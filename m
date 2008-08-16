Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbYHPFQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbYHPFQY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 01:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYHPFQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 01:16:09 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:34906 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbYHPFQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 01:16:07 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/3] ATA Kconfig cleanup: hide ATA_SFF and add SATA/PATA menu items
Date: Sat, 16 Aug 2008 15:15:52 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <qjoca411hv4hm25keq70ul5pnbi7747d13@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Grant Coady <gcoady.lk@gmail.com>

ATA Kconfig cleanup 1/3: Hide ATA_SFF, add PATA and SATA driver menu
enable items, and add dependency on the enabled PATA/SATA lines to 
all the ATA drivers except the PATA_PLATFORM items.

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>

---
 Kconfig |  169 +++++++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 94 insertions(+), 75 deletions(-)

--- linux-2.6.27-rc3/drivers/ata/Kconfig	2008-07-14 07:51:29.000000000 +1000
+++ linux-2.6.27-rc3b/drivers/ata/Kconfig	2008-08-16 13:32:20.016374684 +1000
@@ -73,17 +73,31 @@
 
 	  If unsure, say N.
 
-config ATA_SFF
-	bool "ATA SFF support"
+config ATA_SFF_SATA
+	bool "SATA Serial ATA support"
+	default y
+	help
+	  This option adds support for Serial ATA controllers with SFF
+	  compliant or similar programming interface.  Many SATA
+	  controllers have an SFF interface when configured into a
+	  legacy compatibility mode.
+
+	  For users with exclusively modern controllers like AHCI,
+	  Silicon Image 3124, or Marvell 6440, you may choose to
+	  disable this uneeded SFF support.
+
+	  If unsure, say Y.
+
+config ATA_SFF_PATA
+	bool "PATA Parallel ATA support"
 	default y
 	help
-	  This option adds support for ATA controllers with SFF
-	  compliant or similar programming interface.
+	  This option adds support for Parallel ATA controllers with
+	  SFF compliant or similar programming interface.
 
 	  SFF is the legacy IDE interface that has been around since
 	  the dawn of time.  Almost all PATA controllers have an
-	  SFF interface.  Many SATA controllers have an SFF interface
-	  when configured into a legacy compatibility mode.
+	  SFF interface.
 
 	  For users with exclusively modern controllers like AHCI,
 	  Silicon Image 3124, or Marvell 6440, you may choose to
@@ -91,11 +105,16 @@
 
 	  If unsure, say Y.
 
+config ATA_SFF
+	bool
+	default y
+	depends on ATA_SFF_SATA || ATA_SFF_PATA
+
 if ATA_SFF
 
 config SATA_SVW
 	tristate "ServerWorks Frodo / Apple K2 SATA support"
-	depends on PCI
+	depends on ATA_SFF_SATA && PCI
 	help
 	  This option enables support for Broadcom/Serverworks/Apple K2
 	  SATA support.
@@ -104,7 +123,7 @@
 
 config ATA_PIIX
 	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
-	depends on PCI
+	depends on (ATA_SFF_SATA || ATA_SFF_PATA) && PCI
 	help
 	  This option enables support for ICH5/6/7/8 Serial ATA
 	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
@@ -114,7 +133,7 @@
 
 config SATA_MV
 	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on ATA_SFF_SATA && EXPERIMENTAL
 	help
 	  This option enables support for the Marvell Serial ATA family.
 	  Currently supports 88SX[56]0[48][01] chips.
@@ -123,7 +142,7 @@
 
 config SATA_NV
 	tristate "NVIDIA SATA support"
-	depends on PCI
+	depends on ATA_SFF_SATA && PCI
 	help
 	  This option enables support for NVIDIA Serial ATA.
 
@@ -131,7 +150,7 @@
 
 config PDC_ADMA
 	tristate "Pacific Digital ADMA support"
-	depends on PCI
+	depends on ATA_SFF_SATA && PCI
 	help
 	  This option enables support for Pacific Digital ADMA controllers
 
@@ -139,7 +158,7 @@
 
 config SATA_QSTOR
 	tristate "Pacific Digital SATA QStor support"
-	depends on PCI
+	depends on ATA_SFF_SATA && PCI
 	help
 	  This option enables support for Pacific Digital Serial ATA QStor.
 
@@ -147,7 +166,7 @@
 
 config SATA_PROMISE
 	tristate "Promise SATA TX2/TX4 support"
-	depends on PCI
+	depends on ATA_SFF_SATA && PCI
 	help
 	  This option enables support for Promise Serial ATA TX2/TX4.
 
@@ -155,7 +174,7 @@
 
 config SATA_SX4
 	tristate "Promise SATA SX4 support"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_SATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for Promise Serial ATA SX4.
 
@@ -163,7 +182,7 @@
 
 config SATA_SIL
 	tristate "Silicon Image SATA support"
-	depends on PCI
+	depends on ATA_SFF_SATA && PCI
 	help
 	  This option enables support for Silicon Image Serial ATA.
 
@@ -171,7 +190,7 @@
 
 config SATA_SIS
 	tristate "SiS 964/965/966/180 SATA support"
-	depends on PCI
+	depends on ATA_SFF_SATA && PCI
 	select PATA_SIS
 	help
 	  This option enables support for SiS Serial ATA on
@@ -182,7 +201,7 @@
 
 config SATA_ULI
 	tristate "ULi Electronics SATA support"
-	depends on PCI
+	depends on ATA_SFF_SATA && PCI
 	help
 	  This option enables support for ULi Electronics SATA.
 
@@ -190,7 +209,7 @@
 
 config SATA_VIA
 	tristate "VIA SATA support"
-	depends on PCI
+	depends on ATA_SFF_SATA && PCI
 	help
 	  This option enables support for VIA Serial ATA.
 
@@ -198,7 +217,7 @@
 
 config SATA_VITESSE
 	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
-	depends on PCI
+	depends on ATA_SFF_SATA && PCI
 	help
 	  This option enables support for Vitesse VSC7174 and Intel 31244 Serial ATA.
 
@@ -206,13 +225,13 @@
 
 config SATA_INIC162X
 	tristate "Initio 162x SATA support"
-	depends on PCI
+	depends on ATA_SFF_SATA && PCI
 	help
 	  This option enables support for Initio 162x Serial ATA.
 
 config PATA_ACPI
 	tristate "ACPI firmware driver for PATA"
-	depends on ATA_ACPI
+	depends on ATA_SFF_PATA && ATA_ACPI
 	help
 	  This option enables an ACPI method driver which drives
 	  motherboard PATA controller interfaces through the ACPI
@@ -221,7 +240,7 @@
 
 config PATA_ALI
 	tristate "ALi PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the ALi ATA interfaces
 	  found on the many ALi chipsets.
@@ -230,7 +249,7 @@
 
 config PATA_AMD
 	tristate "AMD/NVidia PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the AMD and NVidia PATA
 	  interfaces found on the chipsets for Athlon/Athlon64.
@@ -239,7 +258,7 @@
 
 config PATA_ARTOP
 	tristate "ARTOP 6210/6260 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for ARTOP PATA controllers.
 
@@ -247,7 +266,7 @@
 
 config PATA_AT32
 	tristate "Atmel AVR32 PATA support (Experimental)"
-	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
+	depends on ATA_SFF_PATA && AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
 	help
 	  This option enables support for the IDE devices on the
 	  Atmel AT32AP platform.
@@ -256,7 +275,7 @@
 
 config PATA_ATIIXP
 	tristate "ATI PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the ATI ATA interfaces
 	  found on the many ATI chipsets.
@@ -265,7 +284,7 @@
 
 config PATA_CMD640_PCI
 	tristate "CMD640 PCI PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the CMD640 PCI IDE
 	  interface chip. Only the primary channel is currently
@@ -275,7 +294,7 @@
 
 config PATA_CMD64X
 	tristate "CMD64x PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the CMD64x series chips
 	  except for the CMD640.
@@ -284,7 +303,7 @@
 
 config PATA_CS5520
 	tristate "CS5510/5520 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the Cyrix 5510/5520
 	  companion chip used with the MediaGX/Geode processor family.
@@ -293,7 +312,7 @@
 
 config PATA_CS5530
 	tristate "CS5530 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Cyrix/NatSemi/AMD CS5530
 	  companion chip used with the MediaGX/Geode processor family.
@@ -302,7 +321,7 @@
 
 config PATA_CS5535
 	tristate "CS5535 PATA support (Experimental)"
-	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && X86 && !X86_64 && EXPERIMENTAL
 	help
 	  This option enables support for the NatSemi/AMD CS5535
 	  companion chip used with the Geode processor family.
@@ -311,7 +330,7 @@
 
 config PATA_CS5536
 	tristate "CS5536 PATA support (Experimental)"
-	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && X86 && !X86_64 && EXPERIMENTAL
 	help
 	  This option enables support for the AMD CS5536
 	  companion chip used with the Geode LX processor family.
@@ -320,7 +339,7 @@
 
 config PATA_CYPRESS
 	tristate "Cypress CY82C693 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Cypress/Contaq CY82C693
 	  chipset found in some Alpha systems
@@ -329,7 +348,7 @@
 
 config PATA_EFAR
 	tristate "EFAR SLC90E66 support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the EFAR SLC90E66
 	  IDE controller found on some older machines.
@@ -338,7 +357,7 @@
 
 config ATA_GENERIC
 	tristate "Generic ATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for generic BIOS configured
 	  ATA controllers via the new ATA layer
@@ -347,7 +366,7 @@
 
 config PATA_HPT366
 	tristate "HPT 366/368 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the HPT 366 and 368
 	  PATA controllers via the new ATA layer.
@@ -356,7 +375,7 @@
 
 config PATA_HPT37X
 	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the majority of the later HPT
 	  PATA controllers via the new ATA layer.
@@ -365,7 +384,7 @@
 
 config PATA_HPT3X2N
 	tristate "HPT 372N/302N PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the N variant HPT PATA
 	  controllers via the new ATA layer
@@ -374,7 +393,7 @@
 
 config PATA_HPT3X3
 	tristate "HPT 343/363 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the HPT 343/363
 	  PATA controllers via the new ATA layer
@@ -383,7 +402,7 @@
 
 config PATA_HPT3X3_DMA
 	bool "HPT 343/363 DMA support (Experimental)"
-	depends on PATA_HPT3X3
+	depends on ATA_SFF_PATA && PATA_HPT3X3
 	help
 	  This option enables DMA support for the HPT343/363
 	  controllers. Enable with care as there are still some
@@ -391,7 +410,7 @@
 
 config PATA_ISAPNP
 	tristate "ISA Plug and Play PATA support (Experimental)"
-	depends on EXPERIMENTAL && ISAPNP
+	depends on ATA_SFF_PATA && EXPERIMENTAL && ISAPNP
 	help
 	  This option enables support for ISA plug & play ATA
 	  controllers such as those found on old soundcards.
@@ -400,7 +419,7 @@
 
 config PATA_IT821X
 	tristate "IT8211/2 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the ITE 8211 and 8212
 	  PATA controllers via the new ATA layer, including RAID
@@ -410,7 +429,7 @@
 
 config PATA_IT8213
 	tristate "IT8213 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the ITE 821 PATA
           controllers via the new ATA layer.
@@ -419,7 +438,7 @@
 
 config PATA_JMICRON
 	tristate "JMicron PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  Enable support for the JMicron IDE controller, via the new
 	  ATA layer.
@@ -428,7 +447,7 @@
 
 config PATA_LEGACY
 	tristate "Legacy ISA PATA support (Experimental)"
-	depends on ISA && EXPERIMENTAL
+	depends on ATA_SFF_PATA && ISA && EXPERIMENTAL
 	help
 	  This option enables support for ISA/VLB bus legacy PATA
 	  ports and allows them to be accessed via the new ATA layer.
@@ -437,7 +456,7 @@
 
 config PATA_TRIFLEX
 	tristate "Compaq Triflex PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  Enable support for the Compaq 'Triflex' IDE controller as found
 	  on many Compaq Pentium-Pro systems, via the new ATA layer.
@@ -446,7 +465,7 @@
 
 config PATA_MARVELL
 	tristate "Marvell PATA support via legacy mode"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables limited support for the Marvell 88SE6145 ATA
 	  controller.
@@ -455,7 +474,7 @@
 
 config PATA_MPC52xx
 	tristate "Freescale MPC52xx SoC internal IDE"
-	depends on PPC_MPC52xx
+	depends on ATA_SFF_PATA && PPC_MPC52xx
 	help
 	  This option enables support for integrated IDE controller
 	  of the Freescale MPC52xx SoC.
@@ -464,7 +483,7 @@
 
 config PATA_MPIIX
 	tristate "Intel PATA MPIIX support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for MPIIX PATA support.
 
@@ -472,7 +491,7 @@
 
 config PATA_OLDPIIX
 	tristate "Intel PATA old PIIX support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for early PIIX PATA support.
 
@@ -480,7 +499,7 @@
 
 config PATA_NETCELL
 	tristate "NETCELL Revolution RAID support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the Netcell Revolution RAID
 	  PATA controller.
@@ -489,7 +508,7 @@
 
 config PATA_NINJA32
 	tristate "Ninja32/Delkin Cardbus ATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Ninja32, Delkin and
 	  possibly other brands of Cardbus ATA adapter
@@ -498,7 +517,7 @@
 
 config PATA_NS87410
 	tristate "Nat Semi NS87410 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the National Semiconductor
 	  NS87410 PCI-IDE controller.
@@ -507,7 +526,7 @@
 
 config PATA_NS87415
 	tristate "Nat Semi NS87415 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the National Semiconductor
 	  NS87415 PCI-IDE controller.
@@ -516,7 +535,7 @@
 
 config PATA_OPTI
 	tristate "OPTI621/6215 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables full PIO support for the early Opti ATA
 	  controllers found on some old motherboards.
@@ -525,7 +544,7 @@
 
 config PATA_OPTIDMA
 	tristate "OPTI FireStar PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables DMA/PIO support for the later OPTi
 	  controllers found on some old motherboards and in some
@@ -535,7 +554,7 @@
 
 config PATA_PCMCIA
 	tristate "PCMCIA PATA support"
-	depends on PCMCIA
+	depends on ATA_SFF_PATA && PCMCIA
 	help
 	  This option enables support for PCMCIA ATA interfaces, including
 	  compact flash card adapters via the new ATA layer.
@@ -544,7 +563,7 @@
 
 config PATA_PDC_OLD
 	tristate "Older Promise PATA controller support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
 	  20265 and 20267 adapters.
@@ -553,13 +572,13 @@
 
 config PATA_QDI
 	tristate "QDI VLB PATA support"
-	depends on ISA
+	depends on ATA_SFF_PATA && ISA
 	help
 	  Support for QDI 6500 and 6580 PATA controllers on VESA local bus.
 
 config PATA_RADISYS
 	tristate "RADISYS 82600 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the RADISYS 82600
 	  PATA controllers via the new ATA layer
@@ -568,7 +587,7 @@
 
 config PATA_RB532
 	tristate "RouterBoard 532 PATA CompactFlash support"
-	depends on MIKROTIK_RB532
+	depends on ATA_SFF_PATA && MIKROTIK_RB532
 	help
 	  This option enables support for the RouterBoard 532
 	  PATA CompactFlash controller.
@@ -577,7 +596,7 @@
 
 config PATA_RZ1000
 	tristate "PC Tech RZ1000 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables basic support for the PC Tech RZ1000/1
 	  PATA controllers via the new ATA layer
@@ -586,7 +605,7 @@
 
 config PATA_SC1200
 	tristate "SC1200 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the NatSemi/AMD SC1200 SoC
 	  companion chip used with the Geode processor family.
@@ -595,7 +614,7 @@
 
 config PATA_SERVERWORKS
 	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the Serverworks OSB4/CSB5/CSB6 and
 	  HT1000 PATA controllers, via the new ATA layer.
@@ -604,7 +623,7 @@
 
 config PATA_PDC2027X
 	tristate "Promise PATA 2027x support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
 
@@ -612,7 +631,7 @@
 
 config PATA_SIL680
 	tristate "CMD / Silicon Image 680 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for CMD / Silicon Image 680 PATA.
 
@@ -620,7 +639,7 @@
 
 config PATA_SIS
 	tristate "SiS PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for SiS PATA controllers
 
@@ -628,7 +647,7 @@
 
 config PATA_VIA
 	tristate "VIA PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the VIA PATA interfaces
 	  found on the many VIA chipsets.
@@ -637,7 +656,7 @@
 
 config PATA_WINBOND
 	tristate "Winbond SL82C105 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for SL82C105 PATA devices found in the
 	  Netwinder and some other systems
@@ -646,7 +665,7 @@
 
 config PATA_WINBOND_VLB
 	tristate "Winbond W83759A VLB PATA support (Experimental)"
-	depends on ISA && EXPERIMENTAL
+	depends on ATA_SFF_PATA && ISA && EXPERIMENTAL
 	help
 	  Support for the Winbond W83759A controller on Vesa Local Bus
 	  systems.
@@ -680,7 +699,7 @@
 
 config PATA_ICSIDE
 	tristate "Acorn ICS PATA support"
-	depends on ARM && ARCH_ACORN
+	depends on ATA_SFF_PATA && ARM && ARCH_ACORN
 	help
 	  On Acorn systems, say Y here if you wish to use the ICS PATA
 	  interface card.  This is not required for ICS partition support.
@@ -688,7 +707,7 @@
 
 config PATA_IXP4XX_CF
 	tristate "IXP4XX Compact Flash support"
-	depends on ARCH_IXP4XX
+	depends on ATA_SFF_PATA && ARCH_IXP4XX
 	help
 	  This option enables support for a Compact Flash connected on
 	  the ixp4xx expansion bus. This driver had been written for
@@ -698,7 +717,7 @@
 
 config PATA_SCC
 	tristate "Toshiba's Cell Reference Set IDE support"
-	depends on PCI && PPC_CELLEB
+	depends on ATA_SFF_PATA && PCI && PPC_CELLEB
 	help
 	  This option enables support for the built-in IDE controller on
 	  Toshiba Cell Reference Board.
@@ -707,7 +726,7 @@
 
 config PATA_SCH
 	tristate "Intel SCH PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for Intel SCH PATA on the Intel
 	  SCH (US15W, US15L, UL11L) series host controllers.
@@ -716,7 +735,7 @@
 
 config PATA_BF54X
 	tristate "Blackfin 54x ATAPI support"
-	depends on BF542 || BF548 || BF549
+	depends on ATA_SFF_PATA && (BF542 || BF548 || BF549)
 	help
 	  This option enables support for the built-in ATAPI controller on
 	  Blackfin 54x family chips.
