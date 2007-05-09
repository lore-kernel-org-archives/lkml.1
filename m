Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbXEIMCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbXEIMCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbXEIMCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:02:37 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:43139 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637AbXEIMCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:02:36 -0400
Subject: [KJ PATCH] Replacing alloc_pages(gfp,0) with alloc_page(gfp) in
	arch/i386/mm/pgtable.c.
From: Shani Moideen <shani.moideen@wipro.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@lists.osdl.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux COE, Wipro Technolgies
Date: Wed, 09 May 2007 17:30:41 +0530
Message-Id: <1178712041.2280.25.camel@shani-win>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
X-OriginalArrivalTime: 09 May 2007 12:02:34.0107 (UTC) FILETIME=[ED9FBCB0:01C79231]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 
Replacing alloc_pages(gfp,0) with alloc_page(gfp) in
arch/i386/mm/pgtable.c.

Signed-off-by: Shani Moideen <shani.moideen@wipro.com>
----

diff --git a/arch/i386/mm/pgtable.c b/arch/i386/mm/pgtable.c
index fa0cfbd..5d2b0fb 100644
--- a/arch/i386/mm/pgtable.c
+++ b/arch/i386/mm/pgtable.c
@@ -191,9 +191,9 @@ struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
 	struct page *pte;

 #ifdef CONFIG_HIGHPTE
-	pte = alloc_pages(GFP_KERNEL|__GFP_HIGHMEM|__GFP_REPEAT|__GFP_ZERO, 0);
+	pte = alloc_page(GFP_KERNEL|__GFP_HIGHMEM|__GFP_REPEAT|__GFP_ZERO);
 #else
-	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
+	pte = alloc_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
 #endif
 	return pte;
 }

-- 
Shani 
