Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbZKZL5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbZKZL5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 06:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759804AbZKZL5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 06:57:04 -0500
Received: from smtp.nokia.com ([192.100.122.230]:52371 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759778AbZKZL5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 06:57:02 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, sfr@canb.auug.org.au
Cc: tj@kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       tiwai@suse.de, broonie@opensource.wolfsonmicro.com
Subject: [PATCH] ASoC: tlv320dac33: Change RT wq to singlethread wq
Date: Thu, 26 Nov 2009 13:55:11 +0200
Message-Id: <1259236511-25805-1-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.3
X-OriginalArrivalTime: 26 Nov 2009 11:55:14.0528 (UTC) FILETIME=[509C4E00:01CA6E8F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RT workqueue is going away in the near future, replace it with
singlethread wq for now, which is still supported.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
---

Hello,

I believe this patch fixes the linux-next breakage (in the tlv320dac33 codec
driver) caused by the removal of the RT workqueue in the wq tree.

 sound/soc/codecs/tlv320dac33.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/tlv320dac33.c b/sound/soc/codecs/tlv320dac33.c
index 2a013e4..9c8903d 100644
--- a/sound/soc/codecs/tlv320dac33.c
+++ b/sound/soc/codecs/tlv320dac33.c
@@ -1118,7 +1118,8 @@ static int dac33_i2c_probe(struct i2c_client *client,
 		}
 		if (dac33->irq != -1) {
 			/* Setup work queue */
-			dac33->dac33_wq = create_rt_workqueue("tlv320dac33");
+			dac33->dac33_wq =
+				create_singlethread_workqueue("tlv320dac33");
 			if (dac33->dac33_wq == NULL) {
 				free_irq(dac33->irq, &dac33->codec);
 				ret = -ENOMEM;
--
1.6.5.3

