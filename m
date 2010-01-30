Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281Ab0A3Tto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0A3Tto (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213Ab0A3Ttm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:49:42 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:50554 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab0A3Ttk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:49:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=c2tg+0eCm6TmgXZFCD8tx0NnLlFNbAkSlAd+DMhnMqh29l09PODgwh4ScI2aBatEMF
         FfkVK1IjbwzIU8SFWnxel9fU72O1AGfhIc2H+VOGw4jS45aLbsl8ry5x8282eIAlTjJp
         AlG6yHzqsRfN/PB3/YekdA5jhxEcGW+YQpXjw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 30 Jan 2010 20:49:31 +0100
Message-Id: <20100130194931.30779.16562.sendpatchset@localhost>
In-Reply-To: <20100130194918.30779.25485.sendpatchset@localhost>
References: <20100130194918.30779.25485.sendpatchset@localhost>
Subject: [PATCH 2/9] pata_sil680: CodingStyle fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_sil680: CodingStyle fixes

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_sil680.c |   58 ++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

Index: b/drivers/ata/pata_sil680.c
===================================================================
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -81,7 +81,8 @@ static unsigned long sil680_seldev(struc
  *	space for us.
  */
 
-static int sil680_cable_detect(struct ata_port *ap) {
+static int sil680_cable_detect(struct ata_port *ap)
+{
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned long addr = sil680_selreg(ap, 0);
 	u8 ata66;
@@ -175,7 +176,7 @@ static void sil680_set_dmamode(struct at
 	mode &= ~(0x03 << port_shift);
 
 	/* Extract scsc */
-	scsc = (scsc & 0x30) ? 1: 0;
+	scsc = (scsc & 0x30) ? 1 : 0;
 
 	if (adev->dma_mode >= XFER_UDMA_0) {
 		multi = 0x10C1;
@@ -214,7 +215,7 @@ static u8 sil680_init_chip(struct pci_de
 {
 	u8 tmpbyte	= 0;
 
-        /* FIXME: double check */
+	/* FIXME: double check */
 	pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE,
 			      pdev->revision ? 1 : 255);
 
@@ -232,22 +233,22 @@ static u8 sil680_init_chip(struct pci_de
 		*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
 #endif
 
-	switch(tmpbyte & 0x30) {
-		case 0x00:
-			/* 133 clock attempt to force it on */
-			pci_write_config_byte(pdev, 0x8A, tmpbyte|0x10);
-			break;
-		case 0x30:
-			/* if clocking is disabled */
-			/* 133 clock attempt to force it on */
-			pci_write_config_byte(pdev, 0x8A, tmpbyte & ~0x20);
-			break;
-		case 0x10:
-			/* 133 already */
-			break;
-		case 0x20:
-			/* BIOS set PCI x2 clocking */
-			break;
+	switch (tmpbyte & 0x30) {
+	case 0x00:
+		/* 133 clock attempt to force it on */
+		pci_write_config_byte(pdev, 0x8A, tmpbyte|0x10);
+		break;
+	case 0x30:
+		/* if clocking is disabled */
+		/* 133 clock attempt to force it on */
+		pci_write_config_byte(pdev, 0x8A, tmpbyte & ~0x20);
+		break;
+	case 0x10:
+		/* 133 already */
+		break;
+	case 0x20:
+		/* BIOS set PCI x2 clocking */
+		break;
 	}
 
 	pci_read_config_byte(pdev,   0x8A, &tmpbyte);
@@ -265,12 +266,19 @@ static u8 sil680_init_chip(struct pci_de
 	pci_write_config_dword(pdev, 0xB8, 0x43924392);
 	pci_write_config_dword(pdev, 0xBC, 0x40094009);
 
-	switch(tmpbyte & 0x30) {
-		case 0x00: printk(KERN_INFO "sil680: 100MHz clock.\n");break;
-		case 0x10: printk(KERN_INFO "sil680: 133MHz clock.\n");break;
-		case 0x20: printk(KERN_INFO "sil680: Using PCI clock.\n");break;
-		/* This last case is _NOT_ ok */
-		case 0x30: printk(KERN_ERR "sil680: Clock disabled ?\n");
+	switch (tmpbyte & 0x30) {
+	case 0x00:
+		printk(KERN_INFO "sil680: 100MHz clock.\n");
+		break;
+	case 0x10:
+		printk(KERN_INFO "sil680: 133MHz clock.\n");
+		break;
+	case 0x20:
+		printk(KERN_INFO "sil680: Using PCI clock.\n");
+		break;
+	/* This last case is _NOT_ ok */
+	case 0x30:
+		printk(KERN_ERR "sil680: Clock disabled ?\n");
 	}
 	return tmpbyte & 0x30;
 }
