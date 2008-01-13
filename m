Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbYAMOK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbYAMOK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 09:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYAMOKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 09:10:50 -0500
Received: from mail-a01.ithnet.com ([217.64.83.96]:47890 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751447AbYAMOKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 09:10:49 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jan 2008 09:10:49 EST
X-Sender-Authentication: net64
Date: Sun, 13 Jan 2008 15:04:07 +0100
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel@vger.kernel.org
Subject: Problem with tg3 in 2.6.23.12
Message-Id: <20080113150407.d2ca967b.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

we recently tried to stress several netblk configurations and got this kernel
log (amongst others). If additional information is required feel free to ask. We can try patches as well the config is not in production yet.

Jan 12 15:46:54 fs2 kernel: swapper: page allocation failure. order:0, mode:0x20
Jan 12 15:46:54 fs2 kernel:  [<c014c711>] __alloc_pages+0x283/0x294
Jan 12 15:46:54 fs2 kernel:  [<c016079e>] cache_alloc_refill+0x286/0x45f
Jan 12 15:46:54 fs2 kernel:  [<c01604dd>] kmem_cache_alloc+0x37/0x72
Jan 12 15:46:54 fs2 kernel:  [<c0279c36>] __alloc_skb+0x29/0x104
Jan 12 15:46:54 fs2 kernel:  [<c027a6bd>] __netdev_alloc_skb+0x1c/0x35
Jan 12 15:46:54 fs2 kernel:  [<f897b8e3>] tg3_alloc_rx_skb+0xb2/0x141 [tg3]
Jan 12 15:46:54 fs2 kernel:  [<c027dac9>] netif_receive_skb+0x257/0x271
Jan 12 15:46:54 fs2 kernel:  [<f8981d2a>] tg3_poll+0x370/0x7fd [tg3]
Jan 12 15:46:54 fs2 kernel:  [<f8981c17>] tg3_poll+0x25d/0x7fd [tg3]
Jan 12 15:46:54 fs2 kernel:  [<f8981c17>] tg3_poll+0x25d/0x7fd [tg3]
Jan 12 15:46:54 fs2 kernel:  [<c027f9cc>] net_rx_action+0x64/0xf4
Jan 12 15:46:54 fs2 kernel:  [<c0125d99>] __do_softirq+0x6c/0xcf
Jan 12 15:46:54 fs2 kernel:  [<c0125e2e>] do_softirq+0x32/0x36
Jan 12 15:46:54 fs2 kernel:  [<c0106355>] do_IRQ+0x5c/0x73
Jan 12 15:46:54 fs2 kernel:  [<c01149ab>] smp_apic_timer_interrupt+0x74/0x80
Jan 12 15:46:54 fs2 kernel:  [<c0102c56>] default_idle+0x0/0x3e
Jan 12 15:46:54 fs2 kernel:  [<c010479f>] common_interrupt+0x23/0x28
Jan 12 15:46:54 fs2 kernel:  [<c0102c56>] default_idle+0x0/0x3e 
Jan 12 15:46:54 fs2 kernel:  [<c0102c82>] default_idle+0x2c/0x3e
Jan 12 15:46:54 fs2 kernel:  [<c0102389>] cpu_idle+0x91/0xaa
Jan 12 15:46:54 fs2 kernel:  [<c038d8c0>] start_kernel+0x2b8/0x2c0
Jan 12 15:46:54 fs2 kernel:  [<c038d0e0>] unknown_bootoption+0x0/0x196
Jan 12 15:46:54 fs2 kernel:  =======================
Jan 12 15:46:54 fs2 kernel: DMA per-cpu:
Jan 12 15:46:54 fs2 kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Jan 12 15:46:54 fs2 kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Jan 12 15:46:56 fs2 kernel: Normal per-cpu:
Jan 12 15:46:56 fs2 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  61
Jan 12 15:46:56 fs2 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  59
Jan 12 15:46:56 fs2 kernel: HighMem per-cpu:
Jan 12 15:46:56 fs2 kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 135   Cold: hi:   62, btch:  15 usd:   7
Jan 12 15:46:56 fs2 kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 173   Cold: hi:   62, btch:  15 usd:   3
Jan 12 15:46:56 fs2 kernel: Active:15858 inactive:200197 dirty:16318 writeback:4335 unstable:0
Jan 12 15:46:56 fs2 kernel:  free:671858 slab:17016 mapped:5807 pagetables:161 bounce:0
Jan 12 15:46:56 fs2 kernel: DMA free:3504kB min:68kB low:84kB high:100kB active:0kB inactive:3680kB present:16256kB pages_scanned:8 all_unreclaimable? no
Jan 12 15:46:56 fs2 kernel: lowmem_reserve[]: 0 873 4048 4048
Jan 12 15:46:56 fs2 kernel: Normal free:1328kB min:3744kB low:4680kB high:5616kB active:11912kB inactive:783484kB present:894080kB pages_scanned:32 all_unreclaimable? no
Jan 12 15:46:56 fs2 kernel: lowmem_reserve[]: 0 0 25400 25400
Jan 12 15:46:56 fs2 kernel: HighMem free:2682600kB min:512kB low:3916kB high:7324kB active:51520kB inactive:13624kB present:3251200kB pages_scanned:0 all_unreclaimable? no
Jan 12 15:46:56 fs2 kernel: lowmem_reserve[]: 0 0 0 0
Jan 12 15:46:56 fs2 kernel: DMA: 1*4kB 1*8kB 0*16kB 1*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3500kB   
Jan 12 15:46:56 fs2 kernel: Normal: 0*4kB 1*8kB 0*16kB 1*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1320kB
Jan 12 15:46:56 fs2 kernel: HighMem: 2262*4kB 1422*8kB 862*16kB 524*32kB 395*64kB 326*128kB 270*256kB 232*512kB 169*1024kB 106*2048kB 485*4096kB = 2682600kB
Jan 12 15:46:56 fs2 kernel: Swap cache: add 41, delete 34, find 1/2, race 0+0
Jan 12 15:46:56 fs2 kernel: Free swap  = 2104344kB
Jan 12 15:46:56 fs2 kernel: Total swap = 2104472kB

Basic infos:

00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2)
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2)
00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:05.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
01:07.0 RAID bus controller: 3ware Inc 9xxx-series SATA-RAID
04:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5721 Gigabit Ethernet PCI Express (rev 11)

MemTotal:      3631716 kB
MemFree:       2657044 kB
Buffers:        798072 kB
Cached:          68056 kB
SwapCached:         28 kB
Active:          75892 kB
Inactive:       821916 kB
HighTotal:     2751360 kB
HighFree:      2648096 kB
LowTotal:       880356 kB
LowFree:          8948 kB
SwapTotal:     2104472 kB
SwapFree:      2104344 kB
Dirty:           62660 kB
Writeback:       15092 kB
AnonPages:       31676 kB
Mapped:          29744 kB
Slab:            64984 kB
SReclaimable:    51784 kB
SUnreclaim:      13200 kB
PageTables:        764 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   3920328 kB
Committed_AS:    81528 kB
VmallocTotal:   114680 kB
VmallocUsed:      2568 kB
VmallocChunk:   112028 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
Hugepagesize:     4096 kB

-- 
Regards,
Stephan

