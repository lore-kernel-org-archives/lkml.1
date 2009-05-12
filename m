Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbZELPqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbZELPqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757766AbZELPqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:46:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:51040 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbZELPqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:46:35 -0400
Subject: [PATCH 1/10 -tip] x86: Add cpufeature for Processor Name
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
In-Reply-To: <1242142530.2547.11.camel@ht.satnam>
References: <1242142530.2547.11.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 12 May 2009 21:07:03 +0530
Message-Id: <1242142623.2547.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Processor Name / Brand String (Function 8000_0002h, 8000_0003h, 8000_0004h)
Functions 8000_0002h, 8000_0003h, and 8000_0004h each return up to 16 ASCII
bytes of the processor name in the EAX, EBX, ECX and EDX registers.

X86_FEATURE_PNAME will be useful for displaying MSRs like AMD:
MSRC001_00[35:30] Processor Name String Registers

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    5 +++--
 arch/x86/kernel/cpu/common.c      |   10 ++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 13cc6a5..e1a4cc4 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -153,8 +153,9 @@
  * Auxiliary flags: Linux defined - For features scattered in various
  * CPUID levels like 0x6, 0xA etc
  */
-#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
-#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
+#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration	*/
+#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer	*/
+#define X86_FEATURE_PNAME	(7*32+ 2) /* Processor Name		*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e7fd5c4..542684c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -563,6 +563,16 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 		}
 	}
 
+	/*
+	 * Processor Name / Brand String
+	 * (Function 8000_0002h, 8000_0003h, 8000_0004h)
+	 * Functions 8000_0002h, 8000_0003h, and 8000_0004h each return up to
+	 * 16 ASCII bytes of the processor name in the EAX, EBX, ECX and EDX
+	 * registers.
+	 */
+	if (c->extended_cpuid_level >= 0x80000004)
+		set_cpu_cap(c, X86_FEATURE_PNAME);
+
 	if (c->extended_cpuid_level >= 0x80000008) {
 		u32 eax = cpuid_eax(0x80000008);
 
-- 
1.6.0.6



