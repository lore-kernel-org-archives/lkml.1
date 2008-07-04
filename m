Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYGDRx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYGDRx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYGDRxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 13:53:50 -0400
Received: from saeurebad.de ([85.214.36.134]:39227 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbYGDRxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 13:53:49 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] documentation: update CodingStyle tips for Emacs users
CC: linux-kernel@vger.kernel.org
Date: Fri, 04 Jul 2008 19:52:16 +0200
Message-ID: <87tzf5tu3z.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe a setup that integrates better with Emacs' cc-mode and also
fixes up the alignment of continuation lines to really only use tabs.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

Sorry, forgot linux-kernel on first send.

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 6caa146..4148e9f 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -474,25 +474,29 @@ make a good program).
 So, you can either get rid of GNU emacs, or change it to use saner
 values.  To do the latter, you can stick the following in your .emacs file:
 
-(defun linux-c-mode ()
-  "C mode with adjusted defaults for use with the Linux kernel."
-  (interactive)
-  (c-mode)
-  (c-set-style "K&R")
-  (setq tab-width 8)
-  (setq indent-tabs-mode t)
-  (setq c-basic-offset 8))
-
-This will define the M-x linux-c-mode command.  When hacking on a
-module, if you put the string -*- linux-c -*- somewhere on the first
-two lines, this mode will be automatically invoked. Also, you may want
-to add
-
-(setq auto-mode-alist (cons '("/usr/src/linux.*/.*\\.[ch]$" . linux-c-mode)
-			auto-mode-alist))
-
-to your .emacs file if you want to have linux-c-mode switched on
-automagically when you edit source files under /usr/src/linux.
+(defun c-lineup-arglist-tabs-only (ignored)
+  "Line up argument lists by tabs, not spaces"
+  (let* ((anchor (c-langelem-pos c-syntactic-element))
+	 (column (c-langelem-2nd-pos c-syntactic-element))
+	 (offset (- (1+ column) anchor))
+	 (steps (floor offset c-basic-offset)))
+    (* (max steps 1)
+       c-basic-offset)))
+
+(add-hook 'c-mode-hook
+          (lambda ()
+            (let ((filename (buffer-file-name)))
+              ;; Enable kernel mode for the appropriate files
+              (when (and file
+                         (string-match "/usr/src/linux" filename))
+                (setq indent-tabs-mode t)
+                (c-set-style "linux")
+                (c-set-offset 'arglist-cont-nonempty
+                              '(c-lineup-gcc-asm-reg
+                                c-lineup-arglist-tabs-only))))))
+
+This will make emacs go better with the kernel coding style for C
+files in /usr/src/linux.
 
 But even if you fail in getting emacs to do sane formatting, not
 everything is lost: use "indent".
