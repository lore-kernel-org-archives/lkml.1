Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbZEKQ7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbZEKQ7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbZEKQ7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:59:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:34753 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756854AbZEKQ7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:59:21 -0400
Subject: [PATCH 3/15 -tip] x86: Add cpufeature for Microcode update
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242060207.5139.11.camel@ht.satnam>
References: <1242058494.5139.7.camel@ht.satnam>
	 <1242060119.5139.9.camel@ht.satnam>  <1242060207.5139.11.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 11 May 2009 22:14:14 +0530
Message-Id: <1242060254.5139.12.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Setting microcode update feature to friendly access of UCODE MSRs like:
1. IA32_PLATFORM_ID (Intel)
2. IA32_UCODE_WRITE (Intel)
3. IA32_UCODE_REV (Intel)
4. MSR_AMD64_PATCH_LEVEL (AMD)
5. MSR_AMD64_PATCH_LOADER (AMD)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    7 ++++---
 arch/x86/kernel/microcode_amd.c   |    3 +++
 arch/x86/kernel/microcode_intel.c |    3 +++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 776d12c..06b0919 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -152,9 +152,10 @@
  * Auxiliary flags: Linux defined - For features scattered in various
  * CPUID levels like 0x6, 0xA etc
  */
-#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
-#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
-#define X86_FEATURE_PNAME	(7*32+ 2) /* Processor Name */
+#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration	*/
+#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer	*/
+#define X86_FEATURE_PNAME	(7*32+ 2) /* Processor Name		*/
+#define X86_FEATURE_MICROCODE	(7*32+ 3) /* Microcode update		*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 453b579..ec9e5e2 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -95,6 +95,9 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 		       "supported\n", cpu, c->x86);
 		return -1;
 	}
+	/* setting microcode update feature to friendly access of UCODE MSRs */
+	set_cpu_cap(c, X86_FEATURE_MICROCODE);
+
 	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
 	printk(KERN_INFO "microcode: CPU%d: patch_level=0x%x\n", cpu, csig->rev);
 	return 0;
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 149b9ec..2fcaa58 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -168,6 +168,9 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 		return -1;
 	}
 
+	/* setting microcode update feature to friendly access of UCODE MSRs */
+	set_cpu_cap(c, X86_FEATURE_MICROCODE);
+
 	csig->sig = cpuid_eax(0x00000001);
 
 	if ((c->x86_model >= 5) || (c->x86 > 6)) {
-- 
1.6.0.6



