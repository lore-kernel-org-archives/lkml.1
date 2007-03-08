Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXCHHln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXCHHln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 02:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932961AbXCHHln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 02:41:43 -0500
Received: from fgwmail9.fujitsu.co.jp ([192.51.44.39]:46432 "EHLO
	fgwmail9.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950AbXCHHlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 02:41:42 -0500
Date: Thu, 08 Mar 2007 16:39:43 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fix BUG_ON check at move_freepages() (Re: 2.6.21-rc3-mm2)
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20070307201915.4d579113.akpm@linux-foundation.org>
References: <20070307201915.4d579113.akpm@linux-foundation.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070308162944.FB7F.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello.

The BUG_ON() check at move_freepages() is wrong.
Its end_page is start_page + MAX_ORDER_NR_PAGES. So, it can be 
next zone. BUG_ON() should check "end_page - 1".

This is fix of 2.6.21-rc3-mm2 for it.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: current_test/mm/page_alloc.c
===================================================================
--- current_test.orig/mm/page_alloc.c	2007-03-08 15:44:10.000000000 +0900
+++ current_test/mm/page_alloc.c	2007-03-08 16:17:29.000000000 +0900
@@ -707,7 +707,7 @@ int move_freepages(struct zone *zone,
 	unsigned long order;
 	int blocks_moved = 0;
 
-	BUG_ON(page_zone(start_page) != page_zone(end_page));
+	BUG_ON(page_zone(start_page) != page_zone(end_page - 1));
 
 	for (page = start_page; page < end_page;) {
 		if (!PageBuddy(page)) {

-- 
Yasunori Goto 


