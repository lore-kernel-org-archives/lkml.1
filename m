Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251Ab0AMJcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab0AMJcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215Ab0AMJcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:32:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39651 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088Ab0AMJcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:32:50 -0500
Date: Wed, 13 Jan 2010 10:32:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: introduce NMI_AUTO as nmi_watchdog option
Message-ID: <20100113093240.GC6739@elte.hu>
References: <20100111191633.GT24885@redhat.com>
 <20100111202729.GI4923@lenovo>
 <20100111203356.GU24885@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100111203356.GU24885@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Mon, Jan 11, 2010 at 11:27:29PM +0300, Cyrill Gorcunov wrote:
> > On Mon, Jan 11, 2010 at 02:16:33PM -0500, Don Zickus wrote:
> > > Hi Ingo,
> > > 
> > ...
> > > I was going to jump in and try to do this work.  I wanted to make sure
> > > what you were looking for here.  When you say convert nmi watchdog to perf
> > > events, I assume you mean merging over the bits of perfctr-watchdog.c to
> > > perf_events.c, modify nmi.c to just register as a normal perf event and
> > > probably cleanup the oprofile stuff to match, correct?
> > > 
> > > Cheers,
> > > Don
> > >
> > 
> > As far as I know -- converting perfctr-watchdog.c to into perfevents
> > style would be quite a desirable feature. But I still didn't manage to
> > find time for this task :( If you're interested to start this work
> > -- that would be just great!
> 
> After looking through the code I just had some questions, perhaps you have 
> thought about this longer than me, what to do with the reservation code 
> (just remove it I assume and let perf_events _be_ the only code that
>  handles perf events) and what to do with some of the cpu quirks as noted in 
> perfctr-watchdog.c (notable some of the Intel errata for the Core chipsets).

Given the amount of quirks in the perctr code it might make sense to shape 
this as a new feature initially: introduce a new NMI watchdog that is perf 
based and has a different codebase.

Then, once it's capable enough and has been in circulation long enough we can 
simply drop the old NMI watchdog. (without users noticing anything [modulo 
bugs])

v1 should concentrate on x86 CPUs that are supported by perf currently. Note, 
it _might_ make sense to do it via a new kernel/nmi_watchdog.c file - other 
architectures have NMI concepts as well, such as Sparc64. A further idea would 
be to maybe even merge it with the softlockup code in kernel/softlockup.c - so 
that we dont have two sets of apis like touch_nmi_watchdog and 
touch_softlockup_watchdog.

So there's a wide spectrum of possibilities - the important thing is to start 
small :-)

	Ingo
