Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYAPWQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYAPWQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYAPWPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:38203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbYAPWPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:01 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [2/36] Undo pageattr_32 portions of 11c9734cbcf4c5862260442a5d56dd4779799fcc
Message-Id: <20080116221500.72865150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Undoes pageattr_32.c parts of 

Not sure what the point of that change was anyways.

 commit 11c9734cbcf4c5862260442a5d56dd4779799fcc
 Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
 Date:   Tue Jan 15 09:36:03 2008 +0100

    patches/x86-pat-usable_only_map_i386.patch
    
    i386: Map only usable memory in identity map. Reserved memory maps to a
    zero page.


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -55,11 +55,9 @@ split_large_page(unsigned long address, 
 	/*
 	 * page_private is used to track the number of entries in
 	 * the page table page that have non standard attributes.
-	 * Count of 1 indicates page split by split_large_page(),
-	 * additional count indicates the number of pages with non-std attr.
 	 */
 	SetPagePrivate(base);
-	page_private(base) = 1;
+	page_private(base) = 0;
 
 	address = __pa(address);
 	addr = address & LARGE_PAGE_MASK;
@@ -205,7 +203,7 @@ static int __change_page_attr(struct pag
 
 	save_page(kpte_page);
 	if (!PageReserved(kpte_page)) {
-		if (cpu_has_pse && (page_private(kpte_page) == 1)) {
+		if (cpu_has_pse && (page_private(kpte_page) == 0)) {
 			paravirt_release_pt(page_to_pfn(kpte_page));
 			revert_page(kpte_page, address);
 		}
