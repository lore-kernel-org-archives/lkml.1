Return-Path: <linux-kernel-owner+w=401wt.eu-S1751813AbXBCWwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbXBCWwG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 17:52:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbXBCWwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 17:52:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57372 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbXBCWwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 17:52:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Date: Sat, 3 Feb 2007 23:27:24 +0100
User-Agent: KMail/1.9.1
Cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, dipankar@in.ibm.com,
       Gautham Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
References: <20070126112837.059502fc.akpm@osdl.org> <200701301744.48601.rjw@sisk.pl> <20070203000153.GA1712@elf.ucw.cz>
In-Reply-To: <20070203000153.GA1712@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702032327.25163.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 3 February 2007 01:01, Pavel Machek wrote:
> Hi!
> 
> > > > > 	static int _cpu_down(unsigned int cpu)
> > > > > 	{
> > > > > 		int err;
> > > > > 		struct task_struct *p;
> > > > > 		cpumask_t old_allowed, tmp;
> > > > > 
> > > > > 		if (num_online_cpus() == 1)
> > > > > 			return -EBUSY;
> > > > > 
> > > > > 		if (!cpu_online(cpu))
> > > > > 			return -EINVAL;
> > > > > 
> > > > > 		if (freeze_processes()) {
> > > > > 			err = -EBUSY;
> > > > > 			goto out_freeze_notify_failed;
> > > > > 		}
> > > > > 		err = raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
> > > > > 							(void *)(long)cpu);
> > > > 
> > > > yeah. This all looks so nice that i almost cannot believe it's true :-) 
> > > 
> > > Well, it turns out that maybe it is in fact untrue.  :-/
> > > 
> > > I need to look at all uses of PF_NOFREEZE -- as I understand the
> > > code, processes marked PF_NOFREEZE will continue running, potentially
> > > interfering with the hotplug operation.  :-(
> > > 
> > > I will pass my findings on to this list.
> > 
> > Well, I did it some time ago, although not very thoroughly.
> > 
> > AFAICS there are not so many, but one that stands out is the worker threads.
> > We needed two of them to actually go to sleep, so now it's possible to create
> > a "freezeable workqueue" the worker thread of which will not set PF_NOFREEZE,
> > but currently this is only used by XFS.
> 
> We should slowly move as workqueues to freezeable ones... Having too
> much stuff NOFREEZE is evil, even for swsusp.

On the other hand, some of the workqueues may be necessary for saving the image
(still, I have no examples ;-)).

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King

