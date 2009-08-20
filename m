Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZHTKE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZHTKE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZHTKE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:04:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42641 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbZHTKE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:04:27 -0400
Date: Thu, 20 Aug 2009 12:04:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Anton Blanchard <anton@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       balbir@linux.vnet.ibm.com, Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH] better align percpu counter (Was Re: [tip:sched/core]
	sched: cpuacct: Use bigger percpu counter batch values for stats
	counters
Message-ID: <20090820100403.GB29093@elte.hu>
References: <20090512193656.D647.A69D9226@jp.fujitsu.com> <20090716081010.GB3134@in.ibm.com> <20090716083948.GA2950@kryten> <20090820051038.GF21100@kryten> <20090820052605.GC26265@balbir.in.ibm.com> <1250747579.8282.110.camel@twins> <20090820060528.GG21100@kryten> <20090820151017.2ba95d6e.kamezawa.hiroyu@jp.fujitsu.com> <20090820062451.GH21100@kryten> <20090820174123.afa43c48.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820174123.afa43c48.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 20 Aug 2009 16:24:51 +1000
> Anton Blanchard <anton@samba.org> wrote:
> 
> >  
> > Hi,
> > 
> > > Could you share contex-switch-test program ?
> > > I'd like to play with it to find out what I can do against percpu counter.
> > 
> > Sure:
> > 
> > http://ozlabs.org/~anton/junkcode/context_switch.c
> > 
> > Very simple, just run it once per core:
> > 
> > for i in `seq 0 31`
> > do
> > 	taskset -c $i ./context_switch &
> > done
> > 
> > Then look at the context switch rates in vmstat.
> > 
> Thank you for test program.
> 
> Before adjusting batch counter (I think you should modify it),
> Could you try this ?
> 
> I only have 8cpu(2socket) host but works well.
> (But...my host is x86-64 and has not virt-cpu-accouting.)
> 
> with your program
> before patch.
> cpuacct off : 414000-416000 ctsw per sec.
> cpuacct on  : 401000-404000 ctsw per sec.
> 
> after patch
> cpuacct on  : 412000-413000 ctsw per sec.
> 
> Maybe I should check cache-miss late ;)

Btw., in latest upstream you can do that via:

  cd tools/perf/
  make -j install

  perf stat --repeat 5 -- taskset -c 1 ./context_switch

there will be cache-miss and other stats, error bars so 
you can compare the before/after better, etc.

	Ingo
