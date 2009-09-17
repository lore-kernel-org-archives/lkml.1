Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbZIQSIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbZIQSIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758906AbZIQSIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:08:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:44928 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303AbZIQSH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:07:59 -0400
Date: Thu, 17 Sep 2009 18:07:09 GMT
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
Subject: [tip:perfcounters/core] perf sched: Determine the number of CPUs automatically
Message-ID: <tip-5349256ab12dcbc766495cd1cf3651f7203f8564@git.kernel.org>
Git-Commit-ID: 5349256ab12dcbc766495cd1cf3651f7203f8564
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 18:07:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5349256ab12dcbc766495cd1cf3651f7203f8564
Gitweb:     http://git.kernel.org/tip/5349256ab12dcbc766495cd1cf3651f7203f8564
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 17 Sep 2009 18:24:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Sep 2009 18:24:55 +0200

perf sched: Determine the number of CPUs automatically

For 'perf sched map' output, determine max_cpu automatically,
instead of the static default of 15.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index f67e351..947fd71 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1347,7 +1347,7 @@ process_sched_wakeup_event(struct raw_event_sample *raw,
  * Track the current task - that way we can know whether there's any
  * weird events, such as a task being switched away that is not current.
  */
-static int max_cpu = 15;
+static int max_cpu;
 
 static u32 curr_pid[MAX_CPUS] = { [0 ... MAX_CPUS-1] = -1 };
 
@@ -1818,6 +1818,9 @@ static struct trace_sched_handler map_ops  = {
 
 static void __cmd_map(void)
 {
+	max_cpu = system("exit `grep ^processor /proc/cpuinfo  | wc -l`");
+	max_cpu = WEXITSTATUS(max_cpu)-1;
+
 	setup_pager();
 	read_events();
 	print_bad_events();
