Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbZELKaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbZELKaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbZELKaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:30:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34939 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbZELKaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:30:06 -0400
Date: Tue, 12 May 2009 12:29:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       bharata@linux.vnet.ibm.com, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter
	batch values for stats counters
Message-ID: <20090512102939.GB11714@elte.hu>
References: <20090512185836.D635.A69D9226@jp.fujitsu.com> <20090512101057.GD6351@balbir.in.ibm.com> <20090512191206.D63B.A69D9226@jp.fujitsu.com> <20090512102412.GG6351@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512102412.GG6351@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-05-12 19:13:42]:
> 
> > > > +#ifdef CONFIGCONFIG_SMP
> > > > +	cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
> > > > +#endif
> > > 
> > > Slow down and compile patches before sending them out.. please. That
> > > is a basic expectation if you expect it to be merged.
> > 
> > Unfortunately, this mistake pass test successfully ;)
> > it because cpuacct_batch=0 works even SMP.
> >
> 
> OK, BTW, using an #ifdef right in the middle of a function makes 
> the code harder to read, can't we use an inline function to 
> abstract out SMP?

or rather, to make cpuacct_batch have a sane value on UP too. (1? 
0?)

	Ingo
