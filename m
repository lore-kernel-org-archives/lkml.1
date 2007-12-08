Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbXLHUkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbXLHUkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXLHUke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:40:34 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:34846 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbXLHUkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:40:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=JeCh5OMCiOwu5T7o6P0pYDurvgAJ5Jv0X3bMEhiODTgWhRkCYyPKO396O5istPHbwUnXq467num3z9OkATPMyhMGAHJurIcybVwwd73b5SuZJv5DlV6XgG/OBizsn7tgWuQIeMfmz226XuGPQDhrTDQVvV6sZTo6XgFCkD4biQs=
Date: Sat, 8 Dec 2007 21:41:36 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: perex@perex.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pcm_lib: fix sparse warning about shadowing 'n' symbol
Message-ID: <20071208204126.GC5087@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcm_lib: fix sparse warning about shadowing 'n' symbol

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 sound/core/pcm_lib.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 806f1fb..653fb5c 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1497,14 +1497,14 @@ void snd_pcm_tick_prepare(struct snd_pcm_substream *substream)
 		avail = snd_pcm_capture_avail(runtime);
 	}
 	if (avail < runtime->control->avail_min) {
-		snd_pcm_sframes_t n = runtime->control->avail_min - avail;
-		if (n > 0 && frames > (snd_pcm_uframes_t)n)
-			frames = n;
+		snd_pcm_sframes_t to_avail_min = runtime->control->avail_min - avail;
+		if (to_avail_min > 0 && frames > (snd_pcm_uframes_t)to_avail_min)
+			frames = to_avail_min;
 	}
 	if (avail < runtime->buffer_size) {
-		snd_pcm_sframes_t n = runtime->buffer_size - avail;
-		if (n > 0 && frames > (snd_pcm_uframes_t)n)
-			frames = n;
+		snd_pcm_sframes_t to_buffer_size = runtime->buffer_size - avail;
+		if (to_buffer_size > 0 && frames > (snd_pcm_uframes_t)to_buffer_size)
+			frames = to_buffer_size;
 	}
 	if (frames == ULONG_MAX) {
 		snd_pcm_tick_set(substream, 0);
