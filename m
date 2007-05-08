Return-Path: <linux-kernel-owner+w=401wt.eu-S967460AbXEHSZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967460AbXEHSZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967084AbXEHSZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:25:29 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:56099 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966894AbXEHSZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:25:28 -0400
Message-id: <26766101783271028925@wsc.cz>
In-reply-to: <32177258712660011096@wsc.cz>
Subject: [PATCH 2/2] V4L: v4l1-compat, fix VIDIOCSPICT for non-OVERLAY
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Tue,  8 May 2007 20:25:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v4l1-compat, fix VIDIOCSPICT for non-OVERLAY

Do not return EINVAL for devices, which don't support overlay.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 637f1c324c57b002bcc94f68a1150e1ff32593c4
tree cf35d8f5990c1f335778bd85a4461c4e716daeef
parent fdc535e5e7c1b1781e903d4d21e1f657a9ac12c9
author Jiri Slaby <jirislaby@gmail.com> Sun, 06 May 2007 19:48:30 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 06 May 2007 19:48:30 +0200

 drivers/media/video/v4l1-compat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l1-compat.c b/drivers/media/video/v4l1-compat.c
index a861e15..254df73 100644
--- a/drivers/media/video/v4l1-compat.c
+++ b/drivers/media/video/v4l1-compat.c
@@ -653,8 +653,8 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 			err = drv(inode, file, VIDIOC_S_FBUF, &fbuf2);
 			if (err < 0)
 				dprintk("VIDIOCSPICT / VIDIOC_S_FBUF: %d\n",err);
-			err = 0; /* likely fails for non-root */
 		}
+		err = 0; /* G_ fails for non-OVERLAY, S_ likely for non-root */
 		break;
 	}
 	case VIDIOCGTUNER: /*  get tuner information  */
