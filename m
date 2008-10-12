Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbYJLNln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbYJLNln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYJLNle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:41:34 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43393 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbYJLNld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:41:33 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>
Subject: [mmotm 10 Oct][PATCH 2/2] fix build error of vmscan
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <20081012223808.1817.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081012223808.1817.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081012223946.181A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sun, 12 Oct 2008 22:41:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Patch against: mmotm 10 Oct
Patch name: vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix.patch
Applied after: vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix.patch


--------
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch introduce following build error.

  CC      mm/vmscan.o
mm/vmscan.c: In function 'shrink_active_list':
mm/vmscan.c:1248: error: too few arguments to function 'page_referenced'
make[1]: *** [mm/vmscan.o] Error 1
make: *** [mm] Error 2


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Rik van Riel <riel@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>

---
 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1245,7 +1245,8 @@ static void shrink_active_list(unsigned 
 		}
 
 		/* page_referenced clears PageReferenced */
-		if (page_mapping_inuse(page) && page_referenced(page))
+		if (page_mapping_inuse(page) &&
+		    page_referenced(page, 0, sc->mem_cgroup))
 			pgmoved++;
 
 		list_add(&page->lru, &l_inactive);


