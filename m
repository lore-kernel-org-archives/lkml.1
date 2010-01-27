Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376Ab0A0Aja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab0A0Aja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303Ab0A0Aj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:39:29 -0500
Received: from mail1.radix.net ([207.192.128.31]:44619 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab0A0Aj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:39:29 -0500
Subject: Re: which fields in /proc/meminfo are orthogonal?
From: Andy Walls <awalls@radix.net>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
In-Reply-To: <4B5F54DE.7030302@nortel.com>
References: <4B5F3C9C.3050908@nortel.com>  <4B5F54DE.7030302@nortel.com>
Content-Type: text/plain
Date: Tue, 26 Jan 2010 19:38:34 -0500
Message-Id: <1264552714.3089.2.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 14:47 -0600, Chris Friesen wrote:
> On 01/26/2010 01:03 PM, Chris Friesen wrote:
> 
> > I'm currently trying to figure out which of the entries in /proc/meminfo
> > are actually orthogonal to each other.  Ideally I'd like to be able to
> > add up the suitable entries and have it work out to the total memory on
> > the system, so that I can then narrow down exactly where the memory is
> > going.  Is this feasable?
> 
> I've tried adding up
> MemFree+Buffers+Cached+AnonPages+Mapped+Slab+PageTables+VmallocUsed

VmallocUsed referws to Vmalloc address space consumption.  However,
Vmalloc address space is not used exclusively to map system RAM into
virtual address space.  It is also used to map PCI MMIO windows to the
register sets or memory chips on PCI cards into the vritual address
space.

Regards,
Andy


> (hugepages are disabled and there is no swap)
> 
> Shortly after boot this gets me within about 3MB of MemTotal.  However,
> after 1070 minutes there is a 64MB difference between MemTotal and the
> above sum.
> 
> Here's /proc/meminfo after 1070 minutes:
> 
> MemTotal:      4042848 kB
> MemFree:        406112 kB
> Buffers:         12072 kB
> Cached:        3068368 kB
> SwapCached:          0 kB
> Active:         671200 kB
> Inactive:      2711952 kB
> SwapTotal:           0 kB
> SwapFree:            0 kB
> Dirty:              44 kB
> Writeback:           0 kB
> AnonPages:      235864 kB
> Mapped:          30752 kB
> Slab:           200156 kB
> SReclaimable:   142828 kB
> SUnreclaim:      57328 kB
> PageTables:       4320 kB
> NFS_Unstable:        0 kB
> Bounce:              0 kB
> WritebackTmp:        0 kB
> CommitLimit:   2021424 kB
> Committed_AS:  2593116 kB
> VmallocTotal: 34359738367 kB
> VmallocUsed:     21496 kB
> VmallocChunk: 34359716779 kB
> HugePages_Total:     0
> HugePages_Free:      0
> HugePages_Rsvd:      0
> HugePages_Surp:      0
> Hugepagesize:     2048 kB
> DirectMap4k:      3008 kB
> DirectMap2M:   4190208 kB
> 
> Any ideas how to track down the missing memory?
> 
> Chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

