Return-Path: <linux-kernel-owner+w=401wt.eu-S1763035AbXGSKRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763035AbXGSKRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbXGSJzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:33103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbXGSJzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:32 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [39/58] i386: minor nx handling adjustment
Message-Id: <20070719095525.6424314E05@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Constrain __supported_pte_mask and NX handling to just the PAE kernel.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/i386/mm/init.c     |    7 ++++---
 include/asm-i386/page.h |    1 -
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux/arch/i386/mm/init.c
===================================================================
--- linux.orig/arch/i386/mm/init.c
+++ linux/arch/i386/mm/init.c
@@ -471,6 +471,10 @@ void zap_low_mappings (void)
 	flush_tlb_all();
 }
 
+int nx_enabled = 0;
+
+#ifdef CONFIG_X86_PAE
+
 static int disable_nx __initdata = 0;
 u64 __supported_pte_mask __read_mostly = ~_PAGE_NX;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
@@ -500,9 +504,6 @@ static int __init noexec_setup(char *str
 }
 early_param("noexec", noexec_setup);
 
-int nx_enabled = 0;
-#ifdef CONFIG_X86_PAE
-
 static void __init set_nx(void)
 {
 	unsigned int v[4], l, h;
Index: linux/include/asm-i386/page.h
===================================================================
--- linux.orig/include/asm-i386/page.h
+++ linux/include/asm-i386/page.h
@@ -44,7 +44,6 @@
 extern int nx_enabled;
 
 #ifdef CONFIG_X86_PAE
-extern unsigned long long __supported_pte_mask;
 typedef struct { unsigned long pte_low, pte_high; } pte_t;
 typedef struct { unsigned long long pmd; } pmd_t;
 typedef struct { unsigned long long pgd; } pgd_t;
