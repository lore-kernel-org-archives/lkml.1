Return-Path: <linux-kernel-owner+w=401wt.eu-S1763331AbYD3MMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763331AbYD3MMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759388AbYD3MMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:12:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:57217 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758587AbYD3MML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:12:11 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1+Oh1tfTnOO6zwFHg60khTJ+fxShhvoXun49KHUh4
	N2C75hPhZGGARk
Date: Wed, 30 Apr 2008 14:12:02 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: snakebyte@gmx.de
Subject: Oops with strace_test
Message-ID: <20080430121202.GD18314@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.25 (x86_64)
X-Uptime: 14:08:40 up 22:08,  1 user,  load average: 0.09, 0.11, 0.18
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

running the strace_test from ltp 20080229 (ltp.sf.net) gives me
two different oopses, so far i was not able to pinpoint to a specific
testcase (propably because the strace uses the rng to decided what fails
and what not) one oops is in iret_exc(), the other in __copy_from_user_ll()
The oopses dont happen with 2.6.24 so this appears to be a regression, i am starting
a git-bisect, but this might take some time

Here is a full dmesg with the oopses happening, it usually takes less than a minute
until they trigger, strangely they dont appear in /var/log/messages, only on the netconsole

[    0.000000] Linux version 2.6.25-06679-g0ff5ce7 (root@whiterabbit) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #30 PREEMPT Wed Apr 30 14:50:45 CEST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000000fffc000 (usable)
[    0.000000]  BIOS-e820: 000000000fffc000 - 000000000ffff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000000ffff000 - 0000000010000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
[    0.000000] x86: PAT support disabled.
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->    65532
[    0.000000]   HighMem     65532 ->    65532
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->    65532
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F5EB0, 0014 (r0 ASUS  )
[    0.000000] ACPI: RSDT 0FFFC000, 002C (r1 ASUS   MED_2001 30303031 MSFT 31313031)
[    0.000000] ACPI: FACP 0FFFC080, 0074 (r1 ASUS   MED_2001 30303031 MSFT 31313031)
[    0.000000] ACPI: DSDT 0FFFC100, 2253 (r1   ASUS MED_2001     1000 MSFT  100000B)
[    0.000000] ACPI: FACS 0FFFF000, 0040
[    0.000000] ACPI: BOOT 0FFFC040, 0028 (r1 ASUS   MED_2001 30303031 MSFT 31313031)
[    0.000000] ACPI: PM-Timer IO Port: 0xe408
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 10000000:efff0000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65021
[    0.000000] Kernel command line: root=/dev/hda1 netconsole=4444@192.168.0.201/eth0,4444@192.168.0.50/00:16:17:D6:12:20
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] CPU 0 irqstacks, hard=c08d3000 soft=c08d2000
[    0.000000] PID hash table entries: 1024 (order: 10, 4096 bytes)
[    0.000000] Detected 902.072 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000999] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.000999] ... MAX_LOCK_DEPTH:          48
[    0.000999] ... MAX_LOCKDEP_KEYS:        2048
[    0.000999] ... CLASSHASH_SIZE:           1024
[    0.000999] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.000999] ... MAX_LOCKDEP_CHAINS:      16384
[    0.000999] ... CHAINHASH_SIZE:          8192
[    0.000999]  memory used by lock dependency info: 1024 kB
[    0.000999]  per task-struct memory footprint: 2688 bytes
[    0.000999] ------------------------
[    0.000999] | Locking API testsuite:
[    0.000999] ----------------------------------------------------------------------------
[    0.000999]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000999]   --------------------------------------------------------------------------
[    0.000999]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]   --------------------------------------------------------------------------
[    0.000999]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000999]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000999]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000999]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000999]   --------------------------------------------------------------------------
[    0.000999]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000999]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000999]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000999]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000999]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000999]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000999]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000999]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000999]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000999]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq read-recursion/123:  ok  |
[    0.000999]       soft-irq read-recursion/123:  ok  |
[    0.000999]       hard-irq read-recursion/132:  ok  |
[    0.000999]       soft-irq read-recursion/132:  ok  |
[    0.000999]       hard-irq read-recursion/213:  ok  |
[    0.000999]       soft-irq read-recursion/213:  ok  |
[    0.000999]       hard-irq read-recursion/231:  ok  |
[    0.000999]       soft-irq read-recursion/231:  ok  |
[    0.000999]       hard-irq read-recursion/312:  ok  |
[    0.000999]       soft-irq read-recursion/312:  ok  |
[    0.000999]       hard-irq read-recursion/321:  ok  |
[    0.000999]       soft-irq read-recursion/321:  ok  |
[    0.000999] -------------------------------------------------------
[    0.000999] Good, all 218 testcases passed! |
[    0.000999] ---------------------------------
[    0.000999] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000999] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000999] Memory: 248016k/262128k available (5613k kernel code, 13584k reserved, 2069k data, 308k init, 0k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff9a000 - 0xfffff000   ( 404 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xd0800000 - 0xff7fe000   ( 751 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xcfffc000   ( 255 MB)
[    0.000999]       .init : 0xc0882000 - 0xc08cf000   ( 308 kB)
[    0.000999]       .data : 0xc067b542 - 0xc0880a28   (2069 kB)
[    0.000999]       .text : 0xc0100000 - 0xc067b542   (5613 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.061002] Calibrating delay using timer specific routine.. 1808.63 BogoMIPS (lpj=904315)
[    0.061394] Mount-cache hash table entries: 512
[    0.064450] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.064600] CPU: L2 cache: 256K
[    0.064690] Intel machine check architecture supported.
[    0.064786] Intel machine check reporting enabled on CPU#0.
[    0.064907] Compat vDSO mapped to ffffe000.
[    0.065021] CPU: Intel Pentium III (Coppermine) stepping 06
[    0.065274] Checking 'hlt' instruction... OK.
[    0.070309] debug: unmapping init memory c0882000..c0882000
[    0.070411] ACPI: Core revision 20070126
[    0.093243] ACPI: setting ELCR to 0200 (from 1c00)
[    0.098091] net_namespace: 728 bytes
[    0.100621] NET: Registered protocol family 16
[    0.102874] No dock devices found.
[    0.105465] ACPI: bus type pci registered
[    0.108344] PCI: PCI BIOS revision 2.10 entry at 0xf0900, last bus=1
[    0.108452] PCI: Using configuration type 1 for base access
[    0.108548] Setting up standard PCI resources
[    0.201778] ACPI: Interpreter enabled
[    0.201890] ACPI: (supports S0 S1 S5)
[    0.202396] ACPI: Using PIC for interrupt routing
[    0.266788] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.269409] pci 0000:00:04.4: quirk: region e400-e4ff claimed by vt82c586 ACPI
[    0.269983] pci 0000:00:04.4: quirk: region e800-e80f claimed by vt82c686 SMB
[    0.300323] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.301731] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.303430] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.304865] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
[    0.307601] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.308238] pnp: PnP ACPI init
[    0.308455] ACPI: bus type pnp registered
[    0.346356] pnp: PnP ACPI: found 13 devices
[    0.346469] ACPI: ACPI bus type pnp unregistered
[    0.460452]  [<c0146bed>] ? trace_hardirqs_on+0xbd/0x140
[    0.460650]  [<c08829f0>] ? kernel_init+0x0/0x200
[    0.460825]  [<c08829f0>] ? kernel_init+0x0/0x200
[    0.461284]  [<c010499f>] kernel_thread_helper+0x7/0x18
[    0.461427]  =======================
[    0.470940] Testing a backtrace from irq context.
[    0.471041] The following trace is a kernel self test and not a bug!
[    0.471143] Pid: 0, comm: swapper Not tainted 2.6.25-06679-g0ff5ce7 #30
[    0.471244]  [<c0153fd3>] backtrace_test_timer+0x23/0x30
[    0.471402]  [<c012e909>] run_timer_softirq+0x149/0x1b0
[    0.471549]  [<c0153fb0>] ? backtrace_test_timer+0x0/0x30
[    0.471727]  [<c012424c>] ? free_task+0x2c/0x30
[    0.471911]  [<c0153fb0>] ? backtrace_test_timer+0x0/0x30
[    0.472064]  [<c012adf2>] __do_softirq+0x62/0xc0
[    0.472209]  [<c010675a>] do_softirq+0x8a/0xd0
[    0.472352]  [<c01561f0>] ? handle_level_irq+0x0/0xe0
[    0.472532]  [<c012b015>] irq_exit+0x85/0x90
[    0.472667]  [<c010683a>] do_IRQ+0x9a/0x100
[    0.472800]  [<c0146bed>] ? trace_hardirqs_on+0xbd/0x140
[    0.473066]  [<c0102580>] ? default_idle+0x0/0x50
[    0.473243]  [<c01047fa>] common_interrupt+0x2e/0x34
[    0.473380]  [<c0102580>] ? default_idle+0x0/0x50
[    0.473555]  [<c0140000>] ? sysfs_override_clocksource+0x60/0x100
[    0.473737]  [<c01025b8>] ? default_idle+0x38/0x50
[    0.473938]  [<c0102780>] cpu_idle+0x50/0xc0
[    0.474073]  [<c066cc5c>] rest_init+0x5c/0x60
[    0.474209]  [<c0882965>] start_kernel+0x245/0x2d0
[    0.474347]  [<c0882410>] ? unknown_bootoption+0x0/0x210
[    0.474525]  [<c08822a8>] i386_start_kernel+0x8/0x10
[    0.474663]  =======================
[    0.474782] ====[ end of backtrace testing ]====
[    0.476096] Total HugeTLB memory allocated, 0
[    0.543939] VFS: Disk quotas dquot_6.5.1
[    0.545218] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.550306] DLM (built Apr 30 2008 13:09:20) installed
[    0.583246] NTFS driver 2.1.29 [Flags: R/W].
[    0.590864] JFS: nTxBlock = 1938, nTxLock = 15509
[    0.598004] OCFS2 1.5.0
[    0.600589] ocfs2: Registered cluster interface o2cb
[    0.601562] ocfs2: Registered cluster interface user
[    0.601668] OCFS2 Node Manager 1.5.0
[    0.602653] sysfs: duplicate filename 'o2cb' can not be created
[    0.602785] ------------[ cut here ]------------
[    0.602877] WARNING: at fs/sysfs/dir.c:425 sysfs_add_one+0x7f/0xa0()
[    0.602927] Modules linked in:
[    0.603056] Pid: 1, comm: swapper Not tainted 2.6.25-06679-g0ff5ce7 #30
[    0.603159]  [<c0125d54>] warn_on_slowpath+0x54/0x70
[    0.603382]  [<c01474c5>] ? __lock_acquire+0x2b5/0xd70
[    0.603565]  [<c0146a5b>] ? mark_held_locks+0x4b/0x80
[    0.603763]  [<c06785d5>] ? mutex_trylock+0xc5/0x140
[    0.604069]  [<c0146bed>] ? trace_hardirqs_on+0xbd/0x140
[    0.604249]  [<c012724b>] ? printk+0x1b/0x20
[    0.604425]  [<c01c313f>] sysfs_add_one+0x7f/0xa0
[    0.604562]  [<c01c3f8a>] sysfs_create_link+0x8a/0x110
[    0.604705]  [<c038653f>] o2cb_sys_init+0x2f/0x70
[    0.604925]  [<c089a745>] init_o2nm+0xa5/0xd0
[    0.605071]  [<c0882a83>] kernel_init+0x93/0x200
[    0.605219]  [<c0103e67>] ? restore_nocheck+0x12/0x15
[    0.605401]  [<c0146bed>] ? trace_hardirqs_on+0xbd/0x140
[    0.605579]  [<c08829f0>] ? kernel_init+0x0/0x200
[    0.605754]  [<c08829f0>] ? kernel_init+0x0/0x200
[    0.605924]  [<c010499f>] kernel_thread_helper+0x7/0x18
[    0.606068]  =======================
[    0.606337] ---[ end trace a7919e7f17c0a725 ]---
[    0.606611] OCFS2 DLM 1.5.0
[    0.609344] OCFS2 DLMFS 1.5.0
[    0.610174] OCFS2 User DLM kernel interface loaded
[    0.610305] msgmni has been set to 484 for ipc namespace c0850aa0
[    0.612392] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.612540] io scheduler noop registered
[    0.613782] io scheduler cfq registered (default)
[    0.613940] PCI: VIA PCI bridge detected.Disabling DAC.
[    0.614047] pci 0000:00:04.0: Disabling VIA external APIC routing
[    0.615730] input: Power Button (FF) as /class/input/input0
[    0.615843] ACPI: Power Button (FF) [PWRF]
[    0.616586] input: Power Button (CM) as /class/input/input1
[    0.616692] ACPI: Power Button (CM) [PWRB]
[    0.619335] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    0.620017] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.620137] ACPI: Processor [CPU0] (supports 16 throttling states)
[    0.919846] Linux agpgart interface v0.103
[    0.921170] agpgart: Detected VIA Apollo Pro 133 chipset
[    0.924520] agpgart: AGP aperture is 32M @ 0xfc000000
[    0.925143] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    0.925284] Hangcheck: Using get_cycles().
[    0.925379] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[    0.926578] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.927673] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.931710] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.933549] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.936188] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
[    0.961463] parport_pc: VIA parallel port: io=0x378, irq=7
[    0.966367] Floppy drive(s): fd0 is 1.44M
[    0.976986] FDC 0 is a post-1991 82077
[    0.987275] brd: module loaded
[    0.991932] loop: module loaded
[    0.992195] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[    0.992297] 8139cp 0000:00:09.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
[    0.992434] 8139cp 0000:00:09.0: Try the "8139too" driver instead.
[    0.993116] 8139too Fast Ethernet driver 0.9.28
[    0.997570] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 12
[    0.997691] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKD] -> GSI 12 (level, low) -> IRQ 12
[    1.000444] eth0: RealTek RTL8139 at 0xb400, 00:e0:7d:b5:7e:1b, IRQ 12
[    1.001092] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[    1.002946] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[    1.003663] netconsole: local port 4444
[    1.003755] netconsole: local IP 192.168.0.201
[    1.003846] netconsole: interface eth0
[    1.003932] netconsole: remote port 4444
[    1.004021] netconsole: remote IP 192.168.0.50
[    1.004152] netconsole: remote ethernet address 00:16:17:d6:12:20
[    1.004258] netconsole: device eth0 not up yet, forcing it
[    1.004460] eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
[    1.004740] netconsole: carrier detect appears untrustworthy, waiting 4 seconds
[    4.772412] console [netcon0] enabled
[    4.816805] netconsole: network logging started
[    4.816924] Uniform Multi-Platform E-IDE driver
[    4.817058] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    4.819078] VP_IDE: IDE controller (0x1106:0x0571 rev 0x10) at  PCI slot 0000:00:04.1
[    4.819357] VP_IDE: not 100% native mode: will probe irqs later
[    4.819665] VP_IDE: VIA vt82c686a (rev 22) IDE UDMA66 controller on pci0000:00:04.1
[    4.819882]     ide0: BM-DMA at 0xd800-0xd807
[    4.820031]     ide1: BM-DMA at 0xd808-0xd80f
[    5.028626] hda: ST340823A, ATA DISK drive
[    5.333747] hda: UDMA/66 mode selected
[    5.745106] hdc: LITE-ON LTR-24102B, ATAPI CD/DVD-ROM drive
[    6.091541] hdd: SAMSUNG DVD-ROM SD-616T, ATAPI CD/DVD-ROM drive
[    6.117226] hdc: UDMA/33 mode selected
[    6.117554] hdd: UDMA/33 mode selected
[    6.117839] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    6.118128] ide1 at 0x170-0x177,0x376 on irq 15
[    6.120704] ide_generic: I/O resource 0x1F0-0x1F7 not free.
[    6.120841] ide_generic: I/O resource 0x170-0x177 not free.
[    6.121581] hda: max request size: 128KiB
[    6.121702] hda: 78165360 sectors (40020 MB) w/1024KiB Cache, CHS=65535/16/63
[    6.121970] hda: cache flushes not supported
[    6.122281]  hda: hda1 hda2 < hda5 >
[    6.141742] hdc: ATAPI 40X CD-ROM CD-R/RW drive, 2048kB Cache
[    6.142209] Uniform CD-ROM driver Revision: 3.20
[    6.144836] hdd: ATAPI 48X DVD-ROM drive, 512kB Cache
[    6.149677] Driver 'sd' needs updating - please use bus_type methods
[    6.150259] Driver 'sr' needs updating - please use bus_type methods
[    6.156124] USB Universal Host Controller Interface driver v3.0
[    6.161192] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[    6.161371] ACPI: PCI Interrupt 0000:00:04.2[D] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
[    6.161710] uhci_hcd 0000:00:04.2: UHCI Host Controller
[    6.163221] uhci_hcd 0000:00:04.2: new USB bus registered, assigned bus number 1
[    6.163484] uhci_hcd 0000:00:04.2: irq 10, io base 0x0000d400
[    6.166200] usb usb1: configuration #1 chosen from 1 choice
[    6.166851] hub 1-0:1.0: USB hub found
[    6.167098] hub 1-0:1.0: 2 ports detected
[    6.243028] ACPI: PCI Interrupt 0000:00:04.3[D] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
[    6.243391] uhci_hcd 0000:00:04.3: UHCI Host Controller
[    6.244579] uhci_hcd 0000:00:04.3: new USB bus registered, assigned bus number 2
[    6.244835] uhci_hcd 0000:00:04.3: irq 10, io base 0x0000d000
[    6.246509] usb usb2: configuration #1 chosen from 1 choice
[    6.247150] hub 2-0:1.0: USB hub found
[    6.247329] hub 2-0:1.0: 2 ports detected
[    6.296721] usbcore: registered new interface driver usblp
[    6.296878] Initializing USB Mass Storage driver...
[    6.297435] usbcore: registered new interface driver usb-storage
[    6.297563] USB Mass Storage support registered.
[    6.298568] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    6.298691] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    6.299837] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.301408] mice: PS/2 mouse device common for all mice
[    6.332348] input: AT Translated Set 2 keyboard as /class/input/input2
[    6.345666] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    6.345864] rtc0: alarms up to one year
[    6.347805] cpuidle: using governor ladder
[    6.350385] cpuidle: using governor menu
[    6.351386] usbcore: registered new interface driver usbhid
[    6.351534] usbhid: v2.6:USB HID core driver
[    6.352211] Advanced Linux Sound Architecture Driver Version 1.0.16.
[    6.355656] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LNKD] -> GSI 12 (level, low) -> IRQ 12
[    6.357164] Marking TSC unstable due to: TSC halts in idle.
[    7.661013] ALSA device list:
[    7.661148]   #0: Ensoniq AudioPCI ENS1371 at 0xb800, irq 12
[    7.662359] Netfilter messages via NETLINK v0.30.
[    7.665798] IPv4 over IPv4 tunneling driver
[    7.668033] GRE over IPv4 tunneling driver
[    7.670729] ip_tables: (C) 2000-2006 Netfilter Core Team
[    7.671056] TCP bic registered
[    7.671162] TCP cubic registered
[    7.671282] TCP westwood registered
[    7.671387] TCP htcp registered
[    7.675235] NET: Registered protocol family 10
[    7.680441] lo: Disabled Privacy Extensions
[    7.684069] tunl0: Disabled Privacy Extensions
[    7.689633] Mobile IPv6
[    7.689839] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    7.690226] IPv6 over IPv4 tunneling driver
[    7.693005] sit0: Disabled Privacy Extensions
[    7.697863] ip6tnl0: Disabled Privacy Extensions
[    7.700060] NET: Registered protocol family 17
[    7.700263] NET: Registered protocol family 15
[    7.701585] Bridge firewalling registered
[    7.702417] NET: Registered protocol family 4
[    7.707414] NET: Registered protocol family 5
[    7.722137] RPC: Registered udp transport module.
[    7.722339] RPC: Registered tcp transport module.
[    7.722552] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    7.722672] All bugs added by David S. Miller <davem@redhat.com>
[    7.735671] CCID: Registered CCID 3 (TCP-Friendly Rate Control)
[    7.737044] CCID: Registered CCID 2 (TCP-like)
[    7.740840] SCTP: Hash tables configured (established 2048 bind 1820)
[    7.754300] TIPC: Activated (version 1.6.3 compiled Apr 30 2008 14:42:54)
[    7.759043] NET: Registered protocol family 30
[    7.759186] TIPC: Started in single node mode
[    7.759320] Using IPI Shortcut mode
[    7.761426] rtc_cmos 00:05: setting system clock to 2008-04-30 12:57:21 UTC (1209560241)
[    7.815862] kjournald starting.  Commit interval 5 seconds
[    7.816078] EXT3-fs: mounted filesystem with ordered data mode.
[    7.816345] VFS: Mounted root (ext3 filesystem) readonly.
[    7.816724] debug: unmapping init memory c0882000..c08cf000
[    7.817014] Write protecting the kernel text: 5616k
[    7.817127] Testing CPA: Reverting c0100000-c067c000
[    7.817366] Testing CPA: write protecting again
[    7.817679] Write protecting the kernel read-only data: 1744k
[    7.817801] Testing CPA: undo c067c000-c0830000
[    7.817958] Testing CPA: write protecting again
[  194.539607] BUG: unable to handle kernel NULL pointer dereference at 00000000
[  194.539919] IP: [<c03eb611>] __copy_from_user_ll+0x61/0xe0
[  194.540150] Oops: 0003 [#1] PREEMPT DEBUG_PAGEALLOC
[  194.540432] Modules linked in: nfsd exportfs
[  194.540788] 
[  194.540949] Pid: 7340, comm: strace Tainted: G        W (2.6.25-06679-g0ff5ce7 #30)
[  194.541105] EIP: 0060:[<c03eb611>] EFLAGS: 00010216 CPU: 0
[  194.541187] EIP is at __copy_from_user_ll+0x61/0xe0
[  194.541187] EAX: 00000000 EBX: 00000073 ECX: 00000200 EDX: 00000000
[  194.541187] ESI: 00000073 EDI: 00000000 EBP: cbf23e98 ESP: cbf23e90
[  194.541187]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  194.541187] Process strace (pid: 7340, ti=cbf23000 task=caa5af40 task.ti=cbf23000)
[  194.541187] Stack: 00000000 caa5af40 cbf23f1c c010a599 00000003 00000000 00000000 cbf23ed4 
[  194.541187]        c8001dd8 00000046 00000002 00000001 c0138f7a 00000002 00000000 cbf37694 
[  194.541187]        caa5af40 00000046 00000002 00000000 cbf37694 caa5af40 00000002 00000000 
[  194.541187] Call Trace:
[  194.541187]  [<c010a599>] ? restore_i387+0x89/0x190
[  194.541187]  [<c0138f7a>] ? remove_wait_queue+0x1a/0x40
[  194.541187]  [<c0103067>] ? restore_sigcontext+0x1c7/0x1f0
[  194.541187]  [<c01032e9>] ? sys_sigreturn+0xe9/0x190
[  194.541187]  [<c012fdd8>] ? sys_rt_sigaction+0x68/0x90
[  194.541187]  [<c0103d7d>] ? sysenter_past_esp+0x6a/0xb1
[  194.541187]  =======================
[  194.541187] Code: c1 e9 02 83 e0 03 f3 a5 89 c1 f3 a4 8b 34 24 89 c8 8b 7c 24 04 89 ec 5d c3 90 8b 46 20 83 f9 43 76 04 8b 46 40 90 8b 06 8b 56 04 <89> 07 89 57 04 8b 46 08 8b 56 0c 89 47 08 89 57 0c 8b 46 10 8b 
[  194.541187] EIP: [<c03eb611>] __copy_from_user_ll+0x61/0xe0 SS:ESP 0068:cbf23e90
[  194.594334] ---[ end trace a7919e7f17c0a725 ]---
[  204.592336] BUG: unable to handle kernel NULL pointer dereference at 00000000
[  204.592678] IP: [<c03eb611>] __copy_from_user_ll+0x61/0xe0
[  204.592880] *pde = 0a94d067 *pte = 09ffb065 
[  204.593140] Oops: 0003 [#2] PREEMPT DEBUG_PAGEALLOC
[  204.593423] Modules linked in: nfsd exportfs
[  204.593780] 
[  204.593941] Pid: 7638, comm: strace Tainted: G      D W (2.6.25-06679-g0ff5ce7 #30)
[  204.594097] EIP: 0060:[<c03eb611>] EFLAGS: 00010216 CPU: 0
[  204.594215] EIP is at __copy_from_user_ll+0x61/0xe0
[  204.594328] EAX: 00000000 EBX: 00000074 ECX: 00000200 EDX: 00000000
[  204.594506] ESI: 00000074 EDI: 00000000 EBP: cc82de98 ESP: cc82de90
[  204.594625]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  204.594645] Process strace (pid: 7638, ti=cc82d000 task=ca9bbf00 task.ti=cc82d000)
[  204.594645] Stack: 00000000 ca9bbf00 cc82df1c c010a599 00000004 00000000 00000000 cc82ded4 
[  204.594645]        ca98acd8 00000046 00000002 00000001 c0138f7a 00000002 00000000 cbfceb94 
[  204.594645]        ca9bbf00 00000046 00000002 00000000 cbfceb94 ca9bbf00 00000002 00000000 
[  204.594645] Call Trace:
[  204.594645]  [<c010a599>] ? restore_i387+0x89/0x190
[  204.594645]  [<c0138f7a>] ? remove_wait_queue+0x1a/0x40
[  204.594645]  [<c0103067>] ? restore_sigcontext+0x1c7/0x1f0
[  204.594645]  [<c01032e9>] ? sys_sigreturn+0xe9/0x190
[  204.594645]  [<c012fdd8>] ? sys_rt_sigaction+0x68/0x90
[  204.594645]  [<c0103d7d>] ? sysenter_past_esp+0x6a/0xb1
[  204.594645]  =======================
[  204.594645] Code: c1 e9 02 83 e0 03 f3 a5 89 c1 f3 a4 8b 34 24 89 c8 8b 7c 24 04 89 ec 5d c3 90 8b 46 20 83 f9 43 76 04 8b 46 40 90 8b 06 8b 56 04 <89> 07 89 57 04 8b 46 08 8b 56 0c 89 47 08 89 57 0c 8b 46 10 8b 
[  204.594645] EIP: [<c03eb611>] __copy_from_user_ll+0x61/0xe0 SS:ESP 0068:cc82de90
[  204.785891] ---[ end trace a7919e7f17c0a725 ]---
[  207.866195] BUG: unable to handle kernel NULL pointer dereference at 00000000
[  207.866555] IP: [<c067b1b5>] iret_exc+0x605/0x992
[  207.866753] *pde = 0aac3067 *pte = 00000000 
[  207.867013] Oops: 0002 [#3] PREEMPT DEBUG_PAGEALLOC
[  207.867296] Modules linked in: nfsd exportfs
[  207.867653] 
[  207.867815] Pid: 7897, comm: strace Tainted: G      D W (2.6.25-06679-g0ff5ce7 #30)
[  207.867973] EIP: 0060:[<c067b1b5>] EFLAGS: 00010246 CPU: 0
[  207.868091] EIP is at iret_exc+0x605/0x992
[  207.868201] EAX: 00000000 EBX: 00000077 ECX: 00000200 EDX: 00000077
[  207.868379] ESI: 00000077 EDI: 00000000 EBP: ccbaae98 ESP: ccbaae88
[  207.868498]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  207.868521] Process strace (pid: 7897, ti=ccbaa000 task=cbf7cec0 task.ti=ccbaa000)
[  207.868521] Stack: 00000077 00000200 00000000 cbf7cec0 ccbaaf1c c010a599 00000007 00000000 
[  207.868521]        00000000 ccbaaed4 c8000ef8 00000046 00000002 00000001 c0138f7a 00000002 
[  207.868521]        00000000 cbf57c14 cbf7cec0 00000046 00000002 00000000 cbf57c14 cbf7cec0 
[  207.868521] Call Trace:
[  207.868521]  [<c010a599>] ? restore_i387+0x89/0x190
[  207.868521]  [<c0138f7a>] ? remove_wait_queue+0x1a/0x40
[  207.868521]  [<c0103067>] ? restore_sigcontext+0x1c7/0x1f0
[  207.868521]  [<c01032e9>] ? sys_sigreturn+0xe9/0x190
[  207.868521]  [<c012fdd8>] ? sys_rt_sigaction+0x68/0x90
[  207.868521]  [<c0103d7d>] ? sysenter_past_esp+0x6a/0xb1
[  207.868521]  =======================
[  207.868521] Code: ff 01 c1 e9 00 04 d7 ff 8d 0c 88 e9 f8 03 d7 ff 01 c1 eb 03 8d 0c 88 51 50 31 c0 f3 aa 58 59 e9 44 04 d7 ff 8d 0c 88 51 50 31 c0 <f3> aa 58 59 e9 c9 04 d7 ff 01 c1 e9 0d 05 d7 ff 8d 0c 88 e9 05 
[  207.868521] EIP: [<c067b1b5>] iret_exc+0x605/0x992 SS:ESP 0068:ccbaae88
[  208.002448] ---[ end trace a7919e7f17c0a725 ]---
[  208.991482] strace[8028]: segfault at b7efec50 ip b7efec50 sp bf812234 error 4 in libc-2.7.so[b7efe000+1000]
[  209.219272] strace[8057]: segfault at 3000 ip 00003000 sp bfd50b44 error 4 in strace[8048000+2f000]
[  210.059636] BUG: unable to handle kernel NULL pointer dereference at 00000000
[  210.059940] IP: [<c03eb611>] __copy_from_user_ll+0x61/0xe0
[  210.060178] *pde = 0bf14067 *pte = 0a3f8065 
[  210.060437] Oops: 0003 [#4] PREEMPT DEBUG_PAGEALLOC
[  210.060720] Modules linked in: nfsd exportfs
[  210.061077] 
[  210.061239] Pid: 8030, comm: strace Tainted: G      D W (2.6.25-06679-g0ff5ce7 #30)
[  210.061394] EIP: 0060:[<c03eb611>] EFLAGS: 00010216 CPU: 0
[  210.061513] EIP is at __copy_from_user_ll+0x61/0xe0
[  210.061626] EAX: 00000000 EBX: 00000073 ECX: 00000200 EDX: 00000000
[  210.061805] ESI: 00000073 EDI: 00000000 EBP: c8013e98 ESP: c8013e90
[  210.061925]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  210.062024] Process strace (pid: 8030, ti=c8013000 task=cbf25e80 task.ti=c8013000)
[  210.062024] Stack: 00000000 cbf25e80 c8013f1c c010a599 00000003 00000000 00000000 c8013ed4 
[  210.062024]        cbf84ef8 00000046 00000002 00000001 c0138f7a 00000002 00000000 cbffd014 
[  210.062024]        cbf25e80 00000046 00000002 00000000 cbffd014 cbf25e80 00000002 00000000 
[  210.062024] Call Trace:
[  210.062024]  [<c010a599>] ? restore_i387+0x89/0x190
[  210.062024]  [<c0138f7a>] ? remove_wait_queue+0x1a/0x40
[  210.062024]  [<c0103067>] ? restore_sigcontext+0x1c7/0x1f0
[  210.062024]  [<c01032e9>] ? sys_sigreturn+0xe9/0x190
[  210.062024]  [<c012fdd8>] ? sys_rt_sigaction+0x68/0x90
[  210.062024]  [<c0103d7d>] ? sysenter_past_esp+0x6a/0xb1
[  210.062024]  =======================
[  210.062024] Code: c1 e9 02 83 e0 03 f3 a5 89 c1 f3 a4 8b 34 24 89 c8 8b 7c 24 04 89 ec 5d c3 90 8b 46 20 83 f9 43 76 04 8b 46 40 90 8b 06 8b 56 04 <89> 07 89 57 04 8b 46 08 8b 56 0c 89 47 08 89 57 0c 8b 46 10 8b 
[  210.062024] EIP: [<c03eb611>] __copy_from_user_ll+0x61/0xe0 SS:ESP 0068:c8013e90
[  210.161884] ---[ end trace a7919e7f17c0a725 ]---
[  212.454385] strace[8214]: segfault at 8048c74 ip b8008130 sp bff17394 error 7
[  213.953755] BUG: unable to handle kernel NULL pointer dereference at 00000000
[  213.954104] IP: [<c067b1b5>] iret_exc+0x605/0x992
[  213.954301] *pde = 0a91c067 *pte = 00000000 
[  213.954561] Oops: 0002 [#5] PREEMPT DEBUG_PAGEALLOC
[  213.954857] Modules linked in: nfsd exportfs
[  213.955214] 
[  213.955375] Pid: 8249, comm: strace Tainted: G      D W (2.6.25-06679-g0ff5ce7 #30)
[  213.955532] EIP: 0060:[<c067b1b5>] EFLAGS: 00010246 CPU: 0
[  213.955648] EIP is at iret_exc+0x605/0x992
[  213.955758] EAX: 00000000 EBX: 00000071 ECX: 00000200 EDX: 00000071
[  213.955936] ESI: 00000071 EDI: 00000000 EBP: c8004e98 ESP: c8004e88
[  213.956055]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  213.956071] Process strace (pid: 8249, ti=c8004000 task=cbee1f80 task.ti=c8004000)
[  213.956071] Stack: 00000071 00000200 00000000 cbee1f80 c8004f1c c010a599 00000001 00000000 
[  213.956071]        00000000 c8004ed4 c801c678 00000046 00000002 00000001 c0138f7a 00000002 
[  213.956071]        00000000 cab18514 cbee1f80 00000046 00000002 00000000 cab18514 cbee1f80 
[  213.956071] Call Trace:
[  213.956071]  [<c010a599>] ? restore_i387+0x89/0x190
[  213.956071]  [<c0138f7a>] ? remove_wait_queue+0x1a/0x40
[  213.956071]  [<c0103067>] ? restore_sigcontext+0x1c7/0x1f0
[  213.956071]  [<c01032e9>] ? sys_sigreturn+0xe9/0x190
[  213.956071]  [<c012fdd8>] ? sys_rt_sigaction+0x68/0x90
[  213.956071]  [<c0103d7d>] ? sysenter_past_esp+0x6a/0xb1
[  213.956071]  =======================
[  213.956071] Code: ff 01 c1 e9 00 04 d7 ff 8d 0c 88 e9 f8 03 d7 ff 01 c1 eb 03 8d 0c 88 51 50 31 c0 f3 aa 58 59 e9 44 04 d7 ff 8d 0c 88 51 50 31 c0 <f3> aa 58 59 e9 c9 04 d7 ff 01 c1 e9 0d 05 d7 ff 8d 0c 88 e9 05 
[  213.956071] EIP: [<c067b1b5>] iret_exc+0x605/0x992 SS:ESP 0068:c8004e88
[  214.131649] ---[ end trace a7919e7f17c0a725 ]---


Greetings, Eric
