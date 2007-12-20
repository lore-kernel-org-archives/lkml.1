Return-Path: <linux-kernel-owner+w=401wt.eu-S936835AbXLTRZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936835AbXLTRZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936291AbXLTRZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:25:15 -0500
Received: from ns2.suse.de ([195.135.220.15]:38563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936238AbXLTRZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:25:13 -0500
Date: Thu, 20 Dec 2007 09:22:05 -0800
From: Greg KH <gregkh@suse.de>
To: Tony Camuso <tcamuso@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Message-ID: <20071220172205.GB5636@suse.de>
References: <476A5FD0.4010804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476A5FD0.4010804@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 07:28:00AM -0500, Tony Camuso wrote:
>
>
> -------- Original Message --------
> Subject: Re: [PATCH 0/5]PCI: x86 MMCONFIG
> Date: Wed, 19 Dec 2007 19:33:45 -0500
> From: Tony Camuso <tcamuso@redhat.com>
> Reply-To: tcamuso@redhat.com
> To: Greg KH <gregkh@suse.de>
> References: 
> <20071219221746.20362.39243.sendpatchset@dhcp83-188.boston.redhat.com> 
> <20071219231609.GE24219@suse.de>
>
> Greg KH wrote:
>> On Wed, Dec 19, 2007 at 05:17:46PM -0500, tcamuso@redhat.com wrote:
>>> There exist devices that do not respond correctly to PCI
>>> MMCONFIG accesses in x86 platforms.
>> What devices are these?  Do you have reports of them somewhere?
> There are the AMD 8131 and 8132, the Serverworks HT1000 bridge chips
> and the 830M/MG graphics. Not all versions of these chips present
> this pathology, but there are perhaps tens of thousands of systems
> out there that have the broken versions of these chipsets.

Why haven't we gotten reports about this before if this is a common
problem?

And why hasn't the vendor fixed the bios on these to work properly?

> RedHat have been maintaining a blacklist of systems having these
> devices. Systems in the blacklist are confined to legacy PCI
> access.

Do you have a pointer to this blacklist anywhere so that everyone can
benifit from this knowledge?

>> That sounds like this patchset can cause bad side affects on hardware
>> that currently works just fine.  That is not a good thing to be adding
>> to the kernel, right?
> No, the patch set tries to obviate this without requiring endusers to
> write customized scripts with "pci=nommconf" and without requiring the
> RH folks to add another platform (usually belatedly) to the blacklist.
>
> If a device is going to machine check when you touch it with an mmconfig
> access, it will happen with or without this patch-set.
>
> However, the patch-set does cover most of the devices that don't respond
> well to mmconfig access. Such devices almost alway7s return garbage when
> you read from them.
>
> The one device we know about that throws exceptions is the 830M/MG
> graphics chip. This chip passes the read-compare test, so the code
> merrily advances to bus sizing. When the bus sizing code writes the
> BAR at offset 0x18 in this device, the system hangs.

So it doesn't work at all, with or without this patch?  Does the vendor
know about this?

thanks,

greg k-h
