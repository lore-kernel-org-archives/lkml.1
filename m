Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbZLCTxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbZLCTxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbZLCTxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:53:32 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40945 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbZLCTx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:53:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=noxLljXAn+UyX0ECql7UTiZ4dBNkNRNLNP5Y3BZENxcEcLqHxkqC3jRf6pdOoHLm3o
         4jRGcWvHc+xBCCW1rsE3GoPiVTvjoKLSEcNplxlDCNHZoW7UzzV5izRZ5JJxxj1vIlS6
         ExL4K2ND5nWy6xKyvi1zrtN/yNyLy5Jhgl1Ok=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date: Thu, 03 Dec 2009 20:52:42 +0100
Message-Id: <20091203195242.9093.46792.sendpatchset@localhost>
In-Reply-To: <20091203195145.9093.88261.sendpatchset@localhost>
References: <20091203195145.9093.88261.sendpatchset@localhost>
Subject: [PATCH 6/6] sl82c105: remove no longer needed debugging code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] sl82c105: remove no longer needed debugging code

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/sl82c105.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

Index: b/drivers/ide/sl82c105.c
===================================================================
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -24,13 +24,6 @@
 
 #define DRV_NAME "sl82c105"
 
-#undef DEBUG
-
-#ifdef DEBUG
-#define DBG(arg) printk arg
-#else
-#define DBG(fmt,...)
-#endif
 /*
  * SL82C105 PCI config register 0x40 bits.
  */
@@ -104,9 +97,6 @@ static void sl82c105_set_dma_mode(ide_dr
 	unsigned long timings = (unsigned long)ide_get_drivedata(drive);
 	u16 drv_ctrl;
 
- 	DBG(("sl82c105_tune_chipset(drive:%s, speed:%s)\n",
-	     drive->name, ide_xfer_verbose(speed)));
-
 	drv_ctrl = mwdma_timings[speed - XFER_MW_DMA_0];
 
 	/*
@@ -196,8 +186,6 @@ static void sl82c105_dma_start(ide_drive
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int reg 		= 0x44 + drive->dn * 4;
 
-	DBG(("%s(drive:%s)\n", __func__, drive->name));
-
 	pci_write_config_word(dev, reg,
 			      (unsigned long)ide_get_drivedata(drive) >> 16);
 
@@ -209,8 +197,6 @@ static void sl82c105_dma_clear(ide_drive
 {
 	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 
-	DBG(("sl82c105_dma_clear(drive:%s)\n", drive->name));
-
 	sl82c105_reset_host(dev);
 }
 
@@ -218,11 +204,7 @@ static int sl82c105_dma_end(ide_drive_t
 {
 	struct pci_dev *dev	= to_pci_dev(drive->hwif->dev);
 	int reg 		= 0x44 + drive->dn * 4;
-	int ret;
-
-	DBG(("%s(drive:%s)\n", __func__, drive->name));
-
-	ret = ide_dma_end(drive);
+	int ret			= ide_dma_end(drive);
 
 	pci_write_config_word(dev, reg,
 			      (unsigned long)ide_get_drivedata(drive));
@@ -239,8 +221,6 @@ static void sl82c105_resetproc(ide_drive
 	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	u32 val;
 
-	DBG(("sl82c105_resetproc(drive:%s)\n", drive->name));
-
 	pci_read_config_dword(dev, 0x40, &val);
 	val |= (CTRL_P1F16 | CTRL_P0F16);
 	pci_write_config_dword(dev, 0x40, val);
@@ -291,8 +271,6 @@ static int init_chipset_sl82c105(struct
 {
 	u32 val;
 
-	DBG(("init_chipset_sl82c105()\n"));
-
 	pci_read_config_dword(dev, 0x40, &val);
 	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
 	pci_write_config_dword(dev, 0x40, val);
