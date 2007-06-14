Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbXFNTmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbXFNTmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbXFNTk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:40:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50441 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753300AbXFNTky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:40:54 -0400
Message-Id: <20070614194053.395763058@sgi.com>
References: <20070614193839.878721298@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 12:38:43 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [patch 04/14] Use page_cache_xxx in mm/page-writeback.c
Content-Disposition: inline; filename=vps_mm_page_writeback
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/page-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: vps/mm/page-writeback.c
===================================================================
--- vps.orig/mm/page-writeback.c	2007-06-07 17:01:04.000000000 -0700
+++ vps/mm/page-writeback.c	2007-06-09 21:34:24.000000000 -0700
@@ -626,8 +626,8 @@ int write_cache_pages(struct address_spa
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
@@ -829,7 +829,7 @@ int __set_page_dirty_nobuffers(struct pa
 			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
 			if (mapping_cap_account_dirty(mapping)) {
 				__inc_zone_page_state(page, NR_FILE_DIRTY);
-				task_io_account_write(PAGE_CACHE_SIZE);
+				task_io_account_write(page_cache_size(mapping));
 			}
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);

-- 
