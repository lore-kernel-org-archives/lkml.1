Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbYEKT7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbYEKT7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYEKT70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:59:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:41336 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbYEKT7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:59:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=J5ROopizyORVddMOi6TwMwsiMlGL/T8ULc03BtE0vJWBEmPa5WAq9hvfBLrg2alQPSjW3/wVFDvWm7sygdoscR3aFziuQFO/h8Rmo+vRtWmo6UshOnCNBzBuUYAdqkE/L5mNuP55nZLvAWrcd9VP+d2K/GIg3lil/rbRfMfA+oQ=
Date: Sun, 11 May 2008 21:58:59 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] v4l: check_v4l2 should return -EINVAL on error
Message-ID: <20080511195855.GG19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_v4l2 always returns 0, so this change is an noop for now,
but a comment says it will return something else in the future

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
compile tested only
---
 drivers/media/video/tuner-core.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -795,7 +795,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 	case VIDIOCSAUDIO:
 		if (check_mode(t, "VIDIOCSAUDIO") == -EINVAL)
 			return 0;
-		if (check_v4l2(t) == EINVAL)
+		if (check_v4l2(t) == -EINVAL)
 			return 0;
 
 		/* Should be implemented, since bttv calls it */
@@ -813,7 +813,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 			};
 			struct video_channel *vc = arg;
 
-			if (check_v4l2(t) == EINVAL)
+			if (check_v4l2(t) == -EINVAL)
 				return 0;
 
 			if (set_mode(client,t,V4L2_TUNER_ANALOG_TV, "VIDIOCSCHAN")==-EINVAL)
@@ -832,7 +832,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 
 			if (check_mode(t, "VIDIOCSFREQ") == -EINVAL)
 				return 0;
-			if (check_v4l2(t) == EINVAL)
+			if (check_v4l2(t) == -EINVAL)
 				return 0;
 
 			set_freq(client, *v);
@@ -844,7 +844,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 
 			if (check_mode(t, "VIDIOCGTUNER") == -EINVAL)
 				return 0;
-			if (check_v4l2(t) == EINVAL)
+			if (check_v4l2(t) == -EINVAL)
 				return 0;
 
 			if (V4L2_TUNER_RADIO == t->mode) {
@@ -888,7 +888,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 
 			if (check_mode(t, "VIDIOCGAUDIO") == -EINVAL)
 				return 0;
-			if (check_v4l2(t) == EINVAL)
+			if (check_v4l2(t) == -EINVAL)
 				return 0;
 
 			if (V4L2_TUNER_RADIO == t->mode) {
-- 
