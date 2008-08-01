Return-Path: <linux-kernel-owner+w=401wt.eu-S1760472AbYHAVHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472AbYHAVHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759623AbYHAVHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:07:23 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:49933 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963AbYHAVHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:07:20 -0400
Date: Fri, 01 Aug 2008 17:07:14 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature
 shutdown
In-reply-to: <alpine.LFD.1.10.0807250948320.3884@localhost.localdomain>
X-X-Sender: lenb@localhost.localdomain
To: Thomas Renninger <trenn@suse.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Message-id: <alpine.LFD.1.10.0808011706350.3011@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200807241727.41715.trenn@suse.de>
 <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain>
 <200807251319.12786.trenn@suse.de>
 <alpine.LFD.1.10.0807250948320.3884@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[resend of a message that apparently didn't make it off my laptop]

On Fri, 25 Jul 2008, Len Brown wrote:

> 
> 
> On Fri, 25 Jul 2008, Thomas Renninger wrote:
> 
> > On Friday 25 July 2008 02:04:32 Len Brown wrote:
> > > Thomas,
> > >
> > > re: OSI(Windows...)
> > >
> > > Linux will continue to claim OSI compatibility with Windows
> > > until the day when the majority of Linux systems
> > > have passed a Linux compatibility test rather than
> > > a Windows compatibility test.
> 
> > And to try that out we need the acpi_osi=windows_false boot
> > param I sent recently. So will you accept that one?
> 
> if you want to disable the OSI strings in ACPICA,
> you can already use "acpi=osi=" to disable _OSI support entirely.
> 
> > Also we need this documented.
> > Will you accept a Documentation/acpi/known_osi_vendor_hooks.txt
> > file. Like that we get an idea of what kind of features come
> > in through which Windows version and more important, what kind of
> > ugly Windows bug workarounds exist (the latter will probably be more).
> 
> I'm certainly open to posing what is know about vendor use of OSI.
> However, this is very close to the line of public reverse engineering
> which Intel employees are not allowed to do.
> 
> > > Re: OSI(Linux)
> > >
> > > I've looked at O(100) DSDT's that look at OSI(Linux),
> > > and all but serveral systems from two vendors do it by mistake.
> > > They simply copied it from the bugged Intel reference code.
> > >
> > > OSI(Linux) will _never_ be restored to Linux, ever.
> > But it should not have been removed without announcing it half a
> > year before. It silently moved distributions and vendors into a
> > situation where they cannot support Linux and Windows with
> > the same BIOS anymore.
> 
> nonsense.
> we've always had all the windows OSI strings
> and only a handful of models do anything with OSI Linux.
> 
> > _OSI is mainly not used for interfaces/features in
> > reality (as you stated in the other mail), but to workaround very
> > specific Windows version bugs.
> > 
> > While the mainline kernel stays transparent to _OSI you
> > advise distributions to exactly not do that and provide e.g.
> > a "SLE 11" or "RHEL X" _OSI string to be able to
> > support the system on Linux and Windows, is that correct?
> 
> No, but if a BIOS vendors works with you to get a SKU
> that does something special, you are certainly free
> to do this.
> 
> > Or do you advise them to provide two separate BIOSes?
> 
> No.
> 
> > The last option, "do not implement Windows version bug
> > fixes" we cannot influence.
> > I do not see more options with the current implementation.
> 
> stay the course is the best option.
> It is better to expose ourselves to the known tested
> Windows functionality -- even if it seems arbitrary,
> at least it is tested.  The !Windows case results in
> running _completely_ untested BIOS code.
> 
> > > re: the HP BIOS bug at hand.
> > >
> > > Linux deletes the entire thermal zone when we see this.
> 
> > OpenSUSE 11.0 (2.6.25) and SLES10-SP2 (2.6.16) shut down when
> > the thermal driver is loaded. Probably every kernel in every
> > distribution out there currently is doing that.
> 
> Andy needs to send Arjan's patch to 2.6.25.stable.
> 
> > > (arguably, we could have just disabled the CRT
> > > and kept the rest of the thermal zone).
> > > If HP cared about testing Linux on this laptop
> > > and had tools such that they could actually
> > > test Linux compatiblity, it would be pretty clear
> > > from user-space that their thermal zone was missing.
> 
> Note that what triggered the failure on Arjan's machine
> is a change to the implicit return workaround.
> In earlier releases we would get a run-time exception
> when we ran the bogus _CRT that had no return value.
> Bob enhanced the implicit return workaround so that
> it returned something to fix another case and it
> caused the year to be returned by CRT here, which
> in deci-kelvin was a bogus temperature.
> 
> If HP cared about Linux on this box, they would
> test with acpi=strict, which would turn off most
> of these workarounds, and the kernel would point
> out the problem to the tester.
> 
> > Len, this is not about the thermal zone,
> 
> Yes, it is.
> please see "stay the course" above.
> 
> thanks,
> -Len
> 
> > it is just
> > a real-world example of something I told you will happen
> > if Linux stays _OSI transparent with Windows.
> > 
> > This is about that they have to provide a BIOS hot-fix for
> > VISTA or VISTA SP and thus breaking Linux because there
> > is no way to distinguish anymore.
> > Windows 2007 likely will have that fixed and they provide
> > a sane _CRT trip point again.
> > This is an example of Windows versions workarounds that could
> > get much more complex, like initializing HW differently or
> > whatever.
> > _OSI is used by vendors as a convenient possibility to
> > adjust/workaround Windows bugs in their BIOSes, without
> > the need to pay Millions to Microsoft to fix their things.
> > 
> > 
> >           Thomas
> > 
> 
