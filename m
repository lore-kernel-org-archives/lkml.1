Return-Path: <linux-kernel-owner+w=401wt.eu-S1767223AbXEBXyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767223AbXEBXyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767249AbXEBXyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:54:24 -0400
Received: from outbound-mail-04.bluehost.com ([69.89.21.14]:58521 "HELO
	outbound-mail-04.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767223AbXEBXyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 19:54:23 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 2 May 2007 16:54:23 -0700
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <200705021057.31393.jbarnes@virtuousgeek.org> <4639229C.4030208@shaw.ca>
In-Reply-To: <4639229C.4030208@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021654.23730.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.73.10 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 2, 2007 4:45 pm Robert Hancock wrote:
> Jesse Barnes wrote:
> > On Wednesday, May 2, 2007 7:34 am Robert Hancock wrote:
> >> Jesse Barnes wrote:
> >>> On Tuesday, May 01, 2007, Jesse Barnes wrote:
> >>>>> I'm testing it now on my 965...
> >>>>
> >>>> Bah... nevermind Robert, I see you're doing this already in
> >>>> pci_mmcfg_reject_broken.  I'm about to reboot & test now.
> >>>
> >>> Ok, I've tested a bit on my 965 (after re-adding my old patch to
> >>> support it) and the new checks are more complete, but my BIOS
> >>> still appears to be buggy.
> >>>
> >>> The extended config space (as defined by the register) is at
> >>> 0xf0000000 (full value is 0xf0000003 indicating 128M enabled). 
> >>> The ACPI MCFG table has this space reserved according to Robert's
> >>> new code, but the machine hangs due to the address space aliasing
> >>> Olivier mentioned awhile back.  I don't have a PCIe card to test
> >>> with (or any devices that require extended config space that I
> >>> know of) so I can't really tell if Windows supports PCIe on this
> >>> platform, but if it does I don't see how it would w/o having a
> >>> full bridge driver and sophisticated address space allocation
> >>> builtin.
> >>
> >> Windows XP doesn't use MMCONFIG or any extended configuration
> >> space. I believe Vista is supposed to, though. Not sure how they
> >> are handling this issue.
> >
> > Oh right... Vista will be the first to fully support PCIe & mcfg...
> >
> >> Can you post what your board has for PNPACPI reserved resources (I
> >> believe they're in /sys/devices/pnp0/*/resources IIRC, don't have
> >> a Linux box handy right now). Full dmesg would also be useful, I
> >> think it dumps out those reservations at boot nowadays..
> >
> > BIOS update didn't help.  Here's the boot log and a dump of the
> > pnp0 resources.
>
> Curious.. It looks like the ACPI resources have the correct
> reservation for the MMCONFIG window according to what the register
> says the location should be. There's no other reservations that
> overlap with that range (f000000-f7ffffff), and according to the 965
> datasheet there's nothing that's hard-coded to occupy that memory
> range. I can't really see what this range could be conflicting with.

Yeah, it's strange.  Even /proc/iomem from a working boot looks ok:

d0700000-d07fffff : PCI Bus #04
d0800000-d08fffff : PCI Bus #05
f0000000-f7ffffff : pnp 00:01
fec00000-fec00fff : IOAPIC 0
fed00000-fed003ff : HPET 0

> What happens if you take out the chipset register detection, does the
> MCFG table give you the same result? Wonder if they're doing
> something funny with start/end bus values or something in their
> table. There's some code in my patch that prints out the important
> data from the MCFG table, can you tell me what that shows with the
> chipset detection taken out?

Yeah, I'll look a little more closely.  It could also be that another 
register needs tweaking somewhere to actually get the bridge to decode 
the space.

> If that doesn't provide any useful information, I think we may need
> some assistance from Intel chipset/motherboard people to figure out
> what is going on here..

I'm talking with them now, hopefully they'll shed some light on it.

Thanks,
Jesse

