Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622Ab0ARR0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab0ARR0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497Ab0ARR03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:26:29 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:52207 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab0ARRWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:22:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vgo2aN2BR16+mBSHDvLlWPIxf+psSDBzvfvhqaIco1zXeXpZLpJyaVKwBjvFz7XJEs
         8YwRBrJVd6zWaV9DUs0EIuGK0VjyUSgFIHy+Jgr1RObwdlRkzqMJLVJJa6RZbzeM4Hl3
         ltbT1GutUGYTBwD7uSxwjEaDh+TLF8npIiiq8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:20:50 +0100
Message-Id: <20100118172050.14623.98373.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 49/64] ide: change ->set_dma_mode method parameters
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: change ->set_dma_mode method parameters

Change ->set_dma_mode method parameters to match ->set_dmamode method
used in struct ata_port_operations.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/aec62xx.c       |   10 +++++-----
 drivers/ide/alim15x3.c      |    6 +++---
 drivers/ide/amd74xx.c       |    7 ++++---
 drivers/ide/atiixp.c        |    7 ++++---
 drivers/ide/au1xxx-ide.c    |    4 ++--
 drivers/ide/cmd64x.c        |    4 ++--
 drivers/ide/cs5520.c        |    4 ++--
 drivers/ide/cs5530.c        |    6 +++---
 drivers/ide/cs5535.c        |    6 +++---
 drivers/ide/cs5536.c        |    7 ++++---
 drivers/ide/cy82c693.c      |    4 ++--
 drivers/ide/hpt366.c        |    7 ++++---
 drivers/ide/icside.c        |    3 ++-
 drivers/ide/ide-xfer-mode.c |    4 ++--
 drivers/ide/it8172.c        |    4 ++--
 drivers/ide/it8213.c        |    6 +++---
 drivers/ide/it821x.c        |    6 ++++--
 drivers/ide/jmicron.c       |    4 ++--
 drivers/ide/palm_bk3710.c   |    5 +++--
 drivers/ide/pdc202xx_new.c  |    4 ++--
 drivers/ide/pdc202xx_old.c  |    7 ++++---
 drivers/ide/piix.c          |    6 +++---
 drivers/ide/pmac.c          |    4 ++--
 drivers/ide/sc1200.c        |    4 ++--
 drivers/ide/scc_pata.c      |    6 +++---
 drivers/ide/serverworks.c   |    4 ++--
 drivers/ide/sgiioc4.c       |    2 +-
 drivers/ide/siimage.c       |    6 +++---
 drivers/ide/sis5513.c       |    4 +++-
 drivers/ide/sl82c105.c      |    3 ++-
 drivers/ide/slc90e66.c      |    4 ++--
 drivers/ide/tc86c001.c      |    7 ++++---
 drivers/ide/triflex.c       |    8 ++++----
 drivers/ide/tx4939ide.c     |    4 ++--
 drivers/ide/via82cxxx.c     |    9 +++++----
 include/linux/ide.h         |    2 +-
 36 files changed, 101 insertions(+), 87 deletions(-)

Index: b/drivers/ide/aec62xx.c
===================================================================
--- a/drivers/ide/aec62xx.c
+++ b/drivers/ide/aec62xx.c
@@ -81,15 +81,15 @@ static u8 pci_bus_clock_list_ultra (u8 s
 	return chipset_table->ultra_settings;
 }
 
-static void aec6210_set_mode(ide_drive_t *drive, const u8 speed)
+static void aec6210_set_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
 	struct chipset_bus_clock_list_entry *bus_clock = host->host_priv;
 	u16 d_conf		= 0;
 	u8 ultra = 0, ultra_conf = 0;
 	u8 tmp0 = 0, tmp1 = 0, tmp2 = 0;
+	const u8 speed = drive->dma_mode;
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -109,15 +109,15 @@ static void aec6210_set_mode(ide_drive_t
 	local_irq_restore(flags);
 }
 
-static void aec6260_set_mode(ide_drive_t *drive, const u8 speed)
+static void aec6260_set_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
 	struct chipset_bus_clock_list_entry *bus_clock = host->host_priv;
 	u8 unit			= drive->dn & 1;
 	u8 tmp1 = 0, tmp2 = 0;
 	u8 ultra = 0, drive_conf = 0, ultra_conf = 0;
+	const u8 speed = drive->dma_mode;
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -137,7 +137,7 @@ static void aec6260_set_mode(ide_drive_t
 static void aec_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	drive->dma_mode = drive->pio_mode;
-	hwif->port_ops->set_dma_mode(drive, drive->dma_mode);
+	hwif->port_ops->set_dma_mode(hwif, drive);
 }
 
 static int init_chipset_aec62xx(struct pci_dev *dev)
Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -132,16 +132,16 @@ static u8 ali_udma_filter(ide_drive_t *d
 
 /**
  *	ali_set_dma_mode	-	set host controller for DMA mode
+ *	@hwif: port
  *	@drive: drive
- *	@speed: DMA mode
  *
  *	Configure the hardware for the desired IDE transfer mode.
  */
 
-static void ali_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void ali_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	const u8 speed		= drive->dma_mode;
 	u8 speed1		= speed;
 	u8 unit			= drive->dn & 1;
 	u8 tmpbyte		= 0x00;
Index: b/drivers/ide/amd74xx.c
===================================================================
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -79,14 +79,14 @@ static void amd_set_speed(struct pci_dev
  * to a desired transfer mode.  It also can be called by upper layers.
  */
 
-static void amd_set_drive(ide_drive_t *drive, const u8 speed)
+static void amd_set_drive(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	ide_drive_t *peer = ide_get_pair_dev(drive);
 	struct ide_timing t, p;
 	int T, UT;
 	u8 udma_mask = hwif->ultra_mask;
+	const u8 speed = drive->dma_mode;
 
 	T = 1000000000 / amd_clock;
 	UT = (udma_mask == ATA_UDMA2) ? T : (T / 2);
@@ -110,7 +110,8 @@ static void amd_set_drive(ide_drive_t *d
 
 static void amd_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	amd_set_drive(drive, drive->pio_mode);
+	drive->dma_mode = drive->pio_mode;
+	amd_set_drive(hwif, drive);
 }
 
 static void amd7409_cable_detect(struct pci_dev *dev)
Index: b/drivers/ide/atiixp.c
===================================================================
--- a/drivers/ide/atiixp.c
+++ b/drivers/ide/atiixp.c
@@ -75,21 +75,22 @@ static void atiixp_set_pio_mode(ide_hwif
 
 /**
  *	atiixp_set_dma_mode	-	set host controller for DMA mode
+ *	@hwif: port
  *	@drive: drive
- *	@speed: DMA mode
  *
  *	Set a ATIIXP host controller to the desired DMA mode.  This involves
  *	programming the right timing data into the PCI configuration space.
  */
 
-static void atiixp_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void atiixp_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long flags;
 	int timing_shift = (drive->dn ^ 1) * 8;
 	u32 tmp32;
 	u16 tmp16;
 	u16 udma_ctl = 0;
+	const u8 speed = drive->dma_mode;
 
 	spin_lock_irqsave(&atiixp_lock, flags);
 
Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -160,11 +160,11 @@ static void au1xxx_set_pio_mode(ide_hwif
 	au_writel(mem_stcfg,MEM_STCFG2);
 }
 
-static void auide_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void auide_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	int mem_sttime = 0, mem_stcfg = au_readl(MEM_STCFG2);
 
-	switch(speed) {
+	switch (drive->dma_mode) {
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 	case XFER_MW_DMA_2:
 		mem_sttime = SBC_IDE_TIMING(MDMA2);
Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -167,12 +167,12 @@ static void cmd64x_set_pio_mode(ide_hwif
 	cmd64x_tune_pio(drive, pio);
 }
 
-static void cmd64x_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void cmd64x_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 unit			= drive->dn & 0x01;
 	u8 regU = 0, pciU	= hwif->channel ? UDIDETCR1 : UDIDETCR0;
+	const u8 speed		= drive->dma_mode;
 
 	pci_read_config_byte(dev, pciU, &regU);
 	regU &= ~(unit ? 0xCA : 0x35);
Index: b/drivers/ide/cs5520.c
===================================================================
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -81,12 +81,12 @@ static void cs5520_set_pio_mode(ide_hwif
 		(cs5520_pio_clocks[pio].assert));
 }
 
-static void cs5520_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void cs5520_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	printk(KERN_ERR "cs55x0: bad ide timing.\n");
 
 	drive->pio_mode = XFER_PIO_0 + 0;
-	cs5520_set_pio_mode(drive->hwif, drive);
+	cs5520_set_pio_mode(hwif, drive);
 }
 
 static const struct ide_port_ops cs5520_port_ops = {
Index: b/drivers/ide/cs5530.c
===================================================================
--- a/drivers/ide/cs5530.c
+++ b/drivers/ide/cs5530.c
@@ -100,12 +100,12 @@ out:
 	return mask;
 }
 
-static void cs5530_set_dma_mode(ide_drive_t *drive, const u8 mode)
+static void cs5530_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	unsigned long basereg;
 	unsigned int reg, timings = 0;
 
-	switch (mode) {
+	switch (drive->dma_mode) {
 		case XFER_UDMA_0:	timings = 0x00921250; break;
 		case XFER_UDMA_1:	timings = 0x00911140; break;
 		case XFER_UDMA_2:	timings = 0x00911030; break;
@@ -113,7 +113,7 @@ static void cs5530_set_dma_mode(ide_driv
 		case XFER_MW_DMA_1:	timings = 0x00012121; break;
 		case XFER_MW_DMA_2:	timings = 0x00002020; break;
 	}
-	basereg = CS5530_BASEREG(drive->hwif);
+	basereg = CS5530_BASEREG(hwif);
 	reg = inl(basereg + 4);			/* get drive0 config register */
 	timings |= reg & 0x80000000;		/* preserve PIO format bit */
 	if ((drive-> dn & 1) == 0) {		/* are we configuring drive0? */
Index: b/drivers/ide/cs5535.c
===================================================================
--- a/drivers/ide/cs5535.c
+++ b/drivers/ide/cs5535.c
@@ -129,15 +129,15 @@ static void cs5535_set_speed(ide_drive_t
 
 /**
  *	cs5535_set_dma_mode	-	set host controller for DMA mode
+ *	@hwif: port
  *	@drive: drive
- *	@speed: DMA mode
  *
  *	Programs the chipset for DMA mode.
  */
 
-static void cs5535_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void cs5535_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	cs5535_set_speed(drive, speed);
+	cs5535_set_speed(drive, drive->dma_mode);
 }
 
 /**
Index: b/drivers/ide/cs5536.c
===================================================================
--- a/drivers/ide/cs5536.c
+++ b/drivers/ide/cs5536.c
@@ -173,11 +173,11 @@ static void cs5536_set_pio_mode(ide_hwif
 
 /**
  *	cs5536_set_dma_mode		-	DMA timing setup
+ *	@hwif: ATA port
  *	@drive: ATA device
- *	@mode: DMA mode
  */
 
-static void cs5536_set_dma_mode(ide_drive_t *drive, const u8 mode)
+static void cs5536_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	static const u8 udma_timings[6] = {
 		0xc2, 0xc1, 0xc0, 0xc4, 0xc5, 0xc6,
@@ -187,10 +187,11 @@ static void cs5536_set_dma_mode(ide_driv
 		0x67, 0x21, 0x20,
 	};
 
-	struct pci_dev *pdev = to_pci_dev(drive->hwif->dev);
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	int dshift = (drive->dn & 1) ? IDE_D1_SHIFT : IDE_D0_SHIFT;
 	unsigned long timings = (unsigned long)ide_get_drivedata(drive);
 	u32 etc;
+	const u8 mode = drive->dma_mode;
 
 	cs5536_read(pdev, ETC, &etc);
 
Index: b/drivers/ide/cy82c693.c
===================================================================
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -52,9 +52,9 @@
  * set DMA mode a specific channel for CY82C693
  */
 
-static void cy82c693_set_dma_mode(ide_drive_t *drive, const u8 mode)
+static void cy82c693_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
+	const u8 mode = drive->dma_mode;
 	u8 single = (mode & 0x10) >> 4, index = 0, data = 0;
 
 	index = hwif->channel ? CY82_INDEX_CHANNEL1 : CY82_INDEX_CHANNEL0;
Index: b/drivers/ide/hpt366.c
===================================================================
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -692,14 +692,14 @@ static u32 get_speed_setting(u8 speed, s
 	return info->timings->clock_table[info->clock][i];
 }
 
-static void hpt3xx_set_mode(ide_drive_t *drive, const u8 speed)
+static void hpt3xx_set_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	struct hpt_timings *t	= info->timings;
 	u8  itr_addr		= 0x40 + (drive->dn * 4);
 	u32 old_itr		= 0;
+	const u8 speed		= drive->dma_mode;
 	u32 new_itr		= get_speed_setting(speed, info);
 	u32 itr_mask		= speed < XFER_MW_DMA_0 ? t->pio_mask :
 				 (speed < XFER_UDMA_0   ? t->dma_mask :
@@ -718,7 +718,8 @@ static void hpt3xx_set_mode(ide_drive_t
 
 static void hpt3xx_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	hpt3xx_set_mode(drive, drive->pio_mode);
+	drive->dma_mode = drive->pio_mode;
+	hpt3xx_set_mode(hwif, drive);
 }
 
 static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -185,10 +185,11 @@ static const expansioncard_ops_t icside_
  *	MW1	80	50	50	150	C
  *	MW2	70	25	25	120	C
  */
-static void icside_set_dma_mode(ide_drive_t *drive, const u8 xfer_mode)
+static void icside_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	unsigned long cycle_time;
 	int use_dma_info = 0;
+	const u8 xfer_mode = drive->dma_mode;
 
 	switch (xfer_mode) {
 	case XFER_MW_DMA_2:
Index: b/drivers/ide/ide-xfer-mode.c
===================================================================
--- a/drivers/ide/ide-xfer-mode.c
+++ b/drivers/ide/ide-xfer-mode.c
@@ -168,11 +168,11 @@ int ide_set_dma_mode(ide_drive_t *drive,
 		if (ide_config_drive_speed(drive, mode))
 			return -1;
 		drive->dma_mode = mode;
-		port_ops->set_dma_mode(drive, mode);
+		port_ops->set_dma_mode(hwif, drive);
 		return 0;
 	} else {
 		drive->dma_mode = mode;
-		port_ops->set_dma_mode(drive, mode);
+		port_ops->set_dma_mode(hwif, drive);
 		return ide_config_drive_speed(drive, mode);
 	}
 }
Index: b/drivers/ide/it8172.c
===================================================================
--- a/drivers/ide/it8172.c
+++ b/drivers/ide/it8172.c
@@ -77,14 +77,14 @@ static void it8172_set_pio_mode(ide_hwif
 	pci_write_config_dword(dev, 0x44, drive_timing);
 }
 
-static void it8172_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void it8172_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int a_speed		= 3 << (drive->dn * 4);
 	int u_flag		= 1 << drive->dn;
 	int u_speed		= 0;
 	u8 reg48, reg4a;
+	const u8 speed		= drive->dma_mode;
 
 	pci_read_config_byte(dev, 0x48, &reg48);
 	pci_read_config_byte(dev, 0x4a, &reg4a);
Index: b/drivers/ide/it8213.c
===================================================================
--- a/drivers/ide/it8213.c
+++ b/drivers/ide/it8213.c
@@ -74,15 +74,14 @@ static void it8213_set_pio_mode(ide_hwif
 
 /**
  *	it8213_set_dma_mode	-	set host controller for DMA mode
+ *	@hwif: port
  *	@drive: drive
- *	@speed: DMA mode
  *
  *	Tune the ITE chipset for the DMA mode.
  */
 
-static void it8213_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void it8213_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 maslave		= 0x40;
 	int a_speed		= 3 << (drive->dn * 4);
@@ -92,6 +91,7 @@ static void it8213_set_dma_mode(ide_driv
 	int u_speed		= 0;
 	u16			reg4042, reg4a;
 	u8			reg48, reg54, reg55;
+	const u8 speed		= drive->dma_mode;
 
 	pci_read_config_word(dev, maslave, &reg4042);
 	pci_read_config_byte(dev, 0x48, &reg48);
Index: b/drivers/ide/it821x.c
===================================================================
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -393,14 +393,16 @@ static int it821x_dma_end(ide_drive_t *d
 
 /**
  *	it821x_set_dma_mode	-	set host controller for DMA mode
+ *	@hwif: port
  *	@drive: drive
- *	@speed: DMA mode
  *
  *	Tune the ITE chipset for the desired DMA mode.
  */
 
-static void it821x_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void it821x_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
+	const u8 speed = drive->dma_mode;
+
 	/*
 	 * MWDMA tuning is really hard because our MWDMA and PIO
 	 * timings are kept in the same place.  We can switch in the
Index: b/drivers/ide/jmicron.c
===================================================================
--- a/drivers/ide/jmicron.c
+++ b/drivers/ide/jmicron.c
@@ -86,13 +86,13 @@ static void jmicron_set_pio_mode(ide_hwi
 
 /**
  *	jmicron_set_dma_mode	-	set host controller for DMA mode
+ *	@hwif: port
  *	@drive: drive
- *	@mode: DMA mode
  *
  *	As the JMicron snoops for timings we don't need to do anything here.
  */
 
-static void jmicron_set_dma_mode(ide_drive_t *drive, const u8 mode)
+static void jmicron_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 }
 
Index: b/drivers/ide/palm_bk3710.c
===================================================================
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -188,10 +188,11 @@ static void palm_bk3710_setpiomode(void
 	writel(val32, base + BK3710_REGRCVR);
 }
 
-static void palm_bk3710_set_dma_mode(ide_drive_t *drive, u8 xferspeed)
+static void palm_bk3710_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	int is_slave = drive->dn & 1;
-	void __iomem *base = (void *)drive->hwif->dma_base;
+	void __iomem *base = (void *)hwif->dma_base;
+	const u8 xferspeed = drive->dma_mode;
 
 	if (xferspeed >= XFER_UDMA_0) {
 		palm_bk3710_setudmamode(base, is_slave,
Index: b/drivers/ide/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pdc202xx_new.c
+++ b/drivers/ide/pdc202xx_new.c
@@ -129,11 +129,11 @@ static struct udma_timing {
 	{ 0x1a, 0x01, 0xcb },	/* UDMA mode 6 */
 };
 
-static void pdcnew_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void pdcnew_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 adj			= (drive->dn & 1) ? 0x08 : 0x00;
+	const u8 speed		= drive->dma_mode;
 
 	/*
 	 * IDE core issues SETFEATURES_XFER to the drive first (thanks to
Index: b/drivers/ide/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -21,11 +21,11 @@
 
 #define DRV_NAME "pdc202xx_old"
 
-static void pdc202xx_set_mode(ide_drive_t *drive, const u8 speed)
+static void pdc202xx_set_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 drive_pci		= 0x60 + (drive->dn << 2);
+	const u8 speed		= drive->dma_mode;
 
 	u8			AP = 0, BP = 0, CP = 0;
 	u8			TA = 0, TB = 0, TC = 0;
@@ -78,7 +78,8 @@ static void pdc202xx_set_mode(ide_drive_
 
 static void pdc202xx_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	pdc202xx_set_mode(drive, drive->pio_mode);
+	drive->dma_mode = drive->pio_mode;
+	pdc202xx_set_mode(hwif, drive);
 }
 
 static int pdc202xx_test_irq(ide_hwif_t *hwif)
Index: b/drivers/ide/piix.c
===================================================================
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -127,16 +127,15 @@ static void piix_set_pio_mode(ide_hwif_t
 
 /**
  *	piix_set_dma_mode	-	set host controller for DMA mode
+ *	@hwif: port
  *	@drive: drive
- *	@speed: DMA mode
  *
  *	Set a PIIX host controller to the desired DMA mode.  This involves
  *	programming the right timing data into the PCI configuration space.
  */
 
-static void piix_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void piix_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 maslave		= hwif->channel ? 0x42 : 0x40;
 	int a_speed		= 3 << (drive->dn * 4);
@@ -147,6 +146,7 @@ static void piix_set_dma_mode(ide_drive_
 	int			sitre;
 	u16			reg4042, reg4a;
 	u8			reg48, reg54, reg55;
+	const u8 speed		= drive->dma_mode;
 
 	pci_read_config_word(dev, maslave, &reg4042);
 	sitre = (reg4042 & 0x4000) ? 1 : 0;
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -779,14 +779,14 @@ set_timings_mdma(ide_drive_t *drive, int
 #endif	
 }
 
-static void pmac_ide_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void pmac_ide_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	int ret = 0;
 	u32 *timings, *timings2, tl[2];
 	u8 unit = drive->dn & 1;
+	const u8 speed = drive->dma_mode;
 
 	timings = &pmif->timings[unit];
 	timings2 = &pmif->timings[unit+2];
Index: b/drivers/ide/sc1200.c
===================================================================
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -122,13 +122,13 @@ out:
 	return mask;
 }
 
-static void sc1200_set_dma_mode(ide_drive_t *drive, const u8 mode)
+static void sc1200_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t		*hwif = drive->hwif;
 	struct pci_dev		*dev = to_pci_dev(hwif->dev);
 	unsigned int		reg, timings;
 	unsigned short		pci_clock;
 	unsigned int		basereg = hwif->channel ? 0x50 : 0x40;
+	const u8		mode = drive->dma_mode;
 
 	static const u32 udma_timing[3][3] = {
 		{ 0x00921250, 0x00911140, 0x00911030 },
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -231,16 +231,15 @@ static void scc_set_pio_mode(ide_hwif_t
 
 /**
  *	scc_set_dma_mode	-	set host controller for DMA mode
+ *	@hwif: port
  *	@drive: drive
- *	@speed: DMA mode
  *
  *	Load the timing settings for this device mode into the
  *	controller.
  */
 
-static void scc_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void scc_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
 	unsigned long ctl_base = ports->ctl;
 	unsigned long cckctrl_port = ctl_base + 0xff0;
@@ -254,6 +253,7 @@ static void scc_set_dma_mode(ide_drive_t
 	int offset, idx;
 	unsigned long reg;
 	unsigned long jcactsel;
+	const u8 speed = drive->dma_mode;
 
 	reg = in_be32((void __iomem *)cckctrl_port);
 	if (reg & CCKCTRL_ATACLKOEN) {
Index: b/drivers/ide/serverworks.c
===================================================================
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -128,14 +128,14 @@ static void svwks_set_pio_mode(ide_hwif_
 	}
 }
 
-static void svwks_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void svwks_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	static const u8 udma_modes[]		= { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05 };
 	static const u8 dma_modes[]		= { 0x77, 0x21, 0x20 };
 	static const u8 drive_pci2[]		= { 0x45, 0x44, 0x47, 0x46 };
 
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	const u8 speed		= drive->dma_mode;
 	u8 unit			= drive->dn & 1;
 
 	u8 ultra_enable	 = 0, ultra_timing = 0, dma_timing = 0;
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -255,7 +255,7 @@ static int sgiioc4_dma_end(ide_drive_t *
 	return dma_stat;
 }
 
-static void sgiioc4_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void sgiioc4_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 }
 
Index: b/drivers/ide/siimage.c
===================================================================
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -289,19 +289,18 @@ static void sil_set_pio_mode(ide_hwif_t
 
 /**
  *	sil_set_dma_mode	-	set host controller for DMA mode
+ *	@hwif: port
  *	@drive: drive
- *	@speed: DMA mode
  *
  *	Tune the SiI chipset for the desired DMA mode.
  */
 
-static void sil_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void sil_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	static const u8 ultra6[] = { 0x0F, 0x0B, 0x07, 0x05, 0x03, 0x02, 0x01 };
 	static const u8 ultra5[] = { 0x0C, 0x07, 0x05, 0x04, 0x02, 0x01 };
 	static const u16 dma[]	 = { 0x2208, 0x10C2, 0x10C1 };
 
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	unsigned long base	= (unsigned long)hwif->hwif_data;
 	u16 ultra = 0, multi	= 0;
@@ -311,6 +310,7 @@ static void sil_set_dma_mode(ide_drive_t
 						: (mmio ? 0xB4 : 0x80);
 	unsigned long ma	= siimage_seldev(drive, 0x08);
 	unsigned long ua	= siimage_seldev(drive, 0x0C);
+	const u8 speed		= drive->dma_mode;
 
 	scsc  = sil_ioread8 (dev, base + (mmio ? 0x4A : 0x8A));
 	mode  = sil_ioread8 (dev, base + addr_mask);
Index: b/drivers/ide/sis5513.c
===================================================================
--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -340,8 +340,10 @@ static void sis_program_udma_timings(ide
 		sis_ata33_program_udma_timings(drive, mode);
 }
 
-static void sis_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void sis_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
+	const u8 speed = drive->dma_mode;
+
 	if (speed >= XFER_UDMA_0)
 		sis_program_udma_timings(drive, speed);
 	else
Index: b/drivers/ide/sl82c105.c
===================================================================
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -92,11 +92,12 @@ static void sl82c105_set_pio_mode(ide_hw
 /*
  * Configure the chipset for DMA mode.
  */
-static void sl82c105_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void sl82c105_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	static u16 mwdma_timings[] = {0x0707, 0x0201, 0x0200};
 	unsigned long timings = (unsigned long)ide_get_drivedata(drive);
 	u16 drv_ctrl;
+	const u8 speed = drive->dma_mode;
 
 	drv_ctrl = mwdma_timings[speed - XFER_MW_DMA_0];
 
Index: b/drivers/ide/slc90e66.c
===================================================================
--- a/drivers/ide/slc90e66.c
+++ b/drivers/ide/slc90e66.c
@@ -72,14 +72,14 @@ static void slc90e66_set_pio_mode(ide_hw
 	spin_unlock_irqrestore(&slc90e66_lock, flags);
 }
 
-static void slc90e66_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void slc90e66_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 maslave		= hwif->channel ? 0x42 : 0x40;
 	int sitre = 0, a_speed	= 7 << (drive->dn * 4);
 	int u_speed = 0, u_flag = 1 << drive->dn;
 	u16			reg4042, reg44, reg48, reg4a;
+	const u8 speed		= drive->dma_mode;
 
 	pci_read_config_word(dev, maslave, &reg4042);
 	sitre = (reg4042 & 0x4000) ? 1 : 0;
Index: b/drivers/ide/tc86c001.c
===================================================================
--- a/drivers/ide/tc86c001.c
+++ b/drivers/ide/tc86c001.c
@@ -13,11 +13,11 @@
 
 #define DRV_NAME "tc86c001"
 
-static void tc86c001_set_mode(ide_drive_t *drive, const u8 speed)
+static void tc86c001_set_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long scr_port	= hwif->config_data + (drive->dn ? 0x02 : 0x00);
 	u16 mode, scr		= inw(scr_port);
+	const u8 speed		= drive->dma_mode;
 
 	switch (speed) {
 	case XFER_UDMA_4:	mode = 0x00c0; break;
@@ -43,7 +43,8 @@ static void tc86c001_set_mode(ide_drive_
 
 static void tc86c001_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	tc86c001_set_mode(drive, drive->pio_mode);
+	drive->dma_mode = drive->pio_mode;
+	tc86c001_set_mode(hwif, drive);
 }
 
 /*
Index: b/drivers/ide/triflex.c
===================================================================
--- a/drivers/ide/triflex.c
+++ b/drivers/ide/triflex.c
@@ -34,9 +34,8 @@
 
 #define DRV_NAME "triflex"
 
-static void triflex_set_mode(ide_drive_t *drive, const u8 speed)
+static void triflex_set_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u32 triflex_timings = 0;
 	u16 timing = 0;
@@ -44,7 +43,7 @@ static void triflex_set_mode(ide_drive_t
 
 	pci_read_config_dword(dev, channel_offset, &triflex_timings);
 
-	switch(speed) {
+	switch (drive->dma_mode) {
 		case XFER_MW_DMA_2:
 			timing = 0x0103; 
 			break;
@@ -84,7 +83,8 @@ static void triflex_set_mode(ide_drive_t
 
 static void triflex_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	triflex_set_mode(drive, drive->pio_mode);
+	drive->dma_mode = drive->pio_mode;
+	triflex_set_mode(hwif, drive);
 }
 
 static const struct ide_port_ops triflex_port_ops = {
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -125,10 +125,10 @@ static void tx4939ide_set_pio_mode(ide_h
 	/* tx4939ide_tf_load_fixup() will set the Sys_Ctl register */
 }
 
-static void tx4939ide_set_dma_mode(ide_drive_t *drive, const u8 mode)
+static void tx4939ide_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	u32 mask, val;
+	const u8 mode = drive->dma_mode;
 
 	/* Update Data Transfer Mode for this drive. */
 	if (mode >= XFER_UDMA_0)
Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -169,22 +169,22 @@ static void via_set_speed(ide_hwif_t *hw
 
 /**
  *	via_set_drive		-	configure transfer mode
+ *	@hwif: port
  *	@drive: Drive to set up
- *	@speed: desired speed
  *
  *	via_set_drive() computes timing values configures the chipset to
  *	a desired transfer mode.  It also can be called by upper layers.
  */
 
-static void via_set_drive(ide_drive_t *drive, const u8 speed)
+static void via_set_drive(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	ide_drive_t *peer = ide_get_pair_dev(drive);
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct ide_host *host = pci_get_drvdata(dev);
 	struct via82cxxx_dev *vdev = host->host_priv;
 	struct ide_timing t, p;
 	unsigned int T, UT;
+	const u8 speed = drive->dma_mode;
 
 	T = 1000000000 / via_clock;
 
@@ -216,7 +216,8 @@ static void via_set_drive(ide_drive_t *d
 
 static void via_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	via_set_drive(drive, drive->pio_mode);
+	drive->dma_mode = drive->pio_mode;
+	via_set_drive(hwif, drive);
 }
 
 static struct via_isa_bridge *via_config_find(struct pci_dev **isa)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -625,7 +625,7 @@ extern const struct ide_tp_ops default_t
 struct ide_port_ops {
 	void	(*init_dev)(ide_drive_t *);
 	void	(*set_pio_mode)(struct hwif_s *, ide_drive_t *);
-	void	(*set_dma_mode)(ide_drive_t *, const u8);
+	void	(*set_dma_mode)(struct hwif_s *, ide_drive_t *);
 	int	(*reset_poll)(ide_drive_t *);
 	void	(*pre_reset)(ide_drive_t *);
 	void	(*resetproc)(ide_drive_t *);
