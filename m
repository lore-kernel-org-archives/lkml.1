Return-Path: <linux-kernel-owner+w=401wt.eu-S932697AbXB1OVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbXB1OVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932702AbXB1OVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:21:50 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:20464 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932697AbXB1OVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:21:49 -0500
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Date: Wed, 28 Feb 2007 15:21:17 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] i386: add the X86_FEATURE_SYNC_RDTSC flag
Message-ID: <20070228142117.GD19452@amd.com>
References: <20070228140501.GA19452@amd.com>
MIME-Version: 1.0
In-Reply-To: <20070228140501.GA19452@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 28 Feb 2007 14:21:30.0612 (UTC)
 FILETIME=[BDA6F340:01C75B43]
X-WSS-ID: 69FB50662X01582831-01-01
Content-Type: multipart/mixed;
 boundary=ALfTUftag+2gvp1h
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ALfTUftag+2gvp1h
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

--ALfTUftag+2gvp1h
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

--ALfTUftag+2gvp1h--


