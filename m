Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab0BWRRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:17:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49165 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0BWRRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:17:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH tip/core/rcu 0/21] v6 add lockdep-based diagnostics to rcu_dereference()
Date: Tue, 23 Feb 2010 18:15:59 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
References: <20100223010435.GA666@linux.vnet.ibm.com> <201002231654.09724.arnd@arndb.de> <20100223161602.GD6700@linux.vnet.ibm.com>
In-Reply-To: <20100223161602.GD6700@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002231816.00117.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+VaHijxdXBAVtmCmbtOktgxuvddqu0QJUXFNW
 5CasZ7N4M1Nnl9sB3VEPEcfX9hhzUBsaP4+ULwM8zOy3EDP2sN
 CtXPxWIwuU/1HMqIHMWnQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 February 2010, Paul E. McKenney wrote:
> We would also need something for initialization of structure fields.
> Does __force work in that case as well?

Yes, it will just need some syntactical sugar to avoid placing __force
in device drivers.

> > If there are cases where it does not work, we need to come up with
> > names for new primitives that just do the assignment or dereference
> > with __force but no actual synchronization.
> 
> Some data structures are shared by RCU and non-RCU code, with struct
> list_head being the most prominent example.  Making the "next" pointer
> as __rcu might be OK, but there are a -lot- of non-RCU uses of struct
> list_head.  Would we really want to introduce rcu_dereference() to all
> non-RCU list-traversal primitives, or do we need to do something else?

I've just started an experimental implementation and got stuck at list rcu.
The two to deal with it that I can see are
- ignore list-rcu for now, and make all include/linux/rculist.h __force the
  problem to be ignored.
- introduce a new struct rcu_list_head that needs to be used for list rcu.

A nicer option might be if sparse would let you write
'struct list_head __rcu head' and interpret that as having the pointers
inside it annotated as __rcu.

	Arnd
