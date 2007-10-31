Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbXJaHxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbXJaHxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 03:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbXJaHwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 03:52:55 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46497 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbXJaHwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 03:52:54 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 31 Oct 2007 13:22:43 +0530
Message-Id: <20071031075243.22225.53636.sendpatchset@balbir-laptop>
Subject: [PATCH] Swap delay accounting, include lock_page() delays
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Reported-by: Nick Piggin <nickpiggin@yahoo.com.au>

The delay incurred in lock_page() should also be accounted in swap delay
accounting

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~fix-delay-accounting-swap-accounting mm/swapfile.c
diff -puN mm/memory.c~fix-delay-accounting-swap-accounting mm/memory.c
--- linux-2.6-latest/mm/memory.c~fix-delay-accounting-swap-accounting	2007-10-31 12:58:05.000000000 +0530
+++ linux-2.6-latest-balbir/mm/memory.c	2007-10-31 13:02:50.000000000 +0530
@@ -2084,9 +2084,9 @@ static int do_swap_page(struct mm_struct
 		count_vm_event(PGMAJFAULT);
 	}
 
-	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 	mark_page_accessed(page);
 	lock_page(page);
+	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 
 	/*
 	 * Back out if somebody else already faulted in this pte.
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
