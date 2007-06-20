Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbXFTSdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbXFTSdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759208AbXFTSac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:30:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54768 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756200AbXFTSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:10 -0400
Message-Id: <20070620183008.090980796@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:17 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [10/37] Use page_cache_xxx in fs/sync.
Content-Disposition: inline; filename=vps_fs_sync
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/sync.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: vps/fs/sync.c
===================================================================
--- vps.orig/fs/sync.c	2007-06-04 17:57:25.000000000 -0700
+++ vps/fs/sync.c	2007-06-09 21:17:45.000000000 -0700
@@ -252,8 +252,8 @@ int do_sync_mapping_range(struct address
 	ret = 0;
 	if (flags & SYNC_FILE_RANGE_WAIT_BEFORE) {
 		ret = wait_on_page_writeback_range(mapping,
-					offset >> PAGE_CACHE_SHIFT,
-					endbyte >> PAGE_CACHE_SHIFT);
+					page_cache_index(mapping, offset),
+					page_cache_index(mapping, endbyte));
 		if (ret < 0)
 			goto out;
 	}
@@ -267,8 +267,8 @@ int do_sync_mapping_range(struct address
 
 	if (flags & SYNC_FILE_RANGE_WAIT_AFTER) {
 		ret = wait_on_page_writeback_range(mapping,
-					offset >> PAGE_CACHE_SHIFT,
-					endbyte >> PAGE_CACHE_SHIFT);
+					page_cache_index(mapping, offset),
+					page_cache_index(mapping, endbyte));
 	}
 out:
 	return ret;

-- 
