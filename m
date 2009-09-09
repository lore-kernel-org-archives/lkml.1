Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbZIIU32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbZIIU32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZIIU31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:29:27 -0400
Received: from nox.protox.org ([88.191.38.29]:52610 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbZIIU31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:29:27 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2009 16:29:27 EDT
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: call r100_cp_disable rather than duplicating code.
Date: Wed,  9 Sep 2009 22:23:27 +0200
Message-Id: <1252527807-2241-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

r100_cp_fini was duplicating code of r100_cp_disable, call r100_cp_disable
instead.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r100.c   |    3 +--
 drivers/gpu/drm/radeon/radeon.h |    3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 36d0ba2..4ceb675 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -719,8 +719,7 @@ int r100_cp_init(struct radeon_device *rdev, unsigned ring_size)
 void r100_cp_fini(struct radeon_device *rdev)
 {
 	/* Disable ring */
-	rdev->cp.ready = false;
-	WREG32(RADEON_CP_CSQ_CNTL, 0);
+	r100_cp_disable(rdev);
 	radeon_ring_fini(rdev);
 	DRM_INFO("radeon: cp finalized\n");
 }
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 3299733..24574bc 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -933,4 +933,7 @@ static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
 #define radeon_clear_surface_reg(rdev, r) ((rdev)->asic->clear_surface_reg((rdev), (r)))
 #define radeon_bandwidth_update(rdev) (rdev)->asic->bandwidth_update((rdev))
 
+/* r100,rv100,rs100,rv200,rs200,r200,rv250,rs300,rv280 */
+void r100_cp_disable(struct radeon_device *rdev);
+
 #endif
-- 
1.6.4.1

