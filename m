Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbZJZQ3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbZJZQ3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbZJZQ3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:29:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40097 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbZJZQ3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:29:51 -0400
Date: Mon, 26 Oct 2009 09:29:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, dhowells@redhat.com,
       tglx@linutronix.de, josh@joshtriplett.org
Subject: Re: [tip:core/rcu] rcu: Do tiny cleanups in rcutiny
Message-ID: <20091026162952.GA14684@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-4ce5b90340879ce93d169b7b523c2cbbe7c45843@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-4ce5b90340879ce93d169b7b523c2cbbe7c45843@git.kernel.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 11:37:58AM +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  4ce5b90340879ce93d169b7b523c2cbbe7c45843
> Gitweb:     http://git.kernel.org/tip/4ce5b90340879ce93d169b7b523c2cbbe7c45843
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Mon, 26 Oct 2009 07:55:55 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 26 Oct 2009 09:40:40 +0100
> 
> rcu: Do tiny cleanups in rcutiny
> 
> No change in functionality - just straighten out a few small
> stylistic details.

These all look good to me.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: laijs@cn.fujitsu.com
> Cc: dipankar@in.ibm.com
> Cc: mathieu.desnoyers@polymtl.ca
> Cc: dvhltc@us.ibm.com
> Cc: niv@us.ibm.com
> Cc: peterz@infradead.org
> Cc: rostedt@goodmis.org
> Cc: Valdis.Kletnieks@vt.edu
> Cc: avi@redhat.com
> Cc: mtosatti@redhat.com
> LKML-Reference: <12565226351355-git-send-email->
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/rcutiny.h |    6 +---
>  kernel/rcutiny.c        |   49 ++++++++++++++++++++++------------------------
>  2 files changed, 25 insertions(+), 30 deletions(-)
> 
> diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
> index 891073c..2c1fe83 100644
> --- a/include/linux/rcutiny.h
> +++ b/include/linux/rcutiny.h
> @@ -20,9 +20,8 @@
>   * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>   *
>   * For detailed explanation of Read-Copy Update mechanism see -
> - * 		Documentation/RCU
> + *		Documentation/RCU
>   */
> -
>  #ifndef __LINUX_TINY_H
>  #define __LINUX_TINY_H
> 
> @@ -70,8 +69,7 @@ static inline void synchronize_rcu_bh_expedited(void)
>  }
> 
>  struct notifier_block;
> -extern int rcu_cpu_notify(struct notifier_block *self,
> -			  unsigned long action, void *hcpu);
> +extern int rcu_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu);
> 
>  #ifdef CONFIG_NO_HZ
> 
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 0b54efd..b33ec3a 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -20,22 +20,21 @@
>   * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>   *
>   * For detailed explanation of Read-Copy Update mechanism see -
> - * 		Documentation/RCU
> + *		Documentation/RCU
>   */
> -
> -#include <linux/types.h>
> -#include <linux/kernel.h>
> -#include <linux/init.h>
> -#include <linux/rcupdate.h>
> -#include <linux/interrupt.h>
> -#include <linux/sched.h>
> -#include <linux/module.h>
> -#include <linux/completion.h>
>  #include <linux/moduleparam.h>
> +#include <linux/completion.h>
> +#include <linux/interrupt.h>
>  #include <linux/notifier.h>
> -#include <linux/cpu.h>
> +#include <linux/rcupdate.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/sched.h>
> +#include <linux/types.h>
> +#include <linux/init.h>
>  #include <linux/time.h>
> +#include <linux/cpu.h>
> 
>  /* Global control variables for rcupdate callback mechanism. */
>  struct rcu_ctrlblk {
> @@ -46,14 +45,13 @@ struct rcu_ctrlblk {
> 
>  /* Definition for rcupdate control block. */
>  static struct rcu_ctrlblk rcu_ctrlblk = {
> -	.rcucblist = NULL,
> -	.donetail = &rcu_ctrlblk.rcucblist,
> -	.curtail = &rcu_ctrlblk.rcucblist,
> +	.donetail	= &rcu_ctrlblk.rcucblist,
> +	.curtail	= &rcu_ctrlblk.rcucblist,
>  };
> +
>  static struct rcu_ctrlblk rcu_bh_ctrlblk = {
> -	.rcucblist = NULL,
> -	.donetail = &rcu_bh_ctrlblk.rcucblist,
> -	.curtail = &rcu_bh_ctrlblk.rcucblist,
> +	.donetail	= &rcu_bh_ctrlblk.rcucblist,
> +	.curtail	= &rcu_bh_ctrlblk.rcucblist,
>  };
> 
>  #ifdef CONFIG_NO_HZ
> @@ -84,8 +82,8 @@ void rcu_exit_nohz(void)
> 
>  /*
>   * Helper function for rcu_qsctr_inc() and rcu_bh_qsctr_inc().
> - * Also disable irqs to avoid confusion due to interrupt handlers invoking
> - * call_rcu().
> + * Also disable irqs to avoid confusion due to interrupt handlers
> + * invoking call_rcu().
>   */
>  static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
>  {
> @@ -99,6 +97,7 @@ static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
>  		return 1;
>  	}
>  	local_irq_restore(flags);
> +
>  	return 0;
>  }
> 
> @@ -143,8 +142,8 @@ void rcu_check_callbacks(int cpu, int user)
>   */
>  static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
>  {
> -	unsigned long flags;
>  	struct rcu_head *next, *list;
> +	unsigned long flags;
> 
>  	/* If no RCU callbacks ready to invoke, just return. */
>  	if (&rcp->rcucblist == rcp->donetail)
> @@ -182,8 +181,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
>   * Null function to handle CPU being onlined.  Longer term, we want to
>   * make TINY_RCU avoid using rcupdate.c, but later...
>   */
> -int rcu_cpu_notify(struct notifier_block *self,
> -		   unsigned long action, void *hcpu)
> +int rcu_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
>  {
>  	return NOTIFY_OK;
>  }
> @@ -223,6 +221,7 @@ static void __call_rcu(struct rcu_head *head,
> 
>  	head->func = func;
>  	head->next = NULL;
> +
>  	local_irq_save(flags);
>  	*rcp->curtail = head;
>  	rcp->curtail = &head->next;
> @@ -234,8 +233,7 @@ static void __call_rcu(struct rcu_head *head,
>   * period.  But since we have but one CPU, that would be after any
>   * quiescent state.
>   */
> -void call_rcu(struct rcu_head *head,
> -	      void (*func)(struct rcu_head *rcu))
> +void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
>  {
>  	__call_rcu(head, func, &rcu_ctrlblk);
>  }
> @@ -245,8 +243,7 @@ EXPORT_SYMBOL_GPL(call_rcu);
>   * Post an RCU bottom-half callback to be invoked after any subsequent
>   * quiescent state.
>   */
> -void call_rcu_bh(struct rcu_head *head,
> -		 void (*func)(struct rcu_head *rcu))
> +void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
>  {
>  	__call_rcu(head, func, &rcu_bh_ctrlblk);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
