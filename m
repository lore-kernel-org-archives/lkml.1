Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbYKRITj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbYKRITj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYKRIRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:17:06 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:18386 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYKRIRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:17:00 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62691577"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@sirena.org.uk, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>, Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH 7/8] ASoC: Blackfin: Simplify the MMAP_SUPPORT macros protected code
Date: Tue, 18 Nov 2008 16:18:21 +0800
Message-Id: <1226996302-10234-8-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226996302-10234-1-git-send-email-cooloney@kernel.org>
References: <1226996302-10234-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/blackfin/bf5xx-ac97-pcm.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-ac97-pcm.c b/sound/soc/blackfin/bf5xx-ac97-pcm.c
index 4d25f73..d3d51bc 100644
--- a/sound/soc/blackfin/bf5xx-ac97-pcm.c
+++ b/sound/soc/blackfin/bf5xx-ac97-pcm.c
@@ -100,17 +100,14 @@ static void bf5xx_dma_irq(void *data)
  * The total rx/tx buffer is for ac97 frame to hold all pcm data
  * is  0x20000 * sizeof(struct ac97_frame) / 4.
  */
-#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 static const struct snd_pcm_hardware bf5xx_pcm_hardware = {
 	.info			= SNDRV_PCM_INFO_INTERLEAVED |
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 				   SNDRV_PCM_INFO_MMAP |
 				   SNDRV_PCM_INFO_MMAP_VALID |
-				   SNDRV_PCM_INFO_BLOCK_TRANSFER,
-#else
-static const struct snd_pcm_hardware bf5xx_pcm_hardware = {
-	.info			= SNDRV_PCM_INFO_INTERLEAVED |
-				  SNDRV_PCM_INFO_BLOCK_TRANSFER,
 #endif
+				   SNDRV_PCM_INFO_BLOCK_TRANSFER,
+
 	.formats		= SNDRV_PCM_FMTBIT_S16_LE,
 	.period_bytes_min	= 32,
 	.period_bytes_max	= 0x10000,
-- 
1.5.6.3
