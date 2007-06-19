Return-Path: <linux-kernel-owner+w=401wt.eu-S934077AbXFSU00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077AbXFSU00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763668AbXFSU0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:26:17 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33664 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762536AbXFSU0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:26:16 -0400
Date: Tue, 19 Jun 2007 22:26:33 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.23 patch] remove options depending on OSS_OBSOLETE
Message-ID: <20070619202633.GE12950@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the scheduled removal of options depending
on OSS_OBSOLETE.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 sound/oss/Kconfig |   77 ----------------------------------------------
 1 file changed, 77 deletions(-)

--- linux-2.6.22-rc4-mm2/sound/oss/Kconfig.old	2007-06-18 14:57:48.000000000 +0200
+++ linux-2.6.22-rc4-mm2/sound/oss/Kconfig	2007-06-18 14:59:17.000000000 +0200
@@ -5,35 +5,6 @@
 #
 # Prompt user for primary drivers.
 
-config OSS_OBSOLETE
-	bool "Obsolete OSS drivers"
-	depends on SOUND_PRIME
-	help
-	  This option enables support for obsolete OSS drivers that
-	  are scheduled for removal in the near future.
-
-	  Please contact Adrian Bunk <bunk@stusta.de> if you had to
-	  say Y here because your hardware is not properly supported
-	  by ALSA.
-
-	  If unsure, say N.
-
-config SOUND_BT878
-	tristate "BT878 audio dma"
-	depends on SOUND_PRIME && PCI && OSS_OBSOLETE
-	---help---
-	  Audio DMA support for bt878 based grabber boards.  As you might have
-	  already noticed, bt878 is listed with two functions in /proc/pci.
-	  Function 0 does the video stuff (bt848 compatible), function 1 does
-	  the same for audio data.  This is a driver for the audio part of
-	  the chip.  If you say 'Y' here you get a oss-compatible dsp device
-	  where you can record from.  If you want just watch TV you probably
-	  don't need this driver as most TV cards handle sound with a short
-	  cable from the TV card to your sound card's line-in.
-
-	  To compile this driver as a module, choose M here: the module will
-	  be called btaudio.
-
 config SOUND_BCM_CS4297A
 	tristate "Crystal Sound CS4297a (for Swarm)"
 	depends on SOUND_PRIME && SIBYTE_SWARM
@@ -44,13 +15,6 @@
 	  note that CONFIG_KGDB should not be enabled at the same
 	  time, since it also attempts to use this UART port.
 
-config SOUND_ICH
-	tristate "Intel ICH (i8xx) audio support"
-	depends on SOUND_PRIME && PCI && OSS_OBSOLETE
-	help
-	  Support for integral audio in Intel's I/O Controller Hub (ICH)
-	  chipset, as used on the 810/820/840 motherboards.
-
 config SOUND_VWSND
 	tristate "SGI Visual Workstation Sound"
 	depends on SOUND_PRIME && X86_VISWS
@@ -346,26 +310,6 @@
 	  and Pinnacle). Larger values reduce the chance of data overruns at
 	  the expense of overall latency. If unsure, use the default.
 
-config SOUND_VIA82CXXX
-	tristate "VIA 82C686 Audio Codec"
-	depends on SOUND_PRIME && PCI && OSS_OBSOLETE && VIRT_TO_BUS
-	help
-	  Say Y here to include support for the audio codec found on VIA
-	  82Cxxx-based chips. Typically these are built into a motherboard.
-
-	  DO NOT select Sound Blaster or Adlib with this driver, unless
-	  you have a Sound Blaster or Adlib card in addition to your VIA
-	  audio chip.
-
-config MIDI_VIA82CXXX
-	bool "VIA 82C686 MIDI"
-	depends on SOUND_VIA82CXXX && ISA_DMA_API
-	help
-	  Answer Y to use the MIDI interface of the Via686. You may need to
-	  enable this in the BIOS before it will work. This is for connection
-	  to external MIDI hardware, and is not required for software playback
-	  of MIDI files.
-
 config SOUND_OSS
 	tristate "OSS sound modules"
 	depends on SOUND_PRIME && ISA_DMA_API && VIRT_TO_BUS
@@ -400,20 +344,6 @@
 
 	  Say Y unless you have 16MB or more RAM or a PCI sound card.
 
-config SOUND_CS4232
-	tristate "Crystal CS4232 based (PnP) cards"
-	depends on SOUND_OSS && OSS_OBSOLETE
-	help
-	  Say Y here if you have a card based on the Crystal CS4232 chip set,
-	  which uses its own Plug and Play protocol.
-
-	  If you compile the driver into the kernel, you have to add
-	  "cs4232=<io>,<irq>,<dma>,<dma2>,<mpuio>,<mpuirq>" to the kernel
-	  command line.
-
-	  See <file:Documentation/sound/oss/CS4232> for more information on
-	  configuring this card.
-
 config SOUND_SSCAPE
 	tristate "Ensoniq SoundScape support"
 	depends on SOUND_OSS
@@ -720,13 +650,6 @@
 	  Say Y here to include support for the Rockwell WaveArtist sound
 	  system.  This driver is mainly for the NetWinder.
 
-config SOUND_TVMIXER
-	tristate "TV card (bt848) mixer support"
-	depends on SOUND_PRIME && I2C && VIDEO_V4L1 && OSS_OBSOLETE
-	help
-	  Support for audio mixer facilities on the BT848 TV frame-grabber
-	  card.
-
 config SOUND_KAHLUA
 	tristate "XpressAudio Sound Blaster emulation"
 	depends on SOUND_SB

