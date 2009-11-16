Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZKPESz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZKPESz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZKPESy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:18:54 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56872 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZKPESm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:18:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ITXk2nFwPykK/LH2qHk1dAfPa1N2EeqScm7itPOT7skUpqZd1zGGtBz4QTKAS8NYiX
         EOLj+aXZrTlxtKbSHfGLPnJwg43ySLvzmvWoSQ9PnrmYJEpSOY1tz8FslgYJ+AtkQDgh
         lOiUd/nbncir/6lv6Wv4t48lB8UBXxHjNtg0U=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 04/13] staging: line6: Fix checkpatch errors in capture.c
Date: Sun, 15 Nov 2009 22:17:53 -0600
Message-Id: <1258345082-11811-5-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
References: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 drivers/staging/line6/capture.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/line6/capture.c b/drivers/staging/line6/capture.c
index 7009f39..fd4890d 100644
--- a/drivers/staging/line6/capture.c
+++ b/drivers/staging/line6/capture.c
@@ -219,8 +219,8 @@ static void audio_in_callback(struct urb *urb)
 				       fbuf, fsize * bytes_per_frame);
 			}
 
-			if ((line6pcm->pos_in_done +=
-			     frames) >= runtime->buffer_size)
+			line6pcm->pos_in_done += frames;
+			if (line6pcm->pos_in_done >= runtime->buffer_size)
 				line6pcm->pos_in_done -= runtime->buffer_size;
 		}
 	}
@@ -235,7 +235,8 @@ static void audio_in_callback(struct urb *urb)
 	if (!shutdown) {
 		submit_audio_in_urb(substream);
 
-		if ((line6pcm->bytes_in += length) >= line6pcm->period_in) {
+		line6pcm->bytes_in += length;
+		if (line6pcm->bytes_in >= line6pcm->period_in) {
 			line6pcm->bytes_in -= line6pcm->period_in;
 			snd_pcm_period_elapsed(substream);
 		}
-- 
1.6.5

