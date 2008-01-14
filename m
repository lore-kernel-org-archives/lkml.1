Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbYANWVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbYANWVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbYANWQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:16:56 -0500
Received: from ns2.suse.de ([195.135.220.15]:54949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650AbYANWQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:16:50 -0500
From: Andi Kleen <ak@suse.de>
References: <200801141116.534682000@suse.de>
In-Reply-To: <200801141116.534682000@suse.de>
To: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [16/31] CPA: Use wbinvd() macro instead of inline assembly in 64bit c_p_a()
Message-Id: <20080114221648.C166914F83@wotan.suse.de>
Date: Mon, 14 Jan 2008 23:16:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -95,7 +95,7 @@ static void flush_kernel_map(void *arg)
 	/* When clflush is available always use it because it is
 	   much cheaper than WBINVD. */
 	if ((a->full_flush || !cpu_has_clflush) && !cpu_has_ss)
-		asm volatile("wbinvd" ::: "memory");
+		wbinvd();
 	list_for_each_entry(f, &a->l, l) {
 		if (!a->full_flush && !cpu_has_ss)
 			clflush_cache_range((void *)f->addr, PAGE_SIZE);
