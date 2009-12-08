Return-Path: <linux-kernel-owner+w=401wt.eu-S966435AbZLHVUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966435AbZLHVUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966281AbZLHVQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:16:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49526 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966237AbZLHVQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:16:20 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
In-Reply-To: <200912081016.198135742@firstfloor.org>
To: fengguang.wu@intel.com, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [10/31] HWPOISON: comment dirty swapcache pages
Message-Id: <20091208211626.5E29EB151F@basil.firstfloor.org>
Date: Tue,  8 Dec 2009 22:16:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Wu Fengguang <fengguang.wu@intel.com>

AK: Improve comment

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/memory.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c
+++ linux/mm/memory.c
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
