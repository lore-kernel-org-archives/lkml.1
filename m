Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab0BHO6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 09:58:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab0BHO6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 09:58:44 -0500
Date: Mon, 8 Feb 2010 09:58:13 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3 v2] nmi_watchdog: config option to enable new
 nmi_watchdog
Message-ID: <20100208145813.GW3062@redhat.com>
References: <1265424425-31562-1-git-send-email-dzickus@redhat.com>
 <1265424425-31562-4-git-send-email-dzickus@redhat.com>
 <20100208071954.GA24721@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208071954.GA24721@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 08:19:54AM +0100, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > +config NMI_WATCHDOG
> > +	bool "Detect Hard Lockups with an NMI Watchdog"
> > +	depends on DEBUG_KERNEL && PERF_EVENTS
> > +	default y
> > +	help
> > +	  Say Y here to enable the kernel to use the NMI as a watchdog
> > +	  to detect hard lockups.  This is useful when a cpu hangs for no
> > +	  reason but can still respond to NMIs.  A backtrace is displayed
> > +	  for reviewing and reporting.
> > +
> > +	  The overhead should be minimal, just an extra NMI every few 
> > +	  seconds.
> 
> Thought for later patches: I think an architecture should be able to express 
> via a Kconfig switch that it actually _has_ NMI events. There's architectures 
> which dont have a PMU driver and only have software events. There's also 
> architectures that have a PMU driver but no NMIs.
> 
> Something like ARCH_HAS_NMI_PERF_EVENTS?

I guess I assumed the perf event subsystem would take care of that which
is why I made the config option dependent on PERF_EVENTS.  I am open to
suggestions on enhance it.

> 
> Also, i havent checked, but what is the practical effect of the new generic 
> watchdog on x86 CPUs that does not have a native PMU driver yet - such as 
> P4s?

I believe the call to perf_event_create_kernel_counter would fail, which
then prevents the cpu from coming online.  Probably not the smartest thing
to do.  I was looking at adding code to fall back to trying PERF_TYPE_SOFTWARE.
Let me dig up a P4 box and see what happens.

> 
> Anyway, i'll create a tip:perf/nmi topic branch for these patches, it 
> certainly looks like a useful generalization and a new architecture that has 
> perf could easily enable it, without having to write its own NMI watchdog 
> implementation. It's also useful for any new watchdog features that people 
> might want to add. Plus it makes the x86 PMU code cleaner in the long run as 
> well.

Agreed.

Cheers,
Don
