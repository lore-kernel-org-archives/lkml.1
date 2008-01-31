Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbYAaPza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbYAaPza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbYAaPzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:55:17 -0500
Received: from imo-m25.mx.aol.com ([64.12.137.6]:48308 "EHLO
	imo-m25.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbYAaPzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:55:13 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2008 10:55:13 EST
Message-ID: <47A1EE15.6090507@aol.com>
Date: Thu, 31 Jan 2008 10:49:41 -0500
From: AndrewL733 <AndrewL733@aol.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.24 Page Allocation Failure
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AOL-IP: 146.115.19.135
X-Mailer: Unknown (No Version)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My setup is Mandriva 2007 64-bit:

IntelS5000PSLSATA motherboard
Single Dual Core 3 Ghz Xeon
2 GB ECC RAM
Myricom 10 GbE Network Adapter (using out of kernel 1.4.0 driver 
compiled with "MYRI10GE_ALLOC_ORDER=2")


I have two identical systems doing data transfer via Myricom cards 
connected directly to one another (in other words, not going through a 
switch).

No problems hammering Myricom with 350 MB/sec NFS traffic while running 
2.6.20.15 and 2.6.22.9 (kernel.org "plain vanilla" kernels I compiled 
and run, also with updated Myricom drivers). However, I just compiled 
and installed 2.6.24 and get the following errors as soon as I begin 
doing NFS I/O over the Myricom card. Maybe I missed something in the 
kernel configuration? Throughput when running 2.6.24 is about 40 percent 
lower than when running 2.6.22.9-- surely due to these errors.

Jan 29 22:13:36 master kernel: nfsd: page allocation failure. order:2, 
mode:0x4020
Jan 29 22:13:36 master kernel: Pid: 6586, comm: nfsd Not tainted 2.6.24 #1
Jan 29 22:13:36 master kernel:
Jan 29 22:13:36 master kernel: Call Trace:
Jan 29 22:13:36 master kernel:  <IRQ>  [__alloc_pages+822/912] 
__alloc_pages+0x336/0x390
Jan 29 22:13:36 master kernel:  <IRQ>  [<ffffffff80279d66>] 
__alloc_pages+0x336/0x390
Jan 29 22:13:36 master kernel:  [ip_local_deliver+37/112] 
ip_local_deliver+0x25/0x70
Jan 29 22:13:36 master kernel:  [<ffffffff80417bb5>] 
ip_local_deliver+0x25/0x70
Jan 29 22:13:36 master kernel:  [_end+130301422/2130457992] 
:myri10ge:myri10ge_alloc_rx_pages+0x156/0x270
Jan 29 22:13:36 master kernel:  [<ffffffff88280866>] 
:myri10ge:myri10ge_alloc_rx_pages+0x156/0x270
Jan 29 22:13:36 master kernel:  [_end+130325174/2130457992] 
:myri10ge:myri10ge_poll+0x57e/0xae0
Jan 29 22:13:36 master kernel:  [<ffffffff8828652e>] 
:myri10ge:myri10ge_poll+0x57e/0xae0
Jan 29 22:13:36 master kernel:  [_spin_lock_bh+9/32] _spin_lock_bh+0x9/0x20
Jan 29 22:13:36 master kernel:  [<ffffffff80466819>] _spin_lock_bh+0x9/0x20
Jan 29 22:13:36 master kernel:  [_end+129719928/2130457992] 
:sunrpc:svc_sock_enqueue+0x80/0x340
Jan 29 22:13:36 master kernel:  [<ffffffff881f28f0>] 
:sunrpc:svc_sock_enqueue+0x80/0x340
Jan 29 22:13:36 master kernel:  [net_rx_action+153/448] 
net_rx_action+0x99/0x1c0
Jan 29 22:13:36 master kernel:  [<ffffffff803f6729>] 
net_rx_action+0x99/0x1c0
Jan 29 22:13:36 master kernel:  [__do_softirq+105/224] 
__do_softirq+0x69/0xe0
Jan 29 22:13:36 master kernel:  [<ffffffff80241db9>] __do_softirq+0x69/0xe0
Jan 29 22:13:36 master kernel:  [call_softirq+28/48] call_softirq+0x1c/0x30
Jan 29 22:13:36 master kernel:  [<ffffffff8020cd9c>] call_softirq+0x1c/0x30
Jan 29 22:13:36 master kernel:  <EOI>  [do_softirq+53/144] 
do_softirq+0x35/0x90
Jan 29 22:13:36 master kernel:  <EOI>  [<ffffffff8020eef5>] 
do_softirq+0x35/0x90
Jan 29 22:13:36 master kernel:  [local_bh_enable+91/160] 
local_bh_enable+0x5b/0xa0
Jan 29 22:13:36 master kernel:  [<ffffffff80241c6b>] 
local_bh_enable+0x5b/0xa0
Jan 29 22:13:36 master kernel:  [_end+129726255/2130457992] 
:sunrpc:svc_udp_recvfrom+0x407/0x430
Jan 29 22:13:36 master kernel:  [<ffffffff881f41a7>] 
:sunrpc:svc_udp_recvfrom+0x407/0x430
Jan 29 22:13:36 master kernel:  [_end+129730321/2130457992] 
:sunrpc:svc_recv+0x2a9/0x4e0
Jan 29 22:13:36 master kernel:  [<ffffffff881f5189>] 
:sunrpc:svc_recv+0x2a9/0x4e0
Jan 29 22:13:36 master kernel:  [default_wake_function+0/16] 
default_wake_function+0x0/0x10
Jan 29 22:13:36 master kernel:  [<ffffffff80233460>] 
default_wake_function+0x0/0x10
Jan 29 22:13:36 master kernel:  [__down_read+18/177] __down_read+0x12/0xb1
Jan 29 22:13:36 master kernel:  [<ffffffff80466242>] __down_read+0x12/0xb1
Jan 29 22:13:36 master kernel:  [_end+130772360/2130457992] 
:nfsd:nfsd+0x0/0x2e0
an 29 22:13:36 master kernel:  [<ffffffff882f3800>] :nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:36 master kernel:  [_end+130772586/2130457992] 
:nfsd:nfsd+0xe2/0x2e0
Jan 29 22:13:36 master kernel:  [<ffffffff882f38e2>] :nfsd:nfsd+0xe2/0x2e0
Jan 29 22:13:36 master kernel:  [child_rip+10/18] child_rip+0xa/0x12
Jan 29 22:13:36 master kernel:  [<ffffffff8020ca28>] child_rip+0xa/0x12
Jan 29 22:13:36 master kernel:  [_end+130772360/2130457992] 
:nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:36 master kernel:  [<ffffffff882f3800>] :nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:36 master kernel:  [_end+130772360/2130457992] 
:nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:36 master kernel:  [<ffffffff882f3800>] :nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:36 master kernel:  [child_rip+0/18] child_rip+0x0/0x12
Jan 29 22:13:36 master kernel:  [<ffffffff8020ca1e>] child_rip+0x0/0x12
Jan 29 22:13:36 master kernel:
Jan 29 22:13:36 master kernel: Mem-info:
Jan 29 22:13:36 master kernel: DMA per-cpu:
Jan 29 22:13:36 master kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   
0   Cold: hi:    0, btch:   1 usd:   0
Jan 29 22:13:36 master kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   
0   Cold: hi:    0, btch:   1 usd:   0
Jan 29 22:13:36 master kernel: DMA32 per-cpu:
Jan 29 22:13:36 master kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 
150   Cold: hi:   62, btch:  15 usd:  62
Jan 29 22:13:36 master kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 
105   Cold: hi:   62, btch:  15 usd:  52
Jan 29 22:13:36 master kernel: Active:41027 inactive:437314 dirty:29708 
writeback:0 unstable:0
Jan 29 22:13:36 master kernel:  free:3892 slab:19405 mapped:11793 
pagetables:1512 bounce:0
Jan 29 22:13:36 master kernel: DMA free:8008kB min:28kB low:32kB 
high:40kB active:0kB inactive:2384kB present:11100kB pages_scanned:0 
all_unreclaimable? no
Jan 29 22:13:36 master kernel: lowmem_reserve[]: 0 1998 1998 1998
Jan 29 22:13:36 master kernel: DMA32 free:7560kB min:5704kB low:7128kB 
high:8556kB active:164108kB inactive:1746872kB present:2046800kB 
pages_scanned:32 all_unreclaimab
le? no
Jan 29 22:13:36 master kernel: lowmem_reserve[]: 0 0 0 0
Jan 29 22:13:36 master kernel: DMA: 4*4kB 5*8kB 6*16kB 6*32kB 4*64kB 
2*128kB 4*256kB 4*512kB 0*1024kB 0*2048kB 1*4096kB = 8024kB
Jan 29 22:13:36 master kernel: DMA32: 1365*4kB 11*8kB 38*16kB 18*32kB 
0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 7756kB
Jan 29 22:13:36 master kernel: Swap cache: add 43, delete 43, find 0/0, 
race 0+0
Jan 29 22:13:36 master kernel: Free swap  = 4088332kB
Jan 29 22:13:36 master kernel: Total swap = 4088500kB
Jan 29 22:13:36 master kernel: Free swap:       4088332kB
Jan 29 22:13:36 master kernel: 523264 pages of RAM
Jan 29 22:13:36 master kernel: 9510 reserved pages
Jan 29 22:13:36 master kernel: 492885 pages shared
Jan 29 22:13:36 master kernel: 0 pages swap cached
Jan 29 22:13:44 master nmbd[3438]: [2008/01/29 22:13:44, 0] 
nmbd/nmbd_packets.c:process_browse_packet(1061)
Jan 29 22:13:44 master nmbd[3438]:   process_browse_packet: Discarding 
datagram from IP 192.168.1.240. Source name master<00> is one of our names !
Jan 29 22:13:44 master nmbd[3438]: [2008/01/29 22:13:44, 0] 
nmbd/nmbd_packets.c:process_browse_packet(1061)
Jan 29 22:13:44 master nmbd[3438]:   process_browse_packet: Discarding 
datagram from IP 192.168.1.237. Source name master<00> is one of our names !
Jan 29 22:13:44 master kernel: nfsd: page allocation failure. order:2, 
mode:0x4020
Jan 29 22:13:44 master kernel: Pid: 6591, comm: nfsd Not tainted 2.6.24 #1
Jan 29 22:13:44 master kernel:
Jan 29 22:13:44 master kernel: Call Trace:
Jan 29 22:13:44 master kernel:  <IRQ>  [__alloc_pages+822/912] 
__alloc_pages+0x336/0x390
Jan 29 22:13:44 master kernel:  <IRQ>  [<ffffffff80279d66>] 
__alloc_pages+0x336/0x390
Jan 29 22:13:44 master kernel:  [_end+130301422/2130457992] 
:myri10ge:myri10ge_alloc_rx_pages+0x156/0x270
Jan 29 22:13:44 master kernel:  [<ffffffff88280866>] 
:myri10ge:myri10ge_alloc_rx_pages+0x156/0x270
Jan 29 22:13:44 master kernel:  [_end+130325174/2130457992] 
:myri10ge:myri10ge_poll+0x57e/0xae0
Jan 29 22:13:44 master kernel:  [<ffffffff8828652e>] 
:myri10ge:myri10ge_poll+0x57e/0xae0
Jan 29 22:13:44 master kernel:  [_spin_lock_bh+9/32] _spin_lock_bh+0x9/0x20
Jan 29 22:13:44 master kernel:  [<ffffffff80466819>] _spin_lock_bh+0x9/0x20
Jan 29 22:13:44 master kernel:  [_end+129719928/2130457992] 
:sunrpc:svc_sock_enqueue+0x80/0x340
Jan 29 22:13:44 master kernel:  [<ffffffff881f28f0>] 
:sunrpc:svc_sock_enqueue+0x80/0x340
Jan 29 22:13:44 master kernel:  [net_rx_action+153/448] 
net_rx_action+0x99/0x1c0
Jan 29 22:13:44 master kernel:  [<ffffffff803f6729>] 
net_rx_action+0x99/0x1c0
Jan 29 22:13:44 master kernel:  [__do_softirq+105/224] 
__do_softirq+0x69/0xe0
Jan 29 22:13:44 master kernel:  [<ffffffff80241db9>] __do_softirq+0x69/0xe0
Jan 29 22:13:44 master kernel:  [call_softirq+28/48] call_softirq+0x1c/0x30
Jan 29 22:13:44 master kernel:  [<ffffffff8020cd9c>] call_softirq+0x1c/0x30
Jan 29 22:13:44 master kernel:  [do_softirq+53/144] do_softirq+0x35/0x90
Jan 29 22:13:44 master kernel:  [<ffffffff8020eef5>] do_softirq+0x35/0x90
Jan 29 22:13:44 master kernel:  [do_IRQ+128/256] do_IRQ+0x80/0x100
Jan 29 22:13:44 master kernel:  [<ffffffff8020f170>] do_IRQ+0x80/0x100
Jan 29 22:13:44 master kernel:  [ret_from_intr+0/10] ret_from_intr+0x0/0xa
Jan 29 22:13:44 master kernel:  [<ffffffff8020c121>] ret_from_intr+0x0/0xa
Jan 29 22:13:44 master kernel:  <EOI>  [__copy_user_nocache+35/336] 
__copy_user_nocache+0x23/0x150
Jan 29 22:13:44 master kernel:  <EOI>  [<ffffffff803233b3>] 
__copy_user_nocache+0x23/0x150
Jan 29 22:13:44 master kernel:  [__iovec_copy_from_user_inatomic+67/128] 
__iovec_copy_from_user_inatomic+0x43/0x80
Jan 29 22:13:44 master kernel:  [<ffffffff80273ba3>] 
__iovec_copy_from_user_inatomic+0x43/0x80
Jan 29 22:13:44 master kernel:  [iov_iter_copy_from_user_atomic+163/176] 
iov_iter_copy_from_user_atomic+0xa3/0xb0
Jan 29 22:13:44 master kernel:  [<ffffffff80273d03>] 
iov_iter_copy_from_user_atomic+0xa3/0xb0
Jan 29 22:13:44 master kernel:  [generic_file_buffered_write+383/1728] 
generic_file_buffered_write+0x17f/0x6c0
Jan 29 22:13:44 master kernel:  [<ffffffff802756ff>] 
generic_file_buffered_write+0x17f/0x6c0
Jan 29 22:13:44 master kernel:  [__alloc_skb+133/336] __alloc_skb+0x85/0x150
Jan 29 22:13:44 master kernel:  [<ffffffff803eea15>] __alloc_skb+0x85/0x150
Jan 29 22:13:44 master kernel:  [_end+129525959/2130457992] 
:xfs:xfs_write+0x67f/0x8f0
Jan 29 22:13:44 master kernel:  [<ffffffff881c333f>] 
:xfs:xfs_write+0x67f/0x8f0
Jan 29 22:13:44 master kernel:  [_end+129343578/2130457992] 
:xfs:xfs_iget+0x142/0x160
Jan 29 22:13:44 master kernel:  [<ffffffff88196ad2>] 
:xfs:xfs_iget+0x142/0x160
Jan 29 22:13:44 master kernel:  [_end+129509416/2130457992] 
:xfs:xfs_file_aio_write+0x0/0x50
Jan 29 22:13:44 master kernel:  [<ffffffff881bf2a0>] 
:xfs:xfs_file_aio_write+0x0/0x50
Jan 29 22:13:44 master kernel:  [do_sync_readv_writev+203/272] 
do_sync_readv_writev+0xcb/0x110
Jan 29 22:13:44 master kernel:  [<ffffffff8029a46b>] 
do_sync_readv_writev+0xcb/0x110
Jan 29 22:13:44 master kernel:  [autoremove_wake_function+0/48] 
autoremove_wake_function+0x0/0x30
Jan 29 22:13:44 master kernel:  [<ffffffff80251e10>] 
autoremove_wake_function+0x0/0x30
Jan 29 22:13:44 master kernel:  [_end+130243723/2130457992] 
:exportfs:exportfs_decode_fh+0x93/0x278
Jan 29 22:13:44 master kernel:  [<ffffffff88272703>] 
:exportfs:exportfs_decode_fh+0x93/0x278
Jan 29 22:13:44 master kernel:  [<ffffffff88272703>] 
:exportfs:exportfs_decode_fh+0x93/0x278
Jan 29 22:13:44 master kernel:  [_end+130783832/2130457992] 
:nfsd:nfsd_acceptable+0x0/0x100
Jan 29 22:13:44 master kernel:  [<ffffffff882f64d0>] 
:nfsd:nfsd_acceptable+0x0/0x100
Jan 29 22:13:44 master kernel:  [_end+129748673/2130457992] 
:sunrpc:cache_check+0x49/0x490
Jan 29 22:13:44 master kernel:  [<ffffffff881f9939>] 
:sunrpc:cache_check+0x49/0x490
Jan 29 22:13:44 master kernel:  [rw_copy_check_uvector+157/304] 
rw_copy_check_uvector+0x9d/0x130
Jan 29 22:13:44 master kernel:  [<ffffffff8029a2cd>] 
rw_copy_check_uvector+0x9d/0x130
Jan 29 22:13:44 master kernel:  [do_readv_writev+226/528] 
do_readv_writev+0xe2/0x210
Jan 29 22:13:44 master kernel:  [<ffffffff8029abb2>] 
do_readv_writev+0xe2/0x210
Jan 29 22:13:44 master kernel:  [_end+130813642/2130457992] 
:nfsd:nfsd_setuser+0x82/0x210
Jan 29 22:13:44 master kernel:  [<ffffffff882fd942>] 
:nfsd:nfsd_setuser+0x82/0x210
Jan 29 22:13:44 master kernel:  [_end+130782532/2130457992] 
:nfsd:nfsd_setuser_and_check_port+0x5c/0x70
Jan 29 22:13:44 master kernel:  [<ffffffff882f5fbc>] 
:nfsd:nfsd_setuser_and_check_port+0x5c/0x70
Jan 29 22:13:44 master kernel:  [_end+130788665/2130457992] 
:nfsd:nfsd_vfs_write+0xf1/0x3a0
Jan 29 22:13:44 master kernel:  [<ffffffff882f77b1>] 
:nfsd:nfsd_vfs_write+0xf1/0x3a0
Jan 29 22:13:44 master kernel:  [__dentry_open+408/528] 
__dentry_open+0x198/0x210
Jan 29 22:13:44 master kernel:  [<ffffffff80298ab8>] 
__dentry_open+0x198/0x210
Jan 29 22:13:44 master kernel:  [_end+130790708/2130457992] 
:nfsd:nfsd_open+0x12c/0x1e0
Jan 29 22:13:44 master kernel:  [<ffffffff882f7fac>] 
:nfsd:nfsd_open+0x12c/0x1e0
Jan 29 22:13:44 master kernel:  [_end+130791566/2130457992] 
:nfsd:nfsd_write+0x106/0x110
Jan 29 22:13:44 master kernel:  [<ffffffff882f8306>] 
:nfsd:nfsd_write+0x106/0x110
Jan 29 22:13:44 master kernel:  [_end+130825459/2130457992] 
:nfsd:nfsd3_proc_write+0x10b/0x160
Jan 29 22:13:44 master kernel:  [<ffffffff8830076b>] 
:nfsd:nfsd3_proc_write+0x10b/0x160
Jan 29 22:13:44 master kernel:  [_end+130770937/2130457992] 
:nfsd:nfsd_dispatch+0xb1/0x220
Jan 29 22:13:44 master kernel:  [<ffffffff882f3271>] 
:nfsd:nfsd_dispatch+0xb1/0x220
Jan 29 22:13:44 master kernel:  [_end+129716706/2130457992] 
:sunrpc:svc_process+0x47a/0x780
Jan 29 22:13:44 master kernel:  [<ffffffff881f1c5a>] 
:sunrpc:svc_process+0x47a/0x780
Jan 29 22:13:44 master kernel:  [__down_read+18/177] __down_read+0x12/0xb1
Jan 29 22:13:44 master kernel:  [<ffffffff80466242>] __down_read+0x12/0xb1
Jan 29 22:13:44 master kernel:  [_end+130772360/2130457992] 
:nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:44 master kernel:  [<ffffffff882f3800>] :nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:44 master kernel:  [_end+130772771/2130457992] 
:nfsd:nfsd+0x19b/0x2e0
Jan 29 22:13:44 master kernel:  [<ffffffff882f399b>] :nfsd:nfsd+0x19b/0x2e0
Jan 29 22:13:44 master kernel:  [child_rip+10/18] child_rip+0xa/0x12
Jan 29 22:13:44 master kernel:  [<ffffffff8020ca28>] child_rip+0xa/0x12
Jan 29 22:13:44 master kernel:  [_end+130772360/2130457992] 
:nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:44 master kernel:  [<ffffffff882f3800>] :nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:44 master kernel:  [_end+130772360/2130457992] 
:nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:44 master kernel:  [<ffffffff882f3800>] :nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:44 master kernel:  [child_rip+0/18] child_rip+0x0/0x12
Jan 29 22:13:44 master kernel:  [<ffffffff8020ca1e>] child_rip+0x0/0x12
Jan 29 22:13:44 master kernel:
Jan 29 22:13:44 master kernel: Mem-info:
Jan 29 22:13:44 master kernel: DMA per-cpu:
Jan 29 22:13:44 master kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   
0   Cold: hi:    0, btch:   1 usd:   0
Jan 29 22:13:44 master kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   
0   Cold: hi:    0, btch:   1 usd:   0
Jan 29 22:13:44 master kernel: DMA32 per-cpu:
Jan 29 22:13:44 master kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  
55   Cold: hi:   62, btch:  15 usd:  60
Jan 29 22:13:44 master kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 
183   Cold: hi:   62, btch:  15 usd:  48
Jan 29 22:13:44 master kernel: Active:40766 inactive:437591 dirty:29984 
writeback:1045 unstable:0
Jan 29 22:13:44 master kernel:  free:4000 slab:18952 mapped:11793 
pagetables:1512 bounce:0
Jan 29 22:13:44 master kernel: DMA free:8008kB min:28kB low:32kB 
high:40kB active:0kB inactive:1676kB present:11100kB pages_scanned:0 
all_unreclaimable? no
Jan 29 22:13:44 master kernel: lowmem_reserve[]: 0 1998 1998 1998
Jan 29 22:13:44 master kernel: DMA32 free:8076kB min:5704kB low:7128kB 
high:8556kB active:163064kB inactive:1748688kB present:2046800kB 
pages_scanned:0 all_unreclaimabl
e? no
Jan 29 22:13:44 master kernel: lowmem_reserve[]: 0 0 0 0
Jan 29 22:13:44 master kernel: DMA: 6*4kB 6*8kB 13*16kB 6*32kB 4*64kB 
1*128kB 12*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8024kB
Jan 29 22:13:44 master kernel: DMA32: 1160*4kB 117*8kB 82*16kB 19*32kB 
2*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 8136kB
Jan 29 22:13:44 master kernel: Swap cache: add 45, delete 44, find 0/0, 
race 0+0
Jan 29 22:13:44 master kernel: Free swap  = 4088324kB
Jan 29 22:13:44 master kernel: Total swap = 4088500kB
Jan 29 22:13:44 master kernel: Free swap:       4088324kB
Jan 29 22:13:44 master kernel: 523264 pages of RAM
Jan 29 22:13:44 master kernel: 9510 reserved pages
Jan 29 22:13:44 master kernel: 494203 pages shared
Jan 29 22:13:44 master kernel: 1 pages swap cached
Jan 29 22:13:45 master kernel: nfsd: page allocation failure. order:2, 
mode:0x4020
Jan 29 22:13:45 master kernel: Pid: 6595, comm: nfsd Not tainted 2.6.24 #1
Jan 29 22:13:45 master kernel:
Jan 29 22:13:45 master kernel: Call Trace:
Jan 29 22:13:45 master kernel:  <IRQ>  [__alloc_pages+822/912] 
__alloc_pages+0x336/0x390
Jan 29 22:13:45 master kernel:  <IRQ>  [<ffffffff80279d66>] 
__alloc_pages+0x336/0x390
Jan 29 22:13:45 master kernel:  [ip_local_deliver_finish+129/512] 
ip_local_deliver_finish+0x81/0x200
Jan 29 22:13:45 master kernel:  [<ffffffff80417611>] 
ip_local_deliver_finish+0x81/0x200
Jan 29 22:13:45 master kernel:  [_end+130301422/2130457992] 
:myri10ge:myri10ge_alloc_rx_pages+0x156/0x270
Jan 29 22:13:45 master kernel:  [<ffffffff88280866>] 
:myri10ge:myri10ge_alloc_rx_pages+0x156/0x270
Jan 29 22:13:45 master kernel:  [_end+130325174/2130457992] 
:myri10ge:myri10ge_poll+0x57e/0xae0
Jan 29 22:13:45 master kernel:  [<ffffffff8828652e>] 
:myri10ge:myri10ge_poll+0x57e/0xae0
Jan 29 22:13:45 master kernel:  [_spin_lock_bh+9/32] _spin_lock_bh+0x9/0x20
Jan 29 22:13:45 master kernel:  [<ffffffff80466819>] _spin_lock_bh+0x9/0x20
Jan 29 22:13:45 master kernel:  [_end+129719928/2130457992] 
:sunrpc:svc_sock_enqueue+0x80/0x340
Jan 29 22:13:45 master kernel:  [<ffffffff881f28f0>] 
:sunrpc:svc_sock_enqueue+0x80/0x340
Jan 29 22:13:45 master kernel:  [net_rx_action+153/448] 
net_rx_action+0x99/0x1c0
Jan 29 22:13:45 master kernel:  [<ffffffff803f6729>] 
net_rx_action+0x99/0x1c0
Jan 29 22:13:45 master kernel:  [__do_softirq+105/224] 
__do_softirq+0x69/0xe0
Jan 29 22:13:45 master kernel:  [<ffffffff80241db9>] __do_softirq+0x69/0xe0
Jan 29 22:13:45 master kernel:  [call_softirq+28/48] call_softirq+0x1c/0x30
Jan 29 22:13:45 master kernel:  [<ffffffff8020cd9c>] call_softirq+0x1c/0x30
Jan 29 22:13:45 master kernel:  [do_softirq+53/144] do_softirq+0x35/0x90
Jan 29 22:13:45 master kernel:  [<ffffffff8020eef5>] do_softirq+0x35/0x90
Jan 29 22:13:45 master kernel:  [do_IRQ+128/256] do_IRQ+0x80/0x100
Jan 29 22:13:45 master kernel:  [<ffffffff8020f170>] do_IRQ+0x80/0x100
Jan 29 22:13:45 master kernel:  [ret_from_intr+0/10] ret_from_intr+0x0/0xa
Jan 29 22:13:45 master kernel:  [<ffffffff8020c121>] ret_from_intr+0x0/0xa
Jan 29 22:13:45 master kernel:  <EOI>  [block_write_begin+21/224] 
block_write_begin+0x15/0xe0
Jan 29 22:13:45 master kernel:  <EOI>  [<ffffffff802c03b5>] 
block_write_begin+0x15/0xe0
Jan 29 22:13:45 master kernel:  [_end+129490730/2130457992] 
:xfs:xfs_vm_write_begin+0x22/0x30
Jan 29 22:13:45 master kernel:  [<ffffffff881ba9a2>] 
:xfs:xfs_vm_write_begin+0x22/0x30
Jan 29 22:13:45 master kernel:  [_end+129492696/2130457992] 
:xfs:xfs_get_blocks+0x0/0x10
Jan 29 22:13:45 master kernel:  [<ffffffff881bb150>] 
:xfs:xfs_get_blocks+0x0/0x10
Jan 29 22:13:45 master kernel:  [generic_file_buffered_write+328/1728] 
generic_file_buffered_write+0x148/0x6c0
Jan 29 22:13:45 master kernel:  [<ffffffff802756c8>] 
generic_file_buffered_write+0x148/0x6c0
Jan 29 22:13:45 master kernel:  [__alloc_skb+133/336] __alloc_skb+0x85/0x150
Jan 29 22:13:45 master kernel:  [<ffffffff803eea15>] __alloc_skb+0x85/0x150
Jan 29 22:13:45 master kernel:  [_end+129525959/2130457992] 
:xfs:xfs_write+0x67f/0x8f0
Jan 29 22:13:45 master kernel:  [<ffffffff881c333f>] 
:xfs:xfs_write+0x67f/0x8f0
Jan 29 22:13:45 master kernel:  [_end+129343578/2130457992] 
:xfs:xfs_iget+0x142/0x160
Jan 29 22:13:45 master kernel:  [<ffffffff88196ad2>] 
:xfs:xfs_iget+0x142/0x160
Jan 29 22:13:45 master kernel:  [_end+129509416/2130457992] 
:xfs:xfs_file_aio_write+0x0/0x50
Jan 29 22:13:45 master kernel:  [<ffffffff881bf2a0>] 
:xfs:xfs_file_aio_write+0x0/0x50
Jan 29 22:13:45 master kernel:  [do_sync_readv_writev+203/272] 
do_sync_readv_writev+0xcb/0x110
Jan 29 22:13:45 master kernel:  [<ffffffff8029a46b>] 
do_sync_readv_writev+0xcb/0x110
Jan 29 22:13:45 master kernel:  [autoremove_wake_function+0/48] 
autoremove_wake_function+0x0/0x30
Jan 29 22:13:45 master kernel:  [<ffffffff80251e10>] 
autoremove_wake_function+0x0/0x30
Jan 29 22:13:45 master kernel:  [_end+130243723/2130457992] 
:exportfs:exportfs_decode_fh+0x93/0x278
Jan 29 22:13:45 master kernel:  [<ffffffff88272703>] 
:exportfs:exportfs_decode_fh+0x93/0x278
Jan 29 22:13:45 master kernel:  [_end+130783832/2130457992] 
:nfsd:nfsd_acceptable+0x0/0x100
Jan 29 22:13:45 master kernel:  [<ffffffff882f64d0>] 
:nfsd:nfsd_acceptable+0x0/0x100
Jan 29 22:13:45 master kernel:  [_end+129748673/2130457992] 
:sunrpc:cache_check+0x49/0x490
Jan 29 22:13:45 master kernel:  [<ffffffff881f9939>] 
:sunrpc:cache_check+0x49/0x490
Jan 29 22:13:45 master kernel:  [rw_copy_check_uvector+157/304] 
rw_copy_check_uvector+0x9d/0x130
Jan 29 22:13:45 master kernel:  [<ffffffff8029a2cd>] 
rw_copy_check_uvector+0x9d/0x130
Jan 29 22:13:45 master kernel:  [do_readv_writev+226/528] 
do_readv_writev+0xe2/0x210
Jan 29 22:13:45 master kernel:  [<ffffffff8029abb2>] 
do_readv_writev+0xe2/0x210
Jan 29 22:13:45 master kernel:  [_end+130813642/2130457992] 
:nfsd:nfsd_setuser+0x82/0x210
Jan 29 22:13:45 master kernel:  [<ffffffff882fd942>] 
:nfsd:nfsd_setuser+0x82/0x210
Jan 29 22:13:45 master kernel:  [_end+130782532/2130457992] 
:nfsd:nfsd_setuser_and_check_port+0x5c/0x70
Jan 29 22:13:45 master kernel:  [<ffffffff882f5fbc>] 
:nfsd:nfsd_setuser_and_check_port+0x5c/0x70
Jan 29 22:13:45 master kernel:  [_end+130788665/2130457992] 
:nfsd:nfsd_vfs_write+0xf1/0x3a0
Jan 29 22:13:45 master kernel:  [<ffffffff882f77b1>] 
:nfsd:nfsd_vfs_write+0xf1/0x3a0
Jan 29 22:13:45 master kernel:  [__dentry_open+408/528] 
__dentry_open+0x198/0x210
Jan 29 22:13:45 master kernel:  [<ffffffff80298ab8>] 
__dentry_open+0x198/0x210
Jan 29 22:13:45 master kernel:  [_end+130790708/2130457992] 
:nfsd:nfsd_open+0x12c/0x1e0
Jan 29 22:13:45 master kernel:  [<ffffffff882f7fac>] 
:nfsd:nfsd_open+0x12c/0x1e0
Jan 29 22:13:45 master kernel:  [_end+130791566/2130457992] 
:nfsd:nfsd_write+0x106/0x110
Jan 29 22:13:45 master kernel:  [<ffffffff882f8306>] 
:nfsd:nfsd_write+0x106/0x110
Jan 29 22:13:45 master kernel:  [_end+130825459/2130457992] 
:nfsd:nfsd3_proc_write+0x10b/0x160
Jan 29 22:13:45 master kernel:  [<ffffffff8830076b>] 
:nfsd:nfsd3_proc_write+0x10b/0x160
Jan 29 22:13:45 master kernel:  [_end+130770937/2130457992] 
:nfsd:nfsd_dispatch+0xb1/0x220
Jan 29 22:13:45 master kernel:  [<ffffffff882f3271>] 
:nfsd:nfsd_dispatch+0xb1/0x220
Jan 29 22:13:45 master kernel:  [_end+129716706/2130457992] 
:sunrpc:svc_process+0x47a/0x780
Jan 29 22:13:45 master kernel:  [<ffffffff881f1c5a>] 
:sunrpc:svc_process+0x47a/0x780
Jan 29 22:13:45 master kernel:  [__down_read+18/177] __down_read+0x12/0xb1
Jan 29 22:13:45 master kernel:  [<ffffffff80466242>] __down_read+0x12/0xb1
Jan 29 22:13:45 master kernel:  [_end+130772360/2130457992] 
:nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:45 master kernel:  [<ffffffff882f3800>] :nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:45 master kernel:  [_end+130772771/2130457992] 
:nfsd:nfsd+0x19b/0x2e0
Jan 29 22:13:45 master kernel:  [<ffffffff882f399b>] :nfsd:nfsd+0x19b/0x2e0
Jan 29 22:13:45 master kernel:  [child_rip+10/18] child_rip+0xa/0x12
Jan 29 22:13:45 master kernel:  [<ffffffff8020ca28>] child_rip+0xa/0x12
Jan 29 22:13:45 master kernel:  [_end+130772360/2130457992] 
:nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:45 master kernel:  [<ffffffff882f3800>] :nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:45 master kernel:  [_end+130772360/2130457992] 
:nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:45 master kernel:  [<ffffffff882f3800>] :nfsd:nfsd+0x0/0x2e0
Jan 29 22:13:45 master kernel:  [child_rip+0/18] child_rip+0x0/0x12
Jan 29 22:13:45 master kernel:  [<ffffffff8020ca1e>] child_rip+0x0/0x12
Jan 29 22:13:45 master kernel:
Jan 29 22:13:45 master kernel: Mem-info:
Jan 29 22:13:45 master kernel: DMA per-cpu:
Jan 29 22:13:45 master kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   
0   Cold: hi:    0, btch:   1 usd:   0
Jan 29 22:13:45 master kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   
0   Cold: hi:    0, btch:   1 usd:   0
Jan 29 22:13:45 master kernel: DMA32 per-cpu:
Jan 29 22:13:45 master kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 
156   Cold: hi:   62, btch:  15 usd:  48
Jan 29 22:13:45 master kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  
73   Cold: hi:   62, btch:  15 usd:  56
Jan 29 22:13:45 master kernel: Active:40772 inactive:437908 dirty:24942 
writeback:1051 unstable:0
Jan 29 22:13:45 master kernel:  free:3819 slab:18993 mapped:11793 
pagetables:1512 bounce:0
Jan 29 22:13:45 master kernel: DMA free:8008kB min:28kB low:32kB 
high:40kB active:0kB inactive:400kB present:11100kB pages_scanned:0 
all_unreclaimable? no
Jan 29 22:13:45 master kernel: lowmem_reserve[]: 0 1998 1998 1998
Jan 29 22:13:45 master kernel: DMA32 free:7268kB min:5704kB low:7128kB 
high:8556kB active:163088kB inactive:1751232kB present:2046800kB 
pages_scanned:0 all_unreclaimabl
e? no
Jan 29 22:13:45 master kernel: lowmem_reserve[]: 0 0 0 0
Jan 29 22:13:45 master kernel: DMA: 10*4kB 8*8kB 17*16kB 13*32kB 7*64kB 
5*128kB 8*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8024kB
Jan 29 22:13:45 master kernel: DMA32: 1555*4kB 0*8kB 1*16kB 1*32kB 
1*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 7228kB
Jan 29 22:13:45 master kernel: Swap cache: add 45, delete 44, find 0/0, 
race 0+0
Jan 29 22:13:45 master kernel: Free swap  = 4088324kB
Jan 29 22:13:45 master kernel: Total swap = 4088500kB
Jan 29 22:13:45 master kernel: Free swap:       4088324kB
Jan 29 22:13:45 master kernel: 523264 pages of RAM




