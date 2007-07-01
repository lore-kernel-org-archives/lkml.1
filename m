Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbXGAUWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbXGAUWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758483AbXGAUUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:20:53 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:46832 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758734AbXGAUUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:20:52 -0400
Date: Sun, 1 Jul 2007 22:21:18 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Kailang Yang <kailang@realtek.com.tw>, Jaroslav Kysela <perex@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] sound/pci/hda/patch_realtek.c: remove dead code
Message-ID: <20070701202118.GI10869@stusta.de>
References: <20070615214531.GO3588@stusta.de> <s5hejk8i6tn.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <s5hejk8i6tn.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 12:20:36PM +0200, Takashi Iwai wrote:
> At Fri, 15 Jun 2007 23:45:31 +0200,
> Adrian Bunk wrote:
> > 
> > This patch removes dead code spotted by the Coverity checker.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> This appears to be a copy-and-paste error from other
> auto-configuration code.  I fixed it on ALSA tree now so that it'll be
> merged to the next mm...

Thanks.

The patch below removes the remaining and really dead code.

> thanks,
> 
> Takashi

cu
Adrian


<--  snip  -->


This patch removes some dead code spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 sound/pci/hda/patch_realtek.c |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.22-rc6-mm1/sound/pci/hda/patch_realtek.c.old	2007-06-29 22:47:35.000000000 +0200
+++ linux-2.6.22-rc6-mm1/sound/pci/hda/patch_realtek.c	2007-06-29 23:45:48.000000000 +0200
@@ -11170,32 +11170,30 @@ static int alc662_parse_auto_config(stru
 	err = alc662_auto_create_analog_input_ctls(spec, &spec->autocfg);
 	if (err < 0)
 		return err;
 
 	spec->multiout.max_channels = spec->multiout.num_dacs * 2;
 
 	if (spec->autocfg.dig_out_pin)
 		spec->multiout.dig_out_nid = ALC880_DIGOUT_NID;
 
 	if (spec->kctl_alloc)
 		spec->mixers[spec->num_mixers++] = spec->kctl_alloc;
 
 	spec->num_mux_defs = 1;
 	spec->input_mux = &spec->private_imux;
 	
-	if (err < 0)
-		return err;
 	spec->init_verbs[spec->num_init_verbs++] = alc662_auto_init_verbs;
 	spec->mixers[spec->num_mixers] = alc662_capture_mixer;
 	spec->num_mixers++;
 	return 1;
 }
 
 /* additional initialization for auto-configuration model */
 static void alc662_auto_init(struct hda_codec *codec)
 {
 	alc662_auto_init_multi_out(codec);
 	alc662_auto_init_hp_out(codec);
 	alc662_auto_init_analog_input(codec);
 }
 
 static int patch_alc662(struct hda_codec *codec)

