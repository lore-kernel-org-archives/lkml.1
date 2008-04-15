Return-Path: <linux-kernel-owner+w=401wt.eu-S1763801AbYDOBz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763801AbYDOBz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 21:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759233AbYDOBzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 21:55:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759114AbYDOBzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 21:55:19 -0400
Date: Mon, 14 Apr 2008 18:48:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, mingo@elte.hu, hch@infradead.org,
       mmlnx@us.ibm.com, dipankar@in.ibm.com, dsmith@redhat.com,
       rostedt@goodmis.org, adrian.bunk@movial.fi, a.p.zijlstra@chello.nl,
       ego@in.ibm.com, niv@us.ibm.com, dvhltc@us.ibm.com, rusty@au1.ibm.com,
       jkenisto@linux.vnet.ibm.com, oleg@tv-sign.ru, jamesclhuang@yahoo.com
Subject: Re: [PATCH 0/5] call_rcu_sched() series
Message-Id: <20080414184826.2aa665ad.akpm@linux-foundation.org>
In-Reply-To: <20080414184544.16ae4123.akpm@linux-foundation.org>
References: <20080414035848.GA30005@linux.vnet.ibm.com>
	<20080414183312.eba58a41.akpm@linux-foundation.org>
	<20080414184544.16ae4123.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 18:45:44 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 14 Apr 2008 18:33:12 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sun, 13 Apr 2008 20:58:48 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > This series adds call_rcu_sched(), applies some fixes to RCU Classic,
> > > adds rcu_barrier_sched(), updates rcutorture, and updates the RCU
> > > documentation.
> > 
> > Some massaging was needed here to make these apply against the
> > RCU changes in git-sched.
> > 
> > All fairly simple, except I don't know if these:
> > 
> > static inline void rcu_enter_nohz(void)
> > {
> > 	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
> > 	__get_cpu_var(rcu_dyntick_sched).dynticks++;
> > 	WARN_ON(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1);
> > }
> > 
> > static inline void rcu_exit_nohz(void)
> > {
> > 	__get_cpu_var(rcu_dyntick_sched).dynticks++;
> > 	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
> > 	WARN_ON(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1));
> > }
> > 
> > in include/linux/rcupreempt.h ended up the way we want them?
> 
> argh, I see.  It's all tangled up with the WARN_ON_SECS stuff.

No it isn't.  Don't mind me.

