Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbXGJMqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbXGJMqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbXGJMoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:44:38 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56650 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755622AbXGJMoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:44:13 -0400
Date: Tue, 10 Jul 2007 14:44:45 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] slub.c:early_kmem_cache_node_alloc() shouldn't be
	__init
Message-ID: <20070710124445.GX3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
  MODPOST vmlinux
WARNING: mm/built-in.o(.text+0x24bd3): Section mismatch: reference to .init.text:early_kmem_cache_node_alloc (between 'init_kmem_cache_nodes' and 'calculate_sizes')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/mm/slub.c.old	2007-07-10 04:31:32.000000000 +0200
+++ linux-2.6.22-rc6-mm1/mm/slub.c	2007-07-10 04:31:52.000000000 +0200
@@ -1882,8 +1882,8 @@
  * Note that this function only works on the kmalloc_node_cache
  * when allocating for the kmalloc_node_cache.
  */
-static struct kmem_cache_node * __init early_kmem_cache_node_alloc(gfp_t gfpflags,
-								int node)
+static struct kmem_cache_node *early_kmem_cache_node_alloc(gfp_t gfpflags,
+							   int node)
 {
 	struct page *page;
 	struct kmem_cache_node *n;

