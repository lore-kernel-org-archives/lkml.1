Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761AbZEaAYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbZEaAYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 20:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZEaAYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 20:24:04 -0400
Received: from claw.goop.org ([74.207.240.146]:59926 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbZEaAYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 20:24:02 -0400
Message-ID: <4A21CE1C.1090204@goop.org>
Date: Sun, 31 May 2009 10:23:56 +1000
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rambaldi <rambaldi@xs4all.nl>
CC: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: kernel BUG at arch/x86/xen/multicalls.c:204!
References: <4A20F23D.4080504@xs4all.nl>
In-Reply-To: <4A20F23D.4080504@xs4all.nl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rambaldi wrote:
> Hi,
>
> while booting the 2.6.29-gentoo-r5 kernel as xen domU guest I got the following kernel BUG.
>
> I have not tried a vanilla 2.6.29 kernel, but can if requested, .config is also available on reguest.
>   

That would be useful, particularly if you enable the various debugging 
options:
CONFIG_DEBUG_KERNEL
CONFIG_FRAME_POINTER

It's not clear to me what's failing.  Are there any messages on the Xen 
concole (xm dmesg)?

    J

> thanks,
>
> R.
>
>
> Started domain
>                                  Linux version 2.6.29-gentoo-r5 (root@regula) (gcc version 4.3.2 (Gentoo 4.3.2-r3 p1.6,
> pie-10.1.5) ) #1 SMP Fri May 29 23:52:55 CEST 2009
> Command line: root=/dev/xvda1 ro xencons=hvc0  xen_fbfront.video=4,1152,864
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   Centaur CentaurHauls
> BIOS-provided physical RAM map:
>  Xen: 0000000000000000 - 00000000000a0000 (usable)
>  Xen: 00000000000a0000 - 0000000000100000 (reserved)
>  Xen: 0000000000100000 - 0000000000e91000 (usable)
>  Xen: 0000000000e91000 - 000000000161e000 (reserved)
>  Xen: 000000000161e000 - 00000000f1400000 (usable)
> DMI not present or invalid.
> last_pfn = 0xf1400 max_arch_pfn = 0x100000000
> init_memory_mapping: 0000000000000000-00000000f1400000
> last_map_addr: f1400000 end: f1400000
> (5 early reservations) ==> bootmem [0000000000 - 00f1400000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [000161e000 - 000162d000]   XEN PAGETABLES ==> [000161e000 - 000162d000]
>   #2 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
>   #3 [0000200000 - 0000e90f18]    TEXT DATA BSS ==> [0000200000 - 0000e90f18]
>   #4 [000162d000 - 0001daa000]          PGTABLE ==> [000162d000 - 0001daa000]
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00001000
>   DMA32    0x00001000 -> 0x00100000
>   Normal   0x00100000 -> 0x00100000
> Movable zone start PFN for each node
> early_node_map[3] active PFN ranges
>     0: 0x00000000 -> 0x000000a0
>     0: 0x00000100 -> 0x00000e91
>     0: 0x0000161e -> 0x000f1400
> SMP: Allowing 8 CPUs, 0 hotplug CPUs
> No local APIC present
> Allocating PCI resources starting at f2000000 (gap: f1400000:ec00000)
> NR_CPUS:4096 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
> PERCPU: Allocating 73728 bytes of per cpu data
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 969402
> Kernel command line: root=/dev/xvda1 ro xencons=hvc0  xen_fbfront.video=4,1152,864
> Initializing CPU#0
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> Detected 2499.996 MHz processor.
> Console: colour dummy device 80x25
> console [tty0] enabled
> console [hvc0] enabled
> Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> Checking aperture...
> No AGP bridge found
> Memory: 3856500k/3952640k available (2253k kernel code, 8116k absent, 87672k reserved, 2269k data, 476k init)
> installing Xen timer for CPU 0
> Calibrating delay loop (skipped), value calculated using timer frequency.. 4999.99 BogoMIPS (lpj=24999960)
> Mount-cache hash table entries: 256
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 6144K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> Freeing SMP alternatives: 27k freed
> cpu 0 spinlock event irq 1
> installing Xen timer for CPU 1
> cpu 1 spinlock event irq 7
> Initializing CPU#1
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 6144K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> installing Xen timer for CPU 2
> cpu 2 spinlock event irq 13
> Initializing CPU#2
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 6144K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> installing Xen timer for CPU 3
> cpu 3 spinlock event irq 19
> Initializing CPU#3
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 6144K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> installing Xen timer for CPU 4
> cpu 4 spinlock event irq 25
> Initializing CPU#4
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 6144K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> installing Xen timer for CPU 5
> cpu 5 spinlock event irq 31
> Initializing CPU#5
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 6144K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> installing Xen timer for CPU 6
> cpu 6 spinlock event irq 37
> Initializing CPU#6
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 6144K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> installing Xen timer for CPU 7
> cpu 7 spinlock event irq 43
> Initializing CPU#7
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 6144K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> Brought up 8 CPUs
> net_namespace: 1824 bytes
> Booting paravirtualized kernel on Xen
> Xen version: 3.3.1 (preserve-AD)
> xor: automatically using best checksumming function: generic_sse
>    generic_sse:  2581.600 MB/sec
> xor: using function: generic_sse (2581.600 MB/sec)
> Grant table initialized
> NET: Registered protocol family 16
> PCI: Fatal: No config space access function found
> bio: create slab <bio-0> at 0
> xen_balloon: Initialising balloon driver.
> SCSI subsystem initialized
> PCI: System does not support PCI
> PCI: System does not support PCI
> NET: Registered protocol family 2
> Switched to NOHz mode on CPU #0
> Switched to NOHz mode on CPU #1
> Switched to NOHz mode on CPU #2
> Switched to NOHz mode on CPU #3
> Switched to NOHz mode on CPU #4
> Switched to NOHz mode on CPU #5
> Switched to NOHz mode on CPU #6
> Switched to NOHz mode on CPU #7
> IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> TCP: Hash tables configured (established 262144 bind 65536)
> TCP reno registered
> NET: Registered protocol family 1
> platform rtc_cmos: registered platform RTC device (no PNP device found)
> msgmni has been set to 7720
> alg: No test for stdrng (krng)
> async_tx: api initialized (sync-only)
> io scheduler noop registered
> io scheduler anticipatory registered (default)
> io scheduler deadline registered
> io scheduler cfq registered
> Non-volatile memory driver v1.3
> Linux agpgart interface v0.103
> Console: switching to colour frame buffer device 144x54
> console [tty0] enabled
> loop: module loaded
> Initialising Xen virtual ethernet driver.
> blkfront: xvda: barriers enabled
>  xvda: xvda1 xvda2
> Driver 'sd' needs updating - please use bus_type methods
> i8042.c: No controller found.
> blkfront: xvdb: barriers enabled
> mice: PS/2 mouse device common for all mice
>  xvdb:<6>input: PC Speaker as /class/input/input0
>  unknown partition table
> input: Xen Virtual Keyboard as /class/input/input1
> input: Xen Virtual Pointer as /class/input/input2
> rtc_cmos: probe of rtc_cmos failed with error -16
> md: linear personality registered for level -1
> md: raid0 personality registered for level 0
> md: raid1 personality registered for level 1
> md: raid10 personality registered for level 10
> raid6: int64x1   2063 MB/s
> raid6: int64x2   2748 MB/s
> raid6: int64x4   2264 MB/s
> raid6: int64x8   1879 MB/s
> raid6: sse2x1    2936 MB/s
> raid6: sse2x2    5518 MB/s
> raid6: sse2x4    6267 MB/s
> raid6: using algorithm sse2x4 (6267 MB/s)
> md: raid6 personality registered for level 6
> md: raid5 personality registered for level 5
> md: raid4 personality registered for level 4
> md: multipath personality registered for level -4
> device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
> cpuidle: using governor ladder
> cpuidle: using governor menu
> IPv4 over IPv4 tunneling driver
> GRE over IPv4 tunneling driver
> TCP cubic registered
> NET: Registered protocol family 17
> IO APIC resources could be not be allocated.
> registered taskstats version 1
> XENBUS: Device with no driver: device/console/0
> drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> md: Waiting for all devices to be available before autodetect
> md: If you don't use raid, use raid=noautodetect
> md: Autodetecting RAID arrays.
> md: Scanned 0 and added 0 devices.
> md: autorun ...
> md: ... autorun DONE.
> EXT3-fs: INFO: recovery required on readonly filesystem.
> EXT3-fs: write access will be enabled during recovery.
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: recovery complete.
> EXT3-fs: mounted filesystem with ordered data mode.
> VFS: Mounted root (ext3 filesystem) readonly on device 202:1.
> Freeing unused kernel memory: 476k freed
> ------------[ cut here ]------------
> kernel BUG at arch/x86/xen/multicalls.c:204!
> invalid opcode: 0000 [#1] SMP
> last sysfs file:
> CPU 0
> Modules linked in:
> Pid: 959, comm: bash Not tainted 2.6.29-gentoo-r5 #1
> RIP: e030:[<ffffffff8020be37>]  [<ffffffff8020be37>] __xen_mc_entry+0x8e/0xaf
> RSP: e02b:ffff8800ef0a13d8  EFLAGS: 00010006
> RAX: 0000000000000218 RBX: ffff880001de0070 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
> RBP: 0000000000000218 R08: 0000000000000040 R09: 0000000000000040
> R10: 00000000000e9568 R11: 0000000000000001 R12: 00007f9da8753315
> R13: 0000000000000000 R14: ffff8800f04a0a98 R15: ffff8800f04a4480
> FS:  00007f9da87526f0(0000) GS:ffffffff80c0e000(0000) knlGS:0000000000000000
> CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f9da8753315 CR3: 00000000efec2000 CR4: 0000000000002620
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process bash (pid: 959, threadinfo ffff8800ef0a0000, task ffff8800ef4428f0)
> Stack:
>  0000000000000000 0000000000000000 0000000000000000 0000000000000000
>  0000000000000000 0000000000000200 ffff8800ef0a1438 ffffffff8020aa5d
>  0000000000000000 0000000000000000 0000000000000000 0000000000000000
> Call Trace:
>  [<ffffffff8020aa5d>] ? xen_flush_tlb_others+0xb9/0x15d
>  [<ffffffff8021b390>] ? flush_tlb_page+0xa0/0xad
>  [<ffffffff80271feb>] ? do_wp_page+0x648/0x76a
>  [<ffffffff8020bd2e>] ? xen_mc_flush+0x13c/0x162
>  [<ffffffff8027385e>] ? handle_mm_fault+0x739/0x7ea
>  [<ffffffff80430862>] ? _spin_unlock_irqrestore+0x14/0x17
>  [<ffffffff8022308c>] ? do_page_fault+0x5a5/0x969
>  [<ffffffff802fc84c>] ? __make_request+0x39b/0x3df
>  [<ffffffff802a4683>] ? sync_buffer+0x0/0x40
>  [<ffffffff8042f262>] ? io_schedule+0x2d/0x39
>  [<ffffffff8042f559>] ? __wait_on_bit+0x62/0x70
>  [<ffffffff802a4683>] ? sync_buffer+0x0/0x40
>  [<ffffffff8042f5d2>] ? out_of_line_wait_on_bit+0x6b/0x77
>  [<ffffffff80249496>] ? wake_bit_function+0x0/0x23
>  [<ffffffff80309105>] ? kobject_get+0x12/0x17
>  [<ffffffff8028945f>] ? cdev_get+0x40/0x57
>  [<ffffffff80289482>] ? exact_lock+0xc/0x14
>  [<ffffffff80355cee>] ? kobj_lookup+0x125/0x15f
>  [<ffffffff804309bd>] ? lock_kernel+0x23/0x33
>  [<ffffffff804309f8>] ? unlock_kernel+0x2b/0x2d
>  [<ffffffff803224f8>] ? memory_open+0xd6/0xde
>  [<ffffffff80289712>] ? chrdev_open+0x15a/0x179
>  [<ffffffff802895b8>] ? chrdev_open+0x0/0x179
>  [<ffffffff8028590f>] ? __dentry_open+0x156/0x241
>  [<ffffffff80291352>] ? do_filp_open+0x3ec/0x7eb
>  [<ffffffff80430b05>] ? page_fault+0x25/0x30
> Code: 07 48 c1 e8 03 8d 14 c5 00 00 00 00 8b 8b 00 14 00 00 8d 41 01 89 83 00 14 00 00 8d 04 2a 89 83 04 14 00 00 3d 00
> 02 00 00 76 04 <0f> 0b eb fe 89 d0 48 83 c4 28 48 8d 94 03 00 10 00 00 89 c8 48
> RIP  [<ffffffff8020be37>] __xen_mc_entry+0x8e/0xaf
>  RSP <ffff8800ef0a13d8>
> ---[ end trace 27270f261602e287 ]---
> ------------[ cut here ]------------
> kernel BUG at arch/x86/xen/multicalls.c:190!
> invalid opcode: 0000 [#2] SMP
> last sysfs file:
> CPU 0
> Modules linked in:
> Pid: 959, comm: bash Tainted: G      D    2.6.29-gentoo-r5 #1
> RIP: e030:[<ffffffff8020bdd3>]  [<ffffffff8020bdd3>] __xen_mc_entry+0x2a/0xaf
> RSP: e02b:ffff8800ef0a1068  EFLAGS: 00010006
> RAX: 0000000000000218 RBX: ffff880001de0070 RCX: 0000000000000000
> RDX: ffff880081215000 RSI: 0000000000201000 RDI: 0000000000000018
> RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000002a7d
> R10: ffffffff8025f8c3 R11: 0000000000000000 R12: 0000000000000201
> R13: ffff8800ef6d90a0 R14: ffff8800f04a0a98 R15: ffff8800f04a4480
> FS:  00007f9da87526f0(0000) GS:ffffffff80c0e000(0000) knlGS:0000000000000000
> CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f9da8753315 CR3: 0000000000201000 CR4: 0000000000002620
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process bash (pid: 959, threadinfo ffff8800ef0a0000, task ffff8800ef4428f0)
> Stack:
>  000000000000311d ffffffff8024c34c ffffffff80430d46 0000000000000000
>  000000000000000c 00000000002005fc 0000000000201000 ffffffff8020af1e
>  ffffffff80679300 0000000000000000 ffffffff80bd74f0 ffffffff80210ded
> Call Trace:
>  [<ffffffff8024c34c>] ? up+0xe/0x36
>  [<ffffffff80430d46>] ? error_exit+0x36/0x70
>  [<ffffffff8020af1e>] ? __xen_write_cr3+0x66/0xec
>  [<ffffffff80210ded>] ? retint_restore_args+0x5/0x20
>  [<ffffffff8020aff6>] ? xen_write_cr3+0x52/0xb2
>  [<ffffffff8021b2be>] ? leave_mm+0x42/0x45
>  [<ffffffff8020922a>] ? _stext+0x22a/0x1000
>  [<ffffffff8020c7df>] ? xen_exit_mmap+0x50/0x1d9
>  [<ffffffff8020922a>] ? _stext+0x22a/0x1000
>  [<ffffffff802773d5>] ? exit_mmap+0x49/0x134
>  [<ffffffff80235699>] ? mmput+0x23/0xab
>  [<ffffffff80238bea>] ? exit_mm+0xfc/0x107
>  [<ffffffff8025f8c3>] ? acct_update_integrals+0xa1/0xa9
>  [<ffffffff8023a693>] ? do_exit+0x178/0x706
>  [<ffffffff80430862>] ? _spin_unlock_irqrestore+0x14/0x17
>  [<ffffffff80237d43>] ? release_console_sem+0x197/0x1cc
>  [<ffffffff80213cd1>] ? oops_end+0x96/0x9b
>  [<ffffffff80212200>] ? do_invalid_op+0x8c/0x96
>  [<ffffffff8020be37>] ? __xen_mc_entry+0x8e/0xaf
>  [<ffffffff8021121b>] ? invalid_op+0x1b/0x20
>  [<ffffffff8020be37>] ? __xen_mc_entry+0x8e/0xaf
>  [<ffffffff8020be03>] ? __xen_mc_entry+0x5a/0xaf
>  [<ffffffff8020aa5d>] ? xen_flush_tlb_others+0xb9/0x15d
>  [<ffffffff8021b390>] ? flush_tlb_page+0xa0/0xad
>  [<ffffffff80271feb>] ? do_wp_page+0x648/0x76a
>  [<ffffffff8020bd2e>] ? xen_mc_flush+0x13c/0x162
>  [<ffffffff8027385e>] ? handle_mm_fault+0x739/0x7ea
>  [<ffffffff80430862>] ? _spin_unlock_irqrestore+0x14/0x17
>  [<ffffffff8022308c>] ? do_page_fault+0x5a5/0x969
>  [<ffffffff802fc84c>] ? __make_request+0x39b/0x3df
>  [<ffffffff802a4683>] ? sync_buffer+0x0/0x40
>  [<ffffffff8042f262>] ? io_schedule+0x2d/0x39
>  [<ffffffff8042f559>] ? __wait_on_bit+0x62/0x70
>  [<ffffffff802a4683>] ? sync_buffer+0x0/0x40
>  [<ffffffff8042f5d2>] ? out_of_line_wait_on_bit+0x6b/0x77
>  [<ffffffff80249496>] ? wake_bit_function+0x0/0x23
>  [<ffffffff80309105>] ? kobject_get+0x12/0x17
>  [<ffffffff8028945f>] ? cdev_get+0x40/0x57
>  [<ffffffff80289482>] ? exact_lock+0xc/0x14
>  [<ffffffff80355cee>] ? kobj_lookup+0x125/0x15f
>  [<ffffffff804309bd>] ? lock_kernel+0x23/0x33
>  [<ffffffff804309f8>] ? unlock_kernel+0x2b/0x2d
>  [<ffffffff803224f8>] ? memory_open+0xd6/0xde
>  [<ffffffff80289712>] ? chrdev_open+0x15a/0x179
>  [<ffffffff802895b8>] ? chrdev_open+0x0/0x179
>  [<ffffffff8028590f>] ? __dentry_open+0x156/0x241
>  [<ffffffff80291352>] ? do_filp_open+0x3ec/0x7eb
>  [<ffffffff80430b05>] ? page_fault+0x25/0x30
> Code: c3 55 48 c7 c0 70 b0 bc 80 53 48 89 fd 48 83 ec 28 65 48 8b 14 25 08 00 00 00 48 8d 1c 10 8b 83 04 14 00 00 3d 00
> 02 00 00 76 04 <0f> 0b eb fe 83 bb 00 14 00 00 20 74 1e 89 c0 48 83 c0 07 48 c1
> RIP  [<ffffffff8020bdd3>] __xen_mc_entry+0x2a/0xaf
>  RSP <ffff8800ef0a1068>
> ---[ end trace 27270f261602e288 ]---
> Fixing recursive fault but reboot is needed!
> ------------[ cut here ]------------
> kernel BUG at arch/x86/xen/multicalls.c:190!
> invalid opcode: 0000 [#3] SMP
> last sysfs file:
> CPU 0
> Modules linked in:
> Pid: 959, comm: bash Tainted: G      D    2.6.29-gentoo-r5 #1
> RIP: e030:[<ffffffff8020bdd3>]  [<ffffffff8020bdd3>] __xen_mc_entry+0x2a/0xaf
> RSP: e02b:ffffffff80b3bde8  EFLAGS: 00010006
> RAX: 0000000000000218 RBX: ffff880001de0070 RCX: ffff8800ef4428f0
> RDX: ffff880081215000 RSI: ffffffff80509b58 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000000 R09: ffff880001de68c0
> R10: 000000000000000c R11: ffffffff8024ce94 R12: ffffffff80509b58
> R13: ffffffff80509b58 R14: ffff880001dec840 R15: 0000000000000000
> FS:  00007f9da87526f0(0000) GS:ffffffff80c0e000(0000) knlGS:0000000000000000
> CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f9da8753315 CR3: 0000000000201000 CR4: 0000000000002620
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process bash (pid: 959, threadinfo ffff8800ef0a0000, task ffff8800ef4428f0)
> Stack:
>  ffffffff80b94a80 0000000000000000 ffffffff8020d915 ffff8800ef654b30
>  0000000000000000 0000000000000000 ffff8800ef4428f0 ffffffff8020ac8f
>  0001fefa72fa5670 000000005e15863e 000000000030d927 000000007612a333
> Call Trace:
> Code: c3 55 48 c7 c0 70 b0 bc 80 53 48 89 fd 48 83 ec 28 65 48 8b 14 25 08 00 00 00 48 8d 1c 10 8b 83 04 14 00 00 3d 00
> 02 00 00 76 04 <0f> 0b eb fe 83 bb 00 14 00 00 20 74 1e 89 c0 48 83 c0 07 48 c1
> RIP  [<ffffffff8020bdd3>] __xen_mc_entry+0x2a/0xaf
>  RSP <ffffffff80b3bde8>
> ---[ end trace 27270f261602e289 ]---
> Fixing recursive fault but reboot is needed!
>
>   

