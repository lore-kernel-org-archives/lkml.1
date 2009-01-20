Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbZATJiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbZATJiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 04:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbZATJil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 04:38:41 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:47624 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbZATJii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 04:38:38 -0500
X-BigFish: VPS-48(zz1432R98dR936eQ1805M936fN3117K9371Pzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KDRK40-01-L4Z-01
Date: Tue, 20 Jan 2009 10:37:32 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Hounschell <markh@compro.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD
	Phenom-II processor
Message-ID: <20090120093732.GC3764@alberich.amd.com>
References: <497322CC.7050900@cfl.rr.com> <1f1b08da0901191625i6ac12312g9ae9ab599958a818@mail.gmail.com> <49759499.4050708@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <49759499.4050708@cfl.rr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Jan 2009 09:38:24.0736 (UTC) FILETIME=[D722F600:01C97AE2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 04:08:41AM -0500, Mark Hounschell wrote:
> john stultz wrote:
> > On Sun, Jan 18, 2009 at 4:38 AM, Mark Hounschell <dmarkh@cfl.rr.com> wrote:
> >> I upgraded from a Phenom to a Phenom-II processor and I could no longer boot.
> >>
> >> I have tried kernels from 2.6.26 through 2.6.28.
> >>
> >> I _can_ however boot these kernels when they are configured for HZ = 250. I
> >> haven't tried HZ = 300. But certainly if HZ = 1000 the boot hangs at the spot
> >> indicated below in the dmesg output.
> >>
> >> The machine is up and stable running 2.6.26.8 with a (HZ = 1000) configured kernel.
> >>
> >> While running a 2.6.26.8 kernel configured for HZ = 250:
> > [snip]
> >>    vmalloc : 0xf4800000 - 0xff7fe000   ( 175 MB)
> >>    lowmem  : 0xc0000000 - 0xf4000000   ( 832 MB)
> >>      .init : 0xc0373000 - 0xc03a9000   ( 216 kB)
> >>      .data : 0xc02b5336 - 0xc036c6d0   ( 732 kB)
> >>      .text : 0xc0100000 - 0xc02b5336   (1748 kB)
> >> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> >>
> >>
> >>      The 2.6.26.8 kernel hangs up right here.
> >>
> >>
> >> CPA: page pool initialized 1 of 1 pages preallocated
> >> SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> >> hpet clockevent registered
> >> calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.
> > 
> > This looks suspect. Probably something is off with the timer
> > interrupt, that's causing the calibration to be way off.
> > 
> > Does booting with hpet=disable change anything?
> > 
> > thanks
> > -john
> 
> John,
> 
> I tried this with 2.6.26, 2.6.28, and 2.6.29-rc2. It didn't change anything.

Hi Mark,

I just want to second what Boris already stated.
Obviously your BIOS doesn't properly initialize your CPU.

Your BIOS programs the processor name string as
"AMD Processor model unknown"

I would have expected to see something like "AMD Phenom(tm) II X4"

This shows that the BIOS doesn't know your CPU model and it is an
indication that your CPU is not correctly initialized. Phenom II is a
different CPU model than Phenom and several configuration bits
(e.g. MSRs, CPU config space) need different settings from BIOS
or they even were reserved in previous family 10h CPU models.

IMHO it is a waste of time to try to debug/fix your problem from OS.
First you should update your BIOS. You need to check the "CPU
support"-information from your motherboard vendor to see whether your
motherboard supports Phenom II and which BIOS is required.

If you know that your BIOS/motherboard are supposed to support Phenom II
and the problem persists then it is a different game and we should
definitely look into your problem.

So what's your BIOS version and motherboard vendor/model?
(And output of dmidecode would be helpful.)



Regards,

Andreas


