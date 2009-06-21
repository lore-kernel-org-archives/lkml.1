Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZFUSf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZFUSf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 14:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZFUSfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 14:35:15 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:41981 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZFUSfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 14:35:14 -0400
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Jun 2009 14:35:14 EDT
Date: Sun, 21 Jun 2009 20:26:59 +0200
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] sound: fix check for return value in snd_pcm_hw_refine
Message-ID: <20090621202659.76ae16e8@mako-desktop>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

'params' is a pointer and looking at the code this probably should be a check
for ioctl return value.

	Mariusz


Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 84da3ba..ac2150e 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -320,7 +320,7 @@ int snd_pcm_hw_refine(struct snd_pcm_substream *substream,
                     snd_mask_max(&params->masks[SNDRV_PCM_HW_PARAM_CHANNELS])) {
 			changed = substream->ops->ioctl(substream,
 					SNDRV_PCM_IOCTL1_FIFO_SIZE, params);
-			if (params < 0)
+			if (changed < 0)
 				return changed;
 		}
 	}
