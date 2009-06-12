Return-Path: <linux-kernel-owner+w=401wt.eu-S1765425AbZFLNaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765425AbZFLNaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763381AbZFLN0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:26:00 -0400
Received: from ozlabs.org ([203.10.76.45]:54991 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763205AbZFLNZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:57 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:04 +0930
Subject: [PATCH 8/17] cpumask: remove unused cpu_mask_all
Message-Id: <20090612132559.549A2DDDA2@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's only defined for NR_CPUS > BITS_PER_LONG; cpu_all_mask is always
defined (and const).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/cpumask.h |    3 ---
 init/main.c             |    5 -----
 2 files changed, 8 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -331,9 +331,6 @@ static inline const struct cpumask *get_
 	[0 ... BITS_TO_LONGS(NR_CPUS)-2] = ~0UL,			\
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
 } }
-
-/* cpu_mask_all is in init/main.c */
-extern cpumask_t cpu_mask_all;
 
 #endif
 
diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -358,11 +358,6 @@ static inline void smp_prepare_cpus(unsi
 static inline void smp_prepare_cpus(unsigned int maxcpus) { }
 
 #else
-
-#if NR_CPUS > BITS_PER_LONG
-cpumask_t cpu_mask_all __read_mostly = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_mask_all);
-#endif
 
 /* Setup number of possible processor ids */
 int nr_cpu_ids __read_mostly = NR_CPUS;

