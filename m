Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbXDLRpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbXDLRpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXDLRpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:45:15 -0400
Received: from dsl-mtryl-66-18-218-115-cgy.nucleus.com ([66.18.218.115]:56505
	"HELO schaus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751306AbXDLRpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:45:13 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2007 13:45:12 EDT
Date: Thu, 12 Apr 2007 11:38:30 -0600
From: Cameron Schaus <cam@schaus.ca>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20 OOM with 8Gb RAM
Message-ID: <20070412173830.GA31323@schaus.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am running the latest FC5-i686-smp kernel, 2.6.20, on a machine with
8Gb of RAM, and 2 Xeon processors.  The system has a 750Mb ramdisk,
and one process allocating and deallocating memory that is also
writing lots of files to the ramdisk.  The process also reads and
writes from the network.  After the process runs for a while, the
linux OOM killer starts killing processes, even though there is lots
of memory available.

The system does not ordinarily use swap space, but I've added swap to
see if it makes a difference, but it only defers the problem.

The OOM dump below shows that memory in the NORMAL_ZONE is exhausted,
but there is still plenty of memory (6Gb+) in the HighMem Zone.  I can
provide .config and dmesg data if these would be helpful.

Why is the OOM killer being invoked when there is still memory
available for use?

java invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
java invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
 [<c0455f84>] out_of_memory+0x69/0x191
 [<c0457460>] __alloc_pages+0x220/0x2aa
 [<c046c80a>] cache_alloc_refill+0x26f/0x468
 [<c046ca76>] __kmalloc+0x73/0x7d
 [<c05bb4ce>] __alloc_skb+0x49/0xf7
 [<c05e483d>] tcp_sendmsg+0x169/0xa04
 [<c05fd76d>] inet_sendmsg+0x3b/0x45
 [<c05b57d5>] sock_aio_write+0xf9/0x105
 [<c0455708>] generic_file_aio_read+0x173/0x1a3
 [<c046fd11>] do_sync_write+0xc7/0x10a
 [<c04379fd>] autoremove_wake_function+0x0/0x35
 [<c05e413e>] tcp_ioctl+0x10a/0x115
 [<c05e4034>] tcp_ioctl+0x0/0x115
 [<c05fd406>] inet_ioctl+0x8d/0x91
 [<c0470564>] vfs_write+0xbc/0x154
 [<c0470b62>] sys_write+0x41/0x67
 [<c0403ef6>] sysenter_past_esp+0x5f/0x85
 =======================
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  84   Cold: hi:   62, btch:  15 usd:  53
CPU    1: Hot: hi:  186, btch:  31 usd:  66   Cold: hi:   62, btch:  15 usd:  57
CPU    2: Hot: hi:  186, btch:  31 usd:  59   Cold: hi:   62, btch:  15 usd:  51
CPU    3: Hot: hi:  186, btch:  31 usd:  60   Cold: hi:   62, btch:  15 usd:  58
HighMem per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  65   Cold: hi:   62, btch:  15 usd:   1
CPU    1: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:   5
CPU    2: Hot: hi:  186, btch:  31 usd:  12   Cold: hi:   62, btch:  15 usd:   4
CPU    3: Hot: hi:  186, btch:  31 usd:   9   Cold: hi:   62, btch:  15 usd:   3
Active:313398 inactive:141504 dirty:0 writeback:0 unstable:0 free:1592770 slab:20743 mapped:7015 pagetables:819
DMA free:3536kB min:68kB low:84kB high:100kB active:3496kB inactive:3088kB present:16224kB pages_scanned:24701 all_unreclaimable? yes
lowmem_reserve[]: 0 871 8603
Normal free:1784kB min:3740kB low:4672kB high:5608kB active:324892kB inactive:394008kB present:892320kB pages_scanned:1419914 all_unreclaimable? yes
lowmem_reserve[]: 0 0 61854
HighMem free:6365760kB min:512kB low:8816kB high:17120kB active:925204kB inactive:168920kB present:7917312kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 0*4kB 0*8kB 1*16kB 2*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3536kB
Normal: 0*4kB 1*8kB 1*16kB 9*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1784kB
HighMem: 1438*4kB 599*8kB 191*16kB 49*32kB 0*64kB 0*128kB 79*256kB 48*512kB 10*1024kB 8*2048kB 1533*4096kB = 6365760kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 9775512kB
Total swap = 9775512kB

