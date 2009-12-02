Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZLBEh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZLBEh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbZLBEh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:37:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:36773 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280AbZLBEha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764900"
Message-Id: <20091202043044.572334411@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <npiggin@suse.de>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/24] HWPOISON: comment dirty swapcache pages
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=hwpoison-comment-dirty-swapcache.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Andi Kleen <andi@firstfloor.org> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-mm.orig/mm/memory.c	2009-11-24 16:50:44.000000000 +0800
+++ linux-mm/mm/memory.c	2009-11-30 10:35:39.000000000 +0800
@@ -2540,6 +2540,10 @@ static int do_swap_page(struct mm_struct
 		ret = VM_FAULT_MAJOR;
 		count_vm_event(PGMAJFAULT);
 	} else if (PageHWPoison(page)) {
+		/*
+		 * hwpoisoned dirty swapcache pages are kept for killing
+		 * owner processes (which may be unknown at hwpoison time)
+		 */
 		ret = VM_FAULT_HWPOISON;
 		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 		goto out_release;


