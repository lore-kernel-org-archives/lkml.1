Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbXGIW4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbXGIW4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbXGIWz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:55:56 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56134 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754535AbXGIWzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:55:55 -0400
Date: Tue, 10 Jul 2007 00:56:26 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Ash Willis <ashwillis@programmer.net>, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] fix SND_CS5530=y, ISA=n compilation
Message-ID: <20070709225626.GL3492@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm2:
>...
>  git-alsa.patch
>...
>  git trees
>...


This patch fixes the following compile error with
CONFIG_SND_CS5530=y, CONFIG_ISA=n:

<--  snip  -->

...
  LD      .tmp_vmlinux1
sound/built-in.o: In function `snd_sb16_capture_trigger':
sb16_main.c:(.text+0x212ad): undefined reference to `snd_sbdsp_command'
sb16_main.c:(.text+0x212cc): undefined reference to `snd_sbdsp_command'
sb16_main.c:(.text+0x212f7): undefined reference to `snd_sbdsp_command'
sound/built-in.o: In function `snd_sb16_playback_trigger':
sb16_main.c:(.text+0x2136d): undefined reference to `snd_sbdsp_command'
sb16_main.c:(.text+0x2138c): undefined reference to `snd_sbdsp_command'
sound/built-in.o:sb16_main.c:(.text+0x213b7): more undefined references to `snd_sbdsp_command' follow
sound/built-in.o: In function `snd_sb16dsp_configure':
(.text+0x21c40): undefined reference to `snd_sbmixer_read'
sound/built-in.o: In function `snd_sb16dsp_configure':
(.text+0x21ccd): undefined reference to `snd_sbmixer_write'
sound/built-in.o: In function `snd_sb16dsp_configure':
(.text+0x21cd9): undefined reference to `snd_sbmixer_read'
sound/built-in.o: In function `snd_sb16dsp_configure':
(.text+0x21cf3): undefined reference to `snd_sbmixer_write'
sound/built-in.o: In function `snd_sb16dsp_configure':
(.text+0x21cff): undefined reference to `snd_sbmixer_read'
sound/built-in.o: In function `snd_sb16dsp_configure':
(.text+0x21d17): undefined reference to `snd_sbmixer_write'
sound/built-in.o: In function `snd_sb16dsp_configure':
(.text+0x21d23): undefined reference to `snd_sbmixer_read'
sound/built-in.o: In function `snd_sb16dsp_interrupt':
(.text+0x21e90): undefined reference to `snd_sbmixer_read'
sound/built-in.o: In function `snd_sb16dsp_interrupt':
(.text+0x21f49): undefined reference to `snd_sbdsp_command'
sound/built-in.o: In function `snd_sb16dsp_interrupt':
(.text+0x21f80): undefined reference to `snd_sbdsp_command'
sound/built-in.o: In function `snd_sb16_playback_prepare':
sb16_main.c:(.text+0x220a5): undefined reference to `snd_sbdsp_command'
sb16_main.c:(.text+0x220af): undefined reference to `snd_sbdsp_command'
sb16_main.c:(.text+0x220bc): undefined reference to `snd_sbdsp_command'
sound/built-in.o:sb16_main.c:(.text+0x220c5): more undefined references to `snd_sbdsp_command' follow
sound/built-in.o: In function `snd_cs5530_probe':
cs5530.c:(.text+0x2245a): undefined reference to `snd_sbdsp_create'
cs5530.c:(.text+0x2248c): undefined reference to `snd_sbmixer_new'
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 sound/isa/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.22-rc6-mm1/sound/isa/Kconfig.old	2007-07-10 00:43:59.000000000 +0200
+++ linux-2.6.22-rc6-mm1/sound/isa/Kconfig	2007-07-10 00:44:19.000000000 +0200
@@ -1,37 +1,37 @@
 # ALSA ISA drivers
 
-menu "ISA devices"
-	depends on SND!=n && ISA && ISA_DMA_API
-
 config SND_AD1848_LIB
         tristate
         select SND_PCM
 
 config SND_CS4231_LIB
         tristate
         select SND_PCM
 
 config SND_SB_COMMON
         tristate
 
 config SND_SB8_DSP
         tristate
         select SND_PCM
         select SND_SB_COMMON
 
 config SND_SB16_DSP
         tristate
         select SND_PCM
         select SND_SB_COMMON
 
+menu "ISA devices"
+	depends on SND!=n && ISA && ISA_DMA_API
+
 config SND_ADLIB
 	tristate "AdLib FM card"
 	depends on SND
 	select SND_OPL3_LIB
 	help
 	  Say Y here to include support for AdLib FM cards.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-adlib.
 
 config SND_AD1816A

