Return-Path: <linux-kernel-owner+w=401wt.eu-S1751578AbXBFI0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbXBFI0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbXBFI0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:26:00 -0500
Received: from colo.lackof.org ([198.49.126.79]:57518 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbXBFIZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:25:59 -0500
Date: Tue, 6 Feb 2007 01:25:50 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, greg@kroah.com,
       Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Message-ID: <20070206082550.GA25953@colo.lackof.org>
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com> <20070206045528.GA4228@colo.lackof.org> <1a297b360702052120x10f15b4cicaa867573d0210b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a297b360702052120x10f15b4cicaa867573d0210b9@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 09:20:15AM +0400, Manu Abraham wrote:
...
> >BIST is required to complete in 2 seconds. Either with success or failure.
> >I expect BIOS to have complained before launching grub/lilo.
...
> BIST is supposed to terminate before, say the OS kernel is loaded?

Yes - that's what I was trying to imply above.

> or does it mean that it can keep running still ?

Don't know. Either it's still running (for much longer that 2 seconds),
linux is causing it run _again_, or linux is has terribly confused the
device somehow. More on this in an email I'm still working on...will
send that out in a bit.

> >>       Region 0: Memory at f7ee0000 (32-bit, non-prefetchable) [disabled] 
> >[size=4K]
> >>       Region 2: Memory at e9b00000 (32-bit, prefetchable) [disabled] 
> >[size=4K]
> >>       Region 3: Memory at <unassigned> (32-bit, prefetchable) [disabled]
> >>       Region 4: Memory at <ignored> (32-bit, non-prefetchable) [disabled]
> >>       Region 5: Memory at <invalid-64bit-slot> (64-bit, 
> >non-prefetchable) [disabled]
> >
> >This is obviously garbage. 64-bit registers can only be represented with
> >two consecutive "BAR" and region 5 is the last one.
> >There is no way this can be a 64-bit BAR.
> >Generally, 64-bit BARs start on an "even" numbered BAR (but I've forgotten
> >again if that's just convention or a requirement)
> >
> 
> was just wondering how it could be a 64 bit device.

64-bit BAR is seperate from 64-bit Device (data path).

PCI has three different 32 vs 64-bit areas:
o BARs
o DMA 
o HW/data path width.

"32-bit device" generally only refers to the latter.
The three attributes are generally all "32-bit" for "32-bit device".

That's less likely to be true for "64-bit devices". Several "64-bit
devices" can only DMA to 32-bit host memory and at least a few only
support 32-bit BARs (even if the device claims it has a 64-bit BAR).

hth,
grant

> 
> >hth,
> >grant
> >
> 
> 
> Thanks a lot for the valuable info. I had not ruled out the option
> that it could be broken.
> I will try the device in the other OS also, to confirm this. Will post
> the status after that.
> But most probably as you said, could be broken.
> 
> Thanks,
> Manu
