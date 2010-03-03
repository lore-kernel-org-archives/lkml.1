Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab0CCAQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:16:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:1908 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab0CCAQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:16:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,570,1262592000"; 
   d="scan'208";a="545465736"
Message-Id: <20100303000849.141285000@intel.com>
References: <20100303000649.757684000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 02 Mar 2010 16:06:50 -0800
From: venkatesh.pallipadi@intel.com
To: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 1/2] x86: Look for IA32_ENERGY_PERF_BIAS support
Content-Disposition: inline; filename=0001-x86-Look-for-IA32_ENERGY_PERF_BIAS-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new hardware feature, which lets system software to set
Energy Performance Preference. This is a opaque knob in the form of
IA32_ENERGY_PERF_BIAS MSR, which has a 4 bit Energy Performance
Preference Hint. When supported, hardware can use this hint to resolve
energy-performance tradeoffs. The support for this feature is indicated
by CPUID.06H.ECX.bit3. Refer to Intel Architectures Software Developer's
Manual for more info.

This patch, looks up for the support of this feature. It shows up as
"epb" in /proc/cpuinfo flags, when supported.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/include/asm/msr-index.h           |    2 ++
 arch/x86/kernel/cpu/addon_cpuid_features.c |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0cd82d0..0e1d52c 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -161,6 +161,7 @@
  */
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
+#define X86_FEATURE_EPB		(7*32+ 2) /* IA32_ENERGY_PERF_BIAS support */
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1cd58cd..feeb918 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -230,6 +230,8 @@
 
 #define MSR_IA32_MISC_ENABLE		0x000001a0
 
+#define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
+
 /* MISC_ENABLE bits: architectural */
 #define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
 #define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 97ad79c..3bc5eda 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -32,6 +32,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
 		{ X86_FEATURE_IDA, CR_EAX, 1, 0x00000006 },
 		{ X86_FEATURE_ARAT, CR_EAX, 2, 0x00000006 },
+		{ X86_FEATURE_EPB, CR_ECX, 3, 0x00000006 },
 		{ X86_FEATURE_NPT,   CR_EDX, 0, 0x8000000a },
 		{ X86_FEATURE_LBRV,  CR_EDX, 1, 0x8000000a },
 		{ X86_FEATURE_SVML,  CR_EDX, 2, 0x8000000a },
-- 
1.6.0.6

-- 

