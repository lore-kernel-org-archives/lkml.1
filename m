Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbYCYSth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbYCYSth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbYCYSt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:49:29 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50145 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbYCYSt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:49:29 -0400
Date: Tue, 25 Mar 2008 11:49:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       hch@infradead.org, mmlnx@us.ibm.com, dipankar@in.ibm.com,
       dsmith@redhat.com, rostedt@goodmis.org, adrian.bunk@movial.fi,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, rusty@au1.ibm.com, jkenisto@linux.vnet.ibm.com,
       oleg@tv-sign.ru
Subject: Re: [PATCH,RFC] Initialize call_rcu_sched sooner
Message-ID: <20080325184912.GL4555@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080321143615.GA936@linux.vnet.ibm.com> <20080321224026.GA10169@linux.vnet.ibm.com> <20080324050652.GA4906@Krystal> <20080324054630.GE4555@linux.vnet.ibm.com> <20080325125308.GA19690@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325125308.GA19690@Krystal>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 08:53:08AM -0400, Mathieu Desnoyers wrote:
> Initialize call_rcu_sched sooner so it can be used in module_init stage.
> 
> (needed for LTTng)

This passes smoke tests, so have incorporated it.  Thank you, Mathieu!!!

						Thanx, Paul

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  init/main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/init/main.c
> ===================================================================
> --- linux-2.6-lttng.orig/init/main.c	2008-03-25 08:49:02.000000000 -0400
> +++ linux-2.6-lttng/init/main.c	2008-03-25 08:49:20.000000000 -0400
> @@ -738,13 +738,13 @@ static void __init do_initcalls(void)
>   */
>  static void __init do_basic_setup(void)
>  {
> +	rcu_init_sched();
>  	/* drivers will send hotplug events */
>  	init_workqueues();
>  	usermodehelper_init();
>  	driver_init();
>  	init_irq_proc();
>  	do_initcalls();
> -	rcu_init_sched();
>  }
> 
>  static int __initdata nosoftlockup;
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
