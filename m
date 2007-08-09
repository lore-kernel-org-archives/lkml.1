Return-Path: <linux-kernel-owner+w=401wt.eu-S939914AbXHIMnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939914AbXHIMnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939640AbXHIMle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:41:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:34958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939630AbXHIMlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:41:32 -0400
From: Andi Kleen <ak@suse.de>
References: <20070809241.425881000@suse.de>
In-Reply-To: <20070809241.425881000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/12] x86_64: Disable CLFLUSH support again
Message-Id: <20070809124131.B6E6114F3B@wotan.suse.de>
Date: Thu,  9 Aug 2007 14:41:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It turns out CLFLUSH support is still not complete; we
flush the wrong pages.  Again disable it for the release.
Noticed by Jan Beulich.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/mm/pageattr.c   |    2 +-
 arch/x86_64/mm/pageattr.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: linux/arch/i386/mm/pageattr.c
===================================================================
--- linux.orig/arch/i386/mm/pageattr.c
+++ linux/arch/i386/mm/pageattr.c
@@ -82,7 +82,7 @@ static void flush_kernel_map(void *arg)
 	struct page *p;
 
 	/* High level code is not ready for clflush yet */
-	if (cpu_has_clflush) {
+	if (0 && cpu_has_clflush) {
 		list_for_each_entry (p, lh, lru)
 			cache_flush_page(p);
 	} else if (boot_cpu_data.x86_model >= 4)
Index: linux/arch/x86_64/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86_64/mm/pageattr.c
+++ linux/arch/x86_64/mm/pageattr.c
@@ -75,7 +75,8 @@ static void flush_kernel_map(void *arg)
 
 	/* When clflush is available always use it because it is
 	   much cheaper than WBINVD. */
-	if (!cpu_has_clflush)
+	/* clflush is still broken. Disable for now. */
+	if (0 && !cpu_has_clflush)
 		asm volatile("wbinvd" ::: "memory");
 	else list_for_each_entry(pg, l, lru) {
 		void *adr = page_address(pg);
