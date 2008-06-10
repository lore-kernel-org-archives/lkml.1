Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbYFJE0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbYFJE0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 00:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbYFJE0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 00:26:37 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51976 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbYFJE0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 00:26:36 -0400
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Transfer-Encoding: 7bit
Message-Id: <DE1761A7-9D0D-4EA6-824D-B160F844452A@mit.edu>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: linux-kernel@vger.kernel.org
From: Andrew Pochinsky <avp@MIT.EDU>
Subject: page allocation failure in 2.6.25.5
Date: Tue, 10 Jun 2008 00:26:40 -0400
X-Mailer: Apple Mail (2.753.1)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	I'm encountering page allocation failures on kernel 2.6.25.5 (as  
well as on 2.6.25 under similar conditions.) The machine is x86-64 4  
CPUs (XEON E5410), 8GB memory, running OpenSUSE 10.3. The kernel was  
built with gcc 4.2.1. The machine has four GigE links bonded together  
and is a part of pvfs2 file server, and a 3ware 16-port raid  
controller fully populated with 1TB disks.

Under heavy pvfs2 loads, sometimes an page allocation fails  
apparently while in handling a receive from the net. It is visible on  
a client side as a communication error with the server, other than  
that, the kernel on the server seems unaffected. When net load drops,  
the system continues to function normally.

Below is a relevant part of the dmesg.

Please CC me directly with any questions you might have as I do not  
subscribe to the list.
Thanks,
--andrew

swapper: page allocation failure. order:0, mode:0x20
Pid: 0, comm: swapper Not tainted 2.6.25.5-fs1 #1

Call Trace:
  <IRQ>  [<ffffffff802640cc>] __alloc_pages+0x31d/0x339
  [<ffffffff8027fedc>] kmem_getpages+0xbd/0x185
  [<ffffffff8028048c>] fallback_alloc+0x10d/0x185
  [<ffffffff8028013a>] kmem_cache_alloc_node+0xf6/0x11e
  [<ffffffff80361460>] __alloc_skb+0x65/0x12e
  [<ffffffff80362162>] __netdev_alloc_skb+0x29/0x43
  [<ffffffff88168d44>] :e1000e:e1000_alloc_rx_buffers+0xb4/0x1d4
  [<ffffffff881693b4>] :e1000e:e1000_clean_rx_irq+0x252/0x2e2
  [<ffffffff88165de0>] :e1000e:e1000_clean+0x2d8/0x454
  [<ffffffff80367b75>] net_rx_action+0x7c/0x146
  [<ffffffff8023172c>] __do_softirq+0x65/0xcf
  [<ffffffff8020ce8c>] call_softirq+0x1c/0x28
  [<ffffffff8020e534>] do_softirq+0x2c/0x68
  [<ffffffff8020e776>] do_IRQ+0xb6/0xd4
  [<ffffffff8020aeee>] mwait_idle+0x0/0x42
  [<ffffffff8020c211>] ret_from_intr+0x0/0xa
  <EOI>  [<ffffffff8020adca>] default_idle+0x0/0x55
  [<ffffffff8020af2a>] mwait_idle+0x3c/0x42
  [<ffffffff8020ae91>] cpu_idle+0x72/0x90

Mem-info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 180
CPU    1: hi:  186, btch:  31 usd: 171
CPU    2: hi:  186, btch:  31 usd: 111
CPU    3: hi:  186, btch:  31 usd:  90
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 136
CPU    1: hi:  186, btch:  31 usd: 157
CPU    2: hi:  186, btch:  31 usd: 103
CPU    3: hi:  186, btch:  31 usd:  57
Active:108437 inactive:1847795 dirty:62205 writeback:65 unstable:0
  free:9199 slab:71531 mapped:2668 pagetables:540 bounce:0
Node 0 DMA free:12392kB min:16kB low:20kB high:24kB active:0kB  
inactive:0kB present:11928kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2999 8049 8049
Node 0 DMA32 free:21788kB min:4272kB low:5340kB high:6408kB active: 
18728kB inactive:2828072kB present:3071200kB pages_scanned:0  
all_unreclaimable? no
lowmem_reserve[]: 0 0 5050 5050
Node 0 Normal free:2616kB min:7196kB low:8992kB high:10792kB active: 
415020kB inactive:4563108kB present:5171200kB pages_scanned:0  
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 6*8kB 4*16kB 1*32kB 5*64kB 3*128kB 1*256kB 0*512kB  
1*1024kB 1*2048kB 2*4096kB = 12392kB
Node 0 DMA32: 11*4kB 9*8kB 39*16kB 16*32kB 8*64kB 2*128kB 3*256kB  
3*512kB 11*1024kB 1*2048kB 1*4096kB = 21732kB
Node 0 Normal: 0*4kB 1*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB  
0*512kB 0*1024kB 1*2048kB 0*4096kB = 2520kB
1945285 total pagecache pages
Swap cache: add 17, delete 0, find 0/0
Free swap  = 8388532kB
Total swap = 8388600kB
Free swap:       8388532kB
2097152 pages of RAM
46557 reserved pages
1292432 pages shared
17 pages swap cached

