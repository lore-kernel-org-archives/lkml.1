Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbXFOVqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbXFOVqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbXFOVpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:45:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36343 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758052AbXFOVpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:45:18 -0400
Date: Fri, 15 Jun 2007 23:45:31 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Kailang Yang <kailang@realtek.com.tw>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] sound/pci/hda/patch_realtek.c: remove dead code
Message-ID: <20070615214531.GO3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dead code spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 sound/pci/hda/patch_realtek.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- linux-2.6.22-rc4-mm2/sound/pci/hda/patch_realtek.c.old	2007-06-15 21:48:12.000000000 +0200
+++ linux-2.6.22-rc4-mm2/sound/pci/hda/patch_realtek.c	2007-06-15 23:12:40.000000000 +0200
@@ -10704,30 +10704,31 @@ static struct hda_verb alc662_init_verbs
 	/* Mixer elements: 0x18, 19, 1a, 1b, 1c, 1d, 14, 15, 16, 17, 0b */
 	/* Input mixer */
 	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
 	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
 	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(2)},
 	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(4)},
 	{ }
 };
 
 static struct hda_verb alc662_sue_init_verbs[] = {
 	{0x14, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN|ALC880_FRONT_EVENT},
 	{0x1b, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN|ALC880_HP_EVENT},
         {}
 };
 
+#if 0
 /*
  * generic initialization of ADC, input mixers and output mixers
  */
 static struct hda_verb alc662_auto_init_verbs[] = {
 	/*
 	 * Unmute ADC and set the default input to mic-in
 	 */
 	{0x09, AC_VERB_SET_CONNECT_SEL, 0x00},
 	{0x09, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
 
 	/* Unmute input amps (CD, Line In, Mic 1 & Mic 2) of the analog-loopback
 	 * mixer widget
 	 * Note: PASD motherboards uses the Line In 2 as the input for front
 	 * panel mic (mic 2)
 	 */
@@ -10755,30 +10756,31 @@ static struct hda_verb alc662_auto_init_
 	{0x04, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
 	{0x04, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
 
 
 	/* FIXME: use matrix-type input source selection */
 	/* Mixer elements: 0x18, 19, 1a, 1b, 1c, 1d, 14, 15, 16, 17, 0b */
 	/* Input mixer */
 	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
 	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
 	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(2)},
 	/*{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(3)},*/
 	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(4)},
 
 	{ }
 };
+#endif  /*  0  */
 
 /* capture mixer elements */
 static struct snd_kcontrol_new alc662_capture_mixer[] = {
 	HDA_CODEC_VOLUME("Capture Volume", 0x09, 0x0, HDA_INPUT),
 	HDA_CODEC_MUTE("Capture Switch", 0x09, 0x0, HDA_INPUT),
 	{
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 		/* The multiple "Capture Source" controls confuse alsamixer
 		 * So call somewhat different..
 		 * FIXME: the controls appear in the "playback" view!
 		 */
 		/* .name = "Capture Source", */
 		.name = "Input Source",
 		.count = 1,
 		.info = alc882_mux_enum_info,
@@ -11152,35 +11154,30 @@ static int alc662_parse_auto_config(stru
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
-	else if (err > 0)
-		/* hack - override the init verbs */
-		spec->init_verbs[0] = alc662_auto_init_verbs;
 	spec->mixers[spec->num_mixers] = alc662_capture_mixer;
 	spec->num_mixers++;
 	return err;
 }
 
 /* additional initialization for auto-configuration model */
 static void alc662_auto_init(struct hda_codec *codec)
 {
 	alc662_auto_init_multi_out(codec);
 	alc662_auto_init_hp_out(codec);
 	alc662_auto_init_analog_input(codec);
 }
 
 static int patch_alc662(struct hda_codec *codec)
 {

