Return-Path: <linux-kernel-owner+w=401wt.eu-S1751716AbXEZKnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbXEZKnl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 06:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXEZKnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 06:43:33 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:34963 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbXEZKna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 06:43:30 -0400
Date: Sat, 26 May 2007 12:40:51 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Takashi Iwai <tiwai@suse.de>, Uwe Bugla <uwe.bugla@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>
Subject: [PATCH 02/04] Use menuconfig objects 3 - sound/alsa
In-Reply-To: <Pine.LNX.4.61.0705260947130.7344@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0705261240290.7344@yvahk01.tjqt.qr>
References: <20070524200052.234330@gmx.net> <20070524130921.8dbd3777.akpm@linux-foundation.org>
 <s5hiragopsx.wl%tiwai@suse.de> <20070525102806.77ee9c0c.akpm@linux-foundation.org>
 <Pine.LNX.4.61.0705260947130.7344@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
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
 sound/Kconfig         |   10 ++++----
 sound/aoa/Kconfig     |    1 
 sound/arm/Kconfig     |    6 ++---
 sound/core/Kconfig    |   18 ++-------------
 sound/drivers/Kconfig |    8 +-----
 sound/isa/Kconfig     |   36 +++++-------------------------
 sound/mips/Kconfig    |    2 -
 sound/parisc/Kconfig  |    1 
 sound/pci/Kconfig     |   60 ++------------------------------------------------
 sound/pcmcia/Kconfig  |    4 +--
 sound/ppc/Kconfig     |    6 ++---
 sound/soc/Kconfig     |    1 
 sound/sparc/Kconfig   |    5 +---
 sound/usb/Kconfig     |    6 ++---
 14 files changed, 34 insertions(+), 130 deletions(-)

Index: linux-2.6.22-rc3/sound/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/Kconfig
+++ linux-2.6.22-rc3/sound/Kconfig
@@ -37,17 +37,17 @@ source "sound/oss/dmasound/Kconfig"
 
 if !M68K
 
-menu "Advanced Linux Sound Architecture"
-	depends on SOUND!=n
-
-config SND
+menuconfig SND
 	tristate "Advanced Linux Sound Architecture"
+	depends on SOUND!=n
 	help
 	  Say 'Y' or 'M' to enable ALSA (Advanced Linux Sound Architecture),
 	  the new base sound system.
 
 	  For more information, see <http://www.alsa-project.org/>
 
+if SND
+
 source "sound/core/Kconfig"
 
 source "sound/drivers/Kconfig"
@@ -78,7 +78,7 @@ source "sound/parisc/Kconfig"
 
 source "sound/soc/Kconfig"
 
-endmenu
+endif # SND
 
 menu "Open Sound System"
 	depends on SOUND!=n
Index: linux-2.6.22-rc3/sound/aoa/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/aoa/Kconfig
+++ linux-2.6.22-rc3/sound/aoa/Kconfig
@@ -3,7 +3,6 @@ menu "Apple Onboard Audio driver"
 
 config SND_AOA
 	tristate "Apple Onboard Audio driver"
-	depends on SND
 	select SND_PCM
 	---help---
 	This option enables the new driver for the various
Index: linux-2.6.22-rc3/sound/arm/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/arm/Kconfig
+++ linux-2.6.22-rc3/sound/arm/Kconfig
@@ -5,7 +5,7 @@ menu "ALSA ARM devices"
 
 config SND_SA11XX_UDA1341
 	tristate "SA11xx UDA1341TS driver (iPaq H3600)"
-	depends on ARCH_SA1100 && SND && L3
+	depends on ARCH_SA1100 && L3
 	select SND_PCM
 	help
 	  Say Y here if you have a Compaq iPaq H3x00 handheld computer
@@ -16,7 +16,7 @@ config SND_SA11XX_UDA1341
 
 config SND_ARMAACI
 	tristate "ARM PrimeCell PL041 AC Link support"
-	depends on SND && ARM_AMBA
+	depends on ARM_AMBA
 	select SND_PCM
 	select SND_AC97_CODEC
 
@@ -26,7 +26,7 @@ config SND_PXA2XX_PCM
 
 config SND_PXA2XX_AC97
 	tristate "AC97 driver for the Intel PXA2xx chip"
-	depends on ARCH_PXA && SND
+	depends on ARCH_PXA
 	select SND_PXA2XX_PCM
 	select SND_AC97_CODEC
 	help
Index: linux-2.6.22-rc3/sound/core/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/core/Kconfig
+++ linux-2.6.22-rc3/sound/core/Kconfig
@@ -1,24 +1,19 @@
 # ALSA soundcard-configuration
 config SND_TIMER
 	tristate
-	depends on SND
 
 config SND_PCM
 	tristate
 	select SND_TIMER
-	depends on SND
 
 config SND_HWDEP
 	tristate
-	depends on SND
 
 config SND_RAWMIDI
 	tristate
-	depends on SND
 
 config SND_SEQUENCER
 	tristate "Sequencer support"
-	depends on SND
 	select SND_TIMER
 	help
 	  Say Y or M to enable MIDI sequencer and router support.  This
@@ -44,11 +39,9 @@ config SND_SEQ_DUMMY
 
 config SND_OSSEMUL
 	bool
-	depends on SND
 
 config SND_MIXER_OSS
 	tristate "OSS Mixer API"
-	depends on SND
 	select SND_OSSEMUL
 	help
 	  To enable OSS mixer API emulation (/dev/mixer*), say Y here
@@ -61,7 +54,6 @@ config SND_MIXER_OSS
 
 config SND_PCM_OSS
 	tristate "OSS PCM (digital audio) API"
-	depends on SND
 	select SND_OSSEMUL
 	select SND_PCM
 	help
@@ -84,7 +76,7 @@ config SND_PCM_OSS_PLUGINS
 
 config SND_SEQUENCER_OSS
 	bool "OSS Sequencer API"
-	depends on SND && SND_SEQUENCER
+	depends on SND_SEQUENCER
 	select SND_OSSEMUL
 	help
 	  Say Y here to enable OSS sequencer emulation (both
@@ -98,7 +90,7 @@ config SND_SEQUENCER_OSS
 
 config SND_RTCTIMER
 	tristate "RTC Timer support"
-	depends on SND && RTC
+	depends on RTC
 	select SND_TIMER
 	help
 	  Say Y here to enable RTC timer support for ALSA.  ALSA uses
@@ -123,7 +115,6 @@ config SND_SEQ_RTCTIMER_DEFAULT
 
 config SND_DYNAMIC_MINORS
 	bool "Dynamic device file minor numbers"
-	depends on SND
 	help
 	  If you say Y here, the minor numbers of ALSA device files in
 	  /dev/snd/ are allocated dynamically.  This allows you to have
@@ -134,7 +125,6 @@ config SND_DYNAMIC_MINORS
 
 config SND_SUPPORT_OLD_API
 	bool "Support old ALSA API"
-	depends on SND
 	default y
 	help
 	  Say Y here to support the obsolete ALSA PCM API (ver.0.9.0 rc3
@@ -142,7 +132,7 @@ config SND_SUPPORT_OLD_API
 
 config SND_VERBOSE_PROCFS
 	bool "Verbose procfs contents"
-	depends on SND && PROC_FS
+	depends on PROC_FS
 	default y
 	help
 	  Say Y here to include code for verbose procfs contents (provides
@@ -151,7 +141,6 @@ config SND_VERBOSE_PROCFS
 
 config SND_VERBOSE_PRINTK
 	bool "Verbose printk"
-	depends on SND
 	help
 	  Say Y here to enable verbose log messages.  These messages
 	  will help to identify source file and position containing
@@ -161,7 +150,6 @@ config SND_VERBOSE_PRINTK
 
 config SND_DEBUG
 	bool "Debug"
-	depends on SND
 	help
 	  Say Y here to enable ALSA debug code.
 
Index: linux-2.6.22-rc3/sound/drivers/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/drivers/Kconfig
+++ linux-2.6.22-rc3/sound/drivers/Kconfig
@@ -30,7 +30,6 @@ config SND_AC97_CODEC
 
 config SND_DUMMY
 	tristate "Dummy (/dev/null) soundcard"
-	depends on SND
 	select SND_PCM
 	help
 	  Say Y here to include the dummy driver.  This driver does
@@ -59,7 +58,6 @@ config SND_VIRMIDI
 
 config SND_MTPAV
 	tristate "MOTU MidiTimePiece AV multiport MIDI"
-	depends on SND
 	select SND_RAWMIDI
 	help
 	  To use a MOTU MidiTimePiece AV multiport MIDI adapter
@@ -71,7 +69,7 @@ config SND_MTPAV
 
 config SND_MTS64
 	tristate "ESI Miditerminal 4140 driver"
-	depends on SND && PARPORT
+	depends on PARPORT
 	select SND_RAWMIDI
 	help
 	  The ESI Miditerminal 4140 is a 4 In 4 Out MIDI Interface with 
@@ -84,7 +82,6 @@ config SND_MTS64
 
 config SND_SERIAL_U16550
 	tristate "UART16550 serial MIDI driver"
-	depends on SND
 	select SND_RAWMIDI
 	help
 	  To include support for MIDI serial port interfaces, say Y here
@@ -100,7 +97,6 @@ config SND_SERIAL_U16550
 
 config SND_MPU401
 	tristate "Generic MPU-401 UART driver"
-	depends on SND
 	select SND_MPU401_UART
 	help
 	  Say Y here to include support for MIDI ports compatible with
@@ -111,7 +107,7 @@ config SND_MPU401
 
 config SND_PORTMAN2X4
 	tristate "Portman 2x4 driver"
-	depends on SND && PARPORT
+	depends on PARPORT
 	select SND_RAWMIDI
 	help
 	  Say Y here to include support for Midiman Portman 2x4 parallel
Index: linux-2.6.22-rc3/sound/isa/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/isa/Kconfig
+++ linux-2.6.22-rc3/sound/isa/Kconfig
@@ -13,7 +13,6 @@ config SND_CS4231_LIB
 
 config SND_ADLIB
 	tristate "AdLib FM card"
-	depends on SND
 	select SND_OPL3_LIB
 	help
 	  Say Y here to include support for AdLib FM cards.
@@ -23,7 +22,7 @@ config SND_ADLIB
 
 config SND_AD1816A
 	tristate "Analog Devices SoundPort AD1816A"
-	depends on SND && PNP && ISA
+	depends on PNP && ISA
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -37,7 +36,6 @@ config SND_AD1816A
 
 config SND_AD1848
 	tristate "Generic AD1848/CS4248 driver"
-	depends on SND
 	select SND_AD1848_LIB
 	help
 	  Say Y here to include support for AD1848 (Analog Devices) or
@@ -51,7 +49,7 @@ config SND_AD1848
 
 config SND_ALS100
 	tristate "Avance Logic ALS100/ALS120"
-	depends on SND && PNP && ISA
+	depends on PNP && ISA
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -65,7 +63,7 @@ config SND_ALS100
 
 config SND_AZT2320
 	tristate "Aztech Systems AZT2320"
-	depends on SND && PNP && ISA
+	depends on PNP && ISA
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -79,7 +77,6 @@ config SND_AZT2320
 
 config SND_CMI8330
 	tristate "C-Media CMI8330"
-	depends on SND
 	select SND_AD1848_LIB
 	help
 	  Say Y here to include support for soundcards based on the
@@ -90,7 +87,6 @@ config SND_CMI8330
 
 config SND_CS4231
 	tristate "Generic Cirrus Logic CS4231 driver"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_CS4231_LIB
 	help
@@ -102,7 +98,6 @@ config SND_CS4231
 
 config SND_CS4232
 	tristate "Generic Cirrus Logic CS4232 driver"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_CS4231_LIB
@@ -115,7 +110,6 @@ config SND_CS4232
 
 config SND_CS4236
 	tristate "Generic Cirrus Logic CS4236+ driver"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_CS4231_LIB
@@ -128,7 +122,7 @@ config SND_CS4236
 
 config SND_DT019X
 	tristate "Diamond Technologies DT-019X, Avance Logic ALS-007"
-	depends on SND && PNP && ISA
+	depends on PNP && ISA
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -142,7 +136,7 @@ config SND_DT019X
 
 config SND_ES968
 	tristate "Generic ESS ES968 driver"
-	depends on SND && PNP && ISA
+	depends on PNP && ISA
 	select ISAPNP
 	select SND_MPU401_UART
 	select SND_PCM
@@ -154,7 +148,6 @@ config SND_ES968
 
 config SND_ES1688
 	tristate "Generic ESS ES688/ES1688 driver"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -167,7 +160,6 @@ config SND_ES1688
 
 config SND_ES18XX
 	tristate "Generic ESS ES18xx driver"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -182,7 +174,6 @@ config SND_GUS_SYNTH
 
 config SND_GUSCLASSIC
 	tristate "Gravis UltraSound Classic"
-	depends on SND
 	select SND_RAWMIDI
 	select SND_PCM
 	select SND_GUS_SYNTH
@@ -195,7 +186,6 @@ config SND_GUSCLASSIC
 
 config SND_GUSEXTREME
 	tristate "Gravis UltraSound Extreme"
-	depends on SND
 	select SND_HWDEP
 	select SND_MPU401_UART
 	select SND_PCM
@@ -209,7 +199,6 @@ config SND_GUSEXTREME
 
 config SND_GUSMAX
 	tristate "Gravis UltraSound MAX"
-	depends on SND
 	select SND_RAWMIDI
 	select SND_CS4231_LIB
 	select SND_GUS_SYNTH
@@ -222,7 +211,7 @@ config SND_GUSMAX
 
 config SND_INTERWAVE
 	tristate "AMD InterWave, Gravis UltraSound PnP"
-	depends on SND && PNP && ISA
+	depends on PNP && ISA
 	select SND_RAWMIDI
 	select SND_CS4231_LIB
 	select SND_GUS_SYNTH
@@ -236,7 +225,7 @@ config SND_INTERWAVE
 
 config SND_INTERWAVE_STB
 	tristate "AMD InterWave + TEA6330T (UltraSound 32-Pro)"
-	depends on SND && PNP && ISA
+	depends on PNP && ISA
 	select SND_RAWMIDI
 	select SND_CS4231_LIB
 	select SND_GUS_SYNTH
@@ -250,7 +239,6 @@ config SND_INTERWAVE_STB
 
 config SND_OPL3SA2
 	tristate "Yamaha OPL3-SA2/SA3"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_CS4231_LIB
@@ -263,7 +251,6 @@ config SND_OPL3SA2
 
 config SND_OPTI92X_AD1848
 	tristate "OPTi 82C92x - AD1848"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_OPL4_LIB
 	select SND_MPU401_UART
@@ -277,7 +264,6 @@ config SND_OPTI92X_AD1848
 
 config SND_OPTI92X_CS4231
 	tristate "OPTi 82C92x - CS4231"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_OPL4_LIB
 	select SND_MPU401_UART
@@ -291,7 +277,6 @@ config SND_OPTI92X_CS4231
 
 config SND_OPTI93X
 	tristate "OPTi 82C93x"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -304,7 +289,6 @@ config SND_OPTI93X
 
 config SND_MIRO
 	tristate "Miro miroSOUND PCM1pro/PCM12/PCM20radio driver"
-	depends on SND
 	select SND_OPL4_LIB
 	select SND_CS4231_LIB
 	select SND_MPU401_UART
@@ -318,7 +302,6 @@ config SND_MIRO
 
 config SND_SB8
 	tristate "Sound Blaster 1.0/2.0/Pro (8-bit)"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_RAWMIDI
 	select SND_PCM
@@ -331,7 +314,6 @@ config SND_SB8
 
 config SND_SB16
 	tristate "Sound Blaster 16 (PnP)"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -344,7 +326,6 @@ config SND_SB16
 
 config SND_SBAWE
 	tristate "Sound Blaster AWE (32,64) (PnP)"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -375,7 +356,6 @@ config SND_SB16_CSP_FIRMWARE_IN_KERNEL
 
 config SND_SGALAXY
 	tristate "Aztech Sound Galaxy"
-	depends on SND
 	select SND_AD1848_LIB
 	help
 	  Say Y here to include support for Aztech Sound Galaxy
@@ -386,7 +366,6 @@ config SND_SGALAXY
 
 config SND_SSCAPE
 	tristate "Ensoniq SoundScape PnP driver"
-	depends on SND
 	select SND_HWDEP
 	select SND_MPU401_UART
 	select SND_CS4231_LIB
@@ -399,7 +378,6 @@ config SND_SSCAPE
 
 config SND_WAVEFRONT
 	tristate "Turtle Beach Maui,Tropez,Tropez+ (Wavefront)"
-	depends on SND
 	select FW_LOADER if !SND_WAVEFRONT_FIRMWARE_IN_KERNEL
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
Index: linux-2.6.22-rc3/sound/mips/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/mips/Kconfig
+++ linux-2.6.22-rc3/sound/mips/Kconfig
@@ -5,7 +5,7 @@ menu "ALSA MIPS devices"
 
 config SND_AU1X00
 	tristate "Au1x00 AC97 Port Driver"
-	depends on (SOC_AU1000 || SOC_AU1100 || SOC_AU1500) && SND
+	depends on SOC_AU1000 || SOC_AU1100 || SOC_AU1500
 	select SND_PCM
 	select SND_AC97_CODEC
 	help
Index: linux-2.6.22-rc3/sound/parisc/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/parisc/Kconfig
+++ linux-2.6.22-rc3/sound/parisc/Kconfig
@@ -5,7 +5,6 @@ menu "GSC devices"
 
 config SND_HARMONY
 	tristate "Harmony/Vivace sound chip"
-	depends on SND
 	select SND_PCM
 	help
 	  Say 'Y' or 'M' to include support for the Harmony/Vivace sound
Index: linux-2.6.22-rc3/sound/pci/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/pci/Kconfig
+++ linux-2.6.22-rc3/sound/pci/Kconfig
@@ -5,7 +5,6 @@ menu "PCI devices"
 
 config SND_AD1889
 	tristate "Analog Devices AD1889"
-	depends on SND
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for the integrated AC97 sound
@@ -17,7 +16,6 @@ config SND_AD1889
 
 config SND_ALS300
 	tristate "Avance Logic ALS300/ALS300+"
-	depends on SND
 	select SND_PCM
 	select SND_AC97_CODEC
 	select SND_OPL3_LIB
@@ -29,7 +27,7 @@ config SND_ALS300
 
 config SND_ALS4000
 	tristate "Avance Logic ALS4000"
-	depends on SND && ISA_DMA_API
+	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -42,7 +40,6 @@ config SND_ALS4000
 
 config SND_ALI5451
 	tristate "ALi M5451 PCI Audio Controller"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -56,7 +53,6 @@ config SND_ALI5451
 
 config SND_ATIIXP
 	tristate "ATI IXP AC97 Controller"
-	depends on SND
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for the integrated AC97 sound
@@ -68,7 +64,6 @@ config SND_ATIIXP
 
 config SND_ATIIXP_MODEM
 	tristate "ATI IXP Modem"
-	depends on SND
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for the integrated MC97 modem on
@@ -79,7 +74,6 @@ config SND_ATIIXP_MODEM
 
 config SND_AU8810
 	tristate "Aureal Advantage"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -94,7 +88,6 @@ config SND_AU8810
 
 config SND_AU8820
 	tristate "Aureal Vortex"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -108,7 +101,6 @@ config SND_AU8820
 
 config SND_AU8830
 	tristate "Aureal Vortex 2"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -123,7 +115,7 @@ config SND_AU8830
 
 config SND_AZT3328
 	tristate "Aztech AZF3328 / PCI168 (EXPERIMENTAL)"
-	depends on SND && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -136,7 +128,6 @@ config SND_AZT3328
 
 config SND_BT87X
 	tristate "Bt87x Audio Capture"
-	depends on SND
 	select SND_PCM
 	help
 	  If you want to record audio from TV cards based on
@@ -158,7 +149,6 @@ config SND_BT87X_OVERCLOCK
 
 config SND_CA0106
 	tristate "SB Audigy LS / Live 24bit"
-	depends on SND
 	select SND_AC97_CODEC
 	select SND_RAWMIDI
 	help
@@ -170,7 +160,6 @@ config SND_CA0106
 
 config SND_CMIPCI
 	tristate "C-Media 8738, 8338"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -184,7 +173,6 @@ config SND_CMIPCI
 
 config SND_CS4281
 	tristate "Cirrus Logic (Sound Fusion) CS4281"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
@@ -196,7 +184,6 @@ config SND_CS4281
 
 config SND_CS46XX
 	tristate "Cirrus Logic (Sound Fusion) CS4280/CS461x/CS462x/CS463x"
-	depends on SND
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
 	help
@@ -217,7 +204,7 @@ config SND_CS46XX_NEW_DSP
 
 config SND_CS5535AUDIO
 	tristate "CS5535/CS5536 Audio"
-	depends on SND && X86 && !X86_64
+	depends on X86 && !X86_64
 	select SND_PCM
 	select SND_AC97_CODEC
 	help
@@ -235,7 +222,6 @@ config SND_CS5535AUDIO
 
 config SND_DARLA20
 	tristate "(Echoaudio) Darla20"
-	depends on SND
 	select FW_LOADER
 	select SND_PCM
 	help
@@ -246,7 +232,6 @@ config SND_DARLA20
 
 config SND_GINA20
 	tristate "(Echoaudio) Gina20"
-	depends on SND
 	select FW_LOADER
 	select SND_PCM
 	help
@@ -257,7 +242,6 @@ config SND_GINA20
 
 config SND_LAYLA20
 	tristate "(Echoaudio) Layla20"
-	depends on SND
 	select FW_LOADER
 	select SND_RAWMIDI
 	select SND_PCM
@@ -269,7 +253,6 @@ config SND_LAYLA20
 
 config SND_DARLA24
 	tristate "(Echoaudio) Darla24"
-	depends on SND
 	select FW_LOADER
 	select SND_PCM
 	help
@@ -280,7 +263,6 @@ config SND_DARLA24
 
 config SND_GINA24
 	tristate "(Echoaudio) Gina24"
-	depends on SND
 	select FW_LOADER
 	select SND_PCM
 	help
@@ -291,7 +273,6 @@ config SND_GINA24
 
 config SND_LAYLA24
 	tristate "(Echoaudio) Layla24"
-	depends on SND
 	select FW_LOADER
 	select SND_RAWMIDI
 	select SND_PCM
@@ -303,7 +284,6 @@ config SND_LAYLA24
 
 config SND_MONA
 	tristate "(Echoaudio) Mona"
-	depends on SND
 	select FW_LOADER
 	select SND_RAWMIDI
 	select SND_PCM
@@ -315,7 +295,6 @@ config SND_MONA
 
 config SND_MIA
 	tristate "(Echoaudio) Mia"
-	depends on SND
 	select FW_LOADER
 	select SND_RAWMIDI
 	select SND_PCM
@@ -327,7 +306,6 @@ config SND_MIA
 
 config SND_ECHO3G
 	tristate "(Echoaudio) 3G cards"
-	depends on SND
 	select FW_LOADER
 	select SND_RAWMIDI
 	select SND_PCM
@@ -339,7 +317,6 @@ config SND_ECHO3G
 
 config SND_INDIGO
 	tristate "(Echoaudio) Indigo"
-	depends on SND
 	select FW_LOADER
 	select SND_PCM
 	help
@@ -350,7 +327,6 @@ config SND_INDIGO
 
 config SND_INDIGOIO
 	tristate "(Echoaudio) Indigo IO"
-	depends on SND
 	select FW_LOADER
 	select SND_PCM
 	help
@@ -361,7 +337,6 @@ config SND_INDIGOIO
 
 config SND_INDIGODJ
 	tristate "(Echoaudio) Indigo DJ"
-	depends on SND
 	select FW_LOADER
 	select SND_PCM
 	help
@@ -372,7 +347,6 @@ config SND_INDIGODJ
 
 config SND_EMU10K1
 	tristate "Emu10k1 (SB Live!, Audigy, E-mu APS)"
-	depends on SND
 	select FW_LOADER
 	select SND_HWDEP
 	select SND_RAWMIDI
@@ -390,7 +364,6 @@ config SND_EMU10K1
 
 config SND_EMU10K1X
 	tristate "Emu10k1X (Dell OEM Version)"
-	depends on SND
 	select SND_AC97_CODEC
 	select SND_RAWMIDI
 	help
@@ -402,7 +375,6 @@ config SND_EMU10K1X
 
 config SND_ENS1370
 	tristate "(Creative) Ensoniq AudioPCI 1370"
-	depends on SND
 	select SND_RAWMIDI
 	select SND_PCM
 	help
@@ -413,7 +385,6 @@ config SND_ENS1370
 
 config SND_ENS1371
 	tristate "(Creative) Ensoniq AudioPCI 1371/1373"
-	depends on SND
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
 	help
@@ -425,7 +396,6 @@ config SND_ENS1371
 
 config SND_ES1938
 	tristate "ESS ES1938/1946/1969 (Solo-1)"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
@@ -438,7 +408,6 @@ config SND_ES1938
 
 config SND_ES1968
 	tristate "ESS ES1968/1978 (Maestro-1/2/2E)"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -450,7 +419,6 @@ config SND_ES1968
 
 config SND_FM801
 	tristate "ForteMedia FM801"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
@@ -480,7 +448,6 @@ config SND_FM801_TEA575X
 
 config SND_HDA_INTEL
 	tristate "Intel HD Audio"
-	depends on SND
 	select SND_PCM
 	help
 	  Say Y here to include support for Intel "High Definition
@@ -491,7 +458,6 @@ config SND_HDA_INTEL
 
 config SND_HDSP
 	tristate "RME Hammerfall DSP Audio"
-	depends on SND
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_PCM
@@ -504,7 +470,6 @@ config SND_HDSP
 
 config SND_HDSPM
 	tristate "RME Hammerfall DSP MADI"
-	depends on SND
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_PCM
@@ -517,7 +482,6 @@ config SND_HDSPM
 
 config SND_ICE1712
 	tristate "ICEnsemble ICE1712 (Envy24)"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -534,7 +498,6 @@ config SND_ICE1712
 
 config SND_ICE1724
 	tristate "ICE/VT1724/1720 (Envy24HT/PT)"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -551,7 +514,6 @@ config SND_ICE1724
 
 config SND_INTEL8X0
 	tristate "Intel/SiS/nVidia/AMD/ALi AC97 Controller"
-	depends on SND
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for the integrated AC97 sound
@@ -564,7 +526,6 @@ config SND_INTEL8X0
 
 config SND_INTEL8X0M
 	tristate "Intel/SiS/nVidia/AMD MC97 Modem"
-	depends on SND
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for the integrated MC97 modem on
@@ -575,7 +536,6 @@ config SND_INTEL8X0M
 
 config SND_KORG1212
 	tristate "Korg 1212 IO"
-	depends on SND
 	select FW_LOADER if !SND_KORG1212_FIRMWARE_IN_KERNEL
 	select SND_PCM
 	help
@@ -595,7 +555,6 @@ config SND_KORG1212_FIRMWARE_IN_KERNEL
 
 config SND_MAESTRO3
 	tristate "ESS Allegro/Maestro3"
-	depends on SND
 	select FW_LOADER if !SND_MAESTRO3_FIRMWARE_IN_KERNEL
 	select SND_AC97_CODEC
 	help
@@ -616,7 +575,6 @@ config SND_MAESTRO3_FIRMWARE_IN_KERNEL
 
 config SND_MIXART
 	tristate "Digigram miXart"
-	depends on SND
 	select SND_HWDEP
 	select SND_PCM
 	help
@@ -628,7 +586,6 @@ config SND_MIXART
 
 config SND_NM256
 	tristate "NeoMagic NM256AV/ZX"
-	depends on SND
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for NeoMagic NM256AV/ZX chips.
@@ -638,7 +595,6 @@ config SND_NM256
 
 config SND_PCXHR
 	tristate "Digigram PCXHR"
-	depends on SND
 	select SND_PCM
 	select SND_HWDEP
 	help
@@ -649,7 +605,6 @@ config SND_PCXHR
 
 config SND_RIPTIDE
 	tristate "Conexant Riptide"
-	depends on SND
 	select FW_LOADER
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -662,7 +617,6 @@ config SND_RIPTIDE
 
 config SND_RME32
 	tristate "RME Digi32, 32/8, 32 PRO"
-	depends on SND
 	select SND_PCM
 	help
 	  Say Y to include support for RME Digi32, Digi32 PRO and
@@ -674,7 +628,6 @@ config SND_RME32
 
 config SND_RME96
 	tristate "RME Digi96, 96/8, 96/8 PRO"
-	depends on SND
 	select SND_PCM
 	help
 	  Say Y here to include support for RME Digi96, Digi96/8 and
@@ -685,7 +638,6 @@ config SND_RME96
 
 config SND_RME9652
 	tristate "RME Digi9652 (Hammerfall)"
-	depends on SND
 	select SND_PCM
 	help
 	  Say Y here to include support for RME Hammerfall (RME
@@ -696,7 +648,6 @@ config SND_RME9652
 
 config SND_SONICVIBES
 	tristate "S3 SonicVibes"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
@@ -709,7 +660,6 @@ config SND_SONICVIBES
 
 config SND_TRIDENT
 	tristate "Trident 4D-Wave DX/NX; SiS 7018"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -721,7 +671,6 @@ config SND_TRIDENT
 
 config SND_VIA82XX
 	tristate "VIA 82C686A/B, 8233/8235 AC97 Controller"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -733,7 +682,6 @@ config SND_VIA82XX
 
 config SND_VIA82XX_MODEM
 	tristate "VIA 82C686A/B, 8233 based Modems"
-	depends on SND
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for the integrated MC97 modem on
@@ -744,7 +692,6 @@ config SND_VIA82XX_MODEM
 
 config SND_VX222
 	tristate "Digigram VX222"
-	depends on SND
 	select SND_VX_LIB
 	help
 	  Say Y here to include support for Digigram VX222 soundcards.
@@ -754,7 +701,6 @@ config SND_VX222
 
 config SND_YMFPCI
 	tristate "Yamaha YMF724/740/744/754"
-	depends on SND
 	select FW_LOADER if !SND_YMFPCI_FIRMWARE_IN_KERNEL
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
Index: linux-2.6.22-rc3/sound/pcmcia/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/pcmcia/Kconfig
+++ linux-2.6.22-rc3/sound/pcmcia/Kconfig
@@ -5,7 +5,7 @@ menu "PCMCIA devices"
 
 config SND_VXPOCKET
 	tristate "Digigram VXpocket"
-	depends on SND && PCMCIA
+	depends on PCMCIA
 	select SND_VX_LIB
 	help
 	  Say Y here to include support for Digigram VXpocket and
@@ -16,7 +16,7 @@ config SND_VXPOCKET
 
 config SND_PDAUDIOCF
 	tristate "Sound Core PDAudioCF"
-	depends on SND && PCMCIA
+	depends on PCMCIA
 	select SND_PCM
 	help
 	  Say Y here to include support for Sound Core PDAudioCF
Index: linux-2.6.22-rc3/sound/ppc/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/ppc/Kconfig
+++ linux-2.6.22-rc3/sound/ppc/Kconfig
@@ -4,14 +4,14 @@ menu "ALSA PowerMac devices"
 	depends on SND!=n && PPC
 
 comment "ALSA PowerMac requires I2C"
-	depends on SND && I2C=n
+	depends on I2C=n
 
 comment "ALSA PowerMac requires INPUT"
-	depends on SND && INPUT=n
+	depends on INPUT=n
 
 config SND_POWERMAC
 	tristate "PowerMac (AWACS, DACA, Burgundy, Tumbler, Keywest)"
-	depends on SND && I2C && INPUT && PPC_PMAC
+	depends on I2C && INPUT && PPC_PMAC
 	select SND_PCM
 	help
 	  Say Y here to include support for the integrated sound device.
Index: linux-2.6.22-rc3/sound/soc/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/soc/Kconfig
+++ linux-2.6.22-rc3/sound/soc/Kconfig
@@ -10,7 +10,6 @@ config SND_SOC_AC97_BUS
 
 config SND_SOC
 	tristate "ALSA for SoC audio support"
-	depends on SND
 	select SND_PCM
 	---help---
 
Index: linux-2.6.22-rc3/sound/sparc/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/sparc/Kconfig
+++ linux-2.6.22-rc3/sound/sparc/Kconfig
@@ -5,7 +5,7 @@ menu "ALSA Sparc devices"
 
 config SND_SUN_AMD7930
 	tristate "Sun AMD7930"
-	depends on SBUS && SND
+	depends on SBUS
 	select SND_PCM
 	help
 	  Say Y here to include support for AMD7930 sound device on Sun.
@@ -15,7 +15,6 @@ config SND_SUN_AMD7930
 
 config SND_SUN_CS4231
 	tristate "Sun CS4231"
-	depends on SND
 	select SND_PCM
 	help
 	  Say Y here to include support for CS4231 sound device on Sun.
@@ -25,7 +24,7 @@ config SND_SUN_CS4231
 
 config SND_SUN_DBRI
 	tristate "Sun DBRI"
-	depends on SND && SBUS
+	depends on SBUS
 	select SND_PCM
 	help
 	  Say Y here to include support for DBRI sound device on Sun.
Index: linux-2.6.22-rc3/sound/usb/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/usb/Kconfig
+++ linux-2.6.22-rc3/sound/usb/Kconfig
@@ -5,7 +5,7 @@ menu "USB devices"
 
 config SND_USB_AUDIO
 	tristate "USB Audio/MIDI driver"
-	depends on SND && USB
+	depends on USB
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_PCM
@@ -18,7 +18,7 @@ config SND_USB_AUDIO
 
 config SND_USB_USX2Y
 	tristate "Tascam US-122, US-224 and US-428 USB driver"
-	depends on SND && USB && (X86 || PPC || ALPHA)
+	depends on USB && (X86 || PPC || ALPHA)
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_PCM
@@ -31,7 +31,7 @@ config SND_USB_USX2Y
 
 config SND_USB_CAIAQ
 	tristate "Native Instruments USB audio devices"
-	 depends on SND && USB
+	 depends on USB
 	 select SND_HWDEP
 	 select SND_RAWMIDI
 	 select SND_PCM
