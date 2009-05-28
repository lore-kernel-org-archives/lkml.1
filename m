Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZE1Jrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZE1Jrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbZE1JrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:47:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:48547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbZE1JrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:47:23 -0400
Date: Thu, 28 May 2009 09:46:12 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Fix perf_counter_init_task() on !CONFIG_PERF_COUNTERS
Message-ID: <tip-d3e78ee3d015dac1794433abb6403b6fc8e70e10@git.kernel.org>
Git-Commit-ID: d3e78ee3d015dac1794433abb6403b6fc8e70e10
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 May 2009 09:46:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3e78ee3d015dac1794433abb6403b6fc8e70e10
Gitweb:     http://git.kernel.org/tip/d3e78ee3d015dac1794433abb6403b6fc8e70e10
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 28 May 2009 11:41:50 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 28 May 2009 11:42:16 +0200

perf_counter: Fix perf_counter_init_task() on !CONFIG_PERF_COUNTERS

Pointed out by compiler warnings:

   tip/include/linux/perf_counter.h:644: warning: no return statement in function returning non-void

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 2b16ed3..a65ddc5 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -641,7 +641,7 @@ perf_counter_task_sched_out(struct task_struct *task,
 			    struct task_struct *next, int cpu)		{ }
 static inline void
 perf_counter_task_tick(struct task_struct *task, int cpu)		{ }
-static inline int perf_counter_init_task(struct task_struct *child)	{ }
+static inline int perf_counter_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_counter_exit_task(struct task_struct *child)	{ }
 static inline void perf_counter_do_pending(void)			{ }
 static inline void perf_counter_print_debug(void)			{ }
