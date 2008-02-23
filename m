Return-Path: <linux-kernel-owner+w=401wt.eu-S1759608AbYBWOHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbYBWOHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758790AbYBWOF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:05:26 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:17790 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765AbYBWOFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:05:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=FKg/f9e0Sl6wJ3A1lWGz/pnrB8zCvBkAx5shX34cuWzPJrOJFvzX6dGj1ZCxTxMzS9Oy7CNUuqzzS6opEzNtehbl/HofuV92dlQhlpzbjRCfzV7yh+ngd+5K07HJraZiXf9Rwb2G728AHZuqnM6HdU/qlUER95tKbXmFtJtsLLE=
Date: Sat, 23 Feb 2008 15:05:16 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 04/10] IDE: Coding Style fixes to drivers/ide/setup-pci.c
Message-ID: <20080223150516.4a455a45@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/setup-pci.c |   45 ++++++++++++++++++++-------------------------
 1 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 1f2d8f9..631be79 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -27,13 +27,13 @@
  *
  *	We attempt to place the PCI interface into PCI native mode. If
  *	we succeed the BARs are ok and the controller is in PCI mode.
- *	Returns 0 on success or an errno code. 
+ *	Returns 0 on success or an errno code.
  *
  *	FIXME: if we program the interface and then fail to set the BARS
  *	we don't switch it back to legacy mode. Do we actually care ??
  */
- 
-static int ide_setup_pci_baseregs (struct pci_dev *dev, const char *name)
+
+static int ide_setup_pci_baseregs(struct pci_dev *dev, const char *name)
 {
 	u8 progif = 0;
 
@@ -71,7 +71,7 @@ static void ide_pci_clear_simplex(unsigned long dma_base, const char *name)
 		printk(KERN_INFO "%s: simplex device: DMA forced\n", name);
 }
 
-/**
+/*
  *	ide_get_or_set_dma_base		-	setup BMIBA
  *	@d: IDE port info
  *	@hwif: IDE interface
@@ -140,11 +140,10 @@ void ide_setup_pci_noise(struct pci_dev *dev, const struct ide_port_info *d)
 			 " PCI slot %s\n", d->name, dev->vendor, dev->device,
 			 dev->revision, pci_name(dev));
 }
-
 EXPORT_SYMBOL_GPL(ide_setup_pci_noise);
 
 
-/**
+/*
  *	ide_pci_enable	-	do PCI enables
  *	@dev: PCI device
  *	@d: IDE port info
@@ -153,7 +152,7 @@ EXPORT_SYMBOL_GPL(ide_setup_pci_noise);
  *	but if that fails then we only need IO space. The PCI code should
  *	have setup the proper resources for us already for controllers in
  *	legacy mode.
- *	
+ *
  *	Returns zero on success or an error code
  */
 
@@ -212,8 +211,8 @@ static int ide_pci_configure(struct pci_dev *dev, const struct ide_port_info *d)
 	 * Maybe the user deliberately *disabled* the device,
 	 * but we'll eventually ignore it again if no drives respond.
 	 */
-	if (ide_setup_pci_baseregs(dev, d->name) || pci_write_config_word(dev, PCI_COMMAND, pcicmd|PCI_COMMAND_IO)) 
-	{
+	if (ide_setup_pci_baseregs(dev, d->name) || pci_write_config_word(dev,
+					PCI_COMMAND, pcicmd|PCI_COMMAND_IO)) {
 		printk(KERN_INFO "%s: device disabled (BIOS)\n", d->name);
 		return -ENODEV;
 	}
@@ -241,15 +240,15 @@ static int ide_pci_configure(struct pci_dev *dev, const struct ide_port_info *d)
 static int ide_pci_check_iomem(struct pci_dev *dev, const struct ide_port_info *d, int bar)
 {
 	ulong flags = pci_resource_flags(dev, bar);
-	
+
 	/* Unconfigured ? */
 	if (!flags || pci_resource_len(dev, bar) == 0)
 		return 0;
 
-	/* I/O space */		
-	if(flags & PCI_BASE_ADDRESS_IO_MASK)
+	/* I/O space */
+	if (flags & PCI_BASE_ADDRESS_IO_MASK)
 		return 0;
-		
+
 	/* Bad */
 	printk(KERN_ERR "%s: IO baseregs (BIOS) are reported "
 			"as MEM, report to "
@@ -257,7 +256,7 @@ static int ide_pci_check_iomem(struct pci_dev *dev, const struct ide_port_info *
 	return -EINVAL;
 }
 
-/**
+/*
  *	ide_hwif_configure	-	configure an IDE interface
  *	@dev: PCI device holding interface
  *	@d: IDE port info
@@ -284,7 +283,7 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
 		/*  Possibly we should fail if these checks report true */
 		ide_pci_check_iomem(dev, d, 2*port);
 		ide_pci_check_iomem(dev, d, 2*port+1);
- 
+
 		ctl  = pci_resource_start(dev, 2*port+1);
 		base = pci_resource_start(dev, 2*port);
 		if ((ctl && !base) || (base && !ctl)) {
@@ -293,8 +292,7 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
 			return NULL;
 		}
 	}
-	if (!ctl)
-	{
+	if (!ctl) {
 		/* Use default values */
 		ctl = port ? 0x374 : 0x3f4;
 		base = port ? 0x170 : 0x1f0;
@@ -328,7 +326,7 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
-/**
+/*
  *	ide_hwif_setup_dma	-	configure DMA interface
  *	@hwif: IDE interface
  *	@d: IDE port info
@@ -351,9 +349,9 @@ void ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 		unsigned long dma_base = ide_get_or_set_dma_base(d, hwif);
 		if (dma_base && !(pcicmd & PCI_COMMAND_MASTER)) {
 			/*
- 			 * Set up BM-DMA capability
+			 * Set up BM-DMA capability
 			 * (PnP BIOS should have done this)
- 			 */
+			 */
 			pci_set_master(dev);
 			if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd) || !(pcicmd & PCI_COMMAND_MASTER)) {
 				printk(KERN_ERR "%s: %s error updating PCICMD\n",
@@ -375,7 +373,7 @@ void ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 }
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
-/**
+/*
  *	ide_setup_pci_controller	-	set up IDE PCI
  *	@dev: PCI device
  *	@d: IDE port info
@@ -416,7 +414,7 @@ out:
 	return ret;
 }
 
-/**
+/*
  *	ide_pci_setup_ports	-	configure ports/devices on PCI IDE
  *	@dev: PCI device
  *	@d: IDE port info
@@ -458,7 +456,6 @@ void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d, int
 		*(idx + port) = hwif->index;
 	}
 }
-
 EXPORT_SYMBOL_GPL(ide_pci_setup_ports);
 
 /*
@@ -541,7 +538,6 @@ int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
 
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(ide_setup_pci_device);
 
 int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
@@ -565,5 +561,4 @@ int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
 out:
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(ide_setup_pci_devices);
-- 
1.5.4.2.316.gf7a7

