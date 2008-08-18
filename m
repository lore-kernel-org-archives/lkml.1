Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYHRVad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYHRVad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYHRVaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:30:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062AbYHRVaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:30:23 -0400
Date: Mon, 18 Aug 2008 14:29:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: vegard.nossum@gmail.com, pavel@suse.cz, robert.richter@amd.com,
       mingo@elte.hu, ak@linux.intel.com, phil.el@wanadoo.fr,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: oprofile + hibernation = badness
Message-Id: <20080818142953.a250c30d.akpm@linux-foundation.org>
In-Reply-To: <200808182316.00854.rjw@sisk.pl>
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com>
	<200808182251.31113.rjw@sisk.pl>
	<19f34abd0808181408q8a38fc0hfaff02fab6e20681@mail.gmail.com>
	<200808182316.00854.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 23:15:59 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday, 18 of August 2008, Vegard Nossum wrote:
> > On Mon, Aug 18, 2008 at 10:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > Apparently nmi_suspend() conflicts with oprofile somehow.  Also, the offlining
> > > of non-boot CPUs may confuse it.  It would be helpful to check if the CPU
> > > hotplug works with oprofile.
> > 
> > That is a good suggestion :-)
> > 
> > Here is offlining:
> > 
> > CPU 1 is now offline
> > lockdep: fixing up alternatives.
> > SMP alternatives: switching to UP code
> > CPU0 attaching NULL sched-domain.
> > WQ on CPU0, prefer CPU1
> > CPU1 attaching NULL sched-domain.
> > CPU0 attaching sched-domain:
> >  domain 0: span 0 level CPU
> >   groups: 0
> > WQ on CPU0, prefer CPU1
> > WQ on CPU0, prefer CPU1
> > WQ on CPU0, prefer CPU1
> > [repeat last message indefinitely]
> > 
> > Here is onlining:
> > 
> > Booting processor 1/1 ip 6000
> > Initializing CPU#1
> > WQ on CPU0, prefer CPU1
> > WQ on CPU0, prefer CPU1
> > Calibrating delay using timer specific routine.. 5986.15 BogoMIPS (lpj=29930790)
> > CPU: Trace cache: 12K uops, L1 D cache: 16K
> > CPU: L2 cache: 2048K
> > CPU: Physical Processor ID: 0
> > Intel machine check architecture supported.
> > Intel machine check reporting enabled on CPU#1.
> > CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
> > CPU1: Thermal monitoring enabled
> > x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> > CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 05
> > checking TSC synchronization [CPU#0 -> CPU#1]:
> > Measured 120 cycles TSC warp between CPUs, turning off TSC clock.
> > Marking TSC unstable due to check_tsc_sync_source failed
> > APIC error on CPU1: 00(40)
> > Clockevents: could not switch to one-shot mode:<7>APIC error on CPU1: 40(40)
> >  lapic is not functional.
> > Could not switch to high resolution mode on CPU 0
> > Clockevents: could not switch to one-shot mode: lapic is not functional.
> > Could not switch to high resolution mode on CPU 1
> > APIC error on CPU1: 40(40)
> > [sched domains messages
> > WQ on CPU0, prefer CPU1
> > APIC error on CPU1: 40(40)
> > [repeat last message 9 times]
> > 
> > Then follows this pattern indefinitely:
> > 
> > WQ on CPU0, prefer CPU1
> > APIC error on CPU1: 40(40)
> > [repeat last message 9 times]
> > 
> > That's basically the same thing as I saw with suspend. So it can be
> > reproduced easily with CPU hotplug.
> 
> Well, I don't know who's the right person to ask about the CPU hotplug.
> Andrew, can you help please?
> 

The CPU hotplug maintainer is basically "everyone", because many
subsystems need to interact correctly with hotplugging, and many
subsystems can break it.

This one looks like a clocksource/apic/resume problem?  Probably the
next port of call would be Thomas, with Robert looking on.

