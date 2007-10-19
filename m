Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbXJTBnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbXJTBnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 21:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbXJTBnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 21:43:11 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:44140 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbXJTBnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:43:01 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates (part 5)
Date: Sat, 20 Oct 2007 00:48:10 +0200
User-Agent: KMail/1.9.7
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710200048.10502.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This is the final part, contains:

* important bugfix from Adrian Bunk for sis5513 host driver
  (for the bug introduced in one of the previous updates)

* more small fixups/cleanups


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig                 |    3 +
 drivers/ide/arm/bast-ide.c          |    2 +-
 drivers/ide/arm/icside.c            |   62 +++--------
 drivers/ide/arm/ide_arm.c           |    2 +-
 drivers/ide/arm/rapide.c            |   37 ++-----
 drivers/ide/cris/ide-cris.c         |    2 +-
 drivers/ide/h8300/ide-h8300.c       |    3 +-
 drivers/ide/ide-acpi.c              |    2 +-
 drivers/ide/ide-disk.c              |   24 +----
 drivers/ide/ide-dma.c               |   32 ++----
 drivers/ide/ide-io.c                |   59 ++++------
 drivers/ide/ide-iops.c              |   26 +----
 drivers/ide/ide-pnp.c               |    3 +-
 drivers/ide/ide-probe.c             |   87 ++++++++-------
 drivers/ide/ide-proc.c              |    2 -
 drivers/ide/ide-tape.c              |    1 -
 drivers/ide/ide-taskfile.c          |   37 ++-----
 drivers/ide/ide.c                   |   73 ++++++++-----
 drivers/ide/legacy/ali14xx.c        |   13 +--
 drivers/ide/legacy/buddha.c         |    4 +-
 drivers/ide/legacy/dtc2278.c        |   16 ++--
 drivers/ide/legacy/falconide.c      |    2 +-
 drivers/ide/legacy/gayle.c          |    2 +-
 drivers/ide/legacy/ht6560b.c        |   33 +++---
 drivers/ide/legacy/ide-cs.c         |    2 +-
 drivers/ide/legacy/ide_platform.c   |   43 +++-----
 drivers/ide/legacy/macide.c         |    6 +-
 drivers/ide/legacy/q40ide.c         |    5 +-
 drivers/ide/legacy/qd65xx.c         |   64 ++++--------
 drivers/ide/legacy/umc8672.c        |    9 +-
 drivers/ide/mips/au1xxx-ide.c       |   19 ++--
 drivers/ide/mips/swarm.c            |   14 +--
 drivers/ide/pci/aec62xx.c           |   25 +----
 drivers/ide/pci/alim15x3.c          |  109 +++++++++----------
 drivers/ide/pci/amd74xx.c           |   29 ++---
 drivers/ide/pci/atiixp.c            |    3 +-
 drivers/ide/pci/cmd640.c            |   42 ++++----
 drivers/ide/pci/cmd64x.c            |    6 +-
 drivers/ide/pci/cs5520.c            |   26 +----
 drivers/ide/pci/cs5530.c            |   10 +--
 drivers/ide/pci/cs5535.c            |    2 +-
 drivers/ide/pci/cy82c693.c          |    4 +-
 drivers/ide/pci/delkin_cb.c         |    2 +-
 drivers/ide/pci/generic.c           |   31 ++----
 drivers/ide/pci/hpt34x.c            |    4 +-
 drivers/ide/pci/hpt366.c            |    4 +-
 drivers/ide/pci/it8213.c            |    2 +-
 drivers/ide/pci/it821x.c            |    2 +-
 drivers/ide/pci/jmicron.c           |    2 +-
 drivers/ide/pci/ns87415.c           |    2 +-
 drivers/ide/pci/opti621.c           |   10 +-
 drivers/ide/pci/pdc202xx_new.c      |    4 +-
 drivers/ide/pci/pdc202xx_old.c      |   22 ++---
 drivers/ide/pci/piix.c              |    6 +-
 drivers/ide/pci/rz1000.c            |    7 +-
 drivers/ide/pci/sc1200.c            |    2 +-
 drivers/ide/pci/scc_pata.c          |   11 +-
 drivers/ide/pci/serverworks.c       |   11 +--
 drivers/ide/pci/sgiioc4.c           |   16 ++--
 drivers/ide/pci/siimage.c           |   92 ++++++++---------
 drivers/ide/pci/sis5513.c           |    4 +-
 drivers/ide/pci/sl82c105.c          |   14 +--
 drivers/ide/pci/slc90e66.c          |   10 +-
 drivers/ide/pci/tc86c001.c          |    2 +-
 drivers/ide/pci/triflex.c           |    2 +-
 drivers/ide/pci/trm290.c            |    4 +-
 drivers/ide/pci/via82cxxx.c         |   81 ++++++--------
 drivers/ide/ppc/mpc8xx.c            |    4 +-
 drivers/ide/ppc/pmac.c              |   12 ++-
 drivers/ide/setup-pci.c             |  202 +++++++++++++++--------------------
 drivers/macintosh/mediabay.c        |    2 +-
 include/asm-alpha/ide.h             |    1 -
 include/asm-arm/ide.h               |    1 -
 include/asm-blackfin/ide.h          |    1 -
 include/asm-cris/arch-v32/ide.h     |    2 +-
 include/asm-ia64/ide.h              |    1 -
 include/asm-m32r/ide.h              |    1 -
 include/asm-m68k/ide.h              |    2 +-
 include/asm-mips/mach-generic/ide.h |    1 -
 include/asm-parisc/ide.h            |    1 -
 include/asm-powerpc/ide.h           |    3 +-
 include/asm-sh64/ide.h              |    1 -
 include/asm-sparc/ide.h             |    1 -
 include/asm-sparc64/ide.h           |    1 -
 include/asm-x86/ide.h               |    1 -
 include/linux/ide.h                 |  109 ++++++-------------
 86 files changed, 669 insertions(+), 970 deletions(-)


Adrian Bunk (1):
      ide/pci/sis5513.c: add missing "else"

Alan Cox (1):
      dtc2278: note on docs

Bartlomiej Zolnierkiewicz (47):
      cmd64x: always set hwif->chipset for CMD646
      ide: fix disabled ports reporting for PCI controllers
      rz1000: set serialized flag only if mate interface exists
      serverworks: remove dead code from svwks_set_dma_mode()
      ide: add hwif_register_devices() helper
      ide: remove unused ->next field from ide_pci_device_t
      ide: add ->chipset field to ide_pci_device_t
      ide: add IDE_HFLAG_FORCE_LEGACY_IRQS host flag
      ide: add IDE_HFLAG_RQSIZE_256 host flag
      ide: add IDE_HFLAG_{IO_32BIT,UNMASK_IRQS} host flags
      alim15x3: fix CD_ROM DMA and PIO FIFO settings setup
      alim15x3: use ->host_flags and ->udma_mask fields from ide_pci_device_t
      aec62xx: remove aec62xx_dma_lost_irq()
      siimage: separate PATA and SATA methods
      ide: add ->fixup method to ide_hwif_t
      ide: add ide_device_add()
      ide: add ide_find_port() helper
      ide: remove redundant comments from ide.h
      ide: add CONFIG_IDE_ARCH_OBSOLETE_INIT
      ide: fix ide_register_hw() to check hwif->io_ports[]
      icside: use ec->dma directly
      ide: add hwif->ack_intr hook
      ide: remove write-only hwif->hw
      au1xxx-ide: set ->autotune and ->no_io_32bit also for the slave device
      dtc2278: set ->pio_mask also for the second port
      via82cxxx: keep local ide_pci_device_t copy
      ide: replace ide_pci_device_t by struct ide_port_info
      ide: constify struct ide_port_info
      ali14xx: fix deadlock on error handling
      dtc2278: fix deadlock on error handling
      qd65xx: fix deadlock on error handling
      opti621: fix deadlock on error handling
      slc90e66: fix deadlock on error handling
      cmd640: fix deadlock on error handling
      ht6560b: fix deadlock on error handling
      ide: take ide_lock for prefetch disable/enable in do_special()
      cs5530: remove needless ide_lock taking
      ide: enhance ide_setup_pci_noise()
      ide: use __ide_end_request() in ide_end_dequeued_request()
      ide: remove dead code from ide_driveid_update()
      ide: remove stale comments from ide-taskfile.c
      ide: PCI BMDMA initialization fixes (take 2)
      qd65xx: remove pointless qd_{read,write}_reg() (take 2)
      ide: check ->dma_setup() return value in flagged_taskfile()
      ide: check drive->using_dma in flagged_taskfile()
      ide: fix ->data_phase in taskfile_load_raw()
      ide-disk: add get_smart_data() helper

Robert P. J. Day (1):
      ide: remove inclusion of non-existent io_trace.h


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 6d9fd92..6eaece9 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -1056,6 +1056,9 @@ endif
 config BLK_DEV_IDEDMA
 	def_bool BLK_DEV_IDEDMA_PCI || BLK_DEV_IDEDMA_PMAC || BLK_DEV_IDEDMA_ICS || BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 
+config IDE_ARCH_OBSOLETE_INIT
+	def_bool ALPHA || (ARM && !ARCH_L7200) || BLACKFIN || X86 || IA64 || M32R || MIPS || PARISC || PPC || (SUPERH64 && BLK_DEV_IDEPCI) || SPARC
+
 endif
 
 config BLK_DEV_HD_ONLY
diff --git a/drivers/ide/arm/bast-ide.c b/drivers/ide/arm/bast-ide.c
index f7449d0..48db616 100644
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -45,7 +45,7 @@ bastide_register(unsigned int base, unsigned int aux, int irq,
 	hw.io_ports[IDE_CONTROL_OFFSET] = aux + (6 * 0x20);
 	hw.irq = irq;
 
-	ide_register_hw(&hw, 0, hwif);
+	ide_register_hw(&hw, NULL, 0, hwif);
 
 	return 0;
 }
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 3af33fb..410a0d1 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -316,27 +316,29 @@ static int icside_dma_end(ide_drive_t *drive)
 
 	drive->waiting_for_dma = 0;
 
-	disable_dma(hwif->hw.dma);
+	disable_dma(state->dev->dma);
 
 	/* Teardown mappings after DMA has completed. */
 	dma_unmap_sg(state->dev, hwif->sg_table, hwif->sg_nents,
 		     hwif->sg_dma_direction);
 
-	return get_dma_residue(hwif->hw.dma) != 0;
+	return get_dma_residue(state->dev->dma) != 0;
 }
 
 static void icside_dma_start(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	struct icside_state *state = hwif->hwif_data;
 
 	/* We can not enable DMA on both channels simultaneously. */
-	BUG_ON(dma_channel_active(hwif->hw.dma));
-	enable_dma(hwif->hw.dma);
+	BUG_ON(dma_channel_active(state->dev->dma));
+	enable_dma(state->dev->dma);
 }
 
 static int icside_dma_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	struct icside_state *state = hwif->hwif_data;
 	struct request *rq = hwif->hwgroup->rq;
 	unsigned int dma_mode;
 
@@ -348,7 +350,7 @@ static int icside_dma_setup(ide_drive_t *drive)
 	/*
 	 * We can not enable DMA on both channels.
 	 */
-	BUG_ON(dma_channel_active(hwif->hw.dma));
+	BUG_ON(dma_channel_active(state->dev->dma));
 
 	icside_build_sglist(drive, rq);
 
@@ -365,14 +367,14 @@ static int icside_dma_setup(ide_drive_t *drive)
 	/*
 	 * Select the correct timing for this drive.
 	 */
-	set_dma_speed(hwif->hw.dma, drive->drive_data);
+	set_dma_speed(state->dev->dma, drive->drive_data);
 
 	/*
 	 * Tell the DMA engine about the SG table and
 	 * data direction.
 	 */
-	set_dma_sg(hwif->hw.dma, hwif->sg_table, hwif->sg_nents);
-	set_dma_mode(hwif->hw.dma, dma_mode);
+	set_dma_sg(state->dev->dma, hwif->sg_table, hwif->sg_nents);
+	set_dma_mode(state->dev->dma, dma_mode);
 
 	drive->waiting_for_dma = 1;
 
@@ -438,40 +440,16 @@ static void icside_dma_init(ide_hwif_t *hwif)
 #define icside_dma_init(hwif)	(0)
 #endif
 
-static ide_hwif_t *icside_find_hwif(unsigned long dataport)
-{
-	ide_hwif_t *hwif;
-	int index;
-
-	for (index = 0; index < MAX_HWIFS; ++index) {
-		hwif = &ide_hwifs[index];
-		if (hwif->io_ports[IDE_DATA_OFFSET] == dataport)
-			goto found;
-	}
-
-	for (index = 0; index < MAX_HWIFS; ++index) {
-		hwif = &ide_hwifs[index];
-		if (!hwif->io_ports[IDE_DATA_OFFSET])
-			goto found;
-	}
-
-	hwif = NULL;
-found:
-	return hwif;
-}
-
 static ide_hwif_t *
 icside_setup(void __iomem *base, struct cardinfo *info, struct expansion_card *ec)
 {
 	unsigned long port = (unsigned long)base + info->dataoffset;
 	ide_hwif_t *hwif;
 
-	hwif = icside_find_hwif(port);
+	hwif = ide_find_port(port);
 	if (hwif) {
 		int i;
 
-		memset(&hwif->hw, 0, sizeof(hw_regs_t));
-
 		/*
 		 * Ensure we're using MMIO
 		 */
@@ -479,13 +457,10 @@ icside_setup(void __iomem *base, struct cardinfo *info, struct expansion_card *e
 		hwif->mmio = 1;
 
 		for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-			hwif->hw.io_ports[i] = port;
 			hwif->io_ports[i] = port;
 			port += 1 << info->stepping;
 		}
-		hwif->hw.io_ports[IDE_CONTROL_OFFSET] = (unsigned long)base + info->ctrloffset;
 		hwif->io_ports[IDE_CONTROL_OFFSET] = (unsigned long)base + info->ctrloffset;
-		hwif->hw.irq  = ec->irq;
 		hwif->irq     = ec->irq;
 		hwif->noprobe = 0;
 		hwif->chipset = ide_acorn;
@@ -500,6 +475,7 @@ icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 {
 	ide_hwif_t *hwif;
 	void __iomem *base;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	base = ecardm_iomap(ec, ECARD_RES_MEMC, 0, 0);
 	if (!base)
@@ -523,9 +499,9 @@ icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 
 	state->hwif[0] = hwif;
 
-	probe_hwif_init(hwif);
+	idx[0] = hwif->index;
 
-	ide_proc_register_port(hwif);
+	ide_device_add(idx);
 
 	return 0;
 }
@@ -537,6 +513,7 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 	void __iomem *ioc_base, *easi_base;
 	unsigned int sel = 0;
 	int ret;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	ioc_base = ecardm_iomap(ec, ECARD_RES_IOCFAST, 0, 0);
 	if (!ioc_base) {
@@ -592,7 +569,6 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 	hwif->serialized  = 1;
 	hwif->config_data = (unsigned long)ioc_base;
 	hwif->select_data = sel;
-	hwif->hw.dma      = ec->dma;
 
 	mate->maskproc    = icside_maskproc;
 	mate->channel     = 1;
@@ -601,18 +577,16 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 	mate->serialized  = 1;
 	mate->config_data = (unsigned long)ioc_base;
 	mate->select_data = sel | 1;
-	mate->hw.dma      = ec->dma;
 
 	if (ec->dma != NO_DMA && !request_dma(ec->dma, hwif->name)) {
 		icside_dma_init(hwif);
 		icside_dma_init(mate);
 	}
 
-	probe_hwif_init(hwif);
-	probe_hwif_init(mate);
+	idx[0] = hwif->index;
+	idx[1] = mate->index;
 
-	ide_proc_register_port(hwif);
-	ide_proc_register_port(mate);
+	ide_device_add(idx);
 
 	return 0;
 
diff --git a/drivers/ide/arm/ide_arm.c b/drivers/ide/arm/ide_arm.c
index bce2bec..8957cba 100644
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -31,5 +31,5 @@ void __init ide_arm_init(void)
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, IDE_ARM_IO, IDE_ARM_IO + 0x206);
 	hw.irq = IDE_ARM_IRQ;
-	ide_register_hw(&hw, 1, NULL);
+	ide_register_hw(&hw, NULL, 1, NULL);
 }
diff --git a/drivers/ide/arm/rapide.c b/drivers/ide/arm/rapide.c
index 83811af..0775a3a 100644
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -13,42 +13,25 @@
 
 #include <asm/ecard.h>
 
-/*
- * Something like this really should be in generic code, but isn't.
- */
 static ide_hwif_t *
 rapide_locate_hwif(void __iomem *base, void __iomem *ctrl, unsigned int sz, int irq)
 {
 	unsigned long port = (unsigned long)base;
-	ide_hwif_t *hwif;
-	int index, i;
-
-	for (index = 0; index < MAX_HWIFS; ++index) {
-		hwif = ide_hwifs + index;
-		if (hwif->io_ports[IDE_DATA_OFFSET] == port)
-			goto found;
-	}
-
-	for (index = 0; index < MAX_HWIFS; ++index) {
-		hwif = ide_hwifs + index;
-		if (hwif->io_ports[IDE_DATA_OFFSET] == 0)
-			goto found;
-	}
+	ide_hwif_t *hwif = ide_find_port(port);
+	int i;
 
-	return NULL;
+	if (hwif == NULL)
+		goto out;
 
- found:
 	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-		hwif->hw.io_ports[i] = port;
 		hwif->io_ports[i] = port;
 		port += sz;
 	}
-	hwif->hw.io_ports[IDE_CONTROL_OFFSET] = (unsigned long)ctrl;
 	hwif->io_ports[IDE_CONTROL_OFFSET] = (unsigned long)ctrl;
-	hwif->hw.irq = hwif->irq = irq;
+	hwif->irq = irq;
 	hwif->mmio = 1;
 	default_hwif_mmiops(hwif);
-
+out:
 	return hwif;
 }
 
@@ -58,6 +41,7 @@ rapide_probe(struct expansion_card *ec, const struct ecard_id *id)
 	ide_hwif_t *hwif;
 	void __iomem *base;
 	int ret;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	ret = ecard_request_resources(ec);
 	if (ret)
@@ -74,8 +58,11 @@ rapide_probe(struct expansion_card *ec, const struct ecard_id *id)
 		hwif->hwif_data = base;
 		hwif->gendev.parent = &ec->dev;
 		hwif->noprobe = 0;
-		probe_hwif_init(hwif);
-		ide_proc_register_port(hwif);
+
+		idx[0] = hwif->index;
+
+		ide_device_add(idx);
+
 		ecard_set_drvdata(ec, hwif);
 		goto out;
 	}
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 9a96a10..ff20377 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -782,7 +782,7 @@ init_e100_ide (void)
 		                ide_offsets,
 		                0, 0, cris_ide_ack_intr,
 		                ide_default_irq(0));
-		ide_register_hw(&hw, 1, &hwif);
+		ide_register_hw(&hw, NULL, 1, &hwif);
 		hwif->mmio = 1;
 		hwif->chipset = ide_etrax100;
 		hwif->set_pio_mode = &cris_set_pio_mode;
diff --git a/drivers/ide/h8300/ide-h8300.c b/drivers/ide/h8300/ide-h8300.c
index 6d26ad7..4a49b5c 100644
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -68,7 +68,6 @@ static inline void hw_setup(hw_regs_t *hw)
 		hw->io_ports[i] = CONFIG_H8300_IDE_BASE + H8300_IDE_GAP*i;
 	hw->io_ports[IDE_CONTROL_OFFSET] = CONFIG_H8300_IDE_ALT;
 	hw->irq = EXT_IRQ0 + CONFIG_H8300_IDE_IRQ;
-	hw->dma = NO_DMA;
 	hw->chipset = ide_generic;
 }
 
@@ -101,7 +100,7 @@ void __init h8300_ide_init(void)
 	hw_setup(&hw);
 
 	/* register if */
-	idx = ide_register_hw(&hw, 1, &hwif);
+	idx = ide_register_hw(&hw, NULL, 1, &hwif);
 	if (idx == -1) {
 		printk(KERN_ERR "ide-h8300: IDE I/F register failed\n");
 		return;
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 1d5f682..89df48f 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -350,7 +350,7 @@ static int taskfile_load_raw(ide_drive_t *drive,
 
 	memset(&args, 0, sizeof(ide_task_t));
 	args.command_type = IDE_DRIVE_TASK_NO_DATA;
-	args.data_phase   = TASKFILE_IN;
+	args.data_phase   = TASKFILE_NO_DATA;
 	args.handler      = &task_no_data_intr;
 
 	/* convert gtf to IDE Taskfile */
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 2722d91..00123d9 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -593,28 +593,12 @@ static int smart_enable(ide_drive_t *drive)
 	return ide_raw_taskfile(drive, &args, NULL);
 }
 
-static int get_smart_values(ide_drive_t *drive, u8 *buf)
+static int get_smart_data(ide_drive_t *drive, u8 *buf, u8 sub_cmd)
 {
 	ide_task_t args;
 
 	memset(&args, 0, sizeof(ide_task_t));
-	args.tfRegister[IDE_FEATURE_OFFSET]	= SMART_READ_VALUES;
-	args.tfRegister[IDE_NSECTOR_OFFSET]	= 0x01;
-	args.tfRegister[IDE_LCYL_OFFSET]	= SMART_LCYL_PASS;
-	args.tfRegister[IDE_HCYL_OFFSET]	= SMART_HCYL_PASS;
-	args.tfRegister[IDE_COMMAND_OFFSET]	= WIN_SMART;
-	args.command_type			= IDE_DRIVE_TASK_IN;
-	args.data_phase				= TASKFILE_IN;
-	args.handler				= &task_in_intr;
-	(void) smart_enable(drive);
-	return ide_raw_taskfile(drive, &args, buf);
-}
-
-static int get_smart_thresholds(ide_drive_t *drive, u8 *buf)
-{
-	ide_task_t args;
-	memset(&args, 0, sizeof(ide_task_t));
-	args.tfRegister[IDE_FEATURE_OFFSET]	= SMART_READ_THRESHOLDS;
+	args.tfRegister[IDE_FEATURE_OFFSET]	= sub_cmd;
 	args.tfRegister[IDE_NSECTOR_OFFSET]	= 0x01;
 	args.tfRegister[IDE_LCYL_OFFSET]	= SMART_LCYL_PASS;
 	args.tfRegister[IDE_HCYL_OFFSET]	= SMART_HCYL_PASS;
@@ -656,7 +640,7 @@ static int proc_idedisk_read_smart_thresholds
 	ide_drive_t	*drive = (ide_drive_t *)data;
 	int		len = 0, i = 0;
 
-	if (!get_smart_thresholds(drive, page)) {
+	if (get_smart_data(drive, page, SMART_READ_THRESHOLDS) == 0) {
 		unsigned short *val = (unsigned short *) page;
 		char *out = ((char *)val) + (SECTOR_WORDS * 4);
 		page = out;
@@ -675,7 +659,7 @@ static int proc_idedisk_read_smart_values
 	ide_drive_t	*drive = (ide_drive_t *)data;
 	int		len = 0, i = 0;
 
-	if (!get_smart_values(drive, page)) {
+	if (get_smart_data(drive, page, SMART_READ_VALUES) == 0) {
 		unsigned short *val = (unsigned short *) page;
 		char *out = ((char *)val) + (SECTOR_WORDS * 4);
 		page = out;
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 80b4f17..428f7a8 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -901,10 +901,7 @@ void ide_dma_timeout (ide_drive_t *drive)
 
 EXPORT_SYMBOL(ide_dma_timeout);
 
-/*
- * Needed for allowing full modular support of ide-driver
- */
-static int ide_release_dma_engine(ide_hwif_t *hwif)
+static void ide_release_dma_engine(ide_hwif_t *hwif)
 {
 	if (hwif->dmatable_cpu) {
 		pci_free_consistent(hwif->pci_dev,
@@ -913,7 +910,6 @@ static int ide_release_dma_engine(ide_hwif_t *hwif)
 				    hwif->dmatable_dma);
 		hwif->dmatable_cpu = NULL;
 	}
-	return 1;
 }
 
 static int ide_release_iomio_dma(ide_hwif_t *hwif)
@@ -956,12 +952,6 @@ static int ide_mapped_mmio_dma(ide_hwif_t *hwif, unsigned long base, unsigned in
 {
 	printk(KERN_INFO "    %s: MMIO-DMA ", hwif->name);
 
- 	hwif->dma_base = base;
-
-	if(hwif->mate)
-		hwif->dma_master = (hwif->channel) ? hwif->mate->dma_base : base;
-	else
-		hwif->dma_master = base;
 	return 0;
 }
 
@@ -975,8 +965,6 @@ static int ide_iomio_dma(ide_hwif_t *hwif, unsigned long base, unsigned int port
 		return 1;
 	}
 
-	hwif->dma_base = base;
-
 	if (hwif->cds->extra) {
 		hwif->extra_base = base + (hwif->channel ? 8 : 16);
 
@@ -991,10 +979,6 @@ static int ide_iomio_dma(ide_hwif_t *hwif, unsigned long base, unsigned int port
 		}
 	}
 
-	if(hwif->mate)
-		hwif->dma_master = (hwif->channel) ? hwif->mate->dma_base:base;
-	else
-		hwif->dma_master = base;
 	return 0;
 }
 
@@ -1006,12 +990,9 @@ static int ide_dma_iobase(ide_hwif_t *hwif, unsigned long base, unsigned int por
 	return ide_iomio_dma(hwif, base, ports);
 }
 
-/*
- * This can be called for a dynamically installed interface. Don't __init it
- */
-void ide_setup_dma (ide_hwif_t *hwif, unsigned long dma_base, unsigned int num_ports)
+void ide_setup_dma(ide_hwif_t *hwif, unsigned long base, unsigned num_ports)
 {
-	if (ide_dma_iobase(hwif, dma_base, num_ports))
+	if (ide_dma_iobase(hwif, base, num_ports))
 		return;
 
 	if (ide_allocate_dma_engine(hwif)) {
@@ -1019,6 +1000,13 @@ void ide_setup_dma (ide_hwif_t *hwif, unsigned long dma_base, unsigned int num_p
 		return;
 	}
 
+	hwif->dma_base = base;
+
+	if (hwif->mate)
+		hwif->dma_master = hwif->channel ? hwif->mate->dma_base : base;
+	else
+		hwif->dma_master = base;
+
 	if (!(hwif->dma_command))
 		hwif->dma_command	= hwif->dma_base;
 	if (!(hwif->dma_vendor1))
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 32eaa3f..c89f0d3 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -55,7 +55,7 @@
 #include <asm/io.h>
 
 static int __ide_end_request(ide_drive_t *drive, struct request *rq,
-			     int uptodate, unsigned int nr_bytes)
+			     int uptodate, unsigned int nr_bytes, int dequeue)
 {
 	int ret = 1;
 
@@ -80,9 +80,11 @@ static int __ide_end_request(ide_drive_t *drive, struct request *rq,
 
 	if (!end_that_request_chunk(rq, uptodate, nr_bytes)) {
 		add_disk_randomness(rq->rq_disk);
-		if (!list_empty(&rq->queuelist))
-			blkdev_dequeue_request(rq);
-		HWGROUP(drive)->rq = NULL;
+		if (dequeue) {
+			if (!list_empty(&rq->queuelist))
+				blkdev_dequeue_request(rq);
+			HWGROUP(drive)->rq = NULL;
+		}
 		end_that_request_last(rq, uptodate);
 		ret = 0;
 	}
@@ -122,7 +124,7 @@ int ide_end_request (ide_drive_t *drive, int uptodate, int nr_sectors)
 			nr_bytes = rq->hard_cur_sectors << 9;
 	}
 
-	ret = __ide_end_request(drive, rq, uptodate, nr_bytes);
+	ret = __ide_end_request(drive, rq, uptodate, nr_bytes, 1);
 
 	spin_unlock_irqrestore(&ide_lock, flags);
 	return ret;
@@ -255,39 +257,13 @@ int ide_end_dequeued_request(ide_drive_t *drive, struct request *rq,
 			     int uptodate, int nr_sectors)
 {
 	unsigned long flags;
-	int ret = 1;
+	int ret;
 
 	spin_lock_irqsave(&ide_lock, flags);
-
 	BUG_ON(!blk_rq_started(rq));
-
-	/*
-	 * if failfast is set on a request, override number of sectors and
-	 * complete the whole request right now
-	 */
-	if (blk_noretry_request(rq) && end_io_error(uptodate))
-		nr_sectors = rq->hard_nr_sectors;
-
-	if (!blk_fs_request(rq) && end_io_error(uptodate) && !rq->errors)
-		rq->errors = -EIO;
-
-	/*
-	 * decide whether to reenable DMA -- 3 is a random magic for now,
-	 * if we DMA timeout more than 3 times, just stay in PIO
-	 */
-	if (drive->state == DMA_PIO_RETRY && drive->retry_pio <= 3) {
-		drive->state = 0;
-		HWGROUP(drive)->hwif->ide_dma_on(drive);
-	}
-
-	if (!end_that_request_first(rq, uptodate, nr_sectors)) {
-		add_disk_randomness(rq->rq_disk);
-		if (blk_rq_tagged(rq))
-			blk_queue_end_tag(drive->queue, rq);
-		end_that_request_last(rq, uptodate);
-		ret = 0;
-	}
+	ret = __ide_end_request(drive, rq, uptodate, nr_sectors << 9, 0);
 	spin_unlock_irqrestore(&ide_lock, flags);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ide_end_dequeued_request);
@@ -800,7 +776,20 @@ static ide_startstop_t do_special (ide_drive_t *drive)
 		s->b.set_tune = 0;
 
 		if (set_pio_mode_abuse(drive->hwif, req_pio)) {
-			if (hwif->set_pio_mode)
+
+			if (hwif->set_pio_mode == NULL)
+				return ide_stopped;
+
+			/*
+			 * take ide_lock for drive->[no_]unmask/[no_]io_32bit
+			 */
+			if (req_pio == 8 || req_pio == 9) {
+				unsigned long flags;
+
+				spin_lock_irqsave(&ide_lock, flags);
+				hwif->set_pio_mode(drive, req_pio);
+				spin_unlock_irqrestore(&ide_lock, flags);
+			} else
 				hwif->set_pio_mode(drive, req_pio);
 		} else {
 			int keep_dma = drive->using_dma;
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index d4d790f..9516883 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -693,35 +693,16 @@ static u8 ide_auto_reduce_xfer (ide_drive_t *drive)
 }
 #endif /* CONFIG_BLK_DEV_IDEDMA */
 
-/*
- * Update the 
- */
-int ide_driveid_update (ide_drive_t *drive)
+int ide_driveid_update(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct hd_driveid *id;
-#if 0
-	id = kmalloc(SECTOR_WORDS*4, GFP_ATOMIC);
-	if (!id)
-		return 0;
-
-	taskfile_lib_get_identify(drive, (char *)&id);
+	unsigned long timeout, flags;
 
-	ide_fix_driveid(id);
-	if (id) {
-		drive->id->dma_ultra = id->dma_ultra;
-		drive->id->dma_mword = id->dma_mword;
-		drive->id->dma_1word = id->dma_1word;
-		/* anything more ? */
-		kfree(id);
-	}
-	return 1;
-#else
 	/*
 	 * Re-read drive->id for possible DMA mode
 	 * change (copied from ide-probe.c)
 	 */
-	unsigned long timeout, flags;
 
 	SELECT_MASK(drive, 1);
 	if (IDE_CONTROL_REG)
@@ -763,7 +744,6 @@ int ide_driveid_update (ide_drive_t *drive)
 	}
 
 	return 1;
-#endif
 }
 
 int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index 2b8009c..e245521 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -40,9 +40,8 @@ static int idepnp_probe(struct pnp_dev * dev, const struct pnp_device_id *dev_id
 	ide_std_init_ports(&hw, pnp_port_start(dev, 0),
 				pnp_port_start(dev, 1));
 	hw.irq = pnp_irq(dev, 0);
-	hw.dma = NO_DMA;
 
-	index = ide_register_hw(&hw, 1, &hwif);
+	index = ide_register_hw(&hw, NULL, 1, &hwif);
 
 	if (index != -1) {
 	    	printk(KERN_INFO "ide%d: generic PnP IDE interface\n", index);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index e294c74..d5146c5 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -717,7 +717,7 @@ EXPORT_SYMBOL_GPL(ide_undecoded_slave);
  * This routine only knows how to look for drive units 0 and 1
  * on an interface, so any setting of MAX_DRIVES > 2 won't work here.
  */
-static void probe_hwif(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif))
+static void probe_hwif(ide_hwif_t *hwif)
 {
 	unsigned long flags;
 	unsigned int irqd;
@@ -819,8 +819,8 @@ static void probe_hwif(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif))
 		return;
 	}
 
-	if (fixup)
-		fixup(hwif);
+	if (hwif->fixup)
+		hwif->fixup(hwif);
 
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
@@ -859,10 +859,11 @@ static void probe_hwif(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif))
 }
 
 static int hwif_init(ide_hwif_t *hwif);
+static void hwif_register_devices(ide_hwif_t *hwif);
 
-int probe_hwif_init_with_fixup(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif))
+static int probe_hwif_init(ide_hwif_t *hwif)
 {
-	probe_hwif(hwif, fixup);
+	probe_hwif(hwif);
 
 	if (!hwif_init(hwif)) {
 		printk(KERN_INFO "%s: failed to initialize IDE interface\n",
@@ -870,34 +871,12 @@ int probe_hwif_init_with_fixup(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif)
 		return -1;
 	}
 
-	if (hwif->present) {
-		u16 unit = 0;
-		int ret;
+	if (hwif->present)
+		hwif_register_devices(hwif);
 
-		for (unit = 0; unit < MAX_DRIVES; ++unit) {
-			ide_drive_t *drive = &hwif->drives[unit];
-			/* For now don't attach absent drives, we may
-			   want them on default or a new "empty" class
-			   for hotplug reprobing ? */
-			if (drive->present) {
-				ret = device_register(&drive->gendev);
-				if (ret < 0)
-					printk(KERN_WARNING "IDE: %s: "
-						"device_register error: %d\n",
-						__FUNCTION__, ret);
-			}
-		}
-	}
 	return 0;
 }
 
-int probe_hwif_init(ide_hwif_t *hwif)
-{
-	return probe_hwif_init_with_fixup(hwif, NULL);
-}
-
-EXPORT_SYMBOL(probe_hwif_init);
-
 #if MAX_HWIFS > 1
 /*
  * save_match() is used to simplify logic in init_irq() below.
@@ -1379,6 +1358,24 @@ out:
 	return 0;
 }
 
+static void hwif_register_devices(ide_hwif_t *hwif)
+{
+	unsigned int i;
+
+	for (i = 0; i < MAX_DRIVES; i++) {
+		ide_drive_t *drive = &hwif->drives[i];
+
+		if (drive->present) {
+			int ret = device_register(&drive->gendev);
+
+			if (ret < 0)
+				printk(KERN_WARNING "IDE: %s: "
+					"device_register error: %d\n",
+					__FUNCTION__, ret);
+		}
+	}
+}
+
 int ideprobe_init (void)
 {
 	unsigned int index;
@@ -1390,27 +1387,18 @@ int ideprobe_init (void)
 
 	for (index = 0; index < MAX_HWIFS; ++index)
 		if (probe[index])
-			probe_hwif(&ide_hwifs[index], NULL);
+			probe_hwif(&ide_hwifs[index]);
 	for (index = 0; index < MAX_HWIFS; ++index)
 		if (probe[index])
 			hwif_init(&ide_hwifs[index]);
 	for (index = 0; index < MAX_HWIFS; ++index) {
 		if (probe[index]) {
 			ide_hwif_t *hwif = &ide_hwifs[index];
-			int unit;
 			if (!hwif->present)
 				continue;
 			if (hwif->chipset == ide_unknown || hwif->chipset == ide_forced)
 				hwif->chipset = ide_generic;
-			for (unit = 0; unit < MAX_DRIVES; ++unit)
-				if (hwif->drives[unit].present) {
-					int ret = device_register(
-						&hwif->drives[unit].gendev);
-					if (ret < 0)
-						printk(KERN_WARNING "IDE: %s: "
-							"device_register error: %d\n",
-							__FUNCTION__, ret);
-				}
+			hwif_register_devices(hwif);
 		}
 	}
 	for (index = 0; index < MAX_HWIFS; ++index)
@@ -1420,3 +1408,22 @@ int ideprobe_init (void)
 }
 
 EXPORT_SYMBOL_GPL(ideprobe_init);
+
+int ide_device_add(u8 idx[4])
+{
+	int i, rc = 0;
+
+	for (i = 0; i < 4; i++) {
+		if (idx[i] != 0xff)
+			rc |= probe_hwif_init(&ide_hwifs[idx[i]]);
+	}
+
+	for (i = 0; i < 4; i++) {
+		if (idx[i] != 0xff)
+			ide_proc_register_port(&ide_hwifs[idx[i]]);
+	}
+
+	return rc;
+}
+
+EXPORT_SYMBOL_GPL(ide_device_add);
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index fc1d8ae..a4007d3 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -804,8 +804,6 @@ void ide_proc_register_port(ide_hwif_t *hwif)
 	create_proc_ide_drives(hwif);
 }
 
-EXPORT_SYMBOL_GPL(ide_proc_register_port);
-
 #ifdef CONFIG_BLK_DEV_IDEPCI
 void ide_pci_create_host_proc(const char *name, get_info_t *get_info)
 {
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1fa5794..e5a86a9 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -621,7 +621,6 @@ typedef struct os_dat_s {
  */
 #define USE_IOTRACE	0
 #if USE_IOTRACE
-#include <linux/io_trace.h>
 #define IO_IDETAPE_FIFO	500
 #endif
 
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 2a3c8d4..73ef6bf 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -8,23 +8,6 @@
  *  Copyright (C) 2003-2004	Bartlomiej Zolnierkiewicz
  *
  *  The big the bad and the ugly.
- *
- *  Problems to be fixed because of BH interface or the lack therefore.
- *
- *  Fill me in stupid !!!
- *
- *  HOST:
- *	General refers to the Controller and Driver "pair".
- *  DATA HANDLER:
- *	Under the context of Linux it generally refers to an interrupt handler.
- *	However, it correctly describes the 'HOST'
- *  DATA BLOCK:
- *	The amount of data needed to be transfered as predefined in the
- *	setup of the device.
- *  STORAGE ATOMIC:
- *	The 'DATA BLOCK' associated to the 'DATA HANDLER', and can be as
- *	small as a single sector or as large as the entire command block
- *	request.
  */
 
 #include <linux/module.h>
@@ -695,9 +678,6 @@ int ide_wait_cmd (ide_drive_t *drive, u8 cmd, u8 nsect, u8 feature, u8 sectors,
 	return ide_do_drive_cmd(drive, &rq, ide_wait);
 }
 
-/*
- * FIXME : this needs to map into at taskfile. <andre@linux-ide.org>
- */
 int ide_cmd_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 {
 	int err = 0;
@@ -761,9 +741,6 @@ static int ide_wait_cmd_task(ide_drive_t *drive, u8 *buf)
 	return ide_do_drive_cmd(drive, &rq, ide_wait);
 }
 
-/*
- * FIXME : this needs to map into at taskfile. <andre@linux-ide.org>
- */
 int ide_task_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 {
 	void __user *p = (void __user *)arg;
@@ -860,9 +837,14 @@ ide_startstop_t flagged_taskfile (ide_drive_t *drive, ide_task_t *task)
 		case TASKFILE_OUT_DMA:
 		case TASKFILE_IN_DMAQ:
 		case TASKFILE_IN_DMA:
-			hwif->dma_setup(drive);
-			hwif->dma_exec_cmd(drive, taskfile->command);
-			hwif->dma_start(drive);
+			if (!drive->using_dma)
+				break;
+
+			if (!hwif->dma_setup(drive)) {
+				hwif->dma_exec_cmd(drive, taskfile->command);
+				hwif->dma_start(drive);
+				return ide_started;
+			}
 			break;
 
 	        default:
@@ -876,7 +858,8 @@ ide_startstop_t flagged_taskfile (ide_drive_t *drive, ide_task_t *task)
 				return task->prehandler(drive, task->rq);
 			}
 			ide_execute_command(drive, taskfile->command, task->handler, WAIT_WORSTCASE, NULL);
+			return ide_started;
 	}
 
-	return ide_started;
+	return ide_stopped;
 }
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 961e6c8..674a65c 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -168,7 +168,6 @@ static void init_hwif_default(ide_hwif_t *hwif, unsigned int index)
 
 	ide_init_hwif_ports(&hw, ide_default_io_base(index), 0, &hwif->irq);
 
-	memcpy(&hwif->hw, &hw, sizeof(hw));
 	memcpy(hwif->io_ports, hw.io_ports, sizeof(hw.io_ports));
 
 	hwif->noprobe = !hwif->io_ports[IDE_DATA_OFFSET];
@@ -214,7 +213,7 @@ static void __init init_ide_data (void)
 		init_hwif_data(hwif, index);
 		init_hwif_default(hwif, index);
 #if !defined(CONFIG_PPC32) || !defined(CONFIG_PCI)
-		hwif->irq = hwif->hw.irq =
+		hwif->irq =
 			ide_init_default_irq(hwif->io_ports[IDE_DATA_OFFSET]);
 #endif
 	}
@@ -265,6 +264,30 @@ static int ide_system_bus_speed(void)
 	return system_bus_speed;
 }
 
+ide_hwif_t * ide_find_port(unsigned long base)
+{
+	ide_hwif_t *hwif;
+	int i;
+
+	for (i = 0; i < MAX_HWIFS; i++) {
+		hwif = &ide_hwifs[i];
+		if (hwif->io_ports[IDE_DATA_OFFSET] == base)
+			goto found;
+	}
+
+	for (i = 0; i < MAX_HWIFS; i++) {
+		hwif = &ide_hwifs[i];
+		if (hwif->io_ports[IDE_DATA_OFFSET] == 0)
+			goto found;
+	}
+
+	hwif = NULL;
+found:
+	return hwif;
+}
+
+EXPORT_SYMBOL_GPL(ide_find_port);
+
 static struct resource* hwif_request_region(ide_hwif_t *hwif,
 					    unsigned long addr, int num)
 {
@@ -391,6 +414,8 @@ static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
 	hwif->cds			= tmp_hwif->cds;
 #endif
 
+	hwif->fixup			= tmp_hwif->fixup;
+
 	hwif->set_pio_mode		= tmp_hwif->set_pio_mode;
 	hwif->set_dma_mode		= tmp_hwif->set_dma_mode;
 	hwif->mdma_filter		= tmp_hwif->mdma_filter;
@@ -652,7 +677,6 @@ void ide_setup_ports (	hw_regs_t *hw,
 		}
 	}
 	hw->irq = irq;
-	hw->dma = NO_DMA;
 	hw->ack_intr = ack_intr;
 /*
  *	hw->iops = iops;
@@ -660,11 +684,11 @@ void ide_setup_ports (	hw_regs_t *hw,
 }
 
 /**
- *	ide_register_hw_with_fixup	-	register IDE interface
+ *	ide_register_hw		-	register IDE interface
  *	@hw: hardware registers
+ *	@fixup: fixup function
  *	@initializing: set while initializing built-in drivers
  *	@hwifp: pointer to returned hwif
- *	@fixup: fixup function
  *
  *	Register an IDE interface, specifying exactly the registers etc.
  *	Set init=1 iff calling before probes have taken place.
@@ -672,9 +696,8 @@ void ide_setup_ports (	hw_regs_t *hw,
  *	Returns -1 on error.
  */
 
-int ide_register_hw_with_fixup(hw_regs_t *hw, int initializing,
-			       ide_hwif_t **hwifp,
-			       void(*fixup)(ide_hwif_t *hwif))
+int ide_register_hw(hw_regs_t *hw, void (*fixup)(ide_hwif_t *),
+		    int initializing, ide_hwif_t **hwifp)
 {
 	int index, retry = 1;
 	ide_hwif_t *hwif;
@@ -682,7 +705,7 @@ int ide_register_hw_with_fixup(hw_regs_t *hw, int initializing,
 	do {
 		for (index = 0; index < MAX_HWIFS; ++index) {
 			hwif = &ide_hwifs[index];
-			if (hwif->hw.io_ports[IDE_DATA_OFFSET] == hw->io_ports[IDE_DATA_OFFSET])
+			if (hwif->io_ports[IDE_DATA_OFFSET] == hw->io_ports[IDE_DATA_OFFSET])
 				goto found;
 		}
 		for (index = 0; index < MAX_HWIFS; ++index) {
@@ -690,7 +713,7 @@ int ide_register_hw_with_fixup(hw_regs_t *hw, int initializing,
 			if (hwif->hold)
 				continue;
 			if ((!hwif->present && !hwif->mate && !initializing) ||
-			    (!hwif->hw.io_ports[IDE_DATA_OFFSET] && initializing))
+			    (!hwif->io_ports[IDE_DATA_OFFSET] && initializing))
 				goto found;
 		}
 		for (index = 0; index < MAX_HWIFS; index++)
@@ -706,16 +729,18 @@ found:
 	}
 	if (hwif->present)
 		return -1;
-	memcpy(&hwif->hw, hw, sizeof(*hw));
-	memcpy(hwif->io_ports, hwif->hw.io_ports, sizeof(hwif->hw.io_ports));
+	memcpy(hwif->io_ports, hw->io_ports, sizeof(hwif->io_ports));
 	hwif->irq = hw->irq;
 	hwif->noprobe = 0;
+	hwif->fixup = fixup;
 	hwif->chipset = hw->chipset;
 	hwif->gendev.parent = hw->dev;
+	hwif->ack_intr = hw->ack_intr;
+
+	if (initializing == 0) {
+		u8 idx[4] = { index, 0xff, 0xff, 0xff };
 
-	if (!initializing) {
-		probe_hwif_init_with_fixup(hwif, fixup);
-		ide_proc_register_port(hwif);
+		ide_device_add(idx);
 	}
 
 	if (hwifp)
@@ -724,13 +749,6 @@ found:
 	return (initializing || hwif->present) ? index : -1;
 }
 
-EXPORT_SYMBOL(ide_register_hw_with_fixup);
-
-int ide_register_hw(hw_regs_t *hw, int initializing, ide_hwif_t **hwifp)
-{
-	return ide_register_hw_with_fixup(hw, initializing, hwifp, NULL);
-}
-
 EXPORT_SYMBOL(ide_register_hw);
 
 /*
@@ -1046,7 +1064,7 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 			ide_init_hwif_ports(&hw, (unsigned long) args[0],
 					    (unsigned long) args[1], NULL);
 			hw.irq = args[2];
-			if (ide_register_hw(&hw, 0, NULL) == -1)
+			if (ide_register_hw(&hw, NULL, 0, NULL) == -1)
 				return -EIO;
 			return 0;
 		}
@@ -1397,6 +1415,9 @@ static int __init ide_setup(char *s)
 			"reset", "minus6", "ata66", "minus8", "minus9",
 			"minus10", "four", "qd65xx", "ht6560b", "cmd640_vlb",
 			"dtc2278", "umc8672", "ali14xx", NULL };
+
+		hw_regs_t hwregs;
+
 		hw = s[3] - '0';
 		hwif = &ide_hwifs[hw];
 		i = match_parm(&s[4], ide_words, vals, 3);
@@ -1506,9 +1527,9 @@ static int __init ide_setup(char *s)
 			case 2: /* base,ctl */
 				vals[2] = 0;	/* default irq = probe for it */
 			case 3: /* base,ctl,irq */
-				hwif->hw.irq = vals[2];
-				ide_init_hwif_ports(&hwif->hw, (unsigned long) vals[0], (unsigned long) vals[1], &hwif->irq);
-				memcpy(hwif->io_ports, hwif->hw.io_ports, sizeof(hwif->io_ports));
+				memset(&hwregs, 0, sizeof(hwregs));
+				ide_init_hwif_ports(&hwregs, vals[0], vals[1], &hwif->irq);
+				memcpy(hwif->io_ports, hwregs.io_ports, sizeof(hwif->io_ports));
 				hwif->irq      = vals[2];
 				hwif->noprobe  = 0;
 				hwif->chipset  = ide_forced;
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index 2f0ef9b..10311ec 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -102,6 +102,8 @@ static void outReg (u8 data, u8 reg)
 	outb_p(data, dataPort);
 }
 
+static DEFINE_SPINLOCK(ali14xx_lock);
+
 /*
  * Set PIO mode for the specified drive.
  * This function computes timing parameters
@@ -129,14 +131,14 @@ static void ali14xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 	/* stuff timing parameters into controller registers */
 	driveNum = (HWIF(drive)->index << 1) + drive->select.b.unit;
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&ali14xx_lock, flags);
 	outb_p(regOn, basePort);
 	outReg(param1, regTab[driveNum].reg1);
 	outReg(param2, regTab[driveNum].reg2);
 	outReg(param3, regTab[driveNum].reg3);
 	outReg(param4, regTab[driveNum].reg4);
 	outb_p(regOff, basePort);
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&ali14xx_lock, flags);
 }
 
 /*
@@ -193,6 +195,7 @@ static int __init initRegisters (void) {
 static int __init ali14xx_probe(void)
 {
 	ide_hwif_t *hwif, *mate;
+	static u8 idx[4] = { 0, 1, 0xff, 0xff };
 
 	printk(KERN_DEBUG "ali14xx: base=0x%03x, regOn=0x%02x.\n",
 			  basePort, regOn);
@@ -217,11 +220,7 @@ static int __init ali14xx_probe(void)
 	mate->mate = hwif;
 	mate->channel = 1;
 
-	probe_hwif_init(hwif);
-	probe_hwif_init(mate);
-
-	ide_proc_register_port(hwif);
-	ide_proc_register_port(mate);
+	ide_device_add(idx);
 
 	return 0;
 }
diff --git a/drivers/ide/legacy/buddha.c b/drivers/ide/legacy/buddha.c
index 101aee1..4a0be25 100644
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -212,8 +212,8 @@ fail_base2:
 //						xsurf_iops,
 						IRQ_AMIGA_PORTS);
 			}	
-			
-			index = ide_register_hw(&hw, 1, &hwif);
+
+			index = ide_register_hw(&hw, NULL, 1, &hwif);
 			if (index != -1) {
 				hwif->mmio = 1;
 				printk("ide%d: ", index);
diff --git a/drivers/ide/legacy/dtc2278.c b/drivers/ide/legacy/dtc2278.c
index f165212..24a845d 100644
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -67,20 +67,24 @@ static void sub22 (char b, char c)
 	}
 }
 
+static DEFINE_SPINLOCK(dtc2278_lock);
+
 static void dtc2278_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	unsigned long flags;
 
 	if (pio >= 3) {
-		spin_lock_irqsave(&ide_lock, flags);
+		spin_lock_irqsave(&dtc2278_lock, flags);
 		/*
 		 * This enables PIO mode4 (3?) on the first interface
 		 */
 		sub22(1,0xc3);
 		sub22(0,0xa0);
-		spin_unlock_irqrestore(&ide_lock, flags);
+		spin_unlock_irqrestore(&dtc2278_lock, flags);
 	} else {
 		/* we don't know how to set it back again.. */
+		/* Actually we do - there is a data sheet available for the
+		   Winbond but does anyone actually care */
 	}
 
 	/*
@@ -94,6 +98,7 @@ static int __init dtc2278_probe(void)
 {
 	unsigned long flags;
 	ide_hwif_t *hwif, *mate;
+	static u8 idx[4] = { 0, 1, 0xff, 0xff };
 
 	hwif = &ide_hwifs[0];
 	mate = &ide_hwifs[1];
@@ -129,16 +134,13 @@ static int __init dtc2278_probe(void)
 
 	mate->serialized = 1;
 	mate->chipset = ide_dtc2278;
+	mate->pio_mask = ATA_PIO4;
 	mate->drives[0].no_unmask = 1;
 	mate->drives[1].no_unmask = 1;
 	mate->mate = hwif;
 	mate->channel = 1;
 
-	probe_hwif_init(hwif);
-	probe_hwif_init(mate);
-
-	ide_proc_register_port(hwif);
-	ide_proc_register_port(mate);
+	ide_device_add(idx);
 
 	return 0;
 }
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index f0829b8..7d7936f 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -72,7 +72,7 @@ void __init falconide_init(void)
 			0, 0, NULL,
 //			falconide_iops,
 			IRQ_MFP_IDE);
-	index = ide_register_hw(&hw, 1, NULL);
+	index = ide_register_hw(&hw, NULL, 1, NULL);
 
 	if (index != -1)
 	    printk("ide%d: Falcon IDE interface\n", index);
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index 0830a02..53331ee 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -165,7 +165,7 @@ found:
 //			&gayle_iops,
 			IRQ_AMIGA_PORTS);
 
-	index = ide_register_hw(&hw, 1, &hwif);
+	index = ide_register_hw(&hw, NULL, 1, &hwif);
 	if (index != -1) {
 	    hwif->mmio = 1;
 	    switch (i) {
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index 2e5a9cc..a4245d1 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -247,6 +247,8 @@ static u8 ht_pio2timings(ide_drive_t *drive, const u8 pio)
 	}
 }
 
+static DEFINE_SPINLOCK(ht6560b_lock);
+
 /*
  *  Enable/Disable so called prefetch mode
  */
@@ -254,9 +256,9 @@ static void ht_set_prefetch(ide_drive_t *drive, u8 state)
 {
 	unsigned long flags;
 	int t = HT_PREFETCH_MODE << 8;
-	
-	spin_lock_irqsave(&ide_lock, flags);
-	
+
+	spin_lock_irqsave(&ht6560b_lock, flags);
+
 	/*
 	 *  Prefetch mode and unmask irq seems to conflict
 	 */
@@ -268,9 +270,9 @@ static void ht_set_prefetch(ide_drive_t *drive, u8 state)
 		drive->drive_data &= ~t;  /* disable prefetch mode */
 		drive->no_unmask = 0;
 	}
-	
-	spin_unlock_irqrestore(&ide_lock, flags);
-	
+
+	spin_unlock_irqrestore(&ht6560b_lock, flags);
+
 #ifdef DEBUG
 	printk("ht6560b: drive %s prefetch mode %sabled\n", drive->name, (state ? "en" : "dis"));
 #endif
@@ -287,16 +289,14 @@ static void ht6560b_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		ht_set_prefetch(drive, pio & 1);
 		return;
 	}
-	
+
 	timing = ht_pio2timings(drive, pio);
-	
-	spin_lock_irqsave(&ide_lock, flags);
-	
+
+	spin_lock_irqsave(&ht6560b_lock, flags);
 	drive->drive_data &= 0xff00;
 	drive->drive_data |= timing;
-	
-	spin_unlock_irqrestore(&ide_lock, flags);
-	
+	spin_unlock_irqrestore(&ht6560b_lock, flags);
+
 #ifdef DEBUG
 	printk("ht6560b: drive %s tuned to pio mode %#x timing=%#x\n", drive->name, pio, timing);
 #endif
@@ -311,6 +311,7 @@ MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
 int __init ht6560b_init(void)
 {
 	ide_hwif_t *hwif, *mate;
+	static u8 idx[4] = { 0, 1, 0xff, 0xff };
 	int t;
 
 	if (probe_ht6560b == 0)
@@ -359,11 +360,7 @@ int __init ht6560b_init(void)
 	mate->drives[0].drive_data = t;
 	mate->drives[1].drive_data = t;
 
-	probe_hwif_init(hwif);
-	probe_hwif_init(mate);
-
-	ide_proc_register_port(hwif);
-	ide_proc_register_port(mate);
+	ide_device_add(idx);
 
 	return 0;
 
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index e8e360c..03715c0 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -153,7 +153,7 @@ static int idecs_register(unsigned long io, unsigned long ctl, unsigned long irq
     hw.irq = irq;
     hw.chipset = ide_pci;
     hw.dev = &handle->dev;
-    return ide_register_hw_with_fixup(&hw, 0, NULL, ide_undecoded_slave);
+    return ide_register_hw(&hw, &ide_undecoded_slave, 0, NULL);
 }
 
 /*======================================================================
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
index b992b2b..7bb79f5 100644
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -33,39 +33,24 @@ static ide_hwif_t *__devinit plat_ide_locate_hwif(void __iomem *base,
 	    int mmio)
 {
 	unsigned long port = (unsigned long)base;
-	ide_hwif_t *hwif;
-	int index, i;
-
-	for (index = 0; index < MAX_HWIFS; ++index) {
-		hwif = ide_hwifs + index;
-		if (hwif->io_ports[IDE_DATA_OFFSET] == port)
-			goto found;
-	}
-
-	for (index = 0; index < MAX_HWIFS; ++index) {
-		hwif = ide_hwifs + index;
-		if (hwif->io_ports[IDE_DATA_OFFSET] == 0)
-			goto found;
-	}
+	ide_hwif_t *hwif = ide_find_port(port);
+	int i;
 
-	return NULL;
-
-found:
+	if (hwif == NULL)
+		goto out;
 
-	hwif->hw.io_ports[IDE_DATA_OFFSET] = port;
+	hwif->io_ports[IDE_DATA_OFFSET] = port;
 
 	port += (1 << pdata->ioport_shift);
 	for (i = IDE_ERROR_OFFSET; i <= IDE_STATUS_OFFSET;
 	     i++, port += (1 << pdata->ioport_shift))
-		hwif->hw.io_ports[i] = port;
+		hwif->io_ports[i] = port;
 
-	hwif->hw.io_ports[IDE_CONTROL_OFFSET] = (unsigned long)ctrl;
+	hwif->io_ports[IDE_CONTROL_OFFSET] = (unsigned long)ctrl;
 
-	memcpy(hwif->io_ports, hwif->hw.io_ports, sizeof(hwif->hw.io_ports));
-	hwif->hw.irq = hwif->irq = irq;
+	hwif->irq = irq;
 
-	hwif->hw.dma = NO_DMA;
-	hwif->chipset = hwif->hw.chipset = ide_generic;
+	hwif->chipset = ide_generic;
 
 	if (mmio) {
 		hwif->mmio = 1;
@@ -73,8 +58,8 @@ found:
 	}
 
 	hwif_prop.hwif = hwif;
-	hwif_prop.index = index;
-
+	hwif_prop.index = hwif->index;
+out:
 	return hwif;
 }
 
@@ -83,6 +68,7 @@ static int __devinit plat_ide_probe(struct platform_device *pdev)
 	struct resource *res_base, *res_alt, *res_irq;
 	ide_hwif_t *hwif;
 	struct pata_platform_info *pdata;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	int ret = 0;
 	int mmio = 0;
 
@@ -130,10 +116,11 @@ static int __devinit plat_ide_probe(struct platform_device *pdev)
 	hwif->gendev.parent = &pdev->dev;
 	hwif->noprobe = 0;
 
-	probe_hwif_init(hwif);
+	idx[0] = hwif->index;
+
+	ide_device_add(idx);
 
 	platform_set_drvdata(pdev, hwif);
-	ide_proc_register_port(hwif);
 
 	return 0;
 
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index b557c45..e87cd2f 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -93,21 +93,21 @@ void macide_init(void)
 				0, 0, macide_ack_intr,
 //				quadra_ide_iops,
 				IRQ_NUBUS_F);
-		index = ide_register_hw(&hw, 1, &hwif);
+		index = ide_register_hw(&hw, NULL, 1, &hwif);
 		break;
 	case MAC_IDE_PB:
 		ide_setup_ports(&hw, IDE_BASE, macide_offsets,
 				0, 0, macide_ack_intr,
 //				macide_pb_iops,
 				IRQ_NUBUS_C);
-		index = ide_register_hw(&hw, 1, &hwif);
+		index = ide_register_hw(&hw, NULL, 1, &hwif);
 		break;
 	case MAC_IDE_BABOON:
 		ide_setup_ports(&hw, BABOON_BASE, macide_offsets,
 				0, 0, NULL,
 //				macide_baboon_iops,
 				IRQ_BABOON_1);
-		index = ide_register_hw(&hw, 1, &hwif);
+		index = ide_register_hw(&hw, NULL, 1, &hwif);
 		if (index == -1) break;
 		if (macintosh_config->ident == MAC_MODEL_PB190) {
 
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index e628a98..44cdb74 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -89,9 +89,8 @@ void q40_ide_setup_ports ( hw_regs_t *hw,
 		else
 			hw->io_ports[i] = Q40_ISA_IO_B(base + offsets[i]);
 	}
-	
+
 	hw->irq = irq;
-	hw->dma = NO_DMA;
 	hw->ack_intr = ack_intr;
 /*
  *	hw->iops = iops;
@@ -142,7 +141,7 @@ void q40ide_init(void)
 			0, NULL,
 //			m68kide_iops,
 			q40ide_default_irq(pcide_bases[i]));
-	index = ide_register_hw(&hw, 1, &hwif);
+	index = ide_register_hw(&hw, NULL, 1, &hwif);
 	// **FIXME**
 	if (index != -1)
 		hwif->mmio = 1;
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index 0c81d2d..912e738 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -89,26 +89,6 @@
 
 static int timings[4]={-1,-1,-1,-1}; /* stores current timing for each timer */
 
-static void qd_write_reg (u8 content, unsigned long reg)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ide_lock, flags);
-	outb(content,reg);
-	spin_unlock_irqrestore(&ide_lock, flags);
-}
-
-static u8 __init qd_read_reg (unsigned long reg)
-{
-	unsigned long flags;
-	u8 read;
-
-	spin_lock_irqsave(&ide_lock, flags);
-	read = inb(reg);
-	spin_unlock_irqrestore(&ide_lock, flags);
-	return read;
-}
-
 /*
  * qd_select:
  *
@@ -121,7 +101,7 @@ static void qd_select (ide_drive_t *drive)
 			(QD_TIMREG(drive) & 0x02);
 
 	if (timings[index] != QD_TIMING(drive))
-		qd_write_reg(timings[index] = QD_TIMING(drive), QD_TIMREG(drive));
+		outb(timings[index] = QD_TIMING(drive), QD_TIMREG(drive));
 }
 
 /*
@@ -284,7 +264,7 @@ static void qd6580_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	}
 
 	if (!HWIF(drive)->channel && drive->media != ide_disk) {
-		qd_write_reg(0x5f, QD_CONTROL_PORT);
+		outb(0x5f, QD_CONTROL_PORT);
 		printk(KERN_WARNING "%s: ATAPI: disabled read-ahead FIFO "
 			"and post-write buffer on %s.\n",
 			drive->name, HWIF(drive)->name);
@@ -301,16 +281,15 @@ static void qd6580_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 static int __init qd_testreg(int port)
 {
-	u8 savereg;
-	u8 readreg;
 	unsigned long flags;
+	u8 savereg, readreg;
 
-	spin_lock_irqsave(&ide_lock, flags);
+	local_irq_save(flags);
 	savereg = inb_p(port);
 	outb_p(QD_TESTVAL, port);	/* safe value */
 	readreg = inb_p(port);
 	outb(savereg, port);
-	spin_unlock_irqrestore(&ide_lock, flags);
+	local_irq_restore(flags);
 
 	if (savereg == QD_TESTVAL) {
 		printk(KERN_ERR "Outch ! the probe for qd65xx isn't reliable !\n");
@@ -364,13 +343,13 @@ static void __exit qd_unsetup(ide_hwif_t *hwif)
 
 	if (set_pio_mode == (void *)qd6500_set_pio_mode) {
 		// will do it for both
-		qd_write_reg(QD6500_DEF_DATA, QD_TIMREG(&hwif->drives[0]));
+		outb(QD6500_DEF_DATA, QD_TIMREG(&hwif->drives[0]));
 	} else if (set_pio_mode == (void *)qd6580_set_pio_mode) {
 		if (QD_CONTROL(hwif) & QD_CONTR_SEC_DISABLED) {
-			qd_write_reg(QD6580_DEF_DATA, QD_TIMREG(&hwif->drives[0]));
-			qd_write_reg(QD6580_DEF_DATA2, QD_TIMREG(&hwif->drives[1]));
+			outb(QD6580_DEF_DATA, QD_TIMREG(&hwif->drives[0]));
+			outb(QD6580_DEF_DATA2, QD_TIMREG(&hwif->drives[1]));
 		} else {
-			qd_write_reg(hwif->channel ? QD6580_DEF_DATA2 : QD6580_DEF_DATA, QD_TIMREG(&hwif->drives[0]));
+			outb(hwif->channel ? QD6580_DEF_DATA2 : QD6580_DEF_DATA, QD_TIMREG(&hwif->drives[0]));
 		}
 	} else {
 		printk(KERN_WARNING "Unknown qd65xx tuning fonction !\n");
@@ -389,10 +368,11 @@ static void __exit qd_unsetup(ide_hwif_t *hwif)
 static int __init qd_probe(int base)
 {
 	ide_hwif_t *hwif;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	u8 config;
 	u8 unit;
 
-	config = qd_read_reg(QD_CONFIG_PORT);
+	config = inb(QD_CONFIG_PORT);
 
 	if (! ((config & QD_CONFIG_BASEPORT) >> 1 == (base == 0xb0)) )
 		return 1;
@@ -419,9 +399,9 @@ static int __init qd_probe(int base)
 
 		hwif->set_pio_mode = &qd6500_set_pio_mode;
 
-		probe_hwif_init(hwif);
+		idx[0] = unit;
 
-		ide_proc_register_port(hwif);
+		ide_device_add(idx);
 
 		return 1;
 	}
@@ -436,7 +416,7 @@ static int __init qd_probe(int base)
 
 		/* qd6580 found */
 
-		control = qd_read_reg(QD_CONTROL_PORT);
+		control = inb(QD_CONTROL_PORT);
 
 		printk(KERN_NOTICE "qd6580 at %#x\n", base);
 		printk(KERN_DEBUG "qd6580: config=%#x, control=%#x, ID3=%u\n",
@@ -453,11 +433,11 @@ static int __init qd_probe(int base)
 
 			hwif->set_pio_mode = &qd6580_set_pio_mode;
 
-			probe_hwif_init(hwif);
+			idx[0] = unit;
 
-			qd_write_reg(QD_DEF_CONTR,QD_CONTROL_PORT);
+			ide_device_add(idx);
 
-			ide_proc_register_port(hwif);
+			outb(QD_DEF_CONTR, QD_CONTROL_PORT);
 
 			return 1;
 		} else {
@@ -474,19 +454,17 @@ static int __init qd_probe(int base)
 
 			hwif->set_pio_mode = &qd6580_set_pio_mode;
 
-			probe_hwif_init(hwif);
-
 			qd_setup(mate, base, config | (control << 8),
 				 QD6580_DEF_DATA2, QD6580_DEF_DATA2);
 
 			mate->set_pio_mode = &qd6580_set_pio_mode;
 
-			probe_hwif_init(mate);
+			idx[0] = 0;
+			idx[1] = 1;
 
-			qd_write_reg(QD_DEF_CONTR,QD_CONTROL_PORT);
+			ide_device_add(idx);
 
-			ide_proc_register_port(hwif);
-			ide_proc_register_port(mate);
+			outb(QD_DEF_CONTR, QD_CONTROL_PORT);
 
 			return 0; /* no other qd65xx possible */
 		}
diff --git a/drivers/ide/legacy/umc8672.c b/drivers/ide/legacy/umc8672.c
index 1151c92..79577b9 100644
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -124,8 +124,9 @@ static void umc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 static int __init umc8672_probe(void)
 {
-	unsigned long flags;
 	ide_hwif_t *hwif, *mate;
+	unsigned long flags;
+	static u8 idx[4] = { 0, 1, 0xff, 0xff };
 
 	if (!request_region(0x108, 2, "umc8672")) {
 		printk(KERN_ERR "umc8672: ports 0x108-0x109 already in use.\n");
@@ -158,11 +159,7 @@ static int __init umc8672_probe(void)
 	mate->mate = hwif;
 	mate->channel = 1;
 
-	probe_hwif_init(hwif);
-	probe_hwif_init(mate);
-
-	ide_proc_register_port(hwif);
-	ide_proc_register_port(mate);
+	ide_device_add(idx);
 
 	return 0;
 }
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 2f322d7..1de5856 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -601,8 +601,9 @@ static int au_ide_probe(struct device *dev)
 	_auide_hwif *ahwif = &auide_hwif;
 	ide_hwif_t *hwif;
 	struct resource *res;
-	hw_regs_t *hw;
 	int ret = 0;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw;
 
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA)
 	char *mode = "MWDMA2";
@@ -644,12 +645,12 @@ static int au_ide_probe(struct device *dev)
 	/* FIXME:  This might possibly break PCMCIA IDE devices */
 
 	hwif                            = &ide_hwifs[pdev->id];
-	hw 				= &hwif->hw;
-	hwif->irq = hw->irq             = ahwif->irq;
+	hwif->irq			= ahwif->irq;
 	hwif->chipset                   = ide_au1xxx;
 
-	auide_setup_ports(hw, ahwif);
-	memcpy(hwif->io_ports, hw->io_ports, sizeof(hwif->io_ports));
+	memset(&hw, 0, sizeof(hw));
+	auide_setup_ports(&hw, ahwif);
+	memcpy(hwif->io_ports, hw.io_ports, sizeof(hwif->io_ports));
 
 	hwif->ultra_mask                = 0x0;  /* Disable Ultra DMA */
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
@@ -706,8 +707,10 @@ static int au_ide_probe(struct device *dev)
 	hwif->config_data               = 0;    /* no chipset-specific code */
 
 	hwif->drives[0].autotune        = 1;    /* 1=autotune, 2=noautotune, 0=default */
+	hwif->drives[1].autotune	= 1;
 #endif
-	hwif->drives[0].no_io_32bit     = 1;   
+	hwif->drives[0].no_io_32bit	= 1;
+	hwif->drives[1].no_io_32bit	= 1;
 
 	auide_hwif.hwif                 = hwif;
 	hwif->hwif_data                 = &auide_hwif;
@@ -717,9 +720,9 @@ static int au_ide_probe(struct device *dev)
 	dbdma_init_done = 1;
 #endif
 
-	probe_hwif_init(hwif);
+	idx[0] = hwif->index;
 
-	ide_proc_register_port(hwif);
+	ide_device_add(idx);
 
 	dev_set_drvdata(dev, hwif);
 
diff --git a/drivers/ide/mips/swarm.c b/drivers/ide/mips/swarm.c
index c2e2957..521edd4 100644
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -71,6 +71,7 @@ static int __devinit swarm_ide_probe(struct device *dev)
 	u8 __iomem *base;
 	phys_t offset, size;
 	int i;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	if (!SIBYTE_HAVE_IDE)
 		return -ENODEV;
@@ -119,18 +120,15 @@ static int __devinit swarm_ide_probe(struct device *dev)
 	hwif->noprobe = 0;
 
 	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
-		hwif->hw.io_ports[i] =
+		hwif->io_ports[i] =
 				(unsigned long)(base + ((0x1f0 + i) << 5));
-	hwif->hw.io_ports[IDE_CONTROL_OFFSET] =
+	hwif->io_ports[IDE_CONTROL_OFFSET] =
 				(unsigned long)(base + (0x3f6 << 5));
-	hwif->hw.irq = K_INT_GB_IDE;
+	hwif->irq = K_INT_GB_IDE;
 
-	memcpy(hwif->io_ports, hwif->hw.io_ports, sizeof(hwif->io_ports));
-	hwif->irq = hwif->hw.irq;
+	idx[0] = hwif->index;
 
-	probe_hwif_init(hwif);
-
-	ide_proc_register_port(hwif);
+	ide_device_add(idx);
 
 	dev_set_drvdata(dev, hwif);
 
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index b3dc12a..19ec421 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/aec62xx.c		Version 0.26	Sep 1, 2007
+ * linux/drivers/ide/pci/aec62xx.c		Version 0.27	Sep 16, 2007
  *
  * Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2007		MontaVista Software, Inc. <source@mvista.com>
@@ -141,19 +141,6 @@ static void aec_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	drive->hwif->set_dma_mode(drive, pio + XFER_PIO_0);
 }
 
-static void aec62xx_dma_lost_irq (ide_drive_t *drive)
-{
-	switch (HWIF(drive)->pci_dev->device) {
-		case PCI_DEVICE_ID_ARTOP_ATP860:
-		case PCI_DEVICE_ID_ARTOP_ATP860R:
-		case PCI_DEVICE_ID_ARTOP_ATP865:
-		case PCI_DEVICE_ID_ARTOP_ATP865R:
-			printk(" AEC62XX time out ");
-		default:
-			break;
-	}
-}
-
 static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const char *name)
 {
 	int bus_speed = system_bus_clock();
@@ -195,8 +182,6 @@ static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->dma_lost_irq	= &aec62xx_dma_lost_irq;
-
 	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
 		return;
 
@@ -209,7 +194,7 @@ static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 	}
 }
 
-static ide_pci_device_t aec62xx_chipsets[] __devinitdata = {
+static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "AEC6210",
 		.init_chipset	= init_chipset_aec62xx,
@@ -268,12 +253,12 @@ static ide_pci_device_t aec62xx_chipsets[] __devinitdata = {
  *	finds a device matching our IDE device tables.
  *
  *	NOTE: since we're going to modify the 'name' field for AEC-6[26]80[R]
- *	chips, pass a local copy of 'struct pci_device_id' down the call chain.
+ *	chips, pass a local copy of 'struct ide_port_info' down the call chain.
  */
- 
+
 static int __devinit aec62xx_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t d;
+	struct ide_port_info d;
 	u8 idx = id->driver_data;
 
 	d = aec62xx_chipsets[idx];
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 8ee2b48..a607dd3 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/alim15x3.c		Version 0.27	Aug 27 2007
+ * linux/drivers/ide/pci/alim15x3.c		Version 0.29	Sep 16 2007
  *
  *  Copyright (C) 1998-2000 Michel Aubry, Maintainer
  *  Copyright (C) 1998-2000 Andrzej Krzysztofowicz, Maintainer
@@ -492,6 +492,13 @@ static unsigned int __devinit init_chipset_ali15x3 (struct pci_dev *dev, const c
 		 * clear bit 7
 		 */
 		pci_write_config_byte(dev, 0x4b, tmpbyte & 0x7F);
+		/*
+		 * check m1533, 0x5e, bit 1~4 == 1001 => & 00011110 = 00010010
+		 */
+		if (m5229_revision >= 0x20 && isa_dev) {
+			pci_read_config_byte(isa_dev, 0x5e, &tmpbyte);
+			chip_is_1543c_e = ((tmpbyte & 0x1e) == 0x12) ? 1: 0;
+		}
 		goto out;
 	}
 
@@ -537,7 +544,30 @@ static unsigned int __devinit init_chipset_ali15x3 (struct pci_dev *dev, const c
 			pci_write_config_byte(isa_dev, 0x79, tmpbyte | 0x02);
 		}
 	}
+
 out:
+	/*
+	 * CD_ROM DMA on (m5229, 0x53, bit0)
+	 *      Enable this bit even if we want to use PIO.
+	 * PIO FIFO off (m5229, 0x53, bit1)
+	 *      The hardware will use 0x54h and 0x55h to control PIO FIFO.
+	 *	(Not on later devices it seems)
+	 *
+	 *	0x53 changes meaning on later revs - we must no touch
+	 *	bit 1 on them.  Need to check if 0x20 is the right break.
+	 */
+	if (m5229_revision >= 0x20) {
+		pci_read_config_byte(dev, 0x53, &tmpbyte);
+
+		if (m5229_revision <= 0x20)
+			tmpbyte = (tmpbyte & (~0x02)) | 0x01;
+		else if (m5229_revision == 0xc7 || m5229_revision == 0xc8)
+			tmpbyte |= 0x03;
+		else
+			tmpbyte |= 0x01;
+
+		pci_write_config_byte(dev, 0x53, tmpbyte);
+	}
 	pci_dev_put(north);
 	pci_dev_put(isa_dev);
 	local_irq_restore(flags);
@@ -616,36 +646,8 @@ static u8 __devinit ata66_ali15x3(ide_hwif_t *hwif)
 			if ((tmpbyte & (1 << hwif->channel)) == 0)
 				cbl = ATA_CBL_PATA80;
 		}
-	} else {
-		/*
-		 * check m1533, 0x5e, bit 1~4 == 1001 => & 00011110 = 00010010
-		 */
-		pci_read_config_byte(isa_dev, 0x5e, &tmpbyte);
-		chip_is_1543c_e = ((tmpbyte & 0x1e) == 0x12) ? 1: 0;
 	}
 
-	/*
-	 * CD_ROM DMA on (m5229, 0x53, bit0)
-	 *      Enable this bit even if we want to use PIO
-	 * PIO FIFO off (m5229, 0x53, bit1)
-	 *      The hardware will use 0x54h and 0x55h to control PIO FIFO
-	 *	(Not on later devices it seems)
-	 *
-	 *	0x53 changes meaning on later revs - we must no touch
-	 *	bit 1 on them. Need to check if 0x20 is the right break
-	 */
-	 
-	pci_read_config_byte(dev, 0x53, &tmpbyte);
-	
-	if(m5229_revision <= 0x20)
-		tmpbyte = (tmpbyte & (~0x02)) | 0x01;
-	else if (m5229_revision == 0xc7 || m5229_revision == 0xc8)
-		tmpbyte |= 0x03;
-	else
-		tmpbyte |= 0x01;
-
-	pci_write_config_byte(dev, 0x53, tmpbyte);
-
 	local_irq_restore(flags);
 
 	return cbl;
@@ -664,31 +666,9 @@ static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
 	hwif->set_dma_mode = &ali_set_dma_mode;
 	hwif->udma_filter = &ali_udma_filter;
 
-	/* don't use LBA48 DMA on ALi devices before rev 0xC5 */
-	if (m5229_revision <= 0xC4)
-		hwif->host_flags |= IDE_HFLAG_NO_LBA48_DMA;
-
 	if (hwif->dma_base == 0)
 		return;
 
-	/*
-	 * check in ->init_dma guarantees m5229_revision >= 0x20 here
-	 */
-
-	if (m5229_revision == 0x20)
-		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
-
-	if (m5229_revision <= 0x20)
-		hwif->ultra_mask = 0x00; /* no udma */
-	else if (m5229_revision < 0xC2)
-		hwif->ultra_mask = ATA_UDMA2;
-	else if (m5229_revision == 0xC2 || m5229_revision == 0xC3)
-		hwif->ultra_mask = ATA_UDMA4;
-	else if (m5229_revision == 0xC4)
-		hwif->ultra_mask = ATA_UDMA5;
-	else
-		hwif->ultra_mask = ATA_UDMA6;
-
 	hwif->dma_setup = &ali15x3_dma_setup;
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
@@ -766,7 +746,7 @@ static void __devinit init_dma_ali15x3 (ide_hwif_t *hwif, unsigned long dmabase)
 	ide_setup_dma(hwif, dmabase, 8);
 }
 
-static ide_pci_device_t ali15x3_chipset __devinitdata = {
+static const struct ide_port_info ali15x3_chipset __devinitdata = {
 	.name		= "ALI15X3",
 	.init_chipset	= init_chipset_ali15x3,
 	.init_hwif	= init_hwif_ali15x3,
@@ -792,15 +772,34 @@ static int __devinit alim15x3_init_one(struct pci_dev *dev, const struct pci_dev
 		{ },
 	};
 
-	ide_pci_device_t *d = &ali15x3_chipset;
+	struct ide_port_info d = ali15x3_chipset;
+	u8 rev = dev->revision;
 
 	if (pci_dev_present(ati_rs100))
 		printk(KERN_WARNING "alim15x3: ATI Radeon IGP Northbridge is not yet fully tested.\n");
 
+	/* don't use LBA48 DMA on ALi devices before rev 0xC5 */
+	if (rev <= 0xC4)
+		d.host_flags |= IDE_HFLAG_NO_LBA48_DMA;
+
+	if (rev >= 0x20) {
+		if (rev == 0x20)
+			d.host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
+
+		if (rev < 0xC2)
+			d.udma_mask = ATA_UDMA2;
+		else if (rev == 0xC2 || rev == 0xC3)
+			d.udma_mask = ATA_UDMA4;
+		else if (rev == 0xC4)
+			d.udma_mask = ATA_UDMA5;
+		else
+			d.udma_mask = ATA_UDMA6;
+	}
+
 #if defined(CONFIG_SPARC64)
-	d->init_hwif = init_hwif_common_ali15x3;
+	d.init_hwif = init_hwif_common_ali15x3;
 #endif /* CONFIG_SPARC64 */
-	return ide_setup_pci_device(dev, d);
+	return ide_setup_pci_device(dev, &d);
 }
 
 
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 7cafefb..8d4125e 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -77,7 +77,7 @@ static struct amd_ide_chip {
 };
 
 static struct amd_ide_chip *amd_config;
-static ide_pci_device_t *amd_chipset;
+static const struct ide_port_info *amd_chipset;
 static unsigned int amd_80w;
 static unsigned int amd_clock;
 
@@ -242,19 +242,12 @@ static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev, const ch
 
 static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 {
-	int i;
-
 	if (hwif->irq == 0) /* 0 is bogus but will do for now */
 		hwif->irq = pci_get_legacy_ide_irq(hwif->pci_dev, hwif->channel);
 
 	hwif->set_pio_mode = &amd_set_pio_mode;
 	hwif->set_dma_mode = &amd_set_drive;
 
-	for (i = 0; i < 2; i++) {
-		hwif->drives[i].io_32bit = 1;
-		hwif->drives[i].unmask = 1;
-	}
-
 	if (!hwif->dma_base)
 		return;
 
@@ -270,16 +263,21 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 	}
 }
 
+#define IDE_HFLAGS_AMD \
+	(IDE_HFLAG_PIO_NO_BLACKLIST | \
+	 IDE_HFLAG_PIO_NO_DOWNGRADE | \
+	 IDE_HFLAG_POST_SET_MODE | \
+	 IDE_HFLAG_IO_32BIT | \
+	 IDE_HFLAG_UNMASK_IRQS | \
+	 IDE_HFLAG_BOOTABLE)
+
 #define DECLARE_AMD_DEV(name_str)					\
 	{								\
 		.name		= name_str,				\
 		.init_chipset	= init_chipset_amd74xx,			\
 		.init_hwif	= init_hwif_amd74xx,			\
 		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},	\
-		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |		\
-				  IDE_HFLAG_PIO_NO_DOWNGRADE |		\
-				  IDE_HFLAG_POST_SET_MODE |		\
-				  IDE_HFLAG_BOOTABLE,			\
+		.host_flags	= IDE_HFLAGS_AMD,			\
 		.pio_mask	= ATA_PIO5,				\
 		.swdma_mask	= ATA_SWDMA2,				\
 		.mwdma_mask	= ATA_MWDMA2,				\
@@ -291,16 +289,13 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 		.init_chipset	= init_chipset_amd74xx,			\
 		.init_hwif	= init_hwif_amd74xx,			\
 		.enablebits	= {{0x50,0x02,0x02}, {0x50,0x01,0x01}},	\
-		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |		\
-				  IDE_HFLAG_PIO_NO_DOWNGRADE |		\
-				  IDE_HFLAG_POST_SET_MODE |		\
-				  IDE_HFLAG_BOOTABLE,			\
+		.host_flags	= IDE_HFLAGS_AMD,			\
 		.pio_mask	= ATA_PIO5,				\
 		.swdma_mask	= ATA_SWDMA2,				\
 		.mwdma_mask	= ATA_MWDMA2,				\
 	}
 
-static ide_pci_device_t amd74xx_chipsets[] __devinitdata = {
+static const struct ide_port_info amd74xx_chipsets[] __devinitdata = {
 	/*  0 */ DECLARE_AMD_DEV("AMD7401"),
 	/*  1 */ DECLARE_AMD_DEV("AMD7409"),
 	/*  2 */ DECLARE_AMD_DEV("AMD7411"),
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index 3078430..ef8e016 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -189,8 +189,7 @@ static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 	hwif->dma_host_off = &atiixp_dma_host_off;
 }
 
-
-static ide_pci_device_t atiixp_pci_info[] __devinitdata = {
+static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
 	{	/* 0 */
 		.name		= "ATIIXP",
 		.init_hwif	= init_hwif_atiixp,
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index f369645..4aa4810 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -185,6 +185,8 @@ static u8 recovery_counts[4] = {16, 16, 16, 16}; /* Recovery count (encoded) */
 
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
+static DEFINE_SPINLOCK(cmd640_lock);
+
 /*
  * These are initialized to point at the devices we control
  */
@@ -258,12 +260,12 @@ static u8 get_cmd640_reg_vlb (u16 reg)
 
 static u8 get_cmd640_reg(u16 reg)
 {
-	u8 b;
 	unsigned long flags;
+	u8 b;
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&cmd640_lock, flags);
 	b = __get_cmd640_reg(reg);
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&cmd640_lock, flags);
 	return b;
 }
 
@@ -271,9 +273,9 @@ static void put_cmd640_reg(u16 reg, u8 val)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&cmd640_lock, flags);
 	__put_cmd640_reg(reg,val);
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&cmd640_lock, flags);
 }
 
 static int __init match_pci_cmd640_device (void)
@@ -351,7 +353,7 @@ static int __init secondary_port_responding (void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&cmd640_lock, flags);
 
 	outb_p(0x0a, 0x170 + IDE_SELECT_OFFSET);	/* select drive0 */
 	udelay(100);
@@ -359,11 +361,11 @@ static int __init secondary_port_responding (void)
 		outb_p(0x1a, 0x170 + IDE_SELECT_OFFSET); /* select drive1 */
 		udelay(100);
 		if ((inb_p(0x170 + IDE_SELECT_OFFSET) & 0x1f) != 0x1a) {
-			spin_unlock_irqrestore(&ide_lock, flags);
+			spin_unlock_irqrestore(&cmd640_lock, flags);
 			return 0; /* nothing responded */
 		}
 	}
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&cmd640_lock, flags);
 	return 1; /* success */
 }
 
@@ -440,11 +442,11 @@ static void __init setup_device_ptrs (void)
 static void set_prefetch_mode (unsigned int index, int mode)
 {
 	ide_drive_t *drive = cmd_drives[index];
+	unsigned long flags;
 	int reg = prefetch_regs[index];
 	u8 b;
-	unsigned long flags;
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&cmd640_lock, flags);
 	b = __get_cmd640_reg(reg);
 	if (mode) {	/* want prefetch on? */
 #if CMD640_PREFETCH_MASKS
@@ -460,7 +462,7 @@ static void set_prefetch_mode (unsigned int index, int mode)
 		b |= prefetch_masks[index];	/* disable prefetch */
 	}
 	__put_cmd640_reg(reg, b);
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&cmd640_lock, flags);
 }
 
 /*
@@ -561,7 +563,7 @@ static void program_drive_counts (unsigned int index)
 	/*
 	 * Now that everything is ready, program the new timings
 	 */
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&cmd640_lock, flags);
 	/*
 	 * Program the address_setup clocks into ARTTIM reg,
 	 * and then the active/recovery counts into the DRWTIM reg
@@ -570,7 +572,7 @@ static void program_drive_counts (unsigned int index)
 	setup_count |= __get_cmd640_reg(arttim_regs[index]) & 0x3f;
 	__put_cmd640_reg(arttim_regs[index], setup_count);
 	__put_cmd640_reg(drwtim_regs[index], pack_nibbles(active_count, recovery_count));
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&cmd640_lock, flags);
 }
 
 /*
@@ -670,20 +672,20 @@ static void cmd640_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 static int pci_conf1(void)
 {
-	u32 tmp;
 	unsigned long flags;
+	u32 tmp;
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&cmd640_lock, flags);
 	outb(0x01, 0xCFB);
 	tmp = inl(0xCF8);
 	outl(0x80000000, 0xCF8);
 	if (inl(0xCF8) == 0x80000000) {
 		outl(tmp, 0xCF8);
-		spin_unlock_irqrestore(&ide_lock, flags);
+		spin_unlock_irqrestore(&cmd640_lock, flags);
 		return 1;
 	}
 	outl(tmp, 0xCF8);
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&cmd640_lock, flags);
 	return 0;
 }
 
@@ -691,15 +693,15 @@ static int pci_conf2(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&cmd640_lock, flags);
 	outb(0x00, 0xCFB);
 	outb(0x00, 0xCF8);
 	outb(0x00, 0xCFA);
 	if (inb(0xCF8) == 0x00 && inb(0xCF8) == 0x00) {
-		spin_unlock_irqrestore(&ide_lock, flags);
+		spin_unlock_irqrestore(&cmd640_lock, flags);
 		return 1;
 	}
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&cmd640_lock, flags);
 	return 0;
 }
 
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index adee2ef..ea0143e 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -535,7 +535,6 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 		hwif->ide_dma_test_irq	= &cmd648_ide_dma_test_irq;
 		break;
 	case PCI_DEVICE_ID_CMD_646:
-		hwif->chipset = ide_cmd646;
 		if (dev->revision == 0x01) {
 			hwif->ide_dma_end = &cmd646_1_ide_dma_end;
 			break;
@@ -549,7 +548,7 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 	}
 }
 
-static ide_pci_device_t cmd64x_chipsets[] __devinitdata = {
+static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "CMD643",
 		.init_chipset	= init_chipset_cmd64x,
@@ -573,6 +572,7 @@ static ide_pci_device_t cmd64x_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
+		.chipset	= ide_cmd646,
 		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -591,7 +591,7 @@ static ide_pci_device_t cmd64x_chipsets[] __devinitdata = {
 
 static int __devinit cmd64x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t d;
+	struct ide_port_info d;
 	u8 idx = id->driver_data;
 
 	d = cmd64x_chipsets[idx];
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index aa98e81..0466462 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -141,7 +141,7 @@ static void __devinit init_hwif_cs5520(ide_hwif_t *hwif)
 		.pio_mask	= ATA_PIO4,			\
 	}
 
-static ide_pci_device_t cyrix_chipsets[] __devinitdata = {
+static const struct ide_port_info cyrix_chipsets[] __devinitdata = {
 	/* 0 */ DECLARE_CS_DEV("Cyrix 5510"),
 	/* 1 */ DECLARE_CS_DEV("Cyrix 5520")
 };
@@ -154,9 +154,8 @@ static ide_pci_device_t cyrix_chipsets[] __devinitdata = {
  
 static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_hwif_t *hwif = NULL, *mate = NULL;
-	ata_index_t index;
-	ide_pci_device_t *d = &cyrix_chipsets[id->driver_data];
+	const struct ide_port_info *d = &cyrix_chipsets[id->driver_data];
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	ide_setup_pci_noise(dev, d);
 
@@ -172,29 +171,14 @@ static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_devic
 		return -ENODEV;
 	}
 
-	index.all = 0xf0f0;
-
 	/*
 	 *	Now the chipset is configured we can let the core
 	 *	do all the device setup for us
 	 */
 
-	ide_pci_setup_ports(dev, d, 14, &index);
-
-	if ((index.b.low & 0xf0) != 0xf0)
-		hwif = &ide_hwifs[index.b.low];
-	if ((index.b.high & 0xf0) != 0xf0)
-		mate = &ide_hwifs[index.b.high];
-
-	if (hwif)
-		probe_hwif_init(hwif);
-	if (mate)
-		probe_hwif_init(mate);
+	ide_pci_setup_ports(dev, d, 14, &idx[0]);
 
-	if (hwif)
-		ide_proc_register_port(hwif);
-	if (mate)
-		ide_proc_register_port(mate);
+	ide_device_add(idx);
 
 	return 0;
 }
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index ba0c6eb..5994089 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/cs5530.c		Version 0.76	Aug 3 2007
+ * linux/drivers/ide/pci/cs5530.c		Version 0.77	Sep 24 2007
  *
  * Copyright (C) 2000			Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2000			Mark Lord <mlord@pobox.com>
@@ -146,7 +146,6 @@ static void cs5530_set_dma_mode(ide_drive_t *drive, const u8 mode)
 static unsigned int __devinit init_chipset_cs5530 (struct pci_dev *dev, const char *name)
 {
 	struct pci_dev *master_0 = NULL, *cs5530_0 = NULL;
-	unsigned long flags;
 
 	if (pci_resource_start(dev, 4) == 0)
 		return -EFAULT;
@@ -171,9 +170,6 @@ static unsigned int __devinit init_chipset_cs5530 (struct pci_dev *dev, const ch
 		goto out;
 	}
 
-	spin_lock_irqsave(&ide_lock, flags);
-		/* all CPUs (there should only be one CPU with this chipset) */
-
 	/*
 	 * Enable BusMaster and MemoryWriteAndInvalidate for the cs5530:
 	 * -->  OR 0x14 into 16-bit PCI COMMAND reg of function 0 of the cs5530
@@ -224,8 +220,6 @@ static unsigned int __devinit init_chipset_cs5530 (struct pci_dev *dev, const ch
 	pci_write_config_byte(master_0, 0x42, 0x00);
 	pci_write_config_byte(master_0, 0x43, 0xc1);
 
-	spin_unlock_irqrestore(&ide_lock, flags);
-
 out:
 	pci_dev_put(master_0);
 	pci_dev_put(cs5530_0);
@@ -261,7 +255,7 @@ static void __devinit init_hwif_cs5530 (ide_hwif_t *hwif)
 	hwif->udma_filter = cs5530_udma_filter;
 }
 
-static ide_pci_device_t cs5530_chipset __devinitdata = {
+static const struct ide_port_info cs5530_chipset __devinitdata = {
 	.name		= "CS5530",
 	.init_chipset	= init_chipset_cs5530,
 	.init_hwif	= init_hwif_cs5530,
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index 5ac82ff..9094916 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -186,7 +186,7 @@ static void __devinit init_hwif_cs5535(ide_hwif_t *hwif)
 	hwif->cbl = cs5535_cable_detect(hwif->pci_dev);
 }
 
-static ide_pci_device_t cs5535_chipset __devinitdata = {
+static const struct ide_port_info cs5535_chipset __devinitdata = {
 	.name		= "CS5535",
 	.init_hwif	= init_hwif_cs5535,
 	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE |
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index efc20bd..3ef4fc1 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -428,7 +428,6 @@ static unsigned int __devinit init_chipset_cy82c693(struct pci_dev *dev, const c
  */
 static void __devinit init_hwif_cy82c693(ide_hwif_t *hwif)
 {
-	hwif->chipset = ide_cy82c693;
 	hwif->set_pio_mode = &cy82c693_set_pio_mode;
 
 	if (hwif->dma_base == 0)
@@ -449,11 +448,12 @@ static void __devinit init_iops_cy82c693(ide_hwif_t *hwif)
 	}
 }
 
-static ide_pci_device_t cy82c693_chipset __devinitdata = {
+static const struct ide_port_info cy82c693_chipset __devinitdata = {
 	.name		= "CY82C693",
 	.init_chipset	= init_chipset_cy82c693,
 	.init_iops	= init_iops_cy82c693,
 	.init_hwif	= init_hwif_cy82c693,
+	.chipset	= ide_cy82c693,
 	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 			  IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO4,
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index 46f4a88..8382908 100644
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -80,7 +80,7 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 	hw.irq = dev->irq;
 	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
-	rc = ide_register_hw_with_fixup(&hw, 0, &hwif, ide_undecoded_slave);
+	rc = ide_register_hw(&hw, &ide_undecoded_slave, 0, &hwif);
 	if (rc < 0) {
 		printk(KERN_ERR "delkin_cb: ide_register_hw failed (%d)\n", rc);
 		pci_disable_device(dev);
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index 5116583..f44d708 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -54,37 +54,24 @@ __setup("all-generic-ide", ide_generic_all_on);
 module_param_named(all_generic_ide, ide_generic_all, bool, 0444);
 MODULE_PARM_DESC(all_generic_ide, "IDE generic will claim all unknown PCI IDE storage controllers.");
 
-static void __devinit init_hwif_generic (ide_hwif_t *hwif)
-{
-	switch(hwif->pci_dev->device) {
-		case PCI_DEVICE_ID_UMC_UM8673F:
-		case PCI_DEVICE_ID_UMC_UM8886A:
-		case PCI_DEVICE_ID_UMC_UM8886BF:
-			hwif->irq = hwif->channel ? 15 : 14;
-			break;
-		default:
-			break;
-	}
-}
+#define IDE_HFLAGS_UMC (IDE_HFLAG_NO_DMA | IDE_HFLAG_FORCE_LEGACY_IRQS)
 
-#define DECLARE_GENERIC_PCI_DEV(name_str, dma_setting) \
+#define DECLARE_GENERIC_PCI_DEV(name_str, extra_flags) \
 	{ \
 		.name		= name_str, \
-		.init_hwif	= init_hwif_generic, \
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA | \
-				  dma_setting | \
+				  extra_flags | \
 				  IDE_HFLAG_BOOTABLE, \
 		.swdma_mask	= ATA_SWDMA2, \
 		.mwdma_mask	= ATA_MWDMA2, \
 		.udma_mask	= ATA_UDMA6, \
 	}
 
-static ide_pci_device_t generic_chipsets[] __devinitdata = {
+static const struct ide_port_info generic_chipsets[] __devinitdata = {
 	/*  0 */ DECLARE_GENERIC_PCI_DEV("Unknown",	0),
 
 	{	/* 1 */
 		.name		= "NS87410",
-		.init_hwif	= init_hwif_generic,
 		.enablebits	= {{0x43,0x08,0x08}, {0x47,0x08,0x08}},
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 				  IDE_HFLAG_BOOTABLE,
@@ -95,16 +82,15 @@ static ide_pci_device_t generic_chipsets[] __devinitdata = {
 
 	/*  2 */ DECLARE_GENERIC_PCI_DEV("SAMURAI",	0),
 	/*  3 */ DECLARE_GENERIC_PCI_DEV("HT6565",	0),
-	/*  4 */ DECLARE_GENERIC_PCI_DEV("UM8673F",	IDE_HFLAG_NO_DMA),
-	/*  5 */ DECLARE_GENERIC_PCI_DEV("UM8886A",	IDE_HFLAG_NO_DMA),
-	/*  6 */ DECLARE_GENERIC_PCI_DEV("UM8886BF",	IDE_HFLAG_NO_DMA),
+	/*  4 */ DECLARE_GENERIC_PCI_DEV("UM8673F",	IDE_HFLAGS_UMC),
+	/*  5 */ DECLARE_GENERIC_PCI_DEV("UM8886A",	IDE_HFLAGS_UMC),
+	/*  6 */ DECLARE_GENERIC_PCI_DEV("UM8886BF",	IDE_HFLAGS_UMC),
 	/*  7 */ DECLARE_GENERIC_PCI_DEV("HINT_IDE",	0),
 	/*  8 */ DECLARE_GENERIC_PCI_DEV("VIA_IDE",	IDE_HFLAG_NO_AUTODMA),
 	/*  9 */ DECLARE_GENERIC_PCI_DEV("OPTI621V",	IDE_HFLAG_NO_AUTODMA),
 
 	{	/* 10 */
 		.name		= "VIA8237SATA",
-		.init_hwif	= init_hwif_generic,
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 				  IDE_HFLAG_OFF_BOARD,
 		.swdma_mask	= ATA_SWDMA2,
@@ -118,7 +104,6 @@ static ide_pci_device_t generic_chipsets[] __devinitdata = {
 
 	{	/* 14 */
 		.name		= "Revolution",
-		.init_hwif	= init_hwif_generic,
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 				  IDE_HFLAG_OFF_BOARD,
 		.swdma_mask	= ATA_SWDMA2,
@@ -138,7 +123,7 @@ static ide_pci_device_t generic_chipsets[] __devinitdata = {
  
 static int __devinit generic_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t *d = &generic_chipsets[id->driver_data];
+	const struct ide_port_info *d = &generic_chipsets[id->driver_data];
 	int ret = -ENODEV;
 
 	/* Don't use the generic entry unless instructed to do so */
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index 67af1a7..ae6307f 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -129,7 +129,7 @@ static void __devinit init_hwif_hpt34x(ide_hwif_t *hwif)
 	hwif->set_dma_mode = &hpt34x_set_mode;
 }
 
-static ide_pci_device_t hpt34x_chipsets[] __devinitdata = {
+static const struct ide_port_info hpt34x_chipsets[] __devinitdata = {
 	{ /* 0 */
 		.name		= "HPT343",
 		.init_chipset	= init_chipset_hpt34x,
@@ -158,7 +158,7 @@ static ide_pci_device_t hpt34x_chipsets[] __devinitdata = {
 
 static int __devinit hpt34x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t *d;
+	const struct ide_port_info *d;
 	u16 pcicmd = 0;
 
 	pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 18f5b7d..612b795 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1425,7 +1425,7 @@ static int __devinit hpt36x_init(struct pci_dev *dev, struct pci_dev *dev2)
 	return 0;
 }
 
-static ide_pci_device_t hpt366_chipsets[] __devinitdata = {
+static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "HPT36x",
 		.init_chipset	= init_chipset_hpt366,
@@ -1510,7 +1510,7 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 {
 	struct hpt_info *info = NULL;
 	struct pci_dev *dev2 = NULL;
-	ide_pci_device_t d;
+	struct ide_port_info d;
 	u8 idx = id->driver_data;
 	u8 rev = dev->revision;
 
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index dfbe605..90b52ed 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -193,7 +193,7 @@ static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 		.udma_mask	= ATA_UDMA6,		\
 	}
 
-static ide_pci_device_t it8213_chipsets[] __devinitdata = {
+static const struct ide_port_info it8213_chipsets[] __devinitdata = {
 	/* 0 */ DECLARE_ITE_DEV("IT8213"),
 };
 
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index ec45b72..1a7ddd1 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -638,7 +638,7 @@ static unsigned int __devinit init_chipset_it821x(struct pci_dev *dev, const cha
 		.pio_mask	= ATA_PIO4,		\
 	}
 
-static ide_pci_device_t it821x_chipsets[] __devinitdata = {
+static const struct ide_port_info it821x_chipsets[] __devinitdata = {
 	/* 0 */ DECLARE_ITE_DEV("IT8212"),
 };
 
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index 2eeff67..bdf64d9 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -118,7 +118,7 @@ static void __devinit init_hwif_jmicron(ide_hwif_t *hwif)
 		hwif->cbl = ata66_jmicron(hwif);
 }
 
-static ide_pci_device_t jmicron_chipset __devinitdata = {
+static const struct ide_port_info jmicron_chipset __devinitdata = {
 	.name		= "JMB",
 	.init_hwif	= init_hwif_jmicron,
 	.host_flags	= IDE_HFLAG_BOOTABLE,
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index d21b589..d4df464 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -260,7 +260,7 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 	hwif->ide_dma_end = &ns87415_ide_dma_end;
 }
 
-static ide_pci_device_t ns87415_chipset __devinitdata = {
+static const struct ide_port_info ns87415_chipset __devinitdata = {
 	.name		= "NS87415",
 #ifdef CONFIG_SUPERIO
 	.init_iops	= init_iops_ns87415,
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index 3573ffe..8953d9c 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/opti621.c		Version 0.8	Aug 27, 2007
+ *  linux/drivers/ide/pci/opti621.c		Version 0.9	Sep 24, 2007
  *
  *  Copyright (C) 1996-1998  Linus Torvalds & authors (see below)
  */
@@ -133,6 +133,8 @@ static int reg_base;
 #define PIO_NOT_EXIST 254
 #define PIO_DONT_KNOW 255
 
+static DEFINE_SPINLOCK(opti621_lock);
+
 /* there are stored pio numbers from other calls of opti621_set_pio_mode */
 static void compute_pios(ide_drive_t *drive, const u8 pio)
 /* Store values into drive->drive_data
@@ -278,7 +280,7 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		second.recovery_time, drdy);
 #endif
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&opti621_lock, flags);
 
      	reg_base = hwif->io_ports[IDE_DATA_OFFSET];
 
@@ -317,7 +319,7 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	/*  and read prefetch for both drives */
 	write_reg(misc, MISC_REG);
 
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&opti621_lock, flags);
 }
 
 /*
@@ -331,7 +333,7 @@ static void __devinit init_hwif_opti621 (ide_hwif_t *hwif)
 	hwif->set_pio_mode = &opti621_set_pio_mode;
 }
 
-static ide_pci_device_t opti621_chipsets[] __devinitdata = {
+static const struct ide_port_info opti621_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "OPTI621",
 		.init_hwif	= init_hwif_opti621,
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index d1e7823..4234efe 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -513,7 +513,7 @@ static struct pci_dev * __devinit pdc20270_get_dev2(struct pci_dev *dev)
 		.udma_mask	= udma, \
 	}
 
-static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
+static const struct ide_port_info pdcnew_chipsets[] __devinitdata = {
 	/* 0 */ DECLARE_PDCNEW_DEV("PDC20268", ATA_UDMA5),
 	/* 1 */ DECLARE_PDCNEW_DEV("PDC20269", ATA_UDMA6),
 	/* 2 */ DECLARE_PDCNEW_DEV("PDC20270", ATA_UDMA5),
@@ -534,7 +534,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
  
 static int __devinit pdc202new_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t *d;
+	const struct ide_port_info *d;
 	struct pci_dev *bridge = dev->bus->self;
 	u8 idx = id->driver_data;
 
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index 2930612..e09742e 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -302,13 +302,6 @@ static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev,
 
 static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = hwif->pci_dev;
-
-	/* PDC20265 has problems with large LBA48 requests */
-	if ((dev->device == PCI_DEVICE_ID_PROMISE_20267) ||
-	    (dev->device == PCI_DEVICE_ID_PROMISE_20265))
-		hwif->rqsize = 256;
-
 	hwif->set_pio_mode = &pdc202xx_set_pio_mode;
 	hwif->set_dma_mode = &pdc202xx_set_mode;
 
@@ -382,7 +375,7 @@ static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
 	}
 }
 
-#define DECLARE_PDC2026X_DEV(name_str, udma) \
+#define DECLARE_PDC2026X_DEV(name_str, udma, extra_flags) \
 	{ \
 		.name		= name_str, \
 		.init_chipset	= init_chipset_pdc202xx, \
@@ -390,13 +383,14 @@ static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
 		.init_dma	= init_dma_pdc202xx, \
 		.extra		= 48, \
 		.host_flags	= IDE_HFLAG_ERROR_STOPS_FIFO | \
+				  extra_flags | \
 				  IDE_HFLAG_OFF_BOARD, \
 		.pio_mask	= ATA_PIO4, \
 		.mwdma_mask	= ATA_MWDMA2, \
 		.udma_mask	= udma, \
 	}
 
-static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
+static const struct ide_port_info pdc202xx_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "PDC20246",
 		.init_chipset	= init_chipset_pdc202xx,
@@ -410,10 +404,10 @@ static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
 		.udma_mask	= ATA_UDMA2,
 	},
 
-	/* 1 */ DECLARE_PDC2026X_DEV("PDC20262", ATA_UDMA4),
-	/* 2 */ DECLARE_PDC2026X_DEV("PDC20263", ATA_UDMA4),
-	/* 3 */ DECLARE_PDC2026X_DEV("PDC20265", ATA_UDMA5),
-	/* 4 */ DECLARE_PDC2026X_DEV("PDC20267", ATA_UDMA5),
+	/* 1 */ DECLARE_PDC2026X_DEV("PDC20262", ATA_UDMA4, 0),
+	/* 2 */ DECLARE_PDC2026X_DEV("PDC20263", ATA_UDMA4, 0),
+	/* 3 */ DECLARE_PDC2026X_DEV("PDC20265", ATA_UDMA5, IDE_HFLAG_RQSIZE_256),
+	/* 4 */ DECLARE_PDC2026X_DEV("PDC20267", ATA_UDMA5, IDE_HFLAG_RQSIZE_256),
 };
 
 /**
@@ -427,7 +421,7 @@ static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
  
 static int __devinit pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t *d;
+	const struct ide_port_info *d;
 	u8 idx = id->driver_data;
 
 	d = &pdc202xx_chipsets[idx];
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index ec0c6e9..9329d4a 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -396,7 +396,7 @@ static void __devinit init_hwif_ich(ide_hwif_t *hwif)
 		.udma_mask	= udma, \
 	}
 
-static ide_pci_device_t piix_pci_info[] __devinitdata = {
+static const struct ide_port_info piix_pci_info[] __devinitdata = {
 	/*  0 */ DECLARE_PIIX_DEV("PIIXa",	0x00),	/* no udma */
 	/*  1 */ DECLARE_PIIX_DEV("PIIXb",	0x00),	/* no udma */
 
@@ -449,9 +449,7 @@ static ide_pci_device_t piix_pci_info[] __devinitdata = {
  
 static int __devinit piix_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t *d = &piix_pci_info[id->driver_data];
-
-	return ide_setup_pci_device(dev, d);
+	return ide_setup_pci_device(dev, &piix_pci_info[id->driver_data]);
 }
 
 /**
diff --git a/drivers/ide/pci/rz1000.c b/drivers/ide/pci/rz1000.c
index dd2583e..6b10ae2 100644
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -35,13 +35,13 @@ static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
 	u16 reg;
 	struct pci_dev *dev = hwif->pci_dev;
 
-	hwif->chipset = ide_rz1000;
 	if (!pci_read_config_word (dev, 0x40, &reg) &&
 	    !pci_write_config_word(dev, 0x40, reg & 0xdfff)) {
 		printk(KERN_INFO "%s: disabled chipset read-ahead "
 			"(buggy RZ1000/RZ1001)\n", hwif->name);
 	} else {
-		hwif->serialized = 1;
+		if (hwif->mate)
+			hwif->mate->serialized = hwif->serialized = 1;
 		hwif->drives[0].no_unmask = 1;
 		hwif->drives[1].no_unmask = 1;
 		printk(KERN_INFO "%s: serialized, disabled unmasking "
@@ -49,9 +49,10 @@ static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
 	}
 }
 
-static ide_pci_device_t rz1000_chipset __devinitdata = {
+static const struct ide_port_info rz1000_chipset __devinitdata = {
 	.name		= "RZ100x",
 	.init_hwif	= init_hwif_rz1000,
+	.chipset	= ide_rz1000,
 	.host_flags	= IDE_HFLAG_NO_DMA | IDE_HFLAG_BOOTABLE,
 };
 
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index b2423e0..d2c8b55 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -372,7 +372,7 @@ static void __devinit init_hwif_sc1200 (ide_hwif_t *hwif)
 	hwif->ide_dma_end   = &sc1200_ide_dma_end;
 }
 
-static ide_pci_device_t sc1200_chipset __devinitdata = {
+static const struct ide_port_info sc1200_chipset __devinitdata = {
 	.name		= "SC1200",
 	.init_hwif	= init_hwif_sc1200,
 	.host_flags	= IDE_HFLAG_SERIALIZE |
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index ae9b503..ebb7132 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -538,12 +538,13 @@ static int setup_mmio_scc (struct pci_dev *dev, const char *name)
 /**
  *	init_setup_scc	-	set up an SCC PATA Controller
  *	@dev: PCI device
- *	@d: IDE PCI device
+ *	@d: IDE port info
  *
  *	Perform the initial set up for this device.
  */
 
-static int __devinit init_setup_scc(struct pci_dev *dev, ide_pci_device_t *d)
+static int __devinit init_setup_scc(struct pci_dev *dev,
+				    const struct ide_port_info *d)
 {
 	unsigned long ctl_base;
 	unsigned long dma_base;
@@ -702,7 +703,7 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
       .pio_mask		= ATA_PIO4,			\
   }
 
-static ide_pci_device_t scc_chipsets[] __devinitdata = {
+static const struct ide_port_info scc_chipsets[] __devinitdata = {
 	/* 0 */ DECLARE_SCC_DEV("sccIDE"),
 };
 
@@ -717,9 +718,7 @@ static ide_pci_device_t scc_chipsets[] __devinitdata = {
 
 static int __devinit scc_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t *d = &scc_chipsets[id->driver_data];
-
-	return init_setup_scc(dev, d);
+	return init_setup_scc(dev, &scc_chipsets[id->driver_data]);
 }
 
 /**
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index a3d880e..a728031 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -158,13 +158,6 @@ static void svwks_set_dma_mode(ide_drive_t *drive, const u8 speed)
 
 	u8 ultra_enable	 = 0, ultra_timing = 0, dma_timing = 0;
 
-	/* If we are about to put a disk into UDMA mode we screwed up.
-	   Our code assumes we never _ever_ do this on an OSB4 */
-	   
-	if(dev->device == PCI_DEVICE_ID_SERVERWORKS_OSB4 &&
-		drive->media == ide_disk && speed >= XFER_UDMA_0)
-			BUG();
-
 	pci_read_config_byte(dev, (0x56|hwif->channel), &ultra_timing);
 	pci_read_config_byte(dev, 0x54, &ultra_enable);
 
@@ -373,7 +366,7 @@ static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 	}
 }
 
-static ide_pci_device_t serverworks_chipsets[] __devinitdata = {
+static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "SvrWks OSB4",
 		.init_chipset	= init_chipset_svwks,
@@ -430,7 +423,7 @@ static ide_pci_device_t serverworks_chipsets[] __devinitdata = {
  
 static int __devinit svwks_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t d;
+	struct ide_port_info d;
 	u8 idx = id->driver_data;
 
 	d = serverworks_chipsets[idx];
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 5af74ea..de820aa 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -614,6 +614,7 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	void __iomem *virt_base;
 	ide_hwif_t *hwif;
 	int h;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	/*
 	 * Find an empty HWIF; if none available, return -ENOMEM.
@@ -654,10 +655,12 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	}
 
 	if (hwif->io_ports[IDE_DATA_OFFSET] != cmd_base) {
+		hw_regs_t hw;
+
 		/* Initialize the IO registers */
-		sgiioc4_init_hwif_ports(&hwif->hw, cmd_base, ctl, irqport);
-		memcpy(hwif->io_ports, hwif->hw.io_ports,
-		       sizeof (hwif->io_ports));
+		memset(&hw, 0, sizeof(hw));
+		sgiioc4_init_hwif_ports(&hw, cmd_base, ctl, irqport);
+		memcpy(hwif->io_ports, hw.io_ports, sizeof(hwif->io_ports));
 		hwif->noprobe = !hwif->io_ports[IDE_DATA_OFFSET];
 	}
 
@@ -679,11 +682,10 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 
 	ide_init_sgiioc4(hwif);
 
-	if (probe_hwif_init(hwif))
-		return -EIO;
+	idx[0] = hwif->index;
 
-	/* Create /proc/ide entries */
-	ide_proc_register_port(hwif);
+	if (ide_device_add(idx))
+		return -EIO;
 
 	return 0;
 }
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 689786d..dc915cb 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/siimage.c		Version 1.17	Oct 18 2007
+ * linux/drivers/ide/pci/siimage.c		Version 1.18	Oct 18 2007
  *
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2003		Red Hat <alan@redhat.com>
@@ -57,8 +57,8 @@
  
 static int pdev_is_sata(struct pci_dev *pdev)
 {
-	switch(pdev->device)
-	{
+#ifdef CONFIG_BLK_DEV_IDE_SATA
+	switch(pdev->device) {
 		case PCI_DEVICE_ID_SII_3112:
 		case PCI_DEVICE_ID_SII_1210SA:
 			return 1;
@@ -66,9 +66,10 @@ static int pdev_is_sata(struct pci_dev *pdev)
 			return 0;
 	}
 	BUG();
+#endif
 	return 0;
 }
- 
+
 /**
  *	is_sata			-	check if hwif is SATA
  *	@hwif:	interface to check
@@ -136,7 +137,7 @@ static inline unsigned long siimage_seldev(ide_drive_t *drive, int r)
  *	SI3112 SATA controller life is a bit simpler.
  */
 
-static u8 sil_udma_filter(ide_drive_t *drive)
+static u8 sil_pata_udma_filter(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	unsigned long base = (unsigned long) hwif->hwif_data;
@@ -147,23 +148,23 @@ static u8 sil_udma_filter(ide_drive_t *drive)
 	else
 		pci_read_config_byte(hwif->pci_dev, 0x8A, &scsc);
 
-	if (is_sata(hwif)) {
-		mask = strstr(drive->id->model, "Maxtor") ? 0x3f : 0x7f;
-		goto out;
-	}
-
 	if ((scsc & 0x30) == 0x10)	/* 133 */
-		mask = 0x7f;
+		mask = ATA_UDMA6;
 	else if ((scsc & 0x30) == 0x20)	/* 2xPCI */
-		mask = 0x7f;
+		mask = ATA_UDMA6;
 	else if ((scsc & 0x30) == 0x00)	/* 100 */
-		mask = 0x3f;
+		mask = ATA_UDMA5;
 	else 	/* Disabled ? */
 		BUG();
-out:
+
 	return mask;
 }
 
+static u8 sil_sata_udma_filter(ide_drive_t *drive)
+{
+	return strstr(drive->id->model, "Maxtor") ? ATA_UDMA5 : ATA_UDMA6;
+}
+
 /**
  *	sil_set_pio_mode	-	set host controller for PIO mode
  *	@drive: drive
@@ -340,10 +341,11 @@ static int siimage_io_ide_dma_test_irq (ide_drive_t *drive)
 static int siimage_mmio_ide_dma_test_irq (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	unsigned long base	= (unsigned long)hwif->hwif_data;
 	unsigned long addr	= siimage_selreg(hwif, 0x1);
 
 	if (SATA_ERROR_REG) {
+		unsigned long base = (unsigned long)hwif->hwif_data;
+
 		u32 ext_stat = readl((void __iomem *)(base + 0x10));
 		u8 watchdog = 0;
 		if (ext_stat & ((hwif->channel) ? 0x40 : 0x10)) {
@@ -376,7 +378,7 @@ static int siimage_mmio_ide_dma_test_irq (ide_drive_t *drive)
 }
 
 /**
- *	siimage_busproc		-	bus isolation ioctl
+ *	sil_sata_busproc	-	bus isolation IOCTL
  *	@drive: drive to isolate/restore
  *	@state: bus state to set
  *
@@ -384,8 +386,8 @@ static int siimage_mmio_ide_dma_test_irq (ide_drive_t *drive)
  *	SATA controller the work required is quite limited, we 
  *	just have to clean up the statistics
  */
- 
-static int siimage_busproc (ide_drive_t * drive, int state)
+
+static int sil_sata_busproc(ide_drive_t * drive, int state)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	u32 stat_config		= 0;
@@ -417,14 +419,14 @@ static int siimage_busproc (ide_drive_t * drive, int state)
 }
 
 /**
- *	siimage_reset_poll	-	wait for sata reset
+ *	sil_sata_reset_poll	-	wait for SATA reset
  *	@drive: drive we are resetting
  *
  *	Poll the SATA phy and see whether it has come back from the dead
  *	yet.
  */
- 
-static int siimage_reset_poll (ide_drive_t *drive)
+
+static int sil_sata_reset_poll(ide_drive_t *drive)
 {
 	if (SATA_STATUS_REG) {
 		ide_hwif_t *hwif	= HWIF(drive);
@@ -436,27 +438,22 @@ static int siimage_reset_poll (ide_drive_t *drive)
 			HWGROUP(drive)->polling = 0;
 			return ide_started;
 		}
-		return 0;
-	} else {
-		return 0;
 	}
+
+	return 0;
 }
 
 /**
- *	siimage_pre_reset	-	reset hook
+ *	sil_sata_pre_reset	-	reset hook
  *	@drive: IDE device being reset
  *
  *	For the SATA devices we need to handle recalibration/geometry
  *	differently
  */
- 
-static void siimage_pre_reset (ide_drive_t *drive)
-{
-	if (drive->media != ide_disk)
-		return;
 
-	if (is_sata(HWIF(drive)))
-	{
+static void sil_sata_pre_reset(ide_drive_t *drive)
+{
+	if (drive->media == ide_disk) {
 		drive->special.b.set_geometry = 0;
 		drive->special.b.recalibrate = 0;
 	}
@@ -502,7 +499,6 @@ static void siimage_reset (ide_drive_t *drive)
 			drive->failures++;
 		}
 	}
-
 }
 
 /**
@@ -758,16 +754,11 @@ static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 		hwif->sata_misc[SATA_IEN_OFFSET]	= base + 0x148;
 	}
 
-	hw.irq				= hwif->pci_dev->irq;
+	memcpy(hwif->io_ports, hw.io_ports, sizeof(hwif->io_ports));
 
-	memcpy(&hwif->hw, &hw, sizeof(hw));
-	memcpy(hwif->io_ports, hwif->hw.io_ports, sizeof(hwif->hw.io_ports));
+	hwif->irq = dev->irq;
 
-	hwif->irq			= hw.irq;
-
-       	base = (unsigned long) addr;
-
-	hwif->dma_base			= base + (ch ? 0x08 : 0x00);
+	hwif->dma_base = (unsigned long)addr + (ch ? 0x08 : 0x00);
 
 	hwif->mmio = 1;
 }
@@ -864,28 +855,31 @@ static u8 __devinit ata66_siimage(ide_hwif_t *hwif)
 
 static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 {
+	u8 sata = is_sata(hwif);
+
 	hwif->resetproc = &siimage_reset;
 	hwif->set_pio_mode = &sil_set_pio_mode;
 	hwif->set_dma_mode = &sil_set_dma_mode;
-	hwif->reset_poll = &siimage_reset_poll;
-	hwif->pre_reset = &siimage_pre_reset;
-	hwif->udma_filter = &sil_udma_filter;
 
-	if(is_sata(hwif)) {
+	if (sata) {
 		static int first = 1;
 
-		hwif->busproc   = &siimage_busproc;
+		hwif->busproc = &sil_sata_busproc;
+		hwif->reset_poll = &sil_sata_reset_poll;
+		hwif->pre_reset = &sil_sata_pre_reset;
+		hwif->udma_filter = &sil_sata_udma_filter;
 
 		if (first) {
 			printk(KERN_INFO "siimage: For full SATA support you should use the libata sata_sil module.\n");
 			first = 0;
 		}
-	}
+	} else
+		hwif->udma_filter = &sil_pata_udma_filter;
 
 	if (hwif->dma_base == 0)
 		return;
 
-	if (is_sata(hwif))
+	if (sata)
 		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
@@ -911,7 +905,7 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 		.udma_mask	= ATA_UDMA6,		\
 	}
 
-static ide_pci_device_t siimage_chipsets[] __devinitdata = {
+static const struct ide_port_info siimage_chipsets[] __devinitdata = {
 	/* 0 */ DECLARE_SII_DEV("SiI680"),
 	/* 1 */ DECLARE_SII_DEV("SiI3112 Serial ATA"),
 	/* 2 */ DECLARE_SII_DEV("Adaptec AAR-1210SA")
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index c1d280b..6b7bb53 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -264,7 +264,7 @@ static void sis_ata133_program_timings(ide_drive_t *drive, const u8 mode)
 	if (mode >= XFER_MW_DMA_0) {
 		t1 &= ~0x04;	/* disable UDMA */
 		idx = mode - XFER_MW_DMA_0 + 5;
-	}
+	} else
 		idx = mode - XFER_PIO_0;
 	t1 |= ini_time_value[clk][idx] << 12;
 	t1 |= act_time_value[clk][idx] << 16;
@@ -579,7 +579,7 @@ static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
 		hwif->cbl = ata66_sis5513(hwif);
 }
 
-static ide_pci_device_t sis5513_chipset __devinitdata = {
+static const struct ide_port_info sis5513_chipset __devinitdata = {
 	.name		= "SIS5513",
 	.init_chipset	= init_chipset_sis5513,
 	.init_hwif	= init_hwif_sis5513,
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index 0dce459..147d783 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -361,13 +361,6 @@ static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 	hwif->selectproc	= &sl82c105_selectproc;
 	hwif->resetproc 	= &sl82c105_resetproc;
 
-	/*
-	 * We support 32-bit I/O on this interface, and
-	 * it doesn't have problems with interrupts.
-	 */
-	hwif->drives[0].io_32bit = hwif->drives[1].io_32bit = 1;
-	hwif->drives[0].unmask   = hwif->drives[1].unmask   = 1;
-
 	if (!hwif->dma_base)
 		return;
 
@@ -394,12 +387,15 @@ static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 		hwif->serialized = hwif->mate->serialized = 1;
 }
 
-static ide_pci_device_t sl82c105_chipset __devinitdata = {
+static const struct ide_port_info sl82c105_chipset __devinitdata = {
 	.name		= "W82C105",
 	.init_chipset	= init_chipset_sl82c105,
 	.init_hwif	= init_hwif_sl82c105,
 	.enablebits	= {{0x40,0x01,0x01}, {0x40,0x10,0x10}},
-	.host_flags	= IDE_HFLAG_NO_AUTODMA | IDE_HFLAG_BOOTABLE,
+	.host_flags	= IDE_HFLAG_IO_32BIT |
+			  IDE_HFLAG_UNMASK_IRQS |
+			  IDE_HFLAG_NO_AUTODMA |
+			  IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO5,
 };
 
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index 4f22dff..eb4445b 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/slc90e66.c	Version 0.18	Aug 9, 2007
+ *  linux/drivers/ide/pci/slc90e66.c	Version 0.19	Sep 24, 2007
  *
  *  Copyright (C) 2000-2002 Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
@@ -21,6 +21,8 @@
 
 #include <asm/io.h>
 
+static DEFINE_SPINLOCK(slc90e66_lock);
+
 static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
@@ -40,7 +42,7 @@ static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
 					{ 2, 1 },
 					{ 2, 3 }, };
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&slc90e66_lock, flags);
 	pci_read_config_word(dev, master_port, &master_data);
 
 	if (pio > 1)
@@ -71,7 +73,7 @@ static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	pci_write_config_word(dev, master_port, master_data);
 	if (is_slave)
 		pci_write_config_byte(dev, slave_port, slave_data);
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&slc90e66_lock, flags);
 }
 
 static void slc90e66_set_dma_mode(ide_drive_t *drive, const u8 speed)
@@ -146,7 +148,7 @@ static void __devinit init_hwif_slc90e66 (ide_hwif_t *hwif)
 		hwif->cbl = (reg47 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 }
 
-static ide_pci_device_t slc90e66_chipset __devinitdata = {
+static const struct ide_port_info slc90e66_chipset __devinitdata = {
 	.name		= "SLC90E66",
 	.init_hwif	= init_hwif_slc90e66,
 	.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}},
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index 631506e..a66ebd1 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -218,7 +218,7 @@ static unsigned int __devinit init_chipset_tc86c001(struct pci_dev *dev,
 	return err;
 }
 
-static ide_pci_device_t tc86c001_chipset __devinitdata = {
+static const struct ide_port_info tc86c001_chipset __devinitdata = {
 	.name		= "TC86C001",
 	.init_chipset	= init_chipset_tc86c001,
 	.init_hwif	= init_hwif_tc86c001,
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index 30b52f6..a227c41 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -102,7 +102,7 @@ static void __devinit init_hwif_triflex(ide_hwif_t *hwif)
 	hwif->set_dma_mode = &triflex_set_mode;
 }
 
-static ide_pci_device_t triflex_device __devinitdata = {
+static const struct ide_port_info triflex_device __devinitdata = {
 	.name		= "TRIFLEX",
 	.init_hwif	= init_hwif_triflex,
 	.enablebits	= {{0x80, 0x01, 0x01}, {0x80, 0x02, 0x02}},
diff --git a/drivers/ide/pci/trm290.c b/drivers/ide/pci/trm290.c
index 140d486..5011ba2 100644
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -250,7 +250,6 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 	u8 reg = 0;
 	struct pci_dev *dev = hwif->pci_dev;
 
-	hwif->chipset = ide_trm290;
 	cfgbase = pci_resource_start(dev, 4);
 	if ((dev->class & 5) && cfgbase) {
 		hwif->config_data = cfgbase;
@@ -320,9 +319,10 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 #endif
 }
 
-static ide_pci_device_t trm290_chipset __devinitdata = {
+static const struct ide_port_info trm290_chipset __devinitdata = {
 	.name		= "TRM290",
 	.init_hwif	= init_hwif_trm290,
+	.chipset	= ide_trm290,
 	.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
 #if 0 /* play it safe for now */
 			  IDE_HFLAG_TRUST_BIOS_FOR_DMA |
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index c8022a9..a0d3c16 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -1,6 +1,6 @@
 /*
  *
- * Version 3.49
+ * Version 3.50
  *
  * VIA IDE driver for Linux. Supported southbridges:
  *
@@ -422,65 +422,40 @@ static u8 __devinit via82cxxx_cable_detect(ide_hwif_t *hwif)
 
 static void __devinit init_hwif_via82cxxx(ide_hwif_t *hwif)
 {
-	struct via82cxxx_dev *vdev = pci_get_drvdata(hwif->pci_dev);
-	int i;
-
 	hwif->set_pio_mode = &via_set_pio_mode;
 	hwif->set_dma_mode = &via_set_drive;
 
-#ifdef CONFIG_PPC_CHRP
-	if(machine_is(chrp) && _chrp_type == _CHRP_Pegasos) {
-		hwif->irq = hwif->channel ? 15 : 14;
-	}
-#endif
-
-	for (i = 0; i < 2; i++) {
-		hwif->drives[i].io_32bit = 1;
-		hwif->drives[i].unmask = (vdev->via_config->flags & VIA_NO_UNMASK) ? 0 : 1;
-	}
-
 	if (!hwif->dma_base)
 		return;
 
-	hwif->ultra_mask = vdev->via_config->udma_mask;
-
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = via82cxxx_cable_detect(hwif);
 }
 
-static ide_pci_device_t via82cxxx_chipsets[] __devinitdata = {
-	{	/* 0 */
-		.name		= "VP_IDE",
-		.init_chipset	= init_chipset_via82cxxx,
-		.init_hwif	= init_hwif_via82cxxx,
-		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},
-		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |
-				  IDE_HFLAG_PIO_NO_DOWNGRADE |
-				  IDE_HFLAG_POST_SET_MODE |
-				  IDE_HFLAG_NO_AUTODMA |
-				  IDE_HFLAG_BOOTABLE,
-		.pio_mask	= ATA_PIO5,
-		.swdma_mask	= ATA_SWDMA2,
-		.mwdma_mask	= ATA_MWDMA2,
-	},{	/* 1 */
-		.name		= "VP_IDE",
-		.init_chipset	= init_chipset_via82cxxx,
-		.init_hwif	= init_hwif_via82cxxx,
-		.enablebits	= {{0x00,0x00,0x00}, {0x00,0x00,0x00}},
-		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |
-				  IDE_HFLAG_PIO_NO_DOWNGRADE |
-				  IDE_HFLAG_POST_SET_MODE |
-				  IDE_HFLAG_BOOTABLE,
-		.pio_mask	= ATA_PIO5,
-		.swdma_mask	= ATA_SWDMA2,
-		.mwdma_mask	= ATA_MWDMA2,
-	}
+static const struct ide_port_info via82cxxx_chipset __devinitdata = {
+	.name		= "VP_IDE",
+	.init_chipset	= init_chipset_via82cxxx,
+	.init_hwif	= init_hwif_via82cxxx,
+	.enablebits	= { { 0x40, 0x02, 0x02 }, { 0x40, 0x01, 0x01 } },
+	.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |
+			  IDE_HFLAG_PIO_NO_DOWNGRADE |
+			  IDE_HFLAG_POST_SET_MODE |
+			  IDE_HFLAG_IO_32BIT |
+			  IDE_HFLAG_BOOTABLE,
+	.pio_mask	= ATA_PIO5,
+	.swdma_mask	= ATA_SWDMA2,
+	.mwdma_mask	= ATA_MWDMA2,
 };
 
 static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	struct pci_dev *isa = NULL;
 	struct via_isa_bridge *via_config;
+	u8 idx = id->driver_data;
+	struct ide_port_info d;
+
+	d = via82cxxx_chipset;
+
 	/*
 	 * Find the ISA bridge and check we know what it is.
 	 */
@@ -490,7 +465,23 @@ static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_i
 		printk(KERN_WARNING "VP_IDE: Unknown VIA SouthBridge, disabling DMA.\n");
 		return -ENODEV;
 	}
-	return ide_setup_pci_device(dev, &via82cxxx_chipsets[id->driver_data]);
+
+	if (idx == 0)
+		d.host_flags |= IDE_HFLAG_NO_AUTODMA;
+	else
+		d.enablebits[1].reg = d.enablebits[0].reg = 0;
+
+	if ((via_config->flags & VIA_NO_UNMASK) == 0)
+		d.host_flags |= IDE_HFLAG_UNMASK_IRQS;
+
+#ifdef CONFIG_PPC_CHRP
+	if (machine_is(chrp) && _chrp_type == _CHRP_Pegasos)
+		d.host_flags |= IDE_HFLAG_FORCE_LEGACY_IRQS;
+#endif
+
+	d.udma_mask = via_config->udma_mask;
+
+	return ide_setup_pci_device(dev, &d);
 }
 
 static const struct pci_device_id via_pci_tbl[] = {
diff --git a/drivers/ide/ppc/mpc8xx.c b/drivers/ide/ppc/mpc8xx.c
index df2e920..5f0da35 100644
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -316,8 +316,8 @@ m8xx_ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port,
 
 	ide_hwifs[data_port].pio_mask = ATA_PIO4;
 	ide_hwifs[data_port].set_pio_mode = m8xx_ide_set_pio_mode;
+	ide_hwifs[data_port].ack_intr = (ide_ack_intr_t *)ide_interrupt_ack;
 
-	hw->ack_intr = (ide_ack_intr_t *) ide_interrupt_ack;
 	/* Enable Harddisk Interrupt,
 	 * and make it edge sensitive
 	 */
@@ -402,8 +402,8 @@ void m8xx_ide_init_hwif_ports (hw_regs_t *hw,
 
 	ide_hwifs[data_port].pio_mask = ATA_PIO4;
 	ide_hwifs[data_port].set_pio_mode = m8xx_ide_set_pio_mode;
+	ide_hwifs[data_port].ack_intr = (ide_ack_intr_t *)ide_interrupt_ack;
 
-	hw->ack_intr = (ide_ack_intr_t *) ide_interrupt_ack;
 	/* Enable Harddisk Interrupt,
 	 * and make it edge sensitive
 	 */
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index c554793..816b531 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1039,6 +1039,8 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 {
 	struct device_node *np = pmif->node;
 	const int *bidp;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw;
 
 	pmif->cable_80 = 0;
 	pmif->broken_dma = pmif->broken_dma_warn = 0;
@@ -1124,8 +1126,9 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 	/* Tell common code _not_ to mess with resources */
 	hwif->mmio = 1;
 	hwif->hwif_data = pmif;
-	pmac_ide_init_hwif_ports(&hwif->hw, pmif->regbase, 0, &hwif->irq);
-	memcpy(hwif->io_ports, hwif->hw.io_ports, sizeof(hwif->io_ports));
+	memset(&hw, 0, sizeof(hw));
+	pmac_ide_init_hwif_ports(&hw, pmif->regbase, 0, &hwif->irq);
+	memcpy(hwif->io_ports, hw.io_ports, sizeof(hwif->io_ports));
 	hwif->chipset = ide_pmac;
 	hwif->noprobe = !hwif->io_ports[IDE_DATA_OFFSET] || pmif->mediabay;
 	hwif->hold = pmif->mediabay;
@@ -1163,10 +1166,9 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 		pmac_ide_setup_dma(pmif, hwif);
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
 
-	/* We probe the hwif now */
-	probe_hwif_init(hwif);
+	idx[0] = hwif->index;
 
-	ide_proc_register_port(hwif);
+	ide_device_add(idx);
 
 	return 0;
 }
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index fff567b..02d14bf 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -147,15 +147,15 @@ static int ide_setup_pci_baseregs (struct pci_dev *dev, const char *name)
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 /**
  *	ide_get_or_set_dma_base		-	setup BMIBA
- *	@d: IDE pci device data
- *	@hwif: Interface
+ *	@d: IDE port info
+ *	@hwif: IDE interface
  *
  *	Fetch the DMA Bus-Master-I/O-Base-Address (BMIBA) from PCI space.
  *	Where a device has a partner that is already in DMA mode we check
  *	and enforce IDE simplex rules.
  */
 
-static unsigned long ide_get_or_set_dma_base(ide_pci_device_t *d, ide_hwif_t *hwif)
+static unsigned long ide_get_or_set_dma_base(const struct ide_port_info *d, ide_hwif_t *hwif)
 {
 	unsigned long	dma_base = 0;
 	struct pci_dev	*dev = hwif->pci_dev;
@@ -225,10 +225,11 @@ static unsigned long ide_get_or_set_dma_base(ide_pci_device_t *d, ide_hwif_t *hw
 }
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
-void ide_setup_pci_noise (struct pci_dev *dev, ide_pci_device_t *d)
+void ide_setup_pci_noise(struct pci_dev *dev, const struct ide_port_info *d)
 {
-	printk(KERN_INFO "%s: IDE controller at PCI slot %s\n",
-			 d->name, pci_name(dev));
+	printk(KERN_INFO "%s: IDE controller (0x%04x:0x%04x rev 0x%02x) at "
+			 " PCI slot %s\n", d->name, dev->vendor, dev->device,
+			 dev->revision, pci_name(dev));
 }
 
 EXPORT_SYMBOL_GPL(ide_setup_pci_noise);
@@ -237,15 +238,15 @@ EXPORT_SYMBOL_GPL(ide_setup_pci_noise);
 /**
  *	ide_pci_enable	-	do PCI enables
  *	@dev: PCI device
- *	@d: IDE pci device data
+ *	@d: IDE port info
  *
  *	Enable the IDE PCI device. We attempt to enable the device in full
  *	but if that fails then we only need BAR4 so we will enable that.
  *	
  *	Returns zero on success or an error code
  */
- 
-static int ide_pci_enable(struct pci_dev *dev, ide_pci_device_t *d)
+
+static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 {
 	int ret;
 
@@ -260,9 +261,9 @@ static int ide_pci_enable(struct pci_dev *dev, ide_pci_device_t *d)
 	}
 
 	/*
-	 * assume all devices can do 32-bit dma for now. we can add a
-	 * dma mask field to the ide_pci_device_t if we need it (or let
-	 * lower level driver set the dma mask)
+	 * assume all devices can do 32-bit DMA for now, we can add
+	 * a DMA mask field to the struct ide_port_info if we need it
+	 * (or let lower level driver set the DMA mask)
 	 */
 	ret = pci_set_dma_mask(dev, DMA_32BIT_MASK);
 	if (ret < 0) {
@@ -284,13 +285,13 @@ out:
 /**
  *	ide_pci_configure	-	configure an unconfigured device
  *	@dev: PCI device
- *	@d: IDE pci device data
+ *	@d: IDE port info
  *
  *	Enable and configure the PCI device we have been passed.
  *	Returns zero on success or an error code.
  */
- 
-static int ide_pci_configure(struct pci_dev *dev, ide_pci_device_t *d)
+
+static int ide_pci_configure(struct pci_dev *dev, const struct ide_port_info *d)
 {
 	u16 pcicmd = 0;
 	/*
@@ -318,15 +319,15 @@ static int ide_pci_configure(struct pci_dev *dev, ide_pci_device_t *d)
 
 /**
  *	ide_pci_check_iomem	-	check a register is I/O
- *	@dev: pci device
- *	@d: ide_pci_device
- *	@bar: bar number
+ *	@dev: PCI device
+ *	@d: IDE port info
+ *	@bar: BAR number
  *
  *	Checks if a BAR is configured and points to MMIO space. If so
  *	print an error and return an error code. Otherwise return 0
  */
- 
-static int ide_pci_check_iomem(struct pci_dev *dev, ide_pci_device_t *d, int bar)
+
+static int ide_pci_check_iomem(struct pci_dev *dev, const struct ide_port_info *d, int bar)
 {
 	ulong flags = pci_resource_flags(dev, bar);
 	
@@ -348,7 +349,7 @@ static int ide_pci_check_iomem(struct pci_dev *dev, ide_pci_device_t *d, int bar
 /**
  *	ide_hwif_configure	-	configure an IDE interface
  *	@dev: PCI device holding interface
- *	@d: IDE pci data
+ *	@d: IDE port info
  *	@mate: Paired interface if any
  *
  *	Perform the initial set up for the hardware interface structure. This
@@ -357,8 +358,8 @@ static int ide_pci_check_iomem(struct pci_dev *dev, ide_pci_device_t *d, int bar
  *
  *	Returns the new hardware interface structure, or NULL on a failure
  */
- 
-static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev, ide_pci_device_t *d, ide_hwif_t *mate, int port, int irq)
+
+static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev, const struct ide_port_info *d, ide_hwif_t *mate, int port, int irq)
 {
 	unsigned long ctl = 0, base = 0;
 	ide_hwif_t *hwif;
@@ -387,19 +388,20 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev, ide_pci_device_t *d,
 		return NULL;	/* no room in ide_hwifs[] */
 	if (hwif->io_ports[IDE_DATA_OFFSET] != base ||
 	    hwif->io_ports[IDE_CONTROL_OFFSET] != (ctl | 2)) {
-		memset(&hwif->hw, 0, sizeof(hwif->hw));
-#ifndef IDE_ARCH_OBSOLETE_INIT
-		ide_std_init_ports(&hwif->hw, base, (ctl | 2));
-		hwif->hw.io_ports[IDE_IRQ_OFFSET] = 0;
+		hw_regs_t hw;
+
+		memset(&hw, 0, sizeof(hw));
+#ifndef CONFIG_IDE_ARCH_OBSOLETE_INIT
+		ide_std_init_ports(&hw, base, ctl | 2);
 #else
-		ide_init_hwif_ports(&hwif->hw, base, (ctl | 2), NULL);
+		ide_init_hwif_ports(&hw, base, ctl | 2, NULL);
 #endif
-		memcpy(hwif->io_ports, hwif->hw.io_ports, sizeof(hwif->io_ports));
+		memcpy(hwif->io_ports, hw.io_ports, sizeof(hwif->io_ports));
 		hwif->noprobe = !hwif->io_ports[IDE_DATA_OFFSET];
 	}
-	hwif->chipset = ide_pci;
+	hwif->chipset = d->chipset ? d->chipset : ide_pci;
 	hwif->pci_dev = dev;
-	hwif->cds = (struct ide_pci_device_s *) d;
+	hwif->cds = d;
 	hwif->channel = port;
 
 	if (!hwif->irq)
@@ -414,21 +416,17 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev, ide_pci_device_t *d,
 /**
  *	ide_hwif_setup_dma	-	configure DMA interface
  *	@dev: PCI device
- *	@d: IDE pci data
- *	@hwif: Hardware interface we are configuring
+ *	@d: IDE port info
+ *	@hwif: IDE interface
  *
  *	Set up the DMA base for the interface. Enable the master bits as
  *	necessary and attempt to bring the device DMA into a ready to use
  *	state
  */
- 
-#ifndef CONFIG_BLK_DEV_IDEDMA_PCI
-static void ide_hwif_setup_dma(struct pci_dev *dev, ide_pci_device_t *d, ide_hwif_t *hwif)
-{
-}
-#else
-static void ide_hwif_setup_dma(struct pci_dev *dev, ide_pci_device_t *d, ide_hwif_t *hwif)
+
+static void ide_hwif_setup_dma(struct pci_dev *dev, const struct ide_port_info *d, ide_hwif_t *hwif)
 {
+#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 	u16 pcicmd;
 
 	pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
@@ -460,13 +458,13 @@ static void ide_hwif_setup_dma(struct pci_dev *dev, ide_pci_device_t *d, ide_hwi
 				"(BIOS)\n", hwif->name, d->name);
 		}
 	}
-}
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI*/
+}
 
 /**
  *	ide_setup_pci_controller	-	set up IDE PCI
  *	@dev: PCI device
- *	@d: IDE PCI data
+ *	@d: IDE port info
  *	@noisy: verbose flag
  *	@config: returned as 1 if we configured the hardware
  *
@@ -474,8 +472,8 @@ static void ide_hwif_setup_dma(struct pci_dev *dev, ide_pci_device_t *d, ide_hwi
  *	up the PCI side of the device, checks that the device is enabled
  *	and enables it if need be
  */
- 
-static int ide_setup_pci_controller(struct pci_dev *dev, ide_pci_device_t *d, int noisy, int *config)
+
+static int ide_setup_pci_controller(struct pci_dev *dev, const struct ide_port_info *d, int noisy, int *config)
 {
 	int ret;
 	u16 pcicmd;
@@ -500,9 +498,6 @@ static int ide_setup_pci_controller(struct pci_dev *dev, ide_pci_device_t *d, in
 		printk(KERN_INFO "%s: device enabled (Linux)\n", d->name);
 	}
 
-	if (noisy)
-		printk(KERN_INFO "%s: chipset revision %d\n",
-				 d->name, dev->revision);
 out:
 	return ret;
 }
@@ -510,9 +505,9 @@ out:
 /**
  *	ide_pci_setup_ports	-	configure ports/devices on PCI IDE
  *	@dev: PCI device
- *	@d: IDE pci device info
+ *	@d: IDE port info
  *	@pciirq: IRQ line
- *	@index: ata index to update
+ *	@idx: ATA index table to update
  *
  *	Scan the interfaces attached to this device and do any
  *	necessary per port setup. Attach the devices and ask the
@@ -522,26 +517,25 @@ out:
  *	but is also used directly as a helper function by some controllers
  *	where the chipset setup is not the default PCI IDE one.
  */
- 
-void ide_pci_setup_ports(struct pci_dev *dev, ide_pci_device_t *d, int pciirq, ata_index_t *index)
+
+void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d, int pciirq, u8 *idx)
 {
 	int channels = (d->host_flags & IDE_HFLAG_SINGLE) ? 1 : 2, port;
-	int at_least_one_hwif_enabled = 0;
 	ide_hwif_t *hwif, *mate = NULL;
 	u8 tmp;
 
-	index->all = 0xf0f0;
-
 	/*
 	 * Set up the IDE ports
 	 */
-	 
+
 	for (port = 0; port < channels; ++port) {
-		ide_pci_enablebit_t *e = &(d->enablebits[port]);
-	
+		const ide_pci_enablebit_t *e = &(d->enablebits[port]);
+
 		if (e->reg && (pci_read_config_byte(dev, e->reg, &tmp) ||
-		    (tmp & e->mask) != e->val))
+		    (tmp & e->mask) != e->val)) {
+			printk(KERN_INFO "%s: IDE port disabled\n", d->name);
 			continue;	/* port not enabled */
+		}
 
 		if ((hwif = ide_hwif_configure(dev, d, mate, port, pciirq)) == NULL)
 			continue;
@@ -549,11 +543,7 @@ void ide_pci_setup_ports(struct pci_dev *dev, ide_pci_device_t *d, int pciirq, a
 		/* setup proper ancestral information */
 		hwif->gendev.parent = &dev->dev;
 
-		if (hwif->channel) {
-			index->b.high = hwif->index;
-		} else {
-			index->b.low = hwif->index;
-		}
+		*(idx + port) = hwif->index;
 
 		
 		if (d->init_iops)
@@ -562,15 +552,28 @@ void ide_pci_setup_ports(struct pci_dev *dev, ide_pci_device_t *d, int pciirq, a
 		if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0)
 			ide_hwif_setup_dma(dev, d, hwif);
 
-		if ((d->host_flags & IDE_HFLAG_LEGACY_IRQS) && hwif->irq == 0)
+		if ((!hwif->irq && (d->host_flags & IDE_HFLAG_LEGACY_IRQS)) ||
+		    (d->host_flags & IDE_HFLAG_FORCE_LEGACY_IRQS))
 			hwif->irq = port ? 15 : 14;
 
+		hwif->fixup = d->fixup;
+
 		hwif->host_flags = d->host_flags;
 		hwif->pio_mask = d->pio_mask;
 
 		if ((d->host_flags & IDE_HFLAG_SERIALIZE) && hwif->mate)
 			hwif->mate->serialized = hwif->serialized = 1;
 
+		if (d->host_flags & IDE_HFLAG_IO_32BIT) {
+			hwif->drives[0].io_32bit = 1;
+			hwif->drives[1].io_32bit = 1;
+		}
+
+		if (d->host_flags & IDE_HFLAG_UNMASK_IRQS) {
+			hwif->drives[0].unmask = 1;
+			hwif->drives[1].unmask = 1;
+		}
+
 		if (hwif->dma_base) {
 			hwif->swdma_mask = d->swdma_mask;
 			hwif->mwdma_mask = d->mwdma_mask;
@@ -580,6 +583,9 @@ void ide_pci_setup_ports(struct pci_dev *dev, ide_pci_device_t *d, int pciirq, a
 		hwif->drives[0].autotune = 1;
 		hwif->drives[1].autotune = 1;
 
+		if (d->host_flags & IDE_HFLAG_RQSIZE_256)
+			hwif->rqsize = 256;
+
 		if (d->init_hwif)
 			/* Call chipset-specific routine
 			 * for each enabled hwif
@@ -587,10 +593,7 @@ void ide_pci_setup_ports(struct pci_dev *dev, ide_pci_device_t *d, int pciirq, a
 			d->init_hwif(hwif);
 
 		mate = hwif;
-		at_least_one_hwif_enabled = 1;
 	}
-	if (!at_least_one_hwif_enabled)
-		printk(KERN_INFO "%s: neither IDE port enabled (BIOS)\n", d->name);
 }
 
 EXPORT_SYMBOL_GPL(ide_pci_setup_ports);
@@ -602,13 +605,13 @@ EXPORT_SYMBOL_GPL(ide_pci_setup_ports);
  *
  * One thing that is not standardized is the location of the
  * primary/secondary interface "enable/disable" bits.  For chipsets that
- * we "know" about, this information is in the ide_pci_device_t struct;
+ * we "know" about, this information is in the struct ide_port_info;
  * for all other chipsets, we just assume both interfaces are enabled.
  */
-static int do_ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t *d,
-				   ata_index_t *index, u8 noisy)
+static int do_ide_setup_pci_device(struct pci_dev *dev,
+				   const struct ide_port_info *d,
+				   u8 *idx, u8 noisy)
 {
-	static ata_index_t ata_index = { .b = { .low = 0xff, .high = 0xff } };
 	int tried_config = 0;
 	int pciirq, ret;
 
@@ -658,51 +661,35 @@ static int do_ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t *d,
 
 	/* FIXME: silent failure can happen */
 
-	*index = ata_index;
-	ide_pci_setup_ports(dev, d, pciirq, index);
+	ide_pci_setup_ports(dev, d, pciirq, idx);
 out:
 	return ret;
 }
 
-int ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t *d)
+int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
 {
-	ide_hwif_t *hwif = NULL, *mate = NULL;
-	ata_index_t index_list;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	int ret;
 
-	ret = do_ide_setup_pci_device(dev, d, &index_list, 1);
-	if (ret < 0)
-		goto out;
+	ret = do_ide_setup_pci_device(dev, d, &idx[0], 1);
 
-	if ((index_list.b.low & 0xf0) != 0xf0)
-		hwif = &ide_hwifs[index_list.b.low];
-	if ((index_list.b.high & 0xf0) != 0xf0)
-		mate = &ide_hwifs[index_list.b.high];
+	if (ret >= 0)
+		ide_device_add(idx);
 
-	if (hwif)
-		probe_hwif_init_with_fixup(hwif, d->fixup);
-	if (mate)
-		probe_hwif_init_with_fixup(mate, d->fixup);
-
-	if (hwif)
-		ide_proc_register_port(hwif);
-	if (mate)
-		ide_proc_register_port(mate);
-out:
 	return ret;
 }
 
 EXPORT_SYMBOL_GPL(ide_setup_pci_device);
 
 int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
-			  ide_pci_device_t *d)
+			  const struct ide_port_info *d)
 {
 	struct pci_dev *pdev[] = { dev1, dev2 };
-	ata_index_t index_list[2];
 	int ret, i;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	for (i = 0; i < 2; i++) {
-		ret = do_ide_setup_pci_device(pdev[i], d, index_list + i, !i);
+		ret = do_ide_setup_pci_device(pdev[i], d, &idx[i*2], !i);
 		/*
 		 * FIXME: Mom, mom, they stole me the helper function to undo
 		 * do_ide_setup_pci_device() on the first device!
@@ -711,25 +698,7 @@ int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
 			goto out;
 	}
 
-	for (i = 0; i < 2; i++) {
-		u8 idx[2] = { index_list[i].b.low, index_list[i].b.high };
-		int j;
-
-		for (j = 0; j < 2; j++) {
-			if ((idx[j] & 0xf0) != 0xf0)
-				probe_hwif_init(ide_hwifs + idx[j]);
-		}
-	}
-
-	for (i = 0; i < 2; i++) {
-		u8 idx[2] = { index_list[i].b.low, index_list[i].b.high };
-		int j;
-
-		for (j = 0; j < 2; j++) {
-			if ((idx[j] & 0xf0) != 0xf0)
-				ide_proc_register_port(ide_hwifs + idx[j]);
-		}
-	}
+	ide_device_add(idx);
 out:
 	return ret;
 }
@@ -754,9 +723,6 @@ static LIST_HEAD(ide_pci_drivers);
  *	hands the controllers off to the core PCI code to do the rest of
  *	the work.
  *
- *	The driver_data of the driver table must point to an ide_pci_device_t
- *	describing the interface.
- *
  *	Returns are the same as for pci_register_driver
  */
 
diff --git a/drivers/macintosh/mediabay.c b/drivers/macintosh/mediabay.c
index c803d2b..48d647a 100644
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -563,7 +563,7 @@ static void media_bay_step(int i)
 				ide_init_hwif_ports(&hw, (unsigned long) bay->cd_base, (unsigned long) 0, NULL);
 				hw.irq = bay->cd_irq;
 				hw.chipset = ide_pmac;
-				bay->cd_index = ide_register_hw(&hw, 0, NULL);
+				bay->cd_index = ide_register_hw(&hw, NULL, 0, NULL);
 				pmu_resume();
 			}
 			if (bay->cd_index == -1) {
diff --git a/include/asm-alpha/ide.h b/include/asm-alpha/ide.h
index 2a5cc0b..b7bf68d 100644
--- a/include/asm-alpha/ide.h
+++ b/include/asm-alpha/ide.h
@@ -40,7 +40,6 @@ static inline unsigned long ide_default_io_base(int index)
 	}
 }
 
-#define IDE_ARCH_OBSOLETE_INIT
 #define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
 
 #ifdef CONFIG_PCI
diff --git a/include/asm-arm/ide.h b/include/asm-arm/ide.h
index 4f68c8a..f348fcf 100644
--- a/include/asm-arm/ide.h
+++ b/include/asm-arm/ide.h
@@ -18,7 +18,6 @@
 #endif
 
 #if !defined(CONFIG_ARCH_L7200)
-# define IDE_ARCH_OBSOLETE_INIT
 # ifdef CONFIG_ARCH_CLPS7500
 #  define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
 # else
diff --git a/include/asm-blackfin/ide.h b/include/asm-blackfin/ide.h
index 41b2db4..121e272 100644
--- a/include/asm-blackfin/ide.h
+++ b/include/asm-blackfin/ide.h
@@ -20,7 +20,6 @@
 #define MAX_HWIFS	1
 
 /* Legacy ... BLK_DEV_IDECS */
-#define IDE_ARCH_OBSOLETE_INIT
 #define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
 
 
diff --git a/include/asm-cris/arch-v32/ide.h b/include/asm-cris/arch-v32/ide.h
index 6590f65..1129617 100644
--- a/include/asm-cris/arch-v32/ide.h
+++ b/include/asm-cris/arch-v32/ide.h
@@ -54,7 +54,7 @@ static inline unsigned long ide_default_io_base(int index)
 #define SUPPORT_VLB_SYNC 0
 
 #define IDE_ARCH_ACK_INTR
-#define ide_ack_intr(hwif)	(hwif)->hw.ack_intr(hwif)
+#define ide_ack_intr(hwif)	((hwif)->ack_intr(hwif))
 
 #endif /* __KERNEL__ */
 
diff --git a/include/asm-ia64/ide.h b/include/asm-ia64/ide.h
index e928675..1ccf238 100644
--- a/include/asm-ia64/ide.h
+++ b/include/asm-ia64/ide.h
@@ -46,7 +46,6 @@ static inline unsigned long ide_default_io_base(int index)
 	}
 }
 
-#define IDE_ARCH_OBSOLETE_INIT
 #define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
 
 #ifdef CONFIG_PCI
diff --git a/include/asm-m32r/ide.h b/include/asm-m32r/ide.h
index 4672a49..5d2044e 100644
--- a/include/asm-m32r/ide.h
+++ b/include/asm-m32r/ide.h
@@ -65,7 +65,6 @@ static __inline__ unsigned long ide_default_io_base(int index)
 	}
 }
 
-#define IDE_ARCH_OBSOLETE_INIT
 #define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
 
 #ifdef CONFIG_BLK_DEV_IDEPCI
diff --git a/include/asm-m68k/ide.h b/include/asm-m68k/ide.h
index f9ffb2c..909c6df 100644
--- a/include/asm-m68k/ide.h
+++ b/include/asm-m68k/ide.h
@@ -137,7 +137,7 @@ ide_get_lock(irq_handler_t handler, void *data)
 #endif /* CONFIG_BLK_DEV_FALCON_IDE */
 
 #define IDE_ARCH_ACK_INTR
-#define ide_ack_intr(hwif)	((hwif)->hw.ack_intr ? (hwif)->hw.ack_intr(hwif) : 1)
+#define ide_ack_intr(hwif)	((hwif)->ack_intr ? (hwif)->ack_intr(hwif) : 1)
 
 #endif /* __KERNEL__ */
 #endif /* _M68K_IDE_H */
diff --git a/include/asm-mips/mach-generic/ide.h b/include/asm-mips/mach-generic/ide.h
index a771283..4ec2b93 100644
--- a/include/asm-mips/mach-generic/ide.h
+++ b/include/asm-mips/mach-generic/ide.h
@@ -98,7 +98,6 @@ static __inline__ unsigned long ide_default_io_base(int index)
 	}
 }
 
-#define IDE_ARCH_OBSOLETE_INIT
 #define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
 
 #ifdef CONFIG_BLK_DEV_IDEPCI
diff --git a/include/asm-parisc/ide.h b/include/asm-parisc/ide.h
index b27bf7a..be8760f 100644
--- a/include/asm-parisc/ide.h
+++ b/include/asm-parisc/ide.h
@@ -17,7 +17,6 @@
 #define MAX_HWIFS	2
 #endif
 
-#define IDE_ARCH_OBSOLETE_INIT
 #define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
 
 #define ide_request_irq(irq,hand,flg,dev,id)	request_irq((irq),(hand),(flg),(dev),(id))
diff --git a/include/asm-powerpc/ide.h b/include/asm-powerpc/ide.h
index 1644e44..fd7f5a4 100644
--- a/include/asm-powerpc/ide.h
+++ b/include/asm-powerpc/ide.h
@@ -69,12 +69,11 @@ static __inline__ unsigned long ide_default_io_base(int index)
 
 #ifdef CONFIG_BLK_DEV_MPC8xx_IDE
 #define IDE_ARCH_ACK_INTR  1
-#define ide_ack_intr(hwif) (hwif->hw.ack_intr ? hwif->hw.ack_intr(hwif) : 1)
+#define ide_ack_intr(hwif) ((hwif)->ack_intr ? (hwif)->ack_intr(hwif) : 1)
 #endif
 
 #endif /* __powerpc64__ */
 
-#define IDE_ARCH_OBSOLETE_INIT
 #define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
 
 #endif /* __KERNEL__ */
diff --git a/include/asm-sh64/ide.h b/include/asm-sh64/ide.h
index c9d84d5..b6e31e8 100644
--- a/include/asm-sh64/ide.h
+++ b/include/asm-sh64/ide.h
@@ -19,7 +19,6 @@
 /* Without this, the initialisation of PCI IDE cards end up calling
  * ide_init_hwif_ports, which won't work. */
 #ifdef CONFIG_BLK_DEV_IDEPCI
-#define IDE_ARCH_OBSOLETE_INIT 1
 #define ide_default_io_ctl(base)	(0)
 #endif
 
diff --git a/include/asm-sparc/ide.h b/include/asm-sparc/ide.h
index a6d735a..4040227 100644
--- a/include/asm-sparc/ide.h
+++ b/include/asm-sparc/ide.h
@@ -18,7 +18,6 @@
 #undef  MAX_HWIFS
 #define MAX_HWIFS	2
 
-#define IDE_ARCH_OBSOLETE_INIT
 #define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
 
 #define __ide_insl(data_reg, buffer, wcount) \
diff --git a/include/asm-sparc64/ide.h b/include/asm-sparc64/ide.h
index 55149cf..ac7eb21 100644
--- a/include/asm-sparc64/ide.h
+++ b/include/asm-sparc64/ide.h
@@ -24,7 +24,6 @@
 # endif
 #endif
 
-#define IDE_ARCH_OBSOLETE_INIT
 #define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
 
 #define __ide_insl(data_reg, buffer, wcount) \
diff --git a/include/asm-x86/ide.h b/include/asm-x86/ide.h
index e7817a3..42130ad 100644
--- a/include/asm-x86/ide.h
+++ b/include/asm-x86/ide.h
@@ -62,7 +62,6 @@ static __inline__ unsigned long ide_default_io_base(int index)
 	}
 }
 
-#define IDE_ARCH_OBSOLETE_INIT
 #define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
 
 #ifdef CONFIG_BLK_DEV_IDEPCI
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 19db0a4..2e4b8dd 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -192,22 +192,20 @@ typedef unsigned char	byte;	/* used everywhere */
 struct hwif_s;
 typedef int (ide_ack_intr_t)(struct hwif_s *);
 
-#ifndef NO_DMA
-#define NO_DMA  255
-#endif
-
 /*
  * hwif_chipset_t is used to keep track of the specific hardware
  * chipset used by each IDE interface, if known.
  */
-typedef enum {	ide_unknown,	ide_generic,	ide_pci,
+enum {		ide_unknown,	ide_generic,	ide_pci,
 		ide_cmd640,	ide_dtc2278,	ide_ali14xx,
 		ide_qd65xx,	ide_umc8672,	ide_ht6560b,
 		ide_rz1000,	ide_trm290,
 		ide_cmd646,	ide_cy82c693,	ide_4drives,
 		ide_pmac,	ide_etrax100,	ide_acorn,
 		ide_au1xxx, ide_forced
-} hwif_chipset_t;
+};
+
+typedef u8 hwif_chipset_t;
 
 /*
  * Structure to hold all information about the location of this port
@@ -215,22 +213,16 @@ typedef enum {	ide_unknown,	ide_generic,	ide_pci,
 typedef struct hw_regs_s {
 	unsigned long	io_ports[IDE_NR_PORTS];	/* task file registers */
 	int		irq;			/* our irq number */
-	int		dma;			/* our dma entry */
 	ide_ack_intr_t	*ack_intr;		/* acknowledge interrupt */
 	hwif_chipset_t  chipset;
 	struct device	*dev;
 } hw_regs_t;
 
-/*
- * Register new hardware with ide
- */
-int ide_register_hw(hw_regs_t *, int, struct hwif_s **);
-int ide_register_hw_with_fixup(hw_regs_t *, int, struct hwif_s **,
-			       void (*)(struct hwif_s *));
+struct hwif_s * ide_find_port(unsigned long);
+
+int ide_register_hw(hw_regs_t *, void (*)(struct hwif_s *), int,
+		    struct hwif_s **);
 
-/*
- * Set up hw_regs_t structure before calling ide_register_hw (optional)
- */
 void ide_setup_ports(	hw_regs_t *hw,
 			unsigned long base,
 			int *offsets,
@@ -268,11 +260,7 @@ static inline void ide_std_init_ports(hw_regs_t *hw,
 # define ide_init_default_irq(base)	(0)
 #endif
 
-/*
- * ide_init_hwif_ports() is OBSOLETE and will be removed in 2.7 series.
- * New ports shouldn't define IDE_ARCH_OBSOLETE_INIT in <asm/ide.h>.
- */
-#ifdef IDE_ARCH_OBSOLETE_INIT
+#ifdef CONFIG_IDE_ARCH_OBSOLETE_INIT
 static inline void ide_init_hwif_ports(hw_regs_t *hw,
 				       unsigned long io_addr,
 				       unsigned long ctl_addr,
@@ -302,7 +290,7 @@ static inline void ide_init_hwif_ports(hw_regs_t *hw,
 	if (io_addr || ctl_addr)
 		printk(KERN_WARNING "%s: must not be called\n", __FUNCTION__);
 }
-#endif /* IDE_ARCH_OBSOLETE_INIT */
+#endif /* CONFIG_IDE_ARCH_OBSOLETE_INIT */
 
 /* Currently only m68k, apus and m8xx need it */
 #ifndef IDE_ARCH_ACK_INTR
@@ -363,7 +351,6 @@ typedef union {
  * ATA DATA Register Special.
  * ATA NSECTOR Count Register().
  * ATAPI Byte Count Register.
- * Channel index ordering pairs.
  */
 typedef union {
 	unsigned all			:16;
@@ -378,7 +365,7 @@ typedef union {
 #error "Please fix <asm/byteorder.h>"
 #endif
 	} b;
-} ata_nsector_t, ata_data_t, atapi_bcount_t, ata_index_t;
+} ata_nsector_t, ata_data_t, atapi_bcount_t;
 
 /*
  * ATA-IDE Select Register, aka Device-Head
@@ -657,7 +644,7 @@ typedef struct ide_drive_s {
     ((1<<ide_pci)|(1<<ide_cmd646)|(1<<ide_ali14xx))
 #define IDE_CHIPSET_IS_PCI(c)	((IDE_CHIPSET_PCI_MASK >> (c)) & 1)
 
-struct ide_pci_device_s;
+struct ide_port_info;
 
 typedef struct hwif_s {
 	struct hwif_s *next;		/* for linked-list in ide_hwgroup_t */
@@ -672,7 +659,6 @@ typedef struct hwif_s {
 	unsigned long	sata_scr[SATA_NR_PORTS];
 	unsigned long	sata_misc[SATA_NR_PORTS];
 
-	hw_regs_t	hw;		/* Hardware info */
 	ide_drive_t	drives[MAX_DRIVES];	/* drive info */
 
 	u8 major;	/* our major number */
@@ -694,7 +680,9 @@ typedef struct hwif_s {
 	hwif_chipset_t chipset;	/* sub-module for tuning.. */
 
 	struct pci_dev  *pci_dev;	/* for pci chipsets */
-	struct ide_pci_device_s	*cds;	/* chipset device struct */
+	const struct ide_port_info *cds;	/* chipset device struct */
+
+	ide_ack_intr_t *ack_intr;
 
 	void (*rw_disk)(ide_drive_t *, struct request *);
 
@@ -725,6 +713,8 @@ typedef struct hwif_s {
 	u8 (*mdma_filter)(ide_drive_t *);
 	u8 (*udma_filter)(ide_drive_t *);
 
+	void (*fixup)(struct hwif_s *);
+
 	void (*ata_input_data)(ide_drive_t *, void *, u32);
 	void (*ata_output_data)(ide_drive_t *, void *, u32);
 
@@ -841,8 +831,6 @@ typedef struct hwgroup_s {
 
 		/* for pci chipsets */
 	struct pci_dev *pci_dev;
-		/* chipset device struct */
-	struct ide_pci_device_s *cds;
 
 		/* current request */
 	struct request *rq;
@@ -1030,36 +1018,16 @@ extern int ide_end_request (ide_drive_t *drive, int uptodate, int nrsecs);
 int ide_end_dequeued_request(ide_drive_t *drive, struct request *rq,
 			     int uptodate, int nr_sectors);
 
-/*
- * This is used on exit from the driver to designate the next irq handler
- * and also to start the safety timer.
- */
 extern void ide_set_handler (ide_drive_t *drive, ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry);
 
-/*
- * This is used on exit from the driver to designate the next irq handler
- * and start the safety time safely and atomically from the IRQ handler
- * with respect to the command issue (which it also does)
- */
 extern void ide_execute_command(ide_drive_t *, task_ioreg_t cmd, ide_handler_t *, unsigned int, ide_expiry_t *);
 
 ide_startstop_t __ide_error(ide_drive_t *, struct request *, u8, u8);
 
-/*
- * ide_error() takes action based on the error returned by the controller.
- * The caller should return immediately after invoking this.
- *
- * (drive, msg, status)
- */
 ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, byte stat);
 
 ide_startstop_t __ide_abort(ide_drive_t *, struct request *);
 
-/*
- * Abort a running command on the controller triggering the abort
- * from a host side, non error situation
- * (drive, msg)
- */
 extern ide_startstop_t ide_abort(ide_drive_t *, const char *);
 
 extern void ide_fix_driveid(struct hd_driveid *);
@@ -1075,15 +1043,8 @@ extern void ide_fixstring(u8 *, const int, const int);
 
 int ide_wait_stat(ide_startstop_t *, ide_drive_t *, u8, u8, unsigned long);
 
-/*
- * Start a reset operation for an IDE interface.
- * The caller should return immediately after invoking this.
- */
 extern ide_startstop_t ide_do_reset (ide_drive_t *);
 
-/*
- * This function is intended to be used prior to invoking ide_do_drive_cmd().
- */
 extern void ide_init_drive_cmd (struct request *rq);
 
 /*
@@ -1098,13 +1059,6 @@ typedef enum {
 
 extern int ide_do_drive_cmd(ide_drive_t *, struct request *, ide_action_t);
 
-/*
- * Clean up after success/failure of an explicit drive cmd.
- * stat/err are used only when (HWGROUP(drive)->rq->cmd == IDE_DRIVE_CMD).
- * stat/err are used only when (HWGROUP(drive)->rq->cmd == IDE_DRIVE_TASK_MASK).
- *
- * (ide_drive_t *drive, u8 stat, u8 err)
- */
 extern void ide_end_drive_cmd(ide_drive_t *, u8, u8);
 
 /*
@@ -1177,10 +1131,6 @@ extern int taskfile_lib_get_identify(ide_drive_t *drive, u8 *);
 
 extern int ide_wait_not_busy(ide_hwif_t *hwif, unsigned long timeout);
 
-/*
- * ide_stall_queue() can be used by a drive to give excess bandwidth back
- * to the hwgroup by sleeping for timeout jiffies.
- */
 extern void ide_stall_queue(ide_drive_t *drive, unsigned long timeout);
 
 extern int ide_spin_wait_hwgroup(ide_drive_t *);
@@ -1200,8 +1150,8 @@ extern int __ide_pci_register_driver(struct pci_driver *driver, struct module *o
 #define ide_pci_register_driver(d) pci_register_driver(d)
 #endif
 
-void ide_pci_setup_ports(struct pci_dev *, struct ide_pci_device_s *, int, ata_index_t *);
-extern void ide_setup_pci_noise (struct pci_dev *dev, struct ide_pci_device_s *d);
+void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *, int, u8 *);
+void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 
 extern void default_hwif_iops(ide_hwif_t *);
 extern void default_hwif_mmiops(ide_hwif_t *);
@@ -1261,6 +1211,14 @@ enum {
 	IDE_HFLAG_SERIALIZE		= (1 << 20),
 	/* use legacy IRQs */
 	IDE_HFLAG_LEGACY_IRQS		= (1 << 21),
+	/* force use of legacy IRQs */
+	IDE_HFLAG_FORCE_LEGACY_IRQS	= (1 << 22),
+	/* limit LBA48 requests to 256 sectors */
+	IDE_HFLAG_RQSIZE_256		= (1 << 23),
+	/* use 32-bit I/O ops */
+	IDE_HFLAG_IO_32BIT		= (1 << 24),
+	/* unmask IRQs */
+	IDE_HFLAG_UNMASK_IRQS		= (1 << 25),
 };
 
 #ifdef CONFIG_BLK_DEV_OFFBOARD
@@ -1269,7 +1227,7 @@ enum {
 # define IDE_HFLAG_OFF_BOARD	0
 #endif
 
-typedef struct ide_pci_device_s {
+struct ide_port_info {
 	char			*name;
 	unsigned int		(*init_chipset)(struct pci_dev *, const char *);
 	void			(*init_iops)(ide_hwif_t *);
@@ -1277,17 +1235,17 @@ typedef struct ide_pci_device_s {
 	void			(*init_dma)(ide_hwif_t *, unsigned long);
 	void			(*fixup)(ide_hwif_t *);
 	ide_pci_enablebit_t	enablebits[2];
+	hwif_chipset_t		chipset;
 	unsigned int		extra;
-	struct ide_pci_device_s	*next;
 	u32			host_flags;
 	u8			pio_mask;
 	u8			swdma_mask;
 	u8			mwdma_mask;
 	u8			udma_mask;
-} ide_pci_device_t;
+};
 
-extern int ide_setup_pci_device(struct pci_dev *, ide_pci_device_t *);
-extern int ide_setup_pci_devices(struct pci_dev *, struct pci_dev *, ide_pci_device_t *);
+int ide_setup_pci_device(struct pci_dev *, const struct ide_port_info *);
+int ide_setup_pci_devices(struct pci_dev *, struct pci_dev *, const struct ide_port_info *);
 
 void ide_map_sg(ide_drive_t *, struct request *);
 void ide_init_sg_cmd(ide_drive_t *, struct request *);
@@ -1370,8 +1328,7 @@ void ide_unregister_region(struct gendisk *);
 
 void ide_undecoded_slave(ide_hwif_t *);
 
-int probe_hwif_init_with_fixup(ide_hwif_t *, void (*)(ide_hwif_t *));
-extern int probe_hwif_init(ide_hwif_t *);
+int ide_device_add(u8 idx[4]);
 
 static inline void *ide_get_hwifdata (ide_hwif_t * hwif)
 {
