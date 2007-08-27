Return-Path: <linux-kernel-owner+w=401wt.eu-S1763827AbXH0VS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763827AbXH0VS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbXH0VN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:13:57 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1161 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbXH0VN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:13:56 -0400
Message-Id: <20070827211350.410311000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:58:00 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 10/23] drm_sman.c: drm_calloc to drm_zalloc
Content-Disposition: inline; filename=drm_sman.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/drm_sman.c | 9108 -> 9094 (-14 bytes)
 drivers/char/drm/drm_sman.o | 104466 -> 103946 (-520 bytes)

 drivers/char/drm/drm_sman.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/drm_sman.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/drm_sman.c
@@ -130,10 +130,10 @@ drm_sman_set_range(struct drm_sman * sma
 	BUG_ON(manager >= sman->num_managers);

 	sman_mm = &sman->mm[manager];
-	mm = drm_calloc(1, sizeof(*mm), DRM_MEM_MM);
-	if (!mm) {
+	mm = drm_zalloc(sizeof(*mm), DRM_MEM_MM);
+	if (!mm)
 		return -ENOMEM;
-	}
+
 	sman_mm->private = mm;
 	ret = drm_mm_init(mm, start, size);

@@ -176,7 +176,7 @@ static struct drm_owner_item *drm_sman_g
 				      owner_hash);
 	}

-	owner_item = drm_calloc(1, sizeof(*owner_item), DRM_MEM_MM);
+	owner_item = drm_zalloc(sizeof(*owner_item), DRM_MEM_MM);
 	if (!owner_item)
 		goto out;

@@ -212,8 +212,7 @@ struct drm_memblock_item *drm_sman_alloc
 		return NULL;
 	}

-	memblock = drm_calloc(1, sizeof(*memblock), DRM_MEM_MM);
-
+	memblock = drm_zalloc(sizeof(*memblock), DRM_MEM_MM);
 	if (!memblock)
 		goto out;

--
