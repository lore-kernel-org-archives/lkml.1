Return-Path: <linux-kernel-owner+w=401wt.eu-S1161117AbXB0Jor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161117AbXB0Jor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 04:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161114AbXB0Jor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 04:44:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44354 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161118AbXB0Jom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 04:44:42 -0500
Date: Tue, 27 Feb 2007 10:38:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: regression: forcedeth.c hang
Message-ID: <20070227093817.GA5007@elte.hu>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070225175247.GB12392@stusta.de> <20070227083918.GC30376@elte.hu> <20070227090106.GA2749@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070227090106.GA2749@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> git bisection gives:
> 
> | 0d63fb32b2b8c3464d9c1afc3ce3fd3ceec025b6 is first bad commit

> but i think this is simply the first commit that makes the driver 
> essentially non-bisectable - the failures in interim iterations 
> changed from 'interface unusable' to boot hangs that were either 
> forcedeth tx ring timeouts, or hangs after nv_sata initialization.

here's the boot log of the tx_ring timeout that happens at the following 
commit in the first step of bisection:

 commit aaa37d2d099f97ced415546e285ac901e47a2437
 Author: Ayaz Abdulla <aabdulla@nvidia.com>
 Date:   Sun Jan 21 18:10:42 2007 -0500

     forcedeth: tx limiting

(eth0/eth1 gets flipped during network startup, so eth1 is the forcedeth 
driver)

	Ingo

---------------------->
Linux version 2.6.21-rc1-syslet-v5 (mingo@dione) (gcc version 4.0.2) #8 SMP PREEMPT Tue Feb 27 10:33:37 CET 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009f800 end: 000000000009f800 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009f800 size: 0000000000000800 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000003fef0000 end: 000000003fff0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000003fff0000 size: 0000000000003000 end: 000000003fff3000 type: 4
copy_e820_map() start: 000000003fff3000 size: 000000000000d000 end: 0000000040000000 type: 3
copy_e820_map() start: 00000000e0000000 size: 0000000010000000 end: 00000000f0000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000001400000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f5680
Entering add_active_range(0, 0, 262128) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262128
early_node_map[1] active PFN ranges
    0:        0 ->   262128
On node 0 totalpages: 262128
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4040 pages, LIFO batch:0
  Normal zone: 3080 pages used for memmap
  Normal zone: 222200 pages, LIFO batch:31
  HighMem zone: 447 pages used for memmap
  HighMem zone: 32305 pages, LIFO batch:7
DMI 2.3 present.
Using APIC driver default
ACPI: RSDP 000F76F0, 0014 (r0 Nvidia)
ACPI: RSDT 3FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 3FFF3180, 6264 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 3FFF0000, 0040
ACPI: SRAT 3FFF9500, 00A0 (r1 AMD    HAMMER          1 AMD         1)
ACPI: MCFG 3FFF9600, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 3FFF9440, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:3 APIC version 16
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:3 APIC version 16
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
Detected 2160.240 MHz processor.
Built 1 zonelists.  Total pages: 258545
Kernel command line: root=/dev/hda1 console=ttyS0,115200 console=tty 3 debug idle=poll profile=schedule initcall_debug maxcpus=2 selinux=1 enforcing=0 apic=verbose ignore_loglevel
using polling idle threads.
kernel schedule profiling enabled (shift: 0)
debug: ignoring loglevel setting.
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0638000 soft=c0658000
PID hash table entries: 4096 (order: 12, 16384 bytes)
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1096 kB
 per task-struct memory footprint: 1200 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |  ok  |
           recursive read-lock #2:             |  ok  |             |  ok  |
            mixed read-write-lock:             |  ok  |             |  ok  |
            mixed write-read-lock:             |  ok  |             |  ok  |
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1010344k/1048512k available (3282k kernel code, 37492k reserved, 1710k data, 308k init, 131008k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc56000 - 0xfffff000   (3748 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc05e6000 - 0xc0633000   ( 308 kB)
      .data : 0xc0434b9a - 0xc05e04f0   (1710 kB)
      .text : 0xc0100000 - 0xc0434b9a   (3282 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4322.31 BogoMIPS (lpj=2161157)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000003
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0(2) -> Core 0
CPU: After all inits, caps: 178bfbff e3d3fbff 00000000 00000410 00000001 00000000 00000003
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
lockdep: not fixing up alternatives.
ACPI: Core revision 20070126
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
enabled ExtINT on CPU#0
lockdep: not fixing up alternatives.
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=c0639000 soft=c0659000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 4319.78 BogoMIPS (lpj=2159892)
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000003
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(2) -> Core 1
CPU: After all inits, caps: 178bfbff e3d3fbff 00000000 00000410 00000001 00000000 00000003
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
Total of 2 processors activated (8642.09 BogoMIPS).
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1349919
... PM timer delta = 357899
... PM timer result ok
..... delta 1349919
..... mult: 57987393
..... calibration result: 215987
..... CPU clock speed is 2159.0869 MHz.
..... host bus clock speed is 215.0987 MHz.
... verify APIC timer
... jiffies delta = 100
... PM timer delta = 357896
... PM timer result ok
Brought up 2 CPUs
migration_cost=151
Calling initcall 0xc06069f6: init_cpufreq_transition_notifier_list+0x0/0x11()
Calling initcall 0xc05ee584: cpufreq_tsc+0x0/0x11()
Calling initcall 0xc05f0ec1: acpisleep_dmi_init+0x0/0x11()
Calling initcall 0xc05f1097: reboot_init+0x0/0x11()
Calling initcall 0xc05f618a: print_banner+0x0/0xd()
Booting paravirtualized kernel on bare hardware
Calling initcall 0xc05f7973: sysctl_init+0x0/0x13()
Calling initcall 0xc05f7fda: helper_init+0x0/0x25()
Calling initcall 0xc05f83ef: pm_init+0x0/0x22()
Calling initcall 0xc05f8411: pm_disk_init+0x0/0x14()
Calling initcall 0xc05f883b: ksysfs_init+0x0/0x22()
Calling initcall 0xc05faa40: filelock_init+0x0/0x37()
Calling initcall 0xc05fb3d1: init_misc_binfmt+0x0/0x33()
Calling initcall 0xc05fb404: init_script_binfmt+0x0/0xf()
Calling initcall 0xc05fb413: init_elf_binfmt+0x0/0xf()
Calling initcall 0xc05fbdb5: debugfs_init+0x0/0x3d()
Calling initcall 0xc05fc2aa: securityfs_init+0x0/0x3d()
Calling initcall 0xc05fd128: random32_init+0x0/0x42()
Calling initcall 0xc0606a07: cpufreq_core_init+0x0/0x56()
Calling initcall 0xc0608c0e: sock_init+0x0/0x5f()
Calling initcall 0xc06094bc: netlink_proto_init+0x0/0x12a()
NET: Registered protocol family 16
Calling initcall 0xc05fd04f: kobject_uevent_init+0x0/0x3c()
Calling initcall 0xc05fd280: pcibus_class_init+0x0/0xf()
Calling initcall 0xc05fd7ea: pci_driver_init+0x0/0xf()
Calling initcall 0xc05fde19: backlight_class_init+0x0/0xf()
Calling initcall 0xc06013dd: tty_class_init+0x0/0x23()
Calling initcall 0xc0601a90: vtconsole_class_init+0x0/0xb5()
Calling initcall 0xc05eedeb: mtrr_if_init+0x0/0x57()
Calling initcall 0xc05f0f87: ffh_cstate_init+0x0/0x2c()
initcall at 0xc05f0f87: ffh_cstate_init+0x0/0x2c(): returned with error code -1
Calling initcall 0xc05fd985: acpi_pci_init+0x0/0x29()
ACPI: bus type pci registered
Calling initcall 0xc05ff37b: init_acpi_device_notify+0x0/0x45()
Calling initcall 0xc06076b3: pci_access_init+0x0/0x41()
PCI: Using MMCONFIG
PCI: No mmconfig possible on device 00:18
Calling initcall 0xc05edea0: request_standard_resources+0x0/0x2d0()
Setting up standard PCI resources
Calling initcall 0xc05ee25a: topology_init+0x0/0x2f()
Calling initcall 0xc05eeb91: mtrr_init_finialize+0x0/0x2c()
Calling initcall 0xc05f7de0: param_sysfs_init+0x0/0x175()
Calling initcall 0xc0151535: pm_sysrq_init+0x0/0x17()
Calling initcall 0xc05fb0bb: init_bio+0x0/0xfc()
Calling initcall 0xc05fce58: genhd_device_init+0x0/0x50()
Calling initcall 0xc05fd9ae: fbmem_init+0x0/0x87()
Calling initcall 0xc05ff17c: acpi_init+0x0/0x1ff()
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
Calling initcall 0xc05ff3c0: acpi_scan_init+0x0/0xfc()
Calling initcall 0xc05ff561: acpi_ec_init+0x0/0x55()
Calling initcall 0xc05ff8a5: acpi_pci_root_init+0x0/0x25()
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:09.0
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
Calling initcall 0xc05ff99e: acpi_pci_link_init+0x0/0x43()
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
Calling initcall 0xc05ffa78: acpi_power_init+0x0/0x69()
Calling initcall 0xc05ffc44: acpi_system_init+0x0/0xad()
Calling initcall 0xc05ffcf1: acpi_event_init+0x0/0x38()
Calling initcall 0xc05ffd29: acpi_cm_sbs_init+0x0/0x7()
Calling initcall 0xc05ffd30: pnp_init+0x0/0x1c()
Linux Plug and Play Support v0.97 (c) Adam Belay
Calling initcall 0xc05ffe83: pnpacpi_init+0x0/0x69()
pnp: PnP ACPI init
pnp: PnP ACPI: found 16 devices
Calling initcall 0xc06017f8: misc_init+0x0/0x79()
Calling initcall 0xc02a5eb4: cn_init+0x0/0xb8()
Calling initcall 0xc0604701: init_scsi+0x0/0x8f()
SCSI subsystem initialized
Calling initcall 0xc0604e63: ata_init+0x0/0x6c()
libata version 2.20 loaded.
Calling initcall 0xc0605aa5: init_pcmcia_cs+0x0/0x31()
Calling initcall 0xc0605f76: usb_init+0x0/0x103()
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Calling initcall 0xc0606309: serio_init+0x0/0x8d()
Calling initcall 0xc06066e3: input_init+0x0/0x101()
Calling initcall 0xc0606a87: leds_init+0x0/0x23()
Calling initcall 0xc060740d: dma_bus_init+0x0/0x23()
Calling initcall 0xc060820c: pci_acpi_init+0x0/0x9b()
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
number of MP IRQ sources: 16.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................
IO APIC #2......
.... register #00: 00000000
.......    : physical APIC id: 00
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
 00 003 03  0    0    0   0   0    1    1    31
 01 003 03  1    0    0   0   0    1    1    39
 02 003 03  0    0    0   0   0    1    1    41
 03 003 03  1    0    0   0   0    1    1    49
 04 003 03  1    0    0   0   0    1    1    51
 05 003 03  1    0    0   0   0    1    1    59
 06 003 03  1    0    0   0   0    1    1    61
 07 003 03  1    0    0   0   0    1    1    69
 08 003 03  1    0    0   0   0    1    1    71
 09 003 03  0    1    0   0   0    1    1    79
 0a 003 03  1    0    0   0   0    1    1    81
 0b 003 03  1    0    0   0   0    1    1    89
 0c 003 03  1    0    0   0   0    1    1    91
 0d 003 03  1    0    0   0   0    1    1    99
 0e 003 03  0    0    0   0   0    1    1    A1
 0f 003 03  0    0    0   0   0    1    1    A9
 10 000 00  1    0    0   0   0    0    0    00
 11 000 00  1    0    0   0   0    0    0    00
 12 000 00  1    0    0   0   0    0    0    00
 13 000 00  1    0    0   0   0    0    0    00
 14 000 00  1    0    0   0   0    0    0    00
 15 000 00  1    0    0   0   0    0    0    00
 16 000 00  1    0    0   0   0    0    0    00
 17 000 00  1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ2 -> 0:2
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
Calling initcall 0xc06082a7: pci_legacy_init+0x0/0x105()
Calling initcall 0xc0608740: pcibios_irq_init+0x0/0x452()
Calling initcall 0xc0608b92: pcibios_init+0x0/0x7c()
Calling initcall 0xc0608cc3: proto_init+0x0/0x2e()
Calling initcall 0xc0608e13: net_dev_init+0x0/0x200()
Calling initcall 0xc060927d: wireless_nlevent_init+0x0/0x39()
Calling initcall 0xc06092b6: fib_rules_init+0x0/0xf()
Calling initcall 0xc06093ac: pktsched_init+0x0/0x91()
Calling initcall 0xc060944c: tc_filter_init+0x0/0x38()
Calling initcall 0xc0609484: tc_action_init+0x0/0x38()
Calling initcall 0xc06095e6: genl_init+0x0/0x9f()
Calling initcall 0xc060a7a9: cipso_v4_init+0x0/0x76()
Calling initcall 0xc060ab56: netlbl_init+0x0/0x71()
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Calling initcall 0xc05fa9ca: init_pipe_fs+0x0/0x3f()
Calling initcall 0xc05ffe0c: pnp_system_init+0x0/0xf()
pnp: 00:01: ioport range 0x4000-0x407f has been reserved
pnp: 00:01: ioport range 0x4080-0x40ff has been reserved
pnp: 00:01: ioport range 0x4400-0x447f has been reserved
pnp: 00:01: ioport range 0x4480-0x44ff has been reserved
pnp: 00:01: ioport range 0x4800-0x487f has been reserved
pnp: 00:01: ioport range 0x4880-0x48ff has been reserved
pnp: 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
pnp: 00:0f: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:0f: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:0f: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:0f: iomem range 0xfc000-0xfffff could not be reserved
Calling initcall 0xc06012f8: chr_dev_init+0x0/0x86()
Calling initcall 0xc0602e67: firmware_class_init+0x0/0x66()
Calling initcall 0xc0605ad6: init_pcmcia_bus+0x0/0x76()
Calling initcall 0xc0606a5d: cpufreq_gov_performance_init+0x0/0xf()
Calling initcall 0xc0606a6c: cpufreq_gov_userspace_init+0x0/0x1b()
Calling initcall 0xc0607430: pcibios_assign_resources+0x0/0x92()
PCI: Bridge: 0000:00:09.0
  IO window: a000-afff
  MEM window: da000000-da0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0e.0
  IO window: 9000-9fff
  MEM window: d8000000-d9ffffff
  PREFETCH window: d0000000-d7ffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
Calling initcall 0xc060a1ae: inet_init+0x0/0x390()
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 65536 (order: 9, 2621440 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
Calling initcall 0xc05ec1a0: populate_rootfs+0x0/0xe4()
Calling initcall 0xc05ed0fd: i8259A_init_sysfs+0x0/0x1d()
Calling initcall 0xc05ed1fd: sbf_init+0x0/0xd7()
Calling initcall 0xc05ee23d: i8237A_init_sysfs+0x0/0x1d()
Calling initcall 0xc05ee50a: init_pit_clocksource+0x0/0x63()
Calling initcall 0xc05ee5bb: init_tsc_clocksource+0x0/0xd1()
Calling initcall 0xc010ded3: cache_sysfs_init+0x0/0x4d()
Calling initcall 0xc05eeb03: thermal_throttle_init_device+0x0/0x8e()
Calling initcall 0xc05ef94b: longrun_init+0x0/0x28()
Calling initcall 0xc05efce7: speedstep_init+0x0/0x24d()
Calling initcall 0xc05eff34: speedstep_init+0x0/0x107()
Calling initcall 0xc05f15ff: apm_init+0x0/0x3c7()
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
Calling initcall 0xc05f2c99: init_lapic_sysfs+0x0/0x28()
Calling initcall 0xc05f3d40: ioapic_init_sysfs+0x0/0xb6()
Calling initcall 0xc05f5eb9: init_hpet_clocksource+0x0/0x5f()
Calling initcall 0xc05f6197: add_pcspkr+0x0/0x35()
Calling initcall 0xc05f7696: create_proc_profile+0x0/0x176()
Calling initcall 0xc05f7880: ioresources_init+0x0/0x39()
Calling initcall 0xc05f7986: timekeeping_init_device+0x0/0x1d()
Calling initcall 0xc05f7b4c: uid_cache_init+0x0/0x6e()
Calling initcall 0xc05f7f55: init_posix_timers+0x0/0x85()
Calling initcall 0xc05f7fff: init_posix_cpu_timers+0x0/0x51()
Calling initcall 0xc05f8075: latency_init+0x0/0x20()
Calling initcall 0xc05f80a6: init_clocksource_sysfs+0x0/0x43()
Calling initcall 0xc05f8176: init_jiffies_clocksource+0x0/0xf()
Calling initcall 0xc05f8185: init_timer_list_procfs+0x0/0x2a()
Calling initcall 0xc05f81af: clockevents_sysfs_init+0x0/0x30()
Calling initcall 0xc05f82f9: lockdep_proc_init+0x0/0x3f()
Calling initcall 0xc05f8338: init+0x0/0x74()
Calling initcall 0xc014929e: init_rttest+0x0/0x10c()
Initializing RT-Tester: OK
Calling initcall 0xc05f83ac: proc_dma_init+0x0/0x20()
Calling initcall 0xc014a405: percpu_modinit+0x0/0x65()
Calling initcall 0xc05f83cc: kallsyms_init+0x0/0x23()
Calling initcall 0xc05f84aa: snapshot_device_init+0x0/0xf()
Calling initcall 0xc05f84b9: crash_notes_memory_init+0x0/0x38()
Calling initcall 0xc05f8676: audit_init+0x0/0x10d()
audit: initializing netlink socket (disabled)
audit(1172571348.203:1): initialized
Calling initcall 0xc05f87f8: init_kprobes+0x0/0x43()
Calling initcall 0xc05f890b: relay_init+0x0/0x11()
Calling initcall 0xc05f891c: utsname_sysctl_init+0x0/0x11()
Calling initcall 0xc05f97ec: init_per_zone_pages_min+0x0/0x3c()
Calling initcall 0xc05fa169: pdflush_init+0x0/0x16()
Calling initcall 0xc05fa1a3: kswapd_init+0x0/0x26()
Calling initcall 0xc05fa1c9: setup_vmstat+0x0/0x16()
Calling initcall 0xc05fa2a9: init_emergency_pool+0x0/0x62()
highmem bounce pool size: 64 pages
Calling initcall 0xc05fa30b: procswaps_init+0x0/0x20()
Calling initcall 0xc05fa32b: hugetlb_init+0x0/0x59()
Total HugeTLB memory allocated, 0
Calling initcall 0xc05fa3ba: init_tmpfs+0x0/0xbf()
Calling initcall 0xc05fa48d: cpucache_init+0x0/0x2f()
Calling initcall 0xc05faa09: fasync_init+0x0/0x37()
Calling initcall 0xc05fafea: aio_setup+0x0/0x77()
Calling initcall 0xc05fb22d: inotify_setup+0x0/0x11()
Calling initcall 0xc05fb23e: inotify_user_setup+0x0/0xc3()
Calling initcall 0xc05fb301: eventpoll_init+0x0/0xd0()
Calling initcall 0xc05fb422: init_mbcache+0x0/0x1b()
Calling initcall 0xc05fb43d: dquot_init+0x0/0xf2()
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Calling initcall 0xc05fb52f: init_v2_quota_format+0x0/0xf()
Calling initcall 0xc05fb53e: dnotify_init+0x0/0x37()
Calling initcall 0xc05fb953: init_devpts_fs+0x0/0x30()
Calling initcall 0xc05fb983: init_ext3_fs+0x0/0x6e()
Calling initcall 0xc05fbab1: journal_init+0x0/0xd8()
Calling initcall 0xc05fbb89: init_ext2_fs+0x0/0x6e()
Calling initcall 0xc05fbc2b: init_ramfs_fs+0x0/0xf()
Calling initcall 0xc05fbc49: init_hugetlbfs_fs+0x0/0x7d()
Calling initcall 0xc05fbcc6: init_iso9660_fs+0x0/0x70()
Calling initcall 0xc05fbd97: init_nls_cp437+0x0/0xf()
Calling initcall 0xc05fbda6: init_nls_ascii+0x0/0xf()
Calling initcall 0xc05fbdf2: ipc_init+0x0/0x16()
Calling initcall 0xc05fc013: ipc_sysctl_init+0x0/0x11()
Calling initcall 0xc05fc024: init_mqueue_fs+0x0/0xc2()
Calling initcall 0xc05fc21c: key_proc_init+0x0/0x4f()
Calling initcall 0xc05fc3c8: selinux_nf_ip_init+0x0/0x57()
SELinux:  Registering netfilter hooks
Calling initcall 0xc05fc573: init_sel_fs+0x0/0x52()
Calling initcall 0xc05fc5c5: selnl_init+0x0/0x44()
Calling initcall 0xc05fc609: sel_netif_init+0x0/0x6d()
Calling initcall 0xc05fc676: aurule_init+0x0/0x46()
Calling initcall 0xc05fc6bc: crypto_algapi_init+0x0/0xc()
Calling initcall 0xc05fc6e6: cryptomgr_init+0x0/0xf()
Calling initcall 0xc05fc6f5: hmac_module_init+0x0/0xf()
Calling initcall 0xc05fc704: crypto_xcbc_module_init+0x0/0xf()
Calling initcall 0xc05fc713: init+0x0/0x4d()
Calling initcall 0xc05fc760: init+0x0/0xf()
Calling initcall 0xc05fc76f: init+0x0/0xf()
Calling initcall 0xc05fc77e: init+0x0/0xf()
Calling initcall 0xc05fc78d: init+0x0/0xf()
Calling initcall 0xc05fc79c: init+0x0/0x33()
Calling initcall 0xc05fc7cf: init+0x0/0x52()
Calling initcall 0xc05fc821: init+0x0/0x52()
Calling initcall 0xc05fc873: crypto_ecb_module_init+0x0/0xf()
Calling initcall 0xc05fc882: crypto_cbc_module_init+0x0/0xf()
Calling initcall 0xc05fc891: crypto_module_init+0x0/0xf()
Calling initcall 0xc05fc8a0: init+0x0/0x33()
Calling initcall 0xc05fc8d3: init+0x0/0xf()
Calling initcall 0xc05fc8e2: init+0x0/0xf()
Calling initcall 0xc05fc8f1: init+0x0/0x33()
Calling initcall 0xc05fc924: aes_init+0x0/0x2db()
Calling initcall 0xc05fcbff: init+0x0/0xf()
Calling initcall 0xc05fcc0e: init+0x0/0xf()
Calling initcall 0xc05fcc1d: arc4_init+0x0/0xf()
Calling initcall 0xc05fcc2c: init+0x0/0x52()
Calling initcall 0xc05fcc7e: init+0x0/0xf()
Calling initcall 0xc05fcc8d: init+0x0/0xf()
Calling initcall 0xc05fcc9c: init+0x0/0xf()
Calling initcall 0xc05fccab: michael_mic_init+0x0/0xf()
Calling initcall 0xc05fccba: init+0x0/0xf()
Calling initcall 0xc05fcea8: noop_init+0x0/0xf()
io scheduler noop registered
Calling initcall 0xc05fceb7: as_init+0x0/0xf()
io scheduler anticipatory registered
Calling initcall 0xc05fcec6: deadline_init+0x0/0xf()
io scheduler deadline registered (default)
Calling initcall 0xc05fced5: cfq_init+0x0/0xb6()
io scheduler cfq registered
Calling initcall 0xc05fcf8b: blk_trace_init+0x0/0xc4()
Calling initcall 0xc05fd1d4: audit_classes_init+0x0/0x40()
Calling initcall 0xc024643c: pci_init+0x0/0x2c()
PCI: Found disabled HT MSI Mapping on 0000:00:0b.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0b.0
PCI: Found disabled HT MSI Mapping on 0000:00:0c.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0c.0
PCI: Found disabled HT MSI Mapping on 0000:00:0d.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0d.0
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0e.0
Calling initcall 0xc05fd7f9: pci_sysfs_init+0x0/0x35()
Calling initcall 0xc05fd82e: pci_proc_init+0x0/0x5f()
Calling initcall 0xc05fd88d: pcie_portdrv_init+0x0/0x46()
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
Allocate Port Service[0000:00:0b.0:pcie03]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
Allocate Port Service[0000:00:0c.0:pcie03]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
Allocate Port Service[0000:00:0d.0:pcie03]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Allocate Port Service[0000:00:0e.0:pcie03]
Calling initcall 0xc05fd8d3: aer_service_init+0x0/0xf()
Calling initcall 0xc05fd8e2: pci_hotplug_init+0x0/0x57()
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Calling initcall 0xc05fdaca: fb_console_init+0x0/0x113()
Calling initcall 0xc05fe4de: vesafb_init+0x0/0x271()
Calling initcall 0xc05fea9c: acpi_reserve_resources+0x0/0xc8()
Calling initcall 0xc05ff854: acpi_fan_init+0x0/0x51()
ACPI: Fan [FAN] (on)
Calling initcall 0xc05ff96b: irqrouter_init_sysfs+0x0/0x33()
Calling initcall 0xc05ffae1: acpi_processor_init+0x0/0xcd()
Calling initcall 0xc05ffbae: acpi_container_init+0x0/0x45()
Calling initcall 0xc05ffbf3: acpi_thermal_init+0x0/0x51()
ACPI: Thermal Zone [THRM] (40 C)
Calling initcall 0xc0600dcc: isapnp_init+0x0/0x43f()
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Calling initcall 0xc060138c: rand_initialize+0x0/0x25()
Calling initcall 0xc0601400: tty_init+0x0/0x1c9()
Calling initcall 0xc06015c9: pty_init+0x0/0x22f()
Calling initcall 0xc0601d7e: rtc_init+0x0/0x1b7()
Real Time Clock Driver v1.12ac
Calling initcall 0xc0601f35: hpet_init+0x0/0x57()
Calling initcall 0xc0601f8c: nvram_init+0x0/0x7c()
Non-volatile memory driver v1.2
Calling initcall 0xc0602008: agp_init+0x0/0x2f()
Linux agpgart interface v0.102 (c) Dave Jones
Calling initcall 0xc060209b: agp_ali_init+0x0/0x24()
Calling initcall 0xc06020bf: agp_ati_init+0x0/0x24()
Calling initcall 0xc06020e3: agp_amdk7_init+0x0/0x24()
Calling initcall 0xc0602107: agp_amd64_init+0x0/0xa7()
Calling initcall 0xc06021ae: agp_efficeon_init+0x0/0x39()
Calling initcall 0xc06021e7: agp_intel_init+0x0/0x24()
Calling initcall 0xc060220b: agp_nvidia_init+0x0/0x24()
Calling initcall 0xc060222f: agp_sis_init+0x0/0x24()
Calling initcall 0xc0602253: agp_serverworks_init+0x0/0x24()
Calling initcall 0xc0602277: agp_via_init+0x0/0x24()
Calling initcall 0xc060229b: cn_proc_init+0x0/0x31()
Calling initcall 0xc0602714: serial8250_init+0x0/0x112()
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
�serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Calling initcall 0xc0602826: serial8250_pnp_init+0x0/0xf()
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Calling initcall 0xc0602835: serial8250_pci_init+0x0/0x16()
Calling initcall 0xc0602e34: isa_bus_init+0x0/0x33()
Calling initcall 0xc02b39d9: topology_sysfs_init+0x0/0x3d()
Calling initcall 0xc0602ecd: rd_init+0x0/0x18d()
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
Calling initcall 0xc06030ac: loop_init+0x0/0x27a()
loop: loaded (max 8 devices)
Calling initcall 0xc0603326: init_cryptoloop+0x0/0x27()
Calling initcall 0xc060334d: e1000_init_module+0x0/0x80()
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
Calling initcall 0xc06033cd: e100_init_module+0x0/0x5a()
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
Calling initcall 0xc0603427: tg3_init+0x0/0x16()
Calling initcall 0xc060343d: skge_init_module+0x0/0x16()
Calling initcall 0xc0603494: net_olddevs_init+0x0/0x89()
Calling initcall 0xc060351d: loopback_init+0x0/0xf()
Calling initcall 0xc060352c: init_nic+0x0/0x2c()
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.59.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 23 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
eth0: forcedeth.c: subsystem: 01043:8141 bound to 0000:00:0a.0
Calling initcall 0xc0603558: cp_init+0x0/0x16()
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
8139cp 0000:05:07.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
8139cp 0000:05:07.0: Try the "8139too" driver instead.
Calling initcall 0xc060356e: rtl8139_init_module+0x0/0x16()
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
ACPI: PCI Interrupt 0000:05:07.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
eth1: RealTek RTL8139 at 0xa000, 00:c0:df:03:68:5d, IRQ 17
eth1:  Identified 8139 chip type 'RTL-8139B'
Calling initcall 0xc0603584: aec62xx_ide_init+0x0/0x16()
Calling initcall 0xc060359a: ali15x3_ide_init+0x0/0x16()
Calling initcall 0xc06035b0: amd74xx_ide_init+0x0/0x16()
Calling initcall 0xc06035c6: atiixp_ide_init+0x0/0x16()
Calling initcall 0xc06035dc: cmd64x_ide_init+0x0/0x16()
Calling initcall 0xc06035f2: cs5520_ide_init+0x0/0x16()
Calling initcall 0xc0603608: cs5530_ide_init+0x0/0x16()
Calling initcall 0xc060361e: cs5535_ide_init+0x0/0x16()
Calling initcall 0xc0603634: hpt34x_ide_init+0x0/0x16()
Calling initcall 0xc060364a: hpt366_ide_init+0x0/0x16()
Calling initcall 0xc0603660: it821x_ide_init+0x0/0x16()
Calling initcall 0xc0603676: pdc202xx_ide_init+0x0/0x16()
Calling initcall 0xc060368c: pdc202new_ide_init+0x0/0x16()
Calling initcall 0xc06036a2: piix_ide_init+0x0/0xba()
Calling initcall 0xc060375c: rz1000_ide_init+0x0/0x16()
Calling initcall 0xc0603772: svwks_ide_init+0x0/0x16()
Calling initcall 0xc0603788: siimage_ide_init+0x0/0x16()
Calling initcall 0xc060379e: sis5513_ide_init+0x0/0x16()
Calling initcall 0xc06037b4: triflex_ide_init+0x0/0x16()
Calling initcall 0xc06037ca: via_ide_init+0x0/0x16()
Calling initcall 0xc0603801: generic_ide_init+0x0/0x16()
Calling initcall 0xc0603f0a: ide_init+0x0/0x8a()
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-CK804: IDE controller at PCI slot 0000:00:06.0
NFORCE-CK804: chipset revision 242
NFORCE-CK804: not 100% native mode: will probe irqs later
NFORCE-CK804: 0000:00:06.0 (rev f2) UDMA133 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: MAXTOR 6L040J2, ATA DISK drive
hdb: ST380011A, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Calling initcall 0xc06046c5: ide_generic_init+0x0/0x11()
Probing IDE interface ide1...
Calling initcall 0xc06046d6: idedisk_init+0x0/0xf()
hda: max request size: 128KiB
hda: 78177792 sectors (40027 MB) w/1818KiB Cache, CHS=65535/16/63, UDMA(133)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 >
hdb: max request size: 512KiB
hdb: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=16383/255/63, UDMA(100)
hdb: cache flushes supported
 hdb: hdb1 hdb2 hdb3 < hdb5 >
Calling initcall 0xc06046e5: idefloppy_init+0x0/0x1c()
ide-floppy driver 0.99.newide
Calling initcall 0xc060495c: spi_transport_init+0x0/0x27()
Calling initcall 0xc0604983: sas_transport_init+0x0/0x9f()
Calling initcall 0xc0604a22: sas_class_init+0x0/0x3d()
Calling initcall 0xc0604a5f: ahc_linux_init+0x0/0x5c()
Calling initcall 0xc0604abb: ahd_linux_init+0x0/0x6e()
Calling initcall 0xc0604b29: aic94xx_init+0x0/0x12e()
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
Calling initcall 0xc0604c57: init_sd+0x0/0xd6()
Calling initcall 0xc0604d2d: init_sg+0x0/0x12a()
Calling initcall 0xc0604ecf: ahci_init+0x0/0x16()
Calling initcall 0xc0604ee5: k2_sata_init+0x0/0x16()
Calling initcall 0xc0604efb: piix_init+0x0/0x27()
Calling initcall 0xc0604f22: pdc_ata_init+0x0/0x16()
Calling initcall 0xc0604f38: qs_ata_init+0x0/0x16()
Calling initcall 0xc0604f4e: sil_init+0x0/0x16()
Calling initcall 0xc0604f64: sil24_init+0x0/0x16()
Calling initcall 0xc0604f7a: svia_init+0x0/0x16()
Calling initcall 0xc0604f90: vsc_sata_init+0x0/0x16()
Calling initcall 0xc0604fa6: sis_init+0x0/0x16()
Calling initcall 0xc0604fbc: pdc_sata_init+0x0/0x16()
Calling initcall 0xc0604fd2: nv_init+0x0/0x16()
sata_nv 0000:00:07.0: version 3.3
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 22 (level, low) -> IRQ 18
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
ata1: SATA max UDMA/133 cmd 0xf881c480 ctl 0xf881c4a0 bmdma 0x0001d800 irq 18
ata2: SATA max UDMA/133 cmd 0xf881c580 ctl 0xf881c5a0 bmdma 0x0001d808 irq 18
scsi0 : sata_nv
ata1: SATA link down (SStatus 0 SControl 300)
scsi1 : sata_nv
ata2: SATA link down (SStatus 0 SControl 300)
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 21 (level, low) -> IRQ 19
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
ata3: SATA max UDMA/133 cmd 0xf881e480 ctl 0xf881e4a0 bmdma 0x0001c400 irq 19
ata4: SATA max UDMA/133 cmd 0xf881e580 ctl 0xf881e5a0 bmdma 0x0001c408 irq 19
scsi2 : sata_nv
ata3: SATA link down (SStatus 0 SControl 300)
scsi3 : sata_nv
ata4: SATA link down (SStatus 0 SControl 300)
Calling initcall 0xc0604fe8: uli_init+0x0/0x16()
Calling initcall 0xc0604ffe: mv_init+0x0/0x16()
Calling initcall 0xc0605014: adma_ata_init+0x0/0x16()
Calling initcall 0xc060502a: ali_init+0x0/0x16()
Calling initcall 0xc0605040: amd_init+0x0/0x16()
Calling initcall 0xc0605056: artop_init+0x0/0x16()
Calling initcall 0xc060506c: atiixp_init+0x0/0x16()
Calling initcall 0xc0605082: cmd64x_init+0x0/0x16()
Calling initcall 0xc0605098: cs5520_init+0x0/0x16()
Calling initcall 0xc06050ae: cs5530_init+0x0/0x16()
Calling initcall 0xc06050c4: cs5535_init+0x0/0x16()
Calling initcall 0xc06050da: cy82c693_init+0x0/0x16()
Calling initcall 0xc06050f0: efar_init+0x0/0x16()
Calling initcall 0xc0605106: hpt36x_init+0x0/0x16()
Calling initcall 0xc060511c: hpt37x_init+0x0/0x16()
Calling initcall 0xc0605132: hpt3x2n_init+0x0/0x16()
Calling initcall 0xc0605148: hpt3x3_init+0x0/0x16()
Calling initcall 0xc060515e: isapnp_init+0x0/0xf()
Calling initcall 0xc060516d: it821x_init+0x0/0x16()
Calling initcall 0xc0605183: jmicron_init+0x0/0x16()
Calling initcall 0xc0605199: netcell_init+0x0/0x16()
Calling initcall 0xc06051af: ns87410_init+0x0/0x16()
Calling initcall 0xc06051c5: opti_init+0x0/0x16()
Calling initcall 0xc06051db: optidma_init+0x0/0x16()
Calling initcall 0xc06051f1: marvell_init+0x0/0x16()
Calling initcall 0xc0605207: mpiix_init+0x0/0x16()
Calling initcall 0xc060521d: oldpiix_init+0x0/0x16()
Calling initcall 0xc0605233: pcmcia_init+0x0/0xf()
Calling initcall 0xc0605242: pdc2027x_init+0x0/0x16()
Calling initcall 0xc0605258: pdc202xx_init+0x0/0x16()
Calling initcall 0xc0605451: qdi_init+0x0/0x247()
Calling initcall 0xc0605698: radisys_init+0x0/0x16()
Calling initcall 0xc06056ae: rz1000_init+0x0/0x16()
Calling initcall 0xc06056c4: sc1200_init+0x0/0x16()
Calling initcall 0xc06056da: serverworks_init+0x0/0x16()
Calling initcall 0xc06056f0: sil680_init+0x0/0x16()
Calling initcall 0xc0605706: via_init+0x0/0x16()
Calling initcall 0xc060571c: sl82c105_init+0x0/0x16()
Calling initcall 0xc0605732: winbond_init+0x0/0x331()
Calling initcall 0xc0605a63: sis_init+0x0/0x16()
Calling initcall 0xc0605a79: triflex_init+0x0/0x16()
Calling initcall 0xc0605a8f: ata_generic_init+0x0/0x16()
Calling initcall 0xc0605bb8: nonstatic_sysfs_init+0x0/0xf()
Calling initcall 0xc0605bc7: yenta_socket_init+0x0/0x16()
Calling initcall 0xc0605bdd: kvm_init+0x0/0xd6()
Calling initcall 0xc0605cd7: vmx_init+0x0/0x11()
kvm: no hardware support
initcall at 0xc0605cd7: vmx_init+0x0/0x11(): returned with error code -95
Calling initcall 0xc0605dad: svm_init+0x0/0x11()
has_svm: svm not available
kvm: no hardware support
initcall at 0xc0605dad: svm_init+0x0/0x11(): returned with error code -95
Calling initcall 0xc060619b: mon_init+0x0/0x90()
Calling initcall 0xc06062db: usb_usual_init+0x0/0x2e()
usbcore: registered new interface driver libusual
Calling initcall 0xc0606396: i8042_init+0x0/0x321()
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
Calling initcall 0xc06066b7: serport_init+0x0/0x2c()
Calling initcall 0xc06067e4: mousedev_init+0x0/0xbc()
mice: PS/2 mouse device common for all mice
Calling initcall 0xc06068a0: evdev_init+0x0/0xf()
Calling initcall 0xc06068af: atkbd_init+0x0/0x16()
Calling initcall 0xc06068c5: psmouse_init+0x0/0x59()
input: AT Translated Set 2 keyboard as /class/input/input0
Calling initcall 0xc060691e: md_init+0x0/0xd8()
Calling initcall 0xc0606aaa: ledtrig_ide_init+0x0/0x16()
Calling initcall 0xc0606f79: efivars_init+0x0/0x191()
Calling initcall 0xc060710a: init_cyclone_clocksource+0x0/0x17c()
Calling initcall 0xc060729a: init_acpi_pm_clocksource+0x0/0x173()
Calling initcall 0xc06090ef: flow_cache_init+0x0/0x160()
Calling initcall 0xc06092c5: llc_init+0x0/0x53()
Calling initcall 0xc0609318: snap_init+0x0/0x2c()
Calling initcall 0xc0609344: rif_init+0x0/0x68()
Calling initcall 0xc060943d: blackhole_module_init+0x0/0xf()
Calling initcall 0xc060974e: nfnetlink_init+0x0/0x52()
Netfilter messages via NETLINK v0.30.
Calling initcall 0xc06097a0: nfnetlink_queue_init+0x0/0x88()
Calling initcall 0xc0609828: nfnetlink_log_init+0x0/0x8d()
Calling initcall 0xc060a784: init_syncookies+0x0/0x16()
Calling initcall 0xc0414dd7: ipv4_netfilter_init+0x0/0xf()
Calling initcall 0xc060a79a: bictcp_register+0x0/0xf()
TCP bic registered
Calling initcall 0xc060a9dd: xfrm_user_init+0x0/0x49()
Initializing XFRM netlink socket
Calling initcall 0xc060aa26: af_unix_init+0x0/0x64()
NET: Registered protocol family 1
Calling initcall 0xc060aa8a: packet_init+0x0/0x4c()
NET: Registered protocol family 17
Calling initcall 0xc060aad6: ipsec_pfkey_init+0x0/0x80()
NET: Registered protocol family 15
Calling initcall 0xc05ee9cb: amd_exit_cpu+0x0/0x11()
Calling initcall 0xc05eea0f: nsc_exit_cpu+0x0/0x11()
Calling initcall 0xc05ee9ed: cyrix_exit_cpu+0x0/0x11()
Calling initcall 0xc05eea31: centaur_exit_cpu+0x0/0x11()
Calling initcall 0xc05eea53: transmeta_exit_cpu+0x0/0x11()
Calling initcall 0xc05eea86: rise_exit_cpu+0x0/0x11()
Calling initcall 0xc05eeaa8: nexgen_exit_cpu+0x0/0x11()
Calling initcall 0xc05eeaca: umc_exit_cpu+0x0/0x11()
Calling initcall 0xc05ef229: powernow_init+0x0/0x10a()
Calling initcall 0xc011191d: powernowk8_init+0x0/0x78()
powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ processors (version 2.00.00)
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
Calling initcall 0xc05f003b: centrino_init+0x0/0x9e()
Calling initcall 0xc05f3aac: init_lapic_nmi_sysfs+0x0/0x33()
Calling initcall 0xc05f387b: check_nmi_watchdog+0x0/0x20a()
Calling initcall 0xc05f3d26: io_apic_bug_finalize+0x0/0x1a()
Calling initcall 0xc05f6bd4: print_ipi_mode+0x0/0x2d()
Using IPI No-Shortcut mode
Calling initcall 0xc05f8095: clocksource_done_booting+0x0/0x11()
Calling initcall 0xc014e8aa<6>Time: acpi_pm clocksource has been installed.
: software_resume+0x0/0x123()
initcall at 0xc014e8aa: software_resume+0x0/0x123(): returned with error code -2
Calling initcall 0xc0433184: debugfs_kprobe_init+0x0/0x56()
Calling initcall 0xc05f8941: taskstats_init+0x0/0x46()
Calling initcall 0xc05f9175: fail_page_alloc_debugfs+0x0/0x8f()
Calling initcall 0xc05fa4cd: failslab_debugfs+0x0/0x59()
Calling initcall 0xc05fcd31: fail_make_request_debugfs+0x0/0x14()
Calling initcall 0xc05fd16a: random32_reseed+0x0/0x4f()
Calling initcall 0xc0278ff8: acpi_poweroff_init+0x0/0x50()
Calling initcall 0xc05fef2e: acpi_wakeup_device_init+0x0/0x9c()
Calling initcall 0xc0279e25: acpi_sleep_proc_init+0x0/0x61()
Calling initcall 0xc060137e: seqgen_init+0x0/0xe()
Calling initcall 0xc0602949: early_uart_console_switch+0x0/0x7d()
Calling initcall 0xc0604e57: wait_scan_init+0x0/0xc()
Calling initcall 0xc0609f5c: tcp_congestion_default+0x0/0xf()
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 308k freed
Write protecting the kernel read-only data: 1254k
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
EXT3 FS on hda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
audit(1172567767.742:2): audit_pid=1725 old=0 by auid=4294967295 subj=kernel

Fedora Core release 4 (Stentz)
Kernel 2.6.21-rc1-syslet-v5 on an i686

neptune login: NETDEV WATCHDOG: eth1: transmit timed out
eth1: Got tx_timeout. irq: 00000000
eth1: Ring at 37f82000
eth1: Dumping tx registers
  0: 00000000 000000ff 00000003 020a03ca 00000000 00000000 00000000 00000000
 20: 06255300 ff701365 00000000 00000000 00000000 00000000 00000000 00000000
 40: 0420e20e 0000a855 00002e20 00000000 00000000 00000000 00000000 00000000
 60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
 80: 003b0f3c 00000001 00000000 007f0028 0000061c 00000001 00000000 00007fb4
 a0: 0014050f 00000016 dcd41300 00001241 005e0001 00000100 ffffffff 0000ffff
 c0: 10000002 00000001 00000001 00000001 00000001 00000001 00000001 00000001
 e0: 00000001 00000001 00000001 00000001 00000001 00000001 00000001 00000001
100: 37f82800 37f82000 007f00ff 00008000 00010032 00000000 0000000b 37f82800
120: 37f820e0 00000000 00000000 37f87494 8000061c 37f8280c 37f8200c 0fe08000
140: 00304120 80002600 00000000 00000000 00000000 00000000 00000000 00000000
160: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
180: 00000016 00000008 0994796d 00008103 0000012a 00007800 0994000f 00000003
1a0: 00000016 00000008 0994796d 00008103 0000012a 00007800 0994000f 00000003
1c0: 00000016 00000008 0994796d 00008103 0000012a 00007800 0994000f 00000003
1e0: 00000016 00000008 0994796d 00008103 0000012a 00007800 0994000f 00000003
200: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
220: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
240: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
260: 00000000 00000000 fe020001 00000100 00000000 00000000 7e020001 00000100
eth1: Dumping tx ring
000: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
004: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
008: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
00c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
010: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
014: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
018: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
01c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
020: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
024: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
028: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
02c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
030: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
034: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
038: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
03c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
040: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
044: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
048: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
04c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
050: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
054: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
058: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
05c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
060: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
064: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
068: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
06c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
070: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
074: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
078: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
07c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
080: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
084: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
088: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
08c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
090: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
094: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
098: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
09c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0a0: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0a4: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0a8: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0ac: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0b0: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0b4: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0b8: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0bc: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0c0: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0c4: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0c8: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0cc: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0d0: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0d4: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0d8: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0dc: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0e0: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0e4: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0e8: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0ec: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0f0: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0f4: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0f8: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0fc: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
eth1: tx_timeout: dead entries!
NETDEV WATCHDOG: eth1: transmit timed out
eth1: Got tx_timeout. irq: 00000000
eth1: Ring at 37f82000
eth1: Dumping tx registers
  0: 00000000 000000ff 00000003 007903ca 00000000 00000000 00000000 00000000
 20: 06255300 ff701365 00000000 00000000 00000000 00000000 00000000 00000000
 40: 0420e20e 0000a855 00002e20 00000000 00000000 00000000 00000000 00000000
 60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
 80: 003b0f3c 00000001 00000000 007f0028 0000061c 00000001 00000000 00007fb4
 a0: 0014050f 00000016 dcd41300 00001241 005e0001 00000100 ffffffff 0000ffff
 c0: 10000002 00000001 00000001 00000001 00000001 00000001 00000001 00000001
 e0: 00000001 00000001 00000001 00000001 00000001 00000001 00000001 00000001
100: 37f82800 37f82000 007f00ff 00008000 00010032 00000000 00000022 37f82800
120: 37f820e0 00000000 00000000 37f87494 8000061c 37f8280c 37f8200c 0fe08000
140: 00304120 80002600 00000000 00000000 00000000 00000000 00000000 00000000
160: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
180: 00000016 00000008 0994796d 00008103 0000012a 00007800 0994000f 00000003
1a0: 00000016 00000008 0994796d 00008103 0000012a 00007800 0994000f 00000003
1c0: 00000016 00000008 0994796d 00008103 0000012a 00007800 0994000f 00000003
1e0: 00000016 00000008 0994796d 00008103 0000012a 00007800 0994000f 00000003
200: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
220: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
240: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
260: 00000000 00000000 fe020001 00000100 00000000 00000000 7e020001 00000100
eth1: Dumping tx ring
000: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
004: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
008: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
00c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
010: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
014: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
018: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
01c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
020: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
024: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
028: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
02c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
030: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
034: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
038: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
03c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
040: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
044: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
048: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
04c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
050: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
054: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
058: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
05c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
060: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
064: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
068: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
06c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
070: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
074: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
078: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
07c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
080: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
084: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
088: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
08c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
090: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
094: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
098: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
09c: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0a0: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0a4: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0a8: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0ac: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0b0: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0b4: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0b8: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0bc: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0c0: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0c4: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0c8: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0cc: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0d0: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0d4: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0d8: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0dc: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0e0: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0e4: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0e8: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0ec: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0f0: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0f4: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0f8: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
0fc: 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000 // 00000000 00000000 00000000
eth1: tx_timeout: dead entries!
