Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbXHGSgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbXHGSgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 14:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbXHGSgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 14:36:04 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:45725 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbXHGSgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 14:36:03 -0400
Date: Tue, 7 Aug 2007 22:36:09 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: Cpu-Hotplug and Real-Time
Message-ID: <20070807183609.GA81@tv-sign.ru>
References: <20070807131216.GA20424@in.ibm.com> <20070807151336.GA507@tv-sign.ru> <20070807173336.GA4472@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807173336.GA4472@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, Venki Pallipadi wrote:
>
> On Tue, Aug 07, 2007 at 07:13:36PM +0400, Oleg Nesterov wrote:
> > 
> > As for kthread_bind(), I think wait_task_inactive+set_task_cpu is just
> > an optimization, and easy to "fix":
> > 
> > --- kernel/kthread.c	2007-07-28 16:58:17.000000000 +0400
> > +++ /proc/self/fd/0	2007-08-07 18:56:54.248073547 +0400
> > @@ -166,10 +166,7 @@ void kthread_bind(struct task_struct *k,
> >  		WARN_ON(1);
> >  		return;
> >  	}
> > -	/* Must have done schedule() in kthread() before we set_task_cpu */
> > -	wait_task_inactive(k);
> > -	set_task_cpu(k, cpu);
> > -	k->cpus_allowed = cpumask_of_cpu(cpu);
> > +	set_cpus_allowed(current, cpumask_of_cpu(cpu));
> >  }
> >  EXPORT_SYMBOL(kthread_bind);
> > 
> 
> Not sure whether set_cpus_allowed() will work here. Looks like, it needs the
> CPU to be online during the call and in kthread_bind() case CPU may be offline.

Aah, you are right, of course.

Thanks,

Oleg.

