Return-Path: <linux-kernel-owner+w=401wt.eu-S1760337AbXEZKoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337AbXEZKoa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 06:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756908AbXEZKoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 06:44:07 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:35300 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760097AbXEZKoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 06:44:04 -0400
Date: Sat, 26 May 2007 12:41:27 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Takashi Iwai <tiwai@suse.de>, Uwe Bugla <uwe.bugla@gmx.de>,
       linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>
Subject: [PATCH 04/04] Use menuconfig objects 3 - sound/oss
In-Reply-To: <Pine.LNX.4.61.0705260947130.7344@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0705261241140.7344@yvahk01.tjqt.qr>
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
 sound/Kconfig     |   11 +++++------
 sound/oss/Kconfig |   39 +++++++++++++++++++--------------------
 2 files changed, 24 insertions(+), 26 deletions(-)

Index: linux-2.6.22-rc3/sound/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/Kconfig
+++ linux-2.6.22-rc3/sound/Kconfig
@@ -80,19 +80,18 @@ source "sound/soc/Kconfig"
 
 endif # SND
 
-menu "Open Sound System"
-	depends on SOUND!=n
-
-config SOUND_PRIME
+menuconfig SOUND_PRIME
 	tristate "Open Sound System (DEPRECATED)"
 	help
 	  Say 'Y' or 'M' to enable Open Sound System drivers.
 
+if SOUND_PRIME
+
 source "sound/oss/Kconfig"
 
-endmenu
+endif # SOUND_PRIME
 
-endif
+endif # !M68K
 
 config AC97_BUS
 	tristate
Index: linux-2.6.22-rc3/sound/oss/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/oss/Kconfig
+++ linux-2.6.22-rc3/sound/oss/Kconfig
@@ -7,7 +7,6 @@
 
 config OSS_OBSOLETE
 	bool "Obsolete OSS drivers"
-	depends on SOUND_PRIME
 	help
 	  This option enables support for obsolete OSS drivers that
 	  are scheduled for removal in the near future.
@@ -20,7 +19,7 @@ config OSS_OBSOLETE
 
 config SOUND_BT878
 	tristate "BT878 audio dma"
-	depends on SOUND_PRIME && PCI && OSS_OBSOLETE
+	depends on PCI && OSS_OBSOLETE
 	---help---
 	  Audio DMA support for bt878 based grabber boards.  As you might have
 	  already noticed, bt878 is listed with two functions in /proc/pci.
@@ -36,7 +35,7 @@ config SOUND_BT878
 
 config SOUND_BCM_CS4297A
 	tristate "Crystal Sound CS4297a (for Swarm)"
-	depends on SOUND_PRIME && SIBYTE_SWARM
+	depends on SIBYTE_SWARM
 	help
 	  The BCM91250A has a Crystal CS4297a on synchronous serial
 	  port B (in addition to the DB-9 serial port).  Say Y or M
@@ -46,14 +45,14 @@ config SOUND_BCM_CS4297A
 
 config SOUND_ICH
 	tristate "Intel ICH (i8xx) audio support"
-	depends on SOUND_PRIME && PCI && OSS_OBSOLETE
+	depends on PCI && OSS_OBSOLETE
 	help
 	  Support for integral audio in Intel's I/O Controller Hub (ICH)
 	  chipset, as used on the 810/820/840 motherboards.
 
 config SOUND_VWSND
 	tristate "SGI Visual Workstation Sound"
-	depends on SOUND_PRIME && X86_VISWS
+	depends on X86_VISWS
 	help
 	  Say Y or M if you have an SGI Visual Workstation and you want to be
 	  able to use its on-board audio.  Read
@@ -62,14 +61,14 @@ config SOUND_VWSND
 
 config SOUND_HAL2
 	tristate "SGI HAL2 sound (EXPERIMENTAL)"
-	depends on SOUND_PRIME && SGI_IP22 && EXPERIMENTAL
+	depends on SGI_IP22 && EXPERIMENTAL
 	help
 	  Say Y or M if you have an SGI Indy or Indigo2 system and want to be able to
 	  use its on-board A2 audio system.
 
 config SOUND_VRC5477
 	tristate "NEC Vrc5477 AC97 sound"
-	depends on SOUND_PRIME && DDB5477
+	depends on DDB5477
 	help
 	  Say Y here to enable sound support for the NEC Vrc5477 chip, an
 	  integrated, multi-function controller chip for MIPS CPUs.  Works
@@ -78,11 +77,11 @@ config SOUND_VRC5477
 config SOUND_AU1550_AC97
 	tristate "Au1550/Au1200 AC97 Sound"
 	select SND_AC97_CODEC
-	depends on SOUND_PRIME && (SOC_AU1550 || SOC_AU1200)
+	depends on SOC_AU1550 || SOC_AU1200
 
 config SOUND_TRIDENT
 	tristate "Trident 4DWave DX/NX, SiS 7018 or ALi 5451 PCI Audio Core"
-	depends on SOUND_PRIME && PCI
+	depends on PCI
 	---help---
 	  Say Y or M if you have a PCI sound card utilizing the Trident
 	  4DWave-DX/NX chipset or your mother board chipset has SiS 7018
@@ -123,7 +122,7 @@ config SOUND_TRIDENT
 
 config SOUND_MSNDCLAS
 	tristate "Support for Turtle Beach MultiSound Classic, Tahiti, Monterey"
-	depends on SOUND_PRIME && (m || !STANDALONE)
+	depends on m || !STANDALONE
 	help
 	  Say M here if you have a Turtle Beach MultiSound Classic, Tahiti or
 	  Monterey (not for the Pinnacle or Fiji).
@@ -134,7 +133,7 @@ config SOUND_MSNDCLAS
 	  at <http://www.turtlebeach.com/site/kb_ftp/790.asp>.
 
 comment "Compiled-in MSND Classic support requires firmware during compilation."
-	depends on SOUND_PRIME && SOUND_MSNDCLAS=y
+	depends on SOUND_MSNDCLAS=y
 
 config MSNDCLAS_HAVE_BOOT
 	bool
@@ -187,7 +186,7 @@ config MSNDCLAS_IO
 
 config SOUND_MSNDPIN
 	tristate "Support for Turtle Beach MultiSound Pinnacle, Fiji"
-	depends on SOUND_PRIME && (m || !STANDALONE)
+	depends on m || !STANDALONE
 	help
 	  Say M here if you have a Turtle Beach MultiSound Pinnacle or Fiji.
 	  See <file:Documentation/sound/oss/MultiSound> for important information
@@ -196,7 +195,7 @@ config SOUND_MSNDPIN
 	  at <http://www.turtlebeach.com/site/kb_ftp/600.asp>.
 
 comment "Compiled-in MSND Pinnacle support requires firmware during compilation."
-	depends on SOUND_PRIME && SOUND_MSNDPIN=y
+	depends on SOUND_MSNDPIN=y
 
 config MSNDPIN_HAVE_BOOT
 	bool
@@ -273,7 +272,7 @@ config MSNDPIN_NONPNP
 	  configure the card's resources.
 
 comment "MSND Pinnacle DSP section will be configured to above parameters."
-	depends on SOUND_PRIME && SOUND_MSNDPIN=y && MSNDPIN_NONPNP
+	depends on SOUND_MSNDPIN=y && MSNDPIN_NONPNP
 
 config MSNDPIN_CFG
 	hex "MSND Pinnacle config port 250,260,270"
@@ -286,7 +285,7 @@ config MSNDPIN_CFG
 	  Mode".
 
 comment "Pinnacle-specific Device Configuration (0 disables)"
-	depends on SOUND_PRIME && SOUND_MSNDPIN=y && MSNDPIN_NONPNP
+	depends on SOUND_MSNDPIN=y && MSNDPIN_NONPNP
 
 config MSNDPIN_MPU_IO
 	hex "MSND Pinnacle MPU I/O (e.g. 330)"
@@ -338,7 +337,7 @@ config MSNDPIN_JOYSTICK_IO
 
 config MSND_FIFOSIZE
 	int "MSND buffer size (kB)"
-	depends on SOUND_PRIME && (SOUND_MSNDPIN=y || SOUND_MSNDCLAS=y)
+	depends on SOUND_MSNDPIN=y || SOUND_MSNDCLAS=y
 	default "128"
 	help
 	  Configures the size of each audio buffer, in kilobytes, for
@@ -348,7 +347,7 @@ config MSND_FIFOSIZE
 
 config SOUND_VIA82CXXX
 	tristate "VIA 82C686 Audio Codec"
-	depends on SOUND_PRIME && PCI && OSS_OBSOLETE
+	depends on PCI && OSS_OBSOLETE
 	help
 	  Say Y here to include support for the audio codec found on VIA
 	  82Cxxx-based chips. Typically these are built into a motherboard.
@@ -368,7 +367,7 @@ config MIDI_VIA82CXXX
 
 config SOUND_OSS
 	tristate "OSS sound modules"
-	depends on SOUND_PRIME && ISA_DMA_API
+	depends on ISA_DMA_API
 	help
 	  OSS is the Open Sound System suite of sound card drivers.  They make
 	  sound programming easier since they provide a common API.  Say Y or
@@ -721,7 +720,7 @@ config SOUND_WAVEARTIST
 
 config SOUND_TVMIXER
 	tristate "TV card (bt848) mixer support"
-	depends on SOUND_PRIME && I2C && VIDEO_V4L1 && OSS_OBSOLETE
+	depends on I2C && VIDEO_V4L1 && OSS_OBSOLETE
 	help
 	  Support for audio mixer facilities on the BT848 TV frame-grabber
 	  card.
@@ -732,7 +731,7 @@ config SOUND_KAHLUA
 
 config SOUND_SH_DAC_AUDIO
 	tristate "SuperH DAC audio support"
-	depends on SOUND_PRIME && CPU_SH3
+	depends on CPU_SH3
 
 config SOUND_SH_DAC_AUDIO_CHANNEL
 	int "DAC channel"
