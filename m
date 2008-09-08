Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYIHBBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYIHBBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 21:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYIHA7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:59:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:51963 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbYIHA7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:59:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ig0iJ/j/Lt/HqlLjqS9D6010BW8Wtwp4rbk0fVc0fgTcsP4N1aIeWhKguwc1VJNV1r
         rj8dTGZUEjOhg5XedcefAN/3SL/jySXB7mkk0smUCc8oAdGUOKUpuqGt5aFw5FTXiXtc
         sFnv4n0WSruSdvaVKyh3iO7RexMIH10j2HCOk=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 9/9] x86: little clean up intel.c/intel_64.c
Date: Sun,  7 Sep 2008 17:58:58 -0700
Message-Id: <1220835538-18280-9-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/intel.c    |    7 +++----
 arch/x86/kernel/cpu/intel_64.c |    8 +++-----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index bafa3a6..a669895 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -76,7 +76,7 @@ static void __cpuinit Intel_errata_workarounds(struct cpuinfo_x86 *c)
 /*
  * find out the number of processor cores on the die
  */
-static int __cpuinit num_cpu_cores(struct cpuinfo_x86 *c)
+static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
 {
 	unsigned int eax, ebx, ecx, edx;
 
@@ -183,7 +183,7 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
 		 * detection.
 		 */
-		c->x86_max_cores = num_cpu_cores(c);
+		c->x86_max_cores = intel_num_cpu_cores(c);
 		detect_ht(c);
 	}
 
@@ -210,9 +210,8 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 	if (cpu_has_xmm2)
 		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-	if (c->x86 == 15) {
+	if (c->x86 == 15)
 		set_cpu_cap(c, X86_FEATURE_P4);
-	}
 	if (c->x86 == 6)
 		set_cpu_cap(c, X86_FEATURE_P3);
 	if (cpu_has_ds) {
diff --git a/arch/x86/kernel/cpu/intel_64.c b/arch/x86/kernel/cpu/intel_64.c
index 14a2cd9..aef4f28 100644
--- a/arch/x86/kernel/cpu/intel_64.c
+++ b/arch/x86/kernel/cpu/intel_64.c
@@ -71,17 +71,15 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_BTS);
 		if (!(l1 & (1<<12)))
 			set_cpu_cap(c, X86_FEATURE_PEBS);
-	}
-
-
-	if (cpu_has_bts)
 		ds_init_intel(c);
+	}
 
 	if (c->x86 == 15)
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
 	if (c->x86 == 6)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
+	if (cpu_has_xmm2)
+		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
 
 	detect_extended_topology(c);
 	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY))
-- 
1.5.4.5

