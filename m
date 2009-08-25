Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZHYAKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZHYAKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 20:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZHYAKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 20:10:46 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:51869 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753875AbZHYAKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 20:10:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEABXHkkpMROOX/2dsb2JhbACBU9U8hBoF
Date: Mon, 24 Aug 2009 20:10:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org
Subject: Re: [PATCH -tip 1/2] Add "notrace" to RCU function headers used by
	ftrace.
Message-ID: <20090825001043.GA8252@Krystal>
References: <20090824164112.GA13693@linux.vnet.ibm.com> <alpine.DEB.2.00.0908241938330.6710@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908241938330.6710@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:06:41 up 6 days, 10:56,  2 users,  load average: 0.31, 0.31,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
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
> 

inline is just a hint. __attribute__((always_inline)) should be used to
really really forbid gcc to generate any function call. So notrace is
needed to make sure we do not trace such function call.

It reminds me of the old mkraid option --really-really-force (or
something like that). ;)

Mathieu

> -- Steve
> 
> >  {
> >  	rcu_read_release();
> >  	__release(RCU_SCHED);
> > -- 
> > 1.5.2.5
> > 
> > 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
