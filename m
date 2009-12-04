Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbZLDTzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbZLDTzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 14:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbZLDTzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 14:55:51 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:54998 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755844AbZLDTzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 14:55:37 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
Date: Fri, 4 Dec 2009 20:55:30 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0912041427550.3070-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912041427550.3070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912042055.32747.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 December 2009 20:34:46 Alan Stern wrote:
> On Fri, 4 Dec 2009, Ondrej Zary wrote:
> > Just found why it was sometimes hard to reproduce a problem. Sometimes
> > the devices are controlled by uhci_hcd and sometimes by ehci_hcd. It
> > seems to be random and can change on every reboot.
>
> It shouldn't change.  The hub you plug into (the D-Link hub) should
> always be controlled by ehci-hcd.  Can you post a dmesg log showing
> what happens on bootup for a case where the hub ends up under uhci-hcd?

dmesg-uhci-hcd:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-rc8-next-20091202 (zary@something) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Thu Dec 3 08:17:52 CET 
2009
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f7a0000 (usable)
[    0.000000]  BIOS-e820: 000000007f7a0000 - 000000007f7ae000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f7ae000 - 000000007f7f0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f7f0000 - 000000007f800000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x7f7a0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 080000000 write-back
[    0.000000]   1 base 07F800000 mask 0FF800000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] init_memory_mapping: 0000000000000000-00000000373fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037000000 page 2M
[    0.000000]  0037000000 - 00373fe000 page 4k
[    0.000000] kernel direct mapping tables up to 373fe000 @ 14000-1a000
[    0.000000] RAMDISK: 3789b000 - 37fefcb7
[    0.000000] Allocated new RAMDISK: 00100000 - 00854cb7
[    0.000000] Move RAMDISK from 000000003789b000 - 0000000037fefcb6 to 00100000 - 00854cb6
[    0.000000] ACPI: RSDP 000fba60 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 7f7a0100 00054 (v01 A_M_I_ OEMXSDT  09000903 MSFT 00000097)
[    0.000000] ACPI: FACP 7f7a0290 000F4 (v03 A_M_I_ OEMFACP  09000903 MSFT 00000097)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0000000000000820/0 (20091112/tbfadt-557)
[    0.000000] ACPI Warning: Invalid length for Pm2ControlBlock: 0, using default 8 (20091112/tbfadt-607)
[    0.000000] ACPI: DSDT 7f7a05b0 05481 (v01  A0990 A0990000 00000000 INTL 20060113)
[    0.000000] ACPI: FACS 7f7ae000 00040
[    0.000000] ACPI: APIC 7f7a0390 0005C (v01 A_M_I_ OEMAPIC  09000903 MSFT 00000097)
[    0.000000] ACPI: MCFG 7f7a03f0 0003C (v01 A_M_I_ OEMMCFG  09000903 MSFT 00000097)
[    0.000000] ACPI: OEMB 7f7ae040 00061 (v01 A_M_I_ AMI_OEM  09000903 MSFT 00000097)
[    0.000000] ACPI: HPET 7f7a5a40 00038 (v01 A_M_I_ OEMHPET  09000903 MSFT 00000097)
[    0.000000] ACPI: SSDT 7f7ae9f0 004F0 (v01  PmRef    CpuPm 00003000 INTL 20060113)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] found SMP MP-table at [c00ff780] ff780
[    0.000000] 1155MB HIGHMEM available.
[    0.000000] 883MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 373fe000
[    0.000000]   low ram: 0 - 373fe000
[    0.000000]   node 0 low ram: 00000000 - 373fe000
[    0.000000]   node 0 bootmap 00016000 - 0001ce80
[    0.000000] (14 early reservations) ==> bootmem [0000000000 - 00373fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 0001499c48]    TEXT DATA BSS ==> [0001000000 - 0001499c48]
[    0.000000]   #4 [000149a000 - 00014a0224]              BRK ==> [000149a000 - 00014a0224]
[    0.000000]   #5 [0000010000 - 0000014000]      ACPI WAKEUP ==> [0000010000 - 0000014000]
[    0.000000]   #6 [0000014000 - 0000016000]          PGTABLE ==> [0000014000 - 0000016000]
[    0.000000]   #7 [0000100000 - 0000854cb7]      NEW RAMDISK ==> [0000100000 - 0000854cb7]
[    0.000000]   #8 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
[    0.000000]   #9 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
[    0.000000]   #10 [000009fc00 - 00000f10e0]    BIOS reserved ==> [000009fc00 - 00000f10e0]
[    0.000000]   #11 [00000f1218 - 00000ff780]    BIOS reserved ==> [00000f1218 - 00000ff780]
[    0.000000]   #12 [00000f10e0 - 00000f1218]     MP-table mpc ==> [00000f10e0 - 00000f1218]
[    0.000000]   #13 [0000016000 - 000001d000]          BOOTMAP ==> [0000016000 - 000001d000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x0007f7a0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f7a0
[    0.000000] On node 0 totalpages: 522031
[    0.000000] free_area_init_node: node 0, pgdat c1387d00, node_mem_map c14a2200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1736 pages used for memmap
[    0.000000]   Normal zone: 220470 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2312 pages used for memmap
[    0.000000]   HighMem zone: 293530 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 7f800000 (gap: 7f800000:7f600000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @c2800000 s32344 r0 d20904 u2097152
[    0.000000] pcpu-alloc: s32344 r0 d20904 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517951
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32-rc8-next-20091202 root=UUID=fbb4bbff-6f44-45a1-9a1c-c707d7895cb4 ro quiet 
fbcon=rotate:3 video=uvesafb:mode_option=1280x1024
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000373fe:0007f7a0)
[    0.000000] Memory: 2057544k/2088576k available (2407k kernel code, 29536k reserved, 1245k data, 364k init, 1183368k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd56000 - 0xfffff000   (2724 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    0.000000]       .init : 0xc1392000 - 0xc13ed000   ( 364 kB)
[    0.000000]       .data : 0xc1259f29 - 0xc1391684   (1245 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1259f29   (2407 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:1280
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1608.123 MHz processor.
[    0.004008] Calibrating delay loop (skipped), value calculated using timer frequency.. 3216.24 BogoMIPS (lpj=6432492)
[    0.004312] Security Framework initialized
[    0.004321] SELinux:  Disabled at boot.
[    0.004422] Mount-cache hash table entries: 512
[    0.008454] Initializing cgroup subsys ns
[    0.008463] Initializing cgroup subsys cpuacct
[    0.008474] Initializing cgroup subsys devices
[    0.008480] Initializing cgroup subsys freezer
[    0.008486] Initializing cgroup subsys net_cls
[    0.008609] CPU: Physical Processor ID: 0
[    0.008613] CPU: Processor Core ID: 0
[    0.008621] mce: CPU supports 5 MCE banks
[    0.008643] CPU0: Thermal monitoring enabled (TM2)
[    0.008650] using mwait in idle threads.
[    0.008663] Performance Events: Atom events, Intel PMU driver.
[    0.008677] ... version:                3
[    0.008681] ... bit width:              40
[    0.008684] ... generic registers:      2
[    0.008688] ... value mask:             000000ffffffffff
[    0.008693] ... max period:             000000007fffffff
[    0.008697] ... fixed-purpose events:   3
[    0.008701] ... event mask:             0000000700000003
[    0.008720] Checking 'hlt' instruction... OK.
[    0.025405] ACPI: Core revision 20091112
[    0.044661] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.087188] CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
[    0.088000] Booting processor 1 APIC 0x1 ip 0x6000
[    0.088000] Initializing CPU#1
[    0.088000] CPU: Physical Processor ID: 0
[    0.088000] CPU: Processor Core ID: 0
[    0.088000] CPU1: Thermal monitoring enabled (TM2)
[    0.176118] CPU1: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
[    0.180078] Brought up 2 CPUs
[    0.180085] Total of 2 processors activated (6432.20 BogoMIPS).
[    0.180691] regulator: core version 0.5
[    0.180691] NET: Registered protocol family 16
[    0.181125] ACPI: bus type pci registered
[    0.181435] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.181443] PCI: not using MMCONFIG
[    0.181754] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=4
[    0.181758] PCI: Using configuration type 1 for base access
[    0.186449] bio: create slab <bio-0> at 0
[    0.189801] ACPI: EC: Look up EC in DSDT
[    0.196588] ACPI: Executed 1 blocks of module-level executable AML code
[    0.214276] ACPI: Interpreter enabled
[    0.214294] ACPI: (supports S0 S1 S3 S4 S5)
[    0.214388] ACPI: Using IOAPIC for interrupt routing
[    0.214536] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.236189] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.236200] PCI: MMCONFIG for 0000 [bus00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000) (size reduced!)
[    0.236206] PCI: Using MMCONFIG for extended config space
[    0.260856] ACPI: No dock devices found.
[    0.261190] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.261316] pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.261900] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.261908] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.261915] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.261921] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.261928] pci_root PNP0A08:00: host bridge window [mem 0x7f800000-0xffffffff] (ignored)
[    0.262057] pci 0000:00:02.0: reg 10: [mem 0xfbd00000-0xfbd7ffff]
[    0.262066] pci 0000:00:02.0: reg 14: [io  0xdc80-0xdc87]
[    0.262075] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
[    0.262084] pci 0000:00:02.0: reg 1c: [mem 0xfbcc0000-0xfbcfffff]
[    0.262150] pci 0000:00:02.1: reg 10: [mem 0xfbd80000-0xfbdfffff]
[    0.262290] pci 0000:00:1b.0: reg 10: [mem 0xfbcb8000-0xfbcbbfff 64bit]
[    0.262361] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.262369] pci 0000:00:1b.0: PME# disabled
[    0.262509] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.262517] pci 0000:00:1c.0: PME# disabled
[    0.262659] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.262667] pci 0000:00:1c.1: PME# disabled
[    0.262799] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.262806] pci 0000:00:1c.2: PME# disabled
[    0.262910] pci 0000:00:1d.0: reg 20: [io  0xd480-0xd49f]
[    0.263001] pci 0000:00:1d.1: reg 20: [io  0xd800-0xd81f]
[    0.263093] pci 0000:00:1d.2: reg 20: [io  0xd880-0xd89f]
[    0.263195] pci 0000:00:1d.3: reg 20: [io  0xdc00-0xdc1f]
[    0.263283] pci 0000:00:1d.7: reg 10: [mem 0xfbcb7c00-0xfbcb7fff]
[    0.263355] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.263364] pci 0000:00:1d.7: PME# disabled
[    0.263590] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.263599] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
[    0.263607] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0380 (mask 0003)
[    0.263615] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 0007)
[    0.263623] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0068 (mask 0003)
[    0.263715] pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
[    0.263726] pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
[    0.263738] pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
[    0.263750] pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
[    0.263761] pci 0000:00:1f.2: reg 20: [io  0xffa0-0xffaf]
[    0.263804] pci 0000:00:1f.2: PME# supported from D3hot
[    0.263811] pci 0000:00:1f.2: PME# disabled
[    0.263898] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.264041] pci 0000:03:00.0: reg 10: [io  0xec00-0xecff]
[    0.264074] pci 0000:03:00.0: reg 18: [mem 0xfbfff000-0xfbffffff 64bit]
[    0.264098] pci 0000:03:00.0: reg 20: [mem 0xfaff0000-0xfaffffff 64bit pref]
[    0.264113] pci 0000:03:00.0: reg 30: [mem 0xfbfc0000-0xfbfdffff pref]
[    0.264175] pci 0000:03:00.0: supports D1 D2
[    0.264180] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.264189] pci 0000:03:00.0: PME# disabled
[    0.264284] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.264293] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[    0.264302] pci 0000:00:1c.0:   bridge window [mem 0xfbf00000-0xfbffffff]
[    0.264315] pci 0000:00:1c.0:   bridge window [mem 0xfaf00000-0xfaffffff 64bit pref]
[    0.264399] pci 0000:02:00.0: reg 10: [mem 0xfbef0000-0xfbefffff]
[    0.264503] pci 0000:02:00.0: PME# supported from D0 D3hot
[    0.264512] pci 0000:02:00.0: PME# disabled
[    0.264588] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.264599] pci 0000:00:1c.1:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.264677] pci 0000:00:1c.2: PCI bridge to [bus 01-01]
[    0.264771] pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive decode)
[    0.264816] pci_bus 0000:00: on NUMA node 0
[    0.264828] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.265375] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.265572] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.265769] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.266033] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.299467] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.299752] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.300065] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.300363] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.300644] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.300924] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 *4 5 6 7 10 11 12 14 15)
[    0.301203] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.301486] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.301904] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.301934] vgaarb: loaded
[    0.302094] PCI: Using ACPI for IRQ routing
[    0.302094] PCI: pci_cache_line_size set to 64 bytes
[    0.302094] IO-APIC supports EOI register
[    0.302094] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.302094] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.302094] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.308021] Switching to clocksource tsc
[    0.314358] pnp: PnP ACPI init
[    0.314396] ACPI: bus type pnp registered
[    0.321299] pnp: PnP ACPI: found 12 devices
[    0.321306] ACPI: ACPI bus type pnp unregistered
[    0.321314] PnPBIOS: Disabled by ACPI PNP
[    0.321344] system 00:01: [mem 0xfed13000-0xfed19fff] has been reserved
[    0.321362] system 00:06: [io  0x0290-0x0297] has been reserved
[    0.321383] system 00:07: [io  0x025c-0x025f] has been reserved
[    0.321390] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.321398] system 00:07: [io  0x0800-0x087f] has been reserved
[    0.321406] system 00:07: [io  0x0480-0x04bf] has been reserved
[    0.321415] system 00:07: [mem 0x8c000000-0x8c01ffff] has been reserved
[    0.321423] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.321431] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.321440] system 00:07: [mem 0xfed50000-0xfed8ffff] has been reserved
[    0.321448] system 00:07: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.321456] system 00:07: [mem 0xfff00000-0xffffffff] has been reserved
[    0.321473] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.321481] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.321496] system 00:0a: [mem 0xe0000000-0xe3ffffff] has been reserved
[    0.321512] system 00:0b: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.321521] system 00:0b: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.321529] system 00:0b: [mem 0x00100000-0x7f7fffff] could not be reserved
[    0.357229] pci 0000:00:1c.1: BAR 15: assigned [mem 0x80000000-0x801fffff 64bit pref]
[    0.357239] pci 0000:00:1c.2: BAR 14: assigned [mem 0x80200000-0x803fffff]
[    0.357248] pci 0000:00:1c.2: BAR 15: assigned [mem 0x80400000-0x805fffff 64bit pref]
[    0.357256] pci 0000:00:1c.1: BAR 13: assigned [io  0x1000-0x1fff]
[    0.357264] pci 0000:00:1c.2: BAR 13: assigned [io  0x2000-0x2fff]
[    0.357271] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.357279] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[    0.357289] pci 0000:00:1c.0:   bridge window [mem 0xfbf00000-0xfbffffff]
[    0.357299] pci 0000:00:1c.0:   bridge window [mem 0xfaf00000-0xfaffffff 64bit pref]
[    0.357311] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.357318] pci 0000:00:1c.1:   bridge window [io  0x1000-0x1fff]
[    0.357328] pci 0000:00:1c.1:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.357337] pci 0000:00:1c.1:   bridge window [mem 0x80000000-0x801fffff 64bit pref]
[    0.357349] pci 0000:00:1c.2: PCI bridge to [bus 01-01]
[    0.357356] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.357366] pci 0000:00:1c.2:   bridge window [mem 0x80200000-0x803fffff]
[    0.357375] pci 0000:00:1c.2:   bridge window [mem 0x80400000-0x805fffff 64bit pref]
[    0.357388] pci 0000:00:1e.0: PCI bridge to [bus 04-04]
[    0.357392] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.357401] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.357408] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.357440] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.357450] pci 0000:00:1c.0: setting latency timer to 64
[    0.357465] pci 0000:00:1c.1: enabling device (0106 -> 0107)
[    0.357476] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.357484] pci 0000:00:1c.1: setting latency timer to 64
[    0.357498] pci 0000:00:1c.2: enabling device (0104 -> 0107)
[    0.357509] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.357517] pci 0000:00:1c.2: setting latency timer to 64
[    0.357529] pci 0000:00:1e.0: setting latency timer to 64
[    0.357538] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.357544] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.357550] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.357556] pci_bus 0000:03: resource 1 [mem 0xfbf00000-0xfbffffff]
[    0.357563] pci_bus 0000:03: resource 2 [mem 0xfaf00000-0xfaffffff 64bit pref]
[    0.357569] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.357575] pci_bus 0000:02: resource 1 [mem 0xfbe00000-0xfbefffff]
[    0.357582] pci_bus 0000:02: resource 2 [mem 0x80000000-0x801fffff 64bit pref]
[    0.357588] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.357594] pci_bus 0000:01: resource 1 [mem 0x80200000-0x803fffff]
[    0.357601] pci_bus 0000:01: resource 2 [mem 0x80400000-0x805fffff 64bit pref]
[    0.357607] pci_bus 0000:04: resource 3 [io  0x0000-0xffff]
[    0.357613] pci_bus 0000:04: resource 4 [mem 0x00000000-0xffffffff]
[    0.357817] NET: Registered protocol family 2
[    0.358028] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.358995] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.360032] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.360492] TCP: Hash tables configured (established 131072 bind 65536)
[    0.360498] TCP reno registered
[    0.360507] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.360528] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.360957] NET: Registered protocol family 1
[    0.361003] pci 0000:00:02.0: Boot video device
[    0.361185] PCI: CLS 32 bytes, default 64
[    0.362048] Unpacking initramfs...
[    0.972370] Freeing initrd memory: 7507k freed
[    0.981664] audit: initializing netlink socket (disabled)
[    0.981729] type=2000 audit(1259953181.976:1): initialized
[    0.982177] highmem bounce pool size: 64 pages
[    0.982190] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.982698] VFS: Disk quotas dquot_6.5.2
[    0.982772] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.983027] msgmni has been set to 1724
[    0.983537] alg: No test for stdrng (krng)
[    0.983752] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.983760] io scheduler noop registered
[    0.983766] io scheduler deadline registered
[    0.983837] io scheduler cfq registered (default)
[    0.984202] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.984218] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.984615] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.984630] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.985006] pcieport 0000:00:1c.2: irq 26 for MSI/MSI-X
[    0.985021] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.985937] isapnp: Scanning for PnP cards...
[    1.339840] isapnp: No Plug & Play device found
[    1.347096] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.348611] PNP: No PS/2 controller found. Probing ports directly.
[    1.350996] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.351011] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.351406] mice: PS/2 mouse device common for all mice
[    1.351498] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    1.351551] rtc_cmos 00:03: RTC can wake from S4
[    1.351732] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.351780] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    1.351850] cpuidle: using governor ladder
[    1.351854] cpuidle: using governor menu
[    1.351866] No iBFT detected.
[    1.352499] TCP cubic registered
[    1.352722] NET: Registered protocol family 10
[    1.353805] lo: Disabled Privacy Extensions
[    1.354379] Mobile IPv6
[    1.354385] NET: Registered protocol family 17
[    1.354442] Using IPI No-Shortcut mode
[    1.354830] registered taskstats version 1
[    1.355363] rtc_cmos 00:03: setting system clock to 2009-12-04 18:59:42 UTC (1259953182)
[    1.355550] Freeing unused kernel memory: 364k freed
[    1.355850] Write protecting the kernel text: 2408k
[    1.355889] Write protecting the kernel read-only data: 852k
[    1.667192] uvesafb: Intel Corporation, Intel(r) 82945GM Chipset Family Graphics Controller, Hardware Version 0.0, OEM: Intel(r) 82945GM 
Chipset Family Graphics Chip Accelerated VGA BIOS, VBE v3.0
[    1.683759] uvesafb: VBIOS/hardware supports DDC2 transfers
[    1.696426] uvesafb: monitor limits: vf = 76 Hz, hf = 80 kHz, clk = 140 MHz
[    1.696680] uvesafb: scrolling: redraw
[    1.925778] Console: switching to colour frame buffer device 128x80
[    1.936060] uvesafb: framebuffer at 0xd0000000, mapped to 0xf7c80000, using 7872k, total 7872k
[    1.936066] fb0: VESA VGA frame buffer device
[    2.176609] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    2.176631] ACPI: Power Button [PWRB]
[    2.177105] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.177119] ACPI: Power Button [PWRF]
[    2.415196] Linux agpgart interface v0.103
[    2.574274] usbcore: registered new interface driver usbfs
[    2.574430] usbcore: registered new interface driver hub
[    2.574944] usbcore: registered new device driver usb
[    2.584302] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    2.584325] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    2.599495] Uniform Multi-Platform E-IDE driver
[    2.613957] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.614058] r8169 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.614128] r8169 0000:03:00.0: setting latency timer to 64
[    2.614215] r8169 0000:03:00.0: irq 27 for MSI/MSI-X
[    2.616326] eth0: RTL8168c/8111c at 0xf8558000, 00:23:54:c7:3d:1c, XID 1c4000c0 IRQ 27
[    2.632500] agpgart-intel 0000:00:00.0: Intel 945GME Chipset
[    2.632888] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    2.652032] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    2.702306] SCSI subsystem initialized
[    2.707520] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.707617] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.707677] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.707687] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.707808] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.707963] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    2.707987] ehci_hcd 0000:00:1d.7: debug port 1
[    2.711893] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.775528] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbcb7c00
[    2.783786] uhci_hcd: USB Universal Host Controller Interface driver
[    2.784208] libata version 3.00 loaded.
[    2.792032] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.792189] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.792199] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.792207] usb usb1: Product: EHCI Host Controller
[    2.792214] usb usb1: Manufacturer: Linux 2.6.32-rc8-next-20091202 ehci_hcd
[    2.792221] usb usb1: SerialNumber: 0000:00:1d.7
[    2.792756] hub 1-0:1.0: USB hub found
[    2.792785] hub 1-0:1.0: 8 ports detected
[    2.793067] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.793095] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.793105] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.793147] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.793233] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d480
[    2.793496] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.793505] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.793512] usb usb2: Product: UHCI Host Controller
[    2.793519] usb usb2: Manufacturer: Linux 2.6.32-rc8-next-20091202 uhci_hcd
[    2.793526] usb usb2: SerialNumber: 0000:00:1d.0
[    2.794073] hub 2-0:1.0: USB hub found
[    2.794104] hub 2-0:1.0: 2 ports detected
[    2.794359] ata_piix 0000:00:1f.2: version 2.13
[    2.794408] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.794422] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    2.795033] ata_piix 0000:00:1f.2: setting latency timer to 64
[    2.795274] scsi0 : ata_piix
[    2.798734] scsi1 : ata_piix
[    2.809817] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    2.809828] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    2.813569] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.813598] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.813607] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.813674] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.813782] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d800
[    2.814036] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.814046] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.814053] usb usb3: Product: UHCI Host Controller
[    2.814058] usb usb3: Manufacturer: Linux 2.6.32-rc8-next-20091202 uhci_hcd
[    2.814065] usb usb3: SerialNumber: 0000:00:1d.1
[    2.814587] hub 3-0:1.0: USB hub found
[    2.814615] hub 3-0:1.0: 2 ports detected
[    2.814819] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[    2.814839] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.814846] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.814885] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.814961] uhci_hcd 0000:00:1d.2: irq 21, io base 0x0000d880
[    2.815123] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.815129] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.815135] usb usb4: Product: UHCI Host Controller
[    2.815139] usb usb4: Manufacturer: Linux 2.6.32-rc8-next-20091202 uhci_hcd
[    2.815144] usb usb4: SerialNumber: 0000:00:1d.2
[    2.815833] hub 4-0:1.0: USB hub found
[    2.815861] hub 4-0:1.0: 2 ports detected
[    2.816193] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 22 (level, low) -> IRQ 22
[    2.816223] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.816233] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.816299] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.816403] uhci_hcd 0000:00:1d.3: irq 22, io base 0x0000dc00
[    2.816669] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.816679] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.816686] usb usb5: Product: UHCI Host Controller
[    2.816693] usb usb5: Manufacturer: Linux 2.6.32-rc8-next-20091202 uhci_hcd
[    2.816700] usb usb5: SerialNumber: 0000:00:1d.3
[    2.817517] hub 5-0:1.0: USB hub found
[    2.817547] hub 5-0:1.0: 2 ports detected
[    2.977712] ata1.00: ATA-8: ST9160310AS, 0303, max UDMA/133
[    2.977723] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.992692] ata1.00: configured for UDMA/133
[    2.993125] scsi 0:0:0:0: Direct-Access     ATA      ST9160310AS      0303 PQ: 0 ANSI: 5
[    3.023621] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.023833] sd 0:0:0:0: [sda] Write Protect is off
[    3.023840] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.023928] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.024688]  sda: sda1 sda2
[    3.261931] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.324040] usb 1-6: new high speed USB device using ehci_hcd and address 5
[    3.466809] usb 1-6: New USB device found, idVendor=0bda, idProduct=0158
[    3.466817] usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.466823] usb 1-6: Product: USB2.0-CRW
[    3.466827] usb 1-6: Manufacturer: Generic
[    3.466832] usb 1-6: SerialNumber: 20071114173400000
[    3.499117] Initializing USB Mass Storage driver...
[    3.499445] scsi2 : usb-storage 1-6:1.0
[    3.499979] usbcore: registered new interface driver usb-storage
[    3.500084] USB Mass Storage support registered.
[    3.712039] usb 2-1: new full speed USB device using uhci_hcd and address 2
[    3.726791] kjournald starting.  Commit interval 5 seconds
[    3.726817] EXT3-fs (sda2): mounted filesystem with ordered data mode
[    3.851384] usb 2-1: not running at top speed; connect to a high speed hub
[    3.859379] usb 2-1: New USB device found, idVendor=2001, idProduct=f103
[    3.859387] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.862635] hub 2-1:1.0: USB hub found
[    3.864385] hub 2-1:1.0: 7 ports detected
[    4.112061] usb 2-2: new full speed USB device using uhci_hcd and address 3
[    4.304340] usb 2-2: New USB device found, idVendor=041e, idProduct=4068
[    4.304348] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.304354] usb 2-2: Product: VF0470 Live! Cam Notebook
[    4.304359] usb 2-2: Manufacturer: Creative Labs
[    4.544033] usb 3-1: new low speed USB device using uhci_hcd and address 2
[    4.718877] usb 3-1: New USB device found, idVendor=413c, idProduct=2003
[    4.718885] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.718892] usb 3-1: Product: Dell USB Keyboard
[    4.718896] usb 3-1: Manufacturer: Dell
[    4.797326] usb 2-1.5: new full speed USB device using uhci_hcd and address 4
[    4.929315] usb 2-1.5: New USB device found, idVendor=065a, idProduct=0001
[    4.929324] usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.929330] usb 2-1.5: Product: Barcode Device
[    4.929335] usb 2-1.5: Manufacturer: OPTO-E
[    5.005316] usb 2-1.6: new full speed USB device using uhci_hcd and address 5
[    5.168306] usb 2-1.6: New USB device found, idVendor=0403, idProduct=6001
[    5.168314] usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    5.168321] usb 2-1.6: Product: USB Serial Converter
[    5.168325] usb 2-1.6: Manufacturer: FTDI
[    5.168329] usb 2-1.6: SerialNumber: FTEFGWQ7
[    5.249319] usb 2-1.7: new full speed USB device using uhci_hcd and address 6
[    5.370293] usb 2-1.7: New USB device found, idVendor=088c, idProduct=2030
[    5.370301] usb 2-1.7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.370307] usb 2-1.7: Product: TTP 2030
[    5.370311] usb 2-1.7: Manufacturer: Swecoin AB 
[    5.758224] udev: starting version 146
[    6.104285] ACPI: SSDT 7f7ae180 0023C (v01  PmRef  Cpu0Ist 00003000 INTL 20060113)
[    6.106201] ACPI: SSDT 7f7ae450 00594 (v01  PmRef  Cpu0Cst 00003001 INTL 20060113)
[    6.178493] Monitor-Mwait will be used to enter C-1 state
[    6.184166] Monitor-Mwait will be used to enter C-2 state
[    6.223946] Monitor-Mwait will be used to enter C-3 state
[    6.223981] Marking TSC unstable due to TSC halts in idle
[    6.223990] Switching to clocksource hpet
[    6.279261] processor LNXCPU:00: registered as cooling_device0
[    6.281270] ACPI: SSDT 7f7ae0b0 000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20060113)
[    6.282843] ACPI: SSDT 7f7ae3c0 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20060113)
[    6.340278] processor LNXCPU:01: registered as cooling_device1
[    6.626794] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    6.628178] intel_rng: FWH not detected
[    6.715885] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.816252] usbcore: registered new interface driver usbserial
[    6.816401] USB Serial support registered for generic
[    6.816651] usbcore: registered new interface driver usbserial_generic
[    6.816659] usbserial: USB Serial Driver core
[    6.950340] USB Serial support registered for FTDI USB Serial Device
[    6.951252] ftdi_sio 2-1.6:1.0: FTDI USB Serial Device converter detected
[    6.951639] usb 2-1.6: Detected FT232RL
[    6.951648] usb 2-1.6: Number of endpoints 2
[    6.951655] usb 2-1.6: Endpoint 1 MaxPacketSize 64
[    6.951662] usb 2-1.6: Endpoint 2 MaxPacketSize 64
[    6.951668] usb 2-1.6: Setting MaxPacketSize 64
[    6.953667] usb 2-1.6: FTDI USB Serial Device converter now attached to ttyUSB0
[    6.953850] usbcore: registered new interface driver ftdi_sio
[    6.953857] ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
[    6.962127] usblp0: USB Bidirectional printer dev 6 if 0 alt 0 proto 2 vid 0x088C pid 0x2030
[    6.962236] usbcore: registered new interface driver usblp
[    7.047814] Linux video capture interface: v2.00
[    7.064622] usbcore: registered new interface driver hiddev
[    7.083558] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input4
[    7.085163] generic-usb 0003:413C:2003.0001: input,hidraw0: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.1-1/input0
[    7.090753] input: OPTO-E Barcode Device as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/input/input5
[    7.091487] generic-usb 0003:065A:0001.0002: input,hidraw1: USB HID v1.00 Keyboard [OPTO-E Barcode Device] on usb-0000:00:1d.0-1.5/input0
[    7.091702] usbcore: registered new interface driver usbhid
[    7.091858] usbhid: USB HID core driver
[    7.134325] gspca: main v2.8.0 registered
[    7.154679] Error: Driver 'pcspkr' is already registered, aborting...
[    7.252212] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    7.252325] HDA Intel 0000:00:1b.0: irq 28 for MSI/MSI-X
[    7.252383] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.571576] gspca: probing 041e:4068
[    7.633137] hda_codec: ALC888: BIOS auto-probing.
[    7.634154] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
[    7.761343] ov519: I2C synced in 0 attempt(s)
[    7.761354] ov519: starting OV7xx0 configuration
[    7.773324] ov519: Sensor is an OV7670
[    8.498755] scsi 2:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
[    8.506407] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[    9.116721] gspca: /dev/video0 created
[    9.122995] usbcore: registered new interface driver snd-usb-audio
[    9.123644] usbcore: registered new interface driver ov519
[    9.123656] ov519: registered
[   10.369641] EXT3-fs (sda2): using internal journal
[   10.605661] loop: module loaded
[   12.053045] r8169: eth0: link up
[   12.053053] r8169: eth0: link up
[   14.005035] Clocksource tsc unstable (delta = -72774627 ns)
[   20.853586] usb 2-1.1: new full speed USB device using uhci_hcd and address 7
[   22.437078] eth0: no IPv6 routers present
[   30.989611] usb 2-1.1: New USB device found, idVendor=1870, idProduct=0001
[   30.989627] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   30.989639] usb 2-1.1: Product: iNexio USB
[   30.989648] usb 2-1.1: Manufacturer: iNexio
[   39.048657] Nexio device: m-Nexio, firmware version: 2.10SMSN
[   39.048678] ret = -22
[   39.049031] input: iNexio iNexio USB as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.1/input/input7
[   39.049410] usbcore: registered new interface driver usbtouchscreen
[   41.672369] [drm] Initialized drm 1.1.0 20060810
[   41.738332] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   41.738342] pci 0000:00:02.0: setting latency timer to 64
[   41.749971] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0


diff between ehci and uhci logs:
There seems to be some problem with timing.
Also order of ehci_usb vs uhci_usb loading changes.

--- dmesg-ehci.txt-	2009-12-04 20:01:39.000000000 +0100
+++ dmesg-uhci.txt-	2009-12-04 20:01:31.000000000 +0100
@@ -144,10 +144,9 @@
  Console: colour VGA+ 80x25
  console [tty0] enabled
  hpet clockevent registered
- Fast TSC calibration failed
- TSC: PIT calibration matches HPET. 1 loops
- Detected 1608.000 MHz processor.
- Calibrating delay loop (skipped), value calculated using timer frequency.. 3216.00 BogoMIPS (lpj=6432000)
+ Fast TSC calibration using PIT
+ Detected 1608.123 MHz processor.
+ Calibrating delay loop (skipped), value calculated using timer frequency.. 3216.24 BogoMIPS (lpj=6432492)
  Security Framework initialized
  SELinux:  Disabled at boot.
  Mount-cache hash table entries: 512
@@ -180,7 +179,7 @@
  CPU1: Thermal monitoring enabled (TM2)
  CPU1: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
  Brought up 2 CPUs
- Total of 2 processors activated (9326.27 BogoMIPS).
+ Total of 2 processors activated (6432.20 BogoMIPS).
  regulator: core version 0.5
  NET: Registered protocol family 16
  ACPI: bus type pci registered
@@ -361,7 +360,7 @@
  Unpacking initramfs...
  Freeing initrd memory: 7507k freed
  audit: initializing netlink socket (disabled)
- type=2000 audit(1259952279.980:1): initialized
+ type=2000 audit(1259953181.976:1): initialized
  highmem bounce pool size: 64 pages
  HugeTLB registered 4 MB page size, pre-allocated 0 pages
  VFS: Disk quotas dquot_6.5.2
@@ -399,7 +398,7 @@
  NET: Registered protocol family 17
  Using IPI No-Shortcut mode
  registered taskstats version 1
- rtc_cmos 00:03: setting system clock to 2009-12-04 18:44:40 UTC (1259952280)
+ rtc_cmos 00:03: setting system clock to 2009-12-04 18:59:42 UTC (1259953182)
  Freeing unused kernel memory: 364k freed
  Write protecting the kernel text: 2408k
  Write protecting the kernel read-only data: 852k
@@ -414,18 +413,18 @@
  ACPI: Power Button [PWRB]
  input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
  ACPI: Power Button [PWRF]
+ Linux agpgart interface v0.103
+ usbcore: registered new interface driver usbfs
+ usbcore: registered new interface driver hub
+ usbcore: registered new device driver usb
  input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input2
  ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
- Linux agpgart interface v0.103
+ Uniform Multi-Platform E-IDE driver
  r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
  r8169 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
  r8169 0000:03:00.0: setting latency timer to 64
  r8169 0000:03:00.0: irq 27 for MSI/MSI-X
- eth0: RTL8168c/8111c at 0xf84ea000, 00:23:54:c7:3d:1c, XID 1c4000c0 IRQ 27
- usbcore: registered new interface driver usbfs
- usbcore: registered new interface driver hub
- usbcore: registered new device driver usb
- Uniform Multi-Platform E-IDE driver
+ eth0: RTL8168c/8111c at 0xf8558000, 00:23:54:c7:3d:1c, XID 1c4000c0 IRQ 27
  agpgart-intel 0000:00:00.0: Intel 945GME Chipset
  agpgart-intel 0000:00:00.0: detected 7932K stolen memory
  agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
@@ -439,6 +438,8 @@
  ehci_hcd 0000:00:1d.7: debug port 1
  ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
  ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbcb7c00
+ uhci_hcd: USB Universal Host Controller Interface driver
+ libata version 3.00 loaded.
  ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
  usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
  usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
@@ -447,8 +448,6 @@
  usb usb1: SerialNumber: 0000:00:1d.7
  hub 1-0:1.0: USB hub found
  hub 1-0:1.0: 8 ports detected
- libata version 3.00 loaded.
- uhci_hcd: USB Universal Host Controller Interface driver
  uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
  uhci_hcd 0000:00:1d.0: setting latency timer to 64
  uhci_hcd 0000:00:1d.0: UHCI Host Controller
@@ -461,6 +460,14 @@
  usb usb2: SerialNumber: 0000:00:1d.0
  hub 2-0:1.0: USB hub found
  hub 2-0:1.0: 2 ports detected
+ ata_piix 0000:00:1f.2: version 2.13
+ ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
+ ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
+ ata_piix 0000:00:1f.2: setting latency timer to 64
+ scsi0 : ata_piix
+ scsi1 : ata_piix
+ ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
+ ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
  uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
  uhci_hcd 0000:00:1d.1: setting latency timer to 64
  uhci_hcd 0000:00:1d.1: UHCI Host Controller
@@ -497,14 +504,6 @@
  usb usb5: SerialNumber: 0000:00:1d.3
  hub 5-0:1.0: USB hub found
  hub 5-0:1.0: 2 ports detected
- ata_piix 0000:00:1f.2: version 2.13
- ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
- ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
- ata_piix 0000:00:1f.2: setting latency timer to 64
- scsi0 : ata_piix
- scsi1 : ata_piix
- ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
- ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
  ata1.00: ATA-8: ST9160310AS, 0303, max UDMA/133
  ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
  ata1.00: configured for UDMA/133
@@ -513,13 +512,7 @@
  sd 0:0:0:0: [sda] Write Protect is off
  sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
  sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
-  sda:
- usb 1-1: new high speed USB device using ehci_hcd and address 2
- usb 1-1: New USB device found, idVendor=2001, idProduct=f103
- usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
- hub 1-1:1.0: USB hub found
- hub 1-1:1.0: 7 ports detected
-  sda1 sda2
+  sda: sda1 sda2
  sd 0:0:0:0: [sda] Attached SCSI disk
  usb 1-6: new high speed USB device using ehci_hcd and address 5
  usb 1-6: New USB device found, idVendor=0bda, idProduct=0158
@@ -531,9 +524,15 @@
  scsi2 : usb-storage 1-6:1.0
  usbcore: registered new interface driver usb-storage
  USB Mass Storage support registered.
+ usb 2-1: new full speed USB device using uhci_hcd and address 2
  kjournald starting.  Commit interval 5 seconds
  EXT3-fs (sda2): mounted filesystem with ordered data mode
- usb 2-2: new full speed USB device using uhci_hcd and address 2
+ usb 2-1: not running at top speed; connect to a high speed hub
+ usb 2-1: New USB device found, idVendor=2001, idProduct=f103
+ usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
+ hub 2-1:1.0: USB hub found
+ hub 2-1:1.0: 7 ports detected
+ usb 2-2: new full speed USB device using uhci_hcd and address 3
  usb 2-2: New USB device found, idVendor=041e, idProduct=4068
  usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
  usb 2-2: Product: VF0470 Live! Cam Notebook
@@ -543,22 +542,22 @@
  usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
  usb 3-1: Product: Dell USB Keyboard
  usb 3-1: Manufacturer: Dell
- usb 1-1.5: new full speed USB device using ehci_hcd and address 6
- usb 1-1.5: New USB device found, idVendor=065a, idProduct=0001
- usb 1-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
- usb 1-1.5: Product: Barcode Device
- usb 1-1.5: Manufacturer: OPTO-E
- usb 1-1.6: new full speed USB device using ehci_hcd and address 7
- usb 1-1.6: New USB device found, idVendor=0403, idProduct=6001
- usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
- usb 1-1.6: Product: USB Serial Converter
- usb 1-1.6: Manufacturer: FTDI
- usb 1-1.6: SerialNumber: FTEFGWQ7
- usb 1-1.7: new full speed USB device using ehci_hcd and address 8
- usb 1-1.7: New USB device found, idVendor=088c, idProduct=2030
- usb 1-1.7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
- usb 1-1.7: Product: TTP 2030
- usb 1-1.7: Manufacturer: Swecoin AB 
+ usb 2-1.5: new full speed USB device using uhci_hcd and address 4
+ usb 2-1.5: New USB device found, idVendor=065a, idProduct=0001
+ usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
+ usb 2-1.5: Product: Barcode Device
+ usb 2-1.5: Manufacturer: OPTO-E
+ usb 2-1.6: new full speed USB device using uhci_hcd and address 5
+ usb 2-1.6: New USB device found, idVendor=0403, idProduct=6001
+ usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
+ usb 2-1.6: Product: USB Serial Converter
+ usb 2-1.6: Manufacturer: FTDI
+ usb 2-1.6: SerialNumber: FTEFGWQ7
+ usb 2-1.7: new full speed USB device using uhci_hcd and address 6
+ usb 2-1.7: New USB device found, idVendor=088c, idProduct=2030
+ usb 2-1.7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
+ usb 2-1.7: Product: TTP 2030
+ usb 2-1.7: Manufacturer: Swecoin AB 
  udev: starting version 146
  ACPI: SSDT 7f7ae180 0023C (v01  PmRef  Cpu0Ist 00003000 INTL 20060113)
  ACPI: SSDT 7f7ae450 00594 (v01  PmRef  Cpu0Cst 00003001 INTL 20060113)
@@ -574,41 +573,41 @@
  input: PC Speaker as /devices/platform/pcspkr/input/input3
  intel_rng: FWH not detected
  i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
- usblp0: USB Bidirectional printer dev 8 if 0 alt 0 proto 2 vid 0x088C pid 0x2030
- usbcore: registered new interface driver usblp
- Linux video capture interface: v2.00
  usbcore: registered new interface driver usbserial
  USB Serial support registered for generic
  usbcore: registered new interface driver usbserial_generic
  usbserial: USB Serial Driver core
- Error: Driver 'pcspkr' is already registered, aborting...
  USB Serial support registered for FTDI USB Serial Device
- ftdi_sio 1-1.6:1.0: FTDI USB Serial Device converter detected
- usb 1-1.6: Detected FT232RL
- usb 1-1.6: Number of endpoints 2
- usb 1-1.6: Endpoint 1 MaxPacketSize 64
- usb 1-1.6: Endpoint 2 MaxPacketSize 64
- usb 1-1.6: Setting MaxPacketSize 64
- usb 1-1.6: FTDI USB Serial Device converter now attached to ttyUSB0
+ ftdi_sio 2-1.6:1.0: FTDI USB Serial Device converter detected
+ usb 2-1.6: Detected FT232RL
+ usb 2-1.6: Number of endpoints 2
+ usb 2-1.6: Endpoint 1 MaxPacketSize 64
+ usb 2-1.6: Endpoint 2 MaxPacketSize 64
+ usb 2-1.6: Setting MaxPacketSize 64
+ usb 2-1.6: FTDI USB Serial Device converter now attached to ttyUSB0
  usbcore: registered new interface driver ftdi_sio
  ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
- gspca: main v2.8.0 registered
+ usblp0: USB Bidirectional printer dev 6 if 0 alt 0 proto 2 vid 0x088C pid 0x2030
+ usbcore: registered new interface driver usblp
+ Linux video capture interface: v2.00
  usbcore: registered new interface driver hiddev
- HDA Intel 0000:00:1b.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
- HDA Intel 0000:00:1b.0: irq 28 for MSI/MSI-X
- HDA Intel 0000:00:1b.0: setting latency timer to 64
- gspca: probing 041e:4068
  input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input4
  generic-usb 0003:413C:2003.0001: input,hidraw0: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.1-1/input0
- input: OPTO-E Barcode Device as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1.5/1-1.5:1.0/input/input5
- generic-usb 0003:065A:0001.0002: input,hidraw1: USB HID v1.00 Keyboard [OPTO-E Barcode Device] on usb-0000:00:1d.7-1.5/input0
+ input: OPTO-E Barcode Device as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/input/input5
+ generic-usb 0003:065A:0001.0002: input,hidraw1: USB HID v1.00 Keyboard [OPTO-E Barcode Device] on usb-0000:00:1d.0-1.5/input0
  usbcore: registered new interface driver usbhid
  usbhid: USB HID core driver
+ gspca: main v2.8.0 registered
+ Error: Driver 'pcspkr' is already registered, aborting...
+ HDA Intel 0000:00:1b.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
+ HDA Intel 0000:00:1b.0: irq 28 for MSI/MSI-X
+ HDA Intel 0000:00:1b.0: setting latency timer to 64
+ gspca: probing 041e:4068
+ hda_codec: ALC888: BIOS auto-probing.
+ input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
  ov519: I2C synced in 0 attempt(s)
  ov519: starting OV7xx0 configuration
  ov519: Sensor is an OV7670
- hda_codec: ALC888: BIOS auto-probing.
- input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
  scsi 2:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
  sd 2:0:0:0: [sdb] Attached SCSI removable disk
  gspca: /dev/video0 created
@@ -619,57 +618,18 @@
  loop: module loaded
  r8169: eth0: link up
  r8169: eth0: link up
- usb 1-1.1: new full speed USB device using ehci_hcd and address 9
+ Clocksource tsc unstable (delta = -72774627 ns)
+ usb 2-1.1: new full speed USB device using uhci_hcd and address 7
  eth0: no IPv6 routers present
- usb 1-1.1: New USB device found, idVendor=1870, idProduct=0001
- usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
- usb 1-1.1: Product: iNexio USB
- usb 1-1.1: Manufacturer: iNexio
+ usb 2-1.1: New USB device found, idVendor=1870, idProduct=0001
+ usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
+ usb 2-1.1: Product: iNexio USB
+ usb 2-1.1: Manufacturer: iNexio
  Nexio device: m-Nexio, firmware version: 2.10SMSN
  ret = -22
- input: iNexio iNexio USB as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1.1/1-1.1:1.1/input/input7
+ input: iNexio iNexio USB as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.1/input/input7
  usbcore: registered new interface driver usbtouchscreen
  [drm] Initialized drm 1.1.0 20060810
  pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
  pci 0000:00:02.0: setting latency timer to 64
  [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0


> > With uhci_hcd, rmmod works fine. With ehci_hcd, rmmod hangs the bus - all
> > urbs fail with -ENOENT:
> > f67265e8 1428021080 S Bi:1:009:2 -115 128 <
> > f67265e8 1431508327 C Bi:1:009:2 -108 0
> > f6726718 1458252464 S Co:1:007:0 s 40 09 0001 0000 0000 0
> > f6726718 1463261404 C Co:1:007:0 -2 0
> > f6726978 1463261428 S Co:1:002:0 s 23 08 0070 0001 0000 0
> > f6726718 1463261509 S Co:1:007:0 s 40 00 0000 0000 0000 0
> > f6726978 1464273397 C Co:1:002:0 -2 0
> > f6726718 1468273397 C Co:1:007:0 -2 0
>
> This may be a bug in ehci-hcd, a bug in your EHCI hardware, or a bug in
> the hub.  Can you try using a different high-speed hub to see if it
> makes any difference?

Yes, I'll try it next week (I have only remote access now).
I have different 7-port hub available to test (should be with Philips chipset).

> Alan Stern


-- 
Ondrej Zary
