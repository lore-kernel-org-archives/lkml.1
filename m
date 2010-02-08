Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab0BHWbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:31:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557Ab0BHWbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:31:43 -0500
Date: Mon, 8 Feb 2010 14:31:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: lkml@Think-Future.de
Cc: Linux Kernel-Liste <linux-kernel@vger.kernel.org>,
       Reinette Chatre <reinette.chatre@intel.com>, ilw@linux.intel.com,
       linux-wireless@vger.kernel.org
Subject: Re: PROBLEM: iwlagn kernel 2.6.32.3 ooops
Message-Id: <20100208143118.e8e5a1ee.akpm@linux-foundation.org>
In-Reply-To: <20100206170348.GB9411@localhost>
References: <20100206170348.GB9411@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Feb 2010 18:03:50 +0100
lkml@Think-Future.de wrote:

>   Hi, 

Suitable cc's added, more below...

> This ooops happens on kernel 2.6.32.3. On a .32.7 it didn't 
> happen yet. Maybe fixed, maybe not.
> 
> Keywords (i.e., modules, networking, kernel):
> iwlagn, kernel 2.6.32.3
> 
> 
> Below two msgs:
> The first is the ooops that occurred when using the box as usual (IRC: after 
> this crash no rmmod && modprobe have been possible).
> 
> The second - IRC - when the iwlagn module crashed, rebooted, crashed differently, 
> was then removed after the different ooops and re-modprobed.
> 
> 
> [250420.677157] ip: page allocation failure. order:3, mode:0x8020

This one isn't an "oops" - it's a warning that a memory allocation
attempt failed.  Which is hardly surprising: an order-3 GFP_ATOMIC
allocation is highly unreliable and the driver just shouldn't be
attempting it.

> [250420.677168] Pid: 11584, comm: ip Not tainted 2.6.32.3 #5
> [250420.677173] Call Trace:
> [250420.677190]  [<c10a53f8>] ? __alloc_pages_nodemask+0x518/0x5f0
> [250420.677204]  [<c1007c20>] ? dma_generic_alloc_coherent+0x0/0x100
> [250420.677214]  [<c1007c92>] ? dma_generic_alloc_coherent+0x72/0x100
> [250420.677224]  [<c1007c20>] ? dma_generic_alloc_coherent+0x0/0x100
> [250420.677241]  [<fca1c9d5>] ? iwl_tx_queue_init+0x285/0x380 [iwlcore]
> [250420.677252]  [<c171d7f9>] ? _spin_lock_irqsave+0x19/0x40
> [250420.678452]  [<fca1cceb>] ? iwl_txq_ctx_reset+0x21b/0x5d0 [iwlcore]
> [250420.678462]  [<c171d7f9>] ? _spin_lock_irqsave+0x19/0x40
> [250420.678478]  [<c171d9ee>] ? _spin_unlock_irqrestore+0xe/0x30
> [250420.678494]  [<fca15821>] ? iwl_hw_nic_init+0xc1/0x130 [iwlcore]
> [250420.678505]  [<fca4d8eb>] ? iwl_prepare_card_hw+0xb/0xa0 [iwlagn]
> [250420.678515]  [<fca4e6ac>] ? __iwl_up+0x9c/0x350 [iwlagn]
> [250420.678526]  [<fca4ee5f>] ? iwl_mac_start+0x4ff/0xb50 [iwlagn]
> [250420.678537]  [<c15e560c>] ? netlink_broadcast+0x22c/0x370
> [250420.678547]  [<c15e5c32>] ? nlmsg_notify+0x42/0xb0
> [250420.678556]  [<c162298c>] ? inetdev_event+0x1c/0x460
> [250420.678565]  [<c171d7f9>] ? _spin_lock_irqsave+0x19/0x40
> [250420.678573]  [<c171d9ee>] ? _spin_unlock_irqrestore+0xe/0x30
> [250420.678586]  [<c16ed1c7>] ? ieee80211_open+0x3e7/0x7a0
> [250420.678596]  [<c15b06d2>] ? dev_open+0xc2/0x100
> [250420.678606]  [<c104864a>] ? local_bh_disable+0xa/0x10
> [250420.678615]  [<c15afb8b>] ? dev_change_flags+0x8b/0x1b0
> [250420.678626]  [<c15b8642>] ? do_setlink+0x1e2/0x370
> [250420.678636]  [<c15b9d6e>] ? rtnl_newlink+0x3fe/0x4c0
> [250420.678648]  [<c1069800>] ? tick_do_broadcast+0x20/0x70
> [250420.678657]  [<c1069922>] ? tick_handle_oneshot_broadcast+0xd2/0x110
> [250420.678667]  [<c15b8d77>] ? rtnl_fill_ifinfo+0x2e7/0x4f0
> [250420.678675]  [<c171da7c>] ? _spin_unlock+0xc/0x30
> [250420.678684]  [<c1005df9>] ? timer_interrupt+0x39/0x40
> [250420.678693]  [<c108421f>] ? handle_IRQ_event+0x7f/0x1a0
> [250420.678702]  [<c171d63d>] ? _spin_lock+0xd/0x30
> [250420.678711]  [<c15b9970>] ? rtnl_newlink+0x0/0x4c0
> [250420.678720]  [<c15b98cb>] ? rtnetlink_rcv_msg+0x16b/0x210
> [250420.678729]  [<c15b9760>] ? rtnetlink_rcv_msg+0x0/0x210
> [250420.678738]  [<c15e5f06>] ? netlink_rcv_skb+0x66/0x90
> [250420.678746]  [<c15b9759>] ? rtnetlink_rcv+0x19/0x20
> [250420.678755]  [<c15e5be4>] ? netlink_unicast+0x274/0x280
> [250420.678764]  [<c15e63e9>] ? netlink_sendmsg+0x1d9/0x2e0
> [250420.678777]  [<c159f311>] ? sock_sendmsg+0x111/0x130
> [250420.678788]  [<c105c2a0>] ? autoremove_wake_function+0x0/0x50
> [250420.678797]  [<c105c2a0>] ? autoremove_wake_function+0x0/0x50
> [250420.678808]  [<c1027975>] ? kunmap_atomic+0x35/0x80
> [250420.678817]  [<c10a4b5f>] ? get_page_from_freelist+0x26f/0x500
> [250420.678828]  [<c159f4a4>] ? sys_sendmsg+0x174/0x270
> [250420.678837]  [<c15a0756>] ? sys_recvmsg+0x1a6/0x230
> [250420.678847]  [<c10bfaa1>] ? anon_vma_prepare+0x91/0xe0
> [250420.678857]  [<c10b2c8b>] ? __inc_zone_state+0x1b/0x90
> [250420.678866]  [<c10a7a37>] ? __lru_cache_add+0x67/0xb0
> [250420.678874]  [<c171da7c>] ? _spin_unlock+0xc/0x30
> [250420.678883]  [<c10b6569>] ? do_wp_page+0xf9/0x700
> [250420.678894]  [<c10b80e4>] ? handle_mm_fault+0x514/0x7c0
> [250420.678905]  [<c15a0f3e>] ? sys_socketcall+0xee/0x2c0
> [250420.678914]  [<c1002ef0>] ? sysenter_do_call+0x12/0x22
> [250420.678921] Mem-Info:
> [250420.678925] DMA per-cpu:
> [250420.678930] CPU    0: hi:    0, btch:   1 usd:   0
> [250420.678936] CPU    1: hi:    0, btch:   1 usd:   0
> [250420.678940] Normal per-cpu:
> [250420.678945] CPU    0: hi:  186, btch:  31 usd: 173
> [250420.678951] CPU    1: hi:  186, btch:  31 usd: 151
> [250420.678956] HighMem per-cpu:
> [250420.678960] CPU    0: hi:  186, btch:  31 usd:  95
> [250420.678966] CPU    1: hi:  186, btch:  31 usd: 149
> [250420.678977] active_anon:206883 inactive_anon:48519 isolated_anon:0
> [250420.678980]  active_file:185862 inactive_file:166683 isolated_file:33
> [250420.678983]  unevictable:831 dirty:5805 writeback:0 unstable:0
> [250420.678986]  free:367782 slab_reclaimable:19779 slab_unreclaimable:13076
> [250420.678989]  mapped:26361 shmem:25241 pagetables:2094 bounce:0
> [250420.679004] DMA free:3552kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:1472kB inactive_file:5152kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15844kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:572kB slab_unreclaimable:4988kB kernel_stack:104kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> [250420.679017] lowmem_reserve[]: 0 867 3967 3967
> [250420.679038] Normal free:155480kB min:3732kB low:4664kB high:5596kB active_anon:652kB inactive_anon:14312kB active_file:154244kB inactive_file:371780kB unevictable:0kB isolated(anon):0kB isolated(file):132kB present:887976kB mlocked:0kB dirty:432kB writeback:0kB mapped:364kB shmem:400kB slab_reclaimable:78544kB slab_unreclaimable:47316kB kernel_stack:2624kB pagetables:8376kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> [250420.679053] lowmem_reserve[]: 0 0 24801 24801
> [250420.679074] HighMem free:1312220kB min:512kB low:3848kB high:7184kB active_anon:826880kB inactive_anon:179764kB active_file:587732kB inactive_file:289800kB unevictable:3324kB isolated(anon):0kB isolated(file):0kB present:3174548kB mlocked:0kB dirty:22788kB writeback:0kB mapped:105080kB shmem:100564kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> [250420.679089] lowmem_reserve[]: 0 0 0 0
> [250420.679099] DMA: 726*4kB 61*8kB 10*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3552kB
> [250420.679125] Normal: 38018*4kB 208*8kB 106*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 155464kB
> [250420.679150] HighMem: 12315*4kB 40702*8kB 32102*16kB 9425*32kB 1468*64kB 194*128kB 13*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1312220kB
> [250420.679177] 379888 total pagecache pages
> [250420.679181] 1260 pages in swap cache
> [250420.679186] Swap cache stats: add 1305, delete 45, find 8532/8534
> [250420.679191] Free swap  = 1946704kB
> [250420.679195] Total swap = 1951856kB
> [250420.731629] 1294336 pages RAM
> [250420.731635] 1066498 pages HighMem
> [250420.731639] 277784 pages reserved
> [250420.731642] 327537 pages shared
> [250420.731646] 426568 pages non-shared
> [250420.731655] iwlagn 0000:03:00.0: pci_alloc_consistent(32768) failed
> [250420.731707] iwlagn 0000:03:00.0: Tx 0 queue init failed
> [250420.731719] iwlagn 0000:03:00.0: Unable to init nic
> [250452.043227] e1000e: eth0 NIC Link is Down
> [251624.072132] usb 1-3: USB disconnect, address 20
> 
> 
> 
> 
> [252109.496953] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
> [252109.496961] iwlagn: Copyright(c) 2003-2009 Intel Corporation
> [252109.497071] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [252109.497094] iwlagn 0000:03:00.0: setting latency timer to 64
> [252109.497156] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
> [252109.547060] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
> [252109.547202] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
> [252109.548104] phy14: Selected rate control algorithm 'iwl-agn-rs'
> [252109.921801] udev: renamed network interface wlan0 to eth1
> [252110.693015] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-4965-2.ucode
> [252110.810198] iwlagn 0000:03:00.0: loaded firmware version 228.61.2.24
> [252110.989598] ------------[ cut here ]------------
> [252110.989620] WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1151 iwl_tx_cmd_complete+0x2ed/0x330 [iwlcore]()

This one is a warning, not an oops.  It could be a consequence of the
memory allocation failure.  If so, the code should be changed to
prevent this warning from coming out.  Because a GFP_ATOMIC memory
allocation failure is common, and expected (especially when it's
order-3!).  The driver should handle it without blurting big warnings.


> [252110.989626] Hardware name: 7666B4G
> [252110.989632] wrong command queue 0, sequence 0xE0 readp=0 writep=0
> [252110.989636] Modules linked in: iwlagn iwlcore btusb xt_TCPMSS uvcvideo nf_conntrack_netlink iptable_nat nf_nat iptable_mangle ipt_LOG xt_tcpudp xt_state xt_multiport iptable_filter ip_tables x_tables e1000e rtc_cmos [last unloaded: iwlcore]
> [252110.989681] Pid: 5684, comm: Xorg Not tainted 2.6.32.3 #5
> [252110.989686] Call Trace:
> [252110.989700]  [<fc000aed>] ? iwl_tx_cmd_complete+0x2ed/0x330 [iwlcore]
> [252110.989712]  [<fc000aed>] ? iwl_tx_cmd_complete+0x2ed/0x330 [iwlcore]
> [252110.989725]  [<c104256f>] ? warn_slowpath_common+0x6f/0xd0
> [252110.989737]  [<fc000aed>] ? iwl_tx_cmd_complete+0x2ed/0x330 [iwlcore]
> [252110.989746]  [<c104261b>] ? warn_slowpath_fmt+0x2b/0x30
> [252110.989758]  [<fc000aed>] ? iwl_tx_cmd_complete+0x2ed/0x330 [iwlcore]
> [252110.989770]  [<c1031e28>] ? select_task_rq_fair+0x368/0x9a0
> [252110.989781]  [<fc03cd15>] ? iwl_rx_handle+0xf5/0x2a0 [iwlagn]
> [252110.989792]  [<fc03d056>] ? iwl_irq_tasklet_legacy+0x196/0x440 [iwlagn]
> [252110.989803]  [<c10473b9>] ? tasklet_action+0x69/0xe0
> [252110.989812]  [<c1048737>] ? __do_softirq+0xe7/0x1e0
> [252110.989821]  [<c108421f>] ? handle_IRQ_event+0x7f/0x1a0
> [252110.989829]  [<c104885d>] ? do_softirq+0x2d/0x40
> [252110.989837]  [<c1048a45>] ? irq_exit+0x65/0x80
> [252110.989845]  [<c1004ea5>] ? do_IRQ+0x55/0xc0
> [252110.989854]  [<c10035a9>] ? common_interrupt+0x29/0x30
> [252110.989866]  [<c165005e>] ? unix_stream_sendmsg+0x2be/0x390
> [252110.989879]  [<c159e99c>] ? sock_aio_write+0x11c/0x130
> [252110.989890]  [<c159e880>] ? sock_aio_write+0x0/0x130
> [252110.989899]  [<c10cf34e>] ? do_sync_readv_writev+0xce/0x110
> [252110.989909]  [<c105c2a0>] ? autoremove_wake_function+0x0/0x50
> [252110.989920]  [<c12a863c>] ? security_file_permission+0xc/0x10
> [252110.989928]  [<c10cf62a>] ? rw_verify_area+0x5a/0xd0
> [252110.989936]  [<c10cfaae>] ? do_readv_writev+0x9e/0x1b0
> [252110.989945]  [<c159e880>] ? sock_aio_write+0x0/0x130
> [252110.989954]  [<c1060560>] ? hrtimer_start+0x20/0x30
> [252110.989962]  [<c12a863c>] ? security_file_permission+0xc/0x10
> [252110.989970]  [<c10cf62a>] ? rw_verify_area+0x5a/0xd0
> [252110.989979]  [<c10cfbfe>] ? vfs_writev+0x3e/0x60
> [252110.989987]  [<c10cfd07>] ? sys_writev+0x47/0x90
> [252110.989995]  [<c1002ef0>] ? sysenter_do_call+0x12/0x22
> [252110.990002] ---[ end trace bd50f16bd2f33949 ]---
> [252110.990010] iwl data: 00000000: 02 00 04 00 e5 e4 e0 00 01 00 00 00 01 00 00 00  ................
> [252110.990017] iwl data: 00000010: 01 00 0a 00 e7 e4 e0 00 0b 01 00 00 00 01 e6 00  ................
> [252114.817112] iwlagn 0000:03:00.0: START_ALIVE timeout after 4000ms.
> [252122.146120] iwlagn 0000:03:00.0: START_ALIVE timeout after 4000ms.

