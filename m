Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab0BBPeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:34:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:5718 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255Ab0BBPeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:34:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="239540021"
Message-Id: <20100202153316.655608338@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 02 Feb 2010 23:28:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jens Axboe <jens.axboe@oracle.com>, Wu Fengguang <fengguang.wu@intel.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Linux Memory Management List <linux-mm@kvack.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/11] readahead: introduce {MAX|MIN}_READAHEAD_PAGES macros for ease of use
References: <20100202152835.683907822@intel.com>
Content-Disposition: inline; filename=readahead-min-max-pages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 block/blk-core.c   |    3 +--
 fs/fuse/inode.c    |    2 +-
 include/linux/mm.h |    3 +++
 mm/backing-dev.c   |    2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

--- linux.orig/block/blk-core.c	2010-01-30 17:38:48.000000000 +0800
+++ linux/block/blk-core.c	2010-01-30 18:10:01.000000000 +0800
@@ -498,8 +498,7 @@ struct request_queue *blk_alloc_queue_no
 
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
-	q->backing_dev_info.ra_pages =
-			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
+	q->backing_dev_info.ra_pages = MAX_READAHEAD_PAGES;
 	q->backing_dev_info.state = 0;
 	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
 	q->backing_dev_info.name = "block";
--- linux.orig/fs/fuse/inode.c	2010-01-30 17:38:48.000000000 +0800
+++ linux/fs/fuse/inode.c	2010-01-30 18:10:01.000000000 +0800
@@ -870,7 +870,7 @@ static int fuse_bdi_init(struct fuse_con
 	int err;
 
 	fc->bdi.name = "fuse";
-	fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
+	fc->bdi.ra_pages = MAX_READAHEAD_PAGES;
 	fc->bdi.unplug_io_fn = default_unplug_io_fn;
 	/* fuse does it's own writeback accounting */
 	fc->bdi.capabilities = BDI_CAP_NO_ACCT_WB;
--- linux.orig/include/linux/mm.h	2010-01-30 18:09:58.000000000 +0800
+++ linux/include/linux/mm.h	2010-01-30 18:10:01.000000000 +0800
@@ -1187,6 +1187,9 @@ void task_dirty_inc(struct task_struct *
 #define VM_MAX_READAHEAD	512	/* kbytes */
 #define VM_MIN_READAHEAD	32	/* kbytes (includes current page) */
 
+#define MAX_READAHEAD_PAGES (VM_MAX_READAHEAD*1024 / PAGE_CACHE_SIZE)
+#define MIN_READAHEAD_PAGES DIV_ROUND_UP(VM_MIN_READAHEAD*1024, PAGE_CACHE_SIZE)
+
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
 
--- linux.orig/mm/backing-dev.c	2010-01-30 17:38:48.000000000 +0800
+++ linux/mm/backing-dev.c	2010-01-30 18:10:01.000000000 +0800
@@ -18,7 +18,7 @@ EXPORT_SYMBOL(default_unplug_io_fn);
 
 struct backing_dev_info default_backing_dev_info = {
 	.name		= "default",
-	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
+	.ra_pages	= MAX_READAHEAD_PAGES,
 	.state		= 0,
 	.capabilities	= BDI_CAP_MAP_COPY,
 	.unplug_io_fn	= default_unplug_io_fn,


