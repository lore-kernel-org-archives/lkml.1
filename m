Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbYHAVJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbYHAVJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760428AbYHAVIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:08:38 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:56665 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760505AbYHAVIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:08:35 -0400
Date: Fri, 01 Aug 2008 17:08:30 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature
 shutdown
In-reply-to: <alpine.LFD.1.10.0807261409290.2958@localhost.localdomain>
X-X-Sender: lenb@localhost.localdomain
To: Thomas Renninger <trenn@suse.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Message-id: <alpine.LFD.1.10.0808011708230.3011@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200807241727.41715.trenn@suse.de>
 <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain>
 <200807251319.12786.trenn@suse.de>
 <alpine.LFD.1.10.0807261409290.2958@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[yet another resend]

On Sat, 26 Jul 2008, Len Brown wrote:

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
> I believe that adding and using such a parameter would make
> Linux worse, not better.  So it is unlikely that I'd accept it.
> 
> > Also we need this documented.
> > Will you accept a Documentation/acpi/known_osi_vendor_hooks.txt
> > file. Like that we get an idea of what kind of features come
> > in through which Windows version and more important, what kind of
> > ugly Windows bug workarounds exist (the latter will probably be more).
> 
> I believe that this thread illustrates a BIOS bug that Vista
> doesn't catch.  That doens't mean it is a Vista bug, or or
> a BIOS workaround for a Vista bug.
> 
> I believe that there are many such holes in Windows testing.
> They don't have to do a good job validating ACPI --
> they just care if Windows works or not.
> 
> If we should document every BIOS issue that is worked
> around by Linux is an interesting idea for a project.
> It sounds like a pretty big project to me.
> I guess I'd wonder what the return on investment would be
> and if that is the best way to apply our resources.
> 
> > > Re: OSI(Linux)
> > >
> > > I've looked at O(100) DSDT's that look at OSI(Linux),
> > > and all but serveral systems from two vendors do it by mistake.
> > > They simply copied it from the bugged Intel reference code.
> > >
> > > OSI(Linux) will _never_ be restored to Linux, ever.
> 
> > But it should not have been removed without announcing it half a
> > year before. It silently moved distributions and vendors into a
> > situation where they cannot support Linux and Windows with
> > the same BIOS anymore.
> 
> Linux started complaining about OSI(Linux) in 2.6.22, a year ago.
> Linux changed the default to disable OSI(Linux) in 2.6.23 --
> 3 months after the warning started.
> 
> If I were to do it again, I would have changed faster, not slower,
> for allowing the spread of OSI(Linux) use is bad for Linux,
> not good.
> 
> Of course a distro is free to maintain whatever OSI strings
> that they think they can their OEMs can support.
> 
> > _OSI is mainly not used for interfaces/features in
> > reality (as you stated in the other mail), but to workaround very
> > specific Windows version bugs.
> > 
> > While the mainline kernel stays transparent to _OSI you
> > advise distributions to exactly not do that and provide e.g.
> > a "SLE 11" or "RHEL X" _OSI string to be able to
> > support the system on Linux and Windows, is that correct?
> > Or do you advise them to provide two separate BIOSes?
> > The last option, "do not implement Windows version bug
> > fixes" we cannot influence.
> > I do not see more options with the current implementation.
> > 
> > > re: the HP BIOS bug at hand.
> > >
> > > Linux deletes the entire thermal zone when we see this.
> > OpenSUSE 11.0 (2.6.25) and SLES10-SP2 (2.6.16) shut down when
> > the thermal driver is loaded. Probably every kernel in every
> > distribution out there currently is doing that.
> 
> Clearly Arjan's patch nees to be backported to the stable releases --
> even though it would have no benefit on Arjan's machine,
> it would benefit the HP that you have.
> 
> Andi,
> Please send 39a2d7c72b358c6253a2ec28e17b023b7f6f41c
> (ACPI: Reject below-freezing temperatures as invalid critical 
> temperatures)
> to 2.6.25.stable (and any stable release that will take it)
> 
> thanks,
> -Len
> 
> 
