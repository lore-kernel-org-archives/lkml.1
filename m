Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbZEKRA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbZEKRA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756915AbZEKQ7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:59:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:34785 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208AbZEKQ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:59:44 -0400
Subject: [PATCH 5/15 -tip] x86: Add cpufeature for Hard and Soft Poweron
 configuration
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242060301.5139.13.camel@ht.satnam>
References: <1242058494.5139.7.camel@ht.satnam>
	 <1242060119.5139.9.camel@ht.satnam>  <1242060207.5139.11.camel@ht.satnam>
	 <1242060254.5139.12.camel@ht.satnam>  <1242060301.5139.13.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 11 May 2009 22:18:43 +0530
Message-Id: <1242060523.5139.15.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


X86_FEATURE_HARD_POWERON : Hard Poweron configuration MSR_EBL_CR_POWERON

X86_FEATURE_SOFT_POWERON : Soft Poweron configuration MSR_EBC_SOFT_POWERON
                         : Frequency configuration MSR_EBC_FREQUENCY_ID

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    2 ++
 arch/x86/kernel/cpu/intel.c       |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index da88aa0..97e54ad 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -158,6 +158,8 @@
 #define X86_FEATURE_MICROCODE	(7*32+ 3) /* Microcode update		*/
 #define X86_FEATURE_CACHE	(7*32+ 4) /* BBL_CR_* MSRs (PII & PIII)	*/
 #define X86_FEATURE_CACHE_CTL	(7*32+ 5) /* Cache control MSRs		*/
+#define X86_FEATURE_HARD_POWERON (7*32+ 6) /* Hard Poweron configuration*/
+#define X86_FEATURE_SOFT_POWERON (7*32+ 7) /* Soft Poweron configuration*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index cb198ed..239048d 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -394,8 +394,15 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 	/* Set cpufeatures for miscellaneous MSRs			*/
 	if (c->x86 == 6) {
 		switch (c->x86_model) {
+		case 1:					/* Pentium Pro	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			break;
+
 		case 3: case 5:				/* Pentium II	*/
 		case 7: case 8: case 0xA: case 0xB:	/* Pentium III	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
 			/* BBL_CR_* MSRs (Pentium II & III processors)	*/
 			set_cpu_cap(c, X86_FEATURE_CACHE);
 			/* BBL_CR_CTL* MSRs (Cache control MSRs)	*/
@@ -406,11 +413,37 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		case 0xE:				/* Core		*/
 		case 0xF: case 0x17:			/* Core 2	*/
 		case 0x1C:				/* ATOM		*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
 			/* BBL_CR_CTL* MSRs (Cache control MSRs)	*/
 			set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
 			break;
+
+		case 0x16:				/* Celeron Core	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			break;
+
+		case 0x1D:				/* Xeon MP	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			/*
+			 * Soft Poweron configuration MSR_EBC_SOFT_POWERON
+			 * Frequency configuration MSR_EBC_FREQUENCY_ID
+			 */
+			set_cpu_cap(c, X86_FEATURE_SOFT_POWERON);
+			break;
 		}
 	}
+	if (c->x86 == 0xF) {
+		/* Hard Poweron configuration MSR_EBL_CR_POWERON	*/
+		set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+		/*
+		 * Soft Poweron configuration MSR_EBC_SOFT_POWERON
+		 * Frequency configuration MSR_EBC_FREQUENCY_ID
+		 */
+		set_cpu_cap(c, X86_FEATURE_SOFT_POWERON);
+	}
 }
 
 #ifdef CONFIG_X86_32
-- 
1.6.0.6



