Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYICPJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYICPJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYICPJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:09:17 -0400
Received: from ns.suse.de ([195.135.220.2]:34328 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbYICPJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:09:17 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [ANNOUNCE] ACPI BIOS Guideline for Linux
Date: Wed, 3 Sep 2008 17:09:07 +0200
User-Agent: KMail/1.9.9
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Andi Kleen <ak@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200807241732.23412.trenn@suse.de> <200808311518.25421.trenn@suse.de> <20080831172547.GA3077@srcf.ucam.org>
In-Reply-To: <20080831172547.GA3077@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031709.09307.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 August 2008 19:25:47 Matthew Garrett wrote:
> On Sun, Aug 31, 2008 at 03:18:24PM +0200, Thomas Renninger wrote:
> > On Saturday 30 August 2008 02:47:13 pm Matthew Garrett wrote:
> > > Not really. It provides approximately no complexity for Linux drivers,
> > > and makes it easier for vendors to provide Windows support. WMI has not
> > > been the hard bit of the drivers I've written. I don't see any reason
> > > to ask vendors not to use it,
> >
> > Autoloading does not work yet?
> > It is working fine with ordinary ACPI devices providing a HID.
>
> That's an implementation detail. We shouldn't be making recommendations
> to vendors based on Linux shortcomings.
Of course we should, therefore it is called guidline for *Linux*.
Everything recommended there should just work fine on Linux.
E.g. it is all about implementation details, which differ from
the ACPI spec (and WMI clearly does) and all other kind of pits you
can fall in with ACPI on Linux.
Half a year ago we couldn't serve any WMI devices.
Until WMI autoloading is available in stable distributions it still takes
at least half a year.

E.g. that is why video posting after suspend should still
work until modesetting works in kernel.

If there would be enough time, I'd add that Intel graphics
Op Region support is partly (only backlight, not video output, right?)
implemented and this support is scheduled to be added for .28
(didn't make it into .27?).

This is IMO what should get documented, like that vendors can
count on what works on which distribution based on which kernel
(without going throug kernel sources, which is impossible for
BIOS writers, they have to rely on some things written down).

-- Be careful ad in between --
E.g. look at that machine coming with Linux:
http://www.engadget.com/2008/08/31/msis-8-9-inch-wind-u90-in-the-flesh-linux-version-shipping-for
and have a look at that green sticker:
http://www.engadget.com/photos/msis-8-9-inch-wind-u90-in-the-flesh-linux-version-shipping-for-339-euro/1009822
That means it is shipped with a 2.6.16 kernel without any WMI support.
-- Be careful ad in between --

I don't want to go that far back, but start from now on.
Vendors should be able to
read out from which kernel version they can rely on what kind of
ACPI implementations/features.
If something is not supported in a Linux version or has "out of spec"
or say "Windows compatibility" relevant implementations introduced, you should
find it there.
The latter info is rather important for non-Microsoft machines, or e.g. using coreboot
BIOSes (AFAIK they also start to hack in the first ACPI tables).

   Thomas

PS: I agree that if WMI works now since kernel xy, this should be documented.
It would be great if you could send a patch against the guidline describing
what kind of WMI support came in and in which kernel version. And for what pits vendors
still have to take care for (I am sure there still are some).

(from git commit):

    What it won't do:

    Unicode - The MS article[1] calls for converting between ASCII and Unicode (or
    vice versa) if a GUID is marked as "string". This is left up to the calling
    driver.

    Handle a MOF[1] - the WMI mapper just exports methods, data and events to
    userspace. MOF handling is down to userspace.

    Userspace interface - this will be added later.
-------
AFAIK MOF files are and will be for long term or ever not
be used in Linux at all? This is the connection to CIM?
Should this be docuemented?

> > > as long as they're willing to document their
> > > implementation.
> >
> > I'll point that out, something like:
> > If you really have to use WMI for Windows compatibility reason, make
> > sure the important parts (is there already something to mention?
> > Against what is the driver loaded -> autoloading?) are documented well.
>
> There's no valid reason to suggest that vendors use an entirely custom
> solution over using WMI. In some ways, reverse engineering is easier -
> we can see all the entry points. But yes, vendors who want to support
> Linux should document their firmware interfaces.
