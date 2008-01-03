Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbYACPbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbYACPbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:31:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYACPYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:44 -0500
Received: from mail.suse.de ([195.135.220.2]:46763 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbYACPYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:39 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [23/28] CPA: Remove unnecessary masking of address
Message-Id: <20080103152438.6B7A214E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


virt_to_page does not care about the bits below the page granuality.
So don't mask them.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -204,7 +204,7 @@ __change_page_attr(unsigned long address
 
 	kpte = lookup_address(address, &level);
 	if (!kpte) return 0;
-	kpte_page = virt_to_page(((unsigned long)kpte) & PAGE_MASK);
+	kpte_page = virt_to_page(kpte);
 	BUG_ON(PageCompound(kpte_page));
 	BUG_ON(PageLRU(kpte_page));
 
