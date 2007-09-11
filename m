Return-Path: <linux-kernel-owner+w=401wt.eu-S1762680AbXIKGIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680AbXIKGIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762282AbXIKGEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:04:42 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56488 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761309AbXIKGEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:30 -0400
Message-Id: <20070911060428.301646767@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:03 -0700
From: Christoph Lameter <clameter@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com, hugh@veritas.com
Cc: joern@lazybastard.org
Subject: [13/41] Use page_cache_xxx in mm/fadvise.c
Content-Disposition: inline; filename=0013-Use-page_cache_xxx-in-mm-fadvise.c.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page_cache_xxx in mm/fadvise.c

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/fadvise.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/fadvise.c b/mm/fadvise.c
index 0df4c89..804c2a9 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -79,8 +79,8 @@ asmlinkage long sys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
 		}
 
 		/* First and last PARTIAL page! */
-		start_index = offset >> PAGE_CACHE_SHIFT;
-		end_index = endbyte >> PAGE_CACHE_SHIFT;
+		start_index = page_cache_index(mapping, offset);
+		end_index = page_cache_index(mapping, endbyte);
 
 		/* Careful about overflow on the "+1" */
 		nrpages = end_index - start_index + 1;
@@ -100,8 +100,8 @@ asmlinkage long sys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
 			filemap_flush(mapping);
 
 		/* First and last FULL page! */
-		start_index = (offset+(PAGE_CACHE_SIZE-1)) >> PAGE_CACHE_SHIFT;
-		end_index = (endbyte >> PAGE_CACHE_SHIFT);
+		start_index = page_cache_next(mapping, offset);
+		end_index = page_cache_index(mapping, endbyte);
 
 		if (end_index >= start_index)
 			invalidate_mapping_pages(mapping, start_index,
-- 
1.5.2.5

-- 
