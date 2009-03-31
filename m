Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbZCaTgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbZCaTgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbZCaTfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:35:53 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47711 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762887AbZCaTfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:35:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=r2CWHBytwDIlsiwQ7Tyd6uQnFDvDYD4OqGaOLiF5uQAa/6X1WpxPa+2RMCovc/Nfgn
         0DwpUbn9Q7GWyI6pS304Pel1TTUJG5nPPgpI/prhHDEKJmmXVKpFZ5047TghbXkKCxvG
         +A2bLsr8lL+ozx9zNWfAzpHv1/sluzIKetkVI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates part 3
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Tue, 31 Mar 2009 21:35:37 +0200
Message-Id: <200903312135.37659.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Part 3, some interesting stuff this time:

- ide-atapi: build fix for non-x86 archs (Geert Uytterhoeven)

- ide-cd: regression fix, start DMA after issuing a packet command
  (Borislav Petkov)

- ide-park: regressing fix, correct handling of sleeping devices
  (Elias Oltmanns)

- ide-pmac: cable detection fix for Apple PowerBook (TOMARI Hisanobu)
  and fix allowing modular IDE build (Gilles Espinasse)

- ide-{floppy,tape}: bug fix for padding of PIO transfers

- support for CompactFlash specific transfer modes (Sergei Shtylyov)

- struct ide_tp_ops sanitizations (Sergei Shtylyov)

- ide-cd: conversion to use scatterlists also for PIO transfers

- many other fixes/cleanups, detailed changelog below


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 CREDITS                        |    9 +
 MAINTAINERS                    |   15 +-
 drivers/ide/Kconfig            |   33 +--
 drivers/ide/Makefile           |    2 -
 drivers/ide/alim15x3.c         |   10 +-
 drivers/ide/at91_ide.c         |   39 +--
 drivers/ide/au1xxx-ide.c       |   26 +--
 drivers/ide/cmd64x.c           |    6 -
 drivers/ide/cs5530.c           |    3 +-
 drivers/ide/cs5536.c           |    1 -
 drivers/ide/falconide.c        |    4 +-
 drivers/ide/gayle.c            |   12 +-
 drivers/ide/hpt366.c           |   10 +-
 drivers/ide/ht6560b.c          |   20 ++-
 drivers/ide/icside.c           |    8 -
 drivers/ide/ide-atapi.c        |  168 +++++---------
 drivers/ide/ide-cd.c           |  525 +++++++++++++---------------------------
 drivers/ide/ide-disk.c         |    4 +-
 drivers/ide/ide-dma-sff.c      |   17 +-
 drivers/ide/ide-dma.c          |  118 ++++++----
 drivers/ide/ide-eh.c           |   14 +-
 drivers/ide/ide-floppy.c       |   29 +--
 drivers/ide/ide-floppy_ioctl.c |    5 +-
 drivers/ide/ide-generic.c      |   86 +------
 drivers/ide/ide-h8300.c        |   34 +--
 drivers/ide/ide-io-std.c       |  130 ++++------
 drivers/ide/ide-io.c           |   27 ++-
 drivers/ide/ide-iops.c         |   41 ++--
 drivers/ide/ide-pm.c           |    5 +-
 drivers/ide/ide-probe.c        |   31 +--
 drivers/ide/ide-tape.c         |   36 ++--
 drivers/ide/ide-taskfile.c     |   96 ++++----
 drivers/ide/ide-timings.c      |   12 +-
 drivers/ide/ide-xfer-mode.c    |   15 +-
 drivers/ide/ide_arm.c          |   53 ----
 drivers/ide/it821x.c           |    3 +-
 drivers/ide/ns87415.c          |   85 ++++----
 drivers/ide/pdc202xx_old.c     |   10 +-
 drivers/ide/pmac.c             |  101 ++++----
 drivers/ide/q40ide.c           |    4 +-
 drivers/ide/qd65xx.c           |   21 ++-
 drivers/ide/sc1200.c           |    7 +-
 drivers/ide/scc_pata.c         |   56 ++---
 drivers/ide/sgiioc4.c          |   24 +--
 drivers/ide/siimage.c          |    1 -
 drivers/ide/sl82c105.c         |   10 +-
 drivers/ide/tc86c001.c         |    1 -
 drivers/ide/trm290.c           |   57 +++--
 drivers/ide/tx4938ide.c        |   41 +---
 drivers/ide/tx4939ide.c        |   62 ++----
 include/linux/ide.h            |   56 ++---
 51 files changed, 847 insertions(+), 1336 deletions(-)
 delete mode 100644 drivers/ide/ide_arm.c


Bartlomiej Zolnierkiewicz (40):
      at91_ide: fix ->ftf_flags handling
      ide: add support for arbitrary transfer lengths to ide_pio_bytes()
      ide: use PageHighMem() instead of ifdefs in ide_pio_bytes()
      ide-cd: remove dead URLs
      ide-cd: use ide_end_rq() also for failed non-fs requests
      ide-cd: remove dead code from cdrom_decode_status()
      ide-cd: remove needless ide_dump_status_no_sense() wrapper
      ide-cd: remove no longer needed 'ignore' module parameter
      ide-cd: factor out failed request completion from cdrom_end_request()
      ide-cd: unify ide_cd_do_request() exit paths
      ide-cd: move setting REQ_FAILED flag out from 'end_request' exit path
      ide-cd: unify cdrom_newpc_intr() exit paths
      ide-cd: remove cdrom_end_request()
      ide-cd: kill whole failed request in ide_cd_do_request()
      ide-cd: cleanup ide_cd_do_request()
      ide-cd: use scatterlists for PIO transfers (fs requests)
      ide-cd: fix non-SECTOR_SIZE-multiples PIO transfers for fs requests
      ide-cd: merge ide_cd_prepare_rw_request() into cdrom_start_rw()
      ide-cd: use scatterlists for PIO transfers (non-fs requests) (v2)
      ide-cd: use common completion path for DMA requests in cdrom_newpc_intr()
      ide-cd: unify transfer padding in cdrom_newpc_intr()
      ide-cd: minor ide_cdrom_setup() cleanup
      ide: add ->dma_clear method and remove ->dma_timeout one
      ide: inline ide_dma_timeout() into ide_dma_timeout_retry()
      ide: destroy DMA mappings after ending DMA (v2)
      ide: add ide_dma_prepare() helper
      ns87415: use custom ->dma_{start,end} to handle ns87415_prepare_drive()
      trm290: use custom ->dma_{start,end} to handle trm290_prepare_drive()
      ide: add ->dma_check method
      ide: move ide_map_sg() call out of ->dma_setup method (take 2)
      ide: set/clear drive->waiting_for_dma flag in the core code
      ide: sanitize ide_build_sglist() and ide_destroy_dmatable()
      ide-generic: remove no longer needed sysfs interface
      ide: merge ide_arm and ide_generic host drivers
      ide: fix locking in drive_release_dev()
      ide: decrease size of ->pc_buf field in struct ide_atapi_pc
      ide: remove CONFIG_BLK_DEV_IDEDOUBLER config option
      ide-{floppy,tape}: fix padding for PIO transfers
      ide-floppy: use ide_pio_bytes()
      MAINTAINERS: move old ide-{floppy,tape} entries to CREDITS (take 2)

Borislav Petkov (2):
      ide-atapi: start DMA after issuing a packet command
      ide-floppy: do not complete rq's prematurely

Elias Oltmanns (1):
      ide: Fix code dealing with sleeping devices in do_ide_request()

Geert Uytterhoeven (1):
      ide: drivers/ide/ide-atapi.c needs <linux/scatterlist.h>

Gilles Espinasse (1):
      ide: be able to build pmac driver without IDE built-in

Sergei Shtylyov (13):
      au1xxx-ide: auide_{in|out}sw() should be static
      ide: identify data word 53 bit 1 doesn't cover words 62 and 63 (take 3)
      ide-iops: only clear DMA words on setting DMA mode
      ide: add support for CFA specified transfer modes (take 3)
      ide-disk: use ATA_ERR
      ide: use ATA_HOB
      ide: turn set_irq() method into write_devctl() method
      ide: rename IDE_TFLAG_IN_[HOB_]FEATURE
      ide-io-std: shorten ide_{in|out}put_data()
      ide: call {in|out}put_data() methods from tf_{read|load}() methods (take 2)
      ide: move data register access out of tf_{read|load}() methods (take 2)
      ide: turn selectproc() method into dev_select() method (take 5)
      ide: inline SELECT_DRIVE()

TOMARI Hisanobu (1):
      ide-pmac: IDE cable detection on Apple PowerBook


diff --git a/CREDITS b/CREDITS
index e8b7d36..9a93e3e 100644
--- a/CREDITS
+++ b/CREDITS
@@ -495,6 +495,11 @@ S: Kopmansg 2
 S: 411 13  Goteborg
 S: Sweden
 
+N: Paul Bristow
+E: paul@paulbristow.net
+W: http://paulbristow.net/linux/idefloppy.html
+D: Maintainer of IDE/ATAPI floppy driver
+
 N: Dominik Brodowski
 E: linux@brodo.de
 W: http://www.brodo.de/
@@ -2642,6 +2647,10 @@ S: C/ Mieses 20, 9-B
 S: Valladolid 47009
 S: Spain
 
+N: Gadi Oxman
+E: gadio@netvision.net.il
+D: Original author and maintainer of IDE/ATAPI floppy/tape drivers
+
 N: Greg Page
 E: gpage@sovereign.org
 D: IPX development and support
diff --git a/MAINTAINERS b/MAINTAINERS
index c5f4e9d..d20c786 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2201,25 +2201,12 @@ L:	linux-ide@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/bart/pata-2.6/
 S:	Maintained
 
-IDE/ATAPI CDROM DRIVER
+IDE/ATAPI DRIVERS
 P:	Borislav Petkov
 M:	petkovbb@gmail.com
 L:	linux-ide@vger.kernel.org
 S:	Maintained
 
-IDE/ATAPI FLOPPY DRIVERS
-P:	Paul Bristow
-M:	Paul Bristow <paul@paulbristow.net>
-W:	http://paulbristow.net/linux/idefloppy.html
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-
-IDE/ATAPI TAPE DRIVERS
-P:	Gadi Oxman
-M:	Gadi Oxman <gadio@netvision.net.il>
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-
 IDLE-I7300
 P:	Andy Henroid
 M:	andrew.d.henroid@intel.com
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 640c992..cf06494 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -222,7 +222,8 @@ comment "IDE chipset support/bugfixes"
 
 config IDE_GENERIC
 	tristate "generic/default IDE chipset support"
-	depends on ALPHA || X86 || IA64 || M32R || MIPS
+	depends on ALPHA || X86 || IA64 || M32R || MIPS || ARCH_RPC || ARCH_SHARK
+	default ARM && (ARCH_RPC || ARCH_SHARK)
 	help
 	  This is the generic IDE driver.  This driver attaches to the
 	  fixed legacy ports (e.g. on PCs 0x1f0/0x170, 0x1e8/0x168 and
@@ -680,7 +681,7 @@ endif
 # TODO: BLK_DEV_IDEDMA_PCI -> BLK_DEV_IDEDMA_SFF
 config BLK_DEV_IDE_PMAC
 	tristate "PowerMac on-board IDE support"
-	depends on PPC_PMAC && IDE=y
+	depends on PPC_PMAC
 	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
@@ -731,11 +732,6 @@ config BLK_DEV_IDE_AT91
 	depends on ARM && ARCH_AT91 && !ARCH_AT91RM9200 && !ARCH_AT91X40
 	select IDE_TIMINGS
 
-config IDE_ARM
-	tristate "ARM IDE support"
-	depends on ARM && (ARCH_RPC || ARCH_SHARK)
-	default y
-
 config BLK_DEV_IDE_ICSIDE
 	tristate "ICS IDE interface support"
 	depends on ARM && ARCH_ACORN
@@ -774,27 +770,20 @@ config BLK_DEV_GAYLE
 	  This includes on-board IDE interfaces on some Amiga models (A600,
 	  A1200, A4000, and A4000T), and IDE interfaces on the Zorro expansion
 	  bus (M-Tech E-Matrix 530 expansion card).
-	  Say Y if you have an Amiga with a Gayle IDE interface and want to use
-	  IDE devices (hard disks, CD-ROM drives, etc.) that are connected to
-	  it.
-	  Note that you also have to enable Zorro bus support if you want to
-	  use Gayle IDE interfaces on the Zorro expansion bus.
 
-config BLK_DEV_IDEDOUBLER
-	bool "Amiga IDE Doubler support (EXPERIMENTAL)"
-	depends on BLK_DEV_GAYLE && EXPERIMENTAL
-	---help---
-	  This feature provides support for the so-called `IDE doublers' (made
+	  It also provides support for the so-called `IDE doublers' (made
 	  by various manufacturers, e.g. Eyetech) that can be connected to
 	  the on-board IDE interface of some Amiga models. Using such an IDE
 	  doubler, you can connect up to four instead of two IDE devices to
-	  the Amiga's on-board IDE interface.
+	  the Amiga's on-board IDE interface. The feature is enabled at kernel
+	  runtime using the "gayle.doubler" kernel boot parameter.
 
-	  Note that the normal Amiga Gayle IDE driver may not work correctly
-	  if you have an IDE doubler and don't enable this feature!
+	  Say Y if you have an Amiga with a Gayle IDE interface and want to use
+	  IDE devices (hard disks, CD-ROM drives, etc.) that are connected to
+	  it.
 
-	  Say Y if you have an IDE doubler.  The feature is enabled at kernel
-	  runtime using the "gayle.doubler" kernel boot parameter.
+	  Note that you also have to enable Zorro bus support if you want to
+	  use Gayle IDE interfaces on the Zorro expansion bus.
 
 config BLK_DEV_BUDDHA
 	tristate "Buddha/Catweasel/X-Surf IDE interface support (EXPERIMENTAL)"
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 9b4bbe1..81df925 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -21,8 +21,6 @@ ide-core-$(CONFIG_IDE_LEGACY)		+= ide-legacy.o
 
 obj-$(CONFIG_IDE)			+= ide-core.o
 
-obj-$(CONFIG_IDE_ARM)			+= ide_arm.o
-
 obj-$(CONFIG_BLK_DEV_ALI14XX)		+= ali14xx.o
 obj-$(CONFIG_BLK_DEV_UMC8672)		+= umc8672.o
 obj-$(CONFIG_BLK_DEV_DTC2278)		+= dtc2278.o
diff --git a/drivers/ide/alim15x3.c b/drivers/ide/alim15x3.c
index d516168..537da1c 100644
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -189,20 +189,20 @@ static void ali_set_dma_mode(ide_drive_t *drive, const u8 speed)
 }
 
 /**
- *	ali15x3_dma_setup	-	begin a DMA phase
+ *	ali_dma_check	-	DMA check
  *	@drive:	target device
  *	@cmd: command
  *
  *	Returns 1 if the DMA cannot be performed, zero on success.
  */
 
-static int ali15x3_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
+static int ali_dma_check(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	if (m5229_revision < 0xC2 && drive->media != ide_disk) {
 		if (cmd->tf_flags & IDE_TFLAG_WRITE)
 			return 1;	/* try PIO instead of DMA */
 	}
-	return ide_dma_setup(drive, cmd);
+	return 0;
 }
 
 /**
@@ -503,13 +503,13 @@ static const struct ide_port_ops ali_port_ops = {
 
 static const struct ide_dma_ops ali_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
-	.dma_setup		= ali15x3_dma_setup,
+	.dma_setup		= ide_dma_setup,
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_check		= ali_dma_check,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
diff --git a/drivers/ide/at91_ide.c b/drivers/ide/at91_ide.c
index 2754712..8eda552 100644
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -192,15 +192,9 @@ static void at91_ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 	struct ide_taskfile *tf = &cmd->tf;
 	u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
-	if (cmd->tf_flags & IDE_FTFLAG_FLAGGED)
+	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (cmd->tf_flags & IDE_FTFLAG_OUT_DATA) {
-		u16 data = (tf->hob_data << 8) | tf->data;
-
-		at91_ide_output_data(drive, NULL, &data, 2);
-	}
-
 	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		ide_mm_outb(tf->hob_feature, io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
@@ -233,19 +227,11 @@ static void at91_ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &cmd->tf;
 
-	if (cmd->tf_flags & IDE_FTFLAG_IN_DATA) {
-		u16 data;
-
-		at91_ide_input_data(drive, NULL, &data, 2);
-		tf->data = data & 0xff;
-		tf->hob_data = (data >> 8) & 0xff;
-	}
-
 	/* be sure we're looking at the low order bits */
-	ide_mm_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
+	ide_mm_outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
-		tf->feature = ide_mm_inb(io_ports->feature_addr);
+	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
+		tf->error  = ide_mm_inb(io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = ide_mm_inb(io_ports->nsect_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
@@ -258,18 +244,18 @@ static void at91_ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 		tf->device = ide_mm_inb(io_ports->device_addr);
 
 	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		ide_mm_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
+		ide_mm_outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature = ide_mm_inb(io_ports->feature_addr);
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
+			tf->hob_error = ide_mm_inb(io_ports->feature_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = ide_mm_inb(io_ports->nsect_addr);
+			tf->hob_nsect = ide_mm_inb(io_ports->nsect_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = ide_mm_inb(io_ports->lbal_addr);
+			tf->hob_lbal  = ide_mm_inb(io_ports->lbal_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = ide_mm_inb(io_ports->lbam_addr);
+			tf->hob_lbam  = ide_mm_inb(io_ports->lbam_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = ide_mm_inb(io_ports->lbah_addr);
+			tf->hob_lbah  = ide_mm_inb(io_ports->lbah_addr);
 	}
 }
 
@@ -295,8 +281,9 @@ static const struct ide_tp_ops at91_ide_tp_ops = {
 	.exec_command	= ide_exec_command,
 	.read_status	= ide_read_status,
 	.read_altstatus	= ide_read_altstatus,
-	.set_irq	= ide_set_irq,
+	.write_devctl	= ide_write_devctl,
 
+	.dev_select	= ide_dev_select,
 	.tf_load	= at91_ide_tf_load,
 	.tf_read	= at91_ide_tf_read,
 
diff --git a/drivers/ide/au1xxx-ide.c b/drivers/ide/au1xxx-ide.c
index d3a9d6c..4601364 100644
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -50,7 +50,7 @@ static _auide_hwif auide_hwif;
 
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA)
 
-void auide_insw(unsigned long port, void *addr, u32 count)
+static inline void auide_insw(unsigned long port, void *addr, u32 count)
 {
 	_auide_hwif *ahwif = &auide_hwif;
 	chan_tab_t *ctp;
@@ -68,7 +68,7 @@ void auide_insw(unsigned long port, void *addr, u32 count)
 	ctp->cur_ptr = au1xxx_ddma_get_nextptr_virt(dp);
 }
 
-void auide_outsw(unsigned long port, void *addr, u32 count)
+static inline void auide_outsw(unsigned long port, void *addr, u32 count)
 {
 	_auide_hwif *ahwif = &auide_hwif;
 	chan_tab_t *ctp;
@@ -236,7 +236,7 @@ static int auide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 			if (++count >= PRD_ENTRIES) {
 				printk(KERN_WARNING "%s: DMA table too small\n",
 				       drive->name);
-				goto use_pio_instead;
+				return 0;
 			}
 
 			/* Lets enable intr for the last descriptor only */
@@ -272,16 +272,11 @@ static int auide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 	if (count)
 		return 1;
 
- use_pio_instead:
-	ide_destroy_dmatable(drive);
-
 	return 0; /* revert to PIO for this request */
 }
 
 static int auide_dma_end(ide_drive_t *drive)
 {
-	ide_destroy_dmatable(drive);
-
 	return 0;
 }
 
@@ -292,12 +287,9 @@ static void auide_dma_start(ide_drive_t *drive )
 
 static int auide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	if (auide_build_dmatable(drive, cmd) == 0) {
-		ide_map_sg(drive, cmd);
+	if (auide_build_dmatable(drive, cmd) == 0)
 		return 1;
-	}
 
-	drive->waiting_for_dma = 1;
 	return 0;
 }
 
@@ -322,16 +314,11 @@ static void auide_dma_host_set(ide_drive_t *drive, int on)
 
 static void auide_ddma_tx_callback(int irq, void *param)
 {
-	_auide_hwif *ahwif = (_auide_hwif*)param;
-	ahwif->drive->waiting_for_dma = 0;
 }
 
 static void auide_ddma_rx_callback(int irq, void *param)
 {
-	_auide_hwif *ahwif = (_auide_hwif*)param;
-	ahwif->drive->waiting_for_dma = 0;
 }
-
 #endif /* end CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA */
 
 static void auide_init_dbdma_dev(dbdev_tab_t *dev, u32 dev_id, u32 tsize, u32 devwidth, u32 flags)
@@ -353,7 +340,6 @@ static const struct ide_dma_ops au1xxx_dma_ops = {
 	.dma_end		= auide_dma_end,
 	.dma_test_irq		= auide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
-	.dma_timeout		= ide_dma_timeout,
 };
 
 static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
@@ -481,9 +467,9 @@ static const struct ide_tp_ops au1xxx_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
 
-	.set_irq		= ide_set_irq,
-
+	.dev_select		= ide_dev_select,
 	.tf_load		= ide_tf_load,
 	.tf_read		= ide_tf_read,
 
diff --git a/drivers/ide/cmd64x.c b/drivers/ide/cmd64x.c
index bf0e3f4..80b777e 100644
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -318,7 +318,6 @@ static int cmd646_1_dma_end(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = 0, dma_cmd = 0;
 
-	drive->waiting_for_dma = 0;
 	/* get DMA status */
 	dma_stat = inb(hwif->dma_base + ATA_DMA_STATUS);
 	/* read DMA command state */
@@ -327,8 +326,6 @@ static int cmd646_1_dma_end(ide_drive_t *drive)
 	outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
 	/* clear the INTR & ERROR bits */
 	outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
-	/* and free any DMA resources */
-	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
 	return (dma_stat & 7) != 4;
 }
@@ -384,7 +381,6 @@ static const struct ide_dma_ops cmd64x_dma_ops = {
 	.dma_test_irq		= cmd64x_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
@@ -396,7 +392,6 @@ static const struct ide_dma_ops cmd646_rev1_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
@@ -408,7 +403,6 @@ static const struct ide_dma_ops cmd648_dma_ops = {
 	.dma_test_irq		= cmd648_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
diff --git a/drivers/ide/cs5530.c b/drivers/ide/cs5530.c
index 8e8b35a..40bf05e 100644
--- a/drivers/ide/cs5530.c
+++ b/drivers/ide/cs5530.c
@@ -92,8 +92,7 @@ static u8 cs5530_udma_filter(ide_drive_t *drive)
 		if ((mateid[ATA_ID_FIELD_VALID] & 4) &&
 		    (mateid[ATA_ID_UDMA_MODES] & 7))
 			goto out;
-		if ((mateid[ATA_ID_FIELD_VALID] & 2) &&
-		    (mateid[ATA_ID_MWDMA_MODES] & 7))
+		if (mateid[ATA_ID_MWDMA_MODES] & 7)
 			mask = 0;
 	}
 out:
diff --git a/drivers/ide/cs5536.c b/drivers/ide/cs5536.c
index d5dcf48..353a35b 100644
--- a/drivers/ide/cs5536.c
+++ b/drivers/ide/cs5536.c
@@ -236,7 +236,6 @@ static const struct ide_dma_ops cs5536_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 };
 
 static const struct ide_port_info cs5536_info = {
diff --git a/drivers/ide/falconide.c b/drivers/ide/falconide.c
index b368a5e..afa2af9 100644
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -89,9 +89,9 @@ static const struct ide_tp_ops falconide_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
 
-	.set_irq		= ide_set_irq,
-
+	.dev_select		= ide_dev_select,
 	.tf_load		= ide_tf_load,
 	.tf_read		= ide_tf_read,
 
diff --git a/drivers/ide/gayle.c b/drivers/ide/gayle.c
index dc77825..c711951 100644
--- a/drivers/ide/gayle.c
+++ b/drivers/ide/gayle.c
@@ -53,11 +53,6 @@
 
 #define GAYLE_NEXT_PORT	0x1000
 
-#ifndef CONFIG_BLK_DEV_IDEDOUBLER
-#define GAYLE_NUM_HWIFS		1
-#define GAYLE_NUM_PROBE_HWIFS	GAYLE_NUM_HWIFS
-#define GAYLE_HAS_CONTROL_REG	1
-#else /* CONFIG_BLK_DEV_IDEDOUBLER */
 #define GAYLE_NUM_HWIFS		2
 #define GAYLE_NUM_PROBE_HWIFS	(ide_doubler ? GAYLE_NUM_HWIFS : \
 					       GAYLE_NUM_HWIFS-1)
@@ -66,8 +61,6 @@
 static int ide_doubler;
 module_param_named(doubler, ide_doubler, bool, 0);
 MODULE_PARM_DESC(doubler, "enable support for IDE doublers");
-#endif /* CONFIG_BLK_DEV_IDEDOUBLER */
-
 
     /*
      *  Check and acknowledge the interrupt status
@@ -151,10 +144,7 @@ static int __init gayle_init(void)
 found:
 	printk(KERN_INFO "ide: Gayle IDE controller (A%d style%s)\n",
 			 a4000 ? 4000 : 1200,
-#ifdef CONFIG_BLK_DEV_IDEDOUBLER
-			 ide_doubler ? ", IDE doubler" :
-#endif
-			 "");
+			 ide_doubler ? ", IDE doubler" : "");
 
 	if (a4000) {
 	    phys_base = GAYLE_BASE_4000;
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index dbaf184..a0eb87f 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -835,12 +835,6 @@ static int hpt370_dma_end(ide_drive_t *drive)
 	return ide_dma_end(drive);
 }
 
-static void hpt370_dma_timeout(ide_drive_t *drive)
-{
-	hpt370_irq_timeout(drive);
-	ide_dma_timeout(drive);
-}
-
 /* returns 1 if DMA IRQ issued, 0 otherwise */
 static int hpt374_dma_test_irq(ide_drive_t *drive)
 {
@@ -1423,7 +1417,6 @@ static const struct ide_dma_ops hpt37x_dma_ops = {
 	.dma_test_irq		= hpt374_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
@@ -1435,7 +1428,7 @@ static const struct ide_dma_ops hpt370_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= hpt370_dma_timeout,
+	.dma_clear		= hpt370_irq_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
@@ -1447,7 +1440,6 @@ static const struct ide_dma_ops hpt36x_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= hpt366_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
diff --git a/drivers/ide/ht6560b.c b/drivers/ide/ht6560b.c
index c7e5c22..2fb0f29 100644
--- a/drivers/ide/ht6560b.c
+++ b/drivers/ide/ht6560b.c
@@ -103,7 +103,7 @@
 /*
  * This routine is invoked from ide.c to prepare for access to a given drive.
  */
-static void ht6560b_selectproc (ide_drive_t *drive)
+static void ht6560b_dev_select(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
@@ -143,6 +143,8 @@ static void ht6560b_selectproc (ide_drive_t *drive)
 #endif
 	}
 	local_irq_restore(flags);
+
+	outb(drive->select | ATA_DEVICE_OBS, hwif->io_ports.device_addr);
 }
 
 /*
@@ -305,15 +307,29 @@ static int probe_ht6560b;
 module_param_named(probe, probe_ht6560b, bool, 0);
 MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
 
+static const struct ide_tp_ops ht6560b_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
+
+	.dev_select		= ht6560b_dev_select,
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
+
 static const struct ide_port_ops ht6560b_port_ops = {
 	.init_dev		= ht6560b_init_dev,
 	.set_pio_mode		= ht6560b_set_pio_mode,
-	.selectproc		= ht6560b_selectproc,
 };
 
 static const struct ide_port_info ht6560b_port_info __initdata = {
 	.name			= DRV_NAME,
 	.chipset		= ide_ht6560b,
+	.tp_ops 		= &ht6560b_tp_ops,
 	.port_ops		= &ht6560b_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE | /* is this needed? */
 				  IDE_HFLAG_NO_DMA |
diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
index 51ce404..4e16ce6 100644
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -287,13 +287,8 @@ static int icside_dma_end(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 
-	drive->waiting_for_dma = 0;
-
 	disable_dma(ec->dma);
 
-	/* Teardown mappings after DMA has completed. */
-	ide_destroy_dmatable(drive);
-
 	return get_dma_residue(ec->dma) != 0;
 }
 
@@ -346,8 +341,6 @@ static int icside_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 	set_dma_sg(ec->dma, hwif->sg_table, cmd->sg_nents);
 	set_dma_mode(ec->dma, dma_mode);
 
-	drive->waiting_for_dma = 1;
-
 	return 0;
 }
 
@@ -377,7 +370,6 @@ static const struct ide_dma_ops icside_v6_dma_ops = {
 	.dma_start		= icside_dma_start,
 	.dma_end		= icside_dma_end,
 	.dma_test_irq		= icside_dma_test_irq,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
 };
 #else
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 2fb5d28..3e43b88 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -6,6 +6,8 @@
 #include <linux/cdrom.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
+#include <linux/scatterlist.h>
+
 #include <scsi/scsi.h>
 
 #ifdef DEBUG
@@ -69,56 +71,6 @@ int ide_check_atapi_device(ide_drive_t *drive, const char *s)
 }
 EXPORT_SYMBOL_GPL(ide_check_atapi_device);
 
-/* PIO data transfer routine using the scatter gather table. */
-int ide_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-		    unsigned int bcount, int write)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	xfer_func_t *xf = write ? tp_ops->output_data : tp_ops->input_data;
-	struct scatterlist *sg = pc->sg;
-	char *buf;
-	int count, done = 0;
-
-	while (bcount) {
-		count = min(sg->length - pc->b_count, bcount);
-
-		if (PageHighMem(sg_page(sg))) {
-			unsigned long flags;
-
-			local_irq_save(flags);
-			buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
-			xf(drive, NULL, buf + pc->b_count, count);
-			kunmap_atomic(buf - sg->offset, KM_IRQ0);
-			local_irq_restore(flags);
-		} else {
-			buf = sg_virt(sg);
-			xf(drive, NULL, buf + pc->b_count, count);
-		}
-
-		bcount -= count;
-		pc->b_count += count;
-		done += count;
-
-		if (pc->b_count == sg->length) {
-			if (!--pc->sg_cnt)
-				break;
-			pc->sg = sg = sg_next(sg);
-			pc->b_count = 0;
-		}
-	}
-
-	if (bcount) {
-		printk(KERN_ERR "%s: %d leftover bytes, %s\n", drive->name,
-			bcount, write ? "padding with zeros"
-				      : "discarding data");
-		ide_pad_transfer(drive, write, bcount);
-	}
-
-	return done;
-}
-EXPORT_SYMBOL_GPL(ide_io_buffers);
-
 void ide_init_pc(struct ide_atapi_pc *pc)
 {
 	memset(pc, 0, sizeof(*pc));
@@ -324,12 +276,14 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 {
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_cmd *cmd = &hwif->cmd;
 	struct request *rq = hwif->rq;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	xfer_func_t *xferfunc;
-	unsigned int timeout, temp;
+	unsigned int timeout, done;
 	u16 bcount;
 	u8 stat, ireason, dsc = 0;
+	u8 write = !!(pc->flags & PC_FLAG_WRITING);
 
 	debug_log("Enter %s - interrupt handler\n", __func__);
 
@@ -340,8 +294,13 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	stat = tp_ops->read_status(hwif);
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		if (hwif->dma_ops->dma_end(drive) ||
-		    (drive->media == ide_tape && (stat & ATA_ERR))) {
+		int rc;
+
+		drive->waiting_for_dma = 0;
+		rc = hwif->dma_ops->dma_end(drive);
+		ide_dma_unmap_sg(drive, cmd);
+
+		if (rc || (drive->media == ide_tape && (stat & ATA_ERR))) {
 			if (drive->media == ide_floppy)
 				printk(KERN_ERR "%s: DMA %s error\n",
 					drive->name, rq_data_dir(pc->rq)
@@ -357,7 +316,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 	/* No more interrupts */
 	if ((stat & ATA_DRQ) == 0) {
-		int uptodate;
+		int uptodate, error;
+		unsigned int done;
 
 		debug_log("Packet command completed, %d bytes transferred\n",
 			  pc->xferred);
@@ -404,16 +364,24 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 		if (blk_special_request(rq)) {
 			rq->errors = 0;
-			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
+			done = blk_rq_bytes(rq);
+			error = 0;
 		} else {
+
 			if (blk_fs_request(rq) == 0 && uptodate <= 0) {
 				if (rq->errors == 0)
 					rq->errors = -EIO;
 			}
-			ide_complete_rq(drive, uptodate ? 0 : -EIO,
-					ide_rq_bytes(rq));
+
+			if (drive->media == ide_tape)
+				done = ide_rq_bytes(rq); /* FIXME */
+			else
+				done = blk_rq_bytes(rq);
+
+			error = uptodate ? 0 : -EIO;
 		}
 
+		ide_complete_rq(drive, error, done);
 		return ide_stopped;
 	}
 
@@ -433,8 +401,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		return ide_do_reset(drive);
 	}
 
-	if (((ireason & ATAPI_IO) == ATAPI_IO) ==
-		!!(pc->flags & PC_FLAG_WRITING)) {
+	if (((ireason & ATAPI_IO) == ATAPI_IO) == write) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
 				"to %s!\n", drive->name,
@@ -443,45 +410,30 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		return ide_do_reset(drive);
 	}
 
-	if (!(pc->flags & PC_FLAG_WRITING)) {
-		/* Reading - Check that we have enough space */
-		temp = pc->xferred + bcount;
-		if (temp > pc->req_xfer) {
-			if (temp > pc->buf_size) {
-				printk(KERN_ERR "%s: The device wants to send "
-						"us more data than expected - "
-						"discarding data\n",
-						drive->name);
-
-				ide_pad_transfer(drive, 0, bcount);
-				goto next_irq;
-			}
-			debug_log("The device wants to send us more data than "
-				  "expected - allowing transfer\n");
-		}
-		xferfunc = tp_ops->input_data;
-	} else
-		xferfunc = tp_ops->output_data;
-
-	if ((drive->media == ide_floppy && !pc->buf) ||
-	    (drive->media == ide_tape && pc->bh)) {
-		int done = drive->pc_io_buffers(drive, pc, bcount,
-				  !!(pc->flags & PC_FLAG_WRITING));
-
-		/* FIXME: don't do partial completions */
-		if (drive->media == ide_floppy)
-			ide_complete_rq(drive, 0,
-					done ? done : ide_rq_bytes(rq));
-	} else
-		xferfunc(drive, NULL, pc->cur_pos, bcount);
+	xferfunc = write ? tp_ops->output_data : tp_ops->input_data;
+
+	if (drive->media == ide_floppy && pc->buf == NULL) {
+		done = min_t(unsigned int, bcount, cmd->nleft);
+		ide_pio_bytes(drive, cmd, write, done);
+	} else if (drive->media == ide_tape && pc->bh) {
+		done = drive->pc_io_buffers(drive, pc, bcount, write);
+	} else {
+		done = min_t(unsigned int, bcount, pc->req_xfer - pc->xferred);
+		xferfunc(drive, NULL, pc->cur_pos, done);
+	}
 
 	/* Update the current position */
-	pc->xferred += bcount;
-	pc->cur_pos += bcount;
+	pc->xferred += done;
+	pc->cur_pos += done;
+
+	bcount -= done;
+
+	if (bcount)
+		ide_pad_transfer(drive, write, bcount);
+
+	debug_log("[cmd %x] transferred %d bytes, padded %d bytes\n",
+		  rq->cmd[0], done, bcount);
 
-	debug_log("[cmd %x] transferred %d bytes on that intr.\n",
-		  rq->cmd[0], bcount);
-next_irq:
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, ide_pc_intr, timeout);
 	return ide_started;
@@ -611,6 +563,10 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 					     : ide_pc_intr),
 			timeout);
 
+	/* Send the actual packet */
+	if ((drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) == 0)
+		hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
+
 	/* Begin DMA, if necessary */
 	if (dev_is_idecd(drive)) {
 		if (drive->dma)
@@ -622,10 +578,6 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 		}
 	}
 
-	/* Send the actual packet */
-	if ((drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) == 0)
-		hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
-
 	return ide_started;
 }
 
@@ -633,7 +585,6 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	struct ide_atapi_pc *pc;
 	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
 	ide_expiry_t *expiry = NULL;
 	struct request *rq = hwif->rq;
 	unsigned int timeout;
@@ -647,12 +598,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 		expiry = ide_cd_expiry;
 		timeout = ATAPI_WAIT_PC;
 
-		if (drive->dma) {
-			if (ide_build_sglist(drive, cmd))
-				drive->dma = !dma_ops->dma_setup(drive, cmd);
-			else
-				drive->dma = 0;
-		}
+		if (drive->dma)
+			drive->dma = !ide_dma_prepare(drive, cmd);
 	} else {
 		pc = drive->pc;
 
@@ -670,13 +617,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 			ide_dma_off(drive);
 		}
 
-		if ((pc->flags & PC_FLAG_DMA_OK) &&
-		     (drive->dev_flags & IDE_DFLAG_USING_DMA)) {
-			if (ide_build_sglist(drive, cmd))
-				drive->dma = !dma_ops->dma_setup(drive, cmd);
-			else
-				drive->dma = 0;
-		}
+		if (pc->flags & PC_FLAG_DMA_OK)
+			drive->dma = !ide_dma_prepare(drive, cmd);
 
 		if (!drive->dma)
 			pc->flags &= ~PC_FLAG_DMA_OK;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 3f630e4..35729a4 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -4,7 +4,7 @@
  * Copyright (C) 1994-1996   Scott Snyder <snyder@fnald0.fnal.gov>
  * Copyright (C) 1996-1998   Erik Andersen <andersee@debian.org>
  * Copyright (C) 1998-2000   Jens Axboe <axboe@suse.de>
- * Copyright (C) 2005, 2007  Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2005, 2007-2009  Bartlomiej Zolnierkiewicz
  *
  * May be copied or modified under the terms of the GNU General Public
  * License.  See linux/COPYING for more information.
@@ -12,12 +12,9 @@
  * See Documentation/cdrom/ide-cd for usage information.
  *
  * Suggestions are welcome. Patches that work are more welcome though. ;-)
- * For those wishing to work on this driver, please be sure you download
- * and comply with the latest Mt. Fuji (SFF8090 version 4) and ATAPI
- * (SFF-8020i rev 2.6) standards. These documents can be obtained by
- * anonymous ftp from:
- * ftp://fission.dt.wdc.com/pub/standards/SFF_atapi/spec/SFF8020-r2.6/PS/8020r26.ps
- * ftp://ftp.avc-pioneer.com/Mtfuji4/Spec/Fuji4r10.pdf
+ *
+ * Documentation:
+ *	Mt. Fuji (SFF8090 version 4) and ATAPI (SFF-8020i rev 2.6) standards.
  *
  * For historical changelog please see:
  *	Documentation/ide/ChangeLog.ide-cd.1994-2004
@@ -245,73 +242,34 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 	elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 0);
 }
 
-static void cdrom_end_request(ide_drive_t *drive, int uptodate)
+static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
 {
-	struct request *rq = drive->hwif->rq;
-	int nsectors = rq->hard_cur_sectors;
-
-	ide_debug_log(IDE_DBG_FUNC, "cmd: 0x%x, uptodate: 0x%x, nsectors: %d",
-				    rq->cmd[0], uptodate, nsectors);
-
-	if (blk_sense_request(rq) && uptodate) {
-		/*
-		 * For REQ_TYPE_SENSE, "rq->buffer" points to the original
-		 * failed request
-		 */
-		struct request *failed = (struct request *) rq->buffer;
-		struct cdrom_info *info = drive->driver_data;
-		void *sense = &info->sense_data;
-
-		if (failed) {
-			if (failed->sense) {
-				sense = failed->sense;
-				failed->sense_len = rq->sense_len;
-			}
-			cdrom_analyze_sense_data(drive, failed, sense);
-			/*
-			 * now end the failed request
-			 */
-			if (blk_fs_request(failed)) {
-				if (ide_end_rq(drive, failed, -EIO,
-						failed->hard_nr_sectors << 9))
-					BUG();
-			} else {
-				if (blk_end_request(failed, -EIO,
-						    failed->data_len))
-					BUG();
-			}
-		} else
-			cdrom_analyze_sense_data(drive, NULL, sense);
-	}
-
-	if (!rq->current_nr_sectors && blk_fs_request(rq))
-		uptodate = 1;
-	/* make sure it's fully ended */
-	if (blk_pc_request(rq))
-		nsectors = (rq->data_len + 511) >> 9;
-	if (!nsectors)
-		nsectors = 1;
-
-	ide_debug_log(IDE_DBG_FUNC, "uptodate: 0x%x, nsectors: %d",
-				    uptodate, nsectors);
-
-	if (blk_fs_request(rq) == 0 && uptodate <= 0 && rq->errors == 0)
-		rq->errors = -EIO;
+	/*
+	 * For REQ_TYPE_SENSE, "rq->buffer" points to the original
+	 * failed request
+	 */
+	struct request *failed = (struct request *)rq->buffer;
+	struct cdrom_info *info = drive->driver_data;
+	void *sense = &info->sense_data;
 
-	ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
-}
+	if (failed) {
+		if (failed->sense) {
+			sense = failed->sense;
+			failed->sense_len = rq->sense_len;
+		}
+		cdrom_analyze_sense_data(drive, failed, sense);
 
-static void ide_dump_status_no_sense(ide_drive_t *drive, const char *msg, u8 st)
-{
-	if (st & 0x80)
-		return;
-	ide_dump_status(drive, msg, st);
+		if (ide_end_rq(drive, failed, -EIO, blk_rq_bytes(failed)))
+			BUG();
+	} else
+		cdrom_analyze_sense_data(drive, NULL, sense);
 }
 
 /*
  * Returns:
  * 0: if the request should be continued.
- * 1: if the request was ended.
+ * 1: if the request will be going through error recovery.
+ * 2: if the request should be ended.
  */
 static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 {
@@ -332,12 +290,6 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 	err = ide_read_error(drive);
 	sense_key = err >> 4;
 
-	if (rq == NULL) {
-		printk(KERN_ERR PFX "%s: missing rq in %s\n",
-				drive->name, __func__);
-		return 1;
-	}
-
 	ide_debug_log(IDE_DBG_RQ, "stat: 0x%x, good_stat: 0x%x, cmd[0]: 0x%x, "
 				  "rq->cmd_type: 0x%x, err: 0x%x",
 				  stat, good_stat, rq->cmd[0], rq->cmd_type,
@@ -350,10 +302,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		 * Just give up.
 		 */
 		rq->cmd_flags |= REQ_FAILED;
-		cdrom_end_request(drive, 0);
-		ide_error(drive, "request sense failure", stat);
-		return 1;
-
+		return 2;
 	} else if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC) {
 		/* All other functions, except for READ. */
 
@@ -456,21 +405,19 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 			 * No point in retrying after an illegal request or data
 			 * protect error.
 			 */
-			ide_dump_status_no_sense(drive, "command error", stat);
+			ide_dump_status(drive, "command error", stat);
 			do_end_request = 1;
 		} else if (sense_key == MEDIUM_ERROR) {
 			/*
 			 * No point in re-trying a zillion times on a bad
 			 * sector. If we got here the error is not correctable.
 			 */
-			ide_dump_status_no_sense(drive,
-						 "media error (bad sector)",
-						 stat);
+			ide_dump_status(drive, "media error (bad sector)",
+					stat);
 			do_end_request = 1;
 		} else if (sense_key == BLANK_CHECK) {
 			/* disk appears blank ?? */
-			ide_dump_status_no_sense(drive, "media error (blank)",
-						 stat);
+			ide_dump_status(drive, "media error (blank)", stat);
 			do_end_request = 1;
 		} else if ((err & ~ATA_ABORTED) != 0) {
 			/* go to the default handler for other errors */
@@ -495,14 +442,12 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		 */
 		if (stat & ATA_ERR)
 			cdrom_queue_request_sense(drive, NULL, NULL);
+		return 1;
 	} else {
 		blk_dump_rq_flags(rq, PFX "bad rq");
-		cdrom_end_request(drive, 0);
+		return 2;
 	}
 
-	/* retry, or handle the next request */
-	return 1;
-
 end_request:
 	if (stat & ATA_ERR) {
 		struct request_queue *q = drive->queue;
@@ -515,10 +460,9 @@ end_request:
 		hwif->rq = NULL;
 
 		cdrom_queue_request_sense(drive, rq->sense, rq);
+		return 1;
 	} else
-		cdrom_end_request(drive, 0);
-
-	return 1;
+		return 2;
 }
 
 /*
@@ -562,101 +506,13 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 	if (rq->cmd_type == REQ_TYPE_ATA_PC)
 		rq->cmd_flags |= REQ_FAILED;
 
-	cdrom_end_request(drive, 0);
 	return -1;
 }
 
-/*
- * Assume that the drive will always provide data in multiples of at least
- * SECTOR_SIZE, as it gets hairy to keep track of the transfers otherwise.
- */
-static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
+static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	ide_debug_log(IDE_DBG_FUNC, "len: %d", len);
-
-	if ((len % SECTOR_SIZE) == 0)
-		return 0;
+	struct request *rq = cmd->rq;
 
-	printk(KERN_ERR PFX "%s: %s: Bad transfer size %d\n", drive->name,
-			__func__, len);
-
-	if (drive->atapi_flags & IDE_AFLAG_LIMIT_NFRAMES)
-		printk(KERN_ERR PFX "This drive is not supported by this "
-				"version of the driver\n");
-	else {
-		printk(KERN_ERR PFX "Trying to limit transfer sizes\n");
-		drive->atapi_flags |= IDE_AFLAG_LIMIT_NFRAMES;
-	}
-
-	return 1;
-}
-
-static ide_startstop_t ide_cd_prepare_rw_request(ide_drive_t *drive,
-						 struct request *rq)
-{
-	ide_debug_log(IDE_DBG_RQ, "rq->cmd_flags: 0x%x", rq->cmd_flags);
-
-	if (rq_data_dir(rq) == READ) {
-		unsigned short sectors_per_frame =
-			queue_hardsect_size(drive->queue) >> SECTOR_BITS;
-		int nskip = rq->sector & (sectors_per_frame - 1);
-
-		/*
-		 * If the requested sector doesn't start on a frame boundary,
-		 * we must adjust the start of the transfer so that it does,
-		 * and remember to skip the first few sectors.
-		 *
-		 * If the rq->current_nr_sectors field is larger than the size
-		 * of the buffer, it will mean that we're to skip a number of
-		 * sectors equal to the amount by which rq->current_nr_sectors
-		 * is larger than the buffer size.
-		 */
-		if (nskip > 0) {
-			/* sanity check... */
-			if (rq->current_nr_sectors !=
-			    bio_cur_sectors(rq->bio)) {
-				printk(KERN_ERR PFX "%s: %s: buffer botch (%u)\n",
-						drive->name, __func__,
-						rq->current_nr_sectors);
-				cdrom_end_request(drive, 0);
-				return ide_stopped;
-			}
-			rq->current_nr_sectors += nskip;
-		}
-	}
-
-	/* set up the command */
-	rq->timeout = ATAPI_WAIT_PC;
-
-	return ide_started;
-}
-
-/*
- * Fix up a possibly partially-processed request so that we can start it over
- * entirely, or even put it back on the request queue.
- */
-static void ide_cd_restore_request(ide_drive_t *drive, struct request *rq)
-{
-
-	ide_debug_log(IDE_DBG_FUNC, "enter");
-
-	if (rq->buffer != bio_data(rq->bio)) {
-		sector_t n =
-			(rq->buffer - (char *)bio_data(rq->bio)) / SECTOR_SIZE;
-
-		rq->buffer = bio_data(rq->bio);
-		rq->nr_sectors += n;
-		rq->sector -= n;
-	}
-	rq->current_nr_sectors = bio_cur_sectors(rq->bio);
-	rq->hard_cur_sectors = rq->current_nr_sectors;
-	rq->hard_nr_sectors = rq->nr_sectors;
-	rq->hard_sector = rq->sector;
-	rq->q->prep_rq_fn(rq->q, rq);
-}
-
-static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct request *rq)
-{
 	ide_debug_log(IDE_DBG_FUNC, "rq->cmd[0]: 0x%x", rq->cmd[0]);
 
 	/*
@@ -664,11 +520,14 @@ static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct request *rq)
 	 * and some drives don't send them.  Sigh.
 	 */
 	if (rq->cmd[0] == GPCMD_REQUEST_SENSE &&
-	    rq->data_len > 0 && rq->data_len <= 5)
-		while (rq->data_len > 0) {
-			*(u8 *)rq->data++ = 0;
-			--rq->data_len;
+	    cmd->nleft > 0 && cmd->nleft <= 5) {
+		unsigned int ofs = cmd->nbytes - cmd->nleft;
+
+		while (cmd->nleft > 0) {
+			*((u8 *)rq->data + ofs++) = 0;
+			cmd->nleft--;
 		}
+	}
 }
 
 int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
@@ -748,24 +607,26 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 	return (flags & REQ_FAILED) ? -EIO : 0;
 }
 
-/*
- * Called from blk_end_request_callback() after the data of the request is
- * completed and before the request itself is completed. By returning value '1',
- * blk_end_request_callback() returns immediately without completing it.
- */
-static int cdrom_newpc_intr_dummy_cb(struct request *rq)
+static void ide_cd_error_cmd(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	return 1;
+	unsigned int nr_bytes = cmd->nbytes - cmd->nleft;
+
+	if (cmd->tf_flags & IDE_TFLAG_WRITE)
+		nr_bytes -= cmd->last_xfer_len;
+
+	if (nr_bytes > 0)
+		ide_complete_rq(drive, 0, nr_bytes);
 }
 
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_cmd *cmd = &hwif->cmd;
 	struct request *rq = hwif->rq;
-	xfer_func_t *xferfunc;
 	ide_expiry_t *expiry = NULL;
 	int dma_error = 0, dma, stat, thislen, uptodate = 0;
-	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0;
+	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc, nsectors;
+	int sense = blk_sense_request(rq);
 	unsigned int timeout;
 	u16 len;
 	u8 ireason;
@@ -777,7 +638,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	dma = drive->dma;
 	if (dma) {
 		drive->dma = 0;
+		drive->waiting_for_dma = 0;
 		dma_error = hwif->dma_ops->dma_end(drive);
+		ide_dma_unmap_sg(drive, cmd);
 		if (dma_error) {
 			printk(KERN_ERR PFX "%s: DMA %s error\n", drive->name,
 					write ? "write" : "read");
@@ -785,27 +648,24 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		}
 	}
 
-	if (cdrom_decode_status(drive, 0, &stat))
+	rc = cdrom_decode_status(drive, 0, &stat);
+	if (rc) {
+		if (rc == 2)
+			goto out_end;
 		return ide_stopped;
+	}
 
 	/* using dma, transfer is complete now */
 	if (dma) {
 		if (dma_error)
 			return ide_error(drive, "dma error", stat);
-		if (blk_fs_request(rq)) {
-			ide_complete_rq(drive, 0, rq->nr_sectors
-				? (rq->nr_sectors << 9) : ide_rq_bytes(rq));
-			return ide_stopped;
-		} else if (rq->cmd_type == REQ_TYPE_ATA_PC && !rq->bio) {
-			ide_complete_rq(drive, 0, 512);
-			return ide_stopped;
-		}
-		goto end_request;
+		uptodate = 1;
+		goto out_end;
 	}
 
 	ide_read_bcount_and_ireason(drive, &len, &ireason);
 
-	thislen = blk_fs_request(rq) ? len : rq->data_len;
+	thislen = blk_fs_request(rq) ? len : cmd->nleft;
 	if (thislen > len)
 		thislen = len;
 
@@ -820,60 +680,30 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			 * Otherwise, complete the command normally.
 			 */
 			uptodate = 1;
-			if (rq->current_nr_sectors > 0) {
+			if (cmd->nleft > 0) {
 				printk(KERN_ERR PFX "%s: %s: data underrun "
-						"(%d blocks)\n",
-						drive->name, __func__,
-						rq->current_nr_sectors);
+					"(%u bytes)\n", drive->name, __func__,
+					cmd->nleft);
 				if (!write)
 					rq->cmd_flags |= REQ_FAILED;
 				uptodate = 0;
 			}
-			cdrom_end_request(drive, uptodate);
-			return ide_stopped;
 		} else if (!blk_pc_request(rq)) {
-			ide_cd_request_sense_fixup(drive, rq);
+			ide_cd_request_sense_fixup(drive, cmd);
 			/* complain if we still have data left to transfer */
-			uptodate = rq->data_len ? 0 : 1;
+			uptodate = cmd->nleft ? 0 : 1;
+			if (uptodate == 0)
+				rq->cmd_flags |= REQ_FAILED;
 		}
-		goto end_request;
+		goto out_end;
 	}
 
 	/* check which way to transfer data */
-	if (ide_cd_check_ireason(drive, rq, len, ireason, write))
-		return ide_stopped;
+	rc = ide_cd_check_ireason(drive, rq, len, ireason, write);
+	if (rc)
+		goto out_end;
 
-	if (blk_fs_request(rq)) {
-		if (write == 0) {
-			int nskip;
-
-			if (ide_cd_check_transfer_size(drive, len)) {
-				cdrom_end_request(drive, 0);
-				return ide_stopped;
-			}
-
-			/*
-			 * First, figure out if we need to bit-bucket
-			 * any of the leading sectors.
-			 */
-			nskip = min_t(int, rq->current_nr_sectors
-					   - bio_cur_sectors(rq->bio),
-					   thislen >> 9);
-			if (nskip > 0) {
-				ide_pad_transfer(drive, write, nskip << 9);
-				rq->current_nr_sectors -= nskip;
-				thislen -= (nskip << 9);
-			}
-		}
-	}
-
-	if (ireason == 0) {
-		write = 1;
-		xferfunc = hwif->tp_ops->output_data;
-	} else {
-		write = 0;
-		xferfunc = hwif->tp_ops->input_data;
-	}
+	cmd->last_xfer_len = 0;
 
 	ide_debug_log(IDE_DBG_PC, "data transfer, rq->cmd_type: 0x%x, "
 				  "ireason: 0x%x",
@@ -881,75 +711,31 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 
 	/* transfer data */
 	while (thislen > 0) {
-		u8 *ptr = blk_fs_request(rq) ? NULL : rq->data;
-		int blen = rq->data_len;
-
-		/* bio backed? */
-		if (rq->bio) {
-			if (blk_fs_request(rq)) {
-				ptr = rq->buffer;
-				blen = rq->current_nr_sectors << 9;
-			} else {
-				ptr = bio_data(rq->bio);
-				blen = bio_iovec(rq->bio)->bv_len;
-			}
-		}
+		int blen = min_t(int, thislen, cmd->nleft);
 
-		if (!ptr) {
-			if (blk_fs_request(rq) && !write)
-				/*
-				 * If the buffers are full, pipe the rest into
-				 * oblivion.
-				 */
-				ide_pad_transfer(drive, 0, thislen);
-			else {
-				printk(KERN_ERR PFX "%s: confused, missing data\n",
-						drive->name);
-				blk_dump_rq_flags(rq, rq_data_dir(rq)
-						  ? "cdrom_newpc_intr, write"
-						  : "cdrom_newpc_intr, read");
-			}
+		if (cmd->nleft == 0)
 			break;
-		}
-
-		if (blen > thislen)
-			blen = thislen;
 
-		xferfunc(drive, NULL, ptr, blen);
+		ide_pio_bytes(drive, cmd, write, blen);
+		cmd->last_xfer_len += blen;
 
 		thislen -= blen;
 		len -= blen;
 
-		if (blk_fs_request(rq)) {
-			rq->buffer += blen;
-			rq->nr_sectors -= (blen >> 9);
-			rq->current_nr_sectors -= (blen >> 9);
-			rq->sector += (blen >> 9);
-
-			if (rq->current_nr_sectors == 0 && rq->nr_sectors)
-				cdrom_end_request(drive, 1);
-		} else {
-			rq->data_len -= blen;
-
-			/*
-			 * The request can't be completed until DRQ is cleared.
-			 * So complete the data, but don't complete the request
-			 * using the dummy function for the callback feature
-			 * of blk_end_request_callback().
-			 */
-			if (rq->bio)
-				blk_end_request_callback(rq, 0, blen,
-						 cdrom_newpc_intr_dummy_cb);
-			else
-				rq->data += blen;
-		}
-		if (!write && blk_sense_request(rq))
+		if (sense && write == 0)
 			rq->sense_len += blen;
 	}
 
 	/* pad, if necessary */
-	if (!blk_fs_request(rq) && len > 0)
-		ide_pad_transfer(drive, write, len);
+	if (len > 0) {
+		if (blk_fs_request(rq) == 0 || write == 0)
+			ide_pad_transfer(drive, write, len);
+		else {
+			printk(KERN_ERR PFX "%s: confused, missing data\n",
+				drive->name);
+			blk_dump_rq_flags(rq, "cdrom_newpc_intr");
+		}
+	}
 
 	if (blk_pc_request(rq)) {
 		timeout = rq->timeout;
@@ -963,21 +749,50 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	ide_set_handler(drive, cdrom_newpc_intr, timeout);
 	return ide_started;
 
-end_request:
-	if (blk_pc_request(rq)) {
+out_end:
+	if (blk_pc_request(rq) && rc == 0) {
 		unsigned int dlen = rq->data_len;
 
-		if (dma)
-			rq->data_len = 0;
+		rq->data_len = 0;
 
 		if (blk_end_request(rq, 0, dlen))
 			BUG();
 
 		hwif->rq = NULL;
 	} else {
-		if (!uptodate)
-			rq->cmd_flags |= REQ_FAILED;
-		cdrom_end_request(drive, uptodate);
+		if (sense && uptodate)
+			ide_cd_complete_failed_rq(drive, rq);
+
+		if (blk_fs_request(rq)) {
+			if (cmd->nleft == 0)
+				uptodate = 1;
+		} else {
+			if (uptodate <= 0 && rq->errors == 0)
+				rq->errors = -EIO;
+		}
+
+		if (uptodate == 0)
+			ide_cd_error_cmd(drive, cmd);
+
+		/* make sure it's fully ended */
+		if (blk_pc_request(rq))
+			nsectors = (rq->data_len + 511) >> 9;
+		else
+			nsectors = rq->hard_nr_sectors;
+
+		if (nsectors == 0)
+			nsectors = 1;
+
+		if (blk_fs_request(rq) == 0) {
+			rq->data_len -= (cmd->nbytes - cmd->nleft);
+			if (uptodate == 0 && (cmd->tf_flags & IDE_TFLAG_WRITE))
+				rq->data_len += cmd->last_xfer_len;
+		}
+
+		ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
+
+		if (sense && rc == 2)
+			ide_error(drive, "request sense failure", stat);
 	}
 	return ide_stopped;
 }
@@ -985,42 +800,40 @@ end_request:
 static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 {
 	struct cdrom_info *cd = drive->driver_data;
+	struct request_queue *q = drive->queue;
 	int write = rq_data_dir(rq) == WRITE;
 	unsigned short sectors_per_frame =
-		queue_hardsect_size(drive->queue) >> SECTOR_BITS;
+		queue_hardsect_size(q) >> SECTOR_BITS;
 
-	ide_debug_log(IDE_DBG_RQ, "rq->cmd[0]: 0x%x, write: 0x%x, "
+	ide_debug_log(IDE_DBG_RQ, "rq->cmd[0]: 0x%x, rq->cmd_flags: 0x%x, "
 				  "secs_per_frame: %u",
-				  rq->cmd[0], write, sectors_per_frame);
+				  rq->cmd[0], rq->cmd_flags, sectors_per_frame);
 
 	if (write) {
 		/* disk has become write protected */
-		if (get_disk_ro(cd->disk)) {
-			cdrom_end_request(drive, 0);
+		if (get_disk_ro(cd->disk))
 			return ide_stopped;
-		}
 	} else {
 		/*
 		 * We may be retrying this request after an error.  Fix up any
 		 * weirdness which might be present in the request packet.
 		 */
-		ide_cd_restore_request(drive, rq);
+		q->prep_rq_fn(q, rq);
 	}
 
-	/* use DMA, if possible / writes *must* be hardware frame aligned */
+	/* fs requests *must* be hardware frame aligned */
 	if ((rq->nr_sectors & (sectors_per_frame - 1)) ||
-	    (rq->sector & (sectors_per_frame - 1))) {
-		if (write) {
-			cdrom_end_request(drive, 0);
-			return ide_stopped;
-		}
-		drive->dma = 0;
-	} else
-		drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
+	    (rq->sector & (sectors_per_frame - 1)))
+		return ide_stopped;
+
+	/* use DMA, if possible */
+	drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 
 	if (write)
 		cd->devinfo.media_written = 1;
 
+	rq->timeout = ATAPI_WAIT_PC;
+
 	return ide_started;
 }
 
@@ -1068,6 +881,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 					sector_t block)
 {
 	struct ide_cmd cmd;
+	int uptodate = 0, nsectors;
 
 	ide_debug_log(IDE_DBG_RQ, "cmd: 0x%x, block: %llu",
 				  rq->cmd[0], (unsigned long long)block);
@@ -1077,10 +891,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 
 	if (blk_fs_request(rq)) {
 		if (cdrom_start_rw(drive, rq) == ide_stopped)
-			return ide_stopped;
-
-		if (ide_cd_prepare_rw_request(drive, rq) == ide_stopped)
-			return ide_stopped;
+			goto out_end;
 	} else if (blk_sense_request(rq) || blk_pc_request(rq) ||
 		   rq->cmd_type == REQ_TYPE_ATA_PC) {
 		if (!rq->timeout)
@@ -1089,12 +900,13 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		cdrom_do_block_pc(drive, rq);
 	} else if (blk_special_request(rq)) {
 		/* right now this can only be a reset... */
-		cdrom_end_request(drive, 1);
-		return ide_stopped;
+		uptodate = 1;
+		goto out_end;
 	} else {
 		blk_dump_rq_flags(rq, DRV_NAME " bad flags");
-		cdrom_end_request(drive, 0);
-		return ide_stopped;
+		if (rq->errors == 0)
+			rq->errors = -EIO;
+		goto out_end;
 	}
 
 	memset(&cmd, 0, sizeof(cmd));
@@ -1104,7 +916,22 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 
 	cmd.rq = rq;
 
+	if (blk_fs_request(rq) || rq->data_len) {
+		ide_init_sg_cmd(&cmd, blk_fs_request(rq) ? (rq->nr_sectors << 9)
+							 : rq->data_len);
+		ide_map_sg(drive, &cmd);
+	}
+
 	return ide_issue_pc(drive, &cmd);
+out_end:
+	nsectors = rq->hard_nr_sectors;
+
+	if (nsectors == 0)
+		nsectors = 1;
+
+	ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
+
+	return ide_stopped;
 }
 
 /*
@@ -1696,9 +1523,6 @@ static const struct ide_proc_devset *ide_cd_proc_devsets(ide_drive_t *drive)
 #endif
 
 static const struct cd_list_entry ide_cd_quirks_list[] = {
-	/* Limit transfer size per interrupt. */
-	{ "SAMSUNG CD-ROM SCR-2430", NULL,   IDE_AFLAG_LIMIT_NFRAMES	     },
-	{ "SAMSUNG CD-ROM SCR-2432", NULL,   IDE_AFLAG_LIMIT_NFRAMES	     },
 	/* SCR-3231 doesn't support the SET_CD_SPEED command. */
 	{ "SAMSUNG CD-ROM SCR-3231", NULL,   IDE_AFLAG_NO_SPEED_SELECT	     },
 	/* Old NEC260 (not R) was released before ATAPI 1.2 spec. */
@@ -1759,18 +1583,18 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
+	struct request_queue *q = drive->queue;
 	u16 *id = drive->id;
 	char *fw_rev = (char *)&id[ATA_ID_FW_REV];
 	int nslots;
 
 	ide_debug_log(IDE_DBG_PROBE, "enter");
 
-	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
-	blk_queue_dma_alignment(drive->queue, 31);
-	blk_queue_update_dma_pad(drive->queue, 15);
-	drive->queue->unplug_delay = (1 * HZ) / 1000;
-	if (!drive->queue->unplug_delay)
-		drive->queue->unplug_delay = 1;
+	blk_queue_prep_rq(q, ide_cdrom_prep_fn);
+	blk_queue_dma_alignment(q, 31);
+	blk_queue_update_dma_pad(q, 15);
+
+	q->unplug_delay = max((1 * HZ) / 1000, 1);
 
 	drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
 	drive->atapi_flags = IDE_AFLAG_NO_EJECT | ide_cd_flags(id);
@@ -1788,8 +1612,7 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 
 	nslots = ide_cdrom_probe_capabilities(drive);
 
-	/* set correct block size */
-	blk_queue_hardsect_size(drive->queue, CD_FRAMESIZE);
+	blk_queue_hardsect_size(q, CD_FRAMESIZE);
 
 	if (ide_cdrom_register(drive, nslots)) {
 		printk(KERN_ERR PFX "%s: %s failed to register device with the"
@@ -1968,9 +1791,6 @@ static struct block_device_operations idecd_ops = {
 };
 
 /* module options */
-static char *ignore;
-module_param(ignore, charp, 0400);
-
 static unsigned long debug_mask;
 module_param(debug_mask, ulong, 0644);
 
@@ -1991,15 +1811,6 @@ static int ide_cd_probe(ide_drive_t *drive)
 	if (drive->media != ide_cdrom && drive->media != ide_optical)
 		goto failed;
 
-	/* skip drives that we were told to ignore */
-	if (ignore != NULL) {
-		if (strstr(ignore, drive->name)) {
-			printk(KERN_INFO PFX "ignoring drive %s\n",
-					 drive->name);
-			goto failed;
-		}
-	}
-
 	drive->debug_mask = debug_mask;
 	drive->irq_handler = cdrom_newpc_intr;
 
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index ca934c8..c998cf8 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -227,7 +227,7 @@ static u64 idedisk_read_native_max_address(ide_drive_t *drive, int lba48)
 	ide_no_data_taskfile(drive, &cmd);
 
 	/* if OK, compute maximum address value */
-	if ((tf->status & 0x01) == 0)
+	if (!(tf->status & ATA_ERR))
 		addr = ide_get_lba_addr(tf, lba48) + 1;
 
 	return addr;
@@ -267,7 +267,7 @@ static u64 idedisk_set_max_address(ide_drive_t *drive, u64 addr_req, int lba48)
 	ide_no_data_taskfile(drive, &cmd);
 
 	/* if OK, compute maximum address value */
-	if ((tf->status & 0x01) == 0)
+	if (!(tf->status & ATA_ERR))
 		addr_set = ide_get_lba_addr(tf, lba48) + 1;
 
 	return addr_set;
diff --git a/drivers/ide/ide-dma-sff.c b/drivers/ide/ide-dma-sff.c
index 75a9ea2..16fc46e 100644
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -38,10 +38,9 @@ int config_drive_for_dma(ide_drive_t *drive)
 	 * Enable DMA on any drive that has mode2 DMA
 	 * (multi or single) enabled
 	 */
-	if (id[ATA_ID_FIELD_VALID] & 2)	/* regular DMA */
-		if ((id[ATA_ID_MWDMA_MODES] & 0x404) == 0x404 ||
-		    (id[ATA_ID_SWDMA_MODES] & 0x404) == 0x404)
-			return 1;
+	if ((id[ATA_ID_MWDMA_MODES] & 0x404) == 0x404 ||
+	    (id[ATA_ID_SWDMA_MODES] & 0x404) == 0x404)
+		return 1;
 
 	/* Consult the list of known "good" drives */
 	if (ide_dma_good_drive(drive))
@@ -166,8 +165,6 @@ use_pio_instead:
 	printk(KERN_ERR "%s: %s\n", drive->name,
 		count ? "DMA table too small" : "empty DMA table?");
 
-	ide_destroy_dmatable(drive);
-
 	return 0; /* revert to PIO for this request */
 }
 EXPORT_SYMBOL_GPL(ide_build_dmatable);
@@ -218,7 +215,6 @@ int ide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 	/* clear INTR & ERROR flags */
 	ide_dma_sff_write_status(hwif, dma_stat | ATA_DMA_ERR | ATA_DMA_INTR);
 
-	drive->waiting_for_dma = 1;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ide_dma_setup);
@@ -292,8 +288,6 @@ int ide_dma_end(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = 0, dma_cmd = 0, mask;
 
-	drive->waiting_for_dma = 0;
-
 	/* stop DMA */
 	if (hwif->host_flags & IDE_HFLAG_MMIO) {
 		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
@@ -310,8 +304,6 @@ int ide_dma_end(ide_drive_t *drive)
 	/* clear INTR & ERROR bits */
 	ide_dma_sff_write_status(hwif, dma_stat | ATA_DMA_ERR | ATA_DMA_INTR);
 
-	/* purge DMA mappings */
-	ide_destroy_dmatable(drive);
 	wmb();
 
 	/* verify good DMA status */
@@ -338,9 +330,8 @@ const struct ide_dma_ops sff_dma_ops = {
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
-	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 EXPORT_SYMBOL_GPL(sff_dma_ops);
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 3dbf80c..a0b8cab 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -89,15 +89,16 @@ static const struct drive_list_entry drive_blacklist[] = {
 ide_startstop_t ide_dma_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_cmd *cmd = &hwif->cmd;
 	u8 stat = 0, dma_stat = 0;
 
+	drive->waiting_for_dma = 0;
 	dma_stat = hwif->dma_ops->dma_end(drive);
+	ide_dma_unmap_sg(drive, cmd);
 	stat = hwif->tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, DRIVE_READY, drive->bad_wstat | ATA_DRQ)) {
 		if (!dma_stat) {
-			struct ide_cmd *cmd = &hwif->cmd;
-
 			if ((cmd->tf_flags & IDE_TFLAG_FS) == 0)
 				ide_finish_cmd(drive, cmd, stat);
 			else
@@ -117,8 +118,8 @@ int ide_dma_good_drive(ide_drive_t *drive)
 }
 
 /**
- *	ide_build_sglist	-	map IDE scatter gather for DMA I/O
- *	@drive: the drive to build the DMA table for
+ *	ide_dma_map_sg	-	map IDE scatter gather for DMA I/O
+ *	@drive: the drive to map the DMA table for
  *	@cmd: command
  *
  *	Perform the DMA mapping magic necessary to access the source or
@@ -127,23 +128,19 @@ int ide_dma_good_drive(ide_drive_t *drive)
  *	operate in a portable fashion.
  */
 
-int ide_build_sglist(ide_drive_t *drive, struct ide_cmd *cmd)
+static int ide_dma_map_sg(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
 	int i;
 
-	ide_map_sg(drive, cmd);
-
 	if (cmd->tf_flags & IDE_TFLAG_WRITE)
 		cmd->sg_dma_direction = DMA_TO_DEVICE;
 	else
 		cmd->sg_dma_direction = DMA_FROM_DEVICE;
 
 	i = dma_map_sg(hwif->dev, sg, cmd->sg_nents, cmd->sg_dma_direction);
-	if (i == 0)
-		ide_map_sg(drive, cmd);
-	else {
+	if (i) {
 		cmd->orig_sg_nents = cmd->sg_nents;
 		cmd->sg_nents = i;
 	}
@@ -152,7 +149,7 @@ int ide_build_sglist(ide_drive_t *drive, struct ide_cmd *cmd)
 }
 
 /**
- *	ide_destroy_dmatable	-	clean up DMA mapping
+ *	ide_dma_unmap_sg	-	clean up DMA mapping
  *	@drive: The drive to unmap
  *
  *	Teardown mappings after DMA has completed. This must be called
@@ -162,15 +159,14 @@ int ide_build_sglist(ide_drive_t *drive, struct ide_cmd *cmd)
  *	time.
  */
 
-void ide_destroy_dmatable(ide_drive_t *drive)
+void ide_dma_unmap_sg(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct ide_cmd *cmd = &hwif->cmd;
 
 	dma_unmap_sg(hwif->dev, hwif->sg_table, cmd->orig_sg_nents,
 		     cmd->sg_dma_direction);
 }
-EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
+EXPORT_SYMBOL_GPL(ide_dma_unmap_sg);
 
 /**
  *	ide_dma_off_quietly	-	Generic DMA kill
@@ -249,12 +245,11 @@ static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base, u8 req_mode)
 	case XFER_UDMA_0:
 		if ((id[ATA_ID_FIELD_VALID] & 4) == 0)
 			break;
-
+		mask = id[ATA_ID_UDMA_MODES];
 		if (port_ops && port_ops->udma_filter)
-			mask = port_ops->udma_filter(drive);
+			mask &= port_ops->udma_filter(drive);
 		else
-			mask = hwif->ultra_mask;
-		mask &= id[ATA_ID_UDMA_MODES];
+			mask &= hwif->ultra_mask;
 
 		/*
 		 * avoid false cable warning from eighty_ninty_three()
@@ -265,18 +260,23 @@ static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base, u8 req_mode)
 		}
 		break;
 	case XFER_MW_DMA_0:
-		if ((id[ATA_ID_FIELD_VALID] & 2) == 0)
-			break;
+		mask = id[ATA_ID_MWDMA_MODES];
+
+		/* Also look for the CF specific MWDMA modes... */
+		if (ata_id_is_cfa(id) && (id[ATA_ID_CFA_MODES] & 0x38)) {
+			u8 mode = ((id[ATA_ID_CFA_MODES] & 0x38) >> 3) - 1;
+
+			mask |= ((2 << mode) - 1) << 3;
+		}
+
 		if (port_ops && port_ops->mdma_filter)
-			mask = port_ops->mdma_filter(drive);
+			mask &= port_ops->mdma_filter(drive);
 		else
-			mask = hwif->mwdma_mask;
-		mask &= id[ATA_ID_MWDMA_MODES];
+			mask &= hwif->mwdma_mask;
 		break;
 	case XFER_SW_DMA_0:
-		if (id[ATA_ID_FIELD_VALID] & 2) {
-			mask = id[ATA_ID_SWDMA_MODES] & hwif->swdma_mask;
-		} else if (id[ATA_ID_OLD_DMA_MODES] >> 8) {
+		mask = id[ATA_ID_SWDMA_MODES];
+		if (!(mask & ATA_SWDMA2) && (id[ATA_ID_OLD_DMA_MODES] >> 8)) {
 			u8 mode = id[ATA_ID_OLD_DMA_MODES] >> 8;
 
 			/*
@@ -284,8 +284,9 @@ static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base, u8 req_mode)
 			 * (the maximum allowed mode is XFER_SW_DMA_2)
 			 */
 			if (mode <= 2)
-				mask = ((2 << mode) - 1) & hwif->swdma_mask;
+				mask = (2 << mode) - 1;
 		}
+		mask &= hwif->swdma_mask;
 		break;
 	default:
 		BUG();
@@ -402,11 +403,10 @@ int ide_id_dma_bug(ide_drive_t *drive)
 		if ((id[ATA_ID_UDMA_MODES] >> 8) &&
 		    (id[ATA_ID_MWDMA_MODES] >> 8))
 			goto err_out;
-	} else if (id[ATA_ID_FIELD_VALID] & 2) {
-		if ((id[ATA_ID_MWDMA_MODES] >> 8) &&
-		    (id[ATA_ID_SWDMA_MODES] >> 8))
-			goto err_out;
-	}
+	} else if ((id[ATA_ID_MWDMA_MODES] >> 8) &&
+		   (id[ATA_ID_SWDMA_MODES] >> 8))
+		goto err_out;
+
 	return 0;
 err_out:
 	printk(KERN_ERR "%s: bad DMA info in identify block\n", drive->name);
@@ -460,21 +460,6 @@ void ide_dma_lost_irq(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_dma_lost_irq);
 
-void ide_dma_timeout(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	printk(KERN_ERR "%s: timeout waiting for DMA\n", drive->name);
-
-	if (hwif->dma_ops->dma_test_irq(drive))
-		return;
-
-	ide_dump_status(drive, "DMA timeout", hwif->tp_ops->read_status(hwif));
-
-	hwif->dma_ops->dma_end(drive);
-}
-EXPORT_SYMBOL_GPL(ide_dma_timeout);
-
 /*
  * un-busy the port etc, and clear any pending DMA status. we want to
  * retry the current request in pio mode instead of risking tossing it
@@ -483,6 +468,8 @@ EXPORT_SYMBOL_GPL(ide_dma_timeout);
 ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
+	struct ide_cmd *cmd = &hwif->cmd;
 	struct request *rq;
 	ide_startstop_t ret = ide_stopped;
 
@@ -492,12 +479,23 @@ ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 
 	if (error < 0) {
 		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
-		(void)hwif->dma_ops->dma_end(drive);
+		drive->waiting_for_dma = 0;
+		(void)dma_ops->dma_end(drive);
+		ide_dma_unmap_sg(drive, cmd);
 		ret = ide_error(drive, "dma timeout error",
 				hwif->tp_ops->read_status(hwif));
 	} else {
 		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
-		hwif->dma_ops->dma_timeout(drive);
+		if (dma_ops->dma_clear)
+			dma_ops->dma_clear(drive);
+		printk(KERN_ERR "%s: timeout waiting for DMA\n", drive->name);
+		if (dma_ops->dma_test_irq(drive) == 0) {
+			ide_dump_status(drive, "DMA timeout",
+					hwif->tp_ops->read_status(hwif));
+			drive->waiting_for_dma = 0;
+			(void)dma_ops->dma_end(drive);
+			ide_dma_unmap_sg(drive, cmd);
+		}
 	}
 
 	/*
@@ -567,3 +565,25 @@ int ide_allocate_dma_engine(ide_hwif_t *hwif)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ide_allocate_dma_engine);
+
+int ide_dma_prepare(ide_drive_t *drive, struct ide_cmd *cmd)
+{
+	const struct ide_dma_ops *dma_ops = drive->hwif->dma_ops;
+
+	if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
+	    (dma_ops->dma_check && dma_ops->dma_check(drive, cmd)))
+		goto out;
+	ide_map_sg(drive, cmd);
+	if (ide_dma_map_sg(drive, cmd) == 0)
+		goto out_map;
+	if (dma_ops->dma_setup(drive, cmd))
+		goto out_dma_unmap;
+	drive->waiting_for_dma = 1;
+	return 0;
+out_dma_unmap:
+	ide_dma_unmap_sg(drive, cmd);
+out_map:
+	ide_map_sg(drive, cmd);
+out:
+	return 1;
+}
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 1166497..5d5fb96 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -165,11 +165,12 @@ static ide_startstop_t do_reset1(ide_drive_t *, int);
 static ide_startstop_t atapi_reset_pollfunc(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u8 stat;
 
-	SELECT_DRIVE(drive);
+	tp_ops->dev_select(drive);
 	udelay(10);
-	stat = hwif->tp_ops->read_status(hwif);
+	stat = tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, 0, ATA_BUSY))
 		printk(KERN_INFO "%s: ATAPI reset complete\n", drive->name);
@@ -348,7 +349,7 @@ static ide_startstop_t do_reset1(ide_drive_t *drive, int do_not_try_atapi)
 	/* For an ATAPI device, first try an ATAPI SRST. */
 	if (drive->media != ide_disk && !do_not_try_atapi) {
 		pre_reset(drive);
-		SELECT_DRIVE(drive);
+		tp_ops->dev_select(drive);
 		udelay(20);
 		tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
 		ndelay(400);
@@ -401,15 +402,14 @@ static ide_startstop_t do_reset1(ide_drive_t *drive, int do_not_try_atapi)
 	 * immediate interrupt due to the edge transition it produces.
 	 * This single interrupt gives us a "fast poll" for drives that
 	 * recover from reset very quickly, saving us the first 50ms wait time.
-	 *
-	 * TODO: add ->softreset method and stop abusing ->set_irq
 	 */
 	/* set SRST and nIEN */
-	tp_ops->set_irq(hwif, 4);
+	tp_ops->write_devctl(hwif, ATA_SRST | ATA_NIEN | ATA_DEVCTL_OBS);
 	/* more than enough time */
 	udelay(10);
 	/* clear SRST, leave nIEN (unless device is on the quirk list) */
-	tp_ops->set_irq(hwif, drive->quirk_list == 2);
+	tp_ops->write_devctl(hwif, (drive->quirk_list == 2 ? 0 : ATA_NIEN) |
+			     ATA_DEVCTL_OBS);
 	/* more than enough time */
 	udelay(10);
 	hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 7ae6623..2b4868d 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -61,16 +61,6 @@
  */
 #define IDEFLOPPY_PC_DELAY	(HZ/20)	/* default delay for ZIP 100 (50ms) */
 
-static void idefloppy_update_buffers(ide_drive_t *drive,
-				struct ide_atapi_pc *pc)
-{
-	struct request *rq = pc->rq;
-	struct bio *bio = rq->bio;
-
-	while ((bio = rq->bio) != NULL)
-		ide_complete_rq(drive, 0, ide_rq_bytes(rq));
-}
-
 static int ide_floppy_callback(ide_drive_t *drive, int dsc)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
@@ -213,7 +203,6 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 	memcpy(rq->cmd, pc->c, 12);
 
 	pc->rq = rq;
-	pc->b_count = 0;
 	if (rq->cmd_flags & REQ_RW)
 		pc->flags |= PC_FLAG_WRITING;
 	pc->buf = NULL;
@@ -227,7 +216,6 @@ static void idefloppy_blockpc_cmd(struct ide_disk_obj *floppy,
 	ide_init_pc(pc);
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
 	pc->rq = rq;
-	pc->b_count = 0;
 	if (rq->data_len && rq_data_dir(rq) == WRITE)
 		pc->flags |= PC_FLAG_WRITING;
 	pc->buf = rq->data;
@@ -244,10 +232,11 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 					     struct request *rq, sector_t block)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
-	ide_hwif_t *hwif = drive->hwif;
 	struct ide_cmd cmd;
 	struct ide_atapi_pc *pc;
 
+	ide_debug_log(IDE_DBG_FUNC, "enter, cmd: 0x%x\n", rq->cmd[0]);
+
 	if (drive->debug_mask & IDE_DBG_RQ)
 		blk_dump_rq_flags(rq, (rq->rq_disk
 					? rq->rq_disk->disk_name
@@ -294,13 +283,10 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 	cmd.rq = rq;
 
 	if (blk_fs_request(rq) || pc->req_xfer) {
-		ide_init_sg_cmd(&cmd, rq->nr_sectors << 9);
+		ide_init_sg_cmd(&cmd, pc->req_xfer);
 		ide_map_sg(drive, &cmd);
 	}
 
-	pc->sg = hwif->sg_table;
-	pc->sg_cnt = cmd.sg_nents;
-
 	pc->rq = rq;
 
 	return ide_floppy_issue_pc(drive, &cmd, pc);
@@ -385,9 +371,11 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	struct gendisk *disk = floppy->disk;
 	struct ide_atapi_pc pc;
 	u8 *cap_desc;
-	u8 header_len, desc_cnt;
+	u8 pc_buf[256], header_len, desc_cnt;
 	int i, rc = 1, blocks, length;
 
+	ide_debug_log(IDE_DBG_FUNC, "enter");
+
 	drive->bios_cyl = 0;
 	drive->bios_head = drive->bios_sect = 0;
 	floppy->blocks = 0;
@@ -395,6 +383,9 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	drive->capacity64 = 0;
 
 	ide_floppy_create_read_capacity_cmd(&pc);
+	pc.buf = &pc_buf[0];
+	pc.buf_size = sizeof(pc_buf);
+
 	if (ide_queue_pc_tail(drive, disk, &pc)) {
 		printk(KERN_ERR PFX "Can't get floppy parameters\n");
 		return 1;
@@ -485,8 +476,6 @@ static void ide_floppy_setup(ide_drive_t *drive)
 	u16 *id = drive->id;
 
 	drive->pc_callback	 = ide_floppy_callback;
-	drive->pc_update_buffers = idefloppy_update_buffers;
-	drive->pc_io_buffers	 = ide_io_buffers;
 
 	/*
 	 * We used to check revisions here. At this point however I'm giving up.
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index 8f8be85..cd8a420 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -36,9 +36,9 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 					    int __user *arg)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
-	u8 header_len, desc_cnt;
 	int i, blocks, length, u_array_size, u_index;
 	int __user *argp;
+	u8 pc_buf[256], header_len, desc_cnt;
 
 	if (get_user(u_array_size, arg))
 		return -EFAULT;
@@ -47,6 +47,9 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 		return -EINVAL;
 
 	ide_floppy_create_read_capacity_cmd(pc);
+	pc->buf = &pc_buf[0];
+	pc->buf_size = sizeof(pc_buf);
+
 	if (ide_queue_pc_tail(drive, floppy->disk, pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return -EIO;
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 9d03e82..7812ca0 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -1,27 +1,22 @@
 /*
  * generic/default IDE host driver
  *
- * Copyright (C) 2004, 2008 Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2004, 2008-2009 Bartlomiej Zolnierkiewicz
  * This code was split off from ide.c.  See it for original copyrights.
  *
  * May be copied or modified under the terms of the GNU General Public License.
  */
 
-/*
- * For special cases new interfaces may be added using sysfs, i.e.
- *
- *	echo -n "0x168:0x36e:10" > /sys/class/ide_generic/add
- *
- * will add an interface using I/O ports 0x168-0x16f/0x36e and IRQ 10.
- */
-
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/ide.h>
 #include <linux/pci_ids.h>
 
-/* FIXME: convert m32r to use ide_platform host driver */
+/* FIXME: convert arm and m32r to use ide_platform host driver */
+#ifdef CONFIG_ARM
+#include <asm/irq.h>
+#endif
 #ifdef CONFIG_M32R
 #include <asm/m32r.h>
 #endif
@@ -36,62 +31,11 @@ static const struct ide_port_info ide_generic_port_info = {
 	.host_flags		= IDE_HFLAG_NO_DMA,
 };
 
-static ssize_t store_add(struct class *cls, const char *buf, size_t n)
-{
-	unsigned int base, ctl;
-	int irq, rc;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-
-	if (sscanf(buf, "%x:%x:%d", &base, &ctl, &irq) != 3)
-		return -EINVAL;
-
-	memset(&hw, 0, sizeof(hw));
-	ide_std_init_ports(&hw, base, ctl);
-	hw.irq = irq;
-	hw.chipset = ide_generic;
-
-	rc = ide_host_add(&ide_generic_port_info, hws, NULL);
-	if (rc)
-		return rc;
-
-	return n;
-};
-
-static struct class_attribute ide_generic_class_attrs[] = {
-	__ATTR(add, S_IWUSR, NULL, store_add),
-	__ATTR_NULL
-};
-
-static void ide_generic_class_release(struct class *cls)
-{
-	kfree(cls);
-}
-
-static int __init ide_generic_sysfs_init(void)
-{
-	struct class *cls;
-	int rc;
-
-	cls = kzalloc(sizeof(*cls), GFP_KERNEL);
-	if (!cls)
-		return -ENOMEM;
-
-	cls->name = DRV_NAME;
-	cls->owner = THIS_MODULE;
-	cls->class_release = ide_generic_class_release;
-	cls->class_attrs = ide_generic_class_attrs;
-
-	rc = class_register(cls);
-	if (rc) {
-		kfree(cls);
-		return rc;
-	}
-
-	return 0;
-}
-
-#if defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_MAPPI2) \
-	|| defined(CONFIG_PLAT_OPSPUT)
+#ifdef CONFIG_ARM
+static const u16 legacy_bases[] = { 0x1f0 };
+static const int legacy_irqs[]  = { IRQ_HARDDISK };
+#elif defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_MAPPI2) || \
+      defined(CONFIG_PLAT_OPSPUT)
 static const u16 legacy_bases[] = { 0x1f0 };
 static const int legacy_irqs[]  = { PLD_IRQ_CFIREQ };
 #elif defined(CONFIG_PLAT_MAPPI3)
@@ -107,11 +51,11 @@ static const int legacy_irqs[]  = { 14, 15, 11, 10, 8, 12 };
 
 static void ide_generic_check_pci_legacy_iobases(int *primary, int *secondary)
 {
+#ifdef CONFIG_PCI
 	struct pci_dev *p = NULL;
 	u16 val;
 
 	for_each_pci_dev(p) {
-
 		if (pci_resource_start(p, 0) == 0x1f0)
 			*primary = 1;
 		if (pci_resource_start(p, 2) == 0x170)
@@ -126,7 +70,6 @@ static void ide_generic_check_pci_legacy_iobases(int *primary, int *secondary)
 		/* Intel MPIIX - PIO ATA on non PCI side of bridge */
 		if (p->vendor == PCI_VENDOR_ID_INTEL &&
 		    p->device == PCI_DEVICE_ID_INTEL_82371MX) {
-
 			pci_read_config_word(p, 0x6C, &val);
 			if (val & 0x8000) {
 				/* ATA port enabled */
@@ -137,6 +80,7 @@ static void ide_generic_check_pci_legacy_iobases(int *primary, int *secondary)
 			}
 		}
 	}
+#endif
 }
 
 static int __init ide_generic_init(void)
@@ -168,6 +112,7 @@ static int __init ide_generic_init(void)
 				printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX "
 						"not free.\n",
 						DRV_NAME, io_addr, io_addr + 7);
+				rc = -EBUSY;
 				continue;
 			}
 
@@ -176,6 +121,7 @@ static int __init ide_generic_init(void)
 						"not free.\n",
 						DRV_NAME, io_addr + 0x206);
 				release_region(io_addr, 8);
+				rc = -EBUSY;
 				continue;
 			}
 
@@ -196,10 +142,6 @@ static int __init ide_generic_init(void)
 		}
 	}
 
-	if (ide_generic_sysfs_init())
-		printk(KERN_ERR DRV_NAME ": failed to create ide_generic "
-					 "class\n");
-
 	return rc;
 }
 
diff --git a/drivers/ide/ide-h8300.c b/drivers/ide/ide-h8300.c
index ff8339e..dac9a6d 100644
--- a/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -54,9 +54,6 @@ static void h8300_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA)
-		mm_outw((tf->hob_data << 8) | tf->data, io_ports->data_addr);
-
 	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		outb(tf->hob_feature, io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
@@ -90,18 +87,11 @@ static void h8300_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &cmd->tf;
 
-	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
-		u16 data = mm_inw(io_ports->data_addr);
-
-		tf->data = data & 0xff;
-		tf->hob_data = (data >> 8) & 0xff;
-	}
-
 	/* be sure we're looking at the low order bits */
-	outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
+	outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
-		tf->feature = inb(io_ports->feature_addr);
+	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
+		tf->error  = inb(io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = inb(io_ports->nsect_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
@@ -114,18 +104,18 @@ static void h8300_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 		tf->device = inb(io_ports->device_addr);
 
 	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
+		outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature = inb(io_ports->feature_addr);
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
+			tf->hob_error = inb(io_ports->feature_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = inb(io_ports->nsect_addr);
+			tf->hob_nsect = inb(io_ports->nsect_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = inb(io_ports->lbal_addr);
+			tf->hob_lbal  = inb(io_ports->lbal_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = inb(io_ports->lbam_addr);
+			tf->hob_lbam  = inb(io_ports->lbam_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = inb(io_ports->lbah_addr);
+			tf->hob_lbah  = inb(io_ports->lbah_addr);
 	}
 }
 
@@ -159,9 +149,9 @@ static const struct ide_tp_ops h8300_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
 
-	.set_irq		= ide_set_irq,
-
+	.dev_select		= ide_dev_select,
 	.tf_load		= h8300_tf_load,
 	.tf_read		= h8300_tf_read,
 
diff --git a/drivers/ide/ide-io-std.c b/drivers/ide/ide-io-std.c
index 2d9c6dc..9cac281 100644
--- a/drivers/ide/ide-io-std.c
+++ b/drivers/ide/ide-io-std.c
@@ -64,23 +64,26 @@ u8 ide_read_altstatus(ide_hwif_t *hwif)
 }
 EXPORT_SYMBOL_GPL(ide_read_altstatus);
 
-void ide_set_irq(ide_hwif_t *hwif, int on)
+void ide_write_devctl(ide_hwif_t *hwif, u8 ctl)
 {
-	u8 ctl = ATA_DEVCTL_OBS;
-
-	if (on == 4) { /* hack for SRST */
-		ctl |= 4;
-		on &= ~4;
-	}
-
-	ctl |= on ? 0 : 2;
-
 	if (hwif->host_flags & IDE_HFLAG_MMIO)
 		writeb(ctl, (void __iomem *)hwif->io_ports.ctl_addr);
 	else
 		outb(ctl, hwif->io_ports.ctl_addr);
 }
-EXPORT_SYMBOL_GPL(ide_set_irq);
+EXPORT_SYMBOL_GPL(ide_write_devctl);
+
+void ide_dev_select(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 select = drive->select | ATA_DEVICE_OBS;
+
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writeb(select, (void __iomem *)hwif->io_ports.device_addr);
+	else
+		outb(select, hwif->io_ports.device_addr);
+}
+EXPORT_SYMBOL_GPL(ide_dev_select);
 
 void ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
@@ -99,15 +102,6 @@ void ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA) {
-		u16 data = (tf->hob_data << 8) | tf->data;
-
-		if (mmio)
-			writew(data, (void __iomem *)io_ports->data_addr);
-		else
-			outw(data, io_ports->data_addr);
-	}
-
 	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		tf_outb(tf->hob_feature, io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
@@ -153,23 +147,11 @@ void ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 		tf_inb  = ide_inb;
 	}
 
-	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
-		u16 data;
-
-		if (mmio)
-			data = readw((void __iomem *)io_ports->data_addr);
-		else
-			data = inw(io_ports->data_addr);
-
-		tf->data = data & 0xff;
-		tf->hob_data = (data >> 8) & 0xff;
-	}
-
 	/* be sure we're looking at the low order bits */
-	tf_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
+	tf_outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
-		tf->feature = tf_inb(io_ports->feature_addr);
+	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
+		tf->error  = tf_inb(io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = tf_inb(io_ports->nsect_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
@@ -182,18 +164,18 @@ void ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 		tf->device = tf_inb(io_ports->device_addr);
 
 	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		tf_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
+		tf_outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature = tf_inb(io_ports->feature_addr);
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
+			tf->hob_error = tf_inb(io_ports->feature_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = tf_inb(io_ports->nsect_addr);
+			tf->hob_nsect = tf_inb(io_ports->nsect_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = tf_inb(io_ports->lbal_addr);
+			tf->hob_lbal  = tf_inb(io_ports->lbal_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = tf_inb(io_ports->lbam_addr);
+			tf->hob_lbam  = tf_inb(io_ports->lbam_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = tf_inb(io_ports->lbah_addr);
+			tf->hob_lbah  = tf_inb(io_ports->lbah_addr);
 	}
 }
 EXPORT_SYMBOL_GPL(ide_tf_read);
@@ -225,11 +207,10 @@ void ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd, void *buf,
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	unsigned long data_addr = io_ports->data_addr;
+	unsigned int words = (len + 1) >> 1;
 	u8 io_32bit = drive->io_32bit;
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
-	len++;
-
 	if (io_32bit) {
 		unsigned long uninitialized_var(flags);
 
@@ -238,27 +219,26 @@ void ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd, void *buf,
 			ata_vlb_sync(io_ports->nsect_addr);
 		}
 
+		words >>= 1;
 		if (mmio)
-			__ide_mm_insl((void __iomem *)data_addr, buf, len / 4);
+			__ide_mm_insl((void __iomem *)data_addr, buf, words);
 		else
-			insl(data_addr, buf, len / 4);
+			insl(data_addr, buf, words);
 
 		if ((io_32bit & 2) && !mmio)
 			local_irq_restore(flags);
 
-		if ((len & 3) >= 2) {
-			if (mmio)
-				__ide_mm_insw((void __iomem *)data_addr,
-						(u8 *)buf + (len & ~3), 1);
-			else
-				insw(data_addr, (u8 *)buf + (len & ~3), 1);
-		}
-	} else {
-		if (mmio)
-			__ide_mm_insw((void __iomem *)data_addr, buf, len / 2);
-		else
-			insw(data_addr, buf, len / 2);
+		if (((len + 1) & 3) < 2)
+			return;
+
+		buf += len & ~3;
+		words = 1;
 	}
+
+	if (mmio)
+		__ide_mm_insw((void __iomem *)data_addr, buf, words);
+	else
+		insw(data_addr, buf, words);
 }
 EXPORT_SYMBOL_GPL(ide_input_data);
 
@@ -271,11 +251,10 @@ void ide_output_data(ide_drive_t *drive, struct ide_cmd *cmd, void *buf,
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	unsigned long data_addr = io_ports->data_addr;
+	unsigned int words = (len + 1) >> 1;
 	u8 io_32bit = drive->io_32bit;
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
-	len++;
-
 	if (io_32bit) {
 		unsigned long uninitialized_var(flags);
 
@@ -284,27 +263,26 @@ void ide_output_data(ide_drive_t *drive, struct ide_cmd *cmd, void *buf,
 			ata_vlb_sync(io_ports->nsect_addr);
 		}
 
+		words >>= 1;
 		if (mmio)
-			__ide_mm_outsl((void __iomem *)data_addr, buf, len / 4);
+			__ide_mm_outsl((void __iomem *)data_addr, buf, words);
 		else
-			outsl(data_addr, buf, len / 4);
+			outsl(data_addr, buf, words);
 
 		if ((io_32bit & 2) && !mmio)
 			local_irq_restore(flags);
 
-		if ((len & 3) >= 2) {
-			if (mmio)
-				__ide_mm_outsw((void __iomem *)data_addr,
-						 (u8 *)buf + (len & ~3), 1);
-			else
-				outsw(data_addr, (u8 *)buf + (len & ~3), 1);
-		}
-	} else {
-		if (mmio)
-			__ide_mm_outsw((void __iomem *)data_addr, buf, len / 2);
-		else
-			outsw(data_addr, buf, len / 2);
+		if (((len + 1) & 3) < 2)
+			return;
+
+		buf += len & ~3;
+		words = 1;
 	}
+
+	if (mmio)
+		__ide_mm_outsw((void __iomem *)data_addr, buf, words);
+	else
+		outsw(data_addr, buf, words);
 }
 EXPORT_SYMBOL_GPL(ide_output_data);
 
@@ -312,9 +290,9 @@ const struct ide_tp_ops default_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
 
-	.set_irq		= ide_set_irq,
-
+	.dev_select		= ide_dev_select,
 	.tf_load		= ide_tf_load,
 	.tf_read		= ide_tf_read,
 
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 1adc5e2..1deb6d2 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -73,6 +73,7 @@ EXPORT_SYMBOL_GPL(ide_end_rq);
 
 void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 {
+	const struct ide_tp_ops *tp_ops = drive->hwif->tp_ops;
 	struct ide_taskfile *tf = &cmd->tf;
 	struct request *rq = cmd->rq;
 	u8 tf_cmd = tf->command;
@@ -80,7 +81,16 @@ void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 	tf->error = err;
 	tf->status = stat;
 
-	drive->hwif->tp_ops->tf_read(drive, cmd);
+	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
+		u8 data[2];
+
+		tp_ops->input_data(drive, cmd, data, 2);
+
+		tf->data = data[0];
+		tf->hob_data = data[1];
+	}
+
+	tp_ops->tf_read(drive, cmd);
 
 	if ((cmd->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) &&
 	    tf_cmd == ATA_CMD_IDLEIMMEDIATE) {
@@ -338,7 +348,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 	if (blk_pm_request(rq))
 		ide_check_pm_state(drive, rq);
 
-	SELECT_DRIVE(drive);
+	drive->hwif->tp_ops->dev_select(drive);
 	if (ide_wait_stat(&startstop, drive, drive->ready_stat,
 			  ATA_BUSY | ATA_DRQ, WAIT_READY)) {
 		printk(KERN_ERR "%s: drive not ready for command\n", drive->name);
@@ -481,11 +491,10 @@ repeat:
 		prev_port = hwif->host->cur_port;
 		hwif->rq = NULL;
 
-		if (drive->dev_flags & IDE_DFLAG_SLEEPING) {
-			if (time_before(drive->sleep, jiffies)) {
-				ide_unlock_port(hwif);
-				goto plug_device;
-			}
+		if (drive->dev_flags & IDE_DFLAG_SLEEPING &&
+		    time_after(drive->sleep, jiffies)) {
+			ide_unlock_port(hwif);
+			goto plug_device;
 		}
 
 		if ((hwif->host->host_flags & IDE_HFLAG_SERIALIZE) &&
@@ -495,7 +504,9 @@ repeat:
 			 * quirk_list may not like intr setups/cleanups
 			 */
 			if (prev_port && prev_port->cur_dev->quirk_list == 0)
-				prev_port->tp_ops->set_irq(prev_port, 0);
+				prev_port->tp_ops->write_devctl(prev_port,
+								ATA_NIEN |
+								ATA_DEVCTL_OBS);
 
 			hwif->host->cur_port = hwif;
 		}
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 5403e4a..27bb70d 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -27,21 +27,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-void SELECT_DRIVE(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_port_ops *port_ops = hwif->port_ops;
-	struct ide_cmd cmd;
-
-	if (port_ops && port_ops->selectproc)
-		port_ops->selectproc(drive);
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.tf_flags = IDE_TFLAG_OUT_DEVICE;
-
-	drive->hwif->tp_ops->tf_load(drive, &cmd);
-}
-
 void SELECT_MASK(ide_drive_t *drive, int mask)
 {
 	const struct ide_port_ops *port_ops = drive->hwif->port_ops;
@@ -55,7 +40,7 @@ u8 ide_read_error(ide_drive_t *drive)
 	struct ide_cmd cmd;
 
 	memset(&cmd, 0, sizeof(cmd));
-	cmd.tf_flags = IDE_TFLAG_IN_FEATURE;
+	cmd.tf_flags = IDE_TFLAG_IN_ERROR;
 
 	drive->hwif->tp_ops->tf_read(drive, &cmd);
 
@@ -306,6 +291,7 @@ int ide_driveid_update(ide_drive_t *drive)
 	drive->id[ATA_ID_UDMA_MODES]  = id[ATA_ID_UDMA_MODES];
 	drive->id[ATA_ID_MWDMA_MODES] = id[ATA_ID_MWDMA_MODES];
 	drive->id[ATA_ID_SWDMA_MODES] = id[ATA_ID_SWDMA_MODES];
+	drive->id[ATA_ID_CFA_MODES]   = id[ATA_ID_CFA_MODES];
 	/* anything more ? */
 
 	kfree(id);
@@ -356,10 +342,10 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 	disable_irq_nosync(hwif->irq);
 
 	udelay(1);
-	SELECT_DRIVE(drive);
+	tp_ops->dev_select(drive);
 	SELECT_MASK(drive, 1);
 	udelay(1);
-	tp_ops->set_irq(hwif, 0);
+	tp_ops->write_devctl(hwif, ATA_NIEN | ATA_DEVCTL_OBS);
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT;
@@ -371,7 +357,7 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 	tp_ops->exec_command(hwif, ATA_CMD_SET_FEATURES);
 
 	if (drive->quirk_list == 2)
-		tp_ops->set_irq(hwif, 1);
+		tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
 
 	error = __ide_wait_stat(drive, drive->ready_stat,
 				ATA_BUSY | ATA_DRQ | ATA_ERR,
@@ -386,9 +372,14 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 		return error;
 	}
 
-	id[ATA_ID_UDMA_MODES]  &= ~0xFF00;
-	id[ATA_ID_MWDMA_MODES] &= ~0x0F00;
-	id[ATA_ID_SWDMA_MODES] &= ~0x0F00;
+	if (speed >= XFER_SW_DMA_0) {
+		id[ATA_ID_UDMA_MODES]  &= ~0xFF00;
+		id[ATA_ID_MWDMA_MODES] &= ~0x0700;
+		id[ATA_ID_SWDMA_MODES] &= ~0x0700;
+		if (ata_id_is_cfa(id))
+			id[ATA_ID_CFA_MODES] &= ~0x0E00;
+	} else	if (ata_id_is_cfa(id))
+		id[ATA_ID_CFA_MODES] &= ~0x01C0;
 
  skip:
 #ifdef CONFIG_BLK_DEV_IDEDMA
@@ -401,12 +392,18 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 	if (speed >= XFER_UDMA_0) {
 		i = 1 << (speed - XFER_UDMA_0);
 		id[ATA_ID_UDMA_MODES] |= (i << 8 | i);
+	} else if (ata_id_is_cfa(id) && speed >= XFER_MW_DMA_3) {
+		i = speed - XFER_MW_DMA_2;
+		id[ATA_ID_CFA_MODES] |= i << 9;
 	} else if (speed >= XFER_MW_DMA_0) {
 		i = 1 << (speed - XFER_MW_DMA_0);
 		id[ATA_ID_MWDMA_MODES] |= (i << 8 | i);
 	} else if (speed >= XFER_SW_DMA_0) {
 		i = 1 << (speed - XFER_SW_DMA_0);
 		id[ATA_ID_SWDMA_MODES] |= (i << 8 | i);
+	} else if (ata_id_is_cfa(id) && speed >= XFER_PIO_5) {
+		i = speed - XFER_PIO_4;
+		id[ATA_ID_CFA_MODES] |= i << 6;
 	}
 
 	if (!drive->init_speed)
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index ebf2d21..bb7858e 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -223,6 +223,7 @@ void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 		 * point.
 		 */
 		ide_hwif_t *hwif = drive->hwif;
+		const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 		struct request_queue *q = drive->queue;
 		unsigned long flags;
 		int rc;
@@ -232,8 +233,8 @@ void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 		rc = ide_wait_not_busy(hwif, 35000);
 		if (rc)
 			printk(KERN_WARNING "%s: bus not ready on wakeup\n", drive->name);
-		SELECT_DRIVE(drive);
-		hwif->tp_ops->set_irq(hwif, 1);
+		tp_ops->dev_select(drive);
+		tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
 		rc = ide_wait_not_busy(hwif, 100000);
 		if (rc)
 			printk(KERN_WARNING "%s: drive not ready on wakeup\n", drive->name);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 5488645..d8c1c3e 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -260,7 +260,7 @@ int ide_dev_read_id(ide_drive_t *drive, u8 cmd, u16 *id)
 	 * during the identify phase that the IRQ handler isn't expecting.
 	 */
 	if (io_ports->ctl_addr)
-		tp_ops->set_irq(hwif, 0);
+		tp_ops->write_devctl(hwif, ATA_NIEN | ATA_DEVCTL_OBS);
 
 	/* take a deep breath */
 	msleep(50);
@@ -390,13 +390,13 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 	 * (e.g. crw9624 as drive0 with disk as slave)
 	 */
 	msleep(50);
-	SELECT_DRIVE(drive);
+	tp_ops->dev_select(drive);
 	msleep(50);
 
 	if (ide_read_device(drive) != drive->select && present == 0) {
 		if (drive->dn & 1) {
 			/* exit with drive0 selected */
-			SELECT_DRIVE(hwif->devices[0]);
+			tp_ops->dev_select(hwif->devices[0]);
 			/* allow ATA_BUSY to assert & clear */
 			msleep(50);
 		}
@@ -422,7 +422,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			printk(KERN_ERR "%s: no response (status = 0x%02x), "
 					"resetting drive\n", drive->name, stat);
 			msleep(50);
-			SELECT_DRIVE(drive);
+			tp_ops->dev_select(drive);
 			msleep(50);
 			tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
 			(void)ide_busy_sleep(hwif, WAIT_WORSTCASE, 0);
@@ -441,7 +441,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 	}
 	if (drive->dn & 1) {
 		/* exit with drive0 selected */
-		SELECT_DRIVE(hwif->devices[0]);
+		tp_ops->dev_select(hwif->devices[0]);
 		msleep(50);
 		/* ensure drive irq is clear */
 		(void)tp_ops->read_status(hwif);
@@ -605,6 +605,7 @@ out:
 
 static int ide_port_wait_ready(ide_hwif_t *hwif)
 {
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	ide_drive_t *drive;
 	int i, rc;
 
@@ -627,8 +628,8 @@ static int ide_port_wait_ready(ide_hwif_t *hwif)
 		/* Ignore disks that we will not probe for later. */
 		if ((drive->dev_flags & IDE_DFLAG_NOPROBE) == 0 ||
 		    (drive->dev_flags & IDE_DFLAG_PRESENT)) {
-			SELECT_DRIVE(drive);
-			hwif->tp_ops->set_irq(hwif, 1);
+			tp_ops->dev_select(drive);
+			tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
 			mdelay(2);
 			rc = ide_wait_not_busy(hwif, 35000);
 			if (rc)
@@ -640,7 +641,7 @@ static int ide_port_wait_ready(ide_hwif_t *hwif)
 out:
 	/* Exit function with master reselected (let's be sane) */
 	if (i)
-		SELECT_DRIVE(hwif->devices[0]);
+		tp_ops->dev_select(hwif->devices[0]);
 
 	return rc;
 }
@@ -845,7 +846,7 @@ static int init_irq (ide_hwif_t *hwif)
 		irq_handler = ide_intr;
 
 	if (io_ports->ctl_addr)
-		hwif->tp_ops->set_irq(hwif, 1);
+		hwif->tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
 
 	if (request_irq(hwif->irq, irq_handler, sa, hwif->name, hwif))
 		goto out_up;
@@ -942,20 +943,16 @@ EXPORT_SYMBOL_GPL(ide_init_disk);
 static void drive_release_dev (struct device *dev)
 {
 	ide_drive_t *drive = container_of(dev, ide_drive_t, gendev);
-	ide_hwif_t *hwif = drive->hwif;
 
 	ide_proc_unregister_device(drive);
 
-	spin_lock_irq(&hwif->lock);
+	blk_cleanup_queue(drive->queue);
+	drive->queue = NULL;
+
 	kfree(drive->id);
 	drive->id = NULL;
+
 	drive->dev_flags &= ~IDE_DFLAG_PRESENT;
-	/* Messed up locking ... */
-	spin_unlock_irq(&hwif->lock);
-	blk_cleanup_queue(drive->queue);
-	spin_lock_irq(&hwif->lock);
-	drive->queue = NULL;
-	spin_unlock_irq(&hwif->lock);
 
 	complete(&drive->gendev_rel_comp);
 }
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 64dfa74..cb942a9 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -297,19 +297,15 @@ static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
 	return tape;
 }
 
-static void idetape_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+static int idetape_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				  unsigned int bcount)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
 
 	while (bcount) {
-		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_input_buffers\n");
-			ide_pad_transfer(drive, 0, bcount);
-			return;
-		}
+		if (bh == NULL)
+			break;
 		count = min(
 			(unsigned int)(bh->b_size - atomic_read(&bh->b_count)),
 			bcount);
@@ -323,21 +319,21 @@ static void idetape_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				atomic_set(&bh->b_count, 0);
 		}
 	}
+
 	pc->bh = bh;
+
+	return bcount;
 }
 
-static void idetape_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+static int idetape_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				   unsigned int bcount)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
 
 	while (bcount) {
-		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
-					__func__);
-			return;
-		}
+		if (bh == NULL)
+			break;
 		count = min((unsigned int)pc->b_count, (unsigned int)bcount);
 		drive->hwif->tp_ops->output_data(drive, NULL, pc->b_data, count);
 		bcount -= count;
@@ -352,6 +348,8 @@ static void idetape_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 			}
 		}
 	}
+
+	return bcount;
 }
 
 static void idetape_update_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc)
@@ -563,12 +561,14 @@ static void ide_tape_handle_dsc(ide_drive_t *drive)
 static int ide_tape_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				unsigned int bcount, int write)
 {
+	unsigned int bleft;
+
 	if (write)
-		idetape_output_buffers(drive, pc, bcount);
+		bleft = idetape_output_buffers(drive, pc, bcount);
 	else
-		idetape_input_buffers(drive, pc, bcount);
+		bleft = idetape_input_buffers(drive, pc, bcount);
 
-	return bcount;
+	return bcount - bleft;
 }
 
 /*
@@ -2014,9 +2014,13 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
+	u8 pc_buf[256];
 	char fw_rev[4], vendor_id[8], product_id[16];
 
 	idetape_create_inquiry_cmd(&pc);
+	pc.buf = &pc_buf[0];
+	pc.buf_size = sizeof(pc_buf);
+
 	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
 		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n",
 				tape->name);
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 84532be..243421c 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -80,8 +80,14 @@ ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *orig_cmd)
 
 	if ((cmd->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
 		ide_tf_dump(drive->name, tf);
-		tp_ops->set_irq(hwif, 1);
+		tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
 		SELECT_MASK(drive, 0);
+
+		if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA) {
+			u8 data[2] = { tf->data, tf->hob_data };
+
+			tp_ops->output_data(drive, cmd, data, 2);
+		}
 		tp_ops->tf_load(drive, cmd);
 	}
 
@@ -100,9 +106,7 @@ ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *orig_cmd)
 		ide_execute_command(drive, cmd, handler, WAIT_WORSTCASE);
 		return ide_started;
 	case ATA_PROT_DMA:
-		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
-		    ide_build_sglist(drive, cmd) == 0 ||
-		    dma_ops->dma_setup(drive, cmd))
+		if (ide_dma_prepare(drive, cmd))
 			return ide_stopped;
 		hwif->expiry = dma_ops->dma_timer_expiry;
 		ide_execute_command(drive, cmd, ide_dma_intr, 2 * WAIT_CMD);
@@ -188,70 +192,68 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	return stat;
 }
 
-static void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
-			  unsigned int write, unsigned int nr_bytes)
+void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
+		   unsigned int write, unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
 	struct scatterlist *cursg = cmd->cursg;
 	struct page *page;
-#ifdef CONFIG_HIGHMEM
 	unsigned long flags;
-#endif
 	unsigned int offset;
 	u8 *buf;
 
 	cursg = cmd->cursg;
-	if (!cursg) {
-		cursg = sg;
-		cmd->cursg = sg;
-	}
+	if (cursg == NULL)
+		cursg = cmd->cursg = sg;
 
-	page = sg_page(cursg);
-	offset = cursg->offset + cmd->cursg_ofs;
+	while (len) {
+		unsigned nr_bytes = min(len, cursg->length - cmd->cursg_ofs);
 
-	/* get the current page and offset */
-	page = nth_page(page, (offset >> PAGE_SHIFT));
-	offset %= PAGE_SIZE;
+		if (nr_bytes > PAGE_SIZE)
+			nr_bytes = PAGE_SIZE;
 
-#ifdef CONFIG_HIGHMEM
-	local_irq_save(flags);
-#endif
-	buf = kmap_atomic(page, KM_BIO_SRC_IRQ) + offset;
+		page = sg_page(cursg);
+		offset = cursg->offset + cmd->cursg_ofs;
 
-	cmd->nleft -= nr_bytes;
-	cmd->cursg_ofs += nr_bytes;
+		/* get the current page and offset */
+		page = nth_page(page, (offset >> PAGE_SHIFT));
+		offset %= PAGE_SIZE;
 
-	if (cmd->cursg_ofs == cursg->length) {
-		cmd->cursg = sg_next(cmd->cursg);
-		cmd->cursg_ofs = 0;
-	}
+		if (PageHighMem(page))
+			local_irq_save(flags);
 
-	/* do the actual data transfer */
-	if (write)
-		hwif->tp_ops->output_data(drive, cmd, buf, nr_bytes);
-	else
-		hwif->tp_ops->input_data(drive, cmd, buf, nr_bytes);
+		buf = kmap_atomic(page, KM_BIO_SRC_IRQ) + offset;
 
-	kunmap_atomic(buf, KM_BIO_SRC_IRQ);
-#ifdef CONFIG_HIGHMEM
-	local_irq_restore(flags);
-#endif
-}
+		cmd->nleft -= nr_bytes;
+		cmd->cursg_ofs += nr_bytes;
 
-static void ide_pio_multi(ide_drive_t *drive, struct ide_cmd *cmd,
-			  unsigned int write)
-{
-	unsigned int nsect;
+		if (cmd->cursg_ofs == cursg->length) {
+			cursg = cmd->cursg = sg_next(cmd->cursg);
+			cmd->cursg_ofs = 0;
+		}
+
+		/* do the actual data transfer */
+		if (write)
+			hwif->tp_ops->output_data(drive, cmd, buf, nr_bytes);
+		else
+			hwif->tp_ops->input_data(drive, cmd, buf, nr_bytes);
+
+		kunmap_atomic(buf, KM_BIO_SRC_IRQ);
 
-	nsect = min_t(unsigned int, cmd->nleft >> 9, drive->mult_count);
-	while (nsect--)
-		ide_pio_bytes(drive, cmd, write, SECTOR_SIZE);
+		if (PageHighMem(page))
+			local_irq_restore(flags);
+
+		len -= nr_bytes;
+	}
 }
+EXPORT_SYMBOL_GPL(ide_pio_bytes);
 
 static void ide_pio_datablock(ide_drive_t *drive, struct ide_cmd *cmd,
 			      unsigned int write)
 {
+	unsigned int nr_bytes;
+
 	u8 saved_io_32bit = drive->io_32bit;
 
 	if (cmd->tf_flags & IDE_TFLAG_FS)
@@ -263,9 +265,11 @@ static void ide_pio_datablock(ide_drive_t *drive, struct ide_cmd *cmd,
 	touch_softlockup_watchdog();
 
 	if (cmd->tf_flags & IDE_TFLAG_MULTI_PIO)
-		ide_pio_multi(drive, cmd, write);
+		nr_bytes = min_t(unsigned, cmd->nleft, drive->mult_count << 9);
 	else
-		ide_pio_bytes(drive, cmd, write, SECTOR_SIZE);
+		nr_bytes = SECTOR_SIZE;
+
+	ide_pio_bytes(drive, cmd, write, nr_bytes);
 
 	drive->io_32bit = saved_io_32bit;
 }
diff --git a/drivers/ide/ide-timings.c b/drivers/ide/ide-timings.c
index 81f527a..001a563 100644
--- a/drivers/ide/ide-timings.c
+++ b/drivers/ide/ide-timings.c
@@ -43,6 +43,8 @@ static struct ide_timing ide_timing[] = {
 	{ XFER_UDMA_1,     0,   0,   0,   0,   0,   0,   0,  80 },
 	{ XFER_UDMA_0,     0,   0,   0,   0,   0,   0,   0, 120 },
 
+	{ XFER_MW_DMA_4,  25,   0,   0,   0,  55,  20,  80,   0 },
+	{ XFER_MW_DMA_3,  25,   0,   0,   0,  65,  25, 100,   0 },
 	{ XFER_MW_DMA_2,  25,   0,   0,   0,  70,  25, 120,   0 },
 	{ XFER_MW_DMA_1,  45,   0,   0,   0,  80,  50, 150,   0 },
 	{ XFER_MW_DMA_0,  60,   0,   0,   0, 215, 215, 480,   0 },
@@ -51,7 +53,8 @@ static struct ide_timing ide_timing[] = {
 	{ XFER_SW_DMA_1,  90,   0,   0,   0, 240, 240, 480,   0 },
 	{ XFER_SW_DMA_0, 120,   0,   0,   0, 480, 480, 960,   0 },
 
-	{ XFER_PIO_5,     20,  50,  30, 100,  50,  30, 100,   0 },
+	{ XFER_PIO_6,     10,  55,  20,  80,  55,  20,  80,   0 },
+	{ XFER_PIO_5,     15,  65,  25, 100,  65,  25, 100,   0 },
 	{ XFER_PIO_4,     25,  70,  25, 120,  70,  25, 120,   0 },
 	{ XFER_PIO_3,     30,  80,  70, 180,  80,  70, 180,   0 },
 
@@ -90,6 +93,10 @@ u16 ide_pio_cycle_time(ide_drive_t *drive, u8 pio)
 		/* conservative "downgrade" for all pre-ATA2 drives */
 		if (pio < 3 && cycle < t->cycle)
 			cycle = 0; /* use standard timing */
+
+		/* Use the standard timing for the CF specific modes too */
+		if (pio > 4 && ata_id_is_cfa(id))
+			cycle = 0;
 	}
 
 	return cycle ? cycle : t->cycle;
@@ -161,7 +168,8 @@ int ide_timing_compute(ide_drive_t *drive, u8 speed,
 
 		if (speed <= XFER_PIO_2)
 			p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO];
-		else if (speed <= XFER_PIO_5)
+		else if ((speed <= XFER_PIO_4) ||
+			 (speed == XFER_PIO_5 && !ata_id_is_cfa(id)))
 			p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO_IORDY];
 		else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
 			p.cycle = id[ATA_ID_EIDE_DMA_MIN];
diff --git a/drivers/ide/ide-xfer-mode.c b/drivers/ide/ide-xfer-mode.c
index 6910f6a..af44be9 100644
--- a/drivers/ide/ide-xfer-mode.c
+++ b/drivers/ide/ide-xfer-mode.c
@@ -9,11 +9,11 @@ static const char *udma_str[] =
 	 { "UDMA/16", "UDMA/25",  "UDMA/33",  "UDMA/44",
 	   "UDMA/66", "UDMA/100", "UDMA/133", "UDMA7" };
 static const char *mwdma_str[] =
-	{ "MWDMA0", "MWDMA1", "MWDMA2" };
+	{ "MWDMA0", "MWDMA1", "MWDMA2", "MWDMA3", "MWDMA4" };
 static const char *swdma_str[] =
 	{ "SWDMA0", "SWDMA1", "SWDMA2" };
 static const char *pio_str[] =
-	{ "PIO0", "PIO1", "PIO2", "PIO3", "PIO4", "PIO5" };
+	{ "PIO0", "PIO1", "PIO2", "PIO3", "PIO4", "PIO5", "PIO6" };
 
 /**
  *	ide_xfer_verbose	-	return IDE mode names
@@ -30,11 +30,11 @@ const char *ide_xfer_verbose(u8 mode)
 
 	if (mode >= XFER_UDMA_0 && mode <= XFER_UDMA_7)
 		s = udma_str[i];
-	else if (mode >= XFER_MW_DMA_0 && mode <= XFER_MW_DMA_2)
+	else if (mode >= XFER_MW_DMA_0 && mode <= XFER_MW_DMA_4)
 		s = mwdma_str[i];
 	else if (mode >= XFER_SW_DMA_0 && mode <= XFER_SW_DMA_2)
 		s = swdma_str[i];
-	else if (mode >= XFER_PIO_0 && mode <= XFER_PIO_5)
+	else if (mode >= XFER_PIO_0 && mode <= XFER_PIO_6)
 		s = pio_str[i & 0x7];
 	else if (mode == XFER_PIO_SLOW)
 		s = "PIO SLOW";
@@ -79,7 +79,10 @@ u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 		}
 
 		if (id[ATA_ID_FIELD_VALID] & 2) {	      /* ATA2? */
-			if (ata_id_has_iordy(id)) {
+			if (ata_id_is_cfa(id) && (id[ATA_ID_CFA_MODES] & 7))
+				pio_mode = 4 + min_t(int, 2,
+						     id[ATA_ID_CFA_MODES] & 7);
+			else if (ata_id_has_iordy(id)) {
 				if (id[ATA_ID_PIO_MODES] & 7) {
 					overridden = 0;
 					if (id[ATA_ID_PIO_MODES] & 4)
@@ -239,7 +242,7 @@ int ide_set_xfer_rate(ide_drive_t *drive, u8 rate)
 
 	BUG_ON(rate < XFER_PIO_0);
 
-	if (rate >= XFER_PIO_0 && rate <= XFER_PIO_5)
+	if (rate >= XFER_PIO_0 && rate <= XFER_PIO_6)
 		return ide_set_pio_mode(drive, rate);
 
 	return ide_set_dma_mode(drive, rate);
diff --git a/drivers/ide/ide_arm.c b/drivers/ide/ide_arm.c
deleted file mode 100644
index cf63854..0000000
--- a/drivers/ide/ide_arm.c
+++ /dev/null
@@ -1,53 +0,0 @@
-/*
- * ARM default IDE host driver
- *
- * Copyright (C) 2004 Bartlomiej Zolnierkiewicz
- * Based on code by: Russell King, Ian Molton and Alexander Schulz.
- *
- * May be copied or modified under the terms of the GNU General Public License.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/ide.h>
-
-#include <asm/irq.h>
-
-#define DRV_NAME "ide_arm"
-
-#define IDE_ARM_IO	0x1f0
-#define IDE_ARM_IRQ	IRQ_HARDDISK
-
-static const struct ide_port_info ide_arm_port_info = {
-	.host_flags		= IDE_HFLAG_NO_DMA,
-};
-
-static int __init ide_arm_init(void)
-{
-	unsigned long base = IDE_ARM_IO, ctl = IDE_ARM_IO + 0x206;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-
-	if (!request_region(base, 8, DRV_NAME)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
-				DRV_NAME, base, base + 7);
-		return -EBUSY;
-	}
-
-	if (!request_region(ctl, 1, DRV_NAME)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
-				DRV_NAME, ctl);
-		release_region(base, 8);
-		return -EBUSY;
-	}
-
-	memset(&hw, 0, sizeof(hw));
-	ide_std_init_ports(&hw, base, ctl);
-	hw.irq = IDE_ARM_IRQ;
-	hw.chipset = ide_generic;
-
-	return ide_host_add(&ide_arm_port_info, hws, NULL);
-}
-
-module_init(ide_arm_init);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/ide/it821x.c b/drivers/ide/it821x.c
index 0d4ac65..51aa745 100644
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -511,9 +511,8 @@ static struct ide_dma_ops it821x_pass_through_dma_ops = {
 	.dma_start		= it821x_dma_start,
 	.dma_end		= it821x_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
-	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
diff --git a/drivers/ide/ns87415.c b/drivers/ide/ns87415.c
index 7b65fe5..71a39fb 100644
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -66,18 +66,11 @@ static void superio_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
 	struct ide_taskfile *tf = &cmd->tf;
 
-	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
-		u16 data = inw(io_ports->data_addr);
-
-		tf->data = data & 0xff;
-		tf->hob_data = (data >> 8) & 0xff;
-	}
-
 	/* be sure we're looking at the low order bits */
-	outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
+	outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
-		tf->feature = inb(io_ports->feature_addr);
+	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
+		tf->error  = inb(io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = inb(io_ports->nsect_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
@@ -90,28 +83,30 @@ static void superio_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 		tf->device = superio_ide_inb(io_ports->device_addr);
 
 	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
+		outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature = inb(io_ports->feature_addr);
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
+			tf->hob_error = inb(io_ports->feature_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = inb(io_ports->nsect_addr);
+			tf->hob_nsect = inb(io_ports->nsect_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = inb(io_ports->lbal_addr);
+			tf->hob_lbal  = inb(io_ports->lbal_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = inb(io_ports->lbam_addr);
+			tf->hob_lbam  = inb(io_ports->lbam_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = inb(io_ports->lbah_addr);
+			tf->hob_lbah  = inb(io_ports->lbah_addr);
 	}
 }
 
+static void ns87415_dev_select(ide_drive_t *drive);
+
 static const struct ide_tp_ops superio_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= superio_read_status,
 	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
 
-	.set_irq		= ide_set_irq,
-
+	.dev_select		= ns87415_dev_select,
 	.tf_load		= ide_tf_load,
 	.tf_read		= superio_tf_read,
 
@@ -190,10 +185,18 @@ static void ns87415_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 	local_irq_restore(flags);
 }
 
-static void ns87415_selectproc (ide_drive_t *drive)
+static void ns87415_dev_select(ide_drive_t *drive)
 {
 	ns87415_prepare_drive(drive,
 			      !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
+
+	outb(drive->select | ATA_DEVICE_OBS, drive->hwif->io_ports.device_addr);
+}
+
+static void ns87415_dma_start(ide_drive_t *drive)
+{
+	ns87415_prepare_drive(drive, 1);
+	ide_dma_start(drive);
 }
 
 static int ns87415_dma_end(ide_drive_t *drive)
@@ -201,7 +204,6 @@ static int ns87415_dma_end(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = 0, dma_cmd = 0;
 
-	drive->waiting_for_dma = 0;
 	dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 	/* get DMA command mode */
 	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
@@ -210,21 +212,11 @@ static int ns87415_dma_end(ide_drive_t *drive)
 	/* from ERRATA: clear the INTR & ERROR bits */
 	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	outb(dma_cmd | 6, hwif->dma_base + ATA_DMA_CMD);
-	/* and free any DMA resources */
-	ide_destroy_dmatable(drive);
-	/* verify good DMA status */
-	return (dma_stat & 7) != 4;
-}
 
-static int ns87415_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	/* select DMA xfer */
-	ns87415_prepare_drive(drive, 1);
-	if (ide_dma_setup(drive, cmd) == 0)
-		return 0;
-	/* DMA failed: select PIO xfer */
 	ns87415_prepare_drive(drive, 0);
-	return 1;
+
+	/* verify good DMA status */
+	return (dma_stat & 7) != 4;
 }
 
 static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
@@ -242,7 +234,7 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 	 * Also, leave IRQ masked during drive probing, to prevent infinite
 	 * interrupts from a potentially floating INTA..
 	 *
-	 * IRQs get unmasked in selectproc when drive is first used.
+	 * IRQs get unmasked in dev_select() when drive is first used.
 	 */
 	(void) pci_read_config_dword(dev, 0x40, &ctrl);
 	(void) pci_read_config_byte(dev, 0x09, &progif);
@@ -270,7 +262,7 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 #ifdef __sparc_v9__
 		/*
 		 * XXX: Reset the device, if we don't it will not respond to
-		 *      SELECT_DRIVE() properly during first ide_probe_port().
+		 *      dev_select() properly during first ide_probe_port().
 		 */
 		timeout = 10000;
 		outb(12, hwif->io_ports.ctl_addr);
@@ -294,26 +286,35 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 	outb(0x60, hwif->dma_base + ATA_DMA_STATUS);
 }
 
-static const struct ide_port_ops ns87415_port_ops = {
-	.selectproc		= ns87415_selectproc,
+static const struct ide_tp_ops ns87415_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
+
+	.dev_select		= ns87415_dev_select,
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
 };
 
 static const struct ide_dma_ops ns87415_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
-	.dma_setup		= ns87415_dma_setup,
-	.dma_start		= ide_dma_start,
+	.dma_setup		= ide_dma_setup,
+	.dma_start		= ns87415_dma_start,
 	.dma_end		= ns87415_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= superio_dma_sff_read_status,
 };
 
 static const struct ide_port_info ns87415_chipset __devinitdata = {
 	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_ns87415,
-	.port_ops	= &ns87415_port_ops,
+	.tp_ops 	= &ns87415_tp_ops,
 	.dma_ops	= &ns87415_dma_ops,
 	.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 			  IDE_HFLAG_NO_ATAPI_DMA,
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index f7536d1..248a54b 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -258,12 +258,6 @@ static void pdc202xx_dma_lost_irq(ide_drive_t *drive)
 	ide_dma_lost_irq(drive);
 }
 
-static void pdc202xx_dma_timeout(ide_drive_t *drive)
-{
-	pdc202xx_reset(drive);
-	ide_dma_timeout(drive);
-}
-
 static int init_chipset_pdc202xx(struct pci_dev *dev)
 {
 	unsigned long dmabase = pci_resource_start(dev, 4);
@@ -336,7 +330,7 @@ static const struct ide_dma_ops pdc20246_dma_ops = {
 	.dma_test_irq		= pdc202xx_dma_test_irq,
 	.dma_lost_irq		= pdc202xx_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= pdc202xx_dma_timeout,
+	.dma_clear		= pdc202xx_reset,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
@@ -348,7 +342,7 @@ static const struct ide_dma_ops pdc2026x_dma_ops = {
 	.dma_test_irq		= pdc202xx_dma_test_irq,
 	.dma_lost_irq		= pdc202xx_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= pdc202xx_dma_timeout,
+	.dma_clear		= pdc202xx_reset,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index 2bfcfed..052b9bf 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -404,8 +404,6 @@ kauai_lookup_timing(struct kauai_timing* table, int cycle_time)
 #define IDE_WAKEUP_DELAY	(1*HZ)
 
 static int pmac_ide_init_dma(ide_hwif_t *, const struct ide_port_info *);
-static void pmac_ide_selectproc(ide_drive_t *drive);
-static void pmac_ide_kauai_selectproc(ide_drive_t *drive);
 
 #define PMAC_IDE_REG(x) \
 	((void __iomem *)((drive)->hwif->io_ports.data_addr + (x)))
@@ -415,8 +413,7 @@ static void pmac_ide_kauai_selectproc(ide_drive_t *drive);
  * timing register when selecting that unit. This version is for
  * ASICs with a single timing register
  */
-static void
-pmac_ide_selectproc(ide_drive_t *drive)
+static void pmac_ide_apply_timings(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
@@ -434,8 +431,7 @@ pmac_ide_selectproc(ide_drive_t *drive)
  * timing register when selecting that unit. This version is for
  * ASICs with a dual timing register (Kauai)
  */
-static void
-pmac_ide_kauai_selectproc(ide_drive_t *drive)
+static void pmac_ide_kauai_apply_timings(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
@@ -464,9 +460,25 @@ pmac_ide_do_update_timings(ide_drive_t *drive)
 	if (pmif->kind == controller_sh_ata6 ||
 	    pmif->kind == controller_un_ata6 ||
 	    pmif->kind == controller_k2_ata6)
-		pmac_ide_kauai_selectproc(drive);
+		pmac_ide_kauai_apply_timings(drive);
 	else
-		pmac_ide_selectproc(drive);
+		pmac_ide_apply_timings(drive);
+}
+
+static void pmac_dev_select(ide_drive_t *drive)
+{
+	pmac_ide_apply_timings(drive);
+
+	writeb(drive->select | ATA_DEVICE_OBS,
+	       (void __iomem *)drive->hwif->io_ports.device_addr);
+}
+
+static void pmac_kauai_dev_select(ide_drive_t *drive)
+{
+	pmac_ide_kauai_apply_timings(drive);
+
+	writeb(drive->select | ATA_DEVICE_OBS,
+	       (void __iomem *)drive->hwif->io_ports.device_addr);
 }
 
 static void pmac_exec_command(ide_hwif_t *hwif, u8 cmd)
@@ -476,17 +488,8 @@ static void pmac_exec_command(ide_hwif_t *hwif, u8 cmd)
 				     + IDE_TIMING_CONFIG));
 }
 
-static void pmac_set_irq(ide_hwif_t *hwif, int on)
+static void pmac_write_devctl(ide_hwif_t *hwif, u8 ctl)
 {
-	u8 ctl = ATA_DEVCTL_OBS;
-
-	if (on == 4) { /* hack for SRST */
-		ctl |= 4;
-		on &= ~4;
-	}
-
-	ctl |= on ? 0 : 2;
-
 	writeb(ctl, (void __iomem *)hwif->io_ports.ctl_addr);
 	(void)readl((void __iomem *)(hwif->io_ports.data_addr
 				     + IDE_TIMING_CONFIG));
@@ -916,10 +919,18 @@ static u8 pmac_ide_cable_detect(ide_hwif_t *hwif)
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct device_node *np = pmif->node;
 	const char *cable = of_get_property(np, "cable-type", NULL);
+	struct device_node *root = of_find_node_by_path("/");
+	const char *model = of_get_property(root, "model", NULL);
 
 	/* Get cable type from device-tree. */
-	if (cable && !strncmp(cable, "80-", 3))
-		return ATA_CBL_PATA80;
+	if (cable && !strncmp(cable, "80-", 3)) {
+		/* Some drives fail to detect 80c cable in PowerBook */
+		/* These machine use proprietary short IDE cable anyway */
+		if (!strncmp(model, "PowerBook", 9))
+			return ATA_CBL_PATA40_SHORT;
+		else
+			return ATA_CBL_PATA80;
+	}
 
 	/*
 	 * G5's seem to have incorrect cable type in device-tree.
@@ -954,9 +965,9 @@ static const struct ide_tp_ops pmac_tp_ops = {
 	.exec_command		= pmac_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= pmac_write_devctl,
 
-	.set_irq		= pmac_set_irq,
-
+	.dev_select		= pmac_dev_select,
 	.tf_load		= ide_tf_load,
 	.tf_read		= ide_tf_read,
 
@@ -964,19 +975,24 @@ static const struct ide_tp_ops pmac_tp_ops = {
 	.output_data		= ide_output_data,
 };
 
-static const struct ide_port_ops pmac_ide_ata6_port_ops = {
-	.init_dev		= pmac_ide_init_dev,
-	.set_pio_mode		= pmac_ide_set_pio_mode,
-	.set_dma_mode		= pmac_ide_set_dma_mode,
-	.selectproc		= pmac_ide_kauai_selectproc,
-	.cable_detect		= pmac_ide_cable_detect,
+static const struct ide_tp_ops pmac_ata6_tp_ops = {
+	.exec_command		= pmac_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= pmac_write_devctl,
+
+	.dev_select		= pmac_kauai_dev_select,
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
 };
 
 static const struct ide_port_ops pmac_ide_ata4_port_ops = {
 	.init_dev		= pmac_ide_init_dev,
 	.set_pio_mode		= pmac_ide_set_pio_mode,
 	.set_dma_mode		= pmac_ide_set_dma_mode,
-	.selectproc		= pmac_ide_selectproc,
 	.cable_detect		= pmac_ide_cable_detect,
 };
 
@@ -984,7 +1000,6 @@ static const struct ide_port_ops pmac_ide_port_ops = {
 	.init_dev		= pmac_ide_init_dev,
 	.set_pio_mode		= pmac_ide_set_pio_mode,
 	.set_dma_mode		= pmac_ide_set_dma_mode,
-	.selectproc		= pmac_ide_selectproc,
 };
 
 static const struct ide_dma_ops pmac_dma_ops;
@@ -1021,15 +1036,18 @@ static int __devinit pmac_ide_setup_device(pmac_ide_hwif_t *pmif, hw_regs_t *hw)
 	pmif->broken_dma = pmif->broken_dma_warn = 0;
 	if (of_device_is_compatible(np, "shasta-ata")) {
 		pmif->kind = controller_sh_ata6;
-		d.port_ops = &pmac_ide_ata6_port_ops;
+		d.tp_ops = &pmac_ata6_tp_ops;
+		d.port_ops = &pmac_ide_ata4_port_ops;
 		d.udma_mask = ATA_UDMA6;
 	} else if (of_device_is_compatible(np, "kauai-ata")) {
 		pmif->kind = controller_un_ata6;
-		d.port_ops = &pmac_ide_ata6_port_ops;
+		d.tp_ops = &pmac_ata6_tp_ops;
+		d.port_ops = &pmac_ide_ata4_port_ops;
 		d.udma_mask = ATA_UDMA5;
 	} else if (of_device_is_compatible(np, "K2-UATA")) {
 		pmif->kind = controller_k2_ata6;
-		d.port_ops = &pmac_ide_ata6_port_ops;
+		d.tp_ops = &pmac_ata6_tp_ops;
+		d.port_ops = &pmac_ide_ata4_port_ops;
 		d.udma_mask = ATA_UDMA5;
 	} else if (of_device_is_compatible(np, "keylargo-ata")) {
 		if (strcmp(np->name, "ata-4") == 0) {
@@ -1455,7 +1473,7 @@ static int pmac_ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 				       "switching to PIO on Ohare chipset\n", drive->name);
 				pmif->broken_dma_warn = 1;
 			}
-			goto use_pio_instead;
+			return 0;
 		}
 		while (cur_len) {
 			unsigned int tc = (cur_len < 0xfe00)? cur_len: 0xfe00;
@@ -1463,7 +1481,7 @@ static int pmac_ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 			if (count++ >= MAX_DCMDS) {
 				printk(KERN_WARNING "%s: DMA table too small\n",
 				       drive->name);
-				goto use_pio_instead;
+				return 0;
 			}
 			st_le16(&table->command, wr? OUTPUT_MORE: INPUT_MORE);
 			st_le16(&table->req_count, tc);
@@ -1492,9 +1510,6 @@ static int pmac_ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 
 	printk(KERN_DEBUG "%s: empty DMA table?\n", drive->name);
 
-use_pio_instead:
-	ide_destroy_dmatable(drive);
-
 	return 0; /* revert to PIO for this request */
 }
 
@@ -1510,10 +1525,8 @@ static int pmac_ide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 	u8 unit = drive->dn & 1, ata4 = (pmif->kind == controller_kl_ata4);
 	u8 write = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
 
-	if (pmac_ide_build_dmatable(drive, cmd) == 0) {
-		ide_map_sg(drive, cmd);
+	if (pmac_ide_build_dmatable(drive, cmd) == 0)
 		return 1;
-	}
 
 	/* Apple adds 60ns to wrDataSetup on reads */
 	if (ata4 && (pmif->timings[unit] & TR_66_UDMA_EN)) {
@@ -1522,8 +1535,6 @@ static int pmac_ide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 		(void)readl(PMAC_IDE_REG(IDE_TIMING_CONFIG));
 	}
 
-	drive->waiting_for_dma = 1;
-
 	return 0;
 }
 
@@ -1558,12 +1569,9 @@ pmac_ide_dma_end (ide_drive_t *drive)
 	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	u32 dstat;
 
-	drive->waiting_for_dma = 0;
 	dstat = readl(&dma->status);
 	writel(((RUN|WAKE|DEAD) << 16), &dma->control);
 
-	ide_destroy_dmatable(drive);
-
 	/* verify good dma status. we don't check for ACTIVE beeing 0. We should...
 	 * in theory, but with ATAPI decices doing buffer underruns, that would
 	 * cause us to disable DMA, which isn't what we want
@@ -1650,7 +1658,6 @@ static const struct ide_dma_ops pmac_dma_ops = {
 	.dma_start		= pmac_ide_dma_start,
 	.dma_end		= pmac_ide_dma_end,
 	.dma_test_irq		= pmac_ide_dma_test_irq,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= pmac_ide_dma_lost_irq,
 };
 
diff --git a/drivers/ide/q40ide.c b/drivers/ide/q40ide.c
index 2a43a2f..d007e7f 100644
--- a/drivers/ide/q40ide.c
+++ b/drivers/ide/q40ide.c
@@ -99,9 +99,9 @@ static const struct ide_tp_ops q40ide_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
 
-	.set_irq		= ide_set_irq,
-
+	.dev_select		= ide_dev_select,
 	.tf_load		= ide_tf_load,
 	.tf_read		= ide_tf_read,
 
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index 08c4fa3..c9a1349 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -90,13 +90,15 @@ static int timings[4]={-1,-1,-1,-1}; /* stores current timing for each timer */
  * This routine is invoked to prepare for access to a given drive.
  */
 
-static void qd65xx_select(ide_drive_t *drive)
+static void qd65xx_dev_select(ide_drive_t *drive)
 {
 	u8 index = ((	(QD_TIMREG(drive)) & 0x80 ) >> 7) |
 			(QD_TIMREG(drive) & 0x02);
 
 	if (timings[index] != QD_TIMING(drive))
 		outb(timings[index] = QD_TIMING(drive), QD_TIMREG(drive));
+
+	outb(drive->select | ATA_DEVICE_OBS, drive->hwif->io_ports.device_addr);
 }
 
 /*
@@ -309,20 +311,33 @@ static void __init qd6580_init_dev(ide_drive_t *drive)
 	drive->drive_data = (drive->dn & 1) ? t2 : t1;
 }
 
+static const struct ide_tp_ops qd65xx_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
+
+	.dev_select		= qd65xx_dev_select,
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
+
 static const struct ide_port_ops qd6500_port_ops = {
 	.init_dev		= qd6500_init_dev,
 	.set_pio_mode		= qd6500_set_pio_mode,
-	.selectproc		= qd65xx_select,
 };
 
 static const struct ide_port_ops qd6580_port_ops = {
 	.init_dev		= qd6580_init_dev,
 	.set_pio_mode		= qd6580_set_pio_mode,
-	.selectproc		= qd65xx_select,
 };
 
 static const struct ide_port_info qd65xx_port_info __initdata = {
 	.name			= DRV_NAME,
+	.tp_ops 		= &qd65xx_tp_ops,
 	.chipset		= ide_qd65xx,
 	.host_flags		= IDE_HFLAG_IO_32BIT |
 				  IDE_HFLAG_NO_DMA,
diff --git a/drivers/ide/sc1200.c b/drivers/ide/sc1200.c
index 1c3a829..d467478 100644
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -115,8 +115,7 @@ static u8 sc1200_udma_filter(ide_drive_t *drive)
 		if ((mateid[ATA_ID_FIELD_VALID] & 4) &&
 		    (mateid[ATA_ID_UDMA_MODES] & 7))
 			goto out;
-		if ((mateid[ATA_ID_FIELD_VALID] & 2) &&
-		    (mateid[ATA_ID_MWDMA_MODES] & 7))
+		if (mateid[ATA_ID_MWDMA_MODES] & 7)
 			mask = 0;
 	}
 out:
@@ -183,9 +182,6 @@ static int sc1200_dma_end(ide_drive_t *drive)
 	outb(dma_stat|0x1b, dma_base+2);	/* clear the INTR & ERROR bits */
 	outb(inb(dma_base)&~1, dma_base);	/* !! DO THIS HERE !! stop DMA */
 
-	drive->waiting_for_dma = 0;
-	ide_destroy_dmatable(drive);		/* purge DMA mappings */
-
 	return (dma_stat & 7) != 4;		/* verify good DMA status */
 }
 
@@ -291,7 +287,6 @@ static const struct ide_dma_ops sc1200_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
diff --git a/drivers/ide/scc_pata.c b/drivers/ide/scc_pata.c
index 0cc137c..6d8dbd9 100644
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -148,17 +148,8 @@ static u8 scc_dma_sff_read_status(ide_hwif_t *hwif)
 	return (u8)in_be32((void *)(hwif->dma_base + 4));
 }
 
-static void scc_set_irq(ide_hwif_t *hwif, int on)
+static void scc_write_devctl(ide_hwif_t *hwif, u8 ctl)
 {
-	u8 ctl = ATA_DEVCTL_OBS;
-
-	if (on == 4) { /* hack for SRST */
-		ctl |= 4;
-		on &= ~4;
-	}
-
-	ctl |= on ? 0 : 2;
-
 	out_be32((void *)hwif->io_ports.ctl_addr, ctl);
 	eieio();
 	in_be32((void *)(hwif->dma_base + 0x01c));
@@ -321,10 +312,8 @@ static int scc_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 	u8 dma_stat;
 
 	/* fall back to pio! */
-	if (ide_build_dmatable(drive, cmd) == 0) {
-		ide_map_sg(drive, cmd);
+	if (ide_build_dmatable(drive, cmd) == 0)
 		return 1;
-	}
 
 	/* PRD table */
 	out_be32((void __iomem *)(hwif->dma_base + 8), hwif->dmatable_dma);
@@ -337,7 +326,7 @@ static int scc_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 
 	/* clear INTR & ERROR flags */
 	out_be32((void __iomem *)(hwif->dma_base + 4), dma_stat | 6);
-	drive->waiting_for_dma = 1;
+
 	return 0;
 }
 
@@ -356,7 +345,6 @@ static int __scc_dma_end(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat, dma_cmd;
 
-	drive->waiting_for_dma = 0;
 	/* get DMA command mode */
 	dma_cmd = scc_ide_inb(hwif->dma_base);
 	/* stop DMA */
@@ -365,8 +353,6 @@ static int __scc_dma_end(ide_drive_t *drive)
 	dma_stat = scc_dma_sff_read_status(hwif);
 	/* clear the INTR & ERROR bits */
 	scc_ide_outb(dma_stat | 6, hwif->dma_base + 4);
-	/* purge DMA mappings */
-	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
 	wmb();
 	return (dma_stat & 7) != 4 ? (0x10 | dma_stat) : 0;
@@ -670,10 +656,6 @@ static void scc_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA)
-		out_be32((void *)io_ports->data_addr,
-			 (tf->hob_data << 8) | tf->data);
-
 	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		scc_ide_outb(tf->hob_feature, io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
@@ -706,18 +688,11 @@ static void scc_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
 	struct ide_taskfile *tf = &cmd->tf;
 
-	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
-		u16 data = (u16)in_be32((void *)io_ports->data_addr);
-
-		tf->data = data & 0xff;
-		tf->hob_data = (data >> 8) & 0xff;
-	}
-
 	/* be sure we're looking at the low order bits */
-	scc_ide_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
+	scc_ide_outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
-		tf->feature = scc_ide_inb(io_ports->feature_addr);
+	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
+		tf->error  = scc_ide_inb(io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = scc_ide_inb(io_ports->nsect_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
@@ -730,18 +705,18 @@ static void scc_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 		tf->device = scc_ide_inb(io_ports->device_addr);
 
 	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		scc_ide_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
+		scc_ide_outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature = scc_ide_inb(io_ports->feature_addr);
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
+			tf->hob_error = scc_ide_inb(io_ports->feature_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = scc_ide_inb(io_ports->nsect_addr);
+			tf->hob_nsect = scc_ide_inb(io_ports->nsect_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = scc_ide_inb(io_ports->lbal_addr);
+			tf->hob_lbal  = scc_ide_inb(io_ports->lbal_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = scc_ide_inb(io_ports->lbam_addr);
+			tf->hob_lbam  = scc_ide_inb(io_ports->lbam_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = scc_ide_inb(io_ports->lbah_addr);
+			tf->hob_lbah  = scc_ide_inb(io_ports->lbah_addr);
 	}
 }
 
@@ -848,9 +823,9 @@ static const struct ide_tp_ops scc_tp_ops = {
 	.exec_command		= scc_exec_command,
 	.read_status		= scc_read_status,
 	.read_altstatus		= scc_read_altstatus,
+	.write_devctl		= scc_write_devctl,
 
-	.set_irq		= scc_set_irq,
-
+	.dev_select		= ide_dev_select,
 	.tf_load		= scc_tf_load,
 	.tf_read		= scc_tf_read,
 
@@ -872,7 +847,6 @@ static const struct ide_dma_ops scc_dma_ops = {
 	.dma_end		= scc_dma_end,
 	.dma_test_irq		= scc_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_sff_read_status	= scc_dma_sff_read_status,
 };
diff --git a/drivers/ide/sgiioc4.c b/drivers/ide/sgiioc4.c
index b12de83..e5d2a48 100644
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -258,9 +258,6 @@ static int sgiioc4_dma_end(ide_drive_t *drive)
 		}
 	}
 
-	drive->waiting_for_dma = 0;
-	ide_destroy_dmatable(drive);
-
 	return dma_stat;
 }
 
@@ -280,10 +277,12 @@ static void sgiioc4_dma_host_set(ide_drive_t *drive, int on)
 		sgiioc4_clearirq(drive);
 }
 
-static void
-sgiioc4_resetproc(ide_drive_t * drive)
+static void sgiioc4_resetproc(ide_drive_t *drive)
 {
+	struct ide_cmd *cmd = &drive->hwif->cmd;
+
 	sgiioc4_dma_end(drive);
+	ide_dma_unmap_sg(drive, cmd);
 	sgiioc4_clearirq(drive);
 }
 
@@ -412,7 +411,6 @@ sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 	writel(ending_dma_addr, (void __iomem *)(dma_base + IOC4_DMA_END_ADDR * 4));
 
 	writel(dma_direction, (void __iomem *)ioc4_dma_addr);
-	drive->waiting_for_dma = 1;
 }
 
 /* IOC4 Scatter Gather list Format 					 */
@@ -442,7 +440,7 @@ static int sgiioc4_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 				printk(KERN_WARNING
 				       "%s: DMA table too small\n",
 				       drive->name);
-				goto use_pio_instead;
+				return 0;
 			} else {
 				u32 bcount =
 				    0x10000 - (cur_addr & 0xffff);
@@ -477,9 +475,6 @@ static int sgiioc4_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 		return count;
 	}
 
-use_pio_instead:
-	ide_destroy_dmatable(drive);
-
 	return 0;		/* revert to PIO for this request */
 }
 
@@ -488,11 +483,9 @@ static int sgiioc4_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 	int ddir;
 	u8 write = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
 
-	if (sgiioc4_build_dmatable(drive, cmd) == 0) {
+	if (sgiioc4_build_dmatable(drive, cmd) == 0)
 		/* try PIO instead of DMA */
-		ide_map_sg(drive, cmd);
 		return 1;
-	}
 
 	if (write)
 		/* Writes TO the IOC4 FROM Main Memory */
@@ -510,9 +503,9 @@ static const struct ide_tp_ops sgiioc4_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= sgiioc4_read_status,
 	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
 
-	.set_irq		= ide_set_irq,
-
+	.dev_select		= ide_dev_select,
 	.tf_load		= ide_tf_load,
 	.tf_read		= ide_tf_read,
 
@@ -533,7 +526,6 @@ static const struct ide_dma_ops sgiioc4_dma_ops = {
 	.dma_end		= sgiioc4_dma_end,
 	.dma_test_irq		= sgiioc4_dma_test_irq,
 	.dma_lost_irq		= sgiioc4_dma_lost_irq,
-	.dma_timeout		= ide_dma_timeout,
 };
 
 static const struct ide_port_info sgiioc4_port_info __devinitconst = {
diff --git a/drivers/ide/siimage.c b/drivers/ide/siimage.c
index 075cb12..e4973cd 100644
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -715,7 +715,6 @@ static const struct ide_dma_ops sil_dma_ops = {
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= siimage_dma_test_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
diff --git a/drivers/ide/sl82c105.c b/drivers/ide/sl82c105.c
index d25137b..b0a4606 100644
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -61,7 +61,8 @@ static unsigned int get_pio_timings(ide_drive_t *drive, u8 pio)
 	if (cmd_off == 0)
 		cmd_off = 1;
 
-	if (pio > 2 || ata_id_has_iordy(drive->id))
+	if ((pio > 2 || ata_id_has_iordy(drive->id)) &&
+	    !(pio > 4 && ata_id_is_cfa(drive->id)))
 		iordy = 0x40;
 
 	return (cmd_on - 1) << 8 | (cmd_off - 1) | iordy;
@@ -189,14 +190,13 @@ static void sl82c105_dma_start(ide_drive_t *drive)
 	ide_dma_start(drive);
 }
 
-static void sl82c105_dma_timeout(ide_drive_t *drive)
+static void sl82c105_dma_clear(ide_drive_t *drive)
 {
 	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 
-	DBG(("sl82c105_dma_timeout(drive:%s)\n", drive->name));
+	DBG(("sl82c105_dma_clear(drive:%s)\n", drive->name));
 
 	sl82c105_reset_host(dev);
-	ide_dma_timeout(drive);
 }
 
 static int sl82c105_dma_end(ide_drive_t *drive)
@@ -298,7 +298,7 @@ static const struct ide_dma_ops sl82c105_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= sl82c105_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= sl82c105_dma_timeout,
+	.dma_clear		= sl82c105_dma_clear,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
diff --git a/drivers/ide/tc86c001.c b/drivers/ide/tc86c001.c
index 427d4b3..b4cf42d 100644
--- a/drivers/ide/tc86c001.c
+++ b/drivers/ide/tc86c001.c
@@ -187,7 +187,6 @@ static const struct ide_dma_ops tc86c001_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
diff --git a/drivers/ide/trm290.c b/drivers/ide/trm290.c
index ed14968..4b42ca0 100644
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -171,54 +171,51 @@ static void trm290_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 	local_irq_restore(flags);
 }
 
-static void trm290_selectproc (ide_drive_t *drive)
+static void trm290_dev_select(ide_drive_t *drive)
 {
 	trm290_prepare_drive(drive, !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
+
+	outb(drive->select | ATA_DEVICE_OBS, drive->hwif->io_ports.device_addr);
 }
 
-static int trm290_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
+static int trm290_dma_check(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	unsigned int count, rw;
-
 	if (cmd->tf_flags & IDE_TFLAG_WRITE) {
 #ifdef TRM290_NO_DMA_WRITES
 		/* always use PIO for writes */
-		trm290_prepare_drive(drive, 0);	/* select PIO xfer */
 		return 1;
 #endif
-		rw = 1;
-	} else
-		rw = 2;
+	}
+	return 0;
+}
+
+static int trm290_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	unsigned int count, rw = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 1 : 2;
 
 	count = ide_build_dmatable(drive, cmd);
-	if (count == 0) {
-		ide_map_sg(drive, cmd);
+	if (count == 0)
 		/* try PIO instead of DMA */
-		trm290_prepare_drive(drive, 0); /* select PIO xfer */
 		return 1;
-	}
-	/* select DMA xfer */
-	trm290_prepare_drive(drive, 1);
+
 	outl(hwif->dmatable_dma | rw, hwif->dma_base);
-	drive->waiting_for_dma = 1;
 	/* start DMA */
 	outw(count * 2 - 1, hwif->dma_base + 2);
+
 	return 0;
 }
 
 static void trm290_dma_start(ide_drive_t *drive)
 {
+	trm290_prepare_drive(drive, 1);
 }
 
 static int trm290_dma_end(ide_drive_t *drive)
 {
-	u16 status;
+	u16 status = inw(drive->hwif->dma_base + 2);
 
-	drive->waiting_for_dma = 0;
-	/* purge DMA mappings */
-	ide_destroy_dmatable(drive);
-	status = inw(drive->hwif->dma_base + 2);
+	trm290_prepare_drive(drive, 0);
 
 	return status != 0x00ff;
 }
@@ -303,8 +300,18 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 #endif
 }
 
-static const struct ide_port_ops trm290_port_ops = {
-	.selectproc		= trm290_selectproc,
+static const struct ide_tp_ops trm290_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
+
+	.dev_select		= trm290_dev_select,
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
 };
 
 static struct ide_dma_ops trm290_dma_ops = {
@@ -314,13 +321,13 @@ static struct ide_dma_ops trm290_dma_ops = {
 	.dma_end		= trm290_dma_end,
 	.dma_test_irq		= trm290_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
-	.dma_timeout		= ide_dma_timeout,
+	.dma_check		= trm290_dma_check,
 };
 
 static const struct ide_port_info trm290_chipset __devinitdata = {
 	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_trm290,
-	.port_ops	= &trm290_port_ops,
+	.tp_ops 	= &trm290_tp_ops,
 	.dma_ops	= &trm290_dma_ops,
 	.host_flags	= IDE_HFLAG_TRM290 |
 			  IDE_HFLAG_NO_ATAPI_DMA |
diff --git a/drivers/ide/tx4938ide.c b/drivers/ide/tx4938ide.c
index 657a618..4cb79c4 100644
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -92,13 +92,6 @@ static void tx4938ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA) {
-		u16 data = (tf->hob_data << 8) | tf->data;
-
-		/* no endian swap */
-		__raw_writew(data, (void __iomem *)io_ports->data_addr);
-	}
-
 	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		tx4938ide_outb(tf->hob_feature, io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
@@ -132,20 +125,11 @@ static void tx4938ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &cmd->tf;
 
-	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
-		u16 data;
-
-		/* no endian swap */
-		data = __raw_readw((void __iomem *)io_ports->data_addr);
-		tf->data = data & 0xff;
-		tf->hob_data = (data >> 8) & 0xff;
-	}
-
 	/* be sure we're looking at the low order bits */
-	tx4938ide_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
+	tx4938ide_outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
-		tf->feature = tx4938ide_inb(io_ports->feature_addr);
+	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
+		tf->error  = tx4938ide_inb(io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = tx4938ide_inb(io_ports->nsect_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
@@ -158,19 +142,18 @@ static void tx4938ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 		tf->device = tx4938ide_inb(io_ports->device_addr);
 
 	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		tx4938ide_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
+		tx4938ide_outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature =
-				tx4938ide_inb(io_ports->feature_addr);
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
+			tf->hob_error = tx4938ide_inb(io_ports->feature_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = tx4938ide_inb(io_ports->nsect_addr);
+			tf->hob_nsect = tx4938ide_inb(io_ports->nsect_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = tx4938ide_inb(io_ports->lbal_addr);
+			tf->hob_lbal  = tx4938ide_inb(io_ports->lbal_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = tx4938ide_inb(io_ports->lbam_addr);
+			tf->hob_lbam  = tx4938ide_inb(io_ports->lbam_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = tx4938ide_inb(io_ports->lbah_addr);
+			tf->hob_lbah  = tx4938ide_inb(io_ports->lbah_addr);
 	}
 }
 
@@ -204,9 +187,9 @@ static const struct ide_tp_ops tx4938ide_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
 
-	.set_irq		= ide_set_irq,
-
+	.dev_select		= ide_dev_select,
 	.tf_load		= tx4938ide_tf_load,
 	.tf_read		= tx4938ide_tf_read,
 
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index e0e0a80..0040a9a 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -279,8 +279,6 @@ use_pio_instead:
 	printk(KERN_ERR "%s: %s\n", drive->name,
 		count ? "DMA table too small" : "empty DMA table?");
 
-	ide_destroy_dmatable(drive);
-
 	return 0; /* revert to PIO for this request */
 }
 #else
@@ -294,10 +292,8 @@ static int tx4939ide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 	u8 rw = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 0 : ATA_DMA_WR;
 
 	/* fall back to PIO! */
-	if (tx4939ide_build_dmatable(drive, cmd) == 0) {
-		ide_map_sg(drive, cmd);
+	if (tx4939ide_build_dmatable(drive, cmd) == 0)
 		return 1;
-	}
 
 	/* PRD table */
 	tx4939ide_writel(hwif->dmatable_dma, base, TX4939IDE_PRD_Ptr);
@@ -308,8 +304,6 @@ static int tx4939ide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 	/* clear INTR & ERROR flags */
 	tx4939ide_clear_dma_status(base);
 
-	drive->waiting_for_dma = 1;
-
 	tx4939ide_writew(SECTOR_SIZE / 2, base, drive->dn ?
 			 TX4939IDE_Xfer_Cnt_2 : TX4939IDE_Xfer_Cnt_1);
 
@@ -325,8 +319,6 @@ static int tx4939ide_dma_end(ide_drive_t *drive)
 	void __iomem *base = TX4939IDE_BASE(hwif);
 	u16 ctl = tx4939ide_readw(base, TX4939IDE_Int_Ctl);
 
-	drive->waiting_for_dma = 0;
-
 	/* get DMA command mode */
 	dma_cmd = tx4939ide_readb(base, TX4939IDE_DMA_Cmd);
 	/* stop DMA */
@@ -335,11 +327,9 @@ static int tx4939ide_dma_end(ide_drive_t *drive)
 	/* read and clear the INTR & ERROR bits */
 	dma_stat = tx4939ide_clear_dma_status(base);
 
-	/* purge DMA mappings */
-	ide_destroy_dmatable(drive);
-	/* verify good DMA status */
 	wmb();
 
+	/* verify good DMA status */
 	if ((dma_stat & (ATA_DMA_INTR | ATA_DMA_ERR | ATA_DMA_ACTIVE)) == 0 &&
 	    (ctl & (TX4939IDE_INT_XFEREND | TX4939IDE_INT_HOST)) ==
 	    (TX4939IDE_INT_XFEREND | TX4939IDE_INT_HOST))
@@ -439,7 +429,7 @@ static void tx4939ide_tf_load_fixup(ide_drive_t *drive)
 	 * Fix ATA100 CORE System Control Register. (The write to the
 	 * Device/Head register may write wrong data to the System
 	 * Control Register)
-	 * While Sys_Ctl is written here, selectproc is not needed.
+	 * While Sys_Ctl is written here, dev_select() is not needed.
 	 */
 	tx4939ide_writew(sysctl, base, TX4939IDE_Sys_Ctl);
 }
@@ -467,13 +457,6 @@ static void tx4939ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA) {
-		u16 data = (tf->hob_data << 8) | tf->data;
-
-		/* no endian swap */
-		__raw_writew(data, (void __iomem *)io_ports->data_addr);
-	}
-
 	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		tx4939ide_outb(tf->hob_feature, io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
@@ -509,20 +492,11 @@ static void tx4939ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &cmd->tf;
 
-	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
-		u16 data;
-
-		/* no endian swap */
-		data = __raw_readw((void __iomem *)io_ports->data_addr);
-		tf->data = data & 0xff;
-		tf->hob_data = (data >> 8) & 0xff;
-	}
-
 	/* be sure we're looking at the low order bits */
-	tx4939ide_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
+	tx4939ide_outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
-		tf->feature = tx4939ide_inb(io_ports->feature_addr);
+	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
+		tf->error  = tx4939ide_inb(io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = tx4939ide_inb(io_ports->nsect_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
@@ -535,19 +509,18 @@ static void tx4939ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 		tf->device = tx4939ide_inb(io_ports->device_addr);
 
 	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		tx4939ide_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
+		tx4939ide_outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature =
-				tx4939ide_inb(io_ports->feature_addr);
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
+			tf->hob_error =	tx4939ide_inb(io_ports->feature_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = tx4939ide_inb(io_ports->nsect_addr);
+			tf->hob_nsect = tx4939ide_inb(io_ports->nsect_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = tx4939ide_inb(io_ports->lbal_addr);
+			tf->hob_lbal  = tx4939ide_inb(io_ports->lbal_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = tx4939ide_inb(io_ports->lbam_addr);
+			tf->hob_lbam  = tx4939ide_inb(io_ports->lbam_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = tx4939ide_inb(io_ports->lbah_addr);
+			tf->hob_lbah  = tx4939ide_inb(io_ports->lbah_addr);
 	}
 }
 
@@ -581,9 +554,9 @@ static const struct ide_tp_ops tx4939ide_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
 
-	.set_irq		= ide_set_irq,
-
+	.dev_select		= ide_dev_select,
 	.tf_load		= tx4939ide_tf_load,
 	.tf_read		= tx4939ide_tf_read,
 
@@ -605,9 +578,9 @@ static const struct ide_tp_ops tx4939ide_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
 
-	.set_irq		= ide_set_irq,
-
+	.dev_select		= ide_dev_select,
 	.tf_load		= tx4939ide_tf_load,
 	.tf_read		= ide_tf_read,
 
@@ -632,7 +605,6 @@ static const struct ide_dma_ops tx4939ide_dma_ops = {
 	.dma_test_irq		= tx4939ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= tx4939ide_dma_sff_read_status,
 };
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index d5d8322..a5d26f6 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -265,7 +265,7 @@ enum {
 	IDE_TFLAG_WRITE			= (1 << 12),
 	IDE_TFLAG_CUSTOM_HANDLER	= (1 << 13),
 	IDE_TFLAG_DMA_PIO_FALLBACK	= (1 << 14),
-	IDE_TFLAG_IN_HOB_FEATURE	= (1 << 15),
+	IDE_TFLAG_IN_HOB_ERROR		= (1 << 15),
 	IDE_TFLAG_IN_HOB_NSECT		= (1 << 16),
 	IDE_TFLAG_IN_HOB_LBAL		= (1 << 17),
 	IDE_TFLAG_IN_HOB_LBAM		= (1 << 18),
@@ -273,10 +273,10 @@ enum {
 	IDE_TFLAG_IN_HOB_LBA		= IDE_TFLAG_IN_HOB_LBAL |
 					  IDE_TFLAG_IN_HOB_LBAM |
 					  IDE_TFLAG_IN_HOB_LBAH,
-	IDE_TFLAG_IN_HOB		= IDE_TFLAG_IN_HOB_FEATURE |
+	IDE_TFLAG_IN_HOB		= IDE_TFLAG_IN_HOB_ERROR |
 					  IDE_TFLAG_IN_HOB_NSECT |
 					  IDE_TFLAG_IN_HOB_LBA,
-	IDE_TFLAG_IN_FEATURE		= (1 << 20),
+	IDE_TFLAG_IN_ERROR		= (1 << 20),
 	IDE_TFLAG_IN_NSECT		= (1 << 21),
 	IDE_TFLAG_IN_LBAL		= (1 << 22),
 	IDE_TFLAG_IN_LBAM		= (1 << 23),
@@ -310,8 +310,12 @@ enum {
 
 struct ide_taskfile {
 	u8	hob_data;	/*  0: high data byte (for TASKFILE IOCTL) */
+				/*  1-5: additional data to support LBA48 */
+	union {
+		u8 hob_error;	/*   read: error */
+		u8 hob_feature;	/*  write: feature */
+	};
 
-	u8	hob_feature;	/*  1-5: additional data to support LBA48 */
 	u8	hob_nsect;
 	u8	hob_lbal;
 	u8	hob_lbam;
@@ -352,6 +356,8 @@ struct ide_cmd {
 
 	unsigned int		nbytes;
 	unsigned int		nleft;
+	unsigned int		last_xfer_len;
+
 	struct scatterlist	*cursg;
 	unsigned int		cursg_ofs;
 
@@ -375,7 +381,7 @@ enum {
  * With each packet command, we allocate a buffer of IDE_PC_BUFFER_SIZE bytes.
  * This is used for several packet commands (not for READ/WRITE commands).
  */
-#define IDE_PC_BUFFER_SIZE	256
+#define IDE_PC_BUFFER_SIZE	64
 #define ATAPI_WAIT_PC		(60 * HZ)
 
 struct ide_atapi_pc {
@@ -413,9 +419,6 @@ struct ide_atapi_pc {
 	struct idetape_bh *bh;
 	char *b_data;
 
-	struct scatterlist *sg;
-	unsigned int sg_cnt;
-
 	unsigned long timeout;
 };
 
@@ -456,11 +459,6 @@ enum {
 	IDE_AFLAG_TOCADDR_AS_BCD	= (1 << 3),
 	/* TOC track numbers are in BCD. */
 	IDE_AFLAG_TOCTRACKS_AS_BCD	= (1 << 4),
-	/*
-	 * Drive does not provide data in multiples of SECTOR_SIZE
-	 * when more than one interrupt is needed.
-	 */
-	IDE_AFLAG_LIMIT_NFRAMES		= (1 << 5),
 	/* Saved TOC information is current. */
 	IDE_AFLAG_TOC_VALID		= (1 << 6),
 	/* We think that the drive door is locked. */
@@ -605,7 +603,7 @@ struct ide_drive_s {
 
 	unsigned int	bios_cyl;	/* BIOS/fdisk/LILO number of cyls */
 	unsigned int	cyl;		/* "real" number of cyls */
-	unsigned int	drive_data;	/* used by set_pio_mode/selectproc */
+	unsigned int	drive_data;	/* used by set_pio_mode/dev_select() */
 	unsigned int	failures;	/* current failure count */
 	unsigned int	max_failures;	/* maximum allowed failure count */
 	u64		probed_capacity;/* initial reported media capacity (ide-cd only currently) */
@@ -661,9 +659,9 @@ struct ide_tp_ops {
 	void	(*exec_command)(struct hwif_s *, u8);
 	u8	(*read_status)(struct hwif_s *);
 	u8	(*read_altstatus)(struct hwif_s *);
+	void	(*write_devctl)(struct hwif_s *, u8);
 
-	void	(*set_irq)(struct hwif_s *, int);
-
+	void	(*dev_select)(ide_drive_t *);
 	void	(*tf_load)(ide_drive_t *, struct ide_cmd *);
 	void	(*tf_read)(ide_drive_t *, struct ide_cmd *);
 
@@ -681,7 +679,6 @@ extern const struct ide_tp_ops default_tp_ops;
  * @init_dev:		host specific initialization of a device
  * @set_pio_mode:	routine to program host for PIO mode
  * @set_dma_mode:	routine to program host for DMA mode
- * @selectproc:		tweaks hardware to select drive
  * @reset_poll:		chipset polling based on hba specifics
  * @pre_reset:		chipset specific changes to default for device-hba resets
  * @resetproc:		routine to reset controller after a disk reset
@@ -698,7 +695,6 @@ struct ide_port_ops {
 	void	(*init_dev)(ide_drive_t *);
 	void	(*set_pio_mode)(ide_drive_t *, const u8);
 	void	(*set_dma_mode)(ide_drive_t *, const u8);
-	void	(*selectproc)(ide_drive_t *);
 	int	(*reset_poll)(ide_drive_t *);
 	void	(*pre_reset)(ide_drive_t *);
 	void	(*resetproc)(ide_drive_t *);
@@ -719,8 +715,10 @@ struct ide_dma_ops {
 	int	(*dma_end)(struct ide_drive_s *);
 	int	(*dma_test_irq)(struct ide_drive_s *);
 	void	(*dma_lost_irq)(struct ide_drive_s *);
+	/* below ones are optional */
+	int	(*dma_check)(struct ide_drive_s *, struct ide_cmd *);
 	int	(*dma_timer_expiry)(struct ide_drive_s *);
-	void	(*dma_timeout)(struct ide_drive_s *);
+	void	(*dma_clear)(struct ide_drive_s *);
 	/*
 	 * The following method is optional and only required to be
 	 * implemented for the SFF-8038i compatible controllers.
@@ -1169,18 +1167,15 @@ void ide_tf_dump(const char *, struct ide_taskfile *);
 void ide_exec_command(ide_hwif_t *, u8);
 u8 ide_read_status(ide_hwif_t *);
 u8 ide_read_altstatus(ide_hwif_t *);
+void ide_write_devctl(ide_hwif_t *, u8);
 
-void ide_set_irq(ide_hwif_t *, int);
-
+void ide_dev_select(ide_drive_t *);
 void ide_tf_load(ide_drive_t *, struct ide_cmd *);
 void ide_tf_read(ide_drive_t *, struct ide_cmd *);
 
 void ide_input_data(ide_drive_t *, struct ide_cmd *, void *, unsigned int);
 void ide_output_data(ide_drive_t *, struct ide_cmd *, void *, unsigned int);
 
-int ide_io_buffers(ide_drive_t *, struct ide_atapi_pc *, unsigned int, int);
-
-extern void SELECT_DRIVE(ide_drive_t *);
 void SELECT_MASK(ide_drive_t *, int);
 
 u8 ide_read_error(ide_drive_t *);
@@ -1226,6 +1221,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t *, struct ide_cmd *);
 
 ide_startstop_t do_rw_taskfile(ide_drive_t *, struct ide_cmd *);
 
+void ide_pio_bytes(ide_drive_t *, struct ide_cmd *, unsigned int, unsigned int);
+
 void ide_finish_cmd(ide_drive_t *, struct ide_cmd *, u8);
 
 int ide_raw_taskfile(ide_drive_t *, struct ide_cmd *, u8 *, u16);
@@ -1443,8 +1440,8 @@ ide_startstop_t ide_dma_intr(ide_drive_t *);
 int ide_allocate_dma_engine(ide_hwif_t *);
 void ide_release_dma_engine(ide_hwif_t *);
 
-int ide_build_sglist(ide_drive_t *, struct ide_cmd *);
-void ide_destroy_dmatable(ide_drive_t *);
+int ide_dma_prepare(ide_drive_t *, struct ide_cmd *);
+void ide_dma_unmap_sg(ide_drive_t *, struct ide_cmd *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 int config_drive_for_dma(ide_drive_t *);
@@ -1462,7 +1459,6 @@ static inline int config_drive_for_dma(ide_drive_t *drive) { return 0; }
 #endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
 
 void ide_dma_lost_irq(ide_drive_t *);
-void ide_dma_timeout(ide_drive_t *);
 ide_startstop_t ide_dma_timeout_retry(ide_drive_t *, int);
 
 #else
@@ -1478,8 +1474,10 @@ static inline void ide_check_dma_crc(ide_drive_t *drive) { ; }
 static inline ide_startstop_t ide_dma_intr(ide_drive_t *drive) { return ide_stopped; }
 static inline ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error) { return ide_stopped; }
 static inline void ide_release_dma_engine(ide_hwif_t *hwif) { ; }
-static inline int ide_build_sglist(ide_drive_t *drive,
-				   struct ide_cmd *cmd) { return 0; }
+static inline int ide_dma_prepare(ide_drive_t *drive,
+				  struct ide_cmd *cmd) { return 1; }
+static inline void ide_dma_unmap_sg(ide_drive_t *drive,
+				    struct ide_cmd *cmd) { ; }
 #endif /* CONFIG_BLK_DEV_IDEDMA */
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
