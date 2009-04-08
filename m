Return-Path: <linux-kernel-owner+w=401wt.eu-S1764720AbZDHMiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764720AbZDHMiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbZDHMh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:37:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:47226 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbZDHMhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:37:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=iOJYdu9Ff8/Z7nl/3TP/zA0sltrE0EMUgwP760SMEM65Is5fHq/wkPNtV5eo1n1ueZ
         UcK79BDUFkFwBeUxFkZDePsQNF/cyKAT1i1jPp4r6QD8pQ2GAjRIvSy356UAaONoC7zb
         EbLQYeu4jtSL3RsfFBqwYcLHwRaE1ZioCd48Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates part 4 (revised)
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 8 Apr 2009 14:36:08 +0200
Message-Id: <200904081436.08445.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ lunatic TRIM support merge was dropped ]

The overdue IDE bits, mostly fixes but there are also few cleanups (mainly
code removals) which are relatively safe/simple and should make future merges
(TRIM support and block layer related changes from Tejun) much easier:

- bug fixes for few fall-outs from previous IDE updates (Geert Uytterhoeven)

- at91_ide host driver updates including PIO6 support (Stanislaw Gruszka)

- tx493[89]ide host driver updates (Atsushi Nemoto)

- simplification of 'struct ide_taskfile' and tf_{read,load}() methods
  (Sergei Shtylyov)

- ide-cd: initial unification of error handling for fs and pc requests
  (Borislav Petkov)

- removal of superfluous write memory barriers (Grant Grundler)

also contains:

- obviously correct xsysace fix (from Grant Likely, xsysace Maintainer)
  for the very recent regression introduced by my <linux/hdreg.h> cleanups


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/block/xsysace.c     |   12 +-
 drivers/ide/at91_ide.c      |   91 +-------------
 drivers/ide/falconide.c     |   13 ++-
 drivers/ide/ide-acpi.c      |    5 +-
 drivers/ide/ide-atapi.c     |   38 +++----
 drivers/ide/ide-cd.c        |  288 +++++++++++++++++++++----------------------
 drivers/ide/ide-disk.c      |   70 +++++++----
 drivers/ide/ide-disk_proc.c |    6 +-
 drivers/ide/ide-dma-sff.c   |    9 +-
 drivers/ide/ide-h8300.c     |  101 +---------------
 drivers/ide/ide-io-std.c    |   75 +++---------
 drivers/ide/ide-io.c        |   13 +-
 drivers/ide/ide-ioctls.c    |   14 ++-
 drivers/ide/ide-iops.c      |   20 ++--
 drivers/ide/ide-lib.c       |   28 +++--
 drivers/ide/ide-park.c      |    3 +-
 drivers/ide/ide-pm.c        |    3 +-
 drivers/ide/ide-probe.c     |   18 +--
 drivers/ide/ide-proc.c      |    4 +-
 drivers/ide/ide-taskfile.c  |   97 +++++++++-----
 drivers/ide/ns87415.c       |   34 ++----
 drivers/ide/q40ide.c        |   14 ++-
 drivers/ide/scc_pata.c      |   71 +++--------
 drivers/ide/tx4938ide.c     |   89 +-------------
 drivers/ide/tx4939ide.c     |  110 ++---------------
 include/linux/ide.h         |  151 +++++++++--------------
 26 files changed, 461 insertions(+), 916 deletions(-)


Atsushi Nemoto (3):
      tx4939ide: remove wmb()
      tx493[89]ide: Remove big endian version of tx493[89]ide_tf_{load,read}
      tx4939ide: Fix tx4939ide_{in,out}put_data_swap argument

Bartlomiej Zolnierkiewicz (3):
      ide-cd: convert cdrom_decode_status() to use switch statements
      ide-cd: unify handling of fs and pc requests in cdrom_decode_status()
      ide-cd: fix intendation in cdrom_decode_status()

Borislav Petkov (5):
      ide-cd: move status checking into the IRQ handler
      ide-cd: carve out an ide_cd_breathe()-helper for fs write requests
      ide-cd: respect REQ_QUIET for fs requests in cdrom_decode_status()
      ide-cd: update debugging support
      ide-cd: reverse NOT_READY sense key logic

Geert Uytterhoeven (2):
      ide: Fix host drivers that need IRQF_SHARED
      ide: falconide/q40ide - Use __ide_mm_{in,out}sw() for data

Grant Grundler (1):
      ide: remove wmb() from ide-dma-sff.c and scc_pata.c

Grant Likely (1):
      xsysace: Fix dereferencing of cf_id after hd_driveid removal

Huang Weiyi (1):
      ide: remove unused #include <linux/version.h>

Sergei Shtylyov (9):
      ide-h8300: remove mm_{inw|outw}()
      at91_ide: remove custom tf_{read|load}() methods
      ide-h8300: remove custom tf_{read|load}() methods
      ide: replace IDE_TFLAG_* flags by IDE_VALID_*
      ide: simplify 'struct ide_taskfile'
      ide: move common code out of tf_load() method
      ide: call write_devctl() method from tf_read() method
      ide: refactor tf_load() method
      ide: refactor tf_read() method

Stanislaw Gruszka (2):
      at91_ide: remove unused ide_mm_{outb,inb}
      at91_ide: turn on PIO 6 support


diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 6cccdc3..4aecf5d 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -563,7 +563,7 @@ static void ace_fsm_dostate(struct ace_device *ace)
 	case ACE_FSM_STATE_IDENTIFY_PREPARE:
 		/* Send identify command */
 		ace->fsm_task = ACE_TASK_IDENTIFY;
-		ace->data_ptr = &ace->cf_id;
+		ace->data_ptr = ace->cf_id;
 		ace->data_count = ACE_BUF_PER_SECTOR;
 		ace_out(ace, ACE_SECCNTCMD, ACE_SECCNTCMD_IDENTIFY);
 
@@ -608,8 +608,8 @@ static void ace_fsm_dostate(struct ace_device *ace)
 		break;
 
 	case ACE_FSM_STATE_IDENTIFY_COMPLETE:
-		ace_fix_driveid(&ace->cf_id[0]);
-		ace_dump_mem(&ace->cf_id, 512);	/* Debug: Dump out disk ID */
+		ace_fix_driveid(ace->cf_id);
+		ace_dump_mem(ace->cf_id, 512);	/* Debug: Dump out disk ID */
 
 		if (ace->data_result) {
 			/* Error occured, disable the disk */
@@ -622,9 +622,9 @@ static void ace_fsm_dostate(struct ace_device *ace)
 
 			/* Record disk parameters */
 			set_capacity(ace->gd,
-				ata_id_u32(&ace->cf_id, ATA_ID_LBA_CAPACITY));
+				ata_id_u32(ace->cf_id, ATA_ID_LBA_CAPACITY));
 			dev_info(ace->dev, "capacity: %i sectors\n",
-				ata_id_u32(&ace->cf_id, ATA_ID_LBA_CAPACITY));
+				ata_id_u32(ace->cf_id, ATA_ID_LBA_CAPACITY));
 		}
 
 		/* We're done, drop to IDLE state and notify waiters */
@@ -923,7 +923,7 @@ static int ace_release(struct gendisk *disk, fmode_t mode)
 static int ace_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
 	struct ace_device *ace = bdev->bd_disk->private_data;
-	u16 *cf_id = &ace->cf_id[0];
+	u16 *cf_id = ace->cf_id;
 
 	dev_dbg(ace->dev, "ace_getgeo()\n");
 
diff --git a/drivers/ide/at91_ide.c b/drivers/ide/at91_ide.c
index 8eda552..403d0e4 100644
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -20,7 +20,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/clk.h>
@@ -175,90 +174,6 @@ static void at91_ide_output_data(ide_drive_t *drive, struct ide_cmd *cmd,
 	leave_16bit(chipselect, mode);
 }
 
-static u8 ide_mm_inb(unsigned long port)
-{
-	return readb((void __iomem *) port);
-}
-
-static void ide_mm_outb(u8 value, unsigned long port)
-{
-	writeb(value, (void __iomem *) port);
-}
-
-static void at91_ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-	u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
-
-	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
-		HIHI = 0xFF;
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		ide_mm_outb(tf->hob_feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		ide_mm_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		ide_mm_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		ide_mm_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		ide_mm_outb(tf->hob_lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		ide_mm_outb(tf->feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
-		ide_mm_outb(tf->nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
-		ide_mm_outb(tf->lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
-		ide_mm_outb(tf->lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
-		ide_mm_outb(tf->lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		ide_mm_outb((tf->device & HIHI) | drive->select, io_ports->device_addr);
-}
-
-static void at91_ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-
-	/* be sure we're looking at the low order bits */
-	ide_mm_outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
-		tf->error  = ide_mm_inb(io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = ide_mm_inb(io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = ide_mm_inb(io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = ide_mm_inb(io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = ide_mm_inb(io_ports->lbah_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = ide_mm_inb(io_ports->device_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		ide_mm_outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
-			tf->hob_error = ide_mm_inb(io_ports->feature_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect = ide_mm_inb(io_ports->nsect_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal  = ide_mm_inb(io_ports->lbal_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam  = ide_mm_inb(io_ports->lbam_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah  = ide_mm_inb(io_ports->lbah_addr);
-	}
-}
-
 static void at91_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	struct ide_timing *timing;
@@ -284,8 +199,8 @@ static const struct ide_tp_ops at91_ide_tp_ops = {
 	.write_devctl	= ide_write_devctl,
 
 	.dev_select	= ide_dev_select,
-	.tf_load	= at91_ide_tf_load,
-	.tf_read	= at91_ide_tf_read,
+	.tf_load	= ide_tf_load,
+	.tf_read	= ide_tf_read,
 
 	.input_data	= at91_ide_input_data,
 	.output_data	= at91_ide_output_data,
@@ -300,7 +215,7 @@ static const struct ide_port_info at91_ide_port_info __initdata = {
 	.tp_ops		= &at91_ide_tp_ops,
 	.host_flags 	= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA | IDE_HFLAG_SINGLE |
 			  IDE_HFLAG_NO_IO_32BIT | IDE_HFLAG_UNMASK_IRQS,
-	.pio_mask 	= ATA_PIO5,
+	.pio_mask 	= ATA_PIO6,
 };
 
 /*
diff --git a/drivers/ide/falconide.c b/drivers/ide/falconide.c
index afa2af9..0e2df67 100644
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -20,6 +20,7 @@
 #include <asm/atarihw.h>
 #include <asm/atariints.h>
 #include <asm/atari_stdma.h>
+#include <asm/ide.h>
 
 #define DRV_NAME "falconide"
 
@@ -67,8 +68,10 @@ static void falconide_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
-		return insw(data_addr, buf, (len + 1) / 2);
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS)) {
+		__ide_mm_insw(data_addr, buf, (len + 1) / 2);
+		return;
+	}
 
 	raw_insw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
 }
@@ -78,8 +81,10 @@ static void falconide_output_data(ide_drive_t *drive, struct ide_cmd *cmd,
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
-		return outsw(data_addr, buf, (len + 1) / 2);
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS)) {
+		__ide_mm_outsw(data_addr, buf, (len + 1) / 2);
+		return;
+	}
 
 	raw_outsw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
 }
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 12f4369..77f79d2 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -318,8 +318,9 @@ static int do_drive_set_taskfiles(ide_drive_t *drive,
 
 		/* convert GTF to taskfile */
 		memset(&cmd, 0, sizeof(cmd));
-		memcpy(&cmd.tf_array[7], gtf, REGS_PER_GTF);
-		cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+		memcpy(&cmd.tf.feature, gtf, REGS_PER_GTF);
+		cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+		cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
 
 		err = ide_no_data_taskfile(drive, &cmd);
 		if (err) {
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 3e43b88..7201b17 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -254,16 +254,13 @@ EXPORT_SYMBOL_GPL(ide_cd_get_xferlen);
 
 void ide_read_bcount_and_ireason(ide_drive_t *drive, u16 *bcount, u8 *ireason)
 {
-	struct ide_cmd cmd;
+	struct ide_taskfile tf;
 
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.tf_flags = IDE_TFLAG_IN_LBAH | IDE_TFLAG_IN_LBAM |
-		       IDE_TFLAG_IN_NSECT;
+	drive->hwif->tp_ops->tf_read(drive, &tf, IDE_VALID_NSECT |
+				     IDE_VALID_LBAM | IDE_VALID_LBAH);
 
-	drive->hwif->tp_ops->tf_read(drive, &cmd);
-
-	*bcount = (cmd.tf.lbah << 8) | cmd.tf.lbam;
-	*ireason = cmd.tf.nsect & 3;
+	*bcount = (tf.lbah << 8) | tf.lbam;
+	*ireason = tf.nsect & 3;
 }
 EXPORT_SYMBOL_GPL(ide_read_bcount_and_ireason);
 
@@ -439,12 +436,12 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	return ide_started;
 }
 
-static void ide_init_packet_cmd(struct ide_cmd *cmd, u32 tf_flags,
+static void ide_init_packet_cmd(struct ide_cmd *cmd, u8 valid_tf,
 				u16 bcount, u8 dma)
 {
-	cmd->protocol  = dma ? ATAPI_PROT_DMA : ATAPI_PROT_PIO;
-	cmd->tf_flags |= IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
-			 IDE_TFLAG_OUT_FEATURE | tf_flags;
+	cmd->protocol = dma ? ATAPI_PROT_DMA : ATAPI_PROT_PIO;
+	cmd->valid.out.tf = IDE_VALID_LBAH | IDE_VALID_LBAM |
+			    IDE_VALID_FEATURE | valid_tf;
 	cmd->tf.command = ATA_CMD_PACKET;
 	cmd->tf.feature = dma;		/* Use PIO/DMA */
 	cmd->tf.lbam    = bcount & 0xff;
@@ -453,14 +450,11 @@ static void ide_init_packet_cmd(struct ide_cmd *cmd, u32 tf_flags,
 
 static u8 ide_read_ireason(ide_drive_t *drive)
 {
-	struct ide_cmd cmd;
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.tf_flags = IDE_TFLAG_IN_NSECT;
+	struct ide_taskfile tf;
 
-	drive->hwif->tp_ops->tf_read(drive, &cmd);
+	drive->hwif->tp_ops->tf_read(drive, &tf, IDE_VALID_NSECT);
 
-	return cmd.tf.nsect & 3;
+	return tf.nsect & 3;
 }
 
 static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
@@ -588,12 +582,12 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 	ide_expiry_t *expiry = NULL;
 	struct request *rq = hwif->rq;
 	unsigned int timeout;
-	u32 tf_flags;
 	u16 bcount;
+	u8 valid_tf;
 	u8 drq_int = !!(drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT);
 
 	if (dev_is_idecd(drive)) {
-		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
+		valid_tf = IDE_VALID_NSECT | IDE_VALID_LBAL;
 		bcount = ide_cd_get_xferlen(rq);
 		expiry = ide_cd_expiry;
 		timeout = ATAPI_WAIT_PC;
@@ -607,7 +601,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 		pc->xferred = 0;
 		pc->cur_pos = pc->buf;
 
-		tf_flags = IDE_TFLAG_OUT_DEVICE;
+		valid_tf = IDE_VALID_DEVICE;
 		bcount = ((drive->media == ide_tape) ?
 				pc->req_xfer :
 				min(pc->req_xfer, 63 * 1024));
@@ -627,7 +621,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 						       : WAIT_TAPE_CMD;
 	}
 
-	ide_init_packet_cmd(cmd, tf_flags, bcount, drive->dma);
+	ide_init_packet_cmd(cmd, valid_tf, bcount, drive->dma);
 
 	(void)do_rw_taskfile(drive, cmd);
 
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 35729a4..3aec19d 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -265,35 +265,62 @@ static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
 		cdrom_analyze_sense_data(drive, NULL, sense);
 }
 
+
 /*
+ * Allow the drive 5 seconds to recover; some devices will return NOT_READY
+ * while flushing data from cache.
+ *
+ * returns: 0 failed (write timeout expired)
+ *	    1 success
+ */
+static int ide_cd_breathe(ide_drive_t *drive, struct request *rq)
+{
+
+	struct cdrom_info *info = drive->driver_data;
+
+	if (!rq->errors)
+		info->write_timeout = jiffies +	ATAPI_WAIT_WRITE_BUSY;
+
+	rq->errors = 1;
+
+	if (time_after(jiffies, info->write_timeout))
+		return 0;
+	else {
+		struct request_queue *q = drive->queue;
+		unsigned long flags;
+
+		/*
+		 * take a breather relying on the unplug timer to kick us again
+		 */
+
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_plug_device(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+
+		return 1;
+	}
+}
+
+/**
  * Returns:
  * 0: if the request should be continued.
  * 1: if the request will be going through error recovery.
  * 2: if the request should be ended.
  */
-static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
+static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
-	int stat, err, sense_key;
-
-	/* check for errors */
-	stat = hwif->tp_ops->read_status(hwif);
-
-	if (stat_ret)
-		*stat_ret = stat;
-
-	if (OK_STAT(stat, good_stat, BAD_R_STAT))
-		return 0;
+	int err, sense_key, do_end_request = 0;
+	u8 quiet = rq->cmd_flags & REQ_QUIET;
 
 	/* get the IDE error register */
 	err = ide_read_error(drive);
 	sense_key = err >> 4;
 
-	ide_debug_log(IDE_DBG_RQ, "stat: 0x%x, good_stat: 0x%x, cmd[0]: 0x%x, "
-				  "rq->cmd_type: 0x%x, err: 0x%x",
-				  stat, good_stat, rq->cmd[0], rq->cmd_type,
-				  err);
+	ide_debug_log(IDE_DBG_RQ, "cmd: 0x%x, rq->cmd_type: 0x%x, err: 0x%x, "
+				  "stat 0x%x",
+				  rq->cmd[0], rq->cmd_type, err, stat);
 
 	if (blk_sense_request(rq)) {
 		/*
@@ -303,151 +330,108 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		 */
 		rq->cmd_flags |= REQ_FAILED;
 		return 2;
-	} else if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC) {
-		/* All other functions, except for READ. */
+	}
 
-		/*
-		 * if we have an error, pass back CHECK_CONDITION as the
-		 * scsi status byte
-		 */
-		if (blk_pc_request(rq) && !rq->errors)
-			rq->errors = SAM_STAT_CHECK_CONDITION;
+	/* if we have an error, pass CHECK_CONDITION as the SCSI status byte */
+	if (blk_pc_request(rq) && !rq->errors)
+		rq->errors = SAM_STAT_CHECK_CONDITION;
 
-		/* check for tray open */
-		if (sense_key == NOT_READY) {
-			cdrom_saw_media_change(drive);
-		} else if (sense_key == UNIT_ATTENTION) {
-			/* check for media change */
+	if (blk_noretry_request(rq))
+		do_end_request = 1;
+
+	switch (sense_key) {
+	case NOT_READY:
+		if (blk_fs_request(rq) && rq_data_dir(rq) == WRITE) {
+			if (ide_cd_breathe(drive, rq))
+				return 1;
+		} else {
 			cdrom_saw_media_change(drive);
-			return 0;
-		} else if (sense_key == ILLEGAL_REQUEST &&
-			   rq->cmd[0] == GPCMD_START_STOP_UNIT) {
-			/*
-			 * Don't print error message for this condition--
-			 * SFF8090i indicates that 5/24/00 is the correct
-			 * response to a request to close the tray if the
-			 * drive doesn't have that capability.
-			 * cdrom_log_sense() knows this!
-			 */
-		} else if (!(rq->cmd_flags & REQ_QUIET)) {
-			/* otherwise, print an error */
-			ide_dump_status(drive, "packet command error", stat);
+
+			if (blk_fs_request(rq) && !quiet)
+				printk(KERN_ERR PFX "%s: tray open\n",
+					drive->name);
 		}
+		do_end_request = 1;
+		break;
+	case UNIT_ATTENTION:
+		cdrom_saw_media_change(drive);
 
-		rq->cmd_flags |= REQ_FAILED;
+		if (blk_fs_request(rq) == 0)
+			return 0;
 
 		/*
-		 * instead of playing games with moving completions around,
-		 * remove failed request completely and end it when the
-		 * request sense has completed
+		 * Arrange to retry the request but be sure to give up if we've
+		 * retried too many times.
 		 */
-		goto end_request;
-
-	} else if (blk_fs_request(rq)) {
-		int do_end_request = 0;
-
-		/* handle errors from READ and WRITE requests */
-
-		if (blk_noretry_request(rq))
+		if (++rq->errors > ERROR_MAX)
 			do_end_request = 1;
-
-		if (sense_key == NOT_READY) {
-			/* tray open */
-			if (rq_data_dir(rq) == READ) {
-				cdrom_saw_media_change(drive);
-
-				/* fail the request */
-				printk(KERN_ERR PFX "%s: tray open\n",
-						drive->name);
-				do_end_request = 1;
-			} else {
-				struct cdrom_info *info = drive->driver_data;
-
-				/*
-				 * Allow the drive 5 seconds to recover, some
-				 * devices will return this error while flushing
-				 * data from cache.
-				 */
-				if (!rq->errors)
-					info->write_timeout = jiffies +
-							ATAPI_WAIT_WRITE_BUSY;
-				rq->errors = 1;
-				if (time_after(jiffies, info->write_timeout))
-					do_end_request = 1;
-				else {
-					struct request_queue *q = drive->queue;
-					unsigned long flags;
-
-					/*
-					 * take a breather relying on the unplug
-					 * timer to kick us again
-					 */
-					spin_lock_irqsave(q->queue_lock, flags);
-					blk_plug_device(q);
-					spin_unlock_irqrestore(q->queue_lock, flags);
-
-					return 1;
-				}
-			}
-		} else if (sense_key == UNIT_ATTENTION) {
-			/* media change */
-			cdrom_saw_media_change(drive);
-
-			/*
-			 * Arrange to retry the request but be sure to give up
-			 * if we've retried too many times.
-			 */
-			if (++rq->errors > ERROR_MAX)
-				do_end_request = 1;
-		} else if (sense_key == ILLEGAL_REQUEST ||
-			   sense_key == DATA_PROTECT) {
-			/*
-			 * No point in retrying after an illegal request or data
-			 * protect error.
-			 */
+		break;
+	case ILLEGAL_REQUEST:
+		/*
+		 * Don't print error message for this condition -- SFF8090i
+		 * indicates that 5/24/00 is the correct response to a request
+		 * to close the tray if the drive doesn't have that capability.
+		 *
+		 * cdrom_log_sense() knows this!
+		 */
+		if (rq->cmd[0] == GPCMD_START_STOP_UNIT)
+			break;
+		/* fall-through */
+	case DATA_PROTECT:
+		/*
+		 * No point in retrying after an illegal request or data
+		 * protect error.
+		 */
+		if (!quiet)
 			ide_dump_status(drive, "command error", stat);
-			do_end_request = 1;
-		} else if (sense_key == MEDIUM_ERROR) {
-			/*
-			 * No point in re-trying a zillion times on a bad
-			 * sector. If we got here the error is not correctable.
-			 */
-			ide_dump_status(drive, "media error (bad sector)",
+		do_end_request = 1;
+		break;
+	case MEDIUM_ERROR:
+		/*
+		 * No point in re-trying a zillion times on a bad sector.
+		 * If we got here the error is not correctable.
+		 */
+		if (!quiet)
+			ide_dump_status(drive, "media error "
+					"(bad sector)", stat);
+		do_end_request = 1;
+		break;
+	case BLANK_CHECK:
+		/* disk appears blank? */
+		if (!quiet)
+			ide_dump_status(drive, "media error (blank)",
 					stat);
-			do_end_request = 1;
-		} else if (sense_key == BLANK_CHECK) {
-			/* disk appears blank ?? */
-			ide_dump_status(drive, "media error (blank)", stat);
-			do_end_request = 1;
-		} else if ((err & ~ATA_ABORTED) != 0) {
+		do_end_request = 1;
+		break;
+	default:
+		if (blk_fs_request(rq) == 0)
+			break;
+		if (err & ~ATA_ABORTED) {
 			/* go to the default handler for other errors */
 			ide_error(drive, "cdrom_decode_status", stat);
 			return 1;
-		} else if ((++rq->errors > ERROR_MAX)) {
+		} else if (++rq->errors > ERROR_MAX)
 			/* we've racked up too many retries, abort */
 			do_end_request = 1;
-		}
-
-		/*
-		 * End a request through request sense analysis when we have
-		 * sense data. We need this in order to perform end of media
-		 * processing.
-		 */
-		if (do_end_request)
-			goto end_request;
+	}
 
-		/*
-		 * If we got a CHECK_CONDITION status, queue
-		 * a request sense command.
-		 */
-		if (stat & ATA_ERR)
-			cdrom_queue_request_sense(drive, NULL, NULL);
-		return 1;
-	} else {
-		blk_dump_rq_flags(rq, PFX "bad rq");
-		return 2;
+	if (blk_fs_request(rq) == 0) {
+		rq->cmd_flags |= REQ_FAILED;
+		do_end_request = 1;
 	}
 
+	/*
+	 * End a request through request sense analysis when we have sense data.
+	 * We need this in order to perform end of media processing.
+	 */
+	if (do_end_request)
+		goto end_request;
+
+	/* if we got a CHECK_CONDITION status, queue a request sense command */
+	if (stat & ATA_ERR)
+		cdrom_queue_request_sense(drive, NULL, NULL);
+	return 1;
+
 end_request:
 	if (stat & ATA_ERR) {
 		struct request_queue *q = drive->queue;
@@ -624,15 +608,14 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	struct ide_cmd *cmd = &hwif->cmd;
 	struct request *rq = hwif->rq;
 	ide_expiry_t *expiry = NULL;
-	int dma_error = 0, dma, stat, thislen, uptodate = 0;
+	int dma_error = 0, dma, thislen, uptodate = 0;
 	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc, nsectors;
 	int sense = blk_sense_request(rq);
 	unsigned int timeout;
 	u16 len;
-	u8 ireason;
+	u8 ireason, stat;
 
-	ide_debug_log(IDE_DBG_PC, "cmd[0]: 0x%x, write: 0x%x",
-				  rq->cmd[0], write);
+	ide_debug_log(IDE_DBG_PC, "cmd: 0x%x, write: 0x%x", rq->cmd[0], write);
 
 	/* check for errors */
 	dma = drive->dma;
@@ -648,11 +631,16 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		}
 	}
 
-	rc = cdrom_decode_status(drive, 0, &stat);
-	if (rc) {
-		if (rc == 2)
-			goto out_end;
-		return ide_stopped;
+	/* check status */
+	stat = hwif->tp_ops->read_status(hwif);
+
+	if (!OK_STAT(stat, 0, BAD_R_STAT)) {
+		rc = cdrom_decode_status(drive, stat);
+		if (rc) {
+			if (rc == 2)
+				goto out_end;
+			return ide_stopped;
+		}
 	}
 
 	/* using dma, transfer is complete now */
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index c998cf8..a9fbe2c 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -97,35 +97,38 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 	}
 
 	memset(&cmd, 0, sizeof(cmd));
-	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
 
 	if (drive->dev_flags & IDE_DFLAG_LBA) {
 		if (lba48) {
 			pr_debug("%s: LBA=0x%012llx\n", drive->name,
 					(unsigned long long)block);
 
-			tf->hob_nsect = (nsectors >> 8) & 0xff;
-			tf->hob_lbal  = (u8)(block >> 24);
-			if (sizeof(block) != 4) {
-				tf->hob_lbam = (u8)((u64)block >> 32);
-				tf->hob_lbah = (u8)((u64)block >> 40);
-			}
-
 			tf->nsect  = nsectors & 0xff;
 			tf->lbal   = (u8) block;
 			tf->lbam   = (u8)(block >>  8);
 			tf->lbah   = (u8)(block >> 16);
+			tf->device = ATA_LBA;
 
-			cmd.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
+			tf = &cmd.hob;
+			tf->nsect = (nsectors >> 8) & 0xff;
+			tf->lbal  = (u8)(block >> 24);
+			if (sizeof(block) != 4) {
+				tf->lbam = (u8)((u64)block >> 32);
+				tf->lbah = (u8)((u64)block >> 40);
+			}
+
+			cmd.valid.out.hob = IDE_VALID_OUT_HOB;
+			cmd.valid.in.hob  = IDE_VALID_IN_HOB;
+			cmd.tf_flags |= IDE_TFLAG_LBA48;
 		} else {
 			tf->nsect  = nsectors & 0xff;
 			tf->lbal   = block;
 			tf->lbam   = block >>= 8;
 			tf->lbah   = block >>= 8;
-			tf->device = (block >> 8) & 0xf;
+			tf->device = ((block >> 8) & 0xf) | ATA_LBA;
 		}
-
-		tf->device |= ATA_LBA;
 	} else {
 		unsigned int sect, head, cyl, track;
 
@@ -220,15 +223,19 @@ static u64 idedisk_read_native_max_address(ide_drive_t *drive, int lba48)
 		tf->command = ATA_CMD_READ_NATIVE_MAX;
 	tf->device  = ATA_LBA;
 
-	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	if (lba48)
-		cmd.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
+	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
+	if (lba48) {
+		cmd.valid.out.hob = IDE_VALID_OUT_HOB;
+		cmd.valid.in.hob  = IDE_VALID_IN_HOB;
+		cmd.tf_flags = IDE_TFLAG_LBA48;
+	}
 
 	ide_no_data_taskfile(drive, &cmd);
 
 	/* if OK, compute maximum address value */
 	if (!(tf->status & ATA_ERR))
-		addr = ide_get_lba_addr(tf, lba48) + 1;
+		addr = ide_get_lba_addr(&cmd, lba48) + 1;
 
 	return addr;
 }
@@ -250,9 +257,9 @@ static u64 idedisk_set_max_address(ide_drive_t *drive, u64 addr_req, int lba48)
 	tf->lbam     = (addr_req >>= 8) & 0xff;
 	tf->lbah     = (addr_req >>= 8) & 0xff;
 	if (lba48) {
-		tf->hob_lbal = (addr_req >>= 8) & 0xff;
-		tf->hob_lbam = (addr_req >>= 8) & 0xff;
-		tf->hob_lbah = (addr_req >>= 8) & 0xff;
+		cmd.hob.lbal = (addr_req >>= 8) & 0xff;
+		cmd.hob.lbam = (addr_req >>= 8) & 0xff;
+		cmd.hob.lbah = (addr_req >>= 8) & 0xff;
 		tf->command  = ATA_CMD_SET_MAX_EXT;
 	} else {
 		tf->device   = (addr_req >>= 8) & 0x0f;
@@ -260,15 +267,19 @@ static u64 idedisk_set_max_address(ide_drive_t *drive, u64 addr_req, int lba48)
 	}
 	tf->device |= ATA_LBA;
 
-	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	if (lba48)
-		cmd.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
+	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
+	if (lba48) {
+		cmd.valid.out.hob = IDE_VALID_OUT_HOB;
+		cmd.valid.in.hob  = IDE_VALID_IN_HOB;
+		cmd.tf_flags = IDE_TFLAG_LBA48;
+	}
 
 	ide_no_data_taskfile(drive, &cmd);
 
 	/* if OK, compute maximum address value */
 	if (!(tf->status & ATA_ERR))
-		addr_set = ide_get_lba_addr(tf, lba48) + 1;
+		addr_set = ide_get_lba_addr(&cmd, lba48) + 1;
 
 	return addr_set;
 }
@@ -395,8 +406,8 @@ static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 		cmd->tf.command = ATA_CMD_FLUSH_EXT;
 	else
 		cmd->tf.command = ATA_CMD_FLUSH;
-	cmd->tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
-			IDE_TFLAG_DYN;
+	cmd->valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd->tf_flags = IDE_TFLAG_DYN;
 	cmd->protocol = ATA_PROT_NODATA;
 
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
@@ -457,7 +468,8 @@ static int ide_do_setfeature(ide_drive_t *drive, u8 feature, u8 nsect)
 	cmd.tf.feature = feature;
 	cmd.tf.nsect   = nsect;
 	cmd.tf.command = ATA_CMD_SET_FEATURES;
-	cmd.tf_flags   = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
 
 	return ide_no_data_taskfile(drive, &cmd);
 }
@@ -533,7 +545,8 @@ static int do_idedisk_flushcache(ide_drive_t *drive)
 		cmd.tf.command = ATA_CMD_FLUSH_EXT;
 	else
 		cmd.tf.command = ATA_CMD_FLUSH;
-	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
 
 	return ide_no_data_taskfile(drive, &cmd);
 }
@@ -715,7 +728,8 @@ static int ide_disk_set_doorlock(ide_drive_t *drive, struct gendisk *disk,
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.tf.command = on ? ATA_CMD_MEDIA_LOCK : ATA_CMD_MEDIA_UNLOCK;
-	cmd.tf_flags   = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
 
 	ret = ide_no_data_taskfile(drive, &cmd);
 
diff --git a/drivers/ide/ide-disk_proc.c b/drivers/ide/ide-disk_proc.c
index eaea3be..19f263b 100644
--- a/drivers/ide/ide-disk_proc.c
+++ b/drivers/ide/ide-disk_proc.c
@@ -13,7 +13,8 @@ static int smart_enable(ide_drive_t *drive)
 	tf->lbam    = ATA_SMART_LBAM_PASS;
 	tf->lbah    = ATA_SMART_LBAH_PASS;
 	tf->command = ATA_CMD_SMART;
-	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
 
 	return ide_no_data_taskfile(drive, &cmd);
 }
@@ -29,7 +30,8 @@ static int get_smart_data(ide_drive_t *drive, u8 *buf, u8 sub_cmd)
 	tf->lbam    = ATA_SMART_LBAM_PASS;
 	tf->lbah    = ATA_SMART_LBAH_PASS;
 	tf->command = ATA_CMD_SMART;
-	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
 	cmd.protocol = ATA_PROT_PIO;
 
 	return ide_raw_taskfile(drive, &cmd, buf, 1);
diff --git a/drivers/ide/ide-dma-sff.c b/drivers/ide/ide-dma-sff.c
index 16fc46e..e4cdf78 100644
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -277,8 +277,6 @@ void ide_dma_start(ide_drive_t *drive)
 		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 		outb(dma_cmd | ATA_DMA_START, hwif->dma_base + ATA_DMA_CMD);
 	}
-
-	wmb();
 }
 EXPORT_SYMBOL_GPL(ide_dma_start);
 
@@ -286,7 +284,7 @@ EXPORT_SYMBOL_GPL(ide_dma_start);
 int ide_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u8 dma_stat = 0, dma_cmd = 0, mask;
+	u8 dma_stat = 0, dma_cmd = 0;
 
 	/* stop DMA */
 	if (hwif->host_flags & IDE_HFLAG_MMIO) {
@@ -304,11 +302,10 @@ int ide_dma_end(ide_drive_t *drive)
 	/* clear INTR & ERROR bits */
 	ide_dma_sff_write_status(hwif, dma_stat | ATA_DMA_ERR | ATA_DMA_INTR);
 
-	wmb();
+#define CHECK_DMA_MASK (ATA_DMA_ACTIVE | ATA_DMA_ERR | ATA_DMA_INTR)
 
 	/* verify good DMA status */
-	mask = ATA_DMA_ACTIVE | ATA_DMA_ERR | ATA_DMA_INTR;
-	if ((dma_stat & mask) != ATA_DMA_INTR)
+	if ((dma_stat & CHECK_DMA_MASK) != ATA_DMA_INTR)
 		return 0x10 | dma_stat;
 	return 0;
 }
diff --git a/drivers/ide/ide-h8300.c b/drivers/ide/ide-h8300.c
index dac9a6d..c06ebdc 100644
--- a/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -22,103 +22,6 @@
 	(r);				\
 })
 
-static void mm_outw(u16 d, unsigned long a)
-{
-	__asm__("mov.b %w0,r2h\n\t"
-		"mov.b %x0,r2l\n\t"
-		"mov.w r2,@%1"
-		:
-		:"r"(d),"r"(a)
-		:"er2");
-}
-
-static u16 mm_inw(unsigned long a)
-{
-	register u16 r __asm__("er0");
-	__asm__("mov.w @%1,r2\n\t"
-		"mov.b r2l,%x0\n\t"
-		"mov.b r2h,%w0"
-		:"=r"(r)
-		:"r"(a)
-		:"er2");
-	return r;
-}
-
-static void h8300_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-	u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
-
-	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
-		HIHI = 0xFF;
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		outb(tf->hob_feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		outb(tf->hob_lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		outb(tf->feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
-		outb(tf->nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
-		outb(tf->lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
-		outb(tf->lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
-		outb(tf->lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		outb((tf->device & HIHI) | drive->select,
-		     io_ports->device_addr);
-}
-
-static void h8300_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-
-	/* be sure we're looking at the low order bits */
-	outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
-		tf->error  = inb(io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = inb(io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = inb(io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = inb(io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = inb(io_ports->lbah_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = inb(io_ports->device_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
-			tf->hob_error = inb(io_ports->feature_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect = inb(io_ports->nsect_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal  = inb(io_ports->lbal_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam  = inb(io_ports->lbam_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah  = inb(io_ports->lbah_addr);
-	}
-}
-
 static void mm_outsw(unsigned long addr, void *buf, u32 len)
 {
 	unsigned short *bp = (unsigned short *)buf;
@@ -152,8 +55,8 @@ static const struct ide_tp_ops h8300_tp_ops = {
 	.write_devctl		= ide_write_devctl,
 
 	.dev_select		= ide_dev_select,
-	.tf_load		= h8300_tf_load,
-	.tf_read		= h8300_tf_read,
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
 
 	.input_data		= h8300_input_data,
 	.output_data		= h8300_output_data,
diff --git a/drivers/ide/ide-io-std.c b/drivers/ide/ide-io-std.c
index 9cac281..46721c4 100644
--- a/drivers/ide/ide-io-std.c
+++ b/drivers/ide/ide-io-std.c
@@ -85,98 +85,57 @@ void ide_dev_select(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_dev_select);
 
-void ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
+void ide_tf_load(ide_drive_t *drive, struct ide_taskfile *tf, u8 valid)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
 	void (*tf_outb)(u8 addr, unsigned long port);
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-	u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
 	if (mmio)
 		tf_outb = ide_mm_outb;
 	else
 		tf_outb = ide_outb;
 
-	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
-		HIHI = 0xFF;
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		tf_outb(tf->hob_feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		tf_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		tf_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		tf_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		tf_outb(tf->hob_lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
+	if (valid & IDE_VALID_FEATURE)
 		tf_outb(tf->feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
+	if (valid & IDE_VALID_NSECT)
 		tf_outb(tf->nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
+	if (valid & IDE_VALID_LBAL)
 		tf_outb(tf->lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
+	if (valid & IDE_VALID_LBAM)
 		tf_outb(tf->lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
+	if (valid & IDE_VALID_LBAH)
 		tf_outb(tf->lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		tf_outb((tf->device & HIHI) | drive->select,
-			 io_ports->device_addr);
+	if (valid & IDE_VALID_DEVICE)
+		tf_outb(tf->device, io_ports->device_addr);
 }
 EXPORT_SYMBOL_GPL(ide_tf_load);
 
-void ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
+void ide_tf_read(ide_drive_t *drive, struct ide_taskfile *tf, u8 valid)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-	void (*tf_outb)(u8 addr, unsigned long port);
 	u8 (*tf_inb)(unsigned long port);
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
-	if (mmio) {
-		tf_outb = ide_mm_outb;
+	if (mmio)
 		tf_inb  = ide_mm_inb;
-	} else {
-		tf_outb = ide_outb;
+	else
 		tf_inb  = ide_inb;
-	}
-
-	/* be sure we're looking at the low order bits */
-	tf_outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
+	if (valid & IDE_VALID_ERROR)
 		tf->error  = tf_inb(io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (valid & IDE_VALID_NSECT)
 		tf->nsect  = tf_inb(io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (valid & IDE_VALID_LBAL)
 		tf->lbal   = tf_inb(io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (valid & IDE_VALID_LBAM)
 		tf->lbam   = tf_inb(io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (valid & IDE_VALID_LBAH)
 		tf->lbah   = tf_inb(io_ports->lbah_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (valid & IDE_VALID_DEVICE)
 		tf->device = tf_inb(io_ports->device_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		tf_outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
-			tf->hob_error = tf_inb(io_ports->feature_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect = tf_inb(io_ports->nsect_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal  = tf_inb(io_ports->lbal_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam  = tf_inb(io_ports->lbam_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah  = tf_inb(io_ports->lbah_addr);
-	}
 }
 EXPORT_SYMBOL_GPL(ide_tf_read);
 
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 1deb6d2..2ae02b8 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -86,18 +86,18 @@ void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 
 		tp_ops->input_data(drive, cmd, data, 2);
 
-		tf->data = data[0];
-		tf->hob_data = data[1];
+		cmd->tf.data  = data[0];
+		cmd->hob.data = data[1];
 	}
 
-	tp_ops->tf_read(drive, cmd);
+	ide_tf_readback(drive, cmd);
 
 	if ((cmd->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) &&
 	    tf_cmd == ATA_CMD_IDLEIMMEDIATE) {
 		if (tf->lbal != 0xc4) {
 			printk(KERN_ERR "%s: head unload failed!\n",
 			       drive->name);
-			ide_tf_dump(drive->name, tf);
+			ide_tf_dump(drive->name, cmd);
 		} else
 			drive->dev_flags |= IDE_DFLAG_PARKED;
 	}
@@ -205,8 +205,9 @@ static ide_startstop_t ide_disk_special(ide_drive_t *drive)
 		return ide_stopped;
 	}
 
-	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE |
-		       IDE_TFLAG_CUSTOM_HANDLER;
+	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
+	cmd.tf_flags = IDE_TFLAG_CUSTOM_HANDLER;
 
 	do_rw_taskfile(drive, &cmd);
 
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index 7701427..c1c25eb 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -141,11 +141,12 @@ static int ide_cmd_ioctl(ide_drive_t *drive, unsigned long arg)
 		tf->lbal  = args[1];
 		tf->lbam  = 0x4f;
 		tf->lbah  = 0xc2;
-		cmd.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_IN_NSECT;
+		cmd.valid.out.tf = IDE_VALID_OUT_TF;
+		cmd.valid.in.tf  = IDE_VALID_NSECT;
 	} else {
 		tf->nsect = args[1];
-		cmd.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT |
-			       IDE_TFLAG_IN_NSECT;
+		cmd.valid.out.tf = IDE_VALID_FEATURE | IDE_VALID_NSECT;
+		cmd.valid.in.tf  = IDE_VALID_NSECT;
 	}
 	tf->command = args[0];
 	cmd.protocol = args[3] ? ATA_PROT_PIO : ATA_PROT_NODATA;
@@ -205,14 +206,15 @@ static int ide_task_ioctl(ide_drive_t *drive, unsigned long arg)
 		return -EFAULT;
 
 	memset(&cmd, 0, sizeof(cmd));
-	memcpy(&cmd.tf_array[7], &args[1], 6);
+	memcpy(&cmd.tf.feature, &args[1], 6);
 	cmd.tf.command = args[0];
-	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
 
 	err = ide_no_data_taskfile(drive, &cmd);
 
 	args[0] = cmd.tf.command;
-	memcpy(&args[1], &cmd.tf_array[7], 6);
+	memcpy(&args[1], &cmd.tf.feature, 6);
 
 	if (copy_to_user(p, args, 7))
 		err = -EFAULT;
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 27bb70d..c19a221 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -37,14 +37,11 @@ void SELECT_MASK(ide_drive_t *drive, int mask)
 
 u8 ide_read_error(ide_drive_t *drive)
 {
-	struct ide_cmd cmd;
+	struct ide_taskfile tf;
 
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.tf_flags = IDE_TFLAG_IN_ERROR;
+	drive->hwif->tp_ops->tf_read(drive, &tf, IDE_VALID_ERROR);
 
-	drive->hwif->tp_ops->tf_read(drive, &cmd);
-
-	return cmd.tf.error;
+	return tf.error;
 }
 EXPORT_SYMBOL_GPL(ide_read_error);
 
@@ -312,10 +309,10 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
+	struct ide_taskfile tf;
 	u16 *id = drive->id, i;
 	int error = 0;
 	u8 stat;
-	struct ide_cmd cmd;
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	if (hwif->dma_ops)	/* check if host supports DMA */
@@ -347,12 +344,11 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 	udelay(1);
 	tp_ops->write_devctl(hwif, ATA_NIEN | ATA_DEVCTL_OBS);
 
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT;
-	cmd.tf.feature = SETFEATURES_XFER;
-	cmd.tf.nsect   = speed;
+	memset(&tf, 0, sizeof(tf));
+	tf.feature = SETFEATURES_XFER;
+	tf.nsect   = speed;
 
-	tp_ops->tf_load(drive, &cmd);
+	tp_ops->tf_load(drive, &tf, IDE_VALID_FEATURE | IDE_VALID_NSECT);
 
 	tp_ops->exec_command(hwif, ATA_CMD_SET_FEATURES);
 
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 217b7fd..56ff8c4 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -49,16 +49,17 @@ static void ide_dump_opcode(ide_drive_t *drive)
 		printk(KERN_CONT "0x%02x\n", cmd->tf.command);
 }
 
-u64 ide_get_lba_addr(struct ide_taskfile *tf, int lba48)
+u64 ide_get_lba_addr(struct ide_cmd *cmd, int lba48)
 {
+	struct ide_taskfile *tf = &cmd->tf;
 	u32 high, low;
 
-	if (lba48)
-		high = (tf->hob_lbah << 16) | (tf->hob_lbam << 8) |
-			tf->hob_lbal;
-	else
-		high = tf->device & 0xf;
 	low  = (tf->lbah << 16) | (tf->lbam << 8) | tf->lbal;
+	if (lba48) {
+		tf = &cmd->hob;
+		high = (tf->lbah << 16) | (tf->lbam << 8) | tf->lbal;
+	} else
+		high = tf->device & 0xf;
 
 	return ((u64)high << 24) | low;
 }
@@ -71,17 +72,18 @@ static void ide_dump_sector(ide_drive_t *drive)
 	u8 lba48 = !!(drive->dev_flags & IDE_DFLAG_LBA48);
 
 	memset(&cmd, 0, sizeof(cmd));
-	if (lba48)
-		cmd.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_HOB_LBA |
-				IDE_TFLAG_LBA48;
-	else
-		cmd.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_DEVICE;
+	if (lba48) {
+		cmd.valid.in.tf  = IDE_VALID_LBA;
+		cmd.valid.in.hob = IDE_VALID_LBA;
+		cmd.tf_flags = IDE_TFLAG_LBA48;
+	} else
+		cmd.valid.in.tf  = IDE_VALID_LBA | IDE_VALID_DEVICE;
 
-	drive->hwif->tp_ops->tf_read(drive, &cmd);
+	ide_tf_readback(drive, &cmd);
 
 	if (lba48 || (tf->device & ATA_LBA))
 		printk(KERN_CONT ", LBAsect=%llu",
-			(unsigned long long)ide_get_lba_addr(tf, lba48));
+			(unsigned long long)ide_get_lba_addr(&cmd, lba48));
 	else
 		printk(KERN_CONT ", CHS=%d/%d/%d", (tf->lbah << 8) + tf->lbam,
 			tf->device & 0xf, tf->lbal);
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index 9490b44..310d03f 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -74,7 +74,8 @@ ide_startstop_t ide_do_park_unpark(ide_drive_t *drive, struct request *rq)
 		tf->lbal = 0x4c;
 		tf->lbam = 0x4e;
 		tf->lbah = 0x55;
-		cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+		cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+		cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
 	} else		/* cmd == REQ_UNPARK_HEADS */
 		tf->command = ATA_CMD_CHK_POWER;
 
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index bb7858e..0d8a151 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -163,7 +163,8 @@ ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 	return ide_stopped;
 
 out_do_tf:
-	cmd->tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd->valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd->valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
 	cmd->protocol = ATA_PROT_NODATA;
 
 	return do_rw_taskfile(drive, cmd);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index d8c1c3e..7f264ed 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -283,13 +283,11 @@ int ide_dev_read_id(ide_drive_t *drive, u8 cmd, u16 *id)
 	 * identify command to be sure of reply
 	 */
 	if (cmd == ATA_CMD_ID_ATAPI) {
-		struct ide_cmd cmd;
+		struct ide_taskfile tf;
 
-		memset(&cmd, 0, sizeof(cmd));
+		memset(&tf, 0, sizeof(tf));
 		/* disable DMA & overlap */
-		cmd.tf_flags = IDE_TFLAG_OUT_FEATURE;
-
-		tp_ops->tf_load(drive, &cmd);
+		tp_ops->tf_load(drive, &tf, IDE_VALID_FEATURE);
 	}
 
 	/* ask drive for ID */
@@ -337,14 +335,11 @@ int ide_busy_sleep(ide_hwif_t *hwif, unsigned long timeout, int altstatus)
 
 static u8 ide_read_device(ide_drive_t *drive)
 {
-	struct ide_cmd cmd;
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.tf_flags = IDE_TFLAG_IN_DEVICE;
+	struct ide_taskfile tf;
 
-	drive->hwif->tp_ops->tf_read(drive, &cmd);
+	drive->hwif->tp_ops->tf_read(drive, &tf, IDE_VALID_DEVICE);
 
-	return cmd.tf.device;
+	return tf.device;
 }
 
 /**
@@ -1314,6 +1309,7 @@ struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
 		host->get_lock     = d->get_lock;
 		host->release_lock = d->release_lock;
 		host->host_flags = d->host_flags;
+		host->irq_flags = d->irq_flags;
 	}
 
 	return host;
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 10a88bf..3242698 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -204,8 +204,8 @@ static int set_xfer_rate (ide_drive_t *drive, int arg)
 	cmd.tf.command = ATA_CMD_SET_FEATURES;
 	cmd.tf.feature = SETFEATURES_XFER;
 	cmd.tf.nsect   = (u8)arg;
-	cmd.tf_flags   = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT |
-			 IDE_TFLAG_IN_NSECT;
+	cmd.valid.out.tf = IDE_VALID_FEATURE | IDE_VALID_NSECT;
+	cmd.valid.in.tf  = IDE_VALID_NSECT;
 
 	err = ide_no_data_taskfile(drive, &cmd);
 
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 243421c..4aa6223 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -23,17 +23,33 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-void ide_tf_dump(const char *s, struct ide_taskfile *tf)
+void ide_tf_readback(ide_drive_t *drive, struct ide_cmd *cmd)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
+
+	/* Be sure we're looking at the low order bytes */
+	tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
+
+	tp_ops->tf_read(drive, &cmd->tf, cmd->valid.in.tf);
+
+	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
+		tp_ops->write_devctl(hwif, ATA_HOB | ATA_DEVCTL_OBS);
+
+		tp_ops->tf_read(drive, &cmd->hob, cmd->valid.in.hob);
+	}
+}
+
+void ide_tf_dump(const char *s, struct ide_cmd *cmd)
 {
 #ifdef DEBUG
 	printk("%s: tf: feat 0x%02x nsect 0x%02x lbal 0x%02x "
 		"lbam 0x%02x lbah 0x%02x dev 0x%02x cmd 0x%02x\n",
-		s, tf->feature, tf->nsect, tf->lbal,
-		tf->lbam, tf->lbah, tf->device, tf->command);
-	printk("%s: hob: nsect 0x%02x lbal 0x%02x "
-		"lbam 0x%02x lbah 0x%02x\n",
-		s, tf->hob_nsect, tf->hob_lbal,
-		tf->hob_lbam, tf->hob_lbah);
+	       s, cmd->tf.feature, cmd->tf.nsect,
+	       cmd->tf.lbal, cmd->tf.lbam, cmd->tf.lbah,
+	       cmd->tf.device, cmd->tf.command);
+	printk("%s: hob: nsect 0x%02x lbal 0x%02x lbam 0x%02x lbah 0x%02x\n",
+	       s, cmd->hob.nsect, cmd->hob.lbal, cmd->hob.lbam, cmd->hob.lbah);
 #endif
 }
 
@@ -47,7 +63,8 @@ int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
 		cmd.tf.command = ATA_CMD_ID_ATA;
 	else
 		cmd.tf.command = ATA_CMD_ID_ATAPI;
-	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
 	cmd.protocol = ATA_PROT_PIO;
 
 	return ide_raw_taskfile(drive, &cmd, buf, 1);
@@ -79,16 +96,27 @@ ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *orig_cmd)
 	memcpy(cmd, orig_cmd, sizeof(*cmd));
 
 	if ((cmd->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
-		ide_tf_dump(drive->name, tf);
+		ide_tf_dump(drive->name, cmd);
 		tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
 		SELECT_MASK(drive, 0);
 
 		if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA) {
-			u8 data[2] = { tf->data, tf->hob_data };
+			u8 data[2] = { cmd->tf.data, cmd->hob.data };
 
 			tp_ops->output_data(drive, cmd, data, 2);
 		}
-		tp_ops->tf_load(drive, cmd);
+
+		if (cmd->valid.out.tf & IDE_VALID_DEVICE) {
+			u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ?
+				  0xE0 : 0xEF;
+
+			if (!(cmd->ftf_flags & IDE_FTFLAG_FLAGGED))
+				cmd->tf.device &= HIHI;
+			cmd->tf.device |= drive->select;
+		}
+
+		tp_ops->tf_load(drive, &cmd->hob, cmd->valid.out.hob);
+		tp_ops->tf_load(drive, &cmd->tf,  cmd->valid.out.tf);
 	}
 
 	switch (cmd->protocol) {
@@ -489,16 +517,17 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 
 	memset(&cmd, 0, sizeof(cmd));
 
-	memcpy(&cmd.tf_array[0], req_task->hob_ports,
-	       HDIO_DRIVE_HOB_HDR_SIZE - 2);
-	memcpy(&cmd.tf_array[6], req_task->io_ports,
-	       HDIO_DRIVE_TASK_HDR_SIZE);
+	memcpy(&cmd.hob, req_task->hob_ports, HDIO_DRIVE_HOB_HDR_SIZE - 2);
+	memcpy(&cmd.tf,  req_task->io_ports,  HDIO_DRIVE_TASK_HDR_SIZE);
 
-	cmd.tf_flags   = IDE_TFLAG_IO_16BIT | IDE_TFLAG_DEVICE |
-			 IDE_TFLAG_IN_TF;
+	cmd.valid.out.tf = IDE_VALID_DEVICE;
+	cmd.valid.in.tf  = IDE_VALID_DEVICE | IDE_VALID_IN_TF;
+	cmd.tf_flags = IDE_TFLAG_IO_16BIT;
 
-	if (drive->dev_flags & IDE_DFLAG_LBA48)
-		cmd.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_IN_HOB);
+	if (drive->dev_flags & IDE_DFLAG_LBA48) {
+		cmd.tf_flags |= IDE_TFLAG_LBA48;
+		cmd.valid.in.hob = IDE_VALID_IN_HOB;
+	}
 
 	if (req_task->out_flags.all) {
 		cmd.ftf_flags |= IDE_FTFLAG_FLAGGED;
@@ -507,28 +536,28 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 			cmd.ftf_flags |= IDE_FTFLAG_OUT_DATA;
 
 		if (req_task->out_flags.b.nsector_hob)
-			cmd.tf_flags |= IDE_TFLAG_OUT_HOB_NSECT;
+			cmd.valid.out.hob |= IDE_VALID_NSECT;
 		if (req_task->out_flags.b.sector_hob)
-			cmd.tf_flags |= IDE_TFLAG_OUT_HOB_LBAL;
+			cmd.valid.out.hob |= IDE_VALID_LBAL;
 		if (req_task->out_flags.b.lcyl_hob)
-			cmd.tf_flags |= IDE_TFLAG_OUT_HOB_LBAM;
+			cmd.valid.out.hob |= IDE_VALID_LBAM;
 		if (req_task->out_flags.b.hcyl_hob)
-			cmd.tf_flags |= IDE_TFLAG_OUT_HOB_LBAH;
+			cmd.valid.out.hob |= IDE_VALID_LBAH;
 
 		if (req_task->out_flags.b.error_feature)
-			cmd.tf_flags |= IDE_TFLAG_OUT_FEATURE;
+			cmd.valid.out.tf  |= IDE_VALID_FEATURE;
 		if (req_task->out_flags.b.nsector)
-			cmd.tf_flags |= IDE_TFLAG_OUT_NSECT;
+			cmd.valid.out.tf  |= IDE_VALID_NSECT;
 		if (req_task->out_flags.b.sector)
-			cmd.tf_flags |= IDE_TFLAG_OUT_LBAL;
+			cmd.valid.out.tf  |= IDE_VALID_LBAL;
 		if (req_task->out_flags.b.lcyl)
-			cmd.tf_flags |= IDE_TFLAG_OUT_LBAM;
+			cmd.valid.out.tf  |= IDE_VALID_LBAM;
 		if (req_task->out_flags.b.hcyl)
-			cmd.tf_flags |= IDE_TFLAG_OUT_LBAH;
+			cmd.valid.out.tf  |= IDE_VALID_LBAH;
 	} else {
-		cmd.tf_flags |= IDE_TFLAG_OUT_TF;
+		cmd.valid.out.tf |= IDE_VALID_OUT_TF;
 		if (cmd.tf_flags & IDE_TFLAG_LBA48)
-			cmd.tf_flags |= IDE_TFLAG_OUT_HOB;
+			cmd.valid.out.hob |= IDE_VALID_OUT_HOB;
 	}
 
 	if (req_task->in_flags.b.data)
@@ -594,7 +623,7 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 	if (req_task->req_cmd == IDE_DRIVE_TASK_NO_DATA)
 		nsect = 0;
 	else if (!nsect) {
-		nsect = (cmd.tf.hob_nsect << 8) | cmd.tf.nsect;
+		nsect = (cmd.hob.nsect << 8) | cmd.tf.nsect;
 
 		if (!nsect) {
 			printk(KERN_ERR "%s: in/out command without data\n",
@@ -606,10 +635,8 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 
 	err = ide_raw_taskfile(drive, &cmd, data_buf, nsect);
 
-	memcpy(req_task->hob_ports, &cmd.tf_array[0],
-	       HDIO_DRIVE_HOB_HDR_SIZE - 2);
-	memcpy(req_task->io_ports, &cmd.tf_array[6],
-	       HDIO_DRIVE_TASK_HDR_SIZE);
+	memcpy(req_task->hob_ports, &cmd.hob, HDIO_DRIVE_HOB_HDR_SIZE - 2);
+	memcpy(req_task->io_ports,  &cmd.tf,  HDIO_DRIVE_TASK_HDR_SIZE);
 
 	if ((cmd.ftf_flags & IDE_FTFLAG_SET_IN_FLAGS) &&
 	    req_task->in_flags.all == 0) {
diff --git a/drivers/ide/ns87415.c b/drivers/ide/ns87415.c
index 71a39fb..95327a2 100644
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -61,41 +61,23 @@ static u8 superio_dma_sff_read_status(ide_hwif_t *hwif)
 	return superio_ide_inb(hwif->dma_base + ATA_DMA_STATUS);
 }
 
-static void superio_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
+static void superio_tf_read(ide_drive_t *drive, struct ide_taskfile *tf,
+			    u8 valid)
 {
 	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
 
-	/* be sure we're looking at the low order bits */
-	outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
+	if (valid & IDE_VALID_ERROR)
 		tf->error  = inb(io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (valid & IDE_VALID_NSECT)
 		tf->nsect  = inb(io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (valid & IDE_VALID_LBAL)
 		tf->lbal   = inb(io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (valid & IDE_VALID_LBAM)
 		tf->lbam   = inb(io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (valid & IDE_VALID_LBAH)
 		tf->lbah   = inb(io_ports->lbah_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (valid & IDE_VALID_DEVICE)
 		tf->device = superio_ide_inb(io_ports->device_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
-			tf->hob_error = inb(io_ports->feature_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect = inb(io_ports->nsect_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal  = inb(io_ports->lbal_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam  = inb(io_ports->lbam_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah  = inb(io_ports->lbah_addr);
-	}
 }
 
 static void ns87415_dev_select(ide_drive_t *drive);
diff --git a/drivers/ide/q40ide.c b/drivers/ide/q40ide.c
index d007e7f..c793466 100644
--- a/drivers/ide/q40ide.c
+++ b/drivers/ide/q40ide.c
@@ -16,6 +16,8 @@
 #include <linux/blkdev.h>
 #include <linux/ide.h>
 
+#include <asm/ide.h>
+
     /*
      *  Bases of the IDE interfaces
      */
@@ -77,8 +79,10 @@ static void q40ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
-		return insw(data_addr, buf, (len + 1) / 2);
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS)) {
+		__ide_mm_insw(data_addr, buf, (len + 1) / 2);
+		return;
+	}
 
 	raw_insw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
 }
@@ -88,8 +92,10 @@ static void q40ide_output_data(ide_drive_t *drive, struct ide_cmd *cmd,
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
-		return outsw(data_addr, buf, (len + 1) / 2);
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS)) {
+		__ide_mm_outsw(data_addr, buf, (len + 1) / 2);
+		return;
+	}
 
 	raw_outsw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
 }
diff --git a/drivers/ide/scc_pata.c b/drivers/ide/scc_pata.c
index 6d8dbd9..5be41f2 100644
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -337,7 +337,6 @@ static void scc_dma_start(ide_drive_t *drive)
 
 	/* start DMA */
 	scc_ide_outb(dma_cmd | 1, hwif->dma_base);
-	wmb();
 }
 
 static int __scc_dma_end(ide_drive_t *drive)
@@ -354,7 +353,6 @@ static int __scc_dma_end(ide_drive_t *drive)
 	/* clear the INTR & ERROR bits */
 	scc_ide_outb(dma_stat | 6, hwif->dma_base + 4);
 	/* verify good DMA status */
-	wmb();
 	return (dma_stat & 7) != 4 ? (0x10 | dma_stat) : 0;
 }
 
@@ -647,77 +645,40 @@ static int __devinit init_setup_scc(struct pci_dev *dev,
 	return rc;
 }
 
-static void scc_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
+static void scc_tf_load(ide_drive_t *drive, struct ide_taskfile *tf, u8 valid)
 {
 	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-	u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
-
-	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
-		HIHI = 0xFF;
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		scc_ide_outb(tf->hob_feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		scc_ide_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		scc_ide_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		scc_ide_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		scc_ide_outb(tf->hob_lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
+
+	if (valid & IDE_VALID_FEATURE)
 		scc_ide_outb(tf->feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
+	if (valid & IDE_VALID_NSECT)
 		scc_ide_outb(tf->nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
+	if (valid & IDE_VALID_LBAL)
 		scc_ide_outb(tf->lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
+	if (valid & IDE_VALID_LBAM)
 		scc_ide_outb(tf->lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
+	if (valid & IDE_VALID_LBAH)
 		scc_ide_outb(tf->lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		scc_ide_outb((tf->device & HIHI) | drive->select,
-			     io_ports->device_addr);
+	if (valid & IDE_VALID_DEVICE)
+		scc_ide_outb(tf->device, io_ports->device_addr);
 }
 
-static void scc_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
+static void scc_tf_read(ide_drive_t *drive, struct ide_taskfile *tf, u8 valid)
 {
 	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-
-	/* be sure we're looking at the low order bits */
-	scc_ide_outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
+	if (valid & IDE_VALID_ERROR)
 		tf->error  = scc_ide_inb(io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (valid & IDE_VALID_NSECT)
 		tf->nsect  = scc_ide_inb(io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (valid & IDE_VALID_LBAL)
 		tf->lbal   = scc_ide_inb(io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (valid & IDE_VALID_LBAM)
 		tf->lbam   = scc_ide_inb(io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (valid & IDE_VALID_LBAH)
 		tf->lbah   = scc_ide_inb(io_ports->lbah_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (valid & IDE_VALID_DEVICE)
 		tf->device = scc_ide_inb(io_ports->device_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		scc_ide_outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
-			tf->hob_error = scc_ide_inb(io_ports->feature_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect = scc_ide_inb(io_ports->nsect_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal  = scc_ide_inb(io_ports->lbal_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam  = scc_ide_inb(io_ports->lbam_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah  = scc_ide_inb(io_ports->lbah_addr);
-	}
 }
 
 static void scc_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
diff --git a/drivers/ide/tx4938ide.c b/drivers/ide/tx4938ide.c
index 4cb79c4..e33d764 100644
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -72,91 +72,6 @@ static void tx4938ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 #ifdef __BIG_ENDIAN
 
 /* custom iops (independent from SWAP_IO_SPACE) */
-static u8 tx4938ide_inb(unsigned long port)
-{
-	return __raw_readb((void __iomem *)port);
-}
-
-static void tx4938ide_outb(u8 value, unsigned long port)
-{
-	__raw_writeb(value, (void __iomem *)port);
-}
-
-static void tx4938ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-	u8 HIHI = cmd->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
-
-	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
-		HIHI = 0xFF;
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		tx4938ide_outb(tf->hob_feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		tx4938ide_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		tx4938ide_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		tx4938ide_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		tx4938ide_outb(tf->hob_lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		tx4938ide_outb(tf->feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
-		tx4938ide_outb(tf->nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
-		tx4938ide_outb(tf->lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
-		tx4938ide_outb(tf->lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
-		tx4938ide_outb(tf->lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		tx4938ide_outb((tf->device & HIHI) | drive->select,
-			       io_ports->device_addr);
-}
-
-static void tx4938ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-
-	/* be sure we're looking at the low order bits */
-	tx4938ide_outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
-		tf->error  = tx4938ide_inb(io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = tx4938ide_inb(io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = tx4938ide_inb(io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = tx4938ide_inb(io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = tx4938ide_inb(io_ports->lbah_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = tx4938ide_inb(io_ports->device_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		tx4938ide_outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
-			tf->hob_error = tx4938ide_inb(io_ports->feature_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect = tx4938ide_inb(io_ports->nsect_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal  = tx4938ide_inb(io_ports->lbal_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam  = tx4938ide_inb(io_ports->lbam_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah  = tx4938ide_inb(io_ports->lbah_addr);
-	}
-}
-
 static void tx4938ide_input_data_swap(ide_drive_t *drive, struct ide_cmd *cmd,
 				void *buf, unsigned int len)
 {
@@ -190,8 +105,8 @@ static const struct ide_tp_ops tx4938ide_tp_ops = {
 	.write_devctl		= ide_write_devctl,
 
 	.dev_select		= ide_dev_select,
-	.tf_load		= tx4938ide_tf_load,
-	.tf_read		= tx4938ide_tf_read,
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
 
 	.input_data		= tx4938ide_input_data_swap,
 	.output_data		= tx4938ide_output_data_swap,
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index 0040a9a..564422d 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -327,15 +327,15 @@ static int tx4939ide_dma_end(ide_drive_t *drive)
 	/* read and clear the INTR & ERROR bits */
 	dma_stat = tx4939ide_clear_dma_status(base);
 
-	wmb();
+#define CHECK_DMA_MASK (ATA_DMA_ACTIVE | ATA_DMA_ERR | ATA_DMA_INTR)
 
 	/* verify good DMA status */
-	if ((dma_stat & (ATA_DMA_INTR | ATA_DMA_ERR | ATA_DMA_ACTIVE)) == 0 &&
+	if ((dma_stat & CHECK_DMA_MASK) == 0 &&
 	    (ctl & (TX4939IDE_INT_XFEREND | TX4939IDE_INT_HOST)) ==
 	    (TX4939IDE_INT_XFEREND | TX4939IDE_INT_HOST))
 		/* INT_IDE lost... bug? */
 		return 0;
-	return ((dma_stat & (ATA_DMA_INTR | ATA_DMA_ERR | ATA_DMA_ACTIVE)) !=
+	return ((dma_stat & CHECK_DMA_MASK) !=
 		ATA_DMA_INTR) ? 0x10 | dma_stat : 0;
 }
 
@@ -434,97 +434,19 @@ static void tx4939ide_tf_load_fixup(ide_drive_t *drive)
 	tx4939ide_writew(sysctl, base, TX4939IDE_Sys_Ctl);
 }
 
-#ifdef __BIG_ENDIAN
-
-/* custom iops (independent from SWAP_IO_SPACE) */
-static u8 tx4939ide_inb(unsigned long port)
+static void tx4939ide_tf_load(ide_drive_t *drive, struct ide_taskfile *tf,
+			      u8 valid)
 {
-	return __raw_readb((void __iomem *)port);
-}
+	ide_tf_load(drive, tf, valid);
 
-static void tx4939ide_outb(u8 value, unsigned long port)
-{
-	__raw_writeb(value, (void __iomem *)port);
-}
-
-static void tx4939ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-	u8 HIHI = cmd->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
-
-	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
-		HIHI = 0xFF;
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		tx4939ide_outb(tf->hob_feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		tx4939ide_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		tx4939ide_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		tx4939ide_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		tx4939ide_outb(tf->hob_lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		tx4939ide_outb(tf->feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
-		tx4939ide_outb(tf->nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
-		tx4939ide_outb(tf->lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
-		tx4939ide_outb(tf->lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
-		tx4939ide_outb(tf->lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE) {
-		tx4939ide_outb((tf->device & HIHI) | drive->select,
-			       io_ports->device_addr);
+	if (valid & IDE_VALID_DEVICE)
 		tx4939ide_tf_load_fixup(drive);
-	}
 }
 
-static void tx4939ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-
-	/* be sure we're looking at the low order bits */
-	tx4939ide_outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
-		tf->error  = tx4939ide_inb(io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = tx4939ide_inb(io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = tx4939ide_inb(io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = tx4939ide_inb(io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = tx4939ide_inb(io_ports->lbah_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = tx4939ide_inb(io_ports->device_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		tx4939ide_outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
-			tf->hob_error =	tx4939ide_inb(io_ports->feature_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect = tx4939ide_inb(io_ports->nsect_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal  = tx4939ide_inb(io_ports->lbal_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam  = tx4939ide_inb(io_ports->lbam_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah  = tx4939ide_inb(io_ports->lbah_addr);
-	}
-}
+#ifdef __BIG_ENDIAN
 
-static void tx4939ide_input_data_swap(ide_drive_t *drive, struct request *rq,
+/* custom iops (independent from SWAP_IO_SPACE) */
+static void tx4939ide_input_data_swap(ide_drive_t *drive, struct ide_cmd *cmd,
 				void *buf, unsigned int len)
 {
 	unsigned long port = drive->hwif->io_ports.data_addr;
@@ -536,7 +458,7 @@ static void tx4939ide_input_data_swap(ide_drive_t *drive, struct request *rq,
 	__ide_flush_dcache_range((unsigned long)buf, roundup(len, 2));
 }
 
-static void tx4939ide_output_data_swap(ide_drive_t *drive, struct request *rq,
+static void tx4939ide_output_data_swap(ide_drive_t *drive, struct ide_cmd *cmd,
 				void *buf, unsigned int len)
 {
 	unsigned long port = drive->hwif->io_ports.data_addr;
@@ -558,7 +480,7 @@ static const struct ide_tp_ops tx4939ide_tp_ops = {
 
 	.dev_select		= ide_dev_select,
 	.tf_load		= tx4939ide_tf_load,
-	.tf_read		= tx4939ide_tf_read,
+	.tf_read		= ide_tf_read,
 
 	.input_data		= tx4939ide_input_data_swap,
 	.output_data		= tx4939ide_output_data_swap,
@@ -566,14 +488,6 @@ static const struct ide_tp_ops tx4939ide_tp_ops = {
 
 #else	/* __LITTLE_ENDIAN */
 
-static void tx4939ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_tf_load(drive, cmd);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		tx4939ide_tf_load_fixup(drive);
-}
-
 static const struct ide_tp_ops tx4939ide_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
diff --git a/include/linux/ide.h b/include/linux/ide.h
index a5d26f6..ff65fff 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -240,65 +240,38 @@ typedef enum {
 } ide_startstop_t;
 
 enum {
+	IDE_VALID_ERROR 		= (1 << 1),
+	IDE_VALID_FEATURE		= IDE_VALID_ERROR,
+	IDE_VALID_NSECT 		= (1 << 2),
+	IDE_VALID_LBAL			= (1 << 3),
+	IDE_VALID_LBAM			= (1 << 4),
+	IDE_VALID_LBAH			= (1 << 5),
+	IDE_VALID_DEVICE		= (1 << 6),
+	IDE_VALID_LBA			= IDE_VALID_LBAL |
+					  IDE_VALID_LBAM |
+					  IDE_VALID_LBAH,
+	IDE_VALID_OUT_TF		= IDE_VALID_FEATURE |
+					  IDE_VALID_NSECT |
+					  IDE_VALID_LBA,
+	IDE_VALID_IN_TF 		= IDE_VALID_NSECT |
+					  IDE_VALID_LBA,
+	IDE_VALID_OUT_HOB		= IDE_VALID_OUT_TF,
+	IDE_VALID_IN_HOB		= IDE_VALID_ERROR |
+					  IDE_VALID_NSECT |
+					  IDE_VALID_LBA,
+};
+
+enum {
 	IDE_TFLAG_LBA48			= (1 << 0),
-	IDE_TFLAG_OUT_HOB_FEATURE	= (1 << 1),
-	IDE_TFLAG_OUT_HOB_NSECT		= (1 << 2),
-	IDE_TFLAG_OUT_HOB_LBAL		= (1 << 3),
-	IDE_TFLAG_OUT_HOB_LBAM		= (1 << 4),
-	IDE_TFLAG_OUT_HOB_LBAH		= (1 << 5),
-	IDE_TFLAG_OUT_HOB		= IDE_TFLAG_OUT_HOB_FEATURE |
-					  IDE_TFLAG_OUT_HOB_NSECT |
-					  IDE_TFLAG_OUT_HOB_LBAL |
-					  IDE_TFLAG_OUT_HOB_LBAM |
-					  IDE_TFLAG_OUT_HOB_LBAH,
-	IDE_TFLAG_OUT_FEATURE		= (1 << 6),
-	IDE_TFLAG_OUT_NSECT		= (1 << 7),
-	IDE_TFLAG_OUT_LBAL		= (1 << 8),
-	IDE_TFLAG_OUT_LBAM		= (1 << 9),
-	IDE_TFLAG_OUT_LBAH		= (1 << 10),
-	IDE_TFLAG_OUT_TF		= IDE_TFLAG_OUT_FEATURE |
-					  IDE_TFLAG_OUT_NSECT |
-					  IDE_TFLAG_OUT_LBAL |
-					  IDE_TFLAG_OUT_LBAM |
-					  IDE_TFLAG_OUT_LBAH,
-	IDE_TFLAG_OUT_DEVICE		= (1 << 11),
-	IDE_TFLAG_WRITE			= (1 << 12),
-	IDE_TFLAG_CUSTOM_HANDLER	= (1 << 13),
-	IDE_TFLAG_DMA_PIO_FALLBACK	= (1 << 14),
-	IDE_TFLAG_IN_HOB_ERROR		= (1 << 15),
-	IDE_TFLAG_IN_HOB_NSECT		= (1 << 16),
-	IDE_TFLAG_IN_HOB_LBAL		= (1 << 17),
-	IDE_TFLAG_IN_HOB_LBAM		= (1 << 18),
-	IDE_TFLAG_IN_HOB_LBAH		= (1 << 19),
-	IDE_TFLAG_IN_HOB_LBA		= IDE_TFLAG_IN_HOB_LBAL |
-					  IDE_TFLAG_IN_HOB_LBAM |
-					  IDE_TFLAG_IN_HOB_LBAH,
-	IDE_TFLAG_IN_HOB		= IDE_TFLAG_IN_HOB_ERROR |
-					  IDE_TFLAG_IN_HOB_NSECT |
-					  IDE_TFLAG_IN_HOB_LBA,
-	IDE_TFLAG_IN_ERROR		= (1 << 20),
-	IDE_TFLAG_IN_NSECT		= (1 << 21),
-	IDE_TFLAG_IN_LBAL		= (1 << 22),
-	IDE_TFLAG_IN_LBAM		= (1 << 23),
-	IDE_TFLAG_IN_LBAH		= (1 << 24),
-	IDE_TFLAG_IN_LBA		= IDE_TFLAG_IN_LBAL |
-					  IDE_TFLAG_IN_LBAM |
-					  IDE_TFLAG_IN_LBAH,
-	IDE_TFLAG_IN_TF			= IDE_TFLAG_IN_NSECT |
-					  IDE_TFLAG_IN_LBA,
-	IDE_TFLAG_IN_DEVICE		= (1 << 25),
-	IDE_TFLAG_HOB			= IDE_TFLAG_OUT_HOB |
-					  IDE_TFLAG_IN_HOB,
-	IDE_TFLAG_TF			= IDE_TFLAG_OUT_TF |
-					  IDE_TFLAG_IN_TF,
-	IDE_TFLAG_DEVICE		= IDE_TFLAG_OUT_DEVICE |
-					  IDE_TFLAG_IN_DEVICE,
+	IDE_TFLAG_WRITE			= (1 << 1),
+	IDE_TFLAG_CUSTOM_HANDLER	= (1 << 2),
+	IDE_TFLAG_DMA_PIO_FALLBACK	= (1 << 3),
 	/* force 16-bit I/O operations */
-	IDE_TFLAG_IO_16BIT		= (1 << 26),
+	IDE_TFLAG_IO_16BIT		= (1 << 4),
 	/* struct ide_cmd was allocated using kmalloc() */
-	IDE_TFLAG_DYN			= (1 << 27),
-	IDE_TFLAG_FS			= (1 << 28),
-	IDE_TFLAG_MULTI_PIO		= (1 << 29),
+	IDE_TFLAG_DYN			= (1 << 5),
+	IDE_TFLAG_FS			= (1 << 6),
+	IDE_TFLAG_MULTI_PIO		= (1 << 7),
 };
 
 enum {
@@ -309,45 +282,34 @@ enum {
 };
 
 struct ide_taskfile {
-	u8	hob_data;	/*  0: high data byte (for TASKFILE IOCTL) */
-				/*  1-5: additional data to support LBA48 */
-	union {
-		u8 hob_error;	/*   read: error */
-		u8 hob_feature;	/*  write: feature */
-	};
-
-	u8	hob_nsect;
-	u8	hob_lbal;
-	u8	hob_lbam;
-	u8	hob_lbah;
-
-	u8	data;		/*  6: low data byte (for TASKFILE IOCTL) */
-
-	union {			/*  7: */
-		u8 error;	/*   read:  error */
-		u8 feature;	/*  write: feature */
+	u8	data;		/* 0: data byte (for TASKFILE ioctl) */
+	union {			/* 1: */
+		u8 error;	/*  read: error */
+		u8 feature;	/* write: feature */
 	};
-
-	u8	nsect;		/*  8: number of sectors */
-	u8	lbal;		/*  9: LBA low */
-	u8	lbam;		/* 10: LBA mid */
-	u8	lbah;		/* 11: LBA high */
-
-	u8	device;		/* 12: device select */
-
-	union {			/* 13: */
-		u8 status;	/*  read: status  */
+	u8	nsect;		/* 2: number of sectors */
+	u8	lbal;		/* 3: LBA low */
+	u8	lbam;		/* 4: LBA mid */
+	u8	lbah;		/* 5: LBA high */
+	u8	device;		/* 6: device select */
+	union {			/* 7: */
+		u8 status;	/*  read: status */
 		u8 command;	/* write: command */
 	};
 };
 
 struct ide_cmd {
-	union {
-		struct ide_taskfile	tf;
-		u8			tf_array[14];
-	};
+	struct ide_taskfile	tf;
+	struct ide_taskfile	hob;
+	struct {
+		struct {
+			u8		tf;
+			u8		hob;
+		} out, in;
+	} valid;
+
+	u8			tf_flags;
 	u8			ftf_flags;	/* for TASKFILE ioctl */
-	u32			tf_flags;
 	int			protocol;
 
 	int			sg_nents;	  /* number of sg entries */
@@ -662,8 +624,8 @@ struct ide_tp_ops {
 	void	(*write_devctl)(struct hwif_s *, u8);
 
 	void	(*dev_select)(ide_drive_t *);
-	void	(*tf_load)(ide_drive_t *, struct ide_cmd *);
-	void	(*tf_read)(ide_drive_t *, struct ide_cmd *);
+	void	(*tf_load)(ide_drive_t *, struct ide_taskfile *, u8);
+	void	(*tf_read)(ide_drive_t *, struct ide_taskfile *, u8);
 
 	void	(*input_data)(ide_drive_t *, struct ide_cmd *,
 			      void *, unsigned int);
@@ -1162,7 +1124,8 @@ extern int ide_devset_execute(ide_drive_t *drive,
 void ide_complete_cmd(ide_drive_t *, struct ide_cmd *, u8, u8);
 int ide_complete_rq(ide_drive_t *, int, unsigned int);
 
-void ide_tf_dump(const char *, struct ide_taskfile *);
+void ide_tf_readback(ide_drive_t *drive, struct ide_cmd *cmd);
+void ide_tf_dump(const char *, struct ide_cmd *);
 
 void ide_exec_command(ide_hwif_t *, u8);
 u8 ide_read_status(ide_hwif_t *);
@@ -1170,8 +1133,8 @@ u8 ide_read_altstatus(ide_hwif_t *);
 void ide_write_devctl(ide_hwif_t *, u8);
 
 void ide_dev_select(ide_drive_t *);
-void ide_tf_load(ide_drive_t *, struct ide_cmd *);
-void ide_tf_read(ide_drive_t *, struct ide_cmd *);
+void ide_tf_load(ide_drive_t *, struct ide_taskfile *, u8);
+void ide_tf_read(ide_drive_t *, struct ide_taskfile *, u8);
 
 void ide_input_data(ide_drive_t *, struct ide_cmd *, void *, unsigned int);
 void ide_output_data(ide_drive_t *, struct ide_cmd *, void *, unsigned int);
@@ -1529,7 +1492,7 @@ static inline void ide_set_hwifdata (ide_hwif_t * hwif, void *data)
 
 extern void ide_toggle_bounce(ide_drive_t *drive, int on);
 
-u64 ide_get_lba_addr(struct ide_taskfile *, int);
+u64 ide_get_lba_addr(struct ide_cmd *, int);
 u8 ide_dump_status(ide_drive_t *, const char *, u8);
 
 struct ide_timing {
