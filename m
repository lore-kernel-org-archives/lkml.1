Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYHSRrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYHSRrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbYHSRrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:47:05 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:44207 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145AbYHSRrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=NoCWw3ndvlQ61bpXOWUZ6GVfeMDsmTB9wNFXeUhRiTrBywO8rTEYVYQF64bdOfZL9w
         Rf3VAsMtWfRjO9c8iDLHntRUQCm/prUrXDiUadafx25/dCnWkgmHkhw+Xf71KoIILshD
         tlKMno/dA4eGXN+/ucS3agCUbF4jnv35DVSIU=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: penberg@cs.helsinki.fi
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rdunlap@xenotime.net,
       mpm@selenic.com, tglx@linutronix.de, rostedt@goodmis.org,
       cl@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       tzanussi@gmail.com,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH 3/5] SLUB: Replace __builtin_return_address(0) with _RET_IP_.
Date: Tue, 19 Aug 2008 20:43:25 +0300
Message-Id: <1219167807-5407-3-git-send-email-eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1219167807-5407-2-git-send-email-eduard.munteanu@linux360.ro>
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro>
 <1219167807-5407-2-git-send-email-eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces __builtin_return_address(0) with _RET_IP_, since a
previous patch moved _RET_IP_ and _THIS_IP_ to include/linux/kernel.h and
they're widely available now. This makes for shorter and easier to read
code.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 mm/slub.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4f5b961..8f66782 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1612,14 +1612,14 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
-	return slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
+	return slab_alloc(s, gfpflags, -1, (void *) _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	return slab_alloc(s, gfpflags, node, __builtin_return_address(0));
+	return slab_alloc(s, gfpflags, node, (void *) _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 #endif
@@ -1730,7 +1730,7 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 
 	page = virt_to_head_page(x);
 
-	slab_free(s, page, x, __builtin_return_address(0));
+	slab_free(s, page, x, (void *) _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -2657,7 +2657,7 @@ void *__kmalloc(size_t size, gfp_t flags)
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, -1, __builtin_return_address(0));
+	return slab_alloc(s, flags, -1, (void *) _RET_IP_);
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -2685,7 +2685,7 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, node, __builtin_return_address(0));
+	return slab_alloc(s, flags, node, (void *) _RET_IP_);
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
@@ -2742,7 +2742,7 @@ void kfree(const void *x)
 		put_page(page);
 		return;
 	}
-	slab_free(page->slab, page, object, __builtin_return_address(0));
+	slab_free(page->slab, page, object, (void *) _RET_IP_);
 }
 EXPORT_SYMBOL(kfree);
 
-- 
1.5.6.1

