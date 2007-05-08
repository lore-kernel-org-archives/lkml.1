Return-Path: <linux-kernel-owner+w=401wt.eu-S1030346AbXEHSYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030346AbXEHSYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966894AbXEHSYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:24:50 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:56086 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967143AbXEHSYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:24:49 -0400
Message-id: <32177258712660011096@wsc.cz>
Subject: [PATCH 1/2] V4L: videodev, allow VIDIOCGMBUF
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Tue,  8 May 2007 20:24:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

videodev, allow VIDIOCGMBUF

this is 'v' compat ioctl handled in v4l2

Cc: Mauro Carvalho Chehab <video4linux-list@redhat.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit fdc535e5e7c1b1781e903d4d21e1f657a9ac12c9
tree 8beb32a89d2679b14577762ebec8fb3c1e81fcaf
parent 94b6ccaf1ca50632014202d3eeb99a0e23185ddb
author Jiri Slaby <jirislaby@gmail.com> Sat, 05 May 2007 17:47:31 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 05 May 2007 17:47:31 +0200

 drivers/media/video/videodev.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videodev.c b/drivers/media/video/videodev.c
index a3cef80..099ad99 100644
--- a/drivers/media/video/videodev.c
+++ b/drivers/media/video/videodev.c
@@ -438,7 +438,10 @@ static int __video_do_ioctl(struct inode *inode, struct file *file,
 	}
 
 	if (_IOC_TYPE(cmd)=='v')
-		return v4l_compat_translate_ioctl(inode,file,cmd,arg,
+#ifdef CONFIG_VIDEO_V4L1_COMPAT
+		if (cmd != VIDIOCGMBUF) /* <-- handled below vvv */
+#endif
+			return v4l_compat_translate_ioctl(inode,file,cmd,arg,
 						__video_do_ioctl);
 
 	switch(cmd) {
