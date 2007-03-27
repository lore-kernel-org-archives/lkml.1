Return-Path: <linux-kernel-owner+w=401wt.eu-S933888AbXC0BDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbXC0BDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 21:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933895AbXC0BDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 21:03:01 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35468 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933884AbXC0BCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 21:02:38 -0400
Date: Tue, 27 Mar 2007 03:02:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] drivers/mtd/maps/nettel.c: possible cleanups
Message-ID: <20070327010243.GV16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- make 2 needlessly global functions static
- #if 0 the unused nettel_eraseconfig()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

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

