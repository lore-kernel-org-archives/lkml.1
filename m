Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbYGPTNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbYGPTNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 15:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbYGPTNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 15:13:34 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:11061 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294AbYGPTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 15:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=CIUosfi7ugKd/5YMkMdYYNbi/tvDBeoYhvAsgdslwogroinVrjS+nRsknEDSPuvzP0
         FgSRBgdum3ymobtSDNC4TwLH6i52pNex1ewI+anPtRkBoI/5MogF/TvI8Qp/qNSC7DLq
         V6avIRhC9O0tosi3685GdZ1Kk/20NLoMJSvDI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates [part 2]
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 16 Jul 2008 21:07:04 +0200
Message-Id: <200807162107.06056.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Part 2:

* Fix for it821x OOPS in pass-through mode from Dimitri Gorokhovik.

* Fix for long-standing bugs in HDIO_DRIVE_RESET handling from Elias Oltmanns.

* ide-cd preparations for using generic ATAPI support from Borislav Petkov.

* DMA support for REQ_TYPE_ATA_PC requests in ide-cd from FUJITA Tomonori.

* ide/legacy/hd.c to drivers/block/ move from Adrian Bunk.

* Old bast-ide driver removal (we use PATA platform support now) from Ben Dooks.

* mpc8xx-ide driver removal (since arch/ppc is gone) from Arnd Bergmann.

* ide-timing.h to ide-timings.c helper library conversion.

* Conversion of more host drivers to use struct ide_port_info.

* Preparations for dynamic allocation of ide_hwif_t instances.

* and more...

Thanks to all contributors!


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/ioctl/hdio.txt                |    7 +-
 drivers/block/Kconfig                       |   12 +
 drivers/block/Makefile                      |    1 +
 drivers/{ide/legacy => block}/hd.c          |    3 +-
 drivers/ide/Kconfig                         |   88 +---
 drivers/ide/Makefile                        |   10 +-
 drivers/ide/arm/Makefile                    |    1 -
 drivers/ide/arm/bast-ide.c                  |   90 ---
 drivers/ide/arm/icside.c                    |  105 ++--
 drivers/ide/arm/palm_bk3710.c               |    3 -
 drivers/ide/arm/rapide.c                    |   33 +-
 drivers/ide/h8300/ide-h8300.c               |   19 +-
 drivers/ide/ide-cd.c                        |  160 +++---
 drivers/ide/ide-disk.c                      |    1 -
 drivers/ide/ide-floppy.c                    |   32 +-
 drivers/ide/ide-io.c                        |   72 +--
 drivers/ide/ide-iops.c                      |   24 +-
 drivers/ide/ide-lib.c                       |  151 -----
 drivers/ide/ide-pio-blacklist.c             |   94 +++
 drivers/ide/ide-pnp.c                       |    4 +-
 drivers/ide/ide-probe.c                     |   21 +-
 drivers/ide/ide-tape.c                      |    1 -
 drivers/ide/ide-taskfile.c                  |   33 +-
 drivers/ide/{ide-timing.h => ide-timings.c} |  204 +++----
 drivers/ide/ide.c                           |   76 +--
 drivers/ide/legacy/ali14xx.c                |    3 +-
 drivers/ide/legacy/buddha.c                 |    1 -
 drivers/ide/legacy/falconide.c              |    1 -
 drivers/ide/legacy/gayle.c                  |    1 -
 drivers/ide/legacy/ht6560b.c                |   15 +-
 drivers/ide/legacy/ide-4drives.c            |   25 +-
 drivers/ide/legacy/ide-cs.c                 |    9 +-
 drivers/ide/legacy/ide_platform.c           |    9 +-
 drivers/ide/legacy/macide.c                 |    1 -
 drivers/ide/legacy/q40ide.c                 |    1 -
 drivers/ide/legacy/qd65xx.c                 |   19 +-
 drivers/ide/mips/au1xxx-ide.c               |   13 +-
 drivers/ide/mips/swarm.c                    |   28 +-
 drivers/ide/pci/alim15x3.c                  |    6 +-
 drivers/ide/pci/amd74xx.c                   |    2 -
 drivers/ide/pci/cmd640.c                    |  131 ++---
 drivers/ide/pci/cmd64x.c                    |    6 +-
 drivers/ide/pci/cs5535.c                    |    6 +-
 drivers/ide/pci/cy82c693.c                  |    9 +-
 drivers/ide/pci/delkin_cb.c                 |    1 -
 drivers/ide/pci/it821x.c                    |    6 +
 drivers/ide/pci/scc_pata.c                  |    8 +-
 drivers/ide/pci/sgiioc4.c                   |   23 +-
 drivers/ide/pci/siimage.c                   |    3 +-
 drivers/ide/pci/sis5513.c                   |    3 -
 drivers/ide/pci/sl82c105.c                  |    3 +-
 drivers/ide/pci/via82cxxx.c                 |    2 -
 drivers/ide/ppc/Makefile                    |    1 -
 drivers/ide/ppc/mpc8xx.c                    |  851 ---------------------------
 drivers/ide/ppc/pmac.c                      |   21 +-
 drivers/ide/setup-pci.c                     |   25 +-
 drivers/scsi/ide-scsi.c                     |   14 -
 include/linux/ide.h                         |   74 ++-
 58 files changed, 695 insertions(+), 1871 deletions(-)
 rename drivers/{ide/legacy => block}/hd.c (99%)
 delete mode 100644 drivers/ide/arm/bast-ide.c
 create mode 100644 drivers/ide/ide-pio-blacklist.c
 rename drivers/ide/{ide-timing.h => ide-timings.c} (56%)
 delete mode 100644 drivers/ide/ppc/mpc8xx.c


Adrian Bunk (5):
      remove BLK_DEV_HD_ONLY
      ide/legacy/hd.c: use late_initcall()
      move ide/legacy/hd.c to drivers/block/
      update the BLK_DEV_HD help text
      hd.c: remove the #include <linux/mc146818rtc.h>

Arnd Bergmann (1):
      powerpc/ide: remove mpc8xx-ide driver

Bartlomiej Zolnierkiewicz (49):
      ide: remove needless includes from ide-lib.c
      ide: remove unused XFER_UDMA_SLOW
      ide: use u8 for xfer modes in ide-timing.h
      ide: move some bits from ide-timing.h to <linux/ide.h>
      ide: remove XFER_* masks from ide-timing.h
      ide: checkpatch.pl fixes for ide-timing.h
      ide: convert ide-timing.h to ide-timings.c library (take 2)
      ali14xx: convert to use ide_timing_find_mode()
      ht6560b: convert to use ide_timing_find_mode()
      qd65xx: convert to use ide_timing_find_mode()
      alim15x3: convert to use ide_timing_find_mode()
      cmd640: convert to use ide_timing_find_mode()
      cmd64x: convert to use ide_timing_find_mode()
      cy82c693: convert to use ide_timing_find_mode()
      sl82c105: convert to use ide_timing_find_mode()
      ide-mpc8xx: convert to use ide_timing_find_mode()
      ide-pmac: convert to use ide_timing_find_mode()
      ide: move ide_pio_cycle_time() to ide-timings.c
      ide: remove no longer used ide_pio_timings[]
      ide: move PIO blacklist to ide-pio-blacklist.c
      ide: fix hwif-s initialization
      ide: make ide_hwifs[] static
      ide: set hwif->dev in ide_init_port_hw() (take 2)
      au1xxx-ide: don't use hwif->hwif_data
      ide_4drives: use struct ide_port_info
      ide-cs: use struct ide_port_info
      icside: don't use hwif->hwif_data
      icside: use ide_init_port_hw()
      sgiioc4: use driver name for resource allocation
      ide: tighten checks on PCI BARs in ide_hwif_configure()
      swarm: use struct ide_port_info
      cmd640: fix warm-plug support for the secondary interface
      ide: ->port_init_devs -> ->init_dev
      cmd640: add ->init_dev method
      rapide: use struct ide_port_info
      ide-h8300: use struct ide_port_info
      ide_platform: use struct ide_port_info
      ide: print message on error in ide_find_port_slot()
      ide-h8300: print driver banner message early
      ide-pnp: print driver banner message early
      ide: allow any command requesting DMA data phase for HDIO_DRIVE_TASKFILE
      ide: remove superfluous BUG_ON() from set_geometry_intr()
      ide: remove needless includes from ide.c
      ide: remove needless includes from ide-taskfile.c (take 2)
      ide: remove needless includes from setup-pci.c (take 2)
      rapide: fix rapide_probe() return value
      icside: always try to probe first interface
      swarm: call ide_find_port_slot() later
      sgiioc4: call ide_find_port_slot() later

Ben Dooks (1):
      BAST: Remove old IDE driver

Borislav Petkov (12):
      ide-cd: remove wait-for-idle-controller bit in cdrom_start_packet_command
      ide-cd: remove ide_cd_drain_data and ide_cd_pad_transfer
      ide-cd: ide_do_rw_cdrom: add the catch-all bad request case to the if-else block
      ide-cd: cdrom_start_seek: remove unused argument block
      ide-cd: mv ide_do_rw_cdrom ide_cd_do_request
      ide-cd: simplify request issuing path
      ide-cd: fold cdrom_start_seek into ide_cd_do_request
      ide-cd: move request prep from cdrom_start_seek_continuation to rq issue path
      ide-cd: move request prep from cdrom_start_rw_cont to rq issue path
      ide-cd: move request prep chunk from cdrom_do_newpc_cont to rq issue path
      ide-floppy: fold idefloppy_create_test_unit_ready_cmd into idefloppy_open
      ide-floppy: zero out the whole struct ide_atapi_pc on init

Dimitri Gorokhovik (1):
      ide: it821x in pass-through mode segfaults in 2.6.26-stable

Elias Oltmanns (4):
      IDE: Fix HDIO_DRIVE_RESET handling
      IDE: Remove unused code
      Update documentation of HDIO_DRIVE_RESET ioctl
      IDE: Report errors during drive reset back to user space

FUJITA Tomonori (2):
      ide: avoid DMA on the stack for REQ_TYPE_ATA_PC
      ide: use the dma safe check for REQ_TYPE_ATA_PC

Harvey Harrison (1):
      ide: endian annotations in ide-floppy.c


diff --git a/Documentation/ioctl/hdio.txt b/Documentation/ioctl/hdio.txt
index c19efde..91a6ecb 100644
--- a/Documentation/ioctl/hdio.txt
+++ b/Documentation/ioctl/hdio.txt
@@ -508,12 +508,13 @@ HDIO_DRIVE_RESET		execute a device reset
 
 	error returns:
 	  EACCES	Access denied:  requires CAP_SYS_ADMIN
+	  ENXIO		No such device:	phy dead or ctl_addr == 0
+	  EIO		I/O error:	reset timed out or hardware error
 
 	notes:
 
-	  Abort any current command, prevent anything else from being
-	  queued, execute a reset on the device, and issue BLKRRPART
-	  ioctl on the block device.
+	  Execute a reset on the device as soon as the current IO
+	  operation has completed.
 
 	  Executes an ATAPI soft reset if applicable, otherwise
 	  executes an ATA soft reset on the controller.
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 0d1d213..61ad8d6 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -433,4 +433,16 @@ config VIRTIO_BLK
 	  This is the virtual block driver for virtio.  It can be used with
           lguest or QEMU based VMMs (like KVM or Xen).  Say Y or M.
 
+config BLK_DEV_HD
+	bool "Very old hard disk (MFM/RLL/IDE) driver"
+	depends on HAVE_IDE
+	depends on !ARM || ARCH_RPC || ARCH_SHARK || BROKEN
+	help
+	  This is a very old hard disk driver that lacks the enhanced
+	  functionality of the newer ones.
+
+	  It is required for systems with ancient MFM/RLL/ESDI drives.
+
+	  If unsure, say N.
+
 endif # BLK_DEV
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 5e58430..204332b 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -29,5 +29,6 @@ obj-$(CONFIG_VIRTIO_BLK)	+= virtio_blk.o
 obj-$(CONFIG_VIODASD)		+= viodasd.o
 obj-$(CONFIG_BLK_DEV_SX8)	+= sx8.o
 obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
+obj-$(CONFIG_BLK_DEV_HD)	+= hd.o
 
 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
new file mode 100644
index 0000000..682243b
--- /dev/null
+++ b/drivers/block/hd.c
@@ -0,0 +1,814 @@
+/*
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * This is the low-level hd interrupt support. It traverses the
+ * request-list, using interrupts to jump between functions. As
+ * all the functions are called within interrupts, we may not
+ * sleep. Special care is recommended.
+ *
+ *  modified by Drew Eckhardt to check nr of hd's from the CMOS.
+ *
+ *  Thanks to Branko Lankester, lankeste@fwi.uva.nl, who found a bug
+ *  in the early extended-partition checks and added DM partitions
+ *
+ *  IRQ-unmask, drive-id, multiple-mode, support for ">16 heads",
+ *  and general streamlining by Mark Lord.
+ *
+ *  Removed 99% of above. Use Mark's ide driver for those options.
+ *  This is now a lightweight ST-506 driver. (Paul Gortmaker)
+ *
+ *  Modified 1995 Russell King for ARM processor.
+ *
+ *  Bugfix: max_sectors must be <= 255 or the wheels tend to come
+ *  off in a hurry once you queue things up - Paul G. 02/2001
+ */
+
+/* Uncomment the following if you want verbose error reports. */
+/* #define VERBOSE_ERRORS */
+
+#include <linux/blkdev.h>
+#include <linux/errno.h>
+#include <linux/signal.h>
+#include <linux/interrupt.h>
+#include <linux/timer.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/genhd.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/ioport.h>
+#include <linux/init.h>
+#include <linux/blkpg.h>
+#include <linux/hdreg.h>
+
+#define REALLY_SLOW_IO
+#include <asm/system.h>
+#include <asm/io.h>
+#include <asm/uaccess.h>
+
+#ifdef __arm__
+#undef  HD_IRQ
+#endif
+#include <asm/irq.h>
+#ifdef __arm__
+#define HD_IRQ IRQ_HARDDISK
+#endif
+
+/* Hd controller regster ports */
+
+#define HD_DATA		0x1f0		/* _CTL when writing */
+#define HD_ERROR	0x1f1		/* see err-bits */
+#define HD_NSECTOR	0x1f2		/* nr of sectors to read/write */
+#define HD_SECTOR	0x1f3		/* starting sector */
+#define HD_LCYL		0x1f4		/* starting cylinder */
+#define HD_HCYL		0x1f5		/* high byte of starting cyl */
+#define HD_CURRENT	0x1f6		/* 101dhhhh , d=drive, hhhh=head */
+#define HD_STATUS	0x1f7		/* see status-bits */
+#define HD_FEATURE	HD_ERROR	/* same io address, read=error, write=feature */
+#define HD_PRECOMP	HD_FEATURE	/* obsolete use of this port - predates IDE */
+#define HD_COMMAND	HD_STATUS	/* same io address, read=status, write=cmd */
+
+#define HD_CMD		0x3f6		/* used for resets */
+#define HD_ALTSTATUS	0x3f6		/* same as HD_STATUS but doesn't clear irq */
+
+/* Bits of HD_STATUS */
+#define ERR_STAT		0x01
+#define INDEX_STAT		0x02
+#define ECC_STAT		0x04	/* Corrected error */
+#define DRQ_STAT		0x08
+#define SEEK_STAT		0x10
+#define SERVICE_STAT		SEEK_STAT
+#define WRERR_STAT		0x20
+#define READY_STAT		0x40
+#define BUSY_STAT		0x80
+
+/* Bits for HD_ERROR */
+#define MARK_ERR		0x01	/* Bad address mark */
+#define TRK0_ERR		0x02	/* couldn't find track 0 */
+#define ABRT_ERR		0x04	/* Command aborted */
+#define MCR_ERR			0x08	/* media change request */
+#define ID_ERR			0x10	/* ID field not found */
+#define MC_ERR			0x20	/* media changed */
+#define ECC_ERR			0x40	/* Uncorrectable ECC error */
+#define BBD_ERR			0x80	/* pre-EIDE meaning:  block marked bad */
+#define ICRC_ERR		0x80	/* new meaning:  CRC error during transfer */
+
+static DEFINE_SPINLOCK(hd_lock);
+static struct request_queue *hd_queue;
+
+#define MAJOR_NR HD_MAJOR
+#define QUEUE (hd_queue)
+#define CURRENT elv_next_request(hd_queue)
+
+#define TIMEOUT_VALUE	(6*HZ)
+#define	HD_DELAY	0
+
+#define MAX_ERRORS     16	/* Max read/write errors/sector */
+#define RESET_FREQ      8	/* Reset controller every 8th retry */
+#define RECAL_FREQ      4	/* Recalibrate every 4th retry */
+#define MAX_HD		2
+
+#define STAT_OK		(READY_STAT|SEEK_STAT)
+#define OK_STATUS(s)	(((s)&(STAT_OK|(BUSY_STAT|WRERR_STAT|ERR_STAT)))==STAT_OK)
+
+static void recal_intr(void);
+static void bad_rw_intr(void);
+
+static int reset;
+static int hd_error;
+
+/*
+ *  This struct defines the HD's and their types.
+ */
+struct hd_i_struct {
+	unsigned int head, sect, cyl, wpcom, lzone, ctl;
+	int unit;
+	int recalibrate;
+	int special_op;
+};
+
+#ifdef HD_TYPE
+static struct hd_i_struct hd_info[] = { HD_TYPE };
+static int NR_HD = ARRAY_SIZE(hd_info);
+#else
+static struct hd_i_struct hd_info[MAX_HD];
+static int NR_HD;
+#endif
+
+static struct gendisk *hd_gendisk[MAX_HD];
+
+static struct timer_list device_timer;
+
+#define TIMEOUT_VALUE (6*HZ)
+
+#define SET_TIMER							\
+	do {								\
+		mod_timer(&device_timer, jiffies + TIMEOUT_VALUE);	\
+	} while (0)
+
+static void (*do_hd)(void) = NULL;
+#define SET_HANDLER(x) \
+if ((do_hd = (x)) != NULL) \
+	SET_TIMER; \
+else \
+	del_timer(&device_timer);
+
+
+#if (HD_DELAY > 0)
+
+#include <asm/i8253.h>
+
+unsigned long last_req;
+
+unsigned long read_timer(void)
+{
+	unsigned long t, flags;
+	int i;
+
+	spin_lock_irqsave(&i8253_lock, flags);
+	t = jiffies * 11932;
+	outb_p(0, 0x43);
+	i = inb_p(0x40);
+	i |= inb(0x40) << 8;
+	spin_unlock_irqrestore(&i8253_lock, flags);
+	return(t - i);
+}
+#endif
+
+static void __init hd_setup(char *str, int *ints)
+{
+	int hdind = 0;
+
+	if (ints[0] != 3)
+		return;
+	if (hd_info[0].head != 0)
+		hdind = 1;
+	hd_info[hdind].head = ints[2];
+	hd_info[hdind].sect = ints[3];
+	hd_info[hdind].cyl = ints[1];
+	hd_info[hdind].wpcom = 0;
+	hd_info[hdind].lzone = ints[1];
+	hd_info[hdind].ctl = (ints[2] > 8 ? 8 : 0);
+	NR_HD = hdind+1;
+}
+
+static void dump_status(const char *msg, unsigned int stat)
+{
+	char *name = "hd?";
+	if (CURRENT)
+		name = CURRENT->rq_disk->disk_name;
+
+#ifdef VERBOSE_ERRORS
+	printk("%s: %s: status=0x%02x { ", name, msg, stat & 0xff);
+	if (stat & BUSY_STAT)	printk("Busy ");
+	if (stat & READY_STAT)	printk("DriveReady ");
+	if (stat & WRERR_STAT)	printk("WriteFault ");
+	if (stat & SEEK_STAT)	printk("SeekComplete ");
+	if (stat & DRQ_STAT)	printk("DataRequest ");
+	if (stat & ECC_STAT)	printk("CorrectedError ");
+	if (stat & INDEX_STAT)	printk("Index ");
+	if (stat & ERR_STAT)	printk("Error ");
+	printk("}\n");
+	if ((stat & ERR_STAT) == 0) {
+		hd_error = 0;
+	} else {
+		hd_error = inb(HD_ERROR);
+		printk("%s: %s: error=0x%02x { ", name, msg, hd_error & 0xff);
+		if (hd_error & BBD_ERR)		printk("BadSector ");
+		if (hd_error & ECC_ERR)		printk("UncorrectableError ");
+		if (hd_error & ID_ERR)		printk("SectorIdNotFound ");
+		if (hd_error & ABRT_ERR)	printk("DriveStatusError ");
+		if (hd_error & TRK0_ERR)	printk("TrackZeroNotFound ");
+		if (hd_error & MARK_ERR)	printk("AddrMarkNotFound ");
+		printk("}");
+		if (hd_error & (BBD_ERR|ECC_ERR|ID_ERR|MARK_ERR)) {
+			printk(", CHS=%d/%d/%d", (inb(HD_HCYL)<<8) + inb(HD_LCYL),
+				inb(HD_CURRENT) & 0xf, inb(HD_SECTOR));
+			if (CURRENT)
+				printk(", sector=%ld", CURRENT->sector);
+		}
+		printk("\n");
+	}
+#else
+	printk("%s: %s: status=0x%02x.\n", name, msg, stat & 0xff);
+	if ((stat & ERR_STAT) == 0) {
+		hd_error = 0;
+	} else {
+		hd_error = inb(HD_ERROR);
+		printk("%s: %s: error=0x%02x.\n", name, msg, hd_error & 0xff);
+	}
+#endif
+}
+
+static void check_status(void)
+{
+	int i = inb_p(HD_STATUS);
+
+	if (!OK_STATUS(i)) {
+		dump_status("check_status", i);
+		bad_rw_intr();
+	}
+}
+
+static int controller_busy(void)
+{
+	int retries = 100000;
+	unsigned char status;
+
+	do {
+		status = inb_p(HD_STATUS);
+	} while ((status & BUSY_STAT) && --retries);
+	return status;
+}
+
+static int status_ok(void)
+{
+	unsigned char status = inb_p(HD_STATUS);
+
+	if (status & BUSY_STAT)
+		return 1;	/* Ancient, but does it make sense??? */
+	if (status & WRERR_STAT)
+		return 0;
+	if (!(status & READY_STAT))
+		return 0;
+	if (!(status & SEEK_STAT))
+		return 0;
+	return 1;
+}
+
+static int controller_ready(unsigned int drive, unsigned int head)
+{
+	int retry = 100;
+
+	do {
+		if (controller_busy() & BUSY_STAT)
+			return 0;
+		outb_p(0xA0 | (drive<<4) | head, HD_CURRENT);
+		if (status_ok())
+			return 1;
+	} while (--retry);
+	return 0;
+}
+
+static void hd_out(struct hd_i_struct *disk,
+		   unsigned int nsect,
+		   unsigned int sect,
+		   unsigned int head,
+		   unsigned int cyl,
+		   unsigned int cmd,
+		   void (*intr_addr)(void))
+{
+	unsigned short port;
+
+#if (HD_DELAY > 0)
+	while (read_timer() - last_req < HD_DELAY)
+		/* nothing */;
+#endif
+	if (reset)
+		return;
+	if (!controller_ready(disk->unit, head)) {
+		reset = 1;
+		return;
+	}
+	SET_HANDLER(intr_addr);
+	outb_p(disk->ctl, HD_CMD);
+	port = HD_DATA;
+	outb_p(disk->wpcom >> 2, ++port);
+	outb_p(nsect, ++port);
+	outb_p(sect, ++port);
+	outb_p(cyl, ++port);
+	outb_p(cyl >> 8, ++port);
+	outb_p(0xA0 | (disk->unit << 4) | head, ++port);
+	outb_p(cmd, ++port);
+}
+
+static void hd_request (void);
+
+static int drive_busy(void)
+{
+	unsigned int i;
+	unsigned char c;
+
+	for (i = 0; i < 500000 ; i++) {
+		c = inb_p(HD_STATUS);
+		if ((c & (BUSY_STAT | READY_STAT | SEEK_STAT)) == STAT_OK)
+			return 0;
+	}
+	dump_status("reset timed out", c);
+	return 1;
+}
+
+static void reset_controller(void)
+{
+	int	i;
+
+	outb_p(4, HD_CMD);
+	for (i = 0; i < 1000; i++) barrier();
+	outb_p(hd_info[0].ctl & 0x0f, HD_CMD);
+	for (i = 0; i < 1000; i++) barrier();
+	if (drive_busy())
+		printk("hd: controller still busy\n");
+	else if ((hd_error = inb(HD_ERROR)) != 1)
+		printk("hd: controller reset failed: %02x\n", hd_error);
+}
+
+static void reset_hd(void)
+{
+	static int i;
+
+repeat:
+	if (reset) {
+		reset = 0;
+		i = -1;
+		reset_controller();
+	} else {
+		check_status();
+		if (reset)
+			goto repeat;
+	}
+	if (++i < NR_HD) {
+		struct hd_i_struct *disk = &hd_info[i];
+		disk->special_op = disk->recalibrate = 1;
+		hd_out(disk, disk->sect, disk->sect, disk->head-1,
+			disk->cyl, WIN_SPECIFY, &reset_hd);
+		if (reset)
+			goto repeat;
+	} else
+		hd_request();
+}
+
+/*
+ * Ok, don't know what to do with the unexpected interrupts: on some machines
+ * doing a reset and a retry seems to result in an eternal loop. Right now I
+ * ignore it, and just set the timeout.
+ *
+ * On laptops (and "green" PCs), an unexpected interrupt occurs whenever the
+ * drive enters "idle", "standby", or "sleep" mode, so if the status looks
+ * "good", we just ignore the interrupt completely.
+ */
+static void unexpected_hd_interrupt(void)
+{
+	unsigned int stat = inb_p(HD_STATUS);
+
+	if (stat & (BUSY_STAT|DRQ_STAT|ECC_STAT|ERR_STAT)) {
+		dump_status("unexpected interrupt", stat);
+		SET_TIMER;
+	}
+}
+
+/*
+ * bad_rw_intr() now tries to be a bit smarter and does things
+ * according to the error returned by the controller.
+ * -Mika Liljeberg (liljeber@cs.Helsinki.FI)
+ */
+static void bad_rw_intr(void)
+{
+	struct request *req = CURRENT;
+	if (req != NULL) {
+		struct hd_i_struct *disk = req->rq_disk->private_data;
+		if (++req->errors >= MAX_ERRORS || (hd_error & BBD_ERR)) {
+			end_request(req, 0);
+			disk->special_op = disk->recalibrate = 1;
+		} else if (req->errors % RESET_FREQ == 0)
+			reset = 1;
+		else if ((hd_error & TRK0_ERR) || req->errors % RECAL_FREQ == 0)
+			disk->special_op = disk->recalibrate = 1;
+		/* Otherwise just retry */
+	}
+}
+
+static inline int wait_DRQ(void)
+{
+	int retries;
+	int stat;
+
+	for (retries = 0; retries < 100000; retries++) {
+		stat = inb_p(HD_STATUS);
+		if (stat & DRQ_STAT)
+			return 0;
+	}
+	dump_status("wait_DRQ", stat);
+	return -1;
+}
+
+static void read_intr(void)
+{
+	struct request *req;
+	int i, retries = 100000;
+
+	do {
+		i = (unsigned) inb_p(HD_STATUS);
+		if (i & BUSY_STAT)
+			continue;
+		if (!OK_STATUS(i))
+			break;
+		if (i & DRQ_STAT)
+			goto ok_to_read;
+	} while (--retries > 0);
+	dump_status("read_intr", i);
+	bad_rw_intr();
+	hd_request();
+	return;
+ok_to_read:
+	req = CURRENT;
+	insw(HD_DATA, req->buffer, 256);
+	req->sector++;
+	req->buffer += 512;
+	req->errors = 0;
+	i = --req->nr_sectors;
+	--req->current_nr_sectors;
+#ifdef DEBUG
+	printk("%s: read: sector %ld, remaining = %ld, buffer=%p\n",
+		req->rq_disk->disk_name, req->sector, req->nr_sectors,
+		req->buffer+512);
+#endif
+	if (req->current_nr_sectors <= 0)
+		end_request(req, 1);
+	if (i > 0) {
+		SET_HANDLER(&read_intr);
+		return;
+	}
+	(void) inb_p(HD_STATUS);
+#if (HD_DELAY > 0)
+	last_req = read_timer();
+#endif
+	if (elv_next_request(QUEUE))
+		hd_request();
+	return;
+}
+
+static void write_intr(void)
+{
+	struct request *req = CURRENT;
+	int i;
+	int retries = 100000;
+
+	do {
+		i = (unsigned) inb_p(HD_STATUS);
+		if (i & BUSY_STAT)
+			continue;
+		if (!OK_STATUS(i))
+			break;
+		if ((req->nr_sectors <= 1) || (i & DRQ_STAT))
+			goto ok_to_write;
+	} while (--retries > 0);
+	dump_status("write_intr", i);
+	bad_rw_intr();
+	hd_request();
+	return;
+ok_to_write:
+	req->sector++;
+	i = --req->nr_sectors;
+	--req->current_nr_sectors;
+	req->buffer += 512;
+	if (!i || (req->bio && req->current_nr_sectors <= 0))
+		end_request(req, 1);
+	if (i > 0) {
+		SET_HANDLER(&write_intr);
+		outsw(HD_DATA, req->buffer, 256);
+		local_irq_enable();
+	} else {
+#if (HD_DELAY > 0)
+		last_req = read_timer();
+#endif
+		hd_request();
+	}
+	return;
+}
+
+static void recal_intr(void)
+{
+	check_status();
+#if (HD_DELAY > 0)
+	last_req = read_timer();
+#endif
+	hd_request();
+}
+
+/*
+ * This is another of the error-routines I don't know what to do with. The
+ * best idea seems to just set reset, and start all over again.
+ */
+static void hd_times_out(unsigned long dummy)
+{
+	char *name;
+
+	do_hd = NULL;
+
+	if (!CURRENT)
+		return;
+
+	disable_irq(HD_IRQ);
+	local_irq_enable();
+	reset = 1;
+	name = CURRENT->rq_disk->disk_name;
+	printk("%s: timeout\n", name);
+	if (++CURRENT->errors >= MAX_ERRORS) {
+#ifdef DEBUG
+		printk("%s: too many errors\n", name);
+#endif
+		end_request(CURRENT, 0);
+	}
+	local_irq_disable();
+	hd_request();
+	enable_irq(HD_IRQ);
+}
+
+static int do_special_op(struct hd_i_struct *disk, struct request *req)
+{
+	if (disk->recalibrate) {
+		disk->recalibrate = 0;
+		hd_out(disk, disk->sect, 0, 0, 0, WIN_RESTORE, &recal_intr);
+		return reset;
+	}
+	if (disk->head > 16) {
+		printk("%s: cannot handle device with more than 16 heads - giving up\n", req->rq_disk->disk_name);
+		end_request(req, 0);
+	}
+	disk->special_op = 0;
+	return 1;
+}
+
+/*
+ * The driver enables interrupts as much as possible.  In order to do this,
+ * (a) the device-interrupt is disabled before entering hd_request(),
+ * and (b) the timeout-interrupt is disabled before the sti().
+ *
+ * Interrupts are still masked (by default) whenever we are exchanging
+ * data/cmds with a drive, because some drives seem to have very poor
+ * tolerance for latency during I/O. The IDE driver has support to unmask
+ * interrupts for non-broken hardware, so use that driver if required.
+ */
+static void hd_request(void)
+{
+	unsigned int block, nsect, sec, track, head, cyl;
+	struct hd_i_struct *disk;
+	struct request *req;
+
+	if (do_hd)
+		return;
+repeat:
+	del_timer(&device_timer);
+	local_irq_enable();
+
+	req = CURRENT;
+	if (!req) {
+		do_hd = NULL;
+		return;
+	}
+
+	if (reset) {
+		local_irq_disable();
+		reset_hd();
+		return;
+	}
+	disk = req->rq_disk->private_data;
+	block = req->sector;
+	nsect = req->nr_sectors;
+	if (block >= get_capacity(req->rq_disk) ||
+	    ((block+nsect) > get_capacity(req->rq_disk))) {
+		printk("%s: bad access: block=%d, count=%d\n",
+			req->rq_disk->disk_name, block, nsect);
+		end_request(req, 0);
+		goto repeat;
+	}
+
+	if (disk->special_op) {
+		if (do_special_op(disk, req))
+			goto repeat;
+		return;
+	}
+	sec   = block % disk->sect + 1;
+	track = block / disk->sect;
+	head  = track % disk->head;
+	cyl   = track / disk->head;
+#ifdef DEBUG
+	printk("%s: %sing: CHS=%d/%d/%d, sectors=%d, buffer=%p\n",
+		req->rq_disk->disk_name,
+		req_data_dir(req) == READ ? "read" : "writ",
+		cyl, head, sec, nsect, req->buffer);
+#endif
+	if (blk_fs_request(req)) {
+		switch (rq_data_dir(req)) {
+		case READ:
+			hd_out(disk, nsect, sec, head, cyl, WIN_READ,
+				&read_intr);
+			if (reset)
+				goto repeat;
+			break;
+		case WRITE:
+			hd_out(disk, nsect, sec, head, cyl, WIN_WRITE,
+				&write_intr);
+			if (reset)
+				goto repeat;
+			if (wait_DRQ()) {
+				bad_rw_intr();
+				goto repeat;
+			}
+			outsw(HD_DATA, req->buffer, 256);
+			break;
+		default:
+			printk("unknown hd-command\n");
+			end_request(req, 0);
+			break;
+		}
+	}
+}
+
+static void do_hd_request(struct request_queue *q)
+{
+	disable_irq(HD_IRQ);
+	hd_request();
+	enable_irq(HD_IRQ);
+}
+
+static int hd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
+{
+	struct hd_i_struct *disk = bdev->bd_disk->private_data;
+
+	geo->heads = disk->head;
+	geo->sectors = disk->sect;
+	geo->cylinders = disk->cyl;
+	return 0;
+}
+
+/*
+ * Releasing a block device means we sync() it, so that it can safely
+ * be forgotten about...
+ */
+
+static irqreturn_t hd_interrupt(int irq, void *dev_id)
+{
+	void (*handler)(void) = do_hd;
+
+	do_hd = NULL;
+	del_timer(&device_timer);
+	if (!handler)
+		handler = unexpected_hd_interrupt;
+	handler();
+	local_irq_enable();
+	return IRQ_HANDLED;
+}
+
+static struct block_device_operations hd_fops = {
+	.getgeo =	hd_getgeo,
+};
+
+/*
+ * This is the hard disk IRQ description. The IRQF_DISABLED in sa_flags
+ * means we run the IRQ-handler with interrupts disabled:  this is bad for
+ * interrupt latency, but anything else has led to problems on some
+ * machines.
+ *
+ * We enable interrupts in some of the routines after making sure it's
+ * safe.
+ */
+
+static int __init hd_init(void)
+{
+	int drive;
+
+	if (register_blkdev(MAJOR_NR, "hd"))
+		return -1;
+
+	hd_queue = blk_init_queue(do_hd_request, &hd_lock);
+	if (!hd_queue) {
+		unregister_blkdev(MAJOR_NR, "hd");
+		return -ENOMEM;
+	}
+
+	blk_queue_max_sectors(hd_queue, 255);
+	init_timer(&device_timer);
+	device_timer.function = hd_times_out;
+	blk_queue_hardsect_size(hd_queue, 512);
+
+	if (!NR_HD) {
+		/*
+		 * We don't know anything about the drive.  This means
+		 * that you *MUST* specify the drive parameters to the
+		 * kernel yourself.
+		 *
+		 * If we were on an i386, we used to read this info from
+		 * the BIOS or CMOS.  This doesn't work all that well,
+		 * since this assumes that this is a primary or secondary
+		 * drive, and if we're using this legacy driver, it's
+		 * probably an auxilliary controller added to recover
+		 * legacy data off an ST-506 drive.  Either way, it's
+		 * definitely safest to have the user explicitly specify
+		 * the information.
+		 */
+		printk("hd: no drives specified - use hd=cyl,head,sectors"
+			" on kernel command line\n");
+		goto out;
+	}
+
+	for (drive = 0 ; drive < NR_HD ; drive++) {
+		struct gendisk *disk = alloc_disk(64);
+		struct hd_i_struct *p = &hd_info[drive];
+		if (!disk)
+			goto Enomem;
+		disk->major = MAJOR_NR;
+		disk->first_minor = drive << 6;
+		disk->fops = &hd_fops;
+		sprintf(disk->disk_name, "hd%c", 'a'+drive);
+		disk->private_data = p;
+		set_capacity(disk, p->head * p->sect * p->cyl);
+		disk->queue = hd_queue;
+		p->unit = drive;
+		hd_gendisk[drive] = disk;
+		printk("%s: %luMB, CHS=%d/%d/%d\n",
+			disk->disk_name, (unsigned long)get_capacity(disk)/2048,
+			p->cyl, p->head, p->sect);
+	}
+
+	if (request_irq(HD_IRQ, hd_interrupt, IRQF_DISABLED, "hd", NULL)) {
+		printk("hd: unable to get IRQ%d for the hard disk driver\n",
+			HD_IRQ);
+		goto out1;
+	}
+	if (!request_region(HD_DATA, 8, "hd")) {
+		printk(KERN_WARNING "hd: port 0x%x busy\n", HD_DATA);
+		goto out2;
+	}
+	if (!request_region(HD_CMD, 1, "hd(cmd)")) {
+		printk(KERN_WARNING "hd: port 0x%x busy\n", HD_CMD);
+		goto out3;
+	}
+
+	/* Let them fly */
+	for (drive = 0; drive < NR_HD; drive++)
+		add_disk(hd_gendisk[drive]);
+
+	return 0;
+
+out3:
+	release_region(HD_DATA, 8);
+out2:
+	free_irq(HD_IRQ, NULL);
+out1:
+	for (drive = 0; drive < NR_HD; drive++)
+		put_disk(hd_gendisk[drive]);
+	NR_HD = 0;
+out:
+	del_timer(&device_timer);
+	unregister_blkdev(MAJOR_NR, "hd");
+	blk_cleanup_queue(hd_queue);
+	return -1;
+Enomem:
+	while (drive--)
+		put_disk(hd_gendisk[drive]);
+	goto out;
+}
+
+static int __init parse_hd_setup(char *line)
+{
+	int ints[6];
+
+	(void) get_options(line, ARRAY_SIZE(ints), ints);
+	hd_setup(NULL, ints);
+
+	return 1;
+}
+__setup("hd=", parse_hd_setup);
+
+late_initcall(hd_init);
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index cf707c8..15b09b8 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -98,6 +98,9 @@ if BLK_DEV_IDE
 
 comment "Please see Documentation/ide/ide.txt for help/info on IDE drives"
 
+config IDE_TIMINGS
+	bool
+
 config IDE_ATAPI
 	bool
 
@@ -326,6 +329,7 @@ config BLK_DEV_PLATFORM
 config BLK_DEV_CMD640
 	tristate "CMD640 chipset bugfix/support"
 	depends on X86
+	select IDE_TIMINGS
 	---help---
 	  The CMD-Technologies CMD640 IDE chip is used on many common 486 and
 	  Pentium motherboards, usually in combination with a "Neptune" or
@@ -455,6 +459,7 @@ config BLK_DEV_AEC62XX
 
 config BLK_DEV_ALI15X3
 	tristate "ALI M15x3 chipset support"
+	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver ensures (U)DMA support for ALI 1533, 1543 and 1543C
@@ -469,6 +474,7 @@ config BLK_DEV_ALI15X3
 config BLK_DEV_AMD74XX
 	tristate "AMD and nVidia IDE support"
 	depends on !ARM
+	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds explicit support for AMD-7xx and AMD-8111 chips
@@ -489,6 +495,7 @@ config BLK_DEV_ATIIXP
 
 config BLK_DEV_CMD64X
 	tristate "CMD64{3|6|8|9} chipset support"
+	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  Say Y here if you have an IDE controller which uses any of these
@@ -503,6 +510,7 @@ config BLK_DEV_TRIFLEX
 
 config BLK_DEV_CY82C693
 	tristate "CY82C693 chipset support"
+	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds detection and support for the CY82C693 chipset
@@ -695,6 +703,7 @@ config BLK_DEV_SIS5513
 config BLK_DEV_SL82C105
 	tristate "Winbond SL82c105 support"
 	depends on (PPC || ARM)
+	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  If you have a Winbond SL82c105 IDE controller, say Y here to enable
@@ -725,6 +734,7 @@ config BLK_DEV_TRM290
 
 config BLK_DEV_VIA82CXXX
 	tristate "VIA82CXXX chipset support"
+	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds explicit support for VIA BusMastering IDE chips.
@@ -751,6 +761,7 @@ endif
 config BLK_DEV_IDE_PMAC
 	tristate "PowerMac on-board IDE support"
 	depends on PPC_PMAC && IDE=y && BLK_DEV_IDE=y
+	select IDE_TIMINGS
 	help
 	  This driver provides support for the on-board IDE controller on
 	  most of the recent Apple Power Macintoshes and PowerBooks.
@@ -829,13 +840,6 @@ config BLK_DEV_IDE_RAPIDE
 	  Say Y here if you want to support the Yellowstone RapIDE controller
 	  manufactured for use with Acorn computers.
 
-config BLK_DEV_IDE_BAST
-	tristate "Simtec BAST / Thorcom VR1000 IDE support"
-	depends on ARM && (ARCH_BAST || MACH_VR1000)
-	help
-	  Say Y here if you want to support the onboard IDE channels on the
-	  Simtec BAST or the Thorcom VR1000
-
 config IDE_H8300
 	tristate "H8300 IDE support"
 	depends on H8300
@@ -919,51 +923,12 @@ config BLK_DEV_Q40IDE
 config BLK_DEV_PALMCHIP_BK3710
 	tristate "Palmchip bk3710 IDE controller support"
 	depends on ARCH_DAVINCI
+	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_SFF
 	help
 	  Say Y here if you want to support the onchip IDE controller on the
 	  TI DaVinci SoC
 
-
-config BLK_DEV_MPC8xx_IDE
-	tristate "MPC8xx IDE support"
-	depends on 8xx && (LWMON || IVMS8 || IVML24 || TQM8xxL) && IDE=y && BLK_DEV_IDE=y && !PPC_MERGE
-	help
-	  This option provides support for IDE on Motorola MPC8xx Systems.
-	  Please see 'Type of MPC8xx IDE interface' for details.
-
-	  If unsure, say N.
-
-choice
-	prompt "Type of MPC8xx IDE interface"
-	depends on BLK_DEV_MPC8xx_IDE
-	default IDE_8xx_PCCARD
-
-config IDE_8xx_PCCARD
-	bool "8xx_PCCARD"
-	---help---
-	  Select how the IDE devices are connected to the MPC8xx system:
-
-	  8xx_PCCARD uses the 8xx internal PCMCIA interface in combination
-	  with a PC Card (e.g. ARGOSY portable Hard Disk Adapter),
-	  ATA PC Card HDDs or ATA PC Flash Cards (example: TQM8xxL
-	  systems)
-
-	  8xx_DIRECT is used for directly connected IDE devices using the 8xx
-	  internal PCMCIA interface (example: IVMS8 systems)
-
-	  EXT_DIRECT is used for IDE devices directly connected to the 8xx
-	  bus using some glue logic, but _not_ the 8xx internal
-	  PCMCIA interface (example: IDIF860 systems)
-
-config IDE_8xx_DIRECT
-	bool "8xx_DIRECT"
-
-config IDE_EXT_DIRECT
-	bool "EXT_DIRECT"
-
-endchoice
-
 # no isa -> no vlb
 if ISA && (ALPHA || X86 || MIPS)
 
@@ -981,6 +946,7 @@ config BLK_DEV_4DRIVES
 
 config BLK_DEV_ALI14XX
 	tristate "ALI M14xx support"
+	select IDE_TIMINGS
 	help
 	  This driver is enabled at runtime using the "ali14xx.probe" kernel
 	  boot parameter.  It enables support for the secondary IDE interface
@@ -1000,6 +966,7 @@ config BLK_DEV_DTC2278
 
 config BLK_DEV_HT6560B
 	tristate "Holtek HT6560B support"
+	select IDE_TIMINGS
 	help
 	  This driver is enabled at runtime using the "ht6560b.probe" kernel
 	  boot parameter. It enables support for the secondary IDE interface
@@ -1009,6 +976,7 @@ config BLK_DEV_HT6560B
 
 config BLK_DEV_QD65XX
 	tristate "QDI QD65xx support"
+	select IDE_TIMINGS
 	help
 	  This driver is enabled at runtime using the "qd65xx.probe" kernel
 	  boot parameter.  It permits faster I/O speeds to be set.  See the
@@ -1032,30 +1000,4 @@ config BLK_DEV_IDEDMA
 
 endif
 
-config BLK_DEV_HD_ONLY
-	bool "Old hard disk (MFM/RLL/IDE) driver"
-	depends on !ARM || ARCH_RPC || ARCH_SHARK || BROKEN
-	help
-	  There are two drivers for MFM/RLL/IDE hard disks. Most people use
-	  the newer enhanced driver, but this old one is still around for two
-	  reasons. Some older systems have strange timing problems and seem to
-	  work only with the old driver (which itself does not work with some
-	  newer systems). The other reason is that the old driver is smaller,
-	  since it lacks the enhanced functionality of the new one. This makes
-	  it a good choice for systems with very tight memory restrictions, or
-	  for systems with only older MFM/RLL/ESDI drives. Choosing the old
-	  driver can save 13 KB or so of kernel memory.
-
-	  If you want to use this driver together with the new one you have
-	  to use "hda=noprobe hdb=noprobe" kernel parameters to prevent the new
-	  driver from probing the primary interface.
-
-	  If you are unsure, then just choose the Enhanced IDE/MFM/RLL driver
-	  instead of this one. For more detailed information, read the
-	  Disk-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-config BLK_DEV_HD
-	def_bool BLK_DEV_HD_ONLY
-
 endif # IDE
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index a2b3f84..5d414e3 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -11,9 +11,11 @@
 
 EXTRA_CFLAGS				+= -Idrivers/ide
 
-ide-core-y += ide.o ide-io.o ide-iops.o ide-lib.o ide-probe.o ide-taskfile.o
+ide-core-y += ide.o ide-io.o ide-iops.o ide-lib.o ide-probe.o ide-taskfile.o \
+	      ide-pio-blacklist.o
 
 # core IDE code
+ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-timings.o
 ide-core-$(CONFIG_IDE_ATAPI)		+= ide-atapi.o
 ide-core-$(CONFIG_BLK_DEV_IDEPCI)	+= setup-pci.o
 ide-core-$(CONFIG_BLK_DEV_IDEDMA)	+= ide-dma.o
@@ -59,9 +61,3 @@ ifeq ($(CONFIG_BLK_DEV_PLATFORM), y)
 endif
 
 obj-$(CONFIG_BLK_DEV_IDE)		+= arm/ mips/
-
-# old hd driver must be last
-ifeq ($(CONFIG_BLK_DEV_HD), y)
-	hd-core-y += legacy/hd.o
-	obj-y += hd-core.o
-endif
diff --git a/drivers/ide/arm/Makefile b/drivers/ide/arm/Makefile
index 936e7b0..5bc2605 100644
--- a/drivers/ide/arm/Makefile
+++ b/drivers/ide/arm/Makefile
@@ -1,7 +1,6 @@
 
 obj-$(CONFIG_BLK_DEV_IDE_ICSIDE)	+= icside.o
 obj-$(CONFIG_BLK_DEV_IDE_RAPIDE)	+= rapide.o
-obj-$(CONFIG_BLK_DEV_IDE_BAST)		+= bast-ide.o
 obj-$(CONFIG_BLK_DEV_PALMCHIP_BK3710)	+= palm_bk3710.o
 
 ifeq ($(CONFIG_IDE_ARM), m)
diff --git a/drivers/ide/arm/bast-ide.c b/drivers/ide/arm/bast-ide.c
deleted file mode 100644
index 8e8c281..0000000
--- a/drivers/ide/arm/bast-ide.c
+++ /dev/null
@@ -1,90 +0,0 @@
-/*
- * Copyright (c) 2003-2004 Simtec Electronics
- *  Ben Dooks <ben@simtec.co.uk>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
-*/
-
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/ide.h>
-#include <linux/init.h>
-
-#include <asm/mach-types.h>
-
-#include <asm/io.h>
-#include <asm/irq.h>
-#include <asm/arch/map.h>
-#include <asm/arch/bast-map.h>
-#include <asm/arch/bast-irq.h>
-
-#define DRV_NAME "bast-ide"
-
-static int __init bastide_register(unsigned int base, unsigned int aux, int irq)
-{
-	ide_hwif_t *hwif;
-	hw_regs_t hw;
-	int i;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-
-	memset(&hw, 0, sizeof(hw));
-
-	base += BAST_IDE_CS;
-	aux  += BAST_IDE_CS;
-
-	for (i = 0; i <= 7; i++) {
-		hw.io_ports_array[i] = (unsigned long)base;
-		base += 0x20;
-	}
-
-	hw.io_ports.ctl_addr = aux + (6 * 0x20);
-	hw.irq = irq;
-	hw.chipset = ide_generic;
-
-	hwif = ide_find_port();
-	if (hwif == NULL)
-		goto out;
-
-	i = hwif->index;
-
-	ide_init_port_data(hwif, i);
-	ide_init_port_hw(hwif, &hw);
-	hwif->port_ops = NULL;
-
-	idx[0] = i;
-
-	ide_device_add(idx, NULL);
-out:
-	return 0;
-}
-
-static int __init bastide_init(void)
-{
-	unsigned long base = BAST_VA_IDEPRI + BAST_IDE_CS;
-
-	/* we can treat the VR1000 and the BAST the same */
-
-	if (!(machine_is_bast() || machine_is_vr1000()))
-		return 0;
-
-	printk("BAST: IDE driver, (c) 2003-2004 Simtec Electronics\n");
-
-	if (!request_mem_region(base, 0x400000, DRV_NAME)) {
-		printk(KERN_ERR "%s: resources busy\n", DRV_NAME);
-		return -EBUSY;
-	}
-
-	bastide_register(BAST_VA_IDEPRI, BAST_VA_IDEPRIAUX, IRQ_IDE0);
-	bastide_register(BAST_VA_IDESEC, BAST_VA_IDESECAUX, IRQ_IDE1);
-
-	return 0;
-}
-
-module_init(bastide_init);
-
-MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Simtec BAST / Thorcom VR1000 IDE driver");
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 0614569..52f58c8 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -21,6 +21,8 @@
 #include <asm/dma.h>
 #include <asm/ecard.h>
 
+#define DRV_NAME "icside"
+
 #define ICS_IDENT_OFFSET		0x2280
 
 #define ICS_ARCIN_V5_INTRSTAT		0x0000
@@ -68,6 +70,7 @@ struct icside_state {
 	unsigned int enabled;
 	void __iomem *irq_port;
 	void __iomem *ioc_base;
+	unsigned int sel;
 	unsigned int type;
 	ide_hwif_t *hwif[2];
 };
@@ -165,7 +168,8 @@ static const expansioncard_ops_t icside_ops_arcin_v6 = {
 static void icside_maskproc(ide_drive_t *drive, int mask)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	struct icside_state *state = hwif->hwif_data;
+	struct expansion_card *ec = ECARD_DEV(hwif->dev);
+	struct icside_state *state = ecard_get_drvdata(ec);
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -308,6 +312,7 @@ static int icside_dma_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
+	struct icside_state *state = ecard_get_drvdata(ec);
 	struct request *rq = hwif->hwgroup->rq;
 	unsigned int dma_mode;
 
@@ -331,7 +336,7 @@ static int icside_dma_setup(ide_drive_t *drive)
 	/*
 	 * Route the DMA signals to the correct interface.
 	 */
-	writeb(hwif->select_data, hwif->config_data);
+	writeb(state->sel | hwif->channel, state->ioc_base);
 
 	/*
 	 * Select the correct timing for this drive.
@@ -359,7 +364,8 @@ static void icside_dma_exec_cmd(ide_drive_t *drive, u8 cmd)
 static int icside_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	struct icside_state *state = hwif->hwif_data;
+	struct expansion_card *ec = ECARD_DEV(hwif->dev);
+	struct icside_state *state = ecard_get_drvdata(ec);
 
 	return readb(state->irq_port +
 		     (hwif->channel ?
@@ -411,36 +417,24 @@ static int icside_dma_off_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 	return -EOPNOTSUPP;
 }
 
-static ide_hwif_t *
-icside_setup(void __iomem *base, struct cardinfo *info, struct expansion_card *ec)
+static void icside_setup_ports(hw_regs_t *hw, void __iomem *base,
+			       struct cardinfo *info, struct expansion_card *ec)
 {
 	unsigned long port = (unsigned long)base + info->dataoffset;
-	ide_hwif_t *hwif;
 
-	hwif = ide_find_port();
-	if (hwif) {
-		/*
-		 * Ensure we're using MMIO
-		 */
-		default_hwif_mmiops(hwif);
-
-		hwif->io_ports.data_addr = port;
-		hwif->io_ports.error_addr = port + (1 << info->stepping);
-		hwif->io_ports.nsect_addr = port + (2 << info->stepping);
-		hwif->io_ports.lbal_addr = port + (3 << info->stepping);
-		hwif->io_ports.lbam_addr = port + (4 << info->stepping);
-		hwif->io_ports.lbah_addr = port + (5 << info->stepping);
-		hwif->io_ports.device_addr = port + (6 << info->stepping);
-		hwif->io_ports.status_addr = port + (7 << info->stepping);
-		hwif->io_ports.ctl_addr =
-			(unsigned long)base + info->ctrloffset;
-		hwif->irq     = ec->irq;
-		hwif->chipset = ide_acorn;
-		hwif->gendev.parent = &ec->dev;
-		hwif->dev = &ec->dev;
-	}
-
-	return hwif;
+	hw->io_ports.data_addr	 = port;
+	hw->io_ports.error_addr	 = port + (1 << info->stepping);
+	hw->io_ports.nsect_addr	 = port + (2 << info->stepping);
+	hw->io_ports.lbal_addr	 = port + (3 << info->stepping);
+	hw->io_ports.lbam_addr	 = port + (4 << info->stepping);
+	hw->io_ports.lbah_addr	 = port + (5 << info->stepping);
+	hw->io_ports.device_addr = port + (6 << info->stepping);
+	hw->io_ports.status_addr = port + (7 << info->stepping);
+	hw->io_ports.ctl_addr	 = (unsigned long)base + info->ctrloffset;
+
+	hw->irq = ec->irq;
+	hw->dev = &ec->dev;
+	hw->chipset = ide_acorn;
 }
 
 static int __init
@@ -449,6 +443,7 @@ icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 	ide_hwif_t *hwif;
 	void __iomem *base;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw;
 
 	base = ecardm_iomap(ec, ECARD_RES_MEMC, 0, 0);
 	if (!base)
@@ -466,12 +461,19 @@ icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 	 */
 	icside_irqdisable_arcin_v5(ec, 0);
 
-	hwif = icside_setup(base, &icside_cardinfo_v5, ec);
+	icside_setup_ports(&hw, base, &icside_cardinfo_v5, ec);
+
+	hwif = ide_find_port();
 	if (!hwif)
 		return -ENODEV;
 
+	ide_init_port_hw(hwif, &hw);
+	default_hwif_mmiops(hwif);
+
 	state->hwif[0] = hwif;
 
+	ecard_set_drvdata(ec, state);
+
 	idx[0] = hwif->index;
 
 	ide_device_add(idx, NULL);
@@ -497,6 +499,7 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 	int ret;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	struct ide_port_info d = icside_v6_port_info;
+	hw_regs_t hw[2];
 
 	ioc_base = ecardm_iomap(ec, ECARD_RES_IOCFAST, 0, 0);
 	if (!ioc_base) {
@@ -525,43 +528,47 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 
 	state->irq_port   = easi_base;
 	state->ioc_base   = ioc_base;
+	state->sel	  = sel;
 
 	/*
 	 * Be on the safe side - disable interrupts
 	 */
 	icside_irqdisable_arcin_v6(ec, 0);
 
+	icside_setup_ports(&hw[0], easi_base, &icside_cardinfo_v6_1, ec);
+	icside_setup_ports(&hw[1], easi_base, &icside_cardinfo_v6_2, ec);
+
 	/*
 	 * Find and register the interfaces.
 	 */
-	hwif = icside_setup(easi_base, &icside_cardinfo_v6_1, ec);
-	mate = icside_setup(easi_base, &icside_cardinfo_v6_2, ec);
+	hwif = ide_find_port();
+	if (hwif == NULL)
+		return -ENODEV;
 
-	if (!hwif || !mate) {
-		ret = -ENODEV;
-		goto out;
+	ide_init_port_hw(hwif, &hw[0]);
+	default_hwif_mmiops(hwif);
+
+	idx[0] = hwif->index;
+
+	mate = ide_find_port();
+	if (mate) {
+		ide_init_port_hw(mate, &hw[1]);
+		default_hwif_mmiops(mate);
+
+		idx[1] = mate->index;
 	}
 
 	state->hwif[0]    = hwif;
 	state->hwif[1]    = mate;
 
-	hwif->hwif_data   = state;
-	hwif->config_data = (unsigned long)ioc_base;
-	hwif->select_data = sel;
-
-	mate->hwif_data   = state;
-	mate->config_data = (unsigned long)ioc_base;
-	mate->select_data = sel | 1;
+	ecard_set_drvdata(ec, state);
 
-	if (ec->dma != NO_DMA && !request_dma(ec->dma, hwif->name)) {
+	if (ec->dma != NO_DMA && !request_dma(ec->dma, DRV_NAME)) {
 		d.init_dma = icside_dma_init;
 		d.port_ops = &icside_v6_port_ops;
 		d.dma_ops = NULL;
 	}
 
-	idx[0] = hwif->index;
-	idx[1] = mate->index;
-
 	ide_device_add(idx, &d);
 
 	return 0;
@@ -627,10 +634,8 @@ icside_probe(struct expansion_card *ec, const struct ecard_id *id)
 		break;
 	}
 
-	if (ret == 0) {
-		ecard_set_drvdata(ec, state);
+	if (ret == 0)
 		goto out;
-	}
 
 	kfree(state);
  release:
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index 3839f57..c79b85b 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -74,8 +74,6 @@ struct palm_bk3710_udmatiming {
 #define BK3710_IORDYTMP		0x78
 #define BK3710_IORDYTMS		0x7C
 
-#include "../ide-timing.h"
-
 static unsigned ideclk_period; /* in nanoseconds */
 
 static const struct palm_bk3710_udmatiming palm_bk3710_udmatimings[6] = {
@@ -402,7 +400,6 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 
 	i = hwif->index;
 
-	ide_init_port_data(hwif, i);
 	ide_init_port_hw(hwif, &hw);
 
 	default_hwif_mmiops(hwif);
diff --git a/drivers/ide/arm/rapide.c b/drivers/ide/arm/rapide.c
index 1747b23..43057e0 100644
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -11,6 +11,10 @@
 
 #include <asm/ecard.h>
 
+static struct const ide_port_info rapide_port_info = {
+	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
+};
+
 static void rapide_setup_ports(hw_regs_t *hw, void __iomem *base,
 			       void __iomem *ctrl, unsigned int sz, int irq)
 {
@@ -44,25 +48,26 @@ rapide_probe(struct expansion_card *ec, const struct ecard_id *id)
 		goto release;
 	}
 
-	hwif = ide_find_port();
-	if (hwif) {
-		memset(&hw, 0, sizeof(hw));
-		rapide_setup_ports(&hw, base, base + 0x818, 1 << 6, ec->irq);
-		hw.chipset = ide_generic;
-		hw.dev = &ec->dev;
+	memset(&hw, 0, sizeof(hw));
+	rapide_setup_ports(&hw, base, base + 0x818, 1 << 6, ec->irq);
+	hw.chipset = ide_generic;
+	hw.dev = &ec->dev;
 
-		ide_init_port_hw(hwif, &hw);
+	hwif = ide_find_port();
+	if (hwif == NULL) {
+		ret = -ENOENT;
+		goto release;
+	}
 
-		hwif->host_flags = IDE_HFLAG_MMIO;
-		default_hwif_mmiops(hwif);
+	ide_init_port_hw(hwif, &hw);
+	default_hwif_mmiops(hwif);
 
-		idx[0] = hwif->index;
+	idx[0] = hwif->index;
 
-		ide_device_add(idx, NULL);
+	ide_device_add(idx, &rapide_port_info);
 
-		ecard_set_drvdata(ec, hwif);
-		goto out;
-	}
+	ecard_set_drvdata(ec, hwif);
+	goto out;
 
  release:
 	ecard_release_resources(ec);
diff --git a/drivers/ide/h8300/ide-h8300.c b/drivers/ide/h8300/ide-h8300.c
index ae37ee5..20fad6d 100644
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -8,6 +8,8 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
+#define DRV_NAME "ide-h8300"
+
 #define bswap(d) \
 ({					\
 	u16 r;				\
@@ -176,6 +178,10 @@ static inline void hwif_setup(ide_hwif_t *hwif)
 	hwif->output_data = h8300_output_data;
 }
 
+static const struct ide_port_info h8300_port_info = {
+	.host_flags		= IDE_HFLAG_NO_IO_32BIT | IDE_HFLAG_NO_DMA,
+};
+
 static int __init h8300_ide_init(void)
 {
 	hw_regs_t hw;
@@ -183,6 +189,8 @@ static int __init h8300_ide_init(void)
 	int index;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
+	printk(KERN_INFO DRV_NAME ": H8/300 generic IDE interface\n");
+
 	if (!request_region(CONFIG_H8300_IDE_BASE, H8300_IDE_GAP*8, "ide-h8300"))
 		goto out_busy;
 	if (!request_region(CONFIG_H8300_IDE_ALT, H8300_IDE_GAP, "ide-h8300")) {
@@ -192,22 +200,17 @@ static int __init h8300_ide_init(void)
 
 	hw_setup(&hw);
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		printk(KERN_ERR "ide-h8300: IDE I/F register failed\n");
+	hwif = ide_find_port_slot(&h8300_port_info);
+	if (hwif == NULL)
 		return -ENOENT;
-	}
 
 	index = hwif->index;
-	ide_init_port_data(hwif, index);
 	ide_init_port_hw(hwif, &hw);
 	hwif_setup(hwif);
-	hwif->host_flags = IDE_HFLAG_NO_IO_32BIT;
-	printk(KERN_INFO "ide%d: H8/300 generic IDE interface\n", index);
 
 	idx[0] = index;
 
-	ide_device_add(idx, NULL);
+	ide_device_add(idx, &h8300_port_info);
 
 	return 0;
 
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index d998471..6e29dd5 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -517,14 +517,9 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 						  int xferlen,
 						  ide_handler_t *handler)
 {
-	ide_startstop_t startstop;
 	struct cdrom_info *info = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 
-	/* wait for the controller to be idle */
-	if (ide_wait_stat(&startstop, drive, 0, BUSY_STAT, WAIT_READY))
-		return startstop;
-
 	/* FIXME: for Virtual DMA we must check harder */
 	if (info->dma)
 		info->dma = !hwif->dma_ops->dma_setup(drive);
@@ -604,28 +599,6 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 }
 
 /*
- * Block read functions.
- */
-static void ide_cd_pad_transfer(ide_drive_t *drive, xfer_func_t *xf, int len)
-{
-	while (len > 0) {
-		int dum = 0;
-		xf(drive, NULL, &dum, sizeof(dum));
-		len -= sizeof(dum);
-	}
-}
-
-static void ide_cd_drain_data(ide_drive_t *drive, int nsects)
-{
-	while (nsects > 0) {
-		static char dum[SECTOR_SIZE];
-
-		drive->hwif->input_data(drive, NULL, dum, sizeof(dum));
-		nsects--;
-	}
-}
-
-/*
  * Check the contents of the interrupt reason register from the cdrom
  * and attempt to recover if there are problems.  Returns  0 if everything's
  * ok; nonzero if the request has been terminated.
@@ -640,15 +613,12 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 	if (ireason == (!rw << 1))
 		return 0;
 	else if (ireason == (rw << 1)) {
-		ide_hwif_t *hwif = drive->hwif;
-		xfer_func_t *xf;
 
 		/* whoops... */
 		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
 				drive->name, __func__);
 
-		xf = rw ? hwif->output_data : hwif->input_data;
-		ide_cd_pad_transfer(drive, xf, len);
+		ide_pad_transfer(drive, rw, len);
 	} else  if (rw == 0 && ireason == 1) {
 		/*
 		 * Some drives (ASUS) seem to tell us that status info is
@@ -696,16 +666,9 @@ static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *);
 
-/*
- * Routine to send a read/write packet command to the drive. This is usually
- * called directly from cdrom_start_{read,write}(). However, for drq_interrupt
- * devices, it is called from an interrupt when the drive is ready to accept
- * the command.
- */
-static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
+static ide_startstop_t ide_cd_prepare_rw_request(ide_drive_t *drive,
+						 struct request *rq)
 {
-	struct request *rq = HWGROUP(drive)->rq;
-
 	if (rq_data_dir(rq) == READ) {
 		unsigned short sectors_per_frame =
 			queue_hardsect_size(drive->queue) >> SECTOR_BITS;
@@ -742,6 +705,19 @@ static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 	/* set up the command */
 	rq->timeout = ATAPI_WAIT_PC;
 
+	return ide_started;
+}
+
+/*
+ * Routine to send a read/write packet command to the drive. This is usually
+ * called directly from cdrom_start_{read,write}(). However, for drq_interrupt
+ * devices, it is called from an interrupt when the drive is ready to accept
+ * the command.
+ */
+static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
+{
+	struct request *rq = drive->hwif->hwgroup->rq;
+
 	/* send the command to the drive and return */
 	return cdrom_transfer_packet_command(drive, rq, cdrom_newpc_intr);
 }
@@ -768,9 +744,8 @@ static ide_startstop_t cdrom_seek_intr(ide_drive_t *drive)
 	return ide_stopped;
 }
 
-static ide_startstop_t cdrom_start_seek_continuation(ide_drive_t *drive)
+static void ide_cd_prepare_seek_request(ide_drive_t *drive, struct request *rq)
 {
-	struct request *rq = HWGROUP(drive)->rq;
 	sector_t frame = rq->sector;
 
 	sector_div(frame, queue_hardsect_size(drive->queue) >> SECTOR_BITS);
@@ -780,17 +755,13 @@ static ide_startstop_t cdrom_start_seek_continuation(ide_drive_t *drive)
 	put_unaligned(cpu_to_be32(frame), (unsigned int *) &rq->cmd[2]);
 
 	rq->timeout = ATAPI_WAIT_PC;
-	return cdrom_transfer_packet_command(drive, rq, &cdrom_seek_intr);
 }
 
-static ide_startstop_t cdrom_start_seek(ide_drive_t *drive, unsigned int block)
+static ide_startstop_t cdrom_start_seek_continuation(ide_drive_t *drive)
 {
-	struct cdrom_info *info = drive->driver_data;
+	struct request *rq = drive->hwif->hwgroup->rq;
 
-	info->dma = 0;
-	info->start_seek = jiffies;
-	return cdrom_start_packet_command(drive, 0,
-					  cdrom_start_seek_continuation);
+	return cdrom_transfer_packet_command(drive, rq, &cdrom_seek_intr);
 }
 
 /*
@@ -1011,7 +982,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 					   - bio_cur_sectors(rq->bio),
 					   thislen >> 9);
 			if (nskip > 0) {
-				ide_cd_drain_data(drive, nskip);
+				ide_pad_transfer(drive, write, nskip << 9);
 				rq->current_nr_sectors -= nskip;
 				thislen -= (nskip << 9);
 			}
@@ -1048,7 +1019,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 				 * If the buffers are full, pipe the rest into
 				 * oblivion.
 				 */
-				ide_cd_drain_data(drive, thislen >> 9);
+				ide_pad_transfer(drive, 0, thislen);
 			else {
 				printk(KERN_ERR "%s: confused, missing data\n",
 						drive->name);
@@ -1096,7 +1067,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 
 	/* pad, if necessary */
 	if (!blk_fs_request(rq) && len > 0)
-		ide_cd_pad_transfer(drive, xferfunc, len);
+		ide_pad_transfer(drive, write, len);
 
 	if (blk_pc_request(rq)) {
 		timeout = rq->timeout;
@@ -1165,21 +1136,17 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 	if (write)
 		cd->devinfo.media_written = 1;
 
-	/* start sending the read/write request to the drive */
-	return cdrom_start_packet_command(drive, 32768, cdrom_start_rw_cont);
+	return ide_started;
 }
 
 static ide_startstop_t cdrom_do_newpc_cont(ide_drive_t *drive)
 {
 	struct request *rq = HWGROUP(drive)->rq;
 
-	if (!rq->timeout)
-		rq->timeout = ATAPI_WAIT_PC;
-
 	return cdrom_transfer_packet_command(drive, rq, cdrom_newpc_intr);
 }
 
-static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
+static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 {
 	struct cdrom_info *info = drive->driver_data;
 
@@ -1191,10 +1158,16 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 	info->dma = 0;
 
 	/* sg request */
-	if (rq->bio) {
-		int mask = drive->queue->dma_alignment;
-		unsigned long addr =
-			(unsigned long)page_address(bio_page(rq->bio));
+	if (rq->bio || ((rq->cmd_type == REQ_TYPE_ATA_PC) && rq->data_len)) {
+		struct request_queue *q = drive->queue;
+		unsigned int alignment;
+		unsigned long addr;
+		unsigned long stack_mask = ~(THREAD_SIZE - 1);
+
+		if (rq->bio)
+			addr = (unsigned long)bio_data(rq->bio);
+		else
+			addr = (unsigned long)rq->data;
 
 		info->dma = drive->using_dma;
 
@@ -1204,23 +1177,25 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		 * NOTE! The "len" and "addr" checks should possibly have
 		 * separate masks.
 		 */
-		if ((rq->data_len & 15) || (addr & mask))
+		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
+		if (addr & alignment || rq->data_len & alignment)
 			info->dma = 0;
-	}
 
-	/* start sending the command to the drive */
-	return cdrom_start_packet_command(drive, rq->data_len,
-					  cdrom_do_newpc_cont);
+		if (!((addr & stack_mask) ^
+		      ((unsigned long)current->stack & stack_mask)))
+			info->dma = 0;
+	}
 }
 
 /*
  * cdrom driver request routine.
  */
-static ide_startstop_t ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq,
+static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 					sector_t block)
 {
-	ide_startstop_t action;
 	struct cdrom_info *info = drive->driver_data;
+	ide_handler_t *fn;
+	int xferlen;
 
 	if (blk_fs_request(rq)) {
 		if (info->cd_flags & IDE_CD_FLAG_SEEKING) {
@@ -1240,29 +1215,48 @@ static ide_startstop_t ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq,
 		}
 		if (rq_data_dir(rq) == READ &&
 		    IDE_LARGE_SEEK(info->last_block, block,
-				   IDECD_SEEK_THRESHOLD) &&
-		    drive->dsc_overlap)
-			action = cdrom_start_seek(drive, block);
-		else
-			action = cdrom_start_rw(drive, rq);
+			    IDECD_SEEK_THRESHOLD) &&
+		    drive->dsc_overlap) {
+			xferlen = 0;
+			fn = cdrom_start_seek_continuation;
+
+			info->dma = 0;
+			info->start_seek = jiffies;
+
+			ide_cd_prepare_seek_request(drive, rq);
+		} else {
+			xferlen = 32768;
+			fn = cdrom_start_rw_cont;
+
+			if (cdrom_start_rw(drive, rq) == ide_stopped)
+				return ide_stopped;
+
+			if (ide_cd_prepare_rw_request(drive, rq) == ide_stopped)
+				return ide_stopped;
+		}
 		info->last_block = block;
-		return action;
 	} else if (blk_sense_request(rq) || blk_pc_request(rq) ||
 		   rq->cmd_type == REQ_TYPE_ATA_PC) {
-		return cdrom_do_block_pc(drive, rq);
+		xferlen = rq->data_len;
+		fn = cdrom_do_newpc_cont;
+
+		if (!rq->timeout)
+			rq->timeout = ATAPI_WAIT_PC;
+
+		cdrom_do_block_pc(drive, rq);
 	} else if (blk_special_request(rq)) {
 		/* right now this can only be a reset... */
 		cdrom_end_request(drive, 1);
 		return ide_stopped;
+	} else {
+		blk_dump_rq_flags(rq, "ide-cd bad flags");
+		cdrom_end_request(drive, 0);
+		return ide_stopped;
 	}
 
-	blk_dump_rq_flags(rq, "ide-cd bad flags");
-	cdrom_end_request(drive, 0);
-	return ide_stopped;
+	return cdrom_start_packet_command(drive, xferlen, fn);
 }
 
-
-
 /*
  * Ioctl handling.
  *
@@ -1872,6 +1866,7 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 
 	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
 	blk_queue_dma_alignment(drive->queue, 31);
+	blk_queue_update_dma_pad(drive->queue, 15);
 	drive->queue->unplug_delay = (1 * HZ) / 1000;
 	if (!drive->queue->unplug_delay)
 		drive->queue->unplug_delay = 1;
@@ -1954,10 +1949,9 @@ static ide_driver_t ide_cdrom_driver = {
 	.version		= IDECD_VERSION,
 	.media			= ide_cdrom,
 	.supports_dsc_overlap	= 1,
-	.do_request		= ide_do_rw_cdrom,
+	.do_request		= ide_cd_do_request,
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
-	.abort			= __ide_abort,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idecd_proc,
 #endif
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 5f49a4a..3a2e802 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -985,7 +985,6 @@ static ide_driver_t idedisk_driver = {
 	.do_request		= ide_do_rw_disk,
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
-	.abort			= __ide_abort,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idedisk_proc,
 #endif
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index b368943..011d720 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -351,10 +351,7 @@ static void ide_floppy_callback(ide_drive_t *drive)
 
 static void idefloppy_init_pc(struct ide_atapi_pc *pc)
 {
-	memset(pc->c, 0, 12);
-	pc->retries = 0;
-	pc->flags = 0;
-	pc->req_xfer = 0;
+	memset(pc, 0, sizeof(*pc));
 	pc->buf = pc->pc_buf;
 	pc->buf_size = IDEFLOPPY_PC_BUFFER_SIZE;
 	pc->callback = ide_floppy_callback;
@@ -561,12 +558,6 @@ static void idefloppy_create_start_stop_cmd(struct ide_atapi_pc *pc, int start)
 	pc->c[4] = start;
 }
 
-static void idefloppy_create_test_unit_ready_cmd(struct ide_atapi_pc *pc)
-{
-	idefloppy_init_pc(pc);
-	pc->c[0] = GPCMD_TEST_UNIT_READY;
-}
-
 static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 				    struct ide_atapi_pc *pc, struct request *rq,
 				    unsigned long sector)
@@ -711,10 +702,10 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 	set_disk_ro(floppy->disk, floppy->wp);
 	page = &pc.buf[8];
 
-	transfer_rate = be16_to_cpu(*(u16 *)&pc.buf[8 + 2]);
-	sector_size   = be16_to_cpu(*(u16 *)&pc.buf[8 + 6]);
-	cyls          = be16_to_cpu(*(u16 *)&pc.buf[8 + 8]);
-	rpm           = be16_to_cpu(*(u16 *)&pc.buf[8 + 28]);
+	transfer_rate = be16_to_cpup((__be16 *)&pc.buf[8 + 2]);
+	sector_size   = be16_to_cpup((__be16 *)&pc.buf[8 + 6]);
+	cyls          = be16_to_cpup((__be16 *)&pc.buf[8 + 8]);
+	rpm           = be16_to_cpup((__be16 *)&pc.buf[8 + 28]);
 	heads         = pc.buf[8 + 4];
 	sectors       = pc.buf[8 + 5];
 
@@ -789,8 +780,8 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	for (i = 0; i < desc_cnt; i++) {
 		unsigned int desc_start = 4 + i*8;
 
-		blocks = be32_to_cpu(*(u32 *)&pc.buf[desc_start]);
-		length = be16_to_cpu(*(u16 *)&pc.buf[desc_start + 6]);
+		blocks = be32_to_cpup((__be32 *)&pc.buf[desc_start]);
+		length = be16_to_cpup((__be16 *)&pc.buf[desc_start + 6]);
 
 		debug_log("Descriptor %d: %dkB, %d blocks, %d sector size\n",
 				i, blocks * length / 1024, blocks, length);
@@ -911,8 +902,8 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 		if (u_index >= u_array_size)
 			break;	/* User-supplied buffer too small */
 
-		blocks = be32_to_cpu(*(u32 *)&pc.buf[desc_start]);
-		length = be16_to_cpu(*(u16 *)&pc.buf[desc_start + 6]);
+		blocks = be32_to_cpup((__be32 *)&pc.buf[desc_start]);
+		length = be16_to_cpup((__be16 *)&pc.buf[desc_start + 6]);
 
 		if (put_user(blocks, argp))
 			return(-EFAULT);
@@ -1138,7 +1129,6 @@ static ide_driver_t idefloppy_driver = {
 	.do_request		= idefloppy_do_request,
 	.end_request		= idefloppy_end_request,
 	.error			= __ide_error,
-	.abort			= __ide_abort,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idefloppy_proc,
 #endif
@@ -1166,7 +1156,9 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
 		/* Just in case */
 
-		idefloppy_create_test_unit_ready_cmd(&pc);
+		idefloppy_init_pc(&pc);
+		pc.c[0] = GPCMD_TEST_UNIT_READY;
+
 		if (idefloppy_queue_pc_tail(drive, &pc)) {
 			idefloppy_create_start_stop_cmd(&pc, 1);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 2805774..661b75a 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -504,55 +504,6 @@ ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, u8 stat)
 
 EXPORT_SYMBOL_GPL(ide_error);
 
-ide_startstop_t __ide_abort(ide_drive_t *drive, struct request *rq)
-{
-	if (drive->media != ide_disk)
-		rq->errors |= ERROR_RESET;
-
-	ide_kill_rq(drive, rq);
-
-	return ide_stopped;
-}
-
-EXPORT_SYMBOL_GPL(__ide_abort);
-
-/**
- *	ide_abort	-	abort pending IDE operations
- *	@drive: drive the error occurred on
- *	@msg: message to report
- *
- *	ide_abort kills and cleans up when we are about to do a 
- *	host initiated reset on active commands. Longer term we
- *	want handlers to have sensible abort handling themselves
- *
- *	This differs fundamentally from ide_error because in 
- *	this case the command is doing just fine when we
- *	blow it away.
- */
- 
-ide_startstop_t ide_abort(ide_drive_t *drive, const char *msg)
-{
-	struct request *rq;
-
-	if (drive == NULL || (rq = HWGROUP(drive)->rq) == NULL)
-		return ide_stopped;
-
-	/* retry only "normal" I/O: */
-	if (!blk_fs_request(rq)) {
-		rq->errors = 1;
-		ide_end_drive_cmd(drive, BUSY_STAT, 0);
-		return ide_stopped;
-	}
-
-	if (rq->rq_disk) {
-		ide_driver_t *drv;
-
-		drv = *(ide_driver_t **)rq->rq_disk->private_data;
-		return drv->abort(drive, rq);
-	} else
-		return __ide_abort(drive, rq);
-}
-
 static void ide_tf_set_specify_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 {
 	tf->nsect   = drive->sect;
@@ -766,6 +717,18 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
  	return ide_stopped;
 }
 
+static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
+{
+	switch (rq->cmd[0]) {
+	case REQ_DRIVE_RESET:
+		return ide_do_reset(drive);
+	default:
+		blk_dump_rq_flags(rq, "ide_special_rq - bad request");
+		ide_end_request(drive, 0, 0);
+		return ide_stopped;
+	}
+}
+
 static void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 {
 	struct request_pm_state *pm = rq->data;
@@ -869,7 +832,16 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 			    pm->pm_step == ide_pm_state_completed)
 				ide_complete_pm_request(drive, rq);
 			return startstop;
-		}
+		} else if (!rq->rq_disk && blk_special_request(rq))
+			/*
+			 * TODO: Once all ULDs have been modified to
+			 * check for specific op codes rather than
+			 * blindly accepting any special request, the
+			 * check for ->rq_disk above may be replaced
+			 * by a more suitable mechanism or even
+			 * dropped entirely.
+			 */
+			return ide_special_rq(drive, rq);
 
 		drv = *(ide_driver_t **)rq->rq_disk->private_data;
 		return drv->do_request(drive, rq, block);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 80ad4f2..44aaec2 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -905,6 +905,14 @@ void ide_execute_pkt_cmd(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
 
+static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
+{
+	struct request *rq = drive->hwif->hwgroup->rq;
+
+	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET)
+		ide_end_request(drive, err ? err : 1, 0);
+}
+
 /* needed below */
 static ide_startstop_t do_reset1 (ide_drive_t *, int);
 
@@ -940,7 +948,7 @@ static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
 	}
 	/* done polling */
 	hwgroup->polling = 0;
-	hwgroup->resetting = 0;
+	ide_complete_drive_reset(drive, 0);
 	return ide_stopped;
 }
 
@@ -956,12 +964,14 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 	ide_hwif_t *hwif	= HWIF(drive);
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 	u8 tmp;
+	int err = 0;
 
 	if (port_ops && port_ops->reset_poll) {
-		if (port_ops->reset_poll(drive)) {
+		err = port_ops->reset_poll(drive);
+		if (err) {
 			printk(KERN_ERR "%s: host reset_poll failure for %s.\n",
 				hwif->name, drive->name);
-			return ide_stopped;
+			goto out;
 		}
 	}
 
@@ -975,6 +985,7 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 		}
 		printk("%s: reset timed-out, status=0x%02x\n", hwif->name, tmp);
 		drive->failures++;
+		err = -EIO;
 	} else  {
 		printk("%s: reset: ", hwif->name);
 		tmp = ide_read_error(drive);
@@ -1001,10 +1012,12 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 			if (tmp & 0x80)
 				printk("; slave: failed");
 			printk("\n");
+			err = -EIO;
 		}
 	}
+out:
 	hwgroup->polling = 0;	/* done polling */
-	hwgroup->resetting = 0; /* done reset attempt */
+	ide_complete_drive_reset(drive, err);
 	return ide_stopped;
 }
 
@@ -1090,7 +1103,6 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 
 	/* For an ATAPI device, first try an ATAPI SRST. */
 	if (drive->media != ide_disk && !do_not_try_atapi) {
-		hwgroup->resetting = 1;
 		pre_reset(drive);
 		SELECT_DRIVE(drive);
 		udelay (20);
@@ -1112,10 +1124,10 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 
 	if (io_ports->ctl_addr == 0) {
 		spin_unlock_irqrestore(&ide_lock, flags);
+		ide_complete_drive_reset(drive, -ENXIO);
 		return ide_stopped;
 	}
 
-	hwgroup->resetting = 1;
 	/*
 	 * Note that we also set nIEN while resetting the device,
 	 * to mask unwanted interrupts from the interface during the reset.
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 47af80d..13af72f 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -1,26 +1,11 @@
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
 #include <linux/interrupt.h>
-#include <linux/major.h>
-#include <linux/errno.h>
-#include <linux/genhd.h>
-#include <linux/blkpg.h>
-#include <linux/slab.h>
-#include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/bitops.h>
 
-#include <asm/byteorder.h>
-#include <asm/irq.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
-
 static const char *udma_str[] =
 	 { "UDMA/16", "UDMA/25",  "UDMA/33",  "UDMA/44",
 	   "UDMA/66", "UDMA/100", "UDMA/133", "UDMA7" };
@@ -90,142 +75,6 @@ static u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
 	return min(speed, mode);
 }
 
-/*
- * Standard (generic) timings for PIO modes, from ATA2 specification.
- * These timings are for access to the IDE data port register *only*.
- * Some drives may specify a mode, while also specifying a different
- * value for cycle_time (from drive identification data).
- */
-const ide_pio_timings_t ide_pio_timings[6] = {
-	{ 70,	165,	600 },	/* PIO Mode 0 */
-	{ 50,	125,	383 },	/* PIO Mode 1 */
-	{ 30,	100,	240 },	/* PIO Mode 2 */
-	{ 30,	80,	180 },	/* PIO Mode 3 with IORDY */
-	{ 25,	70,	120 },	/* PIO Mode 4 with IORDY */
-	{ 20,	50,	100 }	/* PIO Mode 5 with IORDY (nonstandard) */
-};
-
-EXPORT_SYMBOL_GPL(ide_pio_timings);
-
-/*
- * Shared data/functions for determining best PIO mode for an IDE drive.
- * Most of this stuff originally lived in cmd640.c, and changes to the
- * ide_pio_blacklist[] table should be made with EXTREME CAUTION to avoid
- * breaking the fragile cmd640.c support.
- */
-
-/*
- * Black list. Some drives incorrectly report their maximal PIO mode,
- * at least in respect to CMD640. Here we keep info on some known drives.
- */
-static struct ide_pio_info {
-	const char	*name;
-	int		pio;
-} ide_pio_blacklist [] = {
-	{ "Conner Peripherals 540MB - CFS540A", 3 },
-
-	{ "WDC AC2700",  3 },
-	{ "WDC AC2540",  3 },
-	{ "WDC AC2420",  3 },
-	{ "WDC AC2340",  3 },
-	{ "WDC AC2250",  0 },
-	{ "WDC AC2200",  0 },
-	{ "WDC AC21200", 4 },
-	{ "WDC AC2120",  0 },
-	{ "WDC AC2850",  3 },
-	{ "WDC AC1270",  3 },
-	{ "WDC AC1170",  1 },
-	{ "WDC AC1210",  1 },
-	{ "WDC AC280",   0 },
-	{ "WDC AC31000", 3 },
-	{ "WDC AC31200", 3 },
-
-	{ "Maxtor 7131 AT", 1 },
-	{ "Maxtor 7171 AT", 1 },
-	{ "Maxtor 7213 AT", 1 },
-	{ "Maxtor 7245 AT", 1 },
-	{ "Maxtor 7345 AT", 1 },
-	{ "Maxtor 7546 AT", 3 },
-	{ "Maxtor 7540 AV", 3 },
-
-	{ "SAMSUNG SHD-3121A", 1 },
-	{ "SAMSUNG SHD-3122A", 1 },
-	{ "SAMSUNG SHD-3172A", 1 },
-
-	{ "ST5660A",  3 },
-	{ "ST3660A",  3 },
-	{ "ST3630A",  3 },
-	{ "ST3655A",  3 },
-	{ "ST3391A",  3 },
-	{ "ST3390A",  1 },
-	{ "ST3600A",  1 },
-	{ "ST3290A",  0 },
-	{ "ST3144A",  0 },
-	{ "ST3491A",  1 },	/* reports 3, should be 1 or 2 (depending on */	
-				/* drive) according to Seagates FIND-ATA program */
-
-	{ "QUANTUM ELS127A", 0 },
-	{ "QUANTUM ELS170A", 0 },
-	{ "QUANTUM LPS240A", 0 },
-	{ "QUANTUM LPS210A", 3 },
-	{ "QUANTUM LPS270A", 3 },
-	{ "QUANTUM LPS365A", 3 },
-	{ "QUANTUM LPS540A", 3 },
-	{ "QUANTUM LIGHTNING 540A", 3 },
-	{ "QUANTUM LIGHTNING 730A", 3 },
-
-        { "QUANTUM FIREBALL_540", 3 }, /* Older Quantum Fireballs don't work */
-        { "QUANTUM FIREBALL_640", 3 }, 
-        { "QUANTUM FIREBALL_1080", 3 },
-        { "QUANTUM FIREBALL_1280", 3 },
-	{ NULL,	0 }
-};
-
-/**
- *	ide_scan_pio_blacklist 	-	check for a blacklisted drive
- *	@model: Drive model string
- *
- *	This routine searches the ide_pio_blacklist for an entry
- *	matching the start/whole of the supplied model name.
- *
- *	Returns -1 if no match found.
- *	Otherwise returns the recommended PIO mode from ide_pio_blacklist[].
- */
-
-static int ide_scan_pio_blacklist (char *model)
-{
-	struct ide_pio_info *p;
-
-	for (p = ide_pio_blacklist; p->name != NULL; p++) {
-		if (strncmp(p->name, model, strlen(p->name)) == 0)
-			return p->pio;
-	}
-	return -1;
-}
-
-unsigned int ide_pio_cycle_time(ide_drive_t *drive, u8 pio)
-{
-	struct hd_driveid *id = drive->id;
-	int cycle_time = 0;
-
-	if (id->field_valid & 2) {
-		if (id->capability & 8)
-			cycle_time = id->eide_pio_iordy;
-		else
-			cycle_time = id->eide_pio;
-	}
-
-	/* conservative "downgrade" for all pre-ATA2 drives */
-	if (pio < 3) {
-		if (cycle_time && cycle_time < ide_pio_timings[pio].cycle_time)
-			cycle_time = 0; /* use standard timing */
-	}
-
-	return cycle_time ? cycle_time : ide_pio_timings[pio].cycle_time;
-}
-
-EXPORT_SYMBOL_GPL(ide_pio_cycle_time);
-
 /**
  *	ide_get_best_pio_mode	-	get PIO mode from drive
  *	@drive: drive to consider
diff --git a/drivers/ide/ide-pio-blacklist.c b/drivers/ide/ide-pio-blacklist.c
new file mode 100644
index 0000000..a8c2c8f
--- /dev/null
+++ b/drivers/ide/ide-pio-blacklist.c
@@ -0,0 +1,94 @@
+/*
+ * PIO blacklist.  Some drives incorrectly report their maximal PIO mode,
+ * at least in respect to CMD640.  Here we keep info on some known drives.
+ *
+ * Changes to the ide_pio_blacklist[] should be made with EXTREME CAUTION
+ * to avoid breaking the fragile cmd640.c support.
+ */
+
+#include <linux/string.h>
+
+static struct ide_pio_info {
+	const char	*name;
+	int		pio;
+} ide_pio_blacklist [] = {
+	{ "Conner Peripherals 540MB - CFS540A", 3 },
+
+	{ "WDC AC2700",  3 },
+	{ "WDC AC2540",  3 },
+	{ "WDC AC2420",  3 },
+	{ "WDC AC2340",  3 },
+	{ "WDC AC2250",  0 },
+	{ "WDC AC2200",  0 },
+	{ "WDC AC21200", 4 },
+	{ "WDC AC2120",  0 },
+	{ "WDC AC2850",  3 },
+	{ "WDC AC1270",  3 },
+	{ "WDC AC1170",  1 },
+	{ "WDC AC1210",  1 },
+	{ "WDC AC280",   0 },
+	{ "WDC AC31000", 3 },
+	{ "WDC AC31200", 3 },
+
+	{ "Maxtor 7131 AT", 1 },
+	{ "Maxtor 7171 AT", 1 },
+	{ "Maxtor 7213 AT", 1 },
+	{ "Maxtor 7245 AT", 1 },
+	{ "Maxtor 7345 AT", 1 },
+	{ "Maxtor 7546 AT", 3 },
+	{ "Maxtor 7540 AV", 3 },
+
+	{ "SAMSUNG SHD-3121A", 1 },
+	{ "SAMSUNG SHD-3122A", 1 },
+	{ "SAMSUNG SHD-3172A", 1 },
+
+	{ "ST5660A",  3 },
+	{ "ST3660A",  3 },
+	{ "ST3630A",  3 },
+	{ "ST3655A",  3 },
+	{ "ST3391A",  3 },
+	{ "ST3390A",  1 },
+	{ "ST3600A",  1 },
+	{ "ST3290A",  0 },
+	{ "ST3144A",  0 },
+	{ "ST3491A",  1 }, /* reports 3, should be 1 or 2 (depending on drive)
+			      according to Seagate's FIND-ATA program */
+
+	{ "QUANTUM ELS127A", 0 },
+	{ "QUANTUM ELS170A", 0 },
+	{ "QUANTUM LPS240A", 0 },
+	{ "QUANTUM LPS210A", 3 },
+	{ "QUANTUM LPS270A", 3 },
+	{ "QUANTUM LPS365A", 3 },
+	{ "QUANTUM LPS540A", 3 },
+	{ "QUANTUM LIGHTNING 540A", 3 },
+	{ "QUANTUM LIGHTNING 730A", 3 },
+
+	{ "QUANTUM FIREBALL_540", 3 }, /* Older Quantum Fireballs don't work */
+	{ "QUANTUM FIREBALL_640", 3 },
+	{ "QUANTUM FIREBALL_1080", 3 },
+	{ "QUANTUM FIREBALL_1280", 3 },
+	{ NULL, 0 }
+};
+
+/**
+ *	ide_scan_pio_blacklist 	-	check for a blacklisted drive
+ *	@model: Drive model string
+ *
+ *	This routine searches the ide_pio_blacklist for an entry
+ *	matching the start/whole of the supplied model name.
+ *
+ *	Returns -1 if no match found.
+ *	Otherwise returns the recommended PIO mode from ide_pio_blacklist[].
+ */
+
+int ide_scan_pio_blacklist(char *model)
+{
+	struct ide_pio_info *p;
+
+	for (p = ide_pio_blacklist; p->name != NULL; p++) {
+		if (strncmp(p->name, model, strlen(p->name)) == 0)
+			return p->pio;
+	}
+	return -1;
+}
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index adbd017..03f2ef5 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -33,6 +33,8 @@ static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	ide_hwif_t *hwif;
 	unsigned long base, ctl;
 
+	printk(KERN_INFO DRV_NAME ": generic PnP IDE interface\n");
+
 	if (!(pnp_port_valid(dev, 0) && pnp_port_valid(dev, 1) && pnp_irq_valid(dev, 0)))
 		return -1;
 
@@ -62,10 +64,8 @@ static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
 
-		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
 
-		printk(KERN_INFO "ide%d: generic PnP IDE interface\n", index);
 		pnp_set_drvdata(dev, hwif);
 
 		ide_device_add(idx, NULL);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index d21e51a..235ebdb 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -39,6 +39,8 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+static ide_hwif_t ide_hwifs[MAX_HWIFS]; /* master data repository */
+
 /**
  *	generic_id		-	add a generic drive id
  *	@drive:	drive to make an ID block for
@@ -1318,10 +1320,10 @@ static void ide_port_init_devices(ide_hwif_t *hwif)
 			drive->unmask = 1;
 		if (hwif->host_flags & IDE_HFLAG_NO_UNMASK_IRQS)
 			drive->no_unmask = 1;
-	}
 
-	if (port_ops && port_ops->port_init_devs)
-		port_ops->port_init_devs(hwif);
+		if (port_ops && port_ops->init_dev)
+			port_ops->init_dev(drive);
+	}
 }
 
 static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
@@ -1473,22 +1475,29 @@ ide_hwif_t *ide_find_port_slot(const struct ide_port_info *d)
 		for (; i < MAX_HWIFS; i++) {
 			hwif = &ide_hwifs[i];
 			if (hwif->chipset == ide_unknown)
-				return hwif;
+				goto out_found;
 		}
 	} else {
 		for (i = 2; i < MAX_HWIFS; i++) {
 			hwif = &ide_hwifs[i];
 			if (hwif->chipset == ide_unknown)
-				return hwif;
+				goto out_found;
 		}
 		for (i = 0; i < 2 && i < MAX_HWIFS; i++) {
 			hwif = &ide_hwifs[i];
 			if (hwif->chipset == ide_unknown)
-				return hwif;
+				goto out_found;
 		}
 	}
 
+	printk(KERN_ERR "%s: no free slot for interface\n",
+			d ? d->name : "ide");
+
 	return NULL;
+
+out_found:
+	ide_init_port_data(hwif, i);
+	return hwif;
 }
 EXPORT_SYMBOL_GPL(ide_find_port_slot);
 
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index f9cf167..b711ab9 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2591,7 +2591,6 @@ static ide_driver_t idetape_driver = {
 	.do_request		= idetape_do_request,
 	.end_request		= idetape_end_request,
 	.error			= __ide_error,
-	.abort			= __ide_abort,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idetape_proc,
 #endif
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index cf55a48..1fbdb74 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -8,28 +8,18 @@
  *  The big the bad and the ugly.
  */
 
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
-#include <linux/major.h>
 #include <linux/errno.h>
-#include <linux/genhd.h>
-#include <linux/blkpg.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
-#include <linux/bitops.h>
 #include <linux/scatterlist.h>
 
-#include <asm/byteorder.h>
-#include <asm/irq.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -62,25 +52,6 @@ int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
 	return ide_raw_taskfile(drive, &args, buf, 1);
 }
 
-static int inline task_dma_ok(ide_task_t *task)
-{
-	if (blk_fs_request(task->rq) || (task->tf_flags & IDE_TFLAG_FLAGGED))
-		return 1;
-
-	switch (task->tf.command) {
-		case WIN_WRITEDMA_ONCE:
-		case WIN_WRITEDMA:
-		case WIN_WRITEDMA_EXT:
-		case WIN_READDMA_ONCE:
-		case WIN_READDMA:
-		case WIN_READDMA_EXT:
-		case WIN_IDENTIFY_DMA:
-			return 1;
-	}
-
-	return 0;
-}
-
 static ide_startstop_t task_no_data_intr(ide_drive_t *);
 static ide_startstop_t set_geometry_intr(ide_drive_t *);
 static ide_startstop_t recal_intr(ide_drive_t *);
@@ -139,8 +110,7 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 				    WAIT_WORSTCASE, NULL);
 		return ide_started;
 	default:
-		if (task_dma_ok(task) == 0 || drive->using_dma == 0 ||
-		    dma_ops->dma_setup(drive))
+		if (drive->using_dma == 0 || dma_ops->dma_setup(drive))
 			return ide_stopped;
 		dma_ops->dma_exec_cmd(drive, tf->command);
 		dma_ops->dma_start(drive);
@@ -183,7 +153,6 @@ static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
 	if (stat & (ERR_STAT|DRQ_STAT))
 		return ide_error(drive, "set_geometry_intr", stat);
 
-	BUG_ON(HWGROUP(drive)->handler != NULL);
 	ide_set_handler(drive, &set_geometry_intr, WAIT_WORSTCASE, NULL);
 	return ide_started;
 }
diff --git a/drivers/ide/ide-timing.h b/drivers/ide/ide-timing.h
deleted file mode 100644
index 2e91c58..0000000
--- a/drivers/ide/ide-timing.h
+++ /dev/null
@@ -1,217 +0,0 @@
-#ifndef _IDE_TIMING_H
-#define _IDE_TIMING_H
-
-/*
- *  Copyright (c) 1999-2001 Vojtech Pavlik
- */
-
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- * Should you need to contact me, the author, you can do so either by
- * e-mail - mail your message to <vojtech@ucw.cz>, or by paper mail:
- * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
- */
-
-#include <linux/kernel.h>
-#include <linux/hdreg.h>
-
-#define XFER_PIO_5		0x0d
-#define XFER_UDMA_SLOW		0x4f
-
-struct ide_timing {
-	short mode;
-	short setup;	/* t1 */
-	short act8b;	/* t2 for 8-bit io */
-	short rec8b;	/* t2i for 8-bit io */
-	short cyc8b;	/* t0 for 8-bit io */
-	short active;	/* t2 or tD */
-	short recover;	/* t2i or tK */
-	short cycle;	/* t0 */
-	short udma;	/* t2CYCTYP/2 */
-};
-
-/*
- * PIO 0-5, MWDMA 0-2 and UDMA 0-6 timings (in nanoseconds).
- * These were taken from ATA/ATAPI-6 standard, rev 0a, except
- * for PIO 5, which is a nonstandard extension and UDMA6, which
- * is currently supported only by Maxtor drives. 
- */
-
-static struct ide_timing ide_timing[] = {
-
-	{ XFER_UDMA_6,     0,   0,   0,   0,   0,   0,   0,  15 },
-	{ XFER_UDMA_5,     0,   0,   0,   0,   0,   0,   0,  20 },
-	{ XFER_UDMA_4,     0,   0,   0,   0,   0,   0,   0,  30 },
-	{ XFER_UDMA_3,     0,   0,   0,   0,   0,   0,   0,  45 },
-
-	{ XFER_UDMA_2,     0,   0,   0,   0,   0,   0,   0,  60 },
-	{ XFER_UDMA_1,     0,   0,   0,   0,   0,   0,   0,  80 },
-	{ XFER_UDMA_0,     0,   0,   0,   0,   0,   0,   0, 120 },
-
-	{ XFER_UDMA_SLOW,  0,   0,   0,   0,   0,   0,   0, 150 },
-                                          
-	{ XFER_MW_DMA_2,  25,   0,   0,   0,  70,  25, 120,   0 },
-	{ XFER_MW_DMA_1,  45,   0,   0,   0,  80,  50, 150,   0 },
-	{ XFER_MW_DMA_0,  60,   0,   0,   0, 215, 215, 480,   0 },
-                                          
-	{ XFER_SW_DMA_2,  60,   0,   0,   0, 120, 120, 240,   0 },
-	{ XFER_SW_DMA_1,  90,   0,   0,   0, 240, 240, 480,   0 },
-	{ XFER_SW_DMA_0, 120,   0,   0,   0, 480, 480, 960,   0 },
-
-	{ XFER_PIO_5,     20,  50,  30, 100,  50,  30, 100,   0 },
-	{ XFER_PIO_4,     25,  70,  25, 120,  70,  25, 120,   0 },
-	{ XFER_PIO_3,     30,  80,  70, 180,  80,  70, 180,   0 },
-
-	{ XFER_PIO_2,     30, 290,  40, 330, 100,  90, 240,   0 },
-	{ XFER_PIO_1,     50, 290,  93, 383, 125, 100, 383,   0 },
-	{ XFER_PIO_0,     70, 290, 240, 600, 165, 150, 600,   0 },
-
-	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 960,   0 },
-
-	{ -1 }
-};
-
-#define IDE_TIMING_SETUP	0x01
-#define IDE_TIMING_ACT8B	0x02
-#define IDE_TIMING_REC8B	0x04
-#define IDE_TIMING_CYC8B	0x08
-#define IDE_TIMING_8BIT		0x0e
-#define IDE_TIMING_ACTIVE	0x10
-#define IDE_TIMING_RECOVER	0x20
-#define IDE_TIMING_CYCLE	0x40
-#define IDE_TIMING_UDMA		0x80
-#define IDE_TIMING_ALL		0xff
-
-#define ENOUGH(v,unit)		(((v)-1)/(unit)+1)
-#define EZ(v,unit)		((v)?ENOUGH(v,unit):0)
-
-#define XFER_MODE	0xf0
-#define XFER_MWDMA	0x20
-#define XFER_EPIO	0x01
-#define XFER_PIO	0x00
-
-static void ide_timing_quantize(struct ide_timing *t, struct ide_timing *q, int T, int UT)
-{
-	q->setup   = EZ(t->setup   * 1000,  T);
-	q->act8b   = EZ(t->act8b   * 1000,  T);
-	q->rec8b   = EZ(t->rec8b   * 1000,  T);
-	q->cyc8b   = EZ(t->cyc8b   * 1000,  T);
-	q->active  = EZ(t->active  * 1000,  T);
-	q->recover = EZ(t->recover * 1000,  T);
-	q->cycle   = EZ(t->cycle   * 1000,  T);
-	q->udma    = EZ(t->udma    * 1000, UT);
-}
-
-static void ide_timing_merge(struct ide_timing *a, struct ide_timing *b, struct ide_timing *m, unsigned int what)
-{
-	if (what & IDE_TIMING_SETUP  ) m->setup   = max(a->setup,   b->setup);
-	if (what & IDE_TIMING_ACT8B  ) m->act8b   = max(a->act8b,   b->act8b);
-	if (what & IDE_TIMING_REC8B  ) m->rec8b   = max(a->rec8b,   b->rec8b);
-	if (what & IDE_TIMING_CYC8B  ) m->cyc8b   = max(a->cyc8b,   b->cyc8b);
-	if (what & IDE_TIMING_ACTIVE ) m->active  = max(a->active,  b->active);
-	if (what & IDE_TIMING_RECOVER) m->recover = max(a->recover, b->recover);
-	if (what & IDE_TIMING_CYCLE  ) m->cycle   = max(a->cycle,   b->cycle);
-	if (what & IDE_TIMING_UDMA   ) m->udma    = max(a->udma,    b->udma);
-}
-
-static struct ide_timing* ide_timing_find_mode(short speed)
-{
-	struct ide_timing *t;
-
-	for (t = ide_timing; t->mode != speed; t++)
-		if (t->mode < 0)
-			return NULL;
-	return t; 
-}
-
-static int ide_timing_compute(ide_drive_t *drive, short speed, struct ide_timing *t, int T, int UT)
-{
-	struct hd_driveid *id = drive->id;
-	struct ide_timing *s, p;
-
-/*
- * Find the mode.
- */
-
-	if (!(s = ide_timing_find_mode(speed)))
-		return -EINVAL;
-
-/*
- * Copy the timing from the table.
- */
-
-	*t = *s;
-
-/*
- * If the drive is an EIDE drive, it can tell us it needs extended
- * PIO/MWDMA cycle timing.
- */
-
-	if (id && id->field_valid & 2) {	/* EIDE drive */
-
-		memset(&p, 0, sizeof(p));
-
-		switch (speed & XFER_MODE) {
-
-			case XFER_PIO:
-				if (speed <= XFER_PIO_2) p.cycle = p.cyc8b = id->eide_pio;
-						    else p.cycle = p.cyc8b = id->eide_pio_iordy;
-				break;
-
-			case XFER_MWDMA:
-				p.cycle = id->eide_dma_min;
-				break;
-		}
-
-		ide_timing_merge(&p, t, t, IDE_TIMING_CYCLE | IDE_TIMING_CYC8B);
-	}
-
-/*
- * Convert the timing to bus clock counts.
- */
-
-	ide_timing_quantize(t, t, T, UT);
-
-/*
- * Even in DMA/UDMA modes we still use PIO access for IDENTIFY, S.M.A.R.T
- * and some other commands. We have to ensure that the DMA cycle timing is
- * slower/equal than the fastest PIO timing.
- */
-
-	if ((speed & XFER_MODE) != XFER_PIO) {
-		u8 pio = ide_get_best_pio_mode(drive, 255, 5);
-		ide_timing_compute(drive, XFER_PIO_0 + pio, &p, T, UT);
-		ide_timing_merge(&p, t, t, IDE_TIMING_ALL);
-	}
-
-/*
- * Lengthen active & recovery time so that cycle time is correct.
- */
-
-	if (t->act8b + t->rec8b < t->cyc8b) {
-		t->act8b += (t->cyc8b - (t->act8b + t->rec8b)) / 2;
-		t->rec8b = t->cyc8b - t->act8b;
-	}
-
-	if (t->active + t->recover < t->cycle) {
-		t->active += (t->cycle - (t->active + t->recover)) / 2;
-		t->recover = t->cycle - t->active;
-	}
-
-	return 0;
-}
-
-#endif
diff --git a/drivers/ide/ide-timings.c b/drivers/ide/ide-timings.c
new file mode 100644
index 0000000..8c2f832
--- /dev/null
+++ b/drivers/ide/ide-timings.c
@@ -0,0 +1,205 @@
+/*
+ *  Copyright (c) 1999-2001 Vojtech Pavlik
+ *  Copyright (c) 2007-2008 Bartlomiej Zolnierkiewicz
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Should you need to contact me, the author, you can do so either by
+ * e-mail - mail your message to <vojtech@ucw.cz>, or by paper mail:
+ * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
+ */
+
+#include <linux/kernel.h>
+#include <linux/hdreg.h>
+#include <linux/ide.h>
+#include <linux/module.h>
+
+/*
+ * PIO 0-5, MWDMA 0-2 and UDMA 0-6 timings (in nanoseconds).
+ * These were taken from ATA/ATAPI-6 standard, rev 0a, except
+ * for PIO 5, which is a nonstandard extension and UDMA6, which
+ * is currently supported only by Maxtor drives.
+ */
+
+static struct ide_timing ide_timing[] = {
+
+	{ XFER_UDMA_6,     0,   0,   0,   0,   0,   0,   0,  15 },
+	{ XFER_UDMA_5,     0,   0,   0,   0,   0,   0,   0,  20 },
+	{ XFER_UDMA_4,     0,   0,   0,   0,   0,   0,   0,  30 },
+	{ XFER_UDMA_3,     0,   0,   0,   0,   0,   0,   0,  45 },
+
+	{ XFER_UDMA_2,     0,   0,   0,   0,   0,   0,   0,  60 },
+	{ XFER_UDMA_1,     0,   0,   0,   0,   0,   0,   0,  80 },
+	{ XFER_UDMA_0,     0,   0,   0,   0,   0,   0,   0, 120 },
+
+	{ XFER_MW_DMA_2,  25,   0,   0,   0,  70,  25, 120,   0 },
+	{ XFER_MW_DMA_1,  45,   0,   0,   0,  80,  50, 150,   0 },
+	{ XFER_MW_DMA_0,  60,   0,   0,   0, 215, 215, 480,   0 },
+
+	{ XFER_SW_DMA_2,  60,   0,   0,   0, 120, 120, 240,   0 },
+	{ XFER_SW_DMA_1,  90,   0,   0,   0, 240, 240, 480,   0 },
+	{ XFER_SW_DMA_0, 120,   0,   0,   0, 480, 480, 960,   0 },
+
+	{ XFER_PIO_5,     20,  50,  30, 100,  50,  30, 100,   0 },
+	{ XFER_PIO_4,     25,  70,  25, 120,  70,  25, 120,   0 },
+	{ XFER_PIO_3,     30,  80,  70, 180,  80,  70, 180,   0 },
+
+	{ XFER_PIO_2,     30, 290,  40, 330, 100,  90, 240,   0 },
+	{ XFER_PIO_1,     50, 290,  93, 383, 125, 100, 383,   0 },
+	{ XFER_PIO_0,     70, 290, 240, 600, 165, 150, 600,   0 },
+
+	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 960,   0 },
+
+	{ 0xff }
+};
+
+struct ide_timing *ide_timing_find_mode(u8 speed)
+{
+	struct ide_timing *t;
+
+	for (t = ide_timing; t->mode != speed; t++)
+		if (t->mode == 0xff)
+			return NULL;
+	return t;
+}
+EXPORT_SYMBOL_GPL(ide_timing_find_mode);
+
+u16 ide_pio_cycle_time(ide_drive_t *drive, u8 pio)
+{
+	struct hd_driveid *id = drive->id;
+	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
+	u16 cycle = 0;
+
+	if (id->field_valid & 2) {
+		if (id->capability & 8)
+			cycle = id->eide_pio_iordy;
+		else
+			cycle = id->eide_pio;
+
+		/* conservative "downgrade" for all pre-ATA2 drives */
+		if (pio < 3 && cycle < t->cycle)
+			cycle = 0; /* use standard timing */
+	}
+
+	return cycle ? cycle : t->cycle;
+}
+EXPORT_SYMBOL_GPL(ide_pio_cycle_time);
+
+#define ENOUGH(v, unit)		(((v) - 1) / (unit) + 1)
+#define EZ(v, unit)		((v) ? ENOUGH(v, unit) : 0)
+
+static void ide_timing_quantize(struct ide_timing *t, struct ide_timing *q,
+				int T, int UT)
+{
+	q->setup   = EZ(t->setup   * 1000,  T);
+	q->act8b   = EZ(t->act8b   * 1000,  T);
+	q->rec8b   = EZ(t->rec8b   * 1000,  T);
+	q->cyc8b   = EZ(t->cyc8b   * 1000,  T);
+	q->active  = EZ(t->active  * 1000,  T);
+	q->recover = EZ(t->recover * 1000,  T);
+	q->cycle   = EZ(t->cycle   * 1000,  T);
+	q->udma    = EZ(t->udma    * 1000, UT);
+}
+
+void ide_timing_merge(struct ide_timing *a, struct ide_timing *b,
+		      struct ide_timing *m, unsigned int what)
+{
+	if (what & IDE_TIMING_SETUP)
+		m->setup   = max(a->setup,   b->setup);
+	if (what & IDE_TIMING_ACT8B)
+		m->act8b   = max(a->act8b,   b->act8b);
+	if (what & IDE_TIMING_REC8B)
+		m->rec8b   = max(a->rec8b,   b->rec8b);
+	if (what & IDE_TIMING_CYC8B)
+		m->cyc8b   = max(a->cyc8b,   b->cyc8b);
+	if (what & IDE_TIMING_ACTIVE)
+		m->active  = max(a->active,  b->active);
+	if (what & IDE_TIMING_RECOVER)
+		m->recover = max(a->recover, b->recover);
+	if (what & IDE_TIMING_CYCLE)
+		m->cycle   = max(a->cycle,   b->cycle);
+	if (what & IDE_TIMING_UDMA)
+		m->udma    = max(a->udma,    b->udma);
+}
+EXPORT_SYMBOL_GPL(ide_timing_merge);
+
+int ide_timing_compute(ide_drive_t *drive, u8 speed,
+		       struct ide_timing *t, int T, int UT)
+{
+	struct hd_driveid *id = drive->id;
+	struct ide_timing *s, p;
+
+	/*
+	 * Find the mode.
+	 */
+	s = ide_timing_find_mode(speed);
+	if (s == NULL)
+		return -EINVAL;
+
+	/*
+	 * Copy the timing from the table.
+	 */
+	*t = *s;
+
+	/*
+	 * If the drive is an EIDE drive, it can tell us it needs extended
+	 * PIO/MWDMA cycle timing.
+	 */
+	if (id && id->field_valid & 2) {	/* EIDE drive */
+
+		memset(&p, 0, sizeof(p));
+
+		if (speed <= XFER_PIO_2)
+			p.cycle = p.cyc8b = id->eide_pio;
+		else if (speed <= XFER_PIO_5)
+			p.cycle = p.cyc8b = id->eide_pio_iordy;
+		else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
+			p.cycle = id->eide_dma_min;
+
+		ide_timing_merge(&p, t, t, IDE_TIMING_CYCLE | IDE_TIMING_CYC8B);
+	}
+
+	/*
+	 * Convert the timing to bus clock counts.
+	 */
+	ide_timing_quantize(t, t, T, UT);
+
+	/*
+	 * Even in DMA/UDMA modes we still use PIO access for IDENTIFY,
+	 * S.M.A.R.T and some other commands. We have to ensure that the
+	 * DMA cycle timing is slower/equal than the fastest PIO timing.
+	 */
+	if (speed >= XFER_SW_DMA_0) {
+		u8 pio = ide_get_best_pio_mode(drive, 255, 5);
+		ide_timing_compute(drive, XFER_PIO_0 + pio, &p, T, UT);
+		ide_timing_merge(&p, t, t, IDE_TIMING_ALL);
+	}
+
+	/*
+	 * Lengthen active & recovery time so that cycle time is correct.
+	 */
+	if (t->act8b + t->rec8b < t->cyc8b) {
+		t->act8b += (t->cyc8b - (t->act8b + t->rec8b)) / 2;
+		t->rec8b = t->cyc8b - t->act8b;
+	}
+
+	if (t->active + t->recover < t->cycle) {
+		t->active += (t->cycle - (t->active + t->recover)) / 2;
+		t->recover = t->cycle - t->active;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_timing_compute);
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 2b84535..d4a6b10 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -50,29 +50,16 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/major.h>
 #include <linux/errno.h>
 #include <linux/genhd.h>
-#include <linux/blkpg.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/ide.h>
 #include <linux/completion.h>
-#include <linux/reboot.h>
-#include <linux/cdrom.h>
-#include <linux/seq_file.h>
 #include <linux/device.h>
-#include <linux/bitops.h>
-
-#include <asm/byteorder.h>
-#include <asm/irq.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
 
 
 /* default maximum number of failures */
@@ -91,8 +78,6 @@ DEFINE_MUTEX(ide_cfg_mtx);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(ide_lock);
 EXPORT_SYMBOL(ide_lock);
 
-ide_hwif_t ide_hwifs[MAX_HWIFS];	/* master data repository */
-
 static void ide_port_init_devices_data(ide_hwif_t *);
 
 /*
@@ -121,7 +106,6 @@ void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
 
 	ide_port_init_devices_data(hwif);
 }
-EXPORT_SYMBOL_GPL(ide_init_port_data);
 
 static void ide_port_init_devices_data(ide_hwif_t *hwif)
 {
@@ -150,18 +134,6 @@ static void ide_port_init_devices_data(ide_hwif_t *hwif)
 	}
 }
 
-static void __init init_ide_data (void)
-{
-	unsigned int index;
-
-	/* Initialise all interface structures */
-	for (index = 0; index < MAX_HWIFS; ++index) {
-		ide_hwif_t *hwif = &ide_hwifs[index];
-
-		ide_init_port_data(hwif, index);
-	}
-}
-
 void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
 {
 	ide_hwgroup_t *hwgroup = hwif->hwgroup;
@@ -312,7 +284,8 @@ void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
 	memcpy(&hwif->io_ports, &hw->io_ports, sizeof(hwif->io_ports));
 	hwif->irq = hw->irq;
 	hwif->chipset = hw->chipset;
-	hwif->gendev.parent = hw->dev;
+	hwif->dev = hw->dev;
+	hwif->gendev.parent = hw->parent ? hw->parent : hw->dev;
 	hwif->ack_intr = hw->ack_intr;
 }
 EXPORT_SYMBOL_GPL(ide_init_port_hw);
@@ -556,6 +529,22 @@ static int generic_ide_resume(struct device *dev)
 	return err;
 }
 
+static int generic_drive_reset(ide_drive_t *drive)
+{
+	struct request *rq;
+	int ret = 0;
+
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_len = 1;
+	rq->cmd[0] = REQ_DRIVE_RESET;
+	rq->cmd_flags |= REQ_SOFTBARRIER;
+	if (blk_execute_rq(drive->queue, NULL, rq, 1))
+		ret = rq->errors;
+	blk_put_request(rq);
+	return ret;
+}
+
 int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device *bdev,
 			unsigned int cmd, unsigned long arg)
 {
@@ -630,33 +619,8 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 			if (!capable(CAP_SYS_ADMIN))
 				return -EACCES;
 
-			/*
-			 *	Abort the current command on the
-			 *	group if there is one, taking
-			 *	care not to allow anything else
-			 *	to be queued and to die on the
-			 *	spot if we miss one somehow
-			 */
-
-			spin_lock_irqsave(&ide_lock, flags);
-
-			if (HWGROUP(drive)->resetting) {
-				spin_unlock_irqrestore(&ide_lock, flags);
-				return -EBUSY;
-			}
+			return generic_drive_reset(drive);
 
-			ide_abort(drive, "drive reset");
-
-			BUG_ON(HWGROUP(drive)->handler);
-
-			/* Ensure nothing gets queued after we
-			   drop the lock. Reset will clear the busy */
-
-			HWGROUP(drive)->busy = 1;
-			spin_unlock_irqrestore(&ide_lock, flags);
-			(void) ide_do_reset(drive);
-
-			return 0;
 		case HDIO_GET_BUSSTATE:
 			if (!capable(CAP_SYS_ADMIN))
 				return -EACCES;
@@ -1021,8 +985,6 @@ static int __init ide_init(void)
 		goto out_port_class;
 	}
 
-	init_ide_data();
-
 	proc_ide_create();
 
 	return 0;
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index 052125f..4ec1973 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -117,10 +117,11 @@ static void ali14xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	u8 param1, param2, param3, param4;
 	unsigned long flags;
 	int bus_speed = ide_vlb_clk ? ide_vlb_clk : 50;
+	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 
 	/* calculate timing, according to PIO mode */
 	time1 = ide_pio_cycle_time(drive, pio);
-	time2 = ide_pio_timings[pio].active_time;
+	time2 = t->active;
 	param3 = param1 = (time2 * bus_speed + 999) / 1000;
 	param4 = param2 = (time1 * bus_speed + 999) / 1000 - param1;
 	if (pio < 3) {
diff --git a/drivers/ide/legacy/buddha.c b/drivers/ide/legacy/buddha.c
index 9a1d27e..0497e7f 100644
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -227,7 +227,6 @@ fail_base2:
 			if (hwif) {
 				u8 index = hwif->index;
 
-				ide_init_port_data(hwif, index);
 				ide_init_port_hw(hwif, &hw);
 
 				idx[i] = index;
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index af11028..129a812 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -111,7 +111,6 @@ static int __init falconide_init(void)
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
 
-		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
 
 		/* Atari has a byte-swapped IDE interface */
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index b789416..7e74b20 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -185,7 +185,6 @@ found:
 	if (hwif) {
 	    u8 index = hwif->index;
 
-	    ide_init_port_data(hwif, index);
 	    ide_init_port_hw(hwif, &hw);
 
 	    idx[i] = index;
diff --git a/drivers/ide/legacy/hd.c b/drivers/ide/legacy/hd.c
deleted file mode 100644
index abdedf5..0000000
--- a/drivers/ide/legacy/hd.c
+++ /dev/null
@@ -1,815 +0,0 @@
-/*
- *  Copyright (C) 1991, 1992  Linus Torvalds
- *
- * This is the low-level hd interrupt support. It traverses the
- * request-list, using interrupts to jump between functions. As
- * all the functions are called within interrupts, we may not
- * sleep. Special care is recommended.
- *
- *  modified by Drew Eckhardt to check nr of hd's from the CMOS.
- *
- *  Thanks to Branko Lankester, lankeste@fwi.uva.nl, who found a bug
- *  in the early extended-partition checks and added DM partitions
- *
- *  IRQ-unmask, drive-id, multiple-mode, support for ">16 heads",
- *  and general streamlining by Mark Lord.
- *
- *  Removed 99% of above. Use Mark's ide driver for those options.
- *  This is now a lightweight ST-506 driver. (Paul Gortmaker)
- *
- *  Modified 1995 Russell King for ARM processor.
- *
- *  Bugfix: max_sectors must be <= 255 or the wheels tend to come
- *  off in a hurry once you queue things up - Paul G. 02/2001
- */
-
-/* Uncomment the following if you want verbose error reports. */
-/* #define VERBOSE_ERRORS */
-
-#include <linux/blkdev.h>
-#include <linux/errno.h>
-#include <linux/signal.h>
-#include <linux/interrupt.h>
-#include <linux/timer.h>
-#include <linux/fs.h>
-#include <linux/kernel.h>
-#include <linux/genhd.h>
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <linux/ioport.h>
-#include <linux/mc146818rtc.h> /* CMOS defines */
-#include <linux/init.h>
-#include <linux/blkpg.h>
-#include <linux/hdreg.h>
-
-#define REALLY_SLOW_IO
-#include <asm/system.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
-
-#ifdef __arm__
-#undef  HD_IRQ
-#endif
-#include <asm/irq.h>
-#ifdef __arm__
-#define HD_IRQ IRQ_HARDDISK
-#endif
-
-/* Hd controller regster ports */
-
-#define HD_DATA		0x1f0		/* _CTL when writing */
-#define HD_ERROR	0x1f1		/* see err-bits */
-#define HD_NSECTOR	0x1f2		/* nr of sectors to read/write */
-#define HD_SECTOR	0x1f3		/* starting sector */
-#define HD_LCYL		0x1f4		/* starting cylinder */
-#define HD_HCYL		0x1f5		/* high byte of starting cyl */
-#define HD_CURRENT	0x1f6		/* 101dhhhh , d=drive, hhhh=head */
-#define HD_STATUS	0x1f7		/* see status-bits */
-#define HD_FEATURE	HD_ERROR	/* same io address, read=error, write=feature */
-#define HD_PRECOMP	HD_FEATURE	/* obsolete use of this port - predates IDE */
-#define HD_COMMAND	HD_STATUS	/* same io address, read=status, write=cmd */
-
-#define HD_CMD		0x3f6		/* used for resets */
-#define HD_ALTSTATUS	0x3f6		/* same as HD_STATUS but doesn't clear irq */
-
-/* Bits of HD_STATUS */
-#define ERR_STAT		0x01
-#define INDEX_STAT		0x02
-#define ECC_STAT		0x04	/* Corrected error */
-#define DRQ_STAT		0x08
-#define SEEK_STAT		0x10
-#define SERVICE_STAT		SEEK_STAT
-#define WRERR_STAT		0x20
-#define READY_STAT		0x40
-#define BUSY_STAT		0x80
-
-/* Bits for HD_ERROR */
-#define MARK_ERR		0x01	/* Bad address mark */
-#define TRK0_ERR		0x02	/* couldn't find track 0 */
-#define ABRT_ERR		0x04	/* Command aborted */
-#define MCR_ERR			0x08	/* media change request */
-#define ID_ERR			0x10	/* ID field not found */
-#define MC_ERR			0x20	/* media changed */
-#define ECC_ERR			0x40	/* Uncorrectable ECC error */
-#define BBD_ERR			0x80	/* pre-EIDE meaning:  block marked bad */
-#define ICRC_ERR		0x80	/* new meaning:  CRC error during transfer */
-
-static DEFINE_SPINLOCK(hd_lock);
-static struct request_queue *hd_queue;
-
-#define MAJOR_NR HD_MAJOR
-#define QUEUE (hd_queue)
-#define CURRENT elv_next_request(hd_queue)
-
-#define TIMEOUT_VALUE	(6*HZ)
-#define	HD_DELAY	0
-
-#define MAX_ERRORS     16	/* Max read/write errors/sector */
-#define RESET_FREQ      8	/* Reset controller every 8th retry */
-#define RECAL_FREQ      4	/* Recalibrate every 4th retry */
-#define MAX_HD		2
-
-#define STAT_OK		(READY_STAT|SEEK_STAT)
-#define OK_STATUS(s)	(((s)&(STAT_OK|(BUSY_STAT|WRERR_STAT|ERR_STAT)))==STAT_OK)
-
-static void recal_intr(void);
-static void bad_rw_intr(void);
-
-static int reset;
-static int hd_error;
-
-/*
- *  This struct defines the HD's and their types.
- */
-struct hd_i_struct {
-	unsigned int head, sect, cyl, wpcom, lzone, ctl;
-	int unit;
-	int recalibrate;
-	int special_op;
-};
-
-#ifdef HD_TYPE
-static struct hd_i_struct hd_info[] = { HD_TYPE };
-static int NR_HD = ARRAY_SIZE(hd_info);
-#else
-static struct hd_i_struct hd_info[MAX_HD];
-static int NR_HD;
-#endif
-
-static struct gendisk *hd_gendisk[MAX_HD];
-
-static struct timer_list device_timer;
-
-#define TIMEOUT_VALUE (6*HZ)
-
-#define SET_TIMER							\
-	do {								\
-		mod_timer(&device_timer, jiffies + TIMEOUT_VALUE);	\
-	} while (0)
-
-static void (*do_hd)(void) = NULL;
-#define SET_HANDLER(x) \
-if ((do_hd = (x)) != NULL) \
-	SET_TIMER; \
-else \
-	del_timer(&device_timer);
-
-
-#if (HD_DELAY > 0)
-
-#include <asm/i8253.h>
-
-unsigned long last_req;
-
-unsigned long read_timer(void)
-{
-	unsigned long t, flags;
-	int i;
-
-	spin_lock_irqsave(&i8253_lock, flags);
-	t = jiffies * 11932;
-	outb_p(0, 0x43);
-	i = inb_p(0x40);
-	i |= inb(0x40) << 8;
-	spin_unlock_irqrestore(&i8253_lock, flags);
-	return(t - i);
-}
-#endif
-
-static void __init hd_setup(char *str, int *ints)
-{
-	int hdind = 0;
-
-	if (ints[0] != 3)
-		return;
-	if (hd_info[0].head != 0)
-		hdind = 1;
-	hd_info[hdind].head = ints[2];
-	hd_info[hdind].sect = ints[3];
-	hd_info[hdind].cyl = ints[1];
-	hd_info[hdind].wpcom = 0;
-	hd_info[hdind].lzone = ints[1];
-	hd_info[hdind].ctl = (ints[2] > 8 ? 8 : 0);
-	NR_HD = hdind+1;
-}
-
-static void dump_status(const char *msg, unsigned int stat)
-{
-	char *name = "hd?";
-	if (CURRENT)
-		name = CURRENT->rq_disk->disk_name;
-
-#ifdef VERBOSE_ERRORS
-	printk("%s: %s: status=0x%02x { ", name, msg, stat & 0xff);
-	if (stat & BUSY_STAT)	printk("Busy ");
-	if (stat & READY_STAT)	printk("DriveReady ");
-	if (stat & WRERR_STAT)	printk("WriteFault ");
-	if (stat & SEEK_STAT)	printk("SeekComplete ");
-	if (stat & DRQ_STAT)	printk("DataRequest ");
-	if (stat & ECC_STAT)	printk("CorrectedError ");
-	if (stat & INDEX_STAT)	printk("Index ");
-	if (stat & ERR_STAT)	printk("Error ");
-	printk("}\n");
-	if ((stat & ERR_STAT) == 0) {
-		hd_error = 0;
-	} else {
-		hd_error = inb(HD_ERROR);
-		printk("%s: %s: error=0x%02x { ", name, msg, hd_error & 0xff);
-		if (hd_error & BBD_ERR)		printk("BadSector ");
-		if (hd_error & ECC_ERR)		printk("UncorrectableError ");
-		if (hd_error & ID_ERR)		printk("SectorIdNotFound ");
-		if (hd_error & ABRT_ERR)	printk("DriveStatusError ");
-		if (hd_error & TRK0_ERR)	printk("TrackZeroNotFound ");
-		if (hd_error & MARK_ERR)	printk("AddrMarkNotFound ");
-		printk("}");
-		if (hd_error & (BBD_ERR|ECC_ERR|ID_ERR|MARK_ERR)) {
-			printk(", CHS=%d/%d/%d", (inb(HD_HCYL)<<8) + inb(HD_LCYL),
-				inb(HD_CURRENT) & 0xf, inb(HD_SECTOR));
-			if (CURRENT)
-				printk(", sector=%ld", CURRENT->sector);
-		}
-		printk("\n");
-	}
-#else
-	printk("%s: %s: status=0x%02x.\n", name, msg, stat & 0xff);
-	if ((stat & ERR_STAT) == 0) {
-		hd_error = 0;
-	} else {
-		hd_error = inb(HD_ERROR);
-		printk("%s: %s: error=0x%02x.\n", name, msg, hd_error & 0xff);
-	}
-#endif
-}
-
-static void check_status(void)
-{
-	int i = inb_p(HD_STATUS);
-
-	if (!OK_STATUS(i)) {
-		dump_status("check_status", i);
-		bad_rw_intr();
-	}
-}
-
-static int controller_busy(void)
-{
-	int retries = 100000;
-	unsigned char status;
-
-	do {
-		status = inb_p(HD_STATUS);
-	} while ((status & BUSY_STAT) && --retries);
-	return status;
-}
-
-static int status_ok(void)
-{
-	unsigned char status = inb_p(HD_STATUS);
-
-	if (status & BUSY_STAT)
-		return 1;	/* Ancient, but does it make sense??? */
-	if (status & WRERR_STAT)
-		return 0;
-	if (!(status & READY_STAT))
-		return 0;
-	if (!(status & SEEK_STAT))
-		return 0;
-	return 1;
-}
-
-static int controller_ready(unsigned int drive, unsigned int head)
-{
-	int retry = 100;
-
-	do {
-		if (controller_busy() & BUSY_STAT)
-			return 0;
-		outb_p(0xA0 | (drive<<4) | head, HD_CURRENT);
-		if (status_ok())
-			return 1;
-	} while (--retry);
-	return 0;
-}
-
-static void hd_out(struct hd_i_struct *disk,
-		   unsigned int nsect,
-		   unsigned int sect,
-		   unsigned int head,
-		   unsigned int cyl,
-		   unsigned int cmd,
-		   void (*intr_addr)(void))
-{
-	unsigned short port;
-
-#if (HD_DELAY > 0)
-	while (read_timer() - last_req < HD_DELAY)
-		/* nothing */;
-#endif
-	if (reset)
-		return;
-	if (!controller_ready(disk->unit, head)) {
-		reset = 1;
-		return;
-	}
-	SET_HANDLER(intr_addr);
-	outb_p(disk->ctl, HD_CMD);
-	port = HD_DATA;
-	outb_p(disk->wpcom >> 2, ++port);
-	outb_p(nsect, ++port);
-	outb_p(sect, ++port);
-	outb_p(cyl, ++port);
-	outb_p(cyl >> 8, ++port);
-	outb_p(0xA0 | (disk->unit << 4) | head, ++port);
-	outb_p(cmd, ++port);
-}
-
-static void hd_request (void);
-
-static int drive_busy(void)
-{
-	unsigned int i;
-	unsigned char c;
-
-	for (i = 0; i < 500000 ; i++) {
-		c = inb_p(HD_STATUS);
-		if ((c & (BUSY_STAT | READY_STAT | SEEK_STAT)) == STAT_OK)
-			return 0;
-	}
-	dump_status("reset timed out", c);
-	return 1;
-}
-
-static void reset_controller(void)
-{
-	int	i;
-
-	outb_p(4, HD_CMD);
-	for (i = 0; i < 1000; i++) barrier();
-	outb_p(hd_info[0].ctl & 0x0f, HD_CMD);
-	for (i = 0; i < 1000; i++) barrier();
-	if (drive_busy())
-		printk("hd: controller still busy\n");
-	else if ((hd_error = inb(HD_ERROR)) != 1)
-		printk("hd: controller reset failed: %02x\n", hd_error);
-}
-
-static void reset_hd(void)
-{
-	static int i;
-
-repeat:
-	if (reset) {
-		reset = 0;
-		i = -1;
-		reset_controller();
-	} else {
-		check_status();
-		if (reset)
-			goto repeat;
-	}
-	if (++i < NR_HD) {
-		struct hd_i_struct *disk = &hd_info[i];
-		disk->special_op = disk->recalibrate = 1;
-		hd_out(disk, disk->sect, disk->sect, disk->head-1,
-			disk->cyl, WIN_SPECIFY, &reset_hd);
-		if (reset)
-			goto repeat;
-	} else
-		hd_request();
-}
-
-/*
- * Ok, don't know what to do with the unexpected interrupts: on some machines
- * doing a reset and a retry seems to result in an eternal loop. Right now I
- * ignore it, and just set the timeout.
- *
- * On laptops (and "green" PCs), an unexpected interrupt occurs whenever the
- * drive enters "idle", "standby", or "sleep" mode, so if the status looks
- * "good", we just ignore the interrupt completely.
- */
-static void unexpected_hd_interrupt(void)
-{
-	unsigned int stat = inb_p(HD_STATUS);
-
-	if (stat & (BUSY_STAT|DRQ_STAT|ECC_STAT|ERR_STAT)) {
-		dump_status("unexpected interrupt", stat);
-		SET_TIMER;
-	}
-}
-
-/*
- * bad_rw_intr() now tries to be a bit smarter and does things
- * according to the error returned by the controller.
- * -Mika Liljeberg (liljeber@cs.Helsinki.FI)
- */
-static void bad_rw_intr(void)
-{
-	struct request *req = CURRENT;
-	if (req != NULL) {
-		struct hd_i_struct *disk = req->rq_disk->private_data;
-		if (++req->errors >= MAX_ERRORS || (hd_error & BBD_ERR)) {
-			end_request(req, 0);
-			disk->special_op = disk->recalibrate = 1;
-		} else if (req->errors % RESET_FREQ == 0)
-			reset = 1;
-		else if ((hd_error & TRK0_ERR) || req->errors % RECAL_FREQ == 0)
-			disk->special_op = disk->recalibrate = 1;
-		/* Otherwise just retry */
-	}
-}
-
-static inline int wait_DRQ(void)
-{
-	int retries;
-	int stat;
-
-	for (retries = 0; retries < 100000; retries++) {
-		stat = inb_p(HD_STATUS);
-		if (stat & DRQ_STAT)
-			return 0;
-	}
-	dump_status("wait_DRQ", stat);
-	return -1;
-}
-
-static void read_intr(void)
-{
-	struct request *req;
-	int i, retries = 100000;
-
-	do {
-		i = (unsigned) inb_p(HD_STATUS);
-		if (i & BUSY_STAT)
-			continue;
-		if (!OK_STATUS(i))
-			break;
-		if (i & DRQ_STAT)
-			goto ok_to_read;
-	} while (--retries > 0);
-	dump_status("read_intr", i);
-	bad_rw_intr();
-	hd_request();
-	return;
-ok_to_read:
-	req = CURRENT;
-	insw(HD_DATA, req->buffer, 256);
-	req->sector++;
-	req->buffer += 512;
-	req->errors = 0;
-	i = --req->nr_sectors;
-	--req->current_nr_sectors;
-#ifdef DEBUG
-	printk("%s: read: sector %ld, remaining = %ld, buffer=%p\n",
-		req->rq_disk->disk_name, req->sector, req->nr_sectors,
-		req->buffer+512);
-#endif
-	if (req->current_nr_sectors <= 0)
-		end_request(req, 1);
-	if (i > 0) {
-		SET_HANDLER(&read_intr);
-		return;
-	}
-	(void) inb_p(HD_STATUS);
-#if (HD_DELAY > 0)
-	last_req = read_timer();
-#endif
-	if (elv_next_request(QUEUE))
-		hd_request();
-	return;
-}
-
-static void write_intr(void)
-{
-	struct request *req = CURRENT;
-	int i;
-	int retries = 100000;
-
-	do {
-		i = (unsigned) inb_p(HD_STATUS);
-		if (i & BUSY_STAT)
-			continue;
-		if (!OK_STATUS(i))
-			break;
-		if ((req->nr_sectors <= 1) || (i & DRQ_STAT))
-			goto ok_to_write;
-	} while (--retries > 0);
-	dump_status("write_intr", i);
-	bad_rw_intr();
-	hd_request();
-	return;
-ok_to_write:
-	req->sector++;
-	i = --req->nr_sectors;
-	--req->current_nr_sectors;
-	req->buffer += 512;
-	if (!i || (req->bio && req->current_nr_sectors <= 0))
-		end_request(req, 1);
-	if (i > 0) {
-		SET_HANDLER(&write_intr);
-		outsw(HD_DATA, req->buffer, 256);
-		local_irq_enable();
-	} else {
-#if (HD_DELAY > 0)
-		last_req = read_timer();
-#endif
-		hd_request();
-	}
-	return;
-}
-
-static void recal_intr(void)
-{
-	check_status();
-#if (HD_DELAY > 0)
-	last_req = read_timer();
-#endif
-	hd_request();
-}
-
-/*
- * This is another of the error-routines I don't know what to do with. The
- * best idea seems to just set reset, and start all over again.
- */
-static void hd_times_out(unsigned long dummy)
-{
-	char *name;
-
-	do_hd = NULL;
-
-	if (!CURRENT)
-		return;
-
-	disable_irq(HD_IRQ);
-	local_irq_enable();
-	reset = 1;
-	name = CURRENT->rq_disk->disk_name;
-	printk("%s: timeout\n", name);
-	if (++CURRENT->errors >= MAX_ERRORS) {
-#ifdef DEBUG
-		printk("%s: too many errors\n", name);
-#endif
-		end_request(CURRENT, 0);
-	}
-	local_irq_disable();
-	hd_request();
-	enable_irq(HD_IRQ);
-}
-
-static int do_special_op(struct hd_i_struct *disk, struct request *req)
-{
-	if (disk->recalibrate) {
-		disk->recalibrate = 0;
-		hd_out(disk, disk->sect, 0, 0, 0, WIN_RESTORE, &recal_intr);
-		return reset;
-	}
-	if (disk->head > 16) {
-		printk("%s: cannot handle device with more than 16 heads - giving up\n", req->rq_disk->disk_name);
-		end_request(req, 0);
-	}
-	disk->special_op = 0;
-	return 1;
-}
-
-/*
- * The driver enables interrupts as much as possible.  In order to do this,
- * (a) the device-interrupt is disabled before entering hd_request(),
- * and (b) the timeout-interrupt is disabled before the sti().
- *
- * Interrupts are still masked (by default) whenever we are exchanging
- * data/cmds with a drive, because some drives seem to have very poor
- * tolerance for latency during I/O. The IDE driver has support to unmask
- * interrupts for non-broken hardware, so use that driver if required.
- */
-static void hd_request(void)
-{
-	unsigned int block, nsect, sec, track, head, cyl;
-	struct hd_i_struct *disk;
-	struct request *req;
-
-	if (do_hd)
-		return;
-repeat:
-	del_timer(&device_timer);
-	local_irq_enable();
-
-	req = CURRENT;
-	if (!req) {
-		do_hd = NULL;
-		return;
-	}
-
-	if (reset) {
-		local_irq_disable();
-		reset_hd();
-		return;
-	}
-	disk = req->rq_disk->private_data;
-	block = req->sector;
-	nsect = req->nr_sectors;
-	if (block >= get_capacity(req->rq_disk) ||
-	    ((block+nsect) > get_capacity(req->rq_disk))) {
-		printk("%s: bad access: block=%d, count=%d\n",
-			req->rq_disk->disk_name, block, nsect);
-		end_request(req, 0);
-		goto repeat;
-	}
-
-	if (disk->special_op) {
-		if (do_special_op(disk, req))
-			goto repeat;
-		return;
-	}
-	sec   = block % disk->sect + 1;
-	track = block / disk->sect;
-	head  = track % disk->head;
-	cyl   = track / disk->head;
-#ifdef DEBUG
-	printk("%s: %sing: CHS=%d/%d/%d, sectors=%d, buffer=%p\n",
-		req->rq_disk->disk_name,
-		req_data_dir(req) == READ ? "read" : "writ",
-		cyl, head, sec, nsect, req->buffer);
-#endif
-	if (blk_fs_request(req)) {
-		switch (rq_data_dir(req)) {
-		case READ:
-			hd_out(disk, nsect, sec, head, cyl, WIN_READ,
-				&read_intr);
-			if (reset)
-				goto repeat;
-			break;
-		case WRITE:
-			hd_out(disk, nsect, sec, head, cyl, WIN_WRITE,
-				&write_intr);
-			if (reset)
-				goto repeat;
-			if (wait_DRQ()) {
-				bad_rw_intr();
-				goto repeat;
-			}
-			outsw(HD_DATA, req->buffer, 256);
-			break;
-		default:
-			printk("unknown hd-command\n");
-			end_request(req, 0);
-			break;
-		}
-	}
-}
-
-static void do_hd_request(struct request_queue *q)
-{
-	disable_irq(HD_IRQ);
-	hd_request();
-	enable_irq(HD_IRQ);
-}
-
-static int hd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
-{
-	struct hd_i_struct *disk = bdev->bd_disk->private_data;
-
-	geo->heads = disk->head;
-	geo->sectors = disk->sect;
-	geo->cylinders = disk->cyl;
-	return 0;
-}
-
-/*
- * Releasing a block device means we sync() it, so that it can safely
- * be forgotten about...
- */
-
-static irqreturn_t hd_interrupt(int irq, void *dev_id)
-{
-	void (*handler)(void) = do_hd;
-
-	do_hd = NULL;
-	del_timer(&device_timer);
-	if (!handler)
-		handler = unexpected_hd_interrupt;
-	handler();
-	local_irq_enable();
-	return IRQ_HANDLED;
-}
-
-static struct block_device_operations hd_fops = {
-	.getgeo =	hd_getgeo,
-};
-
-/*
- * This is the hard disk IRQ description. The IRQF_DISABLED in sa_flags
- * means we run the IRQ-handler with interrupts disabled:  this is bad for
- * interrupt latency, but anything else has led to problems on some
- * machines.
- *
- * We enable interrupts in some of the routines after making sure it's
- * safe.
- */
-
-static int __init hd_init(void)
-{
-	int drive;
-
-	if (register_blkdev(MAJOR_NR, "hd"))
-		return -1;
-
-	hd_queue = blk_init_queue(do_hd_request, &hd_lock);
-	if (!hd_queue) {
-		unregister_blkdev(MAJOR_NR, "hd");
-		return -ENOMEM;
-	}
-
-	blk_queue_max_sectors(hd_queue, 255);
-	init_timer(&device_timer);
-	device_timer.function = hd_times_out;
-	blk_queue_hardsect_size(hd_queue, 512);
-
-	if (!NR_HD) {
-		/*
-		 * We don't know anything about the drive.  This means
-		 * that you *MUST* specify the drive parameters to the
-		 * kernel yourself.
-		 *
-		 * If we were on an i386, we used to read this info from
-		 * the BIOS or CMOS.  This doesn't work all that well,
-		 * since this assumes that this is a primary or secondary
-		 * drive, and if we're using this legacy driver, it's
-		 * probably an auxilliary controller added to recover
-		 * legacy data off an ST-506 drive.  Either way, it's
-		 * definitely safest to have the user explicitly specify
-		 * the information.
-		 */
-		printk("hd: no drives specified - use hd=cyl,head,sectors"
-			" on kernel command line\n");
-		goto out;
-	}
-
-	for (drive = 0 ; drive < NR_HD ; drive++) {
-		struct gendisk *disk = alloc_disk(64);
-		struct hd_i_struct *p = &hd_info[drive];
-		if (!disk)
-			goto Enomem;
-		disk->major = MAJOR_NR;
-		disk->first_minor = drive << 6;
-		disk->fops = &hd_fops;
-		sprintf(disk->disk_name, "hd%c", 'a'+drive);
-		disk->private_data = p;
-		set_capacity(disk, p->head * p->sect * p->cyl);
-		disk->queue = hd_queue;
-		p->unit = drive;
-		hd_gendisk[drive] = disk;
-		printk("%s: %luMB, CHS=%d/%d/%d\n",
-			disk->disk_name, (unsigned long)get_capacity(disk)/2048,
-			p->cyl, p->head, p->sect);
-	}
-
-	if (request_irq(HD_IRQ, hd_interrupt, IRQF_DISABLED, "hd", NULL)) {
-		printk("hd: unable to get IRQ%d for the hard disk driver\n",
-			HD_IRQ);
-		goto out1;
-	}
-	if (!request_region(HD_DATA, 8, "hd")) {
-		printk(KERN_WARNING "hd: port 0x%x busy\n", HD_DATA);
-		goto out2;
-	}
-	if (!request_region(HD_CMD, 1, "hd(cmd)")) {
-		printk(KERN_WARNING "hd: port 0x%x busy\n", HD_CMD);
-		goto out3;
-	}
-
-	/* Let them fly */
-	for (drive = 0; drive < NR_HD; drive++)
-		add_disk(hd_gendisk[drive]);
-
-	return 0;
-
-out3:
-	release_region(HD_DATA, 8);
-out2:
-	free_irq(HD_IRQ, NULL);
-out1:
-	for (drive = 0; drive < NR_HD; drive++)
-		put_disk(hd_gendisk[drive]);
-	NR_HD = 0;
-out:
-	del_timer(&device_timer);
-	unregister_blkdev(MAJOR_NR, "hd");
-	blk_cleanup_queue(hd_queue);
-	return -1;
-Enomem:
-	while (drive--)
-		put_disk(hd_gendisk[drive]);
-	goto out;
-}
-
-static int __init parse_hd_setup(char *line)
-{
-	int ints[6];
-
-	(void) get_options(line, ARRAY_SIZE(ints), ints);
-	hd_setup(NULL, ints);
-
-	return 1;
-}
-__setup("hd=", parse_hd_setup);
-
-module_init(hd_init);
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index dd6dfb3..7bc8fd5 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -216,6 +216,7 @@ static u8 ht_pio2timings(ide_drive_t *drive, const u8 pio)
 
         if (pio) {
 		unsigned int cycle_time;
+		struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 
 		cycle_time = ide_pio_cycle_time(drive, pio);
 
@@ -224,10 +225,8 @@ static u8 ht_pio2timings(ide_drive_t *drive, const u8 pio)
 		 *  actual cycle time for recovery and activity
 		 *  according system bus speed.
 		 */
-		active_time = ide_pio_timings[pio].active_time;
-		recovery_time = cycle_time
-			- active_time
-			- ide_pio_timings[pio].setup_time;
+		active_time = t->active;
+		recovery_time = cycle_time - active_time - t->setup;
 		/*
 		 *  Cycle times should be Vesa bus cycles
 		 */
@@ -311,16 +310,16 @@ static void ht6560b_set_pio_mode(ide_drive_t *drive, const u8 pio)
 #endif
 }
 
-static void __init ht6560b_port_init_devs(ide_hwif_t *hwif)
+static void __init ht6560b_init_dev(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	/* Setting default configurations for drives. */
 	int t = (HT_CONFIG_DEFAULT << 8) | HT_TIMING_DEFAULT;
 
 	if (hwif->channel)
 		t |= (HT_SECONDARY_IF << 8);
 
-	hwif->drives[0].drive_data = t;
-	hwif->drives[1].drive_data = t;
+	drive->drive_data = t;
 }
 
 static int probe_ht6560b;
@@ -329,7 +328,7 @@ module_param_named(probe, probe_ht6560b, bool, 0);
 MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
 
 static const struct ide_port_ops ht6560b_port_ops = {
-	.port_init_devs		= ht6560b_port_init_devs,
+	.init_dev		= ht6560b_init_dev,
 	.set_pio_mode		= ht6560b_set_pio_mode,
 	.selectproc		= ht6560b_selectproc,
 };
diff --git a/drivers/ide/legacy/ide-4drives.c b/drivers/ide/legacy/ide-4drives.c
index ecae916..89c8ff0 100644
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -11,6 +11,21 @@ static int probe_4drives;
 module_param_named(probe, probe_4drives, bool, 0);
 MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
 
+static void ide_4drives_init_dev(ide_drive_t *drive)
+{
+	if (drive->hwif->channel)
+		drive->select.all ^= 0x20;
+}
+
+static const struct ide_port_ops ide_4drives_port_ops = {
+	.init_dev		= ide_4drives_init_dev,
+};
+
+static const struct ide_port_info ide_4drives_port_info = {
+	.port_ops		= &ide_4drives_port_ops,
+	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_NO_DMA,
+};
+
 static int __init ide_4drives_init(void)
 {
 	ide_hwif_t *hwif, *mate;
@@ -49,18 +64,10 @@ static int __init ide_4drives_init(void)
 	mate = ide_find_port();
 	if (mate) {
 		ide_init_port_hw(mate, &hw);
-		mate->drives[0].select.all ^= 0x20;
-		mate->drives[1].select.all ^= 0x20;
 		idx[1] = mate->index;
-
-		if (hwif) {
-			hwif->mate = mate;
-			mate->mate = hwif;
-			hwif->serialized = mate->serialized = 1;
-		}
 	}
 
-	ide_device_add(idx, NULL);
+	ide_device_add(idx, &ide_4drives_port_info);
 
 	return 0;
 }
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index 8dbf4d9..fc53dcf 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -154,6 +154,11 @@ static const struct ide_port_ops idecs_port_ops = {
 	.quirkproc		= ide_undecoded_slave,
 };
 
+static const struct ide_port_info idecs_port_info = {
+	.port_ops		= &idecs_port_ops,
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static ide_hwif_t *idecs_register(unsigned long io, unsigned long ctl,
 				unsigned long irq, struct pcmcia_device *handle)
 {
@@ -187,13 +192,11 @@ static ide_hwif_t *idecs_register(unsigned long io, unsigned long ctl,
 
     i = hwif->index;
 
-    ide_init_port_data(hwif, i);
     ide_init_port_hw(hwif, &hw);
-    hwif->port_ops = &idecs_port_ops;
 
     idx[0] = i;
 
-    ide_device_add(idx, NULL);
+    ide_device_add(idx, &idecs_port_info);
 
     if (hwif->present)
 	return hwif;
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
index d3bc3f2..a249562 100644
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -44,6 +44,10 @@ static void __devinit plat_ide_setup_ports(hw_regs_t *hw,
 	hw->chipset = ide_generic;
 }
 
+static const struct ide_port_info platform_ide_port_info = {
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static int __devinit plat_ide_probe(struct platform_device *pdev)
 {
 	struct resource *res_base, *res_alt, *res_irq;
@@ -54,6 +58,7 @@ static int __devinit plat_ide_probe(struct platform_device *pdev)
 	int ret = 0;
 	int mmio = 0;
 	hw_regs_t hw;
+	struct ide_port_info d = platform_ide_port_info;
 
 	pdata = pdev->dev.platform_data;
 
@@ -102,13 +107,13 @@ static int __devinit plat_ide_probe(struct platform_device *pdev)
 	ide_init_port_hw(hwif, &hw);
 
 	if (mmio) {
-		hwif->host_flags = IDE_HFLAG_MMIO;
+		d.host_flags |= IDE_HFLAG_MMIO;
 		default_hwif_mmiops(hwif);
 	}
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx, NULL);
+	ide_device_add(idx, &d);
 
 	platform_set_drvdata(pdev, hwif);
 
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index 2e84290..0a6195b 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -130,7 +130,6 @@ static int __init macide_init(void)
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
 
-		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
 
 		ide_device_add(idx, NULL);
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index 8ff6e2d..9c2b9d0 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -142,7 +142,6 @@ static int __init q40ide_init(void)
 
 	hwif = ide_find_port();
 	if (hwif) {
-		ide_init_port_data(hwif, hwif->index);
 		ide_init_port_hw(hwif, &hw);
 
 		/* Q40 has a byte-swapped IDE interface */
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index 51dba82..2338f34 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -207,6 +207,7 @@ static void qd6500_set_pio_mode(ide_drive_t *drive, const u8 pio)
 static void qd6580_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 	unsigned int cycle_time;
 	int active_time   = 175;
 	int recovery_time = 415; /* worst case values from the dos driver */
@@ -236,7 +237,7 @@ static void qd6580_set_pio_mode(ide_drive_t *drive, const u8 pio)
 					active_time = 110;
 					recovery_time = cycle_time - 120;
 				} else {
-					active_time = ide_pio_timings[pio].active_time;
+					active_time = t->active;
 					recovery_time = cycle_time - active_time;
 				}
 		}
@@ -281,17 +282,18 @@ static int __init qd_testreg(int port)
 	return (readreg != QD_TESTVAL);
 }
 
-static void __init qd6500_port_init_devs(ide_hwif_t *hwif)
+static void __init qd6500_init_dev(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	u8 base = (hwif->config_data & 0xff00) >> 8;
 	u8 config = QD_CONFIG(hwif);
 
-	hwif->drives[0].drive_data = QD6500_DEF_DATA;
-	hwif->drives[1].drive_data = QD6500_DEF_DATA;
+	drive->drive_data = QD6500_DEF_DATA;
 }
 
-static void __init qd6580_port_init_devs(ide_hwif_t *hwif)
+static void __init qd6580_init_dev(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	u16 t1, t2;
 	u8 base = (hwif->config_data & 0xff00) >> 8;
 	u8 config = QD_CONFIG(hwif);
@@ -302,18 +304,17 @@ static void __init qd6580_port_init_devs(ide_hwif_t *hwif)
 	} else
 		t2 = t1 = hwif->channel ? QD6580_DEF_DATA2 : QD6580_DEF_DATA;
 
-	hwif->drives[0].drive_data = t1;
-	hwif->drives[1].drive_data = t2;
+	drive->drive_data = drive->select.b.unit ? t2 : t1;
 }
 
 static const struct ide_port_ops qd6500_port_ops = {
-	.port_init_devs		= qd6500_port_init_devs,
+	.init_dev		= qd6500_init_dev,
 	.set_pio_mode		= qd6500_set_pio_mode,
 	.selectproc		= qd65xx_select,
 };
 
 static const struct ide_port_ops qd6580_port_ops = {
-	.port_init_devs		= qd6580_port_init_devs,
+	.init_dev		= qd6580_init_dev,
 	.set_pio_mode		= qd6580_set_pio_mode,
 	.selectproc		= qd65xx_select,
 };
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 1a6c27b..48d57ca 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -213,10 +213,8 @@ static int auide_build_dmatable(ide_drive_t *drive)
 {
 	int i, iswrite, count = 0;
 	ide_hwif_t *hwif = HWIF(drive);
-
 	struct request *rq = HWGROUP(drive)->rq;
-
-	_auide_hwif *ahwif = (_auide_hwif*)hwif->hwif_data;
+	_auide_hwif *ahwif = &auide_hwif;
 	struct scatterlist *sg;
 
 	iswrite = (rq_data_dir(rq) == WRITE);
@@ -402,7 +400,7 @@ static const struct ide_dma_ops au1xxx_dma_ops = {
 
 static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
-	_auide_hwif *auide = (_auide_hwif *)hwif->hwif_data;
+	_auide_hwif *auide = &auide_hwif;
 	dbdev_tab_t source_dev_tab, target_dev_tab;
 	u32 dev_id, tsize, devwidth, flags;
 
@@ -463,7 +461,7 @@ static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 #else
 static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
-	_auide_hwif *auide = (_auide_hwif *)hwif->hwif_data;
+	_auide_hwif *auide = &auide_hwif;
 	dbdev_tab_t source_dev_tab;
 	int flags;
 
@@ -600,8 +598,6 @@ static int au_ide_probe(struct device *dev)
 
 	ide_init_port_hw(hwif, &hw);
 
-	hwif->dev = dev;
-
 	/* If the user has selected DDMA assisted copies,
 	   then set up a few local I/O function entry points 
 	*/
@@ -610,11 +606,8 @@ static int au_ide_probe(struct device *dev)
 	hwif->input_data  = au1xxx_input_data;
 	hwif->output_data = au1xxx_output_data;
 #endif
-	hwif->select_data               = 0;    /* no chipset-specific code */
-	hwif->config_data               = 0;    /* no chipset-specific code */
 
 	auide_hwif.hwif                 = hwif;
-	hwif->hwif_data                 = &auide_hwif;
 
 	idx[0] = hwif->index;
 
diff --git a/drivers/ide/mips/swarm.c b/drivers/ide/mips/swarm.c
index 52fee3d..9f1212c 100644
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -61,6 +61,11 @@ static struct resource swarm_ide_resource = {
 
 static struct platform_device *swarm_ide_dev;
 
+static const struct ide_port_info swarm_port_info = {
+	.name			= DRV_NAME,
+	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
+};
+
 /*
  * swarm_ide_probe - if the board header indicates the existence of
  * Generic Bus IDE, allocate a HWIF for it.
@@ -77,12 +82,6 @@ static int __devinit swarm_ide_probe(struct device *dev)
 	if (!SIBYTE_HAVE_IDE)
 		return -ENODEV;
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		printk(KERN_ERR DRV_NAME ": no free slot for interface\n");
-		return -ENOMEM;
-	}
-
 	base = ioremap(A_IO_EXT_BASE, 0x800);
 	offset = __raw_readq(base + R_IO_EXT_REG(R_IO_EXT_START_ADDR, IDE_CS));
 	size = __raw_readq(base + R_IO_EXT_REG(R_IO_EXT_MULT_SIZE, IDE_CS));
@@ -109,10 +108,6 @@ static int __devinit swarm_ide_probe(struct device *dev)
 
 	base = ioremap(offset, size);
 
-	/* Setup MMIO ops.  */
-	hwif->host_flags = IDE_HFLAG_MMIO;
-	default_hwif_mmiops(hwif);
-
 	for (i = 0; i <= 7; i++)
 		hw.io_ports_array[i] =
 				(unsigned long)(base + ((0x1f0 + i) << 5));
@@ -121,15 +116,26 @@ static int __devinit swarm_ide_probe(struct device *dev)
 	hw.irq = K_INT_GB_IDE;
 	hw.chipset = ide_generic;
 
+	hwif = ide_find_port_slot(&swarm_port_info);
+	if (hwif == NULL)
+		goto err;
+
 	ide_init_port_hw(hwif, &hw);
 
+	/* Setup MMIO ops. */
+	default_hwif_mmiops(hwif);
+
 	idx[0] = hwif->index;
 
-	ide_device_add(idx, NULL);
+	ide_device_add(idx, &swarm_port_info);
 
 	dev_set_drvdata(dev, hwif);
 
 	return 0;
+err:
+	release_resource(&swarm_ide_resource);
+	iounmap(base);
+	return -ENOMEM;
 }
 
 static struct device_driver swarm_ide_driver = {
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index f2de00a..80d19c0 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -69,7 +69,8 @@ static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	int s_time, a_time, c_time;
+	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
+	int s_time = t->setup, a_time = t->active, c_time = t->cycle;
 	u8 s_clc, a_clc, r_clc;
 	unsigned long flags;
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
@@ -78,13 +79,10 @@ static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	u8 cd_dma_fifo = 0;
 	int unit = drive->select.b.unit & 1;
 
-	s_time = ide_pio_timings[pio].setup_time;
-	a_time = ide_pio_timings[pio].active_time;
 	if ((s_clc = (s_time * bus_speed + 999) / 1000) >= 8)
 		s_clc = 0;
 	if ((a_clc = (a_time * bus_speed + 999) / 1000) >= 8)
 		a_clc = 0;
-	c_time = ide_pio_timings[pio].cycle_time;
 
 	if (!(r_clc = (c_time * bus_speed + 999) / 1000 - a_clc - s_clc)) {
 		r_clc = 1;
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index ad22220..0bfcdd0 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -21,8 +21,6 @@
 #include <linux/init.h>
 #include <linux/ide.h>
 
-#include "ide-timing.h"
-
 enum {
 	AMD_IDE_CONFIG		= 0x41,
 	AMD_CABLE_DETECT	= 0x42,
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index cd1ba14..1ad1e23 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -521,6 +521,7 @@ static void program_drive_counts(ide_drive_t *drive, unsigned int index)
 static void cmd640_set_mode(ide_drive_t *drive, unsigned int index,
 			    u8 pio_mode, unsigned int cycle_time)
 {
+	struct ide_timing *t;
 	int setup_time, active_time, recovery_time, clock_time;
 	u8 setup_count, active_count, recovery_count, recovery_count2, cycle_count;
 	int bus_speed;
@@ -532,8 +533,11 @@ static void cmd640_set_mode(ide_drive_t *drive, unsigned int index,
 
 	if (pio_mode > 5)
 		pio_mode = 5;
-	setup_time  = ide_pio_timings[pio_mode].setup_time;
-	active_time = ide_pio_timings[pio_mode].active_time;
+
+	t = ide_timing_find_mode(XFER_PIO_0 + pio_mode);
+	setup_time  = t->setup;
+	active_time = t->active;
+
 	recovery_time = cycle_time - (setup_time + active_time);
 	clock_time = 1000 / bus_speed;
 	cycle_count = DIV_ROUND_UP(cycle_time, clock_time);
@@ -607,11 +611,40 @@ static void cmd640_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 	display_clocks(index);
 }
+#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
+
+static void cmd640_init_dev(ide_drive_t *drive)
+{
+	unsigned int i = drive->hwif->channel * 2 + drive->select.b.unit;
+
+#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
+	/*
+	 * Reset timing to the slowest speed and turn off prefetch.
+	 * This way, the drive identify code has a better chance.
+	 */
+	setup_counts[i]    =  4;	/* max possible */
+	active_counts[i]   = 16;	/* max possible */
+	recovery_counts[i] = 16;	/* max possible */
+	program_drive_counts(drive, i);
+	set_prefetch_mode(drive, i, 0);
+	printk(KERN_INFO DRV_NAME ": drive%d timings/prefetch cleared\n", i);
+#else
+	/*
+	 * Set the drive unmask flags to match the prefetch setting.
+	 */
+	check_prefetch(drive, i);
+	printk(KERN_INFO DRV_NAME ": drive%d timings/prefetch(%s) preserved\n",
+				  i, drive->no_io_32bit ? "off" : "on");
+#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
+}
+
 
 static const struct ide_port_ops cmd640_port_ops = {
+	.init_dev		= cmd640_init_dev,
+#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 	.set_pio_mode		= cmd640_set_pio_mode,
+#endif
 };
-#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
 static int pci_conf1(void)
 {
@@ -654,10 +687,8 @@ static const struct ide_port_info cmd640_port_info __initdata = {
 				  IDE_HFLAG_NO_DMA |
 				  IDE_HFLAG_ABUSE_PREFETCH |
 				  IDE_HFLAG_ABUSE_FAST_DEVSEL,
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 	.port_ops		= &cmd640_port_ops,
 	.pio_mask		= ATA_PIO5,
-#endif
 };
 
 static int cmd640x_init_one(unsigned long base, unsigned long ctl)
@@ -683,12 +714,8 @@ static int cmd640x_init_one(unsigned long base, unsigned long ctl)
  */
 static int __init cmd640x_init(void)
 {
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-	int second_port_toggled = 0;
-#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 	int second_port_cmd640 = 0, rc;
 	const char *bus_type, *port2;
-	unsigned int index;
 	u8 b, cfr;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw[2];
@@ -774,88 +801,44 @@ static int __init cmd640x_init(void)
 	put_cmd640_reg(CMDTIM, 0);
 	put_cmd640_reg(BRST, 0x40);
 
-	cmd_hwif1 = ide_find_port();
+	b = get_cmd640_reg(CNTRL);
 
 	/*
 	 * Try to enable the secondary interface, if not already enabled
 	 */
-	if (cmd_hwif1 &&
-	    cmd_hwif1->drives[0].noprobe && cmd_hwif1->drives[1].noprobe) {
-		port2 = "not probed";
+	if (secondary_port_responding()) {
+		if ((b & CNTRL_ENA_2ND)) {
+			second_port_cmd640 = 1;
+			port2 = "okay";
+		} else if (cmd640_vlb) {
+			second_port_cmd640 = 1;
+			port2 = "alive";
+		} else
+			port2 = "not cmd640";
 	} else {
-		b = get_cmd640_reg(CNTRL);
+		put_cmd640_reg(CNTRL, b ^ CNTRL_ENA_2ND); /* toggle the bit */
 		if (secondary_port_responding()) {
-			if ((b & CNTRL_ENA_2ND)) {
-				second_port_cmd640 = 1;
-				port2 = "okay";
-			} else if (cmd640_vlb) {
-				second_port_cmd640 = 1;
-				port2 = "alive";
-			} else
-				port2 = "not cmd640";
+			second_port_cmd640 = 1;
+			port2 = "enabled";
 		} else {
-			put_cmd640_reg(CNTRL, b ^ CNTRL_ENA_2ND); /* toggle the bit */
-			if (secondary_port_responding()) {
-				second_port_cmd640 = 1;
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-				second_port_toggled = 1;
-#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
-				port2 = "enabled";
-			} else {
-				put_cmd640_reg(CNTRL, b); /* restore original setting */
-				port2 = "not responding";
-			}
+			put_cmd640_reg(CNTRL, b); /* restore original setting */
+			port2 = "not responding";
 		}
 	}
 
 	/*
 	 * Initialize data for secondary cmd640 port, if enabled
 	 */
-	if (second_port_cmd640 && cmd_hwif1) {
-		ide_init_port_hw(cmd_hwif1, &hw[1]);
-		idx[1] = cmd_hwif1->index;
+	if (second_port_cmd640) {
+		cmd_hwif1 = ide_find_port();
+		if (cmd_hwif1) {
+			ide_init_port_hw(cmd_hwif1, &hw[1]);
+			idx[1] = cmd_hwif1->index;
+		}
 	}
 	printk(KERN_INFO "cmd640: %sserialized, secondary interface %s\n",
 			 second_port_cmd640 ? "" : "not ", port2);
 
-	/*
-	 * Establish initial timings/prefetch for all drives.
-	 * Do not unnecessarily disturb any prior BIOS setup of these.
-	 */
-	for (index = 0; index < (2 + (second_port_cmd640 << 1)); index++) {
-		ide_drive_t *drive;
-
-		if (index > 1) {
-			if (cmd_hwif1 == NULL)
-				continue;
-			drive = &cmd_hwif1->drives[index & 1];
-		} else  {
-			if (cmd_hwif0 == NULL)
-				continue;
-			drive = &cmd_hwif0->drives[index & 1];
-		}
-
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-		/*
-		 * Reset timing to the slowest speed and turn off prefetch.
-		 * This way, the drive identify code has a better chance.
-		 */
-		setup_counts    [index] = 4;	/* max possible */
-		active_counts   [index] = 16;	/* max possible */
-		recovery_counts [index] = 16;	/* max possible */
-		program_drive_counts(drive, index);
-		set_prefetch_mode(drive, index, 0);
-		printk("cmd640: drive%d timings/prefetch cleared\n", index);
-#else
-		/*
-		 * Set the drive unmask flags to match the prefetch setting
-		 */
-		check_prefetch(drive, index);
-		printk("cmd640: drive%d timings/prefetch(%s) preserved\n",
-			index, drive->no_io_32bit ? "off" : "on");
-#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
-	}
-
 #ifdef CMD640_DUMP_REGS
 	cmd640_dump_regs();
 #endif
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index ca4774a..cfa784b 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -116,6 +116,7 @@ static void cmd64x_tune_pio(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	struct ide_timing *t	= ide_timing_find_mode(XFER_PIO_0 + pio);
 	unsigned int cycle_time;
 	u8 setup_count, arttim = 0;
 
@@ -124,10 +125,9 @@ static void cmd64x_tune_pio(ide_drive_t *drive, const u8 pio)
 
 	cycle_time = ide_pio_cycle_time(drive, pio);
 
-	program_cycle_times(drive, cycle_time,
-			    ide_pio_timings[pio].active_time);
+	program_cycle_times(drive, cycle_time, t->active);
 
-	setup_count = quantize_timing(ide_pio_timings[pio].setup_time,
+	setup_count = quantize_timing(t->setup,
 			1000 / (ide_pci_clk ? ide_pci_clk : 33));
 
 	/*
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index 99fe91a..dc97c48 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -26,8 +26,6 @@
 #include <linux/pci.h>
 #include <linux/ide.h>
 
-#include "ide-timing.h"
-
 #define MSR_ATAC_BASE		0x51300000
 #define ATAC_GLD_MSR_CAP	(MSR_ATAC_BASE+0)
 #define ATAC_GLD_MSR_CONFIG	(MSR_ATAC_BASE+0x01)
@@ -75,13 +73,11 @@ static unsigned int cs5535_udma_timings[5] =
  */
 static void cs5535_set_speed(ide_drive_t *drive, const u8 speed)
 {
-
 	u32 reg = 0, dummy;
 	int unit = drive->select.b.unit;
 
-
 	/* Set the PIO timings */
-	if ((speed & XFER_MODE) == XFER_PIO) {
+	if (speed < XFER_SW_DMA_0) {
 		ide_drive_t *pair = ide_get_paired_drive(drive);
 		u8 cmd, pioa;
 
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index 8c534af..e14ad55 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -133,6 +133,7 @@ static int calc_clk(int time, int bus_speed)
  */
 static void compute_clocks(u8 pio, pio_clocks_t *p_pclk)
 {
+	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 	int clk1, clk2;
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 
@@ -141,15 +142,13 @@ static void compute_clocks(u8 pio, pio_clocks_t *p_pclk)
 	 */
 
 	/* let's calc the address setup time clocks */
-	p_pclk->address_time = (u8)calc_clk(ide_pio_timings[pio].setup_time, bus_speed);
+	p_pclk->address_time = (u8)calc_clk(t->setup, bus_speed);
 
 	/* let's calc the active and recovery time clocks */
-	clk1 = calc_clk(ide_pio_timings[pio].active_time, bus_speed);
+	clk1 = calc_clk(t->active, bus_speed);
 
 	/* calc recovery timing */
-	clk2 =	ide_pio_timings[pio].cycle_time -
-		ide_pio_timings[pio].active_time -
-		ide_pio_timings[pio].setup_time;
+	clk2 = t->cycle - t->active - t->setup;
 
 	clk2 = calc_clk(clk2, bus_speed);
 
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index af0f300..0106e2a 100644
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -93,7 +93,6 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 
 	i = hwif->index;
 
-	ide_init_port_data(hwif, i);
 	ide_init_port_hw(hwif, &hw);
 
 	idx[0] = i;
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 6ab0411..cbf6472 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -512,8 +512,14 @@ static void __devinit it821x_quirkproc(ide_drive_t *drive)
 }
 
 static struct ide_dma_ops it821x_pass_through_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= it821x_dma_start,
 	.dma_end		= it821x_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_timeout		= ide_dma_timeout,
+	.dma_lost_irq		= ide_dma_lost_irq,
 };
 
 /**
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 1584ebb..789c66d 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -558,12 +558,9 @@ static int scc_ide_setup_pci_device(struct pci_dev *dev,
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	int i;
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		printk(KERN_ERR "%s: too many IDE interfaces, "
-				"no room in table\n", SCC_PATA_NAME);
+	hwif = ide_find_port_slot(d);
+	if (hwif == NULL)
 		return -ENOMEM;
-	}
 
 	memset(&hw, 0, sizeof(hw));
 	for (i = 0; i <= 8; i++)
@@ -572,7 +569,6 @@ static int scc_ide_setup_pci_device(struct pci_dev *dev,
 	hw.dev = &dev->dev;
 	hw.chipset = ide_pci;
 	ide_init_port_hw(hwif, &hw);
-	hwif->dev = &dev->dev;
 
 	idx[0] = hwif->index;
 
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 24513e3..c79ff5b 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -568,6 +568,7 @@ static const struct ide_dma_ops sgiioc4_dma_ops = {
 };
 
 static const struct ide_port_info sgiioc4_port_info __devinitdata = {
+	.name			= DRV_NAME,
 	.chipset		= ide_pci,
 	.init_dma		= ide_dma_sgiioc4,
 	.port_ops		= &sgiioc4_port_ops,
@@ -587,13 +588,6 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	hw_regs_t hw;
 	struct ide_port_info d = sgiioc4_port_info;
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		printk(KERN_ERR "%s: too many IDE interfaces, no room in table\n",
-				DRV_NAME);
-		return -ENOMEM;
-	}
-
 	/*  Get the CmdBlk and CtrlBlk Base Registers */
 	bar0 = pci_resource_start(dev, 0);
 	virt_base = ioremap(bar0, pci_resource_len(dev, 0));
@@ -608,11 +602,11 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 
 	cmd_phys_base = bar0 + IOC4_CMD_OFFSET;
 	if (!request_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE,
-	    hwif->name)) {
+	    DRV_NAME)) {
 		printk(KERN_ERR
 			"%s : %s -- ERROR, Addresses "
 			"0x%p to 0x%p ALREADY in use\n",
-		       __func__, hwif->name, (void *) cmd_phys_base,
+		       __func__, DRV_NAME, (void *) cmd_phys_base,
 		       (void *) cmd_phys_base + IOC4_CMD_CTL_BLK_SIZE);
 		return -ENOMEM;
 	}
@@ -623,9 +617,12 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	hw.irq = dev->irq;
 	hw.chipset = ide_pci;
 	hw.dev = &dev->dev;
-	ide_init_port_hw(hwif, &hw);
 
-	hwif->dev = &dev->dev;
+	hwif = ide_find_port_slot(&d);
+	if (hwif == NULL)
+		goto err;
+
+	ide_init_port_hw(hwif, &hw);
 
 	/* The IOC4 uses MMIO rather than Port IO. */
 	default_hwif_mmiops(hwif);
@@ -641,6 +638,10 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 		return -EIO;
 
 	return 0;
+err:
+	release_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE);
+	iounmap(virt_base);
+	return -ENOMEM;
 }
 
 static unsigned int __devinit
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index b75e9bb..6e9d765 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -421,8 +421,7 @@ static int sil_sata_reset_poll(ide_drive_t *drive)
 		if ((sata_stat & 0x03) != 0x03) {
 			printk(KERN_WARNING "%s: reset phy dead, status=0x%08x\n",
 					    hwif->name, sata_stat);
-			HWGROUP(drive)->polling = 0;
-			return ide_started;
+			return -ENXIO;
 		}
 	}
 
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index e127eb2..2389945 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -52,8 +52,6 @@
 #include <linux/init.h>
 #include <linux/ide.h>
 
-#include "ide-timing.h"
-
 /* registers layout and init values are chipset family dependant */
 
 #define ATA_16		0x01
@@ -616,7 +614,6 @@ MODULE_LICENSE("GPL");
 /*
  * TODO:
  *	- CLEANUP
- *	- Use drivers/ide/ide-timing.h !
  *	- More checks in the config registers (force values instead of
  *	  relying on the BIOS setting them correctly).
  *	- Further optimisations ?
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index ce84fa0..6efbde2 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -47,10 +47,11 @@
  */
 static unsigned int get_pio_timings(ide_drive_t *drive, u8 pio)
 {
+	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 	unsigned int cmd_on, cmd_off;
 	u8 iordy = 0;
 
-	cmd_on  = (ide_pio_timings[pio].active_time + 29) / 30;
+	cmd_on  = (t->active + 29) / 30;
 	cmd_off = (ide_pio_cycle_time(drive, pio) - 30 * cmd_on + 29) / 30;
 
 	if (cmd_on == 0)
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index 3ed9728..e47384c 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -35,8 +35,6 @@
 #include <asm/processor.h>
 #endif
 
-#include "ide-timing.h"
-
 #define VIA_IDE_ENABLE		0x40
 #define VIA_IDE_CONFIG		0x41
 #define VIA_FIFO_CONFIG		0x43
diff --git a/drivers/ide/ppc/Makefile b/drivers/ide/ppc/Makefile
index 65af584..74e52ad 100644
--- a/drivers/ide/ppc/Makefile
+++ b/drivers/ide/ppc/Makefile
@@ -1,3 +1,2 @@
 
 obj-$(CONFIG_BLK_DEV_IDE_PMAC)		+= pmac.o
-obj-$(CONFIG_BLK_DEV_MPC8xx_IDE)	+= mpc8xx.o
diff --git a/drivers/ide/ppc/mpc8xx.c b/drivers/ide/ppc/mpc8xx.c
deleted file mode 100644
index 236f9c3..0000000
--- a/drivers/ide/ppc/mpc8xx.c
+++ /dev/null
@@ -1,851 +0,0 @@
-/*
- *  Copyright (C) 2000, 2001 Wolfgang Denk, wd@denx.de
- *  Modified for direct IDE interface
- *	by Thomas Lange, thomas@corelatus.com
- *  Modified for direct IDE interface on 8xx without using the PCMCIA
- *  controller
- *	by Steven.Scholz@imc-berlin.de
- *  Moved out of arch/ppc/kernel/m8xx_setup.c, other minor cleanups
- *	by Mathew Locke <mattl@mvista.com>
- */
-
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/stddef.h>
-#include <linux/unistd.h>
-#include <linux/ptrace.h>
-#include <linux/slab.h>
-#include <linux/user.h>
-#include <linux/tty.h>
-#include <linux/major.h>
-#include <linux/interrupt.h>
-#include <linux/reboot.h>
-#include <linux/init.h>
-#include <linux/ioport.h>
-#include <linux/ide.h>
-#include <linux/bootmem.h>
-
-#include <asm/mpc8xx.h>
-#include <asm/mmu.h>
-#include <asm/processor.h>
-#include <asm/io.h>
-#include <asm/pgtable.h>
-#include <asm/ide.h>
-#include <asm/8xx_immap.h>
-#include <asm/machdep.h>
-#include <asm/irq.h>
-
-#define DRV_NAME "ide-mpc8xx"
-
-static int identify  (volatile u8 *p);
-static void print_fixed (volatile u8 *p);
-static void print_funcid (int func);
-static int check_ide_device (unsigned long base);
-
-static void ide_interrupt_ack (void *dev);
-static void m8xx_ide_set_pio_mode(ide_drive_t *drive, const u8 pio);
-
-typedef	struct ide_ioport_desc {
-	unsigned long	base_off;		/* Offset to PCMCIA memory	*/
-	unsigned long	reg_off[IDE_NR_PORTS];	/* controller register offsets	*/
-	int		irq;			/* IRQ				*/
-} ide_ioport_desc_t;
-
-ide_ioport_desc_t ioport_dsc[MAX_HWIFS] = {
-#ifdef IDE0_BASE_OFFSET
-	{ IDE0_BASE_OFFSET,
-	    {
-		IDE0_DATA_REG_OFFSET,
-		IDE0_ERROR_REG_OFFSET,
-		IDE0_NSECTOR_REG_OFFSET,
-		IDE0_SECTOR_REG_OFFSET,
-		IDE0_LCYL_REG_OFFSET,
-		IDE0_HCYL_REG_OFFSET,
-		IDE0_SELECT_REG_OFFSET,
-		IDE0_STATUS_REG_OFFSET,
-		IDE0_CONTROL_REG_OFFSET,
-		IDE0_IRQ_REG_OFFSET,
-	    },
-	    IDE0_INTERRUPT,
-	},
-#ifdef IDE1_BASE_OFFSET
-	{ IDE1_BASE_OFFSET,
-	    {
-		IDE1_DATA_REG_OFFSET,
-		IDE1_ERROR_REG_OFFSET,
-		IDE1_NSECTOR_REG_OFFSET,
-		IDE1_SECTOR_REG_OFFSET,
-		IDE1_LCYL_REG_OFFSET,
-		IDE1_HCYL_REG_OFFSET,
-		IDE1_SELECT_REG_OFFSET,
-		IDE1_STATUS_REG_OFFSET,
-		IDE1_CONTROL_REG_OFFSET,
-		IDE1_IRQ_REG_OFFSET,
-	    },
-	    IDE1_INTERRUPT,
-	},
-#endif /* IDE1_BASE_OFFSET */
-#endif	/* IDE0_BASE_OFFSET */
-};
-
-ide_pio_timings_t ide_pio_clocks[6];
-int hold_time[6] =  {30, 20, 15, 10, 10, 10 };   /* PIO Mode 5 with IORDY (nonstandard) */
-
-/*
- * Warning: only 1 (ONE) PCMCIA slot supported here,
- * which must be correctly initialized by the firmware (PPCBoot).
- */
-static int _slot_ = -1;			/* will be read from PCMCIA registers   */
-
-/* Make clock cycles and always round up */
-#define PCMCIA_MK_CLKS( t, T ) (( (t) * ((T)/1000000) + 999U ) / 1000U )
-
-#define M8XX_PCMCIA_CD2(slot)      (0x10000000 >> (slot << 4))
-#define M8XX_PCMCIA_CD1(slot)      (0x08000000 >> (slot << 4))
-
-/*
- * The TQM850L hardware has two pins swapped! Grrrrgh!
- */
-#ifdef	CONFIG_TQM850L
-#define __MY_PCMCIA_GCRX_CXRESET	PCMCIA_GCRX_CXOE
-#define __MY_PCMCIA_GCRX_CXOE		PCMCIA_GCRX_CXRESET
-#else
-#define __MY_PCMCIA_GCRX_CXRESET	PCMCIA_GCRX_CXRESET
-#define __MY_PCMCIA_GCRX_CXOE		PCMCIA_GCRX_CXOE
-#endif
-
-#if defined(CONFIG_BLK_DEV_MPC8xx_IDE) && defined(CONFIG_IDE_8xx_PCCARD)
-#define PCMCIA_SCHLVL IDE0_INTERRUPT	/* Status Change Interrupt Level	*/
-static int pcmcia_schlvl = PCMCIA_SCHLVL;
-#endif
-
-/*
- * See include/linux/ide.h for definition of hw_regs_t (p, base)
- */
-
-/*
- * m8xx_ide_init_ports() for a direct IDE interface _using_
- * MPC8xx's internal PCMCIA interface
- */
-#if defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_DIRECT)
-static int __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
-{
-	unsigned long *p = hw->io_ports_array;
-	int i;
-
-	typedef struct {
-		ulong br;
-		ulong or;
-	} pcmcia_win_t;
-	volatile pcmcia_win_t *win;
-	volatile pcmconf8xx_t *pcmp;
-
-	uint *pgcrx;
-	u32 pcmcia_phy_base;
-	u32 pcmcia_phy_end;
-	static unsigned long pcmcia_base = 0;
-	unsigned long base;
-
-	*p = 0;
-
-	pcmp = (pcmconf8xx_t *)(&(((immap_t *)IMAP_ADDR)->im_pcmcia));
-
-	if (!pcmcia_base) {
-                /*
-                 * Read out PCMCIA registers. Since the reset values
-                 * are undefined, we sure hope that they have been
-                 * set up by firmware
-		 */
-
-		/* Scan all registers for valid settings */
-		pcmcia_phy_base = 0xFFFFFFFF;
-		pcmcia_phy_end = 0;
-		/* br0 is start of brX and orX regs */
-		win = (pcmcia_win_t *) \
-			(&(((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pbr0));
-		for (i = 0; i < 8; i++) {
-			if (win->or & 1) {	/* This bank is marked as valid */
-				if (win->br < pcmcia_phy_base) {
-					pcmcia_phy_base = win->br;
-				}
-				if ((win->br + PCMCIA_MEM_SIZE) > pcmcia_phy_end) {
-					pcmcia_phy_end  = win->br + PCMCIA_MEM_SIZE;
-				}
-				/* Check which slot that has been defined */
-				_slot_ = (win->or >> 2) & 1;
-
-			}					/* Valid bank */
-			win++;
-		}						/* for */
-
-		printk ("PCMCIA slot %c: phys mem %08x...%08x (size %08x)\n",
-			'A' + _slot_,
-			pcmcia_phy_base, pcmcia_phy_end,
-			pcmcia_phy_end - pcmcia_phy_base);
-
-		if (!request_mem_region(pcmcia_phy_base,
-					pcmcia_phy_end - pcmcia_phy_base,
-					DRV_NAME)) {
-			printk(KERN_ERR "%s: resources busy\n", DRV_NAME);
-			return -EBUSY;
-		}
-
-		pcmcia_base=(unsigned long)ioremap(pcmcia_phy_base,
-						   pcmcia_phy_end-pcmcia_phy_base);
-
-#ifdef DEBUG
-		printk ("PCMCIA virt base: %08lx\n", pcmcia_base);
-#endif
-		/* Compute clock cycles for PIO timings */
-		for (i=0; i<6; ++i) {
-			bd_t	*binfo = (bd_t *)__res;
-
-			hold_time[i]   =
-				PCMCIA_MK_CLKS (hold_time[i],
-						binfo->bi_busfreq);
-			ide_pio_clocks[i].setup_time  =
-				PCMCIA_MK_CLKS (ide_pio_timings[i].setup_time,
-						binfo->bi_busfreq);
-			ide_pio_clocks[i].active_time =
-				PCMCIA_MK_CLKS (ide_pio_timings[i].active_time,
-						binfo->bi_busfreq);
-			ide_pio_clocks[i].cycle_time  =
-				PCMCIA_MK_CLKS (ide_pio_timings[i].cycle_time,
-						binfo->bi_busfreq);
-#if 0
-			printk ("PIO mode %d timings: %d/%d/%d => %d/%d/%d\n",
-				i,
-				ide_pio_clocks[i].setup_time,
-				ide_pio_clocks[i].active_time,
-				ide_pio_clocks[i].hold_time,
-				ide_pio_clocks[i].cycle_time,
-				ide_pio_timings[i].setup_time,
-				ide_pio_timings[i].active_time,
-				ide_pio_timings[i].hold_time,
-				ide_pio_timings[i].cycle_time);
-#endif
-		}
-	}
-
-	if (_slot_ == -1) {
-		printk ("PCMCIA slot has not been defined! Using A as default\n");
-		_slot_ = 0;
-	}
-
-#ifdef CONFIG_IDE_8xx_PCCARD
-
-#ifdef DEBUG
-	printk ("PIPR = 0x%08X  slot %c ==> mask = 0x%X\n",
-		pcmp->pcmc_pipr,
-		'A' + _slot_,
-		M8XX_PCMCIA_CD1(_slot_) | M8XX_PCMCIA_CD2(_slot_) );
-#endif /* DEBUG */
-
-	if (pcmp->pcmc_pipr & (M8XX_PCMCIA_CD1(_slot_)|M8XX_PCMCIA_CD2(_slot_))) {
-		printk ("No card in slot %c: PIPR=%08x\n",
-			'A' + _slot_, (u32) pcmp->pcmc_pipr);
-		return -ENODEV;		/* No card in slot */
-	}
-
-	check_ide_device (pcmcia_base);
-
-#endif	/* CONFIG_IDE_8xx_PCCARD */
-
-	base = pcmcia_base + ioport_dsc[data_port].base_off;
-#ifdef DEBUG
-	printk ("base: %08x + %08x = %08x\n",
-			pcmcia_base, ioport_dsc[data_port].base_off, base);
-#endif
-
-	for (i = 0; i < IDE_NR_PORTS; ++i) {
-#ifdef DEBUG
-		printk ("port[%d]: %08x + %08x = %08x\n",
-			i,
-			base,
-			ioport_dsc[data_port].reg_off[i],
-			i, base + ioport_dsc[data_port].reg_off[i]);
-#endif
-	 	*p++ = base + ioport_dsc[data_port].reg_off[i];
-	}
-
-	hw->irq = ioport_dsc[data_port].irq;
-	hw->ack_intr = (ide_ack_intr_t *)ide_interrupt_ack;
-
-#ifdef CONFIG_IDE_8xx_PCCARD
-	{
-		unsigned int reg;
-
-		if (_slot_)
-			pgcrx = &((immap_t *) IMAP_ADDR)->im_pcmcia.pcmc_pgcrb;
-		else
-			pgcrx = &((immap_t *) IMAP_ADDR)->im_pcmcia.pcmc_pgcra;
-
-		reg = *pgcrx;
-		reg |= mk_int_int_mask (pcmcia_schlvl) << 24;
-		reg |= mk_int_int_mask (pcmcia_schlvl) << 16;
-		*pgcrx = reg;
-	}
-#endif	/* CONFIG_IDE_8xx_PCCARD */
-
-	/* Enable Harddisk Interrupt,
-	 * and make it edge sensitive
-	 */
-	/* (11-18) Set edge detect for irq, no wakeup from low power mode */
-	((immap_t *)IMAP_ADDR)->im_siu_conf.sc_siel |=
-					(0x80000000 >> ioport_dsc[data_port].irq);
-
-#ifdef CONFIG_IDE_8xx_PCCARD
-	/* Make sure we don't get garbage irq */
-	((immap_t *) IMAP_ADDR)->im_pcmcia.pcmc_pscr = 0xFFFF;
-
-	/* Enable falling edge irq */
-	pcmp->pcmc_per = 0x100000 >> (16 * _slot_);
-#endif	/* CONFIG_IDE_8xx_PCCARD */
-
-	hw->chipset = ide_generic;
-
-	return 0;
-}
-#endif /* CONFIG_IDE_8xx_PCCARD || CONFIG_IDE_8xx_DIRECT */
-
-/*
- * m8xx_ide_init_ports() for a direct IDE interface _not_ using
- * MPC8xx's internal PCMCIA interface
- */
-#if defined(CONFIG_IDE_EXT_DIRECT)
-static int __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
-{
-	unsigned long *p = hw->io_ports_array;
-	int i;
-
-	u32 ide_phy_base;
-	u32 ide_phy_end;
-	static unsigned long ide_base = 0;
-	unsigned long base;
-
-	*p = 0;
-
-	if (!ide_base) {
-
-		/* TODO:
-		 * - add code to read ORx, BRx
-		 */
-		ide_phy_base = CFG_ATA_BASE_ADDR;
-		ide_phy_end  = CFG_ATA_BASE_ADDR + 0x200;
-
-		printk ("IDE phys mem : %08x...%08x (size %08x)\n",
-			ide_phy_base, ide_phy_end,
-			ide_phy_end - ide_phy_base);
-
-		if (!request_mem_region(ide_phy_base, 0x200, DRV_NAME)) {
-			printk(KERN_ERR "%s: resources busy\n", DRV_NAME);
-			return -EBUSY;
-		}
-
-		ide_base=(unsigned long)ioremap(ide_phy_base,
-						ide_phy_end-ide_phy_base);
-
-#ifdef DEBUG
-		printk ("IDE virt base: %08lx\n", ide_base);
-#endif
-	}
-
-	base = ide_base + ioport_dsc[data_port].base_off;
-#ifdef DEBUG
-	printk ("base: %08x + %08x = %08x\n",
-		ide_base, ioport_dsc[data_port].base_off, base);
-#endif
-
-	for (i = 0; i < IDE_NR_PORTS; ++i) {
-#ifdef DEBUG
-		printk ("port[%d]: %08x + %08x = %08x\n",
-			i,
-			base,
-			ioport_dsc[data_port].reg_off[i],
-			i, base + ioport_dsc[data_port].reg_off[i]);
-#endif
-	 	*p++ = base + ioport_dsc[data_port].reg_off[i];
-	}
-
-	/* direct connected IDE drive, i.e. external IRQ */
-	hw->irq = ioport_dsc[data_port].irq;
-	hw->ack_intr = (ide_ack_intr_t *)ide_interrupt_ack;
-
-	/* Enable Harddisk Interrupt,
-	 * and make it edge sensitive
-	 */
-	/* (11-18) Set edge detect for irq, no wakeup from low power mode */
-	((immap_t *) IMAP_ADDR)->im_siu_conf.sc_siel |=
-			(0x80000000 >> ioport_dsc[data_port].irq);
-
-	hw->chipset = ide_generic;
-
-	return 0;
-}
-#endif	/* CONFIG_IDE_8xx_DIRECT */
-
-
-/* -------------------------------------------------------------------- */
-
-
-/* PCMCIA Timing */
-#ifndef	PCMCIA_SHT
-#define PCMCIA_SHT(t)	((t & 0x0F)<<16)	/* Strobe Hold  Time 	*/
-#define PCMCIA_SST(t)	((t & 0x0F)<<12)	/* Strobe Setup Time	*/
-#define PCMCIA_SL(t) ((t==32) ? 0 : ((t & 0x1F)<<7)) /* Strobe Length	*/
-#endif
-
-/* Calculate PIO timings */
-static void m8xx_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
-{
-#if defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_DIRECT)
-	volatile pcmconf8xx_t	*pcmp;
-	ulong timing, mask, reg;
-
-	pcmp = (pcmconf8xx_t *)(&(((immap_t *)IMAP_ADDR)->im_pcmcia));
-
-	mask = ~(PCMCIA_SHT(0xFF) | PCMCIA_SST(0xFF) | PCMCIA_SL(0xFF));
-
-	timing  = PCMCIA_SHT(hold_time[pio]  )
-		| PCMCIA_SST(ide_pio_clocks[pio].setup_time )
-		| PCMCIA_SL (ide_pio_clocks[pio].active_time)
-		;
-
-#if 1
-	printk ("Setting timing bits 0x%08lx in PCMCIA controller\n", timing);
-#endif
-	if ((reg = pcmp->pcmc_por0 & mask) != 0)
-		pcmp->pcmc_por0 = reg | timing;
-
-	if ((reg = pcmp->pcmc_por1 & mask) != 0)
-		pcmp->pcmc_por1 = reg | timing;
-
-	if ((reg = pcmp->pcmc_por2 & mask) != 0)
-		pcmp->pcmc_por2 = reg | timing;
-
-	if ((reg = pcmp->pcmc_por3 & mask) != 0)
-		pcmp->pcmc_por3 = reg | timing;
-
-	if ((reg = pcmp->pcmc_por4 & mask) != 0)
-		pcmp->pcmc_por4 = reg | timing;
-
-	if ((reg = pcmp->pcmc_por5 & mask) != 0)
-		pcmp->pcmc_por5 = reg | timing;
-
-	if ((reg = pcmp->pcmc_por6 & mask) != 0)
-		pcmp->pcmc_por6 = reg | timing;
-
-	if ((reg = pcmp->pcmc_por7 & mask) != 0)
-		pcmp->pcmc_por7 = reg | timing;
-
-#elif defined(CONFIG_IDE_EXT_DIRECT)
-
-	printk("%s[%d] %s: not implemented yet!\n",
-		__FILE__, __LINE__, __func__);
-#endif /* defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_PCMCIA */
-}
-
-static const struct ide_port_ops m8xx_port_ops = {
-	.set_pio_mode		= m8xx_ide_set_pio_mode,
-};
-
-static void
-ide_interrupt_ack (void *dev)
-{
-#ifdef CONFIG_IDE_8xx_PCCARD
-	u_int pscr, pipr;
-
-#if (PCMCIA_SOCKETS_NO == 2)
-	u_int _slot_;
-#endif
-
-	/* get interrupt sources */
-
-	pscr = ((volatile immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pscr;
-	pipr = ((volatile immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pipr;
-
-	/*
-	 * report only if both card detect signals are the same
-	 * not too nice done,
-	 * we depend on that CD2 is the bit to the left of CD1...
-	 */
-
-	if(_slot_==-1){
-	  printk("PCMCIA slot has not been defined! Using A as default\n");
-	  _slot_=0;
-	}
-
-	if(((pipr & M8XX_PCMCIA_CD2(_slot_)) >> 1) ^
-	   (pipr & M8XX_PCMCIA_CD1(_slot_))         ) {
-	  printk ("card detect interrupt\n");
-	}
-	/* clear the interrupt sources */
-	((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pscr = pscr;
-
-#else /* ! CONFIG_IDE_8xx_PCCARD */
-	/*
-	 * Only CONFIG_IDE_8xx_PCCARD is using the interrupt of the
-	 * MPC8xx's PCMCIA controller, so there is nothing to be done here
-	 * for CONFIG_IDE_8xx_DIRECT and CONFIG_IDE_EXT_DIRECT.
-	 * The interrupt is handled somewhere else.	-- Steven
-	 */
-#endif /* CONFIG_IDE_8xx_PCCARD */
-}
-
-
-
-/*
- * CIS Tupel codes
- */
-#define CISTPL_NULL		0x00
-#define CISTPL_DEVICE		0x01
-#define CISTPL_LONGLINK_CB	0x02
-#define CISTPL_INDIRECT		0x03
-#define CISTPL_CONFIG_CB	0x04
-#define CISTPL_CFTABLE_ENTRY_CB 0x05
-#define CISTPL_LONGLINK_MFC	0x06
-#define CISTPL_BAR		0x07
-#define CISTPL_PWR_MGMNT	0x08
-#define CISTPL_EXTDEVICE	0x09
-#define CISTPL_CHECKSUM		0x10
-#define CISTPL_LONGLINK_A	0x11
-#define CISTPL_LONGLINK_C	0x12
-#define CISTPL_LINKTARGET	0x13
-#define CISTPL_NO_LINK		0x14
-#define CISTPL_VERS_1		0x15
-#define CISTPL_ALTSTR		0x16
-#define CISTPL_DEVICE_A		0x17
-#define CISTPL_JEDEC_C		0x18
-#define CISTPL_JEDEC_A		0x19
-#define CISTPL_CONFIG		0x1a
-#define CISTPL_CFTABLE_ENTRY	0x1b
-#define CISTPL_DEVICE_OC	0x1c
-#define CISTPL_DEVICE_OA	0x1d
-#define CISTPL_DEVICE_GEO	0x1e
-#define CISTPL_DEVICE_GEO_A	0x1f
-#define CISTPL_MANFID		0x20
-#define CISTPL_FUNCID		0x21
-#define CISTPL_FUNCE		0x22
-#define CISTPL_SWIL		0x23
-#define CISTPL_END		0xff
-
-/*
- * CIS Function ID codes
- */
-#define CISTPL_FUNCID_MULTI	0x00
-#define CISTPL_FUNCID_MEMORY	0x01
-#define CISTPL_FUNCID_SERIAL	0x02
-#define CISTPL_FUNCID_PARALLEL	0x03
-#define CISTPL_FUNCID_FIXED	0x04
-#define CISTPL_FUNCID_VIDEO	0x05
-#define CISTPL_FUNCID_NETWORK	0x06
-#define CISTPL_FUNCID_AIMS	0x07
-#define CISTPL_FUNCID_SCSI	0x08
-
-/*
- * Fixed Disk FUNCE codes
- */
-#define CISTPL_IDE_INTERFACE	0x01
-
-#define CISTPL_FUNCE_IDE_IFACE	0x01
-#define CISTPL_FUNCE_IDE_MASTER	0x02
-#define CISTPL_FUNCE_IDE_SLAVE	0x03
-
-/* First feature byte */
-#define CISTPL_IDE_SILICON	0x04
-#define CISTPL_IDE_UNIQUE	0x08
-#define CISTPL_IDE_DUAL		0x10
-
-/* Second feature byte */
-#define CISTPL_IDE_HAS_SLEEP	0x01
-#define CISTPL_IDE_HAS_STANDBY	0x02
-#define CISTPL_IDE_HAS_IDLE	0x04
-#define CISTPL_IDE_LOW_POWER	0x08
-#define CISTPL_IDE_REG_INHIBIT	0x10
-#define CISTPL_IDE_HAS_INDEX	0x20
-#define CISTPL_IDE_IOIS16	0x40
-
-
-/* -------------------------------------------------------------------- */
-
-
-#define	MAX_TUPEL_SZ	512
-#define MAX_FEATURES	4
-
-static int check_ide_device (unsigned long base)
-{
-	volatile u8 *ident = NULL;
-	volatile u8 *feature_p[MAX_FEATURES];
-	volatile u8 *p, *start;
-	int n_features = 0;
-	u8 func_id = ~0;
-	u8 code, len;
-	unsigned short config_base = 0;
-	int found = 0;
-	int i;
-
-#ifdef DEBUG
-	printk ("PCMCIA MEM: %08lX\n", base);
-#endif
-	start = p = (volatile u8 *) base;
-
-	while ((p - start) < MAX_TUPEL_SZ) {
-
-		code = *p; p += 2;
-
-		if (code == 0xFF) { /* End of chain */
-			break;
-		}
-
-		len = *p; p += 2;
-#ifdef	DEBUG_PCMCIA
-		{ volatile u8 *q = p;
-			printk ("\nTuple code %02x  length %d\n\tData:",
-				code, len);
-
-			for (i = 0; i < len; ++i) {
-				printk (" %02x", *q);
-				q+= 2;
-			}
-		}
-#endif	/* DEBUG_PCMCIA */
-		switch (code) {
-		case CISTPL_VERS_1:
-			ident = p + 4;
-			break;
-		case CISTPL_FUNCID:
-			func_id = *p;
-			break;
-		case CISTPL_FUNCE:
-			if (n_features < MAX_FEATURES)
-				feature_p[n_features++] = p;
-			break;
-		case CISTPL_CONFIG:
-			config_base = (*(p+6) << 8) + (*(p+4));
-		default:
-			break;
-		}
-		p += 2 * len;
-	}
-
-	found = identify (ident);
-
-	if (func_id != ((u8)~0)) {
-		print_funcid (func_id);
-
-		if (func_id == CISTPL_FUNCID_FIXED)
-			found = 1;
-		else
-			return (1);	/* no disk drive */
-	}
-
-	for (i=0; i<n_features; ++i) {
-		print_fixed (feature_p[i]);
-	}
-
-	if (!found) {
-		printk ("unknown card type\n");
-		return (1);
-	}
-
-	/* set level mode irq and I/O mapped device in config reg*/
-	*((u8 *)(base + config_base)) = 0x41;
-
-	return (0);
-}
-
-/* ------------------------------------------------------------------------- */
-
-static void print_funcid (int func)
-{
-	switch (func) {
-	case CISTPL_FUNCID_MULTI:
-		printk (" Multi-Function");
-		break;
-	case CISTPL_FUNCID_MEMORY:
-		printk (" Memory");
-		break;
-	case CISTPL_FUNCID_SERIAL:
-		printk (" Serial Port");
-		break;
-	case CISTPL_FUNCID_PARALLEL:
-		printk (" Parallel Port");
-		break;
-	case CISTPL_FUNCID_FIXED:
-		printk (" Fixed Disk");
-		break;
-	case CISTPL_FUNCID_VIDEO:
-		printk (" Video Adapter");
-		break;
-	case CISTPL_FUNCID_NETWORK:
-		printk (" Network Adapter");
-		break;
-	case CISTPL_FUNCID_AIMS:
-		printk (" AIMS Card");
-		break;
-	case CISTPL_FUNCID_SCSI:
-		printk (" SCSI Adapter");
-		break;
-	default:
-		printk (" Unknown");
-		break;
-	}
-	printk (" Card\n");
-}
-
-/* ------------------------------------------------------------------------- */
-
-static void print_fixed (volatile u8 *p)
-{
-	if (p == NULL)
-		return;
-
-	switch (*p) {
-	case CISTPL_FUNCE_IDE_IFACE:
-	    {   u8 iface = *(p+2);
-
-		printk ((iface == CISTPL_IDE_INTERFACE) ? " IDE" : " unknown");
-		printk (" interface ");
-		break;
-	    }
-	case CISTPL_FUNCE_IDE_MASTER:
-	case CISTPL_FUNCE_IDE_SLAVE:
-	    {   u8 f1 = *(p+2);
-		u8 f2 = *(p+4);
-
-		printk ((f1 & CISTPL_IDE_SILICON) ? " [silicon]" : " [rotating]");
-
-		if (f1 & CISTPL_IDE_UNIQUE)
-			printk (" [unique]");
-
-		printk ((f1 & CISTPL_IDE_DUAL) ? " [dual]" : " [single]");
-
-		if (f2 & CISTPL_IDE_HAS_SLEEP)
-			printk (" [sleep]");
-
-		if (f2 & CISTPL_IDE_HAS_STANDBY)
-			printk (" [standby]");
-
-		if (f2 & CISTPL_IDE_HAS_IDLE)
-			printk (" [idle]");
-
-		if (f2 & CISTPL_IDE_LOW_POWER)
-			printk (" [low power]");
-
-		if (f2 & CISTPL_IDE_REG_INHIBIT)
-			printk (" [reg inhibit]");
-
-		if (f2 & CISTPL_IDE_HAS_INDEX)
-			printk (" [index]");
-
-		if (f2 & CISTPL_IDE_IOIS16)
-			printk (" [IOis16]");
-
-		break;
-	    }
-	}
-	printk ("\n");
-}
-
-/* ------------------------------------------------------------------------- */
-
-
-#define MAX_IDENT_CHARS		64
-#define	MAX_IDENT_FIELDS	4
-
-static u8 *known_cards[] = {
-	"ARGOSY PnPIDE D5",
-	NULL
-};
-
-static int identify  (volatile u8 *p)
-{
-	u8 id_str[MAX_IDENT_CHARS];
-	u8 data;
-	u8 *t;
-	u8 **card;
-	int i, done;
-
-	if (p == NULL)
-		return (0);	/* Don't know */
-
-	t = id_str;
-	done =0;
-
-	for (i=0; i<=4 && !done; ++i, p+=2) {
-		while ((data = *p) != '\0') {
-			if (data == 0xFF) {
-				done = 1;
-				break;
-			}
-			*t++ = data;
-			if (t == &id_str[MAX_IDENT_CHARS-1]) {
-				done = 1;
-				break;
-			}
-			p += 2;
-		}
-		if (!done)
-			*t++ = ' ';
-	}
-	*t = '\0';
-	while (--t > id_str) {
-		if (*t == ' ')
-			*t = '\0';
-		else
-			break;
-	}
-	printk ("Card ID: %s\n", id_str);
-
-	for (card=known_cards; *card; ++card) {
-		if (strcmp(*card, id_str) == 0) {	/* found! */
-			return (1);
-		}
-	}
-
-	return (0);	/* don't know */
-}
-
-static int __init mpc8xx_ide_probe(void)
-{
-	hw_regs_t hw;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-
-#ifdef IDE0_BASE_OFFSET
-	memset(&hw, 0, sizeof(hw));
-	if (!m8xx_ide_init_ports(&hw, 0)) {
-		ide_hwif_t *hwif = ide_find_port();
-
-		if (hwif) {
-			ide_init_port_hw(hwif, &hw);
-			hwif->pio_mask = ATA_PIO4;
-			hwif->port_ops = &m8xx_port_ops;
-
-			idx[0] = hwif->index;
-		}
-	}
-#ifdef IDE1_BASE_OFFSET
-	memset(&hw, 0, sizeof(hw));
-	if (!m8xx_ide_init_ports(&hw, 1)) {
-		ide_hwif_t *mate = ide_find_port();
-
-		if (mate) {
-			ide_init_port_hw(mate, &hw);
-			mate->pio_mask = ATA_PIO4;
-			mate->port_ops = &m8xx_port_ops;
-
-			idx[1] = mate->index;
-		}
-	}
-#endif
-#endif
-
-	ide_device_add(idx, NULL);
-
-	return 0;
-}
-
-module_init(mpc8xx_ide_probe);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index dcb2c46..93fb906 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -5,7 +5,7 @@
  * for doing DMA.
  *
  *  Copyright (C) 1998-2003 Paul Mackerras & Ben. Herrenschmidt
- *  Copyright (C)      2007 Bartlomiej Zolnierkiewicz
+ *  Copyright (C) 2007-2008 Bartlomiej Zolnierkiewicz
  *
  *  This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
@@ -48,8 +48,6 @@
 #include <asm/mediabay.h>
 #endif
 
-#include "../ide-timing.h"
-
 #undef IDE_PMAC_DEBUG
 
 #define DMA_WAIT_TIMEOUT	50
@@ -495,6 +493,7 @@ static void pmac_outbsync(ide_hwif_t *hwif, u8 value, unsigned long port)
 static void
 pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
+	struct ide_timing *tim = ide_timing_find_mode(XFER_PIO_0 + pio);
 	u32 *timings, t;
 	unsigned accessTicks, recTicks;
 	unsigned accessTime, recTime;
@@ -526,10 +525,9 @@ pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		}
 	case controller_kl_ata4:
 		/* 66Mhz cell */
-		recTime = cycle_time - ide_pio_timings[pio].active_time
-				- ide_pio_timings[pio].setup_time;
+		recTime = cycle_time - tim->active - tim->setup;
 		recTime = max(recTime, 150U);
-		accessTime = ide_pio_timings[pio].active_time;
+		accessTime = tim->active;
 		accessTime = max(accessTime, 150U);
 		accessTicks = SYSCLK_TICKS_66(accessTime);
 		accessTicks = min(accessTicks, 0x1fU);
@@ -542,10 +540,9 @@ pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	default: {
 		/* 33Mhz cell */
 		int ebit = 0;
-		recTime = cycle_time - ide_pio_timings[pio].active_time
-				- ide_pio_timings[pio].setup_time;
+		recTime = cycle_time - tim->active - tim->setup;
 		recTime = max(recTime, 150U);
-		accessTime = ide_pio_timings[pio].active_time;
+		accessTime = tim->active;
 		accessTime = max(accessTime, 150U);
 		accessTicks = SYSCLK_TICKS(accessTime);
 		accessTicks = min(accessTicks, 0x1fU);
@@ -1151,8 +1148,6 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	base = ioremap(macio_resource_start(mdev, 0), 0x400);
 	regbase = (unsigned long) base;
 
-	hwif->dev = &mdev->bus->pdev->dev;
-
 	pmif->mdev = mdev;
 	pmif->node = mdev->ofdev.node;
 	pmif->regbase = regbase;
@@ -1174,7 +1169,8 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	memset(&hw, 0, sizeof(hw));
 	pmac_ide_init_ports(&hw, pmif->regbase);
 	hw.irq = irq;
-	hw.dev = &mdev->ofdev.dev;
+	hw.dev = &mdev->bus->pdev->dev;
+	hw.parent = &mdev->ofdev.dev;
 
 	rc = pmac_ide_setup_device(pmif, hwif, &hw);
 	if (rc != 0) {
@@ -1274,7 +1270,6 @@ pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_free_pmif;
 	}
 
-	hwif->dev = &pdev->dev;
 	pmif->mdev = NULL;
 	pmif->node = np;
 
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index abcfb17..65fc08b 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -6,19 +6,15 @@
  *  May be copied or modified under the terms of the GNU General Public License
  */
 
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/init.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/ide.h>
 #include <linux/dma-mapping.h>
 
 #include <asm/io.h>
-#include <asm/irq.h>
 
 /**
  *	ide_setup_pci_baseregs	-	place a PCI IDE controller native
@@ -319,25 +315,22 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
 
 		ctl  = pci_resource_start(dev, 2*port+1);
 		base = pci_resource_start(dev, 2*port);
-		if ((ctl && !base) || (base && !ctl)) {
-			printk(KERN_ERR "%s: inconsistent baseregs (BIOS) "
-				"for port %d, skipping\n", d->name, port);
-			return NULL;
-		}
-	}
-	if (!ctl) {
+	} else {
 		/* Use default values */
 		ctl = port ? 0x374 : 0x3f4;
 		base = port ? 0x170 : 0x1f0;
 	}
 
-	hwif = ide_find_port_slot(d);
-	if (hwif == NULL) {
-		printk(KERN_ERR "%s: too many IDE interfaces, no room in "
-				"table\n", d->name);
+	if (!base || !ctl) {
+		printk(KERN_ERR "%s: bad PCI BARs for port %d, skipping\n",
+				d->name, port);
 		return NULL;
 	}
 
+	hwif = ide_find_port_slot(d);
+	if (hwif == NULL)
+		return NULL;
+
 	memset(&hw, 0, sizeof(hw));
 	hw.irq = irq;
 	hw.dev = &dev->dev;
@@ -346,8 +339,6 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
 
 	ide_init_port_hw(hwif, &hw);
 
-	hwif->dev = &dev->dev;
-
 	return hwif;
 }
 
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 683bce3..f843c13 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -258,19 +258,6 @@ idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 	return ide_stopped;
 }
 
-static ide_startstop_t
-idescsi_atapi_abort(ide_drive_t *drive, struct request *rq)
-{
-	debug_log("%s called for %lu\n", __func__,
-		((struct ide_atapi_pc *) rq->special)->scsi_cmd->serial_number);
-
-	rq->errors |= ERROR_MAX;
-
-	idescsi_end_request(drive, 0, 0);
-
-	return ide_stopped;
-}
-
 static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
@@ -524,7 +511,6 @@ static ide_driver_t idescsi_driver = {
 	.do_request		= idescsi_do_request,
 	.end_request		= idescsi_end_request,
 	.error                  = idescsi_atapi_error,
-	.abort                  = idescsi_atapi_abort,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idescsi_proc,
 #endif
diff --git a/include/linux/ide.h b/include/linux/ide.h
index ac4eeb2..4726126 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -139,6 +139,12 @@ struct ide_io_ports {
 #define WAIT_MIN_SLEEP	(2*HZ/100)	/* 20msec - minimum sleep time */
 
 /*
+ * Op codes for special requests to be handled by ide_special_rq().
+ * Values should be in the range of 0x20 to 0x3f.
+ */
+#define REQ_DRIVE_RESET		0x20
+
+/*
  * Check for an interrupt and acknowledge the interrupt status
  */
 struct hwif_s;
@@ -171,7 +177,7 @@ typedef struct hw_regs_s {
 	int		irq;			/* our irq number */
 	ide_ack_intr_t	*ack_intr;		/* acknowledge interrupt */
 	hwif_chipset_t  chipset;
-	struct device	*dev;
+	struct device	*dev, *parent;
 } hw_regs_t;
 
 void ide_init_port_data(struct hwif_s *, unsigned int);
@@ -405,8 +411,8 @@ typedef struct ide_drive_s {
 struct ide_port_info;
 
 struct ide_port_ops {
-	/* host specific initialization of devices on a port */
-	void	(*port_init_devs)(struct hwif_s *);
+	/* host specific initialization of a device */
+	void	(*init_dev)(ide_drive_t *);
 	/* routine to program host for PIO mode */
 	void	(*set_pio_mode)(ide_drive_t *, const u8);
 	/* routine to program host for DMA mode */
@@ -565,8 +571,6 @@ typedef struct hwgroup_s {
 	unsigned int sleeping	: 1;
 		/* BOOL: polling active & poll_timeout field valid */
 	unsigned int polling	: 1;
-	 	/* BOOL: in a polling reset situation. Must not trigger another reset yet */
-	unsigned int resetting  : 1;
 
 		/* current drive */
 	ide_drive_t *drive;
@@ -786,7 +790,6 @@ struct ide_driver_s {
 	ide_startstop_t	(*do_request)(ide_drive_t *, struct request *, sector_t);
 	int		(*end_request)(ide_drive_t *, int, int);
 	ide_startstop_t	(*error)(ide_drive_t *, struct request *rq, u8, u8);
-	ide_startstop_t	(*abort)(ide_drive_t *, struct request *rq);
 	struct device_driver	gen_driver;
 	int		(*probe)(ide_drive_t *);
 	void		(*remove)(ide_drive_t *);
@@ -801,18 +804,6 @@ struct ide_driver_s {
 
 int generic_ide_ioctl(ide_drive_t *, struct file *, struct block_device *, unsigned, unsigned long);
 
-/*
- * ide_hwifs[] is the master data structure used to keep track
- * of just about everything in ide.c.  Whenever possible, routines
- * should be using pointers to a drive (ide_drive_t *) or
- * pointers to a hwif (ide_hwif_t *), rather than indexing this
- * structure directly (the allocation/layout may change!).
- *
- */
-#ifndef _IDE_C
-extern	ide_hwif_t	ide_hwifs[];		/* master data repository */
-#endif
-
 extern int ide_vlb_clk;
 extern int ide_pci_clk;
 
@@ -840,10 +831,6 @@ ide_startstop_t __ide_error(ide_drive_t *, struct request *, u8, u8);
 
 ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, byte stat);
 
-ide_startstop_t __ide_abort(ide_drive_t *, struct request *);
-
-extern ide_startstop_t ide_abort(ide_drive_t *, const char *);
-
 extern void ide_fix_driveid(struct hd_driveid *);
 
 extern void ide_fixstring(u8 *, const int, const int);
@@ -1271,16 +1258,43 @@ static inline int ide_dev_is_sata(struct hd_driveid *id)
 u64 ide_get_lba_addr(struct ide_taskfile *, int);
 u8 ide_dump_status(ide_drive_t *, const char *, u8);
 
-typedef struct ide_pio_timings_s {
-	int	setup_time;	/* Address setup (ns) minimum */
-	int	active_time;	/* Active pulse (ns) minimum */
-	int	cycle_time;	/* Cycle time (ns) minimum = */
-				/* active + recovery (+ setup for some chips) */
-} ide_pio_timings_t;
+struct ide_timing {
+	u8  mode;
+	u8  setup;	/* t1 */
+	u16 act8b;	/* t2 for 8-bit io */
+	u16 rec8b;	/* t2i for 8-bit io */
+	u16 cyc8b;	/* t0 for 8-bit io */
+	u16 active;	/* t2 or tD */
+	u16 recover;	/* t2i or tK */
+	u16 cycle;	/* t0 */
+	u16 udma;	/* t2CYCTYP/2 */
+};
+
+enum {
+	IDE_TIMING_SETUP	= (1 << 0),
+	IDE_TIMING_ACT8B	= (1 << 1),
+	IDE_TIMING_REC8B	= (1 << 2),
+	IDE_TIMING_CYC8B	= (1 << 3),
+	IDE_TIMING_8BIT		= IDE_TIMING_ACT8B | IDE_TIMING_REC8B |
+				  IDE_TIMING_CYC8B,
+	IDE_TIMING_ACTIVE	= (1 << 4),
+	IDE_TIMING_RECOVER	= (1 << 5),
+	IDE_TIMING_CYCLE	= (1 << 6),
+	IDE_TIMING_UDMA		= (1 << 7),
+	IDE_TIMING_ALL		= IDE_TIMING_SETUP | IDE_TIMING_8BIT |
+				  IDE_TIMING_ACTIVE | IDE_TIMING_RECOVER |
+				  IDE_TIMING_CYCLE | IDE_TIMING_UDMA,
+};
+
+struct ide_timing *ide_timing_find_mode(u8);
+u16 ide_pio_cycle_time(ide_drive_t *, u8);
+void ide_timing_merge(struct ide_timing *, struct ide_timing *,
+		      struct ide_timing *, unsigned int);
+int ide_timing_compute(ide_drive_t *, u8, struct ide_timing *, int, int);
+
+int ide_scan_pio_blacklist(char *);
 
-unsigned int ide_pio_cycle_time(ide_drive_t *, u8);
 u8 ide_get_best_pio_mode(ide_drive_t *, u8, u8);
-extern const ide_pio_timings_t ide_pio_timings[6];
 
 int ide_set_pio_mode(ide_drive_t *, u8);
 int ide_set_dma_mode(ide_drive_t *, u8);
