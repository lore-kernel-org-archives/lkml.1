Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbXJ2ToW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbXJ2ToW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXJ2TkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:40:14 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53743 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011AbXJ2TkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:40:12 -0400
To: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Message-Id: <784ed61cab877a62421ce5287ecebfa6cbcdc0e4.1193686445.git.jeff@garzik.org>
In-Reply-To: <eb2aa159d7f722c61d637feb287bc0f2f9519b1d.1193686445.git.jeff@garzik.org>
References: <eb2aa159d7f722c61d637feb287bc0f2f9519b1d.1193686445.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: kkeil@suse.de, akpm@linux-foundation.org
Subject: [PATCH 15/16] [ISDN] HiSax diva: ia32 build fixes
Date: Mon, 29 Oct 2007 15:39:17 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/isdn/hisax/diva.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/isdn/hisax/diva.c b/drivers/isdn/hisax/diva.c
index 33aacd0..4fd5440 100644
--- a/drivers/isdn/hisax/diva.c
+++ b/drivers/isdn/hisax/diva.c
@@ -24,7 +24,8 @@
 #include "ipacx.h"
 #include "isdnl1.h"
 #include <linux/pci.h>
-#include <linux/isapnp.h>
+#include <linux/isa.h>
+#include <linux/pnp.h>
 
 static int diva_protocol;		/* 0 == use DEFAULT_PROTO */
 
@@ -1088,10 +1089,10 @@ static int __devinit diva_pnp_setup(struct IsdnCard *card)
 {
 	struct IsdnCardState *cs = card->cs;
 	struct pnp_dev *pnp_d = (void *) card->para[0];
+	int ipid_function = card->para[1];
 	int err;
 
-	printk(KERN_INFO "HiSax: %s detected\n",
-		(char *)ipid->driver_data);
+	printk(KERN_INFO "HiSax: DIVA PNP detected\n");
 	pnp_disable_dev(pnp_d);
 	err = pnp_activate_dev(pnp_d);
 	if (err<0) {
@@ -1109,7 +1110,7 @@ static int __devinit diva_pnp_setup(struct IsdnCard *card)
 	}
 	cs->hw.diva.cfg_reg  = card->para[1];
 	cs->irq = card->para[0];
-	if (ipid->function == ISAPNP_FUNCTION(0xA1)) {
+	if (ipid_function == 0xA1) {
 		cs->subtyp = DIVA_IPAC_ISA;
 		cs->hw.diva.ctrl = 0;
 		cs->hw.diva.isac =
@@ -1145,6 +1146,7 @@ static int __devinit diva_pnp_init_one(struct pnp_dev *pdev,
 	int cardnr;
 
 	icard.para[0] = (unsigned long) pdev;
+	icard.para[1] = dev_id->driver_data;
 	if (!diva_protocol)
 		icard.protocol = DEFAULT_PROTO;
 	else
@@ -1166,12 +1168,12 @@ static void __devexit diva_pnp_remove_one(struct pnp_dev *pdev)
 }
 
 static struct pnp_device_id diva_pnp_table[] = {
-	{ .id = "GDI0051", },
-	{ .id = "GDI0071", },
-	{ .id = "GDI00A1", },
-	{ .id = "EIC0051", },
-	{ .id = "EIC0071", },
-	{ .id = "EIC00A1", },
+	{ .id = "GDI0051", 0 },
+	{ .id = "GDI0071", 0 },
+	{ .id = "GDI00A1", 0xA1 },
+	{ .id = "EIC0051", 0 },
+	{ .id = "EIC0071", 0 },
+	{ .id = "EIC00A1", 0xA1 },
 
 	{ .id = "" }		/* terminate list */
 };
-- 
1.5.2.4

