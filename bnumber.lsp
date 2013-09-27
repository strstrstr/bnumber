;;Lisp bnumber ver. 0.1 
;;Нумерация блоков аттрибутами
;;Нумерация вида "PreffixНомерSuffix"

(vl-load-com);;
(defun c:bnumber (/ ass ats cmd pca dn n)

	(setq adoc (vla-get-ActiveDocument (vlax-get-acad-object))
		cmd (getvar "CMDECHO") pca (getvar "PICKAUTO") n 0
	)
	(setvar "CMDECHO" 0)
	(initget "Number Renumber")
	;;(setq kw (getkword "\n[Number/Renumber]? <N>"))
	(if (null kw) 
		(setq kw "Number"))
	(setq preffix (getstring "\n Preffix: "))
	(setq suffix (getstring "\n Suffix: "))
	(if (= kw "Number") (setvar "PICKAUTO" 0) )
	(setq dn (getint "\n Input start number: <1>"))
	(if (null dn) (setq dn 1))
	(prompt (strcat "\nSelect blocks for " kw "ing: "))
	(ssget )
	(setq ass (vla-get-ActiveSelectionSet adoc))
	(vlax-for sb ass 
		(if (= (vla-get-objectname sb) "AcDbBlockReference")
			(progn
				(setq ats  (vlax-safearray->list (vlax-variant-value (vla-getattributes sb))))
				(vla-put-TextString (car ats)
					(if (= kw "Number") (strcat preffix (itoa (+ n dn)) suffix  ))
				);;vla-put-TextString
				
				(if (= (vla-get-HasAttributes sb) :vlax-true)
      				(foreach attVar (vlax-invoke sb 'GetAttributes)
        				(if (not (= (vla-get-TagString attVar) tag))
          				(vla-put-Rotation attVar 0))))

				(setq n (1+ n))

			);;progn
		);;if
	);;vlax-for
	(setvar "CMDECHO" cmd)
	(setvar "PICKAUTO" pca)
)
