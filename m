Return-Path: <linux-kernel-owner+w=401wt.eu-S1765542AbXIUWhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765542AbXIUWhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763417AbXIUWcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:40470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763453AbXIUWcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:14 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [15/50] x86_64: Return EINVAL for unknown address in change_page_attr
Message-Id: <20070921223213.D92CC13DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Matches what i386 does and makes more sense.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/mm/pageattr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/arch/x86_64/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86_64/mm/pageattr.c
+++ linux/arch/x86_64/mm/pageattr.c
@@ -151,7 +151,9 @@ __change_page_attr(unsigned long address
 	pgprot_t ref_prot2;
 
 	kpte = lookup_address(address);
-	if (!kpte) return 0;
+	if (!kpte)
+		return -EINVAL;
+
 	kpte_page = virt_to_page(((unsigned long)kpte) & PAGE_MASK);
 	BUG_ON(PageCompound(kpte_page));
 	BUG_ON(PageLRU(kpte_page));
