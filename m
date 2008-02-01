Return-Path: <linux-kernel-owner+w=401wt.eu-S1764426AbYBAJ7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764426AbYBAJ7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760509AbYBAJzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:55:20 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:58490 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760459AbYBAJzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:55:18 -0500
From: Andi Kleen <ak@suse.de>
References: <200802011055.370582801@suse.de>
In-Reply-To: <200802011055.370582801@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/3] CPA: Remove outdated comment in kernel_map_pages and add warning about recursion
Message-Id: <20080201095515.6C9061B416F@basil.firstfloor.org>
Date: Fri,  1 Feb 2008 10:55:15 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:48:57.0939 (UTC) FILETIME=[AA529230:01C864B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -556,6 +556,7 @@ static int __set_pages_np(struct page *p
 					__pgprot(_PAGE_PRESENT));
 }
 
+/* This function recurses with unknown maximum depth */
 void kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (PageHighMem(page))
@@ -571,10 +572,6 @@ void kernel_map_pages(struct page *page,
 	if (!debug_pagealloc_enabled)
 		return;
 
-	/*
-	 * The return value is ignored - the calls cannot fail,
-	 * large pages are disabled at boot time:
-	 */
 	if (enable)
 		__set_pages_p(page, numpages);
 	else
