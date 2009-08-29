Return-Path: <linux-kernel-owner+w=401wt.eu-S1752142AbZH2KsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbZH2KsJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 06:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZH2KsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 06:48:08 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:43659 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbZH2KsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 06:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IMIM9yIQyC6MfYWazbaOK1blDatuPAVJ45HfvkooARgPVgDbZU1UX1l6mL6AlBvxN8
         AMdN5PCoLlZg0OnGiR7BTol7L1FPGvGO/eLO7YOjFlih3aWNSbBeiLue6tj3WxUc1RgI
         tUyBbPlOy+mKdESuRvFK5/f85Fb4pyTeEISOU=
From: tom.leiming@gmail.com
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] lockdep:remove recursion stattistics
Date: Sat, 29 Aug 2009 18:47:59 +0800
Message-Id: <1251542879-5211-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Since lockdep has introduced BFS to avoid recursion, statistics for
recursion does not make any sense now. So remove them.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
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
index 37b6ddc..d4b3dbc 100644
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
-- 
1.6.0.GIT

