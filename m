Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZKAVsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZKAVsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZKAVsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:48:12 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:11103 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZKAVsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:48:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qbkR4taU63wWbMzzzZo8kcWBYkCfF+q4zqgkq8p6texai59vvr2+WkppuuABGb4AqP
         Bna5zGLGjAqER/0tTFl3RghfJgNYBmMoDh42X/cPsRqhPc7B9Wg4Ny6P3Cuet9WtLlnl
         Ry8rVUsS7d0h/onwu8PEXqWllZt+ITsJzemxI=
From: Thiago Farina <tfransosi@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH] trivial: Make use of ARRAY_SIZE.
Date: Sun,  1 Nov 2009 16:47:35 -0500
Message-Id: <1257112055-14011-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.5.1.61.ge79999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the usage of DBE_VT_SIZE since the kernel already defines the
same macro for the same propose.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/video/sgivwfb.c |    4 ++--
 include/video/sgivw.h   |   11 +++++------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/video/sgivwfb.c b/drivers/video/sgivwfb.c
index bba5371..f860122 100644
--- a/drivers/video/sgivwfb.c
+++ b/drivers/video/sgivwfb.c
@@ -260,13 +260,13 @@ static int sgivwfb_check_var(struct fb_var_screeninfo *var,
 	var->grayscale = 0;	/* No grayscale for now */
 
 	/* determine valid resolution and timing */
-	for (min_mode = 0; min_mode < DBE_VT_SIZE; min_mode++) {
+	for (min_mode = 0; min_mode < ARRAY_SIZE(dbeVTimings); min_mode++) {
 		if (dbeVTimings[min_mode].width >= var->xres &&
 		    dbeVTimings[min_mode].height >= var->yres)
 			break;
 	}
 
-	if (min_mode == DBE_VT_SIZE)
+	if (min_mode == ARRAY_SIZE(dbeVTimings))
 		return -EINVAL;	/* Resolution to high */
 
 	/* XXX FIXME - should try to pick best refresh rate */
diff --git a/include/video/sgivw.h b/include/video/sgivw.h
index 55f2a7c..f6aa569 100644
--- a/include/video/sgivw.h
+++ b/include/video/sgivw.h
@@ -351,7 +351,7 @@ typedef enum {
 struct dbe_timing_info
 {
   dbe_timing_t type;
-  int flags;				
+  int flags;
   short width;		    /* Monitor resolution		*/
   short height;
   int fields_sec;	    /* fields/sec  (Hz -3 dec. places */
@@ -389,11 +389,11 @@ struct dbe_timing_info dbeVTimings[] = {
   {
     DBE_VT_640_480_60,
     /*	flags,	width,			height,		fields_sec,		cfreq */
-    0,  	640,			480,		59940,			25175,
+    0,	        640,			480,		59940,			25175,
     /*	htotal,	hblank_start,	hblank_end,	hsync_start,	hsync_end */
-    800,	640,		    800,		656,	    	752,
+    800,	640,		        800,		656,		752,
     /*	vtotal,	vblank_start,	vblank_end,	vsync_start,	vsync_end */
-    525,	480,		    525,		490,		    492,
+    525,	480,		        525,		490,		    492,
     /*	pll_m,	pll_n,			pll_p */
     15,	    2,				3
   },
@@ -650,7 +650,7 @@ struct dbe_timing_info dbeVTimings[] = {
     /* pll_m,  pll_n,          pll_p */
     6,      1,              0
   },
-	
+
   {
     DBE_VT_1920_1200_60,
     /* flags,  width,          height,         fields_sec,     cfreq */
@@ -676,7 +676,6 @@ struct dbe_timing_info dbeVTimings[] = {
   }
 };
 
-#define DBE_VT_SIZE  (sizeof(dbeVTimings)/sizeof(dbeVTimings[0]))
 #endif // INCLUDE_TIMING_TABLE_DATA
 
 #endif // ! __SGIVWFB_H__
-- 
1.6.5.1.61.ge79999

