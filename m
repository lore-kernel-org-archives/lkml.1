Return-Path: <linux-kernel-owner+w=401wt.eu-S933690AbZIDK0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690AbZIDK0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 06:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933571AbZIDK0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 06:26:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:48659 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933681AbZIDKZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 06:25:58 -0400
Date: Fri, 4 Sep 2009 10:25:30 GMT
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
Subject: [tip:sched/balancing] sched: Turn on SD_BALANCE_NEWIDLE
Message-ID: <tip-840a0653100dbde599ae8ddf83fa214dfa5fd1aa@git.kernel.org>
Git-Commit-ID: 840a0653100dbde599ae8ddf83fa214dfa5fd1aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 10:25:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  840a0653100dbde599ae8ddf83fa214dfa5fd1aa
Gitweb:     http://git.kernel.org/tip/840a0653100dbde599ae8ddf83fa214dfa5fd1aa
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 4 Sep 2009 11:32:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 11:52:54 +0200

sched: Turn on SD_BALANCE_NEWIDLE

Start the re-tuning of the balancer by turning on newidle.

It improves hackbench performance and parallelism on a 4x4 box.
The "perf stat --repeat 10" measurements give us:

  domain0             domain1
  .......................................
 -SD_BALANCE_NEWIDLE -SD_BALANCE_NEWIDLE:
   2041.273208  task-clock-msecs         #      9.354 CPUs    ( +-   0.363% )

 +SD_BALANCE_NEWIDLE -SD_BALANCE_NEWIDLE:
   2086.326925  task-clock-msecs         #     11.934 CPUs    ( +-   0.301% )

 +SD_BALANCE_NEWIDLE +SD_BALANCE_NEWIDLE:
   2115.289791  task-clock-msecs         #     12.158 CPUs    ( +-   0.263% )

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/topology.h |    2 +-
 include/linux/topology.h        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index be29eb8..ef7bc7f 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -142,7 +142,7 @@ extern unsigned long node_remap_size[];
 	.forkexec_idx		= SD_FORKEXEC_IDX,			\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
-				| 0*SD_BALANCE_NEWIDLE			\
+				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_WAKE_IDLE			\
diff --git a/include/linux/topology.h b/include/linux/topology.h
index fe2c032..66774fd 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -126,7 +126,7 @@ int arch_update_cpu_topology(void);
 	.forkexec_idx		= 1,					\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
-				| 0*SD_BALANCE_NEWIDLE			\
+				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_WAKE_IDLE			\
@@ -160,7 +160,7 @@ int arch_update_cpu_topology(void);
 	.forkexec_idx		= 1,					\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
-				| 0*SD_BALANCE_NEWIDLE			\
+				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_WAKE_IDLE			\
