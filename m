Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbXFDPtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbXFDPtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbXFDPtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:49:43 -0400
Received: from lucidpixels.com ([75.144.35.66]:41295 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbXFDPtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:49:43 -0400
Date: Mon, 4 Jun 2007 11:49:41 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Ray Lee <ray-lk@madrabbit.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matt Keenan <tank.en.mate@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't
 the kernel realize the BIOS has problems and re-map appropriately?
In-Reply-To: <2c0942db0706040848y1d1c2ce9p521c65117244edf1@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706041149160.18306@p34.internal.lan>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> 
 <Pine.LNX.4.64.0706021610210.19116@p34.internal.lan>  <4662869A.9030700@gmail.com>
  <200706040840.21593.jbarnes@virtuousgeek.org>
 <2c0942db0706040848y1d1c2ce9p521c65117244edf1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 4 Jun 2007, Ray Lee wrote:

> On 6/4/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> On Sunday, June 3, 2007 2:15:06 Matt Keenan wrote:
>> > Justin Piszcz wrote:
>> > > On Sat, 2 Jun 2007, Andi Kleen wrote:
>> > >>> I feel, having a silent/transparent workaround is not a good idea.
>> > >>> With that
>> > >>
>> > >> If enough RAM is chopped off users will notice. They tend to complain
>> > >> when they miss RAM.  I don't like panic very much because for many
>> > >> users it will be a show stopper (even when they are not blessed
>> > >> with "quiet" boots like some distributions do)
>> > >>
>> > >> The message in dmesg could be also emphasized a bit with a little
>> > >> ASCII art (but no <blink> tag in there)
>> > >>
>> > >> The problem I'm more worried about is if the system will be really
>> > >> stable --- could it be that the memory controller is still
>> > >> misconfigured and cause other stability issues? (we've had such
>> > >> cases in the past). Also I'm not sure we can handle the case of
>> > >> the MTRR wrong not at the end of memory but at the hole sanely.
>> > >>
>> > >> -Andi
>> > >
>> > > So far I have been booting with mem=8832M and have run stress/loaded
>> > > the memory subsystem pretty good; what other tests should I run?
>> > >
>> > > It'd be nice if we could pose some sort of solution/warning for the
>> > > future so other people do not have to experience the same problems.
>> > >
>> > > What are the next steps?
>> >
>> > Wouldn't it be possible for the e820/MTRR set up code detect the problem
>> > and suggest a mem=xxxx that would fix the problem (while also
>> > complaining that the BIOS is broken)?
>> 
>> Yes, that should be fairly easy, though as Andi points out, if there are 
>> holes
>> in the MTRR setup, things get a little trickier (I had an earlier patch to
>> deal with this, but ended up with too many early boot issues).
>> 
>> Maybe what Venki suggested would be best:  just detect the condition and
>> panic, with a string telling the user to use mem=xxx (we can figure that 
>> out)
>> and/or upgrade their BIOS.
>
> Ick. Systems that used to boot fine would then panic on a kernel
> upgrade. That's rather rude for a condition that's merely an
> optimization (using all memory), rather than one of correctness. A
> panic seems entirely inappropriate.
>
> Ray
>

While I am unsure of the 'best' solution, if they boot and it does not 
panic but takes 10 minutes to boot, people are going to seriously wonder 
what is going on?

Justin.
