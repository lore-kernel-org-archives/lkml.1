Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZJQTtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZJQTtJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 15:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZJQTtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 15:49:08 -0400
Received: from nerdhammel.gnuher.de ([88.198.0.170]:53272 "EHLO
	nerdhammel.gnuher.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbZJQTtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 15:49:05 -0400
X-Greylist: delayed 2748 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Oct 2009 15:49:04 EDT
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: Sven Geggus <lists@fuchsschwanzdomain.de>
Subject: Kernel crash on 2.6.31.x (kcryptd: page allocation failure..)
Date: Sat, 17 Oct 2009 19:03:16 +0000 (UTC)
Organization: Geggus clan, virtual section
Message-ID: <hbd4dk$5ac$1@ultimate100.geggus.net>
NNTP-Posting-Host: diesel.geggus.net
X-Trace: ultimate100.geggus.net 1255806196 5452 192.168.3.2 (17 Oct 2009 19:03:16 GMT)
X-Complaints-To: usenet@geggus.net
NNTP-Posting-Date: Sat, 17 Oct 2009 19:03:16 +0000 (UTC)
Cancel-Lock: sha1:XpkWbnl3rxq6FWd2A+fHZKoj0L4=
X-TERMINAL: rxvt-unicode
X-OS: Debian GNU/Linux (Kernel 2.6.31-ztdummy)
User-Agent: tin/1.9.5-20090720 ("Rieclachan") (UNIX) (Linux/2.6.31-ztdummy (i686))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I can reproducible crash my machine by writing bulk data from a
socket to an encrypted partition. It always crashes after a few
Gigabytes have been written.

The Partition in charge is using dm-crypt+xfs filesystem.

Here is what I captured using a serial console cable:

--cut--
kcryptd: page allocation failure. order:0, mode:0x20
Pid: 4904, comm: kcryptd Not tainted 2.6.31.4-ztdummy #1
Call Trace:
 <IRQ>  [<ffffffff810594ae>] ? __alloc_pages_nodemask+0x4c5/0x50c
 [<ffffffff810753eb>] ? cache_alloc_refill+0x218/0x454
 [<ffffffff8107569c>] ? __kmalloc+0x75/0x9e
 [<ffffffff81347361>] ? __alloc_skb+0x59/0x149
 [<ffffffff813a5aa4>] ? tcp_v4_rcv+0x448/0x6a5
 [<ffffffff81347f32>] ? __netdev_alloc_skb+0x15/0x2f
 [<ffffffff81241147>] ? e1000_alloc_rx_buffers+0x90/0x374
 [<ffffffff81241812>] ? e1000_clean_rx_irq+0x3e7/0x429
 [<ffffffff812440a1>] ? e1000_clean+0x318/0x4af
 [<ffffffff8138d4df>] ? ip_local_deliver_finish+0xf3/0x192
 [<ffffffff8138d3b9>] ? ip_rcv+0x236/0x269
 [<ffffffff8134d2e8>] ? net_rx_action+0x71/0x136
 [<ffffffff8104287c>] ? getnstimeofday+0x55/0xaf
 [<ffffffff81032676>] ? __do_softirq+0x7e/0x108
 [<ffffffff81241b08>] ? e1000_intr+0x10a/0x148
 [<ffffffff8100bb6a>] ? call_softirq+0x1a/0x24
 [<ffffffff8100d084>] ? do_softirq+0x28/0x62
 [<ffffffff810323de>] ? irq_exit+0x39/0x6d
 [<ffffffff8100cbb2>] ? do_IRQ+0x86/0x9a
 [<ffffffff8100b593>] ? ret_from_intr+0x0/0x9
 <EOI>  [<ffffffff8117541f>] ? crypto_cbc_encrypt+0x10f/0x15a
 [<ffffffff81025a02>] ? aes_encrypt+0x0/0x9
 [<ffffffff811668f5>] ? async_encrypt+0x35/0x3a
 [<ffffffff812ef115>] ? crypt_convert+0x1e9/0x266
 [<ffffffff812ef57d>] ? kcryptd_crypt+0x3eb/0x40d
 [<ffffffff812ef192>] ? kcryptd_crypt+0x0/0x40d
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103af23>] ? worker_thread+0x106/0x187
 [<ffffffff8103d99d>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103d639>] ? kthread+0x85/0x8d
 [<ffffffff8102b6ab>] ? finish_task_switch+0x2a/0x69
 [<ffffffff8100ba6a>] ? child_rip+0xa/0x20
 [<ffffffff8103d5b4>] ? kthread+0x0/0x8d
 [<ffffffff8100ba60>] ? child_rip+0x0/0x20
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 184
Active_anon:11837 active_file:39855 inactive_anon:18739
 inactive_file:40700 unevictable:0 dirty:7416 writeback:4093 unstable:0
 free:759 slab:10144 mapped:2777 pagetables:2524 bounce:0
DMA free:1992kB min:84kB low:104kB high:124kB active_anon:0kB inactive_anon:124kB active_file:4904kB inactive_file:8236kB unevictable:0kB present:15308kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 489 489 489
DMA32 free:1044kB min:2784kB low:3480kB high:4176kB active_anon:47348kB inactive_anon:74832kB active_file:154516kB inactive_file:154564kB unevictable:0kB present:500768kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 1*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1992kB
DMA32: 261*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1044kB
95554 total pagecache pages
14741 pages in swap cache
Swap cache stats: add 40531, delete 25790, find 57320/57805
Free swap  = 856060kB
Total swap = 987832kB
131008 pages RAM
4139 pages reserved
92164 pages shared
45322 pages non-shared
kcryptd: page allocation failure. order:0, mode:0x20
Pid: 4904, comm: kcryptd Not tainted 2.6.31.4-ztdummy #1
Call Trace:
 <IRQ>  [<ffffffff810594ae>] ? __alloc_pages_nodemask+0x4c5/0x50c
 [<ffffffff810753eb>] ? cache_alloc_refill+0x218/0x454
 [<ffffffff8107569c>] ? __kmalloc+0x75/0x9e
 [<ffffffff81347361>] ? __alloc_skb+0x59/0x149
 [<ffffffff81347f32>] ? __netdev_alloc_skb+0x15/0x2f
 [<ffffffff81255cd7>] ? rhine_napipoll+0x381/0x490
 [<ffffffff8134d2e8>] ? net_rx_action+0x71/0x136
 [<ffffffff8104287c>] ? getnstimeofday+0x55/0xaf
 [<ffffffff81032676>] ? __do_softirq+0x7e/0x108
 [<ffffffff81241b08>] ? e1000_intr+0x10a/0x148
 [<ffffffff8100bb6a>] ? call_softirq+0x1a/0x24
 [<ffffffff8100d084>] ? do_softirq+0x28/0x62
 [<ffffffff810323de>] ? irq_exit+0x39/0x6d
 [<ffffffff8100cbb2>] ? do_IRQ+0x86/0x9a
 [<ffffffff8100b593>] ? ret_from_intr+0x0/0x9
 <EOI>  [<ffffffff8117541f>] ? crypto_cbc_encrypt+0x10f/0x15a
 [<ffffffff81025a02>] ? aes_encrypt+0x0/0x9
 [<ffffffff811668f5>] ? async_encrypt+0x35/0x3a
 [<ffffffff812ef115>] ? crypt_convert+0x1e9/0x266
 [<ffffffff812ef57d>] ? kcryptd_crypt+0x3eb/0x40d
 [<ffffffff812ef192>] ? kcryptd_crypt+0x0/0x40d
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103af23>] ? worker_thread+0x106/0x187
 [<ffffffff8103d99d>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103d639>] ? kthread+0x85/0x8d
 [<ffffffff8102b6ab>] ? finish_task_switch+0x2a/0x69
 [<ffffffff8100ba6a>] ? child_rip+0xa/0x20
 [<ffffffff8103d5b4>] ? kthread+0x0/0x8d
 [<ffffffff8100ba60>] ? child_rip+0x0/0x20
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 184
Active_anon:11837 active_file:39855 inactive_anon:18739
 inactive_file:40700 unevictable:0 dirty:7416 writeback:4093 unstable:0
 free:759 slab:10144 mapped:2777 pagetables:2524 bounce:0
DMA free:1992kB min:84kB low:104kB high:124kB active_anon:0kB inactive_anon:124kB active_file:4904kB inactive_file:8236kB unevictable:0kB present:15308kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 489 489 489
DMA32 free:1044kB min:2784kB low:3480kB high:4176kB active_anon:47348kB inactive_anon:74832kB active_file:154516kB inactive_file:154564kB unevictable:0kB present:500768kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 1*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1992kB
DMA32: 261*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1044kB
95554 total pagecache pages
14741 pages in swap cache
Swap cache stats: add 40531, delete 25790, find 57320/57805
Free swap  = 856060kB
Total swap = 987832kB
131008 pages RAM
4139 pages reserved
92164 pages shared
45322 pages non-shared
kcryptd: page allocation failure. order:0, mode:0x20
Pid: 4904, comm: kcryptd Not tainted 2.6.31.4-ztdummy #1
Call Trace:
 <IRQ>  [<ffffffff810594ae>] ? __alloc_pages_nodemask+0x4c5/0x50c
 [<ffffffff8123bf37>] ? ata_bmdma_setup+0x53/0x6d
 [<ffffffff810753eb>] ? cache_alloc_refill+0x218/0x454
 [<ffffffff8107569c>] ? __kmalloc+0x75/0x9e
 [<ffffffff81347361>] ? __alloc_skb+0x59/0x149
 [<ffffffff813b007f>] ? inet_sk_rebuild_header+0x1b/0x2fa
 [<ffffffff81347a0d>] ? pskb_copy+0x19/0x166
 [<ffffffff813a0a69>] ? tcp_transmit_skb+0x84/0x623
 [<ffffffff81189468>] ? __blk_run_queue+0x41/0x6e
 [<ffffffff81197f2c>] ? rb_insert_color+0x66/0xe2
 [<ffffffff813a05b7>] ? tcp_current_mss+0x3c/0x57
 [<ffffffff813a27f2>] ? tcp_retransmit_skb+0x4a1/0x591
 [<ffffffff8102897e>] ? check_preempt_wakeup+0x22/0x110
 [<ffffffff813a3f29>] ? tcp_write_timer+0x3b1/0x590
 [<ffffffff813a3b78>] ? tcp_write_timer+0x0/0x590
 [<ffffffff81035b8c>] ? run_timer_softirq+0x16c/0x1cb
 [<ffffffff81032676>] ? __do_softirq+0x7e/0x108
 [<ffffffff81241b08>] ? e1000_intr+0x10a/0x148
 [<ffffffff8100bb6a>] ? call_softirq+0x1a/0x24
 [<ffffffff8100d084>] ? do_softirq+0x28/0x62
 [<ffffffff810323de>] ? irq_exit+0x39/0x6d
 [<ffffffff8100cbb2>] ? do_IRQ+0x86/0x9a
 [<ffffffff8100b593>] ? ret_from_intr+0x0/0x9
 <EOI>  [<ffffffff8117541f>] ? crypto_cbc_encrypt+0x10f/0x15a
 [<ffffffff81025a02>] ? aes_encrypt+0x0/0x9
 [<ffffffff811668f5>] ? async_encrypt+0x35/0x3a
 [<ffffffff812ef115>] ? crypt_convert+0x1e9/0x266
 [<ffffffff812ef57d>] ? kcryptd_crypt+0x3eb/0x40d
 [<ffffffff812ef192>] ? kcryptd_crypt+0x0/0x40d
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103af23>] ? worker_thread+0x106/0x187
 [<ffffffff8103d99d>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103d639>] ? kthread+0x85/0x8d
 [<ffffffff8102b6ab>] ? finish_task_switch+0x2a/0x69
 [<ffffffff8100ba6a>] ? child_rip+0xa/0x20
 [<ffffffff8103d5b4>] ? kthread+0x0/0x8d
 [<ffffffff8100ba60>] ? child_rip+0x0/0x20
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 184
Active_anon:11837 active_file:39855 inactive_anon:18739
 inactive_file:40700 unevictable:0 dirty:7416 writeback:4093 unstable:0
 free:759 slab:10144 mapped:2777 pagetables:2524 bounce:0
DMA free:1992kB min:84kB low:104kB high:124kB active_anon:0kB inactive_anon:124kB active_file:4904kB inactive_file:8236kB unevictable:0kB present:15308kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 489 489 489
DMA32 free:1044kB min:2784kB low:3480kB high:4176kB active_anon:47348kB inactive_anon:74832kB active_file:154516kB inactive_file:154564kB unevictable:0kB present:500768kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 1*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1992kB
DMA32: 261*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1044kB
95554 total pagecache pages
14741 pages in swap cache
Swap cache stats: add 40531, delete 25790, find 57320/57805
Free swap  = 856060kB
Total swap = 987832kB
131008 pages RAM
4139 pages reserved
92164 pages shared
45322 pages non-shared
kcryptd: page allocation failure. order:0, mode:0x20
Pid: 4904, comm: kcryptd Not tainted 2.6.31.4-ztdummy #1
Call Trace:
 <IRQ>  [<ffffffff810594ae>] ? __alloc_pages_nodemask+0x4c5/0x50c
 [<ffffffff810753eb>] ? cache_alloc_refill+0x218/0x454
 [<ffffffff8107569c>] ? __kmalloc+0x75/0x9e
 [<ffffffff81347361>] ? __alloc_skb+0x59/0x149
 [<ffffffff813b007f>] ? inet_sk_rebuild_header+0x1b/0x2fa
 [<ffffffff81347a0d>] ? pskb_copy+0x19/0x166
 [<ffffffff813a0a69>] ? tcp_transmit_skb+0x84/0x623
 [<ffffffff81189468>] ? __blk_run_queue+0x41/0x6e
 [<ffffffff81197f2c>] ? rb_insert_color+0x66/0xe2
 [<ffffffff813a05b7>] ? tcp_current_mss+0x3c/0x57
 [<ffffffff813a27f2>] ? tcp_retransmit_skb+0x4a1/0x591
 [<ffffffff8102897e>] ? check_preempt_wakeup+0x22/0x110
 [<ffffffff813a3f29>] ? tcp_write_timer+0x3b1/0x590
 [<ffffffff813a3b78>] ? tcp_write_timer+0x0/0x590
 [<ffffffff81035b8c>] ? run_timer_softirq+0x16c/0x1cb
 [<ffffffff81032676>] ? __do_softirq+0x7e/0x108
 [<ffffffff81241b08>] ? e1000_intr+0x10a/0x148
 [<ffffffff8100bb6a>] ? call_softirq+0x1a/0x24
 [<ffffffff8100d084>] ? do_softirq+0x28/0x62
 [<ffffffff810323de>] ? irq_exit+0x39/0x6d
 [<ffffffff8100cbb2>] ? do_IRQ+0x86/0x9a
 [<ffffffff8100b593>] ? ret_from_intr+0x0/0x9
 <EOI>  [<ffffffff8117541f>] ? crypto_cbc_encrypt+0x10f/0x15a
 [<ffffffff81025a02>] ? aes_encrypt+0x0/0x9
 [<ffffffff811668f5>] ? async_encrypt+0x35/0x3a
 [<ffffffff812ef115>] ? crypt_convert+0x1e9/0x266
 [<ffffffff812ef57d>] ? kcryptd_crypt+0x3eb/0x40d
 [<ffffffff812ef192>] ? kcryptd_crypt+0x0/0x40d
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103af23>] ? worker_thread+0x106/0x187
 [<ffffffff8103d99d>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103d639>] ? kthread+0x85/0x8d
 [<ffffffff8102b6ab>] ? finish_task_switch+0x2a/0x69
 [<ffffffff8100ba6a>] ? child_rip+0xa/0x20
 [<ffffffff8103d5b4>] ? kthread+0x0/0x8d
 [<ffffffff8100ba60>] ? child_rip+0x0/0x20
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 184
Active_anon:11837 active_file:39855 inactive_anon:18739
 inactive_file:40700 unevictable:0 dirty:7416 writeback:4093 unstable:0
 free:759 slab:10144 mapped:2777 pagetables:2524 bounce:0
DMA free:1992kB min:84kB low:104kB high:124kB active_anon:0kB inactive_anon:124kB active_file:4904kB inactive_file:8236kB unevictable:0kB present:15308kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 489 489 489
DMA32 free:1044kB min:2784kB low:3480kB high:4176kB active_anon:47348kB inactive_anon:74832kB active_file:154516kB inactive_file:154564kB unevictable:0kB present:500768kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 1*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1992kB
DMA32: 261*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1044kB
95554 total pagecache pages
14741 pages in swap cache
Swap cache stats: add 40531, delete 25790, find 57320/57805
Free swap  = 856060kB
Total swap = 987832kB
131008 pages RAM
4139 pages reserved
92164 pages shared
45322 pages non-shared
kcryptd: page allocation failure. order:0, mode:0x20
Pid: 4904, comm: kcryptd Not tainted 2.6.31.4-ztdummy #1
Call Trace:
 <IRQ>  [<ffffffff810594ae>] ? __alloc_pages_nodemask+0x4c5/0x50c
 [<ffffffff810323e5>] ? irq_exit+0x40/0x6d
 [<ffffffff810753eb>] ? cache_alloc_refill+0x218/0x454
 [<ffffffff8107569c>] ? __kmalloc+0x75/0x9e
 [<ffffffff81347361>] ? __alloc_skb+0x59/0x149
 [<ffffffff813b007f>] ? inet_sk_rebuild_header+0x1b/0x2fa
 [<ffffffff81347a0d>] ? pskb_copy+0x19/0x166
 [<ffffffff813a0a69>] ? tcp_transmit_skb+0x84/0x623
 [<ffffffff81189468>] ? __blk_run_queue+0x41/0x6e
 [<ffffffff81197f2c>] ? rb_insert_color+0x66/0xe2
 [<ffffffff813a05b7>] ? tcp_current_mss+0x3c/0x57
 [<ffffffff813a27f2>] ? tcp_retransmit_skb+0x4a1/0x591
 [<ffffffff8102897e>] ? check_preempt_wakeup+0x22/0x110
 [<ffffffff813a3f29>] ? tcp_write_timer+0x3b1/0x590
 [<ffffffff813a3b78>] ? tcp_write_timer+0x0/0x590
 [<ffffffff81035b8c>] ? run_timer_softirq+0x16c/0x1cb
 [<ffffffff81032676>] ? __do_softirq+0x7e/0x108
 [<ffffffff81241b08>] ? e1000_intr+0x10a/0x148
 [<ffffffff8100bb6a>] ? call_softirq+0x1a/0x24
 [<ffffffff8100d084>] ? do_softirq+0x28/0x62
 [<ffffffff810323de>] ? irq_exit+0x39/0x6d
 [<ffffffff8100cbb2>] ? do_IRQ+0x86/0x9a
 [<ffffffff8100b593>] ? ret_from_intr+0x0/0x9
 <EOI>  [<ffffffff8117541f>] ? crypto_cbc_encrypt+0x10f/0x15a
 [<ffffffff81025a02>] ? aes_encrypt+0x0/0x9
 [<ffffffff811668f5>] ? async_encrypt+0x35/0x3a
 [<ffffffff812ef115>] ? crypt_convert+0x1e9/0x266
 [<ffffffff812ef57d>] ? kcryptd_crypt+0x3eb/0x40d
 [<ffffffff812ef192>] ? kcryptd_crypt+0x0/0x40d
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103af23>] ? worker_thread+0x106/0x187
 [<ffffffff8103d99d>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103d639>] ? kthread+0x85/0x8d
 [<ffffffff8102b6ab>] ? finish_task_switch+0x2a/0x69
 [<ffffffff8100ba6a>] ? child_rip+0xa/0x20
 [<ffffffff8103d5b4>] ? kthread+0x0/0x8d
 [<ffffffff8100ba60>] ? child_rip+0x0/0x20
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 184
Active_anon:11837 active_file:39855 inactive_anon:18739
 inactive_file:40700 unevictable:0 dirty:7416 writeback:4093 unstable:0
 free:759 slab:10144 mapped:2777 pagetables:2524 bounce:0
DMA free:1992kB min:84kB low:104kB high:124kB active_anon:0kB inactive_anon:124kB active_file:4904kB inactive_file:8236kB unevictable:0kB present:15308kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 489 489 489
DMA32 free:1044kB min:2784kB low:3480kB high:4176kB active_anon:47348kB inactive_anon:74832kB active_file:154516kB inactive_file:154564kB unevictable:0kB present:500768kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 1*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1992kB
DMA32: 261*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1044kB
95554 total pagecache pages
14741 pages in swap cache
Swap cache stats: add 40531, delete 25790, find 57320/57805
Free swap  = 856060kB
Total swap = 987832kB
131008 pages RAM
4139 pages reserved
92164 pages shared
45322 pages non-shared
kcryptd: page allocation failure. order:0, mode:0x20
Pid: 4904, comm: kcryptd Not tainted 2.6.31.4-ztdummy #1
Call Trace:
 <IRQ>  [<ffffffff810594ae>] ? __alloc_pages_nodemask+0x4c5/0x50c
 [<ffffffff810753eb>] ? cache_alloc_refill+0x218/0x454
 [<ffffffff8107569c>] ? __kmalloc+0x75/0x9e
 [<ffffffff81347361>] ? __alloc_skb+0x59/0x149
 [<ffffffff813b007f>] ? inet_sk_rebuild_header+0x1b/0x2fa
 [<ffffffff81347a0d>] ? pskb_copy+0x19/0x166
 [<ffffffff813a0a69>] ? tcp_transmit_skb+0x84/0x623
 [<ffffffff81040063>] ? hrtimer_interrupt+0xf1/0x106
 [<ffffffff813a05b7>] ? tcp_current_mss+0x3c/0x57
 [<ffffffff813a27f2>] ? tcp_retransmit_skb+0x4a1/0x591
 [<ffffffff813a3f29>] ? tcp_write_timer+0x3b1/0x590
 [<ffffffff813a3b78>] ? tcp_write_timer+0x0/0x590
 [<ffffffff81035b8c>] ? run_timer_softirq+0x16c/0x1cb
 [<ffffffff81032676>] ? __do_softirq+0x7e/0x108
 [<ffffffff81241b08>] ? e1000_intr+0x10a/0x148
 [<ffffffff8100bb6a>] ? call_softirq+0x1a/0x24
 [<ffffffff8100d084>] ? do_softirq+0x28/0x62
 [<ffffffff810323de>] ? irq_exit+0x39/0x6d
 [<ffffffff8100cbb2>] ? do_IRQ+0x86/0x9a
 [<ffffffff8100b593>] ? ret_from_intr+0x0/0x9
 <EOI>  [<ffffffff8117541f>] ? crypto_cbc_encrypt+0x10f/0x15a
 [<ffffffff81025a02>] ? aes_encrypt+0x0/0x9
 [<ffffffff811668f5>] ? async_encrypt+0x35/0x3a
 [<ffffffff812ef115>] ? crypt_convert+0x1e9/0x266
 [<ffffffff812ef57d>] ? kcryptd_crypt+0x3eb/0x40d
 [<ffffffff812ef192>] ? kcryptd_crypt+0x0/0x40d
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103af23>] ? worker_thread+0x106/0x187
 [<ffffffff8103d99d>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103d639>] ? kthread+0x85/0x8d
 [<ffffffff8102b6ab>] ? finish_task_switch+0x2a/0x69
 [<ffffffff8100ba6a>] ? child_rip+0xa/0x20
 [<ffffffff8103d5b4>] ? kthread+0x0/0x8d
 [<ffffffff8100ba60>] ? child_rip+0x0/0x20
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 184
Active_anon:11837 active_file:39855 inactive_anon:18739
 inactive_file:40700 unevictable:0 dirty:7416 writeback:4093 unstable:0
 free:759 slab:10144 mapped:2777 pagetables:2524 bounce:0
DMA free:1992kB min:84kB low:104kB high:124kB active_anon:0kB inactive_anon:124kB active_file:4904kB inactive_file:8236kB unevictable:0kB present:15308kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 489 489 489
DMA32 free:1044kB min:2784kB low:3480kB high:4176kB active_anon:47348kB inactive_anon:74832kB active_file:154516kB inactive_file:154564kB unevictable:0kB present:500768kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 1*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1992kB
DMA32: 261*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1044kB
95554 total pagecache pages
14741 pages in swap cache
Swap cache stats: add 40531, delete 25790, find 57320/57805
Free swap  = 856060kB
Total swap = 987832kB
131008 pages RAM
4139 pages reserved
92164 pages shared
45322 pages non-shared
kcryptd: page allocation failure. order:0, mode:0x20
Pid: 4904, comm: kcryptd Not tainted 2.6.31.4-ztdummy #1
Call Trace:
 <IRQ>  [<ffffffff810594ae>] ? __alloc_pages_nodemask+0x4c5/0x50c
 [<ffffffff810753eb>] ? cache_alloc_refill+0x218/0x454
 [<ffffffff8107569c>] ? __kmalloc+0x75/0x9e
 [<ffffffff81347361>] ? __alloc_skb+0x59/0x149
 [<ffffffff813b007f>] ? inet_sk_rebuild_header+0x1b/0x2fa
 [<ffffffff81347a0d>] ? pskb_copy+0x19/0x166
 [<ffffffff813a0a69>] ? tcp_transmit_skb+0x84/0x623
 [<ffffffff81040063>] ? hrtimer_interrupt+0xf1/0x106
 [<ffffffff813a05b7>] ? tcp_current_mss+0x3c/0x57
 [<ffffffff813a27f2>] ? tcp_retransmit_skb+0x4a1/0x591
 [<ffffffff8102897e>] ? check_preempt_wakeup+0x22/0x110
 [<ffffffff813a3f29>] ? tcp_write_timer+0x3b1/0x590
 [<ffffffff813a3b78>] ? tcp_write_timer+0x0/0x590
 [<ffffffff81035b8c>] ? run_timer_softirq+0x16c/0x1cb
 [<ffffffff81032676>] ? __do_softirq+0x7e/0x108
 [<ffffffff81241b08>] ? e1000_intr+0x10a/0x148
 [<ffffffff8100bb6a>] ? call_softirq+0x1a/0x24
 [<ffffffff8100d084>] ? do_softirq+0x28/0x62
 [<ffffffff810323de>] ? irq_exit+0x39/0x6d
 [<ffffffff8100cbb2>] ? do_IRQ+0x86/0x9a
 [<ffffffff8100b593>] ? ret_from_intr+0x0/0x9
 <EOI>  [<ffffffff8117541f>] ? crypto_cbc_encrypt+0x10f/0x15a
 [<ffffffff81025a02>] ? aes_encrypt+0x0/0x9
 [<ffffffff811668f5>] ? async_encrypt+0x35/0x3a
 [<ffffffff812ef115>] ? crypt_convert+0x1e9/0x266
 [<ffffffff812ef57d>] ? kcryptd_crypt+0x3eb/0x40d
 [<ffffffff812ef192>] ? kcryptd_crypt+0x0/0x40d
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103af23>] ? worker_thread+0x106/0x187
 [<ffffffff8103d99d>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103d639>] ? kthread+0x85/0x8d
 [<ffffffff8102b6ab>] ? finish_task_switch+0x2a/0x69
 [<ffffffff8100ba6a>] ? child_rip+0xa/0x20
 [<ffffffff8103d5b4>] ? kthread+0x0/0x8d
 [<ffffffff8100ba60>] ? child_rip+0x0/0x20
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 184
Active_anon:11837 active_file:39855 inactive_anon:18739
 inactive_file:40700 unevictable:0 dirty:7416 writeback:4093 unstable:0
 free:759 slab:10144 mapped:2777 pagetables:2524 bounce:0
DMA free:1992kB min:84kB low:104kB high:124kB active_anon:0kB inactive_anon:124kB active_file:4904kB inactive_file:8236kB unevictable:0kB present:15308kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 489 489 489
DMA32 free:1044kB min:2784kB low:3480kB high:4176kB active_anon:47348kB inactive_anon:74832kB active_file:154516kB inactive_file:154564kB unevictable:0kB present:500768kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 1*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1992kB
DMA32: 261*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1044kB
95554 total pagecache pages
14741 pages in swap cache
Swap cache stats: add 40531, delete 25790, find 57320/57805
Free swap  = 856060kB
Total swap = 987832kB
131008 pages RAM
4139 pages reserved
92164 pages shared
45322 pages non-shared
kcryptd: page allocation failure. order:0, mode:0x20
Pid: 4904, comm: kcryptd Not tainted 2.6.31.4-ztdummy #1
Call Trace:
 <IRQ>  [<ffffffff810594ae>] ? __alloc_pages_nodemask+0x4c5/0x50c
 [<ffffffff810323e5>] ? irq_exit+0x40/0x6d
 [<ffffffff810753eb>] ? cache_alloc_refill+0x218/0x454
 [<ffffffff8107569c>] ? __kmalloc+0x75/0x9e
 [<ffffffff81347361>] ? __alloc_skb+0x59/0x149
 [<ffffffff813b007f>] ? inet_sk_rebuild_header+0x1b/0x2fa
 [<ffffffff81347a0d>] ? pskb_copy+0x19/0x166
 [<ffffffff813a0a69>] ? tcp_transmit_skb+0x84/0x623
 [<ffffffff813a05b7>] ? tcp_current_mss+0x3c/0x57
 [<ffffffff813a27f2>] ? tcp_retransmit_skb+0x4a1/0x591
 [<ffffffff813a3f29>] ? tcp_write_timer+0x3b1/0x590
 [<ffffffff813a3b78>] ? tcp_write_timer+0x0/0x590
 [<ffffffff81035b8c>] ? run_timer_softirq+0x16c/0x1cb
 [<ffffffff81032676>] ? __do_softirq+0x7e/0x108
 [<ffffffff81241b08>] ? e1000_intr+0x10a/0x148
 [<ffffffff8100bb6a>] ? call_softirq+0x1a/0x24
 [<ffffffff8100d084>] ? do_softirq+0x28/0x62
 [<ffffffff810323de>] ? irq_exit+0x39/0x6d
 [<ffffffff8100cbb2>] ? do_IRQ+0x86/0x9a
 [<ffffffff8100b593>] ? ret_from_intr+0x0/0x9
 <EOI>  [<ffffffff8117541f>] ? crypto_cbc_encrypt+0x10f/0x15a
 [<ffffffff81025a02>] ? aes_encrypt+0x0/0x9
 [<ffffffff811668f5>] ? async_encrypt+0x35/0x3a
 [<ffffffff812ef115>] ? crypt_convert+0x1e9/0x266
 [<ffffffff812ef57d>] ? kcryptd_crypt+0x3eb/0x40d
 [<ffffffff812ef192>] ? kcryptd_crypt+0x0/0x40d
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103af23>] ? worker_thread+0x106/0x187
 [<ffffffff8103d99d>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103d639>] ? kthread+0x85/0x8d
 [<ffffffff8102b6ab>] ? finish_task_switch+0x2a/0x69
 [<ffffffff8100ba6a>] ? child_rip+0xa/0x20
 [<ffffffff8103d5b4>] ? kthread+0x0/0x8d
 [<ffffffff8100ba60>] ? child_rip+0x0/0x20
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 184
Active_anon:11837 active_file:39855 inactive_anon:18739
 inactive_file:40700 unevictable:0 dirty:7416 writeback:4093 unstable:0
 free:759 slab:10144 mapped:2777 pagetables:2524 bounce:0
DMA free:1992kB min:84kB low:104kB high:124kB active_anon:0kB inactive_anon:124kB active_file:4904kB inactive_file:8236kB unevictable:0kB present:15308kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 489 489 489
DMA32 free:1044kB min:2784kB low:3480kB high:4176kB active_anon:47348kB inactive_anon:74832kB active_file:154516kB inactive_file:154564kB unevictable:0kB present:500768kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 1*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1992kB
DMA32: 261*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1044kB
95554 total pagecache pages
14741 pages in swap cache
Swap cache stats: add 40531, delete 25790, find 57320/57805
Free swap  = 856060kB
Total swap = 987832kB
131008 pages RAM
4139 pages reserved
92164 pages shared
45322 pages non-shared
kcryptd: page allocation failure. order:0, mode:0x20
Pid: 4904, comm: kcryptd Not tainted 2.6.31.4-ztdummy #1
Call Trace:
 <IRQ>  [<ffffffff810594ae>] ? __alloc_pages_nodemask+0x4c5/0x50c
 [<ffffffff810323e5>] ? irq_exit+0x40/0x6d
 [<ffffffff810753eb>] ? cache_alloc_refill+0x218/0x454
 [<ffffffff8107569c>] ? __kmalloc+0x75/0x9e
 [<ffffffff81347361>] ? __alloc_skb+0x59/0x149
 [<ffffffff813b007f>] ? inet_sk_rebuild_header+0x1b/0x2fa
 [<ffffffff81347a0d>] ? pskb_copy+0x19/0x166
 [<ffffffff813a0a69>] ? tcp_transmit_skb+0x84/0x623
 [<ffffffff813a05b7>] ? tcp_current_mss+0x3c/0x57
 [<ffffffff813a27f2>] ? tcp_retransmit_skb+0x4a1/0x591
 [<ffffffff813a3f29>] ? tcp_write_timer+0x3b1/0x590
 [<ffffffff813a3b78>] ? tcp_write_timer+0x0/0x590
 [<ffffffff81035b8c>] ? run_timer_softirq+0x16c/0x1cb
 [<ffffffff81032676>] ? __do_softirq+0x7e/0x108
 [<ffffffff81241b08>] ? e1000_intr+0x10a/0x148
 [<ffffffff8100bb6a>] ? call_softirq+0x1a/0x24
 [<ffffffff8100d084>] ? do_softirq+0x28/0x62
 [<ffffffff810323de>] ? irq_exit+0x39/0x6d
 [<ffffffff8100cbb2>] ? do_IRQ+0x86/0x9a
 [<ffffffff8100b593>] ? ret_from_intr+0x0/0x9
 <EOI>  [<ffffffff8117541f>] ? crypto_cbc_encrypt+0x10f/0x15a
 [<ffffffff81025a02>] ? aes_encrypt+0x0/0x9
 [<ffffffff811668f5>] ? async_encrypt+0x35/0x3a
 [<ffffffff812ef115>] ? crypt_convert+0x1e9/0x266
 [<ffffffff812ef57d>] ? kcryptd_crypt+0x3eb/0x40d
 [<ffffffff812ef192>] ? kcryptd_crypt+0x0/0x40d
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103af23>] ? worker_thread+0x106/0x187
 [<ffffffff8103d99d>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103d639>] ? kthread+0x85/0x8d
 [<ffffffff8102b6ab>] ? finish_task_switch+0x2a/0x69
 [<ffffffff8100ba6a>] ? child_rip+0xa/0x20
 [<ffffffff8103d5b4>] ? kthread+0x0/0x8d
 [<ffffffff8100ba60>] ? child_rip+0x0/0x20
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 184
Active_anon:11837 active_file:39855 inactive_anon:18739
 inactive_file:40700 unevictable:0 dirty:7416 writeback:4093 unstable:0
 free:759 slab:10144 mapped:2777 pagetables:2524 bounce:0
DMA free:1992kB min:84kB low:104kB high:124kB active_anon:0kB inactive_anon:124kB active_file:4904kB inactive_file:8236kB unevictable:0kB present:15308kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 489 489 489
DMA32 free:1044kB min:2784kB low:3480kB high:4176kB active_anon:47348kB inactive_anon:74832kB active_file:154516kB inactive_file:154564kB unevictable:0kB present:500768kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 1*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1992kB
DMA32: 261*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1044kB
95554 total pagecache pages
14741 pages in swap cache
Swap cache stats: add 40531, delete 25790, find 57320/57805
Free swap  = 856060kB
Total swap = 987832kB
131008 pages RAM
4139 pages reserved
92164 pages shared
45322 pages non-shared
kcryptd: page allocation failure. order:0, mode:0x20
Pid: 4904, comm: kcryptd Not tainted 2.6.31.4-ztdummy #1
Call Trace:
 <IRQ>  [<ffffffff810594ae>] ? __alloc_pages_nodemask+0x4c5/0x50c
 [<ffffffff810323e5>] ? irq_exit+0x40/0x6d
 [<ffffffff810753eb>] ? cache_alloc_refill+0x218/0x454
 [<ffffffff8107569c>] ? __kmalloc+0x75/0x9e
 [<ffffffff81347361>] ? __alloc_skb+0x59/0x149
 [<ffffffff813b007f>] ? inet_sk_rebuild_header+0x1b/0x2fa
 [<ffffffff81347a0d>] ? pskb_copy+0x19/0x166
 [<ffffffff813a0a69>] ? tcp_transmit_skb+0x84/0x623
 [<ffffffff81251858>] ? mdio_ctrl_hw+0xbf/0x122
 [<ffffffff813a05b7>] ? tcp_current_mss+0x3c/0x57
 [<ffffffff813a27f2>] ? tcp_retransmit_skb+0x4a1/0x591
 [<ffffffff813a3f29>] ? tcp_write_timer+0x3b1/0x590
 [<ffffffff813a3b78>] ? tcp_write_timer+0x0/0x590
 [<ffffffff81035b8c>] ? run_timer_softirq+0x16c/0x1cb
 [<ffffffff81032676>] ? __do_softirq+0x7e/0x108
 [<ffffffff81241b08>] ? e1000_intr+0x10a/0x148
 [<ffffffff8100bb6a>] ? call_softirq+0x1a/0x24
 [<ffffffff8100d084>] ? do_softirq+0x28/0x62
 [<ffffffff810323de>] ? irq_exit+0x39/0x6d
 [<ffffffff8100cbb2>] ? do_IRQ+0x86/0x9a
 [<ffffffff8100b593>] ? ret_from_intr+0x0/0x9
 <EOI>  [<ffffffff8117541f>] ? crypto_cbc_encrypt+0x10f/0x15a
 [<ffffffff81025a02>] ? aes_encrypt+0x0/0x9
 [<ffffffff811668f5>] ? async_encrypt+0x35/0x3a
 [<ffffffff812ef115>] ? crypt_convert+0x1e9/0x266
 [<ffffffff812ef57d>] ? kcryptd_crypt+0x3eb/0x40d
 [<ffffffff812ef192>] ? kcryptd_crypt+0x0/0x40d
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103af23>] ? worker_thread+0x106/0x187
 [<ffffffff8103d99d>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103d639>] ? kthread+0x85/0x8d
 [<ffffffff8102b6ab>] ? finish_task_switch+0x2a/0x69
 [<ffffffff8100ba6a>] ? child_rip+0xa/0x20
 [<ffffffff8103d5b4>] ? kthread+0x0/0x8d
 [<ffffffff8100ba60>] ? child_rip+0x0/0x20
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 184
Active_anon:11837 active_file:39855 inactive_anon:18739
 inactive_file:40700 unevictable:0 dirty:7416 writeback:4093 unstable:0
 free:759 slab:10144 mapped:2777 pagetables:2524 bounce:0
DMA free:1992kB min:84kB low:104kB high:124kB active_anon:0kB inactive_anon:124kB active_file:4904kB inactive_file:8236kB unevictable:0kB present:15308kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 489 489 489
DMA32 free:1044kB min:2784kB low:3480kB high:4176kB active_anon:47348kB inactive_anon:74832kB active_file:154516kB inactive_file:154564kB unevictable:0kB present:500768kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 1*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1992kB
DMA32: 261*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1044kB
95554 total pagecache pages
14741 pages in swap cache
Swap cache stats: add 40531, delete 25790, find 57320/57805
Free swap  = 856060kB
Total swap = 987832kB
131008 pages RAM
4139 pages reserved
92164 pages shared
45322 pages non-shared
kcryptd: page allocation failure. order:0, mode:0x20
Pid: 4904, comm: kcryptd Not tainted 2.6.31.4-ztdummy #1
Call Trace:
 <IRQ>  [<ffffffff810594ae>] ? __alloc_pages_nodemask+0x4c5/0x50c
 [<ffffffff810753eb>] ? cache_alloc_refill+0x218/0x454
 [<ffffffff8107569c>] ? __kmalloc+0x75/0x9e
 [<ffffffff81347361>] ? __alloc_skb+0x59/0x149
 [<ffffffff813b007f>] ? inet_sk_rebuild_header+0x1b/0x2fa
 [<ffffffff81347a0d>] ? pskb_copy+0x19/0x166
 [<ffffffff813a0a69>] ? tcp_transmit_skb+0x84/0x623
 [<ffffffff813a05b7>] ? tcp_current_mss+0x3c/0x57
 [<ffffffff813a27f2>] ? tcp_retransmit_skb+0x4a1/0x591
 [<ffffffff813a3f29>] ? tcp_write_timer+0x3b1/0x590
 [<ffffffff813a3b78>] ? tcp_write_timer+0x0/0x590
 [<ffffffff81035b8c>] ? run_timer_softirq+0x16c/0x1cb
 [<ffffffff81032676>] ? __do_softirq+0x7e/0x108
 [<ffffffff81241b08>] ? e1000_intr+0x10a/0x148
 [<ffffffff8100bb6a>] ? call_softirq+0x1a/0x24
 [<ffffffff8100d084>] ? do_softirq+0x28/0x62
 [<ffffffff810323de>] ? irq_exit+0x39/0x6d
 [<ffffffff8100cbb2>] ? do_IRQ+0x86/0x9a
 [<ffffffff8100b593>] ? ret_from_intr+0x0/0x9
 <EOI>  [<ffffffff8117541f>] ? crypto_cbc_encrypt+0x10f/0x15a
 [<ffffffff81025a02>] ? aes_encrypt+0x0/0x9
 [<ffffffff811668f5>] ? async_encrypt+0x35/0x3a
 [<ffffffff812ef115>] ? crypt_convert+0x1e9/0x266
 [<ffffffff812ef57d>] ? kcryptd_crypt+0x3eb/0x40d
 [<ffffffff812ef192>] ? kcryptd_crypt+0x0/0x40d
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103af23>] ? worker_thread+0x106/0x187
 [<ffffffff8103d99d>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x187
 [<ffffffff8103d639>] ? kthread+0x85/0x8d
 [<ffffffff8102b6ab>] ? finish_task_switch+0x2a/0x69
 [<ffffffff8100ba6a>] ? child_rip+0xa/0x20
 [<ffffffff8103d5b4>] ? kthread+0x0/0x8d
 [<ffffffff8100ba60>] ? child_rip+0x0/0x20
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 184
Active_anon:11837 active_file:39855 inactive_anon:18739
 inactive_file:40700 unevictable:0 dirty:7416 writeback:4093 unstable:0
 free:759 slab:10144 mapped:2777 pagetables:2524 bounce:0
DMA free:1992kB min:84kB low:104kB high:124kB active_anon:0kB inactive_anon:124kB active_file:4904kB inactive_file:8236kB unevictable:0kB present:15308kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 489 489 489
DMA32 free:1044kB min:2784kB low:3480kB high:4176kB active_anon:47348kB inactive_anon:74832kB active_file:154516kB inactive_file:154564kB unevictable:0kB present:500768kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 1*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1992kB
DMA32: 261*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1044kB
95554 total pagecache pages
14741 pages in swap cache
Swap cache stats: add 40531, delete 25790, find 57320/57805
Free swap  = 856060kB
Total swap = 987832kB
131008 pages RAM
4139 pages reserved
92164 pages shared
45322 pages non-shared
kcryptd: page allocation failure. order:0, mode:0x20
Pid: 4904, comm: kcryptd Not tainted 2.6.31.4-ztdummy #1
Call Trace:
 <IRQ>  [<ffffffff810594ae>] ? __alloc_pages_nodemask+0x4c5/0x50c
 [<ffffffff810753eb>] ? cache_alloc_refill+0x218/0x454
 [<ffffffff8107569c>] ? __kmalloc+0x75/0x9e
 [<ffffffff81347361>] ? __alloc_skb+0x59/0x149
 [<ffffffff813a5aa4>] ? tcp_v4_rcv+0x448/0x6a5
 [<ffffffff81347f32>] ? __netdev_alloc_skb+0x15/0x2f
 [<ffffffff81241147>] ? e1000_alloc_rx_buffers+0x90/0x374
 [<ffffffff812417b1>] ? e1000_clean_rx_irq+0x386/0x429
 [<ffffffff8134dce0>] ? dev_queue_xmit+0x2f3/0x321
 [<ffffffff812440a1>] ? e1000_clean+0x318/0x4af
 [<ffffffff81257bc7>] ? ppp_start_xmit+0x134/0x150
 [<ffffffff8134d2e8>] ? net_rx_action+0x71/0x136
 [<ffffffff81032676>] ? __do_softirq+0x7e/0x108
 [<ffffffff81241b08>] ? e1000_intr+0x10a/0x148
 [<ffffffff8100bb6a>] ? call_softirq+0x1a/0x24
 [<ffffffff8100d084>] ? do_softirq+0x28/0x62
 [<ffffffff810323de>] ? irq_exit+0x39/0x6d
 [<ffffffff8100cbb2>] ? do_IRQ+0x86/0x9a
 [<ffffffff8100b593>] ? ret_from_intr+0x0/0x9
 <EOI>  [<ffffffff8117541f>] ? crypto_cbc_encrypt+0x10f/0x15a
 [<ffffffff81025a02>] ? aes_encrypt+0x0/0x9
 [<ffffffff811668f5>] ? async_encrypt+0x35/0x3a
 [<ffffffff812ef115>] ? crypt_convert+0x1e9/0x266
 [<ffffffff812ef57d>] ? kcryptd_crypt+0x3eb/0x40d
 [<ffffffff812ef192>] ? kcryptd_crypt+0x0/0x40d
 [<ffffffff8103ae1d>] ? worker_thread+0x0/0x18?
--cut--

This is repeating over and over again until I did a hard reboot.

Sven

-- 
"Those who do not understand Unix are condemned to reinvent it, poorly"
(Henry Spencer)

/me is giggls@ircnet, http://sven.gegg.us/ on the Web
