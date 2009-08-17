Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZHQUEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZHQUEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756507AbZHQUEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:04:09 -0400
Received: from mail-vw0-f172.google.com ([209.85.212.172]:59157 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbZHQUEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:04:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=JzWmam8d6KDcrxhe+u7NVS8F4rR7w6CQwcScC2+HzkTXSe+wVJgW7b4oY3lIXYUQ+C
         OuSIUtSU6WjNi/4QY/hxhd/ZTBPGNDhl3I0856jFtt4+Qn32aoPqEADTpylbcg3vaeZC
         d7I9MuJ0ZSxqtmyA/AP9NQvdGI3TFxiM/H/34=
MIME-Version: 1.0
Date: Mon, 17 Aug 2009 16:04:08 -0400
Message-ID: <fb7befa20908171304idf69300hb935b3ef7aca40f7@mail.gmail.com>
Subject: Packet drops at the interface and Cannot set device ring parameters: 
	Cannot allocate memory
From: Adayadil Thomas <adayadil.thomas@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running into a weird issue where I am seeing drops happening on
the interfaces.
On looking at the traffic I saw that it is in the range of 80-100
Mbps. I tried to increase the rx descriptor sizes to 4096 from 256
default value.
The first call to eth0 succeeded but the call failed to allocate the
extra descriptors for eth1. But then I dropped the caches and the
command succeded. I have not seen the drops increase thus far but I am
not sure it will go away by increasing the descriptor value (looks
like a band-aid approach). The troubling part is why it could not
release the cache in a timely manner automatically. I am clueless as
to where to start inorder to tackle (debug) this. I am not sure if
this is a e1000e problem or a systemic problem which is causing e1000e
to drop. Any help would be greatly appreciated.


# uname -a
Linux 2.6.20-21 #1 SMP PREEMPT Mon Apr 6 15:05:51 EDT 2009 i686 i686
i386 GNU/Linux


# ethtool -G eth0 rx 4096 tx 4096
# ethtool -G eth1 rx 4096 tx 4096
Cannot set device ring parameters: Cannot allocate memory
# echo 3 > /proc/sys/vm/drop_caches
# ethtool -G eth1 rx 4096 tx 4096


# dmesg
ethtool: page allocation failure. order:4, mode:0xd0
 [<c013eb49>] __alloc_pages+0x275/0x286
 [<c013eb86>] __get_free_pages+0x2c/0x3a
 [<c0107563>] dma_alloc_coherent+0xaa/0xde
 [<f884d081>] e1000_alloc_ring_dma+0x21/0x30 [e1000e]
 [<f884d27e>] e1000e_setup_tx_resources+0x6e/0x100 [e1000e]
 [<f885481e>] e1000_set_ringparam+0x1be/0x220 [e1000e]
 [<c02dc4c0>] dev_ethtool+0x457/0xa0f
 [<c013e84f>] get_page_from_freelist+0x27c/0x301
 [<c0151009>] cache_alloc_refill+0x185/0x458
 [<c013a8da>] find_get_page+0x36/0x3b
 [<c013cbce>] filemap_nopage+0x1ad/0x331
 [<c02db7fa>] netdev_run_todo+0x1fc/0x203
 [<c02d0d2c>] sock_ioctl+0x0/0x1ad
 [<c02d0d2c>] sock_ioctl+0x0/0x1ad
 [<c02db3c5>] dev_ioctl+0x2fd/0x405
 [<c02d0eba>] sock_ioctl+0x18e/0x1ad
 [<c02d0d2c>] sock_ioctl+0x0/0x1ad
 [<c015d593>] do_ioctl+0x1f/0x62
 [<c015d81a>] vfs_ioctl+0x244/0x256
 [<c015d85f>] sys_ioctl+0x33/0x4c
 [<c0102e1c>] sysenter_past_esp+0x5d/0x81
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    4: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    5: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    6: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    7: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  55
CPU    1: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:  58
CPU    2: Hot: hi:  186, btch:  31 usd:  70   Cold: hi:   62, btch:  15 usd:  55
CPU    3: Hot: hi:  186, btch:  31 usd: 138   Cold: hi:   62, btch:  15 usd:  55
CPU    4: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:  52
CPU    5: Hot: hi:  186, btch:  31 usd: 127   Cold: hi:   62, btch:  15 usd:  56
CPU    6: Hot: hi:  186, btch:  31 usd:  15   Cold: hi:   62, btch:  15 usd:  51
CPU    7: Hot: hi:  186, btch:  31 usd:  22   Cold: hi:   62, btch:  15 usd:  56
HighMem per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 104   Cold: hi:   62, btch:  15 usd:   1
CPU    1: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  14
CPU    2: Hot: hi:  186, btch:  31 usd: 142   Cold: hi:   62, btch:  15 usd:   1
CPU    3: Hot: hi:  186, btch:  31 usd:  68   Cold: hi:   62, btch:  15 usd:   5
CPU    4: Hot: hi:  186, btch:  31 usd: 140   Cold: hi:   62, btch:  15 usd:   1
CPU    5: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  11
CPU    6: Hot: hi:  186, btch:  31 usd: 124   Cold: hi:   62, btch:  15 usd:  10
CPU    7: Hot: hi:  186, btch:  31 usd:  35   Cold: hi:   62, btch:  15 usd:   5
Active:202847 inactive:94291 dirty:55 writeback:0 unstable:0
free:453765 slab:77825 mapped:4456 pagetables:527
DMA free:3580kB min:68kB low:84kB high:100kB active:0kB inactive:696kB
present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 873 4048
Normal free:7220kB min:3744kB low:4680kB high:5616kB active:170424kB
inactive:341384kB present:894080kB pages_scanned:0 all_unreclaimable?
no
lowmem_reserve[]: 0 0 25400
HighMem free:1804260kB min:512kB low:3916kB high:7324kB
active:640964kB inactive:35084kB present:3251200kB pages_scanned:0
all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 33*4kB 1*8kB 3*16kB 0*32kB 1*64kB 0*128kB 1*256kB 0*512kB
1*1024kB 1*2048kB 0*4096kB = 3580kB
Normal: 1402*4kB 5*8kB 1*16kB 0*32kB 1*64kB 0*128kB 1*256kB 1*512kB
1*1024kB 0*2048kB 0*4096kB = 7520kB
HighMem: 1973*4kB 7288*8kB 4631*16kB 7487*32kB 2088*64kB 1780*128kB
738*256kB 469*512kB 257*1024kB 113*2048kB 34*4096kB = 1804260kB
Swap cache: add 5606, delete 5603, find 3131/3501, race 0+0
Free swap  = 2096392kB
Total swap = 2096472kB
Free swap:       2096392kB
1048576 pages of RAM
819200 pages of HIGHMEM
215492 reserved pages
150624 pages shared
3 pages swap cached
55 pages dirty
0 pages writeback
4456 pages mapped
77825 pages slab
527 pages pagetables
0000:0c:00.1: eth1: Unable to allocate memory for the transmit descriptor ring
br0: port 2(eth1) entering disabled state
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
br0: port 1(eth0) entering learning state
br0: topology change detected, propagating
br0: port 1(eth0) entering forwarding state
e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
br0: port 2(eth1) entering learning state
br0: topology change detected, propagating
br0: port 2(eth1) entering forwarding state
e1000e: eth1 NIC Link is Down
br0: port 2(eth1) entering disabled state
e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
br0: port 2(eth1) entering learning state
br0: topology change detected, propagating
br0: port 2(eth1) entering forwarding state
br0: port 2(eth1) entering disabled state
e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
br0: port 2(eth1) entering learning state
br0: topology change detected, propagating
br0: port 2(eth1) entering forwarding state




# ethtool -i eth0
driver: e1000e
version: 1.0.2.5-NAPI
firmware-version: 5.6-2
bus-info: 0000:0c:00.0

eth0      Link encap:Ethernet  HWaddr 00:E0:ED:0F:16:BE
          UP BROADCAST RUNNING PROMISC MULTICAST  MTU:1500  Metric:1
          RX packets:3436029702 errors:0 dropped:31819 overruns:0 frame:0
          TX packets:2872201241 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1783568623 (1.6 GiB)  TX bytes:1886902987 (1.7 GiB)

eth1      Link encap:Ethernet  HWaddr 00:E0:ED:0F:16:BF
          UP BROADCAST RUNNING PROMISC MULTICAST  MTU:1500  Metric:1
          RX packets:2883721496 errors:0 dropped:6186 overruns:0 frame:0
          TX packets:3424819629 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:99333482 (94.7 MiB)  TX bytes:2820383654 (2.6 GiB)

# ethtool -S eth0
NIC statistics:
     rx_packets: 3599370976
     tx_packets: 3007621633
     rx_bytes: 3171029123163
     tx_bytes: 883638537034
     rx_broadcast: 308834
     tx_broadcast: 6753
     rx_multicast: 225611
     tx_multicast: 289407
     rx_errors: 0
     tx_errors: 0
     tx_dropped: 0
     multicast: 225611
     collisions: 0
     rx_length_errors: 0
     rx_over_errors: 0
     rx_crc_errors: 0
     rx_frame_errors: 0
     rx_no_buffer_count: 79449
     rx_missed_errors: 746388
     tx_aborted_errors: 0
     tx_carrier_errors: 0
     tx_fifo_errors: 0
     tx_heartbeat_errors: 0
     tx_window_errors: 0
     tx_abort_late_coll: 0
     tx_deferred_ok: 0
     tx_single_coll_ok: 0
     tx_multi_coll_ok: 0
     tx_timeout_count: 0
     tx_restart_queue: 890
     rx_long_length_errors: 0
     rx_short_length_errors: 0
     rx_align_errors: 0
     tx_tcp_seg_good: 0
     tx_tcp_seg_failed: 0
     rx_flow_control_xon: 0
     rx_flow_control_xoff: 0
     tx_flow_control_xon: 3222
     tx_flow_control_xoff: 750395
     rx_long_byte_count: 3171029123163
     rx_csum_offload_good: 3176434523
     rx_csum_offload_errors: 23528
     rx_header_split: 0
     alloc_rx_buff_failed: 0
     tx_smbus: 0
     rx_smbus: 0
     dropped_smbus: 0
     rx_dma_failed: 0
     tx_dma_failed: 0



# lspci
00:00.0 Host bridge: Intel Corporation 5000X Chipset Memory Controller
Hub (rev 12)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express
x4 Port 2 (rev 12)
00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express
x4 Port 3 (rev 12)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express
x8 Port 4-5 (rev 12)
00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express
x4 Port 5 (rev 12)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express
x8 Port 6-7 (rev 12)
00:07.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express
x4 Port 7 (rev 12)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB
Registers (rev 12)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB
Registers (rev 12)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB
Registers (rev 12)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved
Registers (rev 12)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved
Registers (rev 12)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD
Registers (rev 12)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD
Registers (rev 12)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI
Express Root Port 1 (rev 09)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #3 (rev 09)
00:1d.3 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #4 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC
Interface Controller (rev 09)
00:1f.2 IDE interface: Intel Corporation 631xESB/632xESB/3100 Chipset
SATA IDE Controller (rev 09)
01:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS
1078 (rev 04)
02:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3)
03:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708
Gigabit Ethernet (rev 12)
04:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Upstream Port (rev 01)
04:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to
PCI-X Bridge (rev 01)
05:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E1 (rev 01)
05:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E2 (rev 01)
06:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3)
07:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708
Gigabit Ethernet (rev 12)
0a:00.0 PCI bridge: PLX Technology, Inc. PEX 8508 8-lane, 5-port PCI
Express Switch (rev ac)
0b:01.0 PCI bridge: PLX Technology, Inc. PEX 8508 8-lane, 5-port PCI
Express Switch (rev ac)
0b:02.0 PCI bridge: PLX Technology, Inc. PEX 8508 8-lane, 5-port PCI
Express Switch (rev ac)
0c:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit
Ethernet Controller (rev 06)
0c:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit
Ethernet Controller (rev 06)
0d:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit
Ethernet Controller (rev 06)
0d:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit
Ethernet Controller (rev 06)
11:0d.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
