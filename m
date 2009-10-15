Return-Path: <linux-kernel-owner+w=401wt.eu-S1762992AbZJOTdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762992AbZJOTdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762970AbZJOTdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:33:19 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:7671 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760768AbZJOTdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:33:09 -0400
X-Spam-Flag: NO
X-Spam-Score: -11.174
Message-ID: <4AD778C7.4070707@tremplin-utc.net>
Date: Thu, 15 Oct 2009 21:32:23 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work	anymore
References: <928C125D-D36B-47C9-A549-3EE502C9EC73@gmail.com> <4AD75AC0.6020705@tremplin-utc.net> <20091015181336.GB8544@core.coreip.homeip.net>
In-Reply-To: <20091015181336.GB8544@core.coreip.homeip.net>
Content-Type: multipart/mixed;
 boundary="------------070807070609020203040707"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070807070609020203040707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Op 15-10-09 20:13, Dmitry Torokhov schreef:
> It lokks like the keyboard controller switched from translated to
> non-translated mode: '1c' is make code and 'f0 1c' is break (aka
> release) code.
>
> Could you tell me how the keyboard indentified (in dmesg) after fresh
> boot and after you do the bind/unbind trick on the older kernel?
>
What do you mean by "how the keyboard indentified"? Are you asking for 
the debug trace in dmesg? I have the beginning of a boot with the debug 
trace to see after a fresh boot. I don't have dmesg history with 
i8042.debug of the bind/unbind trick, so I'll reboot in an old kernel 
and do it again (but I cannot do this before tuesday, when i have 
physical access to the machine).

> sftp://piel@localhost:2226/home/piel/busy/i8042-begin-boot-keyboard.dmesg

> BTW, do you have i8042.reset parameyer on your command line? What
> happens if you remove it?
The two logs where done with i8042.reset. However, without this 
parameter, the behaviour is identical: the keyboard needs the 
unbind/bind trick after the first resume.

Eric

--------------070807070609020203040707
Content-Type: text/plain;
 name="i8042-begin-boot-keyboard.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="i8042-begin-boot-keyboard.dmesg"

Linux version 2.6.32-rc3-git-eric-00343-g35578ca (piel@dutifh) (gcc version 4.4.1 (GCC) ) #17 SMP PREEMPT Mon Oct 12 18:54:14 CEST 2009
Command line: BOOT_IMAGE=2632-rc3-git-eric-00343-g35578c root=UUID=01dc5fcc-55d3-4bae-932b-1119dbe7ff0b resume=UUID=0d777318-dc2d-4ec3-aa25-fbad7e0fa039 splash=silent i8042.debug i8042.reset vga=791
KERNEL supported cpus:
  Intel GenuineIntel
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f7b0000 (usable)
 BIOS-e820: 000000007f7b0000 - 000000007f7c5400 (reserved)
 BIOS-e820: 000000007f7c5400 - 000000007f7e7fb8 (ACPI NVS)
 BIOS-e820: 000000007f7e7fb8 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0x7f7b0 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-D3FFF write-protect
  D4000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 07F800000 mask FFF800000 uncachable
  2 base 0FEDA0000 mask FFFFE0000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2040MB, range: 8MB, type UC
reg 2, base: 4175488KB, range: 128KB, type UC
total RAM coverred: 2040M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 16M 	num_reg: 2  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2040MB, range: 8MB, type UC
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-000000007f7b0000
 0000000000 - 007f600000 page 2M
 007f600000 - 007f7b0000 page 4k
kernel direct mapping tables up to 7f7b0000 @ 8000-c000
RAMDISK: 37666000 - 37fefab0
ACPI: RSDP 00000000000f7980 00024 (v02 HP    )
ACPI: XSDT 000000007f7c81c4 00074 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: FACP 000000007f7c8084 000F4 (v04 HP     30C9     00000003 HP   00000001)
ACPI: DSDT 000000007f7c84c0 13484 (v01 HP       nc2500 00010000 MSFT 03000001)
ACPI: FACS 000000007f7e7d80 00040
ACPI: SLIC 000000007f7c8238 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: HPET 000000007f7c83b0 00038 (v01 HP     30C9     00000001 HP   00000001)
ACPI: APIC 000000007f7c83e8 00068 (v01 HP     30C9     00000001 HP   00000001)
ACPI: MCFG 000000007f7c8450 0003C (v01 HP     30C9     00000001 HP   00000001)
ACPI: TCPA 000000007f7c848c 00032 (v02 HP     30C9     00000001 HP   00000001)
ACPI: SSDT 000000007f7db944 002BE (v01 HP       HPQPAT 00000001 MSFT 03000001)
ACPI: SSDT 000000007f7dc586 0025F (v01 HP      Cpu0Tst 00003000 INTL 20060317)
ACPI: SSDT 000000007f7dc7e5 000A6 (v01 HP      Cpu1Tst 00003000 INTL 20060317)
ACPI: SSDT 000000007f7dc88b 004D7 (v01 HP        CpuPm 00003000 INTL 20060317)
ACPI: Local APIC address 0xfee00000
(7 early reservations) ==> bootmem [0000000000 - 007f7b0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 00019daa64]    TEXT DATA BSS ==> [0001000000 - 00019daa64]
  #3 [0037666000 - 0037fefab0]          RAMDISK ==> [0037666000 - 0037fefab0]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [00019db000 - 00019db18c]              BRK ==> [00019db000 - 00019db18c]
  #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0007f7b0
On node 0 totalpages: 522063
  DMA zone: 56 pages used for memmap
  DMA zone: 101 pages reserved
  DMA zone: 3842 pages, LIFO batch:0
  DMA32 zone: 7083 pages used for memmap
  DMA32 zone: 510981 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 80000000:7ec00000)
Booting paravirtualized kernel on bare hardware
NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 28 pages/cpu @ffff880001a00000 s85400 r8192 d21096 u1048576
pcpu-alloc: s85400 r8192 d21096 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 514823
Kernel command line: BOOT_IMAGE=2632-rc3-git-eric-00343-g35578c root=UUID=01dc5fcc-55d3-4bae-932b-1119dbe7ff0b resume=UUID=0d777318-dc2d-4ec3-aa25-fbad7e0fa039 splash=silent i8042.debug i8042.reset vga=791
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Initializing CPU#0
Memory: 2035536k/2088640k available (4036k kernel code, 388k absent, 51984k reserved, 4576k data, 552k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Experimental preemptable hierarchical RCU implementation.
NR_IRQS:33024 nr_irqs:424
Extended CMOS year: 2000
Console: colour dummy device 80x25
console [tty0] enabled
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Fast TSC calibration using PIT
Detected 1196.971 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 2393.94 BogoMIPS (lpj=1196971)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
Performance Events: Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
ACPI: Core revision 20090903
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     U7600  @ 1.20GHz stepping 0d
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 2393.89 BogoMIPS (lpj=1196949)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 6 MCE banks
CPU1: Thermal monitoring enabled (TM2)
CPU1: Intel(R) Core(TM)2 Duo CPU     U7600  @ 1.20GHz stepping 0d
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (4787.84 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: MCFG area at f8000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at f8000000 - fbffffff
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
ACPI: Power Resource [C29F] (on)
ACPI: Power Resource [C1C7] (off)
ACPI: Power Resource [C3AD] (off)
ACPI: Power Resource [C3B0] (off)
ACPI: Power Resource [C3C3] (off)
ACPI: Power Resource [C3C4] (off)
ACPI: Power Resource [C3C5] (off)
ACPI: Power Resource [C3C6] (off)
ACPI: Power Resource [C3C7] (off)
ACPI: No dock devices found.
ACPI: PCI Root Bridge [C003] (0000:00)
pci 0000:00:02.0: reg 10 64bit mmio: [0xe0400000-0xe04fffff]
pci 0000:00:02.0: reg 18 64bit mmio pref: [0xd0000000-0xdfffffff]
pci 0000:00:02.0: reg 20 io port: [0x2000-0x2007]
pci 0000:00:02.1: reg 10 64bit mmio: [0xe0500000-0xe05fffff]
pci 0000:00:19.0: reg 10 32bit mmio: [0xe0600000-0xe061ffff]
pci 0000:00:19.0: reg 14 32bit mmio: [0xe0620000-0xe0620fff]
pci 0000:00:19.0: reg 18 io port: [0x2020-0x203f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 20 io port: [0x2040-0x205f]
pci 0000:00:1a.1: reg 20 io port: [0x2060-0x207f]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xe0621000-0xe06213ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xe0624000-0xe0627fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x2080-0x209f]
pci 0000:00:1d.1: reg 20 io port: [0x20a0-0x20bf]
pci 0000:00:1d.2: reg 20 io port: [0x20c0-0x20df]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xe0628000-0xe06283ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0500 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 02e8 (mask 0007)
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x20e0-0x20ef]
pci 0000:10:00.0: reg 10 64bit mmio: [0xe0000000-0xe0003fff]
pci 0000:10:00.0: supports D1 D2
pci 0000:00:1c.1: bridge 32bit mmio: [0xe0000000-0xe00fffff]
pci 0000:02:06.0: reg 10 32bit mmio: [0xe0100000-0xe0100fff]
pci 0000:02:06.0: supports D1 D2
pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.0: PME# disabled
pci 0000:02:06.1: reg 10 32bit mmio: [0xe0101000-0xe01017ff]
pci 0000:02:06.1: supports D1 D2
pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.1: PME# disabled
pci 0000:02:06.2: reg 10 32bit mmio: [0xe0102000-0xe01020ff]
pci 0000:02:06.2: supports D1 D2
pci 0000:02:06.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.2: PME# disabled
pci 0000:02:06.3: reg 10 32bit mmio: [0xe0103000-0xe01030ff]
pci 0000:02:06.3: supports D1 D2
pci 0000:02:06.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.3: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge 32bit mmio: [0xe0100000-0xe03fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11F._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C133._PRT]
ACPI: PCI Interrupt Link [C12F] (IRQs *10 11)
ACPI: PCI Interrupt Link [C130] (IRQs *10 11)
ACPI: PCI Interrupt Link [C131] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C132] (IRQs 10 11) *5
ACPI: PCI Interrupt Link [C142] (IRQs *10 11)
ACPI: PCI Interrupt Link [C143] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C144] (IRQs 10 *11)
ACPI Exception: AE_NOT_FOUND, Evaluating _PRS (20090903/pci_link-184)
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
  alloc irq_desc for 23 on node -1
  alloc kstat_irqs on node -1
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x7f7fffff could not be reserved
system 00:0a: ioport range 0x500-0x55f has been reserved
system 00:0a: ioport range 0x800-0x80f has been reserved
system 00:0a: iomem range 0xffb00000-0xffbfffff has been reserved
system 00:0a: iomem range 0xfff00000-0xffffffff has been reserved
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0c: ioport range 0x2f8-0x2ff has been reserved
system 00:0c: ioport range 0x3f8-0x3ff has been reserved
system 00:0c: ioport range 0x1000-0x107f has been reserved
system 00:0c: ioport range 0x1100-0x113f has been reserved
system 00:0c: ioport range 0x1200-0x121f has been reserved
system 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved
system 00:0c: iomem range 0xfec00000-0xfec000ff could not be reserved
system 00:0c: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:0c: iomem range 0xfed45000-0xfed8ffff has been reserved
system 00:0c: iomem range 0xfed90000-0xfed99fff has been reserved
system 00:0d: iomem range 0xcee00-0xcffff has been reserved
system 00:0d: iomem range 0xd2000-0xd3fff has been reserved
system 00:0d: iomem range 0xfeda0000-0xfedbffff has been reserved
system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:08
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:10
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: 0xe0000000-0xe00fffff
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:02:06.0: CardBus bridge, secondary bus 0000:03
pci 0000:02:06.0:   IO window: 0x003000-0x0030ff
pci 0000:02:06.0:   IO window: 0x003400-0x0034ff
pci 0000:02:06.0:   PREFETCH window: 0x80000000-0x83ffffff
pci 0000:02:06.0:   MEM window: 0x84000000-0x87ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
pci 0000:00:1e.0:   MEM window: 0xe0100000-0xe03fffff
pci 0000:00:1e.0:   PREFETCH window: 0x80000000-0x83ffffff
  alloc irq_desc for 16 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 17 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
  alloc irq_desc for 18 on node -1
  alloc kstat_irqs on node -1
pci 0000:02:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:10: resource 1 mem: [0xe0000000-0xe00fffff]
pci_bus 0000:02: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:02: resource 1 mem: [0xe0100000-0xe03fffff]
pci_bus 0000:02: resource 2 pref mem [0x80000000-0x83ffffff]
pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:03: resource 0 io:  [0x3000-0x30ff]
pci_bus 0000:03: resource 1 io:  [0x3400-0x34ff]
pci_bus 0000:03: resource 2 pref mem [0x80000000-0x83ffffff]
pci_bus 0000:03: resource 3 mem: [0x84000000-0x87ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 9766k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1255634791.705:1): initialized
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 3996
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
  alloc irq_desc for 24 on node -1
  alloc kstat_irqs on node -1
pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
pcieport-driver 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 25 on node -1
  alloc kstat_irqs on node -1
pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
pcieport-driver 0000:00:1c.1: setting latency timer to 64
vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90004100000, using 3072k, total 7616k
vesafb: mode is 1024x768x16, linelength=2048, pages=3
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 965GM Chipset
agpgart-intel 0000:00:00.0: detected 7676K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: quirky BIOS, skipping spindown on poweroff and hibernation
ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x20e0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x20e8 irq 15
ata2: port disabled. ignoring.
PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,12
drivers/input/serio/i8042.c: aa -> i8042 (command) [1]
drivers/input/serio/i8042.c: 55 <- i8042 (return) [1]
drivers/input/serio/i8042.c: 20 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 30 <- i8042 (return) [1]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 30 -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: d3 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: 5a <- i8042 (return) [1]
drivers/input/serio/i8042.c: a7 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 20 -> i8042 (command) [2]
drivers/input/serio/i8042.c: 30 <- i8042 (return) [2]
drivers/input/serio/i8042.c: a8 -> i8042 (command) [2]
drivers/input/serio/i8042.c: 20 -> i8042 (command) [2]
drivers/input/serio/i8042.c: 10 <- i8042 (return) [2]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [2]
drivers/input/serio/i8042.c: 30 -> i8042 (parameter) [2]
drivers/input/serio/i8042.c: d3 -> i8042 (command) [2]
drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [2]
drivers/input/serio/i8042.c: f0 <- i8042 (return) [2]
drivers/input/serio/i8042.c: d3 -> i8042 (command) [2]
drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [2]
drivers/input/serio/i8042.c: 56 <- i8042 (return) [2]
drivers/input/serio/i8042.c: d3 -> i8042 (command) [2]
drivers/input/serio/i8042.c: a4 -> i8042 (parameter) [2]
drivers/input/serio/i8042.c: 11 <- i8042 (return) [3]
i8042.c: Detected active multiplexing controller, rev 1.1.
drivers/input/serio/i8042.c: 60 -> i8042 (command) [3]
drivers/input/serio/i8042.c: 30 -> i8042 (parameter) [3]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [3]
drivers/input/serio/i8042.c: a8 -> i8042 (command) [3]
drivers/input/serio/i8042.c: 91 -> i8042 (command) [3]
drivers/input/serio/i8042.c: a8 -> i8042 (command) [3]
drivers/input/serio/i8042.c: 92 -> i8042 (command) [3]
drivers/input/serio/i8042.c: a8 -> i8042 (command) [3]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [3]
drivers/input/serio/i8042.c: a8 -> i8042 (command) [3]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [3]
drivers/input/serio/i8042.c: 12 -> i8042 (parameter) [3]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [3]
drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [4]
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
Driver 'rtc_cmos' needs updating - please use bus_type methods
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
ata1.00: ATA-7: TOSHIBA MK8009GAH, BS021C, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA 
ata1.01: ATAPI: HL-DT-ST DVDRAM GSA-U10N, HP06, max MWDMA2
ata1.00: configured for UDMA/100
ata1.01: configured for MWDMA2
scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK8009GA BS02 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
scsi 0:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-U10N  HP06 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 >
sd 0:0:0:0: [sda] Attached SCSI disk
registered taskstats version 1
rtc_cmos 00:06: setting system clock to 2009-10-15 19:26:32 UTC (1255634792)
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Freeing unused kernel memory: 552k freed
Write protecting the kernel read-only data: 5604k
input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
ACPI: Sleep Button [C2BF]
input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [C155]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
  alloc irq_desc for 26 on node -1
  alloc kstat_irqs on node -1
i915 0000:00:02.0: irq 26 for MSI/MSI-X
[drm] set up 7M of stolen space
[drm] TV-14: set mode NTSC 480i 0
fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
Console: switching to colour dummy device 80x25
Console: switching to colour frame buffer device 160x50
[drm] DAC-6: set mode 1920x1200 2a
[drm] LVDS-8: set mode 1280x800 2b
fb0: inteldrmfb frame buffer device
registered panic notifier
acpi device:00: registered as cooling_device0
input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
ACPI: Video Device [C09A] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [2206]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [2206]
drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [2209]
drivers/input/serio/i8042.c: 83 <- i8042 (interrupt, 0, 1) [2212]
drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [2212]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [2215]
input: AT Raw Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
drivers/input/serio/i8042.c: 90 -> i8042 (command) [2215]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [2215]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [2218]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 2, 12) [2219]
drivers/input/serio/i8042.c: 91 -> i8042 (command) [2219]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [2219]
drivers/input/serio/i8042.c: MUX error, status is 75, data is fe [2219]
drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 3, 12, timeout) [2219]
drivers/input/serio/i8042.c: 91 -> i8042 (command) [2219]
drivers/input/serio/i8042.c: ed -> i8042 (parameter) [2219]
drivers/input/serio/i8042.c: MUX error, status is 75, data is fe [2220]
drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 3, 12, timeout) [2220]
drivers/input/serio/i8042.c: 92 -> i8042 (command) [2220]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [2220]
drivers/input/serio/i8042.c: MUX error, status is b5, data is fe [2221]
drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 4, 12, timeout) [2221]
drivers/input/serio/i8042.c: 92 -> i8042 (command) [2221]
drivers/input/serio/i8042.c: ed -> i8042 (parameter) [2221]
drivers/input/serio/i8042.c: MUX error, status is b5, data is fe [2222]
drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 4, 12, timeout) [2222]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [2222]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [2222]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [2225]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 5, 12) [2226]
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0621000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
  alloc irq_desc for 20 on node -1
  alloc kstat_irqs on node -1
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe0628000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
b43-pci-bridge 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
b43-pci-bridge 0000:10:00.0: setting latency timer to 64
ssb: Sonics Silicon Backplane found on PCI device 0000:10:00.0
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00002040
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 17, io base 0x00002060
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00002080
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
  alloc irq_desc for 22 on node -1
  alloc kstat_irqs on node -1
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 22, io base 0x000020a0
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x000020c0
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
usb 2-6: new high speed USB device using ehci_hcd and address 3
usb 2-6: configuration #1 chosen from 1 choice
hub 2-6:1.0: USB hub found
hub 2-6:1.0: 2 ports detected
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
usb 5-2: new full speed USB device using uhci_hcd and address 2
usb 5-2: configuration #1 chosen from 1 choice
usb 2-6.1: new high speed USB device using ehci_hcd and address 4
usb 2-6.1: configuration #1 chosen from 1 choice
hub 2-6.1:1.0: USB hub found
hub 2-6.1:1.0: 4 ports detected
usb 2-6.2: new low speed USB device using ehci_hcd and address 5
usb 2-6.2: configuration #1 chosen from 1 choice
input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1d.7/usb2/2-6/2-6.2/2-6.2:1.0/input/input5
generic-usb 0003:413C:2003.0001: input,hidraw0: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.7-6.2/input0
usb 2-6.1.1: new high speed USB device using ehci_hcd and address 6
usb 2-6.1.1: configuration #1 chosen from 1 choice
usb 2-6.1.2: new low speed USB device using ehci_hcd and address 7
usb 2-6.1.2: configuration #1 chosen from 1 choice
input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-6/2-6.1/2-6.1.2/2-6.1.2:1.0/input/input6
generic-usb 0003:046D:C018.0002: input,hidraw1: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1d.7-6.1.2/input0
usb 2-6: USB disconnect, address 3
usb 2-6.1: USB disconnect, address 4
usb 2-6.1.1: USB disconnect, address 6
usb 2-6.1.2: USB disconnect, address 7
usb 2-6.2: USB disconnect, address 5
udev: starting version 146
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 0:0:1:0: Attached scsi generic sg1 type 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:1:0: Attached scsi CD-ROM sr0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
ACPI: AC Adapter [C23B] (on-line)
ACPI: Battery Slot [C23D] (battery present)
lis3lv02d: hardware type NC2510 found.
lis3lv02d: 12 bits sensor found
input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input7
Registered led device: hp::hddprotect
lis3lv02d driver loaded.
cfg80211: Calling CRDA to update world regulatory domain
input: PC Speaker as /devices/platform/pcspkr/input/input8
ACPI: WMI: Mapper loaded
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ6] (25 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Thermal Zone [TZ0] (68 C)
thermal LNXTHERM:03: registered as thermal_zone2
ACPI: Thermal Zone [TZ1] (69 C)
thermal LNXTHERM:04: registered as thermal_zone3
ACPI: Thermal Zone [TZ3] (54 C)
thermal LNXTHERM:05: registered as thermal_zone4
ACPI: Thermal Zone [TZ4] (29 C)
thermal LNXTHERM:06: registered as thermal_zone5
ACPI: Thermal Zone [TZ5] (30 C)
  alloc irq_desc for 19 on node -1
  alloc kstat_irqs on node -1
ohci1394 0000:02:06.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
cfg80211: World regulatory domain updated:
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0101000-e01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
ACPI: SSDT 000000007f7dbcca 0023D (v01 HP      Cpu0Ist 00003000 INTL 20060317)
ACPI: SSDT 000000007f7dbf8c 005FA (v01 HP      Cpu0Cst 00003001 INTL 20060317)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Marking TSC unstable due to TSC halts in idle
Switching to clocksource hpet
processor LNXCPU:00: registered as cooling_device1
ACPI: SSDT 000000007f7dbc02 000C8 (v01 HP      Cpu1Ist 00003000 INTL 20060317)
ACPI: SSDT 000000007f7dbf07 00085 (v01 HP      Cpu1Cst 00003000 INTL 20060317)
processor LNXCPU:01: registered as cooling_device2
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
ricoh-mmc: Ricoh MMC Controller disabling driver
ricoh-mmc: Copyright(c) Philip Langdale
ricoh-mmc: Ricoh MMC controller found at 0000:02:06.3 [1180:0843] (rev 11)
ricoh-mmc: Controller is now disabled.
yenta_cardbus 0000:02:06.0: CardBus bridge found [103c:30c9]
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
e1000e 0000:00:19.0: setting latency timer to 64
  alloc irq_desc for 27 on node -1
  alloc kstat_irqs on node -1
e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34491]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [34491]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34494]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 2, 12) [34495]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34495]
drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [34495]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34498]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34498]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [34498]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34500]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34500]
drivers/input/serio/i8042.c: 0a -> i8042 (parameter) [34500]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34503]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34503]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [34503]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34506]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34506]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [34506]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34509]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34509]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [34509]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34511]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34511]
drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [34512]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34514]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34514]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [34514]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34517]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34517]
drivers/input/serio/i8042.c: 3c -> i8042 (parameter) [34517]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34520]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34520]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [34520]
tpm_inf_pnp 00:02: Found C284 with ID IFX0102
tpm_inf_pnp 00:02: TPM found: config base 0x560, data base 0x570, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34526]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34526]
drivers/input/serio/i8042.c: 28 -> i8042 (parameter) [34526]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34529]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34529]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [34529]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34531]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34531]
drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [34532]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34534]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34534]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [34534]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34537]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34537]
drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [34537]
yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x0cb8, PCI irq 18
yenta_cardbus 0000:02:06.0: Socket status: 30000006
pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #03 to #06
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe03fffff
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0x80000000 - 0x83ffffff
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34540]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34540]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [34540]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34543]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34543]
drivers/input/serio/i8042.c: 3c -> i8042 (parameter) [34543]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34546]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34546]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [34546]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34548]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34548]
drivers/input/serio/i8042.c: 28 -> i8042 (parameter) [34549]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34551]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34551]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [34551]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34554]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34554]
drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [34554]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34557]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34557]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [34557]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34560]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34560]
drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [34560]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34562]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34569]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [34569]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34571]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 2, 12) [34572]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34572]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [34572]
b43-phy0: Broadcom 4311 WLAN found (core revision 13)
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34575]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34575]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [34575]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34578]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34578]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [34578]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34581]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34581]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [34581]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34584]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34584]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [34584]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34587]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34587]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [34587]
b43-phy0 debug: Found PHY: Analog 4, Type 2, Revision 9
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34590]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34590]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [34590]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34592]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34592]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [34592]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34595]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34595]
drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [34595]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34598]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 2, 12) [34599]
drivers/input/serio/i8042.c: 46 <- i8042 (interrupt, 2, 12) [34601]
drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 2, 12) [34603]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34603]
drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [34603]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34606]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34606]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [34606]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34609]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34609]
drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [34609]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34612]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34612]
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [34612]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34614]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34615]
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [34615]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34617]
fan PNP0C0B:00: registered as cooling_device3
ACPI: Fan [C3B1] (off)
fan PNP0C0B:01: registered as cooling_device4
ACPI: Fan [C3B2] (off)
fan PNP0C0B:02: registered as cooling_device5
ACPI: Fan [C3C8] (off)
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34619]
fan PNP0C0B:03: registered as cooling_device6
ACPI: Fan [C3C9] (off)
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [34619]
fan PNP0C0B:04: registered as cooling_device7
ACPI: Fan [C3CA] (off)
fan PNP0C0B:05: registered as cooling_device8
ACPI: Fan [C3CB] (off)
fan PNP0C0B:06: registered as cooling_device9
ACPI: Fan [C3CC] (off)
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34622]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34622]
drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [34622]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34625]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 2, 12) [34625]
drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 2, 12) [34627]
drivers/input/serio/i8042.c: 64 <- i8042 (interrupt, 2, 12) [34630]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34630]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [34630]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34633]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34633]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [34633]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34635]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34635]
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [34635]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34638]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34638]
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [34638]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34641]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34641]
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [34641]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34644]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34644]
drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [34644]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34647]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 2, 12) [34648]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 2, 12) [34649]
drivers/input/serio/i8042.c: 64 <- i8042 (interrupt, 2, 12) [34652]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34652]
drivers/input/serio/i8042.c: e1 -> i8042 (parameter) [34652]
drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 2, 12) [34655]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34655]
drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [34655]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34657]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34657]
drivers/input/serio/i8042.c: ff -> i8042 (parameter) [34657]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34660]
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1b:24:ae:b7:02
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: ffffff-0ff
udev: renamed network interface eth0 to eth1
phy0: Selected rate control algorithm 'pid'
Registered led device: b43-phy0::tx
Registered led device: b43-phy0::rx
Registered led device: b43-phy0::radio
Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 2, 12) [34991]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 2, 12) [34993]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34993]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [34993]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34996]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34996]
drivers/input/serio/i8042.c: c8 -> i8042 (parameter) [34996]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [34999]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [34999]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [34999]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35002]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35002]
drivers/input/serio/i8042.c: 64 -> i8042 (parameter) [35002]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35005]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35005]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35005]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35008]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35008]
drivers/input/serio/i8042.c: 50 -> i8042 (parameter) [35008]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35010]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35010]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [35010]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35013]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 2, 12) [35015]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35015]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35015]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35017]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35017]
drivers/input/serio/i8042.c: c8 -> i8042 (parameter) [35017]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35020]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35020]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35020]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35023]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35023]
drivers/input/serio/i8042.c: c8 -> i8042 (parameter) [35023]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35026]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35026]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35026]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35029]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35029]
drivers/input/serio/i8042.c: 50 -> i8042 (parameter) [35029]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35031]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35031]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [35031]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35034]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 2, 12) [35035]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35035]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35035]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35038]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35038]
drivers/input/serio/i8042.c: c8 -> i8042 (parameter) [35038]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35041]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35041]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35041]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35044]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35044]
drivers/input/serio/i8042.c: 64 -> i8042 (parameter) [35044]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35047]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35047]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35047]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35050]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35050]
drivers/input/serio/i8042.c: 50 -> i8042 (parameter) [35050]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35053]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35053]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [35053]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35055]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 2, 12) [35057]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35057]
drivers/input/serio/i8042.c: ff -> i8042 (parameter) [35057]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35060]
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001b249929bd0f10]
drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 2, 12) [35393]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 2, 12) [35395]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35395]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35395]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35398]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35398]
drivers/input/serio/i8042.c: 64 -> i8042 (parameter) [35398]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35400]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35400]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35400]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35403]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35403]
drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [35403]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35406]
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35406]
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [35406]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35409]
input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input9
drivers/input/serio/i8042.c: 90 -> i8042 (command) [35409]
drivers/input/serio/i8042.c: f4 -> i8042 (parameter) [35409]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 2, 12) [35411]
drivers/input/serio/i8042.c: 91 -> i8042 (command) [35412]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [35412]
drivers/input/serio/i8042.c: MUX error, status is 75, data is fe [35412]
drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 3, 12, timeout) [35412]
drivers/input/serio/i8042.c: 92 -> i8042 (command) [35412]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [35412]
drivers/input/serio/i8042.c: MUX error, status is b5, data is fe [35413]
drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 4, 12, timeout) [35413]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35413]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [35413]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35416]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 5, 12) [35417]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35418]
drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [35418]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35420]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35421]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35421]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35423]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35423]
drivers/input/serio/i8042.c: 0a -> i8042 (parameter) [35423]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35427]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35427]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35427]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35430]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35430]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35430]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35433]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35433]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35433]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35435]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35435]
drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [35435]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35439]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35439]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35439]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35442]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35442]
drivers/input/serio/i8042.c: 3c -> i8042 (parameter) [35442]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35445]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35445]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35445]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35448]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35448]
drivers/input/serio/i8042.c: 28 -> i8042 (parameter) [35448]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35450]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35451]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35451]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35453]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35453]
drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [35453]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35456]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35456]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35456]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35459]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35459]
drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [35459]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35462]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35462]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35462]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35465]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35465]
drivers/input/serio/i8042.c: 3c -> i8042 (parameter) [35465]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35468]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35468]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35468]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35471]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35471]
drivers/input/serio/i8042.c: 28 -> i8042 (parameter) [35471]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35474]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35474]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35474]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35478]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35478]
drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [35478]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35480]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35481]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [35481]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35483]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35483]
drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [35483]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35486]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35486]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [35486]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35489]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 5, 12) [35491]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35491]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35491]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35494]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35494]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35494]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35497]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35497]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35497]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35500]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35500]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35500]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35503]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35503]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35503]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35506]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35507]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35507]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35510]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35510]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35510]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35513]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35513]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35513]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35516]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35516]
drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [35516]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35519]
drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 5, 12) [35520]
drivers/input/serio/i8042.c: 47 <- i8042 (interrupt, 5, 12) [35523]
drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 5, 12) [35526]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35526]
drivers/input/serio/i8042.c: ff -> i8042 (parameter) [35526]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35532]
sdhci-pci 0000:02:06.2: SDHCI controller found [1180:0822] (rev 21)
sdhci-pci 0000:02:06.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
Registered led device: mmc0::
mmc0: SDHCI controller on PCI [0000:02:06.2] using PIO
HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input10
drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 5, 12) [35894]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 5, 12) [35897]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35897]
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [35897]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35900]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35900]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35900]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35903]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35903]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35903]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35906]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35906]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35906]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35909]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35909]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35909]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35912]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35912]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35912]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35915]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35915]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35915]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35918]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35918]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35918]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35921]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35921]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35921]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35924]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35924]
drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [35924]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35927]
drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 5, 12) [35928]
drivers/input/serio/i8042.c: 47 <- i8042 (interrupt, 5, 12) [35930]
drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 5, 12) [35933]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35933]
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [35933]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35936]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35936]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35936]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35939]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35939]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35939]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35942]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35942]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35942]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35945]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35945]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35945]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35948]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35948]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35948]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35951]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35951]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35951]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35954]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35954]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35954]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35957]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35957]
drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [35957]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35960]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35960]
drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [35960]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35963]
drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 5, 12) [35964]
drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 5, 12) [35967]
drivers/input/serio/i8042.c: b1 <- i8042 (interrupt, 5, 12) [35970]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35970]
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [35970]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35973]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35973]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35973]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35976]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35976]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35976]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35979]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35979]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35979]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35982]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35982]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35982]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35985]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35985]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35985]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35988]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35988]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [35988]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35991]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35991]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [35991]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35994]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35994]
drivers/input/serio/i8042.c: 02 -> i8042 (parameter) [35994]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [35997]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [35997]
drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [35997]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36000]
drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 5, 12) [36001]
drivers/input/serio/i8042.c: 47 <- i8042 (interrupt, 5, 12) [36004]
drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 5, 12) [36007]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36007]
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [36007]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36010]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36010]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36010]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36013]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36013]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [36013]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36016]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36016]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36016]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36019]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36019]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [36019]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36022]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36022]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36022]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36025]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36025]
drivers/input/serio/i8042.c: 02 -> i8042 (parameter) [36025]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36028]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36028]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36028]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36031]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36031]
drivers/input/serio/i8042.c: 01 -> i8042 (parameter) [36031]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36034]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36034]
drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [36034]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36037]
drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 5, 12) [36039]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 5, 12) [36042]
drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 5, 12) [36045]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36045]
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [36045]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36048]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36048]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36048]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36051]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36051]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [36051]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36054]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36054]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36054]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36056]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36056]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [36056]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36059]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36059]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36059]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36062]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36062]
drivers/input/serio/i8042.c: 02 -> i8042 (parameter) [36062]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36065]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36065]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36065]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36068]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36068]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [36068]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36071]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36071]
drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [36071]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36074]
drivers/input/serio/i8042.c: 4a <- i8042 (interrupt, 5, 12) [36076]
drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 5, 12) [36079]
drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 5, 12) [36082]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36082]
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [36082]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36085]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36085]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36085]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36088]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36088]
drivers/input/serio/i8042.c: 02 -> i8042 (parameter) [36088]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36091]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36091]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36091]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36094]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36094]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [36094]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36096]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36096]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36097]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36099]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36099]
drivers/input/serio/i8042.c: 01 -> i8042 (parameter) [36100]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36102]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36102]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36102]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36105]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36105]
drivers/input/serio/i8042.c: 01 -> i8042 (parameter) [36105]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36108]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36108]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [36108]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36111]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36111]
drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [36111]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36114]
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04713/0x200000
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36114]
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [36114]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36117]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36117]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36117]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36120]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36120]
drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [36120]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36123]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36123]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36123]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36126]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36126]
drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [36126]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36129]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36129]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36129]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36132]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36132]
drivers/input/serio/i8042.c: 01 -> i8042 (parameter) [36132]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36135]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36135]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36135]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36138]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36138]
drivers/input/serio/i8042.c: 01 -> i8042 (parameter) [36138]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36141]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36141]
drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [36141]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36144]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36144]
drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [36144]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36147]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36147]
drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [36147]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36150]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36150]
drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [36150]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36153]
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36153]
drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [36153]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36156]
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input11
drivers/input/serio/i8042.c: 93 -> i8042 (command) [36157]
drivers/input/serio/i8042.c: f4 -> i8042 (parameter) [36157]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 5, 12) [36160]
input: HP WMI hotkeys as /devices/virtual/input/input12
Non-volatile memory driver v1.3
EXT3 FS on sda5, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
fuse init (API version 7.13)
loop: module loaded
Adding 2401676k swap on /dev/sda6.  Priority:-1 extents:1 across:2401676k 
microcode: CPU0 sig=0x6fd, pf=0x80, revision=0xa3
platform microcode: firmware: requesting intel-ucode/06-0f-0d
drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [43419]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [43420]
drivers/input/serio/i8042.c: 02 -> i8042 (kbd-data) [43420]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [43423]
microcode: CPU1 sig=0x6fd, pf=0x80, revision=0xa3
platform microcode: firmware: requesting intel-ucode/06-0f-0d
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
cfg80211: Calling CRDA for country: NL
cfg80211: Regulatory domain changed to country: NL
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
	(5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
	(5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
	(5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth1: link is not ready
b43 ssb0:0: firmware: requesting b43/ucode13.fw
b43 ssb0:0: firmware: requesting b43/b0g0initvals13.fw
b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy0 debug: Chip initialized
b43-phy0 debug: 64-bit DMA initialized
b43-phy0 debug: QoS enabled
b43-phy0 debug: Wireless interface started
b43-phy0 debug: Adding Interface type 2
ADDRCONF(NETDEV_UP): wlan0: link is not ready
e1000e: eth1 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
0000:00:19.0: eth1: 10/100 speed: disabling TSO
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
NET: Registered protocol family 17
wlan0: deauthenticating from 00:1b:90:76:d3:f0 by local choice (reason=3)
wlan0: direct probe to AP 00:1b:90:76:d3:f0 (try 1)
wlan0: direct probe responded
wlan0: authenticate with AP 00:1b:90:76:d3:f0 (try 1)
wlan0: authenticated
wlan0: associate with AP 00:1b:90:76:d3:f0 (try 1)
wlan0: RX AssocResp from 00:1b:90:76:d3:f0 (capab=0x431 status=0 aid=142)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
cfg80211: Calling CRDA for country: NL
wlan0: deauthenticating from 00:1b:90:76:d3:f0 by local choice (reason=3)
wlan0: deauthenticating from 00:1b:90:76:d3:f0 by local choice (reason=3)
cfg80211: Current regulatory domain updated by AP to: NL
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
PPP generic driver version 2.4.2
NET: Registered protocol family 24
drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [52092]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [52093]
drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [52093]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [52096]
drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [52267]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [52267]
drivers/input/serio/i8042.c: 02 -> i8042 (kbd-data) [52267]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [52270]
eth1: no IPv6 routers present
wlan0: no IPv6 routers present
CPUFREQ: Per core ondemand sysfs interface is deprecated - ignore_nice_load
drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [827841]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [827842]
drivers/input/serio/i8042.c: 03 -> i8042 (kbd-data) [827842]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [827844]
drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [3600107]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [3600107]
drivers/input/serio/i8042.c: 02 -> i8042 (kbd-data) [3600107]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [3600110]
drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [3660206]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [3660207]
drivers/input/serio/i8042.c: 03 -> i8042 (kbd-data) [3660207]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [3660209]
drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [3900629]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [3900630]
drivers/input/serio/i8042.c: 02 -> i8042 (kbd-data) [3900630]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [3900633]

--------------070807070609020203040707--
