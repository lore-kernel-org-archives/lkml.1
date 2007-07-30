Return-Path: <linux-kernel-owner+w=401wt.eu-S938926AbXG3Ga7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938926AbXG3Ga7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 02:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938700AbXG3G37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 02:29:59 -0400
Received: from rex.snapgear.com ([203.143.235.140]:44888 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S938698AbXG3G35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 02:29:57 -0400
Date: Mon, 30 Jul 2007 16:29:16 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707300629.l6U6TGVn020363@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] clean up reading of ICR register in FEC driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On the MCF5272, there is no need to read the ICR before writing it :
the bit 4n+3 is a write-enable for the bits 4n,4n+1 and 4n+2.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.23-rc1-git2/drivers/net/fec.c linux/drivers/net/fec.c
--- linux-2.6.23-rc1-git2/drivers/net/fec.c	2007-07-26 10:46:14.000000000 +1000
+++ linux/drivers/net/fec.c	2007-07-26 23:09:23.000000000 +1000
@@ -1269,7 +1270,7 @@
 	icrp = (volatile unsigned long *) (MCF_MBAR + MCFSIM_ICR3);
 	*icrp = 0x00000ddd;
 	icrp = (volatile unsigned long *) (MCF_MBAR + MCFSIM_ICR1);
-	*icrp = (*icrp & 0x70777777) | 0x0d000000;
+	*icrp = 0x0d000000;
 }
 
 static void __inline__ fec_set_mii(struct net_device *dev, struct fec_enet_private *fep)
@@ -1331,7 +1332,7 @@
 {
 	volatile unsigned long *icrp;
 	icrp = (volatile unsigned long *) (MCF_MBAR + MCFSIM_ICR1);
-	*icrp = (*icrp & 0x70777777) | 0x08000000;
+	*icrp = 0x08000000;
 }
 
 static void __inline__ fec_phy_ack_intr(void)
@@ -1339,7 +1340,7 @@
 	volatile unsigned long *icrp;
 	/* Acknowledge the interrupt */
 	icrp = (volatile unsigned long *) (MCF_MBAR + MCFSIM_ICR1);
-	*icrp = (*icrp & 0x77777777) | 0x08000000;
+	*icrp = 0x0d000000;
 }
 
 static void __inline__ fec_localhw_setup(void)
