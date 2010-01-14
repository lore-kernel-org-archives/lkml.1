Return-Path: <linux-kernel-owner+w=401wt.eu-S932345Ab0ANWkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab0ANWkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251Ab0ANW2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:28:19 -0500
Received: from kroah.org ([198.145.64.141]:60495 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab0ANW2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/52] ASoC: fix params_rate() macro use in several codecs
Date: Thu, 14 Jan 2010 14:26:42 -0800
Message-Id: <1263508051-7868-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-2-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit b3172f222ab5afdc91ea058bd11c42cf169728f3 upstream.

Sevelar ASoC codec drivers wrongly assume, that the params_rate() macro
returns one of SNDRV_PCM_RATE_* defines instead of the actual numerical
sampling rate. Fix them.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/soc/codecs/wm8510.c |   14 +++++++-------
 sound/soc/codecs/wm8940.c |   14 +++++++-------
 sound/soc/codecs/wm8974.c |   14 +++++++-------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/sound/soc/codecs/wm8510.c b/sound/soc/codecs/wm8510.c
index 060d5d0..8db62e2 100644
--- a/sound/soc/codecs/wm8510.c
+++ b/sound/soc/codecs/wm8510.c
@@ -425,23 +425,23 @@ static int wm8510_pcm_hw_params(struct snd_pcm_substream *substream,
 
 	/* filter coefficient */
 	switch (params_rate(params)) {
-	case SNDRV_PCM_RATE_8000:
+	case 8000:
 		adn |= 0x5 << 1;
 		break;
-	case SNDRV_PCM_RATE_11025:
+	case 11025:
 		adn |= 0x4 << 1;
 		break;
-	case SNDRV_PCM_RATE_16000:
+	case 16000:
 		adn |= 0x3 << 1;
 		break;
-	case SNDRV_PCM_RATE_22050:
+	case 22050:
 		adn |= 0x2 << 1;
 		break;
-	case SNDRV_PCM_RATE_32000:
+	case 32000:
 		adn |= 0x1 << 1;
 		break;
-	case SNDRV_PCM_RATE_44100:
-	case SNDRV_PCM_RATE_48000:
+	case 44100:
+	case 48000:
 		break;
 	}
 
diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index 1ef2454..63bc2ae 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -379,23 +379,23 @@ static int wm8940_i2s_hw_params(struct snd_pcm_substream *substream,
 		iface |= (1 << 9);
 
 	switch (params_rate(params)) {
-	case SNDRV_PCM_RATE_8000:
+	case 8000:
 		addcntrl |= (0x5 << 1);
 		break;
-	case SNDRV_PCM_RATE_11025:
+	case 11025:
 		addcntrl |= (0x4 << 1);
 		break;
-	case SNDRV_PCM_RATE_16000:
+	case 16000:
 		addcntrl |= (0x3 << 1);
 		break;
-	case SNDRV_PCM_RATE_22050:
+	case 22050:
 		addcntrl |= (0x2 << 1);
 		break;
-	case SNDRV_PCM_RATE_32000:
+	case 32000:
 		addcntrl |= (0x1 << 1);
 		break;
-	case SNDRV_PCM_RATE_44100:
-	case SNDRV_PCM_RATE_48000:
+	case 44100:
+	case 48000:
 		break;
 	}
 	ret = snd_soc_write(codec, WM8940_ADDCNTRL, addcntrl);
diff --git a/sound/soc/codecs/wm8974.c b/sound/soc/codecs/wm8974.c
index b0bd1c0..0dbf6fe 100644
--- a/sound/soc/codecs/wm8974.c
+++ b/sound/soc/codecs/wm8974.c
@@ -480,23 +480,23 @@ static int wm8974_pcm_hw_params(struct snd_pcm_substream *substream,
 
 	/* filter coefficient */
 	switch (params_rate(params)) {
-	case SNDRV_PCM_RATE_8000:
+	case 8000:
 		adn |= 0x5 << 1;
 		break;
-	case SNDRV_PCM_RATE_11025:
+	case 11025:
 		adn |= 0x4 << 1;
 		break;
-	case SNDRV_PCM_RATE_16000:
+	case 16000:
 		adn |= 0x3 << 1;
 		break;
-	case SNDRV_PCM_RATE_22050:
+	case 22050:
 		adn |= 0x2 << 1;
 		break;
-	case SNDRV_PCM_RATE_32000:
+	case 32000:
 		adn |= 0x1 << 1;
 		break;
-	case SNDRV_PCM_RATE_44100:
-	case SNDRV_PCM_RATE_48000:
+	case 44100:
+	case 48000:
 		break;
 	}
 
-- 
1.6.6

