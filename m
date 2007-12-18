Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbXLRQKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbXLRQKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 11:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbXLRQJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 11:09:59 -0500
Received: from elvis.franken.de ([193.175.24.41]:46341 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbXLRQJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 11:09:58 -0500
Date: Tue, 18 Dec 2007 17:09:38 +0100
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, Bob Picco <bob.picco@hp.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>,
       Andi Kleen <ak@muc.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Keith Mannthey <kmannth@gmail.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@osdl.org>, ralf@linux-mips.org
Subject: Re: [PATCH] Fix crash with FLAT_MEMORY and ARCH_PFN_OFFSET != 0
Message-ID: <20071218160938.GA20688@alpha.franken.de>
References: <20071218120300.7565AE3030@solo.franken.de> <20071218135828.GB24917@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218135828.GB24917@csn.ul.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 01:58:28PM +0000, Mel Gorman wrote:
> That commit is over a year old and it initially distressed me that it
> would take this long to show up on a boot test. However, you said this was
> to fix MIPS in a follow-on mail and I never made it use arch-independent
> zone-sizing which is where CONFIG_ARCH_POPULATES_NODE_MAP comes from. Support
> for arch-independent zone-sizing was added for MIPS on Nov 3rd 2007 by commit
> cce335ae47e231398269fb05fa48e0e9cbf289e0 (relevant cc added) which is a much
> more reasonable timeframe for catching this sort of problem. I believe the
> real bug might be in there.

either that or it got uncovered. But I'm not too deep into that part of
the kernel at the moment.

> 
> Can you post a full dmesg log with loglevel=8 so I can see what the layout
> looks like? My aim is to find out why the start of your mem_map is not at
> the start of node 0's mem_map which is what I generally expected with the
> FLATMEM model.


Linux version 2.6.24-rc5-g4b1e2593-dirty (tsbogend@solo.franken.de) (gcc version 4.2.1) #170 Tue Dec 18 17:03:53 CET 2007
ARCH: SGI-IP28
PROMLIB: ARC firmware Version 64 Revision 0
console [early0] enabled
CPU revision is: 00000925 (R10000)
FPU revision is: 00000900
MC: SGI memory controller Revision 5
MC: Probing memory configuration:
 bank0: 256M @ 20000000
 bank1: 128M @ 30000000
 bank2: 128M @ 38000000
Determined physical RAM map:
 memory: 0000000020000000 @ 0000000020000000 (usable)
Entering add_active_range(0, 131946, 262144) 0 entries of 256 used
Zone PFN ranges:
  Normal     131946 ->   262144
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:   131946 ->   262144
On node 0 totalpages: 130198
  Normal zone: 1780 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 128418 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128418
Kernel command line: root=scsi(0)disk(1)rdisk(0)partition(0) loglevel=8 ip=dhcp
Primary instruction cache 32kB, VIPT, 2-way, linesize 64 bytes.
Primary data cache 32kB, 2-way, VIPT, no aliases, linesize 32 bytes
Unified secondary cache 1024kB 2-way, linesize 128 bytes.
Synthesized clear page handler (44 instructions).
Synthesized copy page handler (82 instructions).
Synthesized TLB refill handler (37 instructions).
Synthesized TLB load handler fastpath (49 instructions).
Synthesized TLB store handler fastpath (49 instructions).
Synthesized TLB modify handler fastpath (48 instructions).
EISA: Probing bus...
EISA: Detected 0 card.
ISA support compiled in.
PID hash table entries: 2048 (order: 11, 16384 bytes)
Calibrating system timer... warning: timer counts differ, retrying... 87500 [175.0000 MHz CPU]
Console: colour dummy device 80x25
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
Memory: 512132k/524288k available (2659k kernel code, 8412k reserved, 817k data, 280k init, 0k highmem)


That's with my fix/workaround applied.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
