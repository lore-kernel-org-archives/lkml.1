Return-Path: <linux-kernel-owner+w=401wt.eu-S933702AbZIDK0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702AbZIDK0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 06:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933514AbZIDK0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 06:26:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:48672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933571AbZIDK0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 06:26:14 -0400
Date: Fri, 4 Sep 2009 10:25:43 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, andreas.herrmann3@amd.com, a.p.zijlstra@chello.nl,
       balbir@in.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: balbir@in.ibm.com, mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/balancing] sched: Turn on SD_WAKE_IDLE for 'close' domains
Message-ID: <tip-e54c7073fae0683b90b3157e97142202c7334b79@git.kernel.org>
Git-Commit-ID: e54c7073fae0683b90b3157e97142202c7334b79
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 10:25:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e54c7073fae0683b90b3157e97142202c7334b79
Gitweb:     http://git.kernel.org/tip/e54c7073fae0683b90b3157e97142202c7334b79
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 4 Sep 2009 11:38:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 12:17:06 +0200

sched: Turn on SD_WAKE_IDLE for 'close' domains

Turn it on for the thread, core and cpu domain defaults.

Same argument as for NEWIDLE: we want to err on the side of
over-balancing, and mute the effect of that when it hurts
a workload.

On a NUMA box (4x4) i get better CPU utilization:

 Performance counter stats for './hackbench 10' (10 runs):

 Before:    2124.478000  task-clock-msecs         #     12.196 CPUs    ( +- 0.614% )
 After:     2232.558805  task-clock-msecs         #     12.601 CPUs    ( +- 0.852% )

It's probably not worth turning it on for the NUMA domain though,
as even on this fast-NUMA box it's break-even in terms of cost
versus improvement:

 After #2:  2288.062034  task-clock-msecs         #     12.909 CPUs    ( +- 0.864% )

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/topology.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 66774fd..f13ff3a 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -95,7 +95,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_WAKE_IDLE			\
+				| 1*SD_WAKE_IDLE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_WAKE_BALANCE			\
 				| 1*SD_SHARE_CPUPOWER			\
@@ -129,7 +129,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_WAKE_IDLE			\
+				| 1*SD_WAKE_IDLE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_WAKE_BALANCE			\
 				| 0*SD_SHARE_CPUPOWER			\
@@ -163,7 +163,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_WAKE_IDLE			\
+				| 1*SD_WAKE_IDLE			\
 				| 0*SD_WAKE_AFFINE			\
 				| 1*SD_WAKE_BALANCE			\
 				| 0*SD_SHARE_CPUPOWER			\
