Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbYGAHCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbYGAHCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYGAHCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:02:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33763 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYGAHCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:02:37 -0400
Date: Tue, 01 Jul 2008 16:01:19 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [PATCH -mm] split_lru: fix pagevec_move_tail() doesn't treat unevictable page 
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080701155749.37F8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

even under writebacking, page can move to unevictable list.
so shouldn't pagevec_move_tail() check unevictable?


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/mm/swap.c
===================================================================
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -116,7 +116,7 @@ static void pagevec_move_tail(struct pag
 			zone = pagezone;
 			spin_lock(&zone->lru_lock);
 		}
-		if (PageLRU(page) && !PageActive(page)) {
+		if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 			int lru = page_is_file_cache(page);
 			list_move_tail(&page->lru, &zone->lru[lru].list);
 			pgmoved++;


