Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab0CBN1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 08:27:22 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46913 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0CBN1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 08:27:21 -0500
Date: Tue, 2 Mar 2010 05:27:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu 1/2] rcu: suppress RCU lockdep
	warnings during early boot
Message-ID: <20100302132718.GB6821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100301190329.GA26892@linux.vnet.ibm.com> <1267470234-27150-1-git-send-email-paulmck@linux.vnet.ibm.com> <20100302122059.GA8247@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302122059.GA8247@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 01:20:59PM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > +	if (!rcu_scheduler_active || !debug_locks)
> > +		return 1;
> > +	return lock_is_held(&rcu_lock_map);
> 
> > +	if (!rcu_scheduler_active || !debug_locks)
> > +		return 1;
> > +	return lock_is_held(&rcu_bh_lock_map);
> 
> i guess there could be a common helper here?

Will do!

> Also, could we clear rcu_scheduler_active when we clear debug_locks? That way 
> only a single test is needed, a generic 'is lock debugging active'.

Doing that will break synchronize_rcu(), which returns immediately if
!rcu_scheduler_active.

> (Which test should probably be unlikely() as well?)

Good point, will fix.

							Thanx, Paul
