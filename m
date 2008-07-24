Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbYGXVsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbYGXVsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 17:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYGXVsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 17:48:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:40083 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYGXVrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 17:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=cR/SccmoUip9CNcLfr5fHDcbGUuB0ggbcbF+cRpZWmoBp2PLq7bUN5Poe6aI++Vtnz
         uCrnd3REV4kRvup29y8dFyK3qt4BL6Ip3TG+zIX6C+BnrjF/YGOYBgl41DSndbHBORVM
         mkiNdhm8O3RzrxtDI/409JxdYHEDYaSHTe8fA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates (part 4)
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Thu, 24 Jul 2008 23:39:46 +0200
Message-Id: <200807242339.47098.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

The last big update for .27, highlights:

* ide-cd fix for fs/buffer.c oops when using growisofs from Jens Axboe
  (also thanks to numerous people involved in fixing it).

* Allow unloading of PCI host driver modules (after fixing core code).

* UDMA100 support for Palm BK3710 from Sergei Shtylyov.

* Prefix messages from PCI host drivers by driver name & PCI device name.

* ide-scsi blk_{get,put}_request() conversion from FUJITA Tomonori.

* More sparse fixes from Harvey Harrison.

* ht6560b update from Jan Evert van Grootheest.

* Scale down <asm/ide.h> (it is now officially on its way out).

* Misc fixes/cleanups.


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig                 |    2 +-
 drivers/ide/Makefile                |    9 +-
 drivers/ide/arm/icside.c            |    6 +
 drivers/ide/arm/palm_bk3710.c       |    9 +-
 drivers/ide/arm/rapide.c            |    6 +
 drivers/ide/ide-cd.c                |   39 +++++-
 drivers/ide/ide-disk.c              |   12 ++-
 drivers/ide/ide-dma.c               |    2 +-
 drivers/ide/ide-floppy.c            |   12 ++-
 drivers/ide/ide-generic.c           |   36 +++++-
 drivers/ide/ide-iops.c              |    6 +-
 drivers/ide/ide-probe.c             |   71 +++++-----
 drivers/ide/ide-proc.c              |    4 +-
 drivers/ide/ide-tape.c              |   32 +++--
 drivers/ide/ide-taskfile.c          |   12 ++-
 drivers/ide/ide.c                   |   47 +++++++
 drivers/ide/legacy/gayle.c          |    8 +-
 drivers/ide/legacy/ht6560b.c        |   24 +----
 drivers/ide/pci/aec62xx.c           |   76 +++++++----
 drivers/ide/pci/alim15x3.c          |   18 ++-
 drivers/ide/pci/amd74xx.c           |  155 +++++++++++------------
 drivers/ide/pci/atiixp.c            |   20 ++-
 drivers/ide/pci/cmd64x.c            |   50 +++----
 drivers/ide/pci/cs5520.c            |   24 ++--
 drivers/ide/pci/cs5530.c            |   20 ++-
 drivers/ide/pci/cs5535.c            |   13 ++-
 drivers/ide/pci/cy82c693.c          |   35 ++++-
 drivers/ide/pci/generic.c           |   78 ++++++------
 drivers/ide/pci/hpt34x.c            |   21 ++-
 drivers/ide/pci/hpt366.c            |  183 +++++++++++++--------------
 drivers/ide/pci/it8213.c            |   35 +++---
 drivers/ide/pci/it821x.c            |   74 +++++++-----
 drivers/ide/pci/jmicron.c           |   13 ++-
 drivers/ide/pci/ns87415.c           |   13 ++-
 drivers/ide/pci/opti621.c           |   13 ++-
 drivers/ide/pci/pdc202xx_new.c      |   78 +++++++-----
 drivers/ide/pci/pdc202xx_old.c      |   49 ++++---
 drivers/ide/pci/piix.c              |  118 ++++++++---------
 drivers/ide/pci/rz1000.c            |   13 ++-
 drivers/ide/pci/sc1200.c            |   50 ++++---
 drivers/ide/pci/serverworks.c       |   40 ++++--
 drivers/ide/pci/siimage.c           |  161 ++++++++++++++----------
 drivers/ide/pci/sis5513.c           |   39 ++++--
 drivers/ide/pci/sl82c105.c          |   17 ++-
 drivers/ide/pci/slc90e66.c          |   13 ++-
 drivers/ide/pci/tc86c001.c          |   57 ++++++--
 drivers/ide/pci/triflex.c           |   13 ++-
 drivers/ide/pci/trm290.c            |   17 ++-
 drivers/ide/pci/via82cxxx.c         |  139 +++++++++++---------
 drivers/ide/setup-pci.c             |  240 +++++++++++++++++++++++------------
 drivers/scsi/ide-scsi.c             |   33 +++--
 include/asm-alpha/ide.h             |   44 -------
 include/asm-arm/ide.h               |    4 -
 include/asm-blackfin/ide.h          |   27 ----
 include/asm-cris/arch-v10/ide.h     |   91 -------------
 include/asm-cris/arch-v32/ide.h     |   56 --------
 include/asm-cris/ide.h              |    1 -
 include/asm-frv/ide.h               |    4 -
 include/asm-h8300/ide.h             |   26 ----
 include/asm-ia64/ide.h              |   51 --------
 include/asm-m32r/ide.h              |   70 ----------
 include/asm-m68k/ide.h              |    4 -
 include/asm-mips/mach-generic/ide.h |   48 -------
 include/asm-mn10300/ide.h           |    4 -
 include/asm-parisc/ide.h            |    4 -
 include/asm-powerpc/ide.h           |   26 ----
 include/asm-sh/ide.h                |   21 ---
 include/asm-sparc/ide.h             |    3 -
 include/asm-x86/ide.h               |   65 ----------
 include/asm-xtensa/ide.h            |   35 -----
 include/linux/ide.h                 |   32 ++++-
 71 files changed, 1397 insertions(+), 1474 deletions(-)
 delete mode 100644 include/asm-alpha/ide.h
 delete mode 100644 include/asm-blackfin/ide.h
 delete mode 100644 include/asm-cris/arch-v10/ide.h
 delete mode 100644 include/asm-cris/arch-v32/ide.h
 delete mode 100644 include/asm-cris/ide.h
 delete mode 100644 include/asm-h8300/ide.h
 delete mode 100644 include/asm-ia64/ide.h
 delete mode 100644 include/asm-m32r/ide.h
 delete mode 100644 include/asm-sh/ide.h
 delete mode 100644 include/asm-x86/ide.h
 delete mode 100644 include/asm-xtensa/ide.h


Bartlomiej Zolnierkiewicz (69):
      ide: always call ->init_chipset method in do_ide_setup_pci_device()
      ide: respect dev->irq in do_ide_setup_pci_device() also if 'tried_config'
      ide: move ide_setup_pci_controller() call to ide_setup_pci_device[s]()
      ide: call ide_pci_setup_ports() before do_ide_setup_pci_device()
      ide: add ->dev and ->host_priv fields to struct ide_host
      ide: add ide_device_{get,put}() helpers
      aec62xx: convert to use ->host_priv
      hpt366: convert to use ->host_priv
      it821x: convert to use ->host_priv
      sc1200: convert to use ->host_priv
      siimage: convert to use ->host_priv
      via82cxxx: convert to use ->host_priv
      tc86c001: remove ->init_chipset method
      amd74xx: cleanup ->init_chipset method
      cmd64x: cleanup ->init_chipset method
      via82cxxx: cleanup ->init_chipset method
      ide: add ide_pci_remove() helper
      aec62xx: add ->remove method and module_exit()
      alim15x3: add ->remove method and module_exit()
      amd74xx: add ->remove method and module_exit()
      atiixp: add ->remove method and module_exit()
      cmd64x: add ->remove method and module_exit()
      cs5530: add ->remove method and module_exit()
      cs5535: add ->remove method and module_exit()
      cy82c693: add ->remove method and module_exit()
      ide/pci/generic: add ->remove method and module_exit()
      hpt34x: add ->remove method and module_exit()
      hpt366: add ->remove method and module_exit()
      it8213: add ->remove method and module_exit()
      it821x: add ->remove method and module_exit()
      jmicron: add ->remove method and module_exit()
      ns87415: add ->remove method and module_exit()
      opti621: add ->remove method and module_exit()
      pdc202xx_new: add ->remove method and module_exit()
      pdc202xx_old: add ->remove method and module_exit()
      piix: add ->remove method and module_exit()
      rz1000: add ->remove method and module_exit()
      sc1200: add ->remove method and module_exit()
      serverworks: add ->remove method and module_exit()
      siimage: add ->remove method and module_exit()
      sis5513: add ->remove method and module_exit()
      sl82c105: add ->remove method and module_exit()
      slc90e66: add ->remove method and module_exit()
      tc86c001: add ->remove method and module_exit()
      triflex: add ->remove method and module_exit()
      trm290: add ->remove method and module_exit()
      via82cxxx: add ->remove method and module_exit()
      icside: add module_exit()
      rapide: add module_exit()
      ide: fix <asm-xtensa/ide.h>
      ide-generic: fix ide_default_io_base() for m32r
      ide-generic: minor fix for mips
      ide-generic: remove "no_pci_devices()" quirk from ide_default_io_base()
      ide: remove <asm-cris/ide.h>
      ide: define MAX_HWIFS in <linux/ide.h>
      ide-generic: remove broken PPC_PREP support
      ide-generic: is no longer needed on ppc32
      ide-generic: remove ide_default_{io_base,irq}() inlines (take 3)
      ide: remove <asm/ide.h> for some archs
      ide: include PCI device name in messages from IDE PCI host drivers
      it8213: remove DECLARE_ITE_DEV() macro
      it821x: remove DECLARE_ITE_DEV() macro
      ide: prefix messages from IDE PCI host drivers by driver name
      ide: drop 'name' parameter from ->init_chipset method
      gayle: release resources on ide_host_add() failure
      ide: enable local IRQs in all handlers for TASKFILE_NO_DATA data phase
      ide: remove stale comments from drivers/ide/Makefile
      ide: fix for EATA SCSI HBA in ATA emulating mode
      ide: use proper printk() KERN_* levels in ide-probe.c

FUJITA Tomonori (1):
      ide-scsi: remove kmalloced struct request

Harvey Harrison (2):
      ide: ide-tape.c sparse annotations and unaligned access removal
      ide: trivial sparse annotations

Jan Evert van Grootheest (2):
      ht6560b: update email address
      ht6560b: remove old history

Jens Axboe (1):
      ide-cd: fix oops when using growisofs

Sergei Shtylyov (1):
      palm_bk3710: add UltraDMA/100 support


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 04d9c4d..130ef64 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -314,7 +314,7 @@ comment "IDE chipset support/bugfixes"
 
 config IDE_GENERIC
 	tristate "generic/default IDE chipset support"
-	depends on ALPHA || X86 || IA64 || M32R || MIPS || PPC32
+	depends on ALPHA || X86 || IA64 || M32R || MIPS
 	help
 	  If unsure, say N.
 
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 5d414e3..64e0ecd 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -1,13 +1,6 @@
 #
-# Makefile for the kernel ata, atapi, and ide block device drivers.
-#
-# 12 September 2000, Bartlomiej Zolnierkiewicz <bkz@linux-ide.org>
-# Rewritten to use lists instead of if-statements.
-#
-# Note : at this point, these files are compiled on all systems.
-# In the future, some of these should be built conditionally.
-#
 # link order is important here
+#
 
 EXTRA_CFLAGS				+= -Idrivers/ide
 
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index f575e83..df4af40 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -710,8 +710,14 @@ static int __init icside_init(void)
 	return ecard_register_driver(&icside_driver);
 }
 
+static void __exit icside_exit(void);
+{
+	ecard_unregister_driver(&icside_driver);
+}
+
 MODULE_AUTHOR("Russell King <rmk@arm.linux.org.uk>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ICS IDE driver");
 
 module_init(icside_init);
+module_exit(icside_exit);
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index 65bb4b8..3e842d6 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -82,6 +82,7 @@ static const struct palm_bk3710_udmatiming palm_bk3710_udmatimings[6] = {
 	{100, 120},		/* UDMA Mode 2 */
 	{100, 90},		/* UDMA Mode 3 */
 	{100, 60},		/* UDMA Mode 4 */
+	{85,  40},		/* UDMA Mode 5 */
 };
 
 static void palm_bk3710_setudmamode(void __iomem *base, unsigned int dev,
@@ -334,12 +335,11 @@ static const struct ide_port_ops palm_bk3710_ports_ops = {
 	.cable_detect		= palm_bk3710_cable_detect,
 };
 
-static const struct ide_port_info __devinitdata palm_bk3710_port_info = {
+static struct ide_port_info __devinitdata palm_bk3710_port_info = {
 	.init_dma		= palm_bk3710_init_dma,
 	.port_ops		= &palm_bk3710_ports_ops,
 	.host_flags		= IDE_HFLAG_MMIO,
 	.pio_mask		= ATA_PIO4,
-	.udma_mask		= ATA_UDMA4,	/* (input clk 99MHz) */
 	.mwdma_mask		= ATA_MWDMA2,
 };
 
@@ -352,7 +352,7 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 	int i, rc;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
-	clk = clk_get(NULL, "IDECLK");
+	clk = clk_get(&pdev->dev, "IDECLK");
 	if (IS_ERR(clk))
 		return -ENODEV;
 
@@ -392,6 +392,9 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 	hw.irq = irq->start;
 	hw.chipset = ide_palm3710;
 
+	palm_bk3710_port_info.udma_mask = rate < 100000000 ? ATA_UDMA4 :
+							     ATA_UDMA5;
+
 	rc = ide_host_add(&palm_bk3710_port_info, hws, NULL);
 	if (rc)
 		goto out;
diff --git a/drivers/ide/arm/rapide.c b/drivers/ide/arm/rapide.c
index 2bdd8b7..78d27d9 100644
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -95,7 +95,13 @@ static int __init rapide_init(void)
 	return ecard_register_driver(&rapide_driver);
 }
 
+static void __exit rapide_exit(void)
+{
+	ecard_unregister_driver(&rapide_driver);
+}
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Yellowstone RAPIDE driver");
 
 module_init(rapide_init);
+module_exit(rapide_exit);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 4e73aee..e617cf0 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -57,23 +57,29 @@ static DEFINE_MUTEX(idecd_ref_mutex);
 #define ide_cd_g(disk) \
 	container_of((disk)->private_data, struct cdrom_info, driver)
 
+static void ide_cd_release(struct kref *);
+
 static struct cdrom_info *ide_cd_get(struct gendisk *disk)
 {
 	struct cdrom_info *cd = NULL;
 
 	mutex_lock(&idecd_ref_mutex);
 	cd = ide_cd_g(disk);
-	if (cd)
+	if (cd) {
 		kref_get(&cd->kref);
+		if (ide_device_get(cd->drive)) {
+			kref_put(&cd->kref, ide_cd_release);
+			cd = NULL;
+		}
+	}
 	mutex_unlock(&idecd_ref_mutex);
 	return cd;
 }
 
-static void ide_cd_release(struct kref *);
-
 static void ide_cd_put(struct cdrom_info *cd)
 {
 	mutex_lock(&idecd_ref_mutex);
+	ide_device_put(cd->drive);
 	kref_put(&cd->kref, ide_cd_release);
 	mutex_unlock(&idecd_ref_mutex);
 }
@@ -1305,13 +1311,30 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 
 	stat = ide_cd_queue_pc(drive, cmd, 0, &capbuf, &len, sense, 0,
 			       REQ_QUIET);
-	if (stat == 0) {
-		*capacity = 1 + be32_to_cpu(capbuf.lba);
-		*sectors_per_frame =
-			be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
+	if (stat)
+		return stat;
+
+	/*
+	 * Sanity check the given block size
+	 */
+	switch (capbuf.blocklen) {
+	case __constant_cpu_to_be32(512):
+	case __constant_cpu_to_be32(1024):
+	case __constant_cpu_to_be32(2048):
+	case __constant_cpu_to_be32(4096):
+		break;
+	default:
+		printk(KERN_ERR "%s: weird block size %u\n",
+			drive->name, capbuf.blocklen);
+		printk(KERN_ERR "%s: default to 2kb block size\n",
+			drive->name);
+		capbuf.blocklen = __constant_cpu_to_be32(2048);
+		break;
 	}
 
-	return stat;
+	*capacity = 1 + be32_to_cpu(capbuf.lba);
+	*sectors_per_frame = be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
+	return 0;
 }
 
 static int cdrom_read_tocentry(ide_drive_t *drive, int trackno, int msf_flag,
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index df5fe57..28d85b4 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -56,23 +56,29 @@ static DEFINE_MUTEX(idedisk_ref_mutex);
 #define ide_disk_g(disk) \
 	container_of((disk)->private_data, struct ide_disk_obj, driver)
 
+static void ide_disk_release(struct kref *);
+
 static struct ide_disk_obj *ide_disk_get(struct gendisk *disk)
 {
 	struct ide_disk_obj *idkp = NULL;
 
 	mutex_lock(&idedisk_ref_mutex);
 	idkp = ide_disk_g(disk);
-	if (idkp)
+	if (idkp) {
 		kref_get(&idkp->kref);
+		if (ide_device_get(idkp->drive)) {
+			kref_put(&idkp->kref, ide_disk_release);
+			idkp = NULL;
+		}
+	}
 	mutex_unlock(&idedisk_ref_mutex);
 	return idkp;
 }
 
-static void ide_disk_release(struct kref *);
-
 static void ide_disk_put(struct ide_disk_obj *idkp)
 {
 	mutex_lock(&idedisk_ref_mutex);
+	ide_device_put(idkp->drive);
 	kref_put(&idkp->kref, ide_disk_release);
 	mutex_unlock(&idedisk_ref_mutex);
 }
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index be99d46..71c377a 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -173,7 +173,7 @@ EXPORT_SYMBOL_GPL(ide_build_sglist);
 int ide_build_dmatable (ide_drive_t *drive, struct request *rq)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	unsigned int *table	= hwif->dmatable_cpu;
+	__le32 *table = (__le32 *)hwif->dmatable_cpu;
 	unsigned int is_trm290	= (hwif->chipset == ide_trm290) ? 1 : 0;
 	unsigned int count = 0;
 	int i;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 3d8e6dd..ca11a26 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -158,23 +158,29 @@ static DEFINE_MUTEX(idefloppy_ref_mutex);
 #define ide_floppy_g(disk) \
 	container_of((disk)->private_data, struct ide_floppy_obj, driver)
 
+static void idefloppy_cleanup_obj(struct kref *);
+
 static struct ide_floppy_obj *ide_floppy_get(struct gendisk *disk)
 {
 	struct ide_floppy_obj *floppy = NULL;
 
 	mutex_lock(&idefloppy_ref_mutex);
 	floppy = ide_floppy_g(disk);
-	if (floppy)
+	if (floppy) {
 		kref_get(&floppy->kref);
+		if (ide_device_get(floppy->drive)) {
+			kref_put(&floppy->kref, idefloppy_cleanup_obj);
+			floppy = NULL;
+		}
+	}
 	mutex_unlock(&idefloppy_ref_mutex);
 	return floppy;
 }
 
-static void idefloppy_cleanup_obj(struct kref *);
-
 static void ide_floppy_put(struct ide_floppy_obj *floppy)
 {
 	mutex_lock(&idefloppy_ref_mutex);
+	ide_device_put(floppy->drive);
 	kref_put(&floppy->kref, idefloppy_cleanup_obj);
 	mutex_unlock(&idefloppy_ref_mutex);
 }
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 31d98fe..8fe8b5b 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -20,6 +20,11 @@
 #include <linux/module.h>
 #include <linux/ide.h>
 
+/* FIXME: convert m32r to use ide_platform host driver */
+#ifdef CONFIG_M32R
+#include <asm/m32r.h>
+#endif
+
 #define DRV_NAME	"ide_generic"
 
 static int probe_mask = 0x03;
@@ -80,6 +85,21 @@ static int __init ide_generic_sysfs_init(void)
 	return 0;
 }
 
+#if defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_MAPPI2) \
+	|| defined(CONFIG_PLAT_OPSPUT)
+static const u16 legacy_bases[] = { 0x1f0 };
+static const int legacy_irqs[]  = { PLD_IRQ_CFIREQ };
+#elif defined(CONFIG_PLAT_MAPPI3)
+static const u16 legacy_bases[] = { 0x1f0, 0x170 };
+static const int legacy_irqs[]  = { PLD_IRQ_CFIREQ, PLD_IRQ_IDEIREQ };
+#elif defined(CONFIG_ALPHA)
+static const u16 legacy_bases[] = { 0x1f0, 0x170, 0x1e8, 0x168 };
+static const int legacy_irqs[]  = { 14, 15, 11, 10 };
+#else
+static const u16 legacy_bases[] = { 0x1f0, 0x170, 0x1e8, 0x168, 0x1e0, 0x160 };
+static const int legacy_irqs[]  = { 14, 15, 11, 10, 8, 12 };
+#endif
+
 static int __init ide_generic_init(void)
 {
 	hw_regs_t hw[MAX_HWIFS], *hws[MAX_HWIFS];
@@ -87,11 +107,17 @@ static int __init ide_generic_init(void)
 	unsigned long io_addr;
 	int i, rc;
 
+#ifdef CONFIG_MIPS
+	if (!ide_probe_legacy())
+		return -ENODEV;
+#endif
 	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
 			 "parameter for probing all legacy ISA IDE ports\n");
 
-	for (i = 0; i < MAX_HWIFS; i++) {
-		io_addr = ide_default_io_base(i);
+	memset(hws, 0, sizeof(hw_regs_t *) * MAX_HWIFS);
+
+	for (i = 0; i < ARRAY_SIZE(legacy_bases); i++) {
+		io_addr = legacy_bases[i];
 
 		hws[i] = NULL;
 
@@ -113,7 +139,11 @@ static int __init ide_generic_init(void)
 
 			memset(&hw[i], 0, sizeof(hw[i]));
 			ide_std_init_ports(&hw[i], io_addr, io_addr + 0x206);
-			hw[i].irq = ide_default_irq(io_addr);
+#ifdef CONFIG_IA64
+			hw[i].irq = isa_irq_to_vector(legacy_irqs[i]);
+#else
+			hw[i].irq = legacy_irqs[i];
+#endif
 			hw[i].chipset = ide_generic;
 
 			hws[i] = &hw[i];
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 07da5fb..8aae917 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -510,10 +510,8 @@ void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
 
 	if (byteswap) {
 		/* convert from big-endian to host byte order */
-		for (p = end ; p != s;) {
-			unsigned short *pp = (unsigned short *) (p -= 2);
-			*pp = ntohs(*pp);
-		}
+		for (p = end ; p != s;)
+			be16_to_cpus((u16 *)(p -= 2));
 	}
 	/* strip leading blanks */
 	while (s != end && *s == ' ')
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 4aa76c4..994e410 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -134,18 +134,6 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 #endif
 	ide_fix_driveid(id);
 
-#if defined (CONFIG_SCSI_EATA_PIO) || defined (CONFIG_SCSI_EATA)
-	/*
-	 * EATA SCSI controllers do a hardware ATA emulation:
-	 * Ignore them if there is a driver for them available.
-	 */
-	if ((id->model[0] == 'P' && id->model[1] == 'M') ||
-	    (id->model[0] == 'S' && id->model[1] == 'K')) {
-		printk("%s: EATA SCSI HBA %.10s\n", drive->name, id->model);
-		goto err_misc;
-	}
-#endif /* CONFIG_SCSI_EATA || CONFIG_SCSI_EATA_PIO */
-
 	/*
 	 *  WIN_IDENTIFY returns little-endian info,
 	 *  WIN_PIDENTIFY *usually* returns little-endian info.
@@ -167,7 +155,8 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 	if (strstr(id->model, "E X A B Y T E N E S T"))
 		goto err_misc;
 
-	printk("%s: %s, ", drive->name, id->model);
+	printk(KERN_INFO "%s: %s, ", drive->name, id->model);
+
 	drive->present = 1;
 	drive->dead = 0;
 
@@ -176,16 +165,17 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 	 */
 	if (cmd == WIN_PIDENTIFY) {
 		u8 type = (id->config >> 8) & 0x1f;
-		printk("ATAPI ");
+
+		printk(KERN_CONT "ATAPI ");
 		switch (type) {
 			case ide_floppy:
 				if (!strstr(id->model, "CD-ROM")) {
 					if (!strstr(id->model, "oppy") &&
 					    !strstr(id->model, "poyp") &&
 					    !strstr(id->model, "ZIP"))
-						printk("cdrom or floppy?, assuming ");
+						printk(KERN_CONT "cdrom or floppy?, assuming ");
 					if (drive->media != ide_cdrom) {
-						printk ("FLOPPY");
+						printk(KERN_CONT "FLOPPY");
 						drive->removable = 1;
 						break;
 					}
@@ -198,25 +188,25 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 				/* kludge for Apple PowerBook internal zip */
 				if (!strstr(id->model, "CD-ROM") &&
 				    strstr(id->model, "ZIP")) {
-					printk ("FLOPPY");
+					printk(KERN_CONT "FLOPPY");
 					type = ide_floppy;
 					break;
 				}
 #endif
-				printk ("CD/DVD-ROM");
+				printk(KERN_CONT "CD/DVD-ROM");
 				break;
 			case ide_tape:
-				printk ("TAPE");
+				printk(KERN_CONT "TAPE");
 				break;
 			case ide_optical:
-				printk ("OPTICAL");
+				printk(KERN_CONT "OPTICAL");
 				drive->removable = 1;
 				break;
 			default:
-				printk("UNKNOWN (type %d)", type);
+				printk(KERN_CONT "UNKNOWN (type %d)", type);
 				break;
 		}
-		printk (" drive\n");
+		printk(KERN_CONT " drive\n");
 		drive->media = type;
 		/* an ATAPI device ignores DRDY */
 		drive->ready_stat = 0;
@@ -236,7 +226,9 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 		drive->removable = 1;
 
 	drive->media = ide_disk;
-	printk("%s DISK drive\n", (id->config == 0x848a) ? "CFA" : "ATA" );
+
+	printk(KERN_CONT "%s DISK drive\n",
+		(id->config == 0x848a) ? "CFA" : "ATA");
 
 	return;
 
@@ -387,7 +379,7 @@ static int try_to_identify (ide_drive_t *drive, u8 cmd)
 				/* Mmmm.. multiple IRQs..
 				 * don't know which was ours
 				 */
-				printk("%s: IRQ probe failed (0x%lx)\n",
+				printk(KERN_ERR "%s: IRQ probe failed (0x%lx)\n",
 					drive->name, cookie);
 			}
 		}
@@ -456,7 +448,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			return 4;
 	}
 #ifdef DEBUG
-	printk("probing for %s: present=%d, media=%d, probetype=%s\n",
+	printk(KERN_INFO "probing for %s: present=%d, media=%d, probetype=%s\n",
 		drive->name, drive->present, drive->media,
 		(cmd == WIN_IDENTIFY) ? "ATA" : "ATAPI");
 #endif
@@ -534,7 +526,8 @@ static void enable_nest (ide_drive_t *drive)
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u8 stat;
 
-	printk("%s: enabling %s -- ", hwif->name, drive->id->model);
+	printk(KERN_INFO "%s: enabling %s -- ", hwif->name, drive->id->model);
+
 	SELECT_DRIVE(drive);
 	msleep(50);
 	tp_ops->exec_command(hwif, EXABYTE_ENABLE_NEST);
@@ -883,7 +876,7 @@ static void save_match(ide_hwif_t *hwif, ide_hwif_t *new, ide_hwif_t **match)
 	if (m && m->hwgroup && m->hwgroup != new->hwgroup) {
 		if (!new->hwgroup)
 			return;
-		printk("%s: potential irq problem with %s and %s\n",
+		printk(KERN_WARNING "%s: potential IRQ problem with %s and %s\n",
 			hwif->name, new->name, m->name);
 	}
 	if (!m || m->irq != hwif->irq) /* don't undo a prior perfect match */
@@ -1142,17 +1135,17 @@ static int init_irq (ide_hwif_t *hwif)
 	}
 
 #if !defined(__mc68000__)
-	printk("%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
+	printk(KERN_INFO "%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
 		io_ports->data_addr, io_ports->status_addr,
 		io_ports->ctl_addr, hwif->irq);
 #else
-	printk("%s at 0x%08lx on irq %d", hwif->name,
+	printk(KERN_INFO "%s at 0x%08lx on irq %d", hwif->name,
 		io_ports->data_addr, hwif->irq);
 #endif /* __mc68000__ */
 	if (match)
-		printk(" (%sed with %s)",
+		printk(KERN_CONT " (%sed with %s)",
 			hwif->sharing_irq ? "shar" : "serializ", match->name);
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	mutex_unlock(&ide_cfg_mtx);
 	return 0;
@@ -1287,7 +1280,7 @@ static int hwif_init(ide_hwif_t *hwif)
 	if (!hwif->irq) {
 		hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
 		if (!hwif->irq) {
-			printk("%s: DISABLED, NO IRQ\n", hwif->name);
+			printk(KERN_ERR "%s: disabled, no IRQ\n", hwif->name);
 			return 0;
 		}
 	}
@@ -1317,16 +1310,16 @@ static int hwif_init(ide_hwif_t *hwif)
 	 */
 	hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
 	if (!hwif->irq) {
-		printk("%s: Disabled unable to get IRQ %d.\n",
+		printk(KERN_ERR "%s: disabled, unable to get IRQ %d\n",
 			hwif->name, old_irq);
 		goto out;
 	}
 	if (init_irq(hwif)) {
-		printk("%s: probed IRQ %d and default IRQ %d failed.\n",
+		printk(KERN_ERR "%s: probed IRQ %d and default IRQ %d failed\n",
 			hwif->name, old_irq, hwif->irq);
 		goto out;
 	}
-	printk("%s: probed IRQ %d failed, using default.\n",
+	printk(KERN_WARNING "%s: probed IRQ %d failed, using default\n",
 		hwif->name, hwif->irq);
 
 done:
@@ -1595,6 +1588,8 @@ struct ide_host *ide_host_alloc_all(const struct ide_port_info *d,
 
 		ide_init_port_data(hwif, idx);
 
+		hwif->host = host;
+
 		host->ports[i] = hwif;
 		host->n_ports++;
 	}
@@ -1604,6 +1599,12 @@ struct ide_host *ide_host_alloc_all(const struct ide_port_info *d,
 		return NULL;
 	}
 
+	if (hws[0])
+		host->dev[0] = hws[0]->dev;
+
+	if (d)
+		host->host_flags = d->host_flags;
+
 	return host;
 }
 EXPORT_SYMBOL_GPL(ide_host_alloc_all);
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 151c91e..f66c9c3 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -105,7 +105,7 @@ static int proc_ide_read_identify
 	len = sprintf(page, "\n");
 
 	if (drive) {
-		unsigned short *val = (unsigned short *) page;
+		__le16 *val = (__le16 *)page;
 
 		err = taskfile_lib_get_identify(drive, page);
 		if (!err) {
@@ -113,7 +113,7 @@ static int proc_ide_read_identify
 			page = out;
 			do {
 				out += sprintf(out, "%04x%c",
-					le16_to_cpu(*val), (++i & 7) ? ' ' : '\n');
+					le16_to_cpup(val), (++i & 7) ? ' ' : '\n');
 				val += 1;
 			} while (i < (SECTOR_WORDS * 2));
 			len = out - page;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 6962ca4..82c2afe 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -322,23 +322,29 @@ static struct class *idetape_sysfs_class;
 #define ide_tape_g(disk) \
 	container_of((disk)->private_data, struct ide_tape_obj, driver)
 
+static void ide_tape_release(struct kref *);
+
 static struct ide_tape_obj *ide_tape_get(struct gendisk *disk)
 {
 	struct ide_tape_obj *tape = NULL;
 
 	mutex_lock(&idetape_ref_mutex);
 	tape = ide_tape_g(disk);
-	if (tape)
+	if (tape) {
 		kref_get(&tape->kref);
+		if (ide_device_get(tape->drive)) {
+			kref_put(&tape->kref, ide_tape_release);
+			tape = NULL;
+		}
+	}
 	mutex_unlock(&idetape_ref_mutex);
 	return tape;
 }
 
-static void ide_tape_release(struct kref *);
-
 static void ide_tape_put(struct ide_tape_obj *tape)
 {
 	mutex_lock(&idetape_ref_mutex);
+	ide_device_put(tape->drive);
 	kref_put(&tape->kref, ide_tape_release);
 	mutex_unlock(&idetape_ref_mutex);
 }
@@ -649,10 +655,10 @@ static void ide_tape_callback(ide_drive_t *drive)
 			uptodate = 0;
 		} else {
 			debug_log(DBG_SENSE, "Block Location - %u\n",
-					be32_to_cpu(*(u32 *)&readpos[4]));
+					be32_to_cpup((__be32 *)&readpos[4]));
 
 			tape->partition = readpos[1];
-			tape->first_frame = be32_to_cpu(*(u32 *)&readpos[4]);
+			tape->first_frame = be32_to_cpup((__be32 *)&readpos[4]);
 			set_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
 		}
 	}
@@ -2375,23 +2381,23 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 	caps = pc.buf + 4 + pc.buf[3];
 
 	/* convert to host order and save for later use */
-	speed = be16_to_cpu(*(u16 *)&caps[14]);
-	max_speed = be16_to_cpu(*(u16 *)&caps[8]);
+	speed = be16_to_cpup((__be16 *)&caps[14]);
+	max_speed = be16_to_cpup((__be16 *)&caps[8]);
 
-	put_unaligned(max_speed, (u16 *)&caps[8]);
-	put_unaligned(be16_to_cpu(*(u16 *)&caps[12]), (u16 *)&caps[12]);
-	put_unaligned(speed, (u16 *)&caps[14]);
-	put_unaligned(be16_to_cpu(*(u16 *)&caps[16]), (u16 *)&caps[16]);
+	*(u16 *)&caps[8] = max_speed;
+	*(u16 *)&caps[12] = be16_to_cpup((__be16 *)&caps[12]);
+	*(u16 *)&caps[14] = speed;
+	*(u16 *)&caps[16] = be16_to_cpup((__be16 *)&caps[16]);
 
 	if (!speed) {
 		printk(KERN_INFO "ide-tape: %s: invalid tape speed "
 				"(assuming 650KB/sec)\n", drive->name);
-		put_unaligned(650, (u16 *)&caps[14]);
+		*(u16 *)&caps[14] = 650;
 	}
 	if (!max_speed) {
 		printk(KERN_INFO "ide-tape: %s: invalid max_speed "
 				"(assuming 650KB/sec)\n", drive->name);
-		put_unaligned(650, (u16 *)&caps[8]);
+		*(u16 *)&caps[8] = 650;
 	}
 
 	memcpy(&tape->caps, caps, 20);
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index aeddbbd..7fb6f1c 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -126,7 +126,10 @@ EXPORT_SYMBOL_GPL(do_rw_taskfile);
 static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u8 stat = hwif->tp_ops->read_status(hwif);
+	u8 stat;
+
+	local_irq_enable_in_hardirq();
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, READY_STAT, BAD_STAT))
 		drive->mult_count = drive->mult_req;
@@ -147,6 +150,8 @@ static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
 	int retries = 5;
 	u8 stat;
 
+	local_irq_enable_in_hardirq();
+
 	while (1) {
 		stat = hwif->tp_ops->read_status(hwif);
 		if ((stat & BUSY_STAT) == 0 || retries-- == 0)
@@ -170,7 +175,10 @@ static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
 static ide_startstop_t recal_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u8 stat = hwif->tp_ops->read_status(hwif);
+	u8 stat;
+
+	local_irq_enable_in_hardirq();
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_error(drive, "recal_intr", stat);
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 60f0ca6..7724516 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -618,6 +618,53 @@ set_val:
 
 EXPORT_SYMBOL(generic_ide_ioctl);
 
+/**
+ * ide_device_get	-	get an additional reference to a ide_drive_t
+ * @drive:	device to get a reference to
+ *
+ * Gets a reference to the ide_drive_t and increments the use count of the
+ * underlying LLDD module.
+ */
+int ide_device_get(ide_drive_t *drive)
+{
+	struct device *host_dev;
+	struct module *module;
+
+	if (!get_device(&drive->gendev))
+		return -ENXIO;
+
+	host_dev = drive->hwif->host->dev[0];
+	module = host_dev ? host_dev->driver->owner : NULL;
+
+	if (module && !try_module_get(module)) {
+		put_device(&drive->gendev);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_device_get);
+
+/**
+ * ide_device_put	-	release a reference to a ide_drive_t
+ * @drive:	device to release a reference on
+ *
+ * Release a reference to the ide_drive_t and decrements the use count of
+ * the underlying LLDD module.
+ */
+void ide_device_put(ide_drive_t *drive)
+{
+#ifdef CONFIG_MODULE_UNLOAD
+	struct device *host_dev = drive->hwif->host->dev[0];
+	struct module *module = host_dev ? host_dev->driver->owner : NULL;
+
+	if (module)
+		module_put(module);
+#endif
+	put_device(&drive->gendev);
+}
+EXPORT_SYMBOL_GPL(ide_device_put);
+
 static int ide_bus_match(struct device *dev, struct device_driver *drv)
 {
 	return 1;
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index dd5c467..51ba085 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -127,7 +127,7 @@ static int __init gayle_init(void)
     unsigned long phys_base, res_start, res_n;
     unsigned long base, ctrlport, irqport;
     ide_ack_intr_t *ack_intr;
-    int a4000, i;
+    int a4000, i, rc;
     hw_regs_t hw[GAYLE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
 
     if (!MACH_IS_AMIGA)
@@ -179,7 +179,11 @@ found:
 	hws[i] = &hw[i];
     }
 
-    return ide_host_add(NULL, hws, NULL);
+    rc = ide_host_add(NULL, hws, NULL);
+    if (rc)
+	release_mem_region(res_start, res_n);
+
+    return rc;
 }
 
 module_init(gayle_init);
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index 7bc8fd5..98f7c95 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -3,34 +3,12 @@
  */
 
 /*
- *
- *  Version 0.01        Initial version hacked out of ide.c
- *
- *  Version 0.02        Added support for PIO modes, auto-tune
- *
- *  Version 0.03        Some cleanups
- *
- *  Version 0.05        PIO mode cycle timings auto-tune using bus-speed
- *
- *  Version 0.06        Prefetch mode now defaults no OFF. To set
- *                      prefetch mode OFF/ON use "hdparm -p8/-p9".
- *                      Unmask irq is disabled when prefetch mode
- *                      is enabled.
- *
- *  Version 0.07        Trying to fix CD-ROM detection problem.
- *                      "Prefetch" mode bit OFF for ide disks and
- *                      ON for anything else.
- *
- *  Version 0.08        Need to force prefetch for CDs and other non-disk
- *                      devices. (not sure which devices exactly need
- *                      prefetch)
- *
  *  HT-6560B EIDE-controller support
  *  To activate controller support use kernel parameter "ide0=ht6560b".
  *  Use hdparm utility to enable PIO mode support.
  *
  *  Author:    Mikko Ala-Fossi            <maf@iki.fi>
- *             Jan Evert van Grootheest   <janevert@caiway.nl>
+ *             Jan Evert van Grootheest   <j.e.van.grootheest@caiway.nl>
  *
  *  Try:  http://www.maf.iki.fi/~maf/ht6560b/
  */
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index fbc43e1..e0c8fe7 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -13,6 +13,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "aec62xx"
+
 struct chipset_bus_clock_list_entry {
 	u8 xfer_speed;
 	u8 chipset_settings;
@@ -59,10 +61,6 @@ static const struct chipset_bus_clock_list_entry aec6xxx_34_base [] = {
 	{	0,		0x00,	0x00	}
 };
 
-#define BUSCLOCK(D)	\
-	((struct chipset_bus_clock_list_entry *) pci_get_drvdata((D)))
-
-
 /*
  * TO DO: active tuning and correction of cards without a bios.
  */
@@ -88,6 +86,8 @@ static void aec6210_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct chipset_bus_clock_list_entry *bus_clock = host->host_priv;
 	u16 d_conf		= 0;
 	u8 ultra = 0, ultra_conf = 0;
 	u8 tmp0 = 0, tmp1 = 0, tmp2 = 0;
@@ -96,7 +96,7 @@ static void aec6210_set_mode(ide_drive_t *drive, const u8 speed)
 	local_irq_save(flags);
 	/* 0x40|(2*drive->dn): Active, 0x41|(2*drive->dn): Recovery */
 	pci_read_config_word(dev, 0x40|(2*drive->dn), &d_conf);
-	tmp0 = pci_bus_clock_list(speed, BUSCLOCK(dev));
+	tmp0 = pci_bus_clock_list(speed, bus_clock);
 	d_conf = ((tmp0 & 0xf0) << 4) | (tmp0 & 0xf);
 	pci_write_config_word(dev, 0x40|(2*drive->dn), d_conf);
 
@@ -104,7 +104,7 @@ static void aec6210_set_mode(ide_drive_t *drive, const u8 speed)
 	tmp2 = 0x00;
 	pci_read_config_byte(dev, 0x54, &ultra);
 	tmp1 = ((0x00 << (2*drive->dn)) | (ultra & ~(3 << (2*drive->dn))));
-	ultra_conf = pci_bus_clock_list_ultra(speed, BUSCLOCK(dev));
+	ultra_conf = pci_bus_clock_list_ultra(speed, bus_clock);
 	tmp2 = ((ultra_conf << (2*drive->dn)) | (tmp1 & ~(3 << (2*drive->dn))));
 	pci_write_config_byte(dev, 0x54, tmp2);
 	local_irq_restore(flags);
@@ -114,6 +114,8 @@ static void aec6260_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct chipset_bus_clock_list_entry *bus_clock = host->host_priv;
 	u8 unit		= (drive->select.b.unit & 0x01);
 	u8 tmp1 = 0, tmp2 = 0;
 	u8 ultra = 0, drive_conf = 0, ultra_conf = 0;
@@ -122,12 +124,12 @@ static void aec6260_set_mode(ide_drive_t *drive, const u8 speed)
 	local_irq_save(flags);
 	/* high 4-bits: Active, low 4-bits: Recovery */
 	pci_read_config_byte(dev, 0x40|drive->dn, &drive_conf);
-	drive_conf = pci_bus_clock_list(speed, BUSCLOCK(dev));
+	drive_conf = pci_bus_clock_list(speed, bus_clock);
 	pci_write_config_byte(dev, 0x40|drive->dn, drive_conf);
 
 	pci_read_config_byte(dev, (0x44|hwif->channel), &ultra);
 	tmp1 = ((0x00 << (4*unit)) | (ultra & ~(7 << (4*unit))));
-	ultra_conf = pci_bus_clock_list_ultra(speed, BUSCLOCK(dev));
+	ultra_conf = pci_bus_clock_list_ultra(speed, bus_clock);
 	tmp2 = ((ultra_conf << (4*unit)) | (tmp1 & ~(7 << (4*unit))));
 	pci_write_config_byte(dev, (0x44|hwif->channel), tmp2);
 	local_irq_restore(flags);
@@ -138,15 +140,8 @@ static void aec_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	drive->hwif->port_ops->set_dma_mode(drive, pio + XFER_PIO_0);
 }
 
-static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev)
 {
-	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
-
-	if (bus_speed <= 33)
-		pci_set_drvdata(dev, (void *) aec6xxx_33_base);
-	else
-		pci_set_drvdata(dev, (void *) aec6xxx_34_base);
-
 	/* These are necessary to get AEC6280 Macintosh cards to work */
 	if ((dev->device == PCI_DEVICE_ID_ARTOP_ATP865) ||
 	    (dev->device == PCI_DEVICE_ID_ARTOP_ATP865R)) {
@@ -187,8 +182,8 @@ static const struct ide_port_ops atp86x_port_ops = {
 };
 
 static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
-	{	/* 0 */
-		.name		= "AEC6210",
+	{	/* 0: AEC6210 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.port_ops	= &atp850_port_ops,
@@ -199,8 +194,9 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA2,
-	},{	/* 1 */
-		.name		= "AEC6260",
+	},
+	{	/* 1: AEC6260 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_aec62xx,
 		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_NO_AUTODMA |
@@ -208,8 +204,9 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA4,
-	},{	/* 2 */
-		.name		= "AEC6260R",
+	},
+	{	/* 2: AEC6260R */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.port_ops	= &atp86x_port_ops,
@@ -218,8 +215,9 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA4,
-	},{	/* 3 */
-		.name		= "AEC6280",
+	},
+	{	/* 3: AEC6280 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_aec62xx,
 		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
@@ -227,8 +225,9 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
-	},{	/* 4 */
-		.name		= "AEC6280R",
+	},
+	{	/* 4: AEC6280R */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.port_ops	= &atp86x_port_ops,
@@ -254,10 +253,17 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 
 static int __devinit aec62xx_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
+	const struct chipset_bus_clock_list_entry *bus_clock;
 	struct ide_port_info d;
 	u8 idx = id->driver_data;
+	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 	int err;
 
+	if (bus_speed <= 33)
+		bus_clock = aec6xxx_33_base;
+	else
+		bus_clock = aec6xxx_34_base;
+
 	err = pci_enable_device(dev);
 	if (err)
 		return err;
@@ -268,18 +274,25 @@ static int __devinit aec62xx_init_one(struct pci_dev *dev, const struct pci_devi
 		unsigned long dma_base = pci_resource_start(dev, 4);
 
 		if (inb(dma_base + 2) & 0x10) {
-			d.name = (idx == 4) ? "AEC6880R" : "AEC6880";
+			printk(KERN_INFO DRV_NAME " %s: AEC6880%s card detected"
+				"\n", pci_name(dev), (idx == 4) ? "R" : "");
 			d.udma_mask = ATA_UDMA6;
 		}
 	}
 
-	err = ide_setup_pci_device(dev, &d);
+	err = ide_pci_init_one(dev, &d, (void *)bus_clock);
 	if (err)
 		pci_disable_device(dev);
 
 	return err;
 }
 
+static void __devexit aec62xx_remove(struct pci_dev *dev)
+{
+	ide_pci_remove(dev);
+	pci_disable_device(dev);
+}
+
 static const struct pci_device_id aec62xx_pci_tbl[] = {
 	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP850UF), 0 },
 	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP860),   1 },
@@ -294,6 +307,7 @@ static struct pci_driver driver = {
 	.name		= "AEC62xx_IDE",
 	.id_table	= aec62xx_pci_tbl,
 	.probe		= aec62xx_init_one,
+	.remove		= aec62xx_remove,
 };
 
 static int __init aec62xx_ide_init(void)
@@ -301,7 +315,13 @@ static int __init aec62xx_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit aec62xx_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(aec62xx_ide_init);
+module_exit(aec62xx_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for ARTOP AEC62xx IDE");
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 5ef7817..b582687 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -38,6 +38,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "alim15x3"
+
 /*
  * Allow UDMA on M1543C-E chipset for WDC disks that ignore CRC checking
  * (this is DANGEROUS and could result in data corruption).
@@ -207,13 +209,12 @@ static int ali15x3_dma_setup(ide_drive_t *drive)
 /**
  *	init_chipset_ali15x3	-	Initialise an ALi IDE controller
  *	@dev: PCI device
- *	@name: Name of the controller
  *
  *	This function initializes the ALI IDE controller and where 
  *	appropriate also sets up the 1533 southbridge.
  */
-  
-static unsigned int __devinit init_chipset_ali15x3 (struct pci_dev *dev, const char *name)
+
+static unsigned int __devinit init_chipset_ali15x3(struct pci_dev *dev)
 {
 	unsigned long flags;
 	u8 tmpbyte;
@@ -515,7 +516,7 @@ static const struct ide_dma_ops ali_dma_ops = {
 };
 
 static const struct ide_port_info ali15x3_chipset __devinitdata = {
-	.name		= "ALI15X3",
+	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_ali15x3,
 	.init_hwif	= init_hwif_ali15x3,
 	.init_dma	= init_dma_ali15x3,
@@ -565,7 +566,7 @@ static int __devinit alim15x3_init_one(struct pci_dev *dev, const struct pci_dev
 	if (idx == 0)
 		d.host_flags |= IDE_HFLAG_CLEAR_SIMPLEX;
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 
@@ -580,6 +581,7 @@ static struct pci_driver driver = {
 	.name		= "ALI15x3_IDE",
 	.id_table	= alim15x3_pci_tbl,
 	.probe		= alim15x3_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init ali15x3_ide_init(void)
@@ -587,7 +589,13 @@ static int __init ali15x3_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit ali15x3_ide_exit(void)
+{
+	return pci_unregister_driver(&driver);
+}
+
 module_init(ali15x3_ide_init);
+module_exit(ali15x3_ide_exit);
 
 MODULE_AUTHOR("Michael Aubry, Andrzej Krzysztofowicz, CJ, Andre Hedrick, Alan Cox");
 MODULE_DESCRIPTION("PCI driver module for ALi 15x3 IDE");
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index ef7d971..2cea7bf 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -21,6 +21,8 @@
 #include <linux/init.h>
 #include <linux/ide.h>
 
+#define DRV_NAME "amd74xx"
+
 enum {
 	AMD_IDE_CONFIG		= 0x41,
 	AMD_CABLE_DETECT	= 0x42,
@@ -110,15 +112,13 @@ static void amd_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	amd_set_drive(drive, XFER_PIO_0 + pio);
 }
 
-static void __devinit amd7409_cable_detect(struct pci_dev *dev,
-					   const char *name)
+static void __devinit amd7409_cable_detect(struct pci_dev *dev)
 {
 	/* no host side cable detection */
 	amd_80w = 0x03;
 }
 
-static void __devinit amd7411_cable_detect(struct pci_dev *dev,
-					   const char *name)
+static void __devinit amd7411_cable_detect(struct pci_dev *dev)
 {
 	int i;
 	u32 u = 0;
@@ -129,9 +129,9 @@ static void __devinit amd7411_cable_detect(struct pci_dev *dev,
 	amd_80w = ((t & 0x3) ? 1 : 0) | ((t & 0xc) ? 2 : 0);
 	for (i = 24; i >= 0; i -= 8)
 		if (((u >> i) & 4) && !(amd_80w & (1 << (1 - (i >> 4))))) {
-			printk(KERN_WARNING "%s: BIOS didn't set cable bits "
-					    "correctly. Enabling workaround.\n",
-					    name);
+			printk(KERN_WARNING DRV_NAME " %s: BIOS didn't set "
+				"cable bits correctly. Enabling workaround.\n",
+				pci_name(dev));
 			amd_80w |= (1 << (1 - (i >> 4)));
 		}
 }
@@ -140,8 +140,7 @@ static void __devinit amd7411_cable_detect(struct pci_dev *dev,
  * The initialization callback.  Initialize drive independent registers.
  */
 
-static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev,
-						   const char *name)
+static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev)
 {
 	u8 t = 0, offset = amd_offset(dev);
 
@@ -154,9 +153,9 @@ static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev,
 		; /* no UDMA > 2 */
 	else if (dev->vendor == PCI_VENDOR_ID_AMD &&
 		 dev->device == PCI_DEVICE_ID_AMD_VIPER_7409)
-		amd7409_cable_detect(dev, name);
+		amd7409_cable_detect(dev);
 	else
-		amd7411_cable_detect(dev, name);
+		amd7411_cable_detect(dev);
 
 /*
  * Take care of prefetch & postwrite.
@@ -173,24 +172,6 @@ static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev,
 		t |= 0xf0;
 	pci_write_config_byte(dev, AMD_IDE_CONFIG + offset, t);
 
-/*
- * Determine the system bus clock.
- */
-
-	amd_clock = (ide_pci_clk ? ide_pci_clk : 33) * 1000;
-
-	switch (amd_clock) {
-		case 33000: amd_clock = 33333; break;
-		case 37000: amd_clock = 37500; break;
-		case 41000: amd_clock = 41666; break;
-	}
-
-	if (amd_clock < 20000 || amd_clock > 50000) {
-		printk(KERN_WARNING "%s: User given PCI clock speed impossible (%d), using 33 MHz instead.\n",
-				    name, amd_clock);
-		amd_clock = 33333;
-	}
-
 	return dev->irq;
 }
 
@@ -222,9 +203,9 @@ static const struct ide_port_ops amd_port_ops = {
 	 IDE_HFLAG_IO_32BIT | \
 	 IDE_HFLAG_UNMASK_IRQS)
 
-#define DECLARE_AMD_DEV(name_str, swdma, udma)				\
+#define DECLARE_AMD_DEV(swdma, udma)				\
 	{								\
-		.name		= name_str,				\
+		.name		= DRV_NAME,				\
 		.init_chipset	= init_chipset_amd74xx,			\
 		.init_hwif	= init_hwif_amd74xx,			\
 		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},	\
@@ -236,9 +217,9 @@ static const struct ide_port_ops amd_port_ops = {
 		.udma_mask	= udma,					\
 	}
 
-#define DECLARE_NV_DEV(name_str, udma)					\
+#define DECLARE_NV_DEV(udma)					\
 	{								\
-		.name		= name_str,				\
+		.name		= DRV_NAME,				\
 		.init_chipset	= init_chipset_amd74xx,			\
 		.init_hwif	= init_hwif_amd74xx,			\
 		.enablebits	= {{0x50,0x02,0x02}, {0x50,0x01,0x01}},	\
@@ -251,31 +232,15 @@ static const struct ide_port_ops amd_port_ops = {
 	}
 
 static const struct ide_port_info amd74xx_chipsets[] __devinitdata = {
-	/*  0 */ DECLARE_AMD_DEV("AMD7401",	  0x00, ATA_UDMA2),
-	/*  1 */ DECLARE_AMD_DEV("AMD7409", ATA_SWDMA2, ATA_UDMA4),
-	/*  2 */ DECLARE_AMD_DEV("AMD7411", ATA_SWDMA2, ATA_UDMA5),
-	/*  3 */ DECLARE_AMD_DEV("AMD7441", ATA_SWDMA2, ATA_UDMA5),
-	/*  4 */ DECLARE_AMD_DEV("AMD8111", ATA_SWDMA2, ATA_UDMA6),
-
-	/*  5 */ DECLARE_NV_DEV("NFORCE",		ATA_UDMA5),
-	/*  6 */ DECLARE_NV_DEV("NFORCE2",		ATA_UDMA6),
-	/*  7 */ DECLARE_NV_DEV("NFORCE2-U400R",	ATA_UDMA6),
-	/*  8 */ DECLARE_NV_DEV("NFORCE2-U400R-SATA",	ATA_UDMA6),
-	/*  9 */ DECLARE_NV_DEV("NFORCE3-150",		ATA_UDMA6),
-	/* 10 */ DECLARE_NV_DEV("NFORCE3-250",		ATA_UDMA6),
-	/* 11 */ DECLARE_NV_DEV("NFORCE3-250-SATA",	ATA_UDMA6),
-	/* 12 */ DECLARE_NV_DEV("NFORCE3-250-SATA2",	ATA_UDMA6),
-	/* 13 */ DECLARE_NV_DEV("NFORCE-CK804",		ATA_UDMA6),
-	/* 14 */ DECLARE_NV_DEV("NFORCE-MCP04",		ATA_UDMA6),
-	/* 15 */ DECLARE_NV_DEV("NFORCE-MCP51",		ATA_UDMA6),
-	/* 16 */ DECLARE_NV_DEV("NFORCE-MCP55",		ATA_UDMA6),
-	/* 17 */ DECLARE_NV_DEV("NFORCE-MCP61",		ATA_UDMA6),
-	/* 18 */ DECLARE_NV_DEV("NFORCE-MCP65",		ATA_UDMA6),
-	/* 19 */ DECLARE_NV_DEV("NFORCE-MCP67",		ATA_UDMA6),
-	/* 20 */ DECLARE_NV_DEV("NFORCE-MCP73",		ATA_UDMA6),
-	/* 21 */ DECLARE_NV_DEV("NFORCE-MCP77",		ATA_UDMA6),
-
-	/* 22 */ DECLARE_AMD_DEV("AMD5536", ATA_SWDMA2, ATA_UDMA5),
+	/* 0: AMD7401 */	DECLARE_AMD_DEV(0x00, ATA_UDMA2),
+	/* 1: AMD7409 */	DECLARE_AMD_DEV(ATA_SWDMA2, ATA_UDMA4),
+	/* 2: AMD7411/7441 */	DECLARE_AMD_DEV(ATA_SWDMA2, ATA_UDMA5),
+	/* 3: AMD8111 */	DECLARE_AMD_DEV(ATA_SWDMA2, ATA_UDMA6),
+
+	/* 4: NFORCE */		DECLARE_NV_DEV(ATA_UDMA5),
+	/* 5: >= NFORCE2 */	DECLARE_NV_DEV(ATA_UDMA6),
+
+	/* 6: AMD5536 */	DECLARE_AMD_DEV(ATA_SWDMA2, ATA_UDMA5),
 };
 
 static int __devinit amd74xx_probe(struct pci_dev *dev, const struct pci_device_id *id)
@@ -292,47 +257,64 @@ static int __devinit amd74xx_probe(struct pci_dev *dev, const struct pci_device_
 		if (dev->revision <= 7)
 			d.swdma_mask = 0;
 		d.host_flags |= IDE_HFLAG_CLEAR_SIMPLEX;
-	} else if (idx == 4) {
+	} else if (idx == 3) {
 		if (dev->subsystem_vendor == PCI_VENDOR_ID_AMD &&
 		    dev->subsystem_device == PCI_DEVICE_ID_AMD_SERENADE)
 			d.udma_mask = ATA_UDMA5;
 	}
 
-	printk(KERN_INFO "%s: %s (rev %02x) UDMA%s controller\n",
-			 d.name, pci_name(dev), dev->revision,
-			 amd_dma[fls(d.udma_mask) - 1]);
+	printk(KERN_INFO "%s %s: UDMA%s controller\n",
+		d.name, pci_name(dev), amd_dma[fls(d.udma_mask) - 1]);
+
+	/*
+	* Determine the system bus clock.
+	*/
+	amd_clock = (ide_pci_clk ? ide_pci_clk : 33) * 1000;
+
+	switch (amd_clock) {
+	case 33000: amd_clock = 33333; break;
+	case 37000: amd_clock = 37500; break;
+	case 41000: amd_clock = 41666; break;
+	}
+
+	if (amd_clock < 20000 || amd_clock > 50000) {
+		printk(KERN_WARNING "%s: User given PCI clock speed impossible"
+				    " (%d), using 33 MHz instead.\n",
+				    d.name, amd_clock);
+		amd_clock = 33333;
+	}
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 static const struct pci_device_id amd74xx_pci_tbl[] = {
 	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_COBRA_7401),		 0 },
 	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_VIPER_7409),		 1 },
 	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_VIPER_7411),		 2 },
-	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_OPUS_7441),		 3 },
-	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_8111_IDE),		 4 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_IDE),	 5 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2_IDE),	 6 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2S_IDE),	 7 },
+	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_OPUS_7441),		 2 },
+	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_8111_IDE),		 3 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_IDE),	 4 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2S_IDE),	 5 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2S_SATA),	 8 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2S_SATA),	 5 },
 #endif
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3_IDE),	 9 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_IDE),	10 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_IDE),	 5 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA),	11 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA2),	12 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA2),	 5 },
 #endif
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_CK804_IDE),	13 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_IDE),	14 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_IDE),	15 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE),	16 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE),	17 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE),	18 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE),	19 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE),	20 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE),	21 },
-	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_CS5536_IDE),		22 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_CK804_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE),	 5 },
+	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_CS5536_IDE),		 6 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, amd74xx_pci_tbl);
@@ -341,6 +323,7 @@ static struct pci_driver driver = {
 	.name		= "AMD_IDE",
 	.id_table	= amd74xx_pci_tbl,
 	.probe		= amd74xx_probe,
+	.remove		= ide_pci_remove,
 };
 
 static int __init amd74xx_ide_init(void)
@@ -348,7 +331,13 @@ static int __init amd74xx_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit amd74xx_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(amd74xx_ide_init);
+module_exit(amd74xx_ide_exit);
 
 MODULE_AUTHOR("Vojtech Pavlik");
 MODULE_DESCRIPTION("AMD PCI IDE driver");
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index 8b63718..332f08f 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -11,6 +11,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "atiixp"
+
 #define ATIIXP_IDE_PIO_TIMING		0x40
 #define ATIIXP_IDE_MDMA_TIMING		0x44
 #define ATIIXP_IDE_PIO_CONTROL		0x48
@@ -137,16 +139,17 @@ static const struct ide_port_ops atiixp_port_ops = {
 };
 
 static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
-	{	/* 0 */
-		.name		= "ATIIXP",
+	{	/* 0: IXP200/300/400/700 */
+		.name		= DRV_NAME,
 		.enablebits	= {{0x48,0x01,0x00}, {0x48,0x08,0x00}},
 		.port_ops	= &atiixp_port_ops,
 		.host_flags	= IDE_HFLAG_LEGACY_IRQS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
-	},{	/* 1 */
-		.name		= "SB600_PATA",
+	},
+	{	/* 1: IXP600 */
+		.name		= DRV_NAME,
 		.enablebits	= {{0x48,0x01,0x00}, {0x00,0x00,0x00}},
 		.port_ops	= &atiixp_port_ops,
 		.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_LEGACY_IRQS,
@@ -167,7 +170,7 @@ static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
 
 static int __devinit atiixp_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &atiixp_pci_info[id->driver_data]);
+	return ide_pci_init_one(dev, &atiixp_pci_info[id->driver_data], NULL);
 }
 
 static const struct pci_device_id atiixp_pci_tbl[] = {
@@ -184,6 +187,7 @@ static struct pci_driver driver = {
 	.name		= "ATIIXP_IDE",
 	.id_table	= atiixp_pci_tbl,
 	.probe		= atiixp_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init atiixp_ide_init(void)
@@ -191,7 +195,13 @@ static int __init atiixp_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit atiixp_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(atiixp_ide_init);
+module_exit(atiixp_ide_exit);
 
 MODULE_AUTHOR("HUI YU");
 MODULE_DESCRIPTION("PCI driver module for ATI IXP IDE");
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index ce58bfc..1360b4f 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -19,6 +19,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "cmd64x"
+
 #define CMD_DEBUG 0
 
 #if CMD_DEBUG
@@ -330,28 +332,10 @@ static int cmd646_1_dma_end(ide_drive_t *drive)
 	return (dma_stat & 7) != 4;
 }
 
-static unsigned int __devinit init_chipset_cmd64x(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_cmd64x(struct pci_dev *dev)
 {
 	u8 mrdmode = 0;
 
-	if (dev->device == PCI_DEVICE_ID_CMD_646) {
-
-		switch (dev->revision) {
-		case 0x07:
-		case 0x05:
-			printk("%s: UltraDMA capable\n", name);
-			break;
-		case 0x03:
-		default:
-			printk("%s: MultiWord DMA force limited\n", name);
-			break;
-		case 0x01:
-			printk("%s: MultiWord DMA limited, "
-			       "IRQ workaround enabled\n", name);
-			break;
-		}
-	}
-
 	/* Set a good latency timer and cache line size value. */
 	(void) pci_write_config_byte(dev, PCI_LATENCY_TIMER, 64);
 	/* FIXME: pci_set_master() to ensure a good latency timer value */
@@ -425,8 +409,8 @@ static const struct ide_dma_ops cmd648_dma_ops = {
 };
 
 static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
-	{	/* 0 */
-		.name		= "CMD643",
+	{	/* 0: CMD643 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_cmd64x,
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
 		.port_ops	= &cmd64x_port_ops,
@@ -436,8 +420,9 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= 0x00, /* no udma */
-	},{	/* 1 */
-		.name		= "CMD646",
+	},
+	{	/* 1: CMD646 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.chipset	= ide_cmd646,
@@ -447,8 +432,9 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA2,
-	},{	/* 2 */
-		.name		= "CMD648",
+	},
+	{	/* 2: CMD648 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.port_ops	= &cmd64x_port_ops,
@@ -457,8 +443,9 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA4,
-	},{	/* 3 */
-		.name		= "CMD649",
+	},
+	{	/* 3: CMD649 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.port_ops	= &cmd64x_port_ops,
@@ -507,7 +494,7 @@ static int __devinit cmd64x_init_one(struct pci_dev *dev, const struct pci_devic
 		}
 	}
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 static const struct pci_device_id cmd64x_pci_tbl[] = {
@@ -523,6 +510,7 @@ static struct pci_driver driver = {
 	.name		= "CMD64x_IDE",
 	.id_table	= cmd64x_pci_tbl,
 	.probe		= cmd64x_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init cmd64x_ide_init(void)
@@ -530,7 +518,13 @@ static int __init cmd64x_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit cmd64x_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(cmd64x_ide_init);
+module_exit(cmd64x_ide_exit);
 
 MODULE_AUTHOR("Eddie Dost, David Miller, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for CMD64x IDE");
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index b03d8ae..c0364b2 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -41,6 +41,8 @@
 #include <linux/ide.h>
 #include <linux/dma-mapping.h>
 
+#define DRV_NAME "cs5520"
+
 struct pio_clocks
 {
 	int address;
@@ -92,18 +94,11 @@ static const struct ide_port_ops cs5520_port_ops = {
 	.set_dma_mode		= cs5520_set_dma_mode,
 };
 
-#define DECLARE_CS_DEV(name_str)				\
-	{							\
-		.name		= name_str,			\
-		.port_ops	= &cs5520_port_ops,		\
-		.host_flags	= IDE_HFLAG_ISA_PORTS |		\
-				  IDE_HFLAG_CS5520,		\
-		.pio_mask	= ATA_PIO4,			\
-	}
-
-static const struct ide_port_info cyrix_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_CS_DEV("Cyrix 5510"),
-	/* 1 */ DECLARE_CS_DEV("Cyrix 5520")
+static const struct ide_port_info cyrix_chipset __devinitdata = {
+	.name		= DRV_NAME,
+	.port_ops	= &cs5520_port_ops,
+	.host_flags	= IDE_HFLAG_ISA_PORTS | IDE_HFLAG_CS5520,
+	.pio_mask	= ATA_PIO4,
 };
 
 /*
@@ -114,7 +109,7 @@ static const struct ide_port_info cyrix_chipsets[] __devinitdata = {
  
 static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	const struct ide_port_info *d = &cyrix_chipsets[id->driver_data];
+	const struct ide_port_info *d = &cyrix_chipset;
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 
 	ide_setup_pci_noise(dev, d);
@@ -128,7 +123,8 @@ static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_devic
 	}
 	pci_set_master(dev);
 	if (pci_set_dma_mask(dev, DMA_32BIT_MASK)) {
-		printk(KERN_WARNING "cs5520: No suitable DMA available.\n");
+		printk(KERN_WARNING "%s: No suitable DMA available.\n",
+			d->name);
 		return -ENODEV;
 	}
 
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index f5534c1..f235db8 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -22,6 +22,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "cs5530"
+
 /*
  * Here are the standard PIO mode 0-4 timings for each "format".
  * Format-0 uses fast data reg timings, with slower command reg timings.
@@ -127,12 +129,11 @@ static void cs5530_set_dma_mode(ide_drive_t *drive, const u8 mode)
 /**
  *	init_chipset_5530	-	set up 5530 bridge
  *	@dev: PCI device
- *	@name: device name
  *
  *	Initialize the cs5530 bridge for reliable IDE DMA operation.
  */
 
-static unsigned int __devinit init_chipset_cs5530 (struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_cs5530(struct pci_dev *dev)
 {
 	struct pci_dev *master_0 = NULL, *cs5530_0 = NULL;
 
@@ -151,11 +152,11 @@ static unsigned int __devinit init_chipset_cs5530 (struct pci_dev *dev, const ch
 		}
 	}
 	if (!master_0) {
-		printk(KERN_ERR "%s: unable to locate PCI MASTER function\n", name);
+		printk(KERN_ERR DRV_NAME ": unable to locate PCI MASTER function\n");
 		goto out;
 	}
 	if (!cs5530_0) {
-		printk(KERN_ERR "%s: unable to locate CS5530 LEGACY function\n", name);
+		printk(KERN_ERR DRV_NAME ": unable to locate CS5530 LEGACY function\n");
 		goto out;
 	}
 
@@ -243,7 +244,7 @@ static const struct ide_port_ops cs5530_port_ops = {
 };
 
 static const struct ide_port_info cs5530_chipset __devinitdata = {
-	.name		= "CS5530",
+	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_cs5530,
 	.init_hwif	= init_hwif_cs5530,
 	.port_ops	= &cs5530_port_ops,
@@ -256,7 +257,7 @@ static const struct ide_port_info cs5530_chipset __devinitdata = {
 
 static int __devinit cs5530_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &cs5530_chipset);
+	return ide_pci_init_one(dev, &cs5530_chipset, NULL);
 }
 
 static const struct pci_device_id cs5530_pci_tbl[] = {
@@ -269,6 +270,7 @@ static struct pci_driver driver = {
 	.name		= "CS5530 IDE",
 	.id_table	= cs5530_pci_tbl,
 	.probe		= cs5530_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init cs5530_ide_init(void)
@@ -276,7 +278,13 @@ static int __init cs5530_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit cs5530_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(cs5530_ide_init);
+module_exit(cs5530_ide_exit);
 
 MODULE_AUTHOR("Mark Lord");
 MODULE_DESCRIPTION("PCI driver module for Cyrix/NS 5530 IDE");
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index 5404fe4..f7b50cd 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -26,6 +26,8 @@
 #include <linux/pci.h>
 #include <linux/ide.h>
 
+#define DRV_NAME "cs5535"
+
 #define MSR_ATAC_BASE		0x51300000
 #define ATAC_GLD_MSR_CAP	(MSR_ATAC_BASE+0)
 #define ATAC_GLD_MSR_CONFIG	(MSR_ATAC_BASE+0x01)
@@ -169,7 +171,7 @@ static const struct ide_port_ops cs5535_port_ops = {
 };
 
 static const struct ide_port_info cs5535_chipset __devinitdata = {
-	.name		= "CS5535",
+	.name		= DRV_NAME,
 	.port_ops	= &cs5535_port_ops,
 	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE,
 	.pio_mask	= ATA_PIO4,
@@ -180,7 +182,7 @@ static const struct ide_port_info cs5535_chipset __devinitdata = {
 static int __devinit cs5535_init_one(struct pci_dev *dev,
 					const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &cs5535_chipset);
+	return ide_pci_init_one(dev, &cs5535_chipset, NULL);
 }
 
 static const struct pci_device_id cs5535_pci_tbl[] = {
@@ -194,6 +196,7 @@ static struct pci_driver driver = {
 	.name       = "CS5535_IDE",
 	.id_table   = cs5535_pci_tbl,
 	.probe      = cs5535_init_one,
+	.remove     = ide_pci_remove,
 };
 
 static int __init cs5535_ide_init(void)
@@ -201,7 +204,13 @@ static int __init cs5535_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit cs5535_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(cs5535_ide_init);
+module_exit(cs5535_ide_exit);
 
 MODULE_AUTHOR("AMD");
 MODULE_DESCRIPTION("PCI driver module for AMD/NS CS5535 IDE");
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index e14ad55..bfae2f8 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -48,6 +48,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "cy82c693"
+
 /* the current version */
 #define CY82_VERSION	"CY82C693U driver v0.34 99-13-12 Andreas S. Krebs (akrebs@altavista.net)"
 
@@ -330,7 +332,7 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 /*
  * this function is called during init and is used to setup the cy82c693 chip
  */
-static unsigned int __devinit init_chipset_cy82c693(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_cy82c693(struct pci_dev *dev)
 {
 	if (PCI_FUNC(dev->devfn) != 1)
 		return 0;
@@ -349,8 +351,8 @@ static unsigned int __devinit init_chipset_cy82c693(struct pci_dev *dev, const c
 	data = inb(CY82_DATA_PORT);
 
 #if CY82C693_DEBUG_INFO
-	printk(KERN_INFO "%s: Peripheral Configuration Register: 0x%X\n",
-		name, data);
+	printk(KERN_INFO DRV_NAME ": Peripheral Configuration Register: 0x%X\n",
+		data);
 #endif /* CY82C693_DEBUG_INFO */
 
 	/*
@@ -371,8 +373,8 @@ static unsigned int __devinit init_chipset_cy82c693(struct pci_dev *dev, const c
 	outb(data, CY82_DATA_PORT);
 
 #if CY82C693_DEBUG_INFO
-	printk(KERN_INFO "%s: New Peripheral Configuration Register: 0x%X\n",
-		name, data);
+	printk(KERN_INFO ": New Peripheral Configuration Register: 0x%X\n",
+		data);
 #endif /* CY82C693_DEBUG_INFO */
 
 #endif /* CY82C693_SETDMA_CLOCK */
@@ -398,7 +400,7 @@ static const struct ide_port_ops cy82c693_port_ops = {
 };
 
 static const struct ide_port_info cy82c693_chipset __devinitdata = {
-	.name		= "CY82C693",
+	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_cy82c693,
 	.init_iops	= init_iops_cy82c693,
 	.port_ops	= &cy82c693_port_ops,
@@ -419,12 +421,22 @@ static int __devinit cy82c693_init_one(struct pci_dev *dev, const struct pci_dev
 	if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE &&
 	    PCI_FUNC(dev->devfn) == 1) {
 		dev2 = pci_get_slot(dev->bus, dev->devfn + 1);
-		ret = ide_setup_pci_devices(dev, dev2, &cy82c693_chipset);
-		/* We leak pci refs here but thats ok - we can't be unloaded */
+		ret = ide_pci_init_two(dev, dev2, &cy82c693_chipset, NULL);
+		if (ret)
+			pci_dev_put(dev2);
 	}
 	return ret;
 }
 
+static void __devexit cy82c693_remove(struct pci_dev *dev)
+{
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct pci_dev *dev2 = host->dev[1] ? to_pci_dev(host->dev[1]) : NULL;
+
+	ide_pci_remove(dev);
+	pci_dev_put(dev2);
+}
+
 static const struct pci_device_id cy82c693_pci_tbl[] = {
 	{ PCI_VDEVICE(CONTAQ, PCI_DEVICE_ID_CONTAQ_82C693), 0 },
 	{ 0, },
@@ -435,6 +447,7 @@ static struct pci_driver driver = {
 	.name		= "Cypress_IDE",
 	.id_table	= cy82c693_pci_tbl,
 	.probe		= cy82c693_init_one,
+	.remove		= cy82c693_remove,
 };
 
 static int __init cy82c693_ide_init(void)
@@ -442,7 +455,13 @@ static int __init cy82c693_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit cy82c693_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(cy82c693_ide_init);
+module_exit(cy82c693_ide_exit);
 
 MODULE_AUTHOR("Andreas Krebs, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for the Cypress CY82C693 IDE");
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index 041720e..b07d4f4 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -27,6 +27,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "ide_pci_generic"
+
 static int ide_generic_all;		/* Set to claim all devices */
 
 module_param_named(all_generic_ide, ide_generic_all, bool, 0444);
@@ -34,9 +36,9 @@ MODULE_PARM_DESC(all_generic_ide, "IDE generic will claim all unknown PCI IDE st
 
 #define IDE_HFLAGS_UMC (IDE_HFLAG_NO_DMA | IDE_HFLAG_FORCE_LEGACY_IRQS)
 
-#define DECLARE_GENERIC_PCI_DEV(name_str, extra_flags) \
+#define DECLARE_GENERIC_PCI_DEV(extra_flags) \
 	{ \
-		.name		= name_str, \
+		.name		= DRV_NAME, \
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA | \
 				  extra_flags, \
 		.swdma_mask	= ATA_SWDMA2, \
@@ -45,10 +47,11 @@ MODULE_PARM_DESC(all_generic_ide, "IDE generic will claim all unknown PCI IDE st
 	}
 
 static const struct ide_port_info generic_chipsets[] __devinitdata = {
-	/*  0 */ DECLARE_GENERIC_PCI_DEV("Unknown",	0),
+	/*  0: Unknown */
+	DECLARE_GENERIC_PCI_DEV(0),
 
-	{	/* 1 */
-		.name		= "NS87410",
+	{	/* 1: NS87410 */
+		.name		= DRV_NAME,
 		.enablebits	= { {0x43, 0x08, 0x08}, {0x47, 0x08, 0x08} },
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 		.swdma_mask	= ATA_SWDMA2,
@@ -56,17 +59,15 @@ static const struct ide_port_info generic_chipsets[] __devinitdata = {
 		.udma_mask	= ATA_UDMA6,
 	},
 
-	/*  2 */ DECLARE_GENERIC_PCI_DEV("SAMURAI",	0),
-	/*  3 */ DECLARE_GENERIC_PCI_DEV("HT6565",	0),
-	/*  4 */ DECLARE_GENERIC_PCI_DEV("UM8673F",	IDE_HFLAGS_UMC),
-	/*  5 */ DECLARE_GENERIC_PCI_DEV("UM8886A",	IDE_HFLAGS_UMC),
-	/*  6 */ DECLARE_GENERIC_PCI_DEV("UM8886BF",	IDE_HFLAGS_UMC),
-	/*  7 */ DECLARE_GENERIC_PCI_DEV("HINT_IDE",	0),
-	/*  8 */ DECLARE_GENERIC_PCI_DEV("VIA_IDE",	IDE_HFLAG_NO_AUTODMA),
-	/*  9 */ DECLARE_GENERIC_PCI_DEV("OPTI621V",	IDE_HFLAG_NO_AUTODMA),
-
-	{	/* 10 */
-		.name		= "VIA8237SATA",
+	/*  2: SAMURAI / HT6565 / HINT_IDE */
+	DECLARE_GENERIC_PCI_DEV(0),
+	/*  3: UM8673F / UM8886A / UM8886BF */
+	DECLARE_GENERIC_PCI_DEV(IDE_HFLAGS_UMC),
+	/*  4: VIA_IDE / OPTI621V / Piccolo010{2,3,5} */
+	DECLARE_GENERIC_PCI_DEV(IDE_HFLAG_NO_AUTODMA),
+
+	{	/* 5: VIA8237SATA */
+		.name		= DRV_NAME,
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 				  IDE_HFLAG_OFF_BOARD,
 		.swdma_mask	= ATA_SWDMA2,
@@ -74,12 +75,8 @@ static const struct ide_port_info generic_chipsets[] __devinitdata = {
 		.udma_mask	= ATA_UDMA6,
 	},
 
-	/* 11 */ DECLARE_GENERIC_PCI_DEV("Piccolo0102",	IDE_HFLAG_NO_AUTODMA),
-	/* 12 */ DECLARE_GENERIC_PCI_DEV("Piccolo0103",	IDE_HFLAG_NO_AUTODMA),
-	/* 13 */ DECLARE_GENERIC_PCI_DEV("Piccolo0105",	IDE_HFLAG_NO_AUTODMA),
-
-	{	/* 14 */
-		.name		= "Revolution",
+	{	/* 6: Revolution */
+		.name		= DRV_NAME,
 		.host_flags	= IDE_HFLAG_CLEAR_SIMPLEX |
 				  IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 				  IDE_HFLAG_OFF_BOARD,
@@ -134,12 +131,12 @@ static int __devinit generic_init_one(struct pci_dev *dev, const struct pci_devi
 		u16 command;
 		pci_read_config_word(dev, PCI_COMMAND, &command);
 		if (!(command & PCI_COMMAND_IO)) {
-			printk(KERN_INFO "Skipping disabled %s IDE "
-					"controller.\n", d->name);
+			printk(KERN_INFO "%s %s: skipping disabled "
+				"controller\n", d->name, pci_name(dev));
 			goto out;
 		}
 	}
-	ret = ide_setup_pci_device(dev, d);
+	ret = ide_pci_init_one(dev, d, NULL);
 out:
 	return ret;
 }
@@ -147,20 +144,20 @@ out:
 static const struct pci_device_id generic_pci_tbl[] = {
 	{ PCI_VDEVICE(NS,	PCI_DEVICE_ID_NS_87410),		 1 },
 	{ PCI_VDEVICE(PCTECH,	PCI_DEVICE_ID_PCTECH_SAMURAI_IDE),	 2 },
-	{ PCI_VDEVICE(HOLTEK,	PCI_DEVICE_ID_HOLTEK_6565),		 3 },
-	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8673F),		 4 },
-	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8886A),		 5 },
-	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8886BF),		 6 },
-	{ PCI_VDEVICE(HINT,	PCI_DEVICE_ID_HINT_VXPROII_IDE),	 7 },
-	{ PCI_VDEVICE(VIA,	PCI_DEVICE_ID_VIA_82C561),		 8 },
-	{ PCI_VDEVICE(OPTI,	PCI_DEVICE_ID_OPTI_82C558),		 9 },
+	{ PCI_VDEVICE(HOLTEK,	PCI_DEVICE_ID_HOLTEK_6565),		 2 },
+	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8673F),		 3 },
+	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8886A),		 3 },
+	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8886BF),		 3 },
+	{ PCI_VDEVICE(HINT,	PCI_DEVICE_ID_HINT_VXPROII_IDE),	 2 },
+	{ PCI_VDEVICE(VIA,	PCI_DEVICE_ID_VIA_82C561),		 4 },
+	{ PCI_VDEVICE(OPTI,	PCI_DEVICE_ID_OPTI_82C558),		 4 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
-	{ PCI_VDEVICE(VIA,	PCI_DEVICE_ID_VIA_8237_SATA),		10 },
+	{ PCI_VDEVICE(VIA,	PCI_DEVICE_ID_VIA_8237_SATA),		 5 },
 #endif
-	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO),		11 },
-	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_1),	12 },
-	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),	13 },
-	{ PCI_VDEVICE(NETCELL,	PCI_DEVICE_ID_REVOLUTION),		14 },
+	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO),		 4 },
+	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_1),	 4 },
+	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),	 4 },
+	{ PCI_VDEVICE(NETCELL,	PCI_DEVICE_ID_REVOLUTION),		 6 },
 	/*
 	 * Must come last.  If you add entries adjust
 	 * this table and generic_chipsets[] appropriately.
@@ -174,6 +171,7 @@ static struct pci_driver driver = {
 	.name		= "PCI_IDE",
 	.id_table	= generic_pci_tbl,
 	.probe		= generic_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init generic_ide_init(void)
@@ -181,7 +179,13 @@ static int __init generic_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit generic_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(generic_ide_init);
+module_exit(generic_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for generic PCI IDE");
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index 9e1d1c4..6009b0b 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -33,6 +33,8 @@
 #include <linux/init.h>
 #include <linux/ide.h>
 
+#define DRV_NAME "hpt34x"
+
 #define HPT343_DEBUG_DRIVE_INFO		0
 
 static void hpt34x_set_mode(ide_drive_t *drive, const u8 speed)
@@ -77,7 +79,7 @@ static void hpt34x_set_pio_mode(ide_drive_t *drive, const u8 pio)
  */
 #define	HPT34X_PCI_INIT_REG		0x80
 
-static unsigned int __devinit init_chipset_hpt34x(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_hpt34x(struct pci_dev *dev)
 {
 	int i = 0;
 	unsigned long hpt34xIoBase = pci_resource_start(dev, 4);
@@ -126,15 +128,15 @@ static const struct ide_port_ops hpt34x_port_ops = {
 	 IDE_HFLAG_NO_AUTODMA)
 
 static const struct ide_port_info hpt34x_chipsets[] __devinitdata = {
-	{ /* 0 */
-		.name		= "HPT343",
+	{ /* 0: HPT343 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_hpt34x,
 		.port_ops	= &hpt34x_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_NON_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
 	},
-	{ /* 1 */
-		.name		= "HPT345",
+	{ /* 1: HPT345 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_hpt34x,
 		.port_ops	= &hpt34x_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_OFF_BOARD,
@@ -156,7 +158,7 @@ static int __devinit hpt34x_init_one(struct pci_dev *dev, const struct pci_devic
 
 	d = &hpt34x_chipsets[(pcicmd & PCI_COMMAND_MEMORY) ? 1 : 0];
 
-	return ide_setup_pci_device(dev, d);
+	return ide_pci_init_one(dev, d, NULL);
 }
 
 static const struct pci_device_id hpt34x_pci_tbl[] = {
@@ -169,6 +171,7 @@ static struct pci_driver driver = {
 	.name		= "HPT34x_IDE",
 	.id_table	= hpt34x_pci_tbl,
 	.probe		= hpt34x_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init hpt34x_ide_init(void)
@@ -176,7 +179,13 @@ static int __init hpt34x_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit hpt34x_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(hpt34x_ide_init);
+module_exit(hpt34x_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for Highpoint 34x IDE");
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 1f1135c..5271b24 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -131,6 +131,8 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+#define DRV_NAME "hpt366"
+
 /* various tuning parameters */
 #define HPT_RESET_STATE_ENGINE
 #undef	HPT_DELAY_INTERRUPT
@@ -620,7 +622,8 @@ static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct hpt_info *info	= pci_get_drvdata(dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
 	u8 mask 		= hwif->ultra_mask;
 
 	switch (info->chip_type) {
@@ -660,7 +663,8 @@ static u8 hpt3xx_mdma_filter(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct hpt_info *info	= pci_get_drvdata(dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
 
 	switch (info->chip_type) {
 	case HPT372 :
@@ -694,8 +698,10 @@ static u32 get_speed_setting(u8 speed, struct hpt_info *info)
 
 static void hpt3xx_set_mode(ide_drive_t *drive, const u8 speed)
 {
-	struct pci_dev  *dev	= to_pci_dev(drive->hwif->dev);
-	struct hpt_info	*info	= pci_get_drvdata(dev);
+	ide_hwif_t *hwif	= drive->hwif;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
 	struct hpt_timings *t	= info->timings;
 	u8  itr_addr		= 0x40 + (drive->dn * 4);
 	u32 old_itr		= 0;
@@ -738,7 +744,8 @@ static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
-	struct hpt_info *info	= pci_get_drvdata(dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
 
 	if (drive->quirk_list) {
 		if (info->chip_type >= HPT370) {
@@ -963,24 +970,16 @@ static int __devinit hpt37x_calibrate_dpll(struct pci_dev *dev, u16 f_low, u16 f
 	return 1;
 }
 
-static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev)
 {
-	struct hpt_info *info	= kmalloc(sizeof(struct hpt_info), GFP_KERNEL);
 	unsigned long io_base	= pci_resource_start(dev, 4);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (&dev->dev == host->dev[1]);
+	const char *name	= DRV_NAME;
 	u8 pci_clk,  dpll_clk	= 0;	/* PCI and DPLL clock in MHz */
 	u8 chip_type;
 	enum ata_clock	clock;
 
-	if (info == NULL) {
-		printk(KERN_ERR "%s: out of memory!\n", name);
-		return -ENOMEM;
-	}
-
-	/*
-	 * Copy everything from a static "template" structure
-	 * to just allocated per-chip hpt_info structure.
-	 */
-	memcpy(info, pci_get_drvdata(dev), sizeof(struct hpt_info));
 	chip_type = info->chip_type;
 
 	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, (L1_CACHE_BYTES / 4));
@@ -1048,8 +1047,8 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 		if ((temp & 0xFFFFF000) != 0xABCDE000) {
 			int i;
 
-			printk(KERN_WARNING "%s: no clock data saved by BIOS\n",
-			       name);
+			printk(KERN_WARNING "%s %s: no clock data saved by "
+				"BIOS\n", name, pci_name(dev));
 
 			/* Calculate the average value of f_CNT. */
 			for (temp = i = 0; i < 128; i++) {
@@ -1074,8 +1073,9 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 		else
 			pci_clk = 66;
 
-		printk(KERN_INFO "%s: DPLL base: %d MHz, f_CNT: %d, "
-		       "assuming %d MHz PCI\n", name, dpll_clk, f_cnt, pci_clk);
+		printk(KERN_INFO "%s %s: DPLL base: %d MHz, f_CNT: %d, "
+			"assuming %d MHz PCI\n", name, pci_name(dev),
+			dpll_clk, f_cnt, pci_clk);
 	} else {
 		u32 itr1 = 0;
 
@@ -1141,8 +1141,8 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 		}
 
 		if (info->timings->clock_table[clock] == NULL) {
-			printk(KERN_ERR "%s: unknown bus timing!\n", name);
-			kfree(info);
+			printk(KERN_ERR "%s %s: unknown bus timing!\n",
+				name, pci_name(dev));
 			return -EIO;
 		}
 
@@ -1168,17 +1168,19 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 				f_low += adjust >> 1;
 		}
 		if (adjust == 8) {
-			printk(KERN_ERR "%s: DPLL did not stabilize!\n", name);
-			kfree(info);
+			printk(KERN_ERR "%s %s: DPLL did not stabilize!\n",
+				name, pci_name(dev));
 			return -EIO;
 		}
 
-		printk("%s: using %d MHz DPLL clock\n", name, dpll_clk);
+		printk(KERN_INFO "%s %s: using %d MHz DPLL clock\n",
+			name, pci_name(dev), dpll_clk);
 	} else {
 		/* Mark the fact that we're not using the DPLL. */
 		dpll_clk = 0;
 
-		printk("%s: using %d MHz PCI clock\n", name, pci_clk);
+		printk(KERN_INFO "%s %s: using %d MHz PCI clock\n",
+			name, pci_name(dev), pci_clk);
 	}
 
 	/* Store the clock frequencies. */
@@ -1186,9 +1188,6 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 	info->pci_clk	= pci_clk;
 	info->clock	= clock;
 
-	/* Point to this chip's own instance of the hpt_info structure. */
-	pci_set_drvdata(dev, info);
-
 	if (chip_type >= HPT370) {
 		u8  mcr1, mcr4;
 
@@ -1218,7 +1217,8 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 static u8 __devinit hpt3xx_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
-	struct hpt_info *info	= pci_get_drvdata(dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
 	u8 chip_type		= info->chip_type;
 	u8 scr1 = 0, ata66	= hwif->channel ? 0x01 : 0x02;
 
@@ -1262,7 +1262,8 @@ static u8 __devinit hpt3xx_cable_detect(ide_hwif_t *hwif)
 static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct hpt_info *info	= pci_get_drvdata(dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
 	int serialize		= HPT_SERIALIZE_IO;
 	u8  chip_type		= info->chip_type;
 	u8  new_mcr, old_mcr	= 0;
@@ -1364,7 +1365,8 @@ static void __devinit hpt374_init(struct pci_dev *dev, struct pci_dev *dev2)
 	if (dev2->irq != dev->irq) {
 		/* FIXME: we need a core pci_set_interrupt() */
 		dev2->irq = dev->irq;
-		printk(KERN_INFO "HPT374: PCI config space interrupt fixed\n");
+		printk(KERN_INFO DRV_NAME " %s: PCI config space interrupt "
+			"fixed\n", pci_name(dev2));
 	}
 }
 
@@ -1399,8 +1401,8 @@ static int __devinit hpt36x_init(struct pci_dev *dev, struct pci_dev *dev2)
 	pci_read_config_byte(dev2, PCI_INTERRUPT_PIN, &pin2);
 
 	if (pin1 != pin2 && dev->irq == dev2->irq) {
-		printk(KERN_INFO "HPT36x: onboard version of chipset, "
-				 "pin1=%d pin2=%d\n", pin1, pin2);
+		printk(KERN_INFO DRV_NAME " %s: onboard version of chipset, "
+			"pin1=%d pin2=%d\n", pci_name(dev), pin1, pin2);
 		return 1;
 	}
 
@@ -1455,8 +1457,8 @@ static const struct ide_dma_ops hpt36x_dma_ops = {
 };
 
 static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
-	{	/* 0 */
-		.name		= "HPT36x",
+	{	/* 0: HPT36x */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
@@ -1472,53 +1474,9 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 		.host_flags	= IDE_HFLAGS_HPT3XX | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
-	},{	/* 1 */
-		.name		= "HPT372A",
-		.init_chipset	= init_chipset_hpt366,
-		.init_hwif	= init_hwif_hpt366,
-		.init_dma	= init_dma_hpt366,
-		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.port_ops	= &hpt3xx_port_ops,
-		.dma_ops	= &hpt37x_dma_ops,
-		.host_flags	= IDE_HFLAGS_HPT3XX,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-	},{	/* 2 */
-		.name		= "HPT302",
-		.init_chipset	= init_chipset_hpt366,
-		.init_hwif	= init_hwif_hpt366,
-		.init_dma	= init_dma_hpt366,
-		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.port_ops	= &hpt3xx_port_ops,
-		.dma_ops	= &hpt37x_dma_ops,
-		.host_flags	= IDE_HFLAGS_HPT3XX,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-	},{	/* 3 */
-		.name		= "HPT371",
-		.init_chipset	= init_chipset_hpt366,
-		.init_hwif	= init_hwif_hpt366,
-		.init_dma	= init_dma_hpt366,
-		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.port_ops	= &hpt3xx_port_ops,
-		.dma_ops	= &hpt37x_dma_ops,
-		.host_flags	= IDE_HFLAGS_HPT3XX,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-	},{	/* 4 */
-		.name		= "HPT374",
-		.init_chipset	= init_chipset_hpt366,
-		.init_hwif	= init_hwif_hpt366,
-		.init_dma	= init_dma_hpt366,
-		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= ATA_UDMA5,
-		.port_ops	= &hpt3xx_port_ops,
-		.dma_ops	= &hpt37x_dma_ops,
-		.host_flags	= IDE_HFLAGS_HPT3XX,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-	},{	/* 5 */
-		.name		= "HPT372N",
+	},
+	{	/* 1: HPT3xx */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
@@ -1542,10 +1500,12 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	const struct hpt_info *info = NULL;
+	struct hpt_info *dyn_info;
 	struct pci_dev *dev2 = NULL;
 	struct ide_port_info d;
 	u8 idx = id->driver_data;
 	u8 rev = dev->revision;
+	int ret;
 
 	if ((idx == 0 || idx == 4) && (PCI_FUNC(dev->devfn) & 1))
 		return -ENODEV;
@@ -1582,24 +1542,35 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 		break;
 	}
 
-	d = hpt366_chipsets[idx];
+	printk(KERN_INFO DRV_NAME ": %s chipset detected\n", info->chip_name);
+
+	d = hpt366_chipsets[min_t(u8, idx, 1)];
 
-	d.name = info->chip_name;
 	d.udma_mask = info->udma_mask;
 
 	/* fixup ->dma_ops for HPT370/HPT370A */
 	if (info == &hpt370 || info == &hpt370a)
 		d.dma_ops = &hpt370_dma_ops;
 
-	pci_set_drvdata(dev, (void *)info);
-
 	if (info == &hpt36x || info == &hpt374)
 		dev2 = pci_get_slot(dev->bus, dev->devfn + 1);
 
-	if (dev2) {
-		int ret;
+	dyn_info = kzalloc(sizeof(*dyn_info) * (dev2 ? 2 : 1), GFP_KERNEL);
+	if (dyn_info == NULL) {
+		printk(KERN_ERR "%s %s: out of memory!\n",
+			d.name, pci_name(dev));
+		pci_dev_put(dev2);
+		return -ENOMEM;
+	}
+
+	/*
+	 * Copy everything from a static "template" structure
+	 * to just allocated per-chip hpt_info structure.
+	 */
+	memcpy(dyn_info, info, sizeof(*dyn_info));
 
-		pci_set_drvdata(dev2, (void *)info);
+	if (dev2) {
+		memcpy(dyn_info + 1, info, sizeof(*dyn_info));
 
 		if (info == &hpt374)
 			hpt374_init(dev, dev2);
@@ -1608,13 +1579,30 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 				d.host_flags &= ~IDE_HFLAG_NON_BOOTABLE;
 		}
 
-		ret = ide_setup_pci_devices(dev, dev2, &d);
-		if (ret < 0)
+		ret = ide_pci_init_two(dev, dev2, &d, dyn_info);
+		if (ret < 0) {
 			pci_dev_put(dev2);
+			kfree(dyn_info);
+		}
 		return ret;
 	}
 
-	return ide_setup_pci_device(dev, &d);
+	ret = ide_pci_init_one(dev, &d, dyn_info);
+	if (ret < 0)
+		kfree(dyn_info);
+
+	return ret;
+}
+
+static void __devexit hpt366_remove(struct pci_dev *dev)
+{
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct ide_info *info = host->host_priv;
+	struct pci_dev *dev2 = host->dev[1] ? to_pci_dev(host->dev[1]) : NULL;
+
+	ide_pci_remove(dev);
+	pci_dev_put(dev2);
+	kfree(info);
 }
 
 static const struct pci_device_id hpt366_pci_tbl[] __devinitconst = {
@@ -1632,6 +1620,7 @@ static struct pci_driver driver = {
 	.name		= "HPT366_IDE",
 	.id_table	= hpt366_pci_tbl,
 	.probe		= hpt366_init_one,
+	.remove		= hpt366_remove,
 };
 
 static int __init hpt366_ide_init(void)
@@ -1639,7 +1628,13 @@ static int __init hpt366_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit hpt366_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(hpt366_ide_init);
+module_exit(hpt366_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for Highpoint HPT366 IDE");
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index 2b71bdf..6eba8f1 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -14,6 +14,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "it8213"
+
 /**
  *	it8213_set_pio_mode	-	set host controller for PIO mode
  *	@drive: drive
@@ -155,23 +157,17 @@ static const struct ide_port_ops it8213_port_ops = {
 	.cable_detect		= it8213_cable_detect,
 };
 
-#define DECLARE_ITE_DEV(name_str)			\
-	{						\
-		.name		= name_str,		\
-		.enablebits	= { {0x41, 0x80, 0x80} }, \
-		.port_ops	= &it8213_port_ops,	\
-		.host_flags	= IDE_HFLAG_SINGLE,	\
-		.pio_mask	= ATA_PIO4,		\
-		.swdma_mask	= ATA_SWDMA2_ONLY,	\
-		.mwdma_mask	= ATA_MWDMA12_ONLY,	\
-		.udma_mask	= ATA_UDMA6,		\
-	}
-
-static const struct ide_port_info it8213_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_ITE_DEV("IT8213"),
+static const struct ide_port_info it8213_chipset __devinitdata = {
+	.name		= DRV_NAME,
+	.enablebits	= { {0x41, 0x80, 0x80} },
+	.port_ops	= &it8213_port_ops,
+	.host_flags	= IDE_HFLAG_SINGLE,
+	.pio_mask	= ATA_PIO4,
+	.swdma_mask	= ATA_SWDMA2_ONLY,
+	.mwdma_mask	= ATA_MWDMA12_ONLY,
+	.udma_mask	= ATA_UDMA6,
 };
 
-
 /**
  *	it8213_init_one	-	pci layer discovery entry
  *	@dev: PCI device
@@ -184,7 +180,7 @@ static const struct ide_port_info it8213_chipsets[] __devinitdata = {
 
 static int __devinit it8213_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &it8213_chipsets[id->driver_data]);
+	return ide_pci_init_one(dev, &it8213_chipset, NULL);
 }
 
 static const struct pci_device_id it8213_pci_tbl[] = {
@@ -198,6 +194,7 @@ static struct pci_driver driver = {
 	.name		= "ITE8213_IDE",
 	.id_table	= it8213_pci_tbl,
 	.probe		= it8213_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init it8213_ide_init(void)
@@ -205,7 +202,13 @@ static int __init it8213_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit it8213_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(it8213_ide_init);
+module_exit(it8213_ide_exit);
 
 MODULE_AUTHOR("Jack Lee, Alan Cox");
 MODULE_DESCRIPTION("PCI driver module for the ITE 8213");
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index cbf6472..e16a1d1 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -67,6 +67,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "it821x"
+
 struct it821x_dev
 {
 	unsigned int smart:1,		/* Are we in smart raid mode */
@@ -534,8 +536,9 @@ static struct ide_dma_ops it821x_pass_through_dma_ops = {
 static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct it821x_dev **itdevs = (struct it821x_dev **)pci_get_drvdata(dev);
-	struct it821x_dev *idev = itdevs[hwif->channel];
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct it821x_dev *itdevs = host->host_priv;
+	struct it821x_dev *idev = itdevs + hwif->channel;
 	u8 conf;
 
 	ide_set_hwifdata(hwif, idev);
@@ -568,7 +571,8 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 		idev->timing10 = 1;
 		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 		if (idev->smart == 0)
-			printk(KERN_WARNING "it821x: Revision 0x10, workarounds activated.\n");
+			printk(KERN_WARNING DRV_NAME " %s: revision 0x10, "
+				"workarounds activated\n", pci_name(dev));
 	}
 
 	if (idev->smart == 0) {
@@ -601,18 +605,20 @@ static void __devinit it8212_disable_raid(struct pci_dev *dev)
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
 }
 
-static unsigned int __devinit init_chipset_it821x(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_it821x(struct pci_dev *dev)
 {
 	u8 conf;
 	static char *mode[2] = { "pass through", "smart" };
 
 	/* Force the card into bypass mode if so requested */
 	if (it8212_noraid) {
-		printk(KERN_INFO "it8212: forcing bypass mode.\n");
+		printk(KERN_INFO DRV_NAME " %s: forcing bypass mode\n",
+			pci_name(dev));
 		it8212_disable_raid(dev);
 	}
 	pci_read_config_byte(dev, 0x50, &conf);
-	printk(KERN_INFO "it821x: controller in %s mode.\n", mode[conf & 1]);
+	printk(KERN_INFO DRV_NAME " %s: controller in %s mode\n",
+		pci_name(dev), mode[conf & 1]);
 	return 0;
 }
 
@@ -624,17 +630,12 @@ static const struct ide_port_ops it821x_port_ops = {
 	.cable_detect		= it821x_cable_detect,
 };
 
-#define DECLARE_ITE_DEV(name_str)			\
-	{						\
-		.name		= name_str,		\
-		.init_chipset	= init_chipset_it821x,	\
-		.init_hwif	= init_hwif_it821x,	\
-		.port_ops	= &it821x_port_ops,	\
-		.pio_mask	= ATA_PIO4,		\
-	}
-
-static const struct ide_port_info it821x_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_ITE_DEV("IT8212"),
+static const struct ide_port_info it821x_chipset __devinitdata = {
+	.name		= DRV_NAME,
+	.init_chipset	= init_chipset_it821x,
+	.init_hwif	= init_hwif_it821x,
+	.port_ops	= &it821x_port_ops,
+	.pio_mask	= ATA_PIO4,
 };
 
 /**
@@ -648,23 +649,29 @@ static const struct ide_port_info it821x_chipsets[] __devinitdata = {
 
 static int __devinit it821x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	struct it821x_dev *itdevs[2] = { NULL, NULL} , *itdev;
-	unsigned int i;
-
-	for (i = 0; i < 2; i++) {
-		itdev = kzalloc(sizeof(*itdev), GFP_KERNEL);
-		if (itdev == NULL) {
-			kfree(itdevs[0]);
-			printk(KERN_ERR "it821x: out of memory\n");
-			return -ENOMEM;
-		}
+	struct it821x_dev *itdevs;
+	int rc;
 
-		itdevs[i] = itdev;
+	itdevs = kzalloc(2 * sizeof(*itdevs), GFP_KERNEL);
+	if (itdevs == NULL) {
+		printk(KERN_ERR DRV_NAME " %s: out of memory\n", pci_name(dev));
+		return -ENOMEM;
 	}
 
-	pci_set_drvdata(dev, itdevs);
+	rc = ide_pci_init_one(dev, &it821x_chipset, itdevs);
+	if (rc)
+		kfree(itdevs);
 
-	return ide_setup_pci_device(dev, &it821x_chipsets[id->driver_data]);
+	return rc;
+}
+
+static void __devexit it821x_remove(struct pci_dev *dev)
+{
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct it821x_dev *itdevs = host->host_priv;
+
+	ide_pci_remove(dev);
+	kfree(itdevs);
 }
 
 static const struct pci_device_id it821x_pci_tbl[] = {
@@ -679,6 +686,7 @@ static struct pci_driver driver = {
 	.name		= "ITE821x IDE",
 	.id_table	= it821x_pci_tbl,
 	.probe		= it821x_init_one,
+	.remove		= it821x_remove,
 };
 
 static int __init it821x_ide_init(void)
@@ -686,7 +694,13 @@ static int __init it821x_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit it821x_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(it821x_ide_init);
+module_exit(it821x_ide_exit);
 
 module_param_named(noraid, it8212_noraid, int, S_IRUGO);
 MODULE_PARM_DESC(noraid, "Force card into bypass mode");
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index 96ef739..545b6e1 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -12,6 +12,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "jmicron"
+
 typedef enum {
 	PORT_PATA0 = 0,
 	PORT_PATA1 = 1,
@@ -102,7 +104,7 @@ static const struct ide_port_ops jmicron_port_ops = {
 };
 
 static const struct ide_port_info jmicron_chipset __devinitdata = {
-	.name		= "JMB",
+	.name		= DRV_NAME,
 	.enablebits	= { { 0x40, 0x01, 0x01 }, { 0x40, 0x10, 0x10 } },
 	.port_ops	= &jmicron_port_ops,
 	.pio_mask	= ATA_PIO5,
@@ -121,7 +123,7 @@ static const struct ide_port_info jmicron_chipset __devinitdata = {
 
 static int __devinit jmicron_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &jmicron_chipset);
+	return ide_pci_init_one(dev, &jmicron_chipset, NULL);
 }
 
 /* All JMB PATA controllers have and will continue to have the same
@@ -152,6 +154,7 @@ static struct pci_driver driver = {
 	.name		= "JMicron IDE",
 	.id_table	= jmicron_pci_tbl,
 	.probe		= jmicron_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init jmicron_ide_init(void)
@@ -159,7 +162,13 @@ static int __init jmicron_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit jmicron_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(jmicron_ide_init);
+module_exit(jmicron_ide_exit);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("PCI driver module for the JMicron in legacy modes");
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index 5cd2b32..ffefcd1 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -19,6 +19,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "ns87415"
+
 #ifdef CONFIG_SUPERIO
 /* SUPERIO 87560 is a PoS chip that NatSem denies exists.
  * Unfortunately, it's built-in on all Astro-based PA-RISC workstations
@@ -305,7 +307,7 @@ static const struct ide_dma_ops ns87415_dma_ops = {
 };
 
 static const struct ide_port_info ns87415_chipset __devinitdata = {
-	.name		= "NS87415",
+	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_ns87415,
 	.port_ops	= &ns87415_port_ops,
 	.dma_ops	= &ns87415_dma_ops,
@@ -324,7 +326,7 @@ static int __devinit ns87415_init_one(struct pci_dev *dev, const struct pci_devi
 		d.tp_ops = &superio_tp_ops;
 	}
 #endif
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 static const struct pci_device_id ns87415_pci_tbl[] = {
@@ -337,6 +339,7 @@ static struct pci_driver driver = {
 	.name		= "NS87415_IDE",
 	.id_table	= ns87415_pci_tbl,
 	.probe		= ns87415_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init ns87415_ide_init(void)
@@ -344,7 +347,13 @@ static int __init ns87415_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit ns87415_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(ns87415_ide_init);
+module_exit(ns87415_ide_exit);
 
 MODULE_AUTHOR("Mark Lord, Eddie Dost, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for NS87415 IDE");
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index 725c805..e28e672 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -90,6 +90,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "opti621"
+
 #define READ_REG 0	/* index of Read cycle timing register */
 #define WRITE_REG 1	/* index of Write cycle timing register */
 #define CNTRL_REG 3	/* index of Control register */
@@ -200,7 +202,7 @@ static const struct ide_port_ops opti621_port_ops = {
 };
 
 static const struct ide_port_info opti621_chipset __devinitdata = {
-	.name		= "OPTI621/X",
+	.name		= DRV_NAME,
 	.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
 	.port_ops	= &opti621_port_ops,
 	.host_flags	= IDE_HFLAG_NO_DMA,
@@ -209,7 +211,7 @@ static const struct ide_port_info opti621_chipset __devinitdata = {
 
 static int __devinit opti621_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &opti621_chipset);
+	return ide_pci_init_one(dev, &opti621_chipset, NULL);
 }
 
 static const struct pci_device_id opti621_pci_tbl[] = {
@@ -223,6 +225,7 @@ static struct pci_driver driver = {
 	.name		= "Opti621_IDE",
 	.id_table	= opti621_pci_tbl,
 	.probe		= opti621_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init opti621_ide_init(void)
@@ -230,7 +233,13 @@ static int __init opti621_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit opti621_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(opti621_ide_init);
+module_exit(opti621_ide_exit);
 
 MODULE_AUTHOR("Jaromir Koutek, Jan Harkes, Mark Lord");
 MODULE_DESCRIPTION("PCI driver module for Opti621 IDE");
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 070df8a..998615f 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -31,6 +31,8 @@
 #include <asm/pci-bridge.h>
 #endif
 
+#define DRV_NAME "pdc202xx_new"
+
 #undef DEBUG
 
 #ifdef DEBUG
@@ -324,8 +326,9 @@ static void __devinit apple_kiwi_init(struct pci_dev *pdev)
 }
 #endif /* CONFIG_PPC_PMAC */
 
-static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev)
 {
+	const char *name = DRV_NAME;
 	unsigned long dma_base = pci_resource_start(dev, 4);
 	unsigned long sec_dma_base = dma_base + 0x08;
 	long pll_input, pll_output, ratio;
@@ -358,12 +361,13 @@ static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev, const cha
 	 * registers setting.
 	 */
 	pll_input = detect_pll_input_clock(dma_base);
-	printk("%s: PLL input clock is %ld kHz\n", name, pll_input / 1000);
+	printk(KERN_INFO "%s %s: PLL input clock is %ld kHz\n",
+		name, pci_name(dev), pll_input / 1000);
 
 	/* Sanity check */
 	if (unlikely(pll_input < 5000000L || pll_input > 70000000L)) {
-		printk(KERN_ERR "%s: Bad PLL input clock %ld Hz, giving up!\n",
-		       name, pll_input);
+		printk(KERN_ERR "%s %s: Bad PLL input clock %ld Hz, giving up!"
+			"\n", name, pci_name(dev), pll_input);
 		goto out;
 	}
 
@@ -399,7 +403,8 @@ static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev, const cha
 		r = 0x00;
 	} else {
 		/* Invalid ratio */
-		printk(KERN_ERR "%s: Bad ratio %ld, giving up!\n", name, ratio);
+		printk(KERN_ERR "%s %s: Bad ratio %ld, giving up!\n",
+			name, pci_name(dev), ratio);
 		goto out;
 	}
 
@@ -409,7 +414,8 @@ static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev, const cha
 
 	if (unlikely(f < 0 || f > 127)) {
 		/* Invalid F */
-		printk(KERN_ERR "%s: F[%d] invalid!\n", name, f);
+		printk(KERN_ERR "%s %s: F[%d] invalid!\n",
+			name, pci_name(dev), f);
 		goto out;
 	}
 
@@ -455,8 +461,8 @@ static struct pci_dev * __devinit pdc20270_get_dev2(struct pci_dev *dev)
 
 		if (dev2->irq != dev->irq) {
 			dev2->irq = dev->irq;
-			printk(KERN_INFO "PDC20270: PCI config space "
-					 "interrupt fixed\n");
+			printk(KERN_INFO DRV_NAME " %s: PCI config space "
+				"interrupt fixed\n", pci_name(dev));
 		}
 
 		return dev2;
@@ -473,9 +479,9 @@ static const struct ide_port_ops pdcnew_port_ops = {
 	.cable_detect		= pdcnew_cable_detect,
 };
 
-#define DECLARE_PDCNEW_DEV(name_str, udma) \
+#define DECLARE_PDCNEW_DEV(udma) \
 	{ \
-		.name		= name_str, \
+		.name		= DRV_NAME, \
 		.init_chipset	= init_chipset_pdcnew, \
 		.port_ops	= &pdcnew_port_ops, \
 		.host_flags	= IDE_HFLAG_POST_SET_MODE | \
@@ -487,13 +493,8 @@ static const struct ide_port_ops pdcnew_port_ops = {
 	}
 
 static const struct ide_port_info pdcnew_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_PDCNEW_DEV("PDC20268", ATA_UDMA5),
-	/* 1 */ DECLARE_PDCNEW_DEV("PDC20269", ATA_UDMA6),
-	/* 2 */ DECLARE_PDCNEW_DEV("PDC20270", ATA_UDMA5),
-	/* 3 */ DECLARE_PDCNEW_DEV("PDC20271", ATA_UDMA6),
-	/* 4 */ DECLARE_PDCNEW_DEV("PDC20275", ATA_UDMA6),
-	/* 5 */ DECLARE_PDCNEW_DEV("PDC20276", ATA_UDMA6),
-	/* 6 */ DECLARE_PDCNEW_DEV("PDC20277", ATA_UDMA6),
+	/* 0: PDC202{68,70} */		DECLARE_PDCNEW_DEV(ATA_UDMA5),
+	/* 1: PDC202{69,71,75,76,77} */	DECLARE_PDCNEW_DEV(ATA_UDMA6),
 };
 
 /**
@@ -507,13 +508,10 @@ static const struct ide_port_info pdcnew_chipsets[] __devinitdata = {
  
 static int __devinit pdc202new_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	const struct ide_port_info *d;
+	const struct ide_port_info *d = &pdcnew_chipsets[id->driver_data];
 	struct pci_dev *bridge = dev->bus->self;
-	u8 idx = id->driver_data;
-
-	d = &pdcnew_chipsets[idx];
 
-	if (idx == 2 && bridge &&
+	if (dev->device == PCI_DEVICE_ID_PROMISE_20270 && bridge &&
 	    bridge->vendor == PCI_VENDOR_ID_DEC &&
 	    bridge->device == PCI_DEVICE_ID_DEC_21150) {
 		struct pci_dev *dev2;
@@ -524,33 +522,42 @@ static int __devinit pdc202new_init_one(struct pci_dev *dev, const struct pci_de
 		dev2 = pdc20270_get_dev2(dev);
 
 		if (dev2) {
-			int ret = ide_setup_pci_devices(dev, dev2, d);
+			int ret = ide_pci_init_two(dev, dev2, d, NULL);
 			if (ret < 0)
 				pci_dev_put(dev2);
 			return ret;
 		}
 	}
 
-	if (idx == 5 && bridge &&
+	if (dev->device == PCI_DEVICE_ID_PROMISE_20276 && bridge &&
 	    bridge->vendor == PCI_VENDOR_ID_INTEL &&
 	    (bridge->device == PCI_DEVICE_ID_INTEL_I960 ||
 	     bridge->device == PCI_DEVICE_ID_INTEL_I960RM)) {
-		printk(KERN_INFO "PDC20276: attached to I2O RAID controller, "
-				 "skipping\n");
+		printk(KERN_INFO DRV_NAME " %s: attached to I2O RAID controller,"
+			" skipping\n", pci_name(dev));
 		return -ENODEV;
 	}
 
-	return ide_setup_pci_device(dev, d);
+	return ide_pci_init_one(dev, d, NULL);
+}
+
+static void __devexit pdc202new_remove(struct pci_dev *dev)
+{
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct pci_dev *dev2 = host->dev[1] ? to_pci_dev(host->dev[1]) : NULL;
+
+	ide_pci_remove(dev);
+	pci_dev_put(dev2);
 }
 
 static const struct pci_device_id pdc202new_pci_tbl[] = {
 	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20268), 0 },
 	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20269), 1 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20270), 2 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20271), 3 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20275), 4 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20276), 5 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20277), 6 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20270), 0 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20271), 1 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20275), 1 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20276), 1 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20277), 1 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, pdc202new_pci_tbl);
@@ -559,6 +566,7 @@ static struct pci_driver driver = {
 	.name		= "Promise_IDE",
 	.id_table	= pdc202new_pci_tbl,
 	.probe		= pdc202new_init_one,
+	.remove		= pdc202new_remove,
 };
 
 static int __init pdc202new_ide_init(void)
@@ -566,7 +574,13 @@ static int __init pdc202new_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit pdc202new_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(pdc202new_ide_init);
+module_exit(pdc202new_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick, Frank Tiernan");
 MODULE_DESCRIPTION("PCI driver module for Promise PDC20268 and higher");
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index e54dc65..6ff2def 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -20,6 +20,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "pdc202xx_old"
+
 #define PDC202XX_DEBUG_DRIVE_INFO	0
 
 static const char *pdc_quirk_drives[] = {
@@ -263,8 +265,7 @@ static void pdc202xx_dma_timeout(ide_drive_t *drive)
 	ide_dma_timeout(drive);
 }
 
-static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev,
-						    const char *name)
+static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev)
 {
 	unsigned long dmabase = pci_resource_start(dev, 4);
 	u8 udma_speed_flag = 0, primary_mode = 0, secondary_mode = 0;
@@ -304,8 +305,8 @@ static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
 		if (irq != irq2) {
 			pci_write_config_byte(dev,
 				(PCI_INTERRUPT_LINE)|0x80, irq);     /* 0xbc */
-			printk(KERN_INFO "%s: PCI config space interrupt "
-					 "mirror fixed\n", name);
+			printk(KERN_INFO "%s %s: PCI config space interrupt "
+				"mirror fixed\n", name, pci_name(dev));
 		}
 	}
 }
@@ -350,9 +351,9 @@ static const struct ide_dma_ops pdc2026x_dma_ops = {
 	.dma_timeout		= pdc202xx_dma_timeout,
 };
 
-#define DECLARE_PDC2026X_DEV(name_str, udma, extra_flags) \
+#define DECLARE_PDC2026X_DEV(udma, extra_flags) \
 	{ \
-		.name		= name_str, \
+		.name		= DRV_NAME, \
 		.init_chipset	= init_chipset_pdc202xx, \
 		.port_ops	= &pdc2026x_port_ops, \
 		.dma_ops	= &pdc2026x_dma_ops, \
@@ -363,8 +364,8 @@ static const struct ide_dma_ops pdc2026x_dma_ops = {
 	}
 
 static const struct ide_port_info pdc202xx_chipsets[] __devinitdata = {
-	{	/* 0 */
-		.name		= "PDC20246",
+	{	/* 0: PDC20246 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_pdc202xx,
 		.port_ops	= &pdc20246_port_ops,
 		.dma_ops	= &pdc20246_dma_ops,
@@ -374,10 +375,10 @@ static const struct ide_port_info pdc202xx_chipsets[] __devinitdata = {
 		.udma_mask	= ATA_UDMA2,
 	},
 
-	/* 1 */ DECLARE_PDC2026X_DEV("PDC20262", ATA_UDMA4, 0),
-	/* 2 */ DECLARE_PDC2026X_DEV("PDC20263", ATA_UDMA4, 0),
-	/* 3 */ DECLARE_PDC2026X_DEV("PDC20265", ATA_UDMA5, IDE_HFLAG_RQSIZE_256),
-	/* 4 */ DECLARE_PDC2026X_DEV("PDC20267", ATA_UDMA5, IDE_HFLAG_RQSIZE_256),
+	/* 1: PDC2026{2,3} */
+	DECLARE_PDC2026X_DEV(ATA_UDMA4, 0),
+	/* 2: PDC2026{5,7} */
+	DECLARE_PDC2026X_DEV(ATA_UDMA5, IDE_HFLAG_RQSIZE_256),
 };
 
 /**
@@ -396,31 +397,32 @@ static int __devinit pdc202xx_init_one(struct pci_dev *dev, const struct pci_dev
 
 	d = &pdc202xx_chipsets[idx];
 
-	if (idx < 3)
+	if (idx < 2)
 		pdc202ata4_fixup_irq(dev, d->name);
 
-	if (idx == 3) {
+	if (dev->vendor == PCI_DEVICE_ID_PROMISE_20265) {
 		struct pci_dev *bridge = dev->bus->self;
 
 		if (bridge &&
 		    bridge->vendor == PCI_VENDOR_ID_INTEL &&
 		    (bridge->device == PCI_DEVICE_ID_INTEL_I960 ||
 		     bridge->device == PCI_DEVICE_ID_INTEL_I960RM)) {
-			printk(KERN_INFO "ide: Skipping Promise PDC20265 "
-				"attached to I2O RAID controller\n");
+			printk(KERN_INFO DRV_NAME " %s: skipping Promise "
+				"PDC20265 attached to I2O RAID controller\n",
+				pci_name(dev));
 			return -ENODEV;
 		}
 	}
 
-	return ide_setup_pci_device(dev, d);
+	return ide_pci_init_one(dev, d, NULL);
 }
 
 static const struct pci_device_id pdc202xx_pci_tbl[] = {
 	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20246), 0 },
 	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20262), 1 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20263), 2 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20265), 3 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20267), 4 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20263), 1 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20265), 2 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20267), 2 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, pdc202xx_pci_tbl);
@@ -429,6 +431,7 @@ static struct pci_driver driver = {
 	.name		= "Promise_Old_IDE",
 	.id_table	= pdc202xx_pci_tbl,
 	.probe		= pdc202xx_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init pdc202xx_ide_init(void)
@@ -436,7 +439,13 @@ static int __init pdc202xx_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit pdc202xx_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(pdc202xx_ide_init);
+module_exit(pdc202xx_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick, Frank Tiernan");
 MODULE_DESCRIPTION("PCI driver module for older Promise IDE");
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 0ce41b4..7fc3022 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -54,6 +54,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "piix"
+
 static int no_piix_dma;
 
 /**
@@ -198,13 +200,12 @@ static void piix_set_dma_mode(ide_drive_t *drive, const u8 speed)
 /**
  *	init_chipset_ich	-	set up the ICH chipset
  *	@dev: PCI device to set up
- *	@name: Name of the device
  *
  *	Initialize the PCI device as required.  For the ICH this turns
  *	out to be nice and simple.
  */
 
-static unsigned int __devinit init_chipset_ich(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_ich(struct pci_dev *dev)
 {
 	u32 extra = 0;
 
@@ -314,9 +315,9 @@ static const struct ide_port_ops piix_port_ops = {
  #define IDE_HFLAGS_PIIX 0
 #endif
 
-#define DECLARE_PIIX_DEV(name_str, udma) \
+#define DECLARE_PIIX_DEV(udma) \
 	{						\
-		.name		= name_str,		\
+		.name		= DRV_NAME,		\
 		.init_hwif	= init_hwif_piix,	\
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
 		.port_ops	= &piix_port_ops,	\
@@ -327,9 +328,9 @@ static const struct ide_port_ops piix_port_ops = {
 		.udma_mask	= udma,			\
 	}
 
-#define DECLARE_ICH_DEV(name_str, udma) \
+#define DECLARE_ICH_DEV(udma) \
 	{ \
-		.name		= name_str, \
+		.name		= DRV_NAME, \
 		.init_chipset	= init_chipset_ich, \
 		.init_hwif	= init_hwif_ich, \
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
@@ -342,45 +343,31 @@ static const struct ide_port_ops piix_port_ops = {
 	}
 
 static const struct ide_port_info piix_pci_info[] __devinitdata = {
-	/*  0 */ DECLARE_PIIX_DEV("PIIXa",	0x00),	/* no udma */
-	/*  1 */ DECLARE_PIIX_DEV("PIIXb",	0x00),	/* no udma */
-
-	/*  2 */
+	/* 0: MPIIX */
 	{	/*
 		 * MPIIX actually has only a single IDE channel mapped to
 		 * the primary or secondary ports depending on the value
 		 * of the bit 14 of the IDETIM register at offset 0x6c
 		 */
-		.name		= "MPIIX",
+		.name		= DRV_NAME,
 		.enablebits	= {{0x6d,0xc0,0x80}, {0x6d,0xc0,0xc0}},
 		.host_flags	= IDE_HFLAG_ISA_PORTS | IDE_HFLAG_NO_DMA |
 				  IDE_HFLAGS_PIIX,
 		.pio_mask	= ATA_PIO4,
 		/* This is a painful system best to let it self tune for now */
 	},
-
-	/*  3 */ DECLARE_PIIX_DEV("PIIX3",	0x00),	/* no udma */
-	/*  4 */ DECLARE_PIIX_DEV("PIIX4",	ATA_UDMA2),
-	/*  5 */ DECLARE_ICH_DEV("ICH0",	ATA_UDMA2),
-	/*  6 */ DECLARE_PIIX_DEV("PIIX4",	ATA_UDMA2),
-	/*  7 */ DECLARE_ICH_DEV("ICH",		ATA_UDMA4),
-	/*  8 */ DECLARE_PIIX_DEV("PIIX4",	ATA_UDMA4),
-	/*  9 */ DECLARE_PIIX_DEV("PIIX4",	ATA_UDMA2),
-	/* 10 */ DECLARE_ICH_DEV("ICH2",	ATA_UDMA5),
-	/* 11 */ DECLARE_ICH_DEV("ICH2M",	ATA_UDMA5),
-	/* 12 */ DECLARE_ICH_DEV("ICH3M",	ATA_UDMA5),
-	/* 13 */ DECLARE_ICH_DEV("ICH3",	ATA_UDMA5),
-	/* 14 */ DECLARE_ICH_DEV("ICH4",	ATA_UDMA5),
-	/* 15 */ DECLARE_ICH_DEV("ICH5",	ATA_UDMA5),
-	/* 16 */ DECLARE_ICH_DEV("C-ICH",	ATA_UDMA5),
-	/* 17 */ DECLARE_ICH_DEV("ICH4",	ATA_UDMA5),
-	/* 18 */ DECLARE_ICH_DEV("ICH5-SATA",	ATA_UDMA5),
-	/* 19 */ DECLARE_ICH_DEV("ICH5",	ATA_UDMA5),
-	/* 20 */ DECLARE_ICH_DEV("ICH6",	ATA_UDMA5),
-	/* 21 */ DECLARE_ICH_DEV("ICH7",	ATA_UDMA5),
-	/* 22 */ DECLARE_ICH_DEV("ICH4",	ATA_UDMA5),
-	/* 23 */ DECLARE_ICH_DEV("ESB2",	ATA_UDMA5),
-	/* 24 */ DECLARE_ICH_DEV("ICH8M",	ATA_UDMA5),
+	/* 1: PIIXa/PIIXb/PIIX3 */
+	DECLARE_PIIX_DEV(0x00), /* no udma */
+	/* 2: PIIX4 */
+	DECLARE_PIIX_DEV(ATA_UDMA2),
+	/* 3: ICH0 */
+	DECLARE_ICH_DEV(ATA_UDMA2),
+	/* 4: ICH */
+	DECLARE_ICH_DEV(ATA_UDMA4),
+	/* 5: PIIX4 */
+	DECLARE_PIIX_DEV(ATA_UDMA4),
+	/* 6: ICH[2-7]/ICH[2-3]M/C-ICH/ICH5-SATA/ESB2/ICH8M */
+	DECLARE_ICH_DEV(ATA_UDMA5),
 };
 
 /**
@@ -394,7 +381,7 @@ static const struct ide_port_info piix_pci_info[] __devinitdata = {
  
 static int __devinit piix_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &piix_pci_info[id->driver_data]);
+	return ide_pci_init_one(dev, &piix_pci_info[id->driver_data], NULL);
 }
 
 /**
@@ -421,39 +408,39 @@ static void __devinit piix_check_450nx(void)
 			no_piix_dma = 2;
 	}
 	if(no_piix_dma)
-		printk(KERN_WARNING "piix: 450NX errata present, disabling IDE DMA.\n");
+		printk(KERN_WARNING DRV_NAME ": 450NX errata present, disabling IDE DMA.\n");
 	if(no_piix_dma == 2)
-		printk(KERN_WARNING "piix: A BIOS update may resolve this.\n");
+		printk(KERN_WARNING DRV_NAME ": A BIOS update may resolve this.\n");
 }		
 
 static const struct pci_device_id piix_pci_tbl[] = {
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371FB_0),   0 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371FB_1),   1 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371MX),     2 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371SB_1),   3 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371AB),     4 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801AB_1),   5 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82443MX_1),   6 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801AA_1),   7 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82372FB_1),   8 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82451NX),     9 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801BA_9),  10 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801BA_8),  11 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801CA_10), 12 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801CA_11), 13 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_11), 14 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801EB_11), 15 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801E_11),  16 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_10), 17 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371FB_0),  1 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371FB_1),  1 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371MX),    0 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371SB_1),  1 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371AB),    2 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801AB_1),  3 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82443MX_1),  2 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801AA_1),  4 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82372FB_1),  5 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82451NX),    2 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801BA_9),  6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801BA_8),  6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801CA_10), 6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801CA_11), 6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_11), 6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801EB_11), 6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801E_11),  6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_10), 6 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801EB_1),  18 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801EB_1),  6 },
 #endif
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ESB_2),      19 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH6_19),    20 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH7_21),    21 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_1),  22 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ESB2_18),    23 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH8_6),     24 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ESB_2),      6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH6_19),    6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH7_21),    6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_1),  6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ESB2_18),    6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH8_6),     6 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
@@ -462,6 +449,7 @@ static struct pci_driver driver = {
 	.name		= "PIIX_IDE",
 	.id_table	= piix_pci_tbl,
 	.probe		= piix_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init piix_ide_init(void)
@@ -470,7 +458,13 @@ static int __init piix_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit piix_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(piix_ide_init);
+module_exit(piix_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick, Andrzej Krzysztofowicz");
 MODULE_DESCRIPTION("PCI driver module for Intel PIIX IDE");
diff --git a/drivers/ide/pci/rz1000.c b/drivers/ide/pci/rz1000.c
index 532154a..8d11ee8 100644
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -21,6 +21,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "rz1000"
+
 static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -40,7 +42,7 @@ static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
 }
 
 static const struct ide_port_info rz1000_chipset __devinitdata = {
-	.name		= "RZ100x",
+	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_rz1000,
 	.chipset	= ide_rz1000,
 	.host_flags	= IDE_HFLAG_NO_DMA,
@@ -48,7 +50,7 @@ static const struct ide_port_info rz1000_chipset __devinitdata = {
 
 static int __devinit rz1000_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &rz1000_chipset);
+	return ide_pci_init_one(dev, &rz1000_chipset, NULL);
 }
 
 static const struct pci_device_id rz1000_pci_tbl[] = {
@@ -62,6 +64,7 @@ static struct pci_driver driver = {
 	.name		= "RZ1000_IDE",
 	.id_table	= rz1000_pci_tbl,
 	.probe		= rz1000_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init rz1000_ide_init(void)
@@ -69,7 +72,13 @@ static int __init rz1000_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit rz1000_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(rz1000_ide_init);
+module_exit(rz1000_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for RZ1000 IDE");
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index 14c787b..8efaed1 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -22,6 +22,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "sc1200"
+
 #define SC1200_REV_A	0x00
 #define SC1200_REV_B1	0x01
 #define SC1200_REV_B3	0x02
@@ -234,21 +236,11 @@ static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 	 * we only save state when going from full power to less
 	 */
 	if (state.event == PM_EVENT_ON) {
-		struct sc1200_saved_state *ss;
+		struct ide_host *host = pci_get_drvdata(dev);
+		struct sc1200_saved_state *ss = host->host_priv;
 		unsigned int r;
 
 		/*
-		 * allocate a permanent save area, if not already allocated
-		 */
-		ss = (struct sc1200_saved_state *)pci_get_drvdata(dev);
-		if (ss == NULL) {
-			ss = kmalloc(sizeof(*ss), GFP_KERNEL);
-			if (ss == NULL)
-				return -ENOMEM;
-			pci_set_drvdata(dev, ss);
-		}
-
-		/*
 		 * save timing registers
 		 * (this may be unnecessary if BIOS also does it)
 		 */
@@ -263,7 +255,8 @@ static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 
 static int sc1200_resume (struct pci_dev *dev)
 {
-	struct sc1200_saved_state *ss;
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct sc1200_saved_state *ss = host->host_priv;
 	unsigned int r;
 	int i;
 
@@ -271,16 +264,12 @@ static int sc1200_resume (struct pci_dev *dev)
 	if (i)
 		return i;
 
-	ss = (struct sc1200_saved_state *)pci_get_drvdata(dev);
-
 	/*
 	 * restore timing registers
 	 * (this may be unnecessary if BIOS also does it)
 	 */
-	if (ss) {
-		for (r = 0; r < 8; r++)
-			pci_write_config_dword(dev, 0x40 + r * 4, ss->regs[r]);
-	}
+	for (r = 0; r < 8; r++)
+		pci_write_config_dword(dev, 0x40 + r * 4, ss->regs[r]);
 
 	return 0;
 }
@@ -304,7 +293,7 @@ static const struct ide_dma_ops sc1200_dma_ops = {
 };
 
 static const struct ide_port_info sc1200_chipset __devinitdata = {
-	.name		= "SC1200",
+	.name		= DRV_NAME,
 	.port_ops	= &sc1200_port_ops,
 	.dma_ops	= &sc1200_dma_ops,
 	.host_flags	= IDE_HFLAG_SERIALIZE |
@@ -317,7 +306,19 @@ static const struct ide_port_info sc1200_chipset __devinitdata = {
 
 static int __devinit sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &sc1200_chipset);
+	struct sc1200_saved_state *ss = NULL;
+	int rc;
+
+#ifdef CONFIG_PM
+	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
+	if (ss == NULL)
+		return -ENOMEM;
+#endif
+	rc = ide_pci_init_one(dev, &sc1200_chipset, ss);
+	if (rc)
+		kfree(ss);
+
+	return rc;
 }
 
 static const struct pci_device_id sc1200_pci_tbl[] = {
@@ -330,6 +331,7 @@ static struct pci_driver driver = {
 	.name		= "SC1200_IDE",
 	.id_table	= sc1200_pci_tbl,
 	.probe		= sc1200_init_one,
+	.remove		= ide_pci_remove,
 #ifdef CONFIG_PM
 	.suspend	= sc1200_suspend,
 	.resume		= sc1200_resume,
@@ -341,7 +343,13 @@ static int __init sc1200_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit sc1200_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(sc1200_ide_init);
+module_exit(sc1200_ide_exit);
 
 MODULE_AUTHOR("Mark Lord");
 MODULE_DESCRIPTION("PCI driver module for NS SC1200 IDE");
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index 127ccb4..d173f29 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -38,6 +38,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "serverworks"
+
 #define SVWKS_CSB5_REVISION_NEW	0x92 /* min PCI_REVISION_ID for UDMA5 (A2.0) */
 #define SVWKS_CSB6_REVISION	0xa0 /* min PCI_REVISION_ID for UDMA4 (A1.0) */
 
@@ -172,7 +174,7 @@ static void svwks_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	pci_write_config_byte(dev, 0x54, ultra_enable);
 }
 
-static unsigned int __devinit init_chipset_svwks (struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_svwks(struct pci_dev *dev)
 {
 	unsigned int reg;
 	u8 btr;
@@ -188,7 +190,8 @@ static unsigned int __devinit init_chipset_svwks (struct pci_dev *dev, const cha
 			pci_read_config_dword(isa_dev, 0x64, &reg);
 			reg &= ~0x00002000; /* disable 600ns interrupt mask */
 			if(!(reg & 0x00004000))
-				printk(KERN_DEBUG "%s: UDMA not BIOS enabled.\n", name);
+				printk(KERN_DEBUG DRV_NAME " %s: UDMA not BIOS "
+					"enabled.\n", pci_name(dev));
 			reg |=  0x00004000; /* enable UDMA/33 support */
 			pci_write_config_dword(isa_dev, 0x64, reg);
 		}
@@ -352,40 +355,44 @@ static const struct ide_port_ops svwks_port_ops = {
 #define IDE_HFLAGS_SVWKS IDE_HFLAG_LEGACY_IRQS
 
 static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
-	{	/* 0 */
-		.name		= "SvrWks OSB4",
+	{	/* 0: OSB4 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &osb4_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= 0x00, /* UDMA is problematic on OSB4 */
-	},{	/* 1 */
-		.name		= "SvrWks CSB5",
+	},
+	{	/* 1: CSB5 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
-	},{	/* 2 */
-		.name		= "SvrWks CSB6",
+	},
+	{	/* 2: CSB6 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
-	},{	/* 3 */
-		.name		= "SvrWks CSB6",
+	},
+	{	/* 3: CSB6-2 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
-	},{	/* 4 */
-		.name		= "SvrWks HT1000",
+	},
+	{	/* 4: HT1000 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS | IDE_HFLAG_SINGLE,
@@ -422,7 +429,7 @@ static int __devinit svwks_init_one(struct pci_dev *dev, const struct pci_device
 			d.host_flags &= ~IDE_HFLAG_SINGLE;
 	}
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 static const struct pci_device_id svwks_pci_tbl[] = {
@@ -439,6 +446,7 @@ static struct pci_driver driver = {
 	.name		= "Serverworks_IDE",
 	.id_table	= svwks_pci_tbl,
 	.probe		= svwks_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init svwks_ide_init(void)
@@ -446,7 +454,13 @@ static int __init svwks_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit svwks_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(svwks_ide_init);
+module_exit(svwks_ide_exit);
 
 MODULE_AUTHOR("Michael Aubry. Andrzej Krzysztofowicz, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for Serverworks OSB4/CSB5/CSB6 IDE");
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 5965a35..b8ad9ad 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -44,6 +44,8 @@
 #include <linux/init.h>
 #include <linux/io.h>
 
+#define DRV_NAME "siimage"
+
 /**
  *	pdev_is_sata		-	check if device is SATA
  *	@pdev:	PCI device to check
@@ -127,9 +129,10 @@ static inline unsigned long siimage_seldev(ide_drive_t *drive, int r)
 
 static u8 sil_ioread8(struct pci_dev *dev, unsigned long addr)
 {
+	struct ide_host *host = pci_get_drvdata(dev);
 	u8 tmp = 0;
 
-	if (pci_get_drvdata(dev))
+	if (host->host_priv)
 		tmp = readb((void __iomem *)addr);
 	else
 		pci_read_config_byte(dev, addr, &tmp);
@@ -139,9 +142,10 @@ static u8 sil_ioread8(struct pci_dev *dev, unsigned long addr)
 
 static u16 sil_ioread16(struct pci_dev *dev, unsigned long addr)
 {
+	struct ide_host *host = pci_get_drvdata(dev);
 	u16 tmp = 0;
 
-	if (pci_get_drvdata(dev))
+	if (host->host_priv)
 		tmp = readw((void __iomem *)addr);
 	else
 		pci_read_config_word(dev, addr, &tmp);
@@ -151,7 +155,9 @@ static u16 sil_ioread16(struct pci_dev *dev, unsigned long addr)
 
 static void sil_iowrite8(struct pci_dev *dev, u8 val, unsigned long addr)
 {
-	if (pci_get_drvdata(dev))
+	struct ide_host *host = pci_get_drvdata(dev);
+
+	if (host->host_priv)
 		writeb(val, (void __iomem *)addr);
 	else
 		pci_write_config_byte(dev, addr, val);
@@ -159,7 +165,9 @@ static void sil_iowrite8(struct pci_dev *dev, u8 val, unsigned long addr)
 
 static void sil_iowrite16(struct pci_dev *dev, u16 val, unsigned long addr)
 {
-	if (pci_get_drvdata(dev))
+	struct ide_host *host = pci_get_drvdata(dev);
+
+	if (host->host_priv)
 		writew(val, (void __iomem *)addr);
 	else
 		pci_write_config_word(dev, addr, val);
@@ -167,7 +175,9 @@ static void sil_iowrite16(struct pci_dev *dev, u16 val, unsigned long addr)
 
 static void sil_iowrite32(struct pci_dev *dev, u32 val, unsigned long addr)
 {
-	if (pci_get_drvdata(dev))
+	struct ide_host *host = pci_get_drvdata(dev);
+
+	if (host->host_priv)
 		writel(val, (void __iomem *)addr);
 	else
 		pci_write_config_dword(dev, addr, val);
@@ -445,66 +455,24 @@ static void sil_sata_pre_reset(ide_drive_t *drive)
 }
 
 /**
- *	setup_mmio_siimage	-	switch controller into MMIO mode
- *	@dev: PCI device we are configuring
- *	@name: device name
- *
- *	Attempt to put the device into MMIO mode. There are some slight
- *	complications here with certain systems where the MMIO BAR isn't
- *	mapped, so we have to be sure that we can fall back to I/O.
- */
-
-static unsigned int setup_mmio_siimage(struct pci_dev *dev, const char *name)
-{
-	resource_size_t bar5	= pci_resource_start(dev, 5);
-	unsigned long barsize	= pci_resource_len(dev, 5);
-	void __iomem *ioaddr;
-
-	/*
-	 *	Drop back to PIO if we can't map the MMIO. Some	systems
-	 *	seem to get terminally confused in the PCI spaces.
-	 */
-	if (!request_mem_region(bar5, barsize, name)) {
-		printk(KERN_WARNING "siimage: IDE controller MMIO ports not "
-				    "available.\n");
-		return 0;
-	}
-
-	ioaddr = ioremap(bar5, barsize);
-	if (ioaddr == NULL) {
-		release_mem_region(bar5, barsize);
-		return 0;
-	}
-
-	pci_set_master(dev);
-	pci_set_drvdata(dev, (void *) ioaddr);
-
-	return 1;
-}
-
-/**
  *	init_chipset_siimage	-	set up an SI device
  *	@dev: PCI device
- *	@name: device name
  *
  *	Perform the initial PCI set up for this device. Attempt to switch
  *	to 133 MHz clocking if the system isn't already set up to do it.
  */
 
-static unsigned int __devinit init_chipset_siimage(struct pci_dev *dev,
-						   const char *name)
+static unsigned int __devinit init_chipset_siimage(struct pci_dev *dev)
 {
+	struct ide_host *host = pci_get_drvdata(dev);
+	void __iomem *ioaddr = host->host_priv;
 	unsigned long base, scsc_addr;
-	void __iomem *ioaddr = NULL;
-	u8 rev = dev->revision, tmp, BA5_EN;
+	u8 rev = dev->revision, tmp;
 
 	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, rev ? 1 : 255);
 
-	pci_read_config_byte(dev, 0x8A, &BA5_EN);
-
-	if ((BA5_EN & 0x01) || pci_resource_start(dev, 5))
-		if (setup_mmio_siimage(dev, name))
-			ioaddr = pci_get_drvdata(dev);
+	if (ioaddr)
+		pci_set_master(dev);
 
 	base = (unsigned long)ioaddr;
 
@@ -571,7 +539,8 @@ static unsigned int __devinit init_chipset_siimage(struct pci_dev *dev,
 			{ "== 100", "== 133", "== 2X PCI", "DISABLED!" };
 
 		tmp >>= 4;
-		printk(KERN_INFO "%s: BASE CLOCK %s\n", name, clk_str[tmp & 3]);
+		printk(KERN_INFO DRV_NAME " %s: BASE CLOCK %s\n",
+			pci_name(dev), clk_str[tmp & 3]);
 	}
 
 	return 0;
@@ -592,7 +561,8 @@ static unsigned int __devinit init_chipset_siimage(struct pci_dev *dev,
 static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	void *addr		= pci_get_drvdata(dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	void *addr		= host->host_priv;
 	u8 ch			= hwif->channel;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	unsigned long base;
@@ -691,16 +661,15 @@ static void __devinit sil_quirkproc(ide_drive_t *drive)
 static void __devinit init_iops_siimage(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	struct ide_host *host = pci_get_drvdata(dev);
 
 	hwif->hwif_data = NULL;
 
 	/* Pessimal until we finish probing */
 	hwif->rqsize = 15;
 
-	if (pci_get_drvdata(dev) == NULL)
-		return;
-
-	init_mmio_iops_siimage(hwif);
+	if (host->host_priv)
+		init_mmio_iops_siimage(hwif);
 }
 
 /**
@@ -748,9 +717,9 @@ static const struct ide_dma_ops sil_dma_ops = {
 	.dma_lost_irq		= ide_dma_lost_irq,
 };
 
-#define DECLARE_SII_DEV(name_str, p_ops)		\
+#define DECLARE_SII_DEV(p_ops)				\
 	{						\
-		.name		= name_str,		\
+		.name		= DRV_NAME,		\
 		.init_chipset	= init_chipset_siimage,	\
 		.init_iops	= init_iops_siimage,	\
 		.port_ops	= p_ops,		\
@@ -761,9 +730,8 @@ static const struct ide_dma_ops sil_dma_ops = {
 	}
 
 static const struct ide_port_info siimage_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_SII_DEV("SiI680",		&sil_pata_port_ops),
-	/* 1 */ DECLARE_SII_DEV("SiI3112 Serial ATA",	&sil_sata_port_ops),
-	/* 2 */ DECLARE_SII_DEV("Adaptec AAR-1210SA",	&sil_sata_port_ops)
+	/* 0: SiI680 */  DECLARE_SII_DEV(&sil_pata_port_ops),
+	/* 1: SiI3112 */ DECLARE_SII_DEV(&sil_sata_port_ops)
 };
 
 /**
@@ -778,8 +746,13 @@ static const struct ide_port_info siimage_chipsets[] __devinitdata = {
 static int __devinit siimage_init_one(struct pci_dev *dev,
 				      const struct pci_device_id *id)
 {
+	void __iomem *ioaddr = NULL;
+	resource_size_t bar5 = pci_resource_start(dev, 5);
+	unsigned long barsize = pci_resource_len(dev, 5);
+	int rc;
 	struct ide_port_info d;
 	u8 idx = id->driver_data;
+	u8 BA5_EN;
 
 	d = siimage_chipsets[idx];
 
@@ -787,7 +760,7 @@ static int __devinit siimage_init_one(struct pci_dev *dev,
 		static int first = 1;
 
 		if (first) {
-			printk(KERN_INFO "siimage: For full SATA support you "
+			printk(KERN_INFO DRV_NAME ": For full SATA support you "
 				"should use the libata sata_sil module.\n");
 			first = 0;
 		}
@@ -795,14 +768,61 @@ static int __devinit siimage_init_one(struct pci_dev *dev,
 		d.host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 	}
 
-	return ide_setup_pci_device(dev, &d);
+	rc = pci_enable_device(dev);
+	if (rc)
+		return rc;
+
+	pci_read_config_byte(dev, 0x8A, &BA5_EN);
+	if ((BA5_EN & 0x01) || bar5) {
+		/*
+		* Drop back to PIO if we can't map the MMIO. Some systems
+		* seem to get terminally confused in the PCI spaces.
+		*/
+		if (!request_mem_region(bar5, barsize, d.name)) {
+			printk(KERN_WARNING DRV_NAME " %s: MMIO ports not "
+				"available\n", pci_name(dev));
+		} else {
+			ioaddr = ioremap(bar5, barsize);
+			if (ioaddr == NULL)
+				release_mem_region(bar5, barsize);
+		}
+	}
+
+	rc = ide_pci_init_one(dev, &d, ioaddr);
+	if (rc) {
+		if (ioaddr) {
+			iounmap(ioaddr);
+			release_mem_region(bar5, barsize);
+		}
+		pci_disable_device(dev);
+	}
+
+	return rc;
+}
+
+static void __devexit siimage_remove(struct pci_dev *dev)
+{
+	struct ide_host *host = pci_get_drvdata(dev);
+	void __iomem *ioaddr = host->host_priv;
+
+	ide_pci_remove(dev);
+
+	if (ioaddr) {
+		resource_size_t bar5 = pci_resource_start(dev, 5);
+		unsigned long barsize = pci_resource_len(dev, 5);
+
+		iounmap(ioaddr);
+		release_mem_region(bar5, barsize);
+	}
+
+	pci_disable_device(dev);
 }
 
 static const struct pci_device_id siimage_pci_tbl[] = {
 	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_SII_680),    0 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
 	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_SII_3112),   1 },
-	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_SII_1210SA), 2 },
+	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_SII_1210SA), 1 },
 #endif
 	{ 0, },
 };
@@ -812,6 +832,7 @@ static struct pci_driver driver = {
 	.name		= "SiI_IDE",
 	.id_table	= siimage_pci_tbl,
 	.probe		= siimage_init_one,
+	.remove		= siimage_remove,
 };
 
 static int __init siimage_ide_init(void)
@@ -819,7 +840,13 @@ static int __init siimage_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit siimage_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(siimage_ide_init);
+module_exit(siimage_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick, Alan Cox");
 MODULE_DESCRIPTION("PCI driver module for SiI IDE");
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 2389945..cc95f90 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -52,6 +52,8 @@
 #include <linux/init.h>
 #include <linux/ide.h>
 
+#define DRV_NAME "sis5513"
+
 /* registers layout and init values are chipset family dependant */
 
 #define ATA_16		0x01
@@ -380,8 +382,9 @@ static int __devinit sis_find_family(struct pci_dev *dev)
 		}
 		pci_dev_put(host);
 
-		printk(KERN_INFO "SIS5513: %s %s controller\n",
-			 SiSHostChipInfo[i].name, chipset_capability[chipset_family]);
+		printk(KERN_INFO DRV_NAME " %s: %s %s controller\n",
+			pci_name(dev), SiSHostChipInfo[i].name,
+			chipset_capability[chipset_family]);
 	}
 
 	if (!chipset_family) { /* Belongs to pci-quirks */
@@ -396,7 +399,8 @@ static int __devinit sis_find_family(struct pci_dev *dev)
 			pci_write_config_dword(dev, 0x54, idemisc);
 
 			if (trueid == 0x5518) {
-				printk(KERN_INFO "SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller\n");
+				printk(KERN_INFO DRV_NAME " %s: SiS 962/963 MuTIOL IDE UDMA133 controller\n",
+					pci_name(dev));
 				chipset_family = ATA_133;
 
 				/* Check for 5513 compability mapping
@@ -405,7 +409,8 @@ static int __devinit sis_find_family(struct pci_dev *dev)
 				 */
 				if ((idemisc & 0x40000000) == 0) {
 					pci_write_config_dword(dev, 0x54, idemisc | 0x40000000);
-					printk(KERN_INFO "SIS5513: Switching to 5513 register mapping\n");
+					printk(KERN_INFO DRV_NAME " %s: Switching to 5513 register mapping\n",
+						pci_name(dev));
 				}
 			}
 	}
@@ -429,10 +434,12 @@ static int __devinit sis_find_family(struct pci_dev *dev)
 				pci_dev_put(lpc_bridge);
 
 				if (lpc_bridge->revision == 0x10 && (prefctl & 0x80)) {
-					printk(KERN_INFO "SIS5513: SiS 961B MuTIOL IDE UDMA133 controller\n");
+					printk(KERN_INFO DRV_NAME " %s: SiS 961B MuTIOL IDE UDMA133 controller\n",
+						pci_name(dev));
 					chipset_family = ATA_133a;
 				} else {
-					printk(KERN_INFO "SIS5513: SiS 961 MuTIOL IDE UDMA100 controller\n");
+					printk(KERN_INFO DRV_NAME " %s: SiS 961 MuTIOL IDE UDMA100 controller\n",
+						pci_name(dev));
 					chipset_family = ATA_100;
 				}
 			}
@@ -441,8 +448,7 @@ static int __devinit sis_find_family(struct pci_dev *dev)
 	return chipset_family;
 }
 
-static unsigned int __devinit init_chipset_sis5513(struct pci_dev *dev,
-						   const char *name)
+static unsigned int __devinit init_chipset_sis5513(struct pci_dev *dev)
 {
 	/* Make general config ops here
 	   1/ tell IDE channels to operate in Compatibility mode only
@@ -555,7 +561,7 @@ static const struct ide_port_ops sis_ata133_port_ops = {
 };
 
 static const struct ide_port_info sis5513_chipset __devinitdata = {
-	.name		= "SIS5513",
+	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_sis5513,
 	.enablebits	= { {0x4a, 0x02, 0x02}, {0x4a, 0x04, 0x04} },
 	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_NO_AUTODMA,
@@ -583,7 +589,13 @@ static int __devinit sis5513_init_one(struct pci_dev *dev, const struct pci_devi
 
 	d.udma_mask = udma_rates[chipset_family];
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
+}
+
+static void __devexit sis5513_remove(struct pci_dev *dev)
+{
+	ide_pci_remove(dev);
+	pci_disable_device(dev);
 }
 
 static const struct pci_device_id sis5513_pci_tbl[] = {
@@ -598,6 +610,7 @@ static struct pci_driver driver = {
 	.name		= "SIS_IDE",
 	.id_table	= sis5513_pci_tbl,
 	.probe		= sis5513_init_one,
+	.remove		= sis5513_remove,
 };
 
 static int __init sis5513_ide_init(void)
@@ -605,7 +618,13 @@ static int __init sis5513_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit sis5513_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(sis5513_ide_init);
+module_exit(sis5513_ide_exit);
 
 MODULE_AUTHOR("Lionel Bouton, L C Chang, Andre Hedrick, Vojtech Pavlik");
 MODULE_DESCRIPTION("PCI driver module for SIS IDE");
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index f82a650..73905bc 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -23,6 +23,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "sl82c105"
+
 #undef DEBUG
 
 #ifdef DEBUG
@@ -270,7 +272,7 @@ static u8 sl82c105_bridge_revision(struct pci_dev *dev)
  * channel 0 here at least, but channel 1 has to be enabled by
  * firmware or arch code. We still set both to 16 bits mode.
  */
-static unsigned int __devinit init_chipset_sl82c105(struct pci_dev *dev, const char *msg)
+static unsigned int __devinit init_chipset_sl82c105(struct pci_dev *dev)
 {
 	u32 val;
 
@@ -301,7 +303,7 @@ static const struct ide_dma_ops sl82c105_dma_ops = {
 };
 
 static const struct ide_port_info sl82c105_chipset __devinitdata = {
-	.name		= "W82C105",
+	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_sl82c105,
 	.enablebits	= {{0x40,0x01,0x01}, {0x40,0x10,0x10}},
 	.port_ops	= &sl82c105_port_ops,
@@ -328,14 +330,14 @@ static int __devinit sl82c105_init_one(struct pci_dev *dev, const struct pci_dev
 		 * Never ever EVER under any circumstances enable
 		 * DMA when the bridge is this old.
 		 */
-		printk(KERN_INFO "W82C105_IDE: Winbond W83C553 bridge "
+		printk(KERN_INFO DRV_NAME ": Winbond W83C553 bridge "
 				 "revision %d, BM-DMA disabled\n", rev);
 		d.dma_ops = NULL;
 		d.mwdma_mask = 0;
 		d.host_flags &= ~IDE_HFLAG_SERIALIZE_DMA;
 	}
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 static const struct pci_device_id sl82c105_pci_tbl[] = {
@@ -348,6 +350,7 @@ static struct pci_driver driver = {
 	.name		= "W82C105_IDE",
 	.id_table	= sl82c105_pci_tbl,
 	.probe		= sl82c105_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init sl82c105_ide_init(void)
@@ -355,7 +358,13 @@ static int __init sl82c105_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit sl82c105_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(sl82c105_ide_init);
+module_exit(sl82c105_ide_exit);
 
 MODULE_DESCRIPTION("PCI driver module for W82C105 IDE");
 MODULE_LICENSE("GPL");
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index dae6e2c..13d1fa4 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -15,6 +15,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "slc90e66"
+
 static DEFINE_SPINLOCK(slc90e66_lock);
 
 static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -132,7 +134,7 @@ static const struct ide_port_ops slc90e66_port_ops = {
 };
 
 static const struct ide_port_info slc90e66_chipset __devinitdata = {
-	.name		= "SLC90E66",
+	.name		= DRV_NAME,
 	.enablebits	= { {0x41, 0x80, 0x80}, {0x43, 0x80, 0x80} },
 	.port_ops	= &slc90e66_port_ops,
 	.host_flags	= IDE_HFLAG_LEGACY_IRQS,
@@ -144,7 +146,7 @@ static const struct ide_port_info slc90e66_chipset __devinitdata = {
 
 static int __devinit slc90e66_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &slc90e66_chipset);
+	return ide_pci_init_one(dev, &slc90e66_chipset, NULL);
 }
 
 static const struct pci_device_id slc90e66_pci_tbl[] = {
@@ -157,6 +159,7 @@ static struct pci_driver driver = {
 	.name		= "SLC90e66_IDE",
 	.id_table	= slc90e66_pci_tbl,
 	.probe		= slc90e66_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init slc90e66_ide_init(void)
@@ -164,7 +167,13 @@ static int __init slc90e66_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit slc90e66_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(slc90e66_ide_init);
+module_exit(slc90e66_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for SLC90E66 IDE");
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index 477e197..b1cb8a9 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -11,6 +11,8 @@
 #include <linux/pci.h>
 #include <linux/ide.h>
 
+#define DRV_NAME "tc86c001"
+
 static void tc86c001_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
@@ -173,16 +175,6 @@ static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 	hwif->rqsize	 = 0xffff;
 }
 
-static unsigned int __devinit init_chipset_tc86c001(struct pci_dev *dev,
-							const char *name)
-{
-	int err = pci_request_region(dev, 5, name);
-
-	if (err)
-		printk(KERN_ERR "%s: system control regs already in use", name);
-	return err;
-}
-
 static const struct ide_port_ops tc86c001_port_ops = {
 	.set_pio_mode		= tc86c001_set_pio_mode,
 	.set_dma_mode		= tc86c001_set_mode,
@@ -201,8 +193,7 @@ static const struct ide_dma_ops tc86c001_dma_ops = {
 };
 
 static const struct ide_port_info tc86c001_chipset __devinitdata = {
-	.name		= "TC86C001",
-	.init_chipset	= init_chipset_tc86c001,
+	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_tc86c001,
 	.port_ops	= &tc86c001_port_ops,
 	.dma_ops	= &tc86c001_dma_ops,
@@ -215,7 +206,37 @@ static const struct ide_port_info tc86c001_chipset __devinitdata = {
 static int __devinit tc86c001_init_one(struct pci_dev *dev,
 				       const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &tc86c001_chipset);
+	int rc;
+
+	rc = pci_enable_device(dev);
+	if (rc)
+		goto out;
+
+	rc = pci_request_region(dev, 5, DRV_NAME);
+	if (rc) {
+		printk(KERN_ERR DRV_NAME ": system control regs already in use");
+		goto out_disable;
+	}
+
+	rc = ide_pci_init_one(dev, &tc86c001_chipset, NULL);
+	if (rc)
+		goto out_release;
+
+	goto out;
+
+out_release:
+	pci_release_region(dev, 5);
+out_disable:
+	pci_disable_device(dev);
+out:
+	return rc;
+}
+
+static void __devexit tc86c001_remove(struct pci_dev *dev)
+{
+	ide_pci_remove(dev);
+	pci_release_region(dev, 5);
+	pci_disable_device(dev);
 }
 
 static const struct pci_device_id tc86c001_pci_tbl[] = {
@@ -227,14 +248,22 @@ MODULE_DEVICE_TABLE(pci, tc86c001_pci_tbl);
 static struct pci_driver driver = {
 	.name		= "TC86C001",
 	.id_table	= tc86c001_pci_tbl,
-	.probe		= tc86c001_init_one
+	.probe		= tc86c001_init_one,
+	.remove		= tc86c001_remove,
 };
 
 static int __init tc86c001_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
+
+static void __exit tc86c001_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(tc86c001_ide_init);
+module_exit(tc86c001_ide_exit);
 
 MODULE_AUTHOR("MontaVista Software, Inc. <source@mvista.com>");
 MODULE_DESCRIPTION("PCI driver module for TC86C001 IDE");
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index db65a55..b77ec35 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -33,6 +33,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "triflex"
+
 static void triflex_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif = HWIF(drive);
@@ -93,7 +95,7 @@ static const struct ide_port_ops triflex_port_ops = {
 };
 
 static const struct ide_port_info triflex_device __devinitdata = {
-	.name		= "TRIFLEX",
+	.name		= DRV_NAME,
 	.enablebits	= {{0x80, 0x01, 0x01}, {0x80, 0x02, 0x02}},
 	.port_ops	= &triflex_port_ops,
 	.pio_mask	= ATA_PIO4,
@@ -104,7 +106,7 @@ static const struct ide_port_info triflex_device __devinitdata = {
 static int __devinit triflex_init_one(struct pci_dev *dev, 
 		const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &triflex_device);
+	return ide_pci_init_one(dev, &triflex_device, NULL);
 }
 
 static const struct pci_device_id triflex_pci_tbl[] = {
@@ -117,6 +119,7 @@ static struct pci_driver driver = {
 	.name		= "TRIFLEX_IDE",
 	.id_table	= triflex_pci_tbl,
 	.probe		= triflex_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init triflex_ide_init(void)
@@ -124,7 +127,13 @@ static int __init triflex_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit triflex_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(triflex_ide_init);
+module_exit(triflex_ide_exit);
 
 MODULE_AUTHOR("Torben Mathiasen");
 MODULE_DESCRIPTION("PCI driver module for Compaq Triflex IDE");
diff --git a/drivers/ide/pci/trm290.c b/drivers/ide/pci/trm290.c
index a8a3138..fd28b49 100644
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -141,6 +141,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "trm290"
+
 static void trm290_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 {
 	ide_hwif_t *hwif = HWIF(drive);
@@ -245,10 +247,10 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 	u8 reg = 0;
 
 	if ((dev->class & 5) && cfg_base)
-		printk(KERN_INFO "TRM290: chip");
+		printk(KERN_INFO DRV_NAME " %s: chip", pci_name(dev));
 	else {
 		cfg_base = 0x3df0;
-		printk(KERN_INFO "TRM290: using default");
+		printk(KERN_INFO DRV_NAME " %s: using default", pci_name(dev));
 	}
 	printk(KERN_CONT " config base at 0x%04x\n", cfg_base);
 	hwif->config_data = cfg_base;
@@ -325,7 +327,7 @@ static struct ide_dma_ops trm290_dma_ops = {
 };
 
 static const struct ide_port_info trm290_chipset __devinitdata = {
-	.name		= "TRM290",
+	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_trm290,
 	.chipset	= ide_trm290,
 	.port_ops	= &trm290_port_ops,
@@ -340,7 +342,7 @@ static const struct ide_port_info trm290_chipset __devinitdata = {
 
 static int __devinit trm290_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &trm290_chipset);
+	return ide_pci_init_one(dev, &trm290_chipset, NULL);
 }
 
 static const struct pci_device_id trm290_pci_tbl[] = {
@@ -353,6 +355,7 @@ static struct pci_driver driver = {
 	.name		= "TRM290_IDE",
 	.id_table	= trm290_pci_tbl,
 	.probe		= trm290_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init trm290_ide_init(void)
@@ -360,7 +363,13 @@ static int __init trm290_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit trm290_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(trm290_ide_init);
+module_exit(trm290_ide_exit);
 
 MODULE_AUTHOR("Mark Lord");
 MODULE_DESCRIPTION("PCI driver module for Tekram TRM290 IDE");
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index 09dc480..454d2bf 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -35,6 +35,8 @@
 #include <asm/processor.h>
 #endif
 
+#define DRV_NAME "via82cxxx"
+
 #define VIA_IDE_ENABLE		0x40
 #define VIA_IDE_CONFIG		0x41
 #define VIA_FIFO_CONFIG		0x43
@@ -113,7 +115,8 @@ struct via82cxxx_dev
 static void via_set_speed(ide_hwif_t *hwif, u8 dn, struct ide_timing *timing)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct via82cxxx_dev *vdev = pci_get_drvdata(dev);
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct via82cxxx_dev *vdev = host->host_priv;
 	u8 t;
 
 	if (~vdev->via_config->flags & VIA_BAD_AST) {
@@ -153,7 +156,8 @@ static void via_set_drive(ide_drive_t *drive, const u8 speed)
 	ide_hwif_t *hwif = drive->hwif;
 	ide_drive_t *peer = hwif->drives + (~drive->dn & 1);
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct via82cxxx_dev *vdev = pci_get_drvdata(dev);
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct via82cxxx_dev *vdev = host->host_priv;
 	struct ide_timing t, p;
 	unsigned int T, UT;
 
@@ -258,37 +262,19 @@ static void __devinit via_cable_detect(struct via82cxxx_dev *vdev, u32 u)
 /**
  *	init_chipset_via82cxxx	-	initialization handler
  *	@dev: PCI device
- *	@name: Name of interface
  *
  *	The initialization callback. Here we determine the IDE chip type
  *	and initialize its drive independent registers.
  */
 
-static unsigned int __devinit init_chipset_via82cxxx(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_via82cxxx(struct pci_dev *dev)
 {
-	struct pci_dev *isa = NULL;
-	struct via82cxxx_dev *vdev;
-	struct via_isa_bridge *via_config;
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct via82cxxx_dev *vdev = host->host_priv;
+	struct via_isa_bridge *via_config = vdev->via_config;
 	u8 t, v;
 	u32 u;
 
-	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-	if (!vdev) {
-		printk(KERN_ERR "VP_IDE: out of memory :(\n");
-		return -ENOMEM;
-	}
-	pci_set_drvdata(dev, vdev);
-
-	/*
-	 * Find the ISA bridge to see how good the IDE is.
-	 */
-	vdev->via_config = via_config = via_config_find(&isa);
-
-	/* We checked this earlier so if it fails here deeep badness
-	   is involved */
-
-	BUG_ON(!via_config->id);
-
 	/*
 	 * Detect cable and configure Clk66
 	 */
@@ -334,39 +320,6 @@ static unsigned int __devinit init_chipset_via82cxxx(struct pci_dev *dev, const
 
 	pci_write_config_byte(dev, VIA_FIFO_CONFIG, t);
 
-	/*
-	 * Determine system bus clock.
-	 */
-
-	via_clock = (ide_pci_clk ? ide_pci_clk : 33) * 1000;
-
-	switch (via_clock) {
-		case 33000: via_clock = 33333; break;
-		case 37000: via_clock = 37500; break;
-		case 41000: via_clock = 41666; break;
-	}
-
-	if (via_clock < 20000 || via_clock > 50000) {
-		printk(KERN_WARNING "VP_IDE: User given PCI clock speed "
-			"impossible (%d), using 33 MHz instead.\n", via_clock);
-		printk(KERN_WARNING "VP_IDE: Use ide0=ata66 if you want "
-			"to assume 80-wire cable.\n");
-		via_clock = 33333;
-	}
-
-	/*
-	 * Print the boot message.
-	 */
-
-	printk(KERN_INFO "VP_IDE: VIA %s (rev %02x) IDE %sDMA%s "
-		"controller on pci%s\n",
-		via_config->name, isa->revision,
-		via_config->udma_mask ? "U" : "MW",
-		via_dma[via_config->udma_mask ?
-			(fls(via_config->udma_mask) - 1) : 0],
-		pci_name(dev));
-
-	pci_dev_put(isa);
 	return 0;
 }
 
@@ -402,7 +355,8 @@ static int via_cable_override(struct pci_dev *pdev)
 static u8 __devinit via82cxxx_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	struct via82cxxx_dev *vdev = pci_get_drvdata(pdev);
+	struct ide_host *host = pci_get_drvdata(pdev);
+	struct via82cxxx_dev *vdev = host->host_priv;
 
 	if (via_cable_override(pdev))
 		return ATA_CBL_PATA40_SHORT;
@@ -420,7 +374,7 @@ static const struct ide_port_ops via_port_ops = {
 };
 
 static const struct ide_port_info via82cxxx_chipset __devinitdata = {
-	.name		= "VP_IDE",
+	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_via82cxxx,
 	.enablebits	= { { 0x40, 0x02, 0x02 }, { 0x40, 0x01, 0x01 } },
 	.port_ops	= &via_port_ops,
@@ -436,6 +390,8 @@ static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_i
 {
 	struct pci_dev *isa = NULL;
 	struct via_isa_bridge *via_config;
+	struct via82cxxx_dev *vdev;
+	int rc;
 	u8 idx = id->driver_data;
 	struct ide_port_info d;
 
@@ -445,12 +401,42 @@ static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_i
 	 * Find the ISA bridge and check we know what it is.
 	 */
 	via_config = via_config_find(&isa);
-	pci_dev_put(isa);
 	if (!via_config->id) {
-		printk(KERN_WARNING "VP_IDE: Unknown VIA SouthBridge, disabling DMA.\n");
+		printk(KERN_WARNING DRV_NAME " %s: unknown chipset, skipping\n",
+			pci_name(dev));
 		return -ENODEV;
 	}
 
+	/*
+	 * Print the boot message.
+	 */
+	printk(KERN_INFO DRV_NAME " %s: VIA %s (rev %02x) IDE %sDMA%s\n",
+		pci_name(dev), via_config->name, isa->revision,
+		via_config->udma_mask ? "U" : "MW",
+		via_dma[via_config->udma_mask ?
+			(fls(via_config->udma_mask) - 1) : 0]);
+
+	pci_dev_put(isa);
+
+	/*
+	 * Determine system bus clock.
+	 */
+	via_clock = (ide_pci_clk ? ide_pci_clk : 33) * 1000;
+
+	switch (via_clock) {
+	case 33000: via_clock = 33333; break;
+	case 37000: via_clock = 37500; break;
+	case 41000: via_clock = 41666; break;
+	}
+
+	if (via_clock < 20000 || via_clock > 50000) {
+		printk(KERN_WARNING DRV_NAME ": User given PCI clock speed "
+			"impossible (%d), using 33 MHz instead.\n", via_clock);
+		printk(KERN_WARNING DRV_NAME ": Use ide0=ata66 if you want "
+			"to assume 80-wire cable.\n");
+		via_clock = 33333;
+	}
+
 	if (idx == 0)
 		d.host_flags |= IDE_HFLAG_NO_AUTODMA;
 	else
@@ -466,7 +452,29 @@ static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_i
 
 	d.udma_mask = via_config->udma_mask;
 
-	return ide_setup_pci_device(dev, &d);
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev) {
+		printk(KERN_ERR DRV_NAME " %s: out of memory :(\n",
+			pci_name(dev));
+		return -ENOMEM;
+	}
+
+	vdev->via_config = via_config;
+
+	rc = ide_pci_init_one(dev, &d, vdev);
+	if (rc)
+		kfree(vdev);
+
+	return rc;
+}
+
+static void __devexit via_remove(struct pci_dev *dev)
+{
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct via82cxxx_dev *vdev = host->host_priv;
+
+	ide_pci_remove(dev);
+	kfree(vdev);
 }
 
 static const struct pci_device_id via_pci_tbl[] = {
@@ -483,6 +491,7 @@ static struct pci_driver driver = {
 	.name 		= "VIA_IDE",
 	.id_table 	= via_pci_tbl,
 	.probe 		= via_init_one,
+	.remove		= via_remove,
 };
 
 static int __init via_ide_init(void)
@@ -490,7 +499,13 @@ static int __init via_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit via_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(via_ide_init);
+module_exit(via_ide_exit);
 
 MODULE_AUTHOR("Vojtech Pavlik, Michel Aubry, Jeff Garzik, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for VIA IDE");
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index b15cad5..a8e9e8a 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -39,17 +39,18 @@ static int ide_setup_pci_baseregs(struct pci_dev *dev, const char *name)
 	if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
 			 (progif & 5) != 5) {
 		if ((progif & 0xa) != 0xa) {
-			printk(KERN_INFO "%s: device not capable of full "
-				"native PCI mode\n", name);
+			printk(KERN_INFO "%s %s: device not capable of full "
+				"native PCI mode\n", name, pci_name(dev));
 			return -EOPNOTSUPP;
 		}
-		printk("%s: placing both ports into native PCI mode\n", name);
+		printk(KERN_INFO "%s %s: placing both ports into native PCI "
+			"mode\n", name, pci_name(dev));
 		(void) pci_write_config_byte(dev, PCI_CLASS_PROG, progif|5);
 		if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
 		    (progif & 5) != 5) {
-			printk(KERN_ERR "%s: rewrite of PROGIF failed, wanted "
-				"0x%04x, got 0x%04x\n",
-				name, progif|5, progif);
+			printk(KERN_ERR "%s %s: rewrite of PROGIF failed, "
+				"wanted 0x%04x, got 0x%04x\n",
+				name, pci_name(dev), progif | 5, progif);
 			return -EOPNOTSUPP;
 		}
 	}
@@ -57,14 +58,14 @@ static int ide_setup_pci_baseregs(struct pci_dev *dev, const char *name)
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
-static void ide_pci_clear_simplex(unsigned long dma_base, const char *name)
+static int ide_pci_clear_simplex(unsigned long dma_base, const char *name)
 {
 	u8 dma_stat = inb(dma_base + 2);
 
 	outb(dma_stat & 0x60, dma_base + 2);
 	dma_stat = inb(dma_base + 2);
-	if (dma_stat & 0x80)
-		printk(KERN_INFO "%s: simplex device: DMA forced\n", name);
+
+	return (dma_stat & 0x80) ? 1 : 0;
 }
 
 /**
@@ -91,7 +92,8 @@ unsigned long ide_pci_dma_base(ide_hwif_t *hwif, const struct ide_port_info *d)
 		dma_base = pci_resource_start(dev, baridx);
 
 		if (dma_base == 0) {
-			printk(KERN_ERR "%s: DMA base is invalid\n", d->name);
+			printk(KERN_ERR "%s %s: DMA base is invalid\n",
+				d->name, pci_name(dev));
 			return 0;
 		}
 	}
@@ -105,13 +107,16 @@ EXPORT_SYMBOL_GPL(ide_pci_dma_base);
 
 int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 dma_stat;
 
 	if (d->host_flags & (IDE_HFLAG_MMIO | IDE_HFLAG_CS5520))
 		goto out;
 
 	if (d->host_flags & IDE_HFLAG_CLEAR_SIMPLEX) {
-		ide_pci_clear_simplex(hwif->dma_base, d->name);
+		if (ide_pci_clear_simplex(hwif->dma_base, d->name))
+			printk(KERN_INFO "%s %s: simplex device: DMA forced\n",
+				d->name, pci_name(dev));
 		goto out;
 	}
 
@@ -127,7 +132,8 @@ int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
 	 */
 	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
 	if ((dma_stat & 0x80) && hwif->mate && hwif->mate->dma_base) {
-		printk(KERN_INFO "%s: simplex device: DMA disabled\n", d->name);
+		printk(KERN_INFO "%s %s: simplex device: DMA disabled\n",
+			d->name, pci_name(dev));
 		return -1;
 	}
 out:
@@ -149,8 +155,8 @@ int ide_pci_set_master(struct pci_dev *dev, const char *name)
 
 		if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd) ||
 		    (pcicmd & PCI_COMMAND_MASTER) == 0) {
-			printk(KERN_ERR "%s: error updating PCICMD on %s\n",
-					name, pci_name(dev));
+			printk(KERN_ERR "%s %s: error updating PCICMD\n",
+				name, pci_name(dev));
 			return -EIO;
 		}
 	}
@@ -162,9 +168,9 @@ EXPORT_SYMBOL_GPL(ide_pci_set_master);
 
 void ide_setup_pci_noise(struct pci_dev *dev, const struct ide_port_info *d)
 {
-	printk(KERN_INFO "%s: IDE controller (0x%04x:0x%04x rev 0x%02x) at "
-			 " PCI slot %s\n", d->name, dev->vendor, dev->device,
-			 dev->revision, pci_name(dev));
+	printk(KERN_INFO "%s %s: IDE controller (0x%04x:0x%04x rev 0x%02x)\n",
+		d->name, pci_name(dev),
+		dev->vendor, dev->device, dev->revision);
 }
 EXPORT_SYMBOL_GPL(ide_setup_pci_noise);
 
@@ -189,11 +195,12 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 	if (pci_enable_device(dev)) {
 		ret = pci_enable_device_io(dev);
 		if (ret < 0) {
-			printk(KERN_WARNING "%s: (ide_setup_pci_device:) "
-				"Could not enable device.\n", d->name);
+			printk(KERN_WARNING "%s %s: couldn't enable device\n",
+				d->name, pci_name(dev));
 			goto out;
 		}
-		printk(KERN_WARNING "%s: BIOS configuration fixed.\n", d->name);
+		printk(KERN_WARNING "%s %s: BIOS configuration fixed\n",
+			d->name, pci_name(dev));
 	}
 
 	/*
@@ -203,7 +210,8 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 	 */
 	ret = pci_set_dma_mask(dev, DMA_32BIT_MASK);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: can't set dma mask\n", d->name);
+		printk(KERN_ERR "%s %s: can't set DMA mask\n",
+			d->name, pci_name(dev));
 		goto out;
 	}
 
@@ -221,7 +229,8 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 
 	ret = pci_request_selected_regions(dev, bars, d->name);
 	if (ret < 0)
-		printk(KERN_ERR "%s: can't reserve resources\n", d->name);
+		printk(KERN_ERR "%s %s: can't reserve resources\n",
+			d->name, pci_name(dev));
 out:
 	return ret;
 }
@@ -247,15 +256,18 @@ static int ide_pci_configure(struct pci_dev *dev, const struct ide_port_info *d)
 	 */
 	if (ide_setup_pci_baseregs(dev, d->name) ||
 	    pci_write_config_word(dev, PCI_COMMAND, pcicmd | PCI_COMMAND_IO)) {
-		printk(KERN_INFO "%s: device disabled (BIOS)\n", d->name);
+		printk(KERN_INFO "%s %s: device disabled (BIOS)\n",
+			d->name, pci_name(dev));
 		return -ENODEV;
 	}
 	if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd)) {
-		printk(KERN_ERR "%s: error accessing PCI regs\n", d->name);
+		printk(KERN_ERR "%s %s: error accessing PCI regs\n",
+			d->name, pci_name(dev));
 		return -EIO;
 	}
 	if (!(pcicmd & PCI_COMMAND_IO)) {
-		printk(KERN_ERR "%s: unable to enable IDE controller\n", d->name);
+		printk(KERN_ERR "%s %s: unable to enable IDE controller\n",
+			d->name, pci_name(dev));
 		return -ENXIO;
 	}
 	return 0;
@@ -311,8 +323,9 @@ static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
 	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
 		if (ide_pci_check_iomem(dev, d, 2 * port) ||
 		    ide_pci_check_iomem(dev, d, 2 * port + 1)) {
-			printk(KERN_ERR "%s: I/O baseregs (BIOS) are reported "
-					"as MEM for port %d!\n", d->name, port);
+			printk(KERN_ERR "%s %s: I/O baseregs (BIOS) are "
+				"reported as MEM for port %d!\n",
+				d->name, pci_name(dev), port);
 			return -EINVAL;
 		}
 
@@ -325,8 +338,8 @@ static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
 	}
 
 	if (!base || !ctl) {
-		printk(KERN_ERR "%s: bad PCI BARs for port %d, skipping\n",
-				d->name, port);
+		printk(KERN_ERR "%s %s: bad PCI BARs for port %d, skipping\n",
+			d->name, pci_name(dev), port);
 		return -EINVAL;
 	}
 
@@ -393,14 +406,14 @@ int ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
  *	@dev: PCI device
  *	@d: IDE port info
  *	@noisy: verbose flag
- *	@config: returned as 1 if we configured the hardware
  *
  *	Set up the PCI and controller side of the IDE interface. This brings
  *	up the PCI side of the device, checks that the device is enabled
  *	and enables it if need be
  */
 
-static int ide_setup_pci_controller(struct pci_dev *dev, const struct ide_port_info *d, int noisy, int *config)
+static int ide_setup_pci_controller(struct pci_dev *dev,
+				    const struct ide_port_info *d, int noisy)
 {
 	int ret;
 	u16 pcicmd;
@@ -414,15 +427,16 @@ static int ide_setup_pci_controller(struct pci_dev *dev, const struct ide_port_i
 
 	ret = pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: error accessing PCI regs\n", d->name);
+		printk(KERN_ERR "%s %s: error accessing PCI regs\n",
+			d->name, pci_name(dev));
 		goto out;
 	}
 	if (!(pcicmd & PCI_COMMAND_IO)) {	/* is device disabled? */
 		ret = ide_pci_configure(dev, d);
 		if (ret < 0)
 			goto out;
-		*config = 1;
-		printk(KERN_INFO "%s: device enabled (Linux)\n", d->name);
+		printk(KERN_INFO "%s %s: device enabled (Linux)\n",
+			d->name, pci_name(dev));
 	}
 
 out:
@@ -461,7 +475,8 @@ void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d,
 
 		if (e->reg && (pci_read_config_byte(dev, e->reg, &tmp) ||
 		    (tmp & e->mask) != e->val)) {
-			printk(KERN_INFO "%s: IDE port disabled\n", d->name);
+			printk(KERN_INFO "%s %s: IDE port disabled\n",
+				d->name, pci_name(dev));
 			continue;	/* port not enabled */
 		}
 
@@ -487,51 +502,35 @@ static int do_ide_setup_pci_device(struct pci_dev *dev,
 				   const struct ide_port_info *d,
 				   u8 noisy)
 {
-	int tried_config = 0;
 	int pciirq, ret;
 
-	ret = ide_setup_pci_controller(dev, d, noisy, &tried_config);
-	if (ret < 0)
-		goto out;
-
 	/*
 	 * Can we trust the reported IRQ?
 	 */
 	pciirq = dev->irq;
 
+	/*
+	 * This allows offboard ide-pci cards the enable a BIOS,
+	 * verify interrupt settings of split-mirror pci-config
+	 * space, place chipset into init-mode, and/or preserve
+	 * an interrupt if the card is not native ide support.
+	 */
+	ret = d->init_chipset ? d->init_chipset(dev) : 0;
+	if (ret < 0)
+		goto out;
+
 	/* Is it an "IDE storage" device in non-PCI mode? */
 	if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE && (dev->class & 5) != 5) {
 		if (noisy)
-			printk(KERN_INFO "%s: not 100%% native mode: "
-				"will probe irqs later\n", d->name);
-		/*
-		 * This allows offboard ide-pci cards the enable a BIOS,
-		 * verify interrupt settings of split-mirror pci-config
-		 * space, place chipset into init-mode, and/or preserve
-		 * an interrupt if the card is not native ide support.
-		 */
-		ret = d->init_chipset ? d->init_chipset(dev, d->name) : 0;
-		if (ret < 0)
-			goto out;
+			printk(KERN_INFO "%s %s: not 100%% native mode: will "
+				"probe irqs later\n", d->name, pci_name(dev));
 		pciirq = ret;
-	} else if (tried_config) {
-		if (noisy)
-			printk(KERN_INFO "%s: will probe irqs later\n", d->name);
-		pciirq = 0;
-	} else if (!pciirq) {
-		if (noisy)
-			printk(KERN_WARNING "%s: bad irq (%d): will probe later\n",
-				d->name, pciirq);
-		pciirq = 0;
-	} else {
-		if (d->init_chipset) {
-			ret = d->init_chipset(dev, d->name);
-			if (ret < 0)
-				goto out;
-		}
-		if (noisy)
-			printk(KERN_INFO "%s: 100%% native mode on irq %d\n",
-				d->name, pciirq);
+	} else if (!pciirq && noisy) {
+		printk(KERN_WARNING "%s %s: bad irq (%d): will probe later\n",
+			d->name, pci_name(dev), pciirq);
+	} else if (noisy) {
+		printk(KERN_INFO "%s %s: 100%% native mode on irq %d\n",
+			d->name, pci_name(dev), pciirq);
 	}
 
 	ret = pciirq;
@@ -539,32 +538,77 @@ out:
 	return ret;
 }
 
-int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
+int ide_pci_init_one(struct pci_dev *dev, const struct ide_port_info *d,
+		     void *priv)
 {
+	struct ide_host *host;
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 	int ret;
 
-	ret = do_ide_setup_pci_device(dev, d, 1);
+	ret = ide_setup_pci_controller(dev, d, 1);
+	if (ret < 0)
+		goto out;
 
-	if (ret >= 0) {
-		/* FIXME: silent failure can happen */
-		ide_pci_setup_ports(dev, d, ret, &hw[0], &hws[0]);
+	ide_pci_setup_ports(dev, d, 0, &hw[0], &hws[0]);
 
-		ret = ide_host_add(d, hws, NULL);
+	host = ide_host_alloc(d, hws);
+	if (host == NULL) {
+		ret = -ENOMEM;
+		goto out;
 	}
 
+	host->dev[0] = &dev->dev;
+
+	host->host_priv = priv;
+
+	pci_set_drvdata(dev, host);
+
+	ret = do_ide_setup_pci_device(dev, d, 1);
+	if (ret < 0)
+		goto out;
+
+	/* fixup IRQ */
+	hw[1].irq = hw[0].irq = ret;
+
+	ret = ide_host_register(host, d, hws);
+	if (ret)
+		ide_host_free(host);
+out:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(ide_setup_pci_device);
+EXPORT_SYMBOL_GPL(ide_pci_init_one);
 
-int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
-			  const struct ide_port_info *d)
+int ide_pci_init_two(struct pci_dev *dev1, struct pci_dev *dev2,
+		     const struct ide_port_info *d, void *priv)
 {
 	struct pci_dev *pdev[] = { dev1, dev2 };
+	struct ide_host *host;
 	int ret, i;
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 
 	for (i = 0; i < 2; i++) {
+		ret = ide_setup_pci_controller(pdev[i], d, !i);
+		if (ret < 0)
+			goto out;
+
+		ide_pci_setup_ports(pdev[i], d, 0, &hw[i*2], &hws[i*2]);
+	}
+
+	host = ide_host_alloc(d, hws);
+	if (host == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	host->dev[0] = &dev1->dev;
+	host->dev[1] = &dev2->dev;
+
+	host->host_priv = priv;
+
+	pci_set_drvdata(pdev[0], host);
+	pci_set_drvdata(pdev[1], host);
+
+	for (i = 0; i < 2; i++) {
 		ret = do_ide_setup_pci_device(pdev[i], d, !i);
 
 		/*
@@ -574,12 +618,44 @@ int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
 		if (ret < 0)
 			goto out;
 
-		/* FIXME: silent failure can happen */
-		ide_pci_setup_ports(pdev[i], d, ret, &hw[i*2], &hws[i*2]);
+		/* fixup IRQ */
+		hw[i*2 + 1].irq = hw[i*2].irq = ret;
 	}
 
-	ret = ide_host_add(d, hws, NULL);
+	ret = ide_host_register(host, d, hws);
+	if (ret)
+		ide_host_free(host);
 out:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(ide_setup_pci_devices);
+EXPORT_SYMBOL_GPL(ide_pci_init_two);
+
+void ide_pci_remove(struct pci_dev *dev)
+{
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct pci_dev *dev2 = host->dev[1] ? to_pci_dev(host->dev[1]) : NULL;
+	int bars;
+
+	if (host->host_flags & IDE_HFLAG_SINGLE)
+		bars = (1 << 2) - 1;
+	else
+		bars = (1 << 4) - 1;
+
+	if ((host->host_flags & IDE_HFLAG_NO_DMA) == 0) {
+		if (host->host_flags & IDE_HFLAG_CS5520)
+			bars |= (1 << 2);
+		else
+			bars |= (1 << 4);
+	}
+
+	ide_host_remove(host);
+
+	if (dev2)
+		pci_release_selected_regions(dev2, bars);
+	pci_release_selected_regions(dev, bars);
+
+	if (dev2)
+		pci_disable_device(dev2);
+	pci_disable_device(dev);
+}
+EXPORT_SYMBOL_GPL(ide_pci_remove);
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 5385524..b40a673 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -101,8 +101,13 @@ static struct ide_scsi_obj *ide_scsi_get(struct gendisk *disk)
 
 	mutex_lock(&idescsi_ref_mutex);
 	scsi = ide_scsi_g(disk);
-	if (scsi)
+	if (scsi) {
 		scsi_host_get(scsi->host);
+		if (ide_device_get(scsi->drive)) {
+			scsi_host_put(scsi->host);
+			scsi = NULL;
+		}
+	}
 	mutex_unlock(&idescsi_ref_mutex);
 	return scsi;
 }
@@ -110,6 +115,7 @@ static struct ide_scsi_obj *ide_scsi_get(struct gendisk *disk)
 static void ide_scsi_put(struct ide_scsi_obj *scsi)
 {
 	mutex_lock(&idescsi_ref_mutex);
+	ide_device_put(scsi->drive);
 	scsi_host_put(scsi->host);
 	mutex_unlock(&idescsi_ref_mutex);
 }
@@ -201,15 +207,15 @@ static int idescsi_check_condition(ide_drive_t *drive,
 
 	/* stuff a sense request in front of our current request */
 	pc = kzalloc(sizeof(struct ide_atapi_pc), GFP_ATOMIC);
-	rq = kmalloc(sizeof(struct request), GFP_ATOMIC);
+	rq = blk_get_request(drive->queue, READ, GFP_ATOMIC);
 	buf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_ATOMIC);
 	if (!pc || !rq || !buf) {
 		kfree(buf);
-		kfree(rq);
+		if (rq)
+			blk_put_request(rq);
 		kfree(pc);
 		return -ENOMEM;
 	}
-	blk_rq_init(NULL, rq);
 	rq->special = (char *) pc;
 	pc->rq = rq;
 	pc->buf = buf;
@@ -226,6 +232,7 @@ static int idescsi_check_condition(ide_drive_t *drive,
 		ide_scsi_hex_dump(pc->c, 6);
 	}
 	rq->rq_disk = scsi->disk;
+	rq->ref_count++;
 	memcpy(rq->cmd, pc->c, 12);
 	ide_do_drive_cmd(drive, rq);
 	return 0;
@@ -272,7 +279,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 			SCSI_SENSE_BUFFERSIZE);
 		kfree(pc->buf);
 		kfree(pc);
-		kfree(rq);
+		blk_put_request(rq);
 		pc = opc;
 		rq = pc->rq;
 		pc->scsi_cmd->result = (CHECK_CONDITION << 1) |
@@ -303,7 +310,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 	pc->done(pc->scsi_cmd);
 	spin_unlock_irqrestore(host->host_lock, flags);
 	kfree(pc);
-	kfree(rq);
+	blk_put_request(rq);
 	scsi->pc = NULL;
 	return 0;
 }
@@ -577,6 +584,7 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	ide_drive_t *drive = scsi->drive;
 	struct request *rq = NULL;
 	struct ide_atapi_pc *pc = NULL;
+	int write = cmd->sc_data_direction == DMA_TO_DEVICE;
 
 	if (!drive) {
 		scmd_printk (KERN_ERR, cmd, "drive not present\n");
@@ -584,7 +592,7 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	}
 	scsi = drive_to_idescsi(drive);
 	pc = kmalloc(sizeof(struct ide_atapi_pc), GFP_ATOMIC);
-	rq = kmalloc(sizeof(struct request), GFP_ATOMIC);
+	rq = blk_get_request(drive->queue, write, GFP_ATOMIC);
 	if (rq == NULL || pc == NULL) {
 		printk (KERN_ERR "ide-scsi: %s: out of memory\n", drive->name);
 		goto abort;
@@ -614,17 +622,18 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 		}
 	}
 
-	blk_rq_init(NULL, rq);
 	rq->special = (char *) pc;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	spin_unlock_irq(host->host_lock);
+	rq->ref_count++;
 	memcpy(rq->cmd, pc->c, 12);
 	blk_execute_rq_nowait(drive->queue, scsi->disk, rq, 0, NULL);
 	spin_lock_irq(host->host_lock);
 	return 0;
 abort:
 	kfree (pc);
-	kfree (rq);
+	if (rq)
+		blk_put_request(rq);
 	cmd->result = DID_ERROR << 16;
 	done(cmd);
 	return 0;
@@ -672,7 +681,9 @@ static int idescsi_eh_abort (struct scsi_cmnd *cmd)
 
 		if (blk_sense_request(scsi->pc->rq))
 			kfree(scsi->pc->buf);
-		kfree(scsi->pc->rq);
+		/* we need to call blk_put_request twice. */
+		blk_put_request(scsi->pc->rq);
+		blk_put_request(scsi->pc->rq);
 		kfree(scsi->pc);
 		scsi->pc = NULL;
 
@@ -724,7 +735,7 @@ static int idescsi_eh_reset (struct scsi_cmnd *cmd)
 		kfree(scsi->pc->buf);
 	kfree(scsi->pc);
 	scsi->pc = NULL;
-	kfree(req);
+	blk_put_request(req);
 
 	/* now nuke the drive queue */
 	while ((req = elv_next_request(drive->queue))) {
diff --git a/include/asm-alpha/ide.h b/include/asm-alpha/ide.h
deleted file mode 100644
index f44129a..0000000
--- a/include/asm-alpha/ide.h
+++ /dev/null
@@ -1,44 +0,0 @@
-/*
- *  linux/include/asm-alpha/ide.h
- *
- *  Copyright (C) 1994-1996  Linus Torvalds & authors
- */
-
-/*
- *  This file contains the alpha architecture specific IDE code.
- */
-
-#ifndef __ASMalpha_IDE_H
-#define __ASMalpha_IDE_H
-
-#ifdef __KERNEL__
-
-static inline int ide_default_irq(unsigned long base)
-{
-	switch (base) {
-		case 0x1f0: return 14;
-		case 0x170: return 15;
-		case 0x1e8: return 11;
-		case 0x168: return 10;
-		default:
-			return 0;
-	}
-}
-
-static inline unsigned long ide_default_io_base(int index)
-{
-	switch (index) {
-		case 0:	return 0x1f0;
-		case 1:	return 0x170;
-		case 2: return 0x1e8;
-		case 3: return 0x168;
-		default:
-			return 0;
-	}
-}
-
-#include <asm-generic/ide_iops.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* __ASMalpha_IDE_H */
diff --git a/include/asm-arm/ide.h b/include/asm-arm/ide.h
index 88f4d23..a48019f 100644
--- a/include/asm-arm/ide.h
+++ b/include/asm-arm/ide.h
@@ -13,10 +13,6 @@
 
 #ifdef __KERNEL__
 
-#ifndef MAX_HWIFS
-#define MAX_HWIFS	4
-#endif
-
 #define __ide_mm_insw(port,addr,len)	readsw(port,addr,len)
 #define __ide_mm_insl(port,addr,len)	readsl(port,addr,len)
 #define __ide_mm_outsw(port,addr,len)	writesw(port,addr,len)
diff --git a/include/asm-blackfin/ide.h b/include/asm-blackfin/ide.h
deleted file mode 100644
index 5b88de1..0000000
--- a/include/asm-blackfin/ide.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/****************************************************************************/
-
-/*
- *  linux/include/asm-blackfin/ide.h
- *
- *  Copyright (C) 1994-1996  Linus Torvalds & authors
- *  Copyright (C) 2001       Lineo Inc., davidm@snapgear.com
- *  Copyright (C) 2002       Greg Ungerer (gerg@snapgear.com)
- *  Copyright (C) 2002       Yoshinori Sato (ysato@users.sourceforge.jp)
- *  Copyright (C) 2005       Hennerich Michael (hennerich@blackfin.uclinux.org)
- */
-
-/****************************************************************************/
-#ifndef _BLACKFIN_IDE_H
-#define _BLACKFIN_IDE_H
-/****************************************************************************/
-#ifdef __KERNEL__
-/****************************************************************************/
-
-#define MAX_HWIFS	1
-
-#include <asm-generic/ide_iops.h>
-
-/****************************************************************************/
-#endif				/* __KERNEL__ */
-#endif				/* _BLACKFIN_IDE_H */
-/****************************************************************************/
diff --git a/include/asm-cris/arch-v10/ide.h b/include/asm-cris/arch-v10/ide.h
deleted file mode 100644
index 5366e62..0000000
--- a/include/asm-cris/arch-v10/ide.h
+++ /dev/null
@@ -1,91 +0,0 @@
-/*
- *  linux/include/asm-cris/ide.h
- *
- *  Copyright (C) 2000, 2001, 2002  Axis Communications AB
- *
- *  Authors:    Bjorn Wesen
- *
- */
-
-/*
- *  This file contains the ETRAX 100LX specific IDE code.
- */
-
-#ifndef __ASMCRIS_IDE_H
-#define __ASMCRIS_IDE_H
-
-#ifdef __KERNEL__
-
-#include <asm/arch/svinto.h>
-#include <asm/io.h>
-#include <asm-generic/ide_iops.h>
-
-
-/* ETRAX 100 can support 4 IDE busses on the same pins (serialized) */
-
-#define MAX_HWIFS	4
-
-static inline int ide_default_irq(unsigned long base)
-{
-	/* all IDE busses share the same IRQ, number 4.
-	 * this has the side-effect that ide-probe.c will cluster our 4 interfaces
-	 * together in a hwgroup, and will serialize accesses. this is good, because
-	 * we can't access more than one interface at the same time on ETRAX100.
-	 */
-	return 4;
-}
-
-static inline unsigned long ide_default_io_base(int index)
-{
-	/* we have no real I/O base address per interface, since all go through the
-	 * same register. but in a bitfield in that register, we have the i/f number.
-	 * so we can use the io_base to remember that bitfield.
-	 */
-	static const unsigned long io_bases[MAX_HWIFS] = {
-		IO_FIELD(R_ATA_CTRL_DATA, sel, 0),
-		IO_FIELD(R_ATA_CTRL_DATA, sel, 1),
-		IO_FIELD(R_ATA_CTRL_DATA, sel, 2),
-		IO_FIELD(R_ATA_CTRL_DATA, sel, 3)
-	};
-	return io_bases[index];
-}
-
-/* this is called once for each interface, to setup the port addresses. data_port is the result
- * of the ide_default_io_base call above. ctrl_port will be 0, but that is don't care for us.
- */
-
-static inline void ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port, unsigned long ctrl_port, int *irq)
-{
-	int i;
-
-	/* fill in ports for ATA addresses 0 to 7 */
-	for (i = 0; i <= 7; i++) {
-		hw->io_ports_array[i] = data_port |
-			IO_FIELD(R_ATA_CTRL_DATA, addr, i) |
-			IO_STATE(R_ATA_CTRL_DATA, cs0, active);
-	}
-
-	/* the IDE control register is at ATA address 6, with CS1 active instead of CS0 */
-	hw->io_ports.ctl_addr = data_port |
-			IO_FIELD(R_ATA_CTRL_DATA, addr, 6) |
-			IO_STATE(R_ATA_CTRL_DATA, cs1, active);
-
-	/* whats this for ? */
-	hw->io_ports.irq_addr = 0;
-}
-
-static inline void ide_init_default_hwifs(void)
-{
-	hw_regs_t hw;
-	int index;
-
-	for(index = 0; index < MAX_HWIFS; index++) {
-		ide_init_hwif_ports(&hw, ide_default_io_base(index), 0, NULL);
-		hw.irq = ide_default_irq(ide_default_io_base(index));
-		ide_register_hw(&hw, NULL);
-	}
-}
-
-#endif /* __KERNEL__ */
-
-#endif /* __ASMCRIS_IDE_H */
diff --git a/include/asm-cris/arch-v32/ide.h b/include/asm-cris/arch-v32/ide.h
deleted file mode 100644
index fb9c362..0000000
--- a/include/asm-cris/arch-v32/ide.h
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- *  linux/include/asm-cris/ide.h
- *
- *  Copyright (C) 2000-2004  Axis Communications AB
- *
- *  Authors:    Bjorn Wesen, Mikael Starvik
- *
- */
-
-/*
- *  This file contains the ETRAX FS specific IDE code.
- */
-
-#ifndef __ASMCRIS_IDE_H
-#define __ASMCRIS_IDE_H
-
-#ifdef __KERNEL__
-
-#include <asm/arch/hwregs/intr_vect.h>
-#include <asm/arch/hwregs/ata_defs.h>
-#include <asm/io.h>
-#include <asm-generic/ide_iops.h>
-
-
-/* ETRAX FS can support 4 IDE busses on the same pins (serialized) */
-
-#define MAX_HWIFS	4
-
-static inline int ide_default_irq(unsigned long base)
-{
-	/* all IDE busses share the same IRQ,
-	 * this has the side-effect that ide-probe.c will cluster our 4 interfaces
-	 * together in a hwgroup, and will serialize accesses. this is good, because
-	 * we can't access more than one interface at the same time on ETRAX100.
-	 */
-	return ATA_INTR_VECT;
-}
-
-static inline unsigned long ide_default_io_base(int index)
-{
-	reg_ata_rw_ctrl2 ctrl2 = {.sel = index};
-	/* we have no real I/O base address per interface, since all go through the
-	 * same register. but in a bitfield in that register, we have the i/f number.
-	 * so we can use the io_base to remember that bitfield.
-	 */
-        ctrl2.sel = index;
-
-	return REG_TYPE_CONV(unsigned long, reg_ata_rw_ctrl2, ctrl2);
-}
-
-#define IDE_ARCH_ACK_INTR
-#define ide_ack_intr(hwif)	((hwif)->ack_intr(hwif))
-
-#endif /* __KERNEL__ */
-
-#endif /* __ASMCRIS_IDE_H */
diff --git a/include/asm-cris/ide.h b/include/asm-cris/ide.h
deleted file mode 100644
index a894f66..0000000
--- a/include/asm-cris/ide.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm/arch/ide.h>
diff --git a/include/asm-frv/ide.h b/include/asm-frv/ide.h
index 8c9a540..7ebcc56 100644
--- a/include/asm-frv/ide.h
+++ b/include/asm-frv/ide.h
@@ -18,10 +18,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
-#ifndef MAX_HWIFS
-#define MAX_HWIFS 8
-#endif
-
 /****************************************************************************/
 /*
  * some bits needed for parts of the IDE subsystem to compile
diff --git a/include/asm-h8300/ide.h b/include/asm-h8300/ide.h
deleted file mode 100644
index f8535ce..0000000
--- a/include/asm-h8300/ide.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/****************************************************************************/
-
-/*
- *  linux/include/asm-h8300/ide.h
- *
- *  Copyright (C) 1994-1996  Linus Torvalds & authors
- *  Copyright (C) 2001       Lineo Inc., davidm@snapgear.com
- *  Copyright (C) 2002       Greg Ungerer (gerg@snapgear.com)
- *  Copyright (C) 2002       Yoshinori Sato (ysato@users.sourceforge.jp)
- */
-
-/****************************************************************************/
-#ifndef _H8300_IDE_H
-#define _H8300_IDE_H
-/****************************************************************************/
-#ifdef __KERNEL__
-/****************************************************************************/
-
-#define MAX_HWIFS	1
-
-#include <asm-generic/ide_iops.h>
-
-/****************************************************************************/
-#endif /* __KERNEL__ */
-#endif /* _H8300_IDE_H */
-/****************************************************************************/
diff --git a/include/asm-ia64/ide.h b/include/asm-ia64/ide.h
deleted file mode 100644
index 8fa3f8c..0000000
--- a/include/asm-ia64/ide.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
- *  linux/include/asm-ia64/ide.h
- *
- *  Copyright (C) 1994-1996  Linus Torvalds & authors
- */
-
-/*
- *  This file contains the ia64 architecture specific IDE code.
- */
-
-#ifndef __ASM_IA64_IDE_H
-#define __ASM_IA64_IDE_H
-
-#ifdef __KERNEL__
-
-
-#include <linux/irq.h>
-
-static inline int ide_default_irq(unsigned long base)
-{
-	switch (base) {
-	      case 0x1f0: return isa_irq_to_vector(14);
-	      case 0x170: return isa_irq_to_vector(15);
-	      case 0x1e8: return isa_irq_to_vector(11);
-	      case 0x168: return isa_irq_to_vector(10);
-	      case 0x1e0: return isa_irq_to_vector(8);
-	      case 0x160: return isa_irq_to_vector(12);
-	      default:
-		return 0;
-	}
-}
-
-static inline unsigned long ide_default_io_base(int index)
-{
-	switch (index) {
-	      case 0: return 0x1f0;
-	      case 1: return 0x170;
-	      case 2: return 0x1e8;
-	      case 3: return 0x168;
-	      case 4: return 0x1e0;
-	      case 5: return 0x160;
-	      default:
-		return 0;
-	}
-}
-
-#include <asm-generic/ide_iops.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* __ASM_IA64_IDE_H */
diff --git a/include/asm-m32r/ide.h b/include/asm-m32r/ide.h
deleted file mode 100644
index 1e7f647..0000000
--- a/include/asm-m32r/ide.h
+++ /dev/null
@@ -1,70 +0,0 @@
-#ifndef _ASM_M32R_IDE_H
-#define _ASM_M32R_IDE_H
-
-/*
- *  linux/include/asm-m32r/ide.h
- *
- *  Copyright (C) 1994-1996  Linus Torvalds & authors
- */
-
-/*
- *  This file contains the i386 architecture specific IDE code.
- */
-
-#ifdef __KERNEL__
-
-#include <asm/m32r.h>
-
-#ifndef MAX_HWIFS
-# ifdef CONFIG_BLK_DEV_IDEPCI
-#define MAX_HWIFS	10
-# else
-#define MAX_HWIFS	2
-# endif
-#endif
-
-static __inline__ int ide_default_irq(unsigned long base)
-{
-	switch (base) {
-#if defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_MAPPI2) \
-	|| defined(CONFIG_PLAT_OPSPUT)
-		case 0x1f0: return PLD_IRQ_CFIREQ;
-		default:
-			return 0;
-#elif defined(CONFIG_PLAT_MAPPI3)
-		case 0x1f0: return PLD_IRQ_CFIREQ;
-		case 0x170: return PLD_IRQ_IDEIREQ;
-		default:
-			return 0;
-#else
-		case 0x1f0: return 14;
-		case 0x170: return 15;
-		case 0x1e8: return 11;
-		case 0x168: return 10;
-		case 0x1e0: return 8;
-		case 0x160: return 12;
-		default:
-			return 0;
-#endif
-	}
-}
-
-static __inline__ unsigned long ide_default_io_base(int index)
-{
-	switch (index) {
-		case 0:	return 0x1f0;
-		case 1:	return 0x170;
-		case 2: return 0x1e8;
-		case 3: return 0x168;
-		case 4: return 0x1e0;
-		case 5: return 0x160;
-		default:
-			return 0;
-	}
-}
-
-#include <asm-generic/ide_iops.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* _ASM_M32R_IDE_H */
diff --git a/include/asm-m68k/ide.h b/include/asm-m68k/ide.h
index 909c6df..1daf6cb 100644
--- a/include/asm-m68k/ide.h
+++ b/include/asm-m68k/ide.h
@@ -45,10 +45,6 @@
 #include <asm/macints.h>
 #endif
 
-#ifndef MAX_HWIFS
-#define MAX_HWIFS	4	/* same as the other archs */
-#endif
-
 /*
  * Get rid of defs from io.h - ide has its private and conflicting versions
  * Since so far no single m68k platform uses ISA/PCI I/O space for IDE, we
diff --git a/include/asm-mips/mach-generic/ide.h b/include/asm-mips/mach-generic/ide.h
index 0f6c251..73008f7 100644
--- a/include/asm-mips/mach-generic/ide.h
+++ b/include/asm-mips/mach-generic/ide.h
@@ -19,14 +19,6 @@
 #include <linux/stddef.h>
 #include <asm/processor.h>
 
-#ifndef MAX_HWIFS
-# ifdef CONFIG_BLK_DEV_IDEPCI
-#define MAX_HWIFS	10
-# else
-#define MAX_HWIFS	6
-# endif
-#endif
-
 static __inline__ int ide_probe_legacy(void)
 {
 #ifdef CONFIG_PCI
@@ -56,46 +48,6 @@ found:
 #endif
 }
 
-static __inline__ int ide_default_irq(unsigned long base)
-{
-	switch (base) {
-		case 0x1f0: return 14;
-		case 0x170: return 15;
-		case 0x1e8: return 11;
-		case 0x168: return 10;
-		case 0x1e0: return 8;
-		case 0x160: return 12;
-		default:
-			return 0;
-	}
-}
-
-static __inline__ unsigned long ide_default_io_base(int index)
-{
-	if (!ide_probe_legacy())
-		return 0;
-	/*
-	 *      If PCI is present then it is not safe to poke around
-	 *      the other legacy IDE ports. Only 0x1f0 and 0x170 are
-	 *      defined compatibility mode ports for PCI. A user can
-	 *      override this using ide= but we must default safe.
-	 */
-	if (no_pci_devices()) {
-		switch (index) {
-		case 2: return 0x1e8;
-		case 3: return 0x168;
-		case 4: return 0x1e0;
-		case 5: return 0x160;
-		}
-	}
-	switch (index) {
-	case 0: return 0x1f0;
-	case 1: return 0x170;
-	default:
-		return 0;
-	}
-}
-
 /* MIPS port and memory-mapped I/O string operations.  */
 static inline void __ide_flush_prologue(void)
 {
diff --git a/include/asm-mn10300/ide.h b/include/asm-mn10300/ide.h
index dc23512..6adcdd9 100644
--- a/include/asm-mn10300/ide.h
+++ b/include/asm-mn10300/ide.h
@@ -23,10 +23,6 @@
 #undef SUPPORT_VLB_SYNC
 #define SUPPORT_VLB_SYNC 0
 
-#ifndef MAX_HWIFS
-#define MAX_HWIFS 8
-#endif
-
 /*
  * some bits needed for parts of the IDE subsystem to compile
  */
diff --git a/include/asm-parisc/ide.h b/include/asm-parisc/ide.h
index db0c944..c246ef7 100644
--- a/include/asm-parisc/ide.h
+++ b/include/asm-parisc/ide.h
@@ -13,10 +13,6 @@
 
 #ifdef __KERNEL__
 
-#ifndef MAX_HWIFS
-#define MAX_HWIFS	2
-#endif
-
 #define ide_request_irq(irq,hand,flg,dev,id)	request_irq((irq),(hand),(flg),(dev),(id))
 #define ide_free_irq(irq,dev_id)		free_irq((irq), (dev_id))
 #define ide_request_region(from,extent,name)	request_region((from), (extent), (name))
diff --git a/include/asm-powerpc/ide.h b/include/asm-powerpc/ide.h
index 3d90bf7..1aaf27b 100644
--- a/include/asm-powerpc/ide.h
+++ b/include/asm-powerpc/ide.h
@@ -14,14 +14,6 @@
 #endif
 #include <asm/io.h>
 
-#ifndef MAX_HWIFS
-#ifdef __powerpc64__
-#define MAX_HWIFS	10
-#else
-#define MAX_HWIFS	8
-#endif
-#endif
-
 #define __ide_mm_insw(p, a, c)	readsw((void __iomem *)(p), (a), (c))
 #define __ide_mm_insl(p, a, c)	readsl((void __iomem *)(p), (a), (c))
 #define __ide_mm_outsw(p, a, c)	writesw((void __iomem *)(p), (a), (c))
@@ -40,16 +32,6 @@ static __inline__ int ide_default_irq(unsigned long base)
 	case 0x170:	return 15;
 	}
 #endif
-#ifdef CONFIG_PPC_PREP
-	switch (base) {
-	case 0x1f0:	return 13;
-	case 0x170:	return 13;
-	case 0x1e8:	return 11;
-	case 0x168:	return 10;
-	case 0xfff0:	return 14;	/* MCP(N)750 ide0 */
-	case 0xffe0:	return 15;	/* MCP(N)750 ide1 */
-	}
-#endif
 	return 0;
 }
 
@@ -62,14 +44,6 @@ static __inline__ unsigned long ide_default_io_base(int index)
 	case 1:		return 0x170;
 	}
 #endif
-#ifdef CONFIG_PPC_PREP
-	switch (index) {
-	case 0:		return 0x1f0;
-	case 1:		return 0x170;
-	case 2:		return 0x1e8;
-	case 3:		return 0x168;
-	}
-#endif
 	return 0;
 }
 
diff --git a/include/asm-sh/ide.h b/include/asm-sh/ide.h
deleted file mode 100644
index 58e0bdd..0000000
--- a/include/asm-sh/ide.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- *  linux/include/asm-sh/ide.h
- *
- *  Copyright (C) 1994-1996  Linus Torvalds & authors
- */
-
-/*
- *  This file contains the i386 architecture specific IDE code.
- *  In future, SuperH code.
- */
-
-#ifndef __ASM_SH_IDE_H
-#define __ASM_SH_IDE_H
-
-#ifdef __KERNEL__
-
-#include <asm-generic/ide_iops.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* __ASM_SH_IDE_H */
diff --git a/include/asm-sparc/ide.h b/include/asm-sparc/ide.h
index 879fcec..b7af3d6 100644
--- a/include/asm-sparc/ide.h
+++ b/include/asm-sparc/ide.h
@@ -21,9 +21,6 @@
 #include <asm/psr.h>
 #endif
 
-#undef  MAX_HWIFS
-#define MAX_HWIFS	2
-
 #define __ide_insl(data_reg, buffer, wcount) \
 	__ide_insw(data_reg, buffer, (wcount)<<1)
 #define __ide_outsl(data_reg, buffer, wcount) \
diff --git a/include/asm-x86/ide.h b/include/asm-x86/ide.h
deleted file mode 100644
index cf9c98e..0000000
--- a/include/asm-x86/ide.h
+++ /dev/null
@@ -1,65 +0,0 @@
-/*
- *  Copyright (C) 1994-1996  Linus Torvalds & authors
- */
-
-/*
- *  This file contains the i386 architecture specific IDE code.
- */
-
-#ifndef __ASMi386_IDE_H
-#define __ASMi386_IDE_H
-
-#ifdef __KERNEL__
-
-
-#ifndef MAX_HWIFS
-# ifdef CONFIG_BLK_DEV_IDEPCI
-#define MAX_HWIFS	10
-# else
-#define MAX_HWIFS	6
-# endif
-#endif
-
-static __inline__ int ide_default_irq(unsigned long base)
-{
-	switch (base) {
-		case 0x1f0: return 14;
-		case 0x170: return 15;
-		case 0x1e8: return 11;
-		case 0x168: return 10;
-		case 0x1e0: return 8;
-		case 0x160: return 12;
-		default:
-			return 0;
-	}
-}
-
-static __inline__ unsigned long ide_default_io_base(int index)
-{
-	/*
-	 *	If PCI is present then it is not safe to poke around
-	 *	the other legacy IDE ports. Only 0x1f0 and 0x170 are
-	 *	defined compatibility mode ports for PCI. A user can 
-	 *	override this using ide= but we must default safe.
-	 */
-	if (no_pci_devices()) {
-		switch(index) {
-			case 2: return 0x1e8;
-			case 3: return 0x168;
-			case 4: return 0x1e0;
-			case 5: return 0x160;
-		}
-	}
-	switch (index) {
-		case 0:	return 0x1f0;
-		case 1:	return 0x170;
-		default:
-			return 0;
-	}
-}
-
-#include <asm-generic/ide_iops.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* __ASMi386_IDE_H */
diff --git a/include/asm-xtensa/ide.h b/include/asm-xtensa/ide.h
deleted file mode 100644
index 6b91274..0000000
--- a/include/asm-xtensa/ide.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- * include/asm-xtensa/ide.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 1994 - 1996  Linus Torvalds & authors
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_IDE_H
-#define _XTENSA_IDE_H
-
-#ifdef __KERNEL__
-
-
-#ifndef MAX_HWIFS
-# define MAX_HWIFS	1
-#endif
-
-static __inline__ int ide_default_irq(unsigned long base)
-{
-	/* Unsupported! */
-  	return 0;
-}
-
-static __inline__ unsigned long ide_default_io_base(int index)
-{
-	/* Unsupported! */
-  	return 0;
-}
-
-#endif	/* __KERNEL__ */
-#endif	/* _XTENSA_IDE_H */
diff --git a/include/linux/ide.h b/include/linux/ide.h
index d67ccca..b846bc4 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -211,7 +211,21 @@ static inline int __ide_default_irq(unsigned long base)
 	return 0;
 }
 
+#if defined(CONFIG_ARM) || defined(CONFIG_FRV) || defined(CONFIG_M68K) || \
+    defined(CONFIG_MIPS) || defined(CONFIG_MN10300) || defined(CONFIG_PARISC) \
+    || defined(CONFIG_PPC) || defined(CONFIG_SPARC) || defined(CONFIG_SPARC64)
 #include <asm/ide.h>
+#else
+#include <asm-generic/ide_iops.h>
+#endif
+
+#ifndef MAX_HWIFS
+#if defined(CONFIG_BLACKFIN) || defined(CONFIG_H8300) || defined(CONFIG_XTENSA)
+# define MAX_HWIFS	1
+#else
+# define MAX_HWIFS	10
+#endif
+#endif
 
 #if !defined(MAX_HWIFS) || defined(CONFIG_EMBEDDED)
 #undef MAX_HWIFS
@@ -532,12 +546,16 @@ struct ide_dma_ops {
 	void	(*dma_timeout)(struct ide_drive_s *);
 };
 
+struct ide_host;
+
 typedef struct hwif_s {
 	struct hwif_s *next;		/* for linked-list in ide_hwgroup_t */
 	struct hwif_s *mate;		/* other hwif from same PCI chip */
 	struct hwgroup_s *hwgroup;	/* actually (ide_hwgroup_t *) */
 	struct proc_dir_entry *proc;	/* /proc/ide/ directory entry */
 
+	struct ide_host *host;
+
 	char name[6];			/* name of interface, eg. "ide0" */
 
 	struct ide_io_ports	io_ports;
@@ -626,6 +644,9 @@ typedef struct hwif_s {
 struct ide_host {
 	ide_hwif_t	*ports[MAX_HWIFS];
 	unsigned int	n_ports;
+	struct device	*dev[2];
+	unsigned long	host_flags;
+	void		*host_priv;
 };
 
 /*
@@ -874,6 +895,9 @@ struct ide_driver_s {
 
 #define to_ide_driver(drv) container_of(drv, ide_driver_t, gen_driver)
 
+int ide_device_get(ide_drive_t *);
+void ide_device_put(ide_drive_t *);
+
 int generic_ide_ioctl(ide_drive_t *, struct file *, struct block_device *, unsigned, unsigned long);
 
 extern int ide_vlb_clk;
@@ -1182,7 +1206,7 @@ enum {
 
 struct ide_port_info {
 	char			*name;
-	unsigned int		(*init_chipset)(struct pci_dev *, const char *);
+	unsigned int		(*init_chipset)(struct pci_dev *);
 	void			(*init_iops)(ide_hwif_t *);
 	void                    (*init_hwif)(ide_hwif_t *);
 	int			(*init_dma)(ide_hwif_t *,
@@ -1201,8 +1225,10 @@ struct ide_port_info {
 	u8			udma_mask;
 };
 
-int ide_setup_pci_device(struct pci_dev *, const struct ide_port_info *);
-int ide_setup_pci_devices(struct pci_dev *, struct pci_dev *, const struct ide_port_info *);
+int ide_pci_init_one(struct pci_dev *, const struct ide_port_info *, void *);
+int ide_pci_init_two(struct pci_dev *, struct pci_dev *,
+		     const struct ide_port_info *, void *);
+void ide_pci_remove(struct pci_dev *);
 
 void ide_map_sg(ide_drive_t *, struct request *);
 void ide_init_sg_cmd(ide_drive_t *, struct request *);
