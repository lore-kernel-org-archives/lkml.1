Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbXHBNMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbXHBNMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXHBNMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:12:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:6583 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbXHBNMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=hTnSHqGhuTJcm+0bmZ/PFkheSC764DoT4OgQCp2rB/HyKqE13914DD77VMWf84UVIY0vZxbsbgzFkJ842S2IC0xk7KZ2EA5rV12BgfBVRDzjHsLkFXZHvC3DnOG2OfKkog+RI3Ab51XkueYp49/Yu17HkEjBZzI7I81NCBcxoBI=
Message-ID: <46B1D81F.4080802@googlemail.com>
Date: Thu, 02 Aug 2007 15:11:59 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, tiwai@suse.de,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH -mm] Fix section mismatch warnings in sound/pci/hda/
References: <20070731230932.a9459617.akpm@linux-foundation.org>
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch warnings for sound/pci/hda/*

...

WARNING: vmlinux.o(.text+0x28d5f7): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'alc_build_controls' and 'alc662_auto_set_output_and_unmute')
WARNING: vmlinux.o(.text+0x28d621): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'alc_build_controls' and 'alc662_auto_set_output_and_unmute')
WARNING: vmlinux.o(.text+0x28d63d): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'alc_build_controls' and 'alc662_auto_set_output_and_unmute')
WARNING: vmlinux.o(.text+0x2904ca): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'alc880_parse_auto_config' and 'alc882_gpio_mute')
WARNING: vmlinux.o(.text+0x290e5e): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc268' and 'patch_alc662')
WARNING: vmlinux.o(.text+0x290e7c): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc268' and 'patch_alc662')
WARNING: vmlinux.o(.text+0x291248): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc662' and 'alc_mux_enum_info')
WARNING: vmlinux.o(.text+0x291315): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc662' and 'alc_mux_enum_info')
WARNING: vmlinux.o(.text+0x2919ca): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc880' and 'patch_alc260')
WARNING: vmlinux.o(.text+0x291b96): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc260' and 'patch_alc882')
WARNING: vmlinux.o(.text+0x291c2c): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc260' and 'patch_alc882')
WARNING: vmlinux.o(.text+0x292010): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc882' and 'patch_alc883')
WARNING: vmlinux.o(.text+0x2922da): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc883' and 'patch_alc262')
WARNING: vmlinux.o(.text+0x29244a): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc262' and 'patch_alc861')
WARNING: vmlinux.o(.text+0x292517): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc262' and 'patch_alc861')
WARNING: vmlinux.o(.text+0x292806): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc861' and 'patch_alc861vd')
WARNING: vmlinux.o(.text+0x29289c): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc861' and 'patch_alc861vd')
WARNING: vmlinux.o(.text+0x292c26): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc861vd' and 'cmi9880_build_pcms')
WARNING: vmlinux.o(.text+0x292cf5): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc861vd' and 'cmi9880_build_pcms')
WARNING: vmlinux.o(.text+0x2932dd): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'cmi9880_build_controls' and 'cmi_ch_mode_put')
WARNING: vmlinux.o(.text+0x2932f6): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'cmi9880_build_controls' and 'cmi_ch_mode_put')
WARNING: vmlinux.o(.text+0x293326): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'cmi9880_build_controls' and 'cmi_ch_mode_put')
WARNING: vmlinux.o(.text+0x293346): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'cmi9880_build_controls' and 'cmi_ch_mode_put')
WARNING: vmlinux.o(.text+0x29349e): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_cmi9880' and 'cmi_mux_enum_get')
WARNING: vmlinux.o(.text+0x293614): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_cmi9880' and 'cmi_mux_enum_get')
WARNING: vmlinux.o(.text+0x293e41): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'ad198x_build_controls' and 'ad1988_laptop_unsol_event')
WARNING: vmlinux.o(.text+0x293e6b): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'ad198x_build_controls' and 'ad1988_laptop_unsol_event')
WARNING: vmlinux.o(.text+0x293e87): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'ad198x_build_controls' and 'ad1988_laptop_unsol_event')
WARNING: vmlinux.o(.text+0x294cdb): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1882' and 'patch_ad1884')
WARNING: vmlinux.o(.text+0x294e4d): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1984' and 'ad198x_mux_enum_get')
WARNING: vmlinux.o(.text+0x294f96): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1986a' and 'patch_ad1983')
WARNING: vmlinux.o(.text+0x295226): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1981' and 'patch_ad1988')
WARNING: vmlinux.o(.text+0x295355): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1988' and 'stac92xx_dmux_enum_get')
WARNING: vmlinux.o(.text+0x29553c): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_ad1988' and 'stac92xx_dmux_enum_get')
WARNING: vmlinux.o(.text+0x29680c): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'stac92xx_build_controls' and 'stac92xx_mux_enum_put')
WARNING: vmlinux.o(.text+0x296835): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'stac92xx_build_controls' and 'stac92xx_mux_enum_put')
WARNING: vmlinux.o(.text+0x29685f): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'stac92xx_build_controls' and 'stac92xx_mux_enum_put')
WARNING: vmlinux.o(.text+0x29687b): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'stac92xx_build_controls' and 'stac92xx_mux_enum_put')
WARNING: vmlinux.o(.text+0x296e0f): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'stac92xx_parse_auto_config' and 'patch_stac9872')
WARNING: vmlinux.o(.text+0x2975b9): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac9872' and 'vaio_master_sw_put')
WARNING: vmlinux.o(.text+0x29791c): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac9200' and 'patch_stac925x')
WARNING: vmlinux.o(.text+0x297991): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_stac9200' and 'patch_stac925x')
WARNING: vmlinux.o(.text+0x297cfb): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac925x' and 'patch_stac922x')
WARNING: vmlinux.o(.text+0x297e6c): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac922x' and 'patch_stac927x')
WARNING: vmlinux.o(.text+0x29809f): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac927x' and 'patch_stac9205')
WARNING: vmlinux.o(.text+0x29822f): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac9205' and 'si3054_build_pcms')
WARNING: vmlinux.o(.text+0x298846): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'si3054_build_controls' and 'patch_si3054')
WARNING: vmlinux.o(.text+0x298978): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'atihdmi_build_controls' and 'patch_atihdmi')
WARNING: vmlinux.o(.text+0x299361): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'conexant_build_controls' and 'patch_cxt5047')
WARNING: vmlinux.o(.text+0x29938b): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'conexant_build_controls' and 'patch_cxt5047')
WARNING: vmlinux.o(.text+0x2993a7): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'conexant_build_controls' and 'patch_cxt5047')
WARNING: vmlinux.o(.text+0x2994a9): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_cxt5047' and 'cxt5047_hp_automic')
WARNING: vmlinux.o(.text+0x299a39): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_cxt5045' and 'via_build_pcms')
WARNING: vmlinux.o(.text+0x299d27): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'via_build_controls' and 'via_mux_enum_put')
WARNING: vmlinux.o(.text+0x299d51): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'via_build_controls' and 'via_mux_enum_put')
WARNING: vmlinux.o(.text+0x299d6d): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'via_build_controls' and 'via_mux_enum_put')
WARNING: vmlinux.o(.text+0x29a1c3): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'vt1709_parse_auto_config' and 'patch_vt1709_6ch')
WARNING: vmlinux.o(.text+0x29a9ad): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_vt1708' and 'patch_vt1709_10ch')

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

The same problem exists in mainline.
A patch to fix the mainline warnings can be found there : http://lkml.org/lkml/2007/7/31/643.


diff -Nurp linux2.6.23-mm/sound/pci/hda/hda_patch.h linux2.6.23-mm-p/sound/pci/hda/hda_patch.h
--- linux2.6.23-mm/sound/pci/hda/hda_patch.h	2007-08-02 14:37:42.000000000 +0200
+++ linux2.6.23-mm-p/sound/pci/hda/hda_patch.h	2007-08-02 14:45:02.000000000 +0200
@@ -19,7 +19,7 @@ extern struct hda_codec_preset snd_hda_p
 /* VIA codecs */
 extern struct hda_codec_preset snd_hda_preset_via[];
 
-static const struct hda_codec_preset *hda_preset_tables[] = {
+static const struct hda_codec_preset *hda_preset_tables[] __devinitdata = {
 #ifdef CONFIG_SND_HDA_CODEC_REALTEK
 	snd_hda_preset_realtek,
 #endif
diff -Nurp linux2.6.23-mm/sound/pci/hda/patch_analog.c linux2.6.23-mm-p/sound/pci/hda/patch_analog.c
--- linux2.6.23-mm/sound/pci/hda/patch_analog.c	2007-08-02 14:37:42.000000000 +0200
+++ linux2.6.23-mm-p/sound/pci/hda/patch_analog.c	2007-08-02 14:44:13.000000000 +0200
@@ -120,7 +120,7 @@ static int ad198x_init(struct hda_codec 
 	return 0;
 }
 
-static int ad198x_build_controls(struct hda_codec *codec)
+static int __devinit ad198x_build_controls(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec = codec->spec;
 	unsigned int i;
@@ -756,7 +756,7 @@ static struct snd_pci_quirk ad1986a_cfg_
 	{}
 };
 
-static int patch_ad1986a(struct hda_codec *codec)
+static int __devinit patch_ad1986a(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec;
 	int board_config;
@@ -1364,7 +1364,7 @@ static struct snd_pci_quirk ad1981_cfg_t
 	{}
 };
 
-static int patch_ad1981(struct hda_codec *codec)
+static int __devinit patch_ad1981(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec;
 	int board_config;
@@ -2569,7 +2569,7 @@ static struct snd_pci_quirk ad1988_cfg_t
 	{}
 };
 
-static int patch_ad1988(struct hda_codec *codec)
+static int __devinit patch_ad1988(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec;
 	int board_config;
@@ -2999,7 +2999,7 @@ static struct snd_pci_quirk ad1984_cfg_t
 	{}
 };
 
-static int patch_ad1984(struct hda_codec *codec)
+static int __devinit patch_ad1984(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec;
 	int board_config, err;
@@ -3258,7 +3258,7 @@ static const char *ad1882_models[AD1986A
 };
 
 
-static int patch_ad1882(struct hda_codec *codec)
+static int __devinit patch_ad1882(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec;
 	int board_config;
@@ -3312,7 +3312,7 @@ static int patch_ad1882(struct hda_codec
 /*
  * patch entries
  */
-struct hda_codec_preset snd_hda_preset_analog[] = {
+struct hda_codec_preset snd_hda_preset_analog[] __devinitdata = {
 	{ .id = 0x11d41882, .name = "AD1882", .patch = patch_ad1882 },
 	{ .id = 0x11d41884, .name = "AD1884", .patch = patch_ad1884 },
 	{ .id = 0x11d41981, .name = "AD1981", .patch = patch_ad1981 },
diff -Nurp linux2.6.23-mm/sound/pci/hda/patch_atihdmi.c linux2.6.23-mm-p/sound/pci/hda/patch_atihdmi.c
--- linux2.6.23-mm/sound/pci/hda/patch_atihdmi.c	2007-07-22 22:41:00.000000000 +0200
+++ linux2.6.23-mm-p/sound/pci/hda/patch_atihdmi.c	2007-08-02 14:44:13.000000000 +0200
@@ -44,7 +44,7 @@ static struct hda_verb atihdmi_basic_ini
 /*
  * Controls
  */
-static int atihdmi_build_controls(struct hda_codec *codec)
+static int __devinit atihdmi_build_controls(struct hda_codec *codec)
 {
 	struct atihdmi_spec *spec = codec->spec;
 	int err;
diff -Nurp linux2.6.23-mm/sound/pci/hda/patch_cmedia.c linux2.6.23-mm-p/sound/pci/hda/patch_cmedia.c
--- linux2.6.23-mm/sound/pci/hda/patch_cmedia.c	2007-07-22 22:41:00.000000000 +0200
+++ linux2.6.23-mm-p/sound/pci/hda/patch_cmedia.c	2007-08-02 14:44:13.000000000 +0200
@@ -315,7 +315,7 @@ static struct hda_verb cmi9880_allout_in
 
 /*
  */
-static int cmi9880_build_controls(struct hda_codec *codec)
+static int __devinit cmi9880_build_controls(struct hda_codec *codec)
 {
 	struct cmi_spec *spec = codec->spec;
 	int err;
@@ -640,7 +640,7 @@ static struct hda_codec_ops cmi9880_patc
 #endif
 };
 
-static int patch_cmi9880(struct hda_codec *codec)
+static int __devinit patch_cmi9880(struct hda_codec *codec)
 {
 	struct cmi_spec *spec;
 
@@ -753,7 +753,7 @@ static int patch_cmi9880(struct hda_code
 /*
  * patch entries
  */
-struct hda_codec_preset snd_hda_preset_cmedia[] = {
+struct hda_codec_preset snd_hda_preset_cmedia[] __devinitdata = {
 	{ .id = 0x13f69880, .name = "CMI9880", .patch = patch_cmi9880 },
  	{ .id = 0x434d4980, .name = "CMI9880", .patch = patch_cmi9880 },
 	{} /* terminator */
diff -Nurp linux2.6.23-mm/sound/pci/hda/patch_conexant.c linux2.6.23-mm-p/sound/pci/hda/patch_conexant.c
--- linux2.6.23-mm/sound/pci/hda/patch_conexant.c	2007-08-02 14:37:42.000000000 +0200
+++ linux2.6.23-mm-p/sound/pci/hda/patch_conexant.c	2007-08-02 14:44:13.000000000 +0200
@@ -328,7 +328,7 @@ static int conexant_resume(struct hda_co
 }
 #endif
 
-static int conexant_build_controls(struct hda_codec *codec)
+static int __devinit conexant_build_controls(struct hda_codec *codec)
 {
 	struct conexant_spec *spec = codec->spec;
 	unsigned int i;
@@ -800,7 +800,7 @@ static struct snd_pci_quirk cxt5045_cfg_
 	{}
 };
 
-static int patch_cxt5045(struct hda_codec *codec)
+static int __devinit patch_cxt5045(struct hda_codec *codec)
 {
 	struct conexant_spec *spec;
 	int board_config;
@@ -1309,7 +1309,7 @@ static struct snd_pci_quirk cxt5047_cfg_
 	{}
 };
 
-static int patch_cxt5047(struct hda_codec *codec)
+static int __devinit patch_cxt5047(struct hda_codec *codec)
 {
 	struct conexant_spec *spec;
 	int board_config;
@@ -1366,12 +1366,12 @@ static int patch_cxt5047(struct hda_code
 		spec->mixers[0] = cxt5047_test_mixer;
 		spec->init_verbs[0] = cxt5047_test_init_verbs;
 		codec->patch_ops.unsol_event = cxt5047_hp_unsol_event;
-#endif	
+#endif
 	}
 	return 0;
 }
 
-struct hda_codec_preset snd_hda_preset_conexant[] = {
+struct hda_codec_preset snd_hda_preset_conexant[] __devinitdata = {
 	{ .id = 0x14f15045, .name = "CX20549 (Venice)",
 	  .patch = patch_cxt5045 },
 	{ .id = 0x14f15047, .name = "CX20551 (Waikiki)",
diff -Nurp linux2.6.23-mm/sound/pci/hda/patch_realtek.c linux2.6.23-mm-p/sound/pci/hda/patch_realtek.c
--- linux2.6.23-mm/sound/pci/hda/patch_realtek.c	2007-08-02 14:37:42.000000000 +0200
+++ linux2.6.23-mm-p/sound/pci/hda/patch_realtek.c	2007-08-02 14:44:13.000000000 +0200
@@ -1237,7 +1237,7 @@ static struct snd_kcontrol_new alc880_un
 /*
  * build control elements
  */
-static int alc_build_controls(struct hda_codec *codec)
+static int __devinit alc_build_controls(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
 	int err;
@@ -3253,7 +3253,7 @@ static void alc880_auto_init_analog_inpu
 /* return 1 if successful, 0 if the proper config is not found,
  * or a negative error code
  */
-static int alc880_parse_auto_config(struct hda_codec *codec)
+static int __devinit alc880_parse_auto_config(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
 	int err;
@@ -3315,7 +3315,7 @@ static void alc880_auto_init(struct hda_
  * OK, here we have finally the patch for ALC880
  */
 
-static int patch_alc880(struct hda_codec *codec)
+static int __devinit patch_alc880(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int board_config;
@@ -4686,7 +4686,7 @@ static struct alc_config_preset alc260_p
 #endif
 };
 
-static int patch_alc260(struct hda_codec *codec)
+static int __devinit patch_alc260(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int err, board_config;
@@ -5614,7 +5614,7 @@ static void alc882_auto_init(struct hda_
 	alc882_auto_init_analog_input(codec);
 }
 
-static int patch_alc882(struct hda_codec *codec)
+static int __devinit patch_alc882(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int err, board_config;
@@ -6977,7 +6977,7 @@ static void alc883_auto_init(struct hda_
 	alc883_auto_init_analog_input(codec);
 }
 
-static int patch_alc883(struct hda_codec *codec)
+static int __devinit patch_alc883(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int err, board_config;
@@ -8047,7 +8047,7 @@ static struct alc_config_preset alc262_p
 	},	
 };
 
-static int patch_alc262(struct hda_codec *codec)
+static int __devinit patch_alc262(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int board_config;
@@ -8565,7 +8565,7 @@ static struct alc_config_preset alc268_p
 	},
 };
 
-static int patch_alc268(struct hda_codec *codec)
+static int __devinit patch_alc268(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int board_config;
@@ -9736,7 +9736,7 @@ static struct alc_config_preset alc861_p
 };
 
 
-static int patch_alc861(struct hda_codec *codec)
+static int __devinit patch_alc861(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int board_config;
@@ -10670,7 +10670,7 @@ static void alc861vd_auto_init(struct hd
 	alc861vd_auto_init_analog_input(codec);
 }
 
-static int patch_alc861vd(struct hda_codec *codec)
+static int __devinit patch_alc861vd(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int err, board_config;
@@ -11524,7 +11524,7 @@ static void alc662_auto_init(struct hda_
 	alc662_auto_init_analog_input(codec);
 }
 
-static int patch_alc662(struct hda_codec *codec)
+static int __devinit patch_alc662(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int err, board_config;
@@ -11584,7 +11584,7 @@ static int patch_alc662(struct hda_codec
 /*
  * patch entries
  */
-struct hda_codec_preset snd_hda_preset_realtek[] = {
+struct hda_codec_preset snd_hda_preset_realtek[] __devinitdata = {
 	{ .id = 0x10ec0260, .name = "ALC260", .patch = patch_alc260 },
 	{ .id = 0x10ec0262, .name = "ALC262", .patch = patch_alc262 },
 	{ .id = 0x10ec0268, .name = "ALC268", .patch = patch_alc268 },
diff -Nurp linux2.6.23-mm/sound/pci/hda/patch_si3054.c linux2.6.23-mm-p/sound/pci/hda/patch_si3054.c
--- linux2.6.23-mm/sound/pci/hda/patch_si3054.c	2007-08-02 14:37:42.000000000 +0200
+++ linux2.6.23-mm-p/sound/pci/hda/patch_si3054.c	2007-08-02 14:44:13.000000000 +0200
@@ -135,7 +135,7 @@ static struct snd_kcontrol_new si3054_mo
 	{}
 };
 
-static int si3054_build_controls(struct hda_codec *codec)
+static int __devinit si3054_build_controls(struct hda_codec *codec)
 {
 	return snd_hda_add_new_ctls(codec, si3054_modem_mixer);
 }
diff -Nurp linux2.6.23-mm/sound/pci/hda/patch_sigmatel.c linux2.6.23-mm-p/sound/pci/hda/patch_sigmatel.c
--- linux2.6.23-mm/sound/pci/hda/patch_sigmatel.c	2007-08-02 14:37:42.000000000 +0200
+++ linux2.6.23-mm-p/sound/pci/hda/patch_sigmatel.c	2007-08-02 14:44:13.000000000 +0200
@@ -419,7 +419,7 @@ static struct snd_kcontrol_new stac9205_
 	{ } /* end */
 };
 
-static int stac92xx_build_controls(struct hda_codec *codec)
+static int __devinit stac92xx_build_controls(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec = codec->spec;
 	int err;
@@ -1570,7 +1570,7 @@ static void stac92xx_auto_init_hp_out(st
 	}
 }
 
-static int stac92xx_parse_auto_config(struct hda_codec *codec, hda_nid_t dig_out, hda_nid_t dig_in)
+static int __devinit stac92xx_parse_auto_config(struct hda_codec *codec, hda_nid_t dig_out, hda_nid_t dig_in)
 {
 	struct sigmatel_spec *spec = codec->spec;
 	int err;
@@ -1964,7 +1964,7 @@ static struct hda_codec_ops stac92xx_pat
 #endif
 };
 
-static int patch_stac9200(struct hda_codec *codec)
+static int __devinit patch_stac9200(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec;
 	int err;
@@ -2014,7 +2014,7 @@ static int patch_stac9200(struct hda_cod
 	return 0;
 }
 
-static int patch_stac925x(struct hda_codec *codec)
+static int __devinit patch_stac925x(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec;
 	int err;
@@ -2086,7 +2086,7 @@ static int patch_stac925x(struct hda_cod
 	return 0;
 }
 
-static int patch_stac922x(struct hda_codec *codec)
+static int __devinit patch_stac922x(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec;
 	int err;
@@ -2187,7 +2187,7 @@ static int patch_stac922x(struct hda_cod
 	return 0;
 }
 
-static int patch_stac927x(struct hda_codec *codec)
+static int __devinit patch_stac927x(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec;
 	int err;
@@ -2267,7 +2267,7 @@ static int patch_stac927x(struct hda_cod
 	return 0;
 }
 
-static int patch_stac9205(struct hda_codec *codec)
+static int __devinit patch_stac9205(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec;
 	int err;
@@ -2532,7 +2532,7 @@ static struct snd_pci_quirk stac9872_cfg
 	{}
 };
 
-static int patch_stac9872(struct hda_codec *codec)
+static int __devinit patch_stac9872(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec;
 	int board_config;
@@ -2543,7 +2543,7 @@ static int patch_stac9872(struct hda_cod
 	if (board_config < 0)
 		/* unknown config, let generic-parser do its job... */
 		return snd_hda_parse_generic_codec(codec);
-	
+
 	spec  = kzalloc(sizeof(*spec), GFP_KERNEL);
 	if (spec == NULL)
 		return -ENOMEM;
@@ -2564,7 +2564,7 @@ static int patch_stac9872(struct hda_cod
 		spec->input_mux = &vaio_mux;
 		spec->mux_nids = vaio_mux_nids;
 		break;
-	
+
 	case CXD9872AKD_VAIO:
 		spec->mixer = vaio_ar_mixer;
 		spec->init = vaio_ar_init;
@@ -2587,7 +2587,7 @@ static int patch_stac9872(struct hda_cod
 /*
  * patch entries
  */
-struct hda_codec_preset snd_hda_preset_sigmatel[] = {
+struct hda_codec_preset snd_hda_preset_sigmatel[] __devinitdata = {
  	{ .id = 0x83847690, .name = "STAC9200", .patch = patch_stac9200 },
  	{ .id = 0x83847882, .name = "STAC9220 A1", .patch = patch_stac922x },
  	{ .id = 0x83847680, .name = "STAC9221 A1", .patch = patch_stac922x },
diff -Nurp linux2.6.23-mm/sound/pci/hda/patch_via.c linux2.6.23-mm-p/sound/pci/hda/patch_via.c
--- linux2.6.23-mm/sound/pci/hda/patch_via.c	2007-07-22 22:41:00.000000000 +0200
+++ linux2.6.23-mm-p/sound/pci/hda/patch_via.c	2007-08-02 14:44:13.000000000 +0200
@@ -455,7 +455,7 @@ static struct hda_pcm_stream vt1708_pcm_
 	.channels_max = 2,
 };
 
-static int via_build_controls(struct hda_codec *codec)
+static int __devinit via_build_controls(struct hda_codec *codec)
 {
 	struct via_spec *spec = codec->spec;
 	int err;
@@ -813,7 +813,7 @@ static int via_auto_init(struct hda_code
 	return 0;
 }
 
-static int patch_vt1708(struct hda_codec *codec)
+static int __devinit patch_vt1708(struct hda_codec *codec)
 {
 	struct via_spec *spec;
 	int err;
@@ -1212,7 +1212,7 @@ static int vt1709_auto_create_analog_inp
 	return 0;
 }
 
-static int vt1709_parse_auto_config(struct hda_codec *codec)
+static int __devinit vt1709_parse_auto_config(struct hda_codec *codec)
 {
 	struct via_spec *spec = codec->spec;
 	int err;
@@ -1251,7 +1251,7 @@ static int vt1709_parse_auto_config(stru
 	return 1;
 }
 
-static int patch_vt1709_10ch(struct hda_codec *codec)
+static int __devinit patch_vt1709_10ch(struct hda_codec *codec)
 {
 	struct via_spec *spec;
 	int err;
@@ -1341,7 +1341,7 @@ static struct hda_verb vt1709_6ch_volume
 	{ }
 };
 
-static int patch_vt1709_6ch(struct hda_codec *codec)
+static int __devinit patch_vt1709_6ch(struct hda_codec *codec)
 {
 	struct via_spec *spec;
 	int err;
@@ -1390,7 +1390,7 @@ static int patch_vt1709_6ch(struct hda_c
 /*
  * patch entries
  */
-struct hda_codec_preset snd_hda_preset_via[] = {
+struct hda_codec_preset snd_hda_preset_via[] __devinitdata = {
 	{ .id = 0x11061708, .name = "VIA VT1708", .patch = patch_vt1708},
 	{ .id = 0x11061709, .name = "VIA VT1708", .patch = patch_vt1708},
 	{ .id = 0x1106170A, .name = "VIA VT1708", .patch = patch_vt1708},

 
