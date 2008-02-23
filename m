Return-Path: <linux-kernel-owner+w=401wt.eu-S1763972AbYBWUFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763972AbYBWUFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbYBWUEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:04:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:17682 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762906AbYBWUEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:04:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ldjyQLI5XoOl3vxyRn6VwIr9mOC13hmX0R61SYWWSyUG3RvfPK0V+HfccLZQNcPIT3Pl1N7JIhkPIEO+FKN1ggCfazLZqOhZ99NlQY8UBcyP5okuh8I4tNPwCXpPQgE2KiUrnnZkPbPS2nECwTjlCQySu3IAw9YyxV5M6Du8hM4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/4] ide: add struct ide_port_ops
Date: Sat, 23 Feb 2008 21:16:31 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802232116.31811.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move hooks for port/host specific methods from ide_hwif_t to
  'struct ide_port_ops'.

* Add 'const struct ide_port_ops *port_ops' to 'struct ide_port_info'
  and ide_hwif_t.

* Update host drivers and core code accordingly.

While at it:

* Rename ata66_*() cable detect functions to *_cable_detect() to match
  the standard naming. (Suggested by Sergei Shtylyov)

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c       |   13 +++++++-
 drivers/ide/arm/palm_bk3710.c  |   14 ++++-----
 drivers/ide/cris/ide-cris.c    |    8 ++++-
 drivers/ide/ide-dma.c          |    9 +++---
 drivers/ide/ide-io.c           |    5 ++-
 drivers/ide/ide-iops.c         |   28 ++++++++++++------
 drivers/ide/ide-lib.c          |   24 +++++++++-------
 drivers/ide/ide-probe.c        |   20 +++++++++----
 drivers/ide/ide.c              |    3 +-
 drivers/ide/legacy/ali14xx.c   |    7 +++-
 drivers/ide/legacy/dtc2278.c   |    6 +++-
 drivers/ide/legacy/ht6560b.c   |   13 ++++----
 drivers/ide/legacy/ide-cs.c    |    6 +++-
 drivers/ide/legacy/qd65xx.c    |   31 ++++++++++----------
 drivers/ide/legacy/umc8672.c   |    7 +++-
 drivers/ide/mips/au1xxx-ide.c  |   16 ++++++----
 drivers/ide/pci/aec62xx.c      |   34 ++++++++++------------
 drivers/ide/pci/alim15x3.c     |   18 ++++++------
 drivers/ide/pci/amd74xx.c      |   13 +++++---
 drivers/ide/pci/atiixp.c       |   24 ++++------------
 drivers/ide/pci/cmd640.c       |   10 ++----
 drivers/ide/pci/cmd64x.c       |   17 +++++++----
 drivers/ide/pci/cs5520.c       |    9 ++++--
 drivers/ide/pci/cs5530.c       |   15 ++++------
 drivers/ide/pci/cs5535.c       |   22 ++++----------
 drivers/ide/pci/cy82c693.c     |   16 ++++------
 drivers/ide/pci/delkin_cb.c    |    6 +++-
 drivers/ide/pci/hpt34x.c       |   13 ++++----
 drivers/ide/pci/hpt366.c       |   27 ++++++++++--------
 drivers/ide/pci/it8213.c       |   22 ++++----------
 drivers/ide/pci/it821x.c       |   19 ++++++------
 drivers/ide/pci/jmicron.c      |   25 +++++-----------
 drivers/ide/pci/ns87415.c      |    7 +++-
 drivers/ide/pci/opti621.c      |   16 ++++------
 drivers/ide/pci/pdc202xx_new.c |   21 ++++++--------
 drivers/ide/pci/pdc202xx_old.c |   61 +++++++++++++++++++----------------------
 drivers/ide/pci/piix.c         |   13 +++++---
 drivers/ide/pci/sc1200.c       |   11 ++++---
 drivers/ide/pci/scc_pata.c     |   13 +++++---
 drivers/ide/pci/serverworks.c  |   33 +++++++++++-----------
 drivers/ide/pci/sgiioc4.c      |   19 ++++++------
 drivers/ide/pci/siimage.c      |   44 +++++++++++++++++------------
 drivers/ide/pci/sis5513.c      |   30 ++++++++++++--------
 drivers/ide/pci/sl82c105.c     |   11 ++++---
 drivers/ide/pci/slc90e66.c     |   14 ++++-----
 drivers/ide/pci/tc86c001.c     |   12 ++++----
 drivers/ide/pci/triflex.c      |   11 +++----
 drivers/ide/pci/trm290.c       |    7 +++-
 drivers/ide/pci/via82cxxx.c    |   14 ++++-----
 drivers/ide/ppc/mpc8xx.c       |    8 ++++-
 drivers/ide/ppc/pmac.c         |   24 ++++++++++------
 include/linux/ide.h            |   56 ++++++++++++++++++++-----------------
 52 files changed, 492 insertions(+), 433 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -191,6 +191,10 @@ static void icside_maskproc(ide_drive_t 
 	local_irq_restore(flags);
 }
 
+static const struct ide_port_ops icside_v6_no_dma_port_ops = {
+	.maskproc		= icside_maskproc,
+};
+
 #ifdef CONFIG_BLK_DEV_IDEDMA_ICS
 /*
  * SG-DMA support.
@@ -266,6 +270,11 @@ static void icside_set_dma_mode(ide_driv
 		ide_xfer_verbose(xfer_mode), 2000 / drive->drive_data);
 }
 
+static const struct ide_port_ops icside_v6_port_ops = {
+	.set_dma_mode		= icside_set_dma_mode,
+	.maskproc		= icside_maskproc,
+};
+
 static void icside_dma_host_set(ide_drive_t *drive, int on)
 {
 }
@@ -379,7 +388,6 @@ static void icside_dma_init(ide_hwif_t *
 {
 	hwif->dmatable_cpu	= NULL;
 	hwif->dmatable_dma	= 0;
-	hwif->set_dma_mode	= icside_set_dma_mode;
 
 	hwif->dma_host_set	= icside_dma_host_set;
 	hwif->dma_setup		= icside_dma_setup;
@@ -462,6 +470,7 @@ icside_register_v5(struct icside_state *
 }
 
 static const struct ide_port_info icside_v6_port_info __initdata = {
+	.port_ops		= &icside_v6_no_dma_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
 				  IDE_HFLAG_NO_AUTOTUNE,
@@ -526,7 +535,6 @@ icside_register_v6(struct icside_state *
 	state->hwif[0]    = hwif;
 	state->hwif[1]    = mate;
 
-	hwif->maskproc    = icside_maskproc;
 	hwif->hwif_data   = state;
 	hwif->config_data = (unsigned long)ioc_base;
 	hwif->select_data = sel;
@@ -539,6 +547,7 @@ icside_register_v6(struct icside_state *
 	if (ec->dma != NO_DMA && !request_dma(ec->dma, hwif->name)) {
 		icside_dma_init(hwif);
 		icside_dma_init(mate);
+		d.port_ops = &icside_v6_dma_port_ops;
 	} else
 		d.mwdma_mask = d.swdma_mask = 0;
 
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -317,16 +317,14 @@ static u8 __devinit palm_bk3710_cable_de
 	return ATA_CBL_PATA80;
 }
 
-static void __devinit palm_bk3710_init_hwif(ide_hwif_t *hwif)
-{
-	hwif->set_pio_mode = palm_bk3710_set_pio_mode;
-	hwif->set_dma_mode = palm_bk3710_set_dma_mode;
-
-	hwif->cable_detect = palm_bk3710_cable_detect;
-}
+static const struct ide_port_ops palm_bk3710_ports_ops = {
+	.set_pio_mode		= palm_bk3710_set_pio_mode,
+	.set_dma_mode		= palm_bk3710_set_dma_mode,
+	.cable_detect		= palm_bk3710_cable_detect,
+};
 
 static const struct ide_port_info __devinitdata palm_bk3710_port_info = {
-	.init_hwif		= palm_bk3710_init_hwif,
+	.port_ops		= &palm_bk3710_ports_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA, /* hack (no PCI) */
 	.pio_mask		= ATA_PIO4,
 	.udma_mask		= ATA_UDMA4,	/* (input clk 99MHz) */
Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -782,8 +782,14 @@ static void __init cris_setup_ports(hw_r
 	hw->ack_intr = cris_ide_ack_intr;
 }
 
+static const struct ide_port_ops cris_port_ops = {
+	.set_pio_mode		= cris_set_pio_mode,
+	.set_dma_mode		= cris_set_dma_mode,
+};
+
 static const struct ide_port_info cris_port_info __initdata = {
 	.chipset		= ide_etrax100,
+	.port_ops		= &cris_port_ops,
 	.host_flags		= IDE_HFLAG_NO_ATAPI_DMA |
 				  IDE_HFLAG_NO_DMA, /* no SFF-style DMA */
 	.pio_mask		= ATA_PIO4,
@@ -810,8 +816,6 @@ static int __init init_e100_ide(void)
 		ide_init_port_data(hwif, hwif->index);
 		ide_init_port_hw(hwif, &hw);
 		hwif->mmio = 1;
-		hwif->set_pio_mode = &cris_set_pio_mode;
-		hwif->set_dma_mode = &cris_set_dma_mode;
 		hwif->ata_input_data = &cris_ide_input_data;
 		hwif->ata_output_data = &cris_ide_output_data;
 		hwif->atapi_input_bytes = &cris_atapi_input_bytes;
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -574,6 +574,7 @@ static unsigned int ide_get_mode_mask(id
 {
 	struct hd_driveid *id = drive->id;
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
 	unsigned int mask = 0;
 
 	switch(base) {
@@ -581,8 +582,8 @@ static unsigned int ide_get_mode_mask(id
 		if ((id->field_valid & 4) == 0)
 			break;
 
-		if (hwif->udma_filter)
-			mask = hwif->udma_filter(drive);
+		if (port_ops && port_ops->udma_filter)
+			mask = port_ops->udma_filter(drive);
 		else
 			mask = hwif->ultra_mask;
 		mask &= id->dma_ultra;
@@ -598,8 +599,8 @@ static unsigned int ide_get_mode_mask(id
 	case XFER_MW_DMA_0:
 		if ((id->field_valid & 2) == 0)
 			break;
-		if (hwif->mdma_filter)
-			mask = hwif->mdma_filter(drive);
+		if (port_ops && port_ops->mdma_filter)
+			mask = port_ops->mdma_filter(drive);
 		else
 			mask = hwif->mwdma_mask;
 		mask &= id->dma_mword;
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -721,6 +721,7 @@ static ide_startstop_t do_special (ide_d
 #endif
 	if (s->b.set_tune) {
 		ide_hwif_t *hwif = drive->hwif;
+		const struct ide_port_ops *port_ops = hwif->port_ops;
 		u8 req_pio = drive->tune_req;
 
 		s->b.set_tune = 0;
@@ -733,10 +734,10 @@ static ide_startstop_t do_special (ide_d
 				unsigned long flags;
 
 				spin_lock_irqsave(&ide_lock, flags);
-				hwif->set_pio_mode(drive, req_pio);
+				port_ops->set_pio_mode(drive, req_pio);
 				spin_unlock_irqrestore(&ide_lock, flags);
 			} else
-				hwif->set_pio_mode(drive, req_pio);
+				port_ops->set_pio_mode(drive, req_pio);
 		} else {
 			int keep_dma = drive->using_dma;
 
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -159,17 +159,20 @@ EXPORT_SYMBOL(default_hwif_mmiops);
 void SELECT_DRIVE (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
 
-	if (hwif->selectproc)
-		hwif->selectproc(drive);
+	if (port_ops && port_ops->selectproc)
+		port_ops->selectproc(drive);
 
 	hwif->OUTB(drive->select.all, hwif->io_ports[IDE_SELECT_OFFSET]);
 }
 
 void SELECT_MASK (ide_drive_t *drive, int mask)
 {
-	if (HWIF(drive)->maskproc)
-		HWIF(drive)->maskproc(drive, mask);
+	const struct ide_port_ops *port_ops = drive->hwif->port_ops;
+
+	if (port_ops && port_ops->maskproc)
+		port_ops->maskproc(drive, mask);
 }
 
 /*
@@ -904,10 +907,11 @@ static ide_startstop_t reset_pollfunc (i
 {
 	ide_hwgroup_t *hwgroup	= HWGROUP(drive);
 	ide_hwif_t *hwif	= HWIF(drive);
+	const struct ide_port_ops *port_ops = hwif->port_ops;
 	u8 tmp;
 
-	if (hwif->reset_poll != NULL) {
-		if (hwif->reset_poll(drive)) {
+	if (port_ops && port_ops->reset_poll) {
+		if (port_ops->reset_poll(drive)) {
 			printk(KERN_ERR "%s: host reset_poll failure for %s.\n",
 				hwif->name, drive->name);
 			return ide_stopped;
@@ -973,6 +977,8 @@ static void ide_disk_pre_reset(ide_drive
 
 static void pre_reset(ide_drive_t *drive)
 {
+	const struct ide_port_ops *port_ops = drive->hwif->port_ops;
+
 	if (drive->media == ide_disk)
 		ide_disk_pre_reset(drive);
 	else
@@ -993,8 +999,8 @@ static void pre_reset(ide_drive_t *drive
 		return;
 	}
 
-	if (HWIF(drive)->pre_reset != NULL)
-		HWIF(drive)->pre_reset(drive);
+	if (port_ops && port_ops->pre_reset)
+		port_ops->pre_reset(drive);
 
 	if (drive->current_speed != 0xff)
 		drive->desired_speed = drive->current_speed;
@@ -1022,6 +1028,7 @@ static ide_startstop_t do_reset1 (ide_dr
 	unsigned long flags;
 	ide_hwif_t *hwif;
 	ide_hwgroup_t *hwgroup;
+	const struct ide_port_ops *port_ops;
 	u8 ctl;
 
 	spin_lock_irqsave(&ide_lock, flags);
@@ -1088,8 +1095,9 @@ static ide_startstop_t do_reset1 (ide_dr
 	 * state when the disks are reset this way. At least, the Winbond
 	 * 553 documentation says that
 	 */
-	if (hwif->resetproc)
-		hwif->resetproc(drive);
+	port_ops = hwif->port_ops;
+	if (port_ops && port_ops->resetproc)
+		port_ops->resetproc(drive);
 
 	spin_unlock_irqrestore(&ide_lock, flags);
 	return ide_started;
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -298,9 +298,10 @@ EXPORT_SYMBOL_GPL(ide_get_best_pio_mode)
 void ide_set_pio(ide_drive_t *drive, u8 req_pio)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
 	u8 host_pio, pio;
 
-	if (hwif->set_pio_mode == NULL ||
+	if (port_ops == NULL || port_ops->set_pio_mode == NULL ||
 	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
 		return;
 
@@ -353,29 +354,30 @@ void ide_toggle_bounce(ide_drive_t *driv
 int ide_set_pio_mode(ide_drive_t *drive, const u8 mode)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
 
 	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
 		return 0;
 
-	if (hwif->set_pio_mode == NULL)
+	if (port_ops == NULL || port_ops->set_pio_mode == NULL)
 		return -1;
 
 	/*
 	 * TODO: temporary hack for some legacy host drivers that didn't
 	 * set transfer mode on the device in ->set_pio_mode method...
 	 */
-	if (hwif->set_dma_mode == NULL) {
-		hwif->set_pio_mode(drive, mode - XFER_PIO_0);
+	if (port_ops->set_dma_mode == NULL) {
+		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
 		return 0;
 	}
 
 	if (hwif->host_flags & IDE_HFLAG_POST_SET_MODE) {
 		if (ide_config_drive_speed(drive, mode))
 			return -1;
-		hwif->set_pio_mode(drive, mode - XFER_PIO_0);
+		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
 		return 0;
 	} else {
-		hwif->set_pio_mode(drive, mode - XFER_PIO_0);
+		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
 		return ide_config_drive_speed(drive, mode);
 	}
 }
@@ -383,20 +385,21 @@ int ide_set_pio_mode(ide_drive_t *drive,
 int ide_set_dma_mode(ide_drive_t *drive, const u8 mode)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
 
 	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
 		return 0;
 
-	if (hwif->set_dma_mode == NULL)
+	if (port_ops == NULL || port_ops->set_dma_mode == NULL)
 		return -1;
 
 	if (hwif->host_flags & IDE_HFLAG_POST_SET_MODE) {
 		if (ide_config_drive_speed(drive, mode))
 			return -1;
-		hwif->set_dma_mode(drive, mode);
+		port_ops->set_dma_mode(drive, mode);
 		return 0;
 	} else {
-		hwif->set_dma_mode(drive, mode);
+		port_ops->set_dma_mode(drive, mode);
 		return ide_config_drive_speed(drive, mode);
 	}
 }
@@ -416,8 +419,9 @@ EXPORT_SYMBOL_GPL(ide_set_dma_mode);
 int ide_set_xfer_rate(ide_drive_t *drive, u8 rate)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
 
-	if (hwif->set_dma_mode == NULL ||
+	if (port_ops == NULL || port_ops->set_dma_mode == NULL ||
 	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
 		return -1;
 
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -820,13 +820,14 @@ static int ide_probe_port(ide_hwif_t *hw
 
 static void ide_port_tune_devices(ide_hwif_t *hwif)
 {
+	const struct ide_port_ops *port_ops = hwif->port_ops;
 	int unit;
 
 	for (unit = 0; unit < MAX_DRIVES; unit++) {
 		ide_drive_t *drive = &hwif->drives[unit];
 
-		if (drive->present && hwif->quirkproc)
-			hwif->quirkproc(drive);
+		if (drive->present && port_ops && port_ops->quirkproc)
+			port_ops->quirkproc(drive);
 	}
 
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
@@ -1321,6 +1322,7 @@ static void hwif_register_devices(ide_hw
 
 static void ide_port_init_devices(ide_hwif_t *hwif)
 {
+	const struct ide_port_ops *port_ops = hwif->port_ops;
 	int i;
 
 	for (i = 0; i < MAX_DRIVES; i++) {
@@ -1336,8 +1338,8 @@ static void ide_port_init_devices(ide_hw
 			drive->autotune = 1;
 	}
 
-	if (hwif->port_init_devs)
-		hwif->port_init_devs(hwif);
+	if (port_ops && port_ops->port_init_devs)
+		port_ops->port_init_devs(hwif);
 }
 
 static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
@@ -1362,6 +1364,10 @@ static void ide_init_port(ide_hwif_t *hw
 	hwif->host_flags = d->host_flags;
 	hwif->pio_mask = d->pio_mask;
 
+	/* ->set_pio_mode for DTC2278 is currently limited to port 0 */
+	if (hwif->chipset != ide_dtc2278 || hwif->channel == 0)
+		hwif->port_ops = d->port_ops;
+
 	if ((d->host_flags & IDE_HFLAG_SERIALIZE) && hwif->mate)
 		hwif->mate->serialized = hwif->serialized = 1;
 
@@ -1383,9 +1389,11 @@ static void ide_init_port(ide_hwif_t *hw
 
 static void ide_port_cable_detect(ide_hwif_t *hwif)
 {
-	if (hwif->cable_detect && (hwif->ultra_mask & 0x78)) {
+	const struct ide_port_ops *port_ops = hwif->port_ops;
+
+	if (port_ops && port_ops->cable_detect && (hwif->ultra_mask & 0x78)) {
 		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-			hwif->cbl = hwif->cable_detect(hwif);
+			hwif->cbl = port_ops->cable_detect(hwif);
 	}
 }
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -587,11 +587,12 @@ int set_pio_mode(ide_drive_t *drive, int
 {
 	struct request rq;
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
 
 	if (arg < 0 || arg > 255)
 		return -EINVAL;
 
-	if (hwif->set_pio_mode == NULL ||
+	if (port_ops == NULL || port_ops->set_pio_mode == NULL ||
 	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
 		return -ENOSYS;
 
Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -191,8 +191,13 @@ static int __init initRegisters (void) {
 	return t;
 }
 
+static const struct ide_port_ops ali14xx_port_ops = {
+	.set_pio_mode		= ali14xx_set_pio_mode,
+};
+
 static const struct ide_port_info ali14xx_port_info = {
 	.chipset		= ide_ali14xx,
+	.port_ops		= &ali14xx_port_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_AUTOTUNE,
 	.pio_mask		= ATA_PIO4,
 };
@@ -223,14 +228,12 @@ static int __init ali14xx_probe(void)
 	hwif = ide_find_port();
 	if (hwif) {
 		ide_init_port_hw(hwif, &hw[0]);
-		hwif->set_pio_mode = &ali14xx_set_pio_mode;
 		idx[0] = hwif->index;
 	}
 
 	mate = ide_find_port();
 	if (mate) {
 		ide_init_port_hw(mate, &hw[1]);
-		mate->set_pio_mode = &ali14xx_set_pio_mode;
 		idx[1] = mate->index;
 	}
 
Index: b/drivers/ide/legacy/dtc2278.c
===================================================================
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -86,8 +86,13 @@ static void dtc2278_set_pio_mode(ide_dri
 	}
 }
 
+static const struct ide_port_ops dtc2278_port_ops = {
+	.set_pio_mode		= dtc2278_set_pio_mode,
+};
+
 static const struct ide_port_info dtc2278_port_info __initdata = {
 	.chipset		= ide_dtc2278,
+	.port_ops		= &dtc2278_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_UNMASK_IRQS |
 				  IDE_HFLAG_IO_32BIT |
@@ -134,7 +139,6 @@ static int __init dtc2278_probe(void)
 	hwif = ide_find_port();
 	if (hwif) {
 		ide_init_port_hw(hwif, &hw[0]);
-		hwif->set_pio_mode = dtc2278_set_pio_mode;
 		idx[0] = hwif->index;
 	}
 
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -328,8 +328,15 @@ int probe_ht6560b = 0;
 module_param_named(probe, probe_ht6560b, bool, 0);
 MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
 
+static const struct ide_port_ops ht6560b_port_ops = {
+	.port_init_devs		= ht6560b_port_init_devs,
+	.set_pio_mode		= ht6560b_set_pio_mode,
+	.selectproc		= ht6560b_selectproc,
+};
+
 static const struct ide_port_info ht6560b_port_info __initdata = {
 	.chipset		= ide_ht6560b,
+	.port_ops		= &ht6560b_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE | /* is this needed? */
 				  IDE_HFLAG_NO_DMA |
 				  IDE_HFLAG_NO_AUTOTUNE |
@@ -368,18 +375,12 @@ static int __init ht6560b_init(void)
 	hwif = ide_find_port();
 	if (hwif) {
 		ide_init_port_hw(hwif, &hw[0]);
-		hwif->selectproc     = ht6560b_selectproc;
-		hwif->set_pio_mode   = ht6560b_set_pio_mode;
-		hwif->port_init_devs = ht6560b_port_init_devs;
 		idx[0] = hwif->index;
 	}
 
 	mate = ide_find_port();
 	if (mate) {
 		ide_init_port_hw(mate, &hw[1]);
-		mate->selectproc     = ht6560b_selectproc;
-		mate->set_pio_mode   = ht6560b_set_pio_mode;
-		mate->port_init_devs = ht6560b_port_init_devs;
 		idx[1] = mate->index;
 	}
 
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -143,6 +143,10 @@ static void ide_detach(struct pcmcia_dev
     kfree(link->priv);
 } /* ide_detach */
 
+static const struct ide_port_ops idecs_port_ops = {
+	.quirkproc		= ide_undecoded_slave,
+};
+
 static int idecs_register(unsigned long io, unsigned long ctl, unsigned long irq, struct pcmcia_device *handle)
 {
     ide_hwif_t *hwif;
@@ -168,7 +172,7 @@ static int idecs_register(unsigned long 
 	ide_init_port_data(hwif, i);
 
     ide_init_port_hw(hwif, &hw);
-    hwif->quirkproc = &ide_undecoded_slave;
+    hwif->port_ops = &idecs_port_ops;
 
     idx[0] = i;
 
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -304,6 +304,18 @@ static void __init qd6580_port_init_devs
 	hwif->drives[1].drive_data = t2;
 }
 
+static const struct ide_port_ops qd6500_port_ops = {
+	.port_init_devs		= qd6500_port_init_devs,
+	.set_pio_mode		= qd6500_set_pio_mode,
+	.selectproc		= qd65xx_select,
+};
+
+static const struct ide_port_ops qd6580_port_ops = {
+	.port_init_devs		= qd6580_port_init_devs,
+	.set_pio_mode		= qd6580_set_pio_mode,
+	.selectproc		= qd65xx_select,
+};
+
 static const struct ide_port_info qd65xx_port_info __initdata = {
 	.chipset		= ide_qd65xx,
 	.host_flags		= IDE_HFLAG_IO_32BIT |
@@ -361,6 +373,7 @@ static int __init qd_probe(int base)
 		printk(KERN_DEBUG "qd6500: config=%#x, ID3=%u\n",
 			config, QD_ID3);
 
+		d.port_ops = &qd6500_port_ops;
 		d.host_flags |= IDE_HFLAG_SINGLE;
 
 		hwif = ide_find_port_slot(&d);
@@ -371,10 +384,6 @@ static int __init qd_probe(int base)
 
 		hwif->config_data = (base << 8) | config;
 
-		hwif->port_init_devs = qd6500_port_init_devs;
-		hwif->set_pio_mode   = qd6500_set_pio_mode;
-		hwif->selectproc     = qd65xx_select;
-
 		idx[unit] = unit;
 
 		ide_device_add(idx, &d);
@@ -400,6 +409,8 @@ static int __init qd_probe(int base)
 
 		outb(QD_DEF_CONTR, QD_CONTROL_PORT);
 
+		d.port_ops = &qd6580_port_ops;
+
 		if (control & QD_CONTR_SEC_DISABLED) {
 			/* secondary disabled */
 
@@ -415,10 +426,6 @@ static int __init qd_probe(int base)
 
 			hwif->config_data = (base << 8) | config;
 
-			hwif->port_init_devs = qd6580_port_init_devs;
-			hwif->set_pio_mode   = qd6580_set_pio_mode;
-			hwif->selectproc     = qd65xx_select;
-
 			idx[unit] = unit;
 
 			ide_device_add(idx, &d);
@@ -434,9 +441,6 @@ static int __init qd_probe(int base)
 			if (hwif) {
 				ide_init_port_hw(hwif, &hw[0]);
 				hwif->config_data = (base << 8) | config;
-				hwif->port_init_devs = qd6580_port_init_devs;
-				hwif->set_pio_mode   = qd6580_set_pio_mode;
-				hwif->selectproc     = qd65xx_select;
 				idx[0] = 0;
 			}
 
@@ -444,13 +448,10 @@ static int __init qd_probe(int base)
 			if (mate) {
 				ide_init_port_hw(mate, &hw[1]);
 				mate->config_data = (base << 8) | config;
-				mate->port_init_devs = qd6580_port_init_devs;
-				mate->set_pio_mode   = qd6580_set_pio_mode;
-				hwif->selectproc     = qd65xx_select;
 				idx[1] = 1;
 			}
 
-			ide_device_add(idx, &qd65xx_port_info);
+			ide_device_add(idx, &d);
 
 			return 0; /* no other qd65xx possible */
 		}
Index: b/drivers/ide/legacy/umc8672.c
===================================================================
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -120,8 +120,13 @@ static void umc_set_pio_mode(ide_drive_t
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
+static const struct ide_port_ops umc8672_port_ops = {
+	.set_pio_mode		= umc_set_pio_mode,
+};
+
 static const struct ide_port_info umc8672_port_info __initdata = {
 	.chipset		= ide_umc8672,
+	.port_ops		= &umc8672_port_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_AUTOTUNE,
 	.pio_mask		= ATA_PIO4,
 };
@@ -161,14 +166,12 @@ static int __init umc8672_probe(void)
 	hwif = ide_find_port();
 	if (hwif) {
 		ide_init_port_hw(hwif, &hw[0]);
-		hwif->set_pio_mode = umc_set_pio_mode;
 		idx[0] = hwif->index;
 	}
 
 	mate = ide_find_port();
 	if (mate) {
 		ide_init_port_hw(mate, &hw[1]);
-		mate->set_pio_mode = umc_set_pio_mode;
 		idx[1] = mate->index;
 	}
 
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -548,7 +548,16 @@ static void auide_setup_ports(hw_regs_t 
 	*ata_regs = ahwif->regbase + (14 << AU1XXX_ATA_REG_OFFSET);
 }
 
+static const struct ide_port_ops au1xxx_port_ops = {
+	.set_pio_mode		= au1xxx_set_pio_mode,
+	.set_dma_mode		= auide_set_dma_mode,
+#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
+	.mdma_filter		= auide_mdma_filter,
+#endif
+};
+
 static const struct ide_port_info au1xxx_port_info = {
+	.port_ops		= &au1xxx_port_ops,
 	.host_flags		= IDE_HFLAG_POST_SET_MODE |
 				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
 				  IDE_HFLAG_NO_IO_32BIT |
@@ -629,15 +638,8 @@ static int au_ide_probe(struct device *d
 	hwif->INSW                      = auide_insw;
 	hwif->OUTSW                     = auide_outsw;
 #endif
-
-	hwif->set_pio_mode		= &au1xxx_set_pio_mode;
-	hwif->set_dma_mode		= &auide_set_dma_mode;
-
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 	hwif->dma_timeout		= &auide_dma_timeout;
-
-	hwif->mdma_filter		= &auide_mdma_filter;
-
 	hwif->dma_host_set		= &auide_dma_host_set;
 	hwif->dma_exec_cmd              = &auide_dma_exec_cmd;
 	hwif->dma_start                 = &auide_dma_start;
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -135,7 +135,7 @@ static void aec6260_set_mode(ide_drive_t
 
 static void aec_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	drive->hwif->set_dma_mode(drive, pio + XFER_PIO_0);
+	drive->hwif->port_ops->set_dma_mode(drive, pio + XFER_PIO_0);
 }
 
 static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const char *name)
@@ -175,27 +175,23 @@ static u8 __devinit atp86x_cable_detect(
 	return (ata66 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 }
 
-static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-
-	hwif->set_pio_mode = &aec_set_pio_mode;
-
-	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
-		hwif->set_dma_mode = &aec6210_set_mode;
-	else {
-		hwif->set_dma_mode = &aec6260_set_mode;
+static const struct ide_port_ops atp850_port_ops = {
+	.set_pio_mode		= aec_set_pio_mode,
+	.set_dma_mode		= aec6210_set_mode,
+};
 
-		hwif->cable_detect = atp86x_cable_detect;
-	}
-}
+static const struct ide_port_ops atp86x_port_ops = {
+	.set_pio_mode		= aec_set_pio_mode,
+	.set_dma_mode		= aec6260_set_mode,
+	.cable_detect		= atp86x_cable_detect,
+};
 
 static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "AEC6210",
 		.init_chipset	= init_chipset_aec62xx,
-		.init_hwif	= init_hwif_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
+		.port_ops	= &atp850_port_ops,
 		.host_flags	= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_ATAPI_DMA |
 				  IDE_HFLAG_NO_DSC |
@@ -207,7 +203,7 @@ static const struct ide_port_info aec62x
 	},{	/* 1 */
 		.name		= "AEC6260",
 		.init_chipset	= init_chipset_aec62xx,
-		.init_hwif	= init_hwif_aec62xx,
+		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_NO_AUTODMA |
 				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
@@ -217,8 +213,8 @@ static const struct ide_port_info aec62x
 	},{	/* 2 */
 		.name		= "AEC6260R",
 		.init_chipset	= init_chipset_aec62xx,
-		.init_hwif	= init_hwif_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
+		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
 				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_NON_BOOTABLE,
@@ -228,7 +224,7 @@ static const struct ide_port_info aec62x
 	},{	/* 3 */
 		.name		= "AEC6280",
 		.init_chipset	= init_chipset_aec62xx,
-		.init_hwif	= init_hwif_aec62xx,
+		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
 				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
@@ -238,8 +234,8 @@ static const struct ide_port_info aec62x
 	},{	/* 4 */
 		.name		= "AEC6280R",
 		.init_chipset	= init_chipset_aec62xx,
-		.init_hwif	= init_hwif_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
+		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
 				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -610,7 +610,7 @@ static int ali_cable_override(struct pci
 }
 
 /**
- *	ata66_ali15x3	-	check for UDMA 66 support
+ *	ali_cable_detect	-	cable detection
  *	@hwif: IDE interface
  *
  *	This checks if the controller and the cable are capable
@@ -620,7 +620,7 @@ static int ali_cable_override(struct pci
  *	FIXME: frobs bits that are not defined on newer ALi devicea
  */
 
-static u8 __devinit ata66_ali15x3(ide_hwif_t *hwif)
+static u8 __devinit ali_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long flags;
@@ -661,12 +661,6 @@ static u8 __devinit ata66_ali15x3(ide_hw
  
 static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
 {
-	hwif->set_pio_mode = &ali_set_pio_mode;
-	hwif->set_dma_mode = &ali_set_dma_mode;
-	hwif->udma_filter = &ali_udma_filter;
-
-	hwif->cable_detect = ata66_ali15x3;
-
 	if (hwif->dma_base == 0)
 		return;
 
@@ -745,11 +739,19 @@ static void __devinit init_dma_ali15x3 (
 	ide_setup_dma(hwif, dmabase);
 }
 
+static const struct ide_port_ops ali_port_ops = {
+	.set_pio_mode		= ali_set_pio_mode,
+	.set_dma_mode		= ali_set_dma_mode,
+	.udma_filter		= ali_udma_filter,
+	.cable_detect		= ali_cable_detect,
+};
+
 static const struct ide_port_info ali15x3_chipset __devinitdata = {
 	.name		= "ALI15X3",
 	.init_chipset	= init_chipset_ali15x3,
 	.init_hwif	= init_hwif_ali15x3,
 	.init_dma	= init_dma_ali15x3,
+	.port_ops	= &ali_port_ops,
 	.pio_mask	= ATA_PIO5,
 	.swdma_mask	= ATA_SWDMA2,
 	.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -210,13 +210,14 @@ static void __devinit init_hwif_amd74xx(
 
 	if (hwif->irq == 0) /* 0 is bogus but will do for now */
 		hwif->irq = pci_get_legacy_ide_irq(dev, hwif->channel);
-
-	hwif->set_pio_mode = &amd_set_pio_mode;
-	hwif->set_dma_mode = &amd_set_drive;
-
-	hwif->cable_detect = amd_cable_detect;
 }
 
+static const struct ide_port_ops amd_port_ops = {
+	.set_pio_mode		= amd_set_pio_mode,
+	.set_dma_mode		= amd_set_drive,
+	.cable_detect		= amd_cable_detect,
+};
+
 #define IDE_HFLAGS_AMD \
 	(IDE_HFLAG_PIO_NO_BLACKLIST | \
 	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
@@ -230,6 +231,7 @@ static void __devinit init_hwif_amd74xx(
 		.init_chipset	= init_chipset_amd74xx,			\
 		.init_hwif	= init_hwif_amd74xx,			\
 		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},	\
+		.port_ops	= &amd_port_ops,			\
 		.host_flags	= IDE_HFLAGS_AMD,			\
 		.pio_mask	= ATA_PIO5,				\
 		.swdma_mask	= swdma,				\
@@ -243,6 +245,7 @@ static void __devinit init_hwif_amd74xx(
 		.init_chipset	= init_chipset_amd74xx,			\
 		.init_hwif	= init_hwif_amd74xx,			\
 		.enablebits	= {{0x50,0x02,0x02}, {0x50,0x01,0x01}},	\
+		.port_ops	= &amd_port_ops,			\
 		.host_flags	= IDE_HFLAGS_AMD,			\
 		.pio_mask	= ATA_PIO5,				\
 		.swdma_mask	= ATA_SWDMA2,				\
Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -130,35 +130,25 @@ static u8 __devinit atiixp_cable_detect(
 		return ATA_CBL_PATA40;
 }
 
-/**
- *	init_hwif_atiixp		-	fill in the hwif for the ATIIXP
- *	@hwif: IDE interface
- *
- *	Set up the ide_hwif_t for the ATIIXP interface according to the
- *	capabilities of the hardware.
- */
-
-static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
-{
-	hwif->set_pio_mode = &atiixp_set_pio_mode;
-	hwif->set_dma_mode = &atiixp_set_dma_mode;
-
-	hwif->cable_detect = atiixp_cable_detect;
-}
+static const struct ide_port_ops atiixp_port_ops = {
+	.set_pio_mode		= atiixp_set_pio_mode,
+	.set_dma_mode		= atiixp_set_dma_mode,
+	.cable_detect		= atiixp_cable_detect,
+};
 
 static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
 	{	/* 0 */
 		.name		= "ATIIXP",
-		.init_hwif	= init_hwif_atiixp,
 		.enablebits	= {{0x48,0x01,0x00}, {0x48,0x08,0x00}},
+		.port_ops	= &atiixp_port_ops,
 		.host_flags	= IDE_HFLAG_LEGACY_IRQS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
 	},{	/* 1 */
 		.name		= "SB600_PATA",
-		.init_hwif	= init_hwif_atiixp,
 		.enablebits	= {{0x48,0x01,0x00}, {0x00,0x00,0x00}},
+		.port_ops	= &atiixp_port_ops,
 		.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_LEGACY_IRQS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -632,6 +632,9 @@ static void cmd640_set_pio_mode(ide_driv
 	display_clocks(index);
 }
 
+static const struct ide_port_ops cmd640_port_ops = {
+	.set_pio_mode		= cmd640_set_pio_mode,
+};
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
 static int pci_conf1(void)
@@ -677,6 +680,7 @@ static const struct ide_port_info cmd640
 				  IDE_HFLAG_ABUSE_PREFETCH |
 				  IDE_HFLAG_ABUSE_FAST_DEVSEL,
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
+	.port_ops		= &cmd640_port_ops,
 	.pio_mask		= ATA_PIO5,
 #endif
 };
@@ -751,9 +755,6 @@ static int __init cmd640x_init(void)
 	 */
 	if (cmd_hwif0) {
 		ide_init_port_hw(cmd_hwif0, &hw[0]);
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-		cmd_hwif0->set_pio_mode = &cmd640_set_pio_mode;
-#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
 		idx[0] = cmd_hwif0->index;
 	}
@@ -807,9 +808,6 @@ static int __init cmd640x_init(void)
 	 */
 	if (second_port_cmd640 && cmd_hwif1) {
 		ide_init_port_hw(cmd_hwif1, &hw[1]);
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-		cmd_hwif1->set_pio_mode = &cmd640_set_pio_mode;
-#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
 		idx[1] = cmd_hwif1->index;
 	}
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -370,7 +370,7 @@ static unsigned int __devinit init_chips
 	return 0;
 }
 
-static u8 __devinit ata66_cmd64x(ide_hwif_t *hwif)
+static u8 __devinit cmd64x_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev  *dev	= to_pci_dev(hwif->dev);
 	u8 bmidecsr = 0, mask	= hwif->channel ? 0x02 : 0x01;
@@ -389,11 +389,6 @@ static void __devinit init_hwif_cmd64x(i
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
-	hwif->set_pio_mode = &cmd64x_set_pio_mode;
-	hwif->set_dma_mode = &cmd64x_set_dma_mode;
-
-	hwif->cable_detect = ata66_cmd64x;
-
 	if (!hwif->dma_base)
 		return;
 
@@ -433,12 +428,19 @@ static void __devinit init_hwif_cmd64x(i
 	}
 }
 
+static const struct ide_port_ops cmd64x_port_ops = {
+	.set_pio_mode		= cmd64x_set_pio_mode,
+	.set_dma_mode		= cmd64x_set_dma_mode,
+	.cable_detect		= cmd64x_cable_detect,
+};
+
 static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "CMD643",
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
+		.port_ops	= &cmd64x_port_ops,
 		.host_flags	= IDE_HFLAG_CLEAR_SIMPLEX |
 				  IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
@@ -450,6 +452,7 @@ static const struct ide_port_info cmd64x
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.chipset	= ide_cmd646,
+		.port_ops	= &cmd64x_port_ops,
 		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -459,6 +462,7 @@ static const struct ide_port_info cmd64x
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
+		.port_ops	= &cmd64x_port_ops,
 		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -468,6 +472,7 @@ static const struct ide_port_info cmd64x
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
+		.port_ops	= &cmd64x_port_ops,
 		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -105,19 +105,22 @@ static void cs5520_dma_host_set(ide_driv
 
 static void __devinit init_hwif_cs5520(ide_hwif_t *hwif)
 {
-	hwif->set_pio_mode = &cs5520_set_pio_mode;
-	hwif->set_dma_mode = &cs5520_set_dma_mode;
-
 	if (hwif->dma_base == 0)
 		return;
 
 	hwif->dma_host_set = &cs5520_dma_host_set;
 }
 
+static const struct ide_port_ops cs5520_port_ops = {
+	.set_pio_mode		= cs5520_set_pio_mode,
+	.set_dma_mode		= cs5520_set_dma_mode,
+};
+
 #define DECLARE_CS_DEV(name_str)				\
 	{							\
 		.name		= name_str,			\
 		.init_hwif	= init_hwif_cs5520,		\
+		.port_ops	= &cs5520_port_ops,		\
 		.host_flags	= IDE_HFLAG_ISA_PORTS |		\
 				  IDE_HFLAG_CS5520 |		\
 				  IDE_HFLAG_VDMA |		\
Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -228,26 +228,25 @@ static void __devinit init_hwif_cs5530 (
 	unsigned long basereg;
 	u32 d0_timings;
 
-	hwif->set_pio_mode = &cs5530_set_pio_mode;
-	hwif->set_dma_mode = &cs5530_set_dma_mode;
-
 	basereg = CS5530_BASEREG(hwif);
 	d0_timings = inl(basereg + 0);
 	if (CS5530_BAD_PIO(d0_timings))
 		outl(cs5530_pio_timings[(d0_timings >> 31) & 1][0], basereg + 0);
 	if (CS5530_BAD_PIO(inl(basereg + 8)))
 		outl(cs5530_pio_timings[(d0_timings >> 31) & 1][0], basereg + 8);
-
-	if (hwif->dma_base == 0)
-		return;
-
-	hwif->udma_filter = cs5530_udma_filter;
 }
 
+static const struct ide_port_ops cs5530_port_ops = {
+	.set_pio_mode		= cs5530_set_pio_mode,
+	.set_dma_mode		= cs5530_set_dma_mode,
+	.udma_filter		= cs5530_udma_filter,
+};
+
 static const struct ide_port_info cs5530_chipset __devinitdata = {
 	.name		= "CS5530",
 	.init_chipset	= init_chipset_cs5530,
 	.init_hwif	= init_hwif_cs5530,
+	.port_ops	= &cs5530_port_ops,
 	.host_flags	= IDE_HFLAG_SERIALIZE |
 			  IDE_HFLAG_POST_SET_MODE,
 	.pio_mask	= ATA_PIO4,
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -166,25 +166,15 @@ static u8 __devinit cs5535_cable_detect(
 	return (bit & 1) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
-/****
- *	init_hwif_cs5535        -       Initialize one ide cannel
- *	@hwif: Channel descriptor
- *
- *	This gets invoked by the IDE driver once for each channel. It
- *	performs channel-specific pre-initialization before drive probing.
- *
- */
-static void __devinit init_hwif_cs5535(ide_hwif_t *hwif)
-{
-	hwif->set_pio_mode = &cs5535_set_pio_mode;
-	hwif->set_dma_mode = &cs5535_set_dma_mode;
-
-	hwif->cable_detect = cs5535_cable_detect;
-}
+static const struct ide_port_ops cs5535_port_ops = {
+	.set_pio_mode		= cs5535_set_pio_mode,
+	.set_dma_mode		= cs5535_set_dma_mode,
+	.cable_detect		= cs5535_cable_detect,
+};
 
 static const struct ide_port_info cs5535_chipset __devinitdata = {
 	.name		= "CS5535",
-	.init_hwif	= init_hwif_cs5535,
+	.port_ops	= &cs5535_port_ops,
 	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE |
 			  IDE_HFLAG_ABUSE_SET_DMA_MODE,
 	.pio_mask	= ATA_PIO4,
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -382,15 +382,6 @@ static unsigned int __devinit init_chips
 	return 0;
 }
 
-/*
- * the init function - called for each ide channel once
- */
-static void __devinit init_hwif_cy82c693(ide_hwif_t *hwif)
-{
-	hwif->set_pio_mode = &cy82c693_set_pio_mode;
-	hwif->set_dma_mode = &cy82c693_set_dma_mode;
-}
-
 static void __devinit init_iops_cy82c693(ide_hwif_t *hwif)
 {
 	static ide_hwif_t *primary;
@@ -404,11 +395,16 @@ static void __devinit init_iops_cy82c693
 	}
 }
 
+static const struct ide_port_ops cy82c693_port_ops = {
+	.set_pio_mode		= cy82c693_set_pio_mode,
+	.set_dma_mode		= cy82c693_set_dma_mode,
+};
+
 static const struct ide_port_info cy82c693_chipset __devinitdata = {
 	.name		= "CY82C693",
 	.init_chipset	= init_chipset_cy82c693,
 	.init_iops	= init_iops_cy82c693,
-	.init_hwif	= init_hwif_cy82c693,
+	.port_ops	= &cy82c693_port_ops,
 	.chipset	= ide_cy82c693,
 	.host_flags	= IDE_HFLAG_SINGLE,
 	.pio_mask	= ATA_PIO4,
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -43,6 +43,10 @@ static const u8 setup[] = {
 	0x00, 0x00, 0x00, 0x00, 0xa4, 0x83, 0x02, 0x13,
 };
 
+static const struct ide_port_ops delkin_cb_port_ops = {
+	.quirkproc		= ide_undecoded_slave,
+};
+
 static int __devinit
 delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 {
@@ -90,7 +94,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 
 	ide_init_port_hw(hwif, &hw);
 	hwif->mmio = 1;
-	hwif->quirkproc = &ide_undecoded_slave;
+	hwif->port_ops = &delkin_cb_port_ops;
 
 	idx[0] = i;
 
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -115,11 +115,10 @@ static unsigned int __devinit init_chips
 	return dev->irq;
 }
 
-static void __devinit init_hwif_hpt34x(ide_hwif_t *hwif)
-{
-	hwif->set_pio_mode = &hpt34x_set_pio_mode;
-	hwif->set_dma_mode = &hpt34x_set_mode;
-}
+static const struct ide_port_ops hpt34x_port_ops = {
+	.set_pio_mode		= hpt34x_set_pio_mode,
+	.set_dma_mode		= hpt34x_set_mode,
+};
 
 #define IDE_HFLAGS_HPT34X \
 	(IDE_HFLAG_NO_ATAPI_DMA | \
@@ -131,16 +130,16 @@ static const struct ide_port_info hpt34x
 	{ /* 0 */
 		.name		= "HPT343",
 		.init_chipset	= init_chipset_hpt34x,
-		.init_hwif	= init_hwif_hpt34x,
 		.extra		= 16,
+		.port_ops	= &hpt34x_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_NON_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
 	},
 	{ /* 1 */
 		.name		= "HPT345",
 		.init_chipset	= init_chipset_hpt34x,
-		.init_hwif	= init_hwif_hpt34x,
 		.extra		= 16,
+		.port_ops	= &hpt34x_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO5,
 #ifdef CONFIG_HPT34X_AUTODMA
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1271,17 +1271,6 @@ static void __devinit init_hwif_hpt366(i
 	/* Cache the channel's MISC. control registers' offset */
 	hwif->select_data	= hwif->channel ? 0x54 : 0x50;
 
-	hwif->set_pio_mode	= &hpt3xx_set_pio_mode;
-	hwif->set_dma_mode	= &hpt3xx_set_mode;
-
-	hwif->quirkproc		= &hpt3xx_quirkproc;
-	hwif->maskproc		= &hpt3xx_maskproc;
-
-	hwif->udma_filter	= &hpt3xx_udma_filter;
-	hwif->mdma_filter	= &hpt3xx_mdma_filter;
-
-	hwif->cable_detect	= hpt3xx_cable_detect;
-
 	/*
 	 * HPT3xxN chips have some complications:
 	 *
@@ -1416,6 +1405,16 @@ static int __devinit hpt36x_init(struct 
 	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
 	 IDE_HFLAG_OFF_BOARD)
 
+static const struct ide_port_ops hpt3xx_port_ops = {
+	.set_pio_mode		= hpt3xx_set_pio_mode,
+	.set_dma_mode		= hpt3xx_set_mode,
+	.quirkproc		= hpt3xx_quirkproc,
+	.maskproc		= hpt3xx_maskproc,
+	.mdma_filter		= hpt3xx_mdma_filter,
+	.udma_filter		= hpt3xx_udma_filter,
+	.cable_detect		= hpt3xx_cable_detect,
+};
+
 static const struct ide_port_info hpt366_chipsets[] __devinitconst = {
 	{	/* 0 */
 		.name		= "HPT36x",
@@ -1430,6 +1429,7 @@ static const struct ide_port_info hpt366
 		 */
 		.enablebits	= {{0x50,0x10,0x10}, {0x54,0x04,0x04}},
 		.extra		= 240,
+		.port_ops	= &hpt3xx_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1440,6 +1440,7 @@ static const struct ide_port_info hpt366
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.extra		= 240,
+		.port_ops	= &hpt3xx_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1450,6 +1451,7 @@ static const struct ide_port_info hpt366
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.extra		= 240,
+		.port_ops	= &hpt3xx_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1460,6 +1462,7 @@ static const struct ide_port_info hpt366
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.extra		= 240,
+		.port_ops	= &hpt3xx_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1471,6 +1474,7 @@ static const struct ide_port_info hpt366
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.udma_mask	= ATA_UDMA5,
 		.extra		= 240,
+		.port_ops	= &hpt3xx_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1481,6 +1485,7 @@ static const struct ide_port_info hpt366
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.extra		= 240,
+		.port_ops	= &hpt3xx_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/it8213.c
===================================================================
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -150,27 +150,17 @@ static u8 __devinit it8213_cable_detect(
 	return (reg42h & 0x02) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 }
 
-/**
- *	init_hwif_it8213	-	set up hwif structs
- *	@hwif: interface to set up
- *
- *	We do the basic set up of the interface structure.
- */
-
-static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
-{
-	hwif->set_dma_mode = &it8213_set_dma_mode;
-	hwif->set_pio_mode = &it8213_set_pio_mode;
-
-	hwif->cable_detect = it8213_cable_detect;
-}
-
+static const struct ide_port_ops it8213_port_ops = {
+	.set_pio_mode		= it8213_set_pio_mode,
+	.set_dma_mode		= it8213_set_dma_mode,
+	.cable_detect		= it8213_cable_detect,
+};
 
 #define DECLARE_ITE_DEV(name_str)			\
 	{						\
 		.name		= name_str,		\
-		.init_hwif	= init_hwif_it8213,	\
 		.enablebits	= {{0x41,0x80,0x80}}, \
+		.port_ops	= &it8213_port_ops,	\
 		.host_flags	= IDE_HFLAG_SINGLE,	\
 		.pio_mask	= ATA_PIO4,		\
 		.swdma_mask	= ATA_SWDMA2_ONLY,	\
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -418,7 +418,7 @@ static void it821x_set_dma_mode(ide_driv
 }
 
 /**
- *	ata66_it821x	-	check for 80 pin cable
+ *	it821x_cable_detect	-	cable detection
  *	@hwif: interface to check
  *
  *	Check for the presence of an ATA66 capable cable on the
@@ -426,7 +426,7 @@ static void it821x_set_dma_mode(ide_driv
  *	the needed logic onboard.
  */
 
-static u8 __devinit ata66_it821x(ide_hwif_t *hwif)
+static u8 __devinit it821x_cable_detect(ide_hwif_t *hwif)
 {
 	/* The reference driver also only does disk side */
 	return ATA_CBL_PATA80;
@@ -527,8 +527,6 @@ static void __devinit init_hwif_it821x(i
 	struct it821x_dev *idev = itdevs[hwif->channel];
 	u8 conf;
 
-	hwif->quirkproc = &it821x_quirkproc;
-
 	ide_set_hwifdata(hwif, idev);
 
 	pci_read_config_byte(dev, 0x50, &conf);
@@ -563,17 +561,12 @@ static void __devinit init_hwif_it821x(i
 	}
 
 	if (idev->smart == 0) {
-		hwif->set_pio_mode = &it821x_set_pio_mode;
-		hwif->set_dma_mode = &it821x_set_dma_mode;
-
 		/* MWDMA/PIO clock switching for pass through mode */
 		hwif->dma_start = &it821x_dma_start;
 		hwif->ide_dma_end = &it821x_dma_end;
 	} else
 		hwif->host_flags |= IDE_HFLAG_NO_SET_MODE;
 
-	hwif->cable_detect = ata66_it821x;
-
 	if (hwif->dma_base == 0)
 		return;
 
@@ -613,12 +606,20 @@ static unsigned int __devinit init_chips
 	return 0;
 }
 
+static const struct ide_port_ops it821x_port_ops = {
+	/* it821x_set_{pio,dma}_mode() are only used in pass-through mode */
+	.set_pio_mode		= it821x_set_pio_mode,
+	.set_dma_mode		= it821x_set_dma_mode,
+	.quirkproc		= it821x_quirkproc,
+	.cable_detect		= it821x_cable_detect,
+};
 
 #define DECLARE_ITE_DEV(name_str)			\
 	{						\
 		.name		= name_str,		\
 		.init_chipset	= init_chipset_it821x,	\
 		.init_hwif	= init_hwif_it821x,	\
+		.port_ops	= &it821x_port_ops,	\
 		.pio_mask	= ATA_PIO4,		\
 	}
 
Index: b/drivers/ide/pci/jmicron.c
===================================================================
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -19,13 +19,13 @@ typedef enum {
 } port_type;
 
 /**
- *	ata66_jmicron		-	Cable check
+ *	jmicron_cable_detect	-	cable detection
  *	@hwif: IDE port
  *
  *	Returns the cable type.
  */
 
-static u8 __devinit ata66_jmicron(ide_hwif_t *hwif)
+static u8 __devinit jmicron_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 
@@ -96,25 +96,16 @@ static void jmicron_set_dma_mode(ide_dri
 {
 }
 
-/**
- *	init_hwif_jmicron	-	set up hwif structs
- *	@hwif: interface to set up
- *
- *	Minimal set up is required for the Jmicron hardware.
- */
-
-static void __devinit init_hwif_jmicron(ide_hwif_t *hwif)
-{
-	hwif->set_pio_mode = &jmicron_set_pio_mode;
-	hwif->set_dma_mode = &jmicron_set_dma_mode;
-
-	hwif->cable_detect = ata66_jmicron;
-}
+static const struct ide_port_ops jmicron_port_ops = {
+	.set_pio_mode		= jmicron_set_pio_mode,
+	.set_dma_mode		= jmicron_set_dma_mode,
+	.cable_detect		= jmicron_cable_detect,
+};
 
 static const struct ide_port_info jmicron_chipset __devinitdata = {
 	.name		= "JMB",
-	.init_hwif	= init_hwif_jmicron,
 	.enablebits	= { { 0x40, 0x01, 0x01 }, { 0x40, 0x10, 0x10 } },
+	.port_ops	= &jmicron_port_ops,
 	.pio_mask	= ATA_PIO5,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -195,8 +195,6 @@ static void __devinit init_hwif_ns87415 
 	u8 stat;
 #endif
 
-	hwif->selectproc = &ns87415_selectproc;
-
 	/*
 	 * We cannot probe for IRQ: both ports share common IRQ on INTA.
 	 * Also, leave IRQ masked during drive probing, to prevent infinite
@@ -258,12 +256,17 @@ static void __devinit init_hwif_ns87415 
 	hwif->ide_dma_end = &ns87415_ide_dma_end;
 }
 
+static const struct ide_port_ops ns87415_port_ops = {
+	.selectproc		= ns87415_selectproc,
+};
+
 static const struct ide_port_info ns87415_chipset __devinitdata = {
 	.name		= "NS87415",
 #ifdef CONFIG_SUPERIO
 	.init_iops	= init_iops_ns87415,
 #endif
 	.init_hwif	= init_hwif_ns87415,
+	.port_ops	= &ns87415_port_ops,
 	.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 			  IDE_HFLAG_NO_ATAPI_DMA,
 };
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -321,28 +321,24 @@ static void __devinit opti621_port_init_
 	hwif->drives[1].drive_data = PIO_DONT_KNOW;
 }
 
-/*
- * init_hwif_opti621() is called once for each hwif found at boot.
- */
-static void __devinit init_hwif_opti621 (ide_hwif_t *hwif)
-{
-	hwif->port_init_devs = opti621_port_init_devs;
-	hwif->set_pio_mode = &opti621_set_pio_mode;
-}
+static const struct ide_port_ops opti621_port_ops = {
+	.port_init_devs		= opti621_port_init_devs,
+	.set_pio_mode		= opti621_set_pio_mode,
+};
 
 static const struct ide_port_info opti621_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "OPTI621",
-		.init_hwif	= init_hwif_opti621,
 		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
+		.port_ops	= &opti621_port_ops,
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 		.pio_mask	= ATA_PIO3,
 		.swdma_mask	= ATA_SWDMA2,
 		.mwdma_mask	= ATA_MWDMA2,
 	},{	/* 1 */
 		.name		= "OPTI621X",
-		.init_hwif	= init_hwif_opti621,
 		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
+		.port_ops	= &opti621_port_ops,
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 		.pio_mask	= ATA_PIO3,
 		.swdma_mask	= ATA_SWDMA2,
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -442,17 +442,6 @@ static unsigned int __devinit init_chips
 	return dev->irq;
 }
 
-static void __devinit init_hwif_pdc202new(ide_hwif_t *hwif)
-{
-	hwif->set_pio_mode = &pdcnew_set_pio_mode;
-	hwif->set_dma_mode = &pdcnew_set_dma_mode;
-
-	hwif->quirkproc = &pdcnew_quirkproc;
-	hwif->resetproc = &pdcnew_reset;
-
-	hwif->cable_detect = pdcnew_cable_detect;
-}
-
 static struct pci_dev * __devinit pdc20270_get_dev2(struct pci_dev *dev)
 {
 	struct pci_dev *dev2;
@@ -476,11 +465,19 @@ static struct pci_dev * __devinit pdc202
 	return NULL;
 }
 
+static const struct ide_port_ops pdcnew_port_ops = {
+	.set_pio_mode		= pdcnew_set_pio_mode,
+	.set_dma_mode		= pdcnew_set_dma_mode,
+	.quirkproc		= pdcnew_quirkproc,
+	.resetproc		= pdcnew_reset,
+	.cable_detect		= pdcnew_cable_detect,
+};
+
 #define DECLARE_PDCNEW_DEV(name_str, udma) \
 	{ \
 		.name		= name_str, \
 		.init_chipset	= init_chipset_pdcnew, \
-		.init_hwif	= init_hwif_pdc202new, \
+		.port_ops	= &pdcnew_port_ops, \
 		.host_flags	= IDE_HFLAG_POST_SET_MODE | \
 				  IDE_HFLAG_ERROR_STOPS_FIFO | \
 				  IDE_HFLAG_OFF_BOARD, \
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -115,7 +115,7 @@ static void pdc202xx_set_pio_mode(ide_dr
 	pdc202xx_set_mode(drive, XFER_PIO_0 + pio);
 }
 
-static u8 __devinit pdc2026x_old_cable_detect(ide_hwif_t *hwif)
+static u8 __devinit pdc2026x_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u16 CIS, mask = hwif->channel ? (1 << 11) : (1 << 10);
@@ -226,26 +226,6 @@ somebody_else:
 	return (dma_stat & 4) == 4;	/* return 1 if INTR asserted */
 }
 
-static void pdc202xx_dma_lost_irq(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = HWIF(drive);
-
-	if (hwif->resetproc != NULL)
-		hwif->resetproc(drive);
-
-	ide_dma_lost_irq(drive);
-}
-
-static void pdc202xx_dma_timeout(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = HWIF(drive);
-
-	if (hwif->resetproc != NULL)
-		hwif->resetproc(drive);
-
-	ide_dma_timeout(drive);
-}
-
 static void pdc202xx_reset_host (ide_hwif_t *hwif)
 {
 	unsigned long high_16	= hwif->extra_base - 16;
@@ -271,6 +251,18 @@ static void pdc202xx_reset (ide_drive_t 
 	ide_set_max_pio(drive);
 }
 
+static void pdc202xx_dma_lost_irq(ide_drive_t *drive)
+{
+	pdc202xx_reset(drive);
+	ide_dma_lost_irq(drive);
+}
+
+static void pdc202xx_dma_timeout(ide_drive_t *drive)
+{
+	pdc202xx_reset(drive);
+	ide_dma_timeout(drive);
+}
+
 static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev,
 							const char *name)
 {
@@ -281,17 +273,6 @@ static void __devinit init_hwif_pdc202xx
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
-	hwif->set_pio_mode = &pdc202xx_set_pio_mode;
-	hwif->set_dma_mode = &pdc202xx_set_mode;
-
-	hwif->quirkproc = &pdc202xx_quirkproc;
-
-	if (dev->device != PCI_DEVICE_ID_PROMISE_20246) {
-		hwif->resetproc = &pdc202xx_reset;
-
-		hwif->cable_detect = pdc2026x_old_cable_detect;
-	}
-
 	if (hwif->dma_base == 0)
 		return;
 
@@ -357,6 +338,20 @@ static void __devinit pdc202ata4_fixup_i
 	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
 	 IDE_HFLAG_OFF_BOARD)
 
+static const struct ide_port_ops pdc20246_port_ops = {
+	.set_pio_mode		= pdc202xx_set_pio_mode,
+	.set_dma_mode		= pdc202xx_set_mode,
+	.quirkproc		= pdc202xx_quirkproc,
+};
+
+static const struct ide_port_ops pdc2026x_port_ops = {
+	.set_pio_mode		= pdc202xx_set_pio_mode,
+	.set_dma_mode		= pdc202xx_set_mode,
+	.quirkproc		= pdc202xx_quirkproc,
+	.resetproc		= pdc202xx_reset,
+	.cable_detect		= pdc2026x_cable_detect,
+};
+
 #define DECLARE_PDC2026X_DEV(name_str, udma, extra_flags) \
 	{ \
 		.name		= name_str, \
@@ -364,6 +359,7 @@ static void __devinit pdc202ata4_fixup_i
 		.init_hwif	= init_hwif_pdc202xx, \
 		.init_dma	= init_dma_pdc202xx, \
 		.extra		= 48, \
+		.port_ops	= &pdc2026x_port_ops, \
 		.host_flags	= IDE_HFLAGS_PDC202XX | extra_flags, \
 		.pio_mask	= ATA_PIO4, \
 		.mwdma_mask	= ATA_MWDMA2, \
@@ -376,6 +372,7 @@ static const struct ide_port_info pdc202
 		.init_chipset	= init_chipset_pdc202xx,
 		.init_hwif	= init_hwif_pdc202xx,
 		.init_dma	= init_dma_pdc202xx,
+		.port_ops	= &pdc20246_port_ops,
 		.extra		= 16,
 		.host_flags	= IDE_HFLAGS_PDC202XX,
 		.pio_mask	= ATA_PIO4,
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -285,11 +285,6 @@ static u8 __devinit piix_cable_detect(id
 
 static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 {
-	hwif->set_pio_mode = &piix_set_pio_mode;
-	hwif->set_dma_mode = &piix_set_dma_mode;
-
-	hwif->cable_detect = piix_cable_detect;
-
 	if (!hwif->dma_base)
 		return;
 
@@ -306,6 +301,12 @@ static void __devinit init_hwif_ich(ide_
 		hwif->ide_dma_clear_irq = &piix_dma_clear_irq;
 }
 
+static const struct ide_port_ops piix_port_ops = {
+	.set_pio_mode		= piix_set_pio_mode,
+	.set_dma_mode		= piix_set_dma_mode,
+	.cable_detect		= piix_cable_detect,
+};
+
 #ifndef CONFIG_IA64
  #define IDE_HFLAGS_PIIX IDE_HFLAG_LEGACY_IRQS
 #else
@@ -317,6 +318,7 @@ static void __devinit init_hwif_ich(ide_
 		.name		= name_str,		\
 		.init_hwif	= init_hwif_piix,	\
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
+		.port_ops	= &piix_port_ops,	\
 		.host_flags	= IDE_HFLAGS_PIIX,	\
 		.pio_mask	= ATA_PIO4,		\
 		.swdma_mask	= ATA_SWDMA2_ONLY,	\
@@ -330,6 +332,7 @@ static void __devinit init_hwif_ich(ide_
 		.init_chipset	= init_chipset_ich, \
 		.init_hwif	= init_hwif_ich, \
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
+		.port_ops	= &piix_port_ops, \
 		.host_flags	= IDE_HFLAGS_PIIX, \
 		.pio_mask	= ATA_PIO4, \
 		.swdma_mask	= ATA_SWDMA2_ONLY, \
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -292,19 +292,22 @@ static int sc1200_resume (struct pci_dev
  */
 static void __devinit init_hwif_sc1200 (ide_hwif_t *hwif)
 {
-	hwif->set_pio_mode = &sc1200_set_pio_mode;
-	hwif->set_dma_mode = &sc1200_set_dma_mode;
-
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->udma_filter = sc1200_udma_filter;
 	hwif->ide_dma_end   = &sc1200_ide_dma_end;
 }
 
+static const struct ide_port_ops sc1200_port_ops = {
+	.set_pio_mode		= sc1200_set_pio_mode,
+	.set_dma_mode		= sc1200_set_dma_mode,
+	.udma_filter		= sc1200_udma_filter,
+};
+
 static const struct ide_port_info sc1200_chipset __devinitdata = {
 	.name		= "SC1200",
 	.init_hwif	= init_hwif_sc1200,
+	.port_ops	= &sc1200_port_ops,
 	.host_flags	= IDE_HFLAG_SERIALIZE |
 			  IDE_HFLAG_POST_SET_MODE |
 			  IDE_HFLAG_ABUSE_DMA_MODES,
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -675,24 +675,27 @@ static void __devinit init_hwif_scc(ide_
 
 	hwif->dma_setup = scc_dma_setup;
 	hwif->ide_dma_end = scc_ide_dma_end;
-	hwif->set_pio_mode = scc_set_pio_mode;
-	hwif->set_dma_mode = scc_set_dma_mode;
 	hwif->ide_dma_test_irq = scc_dma_test_irq;
-	hwif->udma_filter = scc_udma_filter;
 
 	if (in_be32((void __iomem *)(hwif->config_data + 0xff0)) & CCKCTRL_ATACLKOEN)
 		hwif->ultra_mask = ATA_UDMA6; /* 133MHz */
 	else
 		hwif->ultra_mask = ATA_UDMA5; /* 100MHz */
-
-	hwif->cable_detect = scc_cable_detect;
 }
 
+static const struct ide_port_ops scc_port_ops = {
+	.set_pio_mode		= scc_set_pio_mode,
+	.set_dma_mode		= scc_set_dma_mode,
+	.udma_filter		= scc_udma_filter,
+	.cable_detect		= scc_cable_detect,
+};
+
 #define DECLARE_SCC_DEV(name_str)			\
   {							\
       .name		= name_str,			\
       .init_iops	= init_iops_scc,		\
       .init_hwif	= init_hwif_scc,		\
+      .port_ops		= &scc_port_ops,		\
       .host_flags	= IDE_HFLAG_SINGLE,		\
       .pio_mask		= ATA_PIO4,			\
   }
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -312,7 +312,7 @@ static u8 __devinit ata66_svwks_cobalt(i
 	return ATA_CBL_PATA40;
 }
 
-static u8 __devinit ata66_svwks(ide_hwif_t *hwif)
+static u8 __devinit svwks_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
@@ -336,17 +336,18 @@ static u8 __devinit ata66_svwks(ide_hwif
 	return ATA_CBL_PATA40;
 }
 
-static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-
-	hwif->set_pio_mode = &svwks_set_pio_mode;
-	hwif->set_dma_mode = &svwks_set_dma_mode;
-	hwif->udma_filter = &svwks_udma_filter;
+static const struct ide_port_ops osb4_port_ops = {
+	.set_pio_mode		= svwks_set_pio_mode,
+	.set_dma_mode		= svwks_set_dma_mode,
+	.udma_filter		= svwks_udma_filter,
+};
 
-	if (dev->device != PCI_DEVICE_ID_SERVERWORKS_OSB4IDE)
-		hwif->cable_detect = ata66_svwks;
-}
+static const struct ide_port_ops svwks_port_ops = {
+	.set_pio_mode		= svwks_set_pio_mode,
+	.set_dma_mode		= svwks_set_dma_mode,
+	.udma_filter		= svwks_udma_filter,
+	.cable_detect		= svwks_cable_detect,
+};
 
 #define IDE_HFLAGS_SVWKS \
 	(IDE_HFLAG_LEGACY_IRQS | \
@@ -356,7 +357,7 @@ static const struct ide_port_info server
 	{	/* 0 */
 		.name		= "SvrWks OSB4",
 		.init_chipset	= init_chipset_svwks,
-		.init_hwif	= init_hwif_svwks,
+		.port_ops	= &osb4_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -364,7 +365,7 @@ static const struct ide_port_info server
 	},{	/* 1 */
 		.name		= "SvrWks CSB5",
 		.init_chipset	= init_chipset_svwks,
-		.init_hwif	= init_hwif_svwks,
+		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -372,7 +373,7 @@ static const struct ide_port_info server
 	},{	/* 2 */
 		.name		= "SvrWks CSB6",
 		.init_chipset	= init_chipset_svwks,
-		.init_hwif	= init_hwif_svwks,
+		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -380,7 +381,7 @@ static const struct ide_port_info server
 	},{	/* 3 */
 		.name		= "SvrWks CSB6",
 		.init_chipset	= init_chipset_svwks,
-		.init_hwif	= init_hwif_svwks,
+		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -388,7 +389,7 @@ static const struct ide_port_info server
 	},{	/* 4 */
 		.name		= "SvrWks HT1000",
 		.init_chipset	= init_chipset_svwks,
-		.init_hwif	= init_hwif_svwks,
+		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -552,16 +552,6 @@ static void __devinit
 ide_init_sgiioc4(ide_hwif_t * hwif)
 {
 	hwif->mmio = 1;
-	hwif->set_pio_mode = NULL; /* Sets timing for PIO mode */
-	hwif->set_dma_mode = &sgiioc4_set_dma_mode;
-	hwif->selectproc = NULL;/* Use the default routine to select drive */
-	hwif->reset_poll = NULL;/* No HBA specific reset_poll needed */
-	hwif->pre_reset = NULL;	/* No HBA specific pre_set needed */
-	hwif->resetproc = &sgiioc4_resetproc;/* Reset DMA engine,
-						clear interrupts */
-	hwif->maskproc = &sgiioc4_maskproc;	/* Mask on/off NIEN register */
-	hwif->quirkproc = NULL;
-
 	hwif->INB = &sgiioc4_INB;
 
 	if (hwif->dma_base == 0)
@@ -576,8 +566,17 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 	hwif->dma_timeout = &ide_dma_timeout;
 }
 
+static const struct ide_port_ops sgiioc4_port_ops = {
+	.set_dma_mode		= sgiioc4_set_dma_mode,
+	/* reset DMA engine, clear IRQs */
+	.resetproc		= sgiioc4_resetproc,
+	/* mask on/off NIEN register */
+	.maskproc		= sgiioc4_maskproc,
+};
+
 static const struct ide_port_info sgiioc4_port_info __devinitdata = {
 	.chipset		= ide_pci,
+	.port_ops		= &sgiioc4_port_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
 				  IDE_HFLAG_NO_AUTOTUNE,
 	.mwdma_mask		= ATA_MWDMA2_ONLY,
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -735,14 +735,14 @@ static void __devinit init_iops_siimage(
 }
 
 /**
- *	ata66_siimage	-	check for 80 pin cable
+ *	sil_cable_detect	-	cable detection
  *	@hwif: interface to check
  *
  *	Check for the presence of an ATA66 capable cable on the
  *	interface.
  */
 
-static u8 __devinit ata66_siimage(ide_hwif_t *hwif)
+static u8 __devinit sil_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long addr = siimage_selreg(hwif, 0);
@@ -769,25 +769,14 @@ static void __devinit init_hwif_siimage(
 {
 	u8 sata = is_sata(hwif);
 
-	hwif->set_pio_mode = &sil_set_pio_mode;
-	hwif->set_dma_mode = &sil_set_dma_mode;
-	hwif->quirkproc = &sil_quirkproc;
-
 	if (sata) {
 		static int first = 1;
 
-		hwif->reset_poll = &sil_sata_reset_poll;
-		hwif->pre_reset = &sil_sata_pre_reset;
-		hwif->udma_filter = &sil_sata_udma_filter;
-
 		if (first) {
 			printk(KERN_INFO "siimage: For full SATA support you should use the libata sata_sil module.\n");
 			first = 0;
 		}
-	} else
-		hwif->udma_filter = &sil_pata_udma_filter;
-
-	hwif->cable_detect = ata66_siimage;
+	}
 
 	if (hwif->dma_base == 0)
 		return;
@@ -802,21 +791,40 @@ static void __devinit init_hwif_siimage(
 	}
 }
 
-#define DECLARE_SII_DEV(name_str)			\
+static const struct ide_port_ops sil_pata_port_ops = {
+	.set_pio_mode		= sil_set_pio_mode,
+	.set_dma_mode		= sil_set_dma_mode,
+	.quirkproc		= sil_quirkproc,
+	.udma_filter		= sil_pata_udma_filter,
+	.cable_detect		= sil_cable_detect,
+};
+
+static const struct ide_port_ops sil_sata_port_ops = {
+	.set_pio_mode		= sil_set_pio_mode,
+	.set_dma_mode		= sil_set_dma_mode,
+	.reset_poll		= sil_sata_reset_poll,
+	.pre_reset		= sil_sata_pre_reset,
+	.quirkproc		= sil_quirkproc,
+	.udma_filter		= sil_sata_udma_filter,
+	.cable_detect		= sil_cable_detect,
+};
+
+#define DECLARE_SII_DEV(name_str, p_ops)		\
 	{						\
 		.name		= name_str,		\
 		.init_chipset	= init_chipset_siimage,	\
 		.init_iops	= init_iops_siimage,	\
 		.init_hwif	= init_hwif_siimage,	\
+		.port_ops	= p_ops,		\
 		.pio_mask	= ATA_PIO4,		\
 		.mwdma_mask	= ATA_MWDMA2,		\
 		.udma_mask	= ATA_UDMA6,		\
 	}
 
 static const struct ide_port_info siimage_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_SII_DEV("SiI680"),
-	/* 1 */ DECLARE_SII_DEV("SiI3112 Serial ATA"),
-	/* 2 */ DECLARE_SII_DEV("Adaptec AAR-1210SA")
+	/* 0 */ DECLARE_SII_DEV("SiI680",		&sil_pata_port_ops),
+	/* 1 */ DECLARE_SII_DEV("SiI3112 Serial ATA",	&sil_sata_port_ops),
+	/* 2 */ DECLARE_SII_DEV("Adaptec AAR-1210SA",	&sil_sata_port_ops)
 };
 
 /**
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -346,7 +346,7 @@ static void sis_set_dma_mode(ide_drive_t
 		sis_program_timings(drive, speed);
 }
 
-static u8 sis5513_ata133_udma_filter(ide_drive_t *drive)
+static u8 sis_ata133_udma_filter(ide_drive_t *drive)
 {
 	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	u32 regdw = 0;
@@ -519,7 +519,7 @@ static const struct sis_laptop sis_lapto
 	{ 0, }
 };
 
-static u8 __devinit ata66_sis5513(ide_hwif_t *hwif)
+static u8 __devinit sis_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	const struct sis_laptop *lap = &sis_laptop[0];
@@ -548,21 +548,22 @@ static u8 __devinit ata66_sis5513(ide_hw
 	return ata66 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
-static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
-{
-	hwif->set_pio_mode = &sis_set_pio_mode;
-	hwif->set_dma_mode = &sis_set_dma_mode;
-
-	if (chipset_family >= ATA_133)
-		hwif->udma_filter = sis5513_ata133_udma_filter;
+static const struct ide_port_ops sis_port_ops = {
+	.set_pio_mode		= sis_set_pio_mode,
+	.set_dma_mode		= sis_set_dma_mode,
+	.cable_detect		= sis_cable_detect,
+};
 
-	hwif->cable_detect = ata66_sis5513;
-}
+static const struct ide_port_ops sis_ata133_port_ops = {
+	.set_pio_mode		= sis_set_pio_mode,
+	.set_dma_mode		= sis_set_dma_mode,
+	.udma_filter		= sis_ata133_udma_filter,
+	.cable_detect		= sis_cable_detect,
+};
 
 static const struct ide_port_info sis5513_chipset __devinitdata = {
 	.name		= "SIS5513",
 	.init_chipset	= init_chipset_sis5513,
-	.init_hwif	= init_hwif_sis5513,
 	.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_NO_AUTODMA,
 	.pio_mask	= ATA_PIO4,
@@ -577,6 +578,11 @@ static int __devinit sis5513_init_one(st
 	if (sis_find_family(dev) == 0)
 		return -ENOTSUPP;
 
+	if (chipset_family >= ATA_133)
+		d.port_ops = &sis_ata133_port_ops;
+	else
+		d.port_ops = &sis_port_ops;
+
 	d.udma_mask = udma_rates[chipset_family];
 
 	return ide_setup_pci_device(dev, &d);
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -292,10 +292,6 @@ static void __devinit init_hwif_sl82c105
 
 	DBG(("init_hwif_sl82c105(hwif: ide%d)\n", hwif->index));
 
-	hwif->set_pio_mode	= &sl82c105_set_pio_mode;
-	hwif->set_dma_mode	= &sl82c105_set_dma_mode;
-	hwif->resetproc 	= &sl82c105_resetproc;
-
 	if (!hwif->dma_base)
 		return;
 
@@ -321,11 +317,18 @@ static void __devinit init_hwif_sl82c105
 		hwif->serialized = hwif->mate->serialized = 1;
 }
 
+static const struct ide_port_ops sl82c105_port_ops = {
+	.set_pio_mode		= sl82c105_set_pio_mode,
+	.set_dma_mode		= sl82c105_set_dma_mode,
+	.resetproc		= sl82c105_resetproc,
+};
+
 static const struct ide_port_info sl82c105_chipset __devinitdata = {
 	.name		= "W82C105",
 	.init_chipset	= init_chipset_sl82c105,
 	.init_hwif	= init_hwif_sl82c105,
 	.enablebits	= {{0x40,0x01,0x01}, {0x40,0x10,0x10}},
+	.port_ops	= &sl82c105_port_ops,
 	.host_flags	= IDE_HFLAG_IO_32BIT |
 			  IDE_HFLAG_UNMASK_IRQS |
 /* FIXME: check for Compatibility mode in generic IDE PCI code */
Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -125,18 +125,16 @@ static u8 __devinit slc90e66_cable_detec
 	return (reg47 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 }
 
-static void __devinit init_hwif_slc90e66(ide_hwif_t *hwif)
-{
-	hwif->set_pio_mode = &slc90e66_set_pio_mode;
-	hwif->set_dma_mode = &slc90e66_set_dma_mode;
-
-	hwif->cable_detect = slc90e66_cable_detect;
-}
+static const struct ide_port_ops slc90e66_port_ops = {
+	.set_pio_mode		= slc90e66_set_pio_mode,
+	.set_dma_mode		= slc90e66_set_dma_mode,
+	.cable_detect		= slc90e66_cable_detect,
+};
 
 static const struct ide_port_info slc90e66_chipset __devinitdata = {
 	.name		= "SLC90E66",
-	.init_hwif	= init_hwif_slc90e66,
 	.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}},
+	.port_ops	= &slc90e66_port_ops,
 	.host_flags	= IDE_HFLAG_LEGACY_IRQS,
 	.pio_mask	= ATA_PIO4,
 	.swdma_mask	= ATA_SWDMA2_ONLY,
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -157,11 +157,6 @@ static void __devinit init_hwif_tc86c001
 	/* Store the system control register base for convenience... */
 	hwif->config_data = sc_base;
 
-	hwif->set_pio_mode = &tc86c001_set_pio_mode;
-	hwif->set_dma_mode = &tc86c001_set_mode;
-
-	hwif->cable_detect = tc86c001_cable_detect;
-
 	if (!hwif->dma_base)
 		return;
 
@@ -187,10 +182,17 @@ static unsigned int __devinit init_chips
 	return err;
 }
 
+static const struct ide_port_ops tc86c001_port_ops = {
+	.set_pio_mode		= tc86c001_set_pio_mode,
+	.set_dma_mode		= tc86c001_set_mode,
+	.cable_detect		= tc86c001_cable_detect,
+};
+
 static const struct ide_port_info tc86c001_chipset __devinitdata = {
 	.name		= "TC86C001",
 	.init_chipset	= init_chipset_tc86c001,
 	.init_hwif	= init_hwif_tc86c001,
+	.port_ops	= &tc86c001_port_ops,
 	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_OFF_BOARD |
 			  IDE_HFLAG_ABUSE_SET_DMA_MODE,
 	.pio_mask	= ATA_PIO4,
Index: b/drivers/ide/pci/triflex.c
===================================================================
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -87,16 +87,15 @@ static void triflex_set_pio_mode(ide_dri
 	triflex_set_mode(drive, XFER_PIO_0 + pio);
 }
 
-static void __devinit init_hwif_triflex(ide_hwif_t *hwif)
-{
-	hwif->set_pio_mode = &triflex_set_pio_mode;
-	hwif->set_dma_mode = &triflex_set_mode;
-}
+static const struct ide_port_ops triflex_port_ops = {
+	.set_pio_mode		= triflex_set_pio_mode,
+	.set_dma_mode		= triflex_set_mode,
+};
 
 static const struct ide_port_info triflex_device __devinitdata = {
 	.name		= "TRIFLEX",
-	.init_hwif	= init_hwif_triflex,
 	.enablebits	= {{0x80, 0x01, 0x01}, {0x80, 0x02, 0x02}},
+	.port_ops	= &triflex_port_ops,
 	.pio_mask	= ATA_PIO4,
 	.swdma_mask	= ATA_SWDMA2,
 	.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -297,8 +297,6 @@ static void __devinit init_hwif_trm290(i
 	hwif->dma_start 	= &trm290_dma_start;
 	hwif->ide_dma_end	= &trm290_ide_dma_end;
 	hwif->ide_dma_test_irq	= &trm290_ide_dma_test_irq;
-
-	hwif->selectproc = &trm290_selectproc;
 #if 1
 	{
 	/*
@@ -328,10 +326,15 @@ static void __devinit init_hwif_trm290(i
 #endif
 }
 
+static const struct ide_port_ops trm290_port_ops = {
+	.selectproc		= trm290_selectproc,
+};
+
 static const struct ide_port_info trm290_chipset __devinitdata = {
 	.name		= "TRM290",
 	.init_hwif	= init_hwif_trm290,
 	.chipset	= ide_trm290,
+	.port_ops	= &trm290_port_ops,
 	.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
 #if 0 /* play it safe for now */
 			  IDE_HFLAG_TRUST_BIOS_FOR_DMA |
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -415,19 +415,17 @@ static u8 __devinit via82cxxx_cable_dete
 		return ATA_CBL_PATA40;
 }
 
-static void __devinit init_hwif_via82cxxx(ide_hwif_t *hwif)
-{
-	hwif->set_pio_mode = &via_set_pio_mode;
-	hwif->set_dma_mode = &via_set_drive;
-
-	hwif->cable_detect = via82cxxx_cable_detect;
-}
+static const struct ide_port_ops via_port_ops = {
+	.set_pio_mode		= via_set_pio_mode,
+	.set_dma_mode		= via_set_drive,
+	.cable_detect		= via82cxxx_cable_detect,
+};
 
 static const struct ide_port_info via82cxxx_chipset __devinitdata = {
 	.name		= "VP_IDE",
 	.init_chipset	= init_chipset_via82cxxx,
-	.init_hwif	= init_hwif_via82cxxx,
 	.enablebits	= { { 0x40, 0x02, 0x02 }, { 0x40, 0x01, 0x01 } },
+	.port_ops	= &via_port_ops,
 	.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |
 			  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 			  IDE_HFLAG_POST_SET_MODE |
Index: b/drivers/ide/ppc/mpc8xx.c
===================================================================
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -442,6 +442,10 @@ static void m8xx_ide_set_pio_mode(ide_dr
 #endif /* defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_PCMCIA */
 }
 
+static const struct ide_port_ops m8xx_port_ops = {
+	.set_pio_mode		= m8xx_ide_set_pio_mode,
+};
+
 static void
 ide_interrupt_ack (void *dev)
 {
@@ -812,7 +816,7 @@ static int __init mpc8xx_ide_probe(void)
 		ide_init_port_hw(hwif, &hw);
 		hwif->mmio = 1;
 		hwif->pio_mask = ATA_PIO4;
-		hwif->set_pio_mode = m8xx_ide_set_pio_mode;
+		hwif->port_ops = &m8xx_port_ops;
 
 		idx[0] = 0;
 	}
@@ -824,7 +828,7 @@ static int __init mpc8xx_ide_probe(void)
 		ide_init_port_hw(mate, &hw);
 		mate->mmio = 1;
 		mate->pio_mask = ATA_PIO4;
-		mate->set_pio_mode = m8xx_ide_set_pio_mode;
+		mate->port_ops = &m8xx_port_ops;
 
 		idx[1] = 1;
 	}
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -918,8 +918,21 @@ pmac_ide_do_resume(ide_hwif_t *hwif)
 	return 0;
 }
 
+static const struct ide_port_ops pmac_ide_ata6_port_ops = {
+	.set_pio_mode		= pmac_ide_set_pio_mode,
+	.set_dma_mode		= pmac_ide_set_dma_mode,
+	.selectproc		= pmac_ide_kauai_selectproc,
+};
+
+static const struct ide_port_ops pmac_ide_port_ops = {
+	.set_pio_mode		= pmac_ide_set_pio_mode,
+	.set_dma_mode		= pmac_ide_set_dma_mode,
+	.selectproc		= pmac_ide_selectproc,
+};
+
 static const struct ide_port_info pmac_port_info = {
 	.chipset		= ide_pmac,
+	.port_ops		= &pmac_ide_port_ops,
 	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
 				  IDE_HFLAG_POST_SET_MODE |
 				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
@@ -947,12 +960,15 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	pmif->broken_dma = pmif->broken_dma_warn = 0;
 	if (of_device_is_compatible(np, "shasta-ata")) {
 		pmif->kind = controller_sh_ata6;
+		d.port_ops = &pmac_ide_ata6_port_ops;
 		d.udma_mask = ATA_UDMA6;
 	} else if (of_device_is_compatible(np, "kauai-ata")) {
 		pmif->kind = controller_un_ata6;
+		d.port_ops = &pmac_ide_ata6_port_ops;
 		d.udma_mask = ATA_UDMA5;
 	} else if (of_device_is_compatible(np, "K2-UATA")) {
 		pmif->kind = controller_k2_ata6;
+		d.port_ops = &pmac_ide_ata6_port_ops;
 		d.udma_mask = ATA_UDMA5;
 	} else if (of_device_is_compatible(np, "keylargo-ata")) {
 		if (strcmp(np->name, "ata-4") == 0) {
@@ -1035,14 +1051,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	ide_init_port_hw(hwif, hw);
 	hwif->noprobe = pmif->mediabay;
 	hwif->cbl = pmif->cable_80 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
-	hwif->set_pio_mode = pmac_ide_set_pio_mode;
-	if (pmif->kind == controller_un_ata6
-	    || pmif->kind == controller_k2_ata6
-	    || pmif->kind == controller_sh_ata6)
-		hwif->selectproc = pmac_ide_kauai_selectproc;
-	else
-		hwif->selectproc = pmac_ide_selectproc;
-	hwif->set_dma_mode = pmac_ide_set_dma_mode;
 
 	printk(KERN_INFO "ide%d: Found Apple %s controller, bus ID %d%s, irq %d\n",
 	       hwif->index, model_name[pmif->kind], pmif->aapl_bus_id,
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -388,6 +388,32 @@ typedef struct ide_drive_s {
 
 struct ide_port_info;
 
+struct ide_port_ops {
+	/* host specific initialization of devices on a port */
+	void	(*port_init_devs)(struct hwif_s *);
+	/* routine to program host for PIO mode */
+	void	(*set_pio_mode)(ide_drive_t *, const u8);
+	/* routine to program host for DMA mode */
+	void	(*set_dma_mode)(ide_drive_t *, const u8);
+	/* tweaks hardware to select drive */
+	void	(*selectproc)(ide_drive_t *);
+	/* chipset polling based on hba specifics */
+	int	(*reset_poll)(ide_drive_t *);
+	/* chipset specific changes to default for device-hba resets */
+	void	(*pre_reset)(ide_drive_t *);
+	/* routine to reset controller after a disk reset */
+	void	(*resetproc)(ide_drive_t *);
+	/* special host masking for drive selection */
+	void	(*maskproc)(ide_drive_t *, int);
+	/* check host's drive quirk list */
+	void	(*quirkproc)(ide_drive_t *);
+
+	u8	(*mdma_filter)(ide_drive_t *);
+	u8	(*udma_filter)(ide_drive_t *);
+
+	u8	(*cable_detect)(struct hwif_s *);
+};
+
 typedef struct hwif_s {
 	struct hwif_s *next;		/* for linked-list in ide_hwgroup_t */
 	struct hwif_s *mate;		/* other hwif from same PCI chip */
@@ -427,32 +453,7 @@ typedef struct hwif_s {
 
 	void (*rw_disk)(ide_drive_t *, struct request *);
 
-#if 0
-	ide_hwif_ops_t	*hwifops;
-#else
-	/* host specific initialization of devices on a port */
-	void	(*port_init_devs)(struct hwif_s *);
-	/* routine to program host for PIO mode */
-	void	(*set_pio_mode)(ide_drive_t *, const u8);
-	/* routine to program host for DMA mode */
-	void	(*set_dma_mode)(ide_drive_t *, const u8);
-	/* tweaks hardware to select drive */
-	void	(*selectproc)(ide_drive_t *);
-	/* chipset polling based on hba specifics */
-	int	(*reset_poll)(ide_drive_t *);
-	/* chipset specific changes to default for device-hba resets */
-	void	(*pre_reset)(ide_drive_t *);
-	/* routine to reset controller after a disk reset */
-	void	(*resetproc)(ide_drive_t *);
-	/* special host masking for drive selection */
-	void	(*maskproc)(ide_drive_t *, int);
-	/* check host's drive quirk list */
-	void	(*quirkproc)(ide_drive_t *);
-#endif
-	u8 (*mdma_filter)(ide_drive_t *);
-	u8 (*udma_filter)(ide_drive_t *);
-
-	u8 (*cable_detect)(struct hwif_s *);
+	const struct ide_port_ops	*port_ops;
 
 	void (*ata_input_data)(ide_drive_t *, void *, u32);
 	void (*ata_output_data)(ide_drive_t *, void *, u32);
@@ -1108,6 +1109,9 @@ struct ide_port_info {
 	void			(*init_iops)(ide_hwif_t *);
 	void                    (*init_hwif)(ide_hwif_t *);
 	void			(*init_dma)(ide_hwif_t *, unsigned long);
+
+	const struct ide_port_ops	*port_ops;
+
 	ide_pci_enablebit_t	enablebits[2];
 	hwif_chipset_t		chipset;
 	u8			extra;
