Return-Path: <linux-kernel-owner+w=401wt.eu-S965223AbZLHAdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965223AbZLHAdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965198AbZLHAdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:33:08 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47965 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965167AbZLHAdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:33:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=w7xHKD3JSuPaYxPgc0AbU1oabccyyIq+O1aLDrJtcUB2spv/ZgHzVh3QgiZCJ8eVay
         PmAEpooSnF6Wy3XrnyQPLJ8Ar/1kxqmGtFYz/rvYBjCeDg2bEGyZ13Iiqqyvw7HvFCwt
         Oa75lvsyCd8bp6eHbXp4qQEnfrEZl2Pp3N9+w=
Message-ID: <4B1D9F0E.4010009@gmail.com>
Date: Tue, 08 Dec 2009 01:34:22 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: javier.martin@vista-silicon.com, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       alsa-devel@alsa-project.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ASoC: Wrong variable returned on error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrong variable was returned in the case of an error

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 sound/soc/imx/mx1_mx2-pcm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/imx/mx1_mx2-pcm.c b/sound/soc/imx/mx1_mx2-pcm.c
index b838665..bffffcd 100644
--- a/sound/soc/imx/mx1_mx2-pcm.c
+++ b/sound/soc/imx/mx1_mx2-pcm.c
@@ -322,12 +322,12 @@ static int mx1_mx2_pcm_open(struct snd_pcm_substream *substream)
 
 	pr_debug("%s: Requesting dma channel (%s)\n", __func__,
 						prtd->dma_params->name);
-	prtd->dma_ch = imx_dma_request_by_prio(prtd->dma_params->name,
-						DMA_PRIO_HIGH);
-	if (prtd->dma_ch < 0) {
+	ret = imx_dma_request_by_prio(prtd->dma_params->name, DMA_PRIO_HIGH);
+	if (ret < 0) {
 		printk(KERN_ERR "Error %d requesting dma channel\n", ret);
 		return ret;
 	}
+	prtd->dma_ch = ret;
 	imx_dma_config_burstlen(prtd->dma_ch,
 				prtd->dma_params->watermark_level);
 
