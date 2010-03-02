Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab0CBONt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:13:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41968 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0CBONs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:13:48 -0500
Date: Tue, 2 Mar 2010 15:12:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu 1/2] rcu: suppress RCU lockdep warnings
 during early boot
Message-ID: <20100302141257.GA28917@elte.hu>
References: <20100301190329.GA26892@linux.vnet.ibm.com>
 <1267470234-27150-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100302122059.GA8247@elte.hu>
 <20100302132718.GB6821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302132718.GB6821@linux.vnet.ibm.com>
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

> On Tue, Mar 02, 2010 at 01:20:59PM +0100, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > +	if (!rcu_scheduler_active || !debug_locks)
> > > +		return 1;
> > > +	return lock_is_held(&rcu_lock_map);
> > 
> > > +	if (!rcu_scheduler_active || !debug_locks)
> > > +		return 1;
> > > +	return lock_is_held(&rcu_bh_lock_map);
> > 
> > i guess there could be a common helper here?
> 
> Will do!
> 
> > Also, could we clear rcu_scheduler_active when we clear debug_locks? That way 
> > only a single test is needed, a generic 'is lock debugging active'.
> 
> Doing that will break synchronize_rcu(), which returns immediately if
> !rcu_scheduler_active.

Ok - then have an debug_rcu flag which is cleared appropriately - so that the 
fastpath impact is reduced?

	Ingo
