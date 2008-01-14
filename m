Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbYANWY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbYANWY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYANWRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:17:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861AbYANWQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:16:57 -0500
From: Andi Kleen <ak@suse.de>
References: <200801141116.534682000@suse.de>
In-Reply-To: <200801141116.534682000@suse.de>
To: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [23/31] CPA: Remove unnecessary masking of address
Message-Id: <20080114221656.35AC014F83@wotan.suse.de>
Date: Mon, 14 Jan 2008 23:16:56 +0100 (CET)
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
 
