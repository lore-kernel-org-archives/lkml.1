Return-Path: <linux-kernel-owner+w=401wt.eu-S965141AbZLGXHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965141AbZLGXHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 18:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965089AbZLGXHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 18:07:47 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:52948 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935734AbZLGXHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 18:07:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bEAEUVpDHEaUHDIXUQIjMqE3958DCHq7EyZ30Br2VZ01y7TAHLw/Nk9jfJhGYVZJkU
         L/75CeCxMd4eB710vISdJj2qD575cCsUVMNbXXCsGuC10iy3dOmExkypj6mgA6UuQNGn
         DH0AXpVta9Ug1VoWnLP1ZLhbVOBI9ex5auY/E=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] [Updated] iMac 9,1 sound patch.
Date: Mon,  7 Dec 2009 15:07:46 -0800
Message-Id: <1260227266-6206-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.5
In-Reply-To: <1260227266-6206-1-git-send-email-justinmattock@gmail.com>
References: <1260227266-6206-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
tested-by:     Justin P. Mattock <justinmattock@gmail.com>
---
 Documentation/sound/alsa/HD-Audio-Models.txt |    1 +
 sound/pci/hda/patch_realtek.c                |  111 ++++++++++++++++++++++++++
 2 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/Documentation/sound/alsa/HD-Audio-Models.txt b/Documentation/sound/alsa/HD-Audio-Models.txt
index 4c7f9ae..633406e 100644
--- a/Documentation/sound/alsa/HD-Audio-Models.txt
+++ b/Documentation/sound/alsa/HD-Audio-Models.txt
@@ -126,6 +126,7 @@ ALC882/883/885/888/889
   mb5		Macbook 5,1
   mbp3		Macbook Pro rev3
   imac24	iMac 24'' with jack detection
+  imac91	iMac 9,1
   w2jc		ASUS W2JC
   3stack-2ch-dig	3-jack with SPDIF I/O (ALC883)
   alc883-6stack-dig	6-jack digital with SPDIF I/O (ALC883)
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7058371..adcbafe 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -208,6 +208,7 @@ enum {
 	ALC885_MBP3,
 	ALC885_MB5,
 	ALC885_IMAC24,
+	ALC885_IMAC91,
 	ALC883_3ST_2ch_DIG,
 	ALC883_3ST_6ch_DIG,
 	ALC883_3ST_6ch,
@@ -7051,6 +7052,20 @@ static struct snd_kcontrol_new alc885_mb5_mixer[] = {
 	{ } /* end */
 };
 
+static struct snd_kcontrol_new alc885_imac91_mixer[] = {
+	HDA_CODEC_VOLUME("Line-Out Playback Volume", 0x0c, 0x00, HDA_OUTPUT),
+	HDA_BIND_MUTE   ("Line-Out Playback Switch", 0x0c, 0x02, HDA_INPUT),
+	HDA_CODEC_MUTE  ("Speaker Playback Switch", 0x14, 0x00, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("Speaker Playback Volume", 0x0d, 0x00, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("Line Playback Volume", 0x0b, 0x02, HDA_INPUT),
+	HDA_CODEC_MUTE  ("Line Playback Switch", 0x0b, 0x02, HDA_INPUT),
+	HDA_CODEC_VOLUME("Mic Playback Volume", 0x0b, 0x00, HDA_INPUT),
+	HDA_CODEC_MUTE  ("Mic Playback Switch", 0x0b, 0x00, HDA_INPUT),
+	HDA_CODEC_VOLUME("Mic Boost", 0x18, 0x00, HDA_INPUT),
+	{ } /* end */
+};
+
+
 static struct snd_kcontrol_new alc882_w2jc_mixer[] = {
 	HDA_CODEC_VOLUME("Front Playback Volume", 0x0c, 0x0, HDA_OUTPUT),
 	HDA_BIND_MUTE("Front Playback Switch", 0x0c, 2, HDA_INPUT),
@@ -7506,6 +7521,66 @@ static struct hda_verb alc885_mbp3_init_verbs[] = {
 	{ }
 };
 
+/* iMac 9,1 */
+static struct hda_verb alc885_imac91_init_verbs[] = {
+	/* Line-Out mixer: unmute input/output amp left and right (volume = 0) */
+	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_ZERO},
+	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
+	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(1)},
+	/* Rear mixer */
+	{0x0d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_ZERO},
+	{0x0d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
+	{0x0d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(1)},
+	/* HP Pin: output 0 (0x0c) */
+	{0x14, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_HP},
+	{0x14, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
+	{0x14, AC_VERB_SET_CONNECT_SEL, 0x00},
+	{0x14, AC_VERB_SET_UNSOLICITED_ENABLE, ALC880_HP_EVENT | AC_USRSP_EN},
+	/* Internal Speakers: output 0 (0x0d) */
+	{0x15, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT},
+	{0x15, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
+	{0x15, AC_VERB_SET_CONNECT_SEL, 0x00},
+	/* Mic (rear) pin: input vref at 80% */
+	{0x18, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_VREF80},
+	{0x18, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
+	/* Front Mic pin: input vref at 80% */
+	{0x19, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_VREF80},
+	{0x19, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
+	/* Line In pin: use output 1 when in LineOut mode */
+	{0x1a, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_IN},
+	{0x1a, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
+	{0x1a, AC_VERB_SET_CONNECT_SEL, 0x01},
+
+	/* FIXME: use matrix-type input source selection */
+	/* Mixer elements: 0x18, 19, 1a, 1b, 1c, 1d, 14, 15, 16, 17, 0b */
+	/* Input mixer1: unmute Mic, F-Mic, Line, CD inputs */
+	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(3)},
+	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(2)},
+	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(4)},
+	/* Input mixer2 */
+	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(3)},
+	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(2)},
+	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(4)},
+	/* Input mixer3 */
+	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(3)},
+	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(2)},
+	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(4)},
+	/* ADC1: mute amp left and right */
+	{0x07, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
+	{0x07, AC_VERB_SET_CONNECT_SEL, 0x00},
+	/* ADC2: mute amp left and right */
+	{0x08, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
+	{0x08, AC_VERB_SET_CONNECT_SEL, 0x00},
+	/* ADC3: mute amp left and right */
+	{0x09, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
+	{0x09, AC_VERB_SET_CONNECT_SEL, 0x00},
+
+	{ }
+};
+
 /* iMac 24 mixer. */
 static struct snd_kcontrol_new alc885_imac24_mixer[] = {
 	HDA_CODEC_VOLUME("Master Playback Volume", 0x0c, 0x00, HDA_OUTPUT),
@@ -7552,6 +7627,26 @@ static void alc885_mbp3_setup(struct hda_codec *codec)
 	spec->autocfg.speaker_pins[0] = 0x14;
 }
 
+static void alc885_imac91_automute(struct hda_codec *codec)
+{
+ 	unsigned int present;
+
+	present = snd_hda_codec_read(codec, 0x14, 0,
+				     AC_VERB_GET_PIN_SENSE, 0) & 0x80000000;
+	snd_hda_codec_amp_stereo(codec, 0x15, HDA_OUTPUT, 0,
+				 HDA_AMP_MUTE, present ? HDA_AMP_MUTE : 0);
+	snd_hda_codec_amp_stereo(codec, 0x1a, HDA_OUTPUT, 0,
+				 HDA_AMP_MUTE, present ? HDA_AMP_MUTE : 0);
+
+}
+
+static void alc885_imac91_unsol_event(struct hda_codec *codec,
+				    unsigned int res)
+{
+	/* Headphone insertion or removal. */
+	if ((res >> 26) == ALC880_HP_EVENT)
+		alc885_imac91_automute(codec);
+}
 
 static struct hda_verb alc882_targa_verbs[] = {
 	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
@@ -8737,6 +8832,7 @@ static const char *alc882_models[ALC882_MODEL_LAST] = {
 	[ALC885_MB5]		= "mb5",
 	[ALC885_MBP3]		= "mbp3",
 	[ALC885_IMAC24]		= "imac24",
+	[ALC885_IMAC91]		= "imac91",
 	[ALC883_3ST_2ch_DIG]	= "3stack-2ch-dig",
 	[ALC883_3ST_6ch_DIG]	= "3stack-6ch-dig",
 	[ALC883_3ST_6ch]	= "3stack-6ch",
@@ -8910,6 +9006,7 @@ static struct snd_pci_quirk alc882_ssid_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x106b, 0x3600, "Macbook 3,1", ALC889A_MB31),
 	SND_PCI_QUIRK(0x106b, 0x3800, "MacbookPro 4,1", ALC885_MBP3),
 	SND_PCI_QUIRK(0x106b, 0x3e00, "iMac 24 Aluminum", ALC885_IMAC24),
+	SND_PCI_QUIRK(0x106b, 0x4900, "iMac 9,1 Aluminum", ALC885_IMAC91),
 	SND_PCI_QUIRK(0x106b, 0x3f00, "Macbook 5,1", ALC885_MB5),
 	/* FIXME: HP jack sense seems not working for MBP 5,1 or 5,2,
 	 * so apparently no perfect solution yet
@@ -9021,6 +9118,20 @@ static struct alc_config_preset alc882_presets[] = {
 		.setup = alc885_imac24_setup,
 		.init_hook = alc885_imac24_init_hook,
 	},
+	[ALC885_IMAC91] = {
+		.mixers = { alc885_imac91_mixer, alc882_chmode_mixer },
+		.init_verbs = { alc885_imac91_init_verbs,
+				alc880_gpio1_init_verbs },
+		.num_dacs = ARRAY_SIZE(alc882_dac_nids),
+		.dac_nids = alc882_dac_nids,
+		.channel_mode = alc885_mbp_4ch_modes,
+		.num_channel_mode = ARRAY_SIZE(alc885_mbp_4ch_modes),
+		.input_mux = &alc882_capture_source,
+		.dig_out_nid = ALC882_DIGOUT_NID,
+		.dig_in_nid = ALC882_DIGIN_NID,
+		.unsol_event = alc885_imac91_unsol_event,
+		.init_hook = alc885_imac91_automute,
+	},
 	[ALC882_TARGA] = {
 		.mixers = { alc882_targa_mixer, alc882_chmode_mixer },
 		.init_verbs = { alc882_base_init_verbs, alc882_adc1_init_verbs,
-- 
1.6.5.5

