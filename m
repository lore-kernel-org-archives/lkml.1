Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbYDZQJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbYDZQJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYDZQJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:09:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:6781 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbYDZQIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:08:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=HfU9B7Bt31idgTBM8W70giA1zIc5Y5a1qLfQBD7kXOLGPms5ivLjPEKoE68kgdHM86glqMmy+5+WYp09u7Koydx3BEgPygxx2ikWPwk8Hl7QlCrCo84vfMVq3+9Lxc4p8g4telGydAxSmsdpAHS73OeU+qD8hg18BvtmKczgXKo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates part 2
Date: Sat, 26 Apr 2008 18:12:30 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro Al <viro@zeniv.linux.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804261812.31197.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Contains:

- critical+obvious execve() fix from Al (not an IDE fix but included here
  to have IDE changes fully bisectable in the mainline)

- fix the infamous ide_4drives allmodconfig error (Frederik Deweerdt)

- fix checking of PCI BARs 0-3 for standard IDE PCI controllers
  (Sergei Shtylyov)

- rework of I/O and MEM resource handling (me)

- preparations for removal of the static array of IDE interfaces (me)

- a lot of coding style fixes (Paolo Ciarrocchi)

- removal of the internal 64k buffer from ide-cd (Borislav Petkov)

- and more (thanks to all people contributing)


PS1 There are still 3-4 IDE updates to go.

PS2 I'm still catching up with the patches/mail from the last week so if
    you've sent me something recently please give me few more days for reply
    before re-sending.


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig               |    2 +-
 drivers/ide/arm/bast-ide.c        |   12 +-
 drivers/ide/arm/icside.c          |    2 +-
 drivers/ide/arm/ide_arm.c         |    2 +-
 drivers/ide/arm/palm_bk3710.c     |   26 ++--
 drivers/ide/arm/rapide.c          |    2 +-
 drivers/ide/cris/ide-cris.c       |    2 +-
 drivers/ide/h8300/ide-h8300.c     |    3 +-
 drivers/ide/ide-cd.c              |  412 ++++++++++++++-----------------------
 drivers/ide/ide-cd.h              |    4 -
 drivers/ide/ide-disk.c            |  159 ++++++++-------
 drivers/ide/ide-dma.c             |   13 +-
 drivers/ide/ide-floppy.c          |   16 +-
 drivers/ide/ide-generic.c         |   16 ++-
 drivers/ide/ide-io.c              |    4 -
 drivers/ide/ide-lib.c             |   22 +-
 drivers/ide/ide-pnp.c             |   12 +-
 drivers/ide/ide-probe.c           |   48 +++++
 drivers/ide/ide-proc.c            |  155 +++++++-------
 drivers/ide/ide.c                 |   69 ++-----
 drivers/ide/legacy/ali14xx.c      |   30 ++-
 drivers/ide/legacy/buddha.c       |    2 +-
 drivers/ide/legacy/dtc2278.c      |   22 +-
 drivers/ide/legacy/falconide.c    |    9 +-
 drivers/ide/legacy/gayle.c        |    2 +-
 drivers/ide/legacy/hd.c           |   78 ++++----
 drivers/ide/legacy/ht6560b.c      |   34 ++--
 drivers/ide/legacy/ide-4drives.c  |   36 ++--
 drivers/ide/legacy/ide-cs.c       |    2 +-
 drivers/ide/legacy/ide_platform.c |    7 +-
 drivers/ide/legacy/macide.c       |    2 +-
 drivers/ide/legacy/q40ide.c       |    2 +-
 drivers/ide/legacy/qd65xx.c       |  165 +++++++--------
 drivers/ide/legacy/qd65xx.h       |    1 -
 drivers/ide/legacy/umc8672.c      |   81 ++++----
 drivers/ide/mips/au1xxx-ide.c     |    8 +-
 drivers/ide/mips/swarm.c          |    9 +-
 drivers/ide/pci/aec62xx.c         |    3 +-
 drivers/ide/pci/alim15x3.c        |    1 -
 drivers/ide/pci/amd74xx.c         |    4 +-
 drivers/ide/pci/atiixp.c          |    5 +-
 drivers/ide/pci/cmd640.c          |  188 +++++++++---------
 drivers/ide/pci/cmd64x.c          |    9 +-
 drivers/ide/pci/cs5520.c          |    3 +-
 drivers/ide/pci/cs5530.c          |    3 +-
 drivers/ide/pci/cs5535.c          |    2 +-
 drivers/ide/pci/cy82c693.c        |   77 ++++----
 drivers/ide/pci/delkin_cb.c       |    6 +-
 drivers/ide/pci/generic.c         |   10 +-
 drivers/ide/pci/hpt34x.c          |    2 +-
 drivers/ide/pci/hpt366.c          |    2 +-
 drivers/ide/pci/it8213.c          |   12 +-
 drivers/ide/pci/it821x.c          |   25 ++-
 drivers/ide/pci/jmicron.c         |    4 +-
 drivers/ide/pci/ns87415.c         |    3 +-
 drivers/ide/pci/opti621.c         |   61 +++---
 drivers/ide/pci/piix.c            |    4 +-
 drivers/ide/pci/rz1000.c          |    2 +-
 drivers/ide/pci/sc1200.c          |    3 +-
 drivers/ide/pci/scc_pata.c        |   17 +-
 drivers/ide/pci/serverworks.c     |    5 +-
 drivers/ide/pci/sgiioc4.c         |   12 +-
 drivers/ide/pci/siimage.c         |    1 -
 drivers/ide/pci/sis5513.c         |  225 ++++++++++----------
 drivers/ide/pci/sl82c105.c        |    3 +-
 drivers/ide/pci/slc90e66.c        |    8 +-
 drivers/ide/pci/tc86c001.c        |   28 ++--
 drivers/ide/pci/triflex.c         |    1 -
 drivers/ide/pci/trm290.c          |    1 -
 drivers/ide/pci/via82cxxx.c       |    4 +-
 drivers/ide/ppc/mpc8xx.c          |   58 ++++--
 drivers/ide/ppc/pmac.c            |   90 +++++----
 drivers/ide/setup-pci.c           |  129 +++---------
 include/linux/Kbuild              |    1 -
 include/linux/hdsmart.h           |  126 -----------
 include/linux/ide.h               |   23 ++-
 kernel/fork.c                     |    2 +-
 77 files changed, 1195 insertions(+), 1439 deletions(-)
 delete mode 100644 include/linux/hdsmart.h


Adrian Bunk (1):
      remove include/linux/hdsmart.h

Al Viro (1):
      fix execve()

Bartlomiej Zolnierkiewicz (35):
      ide: cleanup ide_match_hwif()
      ide: cleanup ide_find_port()
      swarm: use ide_find_port()
      ide-pmac: dynamically allocate struct pmac_ide_hwif instances (take 2)
      ide-pmac: use ide_find_port()
      sgiioc4: use ide_find_port()
      scc_pata: use ide_find_port()
      au1xxx-ide: use ide_find_port()
      cmd640: remove cmd_drives[]
      cmd640: use ide_find_port()
      scc_pata: store 'hwif' pointer in struct scc_ports
      umc8672: don't use ide_hwifs[] in umc_set_pio_mode()
      ht6560b: use driver name for resource allocation
      qd65xx: return error value in qd_probe()
      ide: IDE_HFLAG_BOOTABLE -> IDE_HFLAG_NON_BOOTABLE
      ide: remove PIO "downgrade" quirk
      ide: merge ide_match_hwif() and ide_find_port()
      ide: use ide_find_port() in legacy VLB host drivers (take 2)
      ide-generic: use ide_find_port() (take 3)
      ide: unexport ide_hwifs[]
      ide-disk: add proc_idedisk_read_smart() helper
      ide-disk: fix issues found by checkpatch.pl
      ide_platform: fix resources handling
      delkin_cb: fix resources handling
      bast-ide: fix resources reservation
      ide-mpc8xx: make m8xx_ide_init_ports() return an error value
      ide-mpc8xx: fix resources reservation
      falconide: fix resources reservation (take 2)
      ide: remove IDE_HFLAG_CY82C693 host flag
      ide: remove hwif->straight8 flag
      qd65xx: always use ->selectproc method
      qd65xx: use IDE_HFLAG_SINGLE host flag
      it821x: fix kzalloc() failure handling
      sis5513: fail early for unsupported chipsets
      ide: sanitize handling of IDE_HFLAG_NO_SET_MODE host flag

Borislav Petkov (2):
      ide-cd: remove the internal 64k buffer
      ide-cd: put proc-related functions together under single ifdef

Frederik Deweerdt (1):
      ide/Kconfig: BLK_DEV_4DRIVES should be a tristate

Julia Lawall (1):
      ide: use DIV_ROUND_UP

Paolo Ciarrocchi (19):
      IDE: Coding Style fixes to drivers/ide/setup-pci.c
      IDE: Coding Style fixes to drivers/ide/pci/tc86c001.c
      IDE: Coding Style fixes to drivers/ide/pci/slc90e66.c
      IDE: Coding Style fixes to drivers/ide/pci/sis5513.c
      IDE: Coding Style fixes to drivers/ide/pci/jmicron.c
      IDE: Coding Style fixes to drivers/ide/pci/generic.c
      IDE: Coding Style fixes to drivers/ide/legacy/umc8672.c
      IDE: Coding Style fixes to drivers/ide/legacy/ide-4drives.c
      IDE: Coding Style fixes to drivers/ide/ide-proc.c
      IDE: Coding Style fixes to drivers/ide/ide-pnp.c
      IDE: Coding Style fixes to drivers/ide/pci/opti621.c
      IDE: Coding Style fixes to drivers/ide/pci/cmd640.c
      IDE: Coding Style fixes to drivers/ide/legacy/hd.c
      IDE: Coding Style fixes to drivers/ide/legacy/ali14xx.c
      IDE: Coding Style fixes to drivers/ide/ide-floppy.c
      IDE: Coding Style fixes to drivers/ide/pci/it8213.c
      IDE: Coding Style fixes to drivers/ide/pci/cy82c693.c
      IDE: Coding Style fixes to drivers/ide/ide-cd.c
      ide-cd: Replace __FUNCTION__ with __func__

Sergei Shtylyov (1):
      ide: make ide_pci_check_iomem() actually work


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 8753203..3f9e100 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -1031,7 +1031,7 @@ comment "Other IDE chipsets support"
 comment "Note: most of these also require special kernel boot parameters"
 
 config BLK_DEV_4DRIVES
-	bool "Generic 4 drives/port support"
+	tristate "Generic 4 drives/port support"
 	help
 	  Certain older chipsets, including the Tekram 690CD, use a single set
 	  of I/O ports at 0x1f0 to control up to four drives, instead of the
diff --git a/drivers/ide/arm/bast-ide.c b/drivers/ide/arm/bast-ide.c
index ec46c44..a80b957 100644
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -21,6 +21,8 @@
 #include <asm/arch/bast-map.h>
 #include <asm/arch/bast-irq.h>
 
+#define DRV_NAME "bast-ide"
+
 static int __init bastide_register(unsigned int base, unsigned int aux, int irq)
 {
 	ide_hwif_t *hwif;
@@ -41,7 +43,7 @@ static int __init bastide_register(unsigned int base, unsigned int aux, int irq)
 	hw.io_ports[IDE_CONTROL_OFFSET] = aux + (6 * 0x20);
 	hw.irq = irq;
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif == NULL)
 		goto out;
 
@@ -53,6 +55,7 @@ static int __init bastide_register(unsigned int base, unsigned int aux, int irq)
 		ide_init_port_data(hwif, i);
 
 	ide_init_port_hw(hwif, &hw);
+	hwif->mmio = 1;
 	hwif->quirkproc = NULL;
 
 	idx[0] = i;
@@ -64,6 +67,8 @@ out:
 
 static int __init bastide_init(void)
 {
+	unsigned long base = BAST_VA_IDEPRI + BAST_IDE_CS;
+
 	/* we can treat the VR1000 and the BAST the same */
 
 	if (!(machine_is_bast() || machine_is_vr1000()))
@@ -71,6 +76,11 @@ static int __init bastide_init(void)
 
 	printk("BAST: IDE driver, (c) 2003-2004 Simtec Electronics\n");
 
+	if (!request_mem_region(base, 0x400000, DRV_NAME)) {
+		printk(KERN_ERR "%s: resources busy\n", DRV_NAME);
+		return -EBUSY;
+	}
+
 	bastide_register(BAST_VA_IDEPRI, BAST_VA_IDEPRIAUX, IRQ_IDE0);
 	bastide_register(BAST_VA_IDESEC, BAST_VA_IDESECAUX, IRQ_IDE1);
 
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index e816b0f..fd12bbe 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -400,7 +400,7 @@ icside_setup(void __iomem *base, struct cardinfo *info, struct expansion_card *e
 	unsigned long port = (unsigned long)base + info->dataoffset;
 	ide_hwif_t *hwif;
 
-	hwif = ide_find_port(port);
+	hwif = ide_find_port();
 	if (hwif) {
 		int i;
 
diff --git a/drivers/ide/arm/ide_arm.c b/drivers/ide/arm/ide_arm.c
index be9ff73..82643df 100644
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -34,7 +34,7 @@ static int __init ide_arm_init(void)
 	ide_std_init_ports(&hw, IDE_ARM_IO, IDE_ARM_IO + 0x206);
 	hw.irq = IDE_ARM_IRQ;
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif) {
 		ide_init_port_hw(hwif, &hw);
 		idx[0] = hwif->index;
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index 420fcb7..666df77 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -96,11 +96,11 @@ static void palm_bk3710_setudmamode(void __iomem *base, unsigned int dev,
 	u16 val16;
 
 	/* DMA Data Setup */
-	t0 = (palm_bk3710_udmatimings[mode].cycletime + ide_palm_clk - 1)
-			/ ide_palm_clk - 1;
-	tenv = (20 + ide_palm_clk - 1) / ide_palm_clk - 1;
-	trp = (palm_bk3710_udmatimings[mode].rptime + ide_palm_clk - 1)
-			/ ide_palm_clk - 1;
+	t0 = DIV_ROUND_UP(palm_bk3710_udmatimings[mode].cycletime,
+			  ide_palm_clk) - 1;
+	tenv = DIV_ROUND_UP(20, ide_palm_clk) - 1;
+	trp = DIV_ROUND_UP(palm_bk3710_udmatimings[mode].rptime,
+			   ide_palm_clk) - 1;
 
 	/* udmatim Register */
 	val16 = readw(base + BK3710_UDMATIM) & (dev ? 0xFF0F : 0xFFF0);
@@ -141,8 +141,8 @@ static void palm_bk3710_setdmamode(void __iomem *base, unsigned int dev,
 	cycletime = max_t(int, t->cycle, min_cycle);
 
 	/* DMA Data Setup */
-	t0 = (cycletime + ide_palm_clk - 1) / ide_palm_clk;
-	td = (t->active + ide_palm_clk - 1) / ide_palm_clk;
+	t0 = DIV_ROUND_UP(cycletime, ide_palm_clk);
+	td = DIV_ROUND_UP(t->active, ide_palm_clk);
 	tkw = t0 - td - 1;
 	td -= 1;
 
@@ -168,9 +168,9 @@ static void palm_bk3710_setpiomode(void __iomem *base, ide_drive_t *mate,
 	struct ide_timing *t;
 
 	/* PIO Data Setup */
-	t0 = (cycletime + ide_palm_clk - 1) / ide_palm_clk;
-	t2 = (ide_timing_find_mode(XFER_PIO_0 + mode)->active +
-	      ide_palm_clk - 1)	/ ide_palm_clk;
+	t0 = DIV_ROUND_UP(cycletime, ide_palm_clk);
+	t2 = DIV_ROUND_UP(ide_timing_find_mode(XFER_PIO_0 + mode)->active,
+			  ide_palm_clk);
 
 	t2i = t0 - t2 - 1;
 	t2 -= 1;
@@ -192,8 +192,8 @@ static void palm_bk3710_setpiomode(void __iomem *base, ide_drive_t *mate,
 
 	/* TASKFILE Setup */
 	t = ide_timing_find_mode(XFER_PIO_0 + mode);
-	t0 = (t->cyc8b + ide_palm_clk - 1) / ide_palm_clk;
-	t2 = (t->act8b + ide_palm_clk - 1) / ide_palm_clk;
+	t0 = DIV_ROUND_UP(t->cyc8b, ide_palm_clk);
+	t2 = DIV_ROUND_UP(t->act8b, ide_palm_clk);
 
 	t2i = t0 - t2 - 1;
 	t2 -= 1;
@@ -378,7 +378,7 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 	hw.irq = irq->start;
 	hw.chipset = ide_palm3710;
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif == NULL)
 		goto out;
 
diff --git a/drivers/ide/arm/rapide.c b/drivers/ide/arm/rapide.c
index b30adcf..2c3d0ec 100644
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -44,7 +44,7 @@ rapide_probe(struct expansion_card *ec, const struct ecard_id *id)
 		goto release;
 	}
 
-	hwif = ide_find_port((unsigned long)base);
+	hwif = ide_find_port();
 	if (hwif) {
 		memset(&hw, 0, sizeof(hw));
 		rapide_setup_ports(&hw, base, base + 0x818, 1 << 6, ec->irq);
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 31266d2..790a775 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -804,7 +804,7 @@ static int __init init_e100_ide(void)
 
 		cris_setup_ports(&hw, cris_ide_base_address(h));
 
-		hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+		hwif = ide_find_port();
 		if (hwif == NULL)
 			continue;
 		ide_init_port_data(hwif, hwif->index);
diff --git a/drivers/ide/h8300/ide-h8300.c b/drivers/ide/h8300/ide-h8300.c
index 4108ec4..92b02b9 100644
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -99,8 +99,7 @@ static int __init h8300_ide_init(void)
 
 	hw_setup(&hw);
 
-	/* register if */
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif == NULL) {
 		printk(KERN_ERR "ide-h8300: IDE I/F register failed\n");
 		return -ENOENT;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index fe5aefb..1afd95a 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -13,8 +13,8 @@
  *
  * Suggestions are welcome. Patches that work are more welcome though. ;-)
  * For those wishing to work on this driver, please be sure you download
- * and comply with the latest Mt. Fuji (SFF8090 version 4) and ATAPI 
- * (SFF-8020i rev 2.6) standards. These documents can be obtained by 
+ * and comply with the latest Mt. Fuji (SFF8090 version 4) and ATAPI
+ * (SFF-8020i rev 2.6) standards. These documents can be obtained by
  * anonymous ftp from:
  * ftp://fission.dt.wdc.com/pub/standards/SFF_atapi/spec/SFF8020-r2.6/PS/8020r26.ps
  * ftp://ftp.avc-pioneer.com/Mtfuji4/Spec/Fuji4r10.pdf
@@ -51,7 +51,7 @@
 
 static DEFINE_MUTEX(idecd_ref_mutex);
 
-#define to_ide_cd(obj) container_of(obj, struct cdrom_info, kref) 
+#define to_ide_cd(obj) container_of(obj, struct cdrom_info, kref)
 
 #define ide_cd_g(disk) \
 	container_of((disk)->private_data, struct cdrom_info, driver)
@@ -83,13 +83,12 @@ static void ide_cd_put(struct cdrom_info *cd)
 
 /* Mark that we've seen a media change, and invalidate our internal
    buffers. */
-static void cdrom_saw_media_change (ide_drive_t *drive)
+static void cdrom_saw_media_change(ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
 
 	cd->cd_flags |= IDE_CD_FLAG_MEDIA_CHANGED;
 	cd->cd_flags &= ~IDE_CD_FLAG_TOC_VALID;
-	cd->nsectors_buffered = 0;
 }
 
 static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
@@ -101,38 +100,39 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 		return 0;
 
 	switch (sense->sense_key) {
-		case NO_SENSE: case RECOVERED_ERROR:
-			break;
-		case NOT_READY:
-			/*
-			 * don't care about tray state messages for
-			 * e.g. capacity commands or in-progress or
-			 * becoming ready
-			 */
-			if (sense->asc == 0x3a || sense->asc == 0x04)
-				break;
-			log = 1;
-			break;
-		case ILLEGAL_REQUEST:
-			/*
-			 * don't log START_STOP unit with LoEj set, since
-			 * we cannot reliably check if drive can auto-close
-			 */
-			if (rq->cmd[0] == GPCMD_START_STOP_UNIT && sense->asc == 0x24)
-				break;
-			log = 1;
-			break;
-		case UNIT_ATTENTION:
-			/*
-			 * Make good and sure we've seen this potential media
-			 * change. Some drives (i.e. Creative) fail to present
-			 * the correct sense key in the error register.
-			 */
-			cdrom_saw_media_change(drive);
+	case NO_SENSE:
+	case RECOVERED_ERROR:
+		break;
+	case NOT_READY:
+		/*
+		 * don't care about tray state messages for
+		 * e.g. capacity commands or in-progress or
+		 * becoming ready
+		 */
+		if (sense->asc == 0x3a || sense->asc == 0x04)
 			break;
-		default:
-			log = 1;
+		log = 1;
+		break;
+	case ILLEGAL_REQUEST:
+		/*
+		 * don't log START_STOP unit with LoEj set, since
+		 * we cannot reliably check if drive can auto-close
+		 */
+		if (rq->cmd[0] == GPCMD_START_STOP_UNIT && sense->asc == 0x24)
 			break;
+		log = 1;
+		break;
+	case UNIT_ATTENTION:
+		/*
+		 * Make good and sure we've seen this potential media
+		 * change. Some drives (i.e. Creative) fail to present
+		 * the correct sense key in the error register.
+		 */
+		cdrom_saw_media_change(drive);
+		break;
+	default:
+		log = 1;
+		break;
 	}
 	return log;
 }
@@ -159,8 +159,8 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 		if (sense->sense_key == 0x05 && sense->asc == 0x24)
 			return;
 
- 	if (sense->error_code == 0x70) {	/* Current Error */
- 		switch(sense->sense_key) {
+	if (sense->error_code == 0x70) {	/* Current Error */
+		switch (sense->sense_key) {
 		case MEDIUM_ERROR:
 		case VOLUME_OVERFLOW:
 		case ILLEGAL_REQUEST:
@@ -179,7 +179,7 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 				bio_sectors = 4;
 			if (drive->queue->hardsect_size == 2048)
 				sector <<= 2;	/* Device sector size is 2K */
-			sector &= ~(bio_sectors -1);
+			sector &= ~(bio_sectors - 1);
 			valid = (sector - failed_command->sector) << 9;
 
 			if (valid < 0)
@@ -188,8 +188,8 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 				drive->probed_capacity - sector < 4 * 75) {
 				set_capacity(info->disk, sector);
 			}
- 		}
- 	}
+		}
+	}
 
 	ide_cd_log_error(drive->name, failed_command, sense);
 }
@@ -230,7 +230,7 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
 }
 
-static void cdrom_end_request (ide_drive_t *drive, int uptodate)
+static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 {
 	struct request *rq = HWGROUP(drive)->rq;
 	int nsectors = rq->hard_cur_sectors;
@@ -293,7 +293,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 {
 	struct request *rq = HWGROUP(drive)->rq;
 	int stat, err, sense_key;
-	
+
 	/* Check for errors. */
 	stat = ide_read_status(drive);
 
@@ -334,26 +334,26 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 
 		/* Check for tray open. */
 		if (sense_key == NOT_READY) {
-			cdrom_saw_media_change (drive);
+			cdrom_saw_media_change(drive);
 		} else if (sense_key == UNIT_ATTENTION) {
 			/* Check for media change. */
-			cdrom_saw_media_change (drive);
+			cdrom_saw_media_change(drive);
 			/*printk("%s: media changed\n",drive->name);*/
 			return 0;
- 		} else if ((sense_key == ILLEGAL_REQUEST) &&
- 			   (rq->cmd[0] == GPCMD_START_STOP_UNIT)) {
- 			/*
- 			 * Don't print error message for this condition--
- 			 * SFF8090i indicates that 5/24/00 is the correct
- 			 * response to a request to close the tray if the
- 			 * drive doesn't have that capability.
- 			 * cdrom_log_sense() knows this!
- 			 */
+		} else if (sense_key == ILLEGAL_REQUEST &&
+			   rq->cmd[0] == GPCMD_START_STOP_UNIT) {
+			/*
+			 * Don't print error message for this condition--
+			 * SFF8090i indicates that 5/24/00 is the correct
+			 * response to a request to close the tray if the
+			 * drive doesn't have that capability.
+			 * cdrom_log_sense() knows this!
+			 */
 		} else if (!(rq->cmd_flags & REQ_QUIET)) {
 			/* Otherwise, print an error. */
 			ide_dump_status(drive, "packet command error", stat);
 		}
-		
+
 		rq->cmd_flags |= REQ_FAILED;
 
 		/*
@@ -374,10 +374,10 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		if (sense_key == NOT_READY) {
 			/* Tray open. */
 			if (rq_data_dir(rq) == READ) {
-				cdrom_saw_media_change (drive);
+				cdrom_saw_media_change(drive);
 
 				/* Fail the request. */
-				printk ("%s: tray open\n", drive->name);
+				printk("%s: tray open\n", drive->name);
 				do_end_request = 1;
 			} else {
 				struct cdrom_info *info = drive->driver_data;
@@ -399,7 +399,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 					 */
 					spin_lock_irqsave(&ide_lock, flags);
 					blk_plug_device(drive->queue);
-					spin_unlock_irqrestore(&ide_lock,flags);
+					spin_unlock_irqrestore(&ide_lock, flags);
 					return 1;
 				}
 			}
@@ -407,25 +407,31 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 			/* Media change. */
 			cdrom_saw_media_change (drive);
 
-			/* Arrange to retry the request.
-			   But be sure to give up if we've retried
-			   too many times. */
+			/*
+			 * Arrange to retry the request.
+			 * But be sure to give up if we've retried
+			 * too many times.
+			 */
 			if (++rq->errors > ERROR_MAX)
 				do_end_request = 1;
 		} else if (sense_key == ILLEGAL_REQUEST ||
 			   sense_key == DATA_PROTECT) {
-			/* No point in retrying after an illegal
-			   request or data protect error.*/
-			ide_dump_status_no_sense (drive, "command error", stat);
+			/*
+			 * No point in retrying after an illegal
+			 * request or data protect error.
+			 */
+			ide_dump_status_no_sense(drive, "command error", stat);
 			do_end_request = 1;
 		} else if (sense_key == MEDIUM_ERROR) {
-			/* No point in re-trying a zillion times on a bad 
-			 * sector...  If we got here the error is not correctable */
-			ide_dump_status_no_sense (drive, "media error (bad sector)", stat);
+			/*
+			 * No point in re-trying a zillion times on a bad
+			 * sector... If we got here the error is not correctable
+			 */
+			ide_dump_status_no_sense(drive, "media error (bad sector)", stat);
 			do_end_request = 1;
 		} else if (sense_key == BLANK_CHECK) {
 			/* Disk appears blank ?? */
-			ide_dump_status_no_sense (drive, "media error (blank)", stat);
+			ide_dump_status_no_sense(drive, "media error (blank)", stat);
 			do_end_request = 1;
 		} else if ((err & ~ABRT_ERR) != 0) {
 			/* Go to the default handler
@@ -486,18 +492,18 @@ static int cdrom_timer_expiry(ide_drive_t *drive)
 	 * ide_timer_expiry keep polling us for these.
 	 */
 	switch (rq->cmd[0]) {
-		case GPCMD_BLANK:
-		case GPCMD_FORMAT_UNIT:
-		case GPCMD_RESERVE_RZONE_TRACK:
-		case GPCMD_CLOSE_TRACK:
-		case GPCMD_FLUSH_CACHE:
-			wait = ATAPI_WAIT_PC;
-			break;
-		default:
-			if (!(rq->cmd_flags & REQ_QUIET))
-				printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n", rq->cmd[0]);
-			wait = 0;
-			break;
+	case GPCMD_BLANK:
+	case GPCMD_FORMAT_UNIT:
+	case GPCMD_RESERVE_RZONE_TRACK:
+	case GPCMD_CLOSE_TRACK:
+	case GPCMD_FLUSH_CACHE:
+		wait = ATAPI_WAIT_PC;
+		break;
+	default:
+		if (!(rq->cmd_flags & REQ_QUIET))
+			printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n", rq->cmd[0]);
+		wait = 0;
+		break;
 	}
 	return wait;
 }
@@ -557,7 +563,7 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
    HANDLER is the interrupt handler to call when the command completes
    or there's data ready. */
 #define ATAPI_MIN_CDB_BYTES 12
-static ide_startstop_t cdrom_transfer_packet_command (ide_drive_t *drive,
+static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 					  struct request *rq,
 					  ide_handler_t *handler)
 {
@@ -626,47 +632,6 @@ static void ide_cd_drain_data(ide_drive_t *drive, int nsects)
 }
 
 /*
- * Buffer up to SECTORS_TO_TRANSFER sectors from the drive in our sector
- * buffer.  Once the first sector is added, any subsequent sectors are
- * assumed to be continuous (until the buffer is cleared).  For the first
- * sector added, SECTOR is its sector number.  (SECTOR is then ignored until
- * the buffer is cleared.)
- */
-static void cdrom_buffer_sectors (ide_drive_t *drive, unsigned long sector,
-                                  int sectors_to_transfer)
-{
-	struct cdrom_info *info = drive->driver_data;
-
-	/* Number of sectors to read into the buffer. */
-	int sectors_to_buffer = min_t(int, sectors_to_transfer,
-				     (SECTOR_BUFFER_SIZE >> SECTOR_BITS) -
-				       info->nsectors_buffered);
-
-	char *dest;
-
-	/* If we couldn't get a buffer, don't try to buffer anything... */
-	if (info->buffer == NULL)
-		sectors_to_buffer = 0;
-
-	/* If this is the first sector in the buffer, remember its number. */
-	if (info->nsectors_buffered == 0)
-		info->sector_buffered = sector;
-
-	/* Read the data into the buffer. */
-	dest = info->buffer + info->nsectors_buffered * SECTOR_SIZE;
-	while (sectors_to_buffer > 0) {
-		HWIF(drive)->atapi_input_bytes(drive, dest, SECTOR_SIZE);
-		--sectors_to_buffer;
-		--sectors_to_transfer;
-		++info->nsectors_buffered;
-		dest += SECTOR_SIZE;
-	}
-
-	/* Throw away any remaining data. */
-	ide_cd_drain_data(drive, sectors_to_transfer);
-}
-
-/*
  * Check the contents of the interrupt reason register from the cdrom
  * and attempt to recover if there are problems.  Returns  0 if everything's
  * ok; nonzero if the request has been terminated.
@@ -686,7 +651,7 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 
 		/* Whoops... */
 		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
-				drive->name, __FUNCTION__);
+				drive->name, __func__);
 
 		xf = rw ? hwif->atapi_output_bytes : hwif->atapi_input_bytes;
 		ide_cd_pad_transfer(drive, xf, len);
@@ -699,7 +664,7 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 	} else {
 		/* Drive wants a command packet, or invalid ireason... */
 		printk(KERN_ERR "%s: %s: bad interrupt reason 0x%02x\n",
-				drive->name, __FUNCTION__, ireason);
+				drive->name, __func__, ireason);
 	}
 
 	if (rq->cmd_type == REQ_TYPE_ATA_PC)
@@ -721,7 +686,7 @@ static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 		return 0;
 
 	printk(KERN_ERR "%s: %s: Bad transfer size %d\n",
-			drive->name, __FUNCTION__, len);
+			drive->name, __func__, len);
 
 	if (cd->cd_flags & IDE_CD_FLAG_LIMIT_NFRAMES)
 		printk(KERN_ERR "  This drive is not supported by "
@@ -734,65 +699,6 @@ static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 	return 1;
 }
 
-/*
- * Try to satisfy some of the current read request from our cached data.
- * Returns nonzero if the request has been completed, zero otherwise.
- */
-static int cdrom_read_from_buffer (ide_drive_t *drive)
-{
-	struct cdrom_info *info = drive->driver_data;
-	struct request *rq = HWGROUP(drive)->rq;
-	unsigned short sectors_per_frame;
-
-	sectors_per_frame = queue_hardsect_size(drive->queue) >> SECTOR_BITS;
-
-	/* Can't do anything if there's no buffer. */
-	if (info->buffer == NULL) return 0;
-
-	/* Loop while this request needs data and the next block is present
-	   in our cache. */
-	while (rq->nr_sectors > 0 &&
-	       rq->sector >= info->sector_buffered &&
-	       rq->sector < info->sector_buffered + info->nsectors_buffered) {
-		if (rq->current_nr_sectors == 0)
-			cdrom_end_request(drive, 1);
-
-		memcpy (rq->buffer,
-			info->buffer +
-			(rq->sector - info->sector_buffered) * SECTOR_SIZE,
-			SECTOR_SIZE);
-		rq->buffer += SECTOR_SIZE;
-		--rq->current_nr_sectors;
-		--rq->nr_sectors;
-		++rq->sector;
-	}
-
-	/* If we've satisfied the current request,
-	   terminate it successfully. */
-	if (rq->nr_sectors == 0) {
-		cdrom_end_request(drive, 1);
-		return -1;
-	}
-
-	/* Move on to the next buffer if needed. */
-	if (rq->current_nr_sectors == 0)
-		cdrom_end_request(drive, 1);
-
-	/* If this condition does not hold, then the kluge i use to
-	   represent the number of sectors to skip at the start of a transfer
-	   will fail.  I think that this will never happen, but let's be
-	   paranoid and check. */
-	if (rq->current_nr_sectors < bio_cur_sectors(rq->bio) &&
-	    (rq->sector & (sectors_per_frame - 1))) {
-		printk(KERN_ERR "%s: cdrom_read_from_buffer: buffer botch (%ld)\n",
-			drive->name, (long)rq->sector);
-		cdrom_end_request(drive, 0);
-		return -1;
-	}
-
-	return 0;
-}
-
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *);
 
 /*
@@ -825,7 +731,7 @@ static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 			if (rq->current_nr_sectors !=
 			    bio_cur_sectors(rq->bio)) {
 				printk(KERN_ERR "%s: %s: buffer botch (%u)\n",
-						drive->name, __FUNCTION__,
+						drive->name, __func__,
 						rq->current_nr_sectors);
 				cdrom_end_request(drive, 0);
 				return ide_stopped;
@@ -849,7 +755,7 @@ static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 #define IDECD_SEEK_TIMER	(5 * WAIT_MIN_SLEEP)	/* 100 ms */
 #define IDECD_SEEK_TIMEOUT	(2 * WAIT_CMD)		/* 20 sec */
 
-static ide_startstop_t cdrom_seek_intr (ide_drive_t *drive)
+static ide_startstop_t cdrom_seek_intr(ide_drive_t *drive)
 {
 	struct cdrom_info *info = drive->driver_data;
 	int stat;
@@ -866,14 +772,14 @@ static ide_startstop_t cdrom_seek_intr (ide_drive_t *drive)
 			 * this condition is far too common, to bother
 			 * users about it
 			 */
-			/* printk("%s: disabled DSC seek overlap\n", drive->name);*/ 
+			/* printk("%s: disabled DSC seek overlap\n", drive->name);*/
 			drive->dsc_overlap = 0;
 		}
 	}
 	return ide_stopped;
 }
 
-static ide_startstop_t cdrom_start_seek_continuation (ide_drive_t *drive)
+static ide_startstop_t cdrom_start_seek_continuation(ide_drive_t *drive)
 {
 	struct request *rq = HWGROUP(drive)->rq;
 	sector_t frame = rq->sector;
@@ -888,7 +794,7 @@ static ide_startstop_t cdrom_start_seek_continuation (ide_drive_t *drive)
 	return cdrom_transfer_packet_command(drive, rq, &cdrom_seek_intr);
 }
 
-static ide_startstop_t cdrom_start_seek (ide_drive_t *drive, unsigned int block)
+static ide_startstop_t cdrom_start_seek(ide_drive_t *drive, unsigned int block)
 {
 	struct cdrom_info *info = drive->driver_data;
 
@@ -897,9 +803,11 @@ static ide_startstop_t cdrom_start_seek (ide_drive_t *drive, unsigned int block)
 	return cdrom_start_packet_command(drive, 0, cdrom_start_seek_continuation);
 }
 
-/* Fix up a possibly partially-processed request so that we can
-   start it over entirely, or even put it back on the request queue. */
-static void restore_request (struct request *rq)
+/*
+ * Fix up a possibly partially-processed request so that we can
+ * start it over entirely, or even put it back on the request queue.
+ */
+static void restore_request(struct request *rq)
 {
 	if (rq->buffer != bio_data(rq->bio)) {
 		sector_t n = (rq->buffer - (char *) bio_data(rq->bio)) / SECTOR_SIZE;
@@ -950,7 +858,7 @@ int ide_cd_queue_pc(ide_drive_t *drive, struct request *rq)
 		error = ide_do_drive_cmd(drive, rq, ide_wait);
 		time = jiffies - time;
 
-		/* FIXME: we should probably abort/retry or something 
+		/* FIXME: we should probably abort/retry or something
 		 * in case of failure */
 		if (rq->cmd_flags & REQ_FAILED) {
 			/* The request failed.  Retry if it was due to a unit
@@ -1057,7 +965,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			if (rq->current_nr_sectors > 0) {
 				printk(KERN_ERR "%s: %s: data underrun "
 						"(%d blocks)\n",
-						drive->name, __FUNCTION__,
+						drive->name, __func__,
 						rq->current_nr_sectors);
 				if (!write)
 					rq->cmd_flags |= REQ_FAILED;
@@ -1134,11 +1042,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		if (!ptr) {
 			if (blk_fs_request(rq) && !write)
 				/*
-				 * If the buffers are full, cache the rest
-				 * of the data in our internal buffer.
-				 */
-				cdrom_buffer_sectors(drive, rq->sector,
-						     thislen >> 9);
+				 * If the buffers are full, pipe the rest into
+				 * oblivion. */
+				ide_cd_drain_data(drive, thislen >> 9);
 			else {
 				printk(KERN_ERR "%s: confused, missing data\n",
 						drive->name);
@@ -1243,10 +1149,6 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 		 * weirdness which might be present in the request packet.
 		 */
 		restore_request(rq);
-
-		/* Satisfy whatever we can of this request from our cache. */
-		if (cdrom_read_from_buffer(drive))
-			return ide_stopped;
 	}
 
 	/*
@@ -1262,9 +1164,6 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 	} else
 		cd->dma = drive->using_dma;
 
-	/* Clear the local sector buffer. */
-	cd->nsectors_buffered = 0;
-
 	if (write)
 		cd->devinfo.media_written = 1;
 
@@ -1320,7 +1219,7 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
  * cdrom driver request routine.
  */
 static ide_startstop_t
-ide_do_rw_cdrom (ide_drive_t *drive, struct request *rq, sector_t block)
+ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq, sector_t block)
 {
 	ide_startstop_t action;
 	struct cdrom_info *info = drive->driver_data;
@@ -1335,13 +1234,13 @@ ide_do_rw_cdrom (ide_drive_t *drive, struct request *rq, sector_t block)
 					ide_stall_queue(drive, IDECD_SEEK_TIMER);
 					return ide_stopped;
 				}
-				printk (KERN_ERR "%s: DSC timeout\n", drive->name);
+				printk(KERN_ERR "%s: DSC timeout\n", drive->name);
 			}
 			info->cd_flags &= ~IDE_CD_FLAG_SEEKING;
 		}
-		if ((rq_data_dir(rq) == READ) && IDE_LARGE_SEEK(info->last_block, block, IDECD_SEEK_THRESHOLD) && drive->dsc_overlap) {
+		if ((rq_data_dir(rq) == READ) && IDE_LARGE_SEEK(info->last_block, block, IDECD_SEEK_THRESHOLD) && drive->dsc_overlap)
 			action = cdrom_start_seek(drive, block);
-		} else
+		else
 			action = cdrom_start_rw(drive, rq);
 		info->last_block = block;
 		return action;
@@ -1374,7 +1273,7 @@ ide_do_rw_cdrom (ide_drive_t *drive, struct request *rq, sector_t block)
  */
 
 static
-void msf_from_bcd (struct atapi_msf *msf)
+void msf_from_bcd(struct atapi_msf *msf)
 {
 	msf->minute = BCD2BIN(msf->minute);
 	msf->second = BCD2BIN(msf->second);
@@ -1474,7 +1373,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		/* Try to allocate space. */
 		toc = kmalloc(sizeof(struct atapi_toc), GFP_KERNEL);
 		if (toc == NULL) {
-			printk (KERN_ERR "%s: No cdrom TOC buffer!\n", drive->name);
+			printk(KERN_ERR "%s: No cdrom TOC buffer!\n", drive->name);
 			return -ENOMEM;
 		}
 		info->toc = toc;
@@ -1569,9 +1468,9 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 				toc->ent[i].track = BCD2BIN(toc->ent[i].track);
 			msf_from_bcd(&toc->ent[i].addr.msf);
 		}
-		toc->ent[i].addr.lba = msf_to_lba (toc->ent[i].addr.msf.minute,
-						   toc->ent[i].addr.msf.second,
-						   toc->ent[i].addr.msf.frame);
+		toc->ent[i].addr.lba = msf_to_lba(toc->ent[i].addr.msf.minute,
+						  toc->ent[i].addr.msf.second,
+						  toc->ent[i].addr.msf.frame);
 	}
 
 	/* Read the multisession information. */
@@ -1595,9 +1494,9 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		if (stat)
 			return stat;
 
-		msf_from_bcd (&ms_tmp.ent.addr.msf);
+		msf_from_bcd(&ms_tmp.ent.addr.msf);
 		toc->last_session_lba = msf_to_lba(ms_tmp.ent.addr.msf.minute,
-					  	   ms_tmp.ent.addr.msf.second,
+						   ms_tmp.ent.addr.msf.second,
 						   ms_tmp.ent.addr.msf.frame);
 	}
 
@@ -1679,7 +1578,7 @@ static struct cdrom_device_ops ide_cdrom_dops = {
 	.generic_packet		= ide_cdrom_packet,
 };
 
-static int ide_cdrom_register (ide_drive_t *drive, int nslots)
+static int ide_cdrom_register(ide_drive_t *drive, int nslots)
 {
 	struct cdrom_info *info = drive->driver_data;
 	struct cdrom_device_info *devinfo = &info->devinfo;
@@ -1698,7 +1597,7 @@ static int ide_cdrom_register (ide_drive_t *drive, int nslots)
 }
 
 static
-int ide_cdrom_probe_capabilities (ide_drive_t *drive)
+int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
@@ -1870,7 +1769,7 @@ static int ide_cdrom_prep_pc(struct request *rq)
 		rq->errors = ILLEGAL_REQUEST;
 		return BLKPREP_KILL;
 	}
-	
+
 	return BLKPREP_OK;
 }
 
@@ -1948,7 +1847,7 @@ static unsigned int ide_cd_flags(struct hd_driveid *id)
 }
 
 static
-int ide_cdrom_setup (ide_drive_t *drive)
+int ide_cdrom_setup(ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
@@ -1979,7 +1878,7 @@ int ide_cdrom_setup (ide_drive_t *drive)
 	else if (cd->cd_flags & IDE_CD_FLAG_SANYO_3CD)
 		cdi->sanyo_slot = 3;	/* 3 => use CD in slot 0 */
 
-	nslots = ide_cdrom_probe_capabilities (drive);
+	nslots = ide_cdrom_probe_capabilities(drive);
 
 	/*
 	 * set correct block size
@@ -1991,7 +1890,7 @@ int ide_cdrom_setup (ide_drive_t *drive)
 		drive->dsc_overlap = (drive->next != drive);
 
 	if (ide_cdrom_register(drive, nslots)) {
-		printk (KERN_ERR "%s: ide_cdrom_setup failed to register device with the cdrom driver.\n", drive->name);
+		printk(KERN_ERR "%s: ide_cdrom_setup failed to register device with the cdrom driver.\n", drive->name);
 		cd->devinfo.handle = NULL;
 		return 1;
 	}
@@ -1999,19 +1898,6 @@ int ide_cdrom_setup (ide_drive_t *drive)
 	return 0;
 }
 
-#ifdef CONFIG_IDE_PROC_FS
-static
-sector_t ide_cdrom_capacity (ide_drive_t *drive)
-{
-	unsigned long capacity, sectors_per_frame;
-
-	if (cdrom_read_capacity(drive, &capacity, &sectors_per_frame, NULL))
-		return 0;
-
-	return capacity * sectors_per_frame;
-}
-#endif
-
 static void ide_cd_remove(ide_drive_t *drive)
 {
 	struct cdrom_info *info = drive->driver_data;
@@ -2030,7 +1916,6 @@ static void ide_cd_release(struct kref *kref)
 	ide_drive_t *drive = info->drive;
 	struct gendisk *g = info->disk;
 
-	kfree(info->buffer);
 	kfree(info->toc);
 	if (devinfo->handle == drive)
 		unregister_cdrom(devinfo);
@@ -2045,14 +1930,24 @@ static void ide_cd_release(struct kref *kref)
 static int ide_cd_probe(ide_drive_t *);
 
 #ifdef CONFIG_IDE_PROC_FS
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
 static int proc_idecd_read_capacity
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
 	ide_drive_t *drive = data;
 	int len;
 
-	len = sprintf(page,"%llu\n", (long long)ide_cdrom_capacity(drive));
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	len = sprintf(page, "%llu\n", (long long)ide_cdrom_capacity(drive));
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static ide_proc_entry_t idecd_proc[] = {
@@ -2081,20 +1976,17 @@ static ide_driver_t ide_cdrom_driver = {
 #endif
 };
 
-static int idecd_open(struct inode * inode, struct file * file)
+static int idecd_open(struct inode *inode, struct file *file)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct cdrom_info *info;
 	int rc = -ENOMEM;
 
-	if (!(info = ide_cd_get(disk)))
+	info = ide_cd_get(disk);
+	if (!info)
 		return -ENXIO;
 
-	if (!info->buffer)
-		info->buffer = kmalloc(SECTOR_BUFFER_SIZE, GFP_KERNEL|__GFP_REPEAT);
-
-	if (info->buffer)
-		rc = cdrom_open(&info->devinfo, inode, file);
+	rc = cdrom_open(&info->devinfo, inode, file);
 
 	if (rc < 0)
 		ide_cd_put(info);
@@ -2102,12 +1994,12 @@ static int idecd_open(struct inode * inode, struct file * file)
 	return rc;
 }
 
-static int idecd_release(struct inode * inode, struct file * file)
+static int idecd_release(struct inode *inode, struct file *file)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct cdrom_info *info = ide_cd_g(disk);
 
-	cdrom_release (&info->devinfo, file);
+	cdrom_release(&info->devinfo, file);
 
 	ide_cd_put(info);
 
@@ -2139,7 +2031,7 @@ static int idecd_get_spindown(struct cdrom_device_info *cdi, unsigned long arg)
 	struct packet_command cgc;
 	char buffer[16];
 	int stat;
- 	char spindown;
+	char spindown;
 
 	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_UNKNOWN);
 
@@ -2148,12 +2040,12 @@ static int idecd_get_spindown(struct cdrom_device_info *cdi, unsigned long arg)
 		return stat;
 
 	spindown = buffer[11] & 0x0f;
-	if (copy_to_user((void __user *)arg, &spindown, sizeof (char)))
+	if (copy_to_user((void __user *)arg, &spindown, sizeof(char)))
 		return -EFAULT;
 	return 0;
 }
 
-static int idecd_ioctl (struct inode *inode, struct file *file,
+static int idecd_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
 	struct block_device *bdev = inode->i_bdev;
@@ -2161,13 +2053,13 @@ static int idecd_ioctl (struct inode *inode, struct file *file,
 	int err;
 
 	switch (cmd) {
- 	case CDROMSETSPINDOWN:
+	case CDROMSETSPINDOWN:
 		return idecd_set_spindown(&info->devinfo, arg);
- 	case CDROMGETSPINDOWN:
+	case CDROMGETSPINDOWN:
 		return idecd_get_spindown(&info->devinfo, arg);
 	default:
 		break;
- 	}
+	}
 
 	err = generic_ide_ioctl(info->drive, file, bdev, cmd, arg);
 	if (err == -EINVAL)
@@ -2193,16 +2085,16 @@ static int idecd_revalidate_disk(struct gendisk *disk)
 }
 
 static struct block_device_operations idecd_ops = {
-	.owner		= THIS_MODULE,
-	.open		= idecd_open,
-	.release	= idecd_release,
-	.ioctl		= idecd_ioctl,
-	.media_changed	= idecd_media_changed,
-	.revalidate_disk= idecd_revalidate_disk
+	.owner			= THIS_MODULE,
+	.open			= idecd_open,
+	.release		= idecd_release,
+	.ioctl			= idecd_ioctl,
+	.media_changed		= idecd_media_changed,
+	.revalidate_disk	= idecd_revalidate_disk
 };
 
 /* options */
-static char *ignore = NULL;
+static char *ignore;
 
 module_param(ignore, charp, 0400);
 MODULE_DESCRIPTION("ATAPI CD-ROM Driver");
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index 22e3751..a58801c 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -119,10 +119,6 @@ struct cdrom_info {
 
 	struct atapi_toc *toc;
 
-	unsigned long	sector_buffered;
-	unsigned long	nsectors_buffered;
-	unsigned char	*buffer;
-
 	/* The result of the last successful request sense command
 	   on this device. */
 	struct request_sense sense_data;
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 39501d1..8e08d08 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -16,8 +16,6 @@
 
 #define IDEDISK_VERSION	"1.18"
 
-//#define DEBUG
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -88,7 +86,7 @@ static void ide_disk_put(struct ide_disk_obj *idkp)
  *
  * It is called only once for each drive.
  */
-static int lba_capacity_is_ok (struct hd_driveid *id)
+static int lba_capacity_is_ok(struct hd_driveid *id)
 {
 	unsigned long lba_sects, chs_sects, head, tail;
 
@@ -176,7 +174,8 @@ static void ide_tf_set_cmd(ide_drive_t *drive, ide_task_t *task, u8 dma)
  * __ide_do_rw_disk() issues READ and WRITE commands to a disk,
  * using LBA if supported, or CHS otherwise, to address sectors.
  */
-static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq, sector_t block)
+static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
+					sector_t block)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned int dma	= drive->using_dma;
@@ -228,7 +227,8 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 			tf->device = (block >> 8) & 0xf;
 		}
 	} else {
-		unsigned int sect,head,cyl,track;
+		unsigned int sect, head, cyl, track;
+
 		track = (int)block / drive->sect;
 		sect  = (int)block % drive->sect + 1;
 		head  = track % drive->head;
@@ -271,7 +271,8 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
  * 1073741822 == 549756 MB or 48bit addressing fake drive
  */
 
-static ide_startstop_t ide_do_rw_disk (ide_drive_t *drive, struct request *rq, sector_t block)
+static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
+				      sector_t block)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 
@@ -452,7 +453,7 @@ static void idedisk_check_hpa(ide_drive_t *drive)
  * in above order (i.e., if value of higher priority is available,
  * reset will be ignored).
  */
-static void init_idedisk_capacity (ide_drive_t  *drive)
+static void init_idedisk_capacity(ide_drive_t *drive)
 {
 	struct hd_driveid *id = drive->id;
 	/*
@@ -479,7 +480,7 @@ static void init_idedisk_capacity (ide_drive_t  *drive)
 	}
 }
 
-static sector_t idedisk_capacity (ide_drive_t *drive)
+static sector_t idedisk_capacity(ide_drive_t *drive)
 {
 	return drive->capacity64 - drive->sect0;
 }
@@ -524,10 +525,11 @@ static int proc_idedisk_read_cache
 	int		len;
 
 	if (drive->id_read)
-		len = sprintf(out,"%i\n", drive->id->buf_size / 2);
+		len = sprintf(out, "%i\n", drive->id->buf_size / 2);
 	else
-		len = sprintf(out,"(none)\n");
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+		len = sprintf(out, "(none)\n");
+
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static int proc_idedisk_read_capacity
@@ -536,54 +538,52 @@ static int proc_idedisk_read_capacity
 	ide_drive_t*drive = (ide_drive_t *)data;
 	int len;
 
-	len = sprintf(page,"%llu\n", (long long)idedisk_capacity(drive));
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	len = sprintf(page, "%llu\n", (long long)idedisk_capacity(drive));
+
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
-static int proc_idedisk_read_smart_thresholds
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
+static int proc_idedisk_read_smart(char *page, char **start, off_t off,
+				   int count, int *eof, void *data, u8 sub_cmd)
 {
 	ide_drive_t	*drive = (ide_drive_t *)data;
 	int		len = 0, i = 0;
 
-	if (get_smart_data(drive, page, SMART_READ_THRESHOLDS) == 0) {
+	if (get_smart_data(drive, page, sub_cmd) == 0) {
 		unsigned short *val = (unsigned short *) page;
 		char *out = ((char *)val) + (SECTOR_WORDS * 4);
 		page = out;
 		do {
-			out += sprintf(out, "%04x%c", le16_to_cpu(*val), (++i & 7) ? ' ' : '\n');
+			out += sprintf(out, "%04x%c", le16_to_cpu(*val),
+				       (++i & 7) ? ' ' : '\n');
 			val += 1;
 		} while (i < (SECTOR_WORDS * 2));
 		len = out - page;
 	}
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
-static int proc_idedisk_read_smart_values
+static int proc_idedisk_read_sv
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
-	ide_drive_t	*drive = (ide_drive_t *)data;
-	int		len = 0, i = 0;
+	return proc_idedisk_read_smart(page, start, off, count, eof, data,
+				       SMART_READ_VALUES);
+}
 
-	if (get_smart_data(drive, page, SMART_READ_VALUES) == 0) {
-		unsigned short *val = (unsigned short *) page;
-		char *out = ((char *)val) + (SECTOR_WORDS * 4);
-		page = out;
-		do {
-			out += sprintf(out, "%04x%c", le16_to_cpu(*val), (++i & 7) ? ' ' : '\n');
-			val += 1;
-		} while (i < (SECTOR_WORDS * 2));
-		len = out - page;
-	}
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+static int proc_idedisk_read_st
+	(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	return proc_idedisk_read_smart(page, start, off, count, eof, data,
+				       SMART_READ_THRESHOLDS);
 }
 
 static ide_proc_entry_t idedisk_proc[] = {
-	{ "cache",		S_IFREG|S_IRUGO,	proc_idedisk_read_cache,		NULL },
-	{ "capacity",		S_IFREG|S_IRUGO,	proc_idedisk_read_capacity,		NULL },
-	{ "geometry",		S_IFREG|S_IRUGO,	proc_ide_read_geometry,			NULL },
-	{ "smart_values",	S_IFREG|S_IRUSR,	proc_idedisk_read_smart_values,		NULL },
-	{ "smart_thresholds",	S_IFREG|S_IRUSR,	proc_idedisk_read_smart_thresholds,	NULL },
+	{ "cache",	  S_IFREG|S_IRUGO, proc_idedisk_read_cache,    NULL },
+	{ "capacity",	  S_IFREG|S_IRUGO, proc_idedisk_read_capacity, NULL },
+	{ "geometry",	  S_IFREG|S_IRUGO, proc_ide_read_geometry,     NULL },
+	{ "smart_values", S_IFREG|S_IRUSR, proc_idedisk_read_sv,       NULL },
+	{ "smart_thresholds", S_IFREG|S_IRUSR, proc_idedisk_read_st,   NULL },
 	{ NULL, 0, NULL, NULL }
 };
 #endif	/* CONFIG_IDE_PROC_FS */
@@ -625,12 +625,13 @@ static int set_multcount(ide_drive_t *drive, int arg)
 	if (drive->special.b.set_multmode)
 		return -EBUSY;
 
-	ide_init_drive_cmd (&rq);
+	ide_init_drive_cmd(&rq);
 	rq.cmd_type = REQ_TYPE_ATA_TASKFILE;
 
 	drive->mult_req = arg;
 	drive->special.b.set_multmode = 1;
-	(void) ide_do_drive_cmd (drive, &rq, ide_wait);
+	(void)ide_do_drive_cmd(drive, &rq, ide_wait);
+
 	return (drive->mult_count == arg) ? 0 : -EIO;
 }
 
@@ -706,7 +707,7 @@ static int write_cache(ide_drive_t *drive, int arg)
 	return err;
 }
 
-static int do_idedisk_flushcache (ide_drive_t *drive)
+static int do_idedisk_flushcache(ide_drive_t *drive)
 {
 	ide_task_t args;
 
@@ -719,7 +720,7 @@ static int do_idedisk_flushcache (ide_drive_t *drive)
 	return ide_no_data_taskfile(drive, &args);
 }
 
-static int set_acoustic (ide_drive_t *drive, int arg)
+static int set_acoustic(ide_drive_t *drive, int arg)
 {
 	ide_task_t args;
 
@@ -753,7 +754,7 @@ static int set_lba_addressing(ide_drive_t *drive, int arg)
 		return 0;
 
 	if (!idedisk_supports_lba48(drive->id))
-                return -EIO;
+		return -EIO;
 	drive->addressing = arg;
 	return 0;
 }
@@ -763,23 +764,35 @@ static void idedisk_add_settings(ide_drive_t *drive)
 {
 	struct hd_driveid *id = drive->id;
 
-	ide_add_setting(drive,	"bios_cyl",	SETTING_RW,	TYPE_INT,	0,	65535,			1,	1,	&drive->bios_cyl,	NULL);
-	ide_add_setting(drive,	"bios_head",	SETTING_RW,	TYPE_BYTE,	0,	255,			1,	1,	&drive->bios_head,	NULL);
-	ide_add_setting(drive,	"bios_sect",	SETTING_RW,	TYPE_BYTE,	0,	63,			1,	1,	&drive->bios_sect,	NULL);
-	ide_add_setting(drive,	"address",	SETTING_RW,	TYPE_BYTE,	0,	2,			1,	1,	&drive->addressing,	set_lba_addressing);
-	ide_add_setting(drive,	"multcount",	SETTING_RW,	TYPE_BYTE,	0,	id->max_multsect,	1,	1,	&drive->mult_count,	set_multcount);
-	ide_add_setting(drive,	"nowerr",	SETTING_RW,	TYPE_BYTE,	0,	1,			1,	1,	&drive->nowerr,		set_nowerr);
-	ide_add_setting(drive,	"lun",		SETTING_RW,	TYPE_INT,	0,	7,			1,	1,	&drive->lun,		NULL);
-	ide_add_setting(drive,	"wcache",	SETTING_RW,	TYPE_BYTE,	0,	1,			1,	1,	&drive->wcache,		write_cache);
-	ide_add_setting(drive,	"acoustic",	SETTING_RW,	TYPE_BYTE,	0,	254,			1,	1,	&drive->acoustic,	set_acoustic);
- 	ide_add_setting(drive,	"failures",	SETTING_RW,	TYPE_INT,	0,	65535,			1,	1,	&drive->failures,	NULL);
- 	ide_add_setting(drive,	"max_failures",	SETTING_RW,	TYPE_INT,	0,	65535,			1,	1,	&drive->max_failures,	NULL);
+	ide_add_setting(drive, "bios_cyl", SETTING_RW, TYPE_INT, 0, 65535, 1, 1,
+			&drive->bios_cyl, NULL);
+	ide_add_setting(drive, "bios_head", SETTING_RW, TYPE_BYTE, 0, 255, 1, 1,
+			&drive->bios_head, NULL);
+	ide_add_setting(drive, "bios_sect", SETTING_RW, TYPE_BYTE, 0, 63, 1, 1,
+			&drive->bios_sect, NULL);
+	ide_add_setting(drive, "address", SETTING_RW, TYPE_BYTE, 0, 2, 1, 1,
+			&drive->addressing, set_lba_addressing);
+	ide_add_setting(drive, "multcount", SETTING_RW, TYPE_BYTE, 0,
+			id->max_multsect, 1, 1, &drive->mult_count,
+			set_multcount);
+	ide_add_setting(drive, "nowerr", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
+			&drive->nowerr, set_nowerr);
+	ide_add_setting(drive, "lun", SETTING_RW, TYPE_INT, 0, 7, 1, 1,
+			&drive->lun, NULL);
+	ide_add_setting(drive, "wcache", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
+			&drive->wcache, write_cache);
+	ide_add_setting(drive, "acoustic", SETTING_RW, TYPE_BYTE, 0, 254, 1, 1,
+			&drive->acoustic, set_acoustic);
+	ide_add_setting(drive, "failures", SETTING_RW, TYPE_INT, 0, 65535, 1, 1,
+			&drive->failures, NULL);
+	ide_add_setting(drive, "max_failures", SETTING_RW, TYPE_INT, 0, 65535,
+			1, 1, &drive->max_failures, NULL);
 }
 #else
 static inline void idedisk_add_settings(ide_drive_t *drive) { ; }
 #endif
 
-static void idedisk_setup (ide_drive_t *drive)
+static void idedisk_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct hd_driveid *id = drive->id;
@@ -792,11 +805,10 @@ static void idedisk_setup (ide_drive_t *drive)
 
 	if (drive->removable) {
 		/*
-		 * Removable disks (eg. SYQUEST); ignore 'WD' drives 
+		 * Removable disks (eg. SYQUEST); ignore 'WD' drives
 		 */
-		if (id->model[0] != 'W' || id->model[1] != 'D') {
+		if (id->model[0] != 'W' || id->model[1] != 'D')
 			drive->doorlocking = 1;
-		}
 	}
 
 	(void)set_lba_addressing(drive, 1);
@@ -810,10 +822,11 @@ static void idedisk_setup (ide_drive_t *drive)
 		blk_queue_max_sectors(drive->queue, max_s);
 	}
 
-	printk(KERN_INFO "%s: max request size: %dKiB\n", drive->name, drive->queue->max_sectors / 2);
+	printk(KERN_INFO "%s: max request size: %dKiB\n", drive->name,
+			 drive->queue->max_sectors / 2);
 
 	/* calculate drive capacity, and select LBA if possible */
-	init_idedisk_capacity (drive);
+	init_idedisk_capacity(drive);
 
 	/* limit drive capacity to 137GB if LBA48 cannot be used */
 	if (drive->addressing == 0 && drive->capacity64 > 1ULL << 28) {
@@ -826,9 +839,9 @@ static void idedisk_setup (ide_drive_t *drive)
 
 	if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) && drive->addressing) {
 		if (drive->capacity64 > 1ULL << 28) {
-			printk(KERN_INFO "%s: cannot use LBA48 DMA - PIO mode will"
-					 " be used for accessing sectors > %u\n",
-					 drive->name, 1 << 28);
+			printk(KERN_INFO "%s: cannot use LBA48 DMA - PIO mode"
+					 " will be used for accessing sectors "
+					 "> %u\n", drive->name, 1 << 28);
 		} else
 			drive->addressing = 0;
 	}
@@ -837,7 +850,8 @@ static void idedisk_setup (ide_drive_t *drive)
 	 * if possible, give fdisk access to more of the drive,
 	 * by correcting bios_cyls:
 	 */
-	capacity = idedisk_capacity (drive);
+	capacity = idedisk_capacity(drive);
+
 	if (!drive->forced_geom) {
 
 		if (idedisk_supports_lba48(drive->id)) {
@@ -993,7 +1007,8 @@ static int idedisk_open(struct inode *inode, struct file *filp)
 	struct ide_disk_obj *idkp;
 	ide_drive_t *drive;
 
-	if (!(idkp = ide_disk_get(disk)))
+	idkp = ide_disk_get(disk);
+	if (idkp == NULL)
 		return -ENXIO;
 
 	drive = idkp->drive;
@@ -1115,13 +1130,13 @@ static int idedisk_revalidate_disk(struct gendisk *disk)
 }
 
 static struct block_device_operations idedisk_ops = {
-	.owner		= THIS_MODULE,
-	.open		= idedisk_open,
-	.release	= idedisk_release,
-	.ioctl		= idedisk_ioctl,
-	.getgeo		= idedisk_getgeo,
-	.media_changed	= idedisk_media_changed,
-	.revalidate_disk= idedisk_revalidate_disk
+	.owner			= THIS_MODULE,
+	.open			= idedisk_open,
+	.release		= idedisk_release,
+	.ioctl			= idedisk_ioctl,
+	.getgeo			= idedisk_getgeo,
+	.media_changed		= idedisk_media_changed,
+	.revalidate_disk	= idedisk_revalidate_disk
 };
 
 MODULE_DESCRIPTION("ATA DISK Driver");
@@ -1184,7 +1199,7 @@ failed:
 	return -ENODEV;
 }
 
-static void __exit idedisk_exit (void)
+static void __exit idedisk_exit(void)
 {
 	driver_unregister(&idedisk_driver.gen_driver);
 }
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index d61e578..8757e5e 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -703,17 +703,8 @@ static int ide_tune_dma(ide_drive_t *drive)
 
 	speed = ide_max_dma_mode(drive);
 
-	if (!speed) {
-		 /* is this really correct/needed? */
-		if ((hwif->host_flags & IDE_HFLAG_CY82C693) &&
-		    ide_dma_good_drive(drive))
-			return 1;
-		else
-			return 0;
-	}
-
-	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
-		return 1;
+	if (!speed)
+		return 0;
 
 	if (ide_set_dma_mode(drive, speed))
 		return 0;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 5f133df..ed19a8b 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -396,7 +396,7 @@ static void idefloppy_retry_pc(ide_drive_t *drive)
 }
 
 /* The usual interrupt handler called during a packet command. */
-static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
+static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
@@ -1596,13 +1596,13 @@ static int idefloppy_revalidate_disk(struct gendisk *disk)
 }
 
 static struct block_device_operations idefloppy_ops = {
-	.owner		= THIS_MODULE,
-	.open		= idefloppy_open,
-	.release	= idefloppy_release,
-	.ioctl		= idefloppy_ioctl,
-	.getgeo		= idefloppy_getgeo,
-	.media_changed	= idefloppy_media_changed,
-	.revalidate_disk= idefloppy_revalidate_disk
+	.owner			= THIS_MODULE,
+	.open			= idefloppy_open,
+	.release		= idefloppy_release,
+	.ioctl			= idefloppy_ioctl,
+	.getgeo			= idefloppy_getgeo,
+	.media_changed		= idefloppy_media_changed,
+	.revalidate_disk	= idefloppy_revalidate_disk
 };
 
 static int ide_floppy_probe(ide_drive_t *drive)
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 25fda0a..19f63e3 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -33,7 +33,7 @@ static ssize_t store_add(struct class *cls, const char *buf, size_t n)
 	if (sscanf(buf, "%x:%x:%d", &base, &ctl, &irq) != 3)
 		return -EINVAL;
 
-	hwif = ide_find_port(base);
+	hwif = ide_find_port();
 	if (hwif == NULL)
 		return -ENOENT;
 
@@ -90,11 +90,21 @@ static int __init ide_generic_init(void)
 	int i;
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		ide_hwif_t *hwif = &ide_hwifs[i];
+		ide_hwif_t *hwif;
 		unsigned long io_addr = ide_default_io_base(i);
 		hw_regs_t hw;
 
-		if (hwif->chipset == ide_unknown && io_addr) {
+		if (io_addr) {
+			/*
+			 * Skip probing if the corresponding
+			 * slot is already occupied.
+			 */
+			hwif = ide_find_port();
+			if (hwif == NULL || hwif->index != i) {
+				idx[i] = 0xff;
+				continue;
+			}
+
 			memset(&hw, 0, sizeof(hw));
 			ide_std_init_ports(&hw, io_addr, io_addr + 0x206);
 			hw.irq = ide_default_irq(io_addr);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 31e5afa..51d181e 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -726,10 +726,6 @@ static ide_startstop_t do_special (ide_drive_t *drive)
 		s->b.set_tune = 0;
 
 		if (set_pio_mode_abuse(drive->hwif, req_pio)) {
-
-			if (hwif->set_pio_mode == NULL)
-				return ide_stopped;
-
 			/*
 			 * take ide_lock for drive->[no_]unmask/[no_]io_32bit
 			 */
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 7031a8d..c859de7 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -274,16 +274,6 @@ u8 ide_get_best_pio_mode (ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 		if (overridden)
 			printk(KERN_INFO "%s: tPIO > 2, assuming tPIO = 2\n",
 					 drive->name);
-
-		/*
-		 * Conservative "downgrade" for all pre-ATA2 drives
-		 */
-		if ((drive->hwif->host_flags & IDE_HFLAG_PIO_NO_DOWNGRADE) == 0 &&
-		    pio_mode && pio_mode < 4) {
-			pio_mode--;
-			printk(KERN_INFO "%s: applying conservative "
-					 "PIO \"downgrade\"\n", drive->name);
-		}
 	}
 
 	if (pio_mode > max_mode)
@@ -300,7 +290,8 @@ void ide_set_pio(ide_drive_t *drive, u8 req_pio)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 host_pio, pio;
 
-	if (hwif->set_pio_mode == NULL)
+	if (hwif->set_pio_mode == NULL ||
+	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
 		return;
 
 	BUG_ON(hwif->pio_mask == 0x00);
@@ -353,6 +344,9 @@ int ide_set_pio_mode(ide_drive_t *drive, const u8 mode)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
+	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
+		return 0;
+
 	if (hwif->set_pio_mode == NULL)
 		return -1;
 
@@ -380,6 +374,9 @@ int ide_set_dma_mode(ide_drive_t *drive, const u8 mode)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
+	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
+		return 0;
+
 	if (hwif->set_dma_mode == NULL)
 		return -1;
 
@@ -410,7 +407,8 @@ int ide_set_xfer_rate(ide_drive_t *drive, u8 rate)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if (hwif->set_dma_mode == NULL)
+	if (hwif->set_dma_mode == NULL ||
+	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
 		return -1;
 
 	rate = ide_rate_filter(drive, rate);
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index 34c2ad3..8a178a5 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -11,7 +11,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * (for example /usr/src/linux/COPYING); if not, write to the Free
- * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  
+ * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/init.h>
@@ -20,12 +20,12 @@
 
 /* Add your devices here :)) */
 static struct pnp_device_id idepnp_devices[] = {
-  	/* Generic ESDI/IDE/ATA compatible hard disk controller */
+	/* Generic ESDI/IDE/ATA compatible hard disk controller */
 	{.id = "PNP0600", .driver_data = 0},
 	{.id = ""}
 };
 
-static int idepnp_probe(struct pnp_dev * dev, const struct pnp_device_id *dev_id)
+static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
 	hw_regs_t hw;
 	ide_hwif_t *hwif;
@@ -38,7 +38,7 @@ static int idepnp_probe(struct pnp_dev * dev, const struct pnp_device_id *dev_id
 				pnp_port_start(dev, 1));
 	hw.irq = pnp_irq(dev, 0);
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif) {
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
@@ -47,7 +47,7 @@ static int idepnp_probe(struct pnp_dev * dev, const struct pnp_device_id *dev_id
 		ide_init_port_hw(hwif, &hw);
 
 		printk(KERN_INFO "ide%d: generic PnP IDE interface\n", index);
-		pnp_set_drvdata(dev,hwif);
+		pnp_set_drvdata(dev, hwif);
 
 		ide_device_add(idx, NULL);
 
@@ -57,7 +57,7 @@ static int idepnp_probe(struct pnp_dev * dev, const struct pnp_device_id *dev_id
 	return -1;
 }
 
-static void idepnp_remove(struct pnp_dev * dev)
+static void idepnp_remove(struct pnp_dev *dev)
 {
 	ide_hwif_t *hwif = pnp_get_drvdata(dev);
 
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 6a196c2..8754297 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1444,6 +1444,54 @@ static int ide_sysfs_register_port(ide_hwif_t *hwif)
 	return rc;
 }
 
+/**
+ *	ide_find_port_slot	-	find free ide_hwifs[] slot
+ *	@d: IDE port info
+ *
+ *	Return the new hwif.  If we are out of free slots return NULL.
+ */
+
+ide_hwif_t *ide_find_port_slot(const struct ide_port_info *d)
+{
+	ide_hwif_t *hwif;
+	int i;
+	u8 bootable = (d && (d->host_flags & IDE_HFLAG_NON_BOOTABLE)) ? 0 : 1;
+
+	/*
+	 * Claim an unassigned slot.
+	 *
+	 * Give preference to claiming other slots before claiming ide0/ide1,
+	 * just in case there's another interface yet-to-be-scanned
+	 * which uses ports 0x1f0/0x170 (the ide0/ide1 defaults).
+	 *
+	 * Unless there is a bootable card that does not use the standard
+	 * ports 0x1f0/0x170 (the ide0/ide1 defaults).
+	 */
+	if (bootable) {
+		i = (d && (d->host_flags & IDE_HFLAG_QD_2ND_PORT)) ? 1 : 0;
+
+		for (; i < MAX_HWIFS; i++) {
+			hwif = &ide_hwifs[i];
+			if (hwif->chipset == ide_unknown)
+				return hwif;
+		}
+	} else {
+		for (i = 2; i < MAX_HWIFS; i++) {
+			hwif = &ide_hwifs[i];
+			if (hwif->chipset == ide_unknown)
+				return hwif;
+		}
+		for (i = 0; i < 2 && i < MAX_HWIFS; i++) {
+			hwif = &ide_hwifs[i];
+			if (hwif->chipset == ide_unknown)
+				return hwif;
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(ide_find_port_slot);
+
 int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 {
 	ide_hwif_t *hwif, *mate = NULL;
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index edd7f18..5d3562b 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -47,28 +47,28 @@ static int proc_ide_read_imodel
 	const char	*name;
 
 	switch (hwif->chipset) {
-		case ide_generic:	name = "generic";	break;
-		case ide_pci:		name = "pci";		break;
-		case ide_cmd640:	name = "cmd640";	break;
-		case ide_dtc2278:	name = "dtc2278";	break;
-		case ide_ali14xx:	name = "ali14xx";	break;
-		case ide_qd65xx:	name = "qd65xx";	break;
-		case ide_umc8672:	name = "umc8672";	break;
-		case ide_ht6560b:	name = "ht6560b";	break;
-		case ide_rz1000:	name = "rz1000";	break;
-		case ide_trm290:	name = "trm290";	break;
-		case ide_cmd646:	name = "cmd646";	break;
-		case ide_cy82c693:	name = "cy82c693";	break;
-		case ide_4drives:	name = "4drives";	break;
-		case ide_pmac:		name = "mac-io";	break;
-		case ide_au1xxx:	name = "au1xxx";	break;
-		case ide_palm3710:      name = "palm3710";      break;
-		case ide_etrax100:	name = "etrax100";	break;
-		case ide_acorn:		name = "acorn";		break;
-		default:		name = "(unknown)";	break;
+	case ide_generic:	name = "generic";	break;
+	case ide_pci:		name = "pci";		break;
+	case ide_cmd640:	name = "cmd640";	break;
+	case ide_dtc2278:	name = "dtc2278";	break;
+	case ide_ali14xx:	name = "ali14xx";	break;
+	case ide_qd65xx:	name = "qd65xx";	break;
+	case ide_umc8672:	name = "umc8672";	break;
+	case ide_ht6560b:	name = "ht6560b";	break;
+	case ide_rz1000:	name = "rz1000";	break;
+	case ide_trm290:	name = "trm290";	break;
+	case ide_cmd646:	name = "cmd646";	break;
+	case ide_cy82c693:	name = "cy82c693";	break;
+	case ide_4drives:	name = "4drives";	break;
+	case ide_pmac:		name = "mac-io";	break;
+	case ide_au1xxx:	name = "au1xxx";	break;
+	case ide_palm3710:      name = "palm3710";      break;
+	case ide_etrax100:	name = "etrax100";	break;
+	case ide_acorn:		name = "acorn";		break;
+	default:		name = "(unknown)";	break;
 	}
 	len = sprintf(page, "%s\n", name);
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static int proc_ide_read_mate
@@ -81,7 +81,7 @@ static int proc_ide_read_mate
 		len = sprintf(page, "%s\n", hwif->mate->name);
 	else
 		len = sprintf(page, "(none)\n");
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static int proc_ide_read_channel
@@ -93,7 +93,7 @@ static int proc_ide_read_channel
 	page[0] = hwif->channel ? '1' : '0';
 	page[1] = '\n';
 	len = 2;
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static int proc_ide_read_identify
@@ -120,7 +120,7 @@ static int proc_ide_read_identify
 			len = out - page;
 		}
 	}
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 /**
@@ -197,7 +197,7 @@ EXPORT_SYMBOL(ide_add_setting);
  *	The caller must hold the setting semaphore.
  */
 
-static void __ide_remove_setting (ide_drive_t *drive, char *name)
+static void __ide_remove_setting(ide_drive_t *drive, char *name)
 {
 	ide_settings_t **p, *setting;
 
@@ -205,7 +205,8 @@ static void __ide_remove_setting (ide_drive_t *drive, char *name)
 
 	while ((*p) && strcmp((*p)->name, name))
 		p = &((*p)->next);
-	if ((setting = (*p)) == NULL)
+	setting = (*p);
+	if (setting == NULL)
 		return;
 
 	(*p) = setting->next;
@@ -223,7 +224,7 @@ static void __ide_remove_setting (ide_drive_t *drive, char *name)
  *	caller must hold ide_setting_mtx.
  */
 
-static void auto_remove_settings (ide_drive_t *drive)
+static void auto_remove_settings(ide_drive_t *drive)
 {
 	ide_settings_t *setting;
 repeat:
@@ -279,16 +280,16 @@ static int ide_read_setting(ide_drive_t *drive, ide_settings_t *setting)
 
 	if ((setting->rw & SETTING_READ)) {
 		spin_lock_irqsave(&ide_lock, flags);
-		switch(setting->data_type) {
-			case TYPE_BYTE:
-				val = *((u8 *) setting->data);
-				break;
-			case TYPE_SHORT:
-				val = *((u16 *) setting->data);
-				break;
-			case TYPE_INT:
-				val = *((u32 *) setting->data);
-				break;
+		switch (setting->data_type) {
+		case TYPE_BYTE:
+			val = *((u8 *) setting->data);
+			break;
+		case TYPE_SHORT:
+			val = *((u16 *) setting->data);
+			break;
+		case TYPE_INT:
+			val = *((u32 *) setting->data);
+			break;
 		}
 		spin_unlock_irqrestore(&ide_lock, flags);
 	}
@@ -326,15 +327,15 @@ static int ide_write_setting(ide_drive_t *drive, ide_settings_t *setting, int va
 	if (ide_spin_wait_hwgroup(drive))
 		return -EBUSY;
 	switch (setting->data_type) {
-		case TYPE_BYTE:
-			*((u8 *) setting->data) = val;
-			break;
-		case TYPE_SHORT:
-			*((u16 *) setting->data) = val;
-			break;
-		case TYPE_INT:
-			*((u32 *) setting->data) = val;
-			break;
+	case TYPE_BYTE:
+		*((u8 *) setting->data) = val;
+		break;
+	case TYPE_SHORT:
+		*((u16 *) setting->data) = val;
+		break;
+	case TYPE_INT:
+		*((u32 *) setting->data) = val;
+		break;
 	}
 	spin_unlock_irq(&ide_lock);
 	return 0;
@@ -390,7 +391,7 @@ void ide_add_generic_settings (ide_drive_t *drive)
 
 static void proc_ide_settings_warn(void)
 {
-	static int warned = 0;
+	static int warned;
 
 	if (warned)
 		return;
@@ -413,11 +414,12 @@ static int proc_ide_read_settings
 	mutex_lock(&ide_setting_mtx);
 	out += sprintf(out, "name\t\t\tvalue\t\tmin\t\tmax\t\tmode\n");
 	out += sprintf(out, "----\t\t\t-----\t\t---\t\t---\t\t----\n");
-	while(setting) {
+	while (setting) {
 		mul_factor = setting->mul_factor;
 		div_factor = setting->div_factor;
 		out += sprintf(out, "%-24s", setting->name);
-		if ((rc = ide_read_setting(drive, setting)) >= 0)
+		rc = ide_read_setting(drive, setting);
+		if (rc >= 0)
 			out += sprintf(out, "%-16d", rc * mul_factor / div_factor);
 		else
 			out += sprintf(out, "%-16s", "write-only");
@@ -431,7 +433,7 @@ static int proc_ide_read_settings
 	}
 	len = out - page;
 	mutex_unlock(&ide_setting_mtx);
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 #define MAX_LEN	30
@@ -512,8 +514,7 @@ static int proc_ide_write_settings(struct file *file, const char __user *buffer,
 
 			mutex_lock(&ide_setting_mtx);
 			setting = ide_find_setting_by_name(drive, name);
-			if (!setting)
-			{
+			if (!setting) {
 				mutex_unlock(&ide_setting_mtx);
 				goto parse_error;
 			}
@@ -533,8 +534,8 @@ parse_error:
 int proc_ide_read_capacity
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
-	int len = sprintf(page,"%llu\n", (long long)0x7fffffff);
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	int len = sprintf(page, "%llu\n", (long long)0x7fffffff);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 EXPORT_SYMBOL_GPL(proc_ide_read_capacity);
@@ -546,13 +547,13 @@ int proc_ide_read_geometry
 	char		*out = page;
 	int		len;
 
-	out += sprintf(out,"physical     %d/%d/%d\n",
+	out += sprintf(out, "physical     %d/%d/%d\n",
 			drive->cyl, drive->head, drive->sect);
-	out += sprintf(out,"logical      %d/%d/%d\n",
+	out += sprintf(out, "logical      %d/%d/%d\n",
 			drive->bios_cyl, drive->bios_head, drive->bios_sect);
 
 	len = out - page;
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 EXPORT_SYMBOL(proc_ide_read_geometry);
@@ -566,7 +567,7 @@ static int proc_ide_read_dmodel
 
 	len = sprintf(page, "%.40s\n",
 		(id && id->model[0]) ? (char *)id->model : "(none)");
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static int proc_ide_read_driver
@@ -583,7 +584,7 @@ static int proc_ide_read_driver
 				dev->driver->name, ide_drv->version);
 	} else
 		len = sprintf(page, "ide-default version 0.9.newide\n");
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static int ide_replace_subdriver(ide_drive_t *drive, const char *driver)
@@ -639,30 +640,26 @@ static int proc_ide_read_media
 	int		len;
 
 	switch (drive->media) {
-		case ide_disk:	media = "disk\n";
-				break;
-		case ide_cdrom:	media = "cdrom\n";
-				break;
-		case ide_tape:	media = "tape\n";
-				break;
-		case ide_floppy:media = "floppy\n";
-				break;
-		case ide_optical:media = "optical\n";
-				break;
-		default:	media = "UNKNOWN\n";
-				break;
+	case ide_disk:		media = "disk\n";	break;
+	case ide_cdrom:		media = "cdrom\n";	break;
+	case ide_tape:		media = "tape\n";	break;
+	case ide_floppy:	media = "floppy\n";	break;
+	case ide_optical:	media = "optical\n";	break;
+	default:		media = "UNKNOWN\n";	break;
 	}
-	strcpy(page,media);
+	strcpy(page, media);
 	len = strlen(media);
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static ide_proc_entry_t generic_drive_entries[] = {
-	{ "driver",	S_IFREG|S_IRUGO,	proc_ide_read_driver,	proc_ide_write_driver },
-	{ "identify",	S_IFREG|S_IRUSR,	proc_ide_read_identify,	NULL },
-	{ "media",	S_IFREG|S_IRUGO,	proc_ide_read_media,	NULL },
-	{ "model",	S_IFREG|S_IRUGO,	proc_ide_read_dmodel,	NULL },
-	{ "settings",	S_IFREG|S_IRUSR|S_IWUSR,proc_ide_read_settings,	proc_ide_write_settings },
+	{ "driver",	S_IFREG|S_IRUGO,	 proc_ide_read_driver,
+						 proc_ide_write_driver },
+	{ "identify",	S_IFREG|S_IRUSR,	 proc_ide_read_identify, NULL },
+	{ "media",	S_IFREG|S_IRUGO,	 proc_ide_read_media,    NULL },
+	{ "model",	S_IFREG|S_IRUGO,	 proc_ide_read_dmodel,   NULL },
+	{ "settings",	S_IFREG|S_IRUSR|S_IWUSR, proc_ide_read_settings,
+						 proc_ide_write_settings },
 	{ NULL,	0, NULL, NULL }
 };
 
@@ -734,7 +731,6 @@ void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver)
 	spin_unlock_irqrestore(&ide_lock, flags);
 	mutex_unlock(&ide_setting_mtx);
 }
-
 EXPORT_SYMBOL(ide_proc_unregister_driver);
 
 void ide_proc_port_register_devices(ide_hwif_t *hwif)
@@ -755,7 +751,7 @@ void ide_proc_port_register_devices(ide_hwif_t *hwif)
 		drive->proc = proc_mkdir(drive->name, parent);
 		if (drive->proc)
 			ide_add_proc_entries(drive->proc, generic_drive_entries, drive);
-		sprintf(name,"ide%d/%s", (drive->name[2]-'a')/2, drive->name);
+		sprintf(name, "ide%d/%s", (drive->name[2]-'a')/2, drive->name);
 		ent = proc_symlink(drive->name, proc_ide_root, name);
 		if (!ent) return;
 	}
@@ -795,7 +791,6 @@ void ide_pci_create_host_proc(const char *name, get_info_t *get_info)
 {
 	create_proc_info_entry(name, 0, proc_ide_root, get_info);
 }
-
 EXPORT_SYMBOL_GPL(ide_pci_create_host_proc);
 #endif
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 917c72d..d868ca4 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -100,13 +100,8 @@ int ide_noacpitfs = 1;
 int ide_noacpionboot = 1;
 #endif
 
-/*
- * This is declared extern in ide.h, for access by other IDE modules:
- */
 ide_hwif_t ide_hwifs[MAX_HWIFS];	/* master data repository */
 
-EXPORT_SYMBOL(ide_hwifs);
-
 static void ide_port_init_devices_data(ide_hwif_t *);
 
 /*
@@ -232,30 +227,6 @@ static int ide_system_bus_speed(void)
 	return pci_dev_present(pci_default) ? 33 : 50;
 }
 
-ide_hwif_t * ide_find_port(unsigned long base)
-{
-	ide_hwif_t *hwif;
-	int i;
-
-	for (i = 0; i < MAX_HWIFS; i++) {
-		hwif = &ide_hwifs[i];
-		if (hwif->io_ports[IDE_DATA_OFFSET] == base)
-			goto found;
-	}
-
-	for (i = 0; i < MAX_HWIFS; i++) {
-		hwif = &ide_hwifs[i];
-		if (hwif->chipset == ide_unknown)
-			goto found;
-	}
-
-	hwif = NULL;
-found:
-	return hwif;
-}
-
-EXPORT_SYMBOL_GPL(ide_find_port);
-
 static struct resource* hwif_request_region(ide_hwif_t *hwif,
 					    unsigned long addr, int num)
 {
@@ -280,29 +251,21 @@ static struct resource* hwif_request_region(ide_hwif_t *hwif,
 int ide_hwif_request_regions(ide_hwif_t *hwif)
 {
 	unsigned long addr;
-	unsigned int i;
 
 	if (hwif->mmio)
 		return 0;
+
 	addr = hwif->io_ports[IDE_CONTROL_OFFSET];
+
 	if (addr && !hwif_request_region(hwif, addr, 1))
 		goto control_region_busy;
-	hwif->straight8 = 0;
+
 	addr = hwif->io_ports[IDE_DATA_OFFSET];
-	if ((addr | 7) == hwif->io_ports[IDE_STATUS_OFFSET]) {
-		if (!hwif_request_region(hwif, addr, 8))
-			goto data_region_busy;
-		hwif->straight8 = 1;
-		return 0;
-	}
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-		addr = hwif->io_ports[i];
-		if (!hwif_request_region(hwif, addr, 1)) {
-			while (--i)
-				release_region(addr, 1);
-			goto data_region_busy;
-		}
-	}
+	BUG_ON((addr | 7) != hwif->io_ports[IDE_STATUS_OFFSET]);
+
+	if (!hwif_request_region(hwif, addr, 8))
+		goto data_region_busy;
+
 	return 0;
 
 data_region_busy:
@@ -328,19 +291,13 @@ control_region_busy:
 
 void ide_hwif_release_regions(ide_hwif_t *hwif)
 {
-	u32 i = 0;
-
 	if (hwif->mmio)
 		return;
+
 	if (hwif->io_ports[IDE_CONTROL_OFFSET])
 		release_region(hwif->io_ports[IDE_CONTROL_OFFSET], 1);
-	if (hwif->straight8) {
-		release_region(hwif->io_ports[IDE_DATA_OFFSET], 8);
-		return;
-	}
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
-		if (hwif->io_ports[i])
-			release_region(hwif->io_ports[i], 1);
+
+	release_region(hwif->io_ports[IDE_DATA_OFFSET], 8);
 }
 
 void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
@@ -627,11 +584,13 @@ out:
 int set_pio_mode(ide_drive_t *drive, int arg)
 {
 	struct request rq;
+	ide_hwif_t *hwif = drive->hwif;
 
 	if (arg < 0 || arg > 255)
 		return -EINVAL;
 
-	if (drive->hwif->set_pio_mode == NULL)
+	if (hwif->set_pio_mode == NULL ||
+	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
 		return -ENOSYS;
 
 	if (drive->special.b.set_tune)
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index bc8b1f8..33bb7b8 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -86,7 +86,7 @@ static u8 regOff;	/* output to base port to close registers */
 /*
  * Read a controller register.
  */
-static inline u8 inReg (u8 reg)
+static inline u8 inReg(u8 reg)
 {
 	outb_p(reg, regPort);
 	return inb(dataPort);
@@ -95,7 +95,7 @@ static inline u8 inReg (u8 reg)
 /*
  * Write a controller register.
  */
-static void outReg (u8 data, u8 reg)
+static void outReg(u8 data, u8 reg)
 {
 	outb_p(reg, regPort);
 	outb_p(data, dataPort);
@@ -143,7 +143,7 @@ static void ali14xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 /*
  * Auto-detect the IDE controller port.
  */
-static int __init findPort (void)
+static int __init findPort(void)
 {
 	int i;
 	u8 t;
@@ -175,7 +175,8 @@ static int __init findPort (void)
 /*
  * Initialize controller registers with default values.
  */
-static int __init initRegisters (void) {
+static int __init initRegisters(void)
+{
 	const RegInitializer *p;
 	u8 t;
 	unsigned long flags;
@@ -199,7 +200,8 @@ static const struct ide_port_info ali14xx_port_info = {
 
 static int __init ali14xx_probe(void)
 {
-	static u8 idx[4] = { 0, 1, 0xff, 0xff };
+	ide_hwif_t *hwif, *mate;
+	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw[2];
 
 	printk(KERN_DEBUG "ali14xx: base=0x%03x, regOn=0x%02x.\n",
@@ -219,18 +221,26 @@ static int __init ali14xx_probe(void)
 	ide_std_init_ports(&hw[1], 0x170, 0x376);
 	hw[1].irq = 15;
 
-	ide_init_port_hw(&ide_hwifs[0], &hw[0]);
-	ide_init_port_hw(&ide_hwifs[1], &hw[1]);
+	hwif = ide_find_port();
+	if (hwif) {
+		ide_init_port_hw(hwif, &hw[0]);
+		hwif->set_pio_mode = &ali14xx_set_pio_mode;
+		idx[0] = hwif->index;
+	}
 
-	ide_hwifs[0].set_pio_mode = &ali14xx_set_pio_mode;
-	ide_hwifs[1].set_pio_mode = &ali14xx_set_pio_mode;
+	mate = ide_find_port();
+	if (mate) {
+		ide_init_port_hw(mate, &hw[1]);
+		mate->set_pio_mode = &ali14xx_set_pio_mode;
+		idx[1] = mate->index;
+	}
 
 	ide_device_add(idx, &ali14xx_port_info);
 
 	return 0;
 }
 
-int probe_ali14xx = 0;
+int probe_ali14xx;
 
 module_param_named(probe, probe_ali14xx, bool, 0);
 MODULE_PARM_DESC(probe, "probe for ALI M14xx chipsets");
diff --git a/drivers/ide/legacy/buddha.c b/drivers/ide/legacy/buddha.c
index fdd3791..6956eb8 100644
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -221,7 +221,7 @@ fail_base2:
 
 			buddha_setup_ports(&hw, base, ctl, irq_port, ack_intr);
 
-			hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+			hwif = ide_find_port();
 			if (hwif) {
 				u8 index = hwif->index;
 
diff --git a/drivers/ide/legacy/dtc2278.c b/drivers/ide/legacy/dtc2278.c
index 5f69cd2..9c6b324 100644
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -102,15 +102,9 @@ static int __init dtc2278_probe(void)
 {
 	unsigned long flags;
 	ide_hwif_t *hwif, *mate;
-	static u8 idx[4] = { 0, 1, 0xff, 0xff };
+	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw[2];
 
-	hwif = &ide_hwifs[0];
-	mate = &ide_hwifs[1];
-
-	if (hwif->chipset != ide_unknown || mate->chipset != ide_unknown)
-		return 1;
-
 	local_irq_save(flags);
 	/*
 	 * This enables the second interface
@@ -137,10 +131,18 @@ static int __init dtc2278_probe(void)
 	ide_std_init_ports(&hw[1], 0x170, 0x376);
 	hw[1].irq = 15;
 
-	ide_init_port_hw(hwif, &hw[0]);
-	ide_init_port_hw(mate, &hw[1]);
+	hwif = ide_find_port();
+	if (hwif) {
+		ide_init_port_hw(hwif, &hw[0]);
+		hwif->set_pio_mode = dtc2278_set_pio_mode;
+		idx[0] = hwif->index;
+	}
 
-	hwif->set_pio_mode = &dtc2278_set_pio_mode;
+	mate = ide_find_port();
+	if (mate) {
+		ide_init_port_hw(mate, &hw[1]);
+		idx[1] = mate->index;
+	}
 
 	ide_device_add(idx, &dtc2278_port_info);
 
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index e950afa..8c9c9f7 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -22,6 +22,7 @@
 #include <asm/atariints.h>
 #include <asm/atari_stdma.h>
 
+#define DRV_NAME "falconide"
 
     /*
      *  Base of the IDE interface
@@ -74,15 +75,21 @@ static int __init falconide_init(void)
 
 	printk(KERN_INFO "ide: Falcon IDE controller\n");
 
+	if (!request_mem_region(ATA_HD_BASE, 0x40, DRV_NAME)) {
+		printk(KERN_ERR "%s: resources busy\n", DRV_NAME);
+		return -EBUSY;
+	}
+
 	falconide_setup_ports(&hw);
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif) {
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
 
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
+		hwif->mmio = 1;
 
 		ide_get_lock(NULL, NULL);
 		ide_device_add(idx, NULL);
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index e3b4638..fcc8d52 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -175,7 +175,7 @@ found:
 
 	gayle_setup_ports(&hw, base, ctrlport, irqport, ack_intr);
 
-	hwif = ide_find_port(base);
+	hwif = ide_find_port();
 	if (hwif) {
 	    u8 index = hwif->index;
 
diff --git a/drivers/ide/legacy/hd.c b/drivers/ide/legacy/hd.c
index 0b0d867..abdedf5 100644
--- a/drivers/ide/legacy/hd.c
+++ b/drivers/ide/legacy/hd.c
@@ -122,12 +122,12 @@ static int hd_error;
  *  This struct defines the HD's and their types.
  */
 struct hd_i_struct {
-	unsigned int head,sect,cyl,wpcom,lzone,ctl;
+	unsigned int head, sect, cyl, wpcom, lzone, ctl;
 	int unit;
 	int recalibrate;
 	int special_op;
 };
-	
+
 #ifdef HD_TYPE
 static struct hd_i_struct hd_info[] = { HD_TYPE };
 static int NR_HD = ARRAY_SIZE(hd_info);
@@ -168,7 +168,7 @@ unsigned long read_timer(void)
 
 	spin_lock_irqsave(&i8253_lock, flags);
 	t = jiffies * 11932;
-    	outb_p(0, 0x43);
+	outb_p(0, 0x43);
 	i = inb_p(0x40);
 	i |= inb(0x40) << 8;
 	spin_unlock_irqrestore(&i8253_lock, flags);
@@ -183,7 +183,7 @@ static void __init hd_setup(char *str, int *ints)
 	if (ints[0] != 3)
 		return;
 	if (hd_info[0].head != 0)
-		hdind=1;
+		hdind = 1;
 	hd_info[hdind].head = ints[2];
 	hd_info[hdind].sect = ints[3];
 	hd_info[hdind].cyl = ints[1];
@@ -193,7 +193,7 @@ static void __init hd_setup(char *str, int *ints)
 	NR_HD = hdind+1;
 }
 
-static void dump_status (const char *msg, unsigned int stat)
+static void dump_status(const char *msg, unsigned int stat)
 {
 	char *name = "hd?";
 	if (CURRENT)
@@ -291,7 +291,6 @@ static int controller_ready(unsigned int drive, unsigned int head)
 	return 0;
 }
 
-		
 static void hd_out(struct hd_i_struct *disk,
 		   unsigned int nsect,
 		   unsigned int sect,
@@ -313,15 +312,15 @@ static void hd_out(struct hd_i_struct *disk,
 		return;
 	}
 	SET_HANDLER(intr_addr);
-	outb_p(disk->ctl,HD_CMD);
-	port=HD_DATA;
-	outb_p(disk->wpcom>>2,++port);
-	outb_p(nsect,++port);
-	outb_p(sect,++port);
-	outb_p(cyl,++port);
-	outb_p(cyl>>8,++port);
-	outb_p(0xA0|(disk->unit<<4)|head,++port);
-	outb_p(cmd,++port);
+	outb_p(disk->ctl, HD_CMD);
+	port = HD_DATA;
+	outb_p(disk->wpcom >> 2, ++port);
+	outb_p(nsect, ++port);
+	outb_p(sect, ++port);
+	outb_p(cyl, ++port);
+	outb_p(cyl >> 8, ++port);
+	outb_p(0xA0 | (disk->unit << 4) | head, ++port);
+	outb_p(cmd, ++port);
 }
 
 static void hd_request (void);
@@ -344,14 +343,14 @@ static void reset_controller(void)
 {
 	int	i;
 
-	outb_p(4,HD_CMD);
-	for(i = 0; i < 1000; i++) barrier();
-	outb_p(hd_info[0].ctl & 0x0f,HD_CMD);
-	for(i = 0; i < 1000; i++) barrier();
+	outb_p(4, HD_CMD);
+	for (i = 0; i < 1000; i++) barrier();
+	outb_p(hd_info[0].ctl & 0x0f, HD_CMD);
+	for (i = 0; i < 1000; i++) barrier();
 	if (drive_busy())
 		printk("hd: controller still busy\n");
 	else if ((hd_error = inb(HD_ERROR)) != 1)
-		printk("hd: controller reset failed: %02x\n",hd_error);
+		printk("hd: controller reset failed: %02x\n", hd_error);
 }
 
 static void reset_hd(void)
@@ -371,8 +370,8 @@ repeat:
 	if (++i < NR_HD) {
 		struct hd_i_struct *disk = &hd_info[i];
 		disk->special_op = disk->recalibrate = 1;
-		hd_out(disk,disk->sect,disk->sect,disk->head-1,
-			disk->cyl,WIN_SPECIFY,&reset_hd);
+		hd_out(disk, disk->sect, disk->sect, disk->head-1,
+			disk->cyl, WIN_SPECIFY, &reset_hd);
 		if (reset)
 			goto repeat;
 	} else
@@ -393,7 +392,7 @@ static void unexpected_hd_interrupt(void)
 	unsigned int stat = inb_p(HD_STATUS);
 
 	if (stat & (BUSY_STAT|DRQ_STAT|ECC_STAT|ERR_STAT)) {
-		dump_status ("unexpected interrupt", stat);
+		dump_status("unexpected interrupt", stat);
 		SET_TIMER;
 	}
 }
@@ -453,7 +452,7 @@ static void read_intr(void)
 	return;
 ok_to_read:
 	req = CURRENT;
-	insw(HD_DATA,req->buffer,256);
+	insw(HD_DATA, req->buffer, 256);
 	req->sector++;
 	req->buffer += 512;
 	req->errors = 0;
@@ -507,7 +506,7 @@ ok_to_write:
 		end_request(req, 1);
 	if (i > 0) {
 		SET_HANDLER(&write_intr);
-		outsw(HD_DATA,req->buffer,256);
+		outsw(HD_DATA, req->buffer, 256);
 		local_irq_enable();
 	} else {
 #if (HD_DELAY > 0)
@@ -560,11 +559,11 @@ static int do_special_op(struct hd_i_struct *disk, struct request *req)
 {
 	if (disk->recalibrate) {
 		disk->recalibrate = 0;
-		hd_out(disk,disk->sect,0,0,0,WIN_RESTORE,&recal_intr);
+		hd_out(disk, disk->sect, 0, 0, 0, WIN_RESTORE, &recal_intr);
 		return reset;
 	}
 	if (disk->head > 16) {
-		printk ("%s: cannot handle device with more than 16 heads - giving up\n", req->rq_disk->disk_name);
+		printk("%s: cannot handle device with more than 16 heads - giving up\n", req->rq_disk->disk_name);
 		end_request(req, 0);
 	}
 	disk->special_op = 0;
@@ -633,19 +632,21 @@ repeat:
 	if (blk_fs_request(req)) {
 		switch (rq_data_dir(req)) {
 		case READ:
-			hd_out(disk,nsect,sec,head,cyl,WIN_READ,&read_intr);
+			hd_out(disk, nsect, sec, head, cyl, WIN_READ,
+				&read_intr);
 			if (reset)
 				goto repeat;
 			break;
 		case WRITE:
-			hd_out(disk,nsect,sec,head,cyl,WIN_WRITE,&write_intr);
+			hd_out(disk, nsect, sec, head, cyl, WIN_WRITE,
+				&write_intr);
 			if (reset)
 				goto repeat;
 			if (wait_DRQ()) {
 				bad_rw_intr();
 				goto repeat;
 			}
-			outsw(HD_DATA,req->buffer,256);
+			outsw(HD_DATA, req->buffer, 256);
 			break;
 		default:
 			printk("unknown hd-command\n");
@@ -655,7 +656,7 @@ repeat:
 	}
 }
 
-static void do_hd_request (struct request_queue * q)
+static void do_hd_request(struct request_queue *q)
 {
 	disable_irq(HD_IRQ);
 	hd_request();
@@ -708,12 +709,12 @@ static int __init hd_init(void)
 {
 	int drive;
 
-	if (register_blkdev(MAJOR_NR,"hd"))
+	if (register_blkdev(MAJOR_NR, "hd"))
 		return -1;
 
 	hd_queue = blk_init_queue(do_hd_request, &hd_lock);
 	if (!hd_queue) {
-		unregister_blkdev(MAJOR_NR,"hd");
+		unregister_blkdev(MAJOR_NR, "hd");
 		return -ENOMEM;
 	}
 
@@ -742,7 +743,7 @@ static int __init hd_init(void)
 		goto out;
 	}
 
-	for (drive=0 ; drive < NR_HD ; drive++) {
+	for (drive = 0 ; drive < NR_HD ; drive++) {
 		struct gendisk *disk = alloc_disk(64);
 		struct hd_i_struct *p = &hd_info[drive];
 		if (!disk)
@@ -756,7 +757,7 @@ static int __init hd_init(void)
 		disk->queue = hd_queue;
 		p->unit = drive;
 		hd_gendisk[drive] = disk;
-		printk ("%s: %luMB, CHS=%d/%d/%d\n",
+		printk("%s: %luMB, CHS=%d/%d/%d\n",
 			disk->disk_name, (unsigned long)get_capacity(disk)/2048,
 			p->cyl, p->head, p->sect);
 	}
@@ -776,7 +777,7 @@ static int __init hd_init(void)
 	}
 
 	/* Let them fly */
-	for(drive=0; drive < NR_HD; drive++)
+	for (drive = 0; drive < NR_HD; drive++)
 		add_disk(hd_gendisk[drive]);
 
 	return 0;
@@ -791,7 +792,7 @@ out1:
 	NR_HD = 0;
 out:
 	del_timer(&device_timer);
-	unregister_blkdev(MAJOR_NR,"hd");
+	unregister_blkdev(MAJOR_NR, "hd");
 	blk_cleanup_queue(hd_queue);
 	return -1;
 Enomem:
@@ -800,7 +801,8 @@ Enomem:
 	goto out;
 }
 
-static int __init parse_hd_setup (char *line) {
+static int __init parse_hd_setup(char *line)
+{
 	int ints[6];
 
 	(void) get_options(line, ARRAY_SIZE(ints), ints);
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index 88fe907..60f52f5 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -35,6 +35,7 @@
  *  Try:  http://www.maf.iki.fi/~maf/ht6560b/
  */
 
+#define DRV_NAME	"ht6560b"
 #define HT6560B_VERSION "v0.08"
 
 #include <linux/module.h>
@@ -339,16 +340,13 @@ static const struct ide_port_info ht6560b_port_info __initdata = {
 static int __init ht6560b_init(void)
 {
 	ide_hwif_t *hwif, *mate;
-	static u8 idx[4] = { 0, 1, 0xff, 0xff };
+	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw[2];
 
 	if (probe_ht6560b == 0)
 		return -ENODEV;
 
-	hwif = &ide_hwifs[0];
-	mate = &ide_hwifs[1];
-
-	if (!request_region(HT_CONFIG_PORT, 1, hwif->name)) {
+	if (!request_region(HT_CONFIG_PORT, 1, DRV_NAME)) {
 		printk(KERN_NOTICE "%s: HT_CONFIG_PORT not found\n",
 			__FUNCTION__);
 		return -ENODEV;
@@ -367,17 +365,23 @@ static int __init ht6560b_init(void)
 	ide_std_init_ports(&hw[1], 0x170, 0x376);
 	hw[1].irq = 15;
 
-	ide_init_port_hw(hwif, &hw[0]);
-	ide_init_port_hw(mate, &hw[1]);
-
-	hwif->selectproc = &ht6560b_selectproc;
-	hwif->set_pio_mode = &ht6560b_set_pio_mode;
-
-	mate->selectproc = &ht6560b_selectproc;
-	mate->set_pio_mode = &ht6560b_set_pio_mode;
+	hwif = ide_find_port();
+	if (hwif) {
+		ide_init_port_hw(hwif, &hw[0]);
+		hwif->selectproc     = ht6560b_selectproc;
+		hwif->set_pio_mode   = ht6560b_set_pio_mode;
+		hwif->port_init_devs = ht6560b_port_init_devs;
+		idx[0] = hwif->index;
+	}
 
-	hwif->port_init_devs = ht6560b_port_init_devs;
-	mate->port_init_devs = ht6560b_port_init_devs;
+	mate = ide_find_port();
+	if (mate) {
+		ide_init_port_hw(mate, &hw[1]);
+		mate->selectproc     = ht6560b_selectproc;
+		mate->set_pio_mode   = ht6560b_set_pio_mode;
+		mate->port_init_devs = ht6560b_port_init_devs;
+		idx[1] = mate->index;
+	}
 
 	ide_device_add(idx, &ht6560b_port_info);
 
diff --git a/drivers/ide/legacy/ide-4drives.c b/drivers/ide/legacy/ide-4drives.c
index ecd7f35..c352f12 100644
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -4,7 +4,7 @@
 #include <linux/module.h>
 #include <linux/ide.h>
 
-int probe_4drives = 0;
+int probe_4drives;
 
 module_param_named(probe, probe_4drives, bool, 0);
 MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
@@ -12,31 +12,37 @@ MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
 static int __init ide_4drives_init(void)
 {
 	ide_hwif_t *hwif, *mate;
-	u8 idx[4] = { 0, 1, 0xff, 0xff };
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw;
 
 	if (probe_4drives == 0)
 		return -ENODEV;
 
-	hwif = &ide_hwifs[0];
-	mate = &ide_hwifs[1];
-
 	memset(&hw, 0, sizeof(hw));
 
 	ide_std_init_ports(&hw, 0x1f0, 0x3f6);
 	hw.irq = 14;
 	hw.chipset = ide_4drives;
 
-	ide_init_port_hw(hwif, &hw);
-	ide_init_port_hw(mate, &hw);
-
-	mate->drives[0].select.all ^= 0x20;
-	mate->drives[1].select.all ^= 0x20;
-
-	hwif->mate = mate;
-	mate->mate = hwif;
-
-	hwif->serialized = mate->serialized = 1;
+	hwif = ide_find_port();
+	if (hwif) {
+		ide_init_port_hw(hwif, &hw);
+		idx[0] = hwif->index;
+	}
+
+	mate = ide_find_port();
+	if (mate) {
+		ide_init_port_hw(mate, &hw);
+		mate->drives[0].select.all ^= 0x20;
+		mate->drives[1].select.all ^= 0x20;
+		idx[1] = mate->index;
+
+		if (hwif) {
+			hwif->mate = mate;
+			mate->mate = hwif;
+			hwif->serialized = mate->serialized = 1;
+		}
+	}
 
 	ide_device_add(idx, NULL);
 
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index 9a23b94..b97b8d5 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -156,7 +156,7 @@ static int idecs_register(unsigned long io, unsigned long ctl, unsigned long irq
     hw.chipset = ide_pci;
     hw.dev = &handle->dev;
 
-    hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+    hwif = ide_find_port();
     if (hwif == NULL)
 	return -1;
 
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
index 361b1bb..bf24077 100644
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -89,7 +89,7 @@ static int __devinit plat_ide_probe(struct platform_device *pdev)
 			res_alt->start, res_alt->end - res_alt->start + 1);
 	}
 
-	hwif = ide_find_port((unsigned long)base);
+	hwif = ide_find_port();
 	if (!hwif) {
 		ret = -ENODEV;
 		goto out;
@@ -100,11 +100,10 @@ static int __devinit plat_ide_probe(struct platform_device *pdev)
 	hw.dev = &pdev->dev;
 
 	ide_init_port_hw(hwif, &hw);
+	hwif->mmio = 1;
 
-	if (mmio) {
-		hwif->mmio = 1;
+	if (mmio)
 		default_hwif_mmiops(hwif);
-	}
 
 	idx[0] = hwif->index;
 
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index eaf5dbe..7429b80 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -120,7 +120,7 @@ static int __init macide_init(void)
 
 	macide_setup_ports(&hw, base, irq, ack_intr);
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif) {
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index 2da2875..fcbff0e 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -137,7 +137,7 @@ static int __init q40ide_init(void)
 //			m68kide_iops,
 			q40ide_default_irq(pcide_bases[i]));
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif) {
 		ide_init_port_data(hwif, hwif->index);
 		ide_init_port_hw(hwif, &hw);
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index 7016bdf..6e820c7 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -88,12 +88,12 @@
 static int timings[4]={-1,-1,-1,-1}; /* stores current timing for each timer */
 
 /*
- * qd_select:
+ * qd65xx_select:
  *
- * This routine is invoked from ide.c to prepare for access to a given drive.
+ * This routine is invoked to prepare for access to a given drive.
  */
 
-static void qd_select (ide_drive_t *drive)
+static void qd65xx_select(ide_drive_t *drive)
 {
 	u8 index = ((	(QD_TIMREG(drive)) & 0x80 ) >> 7) |
 			(QD_TIMREG(drive) & 0x02);
@@ -168,36 +168,15 @@ static int qd_find_disk_type (ide_drive_t *drive,
 }
 
 /*
- * qd_timing_ok:
- *
- * check whether timings don't conflict
- */
-
-static int qd_timing_ok (ide_drive_t drives[])
-{
-	return (IDE_IMPLY(drives[0].present && drives[1].present,
-			IDE_IMPLY(QD_TIMREG(drives) == QD_TIMREG(drives+1),
-			          QD_TIMING(drives) == QD_TIMING(drives+1))));
-	/* if same timing register, must be same timing */
-}
-
-/*
  * qd_set_timing:
  *
- * records the timing, and enables selectproc as needed
+ * records the timing
  */
 
 static void qd_set_timing (ide_drive_t *drive, u8 timing)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-
 	drive->drive_data &= 0xff00;
 	drive->drive_data |= timing;
-	if (qd_timing_ok(hwif->drives)) {
-		qd_select(drive); /* selects once */
-		hwif->selectproc = NULL;
-	} else
-		hwif->selectproc = &qd_select;
 
 	printk(KERN_DEBUG "%s: %#x\n", drive->name, timing);
 }
@@ -225,10 +204,11 @@ static void qd6500_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 static void qd6580_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	int base = HWIF(drive)->select_data;
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned int cycle_time;
 	int active_time   = 175;
 	int recovery_time = 415; /* worst case values from the dos driver */
+	u8 base = (hwif->config_data & 0xff00) >> 8;
 
 	if (drive->id && !qd_find_disk_type(drive, &active_time, &recovery_time)) {
 		cycle_time = ide_pio_cycle_time(drive, pio);
@@ -299,21 +279,10 @@ static int __init qd_testreg(int port)
 	return (readreg != QD_TESTVAL);
 }
 
-/*
- * qd_setup:
- *
- * called to setup an ata channel : adjusts attributes & links for tuning
- */
-
-static void __init qd_setup(ide_hwif_t *hwif, int base, int config)
-{
-	hwif->select_data = base;
-	hwif->config_data = config;
-}
-
 static void __init qd6500_port_init_devs(ide_hwif_t *hwif)
 {
-	u8 base = hwif->select_data, config = QD_CONFIG(hwif);
+	u8 base = (hwif->config_data & 0xff00) >> 8;
+	u8 config = QD_CONFIG(hwif);
 
 	hwif->drives[0].drive_data = QD6500_DEF_DATA;
 	hwif->drives[1].drive_data = QD6500_DEF_DATA;
@@ -322,9 +291,10 @@ static void __init qd6500_port_init_devs(ide_hwif_t *hwif)
 static void __init qd6580_port_init_devs(ide_hwif_t *hwif)
 {
 	u16 t1, t2;
-	u8 base = hwif->select_data, config = QD_CONFIG(hwif);
+	u8 base = (hwif->config_data & 0xff00) >> 8;
+	u8 config = QD_CONFIG(hwif);
 
-	if (QD_CONTROL(hwif) & QD_CONTR_SEC_DISABLED) {
+	if (hwif->host_flags & IDE_HFLAG_SINGLE) {
 		t1 = QD6580_DEF_DATA;
 		t2 = QD6580_DEF_DATA2;
 	} else
@@ -355,14 +325,18 @@ static int __init qd_probe(int base)
 	u8 config, unit;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw[2];
+	struct ide_port_info d = qd65xx_port_info;
 
 	config = inb(QD_CONFIG_PORT);
 
 	if (! ((config & QD_CONFIG_BASEPORT) >> 1 == (base == 0xb0)) )
-		return 1;
+		return -ENODEV;
 
 	unit = ! (config & QD_CONFIG_IDE_BASEPORT);
 
+	if (unit)
+		d.host_flags |= IDE_HFLAG_QD_2ND_PORT;
+
 	memset(&hw, 0, sizeof(hw));
 
 	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
@@ -373,30 +347,37 @@ static int __init qd_probe(int base)
 
 	if ((config & 0xf0) == QD_CONFIG_QD6500) {
 
-		if (qd_testreg(base)) return 1;		/* bad register */
+		if (qd_testreg(base))
+			 return -ENODEV;	/* bad register */
 
 		/* qd6500 found */
 
-		hwif = &ide_hwifs[unit];
-		printk(KERN_NOTICE "%s: qd6500 at %#x\n", hwif->name, base);
-		printk(KERN_DEBUG "qd6500: config=%#x, ID3=%u\n",
-			config, QD_ID3);
-		
 		if (config & QD_CONFIG_DISABLED) {
 			printk(KERN_WARNING "qd6500 is disabled !\n");
-			return 1;
+			return -ENODEV;
 		}
 
+		printk(KERN_NOTICE "qd6500 at %#x\n", base);
+		printk(KERN_DEBUG "qd6500: config=%#x, ID3=%u\n",
+			config, QD_ID3);
+
+		d.host_flags |= IDE_HFLAG_SINGLE;
+
+		hwif = ide_find_port_slot(&d);
+		if (hwif == NULL)
+			return -ENOENT;
+
 		ide_init_port_hw(hwif, &hw[unit]);
 
-		qd_setup(hwif, base, config);
+		hwif->config_data = (base << 8) | config;
 
 		hwif->port_init_devs = qd6500_port_init_devs;
-		hwif->set_pio_mode = &qd6500_set_pio_mode;
+		hwif->set_pio_mode   = qd6500_set_pio_mode;
+		hwif->selectproc     = qd65xx_select;
 
-		idx[unit] = unit;
+		idx[unit] = hwif->index;
 
-		ide_device_add(idx, &qd65xx_port_info);
+		ide_device_add(idx, &d);
 
 		return 1;
 	}
@@ -406,8 +387,8 @@ static int __init qd_probe(int base)
 
 		u8 control;
 
-		if (qd_testreg(base) || qd_testreg(base+0x02)) return 1;
-			/* bad registers */
+		if (qd_testreg(base) || qd_testreg(base + 0x02))
+			return -ENODEV;	/* bad registers */
 
 		/* qd6580 found */
 
@@ -422,46 +403,52 @@ static int __init qd_probe(int base)
 		if (control & QD_CONTR_SEC_DISABLED) {
 			/* secondary disabled */
 
-			hwif = &ide_hwifs[unit];
-			printk(KERN_INFO "%s: qd6580: single IDE board\n",
-					 hwif->name);
+			printk(KERN_INFO "qd6580: single IDE board\n");
+
+			d.host_flags |= IDE_HFLAG_SINGLE;
+
+			hwif = ide_find_port_slot(&d);
+			if (hwif == NULL)
+				return -ENOENT;
 
 			ide_init_port_hw(hwif, &hw[unit]);
 
-			qd_setup(hwif, base, config | (control << 8));
+			hwif->config_data = (base << 8) | config;
 
 			hwif->port_init_devs = qd6580_port_init_devs;
-			hwif->set_pio_mode = &qd6580_set_pio_mode;
+			hwif->set_pio_mode   = qd6580_set_pio_mode;
+			hwif->selectproc     = qd65xx_select;
 
-			idx[unit] = unit;
+			idx[unit] = hwif->index;
 
-			ide_device_add(idx, &qd65xx_port_info);
+			ide_device_add(idx, &d);
 
 			return 1;
 		} else {
 			ide_hwif_t *mate;
 
-			hwif = &ide_hwifs[0];
-			mate = &ide_hwifs[1];
 			/* secondary enabled */
-			printk(KERN_INFO "%s&%s: qd6580: dual IDE board\n",
-					hwif->name, mate->name);
-
-			ide_init_port_hw(hwif, &hw[0]);
-			ide_init_port_hw(mate, &hw[1]);
-
-			qd_setup(hwif, base, config | (control << 8));
-
-			hwif->port_init_devs = qd6580_port_init_devs;
-			hwif->set_pio_mode = &qd6580_set_pio_mode;
-
-			qd_setup(mate, base, config | (control << 8));
-
-			mate->port_init_devs = qd6580_port_init_devs;
-			mate->set_pio_mode = &qd6580_set_pio_mode;
-
-			idx[0] = 0;
-			idx[1] = 1;
+			printk(KERN_INFO "qd6580: dual IDE board\n");
+
+			hwif = ide_find_port();
+			if (hwif) {
+				ide_init_port_hw(hwif, &hw[0]);
+				hwif->config_data = (base << 8) | config;
+				hwif->port_init_devs = qd6580_port_init_devs;
+				hwif->set_pio_mode   = qd6580_set_pio_mode;
+				hwif->selectproc     = qd65xx_select;
+				idx[0] = hwif->index;
+			}
+
+			mate = ide_find_port();
+			if (mate) {
+				ide_init_port_hw(mate, &hw[1]);
+				mate->config_data = (base << 8) | config;
+				mate->port_init_devs = qd6580_port_init_devs;
+				mate->set_pio_mode   = qd6580_set_pio_mode;
+				mate->selectproc     = qd65xx_select;
+				idx[1] = mate->index;
+			}
 
 			ide_device_add(idx, &qd65xx_port_info);
 
@@ -469,7 +456,7 @@ static int __init qd_probe(int base)
 		}
 	}
 	/* no qd65xx found */
-	return 1;
+	return -ENODEV;
 }
 
 int probe_qd65xx = 0;
@@ -479,14 +466,18 @@ MODULE_PARM_DESC(probe, "probe for QD65xx chipsets");
 
 static int __init qd65xx_init(void)
 {
+	int rc1, rc2 = -ENODEV;
+
 	if (probe_qd65xx == 0)
 		return -ENODEV;
 
-	if (qd_probe(0x30))
-		qd_probe(0xb0);
-	if (ide_hwifs[0].chipset != ide_qd65xx &&
-	    ide_hwifs[1].chipset != ide_qd65xx)
+	rc1 = qd_probe(0x30);
+	if (rc1)
+		rc2 = qd_probe(0xb0);
+
+	if (rc1 < 0 && rc2 < 0)
 		return -ENODEV;
+
 	return 0;
 }
 
diff --git a/drivers/ide/legacy/qd65xx.h b/drivers/ide/legacy/qd65xx.h
index 28dd50a..c83dea8 100644
--- a/drivers/ide/legacy/qd65xx.h
+++ b/drivers/ide/legacy/qd65xx.h
@@ -30,7 +30,6 @@
 #define QD_ID3			((config & QD_CONFIG_ID3)!=0)
 
 #define QD_CONFIG(hwif)		((hwif)->config_data & 0x00ff)
-#define QD_CONTROL(hwif)	(((hwif)->config_data & 0xff00) >> 8)
 
 #define QD_TIMING(drive)	(byte)(((drive)->drive_data) & 0x00ff)
 #define QD_TIMREG(drive)	(byte)((((drive)->drive_data) & 0xff00) >> 8)
diff --git a/drivers/ide/legacy/umc8672.c b/drivers/ide/legacy/umc8672.c
index bc19448..4d90bad 100644
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -19,7 +19,7 @@
  */
 
 /*
- * VLB Controller Support from 
+ * VLB Controller Support from
  * Wolfram Podien
  * Rohoefe 3
  * D28832 Achim
@@ -32,7 +32,7 @@
  * #define UMC_DRIVE0 11
  * in the beginning of the driver, which sets the speed of drive 0 to 11 (there
  * are some lines present). 0 - 11 are allowed speed values. These values are
- * the results from the DOS speed test program supplied from UMC. 11 is the 
+ * the results from the DOS speed test program supplied from UMC. 11 is the
  * highest speed (about PIO mode 3)
  */
 #define REALLY_SLOW_IO		/* some systems can safely undef this */
@@ -60,62 +60,62 @@
 #define UMC_DRIVE3      1              /* In case of crash reduce speed */
 
 static u8 current_speeds[4] = {UMC_DRIVE0, UMC_DRIVE1, UMC_DRIVE2, UMC_DRIVE3};
-static const u8 pio_to_umc [5] = {0,3,7,10,11};	/* rough guesses */
+static const u8 pio_to_umc [5] = {0, 3, 7, 10, 11};	/* rough guesses */
 
 /*       0    1    2    3    4    5    6    7    8    9    10   11      */
 static const u8 speedtab [3][12] = {
-	{0xf, 0xb, 0x2, 0x2, 0x2, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 },
-	{0x3, 0x2, 0x2, 0x2, 0x2, 0x2, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 },
-	{0xff,0xcb,0xc0,0x58,0x36,0x33,0x23,0x22,0x21,0x11,0x10,0x0}};
+	{0x0f, 0x0b, 0x02, 0x02, 0x02, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x1},
+	{0x03, 0x02, 0x02, 0x02, 0x02, 0x02, 0x01, 0x01, 0x01, 0x01, 0x01, 0x1},
+	{0xff, 0xcb, 0xc0, 0x58, 0x36, 0x33, 0x23, 0x22, 0x21, 0x11, 0x10, 0x0}
+};
 
-static void out_umc (char port,char wert)
+static void out_umc(char port, char wert)
 {
-	outb_p(port,0x108);
-	outb_p(wert,0x109);
+	outb_p(port, 0x108);
+	outb_p(wert, 0x109);
 }
 
-static inline u8 in_umc (char port)
+static inline u8 in_umc(char port)
 {
-	outb_p(port,0x108);
+	outb_p(port, 0x108);
 	return inb_p(0x109);
 }
 
-static void umc_set_speeds (u8 speeds[])
+static void umc_set_speeds(u8 speeds[])
 {
 	int i, tmp;
 
-	outb_p(0x5A,0x108); /* enable umc */
+	outb_p(0x5A, 0x108); /* enable umc */
 
-	out_umc (0xd7,(speedtab[0][speeds[2]] | (speedtab[0][speeds[3]]<<4)));
-	out_umc (0xd6,(speedtab[0][speeds[0]] | (speedtab[0][speeds[1]]<<4)));
+	out_umc(0xd7, (speedtab[0][speeds[2]] | (speedtab[0][speeds[3]]<<4)));
+	out_umc(0xd6, (speedtab[0][speeds[0]] | (speedtab[0][speeds[1]]<<4)));
 	tmp = 0;
-	for (i = 3; i >= 0; i--) {
+	for (i = 3; i >= 0; i--)
 		tmp = (tmp << 2) | speedtab[1][speeds[i]];
+	out_umc(0xdc, tmp);
+	for (i = 0; i < 4; i++) {
+		out_umc(0xd0 + i, speedtab[2][speeds[i]]);
+		out_umc(0xd8 + i, speedtab[2][speeds[i]]);
 	}
-	out_umc (0xdc,tmp);
-	for (i = 0;i < 4; i++) {
-		out_umc (0xd0+i,speedtab[2][speeds[i]]);
-		out_umc (0xd8+i,speedtab[2][speeds[i]]);
-	}
-	outb_p(0xa5,0x108); /* disable umc */
+	outb_p(0xa5, 0x108); /* disable umc */
 
-	printk ("umc8672: drive speeds [0 to 11]: %d %d %d %d\n",
+	printk("umc8672: drive speeds [0 to 11]: %d %d %d %d\n",
 		speeds[0], speeds[1], speeds[2], speeds[3]);
 }
 
 static void umc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
-	ide_hwgroup_t *hwgroup = ide_hwifs[HWIF(drive)->index^1].hwgroup;
 
 	printk("%s: setting umc8672 to PIO mode%d (speed %d)\n",
 		drive->name, pio, pio_to_umc[pio]);
 	spin_lock_irqsave(&ide_lock, flags);
-	if (hwgroup && hwgroup->handler != NULL) {
+	if (hwif->mate && hwif->mate->hwgroup->handler) {
 		printk(KERN_ERR "umc8672: other interface is busy: exiting tune_umc()\n");
 	} else {
 		current_speeds[drive->name[2] - 'a'] = pio_to_umc[pio];
-		umc_set_speeds (current_speeds);
+		umc_set_speeds(current_speeds);
 	}
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
@@ -128,8 +128,9 @@ static const struct ide_port_info umc8672_port_info __initdata = {
 
 static int __init umc8672_probe(void)
 {
+	ide_hwif_t *hwif, *mate;
 	unsigned long flags;
-	static u8 idx[4] = { 0, 1, 0xff, 0xff };
+	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw[2];
 
 	if (!request_region(0x108, 2, "umc8672")) {
@@ -137,16 +138,16 @@ static int __init umc8672_probe(void)
 		return 1;
 	}
 	local_irq_save(flags);
-	outb_p(0x5A,0x108); /* enable umc */
+	outb_p(0x5A, 0x108); /* enable umc */
 	if (in_umc (0xd5) != 0xa0) {
 		local_irq_restore(flags);
 		printk(KERN_ERR "umc8672: not found\n");
 		release_region(0x108, 2);
-		return 1;  
+		return 1;
 	}
-	outb_p(0xa5,0x108); /* disable umc */
+	outb_p(0xa5, 0x108); /* disable umc */
 
-	umc_set_speeds (current_speeds);
+	umc_set_speeds(current_speeds);
 	local_irq_restore(flags);
 
 	memset(&hw, 0, sizeof(hw));
@@ -157,18 +158,26 @@ static int __init umc8672_probe(void)
 	ide_std_init_ports(&hw[1], 0x170, 0x376);
 	hw[1].irq = 15;
 
-	ide_init_port_hw(&ide_hwifs[0], &hw[0]);
-	ide_init_port_hw(&ide_hwifs[1], &hw[1]);
+	hwif = ide_find_port();
+	if (hwif) {
+		ide_init_port_hw(hwif, &hw[0]);
+		hwif->set_pio_mode = umc_set_pio_mode;
+		idx[0] = hwif->index;
+	}
 
-	ide_hwifs[0].set_pio_mode = &umc_set_pio_mode;
-	ide_hwifs[1].set_pio_mode = &umc_set_pio_mode;
+	mate = ide_find_port();
+	if (mate) {
+		ide_init_port_hw(mate, &hw[1]);
+		mate->set_pio_mode = umc_set_pio_mode;
+		idx[1] = mate->index;
+	}
 
 	ide_device_add(idx, &umc8672_port_info);
 
 	return 0;
 }
 
-int probe_umc8672 = 0;
+int probe_umc8672;
 
 module_param_named(probe, probe_umc8672, bool, 0);
 MODULE_PARM_DESC(probe, "probe for UMC8672 chipset");
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 9b62824..a8cd003 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -599,9 +599,11 @@ static int au_ide_probe(struct device *dev)
 		goto out;
 	}
 
-	/* FIXME:  This might possibly break PCMCIA IDE devices */
-
-	hwif                            = &ide_hwifs[pdev->id];
+	hwif = ide_find_port();
+	if (hwif == NULL) {
+		ret = -ENOENT;
+		goto out;
+	}
 
 	memset(&hw, 0, sizeof(hw));
 	auide_setup_ports(&hw, ahwif);
diff --git a/drivers/ide/mips/swarm.c b/drivers/ide/mips/swarm.c
index 956259f..bbe8d58 100644
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -76,17 +76,12 @@ static int __devinit swarm_ide_probe(struct device *dev)
 	if (!SIBYTE_HAVE_IDE)
 		return -ENODEV;
 
-	/* Find an empty slot.  */
-	for (i = 0; i < MAX_HWIFS; i++)
-		if (!ide_hwifs[i].io_ports[IDE_DATA_OFFSET])
-			break;
-	if (i >= MAX_HWIFS) {
+	hwif = ide_find_port();
+	if (hwif == NULL) {
 		printk(KERN_ERR DRV_NAME ": no free slot for interface\n");
 		return -ENOMEM;
 	}
 
-	hwif = ide_hwifs + i;
-
 	base = ioremap(A_IO_EXT_BASE, 0x800);
 	offset = __raw_readq(base + R_IO_EXT_REG(R_IO_EXT_START_ADDR, IDE_CS));
 	size = __raw_readq(base + R_IO_EXT_REG(R_IO_EXT_MULT_SIZE, IDE_CS));
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index cfb3265..c9ba15a 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -220,7 +220,8 @@ static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
 		.init_hwif	= init_hwif_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE,
+				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
+				  IDE_HFLAG_NON_BOOTABLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA4,
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index b3b6f51..3fa2d9f 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -750,7 +750,6 @@ static const struct ide_port_info ali15x3_chipset __devinitdata = {
 	.init_chipset	= init_chipset_ali15x3,
 	.init_hwif	= init_hwif_ali15x3,
 	.init_dma	= init_dma_ali15x3,
-	.host_flags	= IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO5,
 	.swdma_mask	= ATA_SWDMA2,
 	.mwdma_mask	= ATA_MWDMA2,
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 2ef890c..ff684d3 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -219,12 +219,10 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 
 #define IDE_HFLAGS_AMD \
 	(IDE_HFLAG_PIO_NO_BLACKLIST | \
-	 IDE_HFLAG_PIO_NO_DOWNGRADE | \
 	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
 	 IDE_HFLAG_POST_SET_MODE | \
 	 IDE_HFLAG_IO_32BIT | \
-	 IDE_HFLAG_UNMASK_IRQS | \
-	 IDE_HFLAG_BOOTABLE)
+	 IDE_HFLAG_UNMASK_IRQS)
 
 #define DECLARE_AMD_DEV(name_str, swdma, udma)				\
 	{								\
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index 7e037c8..91722f8 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -151,7 +151,7 @@ static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
 		.name		= "ATIIXP",
 		.init_hwif	= init_hwif_atiixp,
 		.enablebits	= {{0x48,0x01,0x00}, {0x48,0x08,0x00}},
-		.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAG_LEGACY_IRQS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -159,8 +159,7 @@ static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
 		.name		= "SB600_PATA",
 		.init_hwif	= init_hwif_atiixp,
 		.enablebits	= {{0x48,0x01,0x00}, {0x00,0x00,0x00}},
- 		.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_LEGACY_IRQS |
-				  IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_LEGACY_IRQS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index a1cfe03..b076dbf 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -4,7 +4,7 @@
 
 /*
  *  Original authors:	abramov@cecmow.enet.dec.com (Igor Abramov)
- *  			mlord@pobox.com (Mark Lord)
+ *			mlord@pobox.com (Mark Lord)
  *
  *  See linux/MAINTAINERS for address of current maintainer.
  *
@@ -98,7 +98,7 @@
 
 #define CMD640_PREFETCH_MASKS 1
 
-//#define CMD640_DUMP_REGS
+/*#define CMD640_DUMP_REGS */
 
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -112,7 +112,7 @@
 /*
  * This flag is set in ide.c by the parameter:  ide0=cmd640_vlb
  */
-int cmd640_vlb = 0;
+int cmd640_vlb;
 
 /*
  * CMD640 specific registers definition.
@@ -185,7 +185,6 @@ static DEFINE_SPINLOCK(cmd640_lock);
  * These are initialized to point at the devices we control
  */
 static ide_hwif_t  *cmd_hwif0, *cmd_hwif1;
-static ide_drive_t *cmd_drives[4];
 
 /*
  * Interface to access cmd640x registers
@@ -207,13 +206,13 @@ static unsigned int cmd640_chip_version;
 
 /* PCI method 1 access */
 
-static void put_cmd640_reg_pci1 (u16 reg, u8 val)
+static void put_cmd640_reg_pci1(u16 reg, u8 val)
 {
 	outl_p((reg & 0xfc) | cmd640_key, 0xcf8);
 	outb_p(val, (reg & 3) | 0xcfc);
 }
 
-static u8 get_cmd640_reg_pci1 (u16 reg)
+static u8 get_cmd640_reg_pci1(u16 reg)
 {
 	outl_p((reg & 0xfc) | cmd640_key, 0xcf8);
 	return inb_p((reg & 3) | 0xcfc);
@@ -221,14 +220,14 @@ static u8 get_cmd640_reg_pci1 (u16 reg)
 
 /* PCI method 2 access (from CMD datasheet) */
 
-static void put_cmd640_reg_pci2 (u16 reg, u8 val)
+static void put_cmd640_reg_pci2(u16 reg, u8 val)
 {
 	outb_p(0x10, 0xcf8);
 	outb_p(val, cmd640_key + reg);
 	outb_p(0, 0xcf8);
 }
 
-static u8 get_cmd640_reg_pci2 (u16 reg)
+static u8 get_cmd640_reg_pci2(u16 reg)
 {
 	u8 b;
 
@@ -240,13 +239,13 @@ static u8 get_cmd640_reg_pci2 (u16 reg)
 
 /* VLB access */
 
-static void put_cmd640_reg_vlb (u16 reg, u8 val)
+static void put_cmd640_reg_vlb(u16 reg, u8 val)
 {
 	outb_p(reg, cmd640_key);
 	outb_p(val, cmd640_key + 4);
 }
 
-static u8 get_cmd640_reg_vlb (u16 reg)
+static u8 get_cmd640_reg_vlb(u16 reg)
 {
 	outb_p(reg, cmd640_key);
 	return inb_p(cmd640_key + 4);
@@ -268,11 +267,11 @@ static void put_cmd640_reg(u16 reg, u8 val)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cmd640_lock, flags);
-	__put_cmd640_reg(reg,val);
+	__put_cmd640_reg(reg, val);
 	spin_unlock_irqrestore(&cmd640_lock, flags);
 }
 
-static int __init match_pci_cmd640_device (void)
+static int __init match_pci_cmd640_device(void)
 {
 	const u8 ven_dev[4] = {0x95, 0x10, 0x40, 0x06};
 	unsigned int i;
@@ -292,7 +291,7 @@ static int __init match_pci_cmd640_device (void)
 /*
  * Probe for CMD640x -- pci method 1
  */
-static int __init probe_for_cmd640_pci1 (void)
+static int __init probe_for_cmd640_pci1(void)
 {
 	__get_cmd640_reg = get_cmd640_reg_pci1;
 	__put_cmd640_reg = put_cmd640_reg_pci1;
@@ -308,7 +307,7 @@ static int __init probe_for_cmd640_pci1 (void)
 /*
  * Probe for CMD640x -- pci method 2
  */
-static int __init probe_for_cmd640_pci2 (void)
+static int __init probe_for_cmd640_pci2(void)
 {
 	__get_cmd640_reg = get_cmd640_reg_pci2;
 	__put_cmd640_reg = put_cmd640_reg_pci2;
@@ -322,7 +321,7 @@ static int __init probe_for_cmd640_pci2 (void)
 /*
  * Probe for CMD640x -- vlb
  */
-static int __init probe_for_cmd640_vlb (void)
+static int __init probe_for_cmd640_vlb(void)
 {
 	u8 b;
 
@@ -343,7 +342,7 @@ static int __init probe_for_cmd640_vlb (void)
  *  Returns 1 if an IDE interface/drive exists at 0x170,
  *  Returns 0 otherwise.
  */
-static int __init secondary_port_responding (void)
+static int __init secondary_port_responding(void)
 {
 	unsigned long flags;
 
@@ -367,7 +366,7 @@ static int __init secondary_port_responding (void)
 /*
  * Dump out all cmd640 registers.  May be called from ide.c
  */
-static void cmd640_dump_regs (void)
+static void cmd640_dump_regs(void)
 {
 	unsigned int reg = cmd640_vlb ? 0x50 : 0x00;
 
@@ -386,9 +385,8 @@ static void cmd640_dump_regs (void)
  * Check whether prefetch is on for a drive,
  * and initialize the unmask flags for safe operation.
  */
-static void __init check_prefetch (unsigned int index)
+static void __init check_prefetch(ide_drive_t *drive, unsigned int index)
 {
-	ide_drive_t *drive = cmd_drives[index];
 	u8 b = get_cmd640_reg(prefetch_regs[index]);
 
 	if (b & prefetch_masks[index]) {	/* is prefetch off? */
@@ -404,28 +402,13 @@ static void __init check_prefetch (unsigned int index)
 	}
 }
 
-/*
- * Figure out which devices we control
- */
-static void __init setup_device_ptrs (void)
-{
-	cmd_hwif0 = &ide_hwifs[0];
-	cmd_hwif1 = &ide_hwifs[1];
-
-	cmd_drives[0] = &cmd_hwif0->drives[0];
-	cmd_drives[1] = &cmd_hwif0->drives[1];
-	cmd_drives[2] = &cmd_hwif1->drives[0];
-	cmd_drives[3] = &cmd_hwif1->drives[1];
-}
-
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 
 /*
  * Sets prefetch mode for a drive.
  */
-static void set_prefetch_mode (unsigned int index, int mode)
+static void set_prefetch_mode(ide_drive_t *drive, unsigned int index, int mode)
 {
-	ide_drive_t *drive = cmd_drives[index];
 	unsigned long flags;
 	int reg = prefetch_regs[index];
 	u8 b;
@@ -452,7 +435,7 @@ static void set_prefetch_mode (unsigned int index, int mode)
 /*
  * Dump out current drive clocks settings
  */
-static void display_clocks (unsigned int index)
+static void display_clocks(unsigned int index)
 {
 	u8 active_count, recovery_count;
 
@@ -471,7 +454,7 @@ static void display_clocks (unsigned int index)
  * Pack active and recovery counts into single byte representation
  * used by controller
  */
-static inline u8 pack_nibbles (u8 upper, u8 lower)
+static inline u8 pack_nibbles(u8 upper, u8 lower)
 {
 	return ((upper & 0x0f) << 4) | (lower & 0x0f);
 }
@@ -479,7 +462,7 @@ static inline u8 pack_nibbles (u8 upper, u8 lower)
 /*
  * This routine retrieves the initial drive timings from the chipset.
  */
-static void __init retrieve_drive_counts (unsigned int index)
+static void __init retrieve_drive_counts(unsigned int index)
 {
 	u8 b;
 
@@ -488,10 +471,10 @@ static void __init retrieve_drive_counts (unsigned int index)
 	 */
 	b = get_cmd640_reg(arttim_regs[index]) & ~0x3f;
 	switch (b) {
-		case 0x00: b = 4; break;
-		case 0x80: b = 3; break;
-		case 0x40: b = 2; break;
-		default:   b = 5; break;
+	case 0x00: b = 4; break;
+	case 0x80: b = 3; break;
+	case 0x40: b = 2; break;
+	default:   b = 5; break;
 	}
 	setup_counts[index] = b;
 
@@ -508,7 +491,7 @@ static void __init retrieve_drive_counts (unsigned int index)
  * This routine writes the prepared setup/active/recovery counts
  * for a drive into the cmd640 chipset registers to active them.
  */
-static void program_drive_counts (unsigned int index)
+static void program_drive_counts(ide_drive_t *drive, unsigned int index)
 {
 	unsigned long flags;
 	u8 setup_count    = setup_counts[index];
@@ -522,8 +505,11 @@ static void program_drive_counts (unsigned int index)
 	 * so we merge the timings, using the slowest value for each timing.
 	 */
 	if (index > 1) {
-		unsigned int mate;
-		if (cmd_drives[mate = index ^ 1]->present) {
+		ide_hwif_t *hwif = drive->hwif;
+		ide_drive_t *peer = &hwif->drives[!drive->select.b.unit];
+		unsigned int mate = index ^ 1;
+
+		if (peer->present) {
 			if (setup_count < setup_counts[mate])
 				setup_count = setup_counts[mate];
 			if (active_count < active_counts[mate])
@@ -537,11 +523,11 @@ static void program_drive_counts (unsigned int index)
 	 * Convert setup_count to internal chipset representation
 	 */
 	switch (setup_count) {
-		case 4:	 setup_count = 0x00; break;
-		case 3:	 setup_count = 0x80; break;
-		case 1:
-		case 2:	 setup_count = 0x40; break;
-		default: setup_count = 0xc0; /* case 5 */
+	case 4:	 setup_count = 0x00; break;
+	case 3:	 setup_count = 0x80; break;
+	case 1:
+	case 2:	 setup_count = 0x40; break;
+	default: setup_count = 0xc0; /* case 5 */
 	}
 
 	/*
@@ -562,7 +548,8 @@ static void program_drive_counts (unsigned int index)
 /*
  * Set a specific pio_mode for a drive
  */
-static void cmd640_set_mode (unsigned int index, u8 pio_mode, unsigned int cycle_time)
+static void cmd640_set_mode(ide_drive_t *drive, unsigned int index,
+			    u8 pio_mode, unsigned int cycle_time)
 {
 	int setup_time, active_time, recovery_time, clock_time;
 	u8 setup_count, active_count, recovery_count, recovery_count2, cycle_count;
@@ -574,15 +561,15 @@ static void cmd640_set_mode (unsigned int index, u8 pio_mode, unsigned int cycle
 	active_time = ide_pio_timings[pio_mode].active_time;
 	recovery_time = cycle_time - (setup_time + active_time);
 	clock_time = 1000 / bus_speed;
-	cycle_count = (cycle_time + clock_time - 1) / clock_time;
+	cycle_count = DIV_ROUND_UP(cycle_time, clock_time);
 
-	setup_count = (setup_time + clock_time - 1) / clock_time;
+	setup_count = DIV_ROUND_UP(setup_time, clock_time);
 
-	active_count = (active_time + clock_time - 1) / clock_time;
+	active_count = DIV_ROUND_UP(active_time, clock_time);
 	if (active_count < 2)
 		active_count = 2; /* minimum allowed by cmd640 */
 
-	recovery_count = (recovery_time + clock_time - 1) / clock_time;
+	recovery_count = DIV_ROUND_UP(recovery_time, clock_time);
 	recovery_count2 = cycle_count - (setup_count + active_count);
 	if (recovery_count2 > recovery_count)
 		recovery_count = recovery_count2;
@@ -611,7 +598,7 @@ static void cmd640_set_mode (unsigned int index, u8 pio_mode, unsigned int cycle
 	 *	1) this is the wrong place to do it (proper is do_special() in ide.c)
 	 * 	2) in practice this is rarely, if ever, necessary
 	 */
-	program_drive_counts (index);
+	program_drive_counts(drive, index);
 }
 
 static void cmd640_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -619,32 +606,26 @@ static void cmd640_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	unsigned int index = 0, cycle_time;
 	u8 b;
 
-	while (drive != cmd_drives[index]) {
-		if (++index > 3) {
-			printk(KERN_ERR "%s: bad news in %s\n",
-					drive->name, __FUNCTION__);
-			return;
-		}
-	}
 	switch (pio) {
-		case 6: /* set fast-devsel off */
-		case 7: /* set fast-devsel on */
-			b = get_cmd640_reg(CNTRL) & ~0x27;
-			if (pio & 1)
-				b |= 0x27;
-			put_cmd640_reg(CNTRL, b);
-			printk("%s: %sabled cmd640 fast host timing (devsel)\n", drive->name, (pio & 1) ? "en" : "dis");
-			return;
-
-		case 8: /* set prefetch off */
-		case 9: /* set prefetch on */
-			set_prefetch_mode(index, pio & 1);
-			printk("%s: %sabled cmd640 prefetch\n", drive->name, (pio & 1) ? "en" : "dis");
-			return;
+	case 6: /* set fast-devsel off */
+	case 7: /* set fast-devsel on */
+		b = get_cmd640_reg(CNTRL) & ~0x27;
+		if (pio & 1)
+			b |= 0x27;
+		put_cmd640_reg(CNTRL, b);
+		printk("%s: %sabled cmd640 fast host timing (devsel)\n",
+			drive->name, (pio & 1) ? "en" : "dis");
+		return;
+	case 8: /* set prefetch off */
+	case 9: /* set prefetch on */
+		set_prefetch_mode(drive, index, pio & 1);
+		printk("%s: %sabled cmd640 prefetch\n",
+			drive->name, (pio & 1) ? "en" : "dis");
+		return;
 	}
 
 	cycle_time = ide_pio_cycle_time(drive, pio);
-	cmd640_set_mode(index, pio, cycle_time);
+	cmd640_set_mode(drive, index, pio, cycle_time);
 
 	printk("%s: selected cmd640 PIO mode%d (%dns)",
 		drive->name, pio, cycle_time);
@@ -749,7 +730,7 @@ static int __init cmd640x_init(void)
 	cfr = get_cmd640_reg(CFR);
 	cmd640_chip_version = cfr & CFR_DEVREV;
 	if (cmd640_chip_version == 0) {
-		printk ("ide: bad cmd640 revision: %d\n", cmd640_chip_version);
+		printk("ide: bad cmd640 revision: %d\n", cmd640_chip_version);
 		return 0;
 	}
 
@@ -764,17 +745,19 @@ static int __init cmd640x_init(void)
 	printk(KERN_INFO "cmd640: buggy cmd640%c interface on %s, config=0x%02x"
 			 "\n", 'a' + cmd640_chip_version - 1, bus_type, cfr);
 
+	cmd_hwif0 = ide_find_port();
+
 	/*
 	 * Initialize data for primary port
 	 */
-	setup_device_ptrs ();
-
-	ide_init_port_hw(cmd_hwif0, &hw[0]);
+	if (cmd_hwif0) {
+		ide_init_port_hw(cmd_hwif0, &hw[0]);
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-	cmd_hwif0->set_pio_mode = &cmd640_set_pio_mode;
+		cmd_hwif0->set_pio_mode = &cmd640_set_pio_mode;
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
-	idx[0] = cmd_hwif0->index;
+		idx[0] = cmd_hwif0->index;
+	}
 
 	/*
 	 * Ensure compatibility by always using the slowest timings
@@ -786,10 +769,13 @@ static int __init cmd640x_init(void)
 	put_cmd640_reg(CMDTIM, 0);
 	put_cmd640_reg(BRST, 0x40);
 
+	cmd_hwif1 = ide_find_port();
+
 	/*
 	 * Try to enable the secondary interface, if not already enabled
 	 */
-	if (cmd_hwif1->drives[0].noprobe && cmd_hwif1->drives[1].noprobe) {
+	if (cmd_hwif1 &&
+	    cmd_hwif1->drives[0].noprobe && cmd_hwif1->drives[1].noprobe) {
 		port2 = "not probed";
 	} else {
 		b = get_cmd640_reg(CNTRL);
@@ -820,7 +806,7 @@ static int __init cmd640x_init(void)
 	/*
 	 * Initialize data for secondary cmd640 port, if enabled
 	 */
-	if (second_port_cmd640) {
+	if (second_port_cmd640 && cmd_hwif1) {
 		ide_init_port_hw(cmd_hwif1, &hw[1]);
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 		cmd_hwif1->set_pio_mode = &cmd640_set_pio_mode;
@@ -828,7 +814,7 @@ static int __init cmd640x_init(void)
 
 		idx[1] = cmd_hwif1->index;
 	}
-	printk(KERN_INFO "%s: %sserialized, secondary interface %s\n", cmd_hwif1->name,
+	printk(KERN_INFO "cmd640: %sserialized, secondary interface %s\n",
 			 second_port_cmd640 ? "" : "not ", port2);
 
 	/*
@@ -836,18 +822,30 @@ static int __init cmd640x_init(void)
 	 * Do not unnecessarily disturb any prior BIOS setup of these.
 	 */
 	for (index = 0; index < (2 + (second_port_cmd640 << 1)); index++) {
-		ide_drive_t *drive = cmd_drives[index];
+		ide_drive_t *drive;
+
+		if (index > 1) {
+			if (cmd_hwif1 == NULL)
+				continue;
+			drive = &cmd_hwif1->drives[index & 1];
+		} else  {
+			if (cmd_hwif0 == NULL)
+				continue;
+			drive = &cmd_hwif0->drives[index & 1];
+		}
+
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 		if (drive->autotune || ((index > 1) && second_port_toggled)) {
-	 		/*
-	 		 * Reset timing to the slowest speed and turn off prefetch.
-			 * This way, the drive identify code has a better chance.
+			/*
+			 * Reset timing to the slowest speed and turn off
+			 * prefetch.  This way, the drive identify code has
+			 * a better chance.
 			 */
 			setup_counts    [index] = 4;	/* max possible */
 			active_counts   [index] = 16;	/* max possible */
 			recovery_counts [index] = 16;	/* max possible */
-			program_drive_counts (index);
-			set_prefetch_mode (index, 0);
+			program_drive_counts(drive, index);
+			set_prefetch_mode(drive, index, 0);
 			printk("cmd640: drive%d timings/prefetch cleared\n", index);
 		} else {
 			/*
@@ -855,7 +853,7 @@ static int __init cmd640x_init(void)
 			 * This preserves any prior BIOS setup.
 			 */
 			retrieve_drive_counts (index);
-			check_prefetch (index);
+			check_prefetch(drive, index);
 			printk("cmd640: drive%d timings/prefetch(%s) preserved",
 				index, drive->no_io_32bit ? "off" : "on");
 			display_clocks(index);
@@ -864,7 +862,7 @@ static int __init cmd640x_init(void)
 		/*
 		 * Set the drive unmask flags to match the prefetch setting
 		 */
-		check_prefetch (index);
+		check_prefetch(drive, index);
 		printk("cmd640: drive%d timings/prefetch(%s) preserved\n",
 			index, drive->no_io_32bit ? "off" : "on");
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index edabe62..8baccfe 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -440,8 +440,7 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
 		.host_flags	= IDE_HFLAG_CLEAR_SIMPLEX |
-				  IDE_HFLAG_ABUSE_PREFETCH |
-				  IDE_HFLAG_BOOTABLE,
+				  IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= 0x00, /* no udma */
@@ -451,7 +450,7 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.chipset	= ide_cmd646,
-		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA2,
@@ -460,7 +459,7 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
-		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA4,
@@ -469,7 +468,7 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
-		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index 1c163e4..01b37ec 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -122,8 +122,7 @@ static void __devinit init_hwif_cs5520(ide_hwif_t *hwif)
 				  IDE_HFLAG_CS5520 |		\
 				  IDE_HFLAG_VDMA |		\
 				  IDE_HFLAG_NO_ATAPI_DMA |	\
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE |\
-				  IDE_HFLAG_BOOTABLE,		\
+				  IDE_HFLAG_ABUSE_SET_DMA_MODE, \
 		.pio_mask	= ATA_PIO4,			\
 	}
 
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index 941a134..56a369c 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -249,8 +249,7 @@ static const struct ide_port_info cs5530_chipset __devinitdata = {
 	.init_chipset	= init_chipset_cs5530,
 	.init_hwif	= init_hwif_cs5530,
 	.host_flags	= IDE_HFLAG_SERIALIZE |
-			  IDE_HFLAG_POST_SET_MODE |
-			  IDE_HFLAG_BOOTABLE,
+			  IDE_HFLAG_POST_SET_MODE,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA2,
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index d7b5ea9..c9685f2 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -186,7 +186,7 @@ static const struct ide_port_info cs5535_chipset __devinitdata = {
 	.name		= "CS5535",
 	.init_hwif	= init_hwif_cs5535,
 	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE |
-			  IDE_HFLAG_ABUSE_SET_DMA_MODE | IDE_HFLAG_BOOTABLE,
+			  IDE_HFLAG_ABUSE_SET_DMA_MODE,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA4,
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index 724cbac..08eab7e 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -6,7 +6,7 @@
  *
  * The CY82C693 chipset is used on Digital's PC-Alpha 164SX boards.
  * Writing the driver was quite simple, since most of the job is
- * done by the generic pci-ide support. 
+ * done by the generic pci-ide support.
  * The hard part was finding the CY82C693's datasheet on Cypress's
  * web page :-(. But Altavista solved this problem :-).
  *
@@ -15,12 +15,12 @@
  * - I recently got a 16.8G IBM DTTA, so I was able to test it with
  *   a large and fast disk - the results look great, so I'd say the
  *   driver is working fine :-)
- *   hdparm -t reports 8.17 MB/sec at about 6% CPU usage for the DTTA 
- * - this is my first linux driver, so there's probably a lot  of room 
+ *   hdparm -t reports 8.17 MB/sec at about 6% CPU usage for the DTTA
+ * - this is my first linux driver, so there's probably a lot  of room
  *   for optimizations and bug fixing, so feel free to do it.
  * - use idebus=xx parameter to set PCI bus speed - needed to calc
  *   timings for PIO modes (default will be 40)
- * - if using PIO mode it's a good idea to set the PIO mode and 
+ * - if using PIO mode it's a good idea to set the PIO mode and
  *   32-bit I/O support (if possible), e.g. hdparm -p2 -c1 /dev/hda
  * - I had some problems with my IBM DHEA with PIO modes < 2
  *   (lost interrupts) ?????
@@ -110,11 +110,11 @@ typedef struct pio_clocks_s {
  * calc clocks using bus_speed
  * returns (rounded up) time in bus clocks for time in ns
  */
-static int calc_clk (int time, int bus_speed)
+static int calc_clk(int time, int bus_speed)
 {
 	int clocks;
 
-	clocks = (time*bus_speed+999)/1000 -1;
+	clocks = (time*bus_speed+999)/1000 - 1;
 
 	if (clocks < 0)
 		clocks = 0;
@@ -132,8 +132,8 @@ static int calc_clk (int time, int bus_speed)
  * NOTE: for mode 0,1 and 2 drives 8-bit IDE command control registers are used
  *       for mode 3 and 4 drives 8 and 16-bit timings are the same
  *
- */ 
-static void compute_clocks (u8 pio, pio_clocks_t *p_pclk)
+ */
+static void compute_clocks(u8 pio, pio_clocks_t *p_pclk)
 {
 	int clk1, clk2;
 	int bus_speed = system_bus_clock();	/* get speed of PCI bus */
@@ -158,7 +158,7 @@ static void compute_clocks (u8 pio, pio_clocks_t *p_pclk)
 	clk1 = (clk1<<4)|clk2;	/* combine active and recovery clocks */
 
 	/* note: we use the same values for 16bit IOR and IOW
-         *	those are all the same, since I don't have other
+	 *	those are all the same, since I don't have other
 	 *	timings than those from ide-lib.c
 	 */
 
@@ -186,7 +186,7 @@ static void cy82c693_set_dma_mode(ide_drive_t *drive, const u8 mode)
 	outb(index, CY82_INDEX_PORT);
 	data = inb(CY82_DATA_PORT);
 
-	printk (KERN_INFO "%s (ch=%d, dev=%d): DMA mode is %d (single=%d)\n",
+	printk(KERN_INFO "%s (ch=%d, dev=%d): DMA mode is %d (single=%d)\n",
 		drive->name, HWIF(drive)->channel, drive->select.b.unit,
 		(data&0x3), ((data>>2)&1));
 #endif /* CY82C693_DEBUG_LOGS */
@@ -202,7 +202,7 @@ static void cy82c693_set_dma_mode(ide_drive_t *drive, const u8 mode)
 		mode & 3, single);
 #endif /* CY82C693_DEBUG_INFO */
 
-	/* 
+	/*
 	 * note: below we set the value for Bus Master IDE TimeOut Register
 	 * I'm not absolutly sure what this does, but it solved my problem
 	 * with IDE DMA and sound, so I now can play sound and work with
@@ -216,8 +216,8 @@ static void cy82c693_set_dma_mode(ide_drive_t *drive, const u8 mode)
 	outb(CY82_INDEX_TIMEOUT, CY82_INDEX_PORT);
 	outb(data, CY82_DATA_PORT);
 
-#if CY82C693_DEBUG_INFO	
-	printk (KERN_INFO "%s: Set IDE Bus Master TimeOut Register to 0x%X\n",
+#if CY82C693_DEBUG_INFO
+	printk(KERN_INFO "%s: Set IDE Bus Master TimeOut Register to 0x%X\n",
 		drive->name, data);
 #endif /* CY82C693_DEBUG_INFO */
 }
@@ -242,14 +242,14 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 #if CY82C693_DEBUG_LOGS
 	/* for debug let's show the register values */
-	
-       	if (drive->select.b.unit == 0) {
+
+	if (drive->select.b.unit == 0) {
 		/*
-		 * get master drive registers               	
+		 * get master drive registers
 		 * address setup control register
 		 * is 32 bit !!!
-		 */ 
-	  	pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);                
+		 */
+		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
 		addrCtrl &= 0x0F;
 
 		/* now let's get the remaining registers */
@@ -261,7 +261,7 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		 * set slave drive registers
 		 * address setup control register
 		 * is 32 bit !!!
-		 */ 
+		 */
 		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
 
 		addrCtrl &= 0xF0;
@@ -288,9 +288,9 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		 * set master drive
 		 * address setup control register
 		 * is 32 bit !!!
-		 */ 
+		 */
 		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
-		
+
 		addrCtrl &= (~0xF);
 		addrCtrl |= (unsigned int)pclk.address_time;
 		pci_write_config_dword(dev, CY82_IDE_ADDRSETUP, addrCtrl);
@@ -299,14 +299,14 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		pci_write_config_byte(dev, CY82_IDE_MASTER_IOR, pclk.time_16r);
 		pci_write_config_byte(dev, CY82_IDE_MASTER_IOW, pclk.time_16w);
 		pci_write_config_byte(dev, CY82_IDE_MASTER_8BIT, pclk.time_8);
-		
+
 		addrCtrl &= 0xF;
 	} else {
 		/*
 		 * set slave drive
 		 * address setup control register
 		 * is 32 bit !!!
-		 */ 
+		 */
 		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
 
 		addrCtrl &= (~0xF0);
@@ -320,7 +320,7 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 		addrCtrl >>= 4;
 		addrCtrl &= 0xF;
-	}	
+	}
 
 #if CY82C693_DEBUG_INFO
 	printk(KERN_INFO "%s (ch=%d, dev=%d): set PIO timing to "
@@ -340,41 +340,41 @@ static unsigned int __devinit init_chipset_cy82c693(struct pci_dev *dev, const c
 
 #ifdef CY82C693_SETDMA_CLOCK
 	u8 data = 0;
-#endif /* CY82C693_SETDMA_CLOCK */ 
+#endif /* CY82C693_SETDMA_CLOCK */
 
 	/* write info about this verion of the driver */
 	printk(KERN_INFO CY82_VERSION "\n");
 
 #ifdef CY82C693_SETDMA_CLOCK
        /* okay let's set the DMA clock speed */
-        
-        outb(CY82_INDEX_CTRLREG1, CY82_INDEX_PORT);
-        data = inb(CY82_DATA_PORT);
+
+	outb(CY82_INDEX_CTRLREG1, CY82_INDEX_PORT);
+	data = inb(CY82_DATA_PORT);
 
 #if CY82C693_DEBUG_INFO
 	printk(KERN_INFO "%s: Peripheral Configuration Register: 0x%X\n",
 		name, data);
 #endif /* CY82C693_DEBUG_INFO */
 
-        /*
+	/*
 	 * for some reason sometimes the DMA controller
 	 * speed is set to ATCLK/2 ???? - we fix this here
-	 * 
+	 *
 	 * note: i don't know what causes this strange behaviour,
 	 *       but even changing the dma speed doesn't solve it :-(
-	 *       the ide performance is still only half the normal speed 
-	 * 
+	 *       the ide performance is still only half the normal speed
+	 *
 	 *       if anybody knows what goes wrong with my machine, please
 	 *       let me know - ASK
-         */
+	 */
 
 	data |= 0x03;
 
-        outb(CY82_INDEX_CTRLREG1, CY82_INDEX_PORT);
-        outb(data, CY82_DATA_PORT);
+	outb(CY82_INDEX_CTRLREG1, CY82_INDEX_PORT);
+	outb(data, CY82_DATA_PORT);
 
 #if CY82C693_DEBUG_INFO
-	printk (KERN_INFO "%s: New Peripheral Configuration Register: 0x%X\n",
+	printk(KERN_INFO "%s: New Peripheral Configuration Register: 0x%X\n",
 		name, data);
 #endif /* CY82C693_DEBUG_INFO */
 
@@ -410,8 +410,7 @@ static const struct ide_port_info cy82c693_chipset __devinitdata = {
 	.init_iops	= init_iops_cy82c693,
 	.init_hwif	= init_hwif_cy82c693,
 	.chipset	= ide_cy82c693,
-	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_CY82C693 |
-			  IDE_HFLAG_BOOTABLE,
+	.host_flags	= IDE_HFLAG_SINGLE,
 	.pio_mask	= ATA_PIO4,
 	.swdma_mask	= ATA_SWDMA2,
 	.mwdma_mask	= ATA_MWDMA2,
@@ -424,7 +423,7 @@ static int __devinit cy82c693_init_one(struct pci_dev *dev, const struct pci_dev
 
 	/* CY82C693 is more than only a IDE controller.
 	   Function 1 is primary IDE channel, function 2 - secondary. */
-        if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE &&
+	if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE &&
 	    PCI_FUNC(dev->devfn) == 1) {
 		dev2 = pci_get_slot(dev->bus, dev->devfn + 1);
 		ret = ide_setup_pci_devices(dev, dev2, &cy82c693_chipset);
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index 961698d..753b86f 100644
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -71,14 +71,13 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 		if (setup[i])
 			outb(setup[i], base + i);
 	}
-	pci_release_regions(dev);	/* IDE layer handles regions itself */
 
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, base + 0x10, base + 0x1e);
 	hw.irq = dev->irq;
 	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif == NULL)
 		goto out_disable;
 
@@ -90,6 +89,7 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 		ide_init_port_data(hwif, i);
 
 	ide_init_port_hw(hwif, &hw);
+	hwif->mmio = 1;
 	hwif->quirkproc = &ide_undecoded_slave;
 
 	idx[0] = i;
@@ -110,6 +110,7 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 
 out_disable:
 	printk(KERN_ERR "delkin_cb: no IDE devices found\n");
+	pci_release_regions(dev);
 	pci_disable_device(dev);
 	return -ENODEV;
 }
@@ -122,6 +123,7 @@ delkin_cb_remove (struct pci_dev *dev)
 	if (hwif)
 		ide_unregister(hwif->index);
 
+	pci_release_regions(dev);
 	pci_disable_device(dev);
 }
 
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index 7fd83a9..041720e 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -38,8 +38,7 @@ MODULE_PARM_DESC(all_generic_ide, "IDE generic will claim all unknown PCI IDE st
 	{ \
 		.name		= name_str, \
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA | \
-				  extra_flags | \
-				  IDE_HFLAG_BOOTABLE, \
+				  extra_flags, \
 		.swdma_mask	= ATA_SWDMA2, \
 		.mwdma_mask	= ATA_MWDMA2, \
 		.udma_mask	= ATA_UDMA6, \
@@ -50,9 +49,8 @@ static const struct ide_port_info generic_chipsets[] __devinitdata = {
 
 	{	/* 1 */
 		.name		= "NS87410",
-		.enablebits	= {{0x43,0x08,0x08}, {0x47,0x08,0x08}},
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
-				  IDE_HFLAG_BOOTABLE,
+		.enablebits	= { {0x43, 0x08, 0x08}, {0x47, 0x08, 0x08} },
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 		.swdma_mask	= ATA_SWDMA2,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
@@ -99,7 +97,7 @@ static const struct ide_port_info generic_chipsets[] __devinitdata = {
  *	Called when the PCI registration layer (or the IDE initialization)
  *	finds a device matching our IDE device tables.
  */
- 
+
 static int __devinit generic_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	const struct ide_port_info *d = &generic_chipsets[id->driver_data];
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index 9f01da4..9f2fc30 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -133,7 +133,7 @@ static const struct ide_port_info hpt34x_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_hpt34x,
 		.init_hwif	= init_hwif_hpt34x,
 		.extra		= 16,
-		.host_flags	= IDE_HFLAGS_HPT34X,
+		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_NON_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
 	},
 	{ /* 1 */
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 82d0e31..a490906 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1557,7 +1557,7 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 			hpt374_init(dev, dev2);
 		else {
 			if (hpt36x_init(dev, dev2))
-				d.host_flags |= IDE_HFLAG_BOOTABLE;
+				d.host_flags &= ~IDE_HFLAG_NON_BOOTABLE;
 		}
 
 		ret = ide_setup_pci_devices(dev, dev2, &d);
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index e3427ea..5b5b0cc 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -35,7 +35,7 @@ static void it8213_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	static DEFINE_SPINLOCK(tune_lock);
 	int control = 0;
 
-	static const u8 timings[][2]= {
+	static const u8 timings[][2] = {
 					{ 0, 0 },
 					{ 0, 0 },
 					{ 1, 0 },
@@ -105,11 +105,10 @@ static void it8213_set_dma_mode(ide_drive_t *drive, const u8 speed)
 
 		if (!(reg48 & u_flag))
 			pci_write_config_byte(dev, 0x48, reg48 | u_flag);
-		if (speed >= XFER_UDMA_5) {
+		if (speed >= XFER_UDMA_5)
 			pci_write_config_byte(dev, 0x55, (u8) reg55|w_flag);
-		} else {
+		else
 			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
-		}
 
 		if ((reg4a & a_speed) != u_speed)
 			pci_write_config_word(dev, 0x4a, (reg4a & ~a_speed) | u_speed);
@@ -170,9 +169,8 @@ static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 	{						\
 		.name		= name_str,		\
 		.init_hwif	= init_hwif_it8213,	\
-		.enablebits	= {{0x41,0x80,0x80}}, \
-		.host_flags	= IDE_HFLAG_SINGLE |	\
-				  IDE_HFLAG_BOOTABLE,	\
+		.enablebits	= { {0x41, 0x80, 0x80} }, \
+		.host_flags	= IDE_HFLAG_SINGLE,	\
 		.pio_mask	= ATA_PIO4,		\
 		.swdma_mask	= ATA_SWDMA2_ONLY,	\
 		.mwdma_mask	= ATA_MWDMA12_ONLY,	\
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index d8a1674..a38ec47 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -523,16 +523,12 @@ static void __devinit it821x_quirkproc(ide_drive_t *drive)
 static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct it821x_dev *idev = kzalloc(sizeof(struct it821x_dev), GFP_KERNEL);
+	struct it821x_dev **itdevs = (struct it821x_dev **)pci_get_drvdata(dev);
+	struct it821x_dev *idev = itdevs[hwif->channel];
 	u8 conf;
 
 	hwif->quirkproc = &it821x_quirkproc;
 
-	if (idev == NULL) {
-		printk(KERN_ERR "it821x: out of memory, falling back to legacy behaviour.\n");
-		return;
-	}
-
 	ide_set_hwifdata(hwif, idev);
 
 	pci_read_config_byte(dev, 0x50, &conf);
@@ -623,7 +619,6 @@ static unsigned int __devinit init_chipset_it821x(struct pci_dev *dev, const cha
 		.name		= name_str,		\
 		.init_chipset	= init_chipset_it821x,	\
 		.init_hwif	= init_hwif_it821x,	\
-		.host_flags	= IDE_HFLAG_BOOTABLE,	\
 		.pio_mask	= ATA_PIO4,		\
 	}
 
@@ -642,6 +637,22 @@ static const struct ide_port_info it821x_chipsets[] __devinitdata = {
 
 static int __devinit it821x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
+	struct it821x_dev *itdevs[2] = { NULL, NULL} , *itdev;
+	unsigned int i;
+
+	for (i = 0; i < 2; i++) {
+		itdev = kzalloc(sizeof(*itdev), GFP_KERNEL);
+		if (itdev == NULL) {
+			kfree(itdevs[0]);
+			printk(KERN_ERR "it821x: out of memory\n");
+			return -ENOMEM;
+		}
+
+		itdevs[i] = itdev;
+	}
+
+	pci_set_drvdata(dev, itdevs);
+
 	return ide_setup_pci_device(dev, &it821x_chipsets[id->driver_data]);
 }
 
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index a56bcb4..673f7dc 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -63,8 +63,7 @@ static u8 __devinit ata66_jmicron(ide_hwif_t *hwif)
 	 *	actually do our cable checking etc. Thankfully we don't need
 	 *	to do the plumbing for other cases.
 	 */
-	switch (port_map[port])
-	{
+	switch (port_map[port]) {
 	case PORT_PATA0:
 		if (control & (1 << 3))	/* 40/80 pin primary */
 			return ATA_CBL_PATA40;
@@ -114,7 +113,6 @@ static void __devinit init_hwif_jmicron(ide_hwif_t *hwif)
 static const struct ide_port_info jmicron_chipset __devinitdata = {
 	.name		= "JMB",
 	.init_hwif	= init_hwif_jmicron,
-	.host_flags	= IDE_HFLAG_BOOTABLE,
 	.enablebits	= { { 0x40, 0x01, 0x01 }, { 0x40, 0x10, 0x10 } },
 	.pio_mask	= ATA_PIO5,
 	.mwdma_mask	= ATA_MWDMA2,
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index 7551332..3015d69 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -265,8 +265,7 @@ static const struct ide_port_info ns87415_chipset __devinitdata = {
 #endif
 	.init_hwif	= init_hwif_ns87415,
 	.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
-			  IDE_HFLAG_NO_ATAPI_DMA |
-			  IDE_HFLAG_BOOTABLE,
+			  IDE_HFLAG_NO_ATAPI_DMA,
 };
 
 static int __devinit ns87415_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index 46e8748..88a4dd9 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -57,9 +57,9 @@
  * (use idebus=xx to select PCI bus speed).
  *
  * Version 0.1, Nov 8, 1996
- * by Jaromir Koutek, for 2.1.8. 
+ * by Jaromir Koutek, for 2.1.8.
  * Initial version of driver.
- * 
+ *
  * Version 0.2
  * Number 0.2 skipped.
  *
@@ -75,7 +75,7 @@
  * by Jaromir Koutek
  * Updates for use with (again) new IDE block driver.
  * Update of documentation.
- * 
+ *
  * Version 0.6, Jan 2, 1999
  * by Jaromir Koutek
  * Reversed to version 0.3 of the driver, because
@@ -208,29 +208,34 @@ typedef struct pio_clocks_s {
 
 static void compute_clocks(int pio, pio_clocks_t *clks)
 {
-        if (pio != PIO_NOT_EXIST) {
-        	int adr_setup, data_pls;
+	if (pio != PIO_NOT_EXIST) {
+		int adr_setup, data_pls;
 		int bus_speed = system_bus_clock();
 
- 	       	adr_setup = ide_pio_timings[pio].setup_time;
-  	      	data_pls = ide_pio_timings[pio].active_time;
-	  	clks->address_time = cmpt_clk(adr_setup, bus_speed);
-	     	clks->data_time = cmpt_clk(data_pls, bus_speed);
-     		clks->recovery_time = cmpt_clk(ide_pio_timings[pio].cycle_time
-     			- adr_setup-data_pls, bus_speed);
-     		if (clks->address_time<1) clks->address_time = 1;
-     		if (clks->address_time>4) clks->address_time = 4;
-     		if (clks->data_time<1) clks->data_time = 1;
-     		if (clks->data_time>16) clks->data_time = 16;
-     		if (clks->recovery_time<2) clks->recovery_time = 2;
-     		if (clks->recovery_time>17) clks->recovery_time = 17;
+		adr_setup = ide_pio_timings[pio].setup_time;
+		data_pls = ide_pio_timings[pio].active_time;
+		clks->address_time = cmpt_clk(adr_setup, bus_speed);
+		clks->data_time = cmpt_clk(data_pls, bus_speed);
+		clks->recovery_time = cmpt_clk(ide_pio_timings[pio].cycle_time
+			- adr_setup-data_pls, bus_speed);
+		if (clks->address_time < 1)
+			clks->address_time = 1;
+		if (clks->address_time > 4)
+			clks->address_time = 4;
+		if (clks->data_time < 1)
+			clks->data_time = 1;
+		if (clks->data_time > 16)
+			clks->data_time = 16;
+		if (clks->recovery_time < 2)
+			clks->recovery_time = 2;
+		if (clks->recovery_time > 17)
+			clks->recovery_time = 17;
 	} else {
 		clks->address_time = 1;
 		clks->data_time = 1;
 		clks->recovery_time = 2;
 		/* minimal values */
 	}
- 
 }
 
 static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -247,8 +252,8 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 	/* sets drive->drive_data for both drives */
 	compute_pios(drive, pio);
- 	pio1 = hwif->drives[0].drive_data;
- 	pio2 = hwif->drives[1].drive_data;
+	pio1 = hwif->drives[0].drive_data;
+	pio2 = hwif->drives[1].drive_data;
 
 	compute_clocks(pio1, &first);
 	compute_clocks(pio2, &second);
@@ -275,7 +280,7 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 	spin_lock_irqsave(&opti621_lock, flags);
 
-     	reg_base = hwif->io_ports[IDE_DATA_OFFSET];
+	reg_base = hwif->io_ports[IDE_DATA_OFFSET];
 
 	/* allow Register-B */
 	outb(0xc0, reg_base + CNTRL_REG);
@@ -324,7 +329,7 @@ static void __devinit opti621_port_init_devs(ide_hwif_t *hwif)
 /*
  * init_hwif_opti621() is called once for each hwif found at boot.
  */
-static void __devinit init_hwif_opti621 (ide_hwif_t *hwif)
+static void __devinit init_hwif_opti621(ide_hwif_t *hwif)
 {
 	hwif->port_init_devs = opti621_port_init_devs;
 	hwif->set_pio_mode = &opti621_set_pio_mode;
@@ -334,18 +339,16 @@ static const struct ide_port_info opti621_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "OPTI621",
 		.init_hwif	= init_hwif_opti621,
-		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
-				  IDE_HFLAG_BOOTABLE,
+		.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 		.pio_mask	= ATA_PIO3,
 		.swdma_mask	= ATA_SWDMA2,
 		.mwdma_mask	= ATA_MWDMA2,
-	},{	/* 1 */
+	}, {	/* 1 */
 		.name		= "OPTI621X",
 		.init_hwif	= init_hwif_opti621,
-		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
-				  IDE_HFLAG_BOOTABLE,
+		.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 		.pio_mask	= ATA_PIO3,
 		.swdma_mask	= ATA_SWDMA2,
 		.mwdma_mask	= ATA_MWDMA2,
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index decef0f..89d74ff 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -307,9 +307,9 @@ static void __devinit init_hwif_ich(ide_hwif_t *hwif)
 }
 
 #ifndef CONFIG_IA64
- #define IDE_HFLAGS_PIIX (IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE)
+ #define IDE_HFLAGS_PIIX IDE_HFLAG_LEGACY_IRQS
 #else
- #define IDE_HFLAGS_PIIX IDE_HFLAG_BOOTABLE
+ #define IDE_HFLAGS_PIIX 0
 #endif
 
 #define DECLARE_PIIX_DEV(name_str, udma) \
diff --git a/drivers/ide/pci/rz1000.c b/drivers/ide/pci/rz1000.c
index 5167661..532154a 100644
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -43,7 +43,7 @@ static const struct ide_port_info rz1000_chipset __devinitdata = {
 	.name		= "RZ100x",
 	.init_hwif	= init_hwif_rz1000,
 	.chipset	= ide_rz1000,
-	.host_flags	= IDE_HFLAG_NO_DMA | IDE_HFLAG_BOOTABLE,
+	.host_flags	= IDE_HFLAG_NO_DMA,
 };
 
 static int __devinit rz1000_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index 561aa47..44985c8 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -307,8 +307,7 @@ static const struct ide_port_info sc1200_chipset __devinitdata = {
 	.init_hwif	= init_hwif_sc1200,
 	.host_flags	= IDE_HFLAG_SERIALIZE |
 			  IDE_HFLAG_POST_SET_MODE |
-			  IDE_HFLAG_ABUSE_DMA_MODES |
-			  IDE_HFLAG_BOOTABLE,
+			  IDE_HFLAG_ABUSE_DMA_MODES,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA2,
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index ef07c7a..5214579 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -65,7 +65,7 @@
 
 static struct scc_ports {
 	unsigned long ctl, dma;
-	unsigned char hwif_id;  /* for removing hwif from system */
+	ide_hwif_t *hwif;  /* for removing port from system */
 } scc_ports[MAX_HWIFS];
 
 /* PIO transfer mode  table */
@@ -534,12 +534,8 @@ static int scc_ide_setup_pci_device(struct pci_dev *dev,
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	int i;
 
-	for (i = 0; i < MAX_HWIFS; i++) {
-		hwif = &ide_hwifs[i];
-		if (hwif->chipset == ide_unknown)
-			break; /* pick an unused entry */
-	}
-	if (i == MAX_HWIFS) {
+	hwif = ide_find_port();
+	if (hwif == NULL) {
 		printk(KERN_ERR "%s: too many IDE interfaces, "
 				"no room in table\n", SCC_PATA_NAME);
 		return -ENOMEM;
@@ -696,7 +692,7 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 {
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
 
-	ports->hwif_id = hwif->index;
+	ports->hwif = hwif;
 
 	hwif->dma_command = hwif->dma_base;
 	hwif->dma_status = hwif->dma_base + 0x04;
@@ -725,8 +721,7 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
       .name		= name_str,			\
       .init_iops	= init_iops_scc,		\
       .init_hwif	= init_hwif_scc,		\
-      .host_flags	= IDE_HFLAG_SINGLE |		\
-			  IDE_HFLAG_BOOTABLE,		\
+      .host_flags	= IDE_HFLAG_SINGLE,		\
       .pio_mask		= ATA_PIO4,			\
   }
 
@@ -758,7 +753,7 @@ static int __devinit scc_init_one(struct pci_dev *dev, const struct pci_device_i
 static void __devexit scc_remove(struct pci_dev *dev)
 {
 	struct scc_ports *ports = pci_get_drvdata(dev);
-	ide_hwif_t *hwif = &ide_hwifs[ports->hwif_id];
+	ide_hwif_t *hwif = ports->hwif;
 	unsigned long ctl_base = pci_resource_start(dev, 0);
 	unsigned long dma_base = pci_resource_start(dev, 1);
 	unsigned long ctl_size = pci_resource_len(dev, 0);
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index c11880b..cfe9274 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -350,8 +350,7 @@ static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 
 #define IDE_HFLAGS_SVWKS \
 	(IDE_HFLAG_LEGACY_IRQS | \
-	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
-	 IDE_HFLAG_BOOTABLE)
+	 IDE_HFLAG_ABUSE_SET_DMA_MODE)
 
 static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 	{	/* 0 */
@@ -418,7 +417,7 @@ static int __devinit svwks_init_one(struct pci_dev *dev, const struct pci_device
 	else if (idx == 2 || idx == 3) {
 		if ((PCI_FUNC(dev->devfn) & 1) == 0) {
 			if (pci_resource_start(dev, 0) != 0x01f1)
-				d.host_flags &= ~IDE_HFLAG_BOOTABLE;
+				d.host_flags |= IDE_HFLAG_NON_BOOTABLE;
 			d.host_flags |= IDE_HFLAG_SINGLE;
 		} else
 			d.host_flags &= ~IDE_HFLAG_SINGLE;
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 9d1a303..6bd9523 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -590,20 +590,12 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	unsigned long bar0, cmd_phys_base, ctl;
 	void __iomem *virt_base;
 	ide_hwif_t *hwif;
-	int h;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw;
 	struct ide_port_info d = sgiioc4_port_info;
 
-	/*
-	 * Find an empty HWIF; if none available, return -ENOMEM.
-	 */
-	for (h = 0; h < MAX_HWIFS; ++h) {
-		hwif = &ide_hwifs[h];
-		if (hwif->chipset == ide_unknown)
-			break;
-	}
-	if (h == MAX_HWIFS) {
+	hwif = ide_find_port();
+	if (hwif == NULL) {
 		printk(KERN_ERR "%s: too many IDE interfaces, no room in table\n",
 				DRV_NAME);
 		return -ENOMEM;
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index b6be1b4..c9ecab8 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -808,7 +808,6 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 		.init_chipset	= init_chipset_siimage,	\
 		.init_iops	= init_iops_siimage,	\
 		.init_hwif	= init_hwif_siimage,	\
-		.host_flags	= IDE_HFLAG_BOOTABLE,	\
 		.pio_mask	= ATA_PIO4,		\
 		.mwdma_mask	= ATA_MWDMA2,		\
 		.udma_mask	= ATA_UDMA6,		\
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 512bb4c..181b647 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -59,10 +59,10 @@
 #define ATA_16		0x01
 #define ATA_33		0x02
 #define ATA_66		0x03
-#define ATA_100a	0x04 // SiS730/SiS550 is ATA100 with ATA66 layout
+#define ATA_100a	0x04 /* SiS730/SiS550 is ATA100 with ATA66 layout */
 #define ATA_100		0x05
-#define ATA_133a	0x06 // SiS961b with 133 support
-#define ATA_133		0x07 // SiS962/963
+#define ATA_133a	0x06 /* SiS961b with 133 support */
+#define ATA_133		0x07 /* SiS962/963 */
 
 static u8 chipset_family;
 
@@ -111,69 +111,70 @@ static const struct {
    Indexed by chipset_family and (dma_mode - XFER_UDMA_0) */
 
 /* {0, ATA_16, ATA_33, ATA_66, ATA_100a, ATA_100, ATA_133} */
-static u8 cycle_time_offset[] = {0,0,5,4,4,0,0};
-static u8 cycle_time_range[] = {0,0,2,3,3,4,4};
+static u8 cycle_time_offset[] = { 0, 0, 5, 4, 4, 0, 0 };
+static u8 cycle_time_range[]  = { 0, 0, 2, 3, 3, 4, 4 };
 static u8 cycle_time_value[][XFER_UDMA_6 - XFER_UDMA_0 + 1] = {
-	{0,0,0,0,0,0,0}, /* no udma */
-	{0,0,0,0,0,0,0}, /* no udma */
-	{3,2,1,0,0,0,0}, /* ATA_33 */
-	{7,5,3,2,1,0,0}, /* ATA_66 */
-	{7,5,3,2,1,0,0}, /* ATA_100a (730 specific), differences are on cycle_time range and offset */
-	{11,7,5,4,2,1,0}, /* ATA_100 */
-	{15,10,7,5,3,2,1}, /* ATA_133a (earliest 691 southbridges) */
-	{15,10,7,5,3,2,1}, /* ATA_133 */
+	{  0,  0, 0, 0, 0, 0, 0 }, /* no UDMA */
+	{  0,  0, 0, 0, 0, 0, 0 }, /* no UDMA */
+	{  3,  2, 1, 0, 0, 0, 0 }, /* ATA_33 */
+	{  7,  5, 3, 2, 1, 0, 0 }, /* ATA_66 */
+	{  7,  5, 3, 2, 1, 0, 0 }, /* ATA_100a (730 specific),
+				      different cycle_time range and offset */
+	{ 11,  7, 5, 4, 2, 1, 0 }, /* ATA_100 */
+	{ 15, 10, 7, 5, 3, 2, 1 }, /* ATA_133a (earliest 691 southbridges) */
+	{ 15, 10, 7, 5, 3, 2, 1 }, /* ATA_133 */
 };
 /* CRC Valid Setup Time vary across IDE clock setting 33/66/100/133
    See SiS962 data sheet for more detail */
 static u8 cvs_time_value[][XFER_UDMA_6 - XFER_UDMA_0 + 1] = {
-	{0,0,0,0,0,0,0}, /* no udma */
-	{0,0,0,0,0,0,0}, /* no udma */
-	{2,1,1,0,0,0,0},
-	{4,3,2,1,0,0,0},
-	{4,3,2,1,0,0,0},
-	{6,4,3,1,1,1,0},
-	{9,6,4,2,2,2,2},
-	{9,6,4,2,2,2,2},
+	{ 0, 0, 0, 0, 0, 0, 0 }, /* no UDMA */
+	{ 0, 0, 0, 0, 0, 0, 0 }, /* no UDMA */
+	{ 2, 1, 1, 0, 0, 0, 0 },
+	{ 4, 3, 2, 1, 0, 0, 0 },
+	{ 4, 3, 2, 1, 0, 0, 0 },
+	{ 6, 4, 3, 1, 1, 1, 0 },
+	{ 9, 6, 4, 2, 2, 2, 2 },
+	{ 9, 6, 4, 2, 2, 2, 2 },
 };
 /* Initialize time, Active time, Recovery time vary across
    IDE clock settings. These 3 arrays hold the register value
    for PIO0/1/2/3/4 and DMA0/1/2 mode in order */
 static u8 ini_time_value[][8] = {
-	{0,0,0,0,0,0,0,0},
-	{0,0,0,0,0,0,0,0},
-	{2,1,0,0,0,1,0,0},
-	{4,3,1,1,1,3,1,1},
-	{4,3,1,1,1,3,1,1},
-	{6,4,2,2,2,4,2,2},
-	{9,6,3,3,3,6,3,3},
-	{9,6,3,3,3,6,3,3},
+	{ 0, 0, 0, 0, 0, 0, 0, 0 },
+	{ 0, 0, 0, 0, 0, 0, 0, 0 },
+	{ 2, 1, 0, 0, 0, 1, 0, 0 },
+	{ 4, 3, 1, 1, 1, 3, 1, 1 },
+	{ 4, 3, 1, 1, 1, 3, 1, 1 },
+	{ 6, 4, 2, 2, 2, 4, 2, 2 },
+	{ 9, 6, 3, 3, 3, 6, 3, 3 },
+	{ 9, 6, 3, 3, 3, 6, 3, 3 },
 };
 static u8 act_time_value[][8] = {
-	{0,0,0,0,0,0,0,0},
-	{0,0,0,0,0,0,0,0},
-	{9,9,9,2,2,7,2,2},
-	{19,19,19,5,4,14,5,4},
-	{19,19,19,5,4,14,5,4},
-	{28,28,28,7,6,21,7,6},
-	{38,38,38,10,9,28,10,9},
-	{38,38,38,10,9,28,10,9},
+	{  0,  0,  0,  0, 0,  0,  0, 0 },
+	{  0,  0,  0,  0, 0,  0,  0, 0 },
+	{  9,  9,  9,  2, 2,  7,  2, 2 },
+	{ 19, 19, 19,  5, 4, 14,  5, 4 },
+	{ 19, 19, 19,  5, 4, 14,  5, 4 },
+	{ 28, 28, 28,  7, 6, 21,  7, 6 },
+	{ 38, 38, 38, 10, 9, 28, 10, 9 },
+	{ 38, 38, 38, 10, 9, 28, 10, 9 },
 };
 static u8 rco_time_value[][8] = {
-	{0,0,0,0,0,0,0,0},
-	{0,0,0,0,0,0,0,0},
-	{9,2,0,2,0,7,1,1},
-	{19,5,1,5,2,16,3,2},
-	{19,5,1,5,2,16,3,2},
-	{30,9,3,9,4,25,6,4},
-	{40,12,4,12,5,34,12,5},
-	{40,12,4,12,5,34,12,5},
+	{  0,  0, 0,  0, 0,  0,  0, 0 },
+	{  0,  0, 0,  0, 0,  0,  0, 0 },
+	{  9,  2, 0,  2, 0,  7,  1, 1 },
+	{ 19,  5, 1,  5, 2, 16,  3, 2 },
+	{ 19,  5, 1,  5, 2, 16,  3, 2 },
+	{ 30,  9, 3,  9, 4, 25,  6, 4 },
+	{ 40, 12, 4, 12, 5, 34, 12, 5 },
+	{ 40, 12, 4, 12, 5, 34, 12, 5 },
 };
 
 /*
  * Printing configuration
  */
 /* Used for chipset type printing at boot time */
-static char* chipset_capability[] = {
+static char *chipset_capability[] = {
 	"ATA", "ATA 16",
 	"ATA 33", "ATA 66",
 	"ATA 100 (1st gen)", "ATA 100 (2nd gen)",
@@ -272,7 +273,7 @@ static void sis_program_timings(ide_drive_t *drive, const u8 mode)
 		sis_ata133_program_timings(drive, mode);
 }
 
-static void config_drive_art_rwp (ide_drive_t *drive)
+static void config_drive_art_rwp(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
@@ -358,8 +359,7 @@ static u8 sis5513_ata133_udma_filter(ide_drive_t *drive)
 	return (regdw & 0x08) ? ATA_UDMA6 : ATA_UDMA5;
 }
 
-/* Chip detection and general config */
-static unsigned int __devinit init_chipset_sis5513 (struct pci_dev *dev, const char *name)
+static int __devinit sis_find_family(struct pci_dev *dev)
 {
 	struct pci_dev *host;
 	int i = 0;
@@ -381,7 +381,7 @@ static unsigned int __devinit init_chipset_sis5513 (struct pci_dev *dev, const c
 				chipset_family = ATA_100a;
 		}
 		pci_dev_put(host);
-	
+
 		printk(KERN_INFO "SIS5513: %s %s controller\n",
 			 SiSHostChipInfo[i].name, chipset_capability[chipset_family]);
 	}
@@ -440,63 +440,60 @@ static unsigned int __devinit init_chipset_sis5513 (struct pci_dev *dev, const c
 			}
 	}
 
-	if (!chipset_family)
-		return -1;
+	return chipset_family;
+}
 
+static unsigned int __devinit init_chipset_sis5513(struct pci_dev *dev,
+						   const char *name)
+{
 	/* Make general config ops here
 	   1/ tell IDE channels to operate in Compatibility mode only
 	   2/ tell old chips to allow per drive IDE timings */
 
-	{
-		u8 reg;
-		u16 regw;
-
-		switch(chipset_family) {
-			case ATA_133:
-				/* SiS962 operation mode */
-				pci_read_config_word(dev, 0x50, &regw);
-				if (regw & 0x08)
-					pci_write_config_word(dev, 0x50, regw&0xfff7);
-				pci_read_config_word(dev, 0x52, &regw);
-				if (regw & 0x08)
-					pci_write_config_word(dev, 0x52, regw&0xfff7);
-				break;
-			case ATA_133a:
-			case ATA_100:
-				/* Fixup latency */
-				pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x80);
-				/* Set compatibility bit */
-				pci_read_config_byte(dev, 0x49, &reg);
-				if (!(reg & 0x01)) {
-					pci_write_config_byte(dev, 0x49, reg|0x01);
-				}
-				break;
-			case ATA_100a:
-			case ATA_66:
-				/* Fixup latency */
-				pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x10);
-
-				/* On ATA_66 chips the bit was elsewhere */
-				pci_read_config_byte(dev, 0x52, &reg);
-				if (!(reg & 0x04)) {
-					pci_write_config_byte(dev, 0x52, reg|0x04);
-				}
-				break;
-			case ATA_33:
-				/* On ATA_33 we didn't have a single bit to set */
-				pci_read_config_byte(dev, 0x09, &reg);
-				if ((reg & 0x0f) != 0x00) {
-					pci_write_config_byte(dev, 0x09, reg&0xf0);
-				}
-			case ATA_16:
-				/* force per drive recovery and active timings
-				   needed on ATA_33 and below chips */
-				pci_read_config_byte(dev, 0x52, &reg);
-				if (!(reg & 0x08)) {
-					pci_write_config_byte(dev, 0x52, reg|0x08);
-				}
-				break;
-		}
+	u8 reg;
+	u16 regw;
+
+	switch (chipset_family) {
+	case ATA_133:
+		/* SiS962 operation mode */
+		pci_read_config_word(dev, 0x50, &regw);
+		if (regw & 0x08)
+			pci_write_config_word(dev, 0x50, regw&0xfff7);
+		pci_read_config_word(dev, 0x52, &regw);
+		if (regw & 0x08)
+			pci_write_config_word(dev, 0x52, regw&0xfff7);
+		break;
+	case ATA_133a:
+	case ATA_100:
+		/* Fixup latency */
+		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x80);
+		/* Set compatibility bit */
+		pci_read_config_byte(dev, 0x49, &reg);
+		if (!(reg & 0x01))
+			pci_write_config_byte(dev, 0x49, reg|0x01);
+		break;
+	case ATA_100a:
+	case ATA_66:
+		/* Fixup latency */
+		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x10);
+
+		/* On ATA_66 chips the bit was elsewhere */
+		pci_read_config_byte(dev, 0x52, &reg);
+		if (!(reg & 0x04))
+			pci_write_config_byte(dev, 0x52, reg|0x04);
+		break;
+	case ATA_33:
+		/* On ATA_33 we didn't have a single bit to set */
+		pci_read_config_byte(dev, 0x09, &reg);
+		if ((reg & 0x0f) != 0x00)
+			pci_write_config_byte(dev, 0x09, reg&0xf0);
+	case ATA_16:
+		/* force per drive recovery and active timings
+		   needed on ATA_33 and below chips */
+		pci_read_config_byte(dev, 0x52, &reg);
+		if (!(reg & 0x08))
+			pci_write_config_byte(dev, 0x52, reg|0x08);
+		break;
 	}
 
 	return 0;
@@ -546,10 +543,8 @@ static u8 __devinit ata66_sis5513(ide_hwif_t *hwif)
 	return ata66 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
-static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
+static void __devinit init_hwif_sis5513(ide_hwif_t *hwif)
 {
-	u8 udma_rates[] = { 0x00, 0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f };
-
 	hwif->set_pio_mode = &sis_set_pio_mode;
 	hwif->set_dma_mode = &sis_set_dma_mode;
 
@@ -557,27 +552,29 @@ static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
 		hwif->udma_filter = sis5513_ata133_udma_filter;
 
 	hwif->cable_detect = ata66_sis5513;
-
-	if (hwif->dma_base == 0)
-		return;
-
-	hwif->ultra_mask = udma_rates[chipset_family];
 }
 
 static const struct ide_port_info sis5513_chipset __devinitdata = {
 	.name		= "SIS5513",
 	.init_chipset	= init_chipset_sis5513,
 	.init_hwif	= init_hwif_sis5513,
-	.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
-	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_NO_AUTODMA |
-			  IDE_HFLAG_BOOTABLE,
+	.enablebits	= { {0x4a, 0x02, 0x02}, {0x4a, 0x04, 0x04} },
+	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_NO_AUTODMA,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 };
 
 static int __devinit sis5513_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &sis5513_chipset);
+	struct ide_port_info d = sis5513_chipset;
+	u8 udma_rates[] = { 0x00, 0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f };
+
+	if (sis_find_family(dev) == 0)
+		return -ENOTSUPP;
+
+	d.udma_mask = udma_rates[chipset_family];
+
+	return ide_setup_pci_device(dev, &d);
 }
 
 static const struct pci_device_id sis5513_pci_tbl[] = {
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index 1f00251..40b3eeb 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -332,8 +332,7 @@ static const struct ide_port_info sl82c105_chipset __devinitdata = {
 #if defined(CONFIG_LOPEC) || defined(CONFIG_SANDPOINT)
 			  IDE_HFLAG_FORCE_LEGACY_IRQS |
 #endif
-			  IDE_HFLAG_NO_AUTODMA |
-			  IDE_HFLAG_BOOTABLE,
+			  IDE_HFLAG_NO_AUTODMA,
 	.pio_mask	= ATA_PIO5,
 };
 
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index 65f4c2f..eab557c 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -27,9 +27,9 @@ static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	unsigned long flags;
 	u16 master_data;
 	u8 slave_data;
- 	int control = 0;
+	int control = 0;
 				     /* ISP  RTC */
-	static const u8 timings[][2]= {
+	static const u8 timings[][2] = {
 					{ 0, 0 },
 					{ 0, 0 },
 					{ 1, 0 },
@@ -136,8 +136,8 @@ static void __devinit init_hwif_slc90e66(ide_hwif_t *hwif)
 static const struct ide_port_info slc90e66_chipset __devinitdata = {
 	.name		= "SLC90E66",
 	.init_hwif	= init_hwif_slc90e66,
-	.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}},
-	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE,
+	.enablebits	= { {0x41, 0x80, 0x80}, {0x43, 0x80, 0x80} },
+	.host_flags	= IDE_HFLAG_LEGACY_IRQS,
 	.pio_mask	= ATA_PIO4,
 	.swdma_mask	= ATA_SWDMA2_ONLY,
 	.mwdma_mask	= ATA_MWDMA12_ONLY,
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index 1e4a626..c154351 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -18,20 +18,20 @@ static void tc86c001_set_mode(ide_drive_t *drive, const u8 speed)
 	u16 mode, scr		= inw(scr_port);
 
 	switch (speed) {
-		case XFER_UDMA_4:	mode = 0x00c0; break;
-		case XFER_UDMA_3:	mode = 0x00b0; break;
-		case XFER_UDMA_2:	mode = 0x00a0; break;
-		case XFER_UDMA_1:	mode = 0x0090; break;
-		case XFER_UDMA_0:	mode = 0x0080; break;
-		case XFER_MW_DMA_2:	mode = 0x0070; break;
-		case XFER_MW_DMA_1:	mode = 0x0060; break;
-		case XFER_MW_DMA_0:	mode = 0x0050; break;
-		case XFER_PIO_4:	mode = 0x0400; break;
-		case XFER_PIO_3:	mode = 0x0300; break;
-		case XFER_PIO_2:	mode = 0x0200; break;
-		case XFER_PIO_1:	mode = 0x0100; break;
-		case XFER_PIO_0:
-		default:		mode = 0x0000; break;
+	case XFER_UDMA_4:	mode = 0x00c0; break;
+	case XFER_UDMA_3:	mode = 0x00b0; break;
+	case XFER_UDMA_2:	mode = 0x00a0; break;
+	case XFER_UDMA_1:	mode = 0x0090; break;
+	case XFER_UDMA_0:	mode = 0x0080; break;
+	case XFER_MW_DMA_2:	mode = 0x0070; break;
+	case XFER_MW_DMA_1:	mode = 0x0060; break;
+	case XFER_MW_DMA_0:	mode = 0x0050; break;
+	case XFER_PIO_4:	mode = 0x0400; break;
+	case XFER_PIO_3:	mode = 0x0300; break;
+	case XFER_PIO_2:	mode = 0x0200; break;
+	case XFER_PIO_1:	mode = 0x0100; break;
+	case XFER_PIO_0:
+	default:		mode = 0x0000; break;
 	}
 
 	scr &= (speed < XFER_MW_DMA_0) ? 0xf8ff : 0xff0f;
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index a67d02a..3316b19 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -97,7 +97,6 @@ static const struct ide_port_info triflex_device __devinitdata = {
 	.name		= "TRIFLEX",
 	.init_hwif	= init_hwif_triflex,
 	.enablebits	= {{0x80, 0x01, 0x01}, {0x80, 0x02, 0x02}},
-	.host_flags	= IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO4,
 	.swdma_mask	= ATA_SWDMA2,
 	.mwdma_mask	= ATA_MWDMA2,
diff --git a/drivers/ide/pci/trm290.c b/drivers/ide/pci/trm290.c
index de750f7..2b8f3a2 100644
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -337,7 +337,6 @@ static const struct ide_port_info trm290_chipset __devinitdata = {
 			  IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 #endif
 			  IDE_HFLAG_NO_AUTODMA |
-			  IDE_HFLAG_BOOTABLE |
 			  IDE_HFLAG_NO_LBA48,
 };
 
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index 9004e75..cff3caf 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -429,11 +429,9 @@ static const struct ide_port_info via82cxxx_chipset __devinitdata = {
 	.init_hwif	= init_hwif_via82cxxx,
 	.enablebits	= { { 0x40, 0x02, 0x02 }, { 0x40, 0x01, 0x01 } },
 	.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |
-			  IDE_HFLAG_PIO_NO_DOWNGRADE |
 			  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 			  IDE_HFLAG_POST_SET_MODE |
-			  IDE_HFLAG_IO_32BIT |
-			  IDE_HFLAG_BOOTABLE,
+			  IDE_HFLAG_IO_32BIT,
 	.pio_mask	= ATA_PIO5,
 	.swdma_mask	= ATA_SWDMA2,
 	.mwdma_mask	= ATA_MWDMA2,
diff --git a/drivers/ide/ppc/mpc8xx.c b/drivers/ide/ppc/mpc8xx.c
index a784a97..467656f 100644
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -36,6 +36,8 @@
 #include <asm/machdep.h>
 #include <asm/irq.h>
 
+#define DRV_NAME "ide-mpc8xx"
+
 static int identify  (volatile u8 *p);
 static void print_fixed (volatile u8 *p);
 static void print_funcid (int func);
@@ -127,7 +129,7 @@ static int pcmcia_schlvl = PCMCIA_SCHLVL;
  * MPC8xx's internal PCMCIA interface
  */
 #if defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_DIRECT)
-static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
+static int __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 {
 	unsigned long *p = hw->io_ports;
 	int i;
@@ -182,6 +184,13 @@ static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 			pcmcia_phy_base, pcmcia_phy_end,
 			pcmcia_phy_end - pcmcia_phy_base);
 
+		if (!request_mem_region(pcmcia_phy_base,
+					pcmcia_phy_end - pcmcia_phy_base,
+					DRV_NAME)) {
+			printk(KERN_ERR "%s: resources busy\n", DRV_NAME);
+			return -EBUSY;
+		}
+
 		pcmcia_base=(unsigned long)ioremap(pcmcia_phy_base,
 						   pcmcia_phy_end-pcmcia_phy_base);
 
@@ -236,7 +245,7 @@ static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 	if (pcmp->pcmc_pipr & (M8XX_PCMCIA_CD1(_slot_)|M8XX_PCMCIA_CD2(_slot_))) {
 		printk ("No card in slot %c: PIPR=%08x\n",
 			'A' + _slot_, (u32) pcmp->pcmc_pipr);
-		return;		/* No card in slot */
+		return -ENODEV;		/* No card in slot */
 	}
 
 	check_ide_device (pcmcia_base);
@@ -279,9 +288,6 @@ static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 	}
 #endif	/* CONFIG_IDE_8xx_PCCARD */
 
-	ide_hwifs[data_port].pio_mask = ATA_PIO4;
-	ide_hwifs[data_port].set_pio_mode = m8xx_ide_set_pio_mode;
-
 	/* Enable Harddisk Interrupt,
 	 * and make it edge sensitive
 	 */
@@ -296,6 +302,8 @@ static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 	/* Enable falling edge irq */
 	pcmp->pcmc_per = 0x100000 >> (16 * _slot_);
 #endif	/* CONFIG_IDE_8xx_PCCARD */
+
+	return 0;
 }
 #endif /* CONFIG_IDE_8xx_PCCARD || CONFIG_IDE_8xx_DIRECT */
 
@@ -304,7 +312,7 @@ static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
  * MPC8xx's internal PCMCIA interface
  */
 #if defined(CONFIG_IDE_EXT_DIRECT)
-static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
+static int __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 {
 	unsigned long *p = hw->io_ports;
 	int i;
@@ -327,7 +335,12 @@ static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 		printk ("IDE phys mem : %08x...%08x (size %08x)\n",
 			ide_phy_base, ide_phy_end,
 			ide_phy_end - ide_phy_base);
-		
+
+		if (!request_mem_region(ide_phy_base, 0x200, DRV_NAME)) {
+			printk(KERN_ERR "%s: resources busy\n", DRV_NAME);
+			return -EBUSY;
+		}
+
 		ide_base=(unsigned long)ioremap(ide_phy_base,
 						ide_phy_end-ide_phy_base);
 
@@ -357,15 +370,14 @@ static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 	hw->irq = ioport_dsc[data_port].irq;
 	hw->ack_intr = (ide_ack_intr_t *)ide_interrupt_ack;
 
-	ide_hwifs[data_port].pio_mask = ATA_PIO4;
-	ide_hwifs[data_port].set_pio_mode = m8xx_ide_set_pio_mode;
-
 	/* Enable Harddisk Interrupt,
 	 * and make it edge sensitive
 	 */
 	/* (11-18) Set edge detect for irq, no wakeup from low power mode */
 	((immap_t *) IMAP_ADDR)->im_siu_conf.sc_siel |=
 			(0x80000000 >> ioport_dsc[data_port].irq);
+
+	return 0;
 }
 #endif	/* CONFIG_IDE_8xx_DIRECT */
 
@@ -794,14 +806,28 @@ static int __init mpc8xx_ide_probe(void)
 
 #ifdef IDE0_BASE_OFFSET
 	memset(&hw, 0, sizeof(hw));
-	m8xx_ide_init_ports(&hw, 0);
-	ide_init_port_hw(&ide_hwifs[0], &hw);
-	idx[0] = 0;
+	if (!m8xx_ide_init_ports(&hw, 0)) {
+		ide_hwif_t *hwif = &ide_hwifs[0];
+
+		ide_init_port_hw(hwif, &hw);
+		hwif->mmio = 1;
+		hwif->pio_mask = ATA_PIO4;
+		hwif->set_pio_mode = m8xx_ide_set_pio_mode;
+
+		idx[0] = 0;
+	}
 #ifdef IDE1_BASE_OFFSET
 	memset(&hw, 0, sizeof(hw));
-	m8xx_ide_init_ports(&hw, 1);
-	ide_init_port_hw(&ide_hwifs[1], &hw);
-	idx[1] = 1;
+	if (!m8xx_ide_init_ports(&hw, 1)) {
+		ide_hwif_t *mate = &ide_hwifs[1];
+
+		ide_init_port_hw(mate, &hw);
+		mate->mmio = 1;
+		mate->pio_mask = ATA_PIO4;
+		mate->set_pio_mode = m8xx_ide_set_pio_mode;
+
+		idx[1] = 1;
+	}
 #endif
 #endif
 
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 88619b5..177961e 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -79,8 +79,6 @@ typedef struct pmac_ide_hwif {
 	
 } pmac_ide_hwif_t;
 
-static pmac_ide_hwif_t pmac_ide[MAX_HWIFS];
-
 enum {
 	controller_ohare,	/* OHare based */
 	controller_heathrow,	/* Heathrow/Paddington */
@@ -923,7 +921,6 @@ pmac_ide_do_resume(ide_hwif_t *hwif)
 static const struct ide_port_info pmac_port_info = {
 	.chipset		= ide_pmac,
 	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
-				  IDE_HFLAG_PIO_NO_DOWNGRADE |
 				  IDE_HFLAG_POST_SET_MODE |
 				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
 				  IDE_HFLAG_UNMASK_IRQS,
@@ -1088,35 +1085,36 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 {
 	void __iomem *base;
 	unsigned long regbase;
-	int irq;
 	ide_hwif_t *hwif;
 	pmac_ide_hwif_t *pmif;
-	int i, rc;
+	int irq, rc;
 	hw_regs_t hw;
 
-	i = 0;
-	while (i < MAX_HWIFS && (ide_hwifs[i].io_ports[IDE_DATA_OFFSET] != 0
-	    || pmac_ide[i].node != NULL))
-		++i;
-	if (i >= MAX_HWIFS) {
+	pmif = kzalloc(sizeof(*pmif), GFP_KERNEL);
+	if (pmif == NULL)
+		return -ENOMEM;
+
+	hwif = ide_find_port();
+	if (hwif == NULL) {
 		printk(KERN_ERR "ide-pmac: MacIO interface attach with no slot\n");
 		printk(KERN_ERR "          %s\n", mdev->ofdev.node->full_name);
-		return -ENODEV;
+		rc = -ENODEV;
+		goto out_free_pmif;
 	}
 
-	pmif = &pmac_ide[i];
-	hwif = &ide_hwifs[i];
-
 	if (macio_resource_count(mdev) == 0) {
-		printk(KERN_WARNING "ide%d: no address for %s\n",
-		       i, mdev->ofdev.node->full_name);
-		return -ENXIO;
+		printk(KERN_WARNING "ide-pmac: no address for %s\n",
+				    mdev->ofdev.node->full_name);
+		rc = -ENXIO;
+		goto out_free_pmif;
 	}
 
 	/* Request memory resource for IO ports */
 	if (macio_request_resource(mdev, 0, "ide-pmac (ports)")) {
-		printk(KERN_ERR "ide%d: can't request mmio resource !\n", i);
-		return -EBUSY;
+		printk(KERN_ERR "ide-pmac: can't request MMIO resource for "
+				"%s!\n", mdev->ofdev.node->full_name);
+		rc = -EBUSY;
+		goto out_free_pmif;
 	}
 			
 	/* XXX This is bogus. Should be fixed in the registry by checking
@@ -1125,8 +1123,8 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	 * where that happens though...
 	 */
 	if (macio_irq_count(mdev) == 0) {
-		printk(KERN_WARNING "ide%d: no intrs for device %s, using 13\n",
-			i, mdev->ofdev.node->full_name);
+		printk(KERN_WARNING "ide-pmac: no intrs for device %s, using "
+				    "13\n", mdev->ofdev.node->full_name);
 		irq = irq_create_mapping(NULL, 13);
 	} else
 		irq = macio_irq(mdev, 0);
@@ -1144,7 +1142,9 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
 	if (macio_resource_count(mdev) >= 2) {
 		if (macio_request_resource(mdev, 1, "ide-pmac (dma)"))
-			printk(KERN_WARNING "ide%d: can't request DMA resource !\n", i);
+			printk(KERN_WARNING "ide-pmac: can't request DMA "
+					    "resource for %s!\n",
+					    mdev->ofdev.node->full_name);
 		else
 			pmif->dma_regs = ioremap(macio_resource_start(mdev, 1), 0x1000);
 	} else
@@ -1166,11 +1166,15 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 			iounmap(pmif->dma_regs);
 			macio_release_resource(mdev, 1);
 		}
-		memset(pmif, 0, sizeof(*pmif));
 		macio_release_resource(mdev, 0);
+		kfree(pmif);
 	}
 
 	return rc;
+
+out_free_pmif:
+	kfree(pmif);
+	return rc;
 }
 
 static int
@@ -1215,7 +1219,7 @@ pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	pmac_ide_hwif_t *pmif;
 	void __iomem *base;
 	unsigned long rbase, rlen;
-	int i, rc;
+	int rc;
 	hw_regs_t hw;
 
 	np = pci_device_to_OF_node(pdev);
@@ -1223,30 +1227,32 @@ pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		printk(KERN_ERR "ide-pmac: cannot find MacIO node for Kauai ATA interface\n");
 		return -ENODEV;
 	}
-	i = 0;
-	while (i < MAX_HWIFS && (ide_hwifs[i].io_ports[IDE_DATA_OFFSET] != 0
-	    || pmac_ide[i].node != NULL))
-		++i;
-	if (i >= MAX_HWIFS) {
+
+	pmif = kzalloc(sizeof(*pmif), GFP_KERNEL);
+	if (pmif == NULL)
+		return -ENOMEM;
+
+	hwif = ide_find_port();
+	if (hwif == NULL) {
 		printk(KERN_ERR "ide-pmac: PCI interface attach with no slot\n");
 		printk(KERN_ERR "          %s\n", np->full_name);
-		return -ENODEV;
+		rc = -ENODEV;
+		goto out_free_pmif;
 	}
 
-	pmif = &pmac_ide[i];
-	hwif = &ide_hwifs[i];
-
 	if (pci_enable_device(pdev)) {
-		printk(KERN_WARNING "ide%i: Can't enable PCI device for %s\n",
-			i, np->full_name);
-		return -ENXIO;
+		printk(KERN_WARNING "ide-pmac: Can't enable PCI device for "
+				    "%s\n", np->full_name);
+		rc = -ENXIO;
+		goto out_free_pmif;
 	}
 	pci_set_master(pdev);
 			
 	if (pci_request_regions(pdev, "Kauai ATA")) {
-		printk(KERN_ERR "ide%d: Cannot obtain PCI resources for %s\n",
-			i, np->full_name);
-		return -ENXIO;
+		printk(KERN_ERR "ide-pmac: Cannot obtain PCI resources for "
+				"%s\n", np->full_name);
+		rc = -ENXIO;
+		goto out_free_pmif;
 	}
 
 	hwif->dev = &pdev->dev;
@@ -1276,11 +1282,15 @@ pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		/* The inteface is released to the common IDE layer */
 		pci_set_drvdata(pdev, NULL);
 		iounmap(base);
-		memset(pmif, 0, sizeof(*pmif));
 		pci_release_regions(pdev);
+		kfree(pmif);
 	}
 
 	return rc;
+
+out_free_pmif:
+	kfree(pmif);
+	return rc;
 }
 
 static int
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index f7ede0e..6302010 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -20,73 +20,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
-
-/**
- *	ide_match_hwif	-	match a PCI IDE against an ide_hwif
- *	@io_base: I/O base of device
- *	@bootable: set if its bootable
- *	@name: name of device
- *
- *	Match a PCI IDE port against an entry in ide_hwifs[],
- *	based on io_base port if possible. Return the matching hwif,
- *	or a new hwif. If we find an error (clashing, out of devices, etc)
- *	return NULL
- *
- *	FIXME: we need to handle mmio matches here too
- */
-
-static ide_hwif_t *ide_match_hwif(unsigned long io_base, u8 bootable, const char *name)
-{
-	int h;
-	ide_hwif_t *hwif;
-
-	/*
-	 * Look for a hwif with matching io_base default value.
-	 * If chipset is "ide_unknown", then claim that hwif slot.
-	 * Otherwise, some other chipset has already claimed it..  :(
-	 */
-	for (h = 0; h < MAX_HWIFS; ++h) {
-		hwif = &ide_hwifs[h];
-		if (hwif->io_ports[IDE_DATA_OFFSET] == io_base) {
-			if (hwif->chipset == ide_unknown)
-				return hwif; /* match */
-			printk(KERN_ERR "%s: port 0x%04lx already claimed by %s\n",
-				name, io_base, hwif->name);
-			return NULL;	/* already claimed */
-		}
-	}
-	/*
-	 * Okay, there is no hwif matching our io_base,
-	 * so we'll just claim an unassigned slot.
-	 * Give preference to claiming other slots before claiming ide0/ide1,
-	 * just in case there's another interface yet-to-be-scanned
-	 * which uses ports 1f0/170 (the ide0/ide1 defaults).
-	 *
-	 * Unless there is a bootable card that does not use the standard
-	 * ports 1f0/170 (the ide0/ide1 defaults). The (bootable) flag.
-	 */
-	if (bootable) {
-		for (h = 0; h < MAX_HWIFS; ++h) {
-			hwif = &ide_hwifs[h];
-			if (hwif->chipset == ide_unknown)
-				return hwif;	/* pick an unused entry */
-		}
-	} else {
-		for (h = 2; h < MAX_HWIFS; ++h) {
-			hwif = ide_hwifs + h;
-			if (hwif->chipset == ide_unknown)
-				return hwif;	/* pick an unused entry */
-		}
-	}
-	for (h = 0; h < 2 && h < MAX_HWIFS; ++h) {
-		hwif = ide_hwifs + h;
-		if (hwif->chipset == ide_unknown)
-			return hwif;	/* pick an unused entry */
-	}
-	printk(KERN_ERR "%s: too many IDE interfaces, no room in table\n", name);
-	return NULL;
-}
-
 /**
  *	ide_setup_pci_baseregs	-	place a PCI IDE controller native
  *	@dev: PCI device of interface to switch native
@@ -94,13 +27,13 @@ static ide_hwif_t *ide_match_hwif(unsigned long io_base, u8 bootable, const char
  *
  *	We attempt to place the PCI interface into PCI native mode. If
  *	we succeed the BARs are ok and the controller is in PCI mode.
- *	Returns 0 on success or an errno code. 
+ *	Returns 0 on success or an errno code.
  *
  *	FIXME: if we program the interface and then fail to set the BARS
  *	we don't switch it back to legacy mode. Do we actually care ??
  */
- 
-static int ide_setup_pci_baseregs (struct pci_dev *dev, const char *name)
+
+static int ide_setup_pci_baseregs(struct pci_dev *dev, const char *name)
 {
 	u8 progif = 0;
 
@@ -207,7 +140,6 @@ void ide_setup_pci_noise(struct pci_dev *dev, const struct ide_port_info *d)
 			 " PCI slot %s\n", d->name, dev->vendor, dev->device,
 			 dev->revision, pci_name(dev));
 }
-
 EXPORT_SYMBOL_GPL(ide_setup_pci_noise);
 
 
@@ -220,7 +152,7 @@ EXPORT_SYMBOL_GPL(ide_setup_pci_noise);
  *	but if that fails then we only need IO space. The PCI code should
  *	have setup the proper resources for us already for controllers in
  *	legacy mode.
- *	
+ *
  *	Returns zero on success or an error code
  */
 
@@ -279,8 +211,8 @@ static int ide_pci_configure(struct pci_dev *dev, const struct ide_port_info *d)
 	 * Maybe the user deliberately *disabled* the device,
 	 * but we'll eventually ignore it again if no drives respond.
 	 */
-	if (ide_setup_pci_baseregs(dev, d->name) || pci_write_config_word(dev, PCI_COMMAND, pcicmd|PCI_COMMAND_IO)) 
-	{
+	if (ide_setup_pci_baseregs(dev, d->name) ||
+	    pci_write_config_word(dev, PCI_COMMAND, pcicmd | PCI_COMMAND_IO)) {
 		printk(KERN_INFO "%s: device disabled (BIOS)\n", d->name);
 		return -ENODEV;
 	}
@@ -301,26 +233,24 @@ static int ide_pci_configure(struct pci_dev *dev, const struct ide_port_info *d)
  *	@d: IDE port info
  *	@bar: BAR number
  *
- *	Checks if a BAR is configured and points to MMIO space. If so
- *	print an error and return an error code. Otherwise return 0
+ *	Checks if a BAR is configured and points to MMIO space. If so,
+ *	return an error code. Otherwise return 0
  */
 
-static int ide_pci_check_iomem(struct pci_dev *dev, const struct ide_port_info *d, int bar)
+static int ide_pci_check_iomem(struct pci_dev *dev, const struct ide_port_info *d,
+			       int bar)
 {
 	ulong flags = pci_resource_flags(dev, bar);
-	
+
 	/* Unconfigured ? */
 	if (!flags || pci_resource_len(dev, bar) == 0)
 		return 0;
 
-	/* I/O space */		
-	if(flags & PCI_BASE_ADDRESS_IO_MASK)
+	/* I/O space */
+	if (flags & IORESOURCE_IO)
 		return 0;
-		
+
 	/* Bad */
-	printk(KERN_ERR "%s: IO baseregs (BIOS) are reported "
-			"as MEM, report to "
-			"<andre@linux-ide.org>.\n", d->name);
 	return -EINVAL;
 }
 
@@ -344,14 +274,16 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
 {
 	unsigned long ctl = 0, base = 0;
 	ide_hwif_t *hwif;
-	u8 bootable = (d->host_flags & IDE_HFLAG_BOOTABLE) ? 1 : 0;
 	struct hw_regs_s hw;
 
 	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
-		/*  Possibly we should fail if these checks report true */
-		ide_pci_check_iomem(dev, d, 2*port);
-		ide_pci_check_iomem(dev, d, 2*port+1);
- 
+		if (ide_pci_check_iomem(dev, d, 2 * port) ||
+		    ide_pci_check_iomem(dev, d, 2 * port + 1)) {
+			printk(KERN_ERR "%s: I/O baseregs (BIOS) are reported "
+					"as MEM for port %d!\n", d->name, port);
+			return NULL;
+		}
+
 		ctl  = pci_resource_start(dev, 2*port+1);
 		base = pci_resource_start(dev, 2*port);
 		if ((ctl && !base) || (base && !ctl)) {
@@ -360,14 +292,18 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
 			return NULL;
 		}
 	}
-	if (!ctl)
-	{
+	if (!ctl) {
 		/* Use default values */
 		ctl = port ? 0x374 : 0x3f4;
 		base = port ? 0x170 : 0x1f0;
 	}
-	if ((hwif = ide_match_hwif(base, bootable, d->name)) == NULL)
-		return NULL;	/* no room in ide_hwifs[] */
+
+	hwif = ide_find_port_slot(d);
+	if (hwif == NULL) {
+		printk(KERN_ERR "%s: too many IDE interfaces, no room in "
+				"table\n", d->name);
+		return NULL;
+	}
 
 	memset(&hw, 0, sizeof(hw));
 	hw.irq = irq;
@@ -407,9 +343,9 @@ void ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 		unsigned long dma_base = ide_get_or_set_dma_base(d, hwif);
 		if (dma_base && !(pcicmd & PCI_COMMAND_MASTER)) {
 			/*
- 			 * Set up BM-DMA capability
+			 * Set up BM-DMA capability
 			 * (PnP BIOS should have done this)
- 			 */
+			 */
 			pci_set_master(dev);
 			if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd) || !(pcicmd & PCI_COMMAND_MASTER)) {
 				printk(KERN_ERR "%s: %s error updating PCICMD\n",
@@ -514,7 +450,6 @@ void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d, int
 		*(idx + port) = hwif->index;
 	}
 }
-
 EXPORT_SYMBOL_GPL(ide_pci_setup_ports);
 
 /*
@@ -597,7 +532,6 @@ int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
 
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(ide_setup_pci_device);
 
 int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
@@ -621,5 +555,4 @@ int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
 out:
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(ide_setup_pci_devices);
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index cbb5ccb..bda6f04 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -210,7 +210,6 @@ unifdef-y += hayesesp.h
 unifdef-y += hdlcdrv.h
 unifdef-y += hdlc.h
 unifdef-y += hdreg.h
-unifdef-y += hdsmart.h
 unifdef-y += hid.h
 unifdef-y += hiddev.h
 unifdef-y += hidraw.h
diff --git a/include/linux/hdsmart.h b/include/linux/hdsmart.h
deleted file mode 100644
index 4f4faf9..0000000
--- a/include/linux/hdsmart.h
+++ /dev/null
@@ -1,126 +0,0 @@
-/*
- * linux/include/linux/hdsmart.h
- *
- * Copyright (C) 1999-2000	Michael Cornwell <cornwell@acm.org>
- * Copyright (C) 2000		Andre Hedrick <andre@linux-ide.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * You should have received a copy of the GNU General Public License
- * (for example /usr/src/linux/COPYING); if not, write to the Free
- * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#ifndef _LINUX_HDSMART_H
-#define _LINUX_HDSMART_H
-
-#ifndef __KERNEL__
-#define OFFLINE_FULL_SCAN		0
-#define SHORT_SELF_TEST			1
-#define EXTEND_SELF_TEST		2
-#define SHORT_CAPTIVE_SELF_TEST		129
-#define EXTEND_CAPTIVE_SELF_TEST	130
-
-/* smart_attribute is the vendor specific in SFF-8035 spec */
-typedef struct ata_smart_attribute_s {
-	unsigned char			id;
-	unsigned short			status_flag;
-	unsigned char			normalized;
-	unsigned char			worse_normal;
-	unsigned char			raw[6];
-	unsigned char			reserv;
-} __attribute__ ((packed)) ata_smart_attribute_t;
-
-/* smart_values is format of the read drive Atrribute command */
-typedef struct ata_smart_values_s {
-	unsigned short			revnumber;
-	ata_smart_attribute_t		vendor_attributes [30];
-        unsigned char			offline_data_collection_status;
-        unsigned char			self_test_exec_status;
-	unsigned short			total_time_to_complete_off_line;
-	unsigned char			vendor_specific_366;
-	unsigned char			offline_data_collection_capability;
-	unsigned short			smart_capability;
-	unsigned char			errorlog_capability;
-	unsigned char			vendor_specific_371;
-	unsigned char			short_test_completion_time;
-	unsigned char			extend_test_completion_time;
-	unsigned char			reserved_374_385 [12];
-	unsigned char			vendor_specific_386_509 [125];
-	unsigned char			chksum;
-} __attribute__ ((packed)) ata_smart_values_t;
-
-/* Smart Threshold data structures */
-/* Vendor attribute of SMART Threshold */
-typedef struct ata_smart_threshold_entry_s {
-	unsigned char			id;
-	unsigned char			normalized_threshold;
-	unsigned char			reserved[10];
-} __attribute__ ((packed)) ata_smart_threshold_entry_t;
-
-/* Format of Read SMART THreshold Command */
-typedef struct ata_smart_thresholds_s {
-	unsigned short			revnumber;
-	ata_smart_threshold_entry_t	thres_entries[30];
-	unsigned char			reserved[149];
-	unsigned char			chksum;
-} __attribute__ ((packed)) ata_smart_thresholds_t;
-
-typedef struct ata_smart_errorlog_command_struct_s {
-	unsigned char			devicecontrolreg;
-	unsigned char			featuresreg;
-	unsigned char			sector_count;
-	unsigned char			sector_number;
-	unsigned char			cylinder_low;
-	unsigned char			cylinder_high;
-	unsigned char			drive_head;
-	unsigned char			commandreg;
-	unsigned int			timestamp;
-} __attribute__ ((packed)) ata_smart_errorlog_command_struct_t;
-
-typedef struct ata_smart_errorlog_error_struct_s {
-	unsigned char			error_condition;
-	unsigned char			extended_error[14];
-	unsigned char			state;
-	unsigned short			timestamp;
-} __attribute__ ((packed)) ata_smart_errorlog_error_struct_t;
-
-typedef struct ata_smart_errorlog_struct_s {
-	ata_smart_errorlog_command_struct_t	commands[6];
-	ata_smart_errorlog_error_struct_t	error_struct;
-} __attribute__ ((packed)) ata_smart_errorlog_struct_t;
-
-typedef struct ata_smart_errorlog_s {
-	unsigned char			revnumber;
-	unsigned char			error_log_pointer;
-	ata_smart_errorlog_struct_t	errorlog_struct[5];
-	unsigned short			ata_error_count;
-	unsigned short			non_fatal_count;
-	unsigned short			drive_timeout_count;
-	unsigned char			reserved[53];
-	unsigned char			chksum;
-} __attribute__ ((packed)) ata_smart_errorlog_t;
-
-typedef struct ata_smart_selftestlog_struct_s {
-	unsigned char			selftestnumber;
-	unsigned char			selfteststatus;
-	unsigned short			timestamp;
-	unsigned char			selftestfailurecheckpoint;
-	unsigned int			lbafirstfailure;
-	unsigned char			vendorspecific[15];
-} __attribute__ ((packed)) ata_smart_selftestlog_struct_t;
-
-typedef struct ata_smart_selftestlog_s {
-	unsigned short			revnumber;
-	ata_smart_selftestlog_struct_t	selftest_struct[21];
-	unsigned char			vendorspecific[2];
-	unsigned char			mostrecenttest;
-	unsigned char			resevered[2];
-	unsigned char			chksum;
-} __attribute__ ((packed)) ata_smart_selftestlog_t;
-#endif /* __KERNEL__ */
-
-#endif	/* _LINUX_HDSMART_H */
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 5f3e82a..f20410d 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -170,7 +170,6 @@ typedef struct hw_regs_s {
 	struct device	*dev;
 } hw_regs_t;
 
-struct hwif_s * ide_find_port(unsigned long);
 void ide_init_port_data(struct hwif_s *, unsigned int);
 void ide_init_port_hw(struct hwif_s *, hw_regs_t *);
 
@@ -522,7 +521,6 @@ typedef struct hwif_s {
 	unsigned	reset      : 1;	/* reset after probe */
 	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
 	unsigned	mmio       : 1; /* host uses MMIO */
-	unsigned	straight8  : 1;	/* Alan's straight 8 check */
 
 	struct device		gendev;
 	struct device		*portdev;
@@ -809,6 +807,13 @@ extern	ide_hwif_t	ide_hwifs[];		/* master data repository */
 #endif
 extern int noautodma;
 
+ide_hwif_t *ide_find_port_slot(const struct ide_port_info *);
+
+static inline ide_hwif_t *ide_find_port(void)
+{
+	return ide_find_port_slot(NULL);
+}
+
 extern int ide_end_request (ide_drive_t *drive, int uptodate, int nrsecs);
 int ide_end_dequeued_request(ide_drive_t *drive, struct request *rq,
 			     int uptodate, int nr_sectors);
@@ -1027,8 +1032,8 @@ enum {
 	IDE_HFLAG_SINGLE		= (1 << 1),
 	/* don't use legacy PIO blacklist */
 	IDE_HFLAG_PIO_NO_BLACKLIST	= (1 << 2),
-	/* don't use conservative PIO "downgrade" */
-	IDE_HFLAG_PIO_NO_DOWNGRADE	= (1 << 3),
+	/* set for the second port of QD65xx */
+	IDE_HFLAG_QD_2ND_PORT		= (1 << 3),
 	/* use PIO8/9 for prefetch off/on */
 	IDE_HFLAG_ABUSE_PREFETCH	= (1 << 4),
 	/* use PIO6/7 for fast-devsel off/on */
@@ -1050,8 +1055,8 @@ enum {
 	IDE_HFLAG_VDMA			= (1 << 11),
 	/* ATAPI DMA is unsupported */
 	IDE_HFLAG_NO_ATAPI_DMA		= (1 << 12),
-	/* set if host is a "bootable" controller */
-	IDE_HFLAG_BOOTABLE		= (1 << 13),
+	/* set if host is a "non-bootable" controller */
+	IDE_HFLAG_NON_BOOTABLE		= (1 << 13),
 	/* host doesn't support DMA */
 	IDE_HFLAG_NO_DMA		= (1 << 14),
 	/* check if host is PCI IDE device before allowing DMA */
@@ -1079,8 +1084,6 @@ enum {
 	/* unmask IRQs */
 	IDE_HFLAG_UNMASK_IRQS		= (1 << 25),
 	IDE_HFLAG_ABUSE_SET_DMA_MODE	= (1 << 26),
-	/* host is CY82C693 */
-	IDE_HFLAG_CY82C693		= (1 << 27),
 	/* force host out of "simplex" mode */
 	IDE_HFLAG_CLEAR_SIMPLEX		= (1 << 28),
 	/* DSC overlap is unsupported */
@@ -1092,9 +1095,9 @@ enum {
 };
 
 #ifdef CONFIG_BLK_DEV_OFFBOARD
-# define IDE_HFLAG_OFF_BOARD	IDE_HFLAG_BOOTABLE
-#else
 # define IDE_HFLAG_OFF_BOARD	0
+#else
+# define IDE_HFLAG_OFF_BOARD	IDE_HFLAG_NON_BOOTABLE
 #endif
 
 struct ide_port_info {
diff --git a/kernel/fork.c b/kernel/fork.c
index efb618f..cb46bef 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1787,7 +1787,7 @@ bad_unshare_out:
 int unshare_files(struct files_struct **displaced)
 {
 	struct task_struct *task = current;
-	struct files_struct *copy;
+	struct files_struct *copy = NULL;
 	int error;
 
 	error = unshare_fd(CLONE_FILES, &copy);
