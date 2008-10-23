Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYJWM6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYJWM6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 08:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYJWM6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 08:58:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38316 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYJWM6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:58:03 -0400
Date: Thu, 23 Oct 2008 14:57:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug] Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct
	cpumask
Message-ID: <20081023125733.GA19147@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023120322.GC25132@elte.hu> <20081023125529.GA18327@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20081023125529.GA18327@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE,UPPERCASE_50_75 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
	0.8 UPPERCASE_50_75        message body is 50-75% uppercase
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Ingo Molnar <mingo@elte.hu> wrote:

> ok, the new cpumask code blew up in -tip testing, with various sorts 
> of slab corruptions during scheduler init:

another 64-bit testbox has similar problems - see the log attached 
below. Config attached as well. The bootup seems to have continued fine.

	Ingo

------------>
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (11732.92 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
=============================================================================
BUG kmalloc-8: Wrong object count. Counter is 11 but counted were 50
-----------------------------------------------------------------------------

INFO: Slab 0xffffe200019cc2d8 objects=51 used=11 fp=0xffff88003f807370 flags=0x40000000000000c3
Pid: 1, comm: swapper Not tainted 2.6.27-tip-07104-g5cf7b67-dirty #1
Call Trace:
 [<ffffffff802cf110>] slab_err+0xa0/0xb0
 [<ffffffff8052a57d>] ? _raw_spin_unlock+0x6d/0xd0
 [<ffffffff80249762>] ? cpu_attach_domain+0x172/0x6b0
 [<ffffffff802ce579>] ? check_bytes+0x9/0x30
 [<ffffffff802d0ea8>] ? slab_pad_check+0xd8/0x160
 [<ffffffff802cfa67>] on_freelist+0x197/0x240
 [<ffffffff802d1877>] __slab_free+0x1c7/0x330
 [<ffffffff80512929>] ? free_cpumask_var+0x9/0x10
 [<ffffffff802d1a9b>] kfree+0xbb/0x120
 [<ffffffff80512929>] ? free_cpumask_var+0x9/0x10
 [<ffffffff80512929>] free_cpumask_var+0x9/0x10
 [<ffffffff80249ec7>] __build_sched_domains+0x227/0x580
 [<ffffffff819dd5f5>] sched_init_smp+0x95/0x280
 [<ffffffff819d239a>] ? native_smp_cpus_done+0x1aa/0x2b0
 [<ffffffff819c5fd0>] kernel_init+0x170/0x240
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff802134b9>] child_rip+0xa/0x11
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff819c5e60>] ? kernel_init+0x0/0x240
 [<ffffffff802134af>] ? child_rip+0x0/0x11
FIX kmalloc-8: Object count adjusted.
=============================================================================
BUG kmalloc-8: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88003f807328-0xffff88003f80732f. First byte 0x0 instead of 0xcc
INFO: Slab 0xffffe200019cc2d8 objects=51 used=50 fp=0xffff88003f807370 flags=0x40000000000000c3
INFO: Object 0xffff88003f807320 @offset=800 fp=0x0000000000000000

Bytes b4 0xffff88003f807310:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  Object 0xffff88003f807320:  00 00 00 00 00 00 00 00                         ........        
 Redzone 0xffff88003f807328:  00 00 00 00 00 00 00 00                         ........        
 Padding 0xffff88003f807368:  00 00 00 00 00 00 00 00                         ........        
Pid: 1, comm: swapper Not tainted 2.6.27-tip-07104-g5cf7b67-dirty #1
Call Trace:
 [<ffffffff802cf21c>] print_trailer+0xfc/0x160
 [<ffffffff802cf3e8>] check_bytes_and_report+0xb8/0xe0
 [<ffffffff802d092a>] check_object+0x6a/0x270
 [<ffffffff802d18d9>] __slab_free+0x229/0x330
 [<ffffffff80512929>] ? free_cpumask_var+0x9/0x10
 [<ffffffff802d1a9b>] kfree+0xbb/0x120
 [<ffffffff80512929>] ? free_cpumask_var+0x9/0x10
 [<ffffffff80512929>] free_cpumask_var+0x9/0x10
 [<ffffffff80249ec7>] __build_sched_domains+0x227/0x580
 [<ffffffff819dd5f5>] sched_init_smp+0x95/0x280
 [<ffffffff819d239a>] ? native_smp_cpus_done+0x1aa/0x2b0
 [<ffffffff819c5fd0>] kernel_init+0x170/0x240
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff802134b9>] child_rip+0xa/0x11
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff819c5e60>] ? kernel_init+0x0/0x240
 [<ffffffff802134af>] ? child_rip+0x0/0x11
FIX kmalloc-8: Restoring 0xffff88003f807328-0xffff88003f80732f=0xcc

=============================================================================
BUG kmalloc-8: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88003f8072d8-0xffff88003f8072df. First byte 0x0 instead of 0xcc
INFO: Slab 0xffffe200019cc2d8 objects=51 used=50 fp=0xffff88003f807370 flags=0x40000000000000c3
INFO: Object 0xffff88003f8072d0 @offset=720 fp=0x0000000000000000

Bytes b4 0xffff88003f8072c0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  Object 0xffff88003f8072d0:  03 00 00 00 00 00 00 00                         ........        
 Redzone 0xffff88003f8072d8:  00 00 00 00 00 00 00 00                         ........        
 Padding 0xffff88003f807318:  00 00 00 00 00 00 00 00                         ........        
Pid: 1, comm: swapper Not tainted 2.6.27-tip-07104-g5cf7b67-dirty #1
Call Trace:
 [<ffffffff802cf21c>] print_trailer+0xfc/0x160
 [<ffffffff802cf3e8>] check_bytes_and_report+0xb8/0xe0
 [<ffffffff802d092a>] check_object+0x6a/0x270
 [<ffffffff802d18d9>] __slab_free+0x229/0x330
 [<ffffffff80512929>] ? free_cpumask_var+0x9/0x10
 [<ffffffff802d1a9b>] kfree+0xbb/0x120
 [<ffffffff80512929>] ? free_cpumask_var+0x9/0x10
 [<ffffffff80512929>] free_cpumask_var+0x9/0x10
 [<ffffffff80249ed0>] __build_sched_domains+0x230/0x580
 [<ffffffff819dd5f5>] sched_init_smp+0x95/0x280
 [<ffffffff819d239a>] ? native_smp_cpus_done+0x1aa/0x2b0
 [<ffffffff819c5fd0>] kernel_init+0x170/0x240
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff802134b9>] child_rip+0xa/0x11
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff819c5e60>] ? kernel_init+0x0/0x240
 [<ffffffff802134af>] ? child_rip+0x0/0x11
FIX kmalloc-8: Restoring 0xffff88003f8072d8-0xffff88003f8072df=0xcc

=============================================================================
BUG kmalloc-8: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88003f807288-0xffff88003f80728f. First byte 0x0 instead of 0xcc
INFO: Slab 0xffffe200019cc2d8 objects=51 used=50 fp=0xffff88003f807370 flags=0x40000000000000c3
INFO: Object 0xffff88003f807280 @offset=640 fp=0x0000000000000000

Bytes b4 0xffff88003f807270:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  Object 0xffff88003f807280:  00 00 00 00 00 00 00 00                         ........        
 Redzone 0xffff88003f807288:  00 00 00 00 00 00 00 00                         ........        
 Padding 0xffff88003f8072c8:  00 00 00 00 00 00 00 00                         ........        
Pid: 1, comm: swapper Not tainted 2.6.27-tip-07104-g5cf7b67-dirty #1
Call Trace:
 [<ffffffff802cf21c>] print_trailer+0xfc/0x160
 [<ffffffff802cf3e8>] check_bytes_and_report+0xb8/0xe0
 [<ffffffff802d092a>] check_object+0x6a/0x270
 [<ffffffff802d18d9>] __slab_free+0x229/0x330
 [<ffffffff80512929>] ? free_cpumask_var+0x9/0x10
 [<ffffffff802d1a9b>] kfree+0xbb/0x120
 [<ffffffff80512929>] ? free_cpumask_var+0x9/0x10
 [<ffffffff80512929>] free_cpumask_var+0x9/0x10
 [<ffffffff80249d4d>] __build_sched_domains+0xad/0x580
 [<ffffffff819dd5f5>] sched_init_smp+0x95/0x280
 [<ffffffff819d239a>] ? native_smp_cpus_done+0x1aa/0x2b0
 [<ffffffff819c5fd0>] kernel_init+0x170/0x240
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff802134b9>] child_rip+0xa/0x11
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff819c5e60>] ? kernel_init+0x0/0x240
 [<ffffffff802134af>] ? child_rip+0x0/0x11
FIX kmalloc-8: Restoring 0xffff88003f807288-0xffff88003f80728f=0xcc

=============================================================================
BUG kmalloc-8: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88003f807238-0xffff88003f80723f. First byte 0x0 instead of 0xcc
INFO: Slab 0xffffe200019cc2d8 objects=51 used=50 fp=0xffff88003f807370 flags=0x40000000000000c3
INFO: Object 0xffff88003f807230 @offset=560 fp=0x0000000000000000

Bytes b4 0xffff88003f807220:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  Object 0xffff88003f807230:  00 00 00 00 00 00 00 00                         ........        
 Redzone 0xffff88003f807238:  00 00 00 00 00 00 00 00                         ........        
 Padding 0xffff88003f807278:  00 00 00 00 00 00 00 00                         ........        
Pid: 1, comm: swapper Not tainted 2.6.27-tip-07104-g5cf7b67-dirty #1
Call Trace:
 [<ffffffff802cf21c>] print_trailer+0xfc/0x160
 [<ffffffff802cf3e8>] check_bytes_and_report+0xb8/0xe0
 [<ffffffff802d092a>] check_object+0x6a/0x270
 [<ffffffff802d18d9>] __slab_free+0x229/0x330
 [<ffffffff80512929>] ? free_cpumask_var+0x9/0x10
 [<ffffffff802d1a9b>] kfree+0xbb/0x120
 [<ffffffff80512929>] ? free_cpumask_var+0x9/0x10
 [<ffffffff80512929>] free_cpumask_var+0x9/0x10
 [<ffffffff80249d2d>] __build_sched_domains+0x8d/0x580
 [<ffffffff819dd5f5>] sched_init_smp+0x95/0x280
 [<ffffffff819d239a>] ? native_smp_cpus_done+0x1aa/0x2b0
 [<ffffffff819c5fd0>] kernel_init+0x170/0x240
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff802134b9>] child_rip+0xa/0x11
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff819c5e60>] ? kernel_init+0x0/0x240
 [<ffffffff802134af>] ? child_rip+0x0/0x11
FIX kmalloc-8: Restoring 0xffff88003f807238-0xffff88003f80723f=0xcc

=============================================================================
BUG kmalloc-8: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88003f8071e8-0xffff88003f8071ef. First byte 0x0 instead of 0xcc
INFO: Slab 0xffffe200019cc2d8 objects=51 used=50 fp=0xffff88003f807370 flags=0x40000000000000c3
INFO: Object 0xffff88003f8071e0 @offset=480 fp=0x0000000000000000

Bytes b4 0xffff88003f8071d0:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
  Object 0xffff88003f8071e0:  03 00 00 00 00 00 00 00                         ........        
 Redzone 0xffff88003f8071e8:  00 00 00 00 00 00 00 00                         ........        
 Padding 0xffff88003f807228:  00 00 00 00 00 00 00 00                         ........        
Pid: 1, comm: swapper Not tainted 2.6.27-tip-07104-g5cf7b67-dirty #1
Call Trace:
 [<ffffffff802cf21c>] print_trailer+0xfc/0x160
 [<ffffffff802cf3e8>] check_bytes_and_report+0xb8/0xe0
 [<ffffffff802d092a>] check_object+0x6a/0x270
 [<ffffffff802d18d9>] __slab_free+0x229/0x330
 [<ffffffff80512929>] ? free_cpumask_var+0x9/0x10
 [<ffffffff802d1a9b>] kfree+0xbb/0x120
 [<ffffffff80512929>] ? free_cpumask_var+0x9/0x10
 [<ffffffff80512929>] free_cpumask_var+0x9/0x10
 [<ffffffff80249d0f>] __build_sched_domains+0x6f/0x580
 [<ffffffff819dd5f5>] sched_init_smp+0x95/0x280
 [<ffffffff819d239a>] ? native_smp_cpus_done+0x1aa/0x2b0
 [<ffffffff819c5fd0>] kernel_init+0x170/0x240
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff802134b9>] child_rip+0xa/0x11
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff819c5e60>] ? kernel_init+0x0/0x240
 [<ffffffff802134af>] ? child_rip+0x0/0x11
FIX kmalloc-8: Restoring 0xffff88003f8071e8-0xffff88003f8071ef=0xcc

=============================================================================
BUG kmalloc-8: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88003f807378-0xffff88003f80737f. First byte 0x0 instead of 0xbb
INFO: Slab 0xffffe200019cc2d8 objects=51 used=50 fp=0xffff88003f807370 flags=0x40000000000000c3
INFO: Object 0xffff88003f807370 @offset=880 fp=0x0000000000000000

Bytes b4 0xffff88003f807360:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  Object 0xffff88003f807370:  00 00 00 00 00 00 00 00                         ........        
 Redzone 0xffff88003f807378:  00 00 00 00 00 00 00 00                         ........        
 Padding 0xffff88003f8073b8:  00 00 00 00 00 00 00 00                         ........        
Pid: 1, comm: swapper Not tainted 2.6.27-tip-07104-g5cf7b67-dirty #1
Call Trace:
 [<ffffffff802cf21c>] print_trailer+0xfc/0x160
 [<ffffffff802cf3e8>] check_bytes_and_report+0xb8/0xe0
 [<ffffffff80246aee>] ? register_sched_domain_sysctl+0xce/0x470
 [<ffffffff802d092a>] check_object+0x6a/0x270
 [<ffffffff802d23df>] __slab_alloc+0x4df/0x590
 [<ffffffff80246aee>] ? register_sched_domain_sysctl+0xce/0x470
 [<ffffffff80246aee>] ? register_sched_domain_sysctl+0xce/0x470
 [<ffffffff802d3c90>] __kmalloc_track_caller+0x100/0x110
 [<ffffffff802b20f5>] kstrdup+0x45/0x120
 [<ffffffff80246aee>] register_sched_domain_sysctl+0xce/0x470
 [<ffffffff819dd5fa>] sched_init_smp+0x9a/0x280
 [<ffffffff819d239a>] ? native_smp_cpus_done+0x1aa/0x2b0
 [<ffffffff819c5fd0>] kernel_init+0x170/0x240
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff802134b9>] child_rip+0xa/0x11
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff819c5140>] ? early_idt_handler+0x0/0x73
 [<ffffffff819c5e60>] ? kernel_init+0x0/0x240
 [<ffffffff802134af>] ? child_rip+0x0/0x11
FIX kmalloc-8: Restoring 0xffff88003f807378-0xffff88003f80737f=0xbb

FIX kmalloc-8: Marking all objects used
calling  init_cpufreq_transition_notifier_list+0x0/0x20 @ 1
initcall init_cpufreq_transition_notifier_list+0x0/0x20 returned 0 after 0 usecs
calling  net_ns_init+0x0/0x180 @ 1
net_namespace: 728 bytes
initcall net_ns_init+0x0/0x180 returned 0 after 3906 usecs
calling  cpufreq_tsc+0x0/0x40 @ 1
initcall cpufreq_tsc+0x0/0x40 returned 0 after 0 usecs
calling  init_smp_flush+0x0/0x80 @ 1
initcall init_smp_flush+0x0/0x80 returned 0 after 0 usecs
calling  print_banner+0x0/0x10 @ 1
Booting paravirtualized kernel on bare hardware
initcall print_banner+0x0/0x10 returned 0 after 3906 usecs
calling  sysctl_init+0x0/0x40 @ 1
initcall sysctl_init+0x0/0x40 returned 0 after 0 usecs
calling  ksysfs_init+0x0/0xc0 @ 1
initcall ksysfs_init+0x0/0xc0 returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0x20 @ 1
initcall init_jiffies_clocksource+0x0/0x20 returned 0 after 0 usecs
calling  pm_init+0x0/0x40 @ 1
initcall pm_init+0x0/0x40 returned 0 after 0 usecs

--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

# head: 5cf7b67e
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.27
# Thu Oct 23 14:54:59 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
# CONFIG_BOOTPARAM_SUPPORT is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
# CONFIG_BROKEN_BOOT_ALLOWED4 is not set
# CONFIG_BROKEN_BOOT_EUROPE is not set
# CONFIG_BROKEN_BOOT_TITAN is not set
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_NS is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_IBS is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP_SUPPORT=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_UP_WANTED_1 is not set
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_XEN=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=32
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_MEMTEST=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=128
CONFIG_X86_INTERNODE_CACHE_BYTES=128
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_64=y
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_AMD_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_WMI=y
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_DEBUG_FUNC_TRACE=y
CONFIG_ACPI_EC=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_HOTPLUG_MEMORY=m
CONFIG_ACPI_SBS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
CONFIG_DMAR_GFX_WA=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_INTR_REMAP=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
CONFIG_PCI_DEBUG=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA_DEBUG=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE=m
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
CONFIG_NETLABEL=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m
CONFIG_IP_DCCP_ACKVEC=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=m
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=m
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=m
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_ECONET=y
CONFIG_ECONET_AUNUDP=y
# CONFIG_ECONET_NATIVE is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFQ=m
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_TCPPROBE=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
# CONFIG_ACTISYS_DONGLE is not set
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
# CONFIG_OLD_BELKIN_DONGLE is not set
# CONFIG_ACT200L_DONGLE is not set
CONFIG_KINGSUN_DONGLE=y
# CONFIG_KSDAZZLE_DONGLE is not set
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=m
CONFIG_SMC_IRCC_FIR=y
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=y
CONFIG_BT=y
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=y
# CONFIG_BT_HCIVHCI is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
# CONFIG_PHONET is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_UB=m
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
CONFIG_EEPROM_93CX6=m
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=m
CONFIG_ACER_WMI=y
CONFIG_ASUS_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_HP_WMI=y
# CONFIG_MSI_LAPTOP is not set
CONFIG_COMPAL_LAPTOP=m
# CONFIG_SONY_LAPTOP is not set
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_BAY=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_INTEL_MENLOW=m
# CONFIG_EEEPC_LAPTOP is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_SGI_XP is not set
# CONFIG_HP_ILO is not set
CONFIG_SGI_GRU=m
CONFIG_SGI_GRU_DEBUG=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_ENCLOSURE is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_BLK_DEV_3W_XXXX_RAID=m
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_DPT_I2O=m
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=m
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=m
CONFIG_SCSI_DMX3191D=m
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=y
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_IPS=y
# CONFIG_SCSI_INITIO is not set
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_PPA=m
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_IZIP_EPP16=y
CONFIG_SCSI_IZIP_SLOW_CTR=y
CONFIG_SCSI_STEX=y
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=y
CONFIG_SCSI_IPR_TRACE=y
# CONFIG_SCSI_IPR_DUMP is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
CONFIG_SCSI_QLA_ISCSI=y
CONFIG_SCSI_LPFC=y
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_SRP=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=y
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SX4=m
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_CMD640_PCI=y
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
# CONFIG_PATA_CS5530 is not set
CONFIG_PATA_CYPRESS=y
CONFIG_PATA_EFAR=m
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=y
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT821X=y
CONFIG_PATA_IT8213=y
CONFIG_PATA_JMICRON=m
CONFIG_PATA_TRIFLEX=y
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_NS87415=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RZ1000=y
CONFIG_PATA_SC1200=y
# CONFIG_PATA_SERVERWORKS is not set
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
# CONFIG_PATA_VIA is not set
CONFIG_PATA_WINBOND=m
CONFIG_PATA_SCH=m
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
# CONFIG_DM_MIRROR is not set
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
# CONFIG_IEEE1394 is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
# CONFIG_I2O_SCSI is not set
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=m
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
# CONFIG_ARCNET_1051 is not set
CONFIG_ARCNET_RAW=m
CONFIG_ARCNET_CAP=m
CONFIG_ARCNET_COM90xx=y
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=m
CONFIG_ARCNET_COM20020_PCI=m
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
# CONFIG_REALTEK_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=m
# CONFIG_SUNGEM is not set
CONFIG_CASSINI=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
# CONFIG_NET_TULIP is not set
CONFIG_HP100=y
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=y
# CONFIG_AMD8111_ETH is not set
CONFIG_ADAPTEC_STARFIRE=y
# CONFIG_B44 is not set
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=y
CONFIG_FEALNX=m
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=m
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
# CONFIG_R6040 is not set
CONFIG_SIS900=m
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
CONFIG_NET_POCKET=y
CONFIG_ATP=y
# CONFIG_DE600 is not set
# CONFIG_DE620 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=y
CONFIG_IP1000=y
CONFIG_IGB=m
CONFIG_IGB_LRO=y
# CONFIG_NS83820 is not set
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
CONFIG_BNX2=y
CONFIG_QLA3XXX=m
# CONFIG_ATL1 is not set
CONFIG_ATL1E=m
CONFIG_JME=m
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
CONFIG_STRIP=m
# CONFIG_WLAN_80211 is not set
# CONFIG_IWLWIFI_LEDS is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=m
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_HSO=y
CONFIG_WAN=y
# CONFIG_HDLC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=y
CONFIG_ATM_LANAI=y
CONFIG_ATM_ENI=y
CONFIG_ATM_ENI_DEBUG=y
CONFIG_ATM_ENI_TUNE_BURST=y
CONFIG_ATM_ENI_BURST_TX_16W=y
# CONFIG_ATM_ENI_BURST_TX_8W is not set
CONFIG_ATM_ENI_BURST_TX_4W=y
CONFIG_ATM_ENI_BURST_TX_2W=y
# CONFIG_ATM_ENI_BURST_RX_16W is not set
CONFIG_ATM_ENI_BURST_RX_8W=y
CONFIG_ATM_ENI_BURST_RX_4W=y
CONFIG_ATM_ENI_BURST_RX_2W=y
CONFIG_ATM_FIRESTREAM=y
CONFIG_ATM_ZATM=m
# CONFIG_ATM_ZATM_DEBUG is not set
# CONFIG_ATM_IDT77252 is not set
CONFIG_ATM_AMBASSADOR=y
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=y
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=m
# CONFIG_ATM_IA_DEBUG is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=m
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
CONFIG_PHONE=m

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y
CONFIG_XEN_KBDDEV_FRONTEND=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_STOWAWAY=m
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE=m
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_PRINTER is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
CONFIG_RTC=m
CONFIG_GEN_RTC=y
CONFIG_GEN_RTC_X=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=m
CONFIG_MWAVE=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=m
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_SIMTEC=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=m
# CONFIG_AT24 is not set
# CONFIG_SENSORS_EEPROM is not set
CONFIG_SENSORS_PCA9539=m
CONFIG_SENSORS_PCF8591=m
# CONFIG_TPS65010 is not set
CONFIG_SENSORS_MAX6875=y
CONFIG_SENSORS_TSL2550=m
CONFIG_I2C_DEBUG_CORE=y
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_I2C_DEBUG_CHIP=y
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set

#
# SPI GPIO expanders:
#
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHER=y
CONFIG_SENSORS_FSCPOS=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_HDAPS=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_HWMON_DEBUG_CHIP=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=m
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_60XX_WDT=m
CONFIG_SBC8360_WDT=y
CONFIG_CPU5_WDT=y
# CONFIG_SMSC37B787_WDT is not set
CONFIG_W83627HF_WDT=m
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=m
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=y
# CONFIG_MFD_TMIO is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=m
CONFIG_DRM=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_I810=m
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=m
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=m
CONFIG_FB_ARC=m
CONFIG_FB_UVESA=m
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
# CONFIG_FB_HGA_ACCEL is not set
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
CONFIG_FB_INTEL=m
CONFIG_FB_INTEL_DEBUG=y
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_MATROX_MULTIHEAD=y
CONFIG_FB_ATY128=m
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_TRIDENT_ACCEL=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
# CONFIG_FB_GEODE_GX is not set
# CONFIG_FB_GEODE_GX1 is not set
CONFIG_FB_SM501=m
CONFIG_XEN_FBDEV_FRONTEND=m
CONFIG_FB_METRONOME=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CORGI=y
CONFIG_BACKLIGHT_PROGEAR=y
# CONFIG_BACKLIGHT_CARILLO_RANCH is not set
CONFIG_BACKLIGHT_MBP_NVIDIA=y

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
CONFIG_HID_DEBUG=y
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=y

#
# Special HID drivers
#
CONFIG_HID_COMPAT=y
CONFIG_HID_APPLE=m
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1760_PCI is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_ONETOUCH=y
# CONFIG_USB_STORAGE_KARMA is not set
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP2101=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_TI=m
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=y
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_PHIDGET=m
CONFIG_USB_PHIDGETKIT=m
# CONFIG_USB_PHIDGETMOTORCONTROL is not set
CONFIG_USB_PHIDGETSERVO=m
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=m
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_VST=m
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
CONFIG_INFINIBAND=m
# CONFIG_INFINIBAND_USER_MAD is not set
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_IPATH is not set
CONFIG_INFINIBAND_AMSO1100=m
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
# CONFIG_MLX4_INFINIBAND is not set
CONFIG_INFINIBAND_NES=m
CONFIG_INFINIBAND_NES_DEBUG=y
# CONFIG_INFINIBAND_IPOIB is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_E752X=m
# CONFIG_EDAC_I82975X is not set
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
# CONFIG_UIO is not set
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4DEV_COMPAT=y
# CONFIG_EXT4_FS_XATTR is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_OCFS2_COMPAT_JBD is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=m

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
CONFIG_ADFS_FS=m
CONFIG_ADFS_FS_RW=y
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=m
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
# CONFIG_NFS_V3 is not set
CONFIG_NFS_V4=y
CONFIG_NFSD=y
# CONFIG_NFSD_V3 is not set
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_XPRT_RDMA=m
# CONFIG_SUNRPC_REGISTER_V4 is not set
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=y
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG2=y
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
# CONFIG_ACORN_PARTITION_ICS is not set
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
# CONFIG_ACORN_PARTITION_RISCIX is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ALLOW_WARNINGS=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_DETECT_SOFTLOCKUP is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_KPROBES_SANITY_TEST=y
CONFIG_BACKTRACE_SELF_TEST=y
# CONFIG_LKDTM is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y

#
# Tracers
#
CONFIG_FUNCTION_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_BOOT_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_PRINTK_DEBUG=y
CONFIG_SAMPLES=y
CONFIG_SAMPLE_MARKERS=m
# CONFIG_SAMPLE_TRACEPOINTS is not set
CONFIG_SAMPLE_KOBJECT=y
CONFIG_SAMPLE_KPROBES=m
CONFIG_SAMPLE_KRETPROBES=m
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_IOMMU_DEBUG=y
CONFIG_IOMMU_LEAK=y
CONFIG_MMIOTRACE_HOOKS=y
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_TRACE is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_FORCE_SUCCESSFUL_BUILD=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_64=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y

--zYM0uCDKw75PZbzx--
