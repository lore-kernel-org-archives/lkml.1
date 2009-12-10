Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbZLJQZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbZLJQZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758514AbZLJQZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:25:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:56974 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757291AbZLJQZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:25:09 -0500
Date: Thu, 10 Dec 2009 16:24:32 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B20BAA6.7010609@cn.fujitsu.com>
References: <4B20BAA6.7010609@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Fix variable initialization in other codepaths
Message-ID: <tip-5e855db5d8fec44e6604eb245aa9077bbd3f0d05@git.kernel.org>
Git-Commit-ID: 5e855db5d8fec44e6604eb245aa9077bbd3f0d05
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e855db5d8fec44e6604eb245aa9077bbd3f0d05
Gitweb:     http://git.kernel.org/tip/5e855db5d8fec44e6604eb245aa9077bbd3f0d05
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Thu, 10 Dec 2009 17:08:54 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 17:23:02 +0100

perf_event: Fix variable initialization in other codepaths

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <4B20BAA6.7010609@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index 3a5d6c4..d891ec4 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4300,6 +4300,7 @@ void perf_bp_event(struct perf_event *bp, void *data)
 	struct perf_sample_data sample;
 	struct pt_regs *regs = data;
 
+	sample.raw = NULL;
 	sample.addr = bp->attr.bp_addr;
 
 	if (!perf_exclude_event(bp, regs))
