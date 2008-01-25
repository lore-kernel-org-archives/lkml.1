Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbYAYVkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbYAYVkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759637AbYAYVkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:40:35 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:16004 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbYAYVkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:40:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=VZh+qHyPKLZ8JF1xT8FK7rFVQOZIlp/cEQfWJPUBi/i/dTL1iuO5WWxxCEUiDLWtvm/cMXrDgn45Rsh1ay4TNpywdVKOVTIonKnynjb1V1/dPKyxZkQx4xRFGmmKdKWFRnkZpdMmCKSxLurwOqFqWOPody3kEa9cIt2eyTN4A3Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates part #1
Date: Fri, 25 Jan 2008 22:51:31 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801252251.31596.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

What's inside:

* hpt366 host driver cleanups (Sergei Shtylyov)

* ide-cd oops fix for dead drives (Aristeu Rozanski)

* unify handling of REQ_TYPE_ATA_TASK and REQ_TYPE_ATA_TASKFILE requests
  (me, heavily based on the earlier patches from Tejun Heo)

* unify LBA28 and LBA48 HPA handling in ide-disk device driver (me)

* cleanups all over the map - remove needless typedefs, dead code, etc.,
  and some bugfixes discovered in the process (me)

Extra thanks to Sergei for feedback and reviewing majority of patches!


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig             |   12 -
 drivers/ide/arm/icside.c        |    2 -
 drivers/ide/cris/ide-cris.c     |    2 -
 drivers/ide/ide-acpi.c          |   16 +-
 drivers/ide/ide-cd.c            |   12 +-
 drivers/ide/ide-disk.c          |  418 ++++++++++++++-------------------
 drivers/ide/ide-dma.c           |   36 +--
 drivers/ide/ide-floppy.c        |  123 ++++-------
 drivers/ide/ide-io.c            |  293 +++++++++++------------
 drivers/ide/ide-iops.c          |   50 +---
 drivers/ide/ide-lib.c           |  207 ++++++++---------
 drivers/ide/ide-probe.c         |   32 +--
 drivers/ide/ide-tape.c          |  124 ++++------
 drivers/ide/ide-taskfile.c      |  492 +++++++++++++++++++-------------------
 drivers/ide/ide.c               |    6 +-
 drivers/ide/mips/au1xxx-ide.c   |    2 -
 drivers/ide/pci/aec62xx.c       |   13 +-
 drivers/ide/pci/alim15x3.c      |    3 -
 drivers/ide/pci/amd74xx.c       |    1 +
 drivers/ide/pci/atiixp.c        |    3 -
 drivers/ide/pci/cmd64x.c        |   10 +-
 drivers/ide/pci/cs5520.c        |    1 +
 drivers/ide/pci/cs5530.c        |    2 -
 drivers/ide/pci/cs5535.c        |    2 +-
 drivers/ide/pci/hpt34x.c        |   12 +-
 drivers/ide/pci/hpt366.c        |  194 +++++++---------
 drivers/ide/pci/it8213.c        |   21 +--
 drivers/ide/pci/pdc202xx_new.c  |   64 ++----
 drivers/ide/pci/pdc202xx_old.c  |   24 +-
 drivers/ide/pci/piix.c          |   17 +-
 drivers/ide/pci/sc1200.c        |  172 +++++---------
 drivers/ide/pci/scc_pata.c      |   14 +-
 drivers/ide/pci/serverworks.c   |   17 +-
 drivers/ide/pci/sgiioc4.c       |    1 -
 drivers/ide/pci/siimage.c       |   29 +--
 drivers/ide/pci/sis5513.c       |   99 ++++----
 drivers/ide/pci/sl82c105.c      |   40 ++--
 drivers/ide/pci/slc90e66.c      |   14 +-
 drivers/ide/pci/tc86c001.c      |    3 +-
 drivers/ide/pci/triflex.c       |    2 -
 drivers/ide/pci/via82cxxx.c     |    1 +
 drivers/ide/ppc/pmac.c          |   51 ++---
 drivers/scsi/ide-scsi.c         |   75 +++---
 include/asm-cris/arch-v10/ide.h |    5 -
 include/asm-cris/arch-v32/ide.h |    5 -
 include/asm-frv/ide.h           |    6 -
 include/asm-powerpc/ide.h       |    3 -
 include/linux/blkdev.h          |    1 -
 include/linux/hdreg.h           |   64 +++---
 include/linux/ide.h             |  322 ++++++++-----------------
 50 files changed, 1265 insertions(+), 1853 deletions(-)


Andrew Morton (1):
      ide: printk fix

Aristeu Rozanski (1):
      ide-io: set REQ_FAILED when drive is dead

Bartlomiej Zolnierkiewicz (62):
      ide: remove ->dma_master field from ide_hwif_t (take 5)
      ide: remove task_ioreg_t typedef (take 2)
      ide: add struct ide_taskfile (take 2)
      ide-disk: merge LBA28 and LBA48 Host Protected Area support code (take 2)
      ide-disk: fix taskfile registers loading order in __ide_do_rw_disk()
      ide-disk: use struct ide_taskfile in __ide_do_rw_disk()
      ide: add ide_tf_load() helper
      ide: add ide_no_data_taskfile() helper
      ide: use do_rw_taskfile() in flagged_taskfile()
      ide-pmac: fix pmac_ide_init_hwif_ports()
      ide: remove IRQF_DISABLED from IRQ flags for IDE IRQ handler
      ide: remove CONFIG_IDEPCI_SHARE_IRQ config option
      ide: remove stale ide.h "configuration options"
      ide-tape: remove dead USE_IOTRACE code
      ide: fix registers loading order for WIN_SMART in execute_drive_cmd()
      ide: fix registers loading order for IDE_NSECTOR_REG in execute_drive_cmd()
      ide: execute_drive_cmd() cleanup
      ide: remove ide_cmd() helper
      ide: use ide_tf_load() in execute_drive_cmd()
      ide: use IDE_TFLAG_LBA48 for REQ_TYPE_ATA_TASKFILE requests
      ide: remove unnecessary writes to HOB taskfile registers
      ide: extend timeout for REQ_TYPE_ATA_{CMD,TASK} requests
      ide: switch idedisk_prepare_flush() to use REQ_TYPE_ATA_TASKFILE requests
      ide: switch ide_task_ioctl() to use REQ_TYPE_ATA_TASKFILE requests
      ide: remove REQ_TYPE_ATA_TASK
      ide-floppy: remove dead code
      ide: CPU endianness doesn't matter for special_t
      ide: remove ata_status_t and atapi_status_t
      ide: remove atapi_error_t (take 2)
      ide: remove atapi_feature_t
      ide: remove ata_nsector_t, ata_data_t and atapi_bcount_t
      ide: remove atapi_ireason_t (take 3)
      ide-cd: fix register loading order in cdrom_start_packet_command()
      ide-{floppy,tape,scsi}: fix register loading order when issuing packet command
      ide: add ide_pktcmd_tf_load() helper
      ide: remove QUIRK_LIST()
      ide: remove SELECT_INTERRUPT()
      ide: remove hwif->intrproc
      ide: remove 'command_type' field from ide_task_t
      ide: remove 'tf_in_flags' field from ide_task_t
      sc1200: remove pointless hwif lookup loop
      ide-disk: fix __ide_do_rw_disk() to use ->OUTBSYNC
      ide-disk: guarantee 400ns delay after writing command register
      ide: merge flagged_taskfile() into do_rw_taskfile()
      ide: convert do_rw_taskfile() to use ->data_phase
      ide: use ->data_phase to set ->handler in do_rw_taskfile()
      ide: remove 'handler' field from ide_task_t (take 2)
      ide-disk: extend timeout for PIO-in commands
      ide-disk: add ide_tf_set_cmd() helper
      ide-disk: use do_rw_taskfile() (take 2)
      ide: fix registers loading order in ide_dump_ata_status()
      ide: add ide_tf_read() helper
      ide-disk: use ide_get_lba_addr()
      ide: kill duplicate code in ide_dump_{ata,atapi}_status()
      ide: make 'extra' field in struct ide_port_info u8
      pdc202xx_new: move PIO programming code to pdcnew_set_pio_mode()
      sis5513: factor out UDMA programming code
      ide: add IDE_HFLAG_ABUSE_SET_DMA_MODE host flag
      sc1200: move DMA timings to timing tables
      ide: remove redundant ->ide_dma_on call from set_using_dma()
      ide: cleanup ide_set_dma()
      ide: remove redundant DMA blacklist check from __ide_dma_on()

Sergei Shtylyov (3):
      hpt366: change timing register masks
      hpt366: kill set_dma_mode() method wrapper
      hpt366: merge set_dma_mode() methods


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index fb06555..ee01e27 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -374,17 +374,6 @@ comment "PCI IDE chipsets support"
 config BLK_DEV_IDEPCI
 	bool
 
-config IDEPCI_SHARE_IRQ
-	bool "Sharing PCI IDE interrupts support"
-	depends on BLK_DEV_IDEPCI
-	help
-	  Some ATA/IDE chipsets have hardware support which allows for
-	  sharing a single IRQ with other cards. To enable support for
-	  this in the ATA/IDE driver, say Y here.
-
-	  It is safe to say Y to this question, in most cases.
-	  If unsure, say N.
-
 config IDEPCI_PCIBUS_ORDER
 	def_bool BLK_DEV_IDE=y && BLK_DEV_IDEPCI
 
@@ -707,7 +696,6 @@ config BLK_DEV_SVWKS
 config BLK_DEV_SGIIOC4
 	tristate "Silicon Graphics IOC4 chipset ATA/ATAPI support"
 	depends on (IA64_SGI_SN2 || IA64_GENERIC) && SGI_IOC4
-	select IDEPCI_SHARE_IRQ
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds PIO & MultiMode DMA-2 support for the SGI IOC4
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 93f71fc..673402f 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -272,8 +272,6 @@ static void icside_set_dma_mode(ide_drive_t *drive, const u8 xfer_mode)
 	case XFER_SW_DMA_0:
 		cycle_time = 480;
 		break;
-	default:
-		return;
 	}
 
 	/*
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 476e0d6..325e608 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -747,8 +747,6 @@ static void cris_set_dma_mode(ide_drive_t *drive, const u8 speed)
 			strobe = ATA_DMA2_STROBE;
 			hold = ATA_DMA2_HOLD;
 			break;
-		default:
-			return;
 	}
 
 	if (speed >= XFER_UDMA_0)
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 899d565..e0bb0cf 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -383,27 +383,19 @@ static int taskfile_load_raw(ide_drive_t *drive,
 	       gtf->tfa[3], gtf->tfa[4], gtf->tfa[5], gtf->tfa[6]);
 
 	memset(&args, 0, sizeof(ide_task_t));
-	args.command_type = IDE_DRIVE_TASK_NO_DATA;
-	args.data_phase   = TASKFILE_NO_DATA;
-	args.handler      = &task_no_data_intr;
 
 	/* convert gtf to IDE Taskfile */
-	args.tfRegister[1] = gtf->tfa[0];	/* 0x1f1 */
-	args.tfRegister[2] = gtf->tfa[1];	/* 0x1f2 */
-	args.tfRegister[3] = gtf->tfa[2];	/* 0x1f3 */
-	args.tfRegister[4] = gtf->tfa[3];	/* 0x1f4 */
-	args.tfRegister[5] = gtf->tfa[4];	/* 0x1f5 */
-	args.tfRegister[6] = gtf->tfa[5];	/* 0x1f6 */
-	args.tfRegister[7] = gtf->tfa[6];	/* 0x1f7 */
+	memcpy(&args.tf_array[7], &gtf->tfa, 7);
+	args.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
 
 	if (ide_noacpitfs) {
 		DEBPRINT("_GTF execution disabled\n");
 		return err;
 	}
 
-	err = ide_raw_taskfile(drive, &args, NULL);
+	err = ide_no_data_taskfile(drive, &args);
 	if (err)
-		printk(KERN_ERR "%s: ide_raw_taskfile failed: %u\n",
+		printk(KERN_ERR "%s: ide_no_data_taskfile failed: %u\n",
 		       __FUNCTION__, err);
 
 	return err;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index c7d77f0..44b033e 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -917,19 +917,13 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 	if (ide_wait_stat(&startstop, drive, 0, BUSY_STAT, WAIT_READY))
 		return startstop;
 
+	/* FIXME: for Virtual DMA we must check harder */
 	if (info->dma)
 		info->dma = !hwif->dma_setup(drive);
 
 	/* Set up the controller registers. */
-	/* FIXME: for Virtual DMA we must check harder */
-	HWIF(drive)->OUTB(info->dma, IDE_FEATURE_REG);
-	HWIF(drive)->OUTB(0, IDE_IREASON_REG);
-	HWIF(drive)->OUTB(0, IDE_SECTOR_REG);
-
-	HWIF(drive)->OUTB(xferlen & 0xff, IDE_BCOUNTL_REG);
-	HWIF(drive)->OUTB(xferlen >> 8  , IDE_BCOUNTH_REG);
-	if (IDE_CONTROL_REG)
-		HWIF(drive)->OUTB(drive->ctl, IDE_CONTROL_REG);
+	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL |
+			   IDE_TFLAG_NO_SELECT_MASK, xferlen, info->dma);
  
 	if (CDROM_CONFIG_FLAGS (drive)->drq_interrupt) {
 		/* waiting for CDB interrupt, not DMA yet. */
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index b178190..d8fdd86 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -129,6 +129,50 @@ static int lba_capacity_is_ok (struct hd_driveid *id)
 	return 0;	/* lba_capacity value may be bad */
 }
 
+static const u8 ide_rw_cmds[] = {
+	WIN_MULTREAD,
+	WIN_MULTWRITE,
+	WIN_MULTREAD_EXT,
+	WIN_MULTWRITE_EXT,
+	WIN_READ,
+	WIN_WRITE,
+	WIN_READ_EXT,
+	WIN_WRITE_EXT,
+	WIN_READDMA,
+	WIN_WRITEDMA,
+	WIN_READDMA_EXT,
+	WIN_WRITEDMA_EXT,
+};
+
+static const u8 ide_data_phases[] = {
+	TASKFILE_MULTI_IN,
+	TASKFILE_MULTI_OUT,
+	TASKFILE_IN,
+	TASKFILE_OUT,
+	TASKFILE_IN_DMA,
+	TASKFILE_OUT_DMA,
+};
+
+static void ide_tf_set_cmd(ide_drive_t *drive, ide_task_t *task, u8 dma)
+{
+	u8 index, lba48, write;
+
+	lba48 = (task->tf_flags & IDE_TFLAG_LBA48) ? 2 : 0;
+	write = (task->tf_flags & IDE_TFLAG_WRITE) ? 1 : 0;
+
+	if (dma)
+		index = drive->vdma ? 4 : 8;
+	else
+		index = drive->mult_count ? 0 : 4;
+
+	task->tf.command = ide_rw_cmds[index + lba48 + write];
+
+	if (dma)
+		index = 8; /* fixup index */
+
+	task->data_phase = ide_data_phases[index / 2 + write];
+}
+
 /*
  * __ide_do_rw_disk() issues READ and WRITE commands to a disk,
  * using LBA if supported, or CHS otherwise, to address sectors.
@@ -137,11 +181,11 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned int dma	= drive->using_dma;
+	u16 nsectors		= (u16)rq->nr_sectors;
 	u8 lba48		= (drive->addressing == 1) ? 1 : 0;
-	task_ioreg_t command	= WIN_NOP;
-	ata_nsector_t		nsectors;
-
-	nsectors.all		= (u16) rq->nr_sectors;
+	ide_task_t		task;
+	struct ide_taskfile	*tf = &task.tf;
+	ide_startstop_t		rc;
 
 	if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) && lba48 && dma) {
 		if (block + rq->nr_sectors > 1ULL << 28)
@@ -155,121 +199,76 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 		ide_map_sg(drive, rq);
 	}
 
-	if (IDE_CONTROL_REG)
-		hwif->OUTB(drive->ctl, IDE_CONTROL_REG);
-
-	/* FIXME: SELECT_MASK(drive, 0) ? */
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_NO_SELECT_MASK;  /* FIXME? */
+	task.tf_flags |= (IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE);
 
 	if (drive->select.b.lba) {
 		if (lba48) {
-			task_ioreg_t tasklets[10];
-
 			pr_debug("%s: LBA=0x%012llx\n", drive->name,
 					(unsigned long long)block);
 
-			tasklets[0] = 0;
-			tasklets[1] = 0;
-			tasklets[2] = nsectors.b.low;
-			tasklets[3] = nsectors.b.high;
-			tasklets[4] = (task_ioreg_t) block;
-			tasklets[5] = (task_ioreg_t) (block>>8);
-			tasklets[6] = (task_ioreg_t) (block>>16);
-			tasklets[7] = (task_ioreg_t) (block>>24);
-			if (sizeof(block) == 4) {
-				tasklets[8] = (task_ioreg_t) 0;
-				tasklets[9] = (task_ioreg_t) 0;
-			} else {
-				tasklets[8] = (task_ioreg_t)((u64)block >> 32);
-				tasklets[9] = (task_ioreg_t)((u64)block >> 40);
+			tf->hob_nsect = (nsectors >> 8) & 0xff;
+			tf->hob_lbal  = (u8)(block >> 24);
+			if (sizeof(block) != 4) {
+				tf->hob_lbam = (u8)((u64)block >> 32);
+				tf->hob_lbah = (u8)((u64)block >> 40);
 			}
+
+			tf->nsect  = nsectors & 0xff;
+			tf->lbal   = (u8) block;
+			tf->lbam   = (u8)(block >>  8);
+			tf->lbah   = (u8)(block >> 16);
 #ifdef DEBUG
 			printk("%s: 0x%02x%02x 0x%02x%02x%02x%02x%02x%02x\n",
-				drive->name, tasklets[3], tasklets[2],
-				tasklets[9], tasklets[8], tasklets[7],
-				tasklets[6], tasklets[5], tasklets[4]);
+				drive->name, tf->hob_nsect, tf->nsect,
+				tf->hob_lbah, tf->hob_lbam, tf->hob_lbal,
+				tf->lbah, tf->lbam, tf->lbal);
 #endif
-			hwif->OUTB(tasklets[1], IDE_FEATURE_REG);
-			hwif->OUTB(tasklets[3], IDE_NSECTOR_REG);
-			hwif->OUTB(tasklets[7], IDE_SECTOR_REG);
-			hwif->OUTB(tasklets[8], IDE_LCYL_REG);
-			hwif->OUTB(tasklets[9], IDE_HCYL_REG);
-
-			hwif->OUTB(tasklets[0], IDE_FEATURE_REG);
-			hwif->OUTB(tasklets[2], IDE_NSECTOR_REG);
-			hwif->OUTB(tasklets[4], IDE_SECTOR_REG);
-			hwif->OUTB(tasklets[5], IDE_LCYL_REG);
-			hwif->OUTB(tasklets[6], IDE_HCYL_REG);
-			hwif->OUTB(0x00|drive->select.all,IDE_SELECT_REG);
+			task.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_OUT_HOB);
 		} else {
-			hwif->OUTB(0x00, IDE_FEATURE_REG);
-			hwif->OUTB(nsectors.b.low, IDE_NSECTOR_REG);
-			hwif->OUTB(block, IDE_SECTOR_REG);
-			hwif->OUTB(block>>=8, IDE_LCYL_REG);
-			hwif->OUTB(block>>=8, IDE_HCYL_REG);
-			hwif->OUTB(((block>>8)&0x0f)|drive->select.all,IDE_SELECT_REG);
+			tf->nsect  = nsectors & 0xff;
+			tf->lbal   = block;
+			tf->lbam   = block >>= 8;
+			tf->lbah   = block >>= 8;
+			tf->device = (block >> 8) & 0xf;
 		}
 	} else {
 		unsigned int sect,head,cyl,track;
 		track = (int)block / drive->sect;
 		sect  = (int)block % drive->sect + 1;
-		hwif->OUTB(sect, IDE_SECTOR_REG);
 		head  = track % drive->head;
 		cyl   = track / drive->head;
 
 		pr_debug("%s: CHS=%u/%u/%u\n", drive->name, cyl, head, sect);
 
-		hwif->OUTB(0x00, IDE_FEATURE_REG);
-		hwif->OUTB(nsectors.b.low, IDE_NSECTOR_REG);
-		hwif->OUTB(cyl, IDE_LCYL_REG);
-		hwif->OUTB(cyl>>8, IDE_HCYL_REG);
-		hwif->OUTB(head|drive->select.all,IDE_SELECT_REG);
+		tf->nsect  = nsectors & 0xff;
+		tf->lbal   = sect;
+		tf->lbam   = cyl;
+		tf->lbah   = cyl >> 8;
+		tf->device = head;
 	}
 
-	if (dma) {
-		if (!hwif->dma_setup(drive)) {
-			if (rq_data_dir(rq)) {
-				command = lba48 ? WIN_WRITEDMA_EXT : WIN_WRITEDMA;
-				if (drive->vdma)
-					command = lba48 ? WIN_WRITE_EXT: WIN_WRITE;
-			} else {
-				command = lba48 ? WIN_READDMA_EXT : WIN_READDMA;
-				if (drive->vdma)
-					command = lba48 ? WIN_READ_EXT: WIN_READ;
-			}
-			hwif->dma_exec_cmd(drive, command);
-			hwif->dma_start(drive);
-			return ide_started;
-		}
-		/* fallback to PIO */
-		ide_init_sg_cmd(drive, rq);
-	}
+	if (rq_data_dir(rq))
+		task.tf_flags |= IDE_TFLAG_WRITE;
 
-	if (rq_data_dir(rq) == READ) {
+	ide_tf_set_cmd(drive, &task, dma);
+	if (!dma)
+		hwif->data_phase = task.data_phase;
+	task.rq = rq;
 
-		if (drive->mult_count) {
-			hwif->data_phase = TASKFILE_MULTI_IN;
-			command = lba48 ? WIN_MULTREAD_EXT : WIN_MULTREAD;
-		} else {
-			hwif->data_phase = TASKFILE_IN;
-			command = lba48 ? WIN_READ_EXT : WIN_READ;
-		}
+	rc = do_rw_taskfile(drive, &task);
 
-		ide_execute_command(drive, command, &task_in_intr, WAIT_CMD, NULL);
-		return ide_started;
-	} else {
-		if (drive->mult_count) {
-			hwif->data_phase = TASKFILE_MULTI_OUT;
-			command = lba48 ? WIN_MULTWRITE_EXT : WIN_MULTWRITE;
-		} else {
-			hwif->data_phase = TASKFILE_OUT;
-			command = lba48 ? WIN_WRITE_EXT : WIN_WRITE;
-		}
-
-		/* FIXME: ->OUTBSYNC ? */
-		hwif->OUTB(command, IDE_COMMAND_REG);
-
-		return pre_task_out_intr(drive, rq);
+	if (rc == ide_stopped && dma) {
+		/* fallback to PIO */
+		task.tf_flags |= IDE_TFLAG_DMA_PIO_FALLBACK;
+		ide_tf_set_cmd(drive, &task, 0);
+		hwif->data_phase = task.data_phase;
+		ide_init_sg_cmd(drive, rq);
+		rc = do_rw_taskfile(drive, &task);
 	}
+
+	return rc;
 }
 
 /*
@@ -307,57 +306,29 @@ static ide_startstop_t ide_do_rw_disk (ide_drive_t *drive, struct request *rq, s
  * Queries for true maximum capacity of the drive.
  * Returns maximum LBA address (> 0) of the drive, 0 if failed.
  */
-static unsigned long idedisk_read_native_max_address(ide_drive_t *drive)
+static u64 idedisk_read_native_max_address(ide_drive_t *drive, int lba48)
 {
 	ide_task_t args;
-	unsigned long addr = 0;
+	struct ide_taskfile *tf = &args.tf;
+	u64 addr = 0;
 
 	/* Create IDE/ATA command request structure */
 	memset(&args, 0, sizeof(ide_task_t));
-	args.tfRegister[IDE_SELECT_OFFSET]	= 0x40;
-	args.tfRegister[IDE_COMMAND_OFFSET]	= WIN_READ_NATIVE_MAX;
-	args.command_type			= IDE_DRIVE_TASK_NO_DATA;
-	args.handler				= &task_no_data_intr;
+	if (lba48)
+		tf->command = WIN_READ_NATIVE_MAX_EXT;
+	else
+		tf->command = WIN_READ_NATIVE_MAX;
+	tf->device  = ATA_LBA;
+	args.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
+	if (lba48)
+		args.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_OUT_HOB);
 	/* submit command request */
-	ide_raw_taskfile(drive, &args, NULL);
+	ide_no_data_taskfile(drive, &args);
 
 	/* if OK, compute maximum address value */
-	if ((args.tfRegister[IDE_STATUS_OFFSET] & 0x01) == 0) {
-		addr = ((args.tfRegister[IDE_SELECT_OFFSET] & 0x0f) << 24)
-		     | ((args.tfRegister[  IDE_HCYL_OFFSET]       ) << 16)
-		     | ((args.tfRegister[  IDE_LCYL_OFFSET]       ) <<  8)
-		     | ((args.tfRegister[IDE_SECTOR_OFFSET]       ));
-		addr++;	/* since the return value is (maxlba - 1), we add 1 */
-	}
-	return addr;
-}
-
-static unsigned long long idedisk_read_native_max_address_ext(ide_drive_t *drive)
-{
-	ide_task_t args;
-	unsigned long long addr = 0;
-
-	/* Create IDE/ATA command request structure */
-	memset(&args, 0, sizeof(ide_task_t));
+	if ((tf->status & 0x01) == 0)
+		addr = ide_get_lba_addr(tf, lba48) + 1;
 
-	args.tfRegister[IDE_SELECT_OFFSET]	= 0x40;
-	args.tfRegister[IDE_COMMAND_OFFSET]	= WIN_READ_NATIVE_MAX_EXT;
-	args.command_type			= IDE_DRIVE_TASK_NO_DATA;
-	args.handler				= &task_no_data_intr;
-        /* submit command request */
-        ide_raw_taskfile(drive, &args, NULL);
-
-	/* if OK, compute maximum address value */
-	if ((args.tfRegister[IDE_STATUS_OFFSET] & 0x01) == 0) {
-		u32 high = (args.hobRegister[IDE_HCYL_OFFSET] << 16) |
-			   (args.hobRegister[IDE_LCYL_OFFSET] <<  8) |
-			    args.hobRegister[IDE_SECTOR_OFFSET];
-		u32 low  = ((args.tfRegister[IDE_HCYL_OFFSET])<<16) |
-			   ((args.tfRegister[IDE_LCYL_OFFSET])<<8) |
-			    (args.tfRegister[IDE_SECTOR_OFFSET]);
-		addr = ((__u64)high << 24) | low;
-		addr++;	/* since the return value is (maxlba - 1), we add 1 */
-	}
 	return addr;
 }
 
@@ -365,67 +336,37 @@ static unsigned long long idedisk_read_native_max_address_ext(ide_drive_t *drive
  * Sets maximum virtual LBA address of the drive.
  * Returns new maximum virtual LBA address (> 0) or 0 on failure.
  */
-static unsigned long idedisk_set_max_address(ide_drive_t *drive, unsigned long addr_req)
+static u64 idedisk_set_max_address(ide_drive_t *drive, u64 addr_req, int lba48)
 {
 	ide_task_t args;
-	unsigned long addr_set = 0;
-	
-	addr_req--;
-	/* Create IDE/ATA command request structure */
-	memset(&args, 0, sizeof(ide_task_t));
-	args.tfRegister[IDE_SECTOR_OFFSET]	= ((addr_req >>  0) & 0xff);
-	args.tfRegister[IDE_LCYL_OFFSET]	= ((addr_req >>  8) & 0xff);
-	args.tfRegister[IDE_HCYL_OFFSET]	= ((addr_req >> 16) & 0xff);
-	args.tfRegister[IDE_SELECT_OFFSET]	= ((addr_req >> 24) & 0x0f) | 0x40;
-	args.tfRegister[IDE_COMMAND_OFFSET]	= WIN_SET_MAX;
-	args.command_type			= IDE_DRIVE_TASK_NO_DATA;
-	args.handler				= &task_no_data_intr;
-	/* submit command request */
-	ide_raw_taskfile(drive, &args, NULL);
-	/* if OK, read new maximum address value */
-	if ((args.tfRegister[IDE_STATUS_OFFSET] & 0x01) == 0) {
-		addr_set = ((args.tfRegister[IDE_SELECT_OFFSET] & 0x0f) << 24)
-			 | ((args.tfRegister[  IDE_HCYL_OFFSET]       ) << 16)
-			 | ((args.tfRegister[  IDE_LCYL_OFFSET]       ) <<  8)
-			 | ((args.tfRegister[IDE_SECTOR_OFFSET]       ));
-		addr_set++;
-	}
-	return addr_set;
-}
-
-static unsigned long long idedisk_set_max_address_ext(ide_drive_t *drive, unsigned long long addr_req)
-{
-	ide_task_t args;
-	unsigned long long addr_set = 0;
+	struct ide_taskfile *tf = &args.tf;
+	u64 addr_set = 0;
 
 	addr_req--;
 	/* Create IDE/ATA command request structure */
 	memset(&args, 0, sizeof(ide_task_t));
-	args.tfRegister[IDE_SECTOR_OFFSET]	= ((addr_req >>  0) & 0xff);
-	args.tfRegister[IDE_LCYL_OFFSET]	= ((addr_req >>= 8) & 0xff);
-	args.tfRegister[IDE_HCYL_OFFSET]	= ((addr_req >>= 8) & 0xff);
-	args.tfRegister[IDE_SELECT_OFFSET]      = 0x40;
-	args.tfRegister[IDE_COMMAND_OFFSET]	= WIN_SET_MAX_EXT;
-	args.hobRegister[IDE_SECTOR_OFFSET]	= (addr_req >>= 8) & 0xff;
-	args.hobRegister[IDE_LCYL_OFFSET]	= (addr_req >>= 8) & 0xff;
-	args.hobRegister[IDE_HCYL_OFFSET]	= (addr_req >>= 8) & 0xff;
-	args.hobRegister[IDE_SELECT_OFFSET]	= 0x40;
-	args.hobRegister[IDE_CONTROL_OFFSET_HOB]= (drive->ctl|0x80);
-	args.command_type			= IDE_DRIVE_TASK_NO_DATA;
-	args.handler				= &task_no_data_intr;
+	tf->lbal     = (addr_req >>  0) & 0xff;
+	tf->lbam     = (addr_req >>= 8) & 0xff;
+	tf->lbah     = (addr_req >>= 8) & 0xff;
+	if (lba48) {
+		tf->hob_lbal = (addr_req >>= 8) & 0xff;
+		tf->hob_lbam = (addr_req >>= 8) & 0xff;
+		tf->hob_lbah = (addr_req >>= 8) & 0xff;
+		tf->command  = WIN_SET_MAX_EXT;
+	} else {
+		tf->device   = (addr_req >>= 8) & 0x0f;
+		tf->command  = WIN_SET_MAX;
+	}
+	tf->device |= ATA_LBA;
+	args.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
+	if (lba48)
+		args.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_OUT_HOB);
 	/* submit command request */
-	ide_raw_taskfile(drive, &args, NULL);
+	ide_no_data_taskfile(drive, &args);
 	/* if OK, compute maximum address value */
-	if ((args.tfRegister[IDE_STATUS_OFFSET] & 0x01) == 0) {
-		u32 high = (args.hobRegister[IDE_HCYL_OFFSET] << 16) |
-			   (args.hobRegister[IDE_LCYL_OFFSET] <<  8) |
-			    args.hobRegister[IDE_SECTOR_OFFSET];
-		u32 low  = ((args.tfRegister[IDE_HCYL_OFFSET])<<16) |
-			   ((args.tfRegister[IDE_LCYL_OFFSET])<<8) |
-			    (args.tfRegister[IDE_SECTOR_OFFSET]);
-		addr_set = ((__u64)high << 24) | low;
-		addr_set++;
-	}
+	if ((tf->status & 0x01) == 0)
+		addr_set = ide_get_lba_addr(tf, lba48) + 1;
+
 	return addr_set;
 }
 
@@ -471,10 +412,8 @@ static void idedisk_check_hpa(ide_drive_t *drive)
 	int lba48 = idedisk_supports_lba48(drive->id);
 
 	capacity = drive->capacity64;
-	if (lba48)
-		set_max = idedisk_read_native_max_address_ext(drive);
-	else
-		set_max = idedisk_read_native_max_address(drive);
+
+	set_max = idedisk_read_native_max_address(drive, lba48);
 
 	if (ide_in_drive_list(drive->id, hpa_list)) {
 		/*
@@ -495,10 +434,8 @@ static void idedisk_check_hpa(ide_drive_t *drive)
 			 capacity, sectors_to_MB(capacity),
 			 set_max, sectors_to_MB(set_max));
 
-	if (lba48)
-		set_max = idedisk_set_max_address_ext(drive, set_max);
-	else
-		set_max = idedisk_set_max_address(drive, set_max);
+	set_max = idedisk_set_max_address(drive, set_max, lba48);
+
 	if (set_max) {
 		drive->capacity64 = set_max;
 		printk(KERN_INFO "%s: Host Protected Area disabled.\n",
@@ -556,32 +493,32 @@ static sector_t idedisk_capacity (ide_drive_t *drive)
 static int smart_enable(ide_drive_t *drive)
 {
 	ide_task_t args;
+	struct ide_taskfile *tf = &args.tf;
 
 	memset(&args, 0, sizeof(ide_task_t));
-	args.tfRegister[IDE_FEATURE_OFFSET]	= SMART_ENABLE;
-	args.tfRegister[IDE_LCYL_OFFSET]	= SMART_LCYL_PASS;
-	args.tfRegister[IDE_HCYL_OFFSET]	= SMART_HCYL_PASS;
-	args.tfRegister[IDE_COMMAND_OFFSET]	= WIN_SMART;
-	args.command_type			= IDE_DRIVE_TASK_NO_DATA;
-	args.handler				= &task_no_data_intr;
-	return ide_raw_taskfile(drive, &args, NULL);
+	tf->feature = SMART_ENABLE;
+	tf->lbam    = SMART_LCYL_PASS;
+	tf->lbah    = SMART_HCYL_PASS;
+	tf->command = WIN_SMART;
+	args.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
+	return ide_no_data_taskfile(drive, &args);
 }
 
 static int get_smart_data(ide_drive_t *drive, u8 *buf, u8 sub_cmd)
 {
 	ide_task_t args;
+	struct ide_taskfile *tf = &args.tf;
 
 	memset(&args, 0, sizeof(ide_task_t));
-	args.tfRegister[IDE_FEATURE_OFFSET]	= sub_cmd;
-	args.tfRegister[IDE_NSECTOR_OFFSET]	= 0x01;
-	args.tfRegister[IDE_LCYL_OFFSET]	= SMART_LCYL_PASS;
-	args.tfRegister[IDE_HCYL_OFFSET]	= SMART_HCYL_PASS;
-	args.tfRegister[IDE_COMMAND_OFFSET]	= WIN_SMART;
-	args.command_type			= IDE_DRIVE_TASK_IN;
-	args.data_phase				= TASKFILE_IN;
-	args.handler				= &task_in_intr;
+	tf->feature = sub_cmd;
+	tf->nsect   = 0x01;
+	tf->lbam    = SMART_LCYL_PASS;
+	tf->lbah    = SMART_HCYL_PASS;
+	tf->command = WIN_SMART;
+	args.tf_flags	= IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
+	args.data_phase	= TASKFILE_IN;
 	(void) smart_enable(drive);
-	return ide_raw_taskfile(drive, &args, buf);
+	return ide_raw_taskfile(drive, &args, buf, 1);
 }
 
 static int proc_idedisk_read_cache
@@ -659,19 +596,20 @@ static ide_proc_entry_t idedisk_proc[] = {
 static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 {
 	ide_drive_t *drive = q->queuedata;
+	ide_task_t task;
 
-	memset(rq->cmd, 0, sizeof(rq->cmd));
-
+	memset(&task, 0, sizeof(task));
 	if (ide_id_has_flush_cache_ext(drive->id) &&
 	    (drive->capacity64 >= (1UL << 28)))
-		rq->cmd[0] = WIN_FLUSH_CACHE_EXT;
+		task.tf.command = WIN_FLUSH_CACHE_EXT;
 	else
-		rq->cmd[0] = WIN_FLUSH_CACHE;
-
+		task.tf.command = WIN_FLUSH_CACHE;
+	task.tf_flags	= IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
+	task.data_phase	= TASKFILE_NO_DATA;
 
-	rq->cmd_type = REQ_TYPE_ATA_TASK;
+	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 	rq->cmd_flags |= REQ_SOFTBARRIER;
-	rq->buffer = rq->cmd;
+	rq->special = &task;
 }
 
 /*
@@ -753,12 +691,11 @@ static int write_cache(ide_drive_t *drive, int arg)
 
 	if (ide_id_has_flush_cache(drive->id)) {
 		memset(&args, 0, sizeof(ide_task_t));
-		args.tfRegister[IDE_FEATURE_OFFSET]	= (arg) ?
+		args.tf.feature = arg ?
 			SETFEATURES_EN_WCACHE : SETFEATURES_DIS_WCACHE;
-		args.tfRegister[IDE_COMMAND_OFFSET]	= WIN_SETFEATURES;
-		args.command_type		= IDE_DRIVE_TASK_NO_DATA;
-		args.handler			= &task_no_data_intr;
-		err = ide_raw_taskfile(drive, &args, NULL);
+		args.tf.command = WIN_SETFEATURES;
+		args.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
+		err = ide_no_data_taskfile(drive, &args);
 		if (err == 0)
 			drive->wcache = arg;
 	}
@@ -774,12 +711,11 @@ static int do_idedisk_flushcache (ide_drive_t *drive)
 
 	memset(&args, 0, sizeof(ide_task_t));
 	if (ide_id_has_flush_cache_ext(drive->id))
-		args.tfRegister[IDE_COMMAND_OFFSET]	= WIN_FLUSH_CACHE_EXT;
+		args.tf.command = WIN_FLUSH_CACHE_EXT;
 	else
-		args.tfRegister[IDE_COMMAND_OFFSET]	= WIN_FLUSH_CACHE;
-	args.command_type			= IDE_DRIVE_TASK_NO_DATA;
-	args.handler				= &task_no_data_intr;
-	return ide_raw_taskfile(drive, &args, NULL);
+		args.tf.command = WIN_FLUSH_CACHE;
+	args.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
+	return ide_no_data_taskfile(drive, &args);
 }
 
 static int set_acoustic (ide_drive_t *drive, int arg)
@@ -790,13 +726,11 @@ static int set_acoustic (ide_drive_t *drive, int arg)
 		return -EINVAL;
 
 	memset(&args, 0, sizeof(ide_task_t));
-	args.tfRegister[IDE_FEATURE_OFFSET]	= (arg) ? SETFEATURES_EN_AAM :
-							  SETFEATURES_DIS_AAM;
-	args.tfRegister[IDE_NSECTOR_OFFSET]	= arg;
-	args.tfRegister[IDE_COMMAND_OFFSET]	= WIN_SETFEATURES;
-	args.command_type = IDE_DRIVE_TASK_NO_DATA;
-	args.handler	  = &task_no_data_intr;
-	ide_raw_taskfile(drive, &args, NULL);
+	args.tf.feature = arg ? SETFEATURES_EN_AAM : SETFEATURES_DIS_AAM;
+	args.tf.nsect   = arg;
+	args.tf.command = WIN_SETFEATURES;
+	args.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
+	ide_no_data_taskfile(drive, &args);
 	drive->acoustic = arg;
 	return 0;
 }
@@ -1057,16 +991,15 @@ static int idedisk_open(struct inode *inode, struct file *filp)
 	if (drive->removable && idkp->openers == 1) {
 		ide_task_t args;
 		memset(&args, 0, sizeof(ide_task_t));
-		args.tfRegister[IDE_COMMAND_OFFSET] = WIN_DOORLOCK;
-		args.command_type = IDE_DRIVE_TASK_NO_DATA;
-		args.handler	  = &task_no_data_intr;
+		args.tf.command = WIN_DOORLOCK;
+		args.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
 		check_disk_change(inode->i_bdev);
 		/*
 		 * Ignore the return code from door_lock,
 		 * since the open() has already succeeded,
 		 * and the door_lock is irrelevant at this point.
 		 */
-		if (drive->doorlocking && ide_raw_taskfile(drive, &args, NULL))
+		if (drive->doorlocking && ide_no_data_taskfile(drive, &args))
 			drive->doorlocking = 0;
 	}
 	return 0;
@@ -1084,10 +1017,9 @@ static int idedisk_release(struct inode *inode, struct file *filp)
 	if (drive->removable && idkp->openers == 1) {
 		ide_task_t args;
 		memset(&args, 0, sizeof(ide_task_t));
-		args.tfRegister[IDE_COMMAND_OFFSET] = WIN_DOORUNLOCK;
-		args.command_type = IDE_DRIVE_TASK_NO_DATA;
-		args.handler	  = &task_no_data_intr;
-		if (drive->doorlocking && ide_raw_taskfile(drive, &args, NULL))
+		args.tf.command = WIN_DOORUNLOCK;
+		args.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
+		if (drive->doorlocking && ide_no_data_taskfile(drive, &args))
 			drive->doorlocking = 0;
 	}
 
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 4703837..18c78ad 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -491,10 +491,6 @@ EXPORT_SYMBOL(ide_dma_host_on);
  
 int __ide_dma_on (ide_drive_t *drive)
 {
-	/* consult the list of known "bad" drives */
-	if (__ide_dma_bad_drive(drive))
-		return 1;
-
 	drive->using_dma = 1;
 	ide_toggle_bounce(drive, 1);
 
@@ -827,22 +823,19 @@ int ide_set_dma(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	int rc;
 
-	rc = ide_dma_check(drive);
+	/*
+	 * Force DMAing for the beginning of the check.
+	 * Some chipsets appear to do interesting
+	 * things, if not checked and cleared.
+	 *   PARANOIA!!!
+	 */
+	hwif->dma_off_quietly(drive);
 
-	switch(rc) {
-	case -1: /* DMA needs to be disabled */
-		hwif->dma_off_quietly(drive);
-		return -1;
-	case  0: /* DMA needs to be enabled */
-		return hwif->ide_dma_on(drive);
-	case  1: /* DMA setting cannot be changed */
-		break;
-	default:
-		BUG();
-		break;
-	}
+	rc = ide_dma_check(drive);
+	if (rc)
+		return rc;
 
-	return rc;
+	return hwif->ide_dma_on(drive);
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
@@ -968,11 +961,6 @@ void ide_setup_dma(ide_hwif_t *hwif, unsigned long base, unsigned num_ports)
 
 	hwif->dma_base = base;
 
-	if (hwif->mate)
-		hwif->dma_master = hwif->channel ? hwif->mate->dma_base : base;
-	else
-		hwif->dma_master = base;
-
 	if (!(hwif->dma_command))
 		hwif->dma_command	= hwif->dma_base;
 	if (!(hwif->dma_vendor1))
@@ -1014,8 +1002,6 @@ void ide_setup_dma(ide_hwif_t *hwif, unsigned long base, unsigned num_ports)
 		       hwif->drives[1].name, (dma_stat & 0x40) ? "DMA" : "pio");
 	}
 	printk("\n");
-
-	BUG_ON(!hwif->dma_master);
 }
 
 EXPORT_SYMBOL_GPL(ide_setup_dma);
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 04a3578..ff8232e 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -369,27 +369,6 @@ typedef struct ide_floppy_obj {
 #define	IDEFLOPPY_IOCTL_FORMAT_START		0x4602
 #define IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS	0x4603
 
-#if 0
-/*
- *	Special requests for our block device strategy routine.
- */
-#define	IDEFLOPPY_FIRST_RQ	90
-
-/*
- * 	IDEFLOPPY_PC_RQ is used to queue a packet command in the request queue.
- */
-#define	IDEFLOPPY_PC_RQ		90
-
-#define IDEFLOPPY_LAST_RQ	90
-
-/*
- *	A macro which can be used to check if a given request command
- *	originated in the driver or in the buffer cache layer.
- */
-#define IDEFLOPPY_RQ_CMD(cmd) 	((cmd >= IDEFLOPPY_FIRST_RQ) && (cmd <= IDEFLOPPY_LAST_RQ))
-
-#endif
-
 /*
  *	Error codes which are returned in rq->errors to the higher part
  *	of the driver.
@@ -793,9 +772,8 @@ static void idefloppy_retry_pc (ide_drive_t *drive)
 {
 	idefloppy_pc_t *pc;
 	struct request *rq;
-	atapi_error_t error;
 
-	error.all = HWIF(drive)->INB(IDE_ERROR_REG);
+	(void)drive->hwif->INB(IDE_ERROR_REG);
 	pc = idefloppy_next_pc_storage(drive);
 	rq = idefloppy_next_rq_storage(drive);
 	idefloppy_create_request_sense_cmd(pc);
@@ -809,12 +787,12 @@ static void idefloppy_retry_pc (ide_drive_t *drive)
 static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	atapi_status_t status;
-	atapi_bcount_t bcount;
-	atapi_ireason_t ireason;
+	ide_hwif_t *hwif = drive->hwif;
 	idefloppy_pc_t *pc = floppy->pc;
 	struct request *rq = pc->rq;
 	unsigned int temp;
+	u16 bcount;
+	u8 stat, ireason;
 
 	debug_log(KERN_INFO "ide-floppy: Reached %s interrupt handler\n",
 		__FUNCTION__);
@@ -830,16 +808,16 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	}
 
 	/* Clear the interrupt */
-	status.all = HWIF(drive)->INB(IDE_STATUS_REG);
+	stat = drive->hwif->INB(IDE_STATUS_REG);
 
-	if (!status.b.drq) {			/* No more interrupts */
+	if ((stat & DRQ_STAT) == 0) {		/* No more interrupts */
 		debug_log(KERN_INFO "Packet command completed, %d bytes "
 			"transferred\n", pc->actually_transferred);
 		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
 
 		local_irq_enable_in_hardirq();
 
-		if (status.b.check || test_bit(PC_DMA_ERROR, &pc->flags)) {
+		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
 			/* Error detected */
 			debug_log(KERN_INFO "ide-floppy: %s: I/O error\n",
 				drive->name);
@@ -870,32 +848,32 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	}
 
 	/* Get the number of bytes to transfer */
-	bcount.b.high = HWIF(drive)->INB(IDE_BCOUNTH_REG);
-	bcount.b.low = HWIF(drive)->INB(IDE_BCOUNTL_REG);
+	bcount = (hwif->INB(IDE_BCOUNTH_REG) << 8) |
+		  hwif->INB(IDE_BCOUNTL_REG);
 	/* on this interrupt */
-	ireason.all = HWIF(drive)->INB(IDE_IREASON_REG);
+	ireason = hwif->INB(IDE_IREASON_REG);
 
-	if (ireason.b.cod) {
+	if (ireason & CD) {
 		printk(KERN_ERR "ide-floppy: CoD != 0 in idefloppy_pc_intr\n");
 		return ide_do_reset(drive);
 	}
-	if (ireason.b.io == test_bit(PC_WRITING, &pc->flags)) {
+	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "ide-floppy: We wanted to %s, ",
-			ireason.b.io ? "Write":"Read");
+				(ireason & IO) ? "Write" : "Read");
 		printk(KERN_ERR "but the floppy wants us to %s !\n",
-			ireason.b.io ? "Read":"Write");
+				(ireason & IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
 	if (!test_bit(PC_WRITING, &pc->flags)) {
 		/* Reading - Check that we have enough space */
-		temp = pc->actually_transferred + bcount.all;
+		temp = pc->actually_transferred + bcount;
 		if (temp > pc->request_transfer) {
 			if (temp > pc->buffer_size) {
 				printk(KERN_ERR "ide-floppy: The floppy wants "
 					"to send us more data than expected "
 					"- discarding data\n");
-				idefloppy_discard_data(drive,bcount.all);
+				idefloppy_discard_data(drive, bcount);
 				BUG_ON(HWGROUP(drive)->handler != NULL);
 				ide_set_handler(drive,
 						&idefloppy_pc_intr,
@@ -911,23 +889,21 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	if (test_bit(PC_WRITING, &pc->flags)) {
 		if (pc->buffer != NULL)
 			/* Write the current buffer */
-			HWIF(drive)->atapi_output_bytes(drive,
-						pc->current_position,
-						bcount.all);
+			hwif->atapi_output_bytes(drive, pc->current_position,
+						 bcount);
 		else
-			idefloppy_output_buffers(drive, pc, bcount.all);
+			idefloppy_output_buffers(drive, pc, bcount);
 	} else {
 		if (pc->buffer != NULL)
 			/* Read the current buffer */
-			HWIF(drive)->atapi_input_bytes(drive,
-						pc->current_position,
-						bcount.all);
+			hwif->atapi_input_bytes(drive, pc->current_position,
+						bcount);
 		else
-			idefloppy_input_buffers(drive, pc, bcount.all);
+			idefloppy_input_buffers(drive, pc, bcount);
 	}
 	/* Update the current position */
-	pc->actually_transferred += bcount.all;
-	pc->current_position += bcount.all;
+	pc->actually_transferred += bcount;
+	pc->current_position += bcount;
 
 	BUG_ON(HWGROUP(drive)->handler != NULL);
 	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);		/* And set the interrupt handler again */
@@ -943,15 +919,15 @@ static ide_startstop_t idefloppy_transfer_pc (ide_drive_t *drive)
 {
 	ide_startstop_t startstop;
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	atapi_ireason_t ireason;
+	u8 ireason;
 
 	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
 		printk(KERN_ERR "ide-floppy: Strange, packet command "
 				"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason.all = HWIF(drive)->INB(IDE_IREASON_REG);
-	if (!ireason.b.cod || ireason.b.io) {
+	ireason = drive->hwif->INB(IDE_IREASON_REG);
+	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) while "
 				"issuing a packet command\n");
 		return ide_do_reset(drive);
@@ -991,15 +967,15 @@ static ide_startstop_t idefloppy_transfer_pc1 (ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_startstop_t startstop;
-	atapi_ireason_t ireason;
+	u8 ireason;
 
 	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
 		printk(KERN_ERR "ide-floppy: Strange, packet command "
 				"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason.all = HWIF(drive)->INB(IDE_IREASON_REG);
-	if (!ireason.b.cod || ireason.b.io) {
+	ireason = drive->hwif->INB(IDE_IREASON_REG);
+	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) "
 				"while issuing a packet command\n");
 		return ide_do_reset(drive);
@@ -1041,21 +1017,9 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
-	atapi_feature_t feature;
-	atapi_bcount_t bcount;
 	ide_handler_t *pkt_xfer_routine;
-
-#if 0 /* Accessing floppy->pc is not valid here, the previous pc may be gone
-         and have lived on another thread's stack; that stack may have become
-         unmapped meanwhile (CONFIG_DEBUG_PAGEALLOC). */
-#if IDEFLOPPY_DEBUG_BUGS
-	if (floppy->pc->c[0] == IDEFLOPPY_REQUEST_SENSE_CMD &&
-	    pc->c[0] == IDEFLOPPY_REQUEST_SENSE_CMD) {
-		printk(KERN_ERR "ide-floppy: possible ide-floppy.c bug - "
-			"Two request sense in serial were issued\n");
-	}
-#endif /* IDEFLOPPY_DEBUG_BUGS */
-#endif
+	u16 bcount;
+	u8 dma;
 
 	if (floppy->failed_pc == NULL &&
 	    pc->c[0] != IDEFLOPPY_REQUEST_SENSE_CMD)
@@ -1093,25 +1057,20 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 	/* We haven't transferred any data yet */
 	pc->actually_transferred = 0;
 	pc->current_position = pc->buffer;
-	bcount.all = min(pc->request_transfer, 63 * 1024);
+	bcount = min(pc->request_transfer, 63 * 1024);
 
 	if (test_and_clear_bit(PC_DMA_ERROR, &pc->flags))
 		ide_dma_off(drive);
 
-	feature.all = 0;
+	dma = 0;
 
 	if (test_bit(PC_DMA_RECOMMENDED, &pc->flags) && drive->using_dma)
-		feature.b.dma = !hwif->dma_setup(drive);
+		dma = !hwif->dma_setup(drive);
 
-	if (IDE_CONTROL_REG)
-		HWIF(drive)->OUTB(drive->ctl, IDE_CONTROL_REG);
-	/* Use PIO/DMA */
-	HWIF(drive)->OUTB(feature.all, IDE_FEATURE_REG);
-	HWIF(drive)->OUTB(bcount.b.high, IDE_BCOUNTH_REG);
-	HWIF(drive)->OUTB(bcount.b.low, IDE_BCOUNTL_REG);
-	HWIF(drive)->OUTB(drive->select.all, IDE_SELECT_REG);
+	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
+			   IDE_TFLAG_OUT_DEVICE, bcount, dma);
 
-	if (feature.b.dma) {	/* Begin DMA, if necessary */
+	if (dma) {	/* Begin DMA, if necessary */
 		set_bit(PC_DMA_IN_PROGRESS, &pc->flags);
 		hwif->dma_start(drive);
 	}
@@ -1665,14 +1624,14 @@ static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 		/* Else assume format_unit has finished, and we're
 		** at 0x10000 */
 	} else {
-		atapi_status_t status;
 		unsigned long flags;
+		u8 stat;
 
 		local_irq_save(flags);
-		status.all = HWIF(drive)->INB(IDE_STATUS_REG);
+		stat = drive->hwif->INB(IDE_STATUS_REG);
 		local_irq_restore(flags);
 
-		progress_indication = !status.b.dsc ? 0 : 0x10000;
+		progress_indication = ((stat & SEEK_STAT) == 0) ? 0 : 0x10000;
 	}
 	if (put_user(progress_indication, arg))
 		return (-EFAULT);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index bef781f..2711b5a 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -189,18 +189,14 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 			return ide_stopped;
 		}
 		if (ide_id_has_flush_cache_ext(drive->id))
-			args->tfRegister[IDE_COMMAND_OFFSET] = WIN_FLUSH_CACHE_EXT;
+			args->tf.command = WIN_FLUSH_CACHE_EXT;
 		else
-			args->tfRegister[IDE_COMMAND_OFFSET] = WIN_FLUSH_CACHE;
-		args->command_type = IDE_DRIVE_TASK_NO_DATA;
-		args->handler	   = &task_no_data_intr;
-		return do_rw_taskfile(drive, args);
+			args->tf.command = WIN_FLUSH_CACHE;
+		goto out_do_tf;
 
 	case idedisk_pm_standby:	/* Suspend step 2 (standby) */
-		args->tfRegister[IDE_COMMAND_OFFSET] = WIN_STANDBYNOW1;
-		args->command_type = IDE_DRIVE_TASK_NO_DATA;
-		args->handler	   = &task_no_data_intr;
-		return do_rw_taskfile(drive, args);
+		args->tf.command = WIN_STANDBYNOW1;
+		goto out_do_tf;
 
 	case idedisk_pm_restore_pio:	/* Resume step 1 (restore PIO) */
 		ide_set_max_pio(drive);
@@ -214,10 +210,8 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 		return ide_stopped;
 
 	case idedisk_pm_idle:		/* Resume step 2 (idle) */
-		args->tfRegister[IDE_COMMAND_OFFSET] = WIN_IDLEIMMEDIATE;
-		args->command_type = IDE_DRIVE_TASK_NO_DATA;
-		args->handler = task_no_data_intr;
-		return do_rw_taskfile(drive, args);
+		args->tf.command = WIN_IDLEIMMEDIATE;
+		goto out_do_tf;
 
 	case ide_pm_restore_dma:	/* Resume step 3 (restore DMA) */
 		/*
@@ -227,7 +221,6 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 		 */
 		if (drive->hwif->ide_dma_on == NULL)
 			break;
-		drive->hwif->dma_off_quietly(drive);
 		/*
 		 * TODO: respect ->using_dma setting
 		 */
@@ -236,6 +229,11 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 	}
 	pm->pm_step = ide_pm_state_completed;
 	return ide_stopped;
+
+out_do_tf:
+	args->tf_flags	 = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
+	args->data_phase = TASKFILE_NO_DATA;
+	return do_rw_taskfile(drive, args);
 }
 
 /**
@@ -298,6 +296,48 @@ static void ide_complete_pm_request (ide_drive_t *drive, struct request *rq)
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
+void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_taskfile *tf = &task->tf;
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data = hwif->INW(IDE_DATA_REG);
+
+		tf->data = data & 0xff;
+		tf->hob_data = (data >> 8) & 0xff;
+	}
+
+	/* be sure we're looking at the low order bits */
+	hwif->OUTB(drive->ctl & ~0x80, IDE_CONTROL_REG);
+
+	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+		tf->nsect  = hwif->INB(IDE_NSECTOR_REG);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+		tf->lbal   = hwif->INB(IDE_SECTOR_REG);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+		tf->lbam   = hwif->INB(IDE_LCYL_REG);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+		tf->lbah   = hwif->INB(IDE_HCYL_REG);
+	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+		tf->device = hwif->INB(IDE_SELECT_REG);
+
+	if (task->tf_flags & IDE_TFLAG_LBA48) {
+		hwif->OUTB(drive->ctl | 0x80, IDE_CONTROL_REG);
+
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+			tf->hob_feature = hwif->INB(IDE_FEATURE_REG);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+			tf->hob_nsect   = hwif->INB(IDE_NSECTOR_REG);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+			tf->hob_lbal    = hwif->INB(IDE_SECTOR_REG);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+			tf->hob_lbam    = hwif->INB(IDE_LCYL_REG);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+			tf->hob_lbah    = hwif->INB(IDE_HCYL_REG);
+	}
+}
+
 /**
  *	ide_end_drive_cmd	-	end an explicit drive command
  *	@drive: command 
@@ -332,51 +372,22 @@ void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
 			args[1] = err;
 			args[2] = hwif->INB(IDE_NSECTOR_REG);
 		}
-	} else if (rq->cmd_type == REQ_TYPE_ATA_TASK) {
-		u8 *args = (u8 *) rq->buffer;
-		if (rq->errors == 0)
-			rq->errors = !OK_STAT(stat,READY_STAT,BAD_STAT);
-
-		if (args) {
-			args[0] = stat;
-			args[1] = err;
-			/* be sure we're looking at the low order bits */
-			hwif->OUTB(drive->ctl & ~0x80, IDE_CONTROL_REG);
-			args[2] = hwif->INB(IDE_NSECTOR_REG);
-			args[3] = hwif->INB(IDE_SECTOR_REG);
-			args[4] = hwif->INB(IDE_LCYL_REG);
-			args[5] = hwif->INB(IDE_HCYL_REG);
-			args[6] = hwif->INB(IDE_SELECT_REG);
-		}
 	} else if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *args = (ide_task_t *) rq->special;
 		if (rq->errors == 0)
 			rq->errors = !OK_STAT(stat,READY_STAT,BAD_STAT);
 			
 		if (args) {
-			if (args->tf_in_flags.b.data) {
-				u16 data				= hwif->INW(IDE_DATA_REG);
-				args->tfRegister[IDE_DATA_OFFSET]	= (data) & 0xFF;
-				args->hobRegister[IDE_DATA_OFFSET]	= (data >> 8) & 0xFF;
-			}
-			args->tfRegister[IDE_ERROR_OFFSET]   = err;
-			/* be sure we're looking at the low order bits */
-			hwif->OUTB(drive->ctl & ~0x80, IDE_CONTROL_REG);
-			args->tfRegister[IDE_NSECTOR_OFFSET] = hwif->INB(IDE_NSECTOR_REG);
-			args->tfRegister[IDE_SECTOR_OFFSET]  = hwif->INB(IDE_SECTOR_REG);
-			args->tfRegister[IDE_LCYL_OFFSET]    = hwif->INB(IDE_LCYL_REG);
-			args->tfRegister[IDE_HCYL_OFFSET]    = hwif->INB(IDE_HCYL_REG);
-			args->tfRegister[IDE_SELECT_OFFSET]  = hwif->INB(IDE_SELECT_REG);
-			args->tfRegister[IDE_STATUS_OFFSET]  = stat;
-
-			if (drive->addressing == 1) {
-				hwif->OUTB(drive->ctl|0x80, IDE_CONTROL_REG);
-				args->hobRegister[IDE_FEATURE_OFFSET]	= hwif->INB(IDE_FEATURE_REG);
-				args->hobRegister[IDE_NSECTOR_OFFSET]	= hwif->INB(IDE_NSECTOR_REG);
-				args->hobRegister[IDE_SECTOR_OFFSET]	= hwif->INB(IDE_SECTOR_REG);
-				args->hobRegister[IDE_LCYL_OFFSET]	= hwif->INB(IDE_LCYL_REG);
-				args->hobRegister[IDE_HCYL_OFFSET]	= hwif->INB(IDE_HCYL_REG);
-			}
+			struct ide_taskfile *tf = &args->tf;
+
+			tf->error = err;
+			tf->status = stat;
+
+			args->tf_flags |= (IDE_TFLAG_IN_TF|IDE_TFLAG_IN_DEVICE);
+			if (args->tf_flags & IDE_TFLAG_LBA48)
+				args->tf_flags |= IDE_TFLAG_IN_HOB;
+
+			ide_tf_read(drive, args);
 		}
 	} else if (blk_pm_request(rq)) {
 		struct request_pm_state *pm = rq->data;
@@ -616,28 +627,6 @@ ide_startstop_t ide_abort(ide_drive_t *drive, const char *msg)
 }
 
 /**
- *	ide_cmd		-	issue a simple drive command
- *	@drive: drive the command is for
- *	@cmd: command byte
- *	@nsect: sector byte
- *	@handler: handler for the command completion
- *
- *	Issue a simple drive command with interrupts.
- *	The drive must be selected beforehand.
- */
-
-static void ide_cmd (ide_drive_t *drive, u8 cmd, u8 nsect,
-		ide_handler_t *handler)
-{
-	ide_hwif_t *hwif = HWIF(drive);
-	if (IDE_CONTROL_REG)
-		hwif->OUTB(drive->ctl,IDE_CONTROL_REG);	/* clear nIEN */
-	SELECT_MASK(drive,0);
-	hwif->OUTB(nsect,IDE_NSECTOR_REG);
-	ide_execute_command(drive, cmd, handler, WAIT_CMD, NULL);
-}
-
-/**
  *	drive_cmd_intr		- 	drive command completion interrupt
  *	@drive: drive the completion interrupt occurred on
  *
@@ -673,32 +662,26 @@ static ide_startstop_t drive_cmd_intr (ide_drive_t *drive)
 	return ide_stopped;
 }
 
-static void ide_init_specify_cmd(ide_drive_t *drive, ide_task_t *task)
+static void ide_tf_set_specify_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 {
-	task->tfRegister[IDE_NSECTOR_OFFSET] = drive->sect;
-	task->tfRegister[IDE_SECTOR_OFFSET]  = drive->sect;
-	task->tfRegister[IDE_LCYL_OFFSET]    = drive->cyl;
-	task->tfRegister[IDE_HCYL_OFFSET]    = drive->cyl>>8;
-	task->tfRegister[IDE_SELECT_OFFSET]  = ((drive->head-1)|drive->select.all)&0xBF;
-	task->tfRegister[IDE_COMMAND_OFFSET] = WIN_SPECIFY;
-
-	task->handler = &set_geometry_intr;
+	tf->nsect   = drive->sect;
+	tf->lbal    = drive->sect;
+	tf->lbam    = drive->cyl;
+	tf->lbah    = drive->cyl >> 8;
+	tf->device  = ((drive->head - 1) | drive->select.all) & ~ATA_LBA;
+	tf->command = WIN_SPECIFY;
 }
 
-static void ide_init_restore_cmd(ide_drive_t *drive, ide_task_t *task)
+static void ide_tf_set_restore_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 {
-	task->tfRegister[IDE_NSECTOR_OFFSET] = drive->sect;
-	task->tfRegister[IDE_COMMAND_OFFSET] = WIN_RESTORE;
-
-	task->handler = &recal_intr;
+	tf->nsect   = drive->sect;
+	tf->command = WIN_RESTORE;
 }
 
-static void ide_init_setmult_cmd(ide_drive_t *drive, ide_task_t *task)
+static void ide_tf_set_setmult_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 {
-	task->tfRegister[IDE_NSECTOR_OFFSET] = drive->mult_req;
-	task->tfRegister[IDE_COMMAND_OFFSET] = WIN_SETMULT;
-
-	task->handler = &set_multmode_intr;
+	tf->nsect   = drive->mult_req;
+	tf->command = WIN_SETMULT;
 }
 
 static ide_startstop_t ide_disk_special(ide_drive_t *drive)
@@ -707,19 +690,19 @@ static ide_startstop_t ide_disk_special(ide_drive_t *drive)
 	ide_task_t args;
 
 	memset(&args, 0, sizeof(ide_task_t));
-	args.command_type = IDE_DRIVE_TASK_NO_DATA;
+	args.data_phase = TASKFILE_NO_DATA;
 
 	if (s->b.set_geometry) {
 		s->b.set_geometry = 0;
-		ide_init_specify_cmd(drive, &args);
+		ide_tf_set_specify_cmd(drive, &args.tf);
 	} else if (s->b.recalibrate) {
 		s->b.recalibrate = 0;
-		ide_init_restore_cmd(drive, &args);
+		ide_tf_set_restore_cmd(drive, &args.tf);
 	} else if (s->b.set_multmode) {
 		s->b.set_multmode = 0;
 		if (drive->mult_req > drive->id->max_multsect)
 			drive->mult_req = drive->id->max_multsect;
-		ide_init_setmult_cmd(drive, &args);
+		ide_tf_set_setmult_cmd(drive, &args.tf);
 	} else if (s->all) {
 		int special = s->all;
 		s->all = 0;
@@ -727,6 +710,9 @@ static ide_startstop_t ide_disk_special(ide_drive_t *drive)
 		return ide_stopped;
 	}
 
+	args.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
+			IDE_TFLAG_CUSTOM_HANDLER;
+
 	do_rw_taskfile(drive, &args);
 
 	return ide_started;
@@ -861,13 +847,17 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 		struct request *rq)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	u8 *args = rq->buffer;
+	ide_task_t ltask;
+	struct ide_taskfile *tf = &ltask.tf;
+
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
- 		ide_task_t *args = rq->special;
+		ide_task_t *task = rq->special;
  
-		if (!args)
+		if (task == NULL)
 			goto done;
 
-		hwif->data_phase = args->data_phase;
+		hwif->data_phase = task->data_phase;
 
 		switch (hwif->data_phase) {
 		case TASKFILE_MULTI_OUT:
@@ -880,55 +870,34 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 			break;
 		}
 
-		if (args->tf_out_flags.all != 0) 
-			return flagged_taskfile(drive, args);
-		return do_rw_taskfile(drive, args);
-	} else if (rq->cmd_type == REQ_TYPE_ATA_TASK) {
-		u8 *args = rq->buffer;
- 
-		if (!args)
-			goto done;
-#ifdef DEBUG
- 		printk("%s: DRIVE_TASK_CMD ", drive->name);
- 		printk("cmd=0x%02x ", args[0]);
- 		printk("fr=0x%02x ", args[1]);
- 		printk("ns=0x%02x ", args[2]);
- 		printk("sc=0x%02x ", args[3]);
- 		printk("lcyl=0x%02x ", args[4]);
- 		printk("hcyl=0x%02x ", args[5]);
- 		printk("sel=0x%02x\n", args[6]);
-#endif
- 		hwif->OUTB(args[1], IDE_FEATURE_REG);
- 		hwif->OUTB(args[3], IDE_SECTOR_REG);
- 		hwif->OUTB(args[4], IDE_LCYL_REG);
- 		hwif->OUTB(args[5], IDE_HCYL_REG);
- 		hwif->OUTB((args[6] & 0xEF)|drive->select.all, IDE_SELECT_REG);
- 		ide_cmd(drive, args[0], args[2], &drive_cmd_intr);
- 		return ide_started;
- 	} else if (rq->cmd_type == REQ_TYPE_ATA_CMD) {
- 		u8 *args = rq->buffer;
-
-		if (!args)
-			goto done;
+		return do_rw_taskfile(drive, task);
+	}
+
+	if (args == NULL)
+		goto done;
+
+	memset(&ltask, 0, sizeof(ltask));
+	if (rq->cmd_type == REQ_TYPE_ATA_CMD) {
 #ifdef DEBUG
- 		printk("%s: DRIVE_CMD ", drive->name);
- 		printk("cmd=0x%02x ", args[0]);
- 		printk("sc=0x%02x ", args[1]);
- 		printk("fr=0x%02x ", args[2]);
- 		printk("xx=0x%02x\n", args[3]);
+		printk("%s: DRIVE_CMD\n", drive->name);
 #endif
- 		if (args[0] == WIN_SMART) {
- 			hwif->OUTB(0x4f, IDE_LCYL_REG);
- 			hwif->OUTB(0xc2, IDE_HCYL_REG);
- 			hwif->OUTB(args[2],IDE_FEATURE_REG);
- 			hwif->OUTB(args[1],IDE_SECTOR_REG);
- 			ide_cmd(drive, args[0], args[3], &drive_cmd_intr);
- 			return ide_started;
- 		}
- 		hwif->OUTB(args[2],IDE_FEATURE_REG);
- 		ide_cmd(drive, args[0], args[1], &drive_cmd_intr);
- 		return ide_started;
+		tf->feature = args[2];
+		if (args[0] == WIN_SMART) {
+			tf->nsect = args[3];
+			tf->lbal  = args[1];
+			tf->lbam  = 0x4f;
+			tf->lbah  = 0xc2;
+			ltask.tf_flags = IDE_TFLAG_OUT_TF;
+		} else {
+			tf->nsect = args[1];
+			ltask.tf_flags = IDE_TFLAG_OUT_FEATURE |
+					 IDE_TFLAG_OUT_NSECT;
+		}
  	}
+	tf->command = args[0];
+	ide_tf_load(drive, &ltask);
+	ide_execute_command(drive, args[0], &drive_cmd_intr, WAIT_WORSTCASE, NULL);
+	return ide_started;
 
 done:
  	/*
@@ -1003,6 +972,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 
 	/* bail early if we've exceeded max_failures */
 	if (drive->max_failures && (drive->failures > drive->max_failures)) {
+		rq->cmd_flags |= REQ_FAILED;
 		goto kill_rq;
 	}
 
@@ -1035,7 +1005,6 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 			ide_config_drive_speed(drive, drive->desired_speed);
 
 		if (rq->cmd_type == REQ_TYPE_ATA_CMD ||
-		    rq->cmd_type == REQ_TYPE_ATA_TASK ||
 		    rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
 			return execute_drive_cmd(drive, rq);
 		else if (blk_pm_request(rq)) {
@@ -1247,8 +1216,12 @@ static void ide_do_request (ide_hwgroup_t *hwgroup, int masked_irq)
 		if (hwgroup->hwif->sharing_irq &&
 		    hwif != hwgroup->hwif &&
 		    hwif->io_ports[IDE_CONTROL_OFFSET]) {
-			/* set nIEN for previous hwif */
-			SELECT_INTERRUPT(drive);
+			/*
+			 * set nIEN for previous hwif, drives in the
+			 * quirk_list may not like intr setups/cleanups
+			 */
+			if (drive->quirk_list != 1)
+				hwif->OUTB(drive->ctl | 2, IDE_CONTROL_REG);
 		}
 		hwgroup->hwif = hwif;
 		hwgroup->drive = drive;
@@ -1454,12 +1427,8 @@ void ide_timer_expiry (unsigned long data)
 			 */
 			spin_unlock(&ide_lock);
 			hwif  = HWIF(drive);
-#if DISABLE_IRQ_NOSYNC
-			disable_irq_nosync(hwif->irq);
-#else
 			/* disable_irq_nosync ?? */
 			disable_irq(hwif->irq);
-#endif /* DISABLE_IRQ_NOSYNC */
 			/* local CPU only,
 			 * as if we were handling an interrupt */
 			local_irq_disable();
@@ -1785,3 +1754,19 @@ int ide_do_drive_cmd (ide_drive_t *drive, struct request *rq, ide_action_t actio
 }
 
 EXPORT_SYMBOL(ide_do_drive_cmd);
+
+void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount, u8 dma)
+{
+	ide_task_t task;
+
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
+			IDE_TFLAG_OUT_FEATURE | tf_flags;
+	task.tf.feature = dma;		/* Use PIO/DMA */
+	task.tf.lbam    = bcount & 0xff;
+	task.tf.lbah    = (bcount >> 8) & 0xff;
+
+	ide_tf_load(drive, &task);
+}
+
+EXPORT_SYMBOL_GPL(ide_pktcmd_tf_load);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index bb9693d..c97c071 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -158,14 +158,6 @@ void default_hwif_mmiops (ide_hwif_t *hwif)
 
 EXPORT_SYMBOL(default_hwif_mmiops);
 
-u32 ide_read_24 (ide_drive_t *drive)
-{
-	u8 hcyl = HWIF(drive)->INB(IDE_HCYL_REG);
-	u8 lcyl = HWIF(drive)->INB(IDE_LCYL_REG);
-	u8 sect = HWIF(drive)->INB(IDE_SECTOR_REG);
-	return (hcyl<<16)|(lcyl<<8)|sect;
-}
-
 void SELECT_DRIVE (ide_drive_t *drive)
 {
 	if (HWIF(drive)->selectproc)
@@ -175,26 +167,12 @@ void SELECT_DRIVE (ide_drive_t *drive)
 
 EXPORT_SYMBOL(SELECT_DRIVE);
 
-void SELECT_INTERRUPT (ide_drive_t *drive)
-{
-	if (HWIF(drive)->intrproc)
-		HWIF(drive)->intrproc(drive);
-	else
-		HWIF(drive)->OUTB(drive->ctl|2, IDE_CONTROL_REG);
-}
-
 void SELECT_MASK (ide_drive_t *drive, int mask)
 {
 	if (HWIF(drive)->maskproc)
 		HWIF(drive)->maskproc(drive, mask);
 }
 
-void QUIRK_LIST (ide_drive_t *drive)
-{
-	if (HWIF(drive)->quirkproc)
-		drive->quirk_list = HWIF(drive)->quirkproc(drive);
-}
-
 /*
  * Some localbus EIDE interfaces require a special access sequence
  * when using 32-bit I/O instructions to transfer data.  We call this
@@ -449,7 +427,6 @@ int drive_is_ready (ide_drive_t *drive)
 	udelay(1);
 #endif
 
-#ifdef CONFIG_IDEPCI_SHARE_IRQ
 	/*
 	 * We do a passive status test under shared PCI interrupts on
 	 * cards that truly share the ATA side interrupt, but may also share
@@ -459,7 +436,6 @@ int drive_is_ready (ide_drive_t *drive)
 	if (IDE_CONTROL_REG)
 		stat = hwif->INB(IDE_ALTSTATUS_REG);
 	else
-#endif /* CONFIG_IDEPCI_SHARE_IRQ */
 		/* Note: this may clear a pending IRQ!! */
 		stat = hwif->INB(IDE_STATUS_REG);
 
@@ -642,9 +618,9 @@ no_80w:
 
 int ide_ata66_check (ide_drive_t *drive, ide_task_t *args)
 {
-	if ((args->tfRegister[IDE_COMMAND_OFFSET] == WIN_SETFEATURES) &&
-	    (args->tfRegister[IDE_SECTOR_OFFSET] > XFER_UDMA_2) &&
-	    (args->tfRegister[IDE_FEATURE_OFFSET] == SETFEATURES_XFER)) {
+	if (args->tf.command == WIN_SETFEATURES &&
+	    args->tf.lbal > XFER_UDMA_2 &&
+	    args->tf.feature == SETFEATURES_XFER) {
 		if (eighty_ninty_three(drive) == 0) {
 			printk(KERN_WARNING "%s: UDMA speeds >UDMA33 cannot "
 					    "be set\n", drive->name);
@@ -662,9 +638,9 @@ int ide_ata66_check (ide_drive_t *drive, ide_task_t *args)
  */
 int set_transfer (ide_drive_t *drive, ide_task_t *args)
 {
-	if ((args->tfRegister[IDE_COMMAND_OFFSET] == WIN_SETFEATURES) &&
-	    (args->tfRegister[IDE_SECTOR_OFFSET] >= XFER_SW_DMA_0) &&
-	    (args->tfRegister[IDE_FEATURE_OFFSET] == SETFEATURES_XFER) &&
+	if (args->tf.command == WIN_SETFEATURES &&
+	    args->tf.lbal >= XFER_SW_DMA_0 &&
+	    args->tf.feature == SETFEATURES_XFER &&
 	    (drive->id->dma_ultra ||
 	     drive->id->dma_mword ||
 	     drive->id->dma_1word))
@@ -902,8 +878,9 @@ EXPORT_SYMBOL(ide_set_handler);
  *	handler and IRQ setup do not race. All IDE command kick off
  *	should go via this function or do equivalent locking.
  */
- 
-void ide_execute_command(ide_drive_t *drive, task_ioreg_t cmd, ide_handler_t *handler, unsigned timeout, ide_expiry_t *expiry)
+
+void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
+			 unsigned timeout, ide_expiry_t *expiry)
 {
 	unsigned long flags;
 	ide_hwgroup_t *hwgroup = HWGROUP(drive);
@@ -1051,8 +1028,7 @@ static void ide_disk_pre_reset(ide_drive_t *drive)
 	drive->special.all = 0;
 	drive->special.b.set_geometry = legacy;
 	drive->special.b.recalibrate  = legacy;
-	if (OK_TO_RESET_CONTROLLER)
-		drive->mult_count = 0;
+	drive->mult_count = 0;
 	if (!drive->keep_settings && !drive->using_dma)
 		drive->mult_req = 0;
 	if (drive->mult_req != drive->mult_count)
@@ -1137,7 +1113,6 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	for (unit = 0; unit < MAX_DRIVES; ++unit)
 		pre_reset(&hwif->drives[unit]);
 
-#if OK_TO_RESET_CONTROLLER
 	if (!IDE_CONTROL_REG) {
 		spin_unlock_irqrestore(&ide_lock, flags);
 		return ide_stopped;
@@ -1174,11 +1149,8 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	 * state when the disks are reset this way. At least, the Winbond
 	 * 553 documentation says that
 	 */
-	if (hwif->resetproc != NULL) {
+	if (hwif->resetproc)
 		hwif->resetproc(drive);
-	}
-	
-#endif	/* OK_TO_RESET_CONTROLLER */
 
 	spin_unlock_irqrestore(&ide_lock, flags);
 	return ide_started;
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 062d3bc..a3bd8e8 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -441,6 +441,12 @@ int ide_set_xfer_rate(ide_drive_t *drive, u8 rate)
 	 * case could happen iff the transfer mode has already been set on
 	 * the device by ide-proc.c::set_xfer_rate()).
 	 */
+	if (rate < XFER_PIO_0) {
+		if (hwif->host_flags & IDE_HFLAG_ABUSE_SET_DMA_MODE)
+			return ide_set_dma_mode(drive, rate);
+		else
+			return ide_config_drive_speed(drive, rate);
+	}
 
 	return ide_set_dma_mode(drive, rate);
 }
@@ -458,8 +464,7 @@ static void ide_dump_opcode(ide_drive_t *drive)
 	spin_unlock(&ide_lock);
 	if (!rq)
 		return;
-	if (rq->cmd_type == REQ_TYPE_ATA_CMD ||
-	    rq->cmd_type == REQ_TYPE_ATA_TASK) {
+	if (rq->cmd_type == REQ_TYPE_ATA_CMD) {
 		char *args = rq->buffer;
 		if (args) {
 			opcode = args[0];
@@ -468,8 +473,7 @@ static void ide_dump_opcode(ide_drive_t *drive)
 	} else if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *args = rq->special;
 		if (args) {
-			task_struct_t *tf = (task_struct_t *) args->tfRegister;
-			opcode = tf->command;
+			opcode = args->tf.command;
 			found = 1;
 		}
 	}
@@ -481,141 +485,118 @@ static void ide_dump_opcode(ide_drive_t *drive)
 		printk("0x%02x\n", opcode);
 }
 
-static u8 ide_dump_ata_status(ide_drive_t *drive, const char *msg, u8 stat)
+u64 ide_get_lba_addr(struct ide_taskfile *tf, int lba48)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-	unsigned long flags;
-	u8 err = 0;
+	u32 high, low;
 
-	local_irq_save(flags);
-	printk("%s: %s: status=0x%02x { ", drive->name, msg, stat);
-	if (stat & BUSY_STAT)
-		printk("Busy ");
-	else {
-		if (stat & READY_STAT)	printk("DriveReady ");
-		if (stat & WRERR_STAT)	printk("DeviceFault ");
-		if (stat & SEEK_STAT)	printk("SeekComplete ");
-		if (stat & DRQ_STAT)	printk("DataRequest ");
-		if (stat & ECC_STAT)	printk("CorrectedError ");
-		if (stat & INDEX_STAT)	printk("Index ");
-		if (stat & ERR_STAT)	printk("Error ");
+	if (lba48)
+		high = (tf->hob_lbah << 16) | (tf->hob_lbam << 8) |
+			tf->hob_lbal;
+	else
+		high = tf->device & 0xf;
+	low  = (tf->lbah << 16) | (tf->lbam << 8) | tf->lbal;
+
+	return ((u64)high << 24) | low;
+}
+EXPORT_SYMBOL_GPL(ide_get_lba_addr);
+
+static void ide_dump_sector(ide_drive_t *drive)
+{
+	ide_task_t task;
+	struct ide_taskfile *tf = &task.tf;
+	int lba48 = (drive->addressing == 1) ? 1 : 0;
+
+	memset(&task, 0, sizeof(task));
+	if (lba48)
+		task.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_HOB_LBA |
+				IDE_TFLAG_LBA48;
+	else
+		task.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_DEVICE;
+
+	ide_tf_read(drive, &task);
+
+	if (lba48 || (tf->device & ATA_LBA))
+		printk(", LBAsect=%llu",
+			(unsigned long long)ide_get_lba_addr(tf, lba48));
+	else
+		printk(", CHS=%d/%d/%d", (tf->lbah << 8) + tf->lbam,
+					 tf->device & 0xf, tf->lbal);
+}
+
+static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
+{
+	printk("{ ");
+	if (err & ABRT_ERR)	printk("DriveStatusError ");
+	if (err & ICRC_ERR)
+		printk((err & ABRT_ERR) ? "BadCRC " : "BadSector ");
+	if (err & ECC_ERR)	printk("UncorrectableError ");
+	if (err & ID_ERR)	printk("SectorIdNotFound ");
+	if (err & TRK0_ERR)	printk("TrackZeroNotFound ");
+	if (err & MARK_ERR)	printk("AddrMarkNotFound ");
+	printk("}");
+	if ((err & (BBD_ERR | ABRT_ERR)) == BBD_ERR ||
+	    (err & (ECC_ERR|ID_ERR|MARK_ERR))) {
+		ide_dump_sector(drive);
+		if (HWGROUP(drive) && HWGROUP(drive)->rq)
+			printk(", sector=%llu",
+			       (unsigned long long)HWGROUP(drive)->rq->sector);
 	}
+	printk("\n");
+}
+
+static void ide_dump_atapi_error(ide_drive_t *drive, u8 err)
+{
+	printk("{ ");
+	if (err & ILI_ERR)	printk("IllegalLengthIndication ");
+	if (err & EOM_ERR)	printk("EndOfMedia ");
+	if (err & ABRT_ERR)	printk("AbortedCommand ");
+	if (err & MCR_ERR)	printk("MediaChangeRequested ");
+	if (err & LFS_ERR)	printk("LastFailedSense=0x%02x ",
+				       (err & LFS_ERR) >> 4);
 	printk("}\n");
-	if ((stat & (BUSY_STAT|ERR_STAT)) == ERR_STAT) {
-		err = hwif->INB(IDE_ERROR_REG);
-		printk("%s: %s: error=0x%02x { ", drive->name, msg, err);
-		if (err & ABRT_ERR)	printk("DriveStatusError ");
-		if (err & ICRC_ERR)
-			printk((err & ABRT_ERR) ? "BadCRC " : "BadSector ");
-		if (err & ECC_ERR)	printk("UncorrectableError ");
-		if (err & ID_ERR)	printk("SectorIdNotFound ");
-		if (err & TRK0_ERR)	printk("TrackZeroNotFound ");
-		if (err & MARK_ERR)	printk("AddrMarkNotFound ");
-		printk("}");
-		if ((err & (BBD_ERR | ABRT_ERR)) == BBD_ERR ||
-		    (err & (ECC_ERR|ID_ERR|MARK_ERR))) {
-			if (drive->addressing == 1) {
-				__u64 sectors = 0;
-				u32 low = 0, high = 0;
-				hwif->OUTB(drive->ctl&~0x80, IDE_CONTROL_REG);
-				low = ide_read_24(drive);
-				hwif->OUTB(drive->ctl|0x80, IDE_CONTROL_REG);
-				high = ide_read_24(drive);
-				sectors = ((__u64)high << 24) | low;
-				printk(", LBAsect=%llu, high=%d, low=%d",
-				       (unsigned long long) sectors,
-				       high, low);
-			} else {
-				u8 cur = hwif->INB(IDE_SELECT_REG);
-				if (cur & 0x40) {	/* using LBA? */
-					printk(", LBAsect=%ld", (unsigned long)
-					 ((cur&0xf)<<24)
-					 |(hwif->INB(IDE_HCYL_REG)<<16)
-					 |(hwif->INB(IDE_LCYL_REG)<<8)
-					 | hwif->INB(IDE_SECTOR_REG));
-				} else {
-					printk(", CHS=%d/%d/%d",
-					 (hwif->INB(IDE_HCYL_REG)<<8) +
-					  hwif->INB(IDE_LCYL_REG),
-					  cur & 0xf,
-					  hwif->INB(IDE_SECTOR_REG));
-				}
-			}
-			if (HWGROUP(drive) && HWGROUP(drive)->rq)
-				printk(", sector=%llu",
-					(unsigned long long)HWGROUP(drive)->rq->sector);
-		}
-		printk("\n");
-	}
-	ide_dump_opcode(drive);
-	local_irq_restore(flags);
-	return err;
 }
 
 /**
- *	ide_dump_atapi_status       -       print human readable atapi status
+ *	ide_dump_status		-	translate ATA/ATAPI error
  *	@drive: drive that status applies to
  *	@msg: text message to print
  *	@stat: status byte to decode
  *
  *	Error reporting, in human readable form (luxurious, but a memory hog).
+ *	Combines the drive name, message and status byte to provide a
+ *	user understandable explanation of the device error.
  */
 
-static u8 ide_dump_atapi_status(ide_drive_t *drive, const char *msg, u8 stat)
+u8 ide_dump_status(ide_drive_t *drive, const char *msg, u8 stat)
 {
 	unsigned long flags;
+	u8 err = 0;
 
-	atapi_status_t status;
-	atapi_error_t error;
-
-	status.all = stat;
-	error.all = 0;
 	local_irq_save(flags);
 	printk("%s: %s: status=0x%02x { ", drive->name, msg, stat);
-	if (status.b.bsy)
+	if (stat & BUSY_STAT)
 		printk("Busy ");
 	else {
-		if (status.b.drdy)	printk("DriveReady ");
-		if (status.b.df)	printk("DeviceFault ");
-		if (status.b.dsc)	printk("SeekComplete ");
-		if (status.b.drq)	printk("DataRequest ");
-		if (status.b.corr)	printk("CorrectedError ");
-		if (status.b.idx)	printk("Index ");
-		if (status.b.check)	printk("Error ");
+		if (stat & READY_STAT)	printk("DriveReady ");
+		if (stat & WRERR_STAT)	printk("DeviceFault ");
+		if (stat & SEEK_STAT)	printk("SeekComplete ");
+		if (stat & DRQ_STAT)	printk("DataRequest ");
+		if (stat & ECC_STAT)	printk("CorrectedError ");
+		if (stat & INDEX_STAT)	printk("Index ");
+		if (stat & ERR_STAT)	printk("Error ");
 	}
 	printk("}\n");
-	if (status.b.check && !status.b.bsy) {
-		error.all = HWIF(drive)->INB(IDE_ERROR_REG);
-		printk("%s: %s: error=0x%02x { ", drive->name, msg, error.all);
-		if (error.b.ili)	printk("IllegalLengthIndication ");
-		if (error.b.eom)	printk("EndOfMedia ");
-		if (error.b.abrt)	printk("AbortedCommand ");
-		if (error.b.mcr)	printk("MediaChangeRequested ");
-		if (error.b.sense_key)	printk("LastFailedSense=0x%02x ",
-						error.b.sense_key);
-		printk("}\n");
+	if ((stat & (BUSY_STAT|ERR_STAT)) == ERR_STAT) {
+		err = drive->hwif->INB(IDE_ERROR_REG);
+		printk("%s: %s: error=0x%02x ", drive->name, msg, err);
+		if (drive->media == ide_disk)
+			ide_dump_ata_error(drive, err);
+		else
+			ide_dump_atapi_error(drive, err);
 	}
 	ide_dump_opcode(drive);
 	local_irq_restore(flags);
-	return error.all;
-}
-
-/**
- *	ide_dump_status		-	translate ATA/ATAPI error
- *	@drive: drive the error occured on
- *	@msg: information string
- *	@stat: status byte
- *
- *	Error reporting, in human readable form (luxurious, but a memory hog).
- *	Combines the drive name, message and status byte to provide a
- *	user understandable explanation of the device error.
- */
-
-u8 ide_dump_status(ide_drive_t *drive, const char *msg, u8 stat)
-{
-	if (drive->media == ide_disk)
-		return ide_dump_ata_status(drive, msg, stat);
-	return ide_dump_atapi_status(drive, msg, stat);
+	return err;
 }
 
 EXPORT_SYMBOL(ide_dump_status);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 0cb3d2b..0379d1f 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -95,10 +95,10 @@ static void ide_disk_init_mult_count(ide_drive_t *drive)
 #ifdef CONFIG_IDEDISK_MULTI_MODE
 		id->multsect = ((id->max_multsect/2) > 1) ? id->max_multsect : 0;
 		id->multsect_valid = id->multsect ? 1 : 0;
-		drive->mult_req = id->multsect_valid ? id->max_multsect : INITIAL_MULT_COUNT;
+		drive->mult_req = id->multsect_valid ? id->max_multsect : 0;
 		drive->special.b.set_multmode = drive->mult_req ? 1 : 0;
 #else	/* original, pre IDE-NFG, per request of AC */
-		drive->mult_req = INITIAL_MULT_COUNT;
+		drive->mult_req = 0;
 		if (drive->mult_req > id->max_multsect)
 			drive->mult_req = id->max_multsect;
 		if (drive->mult_req || ((id->multsect_valid & 1) && id->multsect))
@@ -234,7 +234,10 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 
 	drive->media = ide_disk;
 	printk("%s DISK drive\n", (id->config == 0x848a) ? "CFA" : "ATA" );
-	QUIRK_LIST(drive);
+
+	if (hwif->quirkproc)
+		drive->quirk_list = hwif->quirkproc(drive);
+
 	return;
 
 err_misc:
@@ -830,16 +833,8 @@ static void probe_hwif(ide_hwif_t *hwif)
 
 			drive->nice1 = 1;
 
-			if (hwif->ide_dma_on) {
-				/*
-				 * Force DMAing for the beginning of the check.
-				 * Some chipsets appear to do interesting
-				 * things, if not checked and cleared.
-				 *   PARANOIA!!!
-				 */
-				hwif->dma_off_quietly(drive);
+			if (hwif->ide_dma_on)
 				ide_set_dma(drive);
-			}
 		}
 	}
 
@@ -968,11 +963,6 @@ static int ide_init_queue(ide_drive_t *drive)
  * Much of the code is for correctly detecting/handling irq sharing
  * and irq serialization situations.  This is somewhat complex because
  * it handles static as well as dynamic (PCMCIA) IDE interfaces.
- *
- * The IRQF_DISABLED in sa_flags means ide_intr() is always entered with
- * interrupts completely disabled.  This can be bad for interrupt latency,
- * but anything else has led to problems on some machines.  We re-enable
- * interrupts as much as we can safely do in most places.
  */
 static int init_irq (ide_hwif_t *hwif)
 {
@@ -1055,17 +1045,13 @@ static int init_irq (ide_hwif_t *hwif)
 	 * Allocate the irq, if not already obtained for another hwif
 	 */
 	if (!match || match->irq != hwif->irq) {
-		int sa = IRQF_DISABLED;
+		int sa = 0;
 #if defined(__mc68000__) || defined(CONFIG_APUS)
 		sa = IRQF_SHARED;
 #endif /* __mc68000__ || CONFIG_APUS */
 
-		if (IDE_CHIPSET_IS_PCI(hwif->chipset)) {
+		if (IDE_CHIPSET_IS_PCI(hwif->chipset))
 			sa = IRQF_SHARED;
-#ifndef CONFIG_IDEPCI_SHARE_IRQ
-			sa |= IRQF_DISABLED;
-#endif /* CONFIG_IDEPCI_SHARE_IRQ */
-		}
 
 		if (hwif->io_ports[IDE_CONTROL_OFFSET])
 			/* clear nIEN */
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1495792..3cbca3f 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -615,16 +615,6 @@ typedef struct os_dat_s {
 /*************************** End of tunable parameters ***********************/
 
 /*
- *	Debugging/Performance analysis
- *
- *	I/O trace support
- */
-#define USE_IOTRACE	0
-#if USE_IOTRACE
-#define IO_IDETAPE_FIFO	500
-#endif
-
-/*
  *	Read/Write error simulation
  */
 #define SIMULATE_ERRORS			0
@@ -1818,9 +1808,8 @@ static ide_startstop_t idetape_retry_pc (ide_drive_t *drive)
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t *pc;
 	struct request *rq;
-	atapi_error_t error;
 
-	error.all = HWIF(drive)->INB(IDE_ERROR_REG);
+	(void)drive->hwif->INB(IDE_ERROR_REG);
 	pc = idetape_next_pc_storage(drive);
 	rq = idetape_next_rq_storage(drive);
 	idetape_create_request_sense_cmd(pc);
@@ -1858,15 +1847,13 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
-	atapi_status_t status;
-	atapi_bcount_t bcount;
-	atapi_ireason_t ireason;
 	idetape_pc_t *pc = tape->pc;
-
 	unsigned int temp;
 #if SIMULATE_ERRORS
 	static int error_sim_count = 0;
 #endif
+	u16 bcount;
+	u8 stat, ireason;
 
 #if IDETAPE_DEBUG_LOG
 	if (tape->debug_level >= 4)
@@ -1875,10 +1862,10 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 #endif /* IDETAPE_DEBUG_LOG */	
 
 	/* Clear the interrupt */
-	status.all = HWIF(drive)->INB(IDE_STATUS_REG);
+	stat = hwif->INB(IDE_STATUS_REG);
 
 	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
-		if (HWIF(drive)->ide_dma_end(drive) || status.b.check) {
+		if (hwif->ide_dma_end(drive) || (stat & ERR_STAT)) {
 			/*
 			 * A DMA error is sometimes expected. For example,
 			 * if the tape is crossing a filemark during a
@@ -1912,7 +1899,7 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 	}
 
 	/* No more interrupts */
-	if (!status.b.drq) {
+	if ((stat & DRQ_STAT) == 0) {
 #if IDETAPE_DEBUG_LOG
 		if (tape->debug_level >= 2)
 			printk(KERN_INFO "ide-tape: Packet command completed, %d bytes transferred\n", pc->actually_transferred);
@@ -1927,12 +1914,13 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 		    (++error_sim_count % 100) == 0) {
 			printk(KERN_INFO "ide-tape: %s: simulating error\n",
 				tape->name);
-			status.b.check = 1;
+			stat |= ERR_STAT;
 		}
 #endif
-		if (status.b.check && pc->c[0] == IDETAPE_REQUEST_SENSE_CMD)
-			status.b.check = 0;
-		if (status.b.check || test_bit(PC_DMA_ERROR, &pc->flags)) {	/* Error detected */
+		if ((stat & ERR_STAT) && pc->c[0] == IDETAPE_REQUEST_SENSE_CMD)
+			stat &= ~ERR_STAT;
+		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
+			/* Error detected */
 #if IDETAPE_DEBUG_LOG
 			if (tape->debug_level >= 1)
 				printk(KERN_INFO "ide-tape: %s: I/O error\n",
@@ -1951,7 +1939,7 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 		}
 		pc->error = 0;
 		if (test_bit(PC_WAIT_FOR_DSC, &pc->flags) &&
-		    !status.b.dsc) {
+		    (stat & SEEK_STAT) == 0) {
 			/* Media access command */
 			tape->dsc_polling_start = jiffies;
 			tape->dsc_polling_frequency = IDETAPE_DSC_MA_FAST;
@@ -1973,30 +1961,30 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 		return ide_do_reset(drive);
 	}
 	/* Get the number of bytes to transfer on this interrupt. */
-	bcount.b.high = hwif->INB(IDE_BCOUNTH_REG);
-	bcount.b.low = hwif->INB(IDE_BCOUNTL_REG);
+	bcount = (hwif->INB(IDE_BCOUNTH_REG) << 8) |
+		  hwif->INB(IDE_BCOUNTL_REG);
 
-	ireason.all = hwif->INB(IDE_IREASON_REG);
+	ireason = hwif->INB(IDE_IREASON_REG);
 
-	if (ireason.b.cod) {
+	if (ireason & CD) {
 		printk(KERN_ERR "ide-tape: CoD != 0 in idetape_pc_intr\n");
 		return ide_do_reset(drive);
 	}
-	if (ireason.b.io == test_bit(PC_WRITING, &pc->flags)) {
+	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "ide-tape: We wanted to %s, ",
-			ireason.b.io ? "Write":"Read");
+				(ireason & IO) ? "Write" : "Read");
 		printk(KERN_ERR "ide-tape: but the tape wants us to %s !\n",
-			ireason.b.io ? "Read":"Write");
+				(ireason & IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
 	if (!test_bit(PC_WRITING, &pc->flags)) {
 		/* Reading - Check that we have enough space */
-		temp = pc->actually_transferred + bcount.all;
+		temp = pc->actually_transferred + bcount;
 		if (temp > pc->request_transfer) {
 			if (temp > pc->buffer_size) {
 				printk(KERN_ERR "ide-tape: The tape wants to send us more data than expected - discarding data\n");
-				idetape_discard_data(drive, bcount.all);
+				idetape_discard_data(drive, bcount);
 				ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
 				return ide_started;
 			}
@@ -2008,23 +1996,26 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 	}
 	if (test_bit(PC_WRITING, &pc->flags)) {
 		if (pc->bh != NULL)
-			idetape_output_buffers(drive, pc, bcount.all);
+			idetape_output_buffers(drive, pc, bcount);
 		else
 			/* Write the current buffer */
-			HWIF(drive)->atapi_output_bytes(drive, pc->current_position, bcount.all);
+			hwif->atapi_output_bytes(drive, pc->current_position,
+						 bcount);
 	} else {
 		if (pc->bh != NULL)
-			idetape_input_buffers(drive, pc, bcount.all);
+			idetape_input_buffers(drive, pc, bcount);
 		else
 			/* Read the current buffer */
-			HWIF(drive)->atapi_input_bytes(drive, pc->current_position, bcount.all);
+			hwif->atapi_input_bytes(drive, pc->current_position,
+						bcount);
 	}
 	/* Update the current position */
-	pc->actually_transferred += bcount.all;
-	pc->current_position += bcount.all;
+	pc->actually_transferred += bcount;
+	pc->current_position += bcount;
 #if IDETAPE_DEBUG_LOG
 	if (tape->debug_level >= 2)
-		printk(KERN_INFO "ide-tape: [cmd %x] transferred %d bytes on that interrupt\n", pc->c[0], bcount.all);
+		printk(KERN_INFO "ide-tape: [cmd %x] transferred %d bytes "
+				 "on that interrupt\n", pc->c[0], bcount);
 #endif
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
@@ -2078,28 +2069,28 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t *pc = tape->pc;
-	atapi_ireason_t ireason;
 	int retries = 100;
 	ide_startstop_t startstop;
+	u8 ireason;
 
 	if (ide_wait_stat(&startstop,drive,DRQ_STAT,BUSY_STAT,WAIT_READY)) {
 		printk(KERN_ERR "ide-tape: Strange, packet command initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason.all = hwif->INB(IDE_IREASON_REG);
-	while (retries-- && (!ireason.b.cod || ireason.b.io)) {
+	ireason = hwif->INB(IDE_IREASON_REG);
+	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
 		printk(KERN_ERR "ide-tape: (IO,CoD != (0,1) while issuing "
 				"a packet command, retrying\n");
 		udelay(100);
-		ireason.all = hwif->INB(IDE_IREASON_REG);
+		ireason = hwif->INB(IDE_IREASON_REG);
 		if (retries == 0) {
 			printk(KERN_ERR "ide-tape: (IO,CoD != (0,1) while "
 					"issuing a packet command, ignoring\n");
-			ireason.b.cod = 1;
-			ireason.b.io = 0;
+			ireason |= CD;
+			ireason &= ~IO;
 		}
 	}
-	if (!ireason.b.cod || ireason.b.io) {
+	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-tape: (IO,CoD) != (0,1) while issuing "
 				"a packet command\n");
 		return ide_do_reset(drive);
@@ -2120,8 +2111,8 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
-	atapi_bcount_t bcount;
 	int dma_ok = 0;
+	u16 bcount;
 
 #if IDETAPE_DEBUG_BUGS
 	if (tape->pc->c[0] == IDETAPE_REQUEST_SENSE_CMD &&
@@ -2170,7 +2161,7 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 	pc->actually_transferred = 0;
 	pc->current_position = pc->buffer;
 	/* Request to transfer the entire buffer at once */
-	bcount.all = pc->request_transfer;
+	bcount = pc->request_transfer;
 
 	if (test_and_clear_bit(PC_DMA_ERROR, &pc->flags)) {
 		printk(KERN_WARNING "ide-tape: DMA disabled, "
@@ -2180,12 +2171,9 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 	if (test_bit(PC_DMA_RECOMMENDED, &pc->flags) && drive->using_dma)
 		dma_ok = !hwif->dma_setup(drive);
 
-	if (IDE_CONTROL_REG)
-		hwif->OUTB(drive->ctl, IDE_CONTROL_REG);
-	hwif->OUTB(dma_ok ? 1 : 0, IDE_FEATURE_REG);	/* Use PIO/DMA */
-	hwif->OUTB(bcount.b.high, IDE_BCOUNTH_REG);
-	hwif->OUTB(bcount.b.low, IDE_BCOUNTL_REG);
-	hwif->OUTB(drive->select.all, IDE_SELECT_REG);
+	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
+			   IDE_TFLAG_OUT_DEVICE, bcount, dma_ok);
+
 	if (dma_ok)			/* Will begin DMA later */
 		set_bit(PC_DMA_IN_PROGRESS, &pc->flags);
 	if (test_bit(IDETAPE_DRQ_INTERRUPT, &tape->flags)) {
@@ -2295,11 +2283,11 @@ static ide_startstop_t idetape_media_access_finished (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t *pc = tape->pc;
-	atapi_status_t status;
+	u8 stat;
 
-	status.all = HWIF(drive)->INB(IDE_STATUS_REG);
-	if (status.b.dsc) {
-		if (status.b.check) {
+	stat = drive->hwif->INB(IDE_STATUS_REG);
+	if (stat & SEEK_STAT) {
+		if (stat & ERR_STAT) {
 			/* Error detected */
 			if (pc->c[0] != IDETAPE_TEST_UNIT_READY_CMD)
 				printk(KERN_ERR "ide-tape: %s: I/O error, ",
@@ -2417,7 +2405,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t *pc = NULL;
 	struct request *postponed_rq = tape->postponed_rq;
-	atapi_status_t status;
+	u8 stat;
 
 #if IDETAPE_DEBUG_LOG
 #if 0
@@ -2465,7 +2453,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	 * If the tape is still busy, postpone our request and service
 	 * the other device meanwhile.
 	 */
-	status.all = HWIF(drive)->INB(IDE_STATUS_REG);
+	stat = drive->hwif->INB(IDE_STATUS_REG);
 
 	if (!drive->dsc_overlap && !(rq->cmd[0] & REQ_IDETAPE_PC2))
 		set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
@@ -2481,7 +2469,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		tape->insert_speed = tape->insert_size / 1024 * HZ / (jiffies - tape->insert_time);
 	calculate_speeds(drive);
 	if (!test_and_clear_bit(IDETAPE_IGNORE_DSC, &tape->flags) &&
-	    !status.b.dsc) {
+	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
 			tape->dsc_polling_frequency = tape->best_dsc_rw_frequency;
@@ -2502,9 +2490,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_READ) {
 		tape->buffer_head++;
-#if USE_IOTRACE
-		IO_trace(IO_IDETAPE_FIFO, tape->pipeline_head, tape->buffer_head, tape->tape_head, tape->minor);
-#endif
 		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
 		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors, (struct idetape_bh *)rq->special);
@@ -2512,9 +2497,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
 		tape->buffer_head++;
-#if USE_IOTRACE
-		IO_trace(IO_IDETAPE_FIFO, tape->pipeline_head, tape->buffer_head, tape->tape_head, tape->minor);
-#endif
 		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
 		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors, (struct idetape_bh *)rq->special);
@@ -3241,9 +3223,6 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 	idetape_switch_buffers(tape, new_stage);
 	idetape_add_stage_tail(drive, new_stage);
 	tape->pipeline_head++;
-#if USE_IOTRACE
-	IO_trace(IO_IDETAPE_FIFO, tape->pipeline_head, tape->buffer_head, tape->tape_head, tape->minor);
-#endif
 	calculate_speeds(drive);
 
 	/*
@@ -3493,9 +3472,6 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 		idetape_remove_stage_head(drive);
 		spin_unlock_irqrestore(&tape->spinlock, flags);
 		tape->pipeline_head++;
-#if USE_IOTRACE
-		IO_trace(IO_IDETAPE_FIFO, tape->pipeline_head, tape->buffer_head, tape->tape_head, tape->minor);
-#endif
 		calculate_speeds(drive);
 	}
 #if IDETAPE_DEBUG_BUGS
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 2b60f1b..2d63ea9 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -63,65 +63,78 @@ static void taskfile_output_data(ide_drive_t *drive, void *buffer, u32 wcount)
 	}
 }
 
+void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_taskfile *tf = &task->tf;
+	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+
+	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+		HIHI = 0xFF;
+
+#ifdef DEBUG
+	printk("%s: tf: feat 0x%02x nsect 0x%02x lbal 0x%02x "
+		"lbam 0x%02x lbah 0x%02x dev 0x%02x cmd 0x%02x\n",
+		drive->name, tf->feature, tf->nsect, tf->lbal,
+		tf->lbam, tf->lbah, tf->device, tf->command);
+#endif
+
+	if (IDE_CONTROL_REG)
+		hwif->OUTB(drive->ctl, IDE_CONTROL_REG); /* clear nIEN */
+
+	if ((task->tf_flags & IDE_TFLAG_NO_SELECT_MASK) == 0)
+		SELECT_MASK(drive, 0);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
+		hwif->OUTW((tf->hob_data << 8) | tf->data, IDE_DATA_REG);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+		hwif->OUTB(tf->hob_feature, IDE_FEATURE_REG);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+		hwif->OUTB(tf->hob_nsect, IDE_NSECTOR_REG);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+		hwif->OUTB(tf->hob_lbal, IDE_SECTOR_REG);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+		hwif->OUTB(tf->hob_lbam, IDE_LCYL_REG);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+		hwif->OUTB(tf->hob_lbah, IDE_HCYL_REG);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+		hwif->OUTB(tf->feature, IDE_FEATURE_REG);
+	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+		hwif->OUTB(tf->nsect, IDE_NSECTOR_REG);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+		hwif->OUTB(tf->lbal, IDE_SECTOR_REG);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+		hwif->OUTB(tf->lbam, IDE_LCYL_REG);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+		hwif->OUTB(tf->lbah, IDE_HCYL_REG);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		hwif->OUTB((tf->device & HIHI) | drive->select.all, IDE_SELECT_REG);
+}
+
 int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
 {
 	ide_task_t args;
+
 	memset(&args, 0, sizeof(ide_task_t));
-	args.tfRegister[IDE_NSECTOR_OFFSET]	= 0x01;
+	args.tf.nsect = 0x01;
 	if (drive->media == ide_disk)
-		args.tfRegister[IDE_COMMAND_OFFSET]	= WIN_IDENTIFY;
+		args.tf.command = WIN_IDENTIFY;
 	else
-		args.tfRegister[IDE_COMMAND_OFFSET]	= WIN_PIDENTIFY;
-	args.command_type = IDE_DRIVE_TASK_IN;
-	args.data_phase   = TASKFILE_IN;
-	args.handler	  = &task_in_intr;
-	return ide_raw_taskfile(drive, &args, buf);
+		args.tf.command = WIN_PIDENTIFY;
+	args.tf_flags	= IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
+	args.data_phase	= TASKFILE_IN;
+	return ide_raw_taskfile(drive, &args, buf, 1);
 }
 
-ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
+static int inline task_dma_ok(ide_task_t *task)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	task_struct_t *taskfile	= (task_struct_t *) task->tfRegister;
-	hob_struct_t *hobfile	= (hob_struct_t *) task->hobRegister;
-	u8 HIHI			= (drive->addressing == 1) ? 0xE0 : 0xEF;
-
-	/* ALL Command Block Executions SHALL clear nIEN, unless otherwise */
-	if (IDE_CONTROL_REG) {
-		/* clear nIEN */
-		hwif->OUTB(drive->ctl, IDE_CONTROL_REG);
-	}
-	SELECT_MASK(drive, 0);
-
-	if (drive->addressing == 1) {
-		hwif->OUTB(hobfile->feature, IDE_FEATURE_REG);
-		hwif->OUTB(hobfile->sector_count, IDE_NSECTOR_REG);
-		hwif->OUTB(hobfile->sector_number, IDE_SECTOR_REG);
-		hwif->OUTB(hobfile->low_cylinder, IDE_LCYL_REG);
-		hwif->OUTB(hobfile->high_cylinder, IDE_HCYL_REG);
-	}
-
-	hwif->OUTB(taskfile->feature, IDE_FEATURE_REG);
-	hwif->OUTB(taskfile->sector_count, IDE_NSECTOR_REG);
-	hwif->OUTB(taskfile->sector_number, IDE_SECTOR_REG);
-	hwif->OUTB(taskfile->low_cylinder, IDE_LCYL_REG);
-	hwif->OUTB(taskfile->high_cylinder, IDE_HCYL_REG);
-
-	hwif->OUTB((taskfile->device_head & HIHI) | drive->select.all, IDE_SELECT_REG);
-
-	if (task->handler != NULL) {
-		if (task->prehandler != NULL) {
-			hwif->OUTBSYNC(drive, taskfile->command, IDE_COMMAND_REG);
-			ndelay(400);	/* FIXME */
-			return task->prehandler(drive, task->rq);
-		}
-		ide_execute_command(drive, taskfile->command, task->handler, WAIT_WORSTCASE, NULL);
-		return ide_started;
-	}
-
-	if (!drive->using_dma)
-		return ide_stopped;
+	if (blk_fs_request(task->rq) || (task->tf_flags & IDE_TFLAG_FLAGGED))
+		return 1;
 
-	switch (taskfile->command) {
+	switch (task->tf.command) {
 		case WIN_WRITEDMA_ONCE:
 		case WIN_WRITEDMA:
 		case WIN_WRITEDMA_EXT:
@@ -129,24 +142,79 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 		case WIN_READDMA:
 		case WIN_READDMA_EXT:
 		case WIN_IDENTIFY_DMA:
-			if (!hwif->dma_setup(drive)) {
-				hwif->dma_exec_cmd(drive, taskfile->command);
-				hwif->dma_start(drive);
-				return ide_started;
-			}
-			break;
-		default:
-			if (task->handler == NULL)
-				return ide_stopped;
+			return 1;
 	}
 
-	return ide_stopped;
+	return 0;
+}
+
+static ide_startstop_t task_no_data_intr(ide_drive_t *);
+static ide_startstop_t set_geometry_intr(ide_drive_t *);
+static ide_startstop_t recal_intr(ide_drive_t *);
+static ide_startstop_t set_multmode_intr(ide_drive_t *);
+static ide_startstop_t pre_task_out_intr(ide_drive_t *, struct request *);
+static ide_startstop_t task_in_intr(ide_drive_t *);
+
+ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct ide_taskfile *tf = &task->tf;
+	ide_handler_t *handler = NULL;
+
+	if (task->data_phase == TASKFILE_MULTI_IN ||
+	    task->data_phase == TASKFILE_MULTI_OUT) {
+		if (!drive->mult_count) {
+			printk(KERN_ERR "%s: multimode not set!\n",
+					drive->name);
+			return ide_stopped;
+		}
+	}
+
+	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+		task->tf_flags |= IDE_TFLAG_FLAGGED_SET_IN_FLAGS;
+
+	if ((task->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0)
+		ide_tf_load(drive, task);
+
+	switch (task->data_phase) {
+	case TASKFILE_MULTI_OUT:
+	case TASKFILE_OUT:
+		hwif->OUTBSYNC(drive, tf->command, IDE_COMMAND_REG);
+		ndelay(400);	/* FIXME */
+		return pre_task_out_intr(drive, task->rq);
+	case TASKFILE_MULTI_IN:
+	case TASKFILE_IN:
+		handler = task_in_intr;
+		/* fall-through */
+	case TASKFILE_NO_DATA:
+		if (handler == NULL)
+			handler = task_no_data_intr;
+		/* WIN_{SPECIFY,RESTORE,SETMULT} use custom handlers */
+		if (task->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) {
+			switch (tf->command) {
+			case WIN_SPECIFY: handler = set_geometry_intr;	break;
+			case WIN_RESTORE: handler = recal_intr;		break;
+			case WIN_SETMULT: handler = set_multmode_intr;	break;
+			}
+		}
+		ide_execute_command(drive, tf->command, handler,
+				    WAIT_WORSTCASE, NULL);
+		return ide_started;
+	default:
+		if (task_dma_ok(task) == 0 || drive->using_dma == 0 ||
+		    hwif->dma_setup(drive))
+			return ide_stopped;
+		hwif->dma_exec_cmd(drive, tf->command);
+		hwif->dma_start(drive);
+		return ide_started;
+	}
 }
+EXPORT_SYMBOL_GPL(do_rw_taskfile);
 
 /*
  * set_multmode_intr() is invoked on completion of a WIN_SETMULT cmd.
  */
-ide_startstop_t set_multmode_intr (ide_drive_t *drive)
+static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	u8 stat;
@@ -164,7 +232,7 @@ ide_startstop_t set_multmode_intr (ide_drive_t *drive)
 /*
  * set_geometry_intr() is invoked on completion of a WIN_SPECIFY cmd.
  */
-ide_startstop_t set_geometry_intr (ide_drive_t *drive)
+static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	int retries = 5;
@@ -187,7 +255,7 @@ ide_startstop_t set_geometry_intr (ide_drive_t *drive)
 /*
  * recal_intr() is invoked on completion of a WIN_RESTORE (recalibrate) cmd.
  */
-ide_startstop_t recal_intr (ide_drive_t *drive)
+static ide_startstop_t recal_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	u8 stat;
@@ -200,7 +268,7 @@ ide_startstop_t recal_intr (ide_drive_t *drive)
 /*
  * Handler for commands without a data phase
  */
-ide_startstop_t task_no_data_intr (ide_drive_t *drive)
+static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 {
 	ide_task_t *args	= HWGROUP(drive)->rq->special;
 	ide_hwif_t *hwif	= HWIF(drive);
@@ -217,8 +285,6 @@ ide_startstop_t task_no_data_intr (ide_drive_t *drive)
 	return ide_stopped;
 }
 
-EXPORT_SYMBOL(task_no_data_intr);
-
 static u8 wait_drive_not_busy(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
@@ -363,7 +429,7 @@ static void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *task = rq->special;
 
-		if (task->tf_out_flags.all) {
+		if (task->tf_flags & IDE_TFLAG_FLAGGED) {
 			u8 err = drive->hwif->INB(IDE_ERROR_REG);
 			ide_end_drive_cmd(drive, stat, err);
 			return;
@@ -382,7 +448,7 @@ static void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
 /*
  * Handler for command with PIO data-in phase (Read/Read Multiple).
  */
-ide_startstop_t task_in_intr (ide_drive_t *drive)
+static ide_startstop_t task_in_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = HWGROUP(drive)->rq;
@@ -413,7 +479,6 @@ ide_startstop_t task_in_intr (ide_drive_t *drive)
 
 	return ide_started;
 }
-EXPORT_SYMBOL(task_in_intr);
 
 /*
  * Handler for command with PIO data-out phase (Write/Write Multiple).
@@ -443,7 +508,7 @@ static ide_startstop_t task_out_intr (ide_drive_t *drive)
 	return ide_started;
 }
 
-ide_startstop_t pre_task_out_intr (ide_drive_t *drive, struct request *rq)
+static ide_startstop_t pre_task_out_intr(ide_drive_t *drive, struct request *rq)
 {
 	ide_startstop_t startstop;
 
@@ -464,9 +529,8 @@ ide_startstop_t pre_task_out_intr (ide_drive_t *drive, struct request *rq)
 
 	return ide_started;
 }
-EXPORT_SYMBOL(pre_task_out_intr);
 
-static int ide_diag_taskfile(ide_drive_t *drive, ide_task_t *args, unsigned long data_size, u8 *buf)
+int ide_raw_taskfile(ide_drive_t *drive, ide_task_t *task, u8 *buf, u16 nsect)
 {
 	struct request rq;
 
@@ -481,36 +545,27 @@ static int ide_diag_taskfile(ide_drive_t *drive, ide_task_t *args, unsigned long
 	 * if we would find a solution to transfer any size.
 	 * To support special commands like READ LONG.
 	 */
-	if (args->command_type != IDE_DRIVE_TASK_NO_DATA) {
-		if (data_size == 0)
-			rq.nr_sectors = (args->hobRegister[IDE_NSECTOR_OFFSET] << 8) | args->tfRegister[IDE_NSECTOR_OFFSET];
-		else
-			rq.nr_sectors = data_size / SECTOR_SIZE;
-
-		if (!rq.nr_sectors) {
-			printk(KERN_ERR "%s: in/out command without data\n",
-					drive->name);
-			return -EFAULT;
-		}
+	rq.hard_nr_sectors = rq.nr_sectors = nsect;
+	rq.hard_cur_sectors = rq.current_nr_sectors = nsect;
 
-		rq.hard_nr_sectors = rq.nr_sectors;
-		rq.hard_cur_sectors = rq.current_nr_sectors = rq.nr_sectors;
+	if (task->tf_flags & IDE_TFLAG_WRITE)
+		rq.cmd_flags |= REQ_RW;
 
-		if (args->command_type == IDE_DRIVE_TASK_RAW_WRITE)
-			rq.cmd_flags |= REQ_RW;
-	}
+	rq.special = task;
+	task->rq = &rq;
 
-	rq.special = args;
-	args->rq = &rq;
 	return ide_do_drive_cmd(drive, &rq, ide_wait);
 }
 
-int ide_raw_taskfile (ide_drive_t *drive, ide_task_t *args, u8 *buf)
+EXPORT_SYMBOL(ide_raw_taskfile);
+
+int ide_no_data_taskfile(ide_drive_t *drive, ide_task_t *task)
 {
-	return ide_diag_taskfile(drive, args, 0, buf);
-}
+	task->data_phase = TASKFILE_NO_DATA;
 
-EXPORT_SYMBOL(ide_raw_taskfile);
+	return ide_raw_taskfile(drive, task, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(ide_no_data_taskfile);
 
 #ifdef CONFIG_IDE_TASK_IOCTL
 int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
@@ -519,12 +574,12 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 	ide_task_t		args;
 	u8 *outbuf		= NULL;
 	u8 *inbuf		= NULL;
-	task_ioreg_t *argsptr	= args.tfRegister;
-	task_ioreg_t *hobsptr	= args.hobRegister;
+	u8 *data_buf		= NULL;
 	int err			= 0;
 	int tasksize		= sizeof(struct ide_task_request_s);
 	unsigned int taskin	= 0;
 	unsigned int taskout	= 0;
+	u16 nsect		= 0;
 	u8 io_32bit		= drive->io_32bit;
 	char __user *buf = (char __user *)arg;
 
@@ -572,24 +627,52 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 	}
 
 	memset(&args, 0, sizeof(ide_task_t));
-	memcpy(argsptr, req_task->io_ports, HDIO_DRIVE_TASK_HDR_SIZE);
-	memcpy(hobsptr, req_task->hob_ports, HDIO_DRIVE_HOB_HDR_SIZE);
 
-	args.tf_in_flags  = req_task->in_flags;
-	args.tf_out_flags = req_task->out_flags;
-	args.data_phase   = req_task->data_phase;
-	args.command_type = req_task->req_cmd;
+	memcpy(&args.tf_array[0], req_task->hob_ports, HDIO_DRIVE_HOB_HDR_SIZE - 2);
+	memcpy(&args.tf_array[6], req_task->io_ports, HDIO_DRIVE_TASK_HDR_SIZE);
+
+	args.data_phase = req_task->data_phase;
+
+	args.tf_flags = IDE_TFLAG_OUT_DEVICE;
+	if (drive->addressing == 1)
+		args.tf_flags |= IDE_TFLAG_LBA48;
+
+	if (req_task->out_flags.all) {
+		args.tf_flags |= IDE_TFLAG_FLAGGED;
+
+		if (req_task->out_flags.b.data)
+			args.tf_flags |= IDE_TFLAG_OUT_DATA;
+
+		if (req_task->out_flags.b.nsector_hob)
+			args.tf_flags |= IDE_TFLAG_OUT_HOB_NSECT;
+		if (req_task->out_flags.b.sector_hob)
+			args.tf_flags |= IDE_TFLAG_OUT_HOB_LBAL;
+		if (req_task->out_flags.b.lcyl_hob)
+			args.tf_flags |= IDE_TFLAG_OUT_HOB_LBAM;
+		if (req_task->out_flags.b.hcyl_hob)
+			args.tf_flags |= IDE_TFLAG_OUT_HOB_LBAH;
+
+		if (req_task->out_flags.b.error_feature)
+			args.tf_flags |= IDE_TFLAG_OUT_FEATURE;
+		if (req_task->out_flags.b.nsector)
+			args.tf_flags |= IDE_TFLAG_OUT_NSECT;
+		if (req_task->out_flags.b.sector)
+			args.tf_flags |= IDE_TFLAG_OUT_LBAL;
+		if (req_task->out_flags.b.lcyl)
+			args.tf_flags |= IDE_TFLAG_OUT_LBAM;
+		if (req_task->out_flags.b.hcyl)
+			args.tf_flags |= IDE_TFLAG_OUT_LBAH;
+	} else {
+		args.tf_flags |= IDE_TFLAG_OUT_TF;
+		if (args.tf_flags & IDE_TFLAG_LBA48)
+			args.tf_flags |= IDE_TFLAG_OUT_HOB;
+	}
+
+	if (req_task->in_flags.b.data)
+		args.tf_flags |= IDE_TFLAG_IN_DATA;
 
 	drive->io_32bit = 0;
 	switch(req_task->data_phase) {
-		case TASKFILE_OUT_DMAQ:
-		case TASKFILE_OUT_DMA:
-			err = ide_diag_taskfile(drive, &args, taskout, outbuf);
-			break;
-		case TASKFILE_IN_DMAQ:
-		case TASKFILE_IN_DMA:
-			err = ide_diag_taskfile(drive, &args, taskin, inbuf);
-			break;
 		case TASKFILE_MULTI_OUT:
 			if (!drive->mult_count) {
 				/* (hs): give up if multcount is not set */
@@ -601,9 +684,11 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 			}
 			/* fall through */
 		case TASKFILE_OUT:
-			args.prehandler = &pre_task_out_intr;
-			args.handler = &task_out_intr;
-			err = ide_diag_taskfile(drive, &args, taskout, outbuf);
+			/* fall through */
+		case TASKFILE_OUT_DMAQ:
+		case TASKFILE_OUT_DMA:
+			nsect = taskout / SECTOR_SIZE;
+			data_buf = outbuf;
 			break;
 		case TASKFILE_MULTI_IN:
 			if (!drive->mult_count) {
@@ -616,22 +701,46 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 			}
 			/* fall through */
 		case TASKFILE_IN:
-			args.handler = &task_in_intr;
-			err = ide_diag_taskfile(drive, &args, taskin, inbuf);
+			/* fall through */
+		case TASKFILE_IN_DMAQ:
+		case TASKFILE_IN_DMA:
+			nsect = taskin / SECTOR_SIZE;
+			data_buf = inbuf;
 			break;
 		case TASKFILE_NO_DATA:
-			args.handler = &task_no_data_intr;
-			err = ide_diag_taskfile(drive, &args, 0, NULL);
 			break;
 		default:
 			err = -EFAULT;
 			goto abort;
 	}
 
-	memcpy(req_task->io_ports, &(args.tfRegister), HDIO_DRIVE_TASK_HDR_SIZE);
-	memcpy(req_task->hob_ports, &(args.hobRegister), HDIO_DRIVE_HOB_HDR_SIZE);
-	req_task->in_flags  = args.tf_in_flags;
-	req_task->out_flags = args.tf_out_flags;
+	if (req_task->req_cmd == IDE_DRIVE_TASK_NO_DATA)
+		nsect = 0;
+	else if (!nsect) {
+		nsect = (args.tf.hob_nsect << 8) | args.tf.nsect;
+
+		if (!nsect) {
+			printk(KERN_ERR "%s: in/out command without data\n",
+					drive->name);
+			err = -EFAULT;
+			goto abort;
+		}
+	}
+
+	if (req_task->req_cmd == IDE_DRIVE_TASK_RAW_WRITE)
+		args.tf_flags |= IDE_TFLAG_WRITE;
+
+	err = ide_raw_taskfile(drive, &args, data_buf, nsect);
+
+	memcpy(req_task->hob_ports, &args.tf_array[0], HDIO_DRIVE_HOB_HDR_SIZE - 2);
+	memcpy(req_task->io_ports, &args.tf_array[6], HDIO_DRIVE_TASK_HDR_SIZE);
+
+	if ((args.tf_flags & IDE_TFLAG_FLAGGED_SET_IN_FLAGS) &&
+	    req_task->in_flags.all == 0) {
+		req_task->in_flags.all = IDE_TASKFILE_STD_IN_FLAGS;
+		if (drive->addressing == 1)
+			req_task->in_flags.all |= (IDE_HOB_STD_IN_FLAGS << 8);
+	}
 
 	if (copy_to_user(buf, req_task, tasksize)) {
 		err = -EFAULT;
@@ -688,6 +797,7 @@ int ide_cmd_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 	u8 xfer_rate = 0;
 	int argsize = 4;
 	ide_task_t tfargs;
+	struct ide_taskfile *tf = &tfargs.tf;
 
 	if (NULL == (void *) arg) {
 		struct request rq;
@@ -699,13 +809,10 @@ int ide_cmd_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 		return -EFAULT;
 
 	memset(&tfargs, 0, sizeof(ide_task_t));
-	tfargs.tfRegister[IDE_FEATURE_OFFSET] = args[2];
-	tfargs.tfRegister[IDE_NSECTOR_OFFSET] = args[3];
-	tfargs.tfRegister[IDE_SECTOR_OFFSET]  = args[1];
-	tfargs.tfRegister[IDE_LCYL_OFFSET]    = 0x00;
-	tfargs.tfRegister[IDE_HCYL_OFFSET]    = 0x00;
-	tfargs.tfRegister[IDE_SELECT_OFFSET]  = 0x00;
-	tfargs.tfRegister[IDE_COMMAND_OFFSET] = args[0];
+	tf->feature = args[2];
+	tf->nsect   = args[3];
+	tf->lbal    = args[1];
+	tf->command = args[0];
 
 	if (args[3]) {
 		argsize = 4 + (SECTOR_WORDS * 4 * args[3]);
@@ -734,135 +841,28 @@ abort:
 	return err;
 }
 
-static int ide_wait_cmd_task(ide_drive_t *drive, u8 *buf)
-{
-	struct request rq;
-
-	ide_init_drive_cmd(&rq);
-	rq.cmd_type = REQ_TYPE_ATA_TASK;
-	rq.buffer = buf;
-	return ide_do_drive_cmd(drive, &rq, ide_wait);
-}
-
 int ide_task_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 {
 	void __user *p = (void __user *)arg;
 	int err = 0;
-	u8 args[7], *argbuf = args;
-	int argsize = 7;
+	u8 args[7];
+	ide_task_t task;
 
 	if (copy_from_user(args, p, 7))
 		return -EFAULT;
-	err = ide_wait_cmd_task(drive, argbuf);
-	if (copy_to_user(p, argbuf, argsize))
-		err = -EFAULT;
-	return err;
-}
-
-/*
- * NOTICE: This is additions from IBM to provide a discrete interface,
- * for selective taskregister access operations.  Nice JOB Klaus!!!
- * Glad to be able to work and co-develop this with you and IBM.
- */
-ide_startstop_t flagged_taskfile (ide_drive_t *drive, ide_task_t *task)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	task_struct_t *taskfile	= (task_struct_t *) task->tfRegister;
-	hob_struct_t *hobfile	= (hob_struct_t *) task->hobRegister;
-
-	if (task->data_phase == TASKFILE_MULTI_IN ||
-	    task->data_phase == TASKFILE_MULTI_OUT) {
-		if (!drive->mult_count) {
-			printk(KERN_ERR "%s: multimode not set!\n", drive->name);
-			return ide_stopped;
-		}
-	}
-
-	/*
-	 * (ks) Check taskfile in flags.
-	 * If set, then execute as it is defined.
-	 * If not set, then define default settings.
-	 * The default values are:
-	 *	read all taskfile registers (except data)
-	 *	read the hob registers (sector, nsector, lcyl, hcyl)
-	 */
-	if (task->tf_in_flags.all == 0) {
-		task->tf_in_flags.all = IDE_TASKFILE_STD_IN_FLAGS;
-		if (drive->addressing == 1)
-			task->tf_in_flags.all |= (IDE_HOB_STD_IN_FLAGS  << 8);
-        }
-
-	/* ALL Command Block Executions SHALL clear nIEN, unless otherwise */
-	if (IDE_CONTROL_REG)
-		/* clear nIEN */
-		hwif->OUTB(drive->ctl, IDE_CONTROL_REG);
-	SELECT_MASK(drive, 0);
-
-	if (task->tf_out_flags.b.data) {
-		u16 data =  taskfile->data + (hobfile->data << 8);
-		hwif->OUTW(data, IDE_DATA_REG);
-	}
-
-	/* (ks) send hob registers first */
-	if (task->tf_out_flags.b.nsector_hob)
-		hwif->OUTB(hobfile->sector_count, IDE_NSECTOR_REG);
-	if (task->tf_out_flags.b.sector_hob)
-		hwif->OUTB(hobfile->sector_number, IDE_SECTOR_REG);
-	if (task->tf_out_flags.b.lcyl_hob)
-		hwif->OUTB(hobfile->low_cylinder, IDE_LCYL_REG);
-	if (task->tf_out_flags.b.hcyl_hob)
-		hwif->OUTB(hobfile->high_cylinder, IDE_HCYL_REG);
-
-	/* (ks) Send now the standard registers */
-	if (task->tf_out_flags.b.error_feature)
-		hwif->OUTB(taskfile->feature, IDE_FEATURE_REG);
-	/* refers to number of sectors to transfer */
-	if (task->tf_out_flags.b.nsector)
-		hwif->OUTB(taskfile->sector_count, IDE_NSECTOR_REG);
-	/* refers to sector offset or start sector */
-	if (task->tf_out_flags.b.sector)
-		hwif->OUTB(taskfile->sector_number, IDE_SECTOR_REG);
-	if (task->tf_out_flags.b.lcyl)
-		hwif->OUTB(taskfile->low_cylinder, IDE_LCYL_REG);
-	if (task->tf_out_flags.b.hcyl)
-		hwif->OUTB(taskfile->high_cylinder, IDE_HCYL_REG);
-
-        /*
-	 * (ks) In the flagged taskfile approch, we will use all specified
-	 * registers and the register value will not be changed, except the
-	 * select bit (master/slave) in the drive_head register. We must make
-	 * sure that the desired drive is selected.
-	 */
-	hwif->OUTB(taskfile->device_head | drive->select.all, IDE_SELECT_REG);
-	switch(task->data_phase) {
 
-   	        case TASKFILE_OUT_DMAQ:
-		case TASKFILE_OUT_DMA:
-		case TASKFILE_IN_DMAQ:
-		case TASKFILE_IN_DMA:
-			if (!drive->using_dma)
-				break;
+	memset(&task, 0, sizeof(task));
+	memcpy(&task.tf_array[7], &args[1], 6);
+	task.tf.command = args[0];
+	task.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
 
-			if (!hwif->dma_setup(drive)) {
-				hwif->dma_exec_cmd(drive, taskfile->command);
-				hwif->dma_start(drive);
-				return ide_started;
-			}
-			break;
+	err = ide_no_data_taskfile(drive, &task);
 
-	        default:
- 			if (task->handler == NULL)
-				return ide_stopped;
+	args[0] = task.tf.command;
+	memcpy(&args[1], &task.tf_array[7], 6);
 
-			/* Issue the command */
-			if (task->prehandler) {
-				hwif->OUTBSYNC(drive, taskfile->command, IDE_COMMAND_REG);
-				ndelay(400);	/* FIXME */
-				return task->prehandler(drive, task->rq);
-			}
-			ide_execute_command(drive, taskfile->command, task->handler, WAIT_WORSTCASE, NULL);
-			return ide_started;
-	}
+	if (copy_to_user(p, args, 7))
+		err = -EFAULT;
 
-	return ide_stopped;
+	return err;
 }
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 54943da..c6d4f63 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -424,7 +424,6 @@ static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
 	hwif->reset_poll		= tmp_hwif->reset_poll;
 	hwif->pre_reset			= tmp_hwif->pre_reset;
 	hwif->resetproc			= tmp_hwif->resetproc;
-	hwif->intrproc			= tmp_hwif->intrproc;
 	hwif->maskproc			= tmp_hwif->maskproc;
 	hwif->quirkproc			= tmp_hwif->quirkproc;
 	hwif->busproc			= tmp_hwif->busproc;
@@ -468,7 +467,6 @@ static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
 #endif
 
 	hwif->dma_base			= tmp_hwif->dma_base;
-	hwif->dma_master		= tmp_hwif->dma_master;
 	hwif->dma_command		= tmp_hwif->dma_command;
 	hwif->dma_vendor1		= tmp_hwif->dma_vendor1;
 	hwif->dma_status		= tmp_hwif->dma_status;
@@ -602,7 +600,6 @@ void ide_unregister(unsigned int index)
 		(void) ide_release_dma(hwif);
 
 		hwif->dma_base = 0;
-		hwif->dma_master = 0;
 		hwif->dma_command = 0;
 		hwif->dma_vendor1 = 0;
 		hwif->dma_status = 0;
@@ -854,8 +851,7 @@ int set_using_dma(ide_drive_t *drive, int arg)
 	err = 0;
 
 	if (arg) {
-		hwif->dma_off_quietly(drive);
-		if (ide_set_dma(drive) || hwif->ide_dma_on(drive))
+		if (ide_set_dma(drive))
 			err = -EIO;
 	} else
 		ide_dma_off(drive);
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index a4ce3ba..a4d0d4c 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -198,8 +198,6 @@ static void auide_set_dma_mode(ide_drive_t *drive, const u8 speed)
 
 		break;
 #endif
-	default:
-		return;
 	}
 
 	au_writel(mem_sttime,MEM_STTIME2);
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index 4426850..7f4d185 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -202,6 +202,7 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.host_flags	= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_ATAPI_DMA |
+				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -211,6 +212,7 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_NO_AUTODMA |
+				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -220,7 +222,8 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
-		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA,
+		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
+				  IDE_HFLAG_ABUSE_SET_DMA_MODE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA4,
@@ -228,7 +231,9 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.name		= "AEC6280",
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_OFF_BOARD,
+		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
+				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
+				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -237,7 +242,9 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
-		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_OFF_BOARD,
+		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
+				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
+				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index ce29393..49aa82e 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -402,9 +402,6 @@ static void ali_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	u8 tmpbyte		= 0x00;
 	int m5229_udma		= (hwif->channel) ? 0x57 : 0x56;
 
-	if (speed < XFER_PIO_0)
-		return;
-
 	if (speed == XFER_UDMA_6)
 		speed1 = 0x47;
 
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 8d4125e..cee51fd 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -266,6 +266,7 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 #define IDE_HFLAGS_AMD \
 	(IDE_HFLAG_PIO_NO_BLACKLIST | \
 	 IDE_HFLAG_PIO_NO_DOWNGRADE | \
+	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
 	 IDE_HFLAG_POST_SET_MODE | \
 	 IDE_HFLAG_IO_32BIT | \
 	 IDE_HFLAG_UNMASK_IRQS | \
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index ef8e016..5ae2656 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -133,9 +133,6 @@ static void atiixp_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	u32 tmp32;
 	u16 tmp16;
 
-	if (speed < XFER_MW_DMA_0)
-		return;
-
 	spin_lock_irqsave(&atiixp_lock, flags);
 
 	save_mdma_mode[drive->dn] = 0;
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index bc55333..0b1e947 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -322,8 +322,6 @@ static void cmd64x_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	case XFER_MW_DMA_0:
 		program_cycle_times(drive, 480, 215);
 		break;
-	default:
-		return;
 	}
 
 	if (speed >= XFER_SW_DMA_0)
@@ -333,14 +331,15 @@ static void cmd64x_set_dma_mode(ide_drive_t *drive, const u8 speed)
 static int cmd648_ide_dma_end (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
+	unsigned long base	= hwif->dma_base - (hwif->channel * 8);
 	int err			= __ide_dma_end(drive);
 	u8  irq_mask		= hwif->channel ? MRDMODE_INTR_CH1 :
 						  MRDMODE_INTR_CH0;
-	u8  mrdmode		= inb(hwif->dma_master + 0x01);
+	u8  mrdmode		= inb(base + 1);
 
 	/* clear the interrupt bit */
 	outb((mrdmode & ~(MRDMODE_INTR_CH0 | MRDMODE_INTR_CH1)) | irq_mask,
-	     hwif->dma_master + 0x01);
+	     base + 1);
 
 	return err;
 }
@@ -365,10 +364,11 @@ static int cmd64x_ide_dma_end (ide_drive_t *drive)
 static int cmd648_ide_dma_test_irq (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
+	unsigned long base	= hwif->dma_base - (hwif->channel * 8);
 	u8 irq_mask		= hwif->channel ? MRDMODE_INTR_CH1 :
 						  MRDMODE_INTR_CH0;
 	u8 dma_stat		= inb(hwif->dma_status);
-	u8 mrdmode		= inb(hwif->dma_master + 0x01);
+	u8 mrdmode		= inb(base + 1);
 
 #ifdef DEBUG
 	printk("%s: dma_stat: 0x%02x mrdmode: 0x%02x irq_mask: 0x%02x\n",
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index 0466462..d1a91bc 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -137,6 +137,7 @@ static void __devinit init_hwif_cs5520(ide_hwif_t *hwif)
 				  IDE_HFLAG_CS5520 |		\
 				  IDE_HFLAG_VDMA |		\
 				  IDE_HFLAG_NO_ATAPI_DMA |	\
+				  IDE_HFLAG_ABUSE_SET_DMA_MODE |\
 				  IDE_HFLAG_BOOTABLE,		\
 		.pio_mask	= ATA_PIO4,			\
 	}
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index 5476903..df5966b 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -116,8 +116,6 @@ static void cs5530_set_dma_mode(ide_drive_t *drive, const u8 mode)
 		case XFER_MW_DMA_0:	timings = 0x00077771; break;
 		case XFER_MW_DMA_1:	timings = 0x00012121; break;
 		case XFER_MW_DMA_2:	timings = 0x00002020; break;
-		default:
-			return;
 	}
 	basereg = CS5530_BASEREG(drive->hwif);
 	reg = inl(basereg + 4);			/* get drive0 config register */
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index ddcbeba..50b3d77 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -190,7 +190,7 @@ static const struct ide_port_info cs5535_chipset __devinitdata = {
 	.name		= "CS5535",
 	.init_hwif	= init_hwif_cs5535,
 	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE |
-			  IDE_HFLAG_BOOTABLE,
+			  IDE_HFLAG_ABUSE_SET_DMA_MODE | IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA4,
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index ae6307f..dfba0d1 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -129,14 +129,18 @@ static void __devinit init_hwif_hpt34x(ide_hwif_t *hwif)
 	hwif->set_dma_mode = &hpt34x_set_mode;
 }
 
+#define IDE_HFLAGS_HPT34X \
+	(IDE_HFLAG_NO_ATAPI_DMA | \
+	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
+	 IDE_HFLAG_NO_AUTODMA)
+
 static const struct ide_port_info hpt34x_chipsets[] __devinitdata = {
 	{ /* 0 */
 		.name		= "HPT343",
 		.init_chipset	= init_chipset_hpt34x,
 		.init_hwif	= init_hwif_hpt34x,
 		.extra		= 16,
-		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
-				  IDE_HFLAG_NO_AUTODMA,
+		.host_flags	= IDE_HFLAGS_HPT34X,
 		.pio_mask	= ATA_PIO5,
 	},
 	{ /* 1 */
@@ -144,9 +148,7 @@ static const struct ide_port_info hpt34x_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_hpt34x,
 		.init_hwif	= init_hwif_hpt34x,
 		.extra		= 16,
-		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
-				  IDE_HFLAG_NO_AUTODMA |
-				  IDE_HFLAG_OFF_BOARD,
+		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO5,
 #ifdef CONFIG_HPT34X_AUTODMA
 		.swdma_mask	= ATA_SWDMA2,
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 9fce25b..3777fb8 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.22	Dec 4, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.30	Dec 12, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -88,7 +88,7 @@
  * - rename all the register related variables consistently
  * - move all the interrupt twiddling code from the speedproc handlers into
  *   init_hwif_hpt366(), also grouping all the DMA related code together there
- * - merge two HPT37x speedproc handlers, fix the PIO timing register mask and
+ * - merge HPT36x/HPT37x speedproc handlers, fix PIO timing register mask and
  *   separate the UltraDMA and MWDMA masks there to avoid changing PIO timings
  *   when setting an UltraDMA mode
  * - fix hpt3xx_tune_drive() to set the PIO mode requested, not always select
@@ -458,6 +458,13 @@ enum ata_clock {
 	NUM_ATA_CLOCKS
 };
 
+struct hpt_timings {
+	u32 pio_mask;
+	u32 dma_mask;
+	u32 ultra_mask;
+	u32 *clock_table[NUM_ATA_CLOCKS];
+};
+
 /*
  *	Hold all the HighPoint chip information in one place.
  */
@@ -468,7 +475,8 @@ struct hpt_info {
 	u8 udma_mask;		/* Allowed UltraDMA modes mask. */
 	u8 dpll_clk;		/* DPLL clock in MHz */
 	u8 pci_clk;		/* PCI  clock in MHz */
-	u32 **settings; 	/* Chipset settings table */
+	struct hpt_timings *timings; /* Chipset timing data */
+	u8 clock;		/* ATA clock selected */
 };
 
 /* Supported HighPoint chips */
@@ -486,20 +494,30 @@ enum {
 	HPT371N
 };
 
-static u32 *hpt36x_settings[NUM_ATA_CLOCKS] = {
-	twenty_five_base_hpt36x,
-	thirty_three_base_hpt36x,
-	forty_base_hpt36x,
-	NULL,
-	NULL
+static struct hpt_timings hpt36x_timings = {
+	.pio_mask	= 0xc1f8ffff,
+	.dma_mask	= 0x303800ff,
+	.ultra_mask	= 0x30070000,
+	.clock_table	= {
+		[ATA_CLOCK_25MHZ] = twenty_five_base_hpt36x,
+		[ATA_CLOCK_33MHZ] = thirty_three_base_hpt36x,
+		[ATA_CLOCK_40MHZ] = forty_base_hpt36x,
+		[ATA_CLOCK_50MHZ] = NULL,
+		[ATA_CLOCK_66MHZ] = NULL
+	}
 };
 
-static u32 *hpt37x_settings[NUM_ATA_CLOCKS] = {
-	NULL,
-	thirty_three_base_hpt37x,
-	NULL,
-	fifty_base_hpt37x,
-	sixty_six_base_hpt37x
+static struct hpt_timings hpt37x_timings = {
+	.pio_mask	= 0xcfc3ffff,
+	.dma_mask	= 0x31c001ff,
+	.ultra_mask	= 0x303c0000,
+	.clock_table	= {
+		[ATA_CLOCK_25MHZ] = NULL,
+		[ATA_CLOCK_33MHZ] = thirty_three_base_hpt37x,
+		[ATA_CLOCK_40MHZ] = NULL,
+		[ATA_CLOCK_50MHZ] = fifty_base_hpt37x,
+		[ATA_CLOCK_66MHZ] = sixty_six_base_hpt37x
+	}
 };
 
 static const struct hpt_info hpt36x __devinitdata = {
@@ -507,7 +525,7 @@ static const struct hpt_info hpt36x __devinitdata = {
 	.chip_type	= HPT36x,
 	.udma_mask	= HPT366_ALLOW_ATA66_3 ? (HPT366_ALLOW_ATA66_4 ? ATA_UDMA4 : ATA_UDMA3) : ATA_UDMA2,
 	.dpll_clk	= 0,	/* no DPLL */
-	.settings	= hpt36x_settings
+	.timings	= &hpt36x_timings
 };
 
 static const struct hpt_info hpt370 __devinitdata = {
@@ -515,7 +533,7 @@ static const struct hpt_info hpt370 __devinitdata = {
 	.chip_type	= HPT370,
 	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
 	.dpll_clk	= 48,
-	.settings	= hpt37x_settings
+	.timings	= &hpt37x_timings
 };
 
 static const struct hpt_info hpt370a __devinitdata = {
@@ -523,7 +541,7 @@ static const struct hpt_info hpt370a __devinitdata = {
 	.chip_type	= HPT370A,
 	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
 	.dpll_clk	= 48,
-	.settings	= hpt37x_settings
+	.timings	= &hpt37x_timings
 };
 
 static const struct hpt_info hpt374 __devinitdata = {
@@ -531,7 +549,7 @@ static const struct hpt_info hpt374 __devinitdata = {
 	.chip_type	= HPT374,
 	.udma_mask	= ATA_UDMA5,
 	.dpll_clk	= 48,
-	.settings	= hpt37x_settings
+	.timings	= &hpt37x_timings
 };
 
 static const struct hpt_info hpt372 __devinitdata = {
@@ -539,7 +557,7 @@ static const struct hpt_info hpt372 __devinitdata = {
 	.chip_type	= HPT372,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 	.dpll_clk	= 55,
-	.settings	= hpt37x_settings
+	.timings	= &hpt37x_timings
 };
 
 static const struct hpt_info hpt372a __devinitdata = {
@@ -547,7 +565,7 @@ static const struct hpt_info hpt372a __devinitdata = {
 	.chip_type	= HPT372A,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 	.dpll_clk	= 66,
-	.settings	= hpt37x_settings
+	.timings	= &hpt37x_timings
 };
 
 static const struct hpt_info hpt302 __devinitdata = {
@@ -555,7 +573,7 @@ static const struct hpt_info hpt302 __devinitdata = {
 	.chip_type	= HPT302,
 	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 	.dpll_clk	= 66,
-	.settings	= hpt37x_settings
+	.timings	= &hpt37x_timings
 };
 
 static const struct hpt_info hpt371 __devinitdata = {
@@ -563,7 +581,7 @@ static const struct hpt_info hpt371 __devinitdata = {
 	.chip_type	= HPT371,
 	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 	.dpll_clk	= 66,
-	.settings	= hpt37x_settings
+	.timings	= &hpt37x_timings
 };
 
 static const struct hpt_info hpt372n __devinitdata = {
@@ -571,7 +589,7 @@ static const struct hpt_info hpt372n __devinitdata = {
 	.chip_type	= HPT372N,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 	.dpll_clk	= 77,
-	.settings	= hpt37x_settings
+	.timings	= &hpt37x_timings
 };
 
 static const struct hpt_info hpt302n __devinitdata = {
@@ -579,7 +597,7 @@ static const struct hpt_info hpt302n __devinitdata = {
 	.chip_type	= HPT302N,
 	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 	.dpll_clk	= 77,
-	.settings	= hpt37x_settings
+	.timings	= &hpt37x_timings
 };
 
 static const struct hpt_info hpt371n __devinitdata = {
@@ -587,7 +605,7 @@ static const struct hpt_info hpt371n __devinitdata = {
 	.chip_type	= HPT371N,
 	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 	.dpll_clk	= 77,
-	.settings	= hpt37x_settings
+	.timings	= &hpt37x_timings
 };
 
 static int check_in_drive_list(ide_drive_t *drive, const char **list)
@@ -675,71 +693,33 @@ static u32 get_speed_setting(u8 speed, struct hpt_info *info)
 	for (i = 0; i < ARRAY_SIZE(xfer_speeds) - 1; i++)
 		if (xfer_speeds[i] == speed)
 			break;
-	/*
-	 * NOTE: info->settings only points to the pointer
-	 * to the list of the actual register values
-	 */
-	return (*info->settings)[i];
+
+	return info->timings->clock_table[info->clock][i];
 }
 
-static void hpt36x_set_mode(ide_drive_t *drive, const u8 speed)
+static void hpt3xx_set_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev  *dev	= hwif->pci_dev;
+	struct pci_dev  *dev	= HWIF(drive)->pci_dev;
 	struct hpt_info	*info	= pci_get_drvdata(dev);
-	u8  itr_addr		= drive->dn ? 0x44 : 0x40;
+	struct hpt_timings *t	= info->timings;
+	u8  itr_addr		= 0x40 + (drive->dn * 4);
 	u32 old_itr		= 0;
-	u32 itr_mask, new_itr;
-
-	itr_mask = speed < XFER_MW_DMA_0 ? 0x30070000 :
-		  (speed < XFER_UDMA_0   ? 0xc0070000 : 0xc03800ff);
-
-	new_itr = get_speed_setting(speed, info);
+	u32 new_itr		= get_speed_setting(speed, info);
+	u32 itr_mask		= speed < XFER_MW_DMA_0 ? t->pio_mask :
+				 (speed < XFER_UDMA_0   ? t->dma_mask :
+							  t->ultra_mask);
 
+	pci_read_config_dword(dev, itr_addr, &old_itr);
+	new_itr = (old_itr & ~itr_mask) | (new_itr & itr_mask);
 	/*
 	 * Disable on-chip PIO FIFO/buffer (and PIO MST mode as well)
 	 * to avoid problems handling I/O errors later
 	 */
-	pci_read_config_dword(dev, itr_addr, &old_itr);
-	new_itr  = (new_itr & ~itr_mask) | (old_itr & itr_mask);
 	new_itr &= ~0xc0000000;
 
 	pci_write_config_dword(dev, itr_addr, new_itr);
 }
 
-static void hpt37x_set_mode(ide_drive_t *drive, const u8 speed)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev  *dev	= hwif->pci_dev;
-	struct hpt_info	*info	= pci_get_drvdata(dev);
-	u8  itr_addr		= 0x40 + (drive->dn * 4);
-	u32 old_itr		= 0;
-	u32 itr_mask, new_itr;
-
-	itr_mask = speed < XFER_MW_DMA_0 ? 0x303c0000 :
-		  (speed < XFER_UDMA_0   ? 0xc03c0000 : 0xc1c001ff);
-
-	new_itr = get_speed_setting(speed, info);
-
-	pci_read_config_dword(dev, itr_addr, &old_itr);
-	new_itr = (new_itr & ~itr_mask) | (old_itr & itr_mask);
-	
-	if (speed < XFER_MW_DMA_0)
-		new_itr &= ~0x80000000; /* Disable on-chip PIO FIFO/buffer */
-	pci_write_config_dword(dev, itr_addr, new_itr);
-}
-
-static void hpt3xx_set_mode(ide_drive_t *drive, const u8 speed)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct hpt_info	*info	= pci_get_drvdata(hwif->pci_dev);
-
-	if (info->chip_type >= HPT370)
-		hpt37x_set_mode(drive, speed);
-	else	/* hpt368: hpt_minimum_revision(dev, 2) */
-		hpt36x_set_mode(drive, speed);
-}
-
 static void hpt3xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	hpt3xx_set_mode(drive, XFER_PIO_0 + pio);
@@ -756,15 +736,6 @@ static int hpt3xx_quirkproc(ide_drive_t *drive)
 	return 0;
 }
 
-static void hpt3xx_intrproc(ide_drive_t *drive)
-{
-	if (drive->quirk_list)
-		return;
-
-	/* drives in the quirk_list may not like intr setups/cleanups */
-	outb(drive->ctl | 2, IDE_CONTROL_REG);
-}
-
 static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
@@ -914,32 +885,33 @@ static int hpt374_ide_dma_end(ide_drive_t *drive)
 
 static void hpt3xxn_set_clock(ide_hwif_t *hwif, u8 mode)
 {
-	u8 scr2 = inb(hwif->dma_master + 0x7b);
+	unsigned long base = hwif->extra_base;
+	u8 scr2 = inb(base + 0x6b);
 
 	if ((scr2 & 0x7f) == mode)
 		return;
 
 	/* Tristate the bus */
-	outb(0x80, hwif->dma_master + 0x73);
-	outb(0x80, hwif->dma_master + 0x77);
+	outb(0x80, base + 0x63);
+	outb(0x80, base + 0x67);
 
 	/* Switch clock and reset channels */
-	outb(mode, hwif->dma_master + 0x7b);
-	outb(0xc0, hwif->dma_master + 0x79);
+	outb(mode, base + 0x6b);
+	outb(0xc0, base + 0x69);
 
 	/*
 	 * Reset the state machines.
 	 * NOTE: avoid accidentally enabling the disabled channels.
 	 */
-	outb(inb(hwif->dma_master + 0x70) | 0x32, hwif->dma_master + 0x70);
-	outb(inb(hwif->dma_master + 0x74) | 0x32, hwif->dma_master + 0x74);
+	outb(inb(base + 0x60) | 0x32, base + 0x60);
+	outb(inb(base + 0x64) | 0x32, base + 0x64);
 
 	/* Complete reset */
-	outb(0x00, hwif->dma_master + 0x79);
+	outb(0x00, base + 0x69);
 
 	/* Reconnect channels to bus */
-	outb(0x00, hwif->dma_master + 0x73);
-	outb(0x00, hwif->dma_master + 0x77);
+	outb(0x00, base + 0x63);
+	outb(0x00, base + 0x67);
 }
 
 /**
@@ -1210,7 +1182,7 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 	 * We also  don't like using  the DPLL because this causes glitches
 	 * on PRST-/SRST- when the state engine gets reset...
 	 */
-	if (chip_type >= HPT374 || info->settings[clock] == NULL) {
+	if (chip_type >= HPT374 || info->timings->clock_table[clock] == NULL) {
 		u16 f_low, delta = pci_clk < 50 ? 2 : 4;
 		int adjust;
 
@@ -1226,7 +1198,7 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 			clock = ATA_CLOCK_50MHZ;
 		}
 
-		if (info->settings[clock] == NULL) {
+		if (info->timings->clock_table[clock] == NULL) {
 			printk(KERN_ERR "%s: unknown bus timing!\n", name);
 			kfree(info);
 			return -EIO;
@@ -1267,15 +1239,10 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 		printk("%s: using %d MHz PCI clock\n", name, pci_clk);
 	}
 
-	/*
-	 * Advance the table pointer to a slot which points to the list
-	 * of the register values settings matching the clock being used.
-	 */
-	info->settings += clock;
-
 	/* Store the clock frequencies. */
 	info->dpll_clk	= dpll_clk;
 	info->pci_clk	= pci_clk;
+	info->clock	= clock;
 
 	/* Point to this chip's own instance of the hpt_info structure. */
 	pci_set_drvdata(dev, info);
@@ -1320,8 +1287,8 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 
 	hwif->set_pio_mode	= &hpt3xx_set_pio_mode;
 	hwif->set_dma_mode	= &hpt3xx_set_mode;
+
 	hwif->quirkproc		= &hpt3xx_quirkproc;
-	hwif->intrproc		= &hpt3xx_intrproc;
 	hwif->maskproc		= &hpt3xx_maskproc;
 	hwif->busproc		= &hpt3xx_busproc;
 
@@ -1494,6 +1461,11 @@ static int __devinit hpt36x_init(struct pci_dev *dev, struct pci_dev *dev2)
 	return 0;
 }
 
+#define IDE_HFLAGS_HPT3XX \
+	(IDE_HFLAG_NO_ATAPI_DMA | \
+	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
+	 IDE_HFLAG_OFF_BOARD)
+
 static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "HPT36x",
@@ -1508,9 +1480,7 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 		 */
 		.enablebits	= {{0x50,0x10,0x10}, {0x54,0x04,0x04}},
 		.extra		= 240,
-		.host_flags	= IDE_HFLAG_SINGLE |
-				  IDE_HFLAG_NO_ATAPI_DMA |
-				  IDE_HFLAG_OFF_BOARD,
+		.host_flags	= IDE_HFLAGS_HPT3XX | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 	},{	/* 1 */
@@ -1520,7 +1490,7 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.extra		= 240,
-		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_OFF_BOARD,
+		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 	},{	/* 2 */
@@ -1530,7 +1500,7 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.extra		= 240,
-		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_OFF_BOARD,
+		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 	},{	/* 3 */
@@ -1540,7 +1510,7 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.extra		= 240,
-		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_OFF_BOARD,
+		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 	},{	/* 4 */
@@ -1551,7 +1521,7 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.udma_mask	= ATA_UDMA5,
 		.extra		= 240,
-		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_OFF_BOARD,
+		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 	},{	/* 5 */
@@ -1561,7 +1531,7 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.extra		= 240,
-		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_OFF_BOARD,
+		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 	}
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index 90b52ed..2a0f45c 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -101,24 +101,11 @@ static void it8213_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	pci_read_config_byte(dev, 0x54, &reg54);
 	pci_read_config_byte(dev, 0x55, &reg55);
 
-	switch(speed) {
-		case XFER_UDMA_6:
-		case XFER_UDMA_4:
-		case XFER_UDMA_2:	u_speed = 2 << (drive->dn * 4); break;
-		case XFER_UDMA_5:
-		case XFER_UDMA_3:
-		case XFER_UDMA_1:	u_speed = 1 << (drive->dn * 4); break;
-		case XFER_UDMA_0:	u_speed = 0 << (drive->dn * 4); break;
-			break;
-		case XFER_MW_DMA_2:
-		case XFER_MW_DMA_1:
-		case XFER_SW_DMA_2:
-			break;
-		default:
-			return;
-	}
-
 	if (speed >= XFER_UDMA_0) {
+		u8 udma = speed - XFER_UDMA_0;
+
+		u_speed = min_t(u8, 2 - (udma & 1), udma) << (drive->dn * 4);
+
 		if (!(reg48 & u_flag))
 			pci_write_config_byte(dev, 0x48, reg48 | u_flag);
 		if (speed >= XFER_UDMA_5) {
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 2b4f44e..ef4a99b 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -146,7 +146,7 @@ static struct udma_timing {
 	{ 0x1a, 0x01, 0xcb },	/* UDMA mode 6 */
 };
 
-static void pdcnew_set_mode(ide_drive_t *drive, const u8 speed)
+static void pdcnew_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	u8 adj			= (drive->dn & 1) ? 0x08 : 0x00;
@@ -162,45 +162,18 @@ static void pdcnew_set_mode(ide_drive_t *drive, const u8 speed)
 	if (max_dma_rate(hwif->pci_dev) == 4) {
 		u8 mode = speed & 0x07;
 
-		switch (speed) {
-			case XFER_UDMA_6:
-			case XFER_UDMA_5:
-			case XFER_UDMA_4:
-			case XFER_UDMA_3:
-			case XFER_UDMA_2:
-			case XFER_UDMA_1:
-			case XFER_UDMA_0:
-				set_indexed_reg(hwif, 0x10 + adj,
-						udma_timings[mode].reg10);
-				set_indexed_reg(hwif, 0x11 + adj,
-						udma_timings[mode].reg11);
-				set_indexed_reg(hwif, 0x12 + adj,
-						udma_timings[mode].reg12);
-				break;
-
-			case XFER_MW_DMA_2:
-			case XFER_MW_DMA_1:
-			case XFER_MW_DMA_0:
-				set_indexed_reg(hwif, 0x0e + adj,
-						mwdma_timings[mode].reg0e);
-				set_indexed_reg(hwif, 0x0f + adj,
-						mwdma_timings[mode].reg0f);
-				break;
-			case XFER_PIO_4:
-			case XFER_PIO_3:
-			case XFER_PIO_2:
-			case XFER_PIO_1:
-			case XFER_PIO_0:
-				set_indexed_reg(hwif, 0x0c + adj,
-						pio_timings[mode].reg0c);
-				set_indexed_reg(hwif, 0x0d + adj,
-						pio_timings[mode].reg0d);
-				set_indexed_reg(hwif, 0x13 + adj,
-						pio_timings[mode].reg13);
-				break;
-			default:
-				printk(KERN_ERR "pdc202xx_new: "
-				       "Unknown speed %d ignored\n", speed);
+		if (speed >= XFER_UDMA_0) {
+			set_indexed_reg(hwif, 0x10 + adj,
+					udma_timings[mode].reg10);
+			set_indexed_reg(hwif, 0x11 + adj,
+					udma_timings[mode].reg11);
+			set_indexed_reg(hwif, 0x12 + adj,
+					udma_timings[mode].reg12);
+		} else {
+			set_indexed_reg(hwif, 0x0e + adj,
+					mwdma_timings[mode].reg0e);
+			set_indexed_reg(hwif, 0x0f + adj,
+					mwdma_timings[mode].reg0f);
 		}
 	} else if (speed == XFER_UDMA_2) {
 		/* Set tHOLD bit to 0 if using UDMA mode 2 */
@@ -212,7 +185,14 @@ static void pdcnew_set_mode(ide_drive_t *drive, const u8 speed)
 
 static void pdcnew_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pdcnew_set_mode(drive, XFER_PIO_0 + pio);
+	ide_hwif_t *hwif = drive->hwif;
+	u8 adj = (drive->dn & 1) ? 0x08 : 0x00;
+
+	if (max_dma_rate(hwif->pci_dev) == 4) {
+		set_indexed_reg(hwif, 0x0c + adj, pio_timings[pio].reg0c);
+		set_indexed_reg(hwif, 0x0d + adj, pio_timings[pio].reg0d);
+		set_indexed_reg(hwif, 0x13 + adj, pio_timings[pio].reg13);
+	}
 }
 
 static u8 pdcnew_cable_detect(ide_hwif_t *hwif)
@@ -466,7 +446,7 @@ static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev, const cha
 static void __devinit init_hwif_pdc202new(ide_hwif_t *hwif)
 {
 	hwif->set_pio_mode = &pdcnew_set_pio_mode;
-	hwif->set_dma_mode = &pdcnew_set_mode;
+	hwif->set_dma_mode = &pdcnew_set_dma_mode;
 
 	hwif->quirkproc = &pdcnew_quirkproc;
 	hwif->resetproc = &pdcnew_reset;
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index e09742e..67b2781 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -162,7 +162,7 @@ static u8 pdc202xx_old_cable_detect (ide_hwif_t *hwif)
  */
 static void pdc_old_enable_66MHz_clock(ide_hwif_t *hwif)
 {
-	unsigned long clock_reg = hwif->dma_master + 0x11;
+	unsigned long clock_reg = hwif->extra_base + 0x01;
 	u8 clock = inb(clock_reg);
 
 	outb(clock | (hwif->channel ? 0x08 : 0x02), clock_reg);
@@ -170,7 +170,7 @@ static void pdc_old_enable_66MHz_clock(ide_hwif_t *hwif)
 
 static void pdc_old_disable_66MHz_clock(ide_hwif_t *hwif)
 {
-	unsigned long clock_reg = hwif->dma_master + 0x11;
+	unsigned long clock_reg = hwif->extra_base + 0x01;
 	u8 clock = inb(clock_reg);
 
 	outb(clock & ~(hwif->channel ? 0x08 : 0x02), clock_reg);
@@ -193,7 +193,7 @@ static void pdc202xx_old_ide_dma_start(ide_drive_t *drive)
 	if (drive->media != ide_disk || drive->addressing == 1) {
 		struct request *rq	= HWGROUP(drive)->rq;
 		ide_hwif_t *hwif	= HWIF(drive);
-		unsigned long high_16   = hwif->dma_master;
+		unsigned long high_16	= hwif->extra_base - 16;
 		unsigned long atapi_reg	= high_16 + (hwif->channel ? 0x24 : 0x20);
 		u32 word_count	= 0;
 		u8 clock = inb(high_16 + 0x11);
@@ -212,7 +212,7 @@ static int pdc202xx_old_ide_dma_end(ide_drive_t *drive)
 {
 	if (drive->media != ide_disk || drive->addressing == 1) {
 		ide_hwif_t *hwif	= HWIF(drive);
-		unsigned long high_16	= hwif->dma_master;
+		unsigned long high_16	= hwif->extra_base - 16;
 		unsigned long atapi_reg	= high_16 + (hwif->channel ? 0x24 : 0x20);
 		u8 clock		= 0;
 
@@ -228,7 +228,7 @@ static int pdc202xx_old_ide_dma_end(ide_drive_t *drive)
 static int pdc202xx_old_ide_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	unsigned long high_16	= hwif->dma_master;
+	unsigned long high_16	= hwif->extra_base - 16;
 	u8 dma_stat		= inb(hwif->dma_status);
 	u8 sc1d			= inb(high_16 + 0x001d);
 
@@ -271,7 +271,7 @@ static void pdc202xx_dma_timeout(ide_drive_t *drive)
 
 static void pdc202xx_reset_host (ide_hwif_t *hwif)
 {
-	unsigned long high_16	= hwif->dma_master;
+	unsigned long high_16	= hwif->extra_base - 16;
 	u8 udma_speed_flag	= inb(high_16 | 0x001f);
 
 	outb(udma_speed_flag | 0x10, high_16 | 0x001f);
@@ -375,6 +375,11 @@ static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
 	}
 }
 
+#define IDE_HFLAGS_PDC202XX \
+	(IDE_HFLAG_ERROR_STOPS_FIFO | \
+	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
+	 IDE_HFLAG_OFF_BOARD)
+
 #define DECLARE_PDC2026X_DEV(name_str, udma, extra_flags) \
 	{ \
 		.name		= name_str, \
@@ -382,9 +387,7 @@ static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
 		.init_hwif	= init_hwif_pdc202xx, \
 		.init_dma	= init_dma_pdc202xx, \
 		.extra		= 48, \
-		.host_flags	= IDE_HFLAG_ERROR_STOPS_FIFO | \
-				  extra_flags | \
-				  IDE_HFLAG_OFF_BOARD, \
+		.host_flags	= IDE_HFLAGS_PDC202XX | extra_flags, \
 		.pio_mask	= ATA_PIO4, \
 		.mwdma_mask	= ATA_MWDMA2, \
 		.udma_mask	= udma, \
@@ -397,8 +400,7 @@ static const struct ide_port_info pdc202xx_chipsets[] __devinitdata = {
 		.init_hwif	= init_hwif_pdc202xx,
 		.init_dma	= init_dma_pdc202xx,
 		.extra		= 16,
-		.host_flags	= IDE_HFLAG_ERROR_STOPS_FIFO |
-				  IDE_HFLAG_OFF_BOARD,
+		.host_flags	= IDE_HFLAGS_PDC202XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA2,
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 27781d2..bd6d3f7 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -203,20 +203,11 @@ static void piix_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	pci_read_config_byte(dev, 0x54, &reg54);
 	pci_read_config_byte(dev, 0x55, &reg55);
 
-	switch(speed) {
-		case XFER_UDMA_4:
-		case XFER_UDMA_2:	u_speed = 2 << (drive->dn * 4); break;
-		case XFER_UDMA_5:
-		case XFER_UDMA_3:
-		case XFER_UDMA_1:	u_speed = 1 << (drive->dn * 4); break;
-		case XFER_UDMA_0:	u_speed = 0 << (drive->dn * 4); break;
-		case XFER_MW_DMA_2:
-		case XFER_MW_DMA_1:
-		case XFER_SW_DMA_2:	break;
-		default:		return;
-	}
-
 	if (speed >= XFER_UDMA_0) {
+		u8 udma = speed - XFER_UDMA_0;
+
+		u_speed = min_t(u8, 2 - (udma & 1), udma) << (drive->dn * 4);
+
 		if (!(reg48 & u_flag))
 			pci_write_config_byte(dev, 0x48, reg48 | u_flag);
 		if (speed == XFER_UDMA_5) {
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index 707d5ff..fef20bd 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -135,59 +135,29 @@ static void sc1200_set_dma_mode(ide_drive_t *drive, const u8 mode)
 	unsigned short		pci_clock;
 	unsigned int		basereg = hwif->channel ? 0x50 : 0x40;
 
+	static const u32 udma_timing[3][3] = {
+		{ 0x00921250, 0x00911140, 0x00911030 },
+		{ 0x00932470, 0x00922260, 0x00922140 },
+		{ 0x009436a1, 0x00933481, 0x00923261 },
+	};
+
+	static const u32 mwdma_timing[3][3] = {
+		{ 0x00077771, 0x00012121, 0x00002020 },
+		{ 0x000bbbb2, 0x00024241, 0x00013131 },
+		{ 0x000ffff3, 0x00035352, 0x00015151 },
+	};
+
 	pci_clock = sc1200_get_pci_clock();
 
 	/*
 	 * Note that each DMA mode has several timings associated with it.
 	 * The correct timing depends on the fast PCI clock freq.
 	 */
-	timings = 0;
-	switch (mode) {
-		case XFER_UDMA_0:
-			switch (pci_clock) {
-				case PCI_CLK_33:	timings = 0x00921250;	break;
-				case PCI_CLK_48:	timings = 0x00932470;	break;
-				case PCI_CLK_66:	timings = 0x009436a1;	break;
-			}
-			break;
-		case XFER_UDMA_1:
-			switch (pci_clock) {
-				case PCI_CLK_33:	timings = 0x00911140;	break;
-				case PCI_CLK_48:	timings = 0x00922260;	break;
-				case PCI_CLK_66:	timings = 0x00933481;	break;
-			}
-			break;
-		case XFER_UDMA_2:
-			switch (pci_clock) {
-				case PCI_CLK_33:	timings = 0x00911030;	break;
-				case PCI_CLK_48:	timings = 0x00922140;	break;
-				case PCI_CLK_66:	timings = 0x00923261;	break;
-			}
-			break;
-		case XFER_MW_DMA_0:
-			switch (pci_clock) {
-				case PCI_CLK_33:	timings = 0x00077771;	break;
-				case PCI_CLK_48:	timings = 0x000bbbb2;	break;
-				case PCI_CLK_66:	timings = 0x000ffff3;	break;
-			}
-			break;
-		case XFER_MW_DMA_1:
-			switch (pci_clock) {
-				case PCI_CLK_33:	timings = 0x00012121;	break;
-				case PCI_CLK_48:	timings = 0x00024241;	break;
-				case PCI_CLK_66:	timings = 0x00035352;	break;
-			}
-			break;
-		case XFER_MW_DMA_2:
-			switch (pci_clock) {
-				case PCI_CLK_33:	timings = 0x00002020;	break;
-				case PCI_CLK_48:	timings = 0x00013131;	break;
-				case PCI_CLK_66:	timings = 0x00015151;	break;
-			}
-			break;
-		default:
-			return;
-	}
+
+	if (mode >= XFER_UDMA_0)
+		timings =  udma_timing[pci_clock][mode - XFER_UDMA_0];
+	else
+		timings = mwdma_timing[pci_clock][mode - XFER_MW_DMA_0];
 
 	if (unit == 0) {			/* are we configuring drive0? */
 		pci_read_config_dword(hwif->pci_dev, basereg+4, &reg);
@@ -260,66 +230,39 @@ static void sc1200_set_pio_mode(ide_drive_t *drive, const u8 pio)
 }
 
 #ifdef CONFIG_PM
-static ide_hwif_t *lookup_pci_dev (ide_hwif_t *prev, struct pci_dev *dev)
-{
-	int	h;
-
-	for (h = 0; h < MAX_HWIFS; h++) {
-		ide_hwif_t *hwif = &ide_hwifs[h];
-		if (prev) {
-			if (hwif == prev)
-				prev = NULL;	// found previous, now look for next match
-		} else {
-			if (hwif && hwif->pci_dev == dev)
-				return hwif;	// found next match
-		}
-	}
-	return NULL;	// not found
-}
-
-typedef struct sc1200_saved_state_s {
-	__u32		regs[4];
-} sc1200_saved_state_t;
-
+struct sc1200_saved_state {
+	u32 regs[8];
+};
 
 static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 {
-	ide_hwif_t		*hwif = NULL;
-
 	printk("SC1200: suspend(%u)\n", state.event);
 
+	/*
+	 * we only save state when going from full power to less
+	 */
 	if (state.event == PM_EVENT_ON) {
-		// we only save state when going from full power to less
-
-		//
-		// Loop over all interfaces that are part of this PCI device:
-		//
-		while ((hwif = lookup_pci_dev(hwif, dev)) != NULL) {
-			sc1200_saved_state_t	*ss;
-			unsigned int		basereg, r;
-			//
-			// allocate a permanent save area, if not already allocated
-			//
-			ss = (sc1200_saved_state_t *)hwif->config_data;
-			if (ss == NULL) {
-				ss = kmalloc(sizeof(sc1200_saved_state_t), GFP_KERNEL);
-				if (ss == NULL)
-					return -ENOMEM;
-				hwif->config_data = (unsigned long)ss;
-			}
-			ss = (sc1200_saved_state_t *)hwif->config_data;
-			//
-			// Save timing registers:  this may be unnecessary if 
-			// BIOS also does it
-			//
-			basereg = hwif->channel ? 0x50 : 0x40;
-			for (r = 0; r < 4; ++r) {
-				pci_read_config_dword (hwif->pci_dev, basereg + (r<<2), &ss->regs[r]);
-			}
+		struct sc1200_saved_state *ss;
+		unsigned int r;
+
+		/*
+		 * allocate a permanent save area, if not already allocated
+		 */
+		ss = (struct sc1200_saved_state *)pci_get_drvdata(dev);
+		if (ss == NULL) {
+			ss = kmalloc(sizeof(*ss), GFP_KERNEL);
+			if (ss == NULL)
+				return -ENOMEM;
+			pci_set_drvdata(dev, ss);
 		}
-	}
 
-	/* You don't need to iterate over disks -- sysfs should have done that for you already */ 
+		/*
+		 * save timing registers
+		 * (this may be unnecessary if BIOS also does it)
+		 */
+		for (r = 0; r < 8; r++)
+			pci_read_config_dword(dev, 0x40 + r * 4, &ss->regs[r]);
+	}
 
 	pci_disable_device(dev);
 	pci_set_power_state(dev, pci_choose_state(dev, state));
@@ -328,30 +271,25 @@ static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 
 static int sc1200_resume (struct pci_dev *dev)
 {
-	ide_hwif_t	*hwif = NULL;
-	int		i;
+	struct sc1200_saved_state *ss;
+	unsigned int r;
+	int i;
 
 	i = pci_enable_device(dev);
 	if (i)
 		return i;
 
-	//
-	// loop over all interfaces that are part of this pci device:
-	//
-	while ((hwif = lookup_pci_dev(hwif, dev)) != NULL) {
-		unsigned int		basereg, r;
-		sc1200_saved_state_t	*ss = (sc1200_saved_state_t *)hwif->config_data;
-
-		//
-		// Restore timing registers:  this may be unnecessary if BIOS also does it
-		//
-		basereg = hwif->channel ? 0x50 : 0x40;
-		if (ss != NULL) {
-			for (r = 0; r < 4; ++r) {
-				pci_write_config_dword(hwif->pci_dev, basereg + (r<<2), ss->regs[r]);
-			}
-		}
+	ss = (struct sc1200_saved_state *)pci_get_drvdata(dev);
+
+	/*
+	 * restore timing registers
+	 * (this may be unnecessary if BIOS also does it)
+	 */
+	if (ss) {
+		for (r = 0; r < 8; r++)
+			pci_write_config_dword(dev, 0x40 + r * 4, ss->regs[r]);
 	}
+
 	return 0;
 }
 #endif
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index ebb7132..24a85bb 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -254,19 +254,7 @@ static void scc_set_dma_mode(ide_drive_t *drive, const u8 speed)
 		offset = 0; /* 100MHz */
 	}
 
-	switch (speed) {
-	case XFER_UDMA_6:
-	case XFER_UDMA_5:
-	case XFER_UDMA_4:
-	case XFER_UDMA_3:
-	case XFER_UDMA_2:
-	case XFER_UDMA_1:
-	case XFER_UDMA_0:
-		idx = speed - XFER_UDMA_0;
-		break;
-	default:
-		return;
-	}
+	idx = speed - XFER_UDMA_0;
 
 	jcactsel = JCACTSELtbl[offset][idx];
 	if (is_slave) {
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index a728031..e9bd269 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -366,12 +366,17 @@ static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 	}
 }
 
+#define IDE_HFLAGS_SVWKS \
+	(IDE_HFLAG_LEGACY_IRQS | \
+	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
+	 IDE_HFLAG_BOOTABLE)
+
 static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "SvrWks OSB4",
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= 0x00, /* UDMA is problematic on OSB4 */
@@ -379,7 +384,7 @@ static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 		.name		= "SvrWks CSB5",
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -387,7 +392,7 @@ static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 		.name		= "SvrWks CSB6",
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -395,8 +400,7 @@ static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 		.name		= "SvrWks CSB6",
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_SINGLE |
-				  IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAGS_SVWKS | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -404,8 +408,7 @@ static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 		.name		= "SvrWks HT1000",
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_SINGLE |
-				  IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAGS_SVWKS | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index de820aa..7e9dade 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -582,7 +582,6 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 	hwif->pre_reset = NULL;	/* No HBA specific pre_set needed */
 	hwif->resetproc = &sgiioc4_resetproc;/* Reset DMA engine,
 						clear interrupts */
-	hwif->intrproc = NULL;	/* Enable or Disable interrupt from drive */
 	hwif->maskproc = &sgiioc4_maskproc;	/* Mask on/off NIEN register */
 	hwif->quirkproc = NULL;
 	hwif->busproc = NULL;
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 5709c25..7b45eaf 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -278,27 +278,14 @@ static void sil_set_dma_mode(ide_drive_t *drive, const u8 speed)
 
 	scsc = is_sata(hwif) ? 1 : scsc;
 
-	switch(speed) {
-		case XFER_MW_DMA_2:
-		case XFER_MW_DMA_1:
-		case XFER_MW_DMA_0:
-			multi = dma[speed - XFER_MW_DMA_0];
-			mode |= ((unit) ? 0x20 : 0x02);
-			break;
-		case XFER_UDMA_6:
-		case XFER_UDMA_5:
-		case XFER_UDMA_4:
-		case XFER_UDMA_3:
-		case XFER_UDMA_2:
-		case XFER_UDMA_1:
-		case XFER_UDMA_0:
-			multi = dma[2];
-			ultra |= ((scsc) ? (ultra6[speed - XFER_UDMA_0]) :
-					   (ultra5[speed - XFER_UDMA_0]));
-			mode |= ((unit) ? 0x30 : 0x03);
-			break;
-		default:
-			return;
+	if (speed >= XFER_UDMA_0) {
+		multi = dma[2];
+		ultra |= (scsc ? ultra6[speed - XFER_UDMA_0] :
+				 ultra5[speed - XFER_UDMA_0]);
+		mode |= (unit ? 0x30 : 0x03);
+	} else {
+		multi = dma[speed - XFER_MW_DMA_0];
+		mode |= (unit ? 0x20 : 0x02);
 	}
 
 	if (hwif->mmio) {
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index d90b429..85d3699 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -305,59 +305,56 @@ static void sis_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	sis_program_timings(drive, XFER_PIO_0 + pio);
 }
 
-static void sis_set_dma_mode(ide_drive_t *drive, const u8 speed)
+static void sis_ata133_program_udma_timings(ide_drive_t *drive, const u8 mode)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev = drive->hwif->pci_dev;
+	u32 regdw = 0;
+	u8 drive_pci = sis_ata133_get_base(drive), clk, idx;
 
-	/* Config chip for mode */
-	switch(speed) {
-		case XFER_UDMA_6:
-		case XFER_UDMA_5:
-		case XFER_UDMA_4:
-		case XFER_UDMA_3:
-		case XFER_UDMA_2:
-		case XFER_UDMA_1:
-		case XFER_UDMA_0:
-			if (chipset_family >= ATA_133) {
-				u32 regdw = 0;
-				u8 drive_pci = sis_ata133_get_base(drive);
-
-				pci_read_config_dword(dev, drive_pci, &regdw);
-				regdw |= 0x04;
-				regdw &= 0xfffff00f;
-				/* check if ATA133 enable */
-				if (regdw & 0x08) {
-					regdw |= (unsigned long)cycle_time_value[ATA_133][speed-XFER_UDMA_0] << 4;
-					regdw |= (unsigned long)cvs_time_value[ATA_133][speed-XFER_UDMA_0] << 8;
-				} else {
-					regdw |= (unsigned long)cycle_time_value[ATA_100][speed-XFER_UDMA_0] << 4;
-					regdw |= (unsigned long)cvs_time_value[ATA_100][speed-XFER_UDMA_0] << 8;
-				}
-				pci_write_config_dword(dev, (unsigned long)drive_pci, regdw);
-			} else {
-				u8 drive_pci = 0x40 + drive->dn * 2, reg = 0;
-
-				pci_read_config_byte(dev, drive_pci+1, &reg);
-				/* Force the UDMA bit on if we want to use UDMA */
-				reg |= 0x80;
-				/* clean reg cycle time bits */
-				reg &= ~((0xFF >> (8 - cycle_time_range[chipset_family]))
-					 << cycle_time_offset[chipset_family]);
-				/* set reg cycle time bits */
-				reg |= cycle_time_value[chipset_family][speed-XFER_UDMA_0]
-					<< cycle_time_offset[chipset_family];
-				pci_write_config_byte(dev, drive_pci+1, reg);
-			}
-			break;
-		case XFER_MW_DMA_2:
-		case XFER_MW_DMA_1:
-		case XFER_MW_DMA_0:
-			sis_program_timings(drive, speed);
-			break;
-		default:
-			break;
-	}
+	pci_read_config_dword(dev, drive_pci, &regdw);
+
+	regdw |= 0x04;
+	regdw &= 0xfffff00f;
+	/* check if ATA133 enable */
+	clk = (regdw & 0x08) ? ATA_133 : ATA_100;
+	idx = mode - XFER_UDMA_0;
+	regdw |= cycle_time_value[clk][idx] << 4;
+	regdw |= cvs_time_value[clk][idx] << 8;
+
+	pci_write_config_dword(dev, drive_pci, regdw);
+}
+
+static void sis_ata33_program_udma_timings(ide_drive_t *drive, const u8 mode)
+{
+	struct pci_dev *dev = drive->hwif->pci_dev;
+	u8 drive_pci = 0x40 + drive->dn * 2, reg = 0, i = chipset_family;
+
+	pci_read_config_byte(dev, drive_pci + 1, &reg);
+
+	/* force the UDMA bit on if we want to use UDMA */
+	reg |= 0x80;
+	/* clean reg cycle time bits */
+	reg &= ~((0xff >> (8 - cycle_time_range[i])) << cycle_time_offset[i]);
+	/* set reg cycle time bits */
+	reg |= cycle_time_value[i][mode - XFER_UDMA_0] << cycle_time_offset[i];
+
+	pci_write_config_byte(dev, drive_pci + 1, reg);
+}
+
+static void sis_program_udma_timings(ide_drive_t *drive, const u8 mode)
+{
+	if (chipset_family >= ATA_133)	/* ATA_133 */
+		sis_ata133_program_udma_timings(drive, mode);
+	else				/* ATA_33/66/100a/100/133a */
+		sis_ata33_program_udma_timings(drive, mode);
+}
+
+static void sis_set_dma_mode(ide_drive_t *drive, const u8 speed)
+{
+	if (speed >= XFER_UDMA_0)
+		sis_program_udma_timings(drive, speed);
+	else
+		sis_program_timings(drive, speed);
 }
 
 static u8 sis5513_ata133_udma_filter(ide_drive_t *drive)
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index 147d783..069f104 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -115,32 +115,24 @@ static void sl82c105_set_dma_mode(ide_drive_t *drive, const u8 speed)
  	DBG(("sl82c105_tune_chipset(drive:%s, speed:%s)\n",
 	     drive->name, ide_xfer_verbose(speed)));
 
-	switch (speed) {
-	case XFER_MW_DMA_2:
-	case XFER_MW_DMA_1:
-	case XFER_MW_DMA_0:
-		drv_ctrl = mwdma_timings[speed - XFER_MW_DMA_0];
+	drv_ctrl = mwdma_timings[speed - XFER_MW_DMA_0];
 
-		/*
-		 * Store the DMA timings so that we can actually program
-		 * them when DMA will be turned on...
-		 */
-		drive->drive_data &= 0x0000ffff;
-		drive->drive_data |= (unsigned long)drv_ctrl << 16;
+	/*
+	 * Store the DMA timings so that we can actually program
+	 * them when DMA will be turned on...
+	 */
+	drive->drive_data &= 0x0000ffff;
+	drive->drive_data |= (unsigned long)drv_ctrl << 16;
 
-		/*
-		 * If we are already using DMA, we just reprogram
-		 * the drive control register.
-		 */
-		if (drive->using_dma) {
-			struct pci_dev *dev	= HWIF(drive)->pci_dev;
-			int reg 		= 0x44 + drive->dn * 4;
-
-			pci_write_config_word(dev, reg, drv_ctrl);
-		}
-		break;
-	default:
-		return;
+	/*
+	 * If we are already using DMA, we just reprogram
+	 * the drive control register.
+	 */
+	if (drive->using_dma) {
+		struct pci_dev *dev	= HWIF(drive)->pci_dev;
+		int reg 		= 0x44 + drive->dn * 4;
+
+		pci_write_config_word(dev, reg, drv_ctrl);
 	}
 }
 
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index eb4445b..dbbb468 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -91,19 +91,9 @@ static void slc90e66_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	pci_read_config_word(dev, 0x48, &reg48);
 	pci_read_config_word(dev, 0x4a, &reg4a);
 
-	switch(speed) {
-		case XFER_UDMA_4:	u_speed = 4 << (drive->dn * 4); break;
-		case XFER_UDMA_3:	u_speed = 3 << (drive->dn * 4); break;
-		case XFER_UDMA_2:	u_speed = 2 << (drive->dn * 4); break;
-		case XFER_UDMA_1:	u_speed = 1 << (drive->dn * 4); break;
-		case XFER_UDMA_0:	u_speed = 0 << (drive->dn * 4); break;
-		case XFER_MW_DMA_2:
-		case XFER_MW_DMA_1:
-		case XFER_SW_DMA_2:	break;
-		default:		return;
-	}
-
 	if (speed >= XFER_UDMA_0) {
+		u_speed = (speed - XFER_UDMA_0) << (drive->dn * 4);
+
 		if (!(reg48 & u_flag))
 			pci_write_config_word(dev, 0x48, reg48|u_flag);
 		/* FIXME: (reg4a & a_speed) ? */
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index a66ebd1..e1faf6c 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -222,7 +222,8 @@ static const struct ide_port_info tc86c001_chipset __devinitdata = {
 	.name		= "TC86C001",
 	.init_chipset	= init_chipset_tc86c001,
 	.init_hwif	= init_hwif_tc86c001,
-	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_OFF_BOARD,
+	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_OFF_BOARD |
+			  IDE_HFLAG_ABUSE_SET_DMA_MODE,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA4,
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index a227c41..ae52a96 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -81,8 +81,6 @@ static void triflex_set_mode(ide_drive_t *drive, const u8 speed)
 		case XFER_PIO_0:
 			timing = 0x0808;
 			break;
-		default:
-			return;
 	}
 
 	triflex_timings &= ~(0xFFFF << (16 * unit));
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index a0d3c16..4b32c90 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -439,6 +439,7 @@ static const struct ide_port_info via82cxxx_chipset __devinitdata = {
 	.enablebits	= { { 0x40, 0x02, 0x02 }, { 0x40, 0x01, 0x01 } },
 	.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |
 			  IDE_HFLAG_PIO_NO_DOWNGRADE |
+			  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 			  IDE_HFLAG_POST_SET_MODE |
 			  IDE_HFLAG_IO_32BIT |
 			  IDE_HFLAG_BOOTABLE,
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 7f7a598..3dce800 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -438,13 +438,8 @@ pmac_ide_init_hwif_ports(hw_regs_t *hw,
 		if (data_port == pmac_ide[ix].regbase)
 			break;
 
-	if (ix >= MAX_HWIFS) {
-		/* Probably a PCI interface... */
-		for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; ++i)
-			hw->io_ports[i] = data_port + i - IDE_DATA_OFFSET;
-		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
-		return;
-	}
+	if (ix >= MAX_HWIFS)
+		return;		/* not an IDE PMAC interface */
 
 	for (i = 0; i < 8; ++i)
 		hw->io_ports[i] = data_port + i * 0x10;
@@ -833,38 +828,20 @@ static void pmac_ide_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	tl[0] = *timings;
 	tl[1] = *timings2;
 
-	switch(speed) {
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
-		case XFER_UDMA_6:
-		case XFER_UDMA_5:
-		case XFER_UDMA_4:
-		case XFER_UDMA_3:
-		case XFER_UDMA_2:
-		case XFER_UDMA_1:
-		case XFER_UDMA_0:
-			if (pmif->kind == controller_kl_ata4)
-				ret = set_timings_udma_ata4(&tl[0], speed);
-			else if (pmif->kind == controller_un_ata6
-				 || pmif->kind == controller_k2_ata6)
-				ret = set_timings_udma_ata6(&tl[0], &tl[1], speed);
-			else if (pmif->kind == controller_sh_ata6)
-				ret = set_timings_udma_shasta(&tl[0], &tl[1], speed);
-			else
-				ret = 1;
-			break;
-		case XFER_MW_DMA_2:
-		case XFER_MW_DMA_1:
-		case XFER_MW_DMA_0:
-			set_timings_mdma(drive, pmif->kind, &tl[0], &tl[1], speed);
-			break;
-		case XFER_SW_DMA_2:
-		case XFER_SW_DMA_1:
-		case XFER_SW_DMA_0:
-			return;
+	if (speed >= XFER_UDMA_0) {
+		if (pmif->kind == controller_kl_ata4)
+			ret = set_timings_udma_ata4(&tl[0], speed);
+		else if (pmif->kind == controller_un_ata6
+			 || pmif->kind == controller_k2_ata6)
+			ret = set_timings_udma_ata6(&tl[0], &tl[1], speed);
+		else if (pmif->kind == controller_sh_ata6)
+			ret = set_timings_udma_shasta(&tl[0], &tl[1], speed);
+		else
+			ret = -1;
+	} else
+		set_timings_mdma(drive, pmif->kind, &tl[0], &tl[1], speed);
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
-		default:
-			ret = 1;
-	}
 	if (ret)
 		return;
 
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 9706de9..02e9189 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -395,14 +395,12 @@ static int idescsi_expiry(ide_drive_t *drive)
 static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	idescsi_pc_t *pc=scsi->pc;
+	ide_hwif_t *hwif = drive->hwif;
+	idescsi_pc_t *pc = scsi->pc;
 	struct request *rq = pc->rq;
-	atapi_bcount_t bcount;
-	atapi_status_t status;
-	atapi_ireason_t ireason;
-	atapi_feature_t feature;
-
 	unsigned int temp;
+	u16 bcount;
+	u8 stat, ireason;
 
 #if IDESCSI_DEBUG_LOG
 	printk (KERN_INFO "ide-scsi: Reached idescsi_pc_intr interrupt handler\n");
@@ -425,30 +423,29 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 		(void) HWIF(drive)->ide_dma_end(drive);
 	}
 
-	feature.all = 0;
 	/* Clear the interrupt */
-	status.all = HWIF(drive)->INB(IDE_STATUS_REG);
+	stat = drive->hwif->INB(IDE_STATUS_REG);
 
-	if (!status.b.drq) {
+	if ((stat & DRQ_STAT) == 0) {
 		/* No more interrupts */
 		if (test_bit(IDESCSI_LOG_CMD, &scsi->log))
 			printk (KERN_INFO "Packet command completed, %d bytes transferred\n", pc->actually_transferred);
 		local_irq_enable_in_hardirq();
-		if (status.b.check)
+		if (stat & ERR_STAT)
 			rq->errors++;
 		idescsi_end_request (drive, 1, 0);
 		return ide_stopped;
 	}
-	bcount.b.low	= HWIF(drive)->INB(IDE_BCOUNTL_REG);
-	bcount.b.high	= HWIF(drive)->INB(IDE_BCOUNTH_REG);
-	ireason.all	= HWIF(drive)->INB(IDE_IREASON_REG);
+	bcount = (hwif->INB(IDE_BCOUNTH_REG) << 8) |
+		  hwif->INB(IDE_BCOUNTL_REG);
+	ireason = hwif->INB(IDE_IREASON_REG);
 
-	if (ireason.b.cod) {
+	if (ireason & CD) {
 		printk(KERN_ERR "ide-scsi: CoD != 0 in idescsi_pc_intr\n");
 		return ide_do_reset (drive);
 	}
-	if (ireason.b.io) {
-		temp = pc->actually_transferred + bcount.all;
+	if (ireason & IO) {
+		temp = pc->actually_transferred + bcount;
 		if (temp > pc->request_transfer) {
 			if (temp > pc->buffer_size) {
 				printk(KERN_ERR "ide-scsi: The scsi wants to "
@@ -461,11 +458,13 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 						idescsi_input_buffers(drive, pc, temp);
 					else
 						drive->hwif->atapi_input_bytes(drive, pc->current_position, temp);
-					printk(KERN_ERR "ide-scsi: transferred %d of %d bytes\n", temp, bcount.all);
+					printk(KERN_ERR "ide-scsi: transferred"
+							" %d of %d bytes\n",
+							temp, bcount);
 				}
 				pc->actually_transferred += temp;
 				pc->current_position += temp;
-				idescsi_discard_data(drive, bcount.all - temp);
+				idescsi_discard_data(drive, bcount - temp);
 				ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 				return ide_started;
 			}
@@ -474,22 +473,24 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 #endif /* IDESCSI_DEBUG_LOG */
 		}
 	}
-	if (ireason.b.io) {
+	if (ireason & IO) {
 		clear_bit(PC_WRITING, &pc->flags);
 		if (pc->sg)
-			idescsi_input_buffers(drive, pc, bcount.all);
+			idescsi_input_buffers(drive, pc, bcount);
 		else
-			HWIF(drive)->atapi_input_bytes(drive, pc->current_position, bcount.all);
+			hwif->atapi_input_bytes(drive, pc->current_position,
+						bcount);
 	} else {
 		set_bit(PC_WRITING, &pc->flags);
 		if (pc->sg)
-			idescsi_output_buffers (drive, pc, bcount.all);
+			idescsi_output_buffers(drive, pc, bcount);
 		else
-			HWIF(drive)->atapi_output_bytes(drive, pc->current_position, bcount.all);
+			hwif->atapi_output_bytes(drive, pc->current_position,
+						 bcount);
 	}
 	/* Update the current position */
-	pc->actually_transferred += bcount.all;
-	pc->current_position += bcount.all;
+	pc->actually_transferred += bcount;
+	pc->current_position += bcount;
 
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
@@ -501,16 +502,16 @@ static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	idescsi_pc_t *pc = scsi->pc;
-	atapi_ireason_t ireason;
 	ide_startstop_t startstop;
+	u8 ireason;
 
 	if (ide_wait_stat(&startstop,drive,DRQ_STAT,BUSY_STAT,WAIT_READY)) {
 		printk(KERN_ERR "ide-scsi: Strange, packet command "
 			"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason.all	= HWIF(drive)->INB(IDE_IREASON_REG);
-	if (!ireason.b.cod || ireason.b.io) {
+	ireason = hwif->INB(IDE_IREASON_REG);
+	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-scsi: (IO,CoD) != (0,1) while "
 				"issuing a packet command\n");
 		return ide_do_reset (drive);
@@ -573,30 +574,26 @@ static ide_startstop_t idescsi_issue_pc (ide_drive_t *drive, idescsi_pc_t *pc)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	ide_hwif_t *hwif = drive->hwif;
-	atapi_feature_t feature;
-	atapi_bcount_t bcount;
+	u16 bcount;
+	u8 dma = 0;
 
 	scsi->pc=pc;							/* Set the current packet command */
 	pc->actually_transferred=0;					/* We haven't transferred any data yet */
 	pc->current_position=pc->buffer;
-	bcount.all = min(pc->request_transfer, 63 * 1024);		/* Request to transfer the entire buffer at once */
+	/* Request to transfer the entire buffer at once */
+	bcount = min(pc->request_transfer, 63 * 1024);
 
-	feature.all = 0;
 	if (drive->using_dma && !idescsi_map_sg(drive, pc)) {
 		hwif->sg_mapped = 1;
-		feature.b.dma = !hwif->dma_setup(drive);
+		dma = !hwif->dma_setup(drive);
 		hwif->sg_mapped = 0;
 	}
 
 	SELECT_DRIVE(drive);
-	if (IDE_CONTROL_REG)
-		HWIF(drive)->OUTB(drive->ctl, IDE_CONTROL_REG);
 
-	HWIF(drive)->OUTB(feature.all, IDE_FEATURE_REG);
-	HWIF(drive)->OUTB(bcount.b.high, IDE_BCOUNTH_REG);
-	HWIF(drive)->OUTB(bcount.b.low, IDE_BCOUNTL_REG);
+	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK, bcount, dma);
 
-	if (feature.b.dma)
+	if (dma)
 		set_bit(PC_DMA_OK, &pc->flags);
 
 	if (test_bit(IDESCSI_DRQ_INTERRUPT, &scsi->flags)) {
diff --git a/include/asm-cris/arch-v10/ide.h b/include/asm-cris/arch-v10/ide.h
index 78b301e..ea34e0d 100644
--- a/include/asm-cris/arch-v10/ide.h
+++ b/include/asm-cris/arch-v10/ide.h
@@ -89,11 +89,6 @@ static inline void ide_init_default_hwifs(void)
 	}
 }
 
-/* some configuration options we don't need */
-
-#undef SUPPORT_VLB_SYNC
-#define SUPPORT_VLB_SYNC 0
-
 #endif /* __KERNEL__ */
 
 #endif /* __ASMCRIS_IDE_H */
diff --git a/include/asm-cris/arch-v32/ide.h b/include/asm-cris/arch-v32/ide.h
index 1129617..fb9c362 100644
--- a/include/asm-cris/arch-v32/ide.h
+++ b/include/asm-cris/arch-v32/ide.h
@@ -48,11 +48,6 @@ static inline unsigned long ide_default_io_base(int index)
 	return REG_TYPE_CONV(unsigned long, reg_ata_rw_ctrl2, ctrl2);
 }
 
-/* some configuration options we don't need */
-
-#undef SUPPORT_VLB_SYNC
-#define SUPPORT_VLB_SYNC 0
-
 #define IDE_ARCH_ACK_INTR
 #define ide_ack_intr(hwif)	((hwif)->ack_intr(hwif))
 
diff --git a/include/asm-frv/ide.h b/include/asm-frv/ide.h
index f0bd2cb..8c9a540 100644
--- a/include/asm-frv/ide.h
+++ b/include/asm-frv/ide.h
@@ -18,12 +18,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
-#undef SUPPORT_SLOW_DATA_PORTS
-#define SUPPORT_SLOW_DATA_PORTS 0
-
-#undef SUPPORT_VLB_SYNC
-#define SUPPORT_VLB_SYNC 0
-
 #ifndef MAX_HWIFS
 #define MAX_HWIFS 8
 #endif
diff --git a/include/asm-powerpc/ide.h b/include/asm-powerpc/ide.h
index fd7f5a4..6d50310 100644
--- a/include/asm-powerpc/ide.h
+++ b/include/asm-powerpc/ide.h
@@ -42,9 +42,6 @@ struct ide_machdep_calls {
 
 extern struct ide_machdep_calls ppc_ide_md;
 
-#undef	SUPPORT_SLOW_DATA_PORTS
-#define	SUPPORT_SLOW_DATA_PORTS	0
-
 #define IDE_ARCH_OBSOLETE_DEFAULTS
 
 static __inline__ int ide_default_irq(unsigned long base)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d18ee67..40ee170 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -144,7 +144,6 @@ enum rq_cmd_type_bits {
 	 * private REQ_LB opcodes to differentiate what type of request this is
 	 */
 	REQ_TYPE_ATA_CMD,
-	REQ_TYPE_ATA_TASK,
 	REQ_TYPE_ATA_TASKFILE,
 	REQ_TYPE_ATA_PC,
 };
diff --git a/include/linux/hdreg.h b/include/linux/hdreg.h
index 818c6af..ff43f8d 100644
--- a/include/linux/hdreg.h
+++ b/include/linux/hdreg.h
@@ -44,7 +44,9 @@
 
 /* Bits for HD_ERROR */
 #define MARK_ERR		0x01	/* Bad address mark */
+#define ILI_ERR			0x01	/* Illegal Length Indication (ATAPI) */
 #define TRK0_ERR		0x02	/* couldn't find track 0 */
+#define EOM_ERR			0x02	/* End Of Media (ATAPI) */
 #define ABRT_ERR		0x04	/* Command aborted */
 #define MCR_ERR			0x08	/* media change request */
 #define ID_ERR			0x10	/* ID field not found */
@@ -52,6 +54,7 @@
 #define ECC_ERR			0x40	/* Uncorrectable ECC error */
 #define BBD_ERR			0x80	/* pre-EIDE meaning:  block marked bad */
 #define ICRC_ERR		0x80	/* new meaning:  CRC error during transfer */
+#define LFS_ERR			0xf0	/* Last Failed Sense (ATAPI) */
 
 /* Bits of HD_NSECTOR */
 #define CD			0x01
@@ -70,13 +73,13 @@
 #define HDIO_DRIVE_HOB_HDR_SIZE		(8 * sizeof(__u8))
 #define HDIO_DRIVE_TASK_HDR_SIZE	(8 * sizeof(__u8))
 
-#define IDE_DRIVE_TASK_INVALID		-1
 #define IDE_DRIVE_TASK_NO_DATA		0
+#ifndef __KERNEL__
+#define IDE_DRIVE_TASK_INVALID		-1
 #define IDE_DRIVE_TASK_SET_XFER		1
-
 #define IDE_DRIVE_TASK_IN		2
-
 #define IDE_DRIVE_TASK_OUT		3
+#endif
 #define IDE_DRIVE_TASK_RAW_WRITE	4
 
 /*
@@ -87,10 +90,10 @@
 #ifndef __KERNEL__
 #define IDE_TASKFILE_STD_OUT_FLAGS	0xFE
 #define IDE_HOB_STD_OUT_FLAGS		0x3C
-#endif
 
 typedef unsigned char task_ioreg_t;
 typedef unsigned long sata_ioreg_t;
+#endif
 
 typedef union ide_reg_valid_s {
 	unsigned all				: 16;
@@ -116,8 +119,8 @@ typedef union ide_reg_valid_s {
 } ide_reg_valid_t;
 
 typedef struct ide_task_request_s {
-	task_ioreg_t	io_ports[8];
-	task_ioreg_t	hob_ports[8];
+	__u8		io_ports[8];
+	__u8		hob_ports[8]; /* bytes 6 and 7 are unused */
 	ide_reg_valid_t	out_flags;
 	ide_reg_valid_t	in_flags;
 	int		data_phase;
@@ -133,36 +136,35 @@ typedef struct ide_ioctl_request_s {
 } ide_ioctl_request_t;
 
 struct hd_drive_cmd_hdr {
-	task_ioreg_t command;
-	task_ioreg_t sector_number;
-	task_ioreg_t feature;
-	task_ioreg_t sector_count;
+	__u8 command;
+	__u8 sector_number;
+	__u8 feature;
+	__u8 sector_count;
 };
 
+#ifndef __KERNEL__
 typedef struct hd_drive_task_hdr {
-	task_ioreg_t data;
-	task_ioreg_t feature;
-	task_ioreg_t sector_count;
-	task_ioreg_t sector_number;
-	task_ioreg_t low_cylinder;
-	task_ioreg_t high_cylinder;
-	task_ioreg_t device_head;
-	task_ioreg_t command;
+	__u8 data;
+	__u8 feature;
+	__u8 sector_count;
+	__u8 sector_number;
+	__u8 low_cylinder;
+	__u8 high_cylinder;
+	__u8 device_head;
+	__u8 command;
 } task_struct_t;
 
 typedef struct hd_drive_hob_hdr {
-	task_ioreg_t data;
-	task_ioreg_t feature;
-	task_ioreg_t sector_count;
-	task_ioreg_t sector_number;
-	task_ioreg_t low_cylinder;
-	task_ioreg_t high_cylinder;
-	task_ioreg_t device_head;
-	task_ioreg_t control;
+	__u8 data;
+	__u8 feature;
+	__u8 sector_count;
+	__u8 sector_number;
+	__u8 low_cylinder;
+	__u8 high_cylinder;
+	__u8 device_head;
+	__u8 control;
 } hob_struct_t;
-
-#define TASKFILE_INVALID		0x7fff
-#define TASKFILE_48			0x8000
+#endif
 
 #define TASKFILE_NO_DATA		0x0000
 
@@ -178,12 +180,16 @@ typedef struct hd_drive_hob_hdr {
 #define TASKFILE_IN_DMAQ		0x0080
 #define TASKFILE_OUT_DMAQ		0x0100
 
+#ifndef __KERNEL__
 #define TASKFILE_P_IN			0x0200
 #define TASKFILE_P_OUT			0x0400
 #define TASKFILE_P_IN_DMA		0x0800
 #define TASKFILE_P_OUT_DMA		0x1000
 #define TASKFILE_P_IN_DMAQ		0x2000
 #define TASKFILE_P_OUT_DMAQ		0x4000
+#define TASKFILE_48			0x8000
+#define TASKFILE_INVALID		0x7fff
+#endif
 
 /* ATA/ATAPI Commands pre T13 Spec */
 #define WIN_NOP				0x00
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 9a6a41e..1e44099 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -27,25 +27,10 @@
 #include <asm/semaphore.h>
 #include <asm/mutex.h>
 
-/******************************************************************************
- * IDE driver configuration options (play with these as desired):
- *
- * REALLY_SLOW_IO can be defined in ide.c and ide-cd.c, if necessary
- */
-#define INITIAL_MULT_COUNT	0	/* off=0; on=2,4,8,16,32, etc.. */
-
-#ifndef SUPPORT_SLOW_DATA_PORTS		/* 1 to support slow data ports */
-#define SUPPORT_SLOW_DATA_PORTS	1	/* 0 to reduce kernel size */
-#endif
-#ifndef SUPPORT_VLB_SYNC		/* 1 to support weird 32-bit chips */
-#define SUPPORT_VLB_SYNC	1	/* 0 to reduce kernel size */
-#endif
-#ifndef OK_TO_RESET_CONTROLLER		/* 1 needed for good error recovery */
-#define OK_TO_RESET_CONTROLLER	1	/* 0 for use with AH2372A/B interface */
-#endif
-
-#ifndef DISABLE_IRQ_NOSYNC
-#define DISABLE_IRQ_NOSYNC	0
+#if defined(CRIS) || defined(FRV)
+# define SUPPORT_VLB_SYNC 0
+#else
+# define SUPPORT_VLB_SYNC 1
 #endif
 
 /*
@@ -55,10 +40,6 @@
  
 #define IDE_NO_IRQ		(-1)
 
-/*
- *  "No user-serviceable parts" beyond this point  :)
- *****************************************************************************/
-
 typedef unsigned char	byte;	/* used everywhere */
 
 /*
@@ -103,8 +84,6 @@ typedef unsigned char	byte;	/* used everywhere */
 #define IDE_FEATURE_OFFSET	IDE_ERROR_OFFSET
 #define IDE_COMMAND_OFFSET	IDE_STATUS_OFFSET
 
-#define IDE_CONTROL_OFFSET_HOB	(7)
-
 #define IDE_DATA_REG		(HWIF(drive)->io_ports[IDE_DATA_OFFSET])
 #define IDE_ERROR_REG		(HWIF(drive)->io_ports[IDE_ERROR_OFFSET])
 #define IDE_NSECTOR_REG		(HWIF(drive)->io_ports[IDE_NSECTOR_OFFSET])
@@ -327,47 +306,16 @@ static inline void ide_init_hwif_ports(hw_regs_t *hw,
 typedef union {
 	unsigned all			: 8;
 	struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
 		unsigned set_geometry	: 1;
 		unsigned recalibrate	: 1;
 		unsigned set_multmode	: 1;
 		unsigned set_tune	: 1;
 		unsigned serviced	: 1;
 		unsigned reserved	: 3;
-#elif defined(__BIG_ENDIAN_BITFIELD)
-		unsigned reserved	: 3;
-		unsigned serviced	: 1;
-		unsigned set_tune	: 1;
-		unsigned set_multmode	: 1;
-		unsigned recalibrate	: 1;
-		unsigned set_geometry	: 1;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
 	} b;
 } special_t;
 
 /*
- * ATA DATA Register Special.
- * ATA NSECTOR Count Register().
- * ATAPI Byte Count Register.
- */
-typedef union {
-	unsigned all			:16;
-	struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-		unsigned low		:8;	/* LSB */
-		unsigned high		:8;	/* MSB */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-		unsigned high		:8;	/* MSB */
-		unsigned low		:8;	/* LSB */
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-	} b;
-} ata_nsector_t, ata_data_t, atapi_bcount_t;
-
-/*
  * ATA-IDE Select Register, aka Device-Head
  *
  * head		: always zeros here
@@ -398,131 +346,6 @@ typedef union {
 } select_t, ata_select_t;
 
 /*
- * The ATA-IDE Status Register.
- * The ATAPI Status Register.
- *
- * check	: Error occurred
- * idx		: Index Error
- * corr		: Correctable error occurred
- * drq		: Data is request by the device
- * dsc		: Disk Seek Complete			: ata
- *		: Media access command finished		: atapi
- * df		: Device Fault				: ata
- *		: Reserved				: atapi
- * drdy		: Ready, Command Mode Capable		: ata
- *		: Ignored for ATAPI commands		: atapi
- * bsy		: Disk is Busy
- *		: The device has access to the command block
- */
-typedef union {
-	unsigned all			:8;
-	struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-		unsigned check		:1;
-		unsigned idx		:1;
-		unsigned corr		:1;
-		unsigned drq		:1;
-		unsigned dsc		:1;
-		unsigned df		:1;
-		unsigned drdy		:1;
-		unsigned bsy		:1;
-#elif defined(__BIG_ENDIAN_BITFIELD)
-		unsigned bsy		:1;
-		unsigned drdy		:1;
-		unsigned df		:1;
-		unsigned dsc		:1;
-		unsigned drq		:1;
-		unsigned corr           :1;
-		unsigned idx		:1;
-		unsigned check		:1;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-	} b;
-} ata_status_t, atapi_status_t;
-
-/*
- * ATAPI Feature Register
- *
- * dma		: Using DMA or PIO
- * reserved321	: Reserved
- * reserved654	: Reserved (Tag Type)
- * reserved7	: Reserved
- */
-typedef union {
-	unsigned all			:8;
-	struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-		unsigned dma		:1;
-		unsigned reserved321	:3;
-		unsigned reserved654	:3;
-		unsigned reserved7	:1;
-#elif defined(__BIG_ENDIAN_BITFIELD)
-		unsigned reserved7	:1;
-		unsigned reserved654	:3;
-		unsigned reserved321	:3;
-		unsigned dma		:1;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-	} b;
-} atapi_feature_t;
-
-/*
- * ATAPI Interrupt Reason Register.
- *
- * cod		: Information transferred is command (1) or data (0)
- * io		: The device requests us to read (1) or write (0)
- * reserved	: Reserved
- */
-typedef union {
-	unsigned all			:8;
-	struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-		unsigned cod		:1;
-		unsigned io		:1;
-		unsigned reserved	:6;
-#elif defined(__BIG_ENDIAN_BITFIELD)
-		unsigned reserved	:6;
-		unsigned io		:1;
-		unsigned cod		:1;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-	} b;
-} atapi_ireason_t;
-
-/*
- * The ATAPI error register.
- *
- * ili		: Illegal Length Indication
- * eom		: End Of Media Detected
- * abrt		: Aborted command - As defined by ATA
- * mcr		: Media Change Requested - As defined by ATA
- * sense_key	: Sense key of the last failed packet command
- */
-typedef union {
-	unsigned all			:8;
-	struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-		unsigned ili		:1;
-		unsigned eom		:1;
-		unsigned abrt		:1;
-		unsigned mcr		:1;
-		unsigned sense_key	:4;
-#elif defined(__BIG_ENDIAN_BITFIELD)
-		unsigned sense_key	:4;
-		unsigned mcr		:1;
-		unsigned abrt		:1;
-		unsigned eom		:1;
-		unsigned ili		:1;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-	} b;
-} atapi_error_t;
-
-/*
  * Status returned from various ide_ functions
  */
 typedef enum {
@@ -701,8 +524,6 @@ typedef struct hwif_s {
 	void	(*pre_reset)(ide_drive_t *);
 	/* routine to reset controller after a disk reset */
 	void	(*resetproc)(ide_drive_t *);
-	/* special interrupt handling for shared pci interrupts */
-	void	(*intrproc)(ide_drive_t *);
 	/* special host masking for drive selection */
 	void	(*maskproc)(ide_drive_t *, int);
 	/* check host's drive quirk list */
@@ -766,7 +587,6 @@ typedef struct hwif_s {
 	int		rqsize;		/* max sectors per request */
 	int		irq;		/* our irq number */
 
-	unsigned long	dma_master;	/* reference base addr dmabase */
 	unsigned long	dma_base;	/* base addr for dma ports */
 	unsigned long	dma_command;	/* dma command register */
 	unsigned long	dma_vendor1;	/* dma vendor 1 register */
@@ -806,7 +626,6 @@ typedef struct hwif_s {
 /*
  *  internal ide interrupt handler type
  */
-typedef ide_startstop_t (ide_pre_handler_t)(ide_drive_t *, struct request *);
 typedef ide_startstop_t (ide_handler_t)(ide_drive_t *);
 typedef int (ide_expiry_t)(ide_drive_t *);
 
@@ -1020,7 +839,8 @@ int ide_end_dequeued_request(ide_drive_t *drive, struct request *rq,
 
 extern void ide_set_handler (ide_drive_t *drive, ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry);
 
-extern void ide_execute_command(ide_drive_t *, task_ioreg_t cmd, ide_handler_t *, unsigned int, ide_expiry_t *);
+void ide_execute_command(ide_drive_t *, u8, ide_handler_t *, unsigned int,
+			 ide_expiry_t *);
 
 ide_startstop_t __ide_error(ide_drive_t *, struct request *, u8, u8);
 
@@ -1062,52 +882,114 @@ extern void ide_end_drive_cmd(ide_drive_t *, u8, u8);
  */
 extern int ide_wait_cmd(ide_drive_t *, u8, u8, u8, u8, u8 *);
 
+enum {
+	IDE_TFLAG_LBA48			= (1 << 0),
+	IDE_TFLAG_NO_SELECT_MASK	= (1 << 1),
+	IDE_TFLAG_FLAGGED		= (1 << 2),
+	IDE_TFLAG_OUT_DATA		= (1 << 3),
+	IDE_TFLAG_OUT_HOB_FEATURE	= (1 << 4),
+	IDE_TFLAG_OUT_HOB_NSECT		= (1 << 5),
+	IDE_TFLAG_OUT_HOB_LBAL		= (1 << 6),
+	IDE_TFLAG_OUT_HOB_LBAM		= (1 << 7),
+	IDE_TFLAG_OUT_HOB_LBAH		= (1 << 8),
+	IDE_TFLAG_OUT_HOB		= IDE_TFLAG_OUT_HOB_FEATURE |
+					  IDE_TFLAG_OUT_HOB_NSECT |
+					  IDE_TFLAG_OUT_HOB_LBAL |
+					  IDE_TFLAG_OUT_HOB_LBAM |
+					  IDE_TFLAG_OUT_HOB_LBAH,
+	IDE_TFLAG_OUT_FEATURE		= (1 << 9),
+	IDE_TFLAG_OUT_NSECT		= (1 << 10),
+	IDE_TFLAG_OUT_LBAL		= (1 << 11),
+	IDE_TFLAG_OUT_LBAM		= (1 << 12),
+	IDE_TFLAG_OUT_LBAH		= (1 << 13),
+	IDE_TFLAG_OUT_TF		= IDE_TFLAG_OUT_FEATURE |
+					  IDE_TFLAG_OUT_NSECT |
+					  IDE_TFLAG_OUT_LBAL |
+					  IDE_TFLAG_OUT_LBAM |
+					  IDE_TFLAG_OUT_LBAH,
+	IDE_TFLAG_OUT_DEVICE		= (1 << 14),
+	IDE_TFLAG_WRITE			= (1 << 15),
+	IDE_TFLAG_FLAGGED_SET_IN_FLAGS	= (1 << 16),
+	IDE_TFLAG_IN_DATA		= (1 << 17),
+	IDE_TFLAG_CUSTOM_HANDLER	= (1 << 18),
+	IDE_TFLAG_DMA_PIO_FALLBACK	= (1 << 19),
+	IDE_TFLAG_IN_HOB_FEATURE	= (1 << 20),
+	IDE_TFLAG_IN_HOB_NSECT		= (1 << 21),
+	IDE_TFLAG_IN_HOB_LBAL		= (1 << 22),
+	IDE_TFLAG_IN_HOB_LBAM		= (1 << 23),
+	IDE_TFLAG_IN_HOB_LBAH		= (1 << 24),
+	IDE_TFLAG_IN_HOB_LBA		= IDE_TFLAG_IN_HOB_LBAL |
+					  IDE_TFLAG_IN_HOB_LBAM |
+					  IDE_TFLAG_IN_HOB_LBAH,
+	IDE_TFLAG_IN_HOB		= IDE_TFLAG_IN_HOB_FEATURE |
+					  IDE_TFLAG_IN_HOB_NSECT |
+					  IDE_TFLAG_IN_HOB_LBA,
+	IDE_TFLAG_IN_NSECT		= (1 << 25),
+	IDE_TFLAG_IN_LBAL		= (1 << 26),
+	IDE_TFLAG_IN_LBAM		= (1 << 27),
+	IDE_TFLAG_IN_LBAH		= (1 << 28),
+	IDE_TFLAG_IN_LBA		= IDE_TFLAG_IN_LBAL |
+					  IDE_TFLAG_IN_LBAM |
+					  IDE_TFLAG_IN_LBAH,
+	IDE_TFLAG_IN_TF			= IDE_TFLAG_IN_NSECT |
+					  IDE_TFLAG_IN_LBA,
+	IDE_TFLAG_IN_DEVICE		= (1 << 29),
+};
+
+struct ide_taskfile {
+	u8	hob_data;	/*  0: high data byte (for TASKFILE IOCTL) */
+
+	u8	hob_feature;	/*  1-5: additional data to support LBA48 */
+	u8	hob_nsect;
+	u8	hob_lbal;
+	u8	hob_lbam;
+	u8	hob_lbah;
+
+	u8	data;		/*  6: low data byte (for TASKFILE IOCTL) */
+
+	union {			/*  7: */
+		u8 error;	/*   read:  error */
+		u8 feature;	/*  write: feature */
+	};
+
+	u8	nsect;		/*  8: number of sectors */
+	u8	lbal;		/*  9: LBA low */
+	u8	lbam;		/* 10: LBA mid */
+	u8	lbah;		/* 11: LBA high */
+
+	u8	device;		/* 12: device select */
+
+	union {			/* 13: */
+		u8 status;	/*  read: status  */
+		u8 command;	/* write: command */
+	};
+};
+
 typedef struct ide_task_s {
-/*
- *	struct hd_drive_task_hdr	tf;
- *	task_struct_t		tf;
- *	struct hd_drive_hob_hdr		hobf;
- *	hob_struct_t		hobf;
- */
-	task_ioreg_t		tfRegister[8];
-	task_ioreg_t		hobRegister[8];
-	ide_reg_valid_t		tf_out_flags;
-	ide_reg_valid_t		tf_in_flags;
+	union {
+		struct ide_taskfile	tf;
+		u8			tf_array[14];
+	};
+	u32			tf_flags;
 	int			data_phase;
-	int			command_type;
-	ide_pre_handler_t	*prehandler;
-	ide_handler_t		*handler;
 	struct request		*rq;		/* copy of request */
 	void			*special;	/* valid_t generally */
 } ide_task_t;
 
-extern u32 ide_read_24(ide_drive_t *);
+void ide_tf_load(ide_drive_t *, ide_task_t *);
+void ide_tf_read(ide_drive_t *, ide_task_t *);
 
 extern void SELECT_DRIVE(ide_drive_t *);
-extern void SELECT_INTERRUPT(ide_drive_t *);
 extern void SELECT_MASK(ide_drive_t *, int);
-extern void QUIRK_LIST(ide_drive_t *);
 
 extern int drive_is_ready(ide_drive_t *);
 
-/*
- * taskfile io for disks for now...and builds request from ide_ioctl
- */
-extern ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
-
-/*
- * Special Flagged Register Validation Caller
- */
-extern ide_startstop_t flagged_taskfile(ide_drive_t *, ide_task_t *);
+void ide_pktcmd_tf_load(ide_drive_t *, u32, u16, u8);
 
-extern ide_startstop_t set_multmode_intr(ide_drive_t *);
-extern ide_startstop_t set_geometry_intr(ide_drive_t *);
-extern ide_startstop_t recal_intr(ide_drive_t *);
-extern ide_startstop_t task_no_data_intr(ide_drive_t *);
-extern ide_startstop_t task_in_intr(ide_drive_t *);
-extern ide_startstop_t pre_task_out_intr(ide_drive_t *, struct request *);
+ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
 
-extern int ide_raw_taskfile(ide_drive_t *, ide_task_t *, u8 *);
+int ide_raw_taskfile(ide_drive_t *, ide_task_t *, u8 *, u16);
+int ide_no_data_taskfile(ide_drive_t *, ide_task_t *);
 
 int ide_taskfile_ioctl(ide_drive_t *, unsigned int, unsigned long);
 int ide_cmd_ioctl(ide_drive_t *, unsigned int, unsigned long);
@@ -1212,6 +1094,7 @@ enum {
 	IDE_HFLAG_IO_32BIT		= (1 << 24),
 	/* unmask IRQs */
 	IDE_HFLAG_UNMASK_IRQS		= (1 << 25),
+	IDE_HFLAG_ABUSE_SET_DMA_MODE	= (1 << 26),
 };
 
 #ifdef CONFIG_BLK_DEV_OFFBOARD
@@ -1229,7 +1112,7 @@ struct ide_port_info {
 	void			(*fixup)(ide_hwif_t *);
 	ide_pci_enablebit_t	enablebits[2];
 	hwif_chipset_t		chipset;
-	unsigned int		extra;
+	u8			extra;
 	u32			host_flags;
 	u8			pio_mask;
 	u8			swdma_mask;
@@ -1356,6 +1239,7 @@ static inline int ide_dev_is_sata(struct hd_driveid *id)
 	return 0;
 }
 
+u64 ide_get_lba_addr(struct ide_taskfile *, int);
 u8 ide_dump_status(ide_drive_t *, const char *, u8);
 
 typedef struct ide_pio_timings_s {
