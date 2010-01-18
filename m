Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328Ab0ARRV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0ARRV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263Ab0ARRVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:21:22 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:34657 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab0ARRVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:21:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=TVmgas1oktLkZeYQTyI/ooZpivM9n1agG8h/4l0cEdRChe1APnEeiNXhW/Nr/P1wjH
         qLI6RB/hl9hgh7/jqc5FUVpD+J0fyEuQ5Tf3lBgS7zY1hpeMG7JyLCnPphdAUDNaUxxE
         dQ7cbYyuADx194FkDzBTSb1ZUIvIcQkf+16/E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:20:07 +0100
Message-Id: <20100118172007.14623.89634.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 43/64] via82cxxx: add support for vt8261 and future chips
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] via82cxxx: add support for vt8261 and future chips

Based on commit e4d866c for pata_via host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/via82cxxx.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -75,6 +75,7 @@ static struct via_isa_bridge {
 	{ "vx855",	PCI_DEVICE_ID_VIA_VX855,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
 	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
 	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
+	{ "vt8261",	PCI_DEVICE_ID_VIA_8261,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
@@ -97,6 +98,7 @@ static struct via_isa_bridge {
 	{ "vt82c586",	PCI_DEVICE_ID_VIA_82C586_0, 0x00, 0x0f,      0x00, VIA_SET_FIFO },
 	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f,      0x00, VIA_SET_FIFO | VIA_NO_UNMASK },
 	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f,      0x00, VIA_SET_FIFO | VIA_NO_UNMASK | VIA_BAD_ID },
+	{ "vtxxxx",	PCI_DEVICE_ID_VIA_ANON,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ NULL }
 };
 
@@ -205,7 +207,8 @@ static struct via_isa_bridge *via_config
 {
 	struct via_isa_bridge *via_config;
 
-	for (via_config = via_isa_bridges; via_config->id; via_config++)
+	for (via_config = via_isa_bridges;
+	     via_config->id != PCI_DEVICE_ID_VIA_ANON; via_config++)
 		if ((*isa = pci_get_device(PCI_VENDOR_ID_VIA +
 			!!(via_config->flags & VIA_BAD_ID),
 			via_config->id, NULL))) {
@@ -467,11 +470,6 @@ static int __devinit via_init_one(struct
 	 * Find the ISA bridge and check we know what it is.
 	 */
 	via_config = via_config_find(&isa);
-	if (!via_config->id) {
-		printk(KERN_WARNING DRV_NAME " %s: unknown chipset, skipping\n",
-			pci_name(dev));
-		return -ENODEV;
-	}
 
 	/*
 	 * Print the boot message.
