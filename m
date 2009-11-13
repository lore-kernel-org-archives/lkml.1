Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbZKMT4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbZKMT4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932292AbZKMT4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:56:44 -0500
Received: from nox.protox.org ([88.191.38.29]:50963 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264AbZKMT4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:36 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 1/2] drm/radeon/kms: Disable TV load detect on RS400,RC410,RS480
Date: Fri, 13 Nov 2009 20:56:35 +0100
Message-Id: <1258142195-2032-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RS400,RC410,RS480 chipset seems to report a lot of false positive
with load detect on TV output. We haven't yet found a way to make
load detect reliable on those chipset, thus just disable it for TV
output. Would avoid user to experience phantom screen because X
believe there is a monitor connected to the TV output.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_connectors.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index fce4c40..55fecfc 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1149,6 +1149,13 @@ radeon_add_legacy_connector(struct drm_device *dev,
 			if (ret)
 				goto failed;
 			radeon_connector->dac_load_detect = true;
+			/* RS400,RC410,RS480 chipset seems to report a lot
+			 * of false positive on load detect, we haven't yet
+			 * found a way to make load detect reliable on those
+			 * chipset, thus just disable it for TV.
+			 */
+			if (rdev->family == CHIP_RS400 || rdev->family == CHIP_RS480)
+				radeon_connector->dac_load_detect = false;
 			drm_connector_attach_property(&radeon_connector->base,
 						      rdev->mode_info.load_detect_property,
 						      1);
-- 
1.6.5.2

