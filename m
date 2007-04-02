Return-Path: <linux-kernel-owner+w=401wt.eu-S965371AbXDBKST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965371AbXDBKST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 06:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965369AbXDBKST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 06:18:19 -0400
Received: from saeurebad.de ([85.214.36.134]:50325 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965373AbXDBKSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 06:18:18 -0400
Date: Mon, 2 Apr 2007 12:18:13 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, christoph@lameter.com,
       penberg@cs.helsinki.fi
Subject: [PATCH] Catch kmalloc() failure in kmem_cache_init()
Message-ID: <20070402101813.GB5831@saeurebad.de>
References: <20070329160434.GA10265@cvg>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/Uq4LBwYP4y1W6pO"
Content-Disposition: inline
In-Reply-To: <20070329160434.GA10265@cvg>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

This patch makes kmem_cache_init() trigger a BUG when the calls to
kmalloc() fail. Altough the kernel would not boot anyway on failure,
this adds some clarity to the code.

Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="slab-cache-init-kmalloc-failure-catch.patch"

diff --git a/mm/slab.c b/mm/slab.c
index 57f7aa4..6d7e486 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1512,6 +1512,7 @@ void __init kmem_cache_init(void)
 		struct array_cache *ptr;
 
 		ptr = kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
+		BUG_ON(!ptr);
 
 		local_irq_disable();
 		BUG_ON(cpu_cache_get(&cache_cache) != &initarray_cache.cache);
@@ -1526,6 +1527,7 @@ void __init kmem_cache_init(void)
 		local_irq_enable();
 
 		ptr = kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
+		BUG_ON(!ptr);
 
 		local_irq_disable();
 		BUG_ON(cpu_cache_get(malloc_sizes[INDEX_AC].cs_cachep)

--/Uq4LBwYP4y1W6pO--
