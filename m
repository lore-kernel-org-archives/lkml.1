Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbXH0MPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbXH0MPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbXH0MPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:15:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44843 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480AbXH0MPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:15:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [Suspend2-devel] Problem with CFS V20 and Suspend2/tuxonice
Date: Mon, 27 Aug 2007 14:25:47 +0200
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Matthias Hensler <matthias@wspse.de>,
       Christian Hesse <mail@earthworm.de>, suspend2-devel@lists.tuxonice.net,
       Suspend2-users@lists.suspend2.net, linux-kernel@vger.kernel.org,
       suspend2-devel <suspend2-devel@lists.suspend2.net>,
       David Rodriguez <livuxman@gmail.com>
References: <1946b54f0708250423k75d5797fuc5b032be7e143f26@mail.gmail.com> <20070825190223.GC15888@elte.hu> <20070827114120.GA1797@elf.ucw.cz>
In-Reply-To: <20070827114120.GA1797@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708271425.48135.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 27 August 2007 13:41, Pavel Machek wrote:
> Hi!
> 
> > > > Same problem here: Core Duo, Kernel 2.6.22.5, Suspend 2.2.10, CFS 
> > > > v20.2.
> > > 
> > > Me too for 2.6.22.5, TuxOnIce 2.2.10 and Centrino based notebook.
> > 
> > possible bugfix below.
> > 
> > 	Ingo
> > 
> > Index: linux-cfs-2.6.22.5.q/kernel/sched.c
> > ===================================================================
> > --- linux-cfs-2.6.22.5.q.orig/kernel/sched.c
> > +++ linux-cfs-2.6.22.5.q/kernel/sched.c
> > @@ -5043,6 +5043,8 @@ static int migration_thread(void *data)
> >  		struct migration_req *req;
> >  		struct list_head *head;
> >  
> > +		try_to_freeze();
> > +
> >  		spin_lock_irq(&rq->lock);
> >  
> >  		if (cpu_is_offline(cpu)) {
> 
> If it is NONFREEZE, you should not be trying to freeze it.
> 
> > @@ -5399,6 +5401,7 @@ migration_call(struct notifier_block *nf
> >  		p = kthread_create(migration_thread, hcpu, "migration/%d", cpu);
> >  		if (IS_ERR(p))
> >  			return NOTIFY_BAD;
> > +		p->flags |= PF_NOFREEZE;
> >  		kthread_bind(p, cpu);
> >  		/* Must be high prio: stop_machine expects to yield to it. */
> >  		rq = task_rq_lock(p, &flags);
> 
> ...plus I believe are tasks are nonfreezable by default now...? Or is
> that only in 2.6.23?

Yes, only in 2.6.23-rc.

Greetings,
Rafael
