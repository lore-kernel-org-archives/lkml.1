Return-Path: <linux-kernel-owner+w=401wt.eu-S1751776AbZEUF7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbZEUF7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 01:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZEUF7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 01:59:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49745 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZEUF7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 01:59:40 -0400
Date: Thu, 21 May 2009 07:53:00 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend3 1/2] itimers: merge ITIMER_VIRT and ITIMER_PROF
 common code
Message-ID: <20090521075300.43977873@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.0905191517080.5983@localhost.localdomain>
References: <20090518135011.5de06307@dhcp-lab-109.englab.brq.redhat.com>
	<alpine.LFD.2.00.0905191517080.5983@localhost.localdomain>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 19 May 2009 15:52:06 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index b4c38bc..0d8367b 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -454,6 +454,11 @@ struct pacct_struct {
> >  	unsigned long		ac_minflt, ac_majflt;
> >  };
> >  
> > +struct cpu_itimer {
> > +	cputime_t expires;
> > +	cputime_t incr;
> > +};
> > +
> >  /**
> >   * struct task_cputime - collected CPU time counts
> >   * @utime:		time spent in user mode, in &cputime_t units
> > @@ -540,8 +545,7 @@ struct signal_struct {
> >  	ktime_t it_real_incr;
> >  
> >  	/* ITIMER_PROF and ITIMER_VIRTUAL timers for the process */
> > -	cputime_t it_prof_expires, it_virt_expires;
> > -	cputime_t it_prof_incr, it_virt_incr;
> > +	struct cpu_itimer it[2];
> 
> I like the general idea of the patch, but it's not obvious that
> CPUCLOCK_PROF and CPUCLOCK_VIRT happen to be defined as 0 resp 1.
> 
> This needs at least a comment.

Ok. I'll comment that. I though about something better than comment,
but not find nothing appropriate. 

> >  				break;
> >  			case CPUCLOCK_PROF:
> > -				if (!cputime_eq(p->signal->it_prof_expires,
> > +				if (!cputime_eq(sig->it[CPUCLOCK_PROF].expires,
> >  						cputime_zero) &&
> > -				    cputime_lt(p->signal->it_prof_expires,
> > +				    cputime_lt(sig->it[CPUCLOCK_PROF].expires,
> >  					       timer->it.cpu.expires.cpu))
> >  					break;
> 
>   That code could be simplified further by splitting out the
>   comparisons into a separate function and doing
> 
>   	      	      	     	if (fred(&sig->it[CPUCLOCK_PROF], timer))
> 					break;

I'll create a helper inline function, but I do this in separate patch. 

> Looks fine otherwise. Thanks,
> 
>       tglx

Thanks for review, I'll change both my patches and resend soon.
Stanislaw
