Return-Path: <linux-kernel-owner+w=401wt.eu-S1423175AbXDXWY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423175AbXDXWY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423171AbXDXWXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:23:15 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56787 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423172AbXDXWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:23:06 -0400
Message-Id: <20070424222305.674144260@sgi.com>
References: <20070424222105.883597089@sgi.com>
User-Agent: quilt/0.45-1
Date: Tue, 24 Apr 2007 15:21:10 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [05/17] More compound page features
Content-Disposition: inline; filename=var_pc_compound_advanced
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a couple of more compound functions to avoid having to duplicate code in various places.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux-2.6.21-rc7/include/linux/mm.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/mm.h	2007-04-24 11:33:34.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/mm.h	2007-04-24 11:32:16.000000000 -0700
@@ -330,6 +330,21 @@ static inline int compound_order(struct 
 	return (unsigned long)page[1].lru.prev;
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
