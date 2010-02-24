Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0BXDNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 22:13:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:29684 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114Ab0BXDNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 22:13:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,529,1262592000"; 
   d="scan'208";a="598621487"
Message-Id: <20100224031055.594006457@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 24 Feb 2010 11:10:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Clemens Ladisch <clemens@ladisch.de>
CC: Olivier Galibert <galibert@pobox.com>
cc: Vivek Goyal <vgoyal@redhat.com>
cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
cc: Matt Mackall <mpm@selenic.com>
cc: Linux Memory Management List <linux-mm@kvack.org>
CC: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/15] readahead: reduce MMAP_LOTSAMISS for mmap read-around
References: <20100224031001.026464755@intel.com>
Content-Disposition: inline; filename=readahead-mmap-around.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we lifts readahead size from 128KB to 512KB,
the MMAP_LOTSAMISS shall be shrinked accordingly.

We shrink it a bit more, so that for sparse random access patterns,
only 10*512KB or ~5MB memory will be wasted, instead of the previous
100*128KB or ~12MB. The new threshold "10" is still big enough to avoid
turning off read-around for typical executable/lib page faults.

CC: Nick Piggin <npiggin@suse.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/mm/filemap.c	2010-02-21 23:56:22.000000000 +0800
+++ linux/mm/filemap.c	2010-02-21 23:56:26.000000000 +0800
@@ -1393,7 +1393,7 @@ static int page_cache_read(struct file *
 	return ret;
 }
 
-#define MMAP_LOTSAMISS  (100)
+#define MMAP_LOTSAMISS  (10)
 
 /*
  * Synchronous readahead happens when we don't even find


