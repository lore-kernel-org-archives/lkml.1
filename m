Return-Path: <linux-kernel-owner+w=401wt.eu-S1761492AbYFIOtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761492AbYFIOtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYFIOtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:49:41 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:57754 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbYFIOti convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:49:38 -0400
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Mon, 9 Jun 2008 16:49:32 +0200
User-Agent: KMail/1.9.9
Cc: Peer Chen <pchen@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kuan Luo <kluo@nvidia.com>
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <484CF531.30804@gmail.com> <484CFB2E.30202@gmail.com>
In-Reply-To: <484CFB2E.30202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806091649.32637.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag, 9. Juni 2008, Tejun Heo wrote:
> Volker, can you please test the attached patch?

I patched  2.6.26-rc5 with it. It booted fine without pci=nomsi and ncq got 
turned on. If I see problems with ncq I report back.

cat /proc/interrupts
           CPU0       CPU1
  0:         37          1   IO-APIC-edge      timer
  1:          0       1535   IO-APIC-edge      i8042
  7:          1          0   IO-APIC-edge
  8:          0          1   IO-APIC-edge      rtc
  9:          0          1   IO-APIC-fasteoi   acpi
 12:          0          3   IO-APIC-edge      i8042
 17:          5       1896   IO-APIC-fasteoi   nvidia
 18:          0          0   IO-APIC-fasteoi   EMU10K1
 22:          4       2322   IO-APIC-fasteoi   ehci_hcd:usb1
 23:         17      18904   IO-APIC-fasteoi   ahci
315:          2        305   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:      40225      31947   Local timer interrupts
RES:       9609       7702   Rescheduling interrupts
CAL:       9872       3693   function call interrupts
TLB:       1179       1245   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          1

[    0.000000] Linux version 2.6.26-rc5r4mcp65patch (root@energy) (gcc version 
4.2.4 (Gentoo 4.2.4 p1.0)) #3 SMP Mon Jun 9 16:33:24 CEST 2008
[    0.000000] Command line: root=/dev/sda3 nmi_watchdog=0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] max_pfn_mapped = 1245184
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] init_memory_mapping
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98F0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT   4000809 MSFT       
97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       
97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19201      201 INTL 
20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC   4000809 MSFT       
97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG   4000809 MSFT       
97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM   4000809 MSFT       
97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0  4000809 MSFT       
97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD         
1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-5a3de7] TEXT DATA BSS
[    0.000000]   early res: 3 [9fc00-fffff] BIOS reserved
[    0.000000]   early res: 4 [8000-dfff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe20002dfffff] PMD -> 
[ffff810001200000-ffff810003ffffff] on node 0
[    0.000000]  [ffffe20002e00000-ffffe200043fffff] PMD -> 
[ffff81000c000000-ffff81000d5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1036 pages reserved
[    0.000000]   DMA zone: 2907 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cffb0000 - 
00000000cffc0000
[    0.000000] PM: Registered nosave memory: 00000000cffc0000 - 
00000000cfff0000
[    0.000000] PM: Registered nosave memory: 00000000cfff0000 - 
00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 
00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 
00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 
00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 
00000000ff380000
[    0.000000] PM: Registered nosave memory: 00000000ff380000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: 
d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 33264 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 1030339
[    0.000000] Kernel command line: root=/dev/sda3 nmi_watchdog=0
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.000000] time.c: Detected 3013.874 MHz processor.
[    0.003333] spurious 8259A interrupt: IRQ7.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[    0.003333] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.003333] Checking aperture...
[    0.003333] Node 0: aperture @ 4000000 size 32 MB
[    0.003333] Aperture pointing to e820 RAM. Ignoring.
[    0.003333] No AGP bridge found
[    0.003333] Your BIOS doesn't leave a aperture memory hole
[    0.003333] Please enable the IOMMU option in the BIOS setup
[    0.003333] This costs you 64 MB of RAM
[    0.003333] Mapping aperture over 65536 KB of RAM @ 4000000
[    0.003333] PM: Registered nosave memory: 0000000004000000 - 
0000000008000000
[    0.003333] Memory: 4047784k/4980736k available (2245k kernel code, 145372k 
reserved, 916k data, 204k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, 
Nodes=1
[    0.003333] hpet clockevent registered
[    0.086484] Calibrating delay using timer specific routine.. 6034.74 
BogoMIPS (lpj=10053996)
[    0.086572] Mount-cache hash table entries: 256
[    0.086661] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[    0.086661] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.086661] CPU: Physical Processor ID: 0
[    0.086661] CPU: Processor Core ID: 0
[    0.086661] ACPI: Core revision 20080321
[    0.123325] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 
03
[    0.123325] Using local APIC timer interrupts.
[    0.126658] APIC timer calibration result 12557812
[    0.126658] Detected 12.557 MHz APIC timer.
[    0.126658] Booting processor 1/1 ip 6000
[    0.136657] Initializing CPU#1
[    0.136657] Calibrating delay using timer specific routine.. 6030.96 
BogoMIPS (lpj=10046348)
[    0.136657] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[    0.136657] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.136657] CPU: Physical Processor ID: 0
[    0.136657] CPU: Processor Core ID: 1
[    0.136657] x86 PAT enabled: cpu 1, old 0x7040600070406, new 
0x7010600070106
[    0.219985] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 
03
[    0.219985] Brought up 2 CPUs
[    0.219985] Total of 2 processors activated (12065.71 BogoMIPS).
[    0.219985] net_namespace: 936 bytes
[    0.219985] NET: Registered protocol family 16
[    0.219985] No dock devices found.
[    0.219985] node 0 link 0: io port [1000, ffffff]
[    0.219985] node 0 link 0: io port [2000, 2fff]
[    0.219985] TOM: 00000000d0000000 aka 3328M
[    0.219985] node 0 link 0: mmio [e0000000, efffffff]
[    0.219985] node 0 link 0: mmio [a0000, bffff]
[    0.219985] node 0 link 0: mmio [d0000000, fe0bffff]
[    0.219985] TOM2: 0000000130000000 aka 4864M
[    0.219985] bus: [00,07] on node 0 link 0
[    0.219985] bus: 00 index 0 io port: [0, ffff]
[    0.219985] bus: 00 index 1 mmio: [d0000000, ffffffff]
[    0.219985] bus: 00 index 2 mmio: [a0000, bffff]
[    0.219985] bus: 00 index 3 mmio: [130000000, fcffffffff]
[    0.219985] ACPI: bus type pci registered
[    0.219985] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 
255
[    0.219985] PCI: Not using MMCONFIG.
[    0.219985] PCI: Using configuration type 1 for base access
[    0.219985] ACPI: EC: Look up EC in DSDT
[    0.226551] ACPI: Interpreter enabled
[    0.226589] ACPI: (supports S0 S1 S3 S4 S5)
[    0.226651] ACPI: Using IOAPIC for interrupt routing
[    0.226651] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 
255
[    0.229985] PCI: MCFG area at e0000000 reserved in ACPI motherboard 
resources
[    0.238212] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.246650] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.246650] PCI: Transparent bridge - 0000:00:08.0
[    0.246650] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.246650] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.246650] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.246650] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.246650] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.246650] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.253316] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[    0.253316] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[    0.253316] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *10
[    0.253316] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, 
disabled.
[    0.253316] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, 
disabled.
[    0.253316] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.253316] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, 
disabled.
[    0.253704] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[    0.254066] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[    0.254427] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, 
disabled.
[    0.254812] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[    0.255172] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, 
disabled.
[    0.255558] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, 
disabled.
[    0.255943] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.256303] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, 
disabled.
[    0.256649] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[    0.257014] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, 
disabled.
[    0.257425] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, 
disabled.
[    0.257811] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, 
disabled.
[    0.258197] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, 
disabled.
[    0.259113] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.259451] pnp: PnP ACPI init
[    0.259490] ACPI: bus type pnp registered
[    0.263316] pnp: PnP ACPI: found 13 devices
[    0.263316] ACPI: ACPI bus type pnp unregistered
[    0.263316] SCSI subsystem initialized
[    0.263316] libata version 3.00 loaded.
[    0.263316] usbcore: registered new interface driver usbfs
[    0.263316] usbcore: registered new interface driver hub
[    0.263316] usbcore: registered new device driver usb
[    0.263316] PCI: Using ACPI for IRQ routing
[    0.279981] PCI-DMA: Disabling AGP.
[    0.279981] PCI-DMA: aperture base @ 4000000 size 65536 KB
[    0.279981] PCI-DMA: using GART IOMMU.
[    0.279981] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.279981] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.279981] hpet0: 3 32-bit timers, 25000000 Hz
[    0.280985] Switched to high resolution mode on CPU 0
[    0.281133] Switched to high resolution mode on CPU 1
[    0.287677] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.287717] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.287757] system 00:05: ioport range 0x2000-0x207f has been reserved
[    0.287797] system 00:05: ioport range 0x2080-0x20ff has been reserved
[    0.287836] system 00:05: ioport range 0x2400-0x247f has been reserved
[    0.287876] system 00:05: ioport range 0x2480-0x24ff has been reserved
[    0.287916] system 00:05: ioport range 0x2800-0x287f has been reserved
[    0.287955] system 00:05: ioport range 0x2880-0x28ff has been reserved
[    0.287995] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[    0.288035] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[    0.291438] system 00:05: iomem range 0xfee01000-0xfeefffff could not be 
reserved
[    0.291486] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.291525] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.291565] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.291604] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.291643] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.291683] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.291722] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.291761] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.291801] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.291843] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.291882] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.291922] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.291961] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.292000] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.292039] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.292079] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.292118] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.292157] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.292197] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.292236] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.292275] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.292314] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.292359] system 00:07: iomem range 0xfec00000-0xfec00fff could not be 
reserved
[    0.292406] system 00:07: iomem range 0xfee00000-0xfee00fff could not be 
reserved
[    0.292454] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.292493] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.292533] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.292572] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.292611] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.292651] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.292690] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.292729] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.292768] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.292808] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.292847] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.292886] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.292926] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.292965] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.293004] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.293043] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.293083] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.293122] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.293161] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.293201] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.293240] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.293279] system 00:07: iomem range 0x0-0x0 could not be reserved
[    0.293322] system 00:0a: ioport range 0x290-0x29f has been reserved
[    0.293362] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293402] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293441] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293480] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293520] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293559] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293598] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293637] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293677] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293716] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293755] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293794] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293800] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293800] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293800] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293800] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293800] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293800] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293800] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293800] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293800] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293800] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293800] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293800] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.293848] system 00:0b: iomem range 0xe0000000-0xefffffff has been 
reserved
[    0.293888] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.293928] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.293967] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294006] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294046] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294085] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294124] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294163] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294203] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294242] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294281] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294320] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294360] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294399] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294438] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294477] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294517] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294556] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294595] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294634] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294679] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294718] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294757] system 00:0b: iomem range 0x0-0x0 could not be reserved
[    0.294800] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.294839] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[    0.294879] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.294919] system 00:0c: iomem range 0x100000-0xcfffffff could not be 
reserved
[    0.294967] system 00:0c: iomem range 0xff380000-0xffffffff could not be 
reserved
[    0.295015] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295054] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295093] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295132] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295172] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295211] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295250] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295289] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295329] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295368] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295407] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295446] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295486] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295525] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295564] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295603] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295643] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295682] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.295721] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.296681] PCI: Bridge: 0000:00:08.0
[    0.296681]   IO window: d000-dfff
[    0.296681]   MEM window: 0xf9f00000-0xf9ffffff
[    0.296681]   PREFETCH window: 0x00000000f0000000-0x00000000f00fffff
[    0.296681] PCI: Bridge: 0000:00:0b.0
[    0.296681]   IO window: c000-cfff
[    0.296681]   MEM window: 0xf9e00000-0xf9efffff
[    0.296681]   PREFETCH window: disabled.
[    0.296681] PCI: Bridge: 0000:00:0c.0
[    0.296681]   IO window: disabled.
[    0.296681]   MEM window: disabled.
[    0.296681]   PREFETCH window: disabled.
[    0.296681] PCI: Bridge: 0000:00:0d.0
[    0.296681]   IO window: e000-efff
[    0.296681]   MEM window: 0xfa000000-0xfebfffff
[    0.296681]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.296681] PCI: Bridge: 0000:00:0e.0
[    0.296681]   IO window: disabled.
[    0.296681]   MEM window: disabled.
[    0.296681]   PREFETCH window: disabled.
[    0.296681] PCI: Setting latency timer of device 0000:00:08.0 to 64
[    0.296681] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.296681] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.296681] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.296681] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.296681] NET: Registered protocol family 2
[    0.326779] IP route cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[    0.327277] TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)
[    0.328733] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.329219] TCP: Hash tables configured (established 262144 bind 65536)
[    0.329258] TCP reno registered
[    0.336778] NET: Registered protocol family 1
[    0.340005] Loading Reiser4. See www.namesys.com for a description of 
Reiser4.
[    0.340005] msgmni has been set to 7906 for ipc namespace ffffffff804fd280
[    0.340005] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
254)
[    0.340005] io scheduler noop registered
[    0.340005] io scheduler cfq registered (default)
[    0.340005] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.340005] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.340005] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.340005] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.340005] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    0.340005] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    0.340005] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.340005] pci 0000:04:00.0: Boot video device
[    0.340005] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.340005] assign_interrupt_mode Found MSI capability
[    0.340005] Allocate Port Service[0000:00:0b.0:pcie00]
[    0.340005] Allocate Port Service[0000:00:0b.0:pcie03]
[    0.340005] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.340005] assign_interrupt_mode Found MSI capability
[    0.340005] Allocate Port Service[0000:00:0c.0:pcie00]
[    0.340005] Allocate Port Service[0000:00:0c.0:pcie03]
[    0.340005] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.340005] assign_interrupt_mode Found MSI capability
[    0.340005] Allocate Port Service[0000:00:0d.0:pcie00]
[    0.340005] Allocate Port Service[0000:00:0d.0:pcie03]
[    0.340005] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.340005] assign_interrupt_mode Found MSI capability
[    0.340005] Allocate Port Service[0000:00:0e.0:pcie00]
[    0.340005] Allocate Port Service[0000:00:0e.0:pcie03]
[    0.340005] input: Power Button (FF) as /class/input/input0
[    0.340005] ACPI: Power Button (FF) [PWRF]
[    0.340005] input: Power Button (CM) as /class/input/input1
[    0.340005] ACPI: Power Button (CM) [PWRB]
[    0.340005] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.343347] ACPI: ACPI0007:01 is registered as cooling_device1
[    0.373337] Real Time Clock Driver v1.12ac
[    0.373337] hpet_resources: 0xfed00000 is busy
[    0.373337] Linux agpgart interface v0.103
[    0.377003] Driver 'sd' needs updating - please use bus_type methods
[    0.377003] ahci 0000:00:0a.0: version 3.0
[    0.377003] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.377003] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
(level, low) -> IRQ 23
[    0.390420] ahci 0000:00:0a.0: controller can do NCQ, turning on CAP_NCQ
[    1.394487] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
impl SATA mode
[    1.394536] ahci 0000:00:0a.0: flags: 64bit ncq sntf led clo pmp pio
[    1.394576] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.396672] scsi0 : ahci
[    1.396672] scsi1 : ahci
[    1.396672] scsi2 : ahci
[    1.396672] scsi3 : ahci
[    1.396672] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq 23
[    1.396672] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq 23
[    1.396672] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq 23
[    1.396672] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq 23
[    1.713347] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.719618] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7
[    1.719618] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.723338] ata1.00: configured for UDMA/133
[    2.043345] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.050506] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[    2.050506] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.050506] ata2.00: configured for UDMA/133
[    2.370012] ata3: SATA link down (SStatus 0 SControl 300)
[    2.690011] ata4: SATA link down (SStatus 0 SControl 300)
[    2.690011] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 
PQ: 0 ANSI: 5
[    2.690011] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 
MB)
[    2.690011] sd 0:0:0:0: [sda] Write Protect is off
[    2.690011] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.690011] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    2.690011] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 
MB)
[    2.690012] sd 0:0:0:0: [sda] Write Protect is off
[    2.690012] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.690012] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    2.690012]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    2.714170] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.714170] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.714170] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[    2.714170] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[    2.714170] sd 1:0:0:0: [sdb] Write Protect is off
[    2.714170] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.714170] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    2.714170] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[    2.714170] sd 1:0:0:0: [sdb] Write Protect is off
[    2.724193] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.724208] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    2.724257]  sdb: sdb1 sdb2
[    2.730838] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.730838] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.730838] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 
irq 1,12
[    2.733338] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.733379] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.760838] cpuidle: using governor ladder
[    2.760838] cpuidle: using governor menu
[    2.760838] usbcore: registered new interface driver usbhid
[    2.760838] usbhid: v2.6:USB HID core driver
[    2.760838] TCP cubic registered
[    2.760838] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 
6000+ processors (2 cpu cores) (version 2.20.00)
[    2.760838] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[    2.760838] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[    2.760838] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[    2.760838] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[    2.760838] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[    2.760838] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[    2.760838] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[    2.760838] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[    2.781278] input: AT Translated Set 2 keyboard as /class/input/input2
[    2.867501] reiser4: sda3: found disk format 4.0.0.
[    4.500844] Clocksource tsc unstable (delta = -184281406 ns)
[    8.194169] VFS: Mounted root (reiser4 filesystem) readonly.
[    8.194169] Freeing unused kernel memory: 204k freed
[   29.834167] r8169 Gigabit Ethernet driver 2.2LK loaded
[   29.834167] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   29.834167] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 
(level, low) -> IRQ 19
[   29.834167] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   29.834167] eth0: RTL8168b/8111b at 0xffffc2000004a000, 00:19:66:47:f3:cb, 
XID 38000000 IRQ 315
[   29.853784] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   29.853792] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 
(level, low) -> IRQ 22
[   29.853805] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   29.853807] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   29.854168] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus 
number 1
[   29.854168] ehci_hcd 0000:00:02.1: debug port 1
[   29.854168] PCI: cache line size of 64 is not supported by device 
0000:00:02.1
[   29.854168] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   29.861301] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 
Dec 2004
[   29.861372] usb usb1: configuration #1 chosen from 1 choice
[   29.861395] hub 1-0:1.0: USB hub found
[   29.861402] hub 1-0:1.0: 10 ports detected
[   30.190910] usb 1-4: new high speed USB device using ehci_hcd and address 2
[   30.264358] reiser4: sda5: found disk format 4.0.0.
[   30.315221] usb 1-4: configuration #1 chosen from 1 choice
[   30.315532] hub 1-4:1.0: USB hub found
[   30.315800] hub 1-4:1.0: 4 ports detected
[   30.647509] usb 1-6: new high speed USB device using ehci_hcd and address 3
[   30.777158] usb 1-6: configuration #1 chosen from 1 choice
[   30.964271] usb 1-4.1: new low speed USB device using ehci_hcd and address 
4
[cut off lots of usb loading crap because I forgot to disconnect two devices]

Glück Auf,
Volker
