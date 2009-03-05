Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbZCETPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbZCETPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:15:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756751AbZCETOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:14:34 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:42090 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbZCETOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:14:33 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH v2 04/15] NULL noise: drivers/gpu/drm/radeon/radeon_*.c
Date: Thu, 05 Mar 2009 20:14:18 +0100
Message-ID: <20090305191413.30062.67683.stgit@f10box.hanneseder.net>
In-Reply-To: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel@lists.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  drivers/gpu/drm/radeon/r600_cp.c:1811:52: warning: Using plain integer as NULL pointer
  drivers/gpu/drm/radeon/radeon_cp.c:1363:52: warning: Using plain integer as NULL pointer
  drivers/gpu/drm/radeon/radeon_state.c:1983:61: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
v2: other subject, as suggested by Al Viro

 drivers/gpu/drm/radeon/r600_cp.c      |    2 +-
 drivers/gpu/drm/radeon/radeon_cp.c    |    2 +-
 drivers/gpu/drm/radeon/radeon_state.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_cp.c b/drivers/gpu/drm/radeon/r600_cp.c
index 37249b2..2d9147d 100644
--- a/drivers/gpu/drm/radeon/r600_cp.c
+++ b/drivers/gpu/drm/radeon/r600_cp.c
@@ -1808,7 +1808,7 @@ int r600_do_cleanup_cp(struct drm_device *dev)
 
 		if (dev_priv->gart_info.gart_table_location == DRM_ATI_GART_FB) {
 			drm_core_ioremapfree(&dev_priv->gart_info.mapping, dev);
-			dev_priv->gart_info.addr = 0;
+			dev_priv->gart_info.addr = NULL;
 		}
 	}
 	/* only clear to the start of flags */
diff --git a/drivers/gpu/drm/radeon/radeon_cp.c b/drivers/gpu/drm/radeon/radeon_cp.c
index 15cfe56..0c49230 100644
--- a/drivers/gpu/drm/radeon/radeon_cp.c
+++ b/drivers/gpu/drm/radeon/radeon_cp.c
@@ -1541,7 +1541,7 @@ static int radeon_do_cleanup_cp(struct drm_device * dev)
 		if (dev_priv->gart_info.gart_table_location == DRM_ATI_GART_FB)
 		{
 			drm_core_ioremapfree(&dev_priv->gart_info.mapping, dev);
-			dev_priv->gart_info.addr = 0;
+			dev_priv->gart_info.addr = NULL;
 		}
 	}
 	/* only clear to the start of flags */
diff --git a/drivers/gpu/drm/radeon/radeon_state.c b/drivers/gpu/drm/radeon/radeon_state.c
index ca00cef..fa728ec 100644
--- a/drivers/gpu/drm/radeon/radeon_state.c
+++ b/drivers/gpu/drm/radeon/radeon_state.c
@@ -1986,7 +1986,7 @@ static int alloc_surface(drm_radeon_surface_alloc_t *new,
 
 	/* find a virtual surface */
 	for (i = 0; i < 2 * RADEON_MAX_SURFACES; i++)
-		if (dev_priv->virt_surfaces[i].file_priv == 0)
+		if (dev_priv->virt_surfaces[i].file_priv == NULL)
 			break;
 	if (i == 2 * RADEON_MAX_SURFACES) {
 		return -1;

