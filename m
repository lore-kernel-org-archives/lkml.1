Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZA0CI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZA0CI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 21:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZA0CIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 21:08:49 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:50631 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZA0CIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 21:08:49 -0500
Message-ID: <497E6CAF.9030707@ct.jp.nec.com>
Date: Mon, 26 Jan 2009 18:08:47 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: intel_cacheinfo: fix compiler warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: fix compiler warning

fix the following warning;
  CC      arch/x86/kernel/cpu/intel_cacheinfo.o
arch/x86/kernel/cpu/intel_cacheinfo.c:314: warning: 'cpuid4_cache_lookup' defined but not used

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index d5c4605..03f93c5 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -309,15 +309,6 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
 	return 0;
 }
 
-static int
-__cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
-{
-	struct _cpuid4_info_regs *leaf_regs =
-		(struct _cpuid4_info_regs *)this_leaf;
-
-	return cpuid4_cache_lookup_regs(index, leaf_regs);
-}
-
 static int __cpuinit find_num_cache_leaves(void)
 {
 	unsigned int		eax, ebx, ecx, edx;
@@ -558,6 +549,15 @@ static void __cpuinit free_cache_attributes(unsigned int cpu)
 	per_cpu(cpuid4_info, cpu) = NULL;
 }
 
+static int
+__cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
+{
+	struct _cpuid4_info_regs *leaf_regs =
+		(struct _cpuid4_info_regs *)this_leaf;
+
+	return cpuid4_cache_lookup_regs(index, leaf_regs);
+}
+
 static void __cpuinit get_cpu_leaves(void *_retval)
 {
 	int j, *retval = _retval, cpu = smp_processor_id();
-- 
1.6.0.4

