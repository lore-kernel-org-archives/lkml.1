Return-Path: <linux-kernel-owner+w=401wt.eu-S1763498AbXHVJPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763498AbXHVJPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760424AbXHVI4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:56:44 -0400
Received: from 1wt.eu ([62.212.114.60]:2189 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760380AbXHVI4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:56:42 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084031.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:25 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Adrian Bunk <bunk@stusta.de>, "Antonino A. Daplas" <adaplas@pol.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 41/58] drivers/video/macmodes.c:mac_find_mode() mustnt be __devinit
Content-Disposition: inline; filename=0041-drivers-video-macmodes.c-mac_find_mode-mustn-t-be.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If it's EXPORT_SYMBOL'ed it can't be __devinit.

Reported by Mikael Pettersson.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/video/macmodes.c |    5 ++---
 drivers/video/macmodes.h |    8 ++++----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/video/macmodes.c b/drivers/video/macmodes.c
index ab21495..083f603 100644
--- a/drivers/video/macmodes.c
+++ b/drivers/video/macmodes.c
@@ -369,9 +369,8 @@ EXPORT_SYMBOL(mac_map_monitor_sense);
  *
  */
 
-int __devinit mac_find_mode(struct fb_var_screeninfo *var,
-			    struct fb_info *info, const char *mode_option,
-			    unsigned int default_bpp)
+int mac_find_mode(struct fb_var_screeninfo *var, struct fb_info *info,
+		  const char *mode_option, unsigned int default_bpp)
 {
     const struct fb_videomode *db = NULL;
     unsigned int dbsize = 0;
diff --git a/drivers/video/macmodes.h b/drivers/video/macmodes.h
index babeb81..b86ba08 100644
--- a/drivers/video/macmodes.h
+++ b/drivers/video/macmodes.h
@@ -55,10 +55,10 @@ extern int mac_vmode_to_var(int vmode, int cmode,
 extern int mac_var_to_vmode(const struct fb_var_screeninfo *var, int *vmode,
 			    int *cmode);
 extern int mac_map_monitor_sense(int sense);
-extern int __devinit mac_find_mode(struct fb_var_screeninfo *var,
-				   struct fb_info *info,
-				   const char *mode_option,
-				   unsigned int default_bpp);
+extern int mac_find_mode(struct fb_var_screeninfo *var,
+			 struct fb_info *info,
+			 const char *mode_option,
+			 unsigned int default_bpp);
 
 
     /*
-- 
1.5.2.5

-- 
