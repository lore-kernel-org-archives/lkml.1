Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbYACP1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbYACP1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYACPYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:34 -0500
Received: from mail.suse.de ([195.135.220.2]:46758 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbYACPYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:32 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [16/28] CPA: Use wbinvd() macro instead of inline assembly in 64bit c_p_a()
Message-Id: <20080103152431.0191414E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:30 +0100 (CET)
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
