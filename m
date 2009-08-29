Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218AbZH2LZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbZH2LZt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 07:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbZH2LZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 07:25:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:40040 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbZH2LZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 07:25:47 -0400
Date: Sat, 29 Aug 2009 11:25:22 GMT
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, tom.leiming@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, tom.leiming@gmail.com, mingo@elte.hu
In-Reply-To: <1251542879-5211-1-git-send-email-tom.leiming@gmail.com>
References: <1251542879-5211-1-git-send-email-tom.leiming@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Remove recursion stattistics
Message-ID: <tip-a417887637e862b434b293404f2a31ad1f282a58@git.kernel.org>
Git-Commit-ID: a417887637e862b434b293404f2a31ad1f282a58
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 29 Aug 2009 11:25:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a417887637e862b434b293404f2a31ad1f282a58
Gitweb:     http://git.kernel.org/tip/a417887637e862b434b293404f2a31ad1f282a58
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Sat, 29 Aug 2009 18:47:59 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 29 Aug 2009 13:22:36 +0200

lockdep: Remove recursion stattistics

Since lockdep has introduced BFS to avoid recursion, statistics
for recursion does not make any sense now. So remove them.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: a.p.zijlstra@chello.nl
LKML-Reference: <1251542879-5211-1-git-send-email-tom.leiming@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c      |    4 ----
 kernel/lockdep_proc.c |    8 --------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 0843584..f74d2d7 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -399,7 +399,6 @@ unsigned int nr_hardirq_chains;
 unsigned int nr_softirq_chains;
 unsigned int nr_process_chains;
 unsigned int max_lockdep_depth;
-unsigned int max_recursion_depth;
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
@@ -429,11 +428,8 @@ atomic_t redundant_softirqs_on;
 atomic_t redundant_softirqs_off;
 atomic_t nr_unused_locks;
 atomic_t nr_cyclic_checks;
-atomic_t nr_cyclic_check_recursions;
 atomic_t nr_find_usage_forwards_checks;
-atomic_t nr_find_usage_forwards_recursions;
 atomic_t nr_find_usage_backwards_checks;
-atomic_t nr_find_usage_backwards_recursions;
 #endif
 
 /*
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 8dac840..ec33c6a 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -199,16 +199,10 @@ static void lockdep_stats_debug_show(struct seq_file *m)
 		debug_atomic_read(&chain_lookup_hits));
 	seq_printf(m, " cyclic checks:                 %11u\n",
 		debug_atomic_read(&nr_cyclic_checks));
-	seq_printf(m, " cyclic-check recursions:       %11u\n",
-		debug_atomic_read(&nr_cyclic_check_recursions));
 	seq_printf(m, " find-mask forwards checks:     %11u\n",
 		debug_atomic_read(&nr_find_usage_forwards_checks));
-	seq_printf(m, " find-mask forwards recursions: %11u\n",
-		debug_atomic_read(&nr_find_usage_forwards_recursions));
 	seq_printf(m, " find-mask backwards checks:    %11u\n",
 		debug_atomic_read(&nr_find_usage_backwards_checks));
-	seq_printf(m, " find-mask backwards recursions:%11u\n",
-		debug_atomic_read(&nr_find_usage_backwards_recursions));
 
 	seq_printf(m, " hardirq on events:             %11u\n", hi1);
 	seq_printf(m, " hardirq off events:            %11u\n", hi2);
@@ -350,8 +344,6 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 			nr_unused);
 	seq_printf(m, " max locking depth:             %11u\n",
 			max_lockdep_depth);
-	seq_printf(m, " max recursion depth:           %11u\n",
-			max_recursion_depth);
 #ifdef CONFIG_PROVE_LOCKING
 	seq_printf(m, " max bfs queue depth:           %11u\n",
 			max_bfs_queue_depth);
