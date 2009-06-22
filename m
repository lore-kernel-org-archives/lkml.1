Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbZFVQYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbZFVQYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbZFVQYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:24:24 -0400
Received: from nox.protox.org ([88.191.38.29]:59993 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbZFVQYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:24:23 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 2/2] radeon: fix driver initialization order so radeon kms can be builtin
Date: Mon, 22 Jun 2009 18:16:13 +0200
Message-Id: <1245687373-10517-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TTM need to be initialized before radeon if KMS is enabled otherwise
the kernel will crash hard.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/Makefile            |    2 +-
 drivers/gpu/drm/radeon/radeon_drv.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 4e89ab0..fe23f29 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -16,6 +16,7 @@ drm-y       :=	drm_auth.o drm_bufs.o drm_cache.o \
 drm-$(CONFIG_COMPAT) += drm_ioc32.o
 
 obj-$(CONFIG_DRM)	+= drm.o
+obj-$(CONFIG_DRM_TTM)	+= ttm/
 obj-$(CONFIG_DRM_TDFX)	+= tdfx/
 obj-$(CONFIG_DRM_R128)	+= r128/
 obj-$(CONFIG_DRM_RADEON)+= radeon/
@@ -26,4 +27,3 @@ obj-$(CONFIG_DRM_I915)  += i915/
 obj-$(CONFIG_DRM_SIS)   += sis/
 obj-$(CONFIG_DRM_SAVAGE)+= savage/
 obj-$(CONFIG_DRM_VIA)	+=via/
-obj-$(CONFIG_DRM_TTM)	+= ttm/
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 09c9fb9..84ba69f 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -345,7 +345,7 @@ static void __exit radeon_exit(void)
 	drm_exit(driver);
 }
 
-late_initcall(radeon_init);
+module_init(radeon_init);
 module_exit(radeon_exit);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
1.6.2.2

