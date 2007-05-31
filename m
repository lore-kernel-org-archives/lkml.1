Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbXEaAbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbXEaAbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbXEaAaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:30:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60134 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752900AbXEaAaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:30:14 -0400
Message-Id: <20070531003012.765913558@sgi.com>
References: <20070531002047.702473071@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 30 May 2007 17:20:50 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: [RFC 3/4] CONFIG_STABLE: Switch off SLUB banner
Content-Disposition: inline; filename=stable_no_slub_banner
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The one line that SLUB prints on bootup is useful for debugging but I do not
think that we would like to have it on in stable kernels.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-05-30 16:40:04.000000000 -0700
+++ slub/mm/slub.c	2007-05-30 16:40:40.000000000 -0700
@@ -2518,12 +2518,13 @@ void __init kmem_cache_init(void)
 
 	kmem_size = offsetof(struct kmem_cache, cpu_slab) +
 				nr_cpu_ids * sizeof(struct page *);
-
+#ifndef CONFIG_STABLE
 	printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
 		" Processors=%d, Nodes=%d\n",
 		KMALLOC_SHIFT_HIGH, cache_line_size(),
 		slub_min_order, slub_max_order, slub_min_objects,
 		nr_cpu_ids, nr_node_ids);
+#endif
 }
 
 /*

-- 
