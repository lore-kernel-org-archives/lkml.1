Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbXLDUmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbXLDUmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXLDUmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:42:37 -0500
Received: from mga07.intel.com ([143.182.124.22]:10860 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751495AbXLDUmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:42:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,250,1194249600"; 
   d="scan'208";a="332758445"
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 5/7] dmapool: Tidy up includes and add comments
Date: Tue,  4 Dec 2007 13:26:06 -0800
Message-Id: <1196803569117-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11968035682211-git-send-email-matthew@wil.cx>
References: <20071204170915.GE9405@parisc-linux.org> <11968035682899-git-send-email-matthew@wil.cx> <11968035681680-git-send-email-matthew@wil.cx> <11968035684180-git-send-email-matthew@wil.cx> <11968035682211-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were missing a copyright statement and license, so add GPLv2, David
Brownell's copyright and my copyright.

The asm/io.h include was superfluous, but we were missing a few other
necessary includes.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 mm/dmapool.c |   40 ++++++++++++++++++++++++++++++----------
 1 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index 744d541..e2ea454 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -1,19 +1,39 @@
+/*
+ * DMA Pool allocator
+ *
+ * Copyright 2001 David Brownell
+ * Copyright 2007 Intel Corporation
+ *   Author: Matthew Wilcox <willy@linux.intel.com>
+ *
+ * This software may be redistributed and/or modified under the terms of
+ * the GNU General Public License ("GPL") version 2 as published by the
+ * Free Software Foundation.
+ *
+ * This allocator returns small blocks of a given size which are DMA-able by
+ * the given device.  It uses the dma_alloc_coherent page allocator to get
+ * new pages, then splits them up into blocks of the required size.
+ * Many older drivers still have their own code to do this.
+ *
+ * The current design of this allocator is fairly simple.  The pool is
+ * represented by the 'struct dma_pool' which keeps a doubly-linked list of
+ * allocated pages.  Each page in the page_list is split into blocks of at
+ * least 'size' bytes.
+ */
 
 #include <linux/device.h>
-#include <linux/mm.h>
-#include <asm/io.h>		/* Needed for i386 to build */
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
-#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/poison.h>
 #include <linux/sched.h>
-
-/*
- * Pool allocator ... wraps the dma_alloc_coherent page allocator, so
- * small blocks are easily used by drivers for bus mastering controllers.
- * This should probably be sharing the guts of the slab allocator.
- */
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/wait.h>
 
 struct dma_pool {		/* the pool */
 	struct list_head page_list;
@@ -265,7 +285,7 @@ EXPORT_SYMBOL(dma_pool_destroy);
  *
  * This returns the kernel virtual address of a currently unused block,
  * and reports its dma address through the handle.
- * If such a memory block can't be allocated, null is returned.
+ * If such a memory block can't be allocated, %NULL is returned.
  */
 void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 		     dma_addr_t *handle)
-- 
1.4.4.4
