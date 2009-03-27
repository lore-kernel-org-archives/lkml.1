Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZC0MBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZC0MBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbZC0MA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:00:57 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:37370 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZC0MAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:00:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=G3D6vahMXQf78NWkpE75H/0cHLB0FVaMgvEtXJzDmxwo4cFkJmkpt0a+iw7sdK9rKr
         IJVUsIGlDoOOktzJ6oiUosDXk0Bn+LjIKzmOuLQhasd4phyMiwRJrp511hkzFnEqvHFM
         +ckLdHC3VVnpl/gzEOaviihHoEa05PdEFgTtE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates part 2
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 27 Mar 2009 13:02:55 +0100
Message-Id: <200903271302.56379.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

More "uninteresting" IDE changes:

- make all host drivers use struct ide_port_info
- sanitize command/request completion API
- replace ide_task_t by struct ide_cmd
- improve debugging scheme (from Borislav Petkov)
- misc fixes/cleanups


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 arch/m68k/include/asm/ide.h |   73 -------
 drivers/ide/alim15x3.c      |    9 +-
 drivers/ide/at91_ide.c      |   70 ++++----
 drivers/ide/au1xxx-ide.c    |   39 +---
 drivers/ide/buddha.c        |   11 +-
 drivers/ide/cmd64x.c        |    6 +-
 drivers/ide/cs5536.c        |    2 +-
 drivers/ide/delkin_cb.c     |    1 +
 drivers/ide/dtc2278.c       |    3 +-
 drivers/ide/falconide.c     |   45 ++++-
 drivers/ide/gayle.c         |    7 +-
 drivers/ide/hpt366.c        |    6 +-
 drivers/ide/icside.c        |   24 +--
 drivers/ide/ide-4drives.c   |    3 +-
 drivers/ide/ide-acpi.c      |   10 +-
 drivers/ide/ide-atapi.c     |  123 +++++++-----
 drivers/ide/ide-cd.c        |  155 ++++++++-------
 drivers/ide/ide-cd.h        |    4 +-
 drivers/ide/ide-cs.c        |    1 +
 drivers/ide/ide-devsets.c   |    4 +-
 drivers/ide/ide-disk.c      |  171 ++++++++---------
 drivers/ide/ide-disk_proc.c |   28 ++--
 drivers/ide/ide-dma-sff.c   |   37 ++---
 drivers/ide/ide-dma.c       |   39 ++--
 drivers/ide/ide-eh.c        |   30 ++-
 drivers/ide/ide-floppy.c    |  156 ++++++---------
 drivers/ide/ide-gd.c        |   10 +-
 drivers/ide/ide-gd.h        |    4 +-
 drivers/ide/ide-generic.c   |    8 +-
 drivers/ide/ide-h8300.c     |   66 ++++----
 drivers/ide/ide-io-std.c    |   73 ++++----
 drivers/ide/ide-io.c        |  285 ++++++++++-----------------
 drivers/ide/ide-ioctls.c    |   44 ++--
 drivers/ide/ide-iops.c      |   66 +++----
 drivers/ide/ide-lib.c       |   20 +-
 drivers/ide/ide-park.c      |   19 +-
 drivers/ide/ide-pm.c        |   42 +++--
 drivers/ide/ide-pnp.c       |    6 +-
 drivers/ide/ide-probe.c     |   95 ++++------
 drivers/ide/ide-proc.c      |   16 +-
 drivers/ide/ide-tape.c      |  123 +++++--------
 drivers/ide/ide-taskfile.c  |  448 ++++++++++++++++++++-----------------------
 drivers/ide/ide_arm.c       |    6 +-
 drivers/ide/it821x.c        |    2 +-
 drivers/ide/macide.c        |    7 +-
 drivers/ide/ns87415.c       |   36 ++--
 drivers/ide/palm_bk3710.c   |   13 +-
 drivers/ide/pdc202xx_old.c  |    4 +-
 drivers/ide/pmac.c          |   32 +---
 drivers/ide/q40ide.c        |   15 +-
 drivers/ide/sc1200.c        |    2 +-
 drivers/ide/scc_pata.c      |  115 +++++------
 drivers/ide/setup-pci.c     |    4 +
 drivers/ide/sgiioc4.c       |   30 +--
 drivers/ide/siimage.c       |    2 +-
 drivers/ide/sl82c105.c      |    2 +-
 drivers/ide/tc86c001.c      |    2 +-
 drivers/ide/trm290.c        |   15 +-
 drivers/ide/tx4938ide.c     |   68 ++++----
 drivers/ide/tx4939ide.c     |  109 +++++------
 include/linux/ide.h         |  239 ++++++++++++-----------
 61 files changed, 1418 insertions(+), 1667 deletions(-)


Bartlomiej Zolnierkiewicz (67):
      icside: use struct ide_port_info also for PCB version 5 (v2)
      ide_arm: use struct ide_port_info
      ide-generic: use struct ide_port_info
      ide-pnp: use struct ide_port_info
      buddha: use struct ide_port_info
      macide: use struct ide_port_info
      ide: move ->rqsize init from init_irq() to ide_init_port()
      ide: remove IDE_ARCH_INTR (v2)
      ide: remove IDE_ARCH_LOCK (v2)
      ide: make m68k host drivers use IDE_HFLAG_MMIO
      ide: cleanup <asm-m68k/ide.h>
      at91_ide: use readsw()/writesw() directly
      ide: include <asm/ide.h> only when needed
      scc_pata: remove DECLARE_SCC_DEV() macro (v2)
      ide: fix memleak on failure in probe_for_drive()
      ide: fix error message in pre_task_out_intr()
      ide: allow host drivers to specify IRQ flags
      ide: remove now superfluous check from ide_host_register()
      ide: add IDE_HFLAG_DTC2278 host flag
      ide: add IDE_HFLAG_4DRIVES host flag
      ide: add "flagged" taskfile flags to struct ide_taskfile (v2)
      ide: complete power step in ide_complete_pm_request()
      ide: factor out completion of taskfile from ide_end_drive_cmd()
      ide: move request type specific code from ide_end_drive_cmd() to callers (v3)
      ide: no need to read Status and Error registers for "empty" taskfile requests
      ide: remove ->data_phase field from ide_hwif_t
      ide: move smart_enable() call out from get_smart_data()
      icside: icside_dma_setup() fixes
      trm290: trm290_dma_setup() fix
      au1xxx-ide: auide_dma_end() cleanup
      ide: remove no longer needed PC_FLAG_TIMEDOUT packet command flag
      ide-floppy: remove superfluous check from ide_floppy_end_request()
      ide-tape: remove superfluous tape->lock
      ide: move ->failed_pc to ide_drive_t
      ide: use ->end_request only for private device driver requests
      ide-{floppy,tape}: cleanup ide*_end_request()
      ide: remove ->end_request method
      ide: return request status from ->pc_callback method
      ide: use blk_fs_request() check in ide-taskfile.c
      ide: call ide_build_sglist() prior to ->dma_setup (v2)
      ide: remove ide_task_t typedef
      ide: pass command instead of request to ide_pio_datablock()
      ide: move command related fields from ide_hwif_t to struct ide_cmd
      ide: set IDE_TFLAG_WRITE basing on data phase used in ide_taskfile_ioctl()
      ide: use ata_tf_protocols enums
      ide: merge task_{in,out}_intr()
      ide: inline task_in_unexpected() into task_pio_intr()
      ide: unify exit paths in task_pio_intr()
      ide: task_error() -> task_error_cmd()
      ide: use ide_complete_cmd() for head unload commands
      ide: use ide_complete_cmd() for REQ_UNPARK_HEADS
      ide: sanitize ide_finish_cmd()
      ide: make ide_special_rq() BUG() on unknown requests
      ide: add ide_end_rq() (v2)
      ide: sanitize ide_end_rq()
      ide: pass error value to ide_complete_rq()
      ide: move rq->errors quirk out from ide_end_request()
      ide: remove BUG() from ide_complete_rq()
      ide: pass number of bytes to complete to ide_complete_rq()
      ide: use ide_end_rq() in ide_complete_rq()
      ide: remove ide_end_request()
      ide: pass command to ide_map_sg()
      ide: use do_rw_taskfile() for ATA_CMD_PACKET commands
      ide: set hwif->expiry prior to calling [__]ide_set_handler()
      ide: add ->dma_timer_expiry method and remove ->dma_exec_cmd one (v2)
      ide: remove ide_execute_pkt_cmd() (v2)
      ide: keep track of number of bytes instead of sectors in struct ide_cmd

Borislav Petkov (2):
      ide: improve debugging scheme
      ide-cd: use ide_drive_t's rq in cdrom_queue_request_sense

Kevin Hilman (1):
      IDE: palm_bk3710: use ioremap instead of arch-specific IO_ADDRESS()


diff --git a/arch/m68k/include/asm/ide.h b/arch/m68k/include/asm/ide.h
index b996a3c..3958726 100644
--- a/arch/m68k/include/asm/ide.h
+++ b/arch/m68k/include/asm/ide.h
@@ -30,101 +30,28 @@
 #define _M68K_IDE_H
 
 #ifdef __KERNEL__
-
-
 #include <asm/setup.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
-#ifdef CONFIG_ATARI
-#include <linux/interrupt.h>
-#include <asm/atari_stdma.h>
-#endif
-
-#ifdef CONFIG_MAC
-#include <asm/macints.h>
-#endif
-
 /*
  * Get rid of defs from io.h - ide has its private and conflicting versions
  * Since so far no single m68k platform uses ISA/PCI I/O space for IDE, we
  * always use the `raw' MMIO versions
  */
-#undef inb
-#undef inw
-#undef insw
-#undef inl
-#undef insl
-#undef outb
-#undef outw
-#undef outsw
-#undef outl
-#undef outsl
 #undef readb
 #undef readw
-#undef readl
 #undef writeb
 #undef writew
-#undef writel
 
-#define inb				in_8
-#define inw				in_be16
-#define insw(port, addr, n)		raw_insw((u16 *)port, addr, n)
-#define inl				in_be32
-#define insl(port, addr, n)		raw_insl((u32 *)port, addr, n)
-#define outb(val, port)			out_8(port, val)
-#define outw(val, port)			out_be16(port, val)
-#define outsw(port, addr, n)		raw_outsw((u16 *)port, addr, n)
-#define outl(val, port)			out_be32(port, val)
-#define outsl(port, addr, n)		raw_outsl((u32 *)port, addr, n)
 #define readb				in_8
 #define readw				in_be16
 #define __ide_mm_insw(port, addr, n)	raw_insw((u16 *)port, addr, n)
-#define readl				in_be32
 #define __ide_mm_insl(port, addr, n)	raw_insl((u32 *)port, addr, n)
 #define writeb(val, port)		out_8(port, val)
 #define writew(val, port)		out_be16(port, val)
 #define __ide_mm_outsw(port, addr, n)	raw_outsw((u16 *)port, addr, n)
-#define writel(val, port)		out_be32(port, val)
 #define __ide_mm_outsl(port, addr, n)	raw_outsl((u32 *)port, addr, n)
-#if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
-#define insw_swapw(port, addr, n)	raw_insw_swapw((u16 *)port, addr, n)
-#define outsw_swapw(port, addr, n)	raw_outsw_swapw((u16 *)port, addr, n)
-#endif
-
-#ifdef CONFIG_BLK_DEV_FALCON_IDE
-#define IDE_ARCH_LOCK
-
-extern int falconide_intr_lock;
-
-static __inline__ void ide_release_lock (void)
-{
-	if (MACH_IS_ATARI) {
-		if (falconide_intr_lock == 0) {
-			printk("ide_release_lock: bug\n");
-			return;
-		}
-		falconide_intr_lock = 0;
-		stdma_release();
-	}
-}
-
-static __inline__ void
-ide_get_lock(irq_handler_t handler, void *data)
-{
-	if (MACH_IS_ATARI) {
-		if (falconide_intr_lock == 0) {
-			if (in_interrupt() > 0)
-				panic( "Falcon IDE hasn't ST-DMA lock in interrupt" );
-			stdma_lock(handler, data);
-			falconide_intr_lock = 1;
-		}
-	}
-}
-#endif /* CONFIG_BLK_DEV_FALCON_IDE */
-
-#define IDE_ARCH_ACK_INTR
-#define ide_ack_intr(hwif)	((hwif)->ack_intr ? (hwif)->ack_intr(hwif) : 1)
 
 #endif /* __KERNEL__ */
 #endif /* _M68K_IDE_H */
diff --git a/drivers/ide/alim15x3.c b/drivers/ide/alim15x3.c
index d3513b6..d516168 100644
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -191,17 +191,18 @@ static void ali_set_dma_mode(ide_drive_t *drive, const u8 speed)
 /**
  *	ali15x3_dma_setup	-	begin a DMA phase
  *	@drive:	target device
+ *	@cmd: command
  *
  *	Returns 1 if the DMA cannot be performed, zero on success.
  */
 
-static int ali15x3_dma_setup(ide_drive_t *drive)
+static int ali15x3_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	if (m5229_revision < 0xC2 && drive->media != ide_disk) {
-		if (rq_data_dir(drive->hwif->rq))
+		if (cmd->tf_flags & IDE_TFLAG_WRITE)
 			return 1;	/* try PIO instead of DMA */
 	}
-	return ide_dma_setup(drive);
+	return ide_dma_setup(drive, cmd);
 }
 
 /**
@@ -503,11 +504,11 @@ static const struct ide_port_ops ali_port_ops = {
 static const struct ide_dma_ops ali_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ali15x3_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
diff --git a/drivers/ide/at91_ide.c b/drivers/ide/at91_ide.c
index 1bb50f4..2754712 100644
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -143,7 +143,7 @@ static void apply_timings(const u8 chipselect, const u8 pio,
 	set_smc_timings(chipselect, cycle, setup, pulse, data_float, use_iordy);
 }
 
-static void at91_ide_input_data(ide_drive_t *drive, struct request *rq,
+static void at91_ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 				void *buf, unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -156,11 +156,11 @@ static void at91_ide_input_data(ide_drive_t *drive, struct request *rq,
 	len++;
 
 	enter_16bit(chipselect, mode);
-	__ide_mm_insw((void __iomem *) io_ports->data_addr, buf, len / 2);
+	readsw((void __iomem *)io_ports->data_addr, buf, len / 2);
 	leave_16bit(chipselect, mode);
 }
 
-static void at91_ide_output_data(ide_drive_t *drive, struct request *rq,
+static void at91_ide_output_data(ide_drive_t *drive, struct ide_cmd *cmd,
 				 void *buf, unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -171,7 +171,7 @@ static void at91_ide_output_data(ide_drive_t *drive, struct request *rq,
 	pdbg("cs %u buf %p len %d\n", chipselect,  buf, len);
 
 	enter_16bit(chipselect, mode);
-	__ide_mm_outsw((void __iomem *) io_ports->data_addr, buf, len / 2);
+	writesw((void __iomem *)io_ports->data_addr, buf, len / 2);
 	leave_16bit(chipselect, mode);
 }
 
@@ -185,55 +185,55 @@ static void ide_mm_outb(u8 value, unsigned long port)
 	writeb(value, (void __iomem *) port);
 }
 
-static void at91_ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+static void at91_ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+	struct ide_taskfile *tf = &cmd->tf;
+	u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (cmd->tf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
+	if (cmd->tf_flags & IDE_FTFLAG_OUT_DATA) {
 		u16 data = (tf->hob_data << 8) | tf->data;
 
 		at91_ide_output_data(drive, NULL, &data, 2);
 	}
 
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		ide_mm_outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
 		ide_mm_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
 		ide_mm_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
 		ide_mm_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
 		ide_mm_outb(tf->hob_lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
 		ide_mm_outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
 		ide_mm_outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
 		ide_mm_outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
 		ide_mm_outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
 		ide_mm_outb(tf->lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
 		ide_mm_outb((tf->device & HIHI) | drive->select, io_ports->device_addr);
 }
 
-static void at91_ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+static void at91_ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+	if (cmd->tf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data;
 
 		at91_ide_input_data(drive, NULL, &data, 2);
@@ -244,31 +244,31 @@ static void at91_ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 	/* be sure we're looking at the low order bits */
 	ide_mm_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
 		tf->feature = ide_mm_inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = ide_mm_inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
 		tf->lbal   = ide_mm_inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
 		tf->lbam   = ide_mm_inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
 		tf->lbah   = ide_mm_inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
 		tf->device = ide_mm_inb(io_ports->device_addr);
 
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
+	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
 		ide_mm_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = ide_mm_inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
 			tf->hob_nsect   = ide_mm_inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
 			tf->hob_lbal    = ide_mm_inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
 			tf->hob_lbam    = ide_mm_inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
 			tf->hob_lbah    = ide_mm_inb(io_ports->lbah_addr);
 	}
 }
diff --git a/drivers/ide/au1xxx-ide.c b/drivers/ide/au1xxx-ide.c
index 154ec2c..d3a9d6c 100644
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -86,13 +86,13 @@ void auide_outsw(unsigned long port, void *addr, u32 count)
 	ctp->cur_ptr = au1xxx_ddma_get_nextptr_virt(dp);
 }
 
-static void au1xxx_input_data(ide_drive_t *drive, struct request *rq,
+static void au1xxx_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 			      void *buf, unsigned int len)
 {
 	auide_insw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
 }
 
-static void au1xxx_output_data(ide_drive_t *drive, struct request *rq,
+static void au1xxx_output_data(ide_drive_t *drive, struct ide_cmd *cmd,
 			       void *buf, unsigned int len)
 {
 	auide_outsw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
@@ -209,23 +209,17 @@ static void auide_set_dma_mode(ide_drive_t *drive, const u8 speed)
  */
 
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
-static int auide_build_dmatable(ide_drive_t *drive)
+static int auide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	int i, iswrite, count = 0;
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->rq;
 	_auide_hwif *ahwif = &auide_hwif;
 	struct scatterlist *sg;
+	int i = cmd->sg_nents, count = 0;
+	int iswrite = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
 
-	iswrite = (rq_data_dir(rq) == WRITE);
 	/* Save for interrupt context */
 	ahwif->drive = drive;
 
-	hwif->sg_nents = i = ide_build_sglist(drive, rq);
-
-	if (!i)
-		return 0;
-
 	/* fill the descriptors */
 	sg = hwif->sg_table;
 	while (i && sg_dma_len(sg)) {
@@ -286,12 +280,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 
 static int auide_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
-
-	if (hwif->sg_nents) {
-		ide_destroy_dmatable(drive);
-		hwif->sg_nents = 0;
-	}
+	ide_destroy_dmatable(drive);
 
 	return 0;
 }
@@ -301,19 +290,10 @@ static void auide_dma_start(ide_drive_t *drive )
 }
 
 
-static void auide_dma_exec_cmd(ide_drive_t *drive, u8 command)
+static int auide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	/* issue cmd to drive */
-	ide_execute_command(drive, command, &ide_dma_intr,
-			    (2*WAIT_CMD), NULL);
-}
-
-static int auide_dma_setup(ide_drive_t *drive)
-{
-	struct request *rq = drive->hwif->rq;
-
-	if (!auide_build_dmatable(drive)) {
-		ide_map_sg(drive, rq);
+	if (auide_build_dmatable(drive, cmd) == 0) {
+		ide_map_sg(drive, cmd);
 		return 1;
 	}
 
@@ -369,7 +349,6 @@ static void auide_init_dbdma_dev(dbdev_tab_t *dev, u32 dev_id, u32 tsize, u32 de
 static const struct ide_dma_ops au1xxx_dma_ops = {
 	.dma_host_set		= auide_dma_host_set,
 	.dma_setup		= auide_dma_setup,
-	.dma_exec_cmd		= auide_dma_exec_cmd,
 	.dma_start		= auide_dma_start,
 	.dma_end		= auide_dma_end,
 	.dma_test_irq		= auide_dma_test_irq,
diff --git a/drivers/ide/buddha.c b/drivers/ide/buddha.c
index c5a3c9e..d028f88 100644
--- a/drivers/ide/buddha.c
+++ b/drivers/ide/buddha.c
@@ -143,6 +143,11 @@ static void __init buddha_setup_ports(hw_regs_t *hw, unsigned long base,
 	hw->chipset = ide_generic;
 }
 
+static const struct ide_port_info buddha_port_info = {
+	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
+	.irq_flags		= IRQF_SHARED,
+};
+
     /*
      *  Probe for a Buddha or Catweasel IDE interface
      */
@@ -172,10 +177,6 @@ static int __init buddha_init(void)
 		
 		board = z->resource.start;
 
-/*
- * FIXME: we now have selectable mmio v/s iomio transports.
- */
-
 		if(type != BOARD_XSURF) {
 			if (!request_mem_region(board+BUDDHA_BASE1, 0x800, "IDE"))
 				continue;
@@ -224,7 +225,7 @@ fail_base2:
 			hws[i] = &hw[i];
 		}
 
-		ide_host_add(NULL, hws, NULL);
+		ide_host_add(&buddha_port_info, hws, NULL);
 	}
 
 	return 0;
diff --git a/drivers/ide/cmd64x.c b/drivers/ide/cmd64x.c
index aeee036..bf0e3f4 100644
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -379,11 +379,11 @@ static const struct ide_port_ops cmd64x_port_ops = {
 static const struct ide_dma_ops cmd64x_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= cmd64x_dma_end,
 	.dma_test_irq		= cmd64x_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
@@ -391,11 +391,11 @@ static const struct ide_dma_ops cmd64x_dma_ops = {
 static const struct ide_dma_ops cmd646_rev1_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= cmd646_1_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
@@ -403,11 +403,11 @@ static const struct ide_dma_ops cmd646_rev1_dma_ops = {
 static const struct ide_dma_ops cmd648_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= cmd648_dma_end,
 	.dma_test_irq		= cmd648_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
diff --git a/drivers/ide/cs5536.c b/drivers/ide/cs5536.c
index 7a62db7..d5dcf48 100644
--- a/drivers/ide/cs5536.c
+++ b/drivers/ide/cs5536.c
@@ -231,11 +231,11 @@ static const struct ide_port_ops cs5536_port_ops = {
 static const struct ide_dma_ops cs5536_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= cs5536_dma_start,
 	.dma_end		= cs5536_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 };
 
diff --git a/drivers/ide/delkin_cb.c b/drivers/ide/delkin_cb.c
index bacb119..f153b95 100644
--- a/drivers/ide/delkin_cb.c
+++ b/drivers/ide/delkin_cb.c
@@ -66,6 +66,7 @@ static const struct ide_port_info delkin_cb_port_info = {
 	.port_ops		= &delkin_cb_port_ops,
 	.host_flags		= IDE_HFLAG_IO_32BIT | IDE_HFLAG_UNMASK_IRQS |
 				  IDE_HFLAG_NO_DMA,
+	.irq_flags		= IRQF_SHARED,
 	.init_chipset		= delkin_cb_init_chipset,
 };
 
diff --git a/drivers/ide/dtc2278.c b/drivers/ide/dtc2278.c
index 689b2e4..c6b1381 100644
--- a/drivers/ide/dtc2278.c
+++ b/drivers/ide/dtc2278.c
@@ -100,7 +100,8 @@ static const struct ide_port_info dtc2278_port_info __initdata = {
 				  IDE_HFLAG_IO_32BIT |
 				  /* disallow ->io_32bit changes */
 				  IDE_HFLAG_NO_IO_32BIT |
-				  IDE_HFLAG_NO_DMA,
+				  IDE_HFLAG_NO_DMA |
+				  IDE_HFLAG_DTC2278,
 	.pio_mask		= ATA_PIO4,
 };
 
diff --git a/drivers/ide/falconide.c b/drivers/ide/falconide.c
index a638e95..b368a5e 100644
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -40,29 +40,48 @@
      *  which is shared between several drivers.
      */
 
-int falconide_intr_lock;
-EXPORT_SYMBOL(falconide_intr_lock);
+static int falconide_intr_lock;
 
-static void falconide_input_data(ide_drive_t *drive, struct request *rq,
+static void falconide_release_lock(void)
+{
+	if (falconide_intr_lock == 0) {
+		printk(KERN_ERR "%s: bug\n", __func__);
+		return;
+	}
+	falconide_intr_lock = 0;
+	stdma_release();
+}
+
+static void falconide_get_lock(irq_handler_t handler, void *data)
+{
+	if (falconide_intr_lock == 0) {
+		if (in_interrupt() > 0)
+			panic("Falcon IDE hasn't ST-DMA lock in interrupt");
+		stdma_lock(handler, data);
+		falconide_intr_lock = 1;
+	}
+}
+
+static void falconide_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 				 void *buf, unsigned int len)
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
 		return insw(data_addr, buf, (len + 1) / 2);
 
-	insw_swapw(data_addr, buf, (len + 1) / 2);
+	raw_insw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
 }
 
-static void falconide_output_data(ide_drive_t *drive, struct request *rq,
+static void falconide_output_data(ide_drive_t *drive, struct ide_cmd *cmd,
 				  void *buf, unsigned int len)
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
 		return outsw(data_addr, buf, (len + 1) / 2);
 
-	outsw_swapw(data_addr, buf, (len + 1) / 2);
+	raw_outsw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
 }
 
 /* Atari has a byte-swapped IDE interface */
@@ -81,8 +100,12 @@ static const struct ide_tp_ops falconide_tp_ops = {
 };
 
 static const struct ide_port_info falconide_port_info = {
+	.get_lock		= falconide_get_lock,
+	.release_lock		= falconide_release_lock,
 	.tp_ops			= &falconide_tp_ops,
-	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_SERIALIZE,
+	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_SERIALIZE |
+				  IDE_HFLAG_NO_DMA,
+	.irq_flags		= IRQF_SHARED,
 };
 
 static void __init falconide_setup_ports(hw_regs_t *hw)
@@ -132,9 +155,9 @@ static int __init falconide_init(void)
 		goto err;
 	}
 
-	ide_get_lock(NULL, NULL);
+	falconide_get_lock(NULL, NULL);
 	rc = ide_host_register(host, &falconide_port_info, hws);
-	ide_release_lock();
+	falconide_release_lock();
 
 	if (rc)
 		goto err_free;
diff --git a/drivers/ide/gayle.c b/drivers/ide/gayle.c
index 59bd0be..dc77825 100644
--- a/drivers/ide/gayle.c
+++ b/drivers/ide/gayle.c
@@ -118,7 +118,9 @@ static void __init gayle_setup_ports(hw_regs_t *hw, unsigned long base,
 }
 
 static const struct ide_port_info gayle_port_info = {
-	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_NO_DMA,
+	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_SERIALIZE |
+				  IDE_HFLAG_NO_DMA,
+	.irq_flags		= IRQF_SHARED,
 };
 
     /*
@@ -163,9 +165,6 @@ found:
 	    irqport = (unsigned long)ZTWO_VADDR(GAYLE_IRQ_1200);
 	    ack_intr = gayle_ack_intr_a1200;
 	}
-/*
- * FIXME: we now have selectable modes between mmio v/s iomio
- */
 
 	res_start = ((unsigned long)phys_base) & ~(GAYLE_NEXT_PORT-1);
 	res_n = GAYLE_IDEREG_SIZE;
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index d3b3e82..dbaf184 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -1418,11 +1418,11 @@ static const struct ide_port_ops hpt3xx_port_ops = {
 static const struct ide_dma_ops hpt37x_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= hpt374_dma_end,
 	.dma_test_irq		= hpt374_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
@@ -1430,11 +1430,11 @@ static const struct ide_dma_ops hpt37x_dma_ops = {
 static const struct ide_dma_ops hpt370_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= hpt370_dma_start,
 	.dma_end		= hpt370_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= hpt370_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
@@ -1442,11 +1442,11 @@ static const struct ide_dma_ops hpt370_dma_ops = {
 static const struct ide_dma_ops hpt36x_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= hpt366_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
index 415d7e2..51ce404 100644
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -307,15 +307,14 @@ static void icside_dma_start(ide_drive_t *drive)
 	enable_dma(ec->dma);
 }
 
-static int icside_dma_setup(ide_drive_t *drive)
+static int icside_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 	struct icside_state *state = ecard_get_drvdata(ec);
-	struct request *rq = hwif->rq;
 	unsigned int dma_mode;
 
-	if (rq_data_dir(rq))
+	if (cmd->tf_flags & IDE_TFLAG_WRITE)
 		dma_mode = DMA_MODE_WRITE;
 	else
 		dma_mode = DMA_MODE_READ;
@@ -325,8 +324,6 @@ static int icside_dma_setup(ide_drive_t *drive)
 	 */
 	BUG_ON(dma_channel_active(ec->dma));
 
-	hwif->sg_nents = ide_build_sglist(drive, rq);
-
 	/*
 	 * Ensure that we have the right interrupt routed.
 	 */
@@ -346,7 +343,7 @@ static int icside_dma_setup(ide_drive_t *drive)
 	 * Tell the DMA engine about the SG table and
 	 * data direction.
 	 */
-	set_dma_sg(ec->dma, hwif->sg_table, hwif->sg_nents);
+	set_dma_sg(ec->dma, hwif->sg_table, cmd->sg_nents);
 	set_dma_mode(ec->dma, dma_mode);
 
 	drive->waiting_for_dma = 1;
@@ -354,12 +351,6 @@ static int icside_dma_setup(ide_drive_t *drive)
 	return 0;
 }
 
-static void icside_dma_exec_cmd(ide_drive_t *drive, u8 cmd)
-{
-	/* issue cmd to drive */
-	ide_execute_command(drive, cmd, ide_dma_intr, 2 * WAIT_CMD, NULL);
-}
-
 static int icside_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -383,7 +374,6 @@ static int icside_dma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 static const struct ide_dma_ops icside_v6_dma_ops = {
 	.dma_host_set		= icside_dma_host_set,
 	.dma_setup		= icside_dma_setup,
-	.dma_exec_cmd		= icside_dma_exec_cmd,
 	.dma_start		= icside_dma_start,
 	.dma_end		= icside_dma_end,
 	.dma_test_irq		= icside_dma_test_irq,
@@ -419,6 +409,10 @@ static void icside_setup_ports(hw_regs_t *hw, void __iomem *base,
 	hw->chipset = ide_acorn;
 }
 
+static const struct ide_port_info icside_v5_port_info = {
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static int __devinit
 icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 {
@@ -445,7 +439,7 @@ icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 
 	icside_setup_ports(&hw, base, &icside_cardinfo_v5, ec);
 
-	host = ide_host_alloc(NULL, hws);
+	host = ide_host_alloc(&icside_v5_port_info, hws);
 	if (host == NULL)
 		return -ENODEV;
 
@@ -453,7 +447,7 @@ icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 
 	ecard_set_drvdata(ec, state);
 
-	ret = ide_host_register(host, NULL, hws);
+	ret = ide_host_register(host, &icside_v5_port_info, hws);
 	if (ret)
 		goto err_free;
 
diff --git a/drivers/ide/ide-4drives.c b/drivers/ide/ide-4drives.c
index 9e85b1e..78aca75 100644
--- a/drivers/ide/ide-4drives.c
+++ b/drivers/ide/ide-4drives.c
@@ -23,7 +23,8 @@ static const struct ide_port_ops ide_4drives_port_ops = {
 
 static const struct ide_port_info ide_4drives_port_info = {
 	.port_ops		= &ide_4drives_port_ops,
-	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_NO_DMA,
+	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_NO_DMA |
+				  IDE_HFLAG_4DRIVES,
 };
 
 static int __init ide_4drives_init(void)
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 5b704f1..12f4369 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -304,7 +304,7 @@ static int do_drive_set_taskfiles(ide_drive_t *drive,
 	/* send all taskfile registers (0x1f1-0x1f7) *in*that*order* */
 	for (ix = 0; ix < gtf_count; ix++) {
 		u8 *gtf = (u8 *)(gtf_address + ix * REGS_PER_GTF);
-		ide_task_t task;
+		struct ide_cmd cmd;
 
 		DEBPRINT("(0x1f1-1f7): "
 			 "hex: %02x %02x %02x %02x %02x %02x %02x\n",
@@ -317,11 +317,11 @@ static int do_drive_set_taskfiles(ide_drive_t *drive,
 		}
 
 		/* convert GTF to taskfile */
-		memset(&task, 0, sizeof(ide_task_t));
-		memcpy(&task.tf_array[7], gtf, REGS_PER_GTF);
-		task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+		memset(&cmd, 0, sizeof(cmd));
+		memcpy(&cmd.tf_array[7], gtf, REGS_PER_GTF);
+		cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-		err = ide_no_data_taskfile(drive, &task);
+		err = ide_no_data_taskfile(drive, &cmd);
 		if (err) {
 			printk(KERN_ERR "%s: ide_no_data_taskfile failed: %u\n",
 					__func__, err);
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 6adc5b4..2fb5d28 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -302,16 +302,16 @@ EXPORT_SYMBOL_GPL(ide_cd_get_xferlen);
 
 void ide_read_bcount_and_ireason(ide_drive_t *drive, u16 *bcount, u8 *ireason)
 {
-	ide_task_t task;
+	struct ide_cmd cmd;
 
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_IN_LBAH | IDE_TFLAG_IN_LBAM |
-			IDE_TFLAG_IN_NSECT;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_IN_LBAH | IDE_TFLAG_IN_LBAM |
+		       IDE_TFLAG_IN_NSECT;
 
-	drive->hwif->tp_ops->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &cmd);
 
-	*bcount = (task.tf.lbah << 8) | task.tf.lbam;
-	*ireason = task.tf.nsect & 3;
+	*bcount = (cmd.tf.lbah << 8) | cmd.tf.lbam;
+	*ireason = cmd.tf.nsect & 3;
 }
 EXPORT_SYMBOL_GPL(ide_read_bcount_and_ireason);
 
@@ -336,11 +336,6 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
 					       : WAIT_TAPE_CMD;
 
-	if (pc->flags & PC_FLAG_TIMEDOUT) {
-		drive->pc_callback(drive, 0);
-		return ide_stopped;
-	}
-
 	/* Clear the interrupt */
 	stat = tp_ops->read_status(hwif);
 
@@ -362,6 +357,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 	/* No more interrupts */
 	if ((stat & ATA_DRQ) == 0) {
+		int uptodate;
+
 		debug_log("Packet command completed, %d bytes transferred\n",
 			  pc->xferred);
 
@@ -400,7 +397,22 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			dsc = 1;
 
 		/* Command finished - Call the callback function */
-		drive->pc_callback(drive, dsc);
+		uptodate = drive->pc_callback(drive, dsc);
+
+		if (uptodate == 0)
+			drive->failed_pc = NULL;
+
+		if (blk_special_request(rq)) {
+			rq->errors = 0;
+			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
+		} else {
+			if (blk_fs_request(rq) == 0 && uptodate <= 0) {
+				if (rq->errors == 0)
+					rq->errors = -EIO;
+			}
+			ide_complete_rq(drive, uptodate ? 0 : -EIO,
+					ide_rq_bytes(rq));
+		}
 
 		return ide_stopped;
 	}
@@ -458,7 +470,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 		/* FIXME: don't do partial completions */
 		if (drive->media == ide_floppy)
-			ide_end_request(drive, 1, done >> 9);
+			ide_complete_rq(drive, 0,
+					done ? done : ide_rq_bytes(rq));
 	} else
 		xferfunc(drive, NULL, pc->cur_pos, bcount);
 
@@ -470,39 +483,32 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		  rq->cmd[0], bcount);
 next_irq:
 	/* And set the interrupt handler again */
-	ide_set_handler(drive, ide_pc_intr, timeout, NULL);
+	ide_set_handler(drive, ide_pc_intr, timeout);
 	return ide_started;
 }
 
-static void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount)
+static void ide_init_packet_cmd(struct ide_cmd *cmd, u32 tf_flags,
+				u16 bcount, u8 dma)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	ide_task_t task;
-	u8 dma = drive->dma;
-
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
-			IDE_TFLAG_OUT_FEATURE | tf_flags;
-	task.tf.feature = dma;		/* Use PIO/DMA */
-	task.tf.lbam    = bcount & 0xff;
-	task.tf.lbah    = (bcount >> 8) & 0xff;
-
-	ide_tf_dump(drive->name, &task.tf);
-	hwif->tp_ops->set_irq(hwif, 1);
-	SELECT_MASK(drive, 0);
-	hwif->tp_ops->tf_load(drive, &task);
+	cmd->protocol  = dma ? ATAPI_PROT_DMA : ATAPI_PROT_PIO;
+	cmd->tf_flags |= IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
+			 IDE_TFLAG_OUT_FEATURE | tf_flags;
+	cmd->tf.command = ATA_CMD_PACKET;
+	cmd->tf.feature = dma;		/* Use PIO/DMA */
+	cmd->tf.lbam    = bcount & 0xff;
+	cmd->tf.lbah    = (bcount >> 8) & 0xff;
 }
 
 static u8 ide_read_ireason(ide_drive_t *drive)
 {
-	ide_task_t task;
+	struct ide_cmd cmd;
 
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_IN_NSECT;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_IN_NSECT;
 
-	drive->hwif->tp_ops->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &cmd);
 
-	return task.tf.nsect & 3;
+	return cmd.tf.nsect & 3;
 }
 
 static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
@@ -597,11 +603,13 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 		}
 	}
 
+	hwif->expiry = expiry;
+
 	/* Set the interrupt routine */
 	ide_set_handler(drive,
 			(dev_is_idecd(drive) ? drive->irq_handler
 					     : ide_pc_intr),
-			timeout, expiry);
+			timeout);
 
 	/* Begin DMA, if necessary */
 	if (dev_is_idecd(drive)) {
@@ -621,23 +629,30 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	return ide_started;
 }
 
-ide_startstop_t ide_issue_pc(ide_drive_t *drive)
+ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	struct ide_atapi_pc *pc;
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
 	ide_expiry_t *expiry = NULL;
+	struct request *rq = hwif->rq;
 	unsigned int timeout;
 	u32 tf_flags;
 	u16 bcount;
+	u8 drq_int = !!(drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT);
 
 	if (dev_is_idecd(drive)) {
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
-		bcount = ide_cd_get_xferlen(hwif->rq);
+		bcount = ide_cd_get_xferlen(rq);
 		expiry = ide_cd_expiry;
 		timeout = ATAPI_WAIT_PC;
 
-		if (drive->dma)
-			drive->dma = !hwif->dma_ops->dma_setup(drive);
+		if (drive->dma) {
+			if (ide_build_sglist(drive, cmd))
+				drive->dma = !dma_ops->dma_setup(drive, cmd);
+			else
+				drive->dma = 0;
+		}
 	} else {
 		pc = drive->pc;
 
@@ -656,8 +671,12 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive)
 		}
 
 		if ((pc->flags & PC_FLAG_DMA_OK) &&
-		     (drive->dev_flags & IDE_DFLAG_USING_DMA))
-			drive->dma = !hwif->dma_ops->dma_setup(drive);
+		     (drive->dev_flags & IDE_DFLAG_USING_DMA)) {
+			if (ide_build_sglist(drive, cmd))
+				drive->dma = !dma_ops->dma_setup(drive, cmd);
+			else
+				drive->dma = 0;
+		}
 
 		if (!drive->dma)
 			pc->flags &= ~PC_FLAG_DMA_OK;
@@ -666,18 +685,18 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive)
 						       : WAIT_TAPE_CMD;
 	}
 
-	ide_pktcmd_tf_load(drive, tf_flags, bcount);
+	ide_init_packet_cmd(cmd, tf_flags, bcount, drive->dma);
 
-	/* Issue the packet command */
-	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
+	(void)do_rw_taskfile(drive, cmd);
+
+	if (drq_int) {
 		if (drive->dma)
 			drive->waiting_for_dma = 0;
-		ide_execute_command(drive, ATA_CMD_PACKET, ide_transfer_pc,
-				    timeout, expiry);
-		return ide_started;
-	} else {
-		ide_execute_pkt_cmd(drive);
-		return ide_transfer_pc(drive);
+		hwif->expiry = expiry;
 	}
+
+	ide_execute_command(drive, cmd, ide_transfer_pc, timeout);
+
+	return drq_int ? ide_started : ide_transfer_pc(drive);
 }
 EXPORT_SYMBOL_GPL(ide_issue_pc);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 2177cd1..3f630e4 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -100,8 +100,7 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 {
 	int log = 0;
 
-	ide_debug_log(IDE_DBG_SENSE, "Call %s, sense_key: 0x%x\n", __func__,
-		      sense->sense_key);
+	ide_debug_log(IDE_DBG_SENSE, "sense_key: 0x%x", sense->sense_key);
 
 	if (!sense || !rq || (rq->cmd_flags & REQ_QUIET))
 		return 0;
@@ -151,13 +150,12 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 	unsigned long bio_sectors;
 	struct cdrom_info *info = drive->driver_data;
 
-	ide_debug_log(IDE_DBG_SENSE, "Call %s, error_code: 0x%x, "
-			"sense_key: 0x%x\n", __func__, sense->error_code,
-			sense->sense_key);
+	ide_debug_log(IDE_DBG_SENSE, "error_code: 0x%x, sense_key: 0x%x",
+				     sense->error_code, sense->sense_key);
 
 	if (failed_command)
-		ide_debug_log(IDE_DBG_SENSE, "%s: failed cmd: 0x%x\n",
-				__func__, failed_command->cmd[0]);
+		ide_debug_log(IDE_DBG_SENSE, "failed cmd: 0x%x",
+					     failed_command->cmd[0]);
 
 	if (!cdrom_log_sense(drive, failed_command, sense))
 		return;
@@ -215,9 +213,9 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 				      struct request *failed_command)
 {
 	struct cdrom_info *info		= drive->driver_data;
-	struct request *rq		= &info->request_sense_request;
+	struct request *rq		= &drive->request_sense_rq;
 
-	ide_debug_log(IDE_DBG_SENSE, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_SENSE, "enter");
 
 	if (sense == NULL)
 		sense = &info->sense_data;
@@ -239,8 +237,8 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 	rq->buffer = (void *) failed_command;
 
 	if (failed_command)
-		ide_debug_log(IDE_DBG_SENSE, "failed_cmd: 0x%x\n",
-			      failed_command->cmd[0]);
+		ide_debug_log(IDE_DBG_SENSE, "failed_cmd: 0x%x",
+					     failed_command->cmd[0]);
 
 	drive->hwif->rq = NULL;
 
@@ -252,9 +250,8 @@ static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 	struct request *rq = drive->hwif->rq;
 	int nsectors = rq->hard_cur_sectors;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s, cmd: 0x%x, uptodate: 0x%x, "
-		      "nsectors: %d\n", __func__, rq->cmd[0], uptodate,
-		      nsectors);
+	ide_debug_log(IDE_DBG_FUNC, "cmd: 0x%x, uptodate: 0x%x, nsectors: %d",
+				    rq->cmd[0], uptodate, nsectors);
 
 	if (blk_sense_request(rq) && uptodate) {
 		/*
@@ -275,8 +272,8 @@ static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 			 * now end the failed request
 			 */
 			if (blk_fs_request(failed)) {
-				if (ide_end_dequeued_request(drive, failed, 0,
-						failed->hard_nr_sectors))
+				if (ide_end_rq(drive, failed, -EIO,
+						failed->hard_nr_sectors << 9))
 					BUG();
 			} else {
 				if (blk_end_request(failed, -EIO,
@@ -295,10 +292,13 @@ static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 	if (!nsectors)
 		nsectors = 1;
 
-	ide_debug_log(IDE_DBG_FUNC, "Exit %s, uptodate: 0x%x, nsectors: %d\n",
-		      __func__, uptodate, nsectors);
+	ide_debug_log(IDE_DBG_FUNC, "uptodate: 0x%x, nsectors: %d",
+				    uptodate, nsectors);
 
-	ide_end_request(drive, uptodate, nsectors);
+	if (blk_fs_request(rq) == 0 && uptodate <= 0 && rq->errors == 0)
+		rq->errors = -EIO;
+
+	ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
 }
 
 static void ide_dump_status_no_sense(ide_drive_t *drive, const char *msg, u8 st)
@@ -338,9 +338,10 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		return 1;
 	}
 
-	ide_debug_log(IDE_DBG_RQ, "%s: stat: 0x%x, good_stat: 0x%x, "
-		      "rq->cmd[0]: 0x%x, rq->cmd_type: 0x%x, err: 0x%x\n",
-		      __func__, stat, good_stat, rq->cmd[0], rq->cmd_type, err);
+	ide_debug_log(IDE_DBG_RQ, "stat: 0x%x, good_stat: 0x%x, cmd[0]: 0x%x, "
+				  "rq->cmd_type: 0x%x, err: 0x%x",
+				  stat, good_stat, rq->cmd[0], rq->cmd_type,
+				  err);
 
 	if (blk_sense_request(rq)) {
 		/*
@@ -530,8 +531,7 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s, ireason: 0x%x, rw: 0x%x\n",
-		      __func__, ireason, rw);
+	ide_debug_log(IDE_DBG_FUNC, "ireason: 0x%x, rw: 0x%x", ireason, rw);
 
 	/*
 	 * ireason == 0: the drive wants to receive data from us
@@ -572,7 +572,7 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
  */
 static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 {
-	ide_debug_log(IDE_DBG_FUNC, "Call %s, len: %d\n", __func__, len);
+	ide_debug_log(IDE_DBG_FUNC, "len: %d", len);
 
 	if ((len % SECTOR_SIZE) == 0)
 		return 0;
@@ -594,8 +594,7 @@ static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 static ide_startstop_t ide_cd_prepare_rw_request(ide_drive_t *drive,
 						 struct request *rq)
 {
-	ide_debug_log(IDE_DBG_RQ, "Call %s: rq->cmd_flags: 0x%x\n", __func__,
-		      rq->cmd_flags);
+	ide_debug_log(IDE_DBG_RQ, "rq->cmd_flags: 0x%x", rq->cmd_flags);
 
 	if (rq_data_dir(rq) == READ) {
 		unsigned short sectors_per_frame =
@@ -639,7 +638,7 @@ static ide_startstop_t ide_cd_prepare_rw_request(ide_drive_t *drive,
 static void ide_cd_restore_request(ide_drive_t *drive, struct request *rq)
 {
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	if (rq->buffer != bio_data(rq->bio)) {
 		sector_t n =
@@ -658,8 +657,7 @@ static void ide_cd_restore_request(ide_drive_t *drive, struct request *rq)
 
 static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct request *rq)
 {
-	ide_debug_log(IDE_DBG_FUNC, "Call %s, rq->cmd[0]: 0x%x\n",
-		      __func__, rq->cmd[0]);
+	ide_debug_log(IDE_DBG_FUNC, "rq->cmd[0]: 0x%x", rq->cmd[0]);
 
 	/*
 	 * Some of the trailing request sense fields are optional,
@@ -686,9 +684,9 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 	if (!sense)
 		sense = &local_sense;
 
-	ide_debug_log(IDE_DBG_PC, "Call %s, cmd[0]: 0x%x, write: 0x%x, "
-		      "timeout: %d, cmd_flags: 0x%x\n", __func__, cmd[0], write,
-		      timeout, cmd_flags);
+	ide_debug_log(IDE_DBG_PC, "cmd[0]: 0x%x, write: 0x%x, timeout: %d, "
+				  "cmd_flags: 0x%x",
+				  cmd[0], write, timeout, cmd_flags);
 
 	/* start of retry loop */
 	do {
@@ -772,8 +770,8 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	u16 len;
 	u8 ireason;
 
-	ide_debug_log(IDE_DBG_PC, "Call %s, rq->cmd[0]: 0x%x, write: 0x%x\n",
-		      __func__, rq->cmd[0], write);
+	ide_debug_log(IDE_DBG_PC, "cmd[0]: 0x%x, write: 0x%x",
+				  rq->cmd[0], write);
 
 	/* check for errors */
 	dma = drive->dma;
@@ -795,10 +793,11 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		if (dma_error)
 			return ide_error(drive, "dma error", stat);
 		if (blk_fs_request(rq)) {
-			ide_end_request(drive, 1, rq->nr_sectors);
+			ide_complete_rq(drive, 0, rq->nr_sectors
+				? (rq->nr_sectors << 9) : ide_rq_bytes(rq));
 			return ide_stopped;
 		} else if (rq->cmd_type == REQ_TYPE_ATA_PC && !rq->bio) {
-			ide_end_request(drive, 1, 1);
+			ide_complete_rq(drive, 0, 512);
 			return ide_stopped;
 		}
 		goto end_request;
@@ -810,8 +809,8 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	if (thislen > len)
 		thislen = len;
 
-	ide_debug_log(IDE_DBG_PC, "%s: DRQ: stat: 0x%x, thislen: %d\n",
-		      __func__, stat, thislen);
+	ide_debug_log(IDE_DBG_PC, "DRQ: stat: 0x%x, thislen: %d",
+				  stat, thislen);
 
 	/* If DRQ is clear, the command has completed. */
 	if ((stat & ATA_DRQ) == 0) {
@@ -876,8 +875,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		xferfunc = hwif->tp_ops->input_data;
 	}
 
-	ide_debug_log(IDE_DBG_PC, "%s: data transfer, rq->cmd_type: 0x%x, "
-		      "ireason: 0x%x\n", __func__, rq->cmd_type, ireason);
+	ide_debug_log(IDE_DBG_PC, "data transfer, rq->cmd_type: 0x%x, "
+				  "ireason: 0x%x",
+				  rq->cmd_type, ireason);
 
 	/* transfer data */
 	while (thislen > 0) {
@@ -959,7 +959,8 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			expiry = ide_cd_expiry;
 	}
 
-	ide_set_handler(drive, cdrom_newpc_intr, timeout, expiry);
+	hwif->expiry = expiry;
+	ide_set_handler(drive, cdrom_newpc_intr, timeout);
 	return ide_started;
 
 end_request:
@@ -988,9 +989,9 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 	unsigned short sectors_per_frame =
 		queue_hardsect_size(drive->queue) >> SECTOR_BITS;
 
-	ide_debug_log(IDE_DBG_RQ, "Call %s, rq->cmd[0]: 0x%x, write: 0x%x, "
-		      "secs_per_frame: %u\n",
-		      __func__, rq->cmd[0], write, sectors_per_frame);
+	ide_debug_log(IDE_DBG_RQ, "rq->cmd[0]: 0x%x, write: 0x%x, "
+				  "secs_per_frame: %u",
+				  rq->cmd[0], write, sectors_per_frame);
 
 	if (write) {
 		/* disk has become write protected */
@@ -1026,9 +1027,8 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 {
 
-	ide_debug_log(IDE_DBG_PC, "Call %s, rq->cmd[0]: 0x%x, "
-		      "rq->cmd_type: 0x%x\n", __func__, rq->cmd[0],
-		      rq->cmd_type);
+	ide_debug_log(IDE_DBG_PC, "rq->cmd[0]: 0x%x, rq->cmd_type: 0x%x",
+				  rq->cmd[0], rq->cmd_type);
 
 	if (blk_pc_request(rq))
 		rq->cmd_flags |= REQ_QUIET;
@@ -1067,10 +1067,13 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 					sector_t block)
 {
-	ide_debug_log(IDE_DBG_RQ, "Call %s, rq->cmd[0]: 0x%x, "
-		      "rq->cmd_type: 0x%x, block: %llu\n",
-		      __func__, rq->cmd[0], rq->cmd_type,
-		      (unsigned long long)block);
+	struct ide_cmd cmd;
+
+	ide_debug_log(IDE_DBG_RQ, "cmd: 0x%x, block: %llu",
+				  rq->cmd[0], (unsigned long long)block);
+
+	if (drive->debug_mask & IDE_DBG_RQ)
+		blk_dump_rq_flags(rq, "ide_cd_do_request");
 
 	if (blk_fs_request(rq)) {
 		if (cdrom_start_rw(drive, rq) == ide_stopped)
@@ -1094,7 +1097,14 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		return ide_stopped;
 	}
 
-	return ide_issue_pc(drive);
+	memset(&cmd, 0, sizeof(cmd));
+
+	if (rq_data_dir(rq))
+		cmd.tf_flags |= IDE_TFLAG_WRITE;
+
+	cmd.rq = rq;
+
+	return ide_issue_pc(drive, &cmd);
 }
 
 /*
@@ -1119,7 +1129,7 @@ int cdrom_check_status(ide_drive_t *drive, struct request_sense *sense)
 	struct cdrom_device_info *cdi = &info->devinfo;
 	unsigned char cmd[BLK_MAX_CDB];
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	memset(cmd, 0, BLK_MAX_CDB);
 	cmd[0] = GPCMD_TEST_UNIT_READY;
@@ -1147,7 +1157,7 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	unsigned len = sizeof(capbuf);
 	u32 blocklen;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	memset(cmd, 0, BLK_MAX_CDB);
 	cmd[0] = GPCMD_READ_CDVD_CAPACITY;
@@ -1179,8 +1189,8 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	*capacity = 1 + be32_to_cpu(capbuf.lba);
 	*sectors_per_frame = blocklen >> SECTOR_BITS;
 
-	ide_debug_log(IDE_DBG_PROBE, "%s: cap: %lu, sectors_per_frame: %lu\n",
-		      __func__, *capacity, *sectors_per_frame);
+	ide_debug_log(IDE_DBG_PROBE, "cap: %lu, sectors_per_frame: %lu",
+				     *capacity, *sectors_per_frame);
 
 	return 0;
 }
@@ -1191,7 +1201,7 @@ static int cdrom_read_tocentry(ide_drive_t *drive, int trackno, int msf_flag,
 {
 	unsigned char cmd[BLK_MAX_CDB];
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	memset(cmd, 0, BLK_MAX_CDB);
 
@@ -1221,7 +1231,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	long last_written;
 	unsigned long sectors_per_frame = SECTORS_PER_FRAME;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	if (toc == NULL) {
 		/* try to allocate space */
@@ -1383,7 +1393,7 @@ int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
 	struct packet_command cgc;
 	int stat, attempts = 3, size = ATAPI_CAPABILITIES_PAGE_SIZE;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	if ((drive->atapi_flags & IDE_AFLAG_FULL_CAPS_PAGE) == 0)
 		size -= ATAPI_CAPABILITIES_PAGE_PAD_SIZE;
@@ -1403,7 +1413,7 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 	struct cdrom_info *cd = drive->driver_data;
 	u16 curspeed, maxspeed;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	if (drive->atapi_flags & IDE_AFLAG_LE_SPEED_FIELDS) {
 		curspeed = le16_to_cpup((__le16 *)&buf[8 + 14]);
@@ -1413,8 +1423,8 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 		maxspeed = be16_to_cpup((__be16 *)&buf[8 + 8]);
 	}
 
-	ide_debug_log(IDE_DBG_PROBE, "%s: curspeed: %u, maxspeed: %u\n",
-		      __func__, curspeed, maxspeed);
+	ide_debug_log(IDE_DBG_PROBE, "curspeed: %u, maxspeed: %u",
+				     curspeed, maxspeed);
 
 	cd->current_speed = (curspeed + (176/2)) / 176;
 	cd->max_speed = (maxspeed + (176/2)) / 176;
@@ -1448,7 +1458,7 @@ static int ide_cdrom_register(ide_drive_t *drive, int nslots)
 	struct cdrom_info *info = drive->driver_data;
 	struct cdrom_device_info *devinfo = &info->devinfo;
 
-	ide_debug_log(IDE_DBG_PROBE, "Call %s, nslots: %d\n", __func__, nslots);
+	ide_debug_log(IDE_DBG_PROBE, "nslots: %d", nslots);
 
 	devinfo->ops = &ide_cdrom_dops;
 	devinfo->speed = info->current_speed;
@@ -1471,9 +1481,8 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 	mechtype_t mechtype;
 	int nslots = 1;
 
-	ide_debug_log(IDE_DBG_PROBE, "Call %s, drive->media: 0x%x, "
-		      "drive->atapi_flags: 0x%lx\n", __func__, drive->media,
-		      drive->atapi_flags);
+	ide_debug_log(IDE_DBG_PROBE, "media: 0x%x, atapi_flags: 0x%lx",
+				     drive->media, drive->atapi_flags);
 
 	cdi->mask = (CDC_CD_R | CDC_CD_RW | CDC_DVD | CDC_DVD_R |
 		     CDC_DVD_RAM | CDC_SELECT_DISC | CDC_PLAY_AUDIO |
@@ -1754,7 +1763,7 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 	char *fw_rev = (char *)&id[ATA_ID_FW_REV];
 	int nslots;
 
-	ide_debug_log(IDE_DBG_PROBE, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_PROBE, "enter");
 
 	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
 	blk_queue_dma_alignment(drive->queue, 31);
@@ -1797,7 +1806,7 @@ static void ide_cd_remove(ide_drive_t *drive)
 {
 	struct cdrom_info *info = drive->driver_data;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	ide_proc_unregister_driver(drive, info->driver);
 	device_del(&info->dev);
@@ -1815,7 +1824,7 @@ static void ide_cd_release(struct device *dev)
 	ide_drive_t *drive = info->drive;
 	struct gendisk *g = info->disk;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	kfree(info->toc);
 	if (devinfo->handle == drive)
@@ -1839,7 +1848,6 @@ static struct ide_driver ide_cdrom_driver = {
 	.remove			= ide_cd_remove,
 	.version		= IDECD_VERSION,
 	.do_request		= ide_cd_do_request,
-	.end_request		= ide_end_request,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_cd_proc_entries,
 	.proc_devsets		= ide_cd_proc_devsets,
@@ -1974,9 +1982,8 @@ static int ide_cd_probe(ide_drive_t *drive)
 	struct gendisk *g;
 	struct request_sense sense;
 
-	ide_debug_log(IDE_DBG_PROBE, "Call %s, drive->driver_req: %s, "
-		      "drive->media: 0x%x\n", __func__, drive->driver_req,
-		      drive->media);
+	ide_debug_log(IDE_DBG_PROBE, "driver_req: %s, media: 0x%x",
+				     drive->driver_req, drive->media);
 
 	if (!strstr("ide-cdrom", drive->driver_req))
 		goto failed;
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index c878bfc..1d97101 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -11,7 +11,7 @@
 #define IDECD_DEBUG_LOG		0
 
 #if IDECD_DEBUG_LOG
-#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
+#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, ## args)
 #else
 #define ide_debug_log(lvl, fmt, args...) do {} while (0)
 #endif
@@ -91,8 +91,6 @@ struct cdrom_info {
 	   on this device. */
 	struct request_sense sense_data;
 
-	struct request request_sense_request;
-
 	u8 max_speed;		/* Max speed of the drive. */
 	u8 current_speed;	/* Current speed of the drive. */
 
diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
index f50210f..9e47f35 100644
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -154,6 +154,7 @@ static const struct ide_port_ops idecs_port_ops = {
 static const struct ide_port_info idecs_port_info = {
 	.port_ops		= &idecs_port_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA,
+	.irq_flags		= IRQF_SHARED,
 };
 
 static struct ide_host *idecs_register(unsigned long io, unsigned long ctl,
diff --git a/drivers/ide/ide-devsets.c b/drivers/ide/ide-devsets.c
index 7c39534..5bf958e 100644
--- a/drivers/ide/ide-devsets.c
+++ b/drivers/ide/ide-devsets.c
@@ -183,8 +183,6 @@ ide_startstop_t ide_do_devset(ide_drive_t *drive, struct request *rq)
 	err = setfunc(drive, *(int *)&rq->cmd[1]);
 	if (err)
 		rq->errors = err;
-	else
-		err = 1;
-	ide_end_request(drive, err, 0);
+	ide_complete_rq(drive, err, ide_rq_bytes(rq));
 	return ide_stopped;
 }
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 806760d..ca934c8 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -28,7 +28,6 @@
 #include <linux/mutex.h>
 #include <linux/leds.h>
 #include <linux/ide.h>
-#include <linux/hdreg.h>
 
 #include <asm/byteorder.h>
 #include <asm/irq.h>
@@ -53,33 +52,26 @@ static const u8 ide_rw_cmds[] = {
 	ATA_CMD_WRITE_EXT,
 };
 
-static const u8 ide_data_phases[] = {
-	TASKFILE_MULTI_IN,
-	TASKFILE_MULTI_OUT,
-	TASKFILE_IN,
-	TASKFILE_OUT,
-	TASKFILE_IN_DMA,
-	TASKFILE_OUT_DMA,
-};
-
-static void ide_tf_set_cmd(ide_drive_t *drive, ide_task_t *task, u8 dma)
+static void ide_tf_set_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 dma)
 {
 	u8 index, lba48, write;
 
-	lba48 = (task->tf_flags & IDE_TFLAG_LBA48) ? 2 : 0;
-	write = (task->tf_flags & IDE_TFLAG_WRITE) ? 1 : 0;
+	lba48 = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 2 : 0;
+	write = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 1 : 0;
 
-	if (dma)
+	if (dma) {
+		cmd->protocol = ATA_PROT_DMA;
 		index = 8;
-	else
-		index = drive->mult_count ? 0 : 4;
-
-	task->tf.command = ide_rw_cmds[index + lba48 + write];
-
-	if (dma)
-		index = 8; /* fixup index */
+	} else {
+		cmd->protocol = ATA_PROT_PIO;
+		if (drive->mult_count) {
+			cmd->tf_flags |= IDE_TFLAG_MULTI_PIO;
+			index = 0;
+		} else
+			index = 4;
+	}
 
-	task->data_phase = ide_data_phases[index / 2 + write];
+	cmd->tf.command = ide_rw_cmds[index + lba48 + write];
 }
 
 /*
@@ -93,8 +85,8 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 	u16 nsectors		= (u16)rq->nr_sectors;
 	u8 lba48		= !!(drive->dev_flags & IDE_DFLAG_LBA48);
 	u8 dma			= !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
-	ide_task_t		task;
-	struct ide_taskfile	*tf = &task.tf;
+	struct ide_cmd		cmd;
+	struct ide_taskfile	*tf = &cmd.tf;
 	ide_startstop_t		rc;
 
 	if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) && lba48 && dma) {
@@ -104,13 +96,8 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 			lba48 = 0;
 	}
 
-	if (!dma) {
-		ide_init_sg_cmd(drive, rq);
-		ide_map_sg(drive, rq);
-	}
-
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
 	if (drive->dev_flags & IDE_DFLAG_LBA) {
 		if (lba48) {
@@ -129,7 +116,7 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 			tf->lbam   = (u8)(block >>  8);
 			tf->lbah   = (u8)(block >> 16);
 
-			task.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
+			cmd.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
 		} else {
 			tf->nsect  = nsectors & 0xff;
 			tf->lbal   = block;
@@ -156,23 +143,27 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 		tf->device = head;
 	}
 
+	cmd.tf_flags |= IDE_TFLAG_FS;
+
 	if (rq_data_dir(rq))
-		task.tf_flags |= IDE_TFLAG_WRITE;
+		cmd.tf_flags |= IDE_TFLAG_WRITE;
+
+	ide_tf_set_cmd(drive, &cmd, dma);
+	cmd.rq = rq;
 
-	ide_tf_set_cmd(drive, &task, dma);
-	if (!dma)
-		hwif->data_phase = task.data_phase;
-	task.rq = rq;
+	if (dma == 0) {
+		ide_init_sg_cmd(&cmd, nsectors << 9);
+		ide_map_sg(drive, &cmd);
+	}
 
-	rc = do_rw_taskfile(drive, &task);
+	rc = do_rw_taskfile(drive, &cmd);
 
 	if (rc == ide_stopped && dma) {
 		/* fallback to PIO */
-		task.tf_flags |= IDE_TFLAG_DMA_PIO_FALLBACK;
-		ide_tf_set_cmd(drive, &task, 0);
-		hwif->data_phase = task.data_phase;
-		ide_init_sg_cmd(drive, rq);
-		rc = do_rw_taskfile(drive, &task);
+		cmd.tf_flags |= IDE_TFLAG_DMA_PIO_FALLBACK;
+		ide_tf_set_cmd(drive, &cmd, 0);
+		ide_init_sg_cmd(&cmd, nsectors << 9);
+		rc = do_rw_taskfile(drive, &cmd);
 	}
 
 	return rc;
@@ -193,7 +184,9 @@ static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 
 	if (!blk_fs_request(rq)) {
 		blk_dump_rq_flags(rq, "ide_do_rw_disk - bad command");
-		ide_end_request(drive, 0, 0);
+		if (rq->errors == 0)
+			rq->errors = -EIO;
+		ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
 		return ide_stopped;
 	}
 
@@ -216,22 +209,22 @@ static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
  */
 static u64 idedisk_read_native_max_address(ide_drive_t *drive, int lba48)
 {
-	ide_task_t args;
-	struct ide_taskfile *tf = &args.tf;
+	struct ide_cmd cmd;
+	struct ide_taskfile *tf = &cmd.tf;
 	u64 addr = 0;
 
-	/* Create IDE/ATA command request structure */
-	memset(&args, 0, sizeof(ide_task_t));
+	memset(&cmd, 0, sizeof(cmd));
 	if (lba48)
 		tf->command = ATA_CMD_READ_NATIVE_MAX_EXT;
 	else
 		tf->command = ATA_CMD_READ_NATIVE_MAX;
 	tf->device  = ATA_LBA;
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	if (lba48)
-		args.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
-	/* submit command request */
-	ide_no_data_taskfile(drive, &args);
+		cmd.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
+
+	ide_no_data_taskfile(drive, &cmd);
 
 	/* if OK, compute maximum address value */
 	if ((tf->status & 0x01) == 0)
@@ -246,13 +239,13 @@ static u64 idedisk_read_native_max_address(ide_drive_t *drive, int lba48)
  */
 static u64 idedisk_set_max_address(ide_drive_t *drive, u64 addr_req, int lba48)
 {
-	ide_task_t args;
-	struct ide_taskfile *tf = &args.tf;
+	struct ide_cmd cmd;
+	struct ide_taskfile *tf = &cmd.tf;
 	u64 addr_set = 0;
 
 	addr_req--;
-	/* Create IDE/ATA command request structure */
-	memset(&args, 0, sizeof(ide_task_t));
+
+	memset(&cmd, 0, sizeof(cmd));
 	tf->lbal     = (addr_req >>  0) & 0xff;
 	tf->lbam     = (addr_req >>= 8) & 0xff;
 	tf->lbah     = (addr_req >>= 8) & 0xff;
@@ -266,11 +259,13 @@ static u64 idedisk_set_max_address(ide_drive_t *drive, u64 addr_req, int lba48)
 		tf->command  = ATA_CMD_SET_MAX;
 	}
 	tf->device |= ATA_LBA;
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	if (lba48)
-		args.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
-	/* submit command request */
-	ide_no_data_taskfile(drive, &args);
+		cmd.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
+
+	ide_no_data_taskfile(drive, &cmd);
+
 	/* if OK, compute maximum address value */
 	if ((tf->status & 0x01) == 0)
 		addr_set = ide_get_lba_addr(tf, lba48) + 1;
@@ -389,24 +384,24 @@ static int ide_disk_get_capacity(ide_drive_t *drive)
 static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 {
 	ide_drive_t *drive = q->queuedata;
-	ide_task_t *task = kmalloc(sizeof(*task), GFP_ATOMIC);
+	struct ide_cmd *cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
 
 	/* FIXME: map struct ide_taskfile on rq->cmd[] */
-	BUG_ON(task == NULL);
+	BUG_ON(cmd == NULL);
 
-	memset(task, 0, sizeof(*task));
+	memset(cmd, 0, sizeof(*cmd));
 	if (ata_id_flush_ext_enabled(drive->id) &&
 	    (drive->capacity64 >= (1UL << 28)))
-		task->tf.command = ATA_CMD_FLUSH_EXT;
+		cmd->tf.command = ATA_CMD_FLUSH_EXT;
 	else
-		task->tf.command = ATA_CMD_FLUSH;
-	task->tf_flags	 = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
-			   IDE_TFLAG_DYN;
-	task->data_phase = TASKFILE_NO_DATA;
+		cmd->tf.command = ATA_CMD_FLUSH;
+	cmd->tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
+			IDE_TFLAG_DYN;
+	cmd->protocol = ATA_PROT_NODATA;
 
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 	rq->cmd_flags |= REQ_SOFTBARRIER;
-	rq->special = task;
+	rq->special = cmd;
 }
 
 ide_devset_get(multcount, mult_count);
@@ -456,15 +451,15 @@ static int set_nowerr(ide_drive_t *drive, int arg)
 
 static int ide_do_setfeature(ide_drive_t *drive, u8 feature, u8 nsect)
 {
-	ide_task_t task;
+	struct ide_cmd cmd;
 
-	memset(&task, 0, sizeof(task));
-	task.tf.feature = feature;
-	task.tf.nsect   = nsect;
-	task.tf.command = ATA_CMD_SET_FEATURES;
-	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf.feature = feature;
+	cmd.tf.nsect   = nsect;
+	cmd.tf.command = ATA_CMD_SET_FEATURES;
+	cmd.tf_flags   = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-	return ide_no_data_taskfile(drive, &task);
+	return ide_no_data_taskfile(drive, &cmd);
 }
 
 static void update_ordered(ide_drive_t *drive)
@@ -531,15 +526,16 @@ static int set_wcache(ide_drive_t *drive, int arg)
 
 static int do_idedisk_flushcache(ide_drive_t *drive)
 {
-	ide_task_t args;
+	struct ide_cmd cmd;
 
-	memset(&args, 0, sizeof(ide_task_t));
+	memset(&cmd, 0, sizeof(cmd));
 	if (ata_id_flush_ext_enabled(drive->id))
-		args.tf.command = ATA_CMD_FLUSH_EXT;
+		cmd.tf.command = ATA_CMD_FLUSH_EXT;
 	else
-		args.tf.command = ATA_CMD_FLUSH;
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	return ide_no_data_taskfile(drive, &args);
+		cmd.tf.command = ATA_CMD_FLUSH;
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+
+	return ide_no_data_taskfile(drive, &cmd);
 }
 
 ide_devset_get(acoustic, acoustic);
@@ -711,17 +707,17 @@ static int ide_disk_init_media(ide_drive_t *drive, struct gendisk *disk)
 static int ide_disk_set_doorlock(ide_drive_t *drive, struct gendisk *disk,
 				 int on)
 {
-	ide_task_t task;
+	struct ide_cmd cmd;
 	int ret;
 
 	if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) == 0)
 		return 0;
 
-	memset(&task, 0, sizeof(task));
-	task.tf.command = on ? ATA_CMD_MEDIA_LOCK : ATA_CMD_MEDIA_UNLOCK;
-	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf.command = on ? ATA_CMD_MEDIA_LOCK : ATA_CMD_MEDIA_UNLOCK;
+	cmd.tf_flags   = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-	ret = ide_no_data_taskfile(drive, &task);
+	ret = ide_no_data_taskfile(drive, &cmd);
 
 	if (ret)
 		drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
@@ -737,6 +733,5 @@ const struct ide_disk_ops ide_ata_disk_ops = {
 	.init_media	= ide_disk_init_media,
 	.set_doorlock	= ide_disk_set_doorlock,
 	.do_request	= ide_do_rw_disk,
-	.end_request	= ide_end_request,
 	.ioctl		= ide_disk_ioctl,
 };
diff --git a/drivers/ide/ide-disk_proc.c b/drivers/ide/ide-disk_proc.c
index 1f86dcb..eaea3be 100644
--- a/drivers/ide/ide-disk_proc.c
+++ b/drivers/ide/ide-disk_proc.c
@@ -1,38 +1,38 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
-#include <linux/hdreg.h>
 
 #include "ide-disk.h"
 
 static int smart_enable(ide_drive_t *drive)
 {
-	ide_task_t args;
-	struct ide_taskfile *tf = &args.tf;
+	struct ide_cmd cmd;
+	struct ide_taskfile *tf = &cmd.tf;
 
-	memset(&args, 0, sizeof(ide_task_t));
+	memset(&cmd, 0, sizeof(cmd));
 	tf->feature = ATA_SMART_ENABLE;
 	tf->lbam    = ATA_SMART_LBAM_PASS;
 	tf->lbah    = ATA_SMART_LBAH_PASS;
 	tf->command = ATA_CMD_SMART;
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	return ide_no_data_taskfile(drive, &args);
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+
+	return ide_no_data_taskfile(drive, &cmd);
 }
 
 static int get_smart_data(ide_drive_t *drive, u8 *buf, u8 sub_cmd)
 {
-	ide_task_t args;
-	struct ide_taskfile *tf = &args.tf;
+	struct ide_cmd cmd;
+	struct ide_taskfile *tf = &cmd.tf;
 
-	memset(&args, 0, sizeof(ide_task_t));
+	memset(&cmd, 0, sizeof(cmd));
 	tf->feature = sub_cmd;
 	tf->nsect   = 0x01;
 	tf->lbam    = ATA_SMART_LBAM_PASS;
 	tf->lbah    = ATA_SMART_LBAH_PASS;
 	tf->command = ATA_CMD_SMART;
-	args.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	args.data_phase	= TASKFILE_IN;
-	(void) smart_enable(drive);
-	return ide_raw_taskfile(drive, &args, buf, 1);
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.protocol = ATA_PROT_PIO;
+
+	return ide_raw_taskfile(drive, &cmd, buf, 1);
 }
 
 static int proc_idedisk_read_cache
@@ -67,6 +67,8 @@ static int proc_idedisk_read_smart(char *page, char **start, off_t off,
 	ide_drive_t	*drive = (ide_drive_t *)data;
 	int		len = 0, i = 0;
 
+	(void)smart_enable(drive);
+
 	if (get_smart_data(drive, page, sub_cmd) == 0) {
 		unsigned short *val = (unsigned short *) page;
 		char *out = (char *)val + SECTOR_SIZE;
diff --git a/drivers/ide/ide-dma-sff.c b/drivers/ide/ide-dma-sff.c
index 123d393..75a9ea2 100644
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -111,7 +111,7 @@ EXPORT_SYMBOL_GPL(ide_dma_host_set);
  *	May also be invoked from trm290.c
  */
 
-int ide_build_dmatable(ide_drive_t *drive, struct request *rq)
+int ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	__le32 *table = (__le32 *)hwif->dmatable_cpu;
@@ -120,11 +120,7 @@ int ide_build_dmatable(ide_drive_t *drive, struct request *rq)
 	struct scatterlist *sg;
 	u8 is_trm290 = !!(hwif->host_flags & IDE_HFLAG_TRM290);
 
-	hwif->sg_nents = ide_build_sglist(drive, rq);
-	if (hwif->sg_nents == 0)
-		return 0;
-
-	for_each_sg(hwif->sg_table, sg, hwif->sg_nents, i) {
+	for_each_sg(hwif->sg_table, sg, cmd->sg_nents, i) {
 		u32 cur_addr, cur_len, xcount, bcount;
 
 		cur_addr = sg_dma_address(sg);
@@ -179,6 +175,7 @@ EXPORT_SYMBOL_GPL(ide_build_dmatable);
 /**
  *	ide_dma_setup	-	begin a DMA phase
  *	@drive: target device
+ *	@cmd: command
  *
  *	Build an IDE DMA PRD (IDE speak for scatter gather table)
  *	and then set up the DMA transfer registers for a device
@@ -189,17 +186,16 @@ EXPORT_SYMBOL_GPL(ide_build_dmatable);
  *	is returned.
  */
 
-int ide_dma_setup(ide_drive_t *drive)
+int ide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->rq;
-	unsigned int reading = rq_data_dir(rq) ? 0 : ATA_DMA_WR;
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+	u8 rw = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 0 : ATA_DMA_WR;
 	u8 dma_stat;
 
 	/* fall back to pio! */
-	if (!ide_build_dmatable(drive, rq)) {
-		ide_map_sg(drive, rq);
+	if (ide_build_dmatable(drive, cmd) == 0) {
+		ide_map_sg(drive, cmd);
 		return 1;
 	}
 
@@ -212,9 +208,9 @@ int ide_dma_setup(ide_drive_t *drive)
 
 	/* specify r/w */
 	if (mmio)
-		writeb(reading, (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+		writeb(rw, (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
 	else
-		outb(reading, hwif->dma_base + ATA_DMA_CMD);
+		outb(rw, hwif->dma_base + ATA_DMA_CMD);
 
 	/* read DMA status for INTR & ERROR flags */
 	dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
@@ -228,7 +224,7 @@ int ide_dma_setup(ide_drive_t *drive)
 EXPORT_SYMBOL_GPL(ide_dma_setup);
 
 /**
- *	dma_timer_expiry	-	handle a DMA timeout
+ *	ide_dma_sff_timer_expiry	-	handle a DMA timeout
  *	@drive: Drive that timed out
  *
  *	An IDE DMA transfer timed out. In the event of an error we ask
@@ -241,7 +237,7 @@ EXPORT_SYMBOL_GPL(ide_dma_setup);
  *	This can occur if an interrupt is lost or due to hang or bugs.
  */
 
-static int dma_timer_expiry(ide_drive_t *drive)
+int ide_dma_sff_timer_expiry(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
@@ -265,14 +261,7 @@ static int dma_timer_expiry(ide_drive_t *drive)
 
 	return 0;	/* Status is unknown -- reset the bus */
 }
-
-void ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
-{
-	/* issue cmd to drive */
-	ide_execute_command(drive, command, &ide_dma_intr, 2 * WAIT_CMD,
-			    dma_timer_expiry);
-}
-EXPORT_SYMBOL_GPL(ide_dma_exec_cmd);
+EXPORT_SYMBOL_GPL(ide_dma_sff_timer_expiry);
 
 void ide_dma_start(ide_drive_t *drive)
 {
@@ -346,10 +335,10 @@ EXPORT_SYMBOL_GPL(ide_dma_test_irq);
 const struct ide_dma_ops sff_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index a878f47..3dbf80c 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -96,9 +96,13 @@ ide_startstop_t ide_dma_intr(ide_drive_t *drive)
 
 	if (OK_STAT(stat, DRIVE_READY, drive->bad_wstat | ATA_DRQ)) {
 		if (!dma_stat) {
-			struct request *rq = hwif->rq;
+			struct ide_cmd *cmd = &hwif->cmd;
 
-			task_end_request(drive, rq, stat);
+			if ((cmd->tf_flags & IDE_TFLAG_FS) == 0)
+				ide_finish_cmd(drive, cmd, stat);
+			else
+				ide_complete_rq(drive, 0,
+						cmd->rq->nr_sectors << 9);
 			return ide_stopped;
 		}
 		printk(KERN_ERR "%s: %s: bad DMA status (0x%02x)\n",
@@ -106,7 +110,6 @@ ide_startstop_t ide_dma_intr(ide_drive_t *drive)
 	}
 	return ide_error(drive, "dma_intr", stat);
 }
-EXPORT_SYMBOL_GPL(ide_dma_intr);
 
 int ide_dma_good_drive(ide_drive_t *drive)
 {
@@ -116,7 +119,7 @@ int ide_dma_good_drive(ide_drive_t *drive)
 /**
  *	ide_build_sglist	-	map IDE scatter gather for DMA I/O
  *	@drive: the drive to build the DMA table for
- *	@rq: the request holding the sg list
+ *	@cmd: command
  *
  *	Perform the DMA mapping magic necessary to access the source or
  *	target buffers of a request via DMA.  The lower layers of the
@@ -124,28 +127,29 @@ int ide_dma_good_drive(ide_drive_t *drive)
  *	operate in a portable fashion.
  */
 
-int ide_build_sglist(ide_drive_t *drive, struct request *rq)
+int ide_build_sglist(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
 	int i;
 
-	ide_map_sg(drive, rq);
+	ide_map_sg(drive, cmd);
 
-	if (rq_data_dir(rq) == READ)
-		hwif->sg_dma_direction = DMA_FROM_DEVICE;
+	if (cmd->tf_flags & IDE_TFLAG_WRITE)
+		cmd->sg_dma_direction = DMA_TO_DEVICE;
 	else
-		hwif->sg_dma_direction = DMA_TO_DEVICE;
-
-	i = dma_map_sg(hwif->dev, sg, hwif->sg_nents, hwif->sg_dma_direction);
-	if (i) {
-		hwif->orig_sg_nents = hwif->sg_nents;
-		hwif->sg_nents = i;
+		cmd->sg_dma_direction = DMA_FROM_DEVICE;
+
+	i = dma_map_sg(hwif->dev, sg, cmd->sg_nents, cmd->sg_dma_direction);
+	if (i == 0)
+		ide_map_sg(drive, cmd);
+	else {
+		cmd->orig_sg_nents = cmd->sg_nents;
+		cmd->sg_nents = i;
 	}
 
 	return i;
 }
-EXPORT_SYMBOL_GPL(ide_build_sglist);
 
 /**
  *	ide_destroy_dmatable	-	clean up DMA mapping
@@ -161,9 +165,10 @@ EXPORT_SYMBOL_GPL(ide_build_sglist);
 void ide_destroy_dmatable(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_cmd *cmd = &hwif->cmd;
 
-	dma_unmap_sg(hwif->dev, hwif->sg_table, hwif->orig_sg_nents,
-		     hwif->sg_dma_direction);
+	dma_unmap_sg(hwif->dev, hwif->sg_table, cmd->orig_sg_nents,
+		     cmd->sg_dma_direction);
 }
 EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
 
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 1231b5e..1166497 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -123,8 +123,18 @@ ide_startstop_t ide_error(ide_drive_t *drive, const char *msg, u8 stat)
 
 	/* retry only "normal" I/O: */
 	if (!blk_fs_request(rq)) {
-		rq->errors = 1;
-		ide_end_drive_cmd(drive, stat, err);
+		if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
+			struct ide_cmd *cmd = rq->special;
+
+			if (cmd)
+				ide_complete_cmd(drive, cmd, stat, err);
+		} else if (blk_pm_request(rq)) {
+			rq->errors = 1;
+			ide_complete_pm_rq(drive, rq);
+			return ide_stopped;
+		}
+		rq->errors = err;
+		ide_complete_rq(drive, err ? -EIO : 0, blk_rq_bytes(rq));
 		return ide_stopped;
 	}
 
@@ -136,8 +146,11 @@ static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
 {
 	struct request *rq = drive->hwif->rq;
 
-	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET)
-		ide_end_request(drive, err ? err : 1, 0);
+	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET) {
+		if (err <= 0 && rq->errors == 0)
+			rq->errors = -EIO;
+		ide_complete_rq(drive, err ? err : 0, ide_rq_bytes(rq));
+	}
 }
 
 /* needed below */
@@ -162,8 +175,7 @@ static ide_startstop_t atapi_reset_pollfunc(ide_drive_t *drive)
 		printk(KERN_INFO "%s: ATAPI reset complete\n", drive->name);
 	else {
 		if (time_before(jiffies, hwif->poll_timeout)) {
-			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20,
-					NULL);
+			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20);
 			/* continue polling */
 			return ide_started;
 		}
@@ -225,7 +237,7 @@ static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
 
 	if (!OK_STAT(tmp, 0, ATA_BUSY)) {
 		if (time_before(jiffies, hwif->poll_timeout)) {
-			ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
+			ide_set_handler(drive, &reset_pollfunc, HZ/20);
 			/* continue polling */
 			return ide_started;
 		}
@@ -342,7 +354,7 @@ static ide_startstop_t do_reset1(ide_drive_t *drive, int do_not_try_atapi)
 		ndelay(400);
 		hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
 		hwif->polling = 1;
-		__ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
+		__ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20);
 		spin_unlock_irqrestore(&hwif->lock, flags);
 		return ide_started;
 	}
@@ -402,7 +414,7 @@ static ide_startstop_t do_reset1(ide_drive_t *drive, int do_not_try_atapi)
 	udelay(10);
 	hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
 	hwif->polling = 1;
-	__ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
+	__ide_set_handler(drive, &reset_pollfunc, HZ/20);
 
 	/*
 	 * Some weird controller like resetting themselves to a strange
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 317ec62..7ae6623 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -61,50 +61,6 @@
  */
 #define IDEFLOPPY_PC_DELAY	(HZ/20)	/* default delay for ZIP 100 (50ms) */
 
-/* Error code returned in rq->errors to the higher part of the driver. */
-#define	IDEFLOPPY_ERROR_GENERAL		101
-
-/*
- * Used to finish servicing a request. For read/write requests, we will call
- * ide_end_request to pass to the next buffer.
- */
-static int ide_floppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
-{
-	struct ide_disk_obj *floppy = drive->driver_data;
-	struct request *rq = drive->hwif->rq;
-	int error;
-
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
-
-	switch (uptodate) {
-	case 0:
-		error = IDEFLOPPY_ERROR_GENERAL;
-		break;
-
-	case 1:
-		error = 0;
-		break;
-
-	default:
-		error = uptodate;
-	}
-
-	if (error)
-		floppy->failed_pc = NULL;
-	/* Why does this happen? */
-	if (!rq)
-		return 0;
-	if (!blk_special_request(rq)) {
-		/* our real local end request function */
-		ide_end_request(drive, uptodate, nsecs);
-		return 0;
-	}
-	rq->errors = error;
-	/* fixme: need to move this local also */
-	ide_end_drive_cmd(drive, 0, 0);
-	return 0;
-}
-
 static void idefloppy_update_buffers(ide_drive_t *drive,
 				struct ide_atapi_pc *pc)
 {
@@ -112,22 +68,23 @@ static void idefloppy_update_buffers(ide_drive_t *drive,
 	struct bio *bio = rq->bio;
 
 	while ((bio = rq->bio) != NULL)
-		ide_floppy_end_request(drive, 1, 0);
+		ide_complete_rq(drive, 0, ide_rq_bytes(rq));
 }
 
-static void ide_floppy_callback(ide_drive_t *drive, int dsc)
+static int ide_floppy_callback(ide_drive_t *drive, int dsc)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
 	struct ide_atapi_pc *pc = drive->pc;
+	struct request *rq = pc->rq;
 	int uptodate = pc->error ? 0 : 1;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
-	if (floppy->failed_pc == pc)
-		floppy->failed_pc = NULL;
+	if (drive->failed_pc == pc)
+		drive->failed_pc = NULL;
 
 	if (pc->c[0] == GPCMD_READ_10 || pc->c[0] == GPCMD_WRITE_10 ||
-	    (pc->rq && blk_pc_request(pc->rq)))
+	    (rq && blk_pc_request(rq)))
 		uptodate = 1; /* FIXME */
 	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {
 		u8 *buf = pc->buf;
@@ -139,19 +96,22 @@ static void ide_floppy_callback(ide_drive_t *drive, int dsc)
 			floppy->progress_indication = buf[15] & 0x80 ?
 				(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
 
-			if (floppy->failed_pc)
-				ide_debug_log(IDE_DBG_PC, "pc = %x, ",
-					      floppy->failed_pc->c[0]);
+			if (drive->failed_pc)
+				ide_debug_log(IDE_DBG_PC, "pc = %x",
+					      drive->failed_pc->c[0]);
 
 			ide_debug_log(IDE_DBG_SENSE, "sense key = %x, asc = %x,"
-				      "ascq = %x\n", floppy->sense_key,
+				      "ascq = %x", floppy->sense_key,
 				      floppy->asc, floppy->ascq);
 		} else
 			printk(KERN_ERR PFX "Error in REQUEST SENSE itself - "
 			       "Aborting request!\n");
 	}
 
-	ide_floppy_end_request(drive, uptodate, 0);
+	if (blk_special_request(rq))
+		rq->errors = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
+
+	return uptodate;
 }
 
 static void ide_floppy_report_error(struct ide_disk_obj *floppy,
@@ -170,14 +130,15 @@ static void ide_floppy_report_error(struct ide_disk_obj *floppy,
 
 }
 
-static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
-		struct ide_atapi_pc *pc)
+static ide_startstop_t ide_floppy_issue_pc(ide_drive_t *drive,
+					   struct ide_cmd *cmd,
+					   struct ide_atapi_pc *pc)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
 
-	if (floppy->failed_pc == NULL &&
+	if (drive->failed_pc == NULL &&
 	    pc->c[0] != GPCMD_REQUEST_SENSE)
-		floppy->failed_pc = pc;
+		drive->failed_pc = pc;
 
 	/* Set the current packet command */
 	drive->pc = pc;
@@ -186,18 +147,18 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		if (!(pc->flags & PC_FLAG_SUPPRESS_ERROR))
 			ide_floppy_report_error(floppy, pc);
 		/* Giving up */
-		pc->error = IDEFLOPPY_ERROR_GENERAL;
+		pc->error = IDE_DRV_ERROR_GENERAL;
 
-		floppy->failed_pc = NULL;
+		drive->failed_pc = NULL;
 		drive->pc_callback(drive, 0);
 		return ide_stopped;
 	}
 
-	ide_debug_log(IDE_DBG_FUNC, "%s: Retry #%d\n", __func__, pc->retries);
+	ide_debug_log(IDE_DBG_FUNC, "retry #%d", pc->retries);
 
 	pc->retries++;
 
-	return ide_issue_pc(drive);
+	return ide_issue_pc(drive, cmd);
 }
 
 void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
@@ -242,8 +203,7 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 	int blocks = rq->nr_sectors / floppy->bs_factor;
 	int cmd = rq_data_dir(rq);
 
-	ide_debug_log(IDE_DBG_FUNC, "%s: block: %d, blocks: %d\n", __func__,
-		      block, blocks);
+	ide_debug_log(IDE_DBG_FUNC, "block: %d, blocks: %d", block, blocks);
 
 	ide_init_pc(pc);
 	pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
@@ -285,34 +245,34 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_cmd cmd;
 	struct ide_atapi_pc *pc;
 
-	ide_debug_log(IDE_DBG_FUNC, "%s: dev: %s, cmd: 0x%x, cmd_type: %x, "
-		      "errors: %d\n",
-		      __func__, rq->rq_disk ? rq->rq_disk->disk_name : "?",
-		      rq->cmd[0], rq->cmd_type, rq->errors);
-
-	ide_debug_log(IDE_DBG_FUNC, "%s: sector: %ld, nr_sectors: %ld, "
-		      "current_nr_sectors: %d\n",
-		      __func__, (long)rq->sector, rq->nr_sectors,
-		      rq->current_nr_sectors);
+	if (drive->debug_mask & IDE_DBG_RQ)
+		blk_dump_rq_flags(rq, (rq->rq_disk
+					? rq->rq_disk->disk_name
+					: "dev?"));
 
 	if (rq->errors >= ERROR_MAX) {
-		if (floppy->failed_pc)
-			ide_floppy_report_error(floppy, floppy->failed_pc);
-		else
+		if (drive->failed_pc) {
+			ide_floppy_report_error(floppy, drive->failed_pc);
+			drive->failed_pc = NULL;
+		} else
 			printk(KERN_ERR PFX "%s: I/O error\n", drive->name);
 
-		ide_floppy_end_request(drive, 0, 0);
-		return ide_stopped;
+		if (blk_special_request(rq)) {
+			rq->errors = 0;
+			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
+			return ide_stopped;
+		} else
+			goto out_end;
 	}
 	if (blk_fs_request(rq)) {
 		if (((long)rq->sector % floppy->bs_factor) ||
 		    (rq->nr_sectors % floppy->bs_factor)) {
 			printk(KERN_ERR PFX "%s: unsupported r/w rq size\n",
 				drive->name);
-			ide_floppy_end_request(drive, 0, 0);
-			return ide_stopped;
+			goto out_end;
 		}
 		pc = &floppy->queued_pc;
 		idefloppy_create_rw_cmd(drive, pc, rq, (unsigned long)block);
@@ -323,21 +283,33 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		idefloppy_blockpc_cmd(floppy, pc, rq);
 	} else {
 		blk_dump_rq_flags(rq, PFX "unsupported command in queue");
-		ide_floppy_end_request(drive, 0, 0);
-		return ide_stopped;
+		goto out_end;
 	}
 
+	memset(&cmd, 0, sizeof(cmd));
+
+	if (rq_data_dir(rq))
+		cmd.tf_flags |= IDE_TFLAG_WRITE;
+
+	cmd.rq = rq;
+
 	if (blk_fs_request(rq) || pc->req_xfer) {
-		ide_init_sg_cmd(drive, rq);
-		ide_map_sg(drive, rq);
+		ide_init_sg_cmd(&cmd, rq->nr_sectors << 9);
+		ide_map_sg(drive, &cmd);
 	}
 
 	pc->sg = hwif->sg_table;
-	pc->sg_cnt = hwif->sg_nents;
+	pc->sg_cnt = cmd.sg_nents;
 
 	pc->rq = rq;
 
-	return idefloppy_issue_pc(drive, pc);
+	return ide_floppy_issue_pc(drive, &cmd, pc);
+out_end:
+	drive->failed_pc = NULL;
+	if (blk_fs_request(rq) == 0 && rq->errors == 0)
+		rq->errors = -EIO;
+	ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
+	return ide_stopped;
 }
 
 /*
@@ -438,8 +410,9 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		length = be16_to_cpup((__be16 *)&pc.buf[desc_start + 6]);
 
 		ide_debug_log(IDE_DBG_PROBE, "Descriptor %d: %dkB, %d blocks, "
-			      "%d sector size\n",
-			      i, blocks * length / 1024, blocks, length);
+					     "%d sector size",
+					     i, blocks * length / 1024,
+					     blocks, length);
 
 		if (i)
 			continue;
@@ -495,8 +468,8 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 				"in drive\n", drive->name);
 			break;
 		}
-		ide_debug_log(IDE_DBG_PROBE, "Descriptor 0 Code: %d\n",
-			      pc.buf[desc_start + 4] & 0x03);
+		ide_debug_log(IDE_DBG_PROBE, "Descriptor 0 Code: %d",
+					     pc.buf[desc_start + 4] & 0x03);
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
@@ -575,6 +548,5 @@ const struct ide_disk_ops ide_atapi_disk_ops = {
 	.init_media	= ide_floppy_init_media,
 	.set_doorlock	= ide_set_media_lock,
 	.do_request	= ide_floppy_do_request,
-	.end_request	= ide_floppy_end_request,
 	.ioctl		= ide_floppy_ioctl,
 };
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 0471094..1aebdf1 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -145,11 +145,6 @@ static ide_startstop_t ide_gd_do_request(ide_drive_t *drive,
 	return drive->disk_ops->do_request(drive, rq, sector);
 }
 
-static int ide_gd_end_request(ide_drive_t *drive, int uptodate, int nrsecs)
-{
-	return drive->disk_ops->end_request(drive, uptodate, nrsecs);
-}
-
 static struct ide_driver ide_gd_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
@@ -162,7 +157,6 @@ static struct ide_driver ide_gd_driver = {
 	.shutdown		= ide_gd_shutdown,
 	.version		= IDE_GD_VERSION,
 	.do_request		= ide_gd_do_request,
-	.end_request		= ide_gd_end_request,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_disk_proc_entries,
 	.proc_devsets		= ide_disk_proc_devsets,
@@ -182,7 +176,7 @@ static int ide_gd_open(struct block_device *bdev, fmode_t mode)
 
 	drive = idkp->drive;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	idkp->openers++;
 
@@ -232,7 +226,7 @@ static int ide_gd_release(struct gendisk *disk, fmode_t mode)
 	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
 	ide_drive_t *drive = idkp->drive;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	if (idkp->openers == 1)
 		drive->disk_ops->flush(drive);
diff --git a/drivers/ide/ide-gd.h b/drivers/ide/ide-gd.h
index b604bdd..5597077 100644
--- a/drivers/ide/ide-gd.h
+++ b/drivers/ide/ide-gd.h
@@ -8,7 +8,7 @@
 #define IDE_GD_DEBUG_LOG	0
 
 #if IDE_GD_DEBUG_LOG
-#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
+#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, ## args)
 #else
 #define ide_debug_log(lvl, fmt, args...) do {} while (0)
 #endif
@@ -20,8 +20,6 @@ struct ide_disk_obj {
 	struct device		dev;
 	unsigned int		openers;	/* protected by BKL for now */
 
-	/* Last failed packet command */
-	struct ide_atapi_pc *failed_pc;
 	/* used for blk_{fs,pc}_request() requests */
 	struct ide_atapi_pc queued_pc;
 
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 81a5282..9d03e82 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -32,6 +32,10 @@ static int probe_mask;
 module_param(probe_mask, int, 0);
 MODULE_PARM_DESC(probe_mask, "probe mask for legacy ISA IDE ports");
 
+static const struct ide_port_info ide_generic_port_info = {
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static ssize_t store_add(struct class *cls, const char *buf, size_t n)
 {
 	unsigned int base, ctl;
@@ -46,7 +50,7 @@ static ssize_t store_add(struct class *cls, const char *buf, size_t n)
 	hw.irq = irq;
 	hw.chipset = ide_generic;
 
-	rc = ide_host_add(NULL, hws, NULL);
+	rc = ide_host_add(&ide_generic_port_info, hws, NULL);
 	if (rc)
 		return rc;
 
@@ -184,7 +188,7 @@ static int __init ide_generic_init(void)
 #endif
 			hw.chipset = ide_generic;
 
-			rc = ide_host_add(NULL, hws, NULL);
+			rc = ide_host_add(&ide_generic_port_info, hws, NULL);
 			if (rc) {
 				release_region(io_addr + 0x206, 1);
 				release_region(io_addr, 8);
diff --git a/drivers/ide/ide-h8300.c b/drivers/ide/ide-h8300.c
index 9270d32..ff8339e 100644
--- a/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -44,53 +44,53 @@ static u16 mm_inw(unsigned long a)
 	return r;
 }
 
-static void h8300_tf_load(ide_drive_t *drive, ide_task_t *task)
+static void h8300_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+	struct ide_taskfile *tf = &cmd->tf;
+	u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
+	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA)
 		mm_outw((tf->hob_data << 8) | tf->data, io_ports->data_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
 		outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
 		outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
 		outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
 		outb(tf->hob_lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
 		outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
 		outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
 		outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
 		outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
 		outb(tf->lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
 		outb((tf->device & HIHI) | drive->select,
 		     io_ports->device_addr);
 }
 
-static void h8300_tf_read(ide_drive_t *drive, ide_task_t *task)
+static void h8300_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data = mm_inw(io_ports->data_addr);
 
 		tf->data = data & 0xff;
@@ -100,31 +100,31 @@ static void h8300_tf_read(ide_drive_t *drive, ide_task_t *task)
 	/* be sure we're looking at the low order bits */
 	outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
 		tf->feature = inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
 		tf->lbal   = inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
 		tf->lbam   = inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
 		tf->lbah   = inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
 		tf->device = inb(io_ports->device_addr);
 
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
+	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
 		outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
 			tf->hob_nsect   = inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
 			tf->hob_lbal    = inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
 			tf->hob_lbam    = inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
 			tf->hob_lbah    = inb(io_ports->lbah_addr);
 	}
 }
@@ -143,13 +143,13 @@ static void mm_insw(unsigned long addr, void *buf, u32 len)
 		*bp = bswap(*(volatile u16 *)addr);
 }
 
-static void h8300_input_data(ide_drive_t *drive, struct request *rq,
+static void h8300_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 			     void *buf, unsigned int len)
 {
 	mm_insw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
 }
 
-static void h8300_output_data(ide_drive_t *drive, struct request *rq,
+static void h8300_output_data(ide_drive_t *drive, struct ide_cmd *cmd,
 			      void *buf, unsigned int len)
 {
 	mm_outsw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
diff --git a/drivers/ide/ide-io-std.c b/drivers/ide/ide-io-std.c
index 45b43dd..2d9c6dc 100644
--- a/drivers/ide/ide-io-std.c
+++ b/drivers/ide/ide-io-std.c
@@ -2,6 +2,13 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
 
+#if defined(CONFIG_ARM) || defined(CONFIG_M68K) || defined(CONFIG_MIPS) || \
+    defined(CONFIG_PARISC) || defined(CONFIG_PPC) || defined(CONFIG_SPARC)
+#include <asm/ide.h>
+#else
+#include <asm-generic/ide_iops.h>
+#endif
+
 /*
  *	Conventional PIO operations for ATA devices
  */
@@ -75,24 +82,24 @@ void ide_set_irq(ide_hwif_t *hwif, int on)
 }
 EXPORT_SYMBOL_GPL(ide_set_irq);
 
-void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+void ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 	void (*tf_outb)(u8 addr, unsigned long port);
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+	u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
 	if (mmio)
 		tf_outb = ide_mm_outb;
 	else
 		tf_outb = ide_outb;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA) {
 		u16 data = (tf->hob_data << 8) | tf->data;
 
 		if (mmio)
@@ -101,39 +108,39 @@ void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
 			outw(data, io_ports->data_addr);
 	}
 
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		tf_outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
 		tf_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
 		tf_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
 		tf_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
 		tf_outb(tf->hob_lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
 		tf_outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
 		tf_outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
 		tf_outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
 		tf_outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
 		tf_outb(tf->lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
 		tf_outb((tf->device & HIHI) | drive->select,
 			 io_ports->device_addr);
 }
 EXPORT_SYMBOL_GPL(ide_tf_load);
 
-void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+void ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 	void (*tf_outb)(u8 addr, unsigned long port);
 	u8 (*tf_inb)(unsigned long port);
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
@@ -146,7 +153,7 @@ void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 		tf_inb  = ide_inb;
 	}
 
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data;
 
 		if (mmio)
@@ -161,31 +168,31 @@ void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 	/* be sure we're looking at the low order bits */
 	tf_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
 		tf->feature = tf_inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = tf_inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
 		tf->lbal   = tf_inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
 		tf->lbam   = tf_inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
 		tf->lbah   = tf_inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
 		tf->device = tf_inb(io_ports->device_addr);
 
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
+	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
 		tf_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = tf_inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
 			tf->hob_nsect   = tf_inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
 			tf->hob_lbal    = tf_inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
 			tf->hob_lbam    = tf_inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
 			tf->hob_lbah    = tf_inb(io_ports->lbah_addr);
 	}
 }
@@ -212,7 +219,7 @@ static void ata_vlb_sync(unsigned long port)
  * so if an odd len is specified, be sure that there's at least one
  * extra byte allocated for the buffer.
  */
-void ide_input_data(ide_drive_t *drive, struct request *rq, void *buf,
+void ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd, void *buf,
 		    unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -258,7 +265,7 @@ EXPORT_SYMBOL_GPL(ide_input_data);
 /*
  * This is used for most PIO data transfers *to* the IDE interface
  */
-void ide_output_data(ide_drive_t *drive, struct request *rq, void *buf,
+void ide_output_data(ide_drive_t *drive, struct ide_cmd *cmd, void *buf,
 		     unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 2e92497..1adc5e2 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -40,7 +40,6 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
-#include <linux/hdreg.h>
 #include <linux/completion.h>
 #include <linux/reboot.h>
 #include <linux/cdrom.h>
@@ -55,25 +54,9 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-static int __ide_end_request(ide_drive_t *drive, struct request *rq,
-			     int uptodate, unsigned int nr_bytes, int dequeue)
+int ide_end_rq(ide_drive_t *drive, struct request *rq, int error,
+	       unsigned int nr_bytes)
 {
-	int ret = 1;
-	int error = 0;
-
-	if (uptodate <= 0)
-		error = uptodate ? uptodate : -EIO;
-
-	/*
-	 * if failfast is set on a request, override number of sectors and
-	 * complete the whole request right now
-	 */
-	if (blk_noretry_request(rq) && error)
-		nr_bytes = rq->hard_nr_sectors << 9;
-
-	if (!blk_fs_request(rq) && error && !rq->errors)
-		rq->errors = -EIO;
-
 	/*
 	 * decide whether to reenable DMA -- 3 is a random magic for now,
 	 * if we DMA timeout more than 3 times, just stay in PIO
@@ -84,127 +67,86 @@ static int __ide_end_request(ide_drive_t *drive, struct request *rq,
 		ide_dma_on(drive);
 	}
 
-	if (!blk_end_request(rq, error, nr_bytes))
-		ret = 0;
-
-	if (ret == 0 && dequeue)
-		drive->hwif->rq = NULL;
-
-	return ret;
+	return blk_end_request(rq, error, nr_bytes);
 }
+EXPORT_SYMBOL_GPL(ide_end_rq);
 
-/**
- *	ide_end_request		-	complete an IDE I/O
- *	@drive: IDE device for the I/O
- *	@uptodate:
- *	@nr_sectors: number of sectors completed
- *
- *	This is our end_request wrapper function. We complete the I/O
- *	update random number input and dequeue the request, which if
- *	it was tagged may be out of order.
- */
-
-int ide_end_request (ide_drive_t *drive, int uptodate, int nr_sectors)
+void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 {
-	unsigned int nr_bytes = nr_sectors << 9;
-	struct request *rq = drive->hwif->rq;
-
-	if (!nr_bytes) {
-		if (blk_pc_request(rq))
-			nr_bytes = rq->data_len;
-		else
-			nr_bytes = rq->hard_cur_sectors << 9;
+	struct ide_taskfile *tf = &cmd->tf;
+	struct request *rq = cmd->rq;
+	u8 tf_cmd = tf->command;
+
+	tf->error = err;
+	tf->status = stat;
+
+	drive->hwif->tp_ops->tf_read(drive, cmd);
+
+	if ((cmd->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) &&
+	    tf_cmd == ATA_CMD_IDLEIMMEDIATE) {
+		if (tf->lbal != 0xc4) {
+			printk(KERN_ERR "%s: head unload failed!\n",
+			       drive->name);
+			ide_tf_dump(drive->name, tf);
+		} else
+			drive->dev_flags |= IDE_DFLAG_PARKED;
 	}
 
-	return __ide_end_request(drive, rq, uptodate, nr_bytes, 1);
-}
-EXPORT_SYMBOL(ide_end_request);
+	if (rq && rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
+		memcpy(rq->special, cmd, sizeof(*cmd));
 
-/**
- *	ide_end_dequeued_request	-	complete an IDE I/O
- *	@drive: IDE device for the I/O
- *	@uptodate:
- *	@nr_sectors: number of sectors completed
- *
- *	Complete an I/O that is no longer on the request queue. This
- *	typically occurs when we pull the request and issue a REQUEST_SENSE.
- *	We must still finish the old request but we must not tamper with the
- *	queue in the meantime.
- *
- *	NOTE: This path does not handle barrier, but barrier is not supported
- *	on ide-cd anyway.
- */
+	if (cmd->tf_flags & IDE_TFLAG_DYN)
+		kfree(cmd);
+}
 
-int ide_end_dequeued_request(ide_drive_t *drive, struct request *rq,
-			     int uptodate, int nr_sectors)
+/* obsolete, blk_rq_bytes() should be used instead */
+unsigned int ide_rq_bytes(struct request *rq)
 {
-	BUG_ON(!blk_rq_started(rq));
-
-	return __ide_end_request(drive, rq, uptodate, nr_sectors << 9, 0);
+	if (blk_pc_request(rq))
+		return rq->data_len;
+	else
+		return rq->hard_cur_sectors << 9;
 }
-EXPORT_SYMBOL_GPL(ide_end_dequeued_request);
+EXPORT_SYMBOL_GPL(ide_rq_bytes);
 
-/**
- *	ide_end_drive_cmd	-	end an explicit drive command
- *	@drive: command 
- *	@stat: status bits
- *	@err: error bits
- *
- *	Clean up after success/failure of an explicit drive command.
- *	These get thrown onto the queue so they are synchronized with
- *	real I/O operations on the drive.
- *
- *	In LBA48 mode we have to read the register set twice to get
- *	all the extra information out.
- */
- 
-void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
+int ide_complete_rq(ide_drive_t *drive, int error, unsigned int nr_bytes)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
+	int rc;
 
-	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
-		ide_task_t *task = (ide_task_t *)rq->special;
-
-		if (task) {
-			struct ide_taskfile *tf = &task->tf;
-
-			tf->error = err;
-			tf->status = stat;
-
-			drive->hwif->tp_ops->tf_read(drive, task);
-
-			if (task->tf_flags & IDE_TFLAG_DYN)
-				kfree(task);
-		}
-	} else if (blk_pm_request(rq)) {
-		struct request_pm_state *pm = rq->data;
-
-		ide_complete_power_step(drive, rq);
-		if (pm->pm_step == IDE_PM_COMPLETED)
-			ide_complete_pm_request(drive, rq);
-		return;
-	}
-
-	hwif->rq = NULL;
+	/*
+	 * if failfast is set on a request, override number of sectors
+	 * and complete the whole request right now
+	 */
+	if (blk_noretry_request(rq) && error <= 0)
+		nr_bytes = rq->hard_nr_sectors << 9;
 
-	rq->errors = err;
+	rc = ide_end_rq(drive, rq, error, nr_bytes);
+	if (rc == 0)
+		hwif->rq = NULL;
 
-	if (unlikely(blk_end_request(rq, (rq->errors ? -EIO : 0),
-				     blk_rq_bytes(rq))))
-		BUG();
+	return rc;
 }
-EXPORT_SYMBOL(ide_end_drive_cmd);
+EXPORT_SYMBOL(ide_complete_rq);
 
 void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 {
-	if (rq->rq_disk) {
-		struct ide_driver *drv;
+	u8 drv_req = blk_special_request(rq) && rq->rq_disk;
+	u8 media = drive->media;
 
-		drv = *(struct ide_driver **)rq->rq_disk->private_data;
-		drv->end_request(drive, 0, 0);
-	} else
-		ide_end_request(drive, 0, 0);
+	drive->failed_pc = NULL;
+
+	if ((media == ide_floppy || media == ide_tape) && drv_req) {
+		rq->errors = 0;
+		ide_complete_rq(drive, 0, blk_rq_bytes(rq));
+	} else {
+		if (media == ide_tape)
+			rq->errors = IDE_DRV_ERROR_GENERAL;
+		else if (blk_fs_request(rq) == 0 && rq->errors == 0)
+			rq->errors = -EIO;
+		ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
+	}
 }
 
 static void ide_tf_set_specify_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
@@ -232,20 +174,20 @@ static void ide_tf_set_setmult_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 static ide_startstop_t ide_disk_special(ide_drive_t *drive)
 {
 	special_t *s = &drive->special;
-	ide_task_t args;
+	struct ide_cmd cmd;
 
-	memset(&args, 0, sizeof(ide_task_t));
-	args.data_phase = TASKFILE_NO_DATA;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.protocol = ATA_PROT_NODATA;
 
 	if (s->b.set_geometry) {
 		s->b.set_geometry = 0;
-		ide_tf_set_specify_cmd(drive, &args.tf);
+		ide_tf_set_specify_cmd(drive, &cmd.tf);
 	} else if (s->b.recalibrate) {
 		s->b.recalibrate = 0;
-		ide_tf_set_restore_cmd(drive, &args.tf);
+		ide_tf_set_restore_cmd(drive, &cmd.tf);
 	} else if (s->b.set_multmode) {
 		s->b.set_multmode = 0;
-		ide_tf_set_setmult_cmd(drive, &args.tf);
+		ide_tf_set_setmult_cmd(drive, &cmd.tf);
 	} else if (s->all) {
 		int special = s->all;
 		s->all = 0;
@@ -253,10 +195,10 @@ static ide_startstop_t ide_disk_special(ide_drive_t *drive)
 		return ide_stopped;
 	}
 
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE |
-			IDE_TFLAG_CUSTOM_HANDLER;
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE |
+		       IDE_TFLAG_CUSTOM_HANDLER;
 
-	do_rw_taskfile(drive, &args);
+	do_rw_taskfile(drive, &cmd);
 
 	return ide_started;
 }
@@ -286,33 +228,29 @@ static ide_startstop_t do_special (ide_drive_t *drive)
 	return ide_stopped;
 }
 
-void ide_map_sg(ide_drive_t *drive, struct request *rq)
+void ide_map_sg(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
+	struct request *rq = cmd->rq;
 
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
-		hwif->sg_nents = 1;
+		cmd->sg_nents = 1;
 	} else if (!rq->bio) {
 		sg_init_one(sg, rq->data, rq->data_len);
-		hwif->sg_nents = 1;
-	} else {
-		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
-	}
+		cmd->sg_nents = 1;
+	} else
+		cmd->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
 }
-
 EXPORT_SYMBOL_GPL(ide_map_sg);
 
-void ide_init_sg_cmd(ide_drive_t *drive, struct request *rq)
+void ide_init_sg_cmd(struct ide_cmd *cmd, unsigned int nr_bytes)
 {
-	ide_hwif_t *hwif = drive->hwif;
-
-	hwif->nsect = hwif->nleft = rq->nr_sectors;
-	hwif->cursg_ofs = 0;
-	hwif->cursg = NULL;
+	cmd->nbytes = cmd->nleft = nr_bytes;
+	cmd->cursg_ofs = 0;
+	cmd->cursg = NULL;
 }
-
 EXPORT_SYMBOL_GPL(ide_init_sg_cmd);
 
 /**
@@ -330,24 +268,15 @@ EXPORT_SYMBOL_GPL(ide_init_sg_cmd);
 static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 		struct request *rq)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	ide_task_t *task = rq->special;
-
-	if (task) {
-		hwif->data_phase = task->data_phase;
-
-		switch (hwif->data_phase) {
-		case TASKFILE_MULTI_OUT:
-		case TASKFILE_OUT:
-		case TASKFILE_MULTI_IN:
-		case TASKFILE_IN:
-			ide_init_sg_cmd(drive, rq);
-			ide_map_sg(drive, rq);
-		default:
-			break;
+	struct ide_cmd *cmd = rq->special;
+
+	if (cmd) {
+		if (cmd->protocol == ATA_PROT_PIO) {
+			ide_init_sg_cmd(cmd, rq->nr_sectors << 9);
+			ide_map_sg(drive, cmd);
 		}
 
-		return do_rw_taskfile(drive, task);
+		return do_rw_taskfile(drive, cmd);
 	}
 
  	/*
@@ -357,8 +286,8 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 #ifdef DEBUG
  	printk("%s: DRIVE_CMD (null)\n", drive->name);
 #endif
-	ide_end_drive_cmd(drive, hwif->tp_ops->read_status(hwif),
-			  ide_read_error(drive));
+	rq->errors = 0;
+	ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 
  	return ide_stopped;
 }
@@ -376,9 +305,7 @@ static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 	case REQ_DRIVE_RESET:
 		return ide_do_reset(drive);
 	default:
-		blk_dump_rq_flags(rq, "ide_special_rq - bad request");
-		ide_end_request(drive, 0, 0);
-		return ide_stopped;
+		BUG();
 	}
 }
 
@@ -438,7 +365,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 			startstop = ide_start_power_step(drive, rq);
 			if (startstop == ide_stopped &&
 			    pm->pm_step == IDE_PM_COMPLETED)
-				ide_complete_pm_request(drive, rq);
+				ide_complete_pm_rq(drive, rq);
 			return startstop;
 		} else if (!rq->rq_disk && blk_special_request(rq))
 			/*
@@ -501,8 +428,8 @@ static inline int ide_lock_host(struct ide_host *host, ide_hwif_t *hwif)
 	if (host->host_flags & IDE_HFLAG_SERIALIZE) {
 		rc = test_and_set_bit_lock(IDE_HOST_BUSY, &host->host_busy);
 		if (rc == 0) {
-			/* for atari only */
-			ide_get_lock(ide_intr, hwif);
+			if (host->get_lock)
+				host->get_lock(ide_intr, hwif);
 		}
 	}
 	return rc;
@@ -511,8 +438,8 @@ static inline int ide_lock_host(struct ide_host *host, ide_hwif_t *hwif)
 static inline void ide_unlock_host(struct ide_host *host)
 {
 	if (host->host_flags & IDE_HFLAG_SERIALIZE) {
-		/* for atari only */
-		ide_release_lock();
+		if (host->release_lock)
+			host->release_lock();
 		clear_bit_unlock(IDE_HOST_BUSY, &host->host_busy);
 	}
 }
@@ -724,6 +651,7 @@ void ide_timer_expiry (unsigned long data)
 			}
 		}
 		hwif->handler = NULL;
+		hwif->expiry = NULL;
 		/*
 		 * We need to simulate a real interrupt when invoking
 		 * the handler() function, which means we need to
@@ -739,7 +667,8 @@ void ide_timer_expiry (unsigned long data)
 		} else if (drive_is_ready(drive)) {
 			if (drive->waiting_for_dma)
 				hwif->dma_ops->dma_lost_irq(drive);
-			(void)ide_ack_intr(hwif);
+			if (hwif->ack_intr)
+				hwif->ack_intr(hwif);
 			printk(KERN_WARNING "%s: lost interrupt\n",
 				drive->name);
 			startstop = handler(drive);
@@ -840,6 +769,7 @@ static void unexpected_intr(int irq, ide_hwif_t *hwif)
 irqreturn_t ide_intr (int irq, void *dev_id)
 {
 	ide_hwif_t *hwif = (ide_hwif_t *)dev_id;
+	struct ide_host *host = hwif->host;
 	ide_drive_t *uninitialized_var(drive);
 	ide_handler_t *handler;
 	unsigned long flags;
@@ -847,14 +777,14 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 	irqreturn_t irq_ret = IRQ_NONE;
 	int plug_device = 0;
 
-	if (hwif->host->host_flags & IDE_HFLAG_SERIALIZE) {
-		if (hwif != hwif->host->cur_port)
+	if (host->host_flags & IDE_HFLAG_SERIALIZE) {
+		if (hwif != host->cur_port)
 			goto out_early;
 	}
 
 	spin_lock_irqsave(&hwif->lock, flags);
 
-	if (!ide_ack_intr(hwif))
+	if (hwif->ack_intr && hwif->ack_intr(hwif) == 0)
 		goto out;
 
 	handler = hwif->handler;
@@ -871,27 +801,19 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 		 *
 		 * For PCI, we cannot tell the difference,
 		 * so in that case we just ignore it and hope it goes away.
-		 *
-		 * FIXME: unexpected_intr should be hwif-> then we can
-		 * remove all the ifdef PCI crap
 		 */
-#ifdef CONFIG_BLK_DEV_IDEPCI
-		if (hwif->chipset != ide_pci)
-#endif	/* CONFIG_BLK_DEV_IDEPCI */
-		{
+		if ((host->irq_flags & IRQF_SHARED) == 0) {
 			/*
 			 * Probably not a shared PCI interrupt,
 			 * so we can safely try to do something about it:
 			 */
 			unexpected_intr(irq, hwif);
-#ifdef CONFIG_BLK_DEV_IDEPCI
 		} else {
 			/*
 			 * Whack the status register, just in case
 			 * we have a leftover pending IRQ.
 			 */
 			(void)hwif->tp_ops->read_status(hwif);
-#endif /* CONFIG_BLK_DEV_IDEPCI */
 		}
 		goto out;
 	}
@@ -909,6 +831,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 		goto out;
 
 	hwif->handler = NULL;
+	hwif->expiry = NULL;
 	hwif->req_gen++;
 	del_timer(&hwif->timer);
 	spin_unlock(&hwif->lock);
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index 1be263e..7701427 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -111,13 +111,13 @@ static int ide_set_nice_ioctl(ide_drive_t *drive, unsigned long arg)
 	return 0;
 }
 
-static int ide_cmd_ioctl(ide_drive_t *drive, unsigned cmd, unsigned long arg)
+static int ide_cmd_ioctl(ide_drive_t *drive, unsigned long arg)
 {
 	u8 *buf = NULL;
 	int bufsize = 0, err = 0;
 	u8 args[4], xfer_rate = 0;
-	ide_task_t tfargs;
-	struct ide_taskfile *tf = &tfargs.tf;
+	struct ide_cmd cmd;
+	struct ide_taskfile *tf = &cmd.tf;
 	u16 *id = drive->id;
 
 	if (NULL == (void *) arg) {
@@ -134,24 +134,24 @@ static int ide_cmd_ioctl(ide_drive_t *drive, unsigned cmd, unsigned long arg)
 	if (copy_from_user(args, (void __user *)arg, 4))
 		return -EFAULT;
 
-	memset(&tfargs, 0, sizeof(ide_task_t));
+	memset(&cmd, 0, sizeof(cmd));
 	tf->feature = args[2];
 	if (args[0] == ATA_CMD_SMART) {
 		tf->nsect = args[3];
 		tf->lbal  = args[1];
 		tf->lbam  = 0x4f;
 		tf->lbah  = 0xc2;
-		tfargs.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_IN_NSECT;
+		cmd.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_IN_NSECT;
 	} else {
 		tf->nsect = args[1];
-		tfargs.tf_flags = IDE_TFLAG_OUT_FEATURE |
-				  IDE_TFLAG_OUT_NSECT | IDE_TFLAG_IN_NSECT;
+		cmd.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT |
+			       IDE_TFLAG_IN_NSECT;
 	}
 	tf->command = args[0];
-	tfargs.data_phase = args[3] ? TASKFILE_IN : TASKFILE_NO_DATA;
+	cmd.protocol = args[3] ? ATA_PROT_PIO : ATA_PROT_NODATA;
 
 	if (args[3]) {
-		tfargs.tf_flags |= IDE_TFLAG_IO_16BIT;
+		cmd.tf_flags |= IDE_TFLAG_IO_16BIT;
 		bufsize = SECTOR_SIZE * args[3];
 		buf = kzalloc(bufsize, GFP_KERNEL);
 		if (buf == NULL)
@@ -172,7 +172,7 @@ static int ide_cmd_ioctl(ide_drive_t *drive, unsigned cmd, unsigned long arg)
 		}
 	}
 
-	err = ide_raw_taskfile(drive, &tfargs, buf, args[3]);
+	err = ide_raw_taskfile(drive, &cmd, buf, args[3]);
 
 	args[0] = tf->status;
 	args[1] = tf->error;
@@ -194,25 +194,25 @@ abort:
 	return err;
 }
 
-static int ide_task_ioctl(ide_drive_t *drive, unsigned cmd, unsigned long arg)
+static int ide_task_ioctl(ide_drive_t *drive, unsigned long arg)
 {
 	void __user *p = (void __user *)arg;
 	int err = 0;
 	u8 args[7];
-	ide_task_t task;
+	struct ide_cmd cmd;
 
 	if (copy_from_user(args, p, 7))
 		return -EFAULT;
 
-	memset(&task, 0, sizeof(task));
-	memcpy(&task.tf_array[7], &args[1], 6);
-	task.tf.command = args[0];
-	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	memset(&cmd, 0, sizeof(cmd));
+	memcpy(&cmd.tf_array[7], &args[1], 6);
+	cmd.tf.command = args[0];
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-	err = ide_no_data_taskfile(drive, &task);
+	err = ide_no_data_taskfile(drive, &cmd);
 
-	args[0] = task.tf.command;
-	memcpy(&args[1], &task.tf_array[7], 6);
+	args[0] = cmd.tf.command;
+	memcpy(&args[1], &cmd.tf_array[7], 6);
 
 	if (copy_to_user(p, args, 7))
 		err = -EFAULT;
@@ -262,17 +262,17 @@ int generic_ide_ioctl(ide_drive_t *drive, struct block_device *bdev,
 		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 			return -EACCES;
 		if (drive->media == ide_disk)
-			return ide_taskfile_ioctl(drive, cmd, arg);
+			return ide_taskfile_ioctl(drive, arg);
 		return -ENOMSG;
 #endif
 	case HDIO_DRIVE_CMD:
 		if (!capable(CAP_SYS_RAWIO))
 			return -EACCES;
-		return ide_cmd_ioctl(drive, cmd, arg);
+		return ide_cmd_ioctl(drive, arg);
 	case HDIO_DRIVE_TASK:
 		if (!capable(CAP_SYS_RAWIO))
 			return -EACCES;
-		return ide_task_ioctl(drive, cmd, arg);
+		return ide_task_ioctl(drive, arg);
 	case HDIO_DRIVE_RESET:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 317c5da..5403e4a 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -31,15 +31,15 @@ void SELECT_DRIVE(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
-	ide_task_t task;
+	struct ide_cmd cmd;
 
 	if (port_ops && port_ops->selectproc)
 		port_ops->selectproc(drive);
 
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_OUT_DEVICE;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_OUT_DEVICE;
 
-	drive->hwif->tp_ops->tf_load(drive, &task);
+	drive->hwif->tp_ops->tf_load(drive, &cmd);
 }
 
 void SELECT_MASK(ide_drive_t *drive, int mask)
@@ -52,14 +52,14 @@ void SELECT_MASK(ide_drive_t *drive, int mask)
 
 u8 ide_read_error(ide_drive_t *drive)
 {
-	ide_task_t task;
+	struct ide_cmd cmd;
 
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_IN_FEATURE;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_IN_FEATURE;
 
-	drive->hwif->tp_ops->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &cmd);
 
-	return task.tf.error;
+	return cmd.tf.error;
 }
 EXPORT_SYMBOL_GPL(ide_read_error);
 
@@ -329,7 +329,7 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 	u16 *id = drive->id, i;
 	int error = 0;
 	u8 stat;
-	ide_task_t task;
+	struct ide_cmd cmd;
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	if (hwif->dma_ops)	/* check if host supports DMA */
@@ -361,12 +361,12 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 	udelay(1);
 	tp_ops->set_irq(hwif, 0);
 
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT;
-	task.tf.feature = SETFEATURES_XFER;
-	task.tf.nsect   = speed;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT;
+	cmd.tf.feature = SETFEATURES_XFER;
+	cmd.tf.nsect   = speed;
 
-	tp_ops->tf_load(drive, &task);
+	tp_ops->tf_load(drive, &cmd);
 
 	tp_ops->exec_command(hwif, ATA_CMD_SET_FEATURES);
 
@@ -425,26 +425,25 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
  * See also ide_execute_command
  */
 void __ide_set_handler(ide_drive_t *drive, ide_handler_t *handler,
-		       unsigned int timeout, ide_expiry_t *expiry)
+		       unsigned int timeout)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
 	BUG_ON(hwif->handler);
 	hwif->handler		= handler;
-	hwif->expiry		= expiry;
 	hwif->timer.expires	= jiffies + timeout;
 	hwif->req_gen_timer	= hwif->req_gen;
 	add_timer(&hwif->timer);
 }
 
-void ide_set_handler (ide_drive_t *drive, ide_handler_t *handler,
-		      unsigned int timeout, ide_expiry_t *expiry)
+void ide_set_handler(ide_drive_t *drive, ide_handler_t *handler,
+		     unsigned int timeout)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hwif->lock, flags);
-	__ide_set_handler(drive, handler, timeout, expiry);
+	__ide_set_handler(drive, handler, timeout);
 	spin_unlock_irqrestore(&hwif->lock, flags);
 }
 EXPORT_SYMBOL(ide_set_handler);
@@ -452,10 +451,9 @@ EXPORT_SYMBOL(ide_set_handler);
 /**
  *	ide_execute_command	-	execute an IDE command
  *	@drive: IDE drive to issue the command against
- *	@command: command byte to write
+ *	@cmd: command
  *	@handler: handler for next phase
  *	@timeout: timeout for command
- *	@expiry:  handler to run on timeout
  *
  *	Helper function to issue an IDE command. This handles the
  *	atomicity requirements, command timing and ensures that the
@@ -463,15 +461,18 @@ EXPORT_SYMBOL(ide_set_handler);
  *	should go via this function or do equivalent locking.
  */
 
-void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
-			 unsigned timeout, ide_expiry_t *expiry)
+void ide_execute_command(ide_drive_t *drive, struct ide_cmd *cmd,
+			 ide_handler_t *handler, unsigned timeout)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hwif->lock, flags);
-	__ide_set_handler(drive, handler, timeout, expiry);
-	hwif->tp_ops->exec_command(hwif, cmd);
+	if ((cmd->protocol != ATAPI_PROT_DMA &&
+	     cmd->protocol != ATAPI_PROT_PIO) ||
+	    (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT))
+		__ide_set_handler(drive, handler, timeout);
+	hwif->tp_ops->exec_command(hwif, cmd->tf.command);
 	/*
 	 * Drive takes 400nS to respond, we must avoid the IRQ being
 	 * serviced before that.
@@ -481,19 +482,6 @@ void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
 	ndelay(400);
 	spin_unlock_irqrestore(&hwif->lock, flags);
 }
-EXPORT_SYMBOL(ide_execute_command);
-
-void ide_execute_pkt_cmd(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	unsigned long flags;
-
-	spin_lock_irqsave(&hwif->lock, flags);
-	hwif->tp_ops->exec_command(hwif, ATA_CMD_PACKET);
-	ndelay(400);
-	spin_unlock_irqrestore(&hwif->lock, flags);
-}
-EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
 
 /*
  * ide_wait_not_busy() waits for the currently selected device on the hwif
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index f6c683d..217b7fd 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -34,19 +34,19 @@ void ide_toggle_bounce(ide_drive_t *drive, int on)
 static void ide_dump_opcode(ide_drive_t *drive)
 {
 	struct request *rq = drive->hwif->rq;
-	ide_task_t *task = NULL;
+	struct ide_cmd *cmd = NULL;
 
 	if (!rq)
 		return;
 
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
-		task = rq->special;
+		cmd = rq->special;
 
 	printk(KERN_ERR "ide: failed opcode was: ");
-	if (task == NULL)
+	if (cmd == NULL)
 		printk(KERN_CONT "unknown\n");
 	else
-		printk(KERN_CONT "0x%02x\n", task->tf.command);
+		printk(KERN_CONT "0x%02x\n", cmd->tf.command);
 }
 
 u64 ide_get_lba_addr(struct ide_taskfile *tf, int lba48)
@@ -66,18 +66,18 @@ EXPORT_SYMBOL_GPL(ide_get_lba_addr);
 
 static void ide_dump_sector(ide_drive_t *drive)
 {
-	ide_task_t task;
-	struct ide_taskfile *tf = &task.tf;
+	struct ide_cmd cmd;
+	struct ide_taskfile *tf = &cmd.tf;
 	u8 lba48 = !!(drive->dev_flags & IDE_DFLAG_LBA48);
 
-	memset(&task, 0, sizeof(task));
+	memset(&cmd, 0, sizeof(cmd));
 	if (lba48)
-		task.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_HOB_LBA |
+		cmd.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_HOB_LBA |
 				IDE_TFLAG_LBA48;
 	else
-		task.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_DEVICE;
+		cmd.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_DEVICE;
 
-	drive->hwif->tp_ops->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &cmd);
 
 	if (lba48 || (tf->device & ATA_LBA))
 		printk(KERN_CONT ", LBAsect=%llu",
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index f30e521..9490b44 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -1,6 +1,5 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
-#include <linux/hdreg.h>
 #include <linux/jiffies.h>
 #include <linux/blkdev.h>
 
@@ -63,10 +62,10 @@ out:
 
 ide_startstop_t ide_do_park_unpark(ide_drive_t *drive, struct request *rq)
 {
-	ide_task_t task;
-	struct ide_taskfile *tf = &task.tf;
+	struct ide_cmd cmd;
+	struct ide_taskfile *tf = &cmd.tf;
 
-	memset(&task, 0, sizeof(task));
+	memset(&cmd, 0, sizeof(cmd));
 	if (rq->cmd[0] == REQ_PARK_HEADS) {
 		drive->sleep = *(unsigned long *)rq->special;
 		drive->dev_flags |= IDE_DFLAG_SLEEPING;
@@ -75,14 +74,16 @@ ide_startstop_t ide_do_park_unpark(ide_drive_t *drive, struct request *rq)
 		tf->lbal = 0x4c;
 		tf->lbam = 0x4e;
 		tf->lbah = 0x55;
-		task.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
+		cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	} else		/* cmd == REQ_UNPARK_HEADS */
 		tf->command = ATA_CMD_CHK_POWER;
 
-	task.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	task.rq = rq;
-	drive->hwif->data_phase = task.data_phase = TASKFILE_NO_DATA;
-	return do_rw_taskfile(drive, &task);
+	cmd.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
+	cmd.protocol = ATA_PROT_NODATA;
+
+	cmd.rq = rq;
+
+	return do_rw_taskfile(drive, &cmd);
 }
 
 ssize_t ide_park_show(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 60538d9..ebf2d21 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -1,6 +1,5 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
-#include <linux/hdreg.h>
 
 int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 {
@@ -8,7 +7,7 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	struct request_pm_state rqpm;
-	ide_task_t args;
+	struct ide_cmd cmd;
 	int ret;
 
 	/* call ACPI _GTM only once */
@@ -16,10 +15,10 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 		ide_acpi_get_timing(hwif);
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	memset(&args, 0, sizeof(args));
+	memset(&cmd, 0, sizeof(cmd));
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_PM_SUSPEND;
-	rq->special = &args;
+	rq->special = &cmd;
 	rq->data = &rqpm;
 	rqpm.pm_step = IDE_PM_START_SUSPEND;
 	if (mesg.event == PM_EVENT_PRETHAW)
@@ -42,7 +41,7 @@ int generic_ide_resume(struct device *dev)
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	struct request_pm_state rqpm;
-	ide_task_t args;
+	struct ide_cmd cmd;
 	int err;
 
 	/* call ACPI _PS0 / _STM only once */
@@ -54,11 +53,11 @@ int generic_ide_resume(struct device *dev)
 	ide_acpi_exec_tfs(drive);
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	memset(&args, 0, sizeof(args));
+	memset(&cmd, 0, sizeof(cmd));
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_PM_RESUME;
 	rq->cmd_flags |= REQ_PREEMPT;
-	rq->special = &args;
+	rq->special = &cmd;
 	rq->data = &rqpm;
 	rqpm.pm_step = IDE_PM_START_RESUME;
 	rqpm.pm_state = PM_EVENT_ON;
@@ -109,9 +108,9 @@ void ide_complete_power_step(ide_drive_t *drive, struct request *rq)
 ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 {
 	struct request_pm_state *pm = rq->data;
-	ide_task_t *args = rq->special;
+	struct ide_cmd *cmd = rq->special;
 
-	memset(args, 0, sizeof(*args));
+	memset(cmd, 0, sizeof(*cmd));
 
 	switch (pm->pm_step) {
 	case IDE_PM_FLUSH_CACHE:	/* Suspend step 1 (flush cache) */
@@ -124,12 +123,12 @@ ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 			return ide_stopped;
 		}
 		if (ata_id_flush_ext_enabled(drive->id))
-			args->tf.command = ATA_CMD_FLUSH_EXT;
+			cmd->tf.command = ATA_CMD_FLUSH_EXT;
 		else
-			args->tf.command = ATA_CMD_FLUSH;
+			cmd->tf.command = ATA_CMD_FLUSH;
 		goto out_do_tf;
 	case IDE_PM_STANDBY:		/* Suspend step 2 (standby) */
-		args->tf.command = ATA_CMD_STANDBYNOW1;
+		cmd->tf.command = ATA_CMD_STANDBYNOW1;
 		goto out_do_tf;
 	case IDE_PM_RESTORE_PIO:	/* Resume step 1 (restore PIO) */
 		ide_set_max_pio(drive);
@@ -142,7 +141,7 @@ ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 			ide_complete_power_step(drive, rq);
 		return ide_stopped;
 	case IDE_PM_IDLE:		/* Resume step 2 (idle) */
-		args->tf.command = ATA_CMD_IDLEIMMEDIATE;
+		cmd->tf.command = ATA_CMD_IDLEIMMEDIATE;
 		goto out_do_tf;
 	case IDE_PM_RESTORE_DMA:	/* Resume step 3 (restore DMA) */
 		/*
@@ -160,27 +159,34 @@ ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 	}
 
 	pm->pm_step = IDE_PM_COMPLETED;
+
 	return ide_stopped;
 
 out_do_tf:
-	args->tf_flags	 = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	args->data_phase = TASKFILE_NO_DATA;
-	return do_rw_taskfile(drive, args);
+	cmd->tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd->protocol = ATA_PROT_NODATA;
+
+	return do_rw_taskfile(drive, cmd);
 }
 
 /**
- *	ide_complete_pm_request - end the current Power Management request
+ *	ide_complete_pm_rq - end the current Power Management request
  *	@drive: target drive
  *	@rq: request
  *
  *	This function cleans up the current PM request and stops the queue
  *	if necessary.
  */
-void ide_complete_pm_request(ide_drive_t *drive, struct request *rq)
+void ide_complete_pm_rq(ide_drive_t *drive, struct request *rq)
 {
 	struct request_queue *q = drive->queue;
+	struct request_pm_state *pm = rq->data;
 	unsigned long flags;
 
+	ide_complete_power_step(drive, rq);
+	if (pm->pm_step != IDE_PM_COMPLETED)
+		return;
+
 #ifdef DEBUG_PM
 	printk("%s: completing PM request, %s\n", drive->name,
 	       blk_pm_suspend_request(rq) ? "suspend" : "resume");
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index bac9b39..6e80b77 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -27,6 +27,10 @@ static struct pnp_device_id idepnp_devices[] = {
 	{.id = ""}
 };
 
+static const struct ide_port_info ide_pnp_port_info = {
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
 	struct ide_host *host;
@@ -60,7 +64,7 @@ static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	hw.irq = pnp_irq(dev, 0);
 	hw.chipset = ide_generic;
 
-	rc = ide_host_add(NULL, hws, &host);
+	rc = ide_host_add(&ide_pnp_port_info, hws, &host);
 	if (rc)
 		goto out;
 
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 9740670..5488645 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -228,15 +228,9 @@ static void do_identify(ide_drive_t *drive, u8 cmd, u16 *id)
 	m[ATA_ID_PROD_LEN - 1] = '\0';
 
 	if (strstr(m, "E X A B Y T E N E S T"))
-		goto err_misc;
-
-	drive->dev_flags |= IDE_DFLAG_PRESENT;
-	drive->dev_flags &= ~IDE_DFLAG_DEAD;
-
-	return;
-err_misc:
-	kfree(id);
-	drive->dev_flags &= ~IDE_DFLAG_PRESENT;
+		drive->dev_flags &= ~IDE_DFLAG_PRESENT;
+	else
+		drive->dev_flags |= IDE_DFLAG_PRESENT;
 }
 
 /**
@@ -289,13 +283,13 @@ int ide_dev_read_id(ide_drive_t *drive, u8 cmd, u16 *id)
 	 * identify command to be sure of reply
 	 */
 	if (cmd == ATA_CMD_ID_ATAPI) {
-		ide_task_t task;
+		struct ide_cmd cmd;
 
-		memset(&task, 0, sizeof(task));
+		memset(&cmd, 0, sizeof(cmd));
 		/* disable DMA & overlap */
-		task.tf_flags = IDE_TFLAG_OUT_FEATURE;
+		cmd.tf_flags = IDE_TFLAG_OUT_FEATURE;
 
-		tp_ops->tf_load(drive, &task);
+		tp_ops->tf_load(drive, &cmd);
 	}
 
 	/* ask drive for ID */
@@ -343,14 +337,14 @@ int ide_busy_sleep(ide_hwif_t *hwif, unsigned long timeout, int altstatus)
 
 static u8 ide_read_device(ide_drive_t *drive)
 {
-	ide_task_t task;
+	struct ide_cmd cmd;
 
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_IN_DEVICE;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_IN_DEVICE;
 
-	drive->hwif->tp_ops->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &cmd);
 
-	return task.tf.device;
+	return cmd.tf.device;
 }
 
 /**
@@ -505,8 +499,7 @@ static u8 probe_for_drive(ide_drive_t *drive)
 		}
 
 		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-			/* drive not found */
-			return 0;
+			goto out_free;
 
 		/* identification failed? */
 		if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
@@ -530,7 +523,7 @@ static u8 probe_for_drive(ide_drive_t *drive)
 	}
 
 	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-		return 0;
+		goto out_free;
 
 	/* The drive wasn't being helpful. Add generic info only */
 	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
@@ -543,7 +536,10 @@ static u8 probe_for_drive(ide_drive_t *drive)
 		ide_disk_init_mult_count(drive);
 	}
 
-	return !!(drive->dev_flags & IDE_DFLAG_PRESENT);
+	return 1;
+out_free:
+	kfree(drive->id);
+	return 0;
 }
 
 static void hwif_release_dev(struct device *dev)
@@ -841,34 +837,19 @@ static int ide_port_setup_devices(ide_hwif_t *hwif)
 static int init_irq (ide_hwif_t *hwif)
 {
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	irq_handler_t irq_handler;
-	int sa = 0;
+	struct ide_host *host = hwif->host;
+	irq_handler_t irq_handler = host->irq_handler;
+	int sa = host->irq_flags;
 
-	irq_handler = hwif->host->irq_handler;
 	if (irq_handler == NULL)
 		irq_handler = ide_intr;
 
-#if defined(__mc68000__)
-	sa = IRQF_SHARED;
-#endif /* __mc68000__ */
-
-	if (hwif->chipset == ide_pci)
-		sa = IRQF_SHARED;
-
 	if (io_ports->ctl_addr)
 		hwif->tp_ops->set_irq(hwif, 1);
 
 	if (request_irq(hwif->irq, irq_handler, sa, hwif->name, hwif))
 		goto out_up;
 
-	if (!hwif->rqsize) {
-		if ((hwif->host_flags & IDE_HFLAG_NO_LBA48) ||
-		    (hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA))
-			hwif->rqsize = 256;
-		else
-			hwif->rqsize = 65536;
-	}
-
 #if !defined(__mc68000__)
 	printk(KERN_INFO "%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
 		io_ports->data_addr, io_ports->status_addr,
@@ -1080,7 +1061,7 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 		hwif->tp_ops = d->tp_ops;
 
 	/* ->set_pio_mode for DTC2278 is currently limited to port 0 */
-	if (hwif->chipset != ide_dtc2278 || hwif->channel == 0)
+	if ((hwif->host_flags & IDE_HFLAG_DTC2278) == 0 || hwif->channel == 0)
 		hwif->port_ops = d->port_ops;
 
 	hwif->swdma_mask = d->swdma_mask;
@@ -1114,6 +1095,13 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 
 	if (d->max_sectors)
 		hwif->rqsize = d->max_sectors;
+	else {
+		if ((hwif->host_flags & IDE_HFLAG_NO_LBA48) ||
+		    (hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA))
+			hwif->rqsize = 256;
+		else
+			hwif->rqsize = 65536;
+	}
 
 	/* call chipset specific routine for each enabled port */
 	if (d->init_hwif)
@@ -1326,6 +1314,8 @@ struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
 
 	if (d) {
 		host->init_chipset = d->init_chipset;
+		host->get_lock     = d->get_lock;
+		host->release_lock = d->release_lock;
 		host->host_flags = d->host_flags;
 	}
 
@@ -1372,20 +1362,15 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 		ide_init_port_hw(hwif, hws[i]);
 		ide_port_apply_params(hwif);
 
-		if (d == NULL) {
-			mate = NULL;
-		} else {
-			if ((i & 1) && mate) {
-				hwif->mate = mate;
-				mate->mate = hwif;
-			}
-
-			mate = (i & 1) ? NULL : hwif;
-
-			ide_init_port(hwif, i & 1, d);
-			ide_port_cable_detect(hwif);
+		if ((i & 1) && mate) {
+			hwif->mate = mate;
+			mate->mate = hwif;
 		}
 
+		mate = (i & 1) ? NULL : hwif;
+
+		ide_init_port(hwif, i & 1, d);
+		ide_port_cable_detect(hwif);
 		ide_port_init_devices(hwif);
 	}
 
@@ -1396,8 +1381,8 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 		if (ide_probe_port(hwif) == 0)
 			hwif->present = 1;
 
-		if (hwif->chipset != ide_4drives || !hwif->mate ||
-		    !hwif->mate->present) {
+		if ((hwif->host_flags & IDE_HFLAG_4DRIVES) == 0 ||
+		    hwif->mate == NULL || hwif->mate->present == 0) {
 			if (ide_register_port(hwif)) {
 				ide_disable_port(hwif);
 				continue;
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 417cde5..10a88bf 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -194,20 +194,20 @@ ide_devset_get(xfer_rate, current_speed);
 
 static int set_xfer_rate (ide_drive_t *drive, int arg)
 {
-	ide_task_t task;
+	struct ide_cmd cmd;
 	int err;
 
 	if (arg < XFER_PIO_0 || arg > XFER_UDMA_6)
 		return -EINVAL;
 
-	memset(&task, 0, sizeof(task));
-	task.tf.command = ATA_CMD_SET_FEATURES;
-	task.tf.feature = SETFEATURES_XFER;
-	task.tf.nsect   = (u8)arg;
-	task.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT |
-			IDE_TFLAG_IN_NSECT;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf.command = ATA_CMD_SET_FEATURES;
+	cmd.tf.feature = SETFEATURES_XFER;
+	cmd.tf.nsect   = (u8)arg;
+	cmd.tf_flags   = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT |
+			 IDE_TFLAG_IN_NSECT;
 
-	err = ide_no_data_taskfile(drive, &task);
+	err = ide_no_data_taskfile(drive, &cmd);
 
 	if (!err) {
 		ide_set_xfer_rate(drive, (u8) arg);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 4e6181c..64dfa74 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -152,11 +152,6 @@ struct idetape_bh {
 #define IDETAPE_LU_RETENSION_MASK	2
 #define IDETAPE_LU_EOT_MASK		4
 
-/* Error codes returned in rq->errors to the higher part of the driver. */
-#define IDETAPE_ERROR_GENERAL		101
-#define IDETAPE_ERROR_FILEMARK		102
-#define IDETAPE_ERROR_EOD		103
-
 /* Structures related to the SELECT SENSE / MODE SENSE packet commands. */
 #define IDETAPE_BLOCK_DESCRIPTOR	0
 #define IDETAPE_CAPABILITIES_PAGE	0x2a
@@ -171,14 +166,6 @@ typedef struct ide_tape_obj {
 	struct gendisk		*disk;
 	struct device		dev;
 
-	/*
-	 *	failed_pc points to the last failed packet command, or contains
-	 *	NULL if we do not need to retry any packet command. This is
-	 *	required since an additional packet command is needed before the
-	 *	retry, to get detailed information on what went wrong.
-	 */
-	/* Last failed packet command */
-	struct ide_atapi_pc *failed_pc;
 	/* used by REQ_IDETAPE_{READ,WRITE} requests */
 	struct ide_atapi_pc queued_pc;
 
@@ -245,9 +232,6 @@ typedef struct ide_tape_obj {
 	/* Wasted space in each stage */
 	int excess_bh_size;
 
-	/* protects the ide-tape queue */
-	spinlock_t lock;
-
 	/* Measures average tape speed */
 	unsigned long avg_time;
 	int avg_size;
@@ -400,7 +384,7 @@ static void idetape_update_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc)
 static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	struct ide_atapi_pc *pc = tape->failed_pc;
+	struct ide_atapi_pc *pc = drive->failed_pc;
 
 	tape->sense_key = sense[2] & 0xF;
 	tape->asc       = sense[12];
@@ -433,19 +417,19 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 		}
 	}
 	if (pc->c[0] == READ_6 && (sense[2] & 0x80)) {
-		pc->error = IDETAPE_ERROR_FILEMARK;
+		pc->error = IDE_DRV_ERROR_FILEMARK;
 		pc->flags |= PC_FLAG_ABORT;
 	}
 	if (pc->c[0] == WRITE_6) {
 		if ((sense[2] & 0x40) || (tape->sense_key == 0xd
 		     && tape->asc == 0x0 && tape->ascq == 0x2)) {
-			pc->error = IDETAPE_ERROR_EOD;
+			pc->error = IDE_DRV_ERROR_EOD;
 			pc->flags |= PC_FLAG_ABORT;
 		}
 	}
 	if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
 		if (tape->sense_key == 8) {
-			pc->error = IDETAPE_ERROR_EOD;
+			pc->error = IDE_DRV_ERROR_EOD;
 			pc->flags |= PC_FLAG_ABORT;
 		}
 		if (!(pc->flags & PC_FLAG_ABORT) &&
@@ -477,52 +461,23 @@ static void ide_tape_kfree_buffer(idetape_tape_t *tape)
 	}
 }
 
-static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
-{
-	struct request *rq = drive->hwif->rq;
-	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
-	int error;
-
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	switch (uptodate) {
-	case 0:	error = IDETAPE_ERROR_GENERAL; break;
-	case 1: error = 0; break;
-	default: error = uptodate;
-	}
-	rq->errors = error;
-	if (error)
-		tape->failed_pc = NULL;
-
-	if (!blk_special_request(rq)) {
-		ide_end_request(drive, uptodate, nr_sects);
-		return 0;
-	}
-
-	spin_lock_irqsave(&tape->lock, flags);
-
-	ide_end_drive_cmd(drive, 0, 0);
-
-	spin_unlock_irqrestore(&tape->lock, flags);
-	return 0;
-}
-
 static void ide_tape_handle_dsc(ide_drive_t *);
 
-static void ide_tape_callback(ide_drive_t *drive, int dsc)
+static int ide_tape_callback(ide_drive_t *drive, int dsc)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = drive->pc;
+	struct request *rq = drive->hwif->rq;
 	int uptodate = pc->error ? 0 : 1;
+	int err = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	if (dsc)
 		ide_tape_handle_dsc(drive);
 
-	if (tape->failed_pc == pc)
-		tape->failed_pc = NULL;
+	if (drive->failed_pc == pc)
+		drive->failed_pc = NULL;
 
 	if (pc->c[0] == REQUEST_SENSE) {
 		if (uptodate)
@@ -531,7 +486,6 @@ static void ide_tape_callback(ide_drive_t *drive, int dsc)
 			printk(KERN_ERR "ide-tape: Error in REQUEST SENSE "
 					"itself - Aborting request!\n");
 	} else if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
-		struct request *rq = drive->hwif->rq;
 		int blocks = pc->xferred / tape->blk_size;
 
 		tape->avg_size += blocks * tape->blk_size;
@@ -546,8 +500,10 @@ static void ide_tape_callback(ide_drive_t *drive, int dsc)
 		tape->first_frame += blocks;
 		rq->current_nr_sectors -= blocks;
 
-		if (pc->error)
-			uptodate = pc->error;
+		if (pc->error) {
+			uptodate = 0;
+			err = pc->error;
+		}
 	} else if (pc->c[0] == READ_POSITION && uptodate) {
 		u8 *readpos = pc->buf;
 
@@ -561,6 +517,7 @@ static void ide_tape_callback(ide_drive_t *drive, int dsc)
 					 "to the tape\n");
 			clear_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
 			uptodate = 0;
+			err = IDE_DRV_ERROR_GENERAL;
 		} else {
 			debug_log(DBG_SENSE, "Block Location - %u\n",
 					be32_to_cpup((__be32 *)&readpos[4]));
@@ -571,7 +528,9 @@ static void ide_tape_callback(ide_drive_t *drive, int dsc)
 		}
 	}
 
-	idetape_end_request(drive, uptodate, 0);
+	rq->errors = err;
+
+	return uptodate;
 }
 
 /*
@@ -621,7 +580,7 @@ static int ide_tape_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
  *
  * The handling will be done in three stages:
  *
- * 1. idetape_issue_pc will send the packet command to the drive, and will set
+ * 1. ide_tape_issue_pc will send the packet command to the drive, and will set
  * the interrupt handler to ide_pc_intr.
  *
  * 2. On each interrupt, ide_pc_intr will be called. This step will be
@@ -649,8 +608,9 @@ static int ide_tape_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
  * request.
  */
 
-static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
-		struct ide_atapi_pc *pc)
+static ide_startstop_t ide_tape_issue_pc(ide_drive_t *drive,
+					 struct ide_cmd *cmd,
+					 struct ide_atapi_pc *pc)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -660,8 +620,8 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 			"Two request sense in serial were issued\n");
 	}
 
-	if (tape->failed_pc == NULL && pc->c[0] != REQUEST_SENSE)
-		tape->failed_pc = pc;
+	if (drive->failed_pc == NULL && pc->c[0] != REQUEST_SENSE)
+		drive->failed_pc = pc;
 
 	/* Set the current packet command */
 	drive->pc = pc;
@@ -685,9 +645,9 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 						tape->ascq);
 			}
 			/* Giving up */
-			pc->error = IDETAPE_ERROR_GENERAL;
+			pc->error = IDE_DRV_ERROR_GENERAL;
 		}
-		tape->failed_pc = NULL;
+		drive->failed_pc = NULL;
 		drive->pc_callback(drive, 0);
 		return ide_stopped;
 	}
@@ -695,7 +655,7 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 
 	pc->retries++;
 
-	return ide_issue_pc(drive);
+	return ide_issue_pc(drive, cmd);
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
@@ -746,8 +706,8 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 		}
 		pc->error = 0;
 	} else {
-		pc->error = IDETAPE_ERROR_GENERAL;
-		tape->failed_pc = NULL;
+		pc->error = IDE_DRV_ERROR_GENERAL;
+		drive->failed_pc = NULL;
 	}
 	drive->pc_callback(drive, 0);
 	return ide_stopped;
@@ -790,6 +750,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = NULL;
 	struct request *postponed_rq = tape->postponed_rq;
+	struct ide_cmd cmd;
 	u8 stat;
 
 	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %lu,"
@@ -801,13 +762,15 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		/* We do not support buffer cache originated requests. */
 		printk(KERN_NOTICE "ide-tape: %s: Unsupported request in "
 			"request queue (%d)\n", drive->name, rq->cmd_type);
-		ide_end_request(drive, 0, 0);
+		if (blk_fs_request(rq) == 0 && rq->errors == 0)
+			rq->errors = -EIO;
+		ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
 		return ide_stopped;
 	}
 
 	/* Retry a failed packet command */
-	if (tape->failed_pc && drive->pc->c[0] == REQUEST_SENSE) {
-		pc = tape->failed_pc;
+	if (drive->failed_pc && drive->pc->c[0] == REQUEST_SENSE) {
+		pc = drive->failed_pc;
 		goto out;
 	}
 
@@ -815,7 +778,9 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		if (rq != postponed_rq) {
 			printk(KERN_ERR "ide-tape: ide-tape.c bug - "
 					"Two DSC requests were queued\n");
-			idetape_end_request(drive, 0, 0);
+			drive->failed_pc = NULL;
+			rq->errors = 0;
+			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 			return ide_stopped;
 		}
 
@@ -881,7 +846,14 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	BUG();
 
 out:
-	return idetape_issue_pc(drive, pc);
+	memset(&cmd, 0, sizeof(cmd));
+
+	if (rq_data_dir(rq))
+		cmd.tf_flags |= IDE_TFLAG_WRITE;
+
+	cmd.rq = rq;
+
+	return ide_tape_issue_pc(drive, &cmd, pc);
 }
 
 /*
@@ -1226,7 +1198,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 
 	if (tape->merge_bh)
 		idetape_init_merge_buffer(tape);
-	if (errors == IDETAPE_ERROR_GENERAL)
+	if (errors == IDE_DRV_ERROR_GENERAL)
 		return -EIO;
 	return ret;
 }
@@ -2192,8 +2164,6 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	drive->pc_update_buffers = idetape_update_buffers;
 	drive->pc_io_buffers	 = ide_tape_io_buffers;
 
-	spin_lock_init(&tape->lock);
-
 	drive->dev_flags |= IDE_DFLAG_DSC_OVERLAP;
 
 	if (drive->hwif->host_flags & IDE_HFLAG_NO_DSC) {
@@ -2325,7 +2295,6 @@ static struct ide_driver idetape_driver = {
 	.remove			= ide_tape_remove,
 	.version		= IDETAPE_VERSION,
 	.do_request		= idetape_do_request,
-	.end_request		= idetape_end_request,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_tape_proc_entries,
 	.proc_devsets		= ide_tape_proc_devsets,
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 16138bc..84532be 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -39,88 +39,86 @@ void ide_tf_dump(const char *s, struct ide_taskfile *tf)
 
 int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
 {
-	ide_task_t args;
+	struct ide_cmd cmd;
 
-	memset(&args, 0, sizeof(ide_task_t));
-	args.tf.nsect = 0x01;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf.nsect = 0x01;
 	if (drive->media == ide_disk)
-		args.tf.command = ATA_CMD_ID_ATA;
+		cmd.tf.command = ATA_CMD_ID_ATA;
 	else
-		args.tf.command = ATA_CMD_ID_ATAPI;
-	args.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	args.data_phase	= TASKFILE_IN;
-	return ide_raw_taskfile(drive, &args, buf, 1);
+		cmd.tf.command = ATA_CMD_ID_ATAPI;
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.protocol = ATA_PROT_PIO;
+
+	return ide_raw_taskfile(drive, &cmd, buf, 1);
 }
 
 static ide_startstop_t task_no_data_intr(ide_drive_t *);
-static ide_startstop_t pre_task_out_intr(ide_drive_t *, struct request *);
-static ide_startstop_t task_in_intr(ide_drive_t *);
+static ide_startstop_t pre_task_out_intr(ide_drive_t *, struct ide_cmd *);
+static ide_startstop_t task_pio_intr(ide_drive_t *);
 
-ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
+ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *orig_cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_cmd *cmd = &hwif->cmd;
+	struct ide_taskfile *tf = &cmd->tf;
 	ide_handler_t *handler = NULL;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
 
-	if (task->data_phase == TASKFILE_MULTI_IN ||
-	    task->data_phase == TASKFILE_MULTI_OUT) {
-		if (!drive->mult_count) {
-			printk(KERN_ERR "%s: multimode not set!\n",
-					drive->name);
-			return ide_stopped;
-		}
+	if (orig_cmd->protocol == ATA_PROT_PIO &&
+	    (orig_cmd->tf_flags & IDE_TFLAG_MULTI_PIO) &&
+	    drive->mult_count == 0) {
+		printk(KERN_ERR "%s: multimode not set!\n", drive->name);
+		return ide_stopped;
 	}
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
-		task->tf_flags |= IDE_TFLAG_FLAGGED_SET_IN_FLAGS;
+	if (orig_cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
+		orig_cmd->ftf_flags |= IDE_FTFLAG_SET_IN_FLAGS;
 
-	memcpy(&hwif->task, task, sizeof(*task));
+	memcpy(cmd, orig_cmd, sizeof(*cmd));
 
-	if ((task->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
+	if ((cmd->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
 		ide_tf_dump(drive->name, tf);
 		tp_ops->set_irq(hwif, 1);
 		SELECT_MASK(drive, 0);
-		tp_ops->tf_load(drive, task);
+		tp_ops->tf_load(drive, cmd);
 	}
 
-	switch (task->data_phase) {
-	case TASKFILE_MULTI_OUT:
-	case TASKFILE_OUT:
-		tp_ops->exec_command(hwif, tf->command);
-		ndelay(400);	/* FIXME */
-		return pre_task_out_intr(drive, task->rq);
-	case TASKFILE_MULTI_IN:
-	case TASKFILE_IN:
-		handler = task_in_intr;
+	switch (cmd->protocol) {
+	case ATA_PROT_PIO:
+		if (cmd->tf_flags & IDE_TFLAG_WRITE) {
+			tp_ops->exec_command(hwif, tf->command);
+			ndelay(400);	/* FIXME */
+			return pre_task_out_intr(drive, cmd);
+		}
+		handler = task_pio_intr;
 		/* fall-through */
-	case TASKFILE_NO_DATA:
+	case ATA_PROT_NODATA:
 		if (handler == NULL)
 			handler = task_no_data_intr;
-		ide_execute_command(drive, tf->command, handler,
-				    WAIT_WORSTCASE, NULL);
+		ide_execute_command(drive, cmd, handler, WAIT_WORSTCASE);
 		return ide_started;
-	default:
+	case ATA_PROT_DMA:
 		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
-		    dma_ops->dma_setup(drive))
+		    ide_build_sglist(drive, cmd) == 0 ||
+		    dma_ops->dma_setup(drive, cmd))
 			return ide_stopped;
-		dma_ops->dma_exec_cmd(drive, tf->command);
+		hwif->expiry = dma_ops->dma_timer_expiry;
+		ide_execute_command(drive, cmd, ide_dma_intr, 2 * WAIT_CMD);
 		dma_ops->dma_start(drive);
+	default:
 		return ide_started;
 	}
 }
 EXPORT_SYMBOL_GPL(do_rw_taskfile);
 
-/*
- * Handler for commands without a data phase
- */
 static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_task_t *task = &hwif->task;
-	struct ide_taskfile *tf = &task->tf;
-	int custom = (task->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) ? 1 : 0;
+	struct ide_cmd *cmd = &hwif->cmd;
+	struct ide_taskfile *tf = &cmd->tf;
+	int custom = (cmd->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) ? 1 : 0;
 	int retries = (custom && tf->command == ATA_CMD_INIT_DEV_PARAMS) ? 5 : 1;
 	u8 stat;
 
@@ -142,28 +140,26 @@ static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 		} else if (custom && tf->command == ATA_CMD_INIT_DEV_PARAMS) {
 			if ((stat & (ATA_ERR | ATA_DRQ)) == 0) {
 				ide_set_handler(drive, &task_no_data_intr,
-						WAIT_WORSTCASE, NULL);
+						WAIT_WORSTCASE);
 				return ide_started;
 			}
 		}
 		return ide_error(drive, "task_no_data_intr", stat);
-		/* calls ide_end_drive_cmd */
 	}
 
-	if (!custom)
-		ide_end_drive_cmd(drive, stat, ide_read_error(drive));
-	else if (tf->command == ATA_CMD_IDLEIMMEDIATE) {
-		hwif->tp_ops->tf_read(drive, task);
-		if (tf->lbal != 0xc4) {
-			printk(KERN_ERR "%s: head unload failed!\n",
-			       drive->name);
-			ide_tf_dump(drive->name, tf);
-		} else
-			drive->dev_flags |= IDE_DFLAG_PARKED;
-		ide_end_drive_cmd(drive, stat, ide_read_error(drive));
-	} else if (tf->command == ATA_CMD_SET_MULTI)
+	if (custom && tf->command == ATA_CMD_SET_MULTI)
 		drive->mult_count = drive->mult_req;
 
+	if (custom == 0 || tf->command == ATA_CMD_IDLEIMMEDIATE ||
+	    tf->command == ATA_CMD_CHK_POWER) {
+		struct request *rq = hwif->rq;
+
+		if (blk_pm_request(rq))
+			ide_complete_pm_rq(drive, rq);
+		else
+			ide_finish_cmd(drive, cmd, stat);
+	}
+
 	return ide_stopped;
 }
 
@@ -192,12 +188,12 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	return stat;
 }
 
-static void ide_pio_sector(ide_drive_t *drive, struct request *rq,
-			   unsigned int write)
+static void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
+			  unsigned int write, unsigned int nr_bytes)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
-	struct scatterlist *cursg = hwif->cursg;
+	struct scatterlist *cursg = cmd->cursg;
 	struct page *page;
 #ifdef CONFIG_HIGHMEM
 	unsigned long flags;
@@ -205,14 +201,14 @@ static void ide_pio_sector(ide_drive_t *drive, struct request *rq,
 	unsigned int offset;
 	u8 *buf;
 
-	cursg = hwif->cursg;
+	cursg = cmd->cursg;
 	if (!cursg) {
 		cursg = sg;
-		hwif->cursg = sg;
+		cmd->cursg = sg;
 	}
 
 	page = sg_page(cursg);
-	offset = cursg->offset + hwif->cursg_ofs * SECTOR_SIZE;
+	offset = cursg->offset + cmd->cursg_ofs;
 
 	/* get the current page and offset */
 	page = nth_page(page, (offset >> PAGE_SHIFT));
@@ -223,19 +219,19 @@ static void ide_pio_sector(ide_drive_t *drive, struct request *rq,
 #endif
 	buf = kmap_atomic(page, KM_BIO_SRC_IRQ) + offset;
 
-	hwif->nleft--;
-	hwif->cursg_ofs++;
+	cmd->nleft -= nr_bytes;
+	cmd->cursg_ofs += nr_bytes;
 
-	if ((hwif->cursg_ofs * SECTOR_SIZE) == cursg->length) {
-		hwif->cursg = sg_next(hwif->cursg);
-		hwif->cursg_ofs = 0;
+	if (cmd->cursg_ofs == cursg->length) {
+		cmd->cursg = sg_next(cmd->cursg);
+		cmd->cursg_ofs = 0;
 	}
 
 	/* do the actual data transfer */
 	if (write)
-		hwif->tp_ops->output_data(drive, rq, buf, SECTOR_SIZE);
+		hwif->tp_ops->output_data(drive, cmd, buf, nr_bytes);
 	else
-		hwif->tp_ops->input_data(drive, rq, buf, SECTOR_SIZE);
+		hwif->tp_ops->input_data(drive, cmd, buf, nr_bytes);
 
 	kunmap_atomic(buf, KM_BIO_SRC_IRQ);
 #ifdef CONFIG_HIGHMEM
@@ -243,188 +239,137 @@ static void ide_pio_sector(ide_drive_t *drive, struct request *rq,
 #endif
 }
 
-static void ide_pio_multi(ide_drive_t *drive, struct request *rq,
+static void ide_pio_multi(ide_drive_t *drive, struct ide_cmd *cmd,
 			  unsigned int write)
 {
 	unsigned int nsect;
 
-	nsect = min_t(unsigned int, drive->hwif->nleft, drive->mult_count);
+	nsect = min_t(unsigned int, cmd->nleft >> 9, drive->mult_count);
 	while (nsect--)
-		ide_pio_sector(drive, rq, write);
+		ide_pio_bytes(drive, cmd, write, SECTOR_SIZE);
 }
 
-static void ide_pio_datablock(ide_drive_t *drive, struct request *rq,
-				     unsigned int write)
+static void ide_pio_datablock(ide_drive_t *drive, struct ide_cmd *cmd,
+			      unsigned int write)
 {
 	u8 saved_io_32bit = drive->io_32bit;
 
-	if (rq->bio)	/* fs request */
-		rq->errors = 0;
+	if (cmd->tf_flags & IDE_TFLAG_FS)
+		cmd->rq->errors = 0;
 
-	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
-		ide_task_t *task = rq->special;
-
-		if (task->tf_flags & IDE_TFLAG_IO_16BIT)
-			drive->io_32bit = 0;
-	}
+	if (cmd->tf_flags & IDE_TFLAG_IO_16BIT)
+		drive->io_32bit = 0;
 
 	touch_softlockup_watchdog();
 
-	switch (drive->hwif->data_phase) {
-	case TASKFILE_MULTI_IN:
-	case TASKFILE_MULTI_OUT:
-		ide_pio_multi(drive, rq, write);
-		break;
-	default:
-		ide_pio_sector(drive, rq, write);
-		break;
-	}
+	if (cmd->tf_flags & IDE_TFLAG_MULTI_PIO)
+		ide_pio_multi(drive, cmd, write);
+	else
+		ide_pio_bytes(drive, cmd, write, SECTOR_SIZE);
 
 	drive->io_32bit = saved_io_32bit;
 }
 
-static ide_startstop_t task_error(ide_drive_t *drive, struct request *rq,
-				  const char *s, u8 stat)
+static void ide_error_cmd(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	if (rq->bio) {
-		ide_hwif_t *hwif = drive->hwif;
-		int sectors = hwif->nsect - hwif->nleft;
-
-		switch (hwif->data_phase) {
-		case TASKFILE_IN:
-			if (hwif->nleft)
-				break;
-			/* fall through */
-		case TASKFILE_OUT:
-			sectors--;
-			break;
-		case TASKFILE_MULTI_IN:
-			if (hwif->nleft)
-				break;
-			/* fall through */
-		case TASKFILE_MULTI_OUT:
-			sectors -= drive->mult_count;
-		default:
-			break;
+	if (cmd->tf_flags & IDE_TFLAG_FS) {
+		int nr_bytes = cmd->nbytes - cmd->nleft;
+
+		if (cmd->protocol == ATA_PROT_PIO &&
+		    ((cmd->tf_flags & IDE_TFLAG_WRITE) || cmd->nleft == 0)) {
+			if (cmd->tf_flags & IDE_TFLAG_MULTI_PIO)
+				nr_bytes -= drive->mult_count << 9;
+			else
+				nr_bytes -= SECTOR_SIZE;
 		}
 
-		if (sectors > 0) {
-			struct ide_driver *drv;
-
-			drv = *(struct ide_driver **)rq->rq_disk->private_data;
-			drv->end_request(drive, 1, sectors);
-		}
+		if (nr_bytes > 0)
+			ide_complete_rq(drive, 0, nr_bytes);
 	}
-	return ide_error(drive, s, stat);
-}
-
-void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
-{
-	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
-		u8 err = ide_read_error(drive);
-
-		ide_end_drive_cmd(drive, stat, err);
-		return;
-	}
-
-	if (rq->rq_disk) {
-		struct ide_driver *drv;
-
-		drv = *(struct ide_driver **)rq->rq_disk->private_data;;
-		drv->end_request(drive, 1, rq->nr_sectors);
-	} else
-		ide_end_request(drive, 1, rq->nr_sectors);
 }
 
-/*
- * We got an interrupt on a task_in case, but no errors and no DRQ.
- *
- * It might be a spurious irq (shared irq), but it might be a
- * command that had no output.
- */
-static ide_startstop_t task_in_unexpected(ide_drive_t *drive, struct request *rq, u8 stat)
+void ide_finish_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat)
 {
-	/* Command all done? */
-	if (OK_STAT(stat, ATA_DRDY, ATA_BUSY)) {
-		task_end_request(drive, rq, stat);
-		return ide_stopped;
-	}
+	struct request *rq = drive->hwif->rq;
+	u8 err = ide_read_error(drive);
 
-	/* Assume it was a spurious irq */
-	ide_set_handler(drive, &task_in_intr, WAIT_WORSTCASE, NULL);
-	return ide_started;
+	ide_complete_cmd(drive, cmd, stat, err);
+	rq->errors = err;
+	ide_complete_rq(drive, err ? -EIO : 0, blk_rq_bytes(rq));
 }
 
 /*
- * Handler for command with PIO data-in phase (Read/Read Multiple).
+ * Handler for command with PIO data phase.
  */
-static ide_startstop_t task_in_intr(ide_drive_t *drive)
+static ide_startstop_t task_pio_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->rq;
+	struct ide_cmd *cmd = &drive->hwif->cmd;
 	u8 stat = hwif->tp_ops->read_status(hwif);
+	u8 write = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
 
-	/* Error? */
-	if (stat & ATA_ERR)
-		return task_error(drive, rq, __func__, stat);
+	if (write == 0) {
+		/* Error? */
+		if (stat & ATA_ERR)
+			goto out_err;
 
-	/* Didn't want any data? Odd. */
-	if ((stat & ATA_DRQ) == 0)
-		return task_in_unexpected(drive, rq, stat);
+		/* Didn't want any data? Odd. */
+		if ((stat & ATA_DRQ) == 0) {
+			/* Command all done? */
+			if (OK_STAT(stat, ATA_DRDY, ATA_BUSY))
+				goto out_end;
 
-	ide_pio_datablock(drive, rq, 0);
+			/* Assume it was a spurious irq */
+			goto out_wait;
+		}
+	} else {
+		if (!OK_STAT(stat, DRIVE_READY, drive->bad_wstat))
+			goto out_err;
 
-	/* Are we done? Check status and finish transfer. */
-	if (!hwif->nleft) {
-		stat = wait_drive_not_busy(drive);
-		if (!OK_STAT(stat, 0, BAD_STAT))
-			return task_error(drive, rq, __func__, stat);
-		task_end_request(drive, rq, stat);
-		return ide_stopped;
+		/* Deal with unexpected ATA data phase. */
+		if (((stat & ATA_DRQ) == 0) ^ (cmd->nleft == 0))
+			goto out_err;
 	}
 
-	/* Still data left to transfer. */
-	ide_set_handler(drive, &task_in_intr, WAIT_WORSTCASE, NULL);
+	if (write && cmd->nleft == 0)
+		goto out_end;
 
-	return ide_started;
-}
-
-/*
- * Handler for command with PIO data-out phase (Write/Write Multiple).
- */
-static ide_startstop_t task_out_intr (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->rq;
-	u8 stat = hwif->tp_ops->read_status(hwif);
-
-	if (!OK_STAT(stat, DRIVE_READY, drive->bad_wstat))
-		return task_error(drive, rq, __func__, stat);
+	/* Still data left to transfer. */
+	ide_pio_datablock(drive, cmd, write);
 
-	/* Deal with unexpected ATA data phase. */
-	if (((stat & ATA_DRQ) == 0) ^ !hwif->nleft)
-		return task_error(drive, rq, __func__, stat);
+	/* Are we done? Check status and finish transfer. */
+	if (write == 0 && cmd->nleft == 0) {
+		stat = wait_drive_not_busy(drive);
+		if (!OK_STAT(stat, 0, BAD_STAT))
+			goto out_err;
 
-	if (!hwif->nleft) {
-		task_end_request(drive, rq, stat);
-		return ide_stopped;
+		goto out_end;
 	}
-
+out_wait:
 	/* Still data left to transfer. */
-	ide_pio_datablock(drive, rq, 1);
-	ide_set_handler(drive, &task_out_intr, WAIT_WORSTCASE, NULL);
-
+	ide_set_handler(drive, &task_pio_intr, WAIT_WORSTCASE);
 	return ide_started;
+out_end:
+	if ((cmd->tf_flags & IDE_TFLAG_FS) == 0)
+		ide_finish_cmd(drive, cmd, stat);
+	else
+		ide_complete_rq(drive, 0, cmd->rq->nr_sectors << 9);
+	return ide_stopped;
+out_err:
+	ide_error_cmd(drive, cmd);
+	return ide_error(drive, __func__, stat);
 }
 
-static ide_startstop_t pre_task_out_intr(ide_drive_t *drive, struct request *rq)
+static ide_startstop_t pre_task_out_intr(ide_drive_t *drive,
+					 struct ide_cmd *cmd)
 {
 	ide_startstop_t startstop;
 
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ,
 			  drive->bad_wstat, WAIT_DRQ)) {
 		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
-			drive->name, drive->hwif->data_phase ? "MULT" : "",
+			drive->name,
+			(cmd->tf_flags & IDE_TFLAG_MULTI_PIO) ? "MULT" : "",
 			(drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
 		return startstop;
 	}
@@ -432,13 +377,15 @@ static ide_startstop_t pre_task_out_intr(ide_drive_t *drive, struct request *rq)
 	if ((drive->dev_flags & IDE_DFLAG_UNMASK) == 0)
 		local_irq_disable();
 
-	ide_set_handler(drive, &task_out_intr, WAIT_WORSTCASE, NULL);
-	ide_pio_datablock(drive, rq, 1);
+	ide_set_handler(drive, &task_pio_intr, WAIT_WORSTCASE);
+
+	ide_pio_datablock(drive, cmd, 1);
 
 	return ide_started;
 }
 
-int ide_raw_taskfile(ide_drive_t *drive, ide_task_t *task, u8 *buf, u16 nsect)
+int ide_raw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd, u8 *buf,
+		     u16 nsect)
 {
 	struct request *rq;
 	int error;
@@ -456,11 +403,11 @@ int ide_raw_taskfile(ide_drive_t *drive, ide_task_t *task, u8 *buf, u16 nsect)
 	rq->hard_nr_sectors = rq->nr_sectors = nsect;
 	rq->hard_cur_sectors = rq->current_nr_sectors = nsect;
 
-	if (task->tf_flags & IDE_TFLAG_WRITE)
+	if (cmd->tf_flags & IDE_TFLAG_WRITE)
 		rq->cmd_flags |= REQ_RW;
 
-	rq->special = task;
-	task->rq = rq;
+	rq->special = cmd;
+	cmd->rq = rq;
 
 	error = blk_execute_rq(drive->queue, NULL, rq, 0);
 	blk_put_request(rq);
@@ -470,19 +417,19 @@ int ide_raw_taskfile(ide_drive_t *drive, ide_task_t *task, u8 *buf, u16 nsect)
 
 EXPORT_SYMBOL(ide_raw_taskfile);
 
-int ide_no_data_taskfile(ide_drive_t *drive, ide_task_t *task)
+int ide_no_data_taskfile(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	task->data_phase = TASKFILE_NO_DATA;
+	cmd->protocol = ATA_PROT_NODATA;
 
-	return ide_raw_taskfile(drive, task, NULL, 0);
+	return ide_raw_taskfile(drive, cmd, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(ide_no_data_taskfile);
 
 #ifdef CONFIG_IDE_TASK_IOCTL
-int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
+int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 {
 	ide_task_request_t	*req_task;
-	ide_task_t		args;
+	struct ide_cmd		cmd;
 	u8 *outbuf		= NULL;
 	u8 *inbuf		= NULL;
 	u8 *data_buf		= NULL;
@@ -536,53 +483,63 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 		}
 	}
 
-	memset(&args, 0, sizeof(ide_task_t));
+	memset(&cmd, 0, sizeof(cmd));
 
-	memcpy(&args.tf_array[0], req_task->hob_ports, HDIO_DRIVE_HOB_HDR_SIZE - 2);
-	memcpy(&args.tf_array[6], req_task->io_ports, HDIO_DRIVE_TASK_HDR_SIZE);
+	memcpy(&cmd.tf_array[0], req_task->hob_ports,
+	       HDIO_DRIVE_HOB_HDR_SIZE - 2);
+	memcpy(&cmd.tf_array[6], req_task->io_ports,
+	       HDIO_DRIVE_TASK_HDR_SIZE);
 
-	args.data_phase = req_task->data_phase;
+	cmd.tf_flags   = IDE_TFLAG_IO_16BIT | IDE_TFLAG_DEVICE |
+			 IDE_TFLAG_IN_TF;
 
-	args.tf_flags = IDE_TFLAG_IO_16BIT | IDE_TFLAG_DEVICE |
-			IDE_TFLAG_IN_TF;
 	if (drive->dev_flags & IDE_DFLAG_LBA48)
-		args.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_IN_HOB);
+		cmd.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_IN_HOB);
 
 	if (req_task->out_flags.all) {
-		args.tf_flags |= IDE_TFLAG_FLAGGED;
+		cmd.ftf_flags |= IDE_FTFLAG_FLAGGED;
 
 		if (req_task->out_flags.b.data)
-			args.tf_flags |= IDE_TFLAG_OUT_DATA;
+			cmd.ftf_flags |= IDE_FTFLAG_OUT_DATA;
 
 		if (req_task->out_flags.b.nsector_hob)
-			args.tf_flags |= IDE_TFLAG_OUT_HOB_NSECT;
+			cmd.tf_flags |= IDE_TFLAG_OUT_HOB_NSECT;
 		if (req_task->out_flags.b.sector_hob)
-			args.tf_flags |= IDE_TFLAG_OUT_HOB_LBAL;
+			cmd.tf_flags |= IDE_TFLAG_OUT_HOB_LBAL;
 		if (req_task->out_flags.b.lcyl_hob)
-			args.tf_flags |= IDE_TFLAG_OUT_HOB_LBAM;
+			cmd.tf_flags |= IDE_TFLAG_OUT_HOB_LBAM;
 		if (req_task->out_flags.b.hcyl_hob)
-			args.tf_flags |= IDE_TFLAG_OUT_HOB_LBAH;
+			cmd.tf_flags |= IDE_TFLAG_OUT_HOB_LBAH;
 
 		if (req_task->out_flags.b.error_feature)
-			args.tf_flags |= IDE_TFLAG_OUT_FEATURE;
+			cmd.tf_flags |= IDE_TFLAG_OUT_FEATURE;
 		if (req_task->out_flags.b.nsector)
-			args.tf_flags |= IDE_TFLAG_OUT_NSECT;
+			cmd.tf_flags |= IDE_TFLAG_OUT_NSECT;
 		if (req_task->out_flags.b.sector)
-			args.tf_flags |= IDE_TFLAG_OUT_LBAL;
+			cmd.tf_flags |= IDE_TFLAG_OUT_LBAL;
 		if (req_task->out_flags.b.lcyl)
-			args.tf_flags |= IDE_TFLAG_OUT_LBAM;
+			cmd.tf_flags |= IDE_TFLAG_OUT_LBAM;
 		if (req_task->out_flags.b.hcyl)
-			args.tf_flags |= IDE_TFLAG_OUT_LBAH;
+			cmd.tf_flags |= IDE_TFLAG_OUT_LBAH;
 	} else {
-		args.tf_flags |= IDE_TFLAG_OUT_TF;
-		if (args.tf_flags & IDE_TFLAG_LBA48)
-			args.tf_flags |= IDE_TFLAG_OUT_HOB;
+		cmd.tf_flags |= IDE_TFLAG_OUT_TF;
+		if (cmd.tf_flags & IDE_TFLAG_LBA48)
+			cmd.tf_flags |= IDE_TFLAG_OUT_HOB;
 	}
 
 	if (req_task->in_flags.b.data)
-		args.tf_flags |= IDE_TFLAG_IN_DATA;
+		cmd.ftf_flags |= IDE_FTFLAG_IN_DATA;
 
-	switch(req_task->data_phase) {
+	if (req_task->req_cmd == IDE_DRIVE_TASK_RAW_WRITE) {
+		/* fixup data phase if needed */
+		if (req_task->data_phase == TASKFILE_IN_DMAQ ||
+		    req_task->data_phase == TASKFILE_IN_DMA)
+			cmd.tf_flags |= IDE_TFLAG_WRITE;
+	}
+
+	cmd.protocol = ATA_PROT_DMA;
+
+	switch (req_task->data_phase) {
 		case TASKFILE_MULTI_OUT:
 			if (!drive->mult_count) {
 				/* (hs): give up if multcount is not set */
@@ -592,11 +549,14 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 				err = -EPERM;
 				goto abort;
 			}
+			cmd.tf_flags |= IDE_TFLAG_MULTI_PIO;
 			/* fall through */
 		case TASKFILE_OUT:
+			cmd.protocol = ATA_PROT_PIO;
 			/* fall through */
 		case TASKFILE_OUT_DMAQ:
 		case TASKFILE_OUT_DMA:
+			cmd.tf_flags |= IDE_TFLAG_WRITE;
 			nsect = taskout / SECTOR_SIZE;
 			data_buf = outbuf;
 			break;
@@ -609,8 +569,10 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 				err = -EPERM;
 				goto abort;
 			}
+			cmd.tf_flags |= IDE_TFLAG_MULTI_PIO;
 			/* fall through */
 		case TASKFILE_IN:
+			cmd.protocol = ATA_PROT_PIO;
 			/* fall through */
 		case TASKFILE_IN_DMAQ:
 		case TASKFILE_IN_DMA:
@@ -618,6 +580,7 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 			data_buf = inbuf;
 			break;
 		case TASKFILE_NO_DATA:
+			cmd.protocol = ATA_PROT_NODATA;
 			break;
 		default:
 			err = -EFAULT;
@@ -627,7 +590,7 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 	if (req_task->req_cmd == IDE_DRIVE_TASK_NO_DATA)
 		nsect = 0;
 	else if (!nsect) {
-		nsect = (args.tf.hob_nsect << 8) | args.tf.nsect;
+		nsect = (cmd.tf.hob_nsect << 8) | cmd.tf.nsect;
 
 		if (!nsect) {
 			printk(KERN_ERR "%s: in/out command without data\n",
@@ -637,15 +600,14 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 		}
 	}
 
-	if (req_task->req_cmd == IDE_DRIVE_TASK_RAW_WRITE)
-		args.tf_flags |= IDE_TFLAG_WRITE;
-
-	err = ide_raw_taskfile(drive, &args, data_buf, nsect);
+	err = ide_raw_taskfile(drive, &cmd, data_buf, nsect);
 
-	memcpy(req_task->hob_ports, &args.tf_array[0], HDIO_DRIVE_HOB_HDR_SIZE - 2);
-	memcpy(req_task->io_ports, &args.tf_array[6], HDIO_DRIVE_TASK_HDR_SIZE);
+	memcpy(req_task->hob_ports, &cmd.tf_array[0],
+	       HDIO_DRIVE_HOB_HDR_SIZE - 2);
+	memcpy(req_task->io_ports, &cmd.tf_array[6],
+	       HDIO_DRIVE_TASK_HDR_SIZE);
 
-	if ((args.tf_flags & IDE_TFLAG_FLAGGED_SET_IN_FLAGS) &&
+	if ((cmd.ftf_flags & IDE_FTFLAG_SET_IN_FLAGS) &&
 	    req_task->in_flags.all == 0) {
 		req_task->in_flags.all = IDE_TASKFILE_STD_IN_FLAGS;
 		if (drive->dev_flags & IDE_DFLAG_LBA48)
diff --git a/drivers/ide/ide_arm.c b/drivers/ide/ide_arm.c
index bdcac94..cf63854 100644
--- a/drivers/ide/ide_arm.c
+++ b/drivers/ide/ide_arm.c
@@ -18,6 +18,10 @@
 #define IDE_ARM_IO	0x1f0
 #define IDE_ARM_IRQ	IRQ_HARDDISK
 
+static const struct ide_port_info ide_arm_port_info = {
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static int __init ide_arm_init(void)
 {
 	unsigned long base = IDE_ARM_IO, ctl = IDE_ARM_IO + 0x206;
@@ -41,7 +45,7 @@ static int __init ide_arm_init(void)
 	hw.irq = IDE_ARM_IRQ;
 	hw.chipset = ide_generic;
 
-	return ide_host_add(NULL, hws, NULL);
+	return ide_host_add(&ide_arm_port_info, hws, NULL);
 }
 
 module_init(ide_arm_init);
diff --git a/drivers/ide/it821x.c b/drivers/ide/it821x.c
index 6b9fc95..0d4ac65 100644
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -508,10 +508,10 @@ static void it821x_quirkproc(ide_drive_t *drive)
 static struct ide_dma_ops it821x_pass_through_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= it821x_dma_start,
 	.dma_end		= it821x_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
diff --git a/drivers/ide/macide.c b/drivers/ide/macide.c
index 3c60064..4b1718e 100644
--- a/drivers/ide/macide.c
+++ b/drivers/ide/macide.c
@@ -80,6 +80,11 @@ static void __init macide_setup_ports(hw_regs_t *hw, unsigned long base,
 	hw->chipset = ide_generic;
 }
 
+static const struct ide_port_info macide_port_info = {
+	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
+	.irq_flags		= IRQF_SHARED,
+};
+
 static const char *mac_ide_name[] =
 	{ "Quadra", "Powerbook", "Powerbook Baboon" };
 
@@ -122,7 +127,7 @@ static int __init macide_init(void)
 
 	macide_setup_ports(&hw, base, irq, ack_intr);
 
-	return ide_host_add(NULL, hws, NULL);
+	return ide_host_add(&macide_port_info, hws, NULL);
 }
 
 module_init(macide_init);
diff --git a/drivers/ide/ns87415.c b/drivers/ide/ns87415.c
index ea48a3e..7b65fe5 100644
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -61,12 +61,12 @@ static u8 superio_dma_sff_read_status(ide_hwif_t *hwif)
 	return superio_ide_inb(hwif->dma_base + ATA_DMA_STATUS);
 }
 
-static void superio_tf_read(ide_drive_t *drive, ide_task_t *task)
+static void superio_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data = inw(io_ports->data_addr);
 
 		tf->data = data & 0xff;
@@ -76,31 +76,31 @@ static void superio_tf_read(ide_drive_t *drive, ide_task_t *task)
 	/* be sure we're looking at the low order bits */
 	outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
 		tf->feature = inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
 		tf->lbal   = inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
 		tf->lbam   = inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
 		tf->lbah   = inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
 		tf->device = superio_ide_inb(io_ports->device_addr);
 
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
+	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
 		outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
 			tf->hob_nsect   = inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
 			tf->hob_lbal    = inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
 			tf->hob_lbam    = inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
 			tf->hob_lbah    = inb(io_ports->lbah_addr);
 	}
 }
@@ -216,11 +216,11 @@ static int ns87415_dma_end(ide_drive_t *drive)
 	return (dma_stat & 7) != 4;
 }
 
-static int ns87415_dma_setup(ide_drive_t *drive)
+static int ns87415_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	/* select DMA xfer */
 	ns87415_prepare_drive(drive, 1);
-	if (!ide_dma_setup(drive))
+	if (ide_dma_setup(drive, cmd) == 0)
 		return 0;
 	/* DMA failed: select PIO xfer */
 	ns87415_prepare_drive(drive, 0);
@@ -301,11 +301,11 @@ static const struct ide_port_ops ns87415_port_ops = {
 static const struct ide_dma_ops ns87415_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ns87415_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= ns87415_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= superio_dma_sff_read_status,
 };
diff --git a/drivers/ide/palm_bk3710.c b/drivers/ide/palm_bk3710.c
index f38aac7..c7acca0 100644
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -347,7 +347,7 @@ static int __init palm_bk3710_probe(struct platform_device *pdev)
 	struct clk *clk;
 	struct resource *mem, *irq;
 	void __iomem *base;
-	unsigned long rate;
+	unsigned long rate, mem_size;
 	int i, rc;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
@@ -374,13 +374,18 @@ static int __init palm_bk3710_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	if (request_mem_region(mem->start, mem->end - mem->start + 1,
-			       "palm_bk3710") == NULL) {
+	mem_size = mem->end - mem->start + 1;
+	if (request_mem_region(mem->start, mem_size, "palm_bk3710") == NULL) {
 		printk(KERN_ERR "failed to request memory region\n");
 		return -EBUSY;
 	}
 
-	base = IO_ADDRESS(mem->start);
+	base = ioremap(mem->start, mem_size);
+	if (!base) {
+		printk(KERN_ERR "failed to map IO memory\n");
+		release_mem_region(mem->start, mem_size);
+		return -ENOMEM;
+	}
 
 	/* Configure the Palm Chip controller */
 	palm_bk3710_chipinit(base);
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index cba66eb..f7536d1 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -331,11 +331,11 @@ static const struct ide_port_ops pdc2026x_port_ops = {
 static const struct ide_dma_ops pdc20246_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= pdc202xx_dma_test_irq,
 	.dma_lost_irq		= pdc202xx_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= pdc202xx_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
@@ -343,11 +343,11 @@ static const struct ide_dma_ops pdc20246_dma_ops = {
 static const struct ide_dma_ops pdc2026x_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= pdc202xx_dma_start,
 	.dma_end		= pdc202xx_dma_end,
 	.dma_test_irq		= pdc202xx_dma_test_irq,
 	.dma_lost_irq		= pdc202xx_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= pdc202xx_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index 74625e8..2bfcfed 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -404,7 +404,6 @@ kauai_lookup_timing(struct kauai_timing* table, int cycle_time)
 #define IDE_WAKEUP_DELAY	(1*HZ)
 
 static int pmac_ide_init_dma(ide_hwif_t *, const struct ide_port_info *);
-static int pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq);
 static void pmac_ide_selectproc(ide_drive_t *drive);
 static void pmac_ide_kauai_selectproc(ide_drive_t *drive);
 
@@ -1422,17 +1421,16 @@ out:
  * pmac_ide_build_dmatable builds the DBDMA command list
  * for a transfer and sets the DBDMA channel to point to it.
  */
-static int
-pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq)
+static int pmac_ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct dbdma_cmd *table;
-	int i, count = 0;
 	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	struct scatterlist *sg;
-	int wr = (rq_data_dir(rq) == WRITE);
+	int wr = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
+	int i = cmd->sg_nents, count = 0;
 
 	/* DMA table is already aligned */
 	table = (struct dbdma_cmd *) pmif->dma_table_cpu;
@@ -1442,11 +1440,6 @@ pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq)
 	while (readl(&dma->status) & RUN)
 		udelay(1);
 
-	hwif->sg_nents = i = ide_build_sglist(drive, rq);
-
-	if (!i)
-		return 0;
-
 	/* Build DBDMA commands list */
 	sg = hwif->sg_table;
 	while (i && sg_dma_len(sg)) {
@@ -1509,23 +1502,22 @@ use_pio_instead:
  * Prepare a DMA transfer. We build the DMA table, adjust the timings for
  * a read on KeyLargo ATA/66 and mark us as waiting for DMA completion
  */
-static int
-pmac_ide_dma_setup(ide_drive_t *drive)
+static int pmac_ide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
-	struct request *rq = hwif->rq;
 	u8 unit = drive->dn & 1, ata4 = (pmif->kind == controller_kl_ata4);
+	u8 write = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
 
-	if (!pmac_ide_build_dmatable(drive, rq)) {
-		ide_map_sg(drive, rq);
+	if (pmac_ide_build_dmatable(drive, cmd) == 0) {
+		ide_map_sg(drive, cmd);
 		return 1;
 	}
 
 	/* Apple adds 60ns to wrDataSetup on reads */
 	if (ata4 && (pmif->timings[unit] & TR_66_UDMA_EN)) {
-		writel(pmif->timings[unit] + (!rq_data_dir(rq) ? 0x00800000UL : 0),
+		writel(pmif->timings[unit] + (write ? 0 : 0x00800000UL),
 			PMAC_IDE_REG(IDE_TIMING_CONFIG));
 		(void)readl(PMAC_IDE_REG(IDE_TIMING_CONFIG));
 	}
@@ -1535,13 +1527,6 @@ pmac_ide_dma_setup(ide_drive_t *drive)
 	return 0;
 }
 
-static void
-pmac_ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
-{
-	/* issue cmd to drive */
-	ide_execute_command(drive, command, &ide_dma_intr, 2*WAIT_CMD, NULL);
-}
-
 /*
  * Kick the DMA controller into life after the DMA command has been issued
  * to the drive.
@@ -1662,7 +1647,6 @@ pmac_ide_dma_lost_irq (ide_drive_t *drive)
 static const struct ide_dma_ops pmac_dma_ops = {
 	.dma_host_set		= pmac_ide_dma_host_set,
 	.dma_setup		= pmac_ide_dma_setup,
-	.dma_exec_cmd		= pmac_ide_dma_exec_cmd,
 	.dma_start		= pmac_ide_dma_start,
 	.dma_end		= pmac_ide_dma_end,
 	.dma_test_irq		= pmac_ide_dma_test_irq,
diff --git a/drivers/ide/q40ide.c b/drivers/ide/q40ide.c
index 9f9c0b3..2a43a2f 100644
--- a/drivers/ide/q40ide.c
+++ b/drivers/ide/q40ide.c
@@ -72,26 +72,26 @@ static void q40_ide_setup_ports(hw_regs_t *hw, unsigned long base,
 	hw->chipset = ide_generic;
 }
 
-static void q40ide_input_data(ide_drive_t *drive, struct request *rq,
+static void q40ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 			      void *buf, unsigned int len)
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
 		return insw(data_addr, buf, (len + 1) / 2);
 
-	insw_swapw(data_addr, buf, (len + 1) / 2);
+	raw_insw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
 }
 
-static void q40ide_output_data(ide_drive_t *drive, struct request *rq,
+static void q40ide_output_data(ide_drive_t *drive, struct ide_cmd *cmd,
 			       void *buf, unsigned int len)
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
 		return outsw(data_addr, buf, (len + 1) / 2);
 
-	outsw_swapw(data_addr, buf, (len + 1) / 2);
+	raw_outsw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
 }
 
 /* Q40 has a byte-swapped IDE interface */
@@ -111,7 +111,8 @@ static const struct ide_tp_ops q40ide_tp_ops = {
 
 static const struct ide_port_info q40ide_port_info = {
 	.tp_ops			= &q40ide_tp_ops,
-	.host_flags		= IDE_HFLAG_NO_DMA,
+	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
+	.irq_flags		= IRQF_SHARED,
 };
 
 /* 
diff --git a/drivers/ide/sc1200.c b/drivers/ide/sc1200.c
index dbdd298..1c3a829 100644
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -286,11 +286,11 @@ static const struct ide_port_ops sc1200_port_ops = {
 static const struct ide_dma_ops sc1200_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= sc1200_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
diff --git a/drivers/ide/scc_pata.c b/drivers/ide/scc_pata.c
index 8d2314b..0cc137c 100644
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -303,8 +303,9 @@ static void scc_dma_host_set(ide_drive_t *drive, int on)
 }
 
 /**
- *	scc_ide_dma_setup	-	begin a DMA phase
+ *	scc_dma_setup	-	begin a DMA phase
  *	@drive: target device
+ *	@cmd: command
  *
  *	Build an IDE DMA PRD (IDE speak for scatter gather table)
  *	and then set up the DMA transfer registers.
@@ -313,21 +314,15 @@ static void scc_dma_host_set(ide_drive_t *drive, int on)
  *	is returned.
  */
 
-static int scc_dma_setup(ide_drive_t *drive)
+static int scc_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->rq;
-	unsigned int reading;
+	u32 rw = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 0 : ATA_DMA_WR;
 	u8 dma_stat;
 
-	if (rq_data_dir(rq))
-		reading = 0;
-	else
-		reading = 1 << 3;
-
 	/* fall back to pio! */
-	if (!ide_build_dmatable(drive, rq)) {
-		ide_map_sg(drive, rq);
+	if (ide_build_dmatable(drive, cmd) == 0) {
+		ide_map_sg(drive, cmd);
 		return 1;
 	}
 
@@ -335,7 +330,7 @@ static int scc_dma_setup(ide_drive_t *drive)
 	out_be32((void __iomem *)(hwif->dma_base + 8), hwif->dmatable_dma);
 
 	/* specify r/w */
-	out_be32((void __iomem *)hwif->dma_base, reading);
+	out_be32((void __iomem *)hwif->dma_base, rw);
 
 	/* read DMA status for INTR & ERROR flags */
 	dma_stat = scc_dma_sff_read_status(hwif);
@@ -666,52 +661,52 @@ static int __devinit init_setup_scc(struct pci_dev *dev,
 	return rc;
 }
 
-static void scc_tf_load(ide_drive_t *drive, ide_task_t *task)
+static void scc_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+	struct ide_taskfile *tf = &cmd->tf;
+	u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
+	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA)
 		out_be32((void *)io_ports->data_addr,
 			 (tf->hob_data << 8) | tf->data);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		scc_ide_outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
 		scc_ide_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
 		scc_ide_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
 		scc_ide_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
 		scc_ide_outb(tf->hob_lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
 		scc_ide_outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
 		scc_ide_outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
 		scc_ide_outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
 		scc_ide_outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
 		scc_ide_outb(tf->lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
 		scc_ide_outb((tf->device & HIHI) | drive->select,
 			     io_ports->device_addr);
 }
 
-static void scc_tf_read(ide_drive_t *drive, ide_task_t *task)
+static void scc_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data = (u16)in_be32((void *)io_ports->data_addr);
 
 		tf->data = data & 0xff;
@@ -721,36 +716,36 @@ static void scc_tf_read(ide_drive_t *drive, ide_task_t *task)
 	/* be sure we're looking at the low order bits */
 	scc_ide_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
 		tf->feature = scc_ide_inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = scc_ide_inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
 		tf->lbal   = scc_ide_inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
 		tf->lbam   = scc_ide_inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
 		tf->lbah   = scc_ide_inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
 		tf->device = scc_ide_inb(io_ports->device_addr);
 
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
+	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
 		scc_ide_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = scc_ide_inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
 			tf->hob_nsect   = scc_ide_inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
 			tf->hob_lbal    = scc_ide_inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
 			tf->hob_lbam    = scc_ide_inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
 			tf->hob_lbah    = scc_ide_inb(io_ports->lbah_addr);
 	}
 }
 
-static void scc_input_data(ide_drive_t *drive, struct request *rq,
+static void scc_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 			   void *buf, unsigned int len)
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
@@ -766,7 +761,7 @@ static void scc_input_data(ide_drive_t *drive, struct request *rq,
 		scc_ide_insw(data_addr, buf, len / 2);
 }
 
-static void scc_output_data(ide_drive_t *drive,  struct request *rq,
+static void scc_output_data(ide_drive_t *drive,  struct ide_cmd *cmd,
 			    void *buf, unsigned int len)
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
@@ -873,30 +868,26 @@ static const struct ide_port_ops scc_port_ops = {
 static const struct ide_dma_ops scc_dma_ops = {
 	.dma_host_set		= scc_dma_host_set,
 	.dma_setup		= scc_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= scc_dma_start,
 	.dma_end		= scc_dma_end,
 	.dma_test_irq		= scc_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_sff_read_status	= scc_dma_sff_read_status,
 };
 
-#define DECLARE_SCC_DEV(name_str)			\
-  {							\
-      .name		= name_str,			\
-      .init_iops	= init_iops_scc,		\
-      .init_dma		= scc_init_dma,			\
-      .init_hwif	= init_hwif_scc,		\
-      .tp_ops		= &scc_tp_ops,		\
-      .port_ops		= &scc_port_ops,		\
-      .dma_ops		= &scc_dma_ops,			\
-      .host_flags	= IDE_HFLAG_SINGLE,		\
-      .pio_mask		= ATA_PIO4,			\
-  }
-
-static const struct ide_port_info scc_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_SCC_DEV("sccIDE"),
+static const struct ide_port_info scc_chipset __devinitdata = {
+	.name		= "sccIDE",
+	.init_iops	= init_iops_scc,
+	.init_dma	= scc_init_dma,
+	.init_hwif	= init_hwif_scc,
+	.tp_ops		= &scc_tp_ops,
+	.port_ops	= &scc_port_ops,
+	.dma_ops	= &scc_dma_ops,
+	.host_flags	= IDE_HFLAG_SINGLE,
+	.irq_flags	= IRQF_SHARED,
+	.pio_mask	= ATA_PIO4,
 };
 
 /**
@@ -910,7 +901,7 @@ static const struct ide_port_info scc_chipsets[] __devinitdata = {
 
 static int __devinit scc_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return init_setup_scc(dev, &scc_chipsets[id->driver_data]);
+	return init_setup_scc(dev, &scc_chipset);
 }
 
 /**
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 24bc884..a19dbcc 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -558,6 +558,8 @@ int ide_pci_init_one(struct pci_dev *dev, const struct ide_port_info *d,
 
 	host->host_priv = priv;
 
+	host->irq_flags = IRQF_SHARED;
+
 	pci_set_drvdata(dev, host);
 
 	ret = do_ide_setup_pci_device(dev, d, 1);
@@ -606,6 +608,8 @@ int ide_pci_init_two(struct pci_dev *dev1, struct pci_dev *dev2,
 
 	host->host_priv = priv;
 
+	host->irq_flags = IRQF_SHARED;
+
 	pci_set_drvdata(pdev[0], host);
 	pci_set_drvdata(pdev[1], host);
 
diff --git a/drivers/ide/sgiioc4.c b/drivers/ide/sgiioc4.c
index fdb9d70..b12de83 100644
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -424,20 +424,13 @@ sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 /* | Upper 32 bits - Zero	    |EOL| 15 unused     | 16 Bit Length| */
 /* --------------------------------------------------------------------- */
 /* Creates the scatter gather list, DMA Table */
-static unsigned int
-sgiioc4_build_dma_table(ide_drive_t * drive, struct request *rq, int ddir)
+static int sgiioc4_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	unsigned int *table = hwif->dmatable_cpu;
-	unsigned int count = 0, i = 1;
-	struct scatterlist *sg;
+	unsigned int count = 0, i = cmd->sg_nents;
+	struct scatterlist *sg = hwif->sg_table;
 
-	hwif->sg_nents = i = ide_build_sglist(drive, rq);
-
-	if (!i)
-		return 0;	/* sglist of length Zero */
-
-	sg = hwif->sg_table;
 	while (i && sg_dma_len(sg)) {
 		dma_addr_t cur_addr;
 		int cur_len;
@@ -490,24 +483,18 @@ use_pio_instead:
 	return 0;		/* revert to PIO for this request */
 }
 
-static int sgiioc4_dma_setup(ide_drive_t *drive)
+static int sgiioc4_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	struct request *rq = drive->hwif->rq;
-	unsigned int count = 0;
 	int ddir;
+	u8 write = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
 
-	if (rq_data_dir(rq))
-		ddir = PCI_DMA_TODEVICE;
-	else
-		ddir = PCI_DMA_FROMDEVICE;
-
-	if (!(count = sgiioc4_build_dma_table(drive, rq, ddir))) {
+	if (sgiioc4_build_dmatable(drive, cmd) == 0) {
 		/* try PIO instead of DMA */
-		ide_map_sg(drive, rq);
+		ide_map_sg(drive, cmd);
 		return 1;
 	}
 
-	if (rq_data_dir(rq))
+	if (write)
 		/* Writes TO the IOC4 FROM Main Memory */
 		ddir = IOC4_DMA_READ;
 	else
@@ -557,6 +544,7 @@ static const struct ide_port_info sgiioc4_port_info __devinitconst = {
 	.port_ops		= &sgiioc4_port_ops,
 	.dma_ops		= &sgiioc4_dma_ops,
 	.host_flags		= IDE_HFLAG_MMIO,
+	.irq_flags		= IRQF_SHARED,
 	.mwdma_mask		= ATA_MWDMA2_ONLY,
 };
 
diff --git a/drivers/ide/siimage.c b/drivers/ide/siimage.c
index 1811ae9..075cb12 100644
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -711,10 +711,10 @@ static const struct ide_port_ops sil_sata_port_ops = {
 static const struct ide_dma_ops sil_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= siimage_dma_test_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
diff --git a/drivers/ide/sl82c105.c b/drivers/ide/sl82c105.c
index dba213c..d25137b 100644
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -293,11 +293,11 @@ static const struct ide_port_ops sl82c105_port_ops = {
 static const struct ide_dma_ops sl82c105_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= sl82c105_dma_start,
 	.dma_end		= sl82c105_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= sl82c105_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= sl82c105_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
diff --git a/drivers/ide/tc86c001.c b/drivers/ide/tc86c001.c
index 84109f5..427d4b3 100644
--- a/drivers/ide/tc86c001.c
+++ b/drivers/ide/tc86c001.c
@@ -182,11 +182,11 @@ static const struct ide_port_ops tc86c001_port_ops = {
 static const struct ide_dma_ops tc86c001_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= tc86c001_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
diff --git a/drivers/ide/trm290.c b/drivers/ide/trm290.c
index 1c09e54..ed14968 100644
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -176,18 +176,12 @@ static void trm290_selectproc (ide_drive_t *drive)
 	trm290_prepare_drive(drive, !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
 }
 
-static void trm290_dma_exec_cmd(ide_drive_t *drive, u8 command)
-{
-	ide_execute_command(drive, command, &ide_dma_intr, WAIT_CMD, NULL);
-}
-
-static int trm290_dma_setup(ide_drive_t *drive)
+static int trm290_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->rq;
 	unsigned int count, rw;
 
-	if (rq_data_dir(rq)) {
+	if (cmd->tf_flags & IDE_TFLAG_WRITE) {
 #ifdef TRM290_NO_DMA_WRITES
 		/* always use PIO for writes */
 		trm290_prepare_drive(drive, 0);	/* select PIO xfer */
@@ -197,7 +191,9 @@ static int trm290_dma_setup(ide_drive_t *drive)
 	} else
 		rw = 2;
 
-	if (!(count = ide_build_dmatable(drive, rq))) {
+	count = ide_build_dmatable(drive, cmd);
+	if (count == 0) {
+		ide_map_sg(drive, cmd);
 		/* try PIO instead of DMA */
 		trm290_prepare_drive(drive, 0); /* select PIO xfer */
 		return 1;
@@ -314,7 +310,6 @@ static const struct ide_port_ops trm290_port_ops = {
 static struct ide_dma_ops trm290_dma_ops = {
 	.dma_host_set		= trm290_dma_host_set,
 	.dma_setup 		= trm290_dma_setup,
-	.dma_exec_cmd		= trm290_dma_exec_cmd,
 	.dma_start 		= trm290_dma_start,
 	.dma_end		= trm290_dma_end,
 	.dma_test_irq		= trm290_dma_test_irq,
diff --git a/drivers/ide/tx4938ide.c b/drivers/ide/tx4938ide.c
index d909534..657a618 100644
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -15,6 +15,8 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+
+#include <asm/ide.h>
 #include <asm/txx9/tx4938.h>
 
 static void tx4938ide_tune_ebusc(unsigned int ebus_ch,
@@ -80,57 +82,57 @@ static void tx4938ide_outb(u8 value, unsigned long port)
 	__raw_writeb(value, (void __iomem *)port);
 }
 
-static void tx4938ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+static void tx4938ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	u8 HIHI = task->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
+	struct ide_taskfile *tf = &cmd->tf;
+	u8 HIHI = cmd->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA) {
 		u16 data = (tf->hob_data << 8) | tf->data;
 
 		/* no endian swap */
 		__raw_writew(data, (void __iomem *)io_ports->data_addr);
 	}
 
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		tx4938ide_outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
 		tx4938ide_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
 		tx4938ide_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
 		tx4938ide_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
 		tx4938ide_outb(tf->hob_lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
 		tx4938ide_outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
 		tx4938ide_outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
 		tx4938ide_outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
 		tx4938ide_outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
 		tx4938ide_outb(tf->lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
 		tx4938ide_outb((tf->device & HIHI) | drive->select,
 			       io_ports->device_addr);
 }
 
-static void tx4938ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+static void tx4938ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data;
 
 		/* no endian swap */
@@ -142,37 +144,37 @@ static void tx4938ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 	/* be sure we're looking at the low order bits */
 	tx4938ide_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
 		tf->feature = tx4938ide_inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = tx4938ide_inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
 		tf->lbal   = tx4938ide_inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
 		tf->lbam   = tx4938ide_inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
 		tf->lbah   = tx4938ide_inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
 		tf->device = tx4938ide_inb(io_ports->device_addr);
 
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
+	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
 		tx4938ide_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature =
 				tx4938ide_inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
 			tf->hob_nsect   = tx4938ide_inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
 			tf->hob_lbal    = tx4938ide_inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
 			tf->hob_lbam    = tx4938ide_inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
 			tf->hob_lbah    = tx4938ide_inb(io_ports->lbah_addr);
 	}
 }
 
-static void tx4938ide_input_data_swap(ide_drive_t *drive, struct request *rq,
+static void tx4938ide_input_data_swap(ide_drive_t *drive, struct ide_cmd *cmd,
 				void *buf, unsigned int len)
 {
 	unsigned long port = drive->hwif->io_ports.data_addr;
@@ -184,7 +186,7 @@ static void tx4938ide_input_data_swap(ide_drive_t *drive, struct request *rq,
 	__ide_flush_dcache_range((unsigned long)buf, roundup(len, 2));
 }
 
-static void tx4938ide_output_data_swap(ide_drive_t *drive, struct request *rq,
+static void tx4938ide_output_data_swap(ide_drive_t *drive, struct ide_cmd *cmd,
 				void *buf, unsigned int len)
 {
 	unsigned long port = drive->hwif->io_ports.data_addr;
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index 40b0812..e0e0a80 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -18,6 +18,8 @@
 #include <linux/io.h>
 #include <linux/scatterlist.h>
 
+#include <asm/ide.h>
+
 #define MODNAME	"tx4939ide"
 
 /* ATA Shadow Registers (8-bit except for Data which is 16-bit) */
@@ -230,7 +232,7 @@ static u8 tx4939ide_clear_dma_status(void __iomem *base)
 
 #ifdef __BIG_ENDIAN
 /* custom ide_build_dmatable to handle swapped layout */
-static int tx4939ide_build_dmatable(ide_drive_t *drive, struct request *rq)
+static int tx4939ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u32 *table = (u32 *)hwif->dmatable_cpu;
@@ -238,11 +240,7 @@ static int tx4939ide_build_dmatable(ide_drive_t *drive, struct request *rq)
 	int i;
 	struct scatterlist *sg;
 
-	hwif->sg_nents = ide_build_sglist(drive, rq);
-	if (hwif->sg_nents == 0)
-		return 0;
-
-	for_each_sg(hwif->sg_table, sg, hwif->sg_nents, i) {
+	for_each_sg(hwif->sg_table, sg, cmd->sg_nents, i) {
 		u32 cur_addr, cur_len, bcount;
 
 		cur_addr = sg_dma_address(sg);
@@ -289,23 +287,15 @@ use_pio_instead:
 #define tx4939ide_build_dmatable	ide_build_dmatable
 #endif
 
-static int tx4939ide_dma_setup(ide_drive_t *drive)
+static int tx4939ide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	void __iomem *base = TX4939IDE_BASE(hwif);
-	struct request *rq = hwif->rq;
-	u8 reading;
-	int nent;
-
-	if (rq_data_dir(rq))
-		reading = 0;
-	else
-		reading = ATA_DMA_WR;
+	u8 rw = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 0 : ATA_DMA_WR;
 
 	/* fall back to PIO! */
-	nent = tx4939ide_build_dmatable(drive, rq);
-	if (!nent) {
-		ide_map_sg(drive, rq);
+	if (tx4939ide_build_dmatable(drive, cmd) == 0) {
+		ide_map_sg(drive, cmd);
 		return 1;
 	}
 
@@ -313,7 +303,7 @@ static int tx4939ide_dma_setup(ide_drive_t *drive)
 	tx4939ide_writel(hwif->dmatable_dma, base, TX4939IDE_PRD_Ptr);
 
 	/* specify r/w */
-	tx4939ide_writeb(reading, base, TX4939IDE_DMA_Cmd);
+	tx4939ide_writeb(rw, base, TX4939IDE_DMA_Cmd);
 
 	/* clear INTR & ERROR flags */
 	tx4939ide_clear_dma_status(base);
@@ -322,7 +312,9 @@ static int tx4939ide_dma_setup(ide_drive_t *drive)
 
 	tx4939ide_writew(SECTOR_SIZE / 2, base, drive->dn ?
 			 TX4939IDE_Xfer_Cnt_2 : TX4939IDE_Xfer_Cnt_1);
-	tx4939ide_writew(rq->nr_sectors, base, TX4939IDE_Sec_Cnt);
+
+	tx4939ide_writew(cmd->rq->nr_sectors, base, TX4939IDE_Sec_Cnt);
+
 	return 0;
 }
 
@@ -437,7 +429,7 @@ static int tx4939ide_init_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 	return ide_allocate_dma_engine(hwif);
 }
 
-static void tx4939ide_tf_load_fixup(ide_drive_t *drive, ide_task_t *task)
+static void tx4939ide_tf_load_fixup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	void __iomem *base = TX4939IDE_BASE(hwif);
@@ -465,59 +457,59 @@ static void tx4939ide_outb(u8 value, unsigned long port)
 	__raw_writeb(value, (void __iomem *)port);
 }
 
-static void tx4939ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+static void tx4939ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	u8 HIHI = task->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
+	struct ide_taskfile *tf = &cmd->tf;
+	u8 HIHI = cmd->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA) {
 		u16 data = (tf->hob_data << 8) | tf->data;
 
 		/* no endian swap */
 		__raw_writew(data, (void __iomem *)io_ports->data_addr);
 	}
 
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		tx4939ide_outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
 		tx4939ide_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
 		tx4939ide_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
 		tx4939ide_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
 		tx4939ide_outb(tf->hob_lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
 		tx4939ide_outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
 		tx4939ide_outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
 		tx4939ide_outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
 		tx4939ide_outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
 		tx4939ide_outb(tf->lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE) {
+	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE) {
 		tx4939ide_outb((tf->device & HIHI) | drive->select,
 			       io_ports->device_addr);
-		tx4939ide_tf_load_fixup(drive, task);
+		tx4939ide_tf_load_fixup(drive);
 	}
 }
 
-static void tx4939ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+static void tx4939ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data;
 
 		/* no endian swap */
@@ -529,32 +521,32 @@ static void tx4939ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 	/* be sure we're looking at the low order bits */
 	tx4939ide_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
 		tf->feature = tx4939ide_inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = tx4939ide_inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
 		tf->lbal   = tx4939ide_inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
 		tf->lbam   = tx4939ide_inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
 		tf->lbah   = tx4939ide_inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
 		tf->device = tx4939ide_inb(io_ports->device_addr);
 
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
+	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
 		tx4939ide_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature =
 				tx4939ide_inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
 			tf->hob_nsect   = tx4939ide_inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
 			tf->hob_lbal    = tx4939ide_inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
 			tf->hob_lbam    = tx4939ide_inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
 			tf->hob_lbah    = tx4939ide_inb(io_ports->lbah_addr);
 	}
 }
@@ -601,11 +593,12 @@ static const struct ide_tp_ops tx4939ide_tp_ops = {
 
 #else	/* __LITTLE_ENDIAN */
 
-static void tx4939ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+static void tx4939ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	ide_tf_load(drive, task);
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		tx4939ide_tf_load_fixup(drive, task);
+	ide_tf_load(drive, cmd);
+
+	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		tx4939ide_tf_load_fixup(drive);
 }
 
 static const struct ide_tp_ops tx4939ide_tp_ops = {
@@ -634,11 +627,11 @@ static const struct ide_port_ops tx4939ide_port_ops = {
 static const struct ide_dma_ops tx4939ide_dma_ops = {
 	.dma_host_set		= tx4939ide_dma_host_set,
 	.dma_setup		= tx4939ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= tx4939ide_dma_end,
 	.dma_test_irq		= tx4939ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= tx4939ide_dma_sff_read_status,
 };
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 854eba8..d5d8322 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -40,6 +40,13 @@
 #define ERROR_RESET	3	/* Reset controller every 4th retry */
 #define ERROR_RECAL	1	/* Recalibrate every 2nd retry */
 
+/* Error codes returned in rq->errors to the higher part of the driver. */
+enum {
+	IDE_DRV_ERROR_GENERAL	= 101,
+	IDE_DRV_ERROR_FILEMARK	= 102,
+	IDE_DRV_ERROR_EOD	= 103,
+};
+
 /*
  * Definitions for accessing IDE controller registers
  */
@@ -193,26 +200,8 @@ static inline void ide_std_init_ports(hw_regs_t *hw,
 	hw->io_ports.ctl_addr = ctl_addr;
 }
 
-#if defined(CONFIG_ARM) || defined(CONFIG_M68K) || defined(CONFIG_MIPS) || \
-    defined(CONFIG_PARISC) || defined(CONFIG_PPC) || defined(CONFIG_SPARC)
-#include <asm/ide.h>
-#else
-#include <asm-generic/ide_iops.h>
-#endif
-
 #define MAX_HWIFS	10
 
-/* Currently only m68k, apus and m8xx need it */
-#ifndef IDE_ARCH_ACK_INTR
-# define ide_ack_intr(hwif) (1)
-#endif
-
-/* Currently only Atari needs it */
-#ifndef IDE_ARCH_LOCK
-# define ide_release_lock()			do {} while (0)
-# define ide_get_lock(hdlr, data)		do {} while (0)
-#endif /* IDE_ARCH_LOCK */
-
 /*
  * Now for the data we need to maintain per-drive:  ide_drive_t
  */
@@ -252,56 +241,52 @@ typedef enum {
 
 enum {
 	IDE_TFLAG_LBA48			= (1 << 0),
-	IDE_TFLAG_FLAGGED		= (1 << 2),
-	IDE_TFLAG_OUT_DATA		= (1 << 3),
-	IDE_TFLAG_OUT_HOB_FEATURE	= (1 << 4),
-	IDE_TFLAG_OUT_HOB_NSECT		= (1 << 5),
-	IDE_TFLAG_OUT_HOB_LBAL		= (1 << 6),
-	IDE_TFLAG_OUT_HOB_LBAM		= (1 << 7),
-	IDE_TFLAG_OUT_HOB_LBAH		= (1 << 8),
+	IDE_TFLAG_OUT_HOB_FEATURE	= (1 << 1),
+	IDE_TFLAG_OUT_HOB_NSECT		= (1 << 2),
+	IDE_TFLAG_OUT_HOB_LBAL		= (1 << 3),
+	IDE_TFLAG_OUT_HOB_LBAM		= (1 << 4),
+	IDE_TFLAG_OUT_HOB_LBAH		= (1 << 5),
 	IDE_TFLAG_OUT_HOB		= IDE_TFLAG_OUT_HOB_FEATURE |
 					  IDE_TFLAG_OUT_HOB_NSECT |
 					  IDE_TFLAG_OUT_HOB_LBAL |
 					  IDE_TFLAG_OUT_HOB_LBAM |
 					  IDE_TFLAG_OUT_HOB_LBAH,
-	IDE_TFLAG_OUT_FEATURE		= (1 << 9),
-	IDE_TFLAG_OUT_NSECT		= (1 << 10),
-	IDE_TFLAG_OUT_LBAL		= (1 << 11),
-	IDE_TFLAG_OUT_LBAM		= (1 << 12),
-	IDE_TFLAG_OUT_LBAH		= (1 << 13),
+	IDE_TFLAG_OUT_FEATURE		= (1 << 6),
+	IDE_TFLAG_OUT_NSECT		= (1 << 7),
+	IDE_TFLAG_OUT_LBAL		= (1 << 8),
+	IDE_TFLAG_OUT_LBAM		= (1 << 9),
+	IDE_TFLAG_OUT_LBAH		= (1 << 10),
 	IDE_TFLAG_OUT_TF		= IDE_TFLAG_OUT_FEATURE |
 					  IDE_TFLAG_OUT_NSECT |
 					  IDE_TFLAG_OUT_LBAL |
 					  IDE_TFLAG_OUT_LBAM |
 					  IDE_TFLAG_OUT_LBAH,
-	IDE_TFLAG_OUT_DEVICE		= (1 << 14),
-	IDE_TFLAG_WRITE			= (1 << 15),
-	IDE_TFLAG_FLAGGED_SET_IN_FLAGS	= (1 << 16),
-	IDE_TFLAG_IN_DATA		= (1 << 17),
-	IDE_TFLAG_CUSTOM_HANDLER	= (1 << 18),
-	IDE_TFLAG_DMA_PIO_FALLBACK	= (1 << 19),
-	IDE_TFLAG_IN_HOB_FEATURE	= (1 << 20),
-	IDE_TFLAG_IN_HOB_NSECT		= (1 << 21),
-	IDE_TFLAG_IN_HOB_LBAL		= (1 << 22),
-	IDE_TFLAG_IN_HOB_LBAM		= (1 << 23),
-	IDE_TFLAG_IN_HOB_LBAH		= (1 << 24),
+	IDE_TFLAG_OUT_DEVICE		= (1 << 11),
+	IDE_TFLAG_WRITE			= (1 << 12),
+	IDE_TFLAG_CUSTOM_HANDLER	= (1 << 13),
+	IDE_TFLAG_DMA_PIO_FALLBACK	= (1 << 14),
+	IDE_TFLAG_IN_HOB_FEATURE	= (1 << 15),
+	IDE_TFLAG_IN_HOB_NSECT		= (1 << 16),
+	IDE_TFLAG_IN_HOB_LBAL		= (1 << 17),
+	IDE_TFLAG_IN_HOB_LBAM		= (1 << 18),
+	IDE_TFLAG_IN_HOB_LBAH		= (1 << 19),
 	IDE_TFLAG_IN_HOB_LBA		= IDE_TFLAG_IN_HOB_LBAL |
 					  IDE_TFLAG_IN_HOB_LBAM |
 					  IDE_TFLAG_IN_HOB_LBAH,
 	IDE_TFLAG_IN_HOB		= IDE_TFLAG_IN_HOB_FEATURE |
 					  IDE_TFLAG_IN_HOB_NSECT |
 					  IDE_TFLAG_IN_HOB_LBA,
-	IDE_TFLAG_IN_FEATURE		= (1 << 1),
-	IDE_TFLAG_IN_NSECT		= (1 << 25),
-	IDE_TFLAG_IN_LBAL		= (1 << 26),
-	IDE_TFLAG_IN_LBAM		= (1 << 27),
-	IDE_TFLAG_IN_LBAH		= (1 << 28),
+	IDE_TFLAG_IN_FEATURE		= (1 << 20),
+	IDE_TFLAG_IN_NSECT		= (1 << 21),
+	IDE_TFLAG_IN_LBAL		= (1 << 22),
+	IDE_TFLAG_IN_LBAM		= (1 << 23),
+	IDE_TFLAG_IN_LBAH		= (1 << 24),
 	IDE_TFLAG_IN_LBA		= IDE_TFLAG_IN_LBAL |
 					  IDE_TFLAG_IN_LBAM |
 					  IDE_TFLAG_IN_LBAH,
 	IDE_TFLAG_IN_TF			= IDE_TFLAG_IN_NSECT |
 					  IDE_TFLAG_IN_LBA,
-	IDE_TFLAG_IN_DEVICE		= (1 << 29),
+	IDE_TFLAG_IN_DEVICE		= (1 << 25),
 	IDE_TFLAG_HOB			= IDE_TFLAG_OUT_HOB |
 					  IDE_TFLAG_IN_HOB,
 	IDE_TFLAG_TF			= IDE_TFLAG_OUT_TF |
@@ -309,9 +294,18 @@ enum {
 	IDE_TFLAG_DEVICE		= IDE_TFLAG_OUT_DEVICE |
 					  IDE_TFLAG_IN_DEVICE,
 	/* force 16-bit I/O operations */
-	IDE_TFLAG_IO_16BIT		= (1 << 30),
-	/* ide_task_t was allocated using kmalloc() */
-	IDE_TFLAG_DYN			= (1 << 31),
+	IDE_TFLAG_IO_16BIT		= (1 << 26),
+	/* struct ide_cmd was allocated using kmalloc() */
+	IDE_TFLAG_DYN			= (1 << 27),
+	IDE_TFLAG_FS			= (1 << 28),
+	IDE_TFLAG_MULTI_PIO		= (1 << 29),
+};
+
+enum {
+	IDE_FTFLAG_FLAGGED		= (1 << 0),
+	IDE_FTFLAG_SET_IN_FLAGS		= (1 << 1),
+	IDE_FTFLAG_OUT_DATA		= (1 << 2),
+	IDE_FTFLAG_IN_DATA		= (1 << 3),
 };
 
 struct ide_taskfile {
@@ -343,16 +337,27 @@ struct ide_taskfile {
 	};
 };
 
-typedef struct ide_task_s {
+struct ide_cmd {
 	union {
 		struct ide_taskfile	tf;
 		u8			tf_array[14];
 	};
+	u8			ftf_flags;	/* for TASKFILE ioctl */
 	u32			tf_flags;
-	int			data_phase;
+	int			protocol;
+
+	int			sg_nents;	  /* number of sg entries */
+	int			orig_sg_nents;
+	int			sg_dma_direction; /* DMA transfer direction */
+
+	unsigned int		nbytes;
+	unsigned int		nleft;
+	struct scatterlist	*cursg;
+	unsigned int		cursg_ofs;
+
 	struct request		*rq;		/* copy of request */
 	void			*special;	/* valid_t generally */
-} ide_task_t;
+};
 
 /* ATAPI packet command flags */
 enum {
@@ -364,8 +369,6 @@ enum {
 	PC_FLAG_DMA_IN_PROGRESS		= (1 << 4),
 	PC_FLAG_DMA_ERROR		= (1 << 5),
 	PC_FLAG_WRITING			= (1 << 6),
-	/* command timed out */
-	PC_FLAG_TIMEDOUT		= (1 << 7),
 };
 
 /*
@@ -436,7 +439,6 @@ struct ide_disk_ops {
 					int);
 	ide_startstop_t	(*do_request)(struct ide_drive_s *, struct request *,
 				      sector_t);
-	int		(*end_request)(struct ide_drive_s *, int, int);
 	int		(*ioctl)(struct ide_drive_s *, struct block_device *,
 				 fmode_t, unsigned int, unsigned long);
 };
@@ -512,8 +514,6 @@ enum {
 	IDE_DFLAG_NICE1			= (1 << 5),
 	/* device is physically present */
 	IDE_DFLAG_PRESENT		= (1 << 6),
-	/* device ejected hint */
-	IDE_DFLAG_DEAD			= (1 << 7),
 	/* id read from device (synthetic if not set) */
 	IDE_DFLAG_ID_READ		= (1 << 8),
 	IDE_DFLAG_NOPROBE		= (1 << 9),
@@ -627,8 +627,11 @@ struct ide_drive_s {
 	/* current packet command */
 	struct ide_atapi_pc *pc;
 
+	/* last failed packet command */
+	struct ide_atapi_pc *failed_pc;
+
 	/* callback for packet commands */
-	void (*pc_callback)(struct ide_drive_s *, int);
+	int  (*pc_callback)(struct ide_drive_s *, int);
 
 	void (*pc_update_buffers)(struct ide_drive_s *, struct ide_atapi_pc *);
 	int  (*pc_io_buffers)(struct ide_drive_s *, struct ide_atapi_pc *,
@@ -661,13 +664,13 @@ struct ide_tp_ops {
 
 	void	(*set_irq)(struct hwif_s *, int);
 
-	void	(*tf_load)(ide_drive_t *, struct ide_task_s *);
-	void	(*tf_read)(ide_drive_t *, struct ide_task_s *);
+	void	(*tf_load)(ide_drive_t *, struct ide_cmd *);
+	void	(*tf_read)(ide_drive_t *, struct ide_cmd *);
 
-	void	(*input_data)(ide_drive_t *, struct request *, void *,
-			      unsigned int);
-	void	(*output_data)(ide_drive_t *, struct request *, void *,
-			       unsigned int);
+	void	(*input_data)(ide_drive_t *, struct ide_cmd *,
+			      void *, unsigned int);
+	void	(*output_data)(ide_drive_t *, struct ide_cmd *,
+			       void *, unsigned int);
 };
 
 extern const struct ide_tp_ops default_tp_ops;
@@ -711,12 +714,12 @@ struct ide_port_ops {
 
 struct ide_dma_ops {
 	void	(*dma_host_set)(struct ide_drive_s *, int);
-	int	(*dma_setup)(struct ide_drive_s *);
-	void	(*dma_exec_cmd)(struct ide_drive_s *, u8);
+	int	(*dma_setup)(struct ide_drive_s *, struct ide_cmd *);
 	void	(*dma_start)(struct ide_drive_s *);
 	int	(*dma_end)(struct ide_drive_s *);
 	int	(*dma_test_irq)(struct ide_drive_s *);
 	void	(*dma_lost_irq)(struct ide_drive_s *);
+	int	(*dma_timer_expiry)(struct ide_drive_s *);
 	void	(*dma_timeout)(struct ide_drive_s *);
 	/*
 	 * The following method is optional and only required to be
@@ -780,19 +783,8 @@ typedef struct hwif_s {
 	/* Scatter-gather list used to build the above */
 	struct scatterlist *sg_table;
 	int sg_max_nents;		/* Maximum number of entries in it */
-	int sg_nents;			/* Current number of entries in it */
-	int orig_sg_nents;
-	int sg_dma_direction;		/* dma transfer direction */
-
-	/* data phase of the active command (currently only valid for PIO/DMA) */
-	int		data_phase;
 
-	struct ide_task_s task;		/* current command */
-
-	unsigned int nsect;
-	unsigned int nleft;
-	struct scatterlist *cursg;
-	unsigned int cursg_ofs;
+	struct ide_cmd cmd;		/* current command */
 
 	int		rqsize;		/* max sectors per request */
 	int		irq;		/* our irq number */
@@ -850,9 +842,18 @@ struct ide_host {
 	ide_hwif_t	*ports[MAX_HOST_PORTS + 1];
 	unsigned int	n_ports;
 	struct device	*dev[2];
+
 	int		(*init_chipset)(struct pci_dev *);
+
+	void		(*get_lock)(irq_handler_t, void *);
+	void		(*release_lock)(void);
+
 	irq_handler_t	irq_handler;
+
 	unsigned long	host_flags;
+
+	int		irq_flags;
+
 	void		*host_priv;
 	ide_hwif_t	*cur_port;	/* for hosts requiring serialization */
 
@@ -869,7 +870,7 @@ typedef ide_startstop_t (ide_handler_t)(ide_drive_t *);
 typedef int (ide_expiry_t)(ide_drive_t *);
 
 /* used by ide-cd, ide-floppy, etc. */
-typedef void (xfer_func_t)(ide_drive_t *, struct request *rq, void *, unsigned);
+typedef void (xfer_func_t)(ide_drive_t *, struct ide_cmd *, void *, unsigned);
 
 extern struct mutex ide_setting_mtx;
 
@@ -1045,10 +1046,11 @@ enum {
 };
 
 /* DRV_NAME has to be defined in the driver before using the macro below */
-#define __ide_debug_log(lvl, fmt, args...)			\
-{								\
-	if (unlikely(drive->debug_mask & lvl))			\
-		printk(KERN_INFO DRV_NAME ": " fmt, ## args);	\
+#define __ide_debug_log(lvl, fmt, args...)				\
+{									\
+	if (unlikely(drive->debug_mask & lvl))				\
+		printk(KERN_INFO DRV_NAME ": %s: " fmt "\n",		\
+					  __func__, ## args);		\
 }
 
 /*
@@ -1087,7 +1089,7 @@ int generic_ide_resume(struct device *);
 
 void ide_complete_power_step(ide_drive_t *, struct request *);
 ide_startstop_t ide_start_power_step(ide_drive_t *, struct request *);
-void ide_complete_pm_request(ide_drive_t *, struct request *);
+void ide_complete_pm_rq(ide_drive_t *, struct request *);
 void ide_check_pm_state(ide_drive_t *, struct request *);
 
 /*
@@ -1099,7 +1101,6 @@ void ide_check_pm_state(ide_drive_t *, struct request *);
 struct ide_driver {
 	const char			*version;
 	ide_startstop_t	(*do_request)(ide_drive_t *, struct request *, sector_t);
-	int		(*end_request)(ide_drive_t *, int, int);
 	struct device_driver	gen_driver;
 	int		(*probe)(ide_drive_t *);
 	void		(*remove)(ide_drive_t *);
@@ -1130,19 +1131,15 @@ int generic_ide_ioctl(ide_drive_t *, struct block_device *, unsigned, unsigned l
 extern int ide_vlb_clk;
 extern int ide_pci_clk;
 
-int ide_end_request(ide_drive_t *, int, int);
-int ide_end_dequeued_request(ide_drive_t *, struct request *, int, int);
+unsigned int ide_rq_bytes(struct request *);
+int ide_end_rq(ide_drive_t *, struct request *, int, unsigned int);
 void ide_kill_rq(ide_drive_t *, struct request *);
 
-void __ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int,
-		       ide_expiry_t *);
-void ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int,
-		     ide_expiry_t *);
-
-void ide_execute_command(ide_drive_t *, u8, ide_handler_t *, unsigned int,
-			 ide_expiry_t *);
+void __ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int);
+void ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int);
 
-void ide_execute_pkt_cmd(ide_drive_t *);
+void ide_execute_command(ide_drive_t *, struct ide_cmd *, ide_handler_t *,
+			 unsigned int);
 
 void ide_pad_transfer(ide_drive_t *, int, int);
 
@@ -1164,7 +1161,8 @@ extern ide_startstop_t ide_do_reset (ide_drive_t *);
 extern int ide_devset_execute(ide_drive_t *drive,
 			      const struct ide_devset *setting, int arg);
 
-extern void ide_end_drive_cmd(ide_drive_t *, u8, u8);
+void ide_complete_cmd(ide_drive_t *, struct ide_cmd *, u8, u8);
+int ide_complete_rq(ide_drive_t *, int, unsigned int);
 
 void ide_tf_dump(const char *, struct ide_taskfile *);
 
@@ -1174,11 +1172,11 @@ u8 ide_read_altstatus(ide_hwif_t *);
 
 void ide_set_irq(ide_hwif_t *, int);
 
-void ide_tf_load(ide_drive_t *, ide_task_t *);
-void ide_tf_read(ide_drive_t *, ide_task_t *);
+void ide_tf_load(ide_drive_t *, struct ide_cmd *);
+void ide_tf_read(ide_drive_t *, struct ide_cmd *);
 
-void ide_input_data(ide_drive_t *, struct request *, void *, unsigned int);
-void ide_output_data(ide_drive_t *, struct request *, void *, unsigned int);
+void ide_input_data(ide_drive_t *, struct ide_cmd *, void *, unsigned int);
+void ide_output_data(ide_drive_t *, struct ide_cmd *, void *, unsigned int);
 
 int ide_io_buffers(ide_drive_t *, struct ide_atapi_pc *, unsigned int, int);
 
@@ -1224,16 +1222,16 @@ int ide_cd_expiry(ide_drive_t *);
 
 int ide_cd_get_xferlen(struct request *);
 
-ide_startstop_t ide_issue_pc(ide_drive_t *);
+ide_startstop_t ide_issue_pc(ide_drive_t *, struct ide_cmd *);
 
-ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
+ide_startstop_t do_rw_taskfile(ide_drive_t *, struct ide_cmd *);
 
-void task_end_request(ide_drive_t *, struct request *, u8);
+void ide_finish_cmd(ide_drive_t *, struct ide_cmd *, u8);
 
-int ide_raw_taskfile(ide_drive_t *, ide_task_t *, u8 *, u16);
-int ide_no_data_taskfile(ide_drive_t *, ide_task_t *);
+int ide_raw_taskfile(ide_drive_t *, struct ide_cmd *, u8 *, u16);
+int ide_no_data_taskfile(ide_drive_t *, struct ide_cmd *);
 
-int ide_taskfile_ioctl(ide_drive_t *, unsigned int, unsigned long);
+int ide_taskfile_ioctl(ide_drive_t *, unsigned long);
 
 int ide_dev_read_id(ide_drive_t *, u8, u16 *);
 
@@ -1335,6 +1333,10 @@ enum {
 	IDE_HFLAG_ERROR_STOPS_FIFO	= (1 << 19),
 	/* serialize ports */
 	IDE_HFLAG_SERIALIZE		= (1 << 20),
+	/* host is DTC2278 */
+	IDE_HFLAG_DTC2278		= (1 << 21),
+	/* 4 devices on a single set of I/O ports */
+	IDE_HFLAG_4DRIVES		= (1 << 22),
 	/* host is TRM290 */
 	IDE_HFLAG_TRM290		= (1 << 23),
 	/* use 32-bit I/O ops */
@@ -1362,7 +1364,12 @@ enum {
 
 struct ide_port_info {
 	char			*name;
+
 	int			(*init_chipset)(struct pci_dev *);
+
+	void			(*get_lock)(irq_handler_t, void *);
+	void			(*release_lock)(void);
+
 	void			(*init_iops)(ide_hwif_t *);
 	void                    (*init_hwif)(ide_hwif_t *);
 	int			(*init_dma)(ide_hwif_t *,
@@ -1379,6 +1386,9 @@ struct ide_port_info {
 	u16			max_sectors;	/* if < than the default one */
 
 	u32			host_flags;
+
+	int			irq_flags;
+
 	u8			pio_mask;
 	u8			swdma_mask;
 	u8			mwdma_mask;
@@ -1398,8 +1408,8 @@ int ide_pci_resume(struct pci_dev *);
 #define ide_pci_resume NULL
 #endif
 
-void ide_map_sg(ide_drive_t *, struct request *);
-void ide_init_sg_cmd(ide_drive_t *, struct request *);
+void ide_map_sg(ide_drive_t *, struct ide_cmd *);
+void ide_init_sg_cmd(struct ide_cmd *, unsigned int);
 
 #define BAD_DMA_DRIVE		0
 #define GOOD_DMA_DRIVE		1
@@ -1433,18 +1443,18 @@ ide_startstop_t ide_dma_intr(ide_drive_t *);
 int ide_allocate_dma_engine(ide_hwif_t *);
 void ide_release_dma_engine(ide_hwif_t *);
 
-int ide_build_sglist(ide_drive_t *, struct request *);
+int ide_build_sglist(ide_drive_t *, struct ide_cmd *);
 void ide_destroy_dmatable(ide_drive_t *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 int config_drive_for_dma(ide_drive_t *);
-extern int ide_build_dmatable(ide_drive_t *, struct request *);
+int ide_build_dmatable(ide_drive_t *, struct ide_cmd *);
 void ide_dma_host_set(ide_drive_t *, int);
-extern int ide_dma_setup(ide_drive_t *);
-void ide_dma_exec_cmd(ide_drive_t *, u8);
+int ide_dma_setup(ide_drive_t *, struct ide_cmd *);
 extern void ide_dma_start(ide_drive_t *);
 int ide_dma_end(ide_drive_t *);
 int ide_dma_test_irq(ide_drive_t *);
+int ide_dma_sff_timer_expiry(ide_drive_t *);
 u8 ide_dma_sff_read_status(ide_hwif_t *);
 extern const struct ide_dma_ops sff_dma_ops;
 #else
@@ -1465,8 +1475,11 @@ static inline void ide_dma_on(ide_drive_t *drive) { ; }
 static inline void ide_dma_verbose(ide_drive_t *drive) { ; }
 static inline int ide_set_dma(ide_drive_t *drive) { return 1; }
 static inline void ide_check_dma_crc(ide_drive_t *drive) { ; }
+static inline ide_startstop_t ide_dma_intr(ide_drive_t *drive) { return ide_stopped; }
 static inline ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error) { return ide_stopped; }
 static inline void ide_release_dma_engine(ide_hwif_t *hwif) { ; }
+static inline int ide_build_sglist(ide_drive_t *drive,
+				   struct ide_cmd *cmd) { return 0; }
 #endif /* CONFIG_BLK_DEV_IDEDMA */
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
