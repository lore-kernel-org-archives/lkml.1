Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbXEaFWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbXEaFWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 01:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbXEaFWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 01:22:42 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49667 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750825AbXEaFWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 01:22:41 -0400
Date: Thu, 31 May 2007 07:22:38 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Dave Jones <davej@redhat.com>, Christian Volkmann <haveaniceday@cv-sv.de>,
       linux-kernel@vger.kernel.org, ak@suse.de,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC: 2.6 patch] i386: remove support for the Rise CPU
Message-ID: <20070531052238.GX3899@stusta.de>
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <464BB252.8010008@cv-sv.de> <464CC8E1.5010407@cv-sv.de> <20070517214754.GC398@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070517214754.GC398@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 05:47:54PM -0400, Dave Jones wrote:
> On Thu, May 17, 2007 at 11:28:01PM +0200, Christian Volkmann wrote:
> 
>  > - Important: somebody to check other CPU types if the same behavior happens.
> 
> arch/i386/kernel/cpu/rise.c
> 
> Though, I've *never* seen or even heard of someone with one of those CPUs,
> so whether we need to care is questionable. The mp6 did actually make it
> to manufacture aparently, but I don't think anyone actually bought one.
> http://en.wikipedia.org/wiki/Rise_Technology for a pic of this mythical beast.

Considering that arch/i386/kernel/cpu/rise.o takes a few bytes in every 
i386 kernel image, what about removing it?

> 	Dave

cu
Adrian


<--  snip  -->


The Rise CPUs were only very short-lived, and there are no reports of 
anyone both owning one and running Linux on it.

Googling for the printk string "CPU: Rise iDragon" didn't find any dmesg 
available online.

If it turns out that against all expectations there are actually users 
reverting this patch would be easy.

This patch will make the kernel images smaller by a few bytes for all 
i386 users.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/i386/kernel/cpu/Makefile  |    1 
 arch/i386/kernel/cpu/common.c  |    2 -
 arch/i386/kernel/cpu/rise.c    |   52 ---------------------------------
 include/asm-i386/processor.h   |    1 
 include/asm-x86_64/processor.h |    1 
 5 files changed, 57 deletions(-)

--- linux-2.6.22-rc2-mm1/include/asm-i386/processor.h.old	2007-05-31 01:47:13.000000000 +0200
+++ linux-2.6.22-rc2-mm1/include/asm-i386/processor.h	2007-05-31 01:47:18.000000000 +0200
@@ -88,7 +88,6 @@
 #define X86_VENDOR_UMC 3
 #define X86_VENDOR_NEXGEN 4
 #define X86_VENDOR_CENTAUR 5
-#define X86_VENDOR_RISE 6
 #define X86_VENDOR_TRANSMETA 7
 #define X86_VENDOR_NSC 8
 #define X86_VENDOR_NUM 9
--- linux-2.6.22-rc2-mm1/include/asm-x86_64/processor.h.old	2007-05-31 01:47:28.000000000 +0200
+++ linux-2.6.22-rc2-mm1/include/asm-x86_64/processor.h	2007-05-31 01:47:32.000000000 +0200
@@ -83,7 +83,6 @@
 #define X86_VENDOR_UMC 3
 #define X86_VENDOR_NEXGEN 4
 #define X86_VENDOR_CENTAUR 5
-#define X86_VENDOR_RISE 6
 #define X86_VENDOR_TRANSMETA 7
 #define X86_VENDOR_NUM 8
 #define X86_VENDOR_UNKNOWN 0xff
--- linux-2.6.22-rc2-mm1/arch/i386/kernel/cpu/Makefile.old	2007-05-31 01:46:00.000000000 +0200
+++ linux-2.6.22-rc2-mm1/arch/i386/kernel/cpu/Makefile	2007-05-31 01:46:11.000000000 +0200
@@ -9,7 +9,6 @@
 obj-y	+=	centaur.o
 obj-y	+=	transmeta.o
 obj-y	+=	intel.o intel_cacheinfo.o
-obj-y	+=	rise.o
 obj-y	+=	nexgen.o
 obj-y	+=	umc.o
 
--- linux-2.6.22-rc2-mm1/arch/i386/kernel/cpu/common.c.old	2007-05-31 01:51:43.000000000 +0200
+++ linux-2.6.22-rc2-mm1/arch/i386/kernel/cpu/common.c	2007-05-31 01:51:48.000000000 +0200
@@ -604,7 +604,6 @@
 extern int amd_init_cpu(void);
 extern int centaur_init_cpu(void);
 extern int transmeta_init_cpu(void);
-extern int rise_init_cpu(void);
 extern int nexgen_init_cpu(void);
 extern int umc_init_cpu(void);
 
@@ -616,7 +615,6 @@
 	amd_init_cpu();
 	centaur_init_cpu();
 	transmeta_init_cpu();
-	rise_init_cpu();
 	nexgen_init_cpu();
 	umc_init_cpu();
 	early_cpu_detect();
--- linux-2.6.22-rc2-mm1/arch/i386/kernel/cpu/rise.c	2007-05-26 21:20:11.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,52 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/bitops.h>
-#include <asm/processor.h>
-
-#include "cpu.h"
-
-static void __cpuinit init_rise(struct cpuinfo_x86 *c)
-{
-	printk("CPU: Rise iDragon");
-	if (c->x86_model > 2)
-		printk(" II");
-	printk("\n");
-
-	/* Unhide possibly hidden capability flags
-	   The mp6 iDragon family don't have MSRs.
-	   We switch on extra features with this cpuid weirdness: */
-	__asm__ (
-		"movl $0x6363452a, %%eax\n\t"
-		"movl $0x3231206c, %%ecx\n\t"
-		"movl $0x2a32313a, %%edx\n\t"
-		"cpuid\n\t"
-		"movl $0x63634523, %%eax\n\t"
-		"movl $0x32315f6c, %%ecx\n\t"
-		"movl $0x2333313a, %%edx\n\t"
-		"cpuid\n\t" : : : "eax", "ebx", "ecx", "edx"
-	);
-	set_bit(X86_FEATURE_CX8, c->x86_capability);
-}
-
-static struct cpu_dev rise_cpu_dev __cpuinitdata = {
-	.c_vendor	= "Rise",
-	.c_ident	= { "RiseRiseRise" },
-	.c_models = {
-		{ .vendor = X86_VENDOR_RISE, .family = 5, .model_names = 
-		  { 
-			  [0] = "iDragon", 
-			  [2] = "iDragon", 
-			  [8] = "iDragon II", 
-			  [9] = "iDragon II"
-		  }
-		},
-	},
-	.c_init		= init_rise,
-};
-
-int __init rise_init_cpu(void)
-{
-	cpu_devs[X86_VENDOR_RISE] = &rise_cpu_dev;
-	return 0;
-}
-

