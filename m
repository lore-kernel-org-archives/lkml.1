Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZBVAB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZBVAB6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZBVABs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:01:48 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:51192 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbZBVABr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:01:47 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 03/16] drm: radeon: fix sparse warnings: Using plain integer
	as NULL pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:01:42 +0100
Message-ID: <20090222000122.17557.75097.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  drivers/gpu/drm/radeon/radeon_cp.c:1363:52: warning: Using plain integer as NULL pointer
  drivers/gpu/drm/radeon/radeon_state.c:1983:61: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/gpu/drm/radeon/radeon_cp.c    |    2 +-
 drivers/gpu/drm/radeon/radeon_state.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cp.c b/drivers/gpu/drm/radeon/radeon_cp.c
index 119e642..f5f4e96 100644
--- a/drivers/gpu/drm/radeon/radeon_cp.c
+++ b/drivers/gpu/drm/radeon/radeon_cp.c
@@ -1360,7 +1360,7 @@ static int radeon_do_cleanup_cp(struct drm_device * dev)
 		if (dev_priv->gart_info.gart_table_location == DRM_ATI_GART_FB)
 		{
 			drm_core_ioremapfree(&dev_priv->gart_info.mapping, dev);
-			dev_priv->gart_info.addr = 0;
+			dev_priv->gart_info.addr = NULL;
 		}
 	}
 	/* only clear to the start of flags */
diff --git a/drivers/gpu/drm/radeon/radeon_state.c b/drivers/gpu/drm/radeon/radeon_state.c
index 043293a..61e75bc 100644
--- a/drivers/gpu/drm/radeon/radeon_state.c
+++ b/drivers/gpu/drm/radeon/radeon_state.c
@@ -1980,7 +1980,7 @@ static int alloc_surface(drm_radeon_surface_alloc_t *new,
 
 	/* find a virtual surface */
 	for (i = 0; i < 2 * RADEON_MAX_SURFACES; i++)
-		if (dev_priv->virt_surfaces[i].file_priv == 0)
+		if (dev_priv->virt_surfaces[i].file_priv == NULL)
 			break;
 	if (i == 2 * RADEON_MAX_SURFACES) {
 		return -1;

