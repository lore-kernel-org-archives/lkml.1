Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZKRIcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZKRIcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZKRIcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:32:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:15558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZKRIb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:31:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,764,1249282800"; 
   d="scan'208";a="212830450"
Message-Id: <20091118082846.404788666@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 18 Nov 2009 16:26:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/12] ext4: remove encountered_congestion trace
References: <20091118082648.140755818@intel.com>
Content-Disposition: inline; filename=writeback-remove-congested-checks-ext4-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no longer set and scheduled to be removed.

CC: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/trace/events/ext4.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux.orig/include/trace/events/ext4.h	2009-11-06 09:22:35.000000000 +0800
+++ linux/include/trace/events/ext4.h	2009-11-06 09:52:21.000000000 +0800
@@ -310,7 +310,6 @@ TRACE_EVENT(ext4_da_writepages_result,
 		__field(	int,	ret			)
 		__field(	int,	pages_written		)
 		__field(	long,	pages_skipped		)
-		__field(	char,	encountered_congestion	)
 		__field(	char,	more_io			)	
 		__field(	char,	no_nrwrite_index_update )
 		__field(       pgoff_t,	writeback_index		)
@@ -322,17 +321,16 @@ TRACE_EVENT(ext4_da_writepages_result,
 		__entry->ret		= ret;
 		__entry->pages_written	= pages_written;
 		__entry->pages_skipped	= wbc->pages_skipped;
-		__entry->encountered_congestion	= wbc->encountered_congestion;
 		__entry->more_io	= wbc->more_io;
 		__entry->no_nrwrite_index_update = wbc->no_nrwrite_index_update;
 		__entry->writeback_index = inode->i_mapping->writeback_index;
 	),
 
-	TP_printk("dev %s ino %lu ret %d pages_written %d pages_skipped %ld congestion %d more_io %d no_nrwrite_index_update %d writeback_index %lu",
+	TP_printk("dev %s ino %lu ret %d pages_written %d pages_skipped %ld more_io %d no_nrwrite_index_update %d writeback_index %lu",
 		  jbd2_dev_to_name(__entry->dev),
 		  (unsigned long) __entry->ino, __entry->ret,
 		  __entry->pages_written, __entry->pages_skipped,
-		  __entry->encountered_congestion, __entry->more_io,
+		  __entry->more_io,
 		  __entry->no_nrwrite_index_update,
 		  (unsigned long) __entry->writeback_index)
 );


