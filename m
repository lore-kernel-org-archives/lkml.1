Return-Path: <linux-kernel-owner+w=401wt.eu-S1763626AbXHHMej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763626AbXHHMej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 08:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbXHHMec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 08:34:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57775 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbXHHMeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 08:34:31 -0400
Date: Wed, 8 Aug 2007 14:34:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mitchell Erblich <erblichs@earthlink.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question: RT schedular : task_tick_rt(struct rq *rq, struct
	task_struct *p) : decreases overhead when  rq->nr_running == 1
Message-ID: <20070808123418.GA30248@elte.hu>
References: <000501c7d945$f30af1a0$6501a8c0@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000501c7d945$f30af1a0$6501a8c0@earthlink.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mitchell Erblich <erblichs@earthlink.net> wrote:

> After
>     p->time_slice = static_prio_timeslice(p->static_prio);
> 
> Why isn't their a check like
>     if  (rq->nr_running == 1)
>          return;
> 
> Which world remove the need for any recheduling or requeue'ing...

your change is a possible optimization, but this is a pretty rare 
codepath because the overwhelming majority of RT apps uses SCHED_FIFO. 
Plus, the time_slice going down to 0 is a relatively rare event even for 
SCHED_RR tasks. And if we have only a single SCHED_RR task, why is it 
SCHED_RR to begin with? So this is on several levels an uncommon 
workload and by adding a check like that we'd increase the codesize. But 
... no strong feelings against this optimization - if you send a proper 
patch we can apply it, it certainly makes sense from a logic POV.

	Ingo
