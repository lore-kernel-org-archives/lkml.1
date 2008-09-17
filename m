Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbYIQJA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbYIQJA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 05:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYIQJAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 05:00:13 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:53184 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYIQJAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 05:00:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:references:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=bco/qSwxEH8vU+KUQM6gHmkQ5wf0b3Ipf8S0lRqbfKc9idhz72wLtgrUedJZVFvAuo
         Ymqx7KYrQ/6GVr8vX8w6gIXdPZEHqNolx9DZzkD8DpcifeRyA68Nrjt855sza5XDIqGM
         bTXN4EfO1Y7P0Cam+WTpSxUoAKsD36OTUrtcw=
Date: Wed, 17 Sep 2008 17:00:04 +0800
From: "peerchen" <peerchen@gmail.com>
To: "Wei Ni" <wni@nvidia.com>, "Takashi Iwai" <tiwai@suse.de>,
       "Pavel Hofman" <pavel.hofman@insite.cz>
Cc: "Peer Chen" <pchen@nvidia.com>, "alsa-devel" <alsa-devel@alsa-project.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>
References: <200809031558156739794@gmail.com><s5hhc8xpq6z.wl%tiwai@suse.de><15F501D1A78BD343BE8F4D8DB854566B31F8F744@hkemmail01.nvidia.com><s5h4p4xph6x.wl%tiwai@suse.de><48BE7EE4.8020800@insite.cz>,
 <s5habeoo0ia.wl%tiwai@suse.de>,
 <15F501D1A78BD343BE8F4D8DB854566B32241EB0@hkemmail01.nvidia.com>
Subject: Re: Re: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor	MCP77/79
Message-ID: <200809171700022814652@gmail.com>
X-mailer: Foxmail 6, 10, 201, 20 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

new patch base on git tree.

Signed-off-by: Wei Ni <wni@nvidia.com>
Signed-off-by: Peer Chen <peerchen@gmail.com>
---
diff -uprN -X linux-2.6-tiwai-sound/Documentation/dontdiff linux-2.6-tiwai-sound/sound/pci/hda/hda_codec.c linux-2.6-tiwai-sound-niwei/sound/pci/hda/hda_codec.c
--- linux-2.6-tiwai-sound/sound/pci/hda/hda_codec.c	2008-09-10 17:40:52.000000000 +0800
+++ linux-2.6-tiwai-sound-niwei/sound/pci/hda/hda_codec.c	2008-09-10 17:51:36.000000000 +0800
@@ -94,6 +94,9 @@ static const struct hda_codec_preset *hd
 #ifdef CONFIG_SND_HDA_CODEC_VIA
 	snd_hda_preset_via,
 #endif
+#ifdef CONFIG_SND_HDA_CODEC_NVHDMI
+	snd_hda_preset_nvhdmi,
+#endif
 	NULL
 };
 
diff -uprN -X linux-2.6-tiwai-sound/Documentation/dontdiff linux-2.6-tiwai-sound/sound/pci/hda/hda_intel.c linux-2.6-tiwai-sound-niwei/sound/pci/hda/hda_intel.c
--- linux-2.6-tiwai-sound/sound/pci/hda/hda_intel.c	2008-09-10 17:40:52.000000000 +0800
+++ linux-2.6-tiwai-sound-niwei/sound/pci/hda/hda_intel.c	2008-09-10 17:49:31.000000000 +0800
@@ -1220,6 +1220,9 @@ static int __devinit azx_codec_create(st
 	if (err < 0)
 		return err;
 
+	if (chip->driver_type == AZX_DRIVER_NVIDIA)
+		chip->bus->needs_damn_long_delay = 1;
+
 	codecs = audio_codecs = 0;
 	max_slots = azx_max_codecs[chip->driver_type];
 	if (!max_slots)
diff -uprN -X linux-2.6-tiwai-sound/Documentation/dontdiff linux-2.6-tiwai-sound/sound/pci/hda/hda_patch.h linux-2.6-tiwai-sound-niwei/sound/pci/hda/hda_patch.h
--- linux-2.6-tiwai-sound/sound/pci/hda/hda_patch.h	2008-09-10 17:40:52.000000000 +0800
+++ linux-2.6-tiwai-sound-niwei/sound/pci/hda/hda_patch.h	2008-09-10 17:50:41.000000000 +0800
@@ -18,3 +18,5 @@ extern struct hda_codec_preset snd_hda_p
 extern struct hda_codec_preset snd_hda_preset_conexant[];
 /* VIA codecs */
 extern struct hda_codec_preset snd_hda_preset_via[];
+/* NVIDIA HDMI codecs */
+extern struct hda_codec_preset snd_hda_preset_nvhdmi[];
diff -uprN -X linux-2.6-tiwai-sound/Documentation/dontdiff linux-2.6-tiwai-sound/sound/pci/hda/Makefile linux-2.6-tiwai-sound-niwei/sound/pci/hda/Makefile
--- linux-2.6-tiwai-sound/sound/pci/hda/Makefile	2008-09-10 17:40:52.000000000 +0800
+++ linux-2.6-tiwai-sound-niwei/sound/pci/hda/Makefile	2008-09-10 17:52:06.000000000 +0800
@@ -15,5 +15,6 @@ snd-hda-intel-$(CONFIG_SND_HDA_CODEC_SI3
 snd-hda-intel-$(CONFIG_SND_HDA_CODEC_ATIHDMI) += patch_atihdmi.o
 snd-hda-intel-$(CONFIG_SND_HDA_CODEC_CONEXANT) += patch_conexant.o
 snd-hda-intel-$(CONFIG_SND_HDA_CODEC_VIA) += patch_via.o
+snd-hda-intel-$(CONFIG_SND_HDA_CODEC_NVHDMI) += patch_nvhdmi.o
 
 obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-intel.o
diff -uprN -X linux-2.6-tiwai-sound/Documentation/dontdiff linux-2.6-tiwai-sound/sound/pci/hda/patch_nvhdmi.c linux-2.6-tiwai-sound-niwei/sound/pci/hda/patch_nvhdmi.c
--- linux-2.6-tiwai-sound/sound/pci/hda/patch_nvhdmi.c	1970-01-01 08:00:00.000000000 +0800
+++ linux-2.6-tiwai-sound-niwei/sound/pci/hda/patch_nvhdmi.c	2008-09-10 18:03:15.000000000 +0800
@@ -0,0 +1,164 @@
+/*
+ * Universal Interface for Intel High Definition Audio Codec
+ *
+ * HD audio interface patch for Nvidia HDMI codecs
+ *
+ * Copyright (c) 2008 Nvidia Corp.  All rights reserved.
+ * Copyright 2008 Wei Ni <wni@nvidia.com>
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
+#include "hda_codec.h"
+#include "hda_local.h"
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
+/*
+ * Controls
+ */
+static int nvhdmi_build_controls(struct hda_codec *codec)
+{
+	struct nvhdmi_spec *spec = codec->spec;
+	int err;
+
+	err = snd_hda_create_spdif_out_ctls(codec, spec->multiout.dig_out_nid);
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
+	{ .id = 0x10de0002, .name = "Nvidia MCP77/78 HDMI", .patch = patch_nvhdmi },
+	{ .id = 0x10de0007, .name = "Nvidia MCP79/7A HDMI", .patch = patch_nvhdmi },
+	{} /* terminator */
+};
diff -uprN -X linux-2.6-tiwai-sound/Documentation/dontdiff linux-2.6-tiwai-sound/sound/pci/Kconfig linux-2.6-tiwai-sound-niwei/sound/pci/Kconfig
--- linux-2.6-tiwai-sound/sound/pci/Kconfig	2008-09-10 17:40:51.000000000 +0800
+++ linux-2.6-tiwai-sound-niwei/sound/pci/Kconfig	2008-09-10 17:53:38.000000000 +0800
@@ -565,6 +565,14 @@ config SND_HDA_CODEC_ATIHDMI
 	  Say Y here to include ATI HDMI HD-audio codec support in
 	  snd-hda-intel driver, such as ATI RS600 HDMI.
 
+config SND_HDA_CODEC_NVHDMI
+	bool "Build NVIDIA HDMI HD-audio codec support"
+	depends on SND_HDA_INTEL
+	default y
+	help
+	  Say Y here to include NVIDIA HDMI HD-audio codec support in
+	  snd-hda-intel driver, such as NVIDIA MCP77/78 HDMI.
+
 config SND_HDA_CODEC_CONEXANT
 	bool "Build Conexant HD-audio codec support"
 	depends on SND_HDA_INTEL
-

