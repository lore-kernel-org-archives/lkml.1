Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbXCKVuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbXCKVuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 17:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932849AbXCKVuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 17:50:08 -0400
Received: from www.osadl.org ([213.239.205.134]:33061 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932753AbXCKVuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 17:50:07 -0400
Subject: Re: SwSusp to disk doesn't work - Try 2
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Milan Broz <mbroz@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Meyer <thomas@m3y3r.de>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200703112209.53665.rjw@sisk.pl>
References: <45F44599.3060508@m3y3r.de> <45F46660.4010102@m3y3r.de>
	 <45F46D33.1050808@redhat.com>  <200703112209.53665.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 11 Mar 2007 22:56:35 +0100
Message-Id: <1173650195.13341.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-11 at 22:09 +0100, Rafael J. Wysocki wrote:
> > >>>>>     update_sched_domains
> > >>>>>      detach_destroy_domains
> > >>>>>        [waits here] --> synchronize_sched (==synchronize_rcu)
> > >>>>>         
> > >>>> Well, I think the call to wait_for_completion() does not return, probably
> > >>>> because the task supposed to complete the completion is frozen at this
> > >>>> point.  Can you please try to confirm that it gets stuck on
> > >>>> wait_for_completion() in synchronize_rcu()?
> > >>>>       
> > >>> Yes, it's in wait_for_completion() in synchronize_rcu().
> > >>> As noted in some previous mail, it will wake up after
> > >>> event - key press etc.
> > >>>
> > >>> Patch in http://lkml.org/lkml/2007/3/7/255 solves different problem.
> > >>> I added it to my quilt and applied anyway -> no change.
> > >>>     
> > >> Does the problem go away if NO_HZ is unset?
> > >>   
> > > 
> > > i tried to boot with nohz=off, but the problem did persist.
> > 
> > Hmmmm, both variants (nohz=off or recompiled kernel without NO_HZ) works for me.
> 
> Definitely something strange is going on here.
> 
> I think we need an advice from someone who knows the RCU internals.

RCU synchronization depends on the timer interrupt. Which kernel version
are you guys talking about ?

	tglx



