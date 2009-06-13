Return-Path: <linux-kernel-owner+w=401wt.eu-S1765268AbZFMA41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765268AbZFMA41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758409AbZFMAzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:55:48 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58676 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbZFMAzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:55:46 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Vivek Kutal <vivek.kutal@azingo.com>
Subject: [PATCH 3/5] fbdev: *bfin*: drop unnecessary calls to memset
Date: Fri, 12 Jun 2009 20:55:34 -0400
Message-Id: <1244854536-2367-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244854536-2367-1-git-send-email-vapier@gentoo.org>
References: <1244854536-2367-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Kutal <vivek.kutal@azingo.com>

The dma_alloc_* functions sets the memory to 0 before returning so there
is no need to call memset after the allocation.  Also no point in clearing
the memory when disabling the buffer.

Signed-off-by: Vivek Kutal <vivek.kutal@azingo.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/video/bf54x-lq043fb.c    |    3 ---
 drivers/video/bfin-t350mcqb-fb.c |    3 ---
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index 37e60b1..6439a43 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -323,7 +323,6 @@ static int bfin_bf54x_fb_release(struct fb_info *info, int user)
 		bfin_write_EPPI0_CONTROL(0);
 		SSYNC();
 		disable_dma(CH_EPPI0);
-		memset(fbi->fb_buffer, 0, info->fix.smem_len);
 	}
 
 	spin_unlock(&fbi->lock);
@@ -626,8 +625,6 @@ static int __init bfin_bf54x_probe(struct platform_device *pdev)
 		goto out3;
 	}
 
-	memset(info->fb_buffer, 0, fbinfo->fix.smem_len);
-
 	fbinfo->screen_base = (void *)info->fb_buffer;
 	fbinfo->fix.smem_start = (int)info->fb_buffer;
 
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 2a2e116..f40eef8 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -242,7 +242,6 @@ static int bfin_t350mcqb_fb_release(struct fb_info *info, int user)
 		SSYNC();
 		disable_dma(CH_PPI);
 		bfin_t350mcqb_stop_timers();
-		memset(fbi->fb_buffer, 0, info->fix.smem_len);
 	}
 
 	spin_unlock(&fbi->lock);
@@ -527,8 +526,6 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 		goto out3;
 	}
 
-	memset(info->fb_buffer, 0, fbinfo->fix.smem_len);
-
 	fbinfo->screen_base = (void *)info->fb_buffer + ACTIVE_VIDEO_MEM_OFFSET;
 	fbinfo->fix.smem_start = (int)info->fb_buffer + ACTIVE_VIDEO_MEM_OFFSET;
 
-- 
1.6.3.1

