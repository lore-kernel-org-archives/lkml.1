Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbZAZRBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbZAZRBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZAZRB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:01:27 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:59167 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbZAZRBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:01:24 -0500
From: Teemu Likonen <tlikonen@iki.fi>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Dan Carpenter <error27@gmail.com>
Subject: [PATCH v2] Documentation: update CodingStyle tips for Emacs users
Date: Mon, 26 Jan 2009 19:01:19 +0200
Message-Id: <1232989279-7452-1-git-send-email-tlikonen@iki.fi>
X-Mailer: git-send-email 1.6.1.1.223.gc30e5
In-Reply-To: <87skn6t39o.fsf@iki.fi>
References: <87skn6t39o.fsf@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous Emacs tips example the kernel style was made available
for files in the kernel-tree only. This patch updates the tip to add a
separate cc-mode indent style ("linux-tabs-only"). This makes it easy to
switch between different indent styles and also makes the kernel style
easily available for any filetype mode (c++, awk, ...) that is managed
by the Emacs cc-mode.

Signed-off-by: Teemu Likonen <tlikonen@iki.fi>
---
 Documentation/CodingStyle |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 1875e50..7b5762e 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -483,6 +483,16 @@ values.  To do the latter, you can stick the following in your .emacs file:
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
@@ -490,10 +500,7 @@ values.  To do the latter, you can stick the following in your .emacs file:
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
-- 
1.6.1.1.223.gc30e5

