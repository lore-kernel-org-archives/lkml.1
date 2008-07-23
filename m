Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYGWSVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYGWSVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYGWSVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:21:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:25646 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYGWSVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:21:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :content-type:content-transfer-encoding:message-id;
        b=Qk3DKY7XA3PYZ/UZA1nk7QXVSnvf6UdrOai3j+ao7cWetUy5GgL0lDFlhDl/Qhv65d
         +WoHxq67O0yB0GEa4/42x1F1MpO+sNPSsbJScsB6fjIJVNSAWB4cLidx2ifI+xq9/Ow5
         deIy7Xi/2CHXO5wtIEuG0Hl3zDaPHMw3SDJfY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates (part 3)
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 23 Jul 2008 20:13:58 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807232013.59734.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Inside:

* Addition of struct ide_tp_ops and struct ide_host.

* Rework of probing code to allow unloading of host driver modules.

* Dynamic allocation of ide_hwif_t instances.

* More work on generic ATAPI support from Borislav Petkov.

* Janitorial fixes from Darren Jenkins, Harvey Harrison
  and Pavel Machek.

* Misc fixes/cleanups.


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig               |    2 +
 drivers/ide/arm/icside.c          |   71 +++----
 drivers/ide/arm/ide_arm.c         |   14 +--
 drivers/ide/arm/palm_bk3710.c     |   30 +--
 drivers/ide/arm/rapide.c          |   24 +--
 drivers/ide/h8300/ide-h8300.c     |   48 ++---
 drivers/ide/ide-atapi.c           |   58 ++++--
 drivers/ide/ide-cd.c              |  157 ++++++++--------
 drivers/ide/ide-cd.h              |   38 ----
 drivers/ide/ide-cd_ioctl.c        |   35 ++--
 drivers/ide/ide-disk.c            |    2 +-
 drivers/ide/ide-dma.c             |  103 +++++++----
 drivers/ide/ide-floppy.c          |   90 ++++------
 drivers/ide/ide-generic.c         |   73 ++++----
 drivers/ide/ide-io.c              |   42 +++--
 drivers/ide/ide-iops.c            |  230 ++++++++++++++++--------
 drivers/ide/ide-lib.c             |   17 +--
 drivers/ide/ide-pnp.c             |   29 ++--
 drivers/ide/ide-probe.c           |  366 ++++++++++++++++++++++++++-----------
 drivers/ide/ide-proc.c            |    4 +-
 drivers/ide/ide-tape.c            |  127 ++++++--------
 drivers/ide/ide-taskfile.c        |   38 +++--
 drivers/ide/ide.c                 |   49 +-----
 drivers/ide/legacy/buddha.c       |   24 +--
 drivers/ide/legacy/falconide.c    |   56 ++++--
 drivers/ide/legacy/gayle.c        |   39 ++---
 drivers/ide/legacy/ide-4drives.c  |   20 +--
 drivers/ide/legacy/ide-cs.c       |   54 +++---
 drivers/ide/legacy/ide_platform.c |   32 +---
 drivers/ide/legacy/macide.c       |   15 +--
 drivers/ide/legacy/q40ide.c       |   47 +++--
 drivers/ide/mips/au1xxx-ide.c     |   56 +++---
 drivers/ide/mips/swarm.c          |   24 +--
 drivers/ide/pci/aec62xx.c         |    5 -
 drivers/ide/pci/alim15x3.c        |   12 +-
 drivers/ide/pci/amd74xx.c         |    1 -
 drivers/ide/pci/cmd640.c          |   29 +---
 drivers/ide/pci/cmd64x.c          |   12 +-
 drivers/ide/pci/cs5520.c          |   41 +----
 drivers/ide/pci/cs5535.c          |    3 +-
 drivers/ide/pci/delkin_cb.c       |   25 +--
 drivers/ide/pci/hpt34x.c          |    1 -
 drivers/ide/pci/hpt366.c          |   23 ++-
 drivers/ide/pci/ns87415.c         |  115 ++++++------
 drivers/ide/pci/pdc202xx_old.c    |    3 +-
 drivers/ide/pci/piix.c            |    4 +-
 drivers/ide/pci/scc_pata.c        |  139 +++++++++------
 drivers/ide/pci/serverworks.c     |    4 +-
 drivers/ide/pci/sgiioc4.c         |   65 ++++---
 drivers/ide/pci/siimage.c         |    6 +-
 drivers/ide/pci/sl82c105.c        |    4 +-
 drivers/ide/pci/tc86c001.c        |   16 +-
 drivers/ide/pci/via82cxxx.c       |    1 -
 drivers/ide/ppc/pmac.c            |  222 +++++++++++++---------
 drivers/ide/setup-pci.c           |  109 ++++++-----
 drivers/scsi/ide-scsi.c           |   32 +---
 include/linux/ide.h               |  193 +++++++++++++-------
 57 files changed, 1613 insertions(+), 1466 deletions(-)


Bartlomiej Zolnierkiewicz (40):
      ide-pmac: store pmif instead of hwif in ->driver_data (take 2)
      ide-pmac: add ->init_dev method (take 4)
      ide-pmac: move ide_find_port() call to pmac_ide_setup_device() (take 2)
      ide: move ide_pci_setup_ports() call out from do_ide_setup_pci_device()
      ide: pass hw_regs_t-s to ide_device_add[_all]() (take 3)
      ide: add ->read_sff_dma_status method
      ide: use I/O ops directly in ide-dma.c
      ide: remove ->dma_{status,command} fields from ide_hwif_t
      ide: remove ide_setup_dma()
      ide: factor out simplex handling from ide_pci_dma_base()
      ide: add ->exec_command method
      ide: add ->read_status method
      ide: add ->read_altstatus method
      ide: add ->set_irq method
      ide: change order of register access in ide_config_drive_speed()
      ide: use ->tf_load in ide_config_drive_speed()
      ide: use ->tf_load in actual_try_to_identify()
      ide: use ->tf_load in SELECT_DRIVE()
      ide: use ->tf_read in ide_read_error()
      ide: add ide_read_device() helper
      ide: add ide_read_ireason() helper
      ide: add ide_read_bcount_and_ireason() helper
      ide: remove ->INB, ->OUTB and ->OUTBSYNC methods
      ide: limit cy82c693 host driver to ALPHA
      ide: mark hpt34x host driver as BROKEN
      ide: remove dead Virtual DMA support
      ide: filter out invalid transfer mode values in set_xfer_rate()
      ide: filter out "default" transfer mode values in set_xfer_rate()
      gayle: reserve memory resources at once
      ide-generic: probing fix
      ide: add 'config' field to hw_regs_t
      ide: add struct ide_tp_ops (take 2)
      ide: add struct ide_host (take 3)
      ide: add ide_host_add() helper
      ide: fix ide_host_register() return value
      ide: fix IDE port slots reservation and freeing (take 2)
      ide: move ide_remove_port_from_hwgroup() to ide-probe.c
      ide: add ide_ports[]
      ide: allocate ide_hwif_t instances dynamically
      ide: add ide_host_free() helper (take 2)

Borislav Petkov (16):
      ide: push pc callback pointer into the ide_drive_t structure
      ide-floppy: use drive->pc_callback instead of pc->callback
      ide-tape: use drive->pc_callback instead of pc->callback
      ide-scsi: use drive->pc_callback instead of pc->callback
      ide: remove pc->callback member from ide_atapi_pc
      ide-floppy: pass packet command in rq->cmd
      ide-tape: make room for packet command ids in rq->cmd
      ide-tape: pass packet command in rq->cmd
      ide-scsi: pass packet command in rq->cmd
      ide: use rq->cmd instead of pc->c in atapi common code
      ide: add per-device flags
      ide-floppy: convert to using the new atapi_flags (take 2)
      ide-tape: convert to using the new atapi_flags
      ide-scsi: convert to using the new atapi_flags
      ide: remove unused PC_FLAG_DRQ_INTERRUPT
      ide-cd: convert to using the new atapi_flags

Darren Jenkins (1):
      drivers/ide/ide-tape.c: remove double kfree

Harvey Harrison (2):
      ide: ide-cd.c fix sparse endianness warnings
      ide: ide-cd_ioctl.c fix sparse integer as NULL pointer warnings

Pavel Machek (1):
      ide: small whitespace fixes


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 15b09b8..04d9c4d 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -510,6 +510,7 @@ config BLK_DEV_TRIFLEX
 
 config BLK_DEV_CY82C693
 	tristate "CY82C693 chipset support"
+	depends on ALPHA
 	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
@@ -548,6 +549,7 @@ config BLK_DEV_CS5535
 
 config BLK_DEV_HPT34X
 	tristate "HPT34X chipset support"
+	depends on BROKEN
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds up to 4 more EIDE devices sharing a single
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 52f58c8..f575e83 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -72,7 +72,7 @@ struct icside_state {
 	void __iomem *ioc_base;
 	unsigned int sel;
 	unsigned int type;
-	ide_hwif_t *hwif[2];
+	struct ide_host *host;
 };
 
 #define ICS_TYPE_A3IN	0
@@ -375,12 +375,14 @@ static int icside_dma_test_irq(ide_drive_t *drive)
 
 static void icside_dma_timeout(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
+
 	printk(KERN_ERR "%s: DMA timeout occurred: ", drive->name);
 
 	if (icside_dma_test_irq(drive))
 		return;
 
-	ide_dump_status(drive, "DMA timeout", ide_read_status(drive));
+	ide_dump_status(drive, "DMA timeout", hwif->tp_ops->read_status(hwif));
 
 	icside_dma_end(drive);
 }
@@ -440,10 +442,10 @@ static void icside_setup_ports(hw_regs_t *hw, void __iomem *base,
 static int __init
 icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 {
-	ide_hwif_t *hwif;
 	void __iomem *base;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw;
+	struct ide_host *host;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	int ret;
 
 	base = ecardm_iomap(ec, ECARD_RES_MEMC, 0, 0);
 	if (!base)
@@ -463,22 +465,23 @@ icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 
 	icside_setup_ports(&hw, base, &icside_cardinfo_v5, ec);
 
-	hwif = ide_find_port();
-	if (!hwif)
+	host = ide_host_alloc(NULL, hws);
+	if (host == NULL)
 		return -ENODEV;
 
-	ide_init_port_hw(hwif, &hw);
-	default_hwif_mmiops(hwif);
-
-	state->hwif[0] = hwif;
+	state->host = host;
 
 	ecard_set_drvdata(ec, state);
 
-	idx[0] = hwif->index;
-
-	ide_device_add(idx, NULL);
+	ret = ide_host_register(host, NULL, hws);
+	if (ret)
+		goto err_free;
 
 	return 0;
+err_free:
+	ide_host_free(host);
+	ecard_set_drvdata(ec, NULL);
+	return ret;
 }
 
 static const struct ide_port_info icside_v6_port_info __initdata = {
@@ -493,13 +496,12 @@ static const struct ide_port_info icside_v6_port_info __initdata = {
 static int __init
 icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 {
-	ide_hwif_t *hwif, *mate;
 	void __iomem *ioc_base, *easi_base;
+	struct ide_host *host;
 	unsigned int sel = 0;
 	int ret;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw[2], *hws[] = { &hw[0], NULL, NULL, NULL };
 	struct ide_port_info d = icside_v6_port_info;
-	hw_regs_t hw[2];
 
 	ioc_base = ecardm_iomap(ec, ECARD_RES_IOCFAST, 0, 0);
 	if (!ioc_base) {
@@ -538,28 +540,11 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 	icside_setup_ports(&hw[0], easi_base, &icside_cardinfo_v6_1, ec);
 	icside_setup_ports(&hw[1], easi_base, &icside_cardinfo_v6_2, ec);
 
-	/*
-	 * Find and register the interfaces.
-	 */
-	hwif = ide_find_port();
-	if (hwif == NULL)
+	host = ide_host_alloc(&d, hws);
+	if (host == NULL)
 		return -ENODEV;
 
-	ide_init_port_hw(hwif, &hw[0]);
-	default_hwif_mmiops(hwif);
-
-	idx[0] = hwif->index;
-
-	mate = ide_find_port();
-	if (mate) {
-		ide_init_port_hw(mate, &hw[1]);
-		default_hwif_mmiops(mate);
-
-		idx[1] = mate->index;
-	}
-
-	state->hwif[0]    = hwif;
-	state->hwif[1]    = mate;
+	state->host = host;
 
 	ecard_set_drvdata(ec, state);
 
@@ -569,11 +554,17 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 		d.dma_ops = NULL;
 	}
 
-	ide_device_add(idx, &d);
+	ret = ide_host_register(host, NULL, hws);
+	if (ret)
+		goto err_free;
 
 	return 0;
-
- out:
+err_free:
+	ide_host_free(host);
+	if (d.dma_ops)
+		free_dma(ec->dma);
+	ecard_set_drvdata(ec, NULL);
+out:
 	return ret;
 }
 
diff --git a/drivers/ide/arm/ide_arm.c b/drivers/ide/arm/ide_arm.c
index 2f311da..176532f 100644
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -28,10 +28,8 @@
 
 static int __init ide_arm_init(void)
 {
-	ide_hwif_t *hwif;
-	hw_regs_t hw;
 	unsigned long base = IDE_ARM_IO, ctl = IDE_ARM_IO + 0x206;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	if (!request_region(base, 8, DRV_NAME)) {
 		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
@@ -51,15 +49,7 @@ static int __init ide_arm_init(void)
 	hw.irq = IDE_ARM_IRQ;
 	hw.chipset = ide_generic;
 
-	hwif = ide_find_port();
-	if (hwif) {
-		ide_init_port_hw(hwif, &hw);
-		idx[0] = hwif->index;
-
-		ide_device_add(idx, NULL);
-	}
-
-	return 0;
+	return ide_host_add(NULL, hws, NULL);
 }
 
 module_init(ide_arm_init);
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index c79b85b..65bb4b8 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -316,15 +316,14 @@ static u8 __devinit palm_bk3710_cable_detect(ide_hwif_t *hwif)
 static int __devinit palm_bk3710_init_dma(ide_hwif_t *hwif,
 					  const struct ide_port_info *d)
 {
-	unsigned long base =
-		hwif->io_ports.data_addr - IDE_PALM_ATA_PRI_REG_OFFSET;
-
 	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
 
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	ide_setup_dma(hwif, base);
+	hwif->dma_base = hwif->io_ports.data_addr - IDE_PALM_ATA_PRI_REG_OFFSET;
+
+	hwif->dma_ops = &sff_dma_ops;
 
 	return 0;
 }
@@ -348,11 +347,10 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 {
 	struct clk *clk;
 	struct resource *mem, *irq;
-	ide_hwif_t *hwif;
+	struct ide_host *host;
 	unsigned long base, rate;
-	int i;
-	hw_regs_t hw;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	int i, rc;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	clk = clk_get(NULL, "IDECLK");
 	if (IS_ERR(clk))
@@ -394,24 +392,14 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 	hw.irq = irq->start;
 	hw.chipset = ide_palm3710;
 
-	hwif = ide_find_port();
-	if (hwif == NULL)
+	rc = ide_host_add(&palm_bk3710_port_info, hws, NULL);
+	if (rc)
 		goto out;
 
-	i = hwif->index;
-
-	ide_init_port_hw(hwif, &hw);
-
-	default_hwif_mmiops(hwif);
-
-	idx[0] = i;
-
-	ide_device_add(idx, &palm_bk3710_port_info);
-
 	return 0;
 out:
 	printk(KERN_WARNING "Palm Chip BK3710 IDE Register Fail\n");
-	return -ENODEV;
+	return rc;
 }
 
 /* work with hotplug and coldplug */
diff --git a/drivers/ide/arm/rapide.c b/drivers/ide/arm/rapide.c
index 43057e0..2bdd8b7 100644
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -32,11 +32,10 @@ static void rapide_setup_ports(hw_regs_t *hw, void __iomem *base,
 static int __devinit
 rapide_probe(struct expansion_card *ec, const struct ecard_id *id)
 {
-	ide_hwif_t *hwif;
 	void __iomem *base;
+	struct ide_host *host;
 	int ret;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	ret = ecard_request_resources(ec);
 	if (ret)
@@ -53,20 +52,11 @@ rapide_probe(struct expansion_card *ec, const struct ecard_id *id)
 	hw.chipset = ide_generic;
 	hw.dev = &ec->dev;
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		ret = -ENOENT;
+	ret = ide_host_add(&rapide_port_info, hws, &host);
+	if (ret)
 		goto release;
-	}
-
-	ide_init_port_hw(hwif, &hw);
-	default_hwif_mmiops(hwif);
-
-	idx[0] = hwif->index;
-
-	ide_device_add(idx, &rapide_port_info);
 
-	ecard_set_drvdata(ec, hwif);
+	ecard_set_drvdata(ec, host);
 	goto out;
 
  release:
@@ -77,11 +67,11 @@ rapide_probe(struct expansion_card *ec, const struct ecard_id *id)
 
 static void __devexit rapide_remove(struct expansion_card *ec)
 {
-	ide_hwif_t *hwif = ecard_get_drvdata(ec);
+	struct ide_host *host = ecard_get_drvdata(ec);
 
 	ecard_set_drvdata(ec, NULL);
 
-	ide_unregister(hwif);
+	ide_host_remove(host);
 
 	ecard_release_resources(ec);
 }
diff --git a/drivers/ide/h8300/ide-h8300.c b/drivers/ide/h8300/ide-h8300.c
index 20fad6d..bde7a58 100644
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -100,6 +100,8 @@ static void h8300_tf_read(ide_drive_t *drive, ide_task_t *task)
 	/* be sure we're looking at the low order bits */
 	outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
+	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+		tf->feature = inb(io_ports->feature_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = inb(io_ports->nsect_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
@@ -153,6 +155,21 @@ static void h8300_output_data(ide_drive_t *drive, struct request *rq,
 	mm_outsw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
 }
 
+static const struct ide_tp_ops h8300_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= h8300_tf_load,
+	.tf_read		= h8300_tf_read,
+
+	.input_data		= h8300_input_data,
+	.output_data		= h8300_output_data,
+};
+
 #define H8300_IDE_GAP (2)
 
 static inline void hw_setup(hw_regs_t *hw)
@@ -167,27 +184,14 @@ static inline void hw_setup(hw_regs_t *hw)
 	hw->chipset = ide_generic;
 }
 
-static inline void hwif_setup(ide_hwif_t *hwif)
-{
-	default_hwif_iops(hwif);
-
-	hwif->tf_load = h8300_tf_load;
-	hwif->tf_read = h8300_tf_read;
-
-	hwif->input_data  = h8300_input_data;
-	hwif->output_data = h8300_output_data;
-}
-
 static const struct ide_port_info h8300_port_info = {
+	.tp_ops			= &h8300_tp_ops,
 	.host_flags		= IDE_HFLAG_NO_IO_32BIT | IDE_HFLAG_NO_DMA,
 };
 
 static int __init h8300_ide_init(void)
 {
-	hw_regs_t hw;
-	ide_hwif_t *hwif;
-	int index;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	printk(KERN_INFO DRV_NAME ": H8/300 generic IDE interface\n");
 
@@ -200,19 +204,7 @@ static int __init h8300_ide_init(void)
 
 	hw_setup(&hw);
 
-	hwif = ide_find_port_slot(&h8300_port_info);
-	if (hwif == NULL)
-		return -ENOENT;
-
-	index = hwif->index;
-	ide_init_port_hw(hwif, &hw);
-	hwif_setup(hwif);
-
-	idx[0] = index;
-
-	ide_device_add(idx, &h8300_port_info);
-
-	return 0;
+	return ide_host_add(&h8300_port_info, hws, NULL);
 
 out_busy:
 	printk(KERN_ERR "ide-h8300: IDE I/F resource already used.\n");
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 2802031..adf04f9 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -22,6 +22,8 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	void (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq = hwif->hwgroup->rq;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	xfer_func_t *xferfunc;
 	unsigned int temp;
 	u16 bcount;
@@ -30,12 +32,12 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	debug_log("Enter %s - interrupt handler\n", __func__);
 
 	if (pc->flags & PC_FLAG_TIMEDOUT) {
-		pc->callback(drive);
+		drive->pc_callback(drive);
 		return ide_stopped;
 	}
 
 	/* Clear the interrupt */
-	stat = ide_read_status(drive);
+	stat = tp_ops->read_status(hwif);
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		if (hwif->dma_ops->dma_end(drive) ||
@@ -63,8 +65,9 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		local_irq_enable_in_hardirq();
 
 		if (drive->media == ide_tape && !scsi &&
-		    (stat & ERR_STAT) && pc->c[0] == REQUEST_SENSE)
+		    (stat & ERR_STAT) && rq->cmd[0] == REQUEST_SENSE)
 			stat &= ~ERR_STAT;
+
 		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
 			/* Error detected */
 			debug_log("%s: I/O error\n", drive->name);
@@ -75,16 +78,17 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 					goto cmd_finished;
 			}
 
-			if (pc->c[0] == REQUEST_SENSE) {
+			if (rq->cmd[0] == REQUEST_SENSE) {
 				printk(KERN_ERR "%s: I/O error in request sense"
 						" command\n", drive->name);
 				return ide_do_reset(drive);
 			}
 
-			debug_log("[cmd %x]: check condition\n", pc->c[0]);
+			debug_log("[cmd %x]: check condition\n", rq->cmd[0]);
 
 			/* Retry operation */
 			retry_pc(drive);
+
 			/* queued, but not started */
 			return ide_stopped;
 		}
@@ -95,8 +99,10 @@ cmd_finished:
 			dsc_handle(drive);
 			return ide_stopped;
 		}
+
 		/* Command finished - Call the callback function */
-		pc->callback(drive);
+		drive->pc_callback(drive);
+
 		return ide_stopped;
 	}
 
@@ -107,16 +113,15 @@ cmd_finished:
 		ide_dma_off(drive);
 		return ide_do_reset(drive);
 	}
-	/* Get the number of bytes to transfer on this interrupt. */
-	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
-		  hwif->INB(hwif->io_ports.lbam_addr);
 
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
+	/* Get the number of bytes to transfer on this interrupt. */
+	ide_read_bcount_and_ireason(drive, &bcount, &ireason);
 
 	if (ireason & CD) {
 		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
 		return ide_do_reset(drive);
 	}
+
 	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
@@ -125,6 +130,7 @@ cmd_finished:
 				(ireason & IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
+
 	if (!(pc->flags & PC_FLAG_WRITING)) {
 		/* Reading - Check that we have enough space */
 		temp = pc->xferred + bcount;
@@ -142,7 +148,7 @@ cmd_finished:
 					if (pc->sg)
 						io_buffers(drive, pc, temp, 0);
 					else
-						hwif->input_data(drive, NULL,
+						tp_ops->input_data(drive, NULL,
 							pc->cur_pos, temp);
 					printk(KERN_ERR "%s: transferred %d of "
 							"%d bytes\n",
@@ -159,9 +165,9 @@ cmd_finished:
 			debug_log("The device wants to send us more data than "
 				  "expected - allowing transfer\n");
 		}
-		xferfunc = hwif->input_data;
+		xferfunc = tp_ops->input_data;
 	} else
-		xferfunc = hwif->output_data;
+		xferfunc = tp_ops->output_data;
 
 	if ((drive->media == ide_floppy && !scsi && !pc->buf) ||
 	    (drive->media == ide_tape && !scsi && pc->bh) ||
@@ -175,7 +181,7 @@ cmd_finished:
 	pc->cur_pos += bcount;
 
 	debug_log("[cmd %x] transferred %d bytes on that intr.\n",
-		  pc->c[0], bcount);
+		  rq->cmd[0], bcount);
 
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, handler, timeout, expiry);
@@ -183,16 +189,27 @@ cmd_finished:
 }
 EXPORT_SYMBOL_GPL(ide_pc_intr);
 
+static u8 ide_read_ireason(ide_drive_t *drive)
+{
+	ide_task_t task;
+
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_IN_NSECT;
+
+	drive->hwif->tp_ops->tf_read(drive, &task);
+
+	return task.tf.nsect & 3;
+}
+
 static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	int retries = 100;
 
 	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
 		printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
 				"a packet command, retrying\n", drive->name);
 		udelay(100);
-		ireason = hwif->INB(hwif->io_ports.nsect_addr);
+		ireason = ide_read_ireason(drive);
 		if (retries == 0) {
 			printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
 					"a packet command, ignoring\n",
@@ -210,6 +227,7 @@ ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				ide_expiry_t *expiry)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq = hwif->hwgroup->rq;
 	ide_startstop_t startstop;
 	u8 ireason;
 
@@ -219,7 +237,7 @@ ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		return startstop;
 	}
 
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
+	ireason = ide_read_ireason(drive);
 	if (drive->media == ide_tape && !drive->scsi)
 		ireason = ide_wait_ireason(drive, ireason);
 
@@ -239,8 +257,8 @@ ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	}
 
 	/* Send the actual packet */
-	if ((pc->flags & PC_FLAG_ZIP_DRIVE) == 0)
-		hwif->output_data(drive, NULL, pc->c, 12);
+	if ((drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) == 0)
+		hwif->tp_ops->output_data(drive, NULL, rq->cmd, 12);
 
 	return ide_started;
 }
@@ -284,7 +302,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 			   bcount, dma);
 
 	/* Issue the packet command */
-	if (pc->flags & PC_FLAG_DRQ_INTERRUPT) {
+	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
 		ide_execute_command(drive, WIN_PACKETCMD, handler,
 				    timeout, NULL);
 		return ide_started;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 6e29dd5..4e73aee 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -85,10 +85,8 @@ static void ide_cd_put(struct cdrom_info *cd)
 /* Mark that we've seen a media change and invalidate our internal buffers. */
 static void cdrom_saw_media_change(ide_drive_t *drive)
 {
-	struct cdrom_info *cd = drive->driver_data;
-
-	cd->cd_flags |= IDE_CD_FLAG_MEDIA_CHANGED;
-	cd->cd_flags &= ~IDE_CD_FLAG_TOC_VALID;
+	drive->atapi_flags |= IDE_AFLAG_MEDIA_CHANGED;
+	drive->atapi_flags &= ~IDE_AFLAG_TOC_VALID;
 }
 
 static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
@@ -280,11 +278,12 @@ static void ide_dump_status_no_sense(ide_drive_t *drive, const char *msg, u8 st)
  */
 static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 {
-	struct request *rq = HWGROUP(drive)->rq;
+	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq = hwif->hwgroup->rq;
 	int stat, err, sense_key;
 
 	/* check for errors */
-	stat = ide_read_status(drive);
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (stat_ret)
 		*stat_ret = stat;
@@ -528,7 +527,7 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL,
 			   xferlen, info->dma);
 
-	if (info->cd_flags & IDE_CD_FLAG_DRQ_INTERRUPT) {
+	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
 		/* waiting for CDB interrupt, not DMA yet. */
 		if (info->dma)
 			drive->waiting_for_dma = 0;
@@ -560,7 +559,7 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 	struct cdrom_info *info = drive->driver_data;
 	ide_startstop_t startstop;
 
-	if (info->cd_flags & IDE_CD_FLAG_DRQ_INTERRUPT) {
+	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
 		/*
 		 * Here we should have been called after receiving an interrupt
 		 * from the device.  DRQ should how be set.
@@ -589,7 +588,7 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 		cmd_len = ATAPI_MIN_CDB_BYTES;
 
 	/* send the command to the device */
-	hwif->output_data(drive, NULL, rq->cmd, cmd_len);
+	hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
 
 	/* start the DMA if need be */
 	if (info->dma)
@@ -606,6 +605,8 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 				int len, int ireason, int rw)
 {
+	ide_hwif_t *hwif = drive->hwif;
+
 	/*
 	 * ireason == 0: the drive wants to receive data from us
 	 * ireason == 2: the drive is expecting to transfer data to us
@@ -624,7 +625,7 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 		 * Some drives (ASUS) seem to tell us that status info is
 		 * available.  Just get it and ignore.
 		 */
-		(void)ide_read_status(drive);
+		(void)hwif->tp_ops->read_status(hwif);
 		return 0;
 	} else {
 		/* drive wants a command packet, or invalid ireason... */
@@ -645,20 +646,18 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
  */
 static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 {
-	struct cdrom_info *cd = drive->driver_data;
-
 	if ((len % SECTOR_SIZE) == 0)
 		return 0;
 
 	printk(KERN_ERR "%s: %s: Bad transfer size %d\n",
 			drive->name, __func__, len);
 
-	if (cd->cd_flags & IDE_CD_FLAG_LIMIT_NFRAMES)
+	if (drive->atapi_flags & IDE_AFLAG_LIMIT_NFRAMES)
 		printk(KERN_ERR "  This drive is not supported by "
 				"this version of the driver\n");
 	else {
 		printk(KERN_ERR "  Trying to limit transfer sizes\n");
-		cd->cd_flags |= IDE_CD_FLAG_LIMIT_NFRAMES;
+		drive->atapi_flags |= IDE_AFLAG_LIMIT_NFRAMES;
 	}
 
 	return 1;
@@ -735,7 +734,7 @@ static ide_startstop_t cdrom_seek_intr(ide_drive_t *drive)
 	if (cdrom_decode_status(drive, 0, &stat))
 		return ide_stopped;
 
-	info->cd_flags |= IDE_CD_FLAG_SEEKING;
+	drive->atapi_flags |= IDE_AFLAG_SEEKING;
 
 	if (retry && time_after(jiffies, info->start_seek + IDECD_SEEK_TIMER)) {
 		if (--retry == 0)
@@ -892,10 +891,11 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	struct request *rq = HWGROUP(drive)->rq;
 	xfer_func_t *xferfunc;
 	ide_expiry_t *expiry = NULL;
-	int dma_error = 0, dma, stat, ireason, len, thislen, uptodate = 0;
+	int dma_error = 0, dma, stat, thislen, uptodate = 0;
 	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0;
 	unsigned int timeout;
-	u8 lowcyl, highcyl;
+	u16 len;
+	u8 ireason;
 
 	/* check for errors */
 	dma = info->dma;
@@ -923,12 +923,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		goto end_request;
 	}
 
-	/* ok we fall to pio :/ */
-	ireason = hwif->INB(hwif->io_ports.nsect_addr) & 0x3;
-	lowcyl  = hwif->INB(hwif->io_ports.lbam_addr);
-	highcyl = hwif->INB(hwif->io_ports.lbah_addr);
-
-	len = lowcyl + (256 * highcyl);
+	ide_read_bcount_and_ireason(drive, &len, &ireason);
 
 	thislen = blk_fs_request(rq) ? len : rq->data_len;
 	if (thislen > len)
@@ -991,10 +986,10 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 
 	if (ireason == 0) {
 		write = 1;
-		xferfunc = hwif->output_data;
+		xferfunc = hwif->tp_ops->output_data;
 	} else {
 		write = 0;
-		xferfunc = hwif->input_data;
+		xferfunc = hwif->tp_ops->input_data;
 	}
 
 	/* transfer data */
@@ -1198,9 +1193,10 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 	int xferlen;
 
 	if (blk_fs_request(rq)) {
-		if (info->cd_flags & IDE_CD_FLAG_SEEKING) {
+		if (drive->atapi_flags & IDE_AFLAG_SEEKING) {
+			ide_hwif_t *hwif = drive->hwif;
 			unsigned long elapsed = jiffies - info->start_seek;
-			int stat = ide_read_status(drive);
+			int stat = hwif->tp_ops->read_status(hwif);
 
 			if ((stat & SEEK_STAT) != SEEK_STAT) {
 				if (elapsed < IDECD_SEEK_TIMEOUT) {
@@ -1211,7 +1207,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 				printk(KERN_ERR "%s: DSC timeout\n",
 						drive->name);
 			}
-			info->cd_flags &= ~IDE_CD_FLAG_SEEKING;
+			drive->atapi_flags &= ~IDE_AFLAG_SEEKING;
 		}
 		if (rq_data_dir(rq) == READ &&
 		    IDE_LARGE_SEEK(info->last_block, block,
@@ -1288,7 +1284,7 @@ int cdrom_check_status(ide_drive_t *drive, struct request_sense *sense)
 	 */
 	cmd[7] = cdi->sanyo_slot % 3;
 
-	return ide_cd_queue_pc(drive, cmd, 0, NULL, 0, sense, 0, REQ_QUIET);
+	return ide_cd_queue_pc(drive, cmd, 0, NULL, NULL, sense, 0, REQ_QUIET);
 }
 
 static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
@@ -1296,8 +1292,8 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 			       struct request_sense *sense)
 {
 	struct {
-		__u32 lba;
-		__u32 blocklen;
+		__be32 lba;
+		__be32 blocklen;
 	} capbuf;
 
 	int stat;
@@ -1369,7 +1365,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	 */
 	(void) cdrom_check_status(drive, sense);
 
-	if (info->cd_flags & IDE_CD_FLAG_TOC_VALID)
+	if (drive->atapi_flags & IDE_AFLAG_TOC_VALID)
 		return 0;
 
 	/* try to get the total cdrom capacity and sector size */
@@ -1391,7 +1387,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	if (stat)
 		return stat;
 
-	if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
+	if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
 		toc->hdr.first_track = BCD2BIN(toc->hdr.first_track);
 		toc->hdr.last_track  = BCD2BIN(toc->hdr.last_track);
 	}
@@ -1432,7 +1428,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		if (stat)
 			return stat;
 
-		if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
+		if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
 			toc->hdr.first_track = (u8)BIN2BCD(CDROM_LEADOUT);
 			toc->hdr.last_track = (u8)BIN2BCD(CDROM_LEADOUT);
 		} else {
@@ -1446,14 +1442,14 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 
 	toc->hdr.toc_length = be16_to_cpu(toc->hdr.toc_length);
 
-	if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
+	if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
 		toc->hdr.first_track = BCD2BIN(toc->hdr.first_track);
 		toc->hdr.last_track  = BCD2BIN(toc->hdr.last_track);
 	}
 
 	for (i = 0; i <= ntracks; i++) {
-		if (info->cd_flags & IDE_CD_FLAG_TOCADDR_AS_BCD) {
-			if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD)
+		if (drive->atapi_flags & IDE_AFLAG_TOCADDR_AS_BCD) {
+			if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD)
 				toc->ent[i].track = BCD2BIN(toc->ent[i].track);
 			msf_from_bcd(&toc->ent[i].addr.msf);
 		}
@@ -1476,7 +1472,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		toc->last_session_lba = msf_to_lba(0, 2, 0); /* 0m 2s 0f */
 	}
 
-	if (info->cd_flags & IDE_CD_FLAG_TOCADDR_AS_BCD) {
+	if (drive->atapi_flags & IDE_AFLAG_TOCADDR_AS_BCD) {
 		/* re-read multisession information using MSF format */
 		stat = cdrom_read_tocentry(drive, 0, 1, 1, (char *)&ms_tmp,
 					   sizeof(ms_tmp), sense);
@@ -1500,7 +1496,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	}
 
 	/* Remember that we've read this stuff. */
-	info->cd_flags |= IDE_CD_FLAG_TOC_VALID;
+	drive->atapi_flags |= IDE_AFLAG_TOC_VALID;
 
 	return 0;
 }
@@ -1512,7 +1508,7 @@ int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
 	struct packet_command cgc;
 	int stat, attempts = 3, size = ATAPI_CAPABILITIES_PAGE_SIZE;
 
-	if ((info->cd_flags & IDE_CD_FLAG_FULL_CAPS_PAGE) == 0)
+	if ((drive->atapi_flags & IDE_AFLAG_FULL_CAPS_PAGE) == 0)
 		size -= ATAPI_CAPABILITIES_PAGE_PAD_SIZE;
 
 	init_cdrom_command(&cgc, buf, size, CGC_DATA_UNKNOWN);
@@ -1530,15 +1526,12 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 	struct cdrom_info *cd = drive->driver_data;
 	u16 curspeed, maxspeed;
 
-	curspeed = *(u16 *)&buf[8 + 14];
-	maxspeed = *(u16 *)&buf[8 +  8];
-
-	if (cd->cd_flags & IDE_CD_FLAG_LE_SPEED_FIELDS) {
-		curspeed = le16_to_cpu(curspeed);
-		maxspeed = le16_to_cpu(maxspeed);
+	if (drive->atapi_flags & IDE_AFLAG_LE_SPEED_FIELDS) {
+		curspeed = le16_to_cpup((__le16 *)&buf[8 + 14]);
+		maxspeed = le16_to_cpup((__le16 *)&buf[8 + 8]);
 	} else {
-		curspeed = be16_to_cpu(curspeed);
-		maxspeed = be16_to_cpu(maxspeed);
+		curspeed = be16_to_cpup((__be16 *)&buf[8 + 14]);
+		maxspeed = be16_to_cpup((__be16 *)&buf[8 + 8]);
 	}
 
 	cd->current_speed = (curspeed + (176/2)) / 176;
@@ -1579,7 +1572,7 @@ static int ide_cdrom_register(ide_drive_t *drive, int nslots)
 	devinfo->handle = drive;
 	strcpy(devinfo->name, drive->name);
 
-	if (info->cd_flags & IDE_CD_FLAG_NO_SPEED_SELECT)
+	if (drive->atapi_flags & IDE_AFLAG_NO_SPEED_SELECT)
 		devinfo->mask |= CDC_SELECT_SPEED;
 
 	devinfo->disk = info->disk;
@@ -1605,8 +1598,8 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 		return nslots;
 	}
 
-	if (cd->cd_flags & IDE_CD_FLAG_PRE_ATAPI12) {
-		cd->cd_flags &= ~IDE_CD_FLAG_NO_EJECT;
+	if (drive->atapi_flags & IDE_AFLAG_PRE_ATAPI12) {
+		drive->atapi_flags &= ~IDE_AFLAG_NO_EJECT;
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 		return nslots;
 	}
@@ -1624,9 +1617,9 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 		return 0;
 
 	if ((buf[8 + 6] & 0x01) == 0)
-		cd->cd_flags |= IDE_CD_FLAG_NO_DOORLOCK;
+		drive->atapi_flags |= IDE_AFLAG_NO_DOORLOCK;
 	if (buf[8 + 6] & 0x08)
-		cd->cd_flags &= ~IDE_CD_FLAG_NO_EJECT;
+		drive->atapi_flags &= ~IDE_AFLAG_NO_EJECT;
 	if (buf[8 + 3] & 0x01)
 		cdi->mask &= ~CDC_CD_R;
 	if (buf[8 + 3] & 0x02)
@@ -1637,7 +1630,7 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 		cdi->mask &= ~(CDC_DVD_RAM | CDC_RAM);
 	if (buf[8 + 3] & 0x10)
 		cdi->mask &= ~CDC_DVD_R;
-	if ((buf[8 + 4] & 0x01) || (cd->cd_flags & IDE_CD_FLAG_PLAY_AUDIO_OK))
+	if ((buf[8 + 4] & 0x01) || (drive->atapi_flags & IDE_AFLAG_PLAY_AUDIO_OK))
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 
 	mechtype = buf[8 + 6] >> 5;
@@ -1679,7 +1672,7 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 	else
 		printk(KERN_CONT " drive");
 
-	printk(KERN_CONT ", %dkB Cache\n", be16_to_cpu(*(u16 *)&buf[8 + 12]));
+	printk(KERN_CONT ", %dkB Cache\n", be16_to_cpup((__be16 *)&buf[8 + 12]));
 
 	return nslots;
 }
@@ -1802,43 +1795,43 @@ static inline void ide_cdrom_add_settings(ide_drive_t *drive) { ; }
 
 static const struct cd_list_entry ide_cd_quirks_list[] = {
 	/* Limit transfer size per interrupt. */
-	{ "SAMSUNG CD-ROM SCR-2430", NULL,   IDE_CD_FLAG_LIMIT_NFRAMES	    },
-	{ "SAMSUNG CD-ROM SCR-2432", NULL,   IDE_CD_FLAG_LIMIT_NFRAMES	    },
+	{ "SAMSUNG CD-ROM SCR-2430", NULL,   IDE_AFLAG_LIMIT_NFRAMES	     },
+	{ "SAMSUNG CD-ROM SCR-2432", NULL,   IDE_AFLAG_LIMIT_NFRAMES	     },
 	/* SCR-3231 doesn't support the SET_CD_SPEED command. */
-	{ "SAMSUNG CD-ROM SCR-3231", NULL,   IDE_CD_FLAG_NO_SPEED_SELECT    },
+	{ "SAMSUNG CD-ROM SCR-3231", NULL,   IDE_AFLAG_NO_SPEED_SELECT	     },
 	/* Old NEC260 (not R) was released before ATAPI 1.2 spec. */
-	{ "NEC CD-ROM DRIVE:260",    "1.01", IDE_CD_FLAG_TOCADDR_AS_BCD |
-					     IDE_CD_FLAG_PRE_ATAPI12,	    },
+	{ "NEC CD-ROM DRIVE:260",    "1.01", IDE_AFLAG_TOCADDR_AS_BCD |
+					     IDE_AFLAG_PRE_ATAPI12,	     },
 	/* Vertos 300, some versions of this drive like to talk BCD. */
-	{ "V003S0DS",		     NULL,   IDE_CD_FLAG_VERTOS_300_SSD,    },
+	{ "V003S0DS",		     NULL,   IDE_AFLAG_VERTOS_300_SSD,	     },
 	/* Vertos 600 ESD. */
-	{ "V006E0DS",		     NULL,   IDE_CD_FLAG_VERTOS_600_ESD,    },
+	{ "V006E0DS",		     NULL,   IDE_AFLAG_VERTOS_600_ESD,	     },
 	/*
 	 * Sanyo 3 CD changer uses a non-standard command for CD changing
 	 * (by default standard ATAPI support for CD changers is used).
 	 */
-	{ "CD-ROM CDR-C3 G",	     NULL,   IDE_CD_FLAG_SANYO_3CD	    },
-	{ "CD-ROM CDR-C3G",	     NULL,   IDE_CD_FLAG_SANYO_3CD	    },
-	{ "CD-ROM CDR_C36",	     NULL,   IDE_CD_FLAG_SANYO_3CD	    },
+	{ "CD-ROM CDR-C3 G",	     NULL,   IDE_AFLAG_SANYO_3CD	     },
+	{ "CD-ROM CDR-C3G",	     NULL,   IDE_AFLAG_SANYO_3CD	     },
+	{ "CD-ROM CDR_C36",	     NULL,   IDE_AFLAG_SANYO_3CD	     },
 	/* Stingray 8X CD-ROM. */
-	{ "STINGRAY 8422 IDE 8X CD-ROM 7-27-95", NULL, IDE_CD_FLAG_PRE_ATAPI12},
+	{ "STINGRAY 8422 IDE 8X CD-ROM 7-27-95", NULL, IDE_AFLAG_PRE_ATAPI12 },
 	/*
 	 * ACER 50X CD-ROM and WPI 32X CD-ROM require the full spec length
 	 * mode sense page capabilities size, but older drives break.
 	 */
-	{ "ATAPI CD ROM DRIVE 50X MAX",	NULL,	IDE_CD_FLAG_FULL_CAPS_PAGE  },
-	{ "WPI CDS-32X",		NULL,	IDE_CD_FLAG_FULL_CAPS_PAGE  },
+	{ "ATAPI CD ROM DRIVE 50X MAX",	NULL,	IDE_AFLAG_FULL_CAPS_PAGE     },
+	{ "WPI CDS-32X",		NULL,	IDE_AFLAG_FULL_CAPS_PAGE     },
 	/* ACER/AOpen 24X CD-ROM has the speed fields byte-swapped. */
-	{ "",			     "241N", IDE_CD_FLAG_LE_SPEED_FIELDS    },
+	{ "",			     "241N", IDE_AFLAG_LE_SPEED_FIELDS       },
 	/*
 	 * Some drives used by Apple don't advertise audio play
 	 * but they do support reading TOC & audio datas.
 	 */
-	{ "MATSHITADVD-ROM SR-8187", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
-	{ "MATSHITADVD-ROM SR-8186", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
-	{ "MATSHITADVD-ROM SR-8176", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
-	{ "MATSHITADVD-ROM SR-8174", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
-	{ "Optiarc DVD RW AD-5200A", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK      },
+	{ "MATSHITADVD-ROM SR-8187", NULL,   IDE_AFLAG_PLAY_AUDIO_OK	     },
+	{ "MATSHITADVD-ROM SR-8186", NULL,   IDE_AFLAG_PLAY_AUDIO_OK	     },
+	{ "MATSHITADVD-ROM SR-8176", NULL,   IDE_AFLAG_PLAY_AUDIO_OK	     },
+	{ "MATSHITADVD-ROM SR-8174", NULL,   IDE_AFLAG_PLAY_AUDIO_OK	     },
+	{ "Optiarc DVD RW AD-5200A", NULL,   IDE_AFLAG_PLAY_AUDIO_OK	     },
 	{ NULL, NULL, 0 }
 };
 
@@ -1873,20 +1866,20 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 
 	drive->special.all	= 0;
 
-	cd->cd_flags = IDE_CD_FLAG_MEDIA_CHANGED | IDE_CD_FLAG_NO_EJECT |
+	drive->atapi_flags = IDE_AFLAG_MEDIA_CHANGED | IDE_AFLAG_NO_EJECT |
 		       ide_cd_flags(id);
 
 	if ((id->config & 0x0060) == 0x20)
-		cd->cd_flags |= IDE_CD_FLAG_DRQ_INTERRUPT;
+		drive->atapi_flags |= IDE_AFLAG_DRQ_INTERRUPT;
 
-	if ((cd->cd_flags & IDE_CD_FLAG_VERTOS_300_SSD) &&
+	if ((drive->atapi_flags & IDE_AFLAG_VERTOS_300_SSD) &&
 	    id->fw_rev[4] == '1' && id->fw_rev[6] <= '2')
-		cd->cd_flags |= (IDE_CD_FLAG_TOCTRACKS_AS_BCD |
-				 IDE_CD_FLAG_TOCADDR_AS_BCD);
-	else if ((cd->cd_flags & IDE_CD_FLAG_VERTOS_600_ESD) &&
+		drive->atapi_flags |= (IDE_AFLAG_TOCTRACKS_AS_BCD |
+				     IDE_AFLAG_TOCADDR_AS_BCD);
+	else if ((drive->atapi_flags & IDE_AFLAG_VERTOS_600_ESD) &&
 		 id->fw_rev[4] == '1' && id->fw_rev[6] <= '2')
-		cd->cd_flags |= IDE_CD_FLAG_TOCTRACKS_AS_BCD;
-	else if (cd->cd_flags & IDE_CD_FLAG_SANYO_3CD)
+		drive->atapi_flags |= IDE_AFLAG_TOCTRACKS_AS_BCD;
+	else if (drive->atapi_flags & IDE_AFLAG_SANYO_3CD)
 		/* 3 => use CD in slot 0 */
 		cdi->sanyo_slot = 3;
 
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index fe0ea36..61a4599 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -27,42 +27,6 @@
 #define ATAPI_CAPABILITIES_PAGE_SIZE		(8 + 20)
 #define ATAPI_CAPABILITIES_PAGE_PAD_SIZE	4
 
-enum {
-	/* Device sends an interrupt when ready for a packet command. */
-	IDE_CD_FLAG_DRQ_INTERRUPT	= (1 << 0),
-	/* Drive cannot lock the door. */
-	IDE_CD_FLAG_NO_DOORLOCK		= (1 << 1),
-	/* Drive cannot eject the disc. */
-	IDE_CD_FLAG_NO_EJECT		= (1 << 2),
-	/* Drive is a pre ATAPI 1.2 drive. */
-	IDE_CD_FLAG_PRE_ATAPI12		= (1 << 3),
-	/* TOC addresses are in BCD. */
-	IDE_CD_FLAG_TOCADDR_AS_BCD	= (1 << 4),
-	/* TOC track numbers are in BCD. */
-	IDE_CD_FLAG_TOCTRACKS_AS_BCD	= (1 << 5),
-	/*
-	 * Drive does not provide data in multiples of SECTOR_SIZE
-	 * when more than one interrupt is needed.
-	 */
-	IDE_CD_FLAG_LIMIT_NFRAMES	= (1 << 6),
-	/* Seeking in progress. */
-	IDE_CD_FLAG_SEEKING		= (1 << 7),
-	/* Driver has noticed a media change. */
-	IDE_CD_FLAG_MEDIA_CHANGED	= (1 << 8),
-	/* Saved TOC information is current. */
-	IDE_CD_FLAG_TOC_VALID		= (1 << 9),
-	/* We think that the drive door is locked. */
-	IDE_CD_FLAG_DOOR_LOCKED		= (1 << 10),
-	/* SET_CD_SPEED command is unsupported. */
-	IDE_CD_FLAG_NO_SPEED_SELECT	= (1 << 11),
-	IDE_CD_FLAG_VERTOS_300_SSD	= (1 << 12),
-	IDE_CD_FLAG_VERTOS_600_ESD	= (1 << 13),
-	IDE_CD_FLAG_SANYO_3CD		= (1 << 14),
-	IDE_CD_FLAG_FULL_CAPS_PAGE	= (1 << 15),
-	IDE_CD_FLAG_PLAY_AUDIO_OK	= (1 << 16),
-	IDE_CD_FLAG_LE_SPEED_FIELDS	= (1 << 17),
-};
-
 /* Structure of a MSF cdrom address. */
 struct atapi_msf {
 	byte reserved;
@@ -128,8 +92,6 @@ struct cdrom_info {
 	unsigned long last_block;
 	unsigned long start_seek;
 
-	unsigned int cd_flags;
-
 	u8 max_speed;		/* Max speed of the drive. */
 	u8 current_speed;	/* Current speed of the drive. */
 
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index 24d002a..74231b4 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -27,10 +27,9 @@ int ide_cdrom_open_real(struct cdrom_device_info *cdi, int purpose)
 void ide_cdrom_release_real(struct cdrom_device_info *cdi)
 {
 	ide_drive_t *drive = cdi->handle;
-	struct cdrom_info *cd = drive->driver_data;
 
 	if (!cdi->use_count)
-		cd->cd_flags &= ~IDE_CD_FLAG_TOC_VALID;
+		drive->atapi_flags &= ~IDE_AFLAG_TOC_VALID;
 }
 
 /*
@@ -83,13 +82,12 @@ int ide_cdrom_check_media_change_real(struct cdrom_device_info *cdi,
 				       int slot_nr)
 {
 	ide_drive_t *drive = cdi->handle;
-	struct cdrom_info *cd = drive->driver_data;
 	int retval;
 
 	if (slot_nr == CDSL_CURRENT) {
 		(void) cdrom_check_status(drive, NULL);
-		retval = (cd->cd_flags & IDE_CD_FLAG_MEDIA_CHANGED) ? 1 : 0;
-		cd->cd_flags &= ~IDE_CD_FLAG_MEDIA_CHANGED;
+		retval = (drive->atapi_flags & IDE_AFLAG_MEDIA_CHANGED) ? 1 : 0;
+		drive->atapi_flags &= ~IDE_AFLAG_MEDIA_CHANGED;
 		return retval;
 	} else {
 		return -EINVAL;
@@ -107,11 +105,11 @@ int cdrom_eject(ide_drive_t *drive, int ejectflag,
 	char loej = 0x02;
 	unsigned char cmd[BLK_MAX_CDB];
 
-	if ((cd->cd_flags & IDE_CD_FLAG_NO_EJECT) && !ejectflag)
+	if ((drive->atapi_flags & IDE_AFLAG_NO_EJECT) && !ejectflag)
 		return -EDRIVE_CANT_DO_THIS;
 
 	/* reload fails on some drives, if the tray is locked */
-	if ((cd->cd_flags & IDE_CD_FLAG_DOOR_LOCKED) && ejectflag)
+	if ((drive->atapi_flags & IDE_AFLAG_DOOR_LOCKED) && ejectflag)
 		return 0;
 
 	/* only tell drive to close tray if open, if it can do that */
@@ -123,7 +121,7 @@ int cdrom_eject(ide_drive_t *drive, int ejectflag,
 	cmd[0] = GPCMD_START_STOP_UNIT;
 	cmd[4] = loej | (ejectflag != 0);
 
-	return ide_cd_queue_pc(drive, cmd, 0, NULL, 0, sense, 0, 0);
+	return ide_cd_queue_pc(drive, cmd, 0, NULL, NULL, sense, 0, 0);
 }
 
 /* Lock the door if LOCKFLAG is nonzero; unlock it otherwise. */
@@ -131,7 +129,6 @@ static
 int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
 		    struct request_sense *sense)
 {
-	struct cdrom_info *cd = drive->driver_data;
 	struct request_sense my_sense;
 	int stat;
 
@@ -139,7 +136,7 @@ int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
 		sense = &my_sense;
 
 	/* If the drive cannot lock the door, just pretend. */
-	if (cd->cd_flags & IDE_CD_FLAG_NO_DOORLOCK) {
+	if (drive->atapi_flags & IDE_AFLAG_NO_DOORLOCK) {
 		stat = 0;
 	} else {
 		unsigned char cmd[BLK_MAX_CDB];
@@ -149,7 +146,7 @@ int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
 		cmd[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
 		cmd[4] = lockflag ? 1 : 0;
 
-		stat = ide_cd_queue_pc(drive, cmd, 0, NULL, 0,
+		stat = ide_cd_queue_pc(drive, cmd, 0, NULL, NULL,
 				       sense, 0, 0);
 	}
 
@@ -160,7 +157,7 @@ int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
 	    (sense->asc == 0x24 || sense->asc == 0x20)) {
 		printk(KERN_ERR "%s: door locking not supported\n",
 			drive->name);
-		cd->cd_flags |= IDE_CD_FLAG_NO_DOORLOCK;
+		drive->atapi_flags |= IDE_AFLAG_NO_DOORLOCK;
 		stat = 0;
 	}
 
@@ -170,9 +167,9 @@ int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
 
 	if (stat == 0) {
 		if (lockflag)
-			cd->cd_flags |= IDE_CD_FLAG_DOOR_LOCKED;
+			drive->atapi_flags |= IDE_AFLAG_DOOR_LOCKED;
 		else
-			cd->cd_flags &= ~IDE_CD_FLAG_DOOR_LOCKED;
+			drive->atapi_flags &= ~IDE_AFLAG_DOOR_LOCKED;
 	}
 
 	return stat;
@@ -231,7 +228,7 @@ int ide_cdrom_select_speed(struct cdrom_device_info *cdi, int speed)
 		cmd[5] = speed & 0xff;
 	}
 
-	stat = ide_cd_queue_pc(drive, cmd, 0, NULL, 0, &sense, 0, 0);
+	stat = ide_cd_queue_pc(drive, cmd, 0, NULL, NULL, &sense, 0, 0);
 
 	if (!ide_cdrom_get_capabilities(drive, buf)) {
 		ide_cdrom_update_speed(drive, buf);
@@ -250,7 +247,7 @@ int ide_cdrom_get_last_session(struct cdrom_device_info *cdi,
 	struct request_sense sense;
 	int ret;
 
-	if ((info->cd_flags & IDE_CD_FLAG_TOC_VALID) == 0 || !info->toc) {
+	if ((drive->atapi_flags & IDE_AFLAG_TOC_VALID) == 0 || !info->toc) {
 		ret = ide_cd_read_toc(drive, &sense);
 		if (ret)
 			return ret;
@@ -308,7 +305,7 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi)
 	 * A reset will unlock the door. If it was previously locked,
 	 * lock it again.
 	 */
-	if (cd->cd_flags & IDE_CD_FLAG_DOOR_LOCKED)
+	if (drive->atapi_flags & IDE_AFLAG_DOOR_LOCKED)
 		(void)ide_cd_lockdoor(drive, 1, &sense);
 
 	return ret;
@@ -324,7 +321,7 @@ static int ide_cd_get_toc_entry(ide_drive_t *drive, int track,
 	/*
 	 * don't serve cached data, if the toc isn't valid
 	 */
-	if ((info->cd_flags & IDE_CD_FLAG_TOC_VALID) == 0)
+	if ((drive->atapi_flags & IDE_AFLAG_TOC_VALID) == 0)
 		return -EINVAL;
 
 	/* Check validity of requested track number. */
@@ -374,7 +371,7 @@ static int ide_cd_fake_play_trkind(ide_drive_t *drive, void *arg)
 	lba_to_msf(lba_start,   &cmd[3], &cmd[4], &cmd[5]);
 	lba_to_msf(lba_end - 1, &cmd[6], &cmd[7], &cmd[8]);
 
-	return ide_cd_queue_pc(drive, cmd, 0, NULL, 0, &sense, 0, 0);
+	return ide_cd_queue_pc(drive, cmd, 0, NULL, NULL, &sense, 0, 0);
 }
 
 static int ide_cd_read_tochdr(ide_drive_t *drive, void *arg)
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 3a2e802..df5fe57 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -158,7 +158,7 @@ static void ide_tf_set_cmd(ide_drive_t *drive, ide_task_t *task, u8 dma)
 	write = (task->tf_flags & IDE_TFLAG_WRITE) ? 1 : 0;
 
 	if (dma)
-		index = drive->vdma ? 4 : 8;
+		index = 8;
 	else
 		index = drive->mult_count ? 0 : 4;
 
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 7ee44f8..be99d46 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -100,10 +100,11 @@ static const struct drive_list_entry drive_blacklist [] = {
  
 ide_startstop_t ide_dma_intr (ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	u8 stat = 0, dma_stat = 0;
 
-	dma_stat = drive->hwif->dma_ops->dma_end(drive);
-	stat = ide_read_status(drive);
+	dma_stat = hwif->dma_ops->dma_end(drive);
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat,DRIVE_READY,drive->bad_wstat|DRQ_STAT)) {
 		if (!dma_stat) {
@@ -334,7 +335,7 @@ static int config_drive_for_dma (ide_drive_t *drive)
 static int dma_timer_expiry (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_stat		= hwif->INB(hwif->dma_status);
+	u8 dma_stat		= hwif->tp_ops->read_sff_dma_status(hwif);
 
 	printk(KERN_WARNING "%s: dma_timer_expiry: dma status == 0x%02x\n",
 		drive->name, dma_stat);
@@ -369,14 +370,18 @@ void ide_dma_host_set(ide_drive_t *drive, int on)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	u8 unit			= (drive->select.b.unit & 0x01);
-	u8 dma_stat		= hwif->INB(hwif->dma_status);
+	u8 dma_stat		= hwif->tp_ops->read_sff_dma_status(hwif);
 
 	if (on)
 		dma_stat |= (1 << (5 + unit));
 	else
 		dma_stat &= ~(1 << (5 + unit));
 
-	hwif->OUTB(dma_stat, hwif->dma_status);
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writeb(dma_stat,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
+	else
+		outb(dma_stat, hwif->dma_base + ATA_DMA_STATUS);
 }
 
 EXPORT_SYMBOL_GPL(ide_dma_host_set);
@@ -449,6 +454,7 @@ int ide_dma_setup(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = HWGROUP(drive)->rq;
 	unsigned int reading;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 	u8 dma_stat;
 
 	if (rq_data_dir(rq))
@@ -470,13 +476,21 @@ int ide_dma_setup(ide_drive_t *drive)
 		outl(hwif->dmatable_dma, hwif->dma_base + ATA_DMA_TABLE_OFS);
 
 	/* specify r/w */
-	hwif->OUTB(reading, hwif->dma_command);
+	if (mmio)
+		writeb(reading, (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+	else
+		outb(reading, hwif->dma_base + ATA_DMA_CMD);
 
-	/* read dma_status for INTR & ERROR flags */
-	dma_stat = hwif->INB(hwif->dma_status);
+	/* read DMA status for INTR & ERROR flags */
+	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
 
 	/* clear INTR & ERROR flags */
-	hwif->OUTB(dma_stat|6, hwif->dma_status);
+	if (mmio)
+		writeb(dma_stat | 6,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
+	else
+		outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
+
 	drive->waiting_for_dma = 1;
 	return 0;
 }
@@ -492,16 +506,24 @@ EXPORT_SYMBOL_GPL(ide_dma_exec_cmd);
 
 void ide_dma_start(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_cmd		= hwif->INB(hwif->dma_command);
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_cmd;
 
 	/* Note that this is done *after* the cmd has
 	 * been issued to the drive, as per the BM-IDE spec.
 	 * The Promise Ultra33 doesn't work correctly when
 	 * we do this part before issuing the drive cmd.
 	 */
-	/* start DMA */
-	hwif->OUTB(dma_cmd|1, hwif->dma_command);
+	if (hwif->host_flags & IDE_HFLAG_MMIO) {
+		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+		/* start DMA */
+		writeb(dma_cmd | 1,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+	} else {
+		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
+		outb(dma_cmd | 1, hwif->dma_base + ATA_DMA_CMD);
+	}
+
 	hwif->dma = 1;
 	wmb();
 }
@@ -511,18 +533,33 @@ EXPORT_SYMBOL_GPL(ide_dma_start);
 /* returns 1 on error, 0 otherwise */
 int __ide_dma_end (ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 	u8 dma_stat = 0, dma_cmd = 0;
 
 	drive->waiting_for_dma = 0;
-	/* get dma_command mode */
-	dma_cmd = hwif->INB(hwif->dma_command);
-	/* stop DMA */
-	hwif->OUTB(dma_cmd&~1, hwif->dma_command);
+
+	if (mmio) {
+		/* get DMA command mode */
+		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+		/* stop DMA */
+		writeb(dma_cmd & ~1,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+	} else {
+		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
+		outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
+	}
+
 	/* get DMA status */
-	dma_stat = hwif->INB(hwif->dma_status);
-	/* clear the INTR & ERROR bits */
-	hwif->OUTB(dma_stat|6, hwif->dma_status);
+	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+
+	if (mmio)
+		/* clear the INTR & ERROR bits */
+		writeb(dma_stat | 6,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
+	else
+		outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
+
 	/* purge DMA mappings */
 	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
@@ -537,7 +574,7 @@ EXPORT_SYMBOL(__ide_dma_end);
 int ide_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_stat		= hwif->INB(hwif->dma_status);
+	u8 dma_stat		= hwif->tp_ops->read_sff_dma_status(hwif);
 
 	/* return 1 if INTR asserted */
 	if ((dma_stat & 4) == 4)
@@ -719,9 +756,8 @@ static int ide_tune_dma(ide_drive_t *drive)
 static int ide_dma_check(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	int vdma = (hwif->host_flags & IDE_HFLAG_VDMA)? 1 : 0;
 
-	if (!vdma && ide_tune_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	/* TODO: always do PIO fallback */
@@ -730,7 +766,7 @@ static int ide_dma_check(ide_drive_t *drive)
 
 	ide_set_max_pio(drive);
 
-	return vdma ? 0 : -1;
+	return -1;
 }
 
 int ide_id_dma_bug(ide_drive_t *drive)
@@ -842,7 +878,7 @@ int ide_allocate_dma_engine(ide_hwif_t *hwif)
 }
 EXPORT_SYMBOL_GPL(ide_allocate_dma_engine);
 
-static const struct ide_dma_ops sff_dma_ops = {
+const struct ide_dma_ops sff_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
@@ -852,18 +888,5 @@ static const struct ide_dma_ops sff_dma_ops = {
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
 };
-
-void ide_setup_dma(ide_hwif_t *hwif, unsigned long base)
-{
-	hwif->dma_base = base;
-
-	if (!hwif->dma_command)
-		hwif->dma_command	= hwif->dma_base + 0;
-	if (!hwif->dma_status)
-		hwif->dma_status	= hwif->dma_base + 2;
-
-	hwif->dma_ops = &sff_dma_ops;
-}
-
-EXPORT_SYMBOL_GPL(ide_setup_dma);
+EXPORT_SYMBOL_GPL(sff_dma_ops);
 #endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 011d720..3d8e6dd 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -125,26 +125,10 @@ typedef struct ide_floppy_obj {
 	int wp;
 	/* Supports format progress report */
 	int srfp;
-	/* Status/Action flags */
-	unsigned long flags;
 } idefloppy_floppy_t;
 
 #define IDEFLOPPY_TICKS_DELAY	HZ/20	/* default delay for ZIP 100 (50ms) */
 
-/* Floppy flag bits values. */
-enum {
-	/* DRQ interrupt device */
-	IDEFLOPPY_FLAG_DRQ_INTERRUPT		= (1 <<	0),
-	/* Media may have changed */
-	IDEFLOPPY_FLAG_MEDIA_CHANGED		= (1 << 1),
-	/* Format in progress */
-	IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS	= (1 << 2),
-	/* Avoid commands not supported in Clik drive */
-	IDEFLOPPY_FLAG_CLIK_DRIVE		= (1 << 3),
-	/* Requires BH algorithm for packets */
-	IDEFLOPPY_FLAG_ZIP_DRIVE		= (1 << 4),
-};
-
 /* Defines for the MODE SENSE command */
 #define MODE_SENSE_CURRENT		0x00
 #define MODE_SENSE_CHANGEABLE		0x01
@@ -247,9 +231,9 @@ static void ide_floppy_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 
 		data = bvec_kmap_irq(bvec, &flags);
 		if (direction)
-			hwif->output_data(drive, NULL, data, count);
+			hwif->tp_ops->output_data(drive, NULL, data, count);
 		else
-			hwif->input_data(drive, NULL, data, count);
+			hwif->tp_ops->input_data(drive, NULL, data, count);
 		bvec_kunmap_irq(data, &flags);
 
 		bcount -= count;
@@ -291,6 +275,7 @@ static void idefloppy_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd_flags |= REQ_PREEMPT;
 	rq->rq_disk = floppy->disk;
+	memcpy(rq->cmd, pc->c, 12);
 	ide_do_drive_cmd(drive, rq);
 }
 
@@ -354,7 +339,6 @@ static void idefloppy_init_pc(struct ide_atapi_pc *pc)
 	memset(pc, 0, sizeof(*pc));
 	pc->buf = pc->pc_buf;
 	pc->buf_size = IDEFLOPPY_PC_BUFFER_SIZE;
-	pc->callback = ide_floppy_callback;
 }
 
 static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
@@ -402,7 +386,7 @@ static int idefloppy_transfer_pc(ide_drive_t *drive)
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
 	/* Send the actual packet */
-	drive->hwif->output_data(drive, NULL, floppy->pc->c, 12);
+	drive->hwif->tp_ops->output_data(drive, NULL, floppy->pc->c, 12);
 
 	/* Timeout for the packet command */
 	return IDEFLOPPY_WAIT_CMD;
@@ -429,7 +413,7 @@ static ide_startstop_t idefloppy_start_pc_transfer(ide_drive_t *drive)
 	 * 40 and 50msec work well. idefloppy_pc_intr will not be actually
 	 * used until after the packet is moved in about 50 msec.
 	 */
-	if (pc->flags & PC_FLAG_ZIP_DRIVE) {
+	if (drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) {
 		timeout = floppy->ticks;
 		expiry = &idefloppy_transfer_pc;
 	} else {
@@ -474,7 +458,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		pc->error = IDEFLOPPY_ERROR_GENERAL;
 
 		floppy->failed_pc = NULL;
-		pc->callback(drive);
+		drive->pc_callback(drive);
 		return ide_stopped;
 	}
 
@@ -574,6 +558,8 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
 
+	memcpy(rq->cmd, pc->c, 12);
+
 	pc->rq = rq;
 	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
 	if (rq->cmd_flags & REQ_RW)
@@ -647,12 +633,6 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		return ide_stopped;
 	}
 
-	if (floppy->flags & IDEFLOPPY_FLAG_DRQ_INTERRUPT)
-		pc->flags |= PC_FLAG_DRQ_INTERRUPT;
-
-	if (floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE)
-		pc->flags |= PC_FLAG_ZIP_DRIVE;
-
 	pc->rq = rq;
 
 	return idefloppy_issue_pc(drive, pc);
@@ -671,6 +651,7 @@ static int idefloppy_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->buffer = (char *) pc;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
+	memcpy(rq->cmd, pc->c, 12);
 	error = blk_execute_rq(drive->queue, floppy->disk, rq, 0);
 	blk_put_request(rq);
 
@@ -795,7 +776,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		switch (pc.buf[desc_start + 4] & 0x03) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
-			if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE))
+			if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE))
 				/*
 				 * If it is not a clik drive, break out
 				 * (maintains previous driver behaviour)
@@ -841,7 +822,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
-	if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE))
+	if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE))
 		(void) ide_floppy_get_flexible_disk_page(drive);
 
 	set_capacity(floppy->disk, floppy->blocks * floppy->bs_factor);
@@ -949,11 +930,12 @@ static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 
 		/* Else assume format_unit has finished, and we're at 0x10000 */
 	} else {
+		ide_hwif_t *hwif = drive->hwif;
 		unsigned long flags;
 		u8 stat;
 
 		local_irq_save(flags);
-		stat = ide_read_status(drive);
+		stat = hwif->tp_ops->read_status(hwif);
 		local_irq_restore(flags);
 
 		progress_indication = ((stat & SEEK_STAT) == 0) ? 0 : 0x10000;
@@ -1039,9 +1021,10 @@ static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 
 	*((u16 *) &gcw) = drive->id->config;
 	floppy->pc = floppy->pc_stack;
+	drive->pc_callback = ide_floppy_callback;
 
 	if (((gcw[0] & 0x60) >> 5) == 1)
-		floppy->flags |= IDEFLOPPY_FLAG_DRQ_INTERRUPT;
+		drive->atapi_flags |= IDE_AFLAG_DRQ_INTERRUPT;
 	/*
 	 * We used to check revisions here. At this point however I'm giving up.
 	 * Just assume they are all broken, its easier.
@@ -1052,7 +1035,7 @@ static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	 * we'll leave the limitation below for the 2.2.x tree.
 	 */
 	if (!strncmp(drive->id->model, "IOMEGA ZIP 100 ATAPI", 20)) {
-		floppy->flags |= IDEFLOPPY_FLAG_ZIP_DRIVE;
+		drive->atapi_flags |= IDE_AFLAG_ZIP_DRIVE;
 		/* This value will be visible in the /proc/ide/hdx/settings */
 		floppy->ticks = IDEFLOPPY_TICKS_DELAY;
 		blk_queue_max_sectors(drive->queue, 64);
@@ -1064,7 +1047,7 @@ static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	 */
 	if (strncmp(drive->id->model, "IOMEGA Clik!", 11) == 0) {
 		blk_queue_max_sectors(drive->queue, 64);
-		floppy->flags |= IDEFLOPPY_FLAG_CLIK_DRIVE;
+		drive->atapi_flags |= IDE_AFLAG_CLIK_DRIVE;
 	}
 
 	(void) ide_floppy_get_capacity(drive);
@@ -1153,7 +1136,7 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 	floppy->openers++;
 
 	if (floppy->openers == 1) {
-		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
+		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
 		/* Just in case */
 
 		idefloppy_init_pc(&pc);
@@ -1180,14 +1163,14 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 			ret = -EROFS;
 			goto out_put_floppy;
 		}
-		floppy->flags |= IDEFLOPPY_FLAG_MEDIA_CHANGED;
+		drive->atapi_flags |= IDE_AFLAG_MEDIA_CHANGED;
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-		if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
+		if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE)) {
 			idefloppy_create_prevent_cmd(&pc, 1);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
 		check_disk_change(inode->i_bdev);
-	} else if (floppy->flags & IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS) {
+	} else if (drive->atapi_flags & IDE_AFLAG_FORMAT_IN_PROGRESS) {
 		ret = -EBUSY;
 		goto out_put_floppy;
 	}
@@ -1210,12 +1193,12 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 
 	if (floppy->openers == 1) {
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-		if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
+		if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE)) {
 			idefloppy_create_prevent_cmd(&pc, 0);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
 
-		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
+		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
 	}
 
 	floppy->openers--;
@@ -1236,15 +1219,17 @@ static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
-static int ide_floppy_lockdoor(idefloppy_floppy_t *floppy,
-		struct ide_atapi_pc *pc, unsigned long arg, unsigned int cmd)
+static int ide_floppy_lockdoor(ide_drive_t *drive, struct ide_atapi_pc *pc,
+			       unsigned long arg, unsigned int cmd)
 {
+	idefloppy_floppy_t *floppy = drive->driver_data;
+
 	if (floppy->openers > 1)
 		return -EBUSY;
 
 	/* The IOMEGA Clik! Drive doesn't support this command -
 	 * no room for an eject mechanism */
-	if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
+	if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE)) {
 		int prevent = arg ? 1 : 0;
 
 		if (cmd == CDROMEJECT)
@@ -1265,16 +1250,17 @@ static int ide_floppy_lockdoor(idefloppy_floppy_t *floppy,
 static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
 				  int __user *arg)
 {
-	int blocks, length, flags, err = 0;
 	struct ide_atapi_pc pc;
+	ide_drive_t *drive = floppy->drive;
+	int blocks, length, flags, err = 0;
 
 	if (floppy->openers > 1) {
 		/* Don't format if someone is using the disk */
-		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
+		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
 		return -EBUSY;
 	}
 
-	floppy->flags |= IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
+	drive->atapi_flags |= IDE_AFLAG_FORMAT_IN_PROGRESS;
 
 	/*
 	 * Send ATAPI_FORMAT_UNIT to the drive.
@@ -1298,15 +1284,15 @@ static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
 		goto out;
 	}
 
-	(void) idefloppy_get_sfrp_bit(floppy->drive);
+	(void) idefloppy_get_sfrp_bit(drive);
 	idefloppy_create_format_unit_cmd(&pc, blocks, length, flags);
 
-	if (idefloppy_queue_pc_tail(floppy->drive, &pc))
+	if (idefloppy_queue_pc_tail(drive, &pc))
 		err = -EIO;
 
 out:
 	if (err)
-		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
+		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
 	return err;
 }
 
@@ -1325,7 +1311,7 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 	case CDROMEJECT:
 		/* fall through */
 	case CDROM_LOCKDOOR:
-		return ide_floppy_lockdoor(floppy, &pc, arg, cmd);
+		return ide_floppy_lockdoor(drive, &pc, arg, cmd);
 	case IDEFLOPPY_IOCTL_FORMAT_SUPPORTED:
 		return 0;
 	case IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY:
@@ -1366,8 +1352,8 @@ static int idefloppy_media_changed(struct gendisk *disk)
 		drive->attach = 0;
 		return 0;
 	}
-	ret = !!(floppy->flags & IDEFLOPPY_FLAG_MEDIA_CHANGED);
-	floppy->flags &= ~IDEFLOPPY_FLAG_MEDIA_CHANGED;
+	ret = !!(drive->atapi_flags & IDE_AFLAG_MEDIA_CHANGED);
+	drive->atapi_flags &= ~IDE_AFLAG_MEDIA_CHANGED;
 	return ret;
 }
 
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 2d92214..31d98fe 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -28,29 +28,21 @@ MODULE_PARM_DESC(probe_mask, "probe mask for legacy ISA IDE ports");
 
 static ssize_t store_add(struct class *cls, const char *buf, size_t n)
 {
-	ide_hwif_t *hwif;
 	unsigned int base, ctl;
-	int irq;
-	hw_regs_t hw;
-	u8 idx[] = { 0xff, 0xff, 0xff, 0xff };
+	int irq, rc;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	if (sscanf(buf, "%x:%x:%d", &base, &ctl, &irq) != 3)
 		return -EINVAL;
 
-	hwif = ide_find_port();
-	if (hwif == NULL)
-		return -ENOENT;
-
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = irq;
 	hw.chipset = ide_generic;
 
-	ide_init_port_hw(hwif, &hw);
-
-	idx[0] = hwif->index;
-
-	ide_device_add(idx, NULL);
+	rc = ide_host_add(NULL, hws, NULL);
+	if (rc)
+		return rc;
 
 	return n;
 };
@@ -90,18 +82,18 @@ static int __init ide_generic_sysfs_init(void)
 
 static int __init ide_generic_init(void)
 {
-	u8 idx[MAX_HWIFS];
-	int i;
+	hw_regs_t hw[MAX_HWIFS], *hws[MAX_HWIFS];
+	struct ide_host *host;
+	unsigned long io_addr;
+	int i, rc;
 
 	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
 			 "parameter for probing all legacy ISA IDE ports\n");
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		ide_hwif_t *hwif;
-		unsigned long io_addr = ide_default_io_base(i);
-		hw_regs_t hw;
+		io_addr = ide_default_io_base(i);
 
-		idx[i] = 0xff;
+		hws[i] = NULL;
 
 		if ((probe_mask & (1 << i)) && io_addr) {
 			if (!request_region(io_addr, 8, DRV_NAME)) {
@@ -119,33 +111,42 @@ static int __init ide_generic_init(void)
 				continue;
 			}
 
-			/*
-			 * Skip probing if the corresponding
-			 * slot is already occupied.
-			 */
-			hwif = ide_find_port();
-			if (hwif == NULL || hwif->index != i) {
-				idx[i] = 0xff;
-				continue;
-			}
-
-			memset(&hw, 0, sizeof(hw));
-			ide_std_init_ports(&hw, io_addr, io_addr + 0x206);
-			hw.irq = ide_default_irq(io_addr);
-			hw.chipset = ide_generic;
-			ide_init_port_hw(hwif, &hw);
+			memset(&hw[i], 0, sizeof(hw[i]));
+			ide_std_init_ports(&hw[i], io_addr, io_addr + 0x206);
+			hw[i].irq = ide_default_irq(io_addr);
+			hw[i].chipset = ide_generic;
 
-			idx[i] = i;
+			hws[i] = &hw[i];
 		}
 	}
 
-	ide_device_add_all(idx, NULL);
+	host = ide_host_alloc_all(NULL, hws);
+	if (host == NULL) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	rc = ide_host_register(host, NULL, hws);
+	if (rc)
+		goto err_free;
 
 	if (ide_generic_sysfs_init())
 		printk(KERN_ERR DRV_NAME ": failed to create ide_generic "
 					 "class\n");
 
 	return 0;
+err_free:
+	ide_host_free(host);
+err:
+	for (i = 0; i < MAX_HWIFS; i++) {
+		if (hws[i] == NULL)
+			continue;
+
+		io_addr = hws[i]->io_ports.data_addr;
+		release_region(io_addr + 0x206, 1);
+		release_region(io_addr, 8);
+	}
+	return rc;
 }
 
 module_init(ide_generic_init);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 661b75a..a896a28 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -330,7 +330,7 @@ void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
 			tf->error = err;
 			tf->status = stat;
 
-			drive->hwif->tf_read(drive, task);
+			drive->hwif->tp_ops->tf_read(drive, task);
 
 			if (task->tf_flags & IDE_TFLAG_DYN)
 				kfree(task);
@@ -381,8 +381,7 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
 		if (err == ABRT_ERR) {
 			if (drive->select.b.lba &&
 			    /* some newer drives don't support WIN_SPECIFY */
-			    hwif->INB(hwif->io_ports.command_addr) ==
-				WIN_SPECIFY)
+			    hwif->tp_ops->read_status(hwif) == WIN_SPECIFY)
 				return ide_stopped;
 		} else if ((err & BAD_CRC) == BAD_CRC) {
 			/* UDMA crc error, just retry the operation */
@@ -408,7 +407,7 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
 		return ide_stopped;
 	}
 
-	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->tp_ops->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
 		rq->errors |= ERROR_RESET;
 
 	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
@@ -435,10 +434,9 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq, u
 		/* add decoding error stuff */
 	}
 
-	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->tp_ops->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTBSYNC(hwif, WIN_IDLEIMMEDIATE,
-			       hwif->io_ports.command_addr);
+		hwif->tp_ops->exec_command(hwif, WIN_IDLEIMMEDIATE);
 
 	if (rq->errors >= ERROR_MAX) {
 		ide_kill_rq(drive, rq);
@@ -712,7 +710,8 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 #ifdef DEBUG
  	printk("%s: DRIVE_CMD (null)\n", drive->name);
 #endif
-	ide_end_drive_cmd(drive, ide_read_status(drive), ide_read_error(drive));
+	ide_end_drive_cmd(drive, hwif->tp_ops->read_status(hwif),
+			  ide_read_error(drive));
 
  	return ide_stopped;
 }
@@ -747,16 +746,17 @@ static void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 		 * the bus may be broken enough to walk on our toes at this
 		 * point.
 		 */
+		ide_hwif_t *hwif = drive->hwif;
 		int rc;
 #ifdef DEBUG_PM
 		printk("%s: Wakeup request inited, waiting for !BSY...\n", drive->name);
 #endif
-		rc = ide_wait_not_busy(HWIF(drive), 35000);
+		rc = ide_wait_not_busy(hwif, 35000);
 		if (rc)
 			printk(KERN_WARNING "%s: bus not ready on wakeup\n", drive->name);
 		SELECT_DRIVE(drive);
-		ide_set_irq(drive, 1);
-		rc = ide_wait_not_busy(HWIF(drive), 100000);
+		hwif->tp_ops->set_irq(hwif, 1);
+		rc = ide_wait_not_busy(hwif, 100000);
 		if (rc)
 			printk(KERN_WARNING "%s: drive not ready on wakeup\n", drive->name);
 	}
@@ -1042,7 +1042,7 @@ static void ide_do_request (ide_hwgroup_t *hwgroup, int masked_irq)
 			 * quirk_list may not like intr setups/cleanups
 			 */
 			if (drive->quirk_list != 1)
-				ide_set_irq(drive, 0);
+				hwif->tp_ops->set_irq(hwif, 0);
 		}
 		hwgroup->hwif = hwif;
 		hwgroup->drive = drive;
@@ -1142,7 +1142,7 @@ static ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
 		(void)hwif->dma_ops->dma_end(drive);
 		ret = ide_error(drive, "dma timeout error",
-				ide_read_status(drive));
+				hwif->tp_ops->read_status(hwif));
 	} else {
 		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
 		hwif->dma_ops->dma_timeout(drive);
@@ -1267,7 +1267,7 @@ void ide_timer_expiry (unsigned long data)
 				} else
 					startstop =
 					ide_error(drive, "irq timeout",
-						  ide_read_status(drive));
+						  hwif->tp_ops->read_status(hwif));
 			}
 			drive->service_time = jiffies - drive->service_start;
 			spin_lock_irq(&ide_lock);
@@ -1323,7 +1323,8 @@ static void unexpected_intr (int irq, ide_hwgroup_t *hwgroup)
 	 */
 	do {
 		if (hwif->irq == irq) {
-			stat = hwif->INB(hwif->io_ports.status_addr);
+			stat = hwif->tp_ops->read_status(hwif);
+
 			if (!OK_STAT(stat, READY_STAT, BAD_STAT)) {
 				/* Try to not flood the console with msgs */
 				static unsigned long last_msgtime, count;
@@ -1413,7 +1414,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 			 * Whack the status register, just in case
 			 * we have a leftover pending IRQ.
 			 */
-			(void) hwif->INB(hwif->io_ports.status_addr);
+			(void)hwif->tp_ops->read_status(hwif);
 #endif /* CONFIG_BLK_DEV_IDEPCI */
 		}
 		spin_unlock_irqrestore(&ide_lock, flags);
@@ -1519,6 +1520,7 @@ EXPORT_SYMBOL(ide_do_drive_cmd);
 
 void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount, u8 dma)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	ide_task_t task;
 
 	memset(&task, 0, sizeof(task));
@@ -1529,9 +1531,9 @@ void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount, u8 dma)
 	task.tf.lbah    = (bcount >> 8) & 0xff;
 
 	ide_tf_dump(drive->name, &task.tf);
-	ide_set_irq(drive, 1);
+	hwif->tp_ops->set_irq(hwif, 1);
 	SELECT_MASK(drive, 0);
-	drive->hwif->tf_load(drive, &task);
+	hwif->tp_ops->tf_load(drive, &task);
 }
 
 EXPORT_SYMBOL_GPL(ide_pktcmd_tf_load);
@@ -1543,9 +1545,9 @@ void ide_pad_transfer(ide_drive_t *drive, int write, int len)
 
 	while (len > 0) {
 		if (write)
-			hwif->output_data(drive, NULL, buf, min(4, len));
+			hwif->tp_ops->output_data(drive, NULL, buf, min(4, len));
 		else
-			hwif->input_data(drive, NULL, buf, min(4, len));
+			hwif->tp_ops->input_data(drive, NULL, buf, min(4, len));
 		len -= 4;
 	}
 }
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 44aaec2..07da5fb 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -42,18 +42,6 @@ static void ide_outb (u8 val, unsigned long port)
 	outb(val, port);
 }
 
-static void ide_outbsync(ide_hwif_t *hwif, u8 addr, unsigned long port)
-{
-	outb(addr, port);
-}
-
-void default_hwif_iops (ide_hwif_t *hwif)
-{
-	hwif->OUTB	= ide_outb;
-	hwif->OUTBSYNC	= ide_outbsync;
-	hwif->INB	= ide_inb;
-}
-
 /*
  *	MMIO operations, typically used for SATA controllers
  */
@@ -68,31 +56,19 @@ static void ide_mm_outb (u8 value, unsigned long port)
 	writeb(value, (void __iomem *) port);
 }
 
-static void ide_mm_outbsync(ide_hwif_t *hwif, u8 value, unsigned long port)
-{
-	writeb(value, (void __iomem *) port);
-}
-
-void default_hwif_mmiops (ide_hwif_t *hwif)
-{
-	hwif->OUTB	= ide_mm_outb;
-	/* Most systems will need to override OUTBSYNC, alas however
-	   this one is controller specific! */
-	hwif->OUTBSYNC	= ide_mm_outbsync;
-	hwif->INB	= ide_mm_inb;
-}
-
-EXPORT_SYMBOL(default_hwif_mmiops);
-
 void SELECT_DRIVE (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
+	ide_task_t task;
 
 	if (port_ops && port_ops->selectproc)
 		port_ops->selectproc(drive);
 
-	hwif->OUTB(drive->select.all, hwif->io_ports.device_addr);
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_OUT_DEVICE;
+
+	drive->hwif->tp_ops->tf_load(drive, &task);
 }
 
 void SELECT_MASK(ide_drive_t *drive, int mask)
@@ -103,7 +79,61 @@ void SELECT_MASK(ide_drive_t *drive, int mask)
 		port_ops->maskproc(drive, mask);
 }
 
-static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+void ide_exec_command(ide_hwif_t *hwif, u8 cmd)
+{
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writeb(cmd, (void __iomem *)hwif->io_ports.command_addr);
+	else
+		outb(cmd, hwif->io_ports.command_addr);
+}
+EXPORT_SYMBOL_GPL(ide_exec_command);
+
+u8 ide_read_status(ide_hwif_t *hwif)
+{
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		return readb((void __iomem *)hwif->io_ports.status_addr);
+	else
+		return inb(hwif->io_ports.status_addr);
+}
+EXPORT_SYMBOL_GPL(ide_read_status);
+
+u8 ide_read_altstatus(ide_hwif_t *hwif)
+{
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		return readb((void __iomem *)hwif->io_ports.ctl_addr);
+	else
+		return inb(hwif->io_ports.ctl_addr);
+}
+EXPORT_SYMBOL_GPL(ide_read_altstatus);
+
+u8 ide_read_sff_dma_status(ide_hwif_t *hwif)
+{
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		return readb((void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
+	else
+		return inb(hwif->dma_base + ATA_DMA_STATUS);
+}
+EXPORT_SYMBOL_GPL(ide_read_sff_dma_status);
+
+void ide_set_irq(ide_hwif_t *hwif, int on)
+{
+	u8 ctl = ATA_DEVCTL_OBS;
+
+	if (on == 4) { /* hack for SRST */
+		ctl |= 4;
+		on &= ~4;
+	}
+
+	ctl |= on ? 0 : 2;
+
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writeb(ctl, (void __iomem *)hwif->io_ports.ctl_addr);
+	else
+		outb(ctl, hwif->io_ports.ctl_addr);
+}
+EXPORT_SYMBOL_GPL(ide_set_irq);
+
+void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -155,8 +185,9 @@ static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
 		tf_outb((tf->device & HIHI) | drive->select.all,
 			 io_ports->device_addr);
 }
+EXPORT_SYMBOL_GPL(ide_tf_load);
 
-static void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -188,6 +219,8 @@ static void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 	/* be sure we're looking at the low order bits */
 	tf_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
+	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+		tf->feature = tf_inb(io_ports->feature_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = tf_inb(io_ports->nsect_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
@@ -214,6 +247,7 @@ static void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 			tf->hob_lbah    = tf_inb(io_ports->lbah_addr);
 	}
 }
+EXPORT_SYMBOL_GPL(ide_tf_read);
 
 /*
  * Some localbus EIDE interfaces require a special access sequence
@@ -236,8 +270,8 @@ static void ata_vlb_sync(unsigned long port)
  * so if an odd len is specified, be sure that there's at least one
  * extra byte allocated for the buffer.
  */
-static void ata_input_data(ide_drive_t *drive, struct request *rq,
-			   void *buf, unsigned int len)
+void ide_input_data(ide_drive_t *drive, struct request *rq, void *buf,
+		    unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -277,12 +311,13 @@ static void ata_input_data(ide_drive_t *drive, struct request *rq,
 			insw(data_addr, buf, len / 2);
 	}
 }
+EXPORT_SYMBOL_GPL(ide_input_data);
 
 /*
  * This is used for most PIO data transfers *to* the IDE interface
  */
-static void ata_output_data(ide_drive_t *drive, struct request *rq,
-			    void *buf, unsigned int len)
+void ide_output_data(ide_drive_t *drive, struct request *rq, void *buf,
+		     unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -320,15 +355,50 @@ static void ata_output_data(ide_drive_t *drive, struct request *rq,
 			outsw(data_addr, buf, len / 2);
 	}
 }
+EXPORT_SYMBOL_GPL(ide_output_data);
+
+u8 ide_read_error(ide_drive_t *drive)
+{
+	ide_task_t task;
+
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_IN_FEATURE;
+
+	drive->hwif->tp_ops->tf_read(drive, &task);
+
+	return task.tf.error;
+}
+EXPORT_SYMBOL_GPL(ide_read_error);
 
-void default_hwif_transport(ide_hwif_t *hwif)
+void ide_read_bcount_and_ireason(ide_drive_t *drive, u16 *bcount, u8 *ireason)
 {
-	hwif->tf_load	  = ide_tf_load;
-	hwif->tf_read	  = ide_tf_read;
+	ide_task_t task;
+
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_IN_LBAH | IDE_TFLAG_IN_LBAM |
+			IDE_TFLAG_IN_NSECT;
 
-	hwif->input_data  = ata_input_data;
-	hwif->output_data = ata_output_data;
+	drive->hwif->tp_ops->tf_read(drive, &task);
+
+	*bcount = (task.tf.lbah << 8) | task.tf.lbam;
+	*ireason = task.tf.nsect & 3;
 }
+EXPORT_SYMBOL_GPL(ide_read_bcount_and_ireason);
+
+const struct ide_tp_ops default_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
 
 void ide_fix_driveid (struct hd_driveid *id)
 {
@@ -483,10 +553,10 @@ int drive_is_ready (ide_drive_t *drive)
 	 * about possible isa-pnp and pci-pnp issues yet.
 	 */
 	if (hwif->io_ports.ctl_addr)
-		stat = ide_read_altstatus(drive);
+		stat = hwif->tp_ops->read_altstatus(hwif);
 	else
 		/* Note: this may clear a pending IRQ!! */
-		stat = ide_read_status(drive);
+		stat = hwif->tp_ops->read_status(hwif);
 
 	if (stat & BUSY_STAT)
 		/* drive busy:  definitely not interrupting */
@@ -511,24 +581,26 @@ EXPORT_SYMBOL(drive_is_ready);
  */
 static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long timeout, u8 *rstat)
 {
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	unsigned long flags;
 	int i;
 	u8 stat;
 
 	udelay(1);	/* spec allows drive 400ns to assert "BUSY" */
-	stat = ide_read_status(drive);
+	stat = tp_ops->read_status(hwif);
 
 	if (stat & BUSY_STAT) {
 		local_irq_set(flags);
 		timeout += jiffies;
-		while ((stat = ide_read_status(drive)) & BUSY_STAT) {
+		while ((stat = tp_ops->read_status(hwif)) & BUSY_STAT) {
 			if (time_after(jiffies, timeout)) {
 				/*
 				 * One last read after the timeout in case
 				 * heavy interrupt load made us not make any
 				 * progress during the timeout..
 				 */
-				stat = ide_read_status(drive);
+				stat = tp_ops->read_status(hwif);
 				if (!(stat & BUSY_STAT))
 					break;
 
@@ -548,7 +620,7 @@ static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long ti
 	 */
 	for (i = 0; i < 10; i++) {
 		udelay(1);
-		stat = ide_read_status(drive);
+		stat = tp_ops->read_status(hwif);
 
 		if (OK_STAT(stat, good, bad)) {
 			*rstat = stat;
@@ -674,6 +746,7 @@ no_80w:
 int ide_driveid_update(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	struct hd_driveid *id;
 	unsigned long timeout, flags;
 	u8 stat;
@@ -684,9 +757,9 @@ int ide_driveid_update(ide_drive_t *drive)
 	 */
 
 	SELECT_MASK(drive, 1);
-	ide_set_irq(drive, 0);
+	tp_ops->set_irq(hwif, 0);
 	msleep(50);
-	hwif->OUTBSYNC(hwif, WIN_IDENTIFY, hwif->io_ports.command_addr);
+	tp_ops->exec_command(hwif, WIN_IDENTIFY);
 	timeout = jiffies + WAIT_WORSTCASE;
 	do {
 		if (time_after(jiffies, timeout)) {
@@ -695,11 +768,11 @@ int ide_driveid_update(ide_drive_t *drive)
 		}
 
 		msleep(50);	/* give drive a breather */
-		stat = ide_read_altstatus(drive);
+		stat = tp_ops->read_altstatus(hwif);
 	} while (stat & BUSY_STAT);
 
 	msleep(50);	/* wait for IRQ and DRQ_STAT */
-	stat = ide_read_status(drive);
+	stat = tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, DRQ_STAT, BAD_R_STAT)) {
 		SELECT_MASK(drive, 0);
@@ -713,8 +786,8 @@ int ide_driveid_update(ide_drive_t *drive)
 		local_irq_restore(flags);
 		return 0;
 	}
-	hwif->input_data(drive, NULL, id, SECTOR_SIZE);
-	(void)ide_read_status(drive);	/* clear drive IRQ */
+	tp_ops->input_data(drive, NULL, id, SECTOR_SIZE);
+	(void)tp_ops->read_status(hwif);	/* clear drive IRQ */
 	local_irq_enable();
 	local_irq_restore(flags);
 	ide_fix_driveid(id);
@@ -735,9 +808,10 @@ int ide_driveid_update(ide_drive_t *drive)
 int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int error = 0;
 	u8 stat;
+	ide_task_t task;
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	if (hwif->dma_ops)	/* check if host supports DMA */
@@ -770,12 +844,19 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 	SELECT_DRIVE(drive);
 	SELECT_MASK(drive, 0);
 	udelay(1);
-	ide_set_irq(drive, 0);
-	hwif->OUTB(speed, io_ports->nsect_addr);
-	hwif->OUTB(SETFEATURES_XFER, io_ports->feature_addr);
-	hwif->OUTBSYNC(hwif, WIN_SETFEATURES, io_ports->command_addr);
+	tp_ops->set_irq(hwif, 0);
+
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT;
+	task.tf.feature = SETFEATURES_XFER;
+	task.tf.nsect   = speed;
+
+	tp_ops->tf_load(drive, &task);
+
+	tp_ops->exec_command(hwif, WIN_SETFEATURES);
+
 	if (drive->quirk_list == 2)
-		ide_set_irq(drive, 1);
+		tp_ops->set_irq(hwif, 1);
 
 	error = __ide_wait_stat(drive, drive->ready_stat,
 				BUSY_STAT|DRQ_STAT|ERR_STAT,
@@ -796,8 +877,7 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 
  skip:
 #ifdef CONFIG_BLK_DEV_IDEDMA
-	if ((speed >= XFER_SW_DMA_0 || (hwif->host_flags & IDE_HFLAG_VDMA)) &&
-	    drive->using_dma)
+	if (speed >= XFER_SW_DMA_0 && drive->using_dma)
 		hwif->dma_ops->dma_host_set(drive, 1);
 	else if (hwif->dma_ops)	/* check if host supports DMA */
 		ide_dma_off_quietly(drive);
@@ -881,7 +961,7 @@ void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
 
 	spin_lock_irqsave(&ide_lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
-	hwif->OUTBSYNC(hwif, cmd, hwif->io_ports.command_addr);
+	hwif->tp_ops->exec_command(hwif, cmd);
 	/*
 	 * Drive takes 400nS to respond, we must avoid the IRQ being
 	 * serviced before that.
@@ -899,7 +979,7 @@ void ide_execute_pkt_cmd(ide_drive_t *drive)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ide_lock, flags);
-	hwif->OUTBSYNC(hwif, WIN_PACKETCMD, hwif->io_ports.command_addr);
+	hwif->tp_ops->exec_command(hwif, WIN_PACKETCMD);
 	ndelay(400);
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
@@ -924,12 +1004,13 @@ static ide_startstop_t do_reset1 (ide_drive_t *, int);
  */
 static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
 {
-	ide_hwgroup_t *hwgroup	= HWGROUP(drive);
+	ide_hwif_t *hwif = drive->hwif;
+	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	u8 stat;
 
 	SELECT_DRIVE(drive);
 	udelay (10);
-	stat = ide_read_status(drive);
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, 0, BUSY_STAT))
 		printk("%s: ATAPI reset complete\n", drive->name);
@@ -975,7 +1056,7 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 		}
 	}
 
-	tmp = ide_read_status(drive);
+	tmp = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(tmp, 0, BUSY_STAT)) {
 		if (time_before(jiffies, hwgroup->poll_timeout)) {
@@ -1089,8 +1170,8 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	ide_hwif_t *hwif;
 	ide_hwgroup_t *hwgroup;
 	struct ide_io_ports *io_ports;
+	const struct ide_tp_ops *tp_ops;
 	const struct ide_port_ops *port_ops;
-	u8 ctl;
 
 	spin_lock_irqsave(&ide_lock, flags);
 	hwif = HWIF(drive);
@@ -1098,6 +1179,8 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 
 	io_ports = &hwif->io_ports;
 
+	tp_ops = hwif->tp_ops;
+
 	/* We must not reset with running handlers */
 	BUG_ON(hwgroup->handler != NULL);
 
@@ -1106,7 +1189,7 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 		pre_reset(drive);
 		SELECT_DRIVE(drive);
 		udelay (20);
-		hwif->OUTBSYNC(hwif, WIN_SRST, io_ports->command_addr);
+		tp_ops->exec_command(hwif, WIN_SRST);
 		ndelay(400);
 		hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
 		hwgroup->polling = 1;
@@ -1135,16 +1218,15 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	 * immediate interrupt due to the edge transition it produces.
 	 * This single interrupt gives us a "fast poll" for drives that
 	 * recover from reset very quickly, saving us the first 50ms wait time.
+	 *
+	 * TODO: add ->softreset method and stop abusing ->set_irq
 	 */
 	/* set SRST and nIEN */
-	hwif->OUTBSYNC(hwif, ATA_DEVCTL_OBS | 6, io_ports->ctl_addr);
+	tp_ops->set_irq(hwif, 4);
 	/* more than enough time */
 	udelay(10);
-	if (drive->quirk_list == 2)
-		ctl = ATA_DEVCTL_OBS;		/* clear SRST and nIEN */
-	else
-		ctl = ATA_DEVCTL_OBS | 2;	/* clear SRST, leave nIEN */
-	hwif->OUTBSYNC(hwif, ctl, io_ports->ctl_addr);
+	/* clear SRST, leave nIEN (unless device is on the quirk list) */
+	tp_ops->set_irq(hwif, drive->quirk_list == 2);
 	/* more than enough time */
 	udelay(10);
 	hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
@@ -1189,7 +1271,7 @@ int ide_wait_not_busy(ide_hwif_t *hwif, unsigned long timeout)
 		 * about locking issues (2.5 work ?).
 		 */
 		mdelay(1);
-		stat = hwif->INB(hwif->io_ports.status_addr);
+		stat = hwif->tp_ops->read_status(hwif);
 		if ((stat & BUSY_STAT) == 0)
 			return 0;
 		/*
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 13af72f..97fefab 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -266,22 +266,11 @@ int ide_set_xfer_rate(ide_drive_t *drive, u8 rate)
 
 	rate = ide_rate_filter(drive, rate);
 
+	BUG_ON(rate < XFER_PIO_0);
+
 	if (rate >= XFER_PIO_0 && rate <= XFER_PIO_5)
 		return ide_set_pio_mode(drive, rate);
 
-	/*
-	 * TODO: transfer modes 0x00-0x07 passed from the user-space are
-	 * currently handled here which needs fixing (please note that such
-	 * case could happen iff the transfer mode has already been set on
-	 * the device by ide-proc.c::set_xfer_rate()).
-	 */
-	if (rate < XFER_PIO_0) {
-		if (hwif->host_flags & IDE_HFLAG_ABUSE_SET_DMA_MODE)
-			return ide_set_dma_mode(drive, rate);
-		else
-			return ide_config_drive_speed(drive, rate);
-	}
-
 	return ide_set_dma_mode(drive, rate);
 }
 
@@ -336,7 +325,7 @@ static void ide_dump_sector(ide_drive_t *drive)
 	else
 		task.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_DEVICE;
 
-	drive->hwif->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &task);
 
 	if (lba48 || (tf->device & ATA_LBA))
 		printk(", LBAsect=%llu",
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index 03f2ef5..bac9b39 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -29,9 +29,10 @@ static struct pnp_device_id idepnp_devices[] = {
 
 static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
-	hw_regs_t hw;
-	ide_hwif_t *hwif;
+	struct ide_host *host;
 	unsigned long base, ctl;
+	int rc;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	printk(KERN_INFO DRV_NAME ": generic PnP IDE interface\n");
 
@@ -59,31 +60,25 @@ static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	hw.irq = pnp_irq(dev, 0);
 	hw.chipset = ide_generic;
 
-	hwif = ide_find_port();
-	if (hwif) {
-		u8 index = hwif->index;
-		u8 idx[4] = { index, 0xff, 0xff, 0xff };
+	rc = ide_host_add(NULL, hws, &host);
+	if (rc)
+		goto out;
 
-		ide_init_port_hw(hwif, &hw);
-
-		pnp_set_drvdata(dev, hwif);
-
-		ide_device_add(idx, NULL);
-
-		return 0;
-	}
+	pnp_set_drvdata(dev, host);
 
+	return 0;
+out:
 	release_region(ctl, 1);
 	release_region(base, 8);
 
-	return -1;
+	return rc;
 }
 
 static void idepnp_remove(struct pnp_dev *dev)
 {
-	ide_hwif_t *hwif = pnp_get_drvdata(dev);
+	struct ide_host *host = pnp_get_drvdata(dev);
 
-	ide_unregister(hwif);
+	ide_host_remove(host);
 
 	release_region(pnp_port_start(dev, 1), 1);
 	release_region(pnp_port_start(dev, 0), 8);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 235ebdb..4aa76c4 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -39,8 +39,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-static ide_hwif_t ide_hwifs[MAX_HWIFS]; /* master data repository */
-
 /**
  *	generic_id		-	add a generic drive id
  *	@drive:	drive to make an ID block for
@@ -126,7 +124,7 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 
 	id = drive->id;
 	/* read 512 bytes of id info */
-	hwif->input_data(drive, NULL, id, SECTOR_SIZE);
+	hwif->tp_ops->input_data(drive, NULL, id, SECTOR_SIZE);
 
 	drive->id_read = 1;
 	local_irq_enable();
@@ -267,6 +265,7 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct ide_io_ports *io_ports = &hwif->io_ports;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int use_altstatus = 0, rc;
 	unsigned long timeout;
 	u8 s = 0, a = 0;
@@ -275,8 +274,8 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 	msleep(50);
 
 	if (io_ports->ctl_addr) {
-		a = ide_read_altstatus(drive);
-		s = ide_read_status(drive);
+		a = tp_ops->read_altstatus(hwif);
+		s = tp_ops->read_status(hwif);
 		if ((a ^ s) & ~INDEX_STAT)
 			/* ancient Seagate drives, broken interfaces */
 			printk(KERN_INFO "%s: probing with STATUS(0x%02x) "
@@ -290,12 +289,18 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 	/* set features register for atapi
 	 * identify command to be sure of reply
 	 */
-	if ((cmd == WIN_PIDENTIFY))
-		/* disable dma & overlap */
-		hwif->OUTB(0, io_ports->feature_addr);
+	if (cmd == WIN_PIDENTIFY) {
+		ide_task_t task;
+
+		memset(&task, 0, sizeof(task));
+		/* disable DMA & overlap */
+		task.tf_flags = IDE_TFLAG_OUT_FEATURE;
+
+		tp_ops->tf_load(drive, &task);
+	}
 
 	/* ask drive for ID */
-	hwif->OUTBSYNC(hwif, cmd, hwif->io_ports.command_addr);
+	tp_ops->exec_command(hwif, cmd);
 
 	timeout = ((cmd == WIN_IDENTIFY) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 	timeout += jiffies;
@@ -306,13 +311,13 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 		}
 		/* give drive a breather */
 		msleep(50);
-		s = use_altstatus ? ide_read_altstatus(drive)
-				  : ide_read_status(drive);
+		s = use_altstatus ? tp_ops->read_altstatus(hwif)
+				  : tp_ops->read_status(hwif);
 	} while (s & BUSY_STAT);
 
 	/* wait for IRQ and DRQ_STAT */
 	msleep(50);
-	s = ide_read_status(drive);
+	s = tp_ops->read_status(hwif);
 
 	if (OK_STAT(s, DRQ_STAT, BAD_R_STAT)) {
 		unsigned long flags;
@@ -324,7 +329,7 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 		/* drive responded with ID */
 		rc = 0;
 		/* clear drive IRQ */
-		(void)ide_read_status(drive);
+		(void)tp_ops->read_status(hwif);
 		local_irq_restore(flags);
 	} else {
 		/* drive refused ID */
@@ -346,6 +351,7 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 static int try_to_identify (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int retval;
 	int autoprobe = 0;
 	unsigned long cookie = 0;
@@ -361,7 +367,7 @@ static int try_to_identify (ide_drive_t *drive, u8 cmd)
 			autoprobe = 1;
 			cookie = probe_irq_on();
 		}
-		ide_set_irq(drive, autoprobe);
+		tp_ops->set_irq(hwif, autoprobe);
 	}
 
 	retval = actual_try_to_identify(drive, cmd);
@@ -369,9 +375,9 @@ static int try_to_identify (ide_drive_t *drive, u8 cmd)
 	if (autoprobe) {
 		int irq;
 
-		ide_set_irq(drive, 0);
+		tp_ops->set_irq(hwif, 0);
 		/* clear drive IRQ */
-		(void)ide_read_status(drive);
+		(void)tp_ops->read_status(hwif);
 		udelay(5);
 		irq = probe_irq_off(cookie);
 		if (!hwif->irq) {
@@ -396,7 +402,7 @@ static int ide_busy_sleep(ide_hwif_t *hwif)
 
 	do {
 		msleep(50);
-		stat = hwif->INB(hwif->io_ports.status_addr);
+		stat = hwif->tp_ops->read_status(hwif);
 		if ((stat & BUSY_STAT) == 0)
 			return 0;
 	} while (time_before(jiffies, timeout));
@@ -404,6 +410,18 @@ static int ide_busy_sleep(ide_hwif_t *hwif)
 	return 1;
 }
 
+static u8 ide_read_device(ide_drive_t *drive)
+{
+	ide_task_t task;
+
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_IN_DEVICE;
+
+	drive->hwif->tp_ops->tf_read(drive, &task);
+
+	return task.tf.device;
+}
+
 /**
  *	do_probe		-	probe an IDE device
  *	@drive: drive to probe
@@ -428,7 +446,7 @@ static int ide_busy_sleep(ide_hwif_t *hwif)
 static int do_probe (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	struct ide_io_ports *io_ports = &hwif->io_ports;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int rc;
 	u8 stat;
 
@@ -449,8 +467,8 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 	msleep(50);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	if (hwif->INB(io_ports->device_addr) != drive->select.all &&
-	    !drive->present) {
+
+	if (ide_read_device(drive) != drive->select.all && !drive->present) {
 		if (drive->select.b.unit != 0) {
 			/* exit with drive0 selected */
 			SELECT_DRIVE(&hwif->drives[0]);
@@ -461,7 +479,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 		return 3;
 	}
 
-	stat = ide_read_status(drive);
+	stat = tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, READY_STAT, BUSY_STAT) ||
 	    drive->present || cmd == WIN_PIDENTIFY) {
@@ -471,7 +489,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			rc = try_to_identify(drive,cmd);
 		}
 
-		stat = ide_read_status(drive);
+		stat = tp_ops->read_status(hwif);
 
 		if (stat == (BUSY_STAT | READY_STAT))
 			return 4;
@@ -482,13 +500,13 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			msleep(50);
 			SELECT_DRIVE(drive);
 			msleep(50);
-			hwif->OUTBSYNC(hwif, WIN_SRST, io_ports->command_addr);
+			tp_ops->exec_command(hwif, WIN_SRST);
 			(void)ide_busy_sleep(hwif);
 			rc = try_to_identify(drive, cmd);
 		}
 
 		/* ensure drive IRQ is clear */
-		stat = ide_read_status(drive);
+		stat = tp_ops->read_status(hwif);
 
 		if (rc == 1)
 			printk(KERN_ERR "%s: no response (status = 0x%02x)\n",
@@ -502,7 +520,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 		SELECT_DRIVE(&hwif->drives[0]);
 		msleep(50);
 		/* ensure drive irq is clear */
-		(void)ide_read_status(drive);
+		(void)tp_ops->read_status(hwif);
 	}
 	return rc;
 }
@@ -513,12 +531,13 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 static void enable_nest (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u8 stat;
 
 	printk("%s: enabling %s -- ", hwif->name, drive->id->model);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	hwif->OUTBSYNC(hwif, EXABYTE_ENABLE_NEST, hwif->io_ports.command_addr);
+	tp_ops->exec_command(hwif, EXABYTE_ENABLE_NEST);
 
 	if (ide_busy_sleep(hwif)) {
 		printk(KERN_CONT "failed (timeout)\n");
@@ -527,7 +546,7 @@ static void enable_nest (ide_drive_t *drive)
 
 	msleep(50);
 
-	stat = ide_read_status(drive);
+	stat = tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, 0, BAD_STAT))
 		printk(KERN_CONT "failed (status = 0x%02x)\n", stat);
@@ -619,7 +638,7 @@ static inline u8 probe_for_drive (ide_drive_t *drive)
 	return drive->present;
 }
 
-static void hwif_release_dev (struct device *dev)
+static void hwif_release_dev(struct device *dev)
 {
 	ide_hwif_t *hwif = container_of(dev, ide_hwif_t, gendev);
 
@@ -709,7 +728,7 @@ static int ide_port_wait_ready(ide_hwif_t *hwif)
 		/* Ignore disks that we will not probe for later. */
 		if (!drive->noprobe || drive->present) {
 			SELECT_DRIVE(drive);
-			ide_set_irq(drive, 1);
+			hwif->tp_ops->set_irq(hwif, 1);
 			mdelay(2);
 			rc = ide_wait_not_busy(hwif, 35000);
 			if (rc)
@@ -971,6 +990,45 @@ static void ide_port_setup_devices(ide_hwif_t *hwif)
 	mutex_unlock(&ide_cfg_mtx);
 }
 
+static ide_hwif_t *ide_ports[MAX_HWIFS];
+
+void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
+{
+	ide_hwgroup_t *hwgroup = hwif->hwgroup;
+
+	ide_ports[hwif->index] = NULL;
+
+	spin_lock_irq(&ide_lock);
+	/*
+	 * Remove us from the hwgroup, and free
+	 * the hwgroup if we were the only member
+	 */
+	if (hwif->next == hwif) {
+		BUG_ON(hwgroup->hwif != hwif);
+		kfree(hwgroup);
+	} else {
+		/* There is another interface in hwgroup.
+		 * Unlink us, and set hwgroup->drive and ->hwif to
+		 * something sane.
+		 */
+		ide_hwif_t *g = hwgroup->hwif;
+
+		while (g->next != hwif)
+			g = g->next;
+		g->next = hwif->next;
+		if (hwgroup->hwif == hwif) {
+			/* Chose a random hwif for hwgroup->hwif.
+			 * It's guaranteed that there are no drives
+			 * left in the hwgroup.
+			 */
+			BUG_ON(hwgroup->drive != NULL);
+			hwgroup->hwif = g;
+		}
+		BUG_ON(hwgroup->hwif == hwif);
+	}
+	spin_unlock_irq(&ide_lock);
+}
+
 /*
  * This routine sets up the irq for an ide interface, and creates a new
  * hwgroup for the irq/hwif if none was previously assigned.
@@ -998,8 +1056,9 @@ static int init_irq (ide_hwif_t *hwif)
 	 * Group up with any other hwifs that share our irq(s).
 	 */
 	for (index = 0; index < MAX_HWIFS; index++) {
-		ide_hwif_t *h = &ide_hwifs[index];
-		if (h->hwgroup) {  /* scan only initialized hwif's */
+		ide_hwif_t *h = ide_ports[index];
+
+		if (h && h->hwgroup) {  /* scan only initialized ports */
 			if (hwif->irq == h->irq) {
 				hwif->sharing_irq = h->sharing_irq = 1;
 				if (hwif->chipset != ide_pci ||
@@ -1053,6 +1112,8 @@ static int init_irq (ide_hwif_t *hwif)
 		hwgroup->timer.data = (unsigned long) hwgroup;
 	}
 
+	ide_ports[hwif->index] = hwif;
+
 	/*
 	 * Allocate the irq, if not already obtained for another hwif
 	 */
@@ -1066,8 +1127,7 @@ static int init_irq (ide_hwif_t *hwif)
 			sa = IRQF_SHARED;
 
 		if (io_ports->ctl_addr)
-			/* clear nIEN */
-			hwif->OUTBSYNC(hwif, ATA_DEVCTL_OBS, io_ports->ctl_addr);
+			hwif->tp_ops->set_irq(hwif, 1);
 
 		if (request_irq(hwif->irq,&ide_intr,sa,hwif->name,hwgroup))
 	       		goto out_unlink;
@@ -1345,6 +1405,9 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 	hwif->host_flags |= d->host_flags;
 	hwif->pio_mask = d->pio_mask;
 
+	if (d->tp_ops)
+		hwif->tp_ops = d->tp_ops;
+
 	/* ->set_pio_mode for DTC2278 is currently limited to port 0 */
 	if (hwif->chipset != ide_dtc2278 || hwif->channel == 0)
 		hwif->port_ops = d->port_ops;
@@ -1363,6 +1426,7 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 
 		if (rc < 0) {
 			printk(KERN_INFO "%s: DMA disabled\n", hwif->name);
+			hwif->dma_base = 0;
 			hwif->swdma_mask = 0;
 			hwif->mwdma_mask = 0;
 			hwif->ultra_mask = 0;
@@ -1446,18 +1510,20 @@ static int ide_sysfs_register_port(ide_hwif_t *hwif)
 	return rc;
 }
 
+static unsigned int ide_indexes;
+
 /**
- *	ide_find_port_slot	-	find free ide_hwifs[] slot
+ *	ide_find_port_slot	-	find free port slot
  *	@d: IDE port info
  *
- *	Return the new hwif.  If we are out of free slots return NULL.
+ *	Return the new port slot index or -ENOENT if we are out of free slots.
  */
 
-ide_hwif_t *ide_find_port_slot(const struct ide_port_info *d)
+static int ide_find_port_slot(const struct ide_port_info *d)
 {
-	ide_hwif_t *hwif;
-	int i;
+	int idx = -ENOENT;
 	u8 bootable = (d && (d->host_flags & IDE_HFLAG_NON_BOOTABLE)) ? 0 : 1;
+	u8 i = (d && (d->host_flags & IDE_HFLAG_QD_2ND_PORT)) ? 1 : 0;;
 
 	/*
 	 * Claim an unassigned slot.
@@ -1469,51 +1535,106 @@ ide_hwif_t *ide_find_port_slot(const struct ide_port_info *d)
 	 * Unless there is a bootable card that does not use the standard
 	 * ports 0x1f0/0x170 (the ide0/ide1 defaults).
 	 */
-	if (bootable) {
-		i = (d && (d->host_flags & IDE_HFLAG_QD_2ND_PORT)) ? 1 : 0;
-
-		for (; i < MAX_HWIFS; i++) {
-			hwif = &ide_hwifs[i];
-			if (hwif->chipset == ide_unknown)
-				goto out_found;
-		}
+	mutex_lock(&ide_cfg_mtx);
+	if (MAX_HWIFS == 1) {
+		if (ide_indexes == 0 && i == 0)
+			idx = 1;
 	} else {
-		for (i = 2; i < MAX_HWIFS; i++) {
-			hwif = &ide_hwifs[i];
-			if (hwif->chipset == ide_unknown)
-				goto out_found;
+		if (bootable) {
+			if ((ide_indexes | i) != (1 << MAX_HWIFS) - 1)
+				idx = ffz(ide_indexes | i);
+		} else {
+			if ((ide_indexes | 3) != (1 << MAX_HWIFS) - 1)
+				idx = ffz(ide_indexes | 3);
+			else if ((ide_indexes & 3) != 3)
+				idx = ffz(ide_indexes);
 		}
-		for (i = 0; i < 2 && i < MAX_HWIFS; i++) {
-			hwif = &ide_hwifs[i];
-			if (hwif->chipset == ide_unknown)
-				goto out_found;
+	}
+	if (idx >= 0)
+		ide_indexes |= (1 << idx);
+	mutex_unlock(&ide_cfg_mtx);
+
+	return idx;
+}
+
+static void ide_free_port_slot(int idx)
+{
+	mutex_lock(&ide_cfg_mtx);
+	ide_indexes &= ~(1 << idx);
+	mutex_unlock(&ide_cfg_mtx);
+}
+
+struct ide_host *ide_host_alloc_all(const struct ide_port_info *d,
+				    hw_regs_t **hws)
+{
+	struct ide_host *host;
+	int i;
+
+	host = kzalloc(sizeof(*host), GFP_KERNEL);
+	if (host == NULL)
+		return NULL;
+
+	for (i = 0; i < MAX_HWIFS; i++) {
+		ide_hwif_t *hwif;
+		int idx;
+
+		if (hws[i] == NULL)
+			continue;
+
+		hwif = kzalloc(sizeof(*hwif), GFP_KERNEL);
+		if (hwif == NULL)
+			continue;
+
+		idx = ide_find_port_slot(d);
+		if (idx < 0) {
+			printk(KERN_ERR "%s: no free slot for interface\n",
+					d ? d->name : "ide");
+			kfree(hwif);
+			continue;
 		}
+
+		ide_init_port_data(hwif, idx);
+
+		host->ports[i] = hwif;
+		host->n_ports++;
 	}
 
-	printk(KERN_ERR "%s: no free slot for interface\n",
-			d ? d->name : "ide");
+	if (host->n_ports == 0) {
+		kfree(host);
+		return NULL;
+	}
 
-	return NULL;
+	return host;
+}
+EXPORT_SYMBOL_GPL(ide_host_alloc_all);
+
+struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
+{
+	hw_regs_t *hws_all[MAX_HWIFS];
+	int i;
 
-out_found:
-	ide_init_port_data(hwif, i);
-	return hwif;
+	for (i = 0; i < MAX_HWIFS; i++)
+		hws_all[i] = (i < 4) ? hws[i] : NULL;
+
+	return ide_host_alloc_all(d, hws_all);
 }
-EXPORT_SYMBOL_GPL(ide_find_port_slot);
+EXPORT_SYMBOL_GPL(ide_host_alloc);
 
-int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
+int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
+		      hw_regs_t **hws)
 {
 	ide_hwif_t *hwif, *mate = NULL;
-	int i, rc = 0;
+	int i, j = 0;
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		if (idx[i] == 0xff) {
+		hwif = host->ports[i];
+
+		if (hwif == NULL) {
 			mate = NULL;
 			continue;
 		}
 
-		hwif = &ide_hwifs[idx[i]];
-
+		ide_init_port_hw(hwif, hws[i]);
 		ide_port_apply_params(hwif);
 
 		if (d == NULL) {
@@ -1534,10 +1655,10 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		if (idx[i] == 0xff)
-			continue;
+		hwif = host->ports[i];
 
-		hwif = &ide_hwifs[idx[i]];
+		if (hwif == NULL)
+			continue;
 
 		if (ide_probe_port(hwif) == 0)
 			hwif->present = 1;
@@ -1551,19 +1672,20 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		if (idx[i] == 0xff)
-			continue;
+		hwif = host->ports[i];
 
-		hwif = &ide_hwifs[idx[i]];
+		if (hwif == NULL)
+			continue;
 
 		if (hwif_init(hwif) == 0) {
 			printk(KERN_INFO "%s: failed to initialize IDE "
 					 "interface\n", hwif->name);
 			hwif->present = 0;
-			rc = -1;
 			continue;
 		}
 
+		j++;
+
 		if (hwif->present)
 			ide_port_setup_devices(hwif);
 
@@ -1574,10 +1696,10 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		if (idx[i] == 0xff)
-			continue;
+		hwif = host->ports[i];
 
-		hwif = &ide_hwifs[idx[i]];
+		if (hwif == NULL)
+			continue;
 
 		if (hwif->chipset == ide_unknown)
 			hwif->chipset = ide_generic;
@@ -1587,10 +1709,10 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		if (idx[i] == 0xff)
-			continue;
+		hwif = host->ports[i];
 
-		hwif = &ide_hwifs[idx[i]];
+		if (hwif == NULL)
+			continue;
 
 		ide_sysfs_register_port(hwif);
 		ide_proc_register_port(hwif);
@@ -1599,21 +1721,64 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 			ide_proc_port_register_devices(hwif);
 	}
 
-	return rc;
+	return j ? 0 : -1;
 }
-EXPORT_SYMBOL_GPL(ide_device_add_all);
+EXPORT_SYMBOL_GPL(ide_host_register);
 
-int ide_device_add(u8 idx[4], const struct ide_port_info *d)
+int ide_host_add(const struct ide_port_info *d, hw_regs_t **hws,
+		 struct ide_host **hostp)
 {
-	u8 idx_all[MAX_HWIFS];
+	struct ide_host *host;
+	int rc;
+
+	host = ide_host_alloc(d, hws);
+	if (host == NULL)
+		return -ENOMEM;
+
+	rc = ide_host_register(host, d, hws);
+	if (rc) {
+		ide_host_free(host);
+		return rc;
+	}
+
+	if (hostp)
+		*hostp = host;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_host_add);
+
+void ide_host_free(struct ide_host *host)
+{
+	ide_hwif_t *hwif;
 	int i;
 
-	for (i = 0; i < MAX_HWIFS; i++)
-		idx_all[i] = (i < 4) ? idx[i] : 0xff;
+	for (i = 0; i < MAX_HWIFS; i++) {
+		hwif = host->ports[i];
 
-	return ide_device_add_all(idx_all, d);
+		if (hwif == NULL)
+			continue;
+
+		ide_free_port_slot(hwif->index);
+		kfree(hwif);
+	}
+
+	kfree(host);
 }
-EXPORT_SYMBOL_GPL(ide_device_add);
+EXPORT_SYMBOL_GPL(ide_host_free);
+
+void ide_host_remove(struct ide_host *host)
+{
+	int i;
+
+	for (i = 0; i < MAX_HWIFS; i++) {
+		if (host->ports[i])
+			ide_unregister(host->ports[i]);
+	}
+
+	ide_host_free(host);
+}
+EXPORT_SYMBOL_GPL(ide_host_remove);
 
 void ide_port_scan(ide_hwif_t *hwif)
 {
@@ -1634,11 +1799,10 @@ void ide_port_scan(ide_hwif_t *hwif)
 }
 EXPORT_SYMBOL_GPL(ide_port_scan);
 
-static void ide_legacy_init_one(u8 *idx, hw_regs_t *hw, u8 port_no,
-				const struct ide_port_info *d,
+static void ide_legacy_init_one(hw_regs_t **hws, hw_regs_t *hw,
+				u8 port_no, const struct ide_port_info *d,
 				unsigned long config)
 {
-	ide_hwif_t *hwif;
 	unsigned long base, ctl;
 	int irq;
 
@@ -1668,33 +1832,25 @@ static void ide_legacy_init_one(u8 *idx, hw_regs_t *hw, u8 port_no,
 	ide_std_init_ports(hw, base, ctl);
 	hw->irq = irq;
 	hw->chipset = d->chipset;
+	hw->config = config;
 
-	hwif = ide_find_port_slot(d);
-	if (hwif) {
-		ide_init_port_hw(hwif, hw);
-		if (config)
-			hwif->config_data = config;
-		idx[port_no] = hwif->index;
-	}
+	hws[port_no] = hw;
 }
 
 int ide_legacy_device_add(const struct ide_port_info *d, unsigned long config)
 {
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
+	hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
 
 	memset(&hw, 0, sizeof(hw));
 
 	if ((d->host_flags & IDE_HFLAG_QD_2ND_PORT) == 0)
-		ide_legacy_init_one(idx, &hw[0], 0, d, config);
-	ide_legacy_init_one(idx, &hw[1], 1, d, config);
+		ide_legacy_init_one(hws, &hw[0], 0, d, config);
+	ide_legacy_init_one(hws, &hw[1], 1, d, config);
 
-	if (idx[0] == 0xff && idx[1] == 0xff &&
+	if (hws[0] == NULL && hws[1] == NULL &&
 	    (d->host_flags & IDE_HFLAG_SINGLE))
 		return -ENOENT;
 
-	ide_device_add(idx, d);
-
-	return 0;
+	return ide_host_add(d, hws, NULL);
 }
 EXPORT_SYMBOL_GPL(ide_legacy_device_add);
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 8af88bf..151c91e 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -345,7 +345,7 @@ static int set_xfer_rate (ide_drive_t *drive, int arg)
 	ide_task_t task;
 	int err;
 
-	if (arg < 0 || arg > 70)
+	if (arg < XFER_PIO_0 || arg > XFER_UDMA_6)
 		return -EINVAL;
 
 	memset(&task, 0, sizeof(task));
@@ -357,7 +357,7 @@ static int set_xfer_rate (ide_drive_t *drive, int arg)
 
 	err = ide_no_data_taskfile(drive, &task);
 
-	if (!err && arg) {
+	if (!err) {
 		ide_set_xfer_rate(drive, (u8) arg);
 		ide_driveid_update(drive);
 	}
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 353dd11..6962ca4 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -195,23 +195,6 @@ enum {
 #define IDETAPE_BLOCK_DESCRIPTOR	0
 #define IDETAPE_CAPABILITIES_PAGE	0x2a
 
-/* Tape flag bits values. */
-enum {
-	IDETAPE_FLAG_IGNORE_DSC		= (1 << 0),
-	/* 0 When the tape position is unknown */
-	IDETAPE_FLAG_ADDRESS_VALID	= (1 <<	1),
-	/* Device already opened */
-	IDETAPE_FLAG_BUSY		= (1 << 2),
-	/* Attempt to auto-detect the current user block size */
-	IDETAPE_FLAG_DETECT_BS		= (1 << 3),
-	/* Currently on a filemark */
-	IDETAPE_FLAG_FILEMARK		= (1 << 4),
-	/* DRQ interrupt device */
-	IDETAPE_FLAG_DRQ_INTERRUPT	= (1 << 5),
-	/* 0 = no tape is loaded, so we don't rewind after ejecting */
-	IDETAPE_FLAG_MEDIUM_PRESENT	= (1 << 6),
-};
-
 /*
  * Most of our global data which we need to save even as we leave the driver due
  * to an interrupt or a timer event is stored in the struct defined below.
@@ -312,8 +295,6 @@ typedef struct ide_tape_obj {
 	/* Wasted space in each stage */
 	int excess_bh_size;
 
-	/* Status/Action flags: long for set_bit */
-	unsigned long flags;
 	/* protects the ide-tape queue */
 	spinlock_t lock;
 
@@ -398,7 +379,7 @@ static void idetape_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		count = min(
 			(unsigned int)(bh->b_size - atomic_read(&bh->b_count)),
 			bcount);
-		drive->hwif->input_data(drive, NULL, bh->b_data +
+		drive->hwif->tp_ops->input_data(drive, NULL, bh->b_data +
 					atomic_read(&bh->b_count), count);
 		bcount -= count;
 		atomic_add(count, &bh->b_count);
@@ -424,7 +405,7 @@ static void idetape_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 			return;
 		}
 		count = min((unsigned int)pc->b_count, (unsigned int)bcount);
-		drive->hwif->output_data(drive, NULL, pc->b_data, count);
+		drive->hwif->tp_ops->output_data(drive, NULL, pc->b_data, count);
 		bcount -= count;
 		pc->b_data += count;
 		pc->b_count -= count;
@@ -585,7 +566,6 @@ static void ide_tape_kfree_buffer(idetape_tape_t *tape)
 		bh = bh->b_reqnext;
 		kfree(prev_bh);
 	}
-	kfree(tape->merge_bh);
 }
 
 static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
@@ -665,7 +645,7 @@ static void ide_tape_callback(ide_drive_t *drive)
 		if (readpos[0] & 0x4) {
 			printk(KERN_INFO "ide-tape: Block location is unknown"
 					 "to the tape\n");
-			clear_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags);
+			clear_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
 			uptodate = 0;
 		} else {
 			debug_log(DBG_SENSE, "Block Location - %u\n",
@@ -673,7 +653,7 @@ static void ide_tape_callback(ide_drive_t *drive)
 
 			tape->partition = readpos[1];
 			tape->first_frame = be32_to_cpu(*(u32 *)&readpos[4]);
-			set_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags);
+			set_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
 		}
 	}
 
@@ -690,7 +670,6 @@ static void idetape_init_pc(struct ide_atapi_pc *pc)
 	pc->buf_size = IDETAPE_PC_BUFFER_SIZE;
 	pc->bh = NULL;
 	pc->b_data = NULL;
-	pc->callback = ide_tape_callback;
 }
 
 static void idetape_create_request_sense_cmd(struct ide_atapi_pc *pc)
@@ -705,7 +684,7 @@ static void idetape_init_rq(struct request *rq, u8 cmd)
 {
 	blk_rq_init(NULL, rq);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd[0] = cmd;
+	rq->cmd[13] = cmd;
 }
 
 /*
@@ -732,6 +711,7 @@ static void idetape_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	rq->cmd_flags |= REQ_PREEMPT;
 	rq->buffer = (char *) pc;
 	rq->rq_disk = tape->disk;
+	memcpy(rq->cmd, pc->c, 12);
 	ide_do_drive_cmd(drive, rq);
 }
 
@@ -742,7 +722,6 @@ static void idetape_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
  */
 static void idetape_retry_pc(ide_drive_t *drive)
 {
-	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc;
 	struct request *rq;
 
@@ -750,7 +729,7 @@ static void idetape_retry_pc(ide_drive_t *drive)
 	pc = idetape_next_pc_storage(drive);
 	rq = idetape_next_rq_storage(drive);
 	idetape_create_request_sense_cmd(pc);
-	set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
+	set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
 	idetape_queue_pc_head(drive, pc, rq);
 }
 
@@ -887,7 +866,7 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 			pc->error = IDETAPE_ERROR_GENERAL;
 		}
 		tape->failed_pc = NULL;
-		pc->callback(drive);
+		drive->pc_callback(drive);
 		return ide_stopped;
 	}
 	debug_log(DBG_SENSE, "Retry #%d, cmd = %02X\n", pc->retries, pc->c[0]);
@@ -927,11 +906,12 @@ static void idetape_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
 
 static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = tape->pc;
 	u8 stat;
 
-	stat = ide_read_status(drive);
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (stat & SEEK_STAT) {
 		if (stat & ERR_STAT) {
@@ -948,14 +928,17 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 		pc->error = IDETAPE_ERROR_GENERAL;
 		tape->failed_pc = NULL;
 	}
-	pc->callback(drive);
+	drive->pc_callback(drive);
 	return ide_stopped;
 }
 
 static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
-		struct ide_atapi_pc *pc, unsigned int length,
-		struct idetape_bh *bh, u8 opcode)
+				   struct ide_atapi_pc *pc, struct request *rq,
+				   u8 opcode)
 {
+	struct idetape_bh *bh = (struct idetape_bh *)rq->special;
+	unsigned int length = rq->current_nr_sectors;
+
 	idetape_init_pc(pc);
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
@@ -975,11 +958,14 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 		pc->b_data = bh->b_data;
 		pc->b_count = atomic_read(&bh->b_count);
 	}
+
+	memcpy(rq->cmd, pc->c, 12);
 }
 
 static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 					  struct request *rq, sector_t block)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = NULL;
 	struct request *postponed_rq = tape->postponed_rq;
@@ -1017,17 +1003,17 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	 * If the tape is still busy, postpone our request and service
 	 * the other device meanwhile.
 	 */
-	stat = ide_read_status(drive);
+	stat = hwif->tp_ops->read_status(hwif);
 
-	if (!drive->dsc_overlap && !(rq->cmd[0] & REQ_IDETAPE_PC2))
-		set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
+	if (!drive->dsc_overlap && !(rq->cmd[13] & REQ_IDETAPE_PC2))
+		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
 
 	if (drive->post_reset == 1) {
-		set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
+		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
 		drive->post_reset = 0;
 	}
 
-	if (!test_and_clear_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags) &&
+	if (!test_and_clear_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags) &&
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
@@ -1036,7 +1022,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		} else if (time_after(jiffies, tape->dsc_timeout)) {
 			printk(KERN_ERR "ide-tape: %s: DSC timeout\n",
 				tape->name);
-			if (rq->cmd[0] & REQ_IDETAPE_PC2) {
+			if (rq->cmd[13] & REQ_IDETAPE_PC2) {
 				idetape_media_access_finished(drive);
 				return ide_stopped;
 			} else {
@@ -1049,35 +1035,29 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		idetape_postpone_request(drive);
 		return ide_stopped;
 	}
-	if (rq->cmd[0] & REQ_IDETAPE_READ) {
+	if (rq->cmd[13] & REQ_IDETAPE_READ) {
 		pc = idetape_next_pc_storage(drive);
-		ide_tape_create_rw_cmd(tape, pc, rq->current_nr_sectors,
-					(struct idetape_bh *)rq->special,
-					READ_6);
+		ide_tape_create_rw_cmd(tape, pc, rq, READ_6);
 		goto out;
 	}
-	if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
+	if (rq->cmd[13] & REQ_IDETAPE_WRITE) {
 		pc = idetape_next_pc_storage(drive);
-		ide_tape_create_rw_cmd(tape, pc, rq->current_nr_sectors,
-					 (struct idetape_bh *)rq->special,
-					 WRITE_6);
+		ide_tape_create_rw_cmd(tape, pc, rq, WRITE_6);
 		goto out;
 	}
-	if (rq->cmd[0] & REQ_IDETAPE_PC1) {
+	if (rq->cmd[13] & REQ_IDETAPE_PC1) {
 		pc = (struct ide_atapi_pc *) rq->buffer;
-		rq->cmd[0] &= ~(REQ_IDETAPE_PC1);
-		rq->cmd[0] |= REQ_IDETAPE_PC2;
+		rq->cmd[13] &= ~(REQ_IDETAPE_PC1);
+		rq->cmd[13] |= REQ_IDETAPE_PC2;
 		goto out;
 	}
-	if (rq->cmd[0] & REQ_IDETAPE_PC2) {
+	if (rq->cmd[13] & REQ_IDETAPE_PC2) {
 		idetape_media_access_finished(drive);
 		return ide_stopped;
 	}
 	BUG();
-out:
-	if (test_bit(IDETAPE_FLAG_DRQ_INTERRUPT, &tape->flags))
-		pc->flags |= PC_FLAG_DRQ_INTERRUPT;
 
+out:
 	return idetape_issue_pc(drive, pc);
 }
 
@@ -1281,8 +1261,9 @@ static int idetape_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd[0] = REQ_IDETAPE_PC1;
+	rq->cmd[13] = REQ_IDETAPE_PC1;
 	rq->buffer = (char *)pc;
+	memcpy(rq->cmd, pc->c, 12);
 	error = blk_execute_rq(drive->queue, tape->disk, rq, 0);
 	blk_put_request(rq);
 	return error;
@@ -1304,7 +1285,7 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	int load_attempted = 0;
 
 	/* Wait for the tape to become ready */
-	set_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags);
+	set_bit(IDE_AFLAG_MEDIUM_PRESENT, &drive->atapi_flags);
 	timeout += jiffies;
 	while (time_before(jiffies, timeout)) {
 		idetape_create_test_unit_ready_cmd(&pc);
@@ -1397,7 +1378,7 @@ static void __ide_tape_discard_merge_buffer(ide_drive_t *drive)
 	if (tape->chrdev_dir != IDETAPE_DIR_READ)
 		return;
 
-	clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags);
+	clear_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags);
 	tape->merge_bh_size = 0;
 	if (tape->merge_bh != NULL) {
 		ide_tape_kfree_buffer(tape);
@@ -1465,7 +1446,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd[0] = cmd;
+	rq->cmd[13] = cmd;
 	rq->rq_disk = tape->disk;
 	rq->special = (void *)bh;
 	rq->sector = tape->first_frame;
@@ -1636,7 +1617,7 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
 
 	/* If we are at a filemark, return a read length of 0 */
-	if (test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
+	if (test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags))
 		return 0;
 
 	idetape_init_read(drive);
@@ -1746,7 +1727,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
 		tape->merge_bh_size = 0;
-		if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
+		if (test_and_clear_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags))
 			++count;
 		ide_tape_discard_merge_buffer(drive, 0);
 	}
@@ -1801,7 +1782,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
-		if (test_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags))
+		if (test_bit(IDE_AFLAG_DETECT_BS, &drive->atapi_flags))
 			if (count > tape->blk_size &&
 			    (count % tape->blk_size) == 0)
 				tape->user_bs_factor = count / tape->blk_size;
@@ -1841,7 +1822,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		tape->merge_bh_size = bytes_read-temp;
 	}
 finish:
-	if (!actually_read && test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags)) {
+	if (!actually_read && test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags)) {
 		debug_log(DBG_SENSE, "%s: spacing over filemark\n", tape->name);
 
 		idetape_space_over_filemarks(drive, MTFSF, 1);
@@ -2027,7 +2008,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 					      !IDETAPE_LU_LOAD_MASK);
 		retval = idetape_queue_pc_tail(drive, &pc);
 		if (!retval)
-			clear_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags);
+			clear_bit(IDE_AFLAG_MEDIUM_PRESENT, &drive->atapi_flags);
 		return retval;
 	case MTNOP:
 		ide_tape_discard_merge_buffer(drive, 0);
@@ -2050,9 +2031,9 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			    mt_count % tape->blk_size)
 				return -EIO;
 			tape->user_bs_factor = mt_count / tape->blk_size;
-			clear_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags);
+			clear_bit(IDE_AFLAG_DETECT_BS, &drive->atapi_flags);
 		} else
-			set_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags);
+			set_bit(IDE_AFLAG_DETECT_BS, &drive->atapi_flags);
 		return 0;
 	case MTSEEK:
 		ide_tape_discard_merge_buffer(drive, 0);
@@ -2202,20 +2183,20 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = tape;
 
-	if (test_and_set_bit(IDETAPE_FLAG_BUSY, &tape->flags)) {
+	if (test_and_set_bit(IDE_AFLAG_BUSY, &drive->atapi_flags)) {
 		retval = -EBUSY;
 		goto out_put_tape;
 	}
 
 	retval = idetape_wait_ready(drive, 60 * HZ);
 	if (retval) {
-		clear_bit(IDETAPE_FLAG_BUSY, &tape->flags);
+		clear_bit(IDE_AFLAG_BUSY, &drive->atapi_flags);
 		printk(KERN_ERR "ide-tape: %s: drive not ready\n", tape->name);
 		goto out_put_tape;
 	}
 
 	idetape_read_position(drive);
-	if (!test_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags))
+	if (!test_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags))
 		(void)idetape_rewind_tape(drive);
 
 	/* Read block size and write protect status from drive. */
@@ -2231,7 +2212,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	if (tape->write_prot) {
 		if ((filp->f_flags & O_ACCMODE) == O_WRONLY ||
 		    (filp->f_flags & O_ACCMODE) == O_RDWR) {
-			clear_bit(IDETAPE_FLAG_BUSY, &tape->flags);
+			clear_bit(IDE_AFLAG_BUSY, &drive->atapi_flags);
 			retval = -EROFS;
 			goto out_put_tape;
 		}
@@ -2291,7 +2272,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 			ide_tape_discard_merge_buffer(drive, 1);
 	}
 
-	if (minor < 128 && test_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags))
+	if (minor < 128 && test_bit(IDE_AFLAG_MEDIUM_PRESENT, &drive->atapi_flags))
 		(void) idetape_rewind_tape(drive);
 	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
 		if (tape->door_locked == DOOR_LOCKED) {
@@ -2301,7 +2282,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 			}
 		}
 	}
-	clear_bit(IDETAPE_FLAG_BUSY, &tape->flags);
+	clear_bit(IDE_AFLAG_BUSY, &drive->atapi_flags);
 	ide_tape_put(tape);
 	unlock_kernel();
 	return 0;
@@ -2464,6 +2445,8 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	u8 gcw[2];
 	u16 *ctl = (u16 *)&tape->caps[12];
 
+	drive->pc_callback = ide_tape_callback;
+
 	spin_lock_init(&tape->lock);
 	drive->dsc_overlap = 1;
 	if (drive->hwif->host_flags & IDE_HFLAG_NO_DSC) {
@@ -2484,7 +2467,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 
 	/* Command packet DRQ type */
 	if (((gcw[0] & 0x60) >> 5) == 1)
-		set_bit(IDETAPE_FLAG_DRQ_INTERRUPT, &tape->flags);
+		set_bit(IDE_AFLAG_DRQ_INTERRUPT, &drive->atapi_flags);
 
 	idetape_get_inquiry_results(drive);
 	idetape_get_mode_sense_results(drive);
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 1fbdb74..aeddbbd 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -64,6 +64,7 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct ide_taskfile *tf = &task->tf;
 	ide_handler_t *handler = NULL;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
 
 	if (task->data_phase == TASKFILE_MULTI_IN ||
@@ -80,15 +81,15 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 
 	if ((task->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
 		ide_tf_dump(drive->name, tf);
-		ide_set_irq(drive, 1);
+		tp_ops->set_irq(hwif, 1);
 		SELECT_MASK(drive, 0);
-		hwif->tf_load(drive, task);
+		tp_ops->tf_load(drive, task);
 	}
 
 	switch (task->data_phase) {
 	case TASKFILE_MULTI_OUT:
 	case TASKFILE_OUT:
-		hwif->OUTBSYNC(hwif, tf->command, hwif->io_ports.command_addr);
+		tp_ops->exec_command(hwif, tf->command);
 		ndelay(400);	/* FIXME */
 		return pre_task_out_intr(drive, task->rq);
 	case TASKFILE_MULTI_IN:
@@ -124,7 +125,8 @@ EXPORT_SYMBOL_GPL(do_rw_taskfile);
  */
 static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
 {
-	u8 stat = ide_read_status(drive);
+	ide_hwif_t *hwif = drive->hwif;
+	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, READY_STAT, BAD_STAT))
 		drive->mult_count = drive->mult_req;
@@ -141,11 +143,16 @@ static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
  */
 static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	int retries = 5;
 	u8 stat;
 
-	while (((stat = ide_read_status(drive)) & BUSY_STAT) && retries--)
+	while (1) {
+		stat = hwif->tp_ops->read_status(hwif);
+		if ((stat & BUSY_STAT) == 0 || retries-- == 0)
+			break;
 		udelay(10);
+	};
 
 	if (OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_stopped;
@@ -162,7 +169,8 @@ static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
  */
 static ide_startstop_t recal_intr(ide_drive_t *drive)
 {
-	u8 stat = ide_read_status(drive);
+	ide_hwif_t *hwif = drive->hwif;
+	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_error(drive, "recal_intr", stat);
@@ -174,11 +182,12 @@ static ide_startstop_t recal_intr(ide_drive_t *drive)
  */
 static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 {
-	ide_task_t *args	= HWGROUP(drive)->rq->special;
+	ide_hwif_t *hwif = drive->hwif;
+	ide_task_t *args = hwif->hwgroup->rq->special;
 	u8 stat;
 
 	local_irq_enable_in_hardirq();
-	stat = ide_read_status(drive);
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_error(drive, "task_no_data_intr", stat);
@@ -192,6 +201,7 @@ static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 
 static u8 wait_drive_not_busy(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	int retries;
 	u8 stat;
 
@@ -200,7 +210,7 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	 * take up to 6 ms on some ATAPI devices, so we will wait max 10 ms.
 	 */
 	for (retries = 0; retries < 1000; retries++) {
-		stat = ide_read_status(drive);
+		stat = hwif->tp_ops->read_status(hwif);
 
 		if (stat & BUSY_STAT)
 			udelay(10);
@@ -255,9 +265,9 @@ static void ide_pio_sector(ide_drive_t *drive, struct request *rq,
 
 	/* do the actual data transfer */
 	if (write)
-		hwif->output_data(drive, rq, buf, SECTOR_SIZE);
+		hwif->tp_ops->output_data(drive, rq, buf, SECTOR_SIZE);
 	else
-		hwif->input_data(drive, rq, buf, SECTOR_SIZE);
+		hwif->tp_ops->input_data(drive, rq, buf, SECTOR_SIZE);
 
 	kunmap_atomic(buf, KM_BIO_SRC_IRQ);
 #ifdef CONFIG_HIGHMEM
@@ -383,8 +393,8 @@ static ide_startstop_t task_in_unexpected(ide_drive_t *drive, struct request *rq
 static ide_startstop_t task_in_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = HWGROUP(drive)->rq;
-	u8 stat = ide_read_status(drive);
+	struct request *rq = hwif->hwgroup->rq;
+	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	/* Error? */
 	if (stat & ERR_STAT)
@@ -418,7 +428,7 @@ static ide_startstop_t task_out_intr (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = HWGROUP(drive)->rq;
-	u8 stat = ide_read_status(drive);
+	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, DRIVE_READY, drive->bad_wstat))
 		return task_error(drive, rq, __func__, stat);
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index d4a6b10..60f0ca6 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1,6 +1,6 @@
 /*
  *  Copyright (C) 1994-1998	    Linus Torvalds & authors (see below)
- *  Copyrifht (C) 2003-2005, 2007   Bartlomiej Zolnierkiewicz
+ *  Copyright (C) 2003-2005, 2007   Bartlomiej Zolnierkiewicz
  */
 
 /*
@@ -101,8 +101,7 @@ void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
 
 	init_completion(&hwif->gendev_rel_comp);
 
-	default_hwif_iops(hwif);
-	default_hwif_transport(hwif);
+	hwif->tp_ops = &default_tp_ops;
 
 	ide_port_init_devices_data(hwif);
 }
@@ -134,41 +133,6 @@ static void ide_port_init_devices_data(ide_hwif_t *hwif)
 	}
 }
 
-void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
-{
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
-
-	spin_lock_irq(&ide_lock);
-	/*
-	 * Remove us from the hwgroup, and free
-	 * the hwgroup if we were the only member
-	 */
-	if (hwif->next == hwif) {
-		BUG_ON(hwgroup->hwif != hwif);
-		kfree(hwgroup);
-	} else {
-		/* There is another interface in hwgroup.
-		 * Unlink us, and set hwgroup->drive and ->hwif to
-		 * something sane.
-		 */
-		ide_hwif_t *g = hwgroup->hwif;
-
-		while (g->next != hwif)
-			g = g->next;
-		g->next = hwif->next;
-		if (hwgroup->hwif == hwif) {
-			/* Chose a random hwif for hwgroup->hwif.
-			 * It's guaranteed that there are no drives
-			 * left in the hwgroup.
-			 */
-			BUG_ON(hwgroup->drive != NULL);
-			hwgroup->hwif = g;
-		}
-		BUG_ON(hwgroup->hwif == hwif);
-	}
-	spin_unlock_irq(&ide_lock);
-}
-
 /* Called with ide_lock held. */
 static void __ide_port_unregister_devices(ide_hwif_t *hwif)
 {
@@ -269,16 +233,9 @@ void ide_unregister(ide_hwif_t *hwif)
 	if (hwif->dma_base)
 		ide_release_dma_engine(hwif);
 
-	spin_lock_irq(&ide_lock);
-	/* restore hwif data to pristine status */
-	ide_init_port_data(hwif, hwif->index);
-	spin_unlock_irq(&ide_lock);
-
 	mutex_unlock(&ide_cfg_mtx);
 }
 
-EXPORT_SYMBOL(ide_unregister);
-
 void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
 {
 	memcpy(&hwif->io_ports, &hw->io_ports, sizeof(hwif->io_ports));
@@ -287,8 +244,8 @@ void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
 	hwif->dev = hw->dev;
 	hwif->gendev.parent = hw->parent ? hw->parent : hw->dev;
 	hwif->ack_intr = hw->ack_intr;
+	hwif->config_data = hw->config;
 }
-EXPORT_SYMBOL_GPL(ide_init_port_hw);
 
 /*
  *	Locks for IDE setting functionality
diff --git a/drivers/ide/legacy/buddha.c b/drivers/ide/legacy/buddha.c
index 0497e7f..7c2afa9 100644
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -37,6 +37,8 @@
 #define CATWEASEL_NUM_HWIFS	3
 #define XSURF_NUM_HWIFS         2
 
+#define MAX_NUM_HWIFS		3
+
     /*
      *  Bases of the IDE interfaces (relative to the board address)
      */
@@ -148,18 +150,14 @@ static void __init buddha_setup_ports(hw_regs_t *hw, unsigned long base,
 
 static int __init buddha_init(void)
 {
-	hw_regs_t hw;
-	ide_hwif_t *hwif;
-	int i;
-
 	struct zorro_dev *z = NULL;
 	u_long buddha_board = 0;
 	BuddhaType type;
-	int buddha_num_hwifs;
+	int buddha_num_hwifs, i;
 
 	while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
 		unsigned long board;
-		u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+		hw_regs_t hw[MAX_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
 
 		if (z->id == ZORRO_PROD_INDIVIDUAL_COMPUTERS_BUDDHA) {
 			buddha_num_hwifs = BUDDHA_NUM_HWIFS;
@@ -221,19 +219,13 @@ fail_base2:
 				ack_intr = xsurf_ack_intr;
 			}
 
-			buddha_setup_ports(&hw, base, ctl, irq_port, ack_intr);
+			buddha_setup_ports(&hw[i], base, ctl, irq_port,
+					   ack_intr);
 
-			hwif = ide_find_port();
-			if (hwif) {
-				u8 index = hwif->index;
-
-				ide_init_port_hw(hwif, &hw);
-
-				idx[i] = index;
-			}
+			hws[i] = &hw[i];
 		}
 
-		ide_device_add(idx, NULL);
+		ide_host_add(NULL, hws, NULL);
 	}
 
 	return 0;
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index 129a812..724f950 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -66,6 +66,27 @@ static void falconide_output_data(ide_drive_t *drive, struct request *rq,
 	outsw_swapw(data_addr, buf, (len + 1) / 2);
 }
 
+/* Atari has a byte-swapped IDE interface */
+static const struct ide_tp_ops falconide_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= falconide_input_data,
+	.output_data		= falconide_output_data,
+};
+
+static const struct ide_port_info falconide_port_info = {
+	.tp_ops			= &falconide_tp_ops,
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static void __init falconide_setup_ports(hw_regs_t *hw)
 {
 	int i;
@@ -91,11 +112,12 @@ static void __init falconide_setup_ports(hw_regs_t *hw)
 
 static int __init falconide_init(void)
 {
-	hw_regs_t hw;
-	ide_hwif_t *hwif;
+	struct ide_host *host;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	int rc;
 
 	if (!MACH_IS_ATARI || !ATARIHW_PRESENT(IDE))
-		return 0;
+		return -ENODEV;
 
 	printk(KERN_INFO "ide: Falcon IDE controller\n");
 
@@ -106,23 +128,25 @@ static int __init falconide_init(void)
 
 	falconide_setup_ports(&hw);
 
-	hwif = ide_find_port();
-	if (hwif) {
-		u8 index = hwif->index;
-		u8 idx[4] = { index, 0xff, 0xff, 0xff };
-
-		ide_init_port_hw(hwif, &hw);
+	host = ide_host_alloc(&falconide_port_info, hws);
+	if (host == NULL) {
+		rc = -ENOMEM;
+		goto err;
+	}
 
-		/* Atari has a byte-swapped IDE interface */
-		hwif->input_data  = falconide_input_data;
-		hwif->output_data = falconide_output_data;
+	ide_get_lock(NULL, NULL);
+	rc = ide_host_register(host, &falconide_port_info, hws);
+	ide_release_lock();
 
-		ide_get_lock(NULL, NULL);
-		ide_device_add(idx, NULL);
-		ide_release_lock();
-	}
+	if (rc)
+		goto err_free;
 
 	return 0;
+err_free:
+	ide_host_free(host);
+err:
+	release_mem_region(ATA_HD_BASE, 0x40);
+	return rc;
 }
 
 module_init(falconide_init);
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index 7e74b20..dd5c467 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -31,6 +31,8 @@
 #define GAYLE_BASE_4000	0xdd2020	/* A4000/A4000T */
 #define GAYLE_BASE_1200	0xda0000	/* A1200/A600 and E-Matrix 530 */
 
+#define GAYLE_IDEREG_SIZE	0x2000
+
     /*
      *  Offsets from one of the above bases
      */
@@ -56,13 +58,11 @@
 #define GAYLE_NUM_HWIFS		1
 #define GAYLE_NUM_PROBE_HWIFS	GAYLE_NUM_HWIFS
 #define GAYLE_HAS_CONTROL_REG	1
-#define GAYLE_IDEREG_SIZE	0x2000
 #else /* CONFIG_BLK_DEV_IDEDOUBLER */
 #define GAYLE_NUM_HWIFS		2
 #define GAYLE_NUM_PROBE_HWIFS	(ide_doubler ? GAYLE_NUM_HWIFS : \
 					       GAYLE_NUM_HWIFS-1)
 #define GAYLE_HAS_CONTROL_REG	(!ide_doubler)
-#define GAYLE_IDEREG_SIZE	(ide_doubler ? 0x1000 : 0x2000)
 
 static int ide_doubler;
 module_param_named(doubler, ide_doubler, bool, 0);
@@ -124,8 +124,11 @@ static void __init gayle_setup_ports(hw_regs_t *hw, unsigned long base,
 
 static int __init gayle_init(void)
 {
+    unsigned long phys_base, res_start, res_n;
+    unsigned long base, ctrlport, irqport;
+    ide_ack_intr_t *ack_intr;
     int a4000, i;
-    u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+    hw_regs_t hw[GAYLE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
 
     if (!MACH_IS_AMIGA)
 	return -ENODEV;
@@ -148,13 +151,6 @@ found:
 #endif
 			 "");
 
-    for (i = 0; i < GAYLE_NUM_PROBE_HWIFS; i++) {
-	unsigned long base, ctrlport, irqport;
-	ide_ack_intr_t *ack_intr;
-	hw_regs_t hw;
-	ide_hwif_t *hwif;
-	unsigned long phys_base, res_start, res_n;
-
 	if (a4000) {
 	    phys_base = GAYLE_BASE_4000;
 	    irqport = (unsigned long)ZTWO_VADDR(GAYLE_IRQ_4000);
@@ -168,33 +164,22 @@ found:
  * FIXME: we now have selectable modes between mmio v/s iomio
  */
 
-	phys_base += i*GAYLE_NEXT_PORT;
-
 	res_start = ((unsigned long)phys_base) & ~(GAYLE_NEXT_PORT-1);
 	res_n = GAYLE_IDEREG_SIZE;
 
 	if (!request_mem_region(res_start, res_n, "IDE"))
-	    continue;
+		return -EBUSY;
 
-	base = (unsigned long)ZTWO_VADDR(phys_base);
+    for (i = 0; i < GAYLE_NUM_PROBE_HWIFS; i++) {
+	base = (unsigned long)ZTWO_VADDR(phys_base + i * GAYLE_NEXT_PORT);
 	ctrlport = GAYLE_HAS_CONTROL_REG ? (base + GAYLE_CONTROL) : 0;
 
-	gayle_setup_ports(&hw, base, ctrlport, irqport, ack_intr);
-
-	hwif = ide_find_port();
-	if (hwif) {
-	    u8 index = hwif->index;
+	gayle_setup_ports(&hw[i], base, ctrlport, irqport, ack_intr);
 
-	    ide_init_port_hw(hwif, &hw);
-
-	    idx[i] = index;
-	} else
-	    release_mem_region(res_start, res_n);
+	hws[i] = &hw[i];
     }
 
-    ide_device_add(idx, NULL);
-
-    return 0;
+    return ide_host_add(NULL, hws, NULL);
 }
 
 module_init(gayle_init);
diff --git a/drivers/ide/legacy/ide-4drives.c b/drivers/ide/legacy/ide-4drives.c
index 89c8ff0..c76d55d 100644
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -28,10 +28,8 @@ static const struct ide_port_info ide_4drives_port_info = {
 
 static int __init ide_4drives_init(void)
 {
-	ide_hwif_t *hwif, *mate;
 	unsigned long base = 0x1f0, ctl = 0x3f6;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw;
+	hw_regs_t hw, *hws[] = { &hw, &hw, NULL, NULL };
 
 	if (probe_4drives == 0)
 		return -ENODEV;
@@ -55,21 +53,7 @@ static int __init ide_4drives_init(void)
 	hw.irq = 14;
 	hw.chipset = ide_4drives;
 
-	hwif = ide_find_port();
-	if (hwif) {
-		ide_init_port_hw(hwif, &hw);
-		idx[0] = hwif->index;
-	}
-
-	mate = ide_find_port();
-	if (mate) {
-		ide_init_port_hw(mate, &hw);
-		idx[1] = mate->index;
-	}
-
-	ide_device_add(idx, &ide_4drives_port_info);
-
-	return 0;
+	return ide_host_add(&ide_4drives_port_info, hws, NULL);
 }
 
 module_init(ide_4drives_init);
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index 27b1e0b..21bfac1 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -74,7 +74,7 @@ INT_MODULE_PARM(pc_debug, 0);
 
 typedef struct ide_info_t {
 	struct pcmcia_device	*p_dev;
-	ide_hwif_t		*hwif;
+	struct ide_host		*host;
     int		ndev;
     dev_node_t	node;
 } ide_info_t;
@@ -132,7 +132,7 @@ static int ide_probe(struct pcmcia_device *link)
 static void ide_detach(struct pcmcia_device *link)
 {
     ide_info_t *info = link->priv;
-    ide_hwif_t *hwif = info->hwif;
+    ide_hwif_t *hwif = info->host->ports[0];
     unsigned long data_addr, ctl_addr;
 
     DEBUG(0, "ide_detach(0x%p)\n", link);
@@ -157,13 +157,13 @@ static const struct ide_port_info idecs_port_info = {
 	.host_flags		= IDE_HFLAG_NO_DMA,
 };
 
-static ide_hwif_t *idecs_register(unsigned long io, unsigned long ctl,
+static struct ide_host *idecs_register(unsigned long io, unsigned long ctl,
 				unsigned long irq, struct pcmcia_device *handle)
 {
+    struct ide_host *host;
     ide_hwif_t *hwif;
-    hw_regs_t hw;
-    int i;
-    u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+    int i, rc;
+    hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
     if (!request_region(io, 8, DRV_NAME)) {
 	printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
@@ -184,30 +184,24 @@ static ide_hwif_t *idecs_register(unsigned long io, unsigned long ctl,
     hw.chipset = ide_pci;
     hw.dev = &handle->dev;
 
-    hwif = ide_find_port();
-    if (hwif == NULL)
+    rc = ide_host_add(&idecs_port_info, hws, &host);
+    if (rc)
 	goto out_release;
 
-    i = hwif->index;
-
-    ide_init_port_hw(hwif, &hw);
-
-    idx[0] = i;
-
-    ide_device_add(idx, &idecs_port_info);
+    hwif = host->ports[0];
 
     if (hwif->present)
-	return hwif;
+	return host;
 
     /* retry registration in case device is still spinning up */
     for (i = 0; i < 10; i++) {
 	msleep(100);
 	ide_port_scan(hwif);
 	if (hwif->present)
-	    return hwif;
+	    return host;
     }
 
-    return hwif;
+    return host;
 
 out_release:
     release_region(ctl, 1);
@@ -239,7 +233,7 @@ static int ide_config(struct pcmcia_device *link)
     cistpl_cftable_entry_t *cfg;
     int pass, last_ret = 0, last_fn = 0, is_kme = 0;
     unsigned long io_base, ctl_base;
-    ide_hwif_t *hwif;
+    struct ide_host *host;
 
     DEBUG(0, "ide_config(0x%p)\n", link);
 
@@ -334,21 +328,21 @@ static int ide_config(struct pcmcia_device *link)
     if (is_kme)
 	outb(0x81, ctl_base+1);
 
-     hwif = idecs_register(io_base, ctl_base, link->irq.AssignedIRQ, link);
-     if (hwif == NULL && link->io.NumPorts1 == 0x20) {
+     host = idecs_register(io_base, ctl_base, link->irq.AssignedIRQ, link);
+     if (host == NULL && link->io.NumPorts1 == 0x20) {
 	    outb(0x02, ctl_base + 0x10);
-	    hwif = idecs_register(io_base + 0x10, ctl_base + 0x10,
+	    host = idecs_register(io_base + 0x10, ctl_base + 0x10,
 				  link->irq.AssignedIRQ, link);
     }
 
-    if (hwif == NULL)
+    if (host == NULL)
 	goto failed;
 
     info->ndev = 1;
-    sprintf(info->node.dev_name, "hd%c", 'a' + hwif->index * 2);
-    info->node.major = hwif->major;
+    sprintf(info->node.dev_name, "hd%c", 'a' + host->ports[0]->index * 2);
+    info->node.major = host->ports[0]->major;
     info->node.minor = 0;
-    info->hwif = hwif;
+    info->host = host;
     link->dev_node = &info->node;
     printk(KERN_INFO "ide-cs: %s: Vpp = %d.%d\n",
 	   info->node.dev_name, link->conf.Vpp / 10, link->conf.Vpp % 10);
@@ -379,15 +373,15 @@ failed:
 static void ide_release(struct pcmcia_device *link)
 {
     ide_info_t *info = link->priv;
-    ide_hwif_t *hwif = info->hwif;
+    struct ide_host *host = info->host;
 
     DEBUG(0, "ide_release(0x%p)\n", link);
 
-    if (info->ndev) {
+    if (info->ndev)
 	/* FIXME: if this fails we need to queue the cleanup somehow
 	   -- need to investigate the required PCMCIA magic */
-	ide_unregister(hwif);
-    }
+	ide_host_remove(host);
+
     info->ndev = 0;
 
     pcmcia_disable_device(link);
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
index a249562..051b4ab 100644
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -52,12 +52,10 @@ static int __devinit plat_ide_probe(struct platform_device *pdev)
 {
 	struct resource *res_base, *res_alt, *res_irq;
 	void __iomem *base, *alt_base;
-	ide_hwif_t *hwif;
 	struct pata_platform_info *pdata;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	int ret = 0;
-	int mmio = 0;
-	hw_regs_t hw;
+	struct ide_host *host;
+	int ret = 0, mmio = 0;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	struct ide_port_info d = platform_ide_port_info;
 
 	pdata = pdev->dev.platform_data;
@@ -94,28 +92,18 @@ static int __devinit plat_ide_probe(struct platform_device *pdev)
 			res_alt->start, res_alt->end - res_alt->start + 1);
 	}
 
-	hwif = ide_find_port();
-	if (!hwif) {
-		ret = -ENODEV;
-		goto out;
-	}
-
 	memset(&hw, 0, sizeof(hw));
 	plat_ide_setup_ports(&hw, base, alt_base, pdata, res_irq->start);
 	hw.dev = &pdev->dev;
 
-	ide_init_port_hw(hwif, &hw);
-
-	if (mmio) {
+	if (mmio)
 		d.host_flags |= IDE_HFLAG_MMIO;
-		default_hwif_mmiops(hwif);
-	}
 
-	idx[0] = hwif->index;
-
-	ide_device_add(idx, &d);
+	ret = ide_host_add(&d, hws, &host);
+	if (ret)
+		goto out;
 
-	platform_set_drvdata(pdev, hwif);
+	platform_set_drvdata(pdev, host);
 
 	return 0;
 
@@ -125,9 +113,9 @@ out:
 
 static int __devexit plat_ide_remove(struct platform_device *pdev)
 {
-	ide_hwif_t *hwif = pdev->dev.driver_data;
+	struct ide_host *host = pdev->dev.driver_data;
 
-	ide_unregister(hwif);
+	ide_host_remove(host);
 
 	return 0;
 }
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index 0a6195b..a0bb167 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -91,11 +91,10 @@ static const char *mac_ide_name[] =
 
 static int __init macide_init(void)
 {
-	ide_hwif_t *hwif;
 	ide_ack_intr_t *ack_intr;
 	unsigned long base;
 	int irq;
-	hw_regs_t hw;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	if (!MACH_IS_MAC)
 		return -ENODEV;
@@ -125,17 +124,7 @@ static int __init macide_init(void)
 
 	macide_setup_ports(&hw, base, irq, ack_intr);
 
-	hwif = ide_find_port();
-	if (hwif) {
-		u8 index = hwif->index;
-		u8 idx[4] = { index, 0xff, 0xff, 0xff };
-
-		ide_init_port_hw(hwif, &hw);
-
-		ide_device_add(idx, NULL);
-	}
-
-	return 0;
+	return ide_host_add(NULL, hws, NULL);
 }
 
 module_init(macide_init);
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index 9c2b9d0..4abd8fc 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -96,6 +96,27 @@ static void q40ide_output_data(ide_drive_t *drive, struct request *rq,
 	outsw_swapw(data_addr, buf, (len + 1) / 2);
 }
 
+/* Q40 has a byte-swapped IDE interface */
+static const struct ide_tp_ops q40ide_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= q40ide_input_data,
+	.output_data		= q40ide_output_data,
+};
+
+static const struct ide_port_info q40ide_port_info = {
+	.tp_ops			= &q40ide_tp_ops,
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 /* 
  * the static array is needed to have the name reported in /proc/ioports,
  * hwif->name unfortunately isn't available yet
@@ -111,9 +132,7 @@ static const char *q40_ide_names[Q40IDE_NUM_HWIFS]={
 static int __init q40ide_init(void)
 {
     int i;
-    ide_hwif_t *hwif;
-    const char *name;
-    u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+    hw_regs_t hw[Q40IDE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
 
     if (!MACH_IS_Q40)
       return -ENODEV;
@@ -121,9 +140,8 @@ static int __init q40ide_init(void)
     printk(KERN_INFO "ide: Q40 IDE controller\n");
 
     for (i = 0; i < Q40IDE_NUM_HWIFS; i++) {
-	hw_regs_t hw;
+	const char *name = q40_ide_names[i];
 
-	name = q40_ide_names[i];
 	if (!request_region(pcide_bases[i], 8, name)) {
 		printk("could not reserve ports %lx-%lx for %s\n",
 		       pcide_bases[i],pcide_bases[i]+8,name);
@@ -135,26 +153,13 @@ static int __init q40ide_init(void)
 		release_region(pcide_bases[i], 8);
 		continue;
 	}
-	q40_ide_setup_ports(&hw, pcide_bases[i],
-			NULL,
-//			m68kide_iops,
+	q40_ide_setup_ports(&hw[i], pcide_bases[i], NULL,
 			q40ide_default_irq(pcide_bases[i]));
 
-	hwif = ide_find_port();
-	if (hwif) {
-		ide_init_port_hw(hwif, &hw);
-
-		/* Q40 has a byte-swapped IDE interface */
-		hwif->input_data  = q40ide_input_data;
-		hwif->output_data = q40ide_output_data;
-
-		idx[i] = hwif->index;
-	}
+	hws[i] = &hw[i];
     }
 
-    ide_device_add(idx, NULL);
-
-    return 0;
+    return ide_host_add(&q40ide_port_info, hws, NULL);
 }
 
 module_init(q40ide_init);
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 48d57ca..11b7f61 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -519,6 +519,23 @@ static void auide_setup_ports(hw_regs_t *hw, _auide_hwif *ahwif)
 	*ata_regs = ahwif->regbase + (14 << IDE_REG_SHIFT);
 }
 
+#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA
+static const struct ide_tp_ops au1xxx_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= au1xxx_input_data,
+	.output_data		= au1xxx_output_data,
+};
+#endif
+
 static const struct ide_port_ops au1xxx_port_ops = {
 	.set_pio_mode		= au1xxx_set_pio_mode,
 	.set_dma_mode		= auide_set_dma_mode,
@@ -526,6 +543,9 @@ static const struct ide_port_ops au1xxx_port_ops = {
 
 static const struct ide_port_info au1xxx_port_info = {
 	.init_dma		= auide_ddma_init,
+#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA
+	.tp_ops			= &au1xxx_tp_ops,
+#endif
 	.port_ops		= &au1xxx_port_ops,
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 	.dma_ops		= &au1xxx_dma_ops,
@@ -543,11 +563,10 @@ static int au_ide_probe(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	_auide_hwif *ahwif = &auide_hwif;
-	ide_hwif_t *hwif;
 	struct resource *res;
+	struct ide_host *host;
 	int ret = 0;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA)
 	char *mode = "MWDMA2";
@@ -584,36 +603,19 @@ static int au_ide_probe(struct device *dev)
 		goto out;
 	}
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		ret = -ENOENT;
-		goto out;
-	}
-
 	memset(&hw, 0, sizeof(hw));
 	auide_setup_ports(&hw, ahwif);
 	hw.irq = ahwif->irq;
 	hw.dev = dev;
 	hw.chipset = ide_au1xxx;
 
-	ide_init_port_hw(hwif, &hw);
-
-	/* If the user has selected DDMA assisted copies,
-	   then set up a few local I/O function entry points 
-	*/
-
-#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA	
-	hwif->input_data  = au1xxx_input_data;
-	hwif->output_data = au1xxx_output_data;
-#endif
-
-	auide_hwif.hwif                 = hwif;
-
-	idx[0] = hwif->index;
+	ret = ide_host_add(&au1xxx_port_info, hws, &host);
+	if (ret)
+		goto out;
 
-	ide_device_add(idx, &au1xxx_port_info);
+	auide_hwif.hwif = host->ports[0];
 
-	dev_set_drvdata(dev, hwif);
+	dev_set_drvdata(dev, host);
 
 	printk(KERN_INFO "Au1xxx IDE(builtin) configured for %s\n", mode );
 
@@ -625,10 +627,10 @@ static int au_ide_remove(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct resource *res;
-	ide_hwif_t *hwif = dev_get_drvdata(dev);
+	struct ide_host *host = dev_get_drvdata(dev);
 	_auide_hwif *ahwif = &auide_hwif;
 
-	ide_unregister(hwif);
+	ide_host_remove(host);
 
 	iounmap((void *)ahwif->regbase);
 
diff --git a/drivers/ide/mips/swarm.c b/drivers/ide/mips/swarm.c
index 9f1212c..badf79f 100644
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -72,12 +72,11 @@ static const struct ide_port_info swarm_port_info = {
  */
 static int __devinit swarm_ide_probe(struct device *dev)
 {
-	ide_hwif_t *hwif;
 	u8 __iomem *base;
+	struct ide_host *host;
 	phys_t offset, size;
-	hw_regs_t hw;
-	int i;
-	u8 idx[] = { 0xff, 0xff, 0xff, 0xff };
+	int i, rc;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	if (!SIBYTE_HAVE_IDE)
 		return -ENODEV;
@@ -116,26 +115,17 @@ static int __devinit swarm_ide_probe(struct device *dev)
 	hw.irq = K_INT_GB_IDE;
 	hw.chipset = ide_generic;
 
-	hwif = ide_find_port_slot(&swarm_port_info);
-	if (hwif == NULL)
+	rc = ide_host_add(&swarm_port_info, hws, &host);
+	if (rc)
 		goto err;
 
-	ide_init_port_hw(hwif, &hw);
-
-	/* Setup MMIO ops. */
-	default_hwif_mmiops(hwif);
-
-	idx[0] = hwif->index;
-
-	ide_device_add(idx, &swarm_port_info);
-
-	dev_set_drvdata(dev, hwif);
+	dev_set_drvdata(dev, host);
 
 	return 0;
 err:
 	release_resource(&swarm_ide_resource);
 	iounmap(base);
-	return -ENOMEM;
+	return rc;
 }
 
 static struct device_driver swarm_ide_driver = {
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index ae7a432..fbc43e1 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -195,7 +195,6 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.host_flags	= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_ATAPI_DMA |
 				  IDE_HFLAG_NO_DSC |
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -205,7 +204,6 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_aec62xx,
 		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_NO_AUTODMA |
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -216,7 +214,6 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_NON_BOOTABLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -226,7 +223,6 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_aec62xx,
 		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -237,7 +233,6 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 80d19c0..5ef7817 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -471,7 +471,15 @@ static int __devinit init_dma_ali15x3(ide_hwif_t *hwif,
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long base = ide_pci_dma_base(hwif, d);
 
-	if (base == 0 || ide_pci_set_master(dev, d->name) < 0)
+	if (base == 0)
+		return -1;
+
+	hwif->dma_base = base;
+
+	if (ide_pci_check_simplex(hwif, d) < 0)
+		return -1;
+
+	if (ide_pci_set_master(dev, d->name) < 0)
 		return -1;
 
 	if (!hwif->channel)
@@ -483,7 +491,7 @@ static int __devinit init_dma_ali15x3(ide_hwif_t *hwif,
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	ide_setup_dma(hwif, base);
+	hwif->dma_ops = &sff_dma_ops;
 
 	return 0;
 }
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 0bfcdd0..ef7d971 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -218,7 +218,6 @@ static const struct ide_port_ops amd_port_ops = {
 
 #define IDE_HFLAGS_AMD \
 	(IDE_HFLAG_PIO_NO_BLACKLIST | \
-	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
 	 IDE_HFLAG_POST_SET_MODE | \
 	 IDE_HFLAG_IO_32BIT | \
 	 IDE_HFLAG_UNMASK_IRQS)
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index 1ad1e23..e6c6200 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -181,11 +181,6 @@ static u8 recovery_counts[4] = {16, 16, 16, 16}; /* Recovery count (encoded) */
 static DEFINE_SPINLOCK(cmd640_lock);
 
 /*
- * These are initialized to point at the devices we control
- */
-static ide_hwif_t  *cmd_hwif0, *cmd_hwif1;
-
-/*
  * Interface to access cmd640x registers
  */
 static unsigned int cmd640_key;
@@ -717,8 +712,7 @@ static int __init cmd640x_init(void)
 	int second_port_cmd640 = 0, rc;
 	const char *bus_type, *port2;
 	u8 b, cfr;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
+	hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
 
 	if (cmd640_vlb && probe_for_cmd640_vlb()) {
 		bus_type = "VLB";
@@ -781,15 +775,10 @@ static int __init cmd640x_init(void)
 	printk(KERN_INFO "cmd640: buggy cmd640%c interface on %s, config=0x%02x"
 			 "\n", 'a' + cmd640_chip_version - 1, bus_type, cfr);
 
-	cmd_hwif0 = ide_find_port();
-
 	/*
 	 * Initialize data for primary port
 	 */
-	if (cmd_hwif0) {
-		ide_init_port_hw(cmd_hwif0, &hw[0]);
-		idx[0] = cmd_hwif0->index;
-	}
+	hws[0] = &hw[0];
 
 	/*
 	 * Ensure compatibility by always using the slowest timings
@@ -829,13 +818,9 @@ static int __init cmd640x_init(void)
 	/*
 	 * Initialize data for secondary cmd640 port, if enabled
 	 */
-	if (second_port_cmd640) {
-		cmd_hwif1 = ide_find_port();
-		if (cmd_hwif1) {
-			ide_init_port_hw(cmd_hwif1, &hw[1]);
-			idx[1] = cmd_hwif1->index;
-		}
-	}
+	if (second_port_cmd640)
+		hws[1] = &hw[1];
+
 	printk(KERN_INFO "cmd640: %sserialized, secondary interface %s\n",
 			 second_port_cmd640 ? "" : "not ", port2);
 
@@ -843,9 +828,7 @@ static int __init cmd640x_init(void)
 	cmd640_dump_regs();
 #endif
 
-	ide_device_add(idx, &cmd640_port_info);
-
-	return 1;
+	return ide_host_add(&cmd640_port_info, hws, NULL);
 }
 
 module_param_named(probe_vlb, cmd640_vlb, bool, 0);
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index cfa784b..ce58bfc 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -262,7 +262,7 @@ static int cmd648_dma_test_irq(ide_drive_t *drive)
 	unsigned long base	= hwif->dma_base - (hwif->channel * 8);
 	u8 irq_mask		= hwif->channel ? MRDMODE_INTR_CH1 :
 						  MRDMODE_INTR_CH0;
-	u8 dma_stat		= inb(hwif->dma_status);
+	u8 dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 	u8 mrdmode		= inb(base + 1);
 
 #ifdef DEBUG
@@ -286,7 +286,7 @@ static int cmd64x_dma_test_irq(ide_drive_t *drive)
 	int irq_reg		= hwif->channel ? ARTTIM23 : CFR;
 	u8  irq_mask		= hwif->channel ? ARTTIM23_INTR_CH1 :
 						  CFR_INTR_CH0;
-	u8  dma_stat		= inb(hwif->dma_status);
+	u8  dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 	u8  irq_stat		= 0;
 
 	(void) pci_read_config_byte(dev, irq_reg, &irq_stat);
@@ -317,13 +317,13 @@ static int cmd646_1_dma_end(ide_drive_t *drive)
 
 	drive->waiting_for_dma = 0;
 	/* get DMA status */
-	dma_stat = inb(hwif->dma_status);
+	dma_stat = inb(hwif->dma_base + ATA_DMA_STATUS);
 	/* read DMA command state */
-	dma_cmd = inb(hwif->dma_command);
+	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	/* stop DMA */
-	outb(dma_cmd & ~1, hwif->dma_command);
+	outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
 	/* clear the INTR & ERROR bits */
-	outb(dma_stat | 6, hwif->dma_status);
+	outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
 	/* and free any DMA resources */
 	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index 992b1cf..b03d8ae 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -62,8 +62,6 @@ static void cs5520_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	int controller = drive->dn > 1 ? 1 : 0;
 
-	/* FIXME: if DMA = 1 do we need to set the DMA bit here ? */
-
 	/* 8bit CAT/CRT - 8bit command timing for channel */
 	pci_write_config_byte(pdev, 0x62 + controller, 
 		(cs5520_pio_clocks[pio].recovery << 4) |
@@ -89,46 +87,17 @@ static void cs5520_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	cs5520_set_pio_mode(drive, 0);
 }
 
-/*
- *	We wrap the DMA activate to set the vdma flag. This is needed
- *	so that the IDE DMA layer issues PIO not DMA commands over the
- *	DMA channel
- *
- *	ATAPI is harder so disable it for now using IDE_HFLAG_NO_ATAPI_DMA
- */
-
-static void cs5520_dma_host_set(ide_drive_t *drive, int on)
-{
-	drive->vdma = on;
-	ide_dma_host_set(drive, on);
-}
-
 static const struct ide_port_ops cs5520_port_ops = {
 	.set_pio_mode		= cs5520_set_pio_mode,
 	.set_dma_mode		= cs5520_set_dma_mode,
 };
 
-static const struct ide_dma_ops cs5520_dma_ops = {
-	.dma_host_set		= cs5520_dma_host_set,
-	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
-	.dma_start		= ide_dma_start,
-	.dma_end		= __ide_dma_end,
-	.dma_test_irq		= ide_dma_test_irq,
-	.dma_lost_irq		= ide_dma_lost_irq,
-	.dma_timeout		= ide_dma_timeout,
-};
-
-/* FIXME: VDMA is disabled because it caused system hangs */
 #define DECLARE_CS_DEV(name_str)				\
 	{							\
 		.name		= name_str,			\
 		.port_ops	= &cs5520_port_ops,		\
-		.dma_ops	= &cs5520_dma_ops,		\
 		.host_flags	= IDE_HFLAG_ISA_PORTS |		\
-				  IDE_HFLAG_CS5520 |		\
-				  IDE_HFLAG_NO_ATAPI_DMA |	\
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE, \
+				  IDE_HFLAG_CS5520,		\
 		.pio_mask	= ATA_PIO4,			\
 	}
 
@@ -146,7 +115,7 @@ static const struct ide_port_info cyrix_chipsets[] __devinitdata = {
 static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	const struct ide_port_info *d = &cyrix_chipsets[id->driver_data];
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 
 	ide_setup_pci_noise(dev, d);
 
@@ -168,11 +137,9 @@ static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_devic
 	 *	do all the device setup for us
 	 */
 
-	ide_pci_setup_ports(dev, d, 14, &idx[0]);
-
-	ide_device_add(idx, d);
+	ide_pci_setup_ports(dev, d, 14, &hw[0], &hws[0]);
 
-	return 0;
+	return ide_host_add(d, hws, NULL);
 }
 
 static const struct pci_device_id cs5520_pci_tbl[] = {
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index dc97c48..5404fe4 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -171,8 +171,7 @@ static const struct ide_port_ops cs5535_port_ops = {
 static const struct ide_port_info cs5535_chipset __devinitdata = {
 	.name		= "CS5535",
 	.port_ops	= &cs5535_port_ops,
-	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE |
-			  IDE_HFLAG_ABUSE_SET_DMA_MODE,
+	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA4,
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index 0106e2a..f84bfb4 100644
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -56,11 +56,10 @@ static const struct ide_port_info delkin_cb_port_info = {
 static int __devinit
 delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 {
+	struct ide_host *host;
 	unsigned long base;
-	hw_regs_t hw;
-	ide_hwif_t *hwif = NULL;
 	int i, rc;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	rc = pci_enable_device(dev);
 	if (rc) {
@@ -87,34 +86,26 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 	hw.dev = &dev->dev;
 	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
-	hwif = ide_find_port();
-	if (hwif == NULL)
+	rc = ide_host_add(&delkin_cb_port_info, hws, &host);
+	if (rc)
 		goto out_disable;
 
-	i = hwif->index;
-
-	ide_init_port_hw(hwif, &hw);
-
-	idx[0] = i;
-
-	ide_device_add(idx, &delkin_cb_port_info);
-
-	pci_set_drvdata(dev, hwif);
+	pci_set_drvdata(dev, host);
 
 	return 0;
 
 out_disable:
 	pci_release_regions(dev);
 	pci_disable_device(dev);
-	return -ENODEV;
+	return rc;
 }
 
 static void
 delkin_cb_remove (struct pci_dev *dev)
 {
-	ide_hwif_t *hwif = pci_get_drvdata(dev);
+	struct ide_host *host = pci_get_drvdata(dev);
 
-	ide_unregister(hwif);
+	ide_host_remove(host);
 
 	pci_release_regions(dev);
 	pci_disable_device(dev);
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index 84c36c1..9e1d1c4 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -123,7 +123,6 @@ static const struct ide_port_ops hpt34x_port_ops = {
 #define IDE_HFLAGS_HPT34X \
 	(IDE_HFLAG_NO_ATAPI_DMA | \
 	 IDE_HFLAG_NO_DSC | \
-	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
 	 IDE_HFLAG_NO_AUTODMA)
 
 static const struct ide_port_info hpt34x_chipsets[] __devinitdata = {
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 397c6cb..1f1135c 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -801,9 +801,9 @@ static void hpt370_irq_timeout(ide_drive_t *drive)
 	printk(KERN_DEBUG "%s: %d bytes in FIFO\n", drive->name, bfifo & 0x1ff);
 
 	/* get DMA command mode */
-	dma_cmd = inb(hwif->dma_command);
+	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	/* stop DMA */
-	outb(dma_cmd & ~0x1, hwif->dma_command);
+	outb(dma_cmd & ~0x1, hwif->dma_base + ATA_DMA_CMD);
 	hpt370_clear_engine(drive);
 }
 
@@ -818,12 +818,12 @@ static void hpt370_dma_start(ide_drive_t *drive)
 static int hpt370_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	u8  dma_stat		= inb(hwif->dma_status);
+	u8  dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 
 	if (dma_stat & 0x01) {
 		/* wait a little */
 		udelay(20);
-		dma_stat = inb(hwif->dma_status);
+		dma_stat = inb(hwif->dma_base + ATA_DMA_STATUS);
 		if (dma_stat & 0x01)
 			hpt370_irq_timeout(drive);
 	}
@@ -850,7 +850,7 @@ static int hpt374_dma_test_irq(ide_drive_t *drive)
 		return 0;
 	}
 
-	dma_stat = inb(hwif->dma_status);
+	dma_stat = inb(hwif->dma_base + ATA_DMA_STATUS);
 	/* return 1 if INTR asserted */
 	if (dma_stat & 4)
 		return 1;
@@ -1320,7 +1320,15 @@ static int __devinit init_dma_hpt366(ide_hwif_t *hwif,
 	unsigned long flags, base = ide_pci_dma_base(hwif, d);
 	u8 dma_old, dma_new, masterdma = 0, slavedma = 0;
 
-	if (base == 0 || ide_pci_set_master(dev, d->name) < 0)
+	if (base == 0)
+		return -1;
+
+	hwif->dma_base = base;
+
+	if (ide_pci_check_simplex(hwif, d) < 0)
+		return -1;
+
+	if (ide_pci_set_master(dev, d->name) < 0)
 		return -1;
 
 	dma_old = inb(base + 2);
@@ -1346,7 +1354,7 @@ static int __devinit init_dma_hpt366(ide_hwif_t *hwif,
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	ide_setup_dma(hwif, base);
+	hwif->dma_ops = &sff_dma_ops;
 
 	return 0;
 }
@@ -1401,7 +1409,6 @@ static int __devinit hpt36x_init(struct pci_dev *dev, struct pci_dev *dev2)
 
 #define IDE_HFLAGS_HPT3XX \
 	(IDE_HFLAG_NO_ATAPI_DMA | \
-	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
 	 IDE_HFLAG_OFF_BOARD)
 
 static const struct ide_port_ops hpt3xx_port_ops = {
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index 45ba71a..5cd2b32 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -28,10 +28,6 @@
  */
 #include <asm/superio.h>
 
-static unsigned long superio_ide_status[2];
-static unsigned long superio_ide_select[2];
-static unsigned long superio_ide_dma_status[2];
-
 #define SUPERIO_IDE_MAX_RETRIES 25
 
 /* Because of a defect in Super I/O, all reads of the PCI DMA status 
@@ -40,27 +36,28 @@ static unsigned long superio_ide_dma_status[2];
  */
 static u8 superio_ide_inb (unsigned long port)
 {
-	if (port == superio_ide_status[0] ||
-	    port == superio_ide_status[1] ||
-	    port == superio_ide_select[0] ||
-	    port == superio_ide_select[1] ||
-	    port == superio_ide_dma_status[0] ||
-	    port == superio_ide_dma_status[1]) {
-		u8 tmp;
-		int retries = SUPERIO_IDE_MAX_RETRIES;
+	u8 tmp;
+	int retries = SUPERIO_IDE_MAX_RETRIES;
 
-		/* printk(" [ reading port 0x%x with retry ] ", port); */
+	/* printk(" [ reading port 0x%x with retry ] ", port); */
 
-		do {
-			tmp = inb(port);
-			if (tmp == 0)
-				udelay(50);
-		} while (tmp == 0 && retries-- > 0);
+	do {
+		tmp = inb(port);
+		if (tmp == 0)
+			udelay(50);
+	} while (tmp == 0 && retries-- > 0);
 
-		return tmp;
-	}
+	return tmp;
+}
 
-	return inb(port);
+static u8 superio_read_status(ide_hwif_t *hwif)
+{
+	return superio_ide_inb(hwif->io_ports.status_addr);
+}
+
+static u8 superio_read_sff_dma_status(ide_hwif_t *hwif)
+{
+	return superio_ide_inb(hwif->dma_base + ATA_DMA_STATUS);
 }
 
 static void superio_tf_read(ide_drive_t *drive, ide_task_t *task)
@@ -78,6 +75,8 @@ static void superio_tf_read(ide_drive_t *drive, ide_task_t *task)
 	/* be sure we're looking at the low order bits */
 	outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
+	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+		tf->feature = inb(io_ports->feature_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = inb(io_ports->nsect_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
@@ -105,36 +104,32 @@ static void superio_tf_read(ide_drive_t *drive, ide_task_t *task)
 	}
 }
 
-static void __devinit superio_ide_init_iops (struct hwif_s *hwif)
-{
-	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	u32 base, dmabase;
-	u8 port = hwif->channel, tmp;
+static const struct ide_tp_ops superio_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= superio_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= superio_read_sff_dma_status,
 
-	base = pci_resource_start(pdev, port * 2) & ~3;
-	dmabase = pci_resource_start(pdev, 4) & ~3;
-
-	superio_ide_status[port] = base + 7;
-	superio_ide_select[port] = base + 6;
-	superio_ide_dma_status[port] = dmabase + (!port ? 2 : 0xa);
-
-	/* Clear error/interrupt, enable dma */
-	tmp = superio_ide_inb(superio_ide_dma_status[port]);
-	outb(tmp | 0x66, superio_ide_dma_status[port]);
+	.set_irq		= ide_set_irq,
 
-	hwif->tf_read = superio_tf_read;
+	.tf_load		= ide_tf_load,
+	.tf_read		= superio_tf_read,
 
-	/* We need to override inb to workaround a SuperIO errata */
-	hwif->INB = superio_ide_inb;
-}
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
 
-static void __devinit init_iops_ns87415(ide_hwif_t *hwif)
+static void __devinit superio_init_iops(struct hwif_s *hwif)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
+	u32 dma_stat;
+	u8 port = hwif->channel, tmp;
 
-	if (PCI_SLOT(dev->devfn) == 0xE)
-		/* Built-in - assume it's under superio. */
-		superio_ide_init_iops(hwif);
+	dma_stat = (pci_resource_start(pdev, 4) & ~3) + (!port ? 2 : 0xa);
+
+	/* Clear error/interrupt, enable dma */
+	tmp = superio_ide_inb(dma_stat);
+	outb(tmp | 0x66, dma_stat);
 }
 #endif
 
@@ -200,14 +195,14 @@ static int ns87415_dma_end(ide_drive_t *drive)
 	u8 dma_stat = 0, dma_cmd = 0;
 
 	drive->waiting_for_dma = 0;
-	dma_stat = hwif->INB(hwif->dma_status);
-	/* get dma command mode */
-	dma_cmd = hwif->INB(hwif->dma_command);
+	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+	/* get DMA command mode */
+	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	/* stop DMA */
-	outb(dma_cmd & ~1, hwif->dma_command);
+	outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
 	/* from ERRATA: clear the INTR & ERROR bits */
-	dma_cmd = hwif->INB(hwif->dma_command);
-	outb(dma_cmd | 6, hwif->dma_command);
+	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
+	outb(dma_cmd | 6, hwif->dma_base + ATA_DMA_CMD);
 	/* and free any DMA resources */
 	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
@@ -276,7 +271,7 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 		outb(8, hwif->io_ports.ctl_addr);
 		do {
 			udelay(50);
-			stat = hwif->INB(hwif->io_ports.status_addr);
+			stat = hwif->tp_ops->read_status(hwif);
                 	if (stat == 0xff)
                         	break;
         	} while ((stat & BUSY_STAT) && --timeout);
@@ -291,7 +286,7 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 	if (!hwif->dma_base)
 		return;
 
-	outb(0x60, hwif->dma_status);
+	outb(0x60, hwif->dma_base + ATA_DMA_STATUS);
 }
 
 static const struct ide_port_ops ns87415_port_ops = {
@@ -311,9 +306,6 @@ static const struct ide_dma_ops ns87415_dma_ops = {
 
 static const struct ide_port_info ns87415_chipset __devinitdata = {
 	.name		= "NS87415",
-#ifdef CONFIG_SUPERIO
-	.init_iops	= init_iops_ns87415,
-#endif
 	.init_hwif	= init_hwif_ns87415,
 	.port_ops	= &ns87415_port_ops,
 	.dma_ops	= &ns87415_dma_ops,
@@ -323,7 +315,16 @@ static const struct ide_port_info ns87415_chipset __devinitdata = {
 
 static int __devinit ns87415_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &ns87415_chipset);
+	struct ide_port_info d = ns87415_chipset;
+
+#ifdef CONFIG_SUPERIO
+	if (PCI_SLOT(dev->devfn) == 0xE) {
+		/* Built-in - assume it's under superio. */
+		d.init_iops = superio_init_iops;
+		d.tp_ops = &superio_tp_ops;
+	}
+#endif
+	return ide_setup_pci_device(dev, &d);
 }
 
 static const struct pci_device_id ns87415_pci_tbl[] = {
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index fca89ed..e54dc65 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -206,7 +206,7 @@ static int pdc202xx_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long high_16	= hwif->extra_base - 16;
-	u8 dma_stat		= inb(hwif->dma_status);
+	u8 dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 	u8 sc1d			= inb(high_16 + 0x001d);
 
 	if (hwif->channel) {
@@ -312,7 +312,6 @@ static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
 
 #define IDE_HFLAGS_PDC202XX \
 	(IDE_HFLAG_ERROR_STOPS_FIFO | \
-	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
 	 IDE_HFLAG_OFF_BOARD)
 
 static const struct ide_port_ops pdc20246_port_ops = {
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index f04738d..0ce41b4 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -227,9 +227,9 @@ static void piix_dma_clear_irq(ide_drive_t *drive)
 	u8 dma_stat;
 
 	/* clear the INTR & ERROR bits */
-	dma_stat = inb(hwif->dma_status);
+	dma_stat = inb(hwif->dma_base + ATA_DMA_STATUS);
 	/* Should we force the bit as well ? */
-	outb(dma_stat, hwif->dma_status);
+	outb(dma_stat, hwif->dma_base + ATA_DMA_STATUS);
 }
 
 struct ich_laptop {
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 789c66d..94a7ab8 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -65,7 +65,7 @@
 
 static struct scc_ports {
 	unsigned long ctl, dma;
-	ide_hwif_t *hwif;  /* for removing port from system */
+	struct ide_host *host;	/* for removing port from system */
 } scc_ports[MAX_HWIFS];
 
 /* PIO transfer mode  table */
@@ -126,6 +126,46 @@ static u8 scc_ide_inb(unsigned long port)
 	return (u8)data;
 }
 
+static void scc_exec_command(ide_hwif_t *hwif, u8 cmd)
+{
+	out_be32((void *)hwif->io_ports.command_addr, cmd);
+	eieio();
+	in_be32((void *)(hwif->dma_base + 0x01c));
+	eieio();
+}
+
+static u8 scc_read_status(ide_hwif_t *hwif)
+{
+	return (u8)in_be32((void *)hwif->io_ports.status_addr);
+}
+
+static u8 scc_read_altstatus(ide_hwif_t *hwif)
+{
+	return (u8)in_be32((void *)hwif->io_ports.ctl_addr);
+}
+
+static u8 scc_read_sff_dma_status(ide_hwif_t *hwif)
+{
+	return (u8)in_be32((void *)(hwif->dma_base + 4));
+}
+
+static void scc_set_irq(ide_hwif_t *hwif, int on)
+{
+	u8 ctl = ATA_DEVCTL_OBS;
+
+	if (on == 4) { /* hack for SRST */
+		ctl |= 4;
+		on &= ~4;
+	}
+
+	ctl |= on ? 0 : 2;
+
+	out_be32((void *)hwif->io_ports.ctl_addr, ctl);
+	eieio();
+	in_be32((void *)(hwif->dma_base + 0x01c));
+	eieio();
+}
+
 static void scc_ide_insw(unsigned long port, void *addr, u32 count)
 {
 	u16 *ptr = (u16 *)addr;
@@ -148,14 +188,6 @@ static void scc_ide_outb(u8 addr, unsigned long port)
 	out_be32((void*)port, addr);
 }
 
-static void scc_ide_outbsync(ide_hwif_t *hwif, u8 addr, unsigned long port)
-{
-	out_be32((void*)port, addr);
-	eieio();
-	in_be32((void*)(hwif->dma_base + 0x01c));
-	eieio();
-}
-
 static void
 scc_ide_outsw(unsigned long port, void *addr, u32 count)
 {
@@ -261,14 +293,14 @@ static void scc_dma_host_set(ide_drive_t *drive, int on)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u8 unit = (drive->select.b.unit & 0x01);
-	u8 dma_stat = scc_ide_inb(hwif->dma_status);
+	u8 dma_stat = scc_ide_inb(hwif->dma_base + 4);
 
 	if (on)
 		dma_stat |= (1 << (5 + unit));
 	else
 		dma_stat &= ~(1 << (5 + unit));
 
-	scc_ide_outb(dma_stat, hwif->dma_status);
+	scc_ide_outb(dma_stat, hwif->dma_base + 4);
 }
 
 /**
@@ -304,13 +336,13 @@ static int scc_dma_setup(ide_drive_t *drive)
 	out_be32((void __iomem *)(hwif->dma_base + 8), hwif->dmatable_dma);
 
 	/* specify r/w */
-	out_be32((void __iomem *)hwif->dma_command, reading);
+	out_be32((void __iomem *)hwif->dma_base, reading);
 
-	/* read dma_status for INTR & ERROR flags */
-	dma_stat = in_be32((void __iomem *)hwif->dma_status);
+	/* read DMA status for INTR & ERROR flags */
+	dma_stat = in_be32((void __iomem *)(hwif->dma_base + 4));
 
 	/* clear INTR & ERROR flags */
-	out_be32((void __iomem *)hwif->dma_status, dma_stat|6);
+	out_be32((void __iomem *)(hwif->dma_base + 4), dma_stat | 6);
 	drive->waiting_for_dma = 1;
 	return 0;
 }
@@ -318,10 +350,10 @@ static int scc_dma_setup(ide_drive_t *drive)
 static void scc_dma_start(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u8 dma_cmd = scc_ide_inb(hwif->dma_command);
+	u8 dma_cmd = scc_ide_inb(hwif->dma_base);
 
 	/* start DMA */
-	scc_ide_outb(dma_cmd | 1, hwif->dma_command);
+	scc_ide_outb(dma_cmd | 1, hwif->dma_base);
 	hwif->dma = 1;
 	wmb();
 }
@@ -333,13 +365,13 @@ static int __scc_dma_end(ide_drive_t *drive)
 
 	drive->waiting_for_dma = 0;
 	/* get DMA command mode */
-	dma_cmd = scc_ide_inb(hwif->dma_command);
+	dma_cmd = scc_ide_inb(hwif->dma_base);
 	/* stop DMA */
-	scc_ide_outb(dma_cmd & ~1, hwif->dma_command);
+	scc_ide_outb(dma_cmd & ~1, hwif->dma_base);
 	/* get DMA status */
-	dma_stat = scc_ide_inb(hwif->dma_status);
+	dma_stat = scc_ide_inb(hwif->dma_base + 4);
 	/* clear the INTR & ERROR bits */
-	scc_ide_outb(dma_stat | 6, hwif->dma_status);
+	scc_ide_outb(dma_stat | 6, hwif->dma_base + 4);
 	/* purge DMA mappings */
 	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
@@ -359,6 +391,7 @@ static int __scc_dma_end(ide_drive_t *drive)
 static int scc_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	void __iomem *dma_base = (void __iomem *)hwif->dma_base;
 	unsigned long intsts_port = hwif->dma_base + 0x014;
 	u32 reg;
 	int dma_stat, data_loss = 0;
@@ -397,7 +430,7 @@ static int scc_dma_end(ide_drive_t *drive)
 			printk(KERN_WARNING "%s: SERROR\n", SCC_PATA_NAME);
 			out_be32((void __iomem *)intsts_port, INTSTS_SERROR|INTSTS_BMSINT);
 
-			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
+			out_be32(dma_base, in_be32(dma_base) & ~QCHCD_IOS_SS);
 			continue;
 		}
 
@@ -412,7 +445,7 @@ static int scc_dma_end(ide_drive_t *drive)
 
 			out_be32((void __iomem *)intsts_port, INTSTS_PRERR|INTSTS_BMSINT);
 
-			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
+			out_be32(dma_base, in_be32(dma_base) & ~QCHCD_IOS_SS);
 			continue;
 		}
 
@@ -420,12 +453,12 @@ static int scc_dma_end(ide_drive_t *drive)
 			printk(KERN_WARNING "%s: Response Error\n", SCC_PATA_NAME);
 			out_be32((void __iomem *)intsts_port, INTSTS_RERR|INTSTS_BMSINT);
 
-			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
+			out_be32(dma_base, in_be32(dma_base) & ~QCHCD_IOS_SS);
 			continue;
 		}
 
 		if (reg & INTSTS_ICERR) {
-			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
+			out_be32(dma_base, in_be32(dma_base) & ~QCHCD_IOS_SS);
 
 			printk(KERN_WARNING "%s: Illegal Configuration\n", SCC_PATA_NAME);
 			out_be32((void __iomem *)intsts_port, INTSTS_ICERR|INTSTS_BMSINT);
@@ -553,14 +586,9 @@ static int scc_ide_setup_pci_device(struct pci_dev *dev,
 				    const struct ide_port_info *d)
 {
 	struct scc_ports *ports = pci_get_drvdata(dev);
-	ide_hwif_t *hwif = NULL;
-	hw_regs_t hw;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	int i;
-
-	hwif = ide_find_port_slot(d);
-	if (hwif == NULL)
-		return -ENOMEM;
+	struct ide_host *host;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	int i, rc;
 
 	memset(&hw, 0, sizeof(hw));
 	for (i = 0; i <= 8; i++)
@@ -568,11 +596,12 @@ static int scc_ide_setup_pci_device(struct pci_dev *dev,
 	hw.irq = dev->irq;
 	hw.dev = &dev->dev;
 	hw.chipset = ide_pci;
-	ide_init_port_hw(hwif, &hw);
 
-	idx[0] = hwif->index;
+	rc = ide_host_add(d, hws, &host);
+	if (rc)
+		return rc;
 
-	ide_device_add(idx, d);
+	ports->host = host;
 
 	return 0;
 }
@@ -701,6 +730,8 @@ static void scc_tf_read(ide_drive_t *drive, ide_task_t *task)
 	/* be sure we're looking at the low order bits */
 	scc_ide_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
+	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+		tf->feature = scc_ide_inb(io_ports->feature_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = scc_ide_inb(io_ports->nsect_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
@@ -774,16 +805,6 @@ static void __devinit init_mmio_iops_scc(ide_hwif_t *hwif)
 
 	ide_set_hwifdata(hwif, ports);
 
-	hwif->tf_load = scc_tf_load;
-	hwif->tf_read = scc_tf_read;
-
-	hwif->input_data  = scc_input_data;
-	hwif->output_data = scc_output_data;
-
-	hwif->INB = scc_ide_inb;
-	hwif->OUTB = scc_ide_outb;
-	hwif->OUTBSYNC = scc_ide_outbsync;
-
 	hwif->dma_base = dma_base;
 	hwif->config_data = ports->ctl;
 }
@@ -824,11 +845,6 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 {
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
 
-	ports->hwif = hwif;
-
-	hwif->dma_command = hwif->dma_base;
-	hwif->dma_status = hwif->dma_base + 0x04;
-
 	/* PTERADD */
 	out_be32((void __iomem *)(hwif->dma_base + 0x018), hwif->dmatable_dma);
 
@@ -838,6 +854,21 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 		hwif->ultra_mask = ATA_UDMA5; /* 100MHz */
 }
 
+static const struct ide_tp_ops scc_tp_ops = {
+	.exec_command		= scc_exec_command,
+	.read_status		= scc_read_status,
+	.read_altstatus		= scc_read_altstatus,
+	.read_sff_dma_status	= scc_read_sff_dma_status,
+
+	.set_irq		= scc_set_irq,
+
+	.tf_load		= scc_tf_load,
+	.tf_read		= scc_tf_read,
+
+	.input_data		= scc_input_data,
+	.output_data		= scc_output_data,
+};
+
 static const struct ide_port_ops scc_port_ops = {
 	.set_pio_mode		= scc_set_pio_mode,
 	.set_dma_mode		= scc_set_dma_mode,
@@ -861,6 +892,7 @@ static const struct ide_dma_ops scc_dma_ops = {
       .name		= name_str,			\
       .init_iops	= init_iops_scc,		\
       .init_hwif	= init_hwif_scc,		\
+      .tp_ops		= &scc_tp_ops,		\
       .port_ops		= &scc_port_ops,		\
       .dma_ops		= &scc_dma_ops,			\
       .host_flags	= IDE_HFLAG_SINGLE,		\
@@ -895,7 +927,8 @@ static int __devinit scc_init_one(struct pci_dev *dev, const struct pci_device_i
 static void __devexit scc_remove(struct pci_dev *dev)
 {
 	struct scc_ports *ports = pci_get_drvdata(dev);
-	ide_hwif_t *hwif = ports->hwif;
+	struct ide_host *host = ports->host;
+	ide_hwif_t *hwif = host->ports[0];
 
 	if (hwif->dmatable_cpu) {
 		pci_free_consistent(dev, PRD_ENTRIES * PRD_BYTES,
@@ -903,7 +936,7 @@ static void __devexit scc_remove(struct pci_dev *dev)
 		hwif->dmatable_cpu = NULL;
 	}
 
-	ide_unregister(hwif);
+	ide_host_remove(host);
 
 	iounmap((void*)ports->dma);
 	iounmap((void*)ports->ctl);
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index a1fb208..127ccb4 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -349,9 +349,7 @@ static const struct ide_port_ops svwks_port_ops = {
 	.cable_detect		= svwks_cable_detect,
 };
 
-#define IDE_HFLAGS_SVWKS \
-	(IDE_HFLAG_LEGACY_IRQS | \
-	 IDE_HFLAG_ABUSE_SET_DMA_MODE)
+#define IDE_HFLAGS_SVWKS IDE_HFLAG_LEGACY_IRQS
 
 static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 	{	/* 0 */
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index c79ff5b..42eef19 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -127,7 +127,7 @@ sgiioc4_checkirq(ide_hwif_t * hwif)
 	return 0;
 }
 
-static u8 sgiioc4_INB(unsigned long);
+static u8 sgiioc4_read_status(ide_hwif_t *);
 
 static int
 sgiioc4_clearirq(ide_drive_t * drive)
@@ -141,18 +141,19 @@ sgiioc4_clearirq(ide_drive_t * drive)
 	intr_reg = readl((void __iomem *)other_ir);
 	if (intr_reg & 0x03) { /* Valid IOC4-IDE interrupt */
 		/*
-		 * Using sgiioc4_INB to read the Status register has a side
-		 * effect of clearing the interrupt.  The first read should
+		 * Using sgiioc4_read_status to read the Status register has a
+		 * side effect of clearing the interrupt.  The first read should
 		 * clear it if it is set.  The second read should return
 		 * a "clear" status if it got cleared.  If not, then spin
 		 * for a bit trying to clear it.
 		 */
-		u8 stat = sgiioc4_INB(io_ports->status_addr);
+		u8 stat = sgiioc4_read_status(hwif);
 		int count = 0;
-		stat = sgiioc4_INB(io_ports->status_addr);
+
+		stat = sgiioc4_read_status(hwif);
 		while ((stat & 0x80) && (count++ < 100)) {
 			udelay(1);
-			stat = sgiioc4_INB(io_ports->status_addr);
+			stat = sgiioc4_read_status(hwif);
 		}
 
 		if (intr_reg & 0x02) {
@@ -304,9 +305,9 @@ sgiioc4_dma_lost_irq(ide_drive_t * drive)
 	ide_dma_lost_irq(drive);
 }
 
-static u8
-sgiioc4_INB(unsigned long port)
+static u8 sgiioc4_read_status(ide_hwif_t *hwif)
 {
+	unsigned long port = hwif->io_ports.status_addr;
 	u8 reg = (u8) readb((void __iomem *) port);
 
 	if ((port & 0xFFF) == 0x11C) {	/* Status register of IOC4 */
@@ -549,6 +550,21 @@ static int sgiioc4_dma_setup(ide_drive_t *drive)
 	return 0;
 }
 
+static const struct ide_tp_ops sgiioc4_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= sgiioc4_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
+
 static const struct ide_port_ops sgiioc4_port_ops = {
 	.set_dma_mode		= sgiioc4_set_dma_mode,
 	/* reset DMA engine, clear IRQs */
@@ -571,6 +587,7 @@ static const struct ide_port_info sgiioc4_port_info __devinitdata = {
 	.name			= DRV_NAME,
 	.chipset		= ide_pci,
 	.init_dma		= ide_dma_sgiioc4,
+	.tp_ops			= &sgiioc4_tp_ops,
 	.port_ops		= &sgiioc4_port_ops,
 	.dma_ops		= &sgiioc4_dma_ops,
 	.host_flags		= IDE_HFLAG_MMIO,
@@ -583,10 +600,10 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	unsigned long cmd_base, irqport;
 	unsigned long bar0, cmd_phys_base, ctl;
 	void __iomem *virt_base;
-	ide_hwif_t *hwif;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw;
+	struct ide_host *host;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	struct ide_port_info d = sgiioc4_port_info;
+	int rc;
 
 	/*  Get the CmdBlk and CtrlBlk Base Registers */
 	bar0 = pci_resource_start(dev, 0);
@@ -618,30 +635,26 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	hw.chipset = ide_pci;
 	hw.dev = &dev->dev;
 
-	hwif = ide_find_port_slot(&d);
-	if (hwif == NULL)
-		goto err;
-
-	ide_init_port_hw(hwif, &hw);
-
-	/* The IOC4 uses MMIO rather than Port IO. */
-	default_hwif_mmiops(hwif);
-
 	/* Initializing chipset IRQ Registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
-	hwif->INB = &sgiioc4_INB;
-
-	idx[0] = hwif->index;
+	host = ide_host_alloc(&d, hws);
+	if (host == NULL) {
+		rc = -ENOMEM;
+		goto err;
+	}
 
-	if (ide_device_add(idx, &d))
-		return -EIO;
+	rc = ide_host_register(host, &d, hws);
+	if (rc)
+		goto err_free;
 
 	return 0;
+err_free:
+	ide_host_free(host);
 err:
 	release_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE);
 	iounmap(virt_base);
-	return -ENOMEM;
+	return rc;
 }
 
 static unsigned int __devinit
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 6e9d765..5965a35 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -334,7 +334,7 @@ static int siimage_io_dma_test_irq(ide_drive_t *drive)
 	unsigned long addr	= siimage_selreg(hwif, 1);
 
 	/* return 1 if INTR asserted */
-	if (hwif->INB(hwif->dma_status) & 4)
+	if (inb(hwif->dma_base + ATA_DMA_STATUS) & 4)
 		return 1;
 
 	/* return 1 if Device INTR asserted */
@@ -382,7 +382,7 @@ static int siimage_mmio_dma_test_irq(ide_drive_t *drive)
 	}
 
 	/* return 1 if INTR asserted */
-	if (readb((void __iomem *)hwif->dma_status) & 0x04)
+	if (readb((void __iomem *)(hwif->dma_base + ATA_DMA_STATUS)) & 4)
 		return 1;
 
 	/* return 1 if Device INTR asserted */
@@ -601,7 +601,7 @@ static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 	 *	Fill in the basic hwif bits
 	 */
 	hwif->host_flags |= IDE_HFLAG_MMIO;
-	default_hwif_mmiops(hwif);
+
 	hwif->hwif_data	= addr;
 
 	/*
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index 6efbde2..f82a650 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -157,9 +157,9 @@ static void sl82c105_dma_lost_irq(ide_drive_t *drive)
 	 * Was DMA enabled?  If so, disable it - we're resetting the
 	 * host.  The IDE layer will be handling the drive for us.
 	 */
-	dma_cmd = inb(hwif->dma_command);
+	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	if (dma_cmd & 1) {
-		outb(dma_cmd & ~1, hwif->dma_command);
+		outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
 		printk("sl82c105: DMA was enabled\n");
 	}
 
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index 9b4b27a..477e197 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -63,7 +63,7 @@ static int tc86c001_timer_expiry(ide_drive_t *drive)
 	ide_hwif_t *hwif	= HWIF(drive);
 	ide_expiry_t *expiry	= ide_get_hwifdata(hwif);
 	ide_hwgroup_t *hwgroup	= HWGROUP(drive);
-	u8 dma_stat		= inb(hwif->dma_status);
+	u8 dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 
 	/* Restore a higher level driver's expiry handler first. */
 	hwgroup->expiry	= expiry;
@@ -71,21 +71,24 @@ static int tc86c001_timer_expiry(ide_drive_t *drive)
 	if ((dma_stat & 5) == 1) {	/* DMA active and no interrupt */
 		unsigned long sc_base	= hwif->config_data;
 		unsigned long twcr_port	= sc_base + (drive->dn ? 0x06 : 0x04);
-		u8 dma_cmd		= inb(hwif->dma_command);
+		u8 dma_cmd		= inb(hwif->dma_base + ATA_DMA_CMD);
 
 		printk(KERN_WARNING "%s: DMA interrupt possibly stuck, "
 		       "attempting recovery...\n", drive->name);
 
 		/* Stop DMA */
-		outb(dma_cmd & ~0x01, hwif->dma_command);
+		outb(dma_cmd & ~0x01, hwif->dma_base + ATA_DMA_CMD);
 
 		/* Setup the dummy DMA transfer */
 		outw(0, sc_base + 0x0a);	/* Sector Count */
 		outw(0, twcr_port);	/* Transfer Word Count 1 or 2 */
 
 		/* Start the dummy DMA transfer */
-		outb(0x00, hwif->dma_command); /* clear R_OR_WCTR for write */
-		outb(0x01, hwif->dma_command); /* set START_STOPBM */
+
+		/* clear R_OR_WCTR for write */
+		outb(0x00, hwif->dma_base + ATA_DMA_CMD);
+		/* set START_STOPBM */
+		outb(0x01, hwif->dma_base + ATA_DMA_CMD);
 
 		/*
 		 * If an interrupt was pending, it should come thru shortly.
@@ -203,8 +206,7 @@ static const struct ide_port_info tc86c001_chipset __devinitdata = {
 	.init_hwif	= init_hwif_tc86c001,
 	.port_ops	= &tc86c001_port_ops,
 	.dma_ops	= &tc86c001_dma_ops,
-	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_OFF_BOARD |
-			  IDE_HFLAG_ABUSE_SET_DMA_MODE,
+	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_OFF_BOARD,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA4,
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index e47384c..09dc480 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -425,7 +425,6 @@ static const struct ide_port_info via82cxxx_chipset __devinitdata = {
 	.enablebits	= { { 0x40, 0x02, 0x02 }, { 0x40, 0x01, 0x01 } },
 	.port_ops	= &via_port_ops,
 	.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |
-			  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 			  IDE_HFLAG_POST_SET_MODE |
 			  IDE_HFLAG_IO_32BIT,
 	.pio_mask	= ATA_PIO5,
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 93fb906..c521bf6 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -48,6 +48,8 @@
 #include <asm/mediabay.h>
 #endif
 
+#define DRV_NAME "ide-pmac"
+
 #undef IDE_PMAC_DEBUG
 
 #define DMA_WAIT_TIMEOUT	50
@@ -424,7 +426,9 @@ static void pmac_ide_kauai_selectproc(ide_drive_t *drive);
 static void
 pmac_ide_selectproc(ide_drive_t *drive)
 {
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 
 	if (pmif == NULL)
 		return;
@@ -444,7 +448,9 @@ pmac_ide_selectproc(ide_drive_t *drive)
 static void
 pmac_ide_kauai_selectproc(ide_drive_t *drive)
 {
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 
 	if (pmif == NULL)
 		return;
@@ -465,7 +471,9 @@ pmac_ide_kauai_selectproc(ide_drive_t *drive)
 static void
 pmac_ide_do_update_timings(ide_drive_t *drive)
 {
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 
 	if (pmif == NULL)
 		return;
@@ -478,12 +486,26 @@ pmac_ide_do_update_timings(ide_drive_t *drive)
 		pmac_ide_selectproc(drive);
 }
 
-static void pmac_outbsync(ide_hwif_t *hwif, u8 value, unsigned long port)
+static void pmac_exec_command(ide_hwif_t *hwif, u8 cmd)
 {
-	u32 tmp;
-	
-	writeb(value, (void __iomem *) port);
-	tmp = readl((void __iomem *)(hwif->io_ports.data_addr
+	writeb(cmd, (void __iomem *)hwif->io_ports.command_addr);
+	(void)readl((void __iomem *)(hwif->io_ports.data_addr
+				     + IDE_TIMING_CONFIG));
+}
+
+static void pmac_set_irq(ide_hwif_t *hwif, int on)
+{
+	u8 ctl = ATA_DEVCTL_OBS;
+
+	if (on == 4) { /* hack for SRST */
+		ctl |= 4;
+		on &= ~4;
+	}
+
+	ctl |= on ? 0 : 2;
+
+	writeb(ctl, (void __iomem *)hwif->io_ports.ctl_addr);
+	(void)readl((void __iomem *)(hwif->io_ports.data_addr
 				     + IDE_TIMING_CONFIG));
 }
 
@@ -493,11 +515,13 @@ static void pmac_outbsync(ide_hwif_t *hwif, u8 value, unsigned long port)
 static void
 pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct ide_timing *tim = ide_timing_find_mode(XFER_PIO_0 + pio);
 	u32 *timings, t;
 	unsigned accessTicks, recTicks;
 	unsigned accessTime, recTime;
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
 	unsigned int cycle_time;
 
 	if (pmif == NULL)
@@ -778,9 +802,11 @@ set_timings_mdma(ide_drive_t *drive, int intf_type, u32 *timings, u32 *timings2,
 
 static void pmac_ide_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	int unit = (drive->select.b.unit & 0x01);
 	int ret = 0;
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
 	u32 *timings, *timings2, tl[2];
 
 	timings = &pmif->timings[unit];
@@ -852,11 +878,8 @@ sanitize_timings(pmac_ide_hwif_t *pmif)
 /* Suspend call back, should be called after the child devices
  * have actually been suspended
  */
-static int
-pmac_ide_do_suspend(ide_hwif_t *hwif)
+static int pmac_ide_do_suspend(pmac_ide_hwif_t *pmif)
 {
-	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
-	
 	/* We clear the timings */
 	pmif->timings[0] = 0;
 	pmif->timings[1] = 0;
@@ -884,11 +907,8 @@ pmac_ide_do_suspend(ide_hwif_t *hwif)
 /* Resume call back, should be called before the child devices
  * are resumed
  */
-static int
-pmac_ide_do_resume(ide_hwif_t *hwif)
+static int pmac_ide_do_resume(pmac_ide_hwif_t *pmif)
 {
-	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
-	
 	/* Hard reset & re-enable controller (do we really need to reset ? -BenH) */
 	if (!pmif->mediabay) {
 		ppc_md.feature_call(PMAC_FTR_IDE_RESET, pmif->node, pmif->aapl_bus_id, 1);
@@ -916,7 +936,8 @@ pmac_ide_do_resume(ide_hwif_t *hwif)
 
 static u8 pmac_ide_cable_detect(ide_hwif_t *hwif)
 {
-	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)ide_get_hwifdata(hwif);
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct device_node *np = pmif->node;
 	const char *cable = of_get_property(np, "cable-type", NULL);
 
@@ -936,7 +957,40 @@ static u8 pmac_ide_cable_detect(ide_hwif_t *hwif)
 	return ATA_CBL_PATA40;
 }
 
+static void pmac_ide_init_dev(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+
+	if (pmif->mediabay) {
+#ifdef CONFIG_PMAC_MEDIABAY
+		if (check_media_bay_by_base(pmif->regbase, MB_CD) == 0) {
+			drive->noprobe = 0;
+			return;
+		}
+#endif
+		drive->noprobe = 1;
+	}
+}
+
+static const struct ide_tp_ops pmac_tp_ops = {
+	.exec_command		= pmac_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= pmac_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
+
 static const struct ide_port_ops pmac_ide_ata6_port_ops = {
+	.init_dev		= pmac_ide_init_dev,
 	.set_pio_mode		= pmac_ide_set_pio_mode,
 	.set_dma_mode		= pmac_ide_set_dma_mode,
 	.selectproc		= pmac_ide_kauai_selectproc,
@@ -944,6 +998,7 @@ static const struct ide_port_ops pmac_ide_ata6_port_ops = {
 };
 
 static const struct ide_port_ops pmac_ide_ata4_port_ops = {
+	.init_dev		= pmac_ide_init_dev,
 	.set_pio_mode		= pmac_ide_set_pio_mode,
 	.set_dma_mode		= pmac_ide_set_dma_mode,
 	.selectproc		= pmac_ide_selectproc,
@@ -951,6 +1006,7 @@ static const struct ide_port_ops pmac_ide_ata4_port_ops = {
 };
 
 static const struct ide_port_ops pmac_ide_port_ops = {
+	.init_dev		= pmac_ide_init_dev,
 	.set_pio_mode		= pmac_ide_set_pio_mode,
 	.set_dma_mode		= pmac_ide_set_dma_mode,
 	.selectproc		= pmac_ide_selectproc,
@@ -959,12 +1015,14 @@ static const struct ide_port_ops pmac_ide_port_ops = {
 static const struct ide_dma_ops pmac_dma_ops;
 
 static const struct ide_port_info pmac_port_info = {
+	.name			= DRV_NAME,
 	.init_dma		= pmac_ide_init_dma,
 	.chipset		= ide_pmac,
+	.tp_ops			= &pmac_tp_ops,
+	.port_ops		= &pmac_ide_port_ops,
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
 	.dma_ops		= &pmac_dma_ops,
 #endif
-	.port_ops		= &pmac_ide_port_ops,
 	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
 				  IDE_HFLAG_POST_SET_MODE |
 				  IDE_HFLAG_MMIO |
@@ -977,13 +1035,15 @@ static const struct ide_port_info pmac_port_info = {
  * Setup, register & probe an IDE channel driven by this driver, this is
  * called by one of the 2 probe functions (macio or PCI).
  */
-static int __devinit
-pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
+static int __devinit pmac_ide_setup_device(pmac_ide_hwif_t *pmif, hw_regs_t *hw)
 {
 	struct device_node *np = pmif->node;
 	const int *bidp;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	struct ide_host *host;
+	ide_hwif_t *hwif;
+	hw_regs_t *hws[] = { hw, NULL, NULL, NULL };
 	struct ide_port_info d = pmac_port_info;
+	int rc;
 
 	pmif->broken_dma = pmif->broken_dma_warn = 0;
 	if (of_device_is_compatible(np, "shasta-ata")) {
@@ -1054,31 +1114,16 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
 		msleep(jiffies_to_msecs(IDE_WAKEUP_DELAY));
 	}
 
-	/* Setup MMIO ops */
-	default_hwif_mmiops(hwif);
-       	hwif->OUTBSYNC = pmac_outbsync;
+	printk(KERN_INFO DRV_NAME ": Found Apple %s controller (%s), "
+			 "bus ID %d%s, irq %d\n", model_name[pmif->kind],
+			 pmif->mdev ? "macio" : "PCI", pmif->aapl_bus_id,
+			 pmif->mediabay ? " (mediabay)" : "", hw->irq);
 
-	hwif->hwif_data = pmif;
-	ide_init_port_hw(hwif, hw);
+	rc = ide_host_add(&d, hws, &host);
+	if (rc)
+		return rc;
 
-	printk(KERN_INFO "ide%d: Found Apple %s controller, bus ID %d%s, irq %d\n",
-	       hwif->index, model_name[pmif->kind], pmif->aapl_bus_id,
-	       pmif->mediabay ? " (mediabay)" : "", hwif->irq);
-
-	if (pmif->mediabay) {
-#ifdef CONFIG_PMAC_MEDIABAY
-		if (check_media_bay_by_base(pmif->regbase, MB_CD)) {
-#else
-		if (1) {
-#endif
-			hwif->drives[0].noprobe = 1;
-			hwif->drives[1].noprobe = 1;
-		}
-	}
-
-	idx[0] = hwif->index;
-
-	ide_device_add(idx, &d);
+	hwif = host->ports[0];
 
 	return 0;
 }
@@ -1101,7 +1146,6 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 {
 	void __iomem *base;
 	unsigned long regbase;
-	ide_hwif_t *hwif;
 	pmac_ide_hwif_t *pmif;
 	int irq, rc;
 	hw_regs_t hw;
@@ -1110,14 +1154,6 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	if (pmif == NULL)
 		return -ENOMEM;
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		printk(KERN_ERR "ide-pmac: MacIO interface attach with no slot\n");
-		printk(KERN_ERR "          %s\n", mdev->ofdev.node->full_name);
-		rc = -ENODEV;
-		goto out_free_pmif;
-	}
-
 	if (macio_resource_count(mdev) == 0) {
 		printk(KERN_WARNING "ide-pmac: no address for %s\n",
 				    mdev->ofdev.node->full_name);
@@ -1164,7 +1200,7 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	} else
 		pmif->dma_regs = NULL;
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
-	dev_set_drvdata(&mdev->ofdev.dev, hwif);
+	dev_set_drvdata(&mdev->ofdev.dev, pmif);
 
 	memset(&hw, 0, sizeof(hw));
 	pmac_ide_init_ports(&hw, pmif->regbase);
@@ -1172,7 +1208,7 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	hw.dev = &mdev->bus->pdev->dev;
 	hw.parent = &mdev->ofdev.dev;
 
-	rc = pmac_ide_setup_device(pmif, hwif, &hw);
+	rc = pmac_ide_setup_device(pmif, &hw);
 	if (rc != 0) {
 		/* The inteface is released to the common IDE layer */
 		dev_set_drvdata(&mdev->ofdev.dev, NULL);
@@ -1195,12 +1231,13 @@ out_free_pmif:
 static int
 pmac_ide_macio_suspend(struct macio_dev *mdev, pm_message_t mesg)
 {
-	ide_hwif_t	*hwif = (ide_hwif_t *)dev_get_drvdata(&mdev->ofdev.dev);
-	int		rc = 0;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(&mdev->ofdev.dev);
+	int rc = 0;
 
 	if (mesg.event != mdev->ofdev.dev.power.power_state.event
 			&& (mesg.event & PM_EVENT_SLEEP)) {
-		rc = pmac_ide_do_suspend(hwif);
+		rc = pmac_ide_do_suspend(pmif);
 		if (rc == 0)
 			mdev->ofdev.dev.power.power_state = mesg;
 	}
@@ -1211,11 +1248,12 @@ pmac_ide_macio_suspend(struct macio_dev *mdev, pm_message_t mesg)
 static int
 pmac_ide_macio_resume(struct macio_dev *mdev)
 {
-	ide_hwif_t	*hwif = (ide_hwif_t *)dev_get_drvdata(&mdev->ofdev.dev);
-	int		rc = 0;
-	
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(&mdev->ofdev.dev);
+	int rc = 0;
+
 	if (mdev->ofdev.dev.power.power_state.event != PM_EVENT_ON) {
-		rc = pmac_ide_do_resume(hwif);
+		rc = pmac_ide_do_resume(pmif);
 		if (rc == 0)
 			mdev->ofdev.dev.power.power_state = PMSG_ON;
 	}
@@ -1229,7 +1267,6 @@ pmac_ide_macio_resume(struct macio_dev *mdev)
 static int __devinit
 pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	ide_hwif_t *hwif;
 	struct device_node *np;
 	pmac_ide_hwif_t *pmif;
 	void __iomem *base;
@@ -1247,14 +1284,6 @@ pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pmif == NULL)
 		return -ENOMEM;
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		printk(KERN_ERR "ide-pmac: PCI interface attach with no slot\n");
-		printk(KERN_ERR "          %s\n", np->full_name);
-		rc = -ENODEV;
-		goto out_free_pmif;
-	}
-
 	if (pci_enable_device(pdev)) {
 		printk(KERN_WARNING "ide-pmac: Can't enable PCI device for "
 				    "%s\n", np->full_name);
@@ -1284,14 +1313,14 @@ pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	pmif->kauai_fcr = base;
 	pmif->irq = pdev->irq;
 
-	pci_set_drvdata(pdev, hwif);
+	pci_set_drvdata(pdev, pmif);
 
 	memset(&hw, 0, sizeof(hw));
 	pmac_ide_init_ports(&hw, pmif->regbase);
 	hw.irq = pdev->irq;
 	hw.dev = &pdev->dev;
 
-	rc = pmac_ide_setup_device(pmif, hwif, &hw);
+	rc = pmac_ide_setup_device(pmif, &hw);
 	if (rc != 0) {
 		/* The inteface is released to the common IDE layer */
 		pci_set_drvdata(pdev, NULL);
@@ -1310,12 +1339,12 @@ out_free_pmif:
 static int
 pmac_ide_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
-	ide_hwif_t	*hwif = (ide_hwif_t *)pci_get_drvdata(pdev);
-	int		rc = 0;
-	
+	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)pci_get_drvdata(pdev);
+	int rc = 0;
+
 	if (mesg.event != pdev->dev.power.power_state.event
 			&& (mesg.event & PM_EVENT_SLEEP)) {
-		rc = pmac_ide_do_suspend(hwif);
+		rc = pmac_ide_do_suspend(pmif);
 		if (rc == 0)
 			pdev->dev.power.power_state = mesg;
 	}
@@ -1326,11 +1355,11 @@ pmac_ide_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
 static int
 pmac_ide_pci_resume(struct pci_dev *pdev)
 {
-	ide_hwif_t	*hwif = (ide_hwif_t *)pci_get_drvdata(pdev);
-	int		rc = 0;
-	
+	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)pci_get_drvdata(pdev);
+	int rc = 0;
+
 	if (pdev->dev.power.power_state.event != PM_EVENT_ON) {
-		rc = pmac_ide_do_resume(hwif);
+		rc = pmac_ide_do_resume(pmif);
 		if (rc == 0)
 			pdev->dev.power.power_state = PMSG_ON;
 	}
@@ -1421,10 +1450,11 @@ out:
 static int
 pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq)
 {
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct dbdma_cmd *table;
 	int i, count = 0;
-	ide_hwif_t *hwif = HWIF(drive);
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
 	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	struct scatterlist *sg;
 	int wr = (rq_data_dir(rq) == WRITE);
@@ -1520,7 +1550,8 @@ static int
 pmac_ide_dma_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct request *rq = HWGROUP(drive)->rq;
 	u8 unit = (drive->select.b.unit & 0x01);
 	u8 ata4;
@@ -1560,7 +1591,9 @@ pmac_ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
 static void
 pmac_ide_dma_start(ide_drive_t *drive)
 {
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	volatile struct dbdma_regs __iomem *dma;
 
 	dma = pmif->dma_regs;
@@ -1576,7 +1609,9 @@ pmac_ide_dma_start(ide_drive_t *drive)
 static int
 pmac_ide_dma_end (ide_drive_t *drive)
 {
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	volatile struct dbdma_regs __iomem *dma;
 	u32 dstat;
 	
@@ -1604,7 +1639,9 @@ pmac_ide_dma_end (ide_drive_t *drive)
 static int
 pmac_ide_dma_test_irq (ide_drive_t *drive)
 {
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	volatile struct dbdma_regs __iomem *dma;
 	unsigned long status, timeout;
 
@@ -1664,7 +1701,9 @@ static void pmac_ide_dma_host_set(ide_drive_t *drive, int on)
 static void
 pmac_ide_dma_lost_irq (ide_drive_t *drive)
 {
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	volatile struct dbdma_regs __iomem *dma;
 	unsigned long status;
 
@@ -1694,7 +1733,8 @@ static const struct ide_dma_ops pmac_dma_ops = {
 static int __devinit pmac_ide_init_dma(ide_hwif_t *hwif,
 				       const struct ide_port_info *d)
 {
-	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
 	/* We won't need pci_dev if we switch to generic consistent
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 65fc08b..b15cad5 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -73,15 +73,12 @@ static void ide_pci_clear_simplex(unsigned long dma_base, const char *name)
  *	@d: IDE port info
  *
  *	Fetch the DMA Bus-Master-I/O-Base-Address (BMIBA) from PCI space.
- *	Where a device has a partner that is already in DMA mode we check
- *	and enforce IDE simplex rules.
  */
 
 unsigned long ide_pci_dma_base(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long dma_base = 0;
-	u8 dma_stat = 0;
 
 	if (hwif->host_flags & IDE_HFLAG_MMIO)
 		return hwif->dma_base;
@@ -102,11 +99,19 @@ unsigned long ide_pci_dma_base(ide_hwif_t *hwif, const struct ide_port_info *d)
 	if (hwif->channel)
 		dma_base += 8;
 
-	if (d->host_flags & IDE_HFLAG_CS5520)
+	return dma_base;
+}
+EXPORT_SYMBOL_GPL(ide_pci_dma_base);
+
+int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
+{
+	u8 dma_stat;
+
+	if (d->host_flags & (IDE_HFLAG_MMIO | IDE_HFLAG_CS5520))
 		goto out;
 
 	if (d->host_flags & IDE_HFLAG_CLEAR_SIMPLEX) {
-		ide_pci_clear_simplex(dma_base, d->name);
+		ide_pci_clear_simplex(hwif->dma_base, d->name);
 		goto out;
 	}
 
@@ -120,15 +125,15 @@ unsigned long ide_pci_dma_base(ide_hwif_t *hwif, const struct ide_port_info *d)
 	 * we tune the drive then try to grab DMA ownership if we want to be
 	 * the DMA end.  This has to be become dynamic to handle hot-plug.
 	 */
-	dma_stat = hwif->INB(dma_base + 2);
+	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
 	if ((dma_stat & 0x80) && hwif->mate && hwif->mate->dma_base) {
 		printk(KERN_INFO "%s: simplex device: DMA disabled\n", d->name);
-		dma_base = 0;
+		return -1;
 	}
 out:
-	return dma_base;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(ide_pci_dma_base);
+EXPORT_SYMBOL_GPL(ide_pci_check_simplex);
 
 /*
  * Set up BM-DMA capability (PnP BIOS should have done this)
@@ -284,33 +289,31 @@ static int ide_pci_check_iomem(struct pci_dev *dev, const struct ide_port_info *
 }
 
 /**
- *	ide_hwif_configure	-	configure an IDE interface
+ *	ide_hw_configure	-	configure a hw_regs_t instance
  *	@dev: PCI device holding interface
  *	@d: IDE port info
  *	@port: port number
  *	@irq: PCI IRQ
+ *	@hw: hw_regs_t instance corresponding to this port
  *
  *	Perform the initial set up for the hardware interface structure. This
  *	is done per interface port rather than per PCI device. There may be
  *	more than one port per device.
  *
- *	Returns the new hardware interface structure, or NULL on a failure
+ *	Returns zero on success or an error code.
  */
 
-static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
-				      const struct ide_port_info *d,
-				      unsigned int port, int irq)
+static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
+			    unsigned int port, int irq, hw_regs_t *hw)
 {
 	unsigned long ctl = 0, base = 0;
-	ide_hwif_t *hwif;
-	struct hw_regs_s hw;
 
 	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
 		if (ide_pci_check_iomem(dev, d, 2 * port) ||
 		    ide_pci_check_iomem(dev, d, 2 * port + 1)) {
 			printk(KERN_ERR "%s: I/O baseregs (BIOS) are reported "
 					"as MEM for port %d!\n", d->name, port);
-			return NULL;
+			return -EINVAL;
 		}
 
 		ctl  = pci_resource_start(dev, 2*port+1);
@@ -324,22 +327,16 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
 	if (!base || !ctl) {
 		printk(KERN_ERR "%s: bad PCI BARs for port %d, skipping\n",
 				d->name, port);
-		return NULL;
+		return -EINVAL;
 	}
 
-	hwif = ide_find_port_slot(d);
-	if (hwif == NULL)
-		return NULL;
-
-	memset(&hw, 0, sizeof(hw));
-	hw.irq = irq;
-	hw.dev = &dev->dev;
-	hw.chipset = d->chipset ? d->chipset : ide_pci;
-	ide_std_init_ports(&hw, base, ctl | 2);
-
-	ide_init_port_hw(hwif, &hw);
+	memset(hw, 0, sizeof(*hw));
+	hw->irq = irq;
+	hw->dev = &dev->dev;
+	hw->chipset = d->chipset ? d->chipset : ide_pci;
+	ide_std_init_ports(hw, base, ctl | 2);
 
-	return hwif;
+	return 0;
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
@@ -362,7 +359,15 @@ int ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 	     (dev->class & 0x80))) {
 		unsigned long base = ide_pci_dma_base(hwif, d);
 
-		if (base == 0 || ide_pci_set_master(dev, d->name) < 0)
+		if (base == 0)
+			return -1;
+
+		hwif->dma_base = base;
+
+		if (ide_pci_check_simplex(hwif, d) < 0)
+			return -1;
+
+		if (ide_pci_set_master(dev, d->name) < 0)
 			return -1;
 
 		if (hwif->host_flags & IDE_HFLAG_MMIO)
@@ -376,7 +381,7 @@ int ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 		if (ide_allocate_dma_engine(hwif))
 			return -1;
 
-		ide_setup_dma(hwif, base);
+		hwif->dma_ops = &sff_dma_ops;
 	}
 
 	return 0;
@@ -429,7 +434,8 @@ out:
  *	@dev: PCI device
  *	@d: IDE port info
  *	@pciirq: IRQ line
- *	@idx: ATA index table to update
+ *	@hw: hw_regs_t instances corresponding to this PCI IDE device
+ *	@hws: hw_regs_t pointers table to update
  *
  *	Scan the interfaces attached to this device and do any
  *	necessary per port setup. Attach the devices and ask the
@@ -440,10 +446,10 @@ out:
  *	where the chipset setup is not the default PCI IDE one.
  */
 
-void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d, int pciirq, u8 *idx)
+void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d,
+			 int pciirq, hw_regs_t *hw, hw_regs_t **hws)
 {
 	int channels = (d->host_flags & IDE_HFLAG_SINGLE) ? 1 : 2, port;
-	ide_hwif_t *hwif;
 	u8 tmp;
 
 	/*
@@ -459,11 +465,10 @@ void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d, int
 			continue;	/* port not enabled */
 		}
 
-		hwif = ide_hwif_configure(dev, d, port, pciirq);
-		if (hwif == NULL)
+		if (ide_hw_configure(dev, d, port, pciirq, hw + port))
 			continue;
 
-		*(idx + port) = hwif->index;
+		*(hws + port) = hw + port;
 	}
 }
 EXPORT_SYMBOL_GPL(ide_pci_setup_ports);
@@ -480,7 +485,7 @@ EXPORT_SYMBOL_GPL(ide_pci_setup_ports);
  */
 static int do_ide_setup_pci_device(struct pci_dev *dev,
 				   const struct ide_port_info *d,
-				   u8 *idx, u8 noisy)
+				   u8 noisy)
 {
 	int tried_config = 0;
 	int pciirq, ret;
@@ -529,22 +534,24 @@ static int do_ide_setup_pci_device(struct pci_dev *dev,
 				d->name, pciirq);
 	}
 
-	/* FIXME: silent failure can happen */
-
-	ide_pci_setup_ports(dev, d, pciirq, idx);
+	ret = pciirq;
 out:
 	return ret;
 }
 
 int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
 {
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 	int ret;
 
-	ret = do_ide_setup_pci_device(dev, d, &idx[0], 1);
+	ret = do_ide_setup_pci_device(dev, d, 1);
+
+	if (ret >= 0) {
+		/* FIXME: silent failure can happen */
+		ide_pci_setup_ports(dev, d, ret, &hw[0], &hws[0]);
 
-	if (ret >= 0)
-		ide_device_add(idx, d);
+		ret = ide_host_add(d, hws, NULL);
+	}
 
 	return ret;
 }
@@ -555,19 +562,23 @@ int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
 {
 	struct pci_dev *pdev[] = { dev1, dev2 };
 	int ret, i;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 
 	for (i = 0; i < 2; i++) {
-		ret = do_ide_setup_pci_device(pdev[i], d, &idx[i*2], !i);
+		ret = do_ide_setup_pci_device(pdev[i], d, !i);
+
 		/*
 		 * FIXME: Mom, mom, they stole me the helper function to undo
 		 * do_ide_setup_pci_device() on the first device!
 		 */
 		if (ret < 0)
 			goto out;
+
+		/* FIXME: silent failure can happen */
+		ide_pci_setup_ports(pdev[i], d, ret, &hw[i*2], &hws[i*2]);
 	}
 
-	ide_device_add(idx, d);
+	ret = ide_host_add(d, hws, NULL);
 out:
 	return ret;
 }
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index f843c13..5385524 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -84,7 +84,6 @@ typedef struct ide_scsi_obj {
 	struct Scsi_Host	*host;
 
 	struct ide_atapi_pc *pc;		/* Current packet command */
-	unsigned long flags;			/* Status/Action flags */
 	unsigned long transform;		/* SCSI cmd translation layer */
 	unsigned long log;			/* log flags */
 } idescsi_scsi_t;
@@ -126,23 +125,14 @@ static inline idescsi_scsi_t *drive_to_idescsi(ide_drive_t *ide_drive)
 }
 
 /*
- *	Per ATAPI device status bits.
- */
-#define IDESCSI_DRQ_INTERRUPT		0	/* DRQ interrupt device */
-
-/*
- *	ide-scsi requests.
- */
-#define IDESCSI_PC_RQ			90
-
-/*
  *	PIO data transfer routine using the scatter gather table.
  */
 static void ide_scsi_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				unsigned int bcount, int write)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	xfer_func_t *xf = write ? hwif->output_data : hwif->input_data;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
+	xfer_func_t *xf = write ? tp_ops->output_data : tp_ops->input_data;
 	char *buf;
 	int count;
 
@@ -228,7 +218,6 @@ static int idescsi_check_condition(ide_drive_t *drive,
 	rq->cmd_type = REQ_TYPE_SENSE;
 	rq->cmd_flags |= REQ_PREEMPT;
 	pc->timeout = jiffies + WAIT_READY;
-	pc->callback = ide_scsi_callback;
 	/* NOTE! Save the failed packet command in "rq->buffer" */
 	rq->buffer = (void *) failed_cmd->special;
 	pc->scsi_cmd = ((struct ide_atapi_pc *) failed_cmd->special)->scsi_cmd;
@@ -237,6 +226,7 @@ static int idescsi_check_condition(ide_drive_t *drive,
 		ide_scsi_hex_dump(pc->c, 6);
 	}
 	rq->rq_disk = scsi->disk;
+	memcpy(rq->cmd, pc->c, 12);
 	ide_do_drive_cmd(drive, rq);
 	return 0;
 }
@@ -246,10 +236,9 @@ idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->tp_ops->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTBSYNC(hwif, WIN_IDLEIMMEDIATE,
-			       hwif->io_ports.command_addr);
+		hwif->tp_ops->exec_command(hwif, WIN_IDLEIMMEDIATE);
 
 	rq->errors++;
 
@@ -421,10 +410,6 @@ static ide_startstop_t idescsi_do_request (ide_drive_t *drive, struct request *r
 
 	if (blk_sense_request(rq) || blk_special_request(rq)) {
 		struct ide_atapi_pc *pc = (struct ide_atapi_pc *)rq->special;
-		idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-
-		if (test_bit(IDESCSI_DRQ_INTERRUPT, &scsi->flags))
-			pc->flags |= PC_FLAG_DRQ_INTERRUPT;
 
 		if (drive->using_dma && !idescsi_map_sg(drive, pc))
 			pc->flags |= PC_FLAG_DMA_OK;
@@ -460,11 +445,14 @@ static inline void idescsi_add_settings(ide_drive_t *drive) { ; }
 static void idescsi_setup (ide_drive_t *drive, idescsi_scsi_t *scsi)
 {
 	if (drive->id && (drive->id->config & 0x0060) == 0x20)
-		set_bit (IDESCSI_DRQ_INTERRUPT, &scsi->flags);
+		set_bit(IDE_AFLAG_DRQ_INTERRUPT, &drive->atapi_flags);
 	clear_bit(IDESCSI_SG_TRANSFORM, &scsi->transform);
 #if IDESCSI_DEBUG_LOG
 	set_bit(IDESCSI_LOG_CMD, &scsi->log);
 #endif /* IDESCSI_DEBUG_LOG */
+
+	drive->pc_callback = ide_scsi_callback;
+
 	idescsi_add_settings(drive);
 }
 
@@ -616,7 +604,6 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	pc->scsi_cmd = cmd;
 	pc->done = done;
 	pc->timeout = jiffies + cmd->timeout_per_command;
-	pc->callback = ide_scsi_callback;
 
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: que %lu, cmd = ", drive->name, cmd->serial_number);
@@ -631,6 +618,7 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	rq->special = (char *) pc;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	spin_unlock_irq(host->host_lock);
+	memcpy(rq->cmd, pc->c, 12);
 	blk_execute_rq_nowait(drive->queue, scsi->disk, rq, 0, NULL);
 	spin_lock_irq(host->host_lock);
 	return 0;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 4726126..d67ccca 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -178,6 +178,7 @@ typedef struct hw_regs_s {
 	ide_ack_intr_t	*ack_intr;		/* acknowledge interrupt */
 	hwif_chipset_t  chipset;
 	struct device	*dev, *parent;
+	unsigned long	config;
 } hw_regs_t;
 
 void ide_init_port_data(struct hwif_s *, unsigned int);
@@ -307,7 +308,65 @@ struct ide_acpi_drive_link;
 struct ide_acpi_hwif_link;
 #endif
 
-typedef struct ide_drive_s {
+/* ATAPI device flags */
+enum {
+	IDE_AFLAG_DRQ_INTERRUPT		= (1 << 0),
+	IDE_AFLAG_MEDIA_CHANGED		= (1 << 1),
+
+	/* ide-cd */
+	/* Drive cannot lock the door. */
+	IDE_AFLAG_NO_DOORLOCK		= (1 << 2),
+	/* Drive cannot eject the disc. */
+	IDE_AFLAG_NO_EJECT		= (1 << 3),
+	/* Drive is a pre ATAPI 1.2 drive. */
+	IDE_AFLAG_PRE_ATAPI12		= (1 << 4),
+	/* TOC addresses are in BCD. */
+	IDE_AFLAG_TOCADDR_AS_BCD	= (1 << 5),
+	/* TOC track numbers are in BCD. */
+	IDE_AFLAG_TOCTRACKS_AS_BCD	= (1 << 6),
+	/*
+	 * Drive does not provide data in multiples of SECTOR_SIZE
+	 * when more than one interrupt is needed.
+	 */
+	IDE_AFLAG_LIMIT_NFRAMES		= (1 << 7),
+	/* Seeking in progress. */
+	IDE_AFLAG_SEEKING		= (1 << 8),
+	/* Saved TOC information is current. */
+	IDE_AFLAG_TOC_VALID		= (1 << 9),
+	/* We think that the drive door is locked. */
+	IDE_AFLAG_DOOR_LOCKED		= (1 << 10),
+	/* SET_CD_SPEED command is unsupported. */
+	IDE_AFLAG_NO_SPEED_SELECT	= (1 << 11),
+	IDE_AFLAG_VERTOS_300_SSD	= (1 << 12),
+	IDE_AFLAG_VERTOS_600_ESD	= (1 << 13),
+	IDE_AFLAG_SANYO_3CD		= (1 << 14),
+	IDE_AFLAG_FULL_CAPS_PAGE	= (1 << 15),
+	IDE_AFLAG_PLAY_AUDIO_OK		= (1 << 16),
+	IDE_AFLAG_LE_SPEED_FIELDS	= (1 << 17),
+
+	/* ide-floppy */
+	/* Format in progress */
+	IDE_AFLAG_FORMAT_IN_PROGRESS	= (1 << 18),
+	/* Avoid commands not supported in Clik drive */
+	IDE_AFLAG_CLIK_DRIVE		= (1 << 19),
+	/* Requires BH algorithm for packets */
+	IDE_AFLAG_ZIP_DRIVE		= (1 << 20),
+
+	/* ide-tape */
+	IDE_AFLAG_IGNORE_DSC		= (1 << 21),
+	/* 0 When the tape position is unknown */
+	IDE_AFLAG_ADDRESS_VALID		= (1 <<	22),
+	/* Device already opened */
+	IDE_AFLAG_BUSY			= (1 << 23),
+	/* Attempt to auto-detect the current user block size */
+	IDE_AFLAG_DETECT_BS		= (1 << 24),
+	/* Currently on a filemark */
+	IDE_AFLAG_FILEMARK		= (1 << 25),
+	/* 0 = no tape is loaded, so we don't rewind after ejecting */
+	IDE_AFLAG_MEDIUM_PRESENT	= (1 << 26)
+};
+
+struct ide_drive_s {
 	char		name[4];	/* drive name, such as "hda" */
         char            driver_req[10];	/* requests specific driver */
 
@@ -355,7 +414,6 @@ typedef struct ide_drive_s {
 	unsigned nodma		: 1;	/* disallow DMA */
 	unsigned remap_0_to_1	: 1;	/* 0=noremap, 1=remap 0->1 (for EZDrive) */
 	unsigned blocked        : 1;	/* 1=powermanagment told us not to do anything, so sleep nicely */
-	unsigned vdma		: 1;	/* 1=doing PIO over DMA 0=doing normal DMA */
 	unsigned scsi		: 1;	/* 0=default, 1=ide-scsi emulation */
 	unsigned sleeping	: 1;	/* 1=sleeping & sleep field valid */
 	unsigned post_reset	: 1;
@@ -400,7 +458,14 @@ typedef struct ide_drive_s {
 	struct list_head list;
 	struct device	gendev;
 	struct completion gendev_rel_comp;	/* to deal with device release() */
-} ide_drive_t;
+
+	/* callback for packet commands */
+	void (*pc_callback)(struct ide_drive_s *);
+
+	unsigned long atapi_flags;
+};
+
+typedef struct ide_drive_s ide_drive_t;
 
 #define to_ide_device(dev)container_of(dev, ide_drive_t, gendev)
 
@@ -408,8 +473,28 @@ typedef struct ide_drive_s {
     ((1<<ide_pci)|(1<<ide_cmd646)|(1<<ide_ali14xx))
 #define IDE_CHIPSET_IS_PCI(c)	((IDE_CHIPSET_PCI_MASK >> (c)) & 1)
 
+struct ide_task_s;
 struct ide_port_info;
 
+struct ide_tp_ops {
+	void	(*exec_command)(struct hwif_s *, u8);
+	u8	(*read_status)(struct hwif_s *);
+	u8	(*read_altstatus)(struct hwif_s *);
+	u8	(*read_sff_dma_status)(struct hwif_s *);
+
+	void	(*set_irq)(struct hwif_s *, int);
+
+	void	(*tf_load)(ide_drive_t *, struct ide_task_s *);
+	void	(*tf_read)(ide_drive_t *, struct ide_task_s *);
+
+	void	(*input_data)(ide_drive_t *, struct request *, void *,
+			      unsigned int);
+	void	(*output_data)(ide_drive_t *, struct request *, void *,
+			       unsigned int);
+};
+
+extern const struct ide_tp_ops default_tp_ops;
+
 struct ide_port_ops {
 	/* host specific initialization of a device */
 	void	(*init_dev)(ide_drive_t *);
@@ -447,8 +532,6 @@ struct ide_dma_ops {
 	void	(*dma_timeout)(struct ide_drive_s *);
 };
 
-struct ide_task_s;
-
 typedef struct hwif_s {
 	struct hwif_s *next;		/* for linked-list in ide_hwgroup_t */
 	struct hwif_s *mate;		/* other hwif from same PCI chip */
@@ -486,22 +569,12 @@ typedef struct hwif_s {
 
 	void (*rw_disk)(ide_drive_t *, struct request *);
 
+	const struct ide_tp_ops		*tp_ops;
 	const struct ide_port_ops	*port_ops;
 	const struct ide_dma_ops	*dma_ops;
 
-	void (*tf_load)(ide_drive_t *, struct ide_task_s *);
-	void (*tf_read)(ide_drive_t *, struct ide_task_s *);
-
-	void (*input_data)(ide_drive_t *, struct request *, void *, unsigned);
-	void (*output_data)(ide_drive_t *, struct request *, void *, unsigned);
-
 	void (*ide_dma_clear_irq)(ide_drive_t *drive);
 
-	void (*OUTB)(u8 addr, unsigned long port);
-	void (*OUTBSYNC)(struct hwif_s *hwif, u8 addr, unsigned long port);
-
-	u8  (*INB)(unsigned long port);
-
 	/* dma physical region descriptor table (cpu view) */
 	unsigned int	*dmatable_cpu;
 	/* dma physical region descriptor table (dma view) */
@@ -524,8 +597,6 @@ typedef struct hwif_s {
 	int		irq;		/* our irq number */
 
 	unsigned long	dma_base;	/* base addr for dma ports */
-	unsigned long	dma_command;	/* dma command register */
-	unsigned long	dma_status;	/* dma status register */
 
 	unsigned long	config_data;	/* for use by chipset-specific code */
 	unsigned long	select_data;	/* for use by chipset-specific code */
@@ -552,6 +623,11 @@ typedef struct hwif_s {
 #endif
 } ____cacheline_internodealigned_in_smp ide_hwif_t;
 
+struct ide_host {
+	ide_hwif_t	*ports[MAX_HWIFS];
+	unsigned int	n_ports;
+};
+
 /*
  *  internal ide interrupt handler type
  */
@@ -611,8 +687,6 @@ enum {
 	PC_FLAG_WRITING			= (1 << 6),
 	/* command timed out */
 	PC_FLAG_TIMEDOUT		= (1 << 7),
-	PC_FLAG_ZIP_DRIVE		= (1 << 8),
-	PC_FLAG_DRQ_INTERRUPT		= (1 << 9),
 };
 
 struct ide_atapi_pc {
@@ -646,8 +720,6 @@ struct ide_atapi_pc {
 	 */
 	u8 pc_buf[256];
 
-	void (*callback)(ide_drive_t *);
-
 	/* idetape only */
 	struct idetape_bh *bh;
 	char *b_data;
@@ -807,13 +879,6 @@ int generic_ide_ioctl(ide_drive_t *, struct file *, struct block_device *, unsig
 extern int ide_vlb_clk;
 extern int ide_pci_clk;
 
-ide_hwif_t *ide_find_port_slot(const struct ide_port_info *);
-
-static inline ide_hwif_t *ide_find_port(void)
-{
-	return ide_find_port_slot(NULL);
-}
-
 extern int ide_end_request (ide_drive_t *drive, int uptodate, int nrsecs);
 int ide_end_dequeued_request(ide_drive_t *drive, struct request *rq,
 			     int uptodate, int nr_sectors);
@@ -884,6 +949,7 @@ enum {
 	IDE_TFLAG_IN_HOB		= IDE_TFLAG_IN_HOB_FEATURE |
 					  IDE_TFLAG_IN_HOB_NSECT |
 					  IDE_TFLAG_IN_HOB_LBA,
+	IDE_TFLAG_IN_FEATURE		= (1 << 1),
 	IDE_TFLAG_IN_NSECT		= (1 << 25),
 	IDE_TFLAG_IN_LBAL		= (1 << 26),
 	IDE_TFLAG_IN_LBAM		= (1 << 27),
@@ -948,9 +1014,25 @@ typedef struct ide_task_s {
 
 void ide_tf_dump(const char *, struct ide_taskfile *);
 
+void ide_exec_command(ide_hwif_t *, u8);
+u8 ide_read_status(ide_hwif_t *);
+u8 ide_read_altstatus(ide_hwif_t *);
+u8 ide_read_sff_dma_status(ide_hwif_t *);
+
+void ide_set_irq(ide_hwif_t *, int);
+
+void ide_tf_load(ide_drive_t *, ide_task_t *);
+void ide_tf_read(ide_drive_t *, ide_task_t *);
+
+void ide_input_data(ide_drive_t *, struct request *, void *, unsigned int);
+void ide_output_data(ide_drive_t *, struct request *, void *, unsigned int);
+
 extern void SELECT_DRIVE(ide_drive_t *);
 void SELECT_MASK(ide_drive_t *, int);
 
+u8 ide_read_error(ide_drive_t *);
+void ide_read_bcount_and_ireason(ide_drive_t *, u16 *, u8 *);
+
 extern int drive_is_ready(ide_drive_t *);
 
 void ide_pktcmd_tf_load(ide_drive_t *, u32, u16, u8);
@@ -1000,12 +1082,15 @@ extern int __ide_pci_register_driver(struct pci_driver *driver, struct module *o
 #define ide_pci_register_driver(d) pci_register_driver(d)
 #endif
 
-void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *, int, u8 *);
+void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *, int,
+			 hw_regs_t *, hw_regs_t **);
 void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 int ide_pci_set_master(struct pci_dev *, const char *);
 unsigned long ide_pci_dma_base(ide_hwif_t *, const struct ide_port_info *);
+extern const struct ide_dma_ops sff_dma_ops;
+int ide_pci_check_simplex(ide_hwif_t *, const struct ide_port_info *);
 int ide_hwif_setup_dma(ide_hwif_t *, const struct ide_port_info *);
 #else
 static inline int ide_hwif_setup_dma(ide_hwif_t *hwif,
@@ -1015,10 +1100,6 @@ static inline int ide_hwif_setup_dma(ide_hwif_t *hwif,
 }
 #endif
 
-extern void default_hwif_iops(ide_hwif_t *);
-extern void default_hwif_mmiops(ide_hwif_t *);
-extern void default_hwif_transport(ide_hwif_t *);
-
 typedef struct ide_pci_enablebit_s {
 	u8	reg;	/* byte pci reg holding the enable-bit */
 	u8	mask;	/* mask to isolate the enable-bit */
@@ -1081,7 +1162,6 @@ enum {
 	IDE_HFLAG_IO_32BIT		= (1 << 24),
 	/* unmask IRQs */
 	IDE_HFLAG_UNMASK_IRQS		= (1 << 25),
-	IDE_HFLAG_ABUSE_SET_DMA_MODE	= (1 << 26),
 	/* serialize ports if DMA is possible (for sl82c105) */
 	IDE_HFLAG_SERIALIZE_DMA		= (1 << 27),
 	/* force host out of "simplex" mode */
@@ -1092,8 +1172,6 @@ enum {
 	IDE_HFLAG_NO_IO_32BIT		= (1 << 30),
 	/* never unmask IRQs */
 	IDE_HFLAG_NO_UNMASK_IRQS	= (1 << 31),
-	/* host uses VDMA (disabled for now) */
-	IDE_HFLAG_VDMA			= 0,
 };
 
 #ifdef CONFIG_BLK_DEV_OFFBOARD
@@ -1110,6 +1188,7 @@ struct ide_port_info {
 	int			(*init_dma)(ide_hwif_t *,
 					    const struct ide_port_info *);
 
+	const struct ide_tp_ops		*tp_ops;
 	const struct ide_port_ops	*port_ops;
 	const struct ide_dma_ops	*dma_ops;
 
@@ -1163,7 +1242,6 @@ void ide_destroy_dmatable(ide_drive_t *);
 extern int ide_build_dmatable(ide_drive_t *, struct request *);
 int ide_allocate_dma_engine(ide_hwif_t *);
 void ide_release_dma_engine(ide_hwif_t *);
-void ide_setup_dma(ide_hwif_t *, unsigned long);
 
 void ide_dma_host_set(ide_drive_t *, int);
 extern int ide_dma_setup(ide_drive_t *);
@@ -1217,8 +1295,14 @@ void ide_undecoded_slave(ide_drive_t *);
 
 void ide_port_apply_params(ide_hwif_t *);
 
-int ide_device_add_all(u8 *idx, const struct ide_port_info *);
-int ide_device_add(u8 idx[4], const struct ide_port_info *);
+struct ide_host *ide_host_alloc_all(const struct ide_port_info *, hw_regs_t **);
+struct ide_host *ide_host_alloc(const struct ide_port_info *, hw_regs_t **);
+void ide_host_free(struct ide_host *);
+int ide_host_register(struct ide_host *, const struct ide_port_info *,
+		      hw_regs_t **);
+int ide_host_add(const struct ide_port_info *, hw_regs_t **,
+		 struct ide_host **);
+void ide_host_remove(struct ide_host *);
 int ide_legacy_device_add(const struct ide_port_info *, unsigned long);
 void ide_port_unregister_devices(ide_hwif_t *);
 void ide_port_scan(ide_hwif_t *);
@@ -1350,33 +1434,4 @@ static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
 
 	return &hwif->drives[(drive->dn ^ 1) & 1];
 }
-
-static inline void ide_set_irq(ide_drive_t *drive, int on)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	hwif->OUTBSYNC(hwif, ATA_DEVCTL_OBS | (on ? 0 : 2),
-		       hwif->io_ports.ctl_addr);
-}
-
-static inline u8 ide_read_status(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	return hwif->INB(hwif->io_ports.status_addr);
-}
-
-static inline u8 ide_read_altstatus(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	return hwif->INB(hwif->io_ports.ctl_addr);
-}
-
-static inline u8 ide_read_error(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	return hwif->INB(hwif->io_ports.error_addr);
-}
 #endif /* _IDE_H */
