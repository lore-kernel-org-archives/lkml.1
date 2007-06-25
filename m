Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbXFYGU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbXFYGU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 02:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbXFYGUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 02:20:21 -0400
Received: from [157.181.151.9] ([157.181.151.9]:44480 "EHLO mx2.mail.elte.hu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753260AbXFYGUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 02:20:18 -0400
Date: Mon, 25 Jun 2007 08:18:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.22-rc3 nmi watchdog hang
Message-ID: <20070625061819.GA21874@elte.hu>
References: <20070605091151.GA18385@elte.hu> <20070605022411.f303d28b.akpm@linux-foundation.org> <20070605093349.GA24956@elte.hu> <20070605093958.GA26135@elte.hu> <20070605094246.GA27135@elte.hu> <20070605094555.GA28097@elte.hu> <20070605095025.GA29029@elte.hu> <20070605095600.GA29270@elte.hu> <20070610181016.GA15979@atjola.homenet> <20070618121122.GA14375@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618121122.GA14375@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
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

> attached below. nmi_watchdog=2 still hangs as of -rc5, using the 
> 32-bit kernel (at various places during bootup - a typical place is 
> somewhere after cfq_init()). Changing it to nmi_watchdog=0 makes the 
> kernel boot again.

FYI, latest -git _still_ hangs with the NMI watchdog with 
nmi_watchdog=2, at the same place:

 Calling initcall 0xc06cc620: check_nmi_watchdog+0x0/0x1f0()
 Testing NMI watchdog ... CPU#0: NMI appears to be stuck (0->0)!
 CPU#1: NMI appears to be stuck (0->0)!
 initcall 0xc06cc620: check_nmi_watchdog+0x0/0x1f0() returned -1.
 initcall 0xc06cc620 ran for 27 msecs: check_nmi_watchdog+0x0/0x1f0()
 initcall at 0xc06cc620: check_nmi_watchdog+0x0/0x1f0(): returned with 
 error code -1
 Calling initcall 0xc06ccbb0: io_apic_bug_finalize+0x0/0x20()
 initcall 0xc06ccbb0: io_apic_bug_finalize+0x0/0x20() returned 0.
 initcall 0xc06ccbb0 ran for 0 msecs: io_apic_bug_finalize+0x0/0x20()
 Calling initcall 0xc06ccd00: balanced_irq_init+0x0/0x1e0()
 Starting balanced_irq
 [hard hang]

full bootlog attached below.

	Ingo

-------------------------------->
Linux version 2.6.22-rc5-cfs-v19 (mingo@dione) (gcc version 4.0.2) #7 SMP Mon Jun 25 08:09:25 CEST 2007
BIOS-provided physical RAM map:
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
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 255 pages used for memmap
  HighMem zone: 32497 pages, LIFO batch:7
DMI 2.3 present.
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
Built 1 zonelists.  Total pages: 260081
Kernel command line: root=/dev/hda1 console=tty 3 debug profile=0 initcall_debug maxcpus=2 selinux=1 enforcing=0 apic=verbose ignore_loglevel nmi_watchdog=2 sysrq_always_enabled earlyprintk=serial,ttyS0,115200,keep
kernel profiling enabled (shift: 0)
debug: ignoring loglevel setting.
debug: sysrq always enabled.
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2160.217 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
num_possible_cpus(): 2
CPU#0: allocated 33554432 bytes trace buffer.
CPU#0: allocated 33554432 bytes max-trace buffer.
CPU#1: allocated 33554432 bytes trace buffer.
CPU#1: allocated 33554432 bytes max-trace buffer.
allocated 67108864 bytes out-trace buffer.
tracer: a total of 201326592 bytes allocated.
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 818000k/1048512k available (4339k kernel code, 229872k reserved, 1516k data, 408k init, 131008k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc06bf000 - 0xc0725000   ( 408 kB)
      .data : 0xc053cc70 - 0xc06b7f54   (1516 kB)
      .text : 0xc0100000 - 0xc053cc70   (4339 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4321.76 BogoMIPS (lpj=2160884)
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
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
enabled ExtINT on CPU#0
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 4319.79 BogoMIPS (lpj=2159895)
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000003
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(2) -> Core 1
CPU: After all inits, caps: 178bfbff e3d3fbff 00000000 00000410 00000001 00000000 00000003
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
Total of 2 processors activated (8641.55 BogoMIPS).
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1349919
... PM timer delta = 357900
... PM timer result ok
..... delta 1349919
..... mult: 57987393
..... calibration result: 215987
..... CPU clock speed is 2159.0871 MHz.
..... host bus clock speed is 215.0987 MHz.
Brought up 2 CPUs
Calling initcall 0xc06e0bd0: init_cpufreq_transition_notifier_list+0x0/0x20()
initcall 0xc06e0bd0: init_cpufreq_transition_notifier_list+0x0/0x20() returned 0.
initcall 0xc06e0bd0 ran for 0 msecs: init_cpufreq_transition_notifier_list+0x0/0x20()
Calling initcall 0xc06c80a0: cpufreq_tsc+0x0/0x20()
initcall 0xc06c80a0: cpufreq_tsc+0x0/0x20() returned 0.
initcall 0xc06c80a0 ran for 0 msecs: cpufreq_tsc+0x0/0x20()
Calling initcall 0xc06c9cb0: acpisleep_dmi_init+0x0/0x20()
initcall 0xc06c9cb0: acpisleep_dmi_init+0x0/0x20() returned 0.
initcall 0xc06c9cb0 ran for 0 msecs: acpisleep_dmi_init+0x0/0x20()
Calling initcall 0xc06c9ec0: reboot_init+0x0/0x20()
initcall 0xc06c9ec0: reboot_init+0x0/0x20() returned 0.
initcall 0xc06c9ec0 ran for 0 msecs: reboot_init+0x0/0x20()
Calling initcall 0xc06cf100: print_banner+0x0/0x10()
Booting paravirtualized kernel on bare hardware
initcall 0xc06cf100: print_banner+0x0/0x10() returned 0.
initcall 0xc06cf100 ran for 0 msecs: print_banner+0x0/0x10()
Calling initcall 0xc06d0d30: sysctl_init+0x0/0x20()
initcall 0xc06d0d30: sysctl_init+0x0/0x20() returned 0.
initcall 0xc06d0d30 ran for 0 msecs: sysctl_init+0x0/0x20()
Calling initcall 0xc06d1760: init_jiffies_clocksource+0x0/0x10()
initcall 0xc06d1760: init_jiffies_clocksource+0x0/0x10() returned 0.
initcall 0xc06d1760 ran for 0 msecs: init_jiffies_clocksource+0x0/0x10()
Calling initcall 0xc06d1880: pm_init+0x0/0x30()
initcall 0xc06d1880: pm_init+0x0/0x30() returned 0.
initcall 0xc06d1880 ran for 0 msecs: pm_init+0x0/0x30()
Calling initcall 0xc06d18b0: pm_disk_init+0x0/0x20()
initcall 0xc06d18b0: pm_disk_init+0x0/0x20() returned 0.
initcall 0xc06d18b0 ran for 0 msecs: pm_disk_init+0x0/0x20()
Calling initcall 0xc0157690: swsusp_header_init+0x0/0x30()
initcall 0xc0157690: swsusp_header_init+0x0/0x30() returned 0.
initcall 0xc0157690 ran for 0 msecs: swsusp_header_init+0x0/0x30()
Calling initcall 0xc06d1e50: ksysfs_init+0x0/0x30()
initcall 0xc06d1e50: ksysfs_init+0x0/0x30() returned 0.
initcall 0xc06d1e50 ran for 0 msecs: ksysfs_init+0x0/0x30()
Calling initcall 0xc06d4480: filelock_init+0x0/0x40()
initcall 0xc06d4480: filelock_init+0x0/0x40() returned 0.
initcall 0xc06d4480 ran for 0 msecs: filelock_init+0x0/0x40()
Calling initcall 0xc06d4ff0: init_misc_binfmt+0x0/0x40()
initcall 0xc06d4ff0: init_misc_binfmt+0x0/0x40() returned 0.
initcall 0xc06d4ff0 ran for 0 msecs: init_misc_binfmt+0x0/0x40()
Calling initcall 0xc06d5030: init_script_binfmt+0x0/0x10()
initcall 0xc06d5030: init_script_binfmt+0x0/0x10() returned 0.
initcall 0xc06d5030 ran for 0 msecs: init_script_binfmt+0x0/0x10()
Calling initcall 0xc06d5040: init_elf_binfmt+0x0/0x10()
initcall 0xc06d5040: init_elf_binfmt+0x0/0x10() returned 0.
initcall 0xc06d5040 ran for 0 msecs: init_elf_binfmt+0x0/0x10()
Calling initcall 0xc06d6070: securityfs_init+0x0/0x50()
initcall 0xc06d6070: securityfs_init+0x0/0x50() returned 0.
initcall 0xc06d6070 ran for 0 msecs: securityfs_init+0x0/0x50()
Calling initcall 0xc06d6b00: random32_init+0x0/0x70()
initcall 0xc06d6b00: random32_init+0x0/0x70() returned 0.
initcall 0xc06d6b00 ran for 0 msecs: random32_init+0x0/0x70()
Calling initcall 0xc06e0bf0: cpufreq_core_init+0x0/0x80()
initcall 0xc06e0bf0: cpufreq_core_init+0x0/0x80() returned 0.
initcall 0xc06e0bf0 ran for 0 msecs: cpufreq_core_init+0x0/0x80()
Calling initcall 0xc06e43f0: sock_init+0x0/0x60()
initcall 0xc06e43f0: sock_init+0x0/0x60() returned 0.
initcall 0xc06e43f0 ran for 0 msecs: sock_init+0x0/0x60()
Calling initcall 0xc06e4bb0: netpoll_init+0x0/0x30()
initcall 0xc06e4bb0: netpoll_init+0x0/0x30() returned 0.
initcall 0xc06e4bb0 ran for 0 msecs: netpoll_init+0x0/0x30()
Calling initcall 0xc06e4eb0: netlink_proto_init+0x0/0x150()
NET: Registered protocol family 16
initcall 0xc06e4eb0: netlink_proto_init+0x0/0x150() returned 0.
initcall 0xc06e4eb0 ran for 0 msecs: netlink_proto_init+0x0/0x150()
Calling initcall 0xc06d69f0: kobject_uevent_init+0x0/0x50()
initcall 0xc06d69f0: kobject_uevent_init+0x0/0x50() returned 0.
initcall 0xc06d69f0 ran for 0 msecs: kobject_uevent_init+0x0/0x50()
Calling initcall 0xc06d6c30: pcibus_class_init+0x0/0x10()
initcall 0xc06d6c30: pcibus_class_init+0x0/0x10() returned 0.
initcall 0xc06d6c30 ran for 0 msecs: pcibus_class_init+0x0/0x10()
Calling initcall 0xc06d7270: pci_driver_init+0x0/0x10()
initcall 0xc06d7270: pci_driver_init+0x0/0x10() returned 0.
initcall 0xc06d7270 ran for 0 msecs: pci_driver_init+0x0/0x10()
Calling initcall 0xc06d7af0: backlight_class_init+0x0/0x10()
initcall 0xc06d7af0: backlight_class_init+0x0/0x10() returned 0.
initcall 0xc06d7af0 ran for 0 msecs: backlight_class_init+0x0/0x10()
Calling initcall 0xc06da0e0: tty_class_init+0x0/0x30()
initcall 0xc06da0e0: tty_class_init+0x0/0x30() returned 0.
initcall 0xc06da0e0 ran for 0 msecs: tty_class_init+0x0/0x30()
Calling initcall 0xc06da7f0: vtconsole_class_init+0x0/0xd0()
initcall 0xc06da7f0: vtconsole_class_init+0x0/0xd0() returned 0.
initcall 0xc06da7f0 ran for 0 msecs: vtconsole_class_init+0x0/0xd0()
Calling initcall 0xc06e0530: eisa_init+0x0/0x30()
EISA bus registered
initcall 0xc06e0530: eisa_init+0x0/0x30() returned 0.
initcall 0xc06e0530 ran for 0 msecs: eisa_init+0x0/0x30()
Calling initcall 0xc06c7ff0: init_pit_clocksource+0x0/0x90()
initcall 0xc06c7ff0: init_pit_clocksource+0x0/0x90() returned 0.
initcall 0xc06c7ff0 ran for 0 msecs: init_pit_clocksource+0x0/0x90()
Calling initcall 0xc06c8b00: mtrr_if_init+0x0/0x60()
initcall 0xc06c8b00: mtrr_if_init+0x0/0x60() returned 0.
initcall 0xc06c8b00 ran for 0 msecs: mtrr_if_init+0x0/0x60()
Calling initcall 0xc06c9d90: ffh_cstate_init+0x0/0x30()
initcall 0xc06c9d90: ffh_cstate_init+0x0/0x30() returned -1.
initcall 0xc06c9d90 ran for 0 msecs: ffh_cstate_init+0x0/0x30()
initcall at 0xc06c9d90: ffh_cstate_init+0x0/0x30(): returned with error code -1
Calling initcall 0xc06d7550: acpi_pci_init+0x0/0x50()
ACPI: bus type pci registered
initcall 0xc06d7550: acpi_pci_init+0x0/0x50() returned 0.
initcall 0xc06d7550 ran for 0 msecs: acpi_pci_init+0x0/0x50()
Calling initcall 0xc06d930b: init_acpi_device_notify+0x0/0x45()
initcall 0xc06d930b: init_acpi_device_notify+0x0/0x45() returned 0.
initcall 0xc06d930b ran for 0 msecs: init_acpi_device_notify+0x0/0x45()
Calling initcall 0xc06e2b70: pci_access_init+0x0/0x50()
PCI: Using MMCONFIG
PCI: No mmconfig possible on device 00:18
initcall 0xc06e2b70: pci_access_init+0x0/0x50() returned 0.
initcall 0xc06e2b70 ran for 1 msecs: pci_access_init+0x0/0x50()
Calling initcall 0xc06c7960: request_standard_resources+0x0/0x3b0()
Setting up standard PCI resources
initcall 0xc06c7960: request_standard_resources+0x0/0x3b0() returned 0.
initcall 0xc06c7960 ran for 3 msecs: request_standard_resources+0x0/0x3b0()
Calling initcall 0xc06c7d40: topology_init+0x0/0x60()
initcall 0xc06c7d40: topology_init+0x0/0x60() returned 0.
initcall 0xc06c7d40 ran for 0 msecs: topology_init+0x0/0x60()
Calling initcall 0xc06c8800: mtrr_init_finialize+0x0/0x40()
initcall 0xc06c8800: mtrr_init_finialize+0x0/0x40() returned 0.
initcall 0xc06c8800 ran for 0 msecs: mtrr_init_finialize+0x0/0x40()
Calling initcall 0xc06c9ee0: mca_init+0x0/0x340()
initcall 0xc06c9ee0: mca_init+0x0/0x340() returned -19.
initcall 0xc06c9ee0 ran for 0 msecs: mca_init+0x0/0x340()
Calling initcall 0xc06d1110: param_sysfs_init+0x0/0x1e0()
initcall 0xc06d1110: param_sysfs_init+0x0/0x1e0() returned 0.
initcall 0xc06d1110 ran for 1 msecs: param_sysfs_init+0x0/0x1e0()
Calling initcall 0xc0158930: pm_sysrq_init+0x0/0x20()
initcall 0xc0158930: pm_sysrq_init+0x0/0x20() returned 0.
initcall 0xc0158930 ran for 0 msecs: pm_sysrq_init+0x0/0x20()
Calling initcall 0xc06d4c30: init_bio+0x0/0xd0()
initcall 0xc06d4c30: init_bio+0x0/0xd0() returned 0.
initcall 0xc06d4c30 ran for 0 msecs: init_bio+0x0/0xd0()
Calling initcall 0xc06d6720: genhd_device_init+0x0/0x60()
initcall 0xc06d6720: genhd_device_init+0x0/0x60() returned 0.
initcall 0xc06d6720 ran for 0 msecs: genhd_device_init+0x0/0x60()
Calling initcall 0xc06d75a0: fbmem_init+0x0/0xa0()
initcall 0xc06d75a0: fbmem_init+0x0/0xa0() returned 0.
initcall 0xc06d75a0 ran for 0 msecs: fbmem_init+0x0/0xa0()
Calling initcall 0xc06d910c: acpi_init+0x0/0x1ff()
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
initcall 0xc06d910c: acpi_init+0x0/0x1ff() returned 0.
initcall 0xc06d910c ran for 9 msecs: acpi_init+0x0/0x1ff()
Calling initcall 0xc06d9350: acpi_scan_init+0x0/0xfc()
initcall 0xc06d9350: acpi_scan_init+0x0/0xfc() returned 0.
initcall 0xc06d9350 ran for 9 msecs: acpi_scan_init+0x0/0xfc()
Calling initcall 0xc06d94d4: acpi_ec_init+0x0/0x55()
initcall 0xc06d94d4: acpi_ec_init+0x0/0x55() returned 0.
initcall 0xc06d94d4 ran for 0 msecs: acpi_ec_init+0x0/0x55()
Calling initcall 0xc06d957c: acpi_pci_root_init+0x0/0x25()
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
initcall 0xc06d957c: acpi_pci_root_init+0x0/0x25() returned 0.
initcall 0xc06d957c ran for 55 msecs: acpi_pci_root_init+0x0/0x25()
Calling initcall 0xc06d9675: acpi_pci_link_init+0x0/0x43()
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
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
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
initcall 0xc06d9675: acpi_pci_link_init+0x0/0x43() returned 0.
initcall 0xc06d9675 ran for 119 msecs: acpi_pci_link_init+0x0/0x43()
Calling initcall 0xc06d974f: acpi_power_init+0x0/0x69()
initcall 0xc06d974f: acpi_power_init+0x0/0x69() returned 0.
initcall 0xc06d974f ran for 0 msecs: acpi_power_init+0x0/0x69()
Calling initcall 0xc06d97b8: acpi_system_init+0x0/0xad()
initcall 0xc06d97b8: acpi_system_init+0x0/0xad() returned 0.
initcall 0xc06d97b8 ran for 0 msecs: acpi_system_init+0x0/0xad()
Calling initcall 0xc06d9865: acpi_event_init+0x0/0x38()
initcall 0xc06d9865: acpi_event_init+0x0/0x38() returned 0.
initcall 0xc06d9865 ran for 0 msecs: acpi_event_init+0x0/0x38()
Calling initcall 0xc06d989d: acpi_cm_sbs_init+0x0/0x13()
initcall 0xc06d989d: acpi_cm_sbs_init+0x0/0x13() returned 0.
initcall 0xc06d989d ran for 0 msecs: acpi_cm_sbs_init+0x0/0x13()
Calling initcall 0xc06d98b0: pnp_init+0x0/0x20()
Linux Plug and Play Support v0.97 (c) Adam Belay
initcall 0xc06d98b0: pnp_init+0x0/0x20() returned 0.
initcall 0xc06d98b0 ran for 0 msecs: pnp_init+0x0/0x20()
Calling initcall 0xc06d9b40: pnpacpi_init+0x0/0x90()
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
initcall 0xc06d9b40: pnpacpi_init+0x0/0x90() returned 0.
initcall 0xc06d9b40 ran for 8 msecs: pnpacpi_init+0x0/0x90()
Calling initcall 0xc06da520: misc_init+0x0/0x80()
initcall 0xc06da520: misc_init+0x0/0x80() returned 0.
initcall 0xc06da520 ran for 0 msecs: misc_init+0x0/0x80()
Calling initcall 0xc06dd9e0: init_scsi+0x0/0xb0()
SCSI subsystem initialized
initcall 0xc06dd9e0: init_scsi+0x0/0xb0() returned 0.
initcall 0xc06dd9e0 ran for 0 msecs: init_scsi+0x0/0xb0()
Calling initcall 0xc06de2f0: ata_init+0x0/0x80()
libata version 2.21 loaded.
initcall 0xc06de2f0: ata_init+0x0/0x80() returned 0.
initcall 0xc06de2f0 ran for 0 msecs: ata_init+0x0/0x80()
Calling initcall 0xc06df270: init_pcmcia_cs+0x0/0x40()
initcall 0xc06df270: init_pcmcia_cs+0x0/0x40() returned 0.
initcall 0xc06df270 ran for 0 msecs: init_pcmcia_cs+0x0/0x40()
Calling initcall 0xc06df3f0: usb_init+0x0/0x110()
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall 0xc06df3f0: usb_init+0x0/0x110() returned 0.
initcall 0xc06df3f0 ran for 2 msecs: usb_init+0x0/0x110()
Calling initcall 0xc06df900: serio_init+0x0/0xb0()
initcall 0xc06df900: serio_init+0x0/0xb0() returned 0.
initcall 0xc06df900 ran for 0 msecs: serio_init+0x0/0xb0()
Calling initcall 0xc06dfdf0: input_init+0x0/0x120()
initcall 0xc06dfdf0: input_init+0x0/0x120() returned 0.
initcall 0xc06dfdf0 ran for 0 msecs: input_init+0x0/0x120()
Calling initcall 0xc06e0130: hwmon_init+0x0/0x40()
initcall 0xc06e0130: hwmon_init+0x0/0x40() returned 0.
initcall 0xc06e0130 ran for 0 msecs: hwmon_init+0x0/0x40()
Calling initcall 0xc06e27d0: ac97_bus_init+0x0/0x10()
initcall 0xc06e27d0: ac97_bus_init+0x0/0x10() returned 0.
initcall 0xc06e27d0 ran for 0 msecs: ac97_bus_init+0x0/0x10()
Calling initcall 0xc06e3770: pci_acpi_init+0x0/0xb0()
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
initcall 0xc06e3770: pci_acpi_init+0x0/0xb0() returned 0.
initcall 0xc06e3770 ran for 82 msecs: pci_acpi_init+0x0/0xb0()
Calling initcall 0xc06e3820: pci_legacy_init+0x0/0x120()
initcall 0xc06e3820: pci_legacy_init+0x0/0x120() returned 0.
initcall 0xc06e3820 ran for 0 msecs: pci_legacy_init+0x0/0x120()
Calling initcall 0xc06e3e50: pcibios_irq_init+0x0/0x510()
initcall 0xc06e3e50: pcibios_irq_init+0x0/0x510() returned 0.
initcall 0xc06e3e50 ran for 0 msecs: pcibios_irq_init+0x0/0x510()
Calling initcall 0xc06e4360: pcibios_init+0x0/0x90()
initcall 0xc06e4360: pcibios_init+0x0/0x90() returned 0.
initcall 0xc06e4360 ran for 0 msecs: pcibios_init+0x0/0x90()
Calling initcall 0xc06e44b0: proto_init+0x0/0x30()
initcall 0xc06e44b0: proto_init+0x0/0x30() returned 0.
initcall 0xc06e44b0 ran for 0 msecs: proto_init+0x0/0x30()
Calling initcall 0xc06e4620: net_dev_init+0x0/0x220()
initcall 0xc06e4620: net_dev_init+0x0/0x220() returned 0.
initcall 0xc06e4620 ran for 0 msecs: net_dev_init+0x0/0x220()
Calling initcall 0xc06e4880: neigh_init+0x0/0x80()
initcall 0xc06e4880: neigh_init+0x0/0x80() returned 0.
initcall 0xc06e4880 ran for 0 msecs: neigh_init+0x0/0x80()
Calling initcall 0xc06e4be0: fib_rules_init+0x0/0x60()
initcall 0xc06e4be0: fib_rules_init+0x0/0x60() returned 0.
initcall 0xc06e4be0 ran for 0 msecs: fib_rules_init+0x0/0x60()
Calling initcall 0xc06e4d70: pktsched_init+0x0/0xd0()
initcall 0xc06e4d70: pktsched_init+0x0/0xd0() returned 0.
initcall 0xc06e4d70 ran for 0 msecs: pktsched_init+0x0/0xd0()
Calling initcall 0xc06e4e50: tc_filter_init+0x0/0x60()
initcall 0xc06e4e50: tc_filter_init+0x0/0x60() returned 0.
initcall 0xc06e4e50 ran for 0 msecs: tc_filter_init+0x0/0x60()
Calling initcall 0xc06e5000: genl_init+0x0/0xb0()
initcall 0xc06e5000: genl_init+0x0/0xb0() returned 0.
initcall 0xc06e5000 ran for 0 msecs: genl_init+0x0/0xb0()
Calling initcall 0xc06e72b0: wireless_nlevent_init+0x0/0x2c()
initcall 0xc06e72b0: wireless_nlevent_init+0x0/0x2c() returned 0.
initcall 0xc06e72b0 ran for 0 msecs: wireless_nlevent_init+0x0/0x2c()
Calling initcall 0xc06d1630: clocksource_done_booting+0x0/0x20()
initcall 0xc06d1630: clocksource_done_booting+0x0/0x20() returned 0.
initcall 0xc06d1630 ran for 0 msecs: clocksource_done_booting+0x0/0x20()
Calling initcall 0xc06d43f0: init_pipe_fs+0x0/0x50()
initcall 0xc06d43f0: init_pipe_fs+0x0/0x50() returned 0.
initcall 0xc06d43f0 ran for 0 msecs: init_pipe_fs+0x0/0x50()
Calling initcall 0xc06d4e60: eventpoll_init+0x0/0x90()
initcall 0xc06d4e60: eventpoll_init+0x0/0x90() returned 0.
initcall 0xc06d4e60 ran for 0 msecs: eventpoll_init+0x0/0x90()
Calling initcall 0xc06d4ef0: anon_inode_init+0x0/0x100()
initcall 0xc06d4ef0: anon_inode_init+0x0/0x100() returned 0.
initcall 0xc06d4ef0 ran for 0 msecs: anon_inode_init+0x0/0x100()
Calling initcall 0xc06d9a10: pnp_system_init+0x0/0x10()
pnp: 00:01: ioport range 0x4000-0x407f has been reserved
pnp: 00:01: ioport range 0x4080-0x40ff has been reserved
pnp: 00:01: ioport range 0x4400-0x447f has been reserved
pnp: 00:01: ioport range 0x4480-0x44ff has been reserved
pnp: 00:01: ioport range 0x4800-0x487f has been reserved
pnp: 00:01: ioport range 0x4880-0x48ff has been reserved
pnp: 00:0e: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:0f: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:0f: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:0f: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:0f: iomem range 0xfc000-0xfffff could not be reserved
initcall 0xc06d9a10: pnp_system_init+0x0/0x10() returned 0.
initcall 0xc06d9a10 ran for 10 msecs: pnp_system_init+0x0/0x10()
Calling initcall 0xc06d9fe0: chr_dev_init+0x0/0x90()
initcall 0xc06d9fe0: chr_dev_init+0x0/0x90() returned 0.
initcall 0xc06d9fe0 ran for 0 msecs: chr_dev_init+0x0/0x90()
Calling initcall 0xc06dc6a0: firmware_class_init+0x0/0x70()
initcall 0xc06dc6a0: firmware_class_init+0x0/0x70() returned 0.
initcall 0xc06dc6a0 ran for 0 msecs: firmware_class_init+0x0/0x70()
Calling initcall 0xc06df2b0: init_pcmcia_bus+0x0/0x90()
initcall 0xc06df2b0: init_pcmcia_bus+0x0/0x90() returned 0.
initcall 0xc06df2b0 ran for 0 msecs: init_pcmcia_bus+0x0/0x90()
Calling initcall 0xc06e0c70: cpufreq_gov_userspace_init+0x0/0x20()
initcall 0xc06e0c70: cpufreq_gov_userspace_init+0x0/0x20() returned 0.
initcall 0xc06e0c70 ran for 0 msecs: cpufreq_gov_userspace_init+0x0/0x20()
Calling initcall 0xc06e1260: init_acpi_pm_clocksource+0x0/0x1d0()
initcall 0xc06e1260<6>Time: acpi_pm clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
: init_acpi_pm_clocksource+0x0/0x1d0() returned 0.
initcall 0xc06e1260 ran for 28 msecs: init_acpi_pm_clocksource+0x0/0x1d0()
Calling initcall 0xc06e2850: pcibios_assign_resources+0x0/0xb0()
PCI: Bridge: 0000:00:09.0
  IO window: c000-cfff
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
  IO window: b000-bfff
  MEM window: d8000000-d9ffffff
  PREFETCH window: d0000000-d7ffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
initcall 0xc06e2850: pcibios_assign_resources+0x0/0xb0() returned 0.
initcall 0xc06e2850 ran for 69 msecs: pcibios_assign_resources+0x0/0xb0()
Calling initcall 0xc06e5c20: inet_init+0x0/0x310()
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall 0xc06e5c20: inet_init+0x0/0x310() returned 0.
initcall 0xc06e5c20 ran for 41 msecs: inet_init+0x0/0x310()
Calling initcall 0xc06c58a0: populate_rootfs+0x0/0x100()
initcall 0xc06c58a0: populate_rootfs+0x0/0x100() returned 0.
initcall 0xc06c58a0 ran for 0 msecs: populate_rootfs+0x0/0x100()
Calling initcall 0xc06c6a80: i8259A_init_sysfs+0x0/0x30()
initcall 0xc06c6a80: i8259A_init_sysfs+0x0/0x30() returned 0.
initcall 0xc06c6a80 ran for 0 msecs: i8259A_init_sysfs+0x0/0x30()
Calling initcall 0xc06c6bc0: sbf_init+0x0/0xf0()
initcall 0xc06c6bc0: sbf_init+0x0/0xf0() returned 0.
initcall 0xc06c6bc0 ran for 0 msecs: sbf_init+0x0/0xf0()
Calling initcall 0xc06c7d10: i8237A_init_sysfs+0x0/0x30()
initcall 0xc06c7d10: i8237A_init_sysfs+0x0/0x30() returned 0.
initcall 0xc06c7d10 ran for 0 msecs: i8237A_init_sysfs+0x0/0x30()
Calling initcall 0xc010eed0: cache_sysfs_init+0x0/0x80()
initcall 0xc010eed0: cache_sysfs_init+0x0/0x80() returned 0.
initcall 0xc010eed0 ran for 0 msecs: cache_sysfs_init+0x0/0x80()
Calling initcall 0xc06c86f0: thermal_throttle_init_device+0x0/0xc0()
initcall 0xc06c86f0: thermal_throttle_init_device+0x0/0xc0() returned 0.
initcall 0xc06c86f0 ran for 0 msecs: thermal_throttle_init_device+0x0/0xc0()
Calling initcall 0xc06c87b0: init_nonfatal_mce_checker+0x0/0x50()
Machine check exception polling timer started.
initcall 0xc06c87b0: init_nonfatal_mce_checker+0x0/0x50() returned 0.
initcall 0xc06c87b0 ran for 3 msecs: init_nonfatal_mce_checker+0x0/0x50()
Calling initcall 0xc06cb880: init_lapic_sysfs+0x0/0x30()
initcall 0xc06cb880: init_lapic_sysfs+0x0/0x30() returned 0.
initcall 0xc06cb880 ran for 0 msecs: init_lapic_sysfs+0x0/0x30()
Calling initcall 0xc06ccc30: ioapic_init_sysfs+0x0/0xd0()
initcall 0xc06ccc30: ioapic_init_sysfs+0x0/0xd0() returned 0.
initcall 0xc06ccc30 ran for 0 msecs: ioapic_init_sysfs+0x0/0xd0()
Calling initcall 0xc06ce940: serial8250_x86_com_init+0x0/0x30()
initcall 0xc06ce940: serial8250_x86_com_init+0x0/0x30() returned -19.
initcall 0xc06ce940 ran for 0 msecs: serial8250_x86_com_init+0x0/0x30()
Calling initcall 0xc06ced90: hpet_register_sysfs+0x0/0x50()
initcall 0xc06ced90: hpet_register_sysfs+0x0/0x50() returned 0.
initcall 0xc06ced90 ran for 0 msecs: hpet_register_sysfs+0x0/0x50()
Calling initcall 0xc06cf110: add_pcspkr+0x0/0x60()
initcall 0xc06cf110: add_pcspkr+0x0/0x60() returned 0.
initcall 0xc06cf110 ran for 0 msecs: add_pcspkr+0x0/0x60()
Calling initcall 0xc06cfe00: init_sched_debug_procfs+0x0/0x30()
initcall 0xc06cfe00: init_sched_debug_procfs+0x0/0x30() returned 0.
initcall 0xc06cfe00 ran for 0 msecs: init_sched_debug_procfs+0x0/0x30()
Calling initcall 0xc06d09e0: create_proc_profile+0x0/0x1b0()
initcall 0xc06d09e0: create_proc_profile+0x0/0x1b0() returned 0.
initcall 0xc06d09e0 ran for 0 msecs: create_proc_profile+0x0/0x1b0()
Calling initcall 0xc06d0c10: ioresources_init+0x0/0x40()
initcall 0xc06d0c10: ioresources_init+0x0/0x40() returned 0.
initcall 0xc06d0c10 ran for 0 msecs: ioresources_init+0x0/0x40()
Calling initcall 0xc06d0da0: uid_cache_init+0x0/0xa0()
initcall 0xc06d0da0: uid_cache_init+0x0/0xa0() returned 0.
initcall 0xc06d0da0 ran for 0 msecs: uid_cache_init+0x0/0xa0()
Calling initcall 0xc06d12f0: init_posix_timers+0x0/0x80()
initcall 0xc06d12f0: init_posix_timers+0x0/0x80() returned 0.
initcall 0xc06d12f0 ran for 0 msecs: init_posix_timers+0x0/0x80()
Calling initcall 0xc06d1370: init_posix_cpu_timers+0x0/0x60()
initcall 0xc06d1370: init_posix_cpu_timers+0x0/0x60() returned 0.
initcall 0xc06d1370 ran for 0 msecs: init_posix_cpu_timers+0x0/0x60()
Calling initcall 0xc06d1490: latency_init+0x0/0x20()
initcall 0xc06d1490: latency_init+0x0/0x20() returned 0.
initcall 0xc06d1490 ran for 0 msecs: latency_init+0x0/0x20()
Calling initcall 0xc06d14b0: timekeeping_init_device+0x0/0x30()
initcall 0xc06d14b0: timekeeping_init_device+0x0/0x30() returned 0.
initcall 0xc06d14b0 ran for 0 msecs: timekeeping_init_device+0x0/0x30()
Calling initcall 0xc06d1650: init_clocksource_sysfs+0x0/0x50()
initcall 0xc06d1650: init_clocksource_sysfs+0x0/0x50() returned 0.
initcall 0xc06d1650 ran for 0 msecs: init_clocksource_sysfs+0x0/0x50()
Calling initcall 0xc06d1770: init_timer_list_procfs+0x0/0x30()
initcall 0xc06d1770: init_timer_list_procfs+0x0/0x30() returned 0.
initcall 0xc06d1770 ran for 0 msecs: init_timer_list_procfs+0x0/0x30()
Calling initcall 0xc06d17b0: init+0x0/0x80()
initcall 0xc06d17b0: init+0x0/0x80() returned 0.
initcall 0xc06d17b0 ran for 0 msecs: init+0x0/0x80()
Calling initcall 0xc06d1830: proc_dma_init+0x0/0x20()
initcall 0xc06d1830: proc_dma_init+0x0/0x20() returned 0.
initcall 0xc06d1830 ran for 0 msecs: proc_dma_init+0x0/0x20()
Calling initcall 0xc014ffe0: percpu_modinit+0x0/0x70()
initcall 0xc014ffe0: percpu_modinit+0x0/0x70() returned 0.
initcall 0xc014ffe0 ran for 0 msecs: percpu_modinit+0x0/0x70()
Calling initcall 0xc06d1850: kallsyms_init+0x0/0x30()
initcall 0xc06d1850: kallsyms_init+0x0/0x30() returned 0.
initcall 0xc06d1850 ran for 0 msecs: kallsyms_init+0x0/0x30()
Calling initcall 0xc06d1a20: snapshot_device_init+0x0/0x10()
initcall 0xc06d1a20: snapshot_device_init+0x0/0x10() returned 0.
initcall 0xc06d1a20 ran for 0 msecs: snapshot_device_init+0x0/0x10()
Calling initcall 0xc06d1a30: ikconfig_init+0x0/0x40()
initcall 0xc06d1a30: ikconfig_init+0x0/0x40() returned 0.
initcall 0xc06d1a30 ran for 0 msecs: ikconfig_init+0x0/0x40()
Calling initcall 0xc06d1cc0: audit_init+0x0/0x110()
audit: initializing netlink socket (disabled)
audit(1182753703.820:1): initialized
initcall 0xc06d1cc0: audit_init+0x0/0x110() returned 0.
initcall 0xc06d1cc0 ran for 7 msecs: audit_init+0x0/0x110()
Calling initcall 0xc06d1ee0: utsname_sysctl_init+0x0/0x20()
initcall 0xc06d1ee0: utsname_sysctl_init+0x0/0x20() returned 0.
initcall 0xc06d1ee0 ran for 0 msecs: utsname_sysctl_init+0x0/0x20()
Calling initcall 0xc06d3180: init_per_zone_pages_min+0x0/0x50()
initcall 0xc06d3180: init_per_zone_pages_min+0x0/0x50() returned 0.
initcall 0xc06d3180 ran for 0 msecs: init_per_zone_pages_min+0x0/0x50()
Calling initcall 0xc06d3b20: pdflush_init+0x0/0x20()
initcall 0xc06d3b20: pdflush_init+0x0/0x20() returned 0.
initcall 0xc06d3b20 ran for 0 msecs: pdflush_init+0x0/0x20()
Calling initcall 0xc06d3b70: kswapd_init+0x0/0x30()
initcall 0xc06d3b70: kswapd_init+0x0/0x30() returned 0.
initcall 0xc06d3b70 ran for 0 msecs: kswapd_init+0x0/0x30()
Calling initcall 0xc06d3ba0: setup_vmstat+0x0/0x70()
initcall 0xc06d3ba0: setup_vmstat+0x0/0x70() returned 0.
initcall 0xc06d3ba0 ran for 0 msecs: setup_vmstat+0x0/0x70()
Calling initcall 0xc06d3d00: init_emergency_pool+0x0/0x70()
highmem bounce pool size: 64 pages
initcall 0xc06d3d00: init_emergency_pool+0x0/0x70() returned 0.
initcall 0xc06d3d00 ran for 2 msecs: init_emergency_pool+0x0/0x70()
Calling initcall 0xc06d3d70: procswaps_init+0x0/0x20()
initcall 0xc06d3d70: procswaps_init+0x0/0x20() returned 0.
initcall 0xc06d3d70 ran for 0 msecs: procswaps_init+0x0/0x20()
Calling initcall 0xc06d3d90: hugetlb_init+0x0/0x70()
Total HugeTLB memory allocated, 0
initcall 0xc06d3d90: hugetlb_init+0x0/0x70() returned 0.
initcall 0xc06d3d90 ran for 2 msecs: hugetlb_init+0x0/0x70()
Calling initcall 0xc06d3e40: init_tmpfs+0x0/0xd0()
initcall 0xc06d3e40: init_tmpfs+0x0/0xd0() returned 0.
initcall 0xc06d3e40 ran for 0 msecs: init_tmpfs+0x0/0xd0()
Calling initcall 0xc06d3f30: cpucache_init+0x0/0x60()
initcall 0xc06d3f30: cpucache_init+0x0/0x60() returned 0.
initcall 0xc06d3f30 ran for 0 msecs: cpucache_init+0x0/0x60()
Calling initcall 0xc06d4440: fasync_init+0x0/0x40()
initcall 0xc06d4440: fasync_init+0x0/0x40() returned 0.
initcall 0xc06d4440 ran for 0 msecs: fasync_init+0x0/0x40()
Calling initcall 0xc06d4b50: aio_setup+0x0/0x80()
initcall 0xc06d4b50: aio_setup+0x0/0x80() returned 0.
initcall 0xc06d4b50 ran for 0 msecs: aio_setup+0x0/0x80()
Calling initcall 0xc06d4d80: inotify_setup+0x0/0x10()
initcall 0xc06d4d80: inotify_setup+0x0/0x10() returned 0.
initcall 0xc06d4d80 ran for 0 msecs: inotify_setup+0x0/0x10()
Calling initcall 0xc06d4d90: inotify_user_setup+0x0/0xd0()
initcall 0xc06d4d90: inotify_user_setup+0x0/0xd0() returned 0.
initcall 0xc06d4d90 ran for 0 msecs: inotify_user_setup+0x0/0xd0()
Calling initcall 0xc06d5050: init_mbcache+0x0/0x20()
initcall 0xc06d5050: init_mbcache+0x0/0x20() returned 0.
initcall 0xc06d5050 ran for 0 msecs: init_mbcache+0x0/0x20()
Calling initcall 0xc06d5070: dquot_init+0x0/0x110()
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
initcall 0xc06d5070: dquot_init+0x0/0x110() returned 0.
initcall 0xc06d5070 ran for 7 msecs: dquot_init+0x0/0x110()
Calling initcall 0xc06d5180: init_v2_quota_format+0x0/0x10()
initcall 0xc06d5180: init_v2_quota_format+0x0/0x10() returned 0.
initcall 0xc06d5180 ran for 0 msecs: init_v2_quota_format+0x0/0x10()
Calling initcall 0xc06d5190: dnotify_init+0x0/0x40()
initcall 0xc06d5190: dnotify_init+0x0/0x40() returned 0.
initcall 0xc06d5190 ran for 0 msecs: dnotify_init+0x0/0x40()
Calling initcall 0xc06d55d0: init_devpts_fs+0x0/0x40()
initcall 0xc06d55d0: init_devpts_fs+0x0/0x40() returned 0.
initcall 0xc06d55d0 ran for 0 msecs: init_devpts_fs+0x0/0x40()
Calling initcall 0xc06d5610: init_ext3_fs+0x0/0x80()
initcall 0xc06d5610: init_ext3_fs+0x0/0x80() returned 0.
initcall 0xc06d5610 ran for 0 msecs: init_ext3_fs+0x0/0x80()
Calling initcall 0xc06d5760: journal_init+0x0/0xe0()
initcall 0xc06d5760: journal_init+0x0/0xe0() returned 0.
initcall 0xc06d5760 ran for 0 msecs: journal_init+0x0/0xe0()
Calling initcall 0xc06d5840: init_ext2_fs+0x0/0x80()
initcall 0xc06d5840: init_ext2_fs+0x0/0x80() returned 0.
initcall 0xc06d5840 ran for 0 msecs: init_ext2_fs+0x0/0x80()
Calling initcall 0xc06d5900: init_ramfs_fs+0x0/0x10()
initcall 0xc06d5900: init_ramfs_fs+0x0/0x10() returned 0.
initcall 0xc06d5900 ran for 0 msecs: init_ramfs_fs+0x0/0x10()
Calling initcall 0xc06d5920: init_hugetlbfs_fs+0x0/0xa0()
initcall 0xc06d5920: init_hugetlbfs_fs+0x0/0xa0() returned 0.
initcall 0xc06d5920 ran for 0 msecs: init_hugetlbfs_fs+0x0/0xa0()
Calling initcall 0xc06d59c0: init_iso9660_fs+0x0/0x70()
initcall 0xc06d59c0: init_iso9660_fs+0x0/0x70() returned 0.
initcall 0xc06d59c0 ran for 0 msecs: init_iso9660_fs+0x0/0x70()
Calling initcall 0xc06d5aa0: init_nls_cp437+0x0/0x10()
initcall 0xc06d5aa0: init_nls_cp437+0x0/0x10() returned 0.
initcall 0xc06d5aa0 ran for 0 msecs: init_nls_cp437+0x0/0x10()
Calling initcall 0xc06d5ab0: init_nls_ascii+0x0/0x10()
initcall 0xc06d5ab0: init_nls_ascii+0x0/0x10() returned 0.
initcall 0xc06d5ab0 ran for 0 msecs: init_nls_ascii+0x0/0x10()
Calling initcall 0xc06d5ac0: init_udf_fs+0x0/0x70()
initcall 0xc06d5ac0: init_udf_fs+0x0/0x70() returned 0.
initcall 0xc06d5ac0 ran for 0 msecs: init_udf_fs+0x0/0x70()
Calling initcall 0xc06d5b30: ipc_init+0x0/0x20()
initcall 0xc06d5b30: ipc_init+0x0/0x20() returned 0.
initcall 0xc06d5b30 ran for 0 msecs: ipc_init+0x0/0x20()
Calling initcall 0xc06d5da0: ipc_sysctl_init+0x0/0x20()
initcall 0xc06d5da0: ipc_sysctl_init+0x0/0x20() returned 0.
initcall 0xc06d5da0 ran for 0 msecs: ipc_sysctl_init+0x0/0x20()
Calling initcall 0xc06d5dc0: init_mqueue_fs+0x0/0xd0()
initcall 0xc06d5dc0: init_mqueue_fs+0x0/0xd0() returned 0.
initcall 0xc06d5dc0 ran for 0 msecs: init_mqueue_fs+0x0/0xd0()
Calling initcall 0xc06d5fe0: key_proc_init+0x0/0x30()
initcall 0xc06d5fe0: key_proc_init+0x0/0x30() returned 0.
initcall 0xc06d5fe0 ran for 0 msecs: key_proc_init+0x0/0x30()
Calling initcall 0xc06d61b0: selinux_nf_ip_init+0x0/0x60()
SELinux:  Registering netfilter hooks
initcall 0xc06d61b0: selinux_nf_ip_init+0x0/0x60() returned 0.
initcall 0xc06d61b0 ran for 3 msecs: selinux_nf_ip_init+0x0/0x60()
Calling initcall 0xc06d6380: init_sel_fs+0x0/0x60()
initcall 0xc06d6380: init_sel_fs+0x0/0x60() returned 0.
initcall 0xc06d6380 ran for 0 msecs: init_sel_fs+0x0/0x60()
Calling initcall 0xc06d63e0: selnl_init+0x0/0x50()
initcall 0xc06d63e0: selnl_init+0x0/0x50() returned 0.
initcall 0xc06d63e0 ran for 0 msecs: selnl_init+0x0/0x50()
Calling initcall 0xc06d6430: sel_netif_init+0x0/0x80()
initcall 0xc06d6430: sel_netif_init+0x0/0x80() returned 0.
initcall 0xc06d6430 ran for 0 msecs: sel_netif_init+0x0/0x80()
Calling initcall 0xc06d64b0: aurule_init+0x0/0x50()
initcall 0xc06d64b0: aurule_init+0x0/0x50() returned 0.
initcall 0xc06d64b0 ran for 0 msecs: aurule_init+0x0/0x50()
Calling initcall 0xc06d6500: crypto_algapi_init+0x0/0x10()
initcall 0xc06d6500: crypto_algapi_init+0x0/0x10() returned 0.
initcall 0xc06d6500 ran for 0 msecs: crypto_algapi_init+0x0/0x10()
Calling initcall 0xc06d6530: cryptomgr_init+0x0/0x10()
initcall 0xc06d6530: cryptomgr_init+0x0/0x10() returned 0.
initcall 0xc06d6530 ran for 0 msecs: cryptomgr_init+0x0/0x10()
Calling initcall 0xc06d6540: hmac_module_init+0x0/0x10()
initcall 0xc06d6540: hmac_module_init+0x0/0x10() returned 0.
initcall 0xc06d6540 ran for 0 msecs: hmac_module_init+0x0/0x10()
Calling initcall 0xc06d6550: init+0x0/0x10()
initcall 0xc06d6550: init+0x0/0x10() returned 0.
initcall 0xc06d6550 ran for 0 msecs: init+0x0/0x10()
Calling initcall 0xc06d6560: crypto_cbc_module_init+0x0/0x10()
initcall 0xc06d6560: crypto_cbc_module_init+0x0/0x10() returned 0.
initcall 0xc06d6560 ran for 0 msecs: crypto_cbc_module_init+0x0/0x10()
Calling initcall 0xc06d6910: noop_init+0x0/0x10()
io scheduler noop registered
initcall 0xc06d6910: noop_init+0x0/0x10() returned 0.
initcall 0xc06d6910 ran for 2 msecs: noop_init+0x0/0x10()
Calling initcall 0xc06d6920: cfq_init+0x0/0xd0()
io scheduler cfq registered (default)
initcall 0xc06d6920: cfq_init+0x0/0xd0() returned 0.
initcall 0xc06d6920 ran for 3 msecs: cfq_init+0x0/0xd0()
Calling initcall 0xc06d6be0: audit_classes_init+0x0/0x50()
initcall 0xc06d6be0: audit_classes_init+0x0/0x50() returned 0.
initcall 0xc06d6be0 ran for 0 msecs: audit_classes_init+0x0/0x50()
Calling initcall 0xc0244690: pci_init+0x0/0x30()
PCI: Linking AER extended capability on 0000:00:0b.0
PCI: Linking AER extended capability on 0000:00:0c.0
PCI: Linking AER extended capability on 0000:00:0d.0
PCI: Linking AER extended capability on 0000:00:0e.0
Boot video device is 0000:01:00.0
initcall 0xc0244690: pci_init+0x0/0x30() returned 0.
initcall 0xc0244690 ran for 32 msecs: pci_init+0x0/0x30()
Calling initcall 0xc06d72d0: pci_proc_init+0x0/0x70()
initcall 0xc06d72d0: pci_proc_init+0x0/0x70() returned 0.
initcall 0xc06d72d0 ran for 0 msecs: pci_proc_init+0x0/0x70()
Calling initcall 0xc06d7340: pcie_portdrv_init+0x0/0x60()
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
initcall 0xc06d7340: pcie_portdrv_init+0x0/0x60() returned 0.
initcall 0xc06d7340 ran for 62 msecs: pcie_portdrv_init+0x0/0x60()
Calling initcall 0xc06d73a0: aer_service_init+0x0/0x10()
initcall 0xc06d73a0: aer_service_init+0x0/0x10() returned 0.
initcall 0xc06d73a0 ran for 0 msecs: aer_service_init+0x0/0x10()
Calling initcall 0xc06d73b0: pci_hotplug_init+0x0/0xa0()
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall 0xc06d73b0: pci_hotplug_init+0x0/0xa0() returned 0.
initcall 0xc06d73b0 ran for 4 msecs: pci_hotplug_init+0x0/0xa0()
Calling initcall 0xc06d7460: shpcd_init+0x0/0x70()
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
initcall 0xc06d7460: shpcd_init+0x0/0x70() returned 0.
initcall 0xc06d7460 ran for 5 msecs: shpcd_init+0x0/0x70()
Calling initcall 0xc06d7700: fb_console_init+0x0/0x140()
initcall 0xc06d7700: fb_console_init+0x0/0x140() returned 0.
initcall 0xc06d7700 ran for 0 msecs: fb_console_init+0x0/0x140()
Calling initcall 0xc06d8250: vesafb_init+0x0/0x2b2()
initcall 0xc06d8250: vesafb_init+0x0/0x2b2() returned 0.
initcall 0xc06d8250 ran for 0 msecs: vesafb_init+0x0/0x2b2()
Calling initcall 0xc06d88dc: acpi_reserve_resources+0x0/0xc8()
initcall 0xc06d88dc: acpi_reserve_resources+0x0/0xc8() returned 0.
initcall 0xc06d88dc ran for 0 msecs: acpi_reserve_resources+0x0/0xc8()
Calling initcall 0xc06d9642: irqrouter_init_sysfs+0x0/0x33()
initcall 0xc06d9642: irqrouter_init_sysfs+0x0/0x33() returned 0.
initcall 0xc06d9642 ran for 0 msecs: irqrouter_init_sysfs+0x0/0x33()
Calling initcall 0xc06da080: rand_initialize+0x0/0x30()
initcall 0xc06da080: rand_initialize+0x0/0x30() returned 0.
initcall 0xc06da080 ran for 0 msecs: rand_initialize+0x0/0x30()
Calling initcall 0xc06da110: tty_init+0x0/0x1f0()
initcall 0xc06da110: tty_init+0x0/0x1f0() returned 0.
initcall 0xc06da110 ran for 2 msecs: tty_init+0x0/0x1f0()
Calling initcall 0xc06da300: pty_init+0x0/0x220()
initcall 0xc06da300: pty_init+0x0/0x220() returned 0.
initcall 0xc06da300 ran for 0 msecs: pty_init+0x0/0x220()
Calling initcall 0xc06dab50: raw_init+0x0/0xe0()
initcall 0xc06dab50: raw_init+0x0/0xe0() returned 0.
initcall 0xc06dab50 ran for 0 msecs: raw_init+0x0/0xe0()
Calling initcall 0xc06dac30: rtc_init+0x0/0x1c0()
Real Time Clock Driver v1.12ac
initcall 0xc06dac30: rtc_init+0x0/0x1c0() returned 0.
initcall 0xc06dac30 ran for 2 msecs: rtc_init+0x0/0x1c0()
Calling initcall 0xc06dadf0: hpet_init+0x0/0x60()
initcall 0xc06dadf0: hpet_init+0x0/0x60() returned 0.
initcall 0xc06dadf0 ran for 0 msecs: hpet_init+0x0/0x60()
Calling initcall 0xc06dae50: agp_init+0x0/0x40()
Linux agpgart interface v0.102 (c) Dave Jones
initcall 0xc06dae50: agp_init+0x0/0x40() returned 0.
initcall 0xc06dae50 ran for 3 msecs: agp_init+0x0/0x40()
Calling initcall 0xc06daf00: agp_ali_init+0x0/0x30()
initcall 0xc06daf00: agp_ali_init+0x0/0x30() returned 0.
initcall 0xc06daf00 ran for 0 msecs: agp_ali_init+0x0/0x30()
Calling initcall 0xc06daf30: agp_ati_init+0x0/0x30()
initcall 0xc06daf30: agp_ati_init+0x0/0x30() returned 0.
initcall 0xc06daf30 ran for 0 msecs: agp_ati_init+0x0/0x30()
Calling initcall 0xc06daf60: agp_amdk7_init+0x0/0x30()
initcall 0xc06daf60: agp_amdk7_init+0x0/0x30() returned 0.
initcall 0xc06daf60 ran for 0 msecs: agp_amdk7_init+0x0/0x30()
Calling initcall 0xc06daf90: agp_amd64_init+0x0/0xd0()
initcall 0xc06daf90: agp_amd64_init+0x0/0xd0() returned 0.
initcall 0xc06daf90 ran for 0 msecs: agp_amd64_init+0x0/0xd0()
Calling initcall 0xc06db060: agp_efficeon_init+0x0/0x40()
initcall 0xc06db060: agp_efficeon_init+0x0/0x40() returned 0.
initcall 0xc06db060 ran for 0 msecs: agp_efficeon_init+0x0/0x40()
Calling initcall 0xc06db0a0: agp_intel_init+0x0/0x30()
initcall 0xc06db0a0: agp_intel_init+0x0/0x30() returned 0.
initcall 0xc06db0a0 ran for 0 msecs: agp_intel_init+0x0/0x30()
Calling initcall 0xc06db0d0: agp_nvidia_init+0x0/0x30()
initcall 0xc06db0d0: agp_nvidia_init+0x0/0x30() returned 0.
initcall 0xc06db0d0 ran for 0 msecs: agp_nvidia_init+0x0/0x30()
Calling initcall 0xc06db100: agp_sis_init+0x0/0x30()
initcall 0xc06db100: agp_sis_init+0x0/0x30() returned 0.
initcall 0xc06db100 ran for 0 msecs: agp_sis_init+0x0/0x30()
Calling initcall 0xc06db130: agp_serverworks_init+0x0/0x30()
initcall 0xc06db130: agp_serverworks_init+0x0/0x30() returned 0.
initcall 0xc06db130 ran for 0 msecs: agp_serverworks_init+0x0/0x30()
Calling initcall 0xc06db160: agp_via_init+0x0/0x30()
initcall 0xc06db160: agp_via_init+0x0/0x30() returned 0.
initcall 0xc06db160 ran for 0 msecs: agp_via_init+0x0/0x30()
Calling initcall 0xc06db190: drm_core_init+0x0/0x140()
[drm] Initialized drm 1.1.0 20060810
initcall 0xc06db190: drm_core_init+0x0/0x140() returned 0.
initcall 0xc06db190 ran for 3 msecs: drm_core_init+0x0/0x140()
Calling initcall 0xc06db2d0: radeon_init+0x0/0x20()
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 16
[drm] Initialized radeon 1.27.0 20060524 on minor 0
initcall 0xc06db2d0: radeon_init+0x0/0x20() returned 0.
initcall 0xc06db2d0 ran for 15 msecs: radeon_init+0x0/0x20()
Calling initcall 0xc06db2f0: i810_init+0x0/0x20()
initcall 0xc06db2f0: i810_init+0x0/0x20() returned 0.
initcall 0xc06db2f0 ran for 0 msecs: i810_init+0x0/0x20()
Calling initcall 0xc06db310: i915_init+0x0/0x20()
initcall 0xc06db310: i915_init+0x0/0x20() returned 0.
initcall 0xc06db310 ran for 0 msecs: i915_init+0x0/0x20()
Calling initcall 0xc06db850: serial8250_init+0x0/0x130()
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
initcall 0xc06db850: serial8250_init+0x0/0x130() returned 0.
initcall 0xc06db850 ran for 6 msecs: serial8250_init+0x0/0x130()
Calling initcall 0xc06db980: serial8250_pnp_init+0x0/0x10()
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
initcall 0xc06db980: serial8250_pnp_init+0x0/0x10() returned 0.
initcall 0xc06db980 ran for 4 msecs: serial8250_pnp_init+0x0/0x10()
Calling initcall 0xc06db990: serial8250_pci_init+0x0/0x20()
initcall 0xc06db990: serial8250_pci_init+0x0/0x20() returned 0.
initcall 0xc06db990 ran for 0 msecs: serial8250_pci_init+0x0/0x20()
Calling initcall 0xc06dbf40: parport_default_proc_register+0x0/0x20()
initcall 0xc06dbf40: parport_default_proc_register+0x0/0x20() returned 0.
initcall 0xc06dbf40 ran for 0 msecs: parport_default_proc_register+0x0/0x20()
Calling initcall 0xc06dc340: parport_pc_init+0x0/0x1d0()
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
initcall 0xc06dc340: parport_pc_init+0x0/0x1d0() returned 0.
initcall 0xc06dc340 ran for 87 msecs: parport_pc_init+0x0/0x1d0()
Calling initcall 0xc06dc660: isa_bus_init+0x0/0x40()
initcall 0xc06dc660: isa_bus_init+0x0/0x40() returned 0.
initcall 0xc06dc660 ran for 0 msecs: isa_bus_init+0x0/0x40()
Calling initcall 0xc02e2fa0: topology_sysfs_init+0x0/0x50()
initcall 0xc02e2fa0: topology_sysfs_init+0x0/0x50() returned 0.
initcall 0xc02e2fa0 ran for 0 msecs: topology_sysfs_init+0x0/0x50()
Calling initcall 0xc06dc710: rd_init+0x0/0x1e0()
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
initcall 0xc06dc710: rd_init+0x0/0x1e0() returned 0.
initcall 0xc06dc710 ran for 6 msecs: rd_init+0x0/0x1e0()
Calling initcall 0xc06dceb0: cpqarray_init+0x0/0x2b0()
Compaq SMART2 Driver (v 2.6.0)
initcall 0xc06dceb0: cpqarray_init+0x0/0x2b0() returned 0.
initcall 0xc06dceb0 ran for 2 msecs: cpqarray_init+0x0/0x2b0()
Calling initcall 0xc06dd510: pkt_init+0x0/0x170()
initcall 0xc06dd510: pkt_init+0x0/0x170() returned 0.
initcall 0xc06dd510 ran for 0 msecs: pkt_init+0x0/0x170()
Calling initcall 0xc06dd680: e1000_init_module+0x0/0x90()
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
initcall 0xc06dd680: e1000_init_module+0x0/0x90() returned 0.
initcall 0xc06dd680 ran for 8 msecs: e1000_init_module+0x0/0x90()
Calling initcall 0xc06dd710: e100_init_module+0x0/0x60()
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall 0xc06dd710: e100_init_module+0x0/0x60() returned 0.
initcall 0xc06dd710 ran for 8 msecs: e100_init_module+0x0/0x60()
Calling initcall 0xc06dd770: tg3_init+0x0/0x20()
initcall 0xc06dd770: tg3_init+0x0/0x20() returned 0.
initcall 0xc06dd770 ran for 0 msecs: tg3_init+0x0/0x20()
Calling initcall 0xc06dd790: skge_init_module+0x0/0x20()
initcall 0xc06dd790: skge_init_module+0x0/0x20() returned 0.
initcall 0xc06dd790 ran for 0 msecs: skge_init_module+0x0/0x20()
Calling initcall 0xc06dd7b0: rhine_init+0x0/0x90()
initcall 0xc06dd7b0: rhine_init+0x0/0x90() returned 0.
initcall 0xc06dd7b0 ran for 0 msecs: rhine_init+0x0/0x90()
Calling initcall 0xc06dd8c0: net_olddevs_init+0x0/0xa0()
initcall 0xc06dd8c0: net_olddevs_init+0x0/0xa0() returned 0.
initcall 0xc06dd8c0 ran for 0 msecs: net_olddevs_init+0x0/0xa0()
Calling initcall 0xc06dd960: loopback_init+0x0/0x10()
initcall 0xc06dd960: loopback_init+0x0/0x10() returned 0.
initcall 0xc06dd960 ran for 0 msecs: loopback_init+0x0/0x10()
Calling initcall 0xc06dd970: init_nic+0x0/0x30()
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 23 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
eth0: forcedeth.c: subsystem: 01043:8141 bound to 0000:00:0a.0
initcall 0xc06dd970: init_nic+0x0/0x30() returned 0.
initcall 0xc06dd970 ran for 518 msecs: init_nic+0x0/0x30()
Calling initcall 0xc06dd9a0: rtl8139_init_module+0x0/0x20()
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
ACPI: PCI Interrupt 0000:05:07.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 18
eth1: RealTek RTL8139 at 0xf8820000, 00:c0:df:03:68:5d, IRQ 18
eth1:  Identified 8139 chip type 'RTL-8139B'
initcall 0xc06dd9a0: rtl8139_init_module+0x0/0x20() returned 0.
initcall 0xc06dd9a0 ran for 23 msecs: rtl8139_init_module+0x0/0x20()
Calling initcall 0xc06dd9c0: rtl8169_init_module+0x0/0x20()
initcall 0xc06dd9c0: rtl8169_init_module+0x0/0x20() returned 0.
initcall 0xc06dd9c0 ran for 0 msecs: rtl8169_init_module+0x0/0x20()
Calling initcall 0xc032a130: init_netconsole+0x0/0x80()
netconsole: not configured, aborting
initcall 0xc032a130: init_netconsole+0x0/0x80() returned 0.
initcall 0xc032a130 ran for 3 msecs: init_netconsole+0x0/0x80()
Calling initcall 0xc06ddcc0: spi_transport_init+0x0/0x30()
initcall 0xc06ddcc0: spi_transport_init+0x0/0x30() returned 0.
initcall 0xc06ddcc0 ran for 0 msecs: spi_transport_init+0x0/0x30()
Calling initcall 0xc06ddcf0: sas_transport_init+0x0/0xb0()
initcall 0xc06ddcf0: sas_transport_init+0x0/0xb0() returned 0.
initcall 0xc06ddcf0 ran for 0 msecs: sas_transport_init+0x0/0xb0()
Calling initcall 0xc06ddda0: sas_class_init+0x0/0x40()
initcall 0xc06ddda0: sas_class_init+0x0/0x40() returned 0.
initcall 0xc06ddda0 ran for 0 msecs: sas_class_init+0x0/0x40()
Calling initcall 0xc06ddde0: ahc_linux_init+0x0/0x70()
initcall 0xc06ddde0: ahc_linux_init+0x0/0x70() returned 0.
initcall 0xc06ddde0 ran for 0 msecs: ahc_linux_init+0x0/0x70()
Calling initcall 0xc06dde50: ahd_linux_init+0x0/0x80()
initcall 0xc06dde50: ahd_linux_init+0x0/0x80() returned 0.
initcall 0xc06dde50 ran for 0 msecs: ahd_linux_init+0x0/0x80()
Calling initcall 0xc06dded0: aic94xx_init+0x0/0x150()
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
initcall 0xc06dded0: aic94xx_init+0x0/0x150() returned 0.
initcall 0xc06dded0 ran for 5 msecs: aic94xx_init+0x0/0x150()
Calling initcall 0xc06de020: init_sd+0x0/0xc0()
initcall 0xc06de020: init_sd+0x0/0xc0() returned 0.
initcall 0xc06de020 ran for 0 msecs: init_sd+0x0/0xc0()
Calling initcall 0xc06de0e0: init_sr+0x0/0x30()
initcall 0xc06de0e0: init_sr+0x0/0x30() returned 0.
initcall 0xc06de0e0 ran for 0 msecs: init_sr+0x0/0x30()
Calling initcall 0xc06de110: init_sg+0x0/0x140()
initcall 0xc06de110: init_sg+0x0/0x140() returned 0.
initcall 0xc06de110 ran for 0 msecs: init_sg+0x0/0x140()
Calling initcall 0xc06de250: init_ch_module+0x0/0xa0()
SCSI Media Changer driver v0.25 
initcall 0xc06de250: init_ch_module+0x0/0xa0() returned 0.
initcall 0xc06de250 ran for 2 msecs: init_ch_module+0x0/0xa0()
Calling initcall 0xc06de370: ahci_init+0x0/0x20()
initcall 0xc06de370: ahci_init+0x0/0x20() returned 0.
initcall 0xc06de370 ran for 0 msecs: ahci_init+0x0/0x20()
Calling initcall 0xc06de390: k2_sata_init+0x0/0x20()
initcall 0xc06de390: k2_sata_init+0x0/0x20() returned 0.
initcall 0xc06de390 ran for 0 msecs: k2_sata_init+0x0/0x20()
Calling initcall 0xc06de3b0: piix_init+0x0/0x30()
initcall 0xc06de3b0: piix_init+0x0/0x30() returned 0.
initcall 0xc06de3b0 ran for 0 msecs: piix_init+0x0/0x30()
Calling initcall 0xc06de3e0: pdc_ata_init+0x0/0x20()
initcall 0xc06de3e0: pdc_ata_init+0x0/0x20() returned 0.
initcall 0xc06de3e0 ran for 0 msecs: pdc_ata_init+0x0/0x20()
Calling initcall 0xc06de400: qs_ata_init+0x0/0x20()
initcall 0xc06de400: qs_ata_init+0x0/0x20() returned 0.
initcall 0xc06de400 ran for 0 msecs: qs_ata_init+0x0/0x20()
Calling initcall 0xc06de420: sil_init+0x0/0x20()
initcall 0xc06de420: sil_init+0x0/0x20() returned 0.
initcall 0xc06de420 ran for 0 msecs: sil_init+0x0/0x20()
Calling initcall 0xc06de440: sil24_init+0x0/0x20()
initcall 0xc06de440: sil24_init+0x0/0x20() returned 0.
initcall 0xc06de440 ran for 0 msecs: sil24_init+0x0/0x20()
Calling initcall 0xc06de460: svia_init+0x0/0x20()
initcall 0xc06de460: svia_init+0x0/0x20() returned 0.
initcall 0xc06de460 ran for 0 msecs: svia_init+0x0/0x20()
Calling initcall 0xc06de480: vsc_sata_init+0x0/0x20()
initcall 0xc06de480: vsc_sata_init+0x0/0x20() returned 0.
initcall 0xc06de480 ran for 0 msecs: vsc_sata_init+0x0/0x20()
Calling initcall 0xc06de4a0: sis_init+0x0/0x20()
initcall 0xc06de4a0: sis_init+0x0/0x20() returned 0.
initcall 0xc06de4a0 ran for 0 msecs: sis_init+0x0/0x20()
Calling initcall 0xc06de4c0: pdc_sata_init+0x0/0x20()
initcall 0xc06de4c0: pdc_sata_init+0x0/0x20() returned 0.
initcall 0xc06de4c0 ran for 0 msecs: pdc_sata_init+0x0/0x20()
Calling initcall 0xc06de4e0: nv_init+0x0/0x20()
initcall 0xc06de4e0: nv_init+0x0/0x20() returned 0.
initcall 0xc06de4e0 ran for 0 msecs: nv_init+0x0/0x20()
Calling initcall 0xc06de500: uli_init+0x0/0x20()
initcall 0xc06de500: uli_init+0x0/0x20() returned 0.
initcall 0xc06de500 ran for 0 msecs: uli_init+0x0/0x20()
Calling initcall 0xc06de520: mv_init+0x0/0x20()
initcall 0xc06de520: mv_init+0x0/0x20() returned 0.
initcall 0xc06de520 ran for 0 msecs: mv_init+0x0/0x20()
Calling initcall 0xc06de540: adma_ata_init+0x0/0x20()
initcall 0xc06de540: adma_ata_init+0x0/0x20() returned 0.
initcall 0xc06de540 ran for 0 msecs: adma_ata_init+0x0/0x20()
Calling initcall 0xc06de560: ali_init+0x0/0x20()
initcall 0xc06de560: ali_init+0x0/0x20() returned 0.
initcall 0xc06de560 ran for 0 msecs: ali_init+0x0/0x20()
Calling initcall 0xc06de580: amd_init+0x0/0x20()
pata_amd 0000:00:06.0: version 0.3.8
PCI: Setting latency timer of device 0000:00:06.0 to 64
scsi0 : pata_amd
scsi1 : pata_amd
ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001f000 irq 14
ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001f008 irq 15
ata1.00: ata_hpa_resize 1: sectors = 78177792, hpa_sectors = 78177792
ata1.00: ATA-5: MAXTOR 6L040J2, AR1.0500, max UDMA/133
ata1.00: 78177792 sectors, multi 1: LBA 
ata1.01: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata1.01: ATA-6: ST380011A, 3.06, max UDMA/100
ata1.01: 156301488 sectors, multi 1: LBA48 
ata1.00: ata_hpa_resize 1: sectors = 78177792, hpa_sectors = 78177792
ata1.00: configured for UDMA/133
ata1.01: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata1.01: configured for UDMA/100
ATA: abnormal status 0x38 on port 0x00010177
scsi 0:0:0:0: Direct-Access     ATA      MAXTOR 6L040J2   AR1. PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 78177792 512-byte hardware sectors (40027 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 78177792 512-byte hardware sectors (40027 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:0:1:0: Direct-Access     ATA      ST380011A        3.06 PQ: 0 ANSI: 5
sd 0:0:1:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:1:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 < sdb5 >
sd 0:0:1:0: [sdb] Attached SCSI disk
sd 0:0:1:0: Attached scsi generic sg1 type 0
initcall 0xc06de580: amd_init+0x0/0x20() returned 0.
initcall 0xc06de580 ran for 625 msecs: amd_init+0x0/0x20()
Calling initcall 0xc06de5a0: artop_init+0x0/0x20()
initcall 0xc06de5a0: artop_init+0x0/0x20() returned 0.
initcall 0xc06de5a0 ran for 0 msecs: artop_init+0x0/0x20()
Calling initcall 0xc06de5c0: atiixp_init+0x0/0x20()
initcall 0xc06de5c0: atiixp_init+0x0/0x20() returned 0.
initcall 0xc06de5c0 ran for 0 msecs: atiixp_init+0x0/0x20()
Calling initcall 0xc06de5e0: cmd64x_init+0x0/0x20()
initcall 0xc06de5e0: cmd64x_init+0x0/0x20() returned 0.
initcall 0xc06de5e0 ran for 0 msecs: cmd64x_init+0x0/0x20()
Calling initcall 0xc06de600: cs5520_init+0x0/0x20()
initcall 0xc06de600: cs5520_init+0x0/0x20() returned 0.
initcall 0xc06de600 ran for 0 msecs: cs5520_init+0x0/0x20()
Calling initcall 0xc06de620: cs5530_init+0x0/0x20()
initcall 0xc06de620: cs5530_init+0x0/0x20() returned 0.
initcall 0xc06de620 ran for 0 msecs: cs5530_init+0x0/0x20()
Calling initcall 0xc06de640: cs5535_init+0x0/0x20()
initcall 0xc06de640: cs5535_init+0x0/0x20() returned 0.
initcall 0xc06de640 ran for 0 msecs: cs5535_init+0x0/0x20()
Calling initcall 0xc06de660: cy82c693_init+0x0/0x20()
initcall 0xc06de660: cy82c693_init+0x0/0x20() returned 0.
initcall 0xc06de660 ran for 0 msecs: cy82c693_init+0x0/0x20()
Calling initcall 0xc06de680: efar_init+0x0/0x20()
initcall 0xc06de680: efar_init+0x0/0x20() returned 0.
initcall 0xc06de680 ran for 0 msecs: efar_init+0x0/0x20()
Calling initcall 0xc06de6a0: hpt36x_init+0x0/0x20()
initcall 0xc06de6a0: hpt36x_init+0x0/0x20() returned 0.
initcall 0xc06de6a0 ran for 0 msecs: hpt36x_init+0x0/0x20()
Calling initcall 0xc06de6c0: hpt37x_init+0x0/0x20()
initcall 0xc06de6c0: hpt37x_init+0x0/0x20() returned 0.
initcall 0xc06de6c0 ran for 0 msecs: hpt37x_init+0x0/0x20()
Calling initcall 0xc06de6e0: hpt3x2n_init+0x0/0x20()
initcall 0xc06de6e0: hpt3x2n_init+0x0/0x20() returned 0.
initcall 0xc06de6e0 ran for 0 msecs: hpt3x2n_init+0x0/0x20()
Calling initcall 0xc06de700: hpt3x3_init+0x0/0x20()
initcall 0xc06de700: hpt3x3_init+0x0/0x20() returned 0.
initcall 0xc06de700 ran for 0 msecs: hpt3x3_init+0x0/0x20()
Calling initcall 0xc06de720: it821x_init+0x0/0x20()
initcall 0xc06de720: it821x_init+0x0/0x20() returned 0.
initcall 0xc06de720 ran for 0 msecs: it821x_init+0x0/0x20()
Calling initcall 0xc06de740: jmicron_init+0x0/0x20()
initcall 0xc06de740: jmicron_init+0x0/0x20() returned 0.
initcall 0xc06de740 ran for 0 msecs: jmicron_init+0x0/0x20()
Calling initcall 0xc06de760: netcell_init+0x0/0x20()
initcall 0xc06de760: netcell_init+0x0/0x20() returned 0.
initcall 0xc06de760 ran for 0 msecs: netcell_init+0x0/0x20()
Calling initcall 0xc06de780: ns87410_init+0x0/0x20()
initcall 0xc06de780: ns87410_init+0x0/0x20() returned 0.
initcall 0xc06de780 ran for 0 msecs: ns87410_init+0x0/0x20()
Calling initcall 0xc06de7a0: opti_init+0x0/0x20()
initcall 0xc06de7a0: opti_init+0x0/0x20() returned 0.
initcall 0xc06de7a0 ran for 0 msecs: opti_init+0x0/0x20()
Calling initcall 0xc06de7c0: optidma_init+0x0/0x20()
initcall 0xc06de7c0: optidma_init+0x0/0x20() returned 0.
initcall 0xc06de7c0 ran for 0 msecs: optidma_init+0x0/0x20()
Calling initcall 0xc06de7e0: marvell_init+0x0/0x20()
initcall 0xc06de7e0: marvell_init+0x0/0x20() returned 0.
initcall 0xc06de7e0 ran for 0 msecs: marvell_init+0x0/0x20()
Calling initcall 0xc06de800: mpiix_init+0x0/0x20()
initcall 0xc06de800: mpiix_init+0x0/0x20() returned 0.
initcall 0xc06de800 ran for 0 msecs: mpiix_init+0x0/0x20()
Calling initcall 0xc06de820: oldpiix_init+0x0/0x20()
initcall 0xc06de820: oldpiix_init+0x0/0x20() returned 0.
initcall 0xc06de820 ran for 0 msecs: oldpiix_init+0x0/0x20()
Calling initcall 0xc06de840: pdc2027x_init+0x0/0x20()
initcall 0xc06de840: pdc2027x_init+0x0/0x20() returned 0.
initcall 0xc06de840 ran for 0 msecs: pdc2027x_init+0x0/0x20()
Calling initcall 0xc06de860: pdc202xx_init+0x0/0x20()
initcall 0xc06de860: pdc202xx_init+0x0/0x20() returned 0.
initcall 0xc06de860 ran for 0 msecs: pdc202xx_init+0x0/0x20()
Calling initcall 0xc06dea10: qdi_init+0x0/0x220()
initcall 0xc06dea10: qdi_init+0x0/0x220() returned -19.
initcall 0xc06dea10 ran for 0 msecs: qdi_init+0x0/0x220()
Calling initcall 0xc06dec30: radisys_init+0x0/0x20()
initcall 0xc06dec30: radisys_init+0x0/0x20() returned 0.
initcall 0xc06dec30 ran for 0 msecs: radisys_init+0x0/0x20()
Calling initcall 0xc06dec50: rz1000_init+0x0/0x20()
initcall 0xc06dec50: rz1000_init+0x0/0x20() returned 0.
initcall 0xc06dec50 ran for 0 msecs: rz1000_init+0x0/0x20()
Calling initcall 0xc06dec70: sc1200_init+0x0/0x20()
initcall 0xc06dec70: sc1200_init+0x0/0x20() returned 0.
initcall 0xc06dec70 ran for 0 msecs: sc1200_init+0x0/0x20()
Calling initcall 0xc06dec90: serverworks_init+0x0/0x20()
initcall 0xc06dec90: serverworks_init+0x0/0x20() returned 0.
initcall 0xc06dec90 ran for 0 msecs: serverworks_init+0x0/0x20()
Calling initcall 0xc06decb0: sil680_init+0x0/0x20()
initcall 0xc06decb0: sil680_init+0x0/0x20() returned 0.
initcall 0xc06decb0 ran for 0 msecs: sil680_init+0x0/0x20()
Calling initcall 0xc06decd0: via_init+0x0/0x20()
initcall 0xc06decd0: via_init+0x0/0x20() returned 0.
initcall 0xc06decd0 ran for 0 msecs: via_init+0x0/0x20()
Calling initcall 0xc06decf0: sl82c105_init+0x0/0x20()
initcall 0xc06decf0: sl82c105_init+0x0/0x20() returned 0.
initcall 0xc06decf0 ran for 0 msecs: sl82c105_init+0x0/0x20()
Calling initcall 0xc06ded10: winbond_init+0x0/0x260()
initcall 0xc06ded10: winbond_init+0x0/0x260() returned -19.
initcall 0xc06ded10 ran for 0 msecs: winbond_init+0x0/0x260()
Calling initcall 0xc06def70: sis_init+0x0/0x20()
initcall 0xc06def70: sis_init+0x0/0x20() returned 0.
initcall 0xc06def70 ran for 0 msecs: sis_init+0x0/0x20()
Calling initcall 0xc06def90: triflex_init+0x0/0x20()
initcall 0xc06def90: triflex_init+0x0/0x20() returned 0.
initcall 0xc06def90 ran for 0 msecs: triflex_init+0x0/0x20()
Calling initcall 0xc06defb0: ata_generic_init+0x0/0x20()
initcall 0xc06defb0: ata_generic_init+0x0/0x20() returned 0.
initcall 0xc06defb0 ran for 0 msecs: ata_generic_init+0x0/0x20()
Calling initcall 0xc06defd0: fusion_init+0x0/0xe0()
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
initcall 0xc06defd0: fusion_init+0x0/0xe0() returned 0.
initcall 0xc06defd0 ran for 6 msecs: fusion_init+0x0/0xe0()
Calling initcall 0xc06df0b0: mptspi_init+0x0/0xb0()
Fusion MPT SPI Host driver 3.04.04
initcall 0xc06df0b0: mptspi_init+0x0/0xb0() returned 0.
initcall 0xc06df0b0 ran for 3 msecs: mptspi_init+0x0/0xb0()
Calling initcall 0xc06df160: mptctl_init+0x0/0x100()
Fusion MPT misc device (ioctl) driver 3.04.04
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
initcall 0xc06df160: mptctl_init+0x0/0x100() returned 0.
initcall 0xc06df160 ran for 11 msecs: mptctl_init+0x0/0x100()
Calling initcall 0xc06df260: cdrom_init+0x0/0x10()
initcall 0xc06df260: cdrom_init+0x0/0x10() returned 0.
initcall 0xc06df260 ran for 0 msecs: cdrom_init+0x0/0x10()
Calling initcall 0xc06df3c0: nonstatic_sysfs_init+0x0/0x10()
initcall 0xc06df3c0: nonstatic_sysfs_init+0x0/0x10() returned 0.
initcall 0xc06df3c0 ran for 0 msecs: nonstatic_sysfs_init+0x0/0x10()
Calling initcall 0xc06df3d0: yenta_socket_init+0x0/0x20()
initcall 0xc06df3d0: yenta_socket_init+0x0/0x20() returned 0.
initcall 0xc06df3d0 ran for 0 msecs: yenta_socket_init+0x0/0x20()
Calling initcall 0xc06df650: mon_init+0x0/0xf0()
usbmon: debugfs is not available
initcall 0xc06df650: mon_init+0x0/0xf0() returned -19.
initcall 0xc06df650 ran for 2 msecs: mon_init+0x0/0xf0()
Calling initcall 0xc06df7e0: ehci_hcd_init+0x0/0x20()
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 22 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 19, io mem 0xfeb00000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
initcall 0xc06df7e0: ehci_hcd_init+0x0/0x20() returned 0.
initcall 0xc06df7e0 ran for 149 msecs: ehci_hcd_init+0x0/0x20()
Calling initcall 0xc06df800: ohci_hcd_mod_init+0x0/0x50()
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 21 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 20, io mem 0xda102000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
initcall 0xc06df800: ohci_hcd_mod_init+0x0/0x50() returned 0.
initcall 0xc06df800 ran for 190 msecs: ohci_hcd_mod_init+0x0/0x50()
Calling initcall 0xc06df850: uhci_hcd_init+0x0/0xb0()
USB Universal Host Controller Interface driver v3.0
initcall 0xc06df850: uhci_hcd_init+0x0/0xb0() returned 0.
initcall 0xc06df850 ran for 4 msecs: uhci_hcd_init+0x0/0xb0()
Calling initcall 0xc06df9b0: i8042_init+0x0/0x410()
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall 0xc06df9b0: i8042_init+0x0/0x410() returned 0.
initcall 0xc06df9b0 ran for 15 msecs: i8042_init+0x0/0x410()
Calling initcall 0xc06dfdc0: serport_init+0x0/0x30()
initcall 0xc06dfdc0: serport_init+0x0/0x30() returned 0.
initcall 0xc06dfdc0 ran for 0 msecs: serport_init+0x0/0x30()
Calling initcall 0xc06dff10: mousedev_init+0x0/0xd0()
mice: PS/2 mouse device common for all mice
initcall 0xc06dff10: mousedev_init+0x0/0xd0() returned 0.
initcall 0xc06dff10 ran for 3 msecs: mousedev_init+0x0/0xd0()
Calling initcall 0xc06dffe0: evdev_init+0x0/0x10()
initcall 0xc06dffe0: evdev_init+0x0/0x10() returned 0.
initcall 0xc06dffe0 ran for 0 msecs: evdev_init+0x0/0x10()
Calling initcall 0xc06dfff0: atkbd_init+0x0/0x20()
initcall 0xc06dfff0: atkbd_init+0x0/0x20() returned 0.
initcall 0xc06dfff0 ran for 0 msecs: atkbd_init+0x0/0x20()
Calling initcall 0xc06e0010: psmouse_init+0x0/0x60()
input: AT Translated Set 2 keyboard as /class/input/input0
initcall 0xc06e0010: psmouse_init+0x0/0x60() returned 0.
initcall 0xc06e0010 ran for 17 msecs: psmouse_init+0x0/0x60()
Calling initcall 0xc06e0170: md_init+0x0/0xe0()
initcall 0xc06e0170: md_init+0x0/0xe0() returned 0.
initcall 0xc06e0170 ran for 0 msecs: md_init+0x0/0xe0()
Calling initcall 0xc06e0b50: pci_eisa_init_module+0x0/0x20()
initcall 0xc06e0b50: pci_eisa_init_module+0x0/0x20() returned 0.
initcall 0xc06e0b50 ran for 0 msecs: pci_eisa_init_module+0x0/0x20()
Calling initcall 0xc06e0b70: virtual_eisa_root_init+0x0/0x60()
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 4
EISA: Detected 0 cards.
initcall 0xc06e0b70: virtual_eisa_root_init+0x0/0x60() returned 0.
initcall 0xc06e0b70 ran for 8 msecs: virtual_eisa_root_init+0x0/0x60()
Calling initcall 0xc06e1430: hid_init+0x0/0x80()
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
initcall 0xc06e1430: hid_init+0x0/0x80() returned 0.
initcall 0xc06e1430 ran for 12 msecs: hid_init+0x0/0x80()
Calling initcall 0xc06e14d0: init_soundcore+0x0/0x60()
initcall 0xc06e14d0: init_soundcore+0x0/0x60() returned 0.
initcall 0xc06e14d0 ran for 0 msecs: init_soundcore+0x0/0x60()
Calling initcall 0xc06e1580: alsa_sound_init+0x0/0x80()
Advanced Linux Sound Architecture Driver Version 1.0.14 (Thu May 31 09:03:25 2007 UTC).
initcall 0xc06e1580: alsa_sound_init+0x0/0x80() returned 0.
initcall 0xc06e1580 ran for 7 msecs: alsa_sound_init+0x0/0x80()
Calling initcall 0xc06e1780: alsa_hwdep_init+0x0/0x60()
initcall 0xc06e1780: alsa_hwdep_init+0x0/0x60() returned 0.
initcall 0xc06e1780 ran for 0 msecs: alsa_hwdep_init+0x0/0x60()
Calling initcall 0xc06e17e0: alsa_timer_init+0x0/0x170()
initcall 0xc06e17e0: alsa_timer_init+0x0/0x170() returned 0.
initcall 0xc06e17e0 ran for 0 msecs: alsa_timer_init+0x0/0x170()
Calling initcall 0xc06e1950: rtctimer_init+0x0/0x100()
initcall 0xc06e1950: rtctimer_init+0x0/0x100() returned 0.
initcall 0xc06e1950 ran for 0 msecs: rtctimer_init+0x0/0x100()
Calling initcall 0xc06e1a50: alsa_pcm_init+0x0/0x60()
initcall 0xc06e1a50: alsa_pcm_init+0x0/0x60() returned 0.
initcall 0xc06e1a50 ran for 0 msecs: alsa_pcm_init+0x0/0x60()
Calling initcall 0xc06e1ab0: snd_mem_init+0x0/0x30()
initcall 0xc06e1ab0: snd_mem_init+0x0/0x30() returned 0.
initcall 0xc06e1ab0 ran for 0 msecs: snd_mem_init+0x0/0x30()
Calling initcall 0xc06e1ae0: alsa_rawmidi_init+0x0/0xa0()
initcall 0xc06e1ae0: alsa_rawmidi_init+0x0/0xa0() returned 0.
initcall 0xc06e1ae0 ran for 0 msecs: alsa_rawmidi_init+0x0/0xa0()
Calling initcall 0xc06e1b80: alsa_mixer_oss_init+0x0/0x40()
initcall 0xc06e1b80: alsa_mixer_oss_init+0x0/0x40() returned 0.
initcall 0xc06e1b80 ran for 0 msecs: alsa_mixer_oss_init+0x0/0x40()
Calling initcall 0xc06e1bc0: alsa_pcm_oss_init+0x0/0xb0()
initcall 0xc06e1bc0: alsa_pcm_oss_init+0x0/0xb0() returned 0.
initcall 0xc06e1bc0 ran for 0 msecs: alsa_pcm_oss_init+0x0/0xb0()
Calling initcall 0xc06e1c70: alsa_seq_oss_init+0x0/0x1a0()
initcall 0xc06e1c70: alsa_seq_oss_init+0x0/0x1a0() returned 0.
initcall 0xc06e1c70 ran for 0 msecs: alsa_seq_oss_init+0x0/0x1a0()
Calling initcall 0xc06e2000: alsa_seq_init+0x0/0x60()
initcall 0xc06e2000: alsa_seq_init+0x0/0x60() returned 0.
initcall 0xc06e2000 ran for 0 msecs: alsa_seq_init+0x0/0x60()
Calling initcall 0xc06e22e0: alsa_seq_device_init+0x0/0x60()
initcall 0xc06e22e0: alsa_seq_device_init+0x0/0x60() returned 0.
initcall 0xc06e22e0 ran for 0 msecs: alsa_seq_device_init+0x0/0x60()
Calling initcall 0xc06e2340: alsa_seq_midi_event_init+0x0/0x10()
initcall 0xc06e2340: alsa_seq_midi_event_init+0x0/0x10() returned 0.
initcall 0xc06e2340 ran for 0 msecs: alsa_seq_midi_event_init+0x0/0x10()
Calling initcall 0xc06e24c0: alsa_seq_dummy_init+0x0/0xd0()
initcall 0xc06e24c0: alsa_seq_dummy_init+0x0/0xd0() returned 0.
initcall 0xc06e24c0 ran for 0 msecs: alsa_seq_dummy_init+0x0/0xd0()
Calling initcall 0xc06e2590: alsa_seq_midi_init+0x0/0x40()
initcall 0xc06e2590: alsa_seq_midi_init+0x0/0x40() returned 0.
initcall 0xc06e2590 ran for 0 msecs: alsa_seq_midi_init+0x0/0x40()
Calling initcall 0xc06e25d0: alsa_seq_midi_emul_init+0x0/0x10()
initcall 0xc06e25d0: alsa_seq_midi_emul_init+0x0/0x10() returned 0.
initcall 0xc06e25d0 ran for 0 msecs: alsa_seq_midi_emul_init+0x0/0x10()
Calling initcall 0xc06e25e0: alsa_virmidi_init+0x0/0x10()
initcall 0xc06e25e0: alsa_virmidi_init+0x0/0x10() returned 0.
initcall 0xc06e25e0 ran for 0 msecs: alsa_virmidi_init+0x0/0x10()
Calling initcall 0xc06e25f0: alsa_mpu401_uart_init+0x0/0x10()
initcall 0xc06e25f0: alsa_mpu401_uart_init+0x0/0x10() returned 0.
initcall 0xc06e25f0 ran for 0 msecs: alsa_mpu401_uart_init+0x0/0x10()
Calling initcall 0xc06e2600: alsa_card_mpu401_init+0x0/0xe0()
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
initcall 0xc06e2600: alsa_card_mpu401_init+0x0/0xe0() returned 0.
initcall 0xc06e2600 ran for 458 msecs: alsa_card_mpu401_init+0x0/0xe0()
Calling initcall 0xc06e26e0: alsa_card_intel8x0_init+0x0/0x20()
ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 20 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:04.0 to 64
intel8x0_measure_ac97_clock: measured 50764 usecs
intel8x0: clocking to 46859
initcall 0xc06e26e0: alsa_card_intel8x0_init+0x0/0x20() returned 0.
initcall 0xc06e26e0 ran for 321 msecs: alsa_card_intel8x0_init+0x0/0x20()
Calling initcall 0xc06e2700: alsa_card_via82xx_init+0x0/0x20()
initcall 0xc06e2700: alsa_card_via82xx_init+0x0/0x20() returned 0.
initcall 0xc06e2700 ran for 0 msecs: alsa_card_via82xx_init+0x0/0x20()
Calling initcall 0xc06e2720: alsa_ac97_init+0x0/0x10()
initcall 0xc06e2720: alsa_ac97_init+0x0/0x10() returned 0.
initcall 0xc06e2720 ran for 0 msecs: alsa_ac97_init+0x0/0x10()
Calling initcall 0xc06e2730: alsa_card_emu10k1_init+0x0/0x20()
initcall 0xc06e2730: alsa_card_emu10k1_init+0x0/0x20() returned 0.
initcall 0xc06e2730 ran for 0 msecs: alsa_card_emu10k1_init+0x0/0x20()
Calling initcall 0xc06e2750: alsa_emu10k1_synth_init+0x0/0x20()
initcall 0xc06e2750: alsa_emu10k1_synth_init+0x0/0x20() returned 0.
initcall 0xc06e2750 ran for 0 msecs: alsa_emu10k1_synth_init+0x0/0x20()
Calling initcall 0xc06e2770: alsa_card_emu10k1x_init+0x0/0x20()
initcall 0xc06e2770: alsa_card_emu10k1x_init+0x0/0x20() returned 0.
initcall 0xc06e2770 ran for 0 msecs: alsa_card_emu10k1x_init+0x0/0x20()
Calling initcall 0xc06e2790: alsa_card_azx_init+0x0/0x20()
initcall 0xc06e2790: alsa_card_azx_init+0x0/0x20() returned 0.
initcall 0xc06e2790 ran for 0 msecs: alsa_card_azx_init+0x0/0x20()
Calling initcall 0xc06e27b0: alsa_util_mem_init+0x0/0x10()
initcall 0xc06e27b0: alsa_util_mem_init+0x0/0x10() returned 0.
initcall 0xc06e27b0 ran for 0 msecs: alsa_util_mem_init+0x0/0x10()
Calling initcall 0xc06e27c0: alsa_emux_init+0x0/0x10()
initcall 0xc06e27c0: alsa_emux_init+0x0/0x10() returned 0.
initcall 0xc06e27c0 ran for 0 msecs: alsa_emux_init+0x0/0x10()
Calling initcall 0xc06e27e0: alsa_sound_last_init+0x0/0x70()
ALSA device list:
  #0: NVidia CK804 with ALC850 at irq 21
  #1: MPU-401 UART at 0x330, irq 10
initcall 0xc06e27e0: alsa_sound_last_init+0x0/0x70() returned 0.
initcall 0xc06e27e0 ran for 8 msecs: alsa_sound_last_init+0x0/0x70()
Calling initcall 0xc06e4a10: flow_cache_init+0x0/0x1a0()
initcall 0xc06e4a10: flow_cache_init+0x0/0x1a0() returned 0.
initcall 0xc06e4a10 ran for 0 msecs: flow_cache_init+0x0/0x1a0()
Calling initcall 0xc06e4c40: llc_init+0x0/0x80()
initcall 0xc06e4c40: llc_init+0x0/0x80() returned 0.
initcall 0xc06e4c40 ran for 0 msecs: llc_init+0x0/0x80()
Calling initcall 0xc06e4cc0: snap_init+0x0/0x40()
initcall 0xc06e4cc0: snap_init+0x0/0x40() returned 0.
initcall 0xc06e4cc0 ran for 0 msecs: snap_init+0x0/0x40()
Calling initcall 0xc06e4d00: rif_init+0x0/0x70()
initcall 0xc06e4d00: rif_init+0x0/0x70() returned 0.
initcall 0xc06e4d00 ran for 0 msecs: rif_init+0x0/0x70()
Calling initcall 0xc06e4e40: blackhole_module_init+0x0/0x10()
initcall 0xc06e4e40: blackhole_module_init+0x0/0x10() returned 0.
initcall 0xc06e4e40 ran for 0 msecs: blackhole_module_init+0x0/0x10()
Calling initcall 0xc06e6210: init_syncookies+0x0/0x20()
initcall 0xc06e6210: init_syncookies+0x0/0x20() returned 0.
initcall 0xc06e6210 ran for 0 msecs: init_syncookies+0x0/0x20()
Calling initcall 0xc06e6230: xfrm4_beet_init+0x0/0x20()
initcall 0xc06e6230: xfrm4_beet_init+0x0/0x20() returned 0.
initcall 0xc06e6230 ran for 0 msecs: xfrm4_beet_init+0x0/0x20()
Calling initcall 0xc06e6250: xfrm4_transport_init+0x0/0x20()
initcall 0xc06e6250: xfrm4_transport_init+0x0/0x20() returned 0.
initcall 0xc06e6250 ran for 0 msecs: xfrm4_transport_init+0x0/0x20()
Calling initcall 0xc06e6270: xfrm4_tunnel_init+0x0/0x20()
initcall 0xc06e6270: xfrm4_tunnel_init+0x0/0x20() returned 0.
initcall 0xc06e6270 ran for 0 msecs: xfrm4_tunnel_init+0x0/0x20()
Calling initcall 0xc04f9b30: ipv4_netfilter_init+0x0/0x10()
initcall 0xc04f9b30: ipv4_netfilter_init+0x0/0x10() returned 0.
initcall 0xc04f9b30 ran for 0 msecs: ipv4_netfilter_init+0x0/0x10()
Calling initcall 0xc06e6290: inet_diag_init+0x0/0x70()
initcall 0xc06e6290: inet_diag_init+0x0/0x70() returned 0.
initcall 0xc06e6290 ran for 0 msecs: inet_diag_init+0x0/0x70()
Calling initcall 0xc06e6300: tcp_diag_init+0x0/0x10()
initcall 0xc06e6300: tcp_diag_init+0x0/0x10() returned 0.
initcall 0xc06e6300 ran for 0 msecs: tcp_diag_init+0x0/0x10()
Calling initcall 0xc06e6310: cubictcp_register+0x0/0xb0()
TCP cubic registered
initcall 0xc06e6310: cubictcp_register+0x0/0xb0() returned 0.
initcall 0xc06e6310 ran for 1 msecs: cubictcp_register+0x0/0xb0()
Calling initcall 0xc06e65b0: xfrm_user_init+0x0/0x60()
Initializing XFRM netlink socket
initcall 0xc06e65b0: xfrm_user_init+0x0/0x60() returned 0.
initcall 0xc06e65b0 ran for 2 msecs: xfrm_user_init+0x0/0x60()
Calling initcall 0xc06e6610: af_unix_init+0x0/0x80()
NET: Registered protocol family 1
initcall 0xc06e6610: af_unix_init+0x0/0x80() returned 0.
initcall 0xc06e6610 ran for 2 msecs: af_unix_init+0x0/0x80()
Calling initcall 0xc06e6690: inet6_init+0x0/0x2c0()
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
initcall 0xc06e6690: inet6_init+0x0/0x2c0() returned 0.
initcall 0xc06e6690 ran for 5 msecs: inet6_init+0x0/0x2c0()
Calling initcall 0xc06e7220: packet_init+0x0/0x60()
NET: Registered protocol family 17
initcall 0xc06e7220: packet_init+0x0/0x60() returned 0.
initcall 0xc06e7220 ran for 2 msecs: packet_init+0x0/0x60()
Calling initcall 0xc06cc840: init_lapic_nmi_sysfs+0x0/0x40()
initcall 0xc06cc840: init_lapic_nmi_sysfs+0x0/0x40() returned 0.
initcall 0xc06cc840 ran for 0 msecs: init_lapic_nmi_sysfs+0x0/0x40()
Calling initcall 0xc06cc620: check_nmi_watchdog+0x0/0x1f0()
Testing NMI watchdog ... CPU#0: NMI appears to be stuck (0->0)!
CPU#1: NMI appears to be stuck (0->0)!
initcall 0xc06cc620: check_nmi_watchdog+0x0/0x1f0() returned -1.
initcall 0xc06cc620 ran for 27 msecs: check_nmi_watchdog+0x0/0x1f0()
initcall at 0xc06cc620: check_nmi_watchdog+0x0/0x1f0(): returned with error code -1
Calling initcall 0xc06ccbb0: io_apic_bug_finalize+0x0/0x20()
initcall 0xc06ccbb0: io_apic_bug_finalize+0x0/0x20() returned 0.
initcall 0xc06ccbb0 ran for 0 msecs: io_apic_bug_finalize+0x0/0x20()
Calling initcall 0xc06ccd00: balanced_irq_init+0x0/0x1e0()
Starting balanced_irq
