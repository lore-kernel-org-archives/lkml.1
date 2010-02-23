Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0BWSBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:01:43 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34884 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab0BWSBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:01:41 -0500
Date: Tue, 23 Feb 2010 10:01:27 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/21] v6 add lockdep-based diagnostics to
	rcu_dereference()
Message-ID: <20100223180127.GF6700@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100223010435.GA666@linux.vnet.ibm.com> <201002231654.09724.arnd@arndb.de> <20100223161602.GD6700@linux.vnet.ibm.com> <201002231816.00117.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002231816.00117.arnd@arndb.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 06:15:59PM +0100, Arnd Bergmann wrote:
> On Tuesday 23 February 2010, Paul E. McKenney wrote:
> > We would also need something for initialization of structure fields.
> > Does __force work in that case as well?
> 
> Yes, it will just need some syntactical sugar to avoid placing __force
> in device drivers.

Very good!

> > > If there are cases where it does not work, we need to come up with
> > > names for new primitives that just do the assignment or dereference
> > > with __force but no actual synchronization.
> > 
> > Some data structures are shared by RCU and non-RCU code, with struct
> > list_head being the most prominent example.  Making the "next" pointer
> > as __rcu might be OK, but there are a -lot- of non-RCU uses of struct
> > list_head.  Would we really want to introduce rcu_dereference() to all
> > non-RCU list-traversal primitives, or do we need to do something else?
> 
> I've just started an experimental implementation and got stuck at list rcu.
> The two to deal with it that I can see are
> - ignore list-rcu for now, and make all include/linux/rculist.h __force the
>   problem to be ignored.
> - introduce a new struct rcu_list_head that needs to be used for list rcu.
> 
> A nicer option might be if sparse would let you write
> 'struct list_head __rcu head' and interpret that as having the pointers
> inside it annotated as __rcu.

Only the "next" pointer, not the "prev" pointer, but yes.

Perhaps it would be best to see if the sparse guys are willing to take
this on?

							Thanx, Paul
