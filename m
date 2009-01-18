Return-Path: <linux-kernel-owner+w=401wt.eu-S934157AbZARRSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157AbZARRSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 12:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760946AbZARRSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 12:18:38 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:43097 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760939AbZARRSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 12:18:37 -0500
From: Teemu Likonen <tlikonen@iki.fi>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hannes@saeurebad.de
Subject: [PATCH] Documentation: update CodingStyle tips for Emacs users
Date: Sun, 18 Jan 2009 19:18:35 +0200
Message-Id: <1232299115-8130-1-git-send-email-tlikonen@iki.fi>
X-Mailer: git-send-email 1.6.1.156.gb648d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous Emacs tips example the kernel style was made available
for files in the kernel-tree only. This patch updates the tip to add
separate cc-mode indent style; it makes the kernel style easily
available for any filetype mode that is managed by the Emacs cc-mode.

We also fix the filename regexp in the example: Elisp function
buffer-file-name returns full pathname, not a path relative to user's
home directory. Hence a tilde (~) can't be used to refer to home
directory (as the previous code did).

Signed-off-by: Teemu Likonen <tlikonen@iki.fi>
---
 Documentation/CodingStyle |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 1875e50..2cda242 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -483,20 +483,27 @@ values.  To do the latter, you can stick the following in your .emacs file:
     (* (max steps 1)
        c-basic-offset)))
 
+(add-hook 'c-mode-common-hook
+          (lambda ()
+            ;; Add kernel style
+            (c-add-style
+             "linux-tabs-only"
+             '("linux" (c-offsets-alist
+                        (arglist-cont-nonempty
+                         c-lineup-gcc-asm-reg
+                         c-lineup-arglist-tabs-only))))))
+
 (add-hook 'c-mode-hook
           (lambda ()
             (let ((filename (buffer-file-name)))
               ;; Enable kernel mode for the appropriate files
               (when (and filename
-                         (string-match "~/src/linux-trees" filename))
+                         (string-match "src/linux-trees" filename))
                 (setq indent-tabs-mode t)
-                (c-set-style "linux")
-                (c-set-offset 'arglist-cont-nonempty
-                              '(c-lineup-gcc-asm-reg
-                                c-lineup-arglist-tabs-only))))))
+                (c-set-style "linux-tabs-only")))))
 
 This will make emacs go better with the kernel coding style for C
-files below ~/src/linux-trees.
+files which pathname matches src/linux-trees.
 
 But even if you fail in getting emacs to do sane formatting, not
 everything is lost: use "indent".
-- 
1.6.1.156.gb648d

