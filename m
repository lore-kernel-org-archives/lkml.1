Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbZFCSZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbZFCSZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZFCSZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:25:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:35391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbZFCSZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:25:19 -0400
Date: Wed, 3 Jun 2009 18:24:35 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Clean up old kerneltop references
Message-ID: <tip-f2521b6e4c365bd0aac61b2c346e6e9f22607e31@git.kernel.org>
Git-Commit-ID: f2521b6e4c365bd0aac61b2c346e6e9f22607e31
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 18:24:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2521b6e4c365bd0aac61b2c346e6e9f22607e31
Gitweb:     http://git.kernel.org/tip/f2521b6e4c365bd0aac61b2c346e6e9f22607e31
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 3 Jun 2009 19:17:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 19:17:25 +0200

perf_counter tools: Clean up old kerneltop references

kerneltop has been replaced with perf top - so fix up a few
remaining references to it in display text and error messages.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |    6 +++---
 Documentation/perf_counter/builtin-top.c    |   14 ++++++--------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index cea5b8d..fa62525 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -357,7 +357,8 @@ static void open_counters(int cpu, pid_t pid)
 
 		if (fd[nr_cpu][counter] < 0) {
 			int err = errno;
-			printf("kerneltop error: syscall returned with %d (%s)\n",
+
+			error("syscall returned with %d (%s)\n",
 					fd[nr_cpu][counter], strerror(err));
 			if (err == EPERM)
 				printf("Are you root?\n");
@@ -382,8 +383,7 @@ static void open_counters(int cpu, pid_t pid)
 		mmap_array[nr_cpu][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
 				PROT_READ, MAP_SHARED, fd[nr_cpu][counter], 0);
 		if (mmap_array[nr_cpu][counter].base == MAP_FAILED) {
-			printf("kerneltop error: failed to mmap with %d (%s)\n",
-					errno, strerror(errno));
+			error("failed to mmap with %d (%s)\n", errno, strerror(errno));
 			exit(-1);
 		}
 	}
diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index a639352..16a6184 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -208,7 +208,7 @@ static void print_sym_table(void)
 
 	printf(
 "------------------------------------------------------------------------------\n");
-	printf( " KernelTop:%8.0f irqs/sec  kernel:%4.1f%% [",
+	printf( "   PerfTop:%8.0f irqs/sec  kernel:%4.1f%% [",
 		events_per_sec,
 		100.0 - (100.0*((events_per_sec-kevents_per_sec)/events_per_sec)));
 
@@ -281,7 +281,7 @@ static void print_sym_table(void)
 
 static void *display_thread(void *arg)
 {
-	printf("KernelTop refresh period: %d seconds\n", delay_secs);
+	printf("PerfTop refresh period: %d seconds\n", delay_secs);
 
 	while (!sleep(delay_secs))
 		print_sym_table();
@@ -564,7 +564,8 @@ static int __cmd_top(void)
 			fd[i][counter] = sys_perf_counter_open(&attr, target_pid, cpu, group_fd, 0);
 			if (fd[i][counter] < 0) {
 				int err = errno;
-				printf("kerneltop error: syscall returned with %d (%s)\n",
+
+				error("syscall returned with %d (%s)\n",
 					fd[i][counter], strerror(err));
 				if (err == EPERM)
 					printf("Are you root?\n");
@@ -588,11 +589,8 @@ static int __cmd_top(void)
 			mmap_array[i][counter].mask = mmap_pages*page_size - 1;
 			mmap_array[i][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
 					PROT_READ, MAP_SHARED, fd[i][counter], 0);
-			if (mmap_array[i][counter].base == MAP_FAILED) {
-				printf("kerneltop error: failed to mmap with %d (%s)\n",
-						errno, strerror(errno));
-				exit(-1);
-			}
+			if (mmap_array[i][counter].base == MAP_FAILED)
+				die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 		}
 	}
 
