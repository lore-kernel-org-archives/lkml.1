Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbZLJJKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbZLJJKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 04:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757990AbZLJJKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 04:10:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52663 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757926AbZLJJKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 04:10:32 -0500
Message-ID: <4B20BAA6.7010609@cn.fujitsu.com>
Date: Thu, 10 Dec 2009 17:08:54 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf_event: fix variable initialization in other path
References: <4B2075B0.10805@cn.fujitsu.com> <1260422135.4165.3.camel@twins>
In-Reply-To: <1260422135.4165.3.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix variable initialization in other path
[Commit-ID:  21140f4d3387aa2213f1deea0128df1dbf924379 is not clean]

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kernel/cpu/perf_event.c |    4 ++++
 kernel/perf_event.c              |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index d35f260..1342f23 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1632,6 +1632,7 @@ static void intel_pmu_drain_bts_buffer(struct cpu_hw_events *cpuc)
 
 	data.period	= event->hw.last_period;
 	data.addr	= 0;
+	data.raw	= NULL;
 	regs.ip		= 0;
 
 	/*
@@ -1749,6 +1750,7 @@ static int p6_pmu_handle_irq(struct pt_regs *regs)
 	u64 val;
 
 	data.addr = 0;
+	data.raw = NULL;
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -1794,6 +1796,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	u64 ack, status;
 
 	data.addr = 0;
+	data.raw = NULL;
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -1857,6 +1860,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 	u64 val;
 
 	data.addr = 0;
+	data.raw = NULL;
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 41c2dde..6e2888d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4299,6 +4299,7 @@ void perf_bp_event(struct perf_event *bp, void *data)
 	struct perf_sample_data sample;
 	struct pt_regs *regs = data;
 
+	sample.raw = NULL;
 	sample.addr = bp->attr.bp_addr;
 
 	if (!perf_exclude_event(bp, regs))
-- 
1.6.1.2

