Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458Ab0AZXs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0AZXs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285Ab0AZXsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:48:50 -0500
Received: from kroah.org ([198.145.64.141]:35479 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895Ab0AZXoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:31 2010
Message-Id: <20100126233931.230243413@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [79/98] ALSA: hda - Fix HP T5735 automute
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit dc99be47667c56046555e89e62f1ac17fa06329a upstream.

This patch fixes the aut-mute setup on HP T5735 with ALC262 codec.
Instead of wrong amp, use pin control toggling for muting the speaker now.

Tested-by: Lee Trager <lee.trager@hp.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10154,7 +10154,7 @@ static void alc262_hp_t5735_setup(struct
 	struct alc_spec *spec = codec->spec;
 
 	spec->autocfg.hp_pins[0] = 0x15;
-	spec->autocfg.speaker_pins[0] = 0x0c; /* HACK: not actually a pin */
+	spec->autocfg.speaker_pins[0] = 0x14;
 }
 
 static struct snd_kcontrol_new alc262_hp_t5735_mixer[] = {
@@ -11588,9 +11588,9 @@ static struct alc_config_preset alc262_p
 		.num_channel_mode = ARRAY_SIZE(alc262_modes),
 		.channel_mode = alc262_modes,
 		.input_mux = &alc262_capture_source,
-		.unsol_event = alc_automute_amp_unsol_event,
+		.unsol_event = alc_sku_unsol_event,
 		.setup = alc262_hp_t5735_setup,
-		.init_hook = alc_automute_amp,
+		.init_hook = alc_inithook,
 	},
 	[ALC262_HP_RP5700] = {
 		.mixers = { alc262_hp_rp5700_mixer },


