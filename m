Return-Path: <linux-kernel-owner+w=401wt.eu-S965989AbXG3F1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965989AbXG3F1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 01:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759543AbXG3F06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 01:26:58 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52733 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761049AbXG3F05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 01:26:57 -0400
Date: Sun, 29 Jul 2007 22:26:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt 1/9] preempt rcu: check for underflow
Message-ID: <20070730052653.GD26610@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070730024534.369897977@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730024534.369897977@mvista.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 07:45:35PM -0700, Daniel Walker wrote:
> Simple WARN_ON to catch any underflow in rcu_read_lock_nesting.
> 
> Signed-off-by: Daniel Walker <dwalker@mvista.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/rcupreempt.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux-2.6.22/kernel/rcupreempt.c
> ===================================================================
> --- linux-2.6.22.orig/kernel/rcupreempt.c
> +++ linux-2.6.22/kernel/rcupreempt.c
> @@ -157,6 +157,12 @@ void __rcu_read_unlock(void)
>  	}
> 
>  	local_irq_restore(oldirq);
> +
> +	/*
> +	 * If our rcu_read_lock_nesting went negative, likely
> +	 * something is wrong..
> +	 */
> +	WARN_ON(current->rcu_read_lock_nesting < 0);
>  }
> 
>  static void __rcu_advance_callbacks(void)
> 
> -- 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
