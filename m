Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZDUIIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZDUIIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZDUIHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:07:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:45507 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbZDUIHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:07:34 -0400
Date: Tue, 21 Apr 2009 08:06:37 GMT
From: tip-bot for Gautham R Shenoy <ego@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, rusty@rustcorp.com.au, sfr@canb.auug.org.au,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <20090421031049.GA4140@in.ibm.com>
References: <20090421031049.GA4140@in.ibm.com>
Subject: [tip:sched/core] sched: Replace first_cpu() with cpumask_first() in ILB nomination code
Message-ID: <tip-6e29ec5701e9d44fa02b96c1c5c45f7516182b65@git.kernel.org>
Git-Commit-ID: 6e29ec5701e9d44fa02b96c1c5c45f7516182b65
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 08:06:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e29ec5701e9d44fa02b96c1c5c45f7516182b65
Gitweb:     http://git.kernel.org/tip/6e29ec5701e9d44fa02b96c1c5c45f7516182b65
Author:     Gautham R Shenoy <ego@in.ibm.com>
AuthorDate: Tue, 21 Apr 2009 08:40:49 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Apr 2009 08:06:05 +0200

sched: Replace first_cpu() with cpumask_first() in ILB nomination code

Stephen Rothwell reported this build warning:

>  kernel/sched.c: In function 'find_new_ilb':
>  kernel/sched.c:4355: warning: passing argument 1 of '__first_cpu' from incompatible pointer type
>
> Possibly caused by commit f711f6090a81cbd396b63de90f415d33f563af9b
> ("sched: Nominate idle load balancer from a semi-idle package") from
> the sched tree.  Should this call to first_cpu be cpumask_first?

For !(CONFIG_SCHED_MC || CONFIG_SCHED_SMT), find_new_ilb() nominates the
Idle load balancer as the first cpu from the nohz.cpu_mask.

This code uses the older API first_cpu(). Replace it with cpumask_first(),
which is the correct API here.

[ Impact: cleanup, address build warning ]

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <20090421031049.GA4140@in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 797f6fd..54d67b9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4356,7 +4356,7 @@ out_done:
 #else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
 static inline int find_new_ilb(int call_cpu)
 {
-	return first_cpu(nohz.cpu_mask);
+	return cpumask_first(nohz.cpu_mask);
 }
 #endif
 
