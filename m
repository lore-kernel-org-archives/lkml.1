Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbZLDWmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbZLDWmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757558AbZLDWmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:42:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39422 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537AbZLDWmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:42:44 -0500
Message-ID: <4B1990D7.90704@gmail.com>
Date: Fri, 04 Dec 2009 23:44:39 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: perex@perex.cz, tiwai@suse.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 27/31] Constify struct snd_ac97_build_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct snd_ac97_build_ops.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/sound/ac97_codec.h  |   16 +++++-----
 sound/pci/ac97/ac97_codec.c |    2 +-
 sound/pci/ac97/ac97_patch.c |   64 +++++++++++++++++++++---------------------
 3 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/include/sound/ac97_codec.h b/include/sound/ac97_codec.h
index 3dae3f7..8440d6f 100644
--- a/include/sound/ac97_codec.h
+++ b/include/sound/ac97_codec.h
@@ -419,15 +419,15 @@
 struct snd_ac97;
 
 struct snd_ac97_build_ops {
-	int (*build_3d) (struct snd_ac97 *ac97);
-	int (*build_specific) (struct snd_ac97 *ac97);
-	int (*build_spdif) (struct snd_ac97 *ac97);
-	int (*build_post_spdif) (struct snd_ac97 *ac97);
+	int (* const build_3d) (struct snd_ac97 *ac97);
+	int (* const build_specific) (struct snd_ac97 *ac97);
+	int (* const build_spdif) (struct snd_ac97 *ac97);
+	int (* const build_post_spdif) (struct snd_ac97 *ac97);
 #ifdef CONFIG_PM
-	void (*suspend) (struct snd_ac97 *ac97);
-	void (*resume) (struct snd_ac97 *ac97);
+	void (* const suspend) (struct snd_ac97 *ac97);
+	void (* const resume) (struct snd_ac97 *ac97);
 #endif
-	void (*update_jacks) (struct snd_ac97 *ac97);	/* for jack-sharing */
+	void (* const update_jacks) (struct snd_ac97 *ac97);	/* for jack-sharing */
 };
 
 struct snd_ac97_bus_ops {
@@ -477,7 +477,7 @@ struct snd_ac97_template {
 
 struct snd_ac97 {
 	/* -- lowlevel (hardware) driver specific -- */
-	struct snd_ac97_build_ops * build_ops;
+	const struct snd_ac97_build_ops * build_ops;
 	void *private_data;
 	void (*private_free) (struct snd_ac97 *ac97);
 	/* --- */
diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index 78288db..0406809 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -1952,7 +1952,7 @@ static int snd_ac97_dev_disconnect(struct snd_device *device)
 }
 
 /* build_ops to do nothing */
-static struct snd_ac97_build_ops null_build_ops;
+static const struct snd_ac97_build_ops null_build_ops;
 
 #ifdef CONFIG_SND_AC97_POWER_SAVE
 static void do_update_power(struct work_struct *work)
diff --git a/sound/pci/ac97/ac97_patch.c b/sound/pci/ac97/ac97_patch.c
index 7337abd..bf2d0b9 100644
--- a/sound/pci/ac97/ac97_patch.c
+++ b/sound/pci/ac97/ac97_patch.c
@@ -371,7 +371,7 @@ static int patch_yamaha_ymf743_build_spdif(struct snd_ac97 *ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_yamaha_ymf743_ops = {
+static const struct snd_ac97_build_ops patch_yamaha_ymf743_ops = {
 	.build_spdif	= patch_yamaha_ymf743_build_spdif,
 	.build_3d	= patch_yamaha_ymf7x3_3d,
 };
@@ -455,7 +455,7 @@ static int patch_yamaha_ymf753_post_spdif(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_yamaha_ymf753_ops = {
+static const struct snd_ac97_build_ops patch_yamaha_ymf753_ops = {
 	.build_3d	= patch_yamaha_ymf7x3_3d,
 	.build_post_spdif = patch_yamaha_ymf753_post_spdif
 };
@@ -502,7 +502,7 @@ static int patch_wolfson_wm9703_specific(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_wolfson_wm9703_ops = {
+static const struct snd_ac97_build_ops patch_wolfson_wm9703_ops = {
 	.build_specific = patch_wolfson_wm9703_specific,
 };
 
@@ -533,7 +533,7 @@ static int patch_wolfson_wm9704_specific(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_wolfson_wm9704_ops = {
+static const struct snd_ac97_build_ops patch_wolfson_wm9704_ops = {
 	.build_specific = patch_wolfson_wm9704_specific,
 };
 
@@ -555,7 +555,7 @@ static int patch_wolfson_wm9705_specific(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_wolfson_wm9705_ops = {
+static const struct snd_ac97_build_ops patch_wolfson_wm9705_ops = {
 	.build_specific = patch_wolfson_wm9705_specific,
 };
 
@@ -692,7 +692,7 @@ static int patch_wolfson_wm9711_specific(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_wolfson_wm9711_ops = {
+static const struct snd_ac97_build_ops patch_wolfson_wm9711_ops = {
 	.build_specific = patch_wolfson_wm9711_specific,
 };
 
@@ -886,7 +886,7 @@ static void patch_wolfson_wm9713_resume (struct snd_ac97 * ac97)
 }
 #endif
 
-static struct snd_ac97_build_ops patch_wolfson_wm9713_ops = {
+static const struct snd_ac97_build_ops patch_wolfson_wm9713_ops = {
 	.build_specific = patch_wolfson_wm9713_specific,
 	.build_3d = patch_wolfson_wm9713_3d,
 #ifdef CONFIG_PM	
@@ -991,7 +991,7 @@ static int patch_sigmatel_stac97xx_specific(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_sigmatel_stac9700_ops = {
+static const struct snd_ac97_build_ops patch_sigmatel_stac9700_ops = {
 	.build_3d	= patch_sigmatel_stac9700_3d,
 	.build_specific	= patch_sigmatel_stac97xx_specific
 };
@@ -1038,7 +1038,7 @@ static int patch_sigmatel_stac9708_specific(struct snd_ac97 *ac97)
 	return patch_sigmatel_stac97xx_specific(ac97);
 }
 
-static struct snd_ac97_build_ops patch_sigmatel_stac9708_ops = {
+static const struct snd_ac97_build_ops patch_sigmatel_stac9708_ops = {
 	.build_3d	= patch_sigmatel_stac9708_3d,
 	.build_specific	= patch_sigmatel_stac9708_specific
 };
@@ -1267,7 +1267,7 @@ static int patch_sigmatel_stac9758_specific(struct snd_ac97 *ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_sigmatel_stac9758_ops = {
+static const struct snd_ac97_build_ops patch_sigmatel_stac9758_ops = {
 	.build_3d	= patch_sigmatel_stac9700_3d,
 	.build_specific	= patch_sigmatel_stac9758_specific
 };
@@ -1342,7 +1342,7 @@ static int patch_cirrus_build_spdif(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_cirrus_ops = {
+static const struct snd_ac97_build_ops patch_cirrus_ops = {
 	.build_spdif = patch_cirrus_build_spdif
 };
 
@@ -1399,7 +1399,7 @@ static int patch_conexant_build_spdif(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_conexant_ops = {
+static const struct snd_ac97_build_ops patch_conexant_ops = {
 	.build_spdif = patch_conexant_build_spdif
 };
 
@@ -1575,7 +1575,7 @@ static void patch_ad1881_chained(struct snd_ac97 * ac97, int unchained_idx, int
 	}
 }
 
-static struct snd_ac97_build_ops patch_ad1881_build_ops = {
+static const struct snd_ac97_build_ops patch_ad1881_build_ops = {
 #ifdef CONFIG_PM
 	.resume = ad18xx_resume
 #endif
@@ -1662,7 +1662,7 @@ static int patch_ad1885_specific(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_ad1885_build_ops = {
+static const struct snd_ac97_build_ops patch_ad1885_build_ops = {
 	.build_specific = &patch_ad1885_specific,
 #ifdef CONFIG_PM
 	.resume = ad18xx_resume
@@ -1689,7 +1689,7 @@ static int patch_ad1886_specific(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_ad1886_build_ops = {
+static const struct snd_ac97_build_ops patch_ad1886_build_ops = {
 	.build_specific = &patch_ad1886_specific,
 #ifdef CONFIG_PM
 	.resume = ad18xx_resume
@@ -1893,7 +1893,7 @@ static int patch_ad1981a_specific(struct snd_ac97 * ac97)
 				    ARRAY_SIZE(snd_ac97_ad1981x_jack_sense));
 }
 
-static struct snd_ac97_build_ops patch_ad1981a_build_ops = {
+static const struct snd_ac97_build_ops patch_ad1981a_build_ops = {
 	.build_post_spdif = patch_ad198x_post_spdif,
 	.build_specific = patch_ad1981a_specific,
 #ifdef CONFIG_PM
@@ -1948,7 +1948,7 @@ static int patch_ad1981b_specific(struct snd_ac97 *ac97)
 				    ARRAY_SIZE(snd_ac97_ad1981x_jack_sense));
 }
 
-static struct snd_ac97_build_ops patch_ad1981b_build_ops = {
+static const struct snd_ac97_build_ops patch_ad1981b_build_ops = {
 	.build_post_spdif = patch_ad198x_post_spdif,
 	.build_specific = patch_ad1981b_specific,
 #ifdef CONFIG_PM
@@ -2087,7 +2087,7 @@ static int patch_ad1888_specific(struct snd_ac97 *ac97)
 	return patch_build_controls(ac97, snd_ac97_ad1888_controls, ARRAY_SIZE(snd_ac97_ad1888_controls));
 }
 
-static struct snd_ac97_build_ops patch_ad1888_build_ops = {
+static const struct snd_ac97_build_ops patch_ad1888_build_ops = {
 	.build_post_spdif = patch_ad198x_post_spdif,
 	.build_specific = patch_ad1888_specific,
 #ifdef CONFIG_PM
@@ -2136,7 +2136,7 @@ static int patch_ad1980_specific(struct snd_ac97 *ac97)
 	return patch_build_controls(ac97, &snd_ac97_ad198x_2cmic, 1);
 }
 
-static struct snd_ac97_build_ops patch_ad1980_build_ops = {
+static const struct snd_ac97_build_ops patch_ad1980_build_ops = {
 	.build_post_spdif = patch_ad198x_post_spdif,
 	.build_specific = patch_ad1980_specific,
 #ifdef CONFIG_PM
@@ -2251,7 +2251,7 @@ static int patch_ad1985_specific(struct snd_ac97 *ac97)
 				    ARRAY_SIZE(snd_ac97_ad1985_controls));
 }
 
-static struct snd_ac97_build_ops patch_ad1985_build_ops = {
+static const struct snd_ac97_build_ops patch_ad1985_build_ops = {
 	.build_post_spdif = patch_ad198x_post_spdif,
 	.build_specific = patch_ad1985_specific,
 #ifdef CONFIG_PM
@@ -2543,7 +2543,7 @@ static int patch_ad1986_specific(struct snd_ac97 *ac97)
 				    ARRAY_SIZE(snd_ac97_ad1985_controls));
 }
 
-static struct snd_ac97_build_ops patch_ad1986_build_ops = {
+static const struct snd_ac97_build_ops patch_ad1986_build_ops = {
 	.build_post_spdif = patch_ad198x_post_spdif,
 	.build_specific = patch_ad1986_specific,
 #ifdef CONFIG_PM
@@ -2648,7 +2648,7 @@ static int patch_alc650_specific(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_alc650_ops = {
+static const struct snd_ac97_build_ops patch_alc650_ops = {
 	.build_specific	= patch_alc650_specific,
 	.update_jacks = alc650_update_jacks
 };
@@ -2800,7 +2800,7 @@ static int patch_alc655_specific(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_alc655_ops = {
+static const struct snd_ac97_build_ops patch_alc655_ops = {
 	.build_specific	= patch_alc655_specific,
 	.update_jacks = alc655_update_jacks
 };
@@ -2912,7 +2912,7 @@ static int patch_alc850_specific(struct snd_ac97 *ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_alc850_ops = {
+static const struct snd_ac97_build_ops patch_alc850_ops = {
 	.build_specific	= patch_alc850_specific,
 	.update_jacks = alc850_update_jacks
 };
@@ -2974,7 +2974,7 @@ static int patch_cm9738_specific(struct snd_ac97 * ac97)
 	return patch_build_controls(ac97, snd_ac97_cm9738_controls, ARRAY_SIZE(snd_ac97_cm9738_controls));
 }
 
-static struct snd_ac97_build_ops patch_cm9738_ops = {
+static const struct snd_ac97_build_ops patch_cm9738_ops = {
 	.build_specific	= patch_cm9738_specific,
 	.update_jacks = cm9738_update_jacks
 };
@@ -3065,7 +3065,7 @@ static int patch_cm9739_post_spdif(struct snd_ac97 * ac97)
 	return patch_build_controls(ac97, snd_ac97_cm9739_controls_spdif, ARRAY_SIZE(snd_ac97_cm9739_controls_spdif));
 }
 
-static struct snd_ac97_build_ops patch_cm9739_ops = {
+static const struct snd_ac97_build_ops patch_cm9739_ops = {
 	.build_specific	= patch_cm9739_specific,
 	.build_post_spdif = patch_cm9739_post_spdif,
 	.update_jacks = cm9739_update_jacks
@@ -3239,7 +3239,7 @@ static int patch_cm9761_specific(struct snd_ac97 * ac97)
 	return patch_build_controls(ac97, snd_ac97_cm9761_controls, ARRAY_SIZE(snd_ac97_cm9761_controls));
 }
 
-static struct snd_ac97_build_ops patch_cm9761_ops = {
+static const struct snd_ac97_build_ops patch_cm9761_ops = {
 	.build_specific	= patch_cm9761_specific,
 	.build_post_spdif = patch_cm9761_post_spdif,
 	.update_jacks = cm9761_update_jacks
@@ -3335,7 +3335,7 @@ static int patch_cm9780_specific(struct snd_ac97 *ac97)
 	return patch_build_controls(ac97, cm9780_controls, ARRAY_SIZE(cm9780_controls));
 }
 
-static struct snd_ac97_build_ops patch_cm9780_ops = {
+static const struct snd_ac97_build_ops patch_cm9780_ops = {
 	.build_specific	= patch_cm9780_specific,
 	.build_post_spdif = patch_cm9761_post_spdif	/* identical with CM9761 */
 };
@@ -3455,7 +3455,7 @@ static int patch_vt1616_specific(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_vt1616_ops = {
+static const struct snd_ac97_build_ops patch_vt1616_ops = {
 	.build_specific	= patch_vt1616_specific
 };
 
@@ -3809,7 +3809,7 @@ static int patch_it2646_specific(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_it2646_ops = {
+static const struct snd_ac97_build_ops patch_it2646_ops = {
 	.build_specific	= patch_it2646_specific,
 	.update_jacks = it2646_update_jacks
 };
@@ -3843,7 +3843,7 @@ static int patch_si3036_specific(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_si3036_ops = {
+static const struct snd_ac97_build_ops patch_si3036_ops = {
 	.build_specific	= patch_si3036_specific,
 };
 
@@ -3910,7 +3910,7 @@ static int patch_ucb1400_specific(struct snd_ac97 * ac97)
 	return 0;
 }
 
-static struct snd_ac97_build_ops patch_ucb1400_ops = {
+static const struct snd_ac97_build_ops patch_ucb1400_ops = {
 	.build_specific	= patch_ucb1400_specific,
 };
 

