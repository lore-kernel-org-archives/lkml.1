Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbYGESfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbYGESfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 14:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYGESfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 14:35:33 -0400
Received: from saeurebad.de ([85.214.36.134]:51311 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYGESfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 14:35:32 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] documentation: update CodingStyle tips for Emacs users v2
References: <87tzf5tu3z.fsf@skyscraper.fehenstaub.lan>
	<20080704134159.4dd9f74e@bike.lwn.net> <878wwg4l6b.fsf@saeurebad.de>
	<20080705083235.4b74fa7e@bike.lwn.net>
Date: Sat, 05 Jul 2008 18:33:55 +0000
In-Reply-To: <20080705083235.4b74fa7e@bike.lwn.net> (Jonathan Corbet's message
	of "Sat, 5 Jul 2008 08:32:35 -0600")
Message-ID: <8763rkrxik.fsf_-_@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jonathan Corbet <corbet@lwn.net> writes:

> On Sat, 05 Jul 2008 11:36:44 +0000
> Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> A heuristics seems overkill as this snippet is not distributed code
>> that needs to be portable but it is just a tip for ones .emacs. 
>
> You're right, it's fine the way it is.

Okay, I fixed the file->filename mistake.  How about the following?

	Hannes

---
From: Johannes Weiner <hannes@saeurebad.de>
Subject: documentation: update CodingStyle tips for Emacs users

Describe a setup that integrates better with Emacs' cc-mode and also
fixes up the alignment of continuation lines to really only use tabs.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Jonathan Corbet <corbet@lwn.net>
---

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 6caa146..1875e50 100644
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
+              (when (and filename
+                         (string-match "~/src/linux-trees" filename))
+                (setq indent-tabs-mode t)
+                (c-set-style "linux")
+                (c-set-offset 'arglist-cont-nonempty
+                              '(c-lineup-gcc-asm-reg
+                                c-lineup-arglist-tabs-only))))))
+
+This will make emacs go better with the kernel coding style for C
+files below ~/src/linux-trees.
 
 But even if you fail in getting emacs to do sane formatting, not
 everything is lost: use "indent".
