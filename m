Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968115Ab0B0JwG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:52:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43493 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968098Ab0B0JwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:52:02 -0500
Date: Sat, 27 Feb 2010 10:51:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/2] rcu: fixes for RCU lockdep
Message-ID: <20100227095115.GF31794@elte.hu>
References: <20100225220624.GA7013@linux.vnet.ibm.com>
 <20100226115018.GA4519@elte.hu>
 <20100226174248.GF6733@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100226174248.GF6733@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Fri, Feb 26, 2010 at 12:50:18PM +0100, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > Hello!
> > > 
> > > This set fixes a couple of problems with the RCU-based lockdep patches:
> > > 
> > > 1.	Make the lockdep_rcu_dereference() message less alarmist
> > > 
> > > 2.	Make rcu_read_lock_sched_held() take boot-time lack of
> > > 	preemption into account.
> > > 
> > > 							Thanx, Paul
> > > 
> > > ------------------------------------------------------------------------
> > > 
> > >  include/linux/rcupdate.h |    4 +++-
> > >  include/linux/rcutiny.h  |    4 ----
> > >  include/linux/rcutree.h  |    1 -
> > >  kernel/lockdep.c         |    7 +++----
> > >  kernel/rcupdate.c        |   18 ++++++++++++++++++
> > >  kernel/rcutree.c         |   20 --------------------
> > >  6 files changed, 24 insertions(+), 30 deletions(-)
> > 
> > Applied, thanks Paul!
> > 
> > Here's a new warning:
> > 
> > [    0.000000] 
> > [    0.000000] ===================================================
> > [    0.000000] [ INFO: suspicious rcu_dereference_check() usage. ]
> > [    0.000000] ---------------------------------------------------
> > [    0.000000] kernel/sched_fair.c:3469 invoked rcu_dereference_check() without protection!
> 
> Hmmm...  Could you please tell me what commit this test ran against?

One version of tip:master :-/

ob'kconfig - i think this header bit of the .config:

> > # Automatically generated make config: don't edit
> > # Linux kernel version: 2.6.33
> > # Fri Feb 26 14:51:28 2010

should contain the last-seen kernel Git sha1 as well. It would ease things 
considerably.

> My guesses thus far either don't have that many lines in kernel/sched_fair.c 
> or have some unrelated code at line 3469.

I'll post the sha1 next time i encounter this warning.

Thanks,

	Ingo
