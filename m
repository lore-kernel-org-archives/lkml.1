Return-Path: <linux-kernel-owner+w=401wt.eu-S1763095AbXGFVtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763095AbXGFVtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760450AbXGFVtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:49:09 -0400
Received: from smtp3.Stanford.EDU ([171.67.20.26]:56100 "EHLO
	smtp3.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996AbXGFVtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:49:08 -0400
Subject: Re: v2.6.21.5-rt19
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Rui Nuno Capela <rncbc@rncbc.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       "jcaceres@ccrma.Stanford.EDU" <jcaceres@ccrma.Stanford.EDU>,
       Carsten Emde <carsten.emde@osadl.org>
In-Reply-To: <9609.194.65.103.1.1183731007.squirrel@www.rncbc.org>
References: <1183582155.3291.160.camel@chaos>
	 <9609.194.65.103.1.1183731007.squirrel@www.rncbc.org>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 14:49:04 -0700
Message-Id: <1183758545.20747.34.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 15:10 +0100, Rui Nuno Capela wrote:
> Hi,
> 
> On Wed, July 4, 2007 21:49, Thomas Gleixner wrote:
> > I'm pleased to announce the v2.6.21.5-rt19 kernel on behalf of Ingo.
> >
> >
> > It can be downloaded from the usual place:
> >
> > http://people.redhat.com/mingo/realtime-preempt/
> >
> > More info about the -rt patch set can be found in the RT wiki:
> >
> > http://rt.wiki.kernel.org
> >
> > Changes since 2.6.21.5-rt18:
> >
> > - Fixed a nasty and hard to track down slowness / boot problem on SMP
> > machines with CONFIG_NOHZ enabled. The problem was caused by the timer
> > wheel base lock held during the get_next_timer_interrupt() call in the
> > idle path, which eventually led to a bogus PI boosting of the idle task
> > and in consequence a stale wrong scheduler selection for the affected idle
> > task.
> >
> > Kudos to Carsten Emde, who patiently and meticulously isolated the
> > problem and provided the traces, which allowed to identify the root cause.
> >
> > Problem solution: Prevent idle task boosting
> >
> > - back port of the ntp / clock_was_set fix
> >
> > - integration of the processor_idle fix from Venki Pallipadi, which
> > resolves boot issues on some platforms
> >
> > - ep93xx clock events fix from Manfred Gruber
> >
> 
> Maybe someone remember me whining about troubles with 2.6.21-rt2..18 on my
> Core2 T7200 laptop (fujitsu-siemens amilo i1520).
> 
> Althought I'm still with my fingers crossed, I can tell the good news are
> that 2.6.21.5-rt19 (and -rt20) does behave far better now on the very same
> box.

Yes, it works much better indeed...

Ingo: is there a place where I can read about the changes in different
rtxx releases? What is new/better/fixed in rt20? (I see scheduler stuff
in a diff from rt19 to rt20 but I don't really know what it means). 

-- Fernando

> I've more than 8 hours up and running now, without a single glimpse of the
> bad symptoms, which used to show in a matter of minutes if not earlier
> during init time.
> 
> Congratulations. I'm not sure whether this problem can be closed for good,
> though, just because you mention the slowness fix applies to CONFIG_NOHZ=Y
> and I'm quite sure my badness surged either way.
> 
> But at least -rt is usable again here and that just makes me happier :)
> 
> Cheers.


