Return-Path: <linux-kernel-owner+w=401wt.eu-S1762539AbXJMSf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762539AbXJMSf2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbXJMSfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:35:19 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:22023 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649AbXJMSfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:35:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B91TLRdyg1jtpzEpCBQlvkA2WJzRw/f/3Tb4VjBkjqhwCFyxBPJzu+6A6ONoyY5Ar4i8E/YYOusMmEZ8oukQgj2WQhTByWq96ILTv1CKYf+KPUtGIFqX8t9HkMYx/xzK+QAMR7iGuSmewOhd5P0hk1wD2rjgVOJ2p9rLVkcv4i4=
Message-ID: <64bb37e0710131135s41790cafxd010d9eb04088728@mail.gmail.com>
Date: Sat, 13 Oct 2007 20:35:16 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071013111853.7e67c6c3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <4710A407.3070000@garzik.org>
	 <64bb37e0710130503haa66d6eu93e75ecdc78ac866@mail.gmail.com>
	 <4710B7C5.5050403@garzik.org>
	 <64bb37e0710130732p303547e3n54cfa9dac34c53b5@mail.gmail.com>
	 <64bb37e0710130740u78613f83wbd4f43d073bbe13d@mail.gmail.com>
	 <64bb37e0710130813le68c48dve36f8473b197b84b@mail.gmail.com>
	 <47110500.8050503@garzik.org>
	 <64bb37e0710131105m7c64fca0kb71f3955170e8bec@mail.gmail.com>
	 <20071013111853.7e67c6c3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 13 Oct 2007 20:05:19 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
>
> > The only thing I noted during load testing (updating Gentoo ==
> > compiling and installing) was, that there seems to be memory leak.
> > After ~2h 2.5 of my 4Gb where gone. But there where to many things
> > going on to pinpoint it... (NFSv4 over eth1394?)
>
> Please send /proc/meminfo and /proc/slabinfo after the leak has been
> happening for a while.
>
> Sometimes `echo m > /proc/sysrq_trigger ; dmesg -s 1000000' will
> provide useful info.

I don't have the meminfo or slabinfo, only the output from SysRq+M:

SysRq : Show Memory
Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 173   Cold: hi:   62, btch:  15 usd:  29
CPU    1: Hot: hi:  186, btch:  31 usd:  69   Cold: hi:   62, btch:  15 usd:   4
CPU    2: Hot: hi:  186, btch:  31 usd:  82   Cold: hi:   62, btch:  15 usd:  13
CPU    3: Hot: hi:  186, btch:  31 usd:  71   Cold: hi:   62, btch:  15 usd:   3
Node 1 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 171   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:  57   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd: 171   Cold: hi:   62, btch:  15 usd:   6
CPU    3: Hot: hi:  186, btch:  31 usd: 158   Cold: hi:   62, btch:  15 usd:   7
Node 1 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  13
CPU    3: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:  19
Active:236368 inactive:63289 dirty:365 writeback:0 unstable:0
 free:28366 slab:43372 mapped:13718 pagetables:2356 bounce:0
Node 0 DMA free:8048kB min:16kB low:20kB high:24kB active:0kB
inactive:0kB present:8876kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2004 2004 2004
Node 0 DMA32 free:98364kB min:4040kB low:5048kB high:6060kB
active:527764kB inactive:107636kB present:2052320kB pages_scanned:0
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 DMA32 free:5824kB min:3040kB low:3800kB high:4560kB
active:223216kB inactive:135068kB present:1544000kB pages_scanned:0
all_unreclaimable? no
lowmem_reserve[]: 0 0 505 505
Node 1 Normal free:1228kB min:1016kB low:1268kB high:1524kB
active:194492kB inactive:10452kB present:517120kB pages_scanned:0
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 7*8kB 4*16kB 5*32kB 3*64kB 3*128kB 4*256kB 2*512kB
1*1024kB 2*2048kB 0*4096kB = 8048kB
Node 0 DMA32: 10629*4kB 4229*8kB 1240*16kB 4*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 98364kB
Node 1 DMA32: 442*4kB 5*8kB 3*16kB 2*32kB 1*64kB 0*128kB 1*256kB
1*512kB 1*1024kB 1*2048kB 0*4096kB = 5824kB
Node 1 Normal: 182*4kB 17*8kB 9*16kB 1*32kB 3*64kB 0*128kB 0*256kB
0*512kB 0*1024kB 0*2048kB 0*4096kB = 1232kB
Swap cache: add 64, delete 64, find 35/40, race 0+0
Free swap  = 9775416kB
Total swap = 9775416kB
Free swap:       9775416kB
1048576 pages of RAM
35172 reserved pages
106120 pages shared
0 pages swap cached

When I noticed the leak, I stopped the emerge (the Gentoo update aka
the compiling tasks) and cleared the tmpfs that was used for it. I
also stopped X.
~1Gb was used as pagecache, slubinfo showed around 200..300 Mb used
for slab, but only ~350Mb free out of 4Gb.
I did not see any tasks with abnormal memory sizes.

> The page-owner code can pinpoint a leak source.  See
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/broken-out/page-owner-tracking-leak-detector.patch
>
> Enable CONFIG_DEBUG_SLAB_LEAK, check out /proc/slab_allocators
>

I suspected that I need more debugging options to track this.
Currently compiling more packages again, but no obvious leak.
When the leak occurred I noticed the disk throughput falling /
stalling several second and this appeared in the syslog:
ohci1394: fw-host0: Waking dma ctx=0 ... processing is probably too slow
ohci1394: fw-host0: Waking dma ctx=0 ... processing is probably too slow

I'm still using the old firewire stack because of eth1394.

I will mail again, when I have more info.

Torsten
