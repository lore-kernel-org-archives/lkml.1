Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0CLJzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:55:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:53816 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293Ab0CLJzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:55:43 -0500
Date: Fri, 12 Mar 2010 09:54:42 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, gorcunov@openvz.org,
       peterz@infradead.org, gorcunov@gmail.com, fweisbec@gmail.com,
       robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
       linux-kernel@vger.kernel.org, gorcunov@openvz.org, peterz@infradead.org,
       gorcunov@gmail.com, robert.richter@amd.com, fweisbec@gmail.com,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100311215016.GG25162@lenovo>
References: <20100311215016.GG25162@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/x86] x86, perf: Fix NULL deref on not assigned x86_pmu
Message-ID: <tip-0b861225a5890f22445f08ca9cc7a87cff276ff7@git.kernel.org>
Git-Commit-ID: 0b861225a5890f22445f08ca9cc7a87cff276ff7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Mar 2010 09:54:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b861225a5890f22445f08ca9cc7a87cff276ff7
Gitweb:     http://git.kernel.org/tip/0b861225a5890f22445f08ca9cc7a87cff276ff7
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Fri, 12 Mar 2010 00:50:16 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 12 Mar 2010 10:18:42 +0100

x86, perf: Fix NULL deref on not assigned x86_pmu

In case of not assigned x86_pmu and software events NULL dereference may
being hit via x86_pmu::schedule_events method.

Fix it by checking if x86_pmu is initialized at all.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100311215016.GG25162@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e6a3f5f..5586a02 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1269,6 +1269,9 @@ int hw_perf_group_sched_in(struct perf_event *leader,
 	int assign[X86_PMC_IDX_MAX];
 	int n0, n1, ret;
 
+	if (!x86_pmu_initialized())
+		return 0;
+
 	/* n0 = total number of events */
 	n0 = collect_events(cpuc, leader, true);
 	if (n0 < 0)
