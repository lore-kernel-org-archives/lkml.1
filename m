Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbZI0Pl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbZI0Pl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 11:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZI0Pl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 11:41:58 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:43713 "EHLO
	relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbZI0Pl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 11:41:57 -0400
Date: Sun, 27 Sep 2009 08:41:28 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Apply review feedback from Josh
 Triplett, part 3
Message-ID: <20090927154128.GB2445@feather>
References: <20090927064753.GA9394@linux.vnet.ibm.com>
 <12540341911389-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12540341911389-git-send-email->
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 11:49:50PM -0700, Paul E. McKenney wrote:
> Whitespace fixes, updated comments, and trivial code movement.
> 
> o	Fix whitespace error in RCU_HEAD_INIT()
> 
> o	Move "So where is rcu_write_lock()" comment so that it does
> 	not come between the rcu_read_unlock() header comment and
> 	the rcu_read_unlock() definition.
> 
> o	Move the module_param statements for blimit, qhimark, and qlowmark
> 	to immediately follow the corresponding definitions.
> 
> o	In __rcu_offline_cpu(), move the assignment to rdp_me inside the
> 	"if" statement, given that rdp_me is not used outside of that "if"
> 	statement.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  include/linux/rcupdate.h |   14 +++++++-------
>  kernel/rcutree.c         |   10 +++++-----
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index b2f1e10..6dd71fa 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -83,7 +83,7 @@ extern int rcu_scheduler_active;
>  #error "Unknown RCU implementation specified to kernel configuration"
>  #endif
>  
> -#define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
> +#define RCU_HEAD_INIT	{ .next = NULL, .func = NULL }
>  #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
>  #define INIT_RCU_HEAD(ptr) do { \
>         (ptr)->next = NULL; (ptr)->func = NULL; \
> @@ -135,12 +135,6 @@ static inline void rcu_read_lock(void)
>  	rcu_read_acquire();
>  }
>  
> -/**
> - * rcu_read_unlock - marks the end of an RCU read-side critical section.
> - *
> - * See rcu_read_lock() for more information.
> - */
> -
>  /*
>   * So where is rcu_write_lock()?  It does not exist, as there is no
>   * way for writers to lock out RCU readers.  This is a feature, not
> @@ -150,6 +144,12 @@ static inline void rcu_read_lock(void)
>   * used as well.  RCU does not care how the writers keep out of each
>   * others' way, as long as they do so.
>   */
> +
> +/**
> + * rcu_read_unlock - marks the end of an RCU read-side critical section.
> + *
> + * See rcu_read_lock() for more information.
> + */
>  static inline void rcu_read_unlock(void)
>  {
>  	rcu_read_release();
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 45eb2d1..1ccdd5b 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -121,6 +121,10 @@ static int blimit = 10;		/* Maximum callbacks per softirq. */
>  static int qhimark = 10000;	/* If this many pending, ignore blimit. */
>  static int qlowmark = 100;	/* Once only this many pending, use blimit. */
>  
> +module_param(blimit, int, 0);
> +module_param(qhimark, int, 0);
> +module_param(qlowmark, int, 0);
> +
>  static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
>  static int rcu_pending(int cpu);
>  
> @@ -873,8 +877,8 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
>  	 * indefinitely delay callbacks, you have far worse things to
>  	 * be worrying about.
>  	 */
> -	rdp_me = rsp->rda[smp_processor_id()];
>  	if (rdp->nxtlist != NULL) {
> +		rdp_me = rsp->rda[smp_processor_id()];
>  		*rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
>  		rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
>  		rdp->nxtlist = NULL;
> @@ -1570,7 +1574,3 @@ void __init __rcu_init(void)
>  }
>  
>  #include "rcutree_plugin.h"
> -
> -module_param(blimit, int, 0);
> -module_param(qhimark, int, 0);
> -module_param(qlowmark, int, 0);
> -- 
> 1.5.2.5
> 
