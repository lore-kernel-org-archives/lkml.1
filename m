Return-Path: <linux-kernel-owner+w=401wt.eu-S1946444AbXBCLHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946444AbXBCLHR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 06:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946448AbXBCLHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 06:07:17 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46704 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946444AbXBCLHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 06:07:15 -0500
Date: Sat, 3 Feb 2007 01:01:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, dipankar@in.ibm.com,
       Gautham Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-ID: <20070203000153.GA1712@elf.ucw.cz>
References: <20070126112837.059502fc.akpm@osdl.org> <20070130073340.GC30160@elte.hu> <20070130160244.GB2092@linux.vnet.ibm.com> <200701301744.48601.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701301744.48601.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > 	static int _cpu_down(unsigned int cpu)
> > > > 	{
> > > > 		int err;
> > > > 		struct task_struct *p;
> > > > 		cpumask_t old_allowed, tmp;
> > > > 
> > > > 		if (num_online_cpus() == 1)
> > > > 			return -EBUSY;
> > > > 
> > > > 		if (!cpu_online(cpu))
> > > > 			return -EINVAL;
> > > > 
> > > > 		if (freeze_processes()) {
> > > > 			err = -EBUSY;
> > > > 			goto out_freeze_notify_failed;
> > > > 		}
> > > > 		err = raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
> > > > 							(void *)(long)cpu);
> > > 
> > > yeah. This all looks so nice that i almost cannot believe it's true :-) 
> > 
> > Well, it turns out that maybe it is in fact untrue.  :-/
> > 
> > I need to look at all uses of PF_NOFREEZE -- as I understand the
> > code, processes marked PF_NOFREEZE will continue running, potentially
> > interfering with the hotplug operation.  :-(
> > 
> > I will pass my findings on to this list.
> 
> Well, I did it some time ago, although not very thoroughly.
> 
> AFAICS there are not so many, but one that stands out is the worker threads.
> We needed two of them to actually go to sleep, so now it's possible to create
> a "freezeable workqueue" the worker thread of which will not set PF_NOFREEZE,
> but currently this is only used by XFS.

We should slowly move as workqueues to freezeable ones... Having too
much stuff NOFREEZE is evil, even for swsusp.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
