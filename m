Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbYEADrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbYEADrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 23:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbYEADri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 23:47:38 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:36125 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755099AbYEADrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 23:47:36 -0400
Date: Thu, 1 May 2008 13:47:09 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010347.m413l9x4004691@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: remove unused interrupts in FEC driver
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the acquisition of unused interrupt types. We don't need to
register all the TX and RX varients used on some ColdFire FEC hardware. 

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/drivers/net/fec.c linux-2.6.25-uc0/drivers/net/fec.c
--- linux-2.6.25/drivers/net/fec.c	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/drivers/net/fec.c	2008-04-30 13:39:06.000000000 +1000
@@ -1362,18 +1362,8 @@ static void __inline__ fec_request_intrs
 		unsigned short irq;
 	} *idp, id[] = {
 		{ "fec(TXF)", 23 },
-		{ "fec(TXB)", 24 },
-		{ "fec(TXFIFO)", 25 },
-		{ "fec(TXCR)", 26 },
 		{ "fec(RXF)", 27 },
-		{ "fec(RXB)", 28 },
 		{ "fec(MII)", 29 },
-		{ "fec(LC)", 30 },
-		{ "fec(HBERR)", 31 },
-		{ "fec(GRA)", 32 },
-		{ "fec(EBERR)", 33 },
-		{ "fec(BABT)", 34 },
-		{ "fec(BABR)", 35 },
 		{ NULL },
 	};
 
@@ -1533,18 +1523,8 @@ static void __inline__ fec_request_intrs
 		unsigned short irq;
 	} *idp, id[] = {
 		{ "fec(TXF)", 23 },
-		{ "fec(TXB)", 24 },
-		{ "fec(TXFIFO)", 25 },
-		{ "fec(TXCR)", 26 },
 		{ "fec(RXF)", 27 },
-		{ "fec(RXB)", 28 },
 		{ "fec(MII)", 29 },
-		{ "fec(LC)", 30 },
-		{ "fec(HBERR)", 31 },
-		{ "fec(GRA)", 32 },
-		{ "fec(EBERR)", 33 },
-		{ "fec(BABT)", 34 },
-		{ "fec(BABR)", 35 },
 		{ NULL },
 	};
 
@@ -1660,18 +1640,8 @@ static void __inline__ fec_request_intrs
 		unsigned short irq;
 	} *idp, id[] = {
 	    { "fec(TXF)", 36 },
-	    { "fec(TXB)", 37 },
-	    { "fec(TXFIFO)", 38 },
-	    { "fec(TXCR)", 39 },
 	    { "fec(RXF)", 40 },
-	    { "fec(RXB)", 41 },
 	    { "fec(MII)", 42 },
-	    { "fec(LC)", 43 },
-	    { "fec(HBERR)", 44 },
-	    { "fec(GRA)", 45 },
-	    { "fec(EBERR)", 46 },
-	    { "fec(BABT)", 47 },
-	    { "fec(BABR)", 48 },
 	    { NULL },
 	};
 
@@ -2459,8 +2429,7 @@ int __init fec_enet_init(struct net_devi
 
 	/* Clear and enable interrupts */
 	fecp->fec_ievent = 0xffc00000;
-	fecp->fec_imask = (FEC_ENET_TXF | FEC_ENET_TXB |
-		FEC_ENET_RXF | FEC_ENET_RXB | FEC_ENET_MII);
+	fecp->fec_imask = (FEC_ENET_TXF | FEC_ENET_RXF | FEC_ENET_MII);
 
 	/* Queue up command to detect the PHY and initialize the
 	 * remainder of the interface.
@@ -2587,8 +2556,7 @@ fec_restart(struct net_device *dev, int 
 
 	/* Enable interrupts we wish to service.
 	*/
-	fecp->fec_imask = (FEC_ENET_TXF | FEC_ENET_TXB |
-		FEC_ENET_RXF | FEC_ENET_RXB | FEC_ENET_MII);
+	fecp->fec_imask = (FEC_ENET_TXF | FEC_ENET_RXF | FEC_ENET_MII);
 }
 
 static void
