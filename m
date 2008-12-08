Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbYLHQGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbYLHQGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 11:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYLHQGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 11:06:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49377 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbYLHQGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 11:06:05 -0500
Date: Mon, 8 Dec 2008 17:05:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fix build failure in kernel/sched_rt.c
Message-ID: <20081208160557.GA4570@elte.hu>
References: <493939B1.40506@novell.com> <20081208143228.GF14856@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081208143228.GF14856@elte.hu>
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


>From a9750309ef51081abb17268936769511b3683488 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 8 Dec 2008 16:39:24 +0100
Subject: [PATCH] sched: fix build failure in kernel/sched_rt.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Impact: build fix

fix:

 kernel/sched_rt.c: In function ‘inc_rt_tasks’:
 kernel/sched_rt.c:593: error: ‘prio’ undeclared (first use in this function)
 kernel/sched_rt.c:593: error: (Each undeclared identifier is reported only once
 kernel/sched_rt.c:593: error: for each function it appears in.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index c5b1c5a..64a8f0a 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -583,9 +583,7 @@ static inline int next_prio(struct rq *rq)
 static inline
 void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
-#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	int prio = rt_se_prio(rt_se);
-#endif
 #ifdef CONFIG_SMP
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 #endif
