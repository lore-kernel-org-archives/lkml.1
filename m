Return-Path: <linux-kernel-owner+w=401wt.eu-S1763676AbYBFCBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763676AbYBFCBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 21:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758807AbYBFCAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 21:00:54 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:15858 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759693AbYBFCAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 21:00:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=c0wuv5cCDi92e3uj3qb6W1ZK7fyG8Hg6ch4w5AmnCKmSku4KQFmNPFZQhWSO8WHttJFJh2fcCYipyDY6HuDxnqPBJgCV8gq5B5sfwwpauRLN7wW52YDjICED+EwGi48oHPIQWNssd9s1Wfpjoal/8lSOZ/NiO2noGd84FGN1Hn4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates part #5
Date: Wed, 6 Feb 2008 03:11:02 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060311.03791.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* new IDE host driver for Palmchip BK3710 chipset
  (Anton Salnikov@MontaVista)

* second part of ide-tape redux patches
  (Borislav Petkov)

* ide-generic bugfix

* minor fixups/cleanups


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/kernel-parameters.txt |    3 +
 drivers/ide/Kconfig                 |    9 +
 drivers/ide/arm/Makefile            |    1 +
 drivers/ide/arm/icside.c            |    2 +-
 drivers/ide/arm/palm_bk3710.c       |  395 ++++++
 drivers/ide/cris/ide-cris.c         |   33 +-
 drivers/ide/ide-acpi.c              |    2 +-
 drivers/ide/ide-cd.c                |    9 +-
 drivers/ide/ide-dma.c               |    3 +-
 drivers/ide/ide-floppy.c            |    6 +-
 drivers/ide/ide-generic.c           |   10 +-
 drivers/ide/ide-io.c                |   14 +-
 drivers/ide/ide-iops.c              |   45 +-
 drivers/ide/ide-lib.c               |    2 +-
 drivers/ide/ide-probe.c             |   47 +-
 drivers/ide/ide-proc.c              |    1 +
 drivers/ide/ide-tape.c              | 2400 ++++++++++++++++-------------------
 drivers/ide/ide-taskfile.c          |   35 +-
 drivers/ide/ide.c                   |   54 -
 drivers/ide/legacy/buddha.c         |   72 +-
 drivers/ide/legacy/falconide.c      |   42 +-
 drivers/ide/legacy/gayle.c          |   39 +-
 drivers/ide/legacy/hd.c             |    9 +-
 drivers/ide/legacy/macide.c         |   57 +-
 drivers/ide/legacy/q40ide.c         |    9 +-
 drivers/ide/pci/Makefile            |    3 +-
 drivers/ide/pci/generic.c           |   13 -
 drivers/ide/pci/siimage.c           |    3 -
 drivers/macintosh/mediabay.c        |   46 +-
 drivers/scsi/ide-scsi.c             |    4 +-
 include/asm-powerpc/mediabay.h      |    8 +-
 include/linux/ide.h                 |   42 +-
 32 files changed, 1825 insertions(+), 1593 deletions(-)
 create mode 100644 drivers/ide/arm/palm_bk3710.c


Andrew Morton (2):
      drivers/ide/ide-acpi.c: fix uninitialized var warning
      drivers/ide/legacy/hd.c: fix uninitialized var warning

Anton Salnikov (1):
      Palmchip BK3710 IDE driver

Bartlomiej Zolnierkiewicz (7):
      ide-generic: probing bugfix
      ppc: fix #ifdef-s in mediabay driver (take 2)
      ide: remove write-only ->sata_misc[] from ide_hwif_t
      ide: remove redundant BUG_ON() from [atapi_]reset_pollfunc()
      ide: remove ide_setup_ports()
      ide: add ide_read_[alt]status() inline helpers
      ide: add ide_read_error() inline helper

Borislav Petkov (18):
      ide-tape: refactor the debug logging facility
      ide-tape: remove struct idetape_read_position_result_t
      ide-tape: remove unreachable code chunk
      ide-tape: simplify code branching in the interrupt handler
      ide-tape: remove typedef idetape_chrdev_direction_t
      ide-tape: struct idetape_tape_t: remove unused members
      ide-tape: struct idetape_tape_t: shorten member names v2
      ide-tape: remove idetape_increase_max_pipeline_stages()
      ide-tape: shorten some function names
      ide-tape: cleanup and fix comments
      ide-tape: remove struct idetape_id_gcw
      ide-tape: remove unused "length" arg from idetape_create_read_buffer_cmd()
      ide-tape: include proper headers
      ide-tape: collect module-related macro calls at the end
      ide-tape: remove leftover OnStream support warning
      ide-tape: fix syntax error in idetape_identify_device()
      ide-tape: cleanup the remaining codestyle issues
      ide-tape: bump minor driver version

Denis Cheng (1):
      ide-pci-generic: kill the unused ifdef/endif/MODULE code


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9ad4e6f..8fd5aa4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -780,6 +780,9 @@ and is between 256 and 4096 characters. It is defined in the file
 			loop use the MONITOR/MWAIT idle loop anyways. Performance should be the same
 			as idle=poll.
 
+	ide-pci-generic.all-generic-ide [HW] (E)IDE subsystem
+			Claim all unknown PCI IDE storage controllers.
+
 	ignore_loglevel	[KNL]
 			Ignore loglevel setting - this will print /all/
 			kernel messages to the console. Useful for debugging.
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 45b26ed..ab8fb25 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -1009,6 +1009,15 @@ config BLK_DEV_Q40IDE
 	  normally be on; disable it only if you are running a custom hard
 	  drive subsystem through an expansion card.
 
+config BLK_DEV_PALMCHIP_BK3710
+	tristate "Palmchip bk3710 IDE controller support"
+	depends on ARCH_DAVINCI
+	select BLK_DEV_IDEDMA_PCI
+	help
+	  Say Y here if you want to support the onchip IDE controller on the
+	  TI DaVinci SoC
+
+
 config BLK_DEV_MPC8xx_IDE
 	tristate "MPC8xx IDE support"
 	depends on 8xx && (LWMON || IVMS8 || IVML24 || TQM8xxL) && IDE=y && BLK_DEV_IDE=y && !PPC_MERGE
diff --git a/drivers/ide/arm/Makefile b/drivers/ide/arm/Makefile
index 5f63ad2..936e7b0 100644
--- a/drivers/ide/arm/Makefile
+++ b/drivers/ide/arm/Makefile
@@ -2,6 +2,7 @@
 obj-$(CONFIG_BLK_DEV_IDE_ICSIDE)	+= icside.o
 obj-$(CONFIG_BLK_DEV_IDE_RAPIDE)	+= rapide.o
 obj-$(CONFIG_BLK_DEV_IDE_BAST)		+= bast-ide.o
+obj-$(CONFIG_BLK_DEV_PALMCHIP_BK3710)	+= palm_bk3710.o
 
 ifeq ($(CONFIG_IDE_ARM), m)
 	obj-m += ide_arm.o
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index fb00f38..e816b0f 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -365,7 +365,7 @@ static void icside_dma_timeout(ide_drive_t *drive)
 	if (icside_dma_test_irq(drive))
 		return;
 
-	ide_dump_status(drive, "DMA timeout", HWIF(drive)->INB(IDE_STATUS_REG));
+	ide_dump_status(drive, "DMA timeout", ide_read_status(drive));
 
 	icside_dma_end(drive);
 }
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
new file mode 100644
index 0000000..c306997
--- /dev/null
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -0,0 +1,395 @@
+/*
+ * Palmchip bk3710 IDE controller
+ *
+ * Copyright (C) 2006 Texas Instruments.
+ * Copyright (C) 2007 MontaVista Software, Inc., <source@mvista.com>
+ *
+ * ----------------------------------------------------------------------------
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
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * ----------------------------------------------------------------------------
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/ioport.h>
+#include <linux/hdreg.h>
+#include <linux/ide.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+
+/* Offset of the primary interface registers */
+#define IDE_PALM_ATA_PRI_REG_OFFSET 0x1F0
+
+/* Primary Control Offset */
+#define IDE_PALM_ATA_PRI_CTL_OFFSET 0x3F6
+
+/*
+ * PalmChip 3710 IDE Controller UDMA timing structure Definition
+ */
+struct palm_bk3710_udmatiming {
+	unsigned int rptime;	/* Ready to pause time  */
+	unsigned int cycletime;	/* Cycle Time           */
+};
+
+#define BK3710_BMICP		0x00
+#define BK3710_BMISP		0x02
+#define BK3710_BMIDTP		0x04
+#define BK3710_BMICS		0x08
+#define BK3710_BMISS		0x0A
+#define BK3710_BMIDTS		0x0C
+#define BK3710_IDETIMP		0x40
+#define BK3710_IDETIMS		0x42
+#define BK3710_SIDETIM		0x44
+#define BK3710_SLEWCTL		0x45
+#define BK3710_IDESTATUS	0x47
+#define BK3710_UDMACTL		0x48
+#define BK3710_UDMATIM		0x4A
+#define BK3710_MISCCTL		0x50
+#define BK3710_REGSTB		0x54
+#define BK3710_REGRCVR		0x58
+#define BK3710_DATSTB		0x5C
+#define BK3710_DATRCVR		0x60
+#define BK3710_DMASTB		0x64
+#define BK3710_DMARCVR		0x68
+#define BK3710_UDMASTB		0x6C
+#define BK3710_UDMATRP		0x70
+#define BK3710_UDMAENV		0x74
+#define BK3710_IORDYTMP		0x78
+#define BK3710_IORDYTMS		0x7C
+
+#include "../ide-timing.h"
+
+static long ide_palm_clk;
+
+static const struct palm_bk3710_udmatiming palm_bk3710_udmatimings[6] = {
+	{160, 240},		/* UDMA Mode 0 */
+	{125, 160},		/* UDMA Mode 1 */
+	{100, 120},		/* UDMA Mode 2 */
+	{100, 90},		/* UDMA Mode 3 */
+	{85,  60},		/* UDMA Mode 4 */
+};
+
+static struct clk *ideclkp;
+
+static void palm_bk3710_setudmamode(void __iomem *base, unsigned int dev,
+				    unsigned int mode)
+{
+	u8 tenv, trp, t0;
+	u32 val32;
+	u16 val16;
+
+	/* DMA Data Setup */
+	t0 = (palm_bk3710_udmatimings[mode].cycletime + ide_palm_clk - 1)
+			/ ide_palm_clk - 1;
+	tenv = (20 + ide_palm_clk - 1) / ide_palm_clk - 1;
+	trp = (palm_bk3710_udmatimings[mode].rptime + ide_palm_clk - 1)
+			/ ide_palm_clk - 1;
+
+	/* udmatim Register */
+	val16 = readw(base + BK3710_UDMATIM) & (dev ? 0xFF0F : 0xFFF0);
+	val16 |= (mode << (dev ? 4 : 0));
+	writew(val16, base + BK3710_UDMATIM);
+
+	/* udmastb Ultra DMA Access Strobe Width */
+	val32 = readl(base + BK3710_UDMASTB) & (0xFF << (dev ? 0 : 8));
+	val32 |= (t0 << (dev ? 8 : 0));
+	writel(val32, base + BK3710_UDMASTB);
+
+	/* udmatrp Ultra DMA Ready to Pause Time */
+	val32 = readl(base + BK3710_UDMATRP) & (0xFF << (dev ? 0 : 8));
+	val32 |= (trp << (dev ? 8 : 0));
+	writel(val32, base + BK3710_UDMATRP);
+
+	/* udmaenv Ultra DMA envelop Time */
+	val32 = readl(base + BK3710_UDMAENV) & (0xFF << (dev ? 0 : 8));
+	val32 |= (tenv << (dev ? 8 : 0));
+	writel(val32, base + BK3710_UDMAENV);
+
+	/* Enable UDMA for Device */
+	val16 = readw(base + BK3710_UDMACTL) | (1 << dev);
+	writew(val16, base + BK3710_UDMACTL);
+}
+
+static void palm_bk3710_setdmamode(void __iomem *base, unsigned int dev,
+				   unsigned short min_cycle,
+				   unsigned int mode)
+{
+	u8 td, tkw, t0;
+	u32 val32;
+	u16 val16;
+	struct ide_timing *t;
+	int cycletime;
+
+	t = ide_timing_find_mode(mode);
+	cycletime = max_t(int, t->cycle, min_cycle);
+
+	/* DMA Data Setup */
+	t0 = (cycletime + ide_palm_clk - 1) / ide_palm_clk;
+	td = (t->active + ide_palm_clk - 1) / ide_palm_clk;
+	tkw = t0 - td - 1;
+	td -= 1;
+
+	val32 = readl(base + BK3710_DMASTB) & (0xFF << (dev ? 0 : 8));
+	val32 |= (td << (dev ? 8 : 0));
+	writel(val32, base + BK3710_DMASTB);
+
+	val32 = readl(base + BK3710_DMARCVR) & (0xFF << (dev ? 0 : 8));
+	val32 |= (tkw << (dev ? 8 : 0));
+	writel(val32, base + BK3710_DMARCVR);
+
+	/* Disable UDMA for Device */
+	val16 = readw(base + BK3710_UDMACTL) & ~(1 << dev);
+	writew(val16, base + BK3710_UDMACTL);
+}
+
+static void palm_bk3710_setpiomode(void __iomem *base, ide_drive_t *mate,
+				   unsigned int dev, unsigned int cycletime,
+				   unsigned int mode)
+{
+	u8 t2, t2i, t0;
+	u32 val32;
+	struct ide_timing *t;
+
+	/* PIO Data Setup */
+	t0 = (cycletime + ide_palm_clk - 1) / ide_palm_clk;
+	t2 = (ide_timing_find_mode(XFER_PIO_0 + mode)->active +
+	      ide_palm_clk - 1)	/ ide_palm_clk;
+
+	t2i = t0 - t2 - 1;
+	t2 -= 1;
+
+	val32 = readl(base + BK3710_DATSTB) & (0xFF << (dev ? 0 : 8));
+	val32 |= (t2 << (dev ? 8 : 0));
+	writel(val32, base + BK3710_DATSTB);
+
+	val32 = readl(base + BK3710_DATRCVR) & (0xFF << (dev ? 0 : 8));
+	val32 |= (t2i << (dev ? 8 : 0));
+	writel(val32, base + BK3710_DATRCVR);
+
+	if (mate && mate->present) {
+		u8 mode2 = ide_get_best_pio_mode(mate, 255, 4);
+
+		if (mode2 < mode)
+			mode = mode2;
+	}
+
+	/* TASKFILE Setup */
+	t = ide_timing_find_mode(XFER_PIO_0 + mode);
+	t0 = (t->cyc8b + ide_palm_clk - 1) / ide_palm_clk;
+	t2 = (t->act8b + ide_palm_clk - 1) / ide_palm_clk;
+
+	t2i = t0 - t2 - 1;
+	t2 -= 1;
+
+	val32 = readl(base + BK3710_REGSTB) & (0xFF << (dev ? 0 : 8));
+	val32 |= (t2 << (dev ? 8 : 0));
+	writel(val32, base + BK3710_REGSTB);
+
+	val32 = readl(base + BK3710_REGRCVR) & (0xFF << (dev ? 0 : 8));
+	val32 |= (t2i << (dev ? 8 : 0));
+	writel(val32, base + BK3710_REGRCVR);
+}
+
+static void palm_bk3710_set_dma_mode(ide_drive_t *drive, u8 xferspeed)
+{
+	int is_slave = drive->dn & 1;
+	void __iomem *base = (void *)drive->hwif->dma_base;
+
+	if (xferspeed >= XFER_UDMA_0) {
+		palm_bk3710_setudmamode(base, is_slave,
+					xferspeed - XFER_UDMA_0);
+	} else {
+		palm_bk3710_setdmamode(base, is_slave, drive->id->eide_dma_min,
+				       xferspeed);
+	}
+}
+
+static void palm_bk3710_set_pio_mode(ide_drive_t *drive, u8 pio)
+{
+	unsigned int cycle_time;
+	int is_slave = drive->dn & 1;
+	ide_drive_t *mate;
+	void __iomem *base = (void *)drive->hwif->dma_base;
+
+	/*
+	 * Obtain the drive PIO data for tuning the Palm Chip registers
+	 */
+	cycle_time = ide_pio_cycle_time(drive, pio);
+	mate = ide_get_paired_drive(drive);
+	palm_bk3710_setpiomode(base, mate, is_slave, cycle_time, pio);
+}
+
+static void __devinit palm_bk3710_chipinit(void __iomem *base)
+{
+	/*
+	 * enable the reset_en of ATA controller so that when ata signals
+	 * are brought out, by writing into device config. at that
+	 * time por_n signal should not be 'Z' and have a stable value.
+	 */
+	writel(0x0300, base + BK3710_MISCCTL);
+
+	/* wait for some time and deassert the reset of ATA Device. */
+	mdelay(100);
+
+	/* Deassert the Reset */
+	writel(0x0200, base + BK3710_MISCCTL);
+
+	/*
+	 * Program the IDETIMP Register Value based on the following assumptions
+	 *
+	 * (ATA_IDETIMP_IDEEN		, ENABLE ) |
+	 * (ATA_IDETIMP_SLVTIMEN	, DISABLE) |
+	 * (ATA_IDETIMP_RDYSMPL		, 70NS)    |
+	 * (ATA_IDETIMP_RDYRCVRY	, 50NS)    |
+	 * (ATA_IDETIMP_DMAFTIM1	, PIOCOMP) |
+	 * (ATA_IDETIMP_PREPOST1	, DISABLE) |
+	 * (ATA_IDETIMP_RDYSEN1		, DISABLE) |
+	 * (ATA_IDETIMP_PIOFTIM1	, DISABLE) |
+	 * (ATA_IDETIMP_DMAFTIM0	, PIOCOMP) |
+	 * (ATA_IDETIMP_PREPOST0	, DISABLE) |
+	 * (ATA_IDETIMP_RDYSEN0		, DISABLE) |
+	 * (ATA_IDETIMP_PIOFTIM0	, DISABLE)
+	 */
+	writew(0xB388, base + BK3710_IDETIMP);
+
+	/*
+	 * Configure  SIDETIM  Register
+	 * (ATA_SIDETIM_RDYSMPS1	,120NS ) |
+	 * (ATA_SIDETIM_RDYRCYS1	,120NS )
+	 */
+	writeb(0, base + BK3710_SIDETIM);
+
+	/*
+	 * UDMACTL Ultra-ATA DMA Control
+	 * (ATA_UDMACTL_UDMAP1	, 0 ) |
+	 * (ATA_UDMACTL_UDMAP0	, 0 )
+	 *
+	 */
+	writew(0, base + BK3710_UDMACTL);
+
+	/*
+	 * MISCCTL Miscellaneous Conrol Register
+	 * (ATA_MISCCTL_RSTMODEP	, 1) |
+	 * (ATA_MISCCTL_RESETP		, 0) |
+	 * (ATA_MISCCTL_TIMORIDE	, 1)
+	 */
+	writel(0x201, base + BK3710_MISCCTL);
+
+	/*
+	 * IORDYTMP IORDY Timer for Primary Register
+	 * (ATA_IORDYTMP_IORDYTMP     , 0xffff  )
+	 */
+	writel(0xFFFF, base + BK3710_IORDYTMP);
+
+	/*
+	 * Configure BMISP Register
+	 * (ATA_BMISP_DMAEN1	, DISABLE )	|
+	 * (ATA_BMISP_DMAEN0	, DISABLE )	|
+	 * (ATA_BMISP_IORDYINT	, CLEAR)	|
+	 * (ATA_BMISP_INTRSTAT	, CLEAR)	|
+	 * (ATA_BMISP_DMAERROR	, CLEAR)
+	 */
+	writew(0, base + BK3710_BMISP);
+
+	palm_bk3710_setpiomode(base, NULL, 0, 600, 0);
+	palm_bk3710_setpiomode(base, NULL, 1, 600, 0);
+}
+static int __devinit palm_bk3710_probe(struct platform_device *pdev)
+{
+	hw_regs_t ide_ctlr_info;
+	int index = 0;
+	int pribase;
+	struct clk *clkp;
+	struct resource *mem, *irq;
+	ide_hwif_t *hwif;
+	void __iomem *base;
+
+	clkp = clk_get(NULL, "IDECLK");
+	if (IS_ERR(clkp))
+		return -ENODEV;
+
+	ideclkp = clkp;
+	clk_enable(ideclkp);
+	ide_palm_clk = clk_get_rate(ideclkp)/100000;
+	ide_palm_clk = (10000/ide_palm_clk) + 1;
+	/* Register the IDE interface with Linux ATA Interface */
+	memset(&ide_ctlr_info, 0, sizeof(ide_ctlr_info));
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (mem == NULL) {
+		printk(KERN_ERR "failed to get memory region resource\n");
+		return -ENODEV;
+	}
+	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (irq == NULL) {
+		printk(KERN_ERR "failed to get IRQ resource\n");
+		return -ENODEV;
+	}
+
+	base = (void *)mem->start;
+
+	/* Configure the Palm Chip controller */
+	palm_bk3710_chipinit(base);
+
+	pribase = mem->start + IDE_PALM_ATA_PRI_REG_OFFSET;
+	for (index = 0; index < IDE_NR_PORTS - 2; index++)
+		ide_ctlr_info.io_ports[index] = pribase + index;
+	ide_ctlr_info.io_ports[IDE_CONTROL_OFFSET] = mem->start +
+			IDE_PALM_ATA_PRI_CTL_OFFSET;
+	ide_ctlr_info.irq = irq->start;
+	ide_ctlr_info.chipset = ide_palm3710;
+
+	if (ide_register_hw(&ide_ctlr_info, NULL, &hwif) < 0) {
+		printk(KERN_WARNING "Palm Chip BK3710 IDE Register Fail\n");
+		return -ENODEV;
+	}
+
+	hwif->set_pio_mode = &palm_bk3710_set_pio_mode;
+	hwif->set_dma_mode = &palm_bk3710_set_dma_mode;
+	hwif->mmio = 1;
+	default_hwif_mmiops(hwif);
+	hwif->cbl = ATA_CBL_PATA80;
+	hwif->ultra_mask = 0x1f;	/* Ultra DMA Mode 4 Max
+						(input clk 99MHz) */
+	hwif->mwdma_mask = 0x7;
+	hwif->drives[0].autotune = 1;
+	hwif->drives[1].autotune = 1;
+
+	ide_setup_dma(hwif, mem->start);
+
+	return 0;
+}
+
+static struct platform_driver platform_bk_driver = {
+	.driver = {
+		.name = "palm_bk3710",
+	},
+	.probe = palm_bk3710_probe,
+	.remove = NULL,
+};
+
+static int __init palm_bk3710_init(void)
+{
+	return platform_driver_register(&platform_bk_driver);
+}
+
+module_init(palm_bk3710_init);
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 00587a8..e79bf8f 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -753,6 +753,25 @@ static void cris_set_dma_mode(ide_drive_t *drive, const u8 speed)
 		cris_ide_set_speed(TYPE_DMA, 0, strobe, hold);
 }
 
+static void __init cris_setup_ports(hw_regs_t *hw, unsigned long base)
+{
+	int i;
+
+	memset(hw, 0, sizeof(*hw));
+
+	for (i = 0; i <= 7; i++)
+		hw->io_ports[i] = base + cris_ide_reg_addr(i, 0, 1);
+
+	/*
+	 * the IDE control register is at ATA address 6,
+	 * with CS1 active instead of CS0
+	 */
+	hw->io_ports[IDE_CONTROL_OFFSET] = base + cris_ide_reg_addr(6, 1, 0);
+
+	hw->irq = ide_default_irq(0);
+	hw->ack_intr = cris_ide_ack_intr;
+}
+
 static const struct ide_port_info cris_port_info __initdata = {
 	.chipset		= ide_etrax100,
 	.host_flags		= IDE_HFLAG_NO_ATAPI_DMA |
@@ -765,24 +784,16 @@ static const struct ide_port_info cris_port_info __initdata = {
 static int __init init_e100_ide(void)
 {
 	hw_regs_t hw;
-	int ide_offsets[IDE_NR_PORTS], h, i;
+	int h;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	printk("ide: ETRAX FS built-in ATA DMA controller\n");
 
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
-		ide_offsets[i] = cris_ide_reg_addr(i, 0, 1);
-
-	/* the IDE control register is at ATA address 6, with CS1 active instead of CS0 */
-	ide_offsets[IDE_CONTROL_OFFSET] = cris_ide_reg_addr(6, 1, 0);
-
 	for (h = 0; h < 4; h++) {
 		ide_hwif_t *hwif = NULL;
 
-		ide_setup_ports(&hw, cris_ide_base_address(h),
-		                ide_offsets,
-		                0, 0, cris_ide_ack_intr,
-		                ide_default_irq(0));
+		cris_setup_ports(&hw, cris_ide_base_address(h));
+
 		hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
 		if (hwif == NULL)
 			continue;
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 25aaeae..e07b189 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -171,7 +171,7 @@ err:
 static acpi_handle ide_acpi_hwif_get_handle(ide_hwif_t *hwif)
 {
 	struct device		*dev = hwif->gendev.parent;
-	acpi_handle		dev_handle;
+	acpi_handle		uninitialized_var(dev_handle);
 	acpi_integer		pcidevfn;
 	acpi_handle		chan_handle;
 	int			err;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index ee4d458..5e42c19 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -295,7 +295,8 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 	int stat, err, sense_key;
 	
 	/* Check for errors. */
-	stat = HWIF(drive)->INB(IDE_STATUS_REG);
+	stat = ide_read_status(drive);
+
 	if (stat_ret)
 		*stat_ret = stat;
 
@@ -303,7 +304,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		return 0;
 
 	/* Get the IDE error register. */
-	err = HWIF(drive)->INB(IDE_ERROR_REG);
+	err = ide_read_error(drive);
 	sense_key = err >> 4;
 
 	if (rq == NULL) {
@@ -692,7 +693,7 @@ int ide_cd_check_ireason(ide_drive_t *drive, int len, int ireason, int rw)
 		/* Some drives (ASUS) seem to tell us that status
 		 * info is available. just get it and ignore.
 		 */
-		(void) HWIF(drive)->INB(IDE_STATUS_REG);
+		(void)ide_read_status(drive);
 		return 0;
 	} else {
 		/* Drive wants a command packet, or invalid ireason... */
@@ -1326,7 +1327,7 @@ ide_do_rw_cdrom (ide_drive_t *drive, struct request *rq, sector_t block)
 	if (blk_fs_request(rq)) {
 		if (info->cd_flags & IDE_CD_FLAG_SEEKING) {
 			unsigned long elapsed = jiffies - info->start_seek;
-			int stat = HWIF(drive)->INB(IDE_STATUS_REG);
+			int stat = ide_read_status(drive);
 
 			if ((stat & SEEK_STAT) != SEEK_STAT) {
 				if (elapsed < IDECD_SEEK_TIMEOUT) {
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 3cf59f2..a4bb328 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -147,7 +147,8 @@ ide_startstop_t ide_dma_intr (ide_drive_t *drive)
 	u8 stat = 0, dma_stat = 0;
 
 	dma_stat = HWIF(drive)->ide_dma_end(drive);
-	stat = HWIF(drive)->INB(IDE_STATUS_REG);	/* get drive status */
+	stat = ide_read_status(drive);
+
 	if (OK_STAT(stat,DRIVE_READY,drive->bad_wstat|DRQ_STAT)) {
 		if (!dma_stat) {
 			struct request *rq = HWGROUP(drive)->rq;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index f8fe6ee..faf22d7 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -465,7 +465,7 @@ static void idefloppy_retry_pc(ide_drive_t *drive)
 	idefloppy_pc_t *pc;
 	struct request *rq;
 
-	(void)drive->hwif->INB(IDE_ERROR_REG);
+	(void)ide_read_error(drive);
 	pc = idefloppy_next_pc_storage(drive);
 	rq = idefloppy_next_rq_storage(drive);
 	idefloppy_create_request_sense_cmd(pc);
@@ -501,7 +501,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	}
 
 	/* Clear the interrupt */
-	stat = drive->hwif->INB(IDE_STATUS_REG);
+	stat = ide_read_status(drive);
 
 	/* No more interrupts */
 	if ((stat & DRQ_STAT) == 0) {
@@ -1246,7 +1246,7 @@ static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 		u8 stat;
 
 		local_irq_save(flags);
-		stat = drive->hwif->INB(IDE_STATUS_REG);
+		stat = ide_read_status(drive);
 		local_irq_restore(flags);
 
 		progress_indication = ((stat & SEEK_STAT) == 0) ? 0 : 0x10000;
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index be469db..709b9e4 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -20,8 +20,14 @@ static int __init ide_generic_init(void)
 	if (ide_hwifs[0].io_ports[IDE_DATA_OFFSET])
 		ide_get_lock(NULL, NULL); /* for atari only */
 
-	for (i = 0; i < MAX_HWIFS; i++)
-		idx[i] = ide_hwifs[i].present ? 0xff : i;
+	for (i = 0; i < MAX_HWIFS; i++) {
+		ide_hwif_t *hwif = &ide_hwifs[i];
+
+		if (hwif->io_ports[IDE_DATA_OFFSET] && !hwif->present)
+			idx[i] = i;
+		else
+			idx[i] = 0xff;
+	}
 
 	ide_device_add_all(idx, NULL);
 
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 4bddef0..3addbe4 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -466,7 +466,7 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
 		return ide_stopped;
 	}
 
-	if (hwif->INB(IDE_STATUS_REG) & (BUSY_STAT|DRQ_STAT))
+	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		rq->errors |= ERROR_RESET;
 
 	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
@@ -493,7 +493,7 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq, u
 		/* add decoding error stuff */
 	}
 
-	if (hwif->INB(IDE_STATUS_REG) & (BUSY_STAT|DRQ_STAT))
+	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
 		hwif->OUTB(WIN_IDLEIMMEDIATE, IDE_COMMAND_REG);
 
@@ -821,9 +821,8 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 #ifdef DEBUG
  	printk("%s: DRIVE_CMD (null)\n", drive->name);
 #endif
- 	ide_end_drive_cmd(drive,
-			hwif->INB(IDE_STATUS_REG),
-			hwif->INB(IDE_ERROR_REG));
+	ide_end_drive_cmd(drive, ide_read_status(drive), ide_read_error(drive));
+
  	return ide_stopped;
 }
 
@@ -1231,7 +1230,7 @@ static ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
 		(void)HWIF(drive)->ide_dma_end(drive);
 		ret = ide_error(drive, "dma timeout error",
-						hwif->INB(IDE_STATUS_REG));
+				ide_read_status(drive));
 	} else {
 		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
 		hwif->dma_timeout(drive);
@@ -1355,7 +1354,8 @@ void ide_timer_expiry (unsigned long data)
 					startstop = ide_dma_timeout_retry(drive, wait);
 				} else
 					startstop =
-					ide_error(drive, "irq timeout", hwif->INB(IDE_STATUS_REG));
+					ide_error(drive, "irq timeout",
+						  ide_read_status(drive));
 			}
 			drive->service_time = jiffies - drive->service_start;
 			spin_lock_irq(&ide_lock);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index a95178f..c32e759 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -430,10 +430,10 @@ int drive_is_ready (ide_drive_t *drive)
 	 * about possible isa-pnp and pci-pnp issues yet.
 	 */
 	if (IDE_CONTROL_REG)
-		stat = hwif->INB(IDE_ALTSTATUS_REG);
+		stat = ide_read_altstatus(drive);
 	else
 		/* Note: this may clear a pending IRQ!! */
-		stat = hwif->INB(IDE_STATUS_REG);
+		stat = ide_read_status(drive);
 
 	if (stat & BUSY_STAT)
 		/* drive busy:  definitely not interrupting */
@@ -458,23 +458,24 @@ EXPORT_SYMBOL(drive_is_ready);
  */
 static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long timeout, u8 *rstat)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
 	int i;
 	u8 stat;
 
 	udelay(1);	/* spec allows drive 400ns to assert "BUSY" */
-	if ((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) {
+	stat = ide_read_status(drive);
+
+	if (stat & BUSY_STAT) {
 		local_irq_set(flags);
 		timeout += jiffies;
-		while ((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) {
+		while ((stat = ide_read_status(drive)) & BUSY_STAT) {
 			if (time_after(jiffies, timeout)) {
 				/*
 				 * One last read after the timeout in case
 				 * heavy interrupt load made us not make any
 				 * progress during the timeout..
 				 */
-				stat = hwif->INB(IDE_STATUS_REG);
+				stat = ide_read_status(drive);
 				if (!(stat & BUSY_STAT))
 					break;
 
@@ -494,7 +495,9 @@ static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long ti
 	 */
 	for (i = 0; i < 10; i++) {
 		udelay(1);
-		if (OK_STAT((stat = hwif->INB(IDE_STATUS_REG)), good, bad)) {
+		stat = ide_read_status(drive);
+
+		if (OK_STAT(stat, good, bad)) {
 			*rstat = stat;
 			return 0;
 		}
@@ -617,6 +620,7 @@ int ide_driveid_update(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	struct hd_driveid *id;
 	unsigned long timeout, flags;
+	u8 stat;
 
 	/*
 	 * Re-read drive->id for possible DMA mode
@@ -633,10 +637,15 @@ int ide_driveid_update(ide_drive_t *drive)
 			SELECT_MASK(drive, 0);
 			return 0;	/* drive timed-out */
 		}
+
 		msleep(50);	/* give drive a breather */
-	} while (hwif->INB(IDE_ALTSTATUS_REG) & BUSY_STAT);
+		stat = ide_read_altstatus(drive);
+	} while (stat & BUSY_STAT);
+
 	msleep(50);	/* wait for IRQ and DRQ_STAT */
-	if (!OK_STAT(hwif->INB(IDE_STATUS_REG),DRQ_STAT,BAD_R_STAT)) {
+	stat = ide_read_status(drive);
+
+	if (!OK_STAT(stat, DRQ_STAT, BAD_R_STAT)) {
 		SELECT_MASK(drive, 0);
 		printk("%s: CHECK for good STATUS\n", drive->name);
 		return 0;
@@ -649,7 +658,7 @@ int ide_driveid_update(ide_drive_t *drive)
 		return 0;
 	}
 	ata_input_data(drive, id, SECTOR_WORDS);
-	(void) hwif->INB(IDE_STATUS_REG);	/* clear drive IRQ */
+	(void)ide_read_status(drive);	/* clear drive IRQ */
 	local_irq_enable();
 	local_irq_restore(flags);
 	ide_fix_driveid(id);
@@ -850,17 +859,16 @@ static ide_startstop_t do_reset1 (ide_drive_t *, int);
 static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
 {
 	ide_hwgroup_t *hwgroup	= HWGROUP(drive);
-	ide_hwif_t *hwif	= HWIF(drive);
 	u8 stat;
 
 	SELECT_DRIVE(drive);
 	udelay (10);
+	stat = ide_read_status(drive);
 
-	if (OK_STAT(stat = hwif->INB(IDE_STATUS_REG), 0, BUSY_STAT)) {
+	if (OK_STAT(stat, 0, BUSY_STAT))
 		printk("%s: ATAPI reset complete\n", drive->name);
-	} else {
+	else {
 		if (time_before(jiffies, hwgroup->poll_timeout)) {
-			BUG_ON(HWGROUP(drive)->handler != NULL);
 			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
 			/* continue polling */
 			return ide_started;
@@ -898,9 +906,10 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 		}
 	}
 
-	if (!OK_STAT(tmp = hwif->INB(IDE_STATUS_REG), 0, BUSY_STAT)) {
+	tmp = ide_read_status(drive);
+
+	if (!OK_STAT(tmp, 0, BUSY_STAT)) {
 		if (time_before(jiffies, hwgroup->poll_timeout)) {
-			BUG_ON(HWGROUP(drive)->handler != NULL);
 			ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
 			/* continue polling */
 			return ide_started;
@@ -909,7 +918,9 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 		drive->failures++;
 	} else  {
 		printk("%s: reset: ", hwif->name);
-		if ((tmp = hwif->INB(IDE_ERROR_REG)) == 1) {
+		tmp = ide_read_error(drive);
+
+		if (tmp == 1) {
 			printk("success\n");
 			drive->failures = 0;
 		} else {
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index b42940d..1ff676c 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -578,7 +578,7 @@ u8 ide_dump_status(ide_drive_t *drive, const char *msg, u8 stat)
 	}
 	printk("}\n");
 	if ((stat & (BUSY_STAT|ERR_STAT)) == ERR_STAT) {
-		err = drive->hwif->INB(IDE_ERROR_REG);
+		err = ide_read_error(drive);
 		printk("%s: %s: error=0x%02x ", drive->name, msg, err);
 		if (drive->media == ide_disk)
 			ide_dump_ata_error(drive, err);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 9c07bdb..fd0ef82 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -264,8 +264,7 @@ err_misc:
 static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	int rc;
-	unsigned long hd_status;
+	int use_altstatus = 0, rc;
 	unsigned long timeout;
 	u8 s = 0, a = 0;
 
@@ -273,19 +272,17 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 	msleep(50);
 
 	if (IDE_CONTROL_REG) {
-		a = hwif->INB(IDE_ALTSTATUS_REG);
-		s = hwif->INB(IDE_STATUS_REG);
-		if ((a ^ s) & ~INDEX_STAT) {
-			printk(KERN_INFO "%s: probing with STATUS(0x%02x) instead of "
-				"ALTSTATUS(0x%02x)\n", drive->name, s, a);
+		a = ide_read_altstatus(drive);
+		s = ide_read_status(drive);
+		if ((a ^ s) & ~INDEX_STAT)
 			/* ancient Seagate drives, broken interfaces */
-			hd_status = IDE_STATUS_REG;
-		} else {
+			printk(KERN_INFO "%s: probing with STATUS(0x%02x) "
+					 "instead of ALTSTATUS(0x%02x)\n",
+					 drive->name, s, a);
+		else
 			/* use non-intrusive polling */
-			hd_status = IDE_ALTSTATUS_REG;
-		}
-	} else
-		hd_status = IDE_STATUS_REG;
+			use_altstatus = 1;
+	}
 
 	/* set features register for atapi
 	 * identify command to be sure of reply
@@ -306,11 +303,15 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 		}
 		/* give drive a breather */
 		msleep(50);
-	} while ((hwif->INB(hd_status)) & BUSY_STAT);
+		s = use_altstatus ? ide_read_altstatus(drive)
+				  : ide_read_status(drive);
+	} while (s & BUSY_STAT);
 
 	/* wait for IRQ and DRQ_STAT */
 	msleep(50);
-	if (OK_STAT((hwif->INB(IDE_STATUS_REG)), DRQ_STAT, BAD_R_STAT)) {
+	s = ide_read_status(drive);
+
+	if (OK_STAT(s, DRQ_STAT, BAD_R_STAT)) {
 		unsigned long flags;
 
 		/* local CPU only; some systems need this */
@@ -320,7 +321,7 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 		/* drive responded with ID */
 		rc = 0;
 		/* clear drive IRQ */
-		(void) hwif->INB(IDE_STATUS_REG);
+		(void)ide_read_status(drive);
 		local_irq_restore(flags);
 	} else {
 		/* drive refused ID */
@@ -367,7 +368,7 @@ static int try_to_identify (ide_drive_t *drive, u8 cmd)
 
 		ide_set_irq(drive, 0);
 		/* clear drive IRQ */
-		(void) hwif->INB(IDE_STATUS_REG);
+		(void)ide_read_status(drive);
 		udelay(5);
 		irq = probe_irq_off(cookie);
 		if (!hwif->irq) {
@@ -455,7 +456,9 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 		return 3;
 	}
 
-	if (OK_STAT((hwif->INB(IDE_STATUS_REG)), READY_STAT, BUSY_STAT) ||
+	stat = ide_read_status(drive);
+
+	if (OK_STAT(stat, READY_STAT, BUSY_STAT) ||
 	    drive->present || cmd == WIN_PIDENTIFY) {
 		/* send cmd and wait */
 		if ((rc = try_to_identify(drive, cmd))) {
@@ -463,7 +466,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			rc = try_to_identify(drive,cmd);
 		}
 
-		stat = hwif->INB(IDE_STATUS_REG);
+		stat = ide_read_status(drive);
 
 		if (stat == (BUSY_STAT | READY_STAT))
 			return 4;
@@ -482,7 +485,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 		}
 
 		/* ensure drive IRQ is clear */
-		stat = hwif->INB(IDE_STATUS_REG);
+		stat = ide_read_status(drive);
 
 		if (rc == 1)
 			printk(KERN_ERR "%s: no response (status = 0x%02x)\n",
@@ -496,7 +499,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 		SELECT_DRIVE(&hwif->drives[0]);
 		msleep(50);
 		/* ensure drive irq is clear */
-		(void) hwif->INB(IDE_STATUS_REG);
+		(void)ide_read_status(drive);
 	}
 	return rc;
 }
@@ -521,7 +524,7 @@ static void enable_nest (ide_drive_t *drive)
 
 	msleep(50);
 
-	stat = hwif->INB(IDE_STATUS_REG);
+	stat = ide_read_status(drive);
 
 	if (!OK_STAT(stat, 0, BAD_STAT))
 		printk(KERN_CONT "failed (status = 0x%02x)\n", stat);
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 975c0ff..bab88ca 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -65,6 +65,7 @@ static int proc_ide_read_imodel
 		case ide_4drives:	name = "4drives";	break;
 		case ide_pmac:		name = "mac-io";	break;
 		case ide_au1xxx:	name = "au1xxx";	break;
+		case ide_palm3710:      name = "palm3710";      break;
 		case ide_etrax100:	name = "etrax100";	break;
 		case ide_acorn:		name = "acorn";		break;
 		default:		name = "(unknown)";	break;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index bf40d8c..49dd2e7 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -15,7 +15,7 @@
  * Documentation/ide/ChangeLog.ide-tape.1995-2002
  */
 
-#define IDETAPE_VERSION "1.19"
+#define IDETAPE_VERSION "1.20"
 
 #include <linux/module.h>
 #include <linux/types.h>
@@ -39,63 +39,70 @@
 #include <scsi/scsi.h>
 
 #include <asm/byteorder.h>
-#include <asm/irq.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/irq.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <asm/unaligned.h>
 #include <linux/mtio.h>
 
+enum {
+	/* output errors only */
+	DBG_ERR =		(1 << 0),
+	/* output all sense key/asc */
+	DBG_SENSE =		(1 << 1),
+	/* info regarding all chrdev-related procedures */
+	DBG_CHRDEV =		(1 << 2),
+	/* all remaining procedures */
+	DBG_PROCS =		(1 << 3),
+	/* buffer alloc info (pc_stack & rq_stack) */
+	DBG_PCRQ_STACK =	(1 << 4),
+};
+
+/* define to see debug info */
+#define IDETAPE_DEBUG_LOG		0
+
+#if IDETAPE_DEBUG_LOG
+#define debug_log(lvl, fmt, args...)			\
+{							\
+	if (tape->debug_mask & lvl)			\
+	printk(KERN_INFO "ide-tape: " fmt, ## args);	\
+}
+#else
+#define debug_log(lvl, fmt, args...) do {} while (0)
+#endif
+
 /**************************** Tunable parameters *****************************/
 
 
 /*
- *	Pipelined mode parameters.
+ * Pipelined mode parameters.
  *
- *	We try to use the minimum number of stages which is enough to
- *	keep the tape constantly streaming. To accomplish that, we implement
- *	a feedback loop around the maximum number of stages:
+ * We try to use the minimum number of stages which is enough to keep the tape
+ * constantly streaming. To accomplish that, we implement a feedback loop around
+ * the maximum number of stages:
  *
- *	We start from MIN maximum stages (we will not even use MIN stages
- *      if we don't need them), increment it by RATE*(MAX-MIN)
- *	whenever we sense that the pipeline is empty, until we reach
- *	the optimum value or until we reach MAX.
+ * We start from MIN maximum stages (we will not even use MIN stages if we don't
+ * need them), increment it by RATE*(MAX-MIN) whenever we sense that the
+ * pipeline is empty, until we reach the optimum value or until we reach MAX.
  *
- *	Setting the following parameter to 0 is illegal: the pipelined mode
- *	cannot be disabled (calculate_speeds() divides by tape->max_stages.)
+ * Setting the following parameter to 0 is illegal: the pipelined mode cannot be
+ * disabled (idetape_calculate_speeds() divides by tape->max_stages.)
  */
 #define IDETAPE_MIN_PIPELINE_STAGES	  1
 #define IDETAPE_MAX_PIPELINE_STAGES	400
 #define IDETAPE_INCREASE_STAGES_RATE	 20
 
 /*
- *	The following are used to debug the driver:
- *
- *	Setting IDETAPE_DEBUG_LOG to 1 will log driver flow control.
+ * After each failed packet command we issue a request sense command and retry
+ * the packet command IDETAPE_MAX_PC_RETRIES times.
  *
- *	Setting them to 0 will restore normal operation mode:
- *
- *		1.	Disable logging normal successful operations.
- *		2.	Disable self-sanity checks.
- *		3.	Errors will still be logged, of course.
- *
- *	All the #if DEBUG code will be removed some day, when the driver
- *	is verified to be stable enough. This will make it much more
- *	esthetic.
- */
-#define IDETAPE_DEBUG_LOG		0
-
-/*
- *	After each failed packet command we issue a request sense command
- *	and retry the packet command IDETAPE_MAX_PC_RETRIES times.
- *
- *	Setting IDETAPE_MAX_PC_RETRIES to 0 will disable retries.
+ * Setting IDETAPE_MAX_PC_RETRIES to 0 will disable retries.
  */
 #define IDETAPE_MAX_PC_RETRIES		3
 
 /*
- *	With each packet command, we allocate a buffer of
- *	IDETAPE_PC_BUFFER_SIZE bytes. This is used for several packet
- *	commands (Not for READ/WRITE commands).
+ * With each packet command, we allocate a buffer of IDETAPE_PC_BUFFER_SIZE
+ * bytes. This is used for several packet commands (Not for READ/WRITE commands)
  */
 #define IDETAPE_PC_BUFFER_SIZE		256
 
@@ -114,48 +121,39 @@
 #define IDETAPE_WAIT_CMD		(900*HZ)
 
 /*
- *	The following parameter is used to select the point in the internal
- *	tape fifo in which we will start to refill the buffer. Decreasing
- *	the following parameter will improve the system's latency and
- *	interactive response, while using a high value might improve system
- *	throughput.
+ * The following parameter is used to select the point in the internal tape fifo
+ * in which we will start to refill the buffer. Decreasing the following
+ * parameter will improve the system's latency and interactive response, while
+ * using a high value might improve system throughput.
  */
-#define IDETAPE_FIFO_THRESHOLD 		2
+#define IDETAPE_FIFO_THRESHOLD		2
 
 /*
- *	DSC polling parameters.
- *
- *	Polling for DSC (a single bit in the status register) is a very
- *	important function in ide-tape. There are two cases in which we
- *	poll for DSC:
+ * DSC polling parameters.
  *
- *	1.	Before a read/write packet command, to ensure that we
- *		can transfer data from/to the tape's data buffers, without
- *		causing an actual media access. In case the tape is not
- *		ready yet, we take out our request from the device
- *		request queue, so that ide.c will service requests from
- *		the other device on the same interface meanwhile.
+ * Polling for DSC (a single bit in the status register) is a very important
+ * function in ide-tape. There are two cases in which we poll for DSC:
  *
- *	2.	After the successful initialization of a "media access
- *		packet command", which is a command which can take a long
- *		time to complete (it can be several seconds or even an hour).
+ * 1. Before a read/write packet command, to ensure that we can transfer data
+ * from/to the tape's data buffers, without causing an actual media access.
+ * In case the tape is not ready yet, we take out our request from the device
+ * request queue, so that ide.c could service requests from the other device
+ * on the same interface in the meantime.
  *
- *		Again, we postpone our request in the middle to free the bus
- *		for the other device. The polling frequency here should be
- *		lower than the read/write frequency since those media access
- *		commands are slow. We start from a "fast" frequency -
- *		IDETAPE_DSC_MA_FAST (one second), and if we don't receive DSC
- *		after IDETAPE_DSC_MA_THRESHOLD (5 minutes), we switch it to a
- *		lower frequency - IDETAPE_DSC_MA_SLOW (1 minute).
+ * 2. After the successful initialization of a "media access packet command",
+ * which is a command that can take a long time to complete (the interval can
+ * range from several seconds to even an hour). Again, we postpone our request
+ * in the middle to free the bus for the other device. The polling frequency
+ * here should be lower than the read/write frequency since those media access
+ * commands are slow. We start from a "fast" frequency - IDETAPE_DSC_MA_FAST
+ * (1 second), and if we don't receive DSC after IDETAPE_DSC_MA_THRESHOLD
+ * (5 min), we switch it to a lower frequency - IDETAPE_DSC_MA_SLOW (1 min).
  *
- *	We also set a timeout for the timer, in case something goes wrong.
- *	The timeout should be longer then the maximum execution time of a
- *	tape operation.
- */
- 
-/*
- *	DSC timings.
+ * We also set a timeout for the timer, in case something goes wrong. The
+ * timeout should be longer then the maximum execution time of a tape operation.
  */
+
+/* DSC timings. */
 #define IDETAPE_DSC_RW_MIN		5*HZ/100	/* 50 msec */
 #define IDETAPE_DSC_RW_MAX		40*HZ/100	/* 400 msec */
 #define IDETAPE_DSC_RW_TIMEOUT		2*60*HZ		/* 2 minutes */
@@ -166,19 +164,15 @@
 
 /*************************** End of tunable parameters ***********************/
 
-/*
- *	Read/Write error simulation
- */
+/* Read/Write error simulation */
 #define SIMULATE_ERRORS			0
 
-/*
- *	For general magnetic tape device compatibility.
- */
-typedef enum {
-	idetape_direction_none,
-	idetape_direction_read,
-	idetape_direction_write
-} idetape_chrdev_direction_t;
+/* tape directions */
+enum {
+	IDETAPE_DIR_NONE  = (1 << 0),
+	IDETAPE_DIR_READ  = (1 << 1),
+	IDETAPE_DIR_WRITE = (1 << 2),
+};
 
 struct idetape_bh {
 	u32 b_size;
@@ -187,24 +181,32 @@ struct idetape_bh {
 	char *b_data;
 };
 
-/*
- *	Our view of a packet command.
- */
 typedef struct idetape_packet_command_s {
-	u8 c[12];				/* Actual packet bytes */
-	int retries;				/* On each retry, we increment retries */
-	int error;				/* Error code */
-	int request_transfer;			/* Bytes to transfer */
-	int actually_transferred;		/* Bytes actually transferred */
-	int buffer_size;			/* Size of our data buffer */
+	/* Actual packet bytes */
+	u8 c[12];
+	/* On each retry, we increment retries */
+	int retries;
+	/* Error code */
+	int error;
+	/* Bytes to transfer */
+	int request_transfer;
+	/* Bytes actually transferred */
+	int actually_transferred;
+	/* Size of our data buffer */
+	int buffer_size;
 	struct idetape_bh *bh;
 	char *b_data;
 	int b_count;
-	u8 *buffer;				/* Data buffer */
-	u8 *current_position;			/* Pointer into the above buffer */
-	ide_startstop_t (*callback) (ide_drive_t *);	/* Called when this packet command is completed */
-	u8 pc_buffer[IDETAPE_PC_BUFFER_SIZE];	/* Temporary buffer */
-	unsigned long flags;			/* Status/Action bit flags: long for set_bit */
+	/* Data buffer */
+	u8 *buffer;
+	/* Pointer into the above buffer */
+	u8 *current_position;
+	/* Called when this packet command is completed */
+	ide_startstop_t (*callback) (ide_drive_t *);
+	/* Temporary buffer */
+	u8 pc_buffer[IDETAPE_PC_BUFFER_SIZE];
+	/* Status/Action bit flags: long for set_bit */
+	unsigned long flags;
 } idetape_pc_t;
 
 /*
@@ -223,9 +225,7 @@ typedef struct idetape_packet_command_s {
 /* Data direction */
 #define	PC_WRITING			5
 
-/*
- *	A pipeline stage.
- */
+/* A pipeline stage. */
 typedef struct idetape_stage_s {
 	struct request rq;			/* The corresponding request */
 	struct idetape_bh *bh;			/* The data buffers */
@@ -233,9 +233,8 @@ typedef struct idetape_stage_s {
 } idetape_stage_t;
 
 /*
- *	Most of our global data which we need to save even as we leave the
- *	driver due to an interrupt or a timer event is stored in a variable
- *	of type idetape_tape_t, defined below.
+ * Most of our global data which we need to save even as we leave the driver due
+ * to an interrupt or a timer event is stored in the struct defined below.
  */
 typedef struct ide_tape_obj {
 	ide_drive_t	*drive;
@@ -271,15 +270,14 @@ typedef struct ide_tape_obj {
 	int rq_stack_index;
 
 	/*
-	 *	DSC polling variables.
+	 * DSC polling variables.
 	 *
-	 *	While polling for DSC we use postponed_rq to postpone the
-	 *	current request so that ide.c will be able to service
-	 *	pending requests on the other device. Note that at most
-	 *	we will have only one DSC (usually data transfer) request
-	 *	in the device request queue. Additional requests can be
-	 *	queued in our internal pipeline, but they will be visible
-	 *	to ide.c only one at a time.
+	 * While polling for DSC we use postponed_rq to postpone the current
+	 * request so that ide.c will be able to service pending requests on the
+	 * other device. Note that at most we will have only one DSC (usually
+	 * data transfer) request in the device request queue. Additional
+	 * requests can be queued in our internal pipeline, but they will be
+	 * visible to ide.c only one at a time.
 	 */
 	struct request *postponed_rq;
 	/* The time in which we started polling for DSC */
@@ -287,73 +285,57 @@ typedef struct ide_tape_obj {
 	/* Timer used to poll for dsc */
 	struct timer_list dsc_timer;
 	/* Read/Write dsc polling frequency */
-	unsigned long best_dsc_rw_frequency;
-	/* The current polling frequency */
-	unsigned long dsc_polling_frequency;
-	/* Maximum waiting time */
+	unsigned long best_dsc_rw_freq;
+	unsigned long dsc_poll_freq;
 	unsigned long dsc_timeout;
 
-	/*
-	 *	Read position information
-	 */
+	/* Read position information */
 	u8 partition;
 	/* Current block */
-	unsigned int first_frame_position;
-	unsigned int last_frame_position;
-	unsigned int blocks_in_buffer;
+	unsigned int first_frame;
 
-	/*
-	 *	Last error information
-	 */
+	/* Last error information */
 	u8 sense_key, asc, ascq;
 
-	/*
-	 *	Character device operation
-	 */
+	/* Character device operation */
 	unsigned int minor;
 	/* device name */
 	char name[4];
 	/* Current character device data transfer direction */
-	idetape_chrdev_direction_t chrdev_direction;
+	u8 chrdev_dir;
 
-	/*
-	 *	Device information
-	 */
-	/* Usually 512 or 1024 bytes */
-	unsigned short tape_block_size;
+	/* tape block size, usually 512 or 1024 bytes */
+	unsigned short blk_size;
 	int user_bs_factor;
 
 	/* Copy of the tape's Capabilities and Mechanical Page */
 	u8 caps[20];
 
 	/*
-	 *	Active data transfer request parameters.
-	 *
-	 *	At most, there is only one ide-tape originated data transfer
-	 *	request in the device request queue. This allows ide.c to
-	 *	easily service requests from the other device when we
-	 *	postpone our active request. In the pipelined operation
-	 *	mode, we use our internal pipeline structure to hold
-	 *	more data requests.
+	 * Active data transfer request parameters.
 	 *
-	 *	The data buffer size is chosen based on the tape's
-	 *	recommendation.
+	 * At most, there is only one ide-tape originated data transfer request
+	 * in the device request queue. This allows ide.c to easily service
+	 * requests from the other device when we postpone our active request.
+	 * In the pipelined operation mode, we use our internal pipeline
+	 * structure to hold more data requests. The data buffer size is chosen
+	 * based on the tape's recommendation.
 	 */
-	/* Pointer to the request which is waiting in the device request queue */
-	struct request *active_data_request;
-	/* Data buffer size (chosen based on the tape's recommendation */
+	/* ptr to the request which is waiting in the device request queue */
+	struct request *active_data_rq;
+	/* Data buffer size chosen based on the tape's recommendation */
 	int stage_size;
 	idetape_stage_t *merge_stage;
 	int merge_stage_size;
 	struct idetape_bh *bh;
 	char *b_data;
 	int b_count;
-	
+
 	/*
-	 *	Pipeline parameters.
+	 * Pipeline parameters.
 	 *
-	 *	To accomplish non-pipelined mode, we simply set the following
-	 *	variables to zero (or NULL, where appropriate).
+	 * To accomplish non-pipelined mode, we simply set the following
+	 * variables to zero (or NULL, where appropriate).
 	 */
 	/* Number of currently used stages */
 	int nr_stages;
@@ -378,20 +360,13 @@ typedef struct ide_tape_obj {
 	/* Status/Action flags: long for set_bit */
 	unsigned long flags;
 	/* protects the ide-tape queue */
-	spinlock_t spinlock;
+	spinlock_t lock;
 
-	/*
-	 * Measures average tape speed
-	 */
+	/* Measures average tape speed */
 	unsigned long avg_time;
 	int avg_size;
 	int avg_speed;
 
-	char vendor_id[10];
-	char product_id[18];
-	char firmware_revision[6];
-	int firmware_revision_num;
-
 	/* the door is currently locked */
 	int door_locked;
 	/* the tape hardware is write protected */
@@ -400,11 +375,9 @@ typedef struct ide_tape_obj {
 	char write_prot;
 
 	/*
-	 * Limit the number of times a request can
-	 * be postponed, to avoid an infinite postpone
-	 * deadlock.
+	 * Limit the number of times a request can be postponed, to avoid an
+	 * infinite postpone deadlock.
 	 */
-	/* request postpone count limit */
 	int postpone_cnt;
 
 	/*
@@ -419,30 +392,19 @@ typedef struct ide_tape_obj {
 	int tape_head;
 	int last_tape_head;
 
-	/*
-	 * Speed control at the tape buffers input/output
-	 */
+	/* Speed control at the tape buffers input/output */
 	unsigned long insert_time;
 	int insert_size;
 	int insert_speed;
 	int max_insert_speed;
 	int measure_insert_time;
 
-	/*
-	 * Measure tape still time, in milliseconds
-	 */
-	unsigned long tape_still_time_begin;
-	int tape_still_time;
-
-	/*
-	 * Speed regulation negative feedback loop
-	 */
+	/* Speed regulation negative feedback loop */
 	int speed_control;
 	int pipeline_head_speed;
 	int controlled_pipeline_head_speed;
 	int uncontrolled_pipeline_head_speed;
 	int controlled_last_pipeline_head;
-	int uncontrolled_last_pipeline_head;
 	unsigned long uncontrolled_pipeline_head_time;
 	unsigned long controlled_pipeline_head_time;
 	int controlled_previous_pipeline_head;
@@ -451,18 +413,7 @@ typedef struct ide_tape_obj {
 	unsigned long uncontrolled_previous_head_time;
 	int restart_speed_control_req;
 
-        /*
-         * Debug_level determines amount of debugging output;
-         * can be changed using /proc/ide/hdx/settings
-         * 0 : almost no debugging output
-         * 1 : 0+output errors only
-         * 2 : 1+output all sensekey/asc
-         * 3 : 2+follow all chrdev related procedures
-         * 4 : 3+follow all procedures
-         * 5 : 4+include pc_stack rq_stack info
-         * 6 : 5+USE_COUNT updates
-         */
-         int debug_level; 
+	u32 debug_mask;
 } idetape_tape_t;
 
 static DEFINE_MUTEX(idetape_ref_mutex);
@@ -495,9 +446,7 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 	mutex_unlock(&idetape_ref_mutex);
 }
 
-/*
- *	Tape door status
- */
+/* Tape door status */
 #define DOOR_UNLOCKED			0
 #define DOOR_LOCKED			1
 #define DOOR_EXPLICITLY_LOCKED		2
@@ -517,30 +466,23 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 /* 0 = no tape is loaded, so we don't rewind after ejecting */
 #define IDETAPE_MEDIUM_PRESENT		9
 
-/*
- *	Some defines for the READ BUFFER command
- */
+/* A define for the READ BUFFER command */
 #define IDETAPE_RETRIEVE_FAULTY_BLOCK	6
 
-/*
- *	Some defines for the SPACE command
- */
+/* Some defines for the SPACE command */
 #define IDETAPE_SPACE_OVER_FILEMARK	1
 #define IDETAPE_SPACE_TO_EOD		3
 
-/*
- *	Some defines for the LOAD UNLOAD command
- */
+/* Some defines for the LOAD UNLOAD command */
 #define IDETAPE_LU_LOAD_MASK		1
 #define IDETAPE_LU_RETENSION_MASK	2
 #define IDETAPE_LU_EOT_MASK		4
 
 /*
- *	Special requests for our block device strategy routine.
+ * Special requests for our block device strategy routine.
  *
- *	In order to service a character device command, we add special
- *	requests to the tail of our block device request queue and wait
- *	for their completion.
+ * In order to service a character device command, we add special requests to
+ * the tail of our block device request queue and wait for their completion.
  */
 
 enum {
@@ -551,55 +493,20 @@ enum {
 	REQ_IDETAPE_READ_BUFFER	= (1 << 4),
 };
 
-/*
- *	Error codes which are returned in rq->errors to the higher part
- *	of the driver.
- */
+/* Error codes returned in rq->errors to the higher part of the driver. */
 #define	IDETAPE_ERROR_GENERAL		101
 #define	IDETAPE_ERROR_FILEMARK		102
 #define	IDETAPE_ERROR_EOD		103
 
-/*
- *	The following is used to format the general configuration word of
- *	the ATAPI IDENTIFY DEVICE command.
- */
-struct idetape_id_gcw {	
-	unsigned packet_size		:2;	/* Packet Size */
-	unsigned reserved234		:3;	/* Reserved */
-	unsigned drq_type		:2;	/* Command packet DRQ type */
-	unsigned removable		:1;	/* Removable media */
-	unsigned device_type		:5;	/* Device type */
-	unsigned reserved13		:1;	/* Reserved */
-	unsigned protocol		:2;	/* Protocol type */
-};
-
-/*
- *	READ POSITION packet command - Data Format (From Table 6-57)
- */
-typedef struct {
-	unsigned	reserved0_10	:2;	/* Reserved */
-	unsigned	bpu		:1;	/* Block Position Unknown */	
-	unsigned	reserved0_543	:3;	/* Reserved */
-	unsigned	eop		:1;	/* End Of Partition */
-	unsigned	bop		:1;	/* Beginning Of Partition */
-	u8		partition;		/* Partition Number */
-	u8		reserved2, reserved3;	/* Reserved */
-	u32		first_block;		/* First Block Location */
-	u32		last_block;		/* Last Block Location (Optional) */
-	u8		reserved12;		/* Reserved */
-	u8		blocks_in_buffer[3];	/* Blocks In Buffer - (Optional) */
-	u32		bytes_in_buffer;	/* Bytes In Buffer (Optional) */
-} idetape_read_position_result_t;
-
 /* Structures related to the SELECT SENSE / MODE SENSE packet commands. */
 #define IDETAPE_BLOCK_DESCRIPTOR	0
 #define	IDETAPE_CAPABILITIES_PAGE	0x2a
 
 /*
- *	The variables below are used for the character device interface.
- *	Additional state variables are defined in our ide_drive_t structure.
+ * The variables below are used for the character device interface. Additional
+ * state variables are defined in our ide_drive_t structure.
  */
-static struct ide_tape_obj * idetape_devs[MAX_HWIFS * MAX_DRIVES];
+static struct ide_tape_obj *idetape_devs[MAX_HWIFS * MAX_DRIVES];
 
 #define ide_tape_f(file) ((file)->private_data)
 
@@ -616,23 +523,17 @@ static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
 }
 
 /*
- *      Function declarations
- *
- */
-static int idetape_chrdev_release (struct inode *inode, struct file *filp);
-static void idetape_write_release (ide_drive_t *drive, unsigned int minor);
-
-/*
  * Too bad. The drive wants to send us data which we are not ready to accept.
  * Just throw it away.
  */
-static void idetape_discard_data (ide_drive_t *drive, unsigned int bcount)
+static void idetape_discard_data(ide_drive_t *drive, unsigned int bcount)
 {
 	while (bcount--)
 		(void) HWIF(drive)->INB(IDE_DATA_REG);
 }
 
-static void idetape_input_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsigned int bcount)
+static void idetape_input_buffers(ide_drive_t *drive, idetape_pc_t *pc,
+				  unsigned int bcount)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
@@ -644,8 +545,11 @@ static void idetape_input_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsigne
 			idetape_discard_data(drive, bcount);
 			return;
 		}
-		count = min((unsigned int)(bh->b_size - atomic_read(&bh->b_count)), bcount);
-		HWIF(drive)->atapi_input_bytes(drive, bh->b_data + atomic_read(&bh->b_count), count);
+		count = min(
+			(unsigned int)(bh->b_size - atomic_read(&bh->b_count)),
+			bcount);
+		HWIF(drive)->atapi_input_bytes(drive, bh->b_data +
+					atomic_read(&bh->b_count), count);
 		bcount -= count;
 		atomic_add(count, &bh->b_count);
 		if (atomic_read(&bh->b_count) == bh->b_size) {
@@ -657,15 +561,16 @@ static void idetape_input_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsigne
 	pc->bh = bh;
 }
 
-static void idetape_output_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsigned int bcount)
+static void idetape_output_buffers(ide_drive_t *drive, idetape_pc_t *pc,
+				   unsigned int bcount)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
 
 	while (bcount) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_output_buffers\n");
+			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
+					__func__);
 			return;
 		}
 		count = min((unsigned int)pc->b_count, (unsigned int)bcount);
@@ -674,7 +579,8 @@ static void idetape_output_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsign
 		pc->b_data += count;
 		pc->b_count -= count;
 		if (!pc->b_count) {
-			pc->bh = bh = bh->b_reqnext;
+			bh = bh->b_reqnext;
+			pc->bh = bh;
 			if (bh) {
 				pc->b_data = bh->b_data;
 				pc->b_count = atomic_read(&bh->b_count);
@@ -683,7 +589,7 @@ static void idetape_output_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsign
 	}
 }
 
-static void idetape_update_buffers (idetape_pc_t *pc)
+static void idetape_update_buffers(idetape_pc_t *pc)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
@@ -693,8 +599,8 @@ static void idetape_update_buffers (idetape_pc_t *pc)
 		return;
 	while (bcount) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_update_buffers\n");
+			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
+					__func__);
 			return;
 		}
 		count = min((unsigned int)bh->b_size, (unsigned int)bcount);
@@ -712,17 +618,14 @@ static void idetape_update_buffers (idetape_pc_t *pc)
  *	driver. A storage space for a maximum of IDETAPE_PC_STACK packet
  *	commands is allocated at initialization time.
  */
-static idetape_pc_t *idetape_next_pc_storage (ide_drive_t *drive)
+static idetape_pc_t *idetape_next_pc_storage(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 5)
-		printk(KERN_INFO "ide-tape: pc_stack_index=%d\n",
-			tape->pc_stack_index);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PCRQ_STACK, "pc_stack_index=%d\n", tape->pc_stack_index);
+
 	if (tape->pc_stack_index == IDETAPE_PC_STACK)
-		tape->pc_stack_index=0;
+		tape->pc_stack_index = 0;
 	return (&tape->pc_stack[tape->pc_stack_index++]);
 }
 
@@ -731,32 +634,26 @@ static idetape_pc_t *idetape_next_pc_storage (ide_drive_t *drive)
  *	Since we queue packet commands in the request queue, we need to
  *	allocate a request, along with the allocation of a packet command.
  */
- 
+
 /**************************************************************
  *                                                            *
  *  This should get fixed to use kmalloc(.., GFP_ATOMIC)      *
  *  followed later on by kfree().   -ml                       *
  *                                                            *
  **************************************************************/
- 
-static struct request *idetape_next_rq_storage (ide_drive_t *drive)
+
+static struct request *idetape_next_rq_storage(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 5)
-		printk(KERN_INFO "ide-tape: rq_stack_index=%d\n",
-			tape->rq_stack_index);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PCRQ_STACK, "rq_stack_index=%d\n", tape->rq_stack_index);
+
 	if (tape->rq_stack_index == IDETAPE_PC_STACK)
-		tape->rq_stack_index=0;
+		tape->rq_stack_index = 0;
 	return (&tape->rq_stack[tape->rq_stack_index++]);
 }
 
-/*
- *	idetape_init_pc initializes a packet command.
- */
-static void idetape_init_pc (idetape_pc_t *pc)
+static void idetape_init_pc(idetape_pc_t *pc)
 {
 	memset(pc->c, 0, 12);
 	pc->retries = 0;
@@ -780,22 +677,14 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	tape->sense_key = sense[2] & 0xF;
 	tape->asc       = sense[12];
 	tape->ascq      = sense[13];
-#if IDETAPE_DEBUG_LOG
-	/*
-	 * Without debugging, we only log an error if we decided to give up
-	 * retrying.
-	 */
-	if (tape->debug_level >= 1)
-		printk(KERN_INFO "ide-tape: pc = %x, sense key = %x, "
-			"asc = %x, ascq = %x\n",
-			pc->c[0], tape->sense_key,
-			tape->asc, tape->ascq);
-#endif /* IDETAPE_DEBUG_LOG */
+
+	debug_log(DBG_ERR, "pc = %x, sense key = %x, asc = %x, ascq = %x\n",
+		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
 
 	/* Correct pc->actually_transferred by asking the tape.	 */
 	if (test_bit(PC_DMA_ERROR, &pc->flags)) {
 		pc->actually_transferred = pc->request_transfer -
-			tape->tape_block_size *
+			tape->blk_size *
 			be32_to_cpu(get_unaligned((u32 *)&sense[3]));
 		idetape_update_buffers(pc);
 	}
@@ -843,50 +732,24 @@ static void idetape_activate_next_stage(ide_drive_t *drive)
 	idetape_stage_t *stage = tape->next_stage;
 	struct request *rq = &stage->rq;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_active_next_stage\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+
 	if (stage == NULL) {
-		printk(KERN_ERR "ide-tape: bug: Trying to activate a non existing stage\n");
+		printk(KERN_ERR "ide-tape: bug: Trying to activate a non"
+				" existing stage\n");
 		return;
 	}
 
 	rq->rq_disk = tape->disk;
 	rq->buffer = NULL;
 	rq->special = (void *)stage->bh;
-	tape->active_data_request = rq;
+	tape->active_data_rq = rq;
 	tape->active_stage = stage;
 	tape->next_stage = stage->next;
 }
 
-/*
- *	idetape_increase_max_pipeline_stages is a part of the feedback
- *	loop which tries to find the optimum number of stages. In the
- *	feedback loop, we are starting from a minimum maximum number of
- *	stages, and if we sense that the pipeline is empty, we try to
- *	increase it, until we reach the user compile time memory limit.
- */
-static void idetape_increase_max_pipeline_stages (ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	int increase = (tape->max_pipeline - tape->min_pipeline) / 10;
-	
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk (KERN_INFO "ide-tape: Reached idetape_increase_max_pipeline_stages\n");
-#endif /* IDETAPE_DEBUG_LOG */
-
-	tape->max_stages += max(increase, 1);
-	tape->max_stages = max(tape->max_stages, tape->min_pipeline);
-	tape->max_stages = min(tape->max_stages, tape->max_pipeline);
-}
-
-/*
- *	idetape_kfree_stage calls kfree to completely free a stage, along with
- *	its related buffers.
- */
-static void __idetape_kfree_stage (idetape_stage_t *stage)
+/* Free a stage along with its related buffers completely. */
+static void __idetape_kfree_stage(idetape_stage_t *stage)
 {
 	struct idetape_bh *prev_bh, *bh = stage->bh;
 	int size;
@@ -907,30 +770,29 @@ static void __idetape_kfree_stage (idetape_stage_t *stage)
 	kfree(stage);
 }
 
-static void idetape_kfree_stage (idetape_tape_t *tape, idetape_stage_t *stage)
+static void idetape_kfree_stage(idetape_tape_t *tape, idetape_stage_t *stage)
 {
 	__idetape_kfree_stage(stage);
 }
 
 /*
- *	idetape_remove_stage_head removes tape->first_stage from the pipeline.
- *	The caller should avoid race conditions.
+ * Remove tape->first_stage from the pipeline. The caller should avoid race
+ * conditions.
  */
-static void idetape_remove_stage_head (ide_drive_t *drive)
+static void idetape_remove_stage_head(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *stage;
-	
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_remove_stage_head\n");
-#endif /* IDETAPE_DEBUG_LOG */
+
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+
 	if (tape->first_stage == NULL) {
 		printk(KERN_ERR "ide-tape: bug: tape->first_stage is NULL\n");
 		return;
 	}
 	if (tape->active_stage == tape->first_stage) {
-		printk(KERN_ERR "ide-tape: bug: Trying to free our active pipeline stage\n");
+		printk(KERN_ERR "ide-tape: bug: Trying to free our active "
+				"pipeline stage\n");
 		return;
 	}
 	stage = tape->first_stage;
@@ -940,9 +802,11 @@ static void idetape_remove_stage_head (ide_drive_t *drive)
 	if (tape->first_stage == NULL) {
 		tape->last_stage = NULL;
 		if (tape->next_stage != NULL)
-			printk(KERN_ERR "ide-tape: bug: tape->next_stage != NULL\n");
+			printk(KERN_ERR "ide-tape: bug: tape->next_stage !="
+					" NULL\n");
 		if (tape->nr_stages)
-			printk(KERN_ERR "ide-tape: bug: nr_stages should be 0 now\n");
+			printk(KERN_ERR "ide-tape: bug: nr_stages should be 0 "
+					"now\n");
 	}
 }
 
@@ -957,10 +821,8 @@ static void idetape_abort_pipeline(ide_drive_t *drive,
 	idetape_stage_t *stage = new_last_stage->next;
 	idetape_stage_t *nstage;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: %s: idetape_abort_pipeline called\n", tape->name);
-#endif
+	debug_log(DBG_PROCS, "%s: Enter %s\n", tape->name, __func__);
+
 	while (stage) {
 		nstage = stage->next;
 		idetape_kfree_stage(tape, stage);
@@ -975,8 +837,8 @@ static void idetape_abort_pipeline(ide_drive_t *drive,
 }
 
 /*
- *	idetape_end_request is used to finish servicing a request, and to
- *	insert a pending pipeline request into the main device queue.
+ * Finish servicing a request and insert a pending pipeline request into the
+ * main device queue.
  */
 static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 {
@@ -987,15 +849,12 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	int remove_stage = 0;
 	idetape_stage_t *active_stage;
 
-#if IDETAPE_DEBUG_LOG
-        if (tape->debug_level >= 4)
-	printk(KERN_INFO "ide-tape: Reached idetape_end_request\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	switch (uptodate) {
-		case 0:	error = IDETAPE_ERROR_GENERAL; break;
-		case 1: error = 0; break;
-		default: error = uptodate;
+	case 0:	error = IDETAPE_ERROR_GENERAL; break;
+	case 1: error = 0; break;
+	default: error = uptodate;
 	}
 	rq->errors = error;
 	if (error)
@@ -1006,20 +865,21 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 		return 0;
 	}
 
-	spin_lock_irqsave(&tape->spinlock, flags);
+	spin_lock_irqsave(&tape->lock, flags);
 
 	/* The request was a pipelined data transfer request */
-	if (tape->active_data_request == rq) {
+	if (tape->active_data_rq == rq) {
 		active_stage = tape->active_stage;
 		tape->active_stage = NULL;
-		tape->active_data_request = NULL;
+		tape->active_data_rq = NULL;
 		tape->nr_pending_stages--;
 		if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
 			remove_stage = 1;
 			if (error) {
 				set_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
 				if (error == IDETAPE_ERROR_EOD)
-					idetape_abort_pipeline(drive, active_stage);
+					idetape_abort_pipeline(drive,
+								active_stage);
 			}
 		} else if (rq->cmd[0] & REQ_IDETAPE_READ) {
 			if (error == IDETAPE_ERROR_EOD) {
@@ -1030,48 +890,57 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 		if (tape->next_stage != NULL) {
 			idetape_activate_next_stage(drive);
 
+			/* Insert the next request into the request queue. */
+			(void)ide_do_drive_cmd(drive, tape->active_data_rq,
+						ide_end);
+		} else if (!error) {
 			/*
-			 * Insert the next request into the request queue.
+			 * This is a part of the feedback loop which tries to
+			 * find the optimum number of stages. We are starting
+			 * from a minimum maximum number of stages, and if we
+			 * sense that the pipeline is empty, we try to increase
+			 * it, until we reach the user compile time memory
+			 * limit.
 			 */
-			(void) ide_do_drive_cmd(drive, tape->active_data_request, ide_end);
-		} else if (!error) {
-				idetape_increase_max_pipeline_stages(drive);
+			int i = (tape->max_pipeline - tape->min_pipeline) / 10;
+
+			tape->max_stages += max(i, 1);
+			tape->max_stages = max(tape->max_stages,
+						tape->min_pipeline);
+			tape->max_stages = min(tape->max_stages,
+						tape->max_pipeline);
 		}
 	}
 	ide_end_drive_cmd(drive, 0, 0);
-//	blkdev_dequeue_request(rq);
-//	drive->rq = NULL;
-//	end_that_request_last(rq);
 
 	if (remove_stage)
 		idetape_remove_stage_head(drive);
-	if (tape->active_data_request == NULL)
+	if (tape->active_data_rq == NULL)
 		clear_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
-	spin_unlock_irqrestore(&tape->spinlock, flags);
+	spin_unlock_irqrestore(&tape->lock, flags);
 	return 0;
 }
 
-static ide_startstop_t idetape_request_sense_callback (ide_drive_t *drive)
+static ide_startstop_t idetape_request_sense_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_request_sense_callback\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+
 	if (!tape->pc->error) {
 		idetape_analyze_error(drive, tape->pc->buffer);
 		idetape_end_request(drive, 1, 0);
 	} else {
-		printk(KERN_ERR "ide-tape: Error in REQUEST SENSE itself - Aborting request!\n");
+		printk(KERN_ERR "ide-tape: Error in REQUEST SENSE itself - "
+				"Aborting request!\n");
 		idetape_end_request(drive, 0, 0);
 	}
 	return ide_stopped;
 }
 
-static void idetape_create_request_sense_cmd (idetape_pc_t *pc)
+static void idetape_create_request_sense_cmd(idetape_pc_t *pc)
 {
-	idetape_init_pc(pc);	
+	idetape_init_pc(pc);
 	pc->c[0] = REQUEST_SENSE;
 	pc->c[4] = 20;
 	pc->request_transfer = 20;
@@ -1086,25 +955,22 @@ static void idetape_init_rq(struct request *rq, u8 cmd)
 }
 
 /*
- *	idetape_queue_pc_head generates a new packet command request in front
- *	of the request queue, before the current request, so that it will be
- *	processed immediately, on the next pass through the driver.
- *
- *	idetape_queue_pc_head is called from the request handling part of
- *	the driver (the "bottom" part). Safe storage for the request should
- *	be allocated with idetape_next_pc_storage and idetape_next_rq_storage
- *	before calling idetape_queue_pc_head.
+ * Generate a new packet command request in front of the request queue, before
+ * the current request, so that it will be processed immediately, on the next
+ * pass through the driver. The function below is called from the request
+ * handling part of the driver (the "bottom" part). Safe storage for the request
+ * should be allocated with ide_tape_next_{pc,rq}_storage() prior to that.
  *
- *	Memory for those requests is pre-allocated at initialization time, and
- *	is limited to IDETAPE_PC_STACK requests. We assume that we have enough
- *	space for the maximum possible number of inter-dependent packet commands.
+ * Memory for those requests is pre-allocated at initialization time, and is
+ * limited to IDETAPE_PC_STACK requests. We assume that we have enough space for
+ * the maximum possible number of inter-dependent packet commands.
  *
- *	The higher level of the driver - The ioctl handler and the character
- *	device handling functions should queue request to the lower level part
- *	and wait for their completion using idetape_queue_pc_tail or
- *	idetape_queue_rw_tail.
+ * The higher level of the driver - The ioctl handler and the character device
+ * handling functions should queue request to the lower level part and wait for
+ * their completion using idetape_queue_pc_tail or idetape_queue_rw_tail.
  */
-static void idetape_queue_pc_head (ide_drive_t *drive, idetape_pc_t *pc,struct request *rq)
+static void idetape_queue_pc_head(ide_drive_t *drive, idetape_pc_t *pc,
+				  struct request *rq)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 
@@ -1125,7 +991,7 @@ static ide_startstop_t idetape_retry_pc (ide_drive_t *drive)
 	idetape_pc_t *pc;
 	struct request *rq;
 
-	(void)drive->hwif->INB(IDE_ERROR_REG);
+	(void)ide_read_error(drive);
 	pc = idetape_next_pc_storage(drive);
 	rq = idetape_next_rq_storage(drive);
 	idetape_create_request_sense_cmd(pc);
@@ -1135,50 +1001,46 @@ static ide_startstop_t idetape_retry_pc (ide_drive_t *drive)
 }
 
 /*
- *	idetape_postpone_request postpones the current request so that
- *	ide.c will be able to service requests from another device on
- *	the same hwgroup while we are polling for DSC.
+ * Postpone the current request so that ide.c will be able to service requests
+ * from another device on the same hwgroup while we are polling for DSC.
  */
-static void idetape_postpone_request (ide_drive_t *drive)
+static void idetape_postpone_request(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: idetape_postpone_request\n");
-#endif
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+
 	tape->postponed_rq = HWGROUP(drive)->rq;
-	ide_stall_queue(drive, tape->dsc_polling_frequency);
+	ide_stall_queue(drive, tape->dsc_poll_freq);
 }
 
+typedef void idetape_io_buf(ide_drive_t *, idetape_pc_t *, unsigned int);
+
 /*
- *	idetape_pc_intr is the usual interrupt handler which will be called
- *	during a packet command. We will transfer some of the data (as
- *	requested by the drive) and will re-point interrupt handler to us.
- *	When data transfer is finished, we will act according to the
- *	algorithm described before idetape_issue_packet_command.
- *
+ * This is the usual interrupt handler which will be called during a packet
+ * command. We will transfer some of the data (as requested by the drive) and
+ * will re-point interrupt handler to us. When data transfer is finished, we
+ * will act according to the algorithm described before
+ * idetape_issue_pc.
  */
-static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
+static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t *pc = tape->pc;
+	xfer_func_t *xferfunc;
+	idetape_io_buf *iobuf;
 	unsigned int temp;
 #if SIMULATE_ERRORS
-	static int error_sim_count = 0;
+	static int error_sim_count;
 #endif
 	u16 bcount;
 	u8 stat, ireason;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_pc_intr "
-				"interrupt handler\n");
-#endif /* IDETAPE_DEBUG_LOG */	
+	debug_log(DBG_PROCS, "Enter %s - interrupt handler\n", __func__);
 
 	/* Clear the interrupt */
-	stat = hwif->INB(IDE_STATUS_REG);
+	stat = ide_read_status(drive);
 
 	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
 		if (hwif->ide_dma_end(drive) || (stat & ERR_STAT)) {
@@ -1208,20 +1070,16 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 			pc->actually_transferred = pc->request_transfer;
 			idetape_update_buffers(pc);
 		}
-#if IDETAPE_DEBUG_LOG
-		if (tape->debug_level >= 4)
-			printk(KERN_INFO "ide-tape: DMA finished\n");
-#endif /* IDETAPE_DEBUG_LOG */
+		debug_log(DBG_PROCS, "DMA finished\n");
+
 	}
 
 	/* No more interrupts */
 	if ((stat & DRQ_STAT) == 0) {
-#if IDETAPE_DEBUG_LOG
-		if (tape->debug_level >= 2)
-			printk(KERN_INFO "ide-tape: Packet command completed, %d bytes transferred\n", pc->actually_transferred);
-#endif /* IDETAPE_DEBUG_LOG */
-		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
+		debug_log(DBG_SENSE, "Packet command completed, %d bytes"
+				" transferred\n", pc->actually_transferred);
 
+		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
 		local_irq_enable();
 
 #if SIMULATE_ERRORS
@@ -1236,19 +1094,16 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 			stat &= ~ERR_STAT;
 		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
 			/* Error detected */
-#if IDETAPE_DEBUG_LOG
-			if (tape->debug_level >= 1)
-				printk(KERN_INFO "ide-tape: %s: I/O error\n",
-					tape->name);
-#endif /* IDETAPE_DEBUG_LOG */
+			debug_log(DBG_ERR, "%s: I/O error\n", tape->name);
+
 			if (pc->c[0] == REQUEST_SENSE) {
-				printk(KERN_ERR "ide-tape: I/O error in request sense command\n");
+				printk(KERN_ERR "ide-tape: I/O error in request"
+						" sense command\n");
 				return ide_do_reset(drive);
 			}
-#if IDETAPE_DEBUG_LOG
-			if (tape->debug_level >= 1)
-				printk(KERN_INFO "ide-tape: [cmd %x]: check condition\n", pc->c[0]);
-#endif
+			debug_log(DBG_ERR, "[cmd %x]: check condition\n",
+					pc->c[0]);
+
 			/* Retry operation */
 			return idetape_retry_pc(drive);
 		}
@@ -1257,7 +1112,7 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 		    (stat & SEEK_STAT) == 0) {
 			/* Media access command */
 			tape->dsc_polling_start = jiffies;
-			tape->dsc_polling_frequency = IDETAPE_DSC_MA_FAST;
+			tape->dsc_poll_freq = IDETAPE_DSC_MA_FAST;
 			tape->dsc_timeout = jiffies + IDETAPE_DSC_MA_TIMEOUT;
 			/* Allow ide.c to handle other requests */
 			idetape_postpone_request(drive);
@@ -1282,7 +1137,7 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 	ireason = hwif->INB(IDE_IREASON_REG);
 
 	if (ireason & CD) {
-		printk(KERN_ERR "ide-tape: CoD != 0 in idetape_pc_intr\n");
+		printk(KERN_ERR "ide-tape: CoD != 0 in %s\n", __func__);
 		return ide_do_reset(drive);
 	}
 	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
@@ -1298,86 +1153,76 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 		temp = pc->actually_transferred + bcount;
 		if (temp > pc->request_transfer) {
 			if (temp > pc->buffer_size) {
-				printk(KERN_ERR "ide-tape: The tape wants to send us more data than expected - discarding data\n");
+				printk(KERN_ERR "ide-tape: The tape wants to "
+					"send us more data than expected "
+					"- discarding data\n");
 				idetape_discard_data(drive, bcount);
-				ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
+				ide_set_handler(drive, &idetape_pc_intr,
+						IDETAPE_WAIT_CMD, NULL);
 				return ide_started;
 			}
-#if IDETAPE_DEBUG_LOG
-			if (tape->debug_level >= 2)
-				printk(KERN_NOTICE "ide-tape: The tape wants to send us more data than expected - allowing transfer\n");
-#endif /* IDETAPE_DEBUG_LOG */
+			debug_log(DBG_SENSE, "The tape wants to send us more "
+				"data than expected - allowing transfer\n");
 		}
-	}
-	if (test_bit(PC_WRITING, &pc->flags)) {
-		if (pc->bh != NULL)
-			idetape_output_buffers(drive, pc, bcount);
-		else
-			/* Write the current buffer */
-			hwif->atapi_output_bytes(drive, pc->current_position,
-						 bcount);
+		iobuf = &idetape_input_buffers;
+		xferfunc = hwif->atapi_input_bytes;
 	} else {
-		if (pc->bh != NULL)
-			idetape_input_buffers(drive, pc, bcount);
-		else
-			/* Read the current buffer */
-			hwif->atapi_input_bytes(drive, pc->current_position,
-						bcount);
+		iobuf = &idetape_output_buffers;
+		xferfunc = hwif->atapi_output_bytes;
 	}
+
+	if (pc->bh)
+		iobuf(drive, pc, bcount);
+	else
+		xferfunc(drive, pc->current_position, bcount);
+
 	/* Update the current position */
 	pc->actually_transferred += bcount;
 	pc->current_position += bcount;
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 2)
-		printk(KERN_INFO "ide-tape: [cmd %x] transferred %d bytes "
-				 "on that interrupt\n", pc->c[0], bcount);
-#endif
+
+	debug_log(DBG_SENSE, "[cmd %x] transferred %d bytes on that intr.\n",
+			pc->c[0], bcount);
+
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
 	return ide_started;
 }
 
 /*
- *	Packet Command Interface
- *
- *	The current Packet Command is available in tape->pc, and will not
- *	change until we finish handling it. Each packet command is associated
- *	with a callback function that will be called when the command is
- *	finished.
+ * Packet Command Interface
  *
- *	The handling will be done in three stages:
+ * The current Packet Command is available in tape->pc, and will not change
+ * until we finish handling it. Each packet command is associated with a
+ * callback function that will be called when the command is finished.
  *
- *	1.	idetape_issue_packet_command will send the packet command to the
- *		drive, and will set the interrupt handler to idetape_pc_intr.
+ * The handling will be done in three stages:
  *
- *	2.	On each interrupt, idetape_pc_intr will be called. This step
- *		will be repeated until the device signals us that no more
- *		interrupts will be issued.
+ * 1. idetape_issue_pc will send the packet command to the drive, and will set
+ * the interrupt handler to idetape_pc_intr.
  *
- *	3.	ATAPI Tape media access commands have immediate status with a
- *		delayed process. In case of a successful initiation of a
- *		media access packet command, the DSC bit will be set when the
- *		actual execution of the command is finished. 
- *		Since the tape drive will not issue an interrupt, we have to
- *		poll for this event. In this case, we define the request as
- *		"low priority request" by setting rq_status to
- *		IDETAPE_RQ_POSTPONED, 	set a timer to poll for DSC and exit
- *		the driver.
+ * 2. On each interrupt, idetape_pc_intr will be called. This step will be
+ * repeated until the device signals us that no more interrupts will be issued.
  *
- *		ide.c will then give higher priority to requests which
- *		originate from the other device, until will change rq_status
- *		to RQ_ACTIVE.
+ * 3. ATAPI Tape media access commands have immediate status with a delayed
+ * process. In case of a successful initiation of a media access packet command,
+ * the DSC bit will be set when the actual execution of the command is finished.
+ * Since the tape drive will not issue an interrupt, we have to poll for this
+ * event. In this case, we define the request as "low priority request" by
+ * setting rq_status to IDETAPE_RQ_POSTPONED, set a timer to poll for DSC and
+ * exit the driver.
  *
- *	4.	When the packet command is finished, it will be checked for errors.
+ * ide.c will then give higher priority to requests which originate from the
+ * other device, until will change rq_status to RQ_ACTIVE.
  *
- *	5.	In case an error was found, we queue a request sense packet
- *		command in front of the request queue and retry the operation
- *		up to IDETAPE_MAX_PC_RETRIES times.
+ * 4. When the packet command is finished, it will be checked for errors.
  *
- *	6.	In case no error was found, or we decided to give up and not
- *		to retry again, the callback function will be called and then
- *		we will handle the next request.
+ * 5. In case an error was found, we queue a request sense packet command in
+ * front of the request queue and retry the operation up to
+ * IDETAPE_MAX_PC_RETRIES times.
  *
+ * 6. In case no error was found, or we decided to give up and not to retry
+ * again, the callback function will be called and then we will handle the next
+ * request.
  */
 static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 {
@@ -1388,8 +1233,9 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 	ide_startstop_t startstop;
 	u8 ireason;
 
-	if (ide_wait_stat(&startstop,drive,DRQ_STAT,BUSY_STAT,WAIT_READY)) {
-		printk(KERN_ERR "ide-tape: Strange, packet command initiated yet DRQ isn't asserted\n");
+	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
+		printk(KERN_ERR "ide-tape: Strange, packet command initiated "
+				"yet DRQ isn't asserted\n");
 		return startstop;
 	}
 	ireason = hwif->INB(IDE_IREASON_REG);
@@ -1422,7 +1268,7 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 	return ide_started;
 }
 
-static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape_pc_t *pc)
+static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
@@ -1443,9 +1289,9 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 	if (pc->retries > IDETAPE_MAX_PC_RETRIES ||
 	    test_bit(PC_ABORT, &pc->flags)) {
 		/*
-		 *	We will "abort" retrying a packet command in case
-		 *	a legitimate error code was received (crossing a
-		 *	filemark, or end of the media, for example).
+		 * We will "abort" retrying a packet command in case legitimate
+		 * error code was received (crossing a filemark, or end of the
+		 * media, for example).
 		 */
 		if (!test_bit(PC_ABORT, &pc->flags)) {
 			if (!(pc->c[0] == TEST_UNIT_READY &&
@@ -1464,10 +1310,7 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 		tape->failed_pc = NULL;
 		return pc->callback(drive);
 	}
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 2)
-		printk(KERN_INFO "ide-tape: Retry number - %d, cmd = %02X\n", pc->retries, pc->c[0]);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_SENSE, "Retry #%d, cmd = %02X\n", pc->retries, pc->c[0]);
 
 	pc->retries++;
 	/* We haven't transferred any data yet */
@@ -1499,31 +1342,24 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 	}
 }
 
-/*
- *	General packet command callback function.
- */
-static ide_startstop_t idetape_pc_callback (ide_drive_t *drive)
+static ide_startstop_t idetape_pc_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_pc_callback\n");
-#endif /* IDETAPE_DEBUG_LOG */
+
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	idetape_end_request(drive, tape->pc->error ? 0 : 1, 0);
 	return ide_stopped;
 }
 
-/*
- *	A mode sense command is used to "sense" tape parameters.
- */
-static void idetape_create_mode_sense_cmd (idetape_pc_t *pc, u8 page_code)
+/* A mode sense command is used to "sense" tape parameters. */
+static void idetape_create_mode_sense_cmd(idetape_pc_t *pc, u8 page_code)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = MODE_SENSE;
 	if (page_code != IDETAPE_BLOCK_DESCRIPTOR)
-		pc->c[1] = 8;	/* DBD = 1 - Don't return block descriptors */
+		/* DBD = 1 - Don't return block descriptors */
+		pc->c[1] = 8;
 	pc->c[2] = page_code;
 	/*
 	 * Changed pc->c[3] to 0 (255 will at best return unused info).
@@ -1533,7 +1369,8 @@ static void idetape_create_mode_sense_cmd (idetape_pc_t *pc, u8 page_code)
 	 * and return an error when 255 is used.
 	 */
 	pc->c[3] = 0;
-	pc->c[4] = 255;		/* (We will just discard data in that case) */
+	/* We will just discard data in that case */
+	pc->c[4] = 255;
 	if (page_code == IDETAPE_BLOCK_DESCRIPTOR)
 		pc->request_transfer = 12;
 	else if (page_code == IDETAPE_CAPABILITIES_PAGE)
@@ -1543,62 +1380,77 @@ static void idetape_create_mode_sense_cmd (idetape_pc_t *pc, u8 page_code)
 	pc->callback = &idetape_pc_callback;
 }
 
-static void calculate_speeds(ide_drive_t *drive)
+static void idetape_calculate_speeds(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	int full = 125, empty = 75;
 
-	if (time_after(jiffies, tape->controlled_pipeline_head_time + 120 * HZ)) {
-		tape->controlled_previous_pipeline_head = tape->controlled_last_pipeline_head;
-		tape->controlled_previous_head_time = tape->controlled_pipeline_head_time;
+	if (time_after(jiffies,
+			tape->controlled_pipeline_head_time + 120 * HZ)) {
+		tape->controlled_previous_pipeline_head =
+			tape->controlled_last_pipeline_head;
+		tape->controlled_previous_head_time =
+			tape->controlled_pipeline_head_time;
 		tape->controlled_last_pipeline_head = tape->pipeline_head;
 		tape->controlled_pipeline_head_time = jiffies;
 	}
 	if (time_after(jiffies, tape->controlled_pipeline_head_time + 60 * HZ))
-		tape->controlled_pipeline_head_speed = (tape->pipeline_head - tape->controlled_last_pipeline_head) * 32 * HZ / (jiffies - tape->controlled_pipeline_head_time);
+		tape->controlled_pipeline_head_speed = (tape->pipeline_head -
+				tape->controlled_last_pipeline_head) * 32 * HZ /
+				(jiffies - tape->controlled_pipeline_head_time);
 	else if (time_after(jiffies, tape->controlled_previous_head_time))
-		tape->controlled_pipeline_head_speed = (tape->pipeline_head - tape->controlled_previous_pipeline_head) * 32 * HZ / (jiffies - tape->controlled_previous_head_time);
+		tape->controlled_pipeline_head_speed = (tape->pipeline_head -
+				tape->controlled_previous_pipeline_head) * 32 *
+			HZ / (jiffies - tape->controlled_previous_head_time);
 
-	if (tape->nr_pending_stages < tape->max_stages /*- 1 */) {
+	if (tape->nr_pending_stages < tape->max_stages/*- 1 */) {
 		/* -1 for read mode error recovery */
-		if (time_after(jiffies, tape->uncontrolled_previous_head_time + 10 * HZ)) {
+		if (time_after(jiffies, tape->uncontrolled_previous_head_time +
+					10 * HZ)) {
 			tape->uncontrolled_pipeline_head_time = jiffies;
-			tape->uncontrolled_pipeline_head_speed = (tape->pipeline_head - tape->uncontrolled_previous_pipeline_head) * 32 * HZ / (jiffies - tape->uncontrolled_previous_head_time);
+			tape->uncontrolled_pipeline_head_speed =
+				(tape->pipeline_head -
+				 tape->uncontrolled_previous_pipeline_head) *
+				32 * HZ / (jiffies -
+					tape->uncontrolled_previous_head_time);
 		}
 	} else {
 		tape->uncontrolled_previous_head_time = jiffies;
 		tape->uncontrolled_previous_pipeline_head = tape->pipeline_head;
-		if (time_after(jiffies, tape->uncontrolled_pipeline_head_time + 30 * HZ)) {
+		if (time_after(jiffies, tape->uncontrolled_pipeline_head_time +
+					30 * HZ))
 			tape->uncontrolled_pipeline_head_time = jiffies;
-		}
+
 	}
-	tape->pipeline_head_speed = max(tape->uncontrolled_pipeline_head_speed, tape->controlled_pipeline_head_speed);
-	if (tape->speed_control == 0) {
-		tape->max_insert_speed = 5000;
-	} else if (tape->speed_control == 1) {
+	tape->pipeline_head_speed = max(tape->uncontrolled_pipeline_head_speed,
+					tape->controlled_pipeline_head_speed);
+
+	if (tape->speed_control == 1) {
 		if (tape->nr_pending_stages >= tape->max_stages / 2)
 			tape->max_insert_speed = tape->pipeline_head_speed +
-				(1100 - tape->pipeline_head_speed) * 2 * (tape->nr_pending_stages - tape->max_stages / 2) / tape->max_stages;
+				(1100 - tape->pipeline_head_speed) * 2 *
+				(tape->nr_pending_stages - tape->max_stages / 2)
+				/ tape->max_stages;
 		else
 			tape->max_insert_speed = 500 +
-				(tape->pipeline_head_speed - 500) * 2 * tape->nr_pending_stages / tape->max_stages;
+				(tape->pipeline_head_speed - 500) * 2 *
+				tape->nr_pending_stages / tape->max_stages;
+
 		if (tape->nr_pending_stages >= tape->max_stages * 99 / 100)
 			tape->max_insert_speed = 5000;
-	} else if (tape->speed_control == 2) {
-		tape->max_insert_speed = tape->pipeline_head_speed * empty / 100 +
-			(tape->pipeline_head_speed * full / 100 - tape->pipeline_head_speed * empty / 100) * tape->nr_pending_stages / tape->max_stages;
 	} else
 		tape->max_insert_speed = tape->speed_control;
+
 	tape->max_insert_speed = max(tape->max_insert_speed, 500);
 }
 
-static ide_startstop_t idetape_media_access_finished (ide_drive_t *drive)
+static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t *pc = tape->pc;
 	u8 stat;
 
-	stat = drive->hwif->INB(IDE_STATUS_REG);
+	stat = ide_read_status(drive);
+
 	if (stat & SEEK_STAT) {
 		if (stat & ERR_STAT) {
 			/* Error detected */
@@ -1618,14 +1470,14 @@ static ide_startstop_t idetape_media_access_finished (ide_drive_t *drive)
 	return pc->callback(drive);
 }
 
-static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
+static ide_startstop_t idetape_rw_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
-	int blocks = tape->pc->actually_transferred / tape->tape_block_size;
+	int blocks = tape->pc->actually_transferred / tape->blk_size;
 
-	tape->avg_size += blocks * tape->tape_block_size;
-	tape->insert_size += blocks * tape->tape_block_size;
+	tape->avg_size += blocks * tape->blk_size;
+	tape->insert_size += blocks * tape->blk_size;
 	if (tape->insert_size > 1024 * 1024)
 		tape->measure_insert_time = 1;
 	if (tape->measure_insert_time) {
@@ -1634,19 +1486,17 @@ static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
 		tape->insert_size = 0;
 	}
 	if (time_after(jiffies, tape->insert_time))
-		tape->insert_speed = tape->insert_size / 1024 * HZ / (jiffies - tape->insert_time);
+		tape->insert_speed = tape->insert_size / 1024 * HZ /
+					(jiffies - tape->insert_time);
 	if (time_after_eq(jiffies, tape->avg_time + HZ)) {
-		tape->avg_speed = tape->avg_size * HZ / (jiffies - tape->avg_time) / 1024;
+		tape->avg_speed = tape->avg_size * HZ /
+				(jiffies - tape->avg_time) / 1024;
 		tape->avg_size = 0;
 		tape->avg_time = jiffies;
 	}
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
-#if IDETAPE_DEBUG_LOG	
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_rw_callback\n");
-#endif /* IDETAPE_DEBUG_LOG */
-
-	tape->first_frame_position += blocks;
+	tape->first_frame += blocks;
 	rq->current_nr_sectors -= blocks;
 
 	if (!tape->pc->error)
@@ -1656,7 +1506,8 @@ static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
 	return ide_stopped;
 }
 
-static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
+static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
+		unsigned int length, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = READ_6;
@@ -1666,12 +1517,14 @@ static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsi
 	pc->bh = bh;
 	atomic_set(&bh->b_count, 0);
 	pc->buffer = NULL;
-	pc->request_transfer = pc->buffer_size = length * tape->tape_block_size;
+	pc->buffer_size = length * tape->blk_size;
+	pc->request_transfer = pc->buffer_size;
 	if (pc->request_transfer == tape->stage_size)
 		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
 }
 
-static void idetape_create_read_buffer_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
+static void idetape_create_read_buffer_cmd(idetape_tape_t *tape,
+		idetape_pc_t *pc, struct idetape_bh *bh)
 {
 	int size = 32768;
 	struct idetape_bh *p = bh;
@@ -1689,10 +1542,12 @@ static void idetape_create_read_buffer_cmd(idetape_tape_t *tape, idetape_pc_t *p
 		atomic_set(&p->b_count, 0);
 		p = p->b_reqnext;
 	}
-	pc->request_transfer = pc->buffer_size = size;
+	pc->request_transfer = size;
+	pc->buffer_size = size;
 }
 
-static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
+static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
+		unsigned int length, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_6;
@@ -1704,14 +1559,12 @@ static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, uns
 	pc->b_data = bh->b_data;
 	pc->b_count = atomic_read(&bh->b_count);
 	pc->buffer = NULL;
-	pc->request_transfer = pc->buffer_size = length * tape->tape_block_size;
+	pc->buffer_size = length * tape->blk_size;
+	pc->request_transfer = pc->buffer_size;
 	if (pc->request_transfer == tape->stage_size)
 		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
 }
 
-/*
- * idetape_do_request is our request handling function.	
- */
 static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 					  struct request *rq, sector_t block)
 {
@@ -1720,30 +1573,22 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	struct request *postponed_rq = tape->postponed_rq;
 	u8 stat;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 2)
-		printk(KERN_INFO "ide-tape: sector: %ld, "
-			"nr_sectors: %ld, current_nr_sectors: %d\n",
+	debug_log(DBG_SENSE, "sector: %ld, nr_sectors: %ld,"
+			" current_nr_sectors: %d\n",
 			rq->sector, rq->nr_sectors, rq->current_nr_sectors);
-#endif /* IDETAPE_DEBUG_LOG */
 
 	if (!blk_special_request(rq)) {
-		/*
-		 * We do not support buffer cache originated requests.
-		 */
+		/* We do not support buffer cache originated requests. */
 		printk(KERN_NOTICE "ide-tape: %s: Unsupported request in "
 			"request queue (%d)\n", drive->name, rq->cmd_type);
 		ide_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
 
-	/*
-	 *	Retry a failed packet command
-	 */
-	if (tape->failed_pc != NULL &&
-	    tape->pc->c[0] == REQUEST_SENSE) {
-		return idetape_issue_packet_command(drive, tape->failed_pc);
-	}
+	/* Retry a failed packet command */
+	if (tape->failed_pc && tape->pc->c[0] == REQUEST_SENSE)
+		return idetape_issue_pc(drive, tape->failed_pc);
+
 	if (postponed_rq != NULL)
 		if (rq != postponed_rq) {
 			printk(KERN_ERR "ide-tape: ide-tape.c bug - "
@@ -1758,7 +1603,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	 * If the tape is still busy, postpone our request and service
 	 * the other device meanwhile.
 	 */
-	stat = drive->hwif->INB(IDE_STATUS_REG);
+	stat = ide_read_status(drive);
 
 	if (!drive->dsc_overlap && !(rq->cmd[0] & REQ_IDETAPE_PC2))
 		set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
@@ -1768,16 +1613,15 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		drive->post_reset = 0;
 	}
 
-	if (tape->tape_still_time > 100 && tape->tape_still_time < 200)
-		tape->measure_insert_time = 1;
 	if (time_after(jiffies, tape->insert_time))
-		tape->insert_speed = tape->insert_size / 1024 * HZ / (jiffies - tape->insert_time);
-	calculate_speeds(drive);
+		tape->insert_speed = tape->insert_size / 1024 * HZ /
+					(jiffies - tape->insert_time);
+	idetape_calculate_speeds(drive);
 	if (!test_and_clear_bit(IDETAPE_IGNORE_DSC, &tape->flags) &&
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
-			tape->dsc_polling_frequency = tape->best_dsc_rw_frequency;
+			tape->dsc_poll_freq = tape->best_dsc_rw_freq;
 			tape->dsc_timeout = jiffies + IDETAPE_DSC_RW_TIMEOUT;
 		} else if (time_after(jiffies, tape->dsc_timeout)) {
 			printk(KERN_ERR "ide-tape: %s: DSC timeout\n",
@@ -1788,8 +1632,10 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 			} else {
 				return ide_do_reset(drive);
 			}
-		} else if (time_after(jiffies, tape->dsc_polling_start + IDETAPE_DSC_MA_THRESHOLD))
-			tape->dsc_polling_frequency = IDETAPE_DSC_MA_SLOW;
+		} else if (time_after(jiffies,
+					tape->dsc_polling_start +
+					IDETAPE_DSC_MA_THRESHOLD))
+			tape->dsc_poll_freq = IDETAPE_DSC_MA_SLOW;
 		idetape_postpone_request(drive);
 		return ide_stopped;
 	}
@@ -1797,20 +1643,23 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		tape->buffer_head++;
 		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
-		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors, (struct idetape_bh *)rq->special);
+		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors,
+					(struct idetape_bh *)rq->special);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
 		tape->buffer_head++;
 		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
-		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors, (struct idetape_bh *)rq->special);
+		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors,
+					 (struct idetape_bh *)rq->special);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_READ_BUFFER) {
 		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
-		idetape_create_read_buffer_cmd(tape, pc, rq->current_nr_sectors, (struct idetape_bh *)rq->special);
+		idetape_create_read_buffer_cmd(tape, pc,
+				(struct idetape_bh *)rq->special);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_PC1) {
@@ -1825,49 +1674,51 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	}
 	BUG();
 out:
-	return idetape_issue_packet_command(drive, pc);
+	return idetape_issue_pc(drive, pc);
 }
 
-/*
- *	Pipeline related functions
- */
-static inline int idetape_pipeline_active (idetape_tape_t *tape)
+/* Pipeline related functions */
+static inline int idetape_pipeline_active(idetape_tape_t *tape)
 {
 	int rc1, rc2;
 
 	rc1 = test_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
-	rc2 = (tape->active_data_request != NULL);
+	rc2 = (tape->active_data_rq != NULL);
 	return rc1;
 }
 
 /*
- *	idetape_kmalloc_stage uses __get_free_page to allocate a pipeline
- *	stage, along with all the necessary small buffers which together make
- *	a buffer of size tape->stage_size (or a bit more). We attempt to
- *	combine sequential pages as much as possible.
+ * The function below uses __get_free_page to allocate a pipeline stage, along
+ * with all the necessary small buffers which together make a buffer of size
+ * tape->stage_size (or a bit more). We attempt to combine sequential pages as
+ * much as possible.
  *
- *	Returns a pointer to the new allocated stage, or NULL if we
- *	can't (or don't want to) allocate a stage.
+ * It returns a pointer to the new allocated stage, or NULL if we can't (or
+ * don't want to) allocate a stage.
  *
- *	Pipeline stages are optional and are used to increase performance.
- *	If we can't allocate them, we'll manage without them.
+ * Pipeline stages are optional and are used to increase performance. If we
+ * can't allocate them, we'll manage without them.
  */
-static idetape_stage_t *__idetape_kmalloc_stage (idetape_tape_t *tape, int full, int clear)
+static idetape_stage_t *__idetape_kmalloc_stage(idetape_tape_t *tape, int full,
+						int clear)
 {
 	idetape_stage_t *stage;
 	struct idetape_bh *prev_bh, *bh;
 	int pages = tape->pages_per_stage;
 	char *b_data = NULL;
 
-	if ((stage = kmalloc(sizeof (idetape_stage_t),GFP_KERNEL)) == NULL)
+	stage = kmalloc(sizeof(idetape_stage_t), GFP_KERNEL);
+	if (!stage)
 		return NULL;
 	stage->next = NULL;
 
-	bh = stage->bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
+	stage->bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
+	bh = stage->bh;
 	if (bh == NULL)
 		goto abort;
 	bh->b_reqnext = NULL;
-	if ((bh->b_data = (char *) __get_free_page (GFP_KERNEL)) == NULL)
+	bh->b_data = (char *) __get_free_page(GFP_KERNEL);
+	if (!bh->b_data)
 		goto abort;
 	if (clear)
 		memset(bh->b_data, 0, PAGE_SIZE);
@@ -1875,7 +1726,8 @@ static idetape_stage_t *__idetape_kmalloc_stage (idetape_tape_t *tape, int full,
 	atomic_set(&bh->b_count, full ? bh->b_size : 0);
 
 	while (--pages) {
-		if ((b_data = (char *) __get_free_page (GFP_KERNEL)) == NULL)
+		b_data = (char *) __get_free_page(GFP_KERNEL);
+		if (!b_data)
 			goto abort;
 		if (clear)
 			memset(b_data, 0, PAGE_SIZE);
@@ -1893,7 +1745,8 @@ static idetape_stage_t *__idetape_kmalloc_stage (idetape_tape_t *tape, int full,
 			continue;
 		}
 		prev_bh = bh;
-		if ((bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL)) == NULL) {
+		bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
+		if (!bh) {
 			free_page((unsigned long) b_data);
 			goto abort;
 		}
@@ -1912,14 +1765,11 @@ abort:
 	return NULL;
 }
 
-static idetape_stage_t *idetape_kmalloc_stage (idetape_tape_t *tape)
+static idetape_stage_t *idetape_kmalloc_stage(idetape_tape_t *tape)
 {
 	idetape_stage_t *cache_stage = tape->cache_stage;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_kmalloc_stage\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	if (tape->nr_stages >= tape->max_stages)
 		return NULL;
@@ -1930,7 +1780,8 @@ static idetape_stage_t *idetape_kmalloc_stage (idetape_tape_t *tape)
 	return __idetape_kmalloc_stage(tape, 0, 0);
 }
 
-static int idetape_copy_stage_from_user (idetape_tape_t *tape, idetape_stage_t *stage, const char __user *buf, int n)
+static int idetape_copy_stage_from_user(idetape_tape_t *tape,
+		idetape_stage_t *stage, const char __user *buf, int n)
 {
 	struct idetape_bh *bh = tape->bh;
 	int count;
@@ -1938,12 +1789,15 @@ static int idetape_copy_stage_from_user (idetape_tape_t *tape, idetape_stage_t *
 
 	while (n) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_copy_stage_from_user\n");
+			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
+					__func__);
 			return 1;
 		}
-		count = min((unsigned int)(bh->b_size - atomic_read(&bh->b_count)), (unsigned int)n);
-		if (copy_from_user(bh->b_data + atomic_read(&bh->b_count), buf, count))
+		count = min((unsigned int)
+				(bh->b_size - atomic_read(&bh->b_count)),
+				(unsigned int)n);
+		if (copy_from_user(bh->b_data + atomic_read(&bh->b_count), buf,
+				count))
 			ret = 1;
 		n -= count;
 		atomic_add(count, &bh->b_count);
@@ -1958,7 +1812,8 @@ static int idetape_copy_stage_from_user (idetape_tape_t *tape, idetape_stage_t *
 	return ret;
 }
 
-static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, idetape_stage_t *stage, int n)
+static int idetape_copy_stage_to_user(idetape_tape_t *tape, char __user *buf,
+		idetape_stage_t *stage, int n)
 {
 	struct idetape_bh *bh = tape->bh;
 	int count;
@@ -1966,8 +1821,8 @@ static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, i
 
 	while (n) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_copy_stage_to_user\n");
+			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
+					__func__);
 			return 1;
 		}
 		count = min(tape->b_count, n);
@@ -1978,7 +1833,8 @@ static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, i
 		tape->b_count -= count;
 		buf += count;
 		if (!tape->b_count) {
-			tape->bh = bh = bh->b_reqnext;
+			bh = bh->b_reqnext;
+			tape->bh = bh;
 			if (bh) {
 				tape->b_data = bh->b_data;
 				tape->b_count = atomic_read(&bh->b_count);
@@ -1988,12 +1844,12 @@ static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, i
 	return ret;
 }
 
-static void idetape_init_merge_stage (idetape_tape_t *tape)
+static void idetape_init_merge_stage(idetape_tape_t *tape)
 {
 	struct idetape_bh *bh = tape->merge_stage->bh;
-	
+
 	tape->bh = bh;
-	if (tape->chrdev_direction == idetape_direction_write)
+	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
 		atomic_set(&bh->b_count, 0);
 	else {
 		tape->b_data = bh->b_data;
@@ -2001,7 +1857,7 @@ static void idetape_init_merge_stage (idetape_tape_t *tape)
 	}
 }
 
-static void idetape_switch_buffers (idetape_tape_t *tape, idetape_stage_t *stage)
+static void idetape_switch_buffers(idetape_tape_t *tape, idetape_stage_t *stage)
 {
 	struct idetape_bh *tmp;
 
@@ -2011,87 +1867,76 @@ static void idetape_switch_buffers (idetape_tape_t *tape, idetape_stage_t *stage
 	idetape_init_merge_stage(tape);
 }
 
-/*
- *	idetape_add_stage_tail adds a new stage at the end of the pipeline.
- */
-static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
+/* Add a new stage at the end of the pipeline. */
+static void idetape_add_stage_tail(ide_drive_t *drive, idetape_stage_t *stage)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
-	
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk (KERN_INFO "ide-tape: Reached idetape_add_stage_tail\n");
-#endif /* IDETAPE_DEBUG_LOG */
-	spin_lock_irqsave(&tape->spinlock, flags);
+
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+
+	spin_lock_irqsave(&tape->lock, flags);
 	stage->next = NULL;
 	if (tape->last_stage != NULL)
-		tape->last_stage->next=stage;
+		tape->last_stage->next = stage;
 	else
-		tape->first_stage = tape->next_stage=stage;
+		tape->first_stage = stage;
+		tape->next_stage  = stage;
 	tape->last_stage = stage;
 	if (tape->next_stage == NULL)
 		tape->next_stage = tape->last_stage;
 	tape->nr_stages++;
 	tape->nr_pending_stages++;
-	spin_unlock_irqrestore(&tape->spinlock, flags);
+	spin_unlock_irqrestore(&tape->lock, flags);
 }
 
-/*
- *	idetape_wait_for_request installs a completion in a pending request
- *	and sleeps until it is serviced.
- *
- *	The caller should ensure that the request will not be serviced
- *	before we install the completion (usually by disabling interrupts).
+/* Install a completion in a pending request and sleep until it is serviced. The
+ * caller should ensure that the request will not be serviced before we install
+ * the completion (usually by disabling interrupts).
  */
-static void idetape_wait_for_request (ide_drive_t *drive, struct request *rq)
+static void idetape_wait_for_request(ide_drive_t *drive, struct request *rq)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	idetape_tape_t *tape = drive->driver_data;
 
 	if (rq == NULL || !blk_special_request(rq)) {
-		printk (KERN_ERR "ide-tape: bug: Trying to sleep on non-valid request\n");
+		printk(KERN_ERR "ide-tape: bug: Trying to sleep on non-valid"
+				 " request\n");
 		return;
 	}
 	rq->end_io_data = &wait;
 	rq->end_io = blk_end_sync_rq;
-	spin_unlock_irq(&tape->spinlock);
+	spin_unlock_irq(&tape->lock);
 	wait_for_completion(&wait);
 	/* The stage and its struct request have been deallocated */
-	spin_lock_irq(&tape->spinlock);
+	spin_lock_irq(&tape->lock);
 }
 
-static ide_startstop_t idetape_read_position_callback (ide_drive_t *drive)
+static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_read_position_result_t *result;
-	
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_read_position_callback\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	u8 *readpos = tape->pc->buffer;
+
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	if (!tape->pc->error) {
-		result = (idetape_read_position_result_t *) tape->pc->buffer;
-#if IDETAPE_DEBUG_LOG
-		if (tape->debug_level >= 2)
-			printk(KERN_INFO "ide-tape: BOP - %s\n",result->bop ? "Yes":"No");
-		if (tape->debug_level >= 2)
-			printk(KERN_INFO "ide-tape: EOP - %s\n",result->eop ? "Yes":"No");
-#endif /* IDETAPE_DEBUG_LOG */
-		if (result->bpu) {
-			printk(KERN_INFO "ide-tape: Block location is unknown to the tape\n");
+		debug_log(DBG_SENSE, "BOP - %s\n",
+				(readpos[0] & 0x80) ? "Yes" : "No");
+		debug_log(DBG_SENSE, "EOP - %s\n",
+				(readpos[0] & 0x40) ? "Yes" : "No");
+
+		if (readpos[0] & 0x4) {
+			printk(KERN_INFO "ide-tape: Block location is unknown"
+					 "to the tape\n");
 			clear_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
 			idetape_end_request(drive, 0, 0);
 		} else {
-#if IDETAPE_DEBUG_LOG
-			if (tape->debug_level >= 2)
-				printk(KERN_INFO "ide-tape: Block Location - %u\n", ntohl(result->first_block));
-#endif /* IDETAPE_DEBUG_LOG */
-			tape->partition = result->partition;
-			tape->first_frame_position = ntohl(result->first_block);
-			tape->last_frame_position = ntohl(result->last_block);
-			tape->blocks_in_buffer = result->blocks_in_buffer[2];
+			debug_log(DBG_SENSE, "Block Location - %u\n",
+					be32_to_cpu(*(u32 *)&readpos[4]));
+
+			tape->partition = readpos[1];
+			tape->first_frame =
+				be32_to_cpu(*(u32 *)&readpos[4]);
 			set_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
 			idetape_end_request(drive, 1, 0);
 		}
@@ -2102,14 +1947,11 @@ static ide_startstop_t idetape_read_position_callback (ide_drive_t *drive)
 }
 
 /*
- *	idetape_create_write_filemark_cmd will:
- *
- *		1.	Write a filemark if write_filemark=1.
- *		2.	Flush the device buffers without writing a filemark
- *			if write_filemark=0.
- *
+ * Write a filemark if write_filemark=1. Flush the device buffers without
+ * writing a filemark otherwise.
  */
-static void idetape_create_write_filemark_cmd (ide_drive_t *drive, idetape_pc_t *pc,int write_filemark)
+static void idetape_create_write_filemark_cmd(ide_drive_t *drive,
+		idetape_pc_t *pc, int write_filemark)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_FILEMARKS;
@@ -2126,26 +1968,19 @@ static void idetape_create_test_unit_ready_cmd(idetape_pc_t *pc)
 }
 
 /*
- *	idetape_queue_pc_tail is based on the following functions:
- *
- *	ide_do_drive_cmd from ide.c
- *	cdrom_queue_request and cdrom_queue_packet_command from ide-cd.c
+ * We add a special packet command request to the tail of the request queue, and
+ * wait for it to be serviced. This is not to be called from within the request
+ * handling part of the driver! We allocate here data on the stack and it is
+ * valid until the request is finished. This is not the case for the bottom part
+ * of the driver, where we are always leaving the functions to wait for an
+ * interrupt or a timer event.
  *
- *	We add a special packet command request to the tail of the request
- *	queue, and wait for it to be serviced.
- *
- *	This is not to be called from within the request handling part
- *	of the driver ! We allocate here data in the stack, and it is valid
- *	until the request is finished. This is not the case for the bottom
- *	part of the driver, where we are always leaving the functions to wait
- *	for an interrupt or a timer event.
- *
- *	From the bottom part of the driver, we should allocate safe memory
- *	using idetape_next_pc_storage and idetape_next_rq_storage, and add
- *	the request to the request list without waiting for it to be serviced !
- *	In that case, we usually use idetape_queue_pc_head.
+ * From the bottom part of the driver, we should allocate safe memory using
+ * idetape_next_pc_storage() and ide_tape_next_rq_storage(), and add the request
+ * to the request list without waiting for it to be serviced! In that case, we
+ * usually use idetape_queue_pc_head().
  */
-static int __idetape_queue_pc_tail (ide_drive_t *drive, idetape_pc_t *pc)
+static int __idetape_queue_pc_tail(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 	struct request rq;
@@ -2156,7 +1991,8 @@ static int __idetape_queue_pc_tail (ide_drive_t *drive, idetape_pc_t *pc)
 	return ide_do_drive_cmd(drive, &rq, ide_wait);
 }
 
-static void idetape_create_load_unload_cmd (ide_drive_t *drive, idetape_pc_t *pc,int cmd)
+static void idetape_create_load_unload_cmd(ide_drive_t *drive, idetape_pc_t *pc,
+		int cmd)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = START_STOP;
@@ -2171,9 +2007,7 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	idetape_pc_t pc;
 	int load_attempted = 0;
 
-	/*
-	 * Wait for the tape to become ready
-	 */
+	/* Wait for the tape to become ready */
 	set_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags);
 	timeout += jiffies;
 	while (time_before(jiffies, timeout)) {
@@ -2181,10 +2015,12 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 		if (!__idetape_queue_pc_tail(drive, &pc))
 			return 0;
 		if ((tape->sense_key == 2 && tape->asc == 4 && tape->ascq == 2)
-		    || (tape->asc == 0x3A)) {	/* no media */
+		    || (tape->asc == 0x3A)) {
+			/* no media */
 			if (load_attempted)
 				return -ENOMEDIUM;
-			idetape_create_load_unload_cmd(drive, &pc, IDETAPE_LU_LOAD_MASK);
+			idetape_create_load_unload_cmd(drive, &pc,
+							IDETAPE_LU_LOAD_MASK);
 			__idetape_queue_pc_tail(drive, &pc);
 			load_attempted = 1;
 		/* not about to be ready */
@@ -2196,24 +2032,25 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	return -EIO;
 }
 
-static int idetape_queue_pc_tail (ide_drive_t *drive,idetape_pc_t *pc)
+static int idetape_queue_pc_tail(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	return __idetape_queue_pc_tail(drive, pc);
 }
 
-static int idetape_flush_tape_buffers (ide_drive_t *drive)
+static int idetape_flush_tape_buffers(ide_drive_t *drive)
 {
 	idetape_pc_t pc;
 	int rc;
 
 	idetape_create_write_filemark_cmd(drive, &pc, 0);
-	if ((rc = idetape_queue_pc_tail(drive, &pc)))
+	rc = idetape_queue_pc_tail(drive, &pc);
+	if (rc)
 		return rc;
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	return 0;
 }
 
-static void idetape_create_read_position_cmd (idetape_pc_t *pc)
+static void idetape_create_read_position_cmd(idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = READ_POSITION;
@@ -2221,25 +2058,23 @@ static void idetape_create_read_position_cmd (idetape_pc_t *pc)
 	pc->callback = &idetape_read_position_callback;
 }
 
-static int idetape_read_position (ide_drive_t *drive)
+static int idetape_read_position(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
 	int position;
 
-#if IDETAPE_DEBUG_LOG
-        if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_read_position\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	idetape_create_read_position_cmd(&pc);
 	if (idetape_queue_pc_tail(drive, &pc))
 		return -1;
-	position = tape->first_frame_position;
+	position = tape->first_frame;
 	return position;
 }
 
-static void idetape_create_locate_cmd (ide_drive_t *drive, idetape_pc_t *pc, unsigned int block, u8 partition, int skip)
+static void idetape_create_locate_cmd(ide_drive_t *drive, idetape_pc_t *pc,
+		unsigned int block, u8 partition, int skip)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = POSITION_TO_ELEMENT;
@@ -2250,7 +2085,8 @@ static void idetape_create_locate_cmd (ide_drive_t *drive, idetape_pc_t *pc, uns
 	pc->callback = &idetape_pc_callback;
 }
 
-static int idetape_create_prevent_cmd (ide_drive_t *drive, idetape_pc_t *pc, int prevent)
+static int idetape_create_prevent_cmd(ide_drive_t *drive, idetape_pc_t *pc,
+				      int prevent)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -2265,17 +2101,17 @@ static int idetape_create_prevent_cmd (ide_drive_t *drive, idetape_pc_t *pc, int
 	return 1;
 }
 
-static int __idetape_discard_read_pipeline (ide_drive_t *drive)
+static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
 	int cnt;
 
-	if (tape->chrdev_direction != idetape_direction_read)
+	if (tape->chrdev_dir != IDETAPE_DIR_READ)
 		return 0;
 
 	/* Remove merge stage. */
-	cnt = tape->merge_stage_size / tape->tape_block_size;
+	cnt = tape->merge_stage_size / tape->blk_size;
 	if (test_and_clear_bit(IDETAPE_FILEMARK, &tape->flags))
 		++cnt;		/* Filemarks count as 1 sector */
 	tape->merge_stage_size = 0;
@@ -2286,22 +2122,22 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 
 	/* Clear pipeline flags. */
 	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
-	tape->chrdev_direction = idetape_direction_none;
+	tape->chrdev_dir = IDETAPE_DIR_NONE;
 
 	/* Remove pipeline stages. */
 	if (tape->first_stage == NULL)
 		return 0;
 
-	spin_lock_irqsave(&tape->spinlock, flags);
+	spin_lock_irqsave(&tape->lock, flags);
 	tape->next_stage = NULL;
 	if (idetape_pipeline_active(tape))
-		idetape_wait_for_request(drive, tape->active_data_request);
-	spin_unlock_irqrestore(&tape->spinlock, flags);
+		idetape_wait_for_request(drive, tape->active_data_rq);
+	spin_unlock_irqrestore(&tape->lock, flags);
 
 	while (tape->first_stage != NULL) {
 		struct request *rq_ptr = &tape->first_stage->rq;
 
-		cnt += rq_ptr->nr_sectors - rq_ptr->current_nr_sectors; 
+		cnt += rq_ptr->nr_sectors - rq_ptr->current_nr_sectors;
 		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
 			++cnt;
 		idetape_remove_stage_head(drive);
@@ -2312,21 +2148,19 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 }
 
 /*
- *	idetape_position_tape positions the tape to the requested block
- *	using the LOCATE packet command. A READ POSITION command is then
- *	issued to check where we are positioned.
- *
- *	Like all higher level operations, we queue the commands at the tail
- *	of the request queue and wait for their completion.
- *	
+ * Position the tape to the requested block using the LOCATE packet command.
+ * A READ POSITION command is then issued to check where we are positioned. Like
+ * all higher level operations, we queue the commands at the tail of the request
+ * queue and wait for their completion.
  */
-static int idetape_position_tape (ide_drive_t *drive, unsigned int block, u8 partition, int skip)
+static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
+		u8 partition, int skip)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int retval;
 	idetape_pc_t pc;
 
-	if (tape->chrdev_direction == idetape_direction_read)
+	if (tape->chrdev_dir == IDETAPE_DIR_READ)
 		__idetape_discard_read_pipeline(drive);
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
@@ -2338,7 +2172,8 @@ static int idetape_position_tape (ide_drive_t *drive, unsigned int block, u8 par
 	return (idetape_queue_pc_tail(drive, &pc));
 }
 
-static void idetape_discard_read_pipeline (ide_drive_t *drive, int restore_position)
+static void idetape_discard_read_pipeline(ide_drive_t *drive,
+					  int restore_position)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int cnt;
@@ -2349,35 +2184,37 @@ static void idetape_discard_read_pipeline (ide_drive_t *drive, int restore_posit
 		position = idetape_read_position(drive);
 		seek = position > cnt ? position - cnt : 0;
 		if (idetape_position_tape(drive, seek, 0, 0)) {
-			printk(KERN_INFO "ide-tape: %s: position_tape failed in discard_pipeline()\n", tape->name);
+			printk(KERN_INFO "ide-tape: %s: position_tape failed in"
+					 " discard_pipeline()\n", tape->name);
 			return;
 		}
 	}
 }
 
 /*
- * idetape_queue_rw_tail generates a read/write request for the block
- * device interface and wait for it to be serviced.
+ * Generate a read/write request for the block device interface and wait for it
+ * to be serviced.
  */
-static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct idetape_bh *bh)
+static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
+				 struct idetape_bh *bh)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct request rq;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 2)
-		printk(KERN_INFO "ide-tape: idetape_queue_rw_tail: cmd=%d\n",cmd);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
+
 	if (idetape_pipeline_active(tape)) {
-		printk(KERN_ERR "ide-tape: bug: the pipeline is active in idetape_queue_rw_tail\n");
+		printk(KERN_ERR "ide-tape: bug: the pipeline is active in %s\n",
+				__func__);
 		return (0);
 	}
 
 	idetape_init_rq(&rq, cmd);
 	rq.rq_disk = tape->disk;
 	rq.special = (void *)bh;
-	rq.sector = tape->first_frame_position;
-	rq.nr_sectors = rq.current_nr_sectors = blocks;
+	rq.sector = tape->first_frame;
+	rq.nr_sectors		= blocks;
+	rq.current_nr_sectors	= blocks;
 	(void) ide_do_drive_cmd(drive, &rq, ide_wait);
 
 	if ((cmd & (REQ_IDETAPE_READ | REQ_IDETAPE_WRITE)) == 0)
@@ -2387,14 +2224,11 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
 		idetape_init_merge_stage(tape);
 	if (rq.errors == IDETAPE_ERROR_GENERAL)
 		return -EIO;
-	return (tape->tape_block_size * (blocks-rq.current_nr_sectors));
+	return (tape->blk_size * (blocks-rq.current_nr_sectors));
 }
 
-/*
- *	idetape_insert_pipeline_into_queue is used to start servicing the
- *	pipeline stages, starting from tape->next_stage.
- */
-static void idetape_insert_pipeline_into_queue (ide_drive_t *drive)
+/* start servicing the pipeline stages, starting from tape->next_stage. */
+static void idetape_plug_pipeline(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -2403,19 +2237,20 @@ static void idetape_insert_pipeline_into_queue (ide_drive_t *drive)
 	if (!idetape_pipeline_active(tape)) {
 		set_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
 		idetape_activate_next_stage(drive);
-		(void) ide_do_drive_cmd(drive, tape->active_data_request, ide_end);
+		(void) ide_do_drive_cmd(drive, tape->active_data_rq, ide_end);
 	}
 }
 
-static void idetape_create_inquiry_cmd (idetape_pc_t *pc)
+static void idetape_create_inquiry_cmd(idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = INQUIRY;
-	pc->c[4] = pc->request_transfer = 254;
+	pc->c[4] = 254;
+	pc->request_transfer = 254;
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_create_rewind_cmd (ide_drive_t *drive, idetape_pc_t *pc)
+static void idetape_create_rewind_cmd(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = REZERO_UNIT;
@@ -2423,7 +2258,7 @@ static void idetape_create_rewind_cmd (ide_drive_t *drive, idetape_pc_t *pc)
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_create_erase_cmd (idetape_pc_t *pc)
+static void idetape_create_erase_cmd(idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = ERASE;
@@ -2432,7 +2267,7 @@ static void idetape_create_erase_cmd (idetape_pc_t *pc)
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_create_space_cmd (idetape_pc_t *pc,int count, u8 cmd)
+static void idetape_create_space_cmd(idetape_pc_t *pc, int count, u8 cmd)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = SPACE;
@@ -2442,89 +2277,87 @@ static void idetape_create_space_cmd (idetape_pc_t *pc,int count, u8 cmd)
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_wait_first_stage (ide_drive_t *drive)
+static void idetape_wait_first_stage(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
 
 	if (tape->first_stage == NULL)
 		return;
-	spin_lock_irqsave(&tape->spinlock, flags);
+	spin_lock_irqsave(&tape->lock, flags);
 	if (tape->active_stage == tape->first_stage)
-		idetape_wait_for_request(drive, tape->active_data_request);
-	spin_unlock_irqrestore(&tape->spinlock, flags);
+		idetape_wait_for_request(drive, tape->active_data_rq);
+	spin_unlock_irqrestore(&tape->lock, flags);
 }
 
 /*
- *	idetape_add_chrdev_write_request tries to add a character device
- *	originated write request to our pipeline. In case we don't succeed,
- *	we revert to non-pipelined operation mode for this request.
+ * Try to add a character device originated write request to our pipeline. In
+ * case we don't succeed, we revert to non-pipelined operation mode for this
+ * request. In order to accomplish that, we
  *
- *	1.	Try to allocate a new pipeline stage.
- *	2.	If we can't, wait for more and more requests to be serviced
- *		and try again each time.
- *	3.	If we still can't allocate a stage, fallback to
- *		non-pipelined operation mode for this request.
+ * 1. Try to allocate a new pipeline stage.
+ * 2. If we can't, wait for more and more requests to be serviced and try again
+ * each time.
+ * 3. If we still can't allocate a stage, fallback to non-pipelined operation
+ * mode for this request.
  */
-static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
+static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *new_stage;
 	unsigned long flags;
 	struct request *rq;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 3)
-		printk(KERN_INFO "ide-tape: Reached idetape_add_chrdev_write_request\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
-     	/*
-     	 *	Attempt to allocate a new stage.
-	 *	Pay special attention to possible race conditions.
-	 */
+	/* Attempt to allocate a new stage. Beware possible race conditions. */
 	while ((new_stage = idetape_kmalloc_stage(tape)) == NULL) {
-		spin_lock_irqsave(&tape->spinlock, flags);
+		spin_lock_irqsave(&tape->lock, flags);
 		if (idetape_pipeline_active(tape)) {
-			idetape_wait_for_request(drive, tape->active_data_request);
-			spin_unlock_irqrestore(&tape->spinlock, flags);
+			idetape_wait_for_request(drive, tape->active_data_rq);
+			spin_unlock_irqrestore(&tape->lock, flags);
 		} else {
-			spin_unlock_irqrestore(&tape->spinlock, flags);
-			idetape_insert_pipeline_into_queue(drive);
+			spin_unlock_irqrestore(&tape->lock, flags);
+			idetape_plug_pipeline(drive);
 			if (idetape_pipeline_active(tape))
 				continue;
 			/*
-			 *	Linux is short on memory. Fallback to
-			 *	non-pipelined operation mode for this request.
+			 * The machine is short on memory. Fallback to non-
+			 * pipelined operation mode for this request.
 			 */
-			return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks, tape->merge_stage->bh);
+			return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
+						blocks, tape->merge_stage->bh);
 		}
 	}
 	rq = &new_stage->rq;
 	idetape_init_rq(rq, REQ_IDETAPE_WRITE);
 	/* Doesn't actually matter - We always assume sequential access */
-	rq->sector = tape->first_frame_position;
-	rq->nr_sectors = rq->current_nr_sectors = blocks;
+	rq->sector = tape->first_frame;
+	rq->current_nr_sectors = blocks;
+	rq->nr_sectors = blocks;
 
 	idetape_switch_buffers(tape, new_stage);
 	idetape_add_stage_tail(drive, new_stage);
 	tape->pipeline_head++;
-	calculate_speeds(drive);
+	idetape_calculate_speeds(drive);
 
 	/*
-	 *	Estimate whether the tape has stopped writing by checking
-	 *	if our write pipeline is currently empty. If we are not
-	 *	writing anymore, wait for the pipeline to be full enough
-	 *	(90%) before starting to service requests, so that we will
-	 *	be able to keep up with the higher speeds of the tape.
+	 * Estimate whether the tape has stopped writing by checking if our
+	 * write pipeline is currently empty. If we are not writing anymore,
+	 * wait for the pipeline to be almost completely full (90%) before
+	 * starting to service requests, so that we will be able to keep up with
+	 * the higher speeds of the tape.
 	 */
 	if (!idetape_pipeline_active(tape)) {
 		if (tape->nr_stages >= tape->max_stages * 9 / 10 ||
-		    tape->nr_stages >= tape->max_stages - tape->uncontrolled_pipeline_head_speed * 3 * 1024 / tape->tape_block_size) {
+			tape->nr_stages >= tape->max_stages -
+			tape->uncontrolled_pipeline_head_speed * 3 * 1024 /
+			tape->blk_size) {
 			tape->measure_insert_time = 1;
 			tape->insert_time = jiffies;
 			tape->insert_size = 0;
 			tape->insert_speed = 0;
-			idetape_insert_pipeline_into_queue(drive);
+			idetape_plug_pipeline(drive);
 		}
 	}
 	if (test_and_clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags))
@@ -2534,31 +2367,32 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 }
 
 /*
- *	idetape_wait_for_pipeline will wait until all pending pipeline
- *	requests are serviced. Typically called on device close.
+ * Wait until all pending pipeline requests are serviced. Typically called on
+ * device close.
  */
-static void idetape_wait_for_pipeline (ide_drive_t *drive)
+static void idetape_wait_for_pipeline(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
 
 	while (tape->next_stage || idetape_pipeline_active(tape)) {
-		idetape_insert_pipeline_into_queue(drive);
-		spin_lock_irqsave(&tape->spinlock, flags);
+		idetape_plug_pipeline(drive);
+		spin_lock_irqsave(&tape->lock, flags);
 		if (idetape_pipeline_active(tape))
-			idetape_wait_for_request(drive, tape->active_data_request);
-		spin_unlock_irqrestore(&tape->spinlock, flags);
+			idetape_wait_for_request(drive, tape->active_data_rq);
+		spin_unlock_irqrestore(&tape->lock, flags);
 	}
 }
 
-static void idetape_empty_write_pipeline (ide_drive_t *drive)
+static void idetape_empty_write_pipeline(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int blocks, min;
 	struct idetape_bh *bh;
 
-	if (tape->chrdev_direction != idetape_direction_write) {
-		printk(KERN_ERR "ide-tape: bug: Trying to empty write pipeline, but we are not writing.\n");
+	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
+		printk(KERN_ERR "ide-tape: bug: Trying to empty write pipeline,"
+				" but we are not writing.\n");
 		return;
 	}
 	if (tape->merge_stage_size > tape->stage_size) {
@@ -2566,12 +2400,13 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 		tape->merge_stage_size = tape->stage_size;
 	}
 	if (tape->merge_stage_size) {
-		blocks = tape->merge_stage_size / tape->tape_block_size;
-		if (tape->merge_stage_size % tape->tape_block_size) {
+		blocks = tape->merge_stage_size / tape->blk_size;
+		if (tape->merge_stage_size % tape->blk_size) {
 			unsigned int i;
 
 			blocks++;
-			i = tape->tape_block_size - tape->merge_stage_size % tape->tape_block_size;
+			i = tape->blk_size - tape->merge_stage_size %
+				tape->blk_size;
 			bh = tape->bh->b_reqnext;
 			while (bh) {
 				atomic_set(&bh->b_count, 0);
@@ -2580,12 +2415,14 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 			bh = tape->bh;
 			while (i) {
 				if (bh == NULL) {
-
-					printk(KERN_INFO "ide-tape: bug, bh NULL\n");
+					printk(KERN_INFO "ide-tape: bug,"
+							 " bh NULL\n");
 					break;
 				}
-				min = min(i, (unsigned int)(bh->b_size - atomic_read(&bh->b_count)));
-				memset(bh->b_data + atomic_read(&bh->b_count), 0, min);
+				min = min(i, (unsigned int)(bh->b_size -
+						atomic_read(&bh->b_count)));
+				memset(bh->b_data + atomic_read(&bh->b_count),
+						0, min);
 				atomic_add(min, &bh->b_count);
 				i -= min;
 				bh = bh->b_reqnext;
@@ -2600,13 +2437,13 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 		tape->merge_stage = NULL;
 	}
 	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
-	tape->chrdev_direction = idetape_direction_none;
+	tape->chrdev_dir = IDETAPE_DIR_NONE;
 
 	/*
-	 *	On the next backup, perform the feedback loop again.
-	 *	(I don't want to keep sense information between backups,
-	 *	 as some systems are constantly on, and the system load
-	 *	 can be totally different on the next backup).
+	 * On the next backup, perform the feedback loop again. (I don't want to
+	 * keep sense information between backups, as some systems are
+	 * constantly on, and the system load can be totally different on the
+	 * next backup).
 	 */
 	tape->max_stages = tape->min_pipeline;
 	if (tape->first_stage != NULL ||
@@ -2621,21 +2458,25 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 	}
 }
 
-static void idetape_restart_speed_control (ide_drive_t *drive)
+static void idetape_restart_speed_control(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
 	tape->restart_speed_control_req = 0;
 	tape->pipeline_head = 0;
-	tape->controlled_last_pipeline_head = tape->uncontrolled_last_pipeline_head = 0;
-	tape->controlled_previous_pipeline_head = tape->uncontrolled_previous_pipeline_head = 0;
-	tape->pipeline_head_speed = tape->controlled_pipeline_head_speed = 5000;
+	tape->controlled_last_pipeline_head = 0;
+	tape->controlled_previous_pipeline_head = 0;
+	tape->uncontrolled_previous_pipeline_head = 0;
+	tape->controlled_pipeline_head_speed = 5000;
+	tape->pipeline_head_speed = 5000;
 	tape->uncontrolled_pipeline_head_speed = 0;
-	tape->controlled_pipeline_head_time = tape->uncontrolled_pipeline_head_time = jiffies;
-	tape->controlled_previous_head_time = tape->uncontrolled_previous_head_time = jiffies;
+	tape->controlled_pipeline_head_time =
+		tape->uncontrolled_pipeline_head_time = jiffies;
+	tape->controlled_previous_head_time =
+		tape->uncontrolled_previous_head_time = jiffies;
 }
 
-static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
+static int idetape_init_read(ide_drive_t *drive, int max_stages)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *new_stage;
@@ -2644,32 +2485,35 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 	u16 blocks = *(u16 *)&tape->caps[12];
 
 	/* Initialize read operation */
-	if (tape->chrdev_direction != idetape_direction_read) {
-		if (tape->chrdev_direction == idetape_direction_write) {
+	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
+		if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
 			idetape_empty_write_pipeline(drive);
 			idetape_flush_tape_buffers(drive);
 		}
 		if (tape->merge_stage || tape->merge_stage_size) {
-			printk (KERN_ERR "ide-tape: merge_stage_size should be 0 now\n");
+			printk(KERN_ERR "ide-tape: merge_stage_size should be"
+					 " 0 now\n");
 			tape->merge_stage_size = 0;
 		}
-		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
+		tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0);
+		if (!tape->merge_stage)
 			return -ENOMEM;
-		tape->chrdev_direction = idetape_direction_read;
+		tape->chrdev_dir = IDETAPE_DIR_READ;
 
 		/*
-		 *	Issue a read 0 command to ensure that DSC handshake
-		 *	is switched from completion mode to buffer available
-		 *	mode.
-		 *	No point in issuing this if DSC overlap isn't supported,
-		 *	some drives (Seagate STT3401A) will return an error.
+		 * Issue a read 0 command to ensure that DSC handshake is
+		 * switched from completion mode to buffer available mode.
+		 * No point in issuing this if DSC overlap isn't supported, some
+		 * drives (Seagate STT3401A) will return an error.
 		 */
 		if (drive->dsc_overlap) {
-			bytes_read = idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, 0, tape->merge_stage->bh);
+			bytes_read = idetape_queue_rw_tail(drive,
+							REQ_IDETAPE_READ, 0,
+							tape->merge_stage->bh);
 			if (bytes_read < 0) {
 				__idetape_kfree_stage(tape->merge_stage);
 				tape->merge_stage = NULL;
-				tape->chrdev_direction = idetape_direction_none;
+				tape->chrdev_dir = IDETAPE_DIR_NONE;
 				return bytes_read;
 			}
 		}
@@ -2677,8 +2521,9 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 	if (tape->restart_speed_control_req)
 		idetape_restart_speed_control(drive);
 	idetape_init_rq(&rq, REQ_IDETAPE_READ);
-	rq.sector = tape->first_frame_position;
-	rq.nr_sectors = rq.current_nr_sectors = blocks;
+	rq.sector = tape->first_frame;
+	rq.nr_sectors = blocks;
+	rq.current_nr_sectors = blocks;
 	if (!test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags) &&
 	    tape->nr_stages < max_stages) {
 		new_stage = idetape_kmalloc_stage(tape);
@@ -2696,50 +2541,43 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 			tape->insert_time = jiffies;
 			tape->insert_size = 0;
 			tape->insert_speed = 0;
-			idetape_insert_pipeline_into_queue(drive);
+			idetape_plug_pipeline(drive);
 		}
 	}
 	return 0;
 }
 
 /*
- *	idetape_add_chrdev_read_request is called from idetape_chrdev_read
- *	to service a character device read request and add read-ahead
- *	requests to our pipeline.
+ * Called from idetape_chrdev_read() to service a character device read request
+ * and add read-ahead requests to our pipeline.
  */
-static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
+static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
 	struct request *rq_ptr;
 	int bytes_read;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_add_chrdev_read_request, %d blocks\n", blocks);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
 
-	/*
-	 * If we are at a filemark, return a read length of 0
-	 */
+	/* If we are at a filemark, return a read length of 0 */
 	if (test_bit(IDETAPE_FILEMARK, &tape->flags))
 		return 0;
 
-	/*
-	 * Wait for the next block to be available at the head
-	 * of the pipeline
-	 */
-	idetape_initiate_read(drive, tape->max_stages);
+	/* Wait for the next block to reach the head of the pipeline. */
+	idetape_init_read(drive, tape->max_stages);
 	if (tape->first_stage == NULL) {
 		if (test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags))
 			return 0;
-		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks, tape->merge_stage->bh);
+		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
+					tape->merge_stage->bh);
 	}
 	idetape_wait_first_stage(drive);
 	rq_ptr = &tape->first_stage->rq;
-	bytes_read = tape->tape_block_size * (rq_ptr->nr_sectors - rq_ptr->current_nr_sectors);
-	rq_ptr->nr_sectors = rq_ptr->current_nr_sectors = 0;
-
+	bytes_read = tape->blk_size * (rq_ptr->nr_sectors -
+					rq_ptr->current_nr_sectors);
+	rq_ptr->nr_sectors = 0;
+	rq_ptr->current_nr_sectors = 0;
 
 	if (rq_ptr->errors == IDETAPE_ERROR_EOD)
 		return 0;
@@ -2747,43 +2585,46 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 		idetape_switch_buffers(tape, tape->first_stage);
 		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
 			set_bit(IDETAPE_FILEMARK, &tape->flags);
-		spin_lock_irqsave(&tape->spinlock, flags);
+		spin_lock_irqsave(&tape->lock, flags);
 		idetape_remove_stage_head(drive);
-		spin_unlock_irqrestore(&tape->spinlock, flags);
+		spin_unlock_irqrestore(&tape->lock, flags);
 		tape->pipeline_head++;
-		calculate_speeds(drive);
+		idetape_calculate_speeds(drive);
 	}
-	if (bytes_read > blocks * tape->tape_block_size) {
-		printk(KERN_ERR "ide-tape: bug: trying to return more bytes than requested\n");
-		bytes_read = blocks * tape->tape_block_size;
+	if (bytes_read > blocks * tape->blk_size) {
+		printk(KERN_ERR "ide-tape: bug: trying to return more bytes"
+				" than requested\n");
+		bytes_read = blocks * tape->blk_size;
 	}
 	return (bytes_read);
 }
 
-static void idetape_pad_zeros (ide_drive_t *drive, int bcount)
+static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct idetape_bh *bh;
 	int blocks;
-	
+
 	while (bcount) {
 		unsigned int count;
 
 		bh = tape->merge_stage->bh;
 		count = min(tape->stage_size, bcount);
 		bcount -= count;
-		blocks = count / tape->tape_block_size;
+		blocks = count / tape->blk_size;
 		while (count) {
-			atomic_set(&bh->b_count, min(count, (unsigned int)bh->b_size));
+			atomic_set(&bh->b_count,
+				   min(count, (unsigned int)bh->b_size));
 			memset(bh->b_data, 0, atomic_read(&bh->b_count));
 			count -= atomic_read(&bh->b_count);
 			bh = bh->b_reqnext;
 		}
-		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks, tape->merge_stage->bh);
+		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks,
+				      tape->merge_stage->bh);
 	}
 }
 
-static int idetape_pipeline_size (ide_drive_t *drive)
+static int idetape_pipeline_size(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *stage;
@@ -2794,9 +2635,10 @@ static int idetape_pipeline_size (ide_drive_t *drive)
 	stage = tape->first_stage;
 	while (stage != NULL) {
 		rq = &stage->rq;
-		size += tape->tape_block_size * (rq->nr_sectors-rq->current_nr_sectors);
+		size += tape->blk_size * (rq->nr_sectors -
+				rq->current_nr_sectors);
 		if (rq->errors == IDETAPE_ERROR_FILEMARK)
-			size += tape->tape_block_size;
+			size += tape->blk_size;
 		stage = stage->next;
 	}
 	size += tape->merge_stage_size;
@@ -2804,20 +2646,18 @@ static int idetape_pipeline_size (ide_drive_t *drive)
 }
 
 /*
- *	Rewinds the tape to the Beginning Of the current Partition (BOP).
- *
- *	We currently support only one partition.
- */ 
-static int idetape_rewind_tape (ide_drive_t *drive)
+ * Rewinds the tape to the Beginning Of the current Partition (BOP). We
+ * currently support only one partition.
+ */
+static int idetape_rewind_tape(ide_drive_t *drive)
 {
 	int retval;
 	idetape_pc_t pc;
-#if IDETAPE_DEBUG_LOG
-	idetape_tape_t *tape = drive->driver_data;
-	if (tape->debug_level >= 2)
-		printk(KERN_INFO "ide-tape: Reached idetape_rewind_tape\n");
-#endif /* IDETAPE_DEBUG_LOG */	
-	
+	idetape_tape_t *tape;
+	tape = drive->driver_data;
+
+	debug_log(DBG_SENSE, "Enter %s\n", __func__);
+
 	idetape_create_rewind_cmd(drive, &pc);
 	retval = idetape_queue_pc_tail(drive, &pc);
 	if (retval)
@@ -2830,14 +2670,9 @@ static int idetape_rewind_tape (ide_drive_t *drive)
 	return 0;
 }
 
-/*
- *	Our special ide-tape ioctl's.
- *
- *	Currently there aren't any ioctl's.
- *	mtio.h compatible commands should be issued to the character device
- *	interface.
- */
-static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned long arg)
+/* mtio.h compatible commands should be issued to the chrdev interface. */
+static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd,
+				unsigned long arg)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	void __user *argp = (void __user *)arg;
@@ -2848,44 +2683,41 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned l
 		int nr_stages;
 	} config;
 
-#if IDETAPE_DEBUG_LOG	
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_blkdev_ioctl\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+
 	switch (cmd) {
-		case 0x0340:
-			if (copy_from_user(&config, argp, sizeof(config)))
-				return -EFAULT;
-			tape->best_dsc_rw_frequency = config.dsc_rw_frequency;
-			tape->max_stages = config.nr_stages;
-			break;
-		case 0x0350:
-			config.dsc_rw_frequency = (int) tape->best_dsc_rw_frequency;
-			config.nr_stages = tape->max_stages; 
-			if (copy_to_user(argp, &config, sizeof(config)))
-				return -EFAULT;
-			break;
-		default:
-			return -EIO;
+	case 0x0340:
+		if (copy_from_user(&config, argp, sizeof(config)))
+			return -EFAULT;
+		tape->best_dsc_rw_freq = config.dsc_rw_frequency;
+		tape->max_stages = config.nr_stages;
+		break;
+	case 0x0350:
+		config.dsc_rw_frequency = (int) tape->best_dsc_rw_freq;
+		config.nr_stages = tape->max_stages;
+		if (copy_to_user(argp, &config, sizeof(config)))
+			return -EFAULT;
+		break;
+	default:
+		return -EIO;
 	}
 	return 0;
 }
 
 /*
- *	idetape_space_over_filemarks is now a bit more complicated than just
- *	passing the command to the tape since we may have crossed some
- *	filemarks during our pipelined read-ahead mode.
- *
- *	As a minor side effect, the pipeline enables us to support MTFSFM when
- *	the filemark is in our internal pipeline even if the tape doesn't
- *	support spacing over filemarks in the reverse direction.
+ * The function below is now a bit more complicated than just passing the
+ * command to the tape since we may have crossed some filemarks during our
+ * pipelined read-ahead mode. As a minor side effect, the pipeline enables us to
+ * support MTFSFM when the filemark is in our internal pipeline even if the tape
+ * doesn't support spacing over filemarks in the reverse direction.
  */
-static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_count)
+static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
+					int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
 	unsigned long flags;
-	int retval,count=0;
+	int retval, count = 0;
 	int sprev = !!(tape->caps[4] & 0x20);
 
 	if (mt_count == 0)
@@ -2893,14 +2725,11 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 	if (MTBSF == mt_op || MTBSFM == mt_op) {
 		if (!sprev)
 			return -EIO;
-		mt_count = - mt_count;
+		mt_count = -mt_count;
 	}
 
-	if (tape->chrdev_direction == idetape_direction_read) {
-		/*
-		 *	We have a read-ahead buffer. Scan it for crossed
-		 *	filemarks.
-		 */
+	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
+		/* its a read-ahead buffer, scan it for crossed filemarks. */
 		tape->merge_stage_size = 0;
 		if (test_and_clear_bit(IDETAPE_FILEMARK, &tape->flags))
 			++count;
@@ -2910,24 +2739,27 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 					set_bit(IDETAPE_FILEMARK, &tape->flags);
 				return 0;
 			}
-			spin_lock_irqsave(&tape->spinlock, flags);
+			spin_lock_irqsave(&tape->lock, flags);
 			if (tape->first_stage == tape->active_stage) {
 				/*
-				 *	We have reached the active stage in the read pipeline.
-				 *	There is no point in allowing the drive to continue
-				 *	reading any farther, so we stop the pipeline.
+				 * We have reached the active stage in the read
+				 * pipeline. There is no point in allowing the
+				 * drive to continue reading any farther, so we
+				 * stop the pipeline.
 				 *
-				 *	This section should be moved to a separate subroutine,
-				 *	because a similar function is performed in
-				 *	__idetape_discard_read_pipeline(), for example.
+				 * This section should be moved to a separate
+				 * subroutine because similar operations are
+				 * done in __idetape_discard_read_pipeline(),
+				 * for example.
 				 */
 				tape->next_stage = NULL;
-				spin_unlock_irqrestore(&tape->spinlock, flags);
+				spin_unlock_irqrestore(&tape->lock, flags);
 				idetape_wait_first_stage(drive);
 				tape->next_stage = tape->first_stage->next;
 			} else
-				spin_unlock_irqrestore(&tape->spinlock, flags);
-			if (tape->first_stage->rq.errors == IDETAPE_ERROR_FILEMARK)
+				spin_unlock_irqrestore(&tape->lock, flags);
+			if (tape->first_stage->rq.errors ==
+					IDETAPE_ERROR_FILEMARK)
 				++count;
 			idetape_remove_stage_head(drive);
 		}
@@ -2935,73 +2767,74 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 	}
 
 	/*
-	 *	The filemark was not found in our internal pipeline.
-	 *	Now we can issue the space command.
+	 * The filemark was not found in our internal pipeline;	now we can issue
+	 * the space command.
 	 */
 	switch (mt_op) {
-		case MTFSF:
-		case MTBSF:
-			idetape_create_space_cmd(&pc,mt_count-count,IDETAPE_SPACE_OVER_FILEMARK);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTFSFM:
-		case MTBSFM:
-			if (!sprev)
-				return (-EIO);
-			retval = idetape_space_over_filemarks(drive, MTFSF, mt_count-count);
-			if (retval) return (retval);
-			count = (MTBSFM == mt_op ? 1 : -1);
-			return (idetape_space_over_filemarks(drive, MTFSF, count));
-		default:
-			printk(KERN_ERR "ide-tape: MTIO operation %d not supported\n",mt_op);
-			return (-EIO);
+	case MTFSF:
+	case MTBSF:
+		idetape_create_space_cmd(&pc, mt_count - count,
+					 IDETAPE_SPACE_OVER_FILEMARK);
+		return idetape_queue_pc_tail(drive, &pc);
+	case MTFSFM:
+	case MTBSFM:
+		if (!sprev)
+			return -EIO;
+		retval = idetape_space_over_filemarks(drive, MTFSF,
+						      mt_count - count);
+		if (retval)
+			return retval;
+		count = (MTBSFM == mt_op ? 1 : -1);
+		return idetape_space_over_filemarks(drive, MTFSF, count);
+	default:
+		printk(KERN_ERR "ide-tape: MTIO operation %d not supported\n",
+				mt_op);
+		return -EIO;
 	}
 }
 
-
 /*
- *	Our character device read / write functions.
+ * Our character device read / write functions.
  *
- *	The tape is optimized to maximize throughput when it is transferring
- *	an integral number of the "continuous transfer limit", which is
- *	a parameter of the specific tape (26 KB on my particular tape).
- *      (32 kB for Onstream)
+ * The tape is optimized to maximize throughput when it is transferring an
+ * integral number of the "continuous transfer limit", which is a parameter of
+ * the specific tape (26kB on my particular tape, 32kB for Onstream).
  *
- *	As of version 1.3 of the driver, the character device provides an
- *	abstract continuous view of the media - any mix of block sizes (even 1
- *	byte) on the same backup/restore procedure is supported. The driver
- *	will internally convert the requests to the recommended transfer unit,
- *	so that an unmatch between the user's block size to the recommended
- *	size will only result in a (slightly) increased driver overhead, but
- *	will no longer hit performance.
- *      This is not applicable to Onstream.
+ * As of version 1.3 of the driver, the character device provides an abstract
+ * continuous view of the media - any mix of block sizes (even 1 byte) on the
+ * same backup/restore procedure is supported. The driver will internally
+ * convert the requests to the recommended transfer unit, so that an unmatch
+ * between the user's block size to the recommended size will only result in a
+ * (slightly) increased driver overhead, but will no longer hit performance.
+ * This is not applicable to Onstream.
  */
-static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
-				    size_t count, loff_t *ppos)
+static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
+				   size_t count, loff_t *ppos)
 {
 	struct ide_tape_obj *tape = ide_tape_f(file);
 	ide_drive_t *drive = tape->drive;
-	ssize_t bytes_read,temp, actually_read = 0, rc;
+	ssize_t bytes_read, temp, actually_read = 0, rc;
 	ssize_t ret = 0;
 	u16 ctl = *(u16 *)&tape->caps[12];
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 3)
-		printk(KERN_INFO "ide-tape: Reached idetape_chrdev_read, count %Zd\n", count);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
-	if (tape->chrdev_direction != idetape_direction_read) {
+	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
 		if (test_bit(IDETAPE_DETECT_BS, &tape->flags))
-			if (count > tape->tape_block_size &&
-			    (count % tape->tape_block_size) == 0)
-				tape->user_bs_factor = count / tape->tape_block_size;
+			if (count > tape->blk_size &&
+			    (count % tape->blk_size) == 0)
+				tape->user_bs_factor = count / tape->blk_size;
 	}
-	if ((rc = idetape_initiate_read(drive, tape->max_stages)) < 0)
+	rc = idetape_init_read(drive, tape->max_stages);
+	if (rc < 0)
 		return rc;
 	if (count == 0)
 		return (0);
 	if (tape->merge_stage_size) {
-		actually_read = min((unsigned int)(tape->merge_stage_size), (unsigned int)count);
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, actually_read))
+		actually_read = min((unsigned int)(tape->merge_stage_size),
+				    (unsigned int)count);
+		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
+					       actually_read))
 			ret = -EFAULT;
 		buf += actually_read;
 		tape->merge_stage_size -= actually_read;
@@ -3011,7 +2844,8 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
 			goto finish;
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, bytes_read))
+		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
+					       bytes_read))
 			ret = -EFAULT;
 		buf += bytes_read;
 		count -= bytes_read;
@@ -3022,25 +2856,24 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 		if (bytes_read <= 0)
 			goto finish;
 		temp = min((unsigned long)count, (unsigned long)bytes_read);
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, temp))
+		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
+					       temp))
 			ret = -EFAULT;
 		actually_read += temp;
 		tape->merge_stage_size = bytes_read-temp;
 	}
 finish:
 	if (!actually_read && test_bit(IDETAPE_FILEMARK, &tape->flags)) {
-#if IDETAPE_DEBUG_LOG
-		if (tape->debug_level >= 2)
-			printk(KERN_INFO "ide-tape: %s: spacing over filemark\n", tape->name);
-#endif
+		debug_log(DBG_SENSE, "%s: spacing over filemark\n", tape->name);
+
 		idetape_space_over_filemarks(drive, MTFSF, 1);
 		return 0;
 	}
 
-	return (ret) ? ret : actually_read;
+	return ret ? ret : actually_read;
 }
 
-static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
+static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 				     size_t count, loff_t *ppos)
 {
 	struct ide_tape_obj *tape = ide_tape_f(file);
@@ -3053,39 +2886,37 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	if (tape->write_prot)
 		return -EACCES;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 3)
-		printk(KERN_INFO "ide-tape: Reached idetape_chrdev_write, "
-			"count %Zd\n", count);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	/* Initialize write operation */
-	if (tape->chrdev_direction != idetape_direction_write) {
-		if (tape->chrdev_direction == idetape_direction_read)
+	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
+		if (tape->chrdev_dir == IDETAPE_DIR_READ)
 			idetape_discard_read_pipeline(drive, 1);
 		if (tape->merge_stage || tape->merge_stage_size) {
 			printk(KERN_ERR "ide-tape: merge_stage_size "
 				"should be 0 now\n");
 			tape->merge_stage_size = 0;
 		}
-		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
+		tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0);
+		if (!tape->merge_stage)
 			return -ENOMEM;
-		tape->chrdev_direction = idetape_direction_write;
+		tape->chrdev_dir = IDETAPE_DIR_WRITE;
 		idetape_init_merge_stage(tape);
 
 		/*
-		 *	Issue a write 0 command to ensure that DSC handshake
-		 *	is switched from completion mode to buffer available
-		 *	mode.
-		 *	No point in issuing this if DSC overlap isn't supported,
-		 *	some drives (Seagate STT3401A) will return an error.
+		 * Issue a write 0 command to ensure that DSC handshake is
+		 * switched from completion mode to buffer available mode. No
+		 * point in issuing this if DSC overlap isn't supported, some
+		 * drives (Seagate STT3401A) will return an error.
 		 */
 		if (drive->dsc_overlap) {
-			ssize_t retval = idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, 0, tape->merge_stage->bh);
+			ssize_t retval = idetape_queue_rw_tail(drive,
+							REQ_IDETAPE_WRITE, 0,
+							tape->merge_stage->bh);
 			if (retval < 0) {
 				__idetape_kfree_stage(tape->merge_stage);
 				tape->merge_stage = NULL;
-				tape->chrdev_direction = idetape_direction_none;
+				tape->chrdev_dir = IDETAPE_DIR_NONE;
 				return retval;
 			}
 		}
@@ -3096,11 +2927,14 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 		idetape_restart_speed_control(drive);
 	if (tape->merge_stage_size) {
 		if (tape->merge_stage_size >= tape->stage_size) {
-			printk(KERN_ERR "ide-tape: bug: merge buffer too big\n");
+			printk(KERN_ERR "ide-tape: bug: merge buf too big\n");
 			tape->merge_stage_size = 0;
 		}
-		actually_written = min((unsigned int)(tape->stage_size - tape->merge_stage_size), (unsigned int)count);
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, actually_written))
+		actually_written = min((unsigned int)
+				(tape->stage_size - tape->merge_stage_size),
+				(unsigned int)count);
+		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
+						 actually_written))
 				ret = -EFAULT;
 		buf += actually_written;
 		tape->merge_stage_size += actually_written;
@@ -3116,7 +2950,8 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	}
 	while (count >= tape->stage_size) {
 		ssize_t retval;
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, tape->stage_size))
+		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
+						 tape->stage_size))
 			ret = -EFAULT;
 		buf += tape->stage_size;
 		count -= tape->stage_size;
@@ -3127,14 +2962,15 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	}
 	if (count) {
 		actually_written += count;
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, count))
+		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
+						 count))
 			ret = -EFAULT;
 		tape->merge_stage_size += count;
 	}
-	return (ret) ? ret : actually_written;
+	return ret ? ret : actually_written;
 }
 
-static int idetape_write_filemark (ide_drive_t *drive)
+static int idetape_write_filemark(ide_drive_t *drive)
 {
 	idetape_pc_t pc;
 
@@ -3165,113 +3001,117 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
-	int i,retval;
+	int i, retval;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 1)
-		printk(KERN_INFO "ide-tape: Handling MTIOCTOP ioctl: "
-			"mt_op=%d, mt_count=%d\n", mt_op, mt_count);
-#endif /* IDETAPE_DEBUG_LOG */
-	/*
-	 *	Commands which need our pipelined read-ahead stages.
-	 */
+	debug_log(DBG_ERR, "Handling MTIOCTOP ioctl: mt_op=%d, mt_count=%d\n",
+			mt_op, mt_count);
+
+	/* Commands which need our pipelined read-ahead stages. */
 	switch (mt_op) {
-		case MTFSF:
-		case MTFSFM:
-		case MTBSF:
-		case MTBSFM:
-			if (!mt_count)
-				return (0);
-			return (idetape_space_over_filemarks(drive,mt_op,mt_count));
-		default:
-			break;
+	case MTFSF:
+	case MTFSFM:
+	case MTBSF:
+	case MTBSFM:
+		if (!mt_count)
+			return 0;
+		return idetape_space_over_filemarks(drive, mt_op, mt_count);
+	default:
+		break;
 	}
+
 	switch (mt_op) {
-		case MTWEOF:
-			if (tape->write_prot)
-				return -EACCES;
-			idetape_discard_read_pipeline(drive, 1);
-			for (i = 0; i < mt_count; i++) {
-				retval = idetape_write_filemark(drive);
-				if (retval)
-					return retval;
-			}
-			return (0);
-		case MTREW:
-			idetape_discard_read_pipeline(drive, 0);
-			if (idetape_rewind_tape(drive))
+	case MTWEOF:
+		if (tape->write_prot)
+			return -EACCES;
+		idetape_discard_read_pipeline(drive, 1);
+		for (i = 0; i < mt_count; i++) {
+			retval = idetape_write_filemark(drive);
+			if (retval)
+				return retval;
+		}
+		return 0;
+	case MTREW:
+		idetape_discard_read_pipeline(drive, 0);
+		if (idetape_rewind_tape(drive))
+			return -EIO;
+		return 0;
+	case MTLOAD:
+		idetape_discard_read_pipeline(drive, 0);
+		idetape_create_load_unload_cmd(drive, &pc,
+					       IDETAPE_LU_LOAD_MASK);
+		return idetape_queue_pc_tail(drive, &pc);
+	case MTUNLOAD:
+	case MTOFFL:
+		/*
+		 * If door is locked, attempt to unlock before
+		 * attempting to eject.
+		 */
+		if (tape->door_locked) {
+			if (idetape_create_prevent_cmd(drive, &pc, 0))
+				if (!idetape_queue_pc_tail(drive, &pc))
+					tape->door_locked = DOOR_UNLOCKED;
+		}
+		idetape_discard_read_pipeline(drive, 0);
+		idetape_create_load_unload_cmd(drive, &pc,
+					      !IDETAPE_LU_LOAD_MASK);
+		retval = idetape_queue_pc_tail(drive, &pc);
+		if (!retval)
+			clear_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags);
+		return retval;
+	case MTNOP:
+		idetape_discard_read_pipeline(drive, 0);
+		return idetape_flush_tape_buffers(drive);
+	case MTRETEN:
+		idetape_discard_read_pipeline(drive, 0);
+		idetape_create_load_unload_cmd(drive, &pc,
+			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
+		return idetape_queue_pc_tail(drive, &pc);
+	case MTEOM:
+		idetape_create_space_cmd(&pc, 0, IDETAPE_SPACE_TO_EOD);
+		return idetape_queue_pc_tail(drive, &pc);
+	case MTERASE:
+		(void)idetape_rewind_tape(drive);
+		idetape_create_erase_cmd(&pc);
+		return idetape_queue_pc_tail(drive, &pc);
+	case MTSETBLK:
+		if (mt_count) {
+			if (mt_count < tape->blk_size ||
+			    mt_count % tape->blk_size)
 				return -EIO;
+			tape->user_bs_factor = mt_count / tape->blk_size;
+			clear_bit(IDETAPE_DETECT_BS, &tape->flags);
+		} else
+			set_bit(IDETAPE_DETECT_BS, &tape->flags);
+		return 0;
+	case MTSEEK:
+		idetape_discard_read_pipeline(drive, 0);
+		return idetape_position_tape(drive,
+			mt_count * tape->user_bs_factor, tape->partition, 0);
+	case MTSETPART:
+		idetape_discard_read_pipeline(drive, 0);
+		return idetape_position_tape(drive, 0, mt_count, 0);
+	case MTFSR:
+	case MTBSR:
+	case MTLOCK:
+		if (!idetape_create_prevent_cmd(drive, &pc, 1))
 			return 0;
-		case MTLOAD:
-			idetape_discard_read_pipeline(drive, 0);
-			idetape_create_load_unload_cmd(drive, &pc, IDETAPE_LU_LOAD_MASK);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTUNLOAD:
-		case MTOFFL:
-			/*
-			 * If door is locked, attempt to unlock before
-			 * attempting to eject.
-			 */
-			if (tape->door_locked) {
-				if (idetape_create_prevent_cmd(drive, &pc, 0))
-					if (!idetape_queue_pc_tail(drive, &pc))
-						tape->door_locked = DOOR_UNLOCKED;
-			}
-			idetape_discard_read_pipeline(drive, 0);
-			idetape_create_load_unload_cmd(drive, &pc,!IDETAPE_LU_LOAD_MASK);
-			retval = idetape_queue_pc_tail(drive, &pc);
-			if (!retval)
-				clear_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags);
+		retval = idetape_queue_pc_tail(drive, &pc);
+		if (retval)
 			return retval;
-		case MTNOP:
-			idetape_discard_read_pipeline(drive, 0);
-			return (idetape_flush_tape_buffers(drive));
-		case MTRETEN:
-			idetape_discard_read_pipeline(drive, 0);
-			idetape_create_load_unload_cmd(drive, &pc,IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTEOM:
-			idetape_create_space_cmd(&pc, 0, IDETAPE_SPACE_TO_EOD);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTERASE:
-			(void) idetape_rewind_tape(drive);
-			idetape_create_erase_cmd(&pc);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTSETBLK:
-			if (mt_count) {
-				if (mt_count < tape->tape_block_size || mt_count % tape->tape_block_size)
-					return -EIO;
-				tape->user_bs_factor = mt_count / tape->tape_block_size;
-				clear_bit(IDETAPE_DETECT_BS, &tape->flags);
-			} else
-				set_bit(IDETAPE_DETECT_BS, &tape->flags);
-			return 0;
-		case MTSEEK:
-			idetape_discard_read_pipeline(drive, 0);
-			return idetape_position_tape(drive, mt_count * tape->user_bs_factor, tape->partition, 0);
-		case MTSETPART:
-			idetape_discard_read_pipeline(drive, 0);
-			return (idetape_position_tape(drive, 0, mt_count, 0));
-		case MTFSR:
-		case MTBSR:
-		case MTLOCK:
-			if (!idetape_create_prevent_cmd(drive, &pc, 1))
-				return 0;
-			retval = idetape_queue_pc_tail(drive, &pc);
-			if (retval) return retval;
-			tape->door_locked = DOOR_EXPLICITLY_LOCKED;
-			return 0;
-		case MTUNLOCK:
-			if (!idetape_create_prevent_cmd(drive, &pc, 0))
-				return 0;
-			retval = idetape_queue_pc_tail(drive, &pc);
-			if (retval) return retval;
-			tape->door_locked = DOOR_UNLOCKED;
+		tape->door_locked = DOOR_EXPLICITLY_LOCKED;
+		return 0;
+	case MTUNLOCK:
+		if (!idetape_create_prevent_cmd(drive, &pc, 0))
 			return 0;
-		default:
-			printk(KERN_ERR "ide-tape: MTIO operation %d not "
-				"supported\n", mt_op);
-			return (-EIO);
+		retval = idetape_queue_pc_tail(drive, &pc);
+		if (retval)
+			return retval;
+		tape->door_locked = DOOR_UNLOCKED;
+		return 0;
+	default:
+		printk(KERN_ERR "ide-tape: MTIO operation %d not supported\n",
+				mt_op);
+		return -EIO;
 	}
 }
 
@@ -3288,50 +3128,51 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 	struct mtop mtop;
 	struct mtget mtget;
 	struct mtpos mtpos;
-	int block_offset = 0, position = tape->first_frame_position;
+	int block_offset = 0, position = tape->first_frame;
 	void __user *argp = (void __user *)arg;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 3)
-		printk(KERN_INFO "ide-tape: Reached idetape_chrdev_ioctl, "
-			"cmd=%u\n", cmd);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_CHRDEV, "Enter %s, cmd=%u\n", __func__, cmd);
 
 	tape->restart_speed_control_req = 1;
-	if (tape->chrdev_direction == idetape_direction_write) {
+	if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
 		idetape_empty_write_pipeline(drive);
 		idetape_flush_tape_buffers(drive);
 	}
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
-		block_offset = idetape_pipeline_size(drive) / (tape->tape_block_size * tape->user_bs_factor);
-		if ((position = idetape_read_position(drive)) < 0)
+		block_offset = idetape_pipeline_size(drive) /
+			(tape->blk_size * tape->user_bs_factor);
+		position = idetape_read_position(drive);
+		if (position < 0)
 			return -EIO;
 	}
 	switch (cmd) {
-		case MTIOCTOP:
-			if (copy_from_user(&mtop, argp, sizeof (struct mtop)))
-				return -EFAULT;
-			return (idetape_mtioctop(drive,mtop.mt_op,mtop.mt_count));
-		case MTIOCGET:
-			memset(&mtget, 0, sizeof (struct mtget));
-			mtget.mt_type = MT_ISSCSI2;
-			mtget.mt_blkno = position / tape->user_bs_factor - block_offset;
-			mtget.mt_dsreg = ((tape->tape_block_size * tape->user_bs_factor) << MT_ST_BLKSIZE_SHIFT) & MT_ST_BLKSIZE_MASK;
-			if (tape->drv_write_prot) {
-				mtget.mt_gstat |= GMT_WR_PROT(0xffffffff);
-			}
-			if (copy_to_user(argp, &mtget, sizeof(struct mtget)))
-				return -EFAULT;
-			return 0;
-		case MTIOCPOS:
-			mtpos.mt_blkno = position / tape->user_bs_factor - block_offset;
-			if (copy_to_user(argp, &mtpos, sizeof(struct mtpos)))
-				return -EFAULT;
-			return 0;
-		default:
-			if (tape->chrdev_direction == idetape_direction_read)
-				idetape_discard_read_pipeline(drive, 1);
-			return idetape_blkdev_ioctl(drive, cmd, arg);
+	case MTIOCTOP:
+		if (copy_from_user(&mtop, argp, sizeof(struct mtop)))
+			return -EFAULT;
+		return idetape_mtioctop(drive, mtop.mt_op, mtop.mt_count);
+	case MTIOCGET:
+		memset(&mtget, 0, sizeof(struct mtget));
+		mtget.mt_type = MT_ISSCSI2;
+		mtget.mt_blkno = position / tape->user_bs_factor - block_offset;
+		mtget.mt_dsreg =
+			((tape->blk_size * tape->user_bs_factor)
+			 << MT_ST_BLKSIZE_SHIFT) & MT_ST_BLKSIZE_MASK;
+
+		if (tape->drv_write_prot)
+			mtget.mt_gstat |= GMT_WR_PROT(0xffffffff);
+
+		if (copy_to_user(argp, &mtget, sizeof(struct mtget)))
+			return -EFAULT;
+		return 0;
+	case MTIOCPOS:
+		mtpos.mt_blkno = position / tape->user_bs_factor - block_offset;
+		if (copy_to_user(argp, &mtpos, sizeof(struct mtpos)))
+			return -EFAULT;
+		return 0;
+	default:
+		if (tape->chrdev_dir == IDETAPE_DIR_READ)
+			idetape_discard_read_pipeline(drive, 1);
+		return idetape_blkdev_ioctl(drive, cmd, arg);
 	}
 }
 
@@ -3347,23 +3188,20 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
 	if (idetape_queue_pc_tail(drive, &pc)) {
 		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
-		if (tape->tape_block_size == 0) {
+		if (tape->blk_size == 0) {
 			printk(KERN_WARNING "ide-tape: Cannot deal with zero "
 					    "block size, assuming 32k\n");
-			tape->tape_block_size = 32768;
+			tape->blk_size = 32768;
 		}
 		return;
 	}
-	tape->tape_block_size = (pc.buffer[4 + 5] << 16) +
+	tape->blk_size = (pc.buffer[4 + 5] << 16) +
 				(pc.buffer[4 + 6] << 8)  +
 				 pc.buffer[4 + 7];
 	tape->drv_write_prot = (pc.buffer[2] & 0x80) >> 7;
 }
 
-/*
- *	Our character device open function.
- */
-static int idetape_chrdev_open (struct inode *inode, struct file *filp)
+static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 {
 	unsigned int minor = iminor(inode), i = minor & ~0xc0;
 	ide_drive_t *drive;
@@ -3371,6 +3209,15 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	idetape_pc_t pc;
 	int retval;
 
+	if (i >= MAX_HWIFS * MAX_DRIVES)
+		return -ENXIO;
+
+	tape = ide_tape_chrdev_get(i);
+	if (!tape)
+		return -ENXIO;
+
+	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
+
 	/*
 	 * We really want to do nonseekable_open(inode, filp); here, but some
 	 * versions of tar incorrectly call lseek on tapes and bail out if that
@@ -3378,16 +3225,6 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	 */
 	filp->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
 
-#if IDETAPE_DEBUG_LOG
-	printk(KERN_INFO "ide-tape: Reached idetape_chrdev_open\n");
-#endif /* IDETAPE_DEBUG_LOG */
-	
-	if (i >= MAX_HWIFS * MAX_DRIVES)
-		return -ENXIO;
-
-	if (!(tape = ide_tape_chrdev_get(i)))
-		return -ENXIO;
-
 	drive = tape->drive;
 
 	filp->private_data = tape;
@@ -3408,7 +3245,7 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	if (!test_bit(IDETAPE_ADDRESS_VALID, &tape->flags))
 		(void)idetape_rewind_tape(drive);
 
-	if (tape->chrdev_direction != idetape_direction_read)
+	if (tape->chrdev_dir != IDETAPE_DIR_READ)
 		clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
 
 	/* Read block size and write protect status from drive. */
@@ -3430,10 +3267,8 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 		}
 	}
 
-	/*
-	 * Lock the tape drive door so user can't eject.
-	 */
-	if (tape->chrdev_direction == idetape_direction_none) {
+	/* Lock the tape drive door so user can't eject. */
+	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
 		if (idetape_create_prevent_cmd(drive, &pc, 1)) {
 			if (!idetape_queue_pc_tail(drive, &pc)) {
 				if (tape->door_locked != DOOR_EXPLICITLY_LOCKED)
@@ -3450,14 +3285,15 @@ out_put_tape:
 	return retval;
 }
 
-static void idetape_write_release (ide_drive_t *drive, unsigned int minor)
+static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
 	idetape_empty_write_pipeline(drive);
 	tape->merge_stage = __idetape_kmalloc_stage(tape, 1, 0);
 	if (tape->merge_stage != NULL) {
-		idetape_pad_zeros(drive, tape->tape_block_size * (tape->user_bs_factor - 1));
+		idetape_pad_zeros(drive, tape->blk_size *
+				(tape->user_bs_factor - 1));
 		__idetape_kfree_stage(tape->merge_stage);
 		tape->merge_stage = NULL;
 	}
@@ -3466,10 +3302,7 @@ static void idetape_write_release (ide_drive_t *drive, unsigned int minor)
 	idetape_flush_tape_buffers(drive);
 }
 
-/*
- *	Our character device release function.
- */
-static int idetape_chrdev_release (struct inode *inode, struct file *filp)
+static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 {
 	struct ide_tape_obj *tape = ide_tape_f(filp);
 	ide_drive_t *drive = tape->drive;
@@ -3478,14 +3311,12 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 
 	lock_kernel();
 	tape = drive->driver_data;
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 3)
-		printk(KERN_INFO "ide-tape: Reached idetape_chrdev_release\n");
-#endif /* IDETAPE_DEBUG_LOG */
 
-	if (tape->chrdev_direction == idetape_direction_write)
+	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
+
+	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
 		idetape_write_release(drive, minor);
-	if (tape->chrdev_direction == idetape_direction_read) {
+	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
 		if (minor < 128)
 			idetape_discard_read_pipeline(drive, 1);
 		else
@@ -3497,7 +3328,7 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 	}
 	if (minor < 128 && test_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags))
 		(void) idetape_rewind_tape(drive);
-	if (tape->chrdev_direction == idetape_direction_none) {
+	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
 		if (tape->door_locked == DOOR_LOCKED) {
 			if (idetape_create_prevent_cmd(drive, &pc, 0)) {
 				if (!idetape_queue_pc_tail(drive, &pc))
@@ -3512,37 +3343,39 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 }
 
 /*
- *	idetape_identify_device is called to check the contents of the
- *	ATAPI IDENTIFY command results. We return:
+ * check the contents of the ATAPI IDENTIFY command results. We return:
  *
- *	1	If the tape can be supported by us, based on the information
- *		we have so far.
+ * 1 - If the tape can be supported by us, based on the information we have so
+ * far.
  *
- *	0 	If this tape driver is not currently supported by us.
+ * 0 - If this tape driver is not currently supported by us.
  */
-static int idetape_identify_device (ide_drive_t *drive)
+static int idetape_identify_device(ide_drive_t *drive)
 {
-	struct idetape_id_gcw gcw;
-	struct hd_driveid *id = drive->id;
+	u8 gcw[2], protocol, device_type, removable, packet_size;
 
 	if (drive->id_read == 0)
 		return 1;
 
-	*((unsigned short *) &gcw) = id->config;
+	*((unsigned short *) &gcw) = drive->id->config;
+
+	protocol	=   (gcw[1] & 0xC0) >> 6;
+	device_type	=    gcw[1] & 0x1F;
+	removable	= !!(gcw[0] & 0x80);
+	packet_size	=    gcw[0] & 0x3;
 
 	/* Check that we can support this device */
-
-	if (gcw.protocol != 2)
+	if (protocol != 2)
 		printk(KERN_ERR "ide-tape: Protocol (0x%02x) is not ATAPI\n",
-				gcw.protocol);
-	else if (gcw.device_type != 1)
+				protocol);
+	else if (device_type != 1)
 		printk(KERN_ERR "ide-tape: Device type (0x%02x) is not set "
-				"to tape\n", gcw.device_type);
-	else if (!gcw.removable)
+				"to tape\n", device_type);
+	else if (!removable)
 		printk(KERN_ERR "ide-tape: The removable flag is not set\n");
-	else if (gcw.packet_size != 0) {
-		printk(KERN_ERR "ide-tape: Packet size (0x%02x) is not 12 "
-				"bytes long\n", gcw.packet_size);
+	else if (packet_size != 0) {
+		printk(KERN_ERR "ide-tape: Packet size (0x%02x) is not 12"
+				" bytes\n", packet_size);
 	} else
 		return 1;
 	return 0;
@@ -3550,9 +3383,9 @@ static int idetape_identify_device (ide_drive_t *drive)
 
 static void idetape_get_inquiry_results(ide_drive_t *drive)
 {
-	char *r;
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
+	char fw_rev[6], vendor_id[10], product_id[18];
 
 	idetape_create_inquiry_cmd(&pc);
 	if (idetape_queue_pc_tail(drive, &pc)) {
@@ -3560,27 +3393,23 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 				tape->name);
 		return;
 	}
-	memcpy(tape->vendor_id, &pc.buffer[8], 8);
-	memcpy(tape->product_id, &pc.buffer[16], 16);
-	memcpy(tape->firmware_revision, &pc.buffer[32], 4);
-
-	ide_fixstring(tape->vendor_id, 10, 0);
-	ide_fixstring(tape->product_id, 18, 0);
-	ide_fixstring(tape->firmware_revision, 6, 0);
-	r = tape->firmware_revision;
-	if (*(r + 1) == '.')
-		tape->firmware_revision_num = (*r - '0') * 100 +
-			(*(r + 2) - '0') * 10 +	*(r + 3) - '0';
+	memcpy(vendor_id, &pc.buffer[8], 8);
+	memcpy(product_id, &pc.buffer[16], 16);
+	memcpy(fw_rev, &pc.buffer[32], 4);
+
+	ide_fixstring(vendor_id, 10, 0);
+	ide_fixstring(product_id, 18, 0);
+	ide_fixstring(fw_rev, 6, 0);
+
 	printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n",
-			drive->name, tape->name, tape->vendor_id,
-			tape->product_id, tape->firmware_revision);
+			drive->name, tape->name, vendor_id, product_id, fw_rev);
 }
 
 /*
  * Ask the tape about its various parameters. In particular, we will adjust our
  * data transfer buffer	size to the recommended value as returned by the tape.
  */
-static void idetape_get_mode_sense_results (ide_drive_t *drive)
+static void idetape_get_mode_sense_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
@@ -3591,7 +3420,7 @@ static void idetape_get_mode_sense_results (ide_drive_t *drive)
 	if (idetape_queue_pc_tail(drive, &pc)) {
 		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming"
 				" some default values\n");
-		tape->tape_block_size = 512;
+		tape->blk_size = 512;
 		put_unaligned(52,   (u16 *)&tape->caps[12]);
 		put_unaligned(540,  (u16 *)&tape->caps[14]);
 		put_unaligned(6*52, (u16 *)&tape->caps[16]);
@@ -3621,62 +3450,75 @@ static void idetape_get_mode_sense_results (ide_drive_t *drive)
 
 	memcpy(&tape->caps, caps, 20);
 	if (caps[7] & 0x02)
-		tape->tape_block_size = 512;
+		tape->blk_size = 512;
 	else if (caps[7] & 0x04)
-		tape->tape_block_size = 1024;
+		tape->blk_size = 1024;
 }
 
 #ifdef CONFIG_IDE_PROC_FS
-static void idetape_add_settings (ide_drive_t *drive)
+static void idetape_add_settings(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-/*
- *			drive	setting name		read/write	data type	min			max			mul_factor			div_factor	data pointer				set function
- */
 	ide_add_setting(drive, "buffer", SETTING_READ, TYPE_SHORT, 0, 0xffff,
 			1, 2, (u16 *)&tape->caps[16], NULL);
-	ide_add_setting(drive,	"pipeline_min",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->min_pipeline,			NULL);
-	ide_add_setting(drive,	"pipeline",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->max_stages,			NULL);
-	ide_add_setting(drive,	"pipeline_max",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->max_pipeline,			NULL);
-	ide_add_setting(drive,	"pipeline_used",	SETTING_READ,	TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,		&tape->nr_stages,			NULL);
-	ide_add_setting(drive,	"pipeline_pending",	SETTING_READ,	TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,		&tape->nr_pending_stages,		NULL);
+	ide_add_setting(drive, "pipeline_min", SETTING_RW, TYPE_INT, 1, 0xffff,
+			tape->stage_size / 1024, 1, &tape->min_pipeline, NULL);
+	ide_add_setting(drive, "pipeline", SETTING_RW, TYPE_INT, 1, 0xffff,
+			tape->stage_size / 1024, 1, &tape->max_stages, NULL);
+	ide_add_setting(drive, "pipeline_max", SETTING_RW, TYPE_INT, 1,	0xffff,
+			tape->stage_size / 1024, 1, &tape->max_pipeline, NULL);
+	ide_add_setting(drive, "pipeline_used",	SETTING_READ, TYPE_INT, 0,
+			0xffff,	tape->stage_size / 1024, 1, &tape->nr_stages,
+			NULL);
+	ide_add_setting(drive, "pipeline_pending", SETTING_READ, TYPE_INT, 0,
+			0xffff, tape->stage_size / 1024, 1,
+			&tape->nr_pending_stages, NULL);
 	ide_add_setting(drive, "speed", SETTING_READ, TYPE_SHORT, 0, 0xffff,
 			1, 1, (u16 *)&tape->caps[14], NULL);
-	ide_add_setting(drive,	"stage",		SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1024,		&tape->stage_size,			NULL);
-	ide_add_setting(drive,	"tdsc",			SETTING_RW,	TYPE_INT,	IDETAPE_DSC_RW_MIN,	IDETAPE_DSC_RW_MAX,	1000,				HZ,		&tape->best_dsc_rw_frequency,		NULL);
-	ide_add_setting(drive,	"dsc_overlap",		SETTING_RW,	TYPE_BYTE,	0,			1,			1,				1,		&drive->dsc_overlap,			NULL);
-	ide_add_setting(drive,	"pipeline_head_speed_c",SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->controlled_pipeline_head_speed,	NULL);
-	ide_add_setting(drive,	"pipeline_head_speed_u",SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->uncontrolled_pipeline_head_speed,NULL);
-	ide_add_setting(drive,	"avg_speed",		SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->avg_speed,			NULL);
-	ide_add_setting(drive,	"debug_level",		SETTING_RW,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->debug_level,			NULL);
+	ide_add_setting(drive, "stage", SETTING_READ, TYPE_INT,	0, 0xffff, 1,
+			1024, &tape->stage_size, NULL);
+	ide_add_setting(drive, "tdsc", SETTING_RW, TYPE_INT, IDETAPE_DSC_RW_MIN,
+			IDETAPE_DSC_RW_MAX, 1000, HZ, &tape->best_dsc_rw_freq,
+			NULL);
+	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0, 1, 1,
+			1, &drive->dsc_overlap, NULL);
+	ide_add_setting(drive, "pipeline_head_speed_c", SETTING_READ, TYPE_INT,
+			0, 0xffff, 1, 1, &tape->controlled_pipeline_head_speed,
+			NULL);
+	ide_add_setting(drive, "pipeline_head_speed_u", SETTING_READ, TYPE_INT,
+			0, 0xffff, 1, 1,
+			&tape->uncontrolled_pipeline_head_speed, NULL);
+	ide_add_setting(drive, "avg_speed", SETTING_READ, TYPE_INT, 0, 0xffff,
+			1, 1, &tape->avg_speed, NULL);
+	ide_add_setting(drive, "debug_mask", SETTING_RW, TYPE_INT, 0, 0xffff, 1,
+			1, &tape->debug_mask, NULL);
 }
 #else
 static inline void idetape_add_settings(ide_drive_t *drive) { ; }
 #endif
 
 /*
- *	ide_setup is called to:
+ * The function below is called to:
  *
- *		1.	Initialize our various state variables.
- *		2.	Ask the tape for its capabilities.
- *		3.	Allocate a buffer which will be used for data
- *			transfer. The buffer size is chosen based on
- *			the recommendation which we received in step (2).
+ * 1. Initialize our various state variables.
+ * 2. Ask the tape for its capabilities.
+ * 3. Allocate a buffer which will be used for data transfer. The buffer size
+ * is chosen based on the recommendation which we received in step 2.
  *
- *	Note that at this point ide.c already assigned us an irq, so that
- *	we can queue requests here and wait for their completion.
+ * Note that at this point ide.c already assigned us an irq, so that we can
+ * queue requests here and wait for their completion.
  */
-static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
+static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 {
 	unsigned long t1, tmid, tn, t;
 	int speed;
-	struct idetape_id_gcw gcw;
 	int stage_size;
+	u8 gcw[2];
 	struct sysinfo si;
 	u16 *ctl = (u16 *)&tape->caps[12];
 
-	spin_lock_init(&tape->spinlock);
+	spin_lock_init(&tape->lock);
 	drive->dsc_overlap = 1;
 	if (drive->hwif->host_flags & IDE_HFLAG_NO_DSC) {
 		printk(KERN_INFO "ide-tape: %s: disabling DSC overlap\n",
@@ -3690,25 +3532,29 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	tape->name[0] = 'h';
 	tape->name[1] = 't';
 	tape->name[2] = '0' + minor;
-	tape->chrdev_direction = idetape_direction_none;
+	tape->chrdev_dir = IDETAPE_DIR_NONE;
 	tape->pc = tape->pc_stack;
 	tape->max_insert_speed = 10000;
 	tape->speed_control = 1;
 	*((unsigned short *) &gcw) = drive->id->config;
-	if (gcw.drq_type == 1)
+
+	/* Command packet DRQ type */
+	if (((gcw[0] & 0x60) >> 5) == 1)
 		set_bit(IDETAPE_DRQ_INTERRUPT, &tape->flags);
 
-	tape->min_pipeline = tape->max_pipeline = tape->max_stages = 10;
-	
+	tape->min_pipeline = 10;
+	tape->max_pipeline = 10;
+	tape->max_stages   = 10;
+
 	idetape_get_inquiry_results(drive);
 	idetape_get_mode_sense_results(drive);
 	ide_tape_get_bsize_from_bdesc(drive);
 	tape->user_bs_factor = 1;
-	tape->stage_size = *ctl * tape->tape_block_size;
+	tape->stage_size = *ctl * tape->blk_size;
 	while (tape->stage_size > 0xffff) {
 		printk(KERN_NOTICE "ide-tape: decreasing stage size\n");
 		*ctl /= 2;
-		tape->stage_size = *ctl * tape->tape_block_size;
+		tape->stage_size = *ctl * tape->blk_size;
 	}
 	stage_size = tape->stage_size;
 	tape->pages_per_stage = stage_size / PAGE_SIZE;
@@ -3722,17 +3568,22 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 
 	tape->max_stages = speed * 1000 * 10 / tape->stage_size;
 
-	/*
-	 * 	Limit memory use for pipeline to 10% of physical memory
-	 */
+	/* Limit memory use for pipeline to 10% of physical memory */
 	si_meminfo(&si);
-	if (tape->max_stages * tape->stage_size > si.totalram * si.mem_unit / 10)
-		tape->max_stages = si.totalram * si.mem_unit / (10 * tape->stage_size);
+	if (tape->max_stages * tape->stage_size >
+			si.totalram * si.mem_unit / 10)
+		tape->max_stages =
+			si.totalram * si.mem_unit / (10 * tape->stage_size);
+
 	tape->max_stages   = min(tape->max_stages, IDETAPE_MAX_PIPELINE_STAGES);
 	tape->min_pipeline = min(tape->max_stages, IDETAPE_MIN_PIPELINE_STAGES);
-	tape->max_pipeline = min(tape->max_stages * 2, IDETAPE_MAX_PIPELINE_STAGES);
-	if (tape->max_stages == 0)
-		tape->max_stages = tape->min_pipeline = tape->max_pipeline = 1;
+	tape->max_pipeline =
+		min(tape->max_stages * 2, IDETAPE_MAX_PIPELINE_STAGES);
+	if (tape->max_stages == 0) {
+		tape->max_stages   = 1;
+		tape->min_pipeline = 1;
+		tape->max_pipeline = 1;
+	}
 
 	t1 = (tape->stage_size * HZ) / (speed * 1000);
 	tmid = (*(u16 *)&tape->caps[16] * 32 * HZ) / (speed * 125);
@@ -3744,17 +3595,19 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		t = t1;
 
 	/*
-	 *	Ensure that the number we got makes sense; limit
-	 *	it within IDETAPE_DSC_RW_MIN and IDETAPE_DSC_RW_MAX.
+	 * Ensure that the number we got makes sense; limit it within
+	 * IDETAPE_DSC_RW_MIN and IDETAPE_DSC_RW_MAX.
 	 */
-	tape->best_dsc_rw_frequency = max_t(unsigned long, min_t(unsigned long, t, IDETAPE_DSC_RW_MAX), IDETAPE_DSC_RW_MIN);
+	tape->best_dsc_rw_freq = max_t(unsigned long,
+				min_t(unsigned long, t, IDETAPE_DSC_RW_MAX),
+				IDETAPE_DSC_RW_MIN);
 	printk(KERN_INFO "ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, "
 		"%dkB pipeline, %lums tDSC%s\n",
 		drive->name, tape->name, *(u16 *)&tape->caps[14],
 		(*(u16 *)&tape->caps[16] * 512) / tape->stage_size,
 		tape->stage_size / 1024,
 		tape->max_stages * tape->stage_size / 1024,
-		tape->best_dsc_rw_frequency * 1000 / HZ,
+		tape->best_dsc_rw_freq * 1000 / HZ,
 		drive->using_dma ? ", DMA":"");
 
 	idetape_add_settings(drive);
@@ -3782,7 +3635,8 @@ static void ide_tape_release(struct kref *kref)
 	drive->dsc_overlap = 0;
 	drive->driver_data = NULL;
 	device_destroy(idetape_sysfs_class, MKDEV(IDETAPE_MAJOR, tape->minor));
-	device_destroy(idetape_sysfs_class, MKDEV(IDETAPE_MAJOR, tape->minor + 128));
+	device_destroy(idetape_sysfs_class,
+			MKDEV(IDETAPE_MAJOR, tape->minor + 128));
 	idetape_devs[tape->minor] = NULL;
 	g->private_data = NULL;
 	put_disk(g);
@@ -3831,9 +3685,7 @@ static ide_driver_t idetape_driver = {
 #endif
 };
 
-/*
- *	Our character device supporting functions, passed to register_chrdev.
- */
+/* Our character device supporting functions, passed to register_chrdev. */
 static const struct file_operations idetape_fops = {
 	.owner		= THIS_MODULE,
 	.read		= idetape_chrdev_read,
@@ -3848,7 +3700,8 @@ static int idetape_open(struct inode *inode, struct file *filp)
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct ide_tape_obj *tape;
 
-	if (!(tape = ide_tape_get(disk)))
+	tape = ide_tape_get(disk);
+	if (!tape)
 		return -ENXIO;
 
 	return 0;
@@ -3895,21 +3748,20 @@ static int ide_tape_probe(ide_drive_t *drive)
 		goto failed;
 	if (drive->media != ide_tape)
 		goto failed;
-	if (!idetape_identify_device (drive)) {
-		printk(KERN_ERR "ide-tape: %s: not supported by this version of ide-tape\n", drive->name);
+	if (!idetape_identify_device(drive)) {
+		printk(KERN_ERR "ide-tape: %s: not supported by this version of"
+				" the driver\n", drive->name);
 		goto failed;
 	}
 	if (drive->scsi) {
-		printk("ide-tape: passing drive %s to ide-scsi emulation.\n", drive->name);
+		printk(KERN_INFO "ide-tape: passing drive %s to ide-scsi"
+				 " emulation.\n", drive->name);
 		goto failed;
 	}
-	if (strstr(drive->id->model, "OnStream DI-")) {
-		printk(KERN_WARNING "ide-tape: Use drive %s with ide-scsi emulation and osst.\n", drive->name);
-		printk(KERN_WARNING "ide-tape: OnStream support will be removed soon from ide-tape!\n");
-	}
-	tape = kzalloc(sizeof (idetape_tape_t), GFP_KERNEL);
+	tape = kzalloc(sizeof(idetape_tape_t), GFP_KERNEL);
 	if (tape == NULL) {
-		printk(KERN_ERR "ide-tape: %s: Can't allocate a tape structure\n", drive->name);
+		printk(KERN_ERR "ide-tape: %s: Can't allocate a tape struct\n",
+				drive->name);
 		goto failed;
 	}
 
@@ -3955,10 +3807,7 @@ failed:
 	return -ENODEV;
 }
 
-MODULE_DESCRIPTION("ATAPI Streaming TAPE Driver");
-MODULE_LICENSE("GPL");
-
-static void __exit idetape_exit (void)
+static void __exit idetape_exit(void)
 {
 	driver_unregister(&idetape_driver.gen_driver);
 	class_destroy(idetape_sysfs_class);
@@ -3977,7 +3826,8 @@ static int __init idetape_init(void)
 	}
 
 	if (register_chrdev(IDETAPE_MAJOR, "ht", &idetape_fops)) {
-		printk(KERN_ERR "ide-tape: Failed to register character device interface\n");
+		printk(KERN_ERR "ide-tape: Failed to register chrdev"
+				" interface\n");
 		error = -EBUSY;
 		goto out_free_class;
 	}
@@ -4000,3 +3850,5 @@ MODULE_ALIAS("ide:*m-tape*");
 module_init(idetape_init);
 module_exit(idetape_exit);
 MODULE_ALIAS_CHARDEV_MAJOR(IDETAPE_MAJOR);
+MODULE_DESCRIPTION("ATAPI Streaming TAPE Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 4e1da1c..0518a2e 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -189,12 +189,11 @@ EXPORT_SYMBOL_GPL(do_rw_taskfile);
  */
 static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-	u8 stat;
+	u8 stat = ide_read_status(drive);
 
-	if (OK_STAT(stat = hwif->INB(IDE_STATUS_REG),READY_STAT,BAD_STAT)) {
+	if (OK_STAT(stat, READY_STAT, BAD_STAT))
 		drive->mult_count = drive->mult_req;
-	} else {
+	else {
 		drive->mult_req = drive->mult_count = 0;
 		drive->special.b.recalibrate = 1;
 		(void) ide_dump_status(drive, "set_multmode", stat);
@@ -207,11 +206,10 @@ static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
  */
 static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
 	int retries = 5;
 	u8 stat;
 
-	while (((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) && retries--)
+	while (((stat = ide_read_status(drive)) & BUSY_STAT) && retries--)
 		udelay(10);
 
 	if (OK_STAT(stat, READY_STAT, BAD_STAT))
@@ -230,10 +228,9 @@ static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
  */
 static ide_startstop_t recal_intr(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-	u8 stat;
+	u8 stat = ide_read_status(drive);
 
-	if (!OK_STAT(stat = hwif->INB(IDE_STATUS_REG), READY_STAT, BAD_STAT))
+	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_error(drive, "recal_intr", stat);
 	return ide_stopped;
 }
@@ -244,23 +241,23 @@ static ide_startstop_t recal_intr(ide_drive_t *drive)
 static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 {
 	ide_task_t *args	= HWGROUP(drive)->rq->special;
-	ide_hwif_t *hwif	= HWIF(drive);
 	u8 stat;
 
 	local_irq_enable_in_hardirq();
-	if (!OK_STAT(stat = hwif->INB(IDE_STATUS_REG),READY_STAT,BAD_STAT)) {
+	stat = ide_read_status(drive);
+
+	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_error(drive, "task_no_data_intr", stat);
 		/* calls ide_end_drive_cmd */
-	}
+
 	if (args)
-		ide_end_drive_cmd(drive, stat, hwif->INB(IDE_ERROR_REG));
+		ide_end_drive_cmd(drive, stat, ide_read_error(drive));
 
 	return ide_stopped;
 }
 
 static u8 wait_drive_not_busy(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
 	int retries;
 	u8 stat;
 
@@ -269,7 +266,9 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	 * This can take up to 10 usec, but we will wait max 1 ms.
 	 */
 	for (retries = 0; retries < 100; retries++) {
-		if ((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT)
+		stat = ide_read_status(drive);
+
+		if (stat & BUSY_STAT)
 			udelay(10);
 		else
 			break;
@@ -408,7 +407,7 @@ static ide_startstop_t task_error(ide_drive_t *drive, struct request *rq,
 void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
 {
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
-		u8 err = drive->hwif->INB(IDE_ERROR_REG);
+		u8 err = ide_read_error(drive);
 
 		ide_end_drive_cmd(drive, stat, err);
 		return;
@@ -430,7 +429,7 @@ static ide_startstop_t task_in_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = HWGROUP(drive)->rq;
-	u8 stat = hwif->INB(IDE_STATUS_REG);
+	u8 stat = ide_read_status(drive);
 
 	/* new way for dealing with premature shared PCI interrupts */
 	if (!OK_STAT(stat, DRQ_STAT, BAD_R_STAT)) {
@@ -465,7 +464,7 @@ static ide_startstop_t task_out_intr (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = HWGROUP(drive)->rq;
-	u8 stat = hwif->INB(IDE_STATUS_REG);
+	u8 stat = ide_read_status(drive);
 
 	if (!OK_STAT(stat, DRIVE_READY, drive->bad_wstat))
 		return task_error(drive, rq, __FUNCTION__, stat);
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index ac61360..ad0e995 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -618,60 +618,6 @@ abort:
 
 EXPORT_SYMBOL(ide_unregister);
 
-
-/**
- *	ide_setup_ports 	-	set up IDE interface ports
- *	@hw: register descriptions
- *	@base: base register
- *	@offsets: table of register offsets
- *	@ctrl: control register
- *	@ack_irq: IRQ ack
- *	@irq: interrupt lie
- *
- *	Setup hw_regs_t structure described by parameters.  You
- *	may set up the hw structure yourself OR use this routine to
- *	do it for you. This is basically a helper
- *
- */
- 
-void ide_setup_ports (	hw_regs_t *hw,
-			unsigned long base, int *offsets,
-			unsigned long ctrl, unsigned long intr,
-			ide_ack_intr_t *ack_intr,
-/*
- *			ide_io_ops_t *iops,
- */
-			int irq)
-{
-	int i;
-
-	memset(hw, 0, sizeof(hw_regs_t));
-	for (i = 0; i < IDE_NR_PORTS; i++) {
-		if (offsets[i] == -1) {
-			switch(i) {
-				case IDE_CONTROL_OFFSET:
-					hw->io_ports[i] = ctrl;
-					break;
-#if defined(CONFIG_AMIGA) || defined(CONFIG_MAC)
-				case IDE_IRQ_OFFSET:
-					hw->io_ports[i] = intr;
-					break;
-#endif /* (CONFIG_AMIGA) || (CONFIG_MAC) */
-				default:
-					hw->io_ports[i] = 0;
-					break;
-			}
-		} else {
-			hw->io_ports[i] = base + offsets[i];
-		}
-	}
-	hw->irq = irq;
-	hw->ack_intr = ack_intr;
-/*
- *	hw->iops = iops;
- */
-}
-
 void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
 {
 	memcpy(hwif->io_ports, hw->io_ports, sizeof(hwif->io_ports));
diff --git a/drivers/ide/legacy/buddha.c b/drivers/ide/legacy/buddha.c
index 8bdb79d..50ffa87 100644
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -56,31 +56,11 @@ static u_int xsurf_bases[XSURF_NUM_HWIFS] __initdata = {
      XSURF_BASE1, XSURF_BASE2
 };
 
-
     /*
      *  Offsets from one of the above bases
      */
 
-#define BUDDHA_DATA	0x00
-#define BUDDHA_ERROR	0x06		/* see err-bits */
-#define BUDDHA_NSECTOR	0x0a		/* nr of sectors to read/write */
-#define BUDDHA_SECTOR	0x0e		/* starting sector */
-#define BUDDHA_LCYL	0x12		/* starting cylinder */
-#define BUDDHA_HCYL	0x16		/* high byte of starting cyl */
-#define BUDDHA_SELECT	0x1a		/* 101dhhhh , d=drive, hhhh=head */
-#define BUDDHA_STATUS	0x1e		/* see status-bits */
 #define BUDDHA_CONTROL	0x11a
-#define XSURF_CONTROL   -1              /* X-Surf has no CS1* (Control/AltStat) */
-
-static int buddha_offsets[IDE_NR_PORTS] __initdata = {
-    BUDDHA_DATA, BUDDHA_ERROR, BUDDHA_NSECTOR, BUDDHA_SECTOR, BUDDHA_LCYL,
-    BUDDHA_HCYL, BUDDHA_SELECT, BUDDHA_STATUS, BUDDHA_CONTROL, -1
-};
-
-static int xsurf_offsets[IDE_NR_PORTS] __initdata = {
-    BUDDHA_DATA, BUDDHA_ERROR, BUDDHA_NSECTOR, BUDDHA_SECTOR, BUDDHA_LCYL,
-    BUDDHA_HCYL, BUDDHA_SELECT, BUDDHA_STATUS, XSURF_CONTROL, -1
-};
 
     /*
      *  Other registers
@@ -140,6 +120,26 @@ static int xsurf_ack_intr(ide_hwif_t *hwif)
     return 1;
 }
 
+static void __init buddha_setup_ports(hw_regs_t *hw, unsigned long base,
+				      unsigned long ctl, unsigned long irq_port,
+				      ide_ack_intr_t *ack_intr)
+{
+	int i;
+
+	memset(hw, 0, sizeof(*hw));
+
+	hw->io_ports[IDE_DATA_OFFSET] = base;
+
+	for (i = 1; i < 8; i++)
+		hw->io_ports[i] = base + 2 + i * 4;
+
+	hw->io_ports[IDE_CONTROL_OFFSET] = ctl;
+	hw->io_ports[IDE_IRQ_OFFSET] = irq_port;
+
+	hw->irq = IRQ_AMIGA_PORTS;
+	hw->ack_intr = ack_intr;
+}
+
     /*
      *  Probe for a Buddha or Catweasel IDE interface
      */
@@ -202,22 +202,24 @@ fail_base2:
 		printk(KERN_INFO "ide: %s IDE controller\n",
 				 buddha_board_name[type]);
 
-		for(i=0;i<buddha_num_hwifs;i++) {
-			if(type != BOARD_XSURF) {
-				ide_setup_ports(&hw, (buddha_board+buddha_bases[i]),
-						buddha_offsets, 0,
-						(buddha_board+buddha_irqports[i]),
-						buddha_ack_intr,
-//						budda_iops,
-						IRQ_AMIGA_PORTS);
+		for (i = 0; i < buddha_num_hwifs; i++) {
+			unsigned long base, ctl, irq_port;
+			ide_ack_intr_t *ack_intr;
+
+			if (type != BOARD_XSURF) {
+				base = buddha_board + buddha_bases[i];
+				ctl = base + BUDDHA_CONTROL;
+				irq_port = buddha_board + buddha_irqports[i];
+				ack_intr = buddha_ack_intr;
 			} else {
-				ide_setup_ports(&hw, (buddha_board+xsurf_bases[i]),
-						xsurf_offsets, 0,
-						(buddha_board+xsurf_irqports[i]),
-						xsurf_ack_intr,
-//						xsurf_iops,
-						IRQ_AMIGA_PORTS);
-			}	
+				base = buddha_board + xsurf_bases[i];
+				/* X-Surf has no CS1* (Control/AltStat) */
+				ctl = 0;
+				irq_port = buddha_board + xsurf_irqports[i];
+				ack_intr = xsurf_ack_intr;
+			}
+
+			buddha_setup_ports(&hw, base, ctl, irq_port, ack_intr);
 
 			hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
 			if (hwif) {
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index 85b69a8..f044048 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -33,22 +33,8 @@
      *  Offsets from the above base
      */
 
-#define ATA_HD_DATA	0x00
-#define ATA_HD_ERROR	0x05		/* see err-bits */
-#define ATA_HD_NSECTOR	0x09		/* nr of sectors to read/write */
-#define ATA_HD_SECTOR	0x0d		/* starting sector */
-#define ATA_HD_LCYL	0x11		/* starting cylinder */
-#define ATA_HD_HCYL	0x15		/* high byte of starting cyl */
-#define ATA_HD_SELECT	0x19		/* 101dhhhh , d=drive, hhhh=head */
-#define ATA_HD_STATUS	0x1d		/* see status-bits */
 #define ATA_HD_CONTROL	0x39
 
-static int falconide_offsets[IDE_NR_PORTS] __initdata = {
-    ATA_HD_DATA, ATA_HD_ERROR, ATA_HD_NSECTOR, ATA_HD_SECTOR, ATA_HD_LCYL,
-    ATA_HD_HCYL, ATA_HD_SELECT, ATA_HD_STATUS, ATA_HD_CONTROL, -1
-};
-
-
     /*
      *  falconide_intr_lock is used to obtain access to the IDE interrupt,
      *  which is shared between several drivers.
@@ -57,6 +43,22 @@ static int falconide_offsets[IDE_NR_PORTS] __initdata = {
 int falconide_intr_lock;
 EXPORT_SYMBOL(falconide_intr_lock);
 
+static void __init falconide_setup_ports(hw_regs_t *hw)
+{
+	int i;
+
+	memset(hw, 0, sizeof(*hw));
+
+	hw->io_ports[IDE_DATA_OFFSET] = ATA_HD_BASE;
+
+	for (i = 1; i < 8; i++)
+		hw->io_ports[i] = ATA_HD_BASE + 1 + i * 4;
+
+	hw->io_ports[IDE_CONTROL_OFFSET] = ATA_HD_CONTROL;
+
+	hw->irq = IRQ_MFP_IDE;
+	hw->ack_intr = NULL;
+}
 
     /*
      *  Probe for a Falcon IDE interface
@@ -64,16 +66,15 @@ EXPORT_SYMBOL(falconide_intr_lock);
 
 static int __init falconide_init(void)
 {
-    if (MACH_IS_ATARI && ATARIHW_PRESENT(IDE)) {
 	hw_regs_t hw;
 	ide_hwif_t *hwif;
 
+	if (!MACH_IS_ATARI || !ATARIHW_PRESENT(IDE))
+		return 0;
+
 	printk(KERN_INFO "ide: Falcon IDE controller\n");
 
-	ide_setup_ports(&hw, ATA_HD_BASE, falconide_offsets,
-			0, 0, NULL,
-//			falconide_iops,
-			IRQ_MFP_IDE);
+	falconide_setup_ports(&hw);
 
 	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
 	if (hwif) {
@@ -85,9 +86,8 @@ static int __init falconide_init(void)
 
 		ide_device_add(idx, NULL);
 	}
-    }
 
-    return 0;
+	return 0;
 }
 
 module_init(falconide_init);
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index fc29ce7..9d3851d 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -34,22 +34,8 @@
      *  Offsets from one of the above bases
      */
 
-#define GAYLE_DATA	0x00
-#define GAYLE_ERROR	0x06		/* see err-bits */
-#define GAYLE_NSECTOR	0x0a		/* nr of sectors to read/write */
-#define GAYLE_SECTOR	0x0e		/* starting sector */
-#define GAYLE_LCYL	0x12		/* starting cylinder */
-#define GAYLE_HCYL	0x16		/* high byte of starting cyl */
-#define GAYLE_SELECT	0x1a		/* 101dhhhh , d=drive, hhhh=head */
-#define GAYLE_STATUS	0x1e		/* see status-bits */
 #define GAYLE_CONTROL	0x101a
 
-static int gayle_offsets[IDE_NR_PORTS] __initdata = {
-    GAYLE_DATA, GAYLE_ERROR, GAYLE_NSECTOR, GAYLE_SECTOR, GAYLE_LCYL,
-    GAYLE_HCYL, GAYLE_SELECT, GAYLE_STATUS, -1, -1
-};
-
-
     /*
      *  These are at different offsets from the base
      */
@@ -106,6 +92,26 @@ static int gayle_ack_intr_a1200(ide_hwif_t *hwif)
     return 1;
 }
 
+static void __init gayle_setup_ports(hw_regs_t *hw, unsigned long base,
+				     unsigned long ctl, unsigned long irq_port,
+				     ide_ack_intr_t *ack_intr);
+{
+	int i;
+
+	memset(hw, 0, sizeof(*hw));
+
+	hw->io_ports[IDE_DATA_OFFSET] = base;
+
+	for (i = 1; i < 8; i++)
+		hw->io_ports[i] = base + 2 + i * 4;
+
+	hw->io_ports[IDE_CONTROL_OFFSET] = ctl;
+	hw->io_ports[IDE_IRQ_OFFSET] = irq_port;
+
+	hw->irq = IRQ_AMIGA_PORTS;
+	hw->ack_intr = ack_intr;
+}
+
     /*
      *  Probe for a Gayle IDE interface (and optionally for an IDE doubler)
      */
@@ -167,10 +173,7 @@ found:
 	base = (unsigned long)ZTWO_VADDR(phys_base);
 	ctrlport = GAYLE_HAS_CONTROL_REG ? (base + GAYLE_CONTROL) : 0;
 
-	ide_setup_ports(&hw, base, gayle_offsets,
-			ctrlport, irqport, ack_intr,
-//			&gayle_iops,
-			IRQ_AMIGA_PORTS);
+	gayle_setup_ports(&hw, base, ctrlport, irqport, ack_intr);
 
 	hwif = ide_find_port(base);
 	if (hwif) {
diff --git a/drivers/ide/legacy/hd.c b/drivers/ide/legacy/hd.c
index 8e05d88..0b0d867 100644
--- a/drivers/ide/legacy/hd.c
+++ b/drivers/ide/legacy/hd.c
@@ -421,11 +421,14 @@ static void bad_rw_intr(void)
 
 static inline int wait_DRQ(void)
 {
-	int retries = 100000, stat;
+	int retries;
+	int stat;
 
-	while (--retries > 0)
-		if ((stat = inb_p(HD_STATUS)) & DRQ_STAT)
+	for (retries = 0; retries < 100000; retries++) {
+		stat = inb_p(HD_STATUS);
+		if (stat & DRQ_STAT)
 			return 0;
+	}
 	dump_status("wait_DRQ", stat);
 	return -1;
 }
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index 06df8df..a61e607 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -31,14 +31,6 @@
  * These match MkLinux so they should be correct.
  */
 
-#define IDE_DATA	0x00
-#define IDE_ERROR	0x04	/* see err-bits */
-#define IDE_NSECTOR	0x08	/* nr of sectors to read/write */
-#define IDE_SECTOR	0x0c	/* starting sector */
-#define IDE_LCYL	0x10	/* starting cylinder */
-#define IDE_HCYL	0x14	/* high byte of starting cyl */
-#define IDE_SELECT	0x18	/* 101dhhhh , d=drive, hhhh=head */
-#define IDE_STATUS	0x1c	/* see status-bits */
 #define IDE_CONTROL	0x38	/* control/altstatus */
 
 /*
@@ -63,11 +55,6 @@
 
 volatile unsigned char *ide_ifr = (unsigned char *) (IDE_BASE + IDE_IFR);
 
-static int macide_offsets[IDE_NR_PORTS] = {
-    IDE_DATA, IDE_ERROR,  IDE_NSECTOR, IDE_SECTOR, IDE_LCYL,
-    IDE_HCYL, IDE_SELECT, IDE_STATUS,  IDE_CONTROL
-};
-
 int macide_ack_intr(ide_hwif_t* hwif)
 {
 	if (*ide_ifr & 0x20) {
@@ -77,6 +64,22 @@ int macide_ack_intr(ide_hwif_t* hwif)
 	return 0;
 }
 
+static void __init macide_setup_ports(hw_regs_t *hw, unsigned long base,
+				      int irq, ide_ack_intr_t *ack_intr)
+{
+	int i;
+
+	memset(hw, 0, sizeof(*hw));
+
+	for (i = 0; i < 8; i++)
+		hw->io_ports[i] = base + i * 4;
+
+	hw->io_ports[IDE_CONTROL_OFFSET] = IDE_CONTROL;
+
+	hw->irq = irq;
+	hw->ack_intr = ack_intr;
+}
+
 static const char *mac_ide_name[] =
 	{ "Quadra", "Powerbook", "Powerbook Baboon" };
 
@@ -86,27 +89,27 @@ static const char *mac_ide_name[] =
 
 static int __init macide_init(void)
 {
-	hw_regs_t hw;
 	ide_hwif_t *hwif;
+	ide_ack_intr_t *ack_intr;
+	unsigned long base;
+	int irq;
+	hw_regs_t hw;
 
 	switch (macintosh_config->ide_type) {
 	case MAC_IDE_QUADRA:
-		ide_setup_ports(&hw, IDE_BASE, macide_offsets,
-				0, 0, macide_ack_intr,
-//				quadra_ide_iops,
-				IRQ_NUBUS_F);
+		base = IDE_BASE;
+		ack_intr = macide_ack_intr;
+		irq = IRQ_NUBUS_F;
 		break;
 	case MAC_IDE_PB:
-		ide_setup_ports(&hw, IDE_BASE, macide_offsets,
-				0, 0, macide_ack_intr,
-//				macide_pb_iops,
-				IRQ_NUBUS_C);
+		base = IDE_BASE;
+		ack_intr = macide_ack_intr;
+		irq = IRQ_NUBUS_C;
 		break;
 	case MAC_IDE_BABOON:
-		ide_setup_ports(&hw, BABOON_BASE, macide_offsets,
-				0, 0, NULL,
-//				macide_baboon_iops,
-				IRQ_BABOON_1);
+		base = BABOON_BASE;
+		ack_intr = NULL;
+		irq = IRQ_BABOON_1;
 		break;
 	default:
 		return -ENODEV;
@@ -115,6 +118,8 @@ static int __init macide_init(void)
 	printk(KERN_INFO "ide: Macintosh %s IDE controller\n",
 			 mac_ide_name[macintosh_config->ide_type - 1]);
 
+	macide_setup_ports(&hw, base, irq, ack_intr);
+
 	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
 	if (hwif) {
 		u8 index = hwif->index;
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index 2f0b34d..1381b91 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -66,16 +66,12 @@ static int q40ide_default_irq(unsigned long base)
 
 
 /*
- * This is very similar to ide_setup_ports except that addresses
- * are pretranslated for q40 ISA access
+ * Addresses are pretranslated for Q40 ISA access.
  */
 void q40_ide_setup_ports ( hw_regs_t *hw,
 			unsigned long base, int *offsets,
 			unsigned long ctrl, unsigned long intr,
 			ide_ack_intr_t *ack_intr,
-/*
- *			ide_io_ops_t *iops,
- */
 			int irq)
 {
 	int i;
@@ -92,9 +88,6 @@ void q40_ide_setup_ports ( hw_regs_t *hw,
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;
-/*
- *	hw->iops = iops;
- */
 }
 
 
diff --git a/drivers/ide/pci/Makefile b/drivers/ide/pci/Makefile
index 9480325..02e6ee7 100644
--- a/drivers/ide/pci/Makefile
+++ b/drivers/ide/pci/Makefile
@@ -34,7 +34,8 @@ obj-$(CONFIG_BLK_DEV_TRM290)		+= trm290.o
 obj-$(CONFIG_BLK_DEV_VIA82CXXX)		+= via82cxxx.o
 
 # Must appear at the end of the block
-obj-$(CONFIG_BLK_DEV_GENERIC)          += generic.o
+obj-$(CONFIG_BLK_DEV_GENERIC)		+= ide-pci-generic.o
+ide-pci-generic-y			+= generic.o
 
 ifeq ($(CONFIG_BLK_DEV_CMD640), m)
 	obj-m += cmd640.o
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index 9262a91..7fd83a9 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -29,19 +29,6 @@
 
 static int ide_generic_all;		/* Set to claim all devices */
 
-/*
- * the module_param_named() was added for the modular case
- * the __setup() is left as compatibility for existing setups
- */
-#ifndef MODULE
-static int __init ide_generic_all_on(char *unused)
-{
-	ide_generic_all = 1;
-	printk(KERN_INFO "IDE generic will claim all unknown PCI IDE storage controllers.\n");
-	return 1;
-}
-const __setup("all-generic-ide", ide_generic_all_on);
-#endif
 module_param_named(all_generic_ide, ide_generic_all, bool, 0444);
 MODULE_PARM_DESC(all_generic_ide, "IDE generic will claim all unknown PCI IDE storage controllers.");
 
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index ef5b39f..cc4be96 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -704,9 +704,6 @@ static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 		hwif->sata_scr[SATA_STATUS_OFFSET]	= base + 0x104;
 		hwif->sata_scr[SATA_ERROR_OFFSET]	= base + 0x108;
 		hwif->sata_scr[SATA_CONTROL_OFFSET]	= base + 0x100;
-		hwif->sata_misc[SATA_MISC_OFFSET]	= base + 0x140;
-		hwif->sata_misc[SATA_PHY_OFFSET]	= base + 0x144;
-		hwif->sata_misc[SATA_IEN_OFFSET]	= base + 0x148;
 	}
 
 	memcpy(hwif->io_ports, hw.io_ports, sizeof(hwif->io_ports));
diff --git a/drivers/macintosh/mediabay.c b/drivers/macintosh/mediabay.c
index de9ebbf..9367882 100644
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -78,12 +78,14 @@ struct media_bay_info {
 	int				cached_gpio;
 	int				sleeping;
 	struct semaphore		lock;
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 	void __iomem			*cd_base;
-	int 				cd_index;
 	int				cd_irq;
 	int				cd_retry;
 #endif
+#if defined(CONFIG_BLK_DEV_IDE_PMAC) || defined(CONFIG_MAC_FLOPPY)
+	int 				cd_index;
+#endif
 };
 
 #define MAX_BAYS	2
@@ -91,7 +93,7 @@ struct media_bay_info {
 static struct media_bay_info media_bays[MAX_BAYS];
 int media_bay_count = 0;
 
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 /* check the busy bit in the media-bay ide interface
    (assumes the media-bay contains an ide device) */
 #define MB_IDE_READY(i)	((readb(media_bays[i].cd_base + 0x70) & 0x80) == 0)
@@ -401,7 +403,7 @@ static void poll_media_bay(struct media_bay_info* bay)
 				set_mb_power(bay, id != MB_NO);
 				bay->content_id = id;
 				if (id == MB_NO) {
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 					bay->cd_retry = 0;
 #endif
 					printk(KERN_INFO "media bay %d is empty\n", bay->index);
@@ -414,9 +416,9 @@ static void poll_media_bay(struct media_bay_info* bay)
 	}
 }
 
+#ifdef CONFIG_MAC_FLOPPY
 int check_media_bay(struct device_node *which_bay, int what)
 {
-#ifdef CONFIG_BLK_DEV_IDE
 	int	i;
 
 	for (i=0; i<media_bay_count; i++)
@@ -426,14 +428,14 @@ int check_media_bay(struct device_node *which_bay, int what)
 			media_bays[i].cd_index = -1;
 			return -EINVAL;
 		}
-#endif /* CONFIG_BLK_DEV_IDE */
 	return -ENODEV;
 }
 EXPORT_SYMBOL(check_media_bay);
+#endif /* CONFIG_MAC_FLOPPY */
 
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 int check_media_bay_by_base(unsigned long base, int what)
 {
-#ifdef CONFIG_BLK_DEV_IDE
 	int	i;
 
 	for (i=0; i<media_bay_count; i++)
@@ -443,15 +445,13 @@ int check_media_bay_by_base(unsigned long base, int what)
 			media_bays[i].cd_index = -1;
 			return -EINVAL;
 		} 
-#endif
-	
+
 	return -ENODEV;
 }
 
 int media_bay_set_ide_infos(struct device_node* which_bay, unsigned long base,
-	int irq, int index)
+			    int irq, int index)
 {
-#ifdef CONFIG_BLK_DEV_IDE
 	int	i;
 
 	for (i=0; i<media_bay_count; i++) {
@@ -483,10 +483,10 @@ int media_bay_set_ide_infos(struct device_node* which_bay, unsigned long base,
 			return -ENODEV;
 		}
 	}
-#endif /* CONFIG_BLK_DEV_IDE */
-	
+
 	return -ENODEV;
 }
+#endif /* CONFIG_BLK_DEV_IDE_PMAC */
 
 static void media_bay_step(int i)
 {
@@ -521,14 +521,13 @@ static void media_bay_step(int i)
 	    	bay->state = mb_resetting;
 		MBDBG("mediabay%d: waiting reset (kind:%d)\n", i, bay->content_id);
 	    	break;
-	    
 	case mb_resetting:
 		if (bay->content_id != MB_CD) {
 			MBDBG("mediabay%d: bay is up (kind:%d)\n", i, bay->content_id);
 			bay->state = mb_up;
 			break;
 	    	}
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 		MBDBG("mediabay%d: waiting IDE reset (kind:%d)\n", i, bay->content_id);
 		bay->ops->un_reset_ide(bay);
 	    	bay->timer = msecs_to_jiffies(MB_IDE_WAIT);
@@ -536,16 +535,14 @@ static void media_bay_step(int i)
 #else
 		printk(KERN_DEBUG "media-bay %d is ide (not compiled in kernel)\n", i);
 		set_mb_power(bay, 0);
-#endif /* CONFIG_BLK_DEV_IDE */
+#endif /* CONFIG_BLK_DEV_IDE_PMAC */
 	    	break;
-	    
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 	case mb_ide_resetting:
 	    	bay->timer = msecs_to_jiffies(MB_IDE_TIMEOUT);
 	    	bay->state = mb_ide_waiting;
 		MBDBG("mediabay%d: waiting IDE ready (kind:%d)\n", i, bay->content_id);
 	    	break;
-	    
 	case mb_ide_waiting:
 		if (bay->cd_base == NULL) {
 			bay->timer = 0;
@@ -587,11 +584,10 @@ static void media_bay_step(int i)
 			bay->timer = 0;
 	    	}
 		break;
-#endif /* CONFIG_BLK_DEV_IDE */
-
+#endif /* CONFIG_BLK_DEV_IDE_PMAC */
 	case mb_powering_down:
 	    	bay->state = mb_empty;
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
     	        if (bay->cd_index >= 0) {
 			printk(KERN_DEBUG "Unregistering mb %d ide, index:%d\n", i,
 			       bay->cd_index);
@@ -607,7 +603,7 @@ static void media_bay_step(int i)
 				bay->content_id = MB_NO;
 			}
 	    	}
-#endif /* CONFIG_BLK_DEV_IDE */    
+#endif /* CONFIG_BLK_DEV_IDE_PMAC */
 		MBDBG("mediabay%d: end of power down\n", i);
 	    	break;
 	}
@@ -739,7 +735,7 @@ static int media_bay_resume(struct macio_dev *mdev)
 	       	bay->last_value = bay->content_id;
 	       	bay->value_count = msecs_to_jiffies(MB_STABLE_DELAY);
 	       	bay->timer = msecs_to_jiffies(MB_POWER_DELAY);
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 	       	bay->cd_retry = 0;
 #endif
 	       	do {
@@ -829,7 +825,7 @@ static int __init media_bay_init(void)
 	for (i=0; i<MAX_BAYS; i++) {
 		memset((char *)&media_bays[i], 0, sizeof(struct media_bay_info));
 		media_bays[i].content_id	= -1;
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 		media_bays[i].cd_index		= -1;
 #endif
 	}
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 6c4f0f0..68e5c63 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -287,7 +287,7 @@ static int idescsi_end_request(ide_drive_t *, int, int);
 static ide_startstop_t
 idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 {
-	if (HWIF(drive)->INB(IDE_STATUS_REG) & (BUSY_STAT|DRQ_STAT))
+	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
 		HWIF(drive)->OUTB(WIN_IDLEIMMEDIATE,IDE_COMMAND_REG);
 
@@ -423,7 +423,7 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 	}
 
 	/* Clear the interrupt */
-	stat = drive->hwif->INB(IDE_STATUS_REG);
+	stat = ide_read_status(drive);
 
 	if ((stat & DRQ_STAT) == 0) {
 		/* No more interrupts */
diff --git a/include/asm-powerpc/mediabay.h b/include/asm-powerpc/mediabay.h
index 9daa325..de83fe1 100644
--- a/include/asm-powerpc/mediabay.h
+++ b/include/asm-powerpc/mediabay.h
@@ -18,14 +18,14 @@
 #define MB_NO		7	/* media bay contains nothing */
 
 int check_media_bay(struct device_node *which_bay, int what);
-int check_media_bay_by_base(unsigned long base, int what);
 
 /* Number of bays in the machine or 0 */
 extern int media_bay_count;
 
-/* called by pmac-ide.c to register IDE controller for media bay */
-extern int media_bay_set_ide_infos(struct device_node* which_bay,
-			unsigned long base, int irq, int index);
+int check_media_bay_by_base(unsigned long base, int what);
+/* called by IDE PMAC host driver to register IDE controller for media bay */
+int media_bay_set_ide_infos(struct device_node *which_bay, unsigned long base,
+			    int irq, int index);
 
 #endif /* __KERNEL__ */
 #endif /* _PPC_MEDIABAY_H */
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 367c170..acec99d 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -115,10 +115,6 @@ typedef unsigned char	byte;	/* used everywhere */
 #define SATA_ERROR_OFFSET	(1)
 #define SATA_CONTROL_OFFSET	(2)
 
-#define SATA_MISC_OFFSET	(0)
-#define SATA_PHY_OFFSET		(1)
-#define SATA_IEN_OFFSET		(2)
-
 /*
  * Our Physical Region Descriptor (PRD) table should be large enough
  * to handle the biggest I/O request we are likely to see.  Since requests
@@ -173,7 +169,7 @@ enum {		ide_unknown,	ide_generic,	ide_pci,
 		ide_rz1000,	ide_trm290,
 		ide_cmd646,	ide_cy82c693,	ide_4drives,
 		ide_pmac,	ide_etrax100,	ide_acorn,
-		ide_au1xxx, ide_forced
+		ide_au1xxx,	ide_palm3710,	ide_forced
 };
 
 typedef u8 hwif_chipset_t;
@@ -198,17 +194,6 @@ struct ide_drive_s;
 int ide_register_hw(hw_regs_t *, void (*)(struct ide_drive_s *),
 		    struct hwif_s **);
 
-void ide_setup_ports(	hw_regs_t *hw,
-			unsigned long base,
-			int *offsets,
-			unsigned long ctrl,
-			unsigned long intr,
-			ide_ack_intr_t *ack_intr,
-#if 0
-			ide_io_ops_t *iops,
-#endif
-			int irq);
-
 static inline void ide_std_init_ports(hw_regs_t *hw,
 				      unsigned long io_addr,
 				      unsigned long ctl_addr)
@@ -473,7 +458,6 @@ typedef struct hwif_s {
 		/* task file registers for pata and sata */
 	unsigned long	io_ports[IDE_NR_PORTS];
 	unsigned long	sata_scr[SATA_NR_PORTS];
-	unsigned long	sata_misc[SATA_NR_PORTS];
 
 	ide_drive_t	drives[MAX_DRIVES];	/* drive info */
 
@@ -1014,7 +998,8 @@ extern int __ide_pci_register_driver(struct pci_driver *driver, struct module *o
 void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *, int, u8 *);
 void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
+/* FIXME: palm_bk3710 uses BLK_DEV_IDEDMA_PCI without BLK_DEV_IDEPCI! */
+#if defined(CONFIG_BLK_DEV_IDEPCI) && defined(CONFIG_BLK_DEV_IDEDMA_PCI)
 void ide_hwif_setup_dma(ide_hwif_t *, const struct ide_port_info *);
 #else
 static inline void ide_hwif_setup_dma(ide_hwif_t *hwif,
@@ -1324,4 +1309,25 @@ static inline void ide_set_irq(ide_drive_t *drive, int on)
 	drive->hwif->OUTB(drive->ctl | (on ? 0 : 2), IDE_CONTROL_REG);
 }
 
+static inline u8 ide_read_status(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	return hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+}
+
+static inline u8 ide_read_altstatus(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	return hwif->INB(hwif->io_ports[IDE_CONTROL_OFFSET]);
+}
+
+static inline u8 ide_read_error(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	return hwif->INB(hwif->io_ports[IDE_ERROR_OFFSET]);
+}
+
 #endif /* _IDE_H */
