Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbXK0UgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbXK0UgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 15:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbXK0Uf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 15:35:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:53020 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbXK0Ufy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 15:35:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=m0X7KfPD0tb3pxIVT86dpa22J2BHGTNMWR2QiBSRcoJ2CJTy40JIS9wIEGM6u65z2W0/X9wSiS3uEPo3Qq8jBQ82JN4iPGosOMMLuzUNAs/AnUv6ItJ5nrTIc4AHAZcyVvm+RWQS/TF0p+ItlUHCqt2e2kXkdgyQAJiztU+j5lM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Tue, 27 Nov 2007 21:39:09 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711272139.09315.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 arch/cris/arch-v10/drivers/Kconfig |   39 -----------------------------
 arch/cris/arch-v32/drivers/Kconfig |   12 ---------
 drivers/ide/Kconfig                |   47 ++++++++++++++++++++++++++++++++++-
 drivers/ide/Makefile               |    2 +-
 drivers/ide/cris/ide-cris.c        |    7 +++--
 drivers/ide/ide-dma.c              |    1 +
 drivers/ide/ide-iops.c             |   13 +++++++---
 drivers/ide/ide-probe.c            |   32 ++++++++++++++----------
 drivers/ide/legacy/ali14xx.c       |    7 +++--
 drivers/ide/legacy/macide.c        |    2 +-
 drivers/ide/legacy/q40ide.c        |    2 +-
 drivers/ide/pci/aec62xx.c          |   11 +++++++-
 drivers/ide/pci/alim15x3.c         |    5 ++++
 drivers/ide/pci/piix.c             |    1 +
 drivers/ide/pci/siimage.c          |   45 +---------------------------------
 drivers/ide/pci/sis5513.c          |    1 +
 drivers/ide/pci/trm290.c           |    3 --
 drivers/ide/ppc/pmac.c             |    2 +-
 drivers/scsi/ide-scsi.c            |   22 ++++++----------
 19 files changed, 112 insertions(+), 142 deletions(-)


Aleksandar Radovanovic (1):
      aec62xx: Fix kernel oops in driver's probe function

Andrew Morton (1):
      amd74xx: arm hack

Bartlomiej Zolnierkiewicz (11):
      macide/q40ide: add missing __init tag to {macide,q40ide}_init()
      ide/Kconfig: fix mpc8xx host driver dependencies
      ide: add CONFIG_IDE_H8300 config option
      ide: move CONFIG_IDE_ETRAX to drivers/ide/Kconfig
      ide-cris: don't override ide_register_hw() result
      ide: add TORiSAN model: CD-ROM CDR_U200 fw: 1.09 to DMA blacklist
      alim15x3: add Mitac 8317 and derivatives to ali_cable_override()
      piix: add HP compaq laptop to short cable list
      trm290: remove bogus init_hwif_trm290() comment
      ide: remove bogus ide_fix_driveid() comment
      ali14xx: constify __initdata

Denis Cheng (1):
      ide-scsi: use print_hex_dump from <linux/kernel.h>

Gabriel Craciunescu (1):
      sis5513.c: Add Packard Bell EasyNote K5305 to laptops

Joe Perches (1):
      drivers/ide: Add missing "space"

Jonas Stare (1):
      ide: skip ide_wait_not_busy() on noprobe-disks

Peter Missel (1):
      ide: More TSST drives with broken cable detection

Sergei Shtylyov (2):
      ide: don't set PIO mode on pre-EIDE drives
      siimage: remove resetproc() method


diff --git a/arch/cris/arch-v10/drivers/Kconfig b/arch/cris/arch-v10/drivers/Kconfig
index faf8b4d..e3c0f29 100644
--- a/arch/cris/arch-v10/drivers/Kconfig
+++ b/arch/cris/arch-v10/drivers/Kconfig
@@ -542,45 +542,6 @@ config ETRAX_RS485_DISABLE_RECEIVER
 	  loopback.  Not all products are able to do this in software only.
 	  Axis 2400/2401 must disable receiver.
 
-config ETRAX_IDE
-	bool "ATA/IDE support"
-	select IDE
-	select BLK_DEV_IDE
-	select BLK_DEV_IDEDISK
-	select BLK_DEV_IDECD
-	select BLK_DEV_IDEDMA
-	select IDE_GENERIC
-	help
-	  Enable this to get support for ATA/IDE.
-	  You can't use parallel ports or SCSI ports
-	  at the same time.
-
-
-config ETRAX_IDE_DELAY
-	int "Delay for drives to regain consciousness"
-	depends on ETRAX_IDE
-	default 15
-	help
-	  Number of seconds to wait for IDE drives to spin up after an IDE
-	  reset.
-choice
-	prompt "IDE reset pin"
-	depends on ETRAX_IDE
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
-
 config ETRAX_USB_HOST
 	bool "USB host"
 	select USB
diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index 7f72d7c..9bccb5e 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -582,18 +582,6 @@ config ETRAX_PE_CHANGEABLE_BITS
 	  that a user can change the value on using ioctl's.
 	  Bit set = changeable.
 
-config ETRAX_IDE
-	bool "ATA/IDE support"
-	depends on ETRAX_ARCH_V32
-	select IDE
-	select BLK_DEV_IDE
-	select BLK_DEV_IDEDISK
-	select BLK_DEV_IDECD
-	select BLK_DEV_IDEDMA
-	select IDE_GENERIC
-	help
-	  Enables the ETRAX IDE driver.
-
 config ETRAX_CARDBUS
         bool "Cardbus support"
         depends on ETRAX_ARCH_V32
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index e445fe6..45b2228 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -313,7 +313,6 @@ comment "IDE chipset support/bugfixes"
 
 config IDE_GENERIC
 	tristate "generic/default IDE chipset support"
-	default H8300
 	help
 	  If unsure, say N.
 
@@ -484,6 +483,7 @@ config WDC_ALI15X3
 
 config BLK_DEV_AMD74XX
 	tristate "AMD and nVidia IDE support"
+	depends on !ARM
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds explicit support for AMD-7xx and AMD-8111 chips
@@ -883,6 +883,49 @@ config BLK_DEV_IDE_BAST
 	  Say Y here if you want to support the onboard IDE channels on the
 	  Simtec BAST or the Thorcom VR1000
 
+config ETRAX_IDE
+	bool "ETRAX IDE support"
+	depends on CRIS && BROKEN
+	select BLK_DEV_IDEDMA
+	select IDE_GENERIC
+	help
+	  Enables the ETRAX IDE driver.
+
+	  You can't use parallel ports or SCSI ports at the same time.
+
+config ETRAX_IDE_DELAY
+	int "Delay for drives to regain consciousness"
+	depends on ETRAX_IDE && ETRAX_ARCH_V10
+	default 15
+	help
+	  Number of seconds to wait for IDE drives to spin up after an IDE
+	  reset.
+
+choice
+	prompt "IDE reset pin"
+	depends on ETRAX_IDE && ETRAX_ARCH_V10
+	default ETRAX_IDE_PB7_RESET
+
+config ETRAX_IDE_PB7_RESET
+	bool "Port_PB_Bit_7"
+	help
+	  IDE reset on pin 7 on port B
+
+config ETRAX_IDE_G27_RESET
+	bool "Port_G_Bit_27"
+	help
+	  IDE reset on pin 27 on port G
+
+endchoice
+
+config IDE_H8300
+	bool "H8300 IDE support"
+	depends on H8300
+	select IDE_GENERIC
+	default y
+	help
+	  Enables the H8300 IDE driver.
+
 config BLK_DEV_GAYLE
 	bool "Amiga Gayle IDE interface support"
 	depends on AMIGA
@@ -963,7 +1006,7 @@ config BLK_DEV_Q40IDE
 
 config BLK_DEV_MPC8xx_IDE
 	bool "MPC8xx IDE support"
-	depends on 8xx && IDE=y && BLK_DEV_IDE=y && !PPC_MERGE
+	depends on 8xx && (LWMON || IVMS8 || IVML24 || TQM8xxL) && IDE=y && BLK_DEV_IDE=y && !PPC_MERGE
 	select IDE_GENERIC
 	help
 	  This option provides support for IDE on Motorola MPC8xx Systems.
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 75dc696..b181fc6 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -39,7 +39,7 @@ ide-core-$(CONFIG_BLK_DEV_MPC8xx_IDE)	+= ppc/mpc8xx.o
 ide-core-$(CONFIG_BLK_DEV_IDE_PMAC)	+= ppc/pmac.o
 
 # built-in only drivers from h8300/
-ide-core-$(CONFIG_H8300)		+= h8300/ide-h8300.o
+ide-core-$(CONFIG_IDE_H8300)		+= h8300/ide-h8300.o
 
 obj-$(CONFIG_BLK_DEV_IDE)		+= ide-core.o
 obj-$(CONFIG_IDE_GENERIC)		+= ide-generic.o
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 7f5bc2e..476e0d6 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -773,15 +773,16 @@ init_e100_ide (void)
 	/* the IDE control register is at ATA address 6, with CS1 active instead of CS0 */
 	ide_offsets[IDE_CONTROL_OFFSET] = cris_ide_reg_addr(6, 1, 0);
 
-	/* first fill in some stuff in the ide_hwifs fields */
+	for (h = 0; h < 4; h++) {
+		ide_hwif_t *hwif = NULL;
 
-	for(h = 0; h < MAX_HWIFS; h++) {
-		ide_hwif_t *hwif = &ide_hwifs[h];
 		ide_setup_ports(&hw, cris_ide_base_address(h),
 		                ide_offsets,
 		                0, 0, cris_ide_ack_intr,
 		                ide_default_irq(0));
 		ide_register_hw(&hw, NULL, 1, &hwif);
+		if (hwif == NULL)
+			continue;
 		hwif->mmio = 1;
 		hwif->chipset = ide_etrax100;
 		hwif->set_pio_mode = &cris_set_pio_mode;
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index e3add70..0d795a1 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -130,6 +130,7 @@ static const struct drive_list_entry drive_blacklist [] = {
 	{ "_NEC DV5800A",               NULL            },
 	{ "SAMSUNG CD-ROM SN-124",	"N001" },
 	{ "Seagate STT20000A",		NULL  },
+	{ "CD-ROM CDR_U200",		"1.09" },
 	{ NULL			,	NULL		}
 
 };
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index e17a9ee..5c32561 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -303,9 +303,6 @@ void default_hwif_transport(ide_hwif_t *hwif)
 	hwif->atapi_output_bytes	= atapi_output_bytes;
 }
 
-/*
- * Beginning of Taskfile OPCODE Library and feature sets.
- */
 void ide_fix_driveid (struct hd_driveid *id)
 {
 #ifndef __LITTLE_ENDIAN
@@ -592,6 +589,9 @@ EXPORT_SYMBOL_GPL(ide_in_drive_list);
 static const struct drive_list_entry ivb_list[] = {
 	{ "QUANTUM FIREBALLlct10 05"	, "A03.0900"	},
 	{ "TSSTcorp CDDVDW SH-S202J"	, "SB00"	},
+	{ "TSSTcorp CDDVDW SH-S202J"	, "SB01"	},
+	{ "TSSTcorp CDDVDW SH-S202N"	, "SB00"	},
+	{ "TSSTcorp CDDVDW SH-S202N"	, "SB01"	},
 	{ NULL				, NULL		}
 };
 
@@ -756,7 +756,7 @@ int ide_driveid_update(ide_drive_t *drive)
 int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	int error;
+	int error = 0;
 	u8 stat;
 
 //	while (HWGROUP(drive)->busy)
@@ -767,6 +767,10 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 		hwif->dma_host_off(drive);
 #endif
 
+	/* Skip setting PIO flow-control modes on pre-EIDE drives */
+	if ((speed & 0xf8) == XFER_PIO_0 && !(drive->id->capability & 0x08))
+		goto skip;
+
 	/*
 	 * Don't use ide_wait_cmd here - it will
 	 * attempt to set_geometry and recalibrate,
@@ -814,6 +818,7 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 	drive->id->dma_mword &= ~0x0F00;
 	drive->id->dma_1word &= ~0x0F00;
 
+ skip:
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	if (speed >= XFER_SW_DMA_0)
 		hwif->dma_host_on(drive);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 56fb0b8..ee848c7 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -644,7 +644,7 @@ static void hwif_register (ide_hwif_t *hwif)
 
 static int wait_hwif_ready(ide_hwif_t *hwif)
 {
-	int rc;
+	int unit, rc;
 
 	printk(KERN_DEBUG "Probing IDE interface %s...\n", hwif->name);
 
@@ -661,20 +661,26 @@ static int wait_hwif_ready(ide_hwif_t *hwif)
 		return rc;
 
 	/* Now make sure both master & slave are ready */
-	SELECT_DRIVE(&hwif->drives[0]);
-	hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
-	mdelay(2);
-	rc = ide_wait_not_busy(hwif, 35000);
-	if (rc)
-		return rc;
-	SELECT_DRIVE(&hwif->drives[1]);
-	hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
-	mdelay(2);
-	rc = ide_wait_not_busy(hwif, 35000);
+	for (unit = 0; unit < MAX_DRIVES; unit++) {
+		ide_drive_t *drive = &hwif->drives[unit];
 
+		/* Ignore disks that we will not probe for later. */
+		if (!drive->noprobe || drive->present) {
+			SELECT_DRIVE(drive);
+			hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
+			mdelay(2);
+			rc = ide_wait_not_busy(hwif, 35000);
+			if (rc)
+				goto out;
+		} else
+			printk(KERN_DEBUG "%s: ide_wait_not_busy() skipped\n",
+					  drive->name);
+	}
+out:
 	/* Exit function with master reselected (let's be sane) */
-	SELECT_DRIVE(&hwif->drives[0]);
-	
+	if (unit)
+		SELECT_DRIVE(&hwif->drives[0]);
+
 	return rc;
 }
 
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index 10311ec..38c3a6d 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -53,12 +53,13 @@
 
 /* port addresses for auto-detection */
 #define ALI_NUM_PORTS 4
-static int ports[ALI_NUM_PORTS] __initdata = {0x074, 0x0f4, 0x034, 0x0e4};
+static const int ports[ALI_NUM_PORTS] __initdata =
+	{ 0x074, 0x0f4, 0x034, 0x0e4 };
 
 /* register initialization data */
 typedef struct { u8 reg, data; } RegInitializer;
 
-static RegInitializer initData[] __initdata = {
+static const RegInitializer initData[] __initdata = {
 	{0x01, 0x0f}, {0x02, 0x00}, {0x03, 0x00}, {0x04, 0x00},
 	{0x05, 0x00}, {0x06, 0x00}, {0x07, 0x2b}, {0x0a, 0x0f},
 	{0x25, 0x00}, {0x26, 0x00}, {0x27, 0x00}, {0x28, 0x00},
@@ -177,7 +178,7 @@ static int __init findPort (void)
  * Initialize controller registers with default values.
  */
 static int __init initRegisters (void) {
-	RegInitializer *p;
+	const RegInitializer *p;
 	u8 t;
 	unsigned long flags;
 
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index e87cd2f..5c6aa77 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -81,7 +81,7 @@ int macide_ack_intr(ide_hwif_t* hwif)
  * Probe for a Macintosh IDE interface
  */
 
-void macide_init(void)
+void __init macide_init(void)
 {
 	hw_regs_t hw;
 	ide_hwif_t *hwif;
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index a73db1b..6ea46a6 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -111,7 +111,7 @@ static const char *q40_ide_names[Q40IDE_NUM_HWIFS]={
  *  Probe for Q40 IDE interfaces
  */
 
-void q40ide_init(void)
+void __init q40ide_init(void)
 {
     int i;
     ide_hwif_t *hwif;
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index 19ec421..4426850 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -260,6 +260,11 @@ static int __devinit aec62xx_init_one(struct pci_dev *dev, const struct pci_devi
 {
 	struct ide_port_info d;
 	u8 idx = id->driver_data;
+	int err;
+
+	err = pci_enable_device(dev);
+	if (err)
+		return err;
 
 	d = aec62xx_chipsets[idx];
 
@@ -272,7 +277,11 @@ static int __devinit aec62xx_init_one(struct pci_dev *dev, const struct pci_devi
 		}
 	}
 
-	return ide_setup_pci_device(dev, &d);
+	err = ide_setup_pci_device(dev, &d);
+	if (err)
+		pci_disable_device(dev);
+
+	return err;
 }
 
 static const struct pci_device_id aec62xx_pci_tbl[] = {
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index a607dd3..ce29393 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -603,6 +603,11 @@ static int ali_cable_override(struct pci_dev *pdev)
 	    pdev->subsystem_device == 0x10AF)
 		return 1;
 
+	/* Mitac 8317 (Winbook-A) and relatives */
+	if (pdev->subsystem_vendor == 0x1071 &&
+	    pdev->subsystem_device == 0x8317)
+		return 1;
+
 	/* Systems by DMI */
 	if (dmi_check_system(cable_dmi_table))
 		return 1;
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 63625a0..27781d2 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -306,6 +306,7 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
 	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
+	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on Acer Aspire 2023WLMi */
 	/* end marker */
 	{ 0, }
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 6d99441..5709c25 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/siimage.c		Version 1.18	Oct 18 2007
+ * linux/drivers/ide/pci/siimage.c		Version 1.19	Nov 16 2007
  *
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2003		Red Hat <alan@redhat.com>
@@ -460,48 +460,6 @@ static void sil_sata_pre_reset(ide_drive_t *drive)
 }
 
 /**
- *	siimage_reset	-	reset a device on an siimage controller
- *	@drive: drive to reset
- *
- *	Perform a controller level reset fo the device. For
- *	SATA we must also check the PHY.
- */
- 
-static void siimage_reset (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 reset		= 0;
-	unsigned long addr	= siimage_selreg(hwif, 0);
-
-	if (hwif->mmio) {
-		reset = hwif->INB(addr);
-		hwif->OUTB((reset|0x03), addr);
-		/* FIXME:posting */
-		udelay(25);
-		hwif->OUTB(reset, addr);
-		(void) hwif->INB(addr);
-	} else {
-		pci_read_config_byte(hwif->pci_dev, addr, &reset);
-		pci_write_config_byte(hwif->pci_dev, addr, reset|0x03);
-		udelay(25);
-		pci_write_config_byte(hwif->pci_dev, addr, reset);
-		pci_read_config_byte(hwif->pci_dev, addr, &reset);
-	}
-
-	if (SATA_STATUS_REG) {
-		/* SATA_STATUS_REG is valid only when in MMIO mode */
-		u32 sata_stat = readl((void __iomem *)SATA_STATUS_REG);
-		printk(KERN_WARNING "%s: reset phy, status=0x%08x, %s\n",
-			hwif->name, sata_stat, __FUNCTION__);
-		if (!(sata_stat)) {
-			printk(KERN_WARNING "%s: reset phy dead, status=0x%08x\n",
-				hwif->name, sata_stat);
-			drive->failures++;
-		}
-	}
-}
-
-/**
  *	proc_reports_siimage		-	add siimage controller to proc
  *	@dev: PCI device
  *	@clocking: SCSC value
@@ -857,7 +815,6 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 {
 	u8 sata = is_sata(hwif);
 
-	hwif->resetproc = &siimage_reset;
 	hwif->set_pio_mode = &sil_set_pio_mode;
 	hwif->set_dma_mode = &sil_set_dma_mode;
 
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index f6e2ab3..d90b429 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -526,6 +526,7 @@ static const struct sis_laptop sis_laptop[] = {
 	/* devid, subvendor, subdev */
 	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
 	{ 0x5513, 0x1734, 0x105f },	/* FSC Amilo A1630 */
+	{ 0x5513, 0x1071, 0x8640 },     /* EasyNote K5305 */
 	/* end marker */
 	{ 0, }
 };
diff --git a/drivers/ide/pci/trm290.c b/drivers/ide/pci/trm290.c
index 5011ba2..0895e75 100644
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -240,9 +240,6 @@ static int trm290_ide_dma_test_irq (ide_drive_t *drive)
 	return (status == 0x00ff);
 }
 
-/*
- * Invoked from ide-dma.c at boot time.
- */
 static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 {
 	unsigned int cfgbase = 0;
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 5afdfef..7f7a598 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1513,7 +1513,7 @@ pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq)
 
 		if (pmif->broken_dma && cur_addr & (L1_CACHE_BYTES - 1)) {
 			if (pmif->broken_dma_warn == 0) {
-				printk(KERN_WARNING "%s: DMA on non aligned address,"
+				printk(KERN_WARNING "%s: DMA on non aligned address, "
 				       "switching to PIO on Ohare chipset\n", drive->name);
 				pmif->broken_dma_warn = 1;
 			}
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 8d0244c..7a835a3 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -242,16 +242,6 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
 	}
 }
 
-static void hexdump(u8 *x, int len)
-{
-	int i;
-
-	printk("[ ");
-	for (i = 0; i < len; i++)
-		printk("%x ", x[i]);
-	printk("]\n");
-}
-
 static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_command)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
@@ -282,7 +272,8 @@ static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_co
 	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: queue cmd = ", drive->name);
-		hexdump(pc->c, 6);
+		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, pc->c,
+			       6, 0);
 	}
 	rq->rq_disk = scsi->disk;
 	return ide_do_drive_cmd(drive, rq, ide_preempt);
@@ -337,7 +328,8 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 		idescsi_pc_t *opc = (idescsi_pc_t *) rq->buffer;
 		if (log) {
 			printk ("ide-scsi: %s: wrap up check %lu, rst = ", drive->name, 
opc->scsi_cmd->serial_number);
-			hexdump(pc->buffer,16);
+			print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1,
+				       pc->buffer, 16, 0);
 		}
 		memcpy((void *) opc->scsi_cmd->sense_buffer, pc->buffer, SCSI_SENSE_BUFFERSIZE);
 		kfree(pc->buffer);
@@ -816,10 +808,12 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: que %lu, cmd = ", drive->name, cmd->serial_number);
-		hexdump(cmd->cmnd, cmd->cmd_len);
+		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1,
+			       cmd->cmnd, cmd->cmd_len, 0);
 		if (memcmp(pc->c, cmd->cmnd, cmd->cmd_len)) {
 			printk ("ide-scsi: %s: que %lu, tsl = ", drive->name, cmd->serial_number);
-			hexdump(pc->c, 12);
+			print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1,
+				       pc->c, 12, 0);
 		}
 	}
 
