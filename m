Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYAPWWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYAPWWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYAPWPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071AbYAPWPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:22 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [21/36] CPA: Use wbinvd() macro instead of inline assembly in 64bit c_p_a()
Message-Id: <20080116221520.ABC61150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

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
