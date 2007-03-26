Return-Path: <linux-kernel-owner+w=401wt.eu-S933580AbXCZEJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbXCZEJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 00:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933571AbXCZEJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 00:09:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34528 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933567AbXCZEJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 00:09:17 -0400
Date: Mon, 26 Mar 2007 06:09:21 +0200
From: Adrian Bunk <bunk@stusta.de>
To: thomas@winischhofer.net
Cc: linux-kernel@vger.kernel.org, adaplas@gmail.com
Subject: [RFC: 2.6 patch] sisfb_get_fix(): remove the unused second parameter
Message-ID: <20070326040921.GB16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Most likely this patch isn't correct but points to a bug.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/video/sis/sis_main.c |   11 ++++-------
 drivers/video/sis/sis_main.h |    4 ++--
 2 files changed, 6 insertions(+), 9 deletions(-)

--- linux-2.6.21-rc4-mm1/drivers/video/sis/sis_main.h.old	2007-03-26 00:26:53.000000000 +0200
+++ linux-2.6.21-rc4-mm1/drivers/video/sis/sis_main.h	2007-03-26 00:27:10.000000000 +0200
@@ -672,8 +672,8 @@
 SISINITSTATIC int sisfb_init(void);
 
 /* fbdev routines */
-static int	sisfb_get_fix(struct fb_fix_screeninfo *fix, int con,
-				struct fb_info *info);
+static int	sisfb_get_fix(struct fb_fix_screeninfo *fix,
+			      struct fb_info *info);
 
 static int	sisfb_ioctl(struct fb_info *info, unsigned int cmd,
 			    unsigned long arg);
--- linux-2.6.21-rc4-mm1/drivers/video/sis/sis_main.c.old	2007-03-26 00:25:33.000000000 +0200
+++ linux-2.6.21-rc4-mm1/drivers/video/sis/sis_main.c	2007-03-26 00:26:35.000000000 +0200
@@ -1430,11 +1430,8 @@
 	if((err = sisfb_do_set_var(&info->var, 1, info)))
 		return err;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,10)
-	sisfb_get_fix(&info->fix, info->currcon, info);
-#else
-	sisfb_get_fix(&info->fix, -1, info);
-#endif
+	sisfb_get_fix(&info->fix, info);
+
 	return 0;
 }
 
@@ -1853,7 +1850,7 @@
 }
 
 static int
-sisfb_get_fix(struct fb_fix_screeninfo *fix, int con, struct fb_info *info)
+sisfb_get_fix(struct fb_fix_screeninfo *fix, struct fb_info *info)
 {
 	struct sis_video_info *ivideo = (struct sis_video_info *)info->par;
 
@@ -6386,7 +6383,7 @@
 		sis_fb_info->fix = ivideo->sisfb_fix;
 		sis_fb_info->screen_base = ivideo->video_vbase + ivideo->video_offset;
 		sis_fb_info->fbops = &sisfb_ops;
-		sisfb_get_fix(&sis_fb_info->fix, -1, sis_fb_info);
+		sisfb_get_fix(&sis_fb_info->fix, sis_fb_info);
 		sis_fb_info->pseudo_palette = ivideo->pseudo_palette;
 
 		fb_alloc_cmap(&sis_fb_info->cmap, 256 , 0);

