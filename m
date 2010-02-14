Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0BNIYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 03:24:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51184 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab0BNIYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 03:24:06 -0500
Date: Sun, 14 Feb 2010 09:23:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 05/13] net: add checking to
 rcu_dereference() primitives
Message-ID: <20100214082314.GA12658@elte.hu>
References: <20100212000016.GA25781@linux.vnet.ibm.com>
 <1265932839-25899-5-git-send-email-paulmck@linux.vnet.ibm.com>
 <1265948152.2891.25.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265948152.2891.25.camel@edumazet-laptop>
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


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le jeudi 11 f??vrier 2010 ?? 16:00 -0800, Paul E. McKenney a ??crit :
> > Update rcu_dereference() primitives to use new lockdep-based checking.
> > The rcu_dereference() in __in6_dev_get() may be protected either by
> > rcu_read_lock() or RTNL, per Eric Dumazet.  The rcu_dereference()
> > in __sk_free() is protected by the fact that it is never reached if an
> > update could change it.  Check for this by using rcu_dereference_check()
> > to verify that the struct sock's ->sk_wmem_alloc counter is zero.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> CC to netdev and David Miller, network maintainer.
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> Thanks Paul, great work !

Dave, does this look good to you too? Cannot pick up the rest of the patchset 
without these checks/annotations into the RCU tree as there's too many 
warnings triggering in the networking code. So it's an all-or-nothing 
patchset in that regard.

Thanks,

	Ingo
