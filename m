Return-Path: <linux-kernel-owner+w=401wt.eu-S1752977AbZFIJQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbZFIJQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 05:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbZFIJQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 05:16:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60997 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461AbZFIJQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 05:16:37 -0400
Date: Tue, 9 Jun 2009 18:15:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       riel@redhat.com
Subject: [BUGFIX][PATCH] fix wrong lru rotate back at lumpty reclaim
Message-Id: <20090609181505.4083a213.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In lumpty reclaim, "cursor_page" is found just by pfn. Then, we don't know
from which LRU "cursor" page came from. Then, putback it to "src" list is BUG.
Just leave it as it is.
(And I think rotate here is overkilling even if "src" is correct.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmscan.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: mmotm-2.6.30-Jun4/mm/vmscan.c
===================================================================
--- mmotm-2.6.30-Jun4.orig/mm/vmscan.c
+++ mmotm-2.6.30-Jun4/mm/vmscan.c
@@ -940,10 +940,9 @@ static unsigned long isolate_lru_pages(u
 				nr_taken++;
 				scan++;
 				break;
-
 			case -EBUSY:
-				/* else it is being freed elsewhere */
-				list_move(&cursor_page->lru, src);
+				/* Do nothing because we don't know where
+ 				   cusrsor_page comes from */
 			default:
 				break;	/* ! on LRU or wrong list */
 			}

