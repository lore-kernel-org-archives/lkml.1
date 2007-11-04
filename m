Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbXKDBd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbXKDBd7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 21:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbXKDBdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 21:33:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbXKDBdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 21:33:52 -0400
Message-ID: <472D2119.8090102@redhat.com>
Date: Sat, 03 Nov 2007 21:32:09 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Zurk Tech <zurktech@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Quad core CPU detected but shows as single core in 2.6.23.1
References: <2ed59cbb0711021231l55fe2df3l23f8da65bb7166f6@mail.gmail.com>
In-Reply-To: <2ed59cbb0711021231l55fe2df3l23f8da65bb7166f6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zurk Tech wrote:
> dmesg (new) with disabled GART error reporting if anyone wants to
> compare to previous dmesg with GART error reporting :

A few unrelated observations about Barcelona support...

> Marking TSC unstable due to TSCs unsynchronized

This is probably wrong.  The TSC is on the northbridge on Barcelona chips, so 
every core on the die should be in sync.  Hypothetically you could have 
different speed northbridges in different sockets, but we've never tried very 
hard to support that case anyway.  We should probably be marking the TSC as 
stable on Barcelona chips.

> xor: automatically using best checksumming function: generic_sse
>    generic_sse:  7449.000 MB/sec
> xor: using function: generic_sse (7449.000 MB/sec)

We should probably also implement an SSE5 function to take advantage of the 
128-bit SSE operations supported on newer processors.

> pnp: the driver 'system' has been registered
> pnp: match found with the PnP device '00:08' and the driver 'system'
> pnp: match found with the PnP device '00:09' and the driver 'system'
> pnp: 00:09: ioport range 0x580-0x58f has been reserved
> pnp: 00:09: ioport range 0x590-0x593 has been reserved
> pnp: 00:09: ioport range 0x700-0x703 has been reserved
> pnp: 00:09: ioport range 0xca0-0xcaf has been reserved
> pnp: 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
> pnp: 00:09: iomem range 0xfec01000-0xfec01fff could not be reserved
> pnp: 00:09: iomem range 0xfec02000-0xfec02fff could not be reserved
> pnp: 00:09: iomem range 0xfee00000-0xfee00fff could not be reserved
> pnp: match found with the PnP device '00:0a' and the driver 'system'
> pnp: 00:0a: ioport range 0x600-0x61f has been reserved
> pnp: 00:0a: ioport range 0x520-0x53f has been reserved
> pnp: 00:0a: ioport range 0x540-0x54f has been reserved
> pnp: 00:0a: ioport range 0x640-0x65f has been reserved
> pnp: match found with the PnP device '00:0b' and the driver 'system'
> pnp: 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
> pnp: match found with the PnP device '00:0c' and the driver 'system'
> pnp: 00:0c: iomem range 0x0-0x9ffff could not be reserved
> pnp: 00:0c: iomem range 0x0-0x0 could not be reserved
> pnp: 00:0c: iomem range 0xe0000-0xfffff could not be reserved
> pnp: 00:0c: iomem range 0x100000-0xc7ffffff could not be reserved
> PCI: Bridge: 0000:01:0d.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:01.0
>   IO window: a000-bfff
>   MEM window: ff400000-ff4fffff
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:06.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:07.0
>   IO window: disabled.
>   MEM window: ff500000-ff5fffff
>   PREFETCH window: cfe00000-cfefffff
> PCI: Bridge: 0000:00:08.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:09.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:0a.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:0b.0
>   IO window: disabled.
>   MEM window: disabled.

Hmmm... perhaps we're not handling the new mmconfig stuff correctly?  Or maybe 
the BIOS isn't.

> hwmon-vid: Unknown VRM version of your x86 CPU
>  : Not supporting VRM 0.0

This code probably needs an update for Barcelona.

> raid6: int64x1   1920 MB/s
> raid6: int64x2   2353 MB/s
> raid6: int64x4   2331 MB/s
> raid6: int64x8   1254 MB/s
> raid6: sse2x1    2664 MB/s
> raid6: sse2x2    4214 MB/s
> raid6: sse2x4    4905 MB/s
> raid6: using algorithm sse2x4 (4905 MB/s)

An update here for SSE5 might be in order as well.

	-- Chris
