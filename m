Return-Path: <linux-kernel-owner+w=401wt.eu-S1161313AbXCBH3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161313AbXCBH3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 02:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161317AbXCBH3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 02:29:25 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:51364 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161313AbXCBH3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 02:29:24 -0500
Date: Fri, 2 Mar 2007 12:27:30 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@osdl.org>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread
Message-ID: <20070302065729.GA22085@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200702260800.49603.rjw@sisk.pl> <200703011605.46692.rjw@sisk.pl> <200703011609.43804.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703011609.43804.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Remove PF_NOFREEZE from the rcutorture thread, adding a try_to_freeze() call as
> required.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---
>  kernel/rcutorture.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.20-mm2/kernel/rcutorture.c
> ===================================================================
> --- linux-2.6.20-mm2.orig/kernel/rcutorture.c	2007-02-25 12:07:15.000000000 +0100
> +++ linux-2.6.20-mm2/kernel/rcutorture.c	2007-02-25 12:49:23.000000000 +0100
> @@ -46,6 +46,7 @@
>  #include <linux/byteorder/swabb.h>
>  #include <linux/stat.h>
>  #include <linux/srcu.h>
> +#include <linux/freezer.h>
> 
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
> @@ -585,7 +586,6 @@ rcu_torture_writer(void *arg)
> 
>  	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
>  	set_user_nice(current, 19);
> -	current->flags |= PF_NOFREEZE;
> 
>  	do {
>  		schedule_timeout_uninterruptible(1);
> @@ -607,6 +607,7 @@ rcu_torture_writer(void *arg)
>  		}
>  		rcu_torture_current_version++;
>  		oldbatch = cur_ops->completed();
> +		try_to_freeze();
>  	} while (!kthread_should_stop() && !fullstop);
>  	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
>  	while (!kthread_should_stop())

Paul, 
Any reasons for not try_to_freeze()'ing the fakewriter and the reader
threads?? (Ok, I admit, I haven't looked into the code for the reason
which might be obvious.)


thanks
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
