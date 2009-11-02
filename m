Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbZKBMge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbZKBMge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbZKBMf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:35:27 -0500
Received: from smtp.nokia.com ([192.100.105.134]:41329 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbZKBMfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:35:25 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: [PATCH 4/5] ASoC: TWL4030: Make sure, that the codec is powered on startup
Date: Mon,  2 Nov 2009 14:34:54 +0200
Message-Id: <1257165295-9352-5-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257165295-9352-4-git-send-email-peter.ujfalusi@nokia.com>
References: <1257165295-9352-1-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-2-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-3-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-4-git-send-email-peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 02 Nov 2009 12:35:01.0390 (UTC) FILETIME=[E5608AE0:01CA5BB8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the codec->bias_level to SND_SOC_BIAS_OFF before changing
the initial bias level to STANDBY.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
---
 sound/soc/codecs/twl4030.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index f9121ef..c0b47df 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -2234,6 +2234,7 @@ static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 
 	/* Set the defaults, and power up the codec */
 	twl4030_init_chip(codec);
+	codec->bias_level = SND_SOC_BIAS_OFF;
 	twl4030_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	ret = snd_soc_register_codec(codec);
-- 
1.6.5.2

