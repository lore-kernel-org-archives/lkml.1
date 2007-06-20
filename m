Return-Path: <linux-kernel-owner+w=401wt.eu-S1761432AbXFTSgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761432AbXFTSgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759327AbXFTSbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:01 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46759 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757087AbXFTSaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:13 -0400
Message-Id: <20070620183011.571596436@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:31 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [24/37] compound pages: Add new support functions
Content-Disposition: inline; filename=compound_functions
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

compound_pages(page)	-> Determines base pages of a compound page

compound_shift(page)	-> Determine the page shift of a compound page

compound_size(page)	-> Determine the size of a compound page

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: vps/include/linux/mm.h
===================================================================
--- vps.orig/include/linux/mm.h	2007-06-11 15:56:37.000000000 -0700
+++ vps/include/linux/mm.h	2007-06-12 19:06:28.000000000 -0700
@@ -365,6 +365,21 @@ static inline void set_compound_order(st
 	page[1].lru.prev = (void *)order;
 }
 
+static inline int compound_pages(struct page *page)
+{
+ 	return 1 << compound_order(page);
+}
+
+static inline int compound_shift(struct page *page)
+{
+ 	return PAGE_SHIFT + compound_order(page);
+}
+
+static inline int compound_size(struct page *page)
+{
+	return PAGE_SIZE << compound_order(page);
+}
+
 /*
  * Multiple processes may "see" the same page. E.g. for untouched
  * mappings of /dev/null, all processes see the same page full of

-- 
