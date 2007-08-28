Return-Path: <linux-kernel-owner+w=401wt.eu-S1761027AbXH1THz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027AbXH1THz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbXH1THd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:07:33 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58313 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753085AbXH1THb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:31 -0400
Message-Id: <20070828190728.601213915@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:05:55 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [04/36] Use page_cache_xxx in mm/page-writeback.c
Content-Disposition: inline; filename=0004-Use-page_cache_xxx-in-mm-page-writeback.c.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page_cache_xxx in mm/page-writeback.c

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/page-writeback.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 63512a9..ebe76e3 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -624,8 +624,8 @@ int write_cache_pages(struct address_space *mapping,
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
 	} else {
-		index = wbc->range_start >> PAGE_CACHE_SHIFT;
-		end = wbc->range_end >> PAGE_CACHE_SHIFT;
+		index = page_cache_index(mapping, wbc->range_start);
+		end = page_cache_index(mapping, wbc->range_end);
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
 		scanned = 1;
@@ -827,7 +827,7 @@ int __set_page_dirty_nobuffers(struct page *page)
 			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
 			if (mapping_cap_account_dirty(mapping)) {
 				__inc_zone_page_state(page, NR_FILE_DIRTY);
-				task_io_account_write(PAGE_CACHE_SIZE);
+				task_io_account_write(page_cache_size(mapping));
 			}
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
-- 
1.5.2.4

-- 
