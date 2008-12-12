Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbYLLLed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbYLLLed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYLLLeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:34:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51662 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbYLLLeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:34:24 -0500
Date: Fri, 12 Dec 2008 12:34:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] RT scheduler updates for tip
Message-ID: <20081212113415.GH32640@elte.hu>
References: <493939B1.40506@novell.com> <20081208143228.GF14856@elte.hu> <20081208161246.GB4570@elte.hu> <493E8246.1090309@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <493E8246.1090309@novell.com>
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


* Gregory Haskins <ghaskins@novell.com> wrote:

> Ingo Molnar wrote:
> > okay, this series is quite bad so i'm disabling it for now. I sent a 
> > build fix earlier today, then i triggered this build failure:
> >
> > kernel/built-in.o: In function `dequeue_pushable_task':
> > sched.c:(.text+0x4a9f): undefined reference to `plist_del'
> > kernel/built-in.o: In function `enqueue_pushable_task':
> > sched.c:(.text+0x5734): undefined reference to `plist_del'
> > sched.c:(.text+0x5747): undefined reference to `plist_add'
> >
> > and then this:
> >
> > kernel/sched_rt.c: In function ‘next_prio’:
> > kernel/sched_rt.c:574: error: ‘struct rq’ has no member named ‘cpu’
> > kernel/sched_rt.c: In function ‘inc_rt_tasks’:
> > kernel/sched_rt.c:619: error: ‘rq’ undeclared (first use in this function)
> > kernel/sched_rt.c:619: error: (Each undeclared identifier is reported only once
> > kernel/sched_rt.c:619: error: for each function it appears in.)
> > kernel/sched_rt.c: In function ‘dec_rt_tasks’:
> > kernel/sched_rt.c:667: error: ‘rq’ undeclared (first use in this function)
> >
> >
> >   
> 
> Hi Ingo,
>   I was able to reproduce your first error (in the previous mail) by 
> turning off CONFIG_SMP.  I have folded your fix into my series and got 
> past it.  However, I was not able to reproduce these two new errors.  I 
> was thinking that perhaps something merged improperly between my 
> (older) tip/master and the merge point in cpus4096.  So I rebased the 
> series on your latest tip/master as of this morning, but it still 
> builds fine for me.  Could you send me the .config that causes this to 
> blow up?  I will get it straightened out for you ASAP.  Sorry for the 
> inconvenience.

Could you send a delta fix against cpus4096 for that bug you fixed?

	Ingo
