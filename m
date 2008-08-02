Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbYHBRKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbYHBRKZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 13:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757175AbYHBRJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 13:09:41 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:7593 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbYHBRJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 13:09:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=w0PI7FqXFM7yxSXqoeGaH4nirP/ypaS/c/49ZQNyPr9x/qCgggGUSkt/5ISzxNCkMk
         ADbxB3to38uL6On3Eiosn54IQyZEUS6Cd5v72vf2G8IW8gKBijEJ8qjQz8zd+CAAcoBz
         A1hDNENQGk+I1+xJSkYMSiIyFQupkg/96zSFw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2] ide: ->cable_detect method cannot be marked __devinit
Date: Sat, 2 Aug 2008 19:05:00 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808021905.00269.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have warm-plug support ->cable_detect method no longer
can be be marked __devinit.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/palm_bk3710.c  |    2 +-
 drivers/ide/pci/aec62xx.c      |    2 +-
 drivers/ide/pci/alim15x3.c     |    2 +-
 drivers/ide/pci/amd74xx.c      |    2 +-
 drivers/ide/pci/atiixp.c       |    2 +-
 drivers/ide/pci/cmd64x.c       |    2 +-
 drivers/ide/pci/cs5535.c       |    2 +-
 drivers/ide/pci/hpt366.c       |    2 +-
 drivers/ide/pci/it8213.c       |    2 +-
 drivers/ide/pci/it821x.c       |    2 +-
 drivers/ide/pci/jmicron.c      |    2 +-
 drivers/ide/pci/pdc202xx_new.c |    2 +-
 drivers/ide/pci/pdc202xx_old.c |    2 +-
 drivers/ide/pci/piix.c         |    2 +-
 drivers/ide/pci/scc_pata.c     |    2 +-
 drivers/ide/pci/serverworks.c  |    8 ++++----
 drivers/ide/pci/siimage.c      |    2 +-
 drivers/ide/pci/sis5513.c      |    2 +-
 drivers/ide/pci/slc90e66.c     |    2 +-
 drivers/ide/pci/tc86c001.c     |    2 +-
 drivers/ide/pci/via82cxxx.c    |    2 +-
 21 files changed, 24 insertions(+), 24 deletions(-)

Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -309,7 +309,7 @@ static void __devinit palm_bk3710_chipin
 	palm_bk3710_setpiomode(base, NULL, 1, 600, 0);
 }
 
-static u8 __devinit palm_bk3710_cable_detect(ide_hwif_t *hwif)
+static u8 palm_bk3710_cable_detect(ide_hwif_t *hwif)
 {
 	return ATA_CBL_PATA80;
 }
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -159,7 +159,7 @@ static unsigned int __devinit init_chips
 	return dev->irq;
 }
 
-static u8 __devinit atp86x_cable_detect(ide_hwif_t *hwif)
+static u8 atp86x_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 ata66 = 0, mask = hwif->channel ? 0x02 : 0x01;
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -370,7 +370,7 @@ static int ali_cable_override(struct pci
  *	FIXME: frobs bits that are not defined on newer ALi devicea
  */
 
-static u8 __devinit ali_cable_detect(ide_hwif_t *hwif)
+static u8 ali_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long flags;
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -175,7 +175,7 @@ static unsigned int __devinit init_chips
 	return dev->irq;
 }
 
-static u8 __devinit amd_cable_detect(ide_hwif_t *hwif)
+static u8 amd_cable_detect(ide_hwif_t *hwif)
 {
 	if ((amd_80w >> hwif->channel) & 1)
 		return ATA_CBL_PATA80;
Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -118,7 +118,7 @@ static void atiixp_set_dma_mode(ide_driv
 	spin_unlock_irqrestore(&atiixp_lock, flags);
 }
 
-static u8 __devinit atiixp_cable_detect(ide_hwif_t *hwif)
+static u8 atiixp_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	u8 udma_mode = 0, ch = hwif->channel;
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -353,7 +353,7 @@ static unsigned int __devinit init_chips
 	return 0;
 }
 
-static u8 __devinit cmd64x_cable_detect(ide_hwif_t *hwif)
+static u8 cmd64x_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev  *dev	= to_pci_dev(hwif->dev);
 	u8 bmidecsr = 0, mask	= hwif->channel ? 0x02 : 0x01;
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -153,7 +153,7 @@ static void cs5535_set_pio_mode(ide_driv
 	cs5535_set_speed(drive, XFER_PIO_0 + pio);
 }
 
-static u8 __devinit cs5535_cable_detect(ide_hwif_t *hwif)
+static u8 cs5535_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 bit;
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1213,7 +1213,7 @@ static unsigned int __devinit init_chips
 	return dev->irq;
 }
 
-static u8 __devinit hpt3xx_cable_detect(ide_hwif_t *hwif)
+static u8 hpt3xx_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
Index: b/drivers/ide/pci/it8213.c
===================================================================
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -140,7 +140,7 @@ static void it8213_set_dma_mode(ide_driv
 	}
 }
 
-static u8 __devinit it8213_cable_detect(ide_hwif_t *hwif)
+static u8 it8213_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 reg42h = 0;
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -427,7 +427,7 @@ static void it821x_set_dma_mode(ide_driv
  *	the needed logic onboard.
  */
 
-static u8 __devinit it821x_cable_detect(ide_hwif_t *hwif)
+static u8 it821x_cable_detect(ide_hwif_t *hwif)
 {
 	/* The reference driver also only does disk side */
 	return ATA_CBL_PATA80;
Index: b/drivers/ide/pci/jmicron.c
===================================================================
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -26,7 +26,7 @@ typedef enum {
  *	Returns the cable type.
  */
 
-static u8 __devinit jmicron_cable_detect(ide_hwif_t *hwif)
+static u8 jmicron_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -192,7 +192,7 @@ static void pdcnew_set_pio_mode(ide_driv
 	}
 }
 
-static u8 __devinit pdcnew_cable_detect(ide_hwif_t *hwif)
+static u8 pdcnew_cable_detect(ide_hwif_t *hwif)
 {
 	if (get_indexed_reg(hwif, 0x0b) & 0x04)
 		return ATA_CBL_PATA40;
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -116,7 +116,7 @@ static void pdc202xx_set_pio_mode(ide_dr
 	pdc202xx_set_mode(drive, XFER_PIO_0 + pio);
 }
 
-static u8 __devinit pdc2026x_cable_detect(ide_hwif_t *hwif)
+static u8 pdc2026x_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u16 CIS, mask = hwif->channel ? (1 << 11) : (1 << 10);
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -255,7 +255,7 @@ static const struct ich_laptop ich_lapto
 	{ 0, }
 };
 
-static u8 __devinit piix_cable_detect(ide_hwif_t *hwif)
+static u8 piix_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	const struct ich_laptop *lap = &ich_laptop[0];
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -826,7 +826,7 @@ static void __devinit init_iops_scc(ide_
 	init_mmio_iops_scc(hwif);
 }
 
-static u8 __devinit scc_cable_detect(ide_hwif_t *hwif)
+static u8 scc_cable_detect(ide_hwif_t *hwif)
 {
 	return ATA_CBL_PATA80;
 }
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -273,7 +273,7 @@ static unsigned int __devinit init_chips
 	return dev->irq;
 }
 
-static u8 __devinit ata66_svwks_svwks(ide_hwif_t *hwif)
+static u8 ata66_svwks_svwks(ide_hwif_t *hwif)
 {
 	return ATA_CBL_PATA80;
 }
@@ -285,7 +285,7 @@ static u8 __devinit ata66_svwks_svwks(id
  * Bit 14 clear = primary IDE channel does not have 80-pin cable.
  * Bit 14 set   = primary IDE channel has 80-pin cable.
  */
-static u8 __devinit ata66_svwks_dell(ide_hwif_t *hwif)
+static u8 ata66_svwks_dell(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
@@ -304,7 +304,7 @@ static u8 __devinit ata66_svwks_dell(ide
  *
  * WARNING: this only works on Alpine hardware!
  */
-static u8 __devinit ata66_svwks_cobalt(ide_hwif_t *hwif)
+static u8 ata66_svwks_cobalt(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
@@ -316,7 +316,7 @@ static u8 __devinit ata66_svwks_cobalt(i
 	return ATA_CBL_PATA40;
 }
 
-static u8 __devinit svwks_cable_detect(ide_hwif_t *hwif)
+static u8 svwks_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -680,7 +680,7 @@ static void __devinit init_iops_siimage(
  *	Check for the presence of an ATA66 capable cable on the interface.
  */
 
-static u8 __devinit sil_cable_detect(ide_hwif_t *hwif)
+static u8 sil_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	unsigned long addr	= siimage_selreg(hwif, 0);
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -517,7 +517,7 @@ static const struct sis_laptop sis_lapto
 	{ 0, }
 };
 
-static u8 __devinit sis_cable_detect(ide_hwif_t *hwif)
+static u8 sis_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	const struct sis_laptop *lap = &sis_laptop[0];
Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -115,7 +115,7 @@ static void slc90e66_set_dma_mode(ide_dr
 	}
 }
 
-static u8 __devinit slc90e66_cable_detect(ide_hwif_t *hwif)
+static u8 slc90e66_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 reg47 = 0, mask = hwif->channel ? 0x01 : 0x02;
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -131,7 +131,7 @@ static void tc86c001_dma_start(ide_drive
 	ide_dma_start(drive);
 }
 
-static u8 __devinit tc86c001_cable_detect(ide_hwif_t *hwif)
+static u8 tc86c001_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long sc_base = pci_resource_start(dev, 5);
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -352,7 +352,7 @@ static int via_cable_override(struct pci
 	return 0;
 }
 
-static u8 __devinit via82cxxx_cable_detect(ide_hwif_t *hwif)
+static u8 via82cxxx_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	struct ide_host *host = pci_get_drvdata(pdev);
