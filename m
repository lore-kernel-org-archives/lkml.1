Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbZDQPQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbZDQPQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbZDQPPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:15:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:45266 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbZDQPPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:15:54 -0400
Message-ID: <49E89D1B.7060800@suse.com>
Date: Fri, 17 Apr 2009 11:15:39 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [BUG] IO-APIC + timer doesn't work! 
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi all -

I saw this while booting 2.6.30-rc1, -rc2, and today's git, on one of
my development nodes. This output is with apic=debug. With noapic,
it still hung. Both outputs follow.

git bisect leads to commit 8d6f0c8214928f7c5083dd54ecb69c5d615b516e,
but I'm not seeing anything obvious there. Backing just that change
out doesn't fix it.

- -Jeff

apic=debug:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-rc2-vanilla (jeffm@sled2) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #22 SMP Thu Apr 16 17:25:38 EDT 2009
[    0.000000] Command line: root=/dev/disk/by-id/ata-ST3120813AS_3LS0FAGL-part10 eth0=dhcp console=tty0 console=ttyS0,115200 resume=/dev/disk/by-id/ata-ST3120813AS_3LS0FAGL-part6 splash=silent showopts vga=0x314 apic=debug
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000f7ff0000 (usable)
[    0.000000]  BIOS-e820: 00000000f7ff0000 - 00000000f7fff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000f7fff000 - 00000000f8000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000200000000 (usable)
[    0.000000] DMI 2.3 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] last_pfn = 0x200000 max_arch_pfn = 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xf7ff0 max_arch_pfn = 0x100000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000f7ff0000 (usable)
[    0.000000]  modified: 00000000f7ff0000 - 00000000f7fff000 (ACPI data)
[    0.000000]  modified: 00000000f7fff000 - 00000000f8000000 (ACPI NVS)
[    0.000000]  modified: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000200000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-00000000f7ff0000
[    0.000000] init_memory_mapping: 0000000100000000-0000000200000000
[    0.000000] RAMDISK: 37a0b000 - 37fefed3
[    0.000000] ACPI: RSDP 00000000000f6d40 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000f7ff0100 00054 (v01 A M I  OEMXSDT  06000514 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000f7ff0281 000F4 (v01 A M I  OEMFACP  06000514 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000f7ff0410 03591 (v01  0AAAA 0AAAA001 00000001 INTL 02002026)
[    0.000000] ACPI: FACS 00000000f7fff000 00040
[    0.000000] ACPI: APIC 00000000f7ff0380 00084 (v01 A M I  OEMAPIC  06000514 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000f7fff040 00041 (v01 A M I  OEMBIOS  06000514 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000f7ff39b0 00110 (v01 A M I  OEMSRAT  06000514 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000f7ff3ac0 00038 (v01 A M I  OEMHPET  06000514 MSFT 00000097)
[    0.000000] ACPI: ASF! 00000000f7ff3b00 00086 (v01 AMIASF AMDSTRET 00000001 INTL 02002026)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 100000-f8000000
[    0.000000] SRAT: Node 1 PXM 1 100000000-200000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-100000000
[    0.000000] SRAT: Node 0 PXM 0 0-9fc00
[    0.000000] Bootmem setup node 0 0000000000000000-0000000100000000
[    0.000000]   NODE_DATA [000000000001c040 - 000000000003403f]
[    0.000000]   bootmap [0000000000035000 -  0000000000054fff] pages 20
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0100000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00009e0d9c]    TEXT DATA BSS ==> [0000200000 - 00009e0d9c]
[    0.000000]   #3 [0037a0b000 - 0037fefed3]          RAMDISK ==> [0037a0b000 - 0037fefed3]
[    0.000000]   #4 [000009d000 - 0000100000]    BIOS reserved ==> [000009d000 - 0000100000]
[    0.000000]   #5 [00009e1000 - 00009e11ad]              BRK ==> [00009e1000 - 00009e11ad]
[    0.000000]   #6 [0000010000 - 0000014000]          PGTABLE ==> [0000010000 - 0000014000]
[    0.000000]   #7 [0000014000 - 0000018000]          PGTABLE ==> [0000014000 - 0000018000]
[    0.000000]   #8 [0000018000 - 000001c040]       MEMNODEMAP ==> [0000018000 - 000001c040]
[    0.000000] Bootmem setup node 1 0000000100000000-0000000200000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100017fff]
[    0.000000]   bootmap [0000000100018000 -  0000000100037fff] pages 20
[    0.000000] (9 early reservations) ==> bootmem [0100000000 - 0200000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 00009e0d9c]    TEXT DATA BSS
[    0.000000]   #3 [0037a0b000 - 0037fefed3]          RAMDISK
[    0.000000]   #4 [000009d000 - 0000100000]    BIOS reserved
[    0.000000]   #5 [00009e1000 - 00009e11ad]              BRK
[    0.000000]   #6 [0000010000 - 0000014000]          PGTABLE
[    0.000000]   #7 [0000014000 - 0000018000]          PGTABLE
[    0.000000]   #8 [0000018000 - 000001c040]       MEMNODEMAP
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]   mpc: fa3b0-fa50c
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00200000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000f7ff0
[    0.000000]     1: 0x00100000 -> 0x00200000
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfebff000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 5, version 0, address 0xfebff000, GSI 24-27
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfebfe000] gsi_base[28])
[    0.000000] IOAPIC[2]: apic_id 6, version 0, address 0xfebfe000, GSI 28-31
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x102282a0 base: 0xfec01000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffffffff5fc000 (fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (febff000)
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (febfe000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000f7ff0000 - 00000000f7fff000
[    0.000000] PM: Registered nosave memory: 00000000f7fff000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000ff780000
[    0.000000] PM: Registered nosave memory: 00000000ff780000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at f8800000 (gap: f8000000:7780000)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:2
[    0.000000] PERCPU: Remapped at ffffc20000000000 with large pages, static data 71776 bytes
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 2033901
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/disk/by-id/ata-ST3120813AS_3LS0FAGL-part10 eth0=dhcp console=tty0 console=ttyS0,115200 resume=/dev/disk/by-id/ata-ST3120813AS_3LS0FAGL-part6 splash=silent showopts vga=0x314 apic=debug
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:4352 nr_irqs:576
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2192.534 MHz processor.
[    0.004000] Console: colour dummy device 80x25
[    0.004000] console [tty0] enabled
[    0.004000] console [ttyS0] enabled
[    0.004000] allocated 82575360 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Node 0: aperture @ 0 size 32 MB
[    0.004000] Your BIOS doesn't leave a aperture memory hole
[    0.004000] Please enable the IOMMU option in the BIOS setup
[    0.004000] This costs you 64 MB of RAM
[    0.004000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.004000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.004000] Memory: 7981076k/8388608k available (3350k kernel code, 131588k absent, 275944k reserved, 1936k data, 1544k init)
[    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.004010] Calibrating delay loop (skipped), value calculated using timer frequency.. 4385.06 BogoMIPS (lpj=8770136)
[    0.008000] Security Framework initialized
[    0.008000] SELinux:  Disabled at boot.
[    0.008000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.008000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.008000] Mount-cache hash table entries: 256
[    0.008000] Initializing cgroup subsys ns
[    0.008000] Initializing cgroup subsys cpuacct
[    0.008000] Initializing cgroup subsys memory
[    0.008000] Initializing cgroup subsys devices
[    0.008000] Initializing cgroup subsys freezer
[    0.008000] Initializing cgroup subsys net_cls
[    0.008000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.008000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.008000] CPU 0/0x0 -> Node 0
[    0.008000] CPU: Physical Processor ID: 0
[    0.008000] CPU: Processor Core ID: 0
[    0.008000] ACPI: Core revision 20090320
[    0.008000] Setting APIC routing to flat
[    0.008000] Getting VERSION: 40010
[    0.008000] Getting VERSION: 40010
[    0.008000] Getting ID: 0
[    0.008000] Getting ID: ff000000
[    0.008000] Getting LVT0: 700
[    0.008000] Getting LVT1: 400
[    0.008000] enabled ExtINT on CPU#0
[    0.008000] ESR value before enabling vector: 0x00000004  after: 0x00000000
[    0.008000] ENABLING IO-APIC IRQs
[    0.008000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.008000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.008000] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.008000] ..... (found apic 0 pin 0) ...
[    0.008000] ....... failed.
[    0.008000] ...trying to set up timer as Virtual Wire IRQ...
[    0.008000] ..... failed.
[    0.008000] ...trying to set up timer as ExtINT IRQ...
[    0.008000] ..... failed :(.
[    0.008000] Kernel panic - not syncing: IO-APIC + timer doesn't work!  Boot with apic=debug and send a report.  Then try booting with the 'noapic' option.
[    0.008000] 
[    0.008000] Pid: 1, comm: swapper Not tainted 2.6.30-rc2-vanilla #22
[    0.008000] Call Trace:
[    0.008000]  [<ffffffff8053b810>] panic+0x84/0x13a
[    0.008000]  [<ffffffff8074e2e9>] setup_IO_APIC+0x487/0x8ea
[    0.008000]  [<ffffffff8053b911>] ? printk+0x4b/0x62
[    0.008000]  [<ffffffff8074922d>] native_smp_prepare_cpus+0x2ff/0x3a1
[    0.008000]  [<ffffffff8073d7c2>] kernel_init+0x69/0x1b5
[    0.008000]  [<ffffffff8020d12a>] child_rip+0xa/0x20
[    0.008000]  [<ffffffff8073d759>] ? kernel_init+0x0/0x1b5
[    0.008000]  [<ffffffff8020d120>] ? child_rip+0x0/0x20


Booting with noapic:
[...]
[    0.008000] Initializing cgroup subsys ns
[    0.008000] Initializing cgroup subsys cpuacct
[    0.008000] Initializing cgroup subsys memory
[    0.008000] Initializing cgroup subsys devices
[    0.008000] Initializing cgroup subsys freezer
[    0.008000] Initializing cgroup subsys net_cls
[    0.008000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.008000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.008000] CPU 0/0x0 -> Node 0
[    0.008000] CPU: Physical Processor ID: 0
[    0.008000] CPU: Processor Core ID: 0
[    0.008000] ACPI: Core revision 20090320
[    0.008000] ACPI: setting ELCR to 0200 (from 0e20)
[    0.008000] Setting APIC routing to flat
[    0.008000] CPU0: AMD Engineering Sample stepping 00


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknonRsACgkQLPWxlyuTD7KSDwCdGI8FqGgvpiciBY+LRq9QZLQ/
1b0AnigAAQtzzYFR9InctfPynAS3J4aV
=PR8g
-----END PGP SIGNATURE-----
