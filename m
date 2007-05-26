Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbXEZKnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbXEZKnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 06:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbXEZKnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 06:43:08 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:34661 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbXEZKnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 06:43:04 -0400
Date: Sat, 26 May 2007 12:40:27 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Takashi Iwai <tiwai@suse.de>, Uwe Bugla <uwe.bugla@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>
Subject: [PATCH 01/04] Use menuconfig objects 3 - sound
In-Reply-To: <Pine.LNX.4.61.0705260947130.7344@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0705261239491.7344@yvahk01.tjqt.qr>
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
 sound/Kconfig              |   12 +++++-------
 sound/aoa/soundbus/Kconfig |    1 -
 sound/oss/dmasound/Kconfig |    6 +++---
 3 files changed, 8 insertions(+), 11 deletions(-)

Index: linux-2.6.22-rc3/sound/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/Kconfig
+++ linux-2.6.22-rc3/sound/Kconfig
@@ -1,11 +1,9 @@
 # sound/Config.in
 #
 
-menu "Sound"
-	depends on HAS_IOMEM
-
-config SOUND
+menuconfig SOUND
 	tristate "Sound card support"
+	depends on HAS_IOMEM
 	help
 	  If you have a sound card in your computer, i.e. if it can say more
 	  than an occasional beep, say Y.  Be sure to have all the information
@@ -33,6 +31,8 @@ config SOUND
 	  Kernel patches and supporting utilities to do that are in the pcsp
 	  package, available at <ftp://ftp.infradead.org/pub/pcsp/>.
 
+if SOUND
+
 source "sound/oss/dmasound/Kconfig"
 
 if !M68K
@@ -42,7 +42,6 @@ menu "Advanced Linux Sound Architecture"
 
 config SND
 	tristate "Advanced Linux Sound Architecture"
-	depends on SOUND
 	help
 	  Say 'Y' or 'M' to enable ALSA (Advanced Linux Sound Architecture),
 	  the new base sound system.
@@ -86,7 +85,6 @@ menu "Open Sound System"
 
 config SOUND_PRIME
 	tristate "Open Sound System (DEPRECATED)"
-	depends on SOUND
 	help
 	  Say 'Y' or 'M' to enable Open Sound System drivers.
 
@@ -104,4 +102,4 @@ config AC97_BUS
 	  sound although they're sharing the AC97 bus. Concerned drivers
 	  should "select" this.
 
-endmenu
+endif # SOUND
Index: linux-2.6.22-rc3/sound/aoa/soundbus/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/aoa/soundbus/Kconfig
+++ linux-2.6.22-rc3/sound/aoa/soundbus/Kconfig
@@ -1,6 +1,5 @@
 config SND_AOA_SOUNDBUS
 	tristate "Apple Soundbus support"
-	depends on SOUND
 	select SND_PCM
 	---help---
 	This option enables the generic driver for the soundbus
Index: linux-2.6.22-rc3/sound/oss/dmasound/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/sound/oss/dmasound/Kconfig
+++ linux-2.6.22-rc3/sound/oss/dmasound/Kconfig
@@ -1,6 +1,6 @@
 config DMASOUND_ATARI
 	tristate "Atari DMA sound support"
-	depends on ATARI && SOUND
+	depends on ATARI
 	select DMASOUND
 	help
 	  If you want to use the internal audio of your Atari in Linux, answer
@@ -14,7 +14,7 @@ config DMASOUND_ATARI
 
 config DMASOUND_PAULA
 	tristate "Amiga DMA sound support"
-	depends on (AMIGA || APUS) && SOUND
+	depends on AMIGA || APUS
 	select DMASOUND
 	help
 	  If you want to use the internal audio of your Amiga in Linux, answer
@@ -28,7 +28,7 @@ config DMASOUND_PAULA
 
 config DMASOUND_Q40
 	tristate "Q40 sound support"
-	depends on Q40 && SOUND
+	depends on Q40
 	select DMASOUND
 	help
 	  If you want to use the internal audio of your Q40 in Linux, answer
