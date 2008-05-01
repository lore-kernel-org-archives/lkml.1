Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbYEAEFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbYEAEFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 00:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbYEAEFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 00:05:06 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:43912 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750787AbYEAEFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 00:05:05 -0400
Date: Thu, 1 May 2008 14:04:02 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010404.m41442Ef004838@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: kill warnings in FEC driver
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Siewior <bigeasy@linutronix.de>

linux-2.6-mk68/drivers/net/fec.c: In function 'fec_enet_module_init':
linux-2.6-mk68/drivers/net/fec.c:2627: warning: unused variable 'j'
linux-2.6-mk68/drivers/net/fec.c: At top level:
linux-2.6-mk68/drivers/net/fec.c:2136: warning: 'mii_link_interrupt' defined but not used

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/drivers/net/fec.c linux-2.6.25-uc0/drivers/net/fec.c
--- linux-2.6.25/drivers/net/fec.c	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/drivers/net/fec.c	2008-04-30 13:39:06.000000000 +1000
@@ -67,6 +67,10 @@
 #define	FEC_MAX_PORTS	1
 #endif
 
+#if defined(CONFIG_FADS) || defined(CONFIG_RPXCLASSIC) || defined(CONFIG_M5272)
+#define HAVE_mii_link_interrupt
+#endif
+
 /*
  * Define the fixed address of the FEC hardware.
  */
@@ -1222,7 +1226,7 @@ static phy_info_t const * const phy_info
 };
 
 /* ------------------------------------------------------------------------- */
-#if !defined(CONFIG_M532x)
+#ifdef HAVE_mii_link_interrupt
 #ifdef CONFIG_RPXCLASSIC
 static void
 mii_link_interrupt(void *dev_id);
@@ -2096,6 +2100,7 @@ mii_discover_phy(uint mii_reg, struct ne
 
 /* This interrupt occurs when the PHY detects a link change.
 */
+#ifdef HAVE_mii_link_interrupt
 #ifdef CONFIG_RPXCLASSIC
 static void
 mii_link_interrupt(void *dev_id)
@@ -2118,6 +2123,7 @@ mii_link_interrupt(int irq, void * dev_i
 
 	return IRQ_HANDLED;
 }
+#endif
 
 static int
 fec_enet_open(struct net_device *dev)
@@ -2596,7 +2602,7 @@ fec_stop(struct net_device *dev)
 static int __init fec_enet_module_init(void)
 {
 	struct net_device *dev;
-	int i, j, err;
+	int i, err;
 	DECLARE_MAC_BUF(mac);
 
 	printk("FEC ENET Version 0.2\n");
