Return-Path: <linux-kernel-owner+w=401wt.eu-S1760984AbZLLJZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760984AbZLLJZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 04:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758855AbZLLJZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 04:25:45 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:57315 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbZLLJZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 04:25:41 -0500
X-Greylist: delayed 1883 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Dec 2009 04:25:40 EST
Date: Sat, 12 Dec 2009 10:54:19 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       sparclinux@vger.kernel.org
Subject: RCU detected CPU 0 stall after panic on sparc64
Message-ID: <alpine.SOC.1.00.0912121049030.26625@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried 2.6.32 git gaad3bf0 on a SMP sparc64 machine (Ultra Enterprise 
250). For some reason my disks were not found (not important in this 
bugreport) and this resulted in panic (cannnot mount root). However, the 
machine kept going and got the below messages (RCU detected CPU 0 stall 
(t=1000 jiffies)) from timer interrupts.

This seems to be like a bug in RCU vs panic.

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.30.0 2003/11/11 10:37'
[    0.000000] PROMLIB: Root node compatible: sun4u
[    0.000000] Linux version 2.6.32-05775-gaad3bf0 (mroos@laimi) (gcc version 4.4.2 (Debian 4.4.2-3) ) #3 SMP Sat Dec 12 01:18:48 EET 2009
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 08:00:20:b0:4e:f6
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /pci@1f,4000/ebus@1/se@14,400000:a
[    0.000000] PROM: Built device tree with 67951 bytes of memory.
[    0.000000] Top of RAM: 0x4febe000, Total RAM: 0x4feba000
[    0.000000] Memory hole size: 0MB
[    0.000000] [0000010000000000-fffff80000c00000] page_structs=131072 node=0 entry=0/0
[    0.000000] [0000010000000000-fffff80001000000] page_structs=131072 node=0 entry=1/0
[    0.000000] [0000010000800000-fffff80001400000] page_structs=131072 node=0 entry=2/0
[    0.000000] [0000010000800000-fffff80001800000] page_structs=131072 node=0 entry=3/0
[    0.000000] Zone PFN ranges:
[    0.000000]   Normal   0x00000000 -> 0x00027f5f
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00027eff
[    0.000000]     0: 0x00027f00 -> 0x00027f52
[    0.000000]     0: 0x00027f53 -> 0x00027f5f
[    0.000000] On node 0 totalpages: 163677
[    0.000000]   Normal zone: 1279 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 162398 pages, LIFO batch:15
[    0.000000] Booting Linux...
[    0.000000] PERCPU: Embedded 6 pages/cpu @fffff80001c00000 s12800 r8192 d28160 u2097152
[    0.000000] pcpu-alloc: s12800 r8192 d28160 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 162398
[    0.000000] Kernel command line: root=/dev/sda2 ro debug ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 8, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 7, 1048576 bytes)
[    0.000000] Memory: 1283880k available (3024k kernel code, 1240k data, 168k init) [fffff80000000000,000000004febe000]
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:255
[    0.000000] clocksource: mult[40842] shift[16]
[    0.000000] clockevent: mult[1065151889x] shift[32]
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.30.0 2003/11/11 10:37'
[    0.000000] PROMLIB: Root node compatible: sun4u
[    0.000000] Linux version 2.6.32-05775-gaad3bf0 (mroos@laimi) (gcc version 4.4.2 (Debian 4.4.2-3) ) #3 SMP Sat Dec 12 01:18:48 EET 2009
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 08:00:20:b0:4e:f6
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /pci@1f,4000/ebus@1/se@14,400000:a
[    0.000000] PROM: Built device tree with 67951 bytes of memory.
[    0.000000] Top of RAM: 0x4febe000, Total RAM: 0x4feba000
[    0.000000] Memory hole size: 0MB
[    0.000000] [0000010000000000-fffff80000c00000] page_structs=131072 node=0 entry=0/0
[    0.000000] [0000010000000000-fffff80001000000] page_structs=131072 node=0 entry=1/0
[    0.000000] [0000010000800000-fffff80001400000] page_structs=131072 node=0 entry=2/0
[    0.000000] [0000010000800000-fffff80001800000] page_structs=131072 node=0 entry=3/0
[    0.000000] Zone PFN ranges:
[    0.000000]   Normal   0x00000000 -> 0x00027f5f
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00027eff
[    0.000000]     0: 0x00027f00 -> 0x00027f52
[    0.000000]     0: 0x00027f53 -> 0x00027f5f
[    0.000000] On node 0 totalpages: 163677
[    0.000000]   Normal zone: 1279 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 162398 pages, LIFO batch:15
[    0.000000] Booting Linux...
[    0.000000] PERCPU: Embedded 6 pages/cpu @fffff80001c00000 s12800 r8192 d28160 u2097152
[    0.000000] pcpu-alloc: s12800 r8192 d28160 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 162398
[    0.000000] Kernel command line: root=/dev/sda2 ro debug ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 8, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 7, 1048576 bytes)
[    0.000000] Memory: 1283880k available (3024k kernel code, 1240k data, 168k init) [fffff80000000000,000000004febe000]
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:255
[    0.000000] clocksource: mult[40842] shift[16]
[    0.000000] clockevent: mult[1065151889x] shift[32]
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[   74.947462] Calibrating delay using timer specific routine.. 497.52 BogoMIPS (lpj=2487601)
[   74.948023] Security Framework initialized
[   74.948338] Mount-cache hash table entries: 512
[   75.009661] CPU 1: synchronized TICK with master CPU (last diff 2 cycles, maxerr 531 cycles)
[   75.009707] Brought up 2 CPUs
[   75.012153] khelper used greatest stack depth: 12280 bytes left
[   75.014164] NET: Registered protocol family 16
[   75.020195] khelper used greatest stack depth: 12104 bytes left
[   75.025614] khelper used greatest stack depth: 11512 bytes left
[   75.070577] /pci@1f,4000: PCI IO[1fe02010000] MEM[1ff80000000]
[   75.070694] /pci@1f,4000: PSYCHO PCI Bus Module ver[4:0]
[   75.070760] PCI: Scanning PBM /pci@1f,4000
[   75.076959] /pci@1f,2000: PCI IO[1fe02000000] MEM[1ff00000000]
[   75.077047] /pci@1f,2000: PSYCHO PCI Bus Module ver[4:0]
[   75.077109] PCI: Scanning PBM /pci@1f,2000
[   75.105167] bio: create slab <bio-0> at 0
[   75.108738] vgaarb: loaded
[   75.111344] SCSI subsystem initialized
[   75.116872] /pci@1f,4000/ebus@1/eeprom@14,0: Mostek regs at 0x1fff1000000
[   75.119761] AUXIO: Found device at /pci@1f,4000/ebus@1/auxio@14,726000
[   75.120459] Switching to clocksource tick
[   75.129048] NET: Registered protocol family 2
[   75.129667] IP route cache hash table entries: 65536 (order: 6, 524288 bytes)
[   75.134038] TCP established hash table entries: 262144 (order: 9, 4194304 bytes)
[   75.157002] TCP bind hash table entries: 65536 (order: 7, 1048576 bytes)
[   75.162786] TCP: Hash tables configured (established 262144 bind 65536)
[   75.162916] TCP reno registered
[   75.163027] UDP hash table entries: 1024 (order: 2, 32768 bytes)
[   75.163412] UDP-Lite hash table entries: 1024 (order: 2, 32768 bytes)
[   75.164681] NET: Registered protocol family 1
[   75.164927] PCI: CLS 0 bytes, default 64
[   75.165321] power: Control reg at 1fff1724000
[   75.171778] VFS: Disk quotas dquot_6.5.2
[   75.172036] Dquot-cache hash table entries: 1024 (order 0, 8192 bytes)
[   75.173125] msgmni has been set to 2509
[   75.175266] alg: No test for stdrng (krng)
[   75.176264] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[   75.176404] io scheduler noop registered
[   75.176627] io scheduler cfq registered (default)
[   75.226223] /pci@1f,4000/ebus@1/su@14,3083f8: Keyboard port at 1fff13083f8, irq 9
[   75.226657] /pci@1f,4000/ebus@1/su@14,3062f8: Mouse port at 1fff13062f8, irq 10
[   75.228919] f0070074: ttyS0 at MMIO 0x1fff1400000 (irq = 7) is a SAB82532 V3.2
[   75.229071] Console: ttyS0 (SAB82532)
[   80.913064] console [ttyS0] enabled
[   80.955299] f0070074: ttyS1 at MMIO 0x1fff1400040 (irq = 7) is a SAB82532 V3.2
[   81.042110] f0071b18: ttyS2 at MMIO 0x1fff1200000 (irq = 8) is a SAB82532 V3.2
[   81.128915] f0071b18: ttyS3 at MMIO 0x1fff1200040 (irq = 8) is a SAB82532 V3.2
[   81.218131] PCI: Enabling device: (0000:00:03.0), cmd 147
[   81.282131] PCI: Enabling device: (0000:00:03.1), cmd 3
[   81.347528] mice: PS/2 mouse device common for all mice
[   81.411431] khelper used greatest stack depth: 10656 bytes left
[   81.483224] rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
[   81.566500] TCP cubic registered
[   81.604778] NET: Registered protocol family 10
[   81.659137] lo: Disabled Privacy Extensions
[   81.708674] NET: Registered protocol family 17
[   81.763940] registered taskstats version 1
[   81.812980] rtc-m48t59 rtc-m48t59.0: setting system clock to 2009-12-12 07:42:20 UTC (1260603740)
[   82.401689] VFS: Cannot open root device "sda2" or unknown-block(0,0)
[   82.477976] Please append a correct "root=" boot option; here are the available partitions:
[   82.577993] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[   82.676937] Call Trace:
[   82.706058]  [00000000006f39a8] panic+0x54/0x178
[   82.761277]  [0000000000836d28] mount_block_root+0x20c/0x2c0
[   82.828996]  [0000000000836e34] mount_root+0x58/0x68
[   82.888364]  [0000000000836fb4] prepare_namespace+0x170/0x1a4
[   82.957093]  [000000000083636c] kernel_init+0x200/0x218
[   83.019589]  [000000000042b9b8] kernel_thread+0x38/0x60
[   83.082100]  [00000000006ea440] rest_init+0x20/0xa0
[   83.140398] Press Stop-A (L1-A) to return to the boot prom
[   92.401151] INFO: RCU detected CPU 0 stall (t=1000 jiffies)
[   92.466969] * CPU[  0]: TSTATE[0000009980001602] TPC[000000000042fb48] TNPC[000000000042fb4c] TASK[swapper:1]
[   92.585782]              TPC[__delay+0x28/0x60] O7[__delay+0x28/0x60] I7[udelay+0x14/0x40] RPC[panic+0x168/0x178]
[   92.708662] Kernel unaligned access at TPC[42c6d4] arch_trigger_all_cpu_backtrace+0x314/0x3a0
[   92.810736] Unable to handle kernel paging request in mna handler
[   92.881471]  at virtual address 000007ea00000001
[   92.938774] current->{active_,}mm->context = 0000000000000000
[   93.007527] current->{active_,}mm->pgd = fffff800008628ec
[   93.072099]               \|/ ____ \|/
[   93.072113]               "@'/ .. \`@"
[   93.072127]               /_| \__/ |_\
[   93.072140]                  \__U_/
[   93.248118] swapper(1): Oops [#1]
[   93.287704] TSTATE: 0000000080e01603 TPC: 000000000042c6d4 TNPC: 000000000042c6d8 Y: 00000000    Not tainted
[   93.405467] TPC: <arch_trigger_all_cpu_backtrace+0x314/0x3a0>
[   93.474153] g0: 0000000000800df8 g1: ffffffffffffffff g2: 0000000000794a60 g3: 000007ea00000001
[   93.578354] g4: fffff8004f05b760 g5: fffff800013a4000 g6: fffff8004f05c000 g7: ffffffffffffffff
[   93.682510] o0: 0000000000000001 o1: 0000000000000020 o2: 0000000000000000 o3: 0000004411001603
[   93.786666] o4: 00000000005a2254 o5: 00000000005a2258 sp: fffff8004f05eb31 ret_pc: 000000000042c560
[   93.895001] RPC: <arch_trigger_all_cpu_backtrace+0x1a0/0x3a0>
[   93.963697] l0: 0000000000861208 l1: 0000000000000001 l2: 0000000000861000 l3: 0000000000861000
[   94.067894] l4: 00000000007f95e0 l5: 00000000007f6400 l6: 0000000000000000 l7: 000000000000000e
[   94.172051] i0: 0000000000861248 i1: 0000000000794ab0 i2: 0000000000794ae0 i3: 0000000000794a68
[   94.276210] i4: 00000000006f9b58 i5: 0000000000794a60 i6: fffff8004f05ec01 i7: 00000000004966a4
[   94.380395] I7: <__rcu_pending+0x2a4/0x320>
[   94.430310] Disabling lock debugging due to kernel taint
[   94.493869] Caller[00000000004966a4]: __rcu_pending+0x2a4/0x320
[   94.564700] Caller[0000000000496750]: rcu_check_callbacks+0x30/0x160
[   94.640752] Caller[000000000046a4cc]: update_process_times+0x2c/0x60
[   94.716778] Caller[0000000000483564]: tick_sched_timer+0x64/0xc0
[   94.788648] Caller[0000000000479f70]: __run_hrtimer+0x50/0xe0
[   94.857381] Caller[000000000047a260]: hrtimer_interrupt+0xc0/0x1c0
[   94.931336] Caller[000000000042fd24]: timer_interrupt+0x84/0xc0
[   95.002164] Caller[00000000004209d4]: tl0_irq14+0x14/0x20
[   95.066733] Caller[000000000042fb48]: __delay+0x28/0x60
[   95.129229] Caller[000000000042fb94]: udelay+0x14/0x40
[   95.190677] Caller[00000000006f3abc]: panic+0x168/0x178
[   95.253177] Caller[0000000000836d28]: mount_block_root+0x20c/0x2c0
[   95.327132] Caller[0000000000836e34]: mount_root+0x58/0x68
[   95.392749] Caller[0000000000836fb4]: prepare_namespace+0x170/0x1a4
[   95.467744] Caller[000000000083636c]: kernel_init+0x200/0x218
[   95.536487] Caller[000000000042b9b8]: kernel_thread+0x38/0x60
[   95.605233] Caller[00000000006ea440]: rest_init+0x20/0xa0
[   95.669789] Instruction DUMP: d85e2008  02c0c007  da5e2010 <c658c000> 02c0c005  d45fa7ef  c200e188  8400e358  d45fa7ef 
[   95.798922] Kernel panic - not syncing: Aiee, killing interrupt handler!
[   95.879152] Call Trace:
[   95.908310]  [00000000006f39a8] panic+0x54/0x178
[   95.963526]  [0000000000462580] do_exit+0x640/0x720
[   96.021859]  [0000000000427c10] die_if_kernel+0xf0/0x300
[   96.085402]  [00000000004337c0] kernel_mna_trap_fault+0xe0/0x120
[   96.157273]  [0000000000433a48] kernel_unaligned_trap+0x248/0x5c0
[   96.230176]  [00000000004278ac] mem_address_unaligned+0x8c/0xa0
[   96.301012]  [0000000000405f60] do_mna+0x3c/0x4c
[   96.356204]  [000000000042c6d4] arch_trigger_all_cpu_backtrace+0x314/0x3a0
[   96.438504]  [00000000004966a4] __rcu_pending+0x2a4/0x320
[   96.503070]  [0000000000496750] rcu_check_callbacks+0x30/0x160
[   96.572863]  [000000000046a4cc] update_process_times+0x2c/0x60
[   96.642641]  [0000000000483564] tick_sched_timer+0x64/0xc0
[   96.708262]  [0000000000479f70] __run_hrtimer+0x50/0xe0
[   96.770753]  [000000000047a260] hrtimer_interrupt+0xc0/0x1c0
[   96.838461]  [000000000042fd24] timer_interrupt+0x84/0xc0
[   96.903031]  [00000000004209d4] tl0_irq14+0x14/0x20
[   96.961353] Press Stop-A (L1-A) to return to the boot prom

-- 
Meelis Roos (mroos@linux.ee)
