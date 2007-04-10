Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbXDJVMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbXDJVMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbXDJVMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:12:30 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:46259 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbXDJVM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:12:28 -0400
Date: Tue, 10 Apr 2007 23:11:41 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jean Delvare <khali@linux-fr.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org
Subject: [PATCH 10/30] Use menuconfig objects - I2C
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102310310.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/drivers/i2c/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/i2c/Kconfig
+++ linux-2.6.21-rc5/drivers/i2c/Kconfig
@@ -2,9 +2,7 @@
 # I2C subsystem configuration
 #
 
-menu "I2C support"
-
-config I2C
+menuconfig I2C
 	tristate "I2C support"
 	---help---
 	  I2C (pronounce: I-square-C) is a slow serial bus protocol used in
@@ -22,9 +20,10 @@ config I2C
 	  This I2C support can also be built as a module.  If so, the module
 	  will be called i2c-core.
 
+if I2C
+
 config I2C_CHARDEV
 	tristate "I2C device interface"
-	depends on I2C
 	help
 	  Say Y here to use i2c-* device files, usually found in the /dev
 	  directory on your system.  They make it possible to have user-space
@@ -40,7 +39,6 @@ source drivers/i2c/chips/Kconfig
 
 config I2C_DEBUG_CORE
 	bool "I2C Core debugging messages"
-	depends on I2C
 	help
 	  Say Y here if you want the I2C core to produce a bunch of debug
 	  messages to the system log.  Select this if you are having a
@@ -48,7 +46,6 @@ config I2C_DEBUG_CORE
 
 config I2C_DEBUG_ALGO
 	bool "I2C Algorithm debugging messages"
-	depends on I2C
 	help
 	  Say Y here if you want the I2C algorithm drivers to produce a bunch
 	  of debug messages to the system log.  Select this if you are having
@@ -57,7 +54,6 @@ config I2C_DEBUG_ALGO
 
 config I2C_DEBUG_BUS
 	bool "I2C Bus debugging messages"
-	depends on I2C
 	help
 	  Say Y here if you want the I2C bus drivers to produce a bunch of
 	  debug messages to the system log.  Select this if you are having
@@ -66,12 +62,10 @@ config I2C_DEBUG_BUS
 
 config I2C_DEBUG_CHIP
 	bool "I2C Chip debugging messages"
-	depends on I2C
 	help
 	  Say Y here if you want the I2C chip drivers to produce a bunch of
 	  debug messages to the system log.  Select this if you are having
 	  a problem with I2C support and want to see more of what is going
 	  on.
 
-endmenu
-
+endif # I2C
Index: linux-2.6.21-rc5/drivers/i2c/algos/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/i2c/algos/Kconfig
+++ linux-2.6.21-rc5/drivers/i2c/algos/Kconfig
@@ -3,11 +3,9 @@
 #
 
 menu "I2C Algorithms"
-	depends on I2C
 
 config I2C_ALGOBIT
 	tristate "I2C bit-banging interfaces"
-	depends on I2C
 	help
 	  This allows you to use a range of I2C adapters called bit-banging
 	  adapters.  Say Y if you own an I2C adapter belonging to this class
@@ -18,7 +16,6 @@ config I2C_ALGOBIT
 
 config I2C_ALGOPCF
 	tristate "I2C PCF 8584 interfaces"
-	depends on I2C
 	help
 	  This allows you to use a range of I2C adapters called PCF adapters.
 	  Say Y if you own an I2C adapter belonging to this class and then say
@@ -29,7 +26,6 @@ config I2C_ALGOPCF
 
 config I2C_ALGOPCA
 	tristate "I2C PCA 9564 interfaces"
-	depends on I2C
 	help
 	  This allows you to use a range of I2C adapters called PCA adapters.
 	  Say Y if you own an I2C adapter belonging to this class and then say
@@ -40,11 +36,11 @@ config I2C_ALGOPCA
 
 config I2C_ALGO8XX
 	tristate "MPC8xx CPM I2C interface"
-	depends on 8xx && I2C
+	depends on 8xx
 
 config I2C_ALGO_SGI
 	tristate "I2C SGI interfaces"
-	depends on I2C && (SGI_IP22 || SGI_IP32 || X86_VISWS)
+	depends on SGI_IP22 || SGI_IP32 || X86_VISWS
 	help
 	  Supports the SGI interfaces like the ones found on SGI Indy VINO
 	  or SGI O2 MACE.
Index: linux-2.6.21-rc5/drivers/i2c/busses/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/i2c/busses/Kconfig
+++ linux-2.6.21-rc5/drivers/i2c/busses/Kconfig
@@ -3,11 +3,10 @@
 #
 
 menu "I2C Hardware Bus support"
-	depends on I2C
 
 config I2C_ALI1535
 	tristate "ALI 1535"
-	depends on I2C && PCI
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the SMB
 	  Host controller on Acer Labs Inc. (ALI) M1535 South Bridges.  The SMB
@@ -19,7 +18,7 @@ config I2C_ALI1535
 
 config I2C_ALI1563
 	tristate "ALI 1563"
-	depends on I2C && PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL
 	help
 	  If you say yes to this option, support will be included for the SMB
 	  Host controller on Acer Labs Inc. (ALI) M1563 South Bridges.  The SMB
@@ -31,7 +30,7 @@ config I2C_ALI1563
 
 config I2C_ALI15X3
 	tristate "ALI 15x3"
-	depends on I2C && PCI
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the
 	  Acer Labs Inc. (ALI) M1514 and M1543 motherboard I2C interfaces.
@@ -41,7 +40,7 @@ config I2C_ALI15X3
 
 config I2C_AMD756
 	tristate "AMD 756/766/768/8111 and nVidia nForce"
-	depends on I2C && PCI
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the AMD
 	  756/766/768 mainboard I2C interfaces.  The driver also includes
@@ -66,7 +65,7 @@ config I2C_AMD756_S4882
 
 config I2C_AMD8111
 	tristate "AMD 8111"
-	depends on I2C && PCI
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the
 	  second (SMBus 2.0) AMD 8111 mainboard I2C interface.
@@ -76,14 +75,14 @@ config I2C_AMD8111
 
 config I2C_AT91
 	tristate "Atmel AT91 I2C Two-Wire interface (TWI)"
-	depends on I2C && ARCH_AT91 && EXPERIMENTAL
+	depends on ARCH_AT91 && EXPERIMENTAL
 	help
 	  This supports the use of the I2C interface on Atmel AT91
 	  processors.
 
 config I2C_AU1550
 	tristate "Au1550/Au1200 SMBus interface"
-	depends on I2C && (SOC_AU1550 || SOC_AU1200)
+	depends on SOC_AU1550 || SOC_AU1200
 	help
 	  If you say yes to this option, support will be included for the
 	  Au1550 and Au1200 SMBus interface.
@@ -93,7 +92,7 @@ config I2C_AU1550
 
 config I2C_ELEKTOR
 	tristate "Elektor ISA card"
-	depends on I2C && ISA && BROKEN_ON_SMP
+	depends on ISA && BROKEN_ON_SMP
 	select I2C_ALGOPCF
 	help
 	  This supports the PCF8584 ISA bus I2C adapter.  Say Y if you own
@@ -104,7 +103,7 @@ config I2C_ELEKTOR
 
 config I2C_HYDRA
 	tristate "CHRP Apple Hydra Mac I/O I2C interface"
-	depends on I2C && PCI && PPC_CHRP && EXPERIMENTAL
+	depends on PCI && PPC_CHRP && EXPERIMENTAL
 	select I2C_ALGOBIT
 	help
 	  This supports the use of the I2C interface in the Apple Hydra Mac
@@ -116,7 +115,7 @@ config I2C_HYDRA
 
 config I2C_I801
 	tristate "Intel 82801 (ICH)"
-	depends on I2C && PCI
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the Intel
 	  801 family of mainboard I2C interfaces.  Specifically, the following
@@ -139,7 +138,7 @@ config I2C_I801
 
 config I2C_I810
 	tristate "Intel 810/815"
-	depends on I2C && PCI
+	depends on PCI
 	select I2C_ALGOBIT
 	help
 	  If you say yes to this option, support will be included for the Intel
@@ -156,7 +155,7 @@ config I2C_I810
 
 config I2C_PXA
 	tristate "Intel PXA2XX I2C adapter (EXPERIMENTAL)"
-	depends on I2C && EXPERIMENTAL && ARCH_PXA
+	depends on EXPERIMENTAL && ARCH_PXA
 	help
 	  If you have devices in the PXA I2C bus, say yes to this option.
 	  This driver can also be built as a module.  If so, the module
@@ -172,7 +171,7 @@ config I2C_PXA_SLAVE
 
 config I2C_PIIX4
 	tristate "Intel PIIX4 and compatible (ATI/Serverworks/Broadcom/SMSC)"
-	depends on I2C && PCI
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the Intel
 	  PIIX4 family of mainboard I2C interfaces.  Specifically, the following
@@ -195,7 +194,7 @@ config I2C_PIIX4
 
 config I2C_IBM_IIC
 	tristate "IBM PPC 4xx on-chip I2C interface"
-	depends on IBM_OCP && I2C
+	depends on IBM_OCP
 	help
 	  Say Y here if you want to use IIC peripheral found on 
 	  embedded IBM PPC 4xx based systems. 
@@ -205,7 +204,7 @@ config I2C_IBM_IIC
 
 config I2C_IOP3XX
 	tristate "Intel IOPx3xx and IXP4xx on-chip I2C interface"
-	depends on (ARCH_IOP32X || ARCH_IOP33X || ARCH_IXP4XX || ARCH_IOP13XX) && I2C
+	depends on ARCH_IOP32X || ARCH_IOP33X || ARCH_IXP4XX || ARCH_IOP13XX
 	help
 	  Say Y here if you want to use the IIC bus controller on
 	  the Intel IOPx3xx I/O Processors or IXP4xx Network Processors.
@@ -215,11 +214,10 @@ config I2C_IOP3XX
 
 config I2C_ISA
 	tristate
-	depends on I2C
 
 config I2C_IXP4XX
 	tristate "IXP4xx GPIO-Based I2C Interface"
-	depends on I2C && ARCH_IXP4XX
+	depends on ARCH_IXP4XX
 	select I2C_ALGOBIT
 	help
 	  Say Y here if you have an Intel IXP4xx(420,421,422,425) based 
@@ -230,7 +228,7 @@ config I2C_IXP4XX
 
 config I2C_IXP2000
 	tristate "IXP2000 GPIO-Based I2C Interface"
-	depends on I2C && ARCH_IXP2000
+	depends on ARCH_IXP2000
 	select I2C_ALGOBIT
 	help
 	  Say Y here if you have an Intel IXP2000(2400, 2800, 2850) based 
@@ -241,7 +239,7 @@ config I2C_IXP2000
 
 config I2C_POWERMAC
 	tristate "Powermac I2C interface"
-	depends on I2C && PPC_PMAC
+	depends on PPC_PMAC
 	default y
 	help
 	  This exposes the various PowerMac i2c interfaces to the linux i2c
@@ -253,7 +251,7 @@ config I2C_POWERMAC
 
 config I2C_MPC
 	tristate "MPC107/824x/85xx/52xx/86xx"
-	depends on I2C && PPC32
+	depends on PPC32
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in I2C interface on the MPC107/Tsi107/MPC8240/MPC8245 and
@@ -265,7 +263,7 @@ config I2C_MPC
 
 config I2C_NFORCE2
 	tristate "Nvidia nForce2, nForce3 and nForce4"
-	depends on I2C && PCI
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the Nvidia
 	  nForce2, nForce3 and nForce4 families of mainboard I2C interfaces.
@@ -275,7 +273,7 @@ config I2C_NFORCE2
 
 config I2C_OCORES
 	tristate "OpenCores I2C Controller"
-	depends on I2C && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  If you say yes to this option, support will be included for the
 	  OpenCores I2C controller. For details see
@@ -286,7 +284,7 @@ config I2C_OCORES
 
 config I2C_OMAP
 	tristate "OMAP I2C adapter"
-	depends on I2C && ARCH_OMAP
+	depends on ARCH_OMAP
 	default y if MACH_OMAP_H3 || MACH_OMAP_OSK
 	help
 	  If you say yes to this option, support will be included for the
@@ -296,7 +294,7 @@ config I2C_OMAP
 
 config I2C_PARPORT
 	tristate "Parallel port adapter"
-	depends on I2C && PARPORT
+	depends on PARPORT
 	select I2C_ALGOBIT
 	help
 	  This supports parallel port I2C adapters such as the ones made by
@@ -320,7 +318,6 @@ config I2C_PARPORT
 
 config I2C_PARPORT_LIGHT
 	tristate "Parallel port adapter (light)"
-	depends on I2C
 	select I2C_ALGOBIT
 	help
 	  This supports parallel port I2C adapters such as the ones made by
@@ -344,14 +341,14 @@ config I2C_PARPORT_LIGHT
 
 config I2C_PASEMI
 	tristate "PA Semi SMBus interface"
-#	depends on PPC_PASEMI && I2C && PCI
-	depends on I2C && PCI
+#	depends on PPC_PASEMI && PCI
+	depends on PCI
 	help
 	  Supports the PA Semi PWRficient on-chip SMBus interfaces.
 
 config I2C_PROSAVAGE
 	tristate "S3/VIA (Pro)Savage"
-	depends on I2C && PCI
+	depends on PCI
 	select I2C_ALGOBIT
 	help
 	  If you say yes to this option, support will be included for the
@@ -366,19 +363,19 @@ config I2C_PROSAVAGE
 
 config I2C_RPXLITE
 	tristate "Embedded Planet RPX Lite/Classic support"
-	depends on (RPXLITE || RPXCLASSIC) && I2C
+	depends on RPXLITE || RPXCLASSIC
 	select I2C_ALGO8XX
 
 config I2C_S3C2410
 	tristate "S3C2410 I2C Driver"
-	depends on I2C && ARCH_S3C2410
+	depends on ARCH_S3C2410
 	help
 	  Say Y here to include support for I2C controller in the
 	  Samsung S3C2410 based System-on-Chip devices.
 
 config I2C_SAVAGE4
 	tristate "S3 Savage 4"
-	depends on I2C && PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL
 	select I2C_ALGOBIT
 	help
 	  If you say yes to this option, support will be included for the 
@@ -389,13 +386,13 @@ config I2C_SAVAGE4
 
 config I2C_SIBYTE
 	tristate "SiByte SMBus interface"
-	depends on SIBYTE_SB1xxx_SOC && I2C
+	depends on SIBYTE_SB1xxx_SOC
 	help
 	  Supports the SiByte SOC on-chip I2C interfaces (2 channels).
 
 config SCx200_I2C
 	tristate "NatSemi SCx200 I2C using GPIO pins"
-	depends on SCx200_GPIO && I2C
+	depends on SCx200_GPIO
 	select I2C_ALGOBIT
 	help
 	  Enable the use of two GPIO pins of a SCx200 processor as an I2C bus.
@@ -423,7 +420,7 @@ config SCx200_I2C_SDA
 
 config SCx200_ACB
 	tristate "Geode ACCESS.bus support"
-	depends on X86_32 && I2C && PCI
+	depends on X86_32 && PCI
 	help
 	  Enable the use of the ACCESS.bus controllers on the Geode SCx200 and
 	  SC1100 processors and the CS5535 and CS5536 Geode companion devices.
@@ -435,7 +432,7 @@ config SCx200_ACB
 
 config I2C_SIS5595
 	tristate "SiS 5595"
-	depends on I2C && PCI
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the 
 	  SiS5595 SMBus (a subset of I2C) interface.
@@ -445,7 +442,7 @@ config I2C_SIS5595
 
 config I2C_SIS630
 	tristate "SiS 630/730"
-	depends on I2C && PCI
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the 
 	  SiS630 and SiS730 SMBus (a subset of I2C) interface.
@@ -455,7 +452,7 @@ config I2C_SIS630
 
 config I2C_SIS96X
 	tristate "SiS 96x"
-	depends on I2C && PCI
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the SiS
 	  96x SMBus (a subset of I2C) interfaces.  Specifically, the following
@@ -473,7 +470,7 @@ config I2C_SIS96X
 
 config I2C_STUB
 	tristate "I2C/SMBus Test Stub"
-	depends on I2C && EXPERIMENTAL && 'm'
+	depends on EXPERIMENTAL && m
 	default 'n'
 	help
 	  This module may be useful to developers of SMBus client drivers,
@@ -486,7 +483,7 @@ config I2C_STUB
 
 config I2C_VERSATILE
 	tristate "ARM Versatile/Realview I2C bus support"
-	depends on I2C && (ARCH_VERSATILE || ARCH_REALVIEW)
+	depends on ARCH_VERSATILE || ARCH_REALVIEW
 	select I2C_ALGOBIT
 	help
 	  Say yes if you want to support the I2C serial bus on ARMs Versatile
@@ -497,7 +494,7 @@ config I2C_VERSATILE
 
 config I2C_ACORN
 	bool "Acorn IOC/IOMD I2C bus support"
-	depends on I2C && ARCH_ACORN
+	depends on ARCH_ACORN
 	default y
 	select I2C_ALGOBIT
 	help
@@ -507,7 +504,7 @@ config I2C_ACORN
 
 config I2C_VIA
 	tristate "VIA 82C586B"
-	depends on I2C && PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL
 	select I2C_ALGOBIT
 	help
 	  If you say yes to this option, support will be included for the VIA
@@ -518,7 +515,7 @@ config I2C_VIA
 
 config I2C_VIAPRO
 	tristate "VIA VT82C596/82C686/82xx and CX700"
-	depends on I2C && PCI
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the VIA
 	  VT82C596 and later SMBus interface.  Specifically, the following
@@ -537,7 +534,7 @@ config I2C_VIAPRO
 
 config I2C_VOODOO3
 	tristate "Voodoo 3"
-	depends on I2C && PCI
+	depends on PCI
 	select I2C_ALGOBIT
 	help
 	  If you say yes to this option, support will be included for the
@@ -548,7 +545,6 @@ config I2C_VOODOO3
 
 config I2C_PCA_ISA
 	tristate "PCA9564 on an ISA bus"
-	depends on I2C
 	select I2C_ALGOPCA
 	default n
 	help
@@ -565,7 +561,7 @@ config I2C_PCA_ISA
 
 config I2C_MV64XXX
 	tristate "Marvell mv64xxx I2C Controller"
-	depends on I2C && MV64X60 && EXPERIMENTAL
+	depends on MV64X60 && EXPERIMENTAL
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in I2C interface on the Marvell 64xxx line of host bridges.
@@ -575,7 +571,7 @@ config I2C_MV64XXX
 
 config I2C_PNX
 	tristate "I2C bus support for Philips PNX targets"
-	depends on ARCH_PNX4008 && I2C
+	depends on ARCH_PNX4008
 	help
 	  This driver supports the Philips IP3204 I2C IP block master and/or
 	  slave controller
Index: linux-2.6.21-rc5/drivers/i2c/chips/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/i2c/chips/Kconfig
+++ linux-2.6.21-rc5/drivers/i2c/chips/Kconfig
@@ -3,11 +3,10 @@
 #
 
 menu "Miscellaneous I2C Chip support"
-	depends on I2C
 
 config SENSORS_DS1337
 	tristate "Dallas Semiconductor DS1337 and DS1339 Real Time Clock"
-	depends on I2C && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for Dallas Semiconductor
 	  DS1337 and DS1339 real-time clock chips.
@@ -17,7 +16,7 @@ config SENSORS_DS1337
 
 config SENSORS_DS1374
 	tristate "Maxim/Dallas Semiconductor DS1374 Real Time Clock"
-	depends on I2C && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for Dallas Semiconductor
 	  DS1374 real-time clock chips.
@@ -27,7 +26,7 @@ config SENSORS_DS1374
 
 config SENSORS_EEPROM
 	tristate "EEPROM reader"
-	depends on I2C && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get read-only access to the EEPROM data
 	  available on modern memory DIMMs and Sony Vaio laptops.  Such
@@ -38,7 +37,7 @@ config SENSORS_EEPROM
 
 config SENSORS_PCF8574
 	tristate "Philips PCF8574 and PCF8574A"
-	depends on I2C && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	default n
 	help
 	  If you say yes here you get support for Philips PCF8574 and 
@@ -52,7 +51,7 @@ config SENSORS_PCF8574
 
 config SENSORS_PCA9539
 	tristate "Philips PCA9539 16-bit I/O port"
-	depends on I2C && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for the Philips PCA9539
 	  16-bit I/O port.
@@ -62,7 +61,7 @@ config SENSORS_PCA9539
 
 config SENSORS_PCF8591
 	tristate "Philips PCF8591"
-	depends on I2C && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	default n
 	help
 	  If you say yes here you get support for Philips PCF8591 chips.
@@ -75,7 +74,7 @@ config SENSORS_PCF8591
 
 config ISP1301_OMAP
 	tristate "Philips ISP1301 with OMAP OTG"
-	depends on I2C && ARCH_OMAP_OTG
+	depends on ARCH_OMAP_OTG
 	help
 	  If you say yes here you get support for the Philips ISP1301
 	  USB-On-The-Go transceiver working with the OMAP OTG controller.
@@ -90,7 +89,7 @@ config ISP1301_OMAP
 # and having mostly OMAP-specific board support
 config TPS65010
 	tristate "TPS6501x Power Management chips"
-	depends on I2C && ARCH_OMAP
+	depends on ARCH_OMAP
 	default y if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_OSK
 	help
 	  If you say yes here you get support for the TPS6501x series of
@@ -103,7 +102,7 @@ config TPS65010
 
 config SENSORS_M41T00
 	tristate "ST M41T00 RTC chip"
-	depends on I2C && PPC32
+	depends on PPC32
 	help
 	  If you say yes here you get support for the ST M41T00 RTC chip.
 
@@ -112,7 +111,7 @@ config SENSORS_M41T00
 
 config SENSORS_MAX6875
 	tristate "Maxim MAX6875 Power supply supervisor"
-	depends on I2C && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for the Maxim MAX6875
 	  EEPROM-programmable, quad power-supply sequencer/supervisor.
#<EOF>
