Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbXJZNLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbXJZNLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 09:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbXJZNL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 09:11:27 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:35703 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbXJZNL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 09:11:26 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: trenn@suse.de
Subject: Re: [PATCH 0/5] Detect hwmon and i2c bus drivers interfering with ACPI Operation Region resources
Date: Fri, 26 Oct 2007 07:09:19 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@osdl.org>,
       Jean Delvare <khali@linux-fr.org>
References: <1193236319.4590.225.camel@queen.suse.de> <200710252159.11594.bjorn.helgaas@hp.com> <1193395520.4590.349.camel@queen.suse.de>
In-Reply-To: <1193395520.4590.349.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260709.20716.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007 4:45:20 am Thomas Renninger wrote:
> On Thu, 2007-10-25 at 21:59 -0600, Bjorn Helgaas wrote:
> > On Thursday 25 October 2007 4:55:07 pm Thomas Renninger wrote:

> > > Also the BIOS developers seem to choose the regions in a very dump way
> > > sometimes.
> > > Just some imaginary values, but I saw similar (overlapping):
> > >  - For a PNP device IO ports from 0x400-0x410 are reserved
> > >  - A operation region is declared from 0x399-0x401
> >
> > If we know the resources the opregion can use, we can at least
> > reserve the union of those used by the opregion and by other
> > PNP devices.  A little messy to deal with overlapping areas, I
> > agree, but it should still be possible by shrinking the region
> > or allocating a port at a time or something.
>
> You mean merging them together to something like:
>   0x400-0x410 pnp device
>   0x399       ACPI Op region's name
> This needs touching of kernel/resource.c and modification in a very ugly
> way affecting all architectures...

Right, that's what I was thinking.  But I haven't tried it, so I'll
take your word for it that it's ugly.

> Maybe the list set up by this patch set should be similarly exported
> like /proc/ioports /proc/iomem
> to where ever appropriate (maybe /sys/devices/system/acpi/opreg_io
> and /sys/devices/system/acpi/opreg_mem?) to get a better overview what
> kind of devices are served by the Op regions on different machines.

I want to try hard to avoid making ACPI a special case in this way.
The current /proc/io{ports,mem} contains reservations for everything
else.  I'd hate to have to look two places just because of ACPI.

> I think I worked on something else.
> Do I get this right:
> This one is to request all active resources of all ACPI devices that
> export resources via _CRS/_SRS?
> As this is currently done for the motherboard devices only by
> pnp/system.c?

Right.  Actually my patch requests resources of all active PNP devices,
not just ACPI.  Glad we didn't do overlapping work here :-)

> If you are interested I can try to fast cleanup and send you a
> pre-version of all patches (but not before beginning of next week).

Thanks for the preview.  No hurry as far as I'm concerned.

Bjorn
