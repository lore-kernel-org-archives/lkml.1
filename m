Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYHJIal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYHJIal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 04:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYHJIae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 04:30:34 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:42741 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155AbYHJIaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 04:30:30 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Grant Coady <gcoady.lk@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig try4
Date: Sun, 10 Aug 2008 18:30:18 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <em9t94trh139dvqdva2tlhu7h3ghsijrbm@4ax.com>
References: <njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com> <m3sktfw1v5.fsf@maximus.localdomain> <alpine.LFD.1.10.0808081911080.3254@localhost.localdomain> <20080809103331.1d475d5c@lxorguk.ukuu.org.uk> <m3zlnm75u1.fsf@maximus.localdomain> <20080809141028.14db9bc7@lxorguk.ukuu.org.uk> <m3skteuhod.fsf@maximus.localdomain> <20080809215918.32f25c4b@lxorguk.ukuu.org.uk> <nifs94lqm5a3qjr3rm2p9mks5tad33cbmi@4ax.com> <cu4t94hi8ei77t57vbmc9am4f2bpsrjtrh@4ax.com>
In-Reply-To: <cu4t94hi8ei77t57vbmc9am4f2bpsrjtrh@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,
Like try3 only the right patch this time, somehow I scrambled try3.
Grant.

From: Grant Coady <gcoady.lk@gmail.com>

Cleanup ATA Kconfig, this patch replaces earlier RFC patches.

Cleanup ATA Kconfig, hide the SFF option behind new PATA and SATA menu
items, sort drivers into a single list, add missing "if unsure, say..."
help text, this version gets the items indented in make menuconfig, some
inconsistent text resolved, and one long (>80 col) help line split.

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>

---
 Kconfig |  592 +++++++++++++++++++++++++++++++++-------------------------------
 1 files changed, 311 insertions(+), 281 deletions(-)

--- linux-2.6.27-rc2/drivers/ata/Kconfig	2008-07-14 07:51:29.000000000 +1000
+++ linux-2.6.27-rc2e/drivers/ata/Kconfig	2008-08-10 18:12:52.495604924 +1000
@@ -3,7 +3,7 @@
 #
 
 menuconfig ATA
-	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
+	tristate "Serial ATA (SATA) and Parallel ATA (PATA) drivers"
 	depends on HAS_IOMEM
 	depends on BLOCK
 	depends on !(M32R || M68K) || BROKEN
@@ -27,6 +27,14 @@
        bool
        default n
 
+config SATA_AHCI
+	tristate "AHCI SATA support"
+	depends on PCI
+	help
+	  This option enables support for AHCI Serial ATA.
+
+	  If unsure, say N.
+
 config ATA_ACPI
 	bool "ATA ACPI Support"
 	depends on ACPI && PCI
@@ -41,28 +49,7 @@
 	  You can disable this at kernel boot time by using the
 	  option libata.noacpi=1
 
-config SATA_PMP
-	bool "SATA Port Multiplier support"
-	default y
-	help
-	  This option adds support for SATA Port Multipliers
-	  (the SATA version of an ethernet hub, or SAS expander).
-
-config SATA_AHCI
-	tristate "AHCI SATA support"
-	depends on PCI
-	help
-	  This option enables support for AHCI Serial ATA.
-
-	  If unsure, say N.
-
-config SATA_SIL24
-	tristate "Silicon Image 3124/3132 SATA support"
-	depends on PCI
-	help
-	  This option enables support for Silicon Image 3124/3132 Serial ATA.
-
-	  If unsure, say N.
+	  If unsure, say Y.
 
 config SATA_FSL
 	tristate "Freescale 3.0Gbps SATA support"
@@ -73,155 +60,78 @@
 
 	  If unsure, say N.
 
-config ATA_SFF
-	bool "ATA SFF support"
+config SATA_PMP
+	bool "SATA Port Multiplier support"
 	default y
 	help
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
+	  This option adds support for SATA Port Multipliers
+	  (the SATA version of an ethernet hub, or SAS expander).
 
 	  If unsure, say Y.
 
-if ATA_SFF
-
-config SATA_SVW
-	tristate "ServerWorks Frodo / Apple K2 SATA support"
-	depends on PCI
-	help
-	  This option enables support for Broadcom/Serverworks/Apple K2
-	  SATA support.
-
-	  If unsure, say N.
-
-config ATA_PIIX
-	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
-	depends on PCI
-	help
-	  This option enables support for ICH5/6/7/8 Serial ATA
-	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
-	  host controllers.
-
-	  If unsure, say N.
-
-config SATA_MV
-	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	help
-	  This option enables support for the Marvell Serial ATA family.
-	  Currently supports 88SX[56]0[48][01] chips.
-
-	  If unsure, say N.
-
-config SATA_NV
-	tristate "NVIDIA SATA support"
-	depends on PCI
-	help
-	  This option enables support for NVIDIA Serial ATA.
-
-	  If unsure, say N.
-
-config PDC_ADMA
-	tristate "Pacific Digital ADMA support"
-	depends on PCI
-	help
-	  This option enables support for Pacific Digital ADMA controllers
-
-	  If unsure, say N.
-
-config SATA_QSTOR
-	tristate "Pacific Digital SATA QStor support"
-	depends on PCI
-	help
-	  This option enables support for Pacific Digital Serial ATA QStor.
-
-	  If unsure, say N.
-
-config SATA_PROMISE
-	tristate "Promise SATA TX2/TX4 support"
+config SATA_SIL24
+	tristate "Silicon Image 3124/3132 SATA support"
 	depends on PCI
 	help
-	  This option enables support for Promise Serial ATA TX2/TX4.
+	  This option enables support for Silicon Image 3124/3132 Serial ATA.
 
 	  If unsure, say N.
 
-config SATA_SX4
-	tristate "Promise SATA SX4 support"
-	depends on PCI && EXPERIMENTAL
+config ATA_SFF_PATA
+	bool "Parallel ATA (PATA) support"
+	default y
 	help
-	  This option enables support for Promise Serial ATA SX4.
-
-	  If unsure, say N.
+	  Say Y here if you want support for Parallel ATA (PATA) devices,
+	  also known as IDE devices.
 
-config SATA_SIL
-	tristate "Silicon Image SATA support"
-	depends on PCI
-	help
-	  This option enables support for Silicon Image Serial ATA.
+	  This option enables a list of available PATA drivers.
 
-	  If unsure, say N.
+	  You may turn this option off if running AHCI or similar devices.
 
-config SATA_SIS
-	tristate "SiS 964/965/966/180 SATA support"
-	depends on PCI
-	select PATA_SIS
-	help
-	  This option enables support for SiS Serial ATA on
-	  SiS 964/965/966/180 and Parallel ATA on SiS 180.
-	  The PATA support for SiS 180 requires additionally to
-	  enable the PATA_SIS driver in the config.
-	  If unsure, say N.
+	  If unsure, say Y.
 
-config SATA_ULI
-	tristate "ULi Electronics SATA support"
-	depends on PCI
+config ATA_SFF_SATA
+	bool "Serial ATA (SATA) support"
+	default y
 	help
-	  This option enables support for ULi Electronics SATA.
+	  Say Y here if you want support for Serial ATA (SATA) devices.
 
-	  If unsure, say N.
-
-config SATA_VIA
-	tristate "VIA SATA support"
-	depends on PCI
-	help
-	  This option enables support for VIA Serial ATA.
+	  This option enables a list of available SATA drivers.
 
-	  If unsure, say N.
+	  You may turn this option off if running AHCI or similar devices.
 
-config SATA_VITESSE
-	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
-	depends on PCI
-	help
-	  This option enables support for Vitesse VSC7174 and Intel 31244 Serial ATA.
+	  If unsure, say Y.
 
-	  If unsure, say N.
+config ATA_SFF
+	bool
+	default y
+	depends on ATA_SFF_PATA || ATA_SFF_SATA
 
-config SATA_INIC162X
-	tristate "Initio 162x SATA support"
-	depends on PCI
-	help
-	  This option enables support for Initio 162x Serial ATA.
+if ATA_SFF
 
 config PATA_ACPI
 	tristate "ACPI firmware driver for PATA"
-	depends on ATA_ACPI
+	depends on ATA_SFF_PATA && ATA_ACPI
 	help
 	  This option enables an ACPI method driver which drives
 	  motherboard PATA controller interfaces through the ACPI
 	  firmware in the BIOS. This driver can sometimes handle
 	  otherwise unsupported hardware.
 
+	  If unsure, say Y.
+
+config PATA_ICSIDE
+	tristate "Acorn ICS PATA support"
+	depends on ATA_SFF_PATA && ARM && ARCH_ACORN
+	help
+	  On Acorn systems, say Y here if you wish to use the ICS PATA
+	  interface card.  This is not required for ICS partition support.
+
+	  If unsure, say N.
+
 config PATA_ALI
 	tristate "ALi PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the ALi ATA interfaces
 	  found on the many ALi chipsets.
@@ -230,7 +140,7 @@
 
 config PATA_AMD
 	tristate "AMD/NVidia PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the AMD and NVidia PATA
 	  interfaces found on the chipsets for Athlon/Athlon64.
@@ -239,7 +149,7 @@
 
 config PATA_ARTOP
 	tristate "ARTOP 6210/6260 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for ARTOP PATA controllers.
 
@@ -247,7 +157,7 @@
 
 config PATA_AT32
 	tristate "Atmel AVR32 PATA support (Experimental)"
-	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
+	depends on ATA_SFF_PATA && AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
 	help
 	  This option enables support for the IDE devices on the
 	  Atmel AT32AP platform.
@@ -256,16 +166,25 @@
 
 config PATA_ATIIXP
 	tristate "ATI PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the ATI ATA interfaces
 	  found on the many ATI chipsets.
 
 	  If unsure, say N.
 
+config PATA_BF54X
+	tristate "Blackfin 54x ATAPI support"
+	depends on ATA_SFF_PATA && (BF542 || BF548 || BF549)
+	help
+	  This option enables support for the built-in ATAPI controller on
+	  Blackfin 54x family chips.
+
+	  If unsure, say N.
+
 config PATA_CMD640_PCI
 	tristate "CMD640 PCI PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the CMD640 PCI IDE
 	  interface chip. Only the primary channel is currently
@@ -275,16 +194,33 @@
 
 config PATA_CMD64X
 	tristate "CMD64x PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the CMD64x series chips
 	  except for the CMD640.
 
 	  If unsure, say N.
 
+config PATA_SIL680
+	tristate "CMD / Silicon Image 680 PATA support"
+	depends on ATA_SFF_PATA && PCI
+	help
+	  This option enables support for CMD / Silicon Image 680 PATA.
+
+	  If unsure, say N.
+
+config PATA_TRIFLEX
+	tristate "Compaq Triflex PATA support"
+	depends on ATA_SFF_PATA && PCI
+	help
+	  Enable support for the Compaq 'Triflex' IDE controller as found
+	  on many Compaq Pentium-Pro systems, via the new ATA layer.
+
+	  If unsure, say N.
+
 config PATA_CS5520
 	tristate "CS5510/5520 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the Cyrix 5510/5520
 	  companion chip used with the MediaGX/Geode processor family.
@@ -293,7 +229,7 @@
 
 config PATA_CS5530
 	tristate "CS5530 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Cyrix/NatSemi/AMD CS5530
 	  companion chip used with the MediaGX/Geode processor family.
@@ -302,7 +238,7 @@
 
 config PATA_CS5535
 	tristate "CS5535 PATA support (Experimental)"
-	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && X86 && !X86_64 && EXPERIMENTAL
 	help
 	  This option enables support for the NatSemi/AMD CS5535
 	  companion chip used with the Geode processor family.
@@ -311,7 +247,7 @@
 
 config PATA_CS5536
 	tristate "CS5536 PATA support (Experimental)"
-	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && X86 && !X86_64 && EXPERIMENTAL
 	help
 	  This option enables support for the AMD CS5536
 	  companion chip used with the Geode LX processor family.
@@ -320,7 +256,7 @@
 
 config PATA_CYPRESS
 	tristate "Cypress CY82C693 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Cypress/Contaq CY82C693
 	  chipset found in some Alpha systems
@@ -329,25 +265,51 @@
 
 config PATA_EFAR
 	tristate "EFAR SLC90E66 support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the EFAR SLC90E66
 	  IDE controller found on some older machines.
 
 	  If unsure, say N.
 
+config PATA_MPC52xx
+	tristate "Freescale MPC52xx SoC internal IDE"
+	depends on ATA_SFF_PATA && PPC_MPC52xx
+	help
+	  This option enables support for integrated IDE controller
+	  of the Freescale MPC52xx SoC.
+
+	  If unsure, say N.
+
 config ATA_GENERIC
 	tristate "Generic ATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for generic BIOS configured
 	  ATA controllers via the new ATA layer
 
 	  If unsure, say N.
 
+config PATA_HPT3X3
+	tristate "HPT 343/363 PATA support"
+	depends on ATA_SFF_PATA && PCI
+	help
+	  This option enables support for the HPT 343/363
+	  PATA controllers via the new ATA layer
+
+	  If unsure, say N.
+
+config PATA_HPT3X3_DMA
+	bool "HPT 343/363 DMA support (Experimental)"
+	depends on ATA_SFF_PATA && PATA_HPT3X3
+	help
+	  This option enables DMA support for the HPT343/363
+	  controllers. Enable with care as there are still some
+	  problems with DMA on this chipset.
+
 config PATA_HPT366
 	tristate "HPT 366/368 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the HPT 366 and 368
 	  PATA controllers via the new ATA layer.
@@ -356,7 +318,7 @@
 
 config PATA_HPT37X
 	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the majority of the later HPT
 	  PATA controllers via the new ATA layer.
@@ -365,33 +327,59 @@
 
 config PATA_HPT3X2N
 	tristate "HPT 372N/302N PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the N variant HPT PATA
 	  controllers via the new ATA layer
 
 	  If unsure, say N.
 
-config PATA_HPT3X3
-	tristate "HPT 343/363 PATA support"
-	depends on PCI
+config SATA_INIC162X
+	tristate "Initio 162x SATA support"
+	depends on ATA_SFF_SATA && PCI
 	help
-	  This option enables support for the HPT 343/363
-	  PATA controllers via the new ATA layer
+	  This option enables support for Initio 162x Serial ATA.
 
 	  If unsure, say N.
 
-config PATA_HPT3X3_DMA
-	bool "HPT 343/363 DMA support (Experimental)"
-	depends on PATA_HPT3X3
+config ATA_PIIX
+	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
+	depends on PCI && (ATA_SFF_PATA_SUPPORT || ATA_SFF_SATA)
 	help
-	  This option enables DMA support for the HPT343/363
-	  controllers. Enable with care as there are still some
-	  problems with DMA on this chipset.
+	  This option enables support for ICH5/6/7/8 Serial ATA
+	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
+	  host controllers.
+
+	  If unsure, say N.
+
+config PATA_MPIIX
+	tristate "Intel PATA MPIIX support"
+	depends on ATA_SFF_PATA && PCI
+	help
+	  This option enables support for MPIIX PATA support.
+
+	  If unsure, say N.
+
+config PATA_OLDPIIX
+	tristate "Intel PATA old PIIX support"
+	depends on ATA_SFF_PATA && PCI
+	help
+	  This option enables support for early PIIX PATA support.
+
+	  If unsure, say N.
+
+config PATA_SCH
+	tristate "Intel SCH PATA support"
+	depends on ATA_SFF_PATA && PCI
+	help
+	  This option enables support for Intel SCH PATA on the Intel
+	  SCH (US15W, US15L, UL11L) series host controllers.
+
+	  If unsure, say N.
 
 config PATA_ISAPNP
 	tristate "ISA Plug and Play PATA support (Experimental)"
-	depends on EXPERIMENTAL && ISAPNP
+	depends on ATA_SFF_PATA && EXPERIMENTAL && ISAPNP
 	help
 	  This option enables support for ISA plug & play ATA
 	  controllers such as those found on old soundcards.
@@ -400,7 +388,7 @@
 
 config PATA_IT821X
 	tristate "IT8211/2 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the ITE 8211 and 8212
 	  PATA controllers via the new ATA layer, including RAID
@@ -410,16 +398,26 @@
 
 config PATA_IT8213
 	tristate "IT8213 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the ITE 821 PATA
           controllers via the new ATA layer.
 
 	  If unsure, say N.
 
+config PATA_IXP4XX_CF
+	tristate "IXP4XX Compact Flash support"
+	depends on ATA_SFF_PATA && ARCH_IXP4XX
+	help
+	  This option enables support for a Compact Flash connected on
+	  the ixp4xx expansion bus. This driver had been written for
+	  Loft/Avila boards in mind but can work with others.
+
+	  If unsure, say N.
+
 config PATA_JMICRON
 	tristate "JMicron PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  Enable support for the JMicron IDE controller, via the new
 	  ATA layer.
@@ -428,59 +426,52 @@
 
 config PATA_LEGACY
 	tristate "Legacy ISA PATA support (Experimental)"
-	depends on ISA && EXPERIMENTAL
+	depends on ATA_SFF_PATA && ISA && EXPERIMENTAL
 	help
 	  This option enables support for ISA/VLB bus legacy PATA
 	  ports and allows them to be accessed via the new ATA layer.
 
 	  If unsure, say N.
 
-config PATA_TRIFLEX
-	tristate "Compaq Triflex PATA support"
-	depends on PCI
-	help
-	  Enable support for the Compaq 'Triflex' IDE controller as found
-	  on many Compaq Pentium-Pro systems, via the new ATA layer.
-
-	  If unsure, say N.
-
 config PATA_MARVELL
 	tristate "Marvell PATA support via legacy mode"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables limited support for the Marvell 88SE6145 ATA
 	  controller.
 
 	  If unsure, say N.
 
-config PATA_MPC52xx
-	tristate "Freescale MPC52xx SoC internal IDE"
-	depends on PPC_MPC52xx
+config SATA_MV
+	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
+	depends on ATA_SFF_SATA && EXPERIMENTAL
 	help
-	  This option enables support for integrated IDE controller
-	  of the Freescale MPC52xx SoC.
+	  This option enables support for the Marvell Serial ATA family.
+	  Currently supports 88SX[56]0[48][01] chips.
 
 	  If unsure, say N.
 
-config PATA_MPIIX
-	tristate "Intel PATA MPIIX support"
-	depends on PCI
+config PATA_NS87410
+	tristate "Nat Semi NS87410 PATA support (Experimental)"
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
-	  This option enables support for MPIIX PATA support.
+	  This option enables support for the National Semiconductor
+	  NS87410 PCI-IDE controller.
 
 	  If unsure, say N.
 
-config PATA_OLDPIIX
-	tristate "Intel PATA old PIIX support"
-	depends on PCI
+config PATA_NS87415
+	tristate "Nat Semi NS87415 PATA support (Experimental)"
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
-	  This option enables support for early PIIX PATA support.
+	  This option enables support for the National Semiconductor
+	  NS87415 PCI-IDE controller.
 
 	  If unsure, say N.
 
 config PATA_NETCELL
 	tristate "NETCELL Revolution RAID support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the Netcell Revolution RAID
 	  PATA controller.
@@ -489,34 +480,24 @@
 
 config PATA_NINJA32
 	tristate "Ninja32/Delkin Cardbus ATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Ninja32, Delkin and
 	  possibly other brands of Cardbus ATA adapter
 
 	  If unsure, say N.
 
-config PATA_NS87410
-	tristate "Nat Semi NS87410 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
-	help
-	  This option enables support for the National Semiconductor
-	  NS87410 PCI-IDE controller.
-
-	  If unsure, say N.
-
-config PATA_NS87415
-	tristate "Nat Semi NS87415 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+config SATA_NV
+	tristate "NVIDIA SATA support"
+	depends on ATA_SFF_SATA && PCI
 	help
-	  This option enables support for the National Semiconductor
-	  NS87415 PCI-IDE controller.
+	  This option enables support for NVIDIA Serial ATA.
 
 	  If unsure, say N.
 
 config PATA_OPTI
 	tristate "OPTI621/6215 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables full PIO support for the early Opti ATA
 	  controllers found on some old motherboards.
@@ -525,7 +506,7 @@
 
 config PATA_OPTIDMA
 	tristate "OPTI FireStar PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables DMA/PIO support for the later OPTi
 	  controllers found on some old motherboards and in some
@@ -533,33 +514,76 @@
 
 	  If unsure, say N.
 
+config PDC_ADMA
+	tristate "Pacific Digital ADMA support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for Pacific Digital ADMA controllers
+
+	  If unsure, say N.
+
+config SATA_QSTOR
+	tristate "Pacific Digital SATA QStor support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for Pacific Digital Serial ATA QStor.
+
+	  If unsure, say N.
+
 config PATA_PCMCIA
 	tristate "PCMCIA PATA support"
-	depends on PCMCIA
+	depends on ATA_SFF_PATA && PCMCIA
 	help
 	  This option enables support for PCMCIA ATA interfaces, including
 	  compact flash card adapters via the new ATA layer.
 
 	  If unsure, say N.
 
+config PATA_PDC2027X
+	tristate "Promise PATA 2027x support"
+	depends on ATA_SFF_PATA && PCI
+	help
+	  This option enables support for Promise PATA pdc20268
+	  to pdc20277 host adapters.
+
+	  If unsure, say N.
+
 config PATA_PDC_OLD
-	tristate "Older Promise PATA controller support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Promise old PATA controller support (Experimental)"
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
 	  20265 and 20267 adapters.
 
 	  If unsure, say N.
 
+config SATA_SX4
+	tristate "Promise SATA SX4 support"
+	depends on ATA_SFF_SATA && PCI && EXPERIMENTAL
+	help
+	  This option enables support for Promise Serial ATA SX4.
+
+	  If unsure, say N.
+
+config SATA_PROMISE
+	tristate "Promise SATA TX2/TX4 support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for Promise Serial ATA TX2/TX4.
+
+	  If unsure, say N.
+
 config PATA_QDI
 	tristate "QDI VLB PATA support"
-	depends on ISA
+	depends on ATA_SFF_PATA && ISA
 	help
 	  Support for QDI 6500 and 6580 PATA controllers on VESA local bus.
 
+	  If unsure, say N.
+
 config PATA_RADISYS
 	tristate "RADISYS 82600 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the RADISYS 82600
 	  PATA controllers via the new ATA layer
@@ -568,7 +592,7 @@
 
 config PATA_RB532
 	tristate "RouterBoard 532 PATA CompactFlash support"
-	depends on MIKROTIK_RB532
+	depends on ATA_SFF_PATA && MIKROTIK_RB532
 	help
 	  This option enables support for the RouterBoard 532
 	  PATA CompactFlash controller.
@@ -577,7 +601,7 @@
 
 config PATA_RZ1000
 	tristate "PC Tech RZ1000 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables basic support for the PC Tech RZ1000/1
 	  PATA controllers via the new ATA layer
@@ -586,58 +610,105 @@
 
 config PATA_SC1200
 	tristate "SC1200 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the NatSemi/AMD SC1200 SoC
 	  companion chip used with the Geode processor family.
 
 	  If unsure, say N.
 
+config SATA_SVW
+	tristate "ServerWorks Frodo / Apple K2 SATA support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for Broadcom/Serverworks/Apple K2
+	  SATA support.
+
+	  If unsure, say N.
+
 config PATA_SERVERWORKS
-	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support"
-	depends on PCI
+	tristate "ServerWorks OSB4/CSB5/CSB6/HT1000 PATA support"
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the Serverworks OSB4/CSB5/CSB6 and
 	  HT1000 PATA controllers, via the new ATA layer.
 
 	  If unsure, say N.
 
-config PATA_PDC2027X
-	tristate "Promise PATA 2027x support"
-	depends on PCI
+config SATA_SIL
+	tristate "Silicon Image SATA support"
+	depends on ATA_SFF_SATA && PCI
 	help
-	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
+	  This option enables support for Silicon Image Serial ATA.
 
 	  If unsure, say N.
 
-config PATA_SIL680
-	tristate "CMD / Silicon Image 680 PATA support"
-	depends on PCI
+config SATA_SIS
+	tristate "SiS 964/965/966/180 SATA support"
+	depends on ATA_SFF_SATA && PCI
+	select PATA_SIS
 	help
-	  This option enables support for CMD / Silicon Image 680 PATA.
+	  This option enables support for SiS Serial ATA on
+	  SiS 964/965/966/180 and Parallel ATA on SiS 180.
+	  The PATA support for SiS 180 requires additionally to
+	  enable the PATA_SIS driver in the config.
 
 	  If unsure, say N.
 
 config PATA_SIS
 	tristate "SiS PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for SiS PATA controllers
 
 	  If unsure, say N.
 
+config PATA_SCC
+	tristate "Toshiba's Cell Reference Set IDE support"
+	depends on ATA_SFF_PATA && PCI && PPC_CELLEB
+	help
+	  This option enables support for the built-in IDE controller on
+	  Toshiba Cell Reference Board.
+
+	  If unsure, say N.
+
+config SATA_ULI
+	tristate "ULi Electronics SATA support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for ULi Electronics SATA.
+
+	  If unsure, say N.
+
 config PATA_VIA
 	tristate "VIA PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the VIA PATA interfaces
 	  found on the many VIA chipsets.
 
 	  If unsure, say N.
 
+config SATA_VIA
+	tristate "VIA SATA support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for VIA Serial ATA.
+
+	  If unsure, say N.
+
+config SATA_VITESSE
+	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for Vitesse VSC7174 and
+	  Intel 31244 Serial ATA.
+
+	  If unsure, say N.
+
 config PATA_WINBOND
 	tristate "Winbond SL82C105 PATA support"
-	depends on PCI
+	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for SL82C105 PATA devices found in the
 	  Netwinder and some other systems
@@ -646,13 +717,16 @@
 
 config PATA_WINBOND_VLB
 	tristate "Winbond W83759A VLB PATA support (Experimental)"
-	depends on ISA && EXPERIMENTAL
+	depends on ATA_SFF_PATA && ISA && EXPERIMENTAL
 	help
 	  Support for the Winbond W83759A controller on Vesa Local Bus
 	  systems.
 
+	  If unsure, say N.
+
 config HAVE_PATA_PLATFORM
 	bool
+	depends on ATA_SFF_PATA
 	help
 	  This is an internal configuration node for any machine that
 	  uses pata-platform driver to enable the relevant driver in the
@@ -662,6 +736,7 @@
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
 	depends on EMBEDDED || ARCH_RPC || PPC || HAVE_PATA_PLATFORM
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems.
@@ -670,7 +745,7 @@
 
 config PATA_OF_PLATFORM
 	tristate "OpenFirmware platform device PATA support"
-	depends on PATA_PLATFORM && PPC_OF
+	depends on ATA_SFF_PATA && PATA_PLATFORM && PPC_OF
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems with OpenFirmware
@@ -678,50 +753,5 @@
 
 	  If unsure, say N.
 
-config PATA_ICSIDE
-	tristate "Acorn ICS PATA support"
-	depends on ARM && ARCH_ACORN
-	help
-	  On Acorn systems, say Y here if you wish to use the ICS PATA
-	  interface card.  This is not required for ICS partition support.
-	  If you are unsure, say N to this.
-
-config PATA_IXP4XX_CF
-	tristate "IXP4XX Compact Flash support"
-	depends on ARCH_IXP4XX
-	help
-	  This option enables support for a Compact Flash connected on
-	  the ixp4xx expansion bus. This driver had been written for
-	  Loft/Avila boards in mind but can work with others.
-
-	  If unsure, say N.
-
-config PATA_SCC
-	tristate "Toshiba's Cell Reference Set IDE support"
-	depends on PCI && PPC_CELLEB
-	help
-	  This option enables support for the built-in IDE controller on
-	  Toshiba Cell Reference Board.
-
-	  If unsure, say N.
-
-config PATA_SCH
-	tristate "Intel SCH PATA support"
-	depends on PCI
-	help
-	  This option enables support for Intel SCH PATA on the Intel
-	  SCH (US15W, US15L, UL11L) series host controllers.
-
-	  If unsure, say N.
-
-config PATA_BF54X
-	tristate "Blackfin 54x ATAPI support"
-	depends on BF542 || BF548 || BF549
-	help
-	  This option enables support for the built-in ATAPI controller on
-	  Blackfin 54x family chips.
-
-	  If unsure, say N.
-
 endif # ATA_SFF
 endif # ATA
