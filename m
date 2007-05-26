Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbXEZKoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbXEZKoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 06:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXEZKnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 06:43:52 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:35164 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbXEZKnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 06:43:50 -0400
Date: Sat, 26 May 2007 12:41:13 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Takashi Iwai <tiwai@suse.de>, Uwe Bugla <uwe.bugla@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>
Subject: [PATCH 03/04] Use menuconfig objects 3 - sound/alsa/more
In-Reply-To: <Pine.LNX.4.61.0705260947130.7344@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0705261240530.7344@yvahk01.tjqt.qr>
References: <20070524200052.234330@gmx.net> <20070524130921.8dbd3777.akpm@linux-foundation.org>
 <s5hiragopsx.wl%tiwai@suse.de> <20070525102806.77ee9c0c.akpm@linux-foundation.org>
 <Pine.LNX.4.61.0705260947130.7344@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


CONFIG_SOUND, CONFIG_SND, CONFIG_SOUND_PRIME, ...:
Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

CONFIG_SND_*_DRIVERS:
Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 sound/aoa/Kconfig         |   10 +++++-----
 sound/aoa/codecs/Kconfig  |    4 ----
 sound/aoa/fabrics/Kconfig |    1 -
 sound/arm/Kconfig         |   11 ++++++++---
 sound/drivers/Kconfig     |    2 --
 sound/isa/Kconfig         |   25 +++++++++++++++----------
 sound/mips/Kconfig        |   12 ++++++++----
 sound/parisc/Kconfig      |   12 +++++++++---
 sound/pci/Kconfig         |   11 ++++++++---
 sound/pcmcia/Kconfig      |   14 +++++++++-----
 sound/ppc/Kconfig         |   11 ++++++++---
 sound/soc/Kconfig         |    9 ++++-----
 sound/soc/at91/Kconfig    |    2 +-
 sound/soc/codecs/Kconfig  |    5 -----
 sound/soc/pxa/Kconfig     |    2 +-
 sound/soc/s3c24xx/Kconfig |    2 +-
 sound/sparc/Kconfig       |   12 +++++++++---
 sound/usb/Kconfig         |   16 +++++++++-------
 18 files changed, 95 insertions(+), 66 deletions(-)

Index: linux-2.6.22-rc3/sound/aoa/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/aoa/Kconfig
+++ linux-2.6.22-rc3/sound/aoa/Kconfig
@@ -1,17 +1,17 @@
-menu "Apple Onboard Audio driver"
-	depends on SND!=n && PPC_PMAC
-
-config SND_AOA
+menuconfig SND_AOA
 	tristate "Apple Onboard Audio driver"
+	depends on PPC_PMAC
 	select SND_PCM
 	---help---
 	This option enables the new driver for the various
 	Apple Onboard Audio components.
 
+if SND_AOA
+
 source "sound/aoa/fabrics/Kconfig"
 
 source "sound/aoa/codecs/Kconfig"
 
 source "sound/aoa/soundbus/Kconfig"
 
-endmenu
+endif # SND_AOA
Index: linux-2.6.22-rc3/sound/aoa/codecs/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/aoa/codecs/Kconfig
+++ linux-2.6.22-rc3/sound/aoa/codecs/Kconfig
@@ -1,6 +1,5 @@
 config SND_AOA_ONYX
 	tristate "support Onyx chip"
-	depends on SND_AOA
 	select I2C
 	select I2C_POWERMAC
 	---help---
@@ -10,7 +9,6 @@ config SND_AOA_ONYX
 
 #config SND_AOA_TOPAZ
 #	tristate "support Topaz chips"
-#	depends on SND_AOA
 #	---help---
 #	This option enables support for the Topaz (CS84xx)
 #	codec chips found in the latest Apple machines,
@@ -19,7 +17,6 @@ config SND_AOA_ONYX
 
 config SND_AOA_TAS
 	tristate "support TAS chips"
-	depends on SND_AOA
 	select I2C
 	select I2C_POWERMAC
 	---help---
@@ -29,7 +26,6 @@ config SND_AOA_TAS
 
 config SND_AOA_TOONIE
 	tristate "support Toonie chip"
-	depends on SND_AOA
 	---help---
 	This option enables support for the toonie codec
 	found in the Mac Mini. If you have a Mac Mini and
Index: linux-2.6.22-rc3/sound/aoa/fabrics/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/aoa/fabrics/Kconfig
+++ linux-2.6.22-rc3/sound/aoa/fabrics/Kconfig
@@ -1,6 +1,5 @@
 config SND_AOA_FABRIC_LAYOUT
 	tristate "layout-id fabric"
-	depends on SND_AOA
 	select SND_AOA_SOUNDBUS
 	select SND_AOA_SOUNDBUS_I2S
 	---help---
Index: linux-2.6.22-rc3/sound/arm/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/arm/Kconfig
+++ linux-2.6.22-rc3/sound/arm/Kconfig
@@ -1,7 +1,12 @@
 # ALSA ARM drivers
 
-menu "ALSA ARM devices"
-	depends on SND!=n && ARM
+menuconfig SND_ARM_DRIVERS
+	bool "ALSA ARM devices"
+	depends on ARM
+	---help---
+	  Select this option if you want to select ARM specific sound drivers.
+
+if SND_ARM_DRIVERS
 
 config SND_SA11XX_UDA1341
 	tristate "SA11xx UDA1341TS driver (iPaq H3600)"
@@ -33,4 +38,4 @@ config SND_PXA2XX_AC97
 	  Say Y or M if you want to support any AC97 codec attached to
 	  the PXA2xx AC97 interface.
 
-endmenu
+endif # SND_ARM_DRIVERS
Index: linux-2.6.22-rc3/sound/drivers/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/drivers/Kconfig
+++ linux-2.6.22-rc3/sound/drivers/Kconfig
@@ -1,8 +1,6 @@
 # ALSA generic drivers
 
 menu "Generic devices"
-	depends on SND!=n
-
 
 config SND_MPU401_UART
         tristate
Index: linux-2.6.22-rc3/sound/isa/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/isa/Kconfig
+++ linux-2.6.22-rc3/sound/isa/Kconfig
@@ -1,7 +1,12 @@
 # ALSA ISA drivers
 
-menu "ISA devices"
-	depends on SND!=n && ISA && ISA_DMA_API
+menuconfig SND_ISA_DRIVERS
+	bool "ISA devices"
+	depends on ISA && ISA_DMA_API
+	---help---
+	  Enable this option if you want to select ISA specific sound drivers.
+
+if SND_ISA_DRIVERS
 
 config SND_AD1848_LIB
         tristate
@@ -22,7 +27,7 @@ config SND_ADLIB
 
 config SND_AD1816A
 	tristate "Analog Devices SoundPort AD1816A"
-	depends on PNP && ISA
+	depends on PNP
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -49,7 +54,7 @@ config SND_AD1848
 
 config SND_ALS100
 	tristate "Avance Logic ALS100/ALS120"
-	depends on PNP && ISA
+	depends on PNP
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -63,7 +68,7 @@ config SND_ALS100
 
 config SND_AZT2320
 	tristate "Aztech Systems AZT2320"
-	depends on PNP && ISA
+	depends on PNP
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -122,7 +127,7 @@ config SND_CS4236
 
 config SND_DT019X
 	tristate "Diamond Technologies DT-019X, Avance Logic ALS-007"
-	depends on PNP && ISA
+	depends on PNP
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -136,7 +141,7 @@ config SND_DT019X
 
 config SND_ES968
 	tristate "Generic ESS ES968 driver"
-	depends on PNP && ISA
+	depends on PNP
 	select ISAPNP
 	select SND_MPU401_UART
 	select SND_PCM
@@ -211,7 +216,7 @@ config SND_GUSMAX
 
 config SND_INTERWAVE
 	tristate "AMD InterWave, Gravis UltraSound PnP"
-	depends on PNP && ISA
+	depends on PNP
 	select SND_RAWMIDI
 	select SND_CS4231_LIB
 	select SND_GUS_SYNTH
@@ -225,7 +230,7 @@ config SND_INTERWAVE
 
 config SND_INTERWAVE_STB
 	tristate "AMD InterWave + TEA6330T (UltraSound 32-Pro)"
-	depends on PNP && ISA
+	depends on PNP
 	select SND_RAWMIDI
 	select SND_CS4231_LIB
 	select SND_GUS_SYNTH
@@ -398,4 +403,4 @@ config SND_WAVEFRONT_FIRMWARE_IN_KERNEL
 	  for the Wavefront driver.  If you choose N here, you need to
 	  install the firmware files from the alsa-firmware package.
 
-endmenu
+endif # SND_ISA_DRIVERS
Index: linux-2.6.22-rc3/sound/mips/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/mips/Kconfig
+++ linux-2.6.22-rc3/sound/mips/Kconfig
@@ -1,7 +1,12 @@
 # ALSA MIPS drivers
 
-menu "ALSA MIPS devices"
-	depends on SND!=n && MIPS
+menuconfig SND_MIPS_DRIVERS
+	bool "ALSA MIPS devices"
+	depends on MIPS
+	---help---
+	  Enable this option if you want to select MIPS specific sound drivers.
+
+if SND_MIPS_DRIVERS
 
 config SND_AU1X00
 	tristate "Au1x00 AC97 Port Driver"
@@ -11,5 +16,4 @@ config SND_AU1X00
 	help
 	  ALSA Sound driver for the Au1x00's AC97 port.
 
-endmenu
-
+endif # SND_MIPS_DRIVERS
Index: linux-2.6.22-rc3/sound/parisc/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/parisc/Kconfig
+++ linux-2.6.22-rc3/sound/parisc/Kconfig
@@ -1,7 +1,13 @@
 # ALSA PA-RISC drivers
 
-menu "GSC devices"
-	depends on SND!=n && GSC
+menuconfig SND_PARISC_DRIVERS
+	bool "GSC devices"
+	depends on GSC
+	---help---
+	  Enable this option if you want to select PA-RISC specific sound
+	  drivers.
+
+if SND_PARISC_DRIVERS
 
 config SND_HARMONY
 	tristate "Harmony/Vivace sound chip"
@@ -11,4 +17,4 @@ config SND_HARMONY
 	  chip found in most GSC-based PA-RISC workstations.  It's frequently
 	  provided as part of the Lasi multi-function IC.
 
-endmenu
+endif # SND_PARISC_DRIVERS
Index: linux-2.6.22-rc3/sound/pci/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/pci/Kconfig
+++ linux-2.6.22-rc3/sound/pci/Kconfig
@@ -1,7 +1,12 @@
 # ALSA PCI drivers
 
-menu "PCI devices"
-	depends on SND!=n && PCI
+menuconfig SND_PCI_DRIVERS
+	bool "PCI devices"
+	depends on PCI
+	---help---
+	  Enable this option if you want to select PCI specific sound drivers.
+
+if SND_PCI_DRIVERS
 
 config SND_AD1889
 	tristate "Analog Devices AD1889"
@@ -734,4 +739,4 @@ config SND_AC97_POWER_SAVE
 	  snd-ac97-codec driver.  You can toggle it dynamically over
 	  sysfs, too.
 
-endmenu
+endif # SND_PCI_DRIVERS
Index: linux-2.6.22-rc3/sound/pcmcia/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/pcmcia/Kconfig
+++ linux-2.6.22-rc3/sound/pcmcia/Kconfig
@@ -1,11 +1,16 @@
 # ALSA PCMCIA drivers
 
-menu "PCMCIA devices"
-	depends on SND!=n && PCMCIA
+menuconfig SND_PCMCIA_DRIVERS
+	bool "PCMCIA devices"
+	depends on PCMCIA
+	---help---
+	  Enable this option if you want to select PCMCIA specific sound
+	  drivers.
+
+if SND_PCMCIA_DRIVERS
 
 config SND_VXPOCKET
 	tristate "Digigram VXpocket"
-	depends on PCMCIA
 	select SND_VX_LIB
 	help
 	  Say Y here to include support for Digigram VXpocket and
@@ -16,7 +21,6 @@ config SND_VXPOCKET
 
 config SND_PDAUDIOCF
 	tristate "Sound Core PDAudioCF"
-	depends on PCMCIA
 	select SND_PCM
 	help
 	  Say Y here to include support for Sound Core PDAudioCF
@@ -25,4 +29,4 @@ config SND_PDAUDIOCF
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-pdaudiocf.
 
-endmenu
+endif # SND_PCMCIA_DRIVERS
Index: linux-2.6.22-rc3/sound/ppc/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/ppc/Kconfig
+++ linux-2.6.22-rc3/sound/ppc/Kconfig
@@ -1,7 +1,12 @@
 # ALSA PowerMac drivers
 
-menu "ALSA PowerMac devices"
-	depends on SND!=n && PPC
+menuconfig SND_PPC_DRIVERS
+	bool "ALSA PowerMac devices"
+	depends on PPC
+	---help---
+	  Enable this option if you want to select PPC specific sound drivers.
+
+if SND_PPC_DRIVERS
 
 comment "ALSA PowerMac requires I2C"
 	depends on I2C=n
@@ -32,4 +37,4 @@ config SND_POWERMAC_AUTO_DRC
 	  Note that you can turn on/off DRC manually even without this
 	  option.
 
-endmenu
+endif # SND_PPC_DRIVERS
Index: linux-2.6.22-rc3/sound/soc/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/soc/Kconfig
+++ linux-2.6.22-rc3/sound/soc/Kconfig
@@ -2,13 +2,10 @@
 # SoC audio configuration
 #
 
-menu "System on Chip audio support"
-	depends on SND!=n
-
 config SND_SOC_AC97_BUS
 	bool
 
-config SND_SOC
+menuconfig SND_SOC
 	tristate "ALSA for SoC audio support"
 	select SND_PCM
 	---help---
@@ -22,6 +19,8 @@ config SND_SOC
 	  This ASoC audio support can also be built as a module.  If so, the module
 	  will be called snd-soc-core.
 
+if SND_SOC
+
 # All the supported Soc's
 source "sound/soc/at91/Kconfig"
 source "sound/soc/pxa/Kconfig"
@@ -30,4 +29,4 @@ source "sound/soc/s3c24xx/Kconfig"
 # Supported codecs
 source "sound/soc/codecs/Kconfig"
 
-endmenu
+endif # SND_SOC
Index: linux-2.6.22-rc3/sound/soc/at91/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/soc/at91/Kconfig
+++ linux-2.6.22-rc3/sound/soc/at91/Kconfig
@@ -1,6 +1,6 @@
 config SND_AT91_SOC
 	tristate "SoC Audio for the Atmel AT91 System-on-Chip"
-	depends on ARCH_AT91 && SND_SOC
+	depends on ARCH_AT91
 	help
 	  Say Y or M if you want to add support for codecs attached to
 	  the AT91 SSC interface. You will also need
Index: linux-2.6.22-rc3/sound/soc/codecs/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/soc/codecs/Kconfig
+++ linux-2.6.22-rc3/sound/soc/codecs/Kconfig
@@ -1,19 +1,14 @@
 config SND_SOC_AC97_CODEC
 	tristate
-	depends on SND_SOC
 
 config SND_SOC_WM8731
 	tristate
-	depends on SND_SOC
 
 config SND_SOC_WM8750
 	tristate
-	depends on SND_SOC
 
 config SND_SOC_WM8753
 	tristate
-	depends on SND_SOC
 
 config SND_SOC_WM9712
 	tristate
-	depends on SND_SOC
Index: linux-2.6.22-rc3/sound/soc/pxa/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/soc/pxa/Kconfig
+++ linux-2.6.22-rc3/sound/soc/pxa/Kconfig
@@ -1,6 +1,6 @@
 config SND_PXA2XX_SOC
 	tristate "SoC Audio for the Intel PXA2xx chip"
-	depends on ARCH_PXA && SND_SOC
+	depends on ARCH_PXA
 	help
 	  Say Y or M if you want to add support for codecs attached to
 	  the PXA2xx AC97, I2S or SSP interface. You will also need
Index: linux-2.6.22-rc3/sound/soc/s3c24xx/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/soc/s3c24xx/Kconfig
+++ linux-2.6.22-rc3/sound/soc/s3c24xx/Kconfig
@@ -1,6 +1,6 @@
 config SND_S3C24XX_SOC
 	tristate "SoC Audio for the Samsung S3C24XX chips"
-	depends on ARCH_S3C2410 && SND_SOC
+	depends on ARCH_S3C2410
 	help
 	  Say Y or M if you want to add support for codecs attached to
 	  the S3C24XX AC97, I2S or SSP interface. You will also need
Index: linux-2.6.22-rc3/sound/sparc/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/sparc/Kconfig
+++ linux-2.6.22-rc3/sound/sparc/Kconfig
@@ -1,7 +1,13 @@
 # ALSA Sparc drivers
 
-menu "ALSA Sparc devices"
-	depends on SND!=n && SPARC
+menuconfig SND_SPARC_DRIVERS
+	bool "ALSA Sparc devices"
+	depends on SPARC
+	---help---
+	  Enable this option if you want to select SPARC specific sound
+	  drivers.
+
+if SND_SPARC_DRIVERS
 
 config SND_SUN_AMD7930
 	tristate "Sun AMD7930"
@@ -32,4 +38,4 @@ config SND_SUN_DBRI
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-sun-dbri.
 
-endmenu
+endif # SND_SPARC_DRIVERS
Index: linux-2.6.22-rc3/sound/usb/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/usb/Kconfig
+++ linux-2.6.22-rc3/sound/usb/Kconfig
@@ -1,11 +1,15 @@
 # ALSA USB drivers
 
-menu "USB devices"
-	depends on SND!=n && USB!=n
+menuconfig SND_USB_DRIVERS
+	bool "USB devices"
+	depends on USB
+	---help---
+	  Enable this option if you want to select USB specific sound drivers.
+
+if SND_USB_DRIVERS
 
 config SND_USB_AUDIO
 	tristate "USB Audio/MIDI driver"
-	depends on USB
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_PCM
@@ -18,7 +22,7 @@ config SND_USB_AUDIO
 
 config SND_USB_USX2Y
 	tristate "Tascam US-122, US-224 and US-428 USB driver"
-	depends on USB && (X86 || PPC || ALPHA)
+	depends on X86 || PPC || ALPHA
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_PCM
@@ -31,7 +35,6 @@ config SND_USB_USX2Y
 
 config SND_USB_CAIAQ
 	tristate "Native Instruments USB audio devices"
-	 depends on USB
 	 select SND_HWDEP
 	 select SND_RAWMIDI
 	 select SND_PCM
@@ -57,5 +60,4 @@ config SND_USB_CAIAQ_INPUT
 	   * Native Instruments RigKontrol2
 	   * Native Instruments Audio Kontrol 1
 
-endmenu
-
+endif # SND_USB_DRIVERS
