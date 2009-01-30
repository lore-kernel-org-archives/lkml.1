Return-Path: <linux-kernel-owner+w=401wt.eu-S1760335AbZA3A3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335AbZA3A3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758198AbZA3A3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:29:11 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:29657 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665AbZA3A3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:29:08 -0500
Date: Thu, 29 Jan 2009 16:28:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, Teemu Likonen <tlikonen@iki.fi>
Subject: [PATCH 2/4] Documentation: update emacs help in CodingStyle
Message-Id: <20090129162816.7e175420.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.498249A3.0115:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Teemu Likonen <tlikonen@iki.fi>
Subject: [PATCH v2] Documentation: update CodingStyle tips for Emacs users

With the previous Emacs tips example the kernel style was made available
for files in the kernel-tree only. This patch updates the tip to add a
separate cc-mode indent style ("linux-tabs-only"). This makes it easy to
switch between different indent styles and also makes the kernel style
easily available for any filetype mode (c++, awk, ...) that is managed
by the Emacs cc-mode.

Signed-off-by: Teemu Likonen <tlikonen@iki.fi>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/CodingStyle |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- linux-next-20090126.orig/Documentation/CodingStyle
+++ linux-next-20090126/Documentation/CodingStyle
@@ -483,6 +483,16 @@ values.  To do the latter, you can stick
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
@@ -490,10 +500,7 @@ values.  To do the latter, you can stick
               (when (and filename
                          (string-match "~/src/linux-trees" filename))
                 (setq indent-tabs-mode t)
-                (c-set-style "linux")
-                (c-set-offset 'arglist-cont-nonempty
-                              '(c-lineup-gcc-asm-reg
-                                c-lineup-arglist-tabs-only))))))
+                (c-set-style "linux-tabs-only")))))
 
 This will make emacs go better with the kernel coding style for C
 files below ~/src/linux-trees.
