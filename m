Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbYAPWY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbYAPWY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbYAPWPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:55256 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbYAPWP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:29 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [28/36] CPA: Remove unnecessary masking of address
Message-Id: <20080116221528.288CB150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


virt_to_page does not care about the bits below the page granuality.
So don't mask them.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

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
 
