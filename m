Return-Path: <linux-kernel-owner+w=401wt.eu-S1751785AbXCJT25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbXCJT25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 14:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbXCJT25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 14:28:57 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:53680 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbXCJT2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 14:28:55 -0500
Date: Sat, 10 Mar 2007 19:26:41 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [SOUND] ice1712: build fixes
Message-ID: <20070310192641.GA24602@linux-mips.org>
References: <20070310190513.GA24435@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310190513.GA24435@linux-mips.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  CC [M]  sound/pci/ice1712/ice1712.o
sound/pci/ice1712/ice1712.c:290: error: snd_ice1712_mixer_digmix_route_ac97 causes a section type conflict
sound/pci/ice1712/ice1712.c:1630: error: snd_ice1712_eeprom causes a section type conflict
sound/pci/ice1712/ice1712.c:1894: error: snd_ice1712_pro_internal_clock causes a section type conflict
sound/pci/ice1712/ice1712.c:1965: error: snd_ice1712_pro_internal_clock_default causes a section type conflict
sound/pci/ice1712/ice1712.c:2004: error: snd_ice1712_pro_rate_locking causes a section type conflict
sound/pci/ice1712/ice1712.c:2043: error: snd_ice1712_pro_rate_reset causes a section type conflict
sound/pci/ice1712/ice1712.c:2210: error: snd_ice1712_mixer_pro_analog_route causes a section type conflict
sound/pci/ice1712/ice1712.c:2218: error: snd_ice1712_mixer_pro_spdif_route causes a section type conflict
sound/pci/ice1712/ice1712.c:2260: error: snd_ice1712_mixer_pro_volume_rate causes a section type conflict
sound/pci/ice1712/ice1712.c:2293: error: snd_ice1712_mixer_pro_peak causes a section type conflict
sound/pci/ice1712/ice1712.c:1666: error: snd_ice1712_spdif_default causes a section type conflict
sound/pci/ice1712/ice1712.c:1717: error: snd_ice1712_spdif_maskc causes a section type conflict
sound/pci/ice1712/ice1712.c:1726: error: snd_ice1712_spdif_maskp causes a section type conflict
sound/pci/ice1712/ice1712.c:1753: error: snd_ice1712_spdif_stream causes a section type conflict

Gcc like its __devinitdata readable not const, it seems.  An alternative
fix would be to remove the __devinitdata attribute but that would result
in slight runtime bloat.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/sound/pci/ice1712/delta.c b/sound/pci/ice1712/delta.c
index 3eeb36c..a48140b 100644
--- a/sound/pci/ice1712/delta.c
+++ b/sound/pci/ice1712/delta.c
@@ -735,7 +735,7 @@ static int __devinit snd_ice1712_delta_add_controls(struct snd_ice1712 *ice)
 
 
 /* entry point */
-const struct snd_ice1712_card_info snd_ice1712_delta_cards[] __devinitdata = {
+struct snd_ice1712_card_info snd_ice1712_delta_cards[] __devinitdata = {
 	{
 		.subvendor = ICE1712_SUBDEVICE_DELTA1010,
 		.name = "M Audio Delta 1010",
diff --git a/sound/pci/ice1712/delta.h b/sound/pci/ice1712/delta.h
index e65d669..746ebde 100644
--- a/sound/pci/ice1712/delta.h
+++ b/sound/pci/ice1712/delta.h
@@ -46,7 +46,7 @@
 #define ICE1712_SUBDEVICE_MEDIASTATION	0x694c0100
 
 /* entry point */
-extern const struct snd_ice1712_card_info snd_ice1712_delta_cards[];
+extern struct snd_ice1712_card_info snd_ice1712_delta_cards[];
 
 
 /*
diff --git a/sound/pci/ice1712/ews.c b/sound/pci/ice1712/ews.c
index 9b7ff30..467fd01 100644
--- a/sound/pci/ice1712/ews.c
+++ b/sound/pci/ice1712/ews.c
@@ -989,7 +989,7 @@ static int __devinit snd_ice1712_ews_add_controls(struct snd_ice1712 *ice)
 
 
 /* entry point */
-const struct snd_ice1712_card_info snd_ice1712_ews_cards[] __devinitdata = {
+struct snd_ice1712_card_info snd_ice1712_ews_cards[] __devinitdata = {
 	{
 		.subvendor = ICE1712_SUBDEVICE_EWX2496,
 		.name = "TerraTec EWX24/96",
diff --git a/sound/pci/ice1712/ews.h b/sound/pci/ice1712/ews.h
index df449b4..a12a0b0 100644
--- a/sound/pci/ice1712/ews.h
+++ b/sound/pci/ice1712/ews.h
@@ -40,7 +40,7 @@
 #define ICE1712_SUBDEVICE_PHASE88	0x3b155111
 
 /* entry point */
-extern const struct snd_ice1712_card_info snd_ice1712_ews_cards[];
+extern struct snd_ice1712_card_info snd_ice1712_ews_cards[];
 
 
 /* TerraTec EWX 24/96 configuration definitions */
diff --git a/sound/pci/ice1712/hoontech.c b/sound/pci/ice1712/hoontech.c
index df97313..8193450 100644
--- a/sound/pci/ice1712/hoontech.c
+++ b/sound/pci/ice1712/hoontech.c
@@ -298,7 +298,7 @@ static int __devinit snd_ice1712_ez8_init(struct snd_ice1712 *ice)
 
 
 /* entry point */
-const struct snd_ice1712_card_info snd_ice1712_hoontech_cards[] __devinitdata = {
+struct snd_ice1712_card_info snd_ice1712_hoontech_cards[] __devinitdata = {
 	{
 		.subvendor = ICE1712_SUBDEVICE_STDSP24,
 		.name = "Hoontech SoundTrack Audio DSP24",
diff --git a/sound/pci/ice1712/hoontech.h b/sound/pci/ice1712/hoontech.h
index b62d6e4..1ee538b 100644
--- a/sound/pci/ice1712/hoontech.h
+++ b/sound/pci/ice1712/hoontech.h
@@ -35,7 +35,7 @@
 #define ICE1712_SUBDEVICE_STDSP24_MEDIA7_1	0x16141217	/* Hoontech ST Audio DSP24 Media 7.1 */
 #define ICE1712_SUBDEVICE_EVENT_EZ8		0x00010001	/* A dummy id for EZ8 */
 
-extern const struct snd_ice1712_card_info snd_ice1712_hoontech_cards[];
+extern struct snd_ice1712_card_info snd_ice1712_hoontech_cards[];
 
 
 /* Hoontech SoundTrack Audio DSP 24 GPIO definitions */
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 830a1bb..23d1419 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -287,7 +287,7 @@ static int snd_ice1712_digmix_route_ac97_put(struct snd_kcontrol *kcontrol, stru
 	return val != nval;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_mixer_digmix_route_ac97 __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_mixer_digmix_route_ac97 __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Digital Mixer To AC97",
 	.info = snd_ice1712_digmix_route_ac97_info,
@@ -1380,7 +1380,7 @@ static int snd_ice1712_pro_mixer_volume_put(struct snd_kcontrol *kcontrol, struc
 
 static const DECLARE_TLV_DB_SCALE(db_scale_playback, -14400, 150, 0);
 
-static const struct snd_kcontrol_new snd_ice1712_multi_playback_ctrls[] __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_multi_playback_ctrls[] __devinitdata = {
 	{
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 		.name = "Multi Playback Switch",
@@ -1404,7 +1404,7 @@ static const struct snd_kcontrol_new snd_ice1712_multi_playback_ctrls[] __devini
 	},
 };
 
-static const struct snd_kcontrol_new snd_ice1712_multi_capture_analog_switch __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_multi_capture_analog_switch __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "H/W Multi Capture Switch",
 	.info = snd_ice1712_pro_mixer_switch_info,
@@ -1413,7 +1413,7 @@ static const struct snd_kcontrol_new snd_ice1712_multi_capture_analog_switch __d
 	.private_value = 10,
 };
 
-static const struct snd_kcontrol_new snd_ice1712_multi_capture_spdif_switch __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_multi_capture_spdif_switch __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = SNDRV_CTL_NAME_IEC958("Multi ",CAPTURE,SWITCH),
 	.info = snd_ice1712_pro_mixer_switch_info,
@@ -1423,7 +1423,7 @@ static const struct snd_kcontrol_new snd_ice1712_multi_capture_spdif_switch __de
 	.count = 2,
 };
 
-static const struct snd_kcontrol_new snd_ice1712_multi_capture_analog_volume __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_multi_capture_analog_volume __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.access = (SNDRV_CTL_ELEM_ACCESS_READWRITE |
 		   SNDRV_CTL_ELEM_ACCESS_TLV_READ),
@@ -1435,7 +1435,7 @@ static const struct snd_kcontrol_new snd_ice1712_multi_capture_analog_volume __d
 	.tlv = { .p = db_scale_playback }
 };
 
-static const struct snd_kcontrol_new snd_ice1712_multi_capture_spdif_volume __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_multi_capture_spdif_volume __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = SNDRV_CTL_NAME_IEC958("Multi ",CAPTURE,VOLUME),
 	.info = snd_ice1712_pro_mixer_volume_info,
@@ -1627,7 +1627,7 @@ static int snd_ice1712_eeprom_get(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_eeprom __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_eeprom __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_CARD,
 	.name = "ICE1712 EEPROM",
 	.access = SNDRV_CTL_ELEM_ACCESS_READ,
@@ -1663,7 +1663,7 @@ static int snd_ice1712_spdif_default_put(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_spdif_default __devinitdata =
+static struct snd_kcontrol_new snd_ice1712_spdif_default __devinitdata =
 {
 	.iface =	SNDRV_CTL_ELEM_IFACE_PCM,
 	.name =         SNDRV_CTL_NAME_IEC958("",PLAYBACK,DEFAULT),
@@ -1714,7 +1714,7 @@ static int snd_ice1712_spdif_maskp_get(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_spdif_maskc __devinitdata =
+static struct snd_kcontrol_new snd_ice1712_spdif_maskc __devinitdata =
 {
 	.access =	SNDRV_CTL_ELEM_ACCESS_READ,
 	.iface =	SNDRV_CTL_ELEM_IFACE_PCM,
@@ -1723,7 +1723,7 @@ static const struct snd_kcontrol_new snd_ice1712_spdif_maskc __devinitdata =
 	.get =		snd_ice1712_spdif_maskc_get,
 };
 
-static const struct snd_kcontrol_new snd_ice1712_spdif_maskp __devinitdata =
+static struct snd_kcontrol_new snd_ice1712_spdif_maskp __devinitdata =
 {
 	.access =	SNDRV_CTL_ELEM_ACCESS_READ,
 	.iface =	SNDRV_CTL_ELEM_IFACE_PCM,
@@ -1750,7 +1750,7 @@ static int snd_ice1712_spdif_stream_put(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_spdif_stream __devinitdata =
+static struct snd_kcontrol_new snd_ice1712_spdif_stream __devinitdata =
 {
 	.access =	(SNDRV_CTL_ELEM_ACCESS_READWRITE |
 			 SNDRV_CTL_ELEM_ACCESS_INACTIVE),
@@ -1891,7 +1891,7 @@ static int snd_ice1712_pro_internal_clock_put(struct snd_kcontrol *kcontrol,
 	return change;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_pro_internal_clock __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_pro_internal_clock __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Multi Track Internal Clock",
 	.info = snd_ice1712_pro_internal_clock_info,
@@ -1962,7 +1962,7 @@ static int snd_ice1712_pro_internal_clock_default_put(struct snd_kcontrol *kcont
 	return change;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_pro_internal_clock_default __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_pro_internal_clock_default __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Multi Track Internal Clock Default",
 	.info = snd_ice1712_pro_internal_clock_default_info,
@@ -2001,7 +2001,7 @@ static int snd_ice1712_pro_rate_locking_put(struct snd_kcontrol *kcontrol,
 	return change;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_pro_rate_locking __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_pro_rate_locking __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Multi Track Rate Locking",
 	.info = snd_ice1712_pro_rate_locking_info,
@@ -2040,7 +2040,7 @@ static int snd_ice1712_pro_rate_reset_put(struct snd_kcontrol *kcontrol,
 	return change;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_pro_rate_reset __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_pro_rate_reset __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Multi Track Rate Reset",
 	.info = snd_ice1712_pro_rate_reset_info,
@@ -2207,7 +2207,7 @@ static int snd_ice1712_pro_route_spdif_put(struct snd_kcontrol *kcontrol,
 	return change;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_mixer_pro_analog_route __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_mixer_pro_analog_route __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "H/W Playback Route",
 	.info = snd_ice1712_pro_route_info,
@@ -2215,7 +2215,7 @@ static const struct snd_kcontrol_new snd_ice1712_mixer_pro_analog_route __devini
 	.put = snd_ice1712_pro_route_analog_put,
 };
 
-static const struct snd_kcontrol_new snd_ice1712_mixer_pro_spdif_route __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_mixer_pro_spdif_route __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = SNDRV_CTL_NAME_IEC958("",PLAYBACK,NONE) "Route",
 	.info = snd_ice1712_pro_route_info,
@@ -2257,7 +2257,7 @@ static int snd_ice1712_pro_volume_rate_put(struct snd_kcontrol *kcontrol,
 	return change;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_mixer_pro_volume_rate __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_mixer_pro_volume_rate __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Multi Track Volume Rate",
 	.info = snd_ice1712_pro_volume_rate_info,
@@ -2290,7 +2290,7 @@ static int snd_ice1712_pro_peak_get(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_mixer_pro_peak __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_mixer_pro_peak __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Multi Track Peak",
 	.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
@@ -2305,7 +2305,7 @@ static const struct snd_kcontrol_new snd_ice1712_mixer_pro_peak __devinitdata =
 /*
  * list of available boards
  */
-static const struct snd_ice1712_card_info *card_tables[] __devinitdata = {
+static struct snd_ice1712_card_info *card_tables[] __devinitdata = {
 	snd_ice1712_hoontech_cards,
 	snd_ice1712_delta_cards,
 	snd_ice1712_ews_cards,
@@ -2329,7 +2329,7 @@ static int __devinit snd_ice1712_read_eeprom(struct snd_ice1712 *ice,
 {
 	int dev = 0xa0;		/* EEPROM device address */
 	unsigned int i, size;
-	const struct snd_ice1712_card_info **tbl, *c;
+	struct snd_ice1712_card_info **tbl, *c;
 
 	if (! modelname || ! *modelname) {
 		ice->eeprom.subvendor = 0;
@@ -2658,7 +2658,7 @@ static int __devinit snd_ice1712_create(struct snd_card *card,
  *
  */
 
-static const struct snd_ice1712_card_info no_matched __devinitdata;
+static struct snd_ice1712_card_info no_matched __devinitdata;
 
 static int __devinit snd_ice1712_probe(struct pci_dev *pci,
 				       const struct pci_device_id *pci_id)
@@ -2667,7 +2667,7 @@ static int __devinit snd_ice1712_probe(struct pci_dev *pci,
 	struct snd_card *card;
 	struct snd_ice1712 *ice;
 	int pcm_dev = 0, err;
-	const struct snd_ice1712_card_info **tbl, *c;
+	struct snd_ice1712_card_info **tbl, *c;
 
 	if (dev >= SNDRV_CARDS)
 		return -ENODEV;
