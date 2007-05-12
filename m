Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbXELS3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbXELS3b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbXELS3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:29:23 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:60869 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbXELS3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:29:23 -0400
Date: Sat, 12 May 2007 20:29:20 +0200 (MEST)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070512183154.17375.54599.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] usbusx2yaudio: kfree(NULL) is valid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

if (!x) kfree(x); is not needed since kfree(NULL) is valid.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with all(yes|mod|no)config on x86(|_64) & sparc(|64)
Diffed against Linus' git-tree.


diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index 0a352e4..48e9aa3 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -935,10 +935,9 @@ static struct snd_pcm_ops snd_usX2Y_pcm_ops =
  */
 static void usX2Y_audio_stream_free(struct snd_usX2Y_substream **usX2Y_substream)
 {
-	if (NULL != usX2Y_substream[SNDRV_PCM_STREAM_PLAYBACK]) {
-		kfree(usX2Y_substream[SNDRV_PCM_STREAM_PLAYBACK]);
-		usX2Y_substream[SNDRV_PCM_STREAM_PLAYBACK] = NULL;
-	}
+	kfree(usX2Y_substream[SNDRV_PCM_STREAM_PLAYBACK]);
+	usX2Y_substream[SNDRV_PCM_STREAM_PLAYBACK] = NULL;
+
 	kfree(usX2Y_substream[SNDRV_PCM_STREAM_CAPTURE]);
 	usX2Y_substream[SNDRV_PCM_STREAM_CAPTURE] = NULL;
 }
