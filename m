Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbZFKFql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbZFKFql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 01:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZFKFqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 01:46:32 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47927 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbZFKFqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 01:46:31 -0400
Date: Thu, 11 Jun 2009 08:46:32 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       yinghai@kernel.org
Subject: [PATCH 1/2] sched: use alloc_cpumask_var() instead of
 alloc_bootmem_cpumask_var()
Message-ID: <Pine.LNX.4.64.0906110846110.2617@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Slab is initialized when sched_init() runs now so lets use alloc_cpumask_var().

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 kernel/sched.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a9ff953..12cc09c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9310,13 +9310,13 @@ void __init sched_init(void)
 	current->sched_class = &fair_sched_class;
 
 	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
-	alloc_bootmem_cpumask_var(&nohz_cpu_mask);
+	alloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
-	alloc_bootmem_cpumask_var(&nohz.cpu_mask);
-	alloc_bootmem_cpumask_var(&nohz.ilb_grp_nohz_mask);
+	alloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
+	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
 #endif
-	alloc_bootmem_cpumask_var(&cpu_isolated_map);
+	alloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
 	scheduler_running = 1;
-- 
1.6.0.4

