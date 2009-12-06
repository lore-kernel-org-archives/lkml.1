Return-Path: <linux-kernel-owner+w=401wt.eu-S934210AbZLFUrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934210AbZLFUrM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757760AbZLFUqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:46:49 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:60047 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757851AbZLFUqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:46:31 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: airlied@redhat.com, Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 4/5] drm/ttm: Export symbols needed for the vmwgfx driver.
Date: Sun,  6 Dec 2009 21:46:27 +0100
Message-Id: <1260132388-28414-5-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.5.3.2
In-Reply-To: <1260132388-28414-4-git-send-email-thellstrom@vmware.com>
References: <1260132388-28414-1-git-send-email-thellstrom@vmware.com>
 <1260132388-28414-2-git-send-email-thellstrom@vmware.com>
 <1260132388-28414-3-git-send-email-thellstrom@vmware.com>
 <1260132388-28414-4-git-send-email-thellstrom@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c |    1 +
 drivers/gpu/drm/ttm/ttm_memory.c  |    3 +++
 drivers/gpu/drm/ttm/ttm_tt.c      |    1 +
 include/drm/ttm/ttm_bo_driver.h   |    9 +++++++++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index c70927e..ceae52f 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -369,6 +369,7 @@ pgprot_t ttm_io_prot(uint32_t caching_flags, pgprot_t tmp)
 #endif
 	return tmp;
 }
+EXPORT_SYMBOL(ttm_io_prot);
 
 static int ttm_bo_ioremap(struct ttm_buffer_object *bo,
 			  unsigned long bus_base,
diff --git a/drivers/gpu/drm/ttm/ttm_memory.c b/drivers/gpu/drm/ttm/ttm_memory.c
index 072c281..716d0ed 100644
--- a/drivers/gpu/drm/ttm/ttm_memory.c
+++ b/drivers/gpu/drm/ttm/ttm_memory.c
@@ -460,6 +460,7 @@ void ttm_mem_global_free(struct ttm_mem_global *glob,
 {
 	return ttm_mem_global_free_zone(glob, NULL, amount);
 }
+EXPORT_SYMBOL(ttm_mem_global_free);
 
 static int ttm_mem_global_reserve(struct ttm_mem_global *glob,
 				  struct ttm_mem_zone *single_zone,
@@ -533,6 +534,7 @@ int ttm_mem_global_alloc(struct ttm_mem_global *glob, uint64_t memory,
 	return ttm_mem_global_alloc_zone(glob, NULL, memory, no_wait,
 					 interruptible);
 }
+EXPORT_SYMBOL(ttm_mem_global_alloc);
 
 int ttm_mem_global_alloc_page(struct ttm_mem_global *glob,
 			      struct page *page,
@@ -588,3 +590,4 @@ size_t ttm_round_pot(size_t size)
 	}
 	return 0;
 }
+EXPORT_SYMBOL(ttm_round_pot);
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 7bcb89f..9c2b1cc 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -192,6 +192,7 @@ int ttm_tt_populate(struct ttm_tt *ttm)
 	ttm->state = tt_unbound;
 	return 0;
 }
+EXPORT_SYMBOL(ttm_tt_populate);
 
 #ifdef CONFIG_X86
 static inline int ttm_tt_set_page_caching(struct page *p,
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index d260a87..67355a1 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -545,6 +545,15 @@ extern int ttm_tt_set_user(struct ttm_tt *ttm,
 extern int ttm_tt_bind(struct ttm_tt *ttm, struct ttm_mem_reg *bo_mem);
 
 /**
+ * ttm_tt_populate:
+ *
+ * @ttm: The struct ttm_tt to contain the backing pages.
+ *
+ * Add backing pages to all of @ttm
+ */
+extern int ttm_tt_populate(struct ttm_tt *ttm);
+
+/**
  * ttm_ttm_destroy:
  *
  * @ttm: The struct ttm_tt.
-- 
1.5.3.2

