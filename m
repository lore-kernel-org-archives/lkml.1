Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZFELKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZFELKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZFELKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:10:07 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:43947 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZFELKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:10:06 -0400
Date: Fri, 5 Jun 2009 13:06:27 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael S. Zick" <lkml@morethan.org>, Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: VIA PowerSaver (Re: Linux 2.6.30-rc8 [also: VIA Support])
Message-ID: <20090605110627.GH4421@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <alpine.LFD.2.01.0906040948480.4880@localhost.localdomain> <alpine.LFD.2.01.0906041004000.4880@localhost.localdomain> <200906041227.10529.lkml@morethan.org> <alpine.LFD.2.01.0906041038130.4880@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906041038130.4880@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus and Michael,

On Thu, Jun 04, 2009 at 10:46:00AM -0700, Linus Torvalds wrote:
 
> On Thu, 4 Jun 2009, Michael S. Zick wrote:
> >
> > Yes, I build test cases with and without - -
> > It was a fixed-speed kernel build that first hit the 4 hour up-time mark.
> > I just reposted that build today (the -09143lk).
> > 
> > > Features like that easily put a huge stress on power regulators etc, if 
> > > they result in sudden changes in current draw.  Underspecced capacitors 
> > > etc can cause CPU "brown-outs", which in turn can easily cause total 
> > > failure. 
> > 
> > There is also a possible thermal issue with these machines - -
> > I doubt that VIA runs their qualification testing in bake ovens;
> > which is what NetBook cases amount too.  ;)
> 
> If the fixed-speed case runs for longer, it's not likely to be a thermal 
> issue. The fixed speed case should be the higher-power one.
> 
> So it can easily be a weak power setup (insufficient grounding, bad 
> capacitors etc). But it could also be external bus issues, in case VIA 
> power management also impact the external bus (eg "stopclock" like 
> behavior on the CPU<->chipset bus).

I'm not intending to disagree with you, I just wanted to quote from
a not [yet] public document on the C7-M.  This quote describes model A
(family 6, model 10(hex A), stepping 0-15):
===============
Enhanced PowerSaver technology allows the dynamic adjustment of the operating
frequency and operating voltage. The VIA C7-M can only change from the
highest supported performance state to the lowest supported performance state:
intermediate performance states are not guaranteed to work and are not offi-
cially supported. System software can use Enhanced PowerSaver to request the
sufficient amount of performance. Each individual performance state (P-State)
is described in the system bios according to 8.4.4 of the ACPI 3.0
specification.  

The VIA C7-M processor incorporates two on-chip core clock PLLs. This allows
the processor to ping-pong between two frequencies instantaneously. In the
simplest scenario, where there are only two clock frequencies of interest and
no voltage changes, the transition can be instantaneous with no latency. In
more complex scenarios, where there are multiple clock frequencies of interest,
the "old" frequency can continue to be used while the new frequency is ramped
up. The transition is still instantaneous from a software point of view (code
still executes), but there is a latency associated with switching to the ramp-
ing "new" frequency.
                                                                      
VIA C7-M allows for a clean hardware approach to processor operating point
transitions. The transitions are performed instantaneously from a software and
functional point of view. Snoops and interrupts, for example, are unaffected by
transitions.
===============

A C7-M model D (family 6, model 13(hex D), stepping 0-15) has advanced performance
states, they use an inflection ratio, as well as adaptive-p-state control and
adaptive overclocking, as well as iteravie P-state transitions and adaptive
thermal control.  I'm not yet aware of all the details, but have requested them.

In any case, the problems that have been reported by Michael were "Model A",
so those particular deatils shouldn't matter at this point.

Regards,
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
