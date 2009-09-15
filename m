Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbZIOJhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbZIOJhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZIOJhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:37:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:57494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbZIOJhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:37:13 -0400
Date: Tue, 15 Sep 2009 09:36:43 GMT
From: tip-bot for mingo <mingo@europe (none)>
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
Subject: [tip:perfcounters/core] perf sched: Print PIDs too
Message-ID: <tip-08f69e6c2e59b3d73343f8c9ecf758e0133dbc22@git.kernel.org>
Git-Commit-ID: 08f69e6c2e59b3d73343f8c9ecf758e0133dbc22
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:36:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08f69e6c2e59b3d73343f8c9ecf758e0133dbc22
Gitweb:     http://git.kernel.org/tip/08f69e6c2e59b3d73343f8c9ecf758e0133dbc22
Author:     mingo <mingo@europe.(none)>
AuthorDate: Mon, 14 Sep 2009 18:30:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Sep 2009 18:34:57 +0200

perf sched: Print PIDs too

Often it's useful to know the PID of the task as well - print it
out too.

( While at it, reformat the output to be a bit more
  paste-into-commit-logs friendly. )

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index f856a02..93ef7b2 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1144,9 +1144,9 @@ static void output_lat_thread(struct task_atoms *atom_list)
 	all_runtime += atom_list->total_runtime;
 	all_count += atom_list->nb_atoms;
 
-	ret = printf(" %s ", atom_list->thread->comm);
+	ret = printf("  %s-%d ", atom_list->thread->comm, atom_list->thread->pid);
 
-	for (i = 0; i < 19 - ret; i++)
+	for (i = 0; i < 24 - ret; i++)
 		printf(" ");
 
 	avg = atom_list->total_lat / atom_list->nb_atoms;
@@ -1296,9 +1296,9 @@ static void __cmd_lat(void)
 	read_events();
 	sort_lat();
 
-	printf("-----------------------------------------------------------------------------------\n");
-	printf(" Task              |  Runtime ms | Switches | Average delay ms | Maximum delay ms |\n");
-	printf("-----------------------------------------------------------------------------------\n");
+	printf("\n ---------------------------------------------------------------------------------------\n");
+	printf("  Task                  |  Runtime ms | Switches | Average delay ms | Maximum delay ms |\n");
+	printf(" ---------------------------------------------------------------------------------------\n");
 
 	next = rb_first(&sorted_atom_root);
 
@@ -1310,8 +1310,8 @@ static void __cmd_lat(void)
 		next = rb_next(next);
 	}
 
-	printf("-----------------------------------------------------------------------------------\n");
-	printf(" TOTAL:            |%9.3f ms |%9Ld |",
+	printf(" ---------------------------------------------------------------------------------------\n");
+	printf("  TOTAL:                |%9.3f ms |%9Ld |",
 		(double)all_runtime/1e6, all_count);
 
 	if (unordered_timestamps && nr_timestamps) {
@@ -1321,7 +1321,7 @@ static void __cmd_lat(void)
 		printf("\n");
 	}
 
-	printf("---------------------------------------------\n");
+	printf(" -------------------------------------------------\n\n");
 }
 
 static struct trace_sched_handler *trace_handler;
