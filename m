Return-Path: <linux-kernel-owner+w=401wt.eu-S932488AbXCPIwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbXCPIwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932458AbXCPIwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:52:12 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34691 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932253AbXCPIwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:52:01 -0400
Message-ID: <374035060.44909@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316085053.339604000@mail.ustc.edu.cn>
References: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:49:08 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] readahead: account I/O block times for stock readahead
Content-Disposition: inline; filename=readahead-account-io-block-times-for-stock-readahead.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Account I/O block times for the stock readahead, too.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

---
 mm/readahead.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.21-rc3-mm2.orig/mm/readahead.c
+++ linux-2.6.21-rc3-mm2/mm/readahead.c
@@ -1756,15 +1756,15 @@ EXPORT_SYMBOL_GPL(page_cache_readahead_a
  */
 void readahead_cache_hit(struct file_ra_state *ra, struct page *page)
 {
-	if (!prefer_adaptive_readahead())
-		return;
-
 	if (PageActive(page) || PageReferenced(page))
 		return;
 
 	if (!PageUptodate(page))
 		ra_account(ra, RA_EVENT_IO_BLOCK, 1);
 
+	if (!prefer_adaptive_readahead())
+		return;
+
 	if (!ra_has_index(ra, page->index))
 		return;
 

--
