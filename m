Return-Path: <linux-kernel-owner+w=401wt.eu-S1763351AbXFTSnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763351AbXFTSnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759235AbXFTSby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46759 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756641AbXFTSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:10 -0400
Message-Id: <20070620183008.937522816@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:20 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [13/37] Use page_cache_xxx in mm/fadvise.c
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
