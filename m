Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZCZB0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZCZB0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 21:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbZCZB0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 21:26:40 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:34413 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbZCZB0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 21:26:39 -0400
Date: Wed, 25 Mar 2009 19:26:36 -0600
From: Alex Chiang <achiang@hp.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: htejun@gmail.com, greg@kroah.com, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] sysfs: allow suicide
Message-ID: <20090326012636.GC11447@ldl.fc.hp.com>
References: <20090325035707.15921.42150.stgit@bob.kio> <m13ad2xi46.fsf@fess.ebiederm.org> <20090325225414.GA11447@ldl.fc.hp.com> <m17i2dunao.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17i2dunao.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric W. Biederman <ebiederm@xmission.com>:
> Alex Chiang <achiang@hp.com> writes:
> 
> > * Eric W. Biederman <ebiederm@xmission.com>:
> >> 
> >> Interesting.
> >> 
> >> Fixing a read/writer deadlock by allowing the writers to nest
> >> inside the readers.
> >> 
> >> My first impression is that it is too clever.
> >
> > Clever points go to Tejun. All I did was refresh the series
> > slightly. :)
> >
> >> Furthermore I think this is walking around the edges of a more
> >> general problem.   How should we serial hotplug and hotunplug
> >> in general.  In what context should remove methods run in.
> >> 
> >> My impression is that we have a huge hole in our infrastructure
> >> for hotplug drivers.  Problems like how do we get a user space
> >> context for the code to run in and how do we handle
> >> multiple hotplug actions for overlapping device trees from
> >> stomping on each other.
> >> 
> >> My hypothesis is once we solve this for the general case of
> >> device hotplug and removal we won't need special support from
> >> sysfs.  At least not in the suicidal way.
> >
> > I agree that we have problems in our infrastructure, especially,
> > as you point out, overlapping device trees, etc.
> >
> > I see your point about adding extra cruft into sysfs to work
> > around a special case while leaving the hard problem unsolved.
> >
> > Perhaps the status quo is better. I do think that getting
> > suicidal sysfs attributes off the global workqueue is a band-aid
> > that actually helps, vs. the proposed patches here which are
> > questionable in nature.
> 
> Sounds like it.    I'm not trying to shoot this down, rather
> I'm trying to figure out how to solve this cleanly, as I am slowly
> trying to sort out the pci hotplug and unplug issues.

Please do keep me informed on any progress you make or thoughts
you have here.

> I'm not certain how general we can be. pci layer, device layer or kobject
> layer, but I think it makes sense to have a dedicated work queue to use
> when devices are removed.  As every hotplug driver currently has to
> invent one.  The fake hotplug code is very normal in this respect.
> 
> If we can get the work queue creation and the calling of remove put
> into the generic pci layer, we should be able to simply all of the
> hotplug controller drivers.

Hm, that is a good idea.

Simplifying all the various hotplug drivers is on my TODO list,
but it's a long and tricky process. I agree though, there is no
reason why they should all be as complicated as they are.

> I'm not seeing a patch from you where you are using a separate
> workqueue.  Am I missing something?  

	http://lkml.org/lkml/2009/3/25/489

But I suspect that is not the workqueue you are looking for. ;)

> But if we can place that workqueue in say the pci layer I think
> it would be just a little re factoring and not a lot more code.

The PCI layer doesn't need a workqueue to remove devices, not on
its own behalf.

You are talking about providing something for the benefit of all
the hotplug drivers, right?

Thanks.

/ac

