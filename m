Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbYGNUmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbYGNUmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 16:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYGNUl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 16:41:57 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:51486 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbYGNUlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:41:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=CwgkwJwKqm+GbVEOx9KHYZCeb/kMtTrf9YSge3BtS8T5aHYwHJFDSdF3ORjfUV4MOH
         huKGQgh1JpGDM/f3kWSIIv0P1K9S+m/HTodqs7ip8GHVBHeb1Cxay0PxOGCKhfcb1PeB
         NlCvzyCCOixbm5VMKtxBgfdqhRpQ04/9qWQNc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates [part 1]
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Tue, 15 Jul 2008 22:32:51 +0200
Message-Id: <200807152232.52354.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

A lot of stuff got queued for 2.6.27, for a start:

* Removal of the on-stack struct request instances + conversion of
  IDE code to use blk_execute_rq() from FUJITA Tomonori.

  [ There also few small block patches included as they depend on
    the above IDE changes - this was acked by Jens. ]

* ide_driveid_update() bugfix to correctly mask drive's interrupts
  from Mikhail Cherkashin. 

* ATAPI support unification (generic code resides now in ide-atapi.c
  and ide-{floppy,tape,scsi} device drivers were converted to use it),
  in the process many bugs were shaken out and 300 LOC is gone.

* Code sanitization fixes from Borislav Petkov and Harvey Harrison.

* Removal of obsoleted old-style kernel parameters (another 300 LOC gone).

* Misc fixes/cleanups.


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/kernel-parameters.txt |    3 -
 block/blk-core.c                    |   12 +-
 block/blk-exec.c                    |    6 +-
 drivers/block/paride/pd.c           |   20 +-
 drivers/ide/Kconfig                 |    6 +
 drivers/ide/Makefile                |    1 +
 drivers/ide/arm/palm_bk3710.c       |    3 +-
 drivers/ide/h8300/ide-h8300.c       |    6 +-
 drivers/ide/ide-acpi.c              |    6 +-
 drivers/ide/ide-atapi.c             |  296 ++++++++++++++++++
 drivers/ide/ide-cd.c                |  122 ++++----
 drivers/ide/ide-cd.h                |    4 +-
 drivers/ide/ide-cd_ioctl.c          |  113 ++++----
 drivers/ide/ide-disk.c              |   13 +-
 drivers/ide/ide-dma.c               |    4 +-
 drivers/ide/ide-floppy.c            |  357 +++++------------------
 drivers/ide/ide-io.c                |  114 ++------
 drivers/ide/ide-iops.c              |   38 +--
 drivers/ide/ide-probe.c             |   10 +-
 drivers/ide/ide-tape.c              |  561 ++++++++++-------------------------
 drivers/ide/ide-taskfile.c          |   38 ++-
 drivers/ide/ide-timing.h            |    1 -
 drivers/ide/ide.c                   |  360 ++---------------------
 drivers/ide/legacy/ali14xx.c        |    2 +-
 drivers/ide/legacy/gayle.c          |    4 +-
 drivers/ide/legacy/ht6560b.c        |    2 +-
 drivers/ide/legacy/qd65xx.c         |    4 +-
 drivers/ide/pci/aec62xx.c           |    2 +-
 drivers/ide/pci/alim15x3.c          |    2 +-
 drivers/ide/pci/amd74xx.c           |   16 +-
 drivers/ide/pci/cmd640.c            |    8 +-
 drivers/ide/pci/cmd64x.c            |    4 +-
 drivers/ide/pci/cy82c693.c          |    2 +-
 drivers/ide/pci/hpt366.c            |    3 +-
 drivers/ide/pci/ns87415.c           |    4 +-
 drivers/ide/pci/scc_pata.c          |   12 +-
 drivers/ide/pci/sgiioc4.c           |    7 +-
 drivers/ide/pci/siimage.c           |   25 +-
 drivers/ide/pci/via82cxxx.c         |   16 +-
 drivers/ide/ppc/pmac.c              |    6 +-
 drivers/ide/setup-pci.c             |    4 +-
 drivers/scsi/ide-scsi.c             |  302 +++++--------------
 include/linux/blkdev.h              |    1 -
 include/linux/ide.h                 |   55 ++--
 44 files changed, 927 insertions(+), 1648 deletions(-)
 create mode 100644 drivers/ide/ide-atapi.c


Bartlomiej Zolnierkiewicz (57):
      ide: set REQ_PREEMPT request flag in ide_do_drive_cmd() users
      ide: use __generic_unplug_device() in ide_do_drive_cmd() (take 2)
      block: handle blk_pm_resume_request() requests in blk_execute_rq_nowait()
      ide: remove obsoleted "idebus=" kernel parameter
      ide: remove obsoleted "hdx=" kernel parameters
      ide: cleanup init_ide_data()
      ide: remove obsoleted "ide=" kernel parameters
      ide: remove try_to_flush_leftover_data()
      sgiioc4: use ->extra_base instead of ->dma_status for dma_handle
      ide: remove commented out code from ide_config_drive_speed()
      ide: fix do_probe() to use SELECT_DRIVE()
      ide: remove IDE_TFLAG_NO_SELECT_MASK taskfile flag
      ide: move IRQ unmasking out from ->tf_load method
      ide: remove ->mmio flag from ide_hwif_t
      ide: pass 'hwif *' instead of 'drive *' to ->OUTBSYNC method
      ide: use ->OUTBSYNC in init_irq()
      ide: use ->OUTBSYNC in ide_set_irq()
      ide: remove drive->ctl
      ide-scsi: fix race in idescsi_transfer_pc()
      ide-scsi: fix DRQ checking for DMA transfers in idescsi_pc_intr()
      ide-scsi: fix handling of DMA errors in idescsi_pc_intr()
      ide-scsi: fix Interrupt Reason checking in idescsi_pc_intr()
      ide-scsi: merge idescsi_input_buffers() and idescsi_output_buffers()
      ide-scsi: remove superfluous BUG_ON() from idescsi_transfer_pc()
      ide-scsi: add debug_log() macro
      ide-tape: idetape_pc_intr() should use local_irq_enable_in_hardirq()
      ide-tape: remove superfluous error message from idetape_pc_intr()
      ide-tape: remove superfluous warning message from idetape_issue_pc()
      ide-tape: remove unneeded CONFIG_BLK_DEV_IDEDMA ifdef
      ide-tape: remove stale comments from idetape_pc_intr()
      ide-tape: remove SIMULATE_ERRORS debug code
      ide-floppy: merge idefloppy_transfer_pc() and idefloppy_transfer_pc1()
      ide-{floppy,tape,scsi}: log device name instead of driver name
      ide-tape: make idetape_retry_pc() void
      ide-tape: merge callbacks
      ide-tape: make pc->idetape_callback void
      ide-{floppy,tape}: merge pc->idefloppy_callback and pc->idetape_callback
      ide-{floppy,tape}: PC_FLAG_DMA_RECOMMENDED -> PC_FLAG_DMA_OK
      ide-floppy: start DMA engine in idefloppy_transfer_pc1()
      ide-tape: set PC_FLAG_DMA_IN_PROGRESS flag in idetape_transfer_pc()
      ide-tape: factor out waiting for good ireason from idetape_transfer_pc()
      ide: add PC_FLAG_ZIP_DRIVE pc flag
      ide-{cd,floppy,tape}: remove checking for drive->scsi
      ide-scsi: set drive->scsi flag for devices handled by the driver
      ide: add ide_transfer_pc() helper
      ide-scsi: move idescsi_map_sg() call out from idescsi_issue_pc()
      ide: add PC_FLAG_DRQ_INTERRUPT pc flag
      ide: add ide_issue_pc() helper
      ide-{floppy,tape}: move checking of ->failed_pc to ->callback
      ide-tape: factor out DSC handling from idetape_pc_intr()
      ide-tape: add ide_tape_io_buffers() helper
      ide-tape: always log debug info in idetape_pc_intr() if debugging is enabled
      ide-floppy: add more debugging to idefloppy_pc_intr()
      ide-scsi: use pc->callback
      ide-scsi: add more debugging to idescsi_pc_intr()
      ide-{floppy,scsi}: read Status Register before stopping DMA engine
      ide: add ide_pc_intr() helper

Borislav Petkov (3):
      ide-floppy: merge callbacks
      ide-tape: unify idetape_create_read/write_cmd
      ide-floppy: fix unfortunate function naming

FUJITA Tomonori (15):
      ide-cd: convert ide_cd_queue_pc to use blk_execute_rq
      ide-cd: convert ide_do_drive_cmd path to use blk_execute_rq
      ide-disk: convert ide_do_drive_cmd path to use blk_execute_rq
      ide-floppy: convert ide_do_drive_cmd path to use blk_execute_rq
      ide-taskfile: convert ide_do_drive_cmd path to use blk_execute_rq
      ide-tape: convert ide_do_drive_cmd path to use blk_execute_rq
      ide: convert ide_do_drive_cmd path to use blk_execute_rq
      ide: remove ide_wait/head_wait path in ide_do_drive_cmd
      ide: remove ide_init_drive_cmd
      ide-cd: remove ide_cd_init_rq
      block: convert pd_special_command to use blk_execute_rq
      block: remove the checking for NULL queue in blk_put_request
      block: unexport blk_end_sync_rq
      ide-scsi: replace ide_do_drive_cmd with blk_execute_rq_nowait
      ide: remove action argument in ide_do_drive_cmd

Harvey Harrison (3):
      ide: eliminate FIT() macro
      ide-tape: use clamp_t() rather than nested min_t()/max_t()
      ide: use get_unaligned_* helpers

Mikhail Cherkashin (2):
      palm_bk3710: fix tRP for UDMA mode 4
      ide: disable drive interrupts in ide_driveid_update()


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b52f47d..faeea50 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -722,9 +722,6 @@ and is between 256 and 4096 characters. It is defined in the file
 	hd=		[EIDE] (E)IDE hard drive subsystem geometry
 			Format: <cyl>,<head>,<sect>
 
-	hd?=		[HW] (E)IDE subsystem
-	hd?lun=		See Documentation/ide/ide.txt.
-
 	highmem=nn[KMG]	[KNL,BOOT] forces the highmem zone to have an exact
 			size of <nn>. This works even on boxes that have no
 			highmem otherwise. This also works to reduce highmem
diff --git a/block/blk-core.c b/block/blk-core.c
index 1905aab..ac83cf9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1042,15 +1042,9 @@ void blk_put_request(struct request *req)
 	unsigned long flags;
 	struct request_queue *q = req->q;
 
-	/*
-	 * Gee, IDE calls in w/ NULL q.  Fix IDE and remove the
-	 * following if (q) test.
-	 */
-	if (q) {
-		spin_lock_irqsave(q->queue_lock, flags);
-		__blk_put_request(q, req);
-		spin_unlock_irqrestore(q->queue_lock, flags);
-	}
+	spin_lock_irqsave(q->queue_lock, flags);
+	__blk_put_request(q, req);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL(blk_put_request);
 
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 391dd62..9bceff7 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -18,7 +18,7 @@
  * @rq: request to complete
  * @error: end io status of the request
  */
-void blk_end_sync_rq(struct request *rq, int error)
+static void blk_end_sync_rq(struct request *rq, int error)
 {
 	struct completion *waiting = rq->end_io_data;
 
@@ -31,7 +31,6 @@ void blk_end_sync_rq(struct request *rq, int error)
 	 */
 	complete(waiting);
 }
-EXPORT_SYMBOL(blk_end_sync_rq);
 
 /**
  * blk_execute_rq_nowait - insert a request into queue for execution
@@ -58,6 +57,9 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	spin_lock_irq(q->queue_lock);
 	__elv_add_request(q, rq, where, 1);
 	__generic_unplug_device(q);
+	/* the queue is stopped so it won't be plugged+unplugged */
+	if (blk_pm_resume_request(rq))
+		q->request_fn(q);
 	spin_unlock_irq(q->queue_lock);
 }
 EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 570f3b7..5fdfa7c 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -712,19 +712,17 @@ static void do_pd_request(struct request_queue * q)
 static int pd_special_command(struct pd_unit *disk,
 		      enum action (*func)(struct pd_unit *disk))
 {
-	DECLARE_COMPLETION_ONSTACK(wait);
-	struct request rq;
+	struct request *rq;
 	int err = 0;
 
-	blk_rq_init(NULL, &rq);
-	rq.rq_disk = disk->gd;
-	rq.end_io_data = &wait;
-	rq.end_io = blk_end_sync_rq;
-	blk_insert_request(disk->gd->queue, &rq, 0, func);
-	wait_for_completion(&wait);
-	if (rq.errors)
-		err = -EIO;
-	blk_put_request(&rq);
+	rq = blk_get_request(disk->gd->queue, READ, __GFP_WAIT);
+
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->special = func;
+
+	err = blk_execute_rq(disk->gd->queue, disk->gd, rq, 0);
+
+	blk_put_request(rq);
 	return err;
 }
 
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 1607536..cf707c8 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -98,6 +98,9 @@ if BLK_DEV_IDE
 
 comment "Please see Documentation/ide/ide.txt for help/info on IDE drives"
 
+config IDE_ATAPI
+	bool
+
 config BLK_DEV_IDE_SATA
 	bool "Support for SATA (deprecated; conflicts with libata SATA driver)"
 	default n
@@ -201,6 +204,7 @@ config BLK_DEV_IDECD_VERBOSE_ERRORS
 
 config BLK_DEV_IDETAPE
 	tristate "Include IDE/ATAPI TAPE support"
+	select IDE_ATAPI
 	help
 	  If you have an IDE tape drive using the ATAPI protocol, say Y.
 	  ATAPI is a newer protocol used by IDE tape and CD-ROM drives,
@@ -223,6 +227,7 @@ config BLK_DEV_IDETAPE
 
 config BLK_DEV_IDEFLOPPY
 	tristate "Include IDE/ATAPI FLOPPY support"
+	select IDE_ATAPI
 	---help---
 	  If you have an IDE floppy drive which uses the ATAPI protocol,
 	  answer Y.  ATAPI is a newer protocol used by IDE CD-ROM/tape/floppy
@@ -246,6 +251,7 @@ config BLK_DEV_IDEFLOPPY
 config BLK_DEV_IDESCSI
 	tristate "SCSI emulation support"
 	depends on SCSI
+	select IDE_ATAPI
 	---help---
 	  WARNING: ide-scsi is no longer needed for cd writing applications!
 	  The 2.6 kernel supports direct writing to ide-cd, which eliminates
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index f94b679..a2b3f84 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -14,6 +14,7 @@ EXTRA_CFLAGS				+= -Idrivers/ide
 ide-core-y += ide.o ide-io.o ide-iops.o ide-lib.o ide-probe.o ide-taskfile.o
 
 # core IDE code
+ide-core-$(CONFIG_IDE_ATAPI)		+= ide-atapi.o
 ide-core-$(CONFIG_BLK_DEV_IDEPCI)	+= setup-pci.o
 ide-core-$(CONFIG_BLK_DEV_IDEDMA)	+= ide-dma.o
 ide-core-$(CONFIG_IDE_PROC_FS)		+= ide-proc.o
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index 2f2b4f4..3839f57 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -83,7 +83,7 @@ static const struct palm_bk3710_udmatiming palm_bk3710_udmatimings[6] = {
 	{125, 160},		/* UDMA Mode 1 */
 	{100, 120},		/* UDMA Mode 2 */
 	{100, 90},		/* UDMA Mode 3 */
-	{85,  60},		/* UDMA Mode 4 */
+	{100, 60},		/* UDMA Mode 4 */
 };
 
 static void palm_bk3710_setudmamode(void __iomem *base, unsigned int dev,
@@ -405,7 +405,6 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 	ide_init_port_data(hwif, i);
 	ide_init_port_hw(hwif, &hw);
 
-	hwif->mmio = 1;
 	default_hwif_mmiops(hwif);
 
 	idx[0] = i;
diff --git a/drivers/ide/h8300/ide-h8300.c b/drivers/ide/h8300/ide-h8300.c
index ecf53bb..ae37ee5 100644
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -52,8 +52,6 @@ static void h8300_tf_load(ide_drive_t *drive, ide_task_t *task)
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	ide_set_irq(drive, 1);
-
 	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
 		mm_outw((tf->hob_data << 8) | tf->data, io_ports->data_addr);
 
@@ -98,7 +96,7 @@ static void h8300_tf_read(ide_drive_t *drive, ide_task_t *task)
 	}
 
 	/* be sure we're looking at the low order bits */
-	outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+	outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = inb(io_ports->nsect_addr);
@@ -112,7 +110,7 @@ static void h8300_tf_read(ide_drive_t *drive, ide_task_t *task)
 		tf->device = inb(io_ports->device_addr);
 
 	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		outb(drive->ctl | 0x80, io_ports->ctl_addr);
+		outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = inb(io_ports->feature_addr);
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 9d3601f..6f70462 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -60,15 +60,15 @@ struct ide_acpi_hwif_link {
 #define DEBPRINT(fmt, args...)	do {} while (0)
 #endif	/* DEBUGGING */
 
-int ide_noacpi;
+static int ide_noacpi;
 module_param_named(noacpi, ide_noacpi, bool, 0);
 MODULE_PARM_DESC(noacpi, "disable IDE ACPI support");
 
-int ide_acpigtf;
+static int ide_acpigtf;
 module_param_named(acpigtf, ide_acpigtf, bool, 0);
 MODULE_PARM_DESC(acpigtf, "enable IDE ACPI _GTF support");
 
-int ide_acpionboot;
+static int ide_acpionboot;
 module_param_named(acpionboot, ide_acpionboot, bool, 0);
 MODULE_PARM_DESC(acpionboot, "call IDE ACPI methods on boot");
 
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
new file mode 100644
index 0000000..2802031
--- /dev/null
+++ b/drivers/ide/ide-atapi.c
@@ -0,0 +1,296 @@
+/*
+ * ATAPI support.
+ */
+
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/ide.h>
+#include <scsi/scsi.h>
+
+#ifdef DEBUG
+#define debug_log(fmt, args...) \
+	printk(KERN_INFO "ide: " fmt, ## args)
+#else
+#define debug_log(fmt, args...) do {} while (0)
+#endif
+
+/* TODO: unify the code thus making some arguments go away */
+ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
+	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
+	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
+	void (*retry_pc)(ide_drive_t *), void (*dsc_handle)(ide_drive_t *),
+	void (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
+{
+	ide_hwif_t *hwif = drive->hwif;
+	xfer_func_t *xferfunc;
+	unsigned int temp;
+	u16 bcount;
+	u8 stat, ireason, scsi = drive->scsi;
+
+	debug_log("Enter %s - interrupt handler\n", __func__);
+
+	if (pc->flags & PC_FLAG_TIMEDOUT) {
+		pc->callback(drive);
+		return ide_stopped;
+	}
+
+	/* Clear the interrupt */
+	stat = ide_read_status(drive);
+
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+		if (hwif->dma_ops->dma_end(drive) ||
+		    (drive->media == ide_tape && !scsi && (stat & ERR_STAT))) {
+			if (drive->media == ide_floppy && !scsi)
+				printk(KERN_ERR "%s: DMA %s error\n",
+					drive->name, rq_data_dir(pc->rq)
+						     ? "write" : "read");
+			pc->flags |= PC_FLAG_DMA_ERROR;
+		} else {
+			pc->xferred = pc->req_xfer;
+			if (update_buffers)
+				update_buffers(drive, pc);
+		}
+		debug_log("%s: DMA finished\n", drive->name);
+	}
+
+	/* No more interrupts */
+	if ((stat & DRQ_STAT) == 0) {
+		debug_log("Packet command completed, %d bytes transferred\n",
+			  pc->xferred);
+
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
+
+		local_irq_enable_in_hardirq();
+
+		if (drive->media == ide_tape && !scsi &&
+		    (stat & ERR_STAT) && pc->c[0] == REQUEST_SENSE)
+			stat &= ~ERR_STAT;
+		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
+			/* Error detected */
+			debug_log("%s: I/O error\n", drive->name);
+
+			if (drive->media != ide_tape || scsi) {
+				pc->rq->errors++;
+				if (scsi)
+					goto cmd_finished;
+			}
+
+			if (pc->c[0] == REQUEST_SENSE) {
+				printk(KERN_ERR "%s: I/O error in request sense"
+						" command\n", drive->name);
+				return ide_do_reset(drive);
+			}
+
+			debug_log("[cmd %x]: check condition\n", pc->c[0]);
+
+			/* Retry operation */
+			retry_pc(drive);
+			/* queued, but not started */
+			return ide_stopped;
+		}
+cmd_finished:
+		pc->error = 0;
+		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) &&
+		    (stat & SEEK_STAT) == 0) {
+			dsc_handle(drive);
+			return ide_stopped;
+		}
+		/* Command finished - Call the callback function */
+		pc->callback(drive);
+		return ide_stopped;
+	}
+
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
+		printk(KERN_ERR "%s: The device wants to issue more interrupts "
+				"in DMA mode\n", drive->name);
+		ide_dma_off(drive);
+		return ide_do_reset(drive);
+	}
+	/* Get the number of bytes to transfer on this interrupt. */
+	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
+		  hwif->INB(hwif->io_ports.lbam_addr);
+
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
+
+	if (ireason & CD) {
+		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
+		return ide_do_reset(drive);
+	}
+	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
+		/* Hopefully, we will never get here */
+		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
+				"to %s!\n", drive->name,
+				(ireason & IO) ? "Write" : "Read",
+				(ireason & IO) ? "Read" : "Write");
+		return ide_do_reset(drive);
+	}
+	if (!(pc->flags & PC_FLAG_WRITING)) {
+		/* Reading - Check that we have enough space */
+		temp = pc->xferred + bcount;
+		if (temp > pc->req_xfer) {
+			if (temp > pc->buf_size) {
+				printk(KERN_ERR "%s: The device wants to send "
+						"us more data than expected - "
+						"discarding data\n",
+						drive->name);
+				if (scsi)
+					temp = pc->buf_size - pc->xferred;
+				else
+					temp = 0;
+				if (temp) {
+					if (pc->sg)
+						io_buffers(drive, pc, temp, 0);
+					else
+						hwif->input_data(drive, NULL,
+							pc->cur_pos, temp);
+					printk(KERN_ERR "%s: transferred %d of "
+							"%d bytes\n",
+							drive->name,
+							temp, bcount);
+				}
+				pc->xferred += temp;
+				pc->cur_pos += temp;
+				ide_pad_transfer(drive, 0, bcount - temp);
+				ide_set_handler(drive, handler, timeout,
+						expiry);
+				return ide_started;
+			}
+			debug_log("The device wants to send us more data than "
+				  "expected - allowing transfer\n");
+		}
+		xferfunc = hwif->input_data;
+	} else
+		xferfunc = hwif->output_data;
+
+	if ((drive->media == ide_floppy && !scsi && !pc->buf) ||
+	    (drive->media == ide_tape && !scsi && pc->bh) ||
+	    (scsi && pc->sg))
+		io_buffers(drive, pc, bcount, !!(pc->flags & PC_FLAG_WRITING));
+	else
+		xferfunc(drive, NULL, pc->cur_pos, bcount);
+
+	/* Update the current position */
+	pc->xferred += bcount;
+	pc->cur_pos += bcount;
+
+	debug_log("[cmd %x] transferred %d bytes on that intr.\n",
+		  pc->c[0], bcount);
+
+	/* And set the interrupt handler again */
+	ide_set_handler(drive, handler, timeout, expiry);
+	return ide_started;
+}
+EXPORT_SYMBOL_GPL(ide_pc_intr);
+
+static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	int retries = 100;
+
+	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
+		printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
+				"a packet command, retrying\n", drive->name);
+		udelay(100);
+		ireason = hwif->INB(hwif->io_ports.nsect_addr);
+		if (retries == 0) {
+			printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
+					"a packet command, ignoring\n",
+					drive->name);
+			ireason |= CD;
+			ireason &= ~IO;
+		}
+	}
+
+	return ireason;
+}
+
+ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
+				ide_handler_t *handler, unsigned int timeout,
+				ide_expiry_t *expiry)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	ide_startstop_t startstop;
+	u8 ireason;
+
+	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
+		printk(KERN_ERR "%s: Strange, packet command initiated yet "
+				"DRQ isn't asserted\n", drive->name);
+		return startstop;
+	}
+
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
+	if (drive->media == ide_tape && !drive->scsi)
+		ireason = ide_wait_ireason(drive, ireason);
+
+	if ((ireason & CD) == 0 || (ireason & IO)) {
+		printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
+				"a packet command\n", drive->name);
+		return ide_do_reset(drive);
+	}
+
+	/* Set the interrupt routine */
+	ide_set_handler(drive, handler, timeout, expiry);
+
+	/* Begin DMA, if necessary */
+	if (pc->flags & PC_FLAG_DMA_OK) {
+		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
+		hwif->dma_ops->dma_start(drive);
+	}
+
+	/* Send the actual packet */
+	if ((pc->flags & PC_FLAG_ZIP_DRIVE) == 0)
+		hwif->output_data(drive, NULL, pc->c, 12);
+
+	return ide_started;
+}
+EXPORT_SYMBOL_GPL(ide_transfer_pc);
+
+ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
+			     ide_handler_t *handler, unsigned int timeout,
+			     ide_expiry_t *expiry)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u16 bcount;
+	u8 dma = 0;
+
+	/* We haven't transferred any data yet */
+	pc->xferred = 0;
+	pc->cur_pos = pc->buf;
+
+	/* Request to transfer the entire buffer at once */
+	if (drive->media == ide_tape && !drive->scsi)
+		bcount = pc->req_xfer;
+	else
+		bcount = min(pc->req_xfer, 63 * 1024);
+
+	if (pc->flags & PC_FLAG_DMA_ERROR) {
+		pc->flags &= ~PC_FLAG_DMA_ERROR;
+		ide_dma_off(drive);
+	}
+
+	if ((pc->flags & PC_FLAG_DMA_OK) && drive->using_dma) {
+		if (drive->scsi)
+			hwif->sg_mapped = 1;
+		dma = !hwif->dma_ops->dma_setup(drive);
+		if (drive->scsi)
+			hwif->sg_mapped = 0;
+	}
+
+	if (!dma)
+		pc->flags &= ~PC_FLAG_DMA_OK;
+
+	ide_pktcmd_tf_load(drive, drive->scsi ? 0 : IDE_TFLAG_OUT_DEVICE,
+			   bcount, dma);
+
+	/* Issue the packet command */
+	if (pc->flags & PC_FLAG_DRQ_INTERRUPT) {
+		ide_execute_command(drive, WIN_PACKETCMD, handler,
+				    timeout, NULL);
+		return ide_started;
+	} else {
+		ide_execute_pkt_cmd(drive);
+		return (*handler)(drive);
+	}
+}
+EXPORT_SYMBOL_GPL(ide_issue_pc);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 68e7f19..d998471 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -188,16 +188,6 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 	ide_cd_log_error(drive->name, failed_command, sense);
 }
 
-/* Initialize a ide-cd packet command request */
-void ide_cd_init_rq(ide_drive_t *drive, struct request *rq)
-{
-	struct cdrom_info *cd = drive->driver_data;
-
-	ide_init_drive_cmd(rq);
-	rq->cmd_type = REQ_TYPE_ATA_PC;
-	rq->rq_disk = cd->disk;
-}
-
 static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 				      struct request *failed_command)
 {
@@ -208,7 +198,9 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 		sense = &info->sense_data;
 
 	/* stuff the sense request in front of our current request */
-	ide_cd_init_rq(drive, rq);
+	blk_rq_init(NULL, rq);
+	rq->cmd_type = REQ_TYPE_ATA_PC;
+	rq->rq_disk = info->disk;
 
 	rq->data = sense;
 	rq->cmd[0] = GPCMD_REQUEST_SENSE;
@@ -216,11 +208,12 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 	rq->data_len = 18;
 
 	rq->cmd_type = REQ_TYPE_SENSE;
+	rq->cmd_flags |= REQ_PREEMPT;
 
 	/* NOTE! Save the failed command in "rq->buffer" */
 	rq->buffer = (void *) failed_command;
 
-	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
+	ide_do_drive_cmd(drive, rq);
 }
 
 static void cdrom_end_request(ide_drive_t *drive, int uptodate)
@@ -537,8 +530,8 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 		info->dma = !hwif->dma_ops->dma_setup(drive);
 
 	/* set up the controller registers */
-	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL |
-			   IDE_TFLAG_NO_SELECT_MASK, xferlen, info->dma);
+	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL,
+			   xferlen, info->dma);
 
 	if (info->cd_flags & IDE_CD_FLAG_DRQ_INTERRUPT) {
 		/* waiting for CDB interrupt, not DMA yet. */
@@ -838,34 +831,54 @@ static void ide_cd_request_sense_fixup(struct request *rq)
 		}
 }
 
-int ide_cd_queue_pc(ide_drive_t *drive, struct request *rq)
+int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
+		    int write, void *buffer, unsigned *bufflen,
+		    struct request_sense *sense, int timeout,
+		    unsigned int cmd_flags)
 {
-	struct request_sense sense;
+	struct cdrom_info *info = drive->driver_data;
+	struct request_sense local_sense;
 	int retries = 10;
-	unsigned int flags = rq->cmd_flags;
+	unsigned int flags = 0;
 
-	if (rq->sense == NULL)
-		rq->sense = &sense;
+	if (!sense)
+		sense = &local_sense;
 
 	/* start of retry loop */
 	do {
+		struct request *rq;
 		int error;
-		unsigned long time = jiffies;
-		rq->cmd_flags = flags;
 
-		error = ide_do_drive_cmd(drive, rq, ide_wait);
-		time = jiffies - time;
+		rq = blk_get_request(drive->queue, write, __GFP_WAIT);
+
+		memcpy(rq->cmd, cmd, BLK_MAX_CDB);
+		rq->cmd_type = REQ_TYPE_ATA_PC;
+		rq->sense = sense;
+		rq->cmd_flags |= cmd_flags;
+		rq->timeout = timeout;
+		if (buffer) {
+			rq->data = buffer;
+			rq->data_len = *bufflen;
+		}
+
+		error = blk_execute_rq(drive->queue, info->disk, rq, 0);
+
+		if (buffer)
+			*bufflen = rq->data_len;
+
+		flags = rq->cmd_flags;
+		blk_put_request(rq);
 
 		/*
 		 * FIXME: we should probably abort/retry or something in case of
 		 * failure.
 		 */
-		if (rq->cmd_flags & REQ_FAILED) {
+		if (flags & REQ_FAILED) {
 			/*
 			 * The request failed.  Retry if it was due to a unit
 			 * attention status (usually means media was changed).
 			 */
-			struct request_sense *reqbuf = rq->sense;
+			struct request_sense *reqbuf = sense;
 
 			if (reqbuf->sense_key == UNIT_ATTENTION)
 				cdrom_saw_media_change(drive);
@@ -885,10 +898,10 @@ int ide_cd_queue_pc(ide_drive_t *drive, struct request *rq)
 		}
 
 		/* end of retry loop */
-	} while ((rq->cmd_flags & REQ_FAILED) && retries >= 0);
+	} while ((flags & REQ_FAILED) && retries >= 0);
 
 	/* return an error if the command failed */
-	return (rq->cmd_flags & REQ_FAILED) ? -EIO : 0;
+	return (flags & REQ_FAILED) ? -EIO : 0;
 }
 
 /*
@@ -1268,23 +1281,20 @@ static void msf_from_bcd(struct atapi_msf *msf)
 
 int cdrom_check_status(ide_drive_t *drive, struct request_sense *sense)
 {
-	struct request req;
 	struct cdrom_info *info = drive->driver_data;
 	struct cdrom_device_info *cdi = &info->devinfo;
+	unsigned char cmd[BLK_MAX_CDB];
 
-	ide_cd_init_rq(drive, &req);
-
-	req.sense = sense;
-	req.cmd[0] = GPCMD_TEST_UNIT_READY;
-	req.cmd_flags |= REQ_QUIET;
+	memset(cmd, 0, BLK_MAX_CDB);
+	cmd[0] = GPCMD_TEST_UNIT_READY;
 
 	/*
 	 * Sanyo 3 CD changer uses byte 7 of TEST_UNIT_READY to switch CDs
 	 * instead of supporting the LOAD_UNLOAD opcode.
 	 */
-	req.cmd[7] = cdi->sanyo_slot % 3;
+	cmd[7] = cdi->sanyo_slot % 3;
 
-	return ide_cd_queue_pc(drive, &req);
+	return ide_cd_queue_pc(drive, cmd, 0, NULL, 0, sense, 0, REQ_QUIET);
 }
 
 static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
@@ -1297,17 +1307,14 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	} capbuf;
 
 	int stat;
-	struct request req;
-
-	ide_cd_init_rq(drive, &req);
+	unsigned char cmd[BLK_MAX_CDB];
+	unsigned len = sizeof(capbuf);
 
-	req.sense = sense;
-	req.cmd[0] = GPCMD_READ_CDVD_CAPACITY;
-	req.data = (char *)&capbuf;
-	req.data_len = sizeof(capbuf);
-	req.cmd_flags |= REQ_QUIET;
+	memset(cmd, 0, BLK_MAX_CDB);
+	cmd[0] = GPCMD_READ_CDVD_CAPACITY;
 
-	stat = ide_cd_queue_pc(drive, &req);
+	stat = ide_cd_queue_pc(drive, cmd, 0, &capbuf, &len, sense, 0,
+			       REQ_QUIET);
 	if (stat == 0) {
 		*capacity = 1 + be32_to_cpu(capbuf.lba);
 		*sectors_per_frame =
@@ -1321,24 +1328,20 @@ static int cdrom_read_tocentry(ide_drive_t *drive, int trackno, int msf_flag,
 				int format, char *buf, int buflen,
 				struct request_sense *sense)
 {
-	struct request req;
+	unsigned char cmd[BLK_MAX_CDB];
 
-	ide_cd_init_rq(drive, &req);
+	memset(cmd, 0, BLK_MAX_CDB);
 
-	req.sense = sense;
-	req.data =  buf;
-	req.data_len = buflen;
-	req.cmd_flags |= REQ_QUIET;
-	req.cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
-	req.cmd[6] = trackno;
-	req.cmd[7] = (buflen >> 8);
-	req.cmd[8] = (buflen & 0xff);
-	req.cmd[9] = (format << 6);
+	cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
+	cmd[6] = trackno;
+	cmd[7] = (buflen >> 8);
+	cmd[8] = (buflen & 0xff);
+	cmd[9] = (format << 6);
 
 	if (msf_flag)
-		req.cmd[1] = 2;
+		cmd[1] = 2;
 
-	return ide_cd_queue_pc(drive, &req);
+	return ide_cd_queue_pc(drive, cmd, 0, buf, &buflen, sense, 0, REQ_QUIET);
 }
 
 /* Try to read the entire TOC for the disk into our internal buffer. */
@@ -2103,11 +2106,6 @@ static int ide_cd_probe(ide_drive_t *drive)
 			goto failed;
 		}
 	}
-	if (drive->scsi) {
-		printk(KERN_INFO "ide-cd: passing drive %s to ide-scsi "
-				 "emulation.\n", drive->name);
-		goto failed;
-	}
 	info = kzalloc(sizeof(struct cdrom_info), GFP_KERNEL);
 	if (info == NULL) {
 		printk(KERN_ERR "%s: Can't allocate a cdrom structure\n",
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index a58801c..fe0ea36 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -143,8 +143,8 @@ struct cdrom_info {
 void ide_cd_log_error(const char *, struct request *, struct request_sense *);
 
 /* ide-cd.c functions used by ide-cd_ioctl.c */
-void ide_cd_init_rq(ide_drive_t *, struct request *);
-int ide_cd_queue_pc(ide_drive_t *, struct request *);
+int ide_cd_queue_pc(ide_drive_t *, const unsigned char *, int, void *,
+		    unsigned *, struct request_sense *, int, unsigned int);
 int ide_cd_read_toc(ide_drive_t *, struct request_sense *);
 int ide_cdrom_get_capabilities(ide_drive_t *, u8 *);
 void ide_cdrom_update_speed(ide_drive_t *, u8 *);
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index 6d147ce..24d002a 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -104,8 +104,8 @@ int cdrom_eject(ide_drive_t *drive, int ejectflag,
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
-	struct request req;
 	char loej = 0x02;
+	unsigned char cmd[BLK_MAX_CDB];
 
 	if ((cd->cd_flags & IDE_CD_FLAG_NO_EJECT) && !ejectflag)
 		return -EDRIVE_CANT_DO_THIS;
@@ -114,17 +114,16 @@ int cdrom_eject(ide_drive_t *drive, int ejectflag,
 	if ((cd->cd_flags & IDE_CD_FLAG_DOOR_LOCKED) && ejectflag)
 		return 0;
 
-	ide_cd_init_rq(drive, &req);
-
 	/* only tell drive to close tray if open, if it can do that */
 	if (ejectflag && (cdi->mask & CDC_CLOSE_TRAY))
 		loej = 0;
 
-	req.sense = sense;
-	req.cmd[0] = GPCMD_START_STOP_UNIT;
-	req.cmd[4] = loej | (ejectflag != 0);
+	memset(cmd, 0, BLK_MAX_CDB);
+
+	cmd[0] = GPCMD_START_STOP_UNIT;
+	cmd[4] = loej | (ejectflag != 0);
 
-	return ide_cd_queue_pc(drive, &req);
+	return ide_cd_queue_pc(drive, cmd, 0, NULL, 0, sense, 0, 0);
 }
 
 /* Lock the door if LOCKFLAG is nonzero; unlock it otherwise. */
@@ -134,7 +133,6 @@ int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct request_sense my_sense;
-	struct request req;
 	int stat;
 
 	if (sense == NULL)
@@ -144,11 +142,15 @@ int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
 	if (cd->cd_flags & IDE_CD_FLAG_NO_DOORLOCK) {
 		stat = 0;
 	} else {
-		ide_cd_init_rq(drive, &req);
-		req.sense = sense;
-		req.cmd[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
-		req.cmd[4] = lockflag ? 1 : 0;
-		stat = ide_cd_queue_pc(drive, &req);
+		unsigned char cmd[BLK_MAX_CDB];
+
+		memset(cmd, 0, BLK_MAX_CDB);
+
+		cmd[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
+		cmd[4] = lockflag ? 1 : 0;
+
+		stat = ide_cd_queue_pc(drive, cmd, 0, NULL, 0,
+				       sense, 0, 0);
 	}
 
 	/* If we got an illegal field error, the drive
@@ -206,32 +208,30 @@ int ide_cdrom_select_speed(struct cdrom_device_info *cdi, int speed)
 {
 	ide_drive_t *drive = cdi->handle;
 	struct cdrom_info *cd = drive->driver_data;
-	struct request rq;
 	struct request_sense sense;
 	u8 buf[ATAPI_CAPABILITIES_PAGE_SIZE];
 	int stat;
-
-	ide_cd_init_rq(drive, &rq);
-
-	rq.sense = &sense;
+	unsigned char cmd[BLK_MAX_CDB];
 
 	if (speed == 0)
 		speed = 0xffff; /* set to max */
 	else
 		speed *= 177;   /* Nx to kbytes/s */
 
-	rq.cmd[0] = GPCMD_SET_SPEED;
+	memset(cmd, 0, BLK_MAX_CDB);
+
+	cmd[0] = GPCMD_SET_SPEED;
 	/* Read Drive speed in kbytes/second MSB/LSB */
-	rq.cmd[2] = (speed >> 8) & 0xff;
-	rq.cmd[3] = speed & 0xff;
+	cmd[2] = (speed >> 8) & 0xff;
+	cmd[3] = speed & 0xff;
 	if ((cdi->mask & (CDC_CD_R | CDC_CD_RW | CDC_DVD_R)) !=
 	    (CDC_CD_R | CDC_CD_RW | CDC_DVD_R)) {
 		/* Write Drive speed in kbytes/second MSB/LSB */
-		rq.cmd[4] = (speed >> 8) & 0xff;
-		rq.cmd[5] = speed & 0xff;
+		cmd[4] = (speed >> 8) & 0xff;
+		cmd[5] = speed & 0xff;
 	}
 
-	stat = ide_cd_queue_pc(drive, &rq);
+	stat = ide_cd_queue_pc(drive, cmd, 0, NULL, 0, &sense, 0, 0);
 
 	if (!ide_cdrom_get_capabilities(drive, buf)) {
 		ide_cdrom_update_speed(drive, buf);
@@ -268,21 +268,19 @@ int ide_cdrom_get_mcn(struct cdrom_device_info *cdi,
 {
 	ide_drive_t *drive = cdi->handle;
 	int stat, mcnlen;
-	struct request rq;
 	char buf[24];
+	unsigned char cmd[BLK_MAX_CDB];
+	unsigned len = sizeof(buf);
 
-	ide_cd_init_rq(drive, &rq);
+	memset(cmd, 0, BLK_MAX_CDB);
 
-	rq.data = buf;
-	rq.data_len = sizeof(buf);
+	cmd[0] = GPCMD_READ_SUBCHANNEL;
+	cmd[1] = 2;		/* MSF addressing */
+	cmd[2] = 0x40;	/* request subQ data */
+	cmd[3] = 2;		/* format */
+	cmd[8] = len;
 
-	rq.cmd[0] = GPCMD_READ_SUBCHANNEL;
-	rq.cmd[1] = 2;		/* MSF addressing */
-	rq.cmd[2] = 0x40;	/* request subQ data */
-	rq.cmd[3] = 2;		/* format */
-	rq.cmd[8] = sizeof(buf);
-
-	stat = ide_cd_queue_pc(drive, &rq);
+	stat = ide_cd_queue_pc(drive, cmd, 0, buf, &len, NULL, 0, 0);
 	if (stat)
 		return stat;
 
@@ -298,14 +296,14 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi)
 	ide_drive_t *drive = cdi->handle;
 	struct cdrom_info *cd = drive->driver_data;
 	struct request_sense sense;
-	struct request req;
+	struct request *rq;
 	int ret;
 
-	ide_cd_init_rq(drive, &req);
-	req.cmd_type = REQ_TYPE_SPECIAL;
-	req.cmd_flags = REQ_QUIET;
-	ret = ide_do_drive_cmd(drive, &req, ide_wait);
-
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_flags = REQ_QUIET;
+	ret = blk_execute_rq(drive->queue, cd->disk, rq, 0);
+	blk_put_request(rq);
 	/*
 	 * A reset will unlock the door. If it was previously locked,
 	 * lock it again.
@@ -351,8 +349,8 @@ static int ide_cd_fake_play_trkind(ide_drive_t *drive, void *arg)
 	struct atapi_toc_entry *first_toc, *last_toc;
 	unsigned long lba_start, lba_end;
 	int stat;
-	struct request rq;
 	struct request_sense sense;
+	unsigned char cmd[BLK_MAX_CDB];
 
 	stat = ide_cd_get_toc_entry(drive, ti->cdti_trk0, &first_toc);
 	if (stat)
@@ -370,14 +368,13 @@ static int ide_cd_fake_play_trkind(ide_drive_t *drive, void *arg)
 	if (lba_end <= lba_start)
 		return -EINVAL;
 
-	ide_cd_init_rq(drive, &rq);
+	memset(cmd, 0, BLK_MAX_CDB);
 
-	rq.sense = &sense;
-	rq.cmd[0] = GPCMD_PLAY_AUDIO_MSF;
-	lba_to_msf(lba_start,   &rq.cmd[3], &rq.cmd[4], &rq.cmd[5]);
-	lba_to_msf(lba_end - 1, &rq.cmd[6], &rq.cmd[7], &rq.cmd[8]);
+	cmd[0] = GPCMD_PLAY_AUDIO_MSF;
+	lba_to_msf(lba_start,   &cmd[3], &cmd[4], &cmd[5]);
+	lba_to_msf(lba_end - 1, &cmd[6], &cmd[7], &cmd[8]);
 
-	return ide_cd_queue_pc(drive, &rq);
+	return ide_cd_queue_pc(drive, cmd, 0, NULL, 0, &sense, 0, 0);
 }
 
 static int ide_cd_read_tochdr(ide_drive_t *drive, void *arg)
@@ -447,8 +444,9 @@ int ide_cdrom_audio_ioctl(struct cdrom_device_info *cdi,
 int ide_cdrom_packet(struct cdrom_device_info *cdi,
 			    struct packet_command *cgc)
 {
-	struct request req;
 	ide_drive_t *drive = cdi->handle;
+	unsigned int flags = 0;
+	unsigned len = cgc->buflen;
 
 	if (cgc->timeout <= 0)
 		cgc->timeout = ATAPI_WAIT_PC;
@@ -456,24 +454,21 @@ int ide_cdrom_packet(struct cdrom_device_info *cdi,
 	/* here we queue the commands from the uniform CD-ROM
 	   layer. the packet must be complete, as we do not
 	   touch it at all. */
-	ide_cd_init_rq(drive, &req);
 
 	if (cgc->data_direction == CGC_DATA_WRITE)
-		req.cmd_flags |= REQ_RW;
+		flags |= REQ_RW;
 
-	memcpy(req.cmd, cgc->cmd, CDROM_PACKET_SIZE);
 	if (cgc->sense)
 		memset(cgc->sense, 0, sizeof(struct request_sense));
-	req.data = cgc->buffer;
-	req.data_len = cgc->buflen;
-	req.timeout = cgc->timeout;
 
 	if (cgc->quiet)
-		req.cmd_flags |= REQ_QUIET;
+		flags |= REQ_QUIET;
 
-	req.sense = cgc->sense;
-	cgc->stat = ide_cd_queue_pc(drive, &req);
+	cgc->stat = ide_cd_queue_pc(drive, cgc->cmd,
+				    cgc->data_direction == CGC_DATA_WRITE,
+				    cgc->buffer, &len,
+				    cgc->sense, cgc->timeout, flags);
 	if (!cgc->stat)
-		cgc->buflen -= req.data_len;
+		cgc->buflen -= len;
 	return cgc->stat;
 }
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 8e08d08..5f49a4a 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -198,8 +198,7 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 	}
 
 	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_NO_SELECT_MASK;  /* FIXME? */
-	task.tf_flags |= (IDE_TFLAG_TF | IDE_TFLAG_DEVICE);
+	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
 	if (drive->select.b.lba) {
 		if (lba48) {
@@ -617,7 +616,8 @@ static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
  */
 static int set_multcount(ide_drive_t *drive, int arg)
 {
-	struct request rq;
+	struct request *rq;
+	int error;
 
 	if (arg < 0 || arg > drive->id->max_multsect)
 		return -EINVAL;
@@ -625,12 +625,13 @@ static int set_multcount(ide_drive_t *drive, int arg)
 	if (drive->special.b.set_multmode)
 		return -EBUSY;
 
-	ide_init_drive_cmd(&rq);
-	rq.cmd_type = REQ_TYPE_ATA_TASKFILE;
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 
 	drive->mult_req = arg;
 	drive->special.b.set_multmode = 1;
-	(void)ide_do_drive_cmd(drive, &rq, ide_wait);
+	error = blk_execute_rq(drive->queue, NULL, rq, 0);
+	blk_put_request(rq);
 
 	return (drive->mult_count == arg) ? 0 : -EIO;
 }
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 653b1ad..7ee44f8 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -463,7 +463,7 @@ int ide_dma_setup(ide_drive_t *drive)
 	}
 
 	/* PRD table */
-	if (hwif->mmio)
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
 		writel(hwif->dmatable_dma,
 		       (void __iomem *)(hwif->dma_base + ATA_DMA_TABLE_OFS));
 	else
@@ -692,7 +692,7 @@ static int ide_tune_dma(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 speed;
 
-	if (noautodma || drive->nodma || (drive->id->capability & 1) == 0)
+	if (drive->nodma || (drive->id->capability & 1) == 0)
 		return 0;
 
 	/* consult the list of known "bad" drives */
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index f05fbc2..b368943 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -286,11 +286,12 @@ static void idefloppy_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
 
-	ide_init_drive_cmd(rq);
+	blk_rq_init(NULL, rq);
 	rq->buffer = (char *) pc;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_flags |= REQ_PREEMPT;
 	rq->rq_disk = floppy->disk;
-	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
+	ide_do_drive_cmd(drive, rq);
 }
 
 static struct ide_atapi_pc *idefloppy_next_pc_storage(ide_drive_t *drive)
@@ -311,50 +312,41 @@ static struct request *idefloppy_next_rq_storage(ide_drive_t *drive)
 	return (&floppy->rq_stack[floppy->rq_stack_index++]);
 }
 
-static void idefloppy_request_sense_callback(ide_drive_t *drive)
+static void ide_floppy_callback(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	u8 *buf = floppy->pc->buf;
+	struct ide_atapi_pc *pc = floppy->pc;
+	int uptodate = pc->error ? 0 : 1;
 
 	debug_log("Reached %s\n", __func__);
 
-	if (!floppy->pc->error) {
-		floppy->sense_key = buf[2] & 0x0F;
-		floppy->asc = buf[12];
-		floppy->ascq = buf[13];
-		floppy->progress_indication = buf[15] & 0x80 ?
-			(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
+	if (floppy->failed_pc == pc)
+		floppy->failed_pc = NULL;
 
-		if (floppy->failed_pc)
-			debug_log("pc = %x, sense key = %x, asc = %x,"
-					" ascq = %x\n",
-					floppy->failed_pc->c[0],
-					floppy->sense_key,
-					floppy->asc,
-					floppy->ascq);
-		else
-			debug_log("sense key = %x, asc = %x, ascq = %x\n",
-					floppy->sense_key,
-					floppy->asc,
-					floppy->ascq);
+	if (pc->c[0] == GPCMD_READ_10 || pc->c[0] == GPCMD_WRITE_10 ||
+	    (pc->rq && blk_pc_request(pc->rq)))
+		uptodate = 1; /* FIXME */
+	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {
+		u8 *buf = floppy->pc->buf;
 
+		if (!pc->error) {
+			floppy->sense_key = buf[2] & 0x0F;
+			floppy->asc = buf[12];
+			floppy->ascq = buf[13];
+			floppy->progress_indication = buf[15] & 0x80 ?
+				(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
 
-		idefloppy_end_request(drive, 1, 0);
-	} else {
-		printk(KERN_ERR "Error in REQUEST SENSE itself - Aborting"
-				" request!\n");
-		idefloppy_end_request(drive, 0, 0);
-	}
-}
+			if (floppy->failed_pc)
+				debug_log("pc = %x, ", floppy->failed_pc->c[0]);
 
-/* General packet command callback function. */
-static void idefloppy_pc_callback(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-
-	debug_log("Reached %s\n", __func__);
+			debug_log("sense key = %x, asc = %x, ascq = %x\n",
+				  floppy->sense_key, floppy->asc, floppy->ascq);
+		} else
+			printk(KERN_ERR "Error in REQUEST SENSE itself - "
+					"Aborting request!\n");
+	}
 
-	idefloppy_end_request(drive, floppy->pc->error ? 0 : 1, 0);
+	idefloppy_end_request(drive, uptodate, 0);
 }
 
 static void idefloppy_init_pc(struct ide_atapi_pc *pc)
@@ -365,7 +357,7 @@ static void idefloppy_init_pc(struct ide_atapi_pc *pc)
 	pc->req_xfer = 0;
 	pc->buf = pc->pc_buf;
 	pc->buf_size = IDEFLOPPY_PC_BUFFER_SIZE;
-	pc->idefloppy_callback = &idefloppy_pc_callback;
+	pc->callback = ide_floppy_callback;
 }
 
 static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
@@ -374,7 +366,6 @@ static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
 	pc->c[0] = GPCMD_REQUEST_SENSE;
 	pc->c[4] = 255;
 	pc->req_xfer = 18;
-	pc->idefloppy_callback = &idefloppy_request_sense_callback;
 }
 
 /*
@@ -397,174 +388,19 @@ static void idefloppy_retry_pc(ide_drive_t *drive)
 static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_atapi_pc *pc = floppy->pc;
-	struct request *rq = pc->rq;
-	xfer_func_t *xferfunc;
-	unsigned int temp;
-	int dma_error = 0;
-	u16 bcount;
-	u8 stat, ireason;
-
-	debug_log("Reached %s interrupt handler\n", __func__);
-
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		dma_error = hwif->dma_ops->dma_end(drive);
-		if (dma_error) {
-			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
-					rq_data_dir(rq) ? "write" : "read");
-			pc->flags |= PC_FLAG_DMA_ERROR;
-		} else {
-			pc->xferred = pc->req_xfer;
-			idefloppy_update_buffers(drive, pc);
-		}
-		debug_log("DMA finished\n");
-	}
-
-	/* Clear the interrupt */
-	stat = ide_read_status(drive);
-
-	/* No more interrupts */
-	if ((stat & DRQ_STAT) == 0) {
-		debug_log("Packet command completed, %d bytes transferred\n",
-				pc->xferred);
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-
-		local_irq_enable_in_hardirq();
-
-		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
-			/* Error detected */
-			debug_log("%s: I/O error\n", drive->name);
-			rq->errors++;
-			if (pc->c[0] == GPCMD_REQUEST_SENSE) {
-				printk(KERN_ERR "ide-floppy: I/O error in "
-					"request sense command\n");
-				return ide_do_reset(drive);
-			}
-			/* Retry operation */
-			idefloppy_retry_pc(drive);
-			/* queued, but not started */
-			return ide_stopped;
-		}
-		pc->error = 0;
-		if (floppy->failed_pc == pc)
-			floppy->failed_pc = NULL;
-		/* Command finished - Call the callback function */
-		pc->idefloppy_callback(drive);
-		return ide_stopped;
-	}
-
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		printk(KERN_ERR "ide-floppy: The floppy wants to issue "
-			"more interrupts in DMA mode\n");
-		ide_dma_off(drive);
-		return ide_do_reset(drive);
-	}
-
-	/* Get the number of bytes to transfer */
-	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
-		  hwif->INB(hwif->io_ports.lbam_addr);
-	/* on this interrupt */
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
-
-	if (ireason & CD) {
-		printk(KERN_ERR "ide-floppy: CoD != 0 in %s\n", __func__);
-		return ide_do_reset(drive);
-	}
-	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
-		/* Hopefully, we will never get here */
-		printk(KERN_ERR "ide-floppy: We wanted to %s, ",
-				(ireason & IO) ? "Write" : "Read");
-		printk(KERN_ERR "but the floppy wants us to %s !\n",
-				(ireason & IO) ? "Read" : "Write");
-		return ide_do_reset(drive);
-	}
-	if (!(pc->flags & PC_FLAG_WRITING)) {
-		/* Reading - Check that we have enough space */
-		temp = pc->xferred + bcount;
-		if (temp > pc->req_xfer) {
-			if (temp > pc->buf_size) {
-				printk(KERN_ERR "ide-floppy: The floppy wants "
-					"to send us more data than expected "
-					"- discarding data\n");
-				ide_pad_transfer(drive, 0, bcount);
-
-				ide_set_handler(drive,
-						&idefloppy_pc_intr,
-						IDEFLOPPY_WAIT_CMD,
-						NULL);
-				return ide_started;
-			}
-			debug_log("The floppy wants to send us more data than"
-					" expected - allowing transfer\n");
-		}
-	}
-	if (pc->flags & PC_FLAG_WRITING)
-		xferfunc = hwif->output_data;
-	else
-		xferfunc = hwif->input_data;
-
-	if (pc->buf)
-		xferfunc(drive, NULL, pc->cur_pos, bcount);
-	else
-		ide_floppy_io_buffers(drive, pc, bcount,
-				      !!(pc->flags & PC_FLAG_WRITING));
-
-	/* Update the current position */
-	pc->xferred += bcount;
-	pc->cur_pos += bcount;
-
-	/* And set the interrupt handler again */
-	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
-	return ide_started;
-}
-
-/*
- * This is the original routine that did the packet transfer.
- * It fails at high speeds on the Iomega ZIP drive, so there's a slower version
- * for that drive below. The algorithm is chosen based on drive type
- */
-static ide_startstop_t idefloppy_transfer_pc(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	ide_startstop_t startstop;
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	u8 ireason;
-
-	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
-		printk(KERN_ERR "ide-floppy: Strange, packet command "
-				"initiated yet DRQ isn't asserted\n");
-		return startstop;
-	}
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
-	if ((ireason & CD) == 0 || (ireason & IO)) {
-		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) while "
-				"issuing a packet command\n");
-		return ide_do_reset(drive);
-	}
 
-	/* Set the interrupt routine */
-	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
-
-	/* Send the actual packet */
-	hwif->output_data(drive, NULL, floppy->pc->c, 12);
-
-	return ide_started;
+	return ide_pc_intr(drive, floppy->pc, idefloppy_pc_intr,
+			   IDEFLOPPY_WAIT_CMD, NULL, idefloppy_update_buffers,
+			   idefloppy_retry_pc, NULL, ide_floppy_io_buffers);
 }
 
-
 /*
  * What we have here is a classic case of a top half / bottom half interrupt
  * service routine. In interrupt mode, the device sends an interrupt to signal
  * that it is ready to receive a packet. However, we need to delay about 2-3
  * ticks before issuing the packet or we gets in trouble.
- *
- * So, follow carefully. transfer_pc1 is called as an interrupt (or directly).
- * In either case, when the device says it's ready for a packet, we schedule
- * the packet transfer to occur about 2-3 ticks later in transfer_pc2.
  */
-static int idefloppy_transfer_pc2(ide_drive_t *drive)
+static int idefloppy_transfer_pc(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
@@ -575,24 +411,19 @@ static int idefloppy_transfer_pc2(ide_drive_t *drive)
 	return IDEFLOPPY_WAIT_CMD;
 }
 
-static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
+
+/*
+ * Called as an interrupt (or directly). When the device says it's ready for a
+ * packet, we schedule the packet transfer to occur about 2-3 ticks later in
+ * transfer_pc.
+ */
+static ide_startstop_t idefloppy_start_pc_transfer(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	ide_startstop_t startstop;
-	u8 ireason;
+	struct ide_atapi_pc *pc = floppy->pc;
+	ide_expiry_t *expiry;
+	unsigned int timeout;
 
-	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
-		printk(KERN_ERR "ide-floppy: Strange, packet command "
-				"initiated yet DRQ isn't asserted\n");
-		return startstop;
-	}
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
-	if ((ireason & CD) == 0 || (ireason & IO)) {
-		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) "
-				"while issuing a packet command\n");
-		return ide_do_reset(drive);
-	}
 	/*
 	 * The following delay solves a problem with ATAPI Zip 100 drives
 	 * where the Busy flag was apparently being deasserted before the
@@ -601,10 +432,15 @@ static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 	 * 40 and 50msec work well. idefloppy_pc_intr will not be actually
 	 * used until after the packet is moved in about 50 msec.
 	 */
+	if (pc->flags & PC_FLAG_ZIP_DRIVE) {
+		timeout = floppy->ticks;
+		expiry = &idefloppy_transfer_pc;
+	} else {
+		timeout = IDEFLOPPY_WAIT_CMD;
+		expiry = NULL;
+	}
 
-	ide_set_handler(drive, &idefloppy_pc_intr, floppy->ticks,
-			&idefloppy_transfer_pc2);
-	return ide_started;
+	return ide_transfer_pc(drive, pc, idefloppy_pc_intr, timeout, expiry);
 }
 
 static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
@@ -627,10 +463,6 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		struct ide_atapi_pc *pc)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	ide_hwif_t *hwif = drive->hwif;
-	ide_handler_t *pkt_xfer_routine;
-	u16 bcount;
-	u8 dma;
 
 	if (floppy->failed_pc == NULL &&
 	    pc->c[0] != GPCMD_REQUEST_SENSE)
@@ -645,65 +477,16 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		pc->error = IDEFLOPPY_ERROR_GENERAL;
 
 		floppy->failed_pc = NULL;
-		pc->idefloppy_callback(drive);
+		pc->callback(drive);
 		return ide_stopped;
 	}
 
 	debug_log("Retry number - %d\n", pc->retries);
 
 	pc->retries++;
-	/* We haven't transferred any data yet */
-	pc->xferred = 0;
-	pc->cur_pos = pc->buf;
-	bcount = min(pc->req_xfer, 63 * 1024);
-
-	if (pc->flags & PC_FLAG_DMA_ERROR) {
-		pc->flags &= ~PC_FLAG_DMA_ERROR;
-		ide_dma_off(drive);
-	}
-	dma = 0;
-
-	if ((pc->flags & PC_FLAG_DMA_RECOMMENDED) && drive->using_dma)
-		dma = !hwif->dma_ops->dma_setup(drive);
 
-	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
-			   IDE_TFLAG_OUT_DEVICE, bcount, dma);
-
-	if (dma) {
-		/* Begin DMA, if necessary */
-		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
-		hwif->dma_ops->dma_start(drive);
-	}
-
-	/* Can we transfer the packet when we get the interrupt or wait? */
-	if (floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE) {
-		/* wait */
-		pkt_xfer_routine = &idefloppy_transfer_pc1;
-	} else {
-		/* immediate */
-		pkt_xfer_routine = &idefloppy_transfer_pc;
-	}
-
-	if (floppy->flags & IDEFLOPPY_FLAG_DRQ_INTERRUPT) {
-		/* Issue the packet command */
-		ide_execute_command(drive, WIN_PACKETCMD,
-				pkt_xfer_routine,
-				IDEFLOPPY_WAIT_CMD,
-				NULL);
-		return ide_started;
-	} else {
-		/* Issue the packet command */
-		ide_execute_pkt_cmd(drive);
-		return (*pkt_xfer_routine) (drive);
-	}
-}
-
-static void idefloppy_rw_callback(ide_drive_t *drive)
-{
-	debug_log("Reached %s\n", __func__);
-
-	idefloppy_end_request(drive, 1, 0);
-	return;
+	return ide_issue_pc(drive, pc, idefloppy_start_pc_transfer,
+			    IDEFLOPPY_WAIT_CMD, NULL);
 }
 
 static void idefloppy_create_prevent_cmd(struct ide_atapi_pc *pc, int prevent)
@@ -800,21 +583,19 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
 
-	pc->idefloppy_callback = &idefloppy_rw_callback;
 	pc->rq = rq;
 	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
 	if (rq->cmd_flags & REQ_RW)
 		pc->flags |= PC_FLAG_WRITING;
 	pc->buf = NULL;
 	pc->req_xfer = pc->buf_size = blocks * floppy->block_size;
-	pc->flags |= PC_FLAG_DMA_RECOMMENDED;
+	pc->flags |= PC_FLAG_DMA_OK;
 }
 
 static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
 		struct ide_atapi_pc *pc, struct request *rq)
 {
 	idefloppy_init_pc(pc);
-	pc->idefloppy_callback = &idefloppy_rw_callback;
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
 	pc->rq = rq;
 	pc->b_count = rq->data_len;
@@ -822,7 +603,7 @@ static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
 		pc->flags |= PC_FLAG_WRITING;
 	pc->buf = rq->data;
 	if (rq->bio)
-		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
+		pc->flags |= PC_FLAG_DMA_OK;
 	/*
 	 * possibly problematic, doesn't look like ide-floppy correctly
 	 * handled scattered requests if dma fails...
@@ -875,7 +656,14 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		return ide_stopped;
 	}
 
+	if (floppy->flags & IDEFLOPPY_FLAG_DRQ_INTERRUPT)
+		pc->flags |= PC_FLAG_DRQ_INTERRUPT;
+
+	if (floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE)
+		pc->flags |= PC_FLAG_ZIP_DRIVE;
+
 	pc->rq = rq;
+
 	return idefloppy_issue_pc(drive, pc);
 }
 
@@ -886,14 +674,16 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 static int idefloppy_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
-	struct request rq;
+	struct request *rq;
+	int error;
 
-	ide_init_drive_cmd(&rq);
-	rq.buffer = (char *) pc;
-	rq.cmd_type = REQ_TYPE_SPECIAL;
-	rq.rq_disk = floppy->disk;
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->buffer = (char *) pc;
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	error = blk_execute_rq(drive->queue, floppy->disk, rq, 0);
+	blk_put_request(rq);
 
-	return ide_do_drive_cmd(drive, &rq, ide_wait);
+	return error;
 }
 
 /*
@@ -1622,11 +1412,6 @@ static int ide_floppy_probe(ide_drive_t *drive)
 				" of ide-floppy\n", drive->name);
 		goto failed;
 	}
-	if (drive->scsi) {
-		printk(KERN_INFO "ide-floppy: passing drive %s to ide-scsi"
-				" emulation.\n", drive->name);
-		goto failed;
-	}
 	floppy = kzalloc(sizeof(idefloppy_floppy_t), GFP_KERNEL);
 	if (!floppy) {
 		printk(KERN_ERR "ide-floppy: %s: Can't allocate a floppy"
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 6965253..2805774 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -358,31 +358,6 @@ void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
 
 EXPORT_SYMBOL(ide_end_drive_cmd);
 
-/**
- *	try_to_flush_leftover_data	-	flush junk
- *	@drive: drive to flush
- *
- *	try_to_flush_leftover_data() is invoked in response to a drive
- *	unexpectedly having its DRQ_STAT bit set.  As an alternative to
- *	resetting the drive, this routine tries to clear the condition
- *	by read a sector's worth of data from the drive.  Of course,
- *	this may not help if the drive is *waiting* for data from *us*.
- */
-static void try_to_flush_leftover_data (ide_drive_t *drive)
-{
-	int i = (drive->mult_count ? drive->mult_count : 1) * SECTOR_WORDS;
-
-	if (drive->media != ide_disk)
-		return;
-	while (i > 0) {
-		u32 buffer[16];
-		u32 wcount = (i > 16) ? 16 : i;
-
-		i -= wcount;
-		drive->hwif->input_data(drive, NULL, buffer, wcount * 4);
-	}
-}
-
 static void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 {
 	if (rq->rq_disk) {
@@ -422,8 +397,11 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
 	}
 
 	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ &&
-	    (hwif->host_flags & IDE_HFLAG_ERROR_STOPS_FIFO) == 0)
-		try_to_flush_leftover_data(drive);
+	    (hwif->host_flags & IDE_HFLAG_ERROR_STOPS_FIFO) == 0) {
+		int nsect = drive->mult_count ? drive->mult_count : 1;
+
+		ide_pad_transfer(drive, READ, nsect * SECTOR_SIZE);
+	}
 
 	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq)) {
 		ide_kill_rq(drive, rq);
@@ -459,7 +437,7 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq, u
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTBSYNC(drive, WIN_IDLEIMMEDIATE,
+		hwif->OUTBSYNC(hwif, WIN_IDLEIMMEDIATE,
 			       hwif->io_ports.command_addr);
 
 	if (rq->errors >= ERROR_MAX) {
@@ -1539,88 +1517,30 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 }
 
 /**
- *	ide_init_drive_cmd	-	initialize a drive command request
- *	@rq: request object
- *
- *	Initialize a request before we fill it in and send it down to
- *	ide_do_drive_cmd. Commands must be set up by this function. Right
- *	now it doesn't do a lot, but if that changes abusers will have a
- *	nasty surprise.
- */
-
-void ide_init_drive_cmd (struct request *rq)
-{
-	blk_rq_init(NULL, rq);
-}
-
-EXPORT_SYMBOL(ide_init_drive_cmd);
-
-/**
  *	ide_do_drive_cmd	-	issue IDE special command
  *	@drive: device to issue command
  *	@rq: request to issue
- *	@action: action for processing
  *
  *	This function issues a special IDE device request
  *	onto the request queue.
  *
- *	If action is ide_wait, then the rq is queued at the end of the
- *	request queue, and the function sleeps until it has been processed.
- *	This is for use when invoked from an ioctl handler.
- *
- *	If action is ide_preempt, then the rq is queued at the head of
- *	the request queue, displacing the currently-being-processed
- *	request and this function returns immediately without waiting
- *	for the new rq to be completed.  This is VERY DANGEROUS, and is
- *	intended for careful use by the ATAPI tape/cdrom driver code.
- *
- *	If action is ide_end, then the rq is queued at the end of the
- *	request queue, and the function returns immediately without waiting
- *	for the new rq to be completed. This is again intended for careful
- *	use by the ATAPI tape/cdrom driver code.
+ *	the rq is queued at the head of the request queue, displacing
+ *	the currently-being-processed request and this function
+ *	returns immediately without waiting for the new rq to be
+ *	completed.  This is VERY DANGEROUS, and is intended for
+ *	careful use by the ATAPI tape/cdrom driver code.
  */
- 
-int ide_do_drive_cmd (ide_drive_t *drive, struct request *rq, ide_action_t action)
+
+void ide_do_drive_cmd(ide_drive_t *drive, struct request *rq)
 {
 	unsigned long flags;
 	ide_hwgroup_t *hwgroup = HWGROUP(drive);
-	DECLARE_COMPLETION_ONSTACK(wait);
-	int where = ELEVATOR_INSERT_BACK, err;
-	int must_wait = (action == ide_wait || action == ide_head_wait);
-
-	rq->errors = 0;
-
-	/*
-	 * we need to hold an extra reference to request for safe inspection
-	 * after completion
-	 */
-	if (must_wait) {
-		rq->ref_count++;
-		rq->end_io_data = &wait;
-		rq->end_io = blk_end_sync_rq;
-	}
 
 	spin_lock_irqsave(&ide_lock, flags);
-	if (action == ide_preempt)
-		hwgroup->rq = NULL;
-	if (action == ide_preempt || action == ide_head_wait) {
-		where = ELEVATOR_INSERT_FRONT;
-		rq->cmd_flags |= REQ_PREEMPT;
-	}
-	__elv_add_request(drive->queue, rq, where, 0);
-	ide_do_request(hwgroup, IDE_NO_IRQ);
+	hwgroup->rq = NULL;
+	__elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 1);
+	__generic_unplug_device(drive->queue);
 	spin_unlock_irqrestore(&ide_lock, flags);
-
-	err = 0;
-	if (must_wait) {
-		wait_for_completion(&wait);
-		if (rq->errors)
-			err = -EIO;
-
-		blk_put_request(rq);
-	}
-
-	return err;
 }
 
 EXPORT_SYMBOL(ide_do_drive_cmd);
@@ -1637,6 +1557,8 @@ void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount, u8 dma)
 	task.tf.lbah    = (bcount >> 8) & 0xff;
 
 	ide_tf_dump(drive->name, &task.tf);
+	ide_set_irq(drive, 1);
+	SELECT_MASK(drive, 0);
 	drive->hwif->tf_load(drive, &task);
 }
 
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 0daf923..80ad4f2 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -42,7 +42,7 @@ static void ide_outb (u8 val, unsigned long port)
 	outb(val, port);
 }
 
-static void ide_outbsync (ide_drive_t *drive, u8 addr, unsigned long port)
+static void ide_outbsync(ide_hwif_t *hwif, u8 addr, unsigned long port)
 {
 	outb(addr, port);
 }
@@ -68,7 +68,7 @@ static void ide_mm_outb (u8 value, unsigned long port)
 	writeb(value, (void __iomem *) port);
 }
 
-static void ide_mm_outbsync (ide_drive_t *drive, u8 value, unsigned long port)
+static void ide_mm_outbsync(ide_hwif_t *hwif, u8 value, unsigned long port)
 {
 	writeb(value, (void __iomem *) port);
 }
@@ -95,7 +95,7 @@ void SELECT_DRIVE (ide_drive_t *drive)
 	hwif->OUTB(drive->select.all, hwif->io_ports.device_addr);
 }
 
-static void SELECT_MASK(ide_drive_t *drive, int mask)
+void SELECT_MASK(ide_drive_t *drive, int mask)
 {
 	const struct ide_port_ops *port_ops = drive->hwif->port_ops;
 
@@ -120,11 +120,6 @@ static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	ide_set_irq(drive, 1);
-
-	if ((task->tf_flags & IDE_TFLAG_NO_SELECT_MASK) == 0)
-		SELECT_MASK(drive, 0);
-
 	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
 		u16 data = (tf->hob_data << 8) | tf->data;
 
@@ -191,7 +186,7 @@ static void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 	}
 
 	/* be sure we're looking at the low order bits */
-	tf_outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+	tf_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = tf_inb(io_ports->nsect_addr);
@@ -205,7 +200,7 @@ static void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 		tf->device = tf_inb(io_ports->device_addr);
 
 	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		tf_outb(drive->ctl | 0x80, io_ports->ctl_addr);
+		tf_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = tf_inb(io_ports->feature_addr);
@@ -689,9 +684,9 @@ int ide_driveid_update(ide_drive_t *drive)
 	 */
 
 	SELECT_MASK(drive, 1);
-	ide_set_irq(drive, 1);
+	ide_set_irq(drive, 0);
 	msleep(50);
-	hwif->OUTBSYNC(drive, WIN_IDENTIFY, hwif->io_ports.command_addr);
+	hwif->OUTBSYNC(hwif, WIN_IDENTIFY, hwif->io_ports.command_addr);
 	timeout = jiffies + WAIT_WORSTCASE;
 	do {
 		if (time_after(jiffies, timeout)) {
@@ -744,9 +739,6 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 	int error = 0;
 	u8 stat;
 
-//	while (HWGROUP(drive)->busy)
-//		msleep(50);
-
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	if (hwif->dma_ops)	/* check if host supports DMA */
 		hwif->dma_ops->dma_host_set(drive, 0);
@@ -781,7 +773,7 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 	ide_set_irq(drive, 0);
 	hwif->OUTB(speed, io_ports->nsect_addr);
 	hwif->OUTB(SETFEATURES_XFER, io_ports->feature_addr);
-	hwif->OUTBSYNC(drive, WIN_SETFEATURES, io_ports->command_addr);
+	hwif->OUTBSYNC(hwif, WIN_SETFEATURES, io_ports->command_addr);
 	if (drive->quirk_list == 2)
 		ide_set_irq(drive, 1);
 
@@ -889,7 +881,7 @@ void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
 
 	spin_lock_irqsave(&ide_lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
-	hwif->OUTBSYNC(drive, cmd, hwif->io_ports.command_addr);
+	hwif->OUTBSYNC(hwif, cmd, hwif->io_ports.command_addr);
 	/*
 	 * Drive takes 400nS to respond, we must avoid the IRQ being
 	 * serviced before that.
@@ -907,7 +899,7 @@ void ide_execute_pkt_cmd(ide_drive_t *drive)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ide_lock, flags);
-	hwif->OUTBSYNC(drive, WIN_PACKETCMD, hwif->io_ports.command_addr);
+	hwif->OUTBSYNC(hwif, WIN_PACKETCMD, hwif->io_ports.command_addr);
 	ndelay(400);
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
@@ -1102,7 +1094,7 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 		pre_reset(drive);
 		SELECT_DRIVE(drive);
 		udelay (20);
-		hwif->OUTBSYNC(drive, WIN_SRST, io_ports->command_addr);
+		hwif->OUTBSYNC(hwif, WIN_SRST, io_ports->command_addr);
 		ndelay(400);
 		hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
 		hwgroup->polling = 1;
@@ -1133,14 +1125,14 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	 * recover from reset very quickly, saving us the first 50ms wait time.
 	 */
 	/* set SRST and nIEN */
-	hwif->OUTBSYNC(drive, drive->ctl|6, io_ports->ctl_addr);
+	hwif->OUTBSYNC(hwif, ATA_DEVCTL_OBS | 6, io_ports->ctl_addr);
 	/* more than enough time */
 	udelay(10);
 	if (drive->quirk_list == 2)
-		ctl = drive->ctl;	/* clear SRST and nIEN */
+		ctl = ATA_DEVCTL_OBS;		/* clear SRST and nIEN */
 	else
-		ctl = drive->ctl | 2;	/* clear SRST, leave nIEN */
-	hwif->OUTBSYNC(drive, ctl, io_ports->ctl_addr);
+		ctl = ATA_DEVCTL_OBS | 2;	/* clear SRST, leave nIEN */
+	hwif->OUTBSYNC(hwif, ctl, io_ports->ctl_addr);
 	/* more than enough time */
 	udelay(10);
 	hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 26e68b6..d21e51a 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -293,7 +293,7 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 		hwif->OUTB(0, io_ports->feature_addr);
 
 	/* ask drive for ID */
-	hwif->OUTBSYNC(drive, cmd, io_ports->command_addr);
+	hwif->OUTBSYNC(hwif, cmd, hwif->io_ports.command_addr);
 
 	timeout = ((cmd == WIN_IDENTIFY) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 	timeout += jiffies;
@@ -478,9 +478,9 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			printk(KERN_ERR "%s: no response (status = 0x%02x), "
 					"resetting drive\n", drive->name, stat);
 			msleep(50);
-			hwif->OUTB(drive->select.all, io_ports->device_addr);
+			SELECT_DRIVE(drive);
 			msleep(50);
-			hwif->OUTBSYNC(drive, WIN_SRST, io_ports->command_addr);
+			hwif->OUTBSYNC(hwif, WIN_SRST, io_ports->command_addr);
 			(void)ide_busy_sleep(hwif);
 			rc = try_to_identify(drive, cmd);
 		}
@@ -516,7 +516,7 @@ static void enable_nest (ide_drive_t *drive)
 	printk("%s: enabling %s -- ", hwif->name, drive->id->model);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	hwif->OUTBSYNC(drive, EXABYTE_ENABLE_NEST, hwif->io_ports.command_addr);
+	hwif->OUTBSYNC(hwif, EXABYTE_ENABLE_NEST, hwif->io_ports.command_addr);
 
 	if (ide_busy_sleep(hwif)) {
 		printk(KERN_CONT "failed (timeout)\n");
@@ -1065,7 +1065,7 @@ static int init_irq (ide_hwif_t *hwif)
 
 		if (io_ports->ctl_addr)
 			/* clear nIEN */
-			hwif->OUTB(0x08, io_ports->ctl_addr);
+			hwif->OUTBSYNC(hwif, ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
 		if (request_irq(hwif->irq,&ide_intr,sa,hwif->name,hwgroup))
 	       		goto out_unlink;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1e1f263..6e1233b 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -144,9 +144,6 @@ enum {
 
 /*************************** End of tunable parameters ***********************/
 
-/* Read/Write error simulation */
-#define SIMULATE_ERRORS			0
-
 /* tape directions */
 enum {
 	IDETAPE_DIR_NONE  = (1 << 0),
@@ -442,7 +439,7 @@ static void idetape_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	}
 }
 
-static void idetape_update_buffers(struct ide_atapi_pc *pc)
+static void idetape_update_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
@@ -506,18 +503,6 @@ static struct request *idetape_next_rq_storage(ide_drive_t *drive)
 	return (&tape->rq_stack[tape->rq_stack_index++]);
 }
 
-static void idetape_init_pc(struct ide_atapi_pc *pc)
-{
-	memset(pc->c, 0, 12);
-	pc->retries = 0;
-	pc->flags = 0;
-	pc->req_xfer = 0;
-	pc->buf = pc->pc_buf;
-	pc->buf_size = IDETAPE_PC_BUFFER_SIZE;
-	pc->bh = NULL;
-	pc->b_data = NULL;
-}
-
 /*
  * called on each failed packet command retry to analyze the request sense. We
  * currently do not utilize this information.
@@ -538,8 +523,8 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	if (pc->flags & PC_FLAG_DMA_ERROR) {
 		pc->xferred = pc->req_xfer -
 			tape->blk_size *
-			be32_to_cpu(get_unaligned((u32 *)&sense[3]));
-		idetape_update_buffers(pc);
+			get_unaligned_be32(&sense[3]);
+		idetape_update_buffers(drive, pc);
 	}
 
 	/*
@@ -634,21 +619,78 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	return 0;
 }
 
-static ide_startstop_t idetape_request_sense_callback(ide_drive_t *drive)
+static void ide_tape_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
+	struct ide_atapi_pc *pc = tape->pc;
+	int uptodate = pc->error ? 0 : 1;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
-	if (!tape->pc->error) {
-		idetape_analyze_error(drive, tape->pc->buf);
-		idetape_end_request(drive, 1, 0);
-	} else {
-		printk(KERN_ERR "ide-tape: Error in REQUEST SENSE itself - "
-				"Aborting request!\n");
-		idetape_end_request(drive, 0, 0);
+	if (tape->failed_pc == pc)
+		tape->failed_pc = NULL;
+
+	if (pc->c[0] == REQUEST_SENSE) {
+		if (uptodate)
+			idetape_analyze_error(drive, pc->buf);
+		else
+			printk(KERN_ERR "ide-tape: Error in REQUEST SENSE "
+					"itself - Aborting request!\n");
+	} else if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
+		struct request *rq = drive->hwif->hwgroup->rq;
+		int blocks = pc->xferred / tape->blk_size;
+
+		tape->avg_size += blocks * tape->blk_size;
+
+		if (time_after_eq(jiffies, tape->avg_time + HZ)) {
+			tape->avg_speed = tape->avg_size * HZ /
+				(jiffies - tape->avg_time) / 1024;
+			tape->avg_size = 0;
+			tape->avg_time = jiffies;
+		}
+
+		tape->first_frame += blocks;
+		rq->current_nr_sectors -= blocks;
+
+		if (pc->error)
+			uptodate = pc->error;
+	} else if (pc->c[0] == READ_POSITION && uptodate) {
+		u8 *readpos = tape->pc->buf;
+
+		debug_log(DBG_SENSE, "BOP - %s\n",
+				(readpos[0] & 0x80) ? "Yes" : "No");
+		debug_log(DBG_SENSE, "EOP - %s\n",
+				(readpos[0] & 0x40) ? "Yes" : "No");
+
+		if (readpos[0] & 0x4) {
+			printk(KERN_INFO "ide-tape: Block location is unknown"
+					 "to the tape\n");
+			clear_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags);
+			uptodate = 0;
+		} else {
+			debug_log(DBG_SENSE, "Block Location - %u\n",
+					be32_to_cpu(*(u32 *)&readpos[4]));
+
+			tape->partition = readpos[1];
+			tape->first_frame = be32_to_cpu(*(u32 *)&readpos[4]);
+			set_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags);
+		}
 	}
-	return ide_stopped;
+
+	idetape_end_request(drive, uptodate, 0);
+}
+
+static void idetape_init_pc(struct ide_atapi_pc *pc)
+{
+	memset(pc->c, 0, 12);
+	pc->retries = 0;
+	pc->flags = 0;
+	pc->req_xfer = 0;
+	pc->buf = pc->pc_buf;
+	pc->buf_size = IDETAPE_PC_BUFFER_SIZE;
+	pc->bh = NULL;
+	pc->b_data = NULL;
+	pc->callback = ide_tape_callback;
 }
 
 static void idetape_create_request_sense_cmd(struct ide_atapi_pc *pc)
@@ -657,7 +699,6 @@ static void idetape_create_request_sense_cmd(struct ide_atapi_pc *pc)
 	pc->c[0] = REQUEST_SENSE;
 	pc->c[4] = 20;
 	pc->req_xfer = 20;
-	pc->idetape_callback = &idetape_request_sense_callback;
 }
 
 static void idetape_init_rq(struct request *rq, u8 cmd)
@@ -688,9 +729,10 @@ static void idetape_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	struct ide_tape_obj *tape = drive->driver_data;
 
 	idetape_init_rq(rq, REQ_IDETAPE_PC1);
+	rq->cmd_flags |= REQ_PREEMPT;
 	rq->buffer = (char *) pc;
 	rq->rq_disk = tape->disk;
-	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
+	ide_do_drive_cmd(drive, rq);
 }
 
 /*
@@ -698,7 +740,7 @@ static void idetape_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
  *	last packet command. We queue a request sense packet command in
  *	the head of the request list.
  */
-static ide_startstop_t idetape_retry_pc (ide_drive_t *drive)
+static void idetape_retry_pc(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc;
@@ -710,7 +752,6 @@ static ide_startstop_t idetape_retry_pc (ide_drive_t *drive)
 	idetape_create_request_sense_cmd(pc);
 	set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
 	idetape_queue_pc_head(drive, pc, rq);
-	return ide_stopped;
 }
 
 /*
@@ -727,7 +768,26 @@ static void idetape_postpone_request(ide_drive_t *drive)
 	ide_stall_queue(drive, tape->dsc_poll_freq);
 }
 
-typedef void idetape_io_buf(ide_drive_t *, struct ide_atapi_pc *, unsigned int);
+static void ide_tape_handle_dsc(ide_drive_t *drive)
+{
+	idetape_tape_t *tape = drive->driver_data;
+
+	/* Media access command */
+	tape->dsc_polling_start = jiffies;
+	tape->dsc_poll_freq = IDETAPE_DSC_MA_FAST;
+	tape->dsc_timeout = jiffies + IDETAPE_DSC_MA_TIMEOUT;
+	/* Allow ide.c to handle other requests */
+	idetape_postpone_request(drive);
+}
+
+static void ide_tape_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+				unsigned int bcount, int write)
+{
+	if (write)
+		idetape_output_buffers(drive, pc, bcount);
+	else
+		idetape_input_buffers(drive, pc, bcount);
+}
 
 /*
  * This is the usual interrupt handler which will be called during a packet
@@ -738,169 +798,11 @@ typedef void idetape_io_buf(ide_drive_t *, struct ide_atapi_pc *, unsigned int);
  */
 static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
-	struct ide_atapi_pc *pc = tape->pc;
-	xfer_func_t *xferfunc;
-	idetape_io_buf *iobuf;
-	unsigned int temp;
-#if SIMULATE_ERRORS
-	static int error_sim_count;
-#endif
-	u16 bcount;
-	u8 stat, ireason;
-
-	debug_log(DBG_PROCS, "Enter %s - interrupt handler\n", __func__);
-
-	/* Clear the interrupt */
-	stat = ide_read_status(drive);
-
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		if (hwif->dma_ops->dma_end(drive) || (stat & ERR_STAT)) {
-			/*
-			 * A DMA error is sometimes expected. For example,
-			 * if the tape is crossing a filemark during a
-			 * READ command, it will issue an irq and position
-			 * itself before the filemark, so that only a partial
-			 * data transfer will occur (which causes the DMA
-			 * error). In that case, we will later ask the tape
-			 * how much bytes of the original request were
-			 * actually transferred (we can't receive that
-			 * information from the DMA engine on most chipsets).
-			 */
-
-			/*
-			 * On the contrary, a DMA error is never expected;
-			 * it usually indicates a hardware error or abort.
-			 * If the tape crosses a filemark during a READ
-			 * command, it will issue an irq and position itself
-			 * after the filemark (not before). Only a partial
-			 * data transfer will occur, but no DMA error.
-			 * (AS, 19 Apr 2001)
-			 */
-			pc->flags |= PC_FLAG_DMA_ERROR;
-		} else {
-			pc->xferred = pc->req_xfer;
-			idetape_update_buffers(pc);
-		}
-		debug_log(DBG_PROCS, "DMA finished\n");
-
-	}
-
-	/* No more interrupts */
-	if ((stat & DRQ_STAT) == 0) {
-		debug_log(DBG_SENSE, "Packet command completed, %d bytes"
-				" transferred\n", pc->xferred);
-
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		local_irq_enable();
-
-#if SIMULATE_ERRORS
-		if ((pc->c[0] == WRITE_6 || pc->c[0] == READ_6) &&
-		    (++error_sim_count % 100) == 0) {
-			printk(KERN_INFO "ide-tape: %s: simulating error\n",
-				tape->name);
-			stat |= ERR_STAT;
-		}
-#endif
-		if ((stat & ERR_STAT) && pc->c[0] == REQUEST_SENSE)
-			stat &= ~ERR_STAT;
-		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
-			/* Error detected */
-			debug_log(DBG_ERR, "%s: I/O error\n", tape->name);
-
-			if (pc->c[0] == REQUEST_SENSE) {
-				printk(KERN_ERR "ide-tape: I/O error in request"
-						" sense command\n");
-				return ide_do_reset(drive);
-			}
-			debug_log(DBG_ERR, "[cmd %x]: check condition\n",
-					pc->c[0]);
-
-			/* Retry operation */
-			return idetape_retry_pc(drive);
-		}
-		pc->error = 0;
-		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) &&
-		    (stat & SEEK_STAT) == 0) {
-			/* Media access command */
-			tape->dsc_polling_start = jiffies;
-			tape->dsc_poll_freq = IDETAPE_DSC_MA_FAST;
-			tape->dsc_timeout = jiffies + IDETAPE_DSC_MA_TIMEOUT;
-			/* Allow ide.c to handle other requests */
-			idetape_postpone_request(drive);
-			return ide_stopped;
-		}
-		if (tape->failed_pc == pc)
-			tape->failed_pc = NULL;
-		/* Command finished - Call the callback function */
-		return pc->idetape_callback(drive);
-	}
-
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		printk(KERN_ERR "ide-tape: The tape wants to issue more "
-				"interrupts in DMA mode\n");
-		printk(KERN_ERR "ide-tape: DMA disabled, reverting to PIO\n");
-		ide_dma_off(drive);
-		return ide_do_reset(drive);
-	}
-	/* Get the number of bytes to transfer on this interrupt. */
-	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
-		  hwif->INB(hwif->io_ports.lbam_addr);
-
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
-
-	if (ireason & CD) {
-		printk(KERN_ERR "ide-tape: CoD != 0 in %s\n", __func__);
-		return ide_do_reset(drive);
-	}
-	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
-		/* Hopefully, we will never get here */
-		printk(KERN_ERR "ide-tape: We wanted to %s, ",
-				(ireason & IO) ? "Write" : "Read");
-		printk(KERN_ERR "ide-tape: but the tape wants us to %s !\n",
-				(ireason & IO) ? "Read" : "Write");
-		return ide_do_reset(drive);
-	}
-	if (!(pc->flags & PC_FLAG_WRITING)) {
-		/* Reading - Check that we have enough space */
-		temp = pc->xferred + bcount;
-		if (temp > pc->req_xfer) {
-			if (temp > pc->buf_size) {
-				printk(KERN_ERR "ide-tape: The tape wants to "
-					"send us more data than expected "
-					"- discarding data\n");
-				ide_pad_transfer(drive, 0, bcount);
-				ide_set_handler(drive, &idetape_pc_intr,
-						IDETAPE_WAIT_CMD, NULL);
-				return ide_started;
-			}
-			debug_log(DBG_SENSE, "The tape wants to send us more "
-				"data than expected - allowing transfer\n");
-		}
-		iobuf = &idetape_input_buffers;
-		xferfunc = hwif->input_data;
-	} else {
-		iobuf = &idetape_output_buffers;
-		xferfunc = hwif->output_data;
-	}
-
-	if (pc->bh)
-		iobuf(drive, pc, bcount);
-	else
-		xferfunc(drive, NULL, pc->cur_pos, bcount);
-
-	/* Update the current position */
-	pc->xferred += bcount;
-	pc->cur_pos += bcount;
-
-	debug_log(DBG_SENSE, "[cmd %x] transferred %d bytes on that intr.\n",
-			pc->c[0], bcount);
 
-	/* And set the interrupt handler again */
-	ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
-	return ide_started;
+	return ide_pc_intr(drive, tape->pc, idetape_pc_intr, IDETAPE_WAIT_CMD,
+			   NULL, idetape_update_buffers, idetape_retry_pc,
+			   ide_tape_handle_dsc, ide_tape_io_buffers);
 }
 
 /*
@@ -941,56 +843,16 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
  */
 static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
-	struct ide_atapi_pc *pc = tape->pc;
-	int retries = 100;
-	ide_startstop_t startstop;
-	u8 ireason;
-
-	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
-		printk(KERN_ERR "ide-tape: Strange, packet command initiated "
-				"yet DRQ isn't asserted\n");
-		return startstop;
-	}
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
-	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
-		printk(KERN_ERR "ide-tape: (IO,CoD != (0,1) while issuing "
-				"a packet command, retrying\n");
-		udelay(100);
-		ireason = hwif->INB(hwif->io_ports.nsect_addr);
-		if (retries == 0) {
-			printk(KERN_ERR "ide-tape: (IO,CoD != (0,1) while "
-					"issuing a packet command, ignoring\n");
-			ireason |= CD;
-			ireason &= ~IO;
-		}
-	}
-	if ((ireason & CD) == 0 || (ireason & IO)) {
-		printk(KERN_ERR "ide-tape: (IO,CoD) != (0,1) while issuing "
-				"a packet command\n");
-		return ide_do_reset(drive);
-	}
-	/* Set the interrupt routine */
-	ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
-#ifdef CONFIG_BLK_DEV_IDEDMA
-	/* Begin DMA, if necessary */
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS)
-		hwif->dma_ops->dma_start(drive);
-#endif
-	/* Send the actual packet */
-	hwif->output_data(drive, NULL, pc->c, 12);
 
-	return ide_started;
+	return ide_transfer_pc(drive, tape->pc, idetape_pc_intr,
+			       IDETAPE_WAIT_CMD, NULL);
 }
 
 static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 		struct ide_atapi_pc *pc)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
-	int dma_ok = 0;
-	u16 bcount;
 
 	if (tape->pc->c[0] == REQUEST_SENSE &&
 	    pc->c[0] == REQUEST_SENSE) {
@@ -1025,50 +887,15 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 			pc->error = IDETAPE_ERROR_GENERAL;
 		}
 		tape->failed_pc = NULL;
-		return pc->idetape_callback(drive);
+		pc->callback(drive);
+		return ide_stopped;
 	}
 	debug_log(DBG_SENSE, "Retry #%d, cmd = %02X\n", pc->retries, pc->c[0]);
 
 	pc->retries++;
-	/* We haven't transferred any data yet */
-	pc->xferred = 0;
-	pc->cur_pos = pc->buf;
-	/* Request to transfer the entire buffer at once */
-	bcount = pc->req_xfer;
 
-	if (pc->flags & PC_FLAG_DMA_ERROR) {
-		pc->flags &= ~PC_FLAG_DMA_ERROR;
-		printk(KERN_WARNING "ide-tape: DMA disabled, "
-				"reverting to PIO\n");
-		ide_dma_off(drive);
-	}
-	if ((pc->flags & PC_FLAG_DMA_RECOMMENDED) && drive->using_dma)
-		dma_ok = !hwif->dma_ops->dma_setup(drive);
-
-	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
-			   IDE_TFLAG_OUT_DEVICE, bcount, dma_ok);
-
-	if (dma_ok)
-		/* Will begin DMA later */
-		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
-	if (test_bit(IDETAPE_FLAG_DRQ_INTERRUPT, &tape->flags)) {
-		ide_execute_command(drive, WIN_PACKETCMD, &idetape_transfer_pc,
-				    IDETAPE_WAIT_CMD, NULL);
-		return ide_started;
-	} else {
-		ide_execute_pkt_cmd(drive);
-		return idetape_transfer_pc(drive);
-	}
-}
-
-static ide_startstop_t idetape_pc_callback(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	idetape_end_request(drive, tape->pc->error ? 0 : 1, 0);
-	return ide_stopped;
+	return ide_issue_pc(drive, pc, idetape_transfer_pc,
+			    IDETAPE_WAIT_CMD, NULL);
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
@@ -1096,7 +923,6 @@ static void idetape_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
 		pc->req_xfer = 24;
 	else
 		pc->req_xfer = 50;
-	pc->idetape_callback = &idetape_pc_callback;
 }
 
 static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
@@ -1114,80 +940,41 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 				printk(KERN_ERR "ide-tape: %s: I/O error, ",
 						tape->name);
 			/* Retry operation */
-			return idetape_retry_pc(drive);
+			idetape_retry_pc(drive);
+			return ide_stopped;
 		}
 		pc->error = 0;
-		if (tape->failed_pc == pc)
-			tape->failed_pc = NULL;
 	} else {
 		pc->error = IDETAPE_ERROR_GENERAL;
 		tape->failed_pc = NULL;
 	}
-	return pc->idetape_callback(drive);
-}
-
-static ide_startstop_t idetape_rw_callback(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	struct request *rq = HWGROUP(drive)->rq;
-	int blocks = tape->pc->xferred / tape->blk_size;
-
-	tape->avg_size += blocks * tape->blk_size;
-
-	if (time_after_eq(jiffies, tape->avg_time + HZ)) {
-		tape->avg_speed = tape->avg_size * HZ /
-				(jiffies - tape->avg_time) / 1024;
-		tape->avg_size = 0;
-		tape->avg_time = jiffies;
-	}
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	tape->first_frame += blocks;
-	rq->current_nr_sectors -= blocks;
-
-	if (!tape->pc->error)
-		idetape_end_request(drive, 1, 0);
-	else
-		idetape_end_request(drive, tape->pc->error, 0);
+	pc->callback(drive);
 	return ide_stopped;
 }
 
-static void idetape_create_read_cmd(idetape_tape_t *tape,
-		struct ide_atapi_pc *pc,
-		unsigned int length, struct idetape_bh *bh)
+static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
+		struct ide_atapi_pc *pc, unsigned int length,
+		struct idetape_bh *bh, u8 opcode)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = READ_6;
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
-	pc->idetape_callback = &idetape_rw_callback;
 	pc->bh = bh;
-	atomic_set(&bh->b_count, 0);
 	pc->buf = NULL;
 	pc->buf_size = length * tape->blk_size;
 	pc->req_xfer = pc->buf_size;
 	if (pc->req_xfer == tape->buffer_size)
-		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
-}
+		pc->flags |= PC_FLAG_DMA_OK;
 
-static void idetape_create_write_cmd(idetape_tape_t *tape,
-		struct ide_atapi_pc *pc,
-		unsigned int length, struct idetape_bh *bh)
-{
-	idetape_init_pc(pc);
-	pc->c[0] = WRITE_6;
-	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
-	pc->c[1] = 1;
-	pc->idetape_callback = &idetape_rw_callback;
-	pc->flags |= PC_FLAG_WRITING;
-	pc->bh = bh;
-	pc->b_data = bh->b_data;
-	pc->b_count = atomic_read(&bh->b_count);
-	pc->buf = NULL;
-	pc->buf_size = length * tape->blk_size;
-	pc->req_xfer = pc->buf_size;
-	if (pc->req_xfer == tape->buffer_size)
-		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
+	if (opcode == READ_6) {
+		pc->c[0] = READ_6;
+		atomic_set(&bh->b_count, 0);
+	} else if (opcode == WRITE_6) {
+		pc->c[0] = WRITE_6;
+		pc->flags |= PC_FLAG_WRITING;
+		pc->b_data = bh->b_data;
+		pc->b_count = atomic_read(&bh->b_count);
+	}
 }
 
 static ide_startstop_t idetape_do_request(ide_drive_t *drive,
@@ -1211,8 +998,10 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	}
 
 	/* Retry a failed packet command */
-	if (tape->failed_pc && tape->pc->c[0] == REQUEST_SENSE)
-		return idetape_issue_pc(drive, tape->failed_pc);
+	if (tape->failed_pc && tape->pc->c[0] == REQUEST_SENSE) {
+		pc = tape->failed_pc;
+		goto out;
+	}
 
 	if (postponed_rq != NULL)
 		if (rq != postponed_rq) {
@@ -1262,14 +1051,16 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_READ) {
 		pc = idetape_next_pc_storage(drive);
-		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors,
-					(struct idetape_bh *)rq->special);
+		ide_tape_create_rw_cmd(tape, pc, rq->current_nr_sectors,
+					(struct idetape_bh *)rq->special,
+					READ_6);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
 		pc = idetape_next_pc_storage(drive);
-		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors,
-					 (struct idetape_bh *)rq->special);
+		ide_tape_create_rw_cmd(tape, pc, rq->current_nr_sectors,
+					 (struct idetape_bh *)rq->special,
+					 WRITE_6);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_PC1) {
@@ -1284,6 +1075,9 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	}
 	BUG();
 out:
+	if (test_bit(IDETAPE_FLAG_DRQ_INTERRUPT, &tape->flags))
+		pc->flags |= PC_FLAG_DRQ_INTERRUPT;
+
 	return idetape_issue_pc(drive, pc);
 }
 
@@ -1447,40 +1241,6 @@ static void idetape_init_merge_buffer(idetape_tape_t *tape)
 	}
 }
 
-static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	u8 *readpos = tape->pc->buf;
-
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	if (!tape->pc->error) {
-		debug_log(DBG_SENSE, "BOP - %s\n",
-				(readpos[0] & 0x80) ? "Yes" : "No");
-		debug_log(DBG_SENSE, "EOP - %s\n",
-				(readpos[0] & 0x40) ? "Yes" : "No");
-
-		if (readpos[0] & 0x4) {
-			printk(KERN_INFO "ide-tape: Block location is unknown"
-					 "to the tape\n");
-			clear_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags);
-			idetape_end_request(drive, 0, 0);
-		} else {
-			debug_log(DBG_SENSE, "Block Location - %u\n",
-					be32_to_cpu(*(u32 *)&readpos[4]));
-
-			tape->partition = readpos[1];
-			tape->first_frame =
-				be32_to_cpu(*(u32 *)&readpos[4]);
-			set_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags);
-			idetape_end_request(drive, 1, 0);
-		}
-	} else {
-		idetape_end_request(drive, 0, 0);
-	}
-	return ide_stopped;
-}
-
 /*
  * Write a filemark if write_filemark=1. Flush the device buffers without
  * writing a filemark otherwise.
@@ -1492,14 +1252,12 @@ static void idetape_create_write_filemark_cmd(ide_drive_t *drive,
 	pc->c[0] = WRITE_FILEMARKS;
 	pc->c[4] = write_filemark;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
-	pc->idetape_callback = &idetape_pc_callback;
 }
 
 static void idetape_create_test_unit_ready_cmd(struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = TEST_UNIT_READY;
-	pc->idetape_callback = &idetape_pc_callback;
 }
 
 /*
@@ -1518,12 +1276,16 @@ static void idetape_create_test_unit_ready_cmd(struct ide_atapi_pc *pc)
 static int idetape_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
-	struct request rq;
+	struct request *rq;
+	int error;
 
-	idetape_init_rq(&rq, REQ_IDETAPE_PC1);
-	rq.buffer = (char *) pc;
-	rq.rq_disk = tape->disk;
-	return ide_do_drive_cmd(drive, &rq, ide_wait);
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd[0] = REQ_IDETAPE_PC1;
+	rq->buffer = (char *)pc;
+	error = blk_execute_rq(drive->queue, tape->disk, rq, 0);
+	blk_put_request(rq);
+	return error;
 }
 
 static void idetape_create_load_unload_cmd(ide_drive_t *drive,
@@ -1533,7 +1295,6 @@ static void idetape_create_load_unload_cmd(ide_drive_t *drive,
 	pc->c[0] = START_STOP;
 	pc->c[4] = cmd;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
-	pc->idetape_callback = &idetape_pc_callback;
 }
 
 static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
@@ -1585,7 +1346,6 @@ static void idetape_create_read_position_cmd(struct ide_atapi_pc *pc)
 	idetape_init_pc(pc);
 	pc->c[0] = READ_POSITION;
 	pc->req_xfer = 20;
-	pc->idetape_callback = &idetape_read_position_callback;
 }
 
 static int idetape_read_position(ide_drive_t *drive)
@@ -1613,7 +1373,6 @@ static void idetape_create_locate_cmd(ide_drive_t *drive,
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[3]);
 	pc->c[8] = partition;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
-	pc->idetape_callback = &idetape_pc_callback;
 }
 
 static int idetape_create_prevent_cmd(ide_drive_t *drive,
@@ -1628,7 +1387,6 @@ static int idetape_create_prevent_cmd(ide_drive_t *drive,
 	idetape_init_pc(pc);
 	pc->c[0] = ALLOW_MEDIUM_REMOVAL;
 	pc->c[4] = prevent;
-	pc->idetape_callback = &idetape_pc_callback;
 	return 1;
 }
 
@@ -1700,26 +1458,33 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 				 struct idetape_bh *bh)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	struct request rq;
+	struct request *rq;
+	int ret, errors;
 
 	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
 
-	idetape_init_rq(&rq, cmd);
-	rq.rq_disk = tape->disk;
-	rq.special = (void *)bh;
-	rq.sector = tape->first_frame;
-	rq.nr_sectors		= blocks;
-	rq.current_nr_sectors	= blocks;
-	(void) ide_do_drive_cmd(drive, &rq, ide_wait);
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd[0] = cmd;
+	rq->rq_disk = tape->disk;
+	rq->special = (void *)bh;
+	rq->sector = tape->first_frame;
+	rq->nr_sectors = blocks;
+	rq->current_nr_sectors = blocks;
+	blk_execute_rq(drive->queue, tape->disk, rq, 0);
+
+	errors = rq->errors;
+	ret = tape->blk_size * (blocks - rq->current_nr_sectors);
+	blk_put_request(rq);
 
 	if ((cmd & (REQ_IDETAPE_READ | REQ_IDETAPE_WRITE)) == 0)
 		return 0;
 
 	if (tape->merge_bh)
 		idetape_init_merge_buffer(tape);
-	if (rq.errors == IDETAPE_ERROR_GENERAL)
+	if (errors == IDETAPE_ERROR_GENERAL)
 		return -EIO;
-	return (tape->blk_size * (blocks-rq.current_nr_sectors));
+	return ret;
 }
 
 static void idetape_create_inquiry_cmd(struct ide_atapi_pc *pc)
@@ -1728,7 +1493,6 @@ static void idetape_create_inquiry_cmd(struct ide_atapi_pc *pc)
 	pc->c[0] = INQUIRY;
 	pc->c[4] = 254;
 	pc->req_xfer = 254;
-	pc->idetape_callback = &idetape_pc_callback;
 }
 
 static void idetape_create_rewind_cmd(ide_drive_t *drive,
@@ -1737,7 +1501,6 @@ static void idetape_create_rewind_cmd(ide_drive_t *drive,
 	idetape_init_pc(pc);
 	pc->c[0] = REZERO_UNIT;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
-	pc->idetape_callback = &idetape_pc_callback;
 }
 
 static void idetape_create_erase_cmd(struct ide_atapi_pc *pc)
@@ -1746,7 +1509,6 @@ static void idetape_create_erase_cmd(struct ide_atapi_pc *pc)
 	pc->c[0] = ERASE;
 	pc->c[1] = 1;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
-	pc->idetape_callback = &idetape_pc_callback;
 }
 
 static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
@@ -1756,7 +1518,6 @@ static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
 	put_unaligned(cpu_to_be32(count), (unsigned int *) &pc->c[1]);
 	pc->c[1] = cmd;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
-	pc->idetape_callback = &idetape_pc_callback;
 }
 
 /* Queue up a character device originated write request. */
@@ -2746,9 +2507,8 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	 * Ensure that the number we got makes sense; limit it within
 	 * IDETAPE_DSC_RW_MIN and IDETAPE_DSC_RW_MAX.
 	 */
-	tape->best_dsc_rw_freq = max_t(unsigned long,
-				min_t(unsigned long, t, IDETAPE_DSC_RW_MAX),
-				IDETAPE_DSC_RW_MIN);
+	tape->best_dsc_rw_freq = clamp_t(unsigned long, t, IDETAPE_DSC_RW_MIN,
+					 IDETAPE_DSC_RW_MAX);
 	printk(KERN_INFO "ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, "
 		"%lums tDSC%s\n",
 		drive->name, tape->name, *(u16 *)&tape->caps[14],
@@ -2900,11 +2660,6 @@ static int ide_tape_probe(ide_drive_t *drive)
 				" the driver\n", drive->name);
 		goto failed;
 	}
-	if (drive->scsi) {
-		printk(KERN_INFO "ide-tape: passing drive %s to ide-scsi"
-				 " emulation.\n", drive->name);
-		goto failed;
-	}
 	tape = kzalloc(sizeof(idetape_tape_t), GFP_KERNEL);
 	if (tape == NULL) {
 		printk(KERN_ERR "ide-tape: %s: Can't allocate a tape struct\n",
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index ab545ff..cf55a48 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -109,13 +109,15 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 
 	if ((task->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
 		ide_tf_dump(drive->name, tf);
+		ide_set_irq(drive, 1);
+		SELECT_MASK(drive, 0);
 		hwif->tf_load(drive, task);
 	}
 
 	switch (task->data_phase) {
 	case TASKFILE_MULTI_OUT:
 	case TASKFILE_OUT:
-		hwif->OUTBSYNC(drive, tf->command, hwif->io_ports.command_addr);
+		hwif->OUTBSYNC(hwif, tf->command, hwif->io_ports.command_addr);
 		ndelay(400);	/* FIXME */
 		return pre_task_out_intr(drive, task->rq);
 	case TASKFILE_MULTI_IN:
@@ -492,11 +494,12 @@ static ide_startstop_t pre_task_out_intr(ide_drive_t *drive, struct request *rq)
 
 int ide_raw_taskfile(ide_drive_t *drive, ide_task_t *task, u8 *buf, u16 nsect)
 {
-	struct request rq;
+	struct request *rq;
+	int error;
 
-	blk_rq_init(NULL, &rq);
-	rq.cmd_type = REQ_TYPE_ATA_TASKFILE;
-	rq.buffer = buf;
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
+	rq->buffer = buf;
 
 	/*
 	 * (ks) We transfer currently only whole sectors.
@@ -504,16 +507,19 @@ int ide_raw_taskfile(ide_drive_t *drive, ide_task_t *task, u8 *buf, u16 nsect)
 	 * if we would find a solution to transfer any size.
 	 * To support special commands like READ LONG.
 	 */
-	rq.hard_nr_sectors = rq.nr_sectors = nsect;
-	rq.hard_cur_sectors = rq.current_nr_sectors = nsect;
+	rq->hard_nr_sectors = rq->nr_sectors = nsect;
+	rq->hard_cur_sectors = rq->current_nr_sectors = nsect;
 
 	if (task->tf_flags & IDE_TFLAG_WRITE)
-		rq.cmd_flags |= REQ_RW;
+		rq->cmd_flags |= REQ_RW;
 
-	rq.special = task;
-	task->rq = &rq;
+	rq->special = task;
+	task->rq = rq;
 
-	return ide_do_drive_cmd(drive, &rq, ide_wait);
+	error = blk_execute_rq(drive->queue, NULL, rq, 0);
+	blk_put_request(rq);
+
+	return error;
 }
 
 EXPORT_SYMBOL(ide_raw_taskfile);
@@ -739,12 +745,14 @@ int ide_cmd_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 	struct hd_driveid *id = drive->id;
 
 	if (NULL == (void *) arg) {
-		struct request rq;
+		struct request *rq;
 
-		ide_init_drive_cmd(&rq);
-		rq.cmd_type = REQ_TYPE_ATA_TASKFILE;
+		rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+		rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
+		err = blk_execute_rq(drive->queue, NULL, rq, 0);
+		blk_put_request(rq);
 
-		return ide_do_drive_cmd(drive, &rq, ide_wait);
+		return err;
 	}
 
 	if (copy_from_user(args, (void __user *)arg, 4))
diff --git a/drivers/ide/ide-timing.h b/drivers/ide/ide-timing.h
index 3b12ffe..2e91c58 100644
--- a/drivers/ide/ide-timing.h
+++ b/drivers/ide/ide-timing.h
@@ -95,7 +95,6 @@ static struct ide_timing ide_timing[] = {
 #define IDE_TIMING_UDMA		0x80
 #define IDE_TIMING_ALL		0xff
 
-#define FIT(v,vmin,vmax)	max_t(short,min_t(short,v,vmax),vmin)
 #define ENOUGH(v,unit)		(((v)-1)/(unit)+1)
 #define EZ(v,unit)		((v)?ENOUGH(v,unit):0)
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 300431d..2b84535 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -86,13 +86,10 @@ static const u8 ide_hwif_to_major[] = { IDE0_MAJOR, IDE1_MAJOR,
 					IDE6_MAJOR, IDE7_MAJOR,
 					IDE8_MAJOR, IDE9_MAJOR };
 
-static int idebus_parameter;	/* holds the "idebus=" parameter */
-static int system_bus_speed;	/* holds what we think is VESA/PCI bus speed */
-
 DEFINE_MUTEX(ide_cfg_mtx);
- __cacheline_aligned_in_smp DEFINE_SPINLOCK(ide_lock);
 
-int noautodma = 0;
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(ide_lock);
+EXPORT_SYMBOL(ide_lock);
 
 ide_hwif_t ide_hwifs[MAX_HWIFS];	/* master data repository */
 
@@ -139,7 +136,6 @@ static void ide_port_init_devices_data(ide_hwif_t *hwif)
 		drive->media			= ide_disk;
 		drive->select.all		= (unit<<4)|0xa0;
 		drive->hwif			= hwif;
-		drive->ctl			= 0x08;
 		drive->ready_stat		= READY_STAT;
 		drive->bad_wstat		= BAD_W_STAT;
 		drive->special.b.recalibrate	= 1;
@@ -154,32 +150,9 @@ static void ide_port_init_devices_data(ide_hwif_t *hwif)
 	}
 }
 
-/*
- * init_ide_data() sets reasonable default values into all fields
- * of all instances of the hwifs and drives, but only on the first call.
- * Subsequent calls have no effect (they don't wipe out anything).
- *
- * This routine is normally called at driver initialization time,
- * but may also be called MUCH earlier during kernel "command-line"
- * parameter processing.  As such, we cannot depend on any other parts
- * of the kernel (such as memory allocation) to be functioning yet.
- *
- * This is too bad, as otherwise we could dynamically allocate the
- * ide_drive_t structs as needed, rather than always consuming memory
- * for the max possible number (MAX_HWIFS * MAX_DRIVES) of them.
- *
- * FIXME: We should stuff the setup data into __init and copy the
- * relevant hwifs/allocate them properly during boot.
- */
-#define MAGIC_COOKIE 0x12345678
 static void __init init_ide_data (void)
 {
 	unsigned int index;
-	static unsigned long magic_cookie = MAGIC_COOKIE;
-
-	if (magic_cookie != MAGIC_COOKIE)
-		return;		/* already initialized */
-	magic_cookie = 0;
 
 	/* Initialise all interface structures */
 	for (index = 0; index < MAX_HWIFS; ++index) {
@@ -189,38 +162,6 @@ static void __init init_ide_data (void)
 	}
 }
 
-/**
- *	ide_system_bus_speed	-	guess bus speed
- *
- *	ide_system_bus_speed() returns what we think is the system VESA/PCI
- *	bus speed (in MHz). This is used for calculating interface PIO timings.
- *	The default is 40 for known PCI systems, 50 otherwise.
- *	The "idebus=xx" parameter can be used to override this value.
- *	The actual value to be used is computed/displayed the first time
- *	through. Drivers should only use this as a last resort.
- *
- *	Returns a guessed speed in MHz.
- */
-
-static int ide_system_bus_speed(void)
-{
-#ifdef CONFIG_PCI
-	static struct pci_device_id pci_default[] = {
-		{ PCI_DEVICE(PCI_ANY_ID, PCI_ANY_ID) },
-		{ }
-	};
-#else
-#define pci_default 0
-#endif /* CONFIG_PCI */
-
-	/* user supplied value */
-	if (idebus_parameter)
-		return idebus_parameter;
-
-	/* safe default value for PCI or VESA and PCI*/
-	return pci_dev_present(pci_default) ? 33 : 50;
-}
-
 void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
 {
 	ide_hwgroup_t *hwgroup = hwif->hwgroup;
@@ -498,7 +439,7 @@ out:
 
 int set_pio_mode(ide_drive_t *drive, int arg)
 {
-	struct request rq;
+	struct request *rq;
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 
@@ -512,12 +453,15 @@ int set_pio_mode(ide_drive_t *drive, int arg)
 	if (drive->special.b.set_tune)
 		return -EBUSY;
 
-	ide_init_drive_cmd(&rq);
-	rq.cmd_type = REQ_TYPE_ATA_TASKFILE;
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 
 	drive->tune_req = (u8) arg;
 	drive->special.b.set_tune = 1;
-	(void) ide_do_drive_cmd(drive, &rq, ide_wait);
+
+	blk_execute_rq(drive->queue, NULL, rq, 0);
+	blk_put_request(rq);
+
 	return 0;
 }
 
@@ -537,25 +481,11 @@ static int set_unmaskirq(ide_drive_t *drive, int arg)
 	return 0;
 }
 
-/**
- *	system_bus_clock	-	clock guess
- *
- *	External version of the bus clock guess used by very old IDE drivers
- *	for things like VLB timings. Should not be used.
- */
-
-int system_bus_clock (void)
-{
-	return system_bus_speed;
-}
-
-EXPORT_SYMBOL(system_bus_clock);
-
 static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 {
 	ide_drive_t *drive = dev->driver_data;
 	ide_hwif_t *hwif = HWIF(drive);
-	struct request rq;
+	struct request *rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
 	int ret;
@@ -564,18 +494,19 @@ static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	if (!(drive->dn % 2))
 		ide_acpi_get_timing(hwif);
 
-	blk_rq_init(NULL, &rq);
 	memset(&rqpm, 0, sizeof(rqpm));
 	memset(&args, 0, sizeof(args));
-	rq.cmd_type = REQ_TYPE_PM_SUSPEND;
-	rq.special = &args;
-	rq.data = &rqpm;
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_PM_SUSPEND;
+	rq->special = &args;
+	rq->data = &rqpm;
 	rqpm.pm_step = ide_pm_state_start_suspend;
 	if (mesg.event == PM_EVENT_PRETHAW)
 		mesg.event = PM_EVENT_FREEZE;
 	rqpm.pm_state = mesg.event;
 
-	ret = ide_do_drive_cmd(drive, &rq, ide_wait);
+	ret = blk_execute_rq(drive->queue, NULL, rq, 0);
+	blk_put_request(rq);
 	/* only call ACPI _PS3 after both drivers are suspended */
 	if (!ret && (((drive->dn % 2) && hwif->drives[0].present
 		 && hwif->drives[1].present)
@@ -589,7 +520,7 @@ static int generic_ide_resume(struct device *dev)
 {
 	ide_drive_t *drive = dev->driver_data;
 	ide_hwif_t *hwif = HWIF(drive);
-	struct request rq;
+	struct request *rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
 	int err;
@@ -602,16 +533,18 @@ static int generic_ide_resume(struct device *dev)
 
 	ide_acpi_exec_tfs(drive);
 
-	blk_rq_init(NULL, &rq);
 	memset(&rqpm, 0, sizeof(rqpm));
 	memset(&args, 0, sizeof(args));
-	rq.cmd_type = REQ_TYPE_PM_RESUME;
-	rq.special = &args;
-	rq.data = &rqpm;
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_PM_RESUME;
+	rq->cmd_flags |= REQ_PREEMPT;
+	rq->special = &args;
+	rq->data = &rqpm;
 	rqpm.pm_step = ide_pm_state_start_resume;
 	rqpm.pm_state = PM_EVENT_ON;
 
-	err = ide_do_drive_cmd(drive, &rq, ide_head_wait);
+	err = blk_execute_rq(drive->queue, NULL, rq, 1);
+	blk_put_request(rq);
 
 	if (err == 0 && dev->driver) {
 		ide_driver_t *drv = to_ide_driver(dev->driver);
@@ -764,212 +697,6 @@ set_val:
 
 EXPORT_SYMBOL(generic_ide_ioctl);
 
-/*
- * stridx() returns the offset of c within s,
- * or -1 if c is '\0' or not found within s.
- */
-static int __init stridx (const char *s, char c)
-{
-	char *i = strchr(s, c);
-	return (i && c) ? i - s : -1;
-}
-
-/*
- * match_parm() does parsing for ide_setup():
- *
- * 1. the first char of s must be '='.
- * 2. if the remainder matches one of the supplied keywords,
- *     the index (1 based) of the keyword is negated and returned.
- * 3. if the remainder is a series of no more than max_vals numbers
- *     separated by commas, the numbers are saved in vals[] and a
- *     count of how many were saved is returned.  Base10 is assumed,
- *     and base16 is allowed when prefixed with "0x".
- * 4. otherwise, zero is returned.
- */
-static int __init match_parm (char *s, const char *keywords[], int vals[], int max_vals)
-{
-	static const char *decimal = "0123456789";
-	static const char *hex = "0123456789abcdef";
-	int i, n;
-
-	if (*s++ == '=') {
-		/*
-		 * Try matching against the supplied keywords,
-		 * and return -(index+1) if we match one
-		 */
-		if (keywords != NULL) {
-			for (i = 0; *keywords != NULL; ++i) {
-				if (!strcmp(s, *keywords++))
-					return -(i+1);
-			}
-		}
-		/*
-		 * Look for a series of no more than "max_vals"
-		 * numeric values separated by commas, in base10,
-		 * or base16 when prefixed with "0x".
-		 * Return a count of how many were found.
-		 */
-		for (n = 0; (i = stridx(decimal, *s)) >= 0;) {
-			vals[n] = i;
-			while ((i = stridx(decimal, *++s)) >= 0)
-				vals[n] = (vals[n] * 10) + i;
-			if (*s == 'x' && !vals[n]) {
-				while ((i = stridx(hex, *++s)) >= 0)
-					vals[n] = (vals[n] * 0x10) + i;
-			}
-			if (++n == max_vals)
-				break;
-			if (*s == ',' || *s == ';')
-				++s;
-		}
-		if (!*s)
-			return n;
-	}
-	return 0;	/* zero = nothing matched */
-}
-
-/*
- * ide_setup() gets called VERY EARLY during initialization,
- * to handle kernel "command line" strings beginning with "hdx=" or "ide".
- *
- * Remember to update Documentation/ide/ide.txt if you change something here.
- */
-static int __init ide_setup(char *s)
-{
-	ide_hwif_t *hwif;
-	ide_drive_t *drive;
-	unsigned int hw, unit;
-	int vals[3];
-	const char max_drive = 'a' + ((MAX_HWIFS * MAX_DRIVES) - 1);
-
-	if (strncmp(s,"hd",2) == 0 && s[2] == '=')	/* hd= is for hd.c   */
-		return 0;				/* driver and not us */
-
-	if (strncmp(s,"ide",3) && strncmp(s,"idebus",6) && strncmp(s,"hd",2))
-		return 0;
-
-	printk(KERN_INFO "ide_setup: %s", s);
-	init_ide_data ();
-
-#ifdef CONFIG_BLK_DEV_IDEDOUBLER
-	if (!strcmp(s, "ide=doubler")) {
-		extern int ide_doubler;
-
-		printk(" : Enabled support for IDE doublers\n");
-		ide_doubler = 1;
-		goto obsolete_option;
-	}
-#endif /* CONFIG_BLK_DEV_IDEDOUBLER */
-
-	if (!strcmp(s, "ide=nodma")) {
-		printk(" : Prevented DMA\n");
-		noautodma = 1;
-		goto obsolete_option;
-	}
-
-#ifdef CONFIG_BLK_DEV_IDEACPI
-	if (!strcmp(s, "ide=noacpi")) {
-		//printk(" : Disable IDE ACPI support.\n");
-		ide_noacpi = 1;
-		goto obsolete_option;
-	}
-	if (!strcmp(s, "ide=acpigtf")) {
-		//printk(" : Enable IDE ACPI _GTF support.\n");
-		ide_acpigtf = 1;
-		goto obsolete_option;
-	}
-	if (!strcmp(s, "ide=acpionboot")) {
-		//printk(" : Call IDE ACPI methods on boot.\n");
-		ide_acpionboot = 1;
-		goto obsolete_option;
-	}
-#endif /* CONFIG_BLK_DEV_IDEACPI */
-
-	/*
-	 * Look for drive options:  "hdx="
-	 */
-	if (s[0] == 'h' && s[1] == 'd' && s[2] >= 'a' && s[2] <= max_drive) {
-		const char *hd_words[] = {
-			"none", "noprobe", "nowerr", "cdrom", "nodma",
-			"-6", "-7", "-8", "-9", "-10",
-			"noflush", "remap", "remap63", "scsi", NULL };
-		unit = s[2] - 'a';
-		hw   = unit / MAX_DRIVES;
-		unit = unit % MAX_DRIVES;
-		hwif = &ide_hwifs[hw];
-		drive = &hwif->drives[unit];
-		if (strncmp(s + 4, "ide-", 4) == 0) {
-			strlcpy(drive->driver_req, s + 4, sizeof(drive->driver_req));
-			goto obsolete_option;
-		}
-		switch (match_parm(&s[3], hd_words, vals, 3)) {
-			case -1: /* "none" */
-			case -2: /* "noprobe" */
-				drive->noprobe = 1;
-				goto obsolete_option;
-			case -3: /* "nowerr" */
-				drive->bad_wstat = BAD_R_STAT;
-				goto obsolete_option;
-			case -4: /* "cdrom" */
-				drive->present = 1;
-				drive->media = ide_cdrom;
-				/* an ATAPI device ignores DRDY */
-				drive->ready_stat = 0;
-				goto obsolete_option;
-			case -5: /* nodma */
-				drive->nodma = 1;
-				goto obsolete_option;
-			case -11: /* noflush */
-				drive->noflush = 1;
-				goto obsolete_option;
-			case -12: /* "remap" */
-				drive->remap_0_to_1 = 1;
-				goto obsolete_option;
-			case -13: /* "remap63" */
-				drive->sect0 = 63;
-				goto obsolete_option;
-			case -14: /* "scsi" */
-				drive->scsi = 1;
-				goto obsolete_option;
-			case 3: /* cyl,head,sect */
-				drive->media	= ide_disk;
-				drive->ready_stat = READY_STAT;
-				drive->cyl	= drive->bios_cyl  = vals[0];
-				drive->head	= drive->bios_head = vals[1];
-				drive->sect	= drive->bios_sect = vals[2];
-				drive->present	= 1;
-				drive->forced_geom = 1;
-				goto obsolete_option;
-			default:
-				goto bad_option;
-		}
-	}
-
-	if (s[0] != 'i' || s[1] != 'd' || s[2] != 'e')
-		goto bad_option;
-	/*
-	 * Look for bus speed option:  "idebus="
-	 */
-	if (s[3] == 'b' && s[4] == 'u' && s[5] == 's') {
-		if (match_parm(&s[6], NULL, vals, 1) != 1)
-			goto bad_option;
-		if (vals[0] >= 20 && vals[0] <= 66) {
-			idebus_parameter = vals[0];
-		} else
-			printk(" -- BAD BUS SPEED! Expected value from 20 to 66");
-		goto obsolete_option;
-	}
-
-bad_option:
-	printk(" -- BAD OPTION\n");
-	return 1;
-obsolete_option:
-	printk(" -- OBSOLETE OPTION, WILL BE REMOVED SOON!\n");
-	return 1;
-}
-
-EXPORT_SYMBOL(ide_lock);
-
 static int ide_bus_match(struct device *dev, struct device_driver *drv)
 {
 	return 1;
@@ -1281,11 +1008,6 @@ static int __init ide_init(void)
 	int ret;
 
 	printk(KERN_INFO "Uniform Multi-Platform E-IDE driver\n");
-	system_bus_speed = ide_system_bus_speed();
-
-	printk(KERN_INFO "ide: Assuming %dMHz system bus speed "
-			 "for PIO modes%s\n", system_bus_speed,
-			idebus_parameter ? "" : "; override with idebus=xx");
 
 	ret = bus_register(&ide_bus_type);
 	if (ret < 0) {
@@ -1311,32 +1033,7 @@ out_port_class:
 	return ret;
 }
 
-#ifdef MODULE
-static char *options = NULL;
-module_param(options, charp, 0);
-MODULE_LICENSE("GPL");
-
-static void __init parse_options (char *line)
-{
-	char *next = line;
-
-	if (line == NULL || !*line)
-		return;
-	while ((line = next) != NULL) {
- 		if ((next = strchr(line,' ')) != NULL)
-			*next++ = 0;
-		if (!ide_setup(line))
-			printk (KERN_INFO "Unknown option '%s'\n", line);
-	}
-}
-
-int __init init_module (void)
-{
-	parse_options(options);
-	return ide_init();
-}
-
-void __exit cleanup_module (void)
+static void __exit ide_exit(void)
 {
 	proc_ide_destroy();
 
@@ -1345,10 +1042,7 @@ void __exit cleanup_module (void)
 	bus_unregister(&ide_bus_type);
 }
 
-#else /* !MODULE */
-
-__setup("", ide_setup);
-
 module_init(ide_init);
+module_exit(ide_exit);
 
-#endif /* MODULE */
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index 90c65cf..052125f 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -116,7 +116,7 @@ static void ali14xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	int time1, time2;
 	u8 param1, param2, param3, param4;
 	unsigned long flags;
-	int bus_speed = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
+	int bus_speed = ide_vlb_clk ? ide_vlb_clk : 50;
 
 	/* calculate timing, according to PIO mode */
 	time1 = ide_pio_cycle_time(drive, pio);
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index fed7d81..b789416 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -64,9 +64,7 @@
 #define GAYLE_HAS_CONTROL_REG	(!ide_doubler)
 #define GAYLE_IDEREG_SIZE	(ide_doubler ? 0x1000 : 0x2000)
 
-int ide_doubler = 0;	/* support IDE doublers? */
-EXPORT_SYMBOL_GPL(ide_doubler);
-
+static int ide_doubler;
 module_param_named(doubler, ide_doubler, bool, 0);
 MODULE_PARM_DESC(doubler, "enable support for IDE doublers");
 #endif /* CONFIG_BLK_DEV_IDEDOUBLER */
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index 4fe516d..dd6dfb3 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -212,7 +212,7 @@ static u8 ht_pio2timings(ide_drive_t *drive, const u8 pio)
 {
 	int active_time, recovery_time;
 	int active_cycles, recovery_cycles;
-	int bus_speed = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
+	int bus_speed = ide_vlb_clk ? ide_vlb_clk : 50;
 
         if (pio) {
 		unsigned int cycle_time;
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index 6424af1..51dba82 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -110,7 +110,7 @@ static void qd65xx_select(ide_drive_t *drive)
 
 static u8 qd6500_compute_timing (ide_hwif_t *hwif, int active_time, int recovery_time)
 {
-	int clk = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
+	int clk = ide_vlb_clk ? ide_vlb_clk : 50;
 	u8 act_cyc, rec_cyc;
 
 	if (clk <= 33) {
@@ -132,7 +132,7 @@ static u8 qd6500_compute_timing (ide_hwif_t *hwif, int active_time, int recovery
 
 static u8 qd6580_compute_timing (int active_time, int recovery_time)
 {
-	int clk = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
+	int clk = ide_vlb_clk ? ide_vlb_clk : 50;
 	u8 act_cyc, rec_cyc;
 
 	act_cyc = 17 - IDE_IN(active_time   * clk / 1000 + 1, 2, 17);
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index 7f46c22..ae7a432 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -140,7 +140,7 @@ static void aec_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const char *name)
 {
-	int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
+	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 
 	if (bus_speed <= 33)
 		pci_set_drvdata(dev, (void *) aec6xxx_33_base);
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index f2129d5..f2de00a 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -72,7 +72,7 @@ static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	int s_time, a_time, c_time;
 	u8 s_clc, a_clc, r_clc;
 	unsigned long flags;
-	int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
+	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 	int port = hwif->channel ? 0x5c : 0x58;
 	int portFIFO = hwif->channel ? 0x55 : 0x54;
 	u8 cd_dma_fifo = 0;
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index efcf543..ad22220 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -53,20 +53,20 @@ static void amd_set_speed(struct pci_dev *dev, u8 dn, u8 udma_mask,
 	u8 t = 0, offset = amd_offset(dev);
 
 	pci_read_config_byte(dev, AMD_ADDRESS_SETUP + offset, &t);
-	t = (t & ~(3 << ((3 - dn) << 1))) | ((FIT(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
+	t = (t & ~(3 << ((3 - dn) << 1))) | ((clamp_val(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
 	pci_write_config_byte(dev, AMD_ADDRESS_SETUP + offset, t);
 
 	pci_write_config_byte(dev, AMD_8BIT_TIMING + offset + (1 - (dn >> 1)),
-		((FIT(timing->act8b, 1, 16) - 1) << 4) | (FIT(timing->rec8b, 1, 16) - 1));
+		((clamp_val(timing->act8b, 1, 16) - 1) << 4) | (clamp_val(timing->rec8b, 1, 16) - 1));
 
 	pci_write_config_byte(dev, AMD_DRIVE_TIMING + offset + (3 - dn),
-		((FIT(timing->active, 1, 16) - 1) << 4) | (FIT(timing->recover, 1, 16) - 1));
+		((clamp_val(timing->active, 1, 16) - 1) << 4) | (clamp_val(timing->recover, 1, 16) - 1));
 
 	switch (udma_mask) {
-	case ATA_UDMA2: t = timing->udma ? (0xc0 | (FIT(timing->udma, 2, 5) - 2)) : 0x03; break;
-	case ATA_UDMA4: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 2, 10)]) : 0x03; break;
-	case ATA_UDMA5: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 1, 10)]) : 0x03; break;
-	case ATA_UDMA6: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 1, 15)]) : 0x03; break;
+	case ATA_UDMA2: t = timing->udma ? (0xc0 | (clamp_val(timing->udma, 2, 5) - 2)) : 0x03; break;
+	case ATA_UDMA4: t = timing->udma ? (0xc0 | amd_cyc2udma[clamp_val(timing->udma, 2, 10)]) : 0x03; break;
+	case ATA_UDMA5: t = timing->udma ? (0xc0 | amd_cyc2udma[clamp_val(timing->udma, 1, 10)]) : 0x03; break;
+	case ATA_UDMA6: t = timing->udma ? (0xc0 | amd_cyc2udma[clamp_val(timing->udma, 1, 15)]) : 0x03; break;
 	default: return;
 	}
 
@@ -179,7 +179,7 @@ static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev,
  * Determine the system bus clock.
  */
 
-	amd_clock = (ide_pci_clk ? ide_pci_clk : system_bus_clock()) * 1000;
+	amd_clock = (ide_pci_clk ? ide_pci_clk : 33) * 1000;
 
 	switch (amd_clock) {
 		case 33000: amd_clock = 33333; break;
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index b38a198..cd1ba14 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -525,12 +525,10 @@ static void cmd640_set_mode(ide_drive_t *drive, unsigned int index,
 	u8 setup_count, active_count, recovery_count, recovery_count2, cycle_count;
 	int bus_speed;
 
-	if (cmd640_vlb && ide_vlb_clk)
-		bus_speed = ide_vlb_clk;
-	else if (!cmd640_vlb && ide_pci_clk)
-		bus_speed = ide_pci_clk;
+	if (cmd640_vlb)
+		bus_speed = ide_vlb_clk ? ide_vlb_clk : 50;
 	else
-		bus_speed = system_bus_clock();
+		bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 
 	if (pio_mode > 5)
 		pio_mode = 5;
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 0867471..ca4774a 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -69,7 +69,7 @@ static u8 quantize_timing(int timing, int quant)
 static void program_cycle_times (ide_drive_t *drive, int cycle_time, int active_time)
 {
 	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
-	int clock_time = 1000 / (ide_pci_clk ? ide_pci_clk : system_bus_clock());
+	int clock_time = 1000 / (ide_pci_clk ? ide_pci_clk : 33);
 	u8  cycle_count, active_count, recovery_count, drwtim;
 	static const u8 recovery_values[] =
 		{15, 15, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0};
@@ -128,7 +128,7 @@ static void cmd64x_tune_pio(ide_drive_t *drive, const u8 pio)
 			    ide_pio_timings[pio].active_time);
 
 	setup_count = quantize_timing(ide_pio_timings[pio].setup_time,
-			1000 / (ide_pci_clk ? ide_pci_clk : system_bus_clock()));
+			1000 / (ide_pci_clk ? ide_pci_clk : 33));
 
 	/*
 	 * The primary channel has individual address setup timing registers
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index 77cc22c..8c534af 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -134,7 +134,7 @@ static int calc_clk(int time, int bus_speed)
 static void compute_clocks(u8 pio, pio_clocks_t *p_pclk)
 {
 	int clk1, clk2;
-	int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
+	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 
 	/* we don't check against CY82C693's min and max speed,
 	 * so you can play with the idebus=xx parameter
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index c929dad..397c6cb 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -759,8 +759,7 @@ static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 				enable_irq (hwif->irq);
 		}
 	} else
-		outb(mask ? (drive->ctl | 2) : (drive->ctl & ~2),
-		     hwif->io_ports.ctl_addr);
+		outb(ATA_DEVCTL_OBS | (mask ? 2 : 0), hwif->io_ports.ctl_addr);
 }
 
 /*
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index a7a41bb..45ba71a 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -76,7 +76,7 @@ static void superio_tf_read(ide_drive_t *drive, ide_task_t *task)
 	}
 
 	/* be sure we're looking at the low order bits */
-	outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+	outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = inb(io_ports->nsect_addr);
@@ -90,7 +90,7 @@ static void superio_tf_read(ide_drive_t *drive, ide_task_t *task)
 		tf->device = superio_ide_inb(io_ports->device_addr);
 
 	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		outb(drive->ctl | 0x80, io_ports->ctl_addr);
+		outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = inb(io_ports->feature_addr);
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 910fb00..1584ebb 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -148,11 +148,8 @@ static void scc_ide_outb(u8 addr, unsigned long port)
 	out_be32((void*)port, addr);
 }
 
-static void
-scc_ide_outbsync(ide_drive_t * drive, u8 addr, unsigned long port)
+static void scc_ide_outbsync(ide_hwif_t *hwif, u8 addr, unsigned long port)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-
 	out_be32((void*)port, addr);
 	eieio();
 	in_be32((void*)(hwif->dma_base + 0x01c));
@@ -662,8 +659,6 @@ static void scc_tf_load(ide_drive_t *drive, ide_task_t *task)
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	ide_set_irq(drive, 1);
-
 	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
 		out_be32((void *)io_ports->data_addr,
 			 (tf->hob_data << 8) | tf->data);
@@ -708,7 +703,7 @@ static void scc_tf_read(ide_drive_t *drive, ide_task_t *task)
 	}
 
 	/* be sure we're looking at the low order bits */
-	scc_ide_outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+	scc_ide_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = scc_ide_inb(io_ports->nsect_addr);
@@ -722,7 +717,7 @@ static void scc_tf_read(ide_drive_t *drive, ide_task_t *task)
 		tf->device = scc_ide_inb(io_ports->device_addr);
 
 	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		scc_ide_outb(drive->ctl | 0x80, io_ports->ctl_addr);
+		scc_ide_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = scc_ide_inb(io_ports->feature_addr);
@@ -795,7 +790,6 @@ static void __devinit init_mmio_iops_scc(ide_hwif_t *hwif)
 
 	hwif->dma_base = dma_base;
 	hwif->config_data = ports->ctl;
-	hwif->mmio = 1;
 }
 
 /**
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 16a0bce..24513e3 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -111,7 +111,7 @@ sgiioc4_init_hwif_ports(hw_regs_t * hw, unsigned long data_port,
 static void
 sgiioc4_maskproc(ide_drive_t * drive, int mask)
 {
-	writeb(mask ? (drive->ctl | 2) : (drive->ctl & ~2),
+	writeb(ATA_DEVCTL_OBS | (mask ? 2 : 0),
 	       (void __iomem *)drive->hwif->io_ports.ctl_addr);
 }
 
@@ -369,8 +369,7 @@ ide_dma_sgiioc4(ide_hwif_t *hwif, const struct ide_port_info *d)
 	hwif->sg_max_nents = IOC4_PRD_ENTRIES;
 
 	pad = pci_alloc_consistent(dev, IOC4_IDE_CACHELINE_SIZE,
-				   (dma_addr_t *) &(hwif->dma_status));
-
+				   (dma_addr_t *)&hwif->extra_base);
 	if (pad) {
 		ide_set_hwifdata(hwif, pad);
 		return 0;
@@ -439,7 +438,7 @@ sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 
 	/* Address of the Ending DMA */
 	memset(ide_get_hwifdata(hwif), 0, IOC4_IDE_CACHELINE_SIZE);
-	ending_dma_addr = cpu_to_le32(hwif->dma_status);
+	ending_dma_addr = cpu_to_le32(hwif->extra_base);
 	writel(ending_dma_addr, (void __iomem *)(dma_base + IOC4_DMA_END_ADDR * 4));
 
 	writel(dma_direction, (void __iomem *)ioc4_dma_addr);
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 0006b9e..b75e9bb 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -94,7 +94,7 @@ static unsigned long siimage_selreg(ide_hwif_t *hwif, int r)
 	unsigned long base = (unsigned long)hwif->hwif_data;
 
 	base += 0xA0 + r;
-	if (hwif->mmio)
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
 		base += hwif->channel << 6;
 	else
 		base += hwif->channel << 4;
@@ -117,7 +117,7 @@ static inline unsigned long siimage_seldev(ide_drive_t *drive, int r)
 	unsigned long base	= (unsigned long)hwif->hwif_data;
 
 	base += 0xA0 + r;
-	if (hwif->mmio)
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
 		base += hwif->channel << 6;
 	else
 		base += hwif->channel << 4;
@@ -190,7 +190,9 @@ static u8 sil_pata_udma_filter(ide_drive_t *drive)
 	unsigned long base	= (unsigned long)hwif->hwif_data;
 	u8 scsc, mask		= 0;
 
-	scsc = sil_ioread8(dev, base + (hwif->mmio ? 0x4A : 0x8A));
+	base += (hwif->host_flags & IDE_HFLAG_MMIO) ? 0x4A : 0x8A;
+
+	scsc = sil_ioread8(dev, base);
 
 	switch (scsc & 0x30) {
 	case 0x10:	/* 133 */
@@ -238,8 +240,9 @@ static void sil_set_pio_mode(ide_drive_t *drive, u8 pio)
 	unsigned long tfaddr	= siimage_selreg(hwif,	0x02);
 	unsigned long base	= (unsigned long)hwif->hwif_data;
 	u8 tf_pio		= pio;
-	u8 addr_mask		= hwif->channel ? (hwif->mmio ? 0xF4 : 0x84)
-						: (hwif->mmio ? 0xB4 : 0x80);
+	u8 mmio			= (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+	u8 addr_mask		= hwif->channel ? (mmio ? 0xF4 : 0x84)
+						: (mmio ? 0xB4 : 0x80);
 	u8 mode			= 0;
 	u8 unit			= drive->select.b.unit;
 
@@ -290,13 +293,13 @@ static void sil_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	u16 ultra = 0, multi	= 0;
 	u8 mode = 0, unit	= drive->select.b.unit;
 	unsigned long base	= (unsigned long)hwif->hwif_data;
-	u8 scsc = 0, addr_mask	= hwif->channel ?
-					(hwif->mmio ? 0xF4 : 0x84) :
-					(hwif->mmio ? 0xB4 : 0x80);
+	u8 mmio			= (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+	u8 scsc = 0, addr_mask	= hwif->channel ? (mmio ? 0xF4 : 0x84)
+						: (mmio ? 0xB4 : 0x80);
 	unsigned long ma	= siimage_seldev(drive, 0x08);
 	unsigned long ua	= siimage_seldev(drive, 0x0C);
 
-	scsc  = sil_ioread8 (dev, base + (hwif->mmio ? 0x4A : 0x8A));
+	scsc  = sil_ioread8 (dev, base + (mmio ? 0x4A : 0x8A));
 	mode  = sil_ioread8 (dev, base + addr_mask);
 	multi = sil_ioread16(dev, ma);
 	ultra = sil_ioread16(dev, ua);
@@ -391,7 +394,7 @@ static int siimage_mmio_dma_test_irq(ide_drive_t *drive)
 
 static int siimage_dma_test_irq(ide_drive_t *drive)
 {
-	if (drive->hwif->mmio)
+	if (drive->hwif->host_flags & IDE_HFLAG_MMIO)
 		return siimage_mmio_dma_test_irq(drive);
 	else
 		return siimage_io_dma_test_irq(drive);
@@ -640,8 +643,6 @@ static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 	hwif->irq = dev->irq;
 
 	hwif->dma_base = (unsigned long)addr + (ch ? 0x08 : 0x00);
-
-	hwif->mmio = 1;
 }
 
 static int is_dev_seagate_sata(ide_drive_t *drive)
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index 566e0ec..3ed9728 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -120,21 +120,21 @@ static void via_set_speed(ide_hwif_t *hwif, u8 dn, struct ide_timing *timing)
 
 	if (~vdev->via_config->flags & VIA_BAD_AST) {
 		pci_read_config_byte(dev, VIA_ADDRESS_SETUP, &t);
-		t = (t & ~(3 << ((3 - dn) << 1))) | ((FIT(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
+		t = (t & ~(3 << ((3 - dn) << 1))) | ((clamp_val(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
 		pci_write_config_byte(dev, VIA_ADDRESS_SETUP, t);
 	}
 
 	pci_write_config_byte(dev, VIA_8BIT_TIMING + (1 - (dn >> 1)),
-		((FIT(timing->act8b, 1, 16) - 1) << 4) | (FIT(timing->rec8b, 1, 16) - 1));
+		((clamp_val(timing->act8b, 1, 16) - 1) << 4) | (clamp_val(timing->rec8b, 1, 16) - 1));
 
 	pci_write_config_byte(dev, VIA_DRIVE_TIMING + (3 - dn),
-		((FIT(timing->active, 1, 16) - 1) << 4) | (FIT(timing->recover, 1, 16) - 1));
+		((clamp_val(timing->active, 1, 16) - 1) << 4) | (clamp_val(timing->recover, 1, 16) - 1));
 
 	switch (vdev->via_config->udma_mask) {
-	case ATA_UDMA2: t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 5) - 2)) : 0x03; break;
-	case ATA_UDMA4: t = timing->udma ? (0xe8 | (FIT(timing->udma, 2, 9) - 2)) : 0x0f; break;
-	case ATA_UDMA5: t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 9) - 2)) : 0x07; break;
-	case ATA_UDMA6: t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 9) - 2)) : 0x07; break;
+	case ATA_UDMA2: t = timing->udma ? (0xe0 | (clamp_val(timing->udma, 2, 5) - 2)) : 0x03; break;
+	case ATA_UDMA4: t = timing->udma ? (0xe8 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x0f; break;
+	case ATA_UDMA5: t = timing->udma ? (0xe0 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x07; break;
+	case ATA_UDMA6: t = timing->udma ? (0xe0 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x07; break;
 	default: return;
 	}
 
@@ -340,7 +340,7 @@ static unsigned int __devinit init_chipset_via82cxxx(struct pci_dev *dev, const
 	 * Determine system bus clock.
 	 */
 
-	via_clock = (ide_pci_clk ? ide_pci_clk : system_bus_clock()) * 1000;
+	via_clock = (ide_pci_clk ? ide_pci_clk : 33) * 1000;
 
 	switch (via_clock) {
 		case 33000: via_clock = 33333; break;
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index ba2d587..dcb2c46 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -480,13 +480,13 @@ pmac_ide_do_update_timings(ide_drive_t *drive)
 		pmac_ide_selectproc(drive);
 }
 
-static void
-pmac_outbsync(ide_drive_t *drive, u8 value, unsigned long port)
+static void pmac_outbsync(ide_hwif_t *hwif, u8 value, unsigned long port)
 {
 	u32 tmp;
 	
 	writeb(value, (void __iomem *) port);
-	tmp = readl(PMAC_IDE_REG(IDE_TIMING_CONFIG));
+	tmp = readl((void __iomem *)(hwif->io_ports.data_addr
+				     + IDE_TIMING_CONFIG));
 }
 
 /*
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 5171601..abcfb17 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -87,7 +87,7 @@ unsigned long ide_pci_dma_base(ide_hwif_t *hwif, const struct ide_port_info *d)
 	unsigned long dma_base = 0;
 	u8 dma_stat = 0;
 
-	if (hwif->mmio)
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
 		return hwif->dma_base;
 
 	if (hwif->mate && hwif->mate->dma_base) {
@@ -374,7 +374,7 @@ int ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 		if (base == 0 || ide_pci_set_master(dev, d->name) < 0)
 			return -1;
 
-		if (hwif->mmio)
+		if (hwif->host_flags & IDE_HFLAG_MMIO)
 			printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
 		else
 			printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 44d8d51..683bce3 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -60,6 +60,13 @@
 
 #define IDESCSI_DEBUG_LOG		0
 
+#if IDESCSI_DEBUG_LOG
+#define debug_log(fmt, args...) \
+	printk(KERN_INFO "ide-scsi: " fmt, ## args)
+#else
+#define debug_log(fmt, args...) do {} while (0)
+#endif
+
 /*
  *	SCSI command transformation layer
  */
@@ -129,14 +136,15 @@ static inline idescsi_scsi_t *drive_to_idescsi(ide_drive_t *ide_drive)
 #define IDESCSI_PC_RQ			90
 
 /*
- *	PIO data transfer routines using the scatter gather table.
+ *	PIO data transfer routine using the scatter gather table.
  */
-static void idescsi_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-		unsigned int bcount)
+static void ide_scsi_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+				unsigned int bcount, int write)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	int count;
+	xfer_func_t *xf = write ? hwif->output_data : hwif->input_data;
 	char *buf;
+	int count;
 
 	while (bcount) {
 		count = min(pc->sg->length - pc->b_count, bcount);
@@ -145,13 +153,13 @@ static void idescsi_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 
 			local_irq_save(flags);
 			buf = kmap_atomic(sg_page(pc->sg), KM_IRQ0) +
-					pc->sg->offset;
-			hwif->input_data(drive, NULL, buf + pc->b_count, count);
+					  pc->sg->offset;
+			xf(drive, NULL, buf + pc->b_count, count);
 			kunmap_atomic(buf - pc->sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
 		} else {
 			buf = sg_virt(pc->sg);
-			hwif->input_data(drive, NULL, buf + pc->b_count, count);
+			xf(drive, NULL, buf + pc->b_count, count);
 		}
 		bcount -= count; pc->b_count += count;
 		if (pc->b_count == pc->sg->length) {
@@ -163,51 +171,34 @@ static void idescsi_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	}
 
 	if (bcount) {
-		printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
-		ide_pad_transfer(drive, 0, bcount);
+		printk(KERN_ERR "%s: scatter gather table too small, %s\n",
+				drive->name, write ? "padding with zeros"
+						   : "discarding data");
+		ide_pad_transfer(drive, write, bcount);
 	}
 }
 
-static void idescsi_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-		unsigned int bcount)
+static void ide_scsi_hex_dump(u8 *data, int len)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	int count;
-	char *buf;
+	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, data, len, 0);
+}
 
-	while (bcount) {
-		count = min(pc->sg->length - pc->b_count, bcount);
-		if (PageHighMem(sg_page(pc->sg))) {
-			unsigned long flags;
+static int idescsi_end_request(ide_drive_t *, int, int);
 
-			local_irq_save(flags);
-			buf = kmap_atomic(sg_page(pc->sg), KM_IRQ0) +
-						pc->sg->offset;
-			hwif->output_data(drive, NULL, buf + pc->b_count, count);
-			kunmap_atomic(buf - pc->sg->offset, KM_IRQ0);
-			local_irq_restore(flags);
-		} else {
-			buf = sg_virt(pc->sg);
-			hwif->output_data(drive, NULL, buf + pc->b_count, count);
-		}
-		bcount -= count; pc->b_count += count;
-		if (pc->b_count == pc->sg->length) {
-			if (!--pc->sg_cnt)
-				break;
-			pc->sg = sg_next(pc->sg);
-			pc->b_count = 0;
-		}
-	}
+static void ide_scsi_callback(ide_drive_t *drive)
+{
+	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
+	struct ide_atapi_pc *pc = scsi->pc;
 
-	if (bcount) {
-		printk (KERN_ERR "ide-scsi: scatter gather table too small, padding with zeros\n");
-		ide_pad_transfer(drive, 1, bcount);
-	}
-}
+	if (pc->flags & PC_FLAG_TIMEDOUT)
+		debug_log("%s: got timed out packet %lu at %lu\n", __func__,
+			  pc->scsi_cmd->serial_number, jiffies);
+		/* end this request now - scsi should retry it*/
+	else if (test_bit(IDESCSI_LOG_CMD, &scsi->log))
+		printk(KERN_INFO "Packet command completed, %d bytes"
+				 " transferred\n", pc->xferred);
 
-static void ide_scsi_hex_dump(u8 *data, int len)
-{
-	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, data, len, 0);
+	idescsi_end_request(drive, 1, 0);
 }
 
 static int idescsi_check_condition(ide_drive_t *drive,
@@ -228,14 +219,16 @@ static int idescsi_check_condition(ide_drive_t *drive,
 		kfree(pc);
 		return -ENOMEM;
 	}
-	ide_init_drive_cmd(rq);
+	blk_rq_init(NULL, rq);
 	rq->special = (char *) pc;
 	pc->rq = rq;
 	pc->buf = buf;
 	pc->c[0] = REQUEST_SENSE;
 	pc->c[4] = pc->req_xfer = pc->buf_size = SCSI_SENSE_BUFFERSIZE;
 	rq->cmd_type = REQ_TYPE_SENSE;
+	rq->cmd_flags |= REQ_PREEMPT;
 	pc->timeout = jiffies + WAIT_READY;
+	pc->callback = ide_scsi_callback;
 	/* NOTE! Save the failed packet command in "rq->buffer" */
 	rq->buffer = (void *) failed_cmd->special;
 	pc->scsi_cmd = ((struct ide_atapi_pc *) failed_cmd->special)->scsi_cmd;
@@ -244,11 +237,10 @@ static int idescsi_check_condition(ide_drive_t *drive,
 		ide_scsi_hex_dump(pc->c, 6);
 	}
 	rq->rq_disk = scsi->disk;
-	return ide_do_drive_cmd(drive, rq, ide_preempt);
+	ide_do_drive_cmd(drive, rq);
+	return 0;
 }
 
-static int idescsi_end_request(ide_drive_t *, int, int);
-
 static ide_startstop_t
 idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 {
@@ -256,7 +248,7 @@ idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTBSYNC(drive, WIN_IDLEIMMEDIATE,
+		hwif->OUTBSYNC(hwif, WIN_IDLEIMMEDIATE,
 			       hwif->io_ports.command_addr);
 
 	rq->errors++;
@@ -269,10 +261,9 @@ idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 static ide_startstop_t
 idescsi_atapi_abort(ide_drive_t *drive, struct request *rq)
 {
-#if IDESCSI_DEBUG_LOG
-	printk(KERN_WARNING "idescsi_atapi_abort called for %lu\n",
+	debug_log("%s called for %lu\n", __func__,
 		((struct ide_atapi_pc *) rq->special)->scsi_cmd->serial_number);
-#endif
+
 	rq->errors |= ERROR_MAX;
 
 	idescsi_end_request(drive, 0, 0);
@@ -351,9 +342,9 @@ static int idescsi_expiry(ide_drive_t *drive)
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	struct ide_atapi_pc   *pc   = scsi->pc;
 
-#if IDESCSI_DEBUG_LOG
-	printk(KERN_WARNING "idescsi_expiry called for %lu at %lu\n", pc->scsi_cmd->serial_number, jiffies);
-#endif
+	debug_log("%s called for %lu at %lu\n", __func__,
+		  pc->scsi_cmd->serial_number, jiffies);
+
 	pc->flags |= PC_FLAG_TIMEDOUT;
 
 	return 0;					/* we do not want the ide subsystem to retry */
@@ -365,141 +356,19 @@ static int idescsi_expiry(ide_drive_t *drive)
 static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	ide_hwif_t *hwif = drive->hwif;
 	struct ide_atapi_pc *pc = scsi->pc;
-	struct request *rq = pc->rq;
-	unsigned int temp;
-	u16 bcount;
-	u8 stat, ireason;
-
-#if IDESCSI_DEBUG_LOG
-	printk (KERN_INFO "ide-scsi: Reached idescsi_pc_intr interrupt handler\n");
-#endif /* IDESCSI_DEBUG_LOG */
-
-	if (pc->flags & PC_FLAG_TIMEDOUT) {
-#if IDESCSI_DEBUG_LOG
-		printk(KERN_WARNING "idescsi_pc_intr: got timed out packet  %lu at %lu\n",
-				pc->scsi_cmd->serial_number, jiffies);
-#endif
-		/* end this request now - scsi should retry it*/
-		idescsi_end_request (drive, 1, 0);
-		return ide_stopped;
-	}
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-#if IDESCSI_DEBUG_LOG
-		printk ("ide-scsi: %s: DMA complete\n", drive->name);
-#endif /* IDESCSI_DEBUG_LOG */
-		pc->xferred = pc->req_xfer;
-		(void)hwif->dma_ops->dma_end(drive);
-	}
-
-	/* Clear the interrupt */
-	stat = ide_read_status(drive);
-
-	if ((stat & DRQ_STAT) == 0) {
-		/* No more interrupts */
-		if (test_bit(IDESCSI_LOG_CMD, &scsi->log))
-			printk(KERN_INFO "Packet command completed, %d bytes"
-					" transferred\n", pc->xferred);
-		local_irq_enable_in_hardirq();
-		if (stat & ERR_STAT)
-			rq->errors++;
-		idescsi_end_request (drive, 1, 0);
-		return ide_stopped;
-	}
-	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
-		  hwif->INB(hwif->io_ports.lbam_addr);
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
-
-	if (ireason & CD) {
-		printk(KERN_ERR "ide-scsi: CoD != 0 in idescsi_pc_intr\n");
-		return ide_do_reset (drive);
-	}
-	if (ireason & IO) {
-		temp = pc->xferred + bcount;
-		if (temp > pc->req_xfer) {
-			if (temp > pc->buf_size) {
-				printk(KERN_ERR "ide-scsi: The scsi wants to "
-					"send us more data than expected "
-					"- discarding data\n");
-				temp = pc->buf_size - pc->xferred;
-				if (temp) {
-					pc->flags &= ~PC_FLAG_WRITING;
-					if (pc->sg)
-						idescsi_input_buffers(drive, pc,
-									temp);
-					else
-						hwif->input_data(drive, NULL,
-							pc->cur_pos, temp);
-					printk(KERN_ERR "ide-scsi: transferred"
-							" %d of %d bytes\n",
-							temp, bcount);
-				}
-				pc->xferred += temp;
-				pc->cur_pos += temp;
-				ide_pad_transfer(drive, 0, bcount - temp);
-				ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
-				return ide_started;
-			}
-#if IDESCSI_DEBUG_LOG
-			printk (KERN_NOTICE "ide-scsi: The scsi wants to send us more data than expected - allowing transfer\n");
-#endif /* IDESCSI_DEBUG_LOG */
-		}
-	}
-	if (ireason & IO) {
-		pc->flags &= ~PC_FLAG_WRITING;
-		if (pc->sg)
-			idescsi_input_buffers(drive, pc, bcount);
-		else
-			hwif->input_data(drive, NULL, pc->cur_pos, bcount);
-	} else {
-		pc->flags |= PC_FLAG_WRITING;
-		if (pc->sg)
-			idescsi_output_buffers(drive, pc, bcount);
-		else
-			hwif->output_data(drive, NULL, pc->cur_pos, bcount);
-	}
-	/* Update the current position */
-	pc->xferred += bcount;
-	pc->cur_pos += bcount;
 
-	/* And set the interrupt handler again */
-	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
-	return ide_started;
+	return ide_pc_intr(drive, pc, idescsi_pc_intr, get_timeout(pc),
+			   idescsi_expiry, NULL, NULL, NULL,
+			   ide_scsi_io_buffers);
 }
 
 static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	struct ide_atapi_pc *pc = scsi->pc;
-	ide_startstop_t startstop;
-	u8 ireason;
 
-	if (ide_wait_stat(&startstop,drive,DRQ_STAT,BUSY_STAT,WAIT_READY)) {
-		printk(KERN_ERR "ide-scsi: Strange, packet command "
-			"initiated yet DRQ isn't asserted\n");
-		return startstop;
-	}
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
-	if ((ireason & CD) == 0 || (ireason & IO)) {
-		printk(KERN_ERR "ide-scsi: (IO,CoD) != (0,1) while "
-				"issuing a packet command\n");
-		return ide_do_reset (drive);
-	}
-	BUG_ON(HWGROUP(drive)->handler != NULL);
-	/* Set the interrupt routine */
-	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
-
-	/* Send the actual packet */
-	hwif->output_data(drive, NULL, scsi->pc->c, 12);
-
-	if (pc->flags & PC_FLAG_DMA_OK) {
-		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
-		hwif->dma_ops->dma_start(drive);
-	}
-	return ide_started;
+	return ide_transfer_pc(drive, scsi->pc, idescsi_pc_intr,
+			       get_timeout(scsi->pc), idescsi_expiry);
 }
 
 static inline int idescsi_set_direction(struct ide_atapi_pc *pc)
@@ -545,38 +414,12 @@ static ide_startstop_t idescsi_issue_pc(ide_drive_t *drive,
 		struct ide_atapi_pc *pc)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	ide_hwif_t *hwif = drive->hwif;
-	u16 bcount;
-	u8 dma = 0;
 
 	/* Set the current packet command */
 	scsi->pc = pc;
-	/* We haven't transferred any data yet */
-	pc->xferred = 0;
-	pc->cur_pos = pc->buf;
-	/* Request to transfer the entire buffer at once */
-	bcount = min(pc->req_xfer, 63 * 1024);
-
-	if (drive->using_dma && !idescsi_map_sg(drive, pc)) {
-		hwif->sg_mapped = 1;
-		dma = !hwif->dma_ops->dma_setup(drive);
-		hwif->sg_mapped = 0;
-	}
-
-	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK, bcount, dma);
 
-	if (dma)
-		pc->flags |= PC_FLAG_DMA_OK;
-
-	if (test_bit(IDESCSI_DRQ_INTERRUPT, &scsi->flags)) {
-		ide_execute_command(drive, WIN_PACKETCMD, &idescsi_transfer_pc,
-				    get_timeout(pc), idescsi_expiry);
-		return ide_started;
-	} else {
-		/* Issue the packet command */
-		ide_execute_pkt_cmd(drive);
-		return idescsi_transfer_pc(drive);
-	}
+	return ide_issue_pc(drive, pc, idescsi_transfer_pc,
+			    get_timeout(pc), idescsi_expiry);
 }
 
 /*
@@ -584,14 +427,22 @@ static ide_startstop_t idescsi_issue_pc(ide_drive_t *drive,
  */
 static ide_startstop_t idescsi_do_request (ide_drive_t *drive, struct request *rq, sector_t block)
 {
-#if IDESCSI_DEBUG_LOG
-	printk (KERN_INFO "dev: %s, cmd: %x, errors: %d\n", rq->rq_disk->disk_name,rq->cmd[0],rq->errors);
-	printk (KERN_INFO "sector: %ld, nr_sectors: %ld, current_nr_sectors: %d\n",rq->sector,rq->nr_sectors,rq->current_nr_sectors);
-#endif /* IDESCSI_DEBUG_LOG */
+	debug_log("dev: %s, cmd: %x, errors: %d\n", rq->rq_disk->disk_name,
+		  rq->cmd[0], rq->errors);
+	debug_log("sector: %ld, nr_sectors: %ld, current_nr_sectors: %d\n",
+		  rq->sector, rq->nr_sectors, rq->current_nr_sectors);
 
 	if (blk_sense_request(rq) || blk_special_request(rq)) {
-		return idescsi_issue_pc(drive,
-				(struct ide_atapi_pc *) rq->special);
+		struct ide_atapi_pc *pc = (struct ide_atapi_pc *)rq->special;
+		idescsi_scsi_t *scsi = drive_to_idescsi(drive);
+
+		if (test_bit(IDESCSI_DRQ_INTERRUPT, &scsi->flags))
+			pc->flags |= PC_FLAG_DRQ_INTERRUPT;
+
+		if (drive->using_dma && !idescsi_map_sg(drive, pc))
+			pc->flags |= PC_FLAG_DMA_OK;
+
+		return idescsi_issue_pc(drive, pc);
 	}
 	blk_dump_rq_flags(rq, "ide-scsi: unsup command");
 	idescsi_end_request (drive, 0, 0);
@@ -646,6 +497,8 @@ static void ide_scsi_remove(ide_drive_t *drive)
 	put_disk(g);
 
 	ide_scsi_put(scsi);
+
+	drive->scsi = 0;
 }
 
 static int ide_scsi_probe(ide_drive_t *);
@@ -765,6 +618,8 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 
 	memset (pc->c, 0, 12);
 	pc->flags = 0;
+	if (cmd->sc_data_direction == DMA_TO_DEVICE)
+		pc->flags |= PC_FLAG_WRITING;
 	pc->rq = rq;
 	memcpy (pc->c, cmd->cmnd, cmd->cmd_len);
 	pc->buf = NULL;
@@ -775,6 +630,7 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	pc->scsi_cmd = cmd;
 	pc->done = done;
 	pc->timeout = jiffies + cmd->timeout_per_command;
+	pc->callback = ide_scsi_callback;
 
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: que %lu, cmd = ", drive->name, cmd->serial_number);
@@ -785,12 +641,11 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 		}
 	}
 
-	ide_init_drive_cmd (rq);
+	blk_rq_init(NULL, rq);
 	rq->special = (char *) pc;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	spin_unlock_irq(host->host_lock);
-	rq->rq_disk = scsi->disk;
-	(void) ide_do_drive_cmd (drive, rq, ide_end);
+	blk_execute_rq_nowait(drive->queue, scsi->disk, rq, 0, NULL);
 	spin_lock_irq(host->host_lock);
 	return 0;
 abort:
@@ -985,6 +840,8 @@ static int ide_scsi_probe(ide_drive_t *drive)
 	    !(host = scsi_host_alloc(&idescsi_template,sizeof(idescsi_scsi_t))))
 		return -ENODEV;
 
+	drive->scsi = 1;
+
 	g = alloc_disk(1 << PARTN_BITS);
 	if (!g)
 		goto out_host_put;
@@ -993,10 +850,10 @@ static int ide_scsi_probe(ide_drive_t *drive)
 
 	host->max_id = 1;
 
-#if IDESCSI_DEBUG_LOG
 	if (drive->id->last_lun)
-		printk(KERN_NOTICE "%s: id->last_lun=%u\n", drive->name, drive->id->last_lun);
-#endif
+		debug_log("%s: id->last_lun=%u\n", drive->name,
+			  drive->id->last_lun);
+
 	if ((drive->id->last_lun & 0x7) != 7)
 		host->max_lun = (drive->id->last_lun & 0x7) + 1;
 	else
@@ -1025,6 +882,7 @@ static int ide_scsi_probe(ide_drive_t *drive)
 
 	put_disk(g);
 out_host_put:
+	drive->scsi = 0;
 	scsi_host_put(host);
 	return err;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d2a1b71..1171abd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -623,7 +623,6 @@ extern void generic_make_request(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);
 extern void __blk_put_request(struct request_queue *, struct request *);
-extern void blk_end_sync_rq(struct request *rq, int error);
 extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
 extern void blk_insert_request(struct request_queue *, struct request *, int, void *);
 extern void blk_requeue_request(struct request_queue *, struct request *);
diff --git a/include/linux/ide.h b/include/linux/ide.h
index eddb6da..ac4eeb2 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -364,7 +364,6 @@ typedef struct ide_drive_s {
         u8	wcache;		/* status of write cache */
 	u8	acoustic;	/* acoustic management */
 	u8	media;		/* disk, cdrom, tape, floppy, ... */
-	u8	ctl;		/* "normal" value for Control register */
 	u8	ready_stat;	/* min status value for drive ready */
 	u8	mult_count;	/* current multiple sector setting */
 	u8	mult_req;	/* requested multiple sector setting */
@@ -493,7 +492,7 @@ typedef struct hwif_s {
 	void (*ide_dma_clear_irq)(ide_drive_t *drive);
 
 	void (*OUTB)(u8 addr, unsigned long port);
-	void (*OUTBSYNC)(ide_drive_t *drive, u8 addr, unsigned long port);
+	void (*OUTBSYNC)(struct hwif_s *hwif, u8 addr, unsigned long port);
 
 	u8  (*INB)(unsigned long port);
 
@@ -532,7 +531,6 @@ typedef struct hwif_s {
 	unsigned	serialized : 1;	/* serialized all channel operation */
 	unsigned	sharing_irq: 1;	/* 1 = sharing irq with another hwif */
 	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
-	unsigned	mmio       : 1; /* host uses MMIO */
 
 	struct device		gendev;
 	struct device		*portdev;
@@ -604,12 +602,13 @@ enum {
 	PC_FLAG_SUPPRESS_ERROR		= (1 << 1),
 	PC_FLAG_WAIT_FOR_DSC		= (1 << 2),
 	PC_FLAG_DMA_OK			= (1 << 3),
-	PC_FLAG_DMA_RECOMMENDED		= (1 << 4),
-	PC_FLAG_DMA_IN_PROGRESS		= (1 << 5),
-	PC_FLAG_DMA_ERROR		= (1 << 6),
-	PC_FLAG_WRITING			= (1 << 7),
+	PC_FLAG_DMA_IN_PROGRESS		= (1 << 4),
+	PC_FLAG_DMA_ERROR		= (1 << 5),
+	PC_FLAG_WRITING			= (1 << 6),
 	/* command timed out */
-	PC_FLAG_TIMEDOUT		= (1 << 8),
+	PC_FLAG_TIMEDOUT		= (1 << 7),
+	PC_FLAG_ZIP_DRIVE		= (1 << 8),
+	PC_FLAG_DRQ_INTERRUPT		= (1 << 9),
 };
 
 struct ide_atapi_pc {
@@ -642,8 +641,8 @@ struct ide_atapi_pc {
 	 * to change/removal later.
 	 */
 	u8 pc_buf[256];
-	void (*idefloppy_callback) (ide_drive_t *);
-	ide_startstop_t (*idetape_callback) (ide_drive_t *);
+
+	void (*callback)(ide_drive_t *);
 
 	/* idetape only */
 	struct idetape_bh *bh;
@@ -813,10 +812,6 @@ int generic_ide_ioctl(ide_drive_t *, struct file *, struct block_device *, unsig
 #ifndef _IDE_C
 extern	ide_hwif_t	ide_hwifs[];		/* master data repository */
 #endif
-extern int ide_noacpi;
-extern int ide_acpigtf;
-extern int ide_acpionboot;
-extern int noautodma;
 
 extern int ide_vlb_clk;
 extern int ide_pci_clk;
@@ -857,25 +852,12 @@ int ide_wait_stat(ide_startstop_t *, ide_drive_t *, u8, u8, unsigned long);
 
 extern ide_startstop_t ide_do_reset (ide_drive_t *);
 
-extern void ide_init_drive_cmd (struct request *rq);
-
-/*
- * "action" parameter type for ide_do_drive_cmd() below.
- */
-typedef enum {
-	ide_wait,	/* insert rq at end of list, and wait for it */
-	ide_preempt,	/* insert rq in front of current request */
-	ide_head_wait,	/* insert rq in front of current request and wait for it */
-	ide_end		/* insert rq at end of list, but don't wait for it */
-} ide_action_t;
-
-extern int ide_do_drive_cmd(ide_drive_t *, struct request *, ide_action_t);
+extern void ide_do_drive_cmd(ide_drive_t *, struct request *);
 
 extern void ide_end_drive_cmd(ide_drive_t *, u8, u8);
 
 enum {
 	IDE_TFLAG_LBA48			= (1 << 0),
-	IDE_TFLAG_NO_SELECT_MASK	= (1 << 1),
 	IDE_TFLAG_FLAGGED		= (1 << 2),
 	IDE_TFLAG_OUT_DATA		= (1 << 3),
 	IDE_TFLAG_OUT_HOB_FEATURE	= (1 << 4),
@@ -980,11 +962,23 @@ typedef struct ide_task_s {
 void ide_tf_dump(const char *, struct ide_taskfile *);
 
 extern void SELECT_DRIVE(ide_drive_t *);
+void SELECT_MASK(ide_drive_t *, int);
 
 extern int drive_is_ready(ide_drive_t *);
 
 void ide_pktcmd_tf_load(ide_drive_t *, u32, u16, u8);
 
+ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
+	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
+	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
+	void (*retry_pc)(ide_drive_t *), void (*dsc_handle)(ide_drive_t *),
+	void (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned int,
+			   int));
+ide_startstop_t ide_transfer_pc(ide_drive_t *, struct ide_atapi_pc *,
+				ide_handler_t *, unsigned int, ide_expiry_t *);
+ide_startstop_t ide_issue_pc(ide_drive_t *, struct ide_atapi_pc *,
+			     ide_handler_t *, unsigned int, ide_expiry_t *);
+
 ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
 
 void task_end_request(ide_drive_t *, struct request *, u8);
@@ -996,8 +990,6 @@ int ide_taskfile_ioctl(ide_drive_t *, unsigned int, unsigned long);
 int ide_cmd_ioctl(ide_drive_t *, unsigned int, unsigned long);
 int ide_task_ioctl(ide_drive_t *, unsigned int, unsigned long);
 
-extern int system_bus_clock(void);
-
 extern int ide_driveid_update(ide_drive_t *);
 extern int ide_config_drive_speed(ide_drive_t *, u8);
 extern u8 eighty_ninty_three (ide_drive_t *);
@@ -1349,7 +1341,8 @@ static inline void ide_set_irq(ide_drive_t *drive, int on)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	hwif->OUTB(drive->ctl | (on ? 0 : 2), hwif->io_ports.ctl_addr);
+	hwif->OUTBSYNC(hwif, ATA_DEVCTL_OBS | (on ? 0 : 2),
+		       hwif->io_ports.ctl_addr);
 }
 
 static inline u8 ide_read_status(ide_drive_t *drive)
