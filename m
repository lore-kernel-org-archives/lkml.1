Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbYFLKHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbYFLKHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYFLKHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:07:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:49552 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbYFLKHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:07:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=lElbynxmvnWAYy+DbAVKrO8dtmfDO0R1mjqMOA2u4q9+w9wD5q7EfWht8MuXelR6rP
         t6xoRAwWfJy+JCw1XmD9zWQo2kobgcEz6mDiac5xNeuSJsXP3U5bPGYtPNdBUSZM+EHd
         2oyw5lx4QiWRoYzZwRLah26IF2saBKixBnT/E=
Message-ID: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
Date: Thu, 12 Jun 2008 12:07:34 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Problem: Out of memory after 2days with 2GB RAM
Cc: riel@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I'm attaching a trace where my machine has got into big troubles after
2 day usage and several successful suspend/resumes (this seems to be
finally getting better now :))

It looks like while there was a huge amount of buffers and caches -
system was unable to allocate few pages for kmalloc in iwl3945 driver
after resume.

I've even tried to 3 > drop_cache  and reinsert iwl driver - but this
had fatal results - machine died completely with blinking caps lock -
and no oops in the log for this case:

This is the commit aab2545fdd6641b76af0ae96456c4ca9d1e50dad  for the
2.6.26-rc5 I've been in this case.
Machine is T61/2GB/C2D

I'm attaching also slabinfo in case it would be usable for something.

NetworkManager: <info>  (eth0): device state change: 1 -> 2
NetworkManager: <info>  (eth0): preparing device.
NetworkManager: <info>  (eth0): deactivating device.
<6>[53906.520363] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17
(level, low) -> IRQ 17
NetworkManager: <info>  (wlan0): device state change: 1 -> 2
NetworkManager: <info>  (wlan0): bringing up device.
<4>[53906.578855] NetworkManager: page allocation failure. order:5, mode:0x1024
<4>[53906.578855] Pid: 2645, comm: NetworkManager Tainted: G        W
2.6.26-rc5 #33
<4>[53906.578855]
<4>[53906.578855] Call Trace:
<4>[53906.578855]  [<ffffffff81092c70>] __alloc_pages_internal+0x460/0x590
<4>[53906.578855]  [<ffffffffa01a87f8>] ?
:iwl3945:iwl3945_hw_tx_queue_init+0x38/0x1a0
<4>[53906.578855]  [<ffffffff81092dbb>] __alloc_pages+0xb/0x10
<4>[53906.578855]  [<ffffffff81011c26>] dma_alloc_pages+0x26/0x30
<4>[53906.578855]  [<ffffffff81011cf3>] dma_alloc_coherent+0xc3/0x2a0
<4>[53906.578855]  [<ffffffffa01a73c3>]
:iwl3945:iwl3945_tx_queue_init+0x63/0x1e0
<4>[53906.578855]  [<ffffffffa01aa06e>] :iwl3945:iwl3945_hw_nic_init+0x8de/0x940
<4>[53906.578855]  [<ffffffffa019de01>] :iwl3945:__iwl3945_up+0x91/0x640
<4>[53906.578855]  [<ffffffffa019e968>] :iwl3945:iwl3945_mac_start+0x568/0x790
<4>[53906.578855]  [<ffffffff8128a67d>] ? __nla_put+0x2d/0x40
<4>[53906.578855]  [<ffffffff8128a633>] ? __nla_reserve+0x53/0x70
<4>[53906.578855]  [<ffffffff8128a67d>] ? __nla_put+0x2d/0x40
<4>[53906.578855]  [<ffffffffa0166def>] :mac80211:ieee80211_open+0x13f/0x590
<4>[53906.578855]  [<ffffffff81273b48>] ? dev_set_rx_mode+0x48/0x60
<4>[53906.578855]  [<ffffffff81275b99>] dev_open+0x89/0xf0
<4>[53906.578855]  [<ffffffff812753c1>] dev_change_flags+0xa1/0x1e0
<4>[53906.578855]  [<ffffffff812730b9>] ? dev_get_by_index+0x19/0x80
<4>[53906.578855]  [<ffffffff8127e59c>] do_setlink+0x20c/0x3a0
<4>[53906.578855]  [<ffffffff812f5cc0>] ? _read_unlock+0x30/0x60
<4>[53906.578855]  [<ffffffff8127e83d>] rtnl_setlink+0x10d/0x150
<4>[53906.578855]  [<ffffffff8127fa2d>] rtnetlink_rcv_msg+0x18d/0x240
<4>[53906.578855]  [<ffffffff8127f8a0>] ? rtnetlink_rcv_msg+0x0/0x240
<4>[53906.578855]  [<ffffffff8128a3e9>] netlink_rcv_skb+0x89/0xb0
<4>[53906.578855]  [<ffffffff8127f889>] rtnetlink_rcv+0x29/0x40
<4>[53906.578855]  [<ffffffff81289e05>] netlink_unicast+0x2d5/0x2f0
<4>[53906.578855]  [<ffffffff8126e38e>] ? __alloc_skb+0x6e/0x150
<4>[53906.578855]  [<ffffffff8128a024>] netlink_sendmsg+0x204/0x300
<4>[53906.578855]  [<ffffffff812f5cc0>] ? _read_unlock+0x30/0x60
<4>[53906.578855]  [<ffffffff81265ca7>] sock_sendmsg+0x127/0x140
<4>[53906.578855]  [<ffffffff81265b09>] ? sock_recvmsg+0x139/0x150
<4>[53906.578855]  [<ffffffff810529d0>] ? autoremove_wake_function+0x0/0x40
<4>[53906.578855]  [<ffffffff812f5e70>] ? _spin_unlock+0x30/0x60
<4>[53906.578855]  [<ffffffff8117bb4a>] ? __up_read+0x2a/0xb0
<4>[53906.578855]  [<ffffffff81266a47>] ? move_addr_to_kernel+0x57/0x60
<4>[53906.578855]  [<ffffffff8126f39c>] ? verify_iovec+0x3c/0xd0
<4>[53906.578855]  [<ffffffff81265e49>] sys_sendmsg+0x189/0x320
<4>[53906.578855]  [<ffffffff81266b4d>] ? sys_sendto+0xfd/0x120
<4>[53906.578855]  [<ffffffff812f5759>] ? trace_hardirqs_on_thunk+0x35/0x3a
<4>[53906.578855]  [<ffffffff8100c50b>] system_call_after_swapgs+0x7b/0x80
<4>[53906.578855]
<6>[53906.578855] Mem-info:
<4>[53906.578855] DMA per-cpu:
<4>[53906.578855] CPU    0: hi:    0, btch:   1 usd:   0
<4>[53906.578855] CPU    1: hi:    0, btch:   1 usd:   0
<4>[53906.578855] DMA32 per-cpu:
<4>[53906.578855] CPU    0: hi:  186, btch:  31 usd:   0
<4>[53906.578855] CPU    1: hi:  186, btch:  31 usd:   0
<4>[53906.578855] Active:231839 inactive:178871 dirty:65 writeback:0 unstable:0
<4>[53906.578855]  free:5997 slab:45072 mapped:27835 pagetables:7405 bounce:0
<4>[53906.578855] DMA free:7896kB min:40kB low:48kB high:60kB
active:308kB inactive:0kB present:15176kB pages_scanned:0
all_unreclaimable? no
<4>[53906.578855] lowmem_reserve[]: 0 1959 1959 1959
<4>[53906.578855] DMA32 free:16092kB min:5640kB low:7048kB high:8460kB
active:927048kB inactive:715484kB present:2006684kB pages_scanned:0
all_unreclaimable? no
<4>[53906.578855] lowmem_reserve[]: 0 0 0 0
<4>[53906.578855] DMA: 86*4kB 112*8kB 148*16kB 38*32kB 0*64kB 0*128kB
0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 7896kB
<4>[53906.578855] DMA32: 2690*4kB 369*8kB 56*16kB 30*32kB 6*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 16080kB
<4>[53906.578855] 253872 total pagecache pages
<4>[53906.578855] Swap cache: add 98, delete 80, find 18/21
<4>[53906.578855] Free swap  = 1019784kB
<4>[53906.578855] Total swap = 1020088kB
<6>[53906.590046] 517808 pages of RAM
<6>[53906.590154] 17084 reserved pages
<6>[53906.590212] 240951 pages shared
<6>[53906.590214] 18 pages swap cached
<3>[53906.590216] iwl3945: Tx 3 queue init failed
<3>[53906.591272] iwl3945: Unable to int nic
<6>[53906.591272] ACPI: PCI interrupt for device 0000:03:00.0 disabled
NetworkManager: <WARN>  nm_device_hw_bring_up(): (wlan0): device not
up after timeout!
NetworkManager: <info>  (wlan0): deactivating device.
NetworkManager: <info>  (wlan0): device state change: 2 -> 3
dhclient: failed to set close-on-exec for /var/lib/dhclient/dhclient-eth0.leases
dhclient: DHCPREQUEST on eth0 to 255.255.255.255 port 67
dhclient: DHCPREQUEST on eth0 to 255.255.255.255 port 67
dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 5
dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 5
dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 11
dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 11
dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 11
dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 8
dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 8
dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 2
dhclient: No DHCPOFFERS received.
dhclient: Trying recorded lease 10.34.33.220
<6>[54165.922893] input: Virtual ThinkFinger Keyboard as
/devices/virtual/input/input29
<6>[54262.400055] input: Virtual ThinkFinger Keyboard as
/devices/virtual/input/input30
NetworkManager: <info>  (wlan0): now unmanaged
NetworkManager: <info>  (wlan0): device state change: 3 -> 1
<6>[54270.420036] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network
Connection driver for Linux, 1.2.26ks
<6>[54270.420036] iwl3945: Copyright(c) 2003-2008 Intel Corporation
<6>[54270.423408] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17
(level, low) -> IRQ 17
<6>[54270.423408] iwl3945: Detected Intel Wireless WiFi Link 3945ABG
<6>[54270.470310] iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
<6>[54270.593997] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17
(level, low) -> IRQ 17
<6>[54270.595114] firmware: requesting iwlwifi-3945-1.ucode
<4>[54270.698079] ip: page allocation failure. order:4, mode:0x40d0
<4>[54270.698094] Pid: 8712, comm: ip Tainted: G        W 2.6.26-rc5 #33
<4>[54270.698098]
<4>[54270.698099] Call Trace:
<4>[54270.698114]  [<ffffffff81092c70>] __alloc_pages_internal+0x460/0x590
<4>[54270.698132]  [<ffffffff81092dbb>] __alloc_pages+0xb/0x10
<4>[54270.698138]  [<ffffffff81092e3c>] __get_free_pages+0x1c/0x60
<4>[54270.698153]  [<ffffffffa01a73f9>]
:iwl3945:iwl3945_tx_queue_init+0x99/0x1e0
<4>[54270.698170]  [<ffffffffa01aa06e>] :iwl3945:iwl3945_hw_nic_init+0x8de/0x940
<4>[54270.698178]  [<ffffffff810b4fb2>] ? __slab_free+0xf2/0x3b0
<4>[54270.698192]  [<ffffffffa019de01>] :iwl3945:__iwl3945_up+0x91/0x640
<4>[54270.698201]  [<ffffffff8120b692>] ? release_firmware+0x22/0x30
<4>[54270.698217]  [<ffffffffa019e968>] :iwl3945:iwl3945_mac_start+0x568/0x790
<4>[54270.698232]  [<ffffffff81026acd>] ? kernel_map_pages+0xad/0x170
<4>[54270.698255]  [<ffffffffa0166def>] :mac80211:ieee80211_open+0x13f/0x590
<4>[54270.698264]  [<ffffffff81273b48>] ? dev_set_rx_mode+0x48/0x60
<4>[54270.698275]  [<ffffffff81275b99>] dev_open+0x89/0xf0
<4>[54270.698282]  [<ffffffff812753c1>] dev_change_flags+0xa1/0x1e0
<4>[54270.698292]  [<ffffffff8127e59c>] do_setlink+0x20c/0x3a0
<4>[54270.698301]  [<ffffffff8109e766>] ? handle_mm_fault+0x606/0x850
<4>[54270.698309]  [<ffffffff8128aa23>] ? nla_parse+0x33/0x100
<4>[54270.698318]  [<ffffffff8127ff14>] rtnl_newlink+0x434/0x4f0
<4>[54270.698339]  [<ffffffff8127f87a>] ? rtnetlink_rcv+0x1a/0x40
<4>[54270.698355]  [<ffffffff8127fa2d>] rtnetlink_rcv_msg+0x18d/0x240
<4>[54270.698363]  [<ffffffff8127f8a0>] ? rtnetlink_rcv_msg+0x0/0x240
<4>[54270.698370]  [<ffffffff8128a3e9>] netlink_rcv_skb+0x89/0xb0
<4>[54270.698378]  [<ffffffff8127f889>] rtnetlink_rcv+0x29/0x40
<4>[54270.698386]  [<ffffffff81289e05>] netlink_unicast+0x2d5/0x2f0
<4>[54270.698394]  [<ffffffff8126e38e>] ? __alloc_skb+0x6e/0x150
<4>[54270.698404]  [<ffffffff8128a024>] netlink_sendmsg+0x204/0x300
<4>[54270.698410]  [<ffffffff8108bde2>] ? find_lock_page+0x32/0xc0
<4>[54270.698425]  [<ffffffff81265ca7>] sock_sendmsg+0x127/0x140
<4>[54270.698431]  [<ffffffff8108be58>] ? find_lock_page+0xa8/0xc0
<4>[54270.698445]  [<ffffffff810529d0>] ? autoremove_wake_function+0x0/0x40
<4>[54270.698453]  [<ffffffff8108bc8d>] ? unlock_page+0x2d/0x40
<4>[54270.698460]  [<ffffffff8109c5e0>] ? __do_fault+0x200/0x450
<4>[54270.698469]  [<ffffffff8117bb4a>] ? __up_read+0x2a/0xb0
<4>[54270.698476]  [<ffffffff8117bb4a>] ? __up_read+0x2a/0xb0
<4>[54270.698485]  [<ffffffff81266a47>] ? move_addr_to_kernel+0x57/0x60
<4>[54270.698492]  [<ffffffff8126f39c>] ? verify_iovec+0x3c/0xd0
<4>[54270.698500]  [<ffffffff81265e49>] sys_sendmsg+0x189/0x320
<4>[54270.698515]  [<ffffffff8117ba14>] ? __up_write+0x24/0x130
<4>[54270.698531]  [<ffffffff812f5df5>] ? _spin_unlock_irqrestore+0x45/0x90
<4>[54270.698538]  [<ffffffff8117bac0>] ? __up_write+0xd0/0x130
<4>[54270.698550]  [<ffffffff812f5759>] ? trace_hardirqs_on_thunk+0x35/0x3a
<4>[54270.698561]  [<ffffffff8100c50b>] system_call_after_swapgs+0x7b/0x80
<4>[54270.698573]
<6>[54270.698576] Mem-info:
<4>[54270.698579] DMA per-cpu:
<4>[54270.698583] CPU    0: hi:    0, btch:   1 usd:   0
<4>[54270.698586] CPU    1: hi:    0, btch:   1 usd:   0
<4>[54270.698589] DMA32 per-cpu:
<4>[54270.698593] CPU    0: hi:  186, btch:  31 usd:   0
<4>[54270.698596] CPU    1: hi:  186, btch:  31 usd:  30
<4>[54270.698601] Active:233210 inactive:175472 dirty:16 writeback:0 unstable:0
<4>[54270.698603]  free:6697 slab:46327 mapped:27535 pagetables:7467 bounce:0
<4>[54270.698608] DMA free:7880kB min:40kB low:48kB high:60kB
active:252kB inactive:40kB present:15176kB pages_scanned:0
all_unreclaimable? no
<4>[54270.698612] lowmem_reserve[]: 0 1959 1959 1959
<4>[54270.698624] DMA32 free:18908kB min:5640kB low:7048kB high:8460kB
active:932588kB inactive:701848kB present:2006684kB pages_scanned:0
all_unreclaimable? no
<4>[54270.698628] lowmem_reserve[]: 0 0 0 0
<4>[54270.698638] DMA: 89*4kB 113*8kB 144*16kB 39*32kB 0*64kB 0*128kB
0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 7884kB
<4>[54270.698661] DMA32: 1272*4kB 1491*8kB 71*16kB 7*32kB 4*64kB
0*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 18888kB
<4>[54270.698683] 249509 total pagecache pages
<4>[54270.698687] Swap cache: add 171, delete 127, find 23/30
<4>[54270.698690] Free swap  = 1019608kB
<4>[54270.698693] Total swap = 1020088kB
<6>[54270.713804] 517808 pages of RAM
<6>[54270.713809] 17084 reserved pages
<6>[54270.713810] 237252 pages shared
<6>[54270.713812] 44 pages swap cached
<3>[54270.713814] iwl3945: kmalloc for auxiliary BD structures failed
<3>[54270.713825] iwl3945: Tx 1 queue init failed
<3>[54270.713837] iwl3945: Unable to int nic
<6>[54270.728285] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17
(level, low) -> IRQ 17
<4>[54270.760009] ip: page allocation failure. order:5, mode:0x1024
<4>[54270.760009] Pid: 8741, comm: ip Tainted: G        W 2.6.26-rc5 #33
<4>[54270.760009]
<4>[54270.760009] Call Trace:
<4>[54270.760009]  [<ffffffff81092c70>] __alloc_pages_internal+0x460/0x590
<4>[54270.760009]  [<ffffffffa01a87f8>] ?
:iwl3945:iwl3945_hw_tx_queue_init+0x38/0x1a0
<4>[54270.760009]  [<ffffffff81092dbb>] __alloc_pages+0xb/0x10
<4>[54270.760009]  [<ffffffff81011c26>] dma_alloc_pages+0x26/0x30
<4>[54270.760009]  [<ffffffff81011cf3>] dma_alloc_coherent+0xc3/0x2a0
<4>[54270.760009]  [<ffffffffa01a73c3>]
:iwl3945:iwl3945_tx_queue_init+0x63/0x1e0
<4>[54270.760009]  [<ffffffffa01aa06e>] :iwl3945:iwl3945_hw_nic_init+0x8de/0x940
<4>[54270.760009]  [<ffffffffa019de01>] :iwl3945:__iwl3945_up+0x91/0x640
<4>[54270.760009]  [<ffffffffa019e968>] :iwl3945:iwl3945_mac_start+0x568/0x790
<4>[54270.760009]  [<ffffffff81092253>] ? get_page_from_freelist+0x343/0x630
<4>[54270.760009]  [<ffffffff81026acd>] ? kernel_map_pages+0xad/0x170
<4>[54270.760009]  [<ffffffffa0166def>] :mac80211:ieee80211_open+0x13f/0x590
<4>[54270.760009]  [<ffffffff81273b48>] ? dev_set_rx_mode+0x48/0x60
<4>[54270.760009]  [<ffffffff81275b99>] dev_open+0x89/0xf0
<4>[54270.760009]  [<ffffffff812753c1>] dev_change_flags+0xa1/0x1e0
<4>[54270.760009]  [<ffffffff8127e59c>] do_setlink+0x20c/0x3a0
<4>[54270.760009]  [<ffffffff8109e766>] ? handle_mm_fault+0x606/0x850
<4>[54270.760009]  [<ffffffff8128aa23>] ? nla_parse+0x33/0x100
<4>[54270.760009]  [<ffffffff8127ff14>] rtnl_newlink+0x434/0x4f0
<4>[54270.760009]  [<ffffffff8127f87a>] ? rtnetlink_rcv+0x1a/0x40
<4>[54270.760009]  [<ffffffff8127fa2d>] rtnetlink_rcv_msg+0x18d/0x240
<4>[54270.760009]  [<ffffffff8127f8a0>] ? rtnetlink_rcv_msg+0x0/0x240
<4>[54270.760009]  [<ffffffff8128a3e9>] netlink_rcv_skb+0x89/0xb0
<4>[54270.760009]  [<ffffffff8127f889>] rtnetlink_rcv+0x29/0x40
<4>[54270.760009]  [<ffffffff81289e05>] netlink_unicast+0x2d5/0x2f0
<4>[54270.760009]  [<ffffffff8126e38e>] ? __alloc_skb+0x6e/0x150
<4>[54270.760009]  [<ffffffff8128a024>] netlink_sendmsg+0x204/0x300
<4>[54270.760009]  [<ffffffff8108bde2>] ? find_lock_page+0x32/0xc0
<4>[54270.760009]  [<ffffffff81265ca7>] sock_sendmsg+0x127/0x140
<4>[54270.760009]  [<ffffffff8108be58>] ? find_lock_page+0xa8/0xc0
<4>[54270.760009]  [<ffffffff810529d0>] ? autoremove_wake_function+0x0/0x40
<4>[54270.760009]  [<ffffffff8108bc8d>] ? unlock_page+0x2d/0x40
<4>[54270.760009]  [<ffffffff8109c5e0>] ? __do_fault+0x200/0x450
<4>[54270.760009]  [<ffffffff8117bb4a>] ? __up_read+0x2a/0xb0
<4>[54270.760009]  [<ffffffff8117bb4a>] ? __up_read+0x2a/0xb0
<4>[54270.760009]  [<ffffffff81266a47>] ? move_addr_to_kernel+0x57/0x60
<4>[54270.760009]  [<ffffffff8126f39c>] ? verify_iovec+0x3c/0xd0
<4>[54270.760009]  [<ffffffff81265e49>] sys_sendmsg+0x189/0x320
<4>[54270.760009]  [<ffffffff8117ba14>] ? __up_write+0x24/0x130
<4>[54270.760009]  [<ffffffff812f5df5>] ? _spin_unlock_irqrestore+0x45/0x90
<4>[54270.760009]  [<ffffffff8117bac0>] ? __up_write+0xd0/0x130
<4>[54270.760009]  [<ffffffff812f5759>] ? trace_hardirqs_on_thunk+0x35/0x3a
<4>[54270.760009]  [<ffffffff8100c50b>] system_call_after_swapgs+0x7b/0x80
<4>[54270.760009]
<6>[54270.760009] Mem-info:
<4>[54270.760009] DMA per-cpu:
<4>[54270.760009] CPU    0: hi:    0, btch:   1 usd:   0
<4>[54270.760009] CPU    1: hi:    0, btch:   1 usd:   0
<4>[54270.760009] DMA32 per-cpu:
<4>[54270.760009] CPU    0: hi:  186, btch:  31 usd:  30
<4>[54270.760009] CPU    1: hi:  186, btch:  31 usd:   0
<4>[54270.760009] Active:233193 inactive:175436 dirty:16 writeback:0 unstable:0
<4>[54270.760009]  free:6697 slab:46326 mapped:27519 pagetables:7437 bounce:0
<4>[54270.760009] DMA free:7880kB min:40kB low:48kB high:60kB
active:252kB inactive:40kB present:15176kB pages_scanned:0
all_unreclaimable? no
<4>[54270.760009] lowmem_reserve[]: 0 1959 1959 1959
<4>[54270.760009] DMA32 free:18908kB min:5640kB low:7048kB high:8460kB
active:932520kB inactive:701704kB present:2006684kB pages_scanned:0
all_unreclaimable? no
<4>[54270.760009] lowmem_reserve[]: 0 0 0 0
<4>[54270.760009] DMA: 89*4kB 113*8kB 144*16kB 39*32kB 0*64kB 0*128kB
0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 7884kB
<4>[54270.760009] DMA32: 1202*4kB 1505*8kB 81*16kB 10*32kB 5*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 18912kB
<4>[54270.760009] 249385 total pagecache pages
<4>[54270.760009] Swap cache: add 228, delete 176, find 23/31
<4>[54270.760009] Free swap  = 1019412kB
<4>[54270.760009] Total swap = 1020088kB
<6>[54270.774246] 517808 pages of RAM
<6>[54270.774264] 17084 reserved pages
<6>[54270.774265] 237398 pages shared
<6>[54270.774267] 52 pages swap cached
<3>[54270.774270] iwl3945: Tx 3 queue init failed
<3>[54270.774311] iwl3945: Unable to int nic
<6>[54270.797597] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17
(level, low) -> IRQ 17
<4>[54270.814521] ip: page allocation failure. order:5, mode:0x1024
<4>[54270.815224] Pid: 8766, comm: ip Tainted: G        W 2.6.26-rc5 #33
<4>[54270.815482]
<4>[54270.815483] Call Trace:
<4>[54270.815858]  [<ffffffff81092c70>] __alloc_pages_internal+0x460/0x590
<4>[54270.815902]  [<ffffffffa01a87f8>] ?
:iwl3945:iwl3945_hw_tx_queue_init+0x38/0x1a0
<4>[54270.815912]  [<ffffffff81092dbb>] __alloc_pages+0xb/0x10
<4>[54270.815917]  [<ffffffff81011c26>] dma_alloc_pages+0x26/0x30
<4>[54270.815920]  [<ffffffff81011cf3>] dma_alloc_coherent+0xc3/0x2a0
<4>[54270.815929]  [<ffffffffa01a73c3>]
:iwl3945:iwl3945_tx_queue_init+0x63/0x1e0
<4>[54270.815938]  [<ffffffffa01aa06e>] :iwl3945:iwl3945_hw_nic_init+0x8de/0x940
<4>[54270.815946]  [<ffffffffa019de01>] :iwl3945:__iwl3945_up+0x91/0x640
<4>[54270.815955]  [<ffffffffa019e968>] :iwl3945:iwl3945_mac_start+0x568/0x790
<4>[54270.815961]  [<ffffffff81092921>] ? __alloc_pages_internal+0x111/0x590
<4>[54270.815966]  [<ffffffff8109e766>] ? handle_mm_fault+0x606/0x850
<4>[54270.815979]  [<ffffffffa0166def>] :mac80211:ieee80211_open+0x13f/0x590
<4>[54270.815984]  [<ffffffff81273b48>] ? dev_set_rx_mode+0x48/0x60
<4>[54270.815990]  [<ffffffff81275b99>] dev_open+0x89/0xf0
<4>[54270.815993]  [<ffffffff812753c1>] dev_change_flags+0xa1/0x1e0
<4>[54270.815999]  [<ffffffff8127e59c>] do_setlink+0x20c/0x3a0
<4>[54270.816003]  [<ffffffff8109e766>] ? handle_mm_fault+0x606/0x850
<4>[54270.816007]  [<ffffffff8128aa23>] ? nla_parse+0x33/0x100
<4>[54270.816013]  [<ffffffff8127ff14>] rtnl_newlink+0x434/0x4f0
<4>[54270.816023]  [<ffffffff8127f87a>] ? rtnetlink_rcv+0x1a/0x40
<4>[54270.816031]  [<ffffffff8127fa2d>] rtnetlink_rcv_msg+0x18d/0x240
<4>[54270.816035]  [<ffffffff8127f8a0>] ? rtnetlink_rcv_msg+0x0/0x240
<4>[54270.816039]  [<ffffffff8128a3e9>] netlink_rcv_skb+0x89/0xb0
<4>[54270.816043]  [<ffffffff8127f889>] rtnetlink_rcv+0x29/0x40
<4>[54270.816047]  [<ffffffff81289e05>] netlink_unicast+0x2d5/0x2f0
<4>[54270.816052]  [<ffffffff8126e38e>] ? __alloc_skb+0x6e/0x150
<4>[54270.816057]  [<ffffffff8128a024>] netlink_sendmsg+0x204/0x300
<4>[54270.816060]  [<ffffffff8108bde2>] ? find_lock_page+0x32/0xc0
<4>[54270.816068]  [<ffffffff81265ca7>] sock_sendmsg+0x127/0x140
<4>[54270.816071]  [<ffffffff8108be58>] ? find_lock_page+0xa8/0xc0
<4>[54270.816078]  [<ffffffff810529d0>] ? autoremove_wake_function+0x0/0x40
<4>[54270.816083]  [<ffffffff8108bc8d>] ? unlock_page+0x2d/0x40
<4>[54270.816086]  [<ffffffff8109c5e0>] ? __do_fault+0x200/0x450
<4>[54270.816092]  [<ffffffff8117bb4a>] ? __up_read+0x2a/0xb0
<4>[54270.816095]  [<ffffffff8117bb4a>] ? __up_read+0x2a/0xb0
<4>[54270.816100]  [<ffffffff81266a47>] ? move_addr_to_kernel+0x57/0x60
<4>[54270.816103]  [<ffffffff8126f39c>] ? verify_iovec+0x3c/0xd0
<4>[54270.816107]  [<ffffffff81265e49>] sys_sendmsg+0x189/0x320
<4>[54270.816114]  [<ffffffff8117ba14>] ? __up_write+0x24/0x130
<4>[54270.816124]  [<ffffffff812f5df5>] ? _spin_unlock_irqrestore+0x45/0x90
<4>[54270.816127]  [<ffffffff8117bac0>] ? __up_write+0xd0/0x130
<4>[54270.816133]  [<ffffffff812f5759>] ? trace_hardirqs_on_thunk+0x35/0x3a
<4>[54270.816139]  [<ffffffff8100c50b>] system_call_after_swapgs+0x7b/0x80
<4>[54270.824621]
<6>[54270.824621] Mem-info:
<4>[54270.824621] DMA per-cpu:
<4>[54270.824621] CPU    0: hi:    0, btch:   1 usd:   0
<4>[54270.824621] CPU    1: hi:    0, btch:   1 usd:   0
<4>[54270.824621] DMA32 per-cpu:
<4>[54270.825933] CPU    0: hi:  186, btch:  31 usd:  30
<4>[54270.826179] CPU    1: hi:  186, btch:  31 usd:   0
<4>[54270.826427] Active:233189 inactive:175412 dirty:16 writeback:0 unstable:0
<4>[54270.826428]  free:6743 slab:46345 mapped:27504 pagetables:7438 bounce:0
<4>[54270.828205] DMA free:7880kB min:40kB low:48kB high:60kB
active:252kB inactive:40kB present:15176kB pages_scanned:0
all_unreclaimable? no
<4>[54270.828490] lowmem_reserve[]: 0 1959 1959 1959
<4>[54270.828900] DMA32 free:19092kB min:5640kB low:7048kB high:8460kB
active:932504kB inactive:701608kB present:2006684kB pages_scanned:0
all_unreclaimable? no
<4>[54270.828942] lowmem_reserve[]: 0 0 0 0
<4>[54270.828942] DMA: 89*4kB 113*8kB 144*16kB 39*32kB 0*64kB 0*128kB
0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 7884kB
<4>[54270.828943] DMA32: 1203*4kB 1503*8kB 84*16kB 13*32kB 6*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 19108kB
<4>[54270.830573] 249353 total pagecache pages
<4>[54270.831043] Swap cache: add 254, delete 202, find 23/31
<4>[54270.831290] Free swap  = 1019308kB
<4>[54270.831527] Total swap = 1020088kB
<6>[54270.844887] 517808 pages of RAM
<6>[54270.845797] 17084 reserved pages
<6>[54270.847318] 237448 pages shared
<6>[54270.847318] 52 pages swap cached
<3>[54270.847318] iwl3945: Tx 3 queue init failed
<3>[54270.847318] iwl3945: Unable to int nic
<6>[54270.861215] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17
(level, low) -> IRQ 17
<4>[54270.871268] ip: page allocation failure. order:5, mode:0x1024
<4>[54270.871268] Pid: 8776, comm: ip Tainted: G        W 2.6.26-rc5 #33
<4>[54270.871268]
<4>[54270.871268] Call Trace:
<4>[54270.871268]  [<ffffffff81092c70>] __alloc_pages_internal+0x460/0x590
<4>[54270.871268]  [<ffffffffa01a87f8>] ?
:iwl3945:iwl3945_hw_tx_queue_init+0x38/0x1a0
<4>[54270.871268]  [<ffffffff81092dbb>] __alloc_pages+0xb/0x10
<4>[54270.871268]  [<ffffffff81011c26>] dma_alloc_pages+0x26/0x30
<4>[54270.871268]  [<ffffffff81011cf3>] dma_alloc_coherent+0xc3/0x2a0
<4>[54270.871268]  [<ffffffffa01a73c3>]
:iwl3945:iwl3945_tx_queue_init+0x63/0x1e0
<4>[54270.871268]  [<ffffffffa01aa06e>] :iwl3945:iwl3945_hw_nic_init+0x8de/0x940
<4>[54270.871268]  [<ffffffffa019de01>] :iwl3945:__iwl3945_up+0x91/0x640
<4>[54270.871268]  [<ffffffffa019e968>] :iwl3945:iwl3945_mac_start+0x568/0x790
<4>[54270.871268]  [<ffffffff81092253>] ? get_page_from_freelist+0x343/0x630
<4>[54270.871268]  [<ffffffffa0166def>] :mac80211:ieee80211_open+0x13f/0x590
<4>[54270.871268]  [<ffffffff81273b48>] ? dev_set_rx_mode+0x48/0x60
<4>[54270.871268]  [<ffffffff81275b99>] dev_open+0x89/0xf0
<4>[54270.871268]  [<ffffffff812753c1>] dev_change_flags+0xa1/0x1e0
<4>[54270.871268]  [<ffffffff8127e59c>] do_setlink+0x20c/0x3a0
<4>[54270.871268]  [<ffffffff8117bb4a>] ? __up_read+0x2a/0xb0
<4>[54270.871268]  [<ffffffff8128aa23>] ? nla_parse+0x33/0x100
<4>[54270.871268]  [<ffffffff8127ff14>] rtnl_newlink+0x434/0x4f0
<4>[54270.871268]  [<ffffffff8127f87a>] ? rtnetlink_rcv+0x1a/0x40
<4>[54270.871268]  [<ffffffff8127fa2d>] rtnetlink_rcv_msg+0x18d/0x240
<4>[54270.871268]  [<ffffffff8127f8a0>] ? rtnetlink_rcv_msg+0x0/0x240
<4>[54270.871268]  [<ffffffff8128a3e9>] netlink_rcv_skb+0x89/0xb0
<4>[54270.871268]  [<ffffffff8127f889>] rtnetlink_rcv+0x29/0x40
<4>[54270.871268]  [<ffffffff81289e05>] netlink_unicast+0x2d5/0x2f0
<4>[54270.871268]  [<ffffffff8126e38e>] ? __alloc_skb+0x6e/0x150
<4>[54270.871268]  [<ffffffff8128a024>] netlink_sendmsg+0x204/0x300
<4>[54270.871268]  [<ffffffff8108bde2>] ? find_lock_page+0x32/0xc0
<4>[54270.871268]  [<ffffffff81265ca7>] sock_sendmsg+0x127/0x140
<4>[54270.871268]  [<ffffffff8108be58>] ? find_lock_page+0xa8/0xc0
<4>[54270.871268]  [<ffffffff810529d0>] ? autoremove_wake_function+0x0/0x40
<4>[54270.871268]  [<ffffffff8108bc8d>] ? unlock_page+0x2d/0x40
<4>[54270.871268]  [<ffffffff8109c5e0>] ? __do_fault+0x200/0x450
<4>[54270.871268]  [<ffffffff8117bb4a>] ? __up_read+0x2a/0xb0
<4>[54270.871268]  [<ffffffff8117bb4a>] ? __up_read+0x2a/0xb0
<4>[54270.871268]  [<ffffffff81266a47>] ? move_addr_to_kernel+0x57/0x60
<4>[54270.871268]  [<ffffffff8126f39c>] ? verify_iovec+0x3c/0xd0
<4>[54270.871268]  [<ffffffff81265e49>] sys_sendmsg+0x189/0x320
<4>[54270.871268]  [<ffffffff8117ba14>] ? __up_write+0x24/0x130
<4>[54270.871268]  [<ffffffff812f5df5>] ? _spin_unlock_irqrestore+0x45/0x90
<4>[54270.871268]  [<ffffffff8117bac0>] ? __up_write+0xd0/0x130
<4>[54270.871268]  [<ffffffff812f5759>] ? trace_hardirqs_on_thunk+0x35/0x3a
<4>[54270.871268]  [<ffffffff8100c50b>] system_call_after_swapgs+0x7b/0x80
<4>[54270.871268]
<6>[54270.871268] Mem-info:
<4>[54270.871268] DMA per-cpu:
<4>[54270.871268] CPU    0: hi:    0, btch:   1 usd:   0
<4>[54270.871268] CPU    1: hi:    0, btch:   1 usd:   0
<4>[54270.871268] DMA32 per-cpu:
<4>[54270.871268] CPU    0: hi:  186, btch:  31 usd:  60
<4>[54270.871268] CPU    1: hi:  186, btch:  31 usd:  94
<4>[54270.871268] Active:233238 inactive:175412 dirty:16 writeback:0 unstable:0
<4>[54270.871268]  free:6487 slab:46333 mapped:27551 pagetables:7438 bounce:0
<4>[54270.871268] DMA free:7880kB min:40kB low:48kB high:60kB
active:252kB inactive:40kB present:15176kB pages_scanned:0
all_unreclaimable? no
<4>[54270.871268] lowmem_reserve[]: 0 1959 1959 1959
<4>[54270.871268] DMA32 free:18068kB min:5640kB low:7048kB high:8460kB
active:932700kB inactive:701608kB present:2006684kB pages_scanned:0
all_unreclaimable? no
<4>[54270.871268] lowmem_reserve[]: 0 0 0 0
<4>[54270.871268] DMA: 89*4kB 113*8kB 144*16kB 39*32kB 0*64kB 0*128kB
0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 7884kB
<4>[54270.871268] DMA32: 1065*4kB 1469*8kB 85*16kB 15*32kB 3*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 18044kB
<4>[54270.871268] 249353 total pagecache pages
<4>[54270.871268] Swap cache: add 254, delete 202, find 23/31
<4>[54270.871268] Free swap  = 1019308kB
<4>[54270.871268] Total swap = 1020088kB
dhclient: Corrupt lease file - possible data loss!
dhclient: failed to set close-on-exec for
/var/lib/dhclient/dhclient-wlan0.leases
<6>[54270.892622] 517808 pages of RAM
<6>[54270.892622] 17084 reserved pages
<6>[54270.892622] 237408 pages shared
<6>[54270.892622] 52 pages swap cached
<3>[54270.892622] iwl3945: Tx 5 queue init failed
<3>[54270.892622] iwl3945: Unable to int nic
dhclient: dhclient(8773) is already running - exiting.
dhclient: exiting.
<6>[54270.956110] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17
(level, low) -> IRQ 17
<4>[54270.969802] ifconfig: page allocation failure. order:5, mode:0x1024
<4>[54270.969802] Pid: 8817, comm: ifconfig Tainted: G        W 2.6.26-rc5 #33
<4>[54270.969802]
<4>[54270.969802] Call Trace:
<4>[54270.969802]  [<ffffffff81092c70>] __alloc_pages_internal+0x460/0x590
<4>[54270.969802]  [<ffffffffa01a87f8>] ?
:iwl3945:iwl3945_hw_tx_queue_init+0x38/0x1a0
<4>[54270.969802]  [<ffffffff81092dbb>] __alloc_pages+0xb/0x10
<4>[54270.969802]  [<ffffffff81011c26>] dma_alloc_pages+0x26/0x30
<4>[54270.969802]  [<ffffffff81011cf3>] dma_alloc_coherent+0xc3/0x2a0
<4>[54270.969802]  [<ffffffffa01a73c3>]
:iwl3945:iwl3945_tx_queue_init+0x63/0x1e0
<4>[54270.969802]  [<ffffffffa01aa06e>] :iwl3945:iwl3945_hw_nic_init+0x8de/0x940
<4>[54270.969802]  [<ffffffffa019de01>] :iwl3945:__iwl3945_up+0x91/0x640
<4>[54270.969802]  [<ffffffffa019e968>] :iwl3945:iwl3945_mac_start+0x568/0x790
<4>[54270.969802]  [<ffffffff8109c546>] ? __do_fault+0x166/0x450
<4>[54270.969802]  [<ffffffff81274fbf>] ? netdev_run_todo+0x1f/0x280
<4>[54270.969802]  [<ffffffff8127f852>] ? rtnl_lock+0x12/0x20
<4>[54270.969802]  [<ffffffffa0166def>] :mac80211:ieee80211_open+0x13f/0x590
<4>[54270.969802]  [<ffffffff81273b48>] ? dev_set_rx_mode+0x48/0x60
<4>[54270.969802]  [<ffffffff81275b99>] dev_open+0x89/0xf0
<4>[54270.969802]  [<ffffffff812753c1>] dev_change_flags+0xa1/0x1e0
<4>[54270.969802]  [<ffffffff812bfbec>] devinet_ioctl+0x81c/0x830
<4>[54270.969802]  [<ffffffff8117ba14>] ? __up_write+0x24/0x130
<4>[54270.969802]  [<ffffffff812c0904>] inet_ioctl+0x94/0xc0
<4>[54270.969802]  [<ffffffff81264d56>] sock_ioctl+0x66/0x270
<4>[54270.969802]  [<ffffffff810c8b01>] vfs_ioctl+0x31/0xa0
<4>[54270.969802]  [<ffffffff810c8df3>] do_vfs_ioctl+0x283/0x2f0
<4>[54270.969802]  [<ffffffff810c8ef9>] sys_ioctl+0x99/0xa0
<4>[54270.969802]  [<ffffffff8100c50b>] system_call_after_swapgs+0x7b/0x80
<4>[54270.969802]
<6>[54270.969802] Mem-info:
<4>[54270.969802] DMA per-cpu:
<4>[54270.969802] CPU    0: hi:    0, btch:   1 usd:   0
<4>[54270.969802] CPU    1: hi:    0, btch:   1 usd:   0
<4>[54270.969802] DMA32 per-cpu:
<4>[54270.969802] CPU    0: hi:  186, btch:  31 usd:  62
<4>[54270.969802] CPU    1: hi:  186, btch:  31 usd: 115
<4>[54270.969802] Active:233290 inactive:175412 dirty:16 writeback:0 unstable:0
<4>[54270.969802]  free:6452 slab:46368 mapped:27552 pagetables:7439 bounce:0
<4>[54270.969802] DMA free:7880kB min:40kB low:48kB high:60kB
active:252kB inactive:40kB present:15176kB pages_scanned:0
all_unreclaimable? no
<4>[54270.969802] lowmem_reserve[]: 0 1959 1959 1959
<4>[54270.969802] DMA32 free:17928kB min:5640kB low:7048kB high:8460kB
active:932908kB inactive:701608kB present:2006684kB pages_scanned:0
all_unreclaimable? no
<4>[54270.969802] lowmem_reserve[]: 0 0 0 0
<4>[54270.969802] DMA: 89*4kB 113*8kB 144*16kB 39*32kB 0*64kB 0*128kB
0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 7884kB
<4>[54270.969802] DMA32: 1165*4kB 1387*8kB 82*16kB 14*32kB 5*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 17964kB
<4>[54270.969802] 249353 total pagecache pages
<4>[54270.969802] Swap cache: add 254, delete 202, find 23/31
<4>[54270.969802] Free swap  = 1019308kB
<4>[54270.969802] Total swap = 1020088kB
<6>[54270.980785] 517808 pages of RAM
<6>[54270.980800] 17084 reserved pages
<6>[54270.980801] 237258 pages shared
<6>[54270.980803] 52 pages swap cached
<3>[54270.980806] iwl3945: Tx 3 queue init failed
<3>[54270.980839] iwl3945: Unable to int nic
<6>[54270.982690] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17
(level, low) -> IRQ 17
<4>[54270.991159] ifconfig: page allocation failure. order:5, mode:0x1024
<4>[54270.991169] Pid: 8817, comm: ifconfig Tainted: G        W 2.6.26-rc5 #33
<4>[54270.991171]
<4>[54270.991172] Call Trace:
<4>[54270.991193]  [<ffffffff81092c70>] __alloc_pages_internal+0x460/0x590
<4>[54270.991210]  [<ffffffffa01a87f8>] ?
:iwl3945:iwl3945_hw_tx_queue_init+0x38/0x1a0
<4>[54270.991215]  [<ffffffff81092dbb>] __alloc_pages+0xb/0x10
<4>[54270.991220]  [<ffffffff81011c26>] dma_alloc_pages+0x26/0x30
<4>[54270.991224]  [<ffffffff81011cf3>] dma_alloc_coherent+0xc3/0x2a0
<4>[54270.991234]  [<ffffffffa01a73c3>]
:iwl3945:iwl3945_tx_queue_init+0x63/0x1e0
<4>[54270.991243]  [<ffffffffa01aa06e>] :iwl3945:iwl3945_hw_nic_init+0x8de/0x940
<4>[54270.991252]  [<ffffffffa019de01>] :iwl3945:__iwl3945_up+0x91/0x640
<4>[54270.991262]  [<ffffffffa019e968>] :iwl3945:iwl3945_mac_start+0x568/0x790
<4>[54270.991266]  [<ffffffff8109c546>] ? __do_fault+0x166/0x450
<4>[54270.991276]  [<ffffffff8127f852>] ? rtnl_lock+0x12/0x20
<4>[54270.991291]  [<ffffffffa0166def>] :mac80211:ieee80211_open+0x13f/0x590
<4>[54270.991296]  [<ffffffff81273b48>] ? dev_set_rx_mode+0x48/0x60
<4>[54270.991302]  [<ffffffff81275b99>] dev_open+0x89/0xf0
<4>[54270.991306]  [<ffffffff812753c1>] dev_change_flags+0xa1/0x1e0
<4>[54270.991313]  [<ffffffff812bfbec>] devinet_ioctl+0x81c/0x830
<4>[54270.991322]  [<ffffffff8117ba14>] ? __up_write+0x24/0x130
<4>[54270.991327]  [<ffffffff812c0904>] inet_ioctl+0x94/0xc0
<4>[54270.991331]  [<ffffffff81264d56>] sock_ioctl+0x66/0x270
<4>[54270.991336]  [<ffffffff810c8b01>] vfs_ioctl+0x31/0xa0
<4>[54270.991341]  [<ffffffff810c8df3>] do_vfs_ioctl+0x283/0x2f0
<4>[54270.991346]  [<ffffffff810c8ef9>] sys_ioctl+0x99/0xa0
<4>[54270.991352]  [<ffffffff8100c50b>] system_call_after_swapgs+0x7b/0x80
<4>[54270.991359]
<6>[54270.991360] Mem-info:
<4>[54270.991362] DMA per-cpu:
<4>[54270.991364] CPU    0: hi:    0, btch:   1 usd:   0
<4>[54270.991366] CPU    1: hi:    0, btch:   1 usd:   0
<4>[54270.991368] DMA32 per-cpu:
<4>[54270.991370] CPU    0: hi:  186, btch:  31 usd:  59
<4>[54270.991372] CPU    1: hi:  186, btch:  31 usd: 114
<4>[54270.991374] Active:233306 inactive:175412 dirty:16 writeback:0 unstable:0
<4>[54270.991375]  free:6478 slab:46351 mapped:27552 pagetables:7439 bounce:0
<4>[54270.991379] DMA free:7880kB min:40kB low:48kB high:60kB
active:252kB inactive:40kB present:15176kB pages_scanned:0
all_unreclaimable? no
<4>[54270.991381] lowmem_reserve[]: 0 1959 1959 1959
<4>[54270.991387] DMA32 free:18032kB min:5640kB low:7048kB high:8460kB
active:932972kB inactive:701608kB present:2006684kB pages_scanned:0
all_unreclaimable? no
<4>[54270.991390] lowmem_reserve[]: 0 0 0 0
<4>[54270.991395] DMA: 89*4kB 113*8kB 144*16kB 39*32kB 0*64kB 0*128kB
0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 7884kB
<4>[54270.991408] DMA32: 1165*4kB 1399*8kB 82*16kB 13*32kB 6*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 18092kB
<4>[54270.991420] 249353 total pagecache pages
<4>[54270.991422] Swap cache: add 254, delete 202, find 23/31
<4>[54270.991424] Free swap  = 1019308kB
<4>[54270.991426] Total swap = 1020088kB
<6>[54271.004577] 517808 pages of RAM
<6>[54271.004595] 17084 reserved pages
<6>[54271.004596] 237266 pages shared
<6>[54271.004598] 52 pages swap cached
<3>[54271.004601] iwl3945: Tx 3 queue init failed
<3>[54271.004641] iwl3945: Unable to int nic
dhclient: receive_packet failed on wlan0: Network is down
dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 7
dhclient: send_packet: Network is down
dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 9
dhclient: send_packet: Network is down
dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 9
dhclient: send_packet: Network is down
dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 8
dhclient: send_packet: Network is down
dhclient: failed to set close-on-exec for /var/lib/dhclient/dhclient-eth0.leases
dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 6
dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 8
dhclient: send_packet: Network is down
dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 6
dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 8
dhclient: send_packet: Network is down
dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 9
dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 12
dhclient: send_packet: Network is down
dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 13


slabinfo:
Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O
%Fr %Ef Flg
Acpi-Namespace            1932      32   204.8K         50/1/0   39 0
 2  30 PZFU
Acpi-Operand              3202      72   475.1K       116/11/0   28 0
 9  48 PZFU
Acpi-Parse                  68      48     8.1K          2/0/0   34 0
 0  39 PZFU
Acpi-ParseExt               56      72     8.1K          2/0/0   28 0
 0  49 PZFU
Acpi-State                  52      80     8.1K          2/0/0   26 0
 0  50 PZFU
anon_vma                  5138      72   770.0K       188/20/0   28 0
10  48 PZFU
arp_cache                   18     348     8.1K          1/0/0   18 1
 0  76 APZFU
bdev_cache                  39    1432    65.5K          2/1/0   21 3
50  85 APaZFU
bio                         59     104    16.3K          4/2/0   21 0
50  37 APZFU
biovec-1                   102      16    12.2K          3/1/0   42 0
33  13 APZFU
biovec-128                  30    2048    65.5K          2/0/0   15 3
 0  93 APZFU
biovec-16                   58     256    24.5K          3/1/0   21 1
33  60 APZFU
biovec-256                  22    4096   327.6K         10/0/0    7 3
 0  27 APZFU
biovec-4                    42      64    12.2K          3/1/0   21 0
33  21 APZFU
biovec-64                   42    1024    49.1K          3/0/0   14 2
 0  87 APZFU
blkdev_ioc                 117     128    28.6K          7/4/0   20 0
57  52 PZFU
blkdev_queue                28    2240    98.3K          3/1/0   14 3
33  63 PZFU
blkdev_requests             50     304    24.5K          3/1/0   21 1
33  61 PZFU
bridge_fdb_cache            21      64     8.1K          2/1/0   21 0
50  16 APZFU
buffer_head              98029     104    30.0M    7345/6625/0   23 0
90  33 PaZFU
cfq_io_context             117     168    32.7K          8/5/0   17 0
62  59 PZFU
cfq_queue                  114     128    28.6K          7/4/0   20 0
57  50 PZFU
dentry                   56168     256    19.1M       4685/9/0   12 0
 0  74 PaZFU
dm_io                      288      40    36.8K          9/1/0   36 0
11  31 PZFU
dm_target_io               294      24    32.7K          8/1/0   42 0
12  21 PZFU
dnotify_cache                1      40     4.0K          1/1/0   36 0
100   0 PZFU
eventpoll_epi               18     128     8.1K          2/1/0   16 0
50  28 APZFU
eventpoll_pwq               30      72     8.1K          2/1/0   28 0
50  26 PZFU
ext3_inode_cache         55555    1472   105.8M     3231/409/0   21 3
12  77 PaZFU
ext3_xattr                 230      88    40.9K         10/1/0   25 0
10  49 PaZFU
fasync_cache                42      24     8.1K          2/1/0   42 0
50  12 PZFU
file_lock_cache             26     232     8.1K          2/0/0   13 0
 0  73 PZFU
files_cache                142     768   147.4K          9/5/0   18 2
55  73 APZFU
filp                      6554     296     2.6M       320/35/0   21 1
10  74 APZFU
fs_cache                   136     120    28.6K          7/4/0   21 0
57  56 APZFU
idr_layer_cache            572     528   360.4K         44/0/0   13 1
 0  83 PZFU
inet_peer_cache             21      64     8.1K          2/1/0   21 0
50  16 APZFU
inode_cache               5284    1072     6.3M        390/0/0   14 2
 0  88 PaZFU
inotify_event_cache         72      40     8.1K          2/0/0   36 0
 0  35 PZFU
inotify_watch_cache        200      72    32.7K          8/1/0   28 0
12  43 PZFU
ip_dst_cache                42     312    16.3K          2/0/0   21 1
 0  79 APZFU
ip_fib_alias                39      32     8.1K          2/1/0   39 0
50  15 PZFU
ip_fib_hash                 32      72     8.1K          2/1/0   28 0
50  28 PZFU
journal_handle              64      56     8.1K          2/0/0   32 0
 0  43 PaZFU
journal_head                59      96    16.3K          4/2/0   24 0
50  34 PaZFU
kmalloc-1024               596    1024   753.6K        23/16/0   29 3
69  80 PZFU
kmalloc-128                442     128    94.2K         23/5/0   20 0
21  60 PZFU
kmalloc-16                2605      16   241.6K        59/15/0   46 0
25  17 PZFU
kmalloc-192                266     192    77.8K         19/7/0   15 0
36  65 PZFU
kmalloc-2048               455    2048     1.5M        48/31/0   15 3
64  59 PZFU
kmalloc-256                625     256   221.1K        54/13/0   12 0
24  72 PZFU
kmalloc-32                 768      32    86.0K         21/9/0   39 0
42  28 PZFU
kmalloc-4096               415    4096     1.9M         60/2/0    7 3
 3  86 PZFU
kmalloc-512                492     512   319.4K        39/10/0   14 1
25  78 PZFU
kmalloc-64                4059      64   815.1K      199/131/0   30 0
65  31 PZFU
kmalloc-8                 3511       8   290.8K        71/11/0   51 0
15   9 PZFU
kmalloc-96                1841      96   327.6K        80/17/0   24 0
21  53 PZFU
kmalloc_dma-512             14     512     8.1K          1/0/0   14 1
 0  87 dPZFU
kvm_mmu_page_header         25      88     8.1K          2/1/0   25 0
50  26 PZFU
kvm_pte_chain               32      56     8.1K          2/1/0   32 0
50  21 PZFU
kvm_rmap_desc               36      40     8.1K          2/1/0   36 0
50  17 PZFU
kvm_vcpu                     0    5568    32.7K          1/1/0    5 3
100   0 PZFU
mm_struct                  127    1184   196.6K        12/10/0   12 2
83  76 APZFU
mnt_cache                   35     224    12.2K          3/1/0   12 0
33  63 APZFU
mqueue_inode_cache           1    1456    32.7K          1/1/0   21 3
100   4 APZFU
names_cache                 14    4096    65.5K          2/0/0    7 3
 0  87 APZFU
nf_conntrack                50     304    40.9K          5/3/0   21 1
60  37 PZFU
pid                        333      88    73.7K        18/13/0   21 0
72  39 APZFU
posix_timers_cache          12     248     4.0K          1/0/0   12 0
 0  72 PZFU
proc_inode_cache          1580    1104     2.0M        64/23/0   27 3
35  83 PaZFU
radix_tree_node          23769     552    15.5M     1896/230/0   13 1
12  84 PaZFU
RAW                         15    1200    32.7K          2/1/0   12 2
50  54 APZFU
request_sock_TCP            21      88     8.1K          2/1/0   21 0
50  22 APZFU
revoke_record               32      32     8.1K          2/1/0   32 0
50  12 APaZFU
revoke_table                46      16     4.0K          1/0/0   46 0
 0  17 PaZFU
rpc_buffers                 23    2048    65.5K          2/1/0   15 3
50  71 APZFU
rpc_inode_cache             22    1376    32.7K          1/0/0   22 3
 0  92 APaZFU
rpc_tasks                   29     272    16.3K          2/1/0   21 1
50  48 APZFU
scsi_cmd_cache              42     312    16.3K          2/0/0   21 1
 0  79 APZFU
scsi_sense_cache            42      96     8.1K          2/0/0   21 0
 0  49 APZFU
sgpool-128                   6    5120    65.5K          2/1/0    6 3
50  46 APZFU
sgpool-16                   42     640    32.7K          2/0/0   21 2
 0  82 APZFU
sgpool-32                   46    1280    65.5K          2/0/0   23 3
 0  89 APZFU
sgpool-64                   12    2560    65.5K          2/1/0   12 3
50  46 APZFU
sgpool-8                    36     320    16.3K          2/0/0   18 1
 0  70 APZFU
shmem_inode_cache         1194    1328     1.7M         53/8/0   23 3
15  91 PZFU
sighand_cache              199    2184   524.2K        16/10/0   14 3
62  82 APZFU
signal_cache               193     888   196.6K         12/4/0   17 2
33  87 APZFU
sigqueue                    34     160     8.1K          2/0/0   17 0
 0  66 PZFU
skbuff_fclone_cache         28     452    16.3K          2/0/0   14 1
 0  77 APZFU
skbuff_head_cache          352     224   208.8K        51/48/0   12 0
94  37 APZFU
sock_inode_cache           731    1200     1.0M        63/11/0   12 2
17  84 APaZFU
sysfs_dir_cache          14377      80     2.2M        555/5/0   26 0
 0  50 PZFU
task_delay_info            295     120    65.5K        16/10/0   21 0
62  54 PZFU
task_struct                278    9368     3.1M        97/12/0    3 3
12  81 PZFU
task_xstate                232     512   163.8K        20/12/0   13 1
60  72 PZFU
taskstats                   29     312    16.3K          2/1/0   21 1
50  55 PZFU
TCP                         32    2248    98.3K          3/1/0   13 3
33  73 APZFU
tcp_bind_bucket             64      40     8.1K          2/0/0   32 0
 0  31 APZFU
tw_sock_TCP                 16     136     8.1K          2/1/0   16 0
50  26 APZFU
UDP                         28    1224    49.1K          3/1/0   12 2
33  69 APZFU
uhci_urb_priv               64      56     8.1K          2/0/0   32 0
 0  43 PZFU
uid_cache                   25      64     8.1K          2/1/0   21 0
50  19 APZFU
UNIX                       731    1376     1.1M         34/8/0   22 3
23  90 APZFU
vm_area_struct           14664     168     3.6M       881/58/0   17 0
 6  68 PZFU
