Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbXFNToE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbXFNToE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbXFNTlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:41:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50447 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753557AbXFNTkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:40:55 -0400
Message-Id: <20070614194054.788180082@sgi.com>
References: <20070614193839.878721298@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 12:38:49 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [patch 10/14] Use page_cache_xx in fs/sync.
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
