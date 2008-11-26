Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbYKZDPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbYKZDPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYKZDOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:14:50 -0500
Received: from smtp-out.google.com ([216.239.45.13]:13378 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbYKZDOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:14:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type;
	b=ncaejYPQvlpS/Z+Gmtdocn+USXcY93ITQZblLK6lFWwRD82PemIaiakuuywcI7zTW
	oSsN/q+BlemYA0nDotXWw==
Date: Tue, 25 Nov 2008 19:14:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch] slub: make early_kmem_cache_node_alloc void
Message-ID: <alpine.DEB.2.00.0811251853250.5358@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value for early_kmem_cache_node_alloc() is unused, so it is
better defined as void.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2073,8 +2073,7 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
  * when allocating for the kmalloc_node_cache. This is used for bootstrapping
  * memory on a fresh node that has no slab structures yet.
  */
-static struct kmem_cache_node *early_kmem_cache_node_alloc(gfp_t gfpflags,
-							   int node)
+static void early_kmem_cache_node_alloc(gfp_t gfpflags, int node)
 {
 	struct page *page;
 	struct kmem_cache_node *n;
@@ -2112,7 +2111,6 @@ static struct kmem_cache_node *early_kmem_cache_node_alloc(gfp_t gfpflags,
 	local_irq_save(flags);
 	add_partial(n, page, 0);
 	local_irq_restore(flags);
-	return n;
 }
 
 static void free_kmem_cache_nodes(struct kmem_cache *s)
@@ -2144,8 +2142,7 @@ static int init_kmem_cache_nodes(struct kmem_cache *s, gfp_t gfpflags)
 			n = &s->local_node;
 		else {
 			if (slab_state == DOWN) {
-				n = early_kmem_cache_node_alloc(gfpflags,
-								node);
+				early_kmem_cache_node_alloc(gfpflags, node);
 				continue;
 			}
 			n = kmem_cache_alloc_node(kmalloc_caches,
