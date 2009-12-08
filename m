Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZLHLyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZLHLyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbZLHLyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:54:36 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46170 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbZLHLyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:54:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=YZsWtu4p/KRRszvqXmajIye+eeUNSAsN3VLQklsSXLkpcLxxxpCbSYRO8X7br10lU1
         kLh3WWeGq4MvAr1zoexivqXhS4/dPkb0bdFl4mW0j97KN2F+qsS86pKKKLLR4qOFf5d7
         fxcKvfqHTQ55dS1D6TwBQWITXyqfgAXv27zpk=
MIME-Version: 1.0
In-Reply-To: <8b8dd87a0912080352j36fa24bbvf301a4101d80e434@mail.gmail.com>
References: <8b8dd87a0912071058p1ab9ba20y931baa576d370f43@mail.gmail.com>
	 <20091208000819.GA18291@linux.vnet.ibm.com>
	 <8b8dd87a0912080352j36fa24bbvf301a4101d80e434@mail.gmail.com>
Date: Tue, 8 Dec 2009 13:54:38 +0200
Message-ID: <8b8dd87a0912080354k69c9f508v8186f0009cf1bf8f@mail.gmail.com>
Subject: Re: Badness at kernel/rcutree.c:1228
From: kordex - <kordex@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I did add the printk and warn_once lines you requested and the output
from them is:

Hierarchical RCU implementation.
rcu_init() smp_processor_id() = 0
rcu_init_percpu_data(0) called
rcu_init_percpu_data(0) called

Full dmesg at http://xnet.fi/opt/apps/lkml-2.6.32-vanilla.dmesg.printk.txt

Captured just right after boot so it does not yet have anything else
than just clean boot messages.

--Mikko Kortelainen

2009/12/8 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Mon, Dec 07, 2009 at 08:58:35PM +0200, kordex - wrote:
>> Hello,
>>
>> I encountered this and I am able to reproduce, unfortunately. I was
>> syncing files from two large HDD drives and I saw difference between
>> cksum so I first suspected faulty filesystem but it was not that. Then
>> I ran couple of Seagate Seatools tests on these disks of mine, still
>> nothing. I suspected there was something bad in rsync(1) code but
>> still negative as tar worked in the same way. Ofcourse I did the dmesg
>> checking but after reboot after checking the disks were fine.  It
>> showed up clean. So I went there and tried to resync my non raid disk
>> with raid0 disk. Still same problem, data mismatch. I read something
>> from google when installing new sata controller about lib_sata an sil
>> 3114 and seagates disks not working so this time i though of checking
>> dmesg. And there it was nice little surprise:
>>
>> ------------[ cut here ]------------
>> Badness at kernel/rcutree.c:1228
>> NIP: c004ecbc LR: c004f14c CTR: c007bd70
>> REGS: df34dde0 TRAP: 0700   Not tainted  (2.6.32)
>> MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 24024482  XER: 20000000
>> TASK = d12c2d10[2734] 'buffer' THREAD: df34c000
>> GPR00: 00000001 df34de90 d12c2d10 c0746498 c07465a0 00b1ed55 00000001 00138c4a
>> GPR08: 00001032 c07b0000 00009032 00000008 44024488 1001c6ac 1002efd8 1002f064
>> GPR16: 10060000 10070000 10070000 c073a590 c073a710 c0685204 00000000 c07a5520
>> GPR24: c07a5520 0000000a df34c000 c0746498 c0746420 c0746528 00000009 c07465a0
>> NIP [c004ecbc] __rcu_process_callbacks+0x34/0x48c
>> LR [c004f14c] rcu_process_callbacks+0x38/0x4c
>> Call Trace:
>> [df34de90] [c004efec] __rcu_process_callbacks+0x364/0x48c (unreliable)
>> [df34deb0] [c004f14c] rcu_process_callbacks+0x38/0x4c
>> [df34ded0] [c0028e8c] __do_softirq+0xa4/0x120
>> [df34df10] [c0006a0c] do_softirq+0x40/0x58
>> [df34df20] [c0028c8c] irq_exit+0x38/0x80
>> [df34df30] [c0010d28] timer_interrupt+0x11c/0x138
>> [df34df40] [c00143a0] ret_from_except+0x0/0x14
>> --- Exception: 901 at 0x10002ddc
>>     LR = 0x10002d80
>> Instruction dump:
>> 7c0802a6 bf410008 7c9f2378 7c7b1b78 90010024 8804000e 2f800000 40be002c
>> 3d20c07b 8009a334 7c000034 5400d97e <0f000000> 2f800000 41be0010 38000001
>> munin-update: page allocation failure. order:1, mode:0x20
>> Call Trace:
>> [c59bfa30] [c0008a24] show_stack+0x4c/0x14c (unreliable)
>> [c59bfa70] [c0058154] __alloc_pages_nodemask+0x468/0x4b8
>> [c59bfb00] [c0077448] cache_alloc_refill+0x2d8/0x55c
>> [c59bfb50] [c0077830] kmem_cache_alloc+0x64/0xb0
>> [c59bfb70] [c04862fc] sk_prot_alloc+0x2c/0x78
>> [c59bfb90] [c04863e0] sk_clone+0x20/0x1b0
>> [c59bfbb0] [c04bca70] inet_csk_clone+0x1c/0x8c
>> [c59bfbc0] [c04d1358] tcp_create_openreq_child+0x20/0x2c4
>> [c59bfbe0] [c04d00a0] tcp_v4_syn_recv_sock+0x58/0x17c
>> [c59bfc00] [c04d11c4] tcp_check_req+0x268/0x3dc
>> [c59bfc40] [c04cf87c] tcp_v4_do_rcv+0xa0/0x198
>> [c59bfc70] [c04cfdb8] tcp_v4_rcv+0x444/0x6d4
>> [c59bfca0] [c04b450c] ip_local_deliver+0x104/0x1d8
>> [c59bfcc0] [c04b43d0] ip_rcv+0x508/0x540
>> [c59bfcf0] [c049227c] netif_receive_skb+0x390/0x3bc
>> [c59bfd20] [c0492344] process_backlog+0x9c/0x134
>> [c59bfd50] [c0492b44] net_rx_action+0x80/0x190
>> [c59bfd80] [c0028e8c] __do_softirq+0xa4/0x120
>> [c59bfdc0] [c0006a0c] do_softirq+0x40/0x58
>> [c59bfdd0] [c0028db4] local_bh_enable+0x7c/0x9c
>> [c59bfde0] [c04852c8] release_sock+0x94/0xa8
>> [c59bfe00] [c04dcd48] inet_stream_connect+0x224/0x29c
>> [c59bfe50] [c0482a54] sys_connect+0x78/0xa8
>> [c59bff00] [c0484088] sys_socketcall+0xf0/0x240
>> [c59bff40] [c0013cf4] ret_from_syscall+0x0/0x38
>> --- Exception: c01 at 0xfd51434
>>     LR = 0xff66550
>> Mem-Info:
>> DMA per-cpu:
>> CPU    0: hi:  186, btch:  31 usd:  87
>> active_anon:6308 inactive_anon:8347 isolated_anon:0
>>  active_file:52970 inactive_file:53351 isolated_file:0
>>  unevictable:0 dirty:12753 writeback:0 unstable:0
>>  free:1728 slab_reclaimable:2017 slab_unreclaimable:1020
>>  mapped:2045 shmem:410 pagetables:431 bounce:0
>> DMA free:6912kB min:2884kB low:3604kB high:4324kB active_anon:25232kB
>> inactive_anon:33388kB active_file:211880kB inactive_file:213404kB
>> unevictable:0kB isolated(anon):0kB isolated(file):0kB present:520192kB
>> mlocked:0kB dirty:51012kB writeback:0kB mapped:8180kB shmem:1640kB
>> slab_reclaimable:8068kB slab_unreclaimable:4080kB kernel_stack:992kB
>> pagetables:1724kB unstable:0kB bounce:0kB writeback_tmp:0kB
>> pages_scanned:0 all_unreclaimable? no
>> lowmem_reserve[]: 0 0 0 0
>> DMA: 1728*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB
>> 0*1024kB 0*2048kB 0*4096kB = 6912kB
>> 106743 total pagecache pages
>> 0 pages in swap cache
>> Swap cache stats: add 0, delete 0, find 0/0
>> Free swap  = 779144kB
>> Total swap = 779144kB
>> 131072 pages RAM
>> 0 pages HighMem
>> 3391 pages reserved
>> 14583 pages shared
>> 121040 pages non-shared
>>
>> ...
>>
>> Full dmesg: http://xnet.fi/opt/apps/lkml-2.6.32-vanilla.dmesg.txt
>> Kernel config: http://xnet.fi/opt/apps/lkml-2.6.32-vanilla.config.txt
>
> Interesting!  You appear to be running a UP build on a 32-bit PowerPC
> platform, which presumably disables CPU hotplug.  You are also running
> CONFIG_TREE_RCU, which does require initialization.  Your dmesg snippet
> seems to start after RCU initialized itself, as it would normally print:
>
>        Hierarchical RCU implementation.
>
> Are you able to capture console output that early?  If so, could you
> please try the attached patch?
>
> The behavior is consistent with the boot CPU thinking that it is not
> online, which would indeed be strange.  The patch checks on this and
> also prints out at the point that ->beenonline should be initialized.
>
>> uname -a: Linux navi 2.6.32 #2 Mon Dec 7 13:35:57 EET 2009 ppc GNU/Linux
>>
>> And no I am not running any patches on this. Same occurred with
>> 2.6.31.6 which I had patched with Con Kolivas' BFS so I upgraded to
>> latest stable vanilla without any patches and still there it is. You
>> know, it ain't too interesting to sync 1TB disks 5 times (yea I needed
>> to do some testing for rsync) with slow controllers like these.
>
> You also have quite a few occurrences of the following splat in your
> dmesg, which might well explain your sync-ing woes:
>
>        Mem-Info:
>        DMA per-cpu:
>        CPU    0: hi:  186, btch:  31 usd: 153
>        active_anon:8938 inactive_anon:9432 isolated_anon:0
>         active_file:11943 inactive_file:91997 isolated_file:0
>         unevictable:0 dirty:4317 writeback:3464 unstable:0
>         free:1044 slab_reclaimable:1160 slab_unreclaimable:1123
>         mapped:3207 shmem:411 pagetables:471 bounce:0
>        DMA free:4176kB min:2884kB low:3604kB high:4324kB active_anon:35752kB
>        inactive_anon:37728kB active_file:47772kB inactive_file:367988kB
>        unevictable:0kB isolated(anon):0kB isolated(file):0kB present:520192kB
>        mlocked:0kB dirty:17268kB writeback:13856kB mapped:12828kB shmem:1644kB
>        slab_reclaimable:4640kB slab_unreclaimable:4492kB kernel_stack:1040kB
>        pagetables:1884kB unstable:0kB bounce:0kB writeback_tmp:0kB
>        pages_scanned:0 all_unreclaimable? no
>        lowmem_reserve[]: 0 0 0 0
>        DMA: 1034*4kB 5*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB
>        0*1024kB 0*2048kB 0*4096kB = 4176kB
>        104353 total pagecache pages
>        0 pages in swap cache
>        Swap cache stats: add 0, delete 0, find 0/0
>        Free swap  = 779144kB
>        Total swap = 779144kB
>        131072 pages RAM
>        0 pages HighMem
>        3391 pages reserved
>        14353 pages shared
>        120982 pages non-shared
>        mconf: page allocation failure. order:1, mode:0x20
>        Call Trace:
>        [d1197cb0] [c0008a24] show_stack+0x4c/0x14c (unreliable)
>        [d1197cf0] [c0058154] __alloc_pages_nodemask+0x468/0x4b8
>        [d1197d80] [c0077448] cache_alloc_refill+0x2d8/0x55c
>        [d1197dd0] [c0077780] __kmalloc+0xb4/0x100
>        [d1197df0] [c02aa6bc] tty_buffer_request_room+0xcc/0x148
>        [d1197e10] [c02aa8f4] tty_insert_flip_string+0x2c/0xa0
>        [d1197e30] [c02ab678] pty_write+0x40/0x70
>        [d1197e50] [c02a6244] n_tty_write+0x260/0x3bc
>        [d1197eb0] [c02a3780] tty_write+0x1bc/0x260
>        [d1197ef0] [c007b4d4] vfs_write+0xb8/0x180
>        [d1197f10] [c007b67c] sys_write+0x4c/0x8c
>        [d1197f40] [c0013cf4] ret_from_syscall+0x0/0x38
>        --- Exception: c01 at 0xfef4034
>            LR = 0xfe97624
>        Mem-Info:
>        DMA per-cpu:
>        CPU    0: hi:  186, btch:  31 usd: 153
>        active_anon:8938 inactive_anon:9432 isolated_anon:0
>         active_file:11943 inactive_file:91997 isolated_file:0
>         unevictable:0 dirty:4317 writeback:3336 unstable:0
>         free:1044 slab_reclaimable:1160 slab_unreclaimable:1123
>         mapped:3207 shmem:411 pagetables:471 bounce:0
>        DMA free:4176kB min:2884kB low:3604kB high:4324kB active_anon:35752kB
>        inactive_anon:37728kB active_file:47772kB inactive_file:367988kB
>        unevictable:0kB isolated(anon):0kB isolated(file):0kB present:520192kB
>        mlocked:0kB dirty:17268kB writeback:13344kB mapped:12828kB shmem:1644kB
>        slab_reclaimable:4640kB slab_unreclaimable:4492kB kernel_stack:1040kB
>        pagetables:1884kB unstable:0kB bounce:0kB writeback_tmp:0kB
>        pages_scanned:0 all_unreclaimable? no
>        lowmem_reserve[]: 0 0 0 0
>        DMA: 1034*4kB 5*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB
>        0*1024kB 0*2048kB 0*4096kB = 4176kB
>        104353 total pagecache pages
>        0 pages in swap cache
>        Swap cache stats: add 0, delete 0, find 0/0
>        Free swap  = 779144kB
>        Total swap = 779144kB
>        131072 pages RAM
>        0 pages HighMem
>        3391 pages reserved
>        14353 pages shared
>        120982 pages non-shared
>        mconf: page allocation failure. order:1, mode:0x20
>        Call Trace:
>        [d1197cb0] [c0008a24] show_stack+0x4c/0x14c (unreliable)
>        [d1197cf0] [c0058154] __alloc_pages_nodemask+0x468/0x4b8
>        [d1197d80] [c0077448] cache_alloc_refill+0x2d8/0x55c
>        [d1197dd0] [c0077780] __kmalloc+0xb4/0x100
>        [d1197df0] [c02aa6bc] tty_buffer_request_room+0xcc/0x148
>        [d1197e10] [c02aa8f4] tty_insert_flip_string+0x2c/0xa0
>        [d1197e30] [c02ab678] pty_write+0x40/0x70
>        [d1197e50] [c02a6244] n_tty_write+0x260/0x3bc
>        [d1197eb0] [c02a3780] tty_write+0x1bc/0x260
>        [d1197ef0] [c007b4d4] vfs_write+0xb8/0x180
>        [d1197f10] [c007b67c] sys_write+0x4c/0x8c
>        [d1197f40] [c0013cf4] ret_from_syscall+0x0/0x38
>        --- Exception: c01 at 0xfef4034
>
>                                                        Thanx, Paul
>
> ------------------------------------------------------------------------
>
> rcu: diagnostic patch for kordex
>
> Make sure that the boot CPU has marked itself as online, print out
> the running CPU's ID, and print a message from within rcu_init_percpu_data()
> that includes the currently running CPU.
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com> not for inclusion
> ---
>
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index 4001833..4f357c4 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -175,6 +175,8 @@ void __init rcu_init(void)
>         * this is called early in boot, before either interrupts
>         * or the scheduler are operational.
>         */
> +       WARN_ON_ONCE(!cpu_online(smp_processor_id()));
> +       printk(KERN_ALERT "rcu_init() smp_processor_id() = %d\n", smp_processor_id());
>        for_each_online_cpu(i)
>                rcu_barrier_cpu_hotplug(NULL, CPU_UP_PREPARE, (void *)(long)i);
>  }
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index f3077c0..207125b 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1557,6 +1557,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
>        rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
>        rdp->qs_pending = 1;     /*  so set up to respond to current GP. */
>        rdp->beenonline = 1;     /* We have now been online. */
> +       printk(KERN_ALERT "rcu_init_percpu_data(%d) called\n", cpu);
>        rdp->preemptable = preemptable;
>        rdp->passed_quiesc_completed = lastcomp - 1;
>        rdp->qlen_last_fqs_check = 0;
>
