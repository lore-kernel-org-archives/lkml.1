Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0BBPfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:35:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:14323 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377Ab0BBPeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:34:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,390,1262592000"; 
   d="scan'208";a="592471018"
Message-Id: <20100202153316.513043033@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 02 Feb 2010 23:28:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Wu Fengguang <fengguang.wu@intel.com>
cc: Linux Memory Management List <linux-mm@kvack.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/11] readahead: bump up the default readahead size
References: <20100202152835.683907822@intel.com>
Content-Disposition: inline; filename=readahead-enlarge-default-size.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use 512kb max readahead size, and 32kb min readahead size.

The former helps io performance for common workloads.
The latter will be used in the thrashing safe context readahead.

CC: Jens Axboe <jens.axboe@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/include/linux/mm.h	2010-01-30 17:38:49.000000000 +0800
+++ linux/include/linux/mm.h	2010-01-30 18:09:58.000000000 +0800
@@ -1184,8 +1184,8 @@ int write_one_page(struct page *page, in
 void task_dirty_inc(struct task_struct *tsk);
 
 /* readahead.c */
-#define VM_MAX_READAHEAD	128	/* kbytes */
-#define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
+#define VM_MAX_READAHEAD	512	/* kbytes */
+#define VM_MIN_READAHEAD	32	/* kbytes (includes current page) */
 
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);


