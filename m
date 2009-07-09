Return-Path: <linux-kernel-owner+w=401wt.eu-S1761772AbZGIPqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761772AbZGIPqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbZGIPqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:46:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:39417 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248AbZGIPqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=jiePxknyA527M9d85vHzrbkus+iigGDH6P3bFeoq8wrEJ5zcjXLXBj/GMQXAJJS6M7
         Zj61+QVYtXS+X9dNLs/QTOy2GjzBAmGxQytpAczB3SMmULXgjIbg6EdPnKojil+Y6X98
         ldCrEgYl2X9eyU+o78Qo2nEj9wusswgL7H8Wo=
Message-ID: <4A561074.5080407@gmail.com>
Date: Thu, 09 Jul 2009 17:44:52 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Linux PM List <linux-pm@lists.linux-foundation.org>,
       cpufreq@vger.kernel.org
Subject: 2.6.31-rc2+: Interrupts enabled after cpufreq_suspend
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I find this message after resume from s2ram:
[  133.014802] ------------[ cut here ]------------
[  133.014814] WARNING: at drivers/base/sys.c:411 sysdev_suspend+0xd3/0x27b()
[  133.014819] Hardware name: To Be Filled By O.E.M.
[  133.014828] Interrupts enabled after cpufreq_suspend+0x0/0xfd
[  133.014832] Modules linked in:
[  133.014840] Pid: 6569, comm: s2ram Not tainted 2.6.31-rc2-faf80-wusb54gc #139
[  133.014845] Call Trace:
[  133.014853]  [<ffffffff8126960a>] ? sysdev_suspend+0xd3/0x27b
[  133.014864]  [<ffffffff810388a9>] warn_slowpath_common+0x77/0xa4
[  133.014873]  [<ffffffff8103894b>] warn_slowpath_fmt+0x64/0x66
[  133.014883]  [<ffffffff8101ac71>] ? query_values_on_cpu+0x0/0x19
[  133.014892]  [<ffffffff813273bc>] ? cpufreq_suspend+0x0/0xfd
[  133.014900]  [<ffffffff811e6d35>] ? kobject_put+0x47/0x4b
[  133.014908]  [<ffffffff813269fd>] ? cpufreq_cpu_put+0x1f/0x21
[  133.014917]  [<ffffffff813274ac>] ? cpufreq_suspend+0xf0/0xfd
[  133.014926]  [<ffffffff8105aeda>] ? trace_hardirqs_off+0xd/0xf
[  133.014934]  [<ffffffff8126960a>] sysdev_suspend+0xd3/0x27b
[  133.014944]  [<ffffffff81068fd8>] suspend_devices_and_enter+0xca/0x14d
[  133.014952]  [<ffffffff81069114>] enter_state+0xb9/0xec
[  133.014959]  [<ffffffff81068923>] state_store+0xb7/0xd7
[  133.014967]  [<ffffffff811e6b4b>] kobj_attr_store+0x17/0x19
[  133.014976]  [<ffffffff811094b1>] sysfs_write_file+0xe4/0x119
[  133.014985]  [<ffffffff810b9f57>] vfs_write+0xac/0x164
[  133.014991]  [<ffffffff810ba0d3>] sys_write+0x47/0x6e
[  133.015000]  [<ffffffff8100aee8>] system_call_fastpath+0x16/0x1b
[  133.015006] ---[ end trace 470f36a1cfb444d7 ]---

it's faf80d62e44dc627efb741f48db50c1858d1667c
full dmesg below

[    0.000000] Linux version 2.6.31-rc2-faf80-wusb54gc (marcin@joi) (gcc version 4.3.2 (Gentoo 4.3.2-r3 p1.6, pie-10.1.5) ) #139 PREEMPT Thu Jul 9 00:29:08 CEST 2009
[    0.000000] Command line: root=/dev/sda5 vga=794 nmi_watchdog=2
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffb0000 (usable)
[    0.000000]  BIOS-e820: 000000003ffb0000 - 000000003ffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ffc0000 - 000000003fff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] last_pfn = 0x3ffb0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 base 00E0000000 mask FFF8000000 write-combining
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000003ffb0000
[    0.000000]  0000000000 - 003fe00000 page 2M
[    0.000000]  003fe00000 - 003ffb0000 page 4k
[    0.000000] kernel direct mapping tables up to 3ffb0000 @ 8000-b000
[    0.000000] ACPI: RSDP 00000000000fa810 00021 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 000000003ffb0100 0003C (v01 A M I  OEMXSDT  10000427 MSFT 00000097)
[    0.000000] ACPI: FACP 000000003ffb0290 000F4 (v03 A M I  OEMFACP  10000427 MSFT 00000097)
[    0.000000] ACPI: DSDT 000000003ffb03e0 038A1 (v01  A0036 A0036001 00000001 MSFT 0100000D)
[    0.000000] ACPI: FACS 000000003ffc0000 00040
[    0.000000] ACPI: APIC 000000003ffb0390 0004A (v01 A M I  OEMAPIC  10000427 MSFT 00000097)
[    0.000000] ACPI: OEMB 000000003ffc0040 0003F (v01 A M I  OEMBIOS  10000427 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 003ffb0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001fb1bc0]    TEXT DATA BSS ==> [0001000000 - 0001fb1bc0]
[    0.000000]   #3 [000009d800 - 0000100000]    BIOS reserved ==> [000009d800 - 0000100000]
[    0.000000]   #4 [0001fb2000 - 0001fb2298]              BRK ==> [0001fb2000 - 0001fb2298]
[    0.000000]   #5 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
[    0.000000]  [ffffea0000000000-ffffea0000dfffff] PMD -> [ffff880002400000-ffff8800031fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003ffb0
[    0.000000] On node 0 totalpages: 261967
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 102 pages reserved
[    0.000000]   DMA zone: 3841 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3527 pages used for memmap
[    0.000000]   DMA32 zone: 254441 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 3, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:bf780000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258282
[    0.000000] Kernel command line: root=/dev/sda5 vga=794 nmi_watchdog=2
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] AGP bridge at 00:00:00
[    0.000000] Aperture from AGP @ e0000000 old size 32 MB
[    0.000000] Aperture from AGP @ e0000000 size 128 MB (APSIZE f20)
[    0.000000] Node 0: aperture @ e0000000 size 128 MB
[    0.000000] Memory: 1015124k/1048256k available (4310k kernel code, 388k absent, 32112k reserved, 2584k data, 328k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:288
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2002.731 MHz processor.
[    0.000051] Console: colour dummy device 80x25
[    0.000072] console [tty0] enabled
[    0.000999] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000999] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000999] ... MAX_LOCK_DEPTH:          48
[    0.000999] ... MAX_LOCKDEP_KEYS:        8191
[    0.000999] ... CLASSHASH_SIZE:          4096
[    0.000999] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000999] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000999] ... CHAINHASH_SIZE:          16384
[    0.000999]  memory used by lock dependency info: 5695 kB
[    0.000999]  per task-struct memory footprint: 1920 bytes
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 4005.46 BogoMIPS (lpj=2002731)
[    0.000999] Mount-cache hash table entries: 256
[    0.001442] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.001455] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001463] tseg: 0000000000
[    0.001540] mce: CPU supports 5 MCE banks
[    0.001557] Performance Counters: AMD PMU driver.
[    0.001576] ... version:                 0
[    0.001584] ... bit width:               48
[    0.001592] ... generic counters:        4
[    0.001600] ... value mask:              0000ffffffffffff
[    0.001609] ... max period:              00007fffffffffff
[    0.001618] ... fixed-purpose counters:  0
[    0.001626] ... counter mask:            000000000000000f
[    0.001635] CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 00
[    0.001660] ACPI: Core revision 20090521
[    0.008976] Setting APIC routing to flat
[    0.009846] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.019996] Testing NMI watchdog ... OK.
[    0.040885] NET: Registered protocol family 16
[    0.042130] node 0 link 0: io port [1000, ffffff]
[    0.042135] TOM: 0000000040000000 aka 1024M
[    0.042148] node 0 link 0: mmio [a0000, bffff]
[    0.042152] node 0 link 0: mmio [40000000, ffffffff]
[    0.042157] bus: [00,ff] on node 0 link 0
[    0.042160] bus: 00 index 0 io port: [0, ffff]
[    0.042163] bus: 00 index 1 mmio: [a0000, bffff]
[    0.042166] bus: 00 index 2 mmio: [40000000, fcffffffff]
[    0.042222] ACPI: bus type pci registered
[    0.042491] PCI: Using configuration type 1 for base access
[    0.072109] bio: create slab <bio-0> at 0
[    0.074593] ACPI: EC: Look up EC in DSDT
[    0.080648] ACPI Warning: Package List length (EA) larger than NumElements count (3), truncated
[    0.080672]  20090521 dsobject-502
[    0.087453] ACPI: Interpreter enabled
[    0.087465] ACPI: (supports S0 S1 S3 S4 S5)
[    0.087549] ACPI: Using IOAPIC for interrupt routing
[    0.101485] ACPI: No dock devices found.
[    0.101684] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.102019] pci 0000:00:00.0: reg 10 32bit mmio: [0xe0000000-0xe7ffffff]
[    0.102497] pci 0000:00:01.0: supports D1
[    0.102573] pci 0000:00:0a.0: reg 10 32bit mmio: [0xfab00000-0xfab03fff]
[    0.102583] pci 0000:00:0a.0: reg 14 io port: [0xa800-0xa8ff]
[    0.102615] pci 0000:00:0a.0: reg 30 32bit mmio: [0xfaa00000-0xfaa1ffff]
[    0.102647] pci 0000:00:0a.0: supports D1 D2
[    0.102650] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.102665] pci 0000:00:0a.0: PME# disabled
[    0.102709] pci 0000:00:0c.0: reg 10 io port: [0xb000-0xb01f]
[    0.102748] pci 0000:00:0c.0: reg 30 32bit mmio: [0xfac00000-0xfac07fff]
[    0.102807] pci 0000:00:0d.0: reg 10 32bit mmio: [0xefe00000-0xefe00fff]
[    0.102925] pci 0000:00:0d.1: reg 10 32bit mmio: [0xeff00000-0xeff00fff]
[    0.103117] pci 0000:00:0f.0: reg 10 io port: [0xd000-0xd007]
[    0.103127] pci 0000:00:0f.0: reg 14 io port: [0xc800-0xc803]
[    0.103136] pci 0000:00:0f.0: reg 18 io port: [0xc400-0xc407]
[    0.103146] pci 0000:00:0f.0: reg 1c io port: [0xc000-0xc003]
[    0.103155] pci 0000:00:0f.0: reg 20 io port: [0xb800-0xb80f]
[    0.103165] pci 0000:00:0f.0: reg 24 io port: [0xb400-0xb4ff]
[    0.103266] pci 0000:00:0f.1: reg 20 io port: [0xfc00-0xfc0f]
[    0.103387] pci 0000:00:10.0: reg 20 io port: [0xd400-0xd41f]
[    0.103424] pci 0000:00:10.0: supports D1 D2
[    0.103427] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.103442] pci 0000:00:10.0: PME# disabled
[    0.103516] pci 0000:00:10.1: reg 20 io port: [0xd800-0xd81f]
[    0.103553] pci 0000:00:10.1: supports D1 D2
[    0.103556] pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.103570] pci 0000:00:10.1: PME# disabled
[    0.103645] pci 0000:00:10.2: reg 20 io port: [0xe000-0xe01f]
[    0.103682] pci 0000:00:10.2: supports D1 D2
[    0.103685] pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.103699] pci 0000:00:10.2: PME# disabled
[    0.103773] pci 0000:00:10.3: reg 20 io port: [0xe400-0xe41f]
[    0.103811] pci 0000:00:10.3: supports D1 D2
[    0.103814] pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.103827] pci 0000:00:10.3: PME# disabled
[    0.103880] pci 0000:00:10.4: reg 10 32bit mmio: [0xfae00000-0xfae000ff]
[    0.103940] pci 0000:00:10.4: supports D1 D2
[    0.103943] pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.103956] pci 0000:00:10.4: PME# disabled
[    0.104059] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.104076] pci 0000:00:11.0: Enabled onboard AC97/MC97 devices
[    0.104164] pci 0000:00:11.5: reg 10 io port: [0xe800-0xe8ff]
[    0.104227] pci 0000:00:11.5: supports D1 D2
[    0.104274] pci 0000:00:11.6: reg 10 io port: [0x00-0xff]
[    0.104607] pci 0000:01:00.0: reg 10 32bit mmio: [0xfb000000-0xfbffffff]
[    0.104615] pci 0000:01:00.0: reg 14 32bit mmio: [0xf0000000-0xf7ffffff]
[    0.104642] pci 0000:01:00.0: reg 30 32bit mmio: [0xfaf00000-0xfaf1ffff]
[    0.104756] pci 0000:00:01.0: bridge 32bit mmio: [0xfaf00000-0xfbffffff]
[    0.104762] pci 0000:00:01.0: bridge 32bit mmio pref: [0xf0000000-0xf9ffffff]
[    0.104772] pci_bus 0000:00: on NUMA node 0
[    0.104780] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.125016] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 14 15)
[    0.125233] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11 14 15)
[    0.125405] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 10 11 14 15)
[    0.125577] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
[    0.125755] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
[    0.125933] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
[    0.126134] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
[    0.126313] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
[    0.126921] SCSI subsystem initialized
[    0.127002] libata version 3.00 loaded.
[    0.127266] usbcore: registered new interface driver usbfs
[    0.127440] usbcore: registered new interface driver hub
[    0.127584] usbcore: registered new device driver usb
[    0.128267] PCI: Using ACPI for IRQ routing
[    0.129217] NET: Registered protocol family 8
[    0.129230] NET: Registered protocol family 20
[    0.129683] cfg80211: Calling CRDA to update world regulatory domain
[    0.130217] agpgart-amd64 0000:00:00.0: AGP bridge [1106/0282]
[    0.136545] agpgart-amd64 0000:00:00.0: AGP aperture is 128M @ 0xe0000000
[    0.143007] pnp: PnP ACPI init
[    0.143068] ACPI: bus type pnp registered
[    0.145853] pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:11.6 BAR 0 (0x0-0xff), disabling
[    0.145875] pnp 00:08: io resource (0x22-0x3f) overlaps 0000:00:11.6 BAR 0 (0x0-0xff), disabling
[    0.145893] pnp 00:08: io resource (0x44-0x5f) overlaps 0000:00:11.6 BAR 0 (0x0-0xff), disabling
[    0.145912] pnp 00:08: io resource (0x62-0x63) overlaps 0000:00:11.6 BAR 0 (0x0-0xff), disabling
[    0.145930] pnp 00:08: io resource (0x65-0x6f) overlaps 0000:00:11.6 BAR 0 (0x0-0xff), disabling
[    0.145948] pnp 00:08: io resource (0x72-0x7f) overlaps 0000:00:11.6 BAR 0 (0x0-0xff), disabling
[    0.145966] pnp 00:08: io resource (0x80-0x80) overlaps 0000:00:11.6 BAR 0 (0x0-0xff), disabling
[    0.145991] pnp 00:08: io resource (0x84-0x86) overlaps 0000:00:11.6 BAR 0 (0x0-0xff), disabling
[    0.146010] pnp 00:08: io resource (0x88-0x88) overlaps 0000:00:11.6 BAR 0 (0x0-0xff), disabling
[    0.146028] pnp 00:08: io resource (0x8c-0x8e) overlaps 0000:00:11.6 BAR 0 (0x0-0xff), disabling
[    0.146047] pnp 00:08: io resource (0x90-0x9f) overlaps 0000:00:11.6 BAR 0 (0x0-0xff), disabling
[    0.146065] pnp 00:08: io resource (0xa2-0xbf) overlaps 0000:00:11.6 BAR 0 (0x0-0xff), disabling
[    0.146083] pnp 00:08: io resource (0xe0-0xef) overlaps 0000:00:11.6 BAR 0 (0x0-0xff), disabling
[    0.148919] pnp: PnP ACPI: found 11 devices
[    0.148932] ACPI: ACPI bus type pnp unregistered
[    0.148966] system 00:07: ioport range 0x680-0x6ff has been reserved
[    0.148987] system 00:07: ioport range 0x290-0x297 has been reserved
[    0.149010] system 00:08: ioport range 0x3e1-0x3e7 has been reserved
[    0.149024] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.149037] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.149051] system 00:08: ioport range 0x400-0x41f has been reserved
[    0.149073] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.149088] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.149102] system 00:09: iomem range 0xfff80000-0xffffffff has been reserved
[    0.149126] system 00:0a: iomem range 0x0-0x9ffff could not be reserved
[    0.149140] system 00:0a: iomem range 0xc0000-0xdffff has been reserved
[    0.149154] system 00:0a: iomem range 0xe0000-0xfffff could not be reserved
[    0.149169] system 00:0a: iomem range 0x100000-0x3ffeffff could not be reserved
[    0.154834] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.154849] pci 0000:00:01.0:   IO window: disabled
[    0.154863] pci 0000:00:01.0:   MEM window: 0xfaf00000-0xfbffffff
[    0.154879] pci 0000:00:01.0:   PREFETCH window: 0xf0000000-0xf9ffffff
[    0.154906] pci 0000:00:01.0: setting latency timer to 64
[    0.154912] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.154916] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.154920] pci_bus 0000:01: resource 1 mem: [0xfaf00000-0xfbffffff]
[    0.154923] pci_bus 0000:01: resource 2 pref mem [0xf0000000-0xf9ffffff]
[    0.155015] NET: Registered protocol family 2
[    0.155308] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.156498] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    0.158112] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    0.166002] TCP: Hash tables configured (established 131072 bind 65536)
[    0.166063] TCP reno registered
[    0.166253] NET: Registered protocol family 1
[    0.169661] cpu0(1) debug files 137
[    0.178220] VFS: Disk quotas dquot_6.5.2
[    0.178457] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.181148] NTFS driver 2.1.29 [Flags: R/O].
[    0.181470] fuse init (API version 7.12)
[    0.182227] msgmni has been set to 1983
[    0.183351] alg: No test for stdrng (krng)
[    0.183402] io scheduler noop registered
[    0.183437] io scheduler cfq registered (default)
[    0.183471] pci 0000:00:01.0: disabling DAC on VIA PCI bridge
[    0.183617] pci 0000:01:00.0: Boot video device
[    0.184330] vesafb: framebuffer at 0xf0000000, mapped to 0xffffc90000080000, using 5120k, total 131072k
[    0.184351] vesafb: mode is 1280x1024x16, linelength=2560, pages=1
[    0.184364] vesafb: scrolling: redraw
[    0.184374] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.245114] Console: switching to colour frame buffer device 160x64
[    0.300794] fb0: VESA VGA frame buffer device
[    0.301660] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.302231] ACPI: Power Button [PWRF]
[    0.302681] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.303270] ACPI: Power Button [PWRB]
[    0.303710] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.304277] ACPI: Sleep Button [SLPB]
[    0.305253] processor LNXCPU:00: registered as cooling_device0
[    0.374918] Linux agpgart interface v0.103
[    0.377452] loop: module loaded
[    0.378443] sata_via 0000:00:0f.0: version 2.4
[    0.378465] sata_via 0000:00:0f.0: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    0.379086] sata_via 0000:00:0f.0: routed to hard irq line 10
[    0.379602] scsi0 : sata_via
[    0.380368] scsi1 : sata_via
[    0.380777] ata1: SATA max UDMA/133 cmd 0xd000 ctl 0xc800 bmdma 0xb800 irq 20
[    0.381300] ata2: SATA max UDMA/133 cmd 0xc400 ctl 0xc000 bmdma 0xb808 irq 20
[    0.382089] pata_via 0000:00:0f.1: version 0.3.4
[    0.382106] pata_via 0000:00:0f.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.383005] scsi2 : pata_via
[    0.383450] scsi3 : pata_via
[    0.388469] ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
[    0.388951] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
[    0.389797] ne2k-pci.c:v1.03 9/22/2003 D. Becker/P. Gortmaker
[    0.390209] ne2k-pci 0000:00:0c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.391572] eth0: Compex RL2000 found at 0xb000, IRQ 17, 00:80:48:de:5e:89.
[    0.392179] skge 0000:00:0a.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.392650] skge 0000:00:0a.0: PCI: Disallowing DAC for device
[    0.393092] skge 1.13 addr 0xfab00000 irq 17 chip Yukon-Lite rev 9
[    0.394326] skge eth1: addr 00:11:d8:60:74:55
[    0.394720] PPP generic driver version 2.4.2
[    0.395382] PPP Deflate Compression module registered
[    0.395728] PPP BSD Compression module registered
[    0.396443] PPP MPPE Compression module registered
[    0.396770] NET: Registered protocol family 24
[    0.397105] tun: Universal TUN/TAP device driver, 1.6
[    0.408036] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.419511] console [netcon0] enabled
[    0.430978] netconsole: network logging started
[    0.442817] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.455091] ehci_hcd 0000:00:10.4: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[    0.467719] ehci_hcd 0000:00:10.4: EHCI Host Controller
[    0.480654] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
[    0.493868] ehci_hcd 0000:00:10.4: irq 21, io mem 0xfae00000
[    0.512945] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
[    0.526591] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.540464] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.554630] usb usb1: Product: EHCI Host Controller
[    0.568977] usb usb1: Manufacturer: Linux 2.6.31-rc2-faf80-wusb54gc ehci_hcd
[    0.583799] usb usb1: SerialNumber: 0000:00:10.4
[    0.599527] usb usb1: configuration #1 chosen from 1 choice
[    0.615184] hub 1-0:1.0: USB hub found
[    0.630636] hub 1-0:1.0: 8 ports detected
[    0.647455] uhci_hcd: USB Universal Host Controller Interface driver
[    0.663692] uhci_hcd 0000:00:10.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    0.680138] uhci_hcd 0000:00:10.0: UHCI Host Controller
[    0.696691] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
[    0.713666] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000d400
[    0.730827] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.748362] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.765858] usb usb2: Product: UHCI Host Controller
[    0.783205] usb usb2: Manufacturer: Linux 2.6.31-rc2-faf80-wusb54gc uhci_hcd
[    0.800618] usb usb2: SerialNumber: 0000:00:10.0
[    0.818010] usb usb2: configuration #1 chosen from 1 choice
[    0.835130] hub 2-0:1.0: USB hub found
[    0.851897] hub 2-0:1.0: 2 ports detected
[    0.868520] uhci_hcd 0000:00:10.1: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    0.884980] uhci_hcd 0000:00:10.1: UHCI Host Controller
[    0.901262] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
[    0.917663] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000d800
[    0.934067] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.950513] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.967022] usb usb3: Product: UHCI Host Controller
[    0.983453] usb usb3: Manufacturer: Linux 2.6.31-rc2-faf80-wusb54gc uhci_hcd
[    1.000343] usb usb3: SerialNumber: 0000:00:10.1
[    1.017241] usb usb3: configuration #1 chosen from 1 choice
[    1.034284] hub 3-0:1.0: USB hub found
[    1.050996] hub 3-0:1.0: 2 ports detected
[    1.067713] uhci_hcd 0000:00:10.2: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.084744] uhci_hcd 0000:00:10.2: UHCI Host Controller
[    1.101560] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
[    1.118992] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e000
[    1.136032] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.153105] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.170076] usb usb4: Product: UHCI Host Controller
[    1.186859] usb usb4: Manufacturer: Linux 2.6.31-rc2-faf80-wusb54gc uhci_hcd
[    1.203900] usb usb4: SerialNumber: 0000:00:10.2
[    1.221019] usb usb4: configuration #1 chosen from 1 choice
[    1.238060] hub 4-0:1.0: USB hub found
[    1.254944] hub 4-0:1.0: 2 ports detected
[    1.271937] uhci_hcd 0000:00:10.3: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.289039] uhci_hcd 0000:00:10.3: UHCI Host Controller
[    1.306039] uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
[    1.323221] uhci_hcd 0000:00:10.3: irq 21, io base 0x0000e400
[    1.340347] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.357537] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.374698] usb usb5: Product: UHCI Host Controller
[    1.391821] usb usb5: Manufacturer: Linux 2.6.31-rc2-faf80-wusb54gc uhci_hcd
[    1.409073] usb usb5: SerialNumber: 0000:00:10.3
[    1.426342] usb usb5: configuration #1 chosen from 1 choice
[    1.443583] hub 5-0:1.0: USB hub found
[    1.460603] hub 5-0:1.0: 2 ports detected
[    1.477863] usbcore: registered new interface driver cdc_acm
[    1.494954] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[    1.512289] Initializing USB Mass Storage driver...
[    1.529687] usbcore: registered new interface driver usb-storage
[    1.547026] USB Mass Storage support registered.
[    1.564410] usbcore: registered new interface driver usbserial
[    1.581763] USB Serial support registered for generic
[    1.599156] usbcore: registered new interface driver usbserial_generic
[    1.616639] usbserial: USB Serial Driver core
[    1.634239] USB Serial support registered for GSM modem (1-port)
[    1.651931] usbcore: registered new interface driver option
[    1.669471] option: v0.7.2:USB Driver for GSM modems
[    1.687172] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.705055] Platform driver 'i8042' needs updating - please use dev_pm_ops
[    1.723654] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.741505] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.759737] mice: PS/2 mouse device common for all mice
[    1.778423] rtc_cmos 00:02: RTC can wake from S4
[    1.796276] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.813730] rtc0: alarms up to one year, y3k, 114 bytes nvram
[    1.831300] i2c /dev entries driver
[    1.849891] Linux video capture interface: v2.00
[    1.867895] bttv: driver version 0.9.18 loaded
[    1.885276] bttv: using 8 buffers with 2080k (520 pages) each for capture
[    1.903037] bttv: Bt8xx card found (0).
[    1.920528] bttv 0000:00:0d.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.938271] bttv0: Bt878 (rev 17) at 0000:00:0d.0, irq: 18, latency: 64, mmio: 0xefe00000
[    1.956193] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[    1.974131] IRQ 18/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
[    1.992116] bttv0: gpio: en=00000000, out=00000000 in=00d4dfe0 [init]
[    1.992726] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    2.015433] tveeprom 1-0050: Huh, no eeprom present (err=-6)?
[    2.033667] bttv0: tuner type unset
[    2.052066] bttv0: registered device video0
[    2.070597] bttv0: registered device vbi0
[    2.089207] EDAC MC: Ver: 2.1.0 Jul  8 2009
[    2.107397] EDAC amd64_edac:  Ver: 3.2.0 Jul  8 2009
[    2.125358] EDAC amd64: This node reports that Memory ECC is currently disabled.
[    2.143489] EDAC amd64: bit 0x400000 in register F3x44 of the MISC_CONTROL device (0000:00:18.3) should be enabled
[    2.162068] EDAC amd64: WARNING: ECC is NOT currently enabled by the BIOS. Module will NOT be loaded.
[    2.162070]     Either Enable ECC in the BIOS, or use the 'ecc_enable_override' parameter.
[    2.162072]     Might be a BIOS bug, if BIOS says ECC is enabled
[    2.162073]     Use of the override can cause unknown side effects.
[    2.236787] amd64_edac: probe of 0000:00:18.2 failed with error -22
[    2.255670] cpuidle: using governor ladder
[    2.274293] cpuidle: using governor menu
[    2.295058] usbcore: registered new interface driver usbhid
[    2.313744] usbhid: v2.6:USB HID core driver
[    2.332571] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    2.354150] VIA 82xx Audio 0000:00:11.5: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.373556] VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
[    2.374105] ata3.00: ATAPI: HL-DT-ST DVDRAM GSA-4163B, A102, max UDMA/33
[    2.414748] ata3.00: configured for UDMA/33
[    2.447433] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.536458] Switched to high resolution mode on CPU 0
[    2.554211] ata1.00: ATA-6: WDC WD1600JD-00HBB0, 08.02D08, max UDMA/133
[    2.573250] ata1.00: 312581808 sectors, multi 16: LBA48 
[    2.592193] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    2.612853] ALSA device list:
[    2.631878]   #0: VIA 8237 with ALC850 at 0xe800, irq 22
[    2.651318] oprofile: using NMI interrupt.
[    2.670447] Netfilter messages via NETLINK v0.30.
[    2.689509] nf_conntrack version 0.5.0 (8189 buckets, 32756 max)
[    2.709815] ctnetlink v0.93: registering with nfnetlink.
[    2.730775] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.749660] TCP cubic registered
[    2.768261] Initializing XFRM netlink socket
[    2.786859] NET: Registered protocol family 17
[    2.805446] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3200+ processors (1 cpu cores) (version 2.20.00)
[    2.824784] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x6
[    2.843710] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x8
[    2.862391] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[    2.881289] powernow-k8: ph2 null fid transition 0xc
[    2.899864] ata1.00: configured for UDMA/133
[    2.929681] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JD-00H 08.0 PQ: 0 ANSI: 5
[    2.949344] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    2.967879] sd 0:0:0:0: [sda] Write Protect is off
[    2.986366] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.986414] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.005797]  sda:
[    3.007159] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.044570]  sda1 sda2 sda3 sda4 <
[    3.047340] usb 1-3: New USB device found, idVendor=1737, idProduct=0077
[    3.084711] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.103672]  sda5
[    3.103867] usb 1-3: Product: 802.11 g WLAN
[    3.141256]  sda6
[    3.141454] usb 1-3: Manufacturer: Ralink
[    3.178284]  sda7
[    3.178488] usb 1-3: SerialNumber: 1.0
[    3.214352]  sda8 >
[    3.232742] usb 1-3: configuration #1 chosen from 1 choice
[    3.250350] ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
[    3.281593] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.302865] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4163B A102 PQ: 0 ANSI: 5
[    3.333451] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.351705] Uniform CD-ROM driver Revision: 3.20
[    3.370483] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    3.370776] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    3.429458] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input4
[    3.559542] ata4.00: HPA detected: current 488395055, native 488397168
[    3.578054] ata4.00: ATA-7: Hitachi HDT725025VLAT80, V5DOA42A, max UDMA/133
[    3.596445] ata4.00: 488395055 sectors, multi 16: LBA48 
[    3.614560] ata4.00: limited to UDMA/33 due to 40-wire cable
[    3.638414] ata4.00: configured for UDMA/33
[    3.667128] scsi 3:0:0:0: Direct-Access     ATA      Hitachi HDT72502 V5DO PQ: 0 ANSI: 5
[    3.685820] sd 3:0:0:0: [sdb] 488395055 512-byte logical blocks: (250 GB/232 GiB)
[    3.704148] sd 3:0:0:0: [sdb] Write Protect is off
[    3.722404] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.722454] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.741369]  sdb:
[    3.741853] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    3.778522]  sdb1
[    3.797284] sd 3:0:0:0: [sdb] Attached SCSI disk
[    3.832892] registered taskstats version 1
[    3.851227] rtc_cmos 00:02: setting system clock to 2009-07-09 15:31:42 UTC (1247153502)
[    3.879635] kjournald starting.  Commit interval 5 seconds
[    3.898220] EXT3-fs: mounted filesystem with writeback data mode.
[    3.916688] VFS: Mounted root (ext3 filesystem) readonly on device 8:5.
[    3.935116] Freeing unused kernel memory: 328k freed
[    3.953557] Write protecting the kernel read-only data: 6296k
[    5.913056] udev: starting version 141
[    8.646594] EXT3 FS on sda5, internal journal
[   10.135523] EXT4-fs (sda1): barriers enabled
[   10.155580] kjournald2 starting: pid 2562, dev sda1:8, commit interval 5 seconds
[   10.174773] EXT4-fs (sda1): internal journal on sda1:8
[   10.193454] EXT4-fs (sda1): delayed allocation enabled
[   10.212137] EXT4-fs: mballoc enabled
[   10.230484] EXT4-fs (sda1): mounted filesystem with ordered data mode
[   10.262765] kjournald starting.  Commit interval 5 seconds
[   10.281719] EXT3 FS on sda6, internal journal
[   10.299883] EXT3-fs: mounted filesystem with writeback data mode.
[   10.327097] kjournald starting.  Commit interval 5 seconds
[   10.345288] EXT3 FS on sda7, internal journal
[   10.363026] EXT3-fs: mounted filesystem with writeback data mode.
[   10.392393] kjournald starting.  Commit interval 5 seconds
[   10.410580] EXT3 FS on sda8, internal journal
[   10.428427] EXT3-fs: mounted filesystem with writeback data mode.
[   10.475539] kjournald starting.  Commit interval 5 seconds
[   10.493273] EXT3-fs: mounted filesystem with writeback data mode.
[   10.543031] EXT4-fs (sda3): barriers enabled
[   10.570812] kjournald2 starting: pid 2567, dev sda3:8, commit interval 5 seconds
[   10.588878] EXT4-fs (sda3): internal journal on sda3:8
[   10.606603] EXT4-fs (sda3): delayed allocation enabled
[   10.624256] EXT4-fs: file extents enabled
[   10.642779] EXT4-fs: mballoc enabled
[   10.660236] EXT4-fs (sda3): mounted filesystem with ordered data mode
[   10.712931] Adding 1052248k swap on /dev/sda2.  Priority:-1 extents:1 across:1052248k 
[   20.857452] skge eth1: enabling interface
[   31.885657] Marking TSC unstable due to cpufreq changes
[   32.154027] Clocksource tsc unstable (delta = -134548653 ns)
[  131.399129] PM: Syncing filesystems ... done.
[  131.415352] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  131.431367] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  131.431630] Suspending console(s) (use no_console_suspend to debug)
[  131.435053] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
[  131.435480] sd 3:0:0:0: [sdb] Stopping disk
[  131.833140] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  131.835515] sd 0:0:0:0: [sda] Stopping disk
[  132.898585] VIA 82xx Audio 0000:00:11.5: PCI INT C disabled
[  132.909110] ehci_hcd 0000:00:10.4: PCI INT C disabled
[  132.909230] uhci_hcd 0000:00:10.3: PCI INT B disabled
[  132.909250] uhci_hcd 0000:00:10.2: PCI INT B disabled
[  132.909269] uhci_hcd 0000:00:10.1: PCI INT A disabled
[  132.909288] uhci_hcd 0000:00:10.0: PCI INT A disabled
[  132.909576] pata_via 0000:00:0f.1: PCI INT A disabled
[  132.909730] sata_via 0000:00:0f.0: PCI INT B disabled
[  132.920276] ACPI handle has no context!
[  132.931084] ne2k-pci 0000:00:0c.0: PCI INT A disabled
[  132.931169] skge eth1: disabling interface
[  132.934060] skge 0000:00:0a.0: PME# disabled
[  132.957201] ehci_hcd 0000:00:10.4: PME# disabled
[  132.968110] uhci_hcd 0000:00:10.3: PME# disabled
[  132.979108] uhci_hcd 0000:00:10.2: PME# disabled
[  132.990109] uhci_hcd 0000:00:10.1: PME# disabled
[  133.001108] uhci_hcd 0000:00:10.0: PME# disabled
[  133.012588] ACPI: Preparing to enter system sleep state S3
[  133.014297] Extended CMOS year: 2000
[  133.014802] ------------[ cut here ]------------
[  133.014814] WARNING: at drivers/base/sys.c:411 sysdev_suspend+0xd3/0x27b()
[  133.014819] Hardware name: To Be Filled By O.E.M.
[  133.014828] Interrupts enabled after cpufreq_suspend+0x0/0xfd
[  133.014832] Modules linked in:
[  133.014840] Pid: 6569, comm: s2ram Not tainted 2.6.31-rc2-faf80-wusb54gc #139
[  133.014845] Call Trace:
[  133.014853]  [<ffffffff8126960a>] ? sysdev_suspend+0xd3/0x27b
[  133.014864]  [<ffffffff810388a9>] warn_slowpath_common+0x77/0xa4
[  133.014873]  [<ffffffff8103894b>] warn_slowpath_fmt+0x64/0x66
[  133.014883]  [<ffffffff8101ac71>] ? query_values_on_cpu+0x0/0x19
[  133.014892]  [<ffffffff813273bc>] ? cpufreq_suspend+0x0/0xfd
[  133.014900]  [<ffffffff811e6d35>] ? kobject_put+0x47/0x4b
[  133.014908]  [<ffffffff813269fd>] ? cpufreq_cpu_put+0x1f/0x21
[  133.014917]  [<ffffffff813274ac>] ? cpufreq_suspend+0xf0/0xfd
[  133.014926]  [<ffffffff8105aeda>] ? trace_hardirqs_off+0xd/0xf
[  133.014934]  [<ffffffff8126960a>] sysdev_suspend+0xd3/0x27b
[  133.014944]  [<ffffffff81068fd8>] suspend_devices_and_enter+0xca/0x14d
[  133.014952]  [<ffffffff81069114>] enter_state+0xb9/0xec
[  133.014959]  [<ffffffff81068923>] state_store+0xb7/0xd7
[  133.014967]  [<ffffffff811e6b4b>] kobj_attr_store+0x17/0x19
[  133.014976]  [<ffffffff811094b1>] sysfs_write_file+0xe4/0x119
[  133.014985]  [<ffffffff810b9f57>] vfs_write+0xac/0x164
[  133.014991]  [<ffffffff810ba0d3>] sys_write+0x47/0x6e
[  133.015000]  [<ffffffff8100aee8>] system_call_fastpath+0x16/0x1b
[  133.015006] ---[ end trace 470f36a1cfb444d7 ]---
[  133.015006] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[  133.015006] Back to C!
[  133.015006] ------------[ cut here ]------------
[  133.015006] WARNING: at drivers/base/sys.c:475 sysdev_resume+0x37/0xa6()
[  133.015006] Hardware name: To Be Filled By O.E.M.
[  133.015006] Interrupts enabled while resuming system devices
[  133.015006] Modules linked in:
[  133.015006] Pid: 6569, comm: s2ram Tainted: G        W  2.6.31-rc2-faf80-wusb54gc #139
[  133.015006] Call Trace:
[  133.015006]  [<ffffffff812694c8>] ? sysdev_resume+0x37/0xa6
[  133.015006]  [<ffffffff810388a9>] warn_slowpath_common+0x77/0xa4
[  133.015006]  [<ffffffff8103894b>] warn_slowpath_fmt+0x64/0x66
[  133.015006]  [<ffffffff8105bcad>] ? mark_held_locks+0x4d/0x6b
[  133.015006]  [<ffffffff812158de>] ? acpi_suspend_enter+0xc3/0xef
[  133.015006]  [<ffffffff8105bf48>] ? trace_hardirqs_on_caller+0x121/0x14b
[  133.015006]  [<ffffffff8105bf7f>] ? trace_hardirqs_on+0xd/0xf
[  133.015006]  [<ffffffff812694c8>] sysdev_resume+0x37/0xa6
[  133.015006]  [<ffffffff81068fee>] suspend_devices_and_enter+0xe0/0x14d
[  133.015006]  [<ffffffff81069114>] enter_state+0xb9/0xec
[  133.015006]  [<ffffffff81068923>] state_store+0xb7/0xd7
[  133.015006]  [<ffffffff811e6b4b>] kobj_attr_store+0x17/0x19
[  133.015006]  [<ffffffff811094b1>] sysfs_write_file+0xe4/0x119
[  133.015006]  [<ffffffff810b9f57>] vfs_write+0xac/0x164
[  133.015006]  [<ffffffff810ba0d3>] sys_write+0x47/0x6e
[  133.015006]  [<ffffffff8100aee8>] system_call_fastpath+0x16/0x1b
[  133.015006] ---[ end trace 470f36a1cfb444d8 ]---
[  133.015006] ------------[ cut here ]------------
[  133.015006] WARNING: at drivers/base/sys.c:353 __sysdev_resume+0x4f/0xc0()
[  133.015006] Hardware name: To Be Filled By O.E.M.
[  133.015006] Interrupts enabled after (null)
[  133.015006] Modules linked in:
[  133.015006] Pid: 6569, comm: s2ram Tainted: G        W  2.6.31-rc2-faf80-wusb54gc #139
[  133.015006] Call Trace:
[  133.015006]  [<ffffffff81269420>] ? __sysdev_resume+0x4f/0xc0
[  133.015006]  [<ffffffff810388a9>] warn_slowpath_common+0x77/0xa4
[  133.015006]  [<ffffffff8103894b>] warn_slowpath_fmt+0x64/0x66
[  133.015006]  [<ffffffff8103894b>] ? warn_slowpath_fmt+0x64/0x66
[  133.015006]  [<ffffffff8105bcad>] ? mark_held_locks+0x4d/0x6b
[  133.015006]  [<ffffffff812158de>] ? acpi_suspend_enter+0xc3/0xef
[  133.015006]  [<ffffffff81269420>] __sysdev_resume+0x4f/0xc0
[  133.015006]  [<ffffffff812694f6>] sysdev_resume+0x65/0xa6
[  133.015006]  [<ffffffff81068fee>] suspend_devices_and_enter+0xe0/0x14d
[  133.015006]  [<ffffffff81069114>] enter_state+0xb9/0xec
[  133.015006]  [<ffffffff81068923>] state_store+0xb7/0xd7
[  133.015006]  [<ffffffff811e6b4b>] kobj_attr_store+0x17/0x19
[  133.015006]  [<ffffffff811094b1>] sysfs_write_file+0xe4/0x119
[  133.015006]  [<ffffffff810b9f57>] vfs_write+0xac/0x164
[  133.015006]  [<ffffffff810ba0d3>] sys_write+0x47/0x6e
[  133.015006]  [<ffffffff8100aee8>] system_call_fastpath+0x16/0x1b
[  133.015006] ---[ end trace 470f36a1cfb444d9 ]---
[  133.015006] ------------[ cut here ]------------
[  133.015006] WARNING: at drivers/base/sys.c:360 __sysdev_resume+0xa0/0xc0()
[  133.015006] Hardware name: To Be Filled By O.E.M.
[  133.015006] Interrupts enabled after cpufreq_resume+0x0/0x105
[  133.015006] Modules linked in:
[  133.015006] Pid: 6569, comm: s2ram Tainted: G        W  2.6.31-rc2-faf80-wusb54gc #139
[  133.015006] Call Trace:
[  133.015006]  [<ffffffff81269471>] ? __sysdev_resume+0xa0/0xc0
[  133.015006]  [<ffffffff810388a9>] warn_slowpath_common+0x77/0xa4
[  133.015006]  [<ffffffff8103894b>] warn_slowpath_fmt+0x64/0x66
[  133.015006]  [<ffffffff813272b7>] ? cpufreq_resume+0x0/0x105
[  133.015006]  [<ffffffff8103096b>] ? finish_task_switch+0x0/0xae
[  133.015006]  [<ffffffff811e6d35>] ? kobject_put+0x47/0x4b
[  133.015006]  [<ffffffff813269fd>] ? cpufreq_cpu_put+0x1f/0x21
[  133.015006]  [<ffffffff813273af>] ? cpufreq_resume+0xf8/0x105
[  133.015006]  [<ffffffff81269471>] __sysdev_resume+0xa0/0xc0
[  133.015006]  [<ffffffff812694f6>] sysdev_resume+0x65/0xa6
[  133.015006]  [<ffffffff81068fee>] suspend_devices_and_enter+0xe0/0x14d
[  133.015006]  [<ffffffff81069114>] enter_state+0xb9/0xec
[  133.015006]  [<ffffffff81068923>] state_store+0xb7/0xd7
[  133.015006]  [<ffffffff811e6b4b>] kobj_attr_store+0x17/0x19
[  133.015006]  [<ffffffff811094b1>] sysfs_write_file+0xe4/0x119
[  133.015006]  [<ffffffff810b9f57>] vfs_write+0xac/0x164
[  133.015006]  [<ffffffff810ba0d3>] sys_write+0x47/0x6e
[  133.015006]  [<ffffffff8100aee8>] system_call_fastpath+0x16/0x1b
[  133.015006] ---[ end trace 470f36a1cfb444da ]---
[  133.015006] Extended CMOS year: 2000
[  133.015006] ------------[ cut here ]------------
[  133.015006] WARNING: at kernel/hrtimer.c:675 hres_timers_resume+0x2e/0x41()
[  133.015006] Hardware name: To Be Filled By O.E.M.
[  133.015006] hres_timers_resume() called with IRQs enabled!
[  133.015006] Modules linked in:
[  133.015006] Pid: 6569, comm: s2ram Tainted: G        W  2.6.31-rc2-faf80-wusb54gc #139
[  133.015006] Call Trace:
[  133.015006]  [<ffffffff81050b1e>] ? hres_timers_resume+0x2e/0x41
[  133.015006]  [<ffffffff810388a9>] warn_slowpath_common+0x77/0xa4
[  133.015006]  [<ffffffff8103894b>] warn_slowpath_fmt+0x64/0x66
[  133.015006]  [<ffffffff8103d6f7>] ? irq_exit+0x7e/0x80
[  133.015006]  [<ffffffff8100b93e>] ? restore_args+0x0/0x30
[  133.015006]  [<ffffffff810572e0>] ? clockevents_notify+0x75/0x7a
[  133.015006]  [<ffffffff814328b3>] ? _spin_unlock+0x30/0x49
[  133.015006]  [<ffffffff81050af5>] ? hres_timers_resume+0x5/0x41
[  133.015006]  [<ffffffff81050b1e>] hres_timers_resume+0x2e/0x41
[  133.015006]  [<ffffffff810547f1>] timekeeping_resume+0x114/0x11b
[  133.015006]  [<ffffffff812693f1>] __sysdev_resume+0x20/0xc0
[  133.015006]  [<ffffffff812694f6>] sysdev_resume+0x65/0xa6
[  133.015006]  [<ffffffff81068fee>] suspend_devices_and_enter+0xe0/0x14d
[  133.015006]  [<ffffffff81069114>] enter_state+0xb9/0xec
[  133.015006]  [<ffffffff81068923>] state_store+0xb7/0xd7
[  133.015006]  [<ffffffff811e6b4b>] kobj_attr_store+0x17/0x19
[  133.015006]  [<ffffffff811094b1>] sysfs_write_file+0xe4/0x119
[  133.015006]  [<ffffffff810b9f57>] vfs_write+0xac/0x164
[  133.015006]  [<ffffffff810ba0d3>] sys_write+0x47/0x6e
[  133.015006]  [<ffffffff8100aee8>] system_call_fastpath+0x16/0x1b
[  133.015006] ---[ end trace 470f36a1cfb444db ]---
[  133.015006] 
[  133.015006] =================================
[  133.015006] [ INFO: inconsistent lock state ]
[  133.015006] 2.6.31-rc2-faf80-wusb54gc #139
[  133.015006] ---------------------------------
[  133.015006] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[  133.015006] s2ram/6569 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  133.015006]  (&cpu_base->lock){?.-...}, at: [<ffffffff8105042a>] retrigger_next_event+0x5b/0xae
[  133.015006] {IN-HARDIRQ-W} state was registered at:
[  133.015006]   [<ffffffff8105d296>] __lock_acquire+0x6d1/0x1672
[  133.015006]   [<ffffffff8105e323>] lock_acquire+0xec/0x10e
[  133.015006]   [<ffffffff814329f2>] _spin_lock+0x36/0x43
[  133.015006]   [<ffffffff8105038c>] hrtimer_run_queues+0xd7/0x11a
[  133.015006]   [<ffffffff8104260d>] run_local_timers+0x9/0x1a
[  133.015006]   [<ffffffff8104264c>] update_process_times+0x2e/0x5e
[  133.015006]   [<ffffffff810579b7>] tick_periodic+0x61/0x6d
[  133.015006]   [<ffffffff810579e2>] tick_handle_periodic+0x1f/0x6d
[  133.015006]   [<ffffffff8101e2f8>] smp_apic_timer_interrupt+0x77/0x87
[  133.015006]   [<ffffffff8100ba63>] apic_timer_interrupt+0x13/0x20
[  133.015006]   [<ffffffffffffffff>] 0xffffffffffffffff
[  133.015006] irq event stamp: 39201
[  133.015006] hardirqs last  enabled at (39201): [<ffffffff8100b93e>] restore_args+0x0/0x30
[  133.015006] hardirqs last disabled at (39200): [<ffffffff8100ad65>] save_args+0x65/0x70
[  133.015006] softirqs last  enabled at (38952): [<ffffffff8103ddb7>] __do_softirq+0x1e0/0x1ef
[  133.015006] softirqs last disabled at (38947): [<ffffffff8100bf2a>] call_softirq+0x1a/0x24
[  133.015006] 
[  133.015006] other info that might help us debug this:
[  133.015006] 2 locks held by s2ram/6569:
[  133.015006]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff81109405>] sysfs_write_file+0x38/0x119
[  133.015006]  #1:  (pm_mutex){+.+.+.}, at: [<ffffffff81069088>] enter_state+0x2d/0xec
[  133.015006] 
[  133.015006] stack backtrace:
[  133.015006] Pid: 6569, comm: s2ram Tainted: G        W  2.6.31-rc2-faf80-wusb54gc #139
[  133.015006] Call Trace:
[  133.015006]  [<ffffffff8105b728>] print_usage_bug+0x1b4/0x1c5
[  133.015006]  [<ffffffff8105c37b>] ? check_usage_backwards+0x0/0x9a
[  133.015006]  [<ffffffff8105ba22>] mark_lock+0x2e9/0x527
[  133.015006]  [<ffffffff8100aee8>] ? system_call_fastpath+0x16/0x1b
[  133.015006]  [<ffffffff8105d32f>] __lock_acquire+0x76a/0x1672
[  133.015006]  [<ffffffff81050b1e>] ? hres_timers_resume+0x2e/0x41
[  133.015006]  [<ffffffff81050b1e>] ? hres_timers_resume+0x2e/0x41
[  133.015006]  [<ffffffff810388cd>] ? warn_slowpath_common+0x9b/0xa4
[  133.015006]  [<ffffffff8105e323>] lock_acquire+0xec/0x10e
[  133.015006]  [<ffffffff8105042a>] ? retrigger_next_event+0x5b/0xae
[  133.015006]  [<ffffffff814329f2>] _spin_lock+0x36/0x43
[  133.015006]  [<ffffffff8105042a>] ? retrigger_next_event+0x5b/0xae
[  133.015006]  [<ffffffff8105042a>] retrigger_next_event+0x5b/0xae
[  133.015006]  [<ffffffff81050b2f>] hres_timers_resume+0x3f/0x41
[  133.015006]  [<ffffffff810547f1>] timekeeping_resume+0x114/0x11b
[  133.015006]  [<ffffffff812693f1>] __sysdev_resume+0x20/0xc0
[  133.015006]  [<ffffffff812694f6>] sysdev_resume+0x65/0xa6
[  133.015006]  [<ffffffff81068fee>] suspend_devices_and_enter+0xe0/0x14d
[  133.015006]  [<ffffffff81069114>] enter_state+0xb9/0xec
[  133.015006]  [<ffffffff81068923>] state_store+0xb7/0xd7
[  133.015006]  [<ffffffff811e6b4b>] kobj_attr_store+0x17/0x19
[  133.015006]  [<ffffffff811094b1>] sysfs_write_file+0xe4/0x119
[  133.015006]  [<ffffffff810b9f57>] vfs_write+0xac/0x164
[  133.015006]  [<ffffffff810ba0d3>] sys_write+0x47/0x6e
[  133.015006]  [<ffffffff8100aee8>] system_call_fastpath+0x16/0x1b
[  133.015021] ACPI: Waking up from system sleep state S3
[  133.016506] uhci_hcd 0000:00:10.0: restoring config space at offset 0x1 (was 0x2100017, writing 0x2100013)
[  133.016527] uhci_hcd 0000:00:10.0: PME# disabled
[  133.016564] uhci_hcd 0000:00:10.1: restoring config space at offset 0x1 (was 0x2100017, writing 0x2100013)
[  133.016584] uhci_hcd 0000:00:10.1: PME# disabled
[  133.016620] uhci_hcd 0000:00:10.2: restoring config space at offset 0x1 (was 0x2100017, writing 0x2100013)
[  133.016639] uhci_hcd 0000:00:10.2: PME# disabled
[  133.016676] uhci_hcd 0000:00:10.3: restoring config space at offset 0x1 (was 0x2100017, writing 0x2100013)
[  133.016695] uhci_hcd 0000:00:10.3: PME# disabled
[  133.016729] ehci_hcd 0000:00:10.4: restoring config space at offset 0x3 (was 0x804008, writing 0x804010)
[  133.016739] ehci_hcd 0000:00:10.4: restoring config space at offset 0x1 (was 0x2100017, writing 0x2100013)
[  133.016759] ehci_hcd 0000:00:10.4: PME# disabled
[  133.016808] pci 0000:00:11.0: Enabled onboard AC97/MC97 devices
[  133.016882] pci 0000:00:11.6: restoring config space at offset 0x4 (was 0x1, writing 0x1001)
[  133.017012] pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x4000)
[  133.017364] pci 0000:00:01.0: setting latency timer to 64
[  133.017385] skge 0000:00:0a.0: PME# disabled
[  133.017451] skge eth1: enabling interface
[  133.020957] ne2k-pci 0000:00:0c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  133.021051] bttv0: reset, reinitialize
[  133.021094] pci 0000:00:0d.1: PME# disabled
[  133.021145] sata_via 0000:00:0f.0: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[  133.021326] pata_via 0000:00:0f.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[  133.032642] uhci_hcd 0000:00:10.0: PME# disabled
[  133.032654] uhci_hcd 0000:00:10.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[  133.032681] usb usb2: root hub lost power or was reset
[  133.032703] uhci_hcd 0000:00:10.1: PME# disabled
[  133.032712] uhci_hcd 0000:00:10.1: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[  133.032737] usb usb3: root hub lost power or was reset
[  133.032758] uhci_hcd 0000:00:10.2: PME# disabled
[  133.032766] uhci_hcd 0000:00:10.2: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[  133.032792] usb usb4: root hub lost power or was reset
[  133.032812] uhci_hcd 0000:00:10.3: PME# disabled
[  133.032821] uhci_hcd 0000:00:10.3: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[  133.032846] usb usb5: root hub lost power or was reset
[  133.032866] ehci_hcd 0000:00:10.4: PME# disabled
[  133.032875] ehci_hcd 0000:00:10.4: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[  133.032896] pci 0000:00:11.0: PME# disabled
[  133.032951] VIA 82xx Audio 0000:00:11.5: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[  133.032962] VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
[  133.036396] pci 0000:00:11.6: PME# disabled
[  133.036417] pci 0000:01:00.0: PME# disabled
[  133.057259] sd 0:0:0:0: [sda] Starting disk
[  133.202435] ata3.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
[  133.202443] ata3.00: ACPI cmd ef/03:01:00:00:00:a0 filtered out
[  133.224328] ata3.00: configured for UDMA/33
[  135.232536] ata1.00: configured for UDMA/133
[  135.330340] sd 3:0:0:0: [sdb] Starting disk
[  136.517422] ata4.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
[  136.517429] ata4.00: ACPI cmd ef/03:01:00:00:00:a0 filtered out
[  136.517627] ata4.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
[  136.526490] ata4.00: configured for UDMA/33
[  136.535490] ata4.00: configured for UDMA/33
[  136.535497] ata4: EH complete
[  136.557436] Restarting tasks ... 
[  136.557506] usb 1-3: USB disconnect, address 2
[  136.593750] done.
[  136.660037] usb 1-3: new high speed USB device using ehci_hcd and address 3
[  136.793230] usb 1-3: New USB device found, idVendor=1737, idProduct=0077
[  136.793236] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  136.793241] usb 1-3: Product: 802.11 g WLAN
[  136.793244] usb 1-3: Manufacturer: Ralink
[  136.793246] usb 1-3: SerialNumber: 1.0
[  136.793411] usb 1-3: configuration #1 chosen from 1 choice
