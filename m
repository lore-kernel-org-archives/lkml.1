Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbXFTSh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbXFTSh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbXFTSbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46753 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757773AbXFTSaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:13 -0400
Message-Id: <20070620183012.273119366@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:34 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [27/37] compound pages: Allow use of get_page_unless_zero with compound pages
Content-Disposition: inline; filename=compound_get_one_unless
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This will be needed by targeted slab reclaim in order to ensure that a
compound page allocated by SLUB will not go away under us.

It also may be needed if Mel starts to implement defragmentation. The
moving of compound pages may require the establishment of a reference
before the use of page migration functions.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: vps/include/linux/mm.h
===================================================================
--- vps.orig/include/linux/mm.h	2007-06-12 19:06:28.000000000 -0700
+++ vps/include/linux/mm.h	2007-06-12 19:06:41.000000000 -0700
@@ -292,7 +292,7 @@ static inline int put_page_testzero(stru
  */
 static inline int get_page_unless_zero(struct page *page)
 {
-	VM_BUG_ON(PageCompound(page));
+	VM_BUG_ON(PageTail(page));
 	return atomic_inc_not_zero(&page->_count);
 }
 

-- 
