Return-Path: <linux-kernel-owner+w=401wt.eu-S965521AbXCATi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521AbXCATi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965534AbXCATi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:38:56 -0500
Received: from ozlabs.org ([203.10.76.45]:60296 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965533AbXCATiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:38:55 -0500
Date: Thu, 1 Mar 2007 13:38:26 -0600
From: Anton Blanchard <anton@samba.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@osdl.org>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread
Message-ID: <20070301193826.GA14587@kryten>
References: <200702260800.49603.rjw@sisk.pl> <200703011605.46692.rjw@sisk.pl> <200703011609.43804.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703011609.43804.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> Remove PF_NOFREEZE from the rcutorture thread, adding a
> try_to_freeze() call as required.

...

> @@ -607,6 +607,7 @@ rcu_torture_writer(void *arg)
>  		}
>  		rcu_torture_current_version++;
>  		oldbatch = cur_ops->completed();
> +		try_to_freeze();
>  	} while (!kthread_should_stop() && !fullstop);
>  	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
>  	while (!kthread_should_stop())

I wonder if it makes sense to embed try_to_freeze() into the kthread
API somewhere. Short of that we should document the try_to_freeze()
requirement in the kthread documentation... Unfortunately I cant find
any kthread docs in Documentation/ :)

Anton
