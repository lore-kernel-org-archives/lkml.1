Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbZEZN2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbZEZN2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbZEZN2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:28:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:57029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312AbZEZN2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:28:36 -0400
Date: Tue, 26 May 2009 13:27:33 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
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
Subject: [tip:perfcounters/core] perf top: Remove leftover NMI/IRQ bits
Message-ID: <tip-f91183fe3780d44849110a1653dfe8af7bc67aa4@git.kernel.org>
Git-Commit-ID: f91183fe3780d44849110a1653dfe8af7bc67aa4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 13:27:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f91183fe3780d44849110a1653dfe8af7bc67aa4
Gitweb:     http://git.kernel.org/tip/f91183fe3780d44849110a1653dfe8af7bc67aa4
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 26 May 2009 15:25:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 15:25:34 +0200

perf top: Remove leftover NMI/IRQ bits

79202b removed IRQ/NMI mode selection, so remove it from
perf top as well.

[ Impact: cleanup ]

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-top.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 87b925c..cacaa3c 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -8,7 +8,7 @@
    Sample output:
 
 ------------------------------------------------------------------------------
- KernelTop:    2669 irqs/sec  [NMI, cache-misses/cache-refs],  (all, cpu: 2)
+ KernelTop:    2669 irqs/sec  [cache-misses/cache-refs],  (all, cpu: 2)
 ------------------------------------------------------------------------------
 
              weight         RIP          kernel function
@@ -92,7 +92,6 @@ static __u64			count_filter		       = 100;
 static int			target_pid				= -1;
 static int			profile_cpu			= -1;
 static int			nr_cpus				=  0;
-static int			nmi				=  1;
 static unsigned int		realtime_prio			=  0;
 static int			group				=  0;
 static unsigned int		page_size;
@@ -198,10 +197,9 @@ static void print_sym_table(void)
 
 	printf(
 "------------------------------------------------------------------------------\n");
-	printf( " KernelTop:%8.0f irqs/sec  kernel:%4.1f%% [%s, ",
+	printf( " KernelTop:%8.0f irqs/sec  kernel:%4.1f%% [",
 		events_per_sec,
-		100.0 - (100.0*((events_per_sec-kevents_per_sec)/events_per_sec)),
-		nmi ? "NMI" : "IRQ");
+		100.0 - (100.0*((events_per_sec-kevents_per_sec)/events_per_sec)));
 
 	if (nr_counters == 1)
 		printf("%d ", event_count[0]);
@@ -637,7 +635,7 @@ static int __cmd_top(void)
 			hw_event.config		= event_id[counter];
 			hw_event.irq_period	= event_count[counter];
 			hw_event.record_type	= PERF_RECORD_IP | PERF_RECORD_TID;
-			hw_event.nmi		= nmi;
+			hw_event.nmi		= 1;
 			hw_event.mmap		= use_mmap;
 			hw_event.munmap		= use_munmap;
 			hw_event.freq		= freq;
