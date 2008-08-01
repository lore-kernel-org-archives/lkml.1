Return-Path: <linux-kernel-owner+w=401wt.eu-S1762196AbYHAVVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762196AbYHAVVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760760AbYHAVNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:13:17 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50607 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761473AbYHAVNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:13:14 -0400
Date: Fri, 1 Aug 2008 14:11:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.org>
Subject: Re: [PATCH 1/2] rcu: just rename call_rcu_bh instead of making it
	a macro
Message-ID: <20080801211123.GE14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080730182053.872043059@goodmis.org> <20080730182239.346811562@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730182239.346811562@goodmis.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 02:20:54PM -0400, Steven Rostedt wrote:
> Seems that I found a box that has a config that passes call_rcu_bh as a
> function pointer (see net/sctp/sm_make_chunk.c), so declaring the
> call_rcu_bh has a macro function isn't good enough.
> 
> This patch makes it just another name of call_rcu for rcupreempt.

Looks good!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Steven Rostedt <srostedt@redhat.org>
> 
> ---
>  include/linux/rcupreempt.h |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> Index: linux-compile.git/include/linux/rcupreempt.h
> ===================================================================
> --- linux-compile.git.orig/include/linux/rcupreempt.h	2008-07-30 13:56:28.000000000 -0400
> +++ linux-compile.git/include/linux/rcupreempt.h	2008-07-30 13:57:57.000000000 -0400
> @@ -57,7 +57,13 @@ static inline void rcu_qsctr_inc(int cpu
>  	rdssp->sched_qs++;
>  }
>  #define rcu_bh_qsctr_inc(cpu)
> -#define call_rcu_bh(head, rcu) call_rcu(head, rcu)
> +
> +/*
> + * Someone might want to pass call_rcu_bh as a function pointer.
> + * So this needs to just be a rename and not a macro function.
> + *  (no parentheses)
> + */
> +#define call_rcu_bh	 	call_rcu
> 
>  /**
>   * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
> 
> -- 
