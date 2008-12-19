Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbYLSRJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbYLSRJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYLSRJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:09:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYLSRJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:09:41 -0500
Subject: [PATCH] x86: perf_counter.c intel_perfmon_event_map and
	max_intel_perfmon_events should be static
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       perfctr-devel@lists.sourceforge.net,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 22:37:58 +0530
Message-Id: <1229706478.7625.5.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, avoid sparse warnings, reduce kernel size a bit

Fixes these sparse warnings:
arch/x86/kernel/cpu/perf_counter.c:44:11: warning: symbol 'intel_perfmon_event_map' was not declared. Should it be static?
arch/x86/kernel/cpu/perf_counter.c:54:11: warning: symbol 'max_intel_perfmon_events' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/kernel/cpu/perf_counter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 8a154bd..bdbdb56 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -41,7 +41,7 @@ struct cpu_hw_counters {
  */
 static DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters);
 
-const int intel_perfmon_event_map[] =
+static const int intel_perfmon_event_map[] =
 {
   [PERF_COUNT_CYCLES]			= 0x003c,
   [PERF_COUNT_INSTRUCTIONS]		= 0x00c0,
@@ -51,7 +51,7 @@ const int intel_perfmon_event_map[] =
   [PERF_COUNT_BRANCH_MISSES]		= 0x00c5,
 };
 
-const int max_intel_perfmon_events = ARRAY_SIZE(intel_perfmon_event_map);
+static const int max_intel_perfmon_events = ARRAY_SIZE(intel_perfmon_event_map);
 
 /*
  * Propagate counter elapsed time into the generic counter.
-- 
1.5.5.1



