Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbXH0MIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbXH0MIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXH0MIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:08:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47673 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751707AbXH0MIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:08:11 -0400
Date: Mon, 27 Aug 2007 13:41:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthias Hensler <matthias@wspse.de>, Christian Hesse <mail@earthworm.de>,
       suspend2-devel@lists.tuxonice.net, Suspend2-users@lists.suspend2.net,
       linux-kernel@vger.kernel.org,
       suspend2-devel <suspend2-devel@lists.suspend2.net>,
       David Rodriguez <livuxman@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Suspend2-devel] Problem with CFS V20 and Suspend2/tuxonice
Message-ID: <20070827114120.GA1797@elf.ucw.cz>
References: <1946b54f0708250423k75d5797fuc5b032be7e143f26@mail.gmail.com> <1946b54f0708250429y570a1620y2796d0ff8abb02eb@mail.gmail.com> <b637ec0b0708250554m35decdb3ic8db88787fc3c0c9@mail.gmail.com> <200708251852.28698.mail@earthworm.de> <20070825184917.GA7945@kobayashi-maru.wspse.de> <20070825190223.GC15888@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070825190223.GC15888@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Same problem here: Core Duo, Kernel 2.6.22.5, Suspend 2.2.10, CFS 
> > > v20.2.
> > 
> > Me too for 2.6.22.5, TuxOnIce 2.2.10 and Centrino based notebook.
> 
> possible bugfix below.
> 
> 	Ingo
> 
> Index: linux-cfs-2.6.22.5.q/kernel/sched.c
> ===================================================================
> --- linux-cfs-2.6.22.5.q.orig/kernel/sched.c
> +++ linux-cfs-2.6.22.5.q/kernel/sched.c
> @@ -5043,6 +5043,8 @@ static int migration_thread(void *data)
>  		struct migration_req *req;
>  		struct list_head *head;
>  
> +		try_to_freeze();
> +
>  		spin_lock_irq(&rq->lock);
>  
>  		if (cpu_is_offline(cpu)) {

If it is NONFREEZE, you should not be trying to freeze it.

> @@ -5399,6 +5401,7 @@ migration_call(struct notifier_block *nf
>  		p = kthread_create(migration_thread, hcpu, "migration/%d", cpu);
>  		if (IS_ERR(p))
>  			return NOTIFY_BAD;
> +		p->flags |= PF_NOFREEZE;
>  		kthread_bind(p, cpu);
>  		/* Must be high prio: stop_machine expects to yield to it. */
>  		rq = task_rq_lock(p, &flags);

...plus I believe are tasks are nonfreezable by default now...? Or is
that only in 2.6.23?
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
