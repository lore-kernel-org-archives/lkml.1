Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbZIPKW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbZIPKW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758025AbZIPKWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:22:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:46508 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbZIPKWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:22:52 -0400
Date: Wed, 16 Sep 2009 10:22:26 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Reduce forkexec_idx
Message-ID: <tip-b8a543ea5a5896830a9969bacfd047f9d15940b2@git.kernel.org>
Git-Commit-ID: b8a543ea5a5896830a9969bacfd047f9d15940b2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:22:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8a543ea5a5896830a9969bacfd047f9d15940b2
Gitweb:     http://git.kernel.org/tip/b8a543ea5a5896830a9969bacfd047f9d15940b2
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 15 Sep 2009 15:22:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:51:23 +0200

sched: Reduce forkexec_idx

If we're looking to place a new task, we might as well find the
idlest position _now_, not 1 tick ago.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/ia64/include/asm/topology.h     |    4 ++--
 arch/sh/include/asm/topology.h       |    2 +-
 arch/sparc/include/asm/topology_64.h |    2 +-
 arch/x86/include/asm/topology.h      |    4 +---
 include/linux/topology.h             |    4 ++--
 5 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index 42f1673..569b9da 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -63,7 +63,7 @@ void build_cpu_to_node_map(void);
 	.idle_idx		= 1,			\
 	.newidle_idx		= 0,			\
 	.wake_idx		= 0,			\
-	.forkexec_idx		= 1,			\
+	.forkexec_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_EXEC	\
@@ -89,7 +89,7 @@ void build_cpu_to_node_map(void);
 	.idle_idx		= 2,			\
 	.newidle_idx		= 0,			\
 	.wake_idx		= 0,			\
-	.forkexec_idx		= 1,			\
+	.forkexec_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_EXEC	\
diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
index c843677..a8cc564 100644
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -17,7 +17,7 @@
 	.idle_idx		= 2,			\
 	.newidle_idx		= 0,			\
 	.wake_idx		= 0,			\
-	.forkexec_idx		= 1,			\
+	.forkexec_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index bc3a093..10b979d 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -53,7 +53,7 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 	.idle_idx		= 2,			\
 	.newidle_idx		= 0, 			\
 	.wake_idx		= 0,			\
-	.forkexec_idx		= 1,			\
+	.forkexec_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 7fafd1b..589f123 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -116,13 +116,11 @@ extern unsigned long node_remap_size[];
 
 # define SD_CACHE_NICE_TRIES	1
 # define SD_IDLE_IDX		1
-# define SD_FORKEXEC_IDX	0
 
 #else
 
 # define SD_CACHE_NICE_TRIES	2
 # define SD_IDLE_IDX		2
-# define SD_FORKEXEC_IDX	1
 
 #endif
 
@@ -137,7 +135,7 @@ extern unsigned long node_remap_size[];
 	.idle_idx		= SD_IDLE_IDX,				\
 	.newidle_idx		= 0,					\
 	.wake_idx		= 0,					\
-	.forkexec_idx		= SD_FORKEXEC_IDX,			\
+	.forkexec_idx		= 0,					\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
 				| 1*SD_BALANCE_NEWIDLE			\
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 4298745..936ab2b 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -121,7 +121,7 @@ int arch_update_cpu_topology(void);
 	.cache_nice_tries	= 1,					\
 	.busy_idx		= 2,					\
 	.wake_idx		= 0,					\
-	.forkexec_idx		= 1,					\
+	.forkexec_idx		= 0,					\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
 				| 1*SD_BALANCE_NEWIDLE			\
@@ -153,7 +153,7 @@ int arch_update_cpu_topology(void);
 	.idle_idx		= 1,					\
 	.newidle_idx		= 0,					\
 	.wake_idx		= 0,					\
-	.forkexec_idx		= 1,					\
+	.forkexec_idx		= 0,					\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
 				| 1*SD_BALANCE_NEWIDLE			\
