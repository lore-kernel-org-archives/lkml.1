Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbZKJTOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbZKJTOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbZKJTOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:14:43 -0500
Received: from nox.protox.org ([88.191.38.29]:34807 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbZKJTOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:14:42 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: disable load detection on TV output
Date: Tue, 10 Nov 2009 20:14:43 +0100
Message-Id: <1257880483-21478-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do like in the DDX don't try to load detect TV output, there is a lot
of false positive detection with those code. Seems to be isolated to
RS480/RC410 chipset thought. Need more investigations.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_connectors.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index fce4c40..292b170 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1015,7 +1015,7 @@ radeon_add_atom_connector(struct drm_device *dev,
 			ret = drm_connector_helper_add(&radeon_connector->base, &radeon_tv_connector_helper_funcs);
 			if (ret)
 				goto failed;
-			radeon_connector->dac_load_detect = true;
+			radeon_connector->dac_load_detect = false;
 			drm_connector_attach_property(&radeon_connector->base,
 						      rdev->mode_info.load_detect_property,
 						      1);
@@ -1148,7 +1148,7 @@ radeon_add_legacy_connector(struct drm_device *dev,
 			ret = drm_connector_helper_add(&radeon_connector->base, &radeon_tv_connector_helper_funcs);
 			if (ret)
 				goto failed;
-			radeon_connector->dac_load_detect = true;
+			radeon_connector->dac_load_detect = false;
 			drm_connector_attach_property(&radeon_connector->base,
 						      rdev->mode_info.load_detect_property,
 						      1);
-- 
1.6.5.2

