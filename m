Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbXINSJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbXINSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbXINSJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:09:16 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2632 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbXINSJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:09:15 -0400
Subject: Re: [PATCH] add consts where appropriate in sound/pci/hda/*
From: Joe Perches <joe@perches.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <200709141848.06027.vda.linux@googlemail.com>
References: <200709141848.06027.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 11:09:06 -0700
Message-Id: <1189793347.19708.156.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-14 at 18:48 +0100, Denys Vlasenko wrote:

> Patch is attached.

The SND_HDA_PRESETS define doesn't seem useful.
It's only used once.

diff -urp linux-2.6.23-rc6/sound/pci/hda/hda_codec.c linux-2.6.23-rc6.bigdata/sound/pci/hda/hda_codec.c
--- linux-2.6.23-rc6/sound/pci/hda/hda_codec.c	2007-07-09 00:32:17.000000000 +0100
+++ linux-2.6.23-rc6.bigdata/sound/pci/hda/hda_codec.c	2007-09-14 18:32:24.000000000 +0100
@@ -57,6 +57,10 @@ static struct hda_vendor_id hda_vendor_i
 
 /* codec presets */
 #include "hda_patch.h"
+static const struct hda_codec_preset *const hda_preset_tables[] = {
+	SND_HDA_PRESETS,
+	NULL
+};
diff -urp linux-2.6.23-rc6/sound/pci/hda/hda_patch.h linux-2.6.23-rc6.bigdata/sound/pci/hda/hda_patch.h
--- linux-2.6.23-rc6/sound/pci/hda/hda_patch.h	2007-07-09 00:32:17.000000000 +0100
+++ linux-2.6.23-rc6.bigdata/sound/pci/hda/hda_patch.h	2007-09-14 18:30:17.000000000 +0100
@@ -1,32 +1,30 @@
 /*
- * HDA Patches - included by hda_codec.c
+ * HDA Patches
  */
 
 /* Realtek codecs */
-extern struct hda_codec_preset snd_hda_preset_realtek[];
+extern const struct hda_codec_preset snd_hda_preset_realtek[];
 /* C-Media codecs */
-extern struct hda_codec_preset snd_hda_preset_cmedia[];
+extern const struct hda_codec_preset snd_hda_preset_cmedia[];
 /* Analog Devices codecs */
-extern struct hda_codec_preset snd_hda_preset_analog[];
+extern const struct hda_codec_preset snd_hda_preset_analog[];
 /* SigmaTel codecs */
-extern struct hda_codec_preset snd_hda_preset_sigmatel[];
+extern const struct hda_codec_preset snd_hda_preset_sigmatel[];
 /* SiLabs 3054/3055 modem codecs */
-extern struct hda_codec_preset snd_hda_preset_si3054[];
+extern const struct hda_codec_preset snd_hda_preset_si3054[];
 /* ATI HDMI codecs */
-extern struct hda_codec_preset snd_hda_preset_atihdmi[];
+extern const struct hda_codec_preset snd_hda_preset_atihdmi[];
 /* Conexant audio codec */
-extern struct hda_codec_preset snd_hda_preset_conexant[];
+extern const struct hda_codec_preset snd_hda_preset_conexant[];
 /* VIA codecs */
-extern struct hda_codec_preset snd_hda_preset_via[];
+extern const struct hda_codec_preset snd_hda_preset_via[];
 
-static const struct hda_codec_preset *hda_preset_tables[] = {
-	snd_hda_preset_realtek,
-	snd_hda_preset_cmedia,
-	snd_hda_preset_analog,
-	snd_hda_preset_sigmatel,
-	snd_hda_preset_si3054,
-	snd_hda_preset_atihdmi,
-	snd_hda_preset_conexant,
-	snd_hda_preset_via,
-	NULL
-};
+#define SND_HDA_PRESETS \
+	snd_hda_preset_realtek, \
+	snd_hda_preset_cmedia, \
+	snd_hda_preset_analog, \
+	snd_hda_preset_sigmatel, \
+	snd_hda_preset_si3054, \
+	snd_hda_preset_atihdmi, \
+	snd_hda_preset_conexant, \
+	snd_hda_preset_via


