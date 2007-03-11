Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXCKVHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXCKVHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 17:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932488AbXCKVHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 17:07:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41056 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458AbXCKVHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 17:07:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Milan Broz <mbroz@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: SwSusp to disk doesn't work - Try 2
Date: Sun, 11 Mar 2007 22:09:52 +0100
User-Agent: KMail/1.9.5
Cc: Thomas Meyer <thomas@m3y3r.de>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>
References: <45F44599.3060508@m3y3r.de> <45F46660.4010102@m3y3r.de> <45F46D33.1050808@redhat.com>
In-Reply-To: <45F46D33.1050808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703112209.53665.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 March 2007 21:57, Milan Broz wrote:
> Thomas Meyer napsal(a):
> > Rafael J. Wysocki schrieb:
> >> On Sunday, 11 March 2007 21:23, Milan Broz wrote:
> >>   
> >>> Rafael J. Wysocki:
> >>>     
> >>>> Ah, NO_HZ.  Thomas Gleixner's address added to the Cc list.
> >>>>
> >>>>       
> >>>>> short printk trace 
> >>>>>
> >>>>> enable_nonboot_cpus
> >>>>>  _cpu_up
> >>>>>   raw_notifier_callchain (CPU_UP_PREPARE)
> >>>>>     ...
> >>>>>     update_sched_domains
> >>>>>      detach_destroy_domains
> >>>>>        [waits here] --> synchronize_sched (==synchronize_rcu)
> >>>>>         
> >>>> Well, I think the call to wait_for_completion() does not return, probably
> >>>> because the task supposed to complete the completion is frozen at this
> >>>> point.  Can you please try to confirm that it gets stuck on
> >>>> wait_for_completion() in synchronize_rcu()?
> >>>>       
> >>> Yes, it's in wait_for_completion() in synchronize_rcu().
> >>> As noted in some previous mail, it will wake up after
> >>> event - key press etc.
> >>>
> >>> Patch in http://lkml.org/lkml/2007/3/7/255 solves different problem.
> >>> I added it to my quilt and applied anyway -> no change.
> >>>     
> >> Does the problem go away if NO_HZ is unset?
> >>   
> > 
> > i tried to boot with nohz=off, but the problem did persist.
> 
> Hmmmm, both variants (nohz=off or recompiled kernel without NO_HZ) works for me.

Definitely something strange is going on here.

I think we need an advice from someone who knows the RCU internals.

Andrew, could you please tell me whom I should ask?

Rafael
