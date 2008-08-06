Return-Path: <linux-kernel-owner+w=401wt.eu-S1422723AbYHFVLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422723AbYHFVLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbYHFVLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:11:42 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47600 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713AbYHFVLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:11:41 -0400
Date: Thu, 7 Aug 2008 00:10:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] make mm/rmap.c:anon_vma_cachep static
Message-ID: <20080806211013.GB1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global anon_vma_cachep static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Rik van Riel <riel@redhat.com>

---

This patch has been sent on:
- 5 May 2008
- 22 Apr 2008
- 14 Apr 2008
- 31 Mar 2008
- 25 Feb 2008

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

