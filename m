Return-Path: <linux-kernel-owner+w=401wt.eu-S1752208AbXA0NQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbXA0NQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 08:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbXA0NQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 08:16:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:12919 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbXA0NQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 08:16:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:subject;
        b=VpRaByCM7ZmcUlhaO16L2nvE39dCqSB6PbBUu3AeZf0qZYflbl6E4si0zHQ/kDQg/ZdxqCmYVg+QZdPLmJCiTzwwAr59rUJK28haVH+0t4DeUkFAGWcmq/Uly+7O6DE50IEWesCIwcrawbrn5gLHlzgzVF5NjgWJMdQXu4y60f0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 27 Jan 2007 14:20:33 +0100
Message-Id: <20070127132033.7034.95530.sendpatchset@localhost.localdomain>
Subject: [git patches] IDE fixes for 2.6.20-rc6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The resend of the 2.6.20-rc6 fixes that I've sent you as patches.
This time in the git form for easier merging and with proper cc:.

Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 MAINTAINERS                    |    7 ++----
 drivers/ata/pata_via.c         |    1 
 drivers/ide/ide-pnp.c          |    5 ++++
 drivers/ide/ide.c              |    5 ++++
 drivers/ide/pci/aec62xx.c      |    2 -
 drivers/ide/pci/alim15x3.c     |    2 -
 drivers/ide/pci/amd74xx.c      |    2 -
 drivers/ide/pci/atiixp.c       |   42 ++++++++++++++++++-----------------------
 drivers/ide/pci/cmd64x.c       |    2 -
 drivers/ide/pci/cs5520.c       |    2 -
 drivers/ide/pci/cs5530.c       |    2 -
 drivers/ide/pci/cy82c693.c     |    2 -
 drivers/ide/pci/generic.c      |   37 ------------------------------------
 drivers/ide/pci/hpt34x.c       |    2 -
 drivers/ide/pci/hpt366.c       |    2 -
 drivers/ide/pci/jmicron.c      |    3 +-
 drivers/ide/pci/ns87415.c      |    2 -
 drivers/ide/pci/opti621.c      |    2 -
 drivers/ide/pci/pdc202xx_new.c |    2 -
 drivers/ide/pci/pdc202xx_old.c |    2 -
 drivers/ide/pci/rz1000.c       |    2 -
 drivers/ide/pci/sc1200.c       |    2 -
 drivers/ide/pci/serverworks.c  |    2 -
 drivers/ide/pci/sgiioc4.c      |    3 --
 drivers/ide/pci/siimage.c      |    2 -
 drivers/ide/pci/sis5513.c      |    2 -
 drivers/ide/pci/sl82c105.c     |    2 -
 drivers/ide/pci/slc90e66.c     |    2 -
 drivers/ide/pci/triflex.c      |    2 -
 drivers/ide/pci/trm290.c       |    2 -
 drivers/ide/pci/via82cxxx.c    |    5 +++-
 include/asm-ia64/pci.h         |    6 +++++
 include/linux/pci_ids.h        |    3 +-
 33 files changed, 71 insertions(+), 90 deletions(-)

Alan Cox (1):
      ide/generic: Jmicron has its own drivers now

Andrew Morton (1):
      jmicron: fix warning

Bartlomiej Zolnierkiewicz (3):
      ide: update MAINTAINERS entry
      ia64: add pci_get_legacy_ide_irq()
      ide: add missing __init tags to IDE PCI host drivers

Conke Hu (3):
      atiixp.c: remove unused code
      atiixp.c: sb600 ide only has one channel
      atiixp.c: add cable detection support for ATI IDE

Josepch Chan (1):
      via82cxxx/pata_via: correct PCI_DEVICE_ID_VIA_SATA_EIDE ID and add support for CX700 and 8237S

Tejun Heo (1):
      ide: unregister idepnp driver on unload

diff --git a/MAINTAINERS b/MAINTAINERS
index f0596e4..1446cc4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1598,12 +1598,11 @@ M:	ipslinux@adaptec.com
 W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html
 S:	Supported 
 
-IDE DRIVER [GENERAL]
+IDE SUBSYSTEM
 P:	Bartlomiej Zolnierkiewicz
-M:	B.Zolnierkiewicz@elka.pw.edu.pl
-L:	linux-kernel@vger.kernel.org
+M:	bzolnier@gmail.com
 L:	linux-ide@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git
+T:	quilt kernel.org/pub/linux/kernel/people/bart/pata-2.6/
 S:	Maintained
 
 IDE/ATAPI CDROM DRIVER
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index f0d4f7e..0219419 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -95,6 +95,7 @@ static const struct via_isa_bridge {
 	u8 rev_max;
 	u16 flags;
 } via_isa_bridges[] = {
+	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES},
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index df7d150..98410ca 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -73,3 +73,8 @@ void __init pnpide_init(void)
 {
 	pnp_register_driver(&idepnp_driver);
 }
+
+void __exit pnpide_exit(void)
+{
+	pnp_unregister_driver(&idepnp_driver);
+}
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 1689076..3b334af 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1782,6 +1782,7 @@ done:
 }
 
 extern void pnpide_init(void);
+extern void pnpide_exit(void);
 extern void h8300_ide_init(void);
 
 /*
@@ -2094,6 +2095,10 @@ void cleanup_module (void)
 	for (index = 0; index < MAX_HWIFS; ++index)
 		ide_unregister(index);
 
+#ifdef CONFIG_BLK_DEV_IDEPNP
+	pnpide_exit();
+#endif
+
 #ifdef CONFIG_PROC_FS
 	proc_ide_destroy();
 #endif
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index f286079..d261bfb 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -441,7 +441,7 @@ static struct pci_driver driver = {
 	.probe		= aec62xx_init_one,
 };
 
-static int aec62xx_ide_init(void)
+static int __init aec62xx_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 89109be..68df77e 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -907,7 +907,7 @@ static struct pci_driver driver = {
 	.probe		= alim15x3_init_one,
 };
 
-static int ali15x3_ide_init(void)
+static int __init ali15x3_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 753fe0e..a433699 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -544,7 +544,7 @@ static struct pci_driver driver = {
 	.probe		= amd74xx_probe,
 };
 
-static int amd74xx_ide_init(void)
+static int __init amd74xx_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index 524e65d..982ac31 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -291,8 +291,12 @@ fast_ata_pio:
 
 static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 {
+	u8 udma_mode = 0;
+	u8 ch = hwif->channel;
+	struct pci_dev *pdev = hwif->pci_dev;
+
 	if (!hwif->irq)
-		hwif->irq = hwif->channel ? 15 : 14;
+		hwif->irq = ch ? 15 : 14;
 
 	hwif->autodma = 0;
 	hwif->tuneproc = &atiixp_tuneproc;
@@ -308,8 +312,12 @@ static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 	hwif->mwdma_mask = 0x06;
 	hwif->swdma_mask = 0x04;
 
-	/* FIXME: proper cable detection needed */
-	hwif->udma_four = 1;
+	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ch, &udma_mode);
+	if ((udma_mode & 0x07) >= 0x04 || (udma_mode & 0x70) >= 0x40)
+		hwif->udma_four = 1;
+	else
+		hwif->udma_four = 0;
+
 	hwif->ide_dma_host_on = &atiixp_ide_dma_host_on;
 	hwif->ide_dma_host_off = &atiixp_ide_dma_host_off;
 	hwif->ide_dma_check = &atiixp_dma_check;
@@ -320,19 +328,6 @@ static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 	hwif->drives[0].autodma = hwif->autodma;
 }
 
-static void __devinit init_hwif_sb600_legacy(ide_hwif_t *hwif)
-{
-
-	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x7f;
-	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
-
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
-}
 
 static ide_pci_device_t atiixp_pci_info[] __devinitdata = {
 	{	/* 0 */
@@ -343,12 +338,13 @@ static ide_pci_device_t atiixp_pci_info[] __devinitdata = {
 		.enablebits	= {{0x48,0x01,0x00}, {0x48,0x08,0x00}},
 		.bootable	= ON_BOARD,
 	},{	/* 1 */
-		.name		= "ATI SB600 SATA Legacy IDE",
-		.init_hwif	= init_hwif_sb600_legacy,
-		.channels	= 2,
+		.name		= "SB600_PATA",
+		.init_hwif	= init_hwif_atiixp,
+		.channels	= 1,
 		.autodma	= AUTODMA,
-		.bootable	= ON_BOARD,
-	}
+		.enablebits	= {{0x48,0x01,0x00}, {0x00,0x00,0x00}},
+ 		.bootable	= ON_BOARD,
+ 	},
 };
 
 /**
@@ -369,7 +365,7 @@ static struct pci_device_id atiixp_pci_tbl[] = {
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP200_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP300_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, atiixp_pci_tbl);
@@ -380,7 +376,7 @@ static struct pci_driver driver = {
 	.probe		= atiixp_init_one,
 };
 
-static int atiixp_ide_init(void)
+static int __init atiixp_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 20c3271..aee947e 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -793,7 +793,7 @@ static struct pci_driver driver = {
 	.probe		= cmd64x_init_one,
 };
 
-static int cmd64x_ide_init(void)
+static int __init cmd64x_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index 079f7c8..ba6786a 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -260,7 +260,7 @@ static struct pci_driver driver = {
 	.probe		= cs5520_init_one,
 };
 
-static int cs5520_ide_init(void)
+static int __init cs5520_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index ae405fa..9bf5fdf 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -374,7 +374,7 @@ static struct pci_driver driver = {
 	.probe		= cs5530_init_one,
 };
 
-static int cs5530_ide_init(void)
+static int __init cs5530_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index 64330c4..9eafcbf 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -519,7 +519,7 @@ static struct pci_driver driver = {
 	.probe		= cy82c693_init_one,
 };
 
-static int cy82c693_ide_init(void)
+static int __init cy82c693_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index 9f30688..b408c6c 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -185,36 +185,6 @@ static ide_pci_device_t generic_chipsets[] __devinitdata = {
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
-	},{	/* 15 */
-		.name		= "JMB361",
-		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-	},{	/* 16 */
-		.name		= "JMB363",
-		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-	},{	/* 17 */
-		.name		= "JMB365",
-		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-	},{	/* 18 */
-		.name		= "JMB366",
-		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-	},{	/* 19 */
-		.name		= "JMB368",
-		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
 	}
 };
 
@@ -281,11 +251,6 @@ static struct pci_device_id generic_pci_tbl[] = {
 	{ PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_1,   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 12},
 	{ PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2,   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 13},
 	{ PCI_VENDOR_ID_NETCELL,PCI_DEVICE_ID_REVOLUTION,          PCI_ANY_ID, PCI_ANY_ID, 0, 0, 14},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361,	   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 15},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363,	   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 16},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365,	   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 17},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366,	   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 18},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368,	   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 19},
 	/* Must come last. If you add entries adjust this table appropriately and the init_one code */
 	{ PCI_ANY_ID,		PCI_ANY_ID,			   PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL, 0},
 	{ 0, },
@@ -298,7 +263,7 @@ static struct pci_driver driver = {
 	.probe		= generic_init_one,
 };
 
-static int generic_ide_init(void)
+static int __init generic_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index b46cb04..ce7b08f 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -265,7 +265,7 @@ static struct pci_driver driver = {
 	.probe		= hpt34x_init_one,
 };
 
-static int hpt34x_ide_init(void)
+static int __init hpt34x_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 08119da..b486442 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1613,7 +1613,7 @@ static struct pci_driver driver = {
 	.probe		= hpt366_init_one,
 };
 
-static int hpt366_ide_init(void)
+static int __init hpt366_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index c1cec23..35dda8f 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -93,8 +93,9 @@ static int __devinit ata66_jmicron(ide_hwif_t *hwif)
 			return 0;
 		return 1;
 	case PORT_SATA:
-		return 1;
+		break;
 	}
+	return 1; /* Avoid bogus "control reaches end of non-void function" */
 }
 
 static void jmicron_tuneproc (ide_drive_t *drive, byte mode_wanted)
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index d95714b..8aaea4e 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -302,7 +302,7 @@ static struct pci_driver driver = {
 	.probe		= ns87415_init_one,
 };
 
-static int ns87415_ide_init(void)
+static int __init ns87415_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index 7a7c2ef..22bbf61 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -382,7 +382,7 @@ static struct pci_driver driver = {
 	.probe		= opti621_init_one,
 };
 
-static int opti621_ide_init(void)
+static int __init opti621_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 7cb4857..77a9aaa 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -756,7 +756,7 @@ static struct pci_driver driver = {
 	.probe		= pdc202new_init_one,
 };
 
-static int pdc202new_ide_init(void)
+static int __init pdc202new_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index 184cdac..143239c 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -719,7 +719,7 @@ static struct pci_driver driver = {
 	.probe		= pdc202xx_init_one,
 };
 
-static int pdc202xx_ide_init(void)
+static int __init pdc202xx_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/rz1000.c b/drivers/ide/pci/rz1000.c
index 5f6950c..c185531 100644
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -77,7 +77,7 @@ static struct pci_driver driver = {
 	.probe		= rz1000_init_one,
 };
 
-static int rz1000_ide_init(void)
+static int __init rz1000_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index ff80937..8d762d3 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -507,7 +507,7 @@ static struct pci_driver driver = {
 #endif
 };
 
-static int sc1200_ide_init(void)
+static int __init sc1200_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index 057548d..ea9a28a 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -666,7 +666,7 @@ static struct pci_driver driver = {
 	.probe		= svwks_init_one,
 };
 
-static int svwks_ide_init(void)
+static int __init svwks_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index cfad09a..b0bf018 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -762,8 +762,7 @@ static struct ioc4_submodule ioc4_ide_submodule = {
 /*	.is_remove = ioc4_ide_remove_one,	*/
 };
 
-static int __devinit
-ioc4_ide_init(void)
+static int __init ioc4_ide_init(void)
 {
 	return ioc4_register_submodule(&ioc4_ide_submodule);
 }
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 697f566..4ff89c7 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -1096,7 +1096,7 @@ static struct pci_driver driver = {
 	.probe		= siimage_init_one,
 };
 
-static int siimage_ide_init(void)
+static int __init siimage_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 6b31313..1afff65 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -968,7 +968,7 @@ static struct pci_driver driver = {
 	.probe		= sis5513_init_one,
 };
 
-static int sis5513_ide_init(void)
+static int __init sis5513_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index 5afefe8..170a261 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -492,7 +492,7 @@ static struct pci_driver driver = {
 	.probe		= sl82c105_init_one,
 };
 
-static int sl82c105_ide_init(void)
+static int __init sl82c105_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index 9be7e49..90e79c0 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -253,7 +253,7 @@ static struct pci_driver driver = {
 	.probe		= slc90e66_init_one,
 };
 
-static int slc90e66_ide_init(void)
+static int __init slc90e66_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index 56d8493..b13cce1 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -173,7 +173,7 @@ static struct pci_driver driver = {
 	.probe		= triflex_init_one,
 };
 
-static int triflex_ide_init(void)
+static int __init triflex_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/trm290.c b/drivers/ide/pci/trm290.c
index 2a28252..174b88c 100644
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -355,7 +355,7 @@ static struct pci_driver driver = {
 	.probe		= trm290_init_one,
 };
 
-static int trm290_ide_init(void)
+static int __init trm290_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index 381cc6f..a98b4d3 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -78,6 +78,8 @@ static struct via_isa_bridge {
 	u8 rev_max;
 	u16 flags;
 } via_isa_bridges[] = {
+	{ "cx7000",	PCI_DEVICE_ID_VIA_CX700,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
+	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
@@ -504,6 +506,7 @@ static struct pci_device_id via_pci_tbl[] = {
 	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C576_1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_6410,     PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
+	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_SATA_EIDE,     PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, via_pci_tbl);
@@ -514,7 +517,7 @@ static struct pci_driver driver = {
 	.probe 		= via_init_one,
 };
 
-static int via_ide_init(void)
+static int __init via_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
diff --git a/include/asm-ia64/pci.h b/include/asm-ia64/pci.h
index 556f53f..5160233 100644
--- a/include/asm-ia64/pci.h
+++ b/include/asm-ia64/pci.h
@@ -167,4 +167,10 @@ pcibios_select_root(struct pci_dev *pdev, struct resource *res)
 
 #define pcibios_scan_all_fns(a, b)	0
 
+#define HAVE_ARCH_PCI_GET_LEGACY_IDE_IRQ
+static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
+{
+	return channel ? 15 : 14;
+}
+
 #endif /* _ASM_IA64_PCI_H */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f7a416c..e642b99 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1283,7 +1283,6 @@
 #define PCI_DEVICE_ID_VIA_82C561	0x0561
 #define PCI_DEVICE_ID_VIA_82C586_1	0x0571
 #define PCI_DEVICE_ID_VIA_82C576	0x0576
-#define PCI_DEVICE_ID_VIA_SATA_EIDE	0x0581
 #define PCI_DEVICE_ID_VIA_82C586_0	0x0586
 #define PCI_DEVICE_ID_VIA_82C596	0x0596
 #define PCI_DEVICE_ID_VIA_82C597_0	0x0597
@@ -1326,6 +1325,8 @@
 #define PCI_DEVICE_ID_VIA_8237		0x3227
 #define PCI_DEVICE_ID_VIA_8251		0x3287
 #define PCI_DEVICE_ID_VIA_8237A		0x3337
+#define PCI_DEVICE_ID_VIA_8237S		0x3372
+#define PCI_DEVICE_ID_VIA_SATA_EIDE	0x5324
 #define PCI_DEVICE_ID_VIA_8231		0x8231
 #define PCI_DEVICE_ID_VIA_8231_4	0x8235
 #define PCI_DEVICE_ID_VIA_8365_1	0x8305
