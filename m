Return-Path: <linux-kernel-owner+w=401wt.eu-S966213AbXIKGN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966213AbXIKGN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762272AbXIKGFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:05:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50596 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761469AbXIKGEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:32 -0400
Message-Id: <20070911060431.361306886@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:15 -0700
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
Subject: [25/41] compound pages: Allow use of get_page_unless_zero with compound pages
Content-Disposition: inline; filename=0025-compound-pages-Allow-use-of-get_page_unless_zero-wi.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed by slab defragmentation. The refcount of a page head
may be incremented to ensure that a compound page will not go away under us.

It also may be needed for defragmentation of higher order pages. The
moving of compound pages may require the establishment of a reference
before the use of page migration functions.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/mm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6f3a8d6..a8a0378 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -290,7 +290,7 @@ static inline int put_page_testzero(struct page *page)
  */
 static inline int get_page_unless_zero(struct page *page)
 {
-	VM_BUG_ON(PageCompound(page));
+	VM_BUG_ON(PageTail(page));
 	return atomic_inc_not_zero(&page->_count);
 }
 
-- 
1.5.2.5

-- 
