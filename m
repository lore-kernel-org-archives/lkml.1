Return-Path: <linux-kernel-owner+w=401wt.eu-S1763362AbYFEBcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763362AbYFEBcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 21:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbYFEBby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 21:31:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41880 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbYFEBby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 21:31:54 -0400
Date: Thu, 05 Jun 2008 10:26:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH 1/5] fix incorrect variable type of do_try_to_free_pages()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nishanth Aravamudan <nacc@us.ibm.com>
In-Reply-To: <20080605021504.134644327@jp.fujitsu.com>
References: <20080605021211.871673550@jp.fujitsu.com> <20080605021504.134644327@jp.fujitsu.com>
Message-Id: <20080605102500.9C23.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "Smarter retry of costly-order allocations" patch series change behaver of do_try_to_free_pages().
> but unfortunately ret variable tyep unchanged.
> 
> thus, overflow problem is possible.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

sorry, this patch already get Nishanth-san's ACK.
I'll append it and resend by this mail.


----------------------------
fix incorrect variable type of do_try_to_free_pages() 

"Smarter retry of costly-order allocations" patch series change behaver of do_try_to_free_pages().
but unfortunately ret variable tyep unchanged.

thus, overflow problem is possible.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>

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



