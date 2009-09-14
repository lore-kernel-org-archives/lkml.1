Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbZINMUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbZINMUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZINMUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:20:19 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:56200 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbZINMUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:20:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DHwKh+Viu4z94IxwrOci4VMhe7MMom7LcPchmzEEFhJAFIDRXO/KanWUFrK7vg1HRz
         LqE/0LdJu86j8BMufgf7niBAt8wdZEKJNsmKK4Wv6knZvczKrKS3TSAowLryCDG4jx1z
         /iR9N7B/WPNBirmje8yTRyrnILcWSHn8oDLaA=
From: Yong Zhang <yong.zhang0@gmail.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix potential NULL derference of doms_cur
Date: Mon, 14 Sep 2009 20:20:16 +0800
Message-Id: <1252930816-7672-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_CPUMASK_OFFSTACK is enabled but doms_cur alloc failed
in arch_init_sched_domains(), doms_cur will move back to
fallback_doms. But this time, fallback_doms has not been
initialized yet.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e27a536..6dc3e06 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9329,6 +9329,7 @@ void __init sched_init_smp(void)
 	cpumask_var_t non_isolated_cpus;
 
 	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
+	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 
 #if defined(CONFIG_NUMA)
 	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
@@ -9360,7 +9361,6 @@ void __init sched_init_smp(void)
 	sched_init_granularity();
 	free_cpumask_var(non_isolated_cpus);
 
-	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 	init_sched_rt_class();
 }
 #else
-- 
1.6.0.4

