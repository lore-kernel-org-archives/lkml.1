Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbXLHUga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbXLHUga (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXLHUgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:36:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:29908 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbXLHUgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:36:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=ayvFlWB9ZWsw/s44ZO45O0XOZFCNkoXscAGKwdxGxrr3PFMXsNzoC/uBEDZkTwQx/kLM6Yna1bViXyfCGTg1F4cFiHQ7dFfm/52yDZ00vZZWtRPzQhnmxC2Cn64o3RRgPkOGf2IaRQb7MFmkY2kuKmGYif7T6duOYSVBSI2O988=
Date: Sat, 8 Dec 2007 21:37:17 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: perex@perex.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pcm_native: fix sparse warning about shadowing 'state'
	symbol
Message-ID: <20071208203712.GA5087@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcm_native: fix sparse warning about shadowing 'state' symbol

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 sound/core/pcm_native.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index fb3dde4..925f0b6 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1395,10 +1395,10 @@ static int snd_pcm_do_drain_init(struct snd_pcm_substream *substream, int state)
 	} else {
 		/* stop running stream */
 		if (runtime->status->state == SNDRV_PCM_STATE_RUNNING) {
-			int state = snd_pcm_capture_avail(runtime) > 0 ?
+			int new_state = snd_pcm_capture_avail(runtime) > 0 ?
 				SNDRV_PCM_STATE_DRAINING : SNDRV_PCM_STATE_SETUP;
-			snd_pcm_do_stop(substream, state);
-			snd_pcm_post_stop(substream, state);
+			snd_pcm_do_stop(substream, new_state);
+			snd_pcm_post_stop(substream, new_state);
 		}
 	}
 	return 0;
