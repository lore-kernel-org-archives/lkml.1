Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYKPEAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYKPEAi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYKPEA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:00:28 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60622 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbYKPEA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:00:27 -0500
Date: Sat, 15 Nov 2008 20:00:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 01/16] RCU read sched notrace
Message-ID: <20081116040026.GE7108@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081114224733.364965865@polymtl.ca> <20081114224947.336246671@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114224947.336246671@polymtl.ca>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 05:47:34PM -0500, Mathieu Desnoyers wrote:
> Add _notrace version to rcu_read_*_sched().
> 
> Impact: new API, useful for tracepoints and markers.

Looks good to me.  Just don't try it with rcu_read_lock(), given
preemptable RCU.  ;-)

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Paul E McKenney <paulmck@linux.vnet.ibm.com>
> CC: 'Ingo Molnar' <mingo@elte.hu>
> CC: akpm@linux-foundation.org
> ---
>  include/linux/rcupdate.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6-lttng/include/linux/rcupdate.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/rcupdate.h	2008-10-08 10:27:57.000000000 -0400
> +++ linux-2.6-lttng/include/linux/rcupdate.h	2008-10-08 10:40:48.000000000 -0400
> @@ -142,6 +142,7 @@ struct rcu_head {
>   * on the write-side to insure proper synchronization.
>   */
>  #define rcu_read_lock_sched() preempt_disable()
> +#define rcu_read_lock_sched_notrace() preempt_disable_notrace()
> 
>  /*
>   * rcu_read_unlock_sched - marks the end of a RCU-classic critical section
> @@ -149,6 +150,7 @@ struct rcu_head {
>   * See rcu_read_lock_sched for more information.
>   */
>  #define rcu_read_unlock_sched() preempt_enable()
> +#define rcu_read_unlock_sched_notrace() preempt_enable_notrace()
> 
> 
> 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
