Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZCJOM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZCJOM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZCJOMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:12:47 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53278 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZCJOMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:12:45 -0400
Message-ID: <49B67552.5070307@in.ibm.com>
Date: Tue, 10 Mar 2009 19:42:34 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Next 10: Badness at mm/allocpercpu.c:123
References: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au>
In-Reply-To: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------070400040505070306040302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070400040505070306040302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While booting Next 20090310 on a powerpc box (Power6 9117-MMA)
i observed the following badness :

[    0.339662] ------------[ cut here ]------------
[    0.339666] Badness at mm/allocpercpu.c:123
[    0.339670] NIP: c0000000001129dc LR: c0000000001129b8 CTR: 0000000000000000
[    0.339676] REGS: c0000000fe1efa10 TRAP: 0700   Not tainted  (2.6.29-rc7-next-20090310)
[    0.339681] MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24000024  XER: 20000002
[    0.339695] TASK = c0000000fe1dd3d0[1] 'swapper' THREAD: c0000000fe1ec000 CPU: 0
[    0.339701] GPR00: 0000000000000001 c0000000fe1efc90 c000000000948660 c0000000fe019000
[    0.339711] GPR04: 0000000000000000 0000000000000000 c0000000fe019080 c00000000122e980
[    0.339721] GPR08: 0000000000000000 c000000001467dec c0000000fe0e2610 c0000000fe1dd3d0
[    0.339732] GPR12: 0000000044000022 c000000000a22300 c000000000733ad0 c00000000065e0c5
[    0.339742] GPR16: 0000000003c33a08 0000000000000000 c000000000733a08 0000000002f1fc90
[    0.339752] GPR20: c000000000733a20 c000000000679b30 0000000000000000 0000000002f1fc90
[    0.339763] GPR24: 0000000000000000 0000000000000000 c000000000670ccd 0000000000000001
[    0.339773] GPR28: c0000000fe019000 0000000000000080 c0000000008cb908 0000000000000100
[    0.339788] NIP [c0000000001129dc] .__alloc_percpu+0x7c/0x244
[    0.339793] LR [c0000000001129b8] .__alloc_percpu+0x58/0x244
[    0.339798] Call Trace:
[    0.339801] [c0000000fe1efc90] [c0000000001129b8] .__alloc_percpu+0x58/0x244 (unreliable)
[    0.339810] [c0000000fe1efdc0] [c00000000007ce84] .__create_workqueue_key+0x74/0x2a0
[    0.339819] [c0000000fe1efe70] [c000000000716990] .cpuset_init_smp+0x78/0xa4
[    0.339827] [c0000000fe1eff00] [c000000000700334] .kernel_init+0x16c/0x224
[    0.339834] [c0000000fe1eff90] [c00000000002adc8] .kernel_thread+0x54/0x70
[    0.339839] Instruction dump:
[    0.339843] 3863007f 78630624 4bffb94d 60000000 2bbd0008 7c7c1b78 40fd0030 e93e8010
[    0.339856] 80090000 7c000034 5400d97e 78000020 <0b000000> 2fa00000 41fe0010 e93e8010

I have attached the dmesg log here.

Next 20090306 had the same problem, while 20090305 did not.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------070400040505070306040302
Content-Type: text/plain;
 name="dmesg_next_20090310"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg_next_20090310"

Using 006299d6 bytes for initrd buffer
Please wait, loading kernel...
Allocated 01600000 bytes for kernel @ 03500000
   Elf64 kernel loaded...
Loading ramdisk...
ramdisk loaded 006299d6 @ 01600000
OF stdout device is: /vdevice/vty@30000000
Hypertas detected, assuming LPAR !
command line: root=/dev/sda5 sysrq=1 insmod=sym53c8xx insmod=ipr crashkernel=512M-:256M  
memory layout at init:
  alloc_bottom : 00000000049c0000
  alloc_top    : 0000000008000000
  alloc_top_hi : 0000000008000000
  rmo_top      : 0000000008000000
  ram_top      : 0000000008000000
Looking for displays
instantiating rtas at 0x00000000074e0000 ... done
boot cpu hw idx 0000000000000000
starting cpu hw idx 0000000000000002... done
copying OF device tree ...
Building dt strings...
Building dt structure...
Device tree strings 0x0000000004bd0000 -> 0x0000000004bd15d3
Device tree struct  0x0000000004be0000 -> 0x0000000004c00000
Calling quiesce ...
returning from prom_init
[    0.000000] Crash kernel location must be 0x2000000
[    0.000000] Reserving 256MB of memory at 32MB for crashkernel (System RAM: 4096MB)
[    0.000000] Phyp-dump disabled at boot time
[    0.000000] Using pSeries machine description
[    0.000000] Using 1TB segments
[    0.000000] Found initrd at 0xc000000001600000:0xc000000001c299d6
[    0.000000] console [udbg0] enabled
[    0.000000] Partition configured for 4 cpus.
[    0.000000] CPU maps initialized for 2 threads per core
[    0.000000] Starting Linux PPC64 #1 SMP Tue Mar 10 17:25:05 IST 2009
[    0.000000] -----------------------------------------------------
[    0.000000] ppc64_pft_size                = 0x1a
[    0.000000] physicalMemorySize            = 0x100000000
[    0.000000] htab_hash_mask                = 0x7ffff
[    0.000000] -----------------------------------------------------
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.29-rc7-next-20090310 (root@llm62) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Tue Mar 10 17:25:05 IST 2009
[    0.000000] [boot]0012 Setup Arch
[    0.000000] EEH: No capable adapters found
[    0.000000] PPC64 nvram contains 15360 bytes
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00010000
[    0.000000]   Normal   0x00010000 -> 0x00010000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00010000
[    0.000000] [boot]0015 Setup Done
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 65448
[    0.000000] Policy zone: DMA
[    0.000000] Kernel command line: root=/dev/sda5 sysrq=1 insmod=sym53c8xx insmod=ipr crashkernel=512M-:256M  
[    0.000000] NR_IRQS:512
[    0.000000] [boot]0020 XICS Init
[    0.000000] [boot]0021 XICS Done
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] clocksource: timebase mult[7d0000] shift[22] registered
[    0.000054] Console: colour dummy device 80x25
[    0.000086] console handover: boot [udbg0] -> real [hvc0]
[    0.000113] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000118] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000121] ... MAX_LOCK_DEPTH:          48
[    0.000124] ... MAX_LOCKDEP_KEYS:        8191
[    0.000128] ... CLASSHASH_SIZE:          4096
[    0.000132] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.000135] ... MAX_LOCKDEP_CHAINS:      16384
[    0.000139] ... CHAINHASH_SIZE:          8192
[    0.000142]  memory used by lock dependency info: 4607 kB
[    0.000146]  per task-struct memory footprint: 1920 bytes
[    0.000476] Dentry cache hash table entries: 524288 (order: 6, 4194304 bytes)
[    0.001534] Inode-cache hash table entries: 262144 (order: 5, 2097152 bytes)
[    0.002663] allocated 2621440 bytes of page_cgroup
[    0.002667] please try cgroup_disable=memory option if you don't want
[    0.002672] freeing bootmem node 0
[    0.079853] Memory: 3864320k/4194304k available (7552k kernel code, 329984k reserved, 1984k data, 10855k bss, 384k init)
[    0.080373] Calibrating delay loop... 1022.36 BogoMIPS (lpj=5111808)
[    0.330475] Security Framework initialized
[    0.330481] SELinux:  Disabled at boot.
[    0.330541] Mount-cache hash table entries: 4096
[    0.333232] Initializing cgroup subsys ns
[    0.333237] Initializing cgroup subsys cpuacct
[    0.333242] Initializing cgroup subsys memory
[    0.333251] Initializing cgroup subsys devices
[    0.333257] Initializing cgroup subsys freezer
[    0.334039] Processor 1 found.
[    0.338524] Processor 2 found.
[    0.339010] Processor 3 found.
[    0.339021] Brought up 4 CPUs
[    0.339662] ------------[ cut here ]------------
[    0.339666] Badness at mm/allocpercpu.c:123
[    0.339670] NIP: c0000000001129dc LR: c0000000001129b8 CTR: 0000000000000000
[    0.339676] REGS: c0000000fe1efa10 TRAP: 0700   Not tainted  (2.6.29-rc7-next-20090310)
[    0.339681] MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24000024  XER: 20000002
[    0.339695] TASK = c0000000fe1dd3d0[1] 'swapper' THREAD: c0000000fe1ec000 CPU: 0
[    0.339701] GPR00: 0000000000000001 c0000000fe1efc90 c000000000948660 c0000000fe019000 
[    0.339711] GPR04: 0000000000000000 0000000000000000 c0000000fe019080 c00000000122e980 
[    0.339721] GPR08: 0000000000000000 c000000001467dec c0000000fe0e2610 c0000000fe1dd3d0 
[    0.339732] GPR12: 0000000044000022 c000000000a22300 c000000000733ad0 c00000000065e0c5 
[    0.339742] GPR16: 0000000003c33a08 0000000000000000 c000000000733a08 0000000002f1fc90 
[    0.339752] GPR20: c000000000733a20 c000000000679b30 0000000000000000 0000000002f1fc90 
[    0.339763] GPR24: 0000000000000000 0000000000000000 c000000000670ccd 0000000000000001 
[    0.339773] GPR28: c0000000fe019000 0000000000000080 c0000000008cb908 0000000000000100 
[    0.339788] NIP [c0000000001129dc] .__alloc_percpu+0x7c/0x244
[    0.339793] LR [c0000000001129b8] .__alloc_percpu+0x58/0x244
[    0.339798] Call Trace:
[    0.339801] [c0000000fe1efc90] [c0000000001129b8] .__alloc_percpu+0x58/0x244 (unreliable)
[    0.339810] [c0000000fe1efdc0] [c00000000007ce84] .__create_workqueue_key+0x74/0x2a0
[    0.339819] [c0000000fe1efe70] [c000000000716990] .cpuset_init_smp+0x78/0xa4
[    0.339827] [c0000000fe1eff00] [c000000000700334] .kernel_init+0x16c/0x224
[    0.339834] [c0000000fe1eff90] [c00000000002adc8] .kernel_thread+0x54/0x70
[    0.339839] Instruction dump:
[    0.339843] 3863007f 78630624 4bffb94d 60000000 2bbd0008 7c7c1b78 40fd0030 e93e8010 
[    0.339856] 80090000 7c000034 5400d97e 78000020 <0b000000> 2fa00000 41fe0010 e93e8010 
[    0.348162] net_namespace: 2160 bytes
[    0.348476] NET: Registered protocol family 16
[    0.348532] IBM eBus Device Driver
[    0.352290] PCI: Probing PCI hardware
[    0.354439] bio: create slab <bio-0> at 0
[    0.355321] SCSI subsystem initialized
[    0.355468] usbcore: registered new interface driver usbfs
[    0.355500] usbcore: registered new interface driver hub
[    0.355577] usbcore: registered new device driver usb
[    0.380869] NET: Registered protocol family 2
[    0.470537] IP route cache hash table entries: 32768 (order: 2, 262144 bytes)
[    0.471080] TCP established hash table entries: 131072 (order: 5, 2097152 bytes)
[    0.471514] TCP bind hash table entries: 65536 (order: 5, 3670016 bytes)
[    0.473611] TCP: Hash tables configured (established 131072 bind 65536)
[    0.473618] TCP reno registered
[    0.500558] NET: Registered protocol family 1
[    0.500632] Unpacking initramfs... done
[    0.645207] Freeing initrd memory: 6310k freed
[    0.658465] IOMMU table initialized, virtual merging enabled
[    0.659595] ====[ backtrace testing ]===========
[    0.659599] Testing a backtrace from process context.
[    0.659603] The following trace is a kernel self test and not a bug!
[    0.659607] Call Trace:
[    0.659613] [c0000000fe1efc70] [c000000000011608] .show_stack+0x6c/0x16c (unreliable)
[    0.659622] [c0000000fe1efd20] [c0000000000a6758] .backtrace_regression_test+0x44/0x134
[    0.659630] [c0000000fe1efe10] [c000000000009254] .do_one_initcall+0x80/0x1a4
[    0.659638] [c0000000fe1eff00] [c000000000700370] .kernel_init+0x1a8/0x224
[    0.659645] [c0000000fe1eff90] [c00000000002adc8] .kernel_thread+0x54/0x70
[    0.659650] Testing a backtrace from irq context.
[    0.659654] The following trace is a kernel self test and not a bug!
[    0.659664] Call Trace:
[    0.659668] [c000000001f9fcf0] [c000000000011608] .show_stack+0x6c/0x16c (unreliable)
[    0.659676] [c000000001f9fda0] [c0000000000a66f0] .backtrace_test_irq_callback+0x18/0x3c
[    0.659684] [c000000001f9fe20] [c00000000006bfa0] .tasklet_action+0x100/0x1d0
[    0.659691] [c000000001f9fec0] [c00000000006ce20] .__do_softirq+0xe8/0x1f8
[    0.659698] [c000000001f9ff90] [c00000000002ac04] .call_do_softirq+0x14/0x24
[    0.659704] [c0000000fe257db0] [c00000000000d4fc] .do_softirq+0x90/0x110
[    0.659711] [c0000000fe257e50] [c00000000006c49c] .ksoftirqd+0xbc/0x18c
[    0.659718] [c0000000fe257f00] [c000000000081cec] .kthread+0x80/0xcc
[    0.659725] [c0000000fe257f90] [c00000000002adc8] .kernel_thread+0x54/0x70
[    0.659733] Testing a saved backtrace.
[    0.659736] The following trace is a kernel self test and not a bug!
[    0.659741]  [<c0000000000a680c>] .backtrace_regression_test+0xf8/0x134
[    0.659747]  [<c000000000009254>] .do_one_initcall+0x80/0x1a4
[    0.659753]  [<c000000000700370>] .kernel_init+0x1a8/0x224
[    0.659759]  [<c00000000002adc8>] .kernel_thread+0x54/0x70
[    0.659764] ====[ end of backtrace testing ]====
[    0.659795] audit: initializing netlink socket (disabled)
[    0.659810] type=2000 audit(1236686641.658:1): initialized
[    0.679339] Kprobe smoke test started
[    0.890631] Kprobe smoke test passed successfully
[    0.890700] rcu-torture:--- Start of test: nreaders=8 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
[    0.891677] HugeTLB registered 16 MB page size, pre-allocated 0 pages
[    0.891682] HugeTLB registered 16 GB page size, pre-allocated 0 pages
[    0.892086] VFS: Disk quotas dquot_6.5.2
[    0.892203] Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
[    0.892884] msgmni has been set to 7556
[    0.893258] alg: No test for stdrng (krng)
[    0.893329] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.893335] io scheduler noop registered
[    0.893339] io scheduler anticipatory registered
[    0.893343] io scheduler deadline registered
[    0.893396] io scheduler cfq registered (default)
[    0.893490] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.893495] rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
[    0.895965] Generic RTC Driver v1.07
[    0.895999] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.896309] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    0.896362] Uniform Multi-Platform E-IDE driver
[    0.896423] ide-gd driver 1.18
[    0.896625] ibmvscsi 30000002: SRP_VERSION: 16.a
[    0.896717] scsi0 : IBM POWER Virtual SCSI Adapter 1.5.8
[    0.896983] ibmvscsi 30000002: partner initialization complete
[    0.896991] ibmvscsi 30000002: sent SRP login
[    0.897062] ibmvscsi 30000002: SRP_LOGIN succeeded
[    0.897104] ibmvscsi 30000002: host srp version: 16.a, host partition VIO (1), OS 3, max io 1048576
[    0.910829] scsi 0:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
[    0.911151] scsi 0:0:2:0: CD-ROM            AIX      VOPTA                 PQ: 0 ANSI: 4
[    0.966517] ibmvfc: IBM Virtual Fibre Channel Driver version: 1.0.4 (November 14, 2008)
[    0.966616] scsi 0:0:1:0: Attached scsi generic sg0 type 0
[    0.966661] scsi 0:0:2:0: Attached scsi generic sg1 type 5
[    0.966739] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.966793] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.966835] uhci_hcd: USB Universal Host Controller Interface driver
[    1.000469] mice: PS/2 mouse device common for all mice
[    1.040547] EDAC MC: Ver: 2.1.0 Mar 10 2009
[    1.041711] usbcore: registered new interface driver hiddev
[    1.041743] usbcore: registered new interface driver usbhid
[    1.041749] usbhid: v2.6:USB HID core driver
[    1.042399] TCP cubic registered
[    1.042405] NET: Registered protocol family 15
[    1.042574] registered taskstats version 1
[    1.042745] Freeing unused kernel memory: 384k freed
doing fast boot
[    1.074740] SysRq : Changing Loglevel
[    1.074747] Loglevel set to 1
FATAL: Module ibmvscsic not found.
Creating device nodes with udev
Boot logging started on /dev/hvc0(/dev/console) at Tue Mar 10 12:04:02 2009


--------------070400040505070306040302--
