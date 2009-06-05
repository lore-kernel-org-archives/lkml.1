Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbZFENlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbZFENlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbZFENlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:41:11 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:44948 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbZFENlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:41:07 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: VIA PowerSaver (Re: Linux 2.6.30-rc8 [also: VIA Support])
Date: Fri, 5 Jun 2009 08:41:04 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <alpine.LFD.2.01.0906041038130.4880@localhost.localdomain> <20090605110627.GH4421@prithivi.gnumonks.org>
In-Reply-To: <20090605110627.GH4421@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906050841.07227.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 5 2009, Harald Welte wrote:
> Hi Linus and Michael,
> 
> On Thu, Jun 04, 2009 at 10:46:00AM -0700, Linus Torvalds wrote:
>  
> > On Thu, 4 Jun 2009, Michael S. Zick wrote:
> > >
> > > Yes, I build test cases with and without - -
> > > It was a fixed-speed kernel build that first hit the 4 hour up-time mark.
> > > I just reposted that build today (the -09143lk).
> > > 
> > > > Features like that easily put a huge stress on power regulators etc, if 
> > > > they result in sudden changes in current draw.  Underspecced capacitors 
> > > > etc can cause CPU "brown-outs", which in turn can easily cause total 
> > > > failure. 
> > > 
> > > There is also a possible thermal issue with these machines - -
> > > I doubt that VIA runs their qualification testing in bake ovens;
> > > which is what NetBook cases amount too.  ;)
> > 
> > If the fixed-speed case runs for longer, it's not likely to be a thermal 
> > issue. The fixed speed case should be the higher-power one.
> > 
> > So it can easily be a weak power setup (insufficient grounding, bad 
> > capacitors etc). But it could also be external bus issues, in case VIA 
> > power management also impact the external bus (eg "stopclock" like 
> > behavior on the CPU<->chipset bus).
> 
> I'm not intending to disagree with you, I just wanted to quote from
> a not [yet] public document on the C7-M.  This quote describes model A
> (family 6, model 10(hex A), stepping 0-15):
> ===============
> Enhanced PowerSaver technology allows the dynamic adjustment of the operating
> frequency and operating voltage. The VIA C7-M can only change from the
> highest supported performance state to the lowest supported performance state:
> intermediate performance states are not guaranteed to work and are not offi-
> cially supported. System software can use Enhanced PowerSaver to request the
> sufficient amount of performance. Each individual performance state (P-State)
> is described in the system bios according to 8.4.4 of the ACPI 3.0
> specification.  
> 
> The VIA C7-M processor incorporates two on-chip core clock PLLs. This allows
> the processor to ping-pong between two frequencies instantaneously. In the
> simplest scenario, where there are only two clock frequencies of interest and
> no voltage changes, the transition can be instantaneous with no latency. In
> more complex scenarios, where there are multiple clock frequencies of interest,
> the "old" frequency can continue to be used while the new frequency is ramped
> up. The transition is still instantaneous from a software point of view (code
> still executes), but there is a latency associated with switching to the ramp-
> ing "new" frequency.
>

This appears to be what the e_powersaver is trying to do - -
It just needs to do it better.  ;)

The current behavior ends up as 9 speeds, (I.E: 8 steps) of twice the FSB 
frequency.  I do show "stats/time_in_state" for all of them.

It is one heck of a system, It will be nice if I can make it work - -
If it has to be turned into a two-speed system, so be it.

= = = =

Note:  This is one of VIA's claims to fame - and a good one - -
and different than what the cpufreq stuff was probably tested with.

Most other brands of CPU will "stall" (or some such) internally while
re-syncing the core clock chain (there-by "stalling" the code progress) -
The VIA processors do not - they keep on computing - something the
general code may not account for.  ;)

Since I have a machine that is sensitive to this, I can test other
ways of doing something other than the two speed solution.

>                                                                       
> VIA C7-M allows for a clean hardware approach to processor operating point
> transitions. The transitions are performed instantaneously from a software and
> functional point of view. Snoops and interrupts, for example, are unaffected by
> transitions.
> ===============
> 
> A C7-M model D (family 6, model 13(hex D), stepping 0-15) has advanced performance
> states, they use an inflection ratio, as well as adaptive-p-state control and
> adaptive overclocking, as well as iteravie P-state transitions and adaptive
> thermal control.  I'm not yet aware of all the details, but have requested them.
> 
> In any case, the problems that have been reported by Michael were "Model A",
> so those particular deatils shouldn't matter at this point.
>

dmesg is reporting it as an "Model D" - I will check if that reporting is correct. 
Tell the Silicon Grower's department "Thanks" for the recommendation of what to look for.

Mike
> Regards,


