Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZITS3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZITS3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbZITS3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:29:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:52138 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbZITS3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:29:52 -0400
Date: Sun, 20 Sep 2009 18:29:25 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yong.zhang0@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <1252930816-7672-1-git-send-email-yong.zhang0@gmail.com>
References: <1252930816-7672-1-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix potential NULL derference of doms_cur
Message-ID: <tip-cb5fd13f1178dee4302646b2890d884c380160e1@git.kernel.org>
Git-Commit-ID: cb5fd13f1178dee4302646b2890d884c380160e1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 20 Sep 2009 18:29:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb5fd13f1178dee4302646b2890d884c380160e1
Gitweb:     http://git.kernel.org/tip/cb5fd13f1178dee4302646b2890d884c380160e1
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Mon, 14 Sep 2009 20:20:16 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Sep 2009 20:20:30 +0200

sched: Fix potential NULL derference of doms_cur

If CONFIG_CPUMASK_OFFSTACK is enabled but doms_cur alloc failed in
arch_init_sched_domains(), doms_cur will move back to
fallback_doms. But this time, fallback_doms has not been
initialized yet.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: a.p.zijlstra@chello.nl
LKML-Reference: <1252930816-7672-1-git-send-email-yong.zhang0@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 575fb01..1b900fb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9165,6 +9165,7 @@ void __init sched_init_smp(void)
 	cpumask_var_t non_isolated_cpus;
 
 	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
+	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 
 #if defined(CONFIG_NUMA)
 	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
@@ -9196,7 +9197,6 @@ void __init sched_init_smp(void)
 	sched_init_granularity();
 	free_cpumask_var(non_isolated_cpus);
 
-	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 	init_sched_rt_class();
 }
 #else
