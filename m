Return-Path: <linux-kernel-owner+w=401wt.eu-S1762800AbYDZUig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762800AbYDZUig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760445AbYDZUiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:38:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:53083 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760247AbYDZUh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=G95vgJ+rkPlpLCqmAifrW9GVayaA7/AOnIYdXF3XjiPhVB612UlEC79EE30HWTr1KKUtnEfFa90XCDGMbAGYZpnokrtxVCeSB3zDkpEiyg0GsCkouCAbz/ym7dlomkBZX1tekCU0QZEtS/e9SjEOXhRuSG/qRcET9x1InDGTKtA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates part 3
Date: Sat, 26 Apr 2008 22:52:16 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804262252.16939.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The previous IDE update is in the mainline and there is also -git9
snapshot containing it so lets have two IDE updates the same day!

- rework of I/O and MEM resource handling, the final part

- add struct ide_port_ops and struct ide_dma_ops
  (a lot of help to get it right from Sergei Shtylyov)

- cleanup patches (Borislav Petkov and Harvey Harrison)

- misc changes


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/mips/AU1xxx_IDE.README      |   46 ---
 drivers/ide/arm/bast-ide.c                |    3 +-
 drivers/ide/arm/icside.c                  |   56 ++-
 drivers/ide/arm/ide_arm.c                 |   18 +-
 drivers/ide/arm/palm_bk3710.c             |   28 +-
 drivers/ide/arm/rapide.c                  |    1 -
 drivers/ide/cris/ide-cris.c               |   33 +-
 drivers/ide/h8300/ide-h8300.c             |    1 -
 drivers/ide/ide-acpi.c                    |   12 +-
 drivers/ide/ide-cd.c                      |  585 +++++++++++++++--------------
 drivers/ide/ide-dma.c                     |  140 ++------
 drivers/ide/ide-floppy.c                  |    6 +-
 drivers/ide/ide-generic.c                 |   20 +-
 drivers/ide/ide-io.c                      |   13 +-
 drivers/ide/ide-iops.c                    |   38 ++-
 drivers/ide/ide-lib.c                     |   26 +-
 drivers/ide/ide-pnp.c                     |   28 ++-
 drivers/ide/ide-probe.c                   |  164 ++++++---
 drivers/ide/ide-proc.c                    |    6 +-
 drivers/ide/ide-scan-pci.c                |    2 +-
 drivers/ide/ide-tape.c                    |   35 +-
 drivers/ide/ide-taskfile.c                |   19 +-
 drivers/ide/ide.c                         |   86 +----
 drivers/ide/legacy/ali14xx.c              |   38 +--
 drivers/ide/legacy/buddha.c               |    2 -
 drivers/ide/legacy/dtc2278.c              |   36 +--
 drivers/ide/legacy/falconide.c            |    1 -
 drivers/ide/legacy/gayle.c                |    2 -
 drivers/ide/legacy/ht6560b.c              |   46 +--
 drivers/ide/legacy/ide-4drives.c          |   18 +-
 drivers/ide/legacy/ide-cs.c               |   76 +++--
 drivers/ide/legacy/ide_platform.c         |    1 -
 drivers/ide/legacy/macide.c               |    2 -
 drivers/ide/legacy/q40ide.c               |    1 -
 drivers/ide/legacy/qd65xx.c               |  130 ++-----
 drivers/ide/legacy/umc8672.c              |   37 +--
 drivers/ide/mips/au1xxx-ide.c             |  115 ++----
 drivers/ide/mips/swarm.c                  |    4 +-
 drivers/ide/pci/aec62xx.c                 |   34 +-
 drivers/ide/pci/alim15x3.c                |   89 +++--
 drivers/ide/pci/amd74xx.c                 |   13 +-
 drivers/ide/pci/atiixp.c                  |   24 +-
 drivers/ide/pci/cmd640.c                  |   45 ++-
 drivers/ide/pci/cmd64x.c                  |  138 ++++---
 drivers/ide/pci/cs5520.c                  |   26 +-
 drivers/ide/pci/cs5530.c                  |   15 +-
 drivers/ide/pci/cs5535.c                  |   22 +-
 drivers/ide/pci/cy82c693.c                |   16 +-
 drivers/ide/pci/delkin_cb.c               |    7 +-
 drivers/ide/pci/hpt34x.c                  |   15 +-
 drivers/ide/pci/hpt366.c                  |  128 +++++---
 drivers/ide/pci/it8213.c                  |   22 +-
 drivers/ide/pci/it821x.c                  |   27 +-
 drivers/ide/pci/jmicron.c                 |   25 +-
 drivers/ide/pci/ns87415.c                 |   25 +-
 drivers/ide/pci/opti621.c                 |   16 +-
 drivers/ide/pci/pdc202xx_new.c            |   23 +-
 drivers/ide/pci/pdc202xx_old.c            |  126 +++----
 drivers/ide/pci/piix.c                    |   13 +-
 drivers/ide/pci/sc1200.c                  |   36 +-
 drivers/ide/pci/scc_pata.c                |   67 ++--
 drivers/ide/pci/serverworks.c             |   33 +-
 drivers/ide/pci/sgiioc4.c                 |  103 +++---
 drivers/ide/pci/siimage.c                 |  114 +++---
 drivers/ide/pci/sis5513.c                 |   30 +-
 drivers/ide/pci/sl82c105.c                |   80 ++--
 drivers/ide/pci/slc90e66.c                |   14 +-
 drivers/ide/pci/tc86c001.c                |   26 +-
 drivers/ide/pci/triflex.c                 |   11 +-
 drivers/ide/pci/trm290.c                  |   44 +--
 drivers/ide/pci/via82cxxx.c               |   14 +-
 drivers/ide/ppc/mpc8xx.c                  |   12 +-
 drivers/ide/ppc/pmac.c                    |   86 +++--
 drivers/ide/setup-pci.c                   |  101 +++--
 drivers/scsi/ide-scsi.c                   |    6 +-
 include/asm-mips/mach-au1x00/au1xxx_ide.h |   42 --
 include/linux/ide.h                       |  109 +++---
 77 files changed, 1777 insertions(+), 1875 deletions(-)


Bartlomiej Zolnierkiewicz (39):
      ide: add struct ide_port_ops (take 2)
      ide: remove ->noprobe field from ide_hwif_t
      ide: add ide_legacy_device_add() helper
      ide: use ide_legacy_device_add() for qd65xx (take 2)
      qd65xx: cleanup qd_probe()
      ide-pnp: manage I/O resources in driver
      ide-cs: manage I/O resources in driver
      ide: register ports with non-present devices (for warm-plug)
      ide: remove ide_hwif_release_regions()
      ide-generic: manage I/O resources in driver
      ide-4drives: manage I/O resources in driver
      ide_arm: manage I/O resources in driver
      ide: add ide_legacy_init_one() helper
      ide: manage I/O resources in ide_legacy_init_one()
      cmd640: manage I/O resources in driver
      ide: manage resources for PCI devices in ide_pci_enable() (take 3)
      ide: remove ide_hwif_request_regions()
      ide: cleanup setting hwif->mmio flag
      ide: remove ->extra field from struct ide_port_info
      ide: remove ide_dma_iobase()
      ide: remove ->cds field from ide_hwif_t (take 2)
      ide: don't display "BIOS" settings in ide_setup_dma()
      pdc202xx_old: remove init_dma_pdc202xx()
      alim15x3: skip DMA initialization completely on revs < 0x20
      ide: move ide_setup_dma() call out from ->init_dma method
      ide: export ide_allocate_dma_engine()
      ide: factor out setting PCI bus-mastering from ide_hwif_setup_dma()
      ide: cleanup ide_setup_dma()
      au1xxx-ide: fix MWDMA support
      ide: do complete DMA setup in ->init_dma method (take 2)
      ide-pmac: use ->init_dma method
      icside: use ->init_dma method
      sgiioc4: use ->init_dma method
      palm_bk3710: use ->init_dma method
      au1xxx-ide: use ->init_dma method
      sl82c105: check bridge revision in sl82c105_init_one()
      ide: add IDE_HFLAG_SERIALIZE_DMA host flag
      ide: add struct ide_dma_ops (take 3)
      ide: constify struct ide_dma_ops

Borislav Petkov (6):
      ide-cd: include proper headers
      ide-cd: put all proc-related code at one place
      ide-cd: fixup comments
      ide-cd: shorten lines longer than 80 columns
      ide-cd: fix remaining checkpatch.pl issues
      ide-tape: remove idetape_pipeline_active()

Harvey Harrison (1):
      ide: replace remaining __FUNCTION__ occurrences


diff --git a/Documentation/mips/AU1xxx_IDE.README b/Documentation/mips/AU1xxx_IDE.README
index 5c83341..25a6ed1 100644
--- a/Documentation/mips/AU1xxx_IDE.README
+++ b/Documentation/mips/AU1xxx_IDE.README
@@ -46,8 +46,6 @@ Two files are introduced:
 
   a) 'include/asm-mips/mach-au1x00/au1xxx_ide.h'
      containes : struct _auide_hwif
-                 struct drive_list_entry dma_white_list
-                 struct drive_list_entry dma_black_list
                  timing parameters for PIO mode 0/1/2/3/4
                  timing parameters for MWDMA 0/1/2
 
@@ -63,12 +61,6 @@ Four configs variables are introduced:
   CONFIG_BLK_DEV_IDE_AU1XXX_SEQTS_PER_RQ - maximum transfer size
                                            per descriptor
 
-If MWDMA is enabled and the connected hard disc is not on the white list, the
-kernel switches to a "safe mwdma mode" at boot time. In this mode the IDE
-performance is substantial slower then in full speed mwdma. In this case
-please add your hard disc to the white list (follow instruction from 'ADD NEW
-HARD DISC TO WHITE OR BLACK LIST' section).
-
 
 SUPPORTED IDE MODES
 -------------------
@@ -120,44 +112,6 @@ CONFIG_IDEDMA_AUTO=y
 Also undefine 'IDE_AU1XXX_BURSTMODE' in 'drivers/ide/mips/au1xxx-ide.c' to
 disable the burst support on DBDMA controller.
 
-ADD NEW HARD DISC TO WHITE OR BLACK LIST
-----------------------------------------
-
-Step 1 : detect the model name of your hard disc
-
-  a) connect your hard disc to the AU1XXX
-
-  b) boot your kernel and get the hard disc model.
-
-     Example boot log:
-
-     --snipped--
-     Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
-     ide: Assuming 50MHz system bus speed for PIO modes; override with idebus=xx
-     Au1xxx IDE(builtin) configured for MWDMA2
-     Probing IDE interface ide0...
-     hda: Maxtor 6E040L0, ATA DISK drive
-     ide0 at 0xac800000-0xac800007,0xac8001c0 on irq 64
-     hda: max request size: 64KiB
-     hda: 80293248 sectors (41110 MB) w/2048KiB Cache, CHS=65535/16/63, (U)DMA
-     --snipped--
-
-     In this example 'Maxtor 6E040L0'.
-
-Step  2 : edit 'include/asm-mips/mach-au1x00/au1xxx_ide.h'
-
-  Add your hard disc to the dma_white_list or dma_black_list structur.
-
-Step 3 : Recompile the kernel
-
-  Enable MWDMA support in the kernel configuration. Recompile the kernel and
-  reboot.
-
-Step 4 : Tests
-
-  If you have add a hard disc to the white list, please run some stress tests
-  for verification.
-
 
 ACKNOWLEDGMENTS
 ---------------
diff --git a/drivers/ide/arm/bast-ide.c b/drivers/ide/arm/bast-ide.c
index a80b957..d158f57 100644
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -55,8 +55,7 @@ static int __init bastide_register(unsigned int base, unsigned int aux, int irq)
 		ide_init_port_data(hwif, i);
 
 	ide_init_port_hw(hwif, &hw);
-	hwif->mmio = 1;
-	hwif->quirkproc = NULL;
+	hwif->port_ops = NULL;
 
 	idx[0] = i;
 
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index fd12bbe..7d642f4 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -191,6 +191,10 @@ static void icside_maskproc(ide_drive_t *drive, int mask)
 	local_irq_restore(flags);
 }
 
+static const struct ide_port_ops icside_v6_no_dma_port_ops = {
+	.maskproc		= icside_maskproc,
+};
+
 #ifdef CONFIG_BLK_DEV_IDEDMA_ICS
 /*
  * SG-DMA support.
@@ -266,6 +270,11 @@ static void icside_set_dma_mode(ide_drive_t *drive, const u8 xfer_mode)
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
@@ -375,25 +384,33 @@ static void icside_dma_lost_irq(ide_drive_t *drive)
 	printk(KERN_ERR "%s: IRQ lost\n", drive->name);
 }
 
-static void icside_dma_init(ide_hwif_t *hwif)
+static int icside_dma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
 	hwif->dmatable_cpu	= NULL;
 	hwif->dmatable_dma	= 0;
-	hwif->set_dma_mode	= icside_set_dma_mode;
-
-	hwif->dma_host_set	= icside_dma_host_set;
-	hwif->dma_setup		= icside_dma_setup;
-	hwif->dma_exec_cmd	= icside_dma_exec_cmd;
-	hwif->dma_start		= icside_dma_start;
-	hwif->ide_dma_end	= icside_dma_end;
-	hwif->ide_dma_test_irq	= icside_dma_test_irq;
-	hwif->dma_timeout	= icside_dma_timeout;
-	hwif->dma_lost_irq	= icside_dma_lost_irq;
+
+	return 0;
 }
+
+static const struct ide_dma_ops icside_v6_dma_ops = {
+	.dma_host_set		= icside_dma_host_set,
+	.dma_setup		= icside_dma_setup,
+	.dma_exec_cmd		= icside_dma_exec_cmd,
+	.dma_start		= icside_dma_start,
+	.dma_end		= icside_dma_end,
+	.dma_test_irq		= icside_dma_test_irq,
+	.dma_timeout		= icside_dma_timeout,
+	.dma_lost_irq		= icside_dma_lost_irq,
+};
 #else
-#define icside_dma_init(hwif)	(0)
+#define icside_v6_dma_ops NULL
 #endif
 
+static int icside_dma_off_init(ide_hwif_t *hwif, const struct ide_port_info *d)
+{
+	return -EOPNOTSUPP;
+}
+
 static ide_hwif_t *
 icside_setup(void __iomem *base, struct cardinfo *info, struct expansion_card *ec)
 {
@@ -408,7 +425,6 @@ icside_setup(void __iomem *base, struct cardinfo *info, struct expansion_card *e
 		 * Ensure we're using MMIO
 		 */
 		default_hwif_mmiops(hwif);
-		hwif->mmio = 1;
 
 		for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
 			hwif->io_ports[i] = port;
@@ -416,7 +432,6 @@ icside_setup(void __iomem *base, struct cardinfo *info, struct expansion_card *e
 		}
 		hwif->io_ports[IDE_CONTROL_OFFSET] = (unsigned long)base + info->ctrloffset;
 		hwif->irq     = ec->irq;
-		hwif->noprobe = 0;
 		hwif->chipset = ide_acorn;
 		hwif->gendev.parent = &ec->dev;
 		hwif->dev = &ec->dev;
@@ -462,8 +477,10 @@ icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 }
 
 static const struct ide_port_info icside_v6_port_info __initdata = {
+	.init_dma		= icside_dma_off_init,
+	.port_ops		= &icside_v6_no_dma_port_ops,
+	.dma_ops		= &icside_v6_dma_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
-				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
 				  IDE_HFLAG_NO_AUTOTUNE,
 	.mwdma_mask		= ATA_MWDMA2,
 	.swdma_mask		= ATA_SWDMA2,
@@ -526,7 +543,6 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 	state->hwif[0]    = hwif;
 	state->hwif[1]    = mate;
 
-	hwif->maskproc    = icside_maskproc;
 	hwif->hwif_data   = state;
 	hwif->config_data = (unsigned long)ioc_base;
 	hwif->select_data = sel;
@@ -537,10 +553,10 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 	mate->select_data = sel | 1;
 
 	if (ec->dma != NO_DMA && !request_dma(ec->dma, hwif->name)) {
-		icside_dma_init(hwif);
-		icside_dma_init(mate);
-	} else
-		d.mwdma_mask = d.swdma_mask = 0;
+		d.init_dma = icside_dma_init;
+		d.port_ops = &icside_v6_dma_port_ops;
+		d.dma_ops = NULL;
+	}
 
 	idx[0] = hwif->index;
 	idx[1] = mate->index;
diff --git a/drivers/ide/arm/ide_arm.c b/drivers/ide/arm/ide_arm.c
index 82643df..4263ffd 100644
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -14,6 +14,8 @@
 #include <asm/mach-types.h>
 #include <asm/irq.h>
 
+#define DRV_NAME "ide_arm"
+
 #ifdef CONFIG_ARCH_CLPS7500
 # include <asm/arch/hardware.h>
 #
@@ -28,10 +30,24 @@ static int __init ide_arm_init(void)
 {
 	ide_hwif_t *hwif;
 	hw_regs_t hw;
+	unsigned long base = IDE_ARM_IO, ctl = IDE_ARM_IO + 0x206;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
+	if (!request_region(base, 8, DRV_NAME)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
+				DRV_NAME, base, base + 7);
+		return -EBUSY;
+	}
+
+	if (!request_region(ctl, 1, DRV_NAME)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
+				DRV_NAME, ctl);
+		release_region(base, 8);
+		return -EBUSY;
+	}
+
 	memset(&hw, 0, sizeof(hw));
-	ide_std_init_ports(&hw, IDE_ARM_IO, IDE_ARM_IO + 0x206);
+	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = IDE_ARM_IRQ;
 
 	hwif = ide_find_port();
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index 666df77..8fa34e2 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -317,17 +317,31 @@ static u8 __devinit palm_bk3710_cable_detect(ide_hwif_t *hwif)
 	return ATA_CBL_PATA80;
 }
 
-static void __devinit palm_bk3710_init_hwif(ide_hwif_t *hwif)
+static int __devinit palm_bk3710_init_dma(ide_hwif_t *hwif,
+					  const struct ide_port_info *d)
 {
-	hwif->set_pio_mode = palm_bk3710_set_pio_mode;
-	hwif->set_dma_mode = palm_bk3710_set_dma_mode;
+	unsigned long base =
+		hwif->io_ports[IDE_DATA_OFFSET] - IDE_PALM_ATA_PRI_REG_OFFSET;
 
-	hwif->cable_detect = palm_bk3710_cable_detect;
+	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
+
+	if (ide_allocate_dma_engine(hwif))
+		return -1;
+
+	ide_setup_dma(hwif, base);
+
+	return 0;
 }
 
+static const struct ide_port_ops palm_bk3710_ports_ops = {
+	.set_pio_mode		= palm_bk3710_set_pio_mode,
+	.set_dma_mode		= palm_bk3710_set_dma_mode,
+	.cable_detect		= palm_bk3710_cable_detect,
+};
+
 static const struct ide_port_info __devinitdata palm_bk3710_port_info = {
-	.init_hwif		= palm_bk3710_init_hwif,
-	.host_flags		= IDE_HFLAG_NO_DMA, /* hack (no PCI) */
+	.init_dma		= palm_bk3710_init_dma,
+	.port_ops		= &palm_bk3710_ports_ops,
 	.pio_mask		= ATA_PIO4,
 	.udma_mask		= ATA_UDMA4,	/* (input clk 99MHz) */
 	.mwdma_mask		= ATA_MWDMA2,
@@ -394,8 +408,6 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 	hwif->mmio = 1;
 	default_hwif_mmiops(hwif);
 
-	ide_setup_dma(hwif, mem->start);
-
 	idx[0] = i;
 
 	ide_device_add(idx, &palm_bk3710_port_info);
diff --git a/drivers/ide/arm/rapide.c b/drivers/ide/arm/rapide.c
index 2c3d0ec..c0581bd 100644
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -53,7 +53,6 @@ rapide_probe(struct expansion_card *ec, const struct ecard_id *id)
 
 		ide_init_port_hw(hwif, &hw);
 
-		hwif->mmio = 1;
 		default_hwif_mmiops(hwif);
 
 		idx[0] = hwif->index;
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 790a775..a62ca75 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -673,11 +673,6 @@ cris_ide_inb(unsigned long reg)
 	return (unsigned char)cris_ide_inw(reg);
 }
 
-static int cris_dma_end (ide_drive_t *drive);
-static int cris_dma_setup (ide_drive_t *drive);
-static void cris_dma_exec_cmd (ide_drive_t *drive, u8 command);
-static int cris_dma_test_irq(ide_drive_t *drive);
-static void cris_dma_start(ide_drive_t *drive);
 static void cris_ide_input_data (ide_drive_t *drive, void *, unsigned int);
 static void cris_ide_output_data (ide_drive_t *drive, void *, unsigned int);
 static void cris_atapi_input_bytes(ide_drive_t *drive, void *, unsigned int);
@@ -782,8 +777,17 @@ static void __init cris_setup_ports(hw_regs_t *hw, unsigned long base)
 	hw->ack_intr = cris_ide_ack_intr;
 }
 
+static const struct ide_port_ops cris_port_ops = {
+	.set_pio_mode		= cris_set_pio_mode,
+	.set_dma_mode		= cris_set_dma_mode,
+};
+
+static const struct ide_dma_ops cris_dma_ops;
+
 static const struct ide_port_info cris_port_info __initdata = {
 	.chipset		= ide_etrax100,
+	.port_ops		= &cris_port_ops,
+	.dma_ops		= &cris_dma_ops,
 	.host_flags		= IDE_HFLAG_NO_ATAPI_DMA |
 				  IDE_HFLAG_NO_DMA, /* no SFF-style DMA */
 	.pio_mask		= ATA_PIO4,
@@ -809,19 +813,11 @@ static int __init init_e100_ide(void)
 			continue;
 		ide_init_port_data(hwif, hwif->index);
 		ide_init_port_hw(hwif, &hw);
-		hwif->mmio = 1;
-		hwif->set_pio_mode = &cris_set_pio_mode;
-		hwif->set_dma_mode = &cris_set_dma_mode;
+
 		hwif->ata_input_data = &cris_ide_input_data;
 		hwif->ata_output_data = &cris_ide_output_data;
 		hwif->atapi_input_bytes = &cris_atapi_input_bytes;
 		hwif->atapi_output_bytes = &cris_atapi_output_bytes;
-		hwif->dma_host_set = &cris_dma_host_set;
-		hwif->ide_dma_end = &cris_dma_end;
-		hwif->dma_setup = &cris_dma_setup;
-		hwif->dma_exec_cmd = &cris_dma_exec_cmd;
-		hwif->ide_dma_test_irq = &cris_dma_test_irq;
-		hwif->dma_start = &cris_dma_start;
 		hwif->OUTB = &cris_ide_outb;
 		hwif->OUTW = &cris_ide_outw;
 		hwif->OUTBSYNC = &cris_ide_outbsync;
@@ -1076,6 +1072,15 @@ static void cris_dma_start(ide_drive_t *drive)
 	}
 }
 
+static const struct ide_dma_ops cris_dma_ops = {
+	.dma_host_set		= cris_dma_host_set,
+	.dma_setup		= cris_dma_setup,
+	.dma_exec_cmd		= cris_dma_exec_cmd,
+	.dma_start		= cris_dma_start,
+	.dma_end		= cris_dma_end,
+	.dma_test_irq		= cris_dma_test_irq,
+};
+
 module_init(init_e100_ide);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/ide/h8300/ide-h8300.c b/drivers/ide/h8300/ide-h8300.c
index 92b02b9..0708b29 100644
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -74,7 +74,6 @@ static inline void hwif_setup(ide_hwif_t *hwif)
 {
 	default_hwif_iops(hwif);
 
-	hwif->mmio  = 1;
 	hwif->OUTW  = mm_outw;
 	hwif->OUTSW = mm_outsw;
 	hwif->INW   = mm_inw;
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 0f6fb6b..e4ad26e 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -55,7 +55,7 @@ struct ide_acpi_hwif_link {
 /* note: adds function name and KERN_DEBUG */
 #ifdef DEBUGGING
 #define DEBPRINT(fmt, args...)	\
-		printk(KERN_DEBUG "%s: " fmt, __FUNCTION__, ## args)
+		printk(KERN_DEBUG "%s: " fmt, __func__, ## args)
 #else
 #define DEBPRINT(fmt, args...)	do {} while (0)
 #endif	/* DEBUGGING */
@@ -309,7 +309,7 @@ static int do_drive_get_GTF(ide_drive_t *drive,
 	if (ACPI_FAILURE(status)) {
 		printk(KERN_DEBUG
 		       "%s: Run _GTF error: status = 0x%x\n",
-		       __FUNCTION__, status);
+		       __func__, status);
 		goto out;
 	}
 
@@ -335,7 +335,7 @@ static int do_drive_get_GTF(ide_drive_t *drive,
 	    out_obj->buffer.length % REGS_PER_GTF) {
 		printk(KERN_ERR
 		       "%s: unexpected GTF length (%d) or addr (0x%p)\n",
-		       __FUNCTION__, out_obj->buffer.length,
+		       __func__, out_obj->buffer.length,
 		       out_obj->buffer.pointer);
 		err = -ENOENT;
 		kfree(output.pointer);
@@ -384,7 +384,7 @@ static int taskfile_load_raw(ide_drive_t *drive,
 	err = ide_no_data_taskfile(drive, &args);
 	if (err)
 		printk(KERN_ERR "%s: ide_no_data_taskfile failed: %u\n",
-		       __FUNCTION__, err);
+		       __func__, err);
 
 	return err;
 }
@@ -422,7 +422,7 @@ static int do_drive_set_taskfiles(ide_drive_t *drive,
 
 	if (gtf_length % REGS_PER_GTF) {
 		printk(KERN_ERR "%s: unexpected GTF length (%d)\n",
-		       __FUNCTION__, gtf_length);
+		       __func__, gtf_length);
 		goto out;
 	}
 
@@ -547,7 +547,7 @@ void ide_acpi_get_timing(ide_hwif_t *hwif)
 		printk(KERN_ERR
 			"%s: unexpected _GTM length (0x%x)[should be 0x%zx] or "
 			"addr (0x%p)\n",
-			__FUNCTION__, out_obj->buffer.length,
+			__func__, out_obj->buffer.length,
 			sizeof(struct GTM_buffer), out_obj->buffer.pointer);
 		return;
 	}
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 1afd95a..ad98432 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -39,12 +39,13 @@
 #include <linux/mutex.h>
 #include <linux/bcd.h>
 
-#include <scsi/scsi.h>	/* For SCSI -> ATAPI command conversion */
+/* For SCSI -> ATAPI command conversion */
+#include <scsi/scsi.h>
 
-#include <asm/irq.h>
-#include <asm/io.h>
+#include <linux/irq.h>
+#include <linux/io.h>
 #include <asm/byteorder.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
 #include "ide-cd.h"
@@ -77,12 +78,11 @@ static void ide_cd_put(struct cdrom_info *cd)
 	mutex_unlock(&idecd_ref_mutex);
 }
 
-/****************************************************************************
+/*
  * Generic packet command support and error handling routines.
  */
 
-/* Mark that we've seen a media change, and invalidate our internal
-   buffers. */
+/* Mark that we've seen a media change and invalidate our internal buffers. */
 static void cdrom_saw_media_change(ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
@@ -105,9 +105,8 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 		break;
 	case NOT_READY:
 		/*
-		 * don't care about tray state messages for
-		 * e.g. capacity commands or in-progress or
-		 * becoming ready
+		 * don't care about tray state messages for e.g. capacity
+		 * commands or in-progress or becoming ready
 		 */
 		if (sense->asc == 0x3a || sense->asc == 0x04)
 			break;
@@ -115,8 +114,8 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 		break;
 	case ILLEGAL_REQUEST:
 		/*
-		 * don't log START_STOP unit with LoEj set, since
-		 * we cannot reliably check if drive can auto-close
+		 * don't log START_STOP unit with LoEj set, since we cannot
+		 * reliably check if drive can auto-close
 		 */
 		if (rq->cmd[0] == GPCMD_START_STOP_UNIT && sense->asc == 0x24)
 			break;
@@ -124,9 +123,9 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 		break;
 	case UNIT_ATTENTION:
 		/*
-		 * Make good and sure we've seen this potential media
-		 * change. Some drives (i.e. Creative) fail to present
-		 * the correct sense key in the error register.
+		 * Make good and sure we've seen this potential media change.
+		 * Some drives (i.e. Creative) fail to present the correct sense
+		 * key in the error register.
 		 */
 		cdrom_saw_media_change(drive);
 		break;
@@ -137,8 +136,7 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 	return log;
 }
 
-static
-void cdrom_analyze_sense_data(ide_drive_t *drive,
+static void cdrom_analyze_sense_data(ide_drive_t *drive,
 			      struct request *failed_command,
 			      struct request_sense *sense)
 {
@@ -151,15 +149,16 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 		return;
 
 	/*
-	 * If a read toc is executed for a CD-R or CD-RW medium where
-	 * the first toc has not been recorded yet, it will fail with
-	 * 05/24/00 (which is a confusing error)
+	 * If a read toc is executed for a CD-R or CD-RW medium where the first
+	 * toc has not been recorded yet, it will fail with 05/24/00 (which is a
+	 * confusing error)
 	 */
 	if (failed_command && failed_command->cmd[0] == GPCMD_READ_TOC_PMA_ATIP)
 		if (sense->sense_key == 0x05 && sense->asc == 0x24)
 			return;
 
-	if (sense->error_code == 0x70) {	/* Current Error */
+	/* current error */
+	if (sense->error_code == 0x70) {
 		switch (sense->sense_key) {
 		case MEDIUM_ERROR:
 		case VOLUME_OVERFLOW:
@@ -178,25 +177,23 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 			if (bio_sectors < 4)
 				bio_sectors = 4;
 			if (drive->queue->hardsect_size == 2048)
-				sector <<= 2;	/* Device sector size is 2K */
+				/* device sector size is 2K */
+				sector <<= 2;
 			sector &= ~(bio_sectors - 1);
 			valid = (sector - failed_command->sector) << 9;
 
 			if (valid < 0)
 				valid = 0;
 			if (sector < get_capacity(info->disk) &&
-				drive->probed_capacity - sector < 4 * 75) {
+			    drive->probed_capacity - sector < 4 * 75)
 				set_capacity(info->disk, sector);
-			}
 		}
 	}
 
 	ide_cd_log_error(drive->name, failed_command, sense);
 }
 
-/*
- * Initialize a ide-cd packet command request
- */
+/* Initialize a ide-cd packet command request */
 void ide_cd_init_rq(ide_drive_t *drive, struct request *rq)
 {
 	struct cdrom_info *cd = drive->driver_data;
@@ -220,7 +217,8 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 
 	rq->data = sense;
 	rq->cmd[0] = GPCMD_REQUEST_SENSE;
-	rq->cmd[4] = rq->data_len = 18;
+	rq->cmd[4] = 18;
+	rq->data_len = 18;
 
 	rq->cmd_type = REQ_TYPE_SENSE;
 
@@ -252,7 +250,7 @@ static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 			}
 			cdrom_analyze_sense_data(drive, failed, sense);
 			/*
-			 * now end failed request
+			 * now end the failed request
 			 */
 			if (blk_fs_request(failed)) {
 				if (ide_end_dequeued_request(drive, failed, 0,
@@ -280,21 +278,24 @@ static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 	ide_end_request(drive, uptodate, nsectors);
 }
 
-static void ide_dump_status_no_sense(ide_drive_t *drive, const char *msg, u8 stat)
+static void ide_dump_status_no_sense(ide_drive_t *drive, const char *msg, u8 st)
 {
-	if (stat & 0x80)
+	if (st & 0x80)
 		return;
-	ide_dump_status(drive, msg, stat);
+	ide_dump_status(drive, msg, st);
 }
 
-/* Returns 0 if the request should be continued.
-   Returns 1 if the request was ended. */
+/*
+ * Returns:
+ * 0: if the request should be continued.
+ * 1: if the request was ended.
+ */
 static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 {
 	struct request *rq = HWGROUP(drive)->rq;
 	int stat, err, sense_key;
 
-	/* Check for errors. */
+	/* check for errors */
 	stat = ide_read_status(drive);
 
 	if (stat_ret)
@@ -303,20 +304,22 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 	if (OK_STAT(stat, good_stat, BAD_R_STAT))
 		return 0;
 
-	/* Get the IDE error register. */
+	/* get the IDE error register */
 	err = ide_read_error(drive);
 	sense_key = err >> 4;
 
 	if (rq == NULL) {
-		printk("%s: missing rq in cdrom_decode_status\n", drive->name);
+		printk(KERN_ERR "%s: missing rq in %s\n",
+				drive->name, __func__);
 		return 1;
 	}
 
 	if (blk_sense_request(rq)) {
-		/* We got an error trying to get sense info
-		   from the drive (probably while trying
-		   to recover from a former error).  Just give up. */
-
+		/*
+		 * We got an error trying to get sense info from the drive
+		 * (probably while trying to recover from a former error).
+		 * Just give up.
+		 */
 		rq->cmd_flags |= REQ_FAILED;
 		cdrom_end_request(drive, 0);
 		ide_error(drive, "request sense failure", stat);
@@ -332,13 +335,12 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		if (blk_pc_request(rq) && !rq->errors)
 			rq->errors = SAM_STAT_CHECK_CONDITION;
 
-		/* Check for tray open. */
+		/* check for tray open */
 		if (sense_key == NOT_READY) {
 			cdrom_saw_media_change(drive);
 		} else if (sense_key == UNIT_ATTENTION) {
-			/* Check for media change. */
+			/* check for media change */
 			cdrom_saw_media_change(drive);
-			/*printk("%s: media changed\n",drive->name);*/
 			return 0;
 		} else if (sense_key == ILLEGAL_REQUEST &&
 			   rq->cmd[0] == GPCMD_START_STOP_UNIT) {
@@ -350,7 +352,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 			 * cdrom_log_sense() knows this!
 			 */
 		} else if (!(rq->cmd_flags & REQ_QUIET)) {
-			/* Otherwise, print an error. */
+			/* otherwise, print an error */
 			ide_dump_status(drive, "packet command error", stat);
 		}
 
@@ -366,27 +368,30 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 	} else if (blk_fs_request(rq)) {
 		int do_end_request = 0;
 
-		/* Handle errors from READ and WRITE requests. */
+		/* handle errors from READ and WRITE requests */
 
 		if (blk_noretry_request(rq))
 			do_end_request = 1;
 
 		if (sense_key == NOT_READY) {
-			/* Tray open. */
+			/* tray open */
 			if (rq_data_dir(rq) == READ) {
 				cdrom_saw_media_change(drive);
 
-				/* Fail the request. */
-				printk("%s: tray open\n", drive->name);
+				/* fail the request */
+				printk(KERN_ERR "%s: tray open\n", drive->name);
 				do_end_request = 1;
 			} else {
 				struct cdrom_info *info = drive->driver_data;
 
-				/* allow the drive 5 seconds to recover, some
+				/*
+				 * Allow the drive 5 seconds to recover, some
 				 * devices will return this error while flushing
-				 * data from cache */
+				 * data from cache.
+				 */
 				if (!rq->errors)
-					info->write_timeout = jiffies + ATAPI_WAIT_WRITE_BUSY;
+					info->write_timeout = jiffies +
+							ATAPI_WAIT_WRITE_BUSY;
 				rq->errors = 1;
 				if (time_after(jiffies, info->write_timeout))
 					do_end_request = 1;
@@ -394,65 +399,68 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 					unsigned long flags;
 
 					/*
-					 * take a breather relying on the
-					 * unplug timer to kick us again
+					 * take a breather relying on the unplug
+					 * timer to kick us again
 					 */
 					spin_lock_irqsave(&ide_lock, flags);
 					blk_plug_device(drive->queue);
-					spin_unlock_irqrestore(&ide_lock, flags);
+					spin_unlock_irqrestore(&ide_lock,
+								flags);
 					return 1;
 				}
 			}
 		} else if (sense_key == UNIT_ATTENTION) {
-			/* Media change. */
-			cdrom_saw_media_change (drive);
+			/* media change */
+			cdrom_saw_media_change(drive);
 
 			/*
-			 * Arrange to retry the request.
-			 * But be sure to give up if we've retried
-			 * too many times.
+			 * Arrange to retry the request but be sure to give up
+			 * if we've retried too many times.
 			 */
 			if (++rq->errors > ERROR_MAX)
 				do_end_request = 1;
 		} else if (sense_key == ILLEGAL_REQUEST ||
 			   sense_key == DATA_PROTECT) {
 			/*
-			 * No point in retrying after an illegal
-			 * request or data protect error.
+			 * No point in retrying after an illegal request or data
+			 * protect error.
 			 */
 			ide_dump_status_no_sense(drive, "command error", stat);
 			do_end_request = 1;
 		} else if (sense_key == MEDIUM_ERROR) {
 			/*
 			 * No point in re-trying a zillion times on a bad
-			 * sector... If we got here the error is not correctable
+			 * sector. If we got here the error is not correctable.
 			 */
-			ide_dump_status_no_sense(drive, "media error (bad sector)", stat);
+			ide_dump_status_no_sense(drive,
+						 "media error (bad sector)",
+						 stat);
 			do_end_request = 1;
 		} else if (sense_key == BLANK_CHECK) {
-			/* Disk appears blank ?? */
-			ide_dump_status_no_sense(drive, "media error (blank)", stat);
+			/* disk appears blank ?? */
+			ide_dump_status_no_sense(drive, "media error (blank)",
+						 stat);
 			do_end_request = 1;
 		} else if ((err & ~ABRT_ERR) != 0) {
-			/* Go to the default handler
-			   for other errors. */
+			/* go to the default handler for other errors */
 			ide_error(drive, "cdrom_decode_status", stat);
 			return 1;
 		} else if ((++rq->errors > ERROR_MAX)) {
-			/* We've racked up too many retries.  Abort. */
+			/* we've racked up too many retries, abort */
 			do_end_request = 1;
 		}
 
-		/* End a request through request sense analysis when we have
-		   sense data. We need this in order to perform end of media
-		   processing */
-
+		/*
+		 * End a request through request sense analysis when we have
+		 * sense data. We need this in order to perform end of media
+		 * processing.
+		 */
 		if (do_end_request)
 			goto end_request;
 
 		/*
-		 * If we got a CHECK_CONDITION status,
-		 * queue a request sense command.
+		 * If we got a CHECK_CONDITION status, queue
+		 * a request sense command.
 		 */
 		if (stat & ERR_STAT)
 			cdrom_queue_request_sense(drive, NULL, NULL);
@@ -461,7 +469,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		cdrom_end_request(drive, 0);
 	}
 
-	/* Retry, or handle the next request. */
+	/* retry, or handle the next request */
 	return 1;
 
 end_request:
@@ -486,10 +494,10 @@ static int cdrom_timer_expiry(ide_drive_t *drive)
 	unsigned long wait = 0;
 
 	/*
-	 * Some commands are *slow* and normally take a long time to
-	 * complete. Usually we can use the ATAPI "disconnect" to bypass
-	 * this, but not all commands/drives support that. Let
-	 * ide_timer_expiry keep polling us for these.
+	 * Some commands are *slow* and normally take a long time to complete.
+	 * Usually we can use the ATAPI "disconnect" to bypass this, but not all
+	 * commands/drives support that. Let ide_timer_expiry keep polling us
+	 * for these.
 	 */
 	switch (rq->cmd[0]) {
 	case GPCMD_BLANK:
@@ -501,20 +509,22 @@ static int cdrom_timer_expiry(ide_drive_t *drive)
 		break;
 	default:
 		if (!(rq->cmd_flags & REQ_QUIET))
-			printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n", rq->cmd[0]);
+			printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n",
+					 rq->cmd[0]);
 		wait = 0;
 		break;
 	}
 	return wait;
 }
 
-/* Set up the device registers for transferring a packet command on DEV,
-   expecting to later transfer XFERLEN bytes.  HANDLER is the routine
-   which actually transfers the command to the drive.  If this is a
-   drq_interrupt device, this routine will arrange for HANDLER to be
-   called when the interrupt from the drive arrives.  Otherwise, HANDLER
-   will be called immediately after the drive is prepared for the transfer. */
-
+/*
+ * Set up the device registers for transferring a packet command on DEV,
+ * expecting to later transfer XFERLEN bytes.  HANDLER is the routine
+ * which actually transfers the command to the drive.  If this is a
+ * drq_interrupt device, this routine will arrange for HANDLER to be
+ * called when the interrupt from the drive arrives.  Otherwise, HANDLER
+ * will be called immediately after the drive is prepared for the transfer.
+ */
 static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 						  int xferlen,
 						  ide_handler_t *handler)
@@ -523,15 +533,15 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 	struct cdrom_info *info = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 
-	/* Wait for the controller to be idle. */
+	/* wait for the controller to be idle */
 	if (ide_wait_stat(&startstop, drive, 0, BUSY_STAT, WAIT_READY))
 		return startstop;
 
 	/* FIXME: for Virtual DMA we must check harder */
 	if (info->dma)
-		info->dma = !hwif->dma_setup(drive);
+		info->dma = !hwif->dma_ops->dma_setup(drive);
 
-	/* Set up the controller registers. */
+	/* set up the controller registers */
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL |
 			   IDE_TFLAG_NO_SELECT_MASK, xferlen, info->dma);
 
@@ -541,7 +551,8 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 			drive->waiting_for_dma = 0;
 
 		/* packet command */
-		ide_execute_command(drive, WIN_PACKETCMD, handler, ATAPI_WAIT_PC, cdrom_timer_expiry);
+		ide_execute_command(drive, WIN_PACKETCMD, handler,
+				    ATAPI_WAIT_PC, cdrom_timer_expiry);
 		return ide_started;
 	} else {
 		unsigned long flags;
@@ -557,11 +568,12 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 	}
 }
 
-/* Send a packet command to DRIVE described by CMD_BUF and CMD_LEN.
-   The device registers must have already been prepared
-   by cdrom_start_packet_command.
-   HANDLER is the interrupt handler to call when the command completes
-   or there's data ready. */
+/*
+ * Send a packet command to DRIVE described by CMD_BUF and CMD_LEN. The device
+ * registers must have already been prepared by cdrom_start_packet_command.
+ * HANDLER is the interrupt handler to call when the command completes or
+ * there's data ready.
+ */
 #define ATAPI_MIN_CDB_BYTES 12
 static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 					  struct request *rq,
@@ -573,24 +585,26 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 	ide_startstop_t startstop;
 
 	if (info->cd_flags & IDE_CD_FLAG_DRQ_INTERRUPT) {
-		/* Here we should have been called after receiving an interrupt
-		   from the device.  DRQ should how be set. */
+		/*
+		 * Here we should have been called after receiving an interrupt
+		 * from the device.  DRQ should how be set.
+		 */
 
-		/* Check for errors. */
+		/* check for errors */
 		if (cdrom_decode_status(drive, DRQ_STAT, NULL))
 			return ide_stopped;
 
-		/* Ok, next interrupt will be DMA interrupt. */
+		/* ok, next interrupt will be DMA interrupt */
 		if (info->dma)
 			drive->waiting_for_dma = 1;
 	} else {
-		/* Otherwise, we must wait for DRQ to get set. */
+		/* otherwise, we must wait for DRQ to get set */
 		if (ide_wait_stat(&startstop, drive, DRQ_STAT,
 				BUSY_STAT, WAIT_READY))
 			return startstop;
 	}
 
-	/* Arm the interrupt handler. */
+	/* arm the interrupt handler */
 	ide_set_handler(drive, handler, rq->timeout, cdrom_timer_expiry);
 
 	/* ATAPI commands get padded out to 12 bytes minimum */
@@ -598,20 +612,19 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 	if (cmd_len < ATAPI_MIN_CDB_BYTES)
 		cmd_len = ATAPI_MIN_CDB_BYTES;
 
-	/* Send the command to the device. */
+	/* send the command to the device */
 	HWIF(drive)->atapi_output_bytes(drive, rq->cmd, cmd_len);
 
-	/* Start the DMA if need be */
+	/* start the DMA if need be */
 	if (info->dma)
-		hwif->dma_start(drive);
+		hwif->dma_ops->dma_start(drive);
 
 	return ide_started;
 }
 
-/****************************************************************************
+/*
  * Block read functions.
  */
-
 static void ide_cd_pad_transfer(ide_drive_t *drive, xfer_func_t *xf, int len)
 {
 	while (len > 0) {
@@ -649,20 +662,21 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 		ide_hwif_t *hwif = drive->hwif;
 		xfer_func_t *xf;
 
-		/* Whoops... */
+		/* whoops... */
 		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
 				drive->name, __func__);
 
 		xf = rw ? hwif->atapi_output_bytes : hwif->atapi_input_bytes;
 		ide_cd_pad_transfer(drive, xf, len);
 	} else  if (rw == 0 && ireason == 1) {
-		/* Some drives (ASUS) seem to tell us that status
-		 * info is available. just get it and ignore.
+		/*
+		 * Some drives (ASUS) seem to tell us that status info is
+		 * available.  Just get it and ignore.
 		 */
 		(void)ide_read_status(drive);
 		return 0;
 	} else {
-		/* Drive wants a command packet, or invalid ireason... */
+		/* drive wants a command packet, or invalid ireason... */
 		printk(KERN_ERR "%s: %s: bad interrupt reason 0x%02x\n",
 				drive->name, __func__, ireason);
 	}
@@ -702,10 +716,10 @@ static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *);
 
 /*
- * Routine to send a read/write packet command to the drive.
- * This is usually called directly from cdrom_start_{read,write}().
- * However, for drq_interrupt devices, it is called from an interrupt
- * when the drive is ready to accept the command.
+ * Routine to send a read/write packet command to the drive. This is usually
+ * called directly from cdrom_start_{read,write}(). However, for drq_interrupt
+ * devices, it is called from an interrupt when the drive is ready to accept
+ * the command.
  */
 static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 {
@@ -727,7 +741,7 @@ static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 		 * is larger than the buffer size.
 		 */
 		if (nskip > 0) {
-			/* Sanity check... */
+			/* sanity check... */
 			if (rq->current_nr_sectors !=
 			    bio_cur_sectors(rq->bio)) {
 				printk(KERN_ERR "%s: %s: buffer botch (%u)\n",
@@ -744,10 +758,10 @@ static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 		/* the immediate bit */
 		rq->cmd[1] = 1 << 3;
 #endif
-	/* Set up the command */
+	/* set up the command */
 	rq->timeout = ATAPI_WAIT_PC;
 
-	/* Send the command to the drive and return. */
+	/* send the command to the drive and return */
 	return cdrom_transfer_packet_command(drive, rq, cdrom_newpc_intr);
 }
 
@@ -767,14 +781,8 @@ static ide_startstop_t cdrom_seek_intr(ide_drive_t *drive)
 	info->cd_flags |= IDE_CD_FLAG_SEEKING;
 
 	if (retry && time_after(jiffies, info->start_seek + IDECD_SEEK_TIMER)) {
-		if (--retry == 0) {
-			/*
-			 * this condition is far too common, to bother
-			 * users about it
-			 */
-			/* printk("%s: disabled DSC seek overlap\n", drive->name);*/
+		if (--retry == 0)
 			drive->dsc_overlap = 0;
-		}
 	}
 	return ide_stopped;
 }
@@ -800,32 +808,34 @@ static ide_startstop_t cdrom_start_seek(ide_drive_t *drive, unsigned int block)
 
 	info->dma = 0;
 	info->start_seek = jiffies;
-	return cdrom_start_packet_command(drive, 0, cdrom_start_seek_continuation);
+	return cdrom_start_packet_command(drive, 0,
+					  cdrom_start_seek_continuation);
 }
 
 /*
- * Fix up a possibly partially-processed request so that we can
- * start it over entirely, or even put it back on the request queue.
+ * Fix up a possibly partially-processed request so that we can start it over
+ * entirely, or even put it back on the request queue.
  */
 static void restore_request(struct request *rq)
 {
 	if (rq->buffer != bio_data(rq->bio)) {
-		sector_t n = (rq->buffer - (char *) bio_data(rq->bio)) / SECTOR_SIZE;
+		sector_t n =
+			(rq->buffer - (char *)bio_data(rq->bio)) / SECTOR_SIZE;
 
 		rq->buffer = bio_data(rq->bio);
 		rq->nr_sectors += n;
 		rq->sector -= n;
 	}
-	rq->hard_cur_sectors = rq->current_nr_sectors = bio_cur_sectors(rq->bio);
+	rq->current_nr_sectors = bio_cur_sectors(rq->bio);
+	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors;
 	rq->hard_sector = rq->sector;
 	rq->q->prep_rq_fn(rq->q, rq);
 }
 
-/****************************************************************************
- * Execute all other packet commands.
+/*
+ * All other packet commands.
  */
-
 static void ide_cd_request_sense_fixup(struct request *rq)
 {
 	/*
@@ -849,7 +859,7 @@ int ide_cd_queue_pc(ide_drive_t *drive, struct request *rq)
 	if (rq->sense == NULL)
 		rq->sense = &sense;
 
-	/* Start of retry loop. */
+	/* start of retry loop */
 	do {
 		int error;
 		unsigned long time = jiffies;
@@ -858,41 +868,45 @@ int ide_cd_queue_pc(ide_drive_t *drive, struct request *rq)
 		error = ide_do_drive_cmd(drive, rq, ide_wait);
 		time = jiffies - time;
 
-		/* FIXME: we should probably abort/retry or something
-		 * in case of failure */
+		/*
+		 * FIXME: we should probably abort/retry or something in case of
+		 * failure.
+		 */
 		if (rq->cmd_flags & REQ_FAILED) {
-			/* The request failed.  Retry if it was due to a unit
-			   attention status
-			   (usually means media was changed). */
+			/*
+			 * The request failed.  Retry if it was due to a unit
+			 * attention status (usually means media was changed).
+			 */
 			struct request_sense *reqbuf = rq->sense;
 
 			if (reqbuf->sense_key == UNIT_ATTENTION)
 				cdrom_saw_media_change(drive);
 			else if (reqbuf->sense_key == NOT_READY &&
 				 reqbuf->asc == 4 && reqbuf->ascq != 4) {
-				/* The drive is in the process of loading
-				   a disk.  Retry, but wait a little to give
-				   the drive time to complete the load. */
+				/*
+				 * The drive is in the process of loading
+				 * a disk.  Retry, but wait a little to give
+				 * the drive time to complete the load.
+				 */
 				ssleep(2);
 			} else {
-				/* Otherwise, don't retry. */
+				/* otherwise, don't retry */
 				retries = 0;
 			}
 			--retries;
 		}
 
-		/* End of retry loop. */
+		/* end of retry loop */
 	} while ((rq->cmd_flags & REQ_FAILED) && retries >= 0);
 
-	/* Return an error if the command failed. */
+	/* return an error if the command failed */
 	return (rq->cmd_flags & REQ_FAILED) ? -EIO : 0;
 }
 
 /*
- * Called from blk_end_request_callback() after the data of the request
- * is completed and before the request is completed.
- * By returning value '1', blk_end_request_callback() returns immediately
- * without completing the request.
+ * Called from blk_end_request_callback() after the data of the request is
+ * completed and before the request itself is completed. By returning value '1',
+ * blk_end_request_callback() returns immediately without completing it.
  */
 static int cdrom_newpc_intr_dummy_cb(struct request *rq)
 {
@@ -911,11 +925,11 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	unsigned int timeout;
 	u8 lowcyl, highcyl;
 
-	/* Check for errors. */
+	/* check for errors */
 	dma = info->dma;
 	if (dma) {
 		info->dma = 0;
-		dma_error = HWIF(drive)->ide_dma_end(drive);
+		dma_error = hwif->dma_ops->dma_end(drive);
 		if (dma_error) {
 			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
 					write ? "write" : "read");
@@ -926,9 +940,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	if (cdrom_decode_status(drive, 0, &stat))
 		return ide_stopped;
 
-	/*
-	 * using dma, transfer is complete now
-	 */
+	/* using dma, transfer is complete now */
 	if (dma) {
 		if (dma_error)
 			return ide_error(drive, "dma error", stat);
@@ -939,9 +951,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		goto end_request;
 	}
 
-	/*
-	 * ok we fall to pio :/
-	 */
+	/* ok we fall to pio :/ */
 	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]) & 0x3;
 	lowcyl  = hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
 	highcyl = hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]);
@@ -952,9 +962,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	if (thislen > len)
 		thislen = len;
 
-	/*
-	 * If DRQ is clear, the command has completed.
-	 */
+	/* If DRQ is clear, the command has completed. */
 	if ((stat & DRQ_STAT) == 0) {
 		if (blk_fs_request(rq)) {
 			/*
@@ -975,15 +983,13 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			return ide_stopped;
 		} else if (!blk_pc_request(rq)) {
 			ide_cd_request_sense_fixup(rq);
-			/* Complain if we still have data left to transfer. */
+			/* complain if we still have data left to transfer */
 			uptodate = rq->data_len ? 0 : 1;
 		}
 		goto end_request;
 	}
 
-	/*
-	 * check which way to transfer data
-	 */
+	/* check which way to transfer data */
 	if (ide_cd_check_ireason(drive, rq, len, ireason, write))
 		return ide_stopped;
 
@@ -1019,16 +1025,12 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		xferfunc = HWIF(drive)->atapi_input_bytes;
 	}
 
-	/*
-	 * transfer data
-	 */
+	/* transfer data */
 	while (thislen > 0) {
 		u8 *ptr = blk_fs_request(rq) ? NULL : rq->data;
 		int blen = rq->data_len;
 
-		/*
-		 * bio backed?
-		 */
+		/* bio backed? */
 		if (rq->bio) {
 			if (blk_fs_request(rq)) {
 				ptr = rq->buffer;
@@ -1043,7 +1045,8 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			if (blk_fs_request(rq) && !write)
 				/*
 				 * If the buffers are full, pipe the rest into
-				 * oblivion. */
+				 * oblivion.
+				 */
 				ide_cd_drain_data(drive, thislen >> 9);
 			else {
 				printk(KERN_ERR "%s: confused, missing data\n",
@@ -1090,9 +1093,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			rq->sense_len += blen;
 	}
 
-	/*
-	 * pad, if necessary
-	 */
+	/* pad, if necessary */
 	if (!blk_fs_request(rq) && len > 0)
 		ide_cd_pad_transfer(drive, xferfunc, len);
 
@@ -1136,9 +1137,7 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 		queue_hardsect_size(drive->queue) >> SECTOR_BITS;
 
 	if (write) {
-		/*
-		 * disk has become write protected
-		 */
+		/* disk has become write protected */
 		if (cd->disk->policy) {
 			cdrom_end_request(drive, 0);
 			return ide_stopped;
@@ -1151,9 +1150,7 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 		restore_request(rq);
 	}
 
-	/*
-	 * use DMA, if possible / writes *must* be hardware frame aligned
-	 */
+	/* use DMA, if possible / writes *must* be hardware frame aligned */
 	if ((rq->nr_sectors & (sectors_per_frame - 1)) ||
 	    (rq->sector & (sectors_per_frame - 1))) {
 		if (write) {
@@ -1167,7 +1164,7 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 	if (write)
 		cd->devinfo.media_written = 1;
 
-	/* Start sending the read/write request to the drive. */
+	/* start sending the read/write request to the drive */
 	return cdrom_start_packet_command(drive, 32768, cdrom_start_rw_cont);
 }
 
@@ -1192,12 +1189,11 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 
 	info->dma = 0;
 
-	/*
-	 * sg request
-	 */
+	/* sg request */
 	if (rq->bio) {
 		int mask = drive->queue->dma_alignment;
-		unsigned long addr = (unsigned long) page_address(bio_page(rq->bio));
+		unsigned long addr =
+			(unsigned long)page_address(bio_page(rq->bio));
 
 		info->dma = drive->using_dma;
 
@@ -1211,15 +1207,16 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 			info->dma = 0;
 	}
 
-	/* Start sending the command to the drive. */
-	return cdrom_start_packet_command(drive, rq->data_len, cdrom_do_newpc_cont);
+	/* start sending the command to the drive */
+	return cdrom_start_packet_command(drive, rq->data_len,
+					  cdrom_do_newpc_cont);
 }
 
-/****************************************************************************
+/*
  * cdrom driver request routine.
  */
-static ide_startstop_t
-ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq, sector_t block)
+static ide_startstop_t ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq,
+					sector_t block)
 {
 	ide_startstop_t action;
 	struct cdrom_info *info = drive->driver_data;
@@ -1231,14 +1228,19 @@ ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq, sector_t block)
 
 			if ((stat & SEEK_STAT) != SEEK_STAT) {
 				if (elapsed < IDECD_SEEK_TIMEOUT) {
-					ide_stall_queue(drive, IDECD_SEEK_TIMER);
+					ide_stall_queue(drive,
+							IDECD_SEEK_TIMER);
 					return ide_stopped;
 				}
-				printk(KERN_ERR "%s: DSC timeout\n", drive->name);
+				printk(KERN_ERR "%s: DSC timeout\n",
+						drive->name);
 			}
 			info->cd_flags &= ~IDE_CD_FLAG_SEEKING;
 		}
-		if ((rq_data_dir(rq) == READ) && IDE_LARGE_SEEK(info->last_block, block, IDECD_SEEK_THRESHOLD) && drive->dsc_overlap)
+		if (rq_data_dir(rq) == READ &&
+		    IDE_LARGE_SEEK(info->last_block, block,
+				   IDECD_SEEK_THRESHOLD) &&
+		    drive->dsc_overlap)
 			action = cdrom_start_seek(drive, block);
 		else
 			action = cdrom_start_rw(drive, rq);
@@ -1248,9 +1250,7 @@ ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq, sector_t block)
 		   rq->cmd_type == REQ_TYPE_ATA_PC) {
 		return cdrom_do_block_pc(drive, rq);
 	} else if (blk_special_request(rq)) {
-		/*
-		 * right now this can only be a reset...
-		 */
+		/* right now this can only be a reset... */
 		cdrom_end_request(drive, 1);
 		return ide_stopped;
 	}
@@ -1262,18 +1262,16 @@ ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq, sector_t block)
 
 
 
-/****************************************************************************
+/*
  * Ioctl handling.
  *
- * Routines which queue packet commands take as a final argument a pointer
- * to a request_sense struct.  If execution of the command results
- * in an error with a CHECK CONDITION status, this structure will be filled
- * with the results of the subsequent request sense command.  The pointer
- * can also be NULL, in which case no sense information is returned.
+ * Routines which queue packet commands take as a final argument a pointer to a
+ * request_sense struct. If execution of the command results in an error with a
+ * CHECK CONDITION status, this structure will be filled with the results of the
+ * subsequent request sense command. The pointer can also be NULL, in which case
+ * no sense information is returned.
  */
-
-static
-void msf_from_bcd(struct atapi_msf *msf)
+static void msf_from_bcd(struct atapi_msf *msf)
 {
 	msf->minute = BCD2BIN(msf->minute);
 	msf->second = BCD2BIN(msf->second);
@@ -1293,8 +1291,8 @@ int cdrom_check_status(ide_drive_t *drive, struct request_sense *sense)
 	req.cmd_flags |= REQ_QUIET;
 
 	/*
-	 * Sanyo 3 CD changer uses byte 7 of TEST_UNIT_READY to
-	 * switch CDs instead of supporting the LOAD_UNLOAD opcode.
+	 * Sanyo 3 CD changer uses byte 7 of TEST_UNIT_READY to switch CDs
+	 * instead of supporting the LOAD_UNLOAD opcode.
 	 */
 	req.cmd[7] = cdi->sanyo_slot % 3;
 
@@ -1370,36 +1368,39 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	unsigned long sectors_per_frame = SECTORS_PER_FRAME;
 
 	if (toc == NULL) {
-		/* Try to allocate space. */
+		/* try to allocate space */
 		toc = kmalloc(sizeof(struct atapi_toc), GFP_KERNEL);
 		if (toc == NULL) {
-			printk(KERN_ERR "%s: No cdrom TOC buffer!\n", drive->name);
+			printk(KERN_ERR "%s: No cdrom TOC buffer!\n",
+					drive->name);
 			return -ENOMEM;
 		}
 		info->toc = toc;
 	}
 
-	/* Check to see if the existing data is still valid.
-	   If it is, just return. */
+	/*
+	 * Check to see if the existing data is still valid. If it is,
+	 * just return.
+	 */
 	(void) cdrom_check_status(drive, sense);
 
 	if (info->cd_flags & IDE_CD_FLAG_TOC_VALID)
 		return 0;
 
-	/* Try to get the total cdrom capacity and sector size. */
+	/* try to get the total cdrom capacity and sector size */
 	stat = cdrom_read_capacity(drive, &toc->capacity, &sectors_per_frame,
 				   sense);
 	if (stat)
 		toc->capacity = 0x1fffff;
 
 	set_capacity(info->disk, toc->capacity * sectors_per_frame);
-	/* Save a private copy of te TOC capacity for error handling */
+	/* save a private copy of the TOC capacity for error handling */
 	drive->probed_capacity = toc->capacity * sectors_per_frame;
 
 	blk_queue_hardsect_size(drive->queue,
 				sectors_per_frame << SECTOR_BITS);
 
-	/* First read just the header, so we know how long the TOC is. */
+	/* first read just the header, so we know how long the TOC is */
 	stat = cdrom_read_tocentry(drive, 0, 1, 0, (char *) &toc->hdr,
 				    sizeof(struct atapi_toc_header), sense);
 	if (stat)
@@ -1416,7 +1417,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	if (ntracks > MAX_TRACKS)
 		ntracks = MAX_TRACKS;
 
-	/* Now read the whole schmeer. */
+	/* now read the whole schmeer */
 	stat = cdrom_read_tocentry(drive, toc->hdr.first_track, 1, 0,
 				  (char *)&toc->hdr,
 				   sizeof(struct atapi_toc_header) +
@@ -1424,15 +1425,18 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 				   sizeof(struct atapi_toc_entry), sense);
 
 	if (stat && toc->hdr.first_track > 1) {
-		/* Cds with CDI tracks only don't have any TOC entries,
-		   despite of this the returned values are
-		   first_track == last_track = number of CDI tracks + 1,
-		   so that this case is indistinguishable from the same
-		   layout plus an additional audio track.
-		   If we get an error for the regular case, we assume
-		   a CDI without additional audio tracks. In this case
-		   the readable TOC is empty (CDI tracks are not included)
-		   and only holds the Leadout entry. Heiko Eißfeldt */
+		/*
+		 * Cds with CDI tracks only don't have any TOC entries, despite
+		 * of this the returned values are
+		 * first_track == last_track = number of CDI tracks + 1,
+		 * so that this case is indistinguishable from the same layout
+		 * plus an additional audio track. If we get an error for the
+		 * regular case, we assume a CDI without additional audio
+		 * tracks. In this case the readable TOC is empty (CDI tracks
+		 * are not included) and only holds the Leadout entry.
+		 *
+		 * Heiko Eißfeldt.
+		 */
 		ntracks = 0;
 		stat = cdrom_read_tocentry(drive, CDROM_LEADOUT, 1, 0,
 					   (char *)&toc->hdr,
@@ -1473,9 +1477,8 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 						  toc->ent[i].addr.msf.frame);
 	}
 
-	/* Read the multisession information. */
 	if (toc->hdr.first_track != CDROM_LEADOUT) {
-		/* Read the multisession information. */
+		/* read the multisession information */
 		stat = cdrom_read_tocentry(drive, 0, 0, 1, (char *)&ms_tmp,
 					   sizeof(ms_tmp), sense);
 		if (stat)
@@ -1483,12 +1486,13 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 
 		toc->last_session_lba = be32_to_cpu(ms_tmp.ent.addr.lba);
 	} else {
-		ms_tmp.hdr.first_track = ms_tmp.hdr.last_track = CDROM_LEADOUT;
+		ms_tmp.hdr.last_track = CDROM_LEADOUT;
+		ms_tmp.hdr.first_track = ms_tmp.hdr.last_track;
 		toc->last_session_lba = msf_to_lba(0, 2, 0); /* 0m 2s 0f */
 	}
 
 	if (info->cd_flags & IDE_CD_FLAG_TOCADDR_AS_BCD) {
-		/* Re-read multisession information using MSF format */
+		/* re-read multisession information using MSF format */
 		stat = cdrom_read_tocentry(drive, 0, 1, 1, (char *)&ms_tmp,
 					   sizeof(ms_tmp), sense);
 		if (stat)
@@ -1502,7 +1506,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 
 	toc->xa_flag = (ms_tmp.hdr.first_track != ms_tmp.hdr.last_track);
 
-	/* Now try to get the total cdrom capacity. */
+	/* now try to get the total cdrom capacity */
 	stat = cdrom_get_last_written(cdi, &last_written);
 	if (!stat && (last_written > toc->capacity)) {
 		toc->capacity = last_written;
@@ -1527,7 +1531,8 @@ int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
 		size -= ATAPI_CAPABILITIES_PAGE_PAD_SIZE;
 
 	init_cdrom_command(&cgc, buf, size, CGC_DATA_UNKNOWN);
-	do { /* we seem to get stat=0x01,err=0x00 the first time (??) */
+	do {
+		/* we seem to get stat=0x01,err=0x00 the first time (??) */
 		stat = cdrom_mode_sense(cdi, &cgc, GPMODE_CAPABILITIES_PAGE, 0);
 		if (!stat)
 			break;
@@ -1596,8 +1601,7 @@ static int ide_cdrom_register(ide_drive_t *drive, int nslots)
 	return register_cdrom(devinfo);
 }
 
-static
-int ide_cdrom_probe_capabilities(ide_drive_t *drive)
+static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
@@ -1611,7 +1615,8 @@ int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 
 	if (drive->media == ide_optical) {
 		cdi->mask &= ~(CDC_MO_DRIVE | CDC_RAM);
-		printk(KERN_ERR "%s: ATAPI magneto-optical drive\n", drive->name);
+		printk(KERN_ERR "%s: ATAPI magneto-optical drive\n",
+				drive->name);
 		return nslots;
 	}
 
@@ -1622,11 +1627,10 @@ int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 	}
 
 	/*
-	 * we have to cheat a little here. the packet will eventually
-	 * be queued with ide_cdrom_packet(), which extracts the
-	 * drive from cdi->handle. Since this device hasn't been
-	 * registered with the Uniform layer yet, it can't do this.
-	 * Same goes for cdi->ops.
+	 * We have to cheat a little here. the packet will eventually be queued
+	 * with ide_cdrom_packet(), which extracts the drive from cdi->handle.
+	 * Since this device hasn't been registered with the Uniform layer yet,
+	 * it can't do this. Same goes for cdi->ops.
 	 */
 	cdi->handle = drive;
 	cdi->ops = &ide_cdrom_dops;
@@ -1695,18 +1699,7 @@ int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 	return nslots;
 }
 
-#ifdef CONFIG_IDE_PROC_FS
-static void ide_cdrom_add_settings(ide_drive_t *drive)
-{
-	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1, &drive->dsc_overlap, NULL);
-}
-#else
-static inline void ide_cdrom_add_settings(ide_drive_t *drive) { ; }
-#endif
-
-/*
- * standard prep_rq_fn that builds 10 byte cmds
- */
+/* standard prep_rq_fn that builds 10 byte cmds */
 static int ide_cdrom_prep_fs(struct request_queue *q, struct request *rq)
 {
 	int hard_sect = queue_hardsect_size(q);
@@ -1745,9 +1738,7 @@ static int ide_cdrom_prep_pc(struct request *rq)
 {
 	u8 *c = rq->cmd;
 
-	/*
-	 * Transform 6-byte read/write commands to the 10-byte version
-	 */
+	/* transform 6-byte read/write commands to the 10-byte version */
 	if (c[0] == READ_6 || c[0] == WRITE_6) {
 		c[8] = c[4];
 		c[5] = c[3];
@@ -1789,6 +1780,41 @@ struct cd_list_entry {
 	unsigned int	cd_flags;
 };
 
+#ifdef CONFIG_IDE_PROC_FS
+static sector_t ide_cdrom_capacity(ide_drive_t *drive)
+{
+	unsigned long capacity, sectors_per_frame;
+
+	if (cdrom_read_capacity(drive, &capacity, &sectors_per_frame, NULL))
+		return 0;
+
+	return capacity * sectors_per_frame;
+}
+
+static int proc_idecd_read_capacity(char *page, char **start, off_t off,
+					int count, int *eof, void *data)
+{
+	ide_drive_t *drive = data;
+	int len;
+
+	len = sprintf(page, "%llu\n", (long long)ide_cdrom_capacity(drive));
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
+}
+
+static ide_proc_entry_t idecd_proc[] = {
+	{ "capacity", S_IFREG|S_IRUGO, proc_idecd_read_capacity, NULL },
+	{ NULL, 0, NULL, NULL }
+};
+
+static void ide_cdrom_add_settings(ide_drive_t *drive)
+{
+	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
+			&drive->dsc_overlap, NULL);
+}
+#else
+static inline void ide_cdrom_add_settings(ide_drive_t *drive) { ; }
+#endif
+
 static const struct cd_list_entry ide_cd_quirks_list[] = {
 	/* Limit transfer size per interrupt. */
 	{ "SAMSUNG CD-ROM SCR-2430", NULL,   IDE_CD_FLAG_LIMIT_NFRAMES	    },
@@ -1846,8 +1872,7 @@ static unsigned int ide_cd_flags(struct hd_driveid *id)
 	return 0;
 }
 
-static
-int ide_cdrom_setup(ide_drive_t *drive)
+static int ide_cdrom_setup(ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
@@ -1876,13 +1901,12 @@ int ide_cdrom_setup(ide_drive_t *drive)
 		 id->fw_rev[4] == '1' && id->fw_rev[6] <= '2')
 		cd->cd_flags |= IDE_CD_FLAG_TOCTRACKS_AS_BCD;
 	else if (cd->cd_flags & IDE_CD_FLAG_SANYO_3CD)
-		cdi->sanyo_slot = 3;	/* 3 => use CD in slot 0 */
+		/* 3 => use CD in slot 0 */
+		cdi->sanyo_slot = 3;
 
 	nslots = ide_cdrom_probe_capabilities(drive);
 
-	/*
-	 * set correct block size
-	 */
+	/* set correct block size */
 	blk_queue_hardsect_size(drive->queue, CD_FRAMESIZE);
 
 	if (drive->autotune == IDE_TUNE_DEFAULT ||
@@ -1890,7 +1914,8 @@ int ide_cdrom_setup(ide_drive_t *drive)
 		drive->dsc_overlap = (drive->next != drive);
 
 	if (ide_cdrom_register(drive, nslots)) {
-		printk(KERN_ERR "%s: ide_cdrom_setup failed to register device with the cdrom driver.\n", drive->name);
+		printk(KERN_ERR "%s: %s failed to register device with the"
+				" cdrom driver.\n", drive->name, __func__);
 		cd->devinfo.handle = NULL;
 		return 1;
 	}
@@ -1929,33 +1954,6 @@ static void ide_cd_release(struct kref *kref)
 
 static int ide_cd_probe(ide_drive_t *);
 
-#ifdef CONFIG_IDE_PROC_FS
-static sector_t ide_cdrom_capacity(ide_drive_t *drive)
-{
-	unsigned long capacity, sectors_per_frame;
-
-	if (cdrom_read_capacity(drive, &capacity, &sectors_per_frame, NULL))
-		return 0;
-
-	return capacity * sectors_per_frame;
-}
-
-static int proc_idecd_read_capacity
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
-{
-	ide_drive_t *drive = data;
-	int len;
-
-	len = sprintf(page, "%llu\n", (long long)ide_cdrom_capacity(drive));
-	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
-}
-
-static ide_proc_entry_t idecd_proc[] = {
-	{ "capacity", S_IFREG|S_IRUGO, proc_idecd_read_capacity, NULL },
-	{ NULL, 0, NULL, NULL }
-};
-#endif
-
 static ide_driver_t ide_cdrom_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
@@ -2093,7 +2091,7 @@ static struct block_device_operations idecd_ops = {
 	.revalidate_disk	= idecd_revalidate_disk
 };
 
-/* options */
+/* module options */
 static char *ignore;
 
 module_param(ignore, charp, 0400);
@@ -2114,17 +2112,20 @@ static int ide_cd_probe(ide_drive_t *drive)
 	/* skip drives that we were told to ignore */
 	if (ignore != NULL) {
 		if (strstr(ignore, drive->name)) {
-			printk(KERN_INFO "ide-cd: ignoring drive %s\n", drive->name);
+			printk(KERN_INFO "ide-cd: ignoring drive %s\n",
+					 drive->name);
 			goto failed;
 		}
 	}
 	if (drive->scsi) {
-		printk(KERN_INFO "ide-cd: passing drive %s to ide-scsi emulation.\n", drive->name);
+		printk(KERN_INFO "ide-cd: passing drive %s to ide-scsi "
+				 "emulation.\n", drive->name);
 		goto failed;
 	}
 	info = kzalloc(sizeof(struct cdrom_info), GFP_KERNEL);
 	if (info == NULL) {
-		printk(KERN_ERR "%s: Can't allocate a cdrom structure\n", drive->name);
+		printk(KERN_ERR "%s: Can't allocate a cdrom structure\n",
+				drive->name);
 		goto failed;
 	}
 
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 8757e5e..c352cf2 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -102,7 +102,7 @@ ide_startstop_t ide_dma_intr (ide_drive_t *drive)
 {
 	u8 stat = 0, dma_stat = 0;
 
-	dma_stat = HWIF(drive)->ide_dma_end(drive);
+	dma_stat = drive->hwif->dma_ops->dma_end(drive);
 	stat = ide_read_status(drive);
 
 	if (OK_STAT(stat,DRIVE_READY,drive->bad_wstat|DRQ_STAT)) {
@@ -394,7 +394,7 @@ void ide_dma_off_quietly(ide_drive_t *drive)
 	drive->using_dma = 0;
 	ide_toggle_bounce(drive, 0);
 
-	drive->hwif->dma_host_set(drive, 0);
+	drive->hwif->dma_ops->dma_host_set(drive, 0);
 }
 
 EXPORT_SYMBOL(ide_dma_off_quietly);
@@ -427,7 +427,7 @@ void ide_dma_on(ide_drive_t *drive)
 	drive->using_dma = 1;
 	ide_toggle_bounce(drive, 1);
 
-	drive->hwif->dma_host_set(drive, 1);
+	drive->hwif->dma_ops->dma_host_set(drive, 1);
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
@@ -482,11 +482,12 @@ int ide_dma_setup(ide_drive_t *drive)
 
 EXPORT_SYMBOL_GPL(ide_dma_setup);
 
-static void ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
+void ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
 {
 	/* issue cmd to drive */
 	ide_execute_command(drive, command, &ide_dma_intr, 2*WAIT_CMD, dma_timer_expiry);
 }
+EXPORT_SYMBOL_GPL(ide_dma_exec_cmd);
 
 void ide_dma_start(ide_drive_t *drive)
 {
@@ -532,7 +533,7 @@ int __ide_dma_end (ide_drive_t *drive)
 EXPORT_SYMBOL(__ide_dma_end);
 
 /* returns 1 if dma irq issued, 0 otherwise */
-static int __ide_dma_test_irq(ide_drive_t *drive)
+int ide_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	u8 dma_stat		= hwif->INB(hwif->dma_status);
@@ -542,9 +543,10 @@ static int __ide_dma_test_irq(ide_drive_t *drive)
 		return 1;
 	if (!drive->waiting_for_dma)
 		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
-			drive->name, __FUNCTION__);
+			drive->name, __func__);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ide_dma_test_irq);
 #else
 static inline int config_drive_for_dma(ide_drive_t *drive) { return 0; }
 #endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
@@ -574,6 +576,7 @@ static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base, u8 req_mode)
 {
 	struct hd_driveid *id = drive->id;
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
 	unsigned int mask = 0;
 
 	switch(base) {
@@ -581,8 +584,8 @@ static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base, u8 req_mode)
 		if ((id->field_valid & 4) == 0)
 			break;
 
-		if (hwif->udma_filter)
-			mask = hwif->udma_filter(drive);
+		if (port_ops && port_ops->udma_filter)
+			mask = port_ops->udma_filter(drive);
 		else
 			mask = hwif->ultra_mask;
 		mask &= id->dma_ultra;
@@ -598,8 +601,8 @@ static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base, u8 req_mode)
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
@@ -801,15 +804,15 @@ void ide_dma_timeout (ide_drive_t *drive)
 
 	printk(KERN_ERR "%s: timeout waiting for DMA\n", drive->name);
 
-	if (hwif->ide_dma_test_irq(drive))
+	if (hwif->dma_ops->dma_test_irq(drive))
 		return;
 
-	hwif->ide_dma_end(drive);
+	hwif->dma_ops->dma_end(drive);
 }
 
 EXPORT_SYMBOL(ide_dma_timeout);
 
-static void ide_release_dma_engine(ide_hwif_t *hwif)
+void ide_release_dma_engine(ide_hwif_t *hwif)
 {
 	if (hwif->dmatable_cpu) {
 		struct pci_dev *pdev = to_pci_dev(hwif->dev);
@@ -820,28 +823,7 @@ static void ide_release_dma_engine(ide_hwif_t *hwif)
 	}
 }
 
-static int ide_release_iomio_dma(ide_hwif_t *hwif)
-{
-	release_region(hwif->dma_base, 8);
-	if (hwif->extra_ports)
-		release_region(hwif->extra_base, hwif->extra_ports);
-	return 1;
-}
-
-/*
- * Needed for allowing full modular support of ide-driver
- */
-int ide_release_dma(ide_hwif_t *hwif)
-{
-	ide_release_dma_engine(hwif);
-
-	if (hwif->mmio)
-		return 1;
-	else
-		return ide_release_iomio_dma(hwif);
-}
-
-static int ide_allocate_dma_engine(ide_hwif_t *hwif)
+int ide_allocate_dma_engine(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 
@@ -853,65 +835,25 @@ static int ide_allocate_dma_engine(ide_hwif_t *hwif)
 		return 0;
 
 	printk(KERN_ERR "%s: -- Error, unable to allocate DMA table.\n",
-	       hwif->cds->name);
+			hwif->name);
 
 	return 1;
 }
-
-static int ide_mapped_mmio_dma(ide_hwif_t *hwif, unsigned long base)
-{
-	printk(KERN_INFO "    %s: MMIO-DMA ", hwif->name);
-
-	return 0;
-}
-
-static int ide_iomio_dma(ide_hwif_t *hwif, unsigned long base)
-{
-	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx",
-	       hwif->name, base, base + 7);
-
-	if (!request_region(base, 8, hwif->name)) {
-		printk(" -- Error, ports in use.\n");
-		return 1;
-	}
-
-	if (hwif->cds->extra) {
-		hwif->extra_base = base + (hwif->channel ? 8 : 16);
-
-		if (!hwif->mate || !hwif->mate->extra_ports) {
-			if (!request_region(hwif->extra_base,
-					    hwif->cds->extra, hwif->cds->name)) {
-				printk(" -- Error, extra ports in use.\n");
-				release_region(base, 8);
-				return 1;
-			}
-			hwif->extra_ports = hwif->cds->extra;
-		}
-	}
-
-	return 0;
-}
-
-static int ide_dma_iobase(ide_hwif_t *hwif, unsigned long base)
-{
-	if (hwif->mmio)
-		return ide_mapped_mmio_dma(hwif, base);
-
-	return ide_iomio_dma(hwif, base);
-}
+EXPORT_SYMBOL_GPL(ide_allocate_dma_engine);
+
+static const struct ide_dma_ops sff_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= __ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_timeout		= ide_dma_timeout,
+	.dma_lost_irq		= ide_dma_lost_irq,
+};
 
 void ide_setup_dma(ide_hwif_t *hwif, unsigned long base)
 {
-	u8 dma_stat;
-
-	if (ide_dma_iobase(hwif, base))
-		return;
-
-	if (ide_allocate_dma_engine(hwif)) {
-		ide_release_dma(hwif);
-		return;
-	}
-
 	hwif->dma_base = base;
 
 	if (!hwif->dma_command)
@@ -925,27 +867,7 @@ void ide_setup_dma(ide_hwif_t *hwif, unsigned long base)
 	if (!hwif->dma_prdtable)
 		hwif->dma_prdtable	= hwif->dma_base + 4;
 
-	if (!hwif->dma_host_set)
-		hwif->dma_host_set = &ide_dma_host_set;
-	if (!hwif->dma_setup)
-		hwif->dma_setup = &ide_dma_setup;
-	if (!hwif->dma_exec_cmd)
-		hwif->dma_exec_cmd = &ide_dma_exec_cmd;
-	if (!hwif->dma_start)
-		hwif->dma_start = &ide_dma_start;
-	if (!hwif->ide_dma_end)
-		hwif->ide_dma_end = &__ide_dma_end;
-	if (!hwif->ide_dma_test_irq)
-		hwif->ide_dma_test_irq = &__ide_dma_test_irq;
-	if (!hwif->dma_timeout)
-		hwif->dma_timeout = &ide_dma_timeout;
-	if (!hwif->dma_lost_irq)
-		hwif->dma_lost_irq = &ide_dma_lost_irq;
-
-	dma_stat = hwif->INB(hwif->dma_status);
-	printk(KERN_CONT ", BIOS settings: %s:%s, %s:%s\n",
-	       hwif->drives[0].name, (dma_stat & 0x20) ? "DMA" : "PIO",
-	       hwif->drives[1].name, (dma_stat & 0x40) ? "DMA" : "PIO");
+	hwif->dma_ops = &sff_dma_ops;
 }
 
 EXPORT_SYMBOL_GPL(ide_setup_dma);
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index ed19a8b..6e891bc 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -411,7 +411,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 	debug_log("Reached %s interrupt handler\n", __func__);
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		dma_error = hwif->ide_dma_end(drive);
+		dma_error = hwif->dma_ops->dma_end(drive);
 		if (dma_error) {
 			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
 					rq_data_dir(rq) ? "write" : "read");
@@ -663,7 +663,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 	dma = 0;
 
 	if ((pc->flags & PC_FLAG_DMA_RECOMMENDED) && drive->using_dma)
-		dma = !hwif->dma_setup(drive);
+		dma = !hwif->dma_ops->dma_setup(drive);
 
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
 			   IDE_TFLAG_OUT_DEVICE, bcount, dma);
@@ -671,7 +671,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 	if (dma) {
 		/* Begin DMA, if necessary */
 		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
-		hwif->dma_start(drive);
+		hwif->dma_ops->dma_start(drive);
 	}
 
 	/* Can we transfer the packet when we get the interrupt or wait? */
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 19f63e3..a6073e2 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -94,7 +94,24 @@ static int __init ide_generic_init(void)
 		unsigned long io_addr = ide_default_io_base(i);
 		hw_regs_t hw;
 
+		idx[i] = 0xff;
+
 		if (io_addr) {
+			if (!request_region(io_addr, 8, DRV_NAME)) {
+				printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX "
+						"not free.\n",
+						DRV_NAME, io_addr, io_addr + 7);
+				continue;
+			}
+
+			if (!request_region(io_addr + 0x206, 1, DRV_NAME)) {
+				printk(KERN_ERR "%s: I/O resource 0x%lX "
+						"not free.\n",
+						DRV_NAME, io_addr + 0x206);
+				release_region(io_addr, 8);
+				continue;
+			}
+
 			/*
 			 * Skip probing if the corresponding
 			 * slot is already occupied.
@@ -111,8 +128,7 @@ static int __init ide_generic_init(void)
 			ide_init_port_hw(hwif, &hw);
 
 			idx[i] = i;
-		} else
-			idx[i] = 0xff;
+		}
 	}
 
 	ide_device_add_all(idx, NULL);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 51d181e..0fe89a5 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -218,7 +218,7 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 		 * we could be smarter and check for current xfer_speed
 		 * in struct drive etc...
 		 */
-		if (drive->hwif->dma_host_set == NULL)
+		if (drive->hwif->dma_ops == NULL)
 			break;
 		/*
 		 * TODO: respect ->using_dma setting
@@ -721,6 +721,7 @@ static ide_startstop_t do_special (ide_drive_t *drive)
 #endif
 	if (s->b.set_tune) {
 		ide_hwif_t *hwif = drive->hwif;
+		const struct ide_port_ops *port_ops = hwif->port_ops;
 		u8 req_pio = drive->tune_req;
 
 		s->b.set_tune = 0;
@@ -733,10 +734,10 @@ static ide_startstop_t do_special (ide_drive_t *drive)
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
 
@@ -1237,12 +1238,12 @@ static ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 
 	if (error < 0) {
 		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
-		(void)HWIF(drive)->ide_dma_end(drive);
+		(void)hwif->dma_ops->dma_end(drive);
 		ret = ide_error(drive, "dma timeout error",
 				ide_read_status(drive));
 	} else {
 		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
-		hwif->dma_timeout(drive);
+		hwif->dma_ops->dma_timeout(drive);
 	}
 
 	/*
@@ -1354,7 +1355,7 @@ void ide_timer_expiry (unsigned long data)
 				startstop = handler(drive);
 			} else if (drive_is_ready(drive)) {
 				if (drive->waiting_for_dma)
-					hwgroup->hwif->dma_lost_irq(drive);
+					hwif->dma_ops->dma_lost_irq(drive);
 				(void)ide_ack_intr(hwif);
 				printk(KERN_WARNING "%s: lost interrupt\n", drive->name);
 				startstop = handler(drive);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 4594421..9c646bd 100644
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
@@ -429,7 +432,7 @@ int drive_is_ready (ide_drive_t *drive)
 	u8 stat			= 0;
 
 	if (drive->waiting_for_dma)
-		return hwif->ide_dma_test_irq(drive);
+		return hwif->dma_ops->dma_test_irq(drive);
 
 #if 0
 	/* need to guarantee 400ns since last command was issued */
@@ -700,8 +703,8 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 //		msleep(50);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
-	if (hwif->dma_host_set)	/* check if host supports DMA */
-		hwif->dma_host_set(drive, 0);
+	if (hwif->dma_ops)	/* check if host supports DMA */
+		hwif->dma_ops->dma_host_set(drive, 0);
 #endif
 
 	/* Skip setting PIO flow-control modes on pre-EIDE drives */
@@ -759,8 +762,8 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	if ((speed >= XFER_SW_DMA_0 || (hwif->host_flags & IDE_HFLAG_VDMA)) &&
 	    drive->using_dma)
-		hwif->dma_host_set(drive, 1);
-	else if (hwif->dma_host_set)	/* check if host supports DMA */
+		hwif->dma_ops->dma_host_set(drive, 1);
+	else if (hwif->dma_ops)	/* check if host supports DMA */
 		ide_dma_off_quietly(drive);
 #endif
 
@@ -905,10 +908,11 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
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
@@ -974,6 +978,8 @@ static void ide_disk_pre_reset(ide_drive_t *drive)
 
 static void pre_reset(ide_drive_t *drive)
 {
+	const struct ide_port_ops *port_ops = drive->hwif->port_ops;
+
 	if (drive->media == ide_disk)
 		ide_disk_pre_reset(drive);
 	else
@@ -994,8 +1000,8 @@ static void pre_reset(ide_drive_t *drive)
 		return;
 	}
 
-	if (HWIF(drive)->pre_reset != NULL)
-		HWIF(drive)->pre_reset(drive);
+	if (port_ops && port_ops->pre_reset)
+		port_ops->pre_reset(drive);
 
 	if (drive->current_speed != 0xff)
 		drive->desired_speed = drive->current_speed;
@@ -1023,6 +1029,7 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	unsigned long flags;
 	ide_hwif_t *hwif;
 	ide_hwgroup_t *hwgroup;
+	const struct ide_port_ops *port_ops;
 	u8 ctl;
 
 	spin_lock_irqsave(&ide_lock, flags);
@@ -1089,8 +1096,9 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
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
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index c859de7..6f04ea3 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -85,7 +85,7 @@ static u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
 			mode = XFER_PIO_4;
 	}
 
-//	printk("%s: mode 0x%02x, speed 0x%02x\n", __FUNCTION__, mode, speed);
+/*	printk("%s: mode 0x%02x, speed 0x%02x\n", __func__, mode, speed); */
 
 	return min(speed, mode);
 }
@@ -288,9 +288,10 @@ EXPORT_SYMBOL_GPL(ide_get_best_pio_mode);
 void ide_set_pio(ide_drive_t *drive, u8 req_pio)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
 	u8 host_pio, pio;
 
-	if (hwif->set_pio_mode == NULL ||
+	if (port_ops == NULL || port_ops->set_pio_mode == NULL ||
 	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
 		return;
 
@@ -343,29 +344,30 @@ void ide_toggle_bounce(ide_drive_t *drive, int on)
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
@@ -373,20 +375,21 @@ int ide_set_pio_mode(ide_drive_t *drive, const u8 mode)
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
@@ -406,8 +409,9 @@ EXPORT_SYMBOL_GPL(ide_set_dma_mode);
 int ide_set_xfer_rate(ide_drive_t *drive, u8 rate)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
 
-	if (hwif->set_dma_mode == NULL ||
+	if (port_ops == NULL || port_ops->set_dma_mode == NULL ||
 	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
 		return -1;
 
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index 8a178a5..10c20e9 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -18,6 +18,8 @@
 #include <linux/pnp.h>
 #include <linux/ide.h>
 
+#define DRV_NAME "ide-pnp"
+
 /* Add your devices here :)) */
 static struct pnp_device_id idepnp_devices[] = {
 	/* Generic ESDI/IDE/ATA compatible hard disk controller */
@@ -29,13 +31,29 @@ static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
 	hw_regs_t hw;
 	ide_hwif_t *hwif;
+	unsigned long base, ctl;
 
 	if (!(pnp_port_valid(dev, 0) && pnp_port_valid(dev, 1) && pnp_irq_valid(dev, 0)))
 		return -1;
 
+	base = pnp_port_start(dev, 0);
+	ctl = pnp_port_start(dev, 1);
+
+	if (!request_region(base, 8, DRV_NAME)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
+				DRV_NAME, base, base + 7);
+		return -EBUSY;
+	}
+
+	if (!request_region(ctl, 1, DRV_NAME)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
+				DRV_NAME, ctl);
+		release_region(base, 8);
+		return -EBUSY;
+	}
+
 	memset(&hw, 0, sizeof(hw));
-	ide_std_init_ports(&hw, pnp_port_start(dev, 0),
-				pnp_port_start(dev, 1));
+	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = pnp_irq(dev, 0);
 
 	hwif = ide_find_port();
@@ -54,6 +72,9 @@ static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 		return 0;
 	}
 
+	release_region(ctl, 1);
+	release_region(base, 8);
+
 	return -1;
 }
 
@@ -65,6 +86,9 @@ static void idepnp_remove(struct pnp_dev *dev)
 		ide_unregister(hwif->index);
 	else
 		printk(KERN_ERR "idepnp: Unable to remove device, please report.\n");
+
+	release_region(pnp_port_start(dev, 1), 1);
+	release_region(pnp_port_start(dev, 0), 8);
 }
 
 static struct pnp_driver idepnp_driver = {
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 8754297..a4b65b3 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -644,7 +644,7 @@ static int ide_register_port(ide_hwif_t *hwif)
 	ret = device_register(&hwif->gendev);
 	if (ret < 0) {
 		printk(KERN_WARNING "IDE: %s: device_register error: %d\n",
-			__FUNCTION__, ret);
+			__func__, ret);
 		goto out;
 	}
 
@@ -773,8 +773,7 @@ static int ide_probe_port(ide_hwif_t *hwif)
 
 	BUG_ON(hwif->present);
 
-	if (hwif->noprobe ||
-	    (hwif->drives[0].noprobe && hwif->drives[1].noprobe))
+	if (hwif->drives[0].noprobe && hwif->drives[1].noprobe)
 		return -EACCES;
 
 	/*
@@ -821,13 +820,14 @@ static int ide_probe_port(ide_hwif_t *hwif)
 
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
@@ -843,7 +843,7 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
 
 			drive->nice1 = 1;
 
-			if (hwif->dma_host_set)
+			if (hwif->dma_ops)
 				ide_set_dma(drive);
 		}
 	}
@@ -1324,6 +1324,7 @@ static void hwif_register_devices(ide_hwif_t *hwif)
 
 static void ide_port_init_devices(ide_hwif_t *hwif)
 {
+	const struct ide_port_ops *port_ops = hwif->port_ops;
 	int i;
 
 	for (i = 0; i < MAX_DRIVES; i++) {
@@ -1339,8 +1340,8 @@ static void ide_port_init_devices(ide_hwif_t *hwif)
 			drive->autotune = 1;
 	}
 
-	if (hwif->port_init_devs)
-		hwif->port_init_devs(hwif);
+	if (port_ops && port_ops->port_init_devs)
+		port_ops->port_init_devs(hwif);
 }
 
 static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
@@ -1355,9 +1356,6 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 	if (d->init_iops)
 		d->init_iops(hwif);
 
-	if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0)
-		ide_hwif_setup_dma(hwif, d);
-
 	if ((!hwif->irq && (d->host_flags & IDE_HFLAG_LEGACY_IRQS)) ||
 	    (d->host_flags & IDE_HFLAG_FORCE_LEGACY_IRQS))
 		hwif->irq = port ? 15 : 14;
@@ -1365,16 +1363,36 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 	hwif->host_flags = d->host_flags;
 	hwif->pio_mask = d->pio_mask;
 
-	if ((d->host_flags & IDE_HFLAG_SERIALIZE) && hwif->mate)
-		hwif->mate->serialized = hwif->serialized = 1;
+	/* ->set_pio_mode for DTC2278 is currently limited to port 0 */
+	if (hwif->chipset != ide_dtc2278 || hwif->channel == 0)
+		hwif->port_ops = d->port_ops;
+
+	if ((d->host_flags & IDE_HFLAG_SERIALIZE) ||
+	    ((d->host_flags & IDE_HFLAG_SERIALIZE_DMA) && hwif->dma_base)) {
+		if (hwif->mate)
+			hwif->mate->serialized = hwif->serialized = 1;
+	}
 
 	hwif->swdma_mask = d->swdma_mask;
 	hwif->mwdma_mask = d->mwdma_mask;
 	hwif->ultra_mask = d->udma_mask;
 
-	/* reset DMA masks only for SFF-style DMA controllers */
-	if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0 && hwif->dma_base == 0)
-		hwif->swdma_mask = hwif->mwdma_mask = hwif->ultra_mask = 0;
+	if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0) {
+		int rc;
+
+		if (d->init_dma)
+			rc = d->init_dma(hwif, d);
+		else
+			rc = ide_hwif_setup_dma(hwif, d);
+
+		if (rc < 0) {
+			printk(KERN_INFO "%s: DMA disabled\n", hwif->name);
+			hwif->swdma_mask = 0;
+			hwif->mwdma_mask = 0;
+			hwif->ultra_mask = 0;
+		} else if (d->dma_ops)
+			hwif->dma_ops = d->dma_ops;
+	}
 
 	if (d->host_flags & IDE_HFLAG_RQSIZE_256)
 		hwif->rqsize = 256;
@@ -1386,9 +1404,11 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 
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
 
@@ -1523,25 +1543,15 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 
 		hwif = &ide_hwifs[idx[i]];
 
-		if ((hwif->chipset != ide_4drives || !hwif->mate ||
-		     !hwif->mate->present) && ide_hwif_request_regions(hwif)) {
-			printk(KERN_ERR "%s: ports already in use, "
-					"skipping probe\n", hwif->name);
-			continue;
-		}
-
-		if (ide_probe_port(hwif) < 0) {
-			ide_hwif_release_regions(hwif);
-			continue;
-		}
-
-		hwif->present = 1;
+		if (ide_probe_port(hwif) == 0)
+			hwif->present = 1;
 
 		if (hwif->chipset != ide_4drives || !hwif->mate ||
 		    !hwif->mate->present)
 			ide_register_port(hwif);
 
-		ide_port_tune_devices(hwif);
+		if (hwif->present)
+			ide_port_tune_devices(hwif);
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
@@ -1550,9 +1560,6 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 
 		hwif = &ide_hwifs[idx[i]];
 
-		if (!hwif->present)
-			continue;
-
 		if (hwif_init(hwif) == 0) {
 			printk(KERN_INFO "%s: failed to initialize IDE "
 					 "interface\n", hwif->name);
@@ -1561,10 +1568,13 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 			continue;
 		}
 
-		ide_port_setup_devices(hwif);
+		if (hwif->present)
+			ide_port_setup_devices(hwif);
 
 		ide_acpi_init(hwif);
-		ide_acpi_port_init_devices(hwif);
+
+		if (hwif->present)
+			ide_acpi_port_init_devices(hwif);
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
@@ -1573,11 +1583,11 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 
 		hwif = &ide_hwifs[idx[i]];
 
-		if (hwif->present) {
-			if (hwif->chipset == ide_unknown)
-				hwif->chipset = ide_generic;
+		if (hwif->chipset == ide_unknown)
+			hwif->chipset = ide_generic;
+
+		if (hwif->present)
 			hwif_register_devices(hwif);
-		}
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
@@ -1586,11 +1596,11 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 
 		hwif = &ide_hwifs[idx[i]];
 
-		if (hwif->present) {
-			ide_sysfs_register_port(hwif);
-			ide_proc_register_port(hwif);
+		ide_sysfs_register_port(hwif);
+		ide_proc_register_port(hwif);
+
+		if (hwif->present)
 			ide_proc_port_register_devices(hwif);
-		}
 	}
 
 	return rc;
@@ -1626,3 +1636,67 @@ void ide_port_scan(ide_hwif_t *hwif)
 	ide_proc_port_register_devices(hwif);
 }
 EXPORT_SYMBOL_GPL(ide_port_scan);
+
+static void ide_legacy_init_one(u8 *idx, hw_regs_t *hw, u8 port_no,
+				const struct ide_port_info *d,
+				unsigned long config)
+{
+	ide_hwif_t *hwif;
+	unsigned long base, ctl;
+	int irq;
+
+	if (port_no == 0) {
+		base = 0x1f0;
+		ctl  = 0x3f6;
+		irq  = 14;
+	} else {
+		base = 0x170;
+		ctl  = 0x376;
+		irq  = 15;
+	}
+
+	if (!request_region(base, 8, d->name)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
+				d->name, base, base + 7);
+		return;
+	}
+
+	if (!request_region(ctl, 1, d->name)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
+				d->name, ctl);
+		release_region(base, 8);
+		return;
+	}
+
+	ide_std_init_ports(hw, base, ctl);
+	hw->irq = irq;
+
+	hwif = ide_find_port_slot(d);
+	if (hwif) {
+		ide_init_port_hw(hwif, hw);
+		if (config)
+			hwif->config_data = config;
+		idx[port_no] = hwif->index;
+	}
+}
+
+int ide_legacy_device_add(const struct ide_port_info *d, unsigned long config)
+{
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw[2];
+
+	memset(&hw, 0, sizeof(hw));
+
+	if ((d->host_flags & IDE_HFLAG_QD_2ND_PORT) == 0)
+		ide_legacy_init_one(idx, &hw[0], 0, d, config);
+	ide_legacy_init_one(idx, &hw[1], 1, d, config);
+
+	if (idx[0] == 0xff && idx[1] == 0xff &&
+	    (d->host_flags & IDE_HFLAG_SINGLE))
+		return -ENOENT;
+
+	ide_device_add(idx, d);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_legacy_device_add);
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 5d3562b..d9d98ac 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -599,14 +599,14 @@ static int ide_replace_subdriver(ide_drive_t *drive, const char *driver)
 	err = device_attach(dev);
 	if (err < 0)
 		printk(KERN_WARNING "IDE: %s: device_attach error: %d\n",
-			__FUNCTION__, err);
+			__func__, err);
 	drive->driver_req[0] = 0;
 	if (dev->driver == NULL) {
 		err = device_attach(dev);
 		if (err < 0)
 			printk(KERN_WARNING
 				"IDE: %s: device_attach(2) error: %d\n",
-				__FUNCTION__, err);
+				__func__, err);
 	}
 	if (dev->driver && !strcmp(dev->driver->name, driver))
 		ret = 0;
@@ -820,7 +820,7 @@ static int ide_drivers_show(struct seq_file *s, void *p)
 	err = bus_for_each_drv(&ide_bus_type, NULL, s, proc_print_driver);
 	if (err < 0)
 		printk(KERN_WARNING "IDE: %s: bus_for_each_drv error: %d\n",
-			__FUNCTION__, err);
+			__func__, err);
 	return 0;
 }
 
diff --git a/drivers/ide/ide-scan-pci.c b/drivers/ide/ide-scan-pci.c
index 98888da..0e79eff 100644
--- a/drivers/ide/ide-scan-pci.c
+++ b/drivers/ide/ide-scan-pci.c
@@ -102,7 +102,7 @@ static int __init ide_scan_pcibus(void)
 		if (__pci_register_driver(d, d->driver.owner,
 					  d->driver.mod_name))
 			printk(KERN_ERR "%s: failed to register %s driver\n",
-					__FUNCTION__, d->driver.mod_name);
+					__func__, d->driver.mod_name);
 	}
 
 	return 0;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index f43fd07..d3d8b8d 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -993,7 +993,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 	stat = ide_read_status(drive);
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		if (hwif->ide_dma_end(drive) || (stat & ERR_STAT)) {
+		if (hwif->dma_ops->dma_end(drive) || (stat & ERR_STAT)) {
 			/*
 			 * A DMA error is sometimes expected. For example,
 			 * if the tape is crossing a filemark during a
@@ -1213,7 +1213,7 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	/* Begin DMA, if necessary */
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS)
-		hwif->dma_start(drive);
+		hwif->dma_ops->dma_start(drive);
 #endif
 	/* Send the actual packet */
 	HWIF(drive)->atapi_output_bytes(drive, pc->c, 12);
@@ -1279,7 +1279,7 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 		ide_dma_off(drive);
 	}
 	if ((pc->flags & PC_FLAG_DMA_RECOMMENDED) && drive->using_dma)
-		dma_ok = !hwif->dma_setup(drive);
+		dma_ok = !hwif->dma_ops->dma_setup(drive);
 
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
 			   IDE_TFLAG_OUT_DEVICE, bcount, dma_ok);
@@ -1605,14 +1605,6 @@ out:
 }
 
 /* Pipeline related functions */
-static inline int idetape_pipeline_active(idetape_tape_t *tape)
-{
-	int rc1, rc2;
-
-	rc1 = test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags);
-	rc2 = (tape->active_data_rq != NULL);
-	return rc1;
-}
 
 /*
  * The function below uses __get_free_page to allocate a pipeline stage, along
@@ -2058,7 +2050,7 @@ static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 
 	spin_lock_irqsave(&tape->lock, flags);
 	tape->next_stage = NULL;
-	if (idetape_pipeline_active(tape))
+	if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags))
 		idetape_wait_for_request(drive, tape->active_data_rq);
 	spin_unlock_irqrestore(&tape->lock, flags);
 
@@ -2131,7 +2123,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 
 	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
 
-	if (idetape_pipeline_active(tape)) {
+	if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
 		printk(KERN_ERR "ide-tape: bug: the pipeline is active in %s\n",
 				__func__);
 		return (0);
@@ -2162,8 +2154,7 @@ static void idetape_plug_pipeline(ide_drive_t *drive)
 
 	if (tape->next_stage == NULL)
 		return;
-	if (!idetape_pipeline_active(tape)) {
-		set_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags);
+	if (!test_and_set_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
 		idetape_activate_next_stage(drive);
 		(void) ide_do_drive_cmd(drive, tape->active_data_rq, ide_end);
 	}
@@ -2242,13 +2233,14 @@ static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 	/* Attempt to allocate a new stage. Beware possible race conditions. */
 	while ((new_stage = idetape_kmalloc_stage(tape)) == NULL) {
 		spin_lock_irqsave(&tape->lock, flags);
-		if (idetape_pipeline_active(tape)) {
+		if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
 			idetape_wait_for_request(drive, tape->active_data_rq);
 			spin_unlock_irqrestore(&tape->lock, flags);
 		} else {
 			spin_unlock_irqrestore(&tape->lock, flags);
 			idetape_plug_pipeline(drive);
-			if (idetape_pipeline_active(tape))
+			if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE,
+					&tape->flags))
 				continue;
 			/*
 			 * The machine is short on memory. Fallback to non-
@@ -2277,7 +2269,7 @@ static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 	 * starting to service requests, so that we will be able to keep up with
 	 * the higher speeds of the tape.
 	 */
-	if (!idetape_pipeline_active(tape)) {
+	if (!test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
 		if (tape->nr_stages >= tape->max_stages * 9 / 10 ||
 			tape->nr_stages >= tape->max_stages -
 			tape->uncontrolled_pipeline_head_speed * 3 * 1024 /
@@ -2304,10 +2296,11 @@ static void idetape_wait_for_pipeline(ide_drive_t *drive)
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
 
-	while (tape->next_stage || idetape_pipeline_active(tape)) {
+	while (tape->next_stage || test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE,
+						&tape->flags)) {
 		idetape_plug_pipeline(drive);
 		spin_lock_irqsave(&tape->lock, flags);
-		if (idetape_pipeline_active(tape))
+		if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags))
 			idetape_wait_for_request(drive, tape->active_data_rq);
 		spin_unlock_irqrestore(&tape->lock, flags);
 	}
@@ -2464,7 +2457,7 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 			new_stage = idetape_kmalloc_stage(tape);
 		}
 	}
-	if (!idetape_pipeline_active(tape)) {
+	if (!test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
 		if (tape->nr_pending_stages >= 3 * max_stages / 4) {
 			tape->measure_insert_time = 1;
 			tape->insert_time = jiffies;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 155cc90..a317ca9 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -135,6 +135,7 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct ide_taskfile *tf = &task->tf;
 	ide_handler_t *handler = NULL;
+	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
 
 	if (task->data_phase == TASKFILE_MULTI_IN ||
 	    task->data_phase == TASKFILE_MULTI_OUT) {
@@ -178,10 +179,10 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 		return ide_started;
 	default:
 		if (task_dma_ok(task) == 0 || drive->using_dma == 0 ||
-		    hwif->dma_setup(drive))
+		    dma_ops->dma_setup(drive))
 			return ide_stopped;
-		hwif->dma_exec_cmd(drive, tf->command);
-		hwif->dma_start(drive);
+		dma_ops->dma_exec_cmd(drive, tf->command);
+		dma_ops->dma_start(drive);
 		return ide_started;
 	}
 }
@@ -455,7 +456,7 @@ static ide_startstop_t task_in_intr(ide_drive_t *drive)
 
 	/* Error? */
 	if (stat & ERR_STAT)
-		return task_error(drive, rq, __FUNCTION__, stat);
+		return task_error(drive, rq, __func__, stat);
 
 	/* Didn't want any data? Odd. */
 	if (!(stat & DRQ_STAT))
@@ -467,7 +468,7 @@ static ide_startstop_t task_in_intr(ide_drive_t *drive)
 	if (!hwif->nleft) {
 		stat = wait_drive_not_busy(drive);
 		if (!OK_STAT(stat, 0, BAD_STAT))
-			return task_error(drive, rq, __FUNCTION__, stat);
+			return task_error(drive, rq, __func__, stat);
 		task_end_request(drive, rq, stat);
 		return ide_stopped;
 	}
@@ -488,11 +489,11 @@ static ide_startstop_t task_out_intr (ide_drive_t *drive)
 	u8 stat = ide_read_status(drive);
 
 	if (!OK_STAT(stat, DRIVE_READY, drive->bad_wstat))
-		return task_error(drive, rq, __FUNCTION__, stat);
+		return task_error(drive, rq, __func__, stat);
 
 	/* Deal with unexpected ATA data phase. */
 	if (((stat & DRQ_STAT) == 0) ^ !hwif->nleft)
-		return task_error(drive, rq, __FUNCTION__, stat);
+		return task_error(drive, rq, __func__, stat);
 
 	if (!hwif->nleft) {
 		task_end_request(drive, rq, stat);
@@ -675,7 +676,7 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 				/* (hs): give up if multcount is not set */
 				printk(KERN_ERR "%s: %s Multimode Write " \
 					"multcount is not set\n",
-					drive->name, __FUNCTION__);
+					drive->name, __func__);
 				err = -EPERM;
 				goto abort;
 			}
@@ -692,7 +693,7 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 				/* (hs): give up if multcount is not set */
 				printk(KERN_ERR "%s: %s Multimode Read failure " \
 					"multcount is not set\n",
-					drive->name, __FUNCTION__);
+					drive->name, __func__);
 				err = -EPERM;
 				goto abort;
 			}
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index d868ca4..bced02f 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -227,79 +227,6 @@ static int ide_system_bus_speed(void)
 	return pci_dev_present(pci_default) ? 33 : 50;
 }
 
-static struct resource* hwif_request_region(ide_hwif_t *hwif,
-					    unsigned long addr, int num)
-{
-	struct resource *res = request_region(addr, num, hwif->name);
-
-	if (!res)
-		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
-				hwif->name, addr, addr+num-1);
-	return res;
-}
-
-/**
- *	ide_hwif_request_regions - request resources for IDE
- *	@hwif: interface to use
- *
- *	Requests all the needed resources for an interface.
- *	Right now core IDE code does this work which is deeply wrong.
- *	MMIO leaves it to the controller driver,
- *	PIO will migrate this way over time.
- */
-
-int ide_hwif_request_regions(ide_hwif_t *hwif)
-{
-	unsigned long addr;
-
-	if (hwif->mmio)
-		return 0;
-
-	addr = hwif->io_ports[IDE_CONTROL_OFFSET];
-
-	if (addr && !hwif_request_region(hwif, addr, 1))
-		goto control_region_busy;
-
-	addr = hwif->io_ports[IDE_DATA_OFFSET];
-	BUG_ON((addr | 7) != hwif->io_ports[IDE_STATUS_OFFSET]);
-
-	if (!hwif_request_region(hwif, addr, 8))
-		goto data_region_busy;
-
-	return 0;
-
-data_region_busy:
-	addr = hwif->io_ports[IDE_CONTROL_OFFSET];
-	if (addr)
-		release_region(addr, 1);
-control_region_busy:
-	/* If any errors are return, we drop the hwif interface. */
-	return -EBUSY;
-}
-
-/**
- *	ide_hwif_release_regions - free IDE resources
- *
- *	Note that we only release the standard ports,
- *	and do not even try to handle any extra ports
- *	allocated for weird IDE interface chipsets.
- *
- *	Note also that we don't yet handle mmio resources here. More
- *	importantly our caller should be doing this so we need to 
- *	restructure this as a helper function for drivers.
- */
-
-void ide_hwif_release_regions(ide_hwif_t *hwif)
-{
-	if (hwif->mmio)
-		return;
-
-	if (hwif->io_ports[IDE_CONTROL_OFFSET])
-		release_region(hwif->io_ports[IDE_CONTROL_OFFSET], 1);
-
-	release_region(hwif->io_ports[IDE_DATA_OFFSET], 8);
-}
-
 void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
 {
 	ide_hwgroup_t *hwgroup = hwif->hwgroup;
@@ -436,9 +363,7 @@ void ide_unregister(unsigned int index)
 	spin_lock_irq(&ide_lock);
 
 	if (hwif->dma_base)
-		(void)ide_release_dma(hwif);
-
-	ide_hwif_release_regions(hwif);
+		ide_release_dma_engine(hwif);
 
 	/* restore hwif data to pristine status */
 	ide_init_port_data(hwif, index);
@@ -454,7 +379,6 @@ void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
 {
 	memcpy(hwif->io_ports, hw->io_ports, sizeof(hwif->io_ports));
 	hwif->irq = hw->irq;
-	hwif->noprobe = 0;
 	hwif->chipset = hw->chipset;
 	hwif->gendev.parent = hw->dev;
 	hwif->ack_intr = hw->ack_intr;
@@ -545,7 +469,7 @@ int set_using_dma(ide_drive_t *drive, int arg)
 	if (!drive->id || !(drive->id->capability & 1))
 		goto out;
 
-	if (hwif->dma_host_set == NULL)
+	if (hwif->dma_ops == NULL)
 		goto out;
 
 	err = -EBUSY;
@@ -585,11 +509,12 @@ int set_pio_mode(ide_drive_t *drive, int arg)
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
 
@@ -1005,14 +930,12 @@ static int __init ide_setup(char *s)
 				goto done;
 			case -3: /* "nowerr" */
 				drive->bad_wstat = BAD_R_STAT;
-				hwif->noprobe = 0;
 				goto done;
 			case -4: /* "cdrom" */
 				drive->present = 1;
 				drive->media = ide_cdrom;
 				/* an ATAPI device ignores DRDY */
 				drive->ready_stat = 0;
-				hwif->noprobe = 0;
 				goto done;
 			case -5: /* nodma */
 				drive->nodma = 1;
@@ -1043,7 +966,6 @@ static int __init ide_setup(char *s)
 				drive->sect	= drive->bios_sect = vals[2];
 				drive->present	= 1;
 				drive->forced_geom = 1;
-				hwif->noprobe = 0;
 				goto done;
 			default:
 				goto bad_option;
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index 33bb7b8..6efbf94 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -49,6 +49,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "ali14xx"
+
 /* port addresses for auto-detection */
 #define ALI_NUM_PORTS 4
 static const int ports[ALI_NUM_PORTS] __initdata =
@@ -192,18 +194,20 @@ static int __init initRegisters(void)
 	return t;
 }
 
+static const struct ide_port_ops ali14xx_port_ops = {
+	.set_pio_mode		= ali14xx_set_pio_mode,
+};
+
 static const struct ide_port_info ali14xx_port_info = {
+	.name			= DRV_NAME,
 	.chipset		= ide_ali14xx,
+	.port_ops		= &ali14xx_port_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_AUTOTUNE,
 	.pio_mask		= ATA_PIO4,
 };
 
 static int __init ali14xx_probe(void)
 {
-	ide_hwif_t *hwif, *mate;
-	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
-
 	printk(KERN_DEBUG "ali14xx: base=0x%03x, regOn=0x%02x.\n",
 			  basePort, regOn);
 
@@ -213,31 +217,7 @@ static int __init ali14xx_probe(void)
 		return 1;
 	}
 
-	memset(&hw, 0, sizeof(hw));
-
-	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
-	hw[0].irq = 14;
-
-	ide_std_init_ports(&hw[1], 0x170, 0x376);
-	hw[1].irq = 15;
-
-	hwif = ide_find_port();
-	if (hwif) {
-		ide_init_port_hw(hwif, &hw[0]);
-		hwif->set_pio_mode = &ali14xx_set_pio_mode;
-		idx[0] = hwif->index;
-	}
-
-	mate = ide_find_port();
-	if (mate) {
-		ide_init_port_hw(mate, &hw[1]);
-		mate->set_pio_mode = &ali14xx_set_pio_mode;
-		idx[1] = mate->index;
-	}
-
-	ide_device_add(idx, &ali14xx_port_info);
-
-	return 0;
+	return ide_legacy_device_add(&ali14xx_port_info, 0);
 }
 
 int probe_ali14xx;
diff --git a/drivers/ide/legacy/buddha.c b/drivers/ide/legacy/buddha.c
index 6956eb8..f51433b 100644
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -228,8 +228,6 @@ fail_base2:
 				ide_init_port_data(hwif, index);
 				ide_init_port_hw(hwif, &hw);
 
-				hwif->mmio = 1;
-
 				idx[i] = index;
 			}
 		}
diff --git a/drivers/ide/legacy/dtc2278.c b/drivers/ide/legacy/dtc2278.c
index 9c6b324..f7c4ad1 100644
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -16,6 +16,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "dtc2278"
+
 /*
  * Changing this #undef to #define may solve start up problems in some systems.
  */
@@ -86,8 +88,14 @@ static void dtc2278_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	}
 }
 
+static const struct ide_port_ops dtc2278_port_ops = {
+	.set_pio_mode		= dtc2278_set_pio_mode,
+};
+
 static const struct ide_port_info dtc2278_port_info __initdata = {
+	.name			= DRV_NAME,
 	.chipset		= ide_dtc2278,
+	.port_ops		= &dtc2278_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_UNMASK_IRQS |
 				  IDE_HFLAG_IO_32BIT |
@@ -101,9 +109,6 @@ static const struct ide_port_info dtc2278_port_info __initdata = {
 static int __init dtc2278_probe(void)
 {
 	unsigned long flags;
-	ide_hwif_t *hwif, *mate;
-	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
 
 	local_irq_save(flags);
 	/*
@@ -123,30 +128,7 @@ static int __init dtc2278_probe(void)
 #endif
 	local_irq_restore(flags);
 
-	memset(&hw, 0, sizeof(hw));
-
-	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
-	hw[0].irq = 14;
-
-	ide_std_init_ports(&hw[1], 0x170, 0x376);
-	hw[1].irq = 15;
-
-	hwif = ide_find_port();
-	if (hwif) {
-		ide_init_port_hw(hwif, &hw[0]);
-		hwif->set_pio_mode = dtc2278_set_pio_mode;
-		idx[0] = hwif->index;
-	}
-
-	mate = ide_find_port();
-	if (mate) {
-		ide_init_port_hw(mate, &hw[1]);
-		idx[1] = mate->index;
-	}
-
-	ide_device_add(idx, &dtc2278_port_info);
-
-	return 0;
+	return ide_legacy_device_add(&dtc2278_port_info, 0);
 }
 
 int probe_dtc2278 = 0;
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index 8c9c9f7..5c19c42 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -89,7 +89,6 @@ static int __init falconide_init(void)
 
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
-		hwif->mmio = 1;
 
 		ide_get_lock(NULL, NULL);
 		ide_device_add(idx, NULL);
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index fcc8d52..a0c9601 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -182,8 +182,6 @@ found:
 	    ide_init_port_data(hwif, index);
 	    ide_init_port_hw(hwif, &hw);
 
-	    hwif->mmio = 1;
-
 	    idx[i] = index;
 	} else
 	    release_mem_region(res_start, res_n);
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index 60f52f5..702d8de 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -328,8 +328,16 @@ int probe_ht6560b = 0;
 module_param_named(probe, probe_ht6560b, bool, 0);
 MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
 
+static const struct ide_port_ops ht6560b_port_ops = {
+	.port_init_devs		= ht6560b_port_init_devs,
+	.set_pio_mode		= ht6560b_set_pio_mode,
+	.selectproc		= ht6560b_selectproc,
+};
+
 static const struct ide_port_info ht6560b_port_info __initdata = {
+	.name			= DRV_NAME,
 	.chipset		= ide_ht6560b,
+	.port_ops		= &ht6560b_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE | /* is this needed? */
 				  IDE_HFLAG_NO_DMA |
 				  IDE_HFLAG_NO_AUTOTUNE |
@@ -339,53 +347,21 @@ static const struct ide_port_info ht6560b_port_info __initdata = {
 
 static int __init ht6560b_init(void)
 {
-	ide_hwif_t *hwif, *mate;
-	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
-
 	if (probe_ht6560b == 0)
 		return -ENODEV;
 
 	if (!request_region(HT_CONFIG_PORT, 1, DRV_NAME)) {
 		printk(KERN_NOTICE "%s: HT_CONFIG_PORT not found\n",
-			__FUNCTION__);
+			__func__);
 		return -ENODEV;
 	}
 
 	if (!try_to_init_ht6560b()) {
-		printk(KERN_NOTICE "%s: HBA not found\n", __FUNCTION__);
+		printk(KERN_NOTICE "%s: HBA not found\n", __func__);
 		goto release_region;
 	}
 
-	memset(&hw, 0, sizeof(hw));
-
-	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
-	hw[0].irq = 14;
-
-	ide_std_init_ports(&hw[1], 0x170, 0x376);
-	hw[1].irq = 15;
-
-	hwif = ide_find_port();
-	if (hwif) {
-		ide_init_port_hw(hwif, &hw[0]);
-		hwif->selectproc     = ht6560b_selectproc;
-		hwif->set_pio_mode   = ht6560b_set_pio_mode;
-		hwif->port_init_devs = ht6560b_port_init_devs;
-		idx[0] = hwif->index;
-	}
-
-	mate = ide_find_port();
-	if (mate) {
-		ide_init_port_hw(mate, &hw[1]);
-		mate->selectproc     = ht6560b_selectproc;
-		mate->set_pio_mode   = ht6560b_set_pio_mode;
-		mate->port_init_devs = ht6560b_port_init_devs;
-		idx[1] = mate->index;
-	}
-
-	ide_device_add(idx, &ht6560b_port_info);
-
-	return 0;
+	return ide_legacy_device_add(&ht6560b_port_info, 0);
 
 release_region:
 	release_region(HT_CONFIG_PORT, 1);
diff --git a/drivers/ide/legacy/ide-4drives.c b/drivers/ide/legacy/ide-4drives.c
index c352f12..17f94d0 100644
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -4,6 +4,8 @@
 #include <linux/module.h>
 #include <linux/ide.h>
 
+#define DRV_NAME "ide-4drives"
+
 int probe_4drives;
 
 module_param_named(probe, probe_4drives, bool, 0);
@@ -12,15 +14,29 @@ MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
 static int __init ide_4drives_init(void)
 {
 	ide_hwif_t *hwif, *mate;
+	unsigned long base = 0x1f0, ctl = 0x3f6;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw;
 
 	if (probe_4drives == 0)
 		return -ENODEV;
 
+	if (!request_region(base, 8, DRV_NAME)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
+				DRV_NAME, base, base + 7);
+		return -EBUSY;
+	}
+
+	if (!request_region(ctl, 1, DRV_NAME)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
+				DRV_NAME, ctl);
+		release_region(base, 8);
+		return -EBUSY;
+	}
+
 	memset(&hw, 0, sizeof(hw));
 
-	ide_std_init_ports(&hw, 0x1f0, 0x3f6);
+	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = 14;
 	hw.chipset = ide_4drives;
 
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index b97b8d5..855e157 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -51,6 +51,8 @@
 #include <pcmcia/cisreg.h>
 #include <pcmcia/ciscode.h>
 
+#define DRV_NAME "ide-cs"
+
 /*====================================================================*/
 
 /* Module parameters */
@@ -72,16 +74,11 @@ static char *version =
 
 /*====================================================================*/
 
-static const char ide_major[] = {
-    IDE0_MAJOR, IDE1_MAJOR, IDE2_MAJOR, IDE3_MAJOR,
-    IDE4_MAJOR, IDE5_MAJOR
-};
-
 typedef struct ide_info_t {
 	struct pcmcia_device	*p_dev;
+	ide_hwif_t		*hwif;
     int		ndev;
     dev_node_t	node;
-    int		hd;
 } ide_info_t;
 
 static void ide_release(struct pcmcia_device *);
@@ -136,20 +133,44 @@ static int ide_probe(struct pcmcia_device *link)
 
 static void ide_detach(struct pcmcia_device *link)
 {
+    ide_info_t *info = link->priv;
+    ide_hwif_t *hwif = info->hwif;
+
     DEBUG(0, "ide_detach(0x%p)\n", link);
 
     ide_release(link);
 
-    kfree(link->priv);
+    release_region(hwif->io_ports[IDE_CONTROL_OFFSET], 1);
+    release_region(hwif->io_ports[IDE_DATA_OFFSET], 8);
+
+    kfree(info);
 } /* ide_detach */
 
-static int idecs_register(unsigned long io, unsigned long ctl, unsigned long irq, struct pcmcia_device *handle)
+static const struct ide_port_ops idecs_port_ops = {
+	.quirkproc		= ide_undecoded_slave,
+};
+
+static ide_hwif_t *idecs_register(unsigned long io, unsigned long ctl,
+				unsigned long irq, struct pcmcia_device *handle)
 {
     ide_hwif_t *hwif;
     hw_regs_t hw;
     int i;
     u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
+    if (!request_region(io, 8, DRV_NAME)) {
+	printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
+			DRV_NAME, io, io + 7);
+	return NULL;
+    }
+
+    if (!request_region(ctl, 1, DRV_NAME)) {
+	printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
+			DRV_NAME, ctl);
+	release_region(io, 8);
+	return NULL;
+    }
+
     memset(&hw, 0, sizeof(hw));
     ide_std_init_ports(&hw, io, ctl);
     hw.irq = irq;
@@ -158,7 +179,7 @@ static int idecs_register(unsigned long io, unsigned long ctl, unsigned long irq
 
     hwif = ide_find_port();
     if (hwif == NULL)
-	return -1;
+	goto out_release;
 
     i = hwif->index;
 
@@ -168,13 +189,19 @@ static int idecs_register(unsigned long io, unsigned long ctl, unsigned long irq
 	ide_init_port_data(hwif, i);
 
     ide_init_port_hw(hwif, &hw);
-    hwif->quirkproc = &ide_undecoded_slave;
+    hwif->port_ops = &idecs_port_ops;
 
     idx[0] = i;
 
     ide_device_add(idx, NULL);
 
-    return hwif->present ? i : -1;
+    if (hwif->present)
+	return hwif;
+
+out_release:
+    release_region(ctl, 1);
+    release_region(io, 8);
+    return NULL;
 }
 
 /*======================================================================
@@ -199,8 +226,9 @@ static int ide_config(struct pcmcia_device *link)
 	cistpl_cftable_entry_t dflt;
     } *stk = NULL;
     cistpl_cftable_entry_t *cfg;
-    int i, pass, last_ret = 0, last_fn = 0, hd, is_kme = 0;
+    int i, pass, last_ret = 0, last_fn = 0, is_kme = 0;
     unsigned long io_base, ctl_base;
+    ide_hwif_t *hwif;
 
     DEBUG(0, "ide_config(0x%p)\n", link);
 
@@ -296,14 +324,15 @@ static int ide_config(struct pcmcia_device *link)
 	outb(0x81, ctl_base+1);
 
     /* retry registration in case device is still spinning up */
-    for (hd = -1, i = 0; i < 10; i++) {
-	hd = idecs_register(io_base, ctl_base, link->irq.AssignedIRQ, link);
-	if (hd >= 0) break;
+    for (i = 0; i < 10; i++) {
+	hwif = idecs_register(io_base, ctl_base, link->irq.AssignedIRQ, link);
+	if (hwif)
+	    break;
 	if (link->io.NumPorts1 == 0x20) {
 	    outb(0x02, ctl_base + 0x10);
-	    hd = idecs_register(io_base + 0x10, ctl_base + 0x10,
-				link->irq.AssignedIRQ, link);
-	    if (hd >= 0) {
+	    hwif = idecs_register(io_base + 0x10, ctl_base + 0x10,
+				  link->irq.AssignedIRQ, link);
+	    if (hwif) {
 		io_base += 0x10;
 		ctl_base += 0x10;
 		break;
@@ -312,7 +341,7 @@ static int ide_config(struct pcmcia_device *link)
 	msleep(100);
     }
 
-    if (hd < 0) {
+    if (hwif == NULL) {
 	printk(KERN_NOTICE "ide-cs: ide_register() at 0x%3lx & 0x%3lx"
 	       ", irq %u failed\n", io_base, ctl_base,
 	       link->irq.AssignedIRQ);
@@ -320,10 +349,10 @@ static int ide_config(struct pcmcia_device *link)
     }
 
     info->ndev = 1;
-    sprintf(info->node.dev_name, "hd%c", 'a' + (hd * 2));
-    info->node.major = ide_major[hd];
+    sprintf(info->node.dev_name, "hd%c", 'a' + hwif->index * 2);
+    info->node.major = hwif->major;
     info->node.minor = 0;
-    info->hd = hd;
+    info->hwif = hwif;
     link->dev_node = &info->node;
     printk(KERN_INFO "ide-cs: %s: Vpp = %d.%d\n",
 	   info->node.dev_name, link->conf.Vpp / 10, link->conf.Vpp % 10);
@@ -354,13 +383,14 @@ failed:
 void ide_release(struct pcmcia_device *link)
 {
     ide_info_t *info = link->priv;
+    ide_hwif_t *hwif = info->hwif;
 
     DEBUG(0, "ide_release(0x%p)\n", link);
 
     if (info->ndev) {
 	/* FIXME: if this fails we need to queue the cleanup somehow
 	   -- need to investigate the required PCMCIA magic */
-	ide_unregister(info->hd);
+	ide_unregister(hwif->index);
     }
     info->ndev = 0;
 
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
index bf24077..822f48b 100644
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -100,7 +100,6 @@ static int __devinit plat_ide_probe(struct platform_device *pdev)
 	hw.dev = &pdev->dev;
 
 	ide_init_port_hw(hwif, &hw);
-	hwif->mmio = 1;
 
 	if (mmio)
 		default_hwif_mmiops(hwif);
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index 7429b80..26546d0 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -128,8 +128,6 @@ static int __init macide_init(void)
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
 
-		hwif->mmio = 1;
-
 		ide_device_add(idx, NULL);
 	}
 
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index fcbff0e..f23999d 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -141,7 +141,6 @@ static int __init q40ide_init(void)
 	if (hwif) {
 		ide_init_port_data(hwif, hwif->index);
 		ide_init_port_hw(hwif, &hw);
-		hwif->mmio = 1;
 
 		idx[i] = hwif->index;
 	}
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index 6e820c7..15a99aa 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -37,6 +37,8 @@
 #include <asm/system.h>
 #include <asm/io.h>
 
+#define DRV_NAME "qd65xx"
+
 #include "qd65xx.h"
 
 /*
@@ -304,7 +306,20 @@ static void __init qd6580_port_init_devs(ide_hwif_t *hwif)
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
+	.name			= DRV_NAME,
 	.chipset		= ide_qd65xx,
 	.host_flags		= IDE_HFLAG_IO_32BIT |
 				  IDE_HFLAG_NO_DMA |
@@ -321,10 +336,8 @@ static const struct ide_port_info qd65xx_port_info __initdata = {
 
 static int __init qd_probe(int base)
 {
-	ide_hwif_t *hwif;
-	u8 config, unit;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
+	int rc;
+	u8 config, unit, control;
 	struct ide_port_info d = qd65xx_port_info;
 
 	config = inb(QD_CONFIG_PORT);
@@ -337,21 +350,11 @@ static int __init qd_probe(int base)
 	if (unit)
 		d.host_flags |= IDE_HFLAG_QD_2ND_PORT;
 
-	memset(&hw, 0, sizeof(hw));
-
-	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
-	hw[0].irq = 14;
-
-	ide_std_init_ports(&hw[1], 0x170, 0x376);
-	hw[1].irq = 15;
-
-	if ((config & 0xf0) == QD_CONFIG_QD6500) {
-
+	switch (config & 0xf0) {
+	case QD_CONFIG_QD6500:
 		if (qd_testreg(base))
 			 return -ENODEV;	/* bad register */
 
-		/* qd6500 found */
-
 		if (config & QD_CONFIG_DISABLED) {
 			printk(KERN_WARNING "qd6500 is disabled !\n");
 			return -ENODEV;
@@ -361,37 +364,14 @@ static int __init qd_probe(int base)
 		printk(KERN_DEBUG "qd6500: config=%#x, ID3=%u\n",
 			config, QD_ID3);
 
+		d.port_ops = &qd6500_port_ops;
 		d.host_flags |= IDE_HFLAG_SINGLE;
-
-		hwif = ide_find_port_slot(&d);
-		if (hwif == NULL)
-			return -ENOENT;
-
-		ide_init_port_hw(hwif, &hw[unit]);
-
-		hwif->config_data = (base << 8) | config;
-
-		hwif->port_init_devs = qd6500_port_init_devs;
-		hwif->set_pio_mode   = qd6500_set_pio_mode;
-		hwif->selectproc     = qd65xx_select;
-
-		idx[unit] = hwif->index;
-
-		ide_device_add(idx, &d);
-
-		return 1;
-	}
-
-	if (((config & 0xf0) == QD_CONFIG_QD6580_A) ||
-	    ((config & 0xf0) == QD_CONFIG_QD6580_B)) {
-
-		u8 control;
-
+		break;
+	case QD_CONFIG_QD6580_A:
+	case QD_CONFIG_QD6580_B:
 		if (qd_testreg(base) || qd_testreg(base + 0x02))
 			return -ENODEV;	/* bad registers */
 
-		/* qd6580 found */
-
 		control = inb(QD_CONTROL_PORT);
 
 		printk(KERN_NOTICE "qd6580 at %#x\n", base);
@@ -400,63 +380,23 @@ static int __init qd_probe(int base)
 
 		outb(QD_DEF_CONTR, QD_CONTROL_PORT);
 
-		if (control & QD_CONTR_SEC_DISABLED) {
-			/* secondary disabled */
-
-			printk(KERN_INFO "qd6580: single IDE board\n");
-
+		d.port_ops = &qd6580_port_ops;
+		if (control & QD_CONTR_SEC_DISABLED)
 			d.host_flags |= IDE_HFLAG_SINGLE;
 
-			hwif = ide_find_port_slot(&d);
-			if (hwif == NULL)
-				return -ENOENT;
-
-			ide_init_port_hw(hwif, &hw[unit]);
-
-			hwif->config_data = (base << 8) | config;
-
-			hwif->port_init_devs = qd6580_port_init_devs;
-			hwif->set_pio_mode   = qd6580_set_pio_mode;
-			hwif->selectproc     = qd65xx_select;
+		printk(KERN_INFO "qd6580: %s IDE board\n",
+			(control & QD_CONTR_SEC_DISABLED) ? "single" : "dual");
+		break;
+	default:
+		return -ENODEV;
+	}
 
-			idx[unit] = hwif->index;
+	rc = ide_legacy_device_add(&d, (base << 8) | config);
 
-			ide_device_add(idx, &d);
+	if (d.host_flags & IDE_HFLAG_SINGLE)
+		return (rc == 0) ? 1 : rc;
 
-			return 1;
-		} else {
-			ide_hwif_t *mate;
-
-			/* secondary enabled */
-			printk(KERN_INFO "qd6580: dual IDE board\n");
-
-			hwif = ide_find_port();
-			if (hwif) {
-				ide_init_port_hw(hwif, &hw[0]);
-				hwif->config_data = (base << 8) | config;
-				hwif->port_init_devs = qd6580_port_init_devs;
-				hwif->set_pio_mode   = qd6580_set_pio_mode;
-				hwif->selectproc     = qd65xx_select;
-				idx[0] = hwif->index;
-			}
-
-			mate = ide_find_port();
-			if (mate) {
-				ide_init_port_hw(mate, &hw[1]);
-				mate->config_data = (base << 8) | config;
-				mate->port_init_devs = qd6580_port_init_devs;
-				mate->set_pio_mode   = qd6580_set_pio_mode;
-				mate->selectproc     = qd65xx_select;
-				idx[1] = mate->index;
-			}
-
-			ide_device_add(idx, &qd65xx_port_info);
-
-			return 0; /* no other qd65xx possible */
-		}
-	}
-	/* no qd65xx found */
-	return -ENODEV;
+	return rc;
 }
 
 int probe_qd65xx = 0;
diff --git a/drivers/ide/legacy/umc8672.c b/drivers/ide/legacy/umc8672.c
index 4d90bad..17d5153 100644
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -51,6 +51,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "umc8672"
+
 /*
  * Default speeds.  These can be changed with "auto-tune" and/or hdparm.
  */
@@ -120,18 +122,21 @@ static void umc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
+static const struct ide_port_ops umc8672_port_ops = {
+	.set_pio_mode		= umc_set_pio_mode,
+};
+
 static const struct ide_port_info umc8672_port_info __initdata = {
+	.name			= DRV_NAME,
 	.chipset		= ide_umc8672,
+	.port_ops		= &umc8672_port_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_AUTOTUNE,
 	.pio_mask		= ATA_PIO4,
 };
 
 static int __init umc8672_probe(void)
 {
-	ide_hwif_t *hwif, *mate;
 	unsigned long flags;
-	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
 
 	if (!request_region(0x108, 2, "umc8672")) {
 		printk(KERN_ERR "umc8672: ports 0x108-0x109 already in use.\n");
@@ -150,31 +155,7 @@ static int __init umc8672_probe(void)
 	umc_set_speeds(current_speeds);
 	local_irq_restore(flags);
 
-	memset(&hw, 0, sizeof(hw));
-
-	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
-	hw[0].irq = 14;
-
-	ide_std_init_ports(&hw[1], 0x170, 0x376);
-	hw[1].irq = 15;
-
-	hwif = ide_find_port();
-	if (hwif) {
-		ide_init_port_hw(hwif, &hw[0]);
-		hwif->set_pio_mode = umc_set_pio_mode;
-		idx[0] = hwif->index;
-	}
-
-	mate = ide_find_port();
-	if (mate) {
-		ide_init_port_hw(mate, &hw[1]);
-		mate->set_pio_mode = umc_set_pio_mode;
-		idx[1] = mate->index;
-	}
-
-	ide_device_add(idx, &umc8672_port_info);
-
-	return 0;
+	return ide_legacy_device_add(&umc8672_port_info, 0);
 }
 
 int probe_umc8672;
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index a8cd003..3485a31 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -47,7 +47,6 @@
 #define IDE_AU1XXX_BURSTMODE	1
 
 static _auide_hwif auide_hwif;
-static int dbdma_init_done;
 
 static int auide_ddma_init(_auide_hwif *auide);
 
@@ -61,7 +60,7 @@ void auide_insw(unsigned long port, void *addr, u32 count)
 
 	if(!put_dest_flags(ahwif->rx_chan, (void*)addr, count << 1, 
 			   DDMA_FLAGS_NOIE)) {
-		printk(KERN_ERR "%s failed %d\n", __FUNCTION__, __LINE__);
+		printk(KERN_ERR "%s failed %d\n", __func__, __LINE__);
 		return;
 	}
 	ctp = *((chan_tab_t **)ahwif->rx_chan);
@@ -79,7 +78,7 @@ void auide_outsw(unsigned long port, void *addr, u32 count)
 
 	if(!put_source_flags(ahwif->tx_chan, (void*)addr,
 			     count << 1, DDMA_FLAGS_NOIE)) {
-		printk(KERN_ERR "%s failed %d\n", __FUNCTION__, __LINE__);
+		printk(KERN_ERR "%s failed %d\n", __func__, __LINE__);
 		return;
 	}
 	ctp = *((chan_tab_t **)ahwif->tx_chan);
@@ -250,7 +249,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 						     (void*) sg_virt(sg),
 						     tc, flags)) { 
 					printk(KERN_ERR "%s failed %d\n", 
-					       __FUNCTION__, __LINE__);
+					       __func__, __LINE__);
 				}
 			} else 
 			{
@@ -258,7 +257,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 						   (void*) sg_virt(sg),
 						   tc, flags)) { 
 					printk(KERN_ERR "%s failed %d\n", 
-					       __FUNCTION__, __LINE__);
+					       __func__, __LINE__);
 				}
 			}
 
@@ -315,35 +314,6 @@ static int auide_dma_setup(ide_drive_t *drive)
 	return 0;
 }
 
-static u8 auide_mdma_filter(ide_drive_t *drive)
-{
-	/*
-	 * FIXME: ->white_list and ->black_list are based on completely bogus
-	 * ->ide_dma_check implementation which didn't set neither the host
-	 * controller timings nor the device for the desired transfer mode.
-	 *
-	 * They should be either removed or 0x00 MWDMA mask should be
-	 * returned for devices on the ->black_list.
-	 */
-
-	if (dbdma_init_done == 0) {
-		auide_hwif.white_list = ide_in_drive_list(drive->id,
-							  dma_white_list);
-		auide_hwif.black_list = ide_in_drive_list(drive->id,
-							  dma_black_list);
-		auide_hwif.drive = drive;
-		auide_ddma_init(&auide_hwif);
-		dbdma_init_done = 1;
-	}
-
-	/* Is the drive in our DMA black list? */
-	if (auide_hwif.black_list)
-		printk(KERN_WARNING "%s: Disabling DMA for %s (blacklisted)\n",
-				    drive->name, drive->id->model);
-
-	return drive->hwif->mwdma_mask;
-}
-
 static int auide_dma_test_irq(ide_drive_t *drive)
 {	
 	if (drive->waiting_for_dma == 0)
@@ -396,41 +366,41 @@ static void auide_init_dbdma_dev(dbdev_tab_t *dev, u32 dev_id, u32 tsize, u32 de
 	dev->dev_devwidth    = devwidth;
 	dev->dev_flags       = flags;
 }
-  
-#if defined(CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA)
 
+#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 static void auide_dma_timeout(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 
 	printk(KERN_ERR "%s: DMA timeout occurred: ", drive->name);
 
-	if (hwif->ide_dma_test_irq(drive))
+	if (auide_dma_test_irq(drive))
 		return;
 
-	hwif->ide_dma_end(drive);
+	auide_dma_end(drive);
 }
-					
 
-static int auide_ddma_init(_auide_hwif *auide) {
-	
+static const struct ide_dma_ops au1xxx_dma_ops = {
+	.dma_host_set		= auide_dma_host_set,
+	.dma_setup		= auide_dma_setup,
+	.dma_exec_cmd		= auide_dma_exec_cmd,
+	.dma_start		= auide_dma_start,
+	.dma_end		= auide_dma_end,
+	.dma_test_irq		= auide_dma_test_irq,
+	.dma_lost_irq		= auide_dma_lost_irq,
+	.dma_timeout		= auide_dma_timeout,
+};
+
+static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
+{
+	_auide_hwif *auide = (_auide_hwif *)hwif->hwif_data;
 	dbdev_tab_t source_dev_tab, target_dev_tab;
 	u32 dev_id, tsize, devwidth, flags;
-	ide_hwif_t *hwif = auide->hwif;
 
 	dev_id   = AU1XXX_ATA_DDMA_REQ;
 
-	if (auide->white_list || auide->black_list) {
-		tsize    = 8;
-		devwidth = 32;
-	}
-	else { 
-		tsize    = 1;
-		devwidth = 16;
-		
-		printk(KERN_ERR "au1xxx-ide: %s is not on ide driver whitelist.\n",auide_hwif.drive->id->model);
-		printk(KERN_ERR "            please read 'Documentation/mips/AU1xxx_IDE.README'");
-	}
+	tsize    =  8; /*  1 */
+	devwidth = 32; /* 16 */
 
 #ifdef IDE_AU1XXX_BURSTMODE 
 	flags = DEV_FLAGS_SYNC | DEV_FLAGS_BURSTABLE;
@@ -482,9 +452,9 @@ static int auide_ddma_init(_auide_hwif *auide) {
 	return 0;
 } 
 #else
- 
-static int auide_ddma_init( _auide_hwif *auide )
+static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
+	_auide_hwif *auide = (_auide_hwif *)hwif->hwif_data;
 	dbdev_tab_t source_dev_tab;
 	int flags;
 
@@ -543,9 +513,18 @@ static void auide_setup_ports(hw_regs_t *hw, _auide_hwif *ahwif)
 	*ata_regs = ahwif->regbase + (14 << AU1XXX_ATA_REG_OFFSET);
 }
 
+static const struct ide_port_ops au1xxx_port_ops = {
+	.set_pio_mode		= au1xxx_set_pio_mode,
+	.set_dma_mode		= auide_set_dma_mode,
+};
+
 static const struct ide_port_info au1xxx_port_info = {
+	.init_dma		= auide_ddma_init,
+	.port_ops		= &au1xxx_port_ops,
+#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
+	.dma_ops		= &au1xxx_dma_ops,
+#endif
 	.host_flags		= IDE_HFLAG_POST_SET_MODE |
-				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
 				  IDE_HFLAG_NO_IO_32BIT |
 				  IDE_HFLAG_UNMASK_IRQS,
 	.pio_mask		= ATA_PIO4,
@@ -615,8 +594,6 @@ static int au_ide_probe(struct device *dev)
 
 	hwif->dev = dev;
 
-	hwif->mmio  = 1;
-
 	/* If the user has selected DDMA assisted copies,
 	   then set up a few local I/O function entry points 
 	*/
@@ -625,34 +602,12 @@ static int au_ide_probe(struct device *dev)
 	hwif->INSW                      = auide_insw;
 	hwif->OUTSW                     = auide_outsw;
 #endif
-
-	hwif->set_pio_mode		= &au1xxx_set_pio_mode;
-	hwif->set_dma_mode		= &auide_set_dma_mode;
-
-#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
-	hwif->dma_timeout		= &auide_dma_timeout;
-
-	hwif->mdma_filter		= &auide_mdma_filter;
-
-	hwif->dma_host_set		= &auide_dma_host_set;
-	hwif->dma_exec_cmd              = &auide_dma_exec_cmd;
-	hwif->dma_start                 = &auide_dma_start;
-	hwif->ide_dma_end               = &auide_dma_end;
-	hwif->dma_setup                 = &auide_dma_setup;
-	hwif->ide_dma_test_irq          = &auide_dma_test_irq;
-	hwif->dma_lost_irq		= &auide_dma_lost_irq;
-#endif
 	hwif->select_data               = 0;    /* no chipset-specific code */
 	hwif->config_data               = 0;    /* no chipset-specific code */
 
 	auide_hwif.hwif                 = hwif;
 	hwif->hwif_data                 = &auide_hwif;
 
-#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA           
-	auide_ddma_init(&auide_hwif);
-	dbdma_init_done = 1;
-#endif
-
 	idx[0] = hwif->index;
 
 	ide_device_add(idx, &au1xxx_port_info);
diff --git a/drivers/ide/mips/swarm.c b/drivers/ide/mips/swarm.c
index bbe8d58..112fe56 100644
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -110,10 +110,8 @@ static int __devinit swarm_ide_probe(struct device *dev)
 
 	/* Setup MMIO ops.  */
 	default_hwif_mmiops(hwif);
-	/* Prevent resource map manipulation.  */
-	hwif->mmio = 1;
+
 	hwif->chipset = ide_generic;
-	hwif->noprobe = 0;
 
 	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
 		hwif->io_ports[i] =
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index c9ba15a..ca16f37 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -135,7 +135,7 @@ static void aec6260_set_mode(ide_drive_t *drive, const u8 speed)
 
 static void aec_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	drive->hwif->set_dma_mode(drive, pio + XFER_PIO_0);
+	drive->hwif->port_ops->set_dma_mode(drive, pio + XFER_PIO_0);
 }
 
 static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const char *name)
@@ -175,27 +175,23 @@ static u8 __devinit atp86x_cable_detect(ide_hwif_t *hwif)
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
@@ -207,7 +203,7 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 	},{	/* 1 */
 		.name		= "AEC6260",
 		.init_chipset	= init_chipset_aec62xx,
-		.init_hwif	= init_hwif_aec62xx,
+		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_NO_AUTODMA |
 				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
@@ -217,8 +213,8 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 	},{	/* 2 */
 		.name		= "AEC6260R",
 		.init_chipset	= init_chipset_aec62xx,
-		.init_hwif	= init_hwif_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
+		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
 				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_NON_BOOTABLE,
@@ -228,7 +224,7 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 	},{	/* 3 */
 		.name		= "AEC6280",
 		.init_chipset	= init_chipset_aec62xx,
-		.init_hwif	= init_hwif_aec62xx,
+		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
 				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
@@ -238,8 +234,8 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 	},{	/* 4 */
 		.name		= "AEC6280R",
 		.init_chipset	= init_chipset_aec62xx,
-		.init_hwif	= init_hwif_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
+		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
 				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 3fa2d9f..b5a3bc3 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -610,7 +610,7 @@ static int ali_cable_override(struct pci_dev *pdev)
 }
 
 /**
- *	ata66_ali15x3	-	check for UDMA 66 support
+ *	ali_cable_detect	-	cable detection
  *	@hwif: IDE interface
  *
  *	This checks if the controller and the cable are capable
@@ -620,7 +620,7 @@ static int ali_cable_override(struct pci_dev *pdev)
  *	FIXME: frobs bits that are not defined on newer ALi devicea
  */
 
-static u8 __devinit ata66_ali15x3(ide_hwif_t *hwif)
+static u8 __devinit ali_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long flags;
@@ -652,27 +652,7 @@ static u8 __devinit ata66_ali15x3(ide_hwif_t *hwif)
 	return cbl;
 }
 
-/**
- *	init_hwif_common_ali15x3	-	Set up ALI IDE hardware
- *	@hwif: IDE interface
- *
- *	Initialize the IDE structure side of the ALi 15x3 driver.
- */
- 
-static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
-{
-	hwif->set_pio_mode = &ali_set_pio_mode;
-	hwif->set_dma_mode = &ali_set_dma_mode;
-	hwif->udma_filter = &ali_udma_filter;
-
-	hwif->cable_detect = ata66_ali15x3;
-
-	if (hwif->dma_base == 0)
-		return;
-
-	hwif->dma_setup = &ali15x3_dma_setup;
-}
-
+#ifndef CONFIG_SPARC64
 /**
  *	init_hwif_ali15x3	-	Initialize the ALI IDE x86 stuff
  *	@hwif: interface to configure
@@ -722,34 +702,66 @@ static void __devinit init_hwif_ali15x3 (ide_hwif_t *hwif)
 		if(irq >= 0)
 			hwif->irq = irq;
 	}
-
-	init_hwif_common_ali15x3(hwif);
 }
+#endif
 
 /**
  *	init_dma_ali15x3	-	set up DMA on ALi15x3
  *	@hwif: IDE interface
- *	@dmabase: DMA interface base PCI address
+ *	@d: IDE port info
  *
- *	Set up the DMA functionality on the ALi 15x3. For the ALi
- *	controllers this is generic so we can let the generic code do
- *	the actual work.
+ *	Set up the DMA functionality on the ALi 15x3.
  */
 
-static void __devinit init_dma_ali15x3 (ide_hwif_t *hwif, unsigned long dmabase)
+static int __devinit init_dma_ali15x3(ide_hwif_t *hwif,
+				      const struct ide_port_info *d)
 {
-	if (m5229_revision < 0x20)
-		return;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	unsigned long base = ide_pci_dma_base(hwif, d);
+
+	if (base == 0 || ide_pci_set_master(dev, d->name) < 0)
+		return -1;
+
 	if (!hwif->channel)
-		outb(inb(dmabase + 2) & 0x60, dmabase + 2);
-	ide_setup_dma(hwif, dmabase);
+		outb(inb(base + 2) & 0x60, base + 2);
+
+	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
+			 hwif->name, base, base + 7);
+
+	if (ide_allocate_dma_engine(hwif))
+		return -1;
+
+	ide_setup_dma(hwif, base);
+
+	return 0;
 }
 
+static const struct ide_port_ops ali_port_ops = {
+	.set_pio_mode		= ali_set_pio_mode,
+	.set_dma_mode		= ali_set_dma_mode,
+	.udma_filter		= ali_udma_filter,
+	.cable_detect		= ali_cable_detect,
+};
+
+static const struct ide_dma_ops ali_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ali15x3_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= __ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
+
 static const struct ide_port_info ali15x3_chipset __devinitdata = {
 	.name		= "ALI15X3",
 	.init_chipset	= init_chipset_ali15x3,
+#ifndef CONFIG_SPARC64
 	.init_hwif	= init_hwif_ali15x3,
+#endif
 	.init_dma	= init_dma_ali15x3,
+	.port_ops	= &ali_port_ops,
 	.pio_mask	= ATA_PIO5,
 	.swdma_mask	= ATA_SWDMA2,
 	.mwdma_mask	= ATA_MWDMA2,
@@ -792,14 +804,17 @@ static int __devinit alim15x3_init_one(struct pci_dev *dev, const struct pci_dev
 			d.udma_mask = ATA_UDMA5;
 		else
 			d.udma_mask = ATA_UDMA6;
+
+		d.dma_ops = &ali_dma_ops;
+	} else {
+		d.host_flags |= IDE_HFLAG_NO_DMA;
+
+		d.mwdma_mask = d.swdma_mask = 0;
 	}
 
 	if (idx == 0)
 		d.host_flags |= IDE_HFLAG_CLEAR_SIMPLEX;
 
-#if defined(CONFIG_SPARC64)
-	d.init_hwif = init_hwif_common_ali15x3;
-#endif /* CONFIG_SPARC64 */
 	return ide_setup_pci_device(dev, &d);
 }
 
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index ff684d3..f7c8838 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -210,13 +210,14 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 
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
@@ -230,6 +231,7 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 		.init_chipset	= init_chipset_amd74xx,			\
 		.init_hwif	= init_hwif_amd74xx,			\
 		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},	\
+		.port_ops	= &amd_port_ops,			\
 		.host_flags	= IDE_HFLAGS_AMD,			\
 		.pio_mask	= ATA_PIO5,				\
 		.swdma_mask	= swdma,				\
@@ -243,6 +245,7 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 		.init_chipset	= init_chipset_amd74xx,			\
 		.init_hwif	= init_hwif_amd74xx,			\
 		.enablebits	= {{0x50,0x02,0x02}, {0x50,0x01,0x01}},	\
+		.port_ops	= &amd_port_ops,			\
 		.host_flags	= IDE_HFLAGS_AMD,			\
 		.pio_mask	= ATA_PIO5,				\
 		.swdma_mask	= ATA_SWDMA2,				\
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index 91722f8..8b63718 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -130,35 +130,25 @@ static u8 __devinit atiixp_cable_detect(ide_hwif_t *hwif)
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
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index b076dbf..25c2f1b 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -109,6 +109,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "cmd640"
+
 /*
  * This flag is set in ide.c by the parameter:  ide0=cmd640_vlb
  */
@@ -633,6 +635,9 @@ static void cmd640_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	display_clocks(index);
 }
 
+static const struct ide_port_ops cmd640_port_ops = {
+	.set_pio_mode		= cmd640_set_pio_mode,
+};
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
 static int pci_conf1(void)
@@ -678,10 +683,29 @@ static const struct ide_port_info cmd640_port_info __initdata = {
 				  IDE_HFLAG_ABUSE_PREFETCH |
 				  IDE_HFLAG_ABUSE_FAST_DEVSEL,
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
+	.port_ops		= &cmd640_port_ops,
 	.pio_mask		= ATA_PIO5,
 #endif
 };
 
+static int cmd640x_init_one(unsigned long base, unsigned long ctl)
+{
+	if (!request_region(base, 8, DRV_NAME)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
+				DRV_NAME, base, base + 7);
+		return -EBUSY;
+	}
+
+	if (!request_region(ctl, 1, DRV_NAME)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
+				DRV_NAME, ctl);
+		release_region(base, 8);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
 /*
  * Probe for a cmd640 chipset, and initialize it if found.
  */
@@ -690,7 +714,7 @@ static int __init cmd640x_init(void)
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 	int second_port_toggled = 0;
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
-	int second_port_cmd640 = 0;
+	int second_port_cmd640 = 0, rc;
 	const char *bus_type, *port2;
 	unsigned int index;
 	u8 b, cfr;
@@ -734,6 +758,17 @@ static int __init cmd640x_init(void)
 		return 0;
 	}
 
+	rc = cmd640x_init_one(0x1f0, 0x3f6);
+	if (rc)
+		return rc;
+
+	rc = cmd640x_init_one(0x170, 0x376);
+	if (rc) {
+		release_region(0x3f6, 1);
+		release_region(0x1f0, 8);
+		return rc;
+	}
+
 	memset(&hw, 0, sizeof(hw));
 
 	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
@@ -752,10 +787,6 @@ static int __init cmd640x_init(void)
 	 */
 	if (cmd_hwif0) {
 		ide_init_port_hw(cmd_hwif0, &hw[0]);
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-		cmd_hwif0->set_pio_mode = &cmd640_set_pio_mode;
-#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
-
 		idx[0] = cmd_hwif0->index;
 	}
 
@@ -808,10 +839,6 @@ static int __init cmd640x_init(void)
 	 */
 	if (second_port_cmd640 && cmd_hwif1) {
 		ide_init_port_hw(cmd_hwif1, &hw[1]);
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-		cmd_hwif1->set_pio_mode = &cmd640_set_pio_mode;
-#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
-
 		idx[1] = cmd_hwif1->index;
 	}
 	printk(KERN_INFO "cmd640: %sserialized, secondary interface %s\n",
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 8baccfe..006fb62 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -223,7 +223,7 @@ static void cmd64x_set_dma_mode(ide_drive_t *drive, const u8 speed)
 		(void) pci_write_config_byte(dev, pciU, regU);
 }
 
-static int cmd648_ide_dma_end (ide_drive_t *drive)
+static int cmd648_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long base	= hwif->dma_base - (hwif->channel * 8);
@@ -239,7 +239,7 @@ static int cmd648_ide_dma_end (ide_drive_t *drive)
 	return err;
 }
 
-static int cmd64x_ide_dma_end (ide_drive_t *drive)
+static int cmd64x_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
@@ -256,7 +256,7 @@ static int cmd64x_ide_dma_end (ide_drive_t *drive)
 	return err;
 }
 
-static int cmd648_ide_dma_test_irq (ide_drive_t *drive)
+static int cmd648_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long base	= hwif->dma_base - (hwif->channel * 8);
@@ -279,7 +279,7 @@ static int cmd648_ide_dma_test_irq (ide_drive_t *drive)
 	return 0;
 }
 
-static int cmd64x_ide_dma_test_irq (ide_drive_t *drive)
+static int cmd64x_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
@@ -310,7 +310,7 @@ static int cmd64x_ide_dma_test_irq (ide_drive_t *drive)
  * event order for DMA transfers.
  */
 
-static int cmd646_1_ide_dma_end (ide_drive_t *drive)
+static int cmd646_1_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	u8 dma_stat = 0, dma_cmd = 0;
@@ -370,7 +370,7 @@ static unsigned int __devinit init_chipset_cmd64x(struct pci_dev *dev, const cha
 	return 0;
 }
 
-static u8 __devinit ata66_cmd64x(ide_hwif_t *hwif)
+static u8 __devinit cmd64x_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev  *dev	= to_pci_dev(hwif->dev);
 	u8 bmidecsr = 0, mask	= hwif->channel ? 0x02 : 0x01;
@@ -385,60 +385,52 @@ static u8 __devinit ata66_cmd64x(ide_hwif_t *hwif)
 	}
 }
 
-static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-
-	hwif->set_pio_mode = &cmd64x_set_pio_mode;
-	hwif->set_dma_mode = &cmd64x_set_dma_mode;
-
-	hwif->cable_detect = ata66_cmd64x;
+static const struct ide_port_ops cmd64x_port_ops = {
+	.set_pio_mode		= cmd64x_set_pio_mode,
+	.set_dma_mode		= cmd64x_set_dma_mode,
+	.cable_detect		= cmd64x_cable_detect,
+};
 
-	if (!hwif->dma_base)
-		return;
+static const struct ide_dma_ops cmd64x_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= cmd64x_dma_end,
+	.dma_test_irq		= cmd64x_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
 
-	/*
-	 * UltraDMA only supported on PCI646U and PCI646U2, which
-	 * correspond to revisions 0x03, 0x05 and 0x07 respectively.
-	 * Actually, although the CMD tech support people won't
-	 * tell me the details, the 0x03 revision cannot support
-	 * UDMA correctly without hardware modifications, and even
-	 * then it only works with Quantum disks due to some
-	 * hold time assumptions in the 646U part which are fixed
-	 * in the 646U2.
-	 *
-	 * So we only do UltraDMA on revision 0x05 and 0x07 chipsets.
-	 */
-	if (dev->device == PCI_DEVICE_ID_CMD_646 && dev->revision < 5)
-		hwif->ultra_mask = 0x00;
+static const struct ide_dma_ops cmd646_rev1_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= cmd646_1_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
 
-	switch (dev->device) {
-	case PCI_DEVICE_ID_CMD_648:
-	case PCI_DEVICE_ID_CMD_649:
-	alt_irq_bits:
-		hwif->ide_dma_end	= &cmd648_ide_dma_end;
-		hwif->ide_dma_test_irq	= &cmd648_ide_dma_test_irq;
-		break;
-	case PCI_DEVICE_ID_CMD_646:
-		if (dev->revision == 0x01) {
-			hwif->ide_dma_end = &cmd646_1_ide_dma_end;
-			break;
-		} else if (dev->revision >= 0x03)
-			goto alt_irq_bits;
-		/* fall thru */
-	default:
-		hwif->ide_dma_end	= &cmd64x_ide_dma_end;
-		hwif->ide_dma_test_irq	= &cmd64x_ide_dma_test_irq;
-		break;
-	}
-}
+static const struct ide_dma_ops cmd648_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= cmd648_dma_end,
+	.dma_test_irq		= cmd648_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
 
 static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "CMD643",
 		.init_chipset	= init_chipset_cmd64x,
-		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
+		.port_ops	= &cmd64x_port_ops,
+		.dma_ops	= &cmd64x_dma_ops,
 		.host_flags	= IDE_HFLAG_CLEAR_SIMPLEX |
 				  IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
@@ -447,9 +439,10 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 	},{	/* 1 */
 		.name		= "CMD646",
 		.init_chipset	= init_chipset_cmd64x,
-		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.chipset	= ide_cmd646,
+		.port_ops	= &cmd64x_port_ops,
+		.dma_ops	= &cmd648_dma_ops,
 		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -457,8 +450,9 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 	},{	/* 2 */
 		.name		= "CMD648",
 		.init_chipset	= init_chipset_cmd64x,
-		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
+		.port_ops	= &cmd64x_port_ops,
+		.dma_ops	= &cmd648_dma_ops,
 		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -466,8 +460,9 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 	},{	/* 3 */
 		.name		= "CMD649",
 		.init_chipset	= init_chipset_cmd64x,
-		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
+		.port_ops	= &cmd64x_port_ops,
+		.dma_ops	= &cmd648_dma_ops,
 		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -482,12 +477,35 @@ static int __devinit cmd64x_init_one(struct pci_dev *dev, const struct pci_devic
 
 	d = cmd64x_chipsets[idx];
 
-	/*
-	 * The original PCI0646 didn't have the primary channel enable bit,
-	 * it appeared starting with PCI0646U (i.e. revision ID 3).
-	 */
-	if (idx == 1 && dev->revision < 3)
-		d.enablebits[0].reg = 0;
+	if (idx == 1) {
+		/*
+		 * UltraDMA only supported on PCI646U and PCI646U2, which
+		 * correspond to revisions 0x03, 0x05 and 0x07 respectively.
+		 * Actually, although the CMD tech support people won't
+		 * tell me the details, the 0x03 revision cannot support
+		 * UDMA correctly without hardware modifications, and even
+		 * then it only works with Quantum disks due to some
+		 * hold time assumptions in the 646U part which are fixed
+		 * in the 646U2.
+		 *
+		 * So we only do UltraDMA on revision 0x05 and 0x07 chipsets.
+		 */
+		if (dev->revision < 5) {
+			d.udma_mask = 0x00;
+			/*
+			 * The original PCI0646 didn't have the primary
+			 * channel enable bit, it appeared starting with
+			 * PCI0646U (i.e. revision ID 3).
+			 */
+			if (dev->revision < 3) {
+				d.enablebits[0].reg = 0;
+				if (dev->revision == 1)
+					d.dma_ops = &cmd646_rev1_dma_ops;
+				else
+					d.dma_ops = &cmd64x_dma_ops;
+			}
+		}
+	}
 
 	return ide_setup_pci_device(dev, &d);
 }
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index 01b37ec..17669a4 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -103,21 +103,27 @@ static void cs5520_dma_host_set(ide_drive_t *drive, int on)
 	ide_dma_host_set(drive, on);
 }
 
-static void __devinit init_hwif_cs5520(ide_hwif_t *hwif)
-{
-	hwif->set_pio_mode = &cs5520_set_pio_mode;
-	hwif->set_dma_mode = &cs5520_set_dma_mode;
-
-	if (hwif->dma_base == 0)
-		return;
+static const struct ide_port_ops cs5520_port_ops = {
+	.set_pio_mode		= cs5520_set_pio_mode,
+	.set_dma_mode		= cs5520_set_dma_mode,
+};
 
-	hwif->dma_host_set = &cs5520_dma_host_set;
-}
+static const struct ide_dma_ops cs5520_dma_ops = {
+	.dma_host_set		= cs5520_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= __ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
 
 #define DECLARE_CS_DEV(name_str)				\
 	{							\
 		.name		= name_str,			\
-		.init_hwif	= init_hwif_cs5520,		\
+		.port_ops	= &cs5520_port_ops,		\
+		.dma_ops	= &cs5520_dma_ops,		\
 		.host_flags	= IDE_HFLAG_ISA_PORTS |		\
 				  IDE_HFLAG_CS5520 |		\
 				  IDE_HFLAG_VDMA |		\
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index 56a369c..f5534c1 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -228,26 +228,25 @@ static void __devinit init_hwif_cs5530 (ide_hwif_t *hwif)
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
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index c9685f2..99fe91a 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -166,25 +166,15 @@ static u8 __devinit cs5535_cable_detect(ide_hwif_t *hwif)
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
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index 08eab7e..e30eae5 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -382,15 +382,6 @@ static unsigned int __devinit init_chipset_cy82c693(struct pci_dev *dev, const c
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
@@ -404,11 +395,16 @@ static void __devinit init_iops_cy82c693(ide_hwif_t *hwif)
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
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index 753b86f..c7b7e04 100644
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
@@ -89,8 +93,7 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 		ide_init_port_data(hwif, i);
 
 	ide_init_port_hw(hwif, &hw);
-	hwif->mmio = 1;
-	hwif->quirkproc = &ide_undecoded_slave;
+	hwif->port_ops = &delkin_cb_port_ops;
 
 	idx[0] = i;
 
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index 9f2fc30..84c36c1 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -115,11 +115,10 @@ static unsigned int __devinit init_chipset_hpt34x(struct pci_dev *dev, const cha
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
@@ -131,16 +130,14 @@ static const struct ide_port_info hpt34x_chipsets[] __devinitdata = {
 	{ /* 0 */
 		.name		= "HPT343",
 		.init_chipset	= init_chipset_hpt34x,
-		.init_hwif	= init_hwif_hpt34x,
-		.extra		= 16,
+		.port_ops	= &hpt34x_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_NON_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
 	},
 	{ /* 1 */
 		.name		= "HPT345",
 		.init_chipset	= init_chipset_hpt34x,
-		.init_hwif	= init_hwif_hpt34x,
-		.extra		= 16,
+		.port_ops	= &hpt34x_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO5,
 #ifdef CONFIG_HPT34X_AUTODMA
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index a490906..8c02961 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -776,7 +776,7 @@ static void hpt366_dma_lost_irq(ide_drive_t *drive)
 	pci_read_config_byte(dev, 0x52, &mcr3);
 	pci_read_config_byte(dev, 0x5a, &scr1);
 	printk("%s: (%s)  mcr1=0x%02x, mcr3=0x%02x, scr1=0x%02x\n",
-		drive->name, __FUNCTION__, mcr1, mcr3, scr1);
+		drive->name, __func__, mcr1, mcr3, scr1);
 	if (scr1 & 0x10)
 		pci_write_config_byte(dev, 0x5a, scr1 & ~0x10);
 	ide_dma_lost_irq(drive);
@@ -808,7 +808,7 @@ static void hpt370_irq_timeout(ide_drive_t *drive)
 	hpt370_clear_engine(drive);
 }
 
-static void hpt370_ide_dma_start(ide_drive_t *drive)
+static void hpt370_dma_start(ide_drive_t *drive)
 {
 #ifdef HPT_RESET_STATE_ENGINE
 	hpt370_clear_engine(drive);
@@ -816,7 +816,7 @@ static void hpt370_ide_dma_start(ide_drive_t *drive)
 	ide_dma_start(drive);
 }
 
-static int hpt370_ide_dma_end(ide_drive_t *drive)
+static int hpt370_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	u8  dma_stat		= inb(hwif->dma_status);
@@ -838,7 +838,7 @@ static void hpt370_dma_timeout(ide_drive_t *drive)
 }
 
 /* returns 1 if DMA IRQ issued, 0 otherwise */
-static int hpt374_ide_dma_test_irq(ide_drive_t *drive)
+static int hpt374_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
@@ -858,11 +858,11 @@ static int hpt374_ide_dma_test_irq(ide_drive_t *drive)
 
 	if (!drive->waiting_for_dma)
 		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
-				drive->name, __FUNCTION__);
+				drive->name, __func__);
 	return 0;
 }
 
-static int hpt374_ide_dma_end(ide_drive_t *drive)
+static int hpt374_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
@@ -1271,17 +1271,6 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
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
@@ -1323,29 +1312,19 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 
 	if (new_mcr != old_mcr)
 		pci_write_config_byte(dev, hwif->select_data + 1, new_mcr);
-
-	if (hwif->dma_base == 0)
-		return;
-
-	if (chip_type >= HPT374) {
-		hwif->ide_dma_test_irq	= &hpt374_ide_dma_test_irq;
-		hwif->ide_dma_end	= &hpt374_ide_dma_end;
-	} else if (chip_type >= HPT370) {
-		hwif->dma_start 	= &hpt370_ide_dma_start;
-		hwif->ide_dma_end	= &hpt370_ide_dma_end;
-		hwif->dma_timeout	= &hpt370_dma_timeout;
-	} else
-		hwif->dma_lost_irq	= &hpt366_dma_lost_irq;
 }
 
-static void __devinit init_dma_hpt366(ide_hwif_t *hwif, unsigned long dmabase)
+static int __devinit init_dma_hpt366(ide_hwif_t *hwif,
+				     const struct ide_port_info *d)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u8 masterdma	= 0, slavedma	= 0;
-	u8 dma_new	= 0, dma_old	= 0;
-	unsigned long flags;
+	unsigned long flags, base = ide_pci_dma_base(hwif, d);
+	u8 dma_old, dma_new, masterdma = 0, slavedma = 0;
 
-	dma_old = inb(dmabase + 2);
+	if (base == 0 || ide_pci_set_master(dev, d->name) < 0)
+		return -1;
+
+	dma_old = inb(base + 2);
 
 	local_irq_save(flags);
 
@@ -1356,11 +1335,21 @@ static void __devinit init_dma_hpt366(ide_hwif_t *hwif, unsigned long dmabase)
 	if (masterdma & 0x30)	dma_new |= 0x20;
 	if ( slavedma & 0x30)	dma_new |= 0x40;
 	if (dma_new != dma_old)
-		outb(dma_new, dmabase + 2);
+		outb(dma_new, base + 2);
 
 	local_irq_restore(flags);
 
-	ide_setup_dma(hwif, dmabase);
+	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
+			 hwif->name, base, base + 7);
+
+	hwif->extra_base = base + (hwif->channel ? 8 : 16);
+
+	if (ide_allocate_dma_engine(hwif))
+		return -1;
+
+	ide_setup_dma(hwif, base);
+
+	return 0;
 }
 
 static void __devinit hpt374_init(struct pci_dev *dev, struct pci_dev *dev2)
@@ -1416,6 +1405,49 @@ static int __devinit hpt36x_init(struct pci_dev *dev, struct pci_dev *dev2)
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
+static const struct ide_dma_ops hpt37x_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= hpt374_dma_end,
+	.dma_test_irq		= hpt374_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
+
+static const struct ide_dma_ops hpt370_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= hpt370_dma_start,
+	.dma_end		= hpt370_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= hpt370_dma_timeout,
+};
+
+static const struct ide_dma_ops hpt36x_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= __ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= hpt366_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
+
 static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "HPT36x",
@@ -1429,7 +1461,8 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 		 * Bit 4 is for the primary channel, bit 5 for the secondary.
 		 */
 		.enablebits	= {{0x50,0x10,0x10}, {0x54,0x04,0x04}},
-		.extra		= 240,
+		.port_ops	= &hpt3xx_port_ops,
+		.dma_ops	= &hpt36x_dma_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1439,7 +1472,8 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.extra		= 240,
+		.port_ops	= &hpt3xx_port_ops,
+		.dma_ops	= &hpt37x_dma_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1449,7 +1483,8 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.extra		= 240,
+		.port_ops	= &hpt3xx_port_ops,
+		.dma_ops	= &hpt37x_dma_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1459,7 +1494,8 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.extra		= 240,
+		.port_ops	= &hpt3xx_port_ops,
+		.dma_ops	= &hpt37x_dma_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1470,7 +1506,8 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.udma_mask	= ATA_UDMA5,
-		.extra		= 240,
+		.port_ops	= &hpt3xx_port_ops,
+		.dma_ops	= &hpt37x_dma_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1480,7 +1517,8 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.extra		= 240,
+		.port_ops	= &hpt3xx_port_ops,
+		.dma_ops	= &hpt37x_dma_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1543,6 +1581,10 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 	d.name = info->chip_name;
 	d.udma_mask = info->udma_mask;
 
+	/* fixup ->dma_ops for HPT370/HPT370A */
+	if (info == &hpt370 || info == &hpt370a)
+		d.dma_ops = &hpt370_dma_ops;
+
 	pci_set_drvdata(dev, (void *)info);
 
 	if (info == &hpt36x || info == &hpt374)
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index 5b5b0cc..9053c87 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -149,27 +149,17 @@ static u8 __devinit it8213_cable_detect(ide_hwif_t *hwif)
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
 		.enablebits	= { {0x41, 0x80, 0x80} }, \
+		.port_ops	= &it8213_port_ops,	\
 		.host_flags	= IDE_HFLAG_SINGLE,	\
 		.pio_mask	= ATA_PIO4,		\
 		.swdma_mask	= ATA_SWDMA2_ONLY,	\
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index a38ec47..6ab0411 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -418,7 +418,7 @@ static void it821x_set_dma_mode(ide_drive_t *drive, const u8 speed)
 }
 
 /**
- *	ata66_it821x	-	check for 80 pin cable
+ *	it821x_cable_detect	-	cable detection
  *	@hwif: interface to check
  *
  *	Check for the presence of an ATA66 capable cable on the
@@ -426,7 +426,7 @@ static void it821x_set_dma_mode(ide_drive_t *drive, const u8 speed)
  *	the needed logic onboard.
  */
 
-static u8 __devinit ata66_it821x(ide_hwif_t *hwif)
+static u8 __devinit it821x_cable_detect(ide_hwif_t *hwif)
 {
 	/* The reference driver also only does disk side */
 	return ATA_CBL_PATA80;
@@ -511,6 +511,11 @@ static void __devinit it821x_quirkproc(ide_drive_t *drive)
 
 }
 
+static struct ide_dma_ops it821x_pass_through_dma_ops = {
+	.dma_start		= it821x_dma_start,
+	.dma_end		= it821x_dma_end,
+};
+
 /**
  *	init_hwif_it821x	-	set up hwif structs
  *	@hwif: interface to set up
@@ -527,8 +532,6 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 	struct it821x_dev *idev = itdevs[hwif->channel];
 	u8 conf;
 
-	hwif->quirkproc = &it821x_quirkproc;
-
 	ide_set_hwifdata(hwif, idev);
 
 	pci_read_config_byte(dev, 0x50, &conf);
@@ -563,17 +566,11 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 	}
 
 	if (idev->smart == 0) {
-		hwif->set_pio_mode = &it821x_set_pio_mode;
-		hwif->set_dma_mode = &it821x_set_dma_mode;
-
 		/* MWDMA/PIO clock switching for pass through mode */
-		hwif->dma_start = &it821x_dma_start;
-		hwif->ide_dma_end = &it821x_dma_end;
+		hwif->dma_ops = &it821x_pass_through_dma_ops;
 	} else
 		hwif->host_flags |= IDE_HFLAG_NO_SET_MODE;
 
-	hwif->cable_detect = ata66_it821x;
-
 	if (hwif->dma_base == 0)
 		return;
 
@@ -613,12 +610,20 @@ static unsigned int __devinit init_chipset_it821x(struct pci_dev *dev, const cha
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
 
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index 673f7dc..96ef739 100644
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
 
@@ -95,25 +95,16 @@ static void jmicron_set_dma_mode(ide_drive_t *drive, const u8 mode)
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
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index 3015d69..e1b0c9a 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -150,7 +150,7 @@ static void ns87415_selectproc (ide_drive_t *drive)
 	ns87415_prepare_drive (drive, drive->using_dma);
 }
 
-static int ns87415_ide_dma_end (ide_drive_t *drive)
+static int ns87415_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t      *hwif = HWIF(drive);
 	u8 dma_stat = 0, dma_cmd = 0;
@@ -170,7 +170,7 @@ static int ns87415_ide_dma_end (ide_drive_t *drive)
 	return (dma_stat & 7) != 4;
 }
 
-static int ns87415_ide_dma_setup(ide_drive_t *drive)
+static int ns87415_dma_setup(ide_drive_t *drive)
 {
 	/* select DMA xfer */
 	ns87415_prepare_drive(drive, 1);
@@ -195,8 +195,6 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 	u8 stat;
 #endif
 
-	hwif->selectproc = &ns87415_selectproc;
-
 	/*
 	 * We cannot probe for IRQ: both ports share common IRQ on INTA.
 	 * Also, leave IRQ masked during drive probing, to prevent infinite
@@ -254,16 +252,31 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 		return;
 
 	outb(0x60, hwif->dma_status);
-	hwif->dma_setup = &ns87415_ide_dma_setup;
-	hwif->ide_dma_end = &ns87415_ide_dma_end;
 }
 
+static const struct ide_port_ops ns87415_port_ops = {
+	.selectproc		= ns87415_selectproc,
+};
+
+static const struct ide_dma_ops ns87415_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ns87415_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= ns87415_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
+
 static const struct ide_port_info ns87415_chipset __devinitdata = {
 	.name		= "NS87415",
 #ifdef CONFIG_SUPERIO
 	.init_iops	= init_iops_ns87415,
 #endif
 	.init_hwif	= init_hwif_ns87415,
+	.port_ops	= &ns87415_port_ops,
+	.dma_ops	= &ns87415_dma_ops,
 	.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 			  IDE_HFLAG_NO_ATAPI_DMA,
 };
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index 88a4dd9..9edacba 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -326,28 +326,24 @@ static void __devinit opti621_port_init_devs(ide_hwif_t *hwif)
 	hwif->drives[1].drive_data = PIO_DONT_KNOW;
 }
 
-/*
- * init_hwif_opti621() is called once for each hwif found at boot.
- */
-static void __devinit init_hwif_opti621(ide_hwif_t *hwif)
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
 		.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
+		.port_ops	= &opti621_port_ops,
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 		.pio_mask	= ATA_PIO3,
 		.swdma_mask	= ATA_SWDMA2,
 		.mwdma_mask	= ATA_MWDMA2,
 	}, {	/* 1 */
 		.name		= "OPTI621X",
-		.init_hwif	= init_hwif_opti621,
 		.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
+		.port_ops	= &opti621_port_ops,
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 		.pio_mask	= ATA_PIO3,
 		.swdma_mask	= ATA_SWDMA2,
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 1c8cb77..ec9bd7b 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -34,7 +34,7 @@
 #undef DEBUG
 
 #ifdef DEBUG
-#define DBG(fmt, args...) printk("%s: " fmt, __FUNCTION__, ## args)
+#define DBG(fmt, args...) printk("%s: " fmt, __func__, ## args)
 #else
 #define DBG(fmt, args...)
 #endif
@@ -442,17 +442,6 @@ static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev, const cha
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
@@ -476,11 +465,19 @@ static struct pci_dev * __devinit pdc20270_get_dev2(struct pci_dev *dev)
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
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index 150422e..fca89ed 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -115,7 +115,7 @@ static void pdc202xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	pdc202xx_set_mode(drive, XFER_PIO_0 + pio);
 }
 
-static u8 __devinit pdc2026x_old_cable_detect(ide_hwif_t *hwif)
+static u8 __devinit pdc2026x_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u16 CIS, mask = hwif->channel ? (1 << 11) : (1 << 10);
@@ -163,7 +163,7 @@ static void pdc202xx_quirkproc(ide_drive_t *drive)
 	drive->quirk_list = 0;
 }
 
-static void pdc202xx_old_ide_dma_start(ide_drive_t *drive)
+static void pdc202xx_dma_start(ide_drive_t *drive)
 {
 	if (drive->current_speed > XFER_UDMA_2)
 		pdc_old_enable_66MHz_clock(drive->hwif);
@@ -185,7 +185,7 @@ static void pdc202xx_old_ide_dma_start(ide_drive_t *drive)
 	ide_dma_start(drive);
 }
 
-static int pdc202xx_old_ide_dma_end(ide_drive_t *drive)
+static int pdc202xx_dma_end(ide_drive_t *drive)
 {
 	if (drive->media != ide_disk || drive->addressing == 1) {
 		ide_hwif_t *hwif	= HWIF(drive);
@@ -202,7 +202,7 @@ static int pdc202xx_old_ide_dma_end(ide_drive_t *drive)
 	return __ide_dma_end(drive);
 }
 
-static int pdc202xx_old_ide_dma_test_irq(ide_drive_t *drive)
+static int pdc202xx_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long high_16	= hwif->extra_base - 16;
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
@@ -271,68 +251,46 @@ static void pdc202xx_reset (ide_drive_t *drive)
 	ide_set_max_pio(drive);
 }
 
-static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev,
-							const char *name)
+static void pdc202xx_dma_lost_irq(ide_drive_t *drive)
 {
-	return dev->irq;
+	pdc202xx_reset(drive);
+	ide_dma_lost_irq(drive);
 }
 
-static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
+static void pdc202xx_dma_timeout(ide_drive_t *drive)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-
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
-	if (hwif->dma_base == 0)
-		return;
-
-	hwif->dma_lost_irq = &pdc202xx_dma_lost_irq;
-	hwif->dma_timeout = &pdc202xx_dma_timeout;
-
-	if (dev->device != PCI_DEVICE_ID_PROMISE_20246) {
-		hwif->dma_start = &pdc202xx_old_ide_dma_start;
-		hwif->ide_dma_end = &pdc202xx_old_ide_dma_end;
-	} 
-	hwif->ide_dma_test_irq = &pdc202xx_old_ide_dma_test_irq;
+	pdc202xx_reset(drive);
+	ide_dma_timeout(drive);
 }
 
-static void __devinit init_dma_pdc202xx(ide_hwif_t *hwif, unsigned long dmabase)
+static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev,
+						    const char *name)
 {
+	unsigned long dmabase = pci_resource_start(dev, 4);
 	u8 udma_speed_flag = 0, primary_mode = 0, secondary_mode = 0;
 
-	if (hwif->channel) {
-		ide_setup_dma(hwif, dmabase);
-		return;
-	}
+	if (dmabase == 0)
+		goto out;
 
 	udma_speed_flag	= inb(dmabase | 0x1f);
 	primary_mode	= inb(dmabase | 0x1a);
 	secondary_mode	= inb(dmabase | 0x1b);
 	printk(KERN_INFO "%s: (U)DMA Burst Bit %sABLED " \
 		"Primary %s Mode " \
-		"Secondary %s Mode.\n", hwif->cds->name,
+		"Secondary %s Mode.\n", pci_name(dev),
 		(udma_speed_flag & 1) ? "EN" : "DIS",
 		(primary_mode & 1) ? "MASTER" : "PCI",
 		(secondary_mode & 1) ? "MASTER" : "PCI" );
 
 	if (!(udma_speed_flag & 1)) {
 		printk(KERN_INFO "%s: FORCING BURST BIT 0x%02x->0x%02x ",
-			hwif->cds->name, udma_speed_flag,
+			pci_name(dev), udma_speed_flag,
 			(udma_speed_flag|1));
 		outb(udma_speed_flag | 1, dmabase | 0x1f);
 		printk("%sACTIVE\n", (inb(dmabase | 0x1f) & 1) ? "" : "IN");
 	}
-
-	ide_setup_dma(hwif, dmabase);
+out:
+	return dev->irq;
 }
 
 static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
@@ -357,13 +315,48 @@ static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
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
+static const struct ide_dma_ops pdc20246_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= __ide_dma_end,
+	.dma_test_irq		= pdc202xx_dma_test_irq,
+	.dma_lost_irq		= pdc202xx_dma_lost_irq,
+	.dma_timeout		= pdc202xx_dma_timeout,
+};
+
+static const struct ide_dma_ops pdc2026x_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= pdc202xx_dma_start,
+	.dma_end		= pdc202xx_dma_end,
+	.dma_test_irq		= pdc202xx_dma_test_irq,
+	.dma_lost_irq		= pdc202xx_dma_lost_irq,
+	.dma_timeout		= pdc202xx_dma_timeout,
+};
+
 #define DECLARE_PDC2026X_DEV(name_str, udma, extra_flags) \
 	{ \
 		.name		= name_str, \
 		.init_chipset	= init_chipset_pdc202xx, \
-		.init_hwif	= init_hwif_pdc202xx, \
-		.init_dma	= init_dma_pdc202xx, \
-		.extra		= 48, \
+		.port_ops	= &pdc2026x_port_ops, \
+		.dma_ops	= &pdc2026x_dma_ops, \
 		.host_flags	= IDE_HFLAGS_PDC202XX | extra_flags, \
 		.pio_mask	= ATA_PIO4, \
 		.mwdma_mask	= ATA_MWDMA2, \
@@ -374,9 +367,8 @@ static const struct ide_port_info pdc202xx_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "PDC20246",
 		.init_chipset	= init_chipset_pdc202xx,
-		.init_hwif	= init_hwif_pdc202xx,
-		.init_dma	= init_dma_pdc202xx,
-		.extra		= 16,
+		.port_ops	= &pdc20246_port_ops,
+		.dma_ops	= &pdc20246_dma_ops,
 		.host_flags	= IDE_HFLAGS_PDC202XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 89d74ff..21c5dd2 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -285,11 +285,6 @@ static u8 __devinit piix_cable_detect(ide_hwif_t *hwif)
 
 static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 {
-	hwif->set_pio_mode = &piix_set_pio_mode;
-	hwif->set_dma_mode = &piix_set_dma_mode;
-
-	hwif->cable_detect = piix_cable_detect;
-
 	if (!hwif->dma_base)
 		return;
 
@@ -306,6 +301,12 @@ static void __devinit init_hwif_ich(ide_hwif_t *hwif)
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
@@ -317,6 +318,7 @@ static void __devinit init_hwif_ich(ide_hwif_t *hwif)
 		.name		= name_str,		\
 		.init_hwif	= init_hwif_piix,	\
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
+		.port_ops	= &piix_port_ops,	\
 		.host_flags	= IDE_HFLAGS_PIIX,	\
 		.pio_mask	= ATA_PIO4,		\
 		.swdma_mask	= ATA_SWDMA2_ONLY,	\
@@ -330,6 +332,7 @@ static void __devinit init_hwif_ich(ide_hwif_t *hwif)
 		.init_chipset	= init_chipset_ich, \
 		.init_hwif	= init_hwif_ich, \
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
+		.port_ops	= &piix_port_ops, \
 		.host_flags	= IDE_HFLAGS_PIIX, \
 		.pio_mask	= ATA_PIO4, \
 		.swdma_mask	= ATA_SWDMA2_ONLY, \
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index 44985c8..14c787b 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -165,7 +165,7 @@ static void sc1200_set_dma_mode(ide_drive_t *drive, const u8 mode)
  *
  *  returns 1 on error, 0 otherwise
  */
-static int sc1200_ide_dma_end (ide_drive_t *drive)
+static int sc1200_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	unsigned long dma_base = hwif->dma_base;
@@ -214,7 +214,7 @@ static void sc1200_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		printk("SC1200: %s: changing (U)DMA mode\n", drive->name);
 		ide_dma_off_quietly(drive);
 		if (ide_set_dma_mode(drive, mode) == 0 && drive->using_dma)
-			hwif->dma_host_set(drive, 1);
+			hwif->dma_ops->dma_host_set(drive, 1);
 		return;
 	}
 
@@ -286,25 +286,27 @@ static int sc1200_resume (struct pci_dev *dev)
 }
 #endif
 
-/*
- * This gets invoked by the IDE driver once for each channel,
- * and performs channel-specific pre-initialization before drive probing.
- */
-static void __devinit init_hwif_sc1200 (ide_hwif_t *hwif)
-{
-	hwif->set_pio_mode = &sc1200_set_pio_mode;
-	hwif->set_dma_mode = &sc1200_set_dma_mode;
-
-	if (hwif->dma_base == 0)
-		return;
+static const struct ide_port_ops sc1200_port_ops = {
+	.set_pio_mode		= sc1200_set_pio_mode,
+	.set_dma_mode		= sc1200_set_dma_mode,
+	.udma_filter		= sc1200_udma_filter,
+};
 
-	hwif->udma_filter = sc1200_udma_filter;
-	hwif->ide_dma_end   = &sc1200_ide_dma_end;
-}
+static const struct ide_dma_ops sc1200_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= sc1200_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
 
 static const struct ide_port_info sc1200_chipset __devinitdata = {
 	.name		= "SC1200",
-	.init_hwif	= init_hwif_sc1200,
+	.port_ops	= &sc1200_port_ops,
+	.dma_ops	= &sc1200_dma_ops,
 	.host_flags	= IDE_HFLAG_SERIALIZE |
 			  IDE_HFLAG_POST_SET_MODE |
 			  IDE_HFLAG_ABUSE_DMA_MODES,
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 5214579..17cf864 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -317,14 +317,14 @@ static int scc_dma_setup(ide_drive_t *drive)
 
 
 /**
- *	scc_ide_dma_end	-	Stop DMA
+ *	scc_dma_end	-	Stop DMA
  *	@drive: IDE drive
  *
  *	Check and clear INT Status register.
  *      Then call __ide_dma_end().
  */
 
-static int scc_ide_dma_end(ide_drive_t * drive)
+static int scc_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	unsigned long intsts_port = hwif->dma_base + 0x014;
@@ -449,7 +449,7 @@ static int scc_dma_test_irq(ide_drive_t *drive)
 
 	if (!drive->waiting_for_dma)
 		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
-			drive->name, __FUNCTION__);
+			drive->name, __func__);
 	return 0;
 }
 
@@ -483,7 +483,7 @@ static int setup_mmio_scc (struct pci_dev *dev, const char *name)
 	unsigned long dma_size = pci_resource_len(dev, 1);
 	void __iomem *ctl_addr;
 	void __iomem *dma_addr;
-	int i;
+	int i, ret;
 
 	for (i = 0; i < MAX_HWIFS; i++) {
 		if (scc_ports[i].ctl == 0)
@@ -492,21 +492,17 @@ static int setup_mmio_scc (struct pci_dev *dev, const char *name)
 	if (i >= MAX_HWIFS)
 		return -ENOMEM;
 
-	if (!request_mem_region(ctl_base, ctl_size, name)) {
-		printk(KERN_WARNING "%s: IDE controller MMIO ports not available.\n", SCC_PATA_NAME);
-		goto fail_0;
-	}
-
-	if (!request_mem_region(dma_base, dma_size, name)) {
-		printk(KERN_WARNING "%s: IDE controller MMIO ports not available.\n", SCC_PATA_NAME);
-		goto fail_1;
+	ret = pci_request_selected_regions(dev, (1 << 2) - 1, name);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: can't reserve resources\n", name);
+		return ret;
 	}
 
 	if ((ctl_addr = ioremap(ctl_base, ctl_size)) == NULL)
-		goto fail_2;
+		goto fail_0;
 
 	if ((dma_addr = ioremap(dma_base, dma_size)) == NULL)
-		goto fail_3;
+		goto fail_1;
 
 	pci_set_master(dev);
 	scc_ports[i].ctl = (unsigned long)ctl_addr;
@@ -515,12 +511,8 @@ static int setup_mmio_scc (struct pci_dev *dev, const char *name)
 
 	return 1;
 
- fail_3:
-	iounmap(ctl_addr);
- fail_2:
-	release_mem_region(dma_base, dma_size);
  fail_1:
-	release_mem_region(ctl_base, ctl_size);
+	iounmap(ctl_addr);
  fail_0:
 	return -ENOMEM;
 }
@@ -549,7 +541,6 @@ static int scc_ide_setup_pci_device(struct pci_dev *dev,
 	hw.chipset = ide_pci;
 	ide_init_port_hw(hwif, &hw);
 	hwif->dev = &dev->dev;
-	hwif->cds = d;
 
 	idx[0] = hwif->index;
 
@@ -701,26 +692,37 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 	/* PTERADD */
 	out_be32((void __iomem *)(hwif->dma_base + 0x018), hwif->dmatable_dma);
 
-	hwif->dma_setup = scc_dma_setup;
-	hwif->ide_dma_end = scc_ide_dma_end;
-	hwif->set_pio_mode = scc_set_pio_mode;
-	hwif->set_dma_mode = scc_set_dma_mode;
-	hwif->ide_dma_test_irq = scc_dma_test_irq;
-	hwif->udma_filter = scc_udma_filter;
-
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
+static const struct ide_dma_ops scc_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= scc_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= scc_dma_end,
+	.dma_test_irq		= scc_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
+
 #define DECLARE_SCC_DEV(name_str)			\
   {							\
       .name		= name_str,			\
       .init_iops	= init_iops_scc,		\
       .init_hwif	= init_hwif_scc,		\
+      .port_ops		= &scc_port_ops,		\
+      .dma_ops		= &scc_dma_ops,			\
       .host_flags	= IDE_HFLAG_SINGLE,		\
       .pio_mask		= ATA_PIO4,			\
   }
@@ -754,10 +756,6 @@ static void __devexit scc_remove(struct pci_dev *dev)
 {
 	struct scc_ports *ports = pci_get_drvdata(dev);
 	ide_hwif_t *hwif = ports->hwif;
-	unsigned long ctl_base = pci_resource_start(dev, 0);
-	unsigned long dma_base = pci_resource_start(dev, 1);
-	unsigned long ctl_size = pci_resource_len(dev, 0);
-	unsigned long dma_size = pci_resource_len(dev, 1);
 
 	if (hwif->dmatable_cpu) {
 		pci_free_consistent(dev, PRD_ENTRIES * PRD_BYTES,
@@ -770,8 +768,7 @@ static void __devexit scc_remove(struct pci_dev *dev)
 	hwif->chipset = ide_unknown;
 	iounmap((void*)ports->dma);
 	iounmap((void*)ports->ctl);
-	release_mem_region(dma_base, dma_size);
-	release_mem_region(ctl_base, ctl_size);
+	pci_release_selected_regions(dev, (1 << 2) - 1);
 	memset(ports, 0, sizeof(*ports));
 }
 
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index cfe9274..a1fb208 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -312,7 +312,7 @@ static u8 __devinit ata66_svwks_cobalt(ide_hwif_t *hwif)
 	return ATA_CBL_PATA40;
 }
 
-static u8 __devinit ata66_svwks(ide_hwif_t *hwif)
+static u8 __devinit svwks_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
@@ -336,17 +336,18 @@ static u8 __devinit ata66_svwks(ide_hwif_t *hwif)
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
@@ -356,7 +357,7 @@ static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "SvrWks OSB4",
 		.init_chipset	= init_chipset_svwks,
-		.init_hwif	= init_hwif_svwks,
+		.port_ops	= &osb4_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -364,7 +365,7 @@ static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 	},{	/* 1 */
 		.name		= "SvrWks CSB5",
 		.init_chipset	= init_chipset_svwks,
-		.init_hwif	= init_hwif_svwks,
+		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -372,7 +373,7 @@ static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 	},{	/* 2 */
 		.name		= "SvrWks CSB6",
 		.init_chipset	= init_chipset_svwks,
-		.init_hwif	= init_hwif_svwks,
+		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -380,7 +381,7 @@ static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 	},{	/* 3 */
 		.name		= "SvrWks CSB6",
 		.init_chipset	= init_chipset_svwks,
-		.init_hwif	= init_hwif_svwks,
+		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -388,7 +389,7 @@ static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 	},{	/* 4 */
 		.name		= "SvrWks HT1000",
 		.init_chipset	= init_chipset_svwks,
-		.init_hwif	= init_hwif_svwks,
+		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 6bd9523..321a4e2 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -170,10 +170,10 @@ sgiioc4_clearirq(ide_drive_t * drive)
 			printk(KERN_ERR
 			       "%s(%s) : PCI Bus Error when doing DMA:"
 				   " status-cmd reg is 0x%x\n",
-			       __FUNCTION__, drive->name, pci_stat_cmd_reg);
+			       __func__, drive->name, pci_stat_cmd_reg);
 			printk(KERN_ERR
 			       "%s(%s) : PCI Error Address is 0x%x%x\n",
-			       __FUNCTION__, drive->name,
+			       __func__, drive->name,
 			       pci_err_addr_high, pci_err_addr_low);
 			/* Clear the PCI Error indicator */
 			pci_write_config_dword(dev, PCI_COMMAND, 0x00000146);
@@ -188,7 +188,7 @@ sgiioc4_clearirq(ide_drive_t * drive)
 	return intr_reg & 3;
 }
 
-static void sgiioc4_ide_dma_start(ide_drive_t * drive)
+static void sgiioc4_dma_start(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	unsigned long ioc4_dma_addr = hwif->dma_base + IOC4_DMA_CTRL * 4;
@@ -215,8 +215,7 @@ sgiioc4_ide_dma_stop(ide_hwif_t *hwif, u64 dma_base)
 }
 
 /* Stops the IOC4 DMA Engine */
-static int
-sgiioc4_ide_dma_end(ide_drive_t * drive)
+static int sgiioc4_dma_end(ide_drive_t *drive)
 {
 	u32 ioc4_dma, bc_dev, bc_mem, num, valid = 0, cnt = 0;
 	ide_hwif_t *hwif = HWIF(drive);
@@ -232,7 +231,7 @@ sgiioc4_ide_dma_end(ide_drive_t * drive)
 		printk(KERN_ERR
 		       "%s(%s): IOC4 DMA STOP bit is still 1 :"
 		       "ioc4_dma_reg 0x%x\n",
-		       __FUNCTION__, drive->name, ioc4_dma);
+		       __func__, drive->name, ioc4_dma);
 		dma_stat = 1;
 	}
 
@@ -251,7 +250,7 @@ sgiioc4_ide_dma_end(ide_drive_t * drive)
 		udelay(1);
 	}
 	if (!valid) {
-		printk(KERN_ERR "%s(%s) : DMA incomplete\n", __FUNCTION__,
+		printk(KERN_ERR "%s(%s) : DMA incomplete\n", __func__,
 		       drive->name);
 		dma_stat = 1;
 	}
@@ -264,7 +263,7 @@ sgiioc4_ide_dma_end(ide_drive_t * drive)
 			printk(KERN_ERR
 			       "%s(%s): WARNING!! byte_count_dev %d "
 			       "!= byte_count_mem %d\n",
-			       __FUNCTION__, drive->name, bc_dev, bc_mem);
+			       __func__, drive->name, bc_dev, bc_mem);
 		}
 	}
 
@@ -279,8 +278,7 @@ static void sgiioc4_set_dma_mode(ide_drive_t *drive, const u8 speed)
 }
 
 /* returns 1 if dma irq issued, 0 otherwise */
-static int
-sgiioc4_ide_dma_test_irq(ide_drive_t * drive)
+static int sgiioc4_dma_test_irq(ide_drive_t *drive)
 {
 	return sgiioc4_checkirq(HWIF(drive));
 }
@@ -294,7 +292,7 @@ static void sgiioc4_dma_host_set(ide_drive_t *drive, int on)
 static void
 sgiioc4_resetproc(ide_drive_t * drive)
 {
-	sgiioc4_ide_dma_end(drive);
+	sgiioc4_dma_end(drive);
 	sgiioc4_clearirq(drive);
 }
 
@@ -329,13 +327,17 @@ sgiioc4_INB(unsigned long port)
 
 /* Creates a dma map for the scatter-gather list entries */
 static int __devinit
-ide_dma_sgiioc4(ide_hwif_t * hwif, unsigned long dma_base)
+ide_dma_sgiioc4(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	unsigned long dma_base = pci_resource_start(dev, 0) + IOC4_DMA_OFFSET;
 	void __iomem *virt_dma_base;
 	int num_ports = sizeof (ioc4_dma_regs_t);
 	void *pad;
 
+	if (dma_base == 0)
+		return -1;
+
 	printk(KERN_INFO "%s: BM-DMA at 0x%04lx-0x%04lx\n", hwif->name,
 	       dma_base, dma_base + num_ports - 1);
 
@@ -343,7 +345,7 @@ ide_dma_sgiioc4(ide_hwif_t * hwif, unsigned long dma_base)
 		printk(KERN_ERR
 		       "%s(%s) -- ERROR, Addresses 0x%p to 0x%p "
 		       "ALREADY in use\n",
-		       __FUNCTION__, hwif->name, (void *) dma_base,
+		       __func__, hwif->name, (void *) dma_base,
 		       (void *) dma_base + num_ports - 1);
 		return -1;
 	}
@@ -352,7 +354,7 @@ ide_dma_sgiioc4(ide_hwif_t * hwif, unsigned long dma_base)
 	if (virt_dma_base == NULL) {
 		printk(KERN_ERR
 		       "%s(%s) -- ERROR, Unable to map addresses 0x%lx to 0x%lx\n",
-		       __FUNCTION__, hwif->name, dma_base, dma_base + num_ports - 1);
+		       __func__, hwif->name, dma_base, dma_base + num_ports - 1);
 		goto dma_remap_failure;
 	}
 	hwif->dma_base = (unsigned long) virt_dma_base;
@@ -378,7 +380,7 @@ ide_dma_sgiioc4(ide_hwif_t * hwif, unsigned long dma_base)
 			    hwif->dmatable_cpu, hwif->dmatable_dma);
 	printk(KERN_INFO
 	       "%s() -- Error! Unable to allocate DMA Maps for drive %s\n",
-	       __FUNCTION__, hwif->name);
+	       __func__, hwif->name);
 	printk(KERN_INFO
 	       "Changing from DMA to PIO mode for Drive %s\n", hwif->name);
 
@@ -406,14 +408,14 @@ sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 	if (ioc4_dma & IOC4_S_DMA_ACTIVE) {
 		printk(KERN_WARNING
 			"%s(%s):Warning!! DMA from previous transfer was still active\n",
-		       __FUNCTION__, drive->name);
+		       __func__, drive->name);
 		writel(IOC4_S_DMA_STOP, (void __iomem *)ioc4_dma_addr);
 		ioc4_dma = sgiioc4_ide_dma_stop(hwif, dma_base);
 
 		if (ioc4_dma & IOC4_S_DMA_STOP)
 			printk(KERN_ERR
 			       "%s(%s) : IOC4 Dma STOP bit is still 1\n",
-			       __FUNCTION__, drive->name);
+			       __func__, drive->name);
 	}
 
 	ioc4_dma = readl((void __iomem *)ioc4_dma_addr);
@@ -421,14 +423,14 @@ sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 		printk(KERN_WARNING
 		       "%s(%s) : Warning!! - DMA Error during Previous"
 		       " transfer | status 0x%x\n",
-		       __FUNCTION__, drive->name, ioc4_dma);
+		       __func__, drive->name, ioc4_dma);
 		writel(IOC4_S_DMA_STOP, (void __iomem *)ioc4_dma_addr);
 		ioc4_dma = sgiioc4_ide_dma_stop(hwif, dma_base);
 
 		if (ioc4_dma & IOC4_S_DMA_STOP)
 			printk(KERN_ERR
 			       "%s(%s) : IOC4 DMA STOP bit is still 1\n",
-			       __FUNCTION__, drive->name);
+			       __func__, drive->name);
 	}
 
 	/* Address of the Scatter Gather List */
@@ -519,7 +521,7 @@ use_pio_instead:
 	return 0;		/* revert to PIO for this request */
 }
 
-static int sgiioc4_ide_dma_setup(ide_drive_t *drive)
+static int sgiioc4_dma_setup(ide_drive_t *drive)
 {
 	struct request *rq = HWGROUP(drive)->rq;
 	unsigned int count = 0;
@@ -548,45 +550,37 @@ static int sgiioc4_ide_dma_setup(ide_drive_t *drive)
 	return 0;
 }
 
-static void __devinit
-ide_init_sgiioc4(ide_hwif_t * hwif)
-{
-	hwif->mmio = 1;
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
-	hwif->INB = &sgiioc4_INB;
-
-	if (hwif->dma_base == 0)
-		return;
+static const struct ide_port_ops sgiioc4_port_ops = {
+	.set_dma_mode		= sgiioc4_set_dma_mode,
+	/* reset DMA engine, clear IRQs */
+	.resetproc		= sgiioc4_resetproc,
+	/* mask on/off NIEN register */
+	.maskproc		= sgiioc4_maskproc,
+};
 
-	hwif->dma_host_set = &sgiioc4_dma_host_set;
-	hwif->dma_setup = &sgiioc4_ide_dma_setup;
-	hwif->dma_start = &sgiioc4_ide_dma_start;
-	hwif->ide_dma_end = &sgiioc4_ide_dma_end;
-	hwif->ide_dma_test_irq = &sgiioc4_ide_dma_test_irq;
-	hwif->dma_lost_irq = &sgiioc4_dma_lost_irq;
-	hwif->dma_timeout = &ide_dma_timeout;
-}
+static const struct ide_dma_ops sgiioc4_dma_ops = {
+	.dma_host_set		= sgiioc4_dma_host_set,
+	.dma_setup		= sgiioc4_dma_setup,
+	.dma_start		= sgiioc4_dma_start,
+	.dma_end		= sgiioc4_dma_end,
+	.dma_test_irq		= sgiioc4_dma_test_irq,
+	.dma_lost_irq		= sgiioc4_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
 
 static const struct ide_port_info sgiioc4_port_info __devinitdata = {
 	.chipset		= ide_pci,
-	.host_flags		= IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
-				  IDE_HFLAG_NO_AUTOTUNE,
+	.init_dma		= ide_dma_sgiioc4,
+	.port_ops		= &sgiioc4_port_ops,
+	.dma_ops		= &sgiioc4_dma_ops,
+	.host_flags		= IDE_HFLAG_NO_AUTOTUNE,
 	.mwdma_mask		= ATA_MWDMA2_ONLY,
 };
 
 static int __devinit
 sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 {
-	unsigned long cmd_base, dma_base, irqport;
+	unsigned long cmd_base, irqport;
 	unsigned long bar0, cmd_phys_base, ctl;
 	void __iomem *virt_base;
 	ide_hwif_t *hwif;
@@ -612,7 +606,6 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	cmd_base = (unsigned long) virt_base + IOC4_CMD_OFFSET;
 	ctl = (unsigned long) virt_base + IOC4_CTRL_OFFSET;
 	irqport = (unsigned long) virt_base + IOC4_INTR_OFFSET;
-	dma_base = pci_resource_start(dev, 0) + IOC4_DMA_OFFSET;
 
 	cmd_phys_base = bar0 + IOC4_CMD_OFFSET;
 	if (!request_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE,
@@ -620,7 +613,7 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 		printk(KERN_ERR
 			"%s : %s -- ERROR, Addresses "
 			"0x%p to 0x%p ALREADY in use\n",
-		       __FUNCTION__, hwif->name, (void *) cmd_phys_base,
+		       __func__, hwif->name, (void *) cmd_phys_base,
 		       (void *) cmd_phys_base + IOC4_CMD_CTL_BLK_SIZE);
 		return -ENOMEM;
 	}
@@ -641,13 +634,7 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	/* Initializing chipset IRQ Registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
-	if (dma_base == 0 || ide_dma_sgiioc4(hwif, dma_base)) {
-		printk(KERN_INFO "%s: %s Bus-Master DMA disabled\n",
-				 hwif->name, DRV_NAME);
-		d.mwdma_mask = 0;
-	}
-
-	ide_init_sgiioc4(hwif);
+	hwif->INB = &sgiioc4_INB;
 
 	idx[0] = hwif->index;
 
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index c9ecab8..1fffea3 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -301,7 +301,7 @@ static void sil_set_dma_mode(ide_drive_t *drive, const u8 speed)
 }
 
 /* returns 1 if dma irq issued, 0 otherwise */
-static int siimage_io_ide_dma_test_irq (ide_drive_t *drive)
+static int siimage_io_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
@@ -320,14 +320,14 @@ static int siimage_io_ide_dma_test_irq (ide_drive_t *drive)
 }
 
 /**
- *	siimage_mmio_ide_dma_test_irq	-	check we caused an IRQ
+ *	siimage_mmio_dma_test_irq	-	check we caused an IRQ
  *	@drive: drive we are testing
  *
  *	Check if we caused an IDE DMA interrupt. We may also have caused
  *	SATA status interrupts, if so we clean them up and continue.
  */
- 
-static int siimage_mmio_ide_dma_test_irq (ide_drive_t *drive)
+
+static int siimage_mmio_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long addr	= siimage_selreg(hwif, 0x1);
@@ -347,7 +347,7 @@ static int siimage_mmio_ide_dma_test_irq (ide_drive_t *drive)
 			printk(KERN_WARNING "%s: sata_error = 0x%08x, "
 				"watchdog = %d, %s\n",
 				drive->name, sata_error, watchdog,
-				__FUNCTION__);
+				__func__);
 
 		} else {
 			watchdog = (ext_stat & 0x8000) ? 1 : 0;
@@ -369,6 +369,14 @@ static int siimage_mmio_ide_dma_test_irq (ide_drive_t *drive)
 	return 0;
 }
 
+static int siimage_dma_test_irq(ide_drive_t *drive)
+{
+	if (drive->hwif->mmio)
+		return siimage_mmio_dma_test_irq(drive);
+	else
+		return siimage_io_dma_test_irq(drive);
+}
+
 /**
  *	sil_sata_reset_poll	-	wait for SATA reset
  *	@drive: drive we are resetting
@@ -735,14 +743,14 @@ static void __devinit init_iops_siimage(ide_hwif_t *hwif)
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
@@ -756,67 +764,44 @@ static u8 __devinit ata66_siimage(ide_hwif_t *hwif)
 	return (ata66 & 0x01) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
-/**
- *	init_hwif_siimage	-	set up hwif structs
- *	@hwif: interface to set up
- *
- *	We do the basic set up of the interface structure. The SIIMAGE
- *	requires several custom handlers so we override the default
- *	ide DMA handlers appropriately
- */
-
-static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
-{
-	u8 sata = is_sata(hwif);
-
-	hwif->set_pio_mode = &sil_set_pio_mode;
-	hwif->set_dma_mode = &sil_set_dma_mode;
-	hwif->quirkproc = &sil_quirkproc;
-
-	if (sata) {
-		static int first = 1;
-
-		hwif->reset_poll = &sil_sata_reset_poll;
-		hwif->pre_reset = &sil_sata_pre_reset;
-		hwif->udma_filter = &sil_sata_udma_filter;
-
-		if (first) {
-			printk(KERN_INFO "siimage: For full SATA support you should use the libata sata_sil module.\n");
-			first = 0;
-		}
-	} else
-		hwif->udma_filter = &sil_pata_udma_filter;
-
-	hwif->cable_detect = ata66_siimage;
-
-	if (hwif->dma_base == 0)
-		return;
+static const struct ide_port_ops sil_pata_port_ops = {
+	.set_pio_mode		= sil_set_pio_mode,
+	.set_dma_mode		= sil_set_dma_mode,
+	.quirkproc		= sil_quirkproc,
+	.udma_filter		= sil_pata_udma_filter,
+	.cable_detect		= sil_cable_detect,
+};
 
-	if (sata)
-		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
+static const struct ide_port_ops sil_sata_port_ops = {
+	.set_pio_mode		= sil_set_pio_mode,
+	.set_dma_mode		= sil_set_dma_mode,
+	.reset_poll		= sil_sata_reset_poll,
+	.pre_reset		= sil_sata_pre_reset,
+	.quirkproc		= sil_quirkproc,
+	.udma_filter		= sil_sata_udma_filter,
+	.cable_detect		= sil_cable_detect,
+};
 
-	if (hwif->mmio) {
-		hwif->ide_dma_test_irq = &siimage_mmio_ide_dma_test_irq;
-	} else {
-		hwif->ide_dma_test_irq = & siimage_io_ide_dma_test_irq;
-	}
-}
+static struct ide_dma_ops sil_dma_ops = {
+	.dma_test_irq		= siimage_dma_test_irq,
+};
 
-#define DECLARE_SII_DEV(name_str)			\
+#define DECLARE_SII_DEV(name_str, p_ops)		\
 	{						\
 		.name		= name_str,		\
 		.init_chipset	= init_chipset_siimage,	\
 		.init_iops	= init_iops_siimage,	\
-		.init_hwif	= init_hwif_siimage,	\
+		.port_ops	= p_ops,		\
+		.dma_ops	= &sil_dma_ops,		\
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
@@ -830,7 +815,24 @@ static const struct ide_port_info siimage_chipsets[] __devinitdata = {
  
 static int __devinit siimage_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &siimage_chipsets[id->driver_data]);
+	struct ide_port_info d;
+	u8 idx = id->driver_data;
+
+	d = siimage_chipsets[idx];
+
+	if (idx) {
+		static int first = 1;
+
+		if (first) {
+			printk(KERN_INFO "siimage: For full SATA support you "
+				"should use the libata sata_sil module.\n");
+			first = 0;
+		}
+
+		d.host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
+	}
+
+	return ide_setup_pci_device(dev, &d);
 }
 
 static const struct pci_device_id siimage_pci_tbl[] = {
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 181b647..4b0b85d 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -347,7 +347,7 @@ static void sis_set_dma_mode(ide_drive_t *drive, const u8 speed)
 		sis_program_timings(drive, speed);
 }
 
-static u8 sis5513_ata133_udma_filter(ide_drive_t *drive)
+static u8 sis_ata133_udma_filter(ide_drive_t *drive)
 {
 	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	u32 regdw = 0;
@@ -514,7 +514,7 @@ static const struct sis_laptop sis_laptop[] = {
 	{ 0, }
 };
 
-static u8 __devinit ata66_sis5513(ide_hwif_t *hwif)
+static u8 __devinit sis_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	const struct sis_laptop *lap = &sis_laptop[0];
@@ -543,21 +543,22 @@ static u8 __devinit ata66_sis5513(ide_hwif_t *hwif)
 	return ata66 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
-static void __devinit init_hwif_sis5513(ide_hwif_t *hwif)
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
 	.enablebits	= { {0x4a, 0x02, 0x02}, {0x4a, 0x04, 0x04} },
 	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_NO_AUTODMA,
 	.pio_mask	= ATA_PIO4,
@@ -572,6 +573,11 @@ static int __devinit sis5513_init_one(struct pci_dev *dev, const struct pci_devi
 	if (sis_find_family(dev) == 0)
 		return -ENOTSUPP;
 
+	if (chipset_family >= ATA_133)
+		d.port_ops = &sis_ata133_port_ops;
+	else
+		d.port_ops = &sis_port_ops;
+
 	d.udma_mask = udma_rates[chipset_family];
 
 	return ide_setup_pci_device(dev, &d);
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index 40b3eeb..ce84fa0 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -179,7 +179,7 @@ static void sl82c105_dma_start(ide_drive_t *drive)
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int reg 		= 0x44 + drive->dn * 4;
 
-	DBG(("%s(drive:%s)\n", __FUNCTION__, drive->name));
+	DBG(("%s(drive:%s)\n", __func__, drive->name));
 
 	pci_write_config_word(dev, reg, drive->drive_data >> 16);
 
@@ -203,7 +203,7 @@ static int sl82c105_dma_end(ide_drive_t *drive)
 	int reg 		= 0x44 + drive->dn * 4;
 	int ret;
 
-	DBG(("%s(drive:%s)\n", __FUNCTION__, drive->name));
+	DBG(("%s(drive:%s)\n", __func__, drive->name));
 
 	ret = __ide_dma_end(drive);
 
@@ -232,7 +232,7 @@ static void sl82c105_resetproc(ide_drive_t *drive)
  * Return the revision of the Winbond bridge
  * which this function is part of.
  */
-static unsigned int sl82c105_bridge_revision(struct pci_dev *dev)
+static u8 sl82c105_bridge_revision(struct pci_dev *dev)
 {
 	struct pci_dev *bridge;
 
@@ -282,63 +282,59 @@ static unsigned int __devinit init_chipset_sl82c105(struct pci_dev *dev, const c
 	return dev->irq;
 }
 
-/*
- * Initialise IDE channel
- */
-static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	unsigned int rev;
-
-	DBG(("init_hwif_sl82c105(hwif: ide%d)\n", hwif->index));
-
-	hwif->set_pio_mode	= &sl82c105_set_pio_mode;
-	hwif->set_dma_mode	= &sl82c105_set_dma_mode;
-	hwif->resetproc 	= &sl82c105_resetproc;
-
-	if (!hwif->dma_base)
-		return;
-
-	rev = sl82c105_bridge_revision(dev);
-	if (rev <= 5) {
-		/*
-		 * Never ever EVER under any circumstances enable
-		 * DMA when the bridge is this old.
-		 */
-		printk("    %s: Winbond W83C553 bridge revision %d, "
-		       "BM-DMA disabled\n", hwif->name, rev);
-		return;
-	}
-
-	hwif->mwdma_mask = ATA_MWDMA2;
-
-	hwif->dma_lost_irq		= &sl82c105_dma_lost_irq;
-	hwif->dma_start			= &sl82c105_dma_start;
-	hwif->ide_dma_end		= &sl82c105_dma_end;
-	hwif->dma_timeout		= &sl82c105_dma_timeout;
+static const struct ide_port_ops sl82c105_port_ops = {
+	.set_pio_mode		= sl82c105_set_pio_mode,
+	.set_dma_mode		= sl82c105_set_dma_mode,
+	.resetproc		= sl82c105_resetproc,
+};
 
-	if (hwif->mate)
-		hwif->serialized = hwif->mate->serialized = 1;
-}
+static const struct ide_dma_ops sl82c105_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= sl82c105_dma_start,
+	.dma_end		= sl82c105_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= sl82c105_dma_lost_irq,
+	.dma_timeout		= sl82c105_dma_timeout,
+};
 
 static const struct ide_port_info sl82c105_chipset __devinitdata = {
 	.name		= "W82C105",
 	.init_chipset	= init_chipset_sl82c105,
-	.init_hwif	= init_hwif_sl82c105,
 	.enablebits	= {{0x40,0x01,0x01}, {0x40,0x10,0x10}},
+	.port_ops	= &sl82c105_port_ops,
+	.dma_ops	= &sl82c105_dma_ops,
 	.host_flags	= IDE_HFLAG_IO_32BIT |
 			  IDE_HFLAG_UNMASK_IRQS |
 /* FIXME: check for Compatibility mode in generic IDE PCI code */
 #if defined(CONFIG_LOPEC) || defined(CONFIG_SANDPOINT)
 			  IDE_HFLAG_FORCE_LEGACY_IRQS |
 #endif
+			  IDE_HFLAG_SERIALIZE_DMA |
 			  IDE_HFLAG_NO_AUTODMA,
 	.pio_mask	= ATA_PIO5,
+	.mwdma_mask	= ATA_MWDMA2,
 };
 
 static int __devinit sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &sl82c105_chipset);
+	struct ide_port_info d = sl82c105_chipset;
+	u8 rev = sl82c105_bridge_revision(dev);
+
+	if (rev <= 5) {
+		/*
+		 * Never ever EVER under any circumstances enable
+		 * DMA when the bridge is this old.
+		 */
+		printk(KERN_INFO "W82C105_IDE: Winbond W83C553 bridge "
+				 "revision %d, BM-DMA disabled\n", rev);
+		d.dma_ops = NULL;
+		d.mwdma_mask = 0;
+		d.host_flags &= ~IDE_HFLAG_SERIALIZE_DMA;
+	}
+
+	return ide_setup_pci_device(dev, &d);
 }
 
 static const struct pci_device_id sl82c105_pci_tbl[] = {
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index eab557c..dae6e2c 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -125,18 +125,16 @@ static u8 __devinit slc90e66_cable_detect(ide_hwif_t *hwif)
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
 	.enablebits	= { {0x41, 0x80, 0x80}, {0x43, 0x80, 0x80} },
+	.port_ops	= &slc90e66_port_ops,
 	.host_flags	= IDE_HFLAG_LEGACY_IRQS,
 	.pio_mask	= ATA_PIO4,
 	.swdma_mask	= ATA_SWDMA2_ONLY,
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index c154351..9b4b27a 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -157,11 +157,6 @@ static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 	/* Store the system control register base for convenience... */
 	hwif->config_data = sc_base;
 
-	hwif->set_pio_mode = &tc86c001_set_pio_mode;
-	hwif->set_dma_mode = &tc86c001_set_mode;
-
-	hwif->cable_detect = tc86c001_cable_detect;
-
 	if (!hwif->dma_base)
 		return;
 
@@ -173,8 +168,6 @@ static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 
 	/* Sector Count Register limit */
 	hwif->rqsize	 = 0xffff;
-
-	hwif->dma_start 	= &tc86c001_dma_start;
 }
 
 static unsigned int __devinit init_chipset_tc86c001(struct pci_dev *dev,
@@ -187,10 +180,29 @@ static unsigned int __devinit init_chipset_tc86c001(struct pci_dev *dev,
 	return err;
 }
 
+static const struct ide_port_ops tc86c001_port_ops = {
+	.set_pio_mode		= tc86c001_set_pio_mode,
+	.set_dma_mode		= tc86c001_set_mode,
+	.cable_detect		= tc86c001_cable_detect,
+};
+
+static const struct ide_dma_ops tc86c001_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= tc86c001_dma_start,
+	.dma_end		= __ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
+
 static const struct ide_port_info tc86c001_chipset __devinitdata = {
 	.name		= "TC86C001",
 	.init_chipset	= init_chipset_tc86c001,
 	.init_hwif	= init_hwif_tc86c001,
+	.port_ops	= &tc86c001_port_ops,
+	.dma_ops	= &tc86c001_dma_ops,
 	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_OFF_BOARD |
 			  IDE_HFLAG_ABUSE_SET_DMA_MODE,
 	.pio_mask	= ATA_PIO4,
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index 3316b19..db65a55 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -87,16 +87,15 @@ static void triflex_set_pio_mode(ide_drive_t *drive, const u8 pio)
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
diff --git a/drivers/ide/pci/trm290.c b/drivers/ide/pci/trm290.c
index 2b8f3a2..15ee38f 100644
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -214,7 +214,7 @@ static void trm290_dma_start(ide_drive_t *drive)
 {
 }
 
-static int trm290_ide_dma_end (ide_drive_t *drive)
+static int trm290_dma_end(ide_drive_t *drive)
 {
 	u16 status;
 
@@ -225,7 +225,7 @@ static int trm290_ide_dma_end (ide_drive_t *drive)
 	return status != 0x00ff;
 }
 
-static int trm290_ide_dma_test_irq (ide_drive_t *drive)
+static int trm290_dma_test_irq(ide_drive_t *drive)
 {
 	u16 status;
 
@@ -254,22 +254,11 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 	hwif->config_data = cfg_base;
 	hwif->dma_base = (cfg_base + 4) ^ (hwif->channel ? 0x80 : 0);
 
-	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx",
+	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
 	       hwif->name, hwif->dma_base, hwif->dma_base + 3);
 
-	if (!request_region(hwif->dma_base, 4, hwif->name)) {
-		printk(KERN_CONT " -- Error, ports in use.\n");
+	if (ide_allocate_dma_engine(hwif))
 		return;
-	}
-
-	hwif->dmatable_cpu = pci_alloc_consistent(dev, PRD_ENTRIES * PRD_BYTES,
-						  &hwif->dmatable_dma);
-	if (!hwif->dmatable_cpu) {
-		printk(KERN_CONT " -- Error, unable to allocate DMA table.\n");
-		release_region(hwif->dma_base, 4);
-		return;
-	}
-	printk(KERN_CONT "\n");
 
 	local_irq_save(flags);
 	/* put config reg into first byte of hwif->select_data */
@@ -291,14 +280,6 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 		/* sharing IRQ with mate */
 		hwif->irq = hwif->mate->irq;
 
-	hwif->dma_host_set	= &trm290_dma_host_set;
-	hwif->dma_setup 	= &trm290_dma_setup;
-	hwif->dma_exec_cmd	= &trm290_dma_exec_cmd;
-	hwif->dma_start 	= &trm290_dma_start;
-	hwif->ide_dma_end	= &trm290_ide_dma_end;
-	hwif->ide_dma_test_irq	= &trm290_ide_dma_test_irq;
-
-	hwif->selectproc = &trm290_selectproc;
 #if 1
 	{
 	/*
@@ -328,10 +309,27 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 #endif
 }
 
+static const struct ide_port_ops trm290_port_ops = {
+	.selectproc		= trm290_selectproc,
+};
+
+static struct ide_dma_ops trm290_dma_ops = {
+	.dma_host_set		= trm290_dma_host_set,
+	.dma_setup 		= trm290_dma_setup,
+	.dma_exec_cmd		= trm290_dma_exec_cmd,
+	.dma_start 		= trm290_dma_start,
+	.dma_end		= trm290_dma_end,
+	.dma_test_irq		= trm290_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
+
 static const struct ide_port_info trm290_chipset __devinitdata = {
 	.name		= "TRM290",
 	.init_hwif	= init_hwif_trm290,
 	.chipset	= ide_trm290,
+	.port_ops	= &trm290_port_ops,
+	.dma_ops	= &trm290_dma_ops,
 	.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
 #if 0 /* play it safe for now */
 			  IDE_HFLAG_TRUST_BIOS_FOR_DMA |
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index cff3caf..bbd17be 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -415,19 +415,17 @@ static u8 __devinit via82cxxx_cable_detect(ide_hwif_t *hwif)
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
diff --git a/drivers/ide/ppc/mpc8xx.c b/drivers/ide/ppc/mpc8xx.c
index 467656f..a82f6ef 100644
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -438,10 +438,14 @@ static void m8xx_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 #elif defined(CONFIG_IDE_EXT_DIRECT)
 
 	printk("%s[%d] %s: not implemented yet!\n",
-		__FILE__,__LINE__,__FUNCTION__);
+		__FILE__, __LINE__, __func__);
 #endif /* defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_PCMCIA */
 }
 
+static const struct ide_port_ops m8xx_port_ops = {
+	.set_pio_mode		= m8xx_ide_set_pio_mode,
+};
+
 static void
 ide_interrupt_ack (void *dev)
 {
@@ -810,9 +814,8 @@ static int __init mpc8xx_ide_probe(void)
 		ide_hwif_t *hwif = &ide_hwifs[0];
 
 		ide_init_port_hw(hwif, &hw);
-		hwif->mmio = 1;
 		hwif->pio_mask = ATA_PIO4;
-		hwif->set_pio_mode = m8xx_ide_set_pio_mode;
+		hwif->port_ops = &m8xx_port_ops;
 
 		idx[0] = 0;
 	}
@@ -822,9 +825,8 @@ static int __init mpc8xx_ide_probe(void)
 		ide_hwif_t *mate = &ide_hwifs[1];
 
 		ide_init_port_hw(mate, &hw);
-		mate->mmio = 1;
 		mate->pio_mask = ATA_PIO4;
-		mate->set_pio_mode = m8xx_ide_set_pio_mode;
+		mate->port_ops = &m8xx_port_ops;
 
 		idx[1] = 1;
 	}
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 177961e..185faa0 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -409,7 +409,7 @@ kauai_lookup_timing(struct kauai_timing* table, int cycle_time)
  */
 #define IDE_WAKEUP_DELAY	(1*HZ)
 
-static int pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif);
+static int pmac_ide_init_dma(ide_hwif_t *, const struct ide_port_info *);
 static int pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq);
 static void pmac_ide_selectproc(ide_drive_t *drive);
 static void pmac_ide_kauai_selectproc(ide_drive_t *drive);
@@ -918,11 +918,29 @@ pmac_ide_do_resume(ide_hwif_t *hwif)
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
+static const struct ide_dma_ops pmac_dma_ops;
+
 static const struct ide_port_info pmac_port_info = {
+	.init_dma		= pmac_ide_init_dma,
 	.chipset		= ide_pmac,
+#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
+	.dma_ops		= &pmac_dma_ops,
+#endif
+	.port_ops		= &pmac_ide_port_ops,
 	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
 				  IDE_HFLAG_POST_SET_MODE |
-				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
 				  IDE_HFLAG_UNMASK_IRQS,
 	.pio_mask		= ATA_PIO4,
 	.mwdma_mask		= ATA_MWDMA2,
@@ -947,12 +965,15 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
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
@@ -1029,37 +1050,29 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
 	default_hwif_mmiops(hwif);
        	hwif->OUTBSYNC = pmac_outbsync;
 
-	/* Tell common code _not_ to mess with resources */
-	hwif->mmio = 1;
 	hwif->hwif_data = pmif;
 	ide_init_port_hw(hwif, hw);
-	hwif->noprobe = pmif->mediabay;
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
 	       pmif->mediabay ? " (mediabay)" : "", hwif->irq);
-			
+
+	if (pmif->mediabay) {
 #ifdef CONFIG_PMAC_MEDIABAY
-	if (pmif->mediabay && check_media_bay_by_base(pmif->regbase, MB_CD) == 0)
-		hwif->noprobe = 0;
-#endif /* CONFIG_PMAC_MEDIABAY */
+		if (check_media_bay_by_base(pmif->regbase, MB_CD)) {
+#else
+		if (1) {
+#endif
+			hwif->drives[0].noprobe = 1;
+			hwif->drives[1].noprobe = 1;
+		}
+	}
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
 	if (pmif->cable_80 == 0)
 		d.udma_mask &= ATA_UDMA2;
-	/* has a DBDMA controller channel */
-	if (pmif->dma_regs == 0 || pmac_ide_setup_dma(pmif, hwif) < 0)
 #endif
-		d.udma_mask = d.mwdma_mask = 0;
 
 	idx[0] = hwif->index;
 
@@ -1662,18 +1675,31 @@ pmac_ide_dma_lost_irq (ide_drive_t *drive)
 	printk(KERN_ERR "ide-pmac lost interrupt, dma status: %lx\n", status);
 }
 
+static const struct ide_dma_ops pmac_dma_ops = {
+	.dma_host_set		= pmac_ide_dma_host_set,
+	.dma_setup		= pmac_ide_dma_setup,
+	.dma_exec_cmd		= pmac_ide_dma_exec_cmd,
+	.dma_start		= pmac_ide_dma_start,
+	.dma_end		= pmac_ide_dma_end,
+	.dma_test_irq		= pmac_ide_dma_test_irq,
+	.dma_timeout		= ide_dma_timeout,
+	.dma_lost_irq		= pmac_ide_dma_lost_irq,
+};
+
 /*
  * Allocate the data structures needed for using DMA with an interface
  * and fill the proper list of functions pointers
  */
-static int __devinit pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
+static int __devinit pmac_ide_init_dma(ide_hwif_t *hwif,
+				       const struct ide_port_info *d)
 {
+	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
 	/* We won't need pci_dev if we switch to generic consistent
 	 * DMA routines ...
 	 */
-	if (dev == NULL)
+	if (dev == NULL || pmif->dma_regs == 0)
 		return -ENODEV;
 	/*
 	 * Allocate space for the DBDMA commands.
@@ -1692,18 +1718,14 @@ static int __devinit pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 
 	hwif->sg_max_nents = MAX_DCMDS;
 
-	hwif->dma_host_set = &pmac_ide_dma_host_set;
-	hwif->dma_setup = &pmac_ide_dma_setup;
-	hwif->dma_exec_cmd = &pmac_ide_dma_exec_cmd;
-	hwif->dma_start = &pmac_ide_dma_start;
-	hwif->ide_dma_end = &pmac_ide_dma_end;
-	hwif->ide_dma_test_irq = &pmac_ide_dma_test_irq;
-	hwif->dma_timeout = &ide_dma_timeout;
-	hwif->dma_lost_irq = &pmac_ide_dma_lost_irq;
-
 	return 0;
 }
-
+#else
+static int __devinit pmac_ide_init_dma(ide_hwif_t *hwif,
+				       const struct ide_port_info *d)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
 
 module_init(pmac_ide_probe);
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 6302010..5171601 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -72,16 +72,16 @@ static void ide_pci_clear_simplex(unsigned long dma_base, const char *name)
 }
 
 /**
- *	ide_get_or_set_dma_base		-	setup BMIBA
- *	@d: IDE port info
+ *	ide_pci_dma_base	-	setup BMIBA
  *	@hwif: IDE interface
+ *	@d: IDE port info
  *
  *	Fetch the DMA Bus-Master-I/O-Base-Address (BMIBA) from PCI space.
  *	Where a device has a partner that is already in DMA mode we check
  *	and enforce IDE simplex rules.
  */
 
-static unsigned long ide_get_or_set_dma_base(const struct ide_port_info *d, ide_hwif_t *hwif)
+unsigned long ide_pci_dma_base(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long dma_base = 0;
@@ -132,6 +132,31 @@ static unsigned long ide_get_or_set_dma_base(const struct ide_port_info *d, ide_
 out:
 	return dma_base;
 }
+EXPORT_SYMBOL_GPL(ide_pci_dma_base);
+
+/*
+ * Set up BM-DMA capability (PnP BIOS should have done this)
+ */
+int ide_pci_set_master(struct pci_dev *dev, const char *name)
+{
+	u16 pcicmd;
+
+	pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
+
+	if ((pcicmd & PCI_COMMAND_MASTER) == 0) {
+		pci_set_master(dev);
+
+		if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd) ||
+		    (pcicmd & PCI_COMMAND_MASTER) == 0) {
+			printk(KERN_ERR "%s: error updating PCICMD on %s\n",
+					name, pci_name(dev));
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_pci_set_master);
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
 void ide_setup_pci_noise(struct pci_dev *dev, const struct ide_port_info *d)
@@ -158,7 +183,7 @@ EXPORT_SYMBOL_GPL(ide_setup_pci_noise);
 
 static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 {
-	int ret;
+	int ret, bars;
 
 	if (pci_enable_device(dev)) {
 		ret = pci_enable_device_io(dev);
@@ -181,13 +206,21 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 		goto out;
 	}
 
-	/* FIXME: Temporary - until we put in the hotplug interface logic
-	   Check that the bits we want are not in use by someone else. */
-	ret = pci_request_region(dev, 4, "ide_tmp");
-	if (ret < 0)
-		goto out;
+	if (d->host_flags & IDE_HFLAG_SINGLE)
+		bars = (1 << 2) - 1;
+	else
+		bars = (1 << 4) - 1;
 
-	pci_release_region(dev, 4);
+	if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0) {
+		if (d->host_flags & IDE_HFLAG_CS5520)
+			bars |= (1 << 2);
+		else
+			bars |= (1 << 4);
+	}
+
+	ret = pci_request_selected_regions(dev, bars, d->name);
+	if (ret < 0)
+		printk(KERN_ERR "%s: can't reserve resources\n", d->name);
 out:
 	return ret;
 }
@@ -314,7 +347,6 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
 	ide_init_port_hw(hwif, &hw);
 
 	hwif->dev = &dev->dev;
-	hwif->cds = d;
 
 	return hwif;
 }
@@ -330,40 +362,33 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
  *	state
  */
 
-void ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
+int ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u16 pcicmd;
-
-	pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
 
 	if ((d->host_flags & IDE_HFLAG_NO_AUTODMA) == 0 ||
 	    ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE &&
 	     (dev->class & 0x80))) {
-		unsigned long dma_base = ide_get_or_set_dma_base(d, hwif);
-		if (dma_base && !(pcicmd & PCI_COMMAND_MASTER)) {
-			/*
-			 * Set up BM-DMA capability
-			 * (PnP BIOS should have done this)
-			 */
-			pci_set_master(dev);
-			if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd) || !(pcicmd & PCI_COMMAND_MASTER)) {
-				printk(KERN_ERR "%s: %s error updating PCICMD\n",
-					hwif->name, d->name);
-				dma_base = 0;
-			}
-		}
-		if (dma_base) {
-			if (d->init_dma) {
-				d->init_dma(hwif, dma_base);
-			} else {
-				ide_setup_dma(hwif, dma_base);
-			}
-		} else {
-			printk(KERN_INFO "%s: %s Bus-Master DMA disabled "
-				"(BIOS)\n", hwif->name, d->name);
-		}
+		unsigned long base = ide_pci_dma_base(hwif, d);
+
+		if (base == 0 || ide_pci_set_master(dev, d->name) < 0)
+			return -1;
+
+		if (hwif->mmio)
+			printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
+		else
+			printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
+					 hwif->name, base, base + 7);
+
+		hwif->extra_base = base + (hwif->channel ? 8 : 16);
+
+		if (ide_allocate_dma_engine(hwif))
+			return -1;
+
+		ide_setup_dma(hwif, base);
 	}
+
+	return 0;
 }
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 93c3fc2..3638fa8 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -393,7 +393,7 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 		printk ("ide-scsi: %s: DMA complete\n", drive->name);
 #endif /* IDESCSI_DEBUG_LOG */
 		pc->xferred = pc->req_xfer;
-		(void) HWIF(drive)->ide_dma_end(drive);
+		(void)hwif->dma_ops->dma_end(drive);
 	}
 
 	/* Clear the interrupt */
@@ -498,7 +498,7 @@ static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 	drive->hwif->atapi_output_bytes(drive, scsi->pc->c, 12);
 	if (pc->flags & PC_FLAG_DMA_OK) {
 		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
-		hwif->dma_start(drive);
+		hwif->dma_ops->dma_start(drive);
 	}
 	return ide_started;
 }
@@ -560,7 +560,7 @@ static ide_startstop_t idescsi_issue_pc(ide_drive_t *drive,
 
 	if (drive->using_dma && !idescsi_map_sg(drive, pc)) {
 		hwif->sg_mapped = 1;
-		dma = !hwif->dma_setup(drive);
+		dma = !hwif->dma_ops->dma_setup(drive);
 		hwif->sg_mapped = 0;
 	}
 
diff --git a/include/asm-mips/mach-au1x00/au1xxx_ide.h b/include/asm-mips/mach-au1x00/au1xxx_ide.h
index 89655c0..b493a5e 100644
--- a/include/asm-mips/mach-au1x00/au1xxx_ide.h
+++ b/include/asm-mips/mach-au1x00/au1xxx_ide.h
@@ -70,7 +70,6 @@ typedef struct
         ide_hwif_t              *hwif;
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
         ide_drive_t             *drive;
-        u8                      white_list, black_list;
         struct dbdma_cmd        *dma_table_cpu;
         dma_addr_t              dma_table_dma;
 #endif
@@ -81,47 +80,6 @@ typedef struct
 #endif
 } _auide_hwif;
 
-#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
-/* HD white list */
-static const struct drive_list_entry dma_white_list [] = {
-/*
- * Hitachi
- */
-        { "HITACHI_DK14FA-20"    ,       NULL            },
-        { "HTS726060M9AT00"      ,       NULL            },
-/*
- * Maxtor
- */
-        { "Maxtor 6E040L0"      ,       NULL            },
-        { "Maxtor 6Y080P0"      ,       NULL            },
-        { "Maxtor 6Y160P0"      ,       NULL            },
-/*
- * Seagate
- */
-        { "ST3120026A"          ,       NULL            },
-        { "ST320014A"           ,       NULL            },
-        { "ST94011A"            ,       NULL            },
-        { "ST340016A"           ,       NULL            },
-/*
- * Western Digital
- */
-        { "WDC WD400UE-00HCT0"  ,       NULL            },
-        { "WDC WD400JB-00JJC0"  ,       NULL            },
-        { NULL                  ,       NULL            }
-};
-
-/* HD black list */
-static const struct drive_list_entry dma_black_list [] = {
-/*
- * Western Digital
- */
-        { "WDC WD100EB-00CGH0"  ,       NULL            },
-        { "WDC WD200BB-00AUA1"  ,       NULL            },
-        { "WDC AC24300L"        ,       NULL            },
-        { NULL                  ,       NULL            }
-};
-#endif
-
 /*******************************************************************************
 * PIO Mode timing calculation :                                                *
 *                                                                              *
diff --git a/include/linux/ide.h b/include/linux/ide.h
index f20410d..f0af504 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -387,6 +387,43 @@ typedef struct ide_drive_s {
 
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
+struct ide_dma_ops {
+	void	(*dma_host_set)(struct ide_drive_s *, int);
+	int	(*dma_setup)(struct ide_drive_s *);
+	void	(*dma_exec_cmd)(struct ide_drive_s *, u8);
+	void	(*dma_start)(struct ide_drive_s *);
+	int	(*dma_end)(struct ide_drive_s *);
+	int	(*dma_test_irq)(struct ide_drive_s *);
+	void	(*dma_lost_irq)(struct ide_drive_s *);
+	void	(*dma_timeout)(struct ide_drive_s *);
+};
+
 typedef struct hwif_s {
 	struct hwif_s *next;		/* for linked-list in ide_hwgroup_t */
 	struct hwif_s *mate;		/* other hwif from same PCI chip */
@@ -420,38 +457,12 @@ typedef struct hwif_s {
 
 	struct device *dev;
 
-	const struct ide_port_info *cds;	/* chipset device struct */
-
 	ide_ack_intr_t *ack_intr;
 
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
+	const struct ide_dma_ops	*dma_ops;
 
 	void (*ata_input_data)(ide_drive_t *, void *, u32);
 	void (*ata_output_data)(ide_drive_t *, void *, u32);
@@ -459,15 +470,7 @@ typedef struct hwif_s {
 	void (*atapi_input_bytes)(ide_drive_t *, void *, u32);
 	void (*atapi_output_bytes)(ide_drive_t *, void *, u32);
 
-	void (*dma_host_set)(ide_drive_t *, int);
-	int (*dma_setup)(ide_drive_t *);
-	void (*dma_exec_cmd)(ide_drive_t *, u8);
-	void (*dma_start)(ide_drive_t *);
-	int (*ide_dma_end)(ide_drive_t *drive);
-	int (*ide_dma_test_irq)(ide_drive_t *drive);
 	void (*ide_dma_clear_irq)(ide_drive_t *drive);
-	void (*dma_lost_irq)(ide_drive_t *drive);
-	void (*dma_timeout)(ide_drive_t *drive);
 
 	void (*OUTB)(u8 addr, unsigned long port);
 	void (*OUTBSYNC)(ide_drive_t *drive, u8 addr, unsigned long port);
@@ -514,7 +517,6 @@ typedef struct hwif_s {
 	unsigned long	extra_base;	/* extra addr for dma ports */
 	unsigned	extra_ports;	/* number of extra dma ports */
 
-	unsigned	noprobe    : 1;	/* don't probe for this interface */
 	unsigned	present    : 1;	/* this interface exists */
 	unsigned	serialized : 1;	/* serialized all channel operation */
 	unsigned	sharing_irq: 1;	/* 1 = sharing irq with another hwif */
@@ -1009,10 +1011,15 @@ void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *, int, u8
 void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
-void ide_hwif_setup_dma(ide_hwif_t *, const struct ide_port_info *);
+int ide_pci_set_master(struct pci_dev *, const char *);
+unsigned long ide_pci_dma_base(ide_hwif_t *, const struct ide_port_info *);
+int ide_hwif_setup_dma(ide_hwif_t *, const struct ide_port_info *);
 #else
-static inline void ide_hwif_setup_dma(ide_hwif_t *hwif,
-				      const struct ide_port_info *d) { }
+static inline int ide_hwif_setup_dma(ide_hwif_t *hwif,
+				     const struct ide_port_info *d)
+{
+	return -EINVAL;
+}
 #endif
 
 extern void default_hwif_iops(ide_hwif_t *);
@@ -1084,6 +1091,8 @@ enum {
 	/* unmask IRQs */
 	IDE_HFLAG_UNMASK_IRQS		= (1 << 25),
 	IDE_HFLAG_ABUSE_SET_DMA_MODE	= (1 << 26),
+	/* serialize ports if DMA is possible (for sl82c105) */
+	IDE_HFLAG_SERIALIZE_DMA		= (1 << 27),
 	/* force host out of "simplex" mode */
 	IDE_HFLAG_CLEAR_SIMPLEX		= (1 << 28),
 	/* DSC overlap is unsupported */
@@ -1105,10 +1114,14 @@ struct ide_port_info {
 	unsigned int		(*init_chipset)(struct pci_dev *, const char *);
 	void			(*init_iops)(ide_hwif_t *);
 	void                    (*init_hwif)(ide_hwif_t *);
-	void			(*init_dma)(ide_hwif_t *, unsigned long);
+	int			(*init_dma)(ide_hwif_t *,
+					    const struct ide_port_info *);
+
+	const struct ide_port_ops	*port_ops;
+	const struct ide_dma_ops	*dma_ops;
+
 	ide_pci_enablebit_t	enablebits[2];
 	hwif_chipset_t		chipset;
-	u8			extra;
 	u32			host_flags;
 	u8			pio_mask;
 	u8			swdma_mask;
@@ -1155,13 +1168,16 @@ void ide_destroy_dmatable(ide_drive_t *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 extern int ide_build_dmatable(ide_drive_t *, struct request *);
-extern int ide_release_dma(ide_hwif_t *);
-extern void ide_setup_dma(ide_hwif_t *, unsigned long);
+int ide_allocate_dma_engine(ide_hwif_t *);
+void ide_release_dma_engine(ide_hwif_t *);
+void ide_setup_dma(ide_hwif_t *, unsigned long);
 
 void ide_dma_host_set(ide_drive_t *, int);
 extern int ide_dma_setup(ide_drive_t *);
+void ide_dma_exec_cmd(ide_drive_t *, u8);
 extern void ide_dma_start(ide_drive_t *);
 extern int __ide_dma_end(ide_drive_t *);
+int ide_dma_test_irq(ide_drive_t *);
 extern void ide_dma_lost_irq(ide_drive_t *);
 extern void ide_dma_timeout(ide_drive_t *);
 #endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
@@ -1179,7 +1195,7 @@ static inline void ide_check_dma_crc(ide_drive_t *drive) { ; }
 #endif /* CONFIG_BLK_DEV_IDEDMA */
 
 #ifndef CONFIG_BLK_DEV_IDEDMA_SFF
-static inline void ide_release_dma(ide_hwif_t *drive) {;}
+static inline void ide_release_dma_engine(ide_hwif_t *hwif) { ; }
 #endif
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
@@ -1199,8 +1215,6 @@ static inline void ide_acpi_set_state(ide_hwif_t *hwif, int on) {}
 #endif
 
 void ide_remove_port_from_hwgroup(ide_hwif_t *);
-extern int ide_hwif_request_regions(ide_hwif_t *hwif);
-extern void ide_hwif_release_regions(ide_hwif_t* hwif);
 void ide_unregister(unsigned int);
 
 void ide_register_region(struct gendisk *);
@@ -1210,6 +1224,7 @@ void ide_undecoded_slave(ide_drive_t *);
 
 int ide_device_add_all(u8 *idx, const struct ide_port_info *);
 int ide_device_add(u8 idx[4], const struct ide_port_info *);
+int ide_legacy_device_add(const struct ide_port_info *, unsigned long);
 void ide_port_unregister_devices(ide_hwif_t *);
 void ide_port_scan(ide_hwif_t *);
 
