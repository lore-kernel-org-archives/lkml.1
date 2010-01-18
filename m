Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394Ab0ARRWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab0ARRWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389Ab0ARRWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:22:00 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:52207 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab0ARRV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:21:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vv4kjeqs21h7WfKR+dXzPs2sAM7x7eC6tO4d1+vmhGLYe/UDeHjy02p4C6OlP4DedJ
         ENMfjmButgQq2+KnU07zL/WHgmGb8O7k1Xy7WtzAHPPno8gPI2kYM5SH8cPsxaq9DWhP
         yZTKoLT8uYVGZmqDcza1IuZOni/sl6LUJfERA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:20:42 +0100
Message-Id: <20100118172042.14623.5531.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 48/64] ide: change ->set_pio_mode method parameters
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: change ->set_pio_mode method parameters

Change ->set_pio_mode method parameters to match ->set_piomode method
used in struct ata_port_operations.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/aec62xx.c       |    6 +++---
 drivers/ide/ali14xx.c       |    3 ++-
 drivers/ide/alim15x3.c      |    7 +++----
 drivers/ide/amd74xx.c       |    4 ++--
 drivers/ide/at91_ide.c      |    5 +++--
 drivers/ide/atiixp.c        |    7 ++++---
 drivers/ide/au1xxx-ide.c    |    5 ++---
 drivers/ide/cmd640.c        |    3 ++-
 drivers/ide/cmd64x.c        |    4 +++-
 drivers/ide/cs5520.c        |    7 ++++---
 drivers/ide/cs5530.c        |    7 ++++---
 drivers/ide/cs5535.c        |    6 +++---
 drivers/ide/cs5536.c        |    7 ++++---
 drivers/ide/cy82c693.c      |    5 ++---
 drivers/ide/dtc2278.c       |    4 ++--
 drivers/ide/hpt366.c        |    4 ++--
 drivers/ide/ht6560b.c       |    3 ++-
 drivers/ide/ide-devsets.c   |    4 ++--
 drivers/ide/ide-xfer-mode.c |    6 +++---
 drivers/ide/it8172.c        |   10 +++++-----
 drivers/ide/it8213.c        |   14 +++++++-------
 drivers/ide/it821x.c        |    6 +++---
 drivers/ide/jmicron.c       |    2 +-
 drivers/ide/opti621.c       |    6 +++---
 drivers/ide/palm_bk3710.c   |    5 +++--
 drivers/ide/pdc202xx_new.c  |    4 ++--
 drivers/ide/pdc202xx_old.c  |    4 ++--
 drivers/ide/piix.c          |   14 +++++++-------
 drivers/ide/pmac.c          |    5 ++---
 drivers/ide/qd65xx.c        |   10 ++++------
 drivers/ide/sc1200.c        |    4 ++--
 drivers/ide/scc_pata.c      |    6 +++---
 drivers/ide/serverworks.c   |    5 +++--
 drivers/ide/siimage.c       |    6 +++---
 drivers/ide/sis5513.c       |    4 ++--
 drivers/ide/sl82c105.c      |    5 +++--
 drivers/ide/slc90e66.c      |   13 +++++++------
 drivers/ide/tc86c001.c      |    4 ++--
 drivers/ide/triflex.c       |    4 ++--
 drivers/ide/tx4938ide.c     |    5 ++---
 drivers/ide/tx4939ide.c     |    4 ++--
 drivers/ide/umc8672.c       |    5 +++--
 drivers/ide/via82cxxx.c     |    6 +++---
 include/linux/ide.h         |    2 +-
 44 files changed, 129 insertions(+), 121 deletions(-)

Index: b/drivers/ide/aec62xx.c
===================================================================
--- a/drivers/ide/aec62xx.c
+++ b/drivers/ide/aec62xx.c
@@ -134,10 +134,10 @@ static void aec6260_set_mode(ide_drive_t
 	local_irq_restore(flags);
 }
 
-static void aec_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void aec_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	drive->dma_mode = pio + XFER_PIO_0;
-	drive->hwif->port_ops->set_dma_mode(drive, pio + XFER_PIO_0);
+	drive->dma_mode = drive->pio_mode;
+	hwif->port_ops->set_dma_mode(drive, drive->dma_mode);
 }
 
 static int init_chipset_aec62xx(struct pci_dev *dev)
Index: b/drivers/ide/ali14xx.c
===================================================================
--- a/drivers/ide/ali14xx.c
+++ b/drivers/ide/ali14xx.c
@@ -109,13 +109,14 @@ static DEFINE_SPINLOCK(ali14xx_lock);
  * This function computes timing parameters
  * and sets controller registers accordingly.
  */
-static void ali14xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void ali14xx_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	int driveNum;
 	int time1, time2;
 	u8 param1, param2, param3, param4;
 	unsigned long flags;
 	int bus_speed = ide_vlb_clk ? ide_vlb_clk : 50;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 
 	/* calculate timing, according to PIO mode */
Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -63,15 +63,14 @@ static void ali_fifo_control(ide_hwif_t
 
 /**
  *	ali_set_pio_mode	-	set host controller for PIO mode
+ *	@hwif: port
  *	@drive: drive
- *	@pio: PIO mode number
  *
  *	Program the controller for the given PIO mode.
  */
 
-static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void ali_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 	unsigned long T =  1000000 / bus_speed; /* PCI clock based */
@@ -79,7 +78,7 @@ static void ali_set_pio_mode(ide_drive_t
 	u8 unit = drive->dn & 1;
 	struct ide_timing t;
 
-	ide_timing_compute(drive, XFER_PIO_0 + pio, &t, T, 1);
+	ide_timing_compute(drive, drive->pio_mode, &t, T, 1);
 
 	t.setup = clamp_val(t.setup, 1, 8) & 7;
 	t.active = clamp_val(t.active, 1, 8) & 7;
Index: b/drivers/ide/amd74xx.c
===================================================================
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -108,9 +108,9 @@ static void amd_set_drive(ide_drive_t *d
  * amd_set_pio_mode() is a callback from upper layers for PIO-only tuning.
  */
 
-static void amd_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void amd_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	amd_set_drive(drive, XFER_PIO_0 + pio);
+	amd_set_drive(drive, drive->pio_mode);
 }
 
 static void amd7409_cable_detect(struct pci_dev *dev)
Index: b/drivers/ide/at91_ide.c
===================================================================
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -172,11 +172,12 @@ static void at91_ide_output_data(ide_dri
 	leave_16bit(chipselect, mode);
 }
 
-static void at91_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void at91_ide_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	struct ide_timing *timing;
-	u8 chipselect = drive->hwif->select_data;
+	u8 chipselect = hwif->select_data;
 	int use_iordy = 0;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 	pdbg("chipselect %u pio %u\n", chipselect, pio);
 
Index: b/drivers/ide/atiixp.c
===================================================================
--- a/drivers/ide/atiixp.c
+++ b/drivers/ide/atiixp.c
@@ -42,19 +42,20 @@ static DEFINE_SPINLOCK(atiixp_lock);
 
 /**
  *	atiixp_set_pio_mode	-	set host controller for PIO mode
+ *	@hwif: port
  *	@drive: drive
- *	@pio: PIO mode number
  *
  *	Set the interface PIO mode.
  */
 
-static void atiixp_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void atiixp_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long flags;
 	int timing_shift = (drive->dn ^ 1) * 8;
 	u32 pio_timing_data;
 	u16 pio_mode_data;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 	spin_lock_irqsave(&atiixp_lock, flags);
 
Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -99,12 +99,11 @@ static void au1xxx_output_data(ide_drive
 }
 #endif
 
-static void au1xxx_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void au1xxx_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	int mem_sttime = 0, mem_stcfg = au_readl(MEM_STCFG2);
 
-	/* set pio mode! */
-	switch(pio) {
+	switch (drive->pio_mode - XFER_PIO_0) {
 	case 0:
 		mem_sttime = SBC_IDE_TIMING(PIO0);
 
Index: b/drivers/ide/cmd640.c
===================================================================
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -572,9 +572,10 @@ static void cmd640_set_mode(ide_drive_t
 	program_drive_counts(drive, index);
 }
 
-static void cmd640_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void cmd640_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	unsigned int index = 0, cycle_time;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 	u8 b;
 
 	switch (pio) {
Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -153,8 +153,10 @@ static void cmd64x_tune_pio(ide_drive_t
  * Special cases are 8: prefetch off, 9: prefetch on (both never worked)
  */
 
-static void cmd64x_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void cmd64x_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
+
 	/*
 	 * Filter out the prefetch control values
 	 * to prevent PIO5 from being programmed
Index: b/drivers/ide/cs5520.c
===================================================================
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -57,11 +57,11 @@ static struct pio_clocks cs5520_pio_cloc
 	{1, 2, 1}
 };
 
-static void cs5520_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void cs5520_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	int controller = drive->dn > 1 ? 1 : 0;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 	/* 8bit CAT/CRT - 8bit command timing for channel */
 	pci_write_config_byte(pdev, 0x62 + controller, 
@@ -85,7 +85,8 @@ static void cs5520_set_dma_mode(ide_driv
 {
 	printk(KERN_ERR "cs55x0: bad ide timing.\n");
 
-	cs5520_set_pio_mode(drive, 0);
+	drive->pio_mode = XFER_PIO_0 + 0;
+	cs5520_set_pio_mode(drive->hwif, drive);
 }
 
 static const struct ide_port_ops cs5520_port_ops = {
Index: b/drivers/ide/cs5530.c
===================================================================
--- a/drivers/ide/cs5530.c
+++ b/drivers/ide/cs5530.c
@@ -41,8 +41,8 @@ static unsigned int cs5530_pio_timings[2
 
 /**
  *	cs5530_set_pio_mode	-	set host controller for PIO mode
+ *	@hwif: port
  *	@drive: drive
- *	@pio: PIO mode number
  *
  *	Handles setting of PIO mode for the chipset.
  *
@@ -50,10 +50,11 @@ static unsigned int cs5530_pio_timings[2
  *	will have valid default PIO timings set up before we get here.
  */
 
-static void cs5530_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void cs5530_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	unsigned long basereg = CS5530_BASEREG(drive->hwif);
+	unsigned long basereg = CS5530_BASEREG(hwif);
 	unsigned int format = (inl(basereg + 4) >> 31) & 1;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 	outl(cs5530_pio_timings[format][pio], basereg + ((drive->dn & 1)<<3));
 }
Index: b/drivers/ide/cs5535.c
===================================================================
--- a/drivers/ide/cs5535.c
+++ b/drivers/ide/cs5535.c
@@ -142,15 +142,15 @@ static void cs5535_set_dma_mode(ide_driv
 
 /**
  *	cs5535_set_pio_mode	-	set host controller for PIO mode
+ *	@hwif: port
  *	@drive: drive
- *	@pio: PIO mode number
  *
  *	A callback from the upper layers for PIO-only tuning.
  */
 
-static void cs5535_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void cs5535_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	cs5535_set_speed(drive, XFER_PIO_0 + pio);
+	cs5535_set_speed(drive, drive->pio_mode);
 }
 
 static u8 cs5535_cable_detect(ide_hwif_t *hwif)
Index: b/drivers/ide/cs5536.c
===================================================================
--- a/drivers/ide/cs5536.c
+++ b/drivers/ide/cs5536.c
@@ -125,11 +125,11 @@ static u8 cs5536_cable_detect(ide_hwif_t
 
 /**
  *	cs5536_set_pio_mode		-	PIO timing setup
+ *	@hwif: ATA port
  *	@drive: ATA device
- *	@pio: PIO mode number
  */
 
-static void cs5536_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void cs5536_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	static const u8 drv_timings[5] = {
 		0x98, 0x55, 0x32, 0x21, 0x20,
@@ -143,11 +143,12 @@ static void cs5536_set_pio_mode(ide_driv
 		0x99, 0x92, 0x90, 0x22, 0x20,
 	};
 
-	struct pci_dev *pdev = to_pci_dev(drive->hwif->dev);
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	ide_drive_t *pair = ide_get_pair_dev(drive);
 	int cshift = (drive->dn & 1) ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
 	unsigned long timings = (unsigned long)ide_get_drivedata(drive);
 	u32 cast;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 	u8 cmd_pio = pio;
 
 	if (pair)
Index: b/drivers/ide/cy82c693.c
===================================================================
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -79,9 +79,8 @@ static void cy82c693_set_dma_mode(ide_dr
 	outb(data, CY82_DATA_PORT);
 }
 
-static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void cy82c693_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 	const unsigned long T = 1000000 / bus_speed;
@@ -89,7 +88,7 @@ static void cy82c693_set_pio_mode(ide_dr
 	struct ide_timing t;
 	u8 time_16, time_8;
 
-	ide_timing_compute(drive, XFER_PIO_0 + pio, &t, T, 1);
+	ide_timing_compute(drive, drive->pio_mode, &t, T, 1);
 
 	time_16 = clamp_val(t.recover - 1, 0, 15) |
 		  (clamp_val(t.active - 1, 0, 15) << 4);
Index: b/drivers/ide/dtc2278.c
===================================================================
--- a/drivers/ide/dtc2278.c
+++ b/drivers/ide/dtc2278.c
@@ -68,11 +68,11 @@ static void sub22 (char b, char c)
 
 static DEFINE_SPINLOCK(dtc2278_lock);
 
-static void dtc2278_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void dtc2278_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	unsigned long flags;
 
-	if (pio >= 3) {
+	if (drive->pio_mode >= XFER_PIO_3) {
 		spin_lock_irqsave(&dtc2278_lock, flags);
 		/*
 		 * This enables PIO mode4 (3?) on the first interface
Index: b/drivers/ide/hpt366.c
===================================================================
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -716,9 +716,9 @@ static void hpt3xx_set_mode(ide_drive_t
 	pci_write_config_dword(dev, itr_addr, new_itr);
 }
 
-static void hpt3xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void hpt3xx_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	hpt3xx_set_mode(drive, XFER_PIO_0 + pio);
+	hpt3xx_set_mode(drive, drive->pio_mode);
 }
 
 static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
Index: b/drivers/ide/ht6560b.c
===================================================================
--- a/drivers/ide/ht6560b.c
+++ b/drivers/ide/ht6560b.c
@@ -279,9 +279,10 @@ static void ht_set_prefetch(ide_drive_t
 #endif
 }
 
-static void ht6560b_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void ht6560b_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	unsigned long flags, config;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 	u8 timing;
 	
 	switch (pio) {
Index: b/drivers/ide/ide-devsets.c
===================================================================
--- a/drivers/ide/ide-devsets.c
+++ b/drivers/ide/ide-devsets.c
@@ -112,10 +112,10 @@ static int set_pio_mode(ide_drive_t *dri
 
 			/* take lock for IDE_DFLAG_[NO_]UNMASK/[NO_]IO_32BIT */
 			spin_lock_irqsave(&hwif->lock, flags);
-			port_ops->set_pio_mode(drive, arg);
+			port_ops->set_pio_mode(hwif, drive);
 			spin_unlock_irqrestore(&hwif->lock, flags);
 		} else
-			port_ops->set_pio_mode(drive, arg);
+			port_ops->set_pio_mode(hwif, drive);
 	} else {
 		int keep_dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 
Index: b/drivers/ide/ide-xfer-mode.c
===================================================================
--- a/drivers/ide/ide-xfer-mode.c
+++ b/drivers/ide/ide-xfer-mode.c
@@ -136,7 +136,7 @@ int ide_set_pio_mode(ide_drive_t *drive,
 	 */
 	if (port_ops->set_dma_mode == NULL) {
 		drive->pio_mode = mode;
-		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
+		port_ops->set_pio_mode(hwif, drive);
 		return 0;
 	}
 
@@ -144,11 +144,11 @@ int ide_set_pio_mode(ide_drive_t *drive,
 		if (ide_config_drive_speed(drive, mode))
 			return -1;
 		drive->pio_mode = mode;
-		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
+		port_ops->set_pio_mode(hwif, drive);
 		return 0;
 	} else {
 		drive->pio_mode = mode;
-		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
+		port_ops->set_pio_mode(hwif, drive);
 		return ide_config_drive_speed(drive, mode);
 	}
 }
Index: b/drivers/ide/it8172.c
===================================================================
--- a/drivers/ide/it8172.c
+++ b/drivers/ide/it8172.c
@@ -37,12 +37,12 @@
 
 #define DRV_NAME "IT8172"
 
-static void it8172_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void it8172_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u16 drive_enables;
 	u32 drive_timing;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 	/*
 	 * The highest value of DIOR/DIOW pulse width and recovery time
@@ -98,14 +98,14 @@ static void it8172_set_dma_mode(ide_driv
 		pci_write_config_byte(dev, 0x4a, reg4a | u_speed);
 	} else {
 		const u8 mwdma_to_pio[] = { 0, 3, 4 };
-		u8 pio;
 
 		pci_write_config_byte(dev, 0x48, reg48 & ~u_flag);
 		pci_write_config_byte(dev, 0x4a, reg4a & ~a_speed);
 
-		pio = mwdma_to_pio[speed - XFER_MW_DMA_0];
+		drive->pio_mode =
+			mwdma_to_pio[speed - XFER_MW_DMA_0] + XFER_PIO_0;
 
-		it8172_set_pio_mode(drive, pio);
+		it8172_set_pio_mode(hwif, drive);
 	}
 }
 
Index: b/drivers/ide/it8213.c
===================================================================
--- a/drivers/ide/it8213.c
+++ b/drivers/ide/it8213.c
@@ -17,15 +17,14 @@
 
 /**
  *	it8213_set_pio_mode	-	set host controller for PIO mode
+ *	@hwif: port
  *	@drive: drive
- *	@pio: PIO mode number
  *
  *	Set the interface PIO mode.
  */
 
-static void it8213_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void it8213_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int is_slave		= drive->dn & 1;
 	int master_port		= 0x40;
@@ -35,6 +34,7 @@ static void it8213_set_pio_mode(ide_driv
 	u8 slave_data;
 	static DEFINE_SPINLOCK(tune_lock);
 	int control = 0;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 	static const u8 timings[][2] = {
 					{ 0, 0 },
@@ -120,7 +120,6 @@ static void it8213_set_dma_mode(ide_driv
 			pci_write_config_byte(dev, 0x54, reg54 & ~v_flag);
 	} else {
 		const u8 mwdma_to_pio[] = { 0, 3, 4 };
-		u8 pio;
 
 		if (reg48 & u_flag)
 			pci_write_config_byte(dev, 0x48, reg48 & ~u_flag);
@@ -132,11 +131,12 @@ static void it8213_set_dma_mode(ide_driv
 			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
 
 		if (speed >= XFER_MW_DMA_0)
-			pio = mwdma_to_pio[speed - XFER_MW_DMA_0];
+			drive->pio_mode =
+				mwdma_to_pio[speed - XFER_MW_DMA_0] + XFER_PIO_0;
 		else
-			pio = 2; /* only SWDMA2 is allowed */
+			drive->pio_mode = XFER_PIO_2; /* for SWDMA2 */
 
-		it8213_set_pio_mode(drive, pio);
+		it8213_set_pio_mode(hwif, drive);
 	}
 }
 
Index: b/drivers/ide/it821x.c
===================================================================
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -228,18 +228,18 @@ static void it821x_clock_strategy(ide_dr
 
 /**
  *	it821x_set_pio_mode	-	set host controller for PIO mode
+ *	@hwif: port
  *	@drive: drive
- *	@pio: PIO mode number
  *
  *	Tune the host to the desired PIO mode taking into the consideration
  *	the maximum PIO mode supported by the other device on the cable.
  */
 
-static void it821x_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void it821x_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
 	ide_drive_t *pair = ide_get_pair_dev(drive);
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 	u8 unit = drive->dn & 1, set_pio = pio;
 
 	/* Spec says 89 ref driver uses 88 */
Index: b/drivers/ide/jmicron.c
===================================================================
--- a/drivers/ide/jmicron.c
+++ b/drivers/ide/jmicron.c
@@ -80,7 +80,7 @@ static u8 jmicron_cable_detect(ide_hwif_
 	return ATA_CBL_PATA80;
 }
 
-static void jmicron_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void jmicron_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 }
 
Index: b/drivers/ide/opti621.c
===================================================================
--- a/drivers/ide/opti621.c
+++ b/drivers/ide/opti621.c
@@ -62,12 +62,12 @@ static u8 read_reg(int reg)
 	return ret;
 }
 
-static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void opti621_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	ide_drive_t *pair = ide_get_pair_dev(drive);
 	unsigned long flags;
-	unsigned long mode = XFER_PIO_0 + pio, pair_mode;
+	unsigned long mode = drive->pio_mode, pair_mode;
+	const u8 pio = mode - XFER_PIO_0;
 	u8 tim, misc, addr_pio = pio, clk;
 
 	/* DRDY is default 2 (by OPTi Databook) */
Index: b/drivers/ide/palm_bk3710.c
===================================================================
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -203,12 +203,13 @@ static void palm_bk3710_set_dma_mode(ide
 	}
 }
 
-static void palm_bk3710_set_pio_mode(ide_drive_t *drive, u8 pio)
+static void palm_bk3710_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	unsigned int cycle_time;
 	int is_slave = drive->dn & 1;
 	ide_drive_t *mate;
-	void __iomem *base = (void *)drive->hwif->dma_base;
+	void __iomem *base = (void *)hwif->dma_base;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 	/*
 	 * Obtain the drive PIO data for tuning the Palm Chip registers
Index: b/drivers/ide/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pdc202xx_new.c
+++ b/drivers/ide/pdc202xx_new.c
@@ -167,11 +167,11 @@ static void pdcnew_set_dma_mode(ide_driv
  	}
 }
 
-static void pdcnew_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void pdcnew_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 adj = (drive->dn & 1) ? 0x08 : 0x00;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 	if (max_dma_rate(dev) == 4) {
 		set_indexed_reg(hwif, 0x0c + adj, pio_timings[pio].reg0c);
Index: b/drivers/ide/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -76,9 +76,9 @@ static void pdc202xx_set_mode(ide_drive_
 	}
 }
 
-static void pdc202xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void pdc202xx_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	pdc202xx_set_mode(drive, XFER_PIO_0 + pio);
+	pdc202xx_set_mode(drive, drive->pio_mode);
 }
 
 static int pdc202xx_test_irq(ide_hwif_t *hwif)
Index: b/drivers/ide/piix.c
===================================================================
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -59,15 +59,14 @@ static int no_piix_dma;
 
 /**
  *	piix_set_pio_mode	-	set host controller for PIO mode
+ *	@port: port
  *	@drive: drive
- *	@pio: PIO mode number
  *
  *	Set the interface PIO mode based upon the settings done by AMI BIOS.
  */
 
-static void piix_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void piix_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int is_slave		= drive->dn & 1;
 	int master_port		= hwif->channel ? 0x42 : 0x40;
@@ -77,6 +76,7 @@ static void piix_set_pio_mode(ide_drive_
 	u8 slave_data;
 	static DEFINE_SPINLOCK(tune_lock);
 	int control = 0;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 				     /* ISP  RTC */
 	static const u8 timings[][2]= {
@@ -176,7 +176,6 @@ static void piix_set_dma_mode(ide_drive_
 			pci_write_config_byte(dev, 0x54, reg54 & ~v_flag);
 	} else {
 		const u8 mwdma_to_pio[] = { 0, 3, 4 };
-		u8 pio;
 
 		if (reg48 & u_flag)
 			pci_write_config_byte(dev, 0x48, reg48 & ~u_flag);
@@ -188,11 +187,12 @@ static void piix_set_dma_mode(ide_drive_
 			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
 
 		if (speed >= XFER_MW_DMA_0)
-			pio = mwdma_to_pio[speed - XFER_MW_DMA_0];
+			drive->pio_mode =
+				mwdma_to_pio[speed - XFER_MW_DMA_0] + XFER_PIO_0;
 		else
-			pio = 2; /* only SWDMA2 is allowed */
+			drive->pio_mode = XFER_PIO_2; /* for SWDMA2 */
 
-		piix_set_pio_mode(drive, pio);
+		piix_set_pio_mode(hwif, drive);
 	}
 }
 
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -498,12 +498,11 @@ static void pmac_write_devctl(ide_hwif_t
 /*
  * Old tuning functions (called on hdparm -p), sets up drive PIO timings
  */
-static void
-pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void pmac_ide_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 	struct ide_timing *tim = ide_timing_find_mode(XFER_PIO_0 + pio);
 	u32 *timings, t;
 	unsigned accessTicks, recTicks;
Index: b/drivers/ide/qd65xx.c
===================================================================
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -189,15 +189,13 @@ static void qd_set_timing (ide_drive_t *
 	printk(KERN_DEBUG "%s: %#x\n", drive->name, timing);
 }
 
-static void qd6500_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void qd6500_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	u16 *id = drive->id;
 	int active_time   = 175;
 	int recovery_time = 415; /* worst case values from the dos driver */
 
-	/*
-	 * FIXME: use "pio" value
-	 */
+	/* FIXME: use drive->pio_mode value */
 	if (!qd_find_disk_type(drive, &active_time, &recovery_time) &&
 	    (id[ATA_ID_OLD_PIO_MODES] & 0xff) && (id[ATA_ID_FIELD_VALID] & 2) &&
 	    id[ATA_ID_EIDE_PIO] >= 240) {
@@ -211,9 +209,9 @@ static void qd6500_set_pio_mode(ide_driv
 				active_time, recovery_time));
 }
 
-static void qd6580_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void qd6580_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 	unsigned int cycle_time;
 	int active_time   = 175;
Index: b/drivers/ide/sc1200.c
===================================================================
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -193,10 +193,10 @@ static int sc1200_dma_end(ide_drive_t *d
  * will have valid default PIO timings set up before we get here.
  */
 
-static void sc1200_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void sc1200_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t	*hwif = drive->hwif;
 	int		mode = -1;
+	const u8	pio = drive->pio_mode - XFER_PIO_0;
 
 	/*
 	 * bad abuse of ->set_pio_mode interface
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -199,16 +199,15 @@ scc_ide_outsl(unsigned long port, void *
 
 /**
  *	scc_set_pio_mode	-	set host controller for PIO mode
+ *	@hwif: port
  *	@drive: drive
- *	@pio: PIO mode number
  *
  *	Load the timing settings for this device mode into the
  *	controller.
  */
 
-static void scc_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void scc_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
 	unsigned long ctl_base = ports->ctl;
 	unsigned long cckctrl_port = ctl_base + 0xff0;
@@ -216,6 +215,7 @@ static void scc_set_pio_mode(ide_drive_t
 	unsigned long pioct_port = ctl_base + 0x004;
 	unsigned long reg;
 	int offset;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 	reg = in_be32((void __iomem *)cckctrl_port);
 	if (reg & CCKCTRL_ATACLKOEN) {
Index: b/drivers/ide/serverworks.c
===================================================================
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -106,12 +106,13 @@ static u8 svwks_csb_check (struct pci_de
 	return 0;
 }
 
-static void svwks_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void svwks_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	static const u8 pio_modes[] = { 0x5d, 0x47, 0x34, 0x22, 0x20 };
 	static const u8 drive_pci[] = { 0x41, 0x40, 0x43, 0x42 };
 
-	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 	pci_write_config_byte(dev, drive_pci[drive->dn], pio_modes[pio]);
 
Index: b/drivers/ide/siimage.c
===================================================================
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -229,19 +229,18 @@ static u8 sil_sata_udma_filter(ide_drive
 
 /**
  *	sil_set_pio_mode	-	set host controller for PIO mode
+ *	@hwif: port
  *	@drive: drive
- *	@pio: PIO mode number
  *
  *	Load the timing settings for this device mode into the
  *	controller.
  */
 
-static void sil_set_pio_mode(ide_drive_t *drive, u8 pio)
+static void sil_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	static const u16 tf_speed[]   = { 0x328a, 0x2283, 0x1281, 0x10c3, 0x10c1 };
 	static const u16 data_speed[] = { 0x328a, 0x2283, 0x1104, 0x10c3, 0x10c1 };
 
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	ide_drive_t *pair	= ide_get_pair_dev(drive);
 	u32 speedt		= 0;
@@ -249,6 +248,7 @@ static void sil_set_pio_mode(ide_drive_t
 	unsigned long addr	= siimage_seldev(drive, 0x04);
 	unsigned long tfaddr	= siimage_selreg(hwif,	0x02);
 	unsigned long base	= (unsigned long)hwif->hwif_data;
+	const u8 pio		= drive->pio_mode - XFER_PIO_0;
 	u8 tf_pio		= pio;
 	u8 mmio			= (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 	u8 addr_mask		= hwif->channel ? (mmio ? 0xF4 : 0x84)
Index: b/drivers/ide/sis5513.c
===================================================================
--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -290,10 +290,10 @@ static void config_drive_art_rwp(ide_dri
 		pci_write_config_byte(dev, 0x4b, rw_prefetch);
 }
 
-static void sis_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void sis_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	config_drive_art_rwp(drive);
-	sis_program_timings(drive, XFER_PIO_0 + pio);
+	sis_program_timings(drive, drive->pio_mode);
 }
 
 static void sis_ata133_program_udma_timings(ide_drive_t *drive, const u8 mode)
Index: b/drivers/ide/sl82c105.c
===================================================================
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -63,12 +63,13 @@ static unsigned int get_pio_timings(ide_
 /*
  * Configure the chipset for PIO mode.
  */
-static void sl82c105_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void sl82c105_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	struct pci_dev *dev	= to_pci_dev(drive->hwif->dev);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	unsigned long timings	= (unsigned long)ide_get_drivedata(drive);
 	int reg			= 0x44 + drive->dn * 4;
 	u16 drv_ctrl;
+	const u8 pio		= drive->pio_mode - XFER_PIO_0;
 
 	drv_ctrl = get_pio_timings(drive, pio);
 
Index: b/drivers/ide/slc90e66.c
===================================================================
--- a/drivers/ide/slc90e66.c
+++ b/drivers/ide/slc90e66.c
@@ -18,9 +18,8 @@
 
 static DEFINE_SPINLOCK(slc90e66_lock);
 
-static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void slc90e66_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int is_slave		= drive->dn & 1;
 	int master_port		= hwif->channel ? 0x42 : 0x40;
@@ -29,6 +28,8 @@ static void slc90e66_set_pio_mode(ide_dr
 	u16 master_data;
 	u8 slave_data;
 	int control = 0;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
+
 				     /* ISP  RTC */
 	static const u8 timings[][2] = {
 					{ 0, 0 },
@@ -98,7 +99,6 @@ static void slc90e66_set_dma_mode(ide_dr
 		}
 	} else {
 		const u8 mwdma_to_pio[] = { 0, 3, 4 };
-		u8 pio;
 
 		if (reg48 & u_flag)
 			pci_write_config_word(dev, 0x48, reg48 & ~u_flag);
@@ -106,11 +106,12 @@ static void slc90e66_set_dma_mode(ide_dr
 			pci_write_config_word(dev, 0x4a, reg4a & ~a_speed);
 
 		if (speed >= XFER_MW_DMA_0)
-			pio = mwdma_to_pio[speed - XFER_MW_DMA_0];
+			drive->pio_mode =
+				mwdma_to_pio[speed - XFER_MW_DMA_0] + XFER_PIO_0;
 		else
-			pio = 2; /* only SWDMA2 is allowed */
+			drive->pio_mode = XFER_PIO_2; /* for SWDMA2 */
 
-		slc90e66_set_pio_mode(drive, pio);
+		slc90e66_set_pio_mode(hwif, drive);
 	}
 }
 
Index: b/drivers/ide/tc86c001.c
===================================================================
--- a/drivers/ide/tc86c001.c
+++ b/drivers/ide/tc86c001.c
@@ -41,9 +41,9 @@ static void tc86c001_set_mode(ide_drive_
 	outw(scr, scr_port);
 }
 
-static void tc86c001_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void tc86c001_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	tc86c001_set_mode(drive, XFER_PIO_0 + pio);
+	tc86c001_set_mode(drive, drive->pio_mode);
 }
 
 /*
Index: b/drivers/ide/triflex.c
===================================================================
--- a/drivers/ide/triflex.c
+++ b/drivers/ide/triflex.c
@@ -82,9 +82,9 @@ static void triflex_set_mode(ide_drive_t
 	pci_write_config_dword(dev, channel_offset, triflex_timings);
 }
 
-static void triflex_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void triflex_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	triflex_set_mode(drive, XFER_PIO_0 + pio);
+	triflex_set_mode(drive, drive->pio_mode);
 }
 
 static const struct ide_port_ops triflex_port_ops = {
Index: b/drivers/ide/tx4938ide.c
===================================================================
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -56,11 +56,10 @@ static void tx4938ide_tune_ebusc(unsigne
 		     &tx4938_ebuscptr->cr[ebus_ch]);
 }
 
-static void tx4938ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void tx4938ide_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	struct tx4938ide_platform_info *pdata = hwif->dev->platform_data;
-	u8 safe = pio;
+	u8 safe = drive->pio_mode - XFER_PIO_0;
 	ide_drive_t *pair;
 
 	pair = ide_get_pair_dev(drive);
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -104,11 +104,11 @@ static void tx4939ide_writeb(u8 val, voi
 
 #define TX4939IDE_BASE(hwif)	((void __iomem *)(hwif)->extra_base)
 
-static void tx4939ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void tx4939ide_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	int is_slave = drive->dn;
 	u32 mask, val;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 	u8 safe = pio;
 	ide_drive_t *pair;
 
Index: b/drivers/ide/umc8672.c
===================================================================
--- a/drivers/ide/umc8672.c
+++ b/drivers/ide/umc8672.c
@@ -104,10 +104,11 @@ static void umc_set_speeds(u8 speeds[])
 		speeds[0], speeds[1], speeds[2], speeds[3]);
 }
 
-static void umc_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void umc_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif, *mate = hwif->mate;
+	ide_hwif_t *mate = hwif->mate;
 	unsigned long uninitialized_var(flags);
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 	printk("%s: setting umc8672 to PIO mode%d (speed %d)\n",
 		drive->name, pio, pio_to_umc[pio]);
Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -208,15 +208,15 @@ static void via_set_drive(ide_drive_t *d
 
 /**
  *	via_set_pio_mode	-	set host controller for PIO mode
+ *	@hwif: port
  *	@drive: drive
- *	@pio: PIO mode number
  *
  *	A callback from the upper layers for PIO-only tuning.
  */
 
-static void via_set_pio_mode(ide_drive_t *drive, const u8 pio)
+static void via_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	via_set_drive(drive, XFER_PIO_0 + pio);
+	via_set_drive(drive, drive->pio_mode);
 }
 
 static struct via_isa_bridge *via_config_find(struct pci_dev **isa)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -624,7 +624,7 @@ extern const struct ide_tp_ops default_t
  */
 struct ide_port_ops {
 	void	(*init_dev)(ide_drive_t *);
-	void	(*set_pio_mode)(ide_drive_t *, const u8);
+	void	(*set_pio_mode)(struct hwif_s *, ide_drive_t *);
 	void	(*set_dma_mode)(ide_drive_t *, const u8);
 	int	(*reset_poll)(ide_drive_t *);
 	void	(*pre_reset)(ide_drive_t *);
