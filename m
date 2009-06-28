Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZF1VEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZF1VEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZF1VEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:04:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:45344 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbZF1VEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:04:33 -0400
Message-ID: <4A47DAD6.9080200@kernel.org>
Date: Sun, 28 Jun 2009 14:04:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/perf_count: make perf_count_mask to local
References: <4A47DAB1.3090707@kernel.org>
In-Reply-To: <4A47DAB1.3090707@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


only used in init_hw_per_counters

[Impact: cleanup]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/cpu/perf_counter.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -25,8 +25,6 @@
 #include <asm/stacktrace.h>
 #include <asm/nmi.h>
 
-static u64 perf_counter_mask __read_mostly;
-
 struct cpu_hw_counters {
 	struct perf_counter	*counters[X86_PMC_IDX_MAX];
 	unsigned long		used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
@@ -1474,6 +1472,7 @@ static int amd_pmu_init(void)
 
 void __init init_hw_perf_counters(void)
 {
+	u64 perf_counter_mask;
 	int err;
 
 	pr_info("Performance Counters: ");
