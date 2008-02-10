Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYBJRoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYBJRoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYBJRoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:44:01 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:40141 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYBJRoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:44:00 -0500
Date: Sun, 10 Feb 2008 09:43:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: preempt rcu bug on s390
Message-ID: <20080210174355.GE16205@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080209113435.GA6915@osiris.boeblingen.de.ibm.com> <20080209140711.GA16205@linux.vnet.ibm.com> <20080209171451.GB8069@osiris.ibm.com> <20080209220226.GB16205@linux.vnet.ibm.com> <20080210130150.GA9044@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210130150.GA9044@osiris.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 02:01:50PM +0100, Heiko Carstens wrote:
> > > > > Using CONFIG_PREEMPT_RCU and CONFIG_NO_IDLE_HZ on s390 my system always
> > > > > gets stuck when running with more than one cpu.
> > > > > When booting with four cpus I get all four cpus caught withing cpu_idle
> > > > > and not advancing anymore. However there is the init process which is
> > > > > waitung for synchronize_rcu() to complete (lcrash output):
> > > > > 
> > > > > If I change the code so that timer ticks won't be disabled everything
> > > > > runs fine. So my guess is that rcu_needs_cpu() doesn't do the right
> > > > > thing for the rcu preemptible case.
> > > > > 
> > > > > Kernel version is git head of today.
> > > > > 
> > > > > Any ideas?
> > > > 
> > > > Does this tree have http://lkml.org/lkml/2008/1/29/208 applied?
> > > > 
> > > > If not, could you please check it out?
> > > 
> > > It's not applied, however it doesn't change anything. Also the patch
> > > is tied to the dynticks implementation which is differently from
> > > s390's nohz implementation.
> > > I had to add the patch below so it would make at least some sense.
> > > But it doesn't fix the problem.
> > 
> > OK, I was afraid of that.  ;-)
> > 
> > Does s390 start out in nohz mode?  The reason I ask is that it feels like
> > an off-by-one error for the dynticks_progress_counter.
> 
> Actually I forgot to add a few ifdefs to make the code do something :)
> That just reveals that we have a conflict with the dynticks implementation
> and s390's nohz that shows up in what rcu_irq_enter/exit assume.
> I didn't patch s390 and common code so it will work, but I think the
> patch you mentionened will fix the problem I reported.
> So I guess we should either convert s390 to use the generic dynticks
> implementation or disable preemptible rcu on s390 until we converted
> our code.

Sounds good to me!!!  (Especially converting s390 to generic algorithm.)

I believe that the generic implementation will do what you need, but
I am sure you will let me know of any problems that arise.

> Thanks for helping debugging this!

Thank you for tracking it down!

							Thanx, Paul
