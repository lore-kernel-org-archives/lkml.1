Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYIEDJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYIEDJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYIEDJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:54468 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbYIEDJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ruRODNv1QnkHVxR3iSaN8US0pQ/Ob8JnZlqa9X4nBCqaBzGLSx01ksS+n8qv59ACfV
         496KmjfLJefkp2cgJsz5y8/pUJhjjEYKK3y+pxfEv5D5GZTeM4vn0HhaTWOL4P2IXJug
         oECzLCrh4mJP4U8QEOmMSnXdEmbFqL4tp53z8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 01/16] x86: make detect_ht depends on X86_HT
Date: Thu,  4 Sep 2008 20:08:59 -0700
Message-Id: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64bit has X86_HT set too, so use that instead of SMP

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |    4 ++--
 arch/x86/kernel/cpu/common_64.c |    2 +-
 include/asm-x86/processor.h     |    4 ----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7d5a07f..1f80ce0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -263,9 +263,9 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 			l2size, ecx & 0xFF);
 }
 
-#ifdef CONFIG_X86_HT
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_HT
 	u32 eax, ebx, ecx, edx;
 	int index_msb, core_bits;
 
@@ -311,8 +311,8 @@ out:
 		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
 		       c->cpu_core_id);
 	}
-}
 #endif
+}
 
 static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 {
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index bcb48ce..8e63073 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -141,7 +141,7 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_SMP
+#ifdef CONFIG_X86_HT
 	u32 eax, ebx, ecx, edx;
 	int index_msb, core_bits;
 
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index ee8eab6..1197cc6 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -167,11 +167,7 @@ extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
 
 extern void detect_extended_topology(struct cpuinfo_x86 *c);
-#if defined(CONFIG_X86_HT) || defined(CONFIG_X86_64)
 extern void detect_ht(struct cpuinfo_x86 *c);
-#else
-static inline void detect_ht(struct cpuinfo_x86 *c) {}
-#endif
 
 static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 				unsigned int *ecx, unsigned int *edx)
-- 
1.5.4.5

