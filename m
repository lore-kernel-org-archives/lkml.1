Return-Path: <linux-kernel-owner+w=401wt.eu-S933245AbXHVUyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbXHVUyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758545AbXHVUyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:54:05 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:36815 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814AbXHVUxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:53:55 -0400
Message-ID: <46CCA14A.6060103@linux.vnet.ibm.com>
Date: Thu, 23 Aug 2007 02:19:14 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [BUG] 2.6.23-rc3-mm1 oom-killer gets invoked
Content-Type: multipart/mixed;
 boundary="------------050801060303080807010008"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050801060303080807010008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew,

I see the oom-killer getting invoked many times on the
2.6.23-rc3-mm1 kernel and have attached the complete console
log and config file.

========================================================
cc1 invoked oom-killer: gfp_mask=0x280d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] <4>cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, 
oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c016000f>] do_filp_open+0x25/0x39

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 
usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 
usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 
usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 
usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  67   Cold: hi:   62, btch:  15 
usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 
usd:  57

CPU    2: Hot: hi:  186, btch:  31 usd: 126   Cold: hi:   62, btch:  15 
usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd:  50   Cold: hi:   62, btch:  15 
usd:  19

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 
usd:  10

CPU    1: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 
usd:  19

CPU    2: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:   62, btch:  15 
usd:  27

CPU    3: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 
usd:  56

Active:228916 inactive:238880 dirty:0 writeback:0 unstable:0

 free:12273 slab:14578 mapped:36 pagetables:10564 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2496kB 
inactive:1716kB present:16224kB pages_scanned:171850 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40400kB min:3740kB low:4672kB high:5608kB active:358456kB 
inactive:358000kB present:892320kB pages_scanned:1427617 
all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:616kB min:512kB low:1736kB high:2960kB active:554712kB 
inactive:595804kB present:1167812kB pages_scanned:2215902 
all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 
1*2048kB 1*4096kB = 8076kB

Normal: 70*4kB 25*8kB 1*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 
1*1024kB 0*2048kB 8*4096kB = 40400kB

HighMem: 49*4kB 20*8kB 4*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 676kB

Swap cache: add 12954, delete 12954, find 2676/3551, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27480 (make) score 2082 or a child

Killed process 27908 (sh)

Thanks & Regards,
Kamalesh Babulal.

--------------050801060303080807010008
Content-Type: text/plain;
 name="console_log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="console_log"

cc1 invoked oom-killer: gfp_mask=0x280d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] <4>cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c016000f>] do_filp_open+0x25/0x39

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  67   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  57

CPU    2: Hot: hi:  186, btch:  31 usd: 126   Cold: hi:   62, btch:  15 usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd:  50   Cold: hi:   62, btch:  15 usd:  19

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  10

CPU    1: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  19

CPU    2: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:   62, btch:  15 usd:  27

CPU    3: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:  56

Active:228916 inactive:238880 dirty:0 writeback:0 unstable:0

 free:12273 slab:14578 mapped:36 pagetables:10564 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2496kB inactive:1716kB present:16224kB pages_scanned:171850 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40400kB min:3740kB low:4672kB high:5608kB active:358456kB inactive:358000kB present:892320kB pages_scanned:1427617 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:616kB min:512kB low:1736kB high:2960kB active:554712kB inactive:595804kB present:1167812kB pages_scanned:2215902 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 70*4kB 25*8kB 1*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40400kB

HighMem: 49*4kB 20*8kB 4*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 676kB

Swap cache: add 12954, delete 12954, find 2676/3551, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27480 (make) score 2082 or a child

Killed process 27908 (sh)

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c016fd86>] d_lookup+0x1c/0x3d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0333478>] _spin_lock_irqsave+0x9/0xd

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0119180>] default_wake_function+0x0/0xc

 [<c012813d>] sys_rt_sigprocmask+0x50/0xc1

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  67   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  57

CPU    2: Hot: hi:  186, btch:  31 usd: 126   Cold: hi:   62, btch:  15 usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd:  50   Cold: hi:   62, btch:  15 usd:  19

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  10

CPU    1: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  28

CPU    2: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:   62, btch:  15 usd:  41

CPU    3: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:  56

Active:227779 inactive:240068 dirty:0 writeback:0 unstable:0

 free:12273 slab:14578 mapped:36 pagetables:10564 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2496kB inactive:1716kB present:16224kB pages_scanned:171850 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40400kB min:3740kB low:4672kB high:5608kB active:358456kB inactive:358000kB present:892320kB pages_scanned:1427617 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:616kB min:512kB low:1736kB high:2960kB active:550164kB inactive:600556kB present:1167812kB pages_scanned:2234213 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 70*4kB 25*8kB 1*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40400kB

HighMem: 49*4kB 20*8kB 4*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 676kB

Swap cache: add 12954, delete 12954, find 2676/3551, race 0+1

Free swap  = 0kB

Total swap = 8024kB

objdump invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c014cac0>] vma_prio_tree_insert+0x17/0x2a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] e====

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  67   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  57

CPU    2: Hot: hi:  186, btch:  31 usd: 126   Cold: hi:   62, btch:  15 usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd:  50   Cold: hi:   62, btch:  15 usd:  19

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  10

CPU    1: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  28

CPU    2: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:   62, btch:  15 usd:  41

CPU    3: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:  56

Active:227869 inactive:239983 dirty:0 writeback:0 unstable:0

 free:12273 slab:14578 mapped:36 pagetables:10564 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2496kB inactive:1716kB present:16224kB pages_scanned:171850 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40400kB min:3740kB low:4672kB high:5608kB active:358816kB inactive:357660kB present:892320kB pages_scanned:1445369 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:616kB min:512kB low:1736kB high:2960kB active:550164kB inactive:600556kB present:1167812kB pages_scanned:2276325 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 70*4kB 25*8kB 1*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40400kB

HighMem: 49*4kB 20*8kB 4*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 676kB

Swap cache: add 12954, delete 12954, find 2676/3551, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: HotHot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  67   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  57

CPU    2: Hot: hi:  186, btch:  31 usd: 126   Cold: hi:   62, btch:  15 usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd:  50   Cold: hi:   62, btch:  15 usd:  19

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  10

CPU    1: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  28

CPU    2: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:   62, btch:  15 usd:  41

CPU    3: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:  56

Active:226924 inactive:240955 dirty:0 writeback:0 unstable:0

 free:12273 slab:14578 mapped:36 pagetables:10564 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2496kB inactive:1716kB present:16224kB pages_scanned:171850 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40400kB min:3740kB low:4672kB high:5608kB active:359000kB inactive:357660kB present:892320kB pages_scanned:1447888 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:616kB min:512kB low:1736kB high:2960kB active:546384kB inactive:604444kB present:1167812kB pages_scanned:2300435 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 70*4kB 25*8kB 1*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40400kB

HighMem: 49*4kB 20*8kB 4*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 676kB

Swap cache: add 12954, delete 12954, find 2676/3551, race 0+1

Free swap  = 0kB

Total swap = 8024kB

as invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0167c5e>] do_path_lookup+0x17a/0x1c3

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0163950>] sys_stat64+0xf/0x23

 [<c015203a>] sys_brk+0xc9/0xd0

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  67   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  57

CPU    2: Hot: hi:  186, btch:  31 usd: 126   Cold: hi:   62, btch:  15 usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd:  5 0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  67   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  57

CPU    2: Hot: hi:  186, btch:  31 usd: 126   Cold: hi:   62, btch:  15 usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd:  50   Cold: hi:   62, btch:  15 usd:  19

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  10

CPU    1: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  28

CPU    2: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:   62, btch:  15 usd:  41

CPU    3: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:  56

Active:225253 inactive:242686 dirty:0 writeback:0 unstable:0

 free:12273 slab:14578 mapped:36 pagetables:10564 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2496kB inactive:1716kB present:16224kB pages_scanned:171850 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40400kB min:3740kB low:4672kB high:5608kB active:359000kB inactive:357660kB present:892320kB pages_scanned:1447888 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:616kB min:512kB low:1736kB high:2960kB active:539516kB inactive:611368kB present:1167812kB pages_scanned:2303370 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 70*4kB 25*8kB 1*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40400kB

HighMem: 49*4kB 20*8kB 4*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 676kB

Swap cache: add 12954, delete 12954, find 2676/3551, race 0+1

Free swap  = 0kB

Total swap = 8024kB

as invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] <4>gcc invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0147386>]  [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] out_of_memory+0x70/0xf6

filemap_nopage+0x164/0x30d

 [<c01484c4>]  [<c0150c7d>] __alloc_pages+0x21b/0x2a8

do_no_page+0x91/0x2fb

 [<c0160986>]  [<c0149f29>] do_sync_read+0xbf/0xfc

__do_page_cache_readahead+0xc8/0x13a

 [<c0151201>]  [<c014535b>] __handle_mm_fault+0x151/0x2bc

filemap_nopage+0x164/0x30d

 [<c0115990>]  [<c0150c7d>] do_page_fault+0x2a3/0x5f7

 [<c0125e2a>] do_no_page+0x91/0x2fb

run_timer_softirq+0x15e/0x166

 [<c0151201>]  [<c01156ed>] __handle_mm_fault+0x151/0x2bc

do_page_fault+0x0/0x5f7

 [<c0167edf>]  [<c03336c4>] __user_walk_fd+0x36/0x3e

error_code+0x7c/0x84

 [<c0115990>]  =======================

do_page_fault+0x2a3/0x5f7

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

 [<c0173168>] CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

mntput_no_expire+0x11/0x6e

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

 [<c01156ed>] Cstable:0

 free:12273 slab:14578 mapped:36 pagetables:10564 bounce:0

 0DMA free:8076kB min:68kB low:84kB high:100kB active:2496kB inactive:1716kB present:16224kB pages_scanned:171850 all_unreclaimable? yes

 9123lowmem_reserve[]: 0

 871HighMem free:616kB min:512kB low:1736kB high:2960kB active:538992kB inactive:612400kB present:1167812kB pages_scanned:2336370 all_unreclaimable? yes

 2011lowmem_reserve[]:

Normal free:40400kB min:3740kB low:4672kB high:5608kB active:359888kB inactive:357056kB present:892320kB pages_scanned:1464993 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0 9123

 0HighMem free:616kB min:512kB low:1736kB high:2960kB active:538992kB inactive:612400kB present:1167812kB pages_scanned:2336402 all_unreclaimable? yes

 0lowmem_reserve[]: 0

 0 0DMA: 

1*4kB DMA: 1*4kB 1*8kB 1*8kB 2*16kB 1*32kB 2*16kB 1*64kB 0*128kB 1*256kB 1*32kB 1*512kB 1*1024kB 1*2048kB 1*64kB 1*4096kB 0*128kB = 8076kB

Normal: 70*4kB 25*8kB 1*16kB 1*256kB 1*32kB 1*512kB 1*64kB 1*1024kB 33*128kB 1*2048kB 7*256kB 1*4096kB 0*512kB = 8076kB

1*1024kB 0*2048kB Normal: 8*4096kB 70*4kB = 40400kB

HighMem: 19*4kB 25*8kB 20*8kB 4*16kB 6*32kB 1*16kB 1*64kB 1*32kB 0*128kB 1*64kB 0*256kB 33*128kB 0*512kB 0*1024kB 0*2048kB 7*256kB 0*4096kB = 556kB

0*512kB Swap cache: add 12954, delete 12954, find 2676/3551, race 0+1

1*1024kB Free swap  = 0kB

Total swap = 8024kB

0*2048kB 8*4096kB = 40400kB

HighMem: 19*4kB 20*8kB 4*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 556kB

Swap cache: add 12954, delete 12954, find 2676/3551, race 0+1

Free swap  = 0kB

Total swap = 8024kB

__alloc_pages+0x21b/0x2a8

 [<c0150a47>] do_anonymous_page+0x3e/0x1e3

 [<c0151251>] __handle_mm_fault+0x1a1/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  67   Cold: hi:   62, btch:  15 usd:  14

CPU    1: Hot: hi:  186, btch:  31 usd: 163   Cold: hi:   62, btch:  15 usd:   3

CPU    2: Hot: hi:  186, btch:  31 usd: 126   Cold: hi:   62, btch:  15 usd:  47

CPU    3: Hot: hi:  186, btch:  31 usd:  50   Cold: hi:   62, btch:  15 usd:  19

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  90   Cold: hi:   62, btch:  15 usd:  58

CPU    1: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  57

CPU    2: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  47

CPU    3: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:  56

Active:227775 inactive:241080 dirty:0 writeback:0 unstable:0

 free:12264 slaprintk: 84 messages suppressed.

sh invoked oom-killer: gfp_mask=0x280d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0150a47>] do_anonymous_page+0x3e/0x1e3

 [<c0151251>] __handle_mm_fault+0x1a1/0x2bc

 [<c01521d2>] vma_link+0xc1/0xcb

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  64   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  32

CPU    2: Hot: hi:  186, btch:  31 usd: 128   Cold: hi:   62, btch:  15 usd:  29

CPU    3: Hot: hi:  186, btch:  31 usd:  56   Cold: hi:   62, btch:  15 usd:  41

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  90   Cold: hi:   62, btch:  15 usd:  60

CPU    1: Hot: hi:  186, btch:  31 usd:  22   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  32

CPU    3: Hot: hi:  186, btch:  31 usd:  91   Cold: hi:   62, btch:  15 usd:  55

Active:177084 inactive:290629 dirty:0 writeback:0 unstable:0

 free:12182 slab:14570 mapped:42 pagetables:10552 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2512kB inactive:1684kB present:16224kB pages_scanned:172170 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40156kB min:3740kB low:4672kB high:5608kB active:358572kB inactive:358400kB present:892320kB pages_scanned:1156433 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:496kB min:512kB low:1736kB high:2960kB active:347252kB inactive:802560kB present:1167812kB pages_scanned:2681187 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 17*4kB 21*8kB 1*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40156kB

HighMem: 48*4kB 6*8kB 0*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 496kB

Swap cache: add 12973, delete 12973, find 2677/3554, race 0+1

Free swap  = 0kB

Total swap = 8024kB

objdump invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c014cac0>] vma_prio_tree_insert+0x17/0x2a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  64   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  32

CPU    2: Hot: hi:  186, btch:  31 usd: 128   Cold: hi:   62, btch:  15 usd:  29

CPU    3: Hot: hi:  186, btch:  31 usd:  56   Cold: hi:   62, btch:  15 usd:  41

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  90   Cold: hi:   62, btch:  15 usd:  60

CPU    1: Hot: hi:  186, btch:  31 usd:  22   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  32

CPU    3: Hot: hi:  186, btch:  31 usd:  91   Cold: hi:   62, btch:  15 usd:  55

Active:180421 inactive:287302 dirty:0 writeback:0 unstable:0

 free:12182 slab:14570 mapped:42 pagetables:10552 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2512kB inactive:1684kB present:16224kB pages_scanned:172170 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40156kB min:3740kB low:4672kB high:5608kB active:358592kB inactive:358400kB present:892320kB pages_scanned:1156541 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:496kB min:512kB low:1736kB high:2960kB active:360580kB inactive:789124kB present:1167812kB pages_scanned:2688431 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 17*4kB 21*8kB 1*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40156kB

HighMem: 48*4kB 6*8kB 0*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 496kB

Swap cache: add 12973, delete 12973, find 2677/3554, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27480 (make) score 2014 or a child

Killed process 28228 (sh)

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

printk: 5 messages suppressed.

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee9f>] dput+0x98/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  64   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  32

CPU    2: Hot: hi:  186, btch:  31 usd: 128   Cold: hi:   62, btch:  15 usd:  29

CPU    3: Hot: hi:  186, btch:  31 usd:  58   Cold: hi:   62, btch:  15 usd:  41

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  90   Cold: hi:   62, btch:  15 usd:  60

CPU    1: Hot: hi:  186, btch:  31 usd:  22   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  32

CPU    3: Hot: hi:  186, btch:  31 usd:  91   Cold: hi:   62, btch:  15 usd:  55

Active:188236 inactive:279668 dirty:0 writeback:0 unstable:0

 free:12182 slab:14568 mapped:41 pagetables:10552 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2512kB inactive:1684kB present:16224kB pages_scanned:172170 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40156kB min:3740kB low:4672kB high:5608kB active:359180kB inactive:358300kB present:892320kB pages_scanned:1172564 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:496kB min:512kB low:1736kB high:2960kB active:391252kB inactive:758688kB present:1167812kB pages_scanned:2778262 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 17*4kB 21*8kB 1*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40156kB

HighMem: 48*4kB 6*8kB 0*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 496kB

Swap cache: add 12973, delete 12973, find 2677/3554, race 0+1

Free swap  = 0kB

Total swap = 8024k16kB

Swap cache: add 12973, delete 12973, find 2677/3554, race 0+1

Free swap  = 0kB

Total swap = 8024kB

printk: 21 messages suppressed.

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee9f>] dput+0x98/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  64   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  33

CPU    2: Hot: hi:  186, btch:  31 usd: 128   Cold: hi:   62, btch:  15 usd:  30

CPU    3: Hot: hi:  186, btch:  31 usd:  58   Cold: hi:   62, btch:  15 usd:  41

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  90   Cold: hi:   62, btch:  15 usd:  48

CPU    1: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  58

CPU    2: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  47

CPU    3: Hot: hi:  186, btch:  31 usd:  91   Cold: hi:   62, btch:  15 usd:  43

Active:236102 inactive:232931 dirty:0 writeback:0 unstable:0

 free:12181 slab:14568 mapped:46 pagetables:10552 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2524kB inactive:1672kB present:16224kB pages_scanned:172234 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40156kB min:3740kB low:4672kB high:5608kB active:357868kB inactive:361200kB present:892320kB pages_scanned:1566259 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:492kB min:512kB low:1736kB high:2960kB active:576900kB inactive:575804kB present:1167812kB pages_scanned:134254 all_unreclaimable? no

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 17*4kB 21*8kB 1*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40156kB

HighMem: 42*4kB 9*8kB 0*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 496kB

Swap cache: add 12973, delete 12973, find 2677/3554, race 0+1

Free swap  = 0kB

Total swap = 8024kB

printk: 63 messages suppressed.

objdump invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee9f>] dput+0x98/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  51   Cold: hi:   62, btch:  15 usd:  36

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  59

CPU    2: Hot: hi:  186, btch:  31 usd: 132   Cold: hi:   62, btch:  15 usd:  44

CPU    3: Hot: hi:  186, btch:  31 usd: 120   Cold: hi:   62, btch:  15 usd:  33

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 101   Cold: hi:   62, btch:  15 usd:  53

CPU    1: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  51

CPU    2: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  53

CPU    3: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:  47

Active:197824 inactive:266637 dirty:0 writeback:0 unstable:0

 free:12189 slab:14511 mapped:38 pagetables:10546 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2520kB inactive:1668kB present:16224kB pages_scanned:172554 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40184kB min:3740kB low:4672kB high:5608kB active:358348kB inactive:355128kB present:892320kB pages_scanned:3403799 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:496kB min:512kB low:1736kB high:2960kB active:430428kB inactive:709752kB present:1167812kB pages_scanned:12945889 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 22*4kB 22*8kB 1*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40184kB

HighMem: 42*4kB 9*8kB 0*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 496kB

Swap cache: add 12973, delete 12973, find 2677/3554, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27480 (make) score 1979 or a child

Killed process 28685 (sh)

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0168243>] may_open+0x4e/0x21a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c016001c>] do_filp_open+0x32/0x39

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  51   Cold: hi:   62, btch:  15 usd:  50

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  59

CPU    2: Hot: hi:  186, btch:  31 usd: 133   Cold: hi:   62, btch:  15 usd:  45

CPU    3: Hot: hi:  186, btch:  31 usd: 127   Cold: hi:   62, btch:  15 usd:  42

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 101   Cold: hi:   62, btch:  15 usd:  54

CPU    1: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  51

CPU    2: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  53

CPU    3: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:  47

Active:113124 inactive:353872 dirty:0 writeback:1 unstable:0

 free:12189 slab:14517 mapped:36 pagetables:10542 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2528kB inactive:1684kB present:16224kB pages_scanned:172554 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40184kB min:3740kB low:4672kB high:5608kB active:317352kB inactive:399464kB present:892320kB pages_scanned:4475641 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:496kB min:512kB low:1736kB high:2960kB active:60kB inactive:1148092kB present:1167812kB pages_scanned:15904903 all_unreclaimable? yes

Out of memory: kill process 27480 (make) score 1945 or a child

Killed process 28874 (sh)

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 22*4kB 22*8kB 1*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40184kB

HighMem: 42*4kB 9*8kB 0*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 496kB

Swap cache: add 12973, delete 12973, find 2677/3554, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27480 (make) score 1910 or a child

Out of memory: kill process 27480 (make) score 1910 or a child

Killed process 29006 (sh)

printk: 273 messages suppressed.

sh invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c01521d2>] vma_link+0xc1/0xcb

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c012819b>] sys_rt_sigprocmask+0xae/0xc1

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  60   Cold: hi:   62, btch:  15 usd:  51

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  59

CPU    2: Hot: hi:  186, btch:  31 usd: 183   Cold: hi:   62, btch:  15 usd:  46

CPU    3: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  43

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 101   Cold: hi:   62, btch:  15 usd:  54

CPU    1: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  51

CPU    2: Hot: hi:  186, btch:  31 usd: 105   Cold: hi:   62, btch:  15 usd:  53

CPU    3: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:  47

Active:114370 inactive:354255 dirty:0 writeback:0 unstable:0

 free:12189 slab:14469 mapped:35 pagetables:10536 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2528kB inactive:1668kB present:16224kB pages_scanned:172938 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40184kB min:3740kB low:4672kB high:5608kB active:335484kB inactive:383588kB present:892320kB pages_scanned:5133309 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:496kB min:512kB low:1736kB high:2960kB active:119468kB inactive:1031764kB present:1167812kB pages_scanned:17190043 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 22*4kB 22*8kB 1*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40184kB

HighMem: 42*4kB 9*8kB 0*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 496kB

Swap cache: add 12997, delete 12973, find 2677/3554, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Killed process 29006 (sh)

printk: 146 messages suppressed.

grep invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0168243>] may_open+0x4e/0x21a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c016001c>] do_filp_open+0x32/0x39

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  64   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  57

CPU    3: Hot: hi:  186, btch:  31 usd: 151   Cold: hi:   62, btch:  15 usd:  52

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 105   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd:  96   Cold: hi:   62, btch:  15 usd:  42

CPU    2: Hot: hi:  186, btch:  31 usd: 113   Cold: hi:   62, btch:  15 usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:  60

Active:324205 inactive:140135 dirty:0 writeback:0 unstable:0

 free:12186 slab:14425 mapped:31 pagetables:10516 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2544kB inactive:1668kB present:16224kB pages_scanned:174026 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40172kB min:3740kB low:4672kB high:5608kB active:353052kB inactive:352344kB present:892320kB pages_scanned:3287473 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:496kB min:512kB low:1736kB high:2960kB active:941224kB inactive:206528kB present:1167812kB pages_scanned:6320541 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 1*4kB 29*8kB 2*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40172kB

HighMem: 30*4kB 11*8kB 2*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 496kB

Swap cache: add 12997, delete 12997, find 2677/3555, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27480 (make) score 1876 or a child

Killed process 29011 (sh)

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c014f15f>] unmap_vmas+0x103/0x1cf

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  64   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  57

CPU    3: Hot: hi:  186, btch:  31 usd: 151   Cold: hi:   62, btch:  15 usd:  52

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 105   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd:  96   Cold: hi:   62, btch:  15 usd:  42

CPU    2: Hot: hi:  186, btch:  31 usd: 113   Cold: hi:   62, btch:  15 usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:  60

Active:324205 inactive:140135 dirty:0 writeback:0 unstable:0

 free:12186 slab:14425 mapped:31 pagetables:10516 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2544kB inactive:1668kB present:16224kB pages_scanned:174026 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40172kB min:3740kB low:4672kB high:5608kB active:353052kB inactive:352344kB present:892320kB pages_scanned:3302545 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:496kB min:512kB low:1736kB high:2960kB active:941224kB inactive:206656kB present:1167812kB pages_scanned:6330237 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 1*4kB 29*8kB 2*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40172kB

HighMem: 30*4kB 11*8kB 2*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 496kB

Swap cache: add 12997, delete 12997, find 2677/3555, race 0+1

Free swap  = 0kB

Total swap = 8024kB

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<f884dc82>] do_get_write_access+0x49d/0x4bc [jbd]

 [<c017cab0>] bh_lru_install+0x98/0xa0

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016b255>] filldir64+0x0/0xc5

 [<c0332d4e>] __mutex_unlock_slowpath+0x26/0x2f

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  64   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  57

CPU    3: Hot: hi:  186, btch:  31 usd: 151   Cold: hi:   62, btch:  15 usd:  52

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 105   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd:  96   Cold: hi:   62, btch:  15 usd:  42

CPU    2: Hot: hi:  186, btch:  31 usd: 113   Cold: hi:   62, btch:  15 usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:  60

Active:324204 inactive:140136 dirty:0 writeback:0 unstable:0

 free:12186 slab:14425 mapped:31 pagetables:10516 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2544kB inactive:1668kB present:16224kB pages_scanned:174026 all_unreclaimable? i:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  64   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  57

CPU    3: Hot: hi:  186, btch:  31 usd: 151   Cold: hi:   62, btch:  15 usd:  52

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 105   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd:  96   Cold: hi:   62, btch:  15 usd:  42

CPU    2: Hot: hi:  186, btch:  31 usd: 113   Cold: hi:   62, btch:  15 usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:  60

Active:328309 inactive:136095 dirty:0 writeback:0 unstable:0

 free:12186 slab:14425 mapped:31 pagetables:10516 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2544kB inactive:1668kB present:16224kB pages_scanned:174026 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40172kB min:3740kB low:4672kB high:5608kB active:355116kB inactive:350364kB present:892320kB pages_scanned:3326240 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:496kB min:512kB low:1736kB high:2960kB active:955576kB inactive:192348kB present:1167812kB pages_scanned:6350308 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 1*4kB 29*8kB 2*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40172kB

HighMem: 30*4kB 11*8kB 2*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 496kB

Swap cache: add 12997, delete 12997, find 2677/3555, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0160d64>] sys_read+0x41/0x67

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  64   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 1
 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  64   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  57

CPU    3: Hot: hi:  186, btch:  31 usd: 151   Cold: hi:   62, btch:  15 usd:  52

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 105   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd:  96   Cold: hi:   62, btch:  15 usd:  42

CPU    2: Hot: hi:  186, btch:  31 usd: 113   Cold: hi:   62, btch:  15 usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:  60

Active:328309 inactive:136095 dirty:0 writeback:0 unstable:0

 free:12186 slab:14425 mapped:31 pagetables:10516 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2544kB inactive:1668kB present:16224kB pages_scanned:174026 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40172kB min:3740kB low:4672kB high:5608kB active:355116kB inactive:350364kB present:892320kB pages_scanned:3326240 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:496kB min:512kB low:1736kB high:2960kB active:955576kB inactive:192476kB present:1167812kB pages_scanned:6382884 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 1*4kB 29*8kB 2*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40172kB

HighMem: 30*4kB 11*8kB 2*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 496kB

Swap cache: add 12997, delete 12997, find 2677/3555, race 0+1

Free swap  = 0kB

Total swap = 8024kB

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<f884dc82>] do_get_write_access+0x49d/0x4bc [jbd]

 [<c0332ba9>] out_of_line_wait_on_bit+0x6f/0x77

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016b255>] filldir64+0x0/0xc5

 [<c0332d4e>] __mutex_unlock_slowpath+0x26/0x2f

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, page_referenced+0x2f/0x68

 [<c014bc84>] shrink_active_list+0x16a/0x3c5

 [<c014bf90>] shrink_zone+0xb1/0xed

 [<c014c039>] shrink_zones+0x6d/0x89

 [<c014c136>] try_to_free_pages+0xe1/0x1c1

 [<c0148447>] __alloc_pages+0x19e/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0160d64>] sys_read+0x41/0x67

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

BUG: soft lockup detected on CPU#2!

 [<c0141387>] softlockup_tick+0xa2/0xb3

 [<c0125ca0>] update_process_times+0x3b/0x5e

 [<c0133200>] tick_periodic+0x63/0x6d

 [<c0133220>] tick_handle_periodic+0x16/0x65

 [<c0110caa>] local_apic_timer_interrupt+0x4c/0x50

 [<c0110cd0>] smp_apic_timer_interrupt+0x22/0x30

 [<c0103b70>] apic_timer_interrupt+0x28/0x30

 [<c01d007b>] vsnprintf+0xb2/0x4d3

 [<c01d2638>] __spin_lock_debug+0x35/0xa9

 [<c01d26ff>] _raw_spin_lock+0x53/0x67

 [<c0154f30>] page_lock_anon_vma+0x19/0x21

 [<c0155153>] page_referenced_anon+0xe/0x5d

 [<c015526a>] page_referenced+0x2f/0x68

 [<c014bc84>] shrink_active_list+0x16a/0x3c5

 [<c014bf90>] shrink_zone+0xb1/0xed

 [<c014c039>] shrink_zones+0x6d/0x89

 [<c014c136>] try_to_free_pages+0xe1/0x1c1

 [<c0148447>] __alloc_pages+0x19e/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0160d64>] sys_read+0x41/0x67

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

BUG: soft lockup detected on CPU#3!

 [<c0141387>] softlockup_tick+0xa2/0xb3

 [<c0125ca0>] update_process_times+0x3b/0x5e

 [<c0133200>] tick_periodic+0x63/0x6d

 [<c0133220>] tick_handle_periodic+0x16/0x65

 [<c0110caa>] local_apic_timer_interrupt+0x4c/0x50

 [<c0110cd0>] smp_apic_timer_interrupt+0x22/0x30

 [<c0103b70>] apic_timer_interrupt+0x28/0x30

 [<c01d0d6d>] delay_tsc+0x9/0x13

 [<c01d0da0>] __delay+0x6/0x7

 [<c01d2646>] __spin_lock_debug+0x43/0xa9

 [<c01d26ff>] _raw_spin_lock+0x53/0x67

 [<c0154f30>] page_lock_anon_vma+0x19/0x21

 [<c0155153>] page_referenced_anon+0xe/0x5d

 [<c015526a>] page_referenced+0x2f/0x68

 [<c014b5b3>] shrink_page_list+0xc2/0x336

 [<c01d0da0>] __delay+0x6/0x7

 [<c01d2646>] __spin_lock_debug+0x43/0xa9

 [<c014b972>] shrink_inactive_list+0xa6/0x24e

 [<c014bfa7>] shrink_zone+0xc8/0xed

 [<c014c039>] shrink_zones+0x6d/0x89

 [<c014c136>] try_to_free_pages+0xe1/0x1c1

 [<c0148447>] __alloc_pages+0x19e/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

ap = 8024kB

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016395f>] sys_stat64+0x1e/0x23

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  69   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  57

CPU    3: Hot: hi:  186, btch:  31 usd: 151   Cold: hi:   62, btch:  15 usd:  52

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 105   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd:  96   Cold: hi:   62, btch:  15 usd:  42

CPU    2: Hot: hi:  186, btch:  31 usd: 113   Cold: hi:   62, btch:  15 usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:  60

Active:350050 inactive:115055 dirty:0 writeback:0 unstable:0

 free:12186 slab:14420 mapped:31 pagetables:10516 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2544kB inactive:1668kB present:16224kB pages_scanned:174026 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40172kB min:3740kB low:4672kB high:5608kB active:353848kB inactive:352136kB present:892320kB pages_scanned:3439427 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:496kB min:512kB low:1736kB high:2960kB active:1043808kB inactive:106416kB present:1167812kB pages_scanned:6788695 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 1*4kB 26*8kB 2*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40148kB

HighMem: 30*4kB 11*8kB 2*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 496kB

Swap cache: add 12997, delete 12997, find 2677/3555, race 0+1

Free swap  = 0kB

Total swap = 8024kB

sh invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c01521d2>] vma_link+0xc1/0xcb

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  69   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  57

CPU    3: Hot: hi:  186, btch:  31 usd: 151   Cold: hi:   62, btch:  15 usd:  52

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 105   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd:  96   Cold: hi:   62, btch:  15 usd:  42

CPU    2: Hot: hi:  186, btch:  31 usd: 113   Cold: hi:   62, btch:  15 usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:  60

Active:377277 inactive:88433 dirty:0 writeback:0 unstable:0

 free:12180 slab:14426 mapped:31 pagetables:10516 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2544kB inactive:1668kB present:16224kB pages_scanned:174026 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40148kB min:3740kB low:4672kB high:5608kB active:354180kB inactive:351996kB present:892320kB pages_scanned:3452871 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:496kB min:512kB low:1736kB high:2960kB active:1152384kB inactive:68kB present:1167812kB pages_scanned:7351918 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 1*4kB 26*8kB 2*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40148kB

HighMem: 30*4kB 11*8kB 2*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 496kB

Swap cache: add 12997, delete 12997, find 2677/3555, race 0+1

Free swap  = 0kB

Total swap = 8024kB

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  69   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  57

CPU    3: Hot: hi:  186, btch:  31 usd: 151   Cold: hi:   62, btch:  15 usd:  52

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 105   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd:  96   Cold: hi:   62, btch:  15 usd:  42

CPU    2: Hot: hi:  186, btch:  31 usd: 113   Cold: hi:   62, btch:  15 usd:  51

CPU    3: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:  60

Active:226203 inactive:240601 dirty:0 writeback:0 unstable:0

 free:12180 slab:14426 mapped:32 pagetables:10516 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2544kB inactive:1668kB present:16224kB pages_scanned:174026 all_unreclaimaprintk: 252 messages suppressed.

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0160d64>] sys_read+0x41/0x67

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  69   Cold: hi:   62, btch:  15 usd:  50

CPU    1: Hot: hi:  186, btch:  31 usd: 177   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 149   Cold: hi:   62, btch:  15 usd:  60

CPU    3: Hot: hi:  186, btch:  31 usd: 179   Cold: hi:   62, btch:  15 usd:  52

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 105   Cold: hi:   62, btch:  15 usd:  58

CPU    1: Hot: hi:  186, btch:  31 usd:  96   Cold: hi:   62, btch:  15 usd:  18

CPU    2: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:  50

CPU    3: Hot: hi:  186, btch:  31 usd: 183   Cold: hi:   62, btch:  15 usd:  59

Active:178947 inactive:286628 dirty:0 writeback:0 unstable:0

 free:12182 slab:14399 mapped:33 pagetables:10504 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2676kB inactive:1520kB present:16224kB pages_scanned:174890 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40208kB min:3740kB low:4672kB high:5608kB active:355344kB inactive:361384kB present:892320kB pages_scanned:1964821 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:444kB min:512kB low:1736kB high:2960kB active:357768kB inactive:783608kB present:1167812kB pages_scanned:2084885 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 16*4kB 26*8kB 2*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40208kB

HighMem: 31*4kB 17*8kB 3*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 564kB

Swap cache: add 12997, delete 12997, find 2677/3555, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27480 (make) score 1807 or a child

Killed process 29017 (sh)

cc1 invoked oom-killer: gfp_mask=0x280d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0150a47>] do_anonymous_page+0x3e/0x1e3

Out of memory: kill process 27480 (make) score 1772 or a child

Killed process 29019 (sh)

 [<c0151251>] __handle_mm_fault+0x1a1/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee9f>] dput+0x98/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  67   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd: 177   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 161   Cold: hi:   62, btch:  15 usd:  60

CPU    3: Hot: hi:  186, btch:  31 usd: 179   Cold: hi:   62, btch:  15 usd:  52

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 105   Cold: hi:   62, btch:  15 usd:  29

CPU    1: Hot: hi:  186, btch:  31 usd:  97   Cold: hi:   62, btch:  15 usd:  12

CPU    2: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  16

CPU    3: Hot: hi:  186, btch:  31 usd: 183   Cold: hi:   62, btch:  15 usd:  59

Active:346643 inactive:119697 dirty:0 writeback:0 unstable:0

 free:12381 slab:14401 mapped:33 pagetables:10492 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2564kB inactive:1648kB present:16224kB pages_scanned:174922 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40208kB min:3740kB low:4672kB high:5608kB active:349352kB inactive:368572kB present:892320kB pages_scanned:2999346 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:1240kB min:512kB low:1736kB high:2960kB active:164560kB inactive:978468kB present:1167812kB pages_scanned:1041090 all_unreclaimable? no

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 16*4kB 26*8kB 2*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40208kB

HighMem: 171*4kB 24*8kB 3*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1180kB

Swap cache: add 12997, delete 12997, find 2677/3555, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27480 (make) score 1738 or a child

Killed process 29021 (sh)

printk: 5 messages suppressed.

cc1 invoked oom-killer: gfp_mask=0x280d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0150a47>] do_anonymous_page+0x3e/0x1e3

 [<c0151251>] __handle_mm_fault+0x1a1/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  63   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd: 167   Cold: hi:   62, btch:  15 usd:  16

CPU    2: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  61

CPU    3: Hot: hi:  186, btch:  31 usd: 179   Cold: hi:   62, btch:  15 usd:  53

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 104   Cold: hi:   62, btch:  15 usd:  16

CPU    1: Hot: hi:  186, btch:  31 usd:  95   Cold: hi:   62, btch:  15 usd:  56

CPU    2: Hot: hi:  186, btch:  31 usd: 185   Cold: hi:   62, btch:  15 usd:  55

CPU    3: Hot: hi:  186, btch:  31 usd: 180   Cold: hi:   62, btch:  15 usd:  40

Active:239538 inactive:226839 dirty:0 writeback:0 unstable:0

 free:12369 slab:14384 mapped:37 pagetables:10486 bounce:0

DMA free:8076kB min:68kB low:84kB high:100kB active:2564kB inactive:1648kB present:16224kB pages_scanned:174922 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40332kB min:3740kB low:4672kB high:5608kB active:343120kB inactive:373424kB present:892320kB pages_scanned:1617263 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:1068kB min:512kB low:1736kB high:2960kB active:656756kB inactive:487112kB present:1167812kB pages_scanned:151776 all_unreclaimable? no

lowmem_reserve[]: 0 0 0

DMA: 1*4kB 1*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB

Normal: 43*4kB 28*8kB 2*16kB 1*32kB 1*64kB 33*128kB 7*256kB 0*512kB 1*1024kB 0*2048kB 8*4096kB = 40332kB

HighMem: 153*4kB 27*8kB 3*16kB 6*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1132kB

Swap cache: add 12997, delete 12997, find 2677/3555, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27480 (make) score 1704 or a child

Killed process 29023 (sh)

-- 0:conmux-control -- time-stamp -- Aug/22/07 12:59:03 --
printk: 2 messages suppressed.

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

sh invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0128b69>] sys_rt_sigaction+0x73/0x88

 [<c0120e2c>] sys_waitpid+0x27/0x2b

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:   4   Cold: hi:   62, btch:  15 usd:  53

CPU    1: Hot: hi:  186, btch:  31 usd: 119   Cold: hi:   62, btch:  15 usd:  49

CPU    2: Hot: hi:  186, btch:  31 usd:   9   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 146   Cold: hi:   62, btch:  15 usd:  18

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  53

CPU    1: Hot: hi:  186, btch:  31 usd:   2   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  53

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  56

Active:231903 inactive:231595 dirty:0 writeback:0 unstable:0

 free:12187 slab:20552 mapped:14 pagetables:15267 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2616kB inactive:1568kB present:16224kB pages_scanned:6953 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40160kB min:3740kB low:4672kB high:5608kB active:341460kB inactive:341268kB present:892320kB pages_scanned:1312337 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:484kB min:512kB low:1736kB high:2960kB active:583536kB inactive:583544kB present:1167812kB pages_scanned:1990481 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 7*4kB 4*8kB 1*16kB 0*32kB 2*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40140kB

HighMem: 60*4kB 16*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 544kB

Swap cache: add 15781, delete 15781, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

as invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0168243>] may_open+0x4e/0x21a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c016001c>] do_filp_open+0x32/0x39

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:   4   Cold: hi:   62, btch:  15 usd:  53

CPU    1: Hot: hi:  186, btch:  31 usd: 119   Cold: hi:   62, btch:  15 usd:  49

CPU    2: Hot: hi:  186, btch:  31 usd:   9   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 146   Cold: hi:   62, btch:  15 usd:  18

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  53

CPU    1: Hot: hi:  186, btch:  31 usd:   2   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  53

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  56

Active:230659 inactive:232843 dirty:0 writeback:0 unstable:0

 free:12187 slab:20552 mapped:14 pagetables:15267 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2616kB inactive:1568kB present:16224kB pages_scanned:6953 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40160kB min:3740kB low:4672kB high:5608kB active:341460kB inactive:341268kB present:892320kB pages_scanned:1312337 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:484kB min:512kB low:1736kB high:2960kB active:578560kB inactive:588536kB present:1167812kB pages_scanned:1997848 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 7*4kB 4*8kB 1*16kB 0*32kB 2*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40140kB

HighMem: 60*4kB 16*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 544kB

Swap cache: add 15781, delete 15781, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1978 or a child

Killed process 28323 (sh)

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:   4   Cold: hi:   62, btch:  15 usd:  53

CPU    1: Hot: hi:  186, btch:  31 usd: 119   Cold: hi:   62, btch:  15 usd:  49

CPU    2: Hot: hi:  186, btch:  31 usd:   9   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 146   Cold: hi:   62, btch:  15 usd:  18

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  53

CPU    1: Hot: hi:  186, btch:  31 usd:   2   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  53

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  56

Active:230659 inactive:232843 dirty:0 writeback:0 unstable:0

 free:12187 slab:20552 mapped:14 pagetables:15267 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2616kB inactive:1568kB present:16224kB pages_scanned:6953 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40160kB min:3740kB low:4672kB high:5608kB active:341460kB inactive:341268kB present:892320kB pages_scanned:1312337 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:484kB min:512kB low:1736kB high:2960kB active:578560kB inactive:588536kB present:1167812kB pages_scanned:2003960 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 7*4kB 4*8kB 1*16kB 0*32kB 2*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40140kB

HighMem: 60*4kB 16*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 544kB

Swap cache: add 15781, delete c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:   4   Cold: hi:   62, btch:  15 usd:  53

CPU    1: Hot: hi:  186, btch:  31 usd: 119   Cold: hi:   62, btch:  15 usd:  49

CPU    2: Hot: hi:  186, btch:  31 usd:   9   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 146   Cold: hi:   62, btch:  15 usd:  18

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  53

CPU    1: Hot: hi:  186, btch:  31 usd:   2   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  53

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  56

Active:230659 inactive:232873 dirty:0 writeback:0 unstable:0

 free:12187 slab:20552 mapped:14 pagetables:15267 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2616kB inactive:1568kB present:16224kB pages_scanned:6953 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40160kB min:3740kB low:4672kB high:5608kB active:341460kB inactive:341276kB present:892320kB pages_scanned:1318065 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:484kB min:512kB low:1736kB high:2960kB active:578560kB inactive:588536kB present:1167812kB pages_scanned:2011064 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 7*4kB 4*8kB 1*16kB 0*32kB 2*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40140kB

HighMem: 60*4kB 16*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 544kB

Swap cache: add 15781, delete 15781, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0152734>] vma_merge+0x176/0x184

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:   4   Cold: hi:   62, btch:  15 usd:  53

CPU    1: Hot: hi:  186, btch:  31 usd: 119   Cold: hi:   62, btch:  15 usd:  49

CPU    2: Hot: hi:  186, btch:  31 usd:   9   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 146   Cold: hi:   62, btch:  15 usd:  18

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  53

CPU    1: Hot: hi:  186, btch:  31 usd:   2   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  53

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  56

Active:230544 inactive:232975 dirty:0 writeback:0 unstable:0

 free:12187 slab:20552 mapped:14 pagetables:15267 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2616kB inactive:1568kB present:16224kB pages_scanned:6953 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40160kB min:3740kB low:4672kB high:5608kB active:341460kB inactive:341280kB present:892320kB pages_scanned:1323314 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:484kB min:512kB low:1736kB high:2960kB active:578100kB inactive:589052kB present:1167812kB pages_scanned:2016913 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 7*4kB 4*8kB 1*16kB 0*32kB 2*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40140kB

HighMem: 60*4kB 16*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 544kB

Swap cache: add 15781, delete 15781, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:   4   Cold: hi:   62, btch:  15 usd:  53

CPU    1: Hot: hi:  186, btch:  31 usd: 119   Cold: hi:   62, btch:  15 usd:  49

CPU    2: Hot: hi:  186, btch:  31 usd:   9   Cold: hi: 8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c01521d2>] vma_link+0xc1/0xcb

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:   4   Cold: hi:   62, btch:  15 usd:  53

CPU    1: Hot: hi:  186, btch:  31 usd: 119   Cold: hi:   62, btch:  15 usd:  49

CPU    2: Hot: hi:  186, btch:  31 usd:   9   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 146   Cold: hi:   62, btch:  15 usd:  18

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  53

CPU    1: Hot: hi:  186, btch:  31 usd:   2   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  53

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  56

Active:230544 inactive:232975 dirty:0 writeback:0 unstable:0

 free:12187 slab:20552 mapped:14 pagetables:15267 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2616kB inactive:1568kB present:16224kB pages_scanned:6953 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40160kB min:3740kB low:4672kB high:5608kB active:341460kB inactive:341280kB present:892320kB pages_scanned:1323314 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:484kB min:512kB low:1736kB high:2960kB active:578100kB inactive:589052kB present:1167812kB pages_scanned:2016913 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 7*4kB 4*8kB 1*16kB 0*32kB 2*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40140kB

HighMem: 60*4kB 16*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 544kB

Swap cache: add 15781, delete 15781, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

as invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c016001c>] do_filp_open+0x32/0x39

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: H[<c0144d78>] file_read_actor+0x47/0xf1

 [<c0144a78>] do_generic_mapping_read+0x174/0x42d

 [<c01d0fc0>] strncpy_from_user+0x37/0x56

 [<c0144fc1>] generic_file_aio_read+0x19f/0x1c3

 [<c0144d31>] file_read_actor+0x0/0xf1

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c0151251>] __handle_mm_fault+0x1a1/0x2bc

 [<c012e872>] autoremove_wake_function+0x0/0x33

 [<c0115a01>] do_page_fault+0x314/0x5f7

 [<c01639a5>] sys_fstat64+0x1e/0x23

 [<c0160a74>] vfs_read+0xb1/0x131

 [<c0160d64>] sys_read+0x41/0x67

 [<c01030a4>] sysenter_past_esp+0x5d/0x81

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:   6   Cold: hi:   62, btch:  15 usd:  55

CPU    1: Hot: hi:  186, btch:  31 usd: 127   Cold: hi:   62, btch:  15 usd:  51

CPU    2: Hot: hi:  186, btch:  31 usd:   9   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 146   Cold: hi:   62, btch:  15 usd:  14

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  22   Cold: hi:   62, btch:  15 usd:  26

CPU    1: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  53

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  27

Active:268762 inactive:196946 dirty:0 writeback:0 unstable:0

 free:12157 slab:20539 mapped:0 pagetables:15267 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2632kB inactive:1528kB present:16224kB pages_scanned:21417 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40160kB min:3740kB low:4672kB high:5608kB active:422668kB inactive:262068kB present:892320kB pages_scanned:2762829 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:364kB min:512kB low:1736kB high:2960kB active:649748kB inactive:524188kB present:1167812kB pages_scanned:4581246 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 5*4kB 5*8kB 1*16kB 0*32kB 2*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40140kB

HighMem: 15*4kB 16*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 364kB

Swap cache: add 15781, delete 15781, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

printk: 10971 messages suppressed.

make invoked oom-killer: gfp_mask=0x280d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0150a47>] do_anonymous_page+0x3e/0x1e3

 [<f888a54c>] ext3_mark_inode_dirty+0x33/0x3a [ext3]

 [<c0151251>] __handle_mm_fault+0x1a1/0x2bc

 [<c0178bf4>] __mark_inode_dirty+0xec/0x180

 [<c0115990>f_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0150a47>] do_anonymous_page+0x3e/0x1e3

 [<c0151251>] __handle_mm_fault+0x1a1/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01220c4>] tasklet_action+0x52/0xa2

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:   6   Cold: hi:   62, btch:  15 usd:  55

CPU    1: Hot: hi:  186, btch:  31 usd: 138   Cold: hi:   62, btch:  15 usd:  51

CPU    2: Hot: hi:  186, btch:  31 usd:   9   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 149   Cold: hi:   62, btch:  15 usd:  14

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  22   Cold: hi:   62, btch:  15 usd:  26

CPU    1: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  53

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  27

Active:268536 inactive:197049 dirty:0 writeback:0 unstable:0

 free:12157 slab:20525 mapped:0 pagetables:15267 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2648kB inactive:1496kB present:16224kB pages_scanned:75881 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40160kB min:3740kB low:4672kB high:5608kB active:421828kB inactive:262272kB present:892320kB pages_scanned:4179789 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:364kB min:512kB low:1736kB high:2960kB active:649668kB inactive:524428kB present:1167812kB pages_scanned:6764710 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 5*4kB 5*8kB 1*16kB 0*32kB 2*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40140kB

HighMem: 15*4kB 16*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 364kB

Swap cache: add 15781, delete 15781, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0264876>] scsi_finish_command+0x84/0x8b

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0105401>] do_IRQ+0x80/0x93

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi1024kB 0*2048kB 0*4096kB = 364kB

Swap cache: add 15782, delete 15782, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1909 or a child

Killed process 28342 (sh)

printk: 5886 messages suppressed.

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014a098>] blockable_page_cache_readahead+0x4a/0x9a

 [<c014a21a>] page_cache_readahead+0x8f/0x159

 [<c0144a29>] do_generic_mapping_read+0x125/0x42d

 [<c01d0fc0>] strncpy_from_user+0x37/0x56

 [<c0144fc1>] generic_file_aio_read+0x19f/0x1c3

 [<c0144d31>] file_read_actor+0x0/0xf1

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c012e872>] autoremove_wake_function+0x0/0x33

 [<c01639a5>] sys_fstat64+0x1e/0x23

 [<c0160a74>] vfs_read+0xb1/0x131

 [<c0160d64>] sys_read+0x41/0x67

 [<c01030a4>] sysenter_past_esp+0x5d/0x81

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  19   Cold: hi:   62, btch:  15 usd:  54

CPU    1: Hot: hi:  186, btch:  31 usd: 177   Cold: hi:   62, btch:  15 usd:  47

CPU    2: Hot: hi:  186, btch:  31 usd:   9   Cold: hi:   62, btch:  15 usd:  16

CPU    3: Hot: hi:  186, btch:  31 usd: 153   Cold: hi:   62, btch:  15 usd:   0

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  28

CPU    1: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  19

CPU    2: Hot: hi:  186, btch:  31 usd:  34   Cold: hi:   62, btch:  15 usd:   6

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  35

Active:231225 inactive:230422 dirty:0 writeback:0 unstable:0

 free:12382 slab:20494 mapped:12 pagetables:15248 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2656kB inactive:1528kB present:16224kB pages_scanned:88105 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40588kB min:3740kB low:4672kB high:5608kB active:341212kB inactive:340204kB present:892320kB pages_scanned:394815 all_unreclaimable? no

lowmem_reserve[]: 0 0 9123

HighMem free:836kB min:512kB low:1736kB high:2960kB active:580252kB inactive:580828kB present:1167812kB pages_scanned:883480 all_unreclaimable? no

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 149*4kB 5*8kB 0*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40668kB

HighMem: 64*4kB 21*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 600kB

Swap cache: add 15783, delete 15783, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1875 or a child

Killed process 28343 (sh)

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee9f>] dput+0x98/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  64   Cold: hi:   62, btch:  15 usd:  56

CPU    1: Hot: hi:  186, btch:  31 usd: 178   Cold: hi:   62, btch:  15 usd:  47

CPU    2: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  29

CPU    3: Hot: hi:  186, btch:  31 usd: 140   Cold: hi:   62, btch:  15 usd:  60

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  32

CPU    2: Hot: hi:  186, btch:  31 usd:  35   Cold: hi:   62, btch:  15 usd:  56

CPU    3: Hot: hi:  186, btch:  31 usd: 154   Cold: hi:   62, btch:  15 usd:  34

Active:230186 inactive:230180 dirty:0 writeback:0 unstable:0

 free:12194 slab:20440 mapped:25 pagetables:15239 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2664kB inactive:1504kB present:16224kB pages_scanned:88617 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40192kB min:3740kB low:4672kB high:5608kB active:339744kB inactive:339960kB present:892320kB pages_scanned:2014791 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:480kB min:512kB low:1736kB high:2960kB active:578336kB inactive:579256kB present:1167812kB pages_scanned:2091314 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 22*8kB 1*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40192kB

HighMem: 24*4kB 26*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB

Swap cache: add 15783, delete 15783, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1841 or a child

Killed process 28345 (sh)

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee9f>] dput+0x98/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  64   Cold: hi:   62, btch:  15 usd:  56

CPU    1: Hot: hi:  186, btch:  31 usd: 178   Cold: hi:   62, btch:  15 usd:  47

CPU    2: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  29

CPU    3: Hot: hi:  186, btch:  31 usd: 140   Cold: hi:   62, btch:  15 usd:  60

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  32

CPU    2: Hot: hi:  186, btch:  31 usd:  35   Cold: hi:   62, btch:  15 usd:  56

CPU    3: Hot: hi:  186, btch:  31 usd: 154   Cold: hi:   62, btch:  15 usd:  34

Active:230186 inactive:230180 dirty:0 writeback:0 unstable:0

 free:12194 slab:20440 mapped:25 pagetables:15239 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2664kB inactive:1504kB present:16224kB pages_scanned:88617 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40192kB min:3740kB low:4672kB high:5608kB active:339744kB inactive:339960kB present:892320kB pages_scanned:2014791 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:480kB min:512kB low:1736kB high:2960kB active:578336kB inactive:579256kB present:1167812kB pages_scanned:2109490 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 22*8kB 1*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40192kB

HighMem: 24*4kB 26*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB

Swap cache: add 15783, delete 15783, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4asd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  64   Cold: hi:   62, btch:  15 usd:  56

CPU    1: Hot: hi:  186, btch:  31 usd: 178   Cold: hi:   62, btch:  15 usd:  47

CPU    2: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  29

CPU    3: Hot: hi:  186, btch:  31 usd: 140   Cold: hi:   62, btch:  15 usd:  60

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  32

CPU    2: Hot: hi:  186, btch:  31 usd:  35   Cold: hi:   62, btch:  15 usd:  56

CPU    3: Hot: hi:  186, btch:  31 usd: 154   Cold: hi:   62, btch:  15 usd:  34

Active:230186 inactive:230180 dirty:0 writeback:0 unstable:0

 free:12194 slab:20440 mapped:25 pagetables:15239 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2664kB inactive:1504kB present:16224kB pages_scanned:88617 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40192kB min:3740kB low:4672kB high:5608kB active:339744kB inactive:339960kB present:892320kB pages_scanned:2014791 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:480kB min:512kB low:1736kB high:2960kB active:578336kB inactive:579256kB present:1167812kB pages_scanned:2153586 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 22*8kB 1*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40192kB

HighMem: 24*4kB 26*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB

Swap cache: add 15783, delete 15783, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

as invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0167c5e>] do_path_lookup+0x17a/0x1c3

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0163950>] sys_stat64+0xf/0x23

 [<c015203a>] sys_brk+0xc9/0xd0

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  64   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd: 178   Cold: hi:   62, btch:  15 usd:  47

CPU    2: Hot: hi:  186, 2, btch:  15 usd:  34

Active:230702 inactive:229933 dirty:0 writeback:0 unstable:0

 free:12194 slab:20440 mapped:25 pagetables:15239 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2664kB inactive:1504kB present:16224kB pages_scanned:88617 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40192kB min:3740kB low:4672kB high:5608kB active:338996kB inactive:341188kB present:892320kB pages_scanned:2150156 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:480kB min:512kB low:1736kB high:2960kB active:581148kB inactive:577040kB present:1167812kB pages_scanned:2369597 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 22*8kB 1*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40192kB

HighMem: 24*4kB 26*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB

Swap cache: add 15783, delete 15783, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1806 or a child

Killed process 28347 (sh)

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0160d64>] sys_read+0x41/0x67

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 130   Cold: hi:   62, btch:  15 usd:  15

CPU    1: Hot: hi:  186, btch:  31 usd: 178   Cold: hi:   62, btch:  15 usd:  47

CPU    2: Hot: hi:  186, btch:  31 usd:  69   Cold: hi:   62, btch:  15 usd:  18

CPU    3: Hot: hi:  186, btch:  31 usd: 139   Cold: hi:   62, btch:  15 usd:  56

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  34   Cold: hi:   62, btch:  15 usd:  34

CPU    1: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  32

CPU    2: Hot: hi:  186, btch:  31 usd:  36   Cold: hi:   62, btch:  15 usd:  51

CPU    3: Hot: hi:  186, btch:  31 usd: 153   Cold: hi:   62, btch:  15 usd:  43

Active:232109 inactive:228208 dirty:0 writeback:0 unstable:0

 free:12164 slab:20406 mapped:7 pagetables:15233 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2664kB inactive:1504kB present:16224kB pages_scanned:88745 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40192kB min:3740kB low:4672kB high:5608kB active:346028kB inactive:33_reserve[]: 0 871 2011

Normal free:40192kB min:3740kB low:4672kB high:5608kB active:346028kB inactive:334240kB present:892320kB pages_scanned:1201140 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:360kB min:512kB low:1736kB high:2960kB active:579316kB inactive:576572kB present:1167812kB pages_scanned:2023759 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 22*8kB 1*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40192kB

HighMem: 22*4kB 27*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB

Swap cache: add 15783, delete 15783, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Swap cache: add 15783, delete 15783, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

printk: 96 messages suppressed.

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] <4>as invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0168243>] may_open+0x4e/0x21a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c016001c>] do_filp_open+0x32/0x39

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 125   Cold: hi:   62, btch:  15 usd:  61

CPU    1: Hot: hi:  186, btch:  31 usd: 158   Cold: hi:   62, btch:  15 usd:  50

CPU    2: Hot: hi:  186, btch:  31 usd:  75   Cold: hi:   62, btch:  15 usd:  44

CPU    3: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  60

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  33   Cold: hi:   62, btch:  15 usd:  12

CPU    1: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  53

CPU    2: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  19

CPU    3: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:  53

Active:221846 inactive:236737 dirty:1 writeback:0 unstable:0

 free:12287 slab:20389 mapped:5 pagetables:15228 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2672kB inactive:1512kB present:16224kB pages_scanned:89129 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40504kB min:3740kB low:4672kB high:5608kB active:345452kB inactive:327348kB present:892320kB pages_scanned:1535671 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:540kB min:512kB low:1736kB high:2960kB active:539260kB inactive:618088kB present:1167812kB pages_scanned:1852142 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 8*4kB 29*8kB 9*16kB 1*32kB 2*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40504kB

HighMem: 45*4kB 23*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 540kB

Swap cache: add 15783, delete 15783, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1772 or a child

Killed process 28349 (sh)

__alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee9f>] dput+0x98/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 123   Cold: hi:   62, btch:  15 usd:  50

CPU    1: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  53

CPU    2: Hot: hi:  186, btch:  31 usd:  75   Cold: hi:   62, btch:  15 usd:  44

CPU    3: Hot: hi:  186, btch:  31 usd: 146   Cold: hi:   62, btch:  15 usd:  48

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:   3

CPU    1: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  19

CPU    3: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:   9

Active:222213 inactive:237442 dirty:1 writeback:0 unstable:0

 free:12372 slab:20378 mapped:5 pagetables:15228 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2672kB inactive:1512kB present:16224kB pages_scanned:89129 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40928kB min:3740kB low:4672kB high:5608kB active:338908kB inactive:333804kB present:892320kB pages_scanned:392594 all_unreclaimable? no

lowmem_reserve[]: 0 0 9123

HighMem free:360kB min:512kB low:1736kB high:2960kB active:541228kB inactive:620660kB present:1167812kB pages_scanned:3942719 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 112*4kB 30*8kB 9*16kB 1*32kB 2*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40928kB

HighMem: 0*4kB 23*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 360kB

Swap cache: add 15783, delete 15783, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1737 or a child

Killed process 28681 (sh)

sh invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] <4>fixdep invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee9f>] dput+0x98/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:   2

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:   5

CPU    2: Hot: hi:  186, btch:  31 usd: 129   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 141   Cold: hi:   62, btch:  15 usd:  53

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  51

CPU    1: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  53

CPU    2: Hot: hi:  186, btch:  31 usd:  51   Cold: hi:   62, btch:  15 usd:  57

CPU    3: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:  42

Active:266237 inactive:191925 dirty:1 writeback:0 unstable:0

 free:12198 slab:20366 mapped:20 pagetables:15216 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2672kB inactive:1512kB present:16224kB pages_scanned:89321 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40208kB min:3740kB low:4672kB high:5608kB active:361048kB inactive:304740kB present:892320kB pages_scanned:1111260 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:480kB min:512kB low:1736kB high:2960kB active:701228kB inactive:461448kB present:1167812kB pages_scanned:8202404 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 0*8kB 7*16kB 1*32kB 2*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40208kB

HighMem: 46*4kB 15*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB

Swap cache: add 15784, delete 15784, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1703 or a child

Killed process 28878 (sh)

fixdep invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:   2

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:   5

CPU    2: Hot: hi:  186, btch:  31 usd: 129   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 141   Cold: hi:   62, btch:  15 usd:  53

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  51

CPU    1: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  53

CPU    2: Hot: hi:  186, btch:  31 usd:  51   Cold: hi:   62, btch:  15 usd:  57

CPU    3: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:  42

Active:267336 inactive:190829 dirty:1 writeback:0 unstable:0

 free:12198 slab:20366 mapped:20 pagetables:15216 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2672kB inactive:1512kB present:16224kB pages_scanned:89321 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40208kB min:3740kB low:4672kB high:5608kB active:365448kB inactive:300360kB present:892320kB pages_scanned:1136769 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:480kB min:512kB low:1736kB high:2960kB active:701224kB inactive:461444kB present:1167812kB pages_scanned:8217956 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 0*8kB 7*16kB 1*32kB 2*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40208kB

HighMem: 46*4kB 15*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB

Swap cache: add 15784, delete 15784, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:   2

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:   6

CPU    2: Hot: hi:  186, btch:  31 usd: 129   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 141   Cold: hi:   62, btch:  15 usd:  53

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  51

CPU    1: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  53

CPU    2: Hot: hi:  186, btch:  31 usd:  51   Cold: hi:   62, btch:  15 usd:  57

CPU    3: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:  42

Active:276216 inactive:181955 dirty:1 writeback:0 unstable:0

 free:12198 slab:20366 mapped:20 pagetables:15216 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2672kB inactive:1512kB present:16224kB pages_scanned:89321 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40208kB min:3740kB low:4672kB high:5608kB active:400968kB inactive:264864kB present:892320kB pages_scanned:1146164 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:480kB min:51dahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0333502>] _spin_unlock_irq+0x5/0x7

 [<c0332325>] __sched_text_start+0x5a5/0x60a

 [<c012819b>] sys_rt_sigprocmask+0xae/0xc1

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:   2

CPU    1: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:   0

CPU    2: Hot: hi:  186, btch:  31 usd: 136   Cold: hi:   62, btch:  15 usd:  51

CPU    3: Hot: hi:  186, btch:  31 usd: 140   Cold: hi:   62, btch:  15 usd:  27

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  51

CPU    1: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  53

CPU    2: Hot: hi:  186, btch:  31 usd:  51   Cold: hi:   62, btch:  15 usd:  58

CPU    3: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:  42

Active:235319 inactive:226210 dirty:1 writeback:0 unstable:0

 free:12198 slab:20369 mapped:42 pagetables:15216 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2660kB inactive:1488kB present:16224kB pages_scanned:89897 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40708kB min:3740kB low:4672kB high:5608kB active:364952kB inactive:310632kB present:892320kB pages_scanned:155593 all_unreclaimable? no

lowmem_reserve[]: 0 0 9123

HighMem free:480kB min:512kB low:1736kB high:2960kB active:515236kB inactive:650460kB present:1167812kB pages_scanned:11450726 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 100*4kB 21*8kB 6*16kB 1*32kB 2*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40760kB

HighMem: 46*4kB 15*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB

Swap cache: add 15785, delete 15785, find 2894/4019, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27480 (make) score 1699 or a child

Killed process 29025 (sh)

printk: 99 messages suppressed.

as invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  22

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  39

CPU    2: Hot: hi:  186, btch:  31 usd: 139   Cold: hi:   62, btch:  15 usd:  36

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  30

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 127   Cold: hi:   62, btch:  15 usd:  55

CPU    1: Hot: hi:  186, btch:  31 usd:  52   Cold: hi:   62, btch:  15 usd:  56

CPU    2: Hot: hi:  186, btch:  31 usd:  52   Cold: hi:   62, btch:  15 usd:  49

CPU    3: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:  39

Active:269908 inactive:186934 dirty:0 writeback:0 unstable:0

 free:12245 slab:20325 mapped:9 pagetables:15202 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2680kB inactive:1480kB present:16224kB pages_scanned:91113 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40396kB min:3740kB low:4672kB high:5608kB active:218608kB inactive:444032kB present:892320kB pages_scanned:1549338 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:480kB min:512kB low:1736kB high:2960kB active:858528kB inactive:302208kB present:1167812kB pages_scanned:38220957 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 69*4kB 3*8kB 4*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40396kB

HighMem: 36*4kB 20*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB

Swap cache: add 15793, delete 15793, find 2894/4020, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1668 or a child

Killed process 29226 (sh)

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  22

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  39

CPU    2: Hot: hi:  186, btch:  31 usd: 139   Cold: hi:   62, btch:  15 usd:  36

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  30

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 127   Cold: hi:   62, btch:  15 usd:  55

CPU    1: Hot: hi:  186, btch:  31 usd:  52   Cold: hi:   62, btch:  15 usd:  56

CPU    2: Hot: hi:  186, btch:  31 usd:  52   Cold: hi:   62, btch:  15 usd:  49

CPU    3: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:  39

Active:276562 inactive:180306 dirty:0 writeback:0 unstable:0

 free:12245 slab:20325 mapped:9 pagetables:15202 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2680kB inactive:1480kB present:16224kB pages_scanned:91113 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40396kB min:3740kB low:4672kB high:5608kB active:205168kB inactive:457344kB present:892320kB pages_scanned:1560250 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:480kB min:512kB low:1736kB high:2960kB active:898272kB inactive:262400kB present:1167812kB pages_scanned:38230909 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 69*4kB 3*8kB 4*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40396kB

HighMem: 36*4kB 20*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB

Swap cache: add 15793, delete 15793, find 2894/4020, race 0+1

Free swap  = 0kB

Total swap = 8024kB

fixdep invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c01521d2>] vma_link+0xc1/0xcb

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  22

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  39

CPU    2: Hot: hi:  186, btch:  31 usd: 139   Cold: hi:   62, btch:  15 usd:  36

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  30

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 127   Cold: hi:   62, btch:  15 usd:  55

CPU    1: Hot: hi:  186, btch:  31 usd:  52   Cold: hi:   62, btch:igh:2960kB active:999300kB inactive:161668kB present:1167812kB pages_scanned:38271485 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 69*4kB 3*8kB 4*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40396kB

HighMem: 36*4kB 20*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB

Swap cache: add 15793, delete 15793, find 2894/4020, race 0+1

Free swap  = 0kB

Total swap = 8024kB

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0160d64>] sys_read+0x41/0x67

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  22

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  39

CPU    2: Hot: hi:  186, btch:  31 usd: 139   Cold: hi:   62, btch:  15 usd:  36

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  30

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 127   Cold: hi:   62, btch:  15 usd:  55

CPU    1: Hot: hi:  186, btch:  31 usd:  52   Cold: hi:   62, btch:  15 usd:  56

CPU    2: Hot: hi:  186, btch:  31 usd:  52   Cold: hi:   62, btch:  15 usd:  49

CPU    3: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:  39

Active:283842 inactive:173195 dirty:0 writeback:0 unstable:0

 free:12245 slab:20325 mapped:9 pagetables:15202 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2680kB inactive:1480kB present:16224kB pages_scanned:91113 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40396kB min:3740kB low:4672kB high:5608kB active:68208kB inactive:594568kB present:892320kB pages_scanned:1625386 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:480kB min:512kB low:1736kB high:2960kB active:1064480kB inactive:96860kB present:1167812kB pages_scanned:38335730 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 69*4kB 3*8kB 4*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40396kB

HighMem: 36*4kB 20*8kB 1*16kB 1*32kB 0*ch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  22

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  39

CPU    2: Hot: hi:  186, btch:  31 usd: 139   Cold: hi:   62, btch:  15 usd:  37

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  14

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 127   Cold: hi:   62, btch:  15 usd:  55

CPU    1: Hot: hi:  186, btch:  31 usd:  52   Cold: hi:   62, btch:  15 usd:  56

CPU    2: Hot: hi:  186, btch:  31 usd:  52   Cold: hi:   62, btch:  15 usd:  49

CPU    3: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:  39

Active:275764 inactive:181348 dirty:0 writeback:0 unstable:0

 free:12245 slab:20325 mapped:9 pagetables:15202 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2680kB inactive:1480kB present:16224kB pages_scanned:91113 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40396kB min:3740kB low:4672kB high:5608kB active:35896kB inactive:627048kB present:892320kB pages_scanned:1669573 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:480kB min:512kB low:1736kB high:2960kB active:1064480kB inactive:96736kB present:1167812kB pages_scanned:38376850 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 54*4kB 3*8kB 4*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40336kB

HighMem: 36*4kB 20*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB

Swap cache: add 15793, delete 15793, find 2894/4020, race 0+1

Free swap  = 0kB

Total swap = 8024kB

fixdep invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  22

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  39

CPU    2: Hot: hi:  186, btch:  31 usd: 139   Cold: hi:   62, btch:  15 usd:  37

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  14

HighMe*2048kB 8*4096kB = 40336kB

HighMem: 36*4kB 20*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB

Swap cache: add 15793, delete 15793, find 2894/4020, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] <6>0 pages writeback

out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee9f>] dput+0x98/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  22

CPU    1: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  39

CPU    2: Hot: hi:  186, btch:  31 usd: 139   Cold: hi:   62, btch:  15 usd:  37

CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  14

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 127   Cold: hi:   62, btch:  15 usd:  55

CPU    1: Hot: hi:  186, btch:  31 usd:  52   Cold: hi:   62, btch:  15 usd:  56

CPU    2: Hot: hi:  186, btch:  31 usd:  52   Cold: hi:   62, btch:  15 usd:  49

CPU    3: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:  39

Active:273361 inactive:183720 dirty:0 writeback:0 unstable:0

 free:12245 slab:20325 mapped:9 pagetables:15202 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2680kB inactive:1480kB present:16224kB pages_scanned:91113 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40396kB min:3740kB low:4672kB high:5608kB active:764kB inactive:662252kB present:892320kB pages_scanned:1684357 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:480kB min:512kB low:1736kB high:2960kB active:1089872kB inactive:71276kB present:1167812kB pages_scanned:38396277 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 54*4kB 3*8kB 4*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40336kB

HighMem: 36*4kB 20*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB

Swap cache: add 15793, delete 15793, find 2894/4020, race 0+1

Free swap  = 0kB

Total swap = 8024kB

 [<c0147386>] <3>Out of memory: kill process 27480 (make) score 1664 or a child

Killed process 29026 (sh)

Out of memory: kill4kB min:68kB low:84kB high:100kB active:2684kB inactive:1444kB present:16224kB pages_scanned:91561 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40196kB min:3740kB low:4672kB high:5608kB active:648332kB inactive:25320kB present:892320kB pages_scanned:2303025 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:480kB min:512kB low:1736kB high:2960kB active:346152kB inactive:821868kB present:1167812kB pages_scanned:903443 all_unreclaimable? no

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 48*4kB 8*8kB 7*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40400kB

HighMem: 16*4kB 31*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 488kB

Swap cache: add 15793, delete 15793, find 2894/4020, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27480 (make) score 1630 or a child

Killed process 29028 (sh)

printk: 34 messages suppressed.

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0168243>] may_open+0x4e/0x21a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c016001c>] do_filp_open+0x32/0x39

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  38

CPU    1: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 150   Cold: hi:   62, btch:  15 usd:  52

CPU    3: Hot: hi:  186, btch:  31 usd: 157   Cold: hi:   62, btch:  15 usd:  55

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd: 123   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd: 144   Cold: hi:   62, btch:  15 usd:  61

CPU    3: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  51

Active:84200 inactive:368473 dirty:0 writeback:0 unstable:0

 free:12207 slab:20135 mapped:35 pagetables:15177 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2708kB inactive:1460kB present:16224kB pages_scanned:91881 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40232kB min:3740kB low:4672kB high:5608kB active:333096kB inactive:326716kB present:892320kB pages_scanned:1183816 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:492kB min:512kB low:1736kB high:2960kB active:848kB inactive:1145828kB present:1167812kB pages_scanned:3129750 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 18*4kB 6*8kB 5*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40232kB

HighMem: 17*4kB 31*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 492kB

Swap cache: add 15802, delete 15802, find 2894/4021, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 3341 (sendmail) score 1624 or a child

Killed process 3341 (sendmail)

fixdep invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0168243>] may_open+0x4e/0x21a

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c01521d2>] vma_link+0xc1/0xcb

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  38

CPU    1: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 150   Cold: hi:   62, btch:  15 usd:  52

CPU    3: Hot: hi:  186, btch:  31 usd: 157   Cold: hi:   62, btch:  15 usd:  55

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd: 123   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd: 144   Cold: hi:   62, btch:  15 usd:  61

CPU    3: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  51

Active:84161 inactive:368475 dirty:0 writeback:0 unstable:0

 free:12207 slab:20135 mapped:35 pagetables:15177 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2708kB inactive:1460kB present:16224kB pages_scanned:91881 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40232kB min:3740kB low:4672kB high:5608kB active:333088kB inactive:326612kB present:892320kB pages_scanned:1199912 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:492kB min:512kB low:1736kB high:2960kB active:848kB inactive:1145828kB present:1167812kB pages_scanned:3129750 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 18*4kB 6*8kB 5*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40232kB

HighMem: 17*4kB 31*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 492kB

Swap cache: add 15802, delete 15802, find 2894/4021, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0168243>] may_open+0x4e/0x21a

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01639a5>] sys_fstat64+0x1e/0x23

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  38

CPU    1: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 150   Cold: hi:   62, btch:  15 usd:  52

CPU    3: Hot: hi:  186, btch:  31 usd: 157   Cold: hi:   62, btch:  15 usd:  55

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd: 123   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd: 144   Cold: hi:   62, btch:  15 usd:  61

CPU    3: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  51

Active:84253 inactive:368382 dirty:0 writeback:0 unstable:0

 free:12207 slab:20135 mapped:35 pagetables:15177 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2708kB inactive:1460kB present:16224kB pages_scanned:91881 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40232kB min:3740kB low:4672kB high:5608kB active:333088kB inactive:326612kB present:892320kB pages_scanned:1200424 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:492kB min:512kB low:1736kB high:2960kB active:1216kB inactive:1145456kB present:1167812kB pages_scanned:3139542 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 18*4kB 6*8kB 5*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40232kB

HighMem: 17*4kB 31*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 492kB

Swap cache: add 15802, delete 15802, find 2894/4021, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_re: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd: 123   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd: 144   Cold: hi:   62, btch:  15 usd:  61

CPU    3: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  51

Active:84141 inactive:368510 dirty:0 writeback:0 unstable:0

 free:12207 slab:20135 mapped:35 pagetables:15177 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2708kB inactive:1460kB present:16224kB pages_scanned:91881 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40232kB min:3740kB low:4672kB high:5608kB active:333108kB inactive:326612kB present:892320kB pages_scanned:1200530 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:492kB min:512kB low:1736kB high:2960kB active:748kB inactive:1145968kB present:1167812kB pages_scanned:3141335 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 18*4kB 6*8kB 5*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40232kB

HighMem: 17*4kB 31*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 492kB

Swap cache: add 15802, delete 15802, find 2894/4021, race 0+1

Free swap  = 0kB

Total swap = 8024kB

fixdep invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

sh invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01220c4>] tasklet_action+0x52/0xa2

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  38

CPU    1: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 150   Cold: hi:   62, btch:  15 usd:  52

CPU    3: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  55

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd: 123   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd: 144   Cold: hi:   62, btch:  15 usd:  61

CPU    3: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  51

Active:84107 inactive:368560 dirty:0 writeback:0 unstable:0

 fr170   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd: 123   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd: 144   Cold: hi:   62, btch:  15 usd:  61

CPU    3: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  51

Active:83974 inactive:368827 dirty:0 writeback:0 unstable:0

 free:12207 slab:20128 mapped:26 pagetables:15177 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2708kB inactive:1460kB present:16224kB pages_scanned:91881 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40232kB min:3740kB low:4672kB high:5608kB active:333108kB inactive:326612kB present:892320kB pages_scanned:1200530 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:492kB min:512kB low:1736kB high:2960kB active:80kB inactive:1147236kB present:1167812kB pages_scanned:3155256 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 18*4kB 5*8kB 5*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40224kB

HighMem: 17*4kB 31*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 492kB

Swap cache: add 15802, delete 15802, find 2894/4021, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  38

CPU    1: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 150   Cold: hi:   62, btch:  15 usd:  52

CPU    3: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  55

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd: 123   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd: 144   Cold: hi:   62, btch:  15 usd:  61

CPU    3: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  51

Active:84181 inactiv55

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd: 123   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd: 144   Cold: hi:   62, btch:  15 usd:  61

CPU    3: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  51

Active:84164 inactive:368613 dirty:0 writeback:0 unstable:0

 free:12207 slab:20128 mapped:26 pagetables:15177 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2708kB inactive:1460kB present:16224kB pages_scanned:91881 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40232kB min:3740kB low:4672kB high:5608kB active:333276kB inactive:326436kB present:892320kB pages_scanned:1200742 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:492kB min:512kB low:1736kB high:2960kB active:672kB inactive:1146556kB present:1167812kB pages_scanned:3186200 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 18*4kB 5*8kB 5*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40224kB

HighMem: 17*4kB 31*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 492kB

Swap cache: add 15802, delete 15802, find 2894/4021, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  38

CPU    1: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 150   Cold: hi:   62, btch:  15 usd:  52

CPU    3: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  55

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd: 123   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd: 144   Cold: hi:   62, btch:  15 usd:  61

CPU    3: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  51

Active:84347 inactive:368409 dirt708kB inactive:1460kB present:16224kB pages_scanned:91881 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40232kB min:3740kB low:4672kB high:5608kB active:333424kB inactive:326260kB present:892320kB pages_scanned:1200848 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:492kB min:512kB low:1736kB high:2960kB active:0kB inactive:1147452kB present:1167812kB pages_scanned:3197400 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 18*4kB 5*8kB 5*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40224kB

HighMem: 17*4kB 31*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 492kB

Swap cache: add 15802, delete 15802, find 2894/4021, race 0+1

Free swap  = 0kB

Total swap = 8024kB

 [<c0147386>] <4>printk: 16 messages suppressed.

sh invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01220c4>] tasklet_action+0x52/0xa2

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  38

CPU    1: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:  14

CPU    2: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  52

CPU    3: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  55

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  52

CPU    1: Hot: hi:  186, btch:  31 usd: 123   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd: 144   Cold: hi:   62, btch:  15 usd:  61

CPU    3: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  52

Active:83243 inactive:369857 dirty:0 writeback:0 unstable:0

 free:12207 slab:20122 mapped:29 pagetables:15177 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2708kB inactive:1460kB present:16224kB pages_scanned:91881 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40232kB min:3740kB low:4672kB high:5608kB active:330264kB inactive:329496kB present:892320kB pages_scanned:1219226 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:492kB min:512kB low:1736kB high:2960kB active:0kB inactive:1148472kB present:1167812kB pages_scannedunreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40232kB min:3740kB low:4672kB high:5608kB active:329752kB inactive:330532kB present:892320kB pages_scanned:1366720 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:492kB min:512kB low:1736kB high:2960kB active:0kB inactive:1150120kB present:1167812kB pages_scanned:3491026 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 18*4kB 1*8kB 5*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40192kB

HighMem: 17*4kB 31*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 492kB

Swap cache: add 15802, delete 15802, find 2894/4021, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  38

CPU    1: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:  41

CPU    2: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  52

CPU    3: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  57

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  56

CPU    1: Hot: hi:  186, btch:  31 usd: 123   Cold: hi:   62, btch:  15 usd:  49

CPU    2: Hot: hi:  186, btch:  31 usd: 144   Cold: hi:   62, btch:  15 usd:  61

CPU    3: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  57

Active:170484 inactive:284289 dirty:0 writeback:0 unstable:0

 free:12197 slab:20132 mapped:34 pagetables:15177 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2704kB inactive:1472kB present:16224kB pages_scanned:91945 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40192kB min:3740kB low:4672kB high:5608kB active:334192kB inactive:328584kB present:892320kB pages_scanned:2235591 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:428kB min:512kB low:1736kB high:2960kB active:516124kB inactive:637096kB present:1167812kB pages_scanned:2254594 all_unreclaimable? no

lowmemprintk: 10 messages suppressed.

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 148   Cold: hi:   62, btch:  15 usd:  54

CPU    1: Hot: hi:  186, btch:  31 usd: 141   Cold: hi:   62, btch:  15 usd:  18

CPU    2: Hot: hi:  186, btch:  31 usd:  93   Cold: hi:   62, btch:  15 usd:  24

CPU    3: Hot: hi:  186, btch:  31 usd:  89   Cold: hi:   62, btch:  15 usd:  51

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  24

CPU    1: Hot: hi:  186, btch:  31 usd: 118   Cold: hi:   62, btch:  15 usd:  12

CPU    2: Hot: hi:  186, btch:  31 usd: 132   Cold: hi:   62, btch:  15 usd:  10

CPU    3: Hot: hi:  186, btch:  31 usd:  88   Cold: hi:   62, btch:  15 usd:  52

Active:223836 inactive:229347 dirty:0 writeback:0 unstable:0

 free:12361 slab:20151 mapped:8 pagetables:15169 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2732kB inactive:1452kB present:16224kB pages_scanned:92777 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40532kB min:3740kB low:4672kB high:5608kB active:323056kB inactive:337696kB present:892320kB pages_scanned:1198753 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:808kB min:512kB low:1736kB high:2960kB active:569428kB inactive:578368kB present:1167812kB pages_scanned:1772732 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 89*4kB 14*8kB 2*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40532kB

HighMem: 81*4kB 16*8kB 5*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 692kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1599 or a child

Killed process 29630 (sh)

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0160d64>] sys_read+0x41/0x67

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 148   Cold: hi:   62, btch:  15 usd:  54

CPU    1: Hot: hi:  186, btch:  31 usd: 141   Cold: hi:   62, btch:  15 usd:  18

CPU    2: Hot: hi:  186, btch:  31 usd:  93   Cold: hi:   62, btch:  15 usd:  24

CPU    3: Hot: hi:  186, btch:  31 usd:  89   Cold: hi:   62, btch:  15 usd:  51

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  24

CPU    1: Hot: hi:  186, btch:  31 usd: 118   Cold: hi:   62, btch:  15 usd:  41

CPU    2: Hot: hi:  186, btch:  31 usd: 132   Cold: hi:   62, btch:  15 usd:  10

CPU    3: Hot: hi:  186, btch:  31 usd:  88   Cold: hi:   62, btch:  15 usd:  52

Active:218026 inactive:235108 dirty:0 writeback:0 unstable:0

 free:12361 slab:20151 mapped:8 pagetables:15169 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2732kB inactive:1452kB present:16224kB pages_scanned:92777 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40532kB min:3740kB low:4672kB high:5608kB active:323056kB inactive:337696kB present:892320kB pages_scanned:1198753 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:808kB min:512kB low:1736kB high:2960kB active:546188kB inactive:601412kB present:1167812kB pages_scanned:1783548 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 89*4kB 14*8kB 2*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40532kB

HighMem: 81*4kB 16*8kB 5*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 692kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<f884dc82>] do_get_write_access+0x49d/0x4bc [jbd]

 [<c0332ba9>] out_of_line_wait_on_bit+0x6f/0x77

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0178bf4>] __mark_inode_dirty+0xec/0x180

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 148   Cold: hi:   62, btch:  15 usd:  54

CPU    1: Hot: hi:  186, btch:  31 usd: 141   Cold: hi:   62, btch:  15 usd:  18

CPU    2: Hot: hi:  186, btch:  31 usd:  93   Cold: hi:   62, btch:  15 usd:  24

CPU    3: Hot: hi:  186, btch:  31 usd:  89   Cold: hi:   62, btch:  15 usd:  51

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  24

CPU    1: Hot: hi:  186, btch:  31 usd: 118   Cold: hi:   62, btch:  15 usd:  41

CPU    2: Hot: hi:  186, btch:  31 usd: 132   Cold: hi:   62, btch:  15 usd:  10

CPU    3: Hot: hi:  186, btch:  31 usd:  88   Cold: hi:   62, btch:  15 usd:  52

Active:213303 inactive:239877 dirty:0 writeback:0 unstable:0

 free:12361 slab:20151 mapped:8 pagetables:15169 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2732kB inactive:1452kB present:16224kB pages_scanned:92777 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40532kB min:3740kB low:4672kB high:5608kB active:323056kB inactive:337696kB present:892320kB pages_scanned:1198753 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:808kB min:512kB low:1736kB high:2960kB active:527240kB inactive:620360kB present:1167812kB pages_scanned:1792572 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 89*4kB 14*8kB 2*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40532kB

HighMem: 81*4kB 16*8kB 5*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 692kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

fixdep invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c01521d2>] vma_link+0xc1/0xcb

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:  47

CPU    1: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  34

CPU    2: Hot: hi:  186, btch:  31 usd:  92   Cold: hi:   62, btch:  15 usd:  37

CPU    3: Hot: hi:  186, btch:  31 usd:  89   Cold: hi:   62, btch:  15 usd:  51

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 173   Cold: hi:   62, btch:  15 usd:  20

CPU    1: Hot: hi:  186, btch:  31 usd: 118   Cold: hi:   62, btch:  15 usd:  45

CPU    2: Hot: hi:  186, btch:  31 usd: 132   Cold: hi:   62, btch:  15 usd:  39

CPU    3: Hot: hi:  186, btch:  31 usd:  88   Cold: hi:   62, btch:  15 usd:  52

Active:171793 inactive:281156 dirty:0 writeback:0 unstable:0

 free:12217 slab:20150 mapped:9 pagetables:15162 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2732kB inactive:1452kB present:16224kB pages_scanned:92777 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40252kB min:3740kB low:4672kB high:5608kB active:326496kB inactive:334348kB present:892320kB pages_scanned:1096435 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:512kB min:512kB low:1736kB high:2960kB active:447cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 133   Cold: hi:   62, btch:  15 usd:   0

CPU    1: Hot: hi:  186, btch:  31 usd: 151   Cold: hi:   62, btch:  15 usd:  23

CPU    2: Hot: hi:  186, btch:  31 usd:  90   Cold: hi:   62, btch:  15 usd:   6

CPU    3: Hot: hi:  186, btch:  31 usd:  93   Cold: hi:   62, btch:  15 usd:  31

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:   1

CPU    1: Hot: hi:  186, btch:  31 usd: 121   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd: 134   Cold: hi:   62, btch:  15 usd:  19

CPU    3: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:  12

Active:193359 inactive:258621 dirty:0 writeback:0 unstable:0

 free:12286 slab:20144 mapped:13 pagetables:15156 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2736kB inactive:1448kB present:16224kB pages_scanned:92841 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40532kB min:3740kB low:4672kB high:5608kB active:353728kB inactive:307896kB present:892320kB pages_scanned:1103659 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:508kB min:512kB low:1736kB high:2960kB active:416716kB inactive:725268kB present:1167812kB pages_scanned:1957143 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 81*4kB 14*8kB 4*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40532kB

HighMem: 1*4kB 10*8kB 6*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 340kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

fixdep invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c017cb7b>] __find_get_block+0x3d/0x45

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c01521d2>] vma_link+0xc1/0xcb

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 133   Cold: hi:   62, btch:  15 usd:   0

CPU    1: Hot: hi:  186, btch:  31 usd: 151   Cold: hi:   62, btch:  15 usd:  23

CPU    2: Hot: hi:  186, btch:  31 usd:  90   Cold: hi:   62, btch:  15 usd:   6

CPU    3: Hot: hi:  186, btch:  31 usd:  93   Cold: hi:   62, btch:  15 usd:  31

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:   1

CPU    1: Hot: hi:  186, btch:  31 usd: 121   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd: 134   Cold: hi:   62, btch:  15 usd:  19

CPU    3: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:  12

Active:183504 inactive:268476 dirty:0 writeback:0 unstable:0

 free:12286 slab:20144 mapped:13 pagetables:15156 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2736kB inactive:1448kB present:16224kB pages_scanned:92841 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40532kB min:3740kB low:4672kB high:5608kB active:353728kB inactive:307896kB present:892320kB pages_scanned:1103659 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:508kB min:512kB low:1736kB high:2960kB active:377424kB inactive:764688kB present:1167812kB pages_scanned:1966968 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 81*4kB 14*8kB 4*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40532kB

HighMem: 1*4kB 10*8kB 6*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 340kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1565 or a child

Killed process 29633 (sh)

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0168243>] may_open+0x4e/0x21a

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01639a5>] sys_fstat64+0x1e/0x23

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 135   Cold: hi:   62, btch:  15 usd:  20

CPU    1: Hot: hi:  186, btch:  31 usd: 151   Cold: hi:   62, btch:  15 usd:  23

CPU    2: Hot: hi:  186, btch:  31 usd:  88   Cold: hi:   62, btch:  15 usd:  57

CPU    3: Hot: hi:  186, btch:  31 usd:  93   Cold: hi:   62, btch:  15 usd:  10

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 173   Cold: hi:   62, btch:  15 usd:  34

CPU    1: Hot: hi:  186, btch:  31 usd: 121   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd: 134   Cold: hi:   62, btch:  15 usd:  58

CPU    3: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:  48

Active:259737 inactive:192636 dirty:0 writeback:0 unstable:0

 free:12273 slab:20143 mapped:12 pagetables:15157 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2736kB inactive:1448kB present:16224kB pages_scanned:92905 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40432kB min:3740kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40592kB

HighMem: 16*4kB 10*8kB 6*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 400kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

sh invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01220c4>] tasklet_action+0x52/0xa2

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  37

CPU    1: Hot: hi:  186, btch:  31 usd: 131   Cold: hi:   62, btch:  15 usd:  60

CPU    2: Hot: hi:  186, btch:  31 usd:  77   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd:  88   Cold: hi:   62, btch:  15 usd:   4

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 136   Cold: hi:   62, btch:  15 usd:  31

CPU    1: Hot: hi:  186, btch:  31 usd: 114   Cold: hi:   62, btch:  15 usd:  52

CPU    2: Hot: hi:  186, btch:  31 usd: 122   Cold: hi:   62, btch:  15 usd:  22

CPU    3: Hot: hi:  186, btch:  31 usd: 161   Cold: hi:   62, btch:  15 usd:  29

Active:311813 inactive:140449 dirty:0 writeback:0 unstable:0

 free:12185 slab:20160 mapped:48 pagetables:15152 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2736kB inactive:1448kB present:16224kB pages_scanned:92969 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40168kB min:3740kB low:4672kB high:5608kB active:651576kB inactive:7208kB present:892320kB pages_scanned:1264801 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:468kB min:512kB low:1736kB high:2960kB active:592812kB inactive:553140kB present:1167812kB pages_scanned:2181050 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 1*4kB 4*8kB 2*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40068kB

HighMem: 1*4kB 18*8kB 6*16kB 3*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 468kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27480 (make) score 1561 or a child

Killed process 29031 (sh)

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0144c74>] do_generic_mapping_read+0x370/0x42d

 [<c01d0fc0>] strncpy_from_user+0x37/0x56

 [<c0144fc1>] generic_file_aio_read+0x19f/0x1c3

 [<c0144d31>] file_read_actor+0x0/0xf1

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c012e872>] autoremove_wake_function+0x0/0x33

 [<c0115a01>] do_page_fault+0x314/0x5f7

 [<c01639a5>] sys_fstat64+0x1e/0x23

 [<c0160a74>] vfs_read+0xb1/0x131

 [<c0160d64>] sys_read+0x41/0x67

 [<c01030a4>] sysenter_past_esp+0x5d/0x81

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  37

CPU    1: Hot: hi:  186, btch:  31 usd: 131   Cold: hi:   62, btch:  15 usd:  60

CPU    2: Hot: hi:  186, btch:  31 usd:  77   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd:  88   Cold: hi:   62, btch:  15 usd:   4

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 136   Cold: hi:   62, btch:  15 usd:  31

CPU    1: Hot: hi:  186, btch:  31 usd: 114   Cold: hi:   62, btch:  15 usd:  52

CPU    2: Hot: hi:  186, btch:  31 usd: 122   Cold: hi:   62, btch:  15 usd:  22

CPU    3: Hot: hi:  186, btch:  31 usd: 161   Cold: hi:   62, btch:  15 usd:  29

Active:302315 inactive:149892 dirty:0 writeback:0 unstable:0

 free:12185 slab:20160 mapped:48 pagetables:15152 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2736kB inactive:1448kB present:16224kB pages_scanned:92969 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40168kB min:3740kB low:4672kB high:5608kB active:651416kB inactive:7320kB present:892320kB pages_scanned:1264841 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:468kB min:512kB low:1736kB high:2960kB active:555108kB inactive:590928kB present:1167812kB pages_scanned:2199004 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 1*4kB 4*8kB 2*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40068kB

HighMem: 1*4kB 18*8kB 6*16kB 3*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 468kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

as invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0168243>] may_open+0x4e/0x21a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c016001c>] do_filp_open+0x32/0x39

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  37

CPU    1: Hot: hi:  186, btch:  31 usd: 131   Cold: hi:   62, btch:  15 usd:  60

CPU    2: Hot: hi:  186, btch:  31 usd:  77   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd:  88   Cold: hi:   62, btch:  15 usd:   4

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 136   Cold: hi:   62, btch:  15 usd:  31

CPU    1: Hot: hi:  186, btch:  31 usd: 114   Cold: hi:   62, btch:  15 usd:  52

CPU    2: Hot: hi:  186, btch:  31 usd: 122   Cold: hi:   62, btch:  15 usd:  22

CPU    3: Hot: hi:  186, btch:  31 usd: 161   Cold: hi:   62, btch:  15 usd:  29

Active:297035 inactive:155178 dirty:0 writeback:0 unstable:0

 free:12185 slab:20160 mapped:48 pagetables:15152 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2736kB inactive:1448kB present:16224kB pages_scanned:92969 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40168kB min:3740kB low:4672kB high:5608kB active:651416kB inactive:7320kB present:892320kB pages_scanned:1264841 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:468kB min:512kB low:1736kB high:2960kB active:533988kB inactive:611944kB present:1167812kB pages_scanned:2209788 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 1*4kB 4*8kB 2*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40068kB

HighMem: 1*4kB 18*8kB 6*16kB 3*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 468kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] f=======

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  37

CPU    1: Hot: hi:  186, btch:  31 usd: 131   Cold: hi:   62, btch:  15 usd:  60

CPU    2: Hot: hi:  186, btch:  31 usd:  77   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd:  88   Cold: hi:   62, btch:  15 usd:   4

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 136   Cold: hi:   62, btch:  15 usd:  34

CPU    1: Hot: hi:  186, btch:  31 usd: 114   Cold: hi:   62, btch:  15 usd:  52

CPU    2: Hot: hi:  186, btch:  31 usd: 122   Cold: hi:   62, btch:  15 usd:  22

CPU    3: Hot: hi:  186, btch:  31 usd: 161   Cold: hi:   62, btch:  15 usd:  29

Active:310492 inactive:141784 dirty:0 writeback:0 unstable:0

 free:12185 slab:20160 mapped:48 pagetables:15152 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2736kB inactive:1448kB present:16224kB pages_scanned:92969 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40168kB min:3740kB low:4672kB high:5608kB active:641348kB inactive:17564kB present:892320kB pages_scanned:1283802 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:468kB min:512kB low:1736kB high:2960kB active:597884kB inactive:547868kB present:1167812kB pages_scanned:2238400 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 1*4kB 4*8kB 2*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40068kB

HighMem: 1*4kB 18*8kB 6*16kB 3*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 468kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usdpen+0x4e/0x21a

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01639a5>] sys_fstat64+0x1e/0x23

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  37

CPU    1: Hot: hi:  186, btch:  31 usd: 131   Cold: hi:   62, btch:  15 usd:  60

CPU    2: Hot: hi:  186, btch:  31 usd:  77   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd:  88   Cold: hi:   62, btch:  15 usd:   4

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 136   Cold: hi:   62, btch:  15 usd:  42

CPU    1: Hot: hi:  186, btch:  31 usd: 114   Cold: hi:   62, btch:  15 usd:  52

CPU    2: Hot: hi:  186, btch:  31 usd: 122   Cold: hi:   62, btch:  15 usd:  24

CPU    3: Hot: hi:  186, btch:  31 usd: 161   Cold: hi:   62, btch:  15 usd:  29

Active:436374 inactive:15994 dirty:0 writeback:0 unstable:0

 free:12170 slab:20160 mapped:31 pagetables:15152 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2736kB inactive:1448kB present:16224kB pages_scanned:92969 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40108kB min:3740kB low:4672kB high:5608kB active:618056kB inactive:41220kB present:892320kB pages_scanned:1399799 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:468kB min:512kB low:1736kB high:2960kB active:1124704kB inactive:21104kB present:1167812kB pages_scanned:2514783 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 1*4kB 4*8kB 2*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40068kB

HighMem: 1*4kB 18*8kB 6*16kB 3*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 468kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0160d64>] sys_read+0x41/0x67

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  37

CPU    1: Hot: hi:  186, btch:  31 usd: 131   Cold: hi:   62, btch:  15 usd:  60

CPU    2: Hot: hi:  186, btch:  31 usd:  77   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd:  88   Cold: hi:   62, btch:  15 usd:   4

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 136   Cold: hi:   62, btch:  15 usd:  42

CPU    1: Hot: hi:  186, btch:  31 usd: 114   Cold: hi:   62, btch:  15 usd:  52

CPU    2: Hot: hi:  186, btch:  31 usd: 122   Cold: hi:   62, btch:  15 usd:  24

CPU    3: Hot: hi:  186, btch:  31 usd: 161   Cold: hi:   62, btch:  15 usd:  32

Active:435624 inactive:16991 dirty:0 writeback:0 unstable:0

 free:12170 slab:20160 mapped:31 pagetables:15152 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2736kB inactive:1448kB present:16224kB pages_scanned:92969 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40108kB min:3740kB low:4672kB high:5608kB active:603288kB inactive:56388kB present:892320kB pages_scanned:1496245 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:468kB min:512kB low:1736kB high:2960kB active:1136472kB inactive:10128kB present:1167812kB pages_scanned:2851817 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 1*4kB 4*8kB 2*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40068kB

HighMem: 1*4kB 18*8kB 6*16kB 3*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 468kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

as invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0168243>] may_open+0x4e/0x21a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c016001c>] do_filp_open+0x32/0x39

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  37

CPU    1: Hot: hi:  186, btch:  31 usd: 131   Cold: hi:   62, btch:  15 usd:  60

CPU    2: Hot: hi:  186, btch:  31 usd:  77   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd:  88   Cold: hi:   62, btch:  15 usd:   4

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  3:   62, btch:  15 usd:  16

CPU    3: Hot: hi:  186, btch:  31 usd:  98   Cold: hi:   62, btch:  15 usd:   7

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 136   Cold: hi:   62, btch:  15 usd:  41

CPU    1: Hot: hi:  186, btch:  31 usd: 114   Cold: hi:   62, btch:  15 usd:  52

CPU    2: Hot: hi:  186, btch:  31 usd: 173   Cold: hi:   62, btch:  15 usd:  16

CPU    3: Hot: hi:  186, btch:  31 usd: 163   Cold: hi:   62, btch:  15 usd:  11

Active:389149 inactive:64866 dirty:0 writeback:0 unstable:0

 free:12116 slab:20119 mapped:10 pagetables:15146 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2740kB inactive:1444kB present:16224kB pages_scanned:93225 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40068kB min:3740kB low:4672kB high:5608kB active:491220kB inactive:172236kB present:892320kB pages_scanned:2210593 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:292kB min:512kB low:1736kB high:2960kB active:1062636kB inactive:85784kB present:1167812kB pages_scanned:8514015 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 1*4kB 4*8kB 2*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40068kB

HighMem: 1*4kB 0*8kB 2*16kB 4*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 292kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1531 or a child

Killed process 29638 (sh)

printk: 10 messages suppressed.

cc1 invoked oom-killer: gfp_mask=0x280d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0150a47>] do_anonymous_page+0x3e/0x1e3

 [<c0151251>] __handle_mm_fault+0x1a1/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01c4b24>] submit_bio+0xbd/0xc4

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c012007b>] do_exit+0x2c8/0x377

 [<c0144d78>] file_read_actor+0x47/0xf1

 [<c0144a78>] do_generic_mapping_read+0x174/0x42d

 [<c0144fc1>] generic_file_aio_read+0x19f/0x1c3

 [<c0144d31>] file_read_actor+0x0/0xf1

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c0151251>] __handle_mm_fault+0x1a1/0x2bc

 [<c012e872>] autoremove_wake_function+0x0/0x33

 [<c0115a01>] do_page_fault+0x314/0x5f7

 [<c01639a5>] sys_fstat64+0x1e/0x23

 [<c0160a74>] vfs_read+0xb1/0x131

 [<c0160d64>] sys_read+0x41/0x67

 [<c01030a4>] sysenter_past_esp+0x5d/0x81

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 133   Cold: hi:   62, btch:  15 usd:  38

CPU    1: Hot: hisd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 154   Cold: hi:   62, btch:  15 usd:  38

CPU    1: Hot: hi:  186, btch:  31 usd: 131   Cold: hi:   62, btch:  15 usd:  60

CPU    2: Hot: hi:  186, btch:  31 usd:  94   Cold: hi:   62, btch:  15 usd:  16

CPU    3: Hot: hi:  186, btch:  31 usd: 103   Cold: hi:   62, btch:  15 usd:   7

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:   4

CPU    1: Hot: hi:  186, btch:  31 usd: 114   Cold: hi:   62, btch:  15 usd:  52

CPU    2: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:   6

CPU    3: Hot: hi:  186, btch:  31 usd: 168   Cold: hi:   62, btch:  15 usd:  14

Active:263054 inactive:191962 dirty:0 writeback:0 unstable:0

 free:12103 slab:20106 mapped:10 pagetables:15134 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2764kB inactive:1404kB present:16224kB pages_scanned:93609 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40068kB min:3740kB low:4672kB high:5608kB active:484156kB inactive:179348kB present:892320kB pages_scanned:2220941 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:240kB min:512kB low:1736kB high:2960kB active:565296kB inactive:586968kB present:1167812kB pages_scanned:1797460 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 1*4kB 4*8kB 2*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40068kB

HighMem: 1*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 188kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1496 or a child

Killed process 29641 (sh)

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0168243>] may_open+0x4e/0x21a

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01639a5>] sys_fstat64+0x1e/0x23

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:  42

CPU    1: Hot: hi:  186, btch:  31 usd: 131   Cold: hi:   62, btch:  15 usd:  60

CPU    2: Hot: hi:  186, btch:  31 usd:  93   Cold: hi:   62, btch:  15 usd:  16

CPU    3: Hot: hi:  186, btch:  31 usd: 103   Cold: hi:   62, btch:  15 usd:   7

HighMem per-cpprintk: 1478 messages suppressed.

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

Out of memory: kill process 27480 (make) score 1458 or a child

Killed process 29036 (sh)

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:  43

CPU    1: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  60

CPU    2: Hot: hi:  186, btch:  31 usd: 132   Cold: hi:   62, btch:  15 usd:  16

CPU    3: Hot: hi:  186, btch:  31 usd: 120   Cold: hi:   62, btch:  15 usd:   8

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  15

CPU    1: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:   3

CPU    2: Hot: hi:  186, btch:  31 usd: 158   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 167   Cold: hi:   62, btch:  15 usd:   2

Active:163387 inactive:291319 dirty:0 writeback:0 unstable:0

 free:12182 slab:20103 mapped:8 pagetables:15122 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2768kB inactive:1416kB present:16224kB pages_scanned:99049 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40052kB min:3740kB low:4672kB high:5608kB active:235052kB inactive:429360kB present:892320kB pages_scanned:3984108 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:572kB min:512kB low:1736kB high:2960kB active:752740kB inactive:397952kB present:1167812kB pages_scanned:627496 all_unreclaimable? no

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 1*4kB 2*8kB 2*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40052kB

HighMem: 1*4kB 42*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 516kB

Swap cache: add 15878, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1427 or a child

Killed process 29717 (sh)

printk: 1 messages suppressed.

Out of memory: kill process 27480 (make) score 1423 or a child

Killed process 29635 (sh)

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0144c74>] do_generic_mapping_read+0x370/0x42d

 [<c0144fc1>] generic_file_aio_read+0x19f/0x1c3

 [<c0144d31>] file_read_actor+0x0/0xf1

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c012e872>] autoremove_wake_function+0x0/0x33

 [<c0115a01>] do_page_fault+0x314/0x5f7

 [<c01639a5>] sys_fstat64+0x1e/0x23

 [<c0160a74>] vfs_read+0xb1/0x131

 [<c0160d64>] sys_read+0x41/0x67

 [<c01030a4>] sysenter_past_esp+0x5d/0x81

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 184   Cold: hi:   62, btch:  15 usd:  43

CPU    1: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  46

CPU    2: Hot: hi:  186, btch:  31 usd: 144   Cold: hi:   62, btch:  15 usd:  16

printk: 14 messages suppressed.

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0178bf4>] __mark_inode_dirty+0xec/0x180

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 184   Cold: hi:   62, btch:  15 usd:  43

CPU    1: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  46

CPU    2: Hot: hi:  186, btch:  31 usd: 144   Cold: hi:   62, btch:  15 usd:  16

CPU    3: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:   9

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 169   Cold: hi:   62, btch:  15 usd:  15

CPU    1: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:   3

CPU    2: Hot: hi:  186, btch:  31 usd: 158   Cold: hi:   62, btch:  15 usd:  15

CPU    3: Hot: hi:  186, btch:  31 usd: 169   Cold: hi:   62, btch:  15 usd:   7

Active:57636 inactive:398284 dirty:0 writeback:1 unstable:0

 free:12279 slab:20087 mapped:7 pagetables:15104 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2768kB inactive:1416kB present:16224kB pages_scanned:99049 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40360kB min:3740kB low:4672kB high:5608kB active:70428kB inactive:593024kB present:892320kB pages_scanned:1147489 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:652kB min:512kB low:1736kB high:2960kB active:157220kB inactive:998824kB present:1167812kB pages_scanned:3097212 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 38*4kB 18*8kB 4*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40360kB

HighMem: 47*4kB 36*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 652kB

Swap cache: add 15879, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

CPU    3: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:   9

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd:  12

CPU    1: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:   9

CPU    2: Hot: hi:  186, btch:  31 usd: 158   Cold: hi:   62, btch:  15 usd:  15

CPU    3: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:   2

Active:255391 inactive:199832 dirty:0 writeback:1 unstable:0

 free:12343 slab:20087 mapped:5 pagetables:15098 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2768kB inactive:1416kB present:16224kB pages_scanned:99049 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40484kB min:3740kB low:4672kB high:5608kB active:389844kB inactive:273404kB present:892320kB pages_scanned:599154 all_unreclaimable? no

lowmem_reserve[]: 0 0 9123

HighMem free:784kB min:512kB low:1736kB high:2960kB active:750132kB inactive:403472kB present:1167812kB pages_scanned:645111 all_unreclaimable? no

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 53*4kB 26*8kB 4*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40484kB

HighMem: 54*4kB 42*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 728kB

Swap cache: add 15879, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1393 or a child

Killed process 29718 (sh)

printk: 39 messages suppressed.

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

Out of memory: kill process 27480 (make) score 1389 or a child

Killed process 29649 (sh)

 [<c016ee9f>] dput+0x98/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 168   Cold: hi:   62, btch:  15 usd:  44

CPU    1: Hot: hi:  186, btch:  31 usd: 163   Cold: hi:   62, btch:  15 usd:  47

CPU    2: Hot: hi:  186, btch:  31 usd: 176   Cold: hi:   62, btch:  15 usd:  10

CPU    3: Hot: hi:  186, btch:  31 usd: 157   Cold: hi:   62, btch:  15 usd:   9

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:  12

CPU    1: Hot: hi:  186, btch:  31 usd: 168   Cold: hi:   62, btch:  15 usd:   4

CPU    2: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 175   Cold: hi:   62, btch:  15 usd:   5

Active:276616 inactive:178743 dirty:0 writeback:1 unstable:0

 free:12391 slab:20083 mapped:5 pagetables:15092 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2768kB inactive:1416kB present:16224kB pages_scanned:99113 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40840kB min:3740kB low:4672kB high:5608kB active:331716kB inactive:331412kB present:892320kB pages_scanned:56631 all_unreclaimable? no

lowmem_reserve[]: 0 0 9123

HighMem free:620kB min:512kB low:1736kB high:2960kB active:594388kB inactive:559728kB present:1167812kB pages_scanned:645833 all_unreclaimable? no

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 60*4kB 45*8kB 11*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40808kB

HighMem: 26*4kB 36*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 568kB

Swap cache: add 15880, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1358 or a child

Killed process 29719 (sh)

printk: 14 messages suppressed.

fixdep invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c01521d2>] vma_link+0xc1/0xcb

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 168   Cold: hi:   62, btch:  15 usd:  44

CPU    1: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  39

CPU    2: Hot: hi:  186, btch:  31 usd: 176   Cold: hi:   62, btch:  15 usd:  10

CPU    3: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:  10

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:  12

CPU    1: Hot: hi:  186, btch:  31 usd: 169   Cold: hi:   62, btch:  15 usd:  12

CPU    2: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 183   Cold: hi:   62, btch:  15 usd:  13

Active:323664 inactive:131522 dirty:0 writeback:2 unstable:0

 free:12396 slab:20081 mapped:5 pagetables:15086 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2768kB inactive:1416kB present:16224kB pages_scanned:99113 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:41032kB min:3740kB low:4672kB high:5608kB active:226936kB inactive:433728kB present:892320kB pages_scanned:543471 all_unreclaimable? no

lowmem_reserve[]: 0 0 9123

HighMem free:448kB min:512kB low:1736kB high:2960kB active:891756kB inactive:263964kB present:1167812kB pages_scanned:3110697 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 114*4kB 49*8kB 11*16kB 1*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 41056kB

HighMem: 0*4kB 34*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 448kB

Swap cache: add 15880, delete 15878, find 2894/4023, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] <4>cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0168243>] may_open+0x4e/0x21a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c016001c>] do_filp_open+0x32/0x39

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  56

CPU    1: Hot: hi:  186, btch:  31 usd:  22   Cold: hi:   62, btch:  15 usd:  52

CPU    2: Hot: hi:  186, btch:  31 usd:  14   Cold: hi:   62, btch:  15 usd:  17

CPU    3: Hot: hi:  186, btch:  31 usd: 111   Cold: hi:   62, btch:  15 usd:  25

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  40   Cold: hi:   62, btch:  15 usd:  26

CPU    1: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  56

CPU    2: Hot: hi:  186, btch:  31 usd:  46   Cold: hi:   62, btch:  15 usd:  12

CPU    3: Hot: hi:  186, btch:  31 usd:   6   Cold: hi:   62, btch:  15 usd:  31

Active:226007 inactive:230621 dirty:0 writeback:0 unstable:0

 free:12148 slab:20245 mapped:33 pagetables:15092 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2812kB inactive:1372kB present:16224kB pages_scanned:99561 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40208kB min:3740kB low:4672kB high:5608kB active:329140kB inactive:332944kB present:892320kB pages_scanned:1388470 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:280kB min:512kB low:1736kB high:2960kB active:572076kB inactive:588168kB present:1167812kB pages_scanned:2854683 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 8*4kB 18*8kB 2*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40208kB

HighMem: 16*4kB 1*8kB 3*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 280kB

Swap cache: add 15934, delete 15934, find 2894/4029, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27480 (make) score 1354 or a child

Killed process 29650 (sh)

cc1 invoked oom-killer: gfp_mask=0x280d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0150a47>] do_anonymous_page+0x3e/0x1e3

 [<c0151251>] __handle_mm_fault+0x1a1/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee9f>] dput+0x98/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  56

CPU    1: Hot: hi:  186, btch:  31 usd:  22   Cold: hi:   62, btch:  15 usd:  52

CPU    2: Hot: hi:  186, btch:  31 usd:  14   Cold: hi:   62, btch:  15 usd:  17

CPU    3: Hot: hi:  186, btch:  31 usd: 111   Cold: hi:   62, btch:  15 usd:  25

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  40   Cold: hi:   62, btch:  15 usd:  26

CPU    1: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  56

CPU    2: Hot: hi:  186, btch:  31 usd:  46   Cold: hi:   62, btch:  15 usd:  12

CPU    3: Hot: hi:  186, btch:  31 usd:   6   Cold: hi:   62, btch:  15 usd:  31

Active:225943 inactive:230720 dirty:0 writeback:0 unstable:0

 free:12148 slab:20245 mapped:33 pagetables:15092 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2812kB inactive:1372kB present:16224kB pages_scanned:99561 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40208kB min:3740kB low:4672kB high:5608kB active:329140kB inactive:332944kB present:892320kB pages_scanned:1388470 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:280kB min:512kB low:1736kB high:2960kB active:571820kB inactive:588564kB present:1167812kB pages_scanned:2871131 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 8*4kB 18*8kB 2*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40208kB

HighMem: 16*4kB 1*8kB 3*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 280kB

Swap cache: add 15934, delete 15934, find 2894/4029, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x280d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0150a47>] do_anonymous_page+0x3e/0x1e3

 [<c0151251>] __handle_mm_fault+0x1a1/0x2bc

 [<c0152734>] vma_merge+0x176/0x184

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  56

CPU    1: Hot: hi:  186, btch:  31 usd:  22   Cold: hi:   62, btch:  15 usd:  52

CPU    2: Hot: hi:  186, btch:  31 usd:  14   Cold: hi:   62, btch:  15 usd:  17

CPU    3: Hot: hi:  186, btch:  31 usd: 111   Cold: hi:   62, btch:  15 usd:  25

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  40   Cold: hi:   62, btch:  15 usd:  26

CPU    1: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  56

CPU    2: Hot: hi:  186, btch:  31 usd:  46   Cold: hi:   62, btch:  15 usd:  12

CPU    3: Hot: hi:  186, btch:  31 usd:   6   Cold: hi:   62, btch:  15 usd:  31

Active:225911 inactive:230751 dirty:0 writeback:0 unstable:0

 free:12148 slab:20245 mapped:33 pagetables:15092 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2812kB inactive:1372kB present:16224kB pages_scanned:99561 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40208kB min:3740kB low:4672kB high:5608kB active:329140kB inactive:332944kB present:892320kB pages_scanned:1388470 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:280kB min:512kB low:1736kB high:2960kB active:571692kB inactive:588688kB present:1167812kB pages_scanned:2885403 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 8*4kB 18*8kB 2*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40208kB

HighMem: 16*4kB 1*8kB 3*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 280kB

Swap cache: add 15934, delete 15934, find 2894/4029, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1324 or a child

Killed process 29720 (sh)

Out of memory: kill process 27480 (make) score 1320 or a child

Killed process 29654 (sh)

Out of memory: kill process 27480 (make) score 1320 or a child

Killed process 29654 (sh)

Out of memory: kill process 27480 (make) score 1320 or a child

Killed process 29656 (sh)

Out of memory: kill process 27293 (make) score 1290 or a child

Killed process 29721 (sh)

printk: 123 messages suppressed.

cc1 invoked oom-killer: gfp_mask=0x280d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0150a47>] do_anonymous_page+0x3e/0x1e3

 [<c0151251>] __handle_mm_fault+0x1a1/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01639a5>] sys_fstat64+0x1e/0x23

 [<c01156edd:  12

CPU    3: Hot: hi:  186, btch:  31 usd:  75   Cold: hi:   62, btch:  15 usd:  14

Active:229731 inactive:226658 dirty:0 writeback:0 unstable:0

 free:12227 slab:20235 mapped:28 pagetables:15068 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2840kB inactive:1344kB present:16224kB pages_scanned:99945 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40208kB min:3740kB low:4672kB high:5608kB active:337724kB inactive:325720kB present:892320kB pages_scanned:1546372 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:596kB min:512kB low:1736kB high:2960kB active:578360kB inactive:579568kB present:1167812kB pages_scanned:1848819 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 8*4kB 18*8kB 2*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40208kB

HighMem: 77*4kB 10*8kB 3*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 596kB

Swap cache: add 15935, delete 15934, find 2894/4029, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1255 or a child

Killed process 29722 (sh)

Out of memory: kill process 27293 (make) score 1255 or a child

Killed process 29723 (sh)

Out of memory: kill process 27480 (make) score 1251 or a child

Killed process 29658 (sh)

Out of memory: kill process 27293 (make) score 1221 or a child

Killed process 29724 (sh)

__alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  73   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd:  58   Cold: hi:   62, btch:  15 usd:  53

CPU    2: Hot: hi:  186, btch:  31 usd:  14   Cold: hi:   62, btch:  15 usd:  17

CPU    3: Hot: hi:  186, btch:  31 usd: 128   Cold: hi:   62, btch:  15 usd:  27

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 185   Cold: hi:   62, btch:  15 usd:  15

CPU    1: Hot: hi:  186, btch:  31 usd:  70   Cold: hi:   62, btch:  15 usd:  56

CPU    2: Hot: hi:  186, btch:  31 usd:  46   Cold: hi:   62, btch:  15 usd:  12

CPU    3: Hot: hi:  186, btch:  31 usd: 161   Cold: hi:   62, btch:  15 usd:   2

Active:264200 inactive:192785 dirty:0 writebprintk: 899 messages suppressed.

fixdep invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c014a575>] mark_page_accessed+0x1c/0x30

 [<c017cb7b>] __find_get_block+0x3d/0x45

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c01521d2>] vma_link+0xc1/0xcb

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  85   Cold: hi:   62, btch:  15 usd:  57

CPU    1: Hot: hi:  186, btch:  31 usd:  58   Cold: hi:   62, btch:  15 usd:  53

CPU    2: Hot: hi:  186, btch:  31 usd:  14   Cold: hi:   62, btch:  15 usd:  17

CPU    3: Hot: hi:  186, btch:  31 usd: 128   Cold: hi:   62, btch:  15 usd:  27

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  11

CPU    1: Hot: hi:  186, btch:  31 usd:  70   Cold: hi:   62, btch:  15 usd:  57

CPU    2: Hot: hi:  186, btch:  31 usd:  46   Cold: hi:   62, btch:  15 usd:  14

CPU    3: Hot: hi:  186, btch:  31 usd: 161   Cold: hi:   62, btch:  15 usd:   2

Active:313810 inactive:143059 dirty:0 writeback:1 unstable:0

 free:12275 slab:20191 mapped:27 pagetables:15032 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:2956kB inactive:1228kB present:16224kB pages_scanned:103145 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40192kB min:3740kB low:4672kB high:5608kB active:411128kB inactive:252272kB present:892320kB pages_scanned:2382731 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:804kB min:512kB low:1736kB high:2960kB active:790792kB inactive:369048kB present:1167812kB pages_scanned:3403082 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 8*4kB 16*8kB 2*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40192kB

HighMem: 58*4kB 38*8kB 3*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 744kB

Swap cache: add 15935, delete 15934, find 2894/4029, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27293 (make) score 1152 or a child

Killed process 29725 (sh)

Out of memory: kill process 27293 (make) score 1152 or a child

Out of memory: kill process 27293 (make) score 1152 or a child

Killed process 29726 (sh)

Out of memory: kill process 27480 (make) score 1148 or a child

Killed process 29663 (sh)

Killed process 29727 (sh)

printk: 210 messages suppressed.

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c0160d64>] sys_read+0x41/0x67

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  32

CPU    1: Hot: hi:  186, btch:  31 usd:  53   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  17   Cold: hi:   62, btch:  15 usd:  58

CPU    3: Hot: hi:  186, btch:  31 usd:  40   Cold: hi:   62, btch:  15 usd:  59

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  35

CPU    1: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  18

CPU    2: Hot: hi:  186, btch:  31 usd:  59   Cold: hi:   62, btch:  15 usd:  55

CPU    3: Hot: hi:  186, btch:  31 usd:  46   Cold: hi:   62, btch:  15 usd:  28

Active:225127 inactive:231009 dirty:0 writeback:0 unstable:0

 free:12222 slab:20179 mapped:45 pagetables:15000 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:3016kB inactive:1168kB present:16224kB pages_scanned:104681 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40040kB min:3740kB low:4672kB high:5608kB active:322240kB inactive:342616kB present:892320kB pages_scanned:1345730 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:744kB min:512kB low:1736kB high:2960kB active:575252kB inactive:580252kB present:1167812kB pages_scanned:1889895 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 3*8kB 1*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40040kB

HighMem: 97*4kB 27*8kB 4*16kB 2*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 860kB

Swap cache: add 15972, delete 15972, find 2894/4033, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27282 (make) score 1119 or a child

Killed process 27290 (make)

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  32

CPU    1: Hot: hi:  186, btch:  31 usd:  53   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  17   Cold: hi:   62, btch:  15 usd:  58

CPU    3: Hot: hi:  186, btch:  31 usd:  40   Cold: hi:   62, btch:  15 usd:  59

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  36

CPU    1: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  18

CPU    2: Hot: hi:  186, btch:  31 usd:  59   Cold: hi:   62, btch:  15 usd:  55

CPU    3: Hot: hi:  186, btch:  31 usd:  46   Cold: hi:   62, btch:  15 usd:  29

Active:230009 inactive:226124 dirty:0 writeback:0 unstable:0

 free:12222 slab:20179 mapped:45 pagetables:15000 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:3016kB inactive:1168kB present:16224kB pages_scanned:104681 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40040kB min:3740kB low:4672kB high:5608kB active:322240kB inactive:342616kB present:892320kB pages_scanned:1345730 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:744kB min:512kB low:1736kB high:2960kB active:594780kB inactive:560840kB present:1167812kB pages_scanned:2066139 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 3*8kB 1*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40040kB

HighMem: 97*4kB 27*8kB 4*16kB 2*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 860kB

Swap cache: add 15972, delete 15972, find 2894/4033, race 0+1

Free swap  = 0kB

Total swap = 8024kB

as invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c016000f>] do_filp_open+0x25/0x39

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  32

CPU    1: Hot: hi:  186, btch:  31 usd:  53   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  17   Cold: hi:   62, btch:  15 usd:  58

CPU    3: Hot: hi:  186, btch:  31 usd:  40   Cold: hi:   62, btch:  15 usd:  59

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  12

CPU    1: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  18

CPU    2: Hot: hi:  186, btch:  31 usd:  59   Cold: hi:   62, btch:  15 usd:  55

CPU    3: Hot: hi:  186, btch:  31 usd:  46   Cold: hi:   62, btch:  15 usd:  57

Active:231062 inactive:225148 dirty:0 writeback:0 unstable:0

 free:12222 slab:20179 mapped:45 pagetables:15000 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:3016kB inactive:1168kB present:16224kB pages_scanned:104681 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40040kB min:3740kB low:4672kB high:5608kB active:322260kB inaccanned:1345834 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:744kB min:512kB low:1736kB high:2960kB active:598972kB inactive:556808kB present:1167812kB pages_scanned:2175146 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 3*8kB 1*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40040kB

HighMem: 97*4kB 27*8kB 4*16kB 2*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 860kB

Swap cache: add 15972, delete 15972, find 2894/4033, race 0+1

Free swap  = 0kB

Total swap = 8024kB

fixdep invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee9f>] dput+0x98/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  32

CPU    1: Hot: hi:  186, btch:  31 usd:  53   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  17   Cold: hi:   62, btch:  15 usd:  58

CPU    3: Hot: hi:  186, btch:  31 usd:  40   Cold: hi:   62, btch:  15 usd:  59

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  12

CPU    1: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  18

CPU    2: Hot: hi:  186, btch:  31 usd:  59   Cold: hi:   62, btch:  15 usd:  55

CPU    3: Hot: hi:  186, btch:  31 usd:  46   Cold: hi:   62, btch:  15 usd:  57

Active:231062 inactive:225147 dirty:0 writeback:0 unstable:0

 free:12222 slab:20179 mapped:45 pagetables:15000 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:3016kB inactive:1168kB present:16224kB pages_scanned:104681 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40040kB min:3740kB low:4672kB high:5608kB active:322260kB inactive:342616kB present:892320kB pages_scanned:1345834 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:744kB min:512kB low:1736kB high:2960kB active:598972kB inactive:556804kB present:1167812kB pages_scanned:2186474 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 3*8kB 1*16kB 0*32kB 1*6kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40040kB

HighMem: 97*4kB 27*8kB 4*16kB 2*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 860kB

Swap cache: add 15972, delete 15972, find 2894/4033, race 0+1

Free swap  = 0kB

Total swap = 8024kB

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014a098>] blockable_page_cache_readahead+0x4a/0x9a

 [<c014a21a>] page_cache_readahead+0x8f/0x159

 [<c0144a29>] do_generic_mapping_read+0x125/0x42d

 [<c0144fc1>] generic_file_aio_read+0x19f/0x1c3

 [<c0144d31>] file_read_actor+0x0/0xf1

 [<c0160986>] do_sync_read+0xbf/0xfc

 [<c01d14e9>] copy_to_user+0x42/0x4a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c012e872>] autoremove_wake_function+0x0/0x33

 [<c0115a01>] do_page_fault+0x314/0x5f7

 [<c0160a74>] vfs_read+0xb1/0x131

 [<c0160d64>] sys_read+0x41/0x67

 [<c01030a4>] sysenter_past_esp+0x5d/0x81

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  32

CPU    1: Hot: hi:  186, btch:  31 usd:  53   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  17   Cold: hi:   62, btch:  15 usd:  58

CPU    3: Hot: hi:  186, btch:  31 usd:  40   Cold: hi:   62, btch:  15 usd:  59

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  12

CPU    1: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  18

CPU    2: Hot: hi:  186, btch:  31 usd:  59   Cold: hi:   62, btch:  15 usd:  55

CPU    3: Hot: hi:  186, btch:  31 usd:  46   Cold: hi:   62, btch:  15 usd:  57

Active:231062 inactive:225180 dirty:0 writeback:0 unstable:0

 free:12222 slab:20179 mapped:45 pagetables:15000 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:3016kB inactive:1168kB present:16224kB pages_scanned:104681 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40040kB min:3740kB low:4672kB high:5608kB active:322260kB inactive:342616kB present:892320kB pages_scanned:1345834 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:744kB min:512kB low:1736kB high:2960kB active:598972kB inactive:556808kB present:1167812kB pages_scanned:2198154 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 3*8kB 1*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40040kB

HighMem: 97*4kB 27*8kB 4*16kB 2*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 860kB

Swap cache: amask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  32

CPU    1: Hot: hi:  186, btch:  31 usd:  53   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  17   Cold: hi:   62, btch:  15 usd:  58

CPU    3: Hot: hi:  186, btch:  31 usd:  40   Cold: hi:   62, btch:  15 usd:  59

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  12

CPU    1: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  18

CPU    2: Hot: hi:  186, btch:  31 usd:  59   Cold: hi:   62, btch:  15 usd:  55

CPU    3: Hot: hi:  186, btch:  31 usd:  46   Cold: hi:   62, btch:  15 usd:  57

Active:231062 inactive:225148 dirty:0 writeback:0 unstable:0

 free:12222 slab:20179 mapped:45 pagetables:15000 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:3016kB inactive:1168kB present:16224kB pages_scanned:104681 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40040kB min:3740kB low:4672kB high:5608kB active:322260kB inactive:342616kB present:892320kB pages_scanned:1345834 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:744kB min:512kB low:1736kB high:2960kB active:598972kB inactive:556808kB present:1167812kB pages_scanned:2200426 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 3*8kB 1*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40040kB

HighMem: 97*4kB 27*8kB 4*16kB 2*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 860kB

Swap cache: add 15972, delete 15972, find 2894/4033, race 0+1

Free swap  = 0kB

Total swap = 8024kB

fixdep invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<ctch:  31 usd:  53   Cold: hi:   62, btch:  15 usd:  61

CPU    2: Hot: hi:  186, btch:  31 usd:  19   Cold: hi:   62, btch:  15 usd:  61

CPU    3: Hot: hi:  186, btch:  31 usd:  41   Cold: hi:   62, btch:  15 usd:  54

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 158   Cold: hi:   62, btch:  15 usd:  22

CPU    1: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  18

CPU    2: Hot: hi:  186, btch:  31 usd:  58   Cold: hi:   62, btch:  15 usd:  12

CPU    3: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  51

Active:226924 inactive:228672 dirty:0 writeback:0 unstable:0

 free:12296 slab:20161 mapped:61 pagetables:14995 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:3024kB inactive:1160kB present:16224kB pages_scanned:104745 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40344kB min:3740kB low:4672kB high:5608kB active:331652kB inactive:330064kB present:892320kB pages_scanned:448040 all_unreclaimable? no

lowmem_reserve[]: 0 0 9123

HighMem free:736kB min:512kB low:1736kB high:2960kB active:575212kB inactive:580992kB present:1167812kB pages_scanned:616655 all_unreclaimable? no

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 72*4kB 4*8kB 1*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40336kB

HighMem: 67*4kB 20*8kB 4*16kB 2*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 684kB

Swap cache: add 15972, delete 15972, find 2894/4033, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27480 (make) score 1113 or a child

Killed process 29664 (sh)

printk: 25 messages suppressed.

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0168243>] may_open+0x4e/0x21a

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c016001c>] do_filp_open+0x32/0x39

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  49

CPU    1: Hot: hi:  186, btch:  31 usd:  55   Cold: hi:   62, btch:  15 usd:  28

CPU    2: Hot: hi:  186, btch:  31 usd:  15   Cold: hi:   62, btch:  15 usd:  11

CPU    3: Hot: hi:  186, btch:  31 usd:  71   Cold: hi:   62, btch:  15 usd:  14

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 158   Cold: hi:   62, btch:  15 usd:  48

CPU    1: Hot: hi:  186, btch:  31 usd:  70   Cold: hi:   62, btch:  15 usd:  19

CPU    2: Hot: hi:  186, btch:  31 usd:  55   Cold: hi:   62, btch:  15 usd:  19

CPU    3: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:   1

Active:163555 inactive:291062 dirty:0 writeback:0 unstable:0

 free:12193 slab:20135 mapped:33 pagetables:14989 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:3024kB inactive:1160kB present:16224kB pages_scanned:104937 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40104kB min:3740kB low:4672kB high:5608kB active:4760kB inactive:656180kB present:892320kB pages_scanned:1463225 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:564kB min:512kB low:1736kB high:2960kB active:623968kB inactive:529248kB present:1167812kB pages_scanned:1139257 all_unreclaimable? no

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 11*8kB 1*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40104kB

HighMem: 53*4kB 10*8kB 5*16kB 2*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 564kB

Swap cache: add 15972, delete 15972, find 2894/4033, race 0+1

Free swap  = 0kB

Total swap = 8024kB

Out of memory: kill process 27441 (make) score 1092 or a child

Killed process 27555 (sh)

make invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] <4>cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee9f>] dput+0x98/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:  49

CPU    1: Hot: hi:  186, btch:  31 usd:  55   Cold: hi:   62, btch:  15 usd:  28

CPU    2: Hot: hi:  186, btch:  31 usd:  15   Cold: hi:   62, btch:  15 usd:  11

CPU    3: Hot: hi:  186, btch:  31 usd:  71   Cold: hi:   62, btch:  15 usd:  14

HighMem per-cpu:

CPU    0: Hot: hi:  186, btch:  31 usd: 158   Cold: hi:   62, btch:  15 usd:  49

CPU    1: Hot: hi:  186, btch:  31 usd:  70   Cold: hi:   62, btch:  15 usd:   5

CPU    2: Hot: hi:  186, btch:  31 usd:  55   Cold: hi:   62, btch:  15 usd:  19

CPU    3: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:   1

Active:111649 inactive:343085 dirty:0 writeback:0 unstable:0

 free:12193 slab:20135 mapped:36 pagetables:14989 bounce:0

DMA free:8104kB min:68kB low:84kB high:100kB active:3024kB inactive:1160kB present:16224kB pages_scanned:104937 all_unreclaimable? yes

lowmem_reserve[]: 0 871 2011

Normal free:40104kB min:3740kB low:4672kB high:5608kB active:4784kB inactive:656088kB present:892320kB pages_scanned:1463225 all_unreclaimable? yes

lowmem_reserve[]: 0 0 9123

HighMem free:564kB min:512kB low:1736kB high:2960kB active:438788kB inactive:715092kB present:1167812kB pages_scanned:1888227 all_unreclaimable? yes

lowmem_reserve[]: 0 0 0

DMA: 4*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8104kB

Normal: 0*4kB 11*8kB 1*16kB 0*32kB 1*64kB 0*128kB 12*256kB 4*512kB 2*1024kB 0*2048kB 8*4096kB = 40104kB

HighMem: 38*4kB 10*8kB 5*16kB 2*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 504kB

Swap cache: add 15972, delete 15972, find 2894/4033, race 0+1

Free swap  = 0kB

Total swap = 8024kB

cc1 invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

 [<c0147386>] out_of_memory+0x70/0xf6

 [<c01484c4>] __alloc_pages+0x21b/0x2a8

 [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a

 [<c0148137>] buffered_rmqueue+0x107/0x11f

 [<c014535b>] filemap_nopage+0x164/0x30d

 [<c0150c7d>] do_no_page+0x91/0x2fb

 [<c0151201>] __handle_mm_fault+0x151/0x2bc

 [<c0115990>] do_page_fault+0x2a3/0x5f7

 [<c016ee33>] dput+0x2c/0x131

 [<c0173168>] mntput_no_expire+0x11/0x6e

 [<c0160424>] sys_close+0x5b/0x95

 [<c01156ed>] do_page_fault+0x0/0x5f7

 [<c03336c4>] error_code+0x7c/0x84

 [<c0330000>] packet_rcv+0xfd/0x2d7

 =======================

DMA per-cpu:

CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:(bot:conmon-payload) disconnected
   0

CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0

Normal per-cpu:

CPU    0: Hot: hi:  186, btch:  3

--------------050801060303080807010008
Content-Type: text/plain;
 name="dotconfig"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dotconfig"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23-rc3-mm1-autokern1
# Wed Aug 22 20:48:20 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SWAP_PREFETCH=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CONTAINERS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_KPAGEMAP=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# Processor type and features
#
# CONFIG_TICK_ONESHOT is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_SMP=y
# CONFIG_X86_PC is not set
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
CONFIG_X86_GENERICARCH=y
# CONFIG_X86_ES7000 is not set
# CONFIG_PARAVIRT is not set
CONFIG_X86_CYCLONE_TIMER=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_BKL=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=m
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
# CONFIG_NUMA is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
# CONFIG_IRQBALANCE is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_SMP_POSSIBLE=y
CONFIG_SUSPEND=y
CONFIG_HIBERNATION_SMP_POSSIBLE=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_ASUS=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_ACPI_BLACKLIST_YEAR=2001
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
# CONFIG_APM_DO_ENABLE is not set
CONFIG_APM_CPU_IDLE=y
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set
# CONFIG_APM_REAL_MODE_POWER_OFF is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_POWERNOW_K6=m
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=m
CONFIG_X86_P4_CLOCKMOD=m
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=y
CONFIG_X86_LONGHAUL=y
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set

#
# CPU idle PM support
#
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_COMPAQ=m
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
CONFIG_HOTPLUG_PCI_IBM=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IP_VS=m
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK is not set
# CONFIG_NF_CONNTRACK_ENABLED is not set
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_XTABLES=m
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set

#
# IP: Netfilter Configuration
#
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_IPRANGE=m
CONFIG_IP_NF_MATCH_TOS=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
# CONFIG_IP_NF_MATCH_AH is not set
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_OWNER=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_TOS=m
CONFIG_IP_NF_TARGET_ECN=m
# CONFIG_IP_NF_TARGET_TTL is not set
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration (EXPERIMENTAL)
#
# CONFIG_IP6_NF_QUEUE is not set
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_OWNER=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
# CONFIG_IP6_NF_MATCH_AH is not set
# CONFIG_IP6_NF_MATCH_MH is not set
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_LOG=m
# CONFIG_IP6_NF_TARGET_REJECT is not set
CONFIG_IP6_NF_MANGLE=m
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_RAW=m

#
# Bridge: Netfilter Configuration
#
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
# CONFIG_BRIDGE_EBT_ULOG is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_BRIDGE=m
CONFIG_VLAN_8021Q=m
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
CONFIG_NET_SCHED=y
CONFIG_NET_SCH_FIFO=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_RR is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_CLS_POLICE=y
CONFIG_NET_CLS_IND=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=m
CONFIG_BT_HCIUSB_SCO=y
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIBCM203X=m
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_EXT=y
# CONFIG_MAC80211 is not set
CONFIG_IEEE80211=m
# CONFIG_IEEE80211_DEBUG is not set
# CONFIG_IEEE80211_CRYPT_WEP is not set
CONFIG_IEEE80211_CRYPT_CCMP=m
CONFIG_IEEE80211_CRYPT_TKIP=m
# CONFIG_IEEE80211_SOFTMAC is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
# CONFIG_MTD_DEBUG is not set
CONFIG_MTD_CONCAT=m
CONFIG_MTD_PARTITIONS=y
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=m
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_PNC2000 is not set
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_DILNETPC is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_DISKONCHIP is not set
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_CS553X is not set
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ONENAND is not set

#
# UBI - Unsorted block images
#
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_DEV_XD is not set
# CONFIG_PARIDE is not set
CONFIG_BLK_CPQ_DA=m
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SX8=m
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=m
# CONFIG_PHANTOM is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_IDEDISK_MULTI_MODE=y
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEFLOPPY=y
CONFIG_BLK_DEV_IDESCSI=m
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_WDC_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CY82C693=y
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_CS5535 is not set
CONFIG_BLK_DEV_HPT34X=y
# CONFIG_HPT34X_AUTODMA is not set
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=y
# CONFIG_PDC202XX_BURST is not set
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_IDE_ARM is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
# CONFIG_BLK_DEV_ALI14XX is not set
# CONFIG_BLK_DEV_DTC2278 is not set
# CONFIG_BLK_DEV_HT6560B is not set
# CONFIG_BLK_DEV_QD65XX is not set
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_3W_9XXX=m
# CONFIG_SCSI_7000FASST is not set
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AHA152X=m
# CONFIG_SCSI_AHA1542 is not set
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
# CONFIG_SCSI_OMIT_FLASHPOINT is not set
CONFIG_SCSI_DMX3191D=m
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=m
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_PSI240I is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
CONFIG_SCSI_QLOGIC_1280=m
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_SEAGATE is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=m
CONFIG_SATA_SVW=m
CONFIG_ATA_PIIX=m
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIL24=m
CONFIG_SATA_SIS=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m
CONFIG_SATA_INIC162X=m
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=m
CONFIG_PATA_CS5535=m
CONFIG_PATA_CYPRESS=m
CONFIG_PATA_EFAR=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT821X=m
CONFIG_PATA_IT8213=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_LEGACY=m
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_MPIIX=m
CONFIG_PATA_OLDPIIX=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NS87410=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PDC_OLD=m
CONFIG_PATA_QDI=m
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RZ1000=m
CONFIG_PATA_SC1200=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=m
CONFIG_PATA_WINBOND_VLB=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
# CONFIG_MD_RAID456 is not set
CONFIG_MD_MULTIPATH=m
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_EMC=m
# CONFIG_DM_MULTIPATH_RDAC is not set
# CONFIG_DM_DELAY is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LAN=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
# CONFIG_I2O_BUS is not set
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_IFB is not set
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
# CONFIG_EL1 is not set
# CONFIG_EL2 is not set
# CONFIG_ELPLUS is not set
# CONFIG_EL16 is not set
# CONFIG_EL3 is not set
# CONFIG_3C515 is not set
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
# CONFIG_LANCE is not set
CONFIG_NET_VENDOR_SMC=y
# CONFIG_WD80x3 is not set
# CONFIG_ULTRA is not set
CONFIG_SMC9194=m
CONFIG_NET_VENDOR_RACAL=y
# CONFIG_NI52 is not set
# CONFIG_NI65 is not set
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_TULIP=m
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
# CONFIG_ULI526X is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
CONFIG_HP100=m
# CONFIG_NET_ISA is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
# CONFIG_PCNET32_NAPI is not set
CONFIG_AMD8111_ETH=m
CONFIG_AMD8111E_NAPI=y
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_ADAPTEC_STARFIRE_NAPI=y
# CONFIG_AC3200 is not set
CONFIG_APRICOT=m
CONFIG_B44=m
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=m
# CONFIG_FORCEDETH_NAPI is not set
# CONFIG_CS89x0 is not set
# CONFIG_DGRS is not set
CONFIG_EEPRO100=m
CONFIG_E100=m
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_SIS900=m
CONFIG_EPIC100=m
# CONFIG_SUNDANCE is not set
CONFIG_TLAN=m
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
# CONFIG_VIA_RHINE_NAPI is not set
# CONFIG_SC92031 is not set
CONFIG_NET_POCKET=y
# CONFIG_ATP is not set
# CONFIG_DE600 is not set
# CONFIG_DE620 is not set
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=m
CONFIG_E1000=m
CONFIG_E1000_NAPI=y
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
# CONFIG_E1000E is not set
CONFIG_NS83820=m
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
CONFIG_R8169_NAPI=y
# CONFIG_R8169_VLAN is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=m
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
CONFIG_IXGB=m
CONFIG_IXGB_NAPI=y
CONFIG_S2IO=m
CONFIG_S2IO_NAPI=y
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_MLX4_CORE is not set
CONFIG_TR=y
CONFIG_IBMTR=m
CONFIG_IBMOL=m
CONFIG_IBMLS=m
CONFIG_3C359=m
CONFIG_TMS380TR=m
CONFIG_TMSPCI=m
CONFIG_SKISA=m
CONFIG_PROTEON=m
CONFIG_ABYSS=m
CONFIG_SMCTR=m

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET_MII=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=m
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=m
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=m
# CONFIG_ATM_ZATM is not set
CONFIG_ATM_NICSTAR=m
# CONFIG_ATM_NICSTAR_USE_SUNI is not set
# CONFIG_ATM_NICSTAR_USE_IDT77105 is not set
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
# CONFIG_ATM_IA is not set
CONFIG_ATM_FORE200E_MAYBE=m
# CONFIG_ATM_FORE200E_PCA is not set
CONFIG_ATM_HE=m
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m
CONFIG_NET_FC=y
# CONFIG_SHAPER is not set
CONFIG_NETCONSOLE=m
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_ISDN=m
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
# CONFIG_ISDN_DIVERSION is not set

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
CONFIG_HISAX_NO_LLC=y
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_0=y
CONFIG_HISAX_16_3=y
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_AVM_A1=y
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_IX1MICROR2=y
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_ASUSCOM=y
CONFIG_HISAX_TELEINT=y
CONFIG_HISAX_HFCS=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_SPORTSTER=y
CONFIG_HISAX_MIC=y
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
CONFIG_HISAX_ISURF=y
CONFIG_HISAX_HSTSAPHIR=y
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
CONFIG_HISAX_W6692=y
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_ENTERNOW_PCI=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
CONFIG_HISAX_HFCUSB=m
# CONFIG_HISAX_HFC4S8S is not set
CONFIG_HISAX_FRITZ_PCIPNP=m
CONFIG_HISAX_HDLC=y

#
# Active cards
#
CONFIG_ISDN_DRV_ICN=m
CONFIG_ISDN_DRV_PCBIT=m
CONFIG_ISDN_DRV_SC=m
CONFIG_ISDN_DRV_ACT2000=m
# CONFIG_HYSDN is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
CONFIG_ISDN_CAPI_CAPIFS=m
CONFIG_ISDN_CAPI_CAPIDRV=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
# CONFIG_ISDN_DRV_AVMB1_B1ISA is not set
# CONFIG_ISDN_DRV_AVMB1_B1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_T1ISA is not set
# CONFIG_ISDN_DRV_AVMB1_B1PCMCIA is not set
# CONFIG_ISDN_DRV_AVMB1_T1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
CONFIG_CAPI_EICON=y
CONFIG_ISDN_DIVAS=m
CONFIG_ISDN_DIVAS_BRIPCI=y
CONFIG_ISDN_DIVAS_PRIPCI=y
CONFIG_ISDN_DIVAS_DIVACAPI=m
CONFIG_ISDN_DIVAS_USERIDI=m
CONFIG_ISDN_DIVAS_MAINT=m
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_TSDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_INPORT=m
CONFIG_MOUSE_ATIXL=y
CONFIG_MOUSE_LOGIBM=m
CONFIG_MOUSE_PC110PAD=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=m
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_UCB1400 is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_ESPSERIAL is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_MOXA_SMARTIO_NEW is not set
# CONFIG_ISI is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
# CONFIG_SYNCLINK_GT is not set
CONFIG_N_HDLC=m
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
CONFIG_STALDRV=y
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
# CONFIG_TIPAR is not set
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_NVRAM=m
CONFIG_RTC=y
CONFIG_DTLK=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=m
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_I810=m
CONFIG_DRM_I830=m
CONFIG_DRM_I915=m
CONFIG_DRM_MGA=m
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_I810=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_PROSAVAGE=m
CONFIG_I2C_SAVAGE4=m
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m
CONFIG_I2C_VOODOO3=m
# CONFIG_I2C_PCA_ISA is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
CONFIG_SENSORS_PCF8574=m
# CONFIG_SENSORS_PCA9539 is not set
CONFIG_SENSORS_PCF8591=m
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_FSCHER=m
# CONFIG_SENSORS_FSCPOS is not set
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_VIA686A=m
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_CORE=m
# CONFIG_WATCHDOG_DEBUG_CORE is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_SC520_WDT=m
CONFIG_EUROTECH_WDT=m
CONFIG_IB700_WDT=m
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=m
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_SC1200_WDT=m
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=m
# CONFIG_SMSC37B787_WDT is not set
CONFIG_W83627HF_WDT=m
# CONFIG_W83697HF_WDT is not set
CONFIG_W83877F_WDT=m
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=m
# CONFIG_MIXCOMWD is not set
CONFIG_WDT=m
# CONFIG_WDT_501 is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m
CONFIG_WDT_501_PCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_PMS is not set
# CONFIG_VIDEO_BWQCAM is not set
# CONFIG_VIDEO_CQCAM is not set
# CONFIG_VIDEO_W9966 is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_TUNER_3036 is not set
# CONFIG_TUNER_TEA5761 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DPC is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_USBVISION is not set
CONFIG_VIDEO_USBVIDEO=m
CONFIG_USB_VICAM=m
CONFIG_USB_IBMCAM=m
CONFIG_USB_KONICAWC=m
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
CONFIG_VIDEO_OVCAMCHIP=m
CONFIG_USB_W9968CF=m
CONFIG_USB_OV511=m
CONFIG_USB_SE401=m
CONFIG_USB_SN9C102=m
CONFIG_USB_STV680=m
# CONFIG_USB_ZC0301 is not set
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
# CONFIG_USB_ZR364XX is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_CADET is not set
# CONFIG_RADIO_RTRACK is not set
# CONFIG_RADIO_RTRACK2 is not set
# CONFIG_RADIO_AZTECH is not set
# CONFIG_RADIO_GEMTEK is not set
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
# CONFIG_RADIO_SF16FMI is not set
# CONFIG_RADIO_SF16FMR2 is not set
# CONFIG_RADIO_TERRATEC is not set
# CONFIG_RADIO_TRUST is not set
# CONFIG_RADIO_TYPHOON is not set
# CONFIG_RADIO_ZOLTRIX is not set
CONFIG_USB_DSBR=m
# CONFIG_DVB_CORE is not set
CONFIG_DAB=y
CONFIG_USB_DABUSB=m

#
# Graphics support
#
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
CONFIG_VGASTATE=m
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I810=m
CONFIG_FB_I810_GTF=y
# CONFIG_FB_I810_I2C is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
CONFIG_MDA_CONSOLE=m
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_SB_COMMON=m

#
# ISA devices
#
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
# CONFIG_SND_ALS100 is not set
# CONFIG_SND_AZT2320 is not set
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4232 is not set
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_DT019X is not set
# CONFIG_SND_ES968 is not set
# CONFIG_SND_ES1688 is not set
# CONFIG_SND_ES18XX is not set
# CONFIG_SND_GUSCLASSIC is not set
# CONFIG_SND_GUSEXTREME is not set
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
# CONFIG_SND_MIRO is not set
# CONFIG_SND_SB8 is not set
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
# CONFIG_SND_SGALAXY is not set
# CONFIG_SND_SSCAPE is not set
# CONFIG_SND_WAVEFRONT is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
# CONFIG_SND_CA0106 is not set
CONFIG_SND_CMIPCI=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_EMU10K1=m
# CONFIG_SND_EMU10K1X is not set
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_FM801=m
# CONFIG_SND_FM801_TEA575X_BOOL is not set
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_HDSP=m
# CONFIG_SND_HDSPM is not set
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL=y
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_FIRMWARE_IN_KERNEL=y
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
# CONFIG_SND_VIA82XX_MODEM is not set
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
CONFIG_SND_YMFPCI_FIRMWARE_IN_KERNEL=y
# CONFIG_SND_AC97_POWER_SAVE is not set

#
# USB devices
#
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_USX2Y=m
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
CONFIG_HID_FF=y
CONFIG_HID_PID=y
CONFIG_LOGITECH_FF=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_THRUSTMASTER_FF=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_HIDDEV=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_SPLIT_ISO=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_DPCM=y
# CONFIG_USB_STORAGE_USBAT is not set
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
CONFIG_USB_MON=y

#
# USB port drivers
#
CONFIG_USB_USS720=m

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_AIRPRIME is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=m
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
# CONFIG_USB_SERIAL_CP2101 is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_HP4X is not set
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_DEBUG is not set
CONFIG_USB_EZUSB=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_AUERSWALD=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_BERRY_CHARGE is not set
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
# CONFIG_USB_GOTEMP is not set

#
# USB DSL modem support
#
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
# CONFIG_USB_CXACRU is not set
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISER4_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_RAMFS=y
# CONFIG_CONFIGFS_FS is not set

#
# Layered filesystems
#
# CONFIG_UNION_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_CRAMFS=m
CONFIG_VXFS_FS=m
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=m
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set
CONFIG_INSTRUMENTATION=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=m
# CONFIG_KPROBES is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
# CONFIG_PAGE_OWNER is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_UNWIND_INFO is not set
# CONFIG_PROFILE_LIKELY is not set
CONFIG_FORCED_INLINING=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DEBUG_SYNCHRO_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_WANT_EXTRA_DEBUG_INFORMATION is not set
# CONFIG_KGDB is not set
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_4KSTACKS is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_CAPABILITIES=y
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_586 is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_CRYPTO_DEV_GEODE=m

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=m
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y

--------------050801060303080807010008--
