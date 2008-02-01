Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbYBAOT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbYBAOT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 09:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYBAOTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 09:19:19 -0500
Received: from imo-d05.mx.aol.com ([205.188.157.37]:53333 "EHLO
	imo-d05.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbYBAOTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 09:19:17 -0500
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2008 09:19:17 EST
Message-ID: <47A3291D.8060107@aol.com>
Date: Fri, 01 Feb 2008 09:13:49 -0500
From: AndrewL733 <AndrewL733@aol.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Myricom Technical Support <help@myri.com>
Subject: Re: 2.6.24 Page Allocation Failure
References: <47A1EE15.6090507@aol.com>
In-Reply-To: <47A1EE15.6090507@aol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AOL-IP: 146.115.19.135
X-Mailer: Unknown (No Version)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cause of this problem seems to be compiling the Myricom driver with 
the ALLOC_ORDER=2 option. When I use the in-kernel driver, (1.3.2) or 
recompile the Myricom 1.4.0 driver WITHOUT the option, the problem seems 
to go away even after heavy hammering of the system.

The ALLOC_ORDER=2 compiling option doesn't seem to cause any problem for 
the Myricom 1.4.0 driver in the 2.6.22 kernel but it does cause the 
problem when I run it in 2.6.24. 

Maybe with 2.6.24 more RAM is required to use this option? I will 
contact Myricom to inform them.

Andrew

AndrewL733 wrote:
> My setup is Mandriva 2007 64-bit:
>
> IntelS5000PSLSATA motherboard
> Single Dual Core 3 Ghz Xeon
> 2 GB ECC RAM
> Myricom 10 GbE Network Adapter (using out of kernel 1.4.0 driver 
> compiled with "MYRI10GE_ALLOC_ORDER=2")
>
>
> I have two identical systems doing data transfer via Myricom cards 
> connected directly to one another (in other words, not going through a 
> switch).
>
> No problems hammering Myricom with 350 MB/sec NFS traffic while 
> running 2.6.20.15 and 2.6.22.9 (kernel.org "plain vanilla" kernels I 
> compiled and run, also with updated Myricom drivers). However, I just 
> compiled and installed 2.6.24 and get the following errors as soon as 
> I begin doing NFS I/O over the Myricom card. Maybe I missed something 
> in the kernel configuration? Throughput when running 2.6.24 is about 
> 40 percent lower than when running 2.6.22.9-- surely due to these errors.
>
> Jan 29 22:13:36 master kernel: nfsd: page allocation failure. order:2, 
> mode:0x4020
> Jan 29 22:13:36 master kernel: Pid: 6586, comm: nfsd Not tainted 
> 2.6.24 #1
> Jan 29 22:13:36 master kernel:
> Jan 29 22:13:36 master kernel: Call Trace:
> Jan 29 22:13:36 master kernel:  <IRQ>  [__alloc_pages+822/912] 
> __alloc_pages+0x336/0x390
> Jan 29 22:13:36 master kernel:  <IRQ>  [<ffffffff80279d66>] 
> __alloc_pages+0x336/0x390
> Jan 29 22:13:36 master kernel:  [ip_local_deliver+37/112] 
> ip_local_deliver+0x25/0x70
> Jan 29 22:13:36 master kernel:  [<ffffffff80417bb5>] 
> ip_local_deliver+0x25/0x70
> Jan 29 22:13:36 master kernel:  [_end+130301422/2130457992] 
> :myri10ge:myri10ge_alloc_rx_pages+0x156/0x270
> Jan 29 22:13:36 master kernel:  [<ffffffff88280866>] 
> :myri10ge:myri10ge_alloc_rx_pages+0x156/0x270
> Jan 29 22:13:36 master kernel:  [_end+130325174/2130457992] 
> :myri10ge:myri10ge_poll+0x57e/0xae0
> Jan 29 22:13:36 master kernel:  [<ffffffff8828652e>] 
> :myri10ge:myri10ge_poll+0x57e/0xae0
> Jan 29 22:13:36 master kernel:  [_spin_lock_bh+9/32] 
> _spin_lock_bh+0x9/0x20
> Jan 29 22:13:36 master kernel:  [<ffffffff80466819>] 
> _spin_lock_bh+0x9/0x20
> Jan 29 22:13:36 master kernel:  [_end+129719928/2130457992] 
> :sunrpc:svc_sock_enqueue+0x80/0x340
> Jan 29 22:13:36 master kernel:  [<ffffffff881f28f0>] 
> :sunrpc:svc_sock_enqueue+0x80/0x340
> Jan 29 22:13:36 master kernel:  [net_rx_action+153/448] 
> net_rx_action+0x99/0x1c0
> Jan 29 22:13:36 master kernel:  [<ffffffff803f6729>] 
> net_rx_action+0x99/0x1c0
> Jan 29 22:13:36 master kernel:  [__do_softirq+105/224] 
> __do_softirq+0x69/0xe0
> Jan 29 22:13:36 master kernel:  [<ffffffff80241db9>] 
> __do_softirq+0x69/0xe0
> Jan 29 22:13:36 master kernel:  [call_softirq+28/48] 
> call_softirq+0x1c/0x30
> Jan 29 22:13:36 master kernel:  [<ffffffff8020cd9c>] 
> call_softirq+0x1c/0x30
> Jan 29 22:13:36 master kernel:  <EOI>  [do_softirq+53/144] 
> do_softirq+0x35/0x90
> Jan 29 22:13:36 master kernel:  <EOI>  [<ffffffff8020eef5>] 
> do_softirq+0x35/0x90
> Jan 29 22:13:36 master kernel:  [local_bh_enable+91/160] 
> local_bh_enable+0x5b/0xa0
> Jan 29 22:13:36 master kernel:  [<ffffffff80241c6b>] 
> local_bh_enable+0x5b/0xa0
> Jan 29 22:13:36 master kernel:  [_end+129726255/2130457992] 
> :sunrpc:svc_udp_recvfrom+0x407/0x430
> Jan 29 22:13:36 master kernel:  [<ffffffff881f41a7>] 
> :sunrpc:svc_udp_recvfrom+0x407/0x430
> Jan 29 22:13:36 master kernel:  [_end+129730321/2130457992] 
> :sunrpc:svc_recv+0x2a9/0x4e0
> Jan 29 22:13:36 master kernel:  [<ffffffff881f5189>] 
> :sunrpc:svc_recv+0x2a9/0x4e0
> Jan 29 22:13:36 master kernel:  [default_wake_function+0/16] 
> default_wake_function+0x0/0x10
> Jan 29 22:13:36 master kernel:  [<ffffffff80233460>] 
> default_wake_function+0x0/0x10
> Jan 29 22:13:36 master kernel:  [__down_read+18/177] 
> __down_read+0x12/0xb1
> Jan 29 22:13:36 master kernel:  [<ffffffff80466242>] 
> __down_read+0x12/0xb1
> Jan 29 22:13:36 master kernel:  [_end+130772360/2130457992] 
> :nfsd:nfsd+0x0/0x2e0
> an 29 22:13:36 master kernel:  [<ffffffff882f3800>] :nfsd:nfsd+0x0/0x2e0
> Jan 29 22:13:36 master kernel:  [_end+130772586/2130457992] 
> :nfsd:nfsd+0xe2/0x2e0
> Jan 29 22:13:36 master kernel:  [<ffffffff882f38e2>] 
> :nfsd:nfsd+0xe2/0x2e0
> Jan 29 22:13:36 master kernel:  [child_rip+10/18] child_rip+0xa/0x12
> Jan 29 22:13:36 master kernel:  [<ffffffff8020ca28>] child_rip+0xa/0x12
> Jan 29 22:13:36 master kernel:  [_end+130772360/2130457992] 
> :nfsd:nfsd+0x0/0x2e0
> Jan 29 22:13:36 master kernel:  [<ffffffff882f3800>] :nfsd:nfsd+0x0/0x2e0
> Jan 29 22:13:36 master kernel:  [_end+130772360/2130457992] 
> :nfsd:nfsd+0x0/0x2e0
> Jan 29 22:13:36 master kernel:  [<ffffffff882f3800>] :nfsd:nfsd+0x0/0x2e0
> Jan 29 22:13:36 master kernel:  [child_rip+0/18] child_rip+0x0/0x12
> Jan 29 22:13:36 master kernel:  [<ffffffff8020ca1e>] child_rip+0x0/0x12
> Jan 29 22:13:36 master kernel:
> Jan 29 22:13:36 master kernel: Mem-info:
> Jan 29 22:13:36 master kernel: DMA per-cpu:
> Jan 29 22:13:36 master kernel: CPU    0: Hot: hi:    0, btch:   1 
> usd:   0   Cold: hi:    0, btch:   1 usd:   0
> Jan 29 22:13:36 master kernel: CPU    1: Hot: hi:    0, btch:   1 
> usd:   0   Cold: hi:    0, btch:   1 usd:   0
> Jan 29 22:13:36 master kernel: DMA32 per-cpu:
> Jan 29 22:13:36 master kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 
> 150   Cold: hi:   62, btch:  15 usd:  62
> Jan 29 22:13:36 master kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 
> 105   Cold: hi:   62, btch:  15 usd:  52
> Jan 29 22:13:36 master kernel: Active:41027 inactive:437314 
> dirty:29708 writeback:0 unstable:0
> Jan 29 22:13:36 master kernel:  free:3892 slab:19405 mapped:11793 
> pagetables:1512 bounce:0
> Jan 29 22:13:36 master kernel: DMA free:8008kB min:28kB low:32kB 
> high:40kB active:0kB inactive:2384kB present:11100kB pages_scanned:0 
> all_unreclaimable? no
> Jan 29 22:13:36 master kernel: lowmem_reserve[]: 0 1998 1998 1998
> Jan 29 22:13:36 master kernel: DMA32 free:7560kB min:5704kB low:7128kB 
> high:8556kB active:164108kB inactive:1746872kB present:2046800kB 
> pages_scanned:32 all_unreclaimab
> le? no
> Jan 29 22:13:36 master kernel: lowmem_reserve[]: 0 0 0 0
> Jan 29 22:13:36 master kernel: DMA: 4*4kB 5*8kB 6*16kB 6*32kB 4*64kB 
> 2*128kB 4*256kB 4*512kB 0*1024kB 0*2048kB 1*4096kB = 8024kB
> Jan 29 22:13:36 master kernel: DMA32: 1365*4kB 11*8kB 38*16kB 18*32kB 
> 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 7756kB
> Jan 29 22:13:36 master kernel: Swap cache: add 43, delete 43, find 
> 0/0, race 0+0
> Jan 29 22:13:36 master kernel: Free swap  = 4088332kB
> Jan 29 22:13:36 master kernel: Total swap = 4088500kB
> Jan 29 22:13:36 master kernel: Free swap:       4088332kB
> Jan 29 22:13:36 master kernel: 523264 pages of RAM
> Jan 29 22:13:36 master kernel: 9510 reserved pages
> Jan 29 22:13:36 master kernel: 492885 pages shared
> Jan 29 22:13:36 master kernel: 0 pages swap cached
> Jan 29 22:13:44 master nmbd[3438]: [2008/01/29 22:13:44, 0] 
> nmbd/nmbd_packets.c:process_browse_packet(1061)
> Jan 29 22:13:44 master nmbd[3438]:   process_browse_packet: Discarding 
> datagram from IP 192.168.1.240. Source name master<00> is one of our 
> names !
> Jan 29 22:13:44 master nmbd[3438]: [2008/01/29 22:13:44, 0] 
> nmbd/nmbd_packets.c:process_browse_packet(1061)
> Jan 29 22:13:44 master nmbd[3438]:   process_browse_packet: Discarding 
> datagram from IP 192.168.1.237. Source name master<00> is one of our 
> names !
>

