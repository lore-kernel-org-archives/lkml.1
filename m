Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbZLGAYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbZLGAYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932800AbZLGAN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:27 -0500
Received: from kroah.org ([198.145.64.141]:34489 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758498AbZLGANU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:20 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:51 2009
Message-Id: <20091207000651.381307775@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Michael Krufky <mkrufky@linuxtv.org>
Subject: [063/119] V4L/DVB (12948): v4l1-compat: fix VIDIOC_G_STD handling
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-12948-v4l1-compat-fix-vidioc_g_std-handling.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hans Verkuil <hverkuil@xs4all.nl>

commit 707ca1e30f087f9a6d144693dafc4b67880678c2 upstream.

The VIDIOC_G_STD ioctl may not be present in the case of radio receivers.
In that case G_STD will return an error. The v4l1-compat layer should not
attempt to propagate that error to the caller, instead it should be
ignored.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/v4l1-compat.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/media/video/v4l1-compat.c
+++ b/drivers/media/video/v4l1-compat.c
@@ -565,10 +565,9 @@ static noinline long v4l1_compat_get_inp
 		break;
 	}
 	chan->norm = 0;
-	err = drv(file, VIDIOC_G_STD, &sid);
-	if (err < 0)
-		dprintk("VIDIOCGCHAN / VIDIOC_G_STD: %ld\n", err);
-	if (err == 0) {
+	/* Note: G_STD might not be present for radio receivers,
+	 * so we should ignore any errors. */
+	if (drv(file, VIDIOC_G_STD, &sid) == 0) {
 		if (sid & V4L2_STD_PAL)
 			chan->norm = VIDEO_MODE_PAL;
 		if (sid & V4L2_STD_NTSC)
@@ -777,10 +776,9 @@ static noinline long v4l1_compat_get_tun
 			tun->flags |= VIDEO_TUNER_SECAM;
 	}
 
-	err = drv(file, VIDIOC_G_STD, &sid);
-	if (err < 0)
-		dprintk("VIDIOCGTUNER / VIDIOC_G_STD: %ld\n", err);
-	if (err == 0) {
+	/* Note: G_STD might not be present for radio receivers,
+	 * so we should ignore any errors. */
+	if (drv(file, VIDIOC_G_STD, &sid) == 0) {
 		if (sid & V4L2_STD_PAL)
 			tun->mode = VIDEO_MODE_PAL;
 		if (sid & V4L2_STD_NTSC)


