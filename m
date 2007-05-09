Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbXEIL7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbXEIL7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbXEIL7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:59:16 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:42989 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbXEIL7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:59:15 -0400
Subject: [KJ PATCH] Replacing alloc_pages(gfp,0) with alloc_page(gfp) in
	arch/i386/mm/pageattr.c.
From: Shani Moideen <shani.moideen@wipro.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@lists.osdl.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux COE, Wipro Technolgies
Date: Wed, 09 May 2007 17:27:19 +0530
Message-Id: <1178711839.2280.21.camel@shani-win>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
X-OriginalArrivalTime: 09 May 2007 11:59:12.0822 (UTC) FILETIME=[75A61560:01C79231]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 
Replacing alloc_pages(gfp,0) with alloc_page(gfp) in
arch/i386/mm/pageattr.c.

Signed-off-by: Shani Moideen <shani.moideen@wipro.com>
----

diff --git a/arch/i386/mm/pageattr.c b/arch/i386/mm/pageattr.c
index 412ebbd..12f7f14 100644
--- a/arch/i386/mm/pageattr.c
+++ b/arch/i386/mm/pageattr.c
@@ -45,7 +45,7 @@ static struct page *split_large_page(unsigned long address, pgprot_t prot,
 	pte_t *pbase;

 	spin_unlock_irq(&cpa_lock);
-	base = alloc_pages(GFP_KERNEL, 0);
+	base = alloc_page(GFP_KERNEL);
 	spin_lock_irq(&cpa_lock);
 	if (!base) 
 		return NULL;


-- 
Shani 
