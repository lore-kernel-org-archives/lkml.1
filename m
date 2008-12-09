Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbYLIFwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbYLIFwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 00:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYLIFvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 00:51:54 -0500
Received: from havoc.gtf.org ([69.61.125.42]:36066 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYLIFvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 00:51:53 -0500
Date: Tue, 9 Dec 2008 00:51:51 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20081209055151.GA26498@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The largest (yet least significant) part of this is Alan's Kconfig
patch, which updates the tags to reflect the state of the drivers --
largely a documentation patch.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig        |   44 ++++++++++++++++++++++----------------------
 drivers/ata/ata_piix.c     |    9 ++++++++-
 drivers/ata/pata_hpt366.c  |    4 ++--
 drivers/ata/pata_ninja32.c |    9 +++++++--
 drivers/ata/pata_sis.c     |    1 -
 5 files changed, 39 insertions(+), 28 deletions(-)

Alan Cox (3):
      pata_sis: Remove bogus cable match
      pata_ninja32: update ID table
      ata: Fix experimental tags

Jiri Slaby (1):
      ATA: piix, fix pointer deref on suspend

Tejun Heo (1):
      pata_hpt366: fix clock detection

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 78fbec8..421b7c7 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -153,7 +153,7 @@ config SATA_PROMISE
 	  If unsure, say N.
 
 config SATA_SX4
-	tristate "Promise SATA SX4 support"
+	tristate "Promise SATA SX4 support (Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for Promise Serial ATA SX4.
@@ -219,8 +219,8 @@ config PATA_ACPI
 	  otherwise unsupported hardware.
 
 config PATA_ALI
-	tristate "ALi PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "ALi PATA support"
+	depends on PCI
 	help
 	  This option enables support for the ALi ATA interfaces
 	  found on the many ALi chipsets.
@@ -263,7 +263,7 @@ config PATA_ATIIXP
 	  If unsure, say N.
 
 config PATA_CMD640_PCI
-	tristate "CMD640 PCI PATA support (Very Experimental)"
+	tristate "CMD640 PCI PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the CMD640 PCI IDE
@@ -291,8 +291,8 @@ config PATA_CS5520
 	  If unsure, say N.
 
 config PATA_CS5530
-	tristate "CS5530 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "CS5530 PATA support"
+	depends on PCI
 	help
 	  This option enables support for the Cyrix/NatSemi/AMD CS5530
 	  companion chip used with the MediaGX/Geode processor family.
@@ -309,8 +309,8 @@ config PATA_CS5535
 	  If unsure, say N.
 
 config PATA_CS5536
-	tristate "CS5536 PATA support (Experimental)"
-	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	tristate "CS5536 PATA support"
+	depends on PCI && X86 && !X86_64
 	help
 	  This option enables support for the AMD CS5536
 	  companion chip used with the Geode LX processor family.
@@ -363,7 +363,7 @@ config PATA_HPT37X
 	  If unsure, say N.
 
 config PATA_HPT3X2N
-	tristate "HPT 372N/302N PATA support (Very Experimental)"
+	tristate "HPT 372N/302N PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the N variant HPT PATA
@@ -389,8 +389,8 @@ config PATA_HPT3X3_DMA
 	  problems with DMA on this chipset.
 
 config PATA_ISAPNP
-	tristate "ISA Plug and Play PATA support (Experimental)"
-	depends on EXPERIMENTAL && ISAPNP
+	tristate "ISA Plug and Play PATA support"
+	depends on ISAPNP
 	help
 	  This option enables support for ISA plug & play ATA
 	  controllers such as those found on old soundcards.
@@ -498,8 +498,8 @@ config PATA_NINJA32
 	  If unsure, say N.
 
 config PATA_NS87410
-	tristate "Nat Semi NS87410 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Nat Semi NS87410 PATA support"
+	depends on PCI
 	help
 	  This option enables support for the National Semiconductor
 	  NS87410 PCI-IDE controller.
@@ -507,8 +507,8 @@ config PATA_NS87410
 	  If unsure, say N.
 
 config PATA_NS87415
-	tristate "Nat Semi NS87415 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Nat Semi NS87415 PATA support"
+	depends on PCI
 	help
 	  This option enables support for the National Semiconductor
 	  NS87415 PCI-IDE controller.
@@ -544,8 +544,8 @@ config PATA_PCMCIA
 	  If unsure, say N.
 
 config PATA_PDC_OLD
-	tristate "Older Promise PATA controller support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Older Promise PATA controller support"
+	depends on PCI
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
 	  20265 and 20267 adapters.
@@ -559,7 +559,7 @@ config PATA_QDI
 	  Support for QDI 6500 and 6580 PATA controllers on VESA local bus.
 
 config PATA_RADISYS
-	tristate "RADISYS 82600 PATA support (Very Experimental)"
+	tristate "RADISYS 82600 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the RADISYS 82600
@@ -586,8 +586,8 @@ config PATA_RZ1000
 	  If unsure, say N.
 
 config PATA_SC1200
-	tristate "SC1200 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "SC1200 PATA support"
+	depends on PCI
 	help
 	  This option enables support for the NatSemi/AMD SC1200 SoC
 	  companion chip used with the Geode processor family.
@@ -620,8 +620,8 @@ config PATA_SIL680
 	  If unsure, say N.
 
 config PATA_SIS
-	tristate "SiS PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "SiS PATA support"
+	depends on PCI
 	help
 	  This option enables support for SiS PATA controllers
 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index d6d97d8..c11936e 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1072,7 +1072,14 @@ static int piix_broken_suspend(void)
 	 * matching is necessary because dmi_system_id.matches is
 	 * limited to four entries.
 	 */
-	if (!strcmp(dmi_get_system_info(DMI_SYS_VENDOR), "TOSHIBA") &&
+	if (dmi_get_system_info(DMI_SYS_VENDOR) &&
+	    dmi_get_system_info(DMI_PRODUCT_NAME) &&
+	    dmi_get_system_info(DMI_PRODUCT_VERSION) &&
+	    dmi_get_system_info(DMI_PRODUCT_SERIAL) &&
+	    dmi_get_system_info(DMI_BOARD_VENDOR) &&
+	    dmi_get_system_info(DMI_BOARD_NAME) &&
+	    dmi_get_system_info(DMI_BOARD_VERSION) &&
+	    !strcmp(dmi_get_system_info(DMI_SYS_VENDOR), "TOSHIBA") &&
 	    !strcmp(dmi_get_system_info(DMI_PRODUCT_NAME), "000000") &&
 	    !strcmp(dmi_get_system_info(DMI_PRODUCT_VERSION), "000000") &&
 	    !strcmp(dmi_get_system_info(DMI_PRODUCT_SERIAL), "000000") &&
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index f2b83ea..a098ba8 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -382,10 +382,10 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* PCI clocking determines the ATA timing values to use */
 	/* info_hpt366 is safe against re-entry so we can scribble on it */
 	switch((reg1 & 0x700) >> 8) {
-		case 5:
+		case 9:
 			hpriv = &hpt366_40;
 			break;
-		case 9:
+		case 5:
 			hpriv = &hpt366_25;
 			break;
 		default:
diff --git a/drivers/ata/pata_ninja32.c b/drivers/ata/pata_ninja32.c
index 4e466ea..4dd9a3b 100644
--- a/drivers/ata/pata_ninja32.c
+++ b/drivers/ata/pata_ninja32.c
@@ -44,7 +44,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_ninja32"
-#define DRV_VERSION "0.1.1"
+#define DRV_VERSION "0.1.3"
 
 
 /**
@@ -130,7 +130,8 @@ static int ninja32_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		return rc;
 	pci_set_master(dev);
 
-	/* Set up the register mappings */
+	/* Set up the register mappings. We use the I/O mapping as only the
+	   older chips also have MMIO on BAR 1 */
 	base = host->iomap[0];
 	if (!base)
 		return -ENOMEM;
@@ -167,8 +168,12 @@ static int ninja32_reinit_one(struct pci_dev *pdev)
 #endif
 
 static const struct pci_device_id ninja32[] = {
+	{ 0x10FC, 0x0003, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ 0x1145, 0x8008, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ 0x1145, 0xf008, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ 0x1145, 0xf021, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ 0x1145, 0xf024, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ 0x1145, 0xf02C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ },
 };
 
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index d342366..e4be55e 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -56,7 +56,6 @@ static const struct sis_laptop sis_laptop[] = {
 	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
 	{ 0x5513, 0x1734, 0x105F },	/* FSC Amilo A1630 */
 	{ 0x5513, 0x1071, 0x8640 },     /* EasyNote K5305 */
-	{ 0x5513, 0x1039, 0x5513 },	/* Targa Visionary 1000 */
 	/* end marker */
 	{ 0, }
 };
