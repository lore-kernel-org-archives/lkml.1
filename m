Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbZHYCCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbZHYCCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 22:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZHYCCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 22:02:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47965 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbZHYCCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 22:02:22 -0400
Date: Mon, 24 Aug 2009 19:02:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josht@linux.vnet.ibm.com,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org
Subject: Re: [PATCH -tip 1/2] Add "notrace" to RCU function headers used by
	ftrace.
Message-ID: <20090825020221.GA7355@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090824164112.GA13693@linux.vnet.ibm.com> <alpine.DEB.2.00.0908241938330.6710@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908241938330.6710@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 07:38:51PM -0400, Steven Rostedt wrote:
> 
> On Mon, 24 Aug 2009, Paul E. McKenney wrote:
> 
> > Both rcu_read_lock_sched_notrace() and rcu_read_unlock_sched_notrace()
> > are used by ftrace, and thus need to be marked "notrace".  Unfortunately,
> > my naive assumption that gcc would see the inner "notrace" does not hold.
> > Kudos to Lai Jiangshan for noting this.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  include/linux/rcupdate.h |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index ec90fc3..8b4422c 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -191,7 +191,7 @@ static inline void rcu_read_lock_sched(void)
> >  	__acquire(RCU_SCHED);
> >  	rcu_read_acquire();
> >  }
> > -static inline void rcu_read_lock_sched_notrace(void)
> > +static inline notrace void rcu_read_lock_sched_notrace(void)
> >  {
> >  	preempt_disable_notrace();
> >  	__acquire(RCU_SCHED);
> > @@ -209,7 +209,7 @@ static inline void rcu_read_unlock_sched(void)
> >  	__release(RCU_SCHED);
> >  	preempt_enable();
> >  }
> > -static inline void rcu_read_unlock_sched_notrace(void)
> > +static inline notrace void rcu_read_unlock_sched_notrace(void)
> 
> Funny, inlines should not be traced. Is gcc ignoring the inlines here?

Well, that was my line of thinking as well, until Lai Jiangshan set
me straight.  Version 4.x of gcc apparently decides on a case-by-case
basis.

							Thanx, Paul
