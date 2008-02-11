Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbYBKJwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbYBKJwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:52:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYBKJu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:50:26 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:38022 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbYBKJuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:50:23 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111050.372086035@suse.de>
In-Reply-To: <200802111050.372086035@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/8] CPA: Remove BUG_ON for LRU/Compound pages
Message-Id: <20080211095021.76DDC1B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:50:21 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:44:00.0298 (UTC) FILETIME=[A10BA8A0:01C86C92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


New implementation does not use lru for anything so there is no need
to reject pages that are in the LRU. Similar for compound pages (which
were checked because they also use page->lru)

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -545,7 +545,6 @@ static int __change_page_attr(unsigned l
 {
 	int do_split, err;
 	unsigned int level;
-	struct page *kpte_page;
 	pte_t *kpte;
 
 repeat:
@@ -553,10 +552,6 @@ repeat:
 	if (!kpte)
 		return -EINVAL;
 
-	kpte_page = virt_to_page(kpte);
-	BUG_ON(PageLRU(kpte_page));
-	BUG_ON(PageCompound(kpte_page));
-
 	if (level == PG_LEVEL_4K) {
 		pte_t new_pte, old_pte = *kpte;
 		pgprot_t new_prot = pte_pgprot(old_pte);
