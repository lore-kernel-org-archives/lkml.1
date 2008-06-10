Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbYFJOGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbYFJOGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbYFJOGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:06:41 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:4626 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbYFJOGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:06:40 -0400
X-BigFish: VPS2(zzzz10d3izzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K2936P-01-IRY-01
Date: Tue, 10 Jun 2008 16:05:39 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] x86: PAT: fixed checkpatch errors (and whitespaces)
Message-ID: <20080610140539.GG5024@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Jun 2008 14:05:33.0675 (UTC) FILETIME=[0C98F3B0:01C8CB03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: PAT: fixed checkpatch errors (and whitespaces)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |    2 -
 arch/x86/mm/pat.c                          |   31 +++++++++++++--------------
 include/asm-x86/pat.h                      |    6 +---
 3 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 2df461f..84a8220 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -1,9 +1,7 @@
-
 /*
  *	Routines to indentify additional cpu features that are scattered in
  *	cpuid space.
  */
-
 #include <linux/cpu.h>
 
 #include <asm/pat.h>
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 8f288f8..c9a3074 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -66,7 +66,7 @@ enum {
 	PAT_UC_MINUS = 7,	/* UC, but can be overriden by MTRR */
 };
 
-#define PAT(x,y)	((u64)PAT_ ## y << ((x)*8))
+#define PAT(x, y)	((u64)PAT_ ## y << ((x)*8))
 
 void pat_init(void)
 {
@@ -100,8 +100,8 @@ void pat_init(void)
 	 *      011 UC		_PAGE_CACHE_UC
 	 * PAT bit unused
 	 */
-	pat = PAT(0,WB) | PAT(1,WC) | PAT(2,UC_MINUS) | PAT(3,UC) |
-	      PAT(4,WB) | PAT(5,WC) | PAT(6,UC_MINUS) | PAT(7,UC);
+	pat = PAT(0, WB) | PAT(1, WC) | PAT(2, UC_MINUS) | PAT(3, UC) |
+	      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
 
 	/* Boot CPU check */
 	if (!boot_pat_state)
@@ -117,11 +117,11 @@ void pat_init(void)
 static char *cattr_name(unsigned long flags)
 {
 	switch (flags & _PAGE_CACHE_MASK) {
-		case _PAGE_CACHE_UC:		return "uncached";
-		case _PAGE_CACHE_UC_MINUS:	return "uncached-minus";
-		case _PAGE_CACHE_WB:		return "write-back";
-		case _PAGE_CACHE_WC:		return "write-combining";
-		default:			return "broken";
+	case _PAGE_CACHE_UC:		return "uncached";
+	case _PAGE_CACHE_UC_MINUS:	return "uncached-minus";
+	case _PAGE_CACHE_WB:		return "write-back";
+	case _PAGE_CACHE_WC:		return "write-combining";
+	default:			return "broken";
 	}
 }
 
@@ -190,7 +190,7 @@ static int pat_x_mtrr_type(u64 start, u64 end, unsigned long prot,
 	} else if (pat_type == _PAGE_CACHE_UC_MINUS) {
 		*ret_prot = prot | _PAGE_CACHE_UC_MINUS;
 	} else if (pat_type == _PAGE_CACHE_UC ||
-	           mtrr_type == MTRR_TYPE_UNCACHABLE) {
+		   mtrr_type == MTRR_TYPE_UNCACHABLE) {
 		*ret_prot = prot | _PAGE_CACHE_UC;
 	} else if (mtrr_type == MTRR_TYPE_WRCOMB) {
 		*ret_prot = prot | _PAGE_CACHE_WC;
@@ -537,11 +537,11 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 	 * we maintain the tradition of paranoia in this code.
 	 */
 	if (!pat_wc_enabled &&
-	    ! ( boot_cpu_has(X86_FEATURE_MTRR) ||
-		boot_cpu_has(X86_FEATURE_K6_MTRR) ||
-		boot_cpu_has(X86_FEATURE_CYRIX_ARR) ||
-		boot_cpu_has(X86_FEATURE_CENTAUR_MCR)) &&
-	   (pfn << PAGE_SHIFT) >= __pa(high_memory)) {
+	    !(boot_cpu_has(X86_FEATURE_MTRR) ||
+	      boot_cpu_has(X86_FEATURE_K6_MTRR) ||
+	      boot_cpu_has(X86_FEATURE_CYRIX_ARR) ||
+	      boot_cpu_has(X86_FEATURE_CENTAUR_MCR)) &&
+	    (pfn << PAGE_SHIFT) >= __pa(high_memory)) {
 		flags = _PAGE_CACHE_UC;
 	}
 #endif
@@ -563,7 +563,7 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 		return 0;
 
 	if (pfn <= max_pfn_mapped &&
-            ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
+	    ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
 		free_memtype(offset, offset + size);
 		printk(KERN_INFO
 		"%s:%d /dev/mem ioremap_change_attr failed %s for %Lx-%Lx\n",
@@ -601,4 +601,3 @@ void unmap_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
 
 	free_memtype(addr, addr + size);
 }
-
diff --git a/include/asm-x86/pat.h b/include/asm-x86/pat.h
index 88f60cc..6fa9710 100644
--- a/include/asm-x86/pat.h
+++ b/include/asm-x86/pat.h
@@ -1,6 +1,5 @@
-
 #ifndef _ASM_PAT_H
-#define _ASM_PAT_H 1
+#define _ASM_PAT_H
 
 #include <linux/types.h>
 
@@ -8,7 +7,7 @@
 extern int pat_wc_enabled;
 extern void validate_pat_support(struct cpuinfo_x86 *c);
 #else
-static const int pat_wc_enabled = 0;
+static const int pat_wc_enabled;
 static inline void validate_pat_support(struct cpuinfo_x86 *c) { }
 #endif
 
@@ -21,4 +20,3 @@ extern int free_memtype(u64 start, u64 end);
 extern void pat_disable(char *reason);
 
 #endif
-
-- 
1.5.5.3



