Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbYGAWaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbYGAWaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbYGAWai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:30:38 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37831 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755298AbYGAWag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:30:36 -0400
X-Sasl-enc: Q0T1CCOo5Wew7d+IcO/czbuWj2DfNtKO7xxKYkU8PC8x 1214951434
Message-ID: <486AB006.7080808@imap.cc>
Date: Wed, 02 Jul 2008 00:30:30 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [2.6.25.8] "kswapd0: page allocation failure. order:3" in tcp_collapse
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Intel Pentium D940 system, Intel DQ965GF mainboard, 2 GB RAM, running an
x86_32 build of kernel release 2.6.25.8 with openSUSE 10.3 userland, produced
the message in the subject accompanied by a stack backtrace, seven times in a
row within a few milliseconds, during the nightly backup of a Windows system
through Bacula over the LAN. The backup did not report an error, though, and
everything else seems to be running normally, too.

The kernel is built with CONFIG_SLUB=y.

ts@xenon:~/kernel> uname -a
Linux xenon 2.6.25.8-testing #1 SMP PREEMPT Sun Jun 22 19:46:14 CEST 2008 i686 i686 i386 GNU/Linux
ts@xenon:~/kernel> uptime
 11:25pm  up 8 days  3:05,  3 users,  load average: 0.51, 0.62, 0.77
ts@xenon:~/kernel> slaptop
 Active / Total Objects (% used)    : 361572 / 398951 (90.6%)
 Active / Total Slabs (% used)      : 25567 / 25567 (100.0%)
 Active / Total Caches (% used)     : 53 / 58 (91.4%)
 Active / Total Size (% used)       : 159455.84K / 164085.54K (97.2%)
 Minimum / Average / Maximum Object : 0.01K / 0.41K / 4.44K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
151767 151248  99%    0.84K  16863        9    134904K ext3_inode_cache
 73500  72274  98%    0.16K   2940       25     11760K dentry
 59008  37022  62%    0.06K    922       64      3688K buffer_head
 26176  23505  89%    0.06K    409       64      1636K kmalloc-64
 19084  13645  71%    0.29K   1468       13      5872K radix_tree_node
 12190  11418  93%    0.09K    265       46      1060K vm_area_struct
 10540  10427  98%    0.05K    124       85       496K sysfs_dir_cache
  9680   8491  87%    0.25K    605       16      2420K kmalloc-256
  6144   5160  83%    0.02K     24      256        96K kmalloc-16
  4760   4570  96%    0.05K     56       85       224K anon_vma
  4096   4093  99%    0.01K      8      512        32K kmalloc-8
  3230   3065  94%    0.02K     19      170        76K Acpi-Namespace
  1920   1712  89%    0.03K     15      128        60K kmalloc-32
  1888   1415  74%    0.12K     59       32       236K kmalloc-128
  1785   1703  95%    0.05K     21       85        84K ext3_xattr
  1765   1760  99%    0.73K    353        5      1412K shmem_inode_cache

Excerpt from /var/log/messages:

Jul  1 23:15:41 xenon kernel: [166248.671993] kswapd0: page allocation failure. order:3, mode:0x4020
Jul  1 23:15:41 xenon kernel: [166248.671993] Pid: 185, comm: kswapd0 Not tainted 2.6.25.8-testing #1
Jul  1 23:15:41 xenon kernel: [166248.671993]  [<c01644cc>] __alloc_pages+0x2ec/0x308
Jul  1 23:15:41 xenon kernel: [166248.671993]  [<c017c35c>] __slab_alloc+0x1f2/0x575
Jul  1 23:15:41 xenon kernel: [166248.671993]  [<c017d3e0>] __kmalloc_track_caller+0x8d/0x105
Jul  1 23:15:41 xenon kernel: [166248.671993]  [<c02d3808>] ? tcp_collapse+0x136/0x331
Jul  1 23:15:41 xenon kernel: [166248.671993]  [<c02d3808>] ? tcp_collapse+0x136/0x331
Jul  1 23:15:41 xenon kernel: [166248.671993]  [<c02a4c3e>] __alloc_skb+0x4a/0x107
Jul  1 23:15:41 xenon kernel: [166248.671993]  [<c02d3808>] tcp_collapse+0x136/0x331
Jul  1 23:15:41 xenon kernel: [166248.671993]  [<c02d3b5e>] tcp_prune_queue+0x15b/0x1c4
Jul  1 23:15:41 xenon kernel: [166248.671993]  [<c02d3d9d>] tcp_data_queue+0x1d6/0xaea
Jul  1 23:15:41 xenon kernel: [166248.671993]  [<c02d5da2>] tcp_rcv_established+0x75b/0x80d
Jul  1 23:15:41 xenon kernel: [166248.671993]  [<c02caa42>] ? __inet_lookup_established+0x16c/0x176
Jul  1 23:15:41 xenon kernel: [166248.671993]  [<c02db0fb>] tcp_v4_do_rcv+0x255/0x3e2
Jul  1 23:15:41 xenon kernel: [166248.671993]  [<c031517a>] ? _spin_lock_nested+0x4f/0x57
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c02dccea>] tcp_v4_rcv+0x69b/0x6ec
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c02c41a1>] ip_local_deliver_finish+0xf6/0x19a
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c02c45a4>] ip_local_deliver+0x61/0x6d
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c02c408c>] ip_rcv_finish+0x288/0x2a7
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c02a450f>] ? __kfree_skb+0x63/0x66
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c02c4519>] ip_rcv+0x202/0x22c
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c02a8efa>] netif_receive_skb+0x377/0x3ab
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c027a3a3>] e1000_receive_skb+0x127/0x145
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c027c433>] e1000_clean_rx_irq+0x1df/0x270
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c0279343>] e1000_clean+0x5b/0x1f5
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c02ab043>] net_rx_action+0xa7/0x202
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c012b9ee>] __do_softirq+0x77/0xe5
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c0109e21>] do_softirq+0x74/0xd8
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c015aeb5>] ? handle_edge_irq+0x0/0x10d
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c012b8e8>] irq_exit+0x46/0x88
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c0109f48>] do_IRQ+0xc3/0xdb
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c01085a6>] common_interrupt+0x2e/0x34
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c019b4d3>] ? free_buffer_head+0x17/0x5d
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c019b8fe>] try_to_free_buffers+0x76/0x85
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c01610ad>] try_to_release_page+0x3b/0x3f
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c0167ef4>] shrink_page_list+0x404/0x501
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c0141009>] ? put_lock_stats+0xd/0x21
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c014106d>] ? lock_release_holdtime+0x50/0x56
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c0315867>] ? _spin_unlock_irq+0x22/0x4b
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c0142b4c>] ? trace_hardirqs_on+0xe8/0x11d
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c01680e8>] shrink_inactive_list+0xf7/0x33c
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c01683e7>] shrink_zone+0xba/0xd9
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c0168a83>] kswapd+0x2a1/0x3ec
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c01674e5>] ? isolate_pages_global+0x0/0x3e
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c0137c2a>] ? autoremove_wake_function+0x0/0x30
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c01687e2>] ? kswapd+0x0/0x3ec
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c0137b6c>] kthread+0x3b/0x63
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c0137b31>] ? kthread+0x0/0x63
Jul  1 23:15:41 xenon kernel: [166248.671994]  [<c0108847>] kernel_thread_helper+0x7/0x10
Jul  1 23:15:41 xenon kernel: [166248.671994]  =======================
Jul  1 23:15:41 xenon kernel: [166248.671994] Mem-info:
Jul  1 23:15:41 xenon kernel: [166248.671994] DMA per-cpu:
Jul  1 23:15:41 xenon kernel: [166248.671994] CPU    0: hi:    0, btch:   1 usd:   0
Jul  1 23:15:41 xenon kernel: [166248.671994] CPU    1: hi:    0, btch:   1 usd:   0
Jul  1 23:15:41 xenon kernel: [166248.671994] Normal per-cpu:
Jul  1 23:15:41 xenon kernel: [166248.671994] CPU    0: hi:  186, btch:  31 usd: 179
Jul  1 23:15:41 xenon kernel: [166248.671994] CPU    1: hi:  186, btch:  31 usd: 155
Jul  1 23:15:41 xenon kernel: [166248.671994] HighMem per-cpu:
Jul  1 23:15:41 xenon kernel: [166248.671994] CPU    0: hi:  186, btch:  31 usd:  77
Jul  1 23:15:41 xenon kernel: [166248.671994] CPU    1: hi:  186, btch:  31 usd:  66
Jul  1 23:15:41 xenon kernel: [166248.671994] Active:192629 inactive:196893 dirty:102 writeback:0 unstable:0
Jul  1 23:15:41 xenon kernel: [166248.671994]  free:16544 slab:97362 mapped:29644 pagetables:951 bounce:0
Jul  1 23:15:41 xenon kernel: [166248.671994] DMA free:3492kB min:64kB low:80kB high:96kB active:8kB inactive:0kB present:16160kB pages_scanned:4 all_unreclaimable? no
Jul  1 23:15:41 xenon kernel: [166248.671994] lowmem_reserve[]: 0 867 1979 1979
Jul  1 23:15:41 xenon kernel: [166248.671994] Normal free:59700kB min:3736kB low:4668kB high:5604kB active:241664kB inactive:176036kB present:888800kB pages_scanned:0 all_unreclaimable? no
Jul  1 23:15:41 xenon kernel: [166248.671994] lowmem_reserve[]: 0 0 8892 8892
Jul  1 23:15:41 xenon kernel: [166248.671994] HighMem free:2984kB min:512kB low:1708kB high:2904kB active:528844kB inactive:611536kB present:1138272kB pages_scanned:0 all_unreclaimable? no
Jul  1 23:15:41 xenon kernel: [166248.671994] lowmem_reserve[]: 0 0 0 0
Jul  1 23:15:41 xenon kernel: [166248.671994] DMA: 9*4kB 74*8kB 31*16kB 0*32kB 1*64kB 0*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 3492kB
Jul  1 23:15:41 xenon kernel: [166248.671994] Normal: 3813*4kB 5056*8kB 238*16kB 1*32kB 1*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 59732kB
Jul  1 23:15:41 xenon kernel: [166248.671994] HighMem: 44*4kB 187*8kB 10*16kB 14*32kB 5*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2984kB
Jul  1 23:15:41 xenon kernel: [166248.671994] 266122 total pagecache pages
Jul  1 23:15:41 xenon kernel: [166248.671994] Swap cache: add 1194, delete 994, find 236/310
Jul  1 23:15:41 xenon kernel: [166248.671994] Free swap  = 4200040kB
Jul  1 23:15:41 xenon kernel: [166248.671994] Total swap = 4200988kB
Jul  1 23:15:41 xenon kernel: [166248.671994] Free swap:       4200040kB
Jul  1 23:15:41 xenon kernel: [166248.671994] 517888 pages of RAM
Jul  1 23:15:41 xenon kernel: [166248.671994] 288512 pages of HIGHMEM
Jul  1 23:15:41 xenon kernel: [166248.671994] 9344 reserved pages
Jul  1 23:15:41 xenon kernel: [166248.671994] 168001 pages shared
Jul  1 23:15:41 xenon kernel: [166248.671994] 200 pages swap cached
Jul  1 23:15:41 xenon kernel: [166248.671994] 102 pages dirty
Jul  1 23:15:41 xenon kernel: [166248.671994] 0 pages writeback
Jul  1 23:15:41 xenon kernel: [166248.671994] 29644 pages mapped
Jul  1 23:15:41 xenon kernel: [166248.671994] 97362 pages slab
Jul  1 23:15:41 xenon kernel: [166248.671994] 951 pages pagetables

Should I worry? File a bug? Post more details? Just ignore it?

Thanks,
Tilman

