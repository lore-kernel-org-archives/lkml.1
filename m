Return-Path: <linux-kernel-owner+w=401wt.eu-S1763428AbZFLLwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763428AbZFLLwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZFLLwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:52:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:44481 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZFLLwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:52:10 -0400
Date: Fri, 12 Jun 2009 11:51:29 GMT
From: tip-bot for Yong Wang <yong.y.wang@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       yong.y.wang@intel.com, yong.y.wang@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, yong.y.wang@linux.intel.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, yong.y.wang@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090612080855.GA2286@ywang-moblin2.bj.intel.com>
References: <20090612080855.GA2286@ywang-moblin2.bj.intel.com>
Subject: [tip:perfcounters/core] perf_counter/x86: Add a quirk for Atom processors
Message-ID: <tip-dff5da6d09daaab40a8741dce0ed3c2e94079de2@git.kernel.org>
Git-Commit-ID: dff5da6d09daaab40a8741dce0ed3c2e94079de2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 12 Jun 2009 11:51:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dff5da6d09daaab40a8741dce0ed3c2e94079de2
Gitweb:     http://git.kernel.org/tip/dff5da6d09daaab40a8741dce0ed3c2e94079de2
Author:     Yong Wang <yong.y.wang@linux.intel.com>
AuthorDate: Fri, 12 Jun 2009 16:08:55 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 12 Jun 2009 13:48:32 +0200

perf_counter/x86: Add a quirk for Atom processors

The fixed-function performance counters do not work on current Atom
processors. Use the general-purpose ones instead.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20090612080855.GA2286@ywang-moblin2.bj.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 895c82e..275bc14 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -968,6 +968,13 @@ fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
 	if (!x86_pmu.num_counters_fixed)
 		return -1;
 
+	/*
+	 * Quirk, IA32_FIXED_CTRs do not work on current Atom processors:
+	 */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+					boot_cpu_data.x86_model == 28)
+		return -1;
+
 	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
 
 	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_HW_INSTRUCTIONS)))
