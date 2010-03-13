Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965237Ab0CMB2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:28:01 -0500
Received: from kroah.org ([198.145.64.141]:60721 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934824Ab0CMAUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:06 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:09 2010
Message-Id: <20100313001509.020338202@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jaroslav Kysela <perex@perex.cz>
Subject: [patch 044/123] ALSA: pcm core - fix fifo_size channels interval check
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Jaroslav Kysela <perex@perex.cz>

commit 3be522a9514f58e0596db34898a514df206cadc5 upstream.

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/pcm_native.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -315,10 +315,10 @@ int snd_pcm_hw_refine(struct snd_pcm_sub
 	if (!params->info)
 		params->info = hw->info & ~SNDRV_PCM_INFO_FIFO_IN_FRAMES;
 	if (!params->fifo_size) {
-		if (snd_mask_min(&params->masks[SNDRV_PCM_HW_PARAM_FORMAT]) ==
-		    snd_mask_max(&params->masks[SNDRV_PCM_HW_PARAM_FORMAT]) &&
-                    snd_mask_min(&params->masks[SNDRV_PCM_HW_PARAM_CHANNELS]) ==
-                    snd_mask_max(&params->masks[SNDRV_PCM_HW_PARAM_CHANNELS])) {
+		m = hw_param_mask(params, SNDRV_PCM_HW_PARAM_FORMAT);
+		i = hw_param_interval(params, SNDRV_PCM_HW_PARAM_CHANNELS);
+		if (snd_mask_min(m) == snd_mask_max(m) &&
+                    snd_interval_min(i) == snd_interval_max(i)) {
 			changed = substream->ops->ioctl(substream,
 					SNDRV_PCM_IOCTL1_FIFO_SIZE, params);
 			if (changed < 0)


