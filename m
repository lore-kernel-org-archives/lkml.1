Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbZKKJ7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbZKKJ7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 04:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZKKJ7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 04:59:34 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40146 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbZKKJ7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 04:59:33 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 11 Nov 2009 18:59:28 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] cpu controller can't provide fair CPU time for each group
Cc: Miao Xie <miaox@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1257924007.23203.18.camel@twins>
References: <20091111134910.5F42.E1E9C6FF@jp.fujitsu.com> <1257924007.23203.18.camel@twins>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20091111183634.5F54.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After receiving your mail, I realized I misunderstood about 
test case 1). I thought 1) was occur without cpu affinity due to 
mis-communication with test team.
I'm really really sorry for noise. I need much coffee. :-(


> On Wed, 2009-11-11 at 15:21 +0900, Yasunori Goto wrote:
> 
> > When users use cpuset/cpu affinity, then they would like to controll cpu affinity.
> > Not CPU time.
> 
> What are people using affinity for? The only use of affinity is to
> restrict or disable the load-balancer. Don't complain the load-balancer
> doesn't work when you're taking active steps to hinder its work.
> 
> If you don't want things load-balanced, turn it off, if you want the
> load-balancer to work on smaller groups of cpus, use cpusets.

Ok. make sense.

> 
> Anyway, I said there needs to be done something because the interaction
> between cpusets and the cpu-controller is utter crap, they never should
> have been separated like they are.

Thanks.

> 
> > To be honest, I don't have any good idea because I'm not familiar with
> > schduler's code. But I have one question.
> > 
> > 
> > 1618 static int tg_shares_up(struct task_group *tg, void *data)
> > 1619 {
> > 1620         unsigned long weight, rq_weight = 0, shares = 0;
> > 
> > (snip)
> > 
> > 1632         for_each_cpu(i, sched_domain_span(sd)) {
> > 1633                 weight = tg->cfs_rq[i]->load.weight;
> > 1634                 usd->rq_weight[i] = weight;
> > 1635 
> > 1636                 /*
> > 1637                  * If there are currently no tasks on the cpu pretend there
> > 1638                  * is one of average load so that when a new task gets to
> > 1639                  * run here it will not get delayed by group starvation.
> > 1640                  */
> > 1641                 if (!weight)
> > 1642                         weight = NICE_0_LOAD; ---------(*)
> > 
> > I heard from test team when (*) was removed, 1) didn't occur.
> > 
> > The comment said (*) is to avoid starvation condition.
> > However, I don't understand why NICE_0_LOAD must be specified.
> > Could you tell me why small value (like 2 or 3) is not used for (*)?
> > What is side effect? 
> 
> Exactly what the comment says, it will get delayed because the group
> won't get scheduled on that cpu until all the group weights get
> re-adjusted again, which can be much longer than the typical runtimes of
> the workload in question.
> 
> Regular weights are NICE_0_LOAD, if you stick a 3 next to that I'll not
> get ran much -> starvation.

Ok.

Thank you very much for your explanation.

Best Regards.

-- 
Yasunori Goto 


