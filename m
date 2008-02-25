Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbYBYAKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbYBYAKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759271AbYBYAIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:08:45 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33650 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759244AbYBYAIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:08:44 -0500
Date: Mon, 25 Feb 2008 02:07:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make mm/rmap.c:anon_vma_cachep static
Message-ID: <20080225000748.GG2088@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global anon_vma_cachep static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/rmap.h |   12 ------------
 mm/rmap.c            |   12 +++++++++++-
 2 files changed, 11 insertions(+), 13 deletions(-)

8d2d63d71ecbf2db78f31025acb136c9dd4db6a2 diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 1383692..8a8dbb9 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -31,18 +31,6 @@ struct anon_vma {
 
 #ifdef CONFIG_MMU
 
-extern struct kmem_cache *anon_vma_cachep;
-
-static inline struct anon_vma *anon_vma_alloc(void)
-{
-	return kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
-}
-
-static inline void anon_vma_free(struct anon_vma *anon_vma)
-{
-	kmem_cache_free(anon_vma_cachep, anon_vma);
-}
-
 static inline void anon_vma_lock(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
diff --git a/mm/rmap.c b/mm/rmap.c
index 8fd527c..ef6bb36 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -52,7 +52,17 @@
 
 #include <asm/tlbflush.h>
 
-struct kmem_cache *anon_vma_cachep;
+static struct kmem_cache *anon_vma_cachep;
+
+static inline struct anon_vma *anon_vma_alloc(void)
+{
+	return kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
+}
+
+static inline void anon_vma_free(struct anon_vma *anon_vma)
+{
+	kmem_cache_free(anon_vma_cachep, anon_vma);
+}
 
 /* This must be called under the mmap_sem. */
 int anon_vma_prepare(struct vm_area_struct *vma)

