Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbXFNToq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbXFNToq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbXFNTlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:41:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50449 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753779AbXFNTk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:40:56 -0400
Message-Id: <20070614194055.464510068@sgi.com>
References: <20070614193839.878721298@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 12:38:52 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [patch 13/14] Use page_cache_xxx in mm/fadvise.c
Content-Disposition: inline; filename=vps_fs_fadvise
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/fadvise.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: vps/mm/fadvise.c
===================================================================
--- vps.orig/mm/fadvise.c	2007-06-04 17:57:25.000000000 -0700
+++ vps/mm/fadvise.c	2007-06-09 21:32:46.000000000 -0700
@@ -79,8 +79,8 @@ asmlinkage long sys_fadvise64_64(int fd,
 		}
 
 		/* First and last PARTIAL page! */
-		start_index = offset >> PAGE_CACHE_SHIFT;
-		end_index = endbyte >> PAGE_CACHE_SHIFT;
+		start_index = page_cache_index(mapping, offset);
+		end_index = page_cache_index(mapping, endbyte);
 
 		/* Careful about overflow on the "+1" */
 		nrpages = end_index - start_index + 1;
@@ -100,8 +100,8 @@ asmlinkage long sys_fadvise64_64(int fd,
 			filemap_flush(mapping);
 
 		/* First and last FULL page! */
-		start_index = (offset+(PAGE_CACHE_SIZE-1)) >> PAGE_CACHE_SHIFT;
-		end_index = (endbyte >> PAGE_CACHE_SHIFT);
+		start_index = page_cache_next(mapping, offset);
+		end_index = page_cache_index(mapping, endbyte);
 
 		if (end_index >= start_index)
 			invalidate_mapping_pages(mapping, start_index,

-- 
