;;; yasnippet-popup.el --- YAsnippet prompt using popup.el

;; Copyright (C) 2014 Thomas Frössman

;; Author: Thomas Frössman <thomasf@jossystem.se>
;; Version: 0.1
;; Package-Requires: ((s "1.9.0") (dash "2.8.0") (popup "0.5.0") (yasnippet "0.8.0"))
;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; YAsnippet prompt using popup.el

;;; Code:

(require 'yasnippet)
(require 'popup)
(require 'dash)
(require 's)



(defvar yasnippet-popup-auto-install nil
  "Auto install yasnippet-popup as the default yasnippet prompt.
This must be set before loading this package.")

;; TODO eval-after-load bla bla


;;;###autoload
(defun yasnippet-popup-isearch (prompt choices &optional display-fn)
  "A yasnipppet prompt TODO DOCS"
  (let ((group-max-len 0)
        (key-max-len 0)
        (fmt "")
        (popup-items))

    (mapcar #'(lambda (choice)
                (when (yas--template-p choice)
                  (setq group-max-len (max group-max-len
                                           (+ (length (yas--template-group choice) )
                                              (apply '+ (mapcar 'length (yas--template-group choice))))))
                  (setq key-max-len (max key-max-len (length (yas--template-key choice))))))
            choices)

    (setq fmt (format "%s%%%d.%ds%s%%-%d.%ds│ %%s"
                      (if (> group-max-len 0 ) "" " ")
                      group-max-len group-max-len
                      (if (> group-max-len 0 ) " > " "")
                      key-max-len key-max-len))

    (setq popup-items
          (mapcar
           #'(lambda (choice)
               (popup-make-item
                (if (yas--template-p choice)
                    (format fmt
                            (if (yas--template-group choice)
                                (s-join "/" (yas--template-group choice))
                              "")
                            (if (yas--template-key choice)
                                (yas--template-key choice)
                              "")
                            (if (yas--template-name choice)
                                (yas--template-name choice)
                              ""))
                  (format " %s" choice))
                :value choice))
           choices))

    (popup-menu*
     popup-items
     :prompt prompt
     :max-width 80
     :isearch t)))


(provide 'yasnippet-popup)

;;; yasnippet-popup.el ends here
