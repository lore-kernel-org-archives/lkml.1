Return-Path: <linux-kernel-owner+w=401wt.eu-S1762810AbXH1TVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810AbXH1TVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761433AbXH1TI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58364 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756078AbXH1THe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:34 -0400
Message-Id: <20070828190733.172352857@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:13 -0700
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
Subject: [22/36] compound pages: Add new support functions
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
index 3e9e8fe..fa4cbab 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -362,6 +362,21 @@ static inline void set_compound_order(struct page *page, unsigned long order)
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
1.5.2.4

-- 
