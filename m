Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbYEDM5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbYEDM5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYEDM5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:57:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54502 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbYEDM5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:57:06 -0400
Date: Sun, 04 May 2008 21:55:57 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nishanth Aravamudan <nacc@us.ibm.com>
Subject: [-mm][PATCH 1/5] fix overflow problem of do_try_to_free_page()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080504215331.8F55.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch is not part of reclaim throttle series.
it is merely hotfixs.

---------------------------------------
"Smarter retry of costly-order allocations" patch series change 
behaver of do_try_to_free_pages().
but unfortunately ret variable type unchanged.

thus, overflow problem is possible.



Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Nishanth Aravamudan <nacc@us.ibm.com>

---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c	2008-05-03 00:02:52.000000000 +0900
+++ b/mm/vmscan.c	2008-05-03 00:05:08.000000000 +0900
@@ -1317,7 +1317,7 @@ static unsigned long do_try_to_free_page
 					struct scan_control *sc)
 {
 	int priority;
-	int ret = 0;
+	unsigned long ret = 0;
 	unsigned long total_scanned = 0;
 	unsigned long nr_reclaimed = 0;
 	struct reclaim_state *reclaim_state = current->reclaim_state;


