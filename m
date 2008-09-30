Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbYI3NKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbYI3NKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 09:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYI3NKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 09:10:37 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35451 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbYI3NKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 09:10:36 -0400
Date: Tue, 30 Sep 2008 06:10:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] RCU read sched
Message-ID: <20080930131034.GA6716@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu> <20080929150646.GD11245@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929150646.GD11245@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 11:06:46AM -0400, Mathieu Desnoyers wrote:
> (probably already in -tip)
> 
> Add rcu_read_lock_sched() and rcu_read_unlock_sched() to rcupdate.h to match the
> recently added write-side call_rcu_sched() and rcu_barrier_sched(). They also
> match the no-so-recently-added synchronize_sched().
> 
> It will help following matching use of the update/read lock primitives. Those
> new read lock will replace preempt_disable()/enable() used in pair with
> RCU-classic synchronization.

Looks like a very good addition to me!

							Thanx, Paul

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> CC: Paul E McKenney <paulmck@linux.vnet.ibm.com>
> CC: akpm@linux-foundation.org
> ---
>  include/linux/rcupdate.h |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> Index: linux-2.6-lttng/include/linux/rcupdate.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/rcupdate.h	2008-07-15 15:18:20.000000000 -0400
> +++ linux-2.6-lttng/include/linux/rcupdate.h	2008-07-15 15:18:46.000000000 -0400
> @@ -132,6 +132,26 @@ struct rcu_head {
>  #define rcu_read_unlock_bh() __rcu_read_unlock_bh()
> 
>  /**
> + * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
> + *
> + * Should be used with either
> + * - synchronize_sched()
> + * or
> + * - call_rcu_sched() and rcu_barrier_sched()
> + * on the write-side to insure proper synchronization.
> + */
> +#define rcu_read_lock_sched() preempt_disable()
> +
> +/*
> + * rcu_read_unlock_sched - marks the end of a RCU-classic critical section
> + *
> + * See rcu_read_lock_sched for more information.
> + */
> +#define rcu_read_unlock_sched() preempt_enable()
> +
> +
> +
> +/**
>   * rcu_dereference - fetch an RCU-protected pointer in an
>   * RCU read-side critical section.  This pointer may later
>   * be safely dereferenced.
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
