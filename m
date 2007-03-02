Return-Path: <linux-kernel-owner+w=401wt.eu-S1030609AbXCBWSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030609AbXCBWSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030611AbXCBWSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:18:32 -0500
Received: from ozlabs.org ([203.10.76.45]:55211 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030609AbXCBWSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:18:31 -0500
Date: Fri, 2 Mar 2007 16:16:15 -0600
From: Anton Blanchard <anton@samba.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread
Message-ID: <20070302221615.GB22544@kryten>
References: <200702260800.49603.rjw@sisk.pl> <200703011609.43804.rjw@sisk.pl> <20070301193826.GA14587@kryten> <200703012054.26940.rjw@sisk.pl> <20070302213549.GC2373@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302213549.GC2373@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Paul,

> We certainly either need to embed try_to_freeze() into kthread_should_stop()
> or add back the rcu_torture_fakewriter(), and rcu_torture_reader()
> components of this patch.  ;-)
> 
> One way to embed try_to_freeze() into kthread_should_stop() might be
> as follows:
> 
> 	int kthread_should_stop(void)
> 	{
> 		if (kthread_stop_info.k == current)
> 			return 1;
> 		try_to_freeze();
> 		return 0;
> 	}
> 
> Does this seem reasonable?  It certainly would cut down some of the
> code required for freezing -- and reduce the potential for bugs.

Thats what I was thinking too :) 

Anton
