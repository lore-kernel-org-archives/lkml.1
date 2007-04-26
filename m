Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbXDZXuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbXDZXuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbXDZXuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:50:17 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35858 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755257AbXDZXrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:47:45 -0400
Date: Fri, 27 Apr 2007 01:47:56 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] drivers/mtd/maps/nettel.c: possible cleanups
Message-ID: <20070426234756.GM3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- make 2 needlessly global functions static
- #if 0 the unused nettel_eraseconfig()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 27 Mar 2007

 drivers/mtd/maps/nettel.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- linux-2.6.21-rc4-mm1/drivers/mtd/maps/nettel.c.old	2007-03-26 16:04:25.000000000 +0200
+++ linux-2.6.21-rc4-mm1/drivers/mtd/maps/nettel.c	2007-03-26 16:09:39.000000000 +0200
@@ -158,6 +158,8 @@
 	nettel_reboot_notifier, NULL, 0
 };
 
+#if 0
+
 /*
  *	Erase the configuration file system.
  *	Used to support the software reset button.
@@ -208,18 +210,22 @@
 	return(0);
 }
 
+#endif  /*  0  */
+
 #else
 
+#if 0
 int nettel_eraseconfig(void)
 {
 	return(0);
 }
+#endif  /*  0  */
 
 #endif
 
 /****************************************************************************/
 
-int __init nettel_init(void)
+static int __init nettel_init(void)
 {
 	volatile unsigned long *amdpar;
 	unsigned long amdaddr, maxsize;
@@ -477,7 +483,7 @@
 
 /****************************************************************************/
 
-void __exit nettel_cleanup(void)
+static void __exit nettel_cleanup(void)
 {
 #ifdef CONFIG_MTD_CFI_INTELEXT
 	unregister_reboot_notifier(&nettel_notifier_block);

