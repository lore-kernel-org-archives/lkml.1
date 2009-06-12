Return-Path: <linux-kernel-owner+w=401wt.eu-S932395AbZFLDBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbZFLDBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbZFLDAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:00:54 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:60795 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbZFLDAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:00:53 -0400
Message-ID: <4A31C4D9.80605@oracle.com>
Date: Thu, 11 Jun 2009 20:00:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH -2.6.30-git3] block: fix kernel-doc in recent block/ changes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A31C4DC.00CD:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in recently changed block/ source code.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 block/blk-core.c     |   21 +++++++++++----------
 block/blk-settings.c |    6 +++---
 2 files changed, 14 insertions(+), 13 deletions(-)

--- linux-2.6.30-git3.orig/block/blk-core.c
+++ linux-2.6.30-git3/block/blk-core.c
@@ -884,9 +884,10 @@ EXPORT_SYMBOL(blk_get_request);
 
 /**
  * blk_make_request - given a bio, allocate a corresponding struct request.
- *
+ * @q: target request queue
  * @bio:  The bio describing the memory mappings that will be submitted for IO.
  *        It may be a chained-bio properly constructed by block/bio layer.
+ * @gfp_mask: gfp flags to be used for memory allocation
  *
  * blk_make_request is the parallel of generic_make_request for BLOCK_PC
  * type commands. Where the struct request needs to be farther initialized by
@@ -1872,14 +1873,14 @@ EXPORT_SYMBOL(blk_fetch_request);
 
 /**
  * blk_update_request - Special helper function for request stacking drivers
- * @rq:	      the request being processed
+ * @req:      the request being processed
  * @error:    %0 for success, < %0 for error
- * @nr_bytes: number of bytes to complete @rq
+ * @nr_bytes: number of bytes to complete @req
  *
  * Description:
- *     Ends I/O on a number of bytes attached to @rq, but doesn't complete
- *     the request structure even if @rq doesn't have leftover.
- *     If @rq has leftover, sets it up for the next range of segments.
+ *     Ends I/O on a number of bytes attached to @req, but doesn't complete
+ *     the request structure even if @req doesn't have leftover.
+ *     If @req has leftover, sets it up for the next range of segments.
  *
  *     This special helper function is only for request stacking drivers
  *     (e.g. request-based dm) so that they can handle partial completion.
@@ -2145,7 +2146,7 @@ EXPORT_SYMBOL_GPL(blk_end_request);
 /**
  * blk_end_request_all - Helper function for drives to finish the request.
  * @rq: the request to finish
- * @err: %0 for success, < %0 for error
+ * @error: %0 for success, < %0 for error
  *
  * Description:
  *     Completely finish @rq.
@@ -2166,7 +2167,7 @@ EXPORT_SYMBOL_GPL(blk_end_request_all);
 /**
  * blk_end_request_cur - Helper function to finish the current request chunk.
  * @rq: the request to finish the current chunk for
- * @err: %0 for success, < %0 for error
+ * @error: %0 for success, < %0 for error
  *
  * Description:
  *     Complete the current consecutively mapped chunk from @rq.
@@ -2203,7 +2204,7 @@ EXPORT_SYMBOL_GPL(__blk_end_request);
 /**
  * __blk_end_request_all - Helper function for drives to finish the request.
  * @rq: the request to finish
- * @err: %0 for success, < %0 for error
+ * @error: %0 for success, < %0 for error
  *
  * Description:
  *     Completely finish @rq.  Must be called with queue lock held.
@@ -2224,7 +2225,7 @@ EXPORT_SYMBOL_GPL(__blk_end_request_all)
 /**
  * __blk_end_request_cur - Helper function to finish the current request chunk.
  * @rq: the request to finish the current chunk for
- * @err: %0 for success, < %0 for error
+ * @error: %0 for success, < %0 for error
  *
  * Description:
  *     Complete the current consecutively mapped chunk from @rq.  Must
--- linux-2.6.30-git3.orig/block/blk-settings.c
+++ linux-2.6.30-git3/block/blk-settings.c
@@ -343,7 +343,7 @@ EXPORT_SYMBOL(blk_queue_physical_block_s
 /**
  * blk_queue_alignment_offset - set physical block alignment offset
  * @q:	the request queue for the device
- * @alignment:	alignment offset in bytes
+ * @offset: alignment offset in bytes
  *
  * Description:
  *   Some devices are naturally misaligned to compensate for things like
@@ -362,7 +362,7 @@ EXPORT_SYMBOL(blk_queue_alignment_offset
 /**
  * blk_queue_io_min - set minimum request size for the queue
  * @q:	the request queue for the device
- * @io_min:  smallest I/O size in bytes
+ * @min:  smallest I/O size in bytes
  *
  * Description:
  *   Some devices have an internal block size bigger than the reported
@@ -385,7 +385,7 @@ EXPORT_SYMBOL(blk_queue_io_min);
 /**
  * blk_queue_io_opt - set optimal request size for the queue
  * @q:	the request queue for the device
- * @io_opt:  optimal request size in bytes
+ * @opt:  optimal request size in bytes
  *
  * Description:
  *   Drivers can call this function to set the preferred I/O request
