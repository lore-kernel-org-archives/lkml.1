Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbZC2TEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbZC2TEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 15:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbZC2TE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 15:04:28 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:52095 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbZC2TEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 15:04:25 -0400
X-Trace: 174570717/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.47.161/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.41.47.161
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjEFAP9iz0lQKS+h/2dsb2JhbACBULgkDgGMaYI1EwGBMQY
X-IronPort-AV: E=Sophos;i="4.38,442,1233532800"; 
   d="scan'208";a="174570717"
Subject: regression in 2.6.29-git3 on SH/Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Mar 2009 20:04:06 +0100
Message-Id: <1238353446.6471.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While 2.6.29 boots cleanly on the Dreamcast, later revisions are likely
to crash with an OOM condition (this is a race, it doesn't happen on
every boot, but on about one in every three or four).

[    0.000000] Linux version 2.6.29-03652-g5d80f8e (adrian@bossclass) (gcc version 4.2.2) #718 PREEMPT Sun Mar 29 19:28:35 BST 2009
[    0.000000] Boot params:
[    0.000000] ... MOUNT_ROOT_RDONLY - 91f0c75f
[    0.000000] ... RAMDISK_FLAGS     - e1ff3018
[    0.000000] ... ORIG_ROOT_DEV     - 89093610
[    0.000000] ... LOADER_TYPE       - 3612e108
[    0.000000] ... INITRD_START      - 46088904
[    0.000000] ... INITRD_SIZE       - 6002306c
[    0.000000] console [sercon0] enabled
[    0.000000] Booting machvec: Sega Dreamcast
[    0.000000] Node 0: start_pfn = 0xc000, low = 0xd000
[    0.000000] Zone PFN ranges:
[    0.000000]   Normal   0x0000c000 -> 0x0000d000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0: 0x0000c000 -> 0x0000d000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4064
[    0.000000] Kernel command line: root=/dev/nfs rw nfsroot=192.168.61.50:/home/adrian/debdist ip=dhcp earlyprintk=serial video=pvr2fb:640x480-32@60 console=ttySC1 panic=7
[    0.000000] PID hash table entries: 64 (order: 6, 256 bytes)
[    0.000000] Using tmu for system timer
[    0.004326] Console: colour dummy device 80x25
[    0.009300] Dentry cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.016834] Inode-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.026679] Memory: 12420k/16384k available (2435k kernel code, 624k data, 128k init)
[    0.035390] PVR=040205c1 CVR=00000000 PRR=00000000
[    0.040630] I-cache : n_ways=1 n_sets=256 way_incr=8192
[    0.046439] I-cache : entry_mask=0x00001fe0 alias_mask=0x00001000 n_aliases=2
[    0.054274] D-cache : n_ways=1 n_sets=512 way_incr=16384
[    0.060183] D-cache : entry_mask=0x00003fe0 alias_mask=0x00003000 n_aliases=4
[    0.068577] SLUB: Genslabs=11, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.077130] Calibrating delay loop (skipped)... 199.50 BogoMIPS PRESET (lpj=399012)
[    0.086966] Mount-cache hash table entries: 512
[    0.097419] CPU: SH7750
[    0.127143] net_namespace: 296 bytes
[    0.133198] NET: Registered protocol family 16
[    0.196692] bio: create slab <bio-0> at 0
[    0.285816] DMA: Registering DMA API.
[    0.290541] DMA: Registering sh_dmac handler (6 channels).
[    0.306076] DMA: Registering pvr2_dmac handler (1 channel).
[    0.315065] DMA: Registering g2_dmac handler (4 channels).
[    0.327623] Autoconfig PCI channel 0x8c2f9f48
[    0.332423] Scanning bus 00, I/O 0x01001600:0x01003600, Mem 0x01840000:0x01848000
[    0.340680] 00:00.0 Class 0200: 11db:1234 (rev 10)
[    0.345975]         I/O at 0x01001600 [size=0x100]
[    0.351380]         Mem at 0x01840000 [size=0x100]
[    0.359218] PCI: Fixing up device 0000:00:00.0
[    0.469464]  maple: bus core now registered
[    0.474544] NET: Registered protocol family 2
[    0.480185] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.489556] TCP established hash table entries: 512 (order: 0, 4096 bytes)
[    0.497299] TCP bind hash table entries: 512 (order: -1, 2048 bytes)
[    0.504325] TCP: Hash tables configured (established 512 bind 512)
[    0.511162] TCP reno registered
[    0.516384] NET: Registered protocol family 1
[    0.525570] sq: Registering store queue API.
[    0.534341] cpufreq: SuperH CPU frequency driver.
[    0.539554] cpufreq: clock framework rate rounding not supported on this CPU.
[    0.553367] maple <NULL>: detected Dreamcast Controller: function 0x1: at (0, 0)
[    0.561640] maple <NULL>: no driver found
[    0.568710] maple <NULL>: detected Dreamcast Controller: function 0x1: at (1, 0)
[    0.576911] maple <NULL>: no driver found
[    0.582584] maple <NULL>: detected Keyboard: function 0x40: at (2, 0)
[    0.589957] maple <NULL>: no driver found
[    0.595632] maple <NULL>: detected Dreamcast Mouse: function 0x200: at (3, 0)
[    0.603676] maple <NULL>: no driver found
[    0.670106] HugeTLB registered 64 KB page size, pre-allocated 0 pages
[    0.969263] msgmni has been set to 24
[    1.007377] alg: No test for stdrng (krng)
[    1.013335] io scheduler noop registered
[    1.017772] io scheduler anticipatory registered (default)
[    2.143400] Console: switching to colour frame buffer device 80x30
[    2.185575] fb0: NEC PowerVR2 (rev 1.1) frame buffer device, using 1200k/8192k of video memory
[    2.195071] fb0: Mode 640x480-32 pitch = 2560 cable: VGA video output: VGA
[    2.202673] fb0: registering with SQ API
[    2.207350] sqremap:    NEC PowerVR2  [2048 pages]  va 0xe0000000   pa 0xa5000000
[    2.215701] fb0: Mapped video memory to SQ addr 0xe0000000
[    3.405317] SuperH SCI(F) driver initialized
[    3.410647] sh-sci: ttySC0 at MMIO 0xffe00000 (irq = 23) is a sci
[    3.419858] sh-sci: ttySC1 at MMIO 0xffe80000 (irq = 40) is a scif
+�Đ� 3.426755] console handover: boot [sercon0] -> real [ttySC1]
[    3.469192] loop: module loaded
[    3.479670] nbd: registered device at major 43
[    3.565940] 8139too Fast Ethernet driver 0.9.28
[    3.574968] eth0: RealTek RTL8139 at 0xa1001700, 00:d0:f1:03:12:b9, IRQ 83
[    3.589083] mice: PS/2 mouse device common for all mice
[    3.597740] input: Keyboard as /devices/maple/2:00.40/input/input0
[    3.610473] input: Dreamcast Controller as /devices/maple/0:00.1/input/input1
[    3.625513] input: Dreamcast Controller as /devices/maple/1:00.1/input/input2
[    3.639389] TCP cubic registered
[    3.642804] NET: Registered protocol family 17
[    4.620666] RPC: Registered udp transport module.
[    4.625642] RPC: Registered tcp transport module.
[    5.146365] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[    6.156282] Sending DHCP requests ., OK
[    6.168769] IP-Config: Got DHCP answer from 192.168.61.50, my address is 192.168.61.55
[    6.181694] IP-Config: Complete:
[    6.184908]      device=eth0, addr=192.168.61.55, mask=255.255.255.224, gw=192.168.61.50,
[    6.193583]      host=192.168.61.55, domain=, nis-domain=(none),
[    6.199925]      bootserver=192.168.61.50, rootserver=192.168.61.50, rootpath=
[    6.209569] Looking up port of RPC 100003/2 on 192.168.61.50
[    6.222333] Looking up port of RPC 100005/1 on 192.168.61.50
[    6.251512] VFS: Mounted root (nfs filesystem) on device 0:13.
[    6.259236] Freeing unused kernel memory: 128k freed
INIT: �version 2.86 booting�
�Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...udevd-event[1789]: rename_netif: error changing netif name eth0 to eth1: Device or resource busy
[   40.340429] udevd invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=-17
[   40.347734] Stack: (0x8c6f9ce4 to 0x8c6fa000)
[   40.352333] 9ce0:          8c0071ce 8c6f9cf4 00000000 001201d2 8c0542e6 8c6f9cfc 00000041 
[   40.361725] 9d00: 8cf2a0a0 8c054900 8c6f9d2c 000000bc 8cf2a0a0 00000041 00000150 8c2de198 
[   40.370204] 9d20: 8c2de198 00000000 8c2a0788 00000000 001201d2 00000028 10ef26bd 8c0549c6 
[   40.379587] 9d40: 8c6f9d5c 001201d2 00000000 8cc1d220 00000000 001201d2 8c327abc 00000000 
[   40.388493] 9d60: 8c05826a 8c6f9d74 00000000 8c25cac0 00000000 00000000 00000080 8cc1d51c 
[   40.396909] 9d80: 001201d2 00000000 00000000 8c2fdf10 00000010 00000001 00000000 00000042 
[   40.406365] 9da0: 00000000 00000000 00000000 8c05b7d4 8c6f9dcc 8c809154 00000007 0000000f 
[   40.415272] 9dc0: 00000003 0000000a 00000000 8c6f9de8 0000000f 8c98c780 8c809150 00000003 
[   40.423671] 9de0: 00000012 00000003 8c3d8658 8c3c7a38 8c05be7a 8c6f9e14 00008000 8c6f9e84 
[   40.433074] 9e00: 00000007 8c98c780 0000000f 8c809150 00000000 8c05335c 8c6f9e2c 0000000e 
[   40.442018] 9e20: 00000000 8c327cf0 ffffff0f 8c98c7c0 8c8090f8 8c6f5480 8c98c780 8c809150 
[   40.450439] 9e40: 00000000 00000004 8c06a6a8 8c6f9e68 8c6f5480 8c6f9e84 8c6f5480 8c6f7294 
[   40.459825] 9e60: 00000598 00000000 8c6f54c0 29566120 8c6db5a0 00000000 00000204 00000000 
[   40.468733] 9e80: 00000000 00000000 0000000e 29566000 00000000 8c06bc4e 8c6f9ec0 8c6f5480 
[   40.477129] 9ea0: 29566120 8c6f7294 00000000 00000598 8c6fb598 0000000e 00000000 00000000 
[   40.486583] 9ec0: 00000000 8c6db5a0 00003d8f ffffe138 8c152e76 8c25dc0a 8c010f04 8c6f9ef8 
[   40.494983] 9ee0: 8c6f9fe4 8c6f9fa4 8cc1d220 8c6f5480 8c6db5a0 29566120 8c6db5d4 296b5655 
[   40.504387] 9f00: 00000000 8c026724 8c6f9f1c 8c6f9ef4 8c6f9ef4 000000f5 8c325120 8c003a74 
[   40.513280] 9f20: 8c6f9f24 8c25bf84 8c531af0 8cc1d220 8c6db5a0 8cc8fa00 00000000 8c6db5a0 
[   40.521755] 9f40: 10000000 8c6f9f68 8c014970 8c6f9f50 8c25bf9e 8c6f9f68 8cc1d220 8c25bfa4 
[   40.531145] 9f60: 8c25bfb8 8c6f9f68 0000019a 8cc1d41c 8cc1d418 8cc1d3a0 8c6f9f7c 8c010d8a 
[   40.539565] 9f80: 8c6f9f90 8c0080e4 7bb5d144 2970c819 2957a000 0bea6495 8c0080e4 29566120 
[   40.548972] 9fa0: 00000000 0040101c 00400c14 29566120 2957a654 0bea6495 00000061 2970c788 
[   40.557926] 9fc0: 7bb5d1f0 00420d1c 2957a518 00420b70 0bea6495 2957a000 2970c819 7bb5d144 
[   40.566844] 9fe0: 7bb5d144 29566120 2955dbd8 00008001 29708440 00000002 0bea60a9 ffffffff 
[   40.575242] 
[   40.575258] Call trace:
[   40.579922] [<8c0071ce>] dump_stack+0xe/0x20
[   40.584480] [<8c0542e6>] oom_kill_process+0x146/0x280
[   40.589875] [<8c054900>] __out_of_memory+0x120/0x1a0
[   40.595145] [<8c0549c6>] out_of_memory+0x46/0x120
[   40.599678] [<8c05826a>] __alloc_pages_internal+0x40a/0x4a0
[   40.606078] [<8c25cac0>] _cond_resched+0x0/0x60
[   40.610909] [<8c05b7d4>] __do_page_cache_readahead+0x134/0x2c0
[   40.616616] [<8c05be7a>] do_page_cache_readahead+0x3a/0x80
[   40.622424] [<8c05335c>] filemap_fault+0x37c/0x560
[   40.628011] [<8c06a6a8>] __do_fault+0x48/0x540
[   40.632766] [<8c06bc4e>] handle_mm_fault+0xce/0x740
[   40.637945] [<8c152e76>] __up_read+0x56/0x120
[   40.642562] [<8c25dc0a>] down_read+0xa/0x20
[   40.646507] [<8c010f04>] do_page_fault+0x124/0x400
[   40.651619] [<8c026724>] run_timer_softirq+0x1e4/0x220
[   40.657557] [<8c003a74>] __switch_to+0x34/0x1c0
[   40.662866] [<8c25bf84>] __sched_text_start+0x264/0x660
[   40.667929] [<8c014970>] finish_task_switch+0x30/0x120
[   40.672878] [<8c25bf9e>] __sched_text_start+0x27e/0x660
[   40.678413] [<8c25bfa4>] __sched_text_start+0x284/0x660
[   40.684458] [<8c25bfb8>] __sched_text_start+0x298/0x660
[   40.689991] [<8c010d8a>] __do_page_fault+0xea/0x140
[   40.694665] [<8c0080e4>] ret_from_exception+0x0/0x8
[   40.700352] [<8c0080e4>] ret_from_exception+0x0/0x8
[   40.705523] 
[   40.707141] Mem-Info:
[   40.709521] Normal per-cpu:
[   40.712005] CPU    0: hi:    0, btch:   1 usd:   0
[   40.717094] Active_anon:654 active_file:6 inactive_anon:555
[   40.717120]  inactive_file:85 unevictable:0 dirty:0 writeback:0 unstable:0
[   40.717149]  free:127 slab:885 mapped:8 pagetables:174 bounce:0
[   40.737271] Normal free:508kB min:508kB low:632kB high:760kB active_anon:2616kB inactive_anon:2220kB active_file:24kB inactive_file:340kB unevictable:0kB present:16256kB pages_scanned:8768 all_s
[   40.755855] lowmem_reserve[]: 0 0
[   40.758930] Normal: 11*4kB 8*8kB 7*16kB 3*32kB 1*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 508kB
[   40.770957] 92 total pagecache pages
[   40.775236] 0 pages in swap cache
[   40.778257] Swap cache stats: add 0, delete 0, find 0/0
[   40.783274] Free swap  = 0kB
[   40.786335] Total swap = 0kB
[   40.790783] 4096 pages RAM
[   40.793614] 959 pages reserved
[   40.796865] 2654 pages shared
[   40.800035] 2429 pages non-shared
[   40.803053] 10 pages in pagetable cache
[   40.807117] Out of memory: kill process 1697 (rc) score 65 or a child
[   40.814410] Killed process 1740 (S03udev)
[   48.042363] udevd invoked oom-killer: gfp_mask=0x1200d2, order=0, oomkilladj=-17
[   48.050134] Stack: (0x8cea7d9c to 0x8cea8000)
[   48.054146] 7d80:                                                                8c0071ce 
[   48.063606] 7da0: 8cea7dac 00000000 001200d2 8c0542e6 8cea7db4 00000033 8cf283a0 8c054900 
[   48.072515] 7dc0: 8cea7de4 000000bc 8cf283a0 00000033 00000150 8c2de198 8c2de198 00000000 
[   48.081407] 7de0: 8c2a0788 00000000 001200d2 0000002f 3ac571bb 8c0549c6 8cea7e14 001200d2 
[   48.090398] 7e00: 00000000 8c645960 00000000 001200d2 8c327abc 00000000 8c05826a 8cea7e2c 
[   48.098704] 7e20: 00000000 8c25cac0 00000000 00000000 00000080 8c645c5c 001200d2 00000000 
[   48.108218] 7e40: 00000000 8c2fdf10 00000010 00000001 00000000 00000042 00000000 00000000 
[   48.117105] 7e60: 00000000 8c06b354 8cea7e84 2974356c 8ceaad0c 8ceab480 0cb4015c 8c3d1800 
[   48.125429] 7e80: 8c327dd8 8c665780 00000003 29727000 8c3d4a80 8c06bf92 8cea7ec0 8ceab480 
[   48.134965] 7ea0: 2974356c 8cea8294 0cb4015c 8c6657c0 8ceaad0c 8cea8294 8c6657c0 0cb4015c 
[   48.143878] 7ec0: 00000001 8c665780 00004d53 ffffd956 8c152e76 8c25dc0a 8c010f04 8cea7ef8 
[   48.152185] 7ee0: 8cea7fe4 8cea7fa4 8c645960 8ceab480 8c665780 2974356c 8c6657b4 7bb5d2c0 
[   48.161687] 7f00: 00000001 8c026724 8cea7f1c 8cea7ef4 8cea7ef4 0000003f 8c325120 8c003a74 
[   48.170639] 7f20: 8cea7f24 8c25bf84 8ce8fd70 8c645960 8c665780 8cf2a440 00000000 8c665780 
[   48.178964] 7f40: 00000000 8cea7f68 8c014970 8cea7f50 8c25bf9e 8cea7f68 8c645960 8c25bfa4 
[   48.188444] 7f60: 8c25bfb8 8cea7f68 0000000a 8c645b5c 8c645b58 8c645ae0 8c645a1c 8c010d8a 
[   48.197356] 7f80: 8cea7f90 8c0080e4 7bb5d228 7bb5d2c4 2957a000 0000000a 8c0080e4 2974356c 
[   48.205735] 7fa0: 00000001 29724000 00000000 295cc6f8 295a8a6c 295b3ad7 2972669c 2972595c 
[   48.215215] 7fc0: 00000000 29727170 29724000 0001f56c 0000000a 2957a000 7bb5d2c4 7bb5d228 
[   48.224134] 7fe0: 7bb5d228 29560542 29560512 00008001 29708440 00000002 0bea60a9 ffffffff 
[   48.232438] 
[   48.232454] Call trace:
[   48.237213] [<8c0071ce>] dump_stack+0xe/0x20
[   48.242359] [<8c0542e6>] oom_kill_process+0x146/0x280
[   48.247121] [<8c054900>] __out_of_memory+0x120/0x1a0
[   48.251803] [<8c0549c6>] out_of_memory+0x46/0x120
[   48.256816] [<8c05826a>] __alloc_pages_internal+0x40a/0x4a0
[   48.262715] [<8c25cac0>] _cond_resched+0x0/0x60
[   48.268130] [<8c06b354>] do_wp_page+0x1f4/0xa20
[   48.272964] [<8c06bf92>] handle_mm_fault+0x412/0x740
[   48.278231] [<8c152e76>] __up_read+0x56/0x120
[   48.282849] [<8c25dc0a>] down_read+0xa/0x20
[   48.286702] [<8c010f04>] do_page_fault+0x124/0x400
[   48.292403] [<8c026724>] run_timer_softirq+0x1e4/0x220
[   48.297844] [<8c003a74>] __switch_to+0x34/0x1c0
[   48.302069] [<8c25bf84>] __sched_text_start+0x264/0x660
[   48.307626] [<8c014970>] finish_task_switch+0x30/0x120
[   48.313660] [<8c25bf9e>] __sched_text_start+0x27e/0x660
[   48.319784] [<8c25bfa4>] __sched_text_start+0x284/0x660
[   48.324749] [<8c25bfb8>] __sched_text_start+0x298/0x660
[   48.329693] [<8c010d8a>] __do_page_fault+0xea/0x140
[   48.334275] [<8c0080e4>] ret_from_exception+0x0/0x8
[   48.340650] [<8c0080e4>] ret_from_exception+0x0/0x8
[   48.346407] 
[   48.348027] Mem-Info:
[   48.350408] Normal per-cpu:
[   48.352801] CPU    0: hi:    0, btch:   1 usd:   0
[   48.357308] Active_anon:333 active_file:1 inactive_anon:286
[   48.357334]  inactive_file:97 unevictable:0 dirty:0 writeback:0 unstable:0
[   48.357362]  free:130 slab:890 mapped:9 pagetables:171 bounce:0
[   48.377079] Normal free:520kB min:508kB low:632kB high:760kB active_anon:1332kB inactive_anon:1144kB active_file:4kB inactive_file:388kB unevictable:0kB present:16256kB pages_scanned:19139 all_o
[   48.395971] lowmem_reserve[]: 0 0
[   48.399539] Normal: 14*4kB 6*8kB 8*16kB 3*32kB 1*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 520kB
[   48.411154] 107 total pagecache pages
[   48.414438] 0 pages in swap cache
[   48.417956] Swap cache stats: add 0, delete 0, find 0/0
[   48.424058] Free swap  = 0kB
[   48.427712] Total swap = 0kB
[   48.431131] 4096 pages RAM
[   48.433962] 959 pages reserved
[   48.436626] 3126 pages shared
[   48.439798] 1899 pages non-shared
[   48.443312] 14 pages in pagetable cache
[   48.447968] Out of memory: kill process 1696 (init) score 51 or a child
[   48.454944] Killed process 1697 (rc)
INIT: Entering runlevel: 2
[   76.559675] udevd invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=-17
[   76.567502] Stack: (0x8cd7bce4 to 0x8cd7c000)
[   76.572145] bce0:          8c0071ce 8cd7bcf4 00000000 001201d2 8c0542e6 8cd7bcfc 00000041 
[   76.580147] bd00: 8c874000 8c054900 8cd7bd2c 000000bc 8c874000 00000041 00000150 8c2de198 
[   76.590038] bd20: 8c2de198 00000000 8c2a0788 00000000 001201d2 0000004c 1dfe3058 8c0549c6 
[   76.598951] bd40: 8cd7bd5c 001201d2 00000000 8cf2b2c0 00000000 001201d2 8c327abc 00000000 
[   76.606998] bd60: 8c05826a 8cd7bd74 00000000 8c25cac0 00000000 00000000 00000080 8cf2b5bc 
[   76.617757] bd80: 001201d2 00000000 00000000 8c2fdf10 00000010 00000001 00000000 00000042 
[   76.624813] bda0: 00000000 00000000 00000000 8c05b7d4 8cd7bdcc 8c81e854 00000000 0000000f 
[   76.633721] bdc0: 00000000 00000000 00000000 8cd7bde8 0000000f 8c98c840 8c81e850 00000000 
[   76.643616] bde0: 0000000d 00000000 8cd7bde8 8cd7bde8 8c05be7a 8cd7be14 00008000 8cd7be84 
[   76.651616] be00: 00000000 8c98c840 0000000f 8c81e850 00000000 8c05335c 8cd7be2c 00000006 
[   76.661463] be20: 00000000 8c327cf0 ffffff0f 8c98c880 8c81e7f8 8cd78900 8c98c840 8c81e850 
[   76.669462] be40: 00000000 00000004 8c06a6a8 8cd7be68 8cd78900 8cd7be84 8cd78900 8c670004 
[   76.679290] be60: 00000018 00000000 8cd78940 00406382 8cee8b40 00000000 00000200 00000000 
[   76.688282] be80: 00000000 00000000 00000006 00406000 00000000 8c06bc4e 8cd7bec0 8cd78900 
[   76.696241] bea0: 00406382 8c670004 00000000 00000018 8cd7c018 00000006 00000000 00000000 
[   76.706099] bec0: 00000000 8cee8b40 00000071 7bb5b494 8c152e76 8c25dc0a 8c010f04 8cd7bef8 
[   76.714992] bee0: 8cd7bfe4 8cd7bfa4 8cf2b2c0 8cd78900 8cee8b40 00406382 8cee8b74 00000000 
[   76.723043] bf00: 00000000 00001000 00000000 00000000 49cfc114 2b312792 49cfc114 2b312792 
[   76.733807] bf20: 49cfc114 2b312792 00000028 00000000 8c08ee40 8cd7bf48 00000000 00000071 
[   76.740864] bf40: 0000007f 7bb5b494 00000028 00000000 00000000 8c0841ed 0000000c 00000000 
[   76.749776] bf60: 00000000 00000000 00000000 00000000 49cfc114 2b312792 49cfc114 8c010d8a 
[   76.759685] bf80: 8cd7bf90 8c0080e4 7bb5ac78 00401f84 0043f694 0040a024 8c0080e4 00406382 
[   76.767682] bfa0: 00000000 00000007 0000006c 00000007 00000000 0043f91c 0043f69d 00000080 
[   76.777523] bfc0: 0043f6a5 0043f914 29668ca4 0043f688 0040a024 0043f694 00401f84 7bb5ac78 
[   76.785516] bfe0: 7bb5ac78 00406382 00406382 00008000 29708440 00000002 0b7b287e ffffffff 
[   76.795343] 
[   76.795359] Call trace:
[   76.798594] [<8c0071ce>] dump_stack+0xe/0x20
[   76.803165] [<8c0542e6>] oom_kill_process+0x146/0x280
[   76.809451] [<8c054900>] __out_of_memory+0x120/0x1a0
[   76.814719] [<8c0549c6>] out_of_memory+0x46/0x120
[   76.819745] [<8c05826a>] __alloc_pages_internal+0x40a/0x4a0
[   76.824710] [<8c25cac0>] _cond_resched+0x0/0x60
[   76.830477] [<8c05b7d4>] __do_page_cache_readahead+0x134/0x2c0
[   76.836689] [<8c05be7a>] do_page_cache_readahead+0x3a/0x80
[   76.841560] [<8c05335c>] filemap_fault+0x37c/0x560
[   76.846649] [<8c06a6a8>] __do_fault+0x48/0x540
[   76.852351] [<8c06bc4e>] handle_mm_fault+0xce/0x740
[   76.857531] [<8c152e76>] __up_read+0x56/0x120
[   76.862150] [<8c25dc0a>] down_read+0xa/0x20
[   76.866591] [<8c010f04>] do_page_fault+0x124/0x400
[   76.870788] [<8c08ee40>] sys_lstat64+0x20/0x40
[   76.875519] [<8c0841ed>] init_object+0xad/0xc0
[   76.881180] [<8c010d8a>] __do_page_fault+0xea/0x140
[   76.886379] [<8c0080e4>] ret_from_exception+0x0/0x8
[   76.891551] [<8c0080e4>] ret_from_exception+0x0/0x8
[   76.895781] 
[   76.897349] Mem-Info:
[   76.900734] Normal per-cpu:
[   76.903731] CPU    0: hi:    0, btch:   1 usd:   0
[   76.907870] Active_anon:77 active_file:6 inactive_anon:34
[   76.907895]  inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
[   76.907923]  free:135 slab:940 mapped:11 pagetables:219 bounce:0
[   76.927830] Normal free:540kB min:508kB low:632kB high:760kB active_anon:308kB inactive_anon:136kB active_file:24kB inactive_file:0kB unevictable:0kB present:16256kB pages_scanned:1244 all_unreo
[   76.947904] lowmem_reserve[]: 0 0
[   76.950539] Normal: 21*4kB 15*8kB 5*16kB 2*32kB 1*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 540kB
[   76.960732] 70 total pagecache pages
[   76.965454] 0 pages in swap cache
[   76.969002] Swap cache stats: add 0, delete 0, find 0/0
[   76.974499] Free swap  = 0kB
[   76.977561] Total swap = 0kB
[   76.980670] 4096 pages RAM
[   76.984524] 959 pages reserved
[   76.987782] 5056 pages shared
[   76.990881] 1476 pages non-shared
[   76.993457] 0 pages in pagetable cache
[   76.998372] Out of memory: kill process 2067 (rc) score 65 or a child
[   77.004265] Killed process 2220 (rc)
[   79.850346] udevd invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=-17
[   79.858185] Stack: (0x8cd7bce4 to 0x8cd7c000)
[   79.861814] bce0:          8c0071ce 8cd7bcf4 00000000 001201d2 8c0542e6 8cd7bcfc 0000002b 
[   79.871761] bd00: 8c874000 8c054900 8cd7bd2c 000000bc 8c874000 0000002b 00000150 8c2de198 
[   79.880674] bd20: 8c2de198 00000000 8c2a0788 00000000 001201d2 0000004f 2f514f84 8c0549c6 
[   79.888654] bd40: 8cd7bd5c 001201d2 00000000 8cf2b2c0 00000000 001201d2 8c327abc 00000000 
[   79.898521] bd60: 8c05826a 8cd7bd74 00000000 8c25cac0 00000000 00000000 00000080 8cf2b5bc 
[   79.907445] bd80: 001201d2 00000000 00000000 8c2fdf10 00000010 00000001 00000000 00000042 
[   79.916390] bda0: 00000000 00000000 00000000 8c05b7d4 8cd7bdcc 8c81e854 00000000 0000000f 
[   79.925313] bdc0: 00000000 00000000 00000000 8cd7bde8 0000000f 8c98c840 8c81e850 00000000 
[   79.933228] bde0: 0000000d 00000000 8cd7bde8 8cd7bde8 8c05be7a 8cd7be14 00008000 8cd7be84 
[   79.943153] be00: 00000000 8c98c840 0000000f 8c81e850 00000000 8c05335c 8cd7be2c 00000006 
[   79.951167] be20: 00000000 8c327cf0 ffffff0f 8c98c880 8c81e7f8 8cd78900 8c98c840 8c81e850 
[   79.961073] be40: 00000000 00000004 8c06a6a8 8cd7be68 8cd78900 8cd7be84 8cd78900 8c670004 
[   79.969965] be60: 00000018 00000000 8cd78940 00406382 8cee8b40 00000000 00000200 00000000 
[   79.977913] be80: 00000000 00000000 00000006 00406000 00000000 8c06bc4e 8cd7bec0 8cd78900 
[   79.986877] bea0: 00406382 8c670004 00000000 00000018 8cd7c018 00000006 00000000 00000000 
[   79.996760] bec0: 00000000 8cee8b40 00000071 7bb5b494 8c152e76 8c25dc0a 8c010f04 8cd7bef8 
[   80.005687] bee0: 8cd7bfe4 8cd7bfa4 8cf2b2c0 8cd78900 8cee8b40 00406382 8cee8b74 00000000 
[   80.013604] bf00: 00000000 00001000 00000000 00000000 49cfc114 2b312792 49cfc114 2b312792 
[   80.023503] bf20: 49cfc114 2b312792 00000028 00000000 8c08ee40 8cd7bf48 00000000 00000071 
[   80.032451] bf40: 0000007f 7bb5b494 00000028 00000000 00000000 8c0841ed 0000000c 00000000 
[   80.041373] bf60: 00000000 00000000 00000000 00000000 49cfc114 2b312792 49cfc114 8c010d8a 
[   80.049288] bf80: 8cd7bf90 8c0080e4 7bb5ac78 00401f84 0043f694 0040a024 8c0080e4 00406382 
[   80.058214] bfa0: 00000000 00000007 0000006c 00000007 00000000 0043f91c 0043f69d 00000080 
[   80.068137] bfc0: 0043f6a5 0043f914 29668ca4 0043f688 0040a024 0043f694 00401f84 7bb5ac78 
[   80.076088] bfe0: 7bb5ac78 00406382 00406382 00008000 29708440 00000002 0b7b287e ffffffff 
[   80.085953] 
[   80.085969] Call trace:
[   80.090167] [<8c0071ce>] dump_stack+0xe/0x20
[   80.093733] [<8c0542e6>] oom_kill_process+0x146/0x280
[   80.099081] [<8c054900>] __out_of_memory+0x120/0x1a0
[   80.105354] [<8c0549c6>] out_of_memory+0x46/0x120
[   80.110350] [<8c05826a>] __alloc_pages_internal+0x40a/0x4a0
[   80.116249] [<8c25cac0>] _cond_resched+0x0/0x60
[   80.120120] [<8c05b7d4>] __do_page_cache_readahead+0x134/0x2c0
[   80.127293] [<8c05be7a>] do_page_cache_readahead+0x3a/0x80
[   80.133099] [<8c05335c>] filemap_fault+0x37c/0x560
[   80.138205] [<8c06a6a8>] __do_fault+0x48/0x540
[   80.141982] [<8c06bc4e>] handle_mm_fault+0xce/0x740
[   80.147159] [<8c152e76>] __up_read+0x56/0x120
[   80.152754] [<8c25dc0a>] down_read+0xa/0x20
[   80.157224] [<8c010f04>] do_page_fault+0x124/0x400
[   80.162324] [<8c08ee40>] sys_lstat64+0x20/0x40
[   80.167061] [<8c0841ed>] init_object+0xad/0xc0
[   80.170826] [<8c010d8a>] __do_page_fault+0xea/0x140
[   80.176990] [<8c0080e4>] ret_from_exception+0x0/0x8
[   80.182173] [<8c0080e4>] ret_from_exception+0x0/0x8
[   80.186381] 
[   80.188017] Mem-Info:
[   80.190398] Normal per-cpu:
[   80.194355] CPU    0: hi:    0, btch:   1 usd:   0
[   80.199427] Active_anon:344 active_file:0 inactive_anon:362
[   80.199453]  inactive_file:26 unevictable:0 dirty:0 writeback:0 unstable:0
[   80.199481]  free:127 slab:940 mapped:2 pagetables:216 bounce:0
[   80.217646] Normal free:508kB min:508kB low:632kB high:760kB active_anon:1376kB inactive_anon:1448kB active_file:0kB inactive_file:104kB unevictable:0kB present:16256kB pages_scanned:28399 all_s
[   80.238211] lowmem_reserve[]: 0 0
[   80.242775] Normal: 15*4kB 14*8kB 5*16kB 2*32kB 1*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 508kB
[   80.251936] 60 total pagecache pages
[   80.255750] 0 pages in swap cache
[   80.259267] Swap cache stats: add 0, delete 0, find 0/0
[   80.265741] Free swap  = 0kB
[   80.268803] Total swap = 0kB
[   80.272821] 4096 pages RAM
[   80.275717] 959 pages reserved
[   80.278905] 4175 pages shared
[   80.281081] 2110 pages non-shared
[   80.285575] 4 pages in pagetable cache
[   80.289582] Out of memory: kill process 2067 (rc) score 43 or a child
[   80.295406] Killed process 2067 (rc)
[  125.007001] kthreadd invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[  125.016067] Stack: (0x8cc27d94 to 0x8cc28000)
[  125.020697] 7d80:                                              8c0071ce 8cc27da4 00000001 
[  125.029638] 7da0: 000000d0 8c0542e6 8cc27dac 0000001d 8cc1fa00 8c054900 8cc27ddc 000000bc 
[  125.038572] 7dc0: 8cc1fa00 0000001d 00000150 8c2de198 8c2de198 00000000 8c2a0788 00000001 
[  125.045980] 7de0: 000000d0 0000007c 38bc3280 8c0549c6 8cc27e0c 000000d0 00000001 8cc1c3a0 
[  125.056477] 7e00: 00000001 000000d0 8c327abc 00000000 8c05826a 8cc27e24 00000000 8c25cac0 
[  125.063869] 7e20: 00000000 00000000 00000080 8cc1c69c 000200d0 00000000 00000000 8c2fdf10 
[  125.074357] 7e40: 00000010 00000000 00000000 00000042 00000002 00000000 00000000 8c058314 
[  125.081778] 7e60: 8cc27e7c 8ce00ae0 00800711 8ce00ae0 8cc1c3a0 8c320644 00000000 8c017e42 
[  125.092215] 7e80: 8cc27e84 0000015f 00000000 8cc27f04 00000000 8c25c432 8cc27e9c 8c019146 
[  125.101127] 7ea0: 8cc27ec8 00000000 00000000 00000000 00000000 00800711 00000000 00000000 
[  125.110072] 7ec0: 00000000 00000000 00000000 8cc27ee4 8cc1c02c 8c015066 8cc27ee4 8c003c48 
[  125.117461] 7ee0: 8cc27f04 8c013820 8c0138c0 8c034520 00000611 8ce31ef4 8ce31f18 00000000 
[  125.127875] 7f00: 00000000 00000000 00000000 00000000 00000000 8ce31ef4 8c034520 00000000 
[  125.136780] 7f20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
[  125.145718] 7f40: 00000000 8c003c80 00000000 40000000 00000000 00000000 00000000 00000000 
[  125.153099] 7f60: 8c0346b8 8cc27f78 8c2e5988 8ce31ef4 0000015f 8ce31f18 00000000 8c003c88 
[  125.163515] 7f80: 8cc27f9c 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
[  125.172419] 7fa0: 00000000 00000000 00000000 00000000 00000000 00000000 8c0345a0 00000000 
[  125.181323] 7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
[  125.190263] 7fe0: 8cc27fa4 8c003c80 00000000 40000000 00000000 00000000 00000000 00000000 
[  125.197639] 
[  125.197655] Call trace:
[  125.203351] [<8c0071ce>] dump_stack+0xe/0x20
[  125.207891] [<8c0542e6>] oom_kill_process+0x146/0x280
[  125.211722] [<8c054900>] __out_of_memory+0x120/0x1a0
[  125.218533] [<8c0549c6>] out_of_memory+0x46/0x120
[  125.223529] [<8c05826a>] __alloc_pages_internal+0x40a/0x4a0
[  125.227922] [<8c25cac0>] _cond_resched+0x0/0x60
[  125.234289] [<8c058314>] __get_free_pages+0x14/0x60
[  125.239471] [<8c017e42>] copy_process+0x62/0x1200
[  125.242942] [<8c25c432>] preempt_schedule+0x32/0x60
[  125.249657] [<8c019146>] do_fork+0x66/0x380
[  125.254117] [<8c015066>] update_curr+0xe6/0x120
[  125.257395] [<8c003c48>] kernel_thread+0x48/0x80
[  125.262291] [<8c013820>] sub_preempt_count+0x0/0xa0
[  125.268999] [<8c0138c0>] add_preempt_count+0x0/0xc0
[  125.274171] [<8c034520>] kthread+0x0/0x80
[  125.278449] [<8c034520>] kthread+0x0/0x80
[  125.282739] [<8c003c80>] kernel_thread_helper+0x0/0x20
[  125.286661] [<8c0346b8>] kthreadd+0x118/0x200
[  125.292819] [<8c003c88>] kernel_thread_helper+0x8/0x20
[  125.298290] [<8c0345a0>] kthreadd+0x0/0x200
[  125.301218] [<8c003c80>] kernel_thread_helper+0x0/0x20
[  125.306630] 
[  125.309776] Mem-Info:
[  125.312157] Normal per-cpu:
[  125.315153] CPU    0: hi:    0, btch:   1 usd:   0
[  125.320226] Active_anon:104 active_file:0 inactive_anon:30
[  125.320252]  inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
[  125.320280]  free:142 slab:922 mapped:1 pagetables:213 bounce:0
[  125.337702] Normal free:568kB min:508kB low:632kB high:760kB active_anon:416kB inactive_anon:120kB active_file:0kB inactive_file:0kB unevictable:0kB present:16256kB pages_scanned:0 all_unreclaio
[  125.357989] lowmem_reserve[]: 0 0
[  125.361500] Normal: 40*4kB 9*8kB 5*16kB 2*32kB 1*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 568kB
[  125.371003] 16 total pagecache pages
[  125.376314] 0 pages in swap cache
[  125.379831] Swap cache stats: add 0, delete 0, find 0/0
[  125.385344] Free swap  = 0kB
[  125.388405] Total swap = 0kB
[  125.390906] 4096 pages RAM
[  125.393803] 959 pages reserved
[  125.398593] 4601 pages shared
[  125.401746] 1669 pages non-shared
[  125.405206] 7 pages in pagetable cache
[  125.407654] Out of memory: kill process 1935 (udevsettle) score 29 or a child
[  125.416721] Killed process 1935 (udevsettle)
[  130.753537] udevd invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=-17
[  130.762908] Stack: (0x8cf83ce4 to 0x8cf84000)
[  130.769102] 3ce0:          8c0071ce 8cf83cf4 00000000 001201d2 8c0542e6 8cf83cfc 00000013 
[  130.774845] 3d00: 8c8755c0 8c054900 8cf83d2c 000000bc 8c8755c0 00000013 00000150 8c2de198 
[  130.785342] 3d20: 8c2de198 00000000 8c2a0788 00000000 001201d2 00000082 29a173b9 8c0549c6 
[  130.792743] 3d40: 8cf83d5c 001201d2 00000000 8ce00740 00000000 001201d2 8c327abc 00000000 
[  130.803231] 3d60: 8c05826a 8cf83d74 00000000 8c25cac0 00000000 00000000 00000080 8ce00a3c 
[  130.812156] 3d80: 001201d2 00000000 00000000 8c2fdf10 00000010 00000001 00000000 00000042 
[  130.819475] 3da0: 00000000 00000000 00000000 8c05b7d4 8cf83dcc 8c809ed4 00000068 0000000f 
[  130.830031] 3dc0: 00000004 0000006c 00000000 8cf83de8 0000000f 8c98cf00 8c809ed0 00000004 
[  130.837369] 3de0: 000000e6 00000004 8c3cd4d8 8c3d4c78 8c05be7a 8cf83e14 00008000 8cf83e84 
[  130.847858] 3e00: 00000068 8c98cf00 0000000f 8c809ed0 00000000 8c05335c 8cf83e2c 0000006f 
[  130.855193] 3e20: 00000000 8c327cf0 ffffff0f 8c98cf40 8c809e78 8cb91000 8c98cf00 8c809ed0 
[  130.865687] 3e40: 00000000 00000004 8c06a6a8 8cf83e68 8cb91000 8cf83e84 8cb91000 8cf30294 
[  130.874688] 3e60: 0000084c 00000000 8cb91040 29613aa0 8cd6a000 00000000 00000200 00000000 
[  130.881998] 3e80: 00000000 00000000 0000006f 29613000 00000000 8c06bc4e 8cf83ec0 8cb91000 
[  130.892520] 3ea0: 29613aa0 8cf30294 00000000 0000084c 8c94184c 0000006f 00000000 00000000 
[  130.901412] 3ec0: 00000000 8cd6a000 6b6b6b6b 6b6b6b6b 8c152e76 8c25dc0a 8c010f04 8cf83ef8 
[  130.910400] 3ee0: 8cf83fe4 8cf83fa4 8ce00740 8cb91000 8cd6a000 29613aa0 8cd6a034 8c320278 
[  130.917703] 3f00: 00000000 8c0133fa 8cf83f14 8ce0076c 8c320278 8c25be0c 8cf83f28 8c25bd20 
[  130.928228] 3f20: 8c25bfb8 8c0280da 8cf83f3c 8ce00890 000002c0 8c028070 8cf83f3c 00010000 
[  130.935549] 3f40: 00000000 8c02bd0a 8cf83f64 00000000 29698acc 00000000 00000001 00000000 
[  130.946109] 3f60: 8cf83f78 8c02db12 8cf83f7c 00000000 00000071 00000000 00000000 8c010d8a 
[  130.953424] 3f80: 8cf83f90 8c0080e4 7bb5d31c 00000000 004402b8 004402f4 8c0080e4 29613aa0 
[  130.963947] 3fa0: 00000000 29613aa0 00000000 00000000 000000ae 000000b4 7bb5d274 00000000 
[  130.972883] 3fc0: 00000118 7bb5d520 004017a4 00402198 004402f4 004402b8 00000000 7bb5d31c 
[  130.980183] 3fe0: 7bb5d31c 29613aa0 0040285e 00008000 29708440 00000002 006825f0 ffffffff 
[  130.990761] 
[  130.990778] Call trace:
[  130.993354] [<8c0071ce>] dump_stack+0xe/0x20
[  130.997896] [<8c0542e6>] oom_kill_process+0x146/0x280
[  131.004858] [<8c054900>] __out_of_memory+0x120/0x1a0
[  131.010142] [<8c0549c6>] out_of_memory+0x46/0x120
[  131.015138] [<8c05826a>] __alloc_pages_internal+0x40a/0x4a0
[  131.019459] [<8c25cac0>] _cond_resched+0x0/0x60
[  131.025938] [<8c05b7d4>] __do_page_cache_readahead+0x134/0x2c0
[  131.032120] [<8c05be7a>] do_page_cache_readahead+0x3a/0x80
[  131.036347] [<8c05335c>] filemap_fault+0x37c/0x560
[  131.043049] [<8c06a6a8>] __do_fault+0x48/0x540
[  131.047784] [<8c06bc4e>] handle_mm_fault+0xce/0x740
[  131.051367] [<8c152e76>] __up_read+0x56/0x120
[  131.057616] [<8c25dc0a>] down_read+0xa/0x20
[  131.062057] [<8c010f04>] do_page_fault+0x124/0x400
[  131.065550] [<8c0133fa>] pick_next_task_fair+0x5a/0xc0
[  131.071025] [<8c25be0c>] __sched_text_start+0xec/0x660
[  131.078066] [<8c25bd20>] __sched_text_start+0x0/0x660
[  131.085015] [<8c25bfb8>] __sched_text_start+0x298/0x660
[  131.088996] [<8c0280da>] do_sigaction+0x13a/0x1a0
[  131.092397] [<8c028070>] do_sigaction+0xd0/0x1a0
[  131.097296] [<8c02bd0a>] sys_rt_sigaction+0x8a/0xe0
[  131.102486] [<8c02db12>] sys_setpriority+0x152/0x260
[  131.109358] [<8c010d8a>] __do_page_fault+0xea/0x140
[  131.114529] [<8c0080e4>] ret_from_exception+0x0/0x8
[  131.119703] [<8c0080e4>] ret_from_exception+0x0/0x8
[  131.123304] 
[  131.124930] Mem-Info:
[  131.127317] Normal per-cpu:
[  131.131894] CPU    0: hi:    0, btch:   1 usd:   0
[  131.136968] Active_anon:597 active_file:1 inactive_anon:597
[  131.137003]  inactive_file:26 unevictable:0 dirty:0 writeback:0 unstable:0
[  131.137042]  free:171 slab:967 mapped:25 pagetables:210 bounce:0
[  131.154685] Normal free:684kB min:508kB low:632kB high:760kB active_anon:2388kB inactive_anon:2388kB active_file:4kB inactive_file:104kB unevictable:0kB present:16256kB pages_scanned:0 all_unreo
[  131.175419] lowmem_reserve[]: 0 0
[  131.180589] Normal: 61*4kB 23*8kB 10*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 684kB
[  131.188620] 94 total pagecache pages
[  131.192405] 0 pages in swap cache
[  131.195868] Swap cache stats: add 0, delete 0, find 0/0
[  131.202961] Free swap  = 0kB
[  131.206054] Total swap = 0kB
[  131.210004] 4096 pages RAM
[  131.212836] 959 pages reserved
[  131.216087] 4370 pages shared
[  131.217645] 2550 pages non-shared
[  131.221193] 12 pages in pagetable cache
[  131.226859] Out of memory: kill process 2222 (sed) score 19 or a child
[  131.233749] Killed process 2222 (sed)
[  140.368779] Kernel panic - not syncing: Out of memory and no killable processes...
[  140.368817] 
[  140.380006] Rebooting in 7 seconds..

Bisection gives this:

adrian@bossclass:~/linux-2.6$ git bisect good
955c0778723501cc16fec40501cd54b7e72d3e74 is first bad commit
commit 955c0778723501cc16fec40501cd54b7e72d3e74
Author: Magnus Damm <damm@igel.co.jp>
Date:   Thu Jan 22 09:55:31 2009 +0000

    sh: rework clocksource and sched_clock
    
    Rework and simplify the sched_clock and clocksource code. Instead
    of registering the clocksource in a shared file we move it into the
    tmu driver. Also, add code to handle sched_clock in the case of no
    clocksource.
    
    Signed-off-by: Magnus Damm <damm@igel.co.jp>
    Signed-off-by: Paul Mundt <lethal@linux-sh.org>

:040000 040000 0d5ff6c830bfedc524a6c057445f91c2cbfe4808 b169b96bb9505399f2e3a9a776cbfdd19e5131d2 M	arch

Reverting this commit seems to let the Dreamcast boot cleanly [1].

This is the second time I have reported this problem - previously to linux-sh list when testing the patches waiting
to be added when the merge window opened.

I'm afraid that earlier report was greeted with some scepticism (I don't know why this patch
breaks the Dreamcast or why it could possibly), so I said I' test it again when the patches
were sent upstream.

I'll see what I can do about finding out *why* this patch breaks the Dreamcast.

Adrian

[1] Clean boot with patch reverted:

[    0.000000] Linux version 2.6.29-03653-g8a55ca2 (adrian@bossclass) (gcc version 4.2.2) #719 PREEMPT Sun Mar 29 19:50:35 BST 2009
[    0.000000] Boot params:
[    0.000000] ... MOUNT_ROOT_RDONLY - 91f0c75f
[    0.000000] ... RAMDISK_FLAGS     - e1ff3018
[    0.000000] ... ORIG_ROOT_DEV     - 89093610
[    0.000000] ... LOADER_TYPE       - 3612e108
[    0.000000] ... INITRD_START      - 46088904
[    0.000000] ... INITRD_SIZE       - 6002306c
[    0.000000] console [sercon0] enabled
[    0.000000] Booting machvec: Sega Dreamcast
[    0.000000] Node 0: start_pfn = 0xc000, low = 0xd000
[    0.000000] Zone PFN ranges:
[    0.000000]   Normal   0x0000c000 -> 0x0000d000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0: 0x0000c000 -> 0x0000d000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4064
[    0.000000] Kernel command line: root=/dev/nfs rw nfsroot=192.168.61.50:/home/adrian/debdist ip=dhcp earlyprintk=serial video=pvr2fb:640x480-32@60 console=ttySC1 panic=7
[    0.000000] PID hash table entries: 64 (order: 6, 256 bytes)
[    0.000000] Using tmu for system timer
[    0.000000] Using 12.469 MHz high precision timer.
[    0.009652] Console: colour dummy device 80x25
[    0.014642] Dentry cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.022265] Inode-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.032168] Memory: 12420k/16384k available (2435k kernel code, 624k data, 128k init)
[    0.040770] PVR=040205c1 CVR=00000000 PRR=00000000
[    0.046029] I-cache : n_ways=1 n_sets=256 way_incr=8192
[    0.051757] I-cache : entry_mask=0x00001fe0 alias_mask=0x00001000 n_aliases=2
[    0.059597] D-cache : n_ways=1 n_sets=512 way_incr=16384
[    0.065425] D-cache : entry_mask=0x00003fe0 alias_mask=0x00003000 n_aliases=4
[    0.073871] SLUB: Genslabs=11, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.082537] Calibrating delay loop (skipped)... 199.50 BogoMIPS PRESET (lpj=399012)
[    0.092564] Mount-cache hash table entries: 512
[    0.102996] CPU: SH7750
[    0.132721] net_namespace: 296 bytes
[    0.138782] NET: Registered protocol family 16
[    0.202300] bio: create slab <bio-0> at 0
[    0.291151] DMA: Registering DMA API.
[    0.295405] DMA: Registering sh_dmac handler (6 channels).
[    0.312768] DMA: Registering pvr2_dmac handler (1 channel).
[    0.321913] DMA: Registering g2_dmac handler (4 channels).
[    0.334524] Autoconfig PCI channel 0x8c2f9f4c
[    0.339325] Scanning bus 00, I/O 0x01001600:0x01003600, Mem 0x01840000:0x01848000
[    0.347584] 00:00.0 Class 0200: 11db:1234 (rev 10)
[    0.352809]         I/O at 0x01001600 [size=0x100]
[    0.358115]         Mem at 0x01840000 [size=0x100]
[    0.365944] PCI: Fixing up device 0000:00:00.0
[    0.477670]  maple: bus core now registered
[    0.482879] NET: Registered protocol family 2
[    0.488406] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.497831] TCP established hash table entries: 512 (order: 0, 4096 bytes)
[    0.505484] TCP bind hash table entries: 512 (order: -1, 2048 bytes)
[    0.512554] TCP: Hash tables configured (established 512 bind 512)
[    0.519357] TCP reno registered
[    0.524545] NET: Registered protocol family 1
[    0.533799] sq: Registering store queue API.
[    0.542518] cpufreq: SuperH CPU frequency driver.
[    0.547896] cpufreq: clock framework rate rounding not supported on this CPU.
[    0.562855] maple <NULL>: detected Dreamcast Controller: function 0x1: at (0, 0)
[    0.571033] maple <NULL>: no driver found
[    0.578004] maple <NULL>: detected Dreamcast Controller: function 0x1: at (1, 0)
[    0.586180] maple <NULL>: no driver found
[    0.591878] maple <NULL>: detected Keyboard: function 0x40: at (2, 0)
[    0.599902] maple <NULL>: no driver found
[    0.605610] maple <NULL>: detected Dreamcast Mouse: function 0x200: at (3, 0)
[    0.613752] maple <NULL>: no driver found
[    0.677496] HugeTLB registered 64 KB page size, pre-allocated 0 pages
[    0.977337] msgmni has been set to 24
[    1.015517] alg: No test for stdrng (krng)
[    1.021550] io scheduler noop registered
[    1.025916] io scheduler anticipatory registered (default)
[    2.152070] Console: switching to colour frame buffer device 80x30
[    2.194210] fb0: NEC PowerVR2 (rev 1.1) frame buffer device, using 1200k/8192k of video memory
[    2.203764] fb0: Mode 640x480-32 pitch = 2560 cable: VGA video output: VGA
[    2.211346] fb0: registering with SQ API
[    2.216231] sqremap:    NEC PowerVR2  [2048 pages]  va 0xe0000000   pa 0xa5000000
[    2.224571] fb0: Mapped video memory to SQ addr 0xe0000000
[    3.415334] SuperH SCI(F) driver initialized
[    3.420688] sh-sci: ttySC0 at MMIO 0xffe00000 (irq = 23) is a sci
[    3.429885] sh-sci: ttySC1 at MMIO 0xffe80000 (irq = 40) is a scif
+dH�Ȑ3.436787] console handover: boot [sercon0] -> real [ttySC1]
[    3.479060] loop: module loaded
[    3.489688] nbd: registered device at major 43
[    3.575956] 8139too Fast Ethernet driver 0.9.28
[    3.585044] eth0: RealTek RTL8139 at 0xa1001700, 00:d0:f1:03:12:b9, IRQ 83
[    3.599034] mice: PS/2 mouse device common for all mice
[    3.607684] input: Keyboard as /devices/maple/2:00.40/input/input0
[    3.620492] input: Dreamcast Controller as /devices/maple/0:00.1/input/input1
[    3.635563] input: Dreamcast Controller as /devices/maple/1:00.1/input/input2
[    3.649500] TCP cubic registered
[    3.652982] NET: Registered protocol family 17
[    5.135630] RPC: Registered udp transport module.
[    5.140619] RPC: Registered tcp transport module.
[    5.661012] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[    6.668306] Sending DHCP requests ., OK
[    6.680837] IP-Config: Got DHCP answer from 192.168.61.50, my address is 192.168.61.55
[    6.694036] IP-Config: Complete:
[    6.697296]      device=eth0, addr=192.168.61.55, mask=255.255.255.224, gw=192.168.61.50,
[    6.705932]      host=192.168.61.55, domain=, nis-domain=(none),
[    6.712288]      bootserver=192.168.61.50, rootserver=192.168.61.50, rootpath=
[    6.721451] Looking up port of RPC 100003/2 on 192.168.61.50
[    6.734257] Looking up port of RPC 100005/1 on 192.168.61.50
[    6.763700] VFS: Mounted root (nfs filesystem) on device 0:13.
[    6.771427] Freeing unused kernel memory: 128k freed
INIT: �version 2.86 booting�
�Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...udevd-event[1789]: rename_netif: error changing netif name eth0 to eth1: Device or resource busy
done.
Waiting for /dev to be fully populated...done.
Setting the system clock..
Cannot access the Hardware Clock via any known method.
Use the --debug option to see the details of our search for an access method.
Loading kernel modules...done.
Loading device-mapper support.
Setting kernel variables...done.
Mounting local filesystems...done.
Activating swapfile swap...done.
Setting up networking....
Setting up ALSA...done (none loaded).
INIT: �Entering runlevel: 2�
�Starting system log daemon: syslogd.
Starting kernel log daemon: klogd.
Starting mouse interface server: gpm.
Starting NBD client process: FATAL: Module nbd not found.
Connecting...Activating...
nbd-client.
* Not starting internet superserver: no services enabled.
Starting OpenBSD Secure Shell server: sshd.
Starting NTP server: ntpd.
[   76.153090] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
Starting periodic command scheduler: crond.
Negotiation: ..size = 32768KB
bs=1024, sz=32768
Setting up swapspace version 1, size = 33550 kB
no label, UUID=f535b1a4-e5d9-45ca-9084-d292af234e95
[   77.804670] Adding 32760k swap on /dev/nbd0.  Priority:-1 extents:1 across:32760k SS
�
Debian GNU/Linux 4.0 dreamy ttySC1

dreamy login:

