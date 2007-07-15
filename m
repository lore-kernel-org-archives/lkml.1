Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbXGOIym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbXGOIym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 04:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbXGOIyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 04:54:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:25446 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbXGOIyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 04:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZHWZK+afBlJtHoNWWIEVxiE6AdqjP5KkMCMM7NVCwz9W89rT4Sbc3XQ4mUbgsQBU6X95X+oyZOh5L62KnNrJstFKezt9qCPPKkSEfzQtliDna9u0rxLj/mulZWokdf8gBwlpwCuAV6S2Erl+1dU8OIVBwM4seYb7g9VYWFwFhYs=
From: Denis Cheng <crquan@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Denis Cheng <crquan@gmail.com>
Subject: [PATCH 2/2] add static delaration and init_module fixes
Date: Sun, 15 Jul 2007 16:52:51 +0800
Message-Id: <11844896163299-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184489571313-git-send-email-crquan@gmail.com>
References: <1184489571313-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As stated by kernel janitors TODO list:

	Remove unneeded historic code / New API conversions.
	- get rid of init_module / cleanup_module

and with the __init / __exit code section declarations,
the #ifdef MODULE #endif is not needed any more.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/net/wireless/wavelan.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wavelan.c b/drivers/net/wireless/wavelan.c
index 796011b..392c54c 100644
--- a/drivers/net/wireless/wavelan.c
+++ b/drivers/net/wireless/wavelan.c
@@ -4235,13 +4235,12 @@ struct net_device *__init wavelan_probe(int unit)
  * Module entry point: insertion and removal
  */
 
-#ifdef	MODULE
 /*------------------------------------------------------------------*/
 /*
  * Insertion of the module
  * I'm now quite proud of the multi-device support.
  */
-int __init init_module(void)
+static int __init wavelan_init(void)
 {
 	int ret = -EIO;		/* Return error if no cards found */
 	int i;
@@ -4303,7 +4302,7 @@ int __init init_module(void)
 /*
  * Removal of the module
  */
-void cleanup_module(void)
+static void __exit wavelan_exit(void)
 {
 #ifdef DEBUG_MODULE_TRACE
 	printk(KERN_DEBUG "-> cleanup_module()\n");
@@ -4330,7 +4329,9 @@ void cleanup_module(void)
 	printk(KERN_DEBUG "<- cleanup_module()\n");
 #endif
 }
-#endif				/* MODULE */
+
+module_init(wavelan_init);
+module_exit(wavelan_exit);
 MODULE_LICENSE("GPL");
 
 /*
-- 
1.5.2.2

