Return-Path: <linux-kernel-owner+w=401wt.eu-S1763215AbZDJPct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763215AbZDJPct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 11:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbZDJPch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 11:32:37 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47629 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779AbZDJPcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 11:32:35 -0400
Date: Fri, 10 Apr 2009 08:32:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org, hugh@veritas.com, jmorris@namei.org,
       akpm@linux-foundation.org
Subject: Re: [2.6.30-rc1] RCU detected CPU 1 stall
Message-ID: <20090410153229.GB6719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200904080057.n380vZAH051872@www262.sakura.ne.jp> <20090410142203.GA6719@linux.vnet.ibm.com> <20090410150353.GL26366@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410150353.GL26366@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 04:03:53PM +0100, Al Viro wrote:
> On Fri, Apr 10, 2009 at 07:22:03AM -0700, Paul E. McKenney wrote:
> 
> > Hmmmm...  This indicates that CPU 1 was spinning in the kernel for
> > a long time.  At 250 HZ, 32,565 jiffies is 130 seconds, or just over
> > two -minutes-.  Ouch!!!
> > 
> > The interrupt happened on the stalled CPU, so we know that interrupts
> > were enabled.  Because we have CONFIG_PREEMPT_NONE=y, there is no
> > preemption, so preemption need not be disabled.  This could be due
> > to lock contention, or even a simple infinite loop.
> > 
> > The timer interrupt (apic_timer_interrupt) occurred in either
> > __bprm_mm_init(), __get_user_4(), count(), or do_execve().  There
> > have been some recent changes around check_unsafe_exec() -- any
> > possibility that these introduced excessive lock contention or
> > an infinite loop?  Ditto for the recent security fixes?
> 
> Oh, joy... the loop in there is this:
>         for (t = next_thread(p); t != p; t = next_thread(t)) {
>                 if (t->fs == p->fs)
>                         n_fs++;
>         }
> I find it hard to believe that it can take two minutes, though.

Tetsuo, how many tasks did you have on this machine?

Though I too find it hard to believe that there were enough to chew up
two minutes.  Maybe the list got corrupted so that it has a loop?

							Thanx, Paul
