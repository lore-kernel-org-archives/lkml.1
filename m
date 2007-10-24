Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbXJXQXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbXJXQXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbXJXQWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:22:43 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33282 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753927AbXJXQWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:22:40 -0400
Date: Wed, 24 Oct 2007 18:23:09 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make drm_sg_alloc() static
Message-ID: <20071024162309.GG30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drm_sg_alloc() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/char/drm/drmP.h        |    1 -
 drivers/char/drm/drm_scatter.c |    5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

20df9d65e0cd1dc699129787b2c4b02a010b1bcc 
diff --git a/drivers/char/drm/drmP.h b/drivers/char/drm/drmP.h
index 9dd0760..98395c1 100644
--- a/drivers/char/drm/drmP.h
+++ b/drivers/char/drm/drmP.h
@@ -1047,7 +1047,6 @@ extern int drm_proc_cleanup(int minor,
 extern void drm_sg_cleanup(struct drm_sg_mem * entry);
 extern int drm_sg_alloc_ioctl(struct drm_device *dev, void *data,
 			struct drm_file *file_priv);
-extern int drm_sg_alloc(struct drm_device *dev, struct drm_scatter_gather * request);
 extern int drm_sg_free(struct drm_device *dev, void *data,
 		       struct drm_file *file_priv);
 
diff --git a/drivers/char/drm/drm_scatter.c b/drivers/char/drm/drm_scatter.c
index eb7fa43..4444489 100644
--- a/drivers/char/drm/drm_scatter.c
+++ b/drivers/char/drm/drm_scatter.c
@@ -62,7 +62,8 @@ void drm_sg_cleanup(struct drm_sg_mem * entry)
 # define ScatterHandle(x) (unsigned int)(x)
 #endif
 
-int drm_sg_alloc(struct drm_device *dev, struct drm_scatter_gather * request)
+static int drm_sg_alloc(struct drm_device *dev,
+			struct drm_scatter_gather * request)
 {
 	struct drm_sg_mem *entry;
 	unsigned long pages, i, j;
@@ -183,8 +184,6 @@ int drm_sg_alloc(struct drm_device *dev, struct drm_scatter_gather * request)
 	drm_sg_cleanup(entry);
 	return -ENOMEM;
 }
-EXPORT_SYMBOL(drm_sg_alloc);
-
 
 int drm_sg_alloc_ioctl(struct drm_device *dev, void *data,
 		       struct drm_file *file_priv)

