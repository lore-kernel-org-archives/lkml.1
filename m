Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZAVAie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZAVAie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 19:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZAVAi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 19:38:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41292 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbZAVAiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 19:38:25 -0500
Message-ID: <4977BFFE.3040305@zytor.com>
Date: Wed, 21 Jan 2009 16:38:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Avuton Olrich <avuton@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due
 to 	dc1e35c
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com>
In-Reply-To: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030008000100020504020502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030008000100020504020502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Avuton Olrich wrote:
> Hello,
> 
> My computer fails to make it past 'Unpacking kernel' with anything
> later than dc1e35, to at least v2.6.29-rc2 due to dc1e35c, at least so
> git bisect told me. While writing this bug I discovered I was using
> gcc-4.1.1 when I thought I was using gcc-4.3.2; I upgraded, recompiled
> 2.6.28.1 and same results so I assume the same results would come from
> me doing the 4 hour bisect again.
> 

Hi Avuton,

Could you apply these two patches and verify that they work, even with 
the BIOS CPUID level limit enabled?

	-hpa


--------------030008000100020504020502
Content-Type: text/x-patch;
 name="0001-x86-add-MSR_IA32_MISC_ENABLE-bits-to-asm-msr-index.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-add-MSR_IA32_MISC_ENABLE-bits-to-asm-msr-index.patc";
 filename*1="h"

>From 2afec5648181c201ea48c442e2b47d11a73d9f50 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@linux.intel.com>
Date: Wed, 21 Jan 2009 15:01:56 -0800
Subject: [PATCH] x86: add MSR_IA32_MISC_ENABLE bits to <asm/msr-index.h>

Impact: None (new bit definitions currently unused)

Add bit definitions for the MSR_IA32_MISC_ENABLE MSRs to
<asm/msr-index.h>.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/msr-index.h |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index cb58643..358acc5 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -202,6 +202,35 @@
 #define MSR_IA32_THERM_STATUS		0x0000019c
 #define MSR_IA32_MISC_ENABLE		0x000001a0
 
+/* MISC_ENABLE bits: architectural */
+#define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
+#define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
+#define MSR_IA32_MISC_ENABLE_EMON		(1ULL << 7)
+#define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL	(1ULL << 11)
+#define MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL	(1ULL << 12)
+#define MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP	(1ULL << 16)
+#define MSR_IA32_MISC_ENABLE_MWAIT		(1ULL << 18)
+#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID	(1ULL << 22)
+#define MSR_IA32_MISC_ENABLE_XTPR_DISABLE	(1ULL << 23)
+#define MSR_IA32_MISC_ENABLE_XD_DISABLE		(1ULL << 34)
+
+/* MISC_ENABLE bits: model-specific, meaning may vary from core to core */
+#define MSR_IA32_MISC_ENABLE_X87_COMPAT		(1ULL << 2)
+#define MSR_IA32_MISC_ENABLE_TM1		(1ULL << 3)
+#define MSR_IA32_MISC_ENABLE_SPLIT_LOCK_DISABLE	(1ULL << 4)
+#define MSR_IA32_MISC_ENABLE_L3CACHE_DISABLE	(1ULL << 6)
+#define MSR_IA32_MISC_ENABLE_SUPPRESS_LOCK	(1ULL << 8)
+#define MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE	(1ULL << 9)
+#define MSR_IA32_MISC_ENABLE_FERR		(1ULL << 10)
+#define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX	(1ULL << 10)
+#define MSR_IA32_MISC_ENABLE_TM2		(1ULL << 13)
+#define MSR_IA32_MISC_ENABLE_ADJ_PREF_DISABLE	(1ULL << 19)
+#define MSR_IA32_MISC_ENABLE_SPEEDSTEP_LOCK	(1ULL << 20)
+#define MSR_IA32_MISC_ENABLE_L1D_CONTEXT	(1ULL << 24)
+#define MSR_IA32_MISC_ENABLE_DCU_PREF_DISABLE	(1ULL << 37)
+#define MSR_IA32_MISC_ENABLE_TURBO_DISABLE	(1ULL << 38)
+#define MSR_IA32_MISC_ENABLE_IP_PREF_DISABLE	(1ULL << 39)
+
 /* Intel Model 6 */
 #define MSR_P6_EVNTSEL0			0x00000186
 #define MSR_P6_EVNTSEL1			0x00000187
-- 
1.6.0.6


--------------030008000100020504020502
Content-Type: text/x-patch;
 name="0002-x86-unmask-CPUID-levels-on-Intel-CPUs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-x86-unmask-CPUID-levels-on-Intel-CPUs.patch"

>From 128b048be5309bb43641a3c91d599b07158edfd9 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@linux.intel.com>
Date: Wed, 21 Jan 2009 15:04:32 -0800
Subject: [PATCH] x86: unmask CPUID levels on Intel CPUs

Impact: Fixes crashes with misconfigured BIOSes on XSAVE hardware

If the CPUID limit bit in MSR_IA32_MISC_ENABLE is set, clear it to
make all CPUID information available.  This is required for some
features to work, in particular XSAVE.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/intel.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8ea6929..43c1dcf 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -29,6 +29,16 @@
 
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
+	u64 misc_enable;
+
+	/* Unmask CPUID levels if masked */
+	if (!rdmsrl_safe(MSR_IA32_MISC_ENABLE, &misc_enable) &&
+	    (misc_enable & MSR_IA32_MISC_ENABLE_LIMIT_CPUID)) {
+		misc_enable &= ~MSR_IA32_MISC_ENABLE_LIMIT_CPUID;
+		wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		c->cpuid_level = cpuid_eax(0);
+	}
+
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-- 
1.6.0.6


--------------030008000100020504020502--
