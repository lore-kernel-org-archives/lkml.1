Return-Path: <linux-kernel-owner+w=401wt.eu-S966012AbXIKGJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966012AbXIKGJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762317AbXIKGEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:04:48 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56487 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761281AbXIKGEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:30 -0400
Message-Id: <20070911060427.602216400@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:00 -0700
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
Subject: [10/41] Use page_cache_xxx in fs/sync
Content-Disposition: inline; filename=0010-Use-page_cache_xxx-in-fs-sync.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page_cache_xxx in fs/sync.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/sync.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 7cd005e..f30d7eb 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -260,8 +260,8 @@ int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
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
@@ -275,8 +275,8 @@ int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
 
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
1.5.2.5

-- 
