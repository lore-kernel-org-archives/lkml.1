Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYBOVnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYBOVnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYBOVnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:43:14 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53562 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbYBOVnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:43:13 -0500
Date: Fri, 15 Feb 2008 13:42:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org
Subject: Re: [PATCH] rcu_batches_completed prototype cleanup
Message-ID: <20080215214231.GA8602@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.58.0802142335280.17968@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0802142335280.17968@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 11:57:48PM -0500, Steven Rostedt wrote:
> 
> rcu_batches_completed and rcu_patches_completed_bh are both declared
> in rcuclassic.h and rcupreempt.h. This patch removes the extra
> prototypes for them from rcupdate.h.
> 
> rcu_batches_completed_bh is defined as a static inline in the rcupreempt.h
> header file. Trying to export this as EXPORT_SYMBOL_GPL causes section
> problems with the powerpc compiler. There's no need to export a static
> inlined function.
> 
> Modules must be compiled with the same type of RCU implementation as the
> kernel they are for.

Good catch, and works fine here against 2.6.25-rc1.  Andrew, Linus,
could you please apply this?

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/linux/rcupdate.h |    2 --
>  kernel/rcupreempt.c      |    2 --
>  2 files changed, 4 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 37a642c..ae5ba4e 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -238,8 +238,6 @@ extern void call_rcu_bh(struct rcu_head *head,
>  /* Exported common interfaces */
>  extern void synchronize_rcu(void);
>  extern void rcu_barrier(void);
> -extern long rcu_batches_completed(void);
> -extern long rcu_batches_completed_bh(void);
> 
>  /* Internal to kernel */
>  extern void rcu_init(void);
> diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
> index 987cfb7..bdd0a1d 100644
> --- a/kernel/rcupreempt.c
> +++ b/kernel/rcupreempt.c
> @@ -213,8 +213,6 @@ long rcu_batches_completed(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_batches_completed);
> 
> -EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
> -
>  void __rcu_read_lock(void)
>  {
>  	int idx;
> 
