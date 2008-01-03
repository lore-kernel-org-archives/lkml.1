Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbYACPYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbYACPYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYACPYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:16 -0500
Received: from ns2.suse.de ([195.135.220.15]:43006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbYACPYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:16 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [1/28] Shrink __PAGE_KERNEL/__PAGE_KERNEL_EXEC on non PAE kernels
Date: Thu,  3 Jan 2008 16:24:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No need to make it 64bit there.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/init_32.c        |    4 ++--
 include/asm-x86/pgtable_32.h |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: linux/arch/x86/mm/init_32.c
===================================================================
--- linux.orig/arch/x86/mm/init_32.c
+++ linux/arch/x86/mm/init_32.c
@@ -326,9 +326,9 @@ static void __init set_highmem_pages_ini
 #define set_highmem_pages_init(bad_ppro) do { } while (0)
 #endif /* CONFIG_HIGHMEM */
 
-unsigned long long __PAGE_KERNEL = _PAGE_KERNEL;
+typeof_field(pgprot_t, pgprot) __PAGE_KERNEL = _PAGE_KERNEL;
 EXPORT_SYMBOL(__PAGE_KERNEL);
-unsigned long long __PAGE_KERNEL_EXEC = _PAGE_KERNEL_EXEC;
+typeof_field(pgprot_t, pgprot) __PAGE_KERNEL_EXEC = _PAGE_KERNEL_EXEC;
 
 #ifdef CONFIG_NUMA
 extern void __init remap_numa_kva(void);
Index: linux/include/asm-x86/pgtable_32.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_32.h
+++ linux/include/asm-x86/pgtable_32.h
@@ -153,7 +153,8 @@ void paging_init(void);
 #define _PAGE_KERNEL_EXEC \
 	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
 
-extern unsigned long long __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
+#define typeof_field(t, m) typeof(((t *)0)->m)
+extern typeof_field(pgprot_t, pgprot) __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
