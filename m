Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbYHIASb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbYHIASb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 20:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYHIASW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 20:18:22 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55007 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYHIASW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 20:18:22 -0400
Date: Fri, 8 Aug 2008 17:18:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: [PATCH] printk: robustify printk
Message-ID: <20080809001820.GS6760@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1218217257.29098.2.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net> <20080808.160254.223161300.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808.160254.223161300.davem@davemloft.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 04:02:54PM -0700, David Miller wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri, 08 Aug 2008 20:14:28 +0200
> 
> > +struct klogd_wakeup_state {
> > +	struct rcu_head head;
> > +	int pending;
> > +};
> > +
> > +DEFINE_PER_CPU(struct klogd_wakeup_state, kws);
> 
> Since there is not RCU_HEAD_INIT() made on these per-cpu objects, this code
> is depending upon the fact that currently the RCU head is just initialized
> to all zeros.

RCU_HEAD_INIT() is only needed for debugging purposes, when you want
to be sure that any garbage in the rcu_head is due to corruption or
some such.  The call_rcu() function always completely initializes the
rcu_head structure.

							Thanx, Paul
