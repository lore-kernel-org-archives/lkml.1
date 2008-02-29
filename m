Return-Path: <linux-kernel-owner+w=401wt.eu-S1762188AbYB2AS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762188AbYB2AS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbYB2ASP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:18:15 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:25874 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbYB2ASN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:18:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OplpYi/Vp5y9sJnadZL4vPJLCX/jIhLgnRbS5O0Acr9w58FMb6mAdzscEMYfgVJ7Js5Kz6huR3all62AowjemNtIVVknv2iOy/IWEO2aM40GSaPnvkI6syXf5K8N7Fsxam3g3ZFlIsKQldpM/9cZqYnNPoeF8sGRJrUsaBTtyCE=
Subject: [PATCH 1/3] sound: hda: missing includes of hda_patch.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 16:18:09 -0800
Message-Id: <1204244289.20280.100.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the array declaration to hda_codec.c where it is used and add includes
where the individual presets are declared.

Fixes the following sparse warnings:
sound/pci/hda/patch_realtek.c:13744:25: warning: symbol 'snd_hda_preset_realtek' was not declared. Should it be static?
sound/pci/hda/patch_cmedia.c:729:25: warning: symbol 'snd_hda_preset_cmedia' was not declared. Should it be static?
sound/pci/hda/patch_analog.c:3656:25: warning: symbol 'snd_hda_preset_analog' was not declared. Should it be static?
sound/pci/hda/patch_sigmatel.c:3995:25: warning: symbol 'snd_hda_preset_sigmatel' was not declared. Should it be static?
sound/pci/hda/patch_si3054.c:286:25: warning: symbol 'snd_hda_preset_si3054' was not declared. Should it be static?
sound/pci/hda/patch_atihdmi.c:156:25: warning: symbol 'snd_hda_preset_atihdmi' was not declared. Should it be static?
sound/pci/hda/patch_conexant.c:1721:25: warning: symbol 'snd_hda_preset_conexant' was not declared. Should it be static?
sound/pci/hda/patch_via.c:1962:25: warning: symbol 'snd_hda_preset_via' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/hda/hda_codec.c      |   31 ++++++++++++++++++++++++++++---
 sound/pci/hda/hda_patch.h      |   28 ----------------------------
 sound/pci/hda/patch_analog.c   |    1 +
 sound/pci/hda/patch_atihdmi.c  |    1 +
 sound/pci/hda/patch_cmedia.c   |    1 +
 sound/pci/hda/patch_conexant.c |    1 +
 sound/pci/hda/patch_realtek.c  |    1 +
 sound/pci/hda/patch_si3054.c   |    2 +-
 sound/pci/hda/patch_sigmatel.c |    1 +
 sound/pci/hda/patch_via.c      |    2 +-
 10 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 37c4139..615687d 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -31,6 +31,7 @@
 #include <sound/initval.h>
 #include "hda_local.h"
 #include <sound/hda_hwdep.h>
+#include "hda_patch.h"	/* codec presets */
 
 #ifdef CONFIG_SND_HDA_POWER_SAVE
 /* define this option here to hide as static */
@@ -63,9 +64,33 @@ static struct hda_vendor_id hda_vendor_ids[] = {
 	{} /* terminator */
 };
 
-/* codec presets */
-#include "hda_patch.h"
-
+static const struct hda_codec_preset *hda_preset_tables[] = {
+#ifdef CONFIG_SND_HDA_CODEC_REALTEK
+	snd_hda_preset_realtek,
+#endif
+#ifdef CONFIG_SND_HDA_CODEC_CMEDIA
+	snd_hda_preset_cmedia,
+#endif
+#ifdef CONFIG_SND_HDA_CODEC_ANALOG
+	snd_hda_preset_analog,
+#endif
+#ifdef CONFIG_SND_HDA_CODEC_SIGMATEL
+	snd_hda_preset_sigmatel,
+#endif
+#ifdef CONFIG_SND_HDA_CODEC_SI3054
+	snd_hda_preset_si3054,
+#endif
+#ifdef CONFIG_SND_HDA_CODEC_ATIHDMI
+	snd_hda_preset_atihdmi,
+#endif
+#ifdef CONFIG_SND_HDA_CODEC_CONEXANT
+	snd_hda_preset_conexant,
+#endif
+#ifdef CONFIG_SND_HDA_CODEC_VIA
+	snd_hda_preset_via,
+#endif
+	NULL
+};
 
 #ifdef CONFIG_SND_HDA_POWER_SAVE
 static void hda_power_work(struct work_struct *work);
diff --git a/sound/pci/hda/hda_patch.h b/sound/pci/hda/hda_patch.h
index f5c23bb..2fdf235 100644
--- a/sound/pci/hda/hda_patch.h
+++ b/sound/pci/hda/hda_patch.h
@@ -18,31 +18,3 @@ extern struct hda_codec_preset snd_hda_preset_atihdmi[];
 extern struct hda_codec_preset snd_hda_preset_conexant[];
 /* VIA codecs */
 extern struct hda_codec_preset snd_hda_preset_via[];
-
-static const struct hda_codec_preset *hda_preset_tables[] = {
-#ifdef CONFIG_SND_HDA_CODEC_REALTEK
-	snd_hda_preset_realtek,
-#endif
-#ifdef CONFIG_SND_HDA_CODEC_CMEDIA
-	snd_hda_preset_cmedia,
-#endif
-#ifdef CONFIG_SND_HDA_CODEC_ANALOG
-	snd_hda_preset_analog,
-#endif
-#ifdef CONFIG_SND_HDA_CODEC_SIGMATEL
-	snd_hda_preset_sigmatel,
-#endif
-#ifdef CONFIG_SND_HDA_CODEC_SI3054
-	snd_hda_preset_si3054,
-#endif
-#ifdef CONFIG_SND_HDA_CODEC_ATIHDMI
-	snd_hda_preset_atihdmi,
-#endif
-#ifdef CONFIG_SND_HDA_CODEC_CONEXANT
-	snd_hda_preset_conexant,
-#endif
-#ifdef CONFIG_SND_HDA_CODEC_VIA
-	snd_hda_preset_via,
-#endif
-	NULL
-};
diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index 19f0884..02eb4d1 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -28,6 +28,7 @@
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
+#include "hda_patch.h"
 
 struct ad198x_spec {
 	struct snd_kcontrol_new *mixers[5];
diff --git a/sound/pci/hda/patch_atihdmi.c b/sound/pci/hda/patch_atihdmi.c
index 9a8bb4c..8cef276 100644
--- a/sound/pci/hda/patch_atihdmi.c
+++ b/sound/pci/hda/patch_atihdmi.c
@@ -27,6 +27,7 @@
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
+#include "hda_patch.h"
 
 struct atihdmi_spec {
 	struct hda_multi_out multiout;
diff --git a/sound/pci/hda/patch_cmedia.c b/sound/pci/hda/patch_cmedia.c
index 3d6097b..ee796af 100644
--- a/sound/pci/hda/patch_cmedia.c
+++ b/sound/pci/hda/patch_cmedia.c
@@ -28,6 +28,7 @@
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
+#include "hda_patch.h"
 #define NUM_PINS	11
 

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index f7cd3a8..ddc93c9 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -27,6 +27,7 @@
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
+#include "hda_patch.h"
 
 #define CXT_PIN_DIR_IN              0x00
 #define CXT_PIN_DIR_OUT             0x01
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 777f8c0..d190b00 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -30,6 +30,7 @@
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
+#include "hda_patch.h"
 
 #define ALC880_FRONT_EVENT		0x01
 #define ALC880_DCVOL_EVENT		0x02
diff --git a/sound/pci/hda/patch_si3054.c b/sound/pci/hda/patch_si3054.c
index d22f5a6..d691f02 100644
--- a/sound/pci/hda/patch_si3054.c
+++ b/sound/pci/hda/patch_si3054.c
@@ -28,7 +28,7 @@
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
-
+#include "hda_patch.h"
 
 /* si3054 verbs */
 #define SI3054_VERB_READ_NODE  0x900
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index caf48ed..2912047 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -32,6 +32,7 @@
 #include <sound/asoundef.h>
 #include "hda_codec.h"
 #include "hda_local.h"
+#include "hda_patch.h"
 
 #define NUM_CONTROL_ALLOC	32
 #define STAC_PWR_EVENT		0x20
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 4e5dd4c..04379bb 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -39,7 +39,7 @@
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
-
+#include "hda_patch.h"
 
 /* amp values */
 #define AMP_VAL_IDX_SHIFT	19
-- 
1.5.4.3.342.g99e8


