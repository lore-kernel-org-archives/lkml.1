Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbZEKRBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbZEKRBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbZEKRAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:00:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:43635 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757873AbZEKRAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:00:06 -0400
Subject: [PATCH 7/15 -tip] x86: Add cpufeature for Miscellaneous Features
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242060567.5139.16.camel@ht.satnam>
References: <1242058494.5139.7.camel@ht.satnam>
	 <1242060119.5139.9.camel@ht.satnam>  <1242060207.5139.11.camel@ht.satnam>
	 <1242060254.5139.12.camel@ht.satnam>  <1242060301.5139.13.camel@ht.satnam>
	 <1242060523.5139.15.camel@ht.satnam>  <1242060567.5139.16.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 11 May 2009 22:20:01 +0530
Message-Id: <1242060601.5139.17.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


X86_FEATURE_MISC : Miscellaneous Features IA32_MISC_ENABLE

IA32_MISC_ENABLE is introduces as Arctitectural MSR on 0F_00H,
So enable X86_FEATURE_MISC for Family 6 and 0xF and disabling for P6.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/intel.c       |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 8f789b5..f9e8a02 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -161,6 +161,7 @@
 #define X86_FEATURE_HARD_POWERON (7*32+ 6) /* Hard Poweron configuration*/
 #define X86_FEATURE_SOFT_POWERON (7*32+ 7) /* Soft Poweron configuration*/
 #define X86_FEATURE_FSB_FREQ 	(7*32+ 8) /* Scaleable bus speed	*/
+#define X86_FEATURE_MISC 	(7*32+ 9) /* Miscellaneous features	*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index aca1c7d..f63b151 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -393,10 +393,15 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 	/* Set cpufeatures for miscellaneous MSRs			*/
 	if (c->x86 == 6) {
+		/* Miscellaneous Features IA32_MISC_ENABLE		*/
+		set_cpu_cap(c, X86_FEATURE_MISC);
+
 		switch (c->x86_model) {
 		case 1:					/* Pentium Pro	*/
 			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
 			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			/* !Miscellaneous Features IA32_MISC_ENABLE	*/
+			clear_cpu_cap(c, X86_FEATURE_MISC);
 			break;
 
 		case 3: case 5:				/* Pentium II	*/
@@ -407,6 +412,8 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_CACHE);
 			/* BBL_CR_CTL* MSRs (Cache control MSRs)	*/
 			set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+			/* !Miscellaneous Features IA32_MISC_ENABLE	*/
+			clear_cpu_cap(c, X86_FEATURE_MISC);
 			break;
 
 		case 9:	case 0xD:			/* Pentium M	*/
@@ -451,6 +458,9 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		 * Frequency configuration MSR_EBC_FREQUENCY_ID
 		 */
 		set_cpu_cap(c, X86_FEATURE_SOFT_POWERON);
+
+		/* Miscellaneous Features IA32_MISC_ENABLE		*/
+		set_cpu_cap(c, X86_FEATURE_MISC);
 	}
 }
 
-- 
1.6.0.6



