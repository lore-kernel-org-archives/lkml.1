Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYDUVd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYDUVd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYDUVc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:32:26 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60095 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbYDUVcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:32:20 -0400
Date: Tue, 22 Apr 2008 00:31:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [2.6 patch] select ATA_SFF
Message-ID: <20080421213147.GH2633@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making ATA_SFF a user-visible option with the drivers needing it
depending on it caused the following problems:
- people lose their driver when accidentally disabling it
- people not requiring it needlessly enable it

Fortunately, we don't have to bother the user with this option at all
since we can simply select it when it's required.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 13 Apr 2008

 drivers/ata/Kconfig |   90 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 71 insertions(+), 19 deletions(-)

c845cb43fdd7d61130fb838132be961cae104bfc diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 292aa9a..7b8c80b 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -74,28 +74,12 @@ config SATA_FSL
 	  If unsure, say N.
 
 config ATA_SFF
-	bool "ATA SFF support"
-	default y
-	help
-	  This option adds support for ATA controllers with SFF
-	  compliant or similar programming interface.
-
-	  SFF is the legacy IDE interface that has been around since
-	  the dawn of time.  Almost all PATA controllers have an
-	  SFF interface.  Many SATA controllers have an SFF interface
-	  when configured into a legacy compatibility mode.
-
-	  For users with exclusively modern controllers like AHCI,
-	  Silicon Image 3124, or Marvell 6440, you may choose to
-	  disable this uneeded SFF support.
-
-	  If unsure, say Y.
-
-if ATA_SFF
+	bool
 
 config SATA_SVW
 	tristate "ServerWorks Frodo / Apple K2 SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Broadcom/Serverworks/Apple K2
 	  SATA support.
@@ -105,6 +89,7 @@ config SATA_SVW
 config ATA_PIIX
 	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for ICH5/6/7/8 Serial ATA
 	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
@@ -115,6 +100,7 @@ config ATA_PIIX
 config SATA_MV
 	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
 	depends on EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the Marvell Serial ATA family.
 	  Currently supports 88SX[56]0[48][01] chips.
@@ -124,6 +110,7 @@ config SATA_MV
 config SATA_NV
 	tristate "NVIDIA SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for NVIDIA Serial ATA.
 
@@ -132,6 +119,7 @@ config SATA_NV
 config PDC_ADMA
 	tristate "Pacific Digital ADMA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Pacific Digital ADMA controllers
 
@@ -140,6 +128,7 @@ config PDC_ADMA
 config SATA_QSTOR
 	tristate "Pacific Digital SATA QStor support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Pacific Digital Serial ATA QStor.
 
@@ -148,6 +137,7 @@ config SATA_QSTOR
 config SATA_PROMISE
 	tristate "Promise SATA TX2/TX4 support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Promise Serial ATA TX2/TX4.
 
@@ -156,6 +146,7 @@ config SATA_PROMISE
 config SATA_SX4
 	tristate "Promise SATA SX4 support"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for Promise Serial ATA SX4.
 
@@ -164,6 +155,7 @@ config SATA_SX4
 config SATA_SIL
 	tristate "Silicon Image SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Silicon Image Serial ATA.
 
@@ -173,6 +165,7 @@ config SATA_SIS
 	tristate "SiS 964/965/966/180 SATA support"
 	depends on PCI
 	select PATA_SIS
+	select ATA_SFF
 	help
 	  This option enables support for SiS Serial ATA on
 	  SiS 964/965/966/180 and Parallel ATA on SiS 180.
@@ -183,6 +176,7 @@ config SATA_SIS
 config SATA_ULI
 	tristate "ULi Electronics SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for ULi Electronics SATA.
 
@@ -191,6 +185,7 @@ config SATA_ULI
 config SATA_VIA
 	tristate "VIA SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for VIA Serial ATA.
 
@@ -199,6 +194,7 @@ config SATA_VIA
 config SATA_VITESSE
 	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Vitesse VSC7174 and Intel 31244 Serial ATA.
 
@@ -207,12 +203,14 @@ config SATA_VITESSE
 config SATA_INIC162X
 	tristate "Initio 162x SATA support (HIGHLY EXPERIMENTAL)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for Initio 162x Serial ATA.
 
 config PATA_ACPI
 	tristate "ACPI firmware driver for PATA"
 	depends on ATA_ACPI
+	select ATA_SFF
 	help
 	  This option enables an ACPI method driver which drives
 	  motherboard PATA controller interfaces through the ACPI
@@ -222,6 +220,7 @@ config PATA_ACPI
 config PATA_ALI
 	tristate "ALi PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the ALi ATA interfaces
 	  found on the many ALi chipsets.
@@ -231,6 +230,7 @@ config PATA_ALI
 config PATA_AMD
 	tristate "AMD/NVidia PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the AMD and NVidia PATA
 	  interfaces found on the chipsets for Athlon/Athlon64.
@@ -240,6 +240,7 @@ config PATA_AMD
 config PATA_ARTOP
 	tristate "ARTOP 6210/6260 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for ARTOP PATA controllers.
 
@@ -248,6 +249,7 @@ config PATA_ARTOP
 config PATA_AT32
 	tristate "Atmel AVR32 PATA support (Experimental)"
 	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the IDE devices on the
 	  Atmel AT32AP platform.
@@ -257,6 +259,7 @@ config PATA_AT32
 config PATA_ATIIXP
 	tristate "ATI PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the ATI ATA interfaces
 	  found on the many ATI chipsets.
@@ -266,6 +269,7 @@ config PATA_ATIIXP
 config PATA_CMD640_PCI
 	tristate "CMD640 PCI PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the CMD640 PCI IDE
 	  interface chip. Only the primary channel is currently
@@ -276,6 +280,7 @@ config PATA_CMD640_PCI
 config PATA_CMD64X
 	tristate "CMD64x PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the CMD64x series chips
 	  except for the CMD640.
@@ -285,6 +290,7 @@ config PATA_CMD64X
 config PATA_CS5520
 	tristate "CS5510/5520 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the Cyrix 5510/5520
 	  companion chip used with the MediaGX/Geode processor family.
@@ -294,6 +300,7 @@ config PATA_CS5520
 config PATA_CS5530
 	tristate "CS5530 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the Cyrix/NatSemi/AMD CS5530
 	  companion chip used with the MediaGX/Geode processor family.
@@ -303,6 +310,7 @@ config PATA_CS5530
 config PATA_CS5535
 	tristate "CS5535 PATA support (Experimental)"
 	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the NatSemi/AMD CS5535
 	  companion chip used with the Geode processor family.
@@ -312,6 +320,7 @@ config PATA_CS5535
 config PATA_CS5536
 	tristate "CS5536 PATA support (Experimental)"
 	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the AMD CS5536
 	  companion chip used with the Geode LX processor family.
@@ -321,6 +330,7 @@ config PATA_CS5536
 config PATA_CYPRESS
 	tristate "Cypress CY82C693 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the Cypress/Contaq CY82C693
 	  chipset found in some Alpha systems
@@ -330,6 +340,7 @@ config PATA_CYPRESS
 config PATA_EFAR
 	tristate "EFAR SLC90E66 support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the EFAR SLC90E66
 	  IDE controller found on some older machines.
@@ -339,6 +350,7 @@ config PATA_EFAR
 config ATA_GENERIC
 	tristate "Generic ATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for generic BIOS configured
 	  ATA controllers via the new ATA layer
@@ -348,6 +360,7 @@ config ATA_GENERIC
 config PATA_HPT366
 	tristate "HPT 366/368 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the HPT 366 and 368
 	  PATA controllers via the new ATA layer.
@@ -357,6 +370,7 @@ config PATA_HPT366
 config PATA_HPT37X
 	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the majority of the later HPT
 	  PATA controllers via the new ATA layer.
@@ -366,6 +380,7 @@ config PATA_HPT37X
 config PATA_HPT3X2N
 	tristate "HPT 372N/302N PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the N variant HPT PATA
 	  controllers via the new ATA layer
@@ -375,6 +390,7 @@ config PATA_HPT3X2N
 config PATA_HPT3X3
 	tristate "HPT 343/363 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the HPT 343/363
 	  PATA controllers via the new ATA layer
@@ -384,6 +400,7 @@ config PATA_HPT3X3
 config PATA_HPT3X3_DMA
 	bool "HPT 343/363 DMA support (Experimental)"
 	depends on PATA_HPT3X3
+	select ATA_SFF
 	help
 	  This option enables DMA support for the HPT343/363
 	  controllers. Enable with care as there are still some
@@ -392,6 +409,7 @@ config PATA_HPT3X3_DMA
 config PATA_ISAPNP
 	tristate "ISA Plug and Play PATA support (Experimental)"
 	depends on EXPERIMENTAL && ISAPNP
+	select ATA_SFF
 	help
 	  This option enables support for ISA plug & play ATA
 	  controllers such as those found on old soundcards.
@@ -401,6 +419,7 @@ config PATA_ISAPNP
 config PATA_IT821X
 	tristate "IT8211/2 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the ITE 8211 and 8212
 	  PATA controllers via the new ATA layer, including RAID
@@ -411,6 +430,7 @@ config PATA_IT821X
 config PATA_IT8213
 	tristate "IT8213 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the ITE 821 PATA
           controllers via the new ATA layer.
@@ -420,6 +440,7 @@ config PATA_IT8213
 config PATA_JMICRON
 	tristate "JMicron PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  Enable support for the JMicron IDE controller, via the new
 	  ATA layer.
@@ -429,6 +450,7 @@ config PATA_JMICRON
 config PATA_LEGACY
 	tristate "Legacy ISA PATA support (Experimental)"
 	depends on ISA && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for ISA/VLB bus legacy PATA
 	  ports and allows them to be accessed via the new ATA layer.
@@ -438,6 +460,7 @@ config PATA_LEGACY
 config PATA_TRIFLEX
 	tristate "Compaq Triflex PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  Enable support for the Compaq 'Triflex' IDE controller as found
 	  on many Compaq Pentium-Pro systems, via the new ATA layer.
@@ -447,6 +470,7 @@ config PATA_TRIFLEX
 config PATA_MARVELL
 	tristate "Marvell PATA support via legacy mode"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables limited support for the Marvell 88SE6145 ATA
 	  controller.
@@ -456,6 +480,7 @@ config PATA_MARVELL
 config PATA_MPC52xx
 	tristate "Freescale MPC52xx SoC internal IDE"
 	depends on PPC_MPC52xx
+	select ATA_SFF
 	help
 	  This option enables support for integrated IDE controller
 	  of the Freescale MPC52xx SoC.
@@ -465,6 +490,7 @@ config PATA_MPC52xx
 config PATA_MPIIX
 	tristate "Intel PATA MPIIX support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for MPIIX PATA support.
 
@@ -473,6 +499,7 @@ config PATA_MPIIX
 config PATA_OLDPIIX
 	tristate "Intel PATA old PIIX support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for early PIIX PATA support.
 
@@ -481,6 +508,7 @@ config PATA_OLDPIIX
 config PATA_NETCELL
 	tristate "NETCELL Revolution RAID support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the Netcell Revolution RAID
 	  PATA controller.
@@ -490,6 +518,7 @@ config PATA_NETCELL
 config PATA_NINJA32
 	tristate "Ninja32/Delkin Cardbus ATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the Ninja32, Delkin and
 	  possibly other brands of Cardbus ATA adapter
@@ -499,6 +528,7 @@ config PATA_NINJA32
 config PATA_NS87410
 	tristate "Nat Semi NS87410 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the National Semiconductor
 	  NS87410 PCI-IDE controller.
@@ -508,6 +538,7 @@ config PATA_NS87410
 config PATA_NS87415
 	tristate "Nat Semi NS87415 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the National Semiconductor
 	  NS87415 PCI-IDE controller.
@@ -517,6 +548,7 @@ config PATA_NS87415
 config PATA_OPTI
 	tristate "OPTI621/6215 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables full PIO support for the early Opti ATA
 	  controllers found on some old motherboards.
@@ -526,6 +558,7 @@ config PATA_OPTI
 config PATA_OPTIDMA
 	tristate "OPTI FireStar PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables DMA/PIO support for the later OPTi
 	  controllers found on some old motherboards and in some
@@ -536,6 +569,7 @@ config PATA_OPTIDMA
 config PATA_PCMCIA
 	tristate "PCMCIA PATA support"
 	depends on PCMCIA
+	select ATA_SFF
 	help
 	  This option enables support for PCMCIA ATA interfaces, including
 	  compact flash card adapters via the new ATA layer.
@@ -545,6 +579,7 @@ config PATA_PCMCIA
 config PATA_PDC_OLD
 	tristate "Older Promise PATA controller support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
 	  20265 and 20267 adapters.
@@ -554,12 +589,14 @@ config PATA_PDC_OLD
 config PATA_QDI
 	tristate "QDI VLB PATA support"
 	depends on ISA
+	select ATA_SFF
 	help
 	  Support for QDI 6500 and 6580 PATA controllers on VESA local bus.
 
 config PATA_RADISYS
 	tristate "RADISYS 82600 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the RADISYS 82600
 	  PATA controllers via the new ATA layer
@@ -569,6 +606,7 @@ config PATA_RADISYS
 config PATA_RB500
 	tristate "RouterBoard 500 PATA CompactFlash support"
 	depends on MIKROTIK_RB500
+	select ATA_SFF
 	help
 	  This option enables support for the RouterBoard 500
 	  PATA CompactFlash controller.
@@ -578,6 +616,7 @@ config PATA_RB500
 config PATA_RZ1000
 	tristate "PC Tech RZ1000 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables basic support for the PC Tech RZ1000/1
 	  PATA controllers via the new ATA layer
@@ -587,6 +626,7 @@ config PATA_RZ1000
 config PATA_SC1200
 	tristate "SC1200 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for the NatSemi/AMD SC1200 SoC
 	  companion chip used with the Geode processor family.
@@ -596,6 +636,7 @@ config PATA_SC1200
 config PATA_SERVERWORKS
 	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the Serverworks OSB4/CSB5/CSB6 and
 	  HT1000 PATA controllers, via the new ATA layer.
@@ -605,6 +646,7 @@ config PATA_SERVERWORKS
 config PATA_PDC2027X
 	tristate "Promise PATA 2027x support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
 
@@ -613,6 +655,7 @@ config PATA_PDC2027X
 config PATA_SIL680
 	tristate "CMD / Silicon Image 680 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for CMD / Silicon Image 680 PATA.
 
@@ -621,6 +664,7 @@ config PATA_SIL680
 config PATA_SIS
 	tristate "SiS PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  This option enables support for SiS PATA controllers
 
@@ -629,6 +673,7 @@ config PATA_SIS
 config PATA_VIA
 	tristate "VIA PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for the VIA PATA interfaces
 	  found on the many VIA chipsets.
@@ -638,6 +683,7 @@ config PATA_VIA
 config PATA_WINBOND
 	tristate "Winbond SL82C105 PATA support"
 	depends on PCI
+	select ATA_SFF
 	help
 	  This option enables support for SL82C105 PATA devices found in the
 	  Netwinder and some other systems
@@ -647,6 +693,7 @@ config PATA_WINBOND
 config PATA_WINBOND_VLB
 	tristate "Winbond W83759A VLB PATA support (Experimental)"
 	depends on ISA && EXPERIMENTAL
+	select ATA_SFF
 	help
 	  Support for the Winbond W83759A controller on Vesa Local Bus
 	  systems.
@@ -654,6 +701,7 @@ config PATA_WINBOND_VLB
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
 	depends on EMBEDDED || ARCH_RPC || PPC
+	select ATA_SFF
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems.
@@ -663,6 +711,7 @@ config PATA_PLATFORM
 config PATA_OF_PLATFORM
 	tristate "OpenFirmware platform device PATA support"
 	depends on PATA_PLATFORM && PPC_OF
+	select ATA_SFF
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems with OpenFirmware
@@ -673,6 +722,7 @@ config PATA_OF_PLATFORM
 config PATA_ICSIDE
 	tristate "Acorn ICS PATA support"
 	depends on ARM && ARCH_ACORN
+	select ATA_SFF
 	help
 	  On Acorn systems, say Y here if you wish to use the ICS PATA
 	  interface card.  This is not required for ICS partition support.
@@ -681,6 +731,7 @@ config PATA_ICSIDE
 config PATA_IXP4XX_CF
 	tristate "IXP4XX Compact Flash support"
 	depends on ARCH_IXP4XX
+	select ATA_SFF
 	help
 	  This option enables support for a Compact Flash connected on
 	  the ixp4xx expansion bus. This driver had been written for
@@ -691,6 +742,7 @@ config PATA_IXP4XX_CF
 config PATA_SCC
 	tristate "Toshiba's Cell Reference Set IDE support"
 	depends on PCI && PPC_CELLEB
+	select ATA_SFF
 	help
 	  This option enables support for the built-in IDE controller on
 	  Toshiba Cell Reference Board.
@@ -700,11 +752,11 @@ config PATA_SCC
 config PATA_BF54X
 	tristate "Blackfin 54x ATAPI support"
 	depends on BF542 || BF548 || BF549
+	select ATA_SFF
 	help
 	  This option enables support for the built-in ATAPI controller on
 	  Blackfin 54x family chips.
 
 	  If unsure, say N.
 
-endif # ATA_SFF
 endif # ATA

