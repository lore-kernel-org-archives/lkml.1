Return-Path: <linux-kernel-owner+w=401wt.eu-S1763624AbYFEBXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763624AbYFEBXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 21:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763049AbYFEBWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 21:22:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55237 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762959AbYFEBVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 21:21:32 -0400
Message-Id: <20080605021504.134644327@jp.fujitsu.com>
References: <20080605021211.871673550@jp.fujitsu.com>
User-Agent: quilt/0.46-1
Date: Thu, 05 Jun 2008 11:12:12 +0900
From: kosaki.motohiro@jp.fujitsu.com
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH 1/5] fix incorrect variable type of do_try_to_free_pages()
Content-Disposition: inline; filename=01-fix-do_try_to_free_pages-ret.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Smarter retry of costly-order allocations" patch series change behaver of do_try_to_free_pages().
but unfortunately ret variable tyep unchanged.

thus, overflow problem is possible.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1317,7 +1317,7 @@ static unsigned long do_try_to_free_page
 					struct scan_control *sc)
 {
 	int priority;
-	int ret = 0;
+	unsigned long ret = 0;
 	unsigned long total_scanned = 0;
 	unsigned long nr_reclaimed = 0;
 	struct reclaim_state *reclaim_state = current->reclaim_state;

-- 
