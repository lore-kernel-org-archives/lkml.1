Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbYAPWRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbYAPWRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYAPWPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:10 -0500
Received: from ns1.suse.de ([195.135.220.2]:55180 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbYAPWPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:06 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [7/36] Shrink __PAGE_KERNEL/__PAGE_KERNEL_EXEC on non PAE kernels
Message-Id: <20080116221505.CAC21150C5@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No need to make it 64bit there.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/init_32.c     |    4 ++--
 include/asm-x86/pgtable.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/arch/x86/mm/init_32.c
===================================================================
--- linux.orig/arch/x86/mm/init_32.c
+++ linux/arch/x86/mm/init_32.c
@@ -353,9 +353,9 @@ static void __init set_highmem_pages_ini
 #define set_highmem_pages_init(bad_ppro) do { } while (0)
 #endif /* CONFIG_HIGHMEM */
 
-unsigned long long __PAGE_KERNEL = _PAGE_KERNEL;
+pteval_t __PAGE_KERNEL = _PAGE_KERNEL;
 EXPORT_SYMBOL(__PAGE_KERNEL);
-unsigned long long __PAGE_KERNEL_EXEC = _PAGE_KERNEL_EXEC;
+pteval_t __PAGE_KERNEL_EXEC = _PAGE_KERNEL_EXEC;
 
 #ifdef CONFIG_NUMA
 extern void __init remap_numa_kva(void);
Index: linux/include/asm-x86/pgtable.h
===================================================================
--- linux.orig/include/asm-x86/pgtable.h
+++ linux/include/asm-x86/pgtable.h
@@ -74,7 +74,7 @@
 #define _PAGE_KERNEL (_PAGE_KERNEL_EXEC | _PAGE_NX)
 
 #ifndef __ASSEMBLY__
-extern unsigned long long __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
+extern pteval_t __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #endif	/* __ASSEMBLY__ */
 #else
 #define __PAGE_KERNEL_EXEC						\
