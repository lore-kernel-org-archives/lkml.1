Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbZEKUl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbZEKUl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755685AbZEKUlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:41:17 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:24446 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbZEKUlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:41:13 -0400
Date: Mon, 11 May 2009 13:41:12 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: get_domain_for_dev oops 2.6.30-rc5-00096-ga4d7749 (parport_pc, dcdbas)
Message-ID: <20090511204112.GA7297@hexapodia.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm getting the following with 2.6.30-rc5-00096-ga4d7749:

[   16.433725] parport_pc 00:0a: reported by Plug and Play ACPI
[   16.433845] parport0: PC-style at 0x378 (0x778), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[   16.434699] BUG: unable to handle kernel NULL pointer dereference at 00000000000000d8
[   16.434816] IP: [<ffffffff811f9937>] get_domain_for_dev+0x57/0x6a0
[   16.434896] PGD 11892e067 PUD 118cd0067 PMD 0 
[   16.435031] Oops: 0000 [#1] SMP 
[   16.435133] last sysfs file: /sys/module/parport/initstate
[   16.435181] CPU 1 
[   16.435251] Modules linked in: parport_pc(+) parport dell_laptop dcdbas intel_agp serio_raw evdev usbhid hid ehci_hcd uhci_hcd pata_acpi ide_pci_generic
[   16.435718] Pid: 1774, comm: modprobe Not tainted 2.6.30-rc5-dmar-00096-ga4d7749 #58 Latitude E4300                  
[   16.435781] RIP: 0010:[<ffffffff811f9937>]  [<ffffffff811f9937>] get_domain_for_dev+0x57/0x6a0
[   16.435870] RSP: 0018:ffff8801184cdaf8  EFLAGS: 00010246
[   16.435916] RAX: 0000000000000000 RBX: ffff88011a6e2380 RCX: 0000000000000000
[   16.435964] RDX: 0000000000001000 RSI: 0000000000000030 RDI: ffff88011a6e2380
[   16.436012] RBP: ffff8801184cdb78 R08: 0000000000ffffff R09: ffff8801194a0000
[   16.436075] R10: 0000000000000000 R11: 00000000000000a4 R12: 0000000000001000
[   16.436123] R13: 0000000000000030 R14: ffff88011a6e2380 R15: 0000000000000000
[   16.436172] FS:  00007fbbf8a176f0(0000) GS:ffff880028038000(0000) knlGS:0000000000000000
[   16.436231] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   16.436277] CR2: 00000000000000d8 CR3: 0000000118cda000 CR4: 00000000000006e0
[   16.436324] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   16.436372] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   16.436420] Process modprobe (pid: 1774, threadinfo ffff8801184cc000, task ffff8801188fd980)
[   16.436479] Stack:
[   16.436519]  0000000000000246 ffffffff81644ec0 0000004000000000 ffffffff81644a80
[   16.436651]  ffffffff81644a80 ffff88011a6e2400 ffff8801188fd980 0000000000001000
[   16.436850]  0000000000000000 ffff88011a6e2400 ffff8801184cdbe8 ffff88011a6e2380
[   16.437005] Call Trace:
[   16.437005]  [<ffffffff811fa51e>] get_valid_domain_for_dev+0x1e/0x90
[   16.437005]  [<ffffffff811fa8b4>] __intel_map_single+0x44/0x170
[   16.437005]  [<ffffffff811faab2>] intel_alloc_coherent+0x92/0xd0
[   16.437005]  [<ffffffffa00734cd>] parport_pc_probe_port+0x8cd/0xfb0 [parport_pc]
[   16.437005]  [<ffffffffa0073d3e>] parport_pc_pnp_probe+0x18e/0x230 [parport_pc]
[   16.437005]  [<ffffffff8123ea24>] pnp_device_probe+0xa4/0x120
[   16.437005]  [<ffffffff81275541>] driver_probe_device+0xb1/0x2b0
[   16.437005]  [<ffffffff812757d3>] __driver_attach+0x93/0xa0
[   16.437005]  [<ffffffff81275740>] ? __driver_attach+0x0/0xa0
[   16.437005]  [<ffffffff81274bfb>] bus_for_each_dev+0x6b/0xa0
[   16.437005]  [<ffffffff812752ec>] driver_attach+0x1c/0x20
[   16.437005]  [<ffffffff81274375>] bus_add_driver+0x1a5/0x2e0
[   16.437005]  [<ffffffff81275aa9>] driver_register+0x79/0x160
[   16.437005]  [<ffffffff8123e7cc>] pnp_register_driver+0x1c/0x20
[   16.437005]  [<ffffffffa0050448>] parport_pc_init+0x39c/0x3b3 [parport_pc]
[   16.437005]  [<ffffffffa00500ac>] ? parport_pc_init+0x0/0x3b3 [parport_pc]
[   16.437005]  [<ffffffff8100904c>] do_one_initcall+0x3c/0x170
[   16.437005]  [<ffffffff8105ecf3>] ? __blocking_notifier_call_chain+0x63/0x80
[   16.437005]  [<ffffffff8107061d>] sys_init_module+0xad/0x200
[   16.437005]  [<ffffffff8100bf2b>] system_call_fastpath+0x16/0x1b
[   16.437005] Code: 74 22 4c 8b 60 30 4d 85 e4 74 19 4c 89 e0 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 49 8b 46 10 4c 89 f7 <48> 8b 80 d8 00 00 00 44 8b 38 e8 8a 52 ff ff 48 89 45 90 48 85 
[   16.437005] RIP  [<ffffffff811f9937>] get_domain_for_dev+0x57/0x6a0
[   16.437005]  RSP <ffff8801184cdaf8>
[   16.437005] CR2: 00000000000000d8
[   16.440745] ---[ end trace 9244fcdcb95e3383 ]---

and then a little later, another oops while loading dcdbas:

[   23.717004]  [<ffffffff811fa51e>] get_valid_domain_for_dev+0x1e/0x90
[   23.717004]  [<ffffffff811fa8b4>] __intel_map_single+0x44/0x170
[   23.717004]  [<ffffffff811faab2>] intel_alloc_coherent+0x92/0xd0
[   23.717004]  [<ffffffffa00606db>] smi_data_buf_realloc+0xcb/0x220 [dcdbas]
[   23.717004]  [<ffffffffa00608da>] smi_data_buf_size_store+0x3a/0x60 [dcdbas]
[   23.717004]  [<ffffffff81270fcb>] dev_attr_store+0x1b/0x20
[   23.717004]  [<ffffffff8113a7f5>] sysfs_write_file+0xc5/0x140
[   23.717004]  [<ffffffff810dea4b>] vfs_write+0xcb/0x190
[   23.717004]  [<ffffffff810dec00>] sys_write+0x50/0x90
[   23.717004]  [<ffffffff8100bf2b>] system_call_fastpath+0x16/0x1b

Hardware is a Dell E4300, BIOS A05, with a docking station (that
includes parport) attached.  I don't see the parport oops when booted
without the docking station, but the dcdbas oops is still present.

I've attached the complete dmesg; more debug info is available at
http://web.hexapodia.org/~adi/sysinfo/1242072617_cvpe4300_2.6.30-rc5-dmar-00096-ga4d7749/

-andy

--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: attachment; filename="dmesg.out"
Content-Transfer-Encoding: 8bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-rc5-dmar-00096-ga4d7749 (adi@cvpe4300) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #58 SMP Mon May 11 13:00:15 PDT 2009
[    0.000000] Command line: root=/dev/sda5 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
[    0.000000]  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dd04d400 (usable)
[    0.000000]  BIOS-e820: 00000000dd04d400 - 00000000dd04f400 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dd04f400 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe60000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000011c000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x11c000 max_arch_pfn = 0x100000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D7FFF write-protect
[    0.000000]   D8000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 800000000 write-back
[    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   2 base 0DDC00000 mask FFFC00000 uncachable
[    0.000000]   3 base 0DE000000 mask FFE000000 uncachable
[    0.000000]   4 base 11C000000 mask FFC000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000ddc00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] e820 update range: 000000011c000000 - 0000000120000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdd04d max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000dd04d000
[    0.000000]  0000000000 - 00dd000000 page 2M
[    0.000000]  00dd000000 - 00dd04d000 page 4k
[    0.000000] kernel direct mapping tables up to dd04d000 @ 8000-e000
[    0.000000] init_memory_mapping: 0000000100000000-000000011c000000
[    0.000000]  0100000000 - 011c000000 page 2M
[    0.000000] kernel direct mapping tables up to 11c000000 @ c000-12000
[    0.000000] RAMDISK: 37ad0000 - 37fefe0a
[    0.000000] ACPI: RSDP 00000000000fb9f0 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000dd051e00 00074 (v01 DELL    M09     27D80C12 ASL  00000061)
[    0.000000] ACPI: FACP 00000000dd051c9c 000F4 (v04 DELL    M09     27D80C12 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000dd052400 064DB (v02 INT430 SYSFexxx 00001001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000dd060c00 00040
[    0.000000] ACPI: HPET 00000000dd051f00 00038 (v01 DELL    M09     00000001 ASL  00000061)
[    0.000000] ACPI: DMAR 00000000dd060400 00120 (v01 DELL    M09     27D80C12 ASL  00000061)
[    0.000000] ACPI: APIC 00000000dd052000 00068 (v01 DELL    M09     27D80C12 ASL  00000047)
[    0.000000] ACPI: ASF! 00000000dd051c00 0006A (v32 DELL    M09     27D80C12 ASL  00000061)
[    0.000000] ACPI: MCFG 00000000dd051fc0 0003E (v16 DELL    M09     27D80C12 ASL  00000061)
[    0.000000] ACPI: TCPA 00000000dd052300 00032 (v01                 00000000 ASL  00000000)
[    0.000000] ACPI: SLIC 00000000dd05209c 00176 (v01 DELL    M09     27D80C12 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000dd051bc0 00028 (v01 DELL    M09     27D80C12 ASL  00000061)
[    0.000000] ACPI: SSDT 00000000dd050331 0066C (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 011c000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 000185c3b8]    TEXT DATA BSS ==> [0001000000 - 000185c3b8]
[    0.000000]   #3 [0037ad0000 - 0037fefe0a]          RAMDISK ==> [0037ad0000 - 0037fefe0a]
[    0.000000]   #4 [000009bc00 - 0000100000]    BIOS reserved ==> [000009bc00 - 0000100000]
[    0.000000]   #5 [000185d000 - 000185d1e0]              BRK ==> [000185d000 - 000185d1e0]
[    0.000000]   #6 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
[    0.000000]   #7 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]
[    0.000000]  [ffffe20000000000-ffffe20003ffffff] PMD -> [ffff880028200000-ffff88002c1fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0011c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000dd04d
[    0.000000]     0: 0x00100000 -> 0x0011c000
[    0.000000] On node 0 totalpages: 1019880
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 108 pages reserved
[    0.000000]   DMA zone: 3831 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 886917 pages, LIFO batch:31
[    0.000000]   Normal zone: 1568 pages used for memmap
[    0.000000]   Normal zone: 113120 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000dd04d000 - 00000000dd04e000
[    0.000000] PM: Registered nosave memory: 00000000dd04e000 - 00000000dd04f000
[    0.000000] PM: Registered nosave memory: 00000000dd04f000 - 00000000dd050000
[    0.000000] PM: Registered nosave memory: 00000000dd050000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000feda6000
[    0.000000] PM: Registered nosave memory: 00000000feda6000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffe60000
[    0.000000] PM: Registered nosave memory: 00000000ffe60000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e2000000 (gap: e0000000:18000000)
[    0.000000] NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff88002801f000, static data 72288 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1003868
[    0.000000] Kernel command line: root=/dev/sda5 ro
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:768
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2394.148 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] allocated 47185920 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Memory: 3946556k/4653056k available (4211k kernel code, 573536k absent, 132000k reserved, 2252k data, 416k init)
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.29 BogoMIPS (lpj=9576592)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20090320
[    0.012052] Setting APIC routing to flat
[    0.012488] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.053116] CPU0: Intel(R) Core(TM)2 Duo CPU     P9400  @ 2.40GHz stepping 06
[    0.056001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4787.89 BogoMIPS (lpj=9575787)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.141635] CPU1: Intel(R) Core(TM)2 Duo CPU     P9400  @ 2.40GHz stepping 06
[    0.142111] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.144040] Brought up 2 CPUs
[    0.144083] Total of 2 processors activated (9576.18 BogoMIPS).
[    0.144174] CPU0 attaching sched-domain:
[    0.144176]  domain 0: span 0-1 level MC
[    0.144178]   groups: 0 1
[    0.144182] CPU1 attaching sched-domain:
[    0.144183]  domain 0: span 0-1 level MC
[    0.144185]   groups: 1 0
[    0.144241] net_namespace: 1824 bytes
[    0.144241] Time: 13:03:17  Date: 05/11/09
[    0.144241] NET: Registered protocol family 16
[    0.144241] ACPI: bus type pci registered
[    0.144241] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.144241] PCI: MCFG area at f8000000 reserved in E820
[    0.149477] PCI: Using MMCONFIG at f8000000 - fbffffff
[    0.149523] PCI: Using configuration type 1 for base access
[    0.149578] bio: create slab <bio-0> at 0
[    0.152467] ACPI: EC: Look up EC in DSDT
[    0.152650] ACPI: BIOS _OSI(Linux) query ignored
[    0.212019] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.228215] ACPI: Interpreter enabled
[    0.228237] ACPI: (supports S0 S3 S4 S5)
[    0.232152] ACPI: Using IOAPIC for interrupt routing
[    0.340117] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930
[    0.340117] ACPI: EC: driver started in interrupt mode
[    0.340177] ACPI Warning (tbutils-0246): Incorrect checksum in table [TCPA] - F8, should be 9C [20090320]
[    0.341712] ACPI: No dock devices found.
[    0.341763] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.341826] DMAR: Forcing write-buffer flush capability
[    0.341826] pci 0000:00:02.0: reg 10 64bit mmio: [0xf6c00000-0xf6ffffff]
[    0.341826] pci 0000:00:02.0: reg 18 64bit mmio: [0xe0000000-0xefffffff]
[    0.341826] pci 0000:00:02.0: reg 20 io port: [0xef70-0xef77]
[    0.341826] pci 0000:00:02.1: reg 10 64bit mmio: [0xf6b00000-0xf6bfffff]
[    0.341826] pci 0000:00:03.0: reg 10 64bit mmio: [0xf6ad9ef0-0xf6ad9eff]
[    0.341826] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.341826] pci 0000:00:03.0: PME# disabled
[    0.341826] pci 0000:00:03.2: reg 10 io port: [0xef78-0xef7f]
[    0.341826] pci 0000:00:03.2: reg 14 io port: [0xef68-0xef6b]
[    0.341826] pci 0000:00:03.2: reg 18 io port: [0xef80-0xef87]
[    0.341826] pci 0000:00:03.2: reg 1c io port: [0xef6c-0xef6f]
[    0.341826] pci 0000:00:03.2: reg 20 io port: [0xef90-0xef9f]
[    0.341826] pci 0000:00:03.3: reg 10 io port: [0xef88-0xef8f]
[    0.341826] pci 0000:00:03.3: reg 14 32bit mmio: [0xf6ada000-0xf6adafff]
[    0.341826] pci 0000:00:19.0: reg 10 32bit mmio: [0xf6ae0000-0xf6afffff]
[    0.341826] pci 0000:00:19.0: reg 14 32bit mmio: [0xf6adb000-0xf6adbfff]
[    0.341826] pci 0000:00:19.0: reg 18 io port: [0xefe0-0xefff]
[    0.341826] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.341826] pci 0000:00:19.0: PME# disabled
[    0.341826] pci 0000:00:1a.0: reg 20 io port: [0x6f60-0x6f7f]
[    0.341826] pci 0000:00:1a.1: reg 20 io port: [0x6f80-0x6f9f]
[    0.341826] pci 0000:00:1a.2: reg 20 io port: [0x6fa0-0x6fbf]
[    0.341826] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfed1c400-0xfed1c7ff]
[    0.341826] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.341826] pci 0000:00:1a.7: PME# disabled
[    0.344066] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf6adc000-0xf6adffff]
[    0.344122] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.344172] pci 0000:00:1b.0: PME# disabled
[    0.344292] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.344341] pci 0000:00:1c.0: PME# disabled
[    0.344463] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.344512] pci 0000:00:1c.1: PME# disabled
[    0.344636] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.344685] pci 0000:00:1c.3: PME# disabled
[    0.344799] pci 0000:00:1d.0: reg 20 io port: [0x6f00-0x6f1f]
[    0.344885] pci 0000:00:1d.1: reg 20 io port: [0x6f20-0x6f3f]
[    0.344970] pci 0000:00:1d.2: reg 20 io port: [0x6f40-0x6f5f]
[    0.345058] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfed1c000-0xfed1c3ff]
[    0.345121] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.345171] pci 0000:00:1d.7: PME# disabled
[    0.345449] pci 0000:00:1f.2: reg 10 io port: [0x6e70-0x6e77]
[    0.345456] pci 0000:00:1f.2: reg 14 io port: [0x6e78-0x6e7b]
[    0.345463] pci 0000:00:1f.2: reg 18 io port: [0x6e80-0x6e87]
[    0.345470] pci 0000:00:1f.2: reg 1c io port: [0x6e88-0x6e8b]
[    0.345477] pci 0000:00:1f.2: reg 20 io port: [0x6ea0-0x6ebf]
[    0.345484] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfed1c800-0xfed1cfff]
[    0.345528] pci 0000:00:1f.2: PME# supported from D3hot
[    0.345576] pci 0000:00:1f.2: PME# disabled
[    0.345656] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf6ad9f00-0xf6ad9fff]
[    0.345673] pci 0000:00:1f.3: reg 20 io port: [0x1100-0x111f]
[    0.345870] pci 0000:0c:00.0: reg 10 64bit mmio: [0xf69fe000-0xf69fffff]
[    0.345986] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.346059] pci 0000:0c:00.0: PME# disabled
[    0.346203] pci 0000:00:1c.1: bridge 32bit mmio: [0xf6900000-0xf69fffff]
[    0.346264] pci 0000:00:1c.3: bridge io port: [0xd000-0xdfff]
[    0.346268] pci 0000:00:1c.3: bridge 32bit mmio: [0xf6600000-0xf68fffff]
[    0.346276] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf0000000-0xf01fffff]
[    0.346317] pci 0000:02:01.0: reg 10 32bit mmio: [0xf65ff800-0xf65fffff]
[    0.346372] pci 0000:02:01.0: supports D1 D2
[    0.346374] pci 0000:02:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.346423] pci 0000:02:01.0: PME# disabled
[    0.346505] pci 0000:02:01.1: reg 10 32bit mmio: [0xf65ff700-0xf65ff7ff]
[    0.346559] pci 0000:02:01.1: supports D1 D2
[    0.346561] pci 0000:02:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.346611] pci 0000:02:01.1: PME# disabled
[    0.346722] pci 0000:00:1e.0: transparent bridge
[    0.346772] pci 0000:00:1e.0: bridge 32bit mmio: [0xf6500000-0xf65fffff]
[    0.346802] pci_bus 0000:00: on NUMA node 0
[    0.346807] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.347053] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.347145] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.347208] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.347271] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.360590] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 *11)
[    0.360590] ACPI: PCI Interrupt Link [LNKB] (IRQs *5 7)
[    0.360635] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 *11)
[    0.360905] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
[    0.361232] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.361727] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.362224] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.364357] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.364861] SCSI subsystem initialized
[    0.364861] libata version 3.00 loaded.
[    0.364861] usbcore: registered new interface driver usbfs
[    0.364861] usbcore: registered new interface driver hub
[    0.364861] usbcore: registered new device driver usb
[    0.364861] PCI: Using ACPI for IRQ routing
[    0.380010] NET: Registered protocol family 8
[    0.380055] NET: Registered protocol family 20
[    0.380109] NetLabel: Initializing
[    0.380109] NetLabel:  domain hash size = 128
[    0.380109] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.380154] NetLabel:  unlabeled traffic allowed by default
[    0.380206] DMAR:Host address width 36
[    0.380206] DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed10000
[    0.380206] DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed11000
[    0.380206] DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed12000
[    0.380232] DMAR:DRHD (flags: 0x00000001)base: 0x00000000fed13000
[    0.380281] DMAR:RMRR base: 0x00000000dd7e7000 end: 0x00000000dd7fffff
[    0.380329] DMAR:RMRR base: 0x00000000ddc00000 end: 0x00000000dfffffff
[    0.380433] IOMMU 0xfed12000: using Register based invalidation
[    0.380479] IOMMU 0xfed11000: using Register based invalidation
[    0.380526] IOMMU 0xfed10000: using Register based invalidation
[    0.380572] IOMMU 0xfed13000: using Register based invalidation
[    0.380619] IOMMU: Setting identity map for device 0000:00:02.0 [0xddc00000 - 0xe0000000]
[    0.383141] IOMMU: Setting identity map for device 0000:00:02.1 [0xddc00000 - 0xe0000000]
[    0.385991] IOMMU: Setting identity map for device 0000:00:1d.0 [0xdd7e7000 - 0xdd800000]
[    0.386077] IOMMU: Setting identity map for device 0000:00:1d.1 [0xdd7e7000 - 0xdd800000]
[    0.386155] IOMMU: Setting identity map for device 0000:00:1d.2 [0xdd7e7000 - 0xdd800000]
[    0.386234] IOMMU: Setting identity map for device 0000:00:1d.7 [0xdd7e7000 - 0xdd800000]
[    0.386312] IOMMU: Setting identity map for device 0000:00:1a.0 [0xdd7e7000 - 0xdd800000]
[    0.386391] IOMMU: Setting identity map for device 0000:00:1a.1 [0xdd7e7000 - 0xdd800000]
[    0.386471] IOMMU: Setting identity map for device 0000:00:1a.2 [0xdd7e7000 - 0xdd800000]
[    0.386553] IOMMU: Setting identity map for device 0000:00:1a.7 [0xdd7e7000 - 0xdd800000]
[    0.386637] IOMMU: gfx device 0000:00:02.0 1-1 mapping
[    0.386682] IOMMU: Setting identity map for device 0000:00:02.0 [0x0 - 0x9b000]
[    0.386788] IOMMU: Setting identity map for device 0000:00:02.0 [0x100000 - 0xdd04d000]
[    0.628963] IOMMU: Setting identity map for device 0000:00:02.0 [0x100000000 - 0x11c000000]
[    0.659598] IOMMU: gfx device 0000:00:02.1 1-1 mapping
[    0.659645] IOMMU: Setting identity map for device 0000:00:02.1 [0x0 - 0x9b000]
[    0.659752] IOMMU: Setting identity map for device 0000:00:02.1 [0x100000 - 0xdd04d000]
[    0.901895] IOMMU: Setting identity map for device 0000:00:02.1 [0x100000000 - 0x11c000000]
[    0.932562] IOMMU: Prepare 0-16M unity mapping for LPC
[    0.932610] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0x1000000]
[    0.936021] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.936093] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.936211] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.944008] Switched to high resolution mode on CPU 0
[    0.946223] Switched to high resolution mode on CPU 1
[    0.960007] pnp: PnP ACPI init
[    0.960060] ACPI: bus type pnp registered
[    1.054101] pnp: PnP ACPI: found 15 devices
[    1.054146] ACPI: ACPI bus type pnp unregistered
[    1.054199] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    1.054248] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    1.054299] system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
[    1.054350] system 00:0c: ioport range 0x900-0x92f has been reserved
[    1.054398] system 00:0c: ioport range 0x931-0x933 has been reserved
[    1.054446] system 00:0c: ioport range 0x935-0x97f has been reserved
[    1.054492] system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
[    1.054540] system 00:0c: ioport range 0x1000-0x1005 has been reserved
[    1.054588] system 00:0c: ioport range 0x1008-0x100f has been reserved
[    1.054637] system 00:0d: ioport range 0xf400-0xf4fe has been reserved
[    1.054685] system 00:0d: ioport range 0x1006-0x1007 has been reserved
[    1.054733] system 00:0d: ioport range 0x100a-0x1059 could not be reserved
[    1.054781] system 00:0d: ioport range 0x1060-0x107f has been reserved
[    1.054829] system 00:0d: ioport range 0x1080-0x10bf has been reserved
[    1.054877] system 00:0d: ioport range 0x1100-0x111f has been reserved
[    1.054925] system 00:0d: ioport range 0x1010-0x102f has been reserved
[    1.054973] system 00:0d: ioport range 0x809-0x809 has been reserved
[    1.055023] system 00:0e: iomem range 0x0-0x9efff could not be reserved
[    1.055070] system 00:0e: iomem range 0x9f000-0x9ffff could not be reserved
[    1.055119] system 00:0e: iomem range 0xc0000-0xd7fff has been reserved
[    1.055166] system 00:0e: iomem range 0xe0000-0xfffff has been reserved
[    1.055214] system 00:0e: iomem range 0x100000-0xdd04d3ff could not be reserved
[    1.055272] system 00:0e: iomem range 0xdd04d400-0xddafffff could not be reserved
[    1.055330] system 00:0e: iomem range 0xddb00000-0xddbfffff has been reserved
[    1.055379] system 00:0e: iomem range 0xffe00000-0xffffffff could not be reserved
[    1.055437] system 00:0e: iomem range 0xffa00000-0xffbfffff has been reserved
[    1.055486] system 00:0e: iomem range 0xfec00000-0xfec0ffff has been reserved
[    1.055535] system 00:0e: iomem range 0xfee00000-0xfee0ffff has been reserved
[    1.055583] system 00:0e: iomem range 0xfed20000-0xfed3ffff has been reserved
[    1.055632] system 00:0e: iomem range 0xfed45000-0xfed8ffff has been reserved
[    1.055681] system 00:0e: iomem range 0xfeda0000-0xfeda3fff has been reserved
[    1.055729] system 00:0e: iomem range 0xfeda4000-0xfeda4fff has been reserved
[    1.055778] system 00:0e: iomem range 0xfeda5000-0xfeda5fff has been reserved
[    1.055827] system 00:0e: iomem range 0xfeda6000-0xfeda6fff has been reserved
[    1.055876] system 00:0e: iomem range 0xfed1c800-0xfed1cfff has been reserved
[    1.055924] system 00:0e: iomem range 0xfed18000-0xfed1bfff has been reserved
[    1.055972] system 00:0e: iomem range 0xf8000000-0xfbffffff has been reserved
[    1.061091] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
[    1.061137] pci 0000:00:1c.0:   IO window: disabled
[    1.061186] pci 0000:00:1c.0:   MEM window: disabled
[    1.061233] pci 0000:00:1c.0:   PREFETCH window: disabled
[    1.061285] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0c
[    1.061330] pci 0000:00:1c.1:   IO window: disabled
[    1.061378] pci 0000:00:1c.1:   MEM window: 0xf6900000-0xf69fffff
[    1.061428] pci 0000:00:1c.1:   PREFETCH window: disabled
[    1.061479] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:0d
[    1.061527] pci 0000:00:1c.3:   IO window: 0xd000-0xdfff
[    1.061575] pci 0000:00:1c.3:   MEM window: 0xf6600000-0xf68fffff
[    1.061624] pci 0000:00:1c.3:   PREFETCH window: 0x000000f0000000-0x000000f01fffff
[    1.061688] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[    1.061734] pci 0000:00:1e.0:   IO window: disabled
[    1.061783] pci 0000:00:1e.0:   MEM window: 0xf6500000-0xf65fffff
[    1.061831] pci 0000:00:1e.0:   PREFETCH window: disabled
[    1.061890] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.061941] pci 0000:00:1c.0: setting latency timer to 64
[    1.061948] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.061998] pci 0000:00:1c.1: setting latency timer to 64
[    1.062005] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.062055] pci 0000:00:1c.3: setting latency timer to 64
[    1.062062] pci 0000:00:1e.0: setting latency timer to 64
[    1.062066] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    1.062068] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    1.062070] pci_bus 0000:0c: resource 1 mem: [0xf6900000-0xf69fffff]
[    1.062072] pci_bus 0000:0d: resource 0 io:  [0xd000-0xdfff]
[    1.062074] pci_bus 0000:0d: resource 1 mem: [0xf6600000-0xf68fffff]
[    1.062076] pci_bus 0000:0d: resource 2 pref mem [0xf0000000-0xf01fffff]
[    1.062078] pci_bus 0000:02: resource 1 mem: [0xf6500000-0xf65fffff]
[    1.062080] pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
[    1.062082] pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffffffffffff]
[    1.062107] NET: Registered protocol family 2
[    1.108046] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.108416] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.109471] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.109814] TCP: Hash tables configured (established 262144 bind 65536)
[    1.109862] TCP reno registered
[    1.120063] NET: Registered protocol family 1
[    1.120160] Trying to unpack rootfs image as initramfs...
[    1.225810] Freeing initrd memory: 5247k freed
[    1.227710] Simple Boot Flag at 0x79 set to 0x1
[    1.228464] audit: initializing netlink socket (disabled)
[    1.228520] type=2000 audit(1242046998.228:1): initialized
[    1.235069] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.237066] VFS: Disk quotas dquot_6.5.2
[    1.237174] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.237622] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.237722] fuse init (API version 7.11)
[    1.237883] msgmni has been set to 7720
[    1.238127] alg: No test for stdrng (krng)
[    1.238178] io scheduler noop registered
[    1.238222] io scheduler anticipatory registered
[    1.238266] io scheduler deadline registered
[    1.238317] io scheduler cfq registered (default)
[    1.238406] pci 0000:00:02.0: Boot video device
[    1.238723] pcieport-driver 0000:00:1c.0: irq 28 for MSI/MSI-X
[    1.238741] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.238948] pcieport-driver 0000:00:1c.1: irq 29 for MSI/MSI-X
[    1.238964] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.239176] pcieport-driver 0000:00:1c.3: irq 30 for MSI/MSI-X
[    1.239193] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    1.239671] ACPI: AC Adapter [AC] (on-line)
[    1.240408] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    1.241684] ACPI: Lid Switch [LID]
[    1.241784] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.241847] ACPI: Power Button [PBTN]
[    1.241943] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    1.242002] ACPI: Sleep Button [SBTN]
[    1.242539] ACPI: SSDT 00000000dd05099d 00281 (v01  PmRef   BspIst 00003000 INTL 20050624)
[    1.243005] ACPI: SSDT 00000000dd050df5 005C6 (v01  PmRef   BspCst 00003001 INTL 20050624)
[    1.243502] Monitor-Mwait will be used to enter C-1 state
[    1.243521] Monitor-Mwait will be used to enter C-2 state
[    1.243540] Monitor-Mwait will be used to enter C-3 state
[    1.243546] Marking TSC unstable due to TSC halts in idle
[    1.243629] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.243824] processor ACPI_CPU:00: registered as cooling_device0
[    1.243872] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.244465] ACPI: SSDT 00000000dd050c1e 001D7 (v01  PmRef    ApIst 00003000 INTL 20050624)
[    1.244853] ACPI: SSDT 00000000dd0513bb 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    1.245641] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.245833] processor ACPI_CPU:01: registered as cooling_device1
[    1.245880] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.282446] thermal LNXTHERM:01: registered as thermal_zone0
[    1.282497] ACPI: Thermal Zone [THM] (54 C)
[    1.285325] Non-volatile memory driver v1.3
[    1.285371] Linux agpgart interface v0.103
[    1.285416] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.285604] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.286121] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.286301] serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.286453] 0000:00:03.3: ttyS1 at I/O 0xef88 (irq = 17) is a 16550A
[    1.287830] brd: module loaded
[    1.288533] loop: module loaded
[    1.288576] Uniform Multi-Platform E-IDE driver
[    1.288689] ide-gd driver 1.18
[    1.288830] Driver 'sd' needs updating - please use bus_type methods
[    1.288905] Driver 'sr' needs updating - please use bus_type methods
[    1.289078] ahci 0000:00:1f.2: version 3.0
[    1.289086] ahci 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.289175] ahci 0000:00:1f.2: irq 31 for MSI/MSI-X
[    1.289223] ahci: SSS flag set, parallel bus scan disabled
[    1.289363] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl RAID mode
[    1.289423] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
[    1.289485] ahci 0000:00:1f.2: setting latency timer to 64
[    1.292667] scsi0 : ahci
[    1.292814] scsi1 : ahci
[    1.292941] scsi2 : ahci
[    1.293146] scsi3 : ahci
[    1.293303] scsi4 : ahci
[    1.293426] scsi5 : ahci
[    1.293922] ata1: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1c900 irq 31
[    1.294048] ata2: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1c980 irq 31
[    1.294106] ata3: DUMMY
[    1.294147] ata4: DUMMY
[    1.294204] ata5: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1cb00 irq 31
[    1.294313] ata6: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1cb80 irq 31
[    1.294513] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[    1.294561] Copyright (c) 1999-2006 Intel Corporation.
[    1.294673] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[    1.294721] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    1.294793] e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.294844] e1000e 0000:00:19.0: setting latency timer to 64
[    1.294944] e1000e 0000:00:19.0: irq 32 for MSI/MSI-X
[    1.316397] ACPI: Battery Slot [BAT0] (battery present)
[    1.316524] ACPI: Battery Slot [BAT1] (battery absent)
[    1.383416] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:21:70:e6:a4:82
[    1.383475] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.383547] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 3002ff-0ff
[    1.383634] Fusion MPT base driver 3.04.07
[    1.383679] Copyright (c) 1999-2008 LSI Corporation
[    1.383727] Fusion MPT SPI Host driver 3.04.07
[    1.383818] ohci1394 0000:02:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.442033] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[f65ff800-f65fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    1.446269] usbcore: registered new interface driver libusual
[    1.446390] usbcore: registered new interface driver usbserial
[    1.446467] USB Serial support registered for generic
[    1.446544] usbcore: registered new interface driver usbserial_generic
[    1.446592] usbserial: USB Serial Driver core
[    1.446718] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.447064] i8042.c: Warning: Keylock active.
[    1.450885] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.450932] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.451084] mice: PS/2 mouse device common for all mice
[    1.451179] rtc_cmos 00:03: RTC can wake from S4
[    1.451277] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.451351] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.451644] cpuidle: using governor ladder
[    1.452100] cpuidle: using governor menu
[    1.452170] sdhci: Secure Digital Host Controller Interface driver
[    1.452217] sdhci: Copyright(c) Pierre Ossman
[    1.452272] sdhci-pci 0000:02:01.1: SDHCI controller found [1180:0822] (rev 22)
[    1.452337] sdhci-pci 0000:02:01.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    1.454457] mmc0: SDHCI controller on PCI [0000:02:01.1] using DMA
[    1.454791] TCP cubic registered
[    1.454951] PM: Resume from disk failed.
[    1.454963] registered taskstats version 1
[    1.455104]   Magic number: 9:709:78
[    1.455219] rtc_cmos 00:03: setting system clock to 2009-05-11 13:03:19 UTC (1242046999)
[    1.455283] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.455329] EDD information not available.
[    1.474596] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.776233] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.807456] ata1.00: ATA-8: ST9250421ASG, DE16, max UDMA/133
[    1.807506] ata1.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.851802] ata1.00: configured for UDMA/133
[    1.864328] scsi 0:0:0:0: Direct-Access     ATA      ST9250421ASG     DE16 PQ: 0 ANSI: 5
[    1.864709] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.864748] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
[    1.864759] sd 0:0:0:0: [sda] Write Protect is off
[    1.864761] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.864778] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.864842]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
[    1.929115] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.000223] Clocksource tsc unstable (delta = -317373832 ns)
[    2.717091] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[324fc000138975e1]
[    2.752228] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.768842] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-U633A, D200, max UDMA/100, ATAPI AN
[    2.768913] ata2.00: applying bridge limits
[    2.784463] ata2.00: configured for UDMA/100
[    2.802406] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-U633A D200 PQ: 0 ANSI: 5
[    2.809423] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.809485] Uniform CD-ROM driver Revision: 3.20
[    2.809784] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.809893] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    3.128237] ata5: SATA link down (SStatus 0 SControl 300)
[    3.464236] ata6: SATA link down (SStatus 0 SControl 300)
[    3.480233] Freeing unused kernel memory: 416k freed
[    3.480405] Write protecting the kernel read-only data: 6056k
[    3.593461] pata_acpi 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.593542] pata_acpi 0000:00:03.2: setting latency timer to 64
[    3.593552] pata_acpi 0000:00:03.2: PCI INT C disabled
[    3.596965] uhci_hcd: USB Universal Host Controller Interface driver
[    3.597080] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.597134] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.597137] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.597241] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    3.597332] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f60
[    3.597457] usb usb1: configuration #1 chosen from 1 choice
[    3.597524] hub 1-0:1.0: USB hub found
[    3.597572] hub 1-0:1.0: 2 ports detected
[    3.597692] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.597742] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.597746] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.597822] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    3.597911] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f80
[    3.598021] usb usb2: configuration #1 chosen from 1 choice
[    3.598085] hub 2-0:1.0: USB hub found
[    3.598133] hub 2-0:1.0: 2 ports detected
[    3.598244] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.598295] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    3.598299] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    3.598377] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    3.598462] uhci_hcd 0000:00:1a.2: irq 22, io base 0x00006fa0
[    3.598519] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.598574] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    3.598577] usb usb3: configuration #1 chosen from 1 choice
[    3.598598] hub 3-0:1.0: USB hub found
[    3.598604] hub 3-0:1.0: 2 ports detected
[    3.598668] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.598675] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.598679] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.598713] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    3.598743] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f00
[    3.598821] usb usb4: configuration #1 chosen from 1 choice
[    3.598840] hub 4-0:1.0: USB hub found
[    3.598847] hub 4-0:1.0: 2 ports detected
[    3.598923] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.598932] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.598937] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.598972] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    3.599012] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f20
[    3.599086] usb usb5: configuration #1 chosen from 1 choice
[    3.599105] hub 5-0:1.0: USB hub found
[    3.599113] hub 5-0:1.0: 2 ports detected
[    3.599183] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.599193] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.599197] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.599228] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    3.599268] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    3.599343] usb usb6: configuration #1 chosen from 1 choice
[    3.599362] hub 6-0:1.0: USB hub found
[    3.599369] hub 6-0:1.0: 2 ports detected
[    3.600402] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.600496] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    3.600499] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.600580] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 7
[    3.604564] ehci_hcd 0000:00:1a.7: debug port 1
[    3.604613] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    3.604618] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    3.621054] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    3.621175] usb usb7: configuration #1 chosen from 1 choice
[    3.621242] hub 7-0:1.0: USB hub found
[    3.621292] hub 7-0:1.0: 6 ports detected
[    3.621419] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.621481] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.621484] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.621565] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    3.625534] ehci_hcd 0000:00:1d.7: debug port 1
[    3.625583] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    3.625589] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    3.641013] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.641119] usb usb8: configuration #1 chosen from 1 choice
[    3.641187] hub 8-0:1.0: USB hub found
[    3.641235] hub 8-0:1.0: 6 ports detected
[    4.045061] usb 7-3: new high speed USB device using ehci_hcd and address 3
[    4.180567] usb 7-3: configuration #1 chosen from 1 choice
[    4.180784] hub 7-3:1.0: USB hub found
[    4.180999] hub 7-3:1.0: 3 ports detected
[    4.292083] usb 7-4: new high speed USB device using ehci_hcd and address 4
[    4.425542] usb 7-4: configuration #1 chosen from 1 choice
[    4.425770] hub 7-4:1.0: USB hub found
[    4.426001] hub 7-4:1.0: 3 ports detected
[    4.648060] usb 7-6: new high speed USB device using ehci_hcd and address 6
[    4.820792] usb 7-6: configuration #1 chosen from 1 choice
[    5.060072] usb 1-1: new full speed USB device using uhci_hcd and address 2
[    5.232517] usb 1-1: configuration #1 chosen from 1 choice
[    5.234493] hub 1-1:1.0: USB hub found
[    5.236457] hub 1-1:1.0: 3 ports detected
[    5.480073] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    5.661653] usb 3-1: configuration #0 chosen from 1 choice
[    5.661706] usb 3-1: config 0 descriptor??
[    5.745468] usb 1-1.1: new full speed USB device using uhci_hcd and address 3
[    5.863520] usb 1-1.1: configuration #1 chosen from 1 choice
[    5.871585] usbcore: registered new interface driver hiddev
[    5.874700] input: HID 413c:8161 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.0/input/input4
[    5.874797] generic-usb 0003:413C:8161.0001: input,hidraw0: USB HID v1.11 Keyboard [HID 413c:8161] on usb-0000:00:1a.0-1.1/input0
[    5.874878] usbcore: registered new interface driver usbhid
[    5.874932] usbhid: v2.6:USB HID core driver
[    5.941464] usb 1-1.2: new full speed USB device using uhci_hcd and address 4
[    6.063519] usb 1-1.2: configuration #1 chosen from 1 choice
[    6.070780] input: HID 413c:8162 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input5
[    6.070878] generic-usb 0003:413C:8162.0002: input,hidraw1: USB HID v1.11 Mouse [HID 413c:8162] on usb-0000:00:1a.0-1.2/input0
[    9.156962] kjournald starting.  Commit interval 5 seconds
[    9.157024] EXT3-fs: mounted filesystem with writeback data mode.
[   16.051309] udev: starting version 141
[   16.314391] agpgart-intel 0000:00:00.0: Intel Mobile Intel® GM45 Express Chipset
[   16.316220] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[   16.327008] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[   16.333481] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   16.433725] parport_pc 00:0a: reported by Plug and Play ACPI
[   16.433845] parport0: PC-style at 0x378 (0x778), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[   16.434699] BUG: unable to handle kernel NULL pointer dereference at 00000000000000d8
[   16.434816] IP: [<ffffffff811f9937>] get_domain_for_dev+0x57/0x6a0
[   16.434896] PGD 11892e067 PUD 118cd0067 PMD 0 
[   16.435031] Oops: 0000 [#1] SMP 
[   16.435133] last sysfs file: /sys/module/parport/initstate
[   16.435181] CPU 1 
[   16.435251] Modules linked in: parport_pc(+) parport dell_laptop dcdbas intel_agp serio_raw evdev usbhid hid ehci_hcd uhci_hcd pata_acpi ide_pci_generic
[   16.435718] Pid: 1774, comm: modprobe Not tainted 2.6.30-rc5-dmar-00096-ga4d7749 #58 Latitude E4300                  
[   16.435781] RIP: 0010:[<ffffffff811f9937>]  [<ffffffff811f9937>] get_domain_for_dev+0x57/0x6a0
[   16.435870] RSP: 0018:ffff8801184cdaf8  EFLAGS: 00010246
[   16.435916] RAX: 0000000000000000 RBX: ffff88011a6e2380 RCX: 0000000000000000
[   16.435964] RDX: 0000000000001000 RSI: 0000000000000030 RDI: ffff88011a6e2380
[   16.436012] RBP: ffff8801184cdb78 R08: 0000000000ffffff R09: ffff8801194a0000
[   16.436075] R10: 0000000000000000 R11: 00000000000000a4 R12: 0000000000001000
[   16.436123] R13: 0000000000000030 R14: ffff88011a6e2380 R15: 0000000000000000
[   16.436172] FS:  00007fbbf8a176f0(0000) GS:ffff880028038000(0000) knlGS:0000000000000000
[   16.436231] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   16.436277] CR2: 00000000000000d8 CR3: 0000000118cda000 CR4: 00000000000006e0
[   16.436324] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   16.436372] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   16.436420] Process modprobe (pid: 1774, threadinfo ffff8801184cc000, task ffff8801188fd980)
[   16.436479] Stack:
[   16.436519]  0000000000000246 ffffffff81644ec0 0000004000000000 ffffffff81644a80
[   16.436651]  ffffffff81644a80 ffff88011a6e2400 ffff8801188fd980 0000000000001000
[   16.436850]  0000000000000000 ffff88011a6e2400 ffff8801184cdbe8 ffff88011a6e2380
[   16.437005] Call Trace:
[   16.437005]  [<ffffffff811fa51e>] get_valid_domain_for_dev+0x1e/0x90
[   16.437005]  [<ffffffff811fa8b4>] __intel_map_single+0x44/0x170
[   16.437005]  [<ffffffff811faab2>] intel_alloc_coherent+0x92/0xd0
[   16.437005]  [<ffffffffa00734cd>] parport_pc_probe_port+0x8cd/0xfb0 [parport_pc]
[   16.437005]  [<ffffffffa0073d3e>] parport_pc_pnp_probe+0x18e/0x230 [parport_pc]
[   16.437005]  [<ffffffff8123ea24>] pnp_device_probe+0xa4/0x120
[   16.437005]  [<ffffffff81275541>] driver_probe_device+0xb1/0x2b0
[   16.437005]  [<ffffffff812757d3>] __driver_attach+0x93/0xa0
[   16.437005]  [<ffffffff81275740>] ? __driver_attach+0x0/0xa0
[   16.437005]  [<ffffffff81274bfb>] bus_for_each_dev+0x6b/0xa0
[   16.437005]  [<ffffffff812752ec>] driver_attach+0x1c/0x20
[   16.437005]  [<ffffffff81274375>] bus_add_driver+0x1a5/0x2e0
[   16.437005]  [<ffffffff81275aa9>] driver_register+0x79/0x160
[   16.437005]  [<ffffffff8123e7cc>] pnp_register_driver+0x1c/0x20
[   16.437005]  [<ffffffffa0050448>] parport_pc_init+0x39c/0x3b3 [parport_pc]
[   16.437005]  [<ffffffffa00500ac>] ? parport_pc_init+0x0/0x3b3 [parport_pc]
[   16.437005]  [<ffffffff8100904c>] do_one_initcall+0x3c/0x170
[   16.437005]  [<ffffffff8105ecf3>] ? __blocking_notifier_call_chain+0x63/0x80
[   16.437005]  [<ffffffff8107061d>] sys_init_module+0xad/0x200
[   16.437005]  [<ffffffff8100bf2b>] system_call_fastpath+0x16/0x1b
[   16.437005] Code: 74 22 4c 8b 60 30 4d 85 e4 74 19 4c 89 e0 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 49 8b 46 10 4c 89 f7 <48> 8b 80 d8 00 00 00 44 8b 38 e8 8a 52 ff ff 48 89 45 90 48 85 
[   16.437005] RIP  [<ffffffff811f9937>] get_domain_for_dev+0x57/0x6a0
[   16.437005]  RSP <ffff8801184cdaf8>
[   16.437005] CR2: 00000000000000d8
[   16.440745] ---[ end trace 9244fcdcb95e3383 ]---
[   16.453696] ACPI: WMI: Mapper loaded
[   16.502089] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   16.549017] iTCO_vendor_support: vendor-support=0
[   16.604955] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   16.605093] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x1060)
[   16.605184] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   16.717051] cfg80211: Using static regulatory domain info
[   16.717111] cfg80211: Regulatory domain: US
[   16.717163] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   16.717778] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[   16.717827] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   16.717876] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   16.717924] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   16.717971] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   16.718020] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[   16.718073] cfg80211: Calling CRDA for country: US
[   16.792956] ppdev: user-space parallel port driver
[   16.981497] cfg80211: Regulatory domain changed to country: US
[   16.981546] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   16.981605] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[   16.981652] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[   16.981700] 	(5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   16.981748] 	(5490000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   16.981795] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[   17.160401] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input7
[   17.177062] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input8
[   17.599924] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
[   17.599987] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[   17.600146] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   17.600224] iwlagn 0000:0c:00.0: setting latency timer to 64
[   17.600351] iwlagn 0000:0c:00.0: Detected Intel Wireless WiFi Link 5300AGN REV=0x24
[   17.619488] iwlagn 0000:0c:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   17.619631] iwlagn 0000:0c:00.0: irq 33 for MSI/MSI-X
[   17.801616] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   17.975479] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   17.975596] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   18.047809] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
[   18.101256] input: HDA Intel Mic at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/input/input10
[   18.101362] input: HDA Intel Mic at Ext Right Jack as /devices/pci0000:00/0000:00:1b.0/input/input11
[   18.101463] input: HDA Intel Line Out at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/input/input12
[   18.101564] input: HDA Intel HP Out at Ext Right Jack as /devices/pci0000:00/0000:00:1b.0/input/input13
[   18.215230] lp: driver loaded but no devices found
[   18.365439] Adding 9550632k swap on /dev/sda7.  Priority:-1 extents:1 across:9550632k 
[   18.736026] EXT3 FS on sda5, internal journal
[   21.152161] NET: Registered protocol family 10
[   21.153058] lo: Disabled Privacy Extensions
[   23.716274] BUG: unable to handle kernel NULL pointer dereference at 00000000000000d8
[   23.716410] IP: [<ffffffff811f9937>] get_domain_for_dev+0x57/0x6a0
[   23.716494] PGD 114010067 PUD 119982067 PMD 0 
[   23.716628] Oops: 0000 [#2] SMP 
[   23.716727] last sysfs file: /sys/devices/platform/dcdbas/smi_data_buf_size
[   23.716776] CPU 1 
[   23.716844] Modules linked in: ipv6 acpi_cpufreq cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats pci_slot sbs sbshc sbp2 lp snd_hda_codec_intelhdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi arc4 snd_rawmidi ecb snd_seq_midi_event snd_seq iwlagn iwlcore snd_timer snd_seq_device led_class snd mac80211 soundcore ppdev snd_page_alloc cfg80211 iTCO_wdt iTCO_vendor_support psmouse pcspkr wmi parport_pc(+) parport dell_laptop dcdbas intel_agp serio_raw evdev usbhid hid ehci_hcd uhci_hcd pata_acpi ide_pci_generic
[   23.717004] Pid: 3812, comm: hald-addon-dell Tainted: G      D    2.6.30-rc5-dmar-00096-ga4d7749 #58 Latitude E4300                  
[   23.717004] RIP: 0010:[<ffffffff811f9937>]  [<ffffffff811f9937>] get_domain_for_dev+0x57/0x6a0
[   23.717004] RSP: 0018:ffff88011402dd08  EFLAGS: 00010246
[   23.717004] RAX: 0000000000000000 RBX: ffff880118500b90 RCX: 0000000000000000
[   23.717004] RDX: 0000000000001000 RSI: 0000000000000030 RDI: ffff880118500b90
[   23.717004] RBP: ffff88011402dd88 R08: 00000000ffffffff R09: ffff880114043000
[   23.717004] R10: 0000000000000000 R11: 000000000000008b R12: 0000000000001000
[   23.717004] R13: 0000000000000030 R14: ffff880118500b90 R15: 0000000000000000
[   23.717004] FS:  00007fbe88cee700(0000) GS:ffff880028038000(0000) knlGS:0000000000000000
[   23.717004] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   23.717004] CR2: 00000000000000d8 CR3: 000000011402b000 CR4: 00000000000006e0
[   23.717004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   23.717004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   23.717004] Process hald-addon-dell (pid: 3812, threadinfo ffff88011402c000, task ffff88011400acc0)
[   23.717004] Stack:
[   23.717004]  0000000000000246 ffffffff81644ec0 0000004000000000 ffffffff81644a80
[   23.717004]  ffffffff81644a80 0000000000000034 ffff88011400acc0 0000000000001000
[   23.717004]  0000000000000000 ffff880118500c10 ffff88011402ddf8 ffff880118500b90
[   23.717004] Call Trace:
[   23.717004]  [<ffffffff811fa51e>] get_valid_domain_for_dev+0x1e/0x90
[   23.717004]  [<ffffffff811fa8b4>] __intel_map_single+0x44/0x170
[   23.717004]  [<ffffffff811faab2>] intel_alloc_coherent+0x92/0xd0
[   23.717004]  [<ffffffffa00606db>] smi_data_buf_realloc+0xcb/0x220 [dcdbas]
[   23.717004]  [<ffffffffa00608da>] smi_data_buf_size_store+0x3a/0x60 [dcdbas]
[   23.717004]  [<ffffffff81270fcb>] dev_attr_store+0x1b/0x20
[   23.717004]  [<ffffffff8113a7f5>] sysfs_write_file+0xc5/0x140
[   23.717004]  [<ffffffff810dea4b>] vfs_write+0xcb/0x190
[   23.717004]  [<ffffffff810dec00>] sys_write+0x50/0x90
[   23.717004]  [<ffffffff8100bf2b>] system_call_fastpath+0x16/0x1b
[   23.717004] Code: 74 22 4c 8b 60 30 4d 85 e4 74 19 4c 89 e0 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 49 8b 46 10 4c 89 f7 <48> 8b 80 d8 00 00 00 44 8b 38 e8 8a 52 ff ff 48 89 45 90 48 85 
[   23.717004] RIP  [<ffffffff811f9937>] get_domain_for_dev+0x57/0x6a0
[   23.717004]  RSP <ffff88011402dd08>
[   23.717004] CR2: 00000000000000d8
[   23.722900] ---[ end trace 9244fcdcb95e3384 ]---
[   24.095922] Bluetooth: Core ver 2.15
[   24.096448] NET: Registered protocol family 31
[   24.096509] Bluetooth: HCI device and connection manager initialized
[   24.096574] Bluetooth: HCI socket layer initialized
[   24.121526] Bluetooth: L2CAP ver 2.13
[   24.121613] Bluetooth: L2CAP socket layer initialized
[   24.139169] Bluetooth: SCO (Voice Link) ver 0.6
[   24.139234] Bluetooth: SCO socket layer initialized
[   24.165557] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   24.165624] Bluetooth: BNEP filters: protocol multicast
[   24.250727] Bridge firewalling registered
[   24.353622] usb 1-1.2: usbfs: process 3905 (hid2hci) did not claim interface 0 before use
[   24.415577] Bluetooth: RFCOMM socket layer initialized
[   24.415656] Bluetooth: RFCOMM TTY layer initialized
[   24.415714] Bluetooth: RFCOMM ver 1.11
[   24.606518] usb 1-1.3: new full speed USB device using uhci_hcd and address 5
[   24.735711] usb 1-1.3: configuration #1 chosen from 1 choice
[   24.822669] Bluetooth: Generic Bluetooth USB driver ver 0.5
[   24.822950] usbcore: registered new interface driver btusb
[   28.297987] [drm] Initialized drm 1.1.0 20060810
[   28.331669] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   28.331676] pci 0000:00:02.0: setting latency timer to 64
[   28.363184] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[   28.363194] [drm] MTRR allocation failed.  Graphics performance may suffer.
[   28.363241] pci 0000:00:02.0: irq 34 for MSI/MSI-X
[   28.421092] acpi device:35: registered as cooling_device2
[   28.422425] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:33/input/input14
[   28.422467] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   28.422516] ACPI Warning (nspredef-0437): \_SB_.PCI0.VID2._DOD: Return Package has no elements (empty) [20090320]
[   28.422579] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:3a/input/input15
[   28.422599] ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)
[   28.422618] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   28.973269] e1000e 0000:00:19.0: irq 32 for MSI/MSI-X
[   29.028157] e1000e 0000:00:19.0: irq 32 for MSI/MSI-X
[   29.029421] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   29.031049] iwlagn 0000:0c:00.0: firmware: requesting iwlwifi-5000-1.ucode
[   29.092110] iwlagn 0000:0c:00.0: loaded firmware version 5.4.1.16
[   29.259758] Registered led device: iwl-phy0::radio
[   29.259798] Registered led device: iwl-phy0::assoc
[   29.259837] Registered led device: iwl-phy0::RX
[   29.259872] Registered led device: iwl-phy0::TX
[   29.278287] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   29.345311] NET: Registered protocol family 17
[   32.085087] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   32.086196] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   32.419747] wlan0: authenticate with AP 00:0b:0e:46:9e:00
[   32.439796] wlan0: authenticated
[   32.439808] wlan0: associate with AP 00:0b:0e:46:9e:00
[   32.444173] wlan0: RX AssocResp from 00:0b:0e:46:9e:00 (capab=0x421 status=1 aid=0)
[   32.444181] wlan0: AP denied association (code=1)
[   32.636270] wlan0: associate with AP 00:0b:0e:46:9e:00
[   32.640167] wlan0: RX AssocResp from 00:0b:0e:46:9e:00 (capab=0x421 status=1 aid=0)
[   32.640177] wlan0: AP denied association (code=1)
[   32.840005] wlan0: associate with AP 00:0b:0e:46:9e:00
[   32.843958] wlan0: RX AssocResp from 00:0b:0e:46:9e:00 (capab=0x421 status=1 aid=0)
[   32.843968] wlan0: AP denied association (code=1)
[   33.040078] wlan0: association with AP 00:0b:0e:46:9e:00 timed out
[   42.232247] eth0: no IPv6 routers present
[   62.634643] wlan0: authenticate with AP 00:0b:0e:46:9e:00
[   62.635749] wlan0: authenticate with AP 00:0b:0e:46:9e:00
[   62.638173] wlan0: authenticate with AP 00:0b:0e:46:9e:00
[   62.639943] wlan0: authenticated
[   62.639950] wlan0: associate with AP 00:0b:0e:46:9e:00
[   62.642696] wlan0: RX AssocResp from 00:0b:0e:46:9e:00 (capab=0x421 status=0 aid=7)
[   62.642704] wlan0: associated
[   62.647841] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   62.820978] cfg80211: Calling CRDA for country: US
[   62.826229] cfg80211: Current regulatory domain updated by AP to: US
[   62.826238] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   62.826245] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[   72.940255] wlan0: no IPv6 routers present

--/9DWx/yDrRhgMJTb--
