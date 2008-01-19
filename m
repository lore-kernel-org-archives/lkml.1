Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYASWx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYASWx0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 17:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYASWxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 17:53:17 -0500
Received: from mail.davidb.org ([66.93.32.219]:37294 "EHLO mail.davidb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbYASWxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 17:53:16 -0500
From: David Brown <lkml@davidb.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Brown <lkml@davidb.org>
Subject: [PATCH] Update emacs indentation instructions.
Date: Sat, 19 Jan 2008 14:53:12 -0800
Message-Id: <1200783192-24399-1-git-send-email-lkml@davidb.org>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For quite some time now, Emacs has supported multiple coding styles,
including one very close to the Linux style.  Update the Emacs
configuration instructions in the documentation to reflect this.

Signed-off-by: David Brown <lkml@davidb.org>
---
 Documentation/CodingStyle |   39 ++++++++++++++++++---------------------
 1 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index b49b92e..4511b99 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -456,27 +456,24 @@ uses are less than desirable (in fact, they are worse than random
 typing - an infinite number of monkeys typing into GNU emacs would never
 make a good program).
 
-So, you can either get rid of GNU emacs, or change it to use saner
-values.  To do the latter, you can stick the following in your .emacs file:
-
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
+Fortunately, modern versions of GNU emacs support different indentation
+styles.  If you want to use the Linux kernel style for all C code, place
+the following in your .emacs file:
+
+(setq c-default-style "linux")
+
+If you only want to use Linux indenting on Linux source files, you can
+insert something like the following:
+
+(defun my-c-mode-hook ()
+  (c-set-style
+   (if (and (buffer-file-name)
+            (string-match "/usr/src/linux" (buffer-file-name)))
+       "linux"
+     "free-group-style")))
+(add-hook 'c-mode-hook 'my-c-mode-hook)
+
+to your .emacs file if you want to have linux style switched on
 automagically when you edit source files under /usr/src/linux.
 
 But even if you fail in getting emacs to do sane formatting, not
-- 
1.5.3.8

