Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZDGMDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZDGMDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZDGMBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:01:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:7786 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbZDGMAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:00:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,337,1235980800"; 
   d="scan'208";a="128748916"
Message-Id: <20090407115234.083558981@intel.com>
References: <20090407115039.780820496@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Apr 2009 19:50:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ying Han <yinghan@google.com>, Wu Fengguang <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rohit Seth <rohitseth@google.com>
Cc: Edwin <edwintorok@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 03/14] mm: remove FAULT_FLAG_RETRY dead code
Content-Disposition: inline; filename=memory-fault-retry-simp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ying Han <yinghan@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- mm.orig/mm/memory.c
+++ mm/mm/memory.c
@@ -2766,10 +2766,8 @@ static int do_linear_fault(struct mm_str
 {
 	pgoff_t pgoff = (((address & PAGE_MASK)
 			- vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-	int write = write_access & ~FAULT_FLAG_RETRY;
-	unsigned int flags = (write ? FAULT_FLAG_WRITE : 0);
+	unsigned int flags = (write_access ? FAULT_FLAG_WRITE : 0);
 
-	flags |= (write_access & FAULT_FLAG_RETRY);
 	pte_unmap(page_table);
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }

-- 

