Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208Ab0ACXbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0ACXbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 18:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195Ab0ACXbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 18:31:14 -0500
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:33182 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab0ACXbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 18:31:12 -0500
X-Greylist: delayed 1562 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jan 2010 18:31:12 EST
Message-ID: <4B412287.5080902@cogweb.net>
Date: Sun, 03 Jan 2010 15:04:39 -0800
From: David Liontooth <lionteeth@cogweb.net>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.32.2 page allocation failures
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My 2.6.32.2 from kernel.org is generating a large number of page 
allocation failures.

Please cc; I'm not subscribed.  Portions of .config below.

Are there workarounds? KSM is in the kernel but not activated 
(/sys/kernel/mm/ksm/run is 0).

The distro is an up-to-date Debian squeeze, amd64.

Cheers,
Dave

munin-update: page allocation failure. order:1, mode:0x20
Pid: 17499, comm: munin-update Not tainted 2.6.32.2 #1
Call Trace:
 <IRQ>  [<ffffffff810635ef>] ? __alloc_pages_nodemask+0x53f/0x58c
 [<ffffffff810853c9>] ? kmem_getpages+0x4a/0x106
 [<ffffffff810855a2>] ? fallback_alloc+0x11d/0x191
 [<ffffffff8108571b>] ? ____cache_alloc_node+0x105/0x124
 [<ffffffff81086078>] ? kmem_cache_alloc+0xcd/0xf7
 [<ffffffff812c338e>] ? sk_prot_alloc+0x27/0xc3
 [<ffffffff812f5d33>] ? inet_csk_route_req+0xbc/0x11e
 [<ffffffff812c34ba>] ? sk_clone+0x16/0x22b
 [<ffffffff812f5c09>] ? inet_csk_clone+0xf/0x7d
 [<ffffffff81308ba0>] ? tcp_create_openreq_child+0x1d/0x383
 [<ffffffff8130780f>] ? tcp_v4_syn_recv_sock+0x4e/0x1b2
 [<ffffffff81308a10>] ? tcp_check_req+0x20b/0x37e
 [<ffffffff812c54d0>] ? skb_checksum+0x4c/0x251
 [<ffffffff81306f81>] ? tcp_v4_do_rcv+0xba/0x1cc
 [<ffffffff8130751a>] ? tcp_v4_rcv+0x487/0x72e
 [<ffffffff812eda8d>] ? ip_local_deliver_finish+0x12f/0x213
 [<ffffffff812ed657>] ? ip_rcv_finish+0x373/0x38d
 [<ffffffff812cda3e>] ? process_backlog+0x75/0xa2
 [<ffffffff812cdf88>] ? net_rx_action+0x69/0x121
 [<ffffffff8103897b>] ? __do_softirq+0x8b/0x108
 [<ffffffff8100bdfc>] ? call_softirq+0x1c/0x28
 <EOI>  [<ffffffff8100d7d9>] ? do_softirq+0x31/0x66
 [<ffffffff810387d4>] ? local_bh_enable_ip+0x78/0x8a
 [<ffffffff813137b7>] ? inet_stream_connect+0x1ed/0x243
 [<ffffffff812bfe06>] ? sys_connect+0x6c/0x9c
 [<ffffffff810234d5>] ? do_page_fault+0x1e5/0x1fa
 [<ffffffff811ec126>] ? __up_read+0x13/0x8d
 [<ffffffff8100adeb>] ? system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  38
CPU    1: hi:  186, btch:  31 usd: 163
active_anon:51066 inactive_anon:56220 isolated_anon:0
 active_file:16410 inactive_file:74813 isolated_file:0
 unevictable:0 dirty:960 writeback:0 unstable:0
 free:4492 slab_reclaimable:5074 slab_unreclaimable:41922
 mapped:1779 shmem:21 pagetables:2517 bounce:0
Node 0 DMA free:4092kB min:60kB low:72kB high:88kB active_anon:168kB 
inactive_anon:192kB active_file:5092kB inactive_file:5888kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15348kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:24kB shmem:0kB 
slab_reclaimable:248kB slab_unreclaimable:36kB kernel_stack:48kB 
pagetables:112kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 994 994 994
Node 0 DMA32 free:13876kB min:4000kB low:5000kB high:6000kB 
active_anon:204096kB inactive_anon:224688kB active_file:60548kB 
inactive_file:293364kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:1018016kB mlocked:0kB dirty:3840kB 
writeback:0kB mapped:7092kB shmem:84kB slab_reclaimable:20048kB 
slab_unreclaimable:167652kB kernel_stack:1184kB pagetables:9956kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 1005*4kB 10*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 4100kB
Node 0 DMA32: 2705*4kB 382*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 
0*512kB 0*1024kB 0*2048kB 0*4096kB = 13876kB
92667 total pagecache pages
1390 pages in swap cache
Swap cache stats: add 13421, delete 12031, find 69754/70252
Free swap  = 2058228kB
Total swap = 2096472kB
262128 pages RAM
5127 pages reserved
59008 pages shared
196968 pages non-shared
apache_processe: page allocation failure. order:1, mode:0x20
Pid: 18786, comm: apache_processe Not tainted 2.6.32.2 #1
Call Trace:
 <IRQ>  [<ffffffff810635ef>] ? __alloc_pages_nodemask+0x53f/0x58c
 [<ffffffff810853c9>] ? kmem_getpages+0x4a/0x106
 [<ffffffff810855a2>] ? fallback_alloc+0x11d/0x191
 [<ffffffff8108571b>] ? ____cache_alloc_node+0x105/0x124
 [<ffffffff81086078>] ? kmem_cache_alloc+0xcd/0xf7
 [<ffffffff81302514>] ? tcp_transmit_skb+0x604/0x643
 [<ffffffff812c338e>] ? sk_prot_alloc+0x27/0xc3
 [<ffffffff812f5d33>] ? inet_csk_route_req+0xbc/0x11e
 [<ffffffff812c34ba>] ? sk_clone+0x16/0x22b
 [<ffffffff812f5c09>] ? inet_csk_clone+0xf/0x7d
 [<ffffffff81301051>] ? tcp_rcv_state_process+0x3ed/0xab8
 [<ffffffff81308ba0>] ? tcp_create_openreq_child+0x1d/0x383
 [<ffffffff8130780f>] ? tcp_v4_syn_recv_sock+0x4e/0x1b2
 [<ffffffff81308a10>] ? tcp_check_req+0x20b/0x37e
 [<ffffffff8130751a>] ? tcp_v4_rcv+0x487/0x72e
 [<ffffffff81306f81>] ? tcp_v4_do_rcv+0xba/0x1cc
 [<ffffffff8130751a>] ? tcp_v4_rcv+0x487/0x72e
 [<ffffffff812eda8d>] ? ip_local_deliver_finish+0x12f/0x213
 [<ffffffff812ed657>] ? ip_rcv_finish+0x373/0x38d
 [<ffffffff812cda3e>] ? process_backlog+0x75/0xa2
 [<ffffffff812cdf88>] ? net_rx_action+0x69/0x121
 [<ffffffff8103897b>] ? __do_softirq+0x8b/0x108
 [<ffffffff8100bdfc>] ? call_softirq+0x1c/0x28
 <EOI>  [<ffffffff8100d7d9>] ? do_softirq+0x31/0x66
 [<ffffffff8103885e>] ? local_bh_enable+0x78/0x8a
 [<ffffffff812ce9ec>] ? dev_queue_xmit+0x36f/0x3a1
 [<ffffffff812f1dac>] ? ip_queue_xmit+0x2f3/0x350
 [<ffffffff81302514>] ? tcp_transmit_skb+0x604/0x643
 [<ffffffff813049a0>] ? tcp_write_xmit+0x874/0x96c
 [<ffffffff812c7486>] ? __alloc_skb+0x64/0x156
 [<ffffffff81304ae5>] ? __tcp_push_pending_frames+0x22/0x77
 [<ffffffff812f9842>] ? tcp_sendmsg+0x8d9/0x9d5
 [<ffffffff812bf422>] ? sock_aio_write+0xfd/0x111
 [<ffffffff8105de1d>] ? filemap_fault+0x5c/0x303
 [<ffffffff8108b04e>] ? do_sync_write+0xce/0x113
 [<ffffffff81045046>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff811e7e3b>] ? _atomic_dec_and_lock+0x33/0x50
 [<ffffffff8108b94f>] ? vfs_write+0xc0/0x149
 [<ffffffff8108ba94>] ? sys_write+0x45/0x6e
 [<ffffffff8100adeb>] ? system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  70
CPU    1: hi:  186, btch:  31 usd:  43
active_anon:51805 inactive_anon:56418 isolated_anon:0
 active_file:23055 inactive_file:71065 isolated_file:0
 unevictable:0 dirty:17991 writeback:0 unstable:0
 free:2489 slab_reclaimable:4154 slab_unreclaimable:41827
 mapped:2170 shmem:21 pagetables:1922 bounce:0
Node 0 DMA free:4040kB min:60kB low:72kB high:88kB active_anon:260kB 
inactive_anon:304kB active_file:4540kB inactive_file:6516kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15348kB 
mlocked:0kB dirty:380kB writeback:0kB mapped:108kB shmem:0kB 
slab_reclaimable:240kB slab_unreclaimable:36kB kernel_stack:8kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 994 994 994
Node 0 DMA32 free:5916kB min:4000kB low:5000kB high:6000kB 
active_anon:206960kB inactive_anon:225368kB active_file:87680kB 
inactive_file:277744kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:1018016kB mlocked:0kB dirty:71584kB 
writeback:0kB mapped:8572kB shmem:84kB slab_reclaimable:16376kB 
slab_unreclaimable:167272kB kernel_stack:1224kB pagetables:7688kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 1008*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 4040kB
Node 0 DMA32: 1291*4kB 94*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 
0*512kB 0*1024kB 0*2048kB 0*4096kB = 5916kB
95543 total pagecache pages
1400 pages in swap cache
Swap cache stats: add 13470, delete 12070, find 78287/78792
Free swap  = 2058292kB
Total swap = 2096472kB
262128 pages RAM
5127 pages reserved
26675 pages shared
202990 pages non-shared
transcode: page allocation failure. order:0, mode:0x20
Pid: 13584, comm: transcode Not tainted 2.6.32.2 #1
Call Trace:
 <IRQ>  [<ffffffff810635ef>] ? __alloc_pages_nodemask+0x53f/0x58c
 [<ffffffff810853c9>] ? kmem_getpages+0x4a/0x106
 [<ffffffff810855a2>] ? fallback_alloc+0x11d/0x191
 [<ffffffff8108571b>] ? ____cache_alloc_node+0x105/0x124
 [<ffffffff810857cc>] ? kmem_cache_alloc_node+0x92/0xb9
 [<ffffffff812c7486>] ? __alloc_skb+0x64/0x156
 [<ffffffff812c8075>] ? __netdev_alloc_skb+0x29/0x43
 [<ffffffffa007848f>] ? skge_poll+0x3d0/0x606 [skge]
 [<ffffffffa00786b2>] ? skge_poll+0x5f3/0x606 [skge]
 [<ffffffffa0112cf1>] ? ivtv_irq_handler+0x20/0xfbc [ivtv]
 [<ffffffff812cdf88>] ? net_rx_action+0x69/0x121
 [<ffffffff8103897b>] ? __do_softirq+0x8b/0x108
 [<ffffffff8100bdfc>] ? call_softirq+0x1c/0x28
 [<ffffffff8100d7d9>] ? do_softirq+0x31/0x66
 [<ffffffff8100cede>] ? do_IRQ+0xa0/0xb6
 [<ffffffff8100b693>] ? ret_from_intr+0x0/0xa
 <EOI>
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 165
CPU    1: hi:  186, btch:  31 usd:  70
active_anon:5350 inactive_anon:8317 isolated_anon:0
 active_file:45642 inactive_file:139477 isolated_file:32
 unevictable:0 dirty:5670 writeback:15455 unstable:0
 free:1371 slab_reclaimable:7882 slab_unreclaimable:42980
 mapped:3588 shmem:23 pagetables:1629 bounce:0
Node 0 DMA free:3996kB min:60kB low:72kB high:88kB active_anon:0kB 
inactive_anon:76kB active_file:4168kB inactive_file:7452kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15348kB 
mlocked:0kB dirty:28kB writeback:2520kB mapped:176kB shmem:0kB 
slab_reclaimable:208kB slab_unreclaimable:52kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
lowmem_reserve[]: 0 994 994 994
Node 0 DMA32 free:1488kB min:4000kB low:5000kB high:6000kB 
active_anon:21400kB inactive_anon:33192kB active_file:178400kB 
inactive_file:550456kB unevictable:0kB isolated(anon):0kB 
isolated(file):128kB present:1018016kB mlocked:0kB dirty:22652kB 
writeback:59300kB mapped:14176kB shmem:92kB slab_reclaimable:31320kB 
slab_unreclaimable:171868kB kernel_stack:1200kB pagetables:6516kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 53*4kB 61*8kB 60*16kB 61*32kB 6*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 3996kB
Node 0 DMA32: 318*4kB 27*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 
0*512kB 0*1024kB 0*2048kB 0*4096kB = 1488kB
186680 total pagecache pages
1496 pages in swap cache
Swap cache stats: add 15810, delete 14314, find 1109002/1109872
Free swap  = 2064764kB
Total swap = 2096472kB
262128 pages RAM
5127 pages reserved
128878 pages shared
106811 pages non-shared

grep "=[y|m]" /usr/src/linux/.config (excerpt)

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_CONSTRUCTORS=y
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_BZIP2=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_TREE_RCU=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_NAMESPACES=y
CONFIG_NET_NS=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLAB=y
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_SLOW_WORK=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLOCK_COMPAT=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_DEFAULT_AS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_MEMTEST=y
CONFIG_MK8=y
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_AMD_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_KSM=y
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y
CONFIG_PM=y
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y

CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y

CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACING_SUPPORT=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_0X80=y
CONFIG_HAVE_KVM=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y

CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

