Return-Path: <linux-kernel-owner+w=401wt.eu-S964874AbZLQBgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964874AbZLQBgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763633AbZLQBUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:31 -0500
Received: from kroah.org ([198.145.64.141]:47925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763575AbZLQBUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:20 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:02 2009
Message-Id: <20091217011602.713264453@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [37/90] drm/radeon/kms: fix legacy crtc2 dpms
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 8de21525439e6b5bb8d8c81e49094d867bf82f6d upstream.

noticed by Matthijs Kooijman on fdo bug 22140

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -291,8 +291,7 @@ void radeon_crtc_dpms(struct drm_crtc *c
 	uint32_t mask;
 
 	if (radeon_crtc->crtc_id)
-		mask = (RADEON_CRTC2_EN |
-			RADEON_CRTC2_DISP_DIS |
+		mask = (RADEON_CRTC2_DISP_DIS |
 			RADEON_CRTC2_VSYNC_DIS |
 			RADEON_CRTC2_HSYNC_DIS |
 			RADEON_CRTC2_DISP_REQ_EN_B);
@@ -304,7 +303,7 @@ void radeon_crtc_dpms(struct drm_crtc *c
 	switch (mode) {
 	case DRM_MODE_DPMS_ON:
 		if (radeon_crtc->crtc_id)
-			WREG32_P(RADEON_CRTC2_GEN_CNTL, RADEON_CRTC2_EN, ~mask);
+			WREG32_P(RADEON_CRTC2_GEN_CNTL, RADEON_CRTC2_EN, ~(RADEON_CRTC2_EN | mask));
 		else {
 			WREG32_P(RADEON_CRTC_GEN_CNTL, RADEON_CRTC_EN, ~(RADEON_CRTC_EN |
 									 RADEON_CRTC_DISP_REQ_EN_B));
@@ -318,7 +317,7 @@ void radeon_crtc_dpms(struct drm_crtc *c
 	case DRM_MODE_DPMS_OFF:
 		drm_vblank_pre_modeset(dev, radeon_crtc->crtc_id);
 		if (radeon_crtc->crtc_id)
-			WREG32_P(RADEON_CRTC2_GEN_CNTL, mask, ~mask);
+			WREG32_P(RADEON_CRTC2_GEN_CNTL, mask, ~(RADEON_CRTC2_EN | mask));
 		else {
 			WREG32_P(RADEON_CRTC_GEN_CNTL, RADEON_CRTC_DISP_REQ_EN_B, ~(RADEON_CRTC_EN |
 										    RADEON_CRTC_DISP_REQ_EN_B));


