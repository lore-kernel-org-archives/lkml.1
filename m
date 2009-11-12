Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbZKLK6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbZKLK6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 05:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbZKLK6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 05:58:35 -0500
Received: from nox.protox.org ([88.191.38.29]:46960 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbZKLK6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 05:58:35 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: (V2) Add default 800x600 mode when getting bad EDID
Date: Thu, 12 Nov 2009 11:58:35 +0100
Message-Id: <1258023515-4726-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding default 800x600 mode should be a safe fail solution in front
of broken EDID, user can then add new mode to fit its needs.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_connectors.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 292b170..ecdcf68 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -566,8 +566,8 @@ static enum drm_connector_status radeon_vga_detect(struct drm_connector *connect
 		radeon_i2c_do_lock(radeon_connector, 0);
 
 		if (!radeon_connector->edid) {
-			DRM_ERROR("DDC responded but not EDID found for %s\n",
-				  drm_get_connector_name(connector));
+			DRM_ERROR("Probed a monitor but no|invalid EDID\n");
+			ret = connector_status_connected;
 		} else {
 			radeon_connector->use_digital = !!(radeon_connector->edid->input & DRM_EDID_INPUT_DIGITAL);
 
@@ -720,8 +720,7 @@ static enum drm_connector_status radeon_dvi_detect(struct drm_connector *connect
 		radeon_i2c_do_lock(radeon_connector, 0);
 
 		if (!radeon_connector->edid) {
-			DRM_ERROR("DDC responded but not EDID found for %s\n",
-				  drm_get_connector_name(connector));
+			DRM_ERROR("Probed a monitor but no|invalid EDID\n");
 		} else {
 			radeon_connector->use_digital = !!(radeon_connector->edid->input & DRM_EDID_INPUT_DIGITAL);
 
-- 
1.6.5.2

