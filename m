Return-Path: <linux-kernel-owner+w=401wt.eu-S1763287AbXGWIB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763287AbXGWIB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760373AbXGWIB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:01:26 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41696 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760133AbXGWIBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:01:25 -0400
Date: Mon, 23 Jul 2007 10:00:51 +0200
From: Adrian Bunk <bunk@stusta.de>
To: airlied@linux.ie
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drm_rmmap_ioctl(): remove dead code
Message-ID: <20070723080051.GA26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some obviously dead code spotted by the Coverity 
checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/drivers/char/drm/drm_bufs.c.old	2007-07-23 01:09:04.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/char/drm/drm_bufs.c	2007-07-23 01:09:22.000000000 +0200
@@ -476,15 +476,10 @@ int drm_rmmap_ioctl(struct inode *inode,
 	if (list_empty(&dev->maplist) || !map) {
 		mutex_unlock(&dev->struct_mutex);
 		return -EINVAL;
 	}
 
-	if (!map) {
-		mutex_unlock(&dev->struct_mutex);
-		return -EINVAL;
-	}
-
 	/* Register and framebuffer maps are permanent */
 	if ((map->type == _DRM_REGISTERS) || (map->type == _DRM_FRAME_BUFFER)) {
 		mutex_unlock(&dev->struct_mutex);
 		return 0;
 	}

