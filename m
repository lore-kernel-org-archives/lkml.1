Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbYICH6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbYICH6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 03:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbYICH6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 03:58:24 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:52846 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYICH6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 03:58:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=NWkF1bmdfHFpEAIY8L8z4IJfBk+Mu88c4FU6b1O5hnS/vMn1d1orFC7MdUAECkXN8J
         zS9hHmd8ItIF0f/6+YGbWiFCdOnUIVDKAvoTApeCuip/MM2RcV7XGyxzRaNl1RlmEJmJ
         pwKVcPtoKk+09HBhGvfOD45+GJIR53Kc0uFjA=
Date: Wed, 3 Sep 2008 15:58:17 +0800
From: "peerchen" <peerchen@gmail.com>
To: "alsa-devel" <alsa-devel@alsa-project.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "Takashi Iwai" <tiwai@suse.de>, "akpm" <akpm@linux-foundation.org>,
       "pchen" <pchen@nvidia.com>, "wni" <wni@nvidia.com>
Subject: [alsa-devel][PATCH] add the nvidia HDMI codec driver for MCP77/79
Message-ID: <200809031558156739794@gmail.com>
X-mailer: Foxmail 6, 10, 201, 20 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the nvidia HDMI codec driver for MCP77/79. 
The patch based on kernel 2.6.27-rc5.

Signed-off-by: Wei Ni <wni@nvidia.com>
Signed-off-by: Peer Chen <peerchen@gmail.com>
---
diff -uprN -X linux-2.6.26-Orig/Documentation/dontdiff linux-2.6.26-Orig/sound/pci/hda/hda_intel.c linux-2.6.26-New/sound/pci/hda/hda_intel.c
--- linux-2.6.26-Orig/sound/pci/hda/hda_intel.c	2008-08-28 13:47:20.000000000 +0800
+++ linux-2.6.26-New/sound/pci/hda/hda_intel.c	2008-08-28 15:33:51.000000000 +0800
@@ -223,8 +223,8 @@ enum { SDI0, SDI1, SDI2, SDI3, SDO0, SDO
 #define RIRB_INT_MASK		0x05
 
 /* STATESTS int mask: SD2,SD1,SD0 */
-#define AZX_MAX_CODECS		3
-#define STATESTS_INT_MASK	0x07
+#define AZX_MAX_CODECS		4
+#define STATESTS_INT_MASK	0x0f
 
 /* SD_CTL bits */
 #define SD_CTL_STREAM_RESET	0x01	/* stream reset bit */
diff -uprN -X linux-2.6.26-Orig/Documentation/dontdiff linux-2.6.26-Orig/sound/pci/hda/hda_patch.h linux-2.6.26-New/sound/pci/hda/hda_patch.h
--- linux-2.6.26-Orig/sound/pci/hda/hda_patch.h	2008-08-28 13:47:20.000000000 +0800
+++ linux-2.6.26-New/sound/pci/hda/hda_patch.h	2008-08-28 15:33:51.000000000 +0800
@@ -18,3 +18,5 @@ extern struct hda_codec_preset snd_hda_p
 extern struct hda_codec_preset snd_hda_preset_conexant[];
 /* VIA codecs */
 extern struct hda_codec_preset snd_hda_preset_via[];
+/* NVIDIA HDMI codecs */
+extern struct hda_codec_preset snd_hda_preset_nvhdmi[];
diff -uprN -X linux-2.6.26-Orig/Documentation/dontdiff linux-2.6.26-Orig/sound/pci/hda/Makefile linux-2.6.26-New/sound/pci/hda/Makefile
--- linux-2.6.26-Orig/sound/pci/hda/Makefile	2008-08-28 13:47:20.000000000 +0800
+++ linux-2.6.26-New/sound/pci/hda/Makefile	2008-08-28 15:33:51.000000000 +0800
@@ -14,5 +14,6 @@ snd-hda-intel-$(CONFIG_SND_HDA_CODEC_SI3
 snd-hda-intel-$(CONFIG_SND_HDA_CODEC_ATIHDMI) += patch_atihdmi.o
 snd-hda-intel-$(CONFIG_SND_HDA_CODEC_CONEXANT) += patch_conexant.o
 snd-hda-intel-$(CONFIG_SND_HDA_CODEC_VIA) += patch_via.o
+snd-hda-intel-$(CONFIG_SND_HDA_CODEC_NVHDMI) += patch_nvhdmi.o
 
 obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-intel.o
diff -uprN -X linux-2.6.26-Orig/Documentation/dontdiff linux-2.6.26-Orig/sound/pci/hda/patch_nvhdmi.c linux-2.6.26-New/sound/pci/hda/patch_nvhdmi.c
--- linux-2.6.26-Orig/sound/pci/hda/patch_nvhdmi.c	1970-01-01 08:00:00.000000000 +0800
+++ linux-2.6.26-New/sound/pci/hda/patch_nvhdmi.c	2008-08-28 15:37:33.000000000 +0800
@@ -0,0 +1,379 @@
+/*
+ * Universal Interface for Intel High Definition Audio Codec
+ *
+ * HD audio interface patch for Nvidia HDMI codecs
+ *
+ * Copyright (c) 2008 NVIDIA Corp. All rights reserved.
+ * Copyright (c) 2008 Wei Ni <wni@nvidia.com>
+ *
+ *
+ *  This driver is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This driver is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <sound/core.h>
+#include <sound/asoundef.h>
+#include "hda_codec.h"
+#include "hda_local.h"
+#include "hda_patch.h"
+
+struct nvhdmi_spec {
+	struct hda_multi_out multiout;
+
+	struct hda_pcm pcm_rec;
+};
+
+static struct hda_verb nvhdmi_basic_init[] = {
+	/* enable digital output on pin widget */
+	{ 0x05, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT },
+	{} /* terminator */
+};
+
+static unsigned short convert_from_spdif_status_nv(unsigned int sbits)
+{
+        unsigned short val = 0;
+
+        if (sbits & IEC958_AES0_PROFESSIONAL)
+                val |= AC_DIG1_PROFESSIONAL;
+        if (sbits & IEC958_AES0_NONAUDIO)
+                val |= AC_DIG1_NONAUDIO;
+        if (sbits & IEC958_AES0_PROFESSIONAL) {
+                if ((sbits & IEC958_AES0_PRO_EMPHASIS) ==
+                    IEC958_AES0_PRO_EMPHASIS_5015)
+                        val |= AC_DIG1_EMPHASIS;
+        } else {
+                if ((sbits & IEC958_AES0_CON_EMPHASIS) ==
+                    IEC958_AES0_CON_EMPHASIS_5015)
+                        val |= AC_DIG1_EMPHASIS;
+                if (!(sbits & IEC958_AES0_CON_NOT_COPYRIGHT))
+                        val |= AC_DIG1_COPYRIGHT;
+                if (sbits & (IEC958_AES1_CON_ORIGINAL << 8))
+                        val |= AC_DIG1_LEVEL;
+                val |= sbits & (IEC958_AES1_CON_CATEGORY << 8);
+        }
+        return val;
+}
+
+static unsigned int convert_to_spdif_status_nv(unsigned short val)
+{
+        unsigned int sbits = 0;
+
+        if (val & AC_DIG1_NONAUDIO)
+                sbits |= IEC958_AES0_NONAUDIO;
+        if (val & AC_DIG1_PROFESSIONAL)
+                sbits |= IEC958_AES0_PROFESSIONAL;
+        if (sbits & IEC958_AES0_PROFESSIONAL) {
+                if (sbits & AC_DIG1_EMPHASIS)
+                        sbits |= IEC958_AES0_PRO_EMPHASIS_5015;
+        } else {
+                if (val & AC_DIG1_EMPHASIS)
+                        sbits |= IEC958_AES0_CON_EMPHASIS_5015;
+                if (!(val & AC_DIG1_COPYRIGHT))
+                        sbits |= IEC958_AES0_CON_NOT_COPYRIGHT;
+                if (val & AC_DIG1_LEVEL)
+                        sbits |= (IEC958_AES1_CON_ORIGINAL << 8);
+                sbits |= val & (0x7f << 8);
+        }
+        return sbits;
+}
+
+static int snd_hda_hdmi_cmask_get(struct snd_kcontrol *kcontrol,
+                                   struct snd_ctl_elem_value *ucontrol)
+{
+        ucontrol->value.iec958.status[0] = IEC958_AES0_PROFESSIONAL |
+                                           IEC958_AES0_NONAUDIO |
+                                           IEC958_AES0_CON_EMPHASIS_5015 |
+                                           IEC958_AES0_CON_NOT_COPYRIGHT;
+        ucontrol->value.iec958.status[1] = IEC958_AES1_CON_CATEGORY |
+                                           IEC958_AES1_CON_ORIGINAL;
+        return 0;
+}
+
+static int snd_hda_hdmi_pmask_get(struct snd_kcontrol *kcontrol,
+                                   struct snd_ctl_elem_value *ucontrol)
+{
+        ucontrol->value.iec958.status[0] = IEC958_AES0_PROFESSIONAL |
+                                           IEC958_AES0_NONAUDIO |
+                                           IEC958_AES0_PRO_EMPHASIS_5015;
+        return 0;
+}
+
+static int snd_hda_hdmi_mask_info(struct snd_kcontrol *kcontrol,
+                                   struct snd_ctl_elem_info *uinfo)
+{
+        uinfo->type = SNDRV_CTL_ELEM_TYPE_IEC958;
+        uinfo->count = 1;
+        return 0;
+}
+
+static int snd_hda_hdmi_default_get(struct snd_kcontrol *kcontrol,
+                                     struct snd_ctl_elem_value *ucontrol)
+{
+        struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
+
+        ucontrol->value.iec958.status[0] = codec->spdif_status & 0xff;
+        ucontrol->value.iec958.status[1] = (codec->spdif_status >> 8) & 0xff;
+        ucontrol->value.iec958.status[2] = (codec->spdif_status >> 16) & 0xff;
+        ucontrol->value.iec958.status[3] = (codec->spdif_status >> 24) & 0xff;
+
+        return 0;
+}
+
+static int snd_hda_hdmi_default_put(struct snd_kcontrol *kcontrol,
+                                     struct snd_ctl_elem_value *ucontrol)
+{
+        struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
+        hda_nid_t nid = kcontrol->private_value;
+        unsigned short val;
+        int change;
+
+        mutex_lock(&codec->spdif_mutex);
+        codec->spdif_status = ucontrol->value.iec958.status[0] |
+                ((unsigned int)ucontrol->value.iec958.status[1] << 8) |
+                ((unsigned int)ucontrol->value.iec958.status[2] << 16) |
+                ((unsigned int)ucontrol->value.iec958.status[3] << 24);
+        val = convert_from_spdif_status_nv(codec->spdif_status);
+        val |= codec->spdif_ctls & 1;
+        change = codec->spdif_ctls != val;
+        codec->spdif_ctls = val;
+
+        if (change) {
+                snd_hda_codec_write_cache(codec, nid, 0,
+                                          AC_VERB_SET_DIGI_CONVERT_1,
+                                          val & 0xff);
+                snd_hda_codec_write_cache(codec, nid, 0,
+                                          AC_VERB_SET_DIGI_CONVERT_2,
+                                          val >> 8);
+        }
+
+        mutex_unlock(&codec->spdif_mutex);
+        return change;
+}
+
+#define snd_hda_hdmi_out_switch_info   snd_ctl_boolean_mono_info
+
+static int snd_hda_hdmi_out_switch_get(struct snd_kcontrol *kcontrol,
+                                        struct snd_ctl_elem_value *ucontrol)
+{
+        struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
+
+        ucontrol->value.integer.value[0] = codec->spdif_ctls & AC_DIG1_ENABLE;
+        return 0;
+}
+
+static int snd_hda_hdmi_out_switch_put(struct snd_kcontrol *kcontrol,
+                                        struct snd_ctl_elem_value *ucontrol)
+{
+        struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
+        hda_nid_t nid = kcontrol->private_value;
+        unsigned short val;
+        int change;
+
+        mutex_lock(&codec->spdif_mutex);
+        val = codec->spdif_ctls & ~AC_DIG1_ENABLE;
+        if (ucontrol->value.integer.value[0])
+                val |= AC_DIG1_ENABLE;
+        change = codec->spdif_ctls != val;
+        if (change) {
+                codec->spdif_ctls = val;
+                snd_hda_codec_write_cache(codec, nid, 0,
+                                          AC_VERB_SET_DIGI_CONVERT_1,
+                                          val & 0xff);
+                /* unmute amp switch (if any) */
+                if ((get_wcaps(codec, nid) & AC_WCAP_OUT_AMP) &&
+                    (val & AC_DIG1_ENABLE))
+                        snd_hda_codec_amp_stereo(codec, nid, HDA_OUTPUT, 0,
+                                                 HDA_AMP_MUTE, 0);
+        }
+        mutex_unlock(&codec->spdif_mutex);
+        return change;
+}
+
+struct snd_kcontrol_new hdmi_mixes[] = {
+    {
+        .access = SNDRV_CTL_ELEM_ACCESS_READ,
+        .iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+        .name = "IEC958 Playback Con Mask HDMI",
+        .info = snd_hda_hdmi_mask_info,
+        .get = snd_hda_hdmi_cmask_get,
+    },
+    {
+        .access = SNDRV_CTL_ELEM_ACCESS_READ,
+        .iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+        .name = "IEC958 Playback Pro Mask HDMI",
+        .info = snd_hda_hdmi_mask_info,
+        .get = snd_hda_hdmi_pmask_get,
+    },
+    {
+        .iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+        .name = "IEC958 Playback Default HDMI",
+        .info = snd_hda_hdmi_mask_info,
+        .get = snd_hda_hdmi_default_get,
+        .put = snd_hda_hdmi_default_put,
+    },
+    {
+        .iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+        .name = "IEC958 Playback Switch HDMI",
+        .info = snd_hda_hdmi_out_switch_info,
+        .get = snd_hda_hdmi_out_switch_get,
+        .put = snd_hda_hdmi_out_switch_put,
+    },
+    {}
+};
+
+int snd_hda_create_hdmi_out_ctls(struct hda_codec *codec, hda_nid_t nid)
+{
+        int err;
+        struct snd_kcontrol *kctl;
+        struct snd_kcontrol_new *dig_mix;
+
+        for (dig_mix = hdmi_mixes; dig_mix->name; dig_mix++) {
+                kctl = snd_ctl_new1(dig_mix, codec);
+                kctl->private_value = nid;
+                err = snd_ctl_add(codec->bus->card, kctl);
+                if (err < 0)
+                        return err;
+        }
+        codec->spdif_ctls =
+                snd_hda_codec_read(codec, nid, 0,
+                                   AC_VERB_GET_DIGI_CONVERT_1, 0);
+        codec->spdif_status = convert_to_spdif_status_nv(codec->spdif_ctls);
+        return 0;
+}
+
+/*
+ * Controls
+ */
+static int nvhdmi_build_controls(struct hda_codec *codec)
+{
+	struct nvhdmi_spec *spec = codec->spec;
+	int err;
+
+	err = snd_hda_create_hdmi_out_ctls(codec, spec->multiout.dig_out_nid);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int nvhdmi_init(struct hda_codec *codec)
+{
+	snd_hda_sequence_write(codec, nvhdmi_basic_init);
+	return 0;
+}
+
+/*
+ * Digital out
+ */
+static int nvhdmi_dig_playback_pcm_open(struct hda_pcm_stream *hinfo,
+				     struct hda_codec *codec,
+				     struct snd_pcm_substream *substream)
+{
+	struct nvhdmi_spec *spec = codec->spec;
+	return snd_hda_multi_out_dig_open(codec, &spec->multiout);
+}
+
+static int nvhdmi_dig_playback_pcm_close(struct hda_pcm_stream *hinfo,
+				      struct hda_codec *codec,
+				      struct snd_pcm_substream *substream)
+{
+	struct nvhdmi_spec *spec = codec->spec;
+	return snd_hda_multi_out_dig_close(codec, &spec->multiout);
+}
+
+static int nvhdmi_dig_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
+					    struct hda_codec *codec,
+					    unsigned int stream_tag,
+					    unsigned int format,
+					    struct snd_pcm_substream *substream)
+{
+	struct nvhdmi_spec *spec = codec->spec;
+	return snd_hda_multi_out_dig_prepare(codec, &spec->multiout, stream_tag,
+					     format, substream);
+}
+
+static struct hda_pcm_stream nvhdmi_pcm_digital_playback = {
+	.substreams = 1,
+	.channels_min = 2,
+	.channels_max = 2,
+	.nid = 0x4, /* NID to query formats and rates and setup streams */
+        .rates = SNDRV_PCM_RATE_48000,
+        .maxbps = 16,
+        .formats = SNDRV_PCM_FMTBIT_S16_LE,
+	.ops = {
+		.open = nvhdmi_dig_playback_pcm_open,
+		.close = nvhdmi_dig_playback_pcm_close,
+		.prepare = nvhdmi_dig_playback_pcm_prepare
+	},
+};
+
+static int nvhdmi_build_pcms(struct hda_codec *codec)
+{
+	struct nvhdmi_spec *spec = codec->spec;
+	struct hda_pcm *info = &spec->pcm_rec;
+
+	codec->num_pcms = 1;
+	codec->pcm_info = info;
+
+	info->name = "NVIDIA HDMI";
+        info->pcm_type = HDA_PCM_TYPE_HDMI
+	info->stream[SNDRV_PCM_STREAM_PLAYBACK] = nvhdmi_pcm_digital_playback;
+
+	return 0;
+}
+
+static void nvhdmi_free(struct hda_codec *codec)
+{
+	kfree(codec->spec);
+}
+
+static struct hda_codec_ops nvhdmi_patch_ops = {
+	.build_controls = nvhdmi_build_controls,
+	.build_pcms = nvhdmi_build_pcms,
+	.init = nvhdmi_init,
+	.free = nvhdmi_free,
+};
+
+static int patch_nvhdmi(struct hda_codec *codec)
+{
+	struct nvhdmi_spec *spec;
+
+	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
+	if (spec == NULL)
+		return -ENOMEM;
+
+	codec->spec = spec;
+
+	spec->multiout.num_dacs = 0;	  /* no analog */
+	spec->multiout.max_channels = 2;
+	spec->multiout.dig_out_nid = 0x4; /* NID for copying analog to digital,
+					   * seems to be unused in pure-digital
+					   * case. */
+
+	codec->patch_ops = nvhdmi_patch_ops;
+
+	return 0;
+}
+
+/*
+ * patch entries
+ */
+struct hda_codec_preset snd_hda_preset_nvhdmi[] = {
+	{ .id = 0x10de0002, .name = "Nvidia MCP78 HDMI", .patch = patch_nvhdmi },
+	{ .id = 0x10de0007, .name = "Nvidia MCP7A HDMI", .patch = patch_nvhdmi },
+	{} /* terminator */
+};
diff -uprN -X linux-2.6.26-Orig/Documentation/dontdiff linux-2.6.26-Orig/sound/pci/Kconfig linux-2.6.26-New/sound/pci/Kconfig
--- linux-2.6.26-Orig/sound/pci/Kconfig	2008-08-28 13:47:20.000000000 +0800
+++ linux-2.6.26-New/sound/pci/Kconfig	2008-08-28 15:33:51.000000000 +0800
@@ -557,6 +557,14 @@ config SND_HDA_CODEC_ATIHDMI
 	  Say Y here to include ATI HDMI HD-audio codec support in
 	  snd-hda-intel driver, such as ATI RS600 HDMI.
 
+config SND_HDA_CODEC_NVHDMI
+	bool "Build Nvidia HDMI HD-audio codec support"
+	depends on SND_HDA_INTEL
+	default y
+	help
+	  Say Y here to include Nvidia HDMI HD-audio codec support in
+	  snd-hda-intel driver, such as Nvidia MCP78 HDMI.
+
 config SND_HDA_CODEC_CONEXANT
 	bool "Build Conexant HD-audio codec support"
 	depends on SND_HDA_INTEL
-

