Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbXIABrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbXIABrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 21:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbXIABnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 21:43:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46113 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751565AbXIABmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 21:42:22 -0400
Message-Id: <20070901014221.838742707@sgi.com>
References: <20070901014107.719506437@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 31 Aug 2007 18:41:18 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: David Chinner <dgc@sgi.com>
Subject: [RFC 11/26] VM: Allow get_page_unless_zero on compound pages
Content-Disposition: inline; filename=0011-slab_defrag_get_page_unless.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB uses compound pages for larger slabs. We need to increment
the page count of these pages in order to make sure that they are not
freed under us for reclaim from within lumpy reclaim.

(The patch is also part of the large blocksize patchset)

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/mm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9fbb6ba..713d096 100644
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
1.5.2.4

-- 
