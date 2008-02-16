Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbYBPUdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbYBPUdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759643AbYBPU3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:29:52 -0500
Received: from havoc.gtf.org ([69.61.125.42]:34417 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758850AbYBPU3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:29:22 -0500
Message-Id: <56236fc8a8de4a5c83bc90a900601bafaa87bb48.1203189978.git.jeff@garzik.org>
In-Reply-To: <167d76873c13943668c7f4443bfa60bb1552ecb2.1203189978.git.jeff@garzik.org>
References: <167d76873c13943668c7f4443bfa60bb1552ecb2.1203189978.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 14:17:18 -0500
Subject: [PATCH 12/14] [ISDN] HiSax avm_pci, niccy: minor PNP fixes and cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/isdn/hisax/avm_pci.c |    9 ++++++---
 drivers/isdn/hisax/niccy.c   |    2 ++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hisax/avm_pci.c b/drivers/isdn/hisax/avm_pci.c
index 69f8389..0b420aa 100644
--- a/drivers/isdn/hisax/avm_pci.c
+++ b/drivers/isdn/hisax/avm_pci.c
@@ -781,8 +781,8 @@ static int __devinit avm_isa_setup(struct IsdnCard *card)
 	struct IsdnCardState *cs = card->cs;
 
 	/* old manual method */
-	cs->hw.avm.cfg_reg = avm_io_base;
-	cs->irq = avm_irq;
+	cs->hw.avm.cfg_reg = card->para[1];
+	cs->irq = card->para[0];
 	cs->subtyp = AVM_FRITZ_PNP;
 
 	return avm_setup_rest(cs);
@@ -793,7 +793,8 @@ static int __devinit avm_isa_init_one(struct device *dev, unsigned int id)
 	struct IsdnCard icard = { ISDN_CTYPE_FRITZPCI, };
 	int cardnr;
 
-	icard.para[0] = (unsigned long) dev;
+	icard.para[0] = avm_irq;
+	icard.para[1] = avm_io_base;
 	if (!avm_protocol)
 		icard.protocol = DEFAULT_PROTO;
 	else
@@ -889,6 +890,8 @@ static struct pnp_device_id avm_pnp_table[] = {
 	{ .id = "" }		/* terminate list */
 };
 
+MODULE_DEVICE_TABLE(pnp, avm_pnp_table);
+
 static struct pnp_driver avm_pnp_driver = {
 	.name		= "avm_pci",
 	.id_table	= avm_pnp_table,
diff --git a/drivers/isdn/hisax/niccy.c b/drivers/isdn/hisax/niccy.c
index ef48515..cbe1432 100644
--- a/drivers/isdn/hisax/niccy.c
+++ b/drivers/isdn/hisax/niccy.c
@@ -397,6 +397,8 @@ static struct pnp_device_id niccy_pnp_table[] = {
 	{ .id = "" }		/* terminate list */
 };
 
+MODULE_DEVICE_TABLE(pnp, niccy_pnp_table);
+
 static struct pnp_driver niccy_pnp_driver = {
 	.name		= "niccy",
 	.id_table	= niccy_pnp_table,
-- 
1.5.3.8

