Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZIOJhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZIOJhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZIOJg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:36:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:57474 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbZIOJgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:36:52 -0400
Date: Tue, 15 Sep 2009 09:36:30 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf sched: Fix 'perf sched latency' output on 32-bit systems
Message-ID: <tip-d11533893b31ab7806ff04bfa69ae646068610ce@git.kernel.org>
Git-Commit-ID: d11533893b31ab7806ff04bfa69ae646068610ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:36:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d11533893b31ab7806ff04bfa69ae646068610ce
Gitweb:     http://git.kernel.org/tip/d11533893b31ab7806ff04bfa69ae646068610ce
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 14 Sep 2009 18:22:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Sep 2009 18:22:53 +0200

perf sched: Fix 'perf sched latency' output on 32-bit systems

Before:

  -----------------------------------------------------------------------------------
   Task              |  Runtime ms | Switches | Average delay ms | Maximum delay ms |
  -----------------------------------------------------------------------------------
   perf              |4853313.251 ms |       10 | avg:    0.046 ms | max:    0.337 ms |
   flush-8:0         |2426659.202 ms |        5 | avg:    0.015 ms | max:    0.016 ms |
   sleep             |485331.966 ms |        1 | avg:    0.012 ms | max:    0.012 ms |
   ksoftirqd/1       |485331.320 ms |        1 | avg:    0.005 ms | max:    0.005 ms |
  -----------------------------------------------------------------------------------
   TOTAL:            |8250635.739 ms |       17 |
  ---------------------------------------------

After:

  -----------------------------------------------------------------------------------
   Task              |  Runtime ms | Switches | Average delay ms | Maximum delay ms |
  -----------------------------------------------------------------------------------
   perf              |    0.206 ms |       10 | avg:    0.046 ms | max:    0.337 ms |
   flush-8:0         |    2.680 ms |        5 | avg:    0.015 ms | max:    0.016 ms |
   sleep             |    0.662 ms |        1 | avg:    0.012 ms | max:    0.012 ms |
   ksoftirqd/1       |    0.015 ms |        1 | avg:    0.005 ms | max:    0.005 ms |
  -----------------------------------------------------------------------------------
   TOTAL:            |    3.563 ms |       17 |
  ---------------------------------------------

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 2ce87ef..f856a02 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -805,7 +805,7 @@ replay_wakeup_event(struct trace_wakeup_event *wakeup_event,
 	add_sched_event_wakeup(waker, timestamp, wakee);
 }
 
-static unsigned long cpu_last_switched[MAX_CPUS];
+static u64 cpu_last_switched[MAX_CPUS];
 
 static void
 replay_switch_event(struct trace_switch_event *switch_event,
