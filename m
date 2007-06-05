Return-Path: <linux-kernel-owner+w=401wt.eu-S1763818AbXFEJMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763818AbXFEJMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762798AbXFEJMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:12:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47591 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762368AbXFEJMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:12:05 -0400
Date: Tue, 5 Jun 2007 11:11:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1
Message-ID: <20070605091151.GA18385@elte.hu>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
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


hm, mm1 hangs during bootup on one of my boxes:

 Calling initcall 0xc0628d39: pci_mmcfg_late_insert_resources+0x0/0x44()
 initcall 0xc0628d39: pci_mmcfg_late_insert_resources+0x0/0x44() returned 0.
 initcall 0xc0628d39 ran for 0 msecs: 
 pci_mmcfg_late_insert_resources+0x0/0x44()
 Calling initcall 0xc062abd1: tcp_congestion_default+0x0/0xf()
 initcall 0xc062abd1: tcp_congestion_default+0x0/0xf() returned 0.
 initcall 0xc062abd1 ran for 0 msecs: tcp_congestion_default+0x0/0xf()

it usually hangs in different places. Full bootlog below. Same kernel 
bzImage boots fine on another box.

the NMI watchdog warning is a bit weird:

 Calling initcall 0xc0613e4f: check_nmi_watchdog+0x0/0x1a8()
 Testing NMI watchdog ... CPU#0: NMI appears to be stuck (0->0)!
 CPU#1: NMI appears to be stuck (0->0)!
 initcall 0xc0613e4f: check_nmi_watchdog+0x0/0x1a8() returned -1.
 initcall 0xc0613e4f ran for 27 msecs: check_nmi_watchdog+0x0/0x1a8()

i'll test it in a minute with that turned off.

	Ingo

------------>
Linux version 2.6.22-rc3-mm1-v16-rc2 (mingo@dione) (gcc version 4.0.2) #9 SMP Tue Jun 5 10:48:06 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
using polling idle threads.
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f5680
Entering add_active_range(0, 0, 262128) 0 entries of 256 used
sizeof(struct page) = 32
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262128
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   262128
On node 0 totalpages: 262128
Node 0 memmap at 0xc1000000 size 8388608 first pfn 0xc1000000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 255 pages used for memmap
  HighMem zone: 32497 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
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
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260081
Kernel command line: root=/dev/sda1 console=tty earlyprintk=serial,ttyS0,115200,keep 3 debug idle=poll profile=0 initcall_debug maxcpus=2 selinux=1 enforcing=0 apic=verbose ignore_loglevel nmi_watchdog=2
kernel profiling enabled (shift: 0)
debug: ignoring loglevel setting.
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c065b000 soft=c0663000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2160.234 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1018420k/1048512k available (3370k kernel code, 29424k reserved, 1735k data, 332k init, 131008k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4e000 - 0xfffff000   ( 708 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0603000 - 0xc0656000   ( 332 kB)
      .data : 0xc044aafa - 0xc05fc91c   (1735 kB)
      .text : 0xc0100000 - 0xc044aafa   (3370 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4321.76 BogoMIPS (lpj=2160883)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
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
Freeing SMP alternatives: 16k freed
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 980 Objects with 86 Devices 310 Methods 37 Regions
 tbxface-0587 [02] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
enabled ExtINT on CPU#0
Booting processor 1/1 eip 2000
CPU 1 irqstacks, hard=c065c000 soft=c0664000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 4319.79 BogoMIPS (lpj=2159898)
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000003
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(2) -> Core 1
CPU: After all inits, caps: 178bfbff e3d3fbff 00000000 00000410 00000001 00000000 00000003
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
Total of 2 processors activated (8641.56 BogoMIPS).
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
Brought up 2 CPUs
Calling initcall 0xc0626528: init_cpufreq_transition_notifier_list+0x0/0x11()
initcall 0xc0626528: init_cpufreq_transition_notifier_list+0x0/0x11() returned 0.
initcall 0xc0626528 ran for 0 msecs: init_cpufreq_transition_notifier_list+0x0/0x11()
Calling initcall 0xc060ab73: cpufreq_tsc+0x0/0x11()
initcall 0xc060ab73: cpufreq_tsc+0x0/0x11() returned 0.
initcall 0xc060ab73 ran for 0 msecs: cpufreq_tsc+0x0/0x11()
Calling initcall 0xc060acd9: init_sched_clock+0x0/0x42()
initcall 0xc060acd9: init_sched_clock+0x0/0x42() returned 0.
initcall 0xc060acd9 ran for 0 msecs: init_sched_clock+0x0/0x42()
Calling initcall 0xc061092f: reboot_init+0x0/0x11()
initcall 0xc061092f: reboot_init+0x0/0x11() returned 0.
initcall 0xc061092f ran for 0 msecs: reboot_init+0x0/0x11()
Calling initcall 0xc061617a: print_banner+0x0/0xd()
Booting paravirtualized kernel on bare hardware
initcall 0xc061617a: print_banner+0x0/0xd() returned 0.
initcall 0xc061617a ran for 3 msecs: print_banner+0x0/0xd()
Calling initcall 0xc0617e97: sysctl_init+0x0/0x13()
initcall 0xc0617e97: sysctl_init+0x0/0x13() returned 0.
initcall 0xc0617e97 ran for 0 msecs: sysctl_init+0x0/0x13()
Calling initcall 0xc061893b: init_jiffies_clocksource+0x0/0xf()
initcall 0xc061893b: init_jiffies_clocksource+0x0/0xf() returned 0.
initcall 0xc061893b ran for 0 msecs: init_jiffies_clocksource+0x0/0xf()
Calling initcall 0xc0618c0a: pm_init+0x0/0x22()
initcall 0xc0618c0a: pm_init+0x0/0x22() returned 0.
initcall 0xc0618c0a ran for 0 msecs: pm_init+0x0/0x22()
Calling initcall 0xc0618edb: ksysfs_init+0x0/0x22()
initcall 0xc0618edb: ksysfs_init+0x0/0x22() returned 0.
initcall 0xc0618edb ran for 0 msecs: ksysfs_init+0x0/0x22()
Calling initcall 0xc061b418: filelock_init+0x0/0x37()
initcall 0xc061b418: filelock_init+0x0/0x37() returned 0.
initcall 0xc061b418 ran for 0 msecs: filelock_init+0x0/0x37()
Calling initcall 0xc061be98: init_misc_binfmt+0x0/0x33()
initcall 0xc061be98: init_misc_binfmt+0x0/0x33() returned 0.
initcall 0xc061be98 ran for 0 msecs: init_misc_binfmt+0x0/0x33()
Calling initcall 0xc061becb: init_script_binfmt+0x0/0xf()
initcall 0xc061becb: init_script_binfmt+0x0/0xf() returned 0.
initcall 0xc061becb ran for 0 msecs: init_script_binfmt+0x0/0xf()
Calling initcall 0xc061beda: init_elf_binfmt+0x0/0xf()
initcall 0xc061beda: init_elf_binfmt+0x0/0xf() returned 0.
initcall 0xc061beda ran for 0 msecs: init_elf_binfmt+0x0/0xf()
Calling initcall 0xc061cb95: securityfs_init+0x0/0x3d()
initcall 0xc061cb95: securityfs_init+0x0/0x3d() returned 0.
initcall 0xc061cb95 ran for 0 msecs: securityfs_init+0x0/0x3d()
Calling initcall 0xc061d505: random32_init+0x0/0x42()
initcall 0xc061d505: random32_init+0x0/0x42() returned 0.
initcall 0xc061d505 ran for 0 msecs: random32_init+0x0/0x42()
Calling initcall 0xc0626539: cpufreq_core_init+0x0/0x56()
initcall 0xc0626539: cpufreq_core_init+0x0/0x56() returned 0.
initcall 0xc0626539 ran for 0 msecs: cpufreq_core_init+0x0/0x56()
Calling initcall 0xc0629899: sock_init+0x0/0x5f()
initcall 0xc0629899: sock_init+0x0/0x5f() returned 0.
initcall 0xc0629899 ran for 0 msecs: sock_init+0x0/0x5f()
Calling initcall 0xc0629f72: netpoll_init+0x0/0x2f()
initcall 0xc0629f72: netpoll_init+0x0/0x2f() returned 0.
initcall 0xc0629f72 ran for 0 msecs: netpoll_init+0x0/0x2f()
Calling initcall 0xc062a21a: netlink_proto_init+0x0/0x12a()
NET: Registered protocol family 16
initcall 0xc062a21a: netlink_proto_init+0x0/0x12a() returned 0.
initcall 0xc062a21a ran for 2 msecs: netlink_proto_init+0x0/0x12a()
Calling initcall 0xc061d42d: kobject_uevent_init+0x0/0x45()
initcall 0xc061d42d: kobject_uevent_init+0x0/0x45() returned 0.
initcall 0xc061d42d ran for 0 msecs: kobject_uevent_init+0x0/0x45()
Calling initcall 0xc061d5e5: pcibus_class_init+0x0/0xf()
initcall 0xc061d5e5: pcibus_class_init+0x0/0xf() returned 0.
initcall 0xc061d5e5 ran for 0 msecs: pcibus_class_init+0x0/0xf()
Calling initcall 0xc061db0a: pci_driver_init+0x0/0xf()
initcall 0xc061db0a: pci_driver_init+0x0/0xf() returned 0.
initcall 0xc061db0a ran for 0 msecs: pci_driver_init+0x0/0xf()
Calling initcall 0xc061e0fb: backlight_class_init+0x0/0xf()
initcall 0xc061e0fb: backlight_class_init+0x0/0xf() returned 0.
initcall 0xc061e0fb ran for 0 msecs: backlight_class_init+0x0/0xf()
Calling initcall 0xc0620f16: tty_class_init+0x0/0x23()
initcall 0xc0620f16: tty_class_init+0x0/0x23() returned 0.
initcall 0xc0620f16 ran for 0 msecs: tty_class_init+0x0/0x23()
Calling initcall 0xc0621598: vtconsole_class_init+0x0/0xb5()
initcall 0xc0621598: vtconsole_class_init+0x0/0xb5() returned 0.
initcall 0xc0621598 ran for 0 msecs: vtconsole_class_init+0x0/0xb5()
Calling initcall 0xc0625fb2: lgend_pushf+0x0/0x163()
initcall 0xc0625fb2: lgend_pushf+0x0/0x163() returned 0.
initcall 0xc0625fb2 ran for 0 msecs: lgend_pushf+0x0/0x163()
Calling initcall 0xc060aaf7: init_pit_clocksource+0x0/0x65()
initcall 0xc060aaf7: init_pit_clocksource+0x0/0x65() returned 0.
initcall 0xc060aaf7 ran for 0 msecs: init_pit_clocksource+0x0/0x65()
Calling initcall 0xc060e115: mtrr_if_init+0x0/0x57()
initcall 0xc060e115: mtrr_if_init+0x0/0x57() returned 0.
initcall 0xc060e115 ran for 0 msecs: mtrr_if_init+0x0/0x57()
Calling initcall 0xc061081f: ffh_cstate_init+0x0/0x2c()
initcall 0xc061081f: ffh_cstate_init+0x0/0x2c() returned -1.
initcall 0xc061081f ran for 0 msecs: ffh_cstate_init+0x0/0x2c()
initcall at 0xc061081f: ffh_cstate_init+0x0/0x2c(): returned with error code -1
Calling initcall 0xc061dc50: acpi_pci_init+0x0/0x3f()
ACPI: bus type pci registered
initcall 0xc061dc50: acpi_pci_init+0x0/0x3f() returned 0.
initcall 0xc061dc50 ran for 2 msecs: acpi_pci_init+0x0/0x3f()
Calling initcall 0xc061f747: init_acpi_device_notify+0x0/0x45()
initcall 0xc061f747: init_acpi_device_notify+0x0/0x45() returned 0.
initcall 0xc061f747 ran for 0 msecs: init_acpi_device_notify+0x0/0x45()
Calling initcall 0xc0626c8e: dmi_id_init+0x0/0x26c()
initcall 0xc0626c8e: dmi_id_init+0x0/0x26c() returned 0.
initcall 0xc0626c8e ran for 0 msecs: dmi_id_init+0x0/0x26c()
Calling initcall 0xc06282e7: pci_access_init+0x0/0x41()
PCI: Using MMCONFIG
PCI: No mmconfig possible on device 00:18
initcall 0xc06282e7: pci_access_init+0x0/0x41() returned 0.
initcall 0xc06282e7 ran for 4 msecs: pci_access_init+0x0/0x41()
Calling initcall 0xc060a617: request_standard_resources+0x0/0x300()
Setting up standard PCI resources
initcall 0xc060a617: request_standard_resources+0x0/0x300() returned 0.
initcall 0xc060a617 ran for 5 msecs: request_standard_resources+0x0/0x300()
Calling initcall 0xc060a934: topology_init+0x0/0x2f()
initcall 0xc060a934: topology_init+0x0/0x2f() returned 0.
initcall 0xc060a934 ran for 0 msecs: topology_init+0x0/0x2f()
Calling initcall 0xc060de9d: mtrr_init_finialize+0x0/0x2c()
initcall 0xc060de9d: mtrr_init_finialize+0x0/0x2c() returned 0.
initcall 0xc060de9d ran for 0 msecs: mtrr_init_finialize+0x0/0x2c()
Calling initcall 0xc0618386: param_sysfs_init+0x0/0x17f()
initcall 0xc0618386: param_sysfs_init+0x0/0x17f() returned 0.
initcall 0xc0618386 ran for 1 msecs: param_sysfs_init+0x0/0x17f()
Calling initcall 0xc0140499: pm_sysrq_init+0x0/0x17()
initcall 0xc0140499: pm_sysrq_init+0x0/0x17() returned 0.
initcall 0xc0140499 ran for 0 msecs: pm_sysrq_init+0x0/0x17()
Calling initcall 0xc061ba84: init_bio+0x0/0xc7()
initcall 0xc061ba84: init_bio+0x0/0xc7() returned 0.
initcall 0xc061ba84 ran for 0 msecs: init_bio+0x0/0xc7()
Calling initcall 0xc061d1b4: genhd_device_init+0x0/0x50()
initcall 0xc061d1b4: genhd_device_init+0x0/0x50() returned 0.
initcall 0xc061d1b4 ran for 0 msecs: genhd_device_init+0x0/0x50()
Calling initcall 0xc061dc8f: fbmem_init+0x0/0x87()
initcall 0xc061dc8f: fbmem_init+0x0/0x87() returned 0.
initcall 0xc061dc8f ran for 0 msecs: fbmem_init+0x0/0x87()
Calling initcall 0xc061f54d: acpi_init+0x0/0x1fa()
evgpeblk-0956 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-0956 [04] ev_create_gpe_block   : GPE 20 to 5F [_GPE] 8 regs on int 0x9
evgpeblk-1052 [03] ev_initialize_gpe_bloc: Found 7 Wake, Enabled 0 Runtime GPEs in this block
evgpeblk-1052 [03] ev_initialize_gpe_bloc: Found 0 Wake, Enabled 0 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:.....................................................................................................................................................
Initialized 37/37 Regions 9/9 Fields 35/35 Buffers 68/77 Packages (989 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:...
Executed 3 _INI methods requiring 1 _STA executions (examined 91 objects)
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
initcall 0xc061f54d: acpi_init+0x0/0x1fa() returned 0.
initcall 0xc061f54d ran for 76 msecs: acpi_init+0x0/0x1fa()
Calling initcall 0xc061f78c: acpi_scan_init+0x0/0xfc()
initcall 0xc061f78c: acpi_scan_init+0x0/0xfc() returned 0.
initcall 0xc061f78c ran for 13 msecs: acpi_scan_init+0x0/0xfc()
Calling initcall 0xc061f94b: acpi_ec_init+0x0/0x55()
initcall 0xc061f94b: acpi_ec_init+0x0/0x55() returned 0.
initcall 0xc061f94b ran for 0 msecs: acpi_ec_init+0x0/0x55()
Calling initcall 0xc061fa45: acpi_pci_root_init+0x0/0x25()
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
initcall 0xc061fa45: acpi_pci_root_init+0x0/0x25() returned 0.
initcall 0xc061fa45 ran for 96 msecs: acpi_pci_root_init+0x0/0x25()
Calling initcall 0xc061fb3e: acpi_pci_link_init+0x0/0x43()
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
initcall 0xc061fb3e: acpi_pci_link_init+0x0/0x43() returned 0.
initcall 0xc061fb3e ran for 117 msecs: acpi_pci_link_init+0x0/0x43()
Calling initcall 0xc061fc18: acpi_power_init+0x0/0x69()
initcall 0xc061fc18: acpi_power_init+0x0/0x69() returned 0.
initcall 0xc061fc18 ran for 0 msecs: acpi_power_init+0x0/0x69()
Calling initcall 0xc06206ff: acpi_system_init+0x0/0xad()
initcall 0xc06206ff: acpi_system_init+0x0/0xad() returned 0.
initcall 0xc06206ff ran for 0 msecs: acpi_system_init+0x0/0xad()
Calling initcall 0xc06207ac: acpi_event_init+0x0/0x38()
initcall 0xc06207ac: acpi_event_init+0x0/0x38() returned 0.
initcall 0xc06207ac ran for 0 msecs: acpi_event_init+0x0/0x38()
Calling initcall 0xc06207e4: acpi_debug_init+0x0/0x99()
initcall 0xc06207e4: acpi_debug_init+0x0/0x99() returned 0.
initcall 0xc06207e4 ran for 0 msecs: acpi_debug_init+0x0/0x99()
Calling initcall 0xc062087d: acpi_cm_sbs_init+0x0/0x7()
initcall 0xc062087d: acpi_cm_sbs_init+0x0/0x7() returned 0.
initcall 0xc062087d ran for 0 msecs: acpi_cm_sbs_init+0x0/0x7()
Calling initcall 0xc0620884: pnp_init+0x0/0x1c()
Linux Plug and Play Support v0.97 (c) Adam Belay
initcall 0xc0620884: pnp_init+0x0/0x1c() returned 0.
initcall 0xc0620884 ran for 0 msecs: pnp_init+0x0/0x1c()
Calling initcall 0xc0620a56: pnpacpi_init+0x0/0x87()
pnp: PnP ACPI init
ACPI: bus type pnp registered
Clocksource tsc unstable (delta = 164410318 ns)
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
initcall 0xc0620a56: pnpacpi_init+0x0/0x87() returned 0.
initcall 0xc0620a56 ran for 14 msecs: pnpacpi_init+0x0/0x87()
Calling initcall 0xc0621311: misc_init+0x0/0x79()
initcall 0xc0621311: misc_init+0x0/0x79() returned 0.
initcall 0xc0621311 ran for 0 msecs: misc_init+0x0/0x79()
Calling initcall 0xc0623b60: init_scsi+0x0/0x8f()
SCSI subsystem initialized
initcall 0xc0623b60: init_scsi+0x0/0x8f() returned 0.
initcall 0xc0623b60 ran for 1 msecs: init_scsi+0x0/0x8f()
Calling initcall 0xc0624368: ata_init+0x0/0x6c()
libata version 2.21 loaded.
initcall 0xc0624368: ata_init+0x0/0x6c() returned 0.
initcall 0xc0624368 ran for 0 msecs: ata_init+0x0/0x6c()
Calling initcall 0xc06250e2: usb_init+0x0/0x106()
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall 0xc06250e2: usb_init+0x0/0x106() returned 0.
initcall 0xc06250e2 ran for 5 msecs: usb_init+0x0/0x106()
Calling initcall 0xc0625533: serio_init+0x0/0x8d()
initcall 0xc0625533: serio_init+0x0/0x8d() returned 0.
initcall 0xc0625533 ran for 0 msecs: serio_init+0x0/0x8d()
Calling initcall 0xc062590d: input_init+0x0/0x101()
initcall 0xc062590d: input_init+0x0/0x101() returned 0.
initcall 0xc062590d ran for 0 msecs: input_init+0x0/0x101()
Calling initcall 0xc0625b7a: hwmon_init+0x0/0x34()
initcall 0xc0625b7a: hwmon_init+0x0/0x34() returned 0.
initcall 0xc0625b7a ran for 0 msecs: hwmon_init+0x0/0x34()
Calling initcall 0xc0627ffb: ac97_bus_init+0x0/0xf()
initcall 0xc0627ffb: ac97_bus_init+0x0/0xf() returned 0.
initcall 0xc0627ffb ran for 0 msecs: ac97_bus_init+0x0/0xf()
Calling initcall 0xc0628e25: pci_acpi_init+0x0/0x9b()
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
initcall 0xc0628e25: pci_acpi_init+0x0/0x9b() returned 0.
initcall 0xc0628e25 ran for 82 msecs: pci_acpi_init+0x0/0x9b()
Calling initcall 0xc0628ec0: pci_legacy_init+0x0/0x105()
initcall 0xc0628ec0: pci_legacy_init+0x0/0x105() returned 0.
initcall 0xc0628ec0 ran for 0 msecs: pci_legacy_init+0x0/0x105()
Calling initcall 0xc06293cb: pcibios_irq_init+0x0/0x452()
initcall 0xc06293cb: pcibios_irq_init+0x0/0x452() returned 0.
initcall 0xc06293cb ran for 0 msecs: pcibios_irq_init+0x0/0x452()
Calling initcall 0xc062981d: pcibios_init+0x0/0x7c()
initcall 0xc062981d: pcibios_init+0x0/0x7c() returned 0.
initcall 0xc062981d ran for 0 msecs: pcibios_init+0x0/0x7c()
Calling initcall 0xc062994e: proto_init+0x0/0x2e()
initcall 0xc062994e: proto_init+0x0/0x2e() returned 0.
initcall 0xc062994e ran for 0 msecs: proto_init+0x0/0x2e()
Calling initcall 0xc0629a9e: net_dev_init+0x0/0x1d9()
initcall 0xc0629a9e: net_dev_init+0x0/0x1d9() returned 0.
initcall 0xc0629a9e ran for 0 msecs: net_dev_init+0x0/0x1d9()
Calling initcall 0xc0629ca8: neigh_init+0x0/0x7a()
initcall 0xc0629ca8: neigh_init+0x0/0x7a() returned 0.
initcall 0xc0629ca8 ran for 0 msecs: neigh_init+0x0/0x7a()
Calling initcall 0xc0629fa1: fib_rules_init+0x0/0x55()
initcall 0xc0629fa1: fib_rules_init+0x0/0x55() returned 0.
initcall 0xc0629fa1 ran for 0 msecs: fib_rules_init+0x0/0x55()
Calling initcall 0xc062a0f2: pktsched_init+0x0/0xc9()
initcall 0xc062a0f2: pktsched_init+0x0/0xc9() returned 0.
initcall 0xc062a0f2 ran for 0 msecs: pktsched_init+0x0/0xc9()
Calling initcall 0xc062a1ca: tc_filter_init+0x0/0x50()
initcall 0xc062a1ca: tc_filter_init+0x0/0x50() returned 0.
initcall 0xc062a1ca ran for 0 msecs: tc_filter_init+0x0/0x50()
Calling initcall 0xc062a344: genl_init+0x0/0xa7()
initcall 0xc062a344: genl_init+0x0/0xa7() returned 0.
initcall 0xc062a344 ran for 0 msecs: genl_init+0x0/0xa7()
Calling initcall 0xc062b82a: wireless_nlevent_init+0x0/0x2f()
initcall 0xc062b82a: wireless_nlevent_init+0x0/0x2f() returned 0.
initcall 0xc062b82a ran for 0 msecs: wireless_nlevent_init+0x0/0x2f()
Calling initcall 0xc061885a: clocksource_done_booting+0x0/0x11()
initcall 0xc061885a: clocksource_done_booting+0x0/0x11() returned 0.
initcall 0xc061885a ran for 0 msecs: clocksource_done_booting+0x0/0x11()
Calling initcall 0xc061b3a2: init_pipe_fs+0x0/0x3f()
initcall 0xc061b3a2: init_pipe_fs+0x0/0x3f() returned 0.
initcall 0xc061b3a2 ran for 0 msecs: init_pipe_fs+0x0/0x3f()
Calling initcall 0xc061bd1a: eventpoll_init+0x0/0x96()
initcall 0xc061bd1a: eventpoll_init+0x0/0x96() returned 0.
initcall 0xc061bd1a ran for 0 msecs: eventpoll_init+0x0/0x96()
Calling initcall 0xc061bdb0: anon_inode_init+0x0/0xe8()
initcall 0xc061bdb0: anon_inode_init+0x0/0xe8() returned 0.
initcall 0xc061bdb0 ran for 0 msecs: anon_inode_init+0x0/0xe8()
Calling initcall 0xc0620960: pnp_system_init+0x0/0xf()
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
initcall 0xc0620960: pnp_system_init+0x0/0xf() returned 0.
initcall 0xc0620960 ran for 10 msecs: pnp_system_init+0x0/0xf()
Calling initcall 0xc0620e36: chr_dev_init+0x0/0x86()
initcall 0xc0620e36: chr_dev_init+0x0/0x86() returned 0.
initcall 0xc0620e36 ran for 0 msecs: chr_dev_init+0x0/0x86()
Calling initcall 0xc0622b1e: firmware_class_init+0x0/0x66()
initcall 0xc0622b1e: firmware_class_init+0x0/0x66() returned 0.
initcall 0xc0622b1e ran for 0 msecs: firmware_class_init+0x0/0x66()
Calling initcall 0xc062660c: cpufreq_gov_performance_init+0x0/0xf()
initcall 0xc062660c: cpufreq_gov_performance_init+0x0/0xf() returned 0.
initcall 0xc062660c ran for 0 msecs: cpufreq_gov_performance_init+0x0/0xf()
Calling initcall 0xc062661b: cpufreq_gov_userspace_init+0x0/0x1b()
initcall 0xc062661b: cpufreq_gov_userspace_init+0x0/0x1b() returned 0.
initcall 0xc062661b ran for 0 msecs: cpufreq_gov_userspace_init+0x0/0x1b()
Calling initcall 0xc0626f0e: init_acpi_pm_clocksource+0x0/0x173()
initcall 0xc0626f0e<6>Time: acpi_pm clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
: init_acpi_pm_clocksource+0x0/0x173() returned 0.
initcall 0xc0626f0e ran for 28 msecs: init_acpi_pm_clocksource+0x0/0x173()
Calling initcall 0xc0628064: pcibios_assign_resources+0x0/0x92()
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
initcall 0xc0628064: pcibios_assign_resources+0x0/0x92() returned 0.
initcall 0xc0628064 ran for 69 msecs: pcibios_assign_resources+0x0/0x92()
Calling initcall 0xc062ae68: inet_init+0x0/0x2d6()
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall 0xc062ae68: inet_init+0x0/0x2d6() returned 0.
initcall 0xc062ae68 ran for 39 msecs: inet_init+0x0/0x2d6()
Calling initcall 0xc0608f76: populate_rootfs+0x0/0xe4()
initcall 0xc0608f76: populate_rootfs+0x0/0xe4() returned 0.
initcall 0xc0608f76 ran for 0 msecs: populate_rootfs+0x0/0xe4()
Calling initcall 0xc0609a6f: i8259A_init_sysfs+0x0/0x1d()
initcall 0xc0609a6f: i8259A_init_sysfs+0x0/0x1d() returned 0.
initcall 0xc0609a6f ran for 0 msecs: i8259A_init_sysfs+0x0/0x1d()
Calling initcall 0xc0609b4f: sbf_init+0x0/0xd2()
initcall 0xc0609b4f: sbf_init+0x0/0xd2() returned 0.
initcall 0xc0609b4f ran for 0 msecs: sbf_init+0x0/0xd2()
Calling initcall 0xc060a917: i8237A_init_sysfs+0x0/0x1d()
initcall 0xc060a917: i8237A_init_sysfs+0x0/0x1d() returned 0.
initcall 0xc060a917 ran for 0 msecs: i8237A_init_sysfs+0x0/0x1d()
Calling initcall 0xc060dce5: cache_sysfs_init+0x0/0x43()
initcall 0xc060dce5: cache_sysfs_init+0x0/0x43() returned 0.
initcall 0xc060dce5 ran for 0 msecs: cache_sysfs_init+0x0/0x43()
Calling initcall 0xc060de25: thermal_throttle_init_device+0x0/0x78()
initcall 0xc060de25: thermal_throttle_init_device+0x0/0x78() returned 0.
initcall 0xc060de25 ran for 0 msecs: thermal_throttle_init_device+0x0/0x78()
Calling initcall 0xc060f4cf: longrun_init+0x0/0x28()
initcall 0xc060f4cf: longrun_init+0x0/0x28() returned -19.
initcall 0xc060f4cf ran for 0 msecs: longrun_init+0x0/0x28()
Calling initcall 0xc060f80c: speedstep_init+0x0/0x1bf()
initcall 0xc060f80c: speedstep_init+0x0/0x1bf() returned -19.
initcall 0xc060f80c ran for 0 msecs: speedstep_init+0x0/0x1bf()
Calling initcall 0xc0610e97: apm_init+0x0/0x3bd()
apm: BIOS not found.
initcall 0xc0610e97: apm_init+0x0/0x3bd() returned -19.
initcall 0xc0610e97 ran for 1 msecs: apm_init+0x0/0x3bd()
Calling initcall 0xc06132d4: init_lapic_sysfs+0x0/0x28()
initcall 0xc06132d4: init_lapic_sysfs+0x0/0x28() returned 0.
initcall 0xc06132d4 ran for 0 msecs: init_lapic_sysfs+0x0/0x28()
Calling initcall 0xc06142cc: ioapic_init_sysfs+0x0/0xb6()
initcall 0xc06142cc: ioapic_init_sysfs+0x0/0xb6() returned 0.
initcall 0xc06142cc ran for 0 msecs: ioapic_init_sysfs+0x0/0xb6()
Calling initcall 0xc0615b98: serial8250_x86_com_init+0x0/0x26()
initcall 0xc0615b98: serial8250_x86_com_init+0x0/0x26() returned -19.
initcall 0xc0615b98 ran for 0 msecs: serial8250_x86_com_init+0x0/0x26()
Calling initcall 0xc0615ed7: hpet_register_sysfs+0x0/0x49()
initcall 0xc0615ed7: hpet_register_sysfs+0x0/0x49() returned 0.
initcall 0xc0615ed7 ran for 0 msecs: hpet_register_sysfs+0x0/0x49()
Calling initcall 0xc0616187: add_pcspkr+0x0/0x35()
initcall 0xc0616187: add_pcspkr+0x0/0x35() returned 0.
initcall 0xc0616187 ran for 0 msecs: add_pcspkr+0x0/0x35()
Calling initcall 0xc0616c5f: init_sched_debug_procfs+0x0/0x2a()
initcall 0xc0616c5f: init_sched_debug_procfs+0x0/0x2a() returned 0.
initcall 0xc0616c5f ran for 0 msecs: init_sched_debug_procfs+0x0/0x2a()
Calling initcall 0xc0617b2e: create_proc_profile+0x0/0x16c()
initcall 0xc0617b2e: create_proc_profile+0x0/0x16c() returned 0.
initcall 0xc0617b2e ran for 0 msecs: create_proc_profile+0x0/0x16c()
Calling initcall 0xc0617da4: ioresources_init+0x0/0x39()
initcall 0xc0617da4: ioresources_init+0x0/0x39() returned 0.
initcall 0xc0617da4 ran for 0 msecs: ioresources_init+0x0/0x39()
Calling initcall 0xc061802b: uid_cache_init+0x0/0x8c()
initcall 0xc061802b: uid_cache_init+0x0/0x8c() returned 0.
initcall 0xc061802b ran for 0 msecs: uid_cache_init+0x0/0x8c()
Calling initcall 0xc0618505: init_posix_timers+0x0/0x85()
initcall 0xc0618505: init_posix_timers+0x0/0x85() returned 0.
initcall 0xc0618505 ran for 0 msecs: init_posix_timers+0x0/0x85()
Calling initcall 0xc061858a: init_posix_cpu_timers+0x0/0x51()
initcall 0xc061858a: init_posix_cpu_timers+0x0/0x51() returned 0.
initcall 0xc061858a ran for 0 msecs: init_posix_cpu_timers+0x0/0x51()
Calling initcall 0xc06186cc: latency_init+0x0/0x20()
initcall 0xc06186cc: latency_init+0x0/0x20() returned 0.
initcall 0xc06186cc ran for 0 msecs: latency_init+0x0/0x20()
Calling initcall 0xc06186ec: timekeeping_init_device+0x0/0x1d()
initcall 0xc06186ec: timekeeping_init_device+0x0/0x1d() returned 0.
initcall 0xc06186ec ran for 0 msecs: timekeeping_init_device+0x0/0x1d()
Calling initcall 0xc061886b: init_clocksource_sysfs+0x0/0x43()
initcall 0xc061886b: init_clocksource_sysfs+0x0/0x43() returned 0.
initcall 0xc061886b ran for 0 msecs: init_clocksource_sysfs+0x0/0x43()
Calling initcall 0xc061894a: init_timer_list_procfs+0x0/0x2a()
initcall 0xc061894a: init_timer_list_procfs+0x0/0x2a() returned 0.
initcall 0xc061894a ran for 0 msecs: init_timer_list_procfs+0x0/0x2a()
Calling initcall 0xc06189e9: init+0x0/0x74()
initcall 0xc06189e9: init+0x0/0x74() returned 0.
initcall 0xc06189e9 ran for 0 msecs: init+0x0/0x74()
Calling initcall 0xc0618a5d: proc_dma_init+0x0/0x20()
initcall 0xc0618a5d: proc_dma_init+0x0/0x20() returned 0.
initcall 0xc0618a5d ran for 0 msecs: proc_dma_init+0x0/0x20()
Calling initcall 0xc013c40c: percpu_modinit+0x0/0x66()
initcall 0xc013c40c: percpu_modinit+0x0/0x66() returned 0.
initcall 0xc013c40c ran for 0 msecs: percpu_modinit+0x0/0x66()
Calling initcall 0xc0618be7: kallsyms_init+0x0/0x23()
initcall 0xc0618be7: kallsyms_init+0x0/0x23() returned 0.
initcall 0xc0618be7 ran for 0 msecs: kallsyms_init+0x0/0x23()
Calling initcall 0xc0618c2c: crash_notes_memory_init+0x0/0x38()
initcall 0xc0618c2c: crash_notes_memory_init+0x0/0x38() returned 0.
initcall 0xc0618c2c ran for 0 msecs: crash_notes_memory_init+0x0/0x38()
Calling initcall 0xc0618c64: ikconfig_init+0x0/0x3b()
initcall 0xc0618c64: ikconfig_init+0x0/0x3b() returned 0.
initcall 0xc0618c64 ran for 0 msecs: ikconfig_init+0x0/0x3b()
Calling initcall 0xc0618d11: audit_init+0x0/0x10b()
audit: initializing netlink socket (disabled)
audit(1181035938.234:1): initialized
initcall 0xc0618d11: audit_init+0x0/0x10b() returned 0.
initcall 0xc0618d11 ran for 7 msecs: audit_init+0x0/0x10b()
Calling initcall 0xc0618e91: init_kprobes+0x0/0x4a()
initcall 0xc0618e91: init_kprobes+0x0/0x4a() returned 0.
initcall 0xc0618e91 ran for 0 msecs: init_kprobes+0x0/0x4a()
Calling initcall 0xc0619076: relay_init+0x0/0x7()
initcall 0xc0619076: relay_init+0x0/0x7() returned 0.
initcall 0xc0619076 ran for 0 msecs: relay_init+0x0/0x7()
Calling initcall 0xc061907d: utsname_sysctl_init+0x0/0x11()
initcall 0xc061907d: utsname_sysctl_init+0x0/0x11() returned 0.
initcall 0xc061907d ran for 0 msecs: utsname_sysctl_init+0x0/0x11()
Calling initcall 0xc061a5ca: init_per_zone_pages_min+0x0/0x3c()
initcall 0xc061a5ca: init_per_zone_pages_min+0x0/0x3c() returned 0.
initcall 0xc061a5ca ran for 0 msecs: init_per_zone_pages_min+0x0/0x3c()
Calling initcall 0xc061a8a0: pdflush_init+0x0/0x16()
initcall 0xc061a8a0: pdflush_init+0x0/0x16() returned 0.
initcall 0xc061a8a0 ran for 0 msecs: pdflush_init+0x0/0x16()
Calling initcall 0xc061a8d5: kswapd_init+0x0/0x1c()
initcall 0xc061a8d5: kswapd_init+0x0/0x1c() returned 0.
initcall 0xc061a8d5 ran for 0 msecs: kswapd_init+0x0/0x1c()
Calling initcall 0xc061a8f1: setup_vmstat+0x0/0x3e()
initcall 0xc061a8f1: setup_vmstat+0x0/0x3e() returned 0.
initcall 0xc061a8f1 ran for 0 msecs: setup_vmstat+0x0/0x3e()
Calling initcall 0xc061aa51: init_emergency_pool+0x0/0x62()
highmem bounce pool size: 64 pages
initcall 0xc061aa51: init_emergency_pool+0x0/0x62() returned 0.
initcall 0xc061aa51 ran for 2 msecs: init_emergency_pool+0x0/0x62()
Calling initcall 0xc061aab3: procswaps_init+0x0/0x20()
initcall 0xc061aab3: procswaps_init+0x0/0x20() returned 0.
initcall 0xc061aab3 ran for 0 msecs: procswaps_init+0x0/0x20()
Calling initcall 0xc061aad3: kprefetchd_init+0x0/0x3f()
initcall 0xc061aad3: kprefetchd_init+0x0/0x3f() returned 0.
initcall 0xc061aad3 ran for 0 msecs: kprefetchd_init+0x0/0x3f()
Calling initcall 0xc061ab8f: hugetlb_init+0x0/0x59()
Total HugeTLB memory allocated, 0
initcall 0xc061ab8f: hugetlb_init+0x0/0x59() returned 0.
initcall 0xc061ab8f ran for 2 msecs: hugetlb_init+0x0/0x59()
Calling initcall 0xc061ac1e: init_tmpfs+0x0/0xbf()
initcall 0xc061ac1e: init_tmpfs+0x0/0xbf() returned 0.
initcall 0xc061ac1e ran for 0 msecs: init_tmpfs+0x0/0xbf()
Calling initcall 0xc061acf1: cpucache_init+0x0/0x2f()
initcall 0xc061acf1: cpucache_init+0x0/0x2f() returned 0.
initcall 0xc061acf1 ran for 0 msecs: cpucache_init+0x0/0x2f()
Calling initcall 0xc061b3e1: fasync_init+0x0/0x37()
initcall 0xc061b3e1: fasync_init+0x0/0x37() returned 0.
initcall 0xc061b3e1 ran for 0 msecs: fasync_init+0x0/0x37()
Calling initcall 0xc061b9b4: aio_setup+0x0/0x7d()
initcall 0xc061b9b4: aio_setup+0x0/0x7d() returned 0.
initcall 0xc061b9b4 ran for 0 msecs: aio_setup+0x0/0x7d()
Calling initcall 0xc061bc46: inotify_setup+0x0/0x11()
initcall 0xc061bc46: inotify_setup+0x0/0x11() returned 0.
initcall 0xc061bc46 ran for 0 msecs: inotify_setup+0x0/0x11()
Calling initcall 0xc061bc57: inotify_user_setup+0x0/0xc3()
initcall 0xc061bc57: inotify_user_setup+0x0/0xc3() returned 0.
initcall 0xc061bc57 ran for 0 msecs: inotify_user_setup+0x0/0xc3()
Calling initcall 0xc061bee9: init_mbcache+0x0/0x11()
initcall 0xc061bee9: init_mbcache+0x0/0x11() returned 0.
initcall 0xc061bee9 ran for 0 msecs: init_mbcache+0x0/0x11()
Calling initcall 0xc061befa: dquot_init+0x0/0xed()
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
initcall 0xc061befa: dquot_init+0x0/0xed() returned 0.
initcall 0xc061befa ran for 7 msecs: dquot_init+0x0/0xed()
Calling initcall 0xc061bfe7: init_v2_quota_format+0x0/0xf()
initcall 0xc061bfe7: init_v2_quota_format+0x0/0xf() returned 0.
initcall 0xc061bfe7 ran for 0 msecs: init_v2_quota_format+0x0/0xf()
Calling initcall 0xc061bff6: dnotify_init+0x0/0x37()
initcall 0xc061bff6: dnotify_init+0x0/0x37() returned 0.
initcall 0xc061bff6 ran for 0 msecs: dnotify_init+0x0/0x37()
Calling initcall 0xc061c40a: init_devpts_fs+0x0/0x30()
initcall 0xc061c40a: init_devpts_fs+0x0/0x30() returned 0.
initcall 0xc061c40a ran for 0 msecs: init_devpts_fs+0x0/0x30()
Calling initcall 0xc061c43a: init_ext3_fs+0x0/0x6e()
initcall 0xc061c43a: init_ext3_fs+0x0/0x6e() returned 0.
initcall 0xc061c43a ran for 0 msecs: init_ext3_fs+0x0/0x6e()
Calling initcall 0xc061c568: journal_init+0x0/0xd8()
initcall 0xc061c568: journal_init+0x0/0xd8() returned 0.
initcall 0xc061c568 ran for 0 msecs: journal_init+0x0/0xd8()
Calling initcall 0xc061c640: init_ext2_fs+0x0/0x6e()
initcall 0xc061c640: init_ext2_fs+0x0/0x6e() returned 0.
initcall 0xc061c640 ran for 0 msecs: init_ext2_fs+0x0/0x6e()
Calling initcall 0xc061c6e2: init_ramfs_fs+0x0/0xf()
initcall 0xc061c6e2: init_ramfs_fs+0x0/0xf() returned 0.
initcall 0xc061c6e2 ran for 0 msecs: init_ramfs_fs+0x0/0xf()
Calling initcall 0xc061c700: init_hugetlbfs_fs+0x0/0x7d()
initcall 0xc061c700: init_hugetlbfs_fs+0x0/0x7d() returned 0.
initcall 0xc061c700 ran for 0 msecs: init_hugetlbfs_fs+0x0/0x7d()
Calling initcall 0xc061c77d: init_iso9660_fs+0x0/0x70()
initcall 0xc061c77d: init_iso9660_fs+0x0/0x70() returned 0.
initcall 0xc061c77d ran for 0 msecs: init_iso9660_fs+0x0/0x70()
Calling initcall 0xc061c84e: init_nls_cp437+0x0/0xf()
initcall 0xc061c84e: init_nls_cp437+0x0/0xf() returned 0.
initcall 0xc061c84e ran for 0 msecs: init_nls_cp437+0x0/0xf()
Calling initcall 0xc061c85d: init_nls_ascii+0x0/0xf()
initcall 0xc061c85d: init_nls_ascii+0x0/0xf() returned 0.
initcall 0xc061c85d ran for 0 msecs: init_nls_ascii+0x0/0xf()
Calling initcall 0xc061c86c: ipc_init+0x0/0x16()
initcall 0xc061c86c: ipc_init+0x0/0x16() returned 0.
initcall 0xc061c86c ran for 0 msecs: ipc_init+0x0/0x16()
Calling initcall 0xc061ca8d: ipc_sysctl_init+0x0/0x11()
initcall 0xc061ca8d: ipc_sysctl_init+0x0/0x11() returned 0.
initcall 0xc061ca8d ran for 0 msecs: ipc_sysctl_init+0x0/0x11()
Calling initcall 0xc061ca9e: init_mqueue_fs+0x0/0xb8()
initcall 0xc061ca9e: init_mqueue_fs+0x0/0xb8() returned 0.
initcall 0xc061ca9e ran for 0 msecs: init_mqueue_fs+0x0/0xb8()
Calling initcall 0xc061cc9e: selinux_nf_ip_init+0x0/0x57()
SELinux:  Registering netfilter hooks
initcall 0xc061cc9e: selinux_nf_ip_init+0x0/0x57() returned 0.
initcall 0xc061cc9e ran for 3 msecs: selinux_nf_ip_init+0x0/0x57()
Calling initcall 0xc061ce18: init_sel_fs+0x0/0x52()
initcall 0xc061ce18: init_sel_fs+0x0/0x52() returned 0.
initcall 0xc061ce18 ran for 0 msecs: init_sel_fs+0x0/0x52()
Calling initcall 0xc061ce6a: selnl_init+0x0/0x4d()
initcall 0xc061ce6a: selnl_init+0x0/0x4d() returned 0.
initcall 0xc061ce6a ran for 0 msecs: selnl_init+0x0/0x4d()
Calling initcall 0xc061ceb7: sel_netif_init+0x0/0x6d()
initcall 0xc061ceb7: sel_netif_init+0x0/0x6d() returned 0.
initcall 0xc061ceb7 ran for 0 msecs: sel_netif_init+0x0/0x6d()
Calling initcall 0xc061cf24: aurule_init+0x0/0x46()
initcall 0xc061cf24: aurule_init+0x0/0x46() returned 0.
initcall 0xc061cf24 ran for 0 msecs: aurule_init+0x0/0x46()
Calling initcall 0xc061cfec: crypto_algapi_init+0x0/0xc()
initcall 0xc061cfec: crypto_algapi_init+0x0/0xc() returned 0.
initcall 0xc061cfec ran for 0 msecs: crypto_algapi_init+0x0/0xc()
Calling initcall 0xc061d016: cryptomgr_init+0x0/0xf()
initcall 0xc061d016: cryptomgr_init+0x0/0xf() returned 0.
initcall 0xc061d016 ran for 0 msecs: cryptomgr_init+0x0/0xf()
Calling initcall 0xc061d025: hmac_module_init+0x0/0xf()
initcall 0xc061d025: hmac_module_init+0x0/0xf() returned 0.
initcall 0xc061d025 ran for 0 msecs: hmac_module_init+0x0/0xf()
Calling initcall 0xc061d034: init+0x0/0xf()
initcall 0xc061d034: init+0x0/0xf() returned 0.
initcall 0xc061d034 ran for 0 msecs: init+0x0/0xf()
Calling initcall 0xc061d043: init+0x0/0xf()
initcall 0xc061d043: init+0x0/0xf() returned 0.
initcall 0xc061d043 ran for 0 msecs: init+0x0/0xf()
Calling initcall 0xc061d344: noop_init+0x0/0xf()
io scheduler noop registered
initcall 0xc061d344: noop_init+0x0/0xf() returned 0.
initcall 0xc061d344 ran for 2 msecs: noop_init+0x0/0xf()
Calling initcall 0xc061d353: as_init+0x0/0xf()
io scheduler anticipatory registered (default)
initcall 0xc061d353: as_init+0x0/0xf() returned 0.
initcall 0xc061d353 ran for 3 msecs: as_init+0x0/0xf()
Calling initcall 0xc061d362: deadline_init+0x0/0xf()
io scheduler deadline registered
initcall 0xc061d362: deadline_init+0x0/0xf() returned 0.
initcall 0xc061d362 ran for 2 msecs: deadline_init+0x0/0xf()
Calling initcall 0xc061d371: cfq_init+0x0/0xbc()
io scheduler cfq registered
initcall 0xc061d371: cfq_init+0x0/0xbc() returned 0.
initcall 0xc061d371 ran for 2 msecs: cfq_init+0x0/0xbc()
Calling initcall 0xc061d596: audit_classes_init+0x0/0x4f()
initcall 0xc061d596: audit_classes_init+0x0/0x4f() returned 0.
initcall 0xc061d596 ran for 0 msecs: audit_classes_init+0x0/0x4f()
Calling initcall 0xc01fb182: pci_init+0x0/0x2c()
PCI: Linking AER extended capability on 0000:00:0b.0
PCI: Linking AER extended capability on 0000:00:0c.0
PCI: Linking AER extended capability on 0000:00:0d.0
PCI: Linking AER extended capability on 0000:00:0e.0
Boot video device is 0000:01:00.0
initcall 0xc01fb182: pci_init+0x0/0x2c() returned 0.
initcall 0xc01fb182 ran for 32 msecs: pci_init+0x0/0x2c()
Calling initcall 0xc061db4e: pci_proc_init+0x0/0x5f()
initcall 0xc061db4e: pci_proc_init+0x0/0x5f() returned 0.
initcall 0xc061db4e ran for 0 msecs: pci_proc_init+0x0/0x5f()
Calling initcall 0xc061dbad: pci_hotplug_init+0x0/0x57()
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall 0xc061dbad: pci_hotplug_init+0x0/0x57() returned 0.
initcall 0xc061dbad ran for 4 msecs: pci_hotplug_init+0x0/0x57()
Calling initcall 0xc061ddab: fb_console_init+0x0/0x10b()
initcall 0xc061ddab: fb_console_init+0x0/0x10b() returned 0.
initcall 0xc061ddab ran for 0 msecs: fb_console_init+0x0/0x10b()
Calling initcall 0xc061e7c0: vesafb_init+0x0/0x271()
initcall 0xc061e7c0: vesafb_init+0x0/0x271() returned 0.
initcall 0xc061e7c0 ran for 0 msecs: vesafb_init+0x0/0x271()
Calling initcall 0xc061ee85: acpi_reserve_resources+0x0/0xc8()
initcall 0xc061ee85: acpi_reserve_resources+0x0/0xc8() returned 0.
initcall 0xc061ee85 ran for 0 msecs: acpi_reserve_resources+0x0/0xc8()
Calling initcall 0xc061f9f4: acpi_fan_init+0x0/0x51()
ACPI: Fan [FAN] (on)
initcall 0xc061f9f4: acpi_fan_init+0x0/0x51() returned 0.
initcall 0xc061f9f4 ran for 1 msecs: acpi_fan_init+0x0/0x51()
Calling initcall 0xc061fb0b: irqrouter_init_sysfs+0x0/0x33()
initcall 0xc061fb0b: irqrouter_init_sysfs+0x0/0x33() returned 0.
initcall 0xc061fb0b ran for 0 msecs: irqrouter_init_sysfs+0x0/0x33()
Calling initcall 0xc061fc81: acpi_processor_init+0x0/0xa4()
initcall 0xc061fc81: acpi_processor_init+0x0/0xa4() returned 0.
initcall 0xc061fc81 ran for 0 msecs: acpi_processor_init+0x0/0xa4()
Calling initcall 0xc0620669: acpi_container_init+0x0/0x45()
initcall 0xc0620669: acpi_container_init+0x0/0x45() returned 0.
initcall 0xc0620669 ran for 5 msecs: acpi_container_init+0x0/0x45()
Calling initcall 0xc06206ae: acpi_thermal_init+0x0/0x51()
ACPI: Thermal Zone [THRM] (40 C)
initcall 0xc06206ae: acpi_thermal_init+0x0/0x51() returned 0.
initcall 0xc06206ae ran for 3 msecs: acpi_thermal_init+0x0/0x51()
Calling initcall 0xc0620eca: rand_initialize+0x0/0x25()
initcall 0xc0620eca: rand_initialize+0x0/0x25() returned 0.
initcall 0xc0620eca ran for 0 msecs: rand_initialize+0x0/0x25()
Calling initcall 0xc0620f39: tty_init+0x0/0x1c9()
initcall 0xc0620f39: tty_init+0x0/0x1c9() returned 0.
initcall 0xc0620f39 ran for 2 msecs: tty_init+0x0/0x1c9()
Calling initcall 0xc0621102: pty_init+0x0/0x20f()
initcall 0xc0621102: pty_init+0x0/0x20f() returned 0.
initcall 0xc0621102 ran for 0 msecs: pty_init+0x0/0x20f()
Calling initcall 0xc06218be: hvc_lguest_init+0x0/0xf()
initcall 0xc06218be: hvc_lguest_init+0x0/0xf() returned 0.
initcall 0xc06218be ran for 0 msecs: hvc_lguest_init+0x0/0xf()
Calling initcall 0xc06218fe: hvc_init+0x0/0xe2()
initcall 0xc06218fe: hvc_init+0x0/0xe2() returned 0.
initcall 0xc06218fe ran for 0 msecs: hvc_init+0x0/0xe2()
Calling initcall 0xc06219e0: raw_init+0x0/0xc9()
initcall 0xc06219e0: raw_init+0x0/0xc9() returned 0.
initcall 0xc06219e0 ran for 0 msecs: raw_init+0x0/0xc9()
Calling initcall 0xc0621aa9: rtc_init+0x0/0x1bf()
Real Time Clock Driver v1.12ac
initcall 0xc0621aa9: rtc_init+0x0/0x1bf() returned 0.
initcall 0xc0621aa9 ran for 2 msecs: rtc_init+0x0/0x1bf()
Calling initcall 0xc0621c68: agp_init+0x0/0x2f()
Linux agpgart interface v0.102 (c) Dave Jones
initcall 0xc0621c68: agp_init+0x0/0x2f() returned 0.
initcall 0xc0621c68 ran for 3 msecs: agp_init+0x0/0x2f()
Calling initcall 0xc0621cfb: agp_ali_init+0x0/0x24()
initcall 0xc0621cfb: agp_ali_init+0x0/0x24() returned 0.
initcall 0xc0621cfb ran for 0 msecs: agp_ali_init+0x0/0x24()
Calling initcall 0xc0621d1f: agp_ati_init+0x0/0x24()
initcall 0xc0621d1f: agp_ati_init+0x0/0x24() returned 0.
initcall 0xc0621d1f ran for 0 msecs: agp_ati_init+0x0/0x24()
Calling initcall 0xc0621d43: agp_amdk7_init+0x0/0x24()
initcall 0xc0621d43: agp_amdk7_init+0x0/0x24() returned 0.
initcall 0xc0621d43 ran for 0 msecs: agp_amdk7_init+0x0/0x24()
Calling initcall 0xc0621d67: agp_amd64_init+0x0/0xa7()
initcall 0xc0621d67: agp_amd64_init+0x0/0xa7() returned 0.
initcall 0xc0621d67 ran for 0 msecs: agp_amd64_init+0x0/0xa7()
Calling initcall 0xc0621e0e: agp_efficeon_init+0x0/0x39()
initcall 0xc0621e0e: agp_efficeon_init+0x0/0x39() returned 0.
initcall 0xc0621e0e ran for 0 msecs: agp_efficeon_init+0x0/0x39()
Calling initcall 0xc0621e47: agp_intel_init+0x0/0x31()
agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
initcall 0xc0621e47: agp_intel_init+0x0/0x31() returned 0.
initcall 0xc0621e47 ran for 11 msecs: agp_intel_init+0x0/0x31()
Calling initcall 0xc0621e78: agp_nvidia_init+0x0/0x24()
initcall 0xc0621e78: agp_nvidia_init+0x0/0x24() returned 0.
initcall 0xc0621e78 ran for 0 msecs: agp_nvidia_init+0x0/0x24()
Calling initcall 0xc0621e9c: agp_sis_init+0x0/0x24()
initcall 0xc0621e9c: agp_sis_init+0x0/0x24() returned 0.
initcall 0xc0621e9c ran for 0 msecs: agp_sis_init+0x0/0x24()
Calling initcall 0xc0621ec0: agp_serverworks_init+0x0/0x24()
initcall 0xc0621ec0: agp_serverworks_init+0x0/0x24() returned 0.
initcall 0xc0621ec0 ran for 0 msecs: agp_serverworks_init+0x0/0x24()
Calling initcall 0xc0621ee4: agp_via_init+0x0/0x24()
initcall 0xc0621ee4: agp_via_init+0x0/0x24() returned 0.
initcall 0xc0621ee4 ran for 0 msecs: agp_via_init+0x0/0x24()
Calling initcall 0xc0621f08: drm_core_init+0x0/0x12d()
[drm] Initialized drm 1.1.0 20060810
initcall 0xc0621f08: drm_core_init+0x0/0x12d() returned 0.
initcall 0xc0621f08 ran for 3 msecs: drm_core_init+0x0/0x12d()
Calling initcall 0xc0622035: i810_init+0x0/0x19()
initcall 0xc0622035: i810_init+0x0/0x19() returned 0.
initcall 0xc0622035 ran for 0 msecs: i810_init+0x0/0x19()
Calling initcall 0xc062204e: i915_init+0x0/0x19()
initcall 0xc062204e: i915_init+0x0/0x19() returned 0.
initcall 0xc062204e ran for 0 msecs: i915_init+0x0/0x19()
Calling initcall 0xc06223e9: serial8250_init+0x0/0x103()
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
initcall 0xc06223e9: serial8250_init+0x0/0x103() returned 0.
initcall 0xc06223e9 ran for 6 msecs: serial8250_init+0x0/0x103()
Calling initcall 0xc06224ec: serial8250_pci_init+0x0/0x16()
initcall 0xc06224ec: serial8250_pci_init+0x0/0x16() returned 0.
initcall 0xc06224ec ran for 0 msecs: serial8250_pci_init+0x0/0x16()
Calling initcall 0xc0622aeb: isa_bus_init+0x0/0x33()
initcall 0xc0622aeb: isa_bus_init+0x0/0x33() returned 0.
initcall 0xc0622aeb ran for 0 msecs: isa_bus_init+0x0/0x33()
Calling initcall 0xc0622b84: topology_sysfs_init+0x0/0x48()
initcall 0xc0622b84: topology_sysfs_init+0x0/0x48() returned 0.
initcall 0xc0622b84 ran for 0 msecs: topology_sysfs_init+0x0/0x48()
Calling initcall 0xc0622bcc: rd_init+0x0/0x18d()
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
initcall 0xc0622bcc: rd_init+0x0/0x18d() returned 0.
initcall 0xc0622bcc ran for 6 msecs: rd_init+0x0/0x18d()
Calling initcall 0xc062326a: cpqarray_init+0x0/0x23a()
Compaq SMART2 Driver (v 2.6.0)
initcall 0xc062326a: cpqarray_init+0x0/0x23a() returned 0.
initcall 0xc062326a ran for 2 msecs: cpqarray_init+0x0/0x23a()
Calling initcall 0xc06237b2: pkt_init+0x0/0x159()
initcall 0xc06237b2: pkt_init+0x0/0x159() returned 0.
initcall 0xc06237b2 ran for 0 msecs: pkt_init+0x0/0x159()
Calling initcall 0xc062390b: lguestblk_init+0x0/0xf()
initcall 0xc062390b: lguestblk_init+0x0/0xf() returned 0.
initcall 0xc062390b ran for 0 msecs: lguestblk_init+0x0/0xf()
Calling initcall 0xc062391a: e1000_init_module+0x0/0x80()
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
initcall 0xc062391a: e1000_init_module+0x0/0x80() returned 0.
initcall 0xc062391a ran for 8 msecs: e1000_init_module+0x0/0x80()
Calling initcall 0xc062399a: e100_init_module+0x0/0x5a()
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall 0xc062399a: e100_init_module+0x0/0x5a() returned 0.
initcall 0xc062399a ran for 8 msecs: e100_init_module+0x0/0x5a()
Calling initcall 0xc06239f4: tg3_init+0x0/0x16()
initcall 0xc06239f4: tg3_init+0x0/0x16() returned 0.
initcall 0xc06239f4 ran for 0 msecs: tg3_init+0x0/0x16()
Calling initcall 0xc0623a0a: skge_init_module+0x0/0x16()
initcall 0xc0623a0a: skge_init_module+0x0/0x16() returned 0.
initcall 0xc0623a0a ran for 0 msecs: skge_init_module+0x0/0x16()
Calling initcall 0xc0623a61: net_olddevs_init+0x0/0x89()
initcall 0xc0623a61: net_olddevs_init+0x0/0x89() returned 0.
initcall 0xc0623a61 ran for 0 msecs: net_olddevs_init+0x0/0x89()
Calling initcall 0xc0623aea: loopback_init+0x0/0xf()
initcall 0xc0623aea: loopback_init+0x0/0xf() returned 0.
initcall 0xc0623aea ran for 0 msecs: loopback_init+0x0/0xf()
Calling initcall 0xc0623af9: init_nic+0x0/0x2c()
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 23 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
eth0: forcedeth.c: subsystem: 01043:8141 bound to 0000:00:0a.0
initcall 0xc0623af9: init_nic+0x0/0x2c() returned 0.
initcall 0xc0623af9 ran for 518 msecs: init_nic+0x0/0x2c()
Calling initcall 0xc0623b25: rtl8139_init_module+0x0/0x16()
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
ACPI: PCI Interrupt 0000:05:07.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
eth1: RealTek RTL8139 at 0xf881c000, 00:c0:df:03:68:5d, IRQ 17
eth1:  Identified 8139 chip type 'RTL-8139B'
initcall 0xc0623b25: rtl8139_init_module+0x0/0x16() returned 0.
initcall 0xc0623b25 ran for 23 msecs: rtl8139_init_module+0x0/0x16()
Calling initcall 0xc0623b3b: rtl8169_init_module+0x0/0x16()
initcall 0xc0623b3b: rtl8169_init_module+0x0/0x16() returned 0.
initcall 0xc0623b3b ran for 0 msecs: rtl8169_init_module+0x0/0x16()
Calling initcall 0xc02bbeb3: init_netconsole+0x0/0x67()
netconsole: not configured, aborting
initcall 0xc02bbeb3: init_netconsole+0x0/0x67() returned 0.
initcall 0xc02bbeb3 ran for 3 msecs: init_netconsole+0x0/0x67()
Calling initcall 0xc0623b51: lguestnet_init+0x0/0xf()
initcall 0xc0623b51: lguestnet_init+0x0/0xf() returned 0.
initcall 0xc0623b51 ran for 0 msecs: lguestnet_init+0x0/0xf()
Calling initcall 0xc0623dbb: spi_transport_init+0x0/0x27()
initcall 0xc0623dbb: spi_transport_init+0x0/0x27() returned 0.
initcall 0xc0623dbb ran for 0 msecs: spi_transport_init+0x0/0x27()
Calling initcall 0xc0623de2: sas_transport_init+0x0/0x9f()
initcall 0xc0623de2: sas_transport_init+0x0/0x9f() returned 0.
initcall 0xc0623de2 ran for 0 msecs: sas_transport_init+0x0/0x9f()
Calling initcall 0xc0623e81: sas_class_init+0x0/0x3d()
initcall 0xc0623e81: sas_class_init+0x0/0x3d() returned 0.
initcall 0xc0623e81 ran for 0 msecs: sas_class_init+0x0/0x3d()
Calling initcall 0xc0623ebe: ahc_linux_init+0x0/0x5c()
initcall 0xc0623ebe: ahc_linux_init+0x0/0x5c() returned 0.
initcall 0xc0623ebe ran for 0 msecs: ahc_linux_init+0x0/0x5c()
Calling initcall 0xc0623f1a: ahd_linux_init+0x0/0x6e()
initcall 0xc0623f1a: ahd_linux_init+0x0/0x6e() returned 0.
initcall 0xc0623f1a ran for 0 msecs: ahd_linux_init+0x0/0x6e()
Calling initcall 0xc0623f88: aic94xx_init+0x0/0x12e()
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
initcall 0xc0623f88: aic94xx_init+0x0/0x12e() returned 0.
initcall 0xc0623f88 ran for 5 msecs: aic94xx_init+0x0/0x12e()
Calling initcall 0xc06240b6: init_sd+0x0/0xd6()
initcall 0xc06240b6: init_sd+0x0/0xd6() returned 0.
initcall 0xc06240b6 ran for 0 msecs: init_sd+0x0/0xd6()
Calling initcall 0xc062418c: init_sr+0x0/0x22()
initcall 0xc062418c: init_sr+0x0/0x22() returned 0.
initcall 0xc062418c ran for 0 msecs: init_sr+0x0/0x22()
Calling initcall 0xc06241ae: init_sg+0x0/0x12a()
initcall 0xc06241ae: init_sg+0x0/0x12a() returned 0.
initcall 0xc06241ae ran for 0 msecs: init_sg+0x0/0x12a()
Calling initcall 0xc06242d8: init_ch_module+0x0/0x90()
SCSI Media Changer driver v0.25 
initcall 0xc06242d8: init_ch_module+0x0/0x90() returned 0.
initcall 0xc06242d8 ran for 2 msecs: init_ch_module+0x0/0x90()
Calling initcall 0xc06243d4: ahci_init+0x0/0x16()
initcall 0xc06243d4: ahci_init+0x0/0x16() returned 0.
initcall 0xc06243d4 ran for 0 msecs: ahci_init+0x0/0x16()
Calling initcall 0xc06243ea: k2_sata_init+0x0/0x16()
initcall 0xc06243ea: k2_sata_init+0x0/0x16() returned 0.
initcall 0xc06243ea ran for 0 msecs: k2_sata_init+0x0/0x16()
Calling initcall 0xc0624400: piix_init+0x0/0x27()
initcall 0xc0624400: piix_init+0x0/0x27() returned 0.
initcall 0xc0624400 ran for 0 msecs: piix_init+0x0/0x27()
Calling initcall 0xc0624427: pdc_ata_init+0x0/0x16()
initcall 0xc0624427: pdc_ata_init+0x0/0x16() returned 0.
initcall 0xc0624427 ran for 0 msecs: pdc_ata_init+0x0/0x16()
Calling initcall 0xc062443d: qs_ata_init+0x0/0x16()
initcall 0xc062443d: qs_ata_init+0x0/0x16() returned 0.
initcall 0xc062443d ran for 0 msecs: qs_ata_init+0x0/0x16()
Calling initcall 0xc0624453: sil_init+0x0/0x16()
initcall 0xc0624453: sil_init+0x0/0x16() returned 0.
initcall 0xc0624453 ran for 0 msecs: sil_init+0x0/0x16()
Calling initcall 0xc0624469: sil24_init+0x0/0x16()
initcall 0xc0624469: sil24_init+0x0/0x16() returned 0.
initcall 0xc0624469 ran for 0 msecs: sil24_init+0x0/0x16()
Calling initcall 0xc062447f: svia_init+0x0/0x16()
initcall 0xc062447f: svia_init+0x0/0x16() returned 0.
initcall 0xc062447f ran for 0 msecs: svia_init+0x0/0x16()
Calling initcall 0xc0624495: vsc_sata_init+0x0/0x16()
initcall 0xc0624495: vsc_sata_init+0x0/0x16() returned 0.
initcall 0xc0624495 ran for 0 msecs: vsc_sata_init+0x0/0x16()
Calling initcall 0xc06244ab: sis_init+0x0/0x16()
initcall 0xc06244ab: sis_init+0x0/0x16() returned 0.
initcall 0xc06244ab ran for 0 msecs: sis_init+0x0/0x16()
Calling initcall 0xc06244c1: pdc_sata_init+0x0/0x16()
initcall 0xc06244c1: pdc_sata_init+0x0/0x16() returned 0.
initcall 0xc06244c1 ran for 0 msecs: pdc_sata_init+0x0/0x16()
Calling initcall 0xc06244d7: nv_init+0x0/0x16()
initcall 0xc06244d7: nv_init+0x0/0x16() returned 0.
initcall 0xc06244d7 ran for 0 msecs: nv_init+0x0/0x16()
Calling initcall 0xc06244ed: uli_init+0x0/0x16()
initcall 0xc06244ed: uli_init+0x0/0x16() returned 0.
initcall 0xc06244ed ran for 0 msecs: uli_init+0x0/0x16()
Calling initcall 0xc0624503: mv_init+0x0/0x16()
initcall 0xc0624503: mv_init+0x0/0x16() returned 0.
initcall 0xc0624503 ran for 0 msecs: mv_init+0x0/0x16()
Calling initcall 0xc0624519: adma_ata_init+0x0/0x16()
initcall 0xc0624519: adma_ata_init+0x0/0x16() returned 0.
initcall 0xc0624519 ran for 0 msecs: adma_ata_init+0x0/0x16()
Calling initcall 0xc062452f: ali_init+0x0/0x16()
initcall 0xc062452f: ali_init+0x0/0x16() returned 0.
initcall 0xc062452f ran for 0 msecs: ali_init+0x0/0x16()
Calling initcall 0xc0624545: amd_init+0x0/0x16()
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
initcall 0xc0624545: amd_init+0x0/0x16() returned 0.
initcall 0xc0624545 ran for 662 msecs: amd_init+0x0/0x16()
Calling initcall 0xc062455b: artop_init+0x0/0x16()
initcall 0xc062455b: artop_init+0x0/0x16() returned 0.
initcall 0xc062455b ran for 0 msecs: artop_init+0x0/0x16()
Calling initcall 0xc0624571: atiixp_init+0x0/0x16()
initcall 0xc0624571: atiixp_init+0x0/0x16() returned 0.
initcall 0xc0624571 ran for 0 msecs: atiixp_init+0x0/0x16()
Calling initcall 0xc0624587: cmd64x_init+0x0/0x16()
initcall 0xc0624587: cmd64x_init+0x0/0x16() returned 0.
initcall 0xc0624587 ran for 0 msecs: cmd64x_init+0x0/0x16()
Calling initcall 0xc062459d: cs5520_init+0x0/0x16()
initcall 0xc062459d: cs5520_init+0x0/0x16() returned 0.
initcall 0xc062459d ran for 0 msecs: cs5520_init+0x0/0x16()
Calling initcall 0xc06245b3: cs5530_init+0x0/0x16()
initcall 0xc06245b3: cs5530_init+0x0/0x16() returned 0.
initcall 0xc06245b3 ran for 0 msecs: cs5530_init+0x0/0x16()
Calling initcall 0xc06245c9: cs5535_init+0x0/0x16()
initcall 0xc06245c9: cs5535_init+0x0/0x16() returned 0.
initcall 0xc06245c9 ran for 0 msecs: cs5535_init+0x0/0x16()
Calling initcall 0xc06245df: cy82c693_init+0x0/0x16()
initcall 0xc06245df: cy82c693_init+0x0/0x16() returned 0.
initcall 0xc06245df ran for 0 msecs: cy82c693_init+0x0/0x16()
Calling initcall 0xc06245f5: efar_init+0x0/0x16()
initcall 0xc06245f5: efar_init+0x0/0x16() returned 0.
initcall 0xc06245f5 ran for 0 msecs: efar_init+0x0/0x16()
Calling initcall 0xc062460b: hpt36x_init+0x0/0x16()
initcall 0xc062460b: hpt36x_init+0x0/0x16() returned 0.
initcall 0xc062460b ran for 0 msecs: hpt36x_init+0x0/0x16()
Calling initcall 0xc0624621: hpt37x_init+0x0/0x16()
initcall 0xc0624621: hpt37x_init+0x0/0x16() returned 0.
initcall 0xc0624621 ran for 0 msecs: hpt37x_init+0x0/0x16()
Calling initcall 0xc0624637: hpt3x2n_init+0x0/0x16()
initcall 0xc0624637: hpt3x2n_init+0x0/0x16() returned 0.
initcall 0xc0624637 ran for 0 msecs: hpt3x2n_init+0x0/0x16()
Calling initcall 0xc062464d: hpt3x3_init+0x0/0x16()
initcall 0xc062464d: hpt3x3_init+0x0/0x16() returned 0.
initcall 0xc062464d ran for 0 msecs: hpt3x3_init+0x0/0x16()
Calling initcall 0xc0624663: it821x_init+0x0/0x16()
initcall 0xc0624663: it821x_init+0x0/0x16() returned 0.
initcall 0xc0624663 ran for 0 msecs: it821x_init+0x0/0x16()
Calling initcall 0xc0624679: jmicron_init+0x0/0x16()
initcall 0xc0624679: jmicron_init+0x0/0x16() returned 0.
initcall 0xc0624679 ran for 0 msecs: jmicron_init+0x0/0x16()
Calling initcall 0xc062468f: netcell_init+0x0/0x16()
initcall 0xc062468f: netcell_init+0x0/0x16() returned 0.
initcall 0xc062468f ran for 0 msecs: netcell_init+0x0/0x16()
Calling initcall 0xc06246a5: ns87410_init+0x0/0x16()
initcall 0xc06246a5: ns87410_init+0x0/0x16() returned 0.
initcall 0xc06246a5 ran for 0 msecs: ns87410_init+0x0/0x16()
Calling initcall 0xc06246bb: opti_init+0x0/0x16()
initcall 0xc06246bb: opti_init+0x0/0x16() returned 0.
initcall 0xc06246bb ran for 0 msecs: opti_init+0x0/0x16()
Calling initcall 0xc06246d1: optidma_init+0x0/0x16()
initcall 0xc06246d1: optidma_init+0x0/0x16() returned 0.
initcall 0xc06246d1 ran for 0 msecs: optidma_init+0x0/0x16()
Calling initcall 0xc06246e7: marvell_init+0x0/0x16()
initcall 0xc06246e7: marvell_init+0x0/0x16() returned 0.
initcall 0xc06246e7 ran for 0 msecs: marvell_init+0x0/0x16()
Calling initcall 0xc06246fd: mpiix_init+0x0/0x16()
initcall 0xc06246fd: mpiix_init+0x0/0x16() returned 0.
initcall 0xc06246fd ran for 0 msecs: mpiix_init+0x0/0x16()
Calling initcall 0xc0624713: oldpiix_init+0x0/0x16()
initcall 0xc0624713: oldpiix_init+0x0/0x16() returned 0.
initcall 0xc0624713 ran for 0 msecs: oldpiix_init+0x0/0x16()
Calling initcall 0xc0624729: pdc2027x_init+0x0/0x16()
initcall 0xc0624729: pdc2027x_init+0x0/0x16() returned 0.
initcall 0xc0624729 ran for 0 msecs: pdc2027x_init+0x0/0x16()
Calling initcall 0xc062473f: pdc202xx_init+0x0/0x16()
initcall 0xc062473f: pdc202xx_init+0x0/0x16() returned 0.
initcall 0xc062473f ran for 0 msecs: pdc202xx_init+0x0/0x16()
Calling initcall 0xc06248d3: qdi_init+0x0/0x233()
initcall 0xc06248d3: qdi_init+0x0/0x233() returned -19.
initcall 0xc06248d3 ran for 0 msecs: qdi_init+0x0/0x233()
Calling initcall 0xc0624b06: radisys_init+0x0/0x16()
initcall 0xc0624b06: radisys_init+0x0/0x16() returned 0.
initcall 0xc0624b06 ran for 0 msecs: radisys_init+0x0/0x16()
Calling initcall 0xc0624b1c: rz1000_init+0x0/0x16()
initcall 0xc0624b1c: rz1000_init+0x0/0x16() returned 0.
initcall 0xc0624b1c ran for 0 msecs: rz1000_init+0x0/0x16()
Calling initcall 0xc0624b32: sc1200_init+0x0/0x16()
initcall 0xc0624b32: sc1200_init+0x0/0x16() returned 0.
initcall 0xc0624b32 ran for 0 msecs: sc1200_init+0x0/0x16()
Calling initcall 0xc0624b48: serverworks_init+0x0/0x16()
initcall 0xc0624b48: serverworks_init+0x0/0x16() returned 0.
initcall 0xc0624b48 ran for 0 msecs: serverworks_init+0x0/0x16()
Calling initcall 0xc0624b5e: sil680_init+0x0/0x16()
initcall 0xc0624b5e: sil680_init+0x0/0x16() returned 0.
initcall 0xc0624b5e ran for 0 msecs: sil680_init+0x0/0x16()
Calling initcall 0xc0624b74: via_init+0x0/0x16()
initcall 0xc0624b74: via_init+0x0/0x16() returned 0.
initcall 0xc0624b74 ran for 0 msecs: via_init+0x0/0x16()
Calling initcall 0xc0624b8a: sl82c105_init+0x0/0x16()
initcall 0xc0624b8a: sl82c105_init+0x0/0x16() returned 0.
initcall 0xc0624b8a ran for 0 msecs: sl82c105_init+0x0/0x16()
Calling initcall 0xc0624ba0: winbond_init+0x0/0x27b()
initcall 0xc0624ba0: winbond_init+0x0/0x27b() returned -19.
initcall 0xc0624ba0 ran for 0 msecs: winbond_init+0x0/0x27b()
Calling initcall 0xc0624e1b: sis_init+0x0/0x16()
initcall 0xc0624e1b: sis_init+0x0/0x16() returned 0.
initcall 0xc0624e1b ran for 0 msecs: sis_init+0x0/0x16()
Calling initcall 0xc0624e31: triflex_init+0x0/0x16()
initcall 0xc0624e31: triflex_init+0x0/0x16() returned 0.
initcall 0xc0624e31 ran for 0 msecs: triflex_init+0x0/0x16()
Calling initcall 0xc0624e47: ata_generic_init+0x0/0x16()
initcall 0xc0624e47: ata_generic_init+0x0/0x16() returned 0.
initcall 0xc0624e47 ran for 0 msecs: ata_generic_init+0x0/0x16()
Calling initcall 0xc0624e5d: fusion_init+0x0/0xdd()
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
initcall 0xc0624e5d: fusion_init+0x0/0xdd() returned 0.
initcall 0xc0624e5d ran for 6 msecs: fusion_init+0x0/0xdd()
Calling initcall 0xc0624f3a: mptspi_init+0x0/0xab()
Fusion MPT SPI Host driver 3.04.04
initcall 0xc0624f3a: mptspi_init+0x0/0xab() returned 0.
initcall 0xc0624f3a ran for 3 msecs: mptspi_init+0x0/0xab()
Calling initcall 0xc0624fe5: mptctl_init+0x0/0xf1()
Fusion MPT misc device (ioctl) driver 3.04.04
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
initcall 0xc0624fe5: mptctl_init+0x0/0xf1() returned 0.
initcall 0xc0624fe5 ran for 11 msecs: mptctl_init+0x0/0xf1()
Calling initcall 0xc06250d6: cdrom_init+0x0/0xc()
initcall 0xc06250d6: cdrom_init+0x0/0xc() returned 0.
initcall 0xc06250d6 ran for 0 msecs: cdrom_init+0x0/0xc()
Calling initcall 0xc06252b3: mon_init+0x0/0xe2()
usbmon: debugfs is not available
initcall 0xc06252b3: mon_init+0x0/0xe2() returned -19.
initcall 0xc06252b3 ran for 2 msecs: mon_init+0x0/0xe2()
Calling initcall 0xc0625440: ehci_hcd_init+0x0/0x16()
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 22 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 18, io mem 0xfeb00000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22-rc3-mm1-v16-rc2 ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
initcall 0xc0625440: ehci_hcd_init+0x0/0x16() returned 0.
initcall 0xc0625440 ran for 171 msecs: ehci_hcd_init+0x0/0x16()
Calling initcall 0xc0625456: ohci_hcd_mod_init+0x0/0x3e()
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 21 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 19, io mem 0xda102000
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22-rc3-mm1-v16-rc2 ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
initcall 0xc0625456: ohci_hcd_mod_init+0x0/0x3e() returned 0.
initcall 0xc0625456 ran for 212 msecs: ohci_hcd_mod_init+0x0/0x3e()
Calling initcall 0xc0625494: uhci_hcd_init+0x0/0x9f()
USB Universal Host Controller Interface driver v3.0
initcall 0xc0625494: uhci_hcd_init+0x0/0x9f() returned 0.
initcall 0xc0625494 ran for 4 msecs: uhci_hcd_init+0x0/0x9f()
Calling initcall 0xc06255c0: i8042_init+0x0/0x321()
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall 0xc06255c0: i8042_init+0x0/0x321() returned 0.
initcall 0xc06255c0 ran for 15 msecs: i8042_init+0x0/0x321()
Calling initcall 0xc06258e1: serport_init+0x0/0x2c()
initcall 0xc06258e1: serport_init+0x0/0x2c() returned 0.
initcall 0xc06258e1 ran for 0 msecs: serport_init+0x0/0x2c()
Calling initcall 0xc0625a0e: mousedev_init+0x0/0x52()
mice: PS/2 mouse device common for all mice
initcall 0xc0625a0e: mousedev_init+0x0/0x52() returned 0.
initcall 0xc0625a0e ran for 3 msecs: mousedev_init+0x0/0x52()
Calling initcall 0xc0625a60: evdev_init+0x0/0xf()
initcall 0xc0625a60: evdev_init+0x0/0xf() returned 0.
initcall 0xc0625a60 ran for 0 msecs: evdev_init+0x0/0xf()
Calling initcall 0xc0625a6f: atkbd_init+0x0/0x16()
initcall 0xc0625a6f: atkbd_init+0x0/0x16() returned 0.
initcall 0xc0625a6f ran for 0 msecs: atkbd_init+0x0/0x16()
Calling initcall 0xc0625a85: psmouse_init+0x0/0x59()
input: AT Translated Set 2 keyboard as /class/input/input0
initcall 0xc0625a85: psmouse_init+0x0/0x59() returned 0.
initcall 0xc0625a85 ran for 15 msecs: psmouse_init+0x0/0x59()
Calling initcall 0xc0625bae: md_init+0x0/0xd8()
initcall 0xc0625bae: md_init+0x0/0xd8() returned 0.
initcall 0xc0625bae ran for 0 msecs: md_init+0x0/0xd8()
Calling initcall 0xc0626115: init+0x0/0x331()
lguest: mapped switcher at ffc00000
initcall 0xc0626115: init+0x0/0x331() returned 0.
initcall 0xc0626115 ran for 3 msecs: init+0x0/0x331()
Calling initcall 0xc062658f: cpufreq_stats_init+0x0/0x7d()
initcall 0xc062658f: cpufreq_stats_init+0x0/0x7d() returned 0.
initcall 0xc062658f ran for 0 msecs: cpufreq_stats_init+0x0/0x7d()
Calling initcall 0xc0627081: hid_init+0x0/0x7()
initcall 0xc0627081: hid_init+0x0/0x7() returned 0.
initcall 0xc0627081 ran for 0 msecs: hid_init+0x0/0x7()
Calling initcall 0xc0627088: hid_init+0x0/0x5f()
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
initcall 0xc0627088: hid_init+0x0/0x5f() returned 0.
initcall 0xc0627088 ran for 12 msecs: hid_init+0x0/0x5f()
Calling initcall 0xc06270fd: init_soundcore+0x0/0x4d()
initcall 0xc06270fd: init_soundcore+0x0/0x4d() returned 0.
initcall 0xc06270fd ran for 0 msecs: init_soundcore+0x0/0x4d()
Calling initcall 0xc0627186: alsa_sound_init+0x0/0x7e()
Advanced Linux Sound Architecture Driver Version 1.0.14rc4 (Wed May 16 09:45:46 2007 UTC).
initcall 0xc0627186: alsa_sound_init+0x0/0x7e() returned 0.
initcall 0xc0627186 ran for 7 msecs: alsa_sound_init+0x0/0x7e()
Calling initcall 0xc062735e: alsa_hwdep_init+0x0/0x46()
initcall 0xc062735e: alsa_hwdep_init+0x0/0x46() returned 0.
initcall 0xc062735e ran for 0 msecs: alsa_hwdep_init+0x0/0x46()
Calling initcall 0xc06273a4: alsa_timer_init+0x0/0x140()
initcall 0xc06273a4: alsa_timer_init+0x0/0x140() returned 0.
initcall 0xc06273a4 ran for 0 msecs: alsa_timer_init+0x0/0x140()
Calling initcall 0xc06274e4: rtctimer_init+0x0/0xef()
initcall 0xc06274e4: rtctimer_init+0x0/0xef() returned 0.
initcall 0xc06274e4 ran for 0 msecs: rtctimer_init+0x0/0xef()
Calling initcall 0xc06275d3: alsa_pcm_init+0x0/0x4d()
initcall 0xc06275d3: alsa_pcm_init+0x0/0x4d() returned 0.
initcall 0xc06275d3 ran for 0 msecs: alsa_pcm_init+0x0/0x4d()
Calling initcall 0xc0627620: snd_mem_init+0x0/0x2f()
initcall 0xc0627620: snd_mem_init+0x0/0x2f() returned 0.
initcall 0xc0627620 ran for 0 msecs: snd_mem_init+0x0/0x2f()
Calling initcall 0xc062764f: alsa_rawmidi_init+0x0/0x7a()
initcall 0xc062764f: alsa_rawmidi_init+0x0/0x7a() returned 0.
initcall 0xc062764f ran for 0 msecs: alsa_rawmidi_init+0x0/0x7a()
Calling initcall 0xc06276c9: alsa_mixer_oss_init+0x0/0x30()
initcall 0xc06276c9: alsa_mixer_oss_init+0x0/0x30() returned 0.
initcall 0xc06276c9 ran for 0 msecs: alsa_mixer_oss_init+0x0/0x30()
Calling initcall 0xc06276f9: alsa_pcm_oss_init+0x0/0x84()
initcall 0xc06276f9: alsa_pcm_oss_init+0x0/0x84() returned 0.
initcall 0xc06276f9 ran for 0 msecs: alsa_pcm_oss_init+0x0/0x84()
Calling initcall 0xc062777d: alsa_seq_oss_init+0x0/0x152()
initcall 0xc062777d: alsa_seq_oss_init+0x0/0x152() returned 0.
initcall 0xc062777d ran for 0 msecs: alsa_seq_oss_init+0x0/0x152()
Calling initcall 0xc0627ac8: alsa_seq_init+0x0/0x37()
initcall 0xc0627ac8: alsa_seq_init+0x0/0x37() returned 0.
initcall 0xc0627ac8 ran for 0 msecs: alsa_seq_init+0x0/0x37()
Calling initcall 0xc0627d1a: alsa_seq_device_init+0x0/0x4e()
initcall 0xc0627d1a: alsa_seq_device_init+0x0/0x4e() returned 0.
initcall 0xc0627d1a ran for 0 msecs: alsa_seq_device_init+0x0/0x4e()
Calling initcall 0xc0627d68: alsa_seq_midi_event_init+0x0/0x7()
initcall 0xc0627d68: alsa_seq_midi_event_init+0x0/0x7() returned 0.
initcall 0xc0627d68 ran for 0 msecs: alsa_seq_midi_event_init+0x0/0x7()
Calling initcall 0xc0627eab: alsa_seq_dummy_init+0x0/0xaa()
initcall 0xc0627eab: alsa_seq_dummy_init+0x0/0xaa() returned 0.
initcall 0xc0627eab ran for 0 msecs: alsa_seq_dummy_init+0x0/0xaa()
Calling initcall 0xc0627f55: alsa_seq_midi_init+0x0/0x28()
initcall 0xc0627f55: alsa_seq_midi_init+0x0/0x28() returned 0.
initcall 0xc0627f55 ran for 0 msecs: alsa_seq_midi_init+0x0/0x28()
Calling initcall 0xc0627f7d: alsa_seq_midi_emul_init+0x0/0x7()
initcall 0xc0627f7d: alsa_seq_midi_emul_init+0x0/0x7() returned 0.
initcall 0xc0627f7d ran for 0 msecs: alsa_seq_midi_emul_init+0x0/0x7()
Calling initcall 0xc0627f84: alsa_virmidi_init+0x0/0x7()
initcall 0xc0627f84: alsa_virmidi_init+0x0/0x7() returned 0.
initcall 0xc0627f84 ran for 0 msecs: alsa_virmidi_init+0x0/0x7()
Calling initcall 0xc0627f8b: alsa_ac97_init+0x0/0x7()
initcall 0xc0627f8b: alsa_ac97_init+0x0/0x7() returned 0.
initcall 0xc0627f8b ran for 0 msecs: alsa_ac97_init+0x0/0x7()
Calling initcall 0xc0627f92: alsa_card_emu10k1_init+0x0/0x16()
initcall 0xc0627f92: alsa_card_emu10k1_init+0x0/0x16() returned 0.
initcall 0xc0627f92 ran for 0 msecs: alsa_card_emu10k1_init+0x0/0x16()
Calling initcall 0xc0627fa8: alsa_emu10k1_synth_init+0x0/0x19()
initcall 0xc0627fa8: alsa_emu10k1_synth_init+0x0/0x19() returned 0.
initcall 0xc0627fa8 ran for 0 msecs: alsa_emu10k1_synth_init+0x0/0x19()
Calling initcall 0xc0627fc1: alsa_card_emu10k1x_init+0x0/0x16()
initcall 0xc0627fc1: alsa_card_emu10k1x_init+0x0/0x16() returned 0.
initcall 0xc0627fc1 ran for 0 msecs: alsa_card_emu10k1x_init+0x0/0x16()
Calling initcall 0xc0627fd7: alsa_card_azx_init+0x0/0x16()
initcall 0xc0627fd7: alsa_card_azx_init+0x0/0x16() returned 0.
initcall 0xc0627fd7 ran for 0 msecs: alsa_card_azx_init+0x0/0x16()
Calling initcall 0xc0627fed: alsa_util_mem_init+0x0/0x7()
initcall 0xc0627fed: alsa_util_mem_init+0x0/0x7() returned 0.
initcall 0xc0627fed ran for 0 msecs: alsa_util_mem_init+0x0/0x7()
Calling initcall 0xc0627ff4: alsa_emux_init+0x0/0x7()
initcall 0xc0627ff4: alsa_emux_init+0x0/0x7() returned 0.
initcall 0xc0627ff4 ran for 0 msecs: alsa_emux_init+0x0/0x7()
Calling initcall 0xc062800a: alsa_sound_last_init+0x0/0x5a()
ALSA device list:
  No soundcards found.
initcall 0xc062800a: alsa_sound_last_init+0x0/0x5a() returned 0.
initcall 0xc062800a ran for 3 msecs: alsa_sound_last_init+0x0/0x5a()
Calling initcall 0xc0629e1c: flow_cache_init+0x0/0x156()
initcall 0xc0629e1c: flow_cache_init+0x0/0x156() returned 0.
initcall 0xc0629e1c ran for 0 msecs: flow_cache_init+0x0/0x156()
Calling initcall 0xc0629ff6: llc_init+0x0/0x68()
initcall 0xc0629ff6: llc_init+0x0/0x68() returned 0.
initcall 0xc0629ff6 ran for 0 msecs: llc_init+0x0/0x68()
Calling initcall 0xc062a05e: snap_init+0x0/0x2c()
initcall 0xc062a05e: snap_init+0x0/0x2c() returned 0.
initcall 0xc062a05e ran for 0 msecs: snap_init+0x0/0x2c()
Calling initcall 0xc062a08a: rif_init+0x0/0x68()
initcall 0xc062a08a: rif_init+0x0/0x68() returned 0.
initcall 0xc062a08a ran for 0 msecs: rif_init+0x0/0x68()
Calling initcall 0xc062a1bb: blackhole_module_init+0x0/0xf()
initcall 0xc062a1bb: blackhole_module_init+0x0/0xf() returned 0.
initcall 0xc062a1bb ran for 0 msecs: blackhole_module_init+0x0/0xf()
Calling initcall 0xc062b3e8: init_syncookies+0x0/0x16()
initcall 0xc062b3e8: init_syncookies+0x0/0x16() returned 0.
initcall 0xc062b3e8 ran for 0 msecs: init_syncookies+0x0/0x16()
Calling initcall 0xc062b3fe: xfrm4_beet_init+0x0/0x14()
initcall 0xc062b3fe: xfrm4_beet_init+0x0/0x14() returned 0.
initcall 0xc062b3fe ran for 0 msecs: xfrm4_beet_init+0x0/0x14()
Calling initcall 0xc062b412: xfrm4_transport_init+0x0/0x14()
initcall 0xc062b412: xfrm4_transport_init+0x0/0x14() returned 0.
initcall 0xc062b412 ran for 0 msecs: xfrm4_transport_init+0x0/0x14()
Calling initcall 0xc062b426: xfrm4_tunnel_init+0x0/0x14()
initcall 0xc062b426: xfrm4_tunnel_init+0x0/0x14() returned 0.
initcall 0xc062b426 ran for 0 msecs: xfrm4_tunnel_init+0x0/0x14()
Calling initcall 0xc04326d8: ipv4_netfilter_init+0x0/0xf()
initcall 0xc04326d8: ipv4_netfilter_init+0x0/0xf() returned 0.
initcall 0xc04326d8 ran for 0 msecs: ipv4_netfilter_init+0x0/0xf()
Calling initcall 0xc062b43a: inet_diag_init+0x0/0x60()
initcall 0xc062b43a: inet_diag_init+0x0/0x60() returned 0.
initcall 0xc062b43a ran for 0 msecs: inet_diag_init+0x0/0x60()
Calling initcall 0xc062b49a: tcp_diag_init+0x0/0xf()
initcall 0xc062b49a: tcp_diag_init+0x0/0xf() returned 0.
initcall 0xc062b49a ran for 0 msecs: tcp_diag_init+0x0/0xf()
Calling initcall 0xc062b4a9: cubictcp_register+0x0/0x93()
TCP cubic registered
initcall 0xc062b4a9: cubictcp_register+0x0/0x93() returned 0.
initcall 0xc062b4a9 ran for 1 msecs: cubictcp_register+0x0/0x93()
Calling initcall 0xc062b6fa: xfrm_user_init+0x0/0x52()
Initializing XFRM netlink socket
initcall 0xc062b6fa: xfrm_user_init+0x0/0x52() returned 0.
initcall 0xc062b6fa ran for 2 msecs: xfrm_user_init+0x0/0x52()
Calling initcall 0xc062b74c: af_unix_init+0x0/0x64()
NET: Registered protocol family 1
initcall 0xc062b74c: af_unix_init+0x0/0x64() returned 0.
initcall 0xc062b74c ran for 2 msecs: af_unix_init+0x0/0x64()
Calling initcall 0xc062b7b0: packet_init+0x0/0x4c()
NET: Registered protocol family 17
initcall 0xc062b7b0: packet_init+0x0/0x4c() returned 0.
initcall 0xc062b7b0 ran for 2 msecs: packet_init+0x0/0x4c()
Calling initcall 0xc060e4e4: powernow_init+0x0/0x114()
initcall 0xc060e4e4: powernow_init+0x0/0x114() returned -19.
initcall 0xc060e4e4 ran for 0 msecs: powernow_init+0x0/0x114()
Calling initcall 0xc060ea62: longhaul_init+0x0/0x6b()
initcall 0xc060ea62: longhaul_init+0x0/0x6b() returned -19.
initcall 0xc060ea62 ran for 0 msecs: longhaul_init+0x0/0x6b()
Calling initcall 0xc060f9cb: acpi_cpufreq_init+0x0/0x8f()
initcall 0xc060f9cb: acpi_cpufreq_init+0x0/0x8f() returned -19.
initcall 0xc060f9cb ran for 0 msecs: acpi_cpufreq_init+0x0/0x8f()
Calling initcall 0xc060fa5a: centrino_init+0x0/0x9e()
initcall 0xc060fa5a: centrino_init+0x0/0x9e() returned -19.
initcall 0xc060fa5a ran for 0 msecs: centrino_init+0x0/0x9e()
Calling initcall 0xc061401e: init_lapic_nmi_sysfs+0x0/0x33()
initcall 0xc061401e: init_lapic_nmi_sysfs+0x0/0x33() returned 0.
initcall 0xc061401e ran for 0 msecs: init_lapic_nmi_sysfs+0x0/0x33()
Calling initcall 0xc0613e4f: check_nmi_watchdog+0x0/0x1a8()
Testing NMI watchdog ... CPU#0: NMI appears to be stuck (0->0)!
CPU#1: NMI appears to be stuck (0->0)!
initcall 0xc0613e4f: check_nmi_watchdog+0x0/0x1a8() returned -1.
initcall 0xc0613e4f ran for 27 msecs: check_nmi_watchdog+0x0/0x1a8()
initcall at 0xc0613e4f: check_nmi_watchdog+0x0/0x1a8(): returned with error code -1
Calling initcall 0xc06142b2: io_apic_bug_finalize+0x0/0x1a()
initcall 0xc06142b2: io_apic_bug_finalize+0x0/0x1a() returned 0.
initcall 0xc06142b2 ran for 0 msecs: io_apic_bug_finalize+0x0/0x1a()
Calling initcall 0xc0616b8f: print_ipi_mode+0x0/0x2d()
Using IPI Shortcut mode
initcall 0xc0616b8f: print_ipi_mode+0x0/0x2d() returned 0.
initcall 0xc0616b8f ran for 2 msecs: print_ipi_mode+0x0/0x2d()
Calling initcall 0xc061bbc1: revokefs_init+0x0/0x85()
initcall 0xc061bbc1: revokefs_init+0x0/0x85() returned 0.
initcall 0xc061bbc1 ran for 0 msecs: revokefs_init+0x0/0x85()
Calling initcall 0xc061d547: random32_reseed+0x0/0x4f()
initcall 0xc061d547: random32_reseed+0x0/0x4f() returned 0.
initcall 0xc061d547 ran for 0 msecs: random32_reseed+0x0/0x4f()
Calling initcall 0xc061db19: pci_sysfs_init+0x0/0x35()
initcall 0xc061db19: pci_sysfs_init+0x0/0x35() returned 0.
initcall 0xc061db19 ran for 0 msecs: pci_sysfs_init+0x0/0x35()
Calling initcall 0xc023c4ad: acpi_poweroff_init+0x0/0x4f()
initcall 0xc023c4ad: acpi_poweroff_init+0x0/0x4f() returned 0.
initcall 0xc023c4ad ran for 0 msecs: acpi_poweroff_init+0x0/0x4f()
Calling initcall 0xc0620ebc: seqgen_init+0x0/0xe()
initcall 0xc0620ebc: seqgen_init+0x0/0xe() returned 0.
initcall 0xc0620ebc ran for 0 msecs: seqgen_init+0x0/0xe()
Calling initcall 0xc0622600: early_uart_console_switch+0x0/0x7d()
initcall 0xc0622600: early_uart_console_switch+0x0/0x7d() returned 0.
initcall 0xc0622600 ran for 0 msecs: early_uart_console_switch+0x0/0x7d()
Calling initcall 0xc02c2847: scsi_complete_async_scans+0x0/0xe2()
initcall 0xc02c2847: scsi_complete_async_scans+0x0/0xe2() returned 0.
initcall 0xc02c2847 ran for 0 msecs: scsi_complete_async_scans+0x0/0xe2()
Calling initcall 0xc0628d39: pci_mmcfg_late_insert_resources+0x0/0x44()
initcall 0xc0628d39: pci_mmcfg_late_insert_resources+0x0/0x44() returned 0.
initcall 0xc0628d39 ran for 0 msecs: pci_mmcfg_late_insert_resources+0x0/0x44()
Calling initcall 0xc062abd1: tcp_congestion_default+0x0/0xf()
initcall 0xc062abd1: tcp_congestion_default+0x0/0xf() returned 0.
initcall 0xc062abd1 ran for 0 msecs: tcp_congestion_default+0x0/0xf()
