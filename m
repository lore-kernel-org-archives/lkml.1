Return-Path: <linux-kernel-owner+w=401wt.eu-S933867AbYDQPp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867AbYDQPp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbYDQPpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:45:43 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:37867 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbYDQPpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:45:42 -0400
Message-ID: <480770A3.3070805@tiscali.nl>
Date: Thu, 17 Apr 2008 17:45:39 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: liam.girdwood@wolfsonmicro.com, broonie@opensource.wolfsonmicro.com,
       alsa-devel@alsa-project.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] SOC: fix tests in cs4270_hw_params()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cs4270_hw_params does several times:

ret = snd_soc_write()
if (ret < 0)
	...

This only works when ret is signed.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/sound/soc/codecs/cs4270.c b/sound/soc/codecs/cs4270.c
index bf2ab72..e73fcfd 100644
--- a/sound/soc/codecs/cs4270.c
+++ b/sound/soc/codecs/cs4270.c
@@ -372,7 +372,7 @@ static int cs4270_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_device *socdev = rtd->socdev;
 	struct snd_soc_codec *codec = socdev->codec;
 	struct cs4270_private *cs4270 = codec->private_data;
-	unsigned int ret = 0;
+	int ret;
 	unsigned int i;
 	unsigned int rate;
 	unsigned int ratio;
