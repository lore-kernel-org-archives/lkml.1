Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbXGHWug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbXGHWug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 18:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbXGHWu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 18:50:26 -0400
Received: from smtp2.Stanford.EDU ([171.67.20.25]:42353 "EHLO
	smtp2.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127AbXGHWuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 18:50:25 -0400
Subject: Re: v2.6.21.5-rt19
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rui Nuno Capela <rncbc@rncbc.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "jcaceres@ccrma.Stanford.EDU" <jcaceres@ccrma.Stanford.EDU>,
       Carsten Emde <carsten.emde@osadl.org>, nando@ccrma.Stanford.EDU
In-Reply-To: <1183934205.11854.11.camel@cmn3.stanford.edu>
References: <1183582155.3291.160.camel@chaos>
	 <9609.194.65.103.1.1183731007.squirrel@www.rncbc.org>
	 <1183758545.20747.34.camel@cmn3.stanford.edu>
	 <20070707092401.GB21234@elte.hu>
	 <1183934205.11854.11.camel@cmn3.stanford.edu>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 15:50:22 -0700
Message-Id: <1183935022.11854.17.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-08 at 15:36 -0700, Fernando Lopez-Lezcano wrote:
> On Sat, 2007-07-07 at 11:24 +0200, Ingo Molnar wrote:
> > * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> > > > > Changes since 2.6.21.5-rt18:
> > > > >
> > > > > - Fixed a nasty and hard to track down slowness / boot problem on SMP
> > > > > machines with CONFIG_NOHZ enabled. The problem was caused by the timer
> > > > > wheel base lock held during the get_next_timer_interrupt() call in the
> > > > > idle path, which eventually led to a bogus PI boosting of the idle task
> > > > > and in consequence a stale wrong scheduler selection for the affected idle
> > > > > task.
> > > > >
> > > > > Kudos to Carsten Emde, who patiently and meticulously isolated the
> > > > > problem and provided the traces, which allowed to identify the root cause.
> > > > >
> > > > > Problem solution: Prevent idle task boosting
> > 
> > > > Maybe someone remember me whining about troubles with 2.6.21-rt2..18 
> > > > on my Core2 T7200 laptop (fujitsu-siemens amilo i1520).
> > > > 
> > > > Althought I'm still with my fingers crossed, I can tell the good 
> > > > news are that 2.6.21.5-rt19 (and -rt20) does behave far better now 
> > > > on the very same box.
> > > 
> > > Yes, it works much better indeed...
> > > 
> > > Ingo: is there a place where I can read about the changes in different 
> > > rtxx releases? What is new/better/fixed in rt20? (I see scheduler 
> > > stuff in a diff from rt19 to rt20 but I don't really know what it 
> > > means).
> > 
> > and rt18 was a -rt-only NOHZ fix, that bug got introduced in rt11 when 
> > CFS was merged.
> > 
> > i _think_ Rui might have seen two separate problems. Perhaps by the time 
> > we fixed the first problem (which Rui saw since -rt2) we introduced the 
> > other one via -rt11 - which then got fixed in -rt19.
> 
> Ahh, CFS is now part of rt, I was obviously not paying attention... I'm
> really trying to provide a "stable" rt kernel for audio usage and
> including another subsystem into rt is - IMHO - not going to help.
> What's the chance of splitting things?
> 
> > btw., we'd love to get more feedback regarding CFS. CFS is a completely 
> > new scheduler for Linux. 
> 
> Then I'd rather have it separate from rt. 

Please?

I would like to provide the least ammount of new functionality that is
really necessary in my audio kernels. Audio related requirements include
the rt patch but not a new scheduler. 

> > It has a design centered around keeping 
> > application latencies down, so it is ultimately real-time friendly, and 
> > it should also make things work better for desktop-ish and audio-ish 
> > stuff as well. (even under SCHED_OTHER)
> 
> Maybe this is CFS related? (tail of a thread in the Planet CCRMA mailing
> list):
> 
> On Sun, 2007-07-08 at 15:26 -0400, Hector Centeno wrote:
> > Ok, so just to confirm, that 2.6.21-0182.rt19.1.fc7.ccrmart works fine
> > on my desktop but on my laptop it makes Firefox and Tomboy to crash.
> > On the same laptop using 2.6.21-0182.rt17.1.fc7.ccrmart there is no
> > problem.

It looks to my untrained eye like it is CFS related, I'm attaching the
last part of the strace of firefox while it tries to load a flash site.
The firefox process is left in an unkillable (not even by -9) state.
What else could I provide to debug the problem? (this is in a T61 laptop
with the Intel 7700 processor). 

-- Fernando


