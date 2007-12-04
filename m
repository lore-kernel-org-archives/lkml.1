Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbXLDEZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbXLDEZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 23:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXLDEZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 23:25:05 -0500
Received: from vic.ffii.org ([82.197.166.218]:51972 "EHLO vic.ffii.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbXLDEZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 23:25:01 -0500
X-Greylist: delayed 2370 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2007 23:25:01 EST
Date: Tue, 4 Dec 2007 04:45:22 +0100 (CET)
From: Bernhard Kaindl <bkaindl@ffii.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Andi Kleen <ak@suse.de>, Bernhard Kaindl <bk@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: remote debugging via FireWire * __fast__ firedump!
In-Reply-To: <45CDCDCD.5000609@s5r6.in-berlin.de>
Message-ID: <alpine.DEB.0.9999.0712040426100.3769@vic.ffii.org>
References: <200702101242.48467.ak@suse.de> <45CDCDCD.5000609@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    I just wanted to let you know that I'll have picked up the early
firewire patch again and cleaned it up very much so that it should
be ready to submit it and but it on the patch-submission road.

What's left to do is to write some HOWTO like Stefan describes
below, but I'll try to get that done soon.

I've also started working on the userspace tools and got firescope
to work across the 32/64-bit machines (both directions), there is
one hack (which I should do in a clean way insteat) in that patch
of which I do not know if that works in ppc/ppc64 but I could look
at it if needed or send the patch to Benjamin for adding support
for ppc64, to do it properly, we'll probably need an target architecture
option in firescope and as I do not know if it's needed by Benjamin,
I left out ppc64 for now.

I have just had the guts to explore __fast__ memory dumping over
firewire for full-system dumps (reading quadlets is __painfully__
show if you want to read 2GB of memory over the bus, you only get
about some some kilobytes each second) using raw1394_start_read()
to allow also block reads instead of just quatlet reads.

The biggest block size that worked here was 2048 bytes, which was
enough to get nearly 10MB/s of data transfer rate from the remote
memory to disk. Dumping 2GB of remote memory was just a matter of
about 3 few short minutes which quickly ran by.

Afterwards, the victim was dead (I excluded the low MB of memory,
so something else must have caused this), at least the start of
the dump looked well, but I haven't tested the error handling yet,
but I'll send you the tool (I called it firedump) soon.

Bernhard

On Sat, 10 Feb 2007, Stefan Richter wrote:

> Andi Kleen wrote at LKML:
> ...
>> Not likely to make .21:
> ...
>> - Early firewire support for firescope at early boot
> ...
>
> Was it seen in canonical patch format on a mailinglist before?
> Is it Bernhard Kaindl's ohci1394_early?
> http://www.suse.de/~bk/firewire/
>
> Would be good to put this on the usual patch-submission road in order to
> prep it for 2.6.22. Could be handled via linux1394-2.6.git, although a
> different channel where the actual users of this facility watch would
> IMO be more appropriate.
>
> I also have suggestions, at least WRT Bernhard's code:
>  - The Kconfig option could go into the "Kernel hacking" submenu rather
>    than the IEEE 1394 submenu. (The driver source should stay in
>    drivers/ieee1394.)
>  - Leave a note in the Kconfig help how it is typically used, i.e. what
>    is required on the remote terminal side, where to find firescope,
>    fireproxy etc. and assorted HOWTOs.
>  - Indicate in the Kconfig help that only a 4GB address range is made
>    visible this way.
>
> A mostly unrelated note: A simple to set up remote-dmesg utility would
> be nice to have on the terminal side. Maybe a small ieee1394 high-level
> driver which gives hints on the location of the dmesg buffer via
> configuration ROM would be warranted. Or is it feasible to find the
> dmesg buffer by plain memory analysis?
> --
> Stefan Richter
> -=====-=-=== --=- -=-=-
> http://arcgraph.de/sr/
>
> -------------------------------------------------------------------------
> Using Tomcat but need to do more? Need to support web services, security?
> Get stuff done quickly with pre-integrated technology to make your job easier.
> Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
> http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
> _______________________________________________
> mailing list linux1394-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux1394-devel
>
>
