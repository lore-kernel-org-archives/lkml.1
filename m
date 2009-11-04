Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZKDRD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZKDRD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbZKDRD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:03:26 -0500
Received: from nox.protox.org ([88.191.38.29]:56915 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983AbZKDRD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:03:26 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Fix oops when set_base is call with no FB
Date: Wed,  4 Nov 2009 20:03:19 +0100
Message-Id: <1257361399-5128-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just do nothings crct_set_base i call with no FB.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/atombios_crtc.c      |    7 +++++--
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    5 +++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index c15287a..f5987af 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -578,8 +578,11 @@ int atombios_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 	uint64_t fb_location;
 	uint32_t fb_format, fb_pitch_pixels, tiling_flags;
 
-	if (!crtc->fb)
-		return -EINVAL;
+	/* no fb bound */
+	if (!crtc->fb) {
+		DRM_DEBUG("No FB bound\n");
+		return 0;
+	}
 
 	radeon_fb = to_radeon_framebuffer(crtc->fb);
 
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
index 8d0b7aa..5794364 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -408,6 +408,11 @@ int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 	uint32_t gen_cntl_reg, gen_cntl_val;
 
 	DRM_DEBUG("\n");
+	/* no fb bound */
+	if (!crtc->fb) {
+		DRM_DEBUG("No FB bound\n");
+		return 0;
+	}
 
 	radeon_fb = to_radeon_framebuffer(crtc->fb);
 
-- 
1.6.5.1

