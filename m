Return-Path: <linux-kernel-owner+w=401wt.eu-S2992841AbXCIPPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992841AbXCIPPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 10:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992840AbXCIPPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 10:15:09 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:9765 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993105AbXCIPPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 10:15:06 -0500
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Fri, 9 Mar 2007 16:13:57 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4 TRY#3] i386: add the X86_FEATURE_SYNC_RDTSC flag
Message-ID: <20070309151357.GD13481@amd.com>
References: <20070309150825.GA13481@amd.com>
MIME-Version: 1.0
In-Reply-To: <20070309150825.GA13481@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 09 Mar 2007 15:14:47.0259 (UTC)
 FILETIME=[ACB852B0:01C7625D]
X-WSS-ID: 69EFA6602EW578616-01-01
Content-Type: multipart/mixed;
 boundary="IpbVkmxF4tDyP/Kb"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds the  X86_FEATURE_SYNC_RDTSC to the i386 architecture.
This is very helpfull to simplify the get_cycles_sync() function and
remove the #ifdefs from it.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG

--IpbVkmxF4tDyP/Kb
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=i386-x86_sync_rdtsc.patch
Content-Transfer-Encoding: 7bit

diff --git a/arch/i386/kernel/cpu/amd.c b/arch/i386/kernel/cpu/amd.c
index 41cfea5..11f5730 100644
--- a/arch/i386/kernel/cpu/amd.c
+++ b/arch/i386/kernel/cpu/amd.c
@@ -241,6 +241,8 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 
 	if (cpuid_eax(0x80000000) >= 0x80000006)
 		num_cache_leaves = 3;
+
+	clear_bit(X86_FEATURE_SYNC_RDTSC, c->x86_capability);
 }
 
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 * c, unsigned int size)
diff --git a/arch/i386/kernel/cpu/intel.c b/arch/i386/kernel/cpu/intel.c
index 56fe265..403a495 100644
--- a/arch/i386/kernel/cpu/intel.c
+++ b/arch/i386/kernel/cpu/intel.c
@@ -188,8 +188,11 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 	}
 #endif
 
-	if (c->x86 == 15)
+	if (c->x86 == 15) {
 		set_bit(X86_FEATURE_P4, c->x86_capability);
+		set_bit(X86_FEATURE_SYNC_RDTSC, c->x86_capability);
+	} else
+		clear_bit(X86_FEATURE_SYNC_RDTSC, c->x86_capability);
 	if (c->x86 == 6) 
 		set_bit(X86_FEATURE_P3, c->x86_capability);
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
diff --git a/include/asm-i386/cpufeature.h b/include/asm-i386/cpufeature.h
index 3f92b94..a9f1f01 100644
--- a/include/asm-i386/cpufeature.h
+++ b/include/asm-i386/cpufeature.h
@@ -75,6 +76,7 @@
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
 #define X86_FEATURE_PEBS	(3*32+12)  /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
+#define X86_FEATURE_SYNC_RDTSC  (3*32+14)  /* RDTSC is serializing */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */

--IpbVkmxF4tDyP/Kb--


