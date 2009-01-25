Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbZAYK7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbZAYK7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 05:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZAYK6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 05:58:55 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:39604 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbZAYK6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 05:58:46 -0500
Date: Sun, 25 Jan 2009 11:57:57 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Another libata error related to OCZ SSD
Message-ID: <20090125105757.GA5045@ics.muni.cz>
References: <20090111174159.GC4250@ics.muni.cz> <200901192239.25071.rjw@sisk.pl> <497BB9BB.4040608@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <497BB9BB.4040608@kernel.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 25 Jan 2009 11:57:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, Jan 25, 2009 at 10:00:43AM +0900, Tejun Heo wrote:
> Does the following command make any difference?
> 
>  echo 0 > /sys/class/scsi_disk/h:c:i:l/manage_start_stop
> 
> The h:c:i:l part needs to be adjusted to point to the OCZ disk.  lscsi
> will show which value to use.

No. I attached the complete dmesg.

Another observation, it does not happen if I change AHCI to compatibility mode
which results in using ata_piix instead of ahci driver.

So the problems appears to be with ahci driver, the ata_piix works fine.

-- 
Luká¹ Hejtmánek

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename=dmesg

[    0.000000] BIOS EBDA/lowmem at: 0009d800/0009d800
[    0.000000] Linux version 2.6.28-rc8 (root@anubis) (gcc version 4.3.3 20081210 (prerelease) (Ubuntu 4.3.2-2ubuntu8) ) #46 SMP Tue Dec 16 19:44:41 CET 2008
[    0.000000] Command line: root=/dev/sda2 ro resume=/dev/sda3 no_console_suspend
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007d6b0000 (usable)
[    0.000000]  BIOS-e820: 000000007d6b0000 - 000000007d6cc000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007d6cc000 - 000000007d700000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007d700000 - 000000007e000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x7d6b0 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping: 0000000000000000-000000007d6b0000
[    0.000000]  0000000000 - 007d600000 page 2M
[    0.000000]  007d600000 - 007d6b0000 page 4k
[    0.000000] kernel direct mapping tables up to 7d6b0000 @ 8000-c000
[    0.000000] last_map_addr: 7d6b0000 end: 7d6b0000
[    0.000000] ACPI: RSDP 000F68D0, 0024 (r2 LENOVO)
[    0.000000] ACPI: XSDT 7D6BB731, 0094 (r1 LENOVO TP-7L        2100  LTP        0)
[    0.000000] ACPI: FACP 7D6BB800, 00F4 (r3 LENOVO TP-7L        2100 LNVO        1)
[    0.000000] ACPI Warning (tbfadt-0460): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20080926]
[    0.000000] ACPI: DSDT 7D6BBC1D, FF1F (r1 LENOVO TP-7L        2100 MSFT  3000000)
[    0.000000] ACPI: FACS 7D6E4000, 0040
[    0.000000] ACPI: SSDT 7D6BB9B4, 0269 (r1 LENOVO TP-7L        2100 MSFT  3000000)
[    0.000000] ACPI: ECDT 7D6CBB3C, 0052 (r1 LENOVO TP-7L        2100 LNVO        1)
[    0.000000] ACPI: TCPA 7D6CBB8E, 0032 (r2 LENOVO TP-7L        2100 LNVO        1)
[    0.000000] ACPI: APIC 7D6CBBC0, 0068 (r1 LENOVO TP-7L        2100 LNVO        1)
[    0.000000] ACPI: MCFG 7D6CBC28, 003C (r1 LENOVO TP-7L        2100 LNVO        1)
[    0.000000] ACPI: HPET 7D6CBC64, 0038 (r1 LENOVO TP-7L        2100 LNVO        1)
[    0.000000] ACPI: SLIC 7D6CBDF0, 0176 (r1 LENOVO TP-7L        2100  LTP        0)
[    0.000000] ACPI: BOOT 7D6CBF66, 0028 (r1 LENOVO TP-7L        2100  LTP        1)
[    0.000000] ACPI: ASF! 7D6CBF8E, 0072 (r16 LENOVO TP-7L        2100 PTL         1)
[    0.000000] ACPI: SSDT 7D6E271B, 025F (r1 LENOVO TP-7L        2100 INTL 20050513)
[    0.000000] ACPI: SSDT 7D6E297A, 00A6 (r1 LENOVO TP-7L        2100 INTL 20050513)
[    0.000000] ACPI: SSDT 7D6E2A20, 04F7 (r1 LENOVO TP-7L        2100 INTL 20050513)
[    0.000000] ACPI: SSDT 7D6E2F17, 01D8 (r1 LENOVO TP-7L        2100 INTL 20050513)
[    0.000000] ACPI: DMI detected: Lenovo ThinkPad T61
[    0.000000] ACPI: Added _OSI(Linux)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 007d6b0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00007f38a8]    TEXT DATA BSS ==> [0000200000 - 00007f38a8]
[    0.000000]   #3 [000009d800 - 0000100000]    BIOS reserved ==> [000009d800 - 0000100000]
[    0.000000]   #4 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0007d6b0
[    0.000000] On node 0 totalpages: 513613
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1626 pages reserved
[    0.000000]   DMA zone: 2315 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6968 pages used for memmap
[    0.000000]   DMA32 zone: 502648 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 7e000000:72000000)
[    0.000000] PERCPU: Allocating 49152 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 504963
[    0.000000] Kernel command line: root=/dev/sda2 ro resume=/dev/sda3 no_console_suspend
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2393.812 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003333] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.003333] Checking aperture...
[    0.003333] No AGP bridge found
[    0.003333] Memory: 2015872k/2054848k available (3285k kernel code, 396k absent, 38088k reserved, 1701k data, 324k init)
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.003333] hpet clockevent registered
[    0.003333] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 4789.10 BogoMIPS (lpj=7979373)
[    0.003333] Mount-cache hash table entries: 256
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 4096K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] CPU0: Thermal monitoring enabled (TM2)
[    0.003333] using mwait in idle threads.
[    0.003333] ACPI: Core revision 20080926
[    0.020050] Setting APIC routing to flat
[    0.020472] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054471] CPU0: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0a
[    0.056666] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 4789.49 BogoMIPS (lpj=7979984)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 4096K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] CPU1: Thermal monitoring enabled (TM2)
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.147920] CPU1: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0a
[    0.148163] checking TSC synchronization [CPU#0 -> CPU#1]:
[    0.149999] Measured 436464 cycles TSC warp between CPUs, turning off TSC clock.
[    0.149999] Marking TSC unstable due to check_tsc_sync_source failed
[    0.150017] Brought up 2 CPUs
[    0.150039] Total of 2 processors activated (9579.59 BogoMIPS).
[    0.150136] net_namespace: 944 bytes
[    0.150148] regulator: core version 0.5
[    0.150148] NET: Registered protocol family 16
[    0.150148] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.150148] ACPI: bus type pci registered
[    0.150148] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
[    0.150148] PCI: MCFG area at f0000000 reserved in E820
[    0.154196] PCI: Using MMCONFIG at f0000000 - f3ffffff
[    0.154220] PCI: Using configuration type 1 for base access
[    0.157117] ACPI: EC: EC description table is found, configuring boot EC
[    0.163310] ACPI: BIOS _OSI(Linux) query honored via DMI
[    0.163353] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.175371] ACPI: Interpreter enabled
[    0.175393] ACPI: (supports S0 S3 S4 S5)
[    0.175455] ACPI: Using IOAPIC for interrupt routing
[    0.190345] ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
[    0.190345] ACPI: EC: driver started in interrupt mode
[    0.191240] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.191273] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.191381] pci 0000:00:02.0: reg 10 64bit mmio: [0xf8100000-0xf81fffff]
[    0.191387] pci 0000:00:02.0: reg 18 64bit mmio: [0xe0000000-0xefffffff]
[    0.191390] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.191417] pci 0000:00:02.1: reg 10 64bit mmio: [0xf8200000-0xf82fffff]
[    0.191548] pci 0000:00:19.0: reg 10 32bit mmio: [0xfe000000-0xfe01ffff]
[    0.191557] pci 0000:00:19.0: reg 14 32bit mmio: [0xfe025000-0xfe025fff]
[    0.191565] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.191642] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.191672] pci 0000:00:19.0: PME# disabled
[    0.191817] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.191945] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.192069] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfe226c00-0xfe226fff]
[    0.192175] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.192207] pci 0000:00:1a.7: PME# disabled
[    0.192336] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe020000-0xfe023fff]
[    0.192378] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.192407] pci 0000:00:1b.0: PME# disabled
[    0.192529] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.192558] pci 0000:00:1c.0: PME# disabled
[    0.192688] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.192717] pci 0000:00:1c.1: PME# disabled
[    0.192847] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.192878] pci 0000:00:1c.2: PME# disabled
[    0.193390] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.193419] pci 0000:00:1c.3: PME# disabled
[    0.193526] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.193557] pci 0000:00:1c.4: PME# disabled
[    0.193717] pci 0000:00:1d.0: reg 20 io port: [0x18a0-0x18bf]
[    0.193857] pci 0000:00:1d.1: reg 20 io port: [0x18c0-0x18df]
[    0.194000] pci 0000:00:1d.2: reg 20 io port: [0x18e0-0x18ff]
[    0.194143] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe227000-0xfe2273ff]
[    0.194236] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.194266] pci 0000:00:1d.7: PME# disabled
[    0.194495] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.194535] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
[    0.194622] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    0.194635] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    0.194649] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    0.194662] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    0.194676] pci 0000:00:1f.1: reg 20 io port: [0x1c00-0x1c0f]
[    0.194766] pci 0000:00:1f.2: reg 10 io port: [0x1c50-0x1c57]
[    0.194775] pci 0000:00:1f.2: reg 14 io port: [0x1c44-0x1c47]
[    0.194783] pci 0000:00:1f.2: reg 18 io port: [0x1c48-0x1c4f]
[    0.194792] pci 0000:00:1f.2: reg 1c io port: [0x1c40-0x1c43]
[    0.194800] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
[    0.194809] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfe226000-0xfe2267ff]
[    0.194830] pci 0000:00:1f.2: PME# supported from D3hot
[    0.194858] pci 0000:00:1f.2: PME# disabled
[    0.194923] pci 0000:00:1f.3: reg 10 32bit mmio: [0xfe227400-0xfe2274ff]
[    0.194947] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
[    0.195068] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.195074] pci 0000:00:1c.0: bridge 32bit mmio: [0xfc000000-0xfdffffff]
[    0.195089] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf8000000-0xf80fffff]
[    0.195217] pci 0000:03:00.0: reg 10 64bit mmio: [0xdf3fe000-0xdf3fffff]
[    0.195305] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.195358] pci 0000:03:00.0: PME# disabled
[    0.195476] pci 0000:00:1c.1: bridge io port: [0x3000-0x3fff]
[    0.195482] pci 0000:00:1c.1: bridge 32bit mmio: [0xdc000000-0xdf3fffff]
[    0.195490] pci 0000:00:1c.1: bridge 64bit mmio pref: [0xdfe00000-0xdfefffff]
[    0.195560] pci 0000:00:1c.2: bridge io port: [0x4000-0x4fff]
[    0.195568] pci 0000:00:1c.2: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
[    0.195577] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xdfb00000-0xdfbfffff]
[    0.195640] pci 0000:00:1c.3: bridge io port: [0x5000-0x5fff]
[    0.195646] pci 0000:00:1c.3: bridge 32bit mmio: [0xd4000000-0xd5ffffff]
[    0.195655] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xdf800000-0xdf8fffff]
[    0.195720] pci 0000:00:1c.4: bridge io port: [0x6000-0x6fff]
[    0.195726] pci 0000:00:1c.4: bridge 32bit mmio: [0xd0000000-0xd1ffffff]
[    0.195735] pci 0000:00:1c.4: bridge 64bit mmio pref: [0xdf500000-0xdf5fffff]
[    0.195809] pci 0000:15:00.0: reg 10 32bit mmio: [0xf8300000-0xf8300fff]
[    0.195831] pci 0000:15:00.0: supports D1 D2
[    0.195832] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.195865] pci 0000:15:00.0: PME# disabled
[    0.195957] pci 0000:15:00.1: reg 10 32bit mmio: [0xf8301000-0xf83017ff]
[    0.196034] pci 0000:15:00.1: supports D1 D2
[    0.196035] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.196667] pci 0000:15:00.1: PME# disabled
[    0.196759] pci 0000:15:00.2: reg 10 32bit mmio: [0xf8301800-0xf83018ff]
[    0.196837] pci 0000:15:00.2: supports D1 D2
[    0.196838] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.196868] pci 0000:15:00.2: PME# disabled
[    0.196958] pci 0000:15:00.3: reg 10 32bit mmio: [0xf8301c00-0xf8301cff]
[    0.197038] pci 0000:15:00.3: supports D1 D2
[    0.197040] pci 0000:15:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.197072] pci 0000:15:00.3: PME# disabled
[    0.197162] pci 0000:15:00.4: reg 10 32bit mmio: [0xf8302000-0xf83020ff]
[    0.197240] pci 0000:15:00.4: supports D1 D2
[    0.197241] pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.197272] pci 0000:15:00.4: PME# disabled
[    0.197364] pci 0000:15:00.5: reg 10 32bit mmio: [0xf8302400-0xf83024ff]
[    0.197443] pci 0000:15:00.5: supports D1 D2
[    0.197445] pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
[    0.197475] pci 0000:15:00.5: PME# disabled
[    0.197597] pci 0000:00:1e.0: transparent bridge
[    0.197624] pci 0000:00:1e.0: bridge io port: [0x7000-0xafff]
[    0.197631] pci 0000:00:1e.0: bridge 32bit mmio: [0xf8300000-0xfbffffff]
[    0.197639] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xf4000000-0xf7ffffff]
[    0.197722] bus 00 -> node 0
[    0.197728] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.197961] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.198086] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.198211] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.198335] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.198461] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.198587] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.203963] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
[    0.204259] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.204552] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.204844] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.204844] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.204844] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.204844] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.204844] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.204844] ACPI: Power Resource [PUBS] (on)
[    0.206847] SCSI subsystem initialized
[    0.206847] libata version 3.00 loaded.
[    0.206847] usbcore: registered new interface driver usbfs
[    0.206847] usbcore: registered new interface driver hub
[    0.206847] usbcore: registered new device driver usb
[    0.206847] PCI: Using ACPI for IRQ routing
[    0.216695] PCI-GART: No AMD GART found.
[    0.216726] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.216777] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.223344] Switched to high resolution mode on CPU 0
[    0.224945] Switched to high resolution mode on CPU 1
[    0.230845] pnp: PnP ACPI init
[    0.230871] ACPI: bus type pnp registered
[    0.235208] pnp: PnP ACPI: found 11 devices
[    0.235231] ACPI: ACPI bus type pnp unregistered
[    0.235263] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.235289] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.235314] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.235340] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.235365] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.235391] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
[    0.235416] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
[    0.235442] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
[    0.235468] system 00:00: iomem range 0xec000-0xeffff could not be reserved
[    0.235494] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.235520] system 00:00: iomem range 0x100000-0x7dffffff could not be reserved
[    0.235556] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
[    0.235592] system 00:00: iomem range 0xfed4c000-0xffffffff could not be reserved
[    0.235631] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.235657] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.235682] system 00:02: ioport range 0x1180-0x11bf has been reserved
[    0.235707] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.235732] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.235758] system 00:02: ioport range 0x1600-0x165f could not be reserved
[    0.235784] system 00:02: iomem range 0xf0000000-0xf3ffffff has been reserved
[    0.235810] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.235836] system 00:02: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.235862] system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.235889] system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.235915] system 00:02: iomem range 0xfed45000-0xfed4bfff has been reserved
[    0.241011] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.241039] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.241069] pci 0000:00:1c.0:   MEM window: 0xfc000000-0xfdffffff
[    0.241100] pci 0000:00:1c.0:   PREFETCH window: 0x000000f8000000-0x000000f80fffff
[    0.241143] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.241171] pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
[    0.241200] pci 0000:00:1c.1:   MEM window: 0xdc000000-0xdf3fffff
[    0.241229] pci 0000:00:1c.1:   PREFETCH window: 0x000000dfe00000-0x000000dfefffff
[    0.241272] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.241299] pci 0000:00:1c.2:   IO window: 0x4000-0x4fff
[    0.241328] pci 0000:00:1c.2:   MEM window: 0xd8000000-0xd9ffffff
[    0.241357] pci 0000:00:1c.2:   PREFETCH window: 0x000000dfb00000-0x000000dfbfffff
[    0.241400] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.241427] pci 0000:00:1c.3:   IO window: 0x5000-0x5fff
[    0.241457] pci 0000:00:1c.3:   MEM window: 0xd4000000-0xd5ffffff
[    0.241486] pci 0000:00:1c.3:   PREFETCH window: 0x000000df800000-0x000000df8fffff
[    0.241536] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:0d
[    0.241563] pci 0000:00:1c.4:   IO window: 0x6000-0x6fff
[    0.241594] pci 0000:00:1c.4:   MEM window: 0xd0000000-0xd1ffffff
[    0.241624] pci 0000:00:1c.4:   PREFETCH window: 0x000000df500000-0x000000df5fffff
[    0.241670] pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16
[    0.241694] pci 0000:15:00.0:   IO window: 0x007000-0x0070ff
[    0.241726] pci 0000:15:00.0:   IO window: 0x007400-0x0074ff
[    0.241756] pci 0000:15:00.0:   PREFETCH window: 0xf4000000-0xf7ffffff
[    0.241786] pci 0000:15:00.0:   MEM window: 0x80000000-0x83ffffff
[    0.241816] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15
[    0.241844] pci 0000:00:1e.0:   IO window: 0x7000-0xafff
[    0.241875] pci 0000:00:1e.0:   MEM window: 0xf8300000-0xfbffffff
[    0.241904] pci 0000:00:1e.0:   PREFETCH window: 0x000000f4000000-0x000000f7ffffff
[    0.241961] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.241994] pci 0000:00:1c.0: setting latency timer to 64
[    0.242011] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.242040] pci 0000:00:1c.1: setting latency timer to 64
[    0.242057] pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    0.242088] pci 0000:00:1c.2: setting latency timer to 64
[    0.242103] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.242133] pci 0000:00:1c.3: setting latency timer to 64
[    0.242150] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.242181] pci 0000:00:1c.4: setting latency timer to 64
[    0.242189] pci 0000:00:1e.0: enabling device (0005 -> 0007)
[    0.242222] pci 0000:00:1e.0: setting latency timer to 64
[    0.242239] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.242272] pci 0000:15:00.0: setting latency timer to 64
[    0.242278] bus: 00 index 0 io port: [0x00-0xffff]
[    0.242301] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.242327] bus: 02 index 0 io port: [0x2000-0x2fff]
[    0.242350] bus: 02 index 1 mmio: [0xfc000000-0xfdffffff]
[    0.242373] bus: 02 index 2 mmio: [0xf8000000-0xf80fffff]
[    0.242397] bus: 02 index 3 mmio: [0x0-0x0]
[    0.242419] bus: 03 index 0 io port: [0x3000-0x3fff]
[    0.242442] bus: 03 index 1 mmio: [0xdc000000-0xdf3fffff]
[    0.242465] bus: 03 index 2 mmio: [0xdfe00000-0xdfefffff]
[    0.242489] bus: 03 index 3 mmio: [0x0-0x0]
[    0.242511] bus: 04 index 0 io port: [0x4000-0x4fff]
[    0.242533] bus: 04 index 1 mmio: [0xd8000000-0xd9ffffff]
[    0.242557] bus: 04 index 2 mmio: [0xdfb00000-0xdfbfffff]
[    0.242580] bus: 04 index 3 mmio: [0x0-0x0]
[    0.242602] bus: 05 index 0 io port: [0x5000-0x5fff]
[    0.242625] bus: 05 index 1 mmio: [0xd4000000-0xd5ffffff]
[    0.242649] bus: 05 index 2 mmio: [0xdf800000-0xdf8fffff]
[    0.242672] bus: 05 index 3 mmio: [0x0-0x0]
[    0.242694] bus: 0d index 0 io port: [0x6000-0x6fff]
[    0.242717] bus: 0d index 1 mmio: [0xd0000000-0xd1ffffff]
[    0.242740] bus: 0d index 2 mmio: [0xdf500000-0xdf5fffff]
[    0.242764] bus: 0d index 3 mmio: [0x0-0x0]
[    0.242786] bus: 15 index 0 io port: [0x7000-0xafff]
[    0.242809] bus: 15 index 1 mmio: [0xf8300000-0xfbffffff]
[    0.242832] bus: 15 index 2 mmio: [0xf4000000-0xf7ffffff]
[    0.242856] bus: 15 index 3 io port: [0x00-0xffff]
[    0.242879] bus: 15 index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.242903] bus: 16 index 0 io port: [0x7000-0x70ff]
[    0.242926] bus: 16 index 1 io port: [0x7400-0x74ff]
[    0.242949] bus: 16 index 2 mmio: [0xf4000000-0xf7ffffff]
[    0.242972] bus: 16 index 3 mmio: [0x80000000-0x83ffffff]
[    0.243001] NET: Registered protocol family 2
[    0.274210] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.274509] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.276146] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.276779] TCP: Hash tables configured (established 262144 bind 65536)
[    0.276805] TCP reno registered
[    0.284259] NET: Registered protocol family 1
[    0.284431] Simple Boot Flag at 0x35 set to 0x1
[    0.287858] msgmni has been set to 3938
[    0.288047] alg: No test for stdrng (krng)
[    0.288157] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.288194] io scheduler noop registered
[    0.288215] io scheduler anticipatory registered
[    0.288238] io scheduler deadline registered
[    0.288310] io scheduler cfq registered (default)
[    0.288342] pci 0000:00:02.0: Boot video device
[    0.288356] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.288357] pci 0000:00:1a.0: Performing full reset
[    0.288383] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.288385] pci 0000:00:1a.1: Performing full reset
[    0.288446] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.288447] pci 0000:00:1d.0: Performing full reset
[    0.288474] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.288475] pci 0000:00:1d.1: Performing full reset
[    0.288501] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.288502] pci 0000:00:1d.2: Performing full reset
[    0.296031] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.296081] pcieport-driver 0000:00:1c.0: found MSI capability
[    0.296148] pcieport-driver 0000:00:1c.0: irq 319 for MSI/MSI-X
[    0.296163] pci_express 0000:00:1c.0:pcie00: allocate port service
[    0.296208] pci_express 0000:00:1c.0:pcie02: allocate port service
[    0.296251] pci_express 0000:00:1c.0:pcie03: allocate port service
[    0.296352] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.296398] pcieport-driver 0000:00:1c.1: found MSI capability
[    0.296463] pcieport-driver 0000:00:1c.1: irq 318 for MSI/MSI-X
[    0.296479] pci_express 0000:00:1c.1:pcie00: allocate port service
[    0.296522] pci_express 0000:00:1c.1:pcie02: allocate port service
[    0.296565] pci_express 0000:00:1c.1:pcie03: allocate port service
[    0.296720] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.296773] pcieport-driver 0000:00:1c.2: found MSI capability
[    0.296828] pcieport-driver 0000:00:1c.2: irq 317 for MSI/MSI-X
[    0.296844] pci_express 0000:00:1c.2:pcie00: allocate port service
[    0.296880] pci_express 0000:00:1c.2:pcie02: allocate port service
[    0.296913] pci_express 0000:00:1c.2:pcie03: allocate port service
[    0.297046] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.297106] pcieport-driver 0000:00:1c.3: found MSI capability
[    0.297161] pcieport-driver 0000:00:1c.3: irq 316 for MSI/MSI-X
[    0.297186] pci_express 0000:00:1c.3:pcie00: allocate port service
[    0.297220] pci_express 0000:00:1c.3:pcie02: allocate port service
[    0.297252] pci_express 0000:00:1c.3:pcie03: allocate port service
[    0.297374] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.297420] pcieport-driver 0000:00:1c.4: found MSI capability
[    0.297475] pcieport-driver 0000:00:1c.4: irq 315 for MSI/MSI-X
[    0.297491] pci_express 0000:00:1c.4:pcie00: allocate port service
[    0.297563] pci_express 0000:00:1c.4:pcie02: allocate port service
[    0.297609] pci_express 0000:00:1c.4:pcie03: allocate port service
[    0.298290] ACPI: AC Adapter [AC] (off-line)
[    0.338362] ACPI: Battery Slot [BAT0] (battery present)
[    0.338513] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.338550] ACPI: Power Button (FF) [PWRF]
[    0.338638] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    0.339570] ACPI: Lid Switch [LID]
[    0.339662] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.339705] ACPI: Sleep Button (CM) [SLPB]
[    0.344981] acpi device:03: registered as cooling_device0
[    0.345259] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/input/input3
[    0.345297] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    0.345886] ACPI: SSDT 7D6E1B32, 0306 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
[    0.346461] ACPI: SSDT 7D6E1EBD, 085E (r1  PmRef  Cpu0Cst      100 INTL 20050513)
[    0.349409] Monitor-Mwait will be used to enter C-1 state
[    0.349411] Monitor-Mwait will be used to enter C-2 state
[    0.349413] Monitor-Mwait will be used to enter C-3 state
[    0.349459] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.349556] processor ACPI_CPU:00: registered as cooling_device1
[    0.349581] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.349914] ACPI: SSDT 7D6E1A6A, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
[    0.350334] ACPI: SSDT 7D6E1E38, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
[    0.352628] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.352706] processor ACPI_CPU:01: registered as cooling_device2
[    0.352731] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.358425] thermal LNXTHERM:01: registered as thermal_zone0
[    0.362169] ACPI: Thermal Zone [THM0] (57 C)
[    0.363145] thermal LNXTHERM:02: registered as thermal_zone1
[    0.364380] ACPI: Thermal Zone [THM1] (50 C)
[    0.419656] Non-volatile memory driver v1.2
[    0.419682] Linux agpgart interface v0.103
[    0.419719] Uniform Multi-Platform E-IDE driver
[    0.419805] ide-gd driver 1.18
[    0.420113] Driver 'sd' needs updating - please use bus_type methods
[    0.420159] Driver 'sr' needs updating - please use bus_type methods
[    0.420253] ahci 0000:00:1f.2: version 3.0
[    0.420274] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.420352] ahci 0000:00:1f.2: irq 314 for MSI/MSI-X
[    0.420413] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 1.5 Gbps 0x1 impl SATA mode
[    0.420450] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part 
[    0.420493] ahci 0000:00:1f.2: setting latency timer to 64
[    0.420620] scsi0 : ahci
[    0.420740] scsi1 : ahci
[    0.420866] scsi2 : ahci
[    0.421034] ata1: SATA max UDMA/133 irq_stat 0x00400040 irq 314, connection status changed
[    0.421071] ata2: DUMMY
[    0.421090] ata3: DUMMY
[    1.140031] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.140788] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    1.140790] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    1.141298] ata1.00: ATA-8: OCZ CORE_SSD, 02.10104, max UDMA/100
[    1.141323] ata1.00: 504856576 sectors, multi 0: LBA48 NCQ (not used)
[    1.141351] ata1.00: applying bridge limits
[    1.142417] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    1.142419] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    1.142931] ata1.00: configured for UDMA/100
[    1.154424] ata1.00: configured for UDMA/100
[    1.154447] ata1: EH complete
[    1.154588] scsi 0:0:0:0: Direct-Access     ATA      OCZ CORE_SSD     02.1 PQ: 0 ANSI: 5
[    1.154762] sd 0:0:0:0: [sda] 504856576 512-byte hardware sectors: (258 GB/240 GiB)
[    1.154807] sd 0:0:0:0: [sda] Write Protect is off
[    1.154830] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.154846] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.154930] sd 0:0:0:0: [sda] 504856576 512-byte hardware sectors: (258 GB/240 GiB)
[    1.154973] sd 0:0:0:0: [sda] Write Protect is off
[    1.154996] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.155011] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.155049]  sda: sda1 sda2 sda3 sda4
[    3.198433] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.198553] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.198683] ata_piix 0000:00:1f.1: version 2.12
[    3.198692] ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[    3.198759] ata_piix 0000:00:1f.1: setting latency timer to 64
[    3.198846] scsi3 : ata_piix
[    3.198971] scsi4 : ata_piix
[    3.199738] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1c00 irq 14
[    3.199764] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1c08 irq 15
[    3.357221] ata4.00: ATAPI: MATSHITADVD-RAM UJ-852, RB02, max UDMA/33
[    3.370461] ata4.00: configured for UDMA/33
[    3.370906] ata5: port disabled. ignoring.
[    3.370921] isa bounce pool size: 16 pages
[    3.372830] scsi 3:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-852   RB02 PQ: 0 ANSI: 5
[    3.377246] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.377283] Uniform CD-ROM driver Revision: 3.20
[    3.377410] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    3.377493] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    3.377718] usbcore: registered new interface driver libusual
[    3.377809] usbcore: registered new interface driver usbserial
[    3.377833] usbserial: USB Serial Driver core
[    3.377885] USB Serial support registered for pl2303
[    3.377942] usbcore: registered new interface driver pl2303
[    3.377966] pl2303: Prolific PL2303 USB to serial adaptor driver
[    3.378070] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.387323] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.387348] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.387509] mice: PS/2 mouse device common for all mice
[    3.433543] rtc_cmos 00:07: RTC can wake from S4
[    3.433633] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    3.433691] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.433755] i2c /dev entries driver
[    3.433872] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.434429] cpuidle: using governor ladder
[    3.435079] cpuidle: using governor menu
[    3.435348] Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
[    3.435753] ALSA device list:
[    3.435775]   No soundcards found.
[    3.436031] TCP highspeed registered
[    3.436058] NET: Registered protocol family 17
[    3.436085] NET: Registered protocol family 15
[    3.437436] rtc_cmos 00:07: setting system clock to 2009-01-25 11:32:18 UTC (1232883138)
[    3.437606] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    4.000948] Clocksource tsc unstable (delta = -481072483 ns)
[    4.088660] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000
[    4.088706] serio: Synaptics pass-through port at isa0060/serio1/input0
[    4.128889] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
[    9.516029] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    9.746697] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input6
[    9.948969] EXT3-fs: INFO: recovery required on readonly filesystem.
[    9.948999] EXT3-fs: write access will be enabled during recovery.
[   10.072887] kjournald starting.  Commit interval 5 seconds
[   10.072939] EXT3-fs: recovery complete.
[   10.075976] EXT3-fs: mounted filesystem with ordered data mode.
[   10.076016] VFS: Mounted root (ext3 filesystem) readonly.
[   10.076069] Freeing unused kernel memory: 324k freed
[   10.801139] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[   10.802114] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[   10.805073] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[   10.814918] ACPI: WMI: Mapper loaded
[   10.834805] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[   10.834834] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   10.834916] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   10.834955] e1000e 0000:00:19.0: setting latency timer to 64
[   10.835125] e1000e 0000:00:19.0: irq 313 for MSI/MSI-X
[   10.852863] uhci_hcd: USB Universal Host Controller Interface driver
[   10.869701] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.869730] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[   10.869767] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[   10.886650] cfg80211: Using static regulatory domain info
[   10.886693] cfg80211: Regulatory domain: US
[   10.886715] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   10.886751] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[   10.886776] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   10.886802] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   10.886827] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   10.886852] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   10.886878] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[   10.886903] cfg80211: Calling CRDA for country: US
[   10.926622] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
[   10.937739] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
[   10.937778] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[   10.937913] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   10.937969] iwlagn 0000:03:00.0: setting latency timer to 64
[   10.938030] iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
[   10.985883] iwlagn: Tunable channels: 11 802.11bg, 13 802.11a channels
[   10.989354] iwlagn 0000:03:00.0: PCI INT A disabled
[   10.990653] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   11.005421] sdhci: Secure Digital Host Controller Interface driver
[   11.005456] sdhci: Copyright(c) Pierre Ossman
[   11.027309] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   11.053305] thinkpad_acpi: ThinkPad ACPI Extras v0.21
[   11.053381] thinkpad_acpi: http://ibm-acpi.sf.net/
[   11.053404] thinkpad_acpi: ThinkPad BIOS 7LETB0WW (2.10 ), EC 7KHT24WW-1.08
[   11.053431] thinkpad_acpi: Lenovo ThinkPad T61, model 6465CTO
[   11.055348] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
[   11.055380] yenta_cardbus 0000:15:00.0: Socket status: 30000006
[   11.055408] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge I/O window: 0x7000 - 0xafff
[   11.055448] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf8300000 - 0xfbffffff
[   11.055488] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf4000000 - 0xf7ffffff
[   11.056322] sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 21)
[   11.056389] sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   11.056999] thinkpad_acpi: ACPI backlight control delay disabled
[   11.057471] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[   11.057589] sdhci-pci 0000:15:00.2: setting latency timer to 64
[   11.057770] thinkpad_acpi: radio switch found; radios are enabled
[   11.057887] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   11.057927] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   11.058645] Registered led device: mmc0
[   11.059697] mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
[   11.061073] ohci1394 0000:15:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   11.061108] ohci1394 0000:15:00.1: setting latency timer to 64
[   11.091098] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1a:6b:d2:bd:81
[   11.091134] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   11.091785] 0000:00:19.0: eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff
[   11.092110] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   11.092145] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   11.092150] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   11.092221] drivers/usb/core/inode.c: creating file 'devices'
[   11.092224] drivers/usb/core/inode.c: creating file '001'
[   11.092335] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[   11.092379] uhci_hcd 0000:00:1a.0: detected 2 ports
[   11.092407] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[   11.092409] uhci_hcd 0000:00:1a.0: Performing full reset
[   11.092426] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[   11.092439] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[   11.092498] usb usb1: default language 0x0409
[   11.092534] usb usb1: uevent
[   11.092568] usb usb1: usb_probe_device
[   11.092570] usb usb1: configuration #1 chosen from 1 choice
[   11.092597] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   11.092608] usb 1-0:1.0: uevent
[   11.092638] hub 1-0:1.0: usb_probe_interface
[   11.092640] hub 1-0:1.0: usb_probe_interface - got id
[   11.092641] hub 1-0:1.0: USB hub found
[   11.092667] hub 1-0:1.0: 2 ports detected
[   11.092689] hub 1-0:1.0: standalone hub
[   11.092690] hub 1-0:1.0: no power switching (usb 1.0)
[   11.092691] hub 1-0:1.0: individual port over-current protection
[   11.092693] hub 1-0:1.0: power on to power good time: 2ms
[   11.092696] hub 1-0:1.0: local power source is good
[   11.092698] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   11.092804] drivers/usb/core/inode.c: creating file '001'
[   11.092870] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   11.092896] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.092931] usb usb1: Product: UHCI Host Controller
[   11.092954] usb usb1: Manufacturer: Linux 2.6.28-rc8 uhci_hcd
[   11.092978] usb usb1: SerialNumber: 0000:00:1a.0
[   11.101922] Registered led device: tpacpi::thinklight
[   11.101989] Registered led device: tpacpi::power
[   11.102041] Registered led device: tpacpi:orange:batt
[   11.102090] Registered led device: tpacpi:green:batt
[   11.102139] Registered led device: tpacpi::dock_active
[   11.102188] Registered led device: tpacpi::bay_active
[   11.102236] Registered led device: tpacpi::dock_batt
[   11.102285] Registered led device: tpacpi::unknown_led
[   11.102336] Registered led device: tpacpi::standby
[   11.105049] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[   11.105372] input: ThinkPad Extra Buttons as /devices/virtual/input/input8
[   11.114262] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[f8301000-f83017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[   11.118885] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   11.118926] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[   11.118979] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   11.118984] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   11.119030] drivers/usb/core/inode.c: creating file '002'
[   11.119107] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 2
[   11.119153] ehci_hcd 0000:00:1a.7: reset hcs_params 0x102204 dbg=1 cc=2 pcc=2 ordered !ppc ports=4
[   11.119158] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[   11.119182] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   11.123093] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[   11.123094] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[   11.123109] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfe226c00
[   11.123137] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   11.127009] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[   11.137557] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   11.137617] usb usb2: default language 0x0409
[   11.137700] usb usb2: uevent
[   11.137741] usb usb2: usb_probe_device
[   11.137743] usb usb2: configuration #1 chosen from 1 choice
[   11.137770] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   11.137781] usb 2-0:1.0: uevent
[   11.137812] hub 2-0:1.0: usb_probe_interface
[   11.137813] hub 2-0:1.0: usb_probe_interface - got id
[   11.137815] hub 2-0:1.0: USB hub found
[   11.137841] hub 2-0:1.0: 4 ports detected
[   11.137863] hub 2-0:1.0: standalone hub
[   11.137864] hub 2-0:1.0: no power switching (usb 1.0)
[   11.137865] hub 2-0:1.0: individual port over-current protection
[   11.137867] hub 2-0:1.0: power on to power good time: 20ms
[   11.137870] hub 2-0:1.0: local power source is good
[   11.137872] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   11.138006] drivers/usb/core/inode.c: creating file '001'
[   11.138061] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   11.138091] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.138132] usb usb2: Product: EHCI Host Controller
[   11.138159] usb usb2: Manufacturer: Linux 2.6.28-rc8 ehci_hcd
[   11.138183] usb usb2: SerialNumber: 0000:00:1a.7
[   11.138238] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   11.138284] hda_intel: probe_mask set to 0x1 for device 17aa:20ac
[   11.138347] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   11.190528] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[   11.190543] uhci_hcd 0000:00:1a.0: port 2 portsc 0082,00
[   11.237579] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[   11.237583] hub 2-0:1.0: port 1: status 0501 change 0001
[   11.237595] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[   11.237597] hub 2-0:1.0: port 2: status 0501 change 0001
[   11.290128] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   11.337602] hub 2-0:1.0: state 7 ports 4 chg 0006 evt 0000
[   11.337617] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[   11.390414] ehci_hcd 0000:00:1a.7: port 1 full speed --> companion
[   11.390422] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 003801 POWER OWNER sig=j CONNECT
[   11.390425] hub 2-0:1.0: port 1 not reset yet, waiting 50ms
[   11.443550] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 003002 POWER OWNER sig=se0 CSC
[   11.443590] hub 2-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[   11.497042] ehci_hcd 0000:00:1a.7: port 2 full speed --> companion
[   11.497044] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
[   11.497047] hub 2-0:1.0: port 2 not reset yet, waiting 50ms
[   11.539759] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[   11.539795] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[   11.539832] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   11.539837] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   11.539916] drivers/usb/core/inode.c: creating file '003'
[   11.539980] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
[   11.540049] uhci_hcd 0000:00:1a.1: detected 2 ports
[   11.540077] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[   11.540078] uhci_hcd 0000:00:1a.1: Performing full reset
[   11.540097] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[   11.540117] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[   11.540180] usb usb3: default language 0x0409
[   11.540215] usb usb3: uevent
[   11.540248] usb usb3: usb_probe_device
[   11.540250] usb usb3: configuration #1 chosen from 1 choice
[   11.540278] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   11.540313] usb 3-0:1.0: uevent
[   11.540351] hub 3-0:1.0: usb_probe_interface
[   11.540352] hub 3-0:1.0: usb_probe_interface - got id
[   11.540354] hub 3-0:1.0: USB hub found
[   11.540381] hub 3-0:1.0: 2 ports detected
[   11.540403] hub 3-0:1.0: standalone hub
[   11.540404] hub 3-0:1.0: no power switching (usb 1.0)
[   11.540405] hub 3-0:1.0: individual port over-current protection
[   11.540407] hub 3-0:1.0: power on to power good time: 2ms
[   11.540410] hub 3-0:1.0: local power source is good
[   11.540411] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   11.540496] drivers/usb/core/inode.c: creating file '001'
[   11.540551] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   11.540577] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.540612] usb usb3: Product: UHCI Host Controller
[   11.540635] usb usb3: Manufacturer: Linux 2.6.28-rc8 uhci_hcd
[   11.540659] usb usb3: SerialNumber: 0000:00:1a.1
[   11.541116] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   11.541154] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   11.541211] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   11.541216] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   11.541278] drivers/usb/core/inode.c: creating file '004'
[   11.541331] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
[   11.541373] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   11.541379] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[   11.541398] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   11.545307] ehci_hcd 0000:00:1d.7: debug port 1
[   11.545345] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[   11.545347] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[   11.545364] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfe227000
[   11.545401] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   11.549281] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[   11.550039] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[   11.550554] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
[   11.560075] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   11.560134] usb usb4: default language 0x0409
[   11.560247] usb usb4: uevent
[   11.560269] usb usb4: usb_probe_device
[   11.560272] usb usb4: configuration #1 chosen from 1 choice
[   11.560325] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   11.560341] usb 4-0:1.0: uevent
[   11.560350] hub 4-0:1.0: usb_probe_interface
[   11.560351] hub 4-0:1.0: usb_probe_interface - got id
[   11.560353] hub 4-0:1.0: USB hub found
[   11.560383] hub 4-0:1.0: 6 ports detected
[   11.560409] hub 4-0:1.0: standalone hub
[   11.560410] hub 4-0:1.0: no power switching (usb 1.0)
[   11.560411] hub 4-0:1.0: individual port over-current protection
[   11.560412] hub 4-0:1.0: power on to power good time: 20ms
[   11.560415] hub 4-0:1.0: local power source is good
[   11.560417] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   11.560494] drivers/usb/core/inode.c: creating file '001'
[   11.560528] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[   11.560559] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.560612] usb usb4: Product: EHCI Host Controller
[   11.560641] usb usb4: Manufacturer: Linux 2.6.28-rc8 ehci_hcd
[   11.560672] usb usb4: SerialNumber: 0000:00:1d.7
[   11.561409] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   11.561443] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.561480] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   11.561485] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   11.561549] drivers/usb/core/inode.c: creating file '005'
[   11.561646] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[   11.561693] uhci_hcd 0000:00:1d.0: detected 2 ports
[   11.561721] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[   11.561722] uhci_hcd 0000:00:1d.0: Performing full reset
[   11.561742] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[   11.561748] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018a0
[   11.561804] usb usb5: default language 0x0409
[   11.561839] usb usb5: uevent
[   11.561870] usb usb5: usb_probe_device
[   11.561872] usb usb5: configuration #1 chosen from 1 choice
[   11.561899] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[   11.561914] usb 5-0:1.0: uevent
[   11.561946] hub 5-0:1.0: usb_probe_interface
[   11.561947] hub 5-0:1.0: usb_probe_interface - got id
[   11.561949] hub 5-0:1.0: USB hub found
[   11.561975] hub 5-0:1.0: 2 ports detected
[   11.561997] hub 5-0:1.0: standalone hub
[   11.561998] hub 5-0:1.0: no power switching (usb 1.0)
[   11.562000] hub 5-0:1.0: individual port over-current protection
[   11.562001] hub 5-0:1.0: power on to power good time: 2ms
[   11.562004] hub 5-0:1.0: local power source is good
[   11.562006] hub 5-0:1.0: trying to enable port power on non-switchable hub
[   11.562091] drivers/usb/core/inode.c: creating file '001'
[   11.562167] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   11.562193] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.562229] usb usb5: Product: UHCI Host Controller
[   11.562252] usb usb5: Manufacturer: Linux 2.6.28-rc8 uhci_hcd
[   11.562279] usb usb5: SerialNumber: 0000:00:1d.0
[   11.562332] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   11.562373] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   11.562378] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   11.562433] drivers/usb/core/inode.c: creating file '006'
[   11.562484] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[   11.562525] uhci_hcd 0000:00:1d.1: detected 2 ports
[   11.562553] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[   11.562555] uhci_hcd 0000:00:1d.1: Performing full reset
[   11.562573] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[   11.562577] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018c0
[   11.562663] usb usb6: default language 0x0409
[   11.562698] usb usb6: uevent
[   11.562728] usb usb6: usb_probe_device
[   11.562729] usb usb6: configuration #1 chosen from 1 choice
[   11.562756] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[   11.562767] usb 6-0:1.0: uevent
[   11.562795] hub 6-0:1.0: usb_probe_interface
[   11.562796] hub 6-0:1.0: usb_probe_interface - got id
[   11.562798] hub 6-0:1.0: USB hub found
[   11.562823] hub 6-0:1.0: 2 ports detected
[   11.562848] hub 6-0:1.0: standalone hub
[   11.562849] hub 6-0:1.0: no power switching (usb 1.0)
[   11.562850] hub 6-0:1.0: individual port over-current protection
[   11.562851] hub 6-0:1.0: power on to power good time: 2ms
[   11.562854] hub 6-0:1.0: local power source is good
[   11.562856] hub 6-0:1.0: trying to enable port power on non-switchable hub
[   11.562943] drivers/usb/core/inode.c: creating file '001'
[   11.563001] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   11.563027] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.563062] usb usb6: Product: UHCI Host Controller
[   11.563085] usb usb6: Manufacturer: Linux 2.6.28-rc8 uhci_hcd
[   11.563110] usb usb6: SerialNumber: 0000:00:1d.1
[   11.563187] usb usb2: uevent
[   11.563676] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[   11.563711] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   11.563746] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   11.563751] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   11.563808] drivers/usb/core/inode.c: creating file '007'
[   11.563867] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[   11.563910] uhci_hcd 0000:00:1d.2: detected 2 ports
[   11.563938] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[   11.563939] uhci_hcd 0000:00:1d.2: Performing full reset
[   11.563957] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[   11.563962] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018e0
[   11.564019] usb usb7: default language 0x0409
[   11.564078] usb usb7: uevent
[   11.564109] usb usb7: usb_probe_device
[   11.564110] usb usb7: configuration #1 chosen from 1 choice
[   11.564137] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[   11.564148] usb 7-0:1.0: uevent
[   11.564177] hub 7-0:1.0: usb_probe_interface
[   11.564178] hub 7-0:1.0: usb_probe_interface - got id
[   11.564180] hub 7-0:1.0: USB hub found
[   11.564208] hub 7-0:1.0: 2 ports detected
[   11.564232] hub 7-0:1.0: standalone hub
[   11.564233] hub 7-0:1.0: no power switching (usb 1.0)
[   11.564235] hub 7-0:1.0: individual port over-current protection
[   11.564236] hub 7-0:1.0: power on to power good time: 2ms
[   11.564239] hub 7-0:1.0: local power source is good
[   11.564240] hub 7-0:1.0: trying to enable port power on non-switchable hub
[   11.564330] drivers/usb/core/inode.c: creating file '001'
[   11.564383] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   11.564412] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.564453] usb usb7: Product: UHCI Host Controller
[   11.564476] usb usb7: Manufacturer: Linux 2.6.28-rc8 uhci_hcd
[   11.564502] usb usb7: SerialNumber: 0000:00:1d.2
[   11.566786] usb usb1: uevent
[   11.589630] usb usb6: uevent
[   11.596858] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0006
[   11.596872] uhci_hcd 0000:00:1a.0: port 1 portsc 0093,00
[   11.596884] hub 1-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[   11.601165] usb usb3: uevent
[   11.602347] usb usb5: uevent
[   11.621516] usb usb7: uevent
[   11.657681] usb usb4: uevent
[   11.724227] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[   11.830884] usb 1-1: new full speed USB device using uhci_hcd and address 2
[   11.978555] usb 1-1: skipped 1 descriptor after interface
[   11.981539] usb 1-1: default language 0x0409
[   11.987648] usb 1-1: uevent
[   11.987816] usb 1-1: usb_probe_device
[   11.987818] usb 1-1: configuration #1 chosen from 1 choice
[   11.989543] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[   11.989555] usb 1-1:1.0: uevent
[   11.989823] usb 1-1: adding 1-1:1.1 (config #1, interface 1)
[   11.989835] usb 1-1:1.1: uevent
[   11.990003] usb 1-1: adding 1-1:1.2 (config #1, interface 2)
[   11.990014] usb 1-1:1.2: uevent
[   11.990162] usb 1-1: adding 1-1:1.3 (config #1, interface 3)
[   11.990176] usb 1-1:1.3: uevent
[   11.990263] drivers/usb/core/inode.c: creating file '002'
[   11.990333] usb 1-1: New USB device found, idVendor=0a5c, idProduct=2110
[   11.990475] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   11.990621] usb 1-1: Product: BCM2045B
[   11.990747] usb 1-1: Manufacturer: Broadcom Corp
[   11.990897] uhci_hcd 0000:00:1a.0: port 2 portsc 0093,00
[   11.990903] hub 1-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[   12.013306] Bluetooth: Core ver 2.13
[   12.016377] usb 1-1: uevent
[   12.034513] NET: Registered protocol family 31
[   12.034538] Bluetooth: HCI device and connection manager initialized
[   12.034563] Bluetooth: HCI socket layer initialized
[   12.036947] Bluetooth: Generic Bluetooth USB driver ver 0.3
[   12.037002] btusb 1-1:1.0: usb_probe_interface
[   12.037003] btusb 1-1:1.0: usb_probe_interface - got id
[   12.037041] btusb 1-1:1.2: usb_probe_interface
[   12.037043] btusb 1-1:1.2: usb_probe_interface - got id
[   12.037049] btusb 1-1:1.3: usb_probe_interface
[   12.037050] btusb 1-1:1.3: usb_probe_interface - got id
[   12.037060] usbcore: registered new interface driver btusb
[   12.062697] fuse init (API version 7.10)
[   12.114719] hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[   12.143699] Adding 1542232k swap on /dev/sda3.  Priority:-1 extents:1 across:1542232k
[   12.157193] EXT3 FS on sda2, internal journal
[   12.220908] usb 1-2: new full speed USB device using uhci_hcd and address 3
[   12.221484] EXT2-fs warning (device sda4): ext2_fill_super: mounting ext3 filesystem as ext2
[   12.221489] EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
[   12.347643] usb 1-2: ep0 maxpacket = 8
[   12.370533] usb 1-2: default language 0x0409
[   12.389625] usb 1-2: uevent
[   12.390332] usb 1-2: usb_probe_device
[   12.390334] usb 1-2: configuration #1 chosen from 1 choice
[   12.392537] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
[   12.392558] usb 1-2:1.0: uevent
[   12.392706] drivers/usb/core/inode.c: creating file '003'
[   12.392747] usb 1-2: New USB device found, idVendor=0483, idProduct=2016
[   12.392749] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   12.392750] usb 1-2: Product: Biometric Coprocessor
[   12.392751] usb 1-2: Manufacturer: STMicroelectronics
[   12.392755] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   12.392759] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   12.392762] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   12.392764] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   12.392767] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   12.392770] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[   12.395727] usb 1-2: uevent
[   12.397235] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00061b032a155b20]
[   12.596836] usb usb3: suspend_rh (auto-stop)
[   12.596883] usb usb5: suspend_rh (auto-stop)
[   12.596926] usb usb6: suspend_rh (auto-stop)
[   12.596973] usb usb7: suspend_rh (auto-stop)
[   13.550292] hub 2-0:1.0: hub_suspend
[   13.550309] usb usb2: bus auto-suspend
[   13.550315] ehci_hcd 0000:00:1a.7: suspend root hub
[   14.390298] hub 3-0:1.0: hub_suspend
[   14.390314] usb usb3: bus auto-suspend
[   14.390319] usb usb3: suspend_rh
[   14.390351] hub 4-0:1.0: hub_suspend
[   14.390358] usb usb4: bus auto-suspend
[   14.390363] ehci_hcd 0000:00:1d.7: suspend root hub
[   14.390401] hub 5-0:1.0: hub_suspend
[   14.390406] usb usb5: bus auto-suspend
[   14.390410] usb usb5: suspend_rh
[   14.390438] hub 6-0:1.0: hub_suspend
[   14.390443] usb usb6: bus auto-suspend
[   14.390447] usb usb6: suspend_rh
[   14.390476] hub 7-0:1.0: hub_suspend
[   14.390481] usb usb7: bus auto-suspend
[   14.390485] usb usb7: suspend_rh
[   16.012092] ieee1394: Node removed: ID:BUS[0-00:1023]  GUID[00061b032a155b20]
[   16.146586] sdhci-pci 0000:15:00.2: PCI INT C disabled
[   18.234543] usb usb1: uevent
[   18.234661] usb 1-0:1.0: uevent
[   18.234845] usb 1-1: uevent
[   18.234960] usb 1-1:1.0: uevent
[   18.235403] usb 1-1:1.1: uevent
[   18.235677] usb 1-1:1.2: uevent
[   18.235966] usb 1-1:1.3: uevent
[   18.236240] usb 1-2: uevent
[   18.236354] usb 1-2:1.0: uevent
[   18.238291] usb usb3: uevent
[   18.238406] usb 3-0:1.0: uevent
[   18.238992] usb usb2: uevent
[   18.239108] usb 2-0:1.0: uevent
[   18.242531] usb usb5: uevent
[   18.242656] usb 5-0:1.0: uevent
[   18.243231] usb usb6: uevent
[   18.243373] usb 6-0:1.0: uevent
[   18.244505] usb usb7: uevent
[   18.244620] usb 7-0:1.0: uevent
[   18.245192] usb usb4: uevent
[   18.245316] usb 4-0:1.0: uevent
[   19.079196] usb usb4: usb auto-resume
[   19.079207] ehci_hcd 0000:00:1d.7: resume root hub
[   19.107681] hub 4-0:1.0: hub_resume
[   19.107839] usb usb7: usb auto-resume
[   19.107845] usb usb7: wakeup_rh
[   19.107860] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   19.120042] Bluetooth: L2CAP ver 2.11
[   19.120046] Bluetooth: L2CAP socket layer initialized
[   19.130737] Bluetooth: SCO (Voice Link) ver 0.6
[   19.130741] Bluetooth: SCO socket layer initialized
[   19.143441] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   19.143447] Bluetooth: BNEP filters: protocol multicast
[   19.146760] hub 7-0:1.0: hub_resume
[   19.146915] usb usb3: usb auto-resume
[   19.146920] usb usb3: wakeup_rh
[   19.148916] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   19.162295] Bridge firewalling registered
[   19.166110] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 1, phase 0, 23 us
[   19.183599] hub 3-0:1.0: hub_resume
[   19.183676] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   19.183779] usb usb5: usb auto-resume
[   19.183785] usb usb5: wakeup_rh
[   19.220253] hub 5-0:1.0: hub_resume
[   19.220335] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   19.220431] usb usb6: usb auto-resume
[   19.220436] usb usb6: wakeup_rh
[   19.260058] hub 6-0:1.0: hub_resume
[   19.260111] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   19.260385] usb usb2: usb auto-resume
[   19.260392] ehci_hcd 0000:00:1a.7: resume root hub
[   19.296798] Bluetooth: RFCOMM socket layer initialized
[   19.296822] Bluetooth: RFCOMM TTY layer initialized
[   19.296826] Bluetooth: RFCOMM ver 1.10
[   19.303405] hub 2-0:1.0: hub_resume
[   19.303491] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0000
[   20.346950] usb usb7: suspend_rh (auto-stop)
[   20.346974] usb usb3: suspend_rh (auto-stop)
[   20.347022] usb usb5: suspend_rh (auto-stop)
[   20.347065] usb usb6: suspend_rh (auto-stop)
[   21.336956] hub 4-0:1.0: hub_suspend
[   21.336973] usb usb4: bus auto-suspend
[   21.336979] ehci_hcd 0000:00:1d.7: suspend root hub
[   21.337019] hub 7-0:1.0: hub_suspend
[   21.337025] usb usb7: bus auto-suspend
[   21.337030] usb usb7: suspend_rh
[   21.337058] hub 3-0:1.0: hub_suspend
[   21.337064] usb usb3: bus auto-suspend
[   21.337067] usb usb3: suspend_rh
[   21.337093] hub 5-0:1.0: hub_suspend
[   21.337099] usb usb5: bus auto-suspend
[   21.337103] usb usb5: suspend_rh
[   21.337129] hub 6-0:1.0: hub_suspend
[   21.337134] usb usb6: bus auto-suspend
[   21.337138] usb usb6: suspend_rh
[   21.337167] hub 2-0:1.0: hub_suspend
[   21.337172] usb usb2: bus auto-suspend
[   21.337176] ehci_hcd 0000:00:1a.7: suspend root hub
[   45.389510] usb 1-1: uhci_result_common: failed with status 440000
[   45.393543] usb 1-1: uhci_result_common: failed with status 440000
[   45.397556] usb 1-1: uhci_result_common: failed with status 440000
[   45.401561] usb 1-1: uhci_result_common: failed with status 440000
[   45.405572] usb 1-1: uhci_result_common: failed with status 440000
[   45.409554] usb 1-1: uhci_result_common: failed with status 440000
[   45.413559] usb 1-1: uhci_result_common: failed with status 440000
[   45.417562] usb 1-1: uhci_result_common: failed with status 440000
[   45.421568] usb 1-1: uhci_result_common: failed with status 440000
[   45.425558] usb 1-1: uhci_result_common: failed with status 440000
[   45.429558] usb 1-1: uhci_result_common: failed with status 440000
[   45.433557] usb 1-1: uhci_result_common: failed with status 440000
[   45.437574] usb 1-1: uhci_result_common: failed with status 440000
[   45.441561] usb 1-1: uhci_result_common: failed with status 440000
[   45.445571] usb 1-1: uhci_result_common: failed with status 440000
[   45.449554] usb 1-1: uhci_result_common: failed with status 440000
[   45.453562] usb 1-1: uhci_result_common: failed with status 440000
[   45.457555] usb 1-1: uhci_result_common: failed with status 440000
[   45.461569] usb 1-1: uhci_result_common: failed with status 440000
[   45.465563] usb 1-1: uhci_result_common: failed with status 440000
[   45.469563] usb 1-1: uhci_result_common: failed with status 440000
[   45.473551] usb 1-1: uhci_result_common: failed with status 440000
[   45.477572] usb 1-1: uhci_result_common: failed with status 440000
[   45.481558] usb 1-1: uhci_result_common: failed with status 440000
[   45.485569] usb 1-1: uhci_result_common: failed with status 440000
[   45.489553] usb 1-1: uhci_result_common: failed with status 440000
[   45.493559] usb 1-1: uhci_result_common: failed with status 440000
[   45.497562] usb 1-1: uhci_result_common: failed with status 440000
[   45.501572] usb 1-1: uhci_result_common: failed with status 440000
[   45.505559] usb 1-1: uhci_result_common: failed with status 440000
[   45.509562] usb 1-1: uhci_result_common: failed with status 440000
[   45.513561] usb 1-1: uhci_result_common: failed with status 440000
[   45.517568] usb 1-1: uhci_result_common: failed with status 440000
[   45.521557] usb 1-1: uhci_result_common: failed with status 440000
[   45.525572] usb 1-1: uhci_result_common: failed with status 440000
[   45.529552] usb 1-1: uhci_result_common: failed with status 440000
[   45.533559] usb 1-1: uhci_result_common: failed with status 440000
[   45.537562] usb 1-1: uhci_result_common: failed with status 440000
[   45.541572] usb 1-1: uhci_result_common: failed with status 440000
[   45.545561] usb 1-1: uhci_result_common: failed with status 440000
[   45.549565] usb 1-1: uhci_result_common: failed with status 440000
[   45.553552] usb 1-1: uhci_result_common: failed with status 440000
[   45.557571] usb 1-1: uhci_result_common: failed with status 440000
[   45.561562] usb 1-1: uhci_result_common: failed with status 440000
[   45.565567] usb 1-1: uhci_result_common: failed with status 440000
[   45.569558] usb 1-1: uhci_result_common: failed with status 440000
[   45.573561] usb 1-1: uhci_result_common: failed with status 440000
[   45.577560] usb 1-1: uhci_result_common: failed with status 440000
[   45.581569] usb 1-1: uhci_result_common: failed with status 440000
[   45.585559] usb 1-1: uhci_result_common: failed with status 440000
[   45.589565] usb 1-1: uhci_result_common: failed with status 440000
[   45.593552] usb 1-1: uhci_result_common: failed with status 440000
[   45.596932] usb 1-1: uhci_result_common: failed with status 440000
[   45.596997] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[   45.597018] uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
[   45.597042] hub 1-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
[   45.597048] usb 1-1: USB disconnect, address 2
[   45.597052] usb 1-1: unregistering device
[   45.597058] usb 1-1: usb_disable_device nuking all URBs
[   45.597071] uhci_hcd 0000:00:1a.0: shutdown urb ffff8800796f5300 ep1in-intr
[   45.597529] btusb_intr_complete: hci0 urb ffff8800796f5300 failed to resubmit (19)
[   45.597588] uhci_hcd 0000:00:1a.0: release dev 2 ep81-INT, period 1, phase 0, 23 us
[   45.597639] usb 1-1: unregistering interface 1-1:1.0
[   45.598099] btusb_send_frame: hci0 urb ffff8800797ee480 submission failed
[   45.848069] usb 1-1:1.0: uevent
[   45.848097] usb 1-1: unregistering interface 1-1:1.1
[   45.848399] usb 1-1:1.1: uevent
[   45.848421] usb 1-1: unregistering interface 1-1:1.2
[   45.848649] usb 1-1:1.2: uevent
[   45.848670] usb 1-1: unregistering interface 1-1:1.3
[   45.848720] usb 1-1:1.3: uevent
[   45.849043] usb 1-1: uevent
[   45.966998] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
[   64.277851] [drm] Initialized drm 1.1.0 20060810
[   64.286889] pci 0000:00:02.0: power state changed by ACPI to D0
[   64.286905] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   64.286913] pci 0000:00:02.0: setting latency timer to 64
[   64.287124] pci 0000:00:02.0: irq 312 for MSI/MSI-X
[   64.287689] [drm] Initialized i915 1.6.0 20080730 on minor 0
[  122.598808] ACPI: \_SB_.GDCK - undocking
[  127.970866] PM: Syncing filesystems ... done.
[  127.975916] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  127.976707] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  128.000215] pci 0000:00:02.0: power state changed by ACPI to D3
[  128.001567] usb 1-2: usb suspend
[  128.013471] hub 1-0:1.0: hub_suspend
[  128.013477] usb usb1: bus suspend
[  128.013480] usb usb1: suspend_rh
[  129.226910] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  129.560144] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  134.560128] ata1.00: qc timeout (cmd 0xec)
[  134.560139] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[  134.560142] ata1.00: revalidation failed (errno=-5)
[  134.880121] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  144.880144] ata1.00: qc timeout (cmd 0xec)
[  144.880151] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[  144.880154] ata1.00: revalidation failed (errno=-5)
[  145.200144] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  175.200104] ata1.00: qc timeout (cmd 0xec)
[  175.200113] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[  175.200116] ata1.00: revalidation failed (errno=-5)
[  175.200172] ata1.00: disabled
[  175.213457] ata5: port disabled. ignoring.
[  175.213526] ata_piix 0000:00:1f.1: PCI INT C disabled
[  175.213745] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[  175.229231] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[  175.229238] ehci_hcd 0000:00:1d.7: --> PCI D3
[  175.229248] uhci_hcd 0000:00:1d.2: uhci_pci_suspend
[  175.229313] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  175.229315] uhci_hcd 0000:00:1d.2: --> PCI D0/legacy
[  175.229316] uhci_hcd 0000:00:1d.1: uhci_pci_suspend
[  175.229381] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  175.229382] uhci_hcd 0000:00:1d.1: --> PCI D0/legacy
[  175.229384] uhci_hcd 0000:00:1d.0: uhci_pci_suspend
[  175.229448] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  175.229450] uhci_hcd 0000:00:1d.0: --> PCI D0/legacy
[  175.229771] HDA Intel 0000:00:1b.0: PCI INT B disabled
[  175.240219] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[  175.255513] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[  175.255519] ehci_hcd 0000:00:1a.7: --> PCI D3
[  175.255521] uhci_hcd 0000:00:1a.1: uhci_pci_suspend
[  175.255588] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[  175.255589] uhci_hcd 0000:00:1a.1: --> PCI D0/legacy
[  175.255591] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[  175.255655] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  175.255656] uhci_hcd 0000:00:1a.0: --> PCI D0/legacy
[  175.258116] e1000e 0000:00:19.0: PCI INT A disabled
[  175.275302] ACPI: Preparing to enter system sleep state S3
[  175.289251] Disabling non-boot CPUs ...
[  175.291468] CPU 1 is now offline
[  175.291470] SMP alternatives: switching to UP code
[  175.353575] CPU1 is down
[  175.353693] Extended CMOS year: 2000
[  175.353693] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[  175.353693] Back to C!
[  175.353693] Extended CMOS year: 2000
[  175.353693] Enabling non-boot CPUs ...
[  175.353693] SMP alternatives: switching to SMP code
[  175.417579] Booting processor 1 APIC 0x1 ip 0x6000
[  175.348958] Initializing CPU#1
[  175.348958] Calibrating delay using timer specific routine.. 4789.54 BogoMIPS (lpj=7980064)
[  175.348958] CPU: L1 I cache: 32K, L1 D cache: 32K
[  175.348958] CPU: L2 cache: 4096K
[  175.348958] CPU: Physical Processor ID: 0
[  175.348958] CPU: Processor Core ID: 1
[  175.348958] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[  175.511235] CPU1: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0a
[  175.514172] Switched to high resolution mode on CPU 1
[  175.523976] CPU1 is up
[  175.523978] ACPI: Waking up from system sleep state S3
[  175.565406] ACPI: EC: non-query interrupt received, switching to interrupt mode
[  175.606001] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900403)
[  175.608694] pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
[  175.620261] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[  175.620273] e1000e 0000:00:19.0: setting latency timer to 64
[  175.620331] e1000e 0000:00:19.0: irq 313 for MSI/MSI-X
[  175.899440] uhci_hcd 0000:00:1a.0: PCI legacy resume
[  175.899447] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[  175.899453] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  175.899510] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[  175.899515] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x2f00
[  175.899516] uhci_hcd 0000:00:1a.0: Performing full reset
[  175.899539] usb usb1: root hub lost power or was reset
[  175.899541] usb usb1: suspend_rh
[  175.899572] uhci_hcd 0000:00:1a.1: PCI legacy resume
[  175.902777] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[  175.902783] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[  175.902789] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[  175.902843] uhci_hcd 0000:00:1a.1: uhci_pci_resume
[  175.902848] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x2000
[  175.902849] uhci_hcd 0000:00:1a.1: Performing full reset
[  175.902872] usb usb3: root hub lost power or was reset
[  175.902873] usb usb3: suspend_rh
[  175.902899] ehci_hcd 0000:00:1a.7: PCI D0, from previous PCI D3
[  175.903417] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[  175.903430] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[  175.903441] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[  175.916797] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
[  175.916845] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[  175.916860] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  175.916947] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20002020, writing 0x2020)
[  175.916982] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  175.917041] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[  175.917078] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  175.917134] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[  175.917166] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x7 (was 0x20004040, writing 0x4040)
[  175.917184] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  175.917244] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[  175.917273] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20005050, writing 0x5050)
[  175.917298] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  175.917344] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[  175.917380] pcieport-driver 0000:00:1c.4: restoring config space at offset 0x7 (was 0x20006060, writing 0x6060)
[  175.917398] pcieport-driver 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  175.917446] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[  175.917453] uhci_hcd 0000:00:1d.0: PCI legacy resume
[  175.918271] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  175.918277] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  175.918283] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  175.918356] uhci_hcd 0000:00:1d.0: uhci_pci_resume
[  175.918361] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2f00
[  175.918362] uhci_hcd 0000:00:1d.0: Performing full reset
[  175.918384] usb usb5: root hub lost power or was reset
[  175.918385] usb usb5: suspend_rh
[  175.918402] uhci_hcd 0000:00:1d.1: PCI legacy resume
[  175.918407] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[  175.918413] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  175.918478] uhci_hcd 0000:00:1d.1: uhci_pci_resume
[  175.918483] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[  175.918484] uhci_hcd 0000:00:1d.1: Performing full reset
[  175.918507] usb usb6: root hub lost power or was reset
[  175.918508] usb usb6: suspend_rh
[  175.918524] uhci_hcd 0000:00:1d.2: PCI legacy resume
[  175.919032] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[  175.919040] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[  175.919051] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  175.919127] uhci_hcd 0000:00:1d.2: uhci_pci_resume
[  175.919134] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[  175.919136] uhci_hcd 0000:00:1d.2: Performing full reset
[  175.919167] usb usb7: root hub lost power or was reset
[  175.919169] usb usb7: suspend_rh
[  175.919205] ehci_hcd 0000:00:1d.7: PCI D0, from previous PCI D3
[  175.919732] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[  175.919744] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[  175.919755] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  175.919908] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100005, writing 0x100007)
[  175.919942] pci 0000:00:1e.0: setting latency timer to 64
[  175.920081] ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
[  175.920096] ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[  175.920103] ata_piix 0000:00:1f.1: setting latency timer to 64
[  175.920163] ata5: port disabled. ignoring.
[  175.933537] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[  175.933631] ahci 0000:00:1f.2: setting latency timer to 64
[  175.933843] pci 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x40100102)
[  175.933889] pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  175.933965] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  175.934047] pci 0000:15:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[  175.940343] thinkpad_acpi: ACPI backlight control delay disabled
[  175.942379] usb usb1: usb resume
[  175.942382] usb usb1: wakeup_rh
[  175.976767] hub 1-0:1.0: hub_reset_resume
[  175.976770] hub 1-0:1.0: trying to enable port power on non-switchable hub
[  176.080674] ata4.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
[  176.080676] ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[  176.080751] uhci_hcd 0000:00:1a.0: port 2 portsc 008a,00
[  176.080753] hub 1-0:1.0: port 2: status 0100 change 0003
[  176.081736] ata4.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[  176.082711] ata4.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[  176.100578] ata4.00: configured for UDMA/33
[  176.183463] usb usb2: usb resume
[  176.183469] ehci_hcd 0000:00:1a.7: resume root hub
[  176.250123] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  176.327383] ehci_hcd 0000:00:1a.7: port 2 full speed --> companion
[  176.327385] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
[  176.327628] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001000 POWER sig=se0
[  176.327633] ehci_hcd 0000:00:1a.7: failed handover port 1: 1000
[  176.340107] hub 2-0:1.0: hub_resume
[  176.340121] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[  176.443459] usb usb4: usb resume
[  176.443464] ehci_hcd 0000:00:1d.7: resume root hub
[  176.483437] hub 4-0:1.0: hub_resume
[  176.483499] uhci_hcd 0000:00:1a.0: port 2 portsc 0093,00
[  176.483509] usb 1-2: finish reset-resume
[  176.590109] usb 1-2: reset full speed USB device using uhci_hcd and address 3
[  176.716767] usb 1-2: ep0 maxpacket = 8
[  176.734613] pci 0000:00:02.0: power state changed by ACPI to D0
[  176.734735] pci 0000:00:02.0: power state changed by ACPI to D0
[  176.734743] pci 0000:00:02.0: setting latency timer to 64
[  176.736533] Restarting tasks ... <7>hub 1-0:1.0: state 7 ports 2 chg 0004 evt 0004
[  176.746044] hub 1-0:1.0: port 2, status 0103, change 0000, 12 Mb/s
[  176.746047] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0000
[  176.746050] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
[  176.746621] done.
[  179.346953] hub 2-0:1.0: hub_suspend
[  179.346970] usb usb2: bus auto-suspend
[  179.346976] ehci_hcd 0000:00:1a.7: suspend root hub
[  179.347012] hub 4-0:1.0: hub_suspend
[  179.347018] usb usb4: bus auto-suspend
[  179.347022] ehci_hcd 0000:00:1d.7: suspend root hub
[  179.963672] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[  179.963683] end_request: I/O error, dev sda, sector 51191615
[  179.963715] Buffer I/O error on device sda2, logical block 6398944
[  179.963740] lost page write due to I/O error on sda2
[  179.963748] Buffer I/O error on device sda2, logical block 6398945
[  179.963773] lost page write due to I/O error on sda2
[  179.963795] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[  179.963802] end_request: I/O error, dev sda, sector 51191815
[  179.963827] Buffer I/O error on device sda2, logical block 6398969
[  179.963852] lost page write due to I/O error on sda2
[  179.963866] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[  179.963873] end_request: I/O error, dev sda, sector 51192207
[  179.963898] Buffer I/O error on device sda2, logical block 6399018
[  179.963922] lost page write due to I/O error on sda2
[  179.963928] Buffer I/O error on device sda2, logical block 6399019
[  179.963953] lost page write due to I/O error on sda2
[  179.963959] Buffer I/O error on device sda2, logical block 6399020
[  179.963983] lost page write due to I/O error on sda2
[  179.963989] Buffer I/O error on device sda2, logical block 6399021
[  179.964014] lost page write due to I/O error on sda2
[  179.964020] Buffer I/O error on device sda2, logical block 6399022
[  179.964045] lost page write due to I/O error on sda2
[  179.964050] Buffer I/O error on device sda2, logical block 6399023
[  179.964075] lost page write due to I/O error on sda2
[  179.964087] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[  179.964093] end_request: I/O error, dev sda, sector 51348311
[  179.967580] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[  179.967589] end_request: I/O error, dev sda, sector 14322943
[  179.967628] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[  179.967636] end_request: I/O error, dev sda, sector 51122479
[  179.967670] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[  179.967678] end_request: I/O error, dev sda, sector 51192087
[  179.967746] JBD: Detected IO errors while flushing file data on sda2
[  179.967889] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[  179.967898] end_request: I/O error, dev sda, sector 55842855
[  179.967987] Aborting journal on device sda2.
[  179.968029] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[  179.968038] end_request: I/O error, dev sda, sector 55840847
[  179.968086] journal commit I/O error
[  179.968697] ext3_abort called.
[  179.968720] EXT3-fs error (device sda2): ext3_journal_start_sb: Detected aborted journal
[  179.968798] Remounting filesystem read-only
[  180.154330] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[  180.154340] end_request: I/O error, dev sda, sector 66411583
[  180.154414] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[  180.154420] end_request: I/O error, dev sda, sector 66411583
[  180.187587] usb usb4: usb auto-resume
[  180.187598] ehci_hcd 0000:00:1d.7: resume root hub
[  180.227752] hub 4-0:1.0: hub_resume
[  180.227869] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
[  180.228003] usb usb7: usb auto-resume
[  180.228009] usb usb7: wakeup_rh
[  180.263596] hub 7-0:1.0: hub_reset_resume
[  180.263603] hub 7-0:1.0: trying to enable port power on non-switchable hub
[  180.367031] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  180.367104] usb usb3: usb auto-resume
[  180.367109] usb usb3: wakeup_rh
[  180.403434] hub 3-0:1.0: hub_reset_resume
[  180.403440] hub 3-0:1.0: trying to enable port power on non-switchable hub
[  180.506890] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  180.506966] usb usb5: usb auto-resume
[  180.506971] usb usb5: wakeup_rh
[  180.543428] hub 5-0:1.0: hub_reset_resume
[  180.543435] hub 5-0:1.0: trying to enable port power on non-switchable hub
[  180.646895] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  180.646977] usb usb6: usb auto-resume
[  180.646982] usb usb6: wakeup_rh
[  180.683436] hub 6-0:1.0: hub_reset_resume
[  180.683443] hub 6-0:1.0: trying to enable port power on non-switchable hub
[  180.786835] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  180.787059] usb usb2: usb auto-resume
[  180.787069] ehci_hcd 0000:00:1a.7: resume root hub
[  180.850259] hub 2-0:1.0: hub_resume
[  180.850370] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0000
[  181.346934] usb usb7: suspend_rh (auto-stop)
[  181.596749] usb usb3: suspend_rh (auto-stop)
[  181.596793] usb usb5: suspend_rh (auto-stop)
[  181.846931] usb usb6: suspend_rh (auto-stop)
[  182.337754] hub 4-0:1.0: hub_suspend
[  182.337769] usb usb4: bus auto-suspend
[  182.337775] ehci_hcd 0000:00:1d.7: suspend root hub
[  182.366923] hub 7-0:1.0: hub_suspend
[  182.366940] usb usb7: bus auto-suspend
[  182.366945] usb usb7: suspend_rh
[  182.506933] hub 3-0:1.0: hub_suspend
[  182.506948] usb usb3: bus auto-suspend
[  182.506953] usb usb3: suspend_rh
[  183.336946] hub 5-0:1.0: hub_suspend
[  183.336961] usb usb5: bus auto-suspend
[  183.336966] usb usb5: suspend_rh
[  183.336996] hub 6-0:1.0: hub_suspend
[  183.337002] usb usb6: bus auto-suspend
[  183.337006] usb usb6: suspend_rh
[  183.346974] hub 2-0:1.0: hub_suspend
[  183.346990] usb usb2: bus auto-suspend
[  183.346995] ehci_hcd 0000:00:1a.7: suspend root hub
[  266.270707] e1000e 0000:00:19.0: irq 313 for MSI/MSI-X
[  266.323633] e1000e 0000:00:19.0: irq 313 for MSI/MSI-X
[  302.977656] 0000:00:19.0: eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[  302.977663] 0000:00:19.0: eth0: 10/100 speed: disabling TSO

--M9NhX3UHpAaciwkO--
