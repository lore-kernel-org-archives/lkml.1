Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbYHSLms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbYHSLms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 07:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYHSLmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 07:42:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52927 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbYHSLmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 07:42:37 -0400
Date: Tue, 19 Aug 2008 13:42:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] sched: extract walk_tg_tree(), fix
Message-ID: <20080819114204.GA4005@elte.hu>
References: <20080819103301.787700742@chello.nl> <20080819103844.459178947@chello.nl> <20080819110557.GA18608@elte.hu> <20080819111152.GA8592@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819111152.GA8592@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From fc21334298056c1e0d6428d3abe46b104188a05e Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 19 Aug 2008 13:40:47 +0200
Subject: [PATCH] sched: extract walk_tg_tree(), fix

fix:

 kernel/sched.c: In function '__rt_schedulable':
 kernel/sched.c:8771: error: implicit declaration of function 'walk_tg_tree'
 kernel/sched.c:8771: error: 'tg_nop' undeclared (first use in this function)
 kernel/sched.c:8771: error: (Each undeclared identifier is reported only once
 kernel/sched.c:8771: error: for each function it appears in.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 59c6683..10f7ad2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1387,7 +1387,7 @@ static inline void dec_cpu_load(struct rq *rq, unsigned long load)
 	update_load_sub(&rq->load, load);
 }
 
-#if (defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)) || defined(SCHED_RT_GROUP_SCHED)
+#if (defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)) || defined(CONFIG_SCHED_RT_GROUP_SCHED)
 typedef int (*tg_visitor)(struct task_group *, void *);
 
 /*

