Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbYFAXoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbYFAXoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYFAXnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:43:52 -0400
Received: from lucidpixels.com ([75.144.35.66]:50169 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbYFAXnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:43:51 -0400
Date: Sun, 1 Jun 2008 19:43:49 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Limits of the 965 chipset & 3 PCI-e cards/southbridge? ~774MiB/s
 peak for read, ~650MiB/s peak for write?
In-Reply-To: <6278d2220806011423o22e98f27qfd72fbd152d19d9f@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0806011942580.11366@p34.internal.lan>
References: <6278d2220806011423o22e98f27qfd72fbd152d19d9f@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Jun 2008, Daniel J Blueman wrote:

> On 1 Jun, 10:50, Justin Piszcz <jpis...@lucidpixels.com> wrote:
>> I have 12 enterprise-class seagate 1TiB disks on a 965 desktop board and
>> it appears I have hit the limit, if I were able to get the maximum speed
>> of all drives, ~70MiB/avg * 12 = 840MiB/s but it seems to stop aound 774
>> MiB/s (currently running badblocks on all drives)..
>
> Nice test. The Seagate 7200.11 drives deliver 120MB/s (outer zone,
> raw) each, and there is an issue with CFQ dispatching requests; see:
>
> http://groups.google.co.uk/group/linux.kernel/browse_thread/thread/b88264b084a2dfe0/a1bc0f67837bad00
>
> A quick workaround tweak is:
>
> # echo 0 >/sys/block/sda/queue/iosched/slice_idle
>
> Does this help any? This gives the difference of ~68MB/s vs ~120MB/s
> on my 7200.11 ;-) .
>
> That said, the i965 chipset is fairly contemporary, but if that 2GB/s
> DMI connection is the bidirectional bandwidth (likely), then maybe
> you're hitting that limit: Intel's DMI bus is based on PCIe, thus will
> use 128 byte PCI-e Max Payload packets (as in the rest of the
> chipset), which IIRC theoretically maxes you out near 800MB/s.
>
> The X48 chipset may allow you to crank the Max Payload to 256 (setpci
> and the Intel chipset docs), if it doesn't default to 256, like in
> 5400 server chipsets. This chipset is where the fun really starts eg
> hdparm -T giving >10GB/s, like in Itanium2s ;-) .
>
> Thanks,
>  Daniel
> -- 
> Daniel J Blueman
>

slice 0 does help a little with my 10-disk raid5 for sequential 
read/writes:

http://home.comcast.net/~jpiszcz/raid/20080601/raid5.html
