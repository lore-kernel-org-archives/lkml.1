Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbZKPEVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbZKPEVJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZKPEVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:21:07 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:64232 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZKPESg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:18:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u4GeRvrVUVqPxJ3P6lbJgrT0EhDbNaCRrTgB/tGbqV3ncUnwvlqIx2H0lvKqHJlWjr
         IoEcNobV/BCZLegHRwYZ2T02p2hEHRhlQmQ01aH/YzPfS5vthrWPllkju0PtcQ8DEoUT
         hToCd0XYG1NunKmkpi4v3VTnz+ZtY0H9cP4Vs=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 02/13] staging: line6: Fix checkpatch errors in playback.c
Date: Sun, 15 Nov 2009 22:17:51 -0600
Message-Id: <1258345082-11811-3-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
References: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 drivers/staging/line6/playback.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/line6/playback.c b/drivers/staging/line6/playback.c
index 4192cd9..3431f5c 100644
--- a/drivers/staging/line6/playback.c
+++ b/drivers/staging/line6/playback.c
@@ -138,7 +138,8 @@ static int submit_audio_out_urb(struct snd_pcm_substream *substream)
 		}
 	}
 
-	if ((line6pcm->pos_out += urb_frames) >= runtime->buffer_size)
+	line6pcm->pos_out += urb_frames;
+	if (line6pcm->pos_out >= runtime->buffer_size)
 		line6pcm->pos_out -= runtime->buffer_size;
 
 	urb_out->transfer_buffer_length = urb_size;
@@ -281,7 +282,8 @@ static void audio_out_callback(struct urb *urb)
 	if (!shutdown) {
 		submit_audio_out_urb(substream);
 
-		if ((line6pcm->bytes_out += length) >= line6pcm->period_out) {
+		line6pcm->bytes_out += length;
+		if (line6pcm->bytes_out >= line6pcm->period_out) {
 			line6pcm->bytes_out -= line6pcm->period_out;
 			snd_pcm_period_elapsed(substream);
 		}
-- 
1.6.5

