Return-Path: <linux-kernel-owner+w=401wt.eu-S934257AbYBVXSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257AbYBVXSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 18:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759470AbYBVXSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 18:18:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45074 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759385AbYBVXSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 18:18:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Sat, 23 Feb 2008 00:16:45 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Mark Lord <lkml@rtr.ca>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org, Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802221844.31579.rjw@sisk.pl> <alpine.DEB.1.00.0802221114350.17357@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.00.0802221114350.17357@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802230016.47449.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of February 2008, david@lang.hm wrote:
> On Fri, 22 Feb 2008, Rafael J. Wysocki wrote:
> 
> > On Friday, 22 of February 2008, Mark Lord wrote:
> >> Rafael J. Wysocki wrote:
> >>> On Friday, 22 of February 2008, Mark Lord wrote:
> >>>> david@lang.hm wrote:
> >>>> ..
> >>>>> I've been watching for kexec hibernate for a little while now, and the
> >>>>> last I saw was that acpi was incompatible with the kexec hibernate (but
> >>>>> the suspend folks were still claiming that devices needed to be put in
> >>>>> the 'right mode' not just powered off. I've been waiting to see this
> >>>>> resolved.
> >>>> ..
> >>>>
> >>>> Yeah, exactly.  What's so special about poweroff on hibernation?
> >>>> Why even bother with the special "S4" state there?
> >>>
> >>> (1) To be able to wake up with the help of devices that can't wake
> >>>     the system up from S5 (power off)
> >>> (2) To handle some platform devices appropriately over the cycle
> >> ..
> >>
> >> That's the theory.  I've read about it, but have yet to imagine
> >> any real-life situation where it applies.
> >>
> >> But this isn't my speciality, so.. do you have experience with any real examples?
> >
> > Yup.  The fan in my notebook behaves incorrectly after a resume from
> > hibernation if S5 is entered instead of S4 during it.
> 
> so if you power off your laptop the fan doesn't work when you turn it back 
> on?????

No, it works fine then.

> > I don't know why exactly it happens, but that's how it goes.
> >
> > Also, some machines are reported to behave incorrectly after a "shutdown"
> > mode hibernation, while the same machines work just fine after a "platform"
> > mode hibernation.  So at least for these machines it seems to matter.
> 
> given that we don't have a pure "shutdown" option available to try I don't 
> see how this can be said to have been tested.

Yes, we have.

> currently any attempts to do a shutdown type hibernate are tangled in the 
> other code that is there for the suspend modes. this makes it _very_ hard 
> to say that the hardware requires something as opposed to the strong 
> possibility that the software is doing something wrong.

How is it tangled exactly?

> there are also a _lot_ of people who are not able to reliably use the 
> existing "platform" mode hibernation, so it's not a fair statement to say 
> that it's the 'right' thing to do. If you want to make it an option, fine. 
> But please give those of us who don't care about these other wakeup 
> options, and who want to be able to use other OS's while linux is stopped 
> an option as well.

There is such an option.  Put

# echo shutdown > /sys/power/disk

into the init scripts and it will do the trick.

Thanks,
Rafael
