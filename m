Return-Path: <linux-kernel-owner+w=401wt.eu-S966742AbXIKGZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966742AbXIKGZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965517AbXIKGG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:06:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50593 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761468AbXIKGEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:32 -0400
Message-Id: <20070911060430.424260145@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:12 -0700
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
Subject: [22/41] compound pages: Add new support functions
Content-Disposition: inline; filename=0022-compound-pages-Add-new-support-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

compound_pages(page)	-> Determines base pages of a compound page

compound_shift(page)	-> Determine the page shift of a compound page

compound_size(page)	-> Determine the size of a compound page

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/mm.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1692dd6..6f3a8d6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -363,6 +363,21 @@ static inline void set_compound_order(struct page *page, unsigned long order)
 	page[1].lru.prev = (void *)order;
 }
 
+static inline int compound_pages(struct page *page)
+{
+	return 1 << compound_order(page);
+}
+
+static inline int compound_shift(struct page *page)
+{
+	return PAGE_SHIFT + compound_order(page);
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
1.5.2.5

-- 
