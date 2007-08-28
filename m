Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbXH1TLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbXH1TLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761078AbXH1TH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:07:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58812 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756831AbXH1THh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:37 -0400
Message-Id: <20070828190733.876908938@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:16 -0700
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
Subject: [25/36] compound pages: Allow use of get_page_unless_zero with compound pages
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

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-08-27 20:59:40.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2007-08-27 21:03:20.000000000 -0700
@@ -290,7 +290,7 @@ static inline int put_page_testzero(stru
  */
 static inline int get_page_unless_zero(struct page *page)
 {
-	VM_BUG_ON(PageCompound(page));
+	VM_BUG_ON(PageTail(page));
 	return atomic_inc_not_zero(&page->_count);
 }
 

-- 
