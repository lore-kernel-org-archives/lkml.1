Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975Ab0ATGGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0ATGGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742Ab0ATGGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:06:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38049 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab0ATGGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:06:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [cleanup][PATCH] Kill anon local variable from migrate_page_copy
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100120150451.406A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 20 Jan 2010 15:06:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 01b1ae63c2 (memcg: simple migration handling) removed
mem_cgroup_uncharge_cache_page() call from migrate_page_copy.
Then, now anon variable is unused.

This patch remove it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/migrate.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index efddbf0..9e4a13f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -275,8 +275,6 @@ static int migrate_page_move_mapping(struct address_space *mapping,
  */
 static void migrate_page_copy(struct page *newpage, struct page *page)
 {
-	int anon;
-
 	copy_highpage(newpage, page);
 
 	if (PageError(page))
@@ -313,8 +311,6 @@ static void migrate_page_copy(struct page *newpage, struct page *page)
 	ClearPageSwapCache(page);
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
-	/* page->mapping contains a flag for PageAnon() */
-	anon = PageAnon(page);
 	page->mapping = NULL;
 
 	/*
-- 
1.6.5.2



