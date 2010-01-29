Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370Ab0A2QRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0A2QRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369Ab0A2QGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:06:10 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab0A2QFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:05:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jw1gtcWdSRZGVrCMxFwnyUI7VE/MxfEKhl2f3xCWGsoqnu12YLJuN/szSXuuYvSaAc
         o5cTz2QbJC33awqdSv3ngtr8t8PRNf4H4bZRA1/7ugt5KJwlmnHSoPv6Stww+0S32hpc
         kpOKCf0wrb6d2KGhZjMN7uky4f0VQmoquNBfI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:05:44 +0100
Message-Id: <20100129160544.21495.34179.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 24/68] ide: change ->cable_detect method return type to 'int'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: change ->cable_detect method return type to 'int'

Change ->cable_detect method return type to match ->cable_detect method
used in struct ata_port_operations.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/aec62xx.c      |    2 +-
 drivers/ide/alim15x3.c     |    2 +-
 drivers/ide/amd74xx.c      |    2 +-
 drivers/ide/atiixp.c       |    2 +-
 drivers/ide/cmd64x.c       |    2 +-
 drivers/ide/cs5535.c       |    2 +-
 drivers/ide/cs5536.c       |    2 +-
 drivers/ide/hpt366.c       |    2 +-
 drivers/ide/it8213.c       |    2 +-
 drivers/ide/it821x.c       |    2 +-
 drivers/ide/jmicron.c      |    2 +-
 drivers/ide/palm_bk3710.c  |    2 +-
 drivers/ide/pdc202xx_new.c |    2 +-
 drivers/ide/pdc202xx_old.c |    2 +-
 drivers/ide/piix.c         |    2 +-
 drivers/ide/pmac.c         |    2 +-
 drivers/ide/scc_pata.c     |    2 +-
 drivers/ide/serverworks.c  |    2 +-
 drivers/ide/siimage.c      |    2 +-
 drivers/ide/sis5513.c      |    2 +-
 drivers/ide/slc90e66.c     |    2 +-
 drivers/ide/tc86c001.c     |    2 +-
 drivers/ide/tx4939ide.c    |    2 +-
 drivers/ide/via82cxxx.c    |    2 +-
 include/linux/ide.h        |    2 +-
 25 files changed, 25 insertions(+), 25 deletions(-)

Index: b/drivers/ide/aec62xx.c
===================================================================
--- a/drivers/ide/aec62xx.c
+++ b/drivers/ide/aec62xx.c
@@ -160,7 +160,7 @@ static int init_chipset_aec62xx(struct p
 	return 0;
 }
 
-static u8 atp86x_cable_detect(ide_hwif_t *hwif)
+static int atp86x_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 ata66 = 0, mask = hwif->channel ? 0x02 : 0x01;
Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -317,7 +317,7 @@ out:
  *	of UDMA66 transfers. It doesn't check the drives.
  */
 
-static u8 ali_cable_detect(ide_hwif_t *hwif)
+static int ali_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 cbl = ATA_CBL_PATA40, tmpbyte;
Index: b/drivers/ide/amd74xx.c
===================================================================
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -178,7 +178,7 @@ static int init_chipset_amd74xx(struct p
 	return 0;
 }
 
-static u8 amd_cable_detect(ide_hwif_t *hwif)
+static int amd_cable_detect(ide_hwif_t *hwif)
 {
 	if ((amd_80w >> hwif->channel) & 1)
 		return ATA_CBL_PATA80;
Index: b/drivers/ide/atiixp.c
===================================================================
--- a/drivers/ide/atiixp.c
+++ b/drivers/ide/atiixp.c
@@ -120,7 +120,7 @@ static void atiixp_set_dma_mode(ide_hwif
 	spin_unlock_irqrestore(&atiixp_lock, flags);
 }
 
-static u8 atiixp_cable_detect(ide_hwif_t *hwif)
+static int atiixp_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	u8 udma_mode = 0, ch = hwif->channel;
Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -312,7 +312,7 @@ static int init_chipset_cmd64x(struct pc
 	return 0;
 }
 
-static u8 cmd64x_cable_detect(ide_hwif_t *hwif)
+static int cmd64x_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev  *dev	= to_pci_dev(hwif->dev);
 	u8 bmidecsr = 0, mask	= hwif->channel ? 0x02 : 0x01;
Index: b/drivers/ide/cs5535.c
===================================================================
--- a/drivers/ide/cs5535.c
+++ b/drivers/ide/cs5535.c
@@ -153,7 +153,7 @@ static void cs5535_set_pio_mode(ide_hwif
 	cs5535_set_speed(drive, drive->pio_mode);
 }
 
-static u8 cs5535_cable_detect(ide_hwif_t *hwif)
+static int cs5535_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 bit;
Index: b/drivers/ide/cs5536.c
===================================================================
--- a/drivers/ide/cs5536.c
+++ b/drivers/ide/cs5536.c
@@ -110,7 +110,7 @@ static void cs5536_program_dtc(ide_drive
  *	Returns a cable type.
  */
 
-static u8 cs5536_cable_detect(ide_hwif_t *hwif)
+static int cs5536_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	u32 cfg;
Index: b/drivers/ide/hpt366.c
===================================================================
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -1215,7 +1215,7 @@ static int init_chipset_hpt366(struct pc
 	return 0;
 }
 
-static u8 hpt3xx_cable_detect(ide_hwif_t *hwif)
+static int hpt3xx_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
Index: b/drivers/ide/it8213.c
===================================================================
--- a/drivers/ide/it8213.c
+++ b/drivers/ide/it8213.c
@@ -140,7 +140,7 @@ static void it8213_set_dma_mode(ide_hwif
 	}
 }
 
-static u8 it8213_cable_detect(ide_hwif_t *hwif)
+static int it8213_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 reg42h = 0;
Index: b/drivers/ide/it821x.c
===================================================================
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -423,7 +423,7 @@ static void it821x_set_dma_mode(ide_hwif
  *	the needed logic onboard.
  */
 
-static u8 it821x_cable_detect(ide_hwif_t *hwif)
+static int it821x_cable_detect(ide_hwif_t *hwif)
 {
 	/* The reference driver also only does disk side */
 	return ATA_CBL_PATA80;
Index: b/drivers/ide/jmicron.c
===================================================================
--- a/drivers/ide/jmicron.c
+++ b/drivers/ide/jmicron.c
@@ -26,7 +26,7 @@ typedef enum {
  *	Returns the cable type.
  */
 
-static u8 jmicron_cable_detect(ide_hwif_t *hwif)
+static int jmicron_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 
Index: b/drivers/ide/palm_bk3710.c
===================================================================
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -274,7 +274,7 @@ static void __devinit palm_bk3710_chipin
 	palm_bk3710_setpiomode(base, NULL, 1, 600, 0);
 }
 
-static u8 palm_bk3710_cable_detect(ide_hwif_t *hwif)
+static int palm_bk3710_cable_detect(ide_hwif_t *hwif)
 {
 	return ATA_CBL_PATA80;
 }
Index: b/drivers/ide/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pdc202xx_new.c
+++ b/drivers/ide/pdc202xx_new.c
@@ -180,7 +180,7 @@ static void pdcnew_set_pio_mode(ide_hwif
 	}
 }
 
-static u8 pdcnew_cable_detect(ide_hwif_t *hwif)
+static int pdcnew_cable_detect(ide_hwif_t *hwif)
 {
 	if (get_indexed_reg(hwif, 0x0b) & 0x04)
 		return ATA_CBL_PATA40;
Index: b/drivers/ide/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -103,7 +103,7 @@ static int pdc202xx_test_irq(ide_hwif_t
 	}
 }
 
-static u8 pdc2026x_cable_detect(ide_hwif_t *hwif)
+static int pdc2026x_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u16 CIS, mask = hwif->channel ? (1 << 11) : (1 << 10);
Index: b/drivers/ide/piix.c
===================================================================
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -243,7 +243,7 @@ static void ich_clear_irq(ide_drive_t *d
 
 #include "../ata/ata_piix.h"
 
-static u8 piix_cable_detect(ide_hwif_t *hwif)
+static int piix_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	u8 reg54h = 0, mask = hwif->channel ? 0xc0 : 0x30;
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -912,7 +912,7 @@ static int pmac_ide_do_resume(pmac_ide_h
 	return 0;
 }
 
-static u8 pmac_ide_cable_detect(ide_hwif_t *hwif)
+static int pmac_ide_cable_detect(ide_hwif_t *hwif)
 {
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -754,7 +754,7 @@ static int __devinit scc_init_dma(ide_hw
 	return ide_allocate_dma_engine(hwif);
 }
 
-static u8 scc_cable_detect(ide_hwif_t *hwif)
+static int scc_cable_detect(ide_hwif_t *hwif)
 {
 	return ATA_CBL_PATA80;
 }
Index: b/drivers/ide/serverworks.c
===================================================================
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -301,7 +301,7 @@ static u8 ata66_svwks_cobalt(ide_hwif_t
 	return ATA_CBL_PATA40;
 }
 
-static u8 svwks_cable_detect(ide_hwif_t *hwif)
+static int svwks_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
Index: b/drivers/ide/siimage.c
===================================================================
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -667,7 +667,7 @@ static void __devinit init_iops_siimage(
  *	Check for the presence of an ATA66 capable cable on the interface.
  */
 
-static u8 sil_cable_detect(ide_hwif_t *hwif)
+static int sil_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	unsigned long addr	= siimage_selreg(hwif, 0);
Index: b/drivers/ide/sis5513.c
===================================================================
--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -508,7 +508,7 @@ static int init_chipset_sis5513(struct p
 
 #include "../ata/pata_sis.h"
 
-static u8 sis_cable_detect(ide_hwif_t *hwif)
+static int sis_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	u8 ata66 = 0;
Index: b/drivers/ide/slc90e66.c
===================================================================
--- a/drivers/ide/slc90e66.c
+++ b/drivers/ide/slc90e66.c
@@ -115,7 +115,7 @@ static void slc90e66_set_dma_mode(ide_hw
 	}
 }
 
-static u8 slc90e66_cable_detect(ide_hwif_t *hwif)
+static int slc90e66_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 reg47 = 0, mask = hwif->channel ? 0x01 : 0x02;
Index: b/drivers/ide/tc86c001.c
===================================================================
--- a/drivers/ide/tc86c001.c
+++ b/drivers/ide/tc86c001.c
@@ -130,7 +130,7 @@ static void tc86c001_dma_start(ide_drive
 	ide_dma_start(drive);
 }
 
-static u8 tc86c001_cable_detect(ide_hwif_t *hwif)
+static int tc86c001_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long sc_base = pci_resource_start(dev, 5);
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -189,7 +189,7 @@ static void tx4939ide_clear_irq(ide_driv
 	tx4939ide_writew(ctl, base, TX4939IDE_Int_Ctl);
 }
 
-static u8 tx4939ide_cable_detect(ide_hwif_t *hwif)
+static int tx4939ide_cable_detect(ide_hwif_t *hwif)
 {
 	void __iomem *base = TX4939IDE_BASE(hwif);
 
Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -352,7 +352,7 @@ static int init_chipset_via82cxxx(struct
 
 #include "../ata/pata_via.h"
 
-static u8 via82cxxx_cable_detect(ide_hwif_t *hwif)
+static int via82cxxx_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	struct ide_host *host = pci_get_drvdata(pdev);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -644,7 +644,7 @@ struct ide_port_ops {
 	u8	(*mdma_filter)(ide_drive_t *);
 	u8	(*udma_filter)(ide_drive_t *);
 
-	u8	(*cable_detect)(struct hwif_s *);
+	int	(*cable_detect)(struct hwif_s *);
 };
 
 struct ide_dma_ops {
