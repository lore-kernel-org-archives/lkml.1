Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYGUUQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYGUUQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYGUUQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:16:38 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:53236 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbYGUUQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:16:37 -0400
Subject: Re: [git pull] scheduler updates for v2.6.27, phase #2
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1216668182.7257.80.camel@twins>
References: <20080721153804.GA26072@elte.hu>
	 <1216657892.2294.34.camel@dhcp32.mvista.com>
	 <1216668182.7257.80.camel@twins>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 13:16:33 -0700
Message-Id: <1216671393.2294.49.camel@dhcp32.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 21:23 +0200, Peter Zijlstra wrote:

> Does this work for you?
> 

Yours removed the warning .. I made an alternate one below only compile
tested, your choice..

Signed-off-by: Daniel Walker <dwalker@mvista.com>


diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 47ceac9..febb864 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -242,7 +242,7 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 	rt_period = ktime_to_ns(rt_b->rt_period);
 	for_each_cpu_mask(i, rd->span) {
 		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
-		s64 diff;
+		u64 diff;
 
 		if (iter == rt_rq)
 			continue;
@@ -252,7 +252,7 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 			goto next;
 
 		diff = iter->rt_runtime - iter->rt_time;
-		if (diff > 0) {
+		if ((s64)(diff) > 0) {
 			do_div(diff, weight);
 			if (rt_rq->rt_runtime + diff > rt_period)
 				diff = rt_period - rt_rq->rt_runtime;


