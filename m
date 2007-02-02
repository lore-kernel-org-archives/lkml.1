Return-Path: <linux-kernel-owner+w=401wt.eu-S1945955AbXBBP5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945955AbXBBP5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 10:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945957AbXBBP5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 10:57:14 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:42520 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945955AbXBBP5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 10:57:13 -0500
Date: Fri, 2 Feb 2007 07:56:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, dipankar@in.ibm.com,
       tytso@us.ibm.com, dvhltc@us.ibm.com, oleg@tv-sign.ru,
       twoerner.k@gmail.com, josh@freedesktop.org, billh@gnuppy.monkey.org,
       nielsen.esben@googlemail.com, corbet@lwn.net
Subject: Re: [RFC PATCH -rt 1/2] RCU priority boosting that survives vicious testing
Message-ID: <20070202155646.GB4732@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070201012136.GA21770@linux.vnet.ibm.com> <20070201012445.GA22922@linux.vnet.ibm.com> <20070201082333.GA18233@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201082333.GA18233@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 09:23:33AM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Here is the RCU priority-boosting patch.  Pretty close to the 
> > http://lkml.org/lkml/2007/1/24/295 version.  This patch prevents 
> > preempted or blocked low-priority RCU readers from indefinitely 
> > stalling RCU grace periods.
> 
> thanks - i've applied both patches to -rt and it's looking good so far! 
> Find a small cosmetic fix below.

Sorry for the %d noise!  :-/

I will send another patch addressing Nigel's freeze_processes()
review comments.

						Thanx, Paul

> 	Ingo
> 
> Index: linux/kernel/rcupreempt.c
> ===================================================================
> --- linux.orig/kernel/rcupreempt.c
> +++ linux/kernel/rcupreempt.c
> @@ -489,7 +489,7 @@ void init_rcu_boost_late(void)
>  	rcu_boost_task = kthread_run(rcu_booster, NULL, "RCU Prio Booster");
>  	if (IS_ERR(rcu_boost_task)) {
>  		printk(KERN_ALERT
> -		       "Unable to create RCU Priority Booster, errno %d\n",
> +		       "Unable to create RCU Priority Booster, errno %ld\n",
>  		       -PTR_ERR(rcu_boost_task));
> 
>  		/*
