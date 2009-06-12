Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbZFLMRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbZFLMRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757806AbZFLMRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:17:24 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:48434 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbZFLMRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:17:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=aLJqaSxbs+6CDSscR05k8Wgsf1bM3f6BsXtwgSPCh7YV9AoC5XC9PRVVJEqtQJe8PJ
         a3hLGiOOMdTcaZuaWH0U4ahmKMDoCX6nxsJC4h+E6kP0Pcl1pDacqUEGp+1WsavTmRgx
         Te800bYnWAWIEgudKoBNQ+ZP2kQLTytvvHLGA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates part 2
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 12 Jun 2009 14:01:43 +0200
Message-Id: <200906121401.44345.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

More IDE changes for 2.6.31 merge window:

* Improved Host Protected Area handling [ http://lwn.net/Articles/335913/ ].

* Use PIO Mode 0 during probe if possible -- increases chance of successful
  probe on BIOS/firmware-less systems (Joao Ramos, Hugh Dickins).

* Generalized nIEN quirks handling (some older disks don't handle IRQ
  [un]masking well and we need a special treatment for them).

* pdc202xx_old host driver fixes (Sergei Shtylyov).

* ide-tape fixes (Borislav Petkov).

* Misc fixes/cleanups.


Linus, please pull from 'for-2.6.31' branch of:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git for-2.6.31

to receive the following updates:

 Documentation/ide/ide.txt           |    2 +
 Documentation/kernel-parameters.txt |    7 +--
 drivers/ide/at91_ide.c              |    7 +--
 drivers/ide/au1xxx-ide.c            |    8 ++--
 drivers/ide/buddha.c                |    9 ++--
 drivers/ide/cmd640.c                |    7 +--
 drivers/ide/cs5520.c                |    4 +-
 drivers/ide/delkin_cb.c             |    6 +-
 drivers/ide/falconide.c             |    9 ++--
 drivers/ide/gayle.c                 |    9 ++--
 drivers/ide/hpt366.c                |   25 +---------
 drivers/ide/icside.c                |   77 ++++------------------------
 drivers/ide/ide-4drives.c           |    6 +-
 drivers/ide/ide-atapi.c             |    2 +-
 drivers/ide/ide-cs.c                |    6 +-
 drivers/ide/ide-disk.c              |   75 +++++++++++++++++++++++----
 drivers/ide/ide-dma.c               |    1 -
 drivers/ide/ide-eh.c                |   14 +++---
 drivers/ide/ide-gd.c                |   14 +++++
 drivers/ide/ide-generic.c           |    7 +--
 drivers/ide/ide-h8300.c             |   10 ++--
 drivers/ide/ide-io.c                |   77 +++++++++++++---------------
 drivers/ide/ide-iops.c              |   26 +++++++++-
 drivers/ide/ide-legacy.c            |    7 +--
 drivers/ide/ide-pnp.c               |    6 +-
 drivers/ide/ide-probe.c             |   95 +++++++++++++++++++---------------
 drivers/ide/ide-tape.c              |   90 +++++++++++++++++----------------
 drivers/ide/ide-taskfile.c          |    3 +-
 drivers/ide/ide.c                   |   10 ++++
 drivers/ide/ide_platform.c          |    9 ++--
 drivers/ide/macide.c                |    9 ++--
 drivers/ide/palm_bk3710.c           |    6 +-
 drivers/ide/pdc202xx_new.c          |   26 ----------
 drivers/ide/pdc202xx_old.c          |   92 +--------------------------------
 drivers/ide/pmac.c                  |   13 +++--
 drivers/ide/q40ide.c                |   11 ++--
 drivers/ide/rapide.c                |    8 ++--
 drivers/ide/scc_pata.c              |    6 +-
 drivers/ide/setup-pci.c             |   85 ++++++++-----------------------
 drivers/ide/sgiioc4.c               |    7 +--
 drivers/ide/siimage.c               |    4 +-
 drivers/ide/sl82c105.c              |    9 ++--
 drivers/ide/tx4938ide.c             |    5 +-
 drivers/ide/tx4939ide.c             |    5 +-
 fs/partitions/check.c               |   42 ++++++++++++----
 include/linux/blkdev.h              |    2 +
 include/linux/genhd.h               |    1 +
 include/linux/ide.h                 |   46 +++++++----------
 48 files changed, 442 insertions(+), 563 deletions(-)


Bartlomiej Zolnierkiewicz (23):
      ide: BUG() on unknown flags in ide_disk_special()
      ide: merge ide_disk_special() into do_special() (v2)
      ide: replace special_t typedef by IDE_SFLAG_* flags
      ide: remove chipset field from hw_regs_t
      ide: pass number of ports to ide_host_{alloc,add}() (v2)
      ide: remove hw_regs_t typedef
      Merge branch 'for-linus' into for-next
      partitions: warn about the partition exceeding device capacity
      partitions: add ->set_capacity block device method
      ide-gd: implement block device ->set_capacity method (v2)
      ide: preserve Host Protected Area by default (v2)
      Merge branch 'for-linus' into for-next
      icside: remove superfluous ->maskproc method
      ide: remove superfluous SELECT_MASK() call from ide_driveid_update()
      ide: remove superfluous SELECT_MASK() call from do_rw_taskfile()
      hpt366: sync quirk_drives[] list with pdc202xx_{new,old}.c
      hpt366: enable all quirks for devices on quirk_drives[] list
      ide: respect quirk_drives[] list on all controllers
      ide: add IDE_DFLAG_NIEN_QUIRK device flag
      ide: skip probe if there are no devices on the port (v2)
      ide: unexport ide_find_dma_mode()
      ide: re-implement ide_pci_init_one() on top of ide_pci_init_two()
      Merge branch 'for-2.6.31' into 2.6.31

Borislav Petkov (3):
      ide-tape: change IDE_AFLAG_IGNORE_DSC non-atomically
      ide-tape: fix IDE_AFLAG_* atomic accesses
      ide-tape: fix proc warning

Hugh Dickins (1):
      ide: fix PowerMac bootup oops

Joao Ramos (1):
      ide: try to use PIO Mode 0 during probe if possible

Sergei Shtylyov (4):
      pdc202xx_old: use ide_dma_test_irq()
      pdc202xx_old: don't call pdc202xx_reset() on IRQ timeout
      pdc202xx_old: kill resetproc() method
      sl82c105: add printk() logging facility


diff --git a/Documentation/ide/ide.txt b/Documentation/ide/ide.txt
index 0c78f4b..e77bebf 100644
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -216,6 +216,8 @@ Other kernel parameters for ide_core are:
 
 * "noflush=[interface_number.device_number]" to disable flush requests
 
+* "nohpa=[interface_number.device_number]" to disable Host Protected Area
+
 * "noprobe=[interface_number.device_number]" to skip probing
 
 * "nowerr=[interface_number.device_number]" to ignore the WRERR_STAT bit
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7bcdebf..0bf8a88 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -887,11 +887,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	ide-core.nodma=	[HW] (E)IDE subsystem
 			Format: =0.0 to prevent dma on hda, =0.1 hdb =1.0 hdc
-			.vlb_clock .pci_clock .noflush .noprobe .nowerr .cdrom
-			.chs .ignore_cable are additional options
-			See Documentation/ide/ide.txt.
-
-	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
+			.vlb_clock .pci_clock .noflush .nohpa .noprobe .nowerr
+			.cdrom .chs .ignore_cable are additional options
 			See Documentation/ide/ide.txt.
 
 	ide-pci-generic.all-generic-ide [HW] (E)IDE subsystem
diff --git a/drivers/ide/at91_ide.c b/drivers/ide/at91_ide.c
index 403d0e4..fc0949a 100644
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -216,6 +216,7 @@ static const struct ide_port_info at91_ide_port_info __initdata = {
 	.host_flags 	= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA | IDE_HFLAG_SINGLE |
 			  IDE_HFLAG_NO_IO_32BIT | IDE_HFLAG_UNMASK_IRQS,
 	.pio_mask 	= ATA_PIO6,
+	.chipset	= ide_generic,
 };
 
 /*
@@ -246,8 +247,7 @@ irqreturn_t at91_irq_handler(int irq, void *dev_id)
 static int __init at91_ide_probe(struct platform_device *pdev)
 {
 	int ret;
-	hw_regs_t hw;
-	hw_regs_t *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 	struct ide_host *host;
 	struct resource *res;
 	unsigned long tf_base = 0, ctl_base = 0;
@@ -304,10 +304,9 @@ static int __init at91_ide_probe(struct platform_device *pdev)
 		ide_std_init_ports(&hw, tf_base, ctl_base + 6);
 
 	hw.irq = board->irq_pin;
-	hw.chipset = ide_generic;
 	hw.dev = &pdev->dev;
 
-	host = ide_host_alloc(&at91_ide_port_info, hws);
+	host = ide_host_alloc(&at91_ide_port_info, hws, 1);
 	if (!host) {
 		perr("failed to allocate ide host\n");
 		return -ENOMEM;
diff --git a/drivers/ide/au1xxx-ide.c b/drivers/ide/au1xxx-ide.c
index 4601364..58121bd 100644
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -449,7 +449,7 @@ static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 }
 #endif
 
-static void auide_setup_ports(hw_regs_t *hw, _auide_hwif *ahwif)
+static void auide_setup_ports(struct ide_hw *hw, _auide_hwif *ahwif)
 {
 	int i;
 	unsigned long *ata_regs = hw->io_ports_array;
@@ -499,6 +499,7 @@ static const struct ide_port_info au1xxx_port_info = {
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 	.mwdma_mask		= ATA_MWDMA2,
 #endif
+	.chipset		= ide_au1xxx,
 };
 
 static int au_ide_probe(struct platform_device *dev)
@@ -507,7 +508,7 @@ static int au_ide_probe(struct platform_device *dev)
 	struct resource *res;
 	struct ide_host *host;
 	int ret = 0;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA)
 	char *mode = "MWDMA2";
@@ -548,9 +549,8 @@ static int au_ide_probe(struct platform_device *dev)
 	auide_setup_ports(&hw, ahwif);
 	hw.irq = ahwif->irq;
 	hw.dev = &dev->dev;
-	hw.chipset = ide_au1xxx;
 
-	ret = ide_host_add(&au1xxx_port_info, hws, &host);
+	ret = ide_host_add(&au1xxx_port_info, hws, 1, &host);
 	if (ret)
 		goto out;
 
diff --git a/drivers/ide/buddha.c b/drivers/ide/buddha.c
index d028f88..e3c6a59 100644
--- a/drivers/ide/buddha.c
+++ b/drivers/ide/buddha.c
@@ -121,7 +121,7 @@ static int xsurf_ack_intr(ide_hwif_t *hwif)
     return 1;
 }
 
-static void __init buddha_setup_ports(hw_regs_t *hw, unsigned long base,
+static void __init buddha_setup_ports(struct ide_hw *hw, unsigned long base,
 				      unsigned long ctl, unsigned long irq_port,
 				      ide_ack_intr_t *ack_intr)
 {
@@ -139,13 +139,12 @@ static void __init buddha_setup_ports(hw_regs_t *hw, unsigned long base,
 
 	hw->irq = IRQ_AMIGA_PORTS;
 	hw->ack_intr = ack_intr;
-
-	hw->chipset = ide_generic;
 }
 
 static const struct ide_port_info buddha_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
+	.chipset		= ide_generic,
 };
 
     /*
@@ -161,7 +160,7 @@ static int __init buddha_init(void)
 
 	while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
 		unsigned long board;
-		hw_regs_t hw[MAX_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
+		struct ide_hw hw[MAX_NUM_HWIFS], *hws[MAX_NUM_HWIFS];
 
 		if (z->id == ZORRO_PROD_INDIVIDUAL_COMPUTERS_BUDDHA) {
 			buddha_num_hwifs = BUDDHA_NUM_HWIFS;
@@ -225,7 +224,7 @@ fail_base2:
 			hws[i] = &hw[i];
 		}
 
-		ide_host_add(&buddha_port_info, hws, NULL);
+		ide_host_add(&buddha_port_info, hws, i, NULL);
 	}
 
 	return 0;
diff --git a/drivers/ide/cmd640.c b/drivers/ide/cmd640.c
index 8890276..1683ed5 100644
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -708,7 +708,7 @@ static int __init cmd640x_init(void)
 	int second_port_cmd640 = 0, rc;
 	const char *bus_type, *port2;
 	u8 b, cfr;
-	hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
+	struct ide_hw hw[2], *hws[2];
 
 	if (cmd640_vlb && probe_for_cmd640_vlb()) {
 		bus_type = "VLB";
@@ -762,11 +762,9 @@ static int __init cmd640x_init(void)
 
 	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
 	hw[0].irq = 14;
-	hw[0].chipset = ide_cmd640;
 
 	ide_std_init_ports(&hw[1], 0x170, 0x376);
 	hw[1].irq = 15;
-	hw[1].chipset = ide_cmd640;
 
 	printk(KERN_INFO "cmd640: buggy cmd640%c interface on %s, config=0x%02x"
 			 "\n", 'a' + cmd640_chip_version - 1, bus_type, cfr);
@@ -824,7 +822,8 @@ static int __init cmd640x_init(void)
 	cmd640_dump_regs();
 #endif
 
-	return ide_host_add(&cmd640_port_info, hws, NULL);
+	return ide_host_add(&cmd640_port_info, hws, second_port_cmd640 ? 2 : 1,
+			    NULL);
 }
 
 module_param_named(probe_vlb, cmd640_vlb, bool, 0);
diff --git a/drivers/ide/cs5520.c b/drivers/ide/cs5520.c
index 87987a7..bd066bb 100644
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -110,7 +110,7 @@ static const struct ide_port_info cyrix_chipset __devinitdata = {
 static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	const struct ide_port_info *d = &cyrix_chipset;
-	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
+	struct ide_hw hw[2], *hws[] = { NULL, NULL };
 
 	ide_setup_pci_noise(dev, d);
 
@@ -136,7 +136,7 @@ static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_devic
 	ide_pci_setup_ports(dev, d, &hw[0], &hws[0]);
 	hw[0].irq = 14;
 
-	return ide_host_add(d, hws, NULL);
+	return ide_host_add(d, hws, 2, NULL);
 }
 
 static const struct pci_device_id cs5520_pci_tbl[] = {
diff --git a/drivers/ide/delkin_cb.c b/drivers/ide/delkin_cb.c
index f153b95..1e10eba 100644
--- a/drivers/ide/delkin_cb.c
+++ b/drivers/ide/delkin_cb.c
@@ -68,6 +68,7 @@ static const struct ide_port_info delkin_cb_port_info = {
 				  IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
 	.init_chipset		= delkin_cb_init_chipset,
+	.chipset		= ide_pci,
 };
 
 static int __devinit
@@ -76,7 +77,7 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 	struct ide_host *host;
 	unsigned long base;
 	int rc;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 
 	rc = pci_enable_device(dev);
 	if (rc) {
@@ -97,9 +98,8 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 	ide_std_init_ports(&hw, base + 0x10, base + 0x1e);
 	hw.irq = dev->irq;
 	hw.dev = &dev->dev;
-	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
-	rc = ide_host_add(&delkin_cb_port_info, hws, &host);
+	rc = ide_host_add(&delkin_cb_port_info, hws, 1, &host);
 	if (rc)
 		goto out_disable;
 
diff --git a/drivers/ide/falconide.c b/drivers/ide/falconide.c
index 0e2df67..22fa273 100644
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -111,9 +111,10 @@ static const struct ide_port_info falconide_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
+	.chipset		= ide_generic,
 };
 
-static void __init falconide_setup_ports(hw_regs_t *hw)
+static void __init falconide_setup_ports(struct ide_hw *hw)
 {
 	int i;
 
@@ -128,8 +129,6 @@ static void __init falconide_setup_ports(hw_regs_t *hw)
 
 	hw->irq = IRQ_MFP_IDE;
 	hw->ack_intr = NULL;
-
-	hw->chipset = ide_generic;
 }
 
     /*
@@ -139,7 +138,7 @@ static void __init falconide_setup_ports(hw_regs_t *hw)
 static int __init falconide_init(void)
 {
 	struct ide_host *host;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 	int rc;
 
 	if (!MACH_IS_ATARI || !ATARIHW_PRESENT(IDE))
@@ -154,7 +153,7 @@ static int __init falconide_init(void)
 
 	falconide_setup_ports(&hw);
 
-	host = ide_host_alloc(&falconide_port_info, hws);
+	host = ide_host_alloc(&falconide_port_info, hws, 1);
 	if (host == NULL) {
 		rc = -ENOMEM;
 		goto err;
diff --git a/drivers/ide/gayle.c b/drivers/ide/gayle.c
index c711951..4451a6a 100644
--- a/drivers/ide/gayle.c
+++ b/drivers/ide/gayle.c
@@ -88,7 +88,7 @@ static int gayle_ack_intr_a1200(ide_hwif_t *hwif)
     return 1;
 }
 
-static void __init gayle_setup_ports(hw_regs_t *hw, unsigned long base,
+static void __init gayle_setup_ports(struct ide_hw *hw, unsigned long base,
 				     unsigned long ctl, unsigned long irq_port,
 				     ide_ack_intr_t *ack_intr)
 {
@@ -106,14 +106,13 @@ static void __init gayle_setup_ports(hw_regs_t *hw, unsigned long base,
 
 	hw->irq = IRQ_AMIGA_PORTS;
 	hw->ack_intr = ack_intr;
-
-	hw->chipset = ide_generic;
 }
 
 static const struct ide_port_info gayle_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
+	.chipset		= ide_generic,
 };
 
     /*
@@ -126,7 +125,7 @@ static int __init gayle_init(void)
     unsigned long base, ctrlport, irqport;
     ide_ack_intr_t *ack_intr;
     int a4000, i, rc;
-    hw_regs_t hw[GAYLE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
+    struct ide_hw hw[GAYLE_NUM_HWIFS], *hws[GAYLE_NUM_HWIFS];
 
     if (!MACH_IS_AMIGA)
 	return -ENODEV;
@@ -171,7 +170,7 @@ found:
 	hws[i] = &hw[i];
     }
 
-    rc = ide_host_add(&gayle_port_info, hws, NULL);
+    rc = ide_host_add(&gayle_port_info, hws, i, NULL);
     if (rc)
 	release_mem_region(res_start, res_n);
 
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index 0feb66c..7ce68ef 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -138,14 +138,6 @@
 #undef	HPT_RESET_STATE_ENGINE
 #undef	HPT_DELAY_INTERRUPT
 
-static const char *quirk_drives[] = {
-	"QUANTUM FIREBALLlct08 08",
-	"QUANTUM FIREBALLP KA6.4",
-	"QUANTUM FIREBALLP LM20.4",
-	"QUANTUM FIREBALLP LM20.5",
-	NULL
-};
-
 static const char *bad_ata100_5[] = {
 	"IBM-DTLA-307075",
 	"IBM-DTLA-307060",
@@ -729,27 +721,13 @@ static void hpt3xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	hpt3xx_set_mode(drive, XFER_PIO_0 + pio);
 }
 
-static void hpt3xx_quirkproc(ide_drive_t *drive)
-{
-	char *m			= (char *)&drive->id[ATA_ID_PROD];
-	const  char **list	= quirk_drives;
-
-	while (*list)
-		if (strstr(m, *list++)) {
-			drive->quirk_list = 1;
-			return;
-		}
-
-	drive->quirk_list = 0;
-}
-
 static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 {
 	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 
-	if (drive->quirk_list == 0)
+	if ((drive->dev_flags & IDE_DFLAG_NIEN_QUIRK) == 0)
 		return;
 
 	if (info->chip_type >= HPT370) {
@@ -1404,7 +1382,6 @@ static int __devinit hpt36x_init(struct pci_dev *dev, struct pci_dev *dev2)
 static const struct ide_port_ops hpt3xx_port_ops = {
 	.set_pio_mode		= hpt3xx_set_pio_mode,
 	.set_dma_mode		= hpt3xx_set_mode,
-	.quirkproc		= hpt3xx_quirkproc,
 	.maskproc		= hpt3xx_maskproc,
 	.mdma_filter		= hpt3xx_mdma_filter,
 	.udma_filter		= hpt3xx_udma_filter,
diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
index 36da913..5af3d0f 100644
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -65,8 +65,6 @@ static struct cardinfo icside_cardinfo_v6_2 = {
 };
 
 struct icside_state {
-	unsigned int channel;
-	unsigned int enabled;
 	void __iomem *irq_port;
 	void __iomem *ioc_base;
 	unsigned int sel;
@@ -116,18 +114,11 @@ static void icside_irqenable_arcin_v6 (struct expansion_card *ec, int irqnr)
 	struct icside_state *state = ec->irq_data;
 	void __iomem *base = state->irq_port;
 
-	state->enabled = 1;
+	writeb(0, base + ICS_ARCIN_V6_INTROFFSET_1);
+	readb(base + ICS_ARCIN_V6_INTROFFSET_2);
 
-	switch (state->channel) {
-	case 0:
-		writeb(0, base + ICS_ARCIN_V6_INTROFFSET_1);
-		readb(base + ICS_ARCIN_V6_INTROFFSET_2);
-		break;
-	case 1:
-		writeb(0, base + ICS_ARCIN_V6_INTROFFSET_2);
-		readb(base + ICS_ARCIN_V6_INTROFFSET_1);
-		break;
-	}
+	writeb(0, base + ICS_ARCIN_V6_INTROFFSET_2);
+	readb(base + ICS_ARCIN_V6_INTROFFSET_1);
 }
 
 /* Prototype: icside_irqdisable_arcin_v6 (struct expansion_card *ec, int irqnr)
@@ -137,8 +128,6 @@ static void icside_irqdisable_arcin_v6 (struct expansion_card *ec, int irqnr)
 {
 	struct icside_state *state = ec->irq_data;
 
-	state->enabled = 0;
-
 	readb(state->irq_port + ICS_ARCIN_V6_INTROFFSET_1);
 	readb(state->irq_port + ICS_ARCIN_V6_INTROFFSET_2);
 }
@@ -160,44 +149,6 @@ static const expansioncard_ops_t icside_ops_arcin_v6 = {
 	.irqpending	= icside_irqpending_arcin_v6,
 };
 
-/*
- * Handle routing of interrupts.  This is called before
- * we write the command to the drive.
- */
-static void icside_maskproc(ide_drive_t *drive, int mask)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct expansion_card *ec = ECARD_DEV(hwif->dev);
-	struct icside_state *state = ecard_get_drvdata(ec);
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	state->channel = hwif->channel;
-
-	if (state->enabled && !mask) {
-		switch (hwif->channel) {
-		case 0:
-			writeb(0, state->irq_port + ICS_ARCIN_V6_INTROFFSET_1);
-			readb(state->irq_port + ICS_ARCIN_V6_INTROFFSET_2);
-			break;
-		case 1:
-			writeb(0, state->irq_port + ICS_ARCIN_V6_INTROFFSET_2);
-			readb(state->irq_port + ICS_ARCIN_V6_INTROFFSET_1);
-			break;
-		}
-	} else {
-		readb(state->irq_port + ICS_ARCIN_V6_INTROFFSET_2);
-		readb(state->irq_port + ICS_ARCIN_V6_INTROFFSET_1);
-	}
-
-	local_irq_restore(flags);
-}
-
-static const struct ide_port_ops icside_v6_no_dma_port_ops = {
-	.maskproc		= icside_maskproc,
-};
-
 #ifdef CONFIG_BLK_DEV_IDEDMA_ICS
 /*
  * SG-DMA support.
@@ -275,7 +226,6 @@ static void icside_set_dma_mode(ide_drive_t *drive, const u8 xfer_mode)
 
 static const struct ide_port_ops icside_v6_port_ops = {
 	.set_dma_mode		= icside_set_dma_mode,
-	.maskproc		= icside_maskproc,
 };
 
 static void icside_dma_host_set(ide_drive_t *drive, int on)
@@ -320,11 +270,6 @@ static int icside_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 	BUG_ON(dma_channel_active(ec->dma));
 
 	/*
-	 * Ensure that we have the right interrupt routed.
-	 */
-	icside_maskproc(drive, 0);
-
-	/*
 	 * Route the DMA signals to the correct interface.
 	 */
 	writeb(state->sel | hwif->channel, state->ioc_base);
@@ -381,7 +326,7 @@ static int icside_dma_off_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 	return -EOPNOTSUPP;
 }
 
-static void icside_setup_ports(hw_regs_t *hw, void __iomem *base,
+static void icside_setup_ports(struct ide_hw *hw, void __iomem *base,
 			       struct cardinfo *info, struct expansion_card *ec)
 {
 	unsigned long port = (unsigned long)base + info->dataoffset;
@@ -398,11 +343,11 @@ static void icside_setup_ports(hw_regs_t *hw, void __iomem *base,
 
 	hw->irq = ec->irq;
 	hw->dev = &ec->dev;
-	hw->chipset = ide_acorn;
 }
 
 static const struct ide_port_info icside_v5_port_info = {
 	.host_flags		= IDE_HFLAG_NO_DMA,
+	.chipset		= ide_acorn,
 };
 
 static int __devinit
@@ -410,7 +355,7 @@ icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 {
 	void __iomem *base;
 	struct ide_host *host;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 	int ret;
 
 	base = ecardm_iomap(ec, ECARD_RES_MEMC, 0, 0);
@@ -431,7 +376,7 @@ icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 
 	icside_setup_ports(&hw, base, &icside_cardinfo_v5, ec);
 
-	host = ide_host_alloc(&icside_v5_port_info, hws);
+	host = ide_host_alloc(&icside_v5_port_info, hws, 1);
 	if (host == NULL)
 		return -ENODEV;
 
@@ -452,11 +397,11 @@ err_free:
 
 static const struct ide_port_info icside_v6_port_info __initdata = {
 	.init_dma		= icside_dma_off_init,
-	.port_ops		= &icside_v6_no_dma_port_ops,
 	.dma_ops		= &icside_v6_dma_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_MMIO,
 	.mwdma_mask		= ATA_MWDMA2,
 	.swdma_mask		= ATA_SWDMA2,
+	.chipset		= ide_acorn,
 };
 
 static int __devinit
@@ -466,7 +411,7 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 	struct ide_host *host;
 	unsigned int sel = 0;
 	int ret;
-	hw_regs_t hw[2], *hws[] = { &hw[0], &hw[1], NULL, NULL };
+	struct ide_hw hw[2], *hws[] = { &hw[0], &hw[1] };
 	struct ide_port_info d = icside_v6_port_info;
 
 	ioc_base = ecardm_iomap(ec, ECARD_RES_IOCFAST, 0, 0);
@@ -506,7 +451,7 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 	icside_setup_ports(&hw[0], easi_base, &icside_cardinfo_v6_1, ec);
 	icside_setup_ports(&hw[1], easi_base, &icside_cardinfo_v6_2, ec);
 
-	host = ide_host_alloc(&d, hws);
+	host = ide_host_alloc(&d, hws, 2);
 	if (host == NULL)
 		return -ENODEV;
 
diff --git a/drivers/ide/ide-4drives.c b/drivers/ide/ide-4drives.c
index 78aca75..979d342 100644
--- a/drivers/ide/ide-4drives.c
+++ b/drivers/ide/ide-4drives.c
@@ -25,12 +25,13 @@ static const struct ide_port_info ide_4drives_port_info = {
 	.port_ops		= &ide_4drives_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_NO_DMA |
 				  IDE_HFLAG_4DRIVES,
+	.chipset		= ide_4drives,
 };
 
 static int __init ide_4drives_init(void)
 {
 	unsigned long base = 0x1f0, ctl = 0x3f6;
-	hw_regs_t hw, *hws[] = { &hw, &hw, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw, &hw };
 
 	if (probe_4drives == 0)
 		return -ENODEV;
@@ -52,9 +53,8 @@ static int __init ide_4drives_init(void)
 
 	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = 14;
-	hw.chipset = ide_4drives;
 
-	return ide_host_add(&ide_4drives_port_info, hws, NULL);
+	return ide_host_add(&ide_4drives_port_info, hws, 2, NULL);
 }
 
 module_init(ide_4drives_init);
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 757e595..bbdd254 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -259,7 +259,7 @@ void ide_retry_pc(ide_drive_t *drive)
 	pc->req_xfer = blk_rq_bytes(sense_rq);
 
 	if (drive->media == ide_tape)
-		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
+		drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
 
 	/*
 	 * Push back the failed request and put request sense on top
diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
index 9e47f35..527908f 100644
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -155,6 +155,7 @@ static const struct ide_port_info idecs_port_info = {
 	.port_ops		= &idecs_port_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
+	.chipset		= ide_pci,
 };
 
 static struct ide_host *idecs_register(unsigned long io, unsigned long ctl,
@@ -163,7 +164,7 @@ static struct ide_host *idecs_register(unsigned long io, unsigned long ctl,
     struct ide_host *host;
     ide_hwif_t *hwif;
     int i, rc;
-    hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+    struct ide_hw hw, *hws[] = { &hw };
 
     if (!request_region(io, 8, DRV_NAME)) {
 	printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
@@ -181,10 +182,9 @@ static struct ide_host *idecs_register(unsigned long io, unsigned long ctl,
     memset(&hw, 0, sizeof(hw));
     ide_std_init_ports(&hw, io, ctl);
     hw.irq = irq;
-    hw.chipset = ide_pci;
     hw.dev = &handle->dev;
 
-    rc = ide_host_add(&idecs_port_info, hws, &host);
+    rc = ide_host_add(&idecs_port_info, hws, 1, &host);
     if (rc)
 	goto out_release;
 
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index c6f7fcf..6a1de21 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -302,14 +302,12 @@ static const struct drive_list_entry hpa_list[] = {
 	{ NULL,		NULL }
 };
 
-static void idedisk_check_hpa(ide_drive_t *drive)
+static u64 ide_disk_hpa_get_native_capacity(ide_drive_t *drive, int lba48)
 {
-	unsigned long long capacity, set_max;
-	int lba48 = ata_id_lba48_enabled(drive->id);
+	u64 capacity, set_max;
 
 	capacity = drive->capacity64;
-
-	set_max = idedisk_read_native_max_address(drive, lba48);
+	set_max  = idedisk_read_native_max_address(drive, lba48);
 
 	if (ide_in_drive_list(drive->id, hpa_list)) {
 		/*
@@ -320,9 +318,31 @@ static void idedisk_check_hpa(ide_drive_t *drive)
 			set_max--;
 	}
 
+	return set_max;
+}
+
+static u64 ide_disk_hpa_set_capacity(ide_drive_t *drive, u64 set_max, int lba48)
+{
+	set_max = idedisk_set_max_address(drive, set_max, lba48);
+	if (set_max)
+		drive->capacity64 = set_max;
+
+	return set_max;
+}
+
+static void idedisk_check_hpa(ide_drive_t *drive)
+{
+	u64 capacity, set_max;
+	int lba48 = ata_id_lba48_enabled(drive->id);
+
+	capacity = drive->capacity64;
+	set_max  = ide_disk_hpa_get_native_capacity(drive, lba48);
+
 	if (set_max <= capacity)
 		return;
 
+	drive->probed_capacity = set_max;
+
 	printk(KERN_INFO "%s: Host Protected Area detected.\n"
 			 "\tcurrent capacity is %llu sectors (%llu MB)\n"
 			 "\tnative  capacity is %llu sectors (%llu MB)\n",
@@ -330,13 +350,13 @@ static void idedisk_check_hpa(ide_drive_t *drive)
 			 capacity, sectors_to_MB(capacity),
 			 set_max, sectors_to_MB(set_max));
 
-	set_max = idedisk_set_max_address(drive, set_max, lba48);
+	if ((drive->dev_flags & IDE_DFLAG_NOHPA) == 0)
+		return;
 
-	if (set_max) {
-		drive->capacity64 = set_max;
+	set_max = ide_disk_hpa_set_capacity(drive, set_max, lba48);
+	if (set_max)
 		printk(KERN_INFO "%s: Host Protected Area disabled.\n",
 				 drive->name);
-	}
 }
 
 static int ide_disk_get_capacity(ide_drive_t *drive)
@@ -358,6 +378,8 @@ static int ide_disk_get_capacity(ide_drive_t *drive)
 		drive->capacity64 = drive->cyl * drive->head * drive->sect;
 	}
 
+	drive->probed_capacity = drive->capacity64;
+
 	if (lba) {
 		drive->dev_flags |= IDE_DFLAG_LBA;
 
@@ -376,7 +398,7 @@ static int ide_disk_get_capacity(ide_drive_t *drive)
 		       "%llu sectors (%llu MB)\n",
 		       drive->name, (unsigned long long)drive->capacity64,
 		       sectors_to_MB(drive->capacity64));
-		drive->capacity64 = 1ULL << 28;
+		drive->probed_capacity = drive->capacity64 = 1ULL << 28;
 	}
 
 	if ((drive->hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) &&
@@ -392,6 +414,34 @@ static int ide_disk_get_capacity(ide_drive_t *drive)
 	return 0;
 }
 
+static u64 ide_disk_set_capacity(ide_drive_t *drive, u64 capacity)
+{
+	u64 set = min(capacity, drive->probed_capacity);
+	u16 *id = drive->id;
+	int lba48 = ata_id_lba48_enabled(id);
+
+	if ((drive->dev_flags & IDE_DFLAG_LBA) == 0 ||
+	    ata_id_hpa_enabled(id) == 0)
+		goto out;
+
+	/*
+	 * according to the spec the SET MAX ADDRESS command shall be
+	 * immediately preceded by a READ NATIVE MAX ADDRESS command
+	 */
+	capacity = ide_disk_hpa_get_native_capacity(drive, lba48);
+	if (capacity == 0)
+		goto out;
+
+	set = ide_disk_hpa_set_capacity(drive, set, lba48);
+	if (set) {
+		/* needed for ->resume to disable HPA */
+		drive->dev_flags |= IDE_DFLAG_NOHPA;
+		return set;
+	}
+out:
+	return drive->capacity64;
+}
+
 static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 {
 	ide_drive_t *drive = q->queuedata;
@@ -428,14 +478,14 @@ static int set_multcount(ide_drive_t *drive, int arg)
 	if (arg < 0 || arg > (drive->id[ATA_ID_MAX_MULTSECT] & 0xff))
 		return -EINVAL;
 
-	if (drive->special.b.set_multmode)
+	if (drive->special_flags & IDE_SFLAG_SET_MULTMODE)
 		return -EBUSY;
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 
 	drive->mult_req = arg;
-	drive->special.b.set_multmode = 1;
+	drive->special_flags |= IDE_SFLAG_SET_MULTMODE;
 	error = blk_execute_rq(drive->queue, NULL, rq, 0);
 	blk_put_request(rq);
 
@@ -740,6 +790,7 @@ static int ide_disk_set_doorlock(ide_drive_t *drive, struct gendisk *disk,
 
 const struct ide_disk_ops ide_ata_disk_ops = {
 	.check		= ide_disk_check,
+	.set_capacity	= ide_disk_set_capacity,
 	.get_capacity	= ide_disk_get_capacity,
 	.setup		= ide_disk_setup,
 	.flush		= ide_disk_flush,
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 001f68f..219e6fb 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -347,7 +347,6 @@ u8 ide_find_dma_mode(ide_drive_t *drive, u8 req_mode)
 
 	return mode;
 }
-EXPORT_SYMBOL_GPL(ide_find_dma_mode);
 
 static int ide_tune_dma(ide_drive_t *drive)
 {
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 5d5fb96..2b91419 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -52,7 +52,7 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq,
 	}
 
 	if ((rq->errors & ERROR_RECAL) == ERROR_RECAL)
-		drive->special.b.recalibrate = 1;
+		drive->special_flags |= IDE_SFLAG_RECALIBRATE;
 
 	++rq->errors;
 
@@ -268,9 +268,8 @@ static void ide_disk_pre_reset(ide_drive_t *drive)
 {
 	int legacy = (drive->id[ATA_ID_CFS_ENABLE_2] & 0x0400) ? 0 : 1;
 
-	drive->special.all = 0;
-	drive->special.b.set_geometry = legacy;
-	drive->special.b.recalibrate  = legacy;
+	drive->special_flags =
+		legacy ? (IDE_SFLAG_SET_GEOMETRY | IDE_SFLAG_RECALIBRATE) : 0;
 
 	drive->mult_count = 0;
 	drive->dev_flags &= ~IDE_DFLAG_PARKED;
@@ -280,7 +279,7 @@ static void ide_disk_pre_reset(ide_drive_t *drive)
 		drive->mult_req = 0;
 
 	if (drive->mult_req != drive->mult_count)
-		drive->special.b.set_multmode = 1;
+		drive->special_flags |= IDE_SFLAG_SET_MULTMODE;
 }
 
 static void pre_reset(ide_drive_t *drive)
@@ -408,8 +407,9 @@ static ide_startstop_t do_reset1(ide_drive_t *drive, int do_not_try_atapi)
 	/* more than enough time */
 	udelay(10);
 	/* clear SRST, leave nIEN (unless device is on the quirk list) */
-	tp_ops->write_devctl(hwif, (drive->quirk_list == 2 ? 0 : ATA_NIEN) |
-			     ATA_DEVCTL_OBS);
+	tp_ops->write_devctl(hwif,
+		((drive->dev_flags & IDE_DFLAG_NIEN_QUIRK) ? 0 : ATA_NIEN) |
+		 ATA_DEVCTL_OBS);
 	/* more than enough time */
 	udelay(10);
 	hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 4b6b71e..2141190 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -287,6 +287,19 @@ static int ide_gd_media_changed(struct gendisk *disk)
 	return ret;
 }
 
+static unsigned long long ide_gd_set_capacity(struct gendisk *disk,
+					      unsigned long long capacity)
+{
+	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
+	ide_drive_t *drive = idkp->drive;
+	const struct ide_disk_ops *disk_ops = drive->disk_ops;
+
+	if (disk_ops->set_capacity)
+		return disk_ops->set_capacity(drive, capacity);
+
+	return drive->capacity64;
+}
+
 static int ide_gd_revalidate_disk(struct gendisk *disk)
 {
 	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
@@ -315,6 +328,7 @@ static struct block_device_operations ide_gd_ops = {
 	.locked_ioctl		= ide_gd_ioctl,
 	.getgeo			= ide_gd_getgeo,
 	.media_changed		= ide_gd_media_changed,
+	.set_capacity		= ide_gd_set_capacity,
 	.revalidate_disk	= ide_gd_revalidate_disk
 };
 
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 7812ca0..54d7c46 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -29,6 +29,7 @@ MODULE_PARM_DESC(probe_mask, "probe mask for legacy ISA IDE ports");
 
 static const struct ide_port_info ide_generic_port_info = {
 	.host_flags		= IDE_HFLAG_NO_DMA,
+	.chipset		= ide_generic,
 };
 
 #ifdef CONFIG_ARM
@@ -85,7 +86,7 @@ static void ide_generic_check_pci_legacy_iobases(int *primary, int *secondary)
 
 static int __init ide_generic_init(void)
 {
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 	unsigned long io_addr;
 	int i, rc = 0, primary = 0, secondary = 0;
 
@@ -132,9 +133,7 @@ static int __init ide_generic_init(void)
 #else
 			hw.irq = legacy_irqs[i];
 #endif
-			hw.chipset = ide_generic;
-
-			rc = ide_host_add(&ide_generic_port_info, hws, NULL);
+			rc = ide_host_add(&ide_generic_port_info, hws, 1, NULL);
 			if (rc) {
 				release_region(io_addr + 0x206, 1);
 				release_region(io_addr, 8);
diff --git a/drivers/ide/ide-h8300.c b/drivers/ide/ide-h8300.c
index c06ebdc..520f42c 100644
--- a/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -64,26 +64,26 @@ static const struct ide_tp_ops h8300_tp_ops = {
 
 #define H8300_IDE_GAP (2)
 
-static inline void hw_setup(hw_regs_t *hw)
+static inline void hw_setup(struct ide_hw *hw)
 {
 	int i;
 
-	memset(hw, 0, sizeof(hw_regs_t));
+	memset(hw, 0, sizeof(*hw));
 	for (i = 0; i <= 7; i++)
 		hw->io_ports_array[i] = CONFIG_H8300_IDE_BASE + H8300_IDE_GAP*i;
 	hw->io_ports.ctl_addr = CONFIG_H8300_IDE_ALT;
 	hw->irq = EXT_IRQ0 + CONFIG_H8300_IDE_IRQ;
-	hw->chipset = ide_generic;
 }
 
 static const struct ide_port_info h8300_port_info = {
 	.tp_ops			= &h8300_tp_ops,
 	.host_flags		= IDE_HFLAG_NO_IO_32BIT | IDE_HFLAG_NO_DMA,
+	.chipset		= ide_generic,
 };
 
 static int __init h8300_ide_init(void)
 {
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 
 	printk(KERN_INFO DRV_NAME ": H8/300 generic IDE interface\n");
 
@@ -96,7 +96,7 @@ static int __init h8300_ide_init(void)
 
 	hw_setup(&hw);
 
-	return ide_host_add(&h8300_port_info, hws, NULL);
+	return ide_host_add(&h8300_port_info, hws, 1, NULL);
 
 out_busy:
 	printk(KERN_ERR "ide-h8300: IDE I/F resource already used.\n");
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index bba4297..272cc38 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -184,29 +184,42 @@ static void ide_tf_set_setmult_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 	tf->command = ATA_CMD_SET_MULTI;
 }
 
-static ide_startstop_t ide_disk_special(ide_drive_t *drive)
+/**
+ *	do_special		-	issue some special commands
+ *	@drive: drive the command is for
+ *
+ *	do_special() is used to issue ATA_CMD_INIT_DEV_PARAMS,
+ *	ATA_CMD_RESTORE and ATA_CMD_SET_MULTI commands to a drive.
+ */
+
+static ide_startstop_t do_special(ide_drive_t *drive)
 {
-	special_t *s = &drive->special;
 	struct ide_cmd cmd;
 
+#ifdef DEBUG
+	printk(KERN_DEBUG "%s: %s: 0x%02x\n", drive->name, __func__,
+		drive->special_flags);
+#endif
+	if (drive->media != ide_disk) {
+		drive->special_flags = 0;
+		drive->mult_req = 0;
+		return ide_stopped;
+	}
+
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.protocol = ATA_PROT_NODATA;
 
-	if (s->b.set_geometry) {
-		s->b.set_geometry = 0;
+	if (drive->special_flags & IDE_SFLAG_SET_GEOMETRY) {
+		drive->special_flags &= ~IDE_SFLAG_SET_GEOMETRY;
 		ide_tf_set_specify_cmd(drive, &cmd.tf);
-	} else if (s->b.recalibrate) {
-		s->b.recalibrate = 0;
+	} else if (drive->special_flags & IDE_SFLAG_RECALIBRATE) {
+		drive->special_flags &= ~IDE_SFLAG_RECALIBRATE;
 		ide_tf_set_restore_cmd(drive, &cmd.tf);
-	} else if (s->b.set_multmode) {
-		s->b.set_multmode = 0;
+	} else if (drive->special_flags & IDE_SFLAG_SET_MULTMODE) {
+		drive->special_flags &= ~IDE_SFLAG_SET_MULTMODE;
 		ide_tf_set_setmult_cmd(drive, &cmd.tf);
-	} else if (s->all) {
-		int special = s->all;
-		s->all = 0;
-		printk(KERN_ERR "%s: bad special flag: 0x%02x\n", drive->name, special);
-		return ide_stopped;
-	}
+	} else
+		BUG();
 
 	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
 	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
@@ -217,31 +230,6 @@ static ide_startstop_t ide_disk_special(ide_drive_t *drive)
 	return ide_started;
 }
 
-/**
- *	do_special		-	issue some special commands
- *	@drive: drive the command is for
- *
- *	do_special() is used to issue ATA_CMD_INIT_DEV_PARAMS,
- *	ATA_CMD_RESTORE and ATA_CMD_SET_MULTI commands to a drive.
- *
- *	It used to do much more, but has been scaled back.
- */
-
-static ide_startstop_t do_special (ide_drive_t *drive)
-{
-	special_t *s = &drive->special;
-
-#ifdef DEBUG
-	printk("%s: do_special: 0x%02x\n", drive->name, s->all);
-#endif
-	if (drive->media == ide_disk)
-		return ide_disk_special(drive);
-
-	s->all = 0;
-	drive->mult_req = 0;
-	return ide_stopped;
-}
-
 void ide_map_sg(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -351,7 +339,8 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 		printk(KERN_ERR "%s: drive not ready for command\n", drive->name);
 		return startstop;
 	}
-	if (!drive->special.all) {
+
+	if (drive->special_flags == 0) {
 		struct ide_driver *drv;
 
 		/*
@@ -499,11 +488,15 @@ repeat:
 
 		if ((hwif->host->host_flags & IDE_HFLAG_SERIALIZE) &&
 		    hwif != prev_port) {
+			ide_drive_t *cur_dev =
+				prev_port ? prev_port->cur_dev : NULL;
+
 			/*
 			 * set nIEN for previous port, drives in the
-			 * quirk_list may not like intr setups/cleanups
+			 * quirk list may not like intr setups/cleanups
 			 */
-			if (prev_port && prev_port->cur_dev->quirk_list == 0)
+			if (cur_dev &&
+			    (cur_dev->dev_flags & IDE_DFLAG_NIEN_QUIRK) == 0)
 				prev_port->tp_ops->write_devctl(prev_port,
 								ATA_NIEN |
 								ATA_DEVCTL_OBS);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 06fe002..fa04715 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -282,6 +282,29 @@ no_80w:
 	return 0;
 }
 
+static const char *nien_quirk_list[] = {
+	"QUANTUM FIREBALLlct08 08",
+	"QUANTUM FIREBALLP KA6.4",
+	"QUANTUM FIREBALLP KA9.1",
+	"QUANTUM FIREBALLP KX13.6",
+	"QUANTUM FIREBALLP KX20.5",
+	"QUANTUM FIREBALLP KX27.3",
+	"QUANTUM FIREBALLP LM20.4",
+	"QUANTUM FIREBALLP LM20.5",
+	NULL
+};
+
+void ide_check_nien_quirk_list(ide_drive_t *drive)
+{
+	const char **list, *m = (char *)&drive->id[ATA_ID_PROD];
+
+	for (list = nien_quirk_list; *list != NULL; list++)
+		if (strstr(m, *list) != NULL) {
+			drive->dev_flags |= IDE_DFLAG_NIEN_QUIRK;
+			return;
+		}
+}
+
 int ide_driveid_update(ide_drive_t *drive)
 {
 	u16 *id;
@@ -311,7 +334,6 @@ int ide_driveid_update(ide_drive_t *drive)
 
 	return 1;
 out_err:
-	SELECT_MASK(drive, 0);
 	if (rc == 2)
 		printk(KERN_ERR "%s: %s: bad status\n", drive->name, __func__);
 	kfree(id);
@@ -365,7 +387,7 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 
 	tp_ops->exec_command(hwif, ATA_CMD_SET_FEATURES);
 
-	if (drive->quirk_list == 2)
+	if (drive->dev_flags & IDE_DFLAG_NIEN_QUIRK)
 		tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
 
 	error = __ide_wait_stat(drive, drive->ready_stat,
diff --git a/drivers/ide/ide-legacy.c b/drivers/ide/ide-legacy.c
index 8c5dcbf..b9654a7 100644
--- a/drivers/ide/ide-legacy.c
+++ b/drivers/ide/ide-legacy.c
@@ -1,7 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
 
-static void ide_legacy_init_one(hw_regs_t **hws, hw_regs_t *hw,
+static void ide_legacy_init_one(struct ide_hw **hws, struct ide_hw *hw,
 				u8 port_no, const struct ide_port_info *d,
 				unsigned long config)
 {
@@ -33,7 +33,6 @@ static void ide_legacy_init_one(hw_regs_t **hws, hw_regs_t *hw,
 
 	ide_std_init_ports(hw, base, ctl);
 	hw->irq = irq;
-	hw->chipset = d->chipset;
 	hw->config = config;
 
 	hws[port_no] = hw;
@@ -41,7 +40,7 @@ static void ide_legacy_init_one(hw_regs_t **hws, hw_regs_t *hw,
 
 int ide_legacy_device_add(const struct ide_port_info *d, unsigned long config)
 {
-	hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
+	struct ide_hw hw[2], *hws[] = { NULL, NULL };
 
 	memset(&hw, 0, sizeof(hw));
 
@@ -53,6 +52,6 @@ int ide_legacy_device_add(const struct ide_port_info *d, unsigned long config)
 	    (d->host_flags & IDE_HFLAG_SINGLE))
 		return -ENOENT;
 
-	return ide_host_add(d, hws, NULL);
+	return ide_host_add(d, hws, 2, NULL);
 }
 EXPORT_SYMBOL_GPL(ide_legacy_device_add);
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index 6e80b77..017b1df 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -29,6 +29,7 @@ static struct pnp_device_id idepnp_devices[] = {
 
 static const struct ide_port_info ide_pnp_port_info = {
 	.host_flags		= IDE_HFLAG_NO_DMA,
+	.chipset		= ide_generic,
 };
 
 static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
@@ -36,7 +37,7 @@ static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	struct ide_host *host;
 	unsigned long base, ctl;
 	int rc;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 
 	printk(KERN_INFO DRV_NAME ": generic PnP IDE interface\n");
 
@@ -62,9 +63,8 @@ static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = pnp_irq(dev, 0);
-	hw.chipset = ide_generic;
 
-	rc = ide_host_add(&ide_pnp_port_info, hws, &host);
+	rc = ide_host_add(&ide_pnp_port_info, hws, 1, &host);
 	if (rc)
 		goto out;
 
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index c895ed5..f371b0d 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -97,7 +97,7 @@ static void ide_disk_init_mult_count(ide_drive_t *drive)
 		drive->mult_req = id[ATA_ID_MULTSECT] & 0xff;
 
 		if (drive->mult_req)
-			drive->special.b.set_multmode = 1;
+			drive->special_flags |= IDE_SFLAG_SET_MULTMODE;
 	}
 }
 
@@ -465,23 +465,8 @@ static u8 probe_for_drive(ide_drive_t *drive)
 	int rc;
 	u8 cmd;
 
-	/*
-	 *	In order to keep things simple we have an id
-	 *	block for all drives at all times. If the device
-	 *	is pre ATA or refuses ATA/ATAPI identify we
-	 *	will add faked data to this.
-	 *
-	 *	Also note that 0 everywhere means "can't do X"
-	 */
- 
 	drive->dev_flags &= ~IDE_DFLAG_ID_READ;
 
-	drive->id = kzalloc(SECTOR_SIZE, GFP_KERNEL);
-	if (drive->id == NULL) {
-		printk(KERN_ERR "ide: out of memory for id data.\n");
-		return 0;
-	}
-
 	m = (char *)&drive->id[ATA_ID_PROD];
 	strcpy(m, "UNKNOWN");
 
@@ -497,7 +482,7 @@ static u8 probe_for_drive(ide_drive_t *drive)
 		}
 
 		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-			goto out_free;
+			return 0;
 
 		/* identification failed? */
 		if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
@@ -521,7 +506,7 @@ static u8 probe_for_drive(ide_drive_t *drive)
 	}
 
 	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-		goto out_free;
+		return 0;
 
 	/* The drive wasn't being helpful. Add generic info only */
 	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
@@ -535,9 +520,6 @@ static u8 probe_for_drive(ide_drive_t *drive)
 	}
 
 	return 1;
-out_free:
-	kfree(drive->id);
-	return 0;
 }
 
 static void hwif_release_dev(struct device *dev)
@@ -702,8 +684,14 @@ static int ide_probe_port(ide_hwif_t *hwif)
 	if (irqd)
 		disable_irq(hwif->irq);
 
-	if (ide_port_wait_ready(hwif) == -EBUSY)
-		printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
+	rc = ide_port_wait_ready(hwif);
+	if (rc == -ENODEV) {
+		printk(KERN_INFO "%s: no devices on the port\n", hwif->name);
+		goto out;
+	} else if (rc == -EBUSY)
+		printk(KERN_ERR "%s: not ready before the probe\n", hwif->name);
+	else
+		rc = -ENODEV;
 
 	/*
 	 * Second drive should only exist if first drive was found,
@@ -714,7 +702,7 @@ static int ide_probe_port(ide_hwif_t *hwif)
 		if (drive->dev_flags & IDE_DFLAG_PRESENT)
 			rc = 0;
 	}
-
+out:
 	/*
 	 * Use cached IRQ number. It might be (and is...) changed by probe
 	 * code above
@@ -732,6 +720,8 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
 	int i;
 
 	ide_port_for_each_present_dev(i, drive, hwif) {
+		ide_check_nien_quirk_list(drive);
+
 		if (port_ops && port_ops->quirkproc)
 			port_ops->quirkproc(drive);
 	}
@@ -817,8 +807,6 @@ static int ide_port_setup_devices(ide_hwif_t *hwif)
 		if (ide_init_queue(drive)) {
 			printk(KERN_ERR "ide: failed to init %s\n",
 					drive->name);
-			kfree(drive->id);
-			drive->id = NULL;
 			drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 			continue;
 		}
@@ -947,9 +935,6 @@ static void drive_release_dev (struct device *dev)
 	blk_cleanup_queue(drive->queue);
 	drive->queue = NULL;
 
-	kfree(drive->id);
-	drive->id = NULL;
-
 	drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 
 	complete(&drive->gendev_rel_comp);
@@ -1035,6 +1020,15 @@ static void ide_port_init_devices(ide_hwif_t *hwif)
 		if (port_ops && port_ops->init_dev)
 			port_ops->init_dev(drive);
 	}
+
+	ide_port_for_each_dev(i, drive, hwif) {
+		/*
+		 * default to PIO Mode 0 before we figure out
+		 * the most suited mode for the attached device
+		 */
+		if (port_ops && port_ops->set_pio_mode)
+			port_ops->set_pio_mode(drive, 0);
+	}
 }
 
 static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
@@ -1042,8 +1036,7 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 {
 	hwif->channel = port;
 
-	if (d->chipset)
-		hwif->chipset = d->chipset;
+	hwif->chipset = d->chipset ? d->chipset : ide_pci;
 
 	if (d->init_iops)
 		d->init_iops(hwif);
@@ -1124,16 +1117,19 @@ static void ide_port_init_devices_data(ide_hwif_t *hwif)
 
 	ide_port_for_each_dev(i, drive, hwif) {
 		u8 j = (hwif->index * MAX_DRIVES) + i;
+		u16 *saved_id = drive->id;
 
 		memset(drive, 0, sizeof(*drive));
+		memset(saved_id, 0, SECTOR_SIZE);
+		drive->id = saved_id;
 
 		drive->media			= ide_disk;
 		drive->select			= (i << 4) | ATA_DEVICE_OBS;
 		drive->hwif			= hwif;
 		drive->ready_stat		= ATA_DRDY;
 		drive->bad_wstat		= BAD_W_STAT;
-		drive->special.b.recalibrate	= 1;
-		drive->special.b.set_geometry	= 1;
+		drive->special_flags		= IDE_SFLAG_RECALIBRATE |
+						  IDE_SFLAG_SET_GEOMETRY;
 		drive->name[0]			= 'h';
 		drive->name[1]			= 'd';
 		drive->name[2]			= 'a' + j;
@@ -1168,11 +1164,10 @@ static void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
 	ide_port_init_devices_data(hwif);
 }
 
-static void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
+static void ide_init_port_hw(ide_hwif_t *hwif, struct ide_hw *hw)
 {
 	memcpy(&hwif->io_ports, &hw->io_ports, sizeof(hwif->io_ports));
 	hwif->irq = hw->irq;
-	hwif->chipset = hw->chipset;
 	hwif->dev = hw->dev;
 	hwif->gendev.parent = hw->parent ? hw->parent : hw->dev;
 	hwif->ack_intr = hw->ack_intr;
@@ -1233,8 +1228,10 @@ static void ide_port_free_devices(ide_hwif_t *hwif)
 	ide_drive_t *drive;
 	int i;
 
-	ide_port_for_each_dev(i, drive, hwif)
+	ide_port_for_each_dev(i, drive, hwif) {
+		kfree(drive->id);
 		kfree(drive);
+	}
 }
 
 static int ide_port_alloc_devices(ide_hwif_t *hwif, int node)
@@ -1248,6 +1245,18 @@ static int ide_port_alloc_devices(ide_hwif_t *hwif, int node)
 		if (drive == NULL)
 			goto out_nomem;
 
+		/*
+		 * In order to keep things simple we have an id
+		 * block for all drives at all times. If the device
+		 * is pre ATA or refuses ATA/ATAPI identify we
+		 * will add faked data to this.
+		 *
+		 * Also note that 0 everywhere means "can't do X"
+		 */
+		drive->id = kzalloc_node(SECTOR_SIZE, GFP_KERNEL, node);
+		if (drive->id == NULL)
+			goto out_nomem;
+
 		hwif->devices[i] = drive;
 	}
 	return 0;
@@ -1257,7 +1266,8 @@ out_nomem:
 	return -ENOMEM;
 }
 
-struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
+struct ide_host *ide_host_alloc(const struct ide_port_info *d,
+				struct ide_hw **hws, unsigned int n_ports)
 {
 	struct ide_host *host;
 	struct device *dev = hws[0] ? hws[0]->dev : NULL;
@@ -1268,7 +1278,7 @@ struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
 	if (host == NULL)
 		return NULL;
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
+	for (i = 0; i < n_ports; i++) {
 		ide_hwif_t *hwif;
 		int idx;
 
@@ -1288,6 +1298,7 @@ struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
 		if (idx < 0) {
 			printk(KERN_ERR "%s: no free slot for interface\n",
 					d ? d->name : "ide");
+			ide_port_free_devices(hwif);
 			kfree(hwif);
 			continue;
 		}
@@ -1344,7 +1355,7 @@ static void ide_disable_port(ide_hwif_t *hwif)
 }
 
 int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
-		      hw_regs_t **hws)
+		      struct ide_hw **hws)
 {
 	ide_hwif_t *hwif, *mate = NULL;
 	int i, j = 0;
@@ -1438,13 +1449,13 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 }
 EXPORT_SYMBOL_GPL(ide_host_register);
 
-int ide_host_add(const struct ide_port_info *d, hw_regs_t **hws,
-		 struct ide_host **hostp)
+int ide_host_add(const struct ide_port_info *d, struct ide_hw **hws,
+		 unsigned int n_ports, struct ide_host **hostp)
 {
 	struct ide_host *host;
 	int rc;
 
-	host = ide_host_alloc(d, hws);
+	host = ide_host_alloc(d, hws, n_ports);
 	if (host == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index d9764f0..4b447a8 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -240,18 +240,27 @@ static struct class *idetape_sysfs_class;
 
 static void ide_tape_release(struct device *);
 
-static struct ide_tape_obj *ide_tape_get(struct gendisk *disk)
+static struct ide_tape_obj *idetape_devs[MAX_HWIFS * MAX_DRIVES];
+
+static struct ide_tape_obj *ide_tape_get(struct gendisk *disk, bool cdev,
+					 unsigned int i)
 {
 	struct ide_tape_obj *tape = NULL;
 
 	mutex_lock(&idetape_ref_mutex);
-	tape = ide_drv_g(disk, ide_tape_obj);
+
+	if (cdev)
+		tape = idetape_devs[i];
+	else
+		tape = ide_drv_g(disk, ide_tape_obj);
+
 	if (tape) {
 		if (ide_device_get(tape->drive))
 			tape = NULL;
 		else
 			get_device(&tape->dev);
 	}
+
 	mutex_unlock(&idetape_ref_mutex);
 	return tape;
 }
@@ -267,24 +276,6 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 }
 
 /*
- * The variables below are used for the character device interface. Additional
- * state variables are defined in our ide_drive_t structure.
- */
-static struct ide_tape_obj *idetape_devs[MAX_HWIFS * MAX_DRIVES];
-
-static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
-{
-	struct ide_tape_obj *tape = NULL;
-
-	mutex_lock(&idetape_ref_mutex);
-	tape = idetape_devs[i];
-	if (tape)
-		get_device(&tape->dev);
-	mutex_unlock(&idetape_ref_mutex);
-	return tape;
-}
-
-/*
  * called on each failed packet command retry to analyze the request sense. We
  * currently do not utilize this information.
  */
@@ -397,7 +388,8 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 		if (readpos[0] & 0x4) {
 			printk(KERN_INFO "ide-tape: Block location is unknown"
 					 "to the tape\n");
-			clear_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
+			clear_bit(ilog2(IDE_AFLAG_ADDRESS_VALID),
+				  &drive->atapi_flags);
 			uptodate = 0;
 			err = IDE_DRV_ERROR_GENERAL;
 		} else {
@@ -406,7 +398,8 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 
 			tape->partition = readpos[1];
 			tape->first_frame = be32_to_cpup((__be32 *)&readpos[4]);
-			set_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
+			set_bit(ilog2(IDE_AFLAG_ADDRESS_VALID),
+				&drive->atapi_flags);
 		}
 	}
 
@@ -656,15 +649,15 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 
 	if ((drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) == 0 &&
 	    (rq->cmd[13] & REQ_IDETAPE_PC2) == 0)
-		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
+		drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
 
 	if (drive->dev_flags & IDE_DFLAG_POST_RESET) {
-		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
+		drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
 		drive->dev_flags &= ~IDE_DFLAG_POST_RESET;
 	}
 
-	if (!test_and_clear_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags) &&
-	    (stat & ATA_DSC) == 0) {
+	if (!(drive->atapi_flags & IDE_AFLAG_IGNORE_DSC) &&
+	    !(stat & ATA_DSC)) {
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
 			tape->dsc_poll_freq = tape->best_dsc_rw_freq;
@@ -684,7 +677,9 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 			tape->dsc_poll_freq = IDETAPE_DSC_MA_SLOW;
 		idetape_postpone_request(drive);
 		return ide_stopped;
-	}
+	} else
+		drive->atapi_flags &= ~IDE_AFLAG_IGNORE_DSC;
+
 	if (rq->cmd[13] & REQ_IDETAPE_READ) {
 		pc = &tape->queued_pc;
 		ide_tape_create_rw_cmd(tape, pc, rq, READ_6);
@@ -744,7 +739,7 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	int load_attempted = 0;
 
 	/* Wait for the tape to become ready */
-	set_bit(IDE_AFLAG_MEDIUM_PRESENT, &drive->atapi_flags);
+	set_bit(ilog2(IDE_AFLAG_MEDIUM_PRESENT), &drive->atapi_flags);
 	timeout += jiffies;
 	while (time_before(jiffies, timeout)) {
 		if (ide_do_test_unit_ready(drive, disk) == 0)
@@ -820,7 +815,7 @@ static void __ide_tape_discard_merge_buffer(ide_drive_t *drive)
 	if (tape->chrdev_dir != IDETAPE_DIR_READ)
 		return;
 
-	clear_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags);
+	clear_bit(ilog2(IDE_AFLAG_FILEMARK), &drive->atapi_flags);
 	tape->valid = 0;
 	if (tape->buf != NULL) {
 		kfree(tape->buf);
@@ -1113,7 +1108,8 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
 		tape->valid = 0;
-		if (test_and_clear_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags))
+		if (test_and_clear_bit(ilog2(IDE_AFLAG_FILEMARK),
+				       &drive->atapi_flags))
 			++count;
 		ide_tape_discard_merge_buffer(drive, 0);
 	}
@@ -1168,7 +1164,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
-		if (test_bit(IDE_AFLAG_DETECT_BS, &drive->atapi_flags))
+		if (test_bit(ilog2(IDE_AFLAG_DETECT_BS), &drive->atapi_flags))
 			if (count > tape->blk_size &&
 			    (count % tape->blk_size) == 0)
 				tape->user_bs_factor = count / tape->blk_size;
@@ -1184,7 +1180,8 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		/* refill if staging buffer is empty */
 		if (!tape->valid) {
 			/* If we are at a filemark, nothing more to read */
-			if (test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags))
+			if (test_bit(ilog2(IDE_AFLAG_FILEMARK),
+				     &drive->atapi_flags))
 				break;
 			/* read */
 			if (idetape_queue_rw_tail(drive, REQ_IDETAPE_READ,
@@ -1202,7 +1199,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		done += todo;
 	}
 
-	if (!done && test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags)) {
+	if (!done && test_bit(ilog2(IDE_AFLAG_FILEMARK), &drive->atapi_flags)) {
 		debug_log(DBG_SENSE, "%s: spacing over filemark\n", tape->name);
 
 		idetape_space_over_filemarks(drive, MTFSF, 1);
@@ -1336,7 +1333,8 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 		ide_tape_discard_merge_buffer(drive, 0);
 		retval = ide_do_start_stop(drive, disk, !IDETAPE_LU_LOAD_MASK);
 		if (!retval)
-			clear_bit(IDE_AFLAG_MEDIUM_PRESENT, &drive->atapi_flags);
+			clear_bit(ilog2(IDE_AFLAG_MEDIUM_PRESENT),
+				  &drive->atapi_flags);
 		return retval;
 	case MTNOP:
 		ide_tape_discard_merge_buffer(drive, 0);
@@ -1358,9 +1356,11 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			    mt_count % tape->blk_size)
 				return -EIO;
 			tape->user_bs_factor = mt_count / tape->blk_size;
-			clear_bit(IDE_AFLAG_DETECT_BS, &drive->atapi_flags);
+			clear_bit(ilog2(IDE_AFLAG_DETECT_BS),
+				  &drive->atapi_flags);
 		} else
-			set_bit(IDE_AFLAG_DETECT_BS, &drive->atapi_flags);
+			set_bit(ilog2(IDE_AFLAG_DETECT_BS),
+				&drive->atapi_flags);
 		return 0;
 	case MTSEEK:
 		ide_tape_discard_merge_buffer(drive, 0);
@@ -1486,7 +1486,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 		return -ENXIO;
 
 	lock_kernel();
-	tape = ide_tape_chrdev_get(i);
+	tape = ide_tape_get(NULL, true, i);
 	if (!tape) {
 		unlock_kernel();
 		return -ENXIO;
@@ -1505,20 +1505,20 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = tape;
 
-	if (test_and_set_bit(IDE_AFLAG_BUSY, &drive->atapi_flags)) {
+	if (test_and_set_bit(ilog2(IDE_AFLAG_BUSY), &drive->atapi_flags)) {
 		retval = -EBUSY;
 		goto out_put_tape;
 	}
 
 	retval = idetape_wait_ready(drive, 60 * HZ);
 	if (retval) {
-		clear_bit(IDE_AFLAG_BUSY, &drive->atapi_flags);
+		clear_bit(ilog2(IDE_AFLAG_BUSY), &drive->atapi_flags);
 		printk(KERN_ERR "ide-tape: %s: drive not ready\n", tape->name);
 		goto out_put_tape;
 	}
 
 	idetape_read_position(drive);
-	if (!test_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags))
+	if (!test_bit(ilog2(IDE_AFLAG_ADDRESS_VALID), &drive->atapi_flags))
 		(void)idetape_rewind_tape(drive);
 
 	/* Read block size and write protect status from drive. */
@@ -1534,7 +1534,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	if (tape->write_prot) {
 		if ((filp->f_flags & O_ACCMODE) == O_WRONLY ||
 		    (filp->f_flags & O_ACCMODE) == O_RDWR) {
-			clear_bit(IDE_AFLAG_BUSY, &drive->atapi_flags);
+			clear_bit(ilog2(IDE_AFLAG_BUSY), &drive->atapi_flags);
 			retval = -EROFS;
 			goto out_put_tape;
 		}
@@ -1591,15 +1591,17 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 			ide_tape_discard_merge_buffer(drive, 1);
 	}
 
-	if (minor < 128 && test_bit(IDE_AFLAG_MEDIUM_PRESENT, &drive->atapi_flags))
+	if (minor < 128 && test_bit(ilog2(IDE_AFLAG_MEDIUM_PRESENT),
+				    &drive->atapi_flags))
 		(void) idetape_rewind_tape(drive);
+
 	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
 		if (tape->door_locked == DOOR_LOCKED) {
 			if (!ide_set_media_lock(drive, tape->disk, 0))
 				tape->door_locked = DOOR_UNLOCKED;
 		}
 	}
-	clear_bit(IDE_AFLAG_BUSY, &drive->atapi_flags);
+	clear_bit(ilog2(IDE_AFLAG_BUSY), &drive->atapi_flags);
 	ide_tape_put(tape);
 	unlock_kernel();
 	return 0;
@@ -1905,7 +1907,7 @@ static const struct file_operations idetape_fops = {
 
 static int idetape_open(struct block_device *bdev, fmode_t mode)
 {
-	struct ide_tape_obj *tape = ide_tape_get(bdev->bd_disk);
+	struct ide_tape_obj *tape = ide_tape_get(bdev->bd_disk, false, 0);
 
 	if (!tape)
 		return -ENXIO;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index a0c3e1b..75b85a8 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -98,7 +98,6 @@ ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *orig_cmd)
 	if ((cmd->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
 		ide_tf_dump(drive->name, cmd);
 		tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
-		SELECT_MASK(drive, 0);
 
 		if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA) {
 			u8 data[2] = { cmd->tf.data, cmd->hob.data };
@@ -166,7 +165,7 @@ static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT)) {
 		if (custom && tf->command == ATA_CMD_SET_MULTI) {
 			drive->mult_req = drive->mult_count = 0;
-			drive->special.b.recalibrate = 1;
+			drive->special_flags |= IDE_SFLAG_RECALIBRATE;
 			(void)ide_dump_status(drive, __func__, stat);
 			return ide_stopped;
 		} else if (custom && tf->command == ATA_CMD_INIT_DEV_PARAMS) {
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 92c9b90..16d0569 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -211,6 +211,11 @@ static unsigned int ide_noflush;
 module_param_call(noflush, ide_set_dev_param_mask, NULL, &ide_noflush, 0);
 MODULE_PARM_DESC(noflush, "disable flush requests for a device");
 
+static unsigned int ide_nohpa;
+
+module_param_call(nohpa, ide_set_dev_param_mask, NULL, &ide_nohpa, 0);
+MODULE_PARM_DESC(nohpa, "disable Host Protected Area for a device");
+
 static unsigned int ide_noprobe;
 
 module_param_call(noprobe, ide_set_dev_param_mask, NULL, &ide_noprobe, 0);
@@ -281,6 +286,11 @@ static void ide_dev_apply_params(ide_drive_t *drive, u8 unit)
 				 drive->name);
 		drive->dev_flags |= IDE_DFLAG_NOFLUSH;
 	}
+	if (ide_nohpa & (1 << i)) {
+		printk(KERN_INFO "ide: disabling Host Protected Area for %s\n",
+				 drive->name);
+		drive->dev_flags |= IDE_DFLAG_NOHPA;
+	}
 	if (ide_noprobe & (1 << i)) {
 		printk(KERN_INFO "ide: skipping probe for %s\n", drive->name);
 		drive->dev_flags |= IDE_DFLAG_NOPROBE;
diff --git a/drivers/ide/ide_platform.c b/drivers/ide/ide_platform.c
index 051b4ab..ee9b55e 100644
--- a/drivers/ide/ide_platform.c
+++ b/drivers/ide/ide_platform.c
@@ -21,7 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 
-static void __devinit plat_ide_setup_ports(hw_regs_t *hw,
+static void __devinit plat_ide_setup_ports(struct ide_hw *hw,
 					   void __iomem *base,
 					   void __iomem *ctrl,
 					   struct pata_platform_info *pdata,
@@ -40,12 +40,11 @@ static void __devinit plat_ide_setup_ports(hw_regs_t *hw,
 	hw->io_ports.ctl_addr = (unsigned long)ctrl;
 
 	hw->irq = irq;
-
-	hw->chipset = ide_generic;
 }
 
 static const struct ide_port_info platform_ide_port_info = {
 	.host_flags		= IDE_HFLAG_NO_DMA,
+	.chipset		= ide_generic,
 };
 
 static int __devinit plat_ide_probe(struct platform_device *pdev)
@@ -55,7 +54,7 @@ static int __devinit plat_ide_probe(struct platform_device *pdev)
 	struct pata_platform_info *pdata;
 	struct ide_host *host;
 	int ret = 0, mmio = 0;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 	struct ide_port_info d = platform_ide_port_info;
 
 	pdata = pdev->dev.platform_data;
@@ -99,7 +98,7 @@ static int __devinit plat_ide_probe(struct platform_device *pdev)
 	if (mmio)
 		d.host_flags |= IDE_HFLAG_MMIO;
 
-	ret = ide_host_add(&d, hws, &host);
+	ret = ide_host_add(&d, hws, 1, &host);
 	if (ret)
 		goto out;
 
diff --git a/drivers/ide/macide.c b/drivers/ide/macide.c
index 4b1718e..1447c8c 100644
--- a/drivers/ide/macide.c
+++ b/drivers/ide/macide.c
@@ -62,7 +62,7 @@ int macide_ack_intr(ide_hwif_t* hwif)
 	return 0;
 }
 
-static void __init macide_setup_ports(hw_regs_t *hw, unsigned long base,
+static void __init macide_setup_ports(struct ide_hw *hw, unsigned long base,
 				      int irq, ide_ack_intr_t *ack_intr)
 {
 	int i;
@@ -76,13 +76,12 @@ static void __init macide_setup_ports(hw_regs_t *hw, unsigned long base,
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;
-
-	hw->chipset = ide_generic;
 }
 
 static const struct ide_port_info macide_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
+	.chipset		= ide_generic,
 };
 
 static const char *mac_ide_name[] =
@@ -97,7 +96,7 @@ static int __init macide_init(void)
 	ide_ack_intr_t *ack_intr;
 	unsigned long base;
 	int irq;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 
 	if (!MACH_IS_MAC)
 		return -ENODEV;
@@ -127,7 +126,7 @@ static int __init macide_init(void)
 
 	macide_setup_ports(&hw, base, irq, ack_intr);
 
-	return ide_host_add(&macide_port_info, hws, NULL);
+	return ide_host_add(&macide_port_info, hws, 1, NULL);
 }
 
 module_init(macide_init);
diff --git a/drivers/ide/palm_bk3710.c b/drivers/ide/palm_bk3710.c
index 09d813d..3c1dc01 100644
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -306,6 +306,7 @@ static struct ide_port_info __devinitdata palm_bk3710_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO,
 	.pio_mask		= ATA_PIO4,
 	.mwdma_mask		= ATA_MWDMA2,
+	.chipset		= ide_palm3710,
 };
 
 static int __init palm_bk3710_probe(struct platform_device *pdev)
@@ -315,7 +316,7 @@ static int __init palm_bk3710_probe(struct platform_device *pdev)
 	void __iomem *base;
 	unsigned long rate, mem_size;
 	int i, rc;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 
 	clk = clk_get(&pdev->dev, "IDECLK");
 	if (IS_ERR(clk))
@@ -363,13 +364,12 @@ static int __init palm_bk3710_probe(struct platform_device *pdev)
 			(base + IDE_PALM_ATA_PRI_CTL_OFFSET);
 	hw.irq = irq->start;
 	hw.dev = &pdev->dev;
-	hw.chipset = ide_palm3710;
 
 	palm_bk3710_port_info.udma_mask = rate < 100000000 ? ATA_UDMA4 :
 							     ATA_UDMA5;
 
 	/* Register the IDE interface with Linux */
-	rc = ide_host_add(&palm_bk3710_port_info, hws, NULL);
+	rc = ide_host_add(&palm_bk3710_port_info, hws, 1, NULL);
 	if (rc)
 		goto out;
 
diff --git a/drivers/ide/pdc202xx_new.c b/drivers/ide/pdc202xx_new.c
index b68906c..65ba823 100644
--- a/drivers/ide/pdc202xx_new.c
+++ b/drivers/ide/pdc202xx_new.c
@@ -40,18 +40,6 @@
 #define DBG(fmt, args...)
 #endif
 
-static const char *pdc_quirk_drives[] = {
-	"QUANTUM FIREBALLlct08 08",
-	"QUANTUM FIREBALLP KA6.4",
-	"QUANTUM FIREBALLP KA9.1",
-	"QUANTUM FIREBALLP LM20.4",
-	"QUANTUM FIREBALLP KX13.6",
-	"QUANTUM FIREBALLP KX20.5",
-	"QUANTUM FIREBALLP KX27.3",
-	"QUANTUM FIREBALLP LM20.5",
-	NULL
-};
-
 static u8 max_dma_rate(struct pci_dev *pdev)
 {
 	u8 mode;
@@ -200,19 +188,6 @@ static u8 pdcnew_cable_detect(ide_hwif_t *hwif)
 		return ATA_CBL_PATA80;
 }
 
-static void pdcnew_quirkproc(ide_drive_t *drive)
-{
-	const char **list, *m = (char *)&drive->id[ATA_ID_PROD];
-
-	for (list = pdc_quirk_drives; *list != NULL; list++)
-		if (strstr(m, *list) != NULL) {
-			drive->quirk_list = 2;
-			return;
-		}
-
-	drive->quirk_list = 0;
-}
-
 static void pdcnew_reset(ide_drive_t *drive)
 {
 	/*
@@ -473,7 +448,6 @@ static struct pci_dev * __devinit pdc20270_get_dev2(struct pci_dev *dev)
 static const struct ide_port_ops pdcnew_port_ops = {
 	.set_pio_mode		= pdcnew_set_pio_mode,
 	.set_dma_mode		= pdcnew_set_dma_mode,
-	.quirkproc		= pdcnew_quirkproc,
 	.resetproc		= pdcnew_reset,
 	.cable_detect		= pdcnew_cable_detect,
 };
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index e24ecc8..b6abf7e 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -23,18 +23,6 @@
 
 #define PDC202XX_DEBUG_DRIVE_INFO	0
 
-static const char *pdc_quirk_drives[] = {
-	"QUANTUM FIREBALLlct08 08",
-	"QUANTUM FIREBALLP KA6.4",
-	"QUANTUM FIREBALLP KA9.1",
-	"QUANTUM FIREBALLP LM20.4",
-	"QUANTUM FIREBALLP KX13.6",
-	"QUANTUM FIREBALLP KX20.5",
-	"QUANTUM FIREBALLP KX27.3",
-	"QUANTUM FIREBALLP LM20.5",
-	NULL
-};
-
 static void pdc_old_disable_66MHz_clock(ide_hwif_t *);
 
 static void pdc202xx_set_mode(ide_drive_t *drive, const u8 speed)
@@ -151,19 +139,6 @@ static void pdc_old_disable_66MHz_clock(ide_hwif_t *hwif)
 	outb(clock & ~(hwif->channel ? 0x08 : 0x02), clock_reg);
 }
 
-static void pdc202xx_quirkproc(ide_drive_t *drive)
-{
-	const char **list, *m = (char *)&drive->id[ATA_ID_PROD];
-
-	for (list = pdc_quirk_drives; *list != NULL; list++)
-		if (strstr(m, *list) != NULL) {
-			drive->quirk_list = 2;
-			return;
-		}
-
-	drive->quirk_list = 0;
-}
-
 static void pdc202xx_dma_start(ide_drive_t *drive)
 {
 	if (drive->current_speed > XFER_UDMA_2)
@@ -203,52 +178,6 @@ static int pdc202xx_dma_end(ide_drive_t *drive)
 	return ide_dma_end(drive);
 }
 
-static int pdc202xx_dma_test_irq(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif	= drive->hwif;
-	unsigned long high_16	= hwif->extra_base - 16;
-	u8 dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
-	u8 sc1d			= inb(high_16 + 0x001d);
-
-	if (hwif->channel) {
-		/* bit7: Error, bit6: Interrupting, bit5: FIFO Full, bit4: FIFO Empty */
-		if ((sc1d & 0x50) == 0x50)
-			goto somebody_else;
-		else if ((sc1d & 0x40) == 0x40)
-			return (dma_stat & 4) == 4;
-	} else {
-		/* bit3: Error, bit2: Interrupting, bit1: FIFO Full, bit0: FIFO Empty */
-		if ((sc1d & 0x05) == 0x05)
-			goto somebody_else;
-		else if ((sc1d & 0x04) == 0x04)
-			return (dma_stat & 4) == 4;
-	}
-somebody_else:
-	return (dma_stat & 4) == 4;	/* return 1 if INTR asserted */
-}
-
-static void pdc202xx_reset(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif	= drive->hwif;
-	unsigned long high_16	= hwif->extra_base - 16;
-	u8 udma_speed_flag	= inb(high_16 | 0x001f);
-
-	printk(KERN_WARNING "PDC202xx: software reset...\n");
-
-	outb(udma_speed_flag | 0x10, high_16 | 0x001f);
-	mdelay(100);
-	outb(udma_speed_flag & ~0x10, high_16 | 0x001f);
-	mdelay(2000);	/* 2 seconds ?! */
-
-	ide_set_max_pio(drive);
-}
-
-static void pdc202xx_dma_lost_irq(ide_drive_t *drive)
-{
-	pdc202xx_reset(drive);
-	ide_dma_lost_irq(drive);
-}
-
 static int init_chipset_pdc202xx(struct pci_dev *dev)
 {
 	unsigned long dmabase = pci_resource_start(dev, 4);
@@ -302,37 +231,22 @@ static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
 static const struct ide_port_ops pdc20246_port_ops = {
 	.set_pio_mode		= pdc202xx_set_pio_mode,
 	.set_dma_mode		= pdc202xx_set_mode,
-	.quirkproc		= pdc202xx_quirkproc,
 };
 
 static const struct ide_port_ops pdc2026x_port_ops = {
 	.set_pio_mode		= pdc202xx_set_pio_mode,
 	.set_dma_mode		= pdc202xx_set_mode,
-	.quirkproc		= pdc202xx_quirkproc,
-	.resetproc		= pdc202xx_reset,
 	.cable_detect		= pdc2026x_cable_detect,
 };
 
-static const struct ide_dma_ops pdc20246_dma_ops = {
-	.dma_host_set		= ide_dma_host_set,
-	.dma_setup		= ide_dma_setup,
-	.dma_start		= ide_dma_start,
-	.dma_end		= ide_dma_end,
-	.dma_test_irq		= pdc202xx_dma_test_irq,
-	.dma_lost_irq		= ide_dma_lost_irq,
-	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_sff_read_status	= ide_dma_sff_read_status,
-};
-
 static const struct ide_dma_ops pdc2026x_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
 	.dma_start		= pdc202xx_dma_start,
 	.dma_end		= pdc202xx_dma_end,
-	.dma_test_irq		= pdc202xx_dma_test_irq,
-	.dma_lost_irq		= pdc202xx_dma_lost_irq,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_clear		= pdc202xx_reset,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
@@ -354,7 +268,7 @@ static const struct ide_port_info pdc202xx_chipsets[] __devinitdata = {
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_pdc202xx,
 		.port_ops	= &pdc20246_port_ops,
-		.dma_ops	= &pdc20246_dma_ops,
+		.dma_ops	= &sff_dma_ops,
 		.host_flags	= IDE_HFLAGS_PDC202XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index f76e4e6..97642a7 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1023,13 +1023,14 @@ static const struct ide_port_info pmac_port_info = {
  * Setup, register & probe an IDE channel driven by this driver, this is
  * called by one of the 2 probe functions (macio or PCI).
  */
-static int __devinit pmac_ide_setup_device(pmac_ide_hwif_t *pmif, hw_regs_t *hw)
+static int __devinit pmac_ide_setup_device(pmac_ide_hwif_t *pmif,
+					   struct ide_hw *hw)
 {
 	struct device_node *np = pmif->node;
 	const int *bidp;
 	struct ide_host *host;
 	ide_hwif_t *hwif;
-	hw_regs_t *hws[] = { hw, NULL, NULL, NULL };
+	struct ide_hw *hws[] = { hw };
 	struct ide_port_info d = pmac_port_info;
 	int rc;
 
@@ -1077,7 +1078,7 @@ static int __devinit pmac_ide_setup_device(pmac_ide_hwif_t *pmif, hw_regs_t *hw)
 	/* Make sure we have sane timings */
 	sanitize_timings(pmif);
 
-	host = ide_host_alloc(&d, hws);
+	host = ide_host_alloc(&d, hws, 1);
 	if (host == NULL)
 		return -ENOMEM;
 	hwif = host->ports[0];
@@ -1124,7 +1125,7 @@ static int __devinit pmac_ide_setup_device(pmac_ide_hwif_t *pmif, hw_regs_t *hw)
 	return 0;
 }
 
-static void __devinit pmac_ide_init_ports(hw_regs_t *hw, unsigned long base)
+static void __devinit pmac_ide_init_ports(struct ide_hw *hw, unsigned long base)
 {
 	int i;
 
@@ -1144,7 +1145,7 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	unsigned long regbase;
 	pmac_ide_hwif_t *pmif;
 	int irq, rc;
-	hw_regs_t hw;
+	struct ide_hw hw;
 
 	pmif = kzalloc(sizeof(*pmif), GFP_KERNEL);
 	if (pmif == NULL)
@@ -1268,7 +1269,7 @@ pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	void __iomem *base;
 	unsigned long rbase, rlen;
 	int rc;
-	hw_regs_t hw;
+	struct ide_hw hw;
 
 	np = pci_device_to_OF_node(pdev);
 	if (np == NULL) {
diff --git a/drivers/ide/q40ide.c b/drivers/ide/q40ide.c
index c793466..ab49a97 100644
--- a/drivers/ide/q40ide.c
+++ b/drivers/ide/q40ide.c
@@ -51,11 +51,11 @@ static int q40ide_default_irq(unsigned long base)
 /*
  * Addresses are pretranslated for Q40 ISA access.
  */
-static void q40_ide_setup_ports(hw_regs_t *hw, unsigned long base,
+static void q40_ide_setup_ports(struct ide_hw *hw, unsigned long base,
 			ide_ack_intr_t *ack_intr,
 			int irq)
 {
-	memset(hw, 0, sizeof(hw_regs_t));
+	memset(hw, 0, sizeof(*hw));
 	/* BIG FAT WARNING: 
 	   assumption: only DATA port is ever used in 16 bit mode */
 	hw->io_ports.data_addr = Q40_ISA_IO_W(base);
@@ -70,8 +70,6 @@ static void q40_ide_setup_ports(hw_regs_t *hw, unsigned long base,
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;
-
-	hw->chipset = ide_generic;
 }
 
 static void q40ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
@@ -119,6 +117,7 @@ static const struct ide_port_info q40ide_port_info = {
 	.tp_ops			= &q40ide_tp_ops,
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
+	.chipset		= ide_generic,
 };
 
 /* 
@@ -136,7 +135,7 @@ static const char *q40_ide_names[Q40IDE_NUM_HWIFS]={
 static int __init q40ide_init(void)
 {
     int i;
-    hw_regs_t hw[Q40IDE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
+    struct ide_hw hw[Q40IDE_NUM_HWIFS], *hws[] = { NULL, NULL };
 
     if (!MACH_IS_Q40)
       return -ENODEV;
@@ -163,7 +162,7 @@ static int __init q40ide_init(void)
 	hws[i] = &hw[i];
     }
 
-    return ide_host_add(&q40ide_port_info, hws, NULL);
+    return ide_host_add(&q40ide_port_info, hws, Q40IDE_NUM_HWIFS, NULL);
 }
 
 module_init(q40ide_init);
diff --git a/drivers/ide/rapide.c b/drivers/ide/rapide.c
index d5003ca..00f5424 100644
--- a/drivers/ide/rapide.c
+++ b/drivers/ide/rapide.c
@@ -13,9 +13,10 @@
 
 static const struct ide_port_info rapide_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
+	.chipset		= ide_generic,
 };
 
-static void rapide_setup_ports(hw_regs_t *hw, void __iomem *base,
+static void rapide_setup_ports(struct ide_hw *hw, void __iomem *base,
 			       void __iomem *ctrl, unsigned int sz, int irq)
 {
 	unsigned long port = (unsigned long)base;
@@ -35,7 +36,7 @@ rapide_probe(struct expansion_card *ec, const struct ecard_id *id)
 	void __iomem *base;
 	struct ide_host *host;
 	int ret;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 
 	ret = ecard_request_resources(ec);
 	if (ret)
@@ -49,10 +50,9 @@ rapide_probe(struct expansion_card *ec, const struct ecard_id *id)
 
 	memset(&hw, 0, sizeof(hw));
 	rapide_setup_ports(&hw, base, base + 0x818, 1 << 6, ec->irq);
-	hw.chipset = ide_generic;
 	hw.dev = &ec->dev;
 
-	ret = ide_host_add(&rapide_port_info, hws, &host);
+	ret = ide_host_add(&rapide_port_info, hws, 1, &host);
 	if (ret)
 		goto release;
 
diff --git a/drivers/ide/scc_pata.c b/drivers/ide/scc_pata.c
index 5be41f2..1104bb3 100644
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -559,7 +559,7 @@ static int scc_ide_setup_pci_device(struct pci_dev *dev,
 {
 	struct scc_ports *ports = pci_get_drvdata(dev);
 	struct ide_host *host;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 	int i, rc;
 
 	memset(&hw, 0, sizeof(hw));
@@ -567,9 +567,8 @@ static int scc_ide_setup_pci_device(struct pci_dev *dev,
 		hw.io_ports_array[i] = ports->dma + 0x20 + i * 4;
 	hw.irq = dev->irq;
 	hw.dev = &dev->dev;
-	hw.chipset = ide_pci;
 
-	rc = ide_host_add(d, hws, &host);
+	rc = ide_host_add(d, hws, 1, &host);
 	if (rc)
 		return rc;
 
@@ -823,6 +822,7 @@ static const struct ide_port_info scc_chipset __devinitdata = {
 	.host_flags	= IDE_HFLAG_SINGLE,
 	.irq_flags	= IRQF_SHARED,
 	.pio_mask	= ATA_PIO4,
+	.chipset	= ide_pci,
 };
 
 /**
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 7a3a12d..ab3db61 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -1,7 +1,7 @@
 /*
  *  Copyright (C) 1998-2000  Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 1995-1998  Mark Lord
- *  Copyright (C)      2007  Bartlomiej Zolnierkiewicz
+ *  Copyright (C) 2007-2009  Bartlomiej Zolnierkiewicz
  *
  *  May be copied or modified under the terms of the GNU General Public License
  */
@@ -301,11 +301,11 @@ static int ide_pci_check_iomem(struct pci_dev *dev, const struct ide_port_info *
 }
 
 /**
- *	ide_hw_configure	-	configure a hw_regs_t instance
+ *	ide_hw_configure	-	configure a struct ide_hw instance
  *	@dev: PCI device holding interface
  *	@d: IDE port info
  *	@port: port number
- *	@hw: hw_regs_t instance corresponding to this port
+ *	@hw: struct ide_hw instance corresponding to this port
  *
  *	Perform the initial set up for the hardware interface structure. This
  *	is done per interface port rather than per PCI device. There may be
@@ -315,7 +315,7 @@ static int ide_pci_check_iomem(struct pci_dev *dev, const struct ide_port_info *
  */
 
 static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
-			    unsigned int port, hw_regs_t *hw)
+			    unsigned int port, struct ide_hw *hw)
 {
 	unsigned long ctl = 0, base = 0;
 
@@ -344,7 +344,6 @@ static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
 
 	memset(hw, 0, sizeof(*hw));
 	hw->dev = &dev->dev;
-	hw->chipset = d->chipset ? d->chipset : ide_pci;
 	ide_std_init_ports(hw, base, ctl | 2);
 
 	return 0;
@@ -446,8 +445,8 @@ out:
  *	ide_pci_setup_ports	-	configure ports/devices on PCI IDE
  *	@dev: PCI device
  *	@d: IDE port info
- *	@hw: hw_regs_t instances corresponding to this PCI IDE device
- *	@hws: hw_regs_t pointers table to update
+ *	@hw: struct ide_hw instances corresponding to this PCI IDE device
+ *	@hws: struct ide_hw pointers table to update
  *
  *	Scan the interfaces attached to this device and do any
  *	necessary per port setup. Attach the devices and ask the
@@ -459,7 +458,7 @@ out:
  */
 
 void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d,
-			 hw_regs_t *hw, hw_regs_t **hws)
+			 struct ide_hw *hw, struct ide_hw **hws)
 {
 	int channels = (d->host_flags & IDE_HFLAG_SINGLE) ? 1 : 2, port;
 	u8 tmp;
@@ -535,61 +534,15 @@ out:
 	return ret;
 }
 
-int ide_pci_init_one(struct pci_dev *dev, const struct ide_port_info *d,
-		     void *priv)
-{
-	struct ide_host *host;
-	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
-	int ret;
-
-	ret = ide_setup_pci_controller(dev, d, 1);
-	if (ret < 0)
-		goto out;
-
-	ide_pci_setup_ports(dev, d, &hw[0], &hws[0]);
-
-	host = ide_host_alloc(d, hws);
-	if (host == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	host->dev[0] = &dev->dev;
-
-	host->host_priv = priv;
-
-	host->irq_flags = IRQF_SHARED;
-
-	pci_set_drvdata(dev, host);
-
-	ret = do_ide_setup_pci_device(dev, d, 1);
-	if (ret < 0)
-		goto out;
-
-	/* fixup IRQ */
-	if (ide_pci_is_in_compatibility_mode(dev)) {
-		hw[0].irq = pci_get_legacy_ide_irq(dev, 0);
-		hw[1].irq = pci_get_legacy_ide_irq(dev, 1);
-	} else
-		hw[1].irq = hw[0].irq = ret;
-
-	ret = ide_host_register(host, d, hws);
-	if (ret)
-		ide_host_free(host);
-out:
-	return ret;
-}
-EXPORT_SYMBOL_GPL(ide_pci_init_one);
-
 int ide_pci_init_two(struct pci_dev *dev1, struct pci_dev *dev2,
 		     const struct ide_port_info *d, void *priv)
 {
 	struct pci_dev *pdev[] = { dev1, dev2 };
 	struct ide_host *host;
-	int ret, i;
-	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
+	int ret, i, n_ports = dev2 ? 4 : 2;
+	struct ide_hw hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 
-	for (i = 0; i < 2; i++) {
+	for (i = 0; i < n_ports / 2; i++) {
 		ret = ide_setup_pci_controller(pdev[i], d, !i);
 		if (ret < 0)
 			goto out;
@@ -597,23 +550,24 @@ int ide_pci_init_two(struct pci_dev *dev1, struct pci_dev *dev2,
 		ide_pci_setup_ports(pdev[i], d, &hw[i*2], &hws[i*2]);
 	}
 
-	host = ide_host_alloc(d, hws);
+	host = ide_host_alloc(d, hws, n_ports);
 	if (host == NULL) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	host->dev[0] = &dev1->dev;
-	host->dev[1] = &dev2->dev;
+	if (dev2)
+		host->dev[1] = &dev2->dev;
 
 	host->host_priv = priv;
-
 	host->irq_flags = IRQF_SHARED;
 
 	pci_set_drvdata(pdev[0], host);
-	pci_set_drvdata(pdev[1], host);
+	if (dev2)
+		pci_set_drvdata(pdev[1], host);
 
-	for (i = 0; i < 2; i++) {
+	for (i = 0; i < n_ports / 2; i++) {
 		ret = do_ide_setup_pci_device(pdev[i], d, !i);
 
 		/*
@@ -639,6 +593,13 @@ out:
 }
 EXPORT_SYMBOL_GPL(ide_pci_init_two);
 
+int ide_pci_init_one(struct pci_dev *dev, const struct ide_port_info *d,
+		     void *priv)
+{
+	return ide_pci_init_two(dev, NULL, d, priv);
+}
+EXPORT_SYMBOL_GPL(ide_pci_init_one);
+
 void ide_pci_remove(struct pci_dev *dev)
 {
 	struct ide_host *host = pci_get_drvdata(dev);
diff --git a/drivers/ide/sgiioc4.c b/drivers/ide/sgiioc4.c
index e5d2a48..5f37f16 100644
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -91,7 +91,7 @@ typedef struct {
 
 
 static void
-sgiioc4_init_hwif_ports(hw_regs_t * hw, unsigned long data_port,
+sgiioc4_init_hwif_ports(struct ide_hw *hw, unsigned long data_port,
 			unsigned long ctrl_port, unsigned long irq_port)
 {
 	unsigned long reg = data_port;
@@ -546,7 +546,7 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	unsigned long cmd_base, irqport;
 	unsigned long bar0, cmd_phys_base, ctl;
 	void __iomem *virt_base;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 	int rc;
 
 	/*  Get the CmdBlk and CtrlBlk Base Registers */
@@ -575,13 +575,12 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	memset(&hw, 0, sizeof(hw));
 	sgiioc4_init_hwif_ports(&hw, cmd_base, ctl, irqport);
 	hw.irq = dev->irq;
-	hw.chipset = ide_pci;
 	hw.dev = &dev->dev;
 
 	/* Initializing chipset IRQ Registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
-	rc = ide_host_add(&sgiioc4_port_info, hws, NULL);
+	rc = ide_host_add(&sgiioc4_port_info, hws, 1, NULL);
 	if (!rc)
 		return 0;
 
diff --git a/drivers/ide/siimage.c b/drivers/ide/siimage.c
index e4973cd..bd82d22 100644
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -451,8 +451,8 @@ static int sil_sata_reset_poll(ide_drive_t *drive)
 static void sil_sata_pre_reset(ide_drive_t *drive)
 {
 	if (drive->media == ide_disk) {
-		drive->special.b.set_geometry = 0;
-		drive->special.b.recalibrate = 0;
+		drive->special_flags &=
+			~(IDE_SFLAG_SET_GEOMETRY | IDE_SFLAG_RECALIBRATE);
 	}
 }
 
diff --git a/drivers/ide/sl82c105.c b/drivers/ide/sl82c105.c
index b0a4606..0924abf 100644
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -10,7 +10,7 @@
  * with the timing registers setup.
  *  -- Benjamin Herrenschmidt (01/11/03) benh@kernel.crashing.org
  *
- * Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
+ * Copyright (C) 2006-2007,2009 MontaVista Software, Inc. <source@mvista.com>
  * Copyright (C)      2007 Bartlomiej Zolnierkiewicz
  */
 
@@ -146,14 +146,15 @@ static void sl82c105_dma_lost_irq(ide_drive_t *drive)
 	u32 val, mask		= hwif->channel ? CTRL_IDE_IRQB : CTRL_IDE_IRQA;
 	u8 dma_cmd;
 
-	printk("sl82c105: lost IRQ, resetting host\n");
+	printk(KERN_WARNING "sl82c105: lost IRQ, resetting host\n");
 
 	/*
 	 * Check the raw interrupt from the drive.
 	 */
 	pci_read_config_dword(dev, 0x40, &val);
 	if (val & mask)
-		printk("sl82c105: drive was requesting IRQ, but host lost it\n");
+		printk(KERN_INFO "sl82c105: drive was requesting IRQ, "
+		       "but host lost it\n");
 
 	/*
 	 * Was DMA enabled?  If so, disable it - we're resetting the
@@ -162,7 +163,7 @@ static void sl82c105_dma_lost_irq(ide_drive_t *drive)
 	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	if (dma_cmd & 1) {
 		outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
-		printk("sl82c105: DMA was enabled\n");
+		printk(KERN_INFO "sl82c105: DMA was enabled\n");
 	}
 
 	sl82c105_reset_host(dev);
diff --git a/drivers/ide/tx4938ide.c b/drivers/ide/tx4938ide.c
index e33d764..ea89fdd 100644
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -130,8 +130,7 @@ static const struct ide_port_info tx4938ide_port_info __initdata = {
 
 static int __init tx4938ide_probe(struct platform_device *pdev)
 {
-	hw_regs_t hw;
-	hw_regs_t *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 	struct ide_host *host;
 	struct resource *res;
 	struct tx4938ide_platform_info *pdata = pdev->dev.platform_data;
@@ -183,7 +182,7 @@ static int __init tx4938ide_probe(struct platform_device *pdev)
 		tx4938ide_tune_ebusc(pdata->ebus_ch, pdata->gbus_clock, 0);
 	else
 		d.port_ops = NULL;
-	ret = ide_host_add(&d, hws, &host);
+	ret = ide_host_add(&d, hws, 1, &host);
 	if (!ret)
 		platform_set_drvdata(pdev, host);
 	return ret;
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index 5ca7622..64b58ec 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -537,8 +537,7 @@ static const struct ide_port_info tx4939ide_port_info __initdata = {
 
 static int __init tx4939ide_probe(struct platform_device *pdev)
 {
-	hw_regs_t hw;
-	hw_regs_t *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_hw hw, *hws[] = { &hw };
 	struct ide_host *host;
 	struct resource *res;
 	int irq, ret;
@@ -581,7 +580,7 @@ static int __init tx4939ide_probe(struct platform_device *pdev)
 	hw.dev = &pdev->dev;
 
 	pr_info("TX4939 IDE interface (base %#lx, irq %d)\n", mapbase, irq);
-	host = ide_host_alloc(&tx4939ide_port_info, hws);
+	host = ide_host_alloc(&tx4939ide_port_info, hws, 1);
 	if (!host)
 		return -ENOMEM;
 	/* use extra_base for base address of the all registers */
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 0af3608..1a9c787 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -556,27 +556,49 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 
 	/* add partitions */
 	for (p = 1; p < state->limit; p++) {
-		sector_t size = state->parts[p].size;
-		sector_t from = state->parts[p].from;
+		sector_t size, from;
+try_scan:
+		size = state->parts[p].size;
 		if (!size)
 			continue;
+
+		from = state->parts[p].from;
 		if (from >= get_capacity(disk)) {
 			printk(KERN_WARNING
 			       "%s: p%d ignored, start %llu is behind the end of the disk\n",
 			       disk->disk_name, p, (unsigned long long) from);
 			continue;
 		}
+
 		if (from + size > get_capacity(disk)) {
-			/*
-			 * we can not ignore partitions of broken tables
-			 * created by for example camera firmware, but we
-			 * limit them to the end of the disk to avoid
-			 * creating invalid block devices
-			 */
+			struct block_device_operations *bdops = disk->fops;
+			unsigned long long capacity;
+
 			printk(KERN_WARNING
-			       "%s: p%d size %llu limited to end of disk\n",
+			       "%s: p%d size %llu exceeds device capacity, ",
 			       disk->disk_name, p, (unsigned long long) size);
-			size = get_capacity(disk) - from;
+
+			if (bdops->set_capacity &&
+			    (disk->flags & GENHD_FL_NATIVE_CAPACITY) == 0) {
+				printk(KERN_CONT "enabling native capacity\n");
+				capacity = bdops->set_capacity(disk, ~0ULL);
+				disk->flags |= GENHD_FL_NATIVE_CAPACITY;
+				if (capacity > get_capacity(disk)) {
+					set_capacity(disk, capacity);
+					check_disk_size_change(disk, bdev);
+					bdev->bd_invalidated = 0;
+				}
+				goto try_scan;
+			} else {
+				/*
+				 * we can not ignore partitions of broken tables
+				 * created by for example camera firmware, but
+				 * we limit them to the end of the disk to avoid
+				 * creating invalid block devices
+				 */
+				printk(KERN_CONT "limited to end of disk\n");
+				size = get_capacity(disk) - from;
+			}
 		}
 		part = add_partition(disk, p, from, size,
 				     state->parts[p].flags);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ebdfde8..0b1a6ca 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1226,6 +1226,8 @@ struct block_device_operations {
 	int (*direct_access) (struct block_device *, sector_t,
 						void **, unsigned long *);
 	int (*media_changed) (struct gendisk *);
+	unsigned long long (*set_capacity) (struct gendisk *,
+						unsigned long long);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
 	struct module *owner;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 149fda2..7cbd38d 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -114,6 +114,7 @@ struct hd_struct {
 #define GENHD_FL_UP				16
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
 #define GENHD_FL_EXT_DEVT			64 /* allow extended devt */
+#define GENHD_FL_NATIVE_CAPACITY		128
 
 #define BLK_SCSI_MAX_CMDS	(256)
 #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 867cb68..a6c6a2f 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -178,7 +178,7 @@ typedef u8 hwif_chipset_t;
 /*
  * Structure to hold all information about the location of this port
  */
-typedef struct hw_regs_s {
+struct ide_hw {
 	union {
 		struct ide_io_ports	io_ports;
 		unsigned long		io_ports_array[IDE_NR_PORTS];
@@ -186,12 +186,11 @@ typedef struct hw_regs_s {
 
 	int		irq;			/* our irq number */
 	ide_ack_intr_t	*ack_intr;		/* acknowledge interrupt */
-	hwif_chipset_t  chipset;
 	struct device	*dev, *parent;
 	unsigned long	config;
-} hw_regs_t;
+};
 
-static inline void ide_std_init_ports(hw_regs_t *hw,
+static inline void ide_std_init_ports(struct ide_hw *hw,
 				      unsigned long io_addr,
 				      unsigned long ctl_addr)
 {
@@ -218,21 +217,12 @@ static inline void ide_std_init_ports(hw_regs_t *hw,
 
 /*
  * Special Driver Flags
- *
- * set_geometry	: respecify drive geometry
- * recalibrate	: seek to cyl 0
- * set_multmode	: set multmode count
- * reserved	: unused
  */
-typedef union {
-	unsigned all			: 8;
-	struct {
-		unsigned set_geometry	: 1;
-		unsigned recalibrate	: 1;
-		unsigned set_multmode	: 1;
-		unsigned reserved	: 5;
-	} b;
-} special_t;
+enum {
+	IDE_SFLAG_SET_GEOMETRY		= (1 << 0),
+	IDE_SFLAG_RECALIBRATE		= (1 << 1),
+	IDE_SFLAG_SET_MULTMODE		= (1 << 2),
+};
 
 /*
  * Status returned from various ide_ functions
@@ -391,6 +381,7 @@ struct ide_drive_s;
 struct ide_disk_ops {
 	int		(*check)(struct ide_drive_s *, const char *);
 	int		(*get_capacity)(struct ide_drive_s *);
+	u64		(*set_capacity)(struct ide_drive_s *, u64);
 	void		(*setup)(struct ide_drive_s *);
 	void		(*flush)(struct ide_drive_s *);
 	int		(*init_media)(struct ide_drive_s *, struct gendisk *);
@@ -468,6 +459,8 @@ enum {
 	IDE_DFLAG_NICE1			= (1 << 5),
 	/* device is physically present */
 	IDE_DFLAG_PRESENT		= (1 << 6),
+	/* disable Host Protected Area */
+	IDE_DFLAG_NOHPA			= (1 << 7),
 	/* id read from device (synthetic if not set) */
 	IDE_DFLAG_ID_READ		= (1 << 8),
 	IDE_DFLAG_NOPROBE		= (1 << 9),
@@ -506,6 +499,7 @@ enum {
 	/* write protect */
 	IDE_DFLAG_WP			= (1 << 29),
 	IDE_DFLAG_FORMAT_IN_PROGRESS	= (1 << 30),
+	IDE_DFLAG_NIEN_QUIRK		= (1 << 31),
 };
 
 struct ide_drive_s {
@@ -530,14 +524,13 @@ struct ide_drive_s {
 	unsigned long sleep;		/* sleep until this time */
 	unsigned long timeout;		/* max time to wait for irq */
 
-	special_t	special;	/* special action flags */
+	u8	special_flags;		/* special action flags */
 
 	u8	select;			/* basic drive/head select reg value */
 	u8	retry_pio;		/* retrying dma capable host in pio */
 	u8	waiting_for_dma;	/* dma currently in progress */
 	u8	dma;			/* atapi dma flag */
 
-        u8	quirk_list;	/* considered quirky, set for a specific host */
         u8	init_speed;	/* transfer rate set at boot */
         u8	current_speed;	/* current transfer rate set */
 	u8	desired_speed;	/* desired transfer rate set */
@@ -562,8 +555,7 @@ struct ide_drive_s {
 	unsigned int	drive_data;	/* used by set_pio_mode/dev_select() */
 	unsigned int	failures;	/* current failure count */
 	unsigned int	max_failures;	/* maximum allowed failure count */
-	u64		probed_capacity;/* initial reported media capacity (ide-cd only currently) */
-
+	u64		probed_capacity;/* initial/native media capacity */
 	u64		capacity64;	/* total number of sectors */
 
 	int		lun;		/* logical unit */
@@ -1222,7 +1214,7 @@ static inline int ide_pci_is_in_compatibility_mode(struct pci_dev *dev)
 }
 
 void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *,
-			 hw_regs_t *, hw_regs_t **);
+			 struct ide_hw *, struct ide_hw **);
 void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
@@ -1461,16 +1453,18 @@ static inline void ide_acpi_set_state(ide_hwif_t *hwif, int on) {}
 void ide_register_region(struct gendisk *);
 void ide_unregister_region(struct gendisk *);
 
+void ide_check_nien_quirk_list(ide_drive_t *);
 void ide_undecoded_slave(ide_drive_t *);
 
 void ide_port_apply_params(ide_hwif_t *);
 int ide_sysfs_register_port(ide_hwif_t *);
 
-struct ide_host *ide_host_alloc(const struct ide_port_info *, hw_regs_t **);
+struct ide_host *ide_host_alloc(const struct ide_port_info *, struct ide_hw **,
+				unsigned int);
 void ide_host_free(struct ide_host *);
 int ide_host_register(struct ide_host *, const struct ide_port_info *,
-		      hw_regs_t **);
-int ide_host_add(const struct ide_port_info *, hw_regs_t **,
+		      struct ide_hw **);
+int ide_host_add(const struct ide_port_info *, struct ide_hw **, unsigned int,
 		 struct ide_host **);
 void ide_host_remove(struct ide_host *);
 int ide_legacy_device_add(const struct ide_port_info *, unsigned long);
