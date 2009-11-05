Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbZKEOng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbZKEOng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbZKEOng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:43:36 -0500
Received: from nox.protox.org ([88.191.38.29]:35728 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757775AbZKEOnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:43:35 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org, thomas@shipmail.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/ttm: Dead code elimination & comment addition
Date: Thu,  5 Nov 2009 15:43:35 +0100
Message-Id: <1257432215-6146-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dead code in ttm_bo_handle_mem_move and add comment on
what we are doing their and why.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_bo.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 87c0625..aea4699 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -309,9 +309,8 @@ static int ttm_bo_handle_move_mem(struct ttm_buffer_object *bo,
 		ttm_bo_unmap_virtual(bo);
 
 	/*
-	 * Create and bind a ttm if required.
+	 * Create and bind a ttm if new placement is not on card memory.
 	 */
-
 	if (!(new_man->flags & TTM_MEMTYPE_FLAG_FIXED) && (bo->ttm == NULL)) {
 		ret = ttm_bo_add_ttm(bo, false);
 		if (ret)
@@ -327,15 +326,12 @@ static int ttm_bo_handle_move_mem(struct ttm_buffer_object *bo,
 				goto out_err;
 		}
 
+		/* New placement is not on card and old placement is system
+		 * memory we can thus simply copy new placement informations
+		 */
 		if (bo->mem.mem_type == TTM_PL_SYSTEM) {
-
-			struct ttm_mem_reg *old_mem = &bo->mem;
-			uint32_t save_flags = old_mem->placement;
-
-			*old_mem = *mem;
+			bo->mem = *mem;
 			mem->mm_node = NULL;
-			ttm_flag_masked(&save_flags, mem->placement,
-					TTM_PL_MASK_MEMTYPE);
 			goto moved;
 		}
 
-- 
1.6.5.1

