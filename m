Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891Ab0AFQjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0AFQjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184Ab0AFQje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:39:34 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:33641 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab0AFQje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:39:34 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: airlied@linux.ie
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: [PATCH 1/1] GPU: radeon, fix memory leak
Date: Wed,  6 Jan 2010 17:39:31 +0100
Message-Id: <1262795971-15724-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a memory leak in radeon_master_create. master_priv is not
freed/assigned on all paths. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/radeon_cp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cp.c b/drivers/gpu/drm/radeon/radeon_cp.c
index 0b2f9c2..06123ba 100644
--- a/drivers/gpu/drm/radeon/radeon_cp.c
+++ b/drivers/gpu/drm/radeon/radeon_cp.c
@@ -2145,6 +2145,7 @@ int radeon_master_create(struct drm_device *dev, struct drm_master *master)
 			 &master_priv->sarea);
 	if (ret) {
 		DRM_ERROR("SAREA setup failed\n");
+		kfree(master_priv);
 		return ret;
 	}
 	master_priv->sarea_priv = master_priv->sarea->handle + sizeof(struct drm_sarea);
-- 
1.6.5.7

