Return-Path: <linux-kernel-owner+w=401wt.eu-S936352AbYD1Vxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936352AbYD1Vxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934334AbYD1VxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:53:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:12917 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934816AbYD1VxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=vE2pq1ASYP6BtBX48OUENmyTT//ZYvzBPJVHovsjB4eMjYOMKcJ+GlIa/joRWT84mZpXHMuz2ncQpUmQ7EEmNSpMCBx//0LJYXLRTlQRR0m5Pa8Q/YnZur1MUyvp16Tgch+dmdLFAd80yeT2IADQED1W2IVVZjI/amxdPpfeeuc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates part 5
Date: Tue, 29 Apr 2008 00:07:49 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804290007.50090.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


the final part:

- remove broken Etrax IDE driver (Adrian Bunk)

- add ->input_data and ->output_data methods

- add ->tf_load and ->tf_read methods

- and more (detailed changelog below)


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 arch/arm/Kconfig                  |   15 +-
 drivers/ide/Kconfig               |   34 --
 drivers/ide/Makefile              |    2 +-
 drivers/ide/arm/icside.c          |    2 +-
 drivers/ide/arm/palm_bk3710.c     |    1 +
 drivers/ide/arm/rapide.c          |    1 +
 drivers/ide/cris/Makefile         |    3 -
 drivers/ide/cris/ide-cris.c       | 1086 -------------------------------------
 drivers/ide/h8300/ide-h8300.c     |  108 ++++-
 drivers/ide/ide-cd.c              |   32 +-
 drivers/ide/ide-dma.c             |   11 +-
 drivers/ide/ide-floppy.c          |   27 +-
 drivers/ide/ide-io.c              |   68 +--
 drivers/ide/ide-iops.c            |  344 +++++++-----
 drivers/ide/ide-lib.c             |    2 +-
 drivers/ide/ide-probe.c           |    8 +-
 drivers/ide/ide-tape.c            |   19 +-
 drivers/ide/ide-taskfile.c        |   70 +--
 drivers/ide/legacy/falconide.c    |   26 +
 drivers/ide/legacy/ide_platform.c |    4 +-
 drivers/ide/legacy/q40ide.c       |   24 +
 drivers/ide/mips/au1xxx-ide.c     |   17 +-
 drivers/ide/mips/swarm.c          |    1 +
 drivers/ide/pci/ns87415.c         |   44 ++
 drivers/ide/pci/pdc202xx_new.c    |    8 +-
 drivers/ide/pci/piix.c            |    1 +
 drivers/ide/pci/scc_pata.c        |  196 ++++++-
 drivers/ide/pci/sgiioc4.c         |    1 +
 drivers/ide/pci/siimage.c         |  539 +++++++++----------
 drivers/ide/ppc/pmac.c            |    1 +
 drivers/pcmcia/Kconfig            |    1 -
 drivers/scsi/ide-scsi.c           |   38 +-
 include/linux/ide.h               |   53 +--
 33 files changed, 961 insertions(+), 1826 deletions(-)
 delete mode 100644 drivers/ide/cris/Makefile
 delete mode 100644 drivers/ide/cris/ide-cris.c


Adrian Bunk (2):
      remove the broken ETRAX_IDE driver
      ARM: always select HAVE_IDE

Alexander Smal (1):
      ide: add TSSTcorp CDDVDW SH-S202H to ivb_list[]

Bartlomiej Zolnierkiewicz (29):
      ide: fix au1xxx-ide breakage
      falconide/q40ide: add ->atapi_*put_bytes and ->ata_*put_data methods (take 2)
      ide: merge ->atapi_*put_bytes and ->ata_*put_data methods
      scc_pata: add ->{in,out}put_data methods (take 2)
      au1xxx-ide: add ->{in,out}put_data methods (take 2)
      ide-h8300: add ->{in,out}put_data methods (take 2)
      ide: add IDE_HFLAG_MMIO host flag (take 2)
      ide: remove ->INS{W,L} and ->OUTS{W,L} methods
      siimage: do clocking register posting earlier in setup_mmio_siimage()
      siimage: add sil_* I/O ops
      siimage: remove proc_reports_siimage()
      ide: always use ->OUTBSYNC method for executing commands
      ide-{floppy,tape,scsi}: 400ns delay is required after executing the command
      ide: add ide_execute_pkt_cmd() helper
      ide: factor out debugging code from ide_tf_load()
      ide: move ide_tf_{load,read} to ide-iops.c
      ide: add ->tf_load and ->tf_read methods
      ide-cris: add ->tf_{load,read} methods
      ide-h8300: add ->tf_{load,read} methods
      scc_pata: add ->tf_{load,read} methods
      ns87415: add ->tf_read method
      ide: use IDE I/O helpers directly in ide_tf_{load,read}()
      ide: remove ->INW and ->OUTW methods
      ide: add ide_pad_transfer() helper
      ide: skip "VLB sync" if host uses MMIO
      scc_pata: add ->dma_host_set and ->dma_start methods
      ide: remove ->dma_vendor{1,3} fields from ide_hwif_t
      ide: remove ->dma_prdtable field from ide_hwif_t
      piix: add Asus Eee 701 controller to short cable list

Roel Kluin (2):
      ide-cd: fix test unsigned var < 0
      ide-cd: clean up cdrom_analyze_sense_data()

Sergei Shtylyov (1):
      siimage: coding style cleanup (take 2)


diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d8d2532..b786e68 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux Kernel Configuration"
 config ARM
 	bool
 	default y
+	select HAVE_IDE
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
 	select HAVE_OPROFILE
@@ -223,7 +224,6 @@ config ARCH_CLPS7500
 	select TIMER_ACORN
 	select ISA
 	select NO_IOPORT
-	select HAVE_IDE
 	help
 	  Support for the Cirrus Logic PS7500FE system-on-a-chip.
 
@@ -236,7 +236,6 @@ config ARCH_CO285
 	bool "Co-EBSA285"
 	select FOOTBRIDGE
 	select FOOTBRIDGE_ADDIN
-	select HAVE_IDE
 	help
 	  Support for Intel's EBSA285 companion chip.
 
@@ -262,7 +261,6 @@ config ARCH_EP93XX
 config ARCH_FOOTBRIDGE
 	bool "FootBridge"
 	select FOOTBRIDGE
-	select HAVE_IDE
 	help
 	  Support for systems based on the DC21285 companion chip
 	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
@@ -301,7 +299,6 @@ config ARCH_IOP32X
 	depends on MMU
 	select PLAT_IOP
 	select PCI
-	select HAVE_IDE
 	help
 	  Support for Intel's 80219 and IOP32X (XScale) family of
 	  processors.
@@ -311,14 +308,12 @@ config ARCH_IOP33X
 	depends on MMU
 	select PLAT_IOP
 	select PCI
-	select HAVE_IDE
 	help
 	  Support for Intel's IOP33X (XScale) family of processors.
 
 config ARCH_IXP23XX
  	bool "IXP23XX-based"
 	depends on MMU
-	select HAVE_IDE
  	select PCI
 	help
 	  Support for Intel's IXP23xx (XScale) family of processors.
@@ -336,14 +331,12 @@ config ARCH_IXP4XX
 	select GENERIC_GPIO
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
-	select HAVE_IDE
 	help
 	  Support for Intel's IXP4XX (XScale) family of processors.
 
 config ARCH_L7200
 	bool "LinkUp-L7200"
 	select FIQ
-	select HAVE_IDE
 	help
 	  Say Y here if you intend to run this kernel on a LinkUp Systems
 	  L7200 Software Development Board which uses an ARM720T processor.
@@ -400,7 +393,6 @@ config ARCH_PXA
 	depends on MMU
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
-	select HAVE_IDE
 	select HAVE_GPIO_LIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
@@ -416,7 +408,6 @@ config ARCH_RPC
 	select ARCH_MAY_HAVE_PC_FDC
 	select ISA_DMA_API
 	select NO_IOPORT
-	select HAVE_IDE
 	help
 	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
 	  CD-ROM interface, serial and parallel port, and the floppy drive.
@@ -432,7 +423,6 @@ config ARCH_SA1100
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
-	select HAVE_IDE
 	select HAVE_GPIO_LIB
 	help
 	  Support for StrongARM 11x0 based boards.
@@ -440,7 +430,6 @@ config ARCH_SA1100
 config ARCH_S3C2410
 	bool "Samsung S3C2410, S3C2412, S3C2413, S3C2440, S3C2442, S3C2443"
 	select GENERIC_GPIO
-	select HAVE_IDE
 	help
 	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
 	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
@@ -448,7 +437,6 @@ config ARCH_S3C2410
 
 config ARCH_SHARK
 	bool "Shark"
-	select HAVE_IDE
 	select ISA
 	select ISA_DMA
 	select PCI
@@ -458,7 +446,6 @@ config ARCH_SHARK
 
 config ARCH_LH7A40X
 	bool "Sharp LH7A40X"
-	select HAVE_IDE
 	help
 	  Say Y here for systems based on one of the Sharp LH7A40X
 	  System on a Chip processors.  These CPUs include an ARM922T
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 3f9e100..f702f91 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -862,40 +862,6 @@ config BLK_DEV_IDE_BAST
 	  Say Y here if you want to support the onboard IDE channels on the
 	  Simtec BAST or the Thorcom VR1000
 
-config ETRAX_IDE
-	tristate "ETRAX IDE support"
-	depends on CRIS && BROKEN
-	select BLK_DEV_IDEDMA
-	help
-	  Enables the ETRAX IDE driver.
-
-	  You can't use parallel ports or SCSI ports at the same time.
-
-config ETRAX_IDE_DELAY
-	int "Delay for drives to regain consciousness"
-	depends on ETRAX_IDE && ETRAX_ARCH_V10
-	default 15
-	help
-	  Number of seconds to wait for IDE drives to spin up after an IDE
-	  reset.
-
-choice
-	prompt "IDE reset pin"
-	depends on ETRAX_IDE && ETRAX_ARCH_V10
-	default ETRAX_IDE_PB7_RESET
-
-config ETRAX_IDE_PB7_RESET
-	bool "Port_PB_Bit_7"
-	help
-	  IDE reset on pin 7 on port B
-
-config ETRAX_IDE_G27_RESET
-	bool "Port_G_Bit_27"
-	help
-	  IDE reset on pin 27 on port G
-
-endchoice
-
 config IDE_H8300
 	tristate "H8300 IDE support"
 	depends on H8300
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 571544c..f94b679 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -35,7 +35,7 @@ ifeq ($(CONFIG_BLK_DEV_CMD640), y)
 	obj-y += cmd640-core.o
 endif
 
-obj-$(CONFIG_BLK_DEV_IDE)		+= cris/ ppc/
+obj-$(CONFIG_BLK_DEV_IDE)		+= ppc/
 obj-$(CONFIG_IDE_H8300)			+= h8300/
 obj-$(CONFIG_IDE_GENERIC)		+= ide-generic.o
 obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 65038ca..0614569 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -483,7 +483,7 @@ static const struct ide_port_info icside_v6_port_info __initdata = {
 	.init_dma		= icside_dma_off_init,
 	.port_ops		= &icside_v6_no_dma_port_ops,
 	.dma_ops		= &icside_v6_dma_ops,
-	.host_flags		= IDE_HFLAG_SERIALIZE,
+	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_MMIO,
 	.mwdma_mask		= ATA_MWDMA2,
 	.swdma_mask		= ATA_SWDMA2,
 };
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index aaf3254..96378eb 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -342,6 +342,7 @@ static const struct ide_port_ops palm_bk3710_ports_ops = {
 static const struct ide_port_info __devinitdata palm_bk3710_port_info = {
 	.init_dma		= palm_bk3710_init_dma,
 	.port_ops		= &palm_bk3710_ports_ops,
+	.host_flags		= IDE_HFLAG_MMIO,
 	.pio_mask		= ATA_PIO4,
 	.udma_mask		= ATA_UDMA4,	/* (input clk 99MHz) */
 	.mwdma_mask		= ATA_MWDMA2,
diff --git a/drivers/ide/arm/rapide.c b/drivers/ide/arm/rapide.c
index babc1a5..1747b23 100644
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -53,6 +53,7 @@ rapide_probe(struct expansion_card *ec, const struct ecard_id *id)
 
 		ide_init_port_hw(hwif, &hw);
 
+		hwif->host_flags = IDE_HFLAG_MMIO;
 		default_hwif_mmiops(hwif);
 
 		idx[0] = hwif->index;
diff --git a/drivers/ide/cris/Makefile b/drivers/ide/cris/Makefile
deleted file mode 100644
index 20b9596..0000000
--- a/drivers/ide/cris/Makefile
+++ /dev/null
@@ -1,3 +0,0 @@
-EXTRA_CFLAGS				+= -Idrivers/ide
-
-obj-$(CONFIG_IDE_ETRAX)			+= ide-cris.o
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
deleted file mode 100644
index 9df2685..0000000
--- a/drivers/ide/cris/ide-cris.c
+++ /dev/null
@@ -1,1086 +0,0 @@
-/*
- * Etrax specific IDE functions, like init and PIO-mode setting etc.
- * Almost the entire ide.c is used for the rest of the Etrax ATA driver.
- * Copyright (c) 2000-2005 Axis Communications AB
- *
- * Authors:    Bjorn Wesen        (initial version)
- *             Mikael Starvik     (crisv32 port)
- */
-
-/* Regarding DMA:
- *
- * There are two forms of DMA - "DMA handshaking" between the interface and the drive,
- * and DMA between the memory and the interface. We can ALWAYS use the latter, since it's
- * something built-in in the Etrax. However only some drives support the DMA-mode handshaking
- * on the ATA-bus. The normal PC driver and Triton interface disables memory-if DMA when the
- * device can't do DMA handshaking for some stupid reason. We don't need to do that.
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-#include <linux/delay.h>
-#include <linux/blkdev.h>
-#include <linux/hdreg.h>
-#include <linux/ide.h>
-#include <linux/init.h>
-
-#include <asm/io.h>
-#include <asm/dma.h>
-
-/* number of DMA descriptors */
-#define MAX_DMA_DESCRS 64
-
-/* number of times to retry busy-flags when reading/writing IDE-registers
- * this can't be too high because a hung harddisk might cause the watchdog
- * to trigger (sometimes INB and OUTB are called with irq's disabled)
- */
-
-#define IDE_REGISTER_TIMEOUT 300
-
-#define LOWDB(x)
-#define D(x)
-
-enum /* Transfer types */
-{
-	TYPE_PIO,
-	TYPE_DMA,
-	TYPE_UDMA
-};
-
-/* CRISv32 specifics */
-#ifdef CONFIG_ETRAX_ARCH_V32
-#include <asm/arch/hwregs/ata_defs.h>
-#include <asm/arch/hwregs/dma_defs.h>
-#include <asm/arch/hwregs/dma.h>
-#include <asm/arch/pinmux.h>
-
-#define ATA_UDMA2_CYC    2
-#define ATA_UDMA2_DVS    3
-#define ATA_UDMA1_CYC    2
-#define ATA_UDMA1_DVS    4
-#define ATA_UDMA0_CYC    4
-#define ATA_UDMA0_DVS    6
-#define ATA_DMA2_STROBE  7
-#define ATA_DMA2_HOLD    1
-#define ATA_DMA1_STROBE  8
-#define ATA_DMA1_HOLD    3
-#define ATA_DMA0_STROBE 25
-#define ATA_DMA0_HOLD   19
-#define ATA_PIO4_SETUP   3
-#define ATA_PIO4_STROBE  7
-#define ATA_PIO4_HOLD    1
-#define ATA_PIO3_SETUP   3
-#define ATA_PIO3_STROBE  9
-#define ATA_PIO3_HOLD    3
-#define ATA_PIO2_SETUP   3
-#define ATA_PIO2_STROBE 13
-#define ATA_PIO2_HOLD    5
-#define ATA_PIO1_SETUP   5
-#define ATA_PIO1_STROBE 23
-#define ATA_PIO1_HOLD    9
-#define ATA_PIO0_SETUP   9
-#define ATA_PIO0_STROBE 39
-#define ATA_PIO0_HOLD    9
-
-int
-cris_ide_ack_intr(ide_hwif_t* hwif)
-{
-	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
-					       hwif->io_ports.data_addr);
-	REG_WR_INT(ata, regi_ata, rw_ack_intr, 1 << ctrl2.sel);
-	return 1;
-}
-
-static inline int
-cris_ide_busy(void)
-{
-	reg_ata_rs_stat_data stat_data;
-	stat_data = REG_RD(ata, regi_ata, rs_stat_data);
-	return stat_data.busy;
-}
-
-static inline int
-cris_ide_ready(void)
-{
-	return !cris_ide_busy();
-}
-
-static inline int
-cris_ide_data_available(unsigned short* data)
-{
-	reg_ata_rs_stat_data stat_data;
-	stat_data = REG_RD(ata, regi_ata, rs_stat_data);
-	*data = stat_data.data;
-	return stat_data.dav;
-}
-
-static void
-cris_ide_write_command(unsigned long command)
-{
-	REG_WR_INT(ata, regi_ata, rw_ctrl2, command); /* write data to the drive's register */
-}
-
-static void
-cris_ide_set_speed(int type, int setup, int strobe, int hold)
-{
-	reg_ata_rw_ctrl0 ctrl0 = REG_RD(ata, regi_ata, rw_ctrl0);
-	reg_ata_rw_ctrl1 ctrl1 = REG_RD(ata, regi_ata, rw_ctrl1);
-
-	if (type == TYPE_PIO) {
-		ctrl0.pio_setup = setup;
-		ctrl0.pio_strb = strobe;
-		ctrl0.pio_hold = hold;
-	} else if (type == TYPE_DMA) {
-		ctrl0.dma_strb = strobe;
-		ctrl0.dma_hold = hold;
-	} else if (type == TYPE_UDMA) {
-		ctrl1.udma_tcyc = setup;
-		ctrl1.udma_tdvs = strobe;
-	}
-	REG_WR(ata, regi_ata, rw_ctrl0, ctrl0);
-	REG_WR(ata, regi_ata, rw_ctrl1, ctrl1);
-}
-
-static unsigned long
-cris_ide_base_address(int bus)
-{
-	reg_ata_rw_ctrl2 ctrl2 = {0};
-	ctrl2.sel = bus;
-	return REG_TYPE_CONV(int, reg_ata_rw_ctrl2, ctrl2);
-}
-
-static unsigned long
-cris_ide_reg_addr(unsigned long addr, int cs0, int cs1)
-{
-	reg_ata_rw_ctrl2 ctrl2 = {0};
-	ctrl2.addr = addr;
-	ctrl2.cs1 = cs1;
-	ctrl2.cs0 = cs0;
-	return REG_TYPE_CONV(int, reg_ata_rw_ctrl2, ctrl2);
-}
-
-static __init void
-cris_ide_reset(unsigned val)
-{
-	reg_ata_rw_ctrl0 ctrl0 = {0};
-	ctrl0.rst = val ? regk_ata_active : regk_ata_inactive;
-	REG_WR(ata, regi_ata, rw_ctrl0, ctrl0);
-}
-
-static __init void
-cris_ide_init(void)
-{
-	reg_ata_rw_ctrl0 ctrl0 = {0};
-	reg_ata_rw_intr_mask intr_mask = {0};
-
-	ctrl0.en = regk_ata_yes;
-	REG_WR(ata, regi_ata, rw_ctrl0, ctrl0);
-
-	intr_mask.bus0 = regk_ata_yes;
-	intr_mask.bus1 = regk_ata_yes;
-	intr_mask.bus2 = regk_ata_yes;
-	intr_mask.bus3 = regk_ata_yes;
-
-	REG_WR(ata, regi_ata, rw_intr_mask, intr_mask);
-
-	crisv32_request_dma(2, "ETRAX FS built-in ATA", DMA_VERBOSE_ON_ERROR, 0, dma_ata);
-	crisv32_request_dma(3, "ETRAX FS built-in ATA", DMA_VERBOSE_ON_ERROR, 0, dma_ata);
-
-	crisv32_pinmux_alloc_fixed(pinmux_ata);
-	crisv32_pinmux_alloc_fixed(pinmux_ata0);
-	crisv32_pinmux_alloc_fixed(pinmux_ata1);
-	crisv32_pinmux_alloc_fixed(pinmux_ata2);
-	crisv32_pinmux_alloc_fixed(pinmux_ata3);
-
-	DMA_RESET(regi_dma2);
-	DMA_ENABLE(regi_dma2);
-	DMA_RESET(regi_dma3);
-	DMA_ENABLE(regi_dma3);
-
-	DMA_WR_CMD (regi_dma2, regk_dma_set_w_size2);
-	DMA_WR_CMD (regi_dma3, regk_dma_set_w_size2);
-}
-
-static dma_descr_context mycontext __attribute__ ((__aligned__(32)));
-
-#define cris_dma_descr_type dma_descr_data
-#define cris_pio_read regk_ata_rd
-#define cris_ultra_mask 0x7
-#define MAX_DESCR_SIZE 0xffffffffUL
-
-static unsigned long
-cris_ide_get_reg(unsigned long reg)
-{
-	return (reg & 0x0e000000) >> 25;
-}
-
-static void
-cris_ide_fill_descriptor(cris_dma_descr_type *d, void* buf, unsigned int len, int last)
-{
-	d->buf = (char*)virt_to_phys(buf);
-	d->after = d->buf + len;
-	d->eol = last;
-}
-
-static void
-cris_ide_start_dma(ide_drive_t *drive, cris_dma_descr_type *d, int dir,int type,int len)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
-					       hwif->io_ports.data_addr);
-	reg_ata_rw_trf_cnt trf_cnt = {0};
-
-	mycontext.saved_data = (dma_descr_data*)virt_to_phys(d);
-	mycontext.saved_data_buf = d->buf;
-	/* start the dma channel */
-	DMA_START_CONTEXT(dir ? regi_dma3 : regi_dma2, virt_to_phys(&mycontext));
-
-	/* initiate a multi word dma read using PIO handshaking */
-	trf_cnt.cnt = len >> 1;
-	/* Due to a "feature" the transfer count has to be one extra word for UDMA. */
-	if (type == TYPE_UDMA)
-		trf_cnt.cnt++;
-	REG_WR(ata, regi_ata, rw_trf_cnt, trf_cnt);
-
-	ctrl2.rw = dir ? regk_ata_rd : regk_ata_wr;
-	ctrl2.trf_mode = regk_ata_dma;
-	ctrl2.hsh = type == TYPE_PIO ? regk_ata_pio :
-	            type == TYPE_DMA ? regk_ata_dma : regk_ata_udma;
-	ctrl2.multi = regk_ata_yes;
-	ctrl2.dma_size = regk_ata_word;
-	REG_WR(ata, regi_ata, rw_ctrl2, ctrl2);
-}
-
-static void
-cris_ide_wait_dma(int dir)
-{
-	reg_dma_rw_stat status;
-	do
-	{
-		status = REG_RD(dma, dir ? regi_dma3 : regi_dma2, rw_stat);
-	} while(status.list_state != regk_dma_data_at_eol);
-}
-
-static int cris_dma_test_irq(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	int intr = REG_RD_INT(ata, regi_ata, r_intr);
-
-	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
-					       hwif->io_ports.data_addr);
-
-	return intr & (1 << ctrl2.sel) ? 1 : 0;
-}
-
-static void cris_ide_initialize_dma(int dir)
-{
-}
-
-#else
-/* CRISv10 specifics */
-#include <asm/arch/svinto.h>
-#include <asm/arch/io_interface_mux.h>
-
-/* PIO timing (in R_ATA_CONFIG)
- *
- *                        _____________________________
- * ADDRESS :     ________/
- *
- *                            _______________
- * DIOR    :     ____________/               \__________
- *
- *                               _______________
- * DATA    :     XXXXXXXXXXXXXXXX_______________XXXXXXXX
- *
- *
- * DIOR is unbuffered while address and data is buffered.
- * This creates two problems:
- * 1. The DIOR pulse is to early (because it is unbuffered)
- * 2. The rise time of DIOR is long
- *
- * There are at least three different plausible solutions
- * 1. Use a pad capable of larger currents in Etrax
- * 2. Use an external buffer
- * 3. Make the strobe pulse longer
- *
- * Some of the strobe timings below are modified to compensate
- * for this. This implies a slight performance decrease.
- *
- * THIS SHOULD NEVER BE CHANGED!
- *
- * TODO: Is this true for the latest LX boards still ?
- */
-
-#define ATA_UDMA2_CYC    0 /* No UDMA supported, just to make it compile. */
-#define ATA_UDMA2_DVS    0
-#define ATA_UDMA1_CYC    0
-#define ATA_UDMA1_DVS    0
-#define ATA_UDMA0_CYC    0
-#define ATA_UDMA0_DVS    0
-#define ATA_DMA2_STROBE  4
-#define ATA_DMA2_HOLD    0
-#define ATA_DMA1_STROBE  4
-#define ATA_DMA1_HOLD    1
-#define ATA_DMA0_STROBE 12
-#define ATA_DMA0_HOLD    9
-#define ATA_PIO4_SETUP   1
-#define ATA_PIO4_STROBE  5
-#define ATA_PIO4_HOLD    0
-#define ATA_PIO3_SETUP   1
-#define ATA_PIO3_STROBE  5
-#define ATA_PIO3_HOLD    1
-#define ATA_PIO2_SETUP   1
-#define ATA_PIO2_STROBE  6
-#define ATA_PIO2_HOLD    2
-#define ATA_PIO1_SETUP   2
-#define ATA_PIO1_STROBE 11
-#define ATA_PIO1_HOLD    4
-#define ATA_PIO0_SETUP   4
-#define ATA_PIO0_STROBE 19
-#define ATA_PIO0_HOLD    4
-
-int
-cris_ide_ack_intr(ide_hwif_t* hwif)
-{
-	return 1;
-}
-
-static inline int
-cris_ide_busy(void)
-{
-	return *R_ATA_STATUS_DATA & IO_MASK(R_ATA_STATUS_DATA, busy) ;
-}
-
-static inline int
-cris_ide_ready(void)
-{
-	return *R_ATA_STATUS_DATA & IO_MASK(R_ATA_STATUS_DATA, tr_rdy) ;
-}
-
-static inline int
-cris_ide_data_available(unsigned short* data)
-{
-	unsigned long status = *R_ATA_STATUS_DATA;
-	*data = (unsigned short)status;
-	return status & IO_MASK(R_ATA_STATUS_DATA, dav);
-}
-
-static void
-cris_ide_write_command(unsigned long command)
-{
-	*R_ATA_CTRL_DATA = command;
-}
-
-static void
-cris_ide_set_speed(int type, int setup, int strobe, int hold)
-{
-	static int pio_setup = ATA_PIO4_SETUP;
-	static int pio_strobe = ATA_PIO4_STROBE;
-	static int pio_hold = ATA_PIO4_HOLD;
-	static int dma_strobe = ATA_DMA2_STROBE;
-	static int dma_hold = ATA_DMA2_HOLD;
-
-	if (type == TYPE_PIO) {
-		pio_setup = setup;
-		pio_strobe = strobe;
-		pio_hold = hold;
-	} else if (type == TYPE_DMA) {
-		dma_strobe = strobe;
-	  dma_hold = hold;
-	}
-	*R_ATA_CONFIG = ( IO_FIELD( R_ATA_CONFIG, enable, 1 ) |
-	  IO_FIELD( R_ATA_CONFIG, dma_strobe, dma_strobe ) |
-		IO_FIELD( R_ATA_CONFIG, dma_hold,   dma_hold ) |
-		IO_FIELD( R_ATA_CONFIG, pio_setup,  pio_setup ) |
-		IO_FIELD( R_ATA_CONFIG, pio_strobe, pio_strobe ) |
-		IO_FIELD( R_ATA_CONFIG, pio_hold,   pio_hold ) );
-}
-
-static unsigned long
-cris_ide_base_address(int bus)
-{
-	return IO_FIELD(R_ATA_CTRL_DATA, sel, bus);
-}
-
-static unsigned long
-cris_ide_reg_addr(unsigned long addr, int cs0, int cs1)
-{
-	return IO_FIELD(R_ATA_CTRL_DATA, addr, addr) |
-	       IO_FIELD(R_ATA_CTRL_DATA, cs0, cs0) |
-	       IO_FIELD(R_ATA_CTRL_DATA, cs1, cs1);
-}
-
-static __init void
-cris_ide_reset(unsigned val)
-{
-#ifdef CONFIG_ETRAX_IDE_G27_RESET
-	REG_SHADOW_SET(R_PORT_G_DATA, port_g_data_shadow, 27, val);
-#endif
-#ifdef CONFIG_ETRAX_IDE_PB7_RESET
-	port_pb_dir_shadow = port_pb_dir_shadow |
-		IO_STATE(R_PORT_PB_DIR, dir7, output);
-	*R_PORT_PB_DIR = port_pb_dir_shadow;
-	REG_SHADOW_SET(R_PORT_PB_DATA, port_pb_data_shadow, 7, val);
-#endif
-}
-
-static __init void
-cris_ide_init(void)
-{
-	volatile unsigned int dummy;
-
-	*R_ATA_CTRL_DATA = 0;
-	*R_ATA_TRANSFER_CNT = 0;
-	*R_ATA_CONFIG = 0;
-
-	if (cris_request_io_interface(if_ata, "ETRAX100LX IDE")) {
-		printk(KERN_CRIT "ide: Failed to get IO interface\n");
-		return;
-	} else if (cris_request_dma(ATA_TX_DMA_NBR,
-		                          "ETRAX100LX IDE TX",
-		                          DMA_VERBOSE_ON_ERROR,
-		                          dma_ata)) {
-		cris_free_io_interface(if_ata);
-		printk(KERN_CRIT "ide: Failed to get Tx DMA channel\n");
-		return;
-	} else if (cris_request_dma(ATA_RX_DMA_NBR,
-		                          "ETRAX100LX IDE RX",
-		                          DMA_VERBOSE_ON_ERROR,
-		                          dma_ata)) {
-		cris_free_dma(ATA_TX_DMA_NBR, "ETRAX100LX IDE Tx");
-		cris_free_io_interface(if_ata);
-		printk(KERN_CRIT "ide: Failed to get Rx DMA channel\n");
-		return;
-	}
-
-	/* make a dummy read to set the ata controller in a proper state */
-	dummy = *R_ATA_STATUS_DATA;
-
-	*R_ATA_CONFIG = ( IO_FIELD( R_ATA_CONFIG, enable, 1 ));
-	*R_ATA_CTRL_DATA = ( IO_STATE( R_ATA_CTRL_DATA, rw,   read) |
-	                     IO_FIELD( R_ATA_CTRL_DATA, addr, 1   ) );
-
-	while(*R_ATA_STATUS_DATA & IO_MASK(R_ATA_STATUS_DATA, busy)); /* wait for busy flag*/
-
-	*R_IRQ_MASK0_SET = ( IO_STATE( R_IRQ_MASK0_SET, ata_irq0, set ) |
-	                     IO_STATE( R_IRQ_MASK0_SET, ata_irq1, set ) |
-	                     IO_STATE( R_IRQ_MASK0_SET, ata_irq2, set ) |
-	                     IO_STATE( R_IRQ_MASK0_SET, ata_irq3, set ) );
-
-	/* reset the dma channels we will use */
-
-	RESET_DMA(ATA_TX_DMA_NBR);
-	RESET_DMA(ATA_RX_DMA_NBR);
-	WAIT_DMA(ATA_TX_DMA_NBR);
-	WAIT_DMA(ATA_RX_DMA_NBR);
-}
-
-#define cris_dma_descr_type etrax_dma_descr
-#define cris_pio_read IO_STATE(R_ATA_CTRL_DATA, rw, read)
-#define cris_ultra_mask 0x0
-#define MAX_DESCR_SIZE 0x10000UL
-
-static unsigned long
-cris_ide_get_reg(unsigned long reg)
-{
-	return (reg & 0x0e000000) >> 25;
-}
-
-static void
-cris_ide_fill_descriptor(cris_dma_descr_type *d, void* buf, unsigned int len, int last)
-{
-	d->buf = virt_to_phys(buf);
-	d->sw_len = len == MAX_DESCR_SIZE ? 0 : len;
-	if (last)
-		d->ctrl |= d_eol;
-}
-
-static void cris_ide_start_dma(ide_drive_t *drive, cris_dma_descr_type *d, int dir, int type, int len)
-{
-	unsigned long cmd;
-
-	if (dir) {
-		/* need to do this before RX DMA due to a chip bug
-		 * it is enough to just flush the part of the cache that
-		 * corresponds to the buffers we start, but since HD transfers
-		 * usually are more than 8 kB, it is easier to optimize for the
-		 * normal case and just flush the entire cache. its the only
-		 * way to be sure! (OB movie quote)
-		 */
-		flush_etrax_cache();
-		*R_DMA_CH3_FIRST = virt_to_phys(d);
-		*R_DMA_CH3_CMD   = IO_STATE(R_DMA_CH3_CMD, cmd, start);
-
-	} else {
-		*R_DMA_CH2_FIRST = virt_to_phys(d);
-		*R_DMA_CH2_CMD   = IO_STATE(R_DMA_CH2_CMD, cmd, start);
-	}
-
-	/* initiate a multi word dma read using DMA handshaking */
-
-	*R_ATA_TRANSFER_CNT =
-		IO_FIELD(R_ATA_TRANSFER_CNT, count, len >> 1);
-
-	cmd = dir ? IO_STATE(R_ATA_CTRL_DATA, rw, read) : IO_STATE(R_ATA_CTRL_DATA, rw, write);
-	cmd |= type == TYPE_PIO ? IO_STATE(R_ATA_CTRL_DATA, handsh, pio) :
-	                          IO_STATE(R_ATA_CTRL_DATA, handsh, dma);
-	*R_ATA_CTRL_DATA =
-		cmd |
-		IO_FIELD(R_ATA_CTRL_DATA, data,
-			 drive->hwif->io_ports.data_addr) |
-		IO_STATE(R_ATA_CTRL_DATA, src_dst,  dma)  |
-		IO_STATE(R_ATA_CTRL_DATA, multi,    on)   |
-		IO_STATE(R_ATA_CTRL_DATA, dma_size, word);
-}
-
-static void
-cris_ide_wait_dma(int dir)
-{
-	if (dir)
-		WAIT_DMA(ATA_RX_DMA_NBR);
-	else
-		WAIT_DMA(ATA_TX_DMA_NBR);
-}
-
-static int cris_dma_test_irq(ide_drive_t *drive)
-{
-	int intr = *R_IRQ_MASK0_RD;
-	int bus = IO_EXTRACT(R_ATA_CTRL_DATA, sel,
-			     drive->hwif->io_ports.data_addr);
-
-	return intr & (1 << (bus + IO_BITNR(R_IRQ_MASK0_RD, ata_irq0))) ? 1 : 0;
-}
-
-
-static void cris_ide_initialize_dma(int dir)
-{
-	if (dir)
-	{
-		RESET_DMA(ATA_RX_DMA_NBR); /* sometimes the DMA channel get stuck so we need to do this */
-		WAIT_DMA(ATA_RX_DMA_NBR);
-	}
-	else
-	{
-		RESET_DMA(ATA_TX_DMA_NBR); /* sometimes the DMA channel get stuck so we need to do this */
-		WAIT_DMA(ATA_TX_DMA_NBR);
-	}
-}
-
-#endif
-
-void
-cris_ide_outw(unsigned short data, unsigned long reg) {
-	int timeleft;
-
-	LOWDB(printk("ow: data 0x%x, reg 0x%x\n", data, reg));
-
-	/* note the lack of handling any timeouts. we stop waiting, but we don't
-	 * really notify anybody.
-	 */
-
-	timeleft = IDE_REGISTER_TIMEOUT;
-	/* wait for busy flag */
-	do {
-		timeleft--;
-	} while(timeleft && cris_ide_busy());
-
-	/*
-	 * Fall through at a timeout, so the ongoing command will be
-	 * aborted by the write below, which is expected to be a dummy
-	 * command to the command register.  This happens when a faulty
-	 * drive times out on a command.  See comment on timeout in
-	 * INB.
-	 */
-	if(!timeleft)
-		printk("ATA timeout reg 0x%lx := 0x%x\n", reg, data);
-
-	cris_ide_write_command(reg|data); /* write data to the drive's register */
-
-	timeleft = IDE_REGISTER_TIMEOUT;
-	/* wait for transmitter ready */
-	do {
-		timeleft--;
-	} while(timeleft && !cris_ide_ready());
-}
-
-void
-cris_ide_outb(unsigned char data, unsigned long reg)
-{
-	cris_ide_outw(data, reg);
-}
-
-void
-cris_ide_outbsync(ide_drive_t *drive, u8 addr, unsigned long port)
-{
-	cris_ide_outw(addr, port);
-}
-
-unsigned short
-cris_ide_inw(unsigned long reg) {
-	int timeleft;
-	unsigned short val;
-
-	timeleft = IDE_REGISTER_TIMEOUT;
-	/* wait for busy flag */
-	do {
-		timeleft--;
-	} while(timeleft && cris_ide_busy());
-
-	if(!timeleft) {
-		/*
-		 * If we're asked to read the status register, like for
-		 * example when a command does not complete for an
-		 * extended time, but the ATA interface is stuck in a
-		 * busy state at the *ETRAX* ATA interface level (as has
-		 * happened repeatedly with at least one bad disk), then
-		 * the best thing to do is to pretend that we read
-		 * "busy" in the status register, so the IDE driver will
-		 * time-out, abort the ongoing command and perform a
-		 * reset sequence.  Note that the subsequent OUT_BYTE
-		 * call will also timeout on busy, but as long as the
-		 * write is still performed, everything will be fine.
-		 */
-		if (cris_ide_get_reg(reg) == 7)
-			return BUSY_STAT;
-		else
-			/* For other rare cases we assume 0 is good enough.  */
-			return 0;
-	}
-
-	cris_ide_write_command(reg | cris_pio_read);
-
-	timeleft = IDE_REGISTER_TIMEOUT;
-	/* wait for available */
-	do {
-		timeleft--;
-	} while(timeleft && !cris_ide_data_available(&val));
-
-	if(!timeleft)
-		return 0;
-
-	LOWDB(printk("inb: 0x%x from reg 0x%x\n", val & 0xff, reg));
-
-	return val;
-}
-
-unsigned char
-cris_ide_inb(unsigned long reg)
-{
-	return (unsigned char)cris_ide_inw(reg);
-}
-
-static void cris_ide_input_data (ide_drive_t *drive, void *, unsigned int);
-static void cris_ide_output_data (ide_drive_t *drive, void *, unsigned int);
-static void cris_atapi_input_bytes(ide_drive_t *drive, void *, unsigned int);
-static void cris_atapi_output_bytes(ide_drive_t *drive, void *, unsigned int);
-
-static void cris_dma_host_set(ide_drive_t *drive, int on)
-{
-}
-
-static void cris_set_pio_mode(ide_drive_t *drive, const u8 pio)
-{
-	int setup, strobe, hold;
-
-	switch(pio)
-	{
-		case 0:
-			setup = ATA_PIO0_SETUP;
-			strobe = ATA_PIO0_STROBE;
-			hold = ATA_PIO0_HOLD;
-			break;
-		case 1:
-			setup = ATA_PIO1_SETUP;
-			strobe = ATA_PIO1_STROBE;
-			hold = ATA_PIO1_HOLD;
-			break;
-		case 2:
-			setup = ATA_PIO2_SETUP;
-			strobe = ATA_PIO2_STROBE;
-			hold = ATA_PIO2_HOLD;
-			break;
-		case 3:
-			setup = ATA_PIO3_SETUP;
-			strobe = ATA_PIO3_STROBE;
-			hold = ATA_PIO3_HOLD;
-			break;
-		case 4:
-			setup = ATA_PIO4_SETUP;
-			strobe = ATA_PIO4_STROBE;
-			hold = ATA_PIO4_HOLD;
-			break;
-		default:
-			return;
-	}
-
-	cris_ide_set_speed(TYPE_PIO, setup, strobe, hold);
-}
-
-static void cris_set_dma_mode(ide_drive_t *drive, const u8 speed)
-{
-	int cyc = 0, dvs = 0, strobe = 0, hold = 0;
-
-	switch(speed)
-	{
-		case XFER_UDMA_0:
-			cyc = ATA_UDMA0_CYC;
-			dvs = ATA_UDMA0_DVS;
-			break;
-		case XFER_UDMA_1:
-			cyc = ATA_UDMA1_CYC;
-			dvs = ATA_UDMA1_DVS;
-			break;
-		case XFER_UDMA_2:
-			cyc = ATA_UDMA2_CYC;
-			dvs = ATA_UDMA2_DVS;
-			break;
-		case XFER_MW_DMA_0:
-			strobe = ATA_DMA0_STROBE;
-			hold = ATA_DMA0_HOLD;
-			break;
-		case XFER_MW_DMA_1:
-			strobe = ATA_DMA1_STROBE;
-			hold = ATA_DMA1_HOLD;
-			break;
-		case XFER_MW_DMA_2:
-			strobe = ATA_DMA2_STROBE;
-			hold = ATA_DMA2_HOLD;
-			break;
-	}
-
-	if (speed >= XFER_UDMA_0)
-		cris_ide_set_speed(TYPE_UDMA, cyc, dvs, 0);
-	else
-		cris_ide_set_speed(TYPE_DMA, 0, strobe, hold);
-}
-
-static void __init cris_setup_ports(hw_regs_t *hw, unsigned long base)
-{
-	int i;
-
-	memset(hw, 0, sizeof(*hw));
-
-	for (i = 0; i <= 7; i++)
-		hw->io_ports_array[i] = base + cris_ide_reg_addr(i, 0, 1);
-
-	/*
-	 * the IDE control register is at ATA address 6,
-	 * with CS1 active instead of CS0
-	 */
-	hw->io_ports.ctl_addr = base + cris_ide_reg_addr(6, 1, 0);
-
-	hw->irq = ide_default_irq(0);
-	hw->ack_intr = cris_ide_ack_intr;
-}
-
-static const struct ide_port_ops cris_port_ops = {
-	.set_pio_mode		= cris_set_pio_mode,
-	.set_dma_mode		= cris_set_dma_mode,
-};
-
-static const struct ide_dma_ops cris_dma_ops;
-
-static const struct ide_port_info cris_port_info __initdata = {
-	.chipset		= ide_etrax100,
-	.port_ops		= &cris_port_ops,
-	.dma_ops		= &cris_dma_ops,
-	.host_flags		= IDE_HFLAG_NO_ATAPI_DMA |
-				  IDE_HFLAG_NO_DMA, /* no SFF-style DMA */
-	.pio_mask		= ATA_PIO4,
-	.udma_mask		= cris_ultra_mask,
-	.mwdma_mask		= ATA_MWDMA2,
-};
-
-static int __init init_e100_ide(void)
-{
-	hw_regs_t hw;
-	int h;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-
-	printk("ide: ETRAX FS built-in ATA DMA controller\n");
-
-	for (h = 0; h < 4; h++) {
-		ide_hwif_t *hwif = NULL;
-
-		cris_setup_ports(&hw, cris_ide_base_address(h));
-
-		hwif = ide_find_port();
-		if (hwif == NULL)
-			continue;
-		ide_init_port_data(hwif, hwif->index);
-		ide_init_port_hw(hwif, &hw);
-
-		hwif->ata_input_data = &cris_ide_input_data;
-		hwif->ata_output_data = &cris_ide_output_data;
-		hwif->atapi_input_bytes = &cris_atapi_input_bytes;
-		hwif->atapi_output_bytes = &cris_atapi_output_bytes;
-		hwif->OUTB = &cris_ide_outb;
-		hwif->OUTW = &cris_ide_outw;
-		hwif->OUTBSYNC = &cris_ide_outbsync;
-		hwif->INB = &cris_ide_inb;
-		hwif->INW = &cris_ide_inw;
-		hwif->cbl = ATA_CBL_PATA40;
-
-		idx[h] = hwif->index;
-	}
-
-	/* Reset pulse */
-	cris_ide_reset(0);
-	udelay(25);
-	cris_ide_reset(1);
-
-	cris_ide_init();
-
-	cris_ide_set_speed(TYPE_PIO, ATA_PIO4_SETUP, ATA_PIO4_STROBE, ATA_PIO4_HOLD);
-	cris_ide_set_speed(TYPE_DMA, 0, ATA_DMA2_STROBE, ATA_DMA2_HOLD);
-	cris_ide_set_speed(TYPE_UDMA, ATA_UDMA2_CYC, ATA_UDMA2_DVS, 0);
-
-	ide_device_add(idx, &cris_port_info);
-
-	return 0;
-}
-
-static cris_dma_descr_type mydescr __attribute__ ((__aligned__(16)));
-
-/*
- * The following routines are mainly used by the ATAPI drivers.
- *
- * These routines will round up any request for an odd number of bytes,
- * so if an odd bytecount is specified, be sure that there's at least one
- * extra byte allocated for the buffer.
- */
-static void
-cris_atapi_input_bytes (ide_drive_t *drive, void *buffer, unsigned int bytecount)
-{
-	D(printk("atapi_input_bytes, buffer 0x%x, count %d\n",
-	         buffer, bytecount));
-
-	if(bytecount & 1) {
-		printk("warning, odd bytecount in cdrom_in_bytes = %d.\n", bytecount);
-		bytecount++; /* to round off */
-	}
-
-	/* setup DMA and start transfer */
-
-	cris_ide_fill_descriptor(&mydescr, buffer, bytecount, 1);
-	cris_ide_start_dma(drive, &mydescr, 1, TYPE_PIO, bytecount);
-
-	/* wait for completion */
-	LED_DISK_READ(1);
-	cris_ide_wait_dma(1);
-	LED_DISK_READ(0);
-}
-
-static void
-cris_atapi_output_bytes (ide_drive_t *drive, void *buffer, unsigned int bytecount)
-{
-	D(printk("atapi_output_bytes, buffer 0x%x, count %d\n",
-	         buffer, bytecount));
-
-	if(bytecount & 1) {
-		printk("odd bytecount %d in atapi_out_bytes!\n", bytecount);
-		bytecount++;
-	}
-
-	cris_ide_fill_descriptor(&mydescr, buffer, bytecount, 1);
-	cris_ide_start_dma(drive, &mydescr, 0, TYPE_PIO, bytecount);
-
-	/* wait for completion */
-
-	LED_DISK_WRITE(1);
-	LED_DISK_READ(1);
-	cris_ide_wait_dma(0);
-	LED_DISK_WRITE(0);
-}
-
-/*
- * This is used for most PIO data transfers *from* the IDE interface
- */
-static void
-cris_ide_input_data (ide_drive_t *drive, void *buffer, unsigned int wcount)
-{
-	cris_atapi_input_bytes(drive, buffer, wcount << 2);
-}
-
-/*
- * This is used for most PIO data transfers *to* the IDE interface
- */
-static void
-cris_ide_output_data (ide_drive_t *drive, void *buffer, unsigned int wcount)
-{
-	cris_atapi_output_bytes(drive, buffer, wcount << 2);
-}
-
-/* we only have one DMA channel on the chip for ATA, so we can keep these statically */
-static cris_dma_descr_type ata_descrs[MAX_DMA_DESCRS] __attribute__ ((__aligned__(16)));
-static unsigned int ata_tot_size;
-
-/*
- * cris_ide_build_dmatable() prepares a dma request.
- * Returns 0 if all went okay, returns 1 otherwise.
- */
-static int cris_ide_build_dmatable (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct scatterlist* sg;
-	struct request *rq  = drive->hwif->hwgroup->rq;
-	unsigned long size, addr;
-	unsigned int count = 0;
-	int i = 0;
-
-	sg = hwif->sg_table;
-
-	ata_tot_size = 0;
-
-	ide_map_sg(drive, rq);
-	i = hwif->sg_nents;
-
-	while(i) {
-		/*
-		 * Determine addr and size of next buffer area.  We assume that
-		 * individual virtual buffers are always composed linearly in
-		 * physical memory.  For example, we assume that any 8kB buffer
-		 * is always composed of two adjacent physical 4kB pages rather
-		 * than two possibly non-adjacent physical 4kB pages.
-		 */
-		/* group sequential buffers into one large buffer */
-		addr = sg_phys(sg);
-		size = sg_dma_len(sg);
-		while (--i) {
-			sg = sg_next(sg);
-			if ((addr + size) != sg_phys(sg))
-				break;
-			size += sg_dma_len(sg);
-		}
-
-		/* did we run out of descriptors? */
-
-		if(count >= MAX_DMA_DESCRS) {
-			printk("%s: too few DMA descriptors\n", drive->name);
-			return 1;
-		}
-
-		/* however, this case is more difficult - rw_trf_cnt cannot be more
-		   than 65536 words per transfer, so in that case we need to either
-		   1) use a DMA interrupt to re-trigger rw_trf_cnt and continue with
-		      the descriptors, or
-		   2) simply do the request here, and get dma_intr to only ide_end_request on
-		      those blocks that were actually set-up for transfer.
-		*/
-
-		if(ata_tot_size + size > 131072) {
-			printk("too large total ATA DMA request, %d + %d!\n", ata_tot_size, (int)size);
-			return 1;
-		}
-
-		/* If size > MAX_DESCR_SIZE it has to be splitted into new descriptors. Since we
-                   don't handle size > 131072 only one split is necessary */
-
-		if(size > MAX_DESCR_SIZE) {
-			cris_ide_fill_descriptor(&ata_descrs[count], (void*)addr, MAX_DESCR_SIZE, 0);
-			count++;
-			ata_tot_size += MAX_DESCR_SIZE;
-			size -= MAX_DESCR_SIZE;
-			addr += MAX_DESCR_SIZE;
-		}
-
-		cris_ide_fill_descriptor(&ata_descrs[count], (void*)addr, size,i ? 0 : 1);
-		count++;
-		ata_tot_size += size;
-	}
-
-	if (count) {
-		/* return and say all is ok */
-		return 0;
-	}
-
-	printk("%s: empty DMA table?\n", drive->name);
-	return 1;	/* let the PIO routines handle this weirdness */
-}
-
-/*
- * cris_dma_intr() is the handler for disk read/write DMA interrupts
- */
-static ide_startstop_t cris_dma_intr (ide_drive_t *drive)
-{
-	LED_DISK_READ(0);
-	LED_DISK_WRITE(0);
-
-	return ide_dma_intr(drive);
-}
-
-/*
- * Functions below initiates/aborts DMA read/write operations on a drive.
- *
- * The caller is assumed to have selected the drive and programmed the drive's
- * sector address using CHS or LBA.  All that remains is to prepare for DMA
- * and then issue the actual read/write DMA/PIO command to the drive.
- *
- * For ATAPI devices, we just prepare for DMA and return. The caller should
- * then issue the packet command to the drive and call us again with
- * cris_dma_start afterwards.
- *
- * Returns 0 if all went well.
- * Returns 1 if DMA read/write could not be started, in which case
- * the caller should revert to PIO for the current request.
- */
-
-static int cris_dma_end(ide_drive_t *drive)
-{
-	drive->waiting_for_dma = 0;
-	return 0;
-}
-
-static int cris_dma_setup(ide_drive_t *drive)
-{
-	struct request *rq = drive->hwif->hwgroup->rq;
-
-	cris_ide_initialize_dma(!rq_data_dir(rq));
-	if (cris_ide_build_dmatable (drive)) {
-		ide_map_sg(drive, rq);
-		return 1;
-	}
-
-	drive->waiting_for_dma = 1;
-	return 0;
-}
-
-static void cris_dma_exec_cmd(ide_drive_t *drive, u8 command)
-{
-	ide_execute_command(drive, command, &cris_dma_intr, WAIT_CMD, NULL);
-}
-
-static void cris_dma_start(ide_drive_t *drive)
-{
-	struct request *rq = drive->hwif->hwgroup->rq;
-	int writing = rq_data_dir(rq);
-	int type = TYPE_DMA;
-
-	if (drive->current_speed >= XFER_UDMA_0)
-		type = TYPE_UDMA;
-
-	cris_ide_start_dma(drive, &ata_descrs[0], writing ? 0 : 1, type, ata_tot_size);
-
-	if (writing) {
-		LED_DISK_WRITE(1);
-	} else {
-		LED_DISK_READ(1);
-	}
-}
-
-static const struct ide_dma_ops cris_dma_ops = {
-	.dma_host_set		= cris_dma_host_set,
-	.dma_setup		= cris_dma_setup,
-	.dma_exec_cmd		= cris_dma_exec_cmd,
-	.dma_start		= cris_dma_start,
-	.dma_end		= cris_dma_end,
-	.dma_test_irq		= cris_dma_test_irq,
-};
-
-module_init(init_e100_ide);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/ide/h8300/ide-h8300.c b/drivers/ide/h8300/ide-h8300.c
index fd23f12..ecf53bb 100644
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -42,6 +42,91 @@ static u16 mm_inw(unsigned long a)
 	return r;
 }
 
+static void h8300_tf_load(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+
+	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+		HIHI = 0xFF;
+
+	ide_set_irq(drive, 1);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
+		mm_outw((tf->hob_data << 8) | tf->data, io_ports->data_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+		outb(tf->hob_feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+		outb(tf->hob_nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+		outb(tf->hob_lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+		outb(tf->hob_lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+		outb(tf->hob_lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+		outb(tf->feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+		outb(tf->nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+		outb(tf->lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+		outb(tf->lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+		outb(tf->lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		outb((tf->device & HIHI) | drive->select.all,
+		     io_ports->device_addr);
+}
+
+static void h8300_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data = mm_inw(io_ports->data_addr);
+
+		tf->data = data & 0xff;
+		tf->hob_data = (data >> 8) & 0xff;
+	}
+
+	/* be sure we're looking at the low order bits */
+	outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+
+	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+		tf->nsect  = inb(io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+		tf->lbal   = inb(io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+		tf->lbam   = inb(io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+		tf->lbah   = inb(io_ports->lbah_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+		tf->device = inb(io_ports->device_addr);
+
+	if (task->tf_flags & IDE_TFLAG_LBA48) {
+		outb(drive->ctl | 0x80, io_ports->ctl_addr);
+
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+			tf->hob_feature = inb(io_ports->feature_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+			tf->hob_nsect   = inb(io_ports->nsect_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+			tf->hob_lbal    = inb(io_ports->lbal_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+			tf->hob_lbam    = inb(io_ports->lbam_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+			tf->hob_lbah    = inb(io_ports->lbah_addr);
+	}
+}
+
 static void mm_outsw(unsigned long addr, void *buf, u32 len)
 {
 	unsigned short *bp = (unsigned short *)buf;
@@ -56,6 +141,18 @@ static void mm_insw(unsigned long addr, void *buf, u32 len)
 		*bp = bswap(*(volatile u16 *)addr);
 }
 
+static void h8300_input_data(ide_drive_t *drive, struct request *rq,
+			     void *buf, unsigned int len)
+{
+	mm_insw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
+static void h8300_output_data(ide_drive_t *drive, struct request *rq,
+			      void *buf, unsigned int len)
+{
+	mm_outsw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
 #define H8300_IDE_GAP (2)
 
 static inline void hw_setup(hw_regs_t *hw)
@@ -74,12 +171,11 @@ static inline void hwif_setup(ide_hwif_t *hwif)
 {
 	default_hwif_iops(hwif);
 
-	hwif->OUTW  = mm_outw;
-	hwif->OUTSW = mm_outsw;
-	hwif->INW   = mm_inw;
-	hwif->INSW  = mm_insw;
-	hwif->OUTSL = NULL;
-	hwif->INSL  = NULL;
+	hwif->tf_load = h8300_tf_load;
+	hwif->tf_read = h8300_tf_read;
+
+	hwif->input_data  = h8300_input_data;
+	hwif->output_data = h8300_output_data;
 }
 
 static int __init h8300_ide_init(void)
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index b34fd2b..fe9df38 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -142,7 +142,6 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 {
 	unsigned long sector;
 	unsigned long bio_sectors;
-	unsigned long valid;
 	struct cdrom_info *info = drive->driver_data;
 
 	if (!cdrom_log_sense(drive, failed_command, sense))
@@ -173,17 +172,13 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 				 (sense->information[2] <<  8) |
 				 (sense->information[3]);
 
-			bio_sectors = bio_sectors(failed_command->bio);
-			if (bio_sectors < 4)
-				bio_sectors = 4;
 			if (drive->queue->hardsect_size == 2048)
 				/* device sector size is 2K */
 				sector <<= 2;
+
+			bio_sectors = max(bio_sectors(failed_command->bio), 4U);
 			sector &= ~(bio_sectors - 1);
-			valid = (sector - failed_command->sector) << 9;
 
-			if (valid < 0)
-				valid = 0;
 			if (sector < get_capacity(info->disk) &&
 			    drive->probed_capacity - sector < 4 * 75)
 				set_capacity(info->disk, sector);
@@ -555,14 +550,7 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 				    ATAPI_WAIT_PC, cdrom_timer_expiry);
 		return ide_started;
 	} else {
-		unsigned long flags;
-
-		/* packet command */
-		spin_lock_irqsave(&ide_lock, flags);
-		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
-			       hwif->io_ports.command_addr);
-		ndelay(400);
-		spin_unlock_irqrestore(&ide_lock, flags);
+		ide_execute_pkt_cmd(drive);
 
 		return (*handler) (drive);
 	}
@@ -613,7 +601,7 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 		cmd_len = ATAPI_MIN_CDB_BYTES;
 
 	/* send the command to the device */
-	HWIF(drive)->atapi_output_bytes(drive, rq->cmd, cmd_len);
+	hwif->output_data(drive, NULL, rq->cmd, cmd_len);
 
 	/* start the DMA if need be */
 	if (info->dma)
@@ -629,7 +617,7 @@ static void ide_cd_pad_transfer(ide_drive_t *drive, xfer_func_t *xf, int len)
 {
 	while (len > 0) {
 		int dum = 0;
-		xf(drive, &dum, sizeof(dum));
+		xf(drive, NULL, &dum, sizeof(dum));
 		len -= sizeof(dum);
 	}
 }
@@ -639,7 +627,7 @@ static void ide_cd_drain_data(ide_drive_t *drive, int nsects)
 	while (nsects > 0) {
 		static char dum[SECTOR_SIZE];
 
-		drive->hwif->atapi_input_bytes(drive, dum, sizeof(dum));
+		drive->hwif->input_data(drive, NULL, dum, sizeof(dum));
 		nsects--;
 	}
 }
@@ -666,7 +654,7 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
 				drive->name, __func__);
 
-		xf = rw ? hwif->atapi_output_bytes : hwif->atapi_input_bytes;
+		xf = rw ? hwif->output_data : hwif->input_data;
 		ide_cd_pad_transfer(drive, xf, len);
 	} else  if (rw == 0 && ireason == 1) {
 		/*
@@ -1019,10 +1007,10 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 
 	if (ireason == 0) {
 		write = 1;
-		xferfunc = HWIF(drive)->atapi_output_bytes;
+		xferfunc = hwif->output_data;
 	} else {
 		write = 0;
-		xferfunc = HWIF(drive)->atapi_input_bytes;
+		xferfunc = hwif->input_data;
 	}
 
 	/* transfer data */
@@ -1061,7 +1049,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		if (blen > thislen)
 			blen = thislen;
 
-		xferfunc(drive, ptr, blen);
+		xferfunc(drive, NULL, ptr, blen);
 
 		thislen -= blen;
 		len -= blen;
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index c352cf2..653b1ad 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -464,9 +464,10 @@ int ide_dma_setup(ide_drive_t *drive)
 
 	/* PRD table */
 	if (hwif->mmio)
-		writel(hwif->dmatable_dma, (void __iomem *)hwif->dma_prdtable);
+		writel(hwif->dmatable_dma,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_TABLE_OFS));
 	else
-		outl(hwif->dmatable_dma, hwif->dma_prdtable);
+		outl(hwif->dmatable_dma, hwif->dma_base + ATA_DMA_TABLE_OFS);
 
 	/* specify r/w */
 	hwif->OUTB(reading, hwif->dma_command);
@@ -858,14 +859,8 @@ void ide_setup_dma(ide_hwif_t *hwif, unsigned long base)
 
 	if (!hwif->dma_command)
 		hwif->dma_command	= hwif->dma_base + 0;
-	if (!hwif->dma_vendor1)
-		hwif->dma_vendor1	= hwif->dma_base + 1;
 	if (!hwif->dma_status)
 		hwif->dma_status	= hwif->dma_base + 2;
-	if (!hwif->dma_vendor3)
-		hwif->dma_vendor3	= hwif->dma_base + 3;
-	if (!hwif->dma_prdtable)
-		hwif->dma_prdtable	= hwif->dma_base + 4;
 
 	hwif->dma_ops = &sff_dma_ops;
 }
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 489079b..f05fbc2 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -231,6 +231,7 @@ static int idefloppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 static void ide_floppy_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				  unsigned int bcount, int direction)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = pc->rq;
 	struct req_iterator iter;
 	struct bio_vec *bvec;
@@ -246,9 +247,9 @@ static void ide_floppy_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 
 		data = bvec_kmap_irq(bvec, &flags);
 		if (direction)
-			drive->hwif->atapi_output_bytes(drive, data, count);
+			hwif->output_data(drive, NULL, data, count);
 		else
-			drive->hwif->atapi_input_bytes(drive, data, count);
+			hwif->input_data(drive, NULL, data, count);
 		bvec_kunmap_irq(data, &flags);
 
 		bcount -= count;
@@ -261,10 +262,7 @@ static void ide_floppy_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	if (bcount) {
 		printk(KERN_ERR "%s: leftover data in %s, bcount == %d\n",
 				drive->name, __func__, bcount);
-		if (direction)
-			ide_atapi_write_zeros(drive, bcount);
-		else
-			ide_atapi_discard_data(drive, bcount);
+		ide_pad_transfer(drive, direction, bcount);
 	}
 }
 
@@ -490,7 +488,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 				printk(KERN_ERR "ide-floppy: The floppy wants "
 					"to send us more data than expected "
 					"- discarding data\n");
-				ide_atapi_discard_data(drive, bcount);
+				ide_pad_transfer(drive, 0, bcount);
 
 				ide_set_handler(drive,
 						&idefloppy_pc_intr,
@@ -503,12 +501,12 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 		}
 	}
 	if (pc->flags & PC_FLAG_WRITING)
-		xferfunc = hwif->atapi_output_bytes;
+		xferfunc = hwif->output_data;
 	else
-		xferfunc = hwif->atapi_input_bytes;
+		xferfunc = hwif->input_data;
 
 	if (pc->buf)
-		xferfunc(drive, pc->cur_pos, bcount);
+		xferfunc(drive, NULL, pc->cur_pos, bcount);
 	else
 		ide_floppy_io_buffers(drive, pc, bcount,
 				      !!(pc->flags & PC_FLAG_WRITING));
@@ -548,8 +546,10 @@ static ide_startstop_t idefloppy_transfer_pc(ide_drive_t *drive)
 
 	/* Set the interrupt routine */
 	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
+
 	/* Send the actual packet */
-	HWIF(drive)->atapi_output_bytes(drive, floppy->pc->c, 12);
+	hwif->output_data(drive, NULL, floppy->pc->c, 12);
+
 	return ide_started;
 }
 
@@ -569,7 +569,8 @@ static int idefloppy_transfer_pc2(ide_drive_t *drive)
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
 	/* Send the actual packet */
-	HWIF(drive)->atapi_output_bytes(drive, floppy->pc->c, 12);
+	drive->hwif->output_data(drive, NULL, floppy->pc->c, 12);
+
 	/* Timeout for the packet command */
 	return IDEFLOPPY_WAIT_CMD;
 }
@@ -692,7 +693,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		return ide_started;
 	} else {
 		/* Issue the packet command */
-		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports.command_addr);
+		ide_execute_pkt_cmd(drive);
 		return (*pkt_xfer_routine) (drive);
 	}
 }
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 3a2d893..788783d 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -295,49 +295,6 @@ static void ide_complete_pm_request (ide_drive_t *drive, struct request *rq)
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
-void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
-		u16 data = hwif->INW(io_ports->data_addr);
-
-		tf->data = data & 0xff;
-		tf->hob_data = (data >> 8) & 0xff;
-	}
-
-	/* be sure we're looking at the low order bits */
-	hwif->OUTB(drive->ctl & ~0x80, io_ports->ctl_addr);
-
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = hwif->INB(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = hwif->INB(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = hwif->INB(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = hwif->INB(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = hwif->INB(io_ports->device_addr);
-
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		hwif->OUTB(drive->ctl | 0x80, io_ports->ctl_addr);
-
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature = hwif->INB(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = hwif->INB(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = hwif->INB(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = hwif->INB(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = hwif->INB(io_ports->lbah_addr);
-	}
-}
-
 /**
  *	ide_end_drive_cmd	-	end an explicit drive command
  *	@drive: command 
@@ -373,7 +330,7 @@ void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
 			tf->error = err;
 			tf->status = stat;
 
-			ide_tf_read(drive, task);
+			drive->hwif->tf_read(drive, task);
 
 			if (task->tf_flags & IDE_TFLAG_DYN)
 				kfree(task);
@@ -422,7 +379,7 @@ static void try_to_flush_leftover_data (ide_drive_t *drive)
 		u32 wcount = (i > 16) ? 16 : i;
 
 		i -= wcount;
-		HWIF(drive)->ata_input_data(drive, buffer, wcount);
+		drive->hwif->input_data(drive, NULL, buffer, wcount * 4);
 	}
 }
 
@@ -502,7 +459,8 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq, u
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTB(WIN_IDLEIMMEDIATE, hwif->io_ports.command_addr);
+		hwif->OUTBSYNC(drive, WIN_IDLEIMMEDIATE,
+			       hwif->io_ports.command_addr);
 
 	if (rq->errors >= ERROR_MAX) {
 		ide_kill_rq(drive, rq);
@@ -1679,7 +1637,23 @@ void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount, u8 dma)
 	task.tf.lbam    = bcount & 0xff;
 	task.tf.lbah    = (bcount >> 8) & 0xff;
 
-	ide_tf_load(drive, &task);
+	ide_tf_dump(drive->name, &task.tf);
+	drive->hwif->tf_load(drive, &task);
 }
 
 EXPORT_SYMBOL_GPL(ide_pktcmd_tf_load);
+
+void ide_pad_transfer(ide_drive_t *drive, int write, int len)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 buf[4] = { 0 };
+
+	while (len > 0) {
+		if (write)
+			hwif->output_data(drive, NULL, buf, min(4, len));
+		else
+			hwif->input_data(drive, NULL, buf, min(4, len));
+		len -= 4;
+	}
+}
+EXPORT_SYMBOL_GPL(ide_pad_transfer);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 5425d30..57d9a9a 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -37,21 +37,6 @@ static u8 ide_inb (unsigned long port)
 	return (u8) inb(port);
 }
 
-static u16 ide_inw (unsigned long port)
-{
-	return (u16) inw(port);
-}
-
-static void ide_insw (unsigned long port, void *addr, u32 count)
-{
-	insw(port, addr, count);
-}
-
-static void ide_insl (unsigned long port, void *addr, u32 count)
-{
-	insl(port, addr, count);
-}
-
 static void ide_outb (u8 val, unsigned long port)
 {
 	outb(val, port);
@@ -62,32 +47,11 @@ static void ide_outbsync (ide_drive_t *drive, u8 addr, unsigned long port)
 	outb(addr, port);
 }
 
-static void ide_outw (u16 val, unsigned long port)
-{
-	outw(val, port);
-}
-
-static void ide_outsw (unsigned long port, void *addr, u32 count)
-{
-	outsw(port, addr, count);
-}
-
-static void ide_outsl (unsigned long port, void *addr, u32 count)
-{
-	outsl(port, addr, count);
-}
-
 void default_hwif_iops (ide_hwif_t *hwif)
 {
 	hwif->OUTB	= ide_outb;
 	hwif->OUTBSYNC	= ide_outbsync;
-	hwif->OUTW	= ide_outw;
-	hwif->OUTSW	= ide_outsw;
-	hwif->OUTSL	= ide_outsl;
 	hwif->INB	= ide_inb;
-	hwif->INW	= ide_inw;
-	hwif->INSW	= ide_insw;
-	hwif->INSL	= ide_insl;
 }
 
 /*
@@ -99,21 +63,6 @@ static u8 ide_mm_inb (unsigned long port)
 	return (u8) readb((void __iomem *) port);
 }
 
-static u16 ide_mm_inw (unsigned long port)
-{
-	return (u16) readw((void __iomem *) port);
-}
-
-static void ide_mm_insw (unsigned long port, void *addr, u32 count)
-{
-	__ide_mm_insw((void __iomem *) port, addr, count);
-}
-
-static void ide_mm_insl (unsigned long port, void *addr, u32 count)
-{
-	__ide_mm_insl((void __iomem *) port, addr, count);
-}
-
 static void ide_mm_outb (u8 value, unsigned long port)
 {
 	writeb(value, (void __iomem *) port);
@@ -124,34 +73,13 @@ static void ide_mm_outbsync (ide_drive_t *drive, u8 value, unsigned long port)
 	writeb(value, (void __iomem *) port);
 }
 
-static void ide_mm_outw (u16 value, unsigned long port)
-{
-	writew(value, (void __iomem *) port);
-}
-
-static void ide_mm_outsw (unsigned long port, void *addr, u32 count)
-{
-	__ide_mm_outsw((void __iomem *) port, addr, count);
-}
-
-static void ide_mm_outsl (unsigned long port, void *addr, u32 count)
-{
-	__ide_mm_outsl((void __iomem *) port, addr, count);
-}
-
 void default_hwif_mmiops (ide_hwif_t *hwif)
 {
 	hwif->OUTB	= ide_mm_outb;
 	/* Most systems will need to override OUTBSYNC, alas however
 	   this one is controller specific! */
 	hwif->OUTBSYNC	= ide_mm_outbsync;
-	hwif->OUTW	= ide_mm_outw;
-	hwif->OUTSW	= ide_mm_outsw;
-	hwif->OUTSL	= ide_mm_outsl;
 	hwif->INB	= ide_mm_inb;
-	hwif->INW	= ide_mm_inw;
-	hwif->INSW	= ide_mm_insw;
-	hwif->INSL	= ide_mm_insl;
 }
 
 EXPORT_SYMBOL(default_hwif_mmiops);
@@ -175,6 +103,123 @@ void SELECT_MASK (ide_drive_t *drive, int mask)
 		port_ops->maskproc(drive, mask);
 }
 
+static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+	void (*tf_outb)(u8 addr, unsigned long port);
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+
+	if (mmio)
+		tf_outb = ide_mm_outb;
+	else
+		tf_outb = ide_outb;
+
+	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+		HIHI = 0xFF;
+
+	ide_set_irq(drive, 1);
+
+	if ((task->tf_flags & IDE_TFLAG_NO_SELECT_MASK) == 0)
+		SELECT_MASK(drive, 0);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
+		u16 data = (tf->hob_data << 8) | tf->data;
+
+		if (mmio)
+			writew(data, (void __iomem *)io_ports->data_addr);
+		else
+			outw(data, io_ports->data_addr);
+	}
+
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+		tf_outb(tf->hob_feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+		tf_outb(tf->hob_nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+		tf_outb(tf->hob_lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+		tf_outb(tf->hob_lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+		tf_outb(tf->hob_lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+		tf_outb(tf->feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+		tf_outb(tf->nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+		tf_outb(tf->lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+		tf_outb(tf->lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+		tf_outb(tf->lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		tf_outb((tf->device & HIHI) | drive->select.all,
+			 io_ports->device_addr);
+}
+
+static void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+	void (*tf_outb)(u8 addr, unsigned long port);
+	u8 (*tf_inb)(unsigned long port);
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+
+	if (mmio) {
+		tf_outb = ide_mm_outb;
+		tf_inb  = ide_mm_inb;
+	} else {
+		tf_outb = ide_outb;
+		tf_inb  = ide_inb;
+	}
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data;
+
+		if (mmio)
+			data = readw((void __iomem *)io_ports->data_addr);
+		else
+			data = inw(io_ports->data_addr);
+
+		tf->data = data & 0xff;
+		tf->hob_data = (data >> 8) & 0xff;
+	}
+
+	/* be sure we're looking at the low order bits */
+	tf_outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+
+	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+		tf->nsect  = tf_inb(io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+		tf->lbal   = tf_inb(io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+		tf->lbam   = tf_inb(io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+		tf->lbah   = tf_inb(io_ports->lbah_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+		tf->device = tf_inb(io_ports->device_addr);
+
+	if (task->tf_flags & IDE_TFLAG_LBA48) {
+		tf_outb(drive->ctl | 0x80, io_ports->ctl_addr);
+
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+			tf->hob_feature = tf_inb(io_ports->feature_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+			tf->hob_nsect   = tf_inb(io_ports->nsect_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+			tf->hob_lbal    = tf_inb(io_ports->lbal_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+			tf->hob_lbam    = tf_inb(io_ports->lbam_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+			tf->hob_lbah    = tf_inb(io_ports->lbah_addr);
+	}
+}
+
 /*
  * Some localbus EIDE interfaces require a special access sequence
  * when using 32-bit I/O instructions to transfer data.  We call this
@@ -182,109 +227,112 @@ void SELECT_MASK (ide_drive_t *drive, int mask)
  * of the sector count register location, with interrupts disabled
  * to ensure that the reads all happen together.
  */
-static void ata_vlb_sync(ide_drive_t *drive, unsigned long port)
+static void ata_vlb_sync(unsigned long port)
 {
-	(void) HWIF(drive)->INB(port);
-	(void) HWIF(drive)->INB(port);
-	(void) HWIF(drive)->INB(port);
+	(void)inb(port);
+	(void)inb(port);
+	(void)inb(port);
 }
 
 /*
  * This is used for most PIO data transfers *from* the IDE interface
+ *
+ * These routines will round up any request for an odd number of bytes,
+ * so if an odd len is specified, be sure that there's at least one
+ * extra byte allocated for the buffer.
  */
-static void ata_input_data(ide_drive_t *drive, void *buffer, u32 wcount)
+static void ata_input_data(ide_drive_t *drive, struct request *rq,
+			   void *buf, unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
+	unsigned long data_addr = io_ports->data_addr;
 	u8 io_32bit = drive->io_32bit;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+
+	len++;
 
 	if (io_32bit) {
-		if (io_32bit & 2) {
-			unsigned long flags;
+		unsigned long uninitialized_var(flags);
 
+		if ((io_32bit & 2) && !mmio) {
 			local_irq_save(flags);
-			ata_vlb_sync(drive, io_ports->nsect_addr);
-			hwif->INSL(io_ports->data_addr, buffer, wcount);
+			ata_vlb_sync(io_ports->nsect_addr);
+		}
+
+		if (mmio)
+			__ide_mm_insl((void __iomem *)data_addr, buf, len / 4);
+		else
+			insl(data_addr, buf, len / 4);
+
+		if ((io_32bit & 2) && !mmio)
 			local_irq_restore(flags);
-		} else
-			hwif->INSL(io_ports->data_addr, buffer, wcount);
-	} else
-		hwif->INSW(io_ports->data_addr, buffer, wcount << 1);
+
+		if ((len & 3) >= 2) {
+			if (mmio)
+				__ide_mm_insw((void __iomem *)data_addr,
+						(u8 *)buf + (len & ~3), 1);
+			else
+				insw(data_addr, (u8 *)buf + (len & ~3), 1);
+		}
+	} else {
+		if (mmio)
+			__ide_mm_insw((void __iomem *)data_addr, buf, len / 2);
+		else
+			insw(data_addr, buf, len / 2);
+	}
 }
 
 /*
  * This is used for most PIO data transfers *to* the IDE interface
  */
-static void ata_output_data(ide_drive_t *drive, void *buffer, u32 wcount)
+static void ata_output_data(ide_drive_t *drive, struct request *rq,
+			    void *buf, unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
+	unsigned long data_addr = io_ports->data_addr;
 	u8 io_32bit = drive->io_32bit;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
 	if (io_32bit) {
-		if (io_32bit & 2) {
-			unsigned long flags;
+		unsigned long uninitialized_var(flags);
 
+		if ((io_32bit & 2) && !mmio) {
 			local_irq_save(flags);
-			ata_vlb_sync(drive, io_ports->nsect_addr);
-			hwif->OUTSL(io_ports->data_addr, buffer, wcount);
-			local_irq_restore(flags);
-		} else
-			hwif->OUTSL(io_ports->data_addr, buffer, wcount);
-	} else
-		hwif->OUTSW(io_ports->data_addr, buffer, wcount << 1);
-}
-
-/*
- * The following routines are mainly used by the ATAPI drivers.
- *
- * These routines will round up any request for an odd number of bytes,
- * so if an odd bytecount is specified, be sure that there's at least one
- * extra byte allocated for the buffer.
- */
-
-static void atapi_input_bytes(ide_drive_t *drive, void *buffer, u32 bytecount)
-{
-	ide_hwif_t *hwif = HWIF(drive);
+			ata_vlb_sync(io_ports->nsect_addr);
+		}
 
-	++bytecount;
-#if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
-	if (MACH_IS_ATARI || MACH_IS_Q40) {
-		/* Atari has a byte-swapped IDE interface */
-		insw_swapw(hwif->io_ports.data_addr, buffer, bytecount / 2);
-		return;
-	}
-#endif /* CONFIG_ATARI || CONFIG_Q40 */
-	hwif->ata_input_data(drive, buffer, bytecount / 4);
-	if ((bytecount & 0x03) >= 2)
-		hwif->INSW(hwif->io_ports.data_addr,
-			   (u8 *)buffer + (bytecount & ~0x03), 1);
-}
+		if (mmio)
+			__ide_mm_outsl((void __iomem *)data_addr, buf, len / 4);
+		else
+			outsl(data_addr, buf, len / 4);
 
-static void atapi_output_bytes(ide_drive_t *drive, void *buffer, u32 bytecount)
-{
-	ide_hwif_t *hwif = HWIF(drive);
+		if ((io_32bit & 2) && !mmio)
+			local_irq_restore(flags);
 
-	++bytecount;
-#if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
-	if (MACH_IS_ATARI || MACH_IS_Q40) {
-		/* Atari has a byte-swapped IDE interface */
-		outsw_swapw(hwif->io_ports.data_addr, buffer, bytecount / 2);
-		return;
+		if ((len & 3) >= 2) {
+			if (mmio)
+				__ide_mm_outsw((void __iomem *)data_addr,
+						 (u8 *)buf + (len & ~3), 1);
+			else
+				outsw(data_addr, (u8 *)buf + (len & ~3), 1);
+		}
+	} else {
+		if (mmio)
+			__ide_mm_outsw((void __iomem *)data_addr, buf, len / 2);
+		else
+			outsw(data_addr, buf, len / 2);
 	}
-#endif /* CONFIG_ATARI || CONFIG_Q40 */
-	hwif->ata_output_data(drive, buffer, bytecount / 4);
-	if ((bytecount & 0x03) >= 2)
-		hwif->OUTSW(hwif->io_ports.data_addr,
-			    (u8 *)buffer + (bytecount & ~0x03), 1);
 }
 
 void default_hwif_transport(ide_hwif_t *hwif)
 {
-	hwif->ata_input_data		= ata_input_data;
-	hwif->ata_output_data		= ata_output_data;
-	hwif->atapi_input_bytes		= atapi_input_bytes;
-	hwif->atapi_output_bytes	= atapi_output_bytes;
+	hwif->tf_load	  = ide_tf_load;
+	hwif->tf_read	  = ide_tf_read;
+
+	hwif->input_data  = ata_input_data;
+	hwif->output_data = ata_output_data;
 }
 
 void ide_fix_driveid (struct hd_driveid *id)
@@ -577,6 +625,8 @@ static const struct drive_list_entry ivb_list[] = {
 	{ "TSSTcorp CDDVDW SH-S202J"	, "SB01"	},
 	{ "TSSTcorp CDDVDW SH-S202N"	, "SB00"	},
 	{ "TSSTcorp CDDVDW SH-S202N"	, "SB01"	},
+	{ "TSSTcorp CDDVDW SH-S202H"	, "SB00"	},
+	{ "TSSTcorp CDDVDW SH-S202H"	, "SB01"	},
 	{ NULL				, NULL		}
 };
 
@@ -641,7 +691,7 @@ int ide_driveid_update(ide_drive_t *drive)
 	SELECT_MASK(drive, 1);
 	ide_set_irq(drive, 1);
 	msleep(50);
-	hwif->OUTB(WIN_IDENTIFY, hwif->io_ports.command_addr);
+	hwif->OUTBSYNC(drive, WIN_IDENTIFY, hwif->io_ports.command_addr);
 	timeout = jiffies + WAIT_WORSTCASE;
 	do {
 		if (time_after(jiffies, timeout)) {
@@ -668,7 +718,7 @@ int ide_driveid_update(ide_drive_t *drive)
 		local_irq_restore(flags);
 		return 0;
 	}
-	hwif->ata_input_data(drive, id, SECTOR_WORDS);
+	hwif->input_data(drive, NULL, id, SECTOR_SIZE);
 	(void)ide_read_status(drive);	/* clear drive IRQ */
 	local_irq_enable();
 	local_irq_restore(flags);
@@ -849,9 +899,19 @@ void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
 	ndelay(400);
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
-
 EXPORT_SYMBOL(ide_execute_command);
 
+void ide_execute_pkt_cmd(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ide_lock, flags);
+	hwif->OUTBSYNC(drive, WIN_PACKETCMD, hwif->io_ports.command_addr);
+	ndelay(400);
+	spin_unlock_irqrestore(&ide_lock, flags);
+}
+EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
 
 /* needed below */
 static ide_startstop_t do_reset1 (ide_drive_t *, int);
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 6f04ea3..47af80d 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -487,7 +487,7 @@ static void ide_dump_sector(ide_drive_t *drive)
 	else
 		task.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_DEVICE;
 
-	ide_tf_read(drive, &task);
+	drive->hwif->tf_read(drive, &task);
 
 	if (lba48 || (tf->device & ATA_LBA))
 		printk(", LBAsect=%llu",
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 862f026..099a0fe 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -124,7 +124,7 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 
 	id = drive->id;
 	/* read 512 bytes of id info */
-	hwif->ata_input_data(drive, id, SECTOR_WORDS);
+	hwif->input_data(drive, NULL, id, SECTOR_SIZE);
 
 	drive->id_read = 1;
 	local_irq_enable();
@@ -293,7 +293,7 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 		hwif->OUTB(0, io_ports->feature_addr);
 
 	/* ask drive for ID */
-	hwif->OUTB(cmd, io_ports->command_addr);
+	hwif->OUTBSYNC(drive, cmd, io_ports->command_addr);
 
 	timeout = ((cmd == WIN_IDENTIFY) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 	timeout += jiffies;
@@ -480,7 +480,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			msleep(50);
 			hwif->OUTB(drive->select.all, io_ports->device_addr);
 			msleep(50);
-			hwif->OUTB(WIN_SRST, io_ports->command_addr);
+			hwif->OUTBSYNC(drive, WIN_SRST, io_ports->command_addr);
 			(void)ide_busy_sleep(hwif);
 			rc = try_to_identify(drive, cmd);
 		}
@@ -516,7 +516,7 @@ static void enable_nest (ide_drive_t *drive)
 	printk("%s: enabling %s -- ", hwif->name, drive->id->model);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	hwif->OUTB(EXABYTE_ENABLE_NEST, hwif->io_ports.command_addr);
+	hwif->OUTBSYNC(drive, EXABYTE_ENABLE_NEST, hwif->io_ports.command_addr);
 
 	if (ide_busy_sleep(hwif)) {
 		printk(KERN_CONT "failed (timeout)\n");
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 29870c4..54a43b0 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -395,13 +395,13 @@ static void idetape_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		if (bh == NULL) {
 			printk(KERN_ERR "ide-tape: bh == NULL in "
 				"idetape_input_buffers\n");
-			ide_atapi_discard_data(drive, bcount);
+			ide_pad_transfer(drive, 0, bcount);
 			return;
 		}
 		count = min(
 			(unsigned int)(bh->b_size - atomic_read(&bh->b_count)),
 			bcount);
-		HWIF(drive)->atapi_input_bytes(drive, bh->b_data +
+		drive->hwif->input_data(drive, NULL, bh->b_data +
 					atomic_read(&bh->b_count), count);
 		bcount -= count;
 		atomic_add(count, &bh->b_count);
@@ -427,7 +427,7 @@ static void idetape_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 			return;
 		}
 		count = min((unsigned int)pc->b_count, (unsigned int)bcount);
-		HWIF(drive)->atapi_output_bytes(drive, pc->b_data, count);
+		drive->hwif->output_data(drive, NULL, pc->b_data, count);
 		bcount -= count;
 		pc->b_data += count;
 		pc->b_count -= count;
@@ -871,7 +871,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 				printk(KERN_ERR "ide-tape: The tape wants to "
 					"send us more data than expected "
 					"- discarding data\n");
-				ide_atapi_discard_data(drive, bcount);
+				ide_pad_transfer(drive, 0, bcount);
 				ide_set_handler(drive, &idetape_pc_intr,
 						IDETAPE_WAIT_CMD, NULL);
 				return ide_started;
@@ -880,16 +880,16 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 				"data than expected - allowing transfer\n");
 		}
 		iobuf = &idetape_input_buffers;
-		xferfunc = hwif->atapi_input_bytes;
+		xferfunc = hwif->input_data;
 	} else {
 		iobuf = &idetape_output_buffers;
-		xferfunc = hwif->atapi_output_bytes;
+		xferfunc = hwif->output_data;
 	}
 
 	if (pc->bh)
 		iobuf(drive, pc, bcount);
 	else
-		xferfunc(drive, pc->cur_pos, bcount);
+		xferfunc(drive, NULL, pc->cur_pos, bcount);
 
 	/* Update the current position */
 	pc->xferred += bcount;
@@ -979,7 +979,8 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 		hwif->dma_ops->dma_start(drive);
 #endif
 	/* Send the actual packet */
-	HWIF(drive)->atapi_output_bytes(drive, pc->c, 12);
+	hwif->output_data(drive, NULL, pc->c, 12);
+
 	return ide_started;
 }
 
@@ -1055,7 +1056,7 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 				    IDETAPE_WAIT_CMD, NULL);
 		return ide_started;
 	} else {
-		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports.command_addr);
+		ide_execute_pkt_cmd(drive);
 		return idetape_transfer_pc(drive);
 	}
 }
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 9f9ad9f..9a846a0 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -33,60 +33,18 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+void ide_tf_dump(const char *s, struct ide_taskfile *tf)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
-
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
-		HIHI = 0xFF;
-
 #ifdef DEBUG
 	printk("%s: tf: feat 0x%02x nsect 0x%02x lbal 0x%02x "
 		"lbam 0x%02x lbah 0x%02x dev 0x%02x cmd 0x%02x\n",
-		drive->name, tf->feature, tf->nsect, tf->lbal,
+		s, tf->feature, tf->nsect, tf->lbal,
 		tf->lbam, tf->lbah, tf->device, tf->command);
 	printk("%s: hob: nsect 0x%02x lbal 0x%02x "
 		"lbam 0x%02x lbah 0x%02x\n",
-		drive->name, tf->hob_nsect, tf->hob_lbal,
+		s, tf->hob_nsect, tf->hob_lbal,
 		tf->hob_lbam, tf->hob_lbah);
 #endif
-
-	ide_set_irq(drive, 1);
-
-	if ((task->tf_flags & IDE_TFLAG_NO_SELECT_MASK) == 0)
-		SELECT_MASK(drive, 0);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
-		hwif->OUTW((tf->hob_data << 8) | tf->data, io_ports->data_addr);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		hwif->OUTB(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		hwif->OUTB(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		hwif->OUTB(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		hwif->OUTB(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		hwif->OUTB(tf->hob_lbah, io_ports->lbah_addr);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		hwif->OUTB(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
-		hwif->OUTB(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
-		hwif->OUTB(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
-		hwif->OUTB(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
-		hwif->OUTB(tf->lbah, io_ports->lbah_addr);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		hwif->OUTB((tf->device & HIHI) | drive->select.all,
-			   io_ports->device_addr);
 }
 
 int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
@@ -149,8 +107,10 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		task->tf_flags |= IDE_TFLAG_FLAGGED_SET_IN_FLAGS;
 
-	if ((task->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0)
-		ide_tf_load(drive, task);
+	if ((task->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
+		ide_tf_dump(drive->name, tf);
+		hwif->tf_load(drive, task);
+	}
 
 	switch (task->data_phase) {
 	case TASKFILE_MULTI_OUT:
@@ -283,7 +243,8 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	return stat;
 }
 
-static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
+static void ide_pio_sector(ide_drive_t *drive, struct request *rq,
+			   unsigned int write)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
@@ -323,9 +284,9 @@ static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
 
 	/* do the actual data transfer */
 	if (write)
-		hwif->ata_output_data(drive, buf, SECTOR_WORDS);
+		hwif->output_data(drive, rq, buf, SECTOR_SIZE);
 	else
-		hwif->ata_input_data(drive, buf, SECTOR_WORDS);
+		hwif->input_data(drive, rq, buf, SECTOR_SIZE);
 
 	kunmap_atomic(buf, KM_BIO_SRC_IRQ);
 #ifdef CONFIG_HIGHMEM
@@ -333,13 +294,14 @@ static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
 #endif
 }
 
-static void ide_pio_multi(ide_drive_t *drive, unsigned int write)
+static void ide_pio_multi(ide_drive_t *drive, struct request *rq,
+			  unsigned int write)
 {
 	unsigned int nsect;
 
 	nsect = min_t(unsigned int, drive->hwif->nleft, drive->mult_count);
 	while (nsect--)
-		ide_pio_sector(drive, write);
+		ide_pio_sector(drive, rq, write);
 }
 
 static void ide_pio_datablock(ide_drive_t *drive, struct request *rq,
@@ -362,10 +324,10 @@ static void ide_pio_datablock(ide_drive_t *drive, struct request *rq,
 	switch (drive->hwif->data_phase) {
 	case TASKFILE_MULTI_IN:
 	case TASKFILE_MULTI_OUT:
-		ide_pio_multi(drive, write);
+		ide_pio_multi(drive, rq, write);
 		break;
 	default:
-		ide_pio_sector(drive, write);
+		ide_pio_sector(drive, rq, write);
 		break;
 	}
 
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index 56cdaa0..83555ca 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -44,6 +44,28 @@
 int falconide_intr_lock;
 EXPORT_SYMBOL(falconide_intr_lock);
 
+static void falconide_input_data(ide_drive_t *drive, struct request *rq,
+				 void *buf, unsigned int len)
+{
+	unsigned long data_addr = drive->hwif->io_ports.data_addr;
+
+	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+		return insw(data_addr, buf, (len + 1) / 2);
+
+	insw_swapw(data_addr, buf, (len + 1) / 2);
+}
+
+static void falconide_output_data(ide_drive_t *drive, struct request *rq,
+				  void *buf, unsigned int len)
+{
+	unsigned long data_addr = drive->hwif->io_ports.data_addr;
+
+	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+		return outsw(data_adr, buf, (len + 1) / 2);
+
+	outsw_swapw(data_addr, buf, (len + 1) / 2);
+}
+
 static void __init falconide_setup_ports(hw_regs_t *hw)
 {
 	int i;
@@ -90,6 +112,10 @@ static int __init falconide_init(void)
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
 
+		/* Atari has a byte-swapped IDE interface */
+		hwif->input_data  = falconide_input_data;
+		hwif->output_data = falconide_output_data;
+
 		ide_get_lock(NULL, NULL);
 		ide_device_add(idx, NULL);
 		ide_release_lock();
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
index 8279dc7..d3bc3f2 100644
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -101,8 +101,10 @@ static int __devinit plat_ide_probe(struct platform_device *pdev)
 
 	ide_init_port_hw(hwif, &hw);
 
-	if (mmio)
+	if (mmio) {
+		hwif->host_flags = IDE_HFLAG_MMIO;
 		default_hwif_mmiops(hwif);
+	}
 
 	idx[0] = hwif->index;
 
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index f921045..6f535d0 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -72,7 +72,27 @@ static void q40_ide_setup_ports(hw_regs_t *hw, unsigned long base,
 	hw->ack_intr = ack_intr;
 }
 
+static void q40ide_input_data(ide_drive_t *drive, struct request *rq,
+			      void *buf, unsigned int len)
+{
+	unsigned long data_addr = drive->hwif->io_ports.data_addr;
+
+	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+		return insw(data_addr, buf, (len + 1) / 2);
 
+	insw_swapw(data_addr, buf, (len + 1) / 2);
+}
+
+static void q40ide_output_data(ide_drive_t *drive, struct request *rq,
+			       void *buf, unsigned int len)
+{
+	unsigned long data_addr = drive->hwif->io_ports.data_addr;
+
+	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+		return outsw(data_addr, buf, (len + 1) / 2);
+
+	outsw_swapw(data_addr, buf, (len + 1) / 2);
+}
 
 /* 
  * the static array is needed to have the name reported in /proc/ioports,
@@ -123,6 +143,10 @@ static int __init q40ide_init(void)
 		ide_init_port_data(hwif, hwif->index);
 		ide_init_port_hw(hwif, &hw);
 
+		/* Q40 has a byte-swapped IDE interface */
+		hwif->input_data  = q40ide_input_data;
+		hwif->output_data = q40ide_output_data;
+
 		idx[i] = hwif->index;
 	}
     }
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index e0cf5e2..1a6c27b 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -48,8 +48,6 @@
 
 static _auide_hwif auide_hwif;
 
-static int auide_ddma_init(_auide_hwif *auide);
-
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA)
 
 void auide_insw(unsigned long port, void *addr, u32 count)
@@ -88,6 +86,17 @@ void auide_outsw(unsigned long port, void *addr, u32 count)
 	ctp->cur_ptr = au1xxx_ddma_get_nextptr_virt(dp);
 }
 
+static void au1xxx_input_data(ide_drive_t *drive, struct request *rq,
+			      void *buf, unsigned int len)
+{
+	auide_insw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
+static void au1xxx_output_data(ide_drive_t *drive, struct request *rq,
+			       void *buf, unsigned int len)
+{
+	auide_outsw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
 #endif
 
 static void au1xxx_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -598,8 +607,8 @@ static int au_ide_probe(struct device *dev)
 	*/
 
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA	
-	hwif->INSW                      = auide_insw;
-	hwif->OUTSW                     = auide_outsw;
+	hwif->input_data  = au1xxx_input_data;
+	hwif->output_data = au1xxx_output_data;
 #endif
 	hwif->select_data               = 0;    /* no chipset-specific code */
 	hwif->config_data               = 0;    /* no chipset-specific code */
diff --git a/drivers/ide/mips/swarm.c b/drivers/ide/mips/swarm.c
index 6894762..712d17b 100644
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -109,6 +109,7 @@ static int __devinit swarm_ide_probe(struct device *dev)
 	base = ioremap(offset, size);
 
 	/* Setup MMIO ops.  */
+	hwif->host_flags = IDE_HFLAG_MMIO;
 	default_hwif_mmiops(hwif);
 
 	hwif->chipset = ide_generic;
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index c13e299..fec4955 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -63,6 +63,48 @@ static u8 superio_ide_inb (unsigned long port)
 	return inb(port);
 }
 
+static void superio_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data = inw(io_ports->data_addr);
+
+		tf->data = data & 0xff;
+		tf->hob_data = (data >> 8) & 0xff;
+	}
+
+	/* be sure we're looking at the low order bits */
+	outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+
+	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+		tf->nsect  = inb(io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+		tf->lbal   = inb(io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+		tf->lbam   = inb(io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+		tf->lbah   = inb(io_ports->lbah_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+		tf->device = superio_ide_inb(io_ports->device_addr);
+
+	if (task->tf_flags & IDE_TFLAG_LBA48) {
+		outb(drive->ctl | 0x80, io_ports->ctl_addr);
+
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+			tf->hob_feature = inb(io_ports->feature_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+			tf->hob_nsect   = inb(io_ports->nsect_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+			tf->hob_lbal    = inb(io_ports->lbal_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+			tf->hob_lbam    = inb(io_ports->lbam_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+			tf->hob_lbah    = inb(io_ports->lbah_addr);
+	}
+}
+
 static void __devinit superio_ide_init_iops (struct hwif_s *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
@@ -80,6 +122,8 @@ static void __devinit superio_ide_init_iops (struct hwif_s *hwif)
 	tmp = superio_ide_inb(superio_ide_dma_status[port]);
 	outb(tmp | 0x66, superio_ide_dma_status[port]);
 
+	hwif->tf_read = superio_tf_read;
+
 	/* We need to override inb to workaround a SuperIO errata */
 	hwif->INB = superio_ide_inb;
 }
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index ec9bd7b..070df8a 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -83,8 +83,8 @@ static u8 get_indexed_reg(ide_hwif_t *hwif, u8 index)
 {
 	u8 value;
 
-	outb(index, hwif->dma_vendor1);
-	value = inb(hwif->dma_vendor3);
+	outb(index, hwif->dma_base + 1);
+	value = inb(hwif->dma_base + 3);
 
 	DBG("index[%02X] value[%02X]\n", index, value);
 	return value;
@@ -97,8 +97,8 @@ static u8 get_indexed_reg(ide_hwif_t *hwif, u8 index)
  */
 static void set_indexed_reg(ide_hwif_t *hwif, u8 index, u8 value)
 {
-	outb(index, hwif->dma_vendor1);
-	outb(value, hwif->dma_vendor3);
+	outb(index, hwif->dma_base + 1);
+	outb(value, hwif->dma_base + 3);
 	DBG("index[%02X] value[%02X]\n", index, value);
 }
 
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 21c5dd2..f04738d 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -250,6 +250,7 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on Acer Aspire 2023WLMi */
+	{ 0x2653, 0x1043, 0x82D8 },	/* ICH6M on Asus Eee 701 */
 	/* end marker */
 	{ 0, }
 };
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index ad7cdf9..910fb00 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -126,12 +126,6 @@ static u8 scc_ide_inb(unsigned long port)
 	return (u8)data;
 }
 
-static u16 scc_ide_inw(unsigned long port)
-{
-	u32 data = in_be32((void*)port);
-	return (u16)data;
-}
-
 static void scc_ide_insw(unsigned long port, void *addr, u32 count)
 {
 	u16 *ptr = (u16 *)addr;
@@ -154,11 +148,6 @@ static void scc_ide_outb(u8 addr, unsigned long port)
 	out_be32((void*)port, addr);
 }
 
-static void scc_ide_outw(u16 addr, unsigned long port)
-{
-	out_be32((void*)port, addr);
-}
-
 static void
 scc_ide_outbsync(ide_drive_t * drive, u8 addr, unsigned long port)
 {
@@ -271,6 +260,20 @@ static void scc_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	out_be32((void __iomem *)udenvt_port, reg);
 }
 
+static void scc_dma_host_set(ide_drive_t *drive, int on)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 unit = (drive->select.b.unit & 0x01);
+	u8 dma_stat = scc_ide_inb(hwif->dma_status);
+
+	if (on)
+		dma_stat |= (1 << (5 + unit));
+	else
+		dma_stat &= ~(1 << (5 + unit));
+
+	scc_ide_outb(dma_stat, hwif->dma_status);
+}
+
 /**
  *	scc_ide_dma_setup	-	begin a DMA phase
  *	@drive: target device
@@ -301,7 +304,7 @@ static int scc_dma_setup(ide_drive_t *drive)
 	}
 
 	/* PRD table */
-	out_be32((void __iomem *)hwif->dma_prdtable, hwif->dmatable_dma);
+	out_be32((void __iomem *)(hwif->dma_base + 8), hwif->dmatable_dma);
 
 	/* specify r/w */
 	out_be32((void __iomem *)hwif->dma_command, reading);
@@ -315,13 +318,45 @@ static int scc_dma_setup(ide_drive_t *drive)
 	return 0;
 }
 
+static void scc_dma_start(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_cmd = scc_ide_inb(hwif->dma_command);
+
+	/* start DMA */
+	scc_ide_outb(dma_cmd | 1, hwif->dma_command);
+	hwif->dma = 1;
+	wmb();
+}
+
+static int __scc_dma_end(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_stat, dma_cmd;
+
+	drive->waiting_for_dma = 0;
+	/* get DMA command mode */
+	dma_cmd = scc_ide_inb(hwif->dma_command);
+	/* stop DMA */
+	scc_ide_outb(dma_cmd & ~1, hwif->dma_command);
+	/* get DMA status */
+	dma_stat = scc_ide_inb(hwif->dma_status);
+	/* clear the INTR & ERROR bits */
+	scc_ide_outb(dma_stat | 6, hwif->dma_status);
+	/* purge DMA mappings */
+	ide_destroy_dmatable(drive);
+	/* verify good DMA status */
+	hwif->dma = 0;
+	wmb();
+	return (dma_stat & 7) != 4 ? (0x10 | dma_stat) : 0;
+}
 
 /**
  *	scc_dma_end	-	Stop DMA
  *	@drive: IDE drive
  *
  *	Check and clear INT Status register.
- *      Then call __ide_dma_end().
+ *	Then call __scc_dma_end().
  */
 
 static int scc_dma_end(ide_drive_t *drive)
@@ -425,7 +460,7 @@ static int scc_dma_end(ide_drive_t *drive)
 		break;
 	}
 
-	dma_stat = __ide_dma_end(drive);
+	dma_stat = __scc_dma_end(drive);
 	if (data_loss)
 		dma_stat |= 2; /* emulate DMA error (to retry command) */
 	return dma_stat;
@@ -618,6 +653,122 @@ static int __devinit init_setup_scc(struct pci_dev *dev,
 	return rc;
 }
 
+static void scc_tf_load(ide_drive_t *drive, ide_task_t *task)
+{
+	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+
+	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+		HIHI = 0xFF;
+
+	ide_set_irq(drive, 1);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
+		out_be32((void *)io_ports->data_addr,
+			 (tf->hob_data << 8) | tf->data);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+		scc_ide_outb(tf->hob_feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+		scc_ide_outb(tf->hob_nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+		scc_ide_outb(tf->hob_lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+		scc_ide_outb(tf->hob_lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+		scc_ide_outb(tf->hob_lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+		scc_ide_outb(tf->feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+		scc_ide_outb(tf->nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+		scc_ide_outb(tf->lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+		scc_ide_outb(tf->lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+		scc_ide_outb(tf->lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		scc_ide_outb((tf->device & HIHI) | drive->select.all,
+			     io_ports->device_addr);
+}
+
+static void scc_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data = (u16)in_be32((void *)io_ports->data_addr);
+
+		tf->data = data & 0xff;
+		tf->hob_data = (data >> 8) & 0xff;
+	}
+
+	/* be sure we're looking at the low order bits */
+	scc_ide_outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+
+	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+		tf->nsect  = scc_ide_inb(io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+		tf->lbal   = scc_ide_inb(io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+		tf->lbam   = scc_ide_inb(io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+		tf->lbah   = scc_ide_inb(io_ports->lbah_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+		tf->device = scc_ide_inb(io_ports->device_addr);
+
+	if (task->tf_flags & IDE_TFLAG_LBA48) {
+		scc_ide_outb(drive->ctl | 0x80, io_ports->ctl_addr);
+
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+			tf->hob_feature = scc_ide_inb(io_ports->feature_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+			tf->hob_nsect   = scc_ide_inb(io_ports->nsect_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+			tf->hob_lbal    = scc_ide_inb(io_ports->lbal_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+			tf->hob_lbam    = scc_ide_inb(io_ports->lbam_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+			tf->hob_lbah    = scc_ide_inb(io_ports->lbah_addr);
+	}
+}
+
+static void scc_input_data(ide_drive_t *drive, struct request *rq,
+			   void *buf, unsigned int len)
+{
+	unsigned long data_addr = drive->hwif->io_ports.data_addr;
+
+	len++;
+
+	if (drive->io_32bit) {
+		scc_ide_insl(data_addr, buf, len / 4);
+
+		if ((len & 3) >= 2)
+			scc_ide_insw(data_addr, (u8 *)buf + (len & ~3), 1);
+	} else
+		scc_ide_insw(data_addr, buf, len / 2);
+}
+
+static void scc_output_data(ide_drive_t *drive,  struct request *rq,
+			    void *buf, unsigned int len)
+{
+	unsigned long data_addr = drive->hwif->io_ports.data_addr;
+
+	len++;
+
+	if (drive->io_32bit) {
+		scc_ide_outsl(data_addr, buf, len / 4);
+
+		if ((len & 3) >= 2)
+			scc_ide_outsw(data_addr, (u8 *)buf + (len & ~3), 1);
+	} else
+		scc_ide_outsw(data_addr, buf, len / 2);
+}
+
 /**
  *	init_mmio_iops_scc	-	set up the iops for MMIO
  *	@hwif: interface to set up
@@ -632,15 +783,15 @@ static void __devinit init_mmio_iops_scc(ide_hwif_t *hwif)
 
 	ide_set_hwifdata(hwif, ports);
 
+	hwif->tf_load = scc_tf_load;
+	hwif->tf_read = scc_tf_read;
+
+	hwif->input_data  = scc_input_data;
+	hwif->output_data = scc_output_data;
+
 	hwif->INB = scc_ide_inb;
-	hwif->INW = scc_ide_inw;
-	hwif->INSW = scc_ide_insw;
-	hwif->INSL = scc_ide_insl;
 	hwif->OUTB = scc_ide_outb;
 	hwif->OUTBSYNC = scc_ide_outbsync;
-	hwif->OUTW = scc_ide_outw;
-	hwif->OUTSW = scc_ide_outsw;
-	hwif->OUTSL = scc_ide_outsl;
 
 	hwif->dma_base = dma_base;
 	hwif->config_data = ports->ctl;
@@ -687,7 +838,6 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 
 	hwif->dma_command = hwif->dma_base;
 	hwif->dma_status = hwif->dma_base + 0x04;
-	hwif->dma_prdtable = hwif->dma_base + 0x08;
 
 	/* PTERADD */
 	out_be32((void __iomem *)(hwif->dma_base + 0x018), hwif->dmatable_dma);
@@ -706,10 +856,10 @@ static const struct ide_port_ops scc_port_ops = {
 };
 
 static const struct ide_dma_ops scc_dma_ops = {
-	.dma_host_set		= ide_dma_host_set,
+	.dma_host_set		= scc_dma_host_set,
 	.dma_setup		= scc_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
-	.dma_start		= ide_dma_start,
+	.dma_start		= scc_dma_start,
 	.dma_end		= scc_dma_end,
 	.dma_test_irq		= scc_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 63e28f4..16a0bce 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -573,6 +573,7 @@ static const struct ide_port_info sgiioc4_port_info __devinitdata = {
 	.init_dma		= ide_dma_sgiioc4,
 	.port_ops		= &sgiioc4_port_ops,
 	.dma_ops		= &sgiioc4_dma_ops,
+	.host_flags		= IDE_HFLAG_MMIO,
 	.mwdma_mask		= ATA_MWDMA2_ONLY,
 };
 
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index c2040a0..4cf8fc5 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -1,8 +1,8 @@
 /*
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2003		Red Hat <alan@redhat.com>
- * Copyright (C) 2007		MontaVista Software, Inc.
- * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2007-2008	MontaVista Software, Inc.
+ * Copyright (C) 2007-2008	Bartlomiej Zolnierkiewicz
  *
  *  May be copied or modified under the terms of the GNU General Public License
  *
@@ -17,10 +17,10 @@
  *
  *  FAQ Items:
  *	If you are using Marvell SATA-IDE adapters with Maxtor drives
- *	ensure the system is set up for ATA100/UDMA5 not UDMA6.
+ *	ensure the system is set up for ATA100/UDMA5, not UDMA6.
  *
  *	If you are using WD drives with SATA bridges you must set the
- *	drive to "Single". "Master" will hang
+ *	drive to "Single". "Master" will hang.
  *
  *	If you have strange problems with nVidia chipset systems please
  *	see the SI support documentation and update your system BIOS
@@ -42,25 +42,24 @@
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
 
 /**
  *	pdev_is_sata		-	check if device is SATA
  *	@pdev:	PCI device to check
- *	
+ *
  *	Returns true if this is a SATA controller
  */
- 
+
 static int pdev_is_sata(struct pci_dev *pdev)
 {
 #ifdef CONFIG_BLK_DEV_IDE_SATA
-	switch(pdev->device) {
-		case PCI_DEVICE_ID_SII_3112:
-		case PCI_DEVICE_ID_SII_1210SA:
-			return 1;
-		case PCI_DEVICE_ID_SII_680:
-			return 0;
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_SII_3112:
+	case PCI_DEVICE_ID_SII_1210SA:
+		return 1;
+	case PCI_DEVICE_ID_SII_680:
+		return 0;
 	}
 	BUG();
 #endif
@@ -70,10 +69,10 @@ static int pdev_is_sata(struct pci_dev *pdev)
 /**
  *	is_sata			-	check if hwif is SATA
  *	@hwif:	interface to check
- *	
+ *
  *	Returns true if this is a SATA controller
  */
- 
+
 static inline int is_sata(ide_hwif_t *hwif)
 {
 	return pdev_is_sata(to_pci_dev(hwif->dev));
@@ -86,21 +85,22 @@ static inline int is_sata(ide_hwif_t *hwif)
  *
  *	Turn a config register offset into the right address in either
  *	PCI space or MMIO space to access the control register in question
- *	Thankfully this is a configuration operation so isnt performance
- *	criticial. 
+ *	Thankfully this is a configuration operation, so isn't performance
+ *	critical.
  */
- 
+
 static unsigned long siimage_selreg(ide_hwif_t *hwif, int r)
 {
 	unsigned long base = (unsigned long)hwif->hwif_data;
+
 	base += 0xA0 + r;
-	if(hwif->mmio)
-		base += (hwif->channel << 6);
+	if (hwif->mmio)
+		base += hwif->channel << 6;
 	else
-		base += (hwif->channel << 4);
+		base += hwif->channel << 4;
 	return base;
 }
-	
+
 /**
  *	siimage_seldev		-	return register base
  *	@hwif: interface
@@ -110,20 +110,69 @@ static unsigned long siimage_selreg(ide_hwif_t *hwif, int r)
  *	PCI space or MMIO space to access the control register in question
  *	including accounting for the unit shift.
  */
- 
+
 static inline unsigned long siimage_seldev(ide_drive_t *drive, int r)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	unsigned long base = (unsigned long)hwif->hwif_data;
+	unsigned long base	= (unsigned long)hwif->hwif_data;
+
 	base += 0xA0 + r;
-	if(hwif->mmio)
-		base += (hwif->channel << 6);
+	if (hwif->mmio)
+		base += hwif->channel << 6;
 	else
-		base += (hwif->channel << 4);
+		base += hwif->channel << 4;
 	base |= drive->select.b.unit << drive->select.b.unit;
 	return base;
 }
 
+static u8 sil_ioread8(struct pci_dev *dev, unsigned long addr)
+{
+	u8 tmp = 0;
+
+	if (pci_get_drvdata(dev))
+		tmp = readb((void __iomem *)addr);
+	else
+		pci_read_config_byte(dev, addr, &tmp);
+
+	return tmp;
+}
+
+static u16 sil_ioread16(struct pci_dev *dev, unsigned long addr)
+{
+	u16 tmp = 0;
+
+	if (pci_get_drvdata(dev))
+		tmp = readw((void __iomem *)addr);
+	else
+		pci_read_config_word(dev, addr, &tmp);
+
+	return tmp;
+}
+
+static void sil_iowrite8(struct pci_dev *dev, u8 val, unsigned long addr)
+{
+	if (pci_get_drvdata(dev))
+		writeb(val, (void __iomem *)addr);
+	else
+		pci_write_config_byte(dev, addr, val);
+}
+
+static void sil_iowrite16(struct pci_dev *dev, u16 val, unsigned long addr)
+{
+	if (pci_get_drvdata(dev))
+		writew(val, (void __iomem *)addr);
+	else
+		pci_write_config_word(dev, addr, val);
+}
+
+static void sil_iowrite32(struct pci_dev *dev, u32 val, unsigned long addr)
+{
+	if (pci_get_drvdata(dev))
+		writel(val, (void __iomem *)addr);
+	else
+		pci_write_config_dword(dev, addr, val);
+}
+
 /**
  *	sil_udma_filter		-	compute UDMA mask
  *	@drive: IDE device
@@ -136,24 +185,26 @@ static inline unsigned long siimage_seldev(ide_drive_t *drive, int r)
 
 static u8 sil_pata_udma_filter(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	unsigned long base = (unsigned long) hwif->hwif_data;
-	u8 mask = 0, scsc = 0;
+	ide_hwif_t *hwif	= drive->hwif;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	unsigned long base	= (unsigned long)hwif->hwif_data;
+	u8 scsc, mask		= 0;
 
-	if (hwif->mmio)
-		scsc = hwif->INB(base + 0x4A);
-	else
-		pci_read_config_byte(dev, 0x8A, &scsc);
+	scsc = sil_ioread8(dev, base + (hwif->mmio ? 0x4A : 0x8A));
 
-	if ((scsc & 0x30) == 0x10)	/* 133 */
+	switch (scsc & 0x30) {
+	case 0x10:	/* 133 */
 		mask = ATA_UDMA6;
-	else if ((scsc & 0x30) == 0x20)	/* 2xPCI */
+		break;
+	case 0x20:	/* 2xPCI */
 		mask = ATA_UDMA6;
-	else if ((scsc & 0x30) == 0x00)	/* 100 */
+		break;
+	case 0x00:	/* 100 */
 		mask = ATA_UDMA5;
-	else 	/* Disabled ? */
+		break;
+	default: 	/* Disabled ? */
 		BUG();
+	}
 
 	return mask;
 }
@@ -175,15 +226,16 @@ static u8 sil_sata_udma_filter(ide_drive_t *drive)
 
 static void sil_set_pio_mode(ide_drive_t *drive, u8 pio)
 {
-	const u16 tf_speed[]	= { 0x328a, 0x2283, 0x1281, 0x10c3, 0x10c1 };
-	const u16 data_speed[]	= { 0x328a, 0x2283, 0x1104, 0x10c3, 0x10c1 };
+	static const u16 tf_speed[]   = { 0x328a, 0x2283, 0x1281, 0x10c3, 0x10c1 };
+	static const u16 data_speed[] = { 0x328a, 0x2283, 0x1104, 0x10c3, 0x10c1 };
 
 	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	ide_drive_t *pair	= ide_get_paired_drive(drive);
 	u32 speedt		= 0;
 	u16 speedp		= 0;
 	unsigned long addr	= siimage_seldev(drive, 0x04);
-	unsigned long tfaddr	= siimage_selreg(hwif, 0x02);
+	unsigned long tfaddr	= siimage_selreg(hwif,	0x02);
 	unsigned long base	= (unsigned long)hwif->hwif_data;
 	u8 tf_pio		= pio;
 	u8 addr_mask		= hwif->channel ? (hwif->mmio ? 0xF4 : 0x84)
@@ -203,36 +255,20 @@ static void sil_set_pio_mode(ide_drive_t *drive, u8 pio)
 	speedp = data_speed[pio];
 	speedt = tf_speed[tf_pio];
 
-	if (hwif->mmio) {
-		hwif->OUTW(speedp, addr);
-		hwif->OUTW(speedt, tfaddr);
-		/* Now set up IORDY */
-		if (pio > 2)
-			hwif->OUTW(hwif->INW(tfaddr-2)|0x200, tfaddr-2);
-		else
-			hwif->OUTW(hwif->INW(tfaddr-2)&~0x200, tfaddr-2);
-
-		mode = hwif->INB(base + addr_mask);
-		mode &= ~(unit ? 0x30 : 0x03);
-		mode |= (unit ? 0x10 : 0x01);
-		hwif->OUTB(mode, base + addr_mask);
-	} else {
-		struct pci_dev *dev = to_pci_dev(hwif->dev);
-
-		pci_write_config_word(dev, addr, speedp);
-		pci_write_config_word(dev, tfaddr, speedt);
-		pci_read_config_word(dev, tfaddr - 2, &speedp);
-		speedp &= ~0x200;
-		/* Set IORDY for mode 3 or 4 */
-		if (pio > 2)
-			speedp |= 0x200;
-		pci_write_config_word(dev, tfaddr - 2, speedp);
-
-		pci_read_config_byte(dev, addr_mask, &mode);
-		mode &= ~(unit ? 0x30 : 0x03);
-		mode |= (unit ? 0x10 : 0x01);
-		pci_write_config_byte(dev, addr_mask, mode);
-	}
+	sil_iowrite16(dev, speedp, addr);
+	sil_iowrite16(dev, speedt, tfaddr);
+
+	/* now set up IORDY */
+	speedp = sil_ioread16(dev, tfaddr - 2);
+	speedp &= ~0x200;
+	if (pio > 2)
+		speedp |= 0x200;
+	sil_iowrite16(dev, speedp, tfaddr - 2);
+
+	mode = sil_ioread8(dev, base + addr_mask);
+	mode &= ~(unit ? 0x30 : 0x03);
+	mode |= unit ? 0x10 : 0x01;
+	sil_iowrite8(dev, mode, base + addr_mask);
 }
 
 /**
@@ -245,59 +281,45 @@ static void sil_set_pio_mode(ide_drive_t *drive, u8 pio)
 
 static void sil_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	u8 ultra6[]		= { 0x0F, 0x0B, 0x07, 0x05, 0x03, 0x02, 0x01 };
-	u8 ultra5[]		= { 0x0C, 0x07, 0x05, 0x04, 0x02, 0x01 };
-	u16 dma[]		= { 0x2208, 0x10C2, 0x10C1 };
+	static const u8 ultra6[] = { 0x0F, 0x0B, 0x07, 0x05, 0x03, 0x02, 0x01 };
+	static const u8 ultra5[] = { 0x0C, 0x07, 0x05, 0x04, 0x02, 0x01 };
+	static const u16 dma[]	 = { 0x2208, 0x10C2, 0x10C1 };
 
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u16 ultra = 0, multi	= 0;
 	u8 mode = 0, unit	= drive->select.b.unit;
 	unsigned long base	= (unsigned long)hwif->hwif_data;
-	u8 scsc = 0, addr_mask	= ((hwif->channel) ?
-				    ((hwif->mmio) ? 0xF4 : 0x84) :
-				    ((hwif->mmio) ? 0xB4 : 0x80));
-				    
+	u8 scsc = 0, addr_mask	= hwif->channel ?
+					(hwif->mmio ? 0xF4 : 0x84) :
+					(hwif->mmio ? 0xB4 : 0x80);
 	unsigned long ma	= siimage_seldev(drive, 0x08);
 	unsigned long ua	= siimage_seldev(drive, 0x0C);
 
-	if (hwif->mmio) {
-		scsc = hwif->INB(base + 0x4A);
-		mode = hwif->INB(base + addr_mask);
-		multi = hwif->INW(ma);
-		ultra = hwif->INW(ua);
-	} else {
-		pci_read_config_byte(dev, 0x8A, &scsc);
-		pci_read_config_byte(dev, addr_mask, &mode);
-		pci_read_config_word(dev, ma, &multi);
-		pci_read_config_word(dev, ua, &ultra);
-	}
+	scsc  = sil_ioread8 (dev, base + (hwif->mmio ? 0x4A : 0x8A));
+	mode  = sil_ioread8 (dev, base + addr_mask);
+	multi = sil_ioread16(dev, ma);
+	ultra = sil_ioread16(dev, ua);
 
-	mode &= ~((unit) ? 0x30 : 0x03);
+	mode  &= ~(unit ? 0x30 : 0x03);
 	ultra &= ~0x3F;
 	scsc = ((scsc & 0x30) == 0x00) ? 0 : 1;
 
 	scsc = is_sata(hwif) ? 1 : scsc;
 
 	if (speed >= XFER_UDMA_0) {
-		multi = dma[2];
-		ultra |= (scsc ? ultra6[speed - XFER_UDMA_0] :
-				 ultra5[speed - XFER_UDMA_0]);
-		mode |= (unit ? 0x30 : 0x03);
+		multi  = dma[2];
+		ultra |= scsc ? ultra6[speed - XFER_UDMA_0] :
+				ultra5[speed - XFER_UDMA_0];
+		mode  |= unit ? 0x30 : 0x03;
 	} else {
 		multi = dma[speed - XFER_MW_DMA_0];
-		mode |= (unit ? 0x20 : 0x02);
+		mode |= unit ? 0x20 : 0x02;
 	}
 
-	if (hwif->mmio) {
-		hwif->OUTB(mode, base + addr_mask);
-		hwif->OUTW(multi, ma);
-		hwif->OUTW(ultra, ua);
-	} else {
-		pci_write_config_byte(dev, addr_mask, mode);
-		pci_write_config_word(dev, ma, multi);
-		pci_write_config_word(dev, ua, ultra);
-	}
+	sil_iowrite8 (dev, mode, base + addr_mask);
+	sil_iowrite16(dev, multi, ma);
+	sil_iowrite16(dev, ultra, ua);
 }
 
 /* returns 1 if dma irq issued, 0 otherwise */
@@ -309,13 +331,14 @@ static int siimage_io_dma_test_irq(ide_drive_t *drive)
 	unsigned long addr	= siimage_selreg(hwif, 1);
 
 	/* return 1 if INTR asserted */
-	if ((hwif->INB(hwif->dma_status) & 4) == 4)
+	if (hwif->INB(hwif->dma_status) & 4)
 		return 1;
 
 	/* return 1 if Device INTR asserted */
 	pci_read_config_byte(dev, addr, &dma_altstat);
 	if (dma_altstat & 8)
-		return 0;	//return 1;
+		return 0;	/* return 1; */
+
 	return 0;
 }
 
@@ -335,9 +358,9 @@ static int siimage_mmio_dma_test_irq(ide_drive_t *drive)
 		= (void __iomem *)hwif->sata_scr[SATA_ERROR_OFFSET];
 
 	if (sata_error_addr) {
-		unsigned long base = (unsigned long)hwif->hwif_data;
-		u32 ext_stat = readl((void __iomem *)(base + 0x10));
-		u8 watchdog = 0;
+		unsigned long base	= (unsigned long)hwif->hwif_data;
+		u32 ext_stat		= readl((void __iomem *)(base + 0x10));
+		u8 watchdog		= 0;
 
 		if (ext_stat & ((hwif->channel) ? 0x40 : 0x10)) {
 			u32 sata_error = readl(sata_error_addr);
@@ -346,25 +369,22 @@ static int siimage_mmio_dma_test_irq(ide_drive_t *drive)
 			watchdog = (sata_error & 0x00680000) ? 1 : 0;
 			printk(KERN_WARNING "%s: sata_error = 0x%08x, "
 				"watchdog = %d, %s\n",
-				drive->name, sata_error, watchdog,
-				__func__);
-
-		} else {
+				drive->name, sata_error, watchdog, __func__);
+		} else
 			watchdog = (ext_stat & 0x8000) ? 1 : 0;
-		}
-		ext_stat >>= 16;
 
+		ext_stat >>= 16;
 		if (!(ext_stat & 0x0404) && !watchdog)
 			return 0;
 	}
 
 	/* return 1 if INTR asserted */
-	if ((readb((void __iomem *)hwif->dma_status) & 0x04) == 0x04)
+	if (readb((void __iomem *)hwif->dma_status) & 0x04)
 		return 1;
 
 	/* return 1 if Device INTR asserted */
-	if ((readb((void __iomem *)addr) & 8) == 8)
-		return 0;	//return 1;
+	if (readb((void __iomem *)addr) & 8)
+		return 0;	/* return 1; */
 
 	return 0;
 }
@@ -423,63 +443,33 @@ static void sil_sata_pre_reset(ide_drive_t *drive)
 }
 
 /**
- *	proc_reports_siimage		-	add siimage controller to proc
- *	@dev: PCI device
- *	@clocking: SCSC value
- *	@name: controller name
- *
- *	Report the clocking mode of the controller and add it to
- *	the /proc interface layer
- */
- 
-static void proc_reports_siimage (struct pci_dev *dev, u8 clocking, const char *name)
-{
-	if (!pdev_is_sata(dev)) {
-		printk(KERN_INFO "%s: BASE CLOCK ", name);
-		clocking &= 0x03;
-		switch (clocking) {
-			case 0x03: printk("DISABLED!\n"); break;
-			case 0x02: printk("== 2X PCI\n"); break;
-			case 0x01: printk("== 133\n"); break;
-			case 0x00: printk("== 100\n"); break;
-		}
-	}
-}
-
-/**
- *	setup_mmio_siimage	-	switch an SI controller into MMIO
+ *	setup_mmio_siimage	-	switch controller into MMIO mode
  *	@dev: PCI device we are configuring
  *	@name: device name
  *
- *	Attempt to put the device into mmio mode. There are some slight
- *	complications here with certain systems where the mmio bar isnt
- *	mapped so we have to be sure we can fall back to I/O.
+ *	Attempt to put the device into MMIO mode. There are some slight
+ *	complications here with certain systems where the MMIO BAR isn't
+ *	mapped, so we have to be sure that we can fall back to I/O.
  */
- 
-static unsigned int setup_mmio_siimage (struct pci_dev *dev, const char *name)
+
+static unsigned int setup_mmio_siimage(struct pci_dev *dev, const char *name)
 {
 	resource_size_t bar5	= pci_resource_start(dev, 5);
 	unsigned long barsize	= pci_resource_len(dev, 5);
-	u8 tmpbyte	= 0;
 	void __iomem *ioaddr;
-	u32 tmp, irq_mask;
 
 	/*
-	 *	Drop back to PIO if we can't map the mmio. Some
-	 *	systems seem to get terminally confused in the PCI
-	 *	spaces.
+	 *	Drop back to PIO if we can't map the MMIO. Some	systems
+	 *	seem to get terminally confused in the PCI spaces.
 	 */
-	 
-	if(!request_mem_region(bar5, barsize, name))
-	{
-		printk(KERN_WARNING "siimage: IDE controller MMIO ports not available.\n");
+	if (!request_mem_region(bar5, barsize, name)) {
+		printk(KERN_WARNING "siimage: IDE controller MMIO ports not "
+				    "available.\n");
 		return 0;
 	}
-		
-	ioaddr = ioremap(bar5, barsize);
 
-	if (ioaddr == NULL)
-	{
+	ioaddr = ioremap(bar5, barsize);
+	if (ioaddr == NULL) {
 		release_mem_region(bar5, barsize);
 		return 0;
 	}
@@ -487,62 +477,6 @@ static unsigned int setup_mmio_siimage (struct pci_dev *dev, const char *name)
 	pci_set_master(dev);
 	pci_set_drvdata(dev, (void *) ioaddr);
 
-	if (pdev_is_sata(dev)) {
-		/* make sure IDE0/1 interrupts are not masked */
-		irq_mask = (1 << 22) | (1 << 23);
-		tmp = readl(ioaddr + 0x48);
-		if (tmp & irq_mask) {
-			tmp &= ~irq_mask;
-			writel(tmp, ioaddr + 0x48);
-			readl(ioaddr + 0x48); /* flush */
-		}
-		writel(0, ioaddr + 0x148);
-		writel(0, ioaddr + 0x1C8);
-	}
-
-	writeb(0, ioaddr + 0xB4);
-	writeb(0, ioaddr + 0xF4);
-	tmpbyte = readb(ioaddr + 0x4A);
-
-	switch(tmpbyte & 0x30) {
-		case 0x00:
-			/* In 100 MHz clocking, try and switch to 133 */
-			writeb(tmpbyte|0x10, ioaddr + 0x4A);
-			break;
-		case 0x10:
-			/* On 133Mhz clocking */
-			break;
-		case 0x20:
-			/* On PCIx2 clocking */
-			break;
-		case 0x30:
-			/* Clocking is disabled */
-			/* 133 clock attempt to force it on */
-			writeb(tmpbyte & ~0x20, ioaddr + 0x4A);
-			break;
-	}
-	
-	writeb(      0x72, ioaddr + 0xA1);
-	writew(    0x328A, ioaddr + 0xA2);
-	writel(0x62DD62DD, ioaddr + 0xA4);
-	writel(0x43924392, ioaddr + 0xA8);
-	writel(0x40094009, ioaddr + 0xAC);
-	writeb(      0x72, ioaddr + 0xE1);
-	writew(    0x328A, ioaddr + 0xE2);
-	writel(0x62DD62DD, ioaddr + 0xE4);
-	writel(0x43924392, ioaddr + 0xE8);
-	writel(0x40094009, ioaddr + 0xEC);
-
-	if (pdev_is_sata(dev)) {
-		writel(0xFFFF0000, ioaddr + 0x108);
-		writel(0xFFFF0000, ioaddr + 0x188);
-		writel(0x00680000, ioaddr + 0x148);
-		writel(0x00680000, ioaddr + 0x1C8);
-	}
-
-	tmpbyte = readb(ioaddr + 0x4A);
-
-	proc_reports_siimage(dev, (tmpbyte>>4), name);
 	return 1;
 }
 
@@ -552,55 +486,92 @@ static unsigned int setup_mmio_siimage (struct pci_dev *dev, const char *name)
  *	@name: device name
  *
  *	Perform the initial PCI set up for this device. Attempt to switch
- *	to 133MHz clocking if the system isn't already set up to do it.
+ *	to 133 MHz clocking if the system isn't already set up to do it.
  */
 
-static unsigned int __devinit init_chipset_siimage(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_siimage(struct pci_dev *dev,
+						   const char *name)
 {
-	u8 rev = dev->revision, tmpbyte = 0, BA5_EN = 0;
+	unsigned long base, scsc_addr;
+	void __iomem *ioaddr = NULL;
+	u8 rev = dev->revision, tmp, BA5_EN;
 
 	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, rev ? 1 : 255);
 
 	pci_read_config_byte(dev, 0x8A, &BA5_EN);
-	if ((BA5_EN & 0x01) || (pci_resource_start(dev, 5))) {
-		if (setup_mmio_siimage(dev, name)) {
-			return 0;
+
+	if ((BA5_EN & 0x01) || pci_resource_start(dev, 5))
+		if (setup_mmio_siimage(dev, name))
+			ioaddr = pci_get_drvdata(dev);
+
+	base = (unsigned long)ioaddr;
+
+	if (ioaddr && pdev_is_sata(dev)) {
+		u32 tmp32, irq_mask;
+
+		/* make sure IDE0/1 interrupts are not masked */
+		irq_mask = (1 << 22) | (1 << 23);
+		tmp32 = readl(ioaddr + 0x48);
+		if (tmp32 & irq_mask) {
+			tmp32 &= ~irq_mask;
+			writel(tmp32, ioaddr + 0x48);
+			readl(ioaddr + 0x48); /* flush */
 		}
+		writel(0, ioaddr + 0x148);
+		writel(0, ioaddr + 0x1C8);
+	}
+
+	sil_iowrite8(dev, 0, base ? (base + 0xB4) : 0x80);
+	sil_iowrite8(dev, 0, base ? (base + 0xF4) : 0x84);
+
+	scsc_addr = base ? (base + 0x4A) : 0x8A;
+	tmp = sil_ioread8(dev, scsc_addr);
+
+	switch (tmp & 0x30) {
+	case 0x00:
+		/* On 100 MHz clocking, try and switch to 133 MHz */
+		sil_iowrite8(dev, tmp | 0x10, scsc_addr);
+		break;
+	case 0x30:
+		/* Clocking is disabled, attempt to force 133MHz clocking. */
+		sil_iowrite8(dev, tmp & ~0x20, scsc_addr);
+	case 0x10:
+		/* On 133Mhz clocking. */
+		break;
+	case 0x20:
+		/* On PCIx2 clocking. */
+		break;
 	}
 
-	pci_write_config_byte(dev, 0x80, 0x00);
-	pci_write_config_byte(dev, 0x84, 0x00);
-	pci_read_config_byte(dev, 0x8A, &tmpbyte);
-	switch(tmpbyte & 0x30) {
-		case 0x00:
-			/* 133 clock attempt to force it on */
-			pci_write_config_byte(dev, 0x8A, tmpbyte|0x10);
-		case 0x30:
-			/* if clocking is disabled */
-			/* 133 clock attempt to force it on */
-			pci_write_config_byte(dev, 0x8A, tmpbyte & ~0x20);
-		case 0x10:
-			/* 133 already */
-			break;
-		case 0x20:
-			/* BIOS set PCI x2 clocking */
-			break;
+	tmp = sil_ioread8(dev, scsc_addr);
+
+	sil_iowrite8 (dev,       0x72, base + 0xA1);
+	sil_iowrite16(dev,     0x328A, base + 0xA2);
+	sil_iowrite32(dev, 0x62DD62DD, base + 0xA4);
+	sil_iowrite32(dev, 0x43924392, base + 0xA8);
+	sil_iowrite32(dev, 0x40094009, base + 0xAC);
+	sil_iowrite8 (dev,       0x72, base ? (base + 0xE1) : 0xB1);
+	sil_iowrite16(dev,     0x328A, base ? (base + 0xE2) : 0xB2);
+	sil_iowrite32(dev, 0x62DD62DD, base ? (base + 0xE4) : 0xB4);
+	sil_iowrite32(dev, 0x43924392, base ? (base + 0xE8) : 0xB8);
+	sil_iowrite32(dev, 0x40094009, base ? (base + 0xEC) : 0xBC);
+
+	if (base && pdev_is_sata(dev)) {
+		writel(0xFFFF0000, ioaddr + 0x108);
+		writel(0xFFFF0000, ioaddr + 0x188);
+		writel(0x00680000, ioaddr + 0x148);
+		writel(0x00680000, ioaddr + 0x1C8);
 	}
 
-	pci_read_config_byte(dev,   0x8A, &tmpbyte);
+	/* report the clocking mode of the controller */
+	if (!pdev_is_sata(dev)) {
+		static const char *clk_str[] =
+			{ "== 100", "== 133", "== 2X PCI", "DISABLED!" };
 
-	pci_write_config_byte(dev,  0xA1, 0x72);
-	pci_write_config_word(dev,  0xA2, 0x328A);
-	pci_write_config_dword(dev, 0xA4, 0x62DD62DD);
-	pci_write_config_dword(dev, 0xA8, 0x43924392);
-	pci_write_config_dword(dev, 0xAC, 0x40094009);
-	pci_write_config_byte(dev,  0xB1, 0x72);
-	pci_write_config_word(dev,  0xB2, 0x328A);
-	pci_write_config_dword(dev, 0xB4, 0x62DD62DD);
-	pci_write_config_dword(dev, 0xB8, 0x43924392);
-	pci_write_config_dword(dev, 0xBC, 0x40094009);
+		tmp >>= 4;
+		printk(KERN_INFO "%s: BASE CLOCK %s\n", name, clk_str[tmp & 3]);
+	}
 
-	proc_reports_siimage(dev, (tmpbyte>>4), name);
 	return 0;
 }
 
@@ -610,8 +581,7 @@ static unsigned int __devinit init_chipset_siimage(struct pci_dev *dev, const ch
  *
  *	The basic setup here is fairly simple, we can use standard MMIO
  *	operations. However we do have to set the taskfile register offsets
- *	by hand as there isnt a standard defined layout for them this
- *	time.
+ *	by hand as there isn't a standard defined layout for them this time.
  *
  *	The hardware supports buffered taskfiles and also some rather nice
  *	extended PRD tables. For better SI3112 support use the libata driver
@@ -622,23 +592,20 @@ static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	void *addr		= pci_get_drvdata(dev);
 	u8 ch			= hwif->channel;
-	unsigned long		base;
-
 	struct ide_io_ports *io_ports = &hwif->io_ports;
+	unsigned long base;
 
 	/*
-	 *	Fill in the basic HWIF bits
+	 *	Fill in the basic hwif bits
 	 */
-
+	hwif->host_flags |= IDE_HFLAG_MMIO;
 	default_hwif_mmiops(hwif);
-	hwif->hwif_data			= addr;
+	hwif->hwif_data	= addr;
 
 	/*
-	 *	Now set up the hw. We have to do this ourselves as
-	 *	the MMIO layout isnt the same as the standard port
-	 *	based I/O
+	 *	Now set up the hw. We have to do this ourselves as the
+	 *	MMIO layout isn't the same as the standard port based I/O.
 	 */
-
 	memset(io_ports, 0, sizeof(*io_ports));
 
 	base = (unsigned long)addr;
@@ -648,10 +615,9 @@ static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 		base += 0x80;
 
 	/*
-	 *	The buffered task file doesn't have status/control
-	 *	so we can't currently use it sanely since we want to
-	 *	use LBA48 mode.
-	 */	
+	 *	The buffered task file doesn't have status/control, so we
+	 *	can't currently use it sanely since we want to use LBA48 mode.
+	 */
 	io_ports->data_addr	= base;
 	io_ports->error_addr	= base + 1;
 	io_ports->nsect_addr	= base + 2;
@@ -680,19 +646,17 @@ static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 
 static int is_dev_seagate_sata(ide_drive_t *drive)
 {
-	const char *s = &drive->id->model[0];
-	unsigned len;
-
-	len = strnlen(s, sizeof(drive->id->model));
+	const char *s	= &drive->id->model[0];
+	unsigned len	= strnlen(s, sizeof(drive->id->model));
 
-	if ((len > 4) && (!memcmp(s, "ST", 2))) {
+	if ((len > 4) && (!memcmp(s, "ST", 2)))
 		if ((!memcmp(s + len - 2, "AS", 2)) ||
 		    (!memcmp(s + len - 3, "ASL", 3))) {
 			printk(KERN_INFO "%s: applying pessimistic Seagate "
 					 "errata fix\n", drive->name);
 			return 1;
 		}
-	}
+
 	return 0;
 }
 
@@ -709,7 +673,7 @@ static void __devinit sil_quirkproc(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	/* Try and raise the rqsize */
+	/* Try and rise the rqsize */
 	if (!is_sata(hwif) || !is_dev_seagate_sata(drive))
 		hwif->rqsize = 128;
 }
@@ -743,20 +707,14 @@ static void __devinit init_iops_siimage(ide_hwif_t *hwif)
  *	sil_cable_detect	-	cable detection
  *	@hwif: interface to check
  *
- *	Check for the presence of an ATA66 capable cable on the
- *	interface.
+ *	Check for the presence of an ATA66 capable cable on the interface.
  */
 
 static u8 __devinit sil_cable_detect(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	unsigned long addr = siimage_selreg(hwif, 0);
-	u8 ata66 = 0;
-
-	if (pci_get_drvdata(dev) == NULL)
-		pci_read_config_byte(dev, addr, &ata66);
-	else
-		ata66 = hwif->INB(addr);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	unsigned long addr	= siimage_selreg(hwif, 0);
+	u8 ata66		= sil_ioread8(dev, addr);
 
 	return (ata66 & 0x01) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
@@ -802,15 +760,16 @@ static const struct ide_port_info siimage_chipsets[] __devinitdata = {
 };
 
 /**
- *	siimage_init_one	-	pci layer discovery entry
+ *	siimage_init_one	-	PCI layer discovery entry
  *	@dev: PCI device
  *	@id: ident table entry
  *
- *	Called by the PCI code when it finds an SI680 or SI3112 controller.
+ *	Called by the PCI code when it finds an SiI680 or SiI3112 controller.
  *	We then use the IDE PCI generic helper to do most of the work.
  */
- 
-static int __devinit siimage_init_one(struct pci_dev *dev, const struct pci_device_id *id)
+
+static int __devinit siimage_init_one(struct pci_dev *dev,
+				      const struct pci_device_id *id)
 {
 	struct ide_port_info d;
 	u8 idx = id->driver_data;
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 3cac6b2..48aa019 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -941,6 +941,7 @@ static const struct ide_port_info pmac_port_info = {
 	.port_ops		= &pmac_ide_port_ops,
 	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
 				  IDE_HFLAG_POST_SET_MODE |
+				  IDE_HFLAG_MMIO |
 				  IDE_HFLAG_UNMASK_IRQS,
 	.pio_mask		= ATA_PIO4,
 	.mwdma_mask		= ATA_MWDMA2,
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 8d88526..1b0eb5a 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -38,7 +38,6 @@ config PCMCIA_DEBUG
 config PCMCIA
 	tristate "16-bit PCMCIA support"
 	select CRC32
-	select HAVE_IDE
 	default y
 	---help---
 	   This option enables support for 16-bit PCMCIA cards. Most older
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 3255363..44d8d51 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -134,6 +134,7 @@ static inline idescsi_scsi_t *drive_to_idescsi(ide_drive_t *ide_drive)
 static void idescsi_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		unsigned int bcount)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	int count;
 	char *buf;
 
@@ -145,14 +146,12 @@ static void idescsi_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 			local_irq_save(flags);
 			buf = kmap_atomic(sg_page(pc->sg), KM_IRQ0) +
 					pc->sg->offset;
-			drive->hwif->atapi_input_bytes(drive,
-						buf + pc->b_count, count);
+			hwif->input_data(drive, NULL, buf + pc->b_count, count);
 			kunmap_atomic(buf - pc->sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
 		} else {
 			buf = sg_virt(pc->sg);
-			drive->hwif->atapi_input_bytes(drive,
-						buf + pc->b_count, count);
+			hwif->input_data(drive, NULL, buf + pc->b_count, count);
 		}
 		bcount -= count; pc->b_count += count;
 		if (pc->b_count == pc->sg->length) {
@@ -165,13 +164,14 @@ static void idescsi_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 
 	if (bcount) {
 		printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
-		ide_atapi_discard_data(drive, bcount);
+		ide_pad_transfer(drive, 0, bcount);
 	}
 }
 
 static void idescsi_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		unsigned int bcount)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	int count;
 	char *buf;
 
@@ -183,14 +183,12 @@ static void idescsi_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 			local_irq_save(flags);
 			buf = kmap_atomic(sg_page(pc->sg), KM_IRQ0) +
 						pc->sg->offset;
-			drive->hwif->atapi_output_bytes(drive,
-						buf + pc->b_count, count);
+			hwif->output_data(drive, NULL, buf + pc->b_count, count);
 			kunmap_atomic(buf - pc->sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
 		} else {
 			buf = sg_virt(pc->sg);
-			drive->hwif->atapi_output_bytes(drive,
-						buf + pc->b_count, count);
+			hwif->output_data(drive, NULL, buf + pc->b_count, count);
 		}
 		bcount -= count; pc->b_count += count;
 		if (pc->b_count == pc->sg->length) {
@@ -203,7 +201,7 @@ static void idescsi_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 
 	if (bcount) {
 		printk (KERN_ERR "ide-scsi: scatter gather table too small, padding with zeros\n");
-		ide_atapi_write_zeros(drive, bcount);
+		ide_pad_transfer(drive, 1, bcount);
 	}
 }
 
@@ -258,7 +256,8 @@ idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTB(WIN_IDLEIMMEDIATE, hwif->io_ports.command_addr);
+		hwif->OUTBSYNC(drive, WIN_IDLEIMMEDIATE,
+			       hwif->io_ports.command_addr);
 
 	rq->errors++;
 
@@ -431,14 +430,15 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 						idescsi_input_buffers(drive, pc,
 									temp);
 					else
-						drive->hwif->atapi_input_bytes(drive, pc->cur_pos, temp);
+						hwif->input_data(drive, NULL,
+							pc->cur_pos, temp);
 					printk(KERN_ERR "ide-scsi: transferred"
 							" %d of %d bytes\n",
 							temp, bcount);
 				}
 				pc->xferred += temp;
 				pc->cur_pos += temp;
-				ide_atapi_discard_data(drive, bcount - temp);
+				ide_pad_transfer(drive, 0, bcount - temp);
 				ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 				return ide_started;
 			}
@@ -452,15 +452,13 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 		if (pc->sg)
 			idescsi_input_buffers(drive, pc, bcount);
 		else
-			hwif->atapi_input_bytes(drive, pc->cur_pos,
-						bcount);
+			hwif->input_data(drive, NULL, pc->cur_pos, bcount);
 	} else {
 		pc->flags |= PC_FLAG_WRITING;
 		if (pc->sg)
 			idescsi_output_buffers(drive, pc, bcount);
 		else
-			hwif->atapi_output_bytes(drive, pc->cur_pos,
-						 bcount);
+			hwif->output_data(drive, NULL, pc->cur_pos, bcount);
 	}
 	/* Update the current position */
 	pc->xferred += bcount;
@@ -493,8 +491,10 @@ static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 	BUG_ON(HWGROUP(drive)->handler != NULL);
 	/* Set the interrupt routine */
 	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
+
 	/* Send the actual packet */
-	drive->hwif->atapi_output_bytes(drive, scsi->pc->c, 12);
+	hwif->output_data(drive, NULL, scsi->pc->c, 12);
+
 	if (pc->flags & PC_FLAG_DMA_OK) {
 		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
 		hwif->dma_ops->dma_start(drive);
@@ -574,7 +574,7 @@ static ide_startstop_t idescsi_issue_pc(ide_drive_t *drive,
 		return ide_started;
 	} else {
 		/* Issue the packet command */
-		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports.command_addr);
+		ide_execute_pkt_cmd(drive);
 		return idescsi_transfer_pc(drive);
 	}
 }
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 32fd77b..b0135b0 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -427,6 +427,8 @@ struct ide_dma_ops {
 	void	(*dma_timeout)(struct ide_drive_s *);
 };
 
+struct ide_task_s;
+
 typedef struct hwif_s {
 	struct hwif_s *next;		/* for linked-list in ide_hwgroup_t */
 	struct hwif_s *mate;		/* other hwif from same PCI chip */
@@ -467,24 +469,18 @@ typedef struct hwif_s {
 	const struct ide_port_ops	*port_ops;
 	const struct ide_dma_ops	*dma_ops;
 
-	void (*ata_input_data)(ide_drive_t *, void *, u32);
-	void (*ata_output_data)(ide_drive_t *, void *, u32);
+	void (*tf_load)(ide_drive_t *, struct ide_task_s *);
+	void (*tf_read)(ide_drive_t *, struct ide_task_s *);
 
-	void (*atapi_input_bytes)(ide_drive_t *, void *, u32);
-	void (*atapi_output_bytes)(ide_drive_t *, void *, u32);
+	void (*input_data)(ide_drive_t *, struct request *, void *, unsigned);
+	void (*output_data)(ide_drive_t *, struct request *, void *, unsigned);
 
 	void (*ide_dma_clear_irq)(ide_drive_t *drive);
 
 	void (*OUTB)(u8 addr, unsigned long port);
 	void (*OUTBSYNC)(ide_drive_t *drive, u8 addr, unsigned long port);
-	void (*OUTW)(u16 addr, unsigned long port);
-	void (*OUTSW)(unsigned long port, void *addr, u32 count);
-	void (*OUTSL)(unsigned long port, void *addr, u32 count);
 
 	u8  (*INB)(unsigned long port);
-	u16 (*INW)(unsigned long port);
-	void (*INSW)(unsigned long port, void *addr, u32 count);
-	void (*INSL)(unsigned long port, void *addr, u32 count);
 
 	/* dma physical region descriptor table (cpu view) */
 	unsigned int	*dmatable_cpu;
@@ -509,10 +505,7 @@ typedef struct hwif_s {
 
 	unsigned long	dma_base;	/* base addr for dma ports */
 	unsigned long	dma_command;	/* dma command register */
-	unsigned long	dma_vendor1;	/* dma vendor 1 register */
 	unsigned long	dma_status;	/* dma status register */
-	unsigned long	dma_vendor3;	/* dma vendor 3 register */
-	unsigned long	dma_prdtable;	/* actual prd table address */
 
 	unsigned long	config_data;	/* for use by chipset-specific code */
 	unsigned long	select_data;	/* for use by chipset-specific code */
@@ -547,7 +540,7 @@ typedef ide_startstop_t (ide_handler_t)(ide_drive_t *);
 typedef int (ide_expiry_t)(ide_drive_t *);
 
 /* used by ide-cd, ide-floppy, etc. */
-typedef void (xfer_func_t)(ide_drive_t *, void *, u32);
+typedef void (xfer_func_t)(ide_drive_t *, struct request *rq, void *, unsigned);
 
 typedef struct hwgroup_s {
 		/* irq handler, if active */
@@ -829,6 +822,10 @@ extern void ide_set_handler (ide_drive_t *drive, ide_handler_t *handler, unsigne
 void ide_execute_command(ide_drive_t *, u8, ide_handler_t *, unsigned int,
 			 ide_expiry_t *);
 
+void ide_execute_pkt_cmd(ide_drive_t *);
+
+void ide_pad_transfer(ide_drive_t *, int, int);
+
 ide_startstop_t __ide_error(ide_drive_t *, struct request *, u8, u8);
 
 ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, byte stat);
@@ -965,8 +962,7 @@ typedef struct ide_task_s {
 	void			*special;	/* valid_t generally */
 } ide_task_t;
 
-void ide_tf_load(ide_drive_t *, ide_task_t *);
-void ide_tf_read(ide_drive_t *, ide_task_t *);
+void ide_tf_dump(const char *, struct ide_taskfile *);
 
 extern void SELECT_DRIVE(ide_drive_t *);
 extern void SELECT_MASK(ide_drive_t *, int);
@@ -1072,6 +1068,8 @@ enum {
 	IDE_HFLAG_NO_DMA		= (1 << 14),
 	/* check if host is PCI IDE device before allowing DMA */
 	IDE_HFLAG_NO_AUTODMA		= (1 << 15),
+	/* host uses MMIO */
+	IDE_HFLAG_MMIO			= (1 << 16),
 	/* host is CS5510/CS5520 */
 	IDE_HFLAG_CS5520		= IDE_HFLAG_VDMA,
 	/* no LBA48 */
@@ -1360,27 +1358,4 @@ static inline u8 ide_read_error(ide_drive_t *drive)
 
 	return hwif->INB(hwif->io_ports.error_addr);
 }
-
-/*
- * Too bad. The drive wants to send us data which we are not ready to accept.
- * Just throw it away.
- */
-static inline void ide_atapi_discard_data(ide_drive_t *drive, unsigned bcount)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	/* FIXME: use ->atapi_input_bytes */
-	while (bcount--)
-		(void)hwif->INB(hwif->io_ports.data_addr);
-}
-
-static inline void ide_atapi_write_zeros(ide_drive_t *drive, unsigned bcount)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	/* FIXME: use ->atapi_output_bytes */
-	while (bcount--)
-		hwif->OUTB(0, hwif->io_ports.data_addr);
-}
-
 #endif /* _IDE_H */
