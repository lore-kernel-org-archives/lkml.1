Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYHNEWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYHNEWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 00:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYHNEWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 00:22:31 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:44953 "EHLO
	QMTA05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbYHNEW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 00:22:28 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Aug 2008 00:22:28 EDT
X-Authority-Analysis: v=1.0 c=1 a=YO9n0XYpXt4A:10 a=sigIMF2fkcgA:10
 a=u9gV1CbJwJOn8F3uClMA:9 a=YJGNQDhtIFp-uIF3jKsA:7
 a=rYvfL4icqr2OuMpyhJ1GAr5yoHUA:4 a=b8hG5vVbyAkA:10
Message-ID: <6b2d1a5d2475e6be79d9ad459579f040.squirrel@www.mannymax.net>
Date: Wed, 13 Aug 2008 23:16:20 -0500 (Central Standard Time)
Subject: SATA Cold Boot Problems with 2.6.27-rc[23] on nVidia 680i
From: "Manny Maxwell" <mannymax@mannymax.net>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been experiencing nasty intermittent boot problems on recent -git
kernels. The problem is not readily reproducible; I tried to bisect and
couldn't trigger it at all, but if I leave the machine off for at least an
hour or so it triggers and is quite obvious (the kernel halts completely
after spewing SATA errors). This is a multi-OS machine; if I boot into a
'good' OS (2.6.25.x works, as does Windows XP), then reboot into a recent
kernel, the kernel boots fine. So the procedure for collecting the traces
below was as follows:

0. Leave machine off for at least an hour.
1. Attempt to boot into new 2.6.27-series kernel; collect bad trace from
netconsole. Kernel never finishes boot.
2. Reboot (soft boot, by pressing reset button) into XP.
3. Hibernate XP (machine powers down completely afterward).
4. Boot into exact same kernel as above, boot finishes; collect good trace
from netconsole.

I have been tracking -git kernels; the first kernel to definitively
exhibit the problem was 2.6.27-rc1-00555-g8f616cd. The last kernel I
believe to be good (with maybe 90% probability) is
2.6.27-rc1-00303-g623fa57. I've been tracking -git kernels for a while,
and late 2.6.26-series kernels, along with 2.6.26 final, worked fine.
Recently my distro (Arch Linux) upgraded its  stock kernel to 2.6.26.2,
however, which *does* exhibit the problem. I never ran 2.6.26.1 at any
time. I looked through the 26.1 and 26.2 stable patches and nothing stood
out to me as an obvious culprit; maybe someone else can see what I can't.

I would be glad to help track this problem down, but this is my main
desktop machine and leaving it off for an hour to reproduce is annoying,
and probably precludes a successful bisection. Please keep me CCed, as I
don't subscribe to LKML/linux-ide directly.

The motherboard in question is an nVidia 680i, with a Seagate ST3320620AS
hard drive and TSSTcorp CDDVDW SH-S203N connected via SATA.

Bad dmesg, from -rc3 with netconsole:

[    0.000000] Linux version 2.6.27-rc3 (root@xeon) (gcc version 4.3.1
20080724 (prerelease) (GCC) ) #24 SMP PREEMPT Wed Aug 13 15:58:41 CDT 2008
[    0.000000] Command line: root=/dev/sda2 ro vga=795
netconsole=1842@192.168.0.6/eth0,1942@192.168.0.3/00:26:54:0E:CA:21
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000afef0000 (usable)
[    0.000000]  BIOS-e820: 00000000afef0000 - 00000000afef3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000afef3000 - 00000000aff00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000d0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000150000000 (usable)
[    0.000000] last_pfn = 0x150000 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] last_pfn = 0xafef0 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000] last_map_addr: afef0000 end: afef0000
[    0.000000] init_memory_mapping
[    0.000000] last_map_addr: 150000000 end: 150000000
[    0.000000] RAMDISK: 37faf000 - 37fef9db
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F7F20, 0014 (r0 Nvidia)
[    0.000000] ACPI: RSDT AFEF3040, 0038 (r1 Nvidia NVDAACPI 42302E31 NVDA
       0)
[    0.000000] ACPI: FACP AFEF30C0, 0074 (r1 Nvidia NVDAACPI 42302E31 NVDA
       0)
[    0.000000] ACPI: DSDT AFEF3180, 5339 (r1 NVIDIA NVDAACPI     1000 MSFT
 3000000)
[    0.000000] ACPI: FACS AFEF0000, 0040
[    0.000000] ACPI: HPET AFEF8600, 003C (r1 Nvidia NVDAACPI 42302E31 NVDA
       0)
[    0.000000] ACPI: WDRT AFEF8680, 0047 (r1 Nvidia NVDAACPI 42302E31 NVDA
       0)
[    0.000000] ACPI: MCFG AFEF8740, 003C (r1 Nvidia NVDAACPI 42302E31 NVDA
       0)
[    0.000000] ACPI: APIC AFEF8500, 0098 (r1 Nvidia NVDAACPI 42302E31 NVDA
       0)
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0150000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
[0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000a4d290]    TEXT DATA BSS ==>
[0000200000 - 0000a4d290]
[    0.000000]   #3 [0037faf000 - 0037fef9db]          RAMDISK ==>
[0037faf000 - 0037fef9db]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==>
[000009f000 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000b000]          PGTABLE ==>
[0000008000 - 000000b000]
[    0.000000]   #6 [000000b000 - 000000d000]          PGTABLE ==>
[000000b000 - 000000d000]
[    0.000000] found SMP MP-table at [ffff8800000f3f50] 000f3f50
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00150000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000afef0
[    0.000000]     0: 0x00100000 -> 0x00150000
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET timers must be located in memory.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at b0000000 (gap:
aff00000:20100000)
[    0.000000] PERCPU: Allocating 42308 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 1027159
[    0.000000] Kernel command line: root=/dev/sda2 ro vga=795
netconsole=1842@192.168.0.6/eth0,1942@192.168.0.3/00:26:54:0E:CA:21
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Detected 3600.004 MHz processor.
[    0.003333] Console: colour dummy device 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304
bytes)
[    0.003333] Inode-cache hash table entries: 262144 (order: 9, 2097152
bytes)
[    0.003333] Checking aperture...
[    0.003333] No AGP bridge found
[    0.003333] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.003333] Placing software IO TLB between 0x20000000 - 0x24000000
[    0.003333] Memory: 4034952k/5505024k available (4781k kernel code,
156980k reserved, 1837k data, 348k init)
[    0.006666] Calibrating delay loop (skipped), value calculated using
timer frequency.. 7202.00 BogoMIPS (lpj=12000013)
[    0.006666] Mount-cache hash table entries: 256
[    0.006666] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.006666] CPU: L2 cache: 4096K
[    0.006666] CPU: Physical Processor ID: 0
[    0.006666] CPU: Processor Core ID: 0
[    0.006666] CPU0: Thermal monitoring enabled (TM2)
[    0.006666] using mwait in idle threads.
[    0.006666] ACPI: Core revision 20080609
[    0.009999] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.043330] CPU0: Intel(R) Xeon(R) CPU            3060  @ 2.40GHz
stepping 06
[    0.043330] Using local APIC timer interrupts.
[    0.046663] Detected 25.000 MHz APIC timer.
[    0.046663] Booting processor 1/1 ip 6000
[    0.056662] Initializing CPU#1
[    0.086661] Calibrating delay using timer specific routine.. 7202.10
BogoMIPS (lpj=12000164)
[    0.086661] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.086661] CPU: L2 cache: 4096K
[    0.086661] CPU: Physical Processor ID: 0
[    0.086661] CPU: Processor Core ID: 1
[    0.086661] CPU1: Thermal monitoring enabled (TM2)
[    0.086661] x86 PAT enabled: cpu 1, old 0x7040600070406, new
0x7010600070106
[    0.139990] CPU1: Intel(R) Xeon(R) CPU            3060  @ 2.40GHz
stepping 06
[    0.139990] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.143323] Brought up 2 CPUs
[    0.143323] Total of 2 processors activated (14405.11 BogoMIPS).
[    0.143324] net_namespace: 896 bytes
[    0.143324] NET: Registered protocol family 16
[    0.143324] No dock devices found.
[    0.143324] ACPI: bus type pci registered
[    0.143324] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0
- 255
[    0.143324] PCI: MCFG area at e0000000 reserved in E820
[    0.146657] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.146657] PCI: Using configuration type 1 for base access
[    0.153323] ACPI: Interpreter enabled
[    0.153323] ACPI: (supports S0 S1 S3 S5)
[    0.153323] ACPI: Using IOAPIC for interrupt routing
[    0.159989] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.159989] pci 0000:00:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.159989] pci 0000:00:03.0: PME# disabled
[    0.159989] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.159989] pci 0000:00:0a.1: PME# supported from D3hot D3cold
[    0.159989] pci 0000:00:0a.1: PME# disabled
[    0.159989] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.159989] pci 0000:00:0b.0: PME# disabled
[    0.159989] pci 0000:00:0b.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.159989] pci 0000:00:0b.1: PME# disabled
[    0.159989] pci 0000:00:0f.1: PME# supported from D3hot D3cold
[    0.159989] pci 0000:00:0f.1: PME# disabled
[    0.159989] pci 0000:00:11.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.159989] pci 0000:00:11.0: PME# disabled
[    0.159989] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.159989] pci 0000:00:12.0: PME# disabled
[    0.159989] Pre-1.1 PCIe device detected, disable ASPM for
0000:00:03.0. It can be enabled forcedly with 'pcie_aspm=force'
[    0.159989] pci 0000:02:07.0: PME# supported from D0 D1 D2 D3hot
[    0.163322] pci 0000:02:07.0: PME# disabled
[    0.163322] pci 0000:00:0f.0: transparent bridge
[    0.223318] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.223318] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.223318] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.223318] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 *10 11 14 15)
[    0.223318] ACPI: PCI Interrupt Link [LXV5] (IRQs 5 7 9 *10 11 14 15)
[    0.223318] ACPI: PCI Interrupt Link [LXV6] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.223318] ACPI: PCI Interrupt Link [LXV7] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.223318] ACPI: PCI Interrupt Link [LXV8] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.223318] ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 *10 11 14 15)
[    0.223318] ACPI: PCI Interrupt Link [LMC1] (IRQs *5 7 9 10 11 14 15)
[    0.226651] ACPI: PCI Interrupt Link [LMAC] (IRQs *5 7 9 10 11 14 15)
[    0.226651] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 *11 14 15)
[    0.226651] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 10 *11 14 15)
[    0.226651] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [LSA0] (IRQs 5 7 9 10 *11 14 15)
[    0.226651] ACPI: PCI Interrupt Link [LSA1] (IRQs 5 7 9 10 *11 14 15)
[    0.226651] ACPI: PCI Interrupt Link [LSA2] (IRQs 5 7 9 *10 11 14 15)
[    0.226651] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
[    0.226651] ACPI: PCI Interrupt Link [AXV5] (IRQs 16) *0
[    0.226651] ACPI: PCI Interrupt Link [AXV6] (IRQs 16) *0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [AXV7] (IRQs 16) *0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [AXV8] (IRQs 16) *0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [AUBA] (IRQs 20 21 22 23) *0
[    0.226651] ACPI: PCI Interrupt Link [AMA1] (IRQs 20 21 22 23) *0
[    0.226651] ACPI: PCI Interrupt Link [AMAC] (IRQs 20 21 22 23) *0
[    0.226651] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
[    0.229985] ACPI: PCI Interrupt Link [AACI] (IRQs 20 21 22 23) *0,
disabled.
[    0.229985] ACPI: PCI Interrupt Link [AMCI] (IRQs 20 21 22 23) *0,
disabled.
[    0.229985] ACPI: PCI Interrupt Link [ASMB] (IRQs 20 21 22 23) *0,
disabled.
[    0.229985] ACPI: PCI Interrupt Link [AUS2] (IRQs 20 21 22 23) *0
[    0.229985] ACPI: PCI Interrupt Link [AIDE] (IRQs 20 21 22 23) *0,
disabled.
[    0.229985] ACPI: PCI Interrupt Link [ASA0] (IRQs 20 21 22 23) *0
[    0.229985] ACPI: PCI Interrupt Link [ASA1] (IRQs 20 21 22 23) *0
[    0.229985] ACPI: PCI Interrupt Link [ASA2] (IRQs 20 21 22 23) *0
[    0.229985] ACPI: WMI: Mapper loaded
[    0.229985] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.229985] pnp: PnP ACPI init
[    0.229985] ACPI: bus type pnp registered
[    0.233318] pnp: PnP ACPI: found 13 devices
[    0.233318] ACPI: ACPI bus type pnp unregistered
[    0.233318] SCSI subsystem initialized
[    0.233318] usbcore: registered new interface driver usbfs
[    0.233318] usbcore: registered new interface driver hub
[    0.233318] usbcore: registered new device driver usb
[    0.233318] PCI: Using ACPI for IRQ routing
[    0.263289] PCI-GART: No AMD northbridge found.
[    0.263316] ACPI: RTC can wake from S4
[    0.303261] system 00:00: ioport range 0x1000-0x107f has been reserved
[    0.303278] system 00:00: ioport range 0x1080-0x10ff has been reserved
[    0.303303] system 00:00: ioport range 0x1400-0x147f has been reserved
[    0.303316] system 00:00: ioport range 0x1480-0x14ff has been reserved
[    0.303316] system 00:00: ioport range 0x1800-0x187f has been reserved
[    0.303316] system 00:00: ioport range 0x1880-0x18ff has been reserved
[    0.303316] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    0.303316] system 00:02: ioport range 0x295-0x314 has been reserved
[    0.303316] system 00:02: ioport range 0x880-0x88f has been reserved
[    0.303316] system 00:0b: iomem range 0xe0000000-0xefffffff could not
be reserved
[    0.303316] system 00:0c: iomem range 0xd0000-0xd3fff has been reserved
[    0.303316] system 00:0c: iomem range 0xd5800-0xd7fff has been reserved
[    0.303316] system 00:0c: iomem range 0xf0000-0xfbfff could not be
reserved
[    0.303316] system 00:0c: iomem range 0xfc000-0xfffff could not be
reserved
[    0.303316] system 00:0c: iomem range 0xafef0000-0xafefffff could not
be reserved
[    0.303316] system 00:0c: iomem range 0xffff0000-0xffffffff could not
be reserved
[    0.303316] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.303316] system 00:0c: iomem range 0x100000-0xafeeffff could not be
reserved
[    0.303316] system 00:0c: iomem range 0xfec00000-0xfec00fff could not
be reserved
[    0.303316] system 00:0c: iomem range 0xd0000000-0xdfffffff could not
be reserved
[    0.303316] system 00:0c: iomem range 0xfee00000-0xfee00fff could not
be reserved
[    0.303316] system 00:0c: iomem range 0xfeff0000-0xfeff0000 could not
be reserved
[    0.304268] pci 0000:00:03.0: PCI bridge, secondary bus 0000:01
[    0.304268] pci 0000:00:03.0:   IO window: 0x9000-0x9fff
[    0.304268] pci 0000:00:03.0:   MEM window: 0xca000000-0xcdffffff
[    0.304268] pci 0000:00:03.0:   PREFETCH window:
0x000000b0000000-0x000000bfffffff
[    0.304268] pci 0000:00:0f.0: PCI bridge, secondary bus 0000:02
[    0.304268] pci 0000:00:0f.0:   IO window: 0x8000-0x8fff
[    0.304268] pci 0000:00:0f.0:   MEM window: 0xcfd00000-0xcfdfffff
[    0.304268] pci 0000:00:0f.0:   PREFETCH window:
0x000000cfe00000-0x000000cfefffff
[    0.304268] NET: Registered protocol family 2
[    0.423168] IP route cache hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.423315] TCP established hash table entries: 262144 (order: 10,
4194304 bytes)
[    0.423315] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.423315] TCP: Hash tables configured (established 262144 bind 65536)
[    0.423315] TCP reno registered
[    0.463315] NET: Registered protocol family 1
[    0.463315] checking if image is initramfs... it is
[    0.479982] Freeing initrd memory: 258k freed
[    0.480933] IA-32 Microcode Update Driver: v1.14a
<tigran@aivazian.fsnet.co.uk>
[    0.480933] NTFS driver 2.1.29 [Flags: R/W].
[    0.480933] fuse init (API version 7.9)
[    0.480933] SGI XFS with ACLs, security attributes, realtime, large
block/inode numbers, no debug enabled
[    0.480933] SGI XFS Quota Management subsystem
[    0.480933] msgmni has been set to 7883
[    0.480933] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 253)
[    0.480933] io scheduler noop registered
[    0.480933] io scheduler anticipatory registered
[    0.480933] io scheduler deadline registered
[    0.480933] io scheduler cfq registered (default)
[    0.501292] pcieport-driver 0000:00:03.0: found MSI capability
[    0.502088] ACPI: PCI Interrupt Link [AXV5] enabled at IRQ 16
[    0.502626] nvidiafb 0000:01:00.0: PCI INT A -> Link[AXV5] -> GSI 16
(level, low) -> IRQ 16
[    0.503369] nvidiafb: Device ID: 10de0193
[    0.504117] nvidiafb: unknown NV_ARCH
[    0.504267] vesafb: framebuffer at 0xcb000000, mapped to
0xffffc20010100000, using 10240k, total 16384k
[    0.504267] vesafb: mode is 1280x1024x32, linelength=5120, pages=1
[    0.504267] vesafb: scrolling: redraw
[    0.504267] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.534266] Console: switching to colour frame buffer device 160x64
[    0.560933] fb0: VESA VGA frame buffer device
[    0.560933] vga16fb: mapped to 0xffff8800000a0000
[    0.560933] fb1: VGA16 VGA frame buffer device
[    0.563556] input: Power Button (FF) as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.563556] ACPI: Power Button (FF) [PWRF]
[    0.563556] input: Power Button (CM) as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.563558] ACPI: Power Button (CM) [PWRB]
[    0.564299] processor ACPI0007:00: registered as cooling_device0
[    0.564299] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.564299] processor ACPI0007:01: registered as cooling_device1
[    0.646616] hpet_acpi_add: no address or irqs in _CRS
[    0.646647] Linux agpgart interface v0.103
[    0.646647] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180
seconds, margin is 60 seconds).
[    0.646647] Hangcheck: Using get_cycles().
[    0.646647] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    0.646647] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.646647] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.646647] Floppy drive(s): fd0 is 1.44M
[    0.663315] FDC 0 is a post-1991 82077
[    0.663315] brd: module loaded
[    0.663315] loop: module loaded
[    0.663315] forcedeth: Reverse Engineered nForce ethernet driver.
Version 0.61.
[    0.663315] ACPI: PCI Interrupt Link [AMAC] enabled at IRQ 23
[    0.663315] forcedeth 0000:00:11.0: PCI INT A -> Link[AMAC] -> GSI 23
(level, low) -> IRQ 23
[    1.169816] forcedeth 0000:00:11.0: ifname eth0, PHY OUI 0x5043 @ 1,
addr 00:04:4b:02:ee:42
[    1.170001] forcedeth 0000:00:11.0: highdma csum vlan pwrctl mgmt
timirq gbit lnktim msi desc-v3
[    1.170001] ACPI: PCI Interrupt Link [AMA1] enabled at IRQ 22
[    1.170001] forcedeth 0000:00:12.0: PCI INT A -> Link[AMA1] -> GSI 22
(level, low) -> IRQ 22
[    1.683687] forcedeth 0000:00:12.0: ifname eth1, PHY OUI 0x5043 @ 2,
addr 00:04:4b:02:ee:43
[    1.684326] forcedeth 0000:00:12.0: highdma csum vlan pwrctl mgmt
timirq gbit lnktim msi desc-v3
[    1.685409] netconsole: local port 1842
[    1.686625] netconsole: local IP 192.168.0.6
[    1.686667] netconsole: interface eth0
[    1.686667] netconsole: remote port 1942
[    1.690672] netconsole: remote IP 192.168.0.3
[    1.690679] netconsole: remote ethernet address 00:26:54:0e:ca:21
[    1.690686] netconsole: device eth0 not up yet, forcing it
[    1.691109] eth0: no link during initialization.
[    2.988197] eth0: link up.
[    3.036618] console [netcon0] enabled
[    5.000349] netconsole: network logging started
[    6.957372] Uniform Multi-Platform E-IDE driver
[    6.957372] amd74xx 0000:00:0d.0: UDMA133 controller
[    6.957372] amd74xx 0000:00:0d.0: IDE controller (0x10de:0x036e rev 0xa1)
[    6.957372] amd74xx 0000:00:0d.0: IDE port disabled
[    6.957372] amd74xx 0000:00:0d.0: not 100% native mode: will probe irqs
later
[    6.957372]     ide0: BM-DMA at 0xec00-0xec07
[    6.957372] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    6.957372] ide_generic: please use "probe_mask=0x3f" module parameter
for probing all legacy ISA IDE ports
[    6.957372] ide_generic: I/O resource 0x1F0-0x1F7 not free.
[    6.957372] ide_generic: I/O resource 0x170-0x177 not free.
[    6.957372] Driver 'sd' needs updating - please use bus_type methods
[    6.957372] Driver 'sr' needs updating - please use bus_type methods
[    6.957372] ACPI: PCI Interrupt Link [ASA0] enabled at IRQ 21
[    6.957372] sata_nv 0000:00:0e.0: PCI INT A -> Link[ASA0] -> GSI 21
(level, low) -> IRQ 21
[    6.957372] sata_nv 0000:00:0e.0: Using SWNCQ mode
[    6.957372] scsi0 : sata_nv
[    6.957372] scsi1 : sata_nv
[    6.957372] ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd800
irq 21
[    6.957372] ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd808
irq 21
[    6.957372] ata1: SATA link down (SStatus 0 SControl 300)
[    6.957373] ata2: SATA link down (SStatus 0 SControl 300)
[    6.957373] ACPI: PCI Interrupt Link [ASA1] enabled at IRQ 20
[    6.957373] sata_nv 0000:00:0e.1: PCI INT B -> Link[ASA1] -> GSI 20
(level, low) -> IRQ 20
[    6.957373] sata_nv 0000:00:0e.1: Using SWNCQ mode
[    6.957373] scsi2 : sata_nv
[    6.957373] scsi3 : sata_nv
[    6.957373] ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc400
irq 20
[    6.957373] ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc408
irq 20
[    6.957373] ata3: SATA link down (SStatus 0 SControl 300)
[   12.270233] ata4: link is slow to respond, please be patient (ready=-19)
[   16.810005] ata4: SRST failed (errno=-16)
[   22.303338] ata4: link is slow to respond, please be patient (ready=-19)
[   26.843337] ata4: SRST failed (errno=-16)
[   32.336670] ata4: link is slow to respond, please be patient (ready=-19)
[   61.890000] ata4: SRST failed (errno=-16)
[   61.897633] ata4: limiting SATA link speed to 1.5 Gbps
[   66.910000] ata4: SRST failed (errno=-16)
[   66.917685] ata4: reset failed, giving up
[   66.938996] ACPI: PCI Interrupt Link [ASA2] enabled at IRQ 23
[   66.946665] sata_nv 0000:00:0e.2: PCI INT C -> Link[ASA2] -> GSI 23
(level, low) -> IRQ 23
[   66.954511] sata_nv 0000:00:0e.2: Using SWNCQ mode
[   66.967493] scsi4 : sata_nv
[   66.971151] scsi5 : sata_nv
[   66.978103] ata5: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb000
irq 23
[   66.985421] ata6: SATA max UDMA/133 cmd 0xb800 ctl 0xb400 bmdma 0xb008
irq 23
[   72.473333] ata5: link is slow to respond, please be patient (ready=-19)
[   77.013332] ata5: SRST failed (errno=-16)
[   82.506665] ata5: link is slow to respond, please be patient (ready=-19)
[   87.046665] ata5: SRST failed (errno=-16)
[   92.539997] ata5: link is slow to respond, please be patient (ready=-19)
[  122.093328] ata5: SRST failed (errno=-16)
[  122.100773] ata5: limiting SATA link speed to 1.5 Gbps
[  127.113327] ata5: SRST failed (errno=-16)
[  127.120843] ata5: reset failed, giving up
[  127.128356] ata5: hard resetting link
[  132.619994] ata5: link is slow to respond, please be patient (ready=-19)
[  137.159993] ata5: SRST failed (errno=-16)
[  137.167566] ata5: hard resetting link
[  142.659992] ata5: link is slow to respond, please be patient (ready=-19)
[  147.199992] ata5: SRST failed (errno=-16)
[  147.207623] ata5: hard resetting link
[  152.699991] ata5: link is slow to respond, please be patient (ready=-19)
[  182.253322] ata5: SRST failed (errno=-16)
[  182.261400] ata5: hard resetting link
[  182.750463] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  182.840813] ata5.00: failed to IDENTIFY (I/O error, err_mask=0x3)
[  187.756660] ata5: hard resetting link
[  193.249988] ata5: link is slow to respond, please be patient (ready=-19)
[  197.789986] ata5: SRST failed (errno=-16)
[  197.797710] ata5: hard resetting link
[  203.136653] ata5: link is slow to respond, please be patient (ready=-19)
[  207.837446] ata5: COMRESET failed (errno=-16)
[  207.845186] ata5: hard resetting link
[  213.184443] ata5: link is slow to respond, please be patient (ready=-19)
[  242.897354] ata5: COMRESET failed (errno=-16)
[  242.905273] ata5: hard resetting link
[  247.918156] ata5: SRST failed (errno=-16)
[  247.926066] ata5: reset failed, giving up
[  247.933914] ata5: hard resetting link
[  253.426648] ata5: link is slow to respond, please be patient (ready=-19)
[  257.966647] ata5: SRST failed (errno=-16)
[  257.974559] ata5: hard resetting link
[  263.466647] ata5: link is slow to respond, please be patient (ready=-19)
[  268.006646] ata5: SRST failed (errno=-16)
[  268.006654] ata5: hard resetting link
[  273.493313] ata5: link is slow to respond, please be patient (ready=-19)
[  303.046643] ata5: SRST failed (errno=-16)
[  303.054803] ata5: hard resetting link
[  308.066642] ata5: SRST failed (errno=-16)
[  308.074622] ata5: reset failed, giving up
[  308.082519] ata5: hard resetting link
[  313.576642] ata5: link is slow to respond, please be patient (ready=-19)
[  318.118107] ata5: SRST failed (errno=-16)
[  318.125917] ata5: hard resetting link
[  323.616641] ata5: link is slow to respond, please be patient (ready=-19)
[  328.156971] ata5: SRST failed (errno=-16)
[  328.164883] ata5: hard resetting link
[  333.656640] ata5: link is slow to respond, please be patient (ready=-19)
[  363.211892] ata5: SRST failed (errno=-16)
[  363.219701] ata5: hard resetting link
[  368.229970] ata5: SRST failed (errno=-16)
[  368.237812] ata5: reset failed, giving up
[  368.245570] ata5: hard resetting link
[  368.737111] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  368.827461] ata5.00: failed to IDENTIFY (I/O error, err_mask=0x3)
[  373.743308] ata5: hard resetting link
[  374.234208] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  374.296629] ata5.00: failed to IDENTIFY (I/O error, err_mask=0x3)
[  379.239973] ata5: hard resetting link
[  379.730443] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  379.793295] ata5.00: failed to IDENTIFY (I/O error, err_mask=0x3)
[  384.736640] ata5: hard resetting link
[  390.077917] ata5: link is slow to respond, please be patient (ready=-19)
[  394.777159] ata5: COMRESET failed (errno=-16)
[  394.785063] ata5: hard resetting link
[  400.124510] ata5: link is slow to respond, please be patient (ready=-19)
[  404.824113] ata5: COMRESET failed (errno=-16)
[  404.832033] ata5: hard resetting link
[  410.323299] ata5: link is slow to respond, please be patient (ready=-19)
[  439.877613] ata5: SRST failed (errno=-16)
[  439.885540] ata5: hard resetting link
[  444.896629] ata5: SRST failed (errno=-16)
[  444.904484] ata5: reset failed, giving up
[  444.912284] ata5: EH pending after 5 tries, giving up
[  444.922283] ata5: EH complete
[  445.271201] ata6: SATA link down (SStatus 0 SControl 300)
[  445.283289] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[  445.286629] firewire_ohci 0000:02:07.0: PCI INT A -> Link[APC4] -> GSI
19 (level, low) -> IRQ 19
[  445.360827] firewire_ohci: Added fw-ohci device 0000:02:07.0, OHCI
version 1.10
[  445.369078] ACPI: PCI Interrupt Link [AUS2] enabled at IRQ 22
[  445.377900] ehci_hcd 0000:00:0b.1: PCI INT B -> Link[AUS2] -> GSI 22
(level, low) -> IRQ 22
[  445.386169] ehci_hcd 0000:00:0b.1: EHCI Host Controller
[  445.394216] ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus
number 1
[  445.402350] ehci_hcd 0000:00:0b.1: debug port 1
[  445.410381] ehci_hcd 0000:00:0b.1: irq 22, io mem 0xcfffe000
[  445.427577] ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver
10 Dec 2004
[  445.433347] usb usb1: configuration #1 chosen from 1 choice
[  445.441462] hub 1-0:1.0: USB hub found
[  445.449700] hub 1-0:1.0: 10 ports detected
[  445.663289] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[  445.669960] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[  445.678148] usb usb1: Product: EHCI Host Controller
[  445.686442] usb usb1: Manufacturer: Linux 2.6.27-rc3 ehci_hcd
[  445.694574] usb usb1: SerialNumber: 0000:00:0b.1
[  445.703087] ACPI: PCI Interrupt Link [AUBA] enabled at IRQ 21
[  445.710906] ohci_hcd 0000:00:0b.0: PCI INT A -> Link[AUBA] -> GSI 21
(level, low) -> IRQ 21
[  445.719373] ohci_hcd 0000:00:0b.0: OHCI Host Controller
[  445.727727] ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus
number 2
[  445.736207] ohci_hcd 0000:00:0b.0: irq 21, io mem 0xcffff000
[  445.796623] usb usb2: configuration #1 chosen from 1 choice
[  445.806653] hub 2-0:1.0: USB hub found
[  445.813777] hub 2-0:1.0: 10 ports detected
[  445.827456] usb 1-9: new high speed USB device using ehci_hcd and
address 3
[  445.866655] firewire_core: created device fw0: GUID 0d4bb3cd00044b03, S400
[  445.959956] usb 1-9: configuration #1 chosen from 1 choice
[  445.969956] usb 1-9: New USB device found, idVendor=05e3, idProduct=070e
[  445.976627] usb 1-9: New USB device strings: Mfr=3, Product=4,
SerialNumber=5
[  445.986234] usb 1-9: Product: USB Reader
[  445.994733] usb 1-9: Manufacturer: Genesys
[  446.003267] usb 1-9: SerialNumber: 000000426965
[  446.028139] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[  446.037459] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[  446.047384] usb usb2: Product: OHCI Host Controller
[  446.054062] usb usb2: Manufacturer: Linux 2.6.27-rc3 ohci_hcd
[  446.062704] usb usb2: SerialNumber: 0000:00:0b.0
[  446.071290] Initializing USB Mass Storage driver...
[  446.087455] scsi6 : SCSI emulation for USB Mass Storage devices
[  446.239773] usb 2-2: new low speed USB device using ohci_hcd and address 2
[  446.433289] usb 2-2: configuration #1 chosen from 1 choice
[  446.456294] usb 2-2: New USB device found, idVendor=046d, idProduct=c50e
[  446.463051] usb 2-2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[  446.473046] usb 2-2: Product: USB RECEIVER
[  446.481710] usb 2-2: Manufacturer: Logitech
[  446.490276] usbcore: registered new interface driver usb-storage
[  446.502154] USB Mass Storage support registered.
[  446.507447] usbcore: registered new interface driver libusual
[  446.516125] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[  446.524806] PNP: PS/2 appears to have AUX port disabled, if this is
incorrect please boot with i8042.nopnp
[  446.533801] serio: i8042 KBD port at 0x60,0x64 irq 1
[  446.550788] mice: PS/2 mouse device common for all mice
[  446.636623] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input2
[  446.737626] input: PC Speaker as /devices/platform/pcspkr/input/input3
[  446.825840] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[  446.833319] rtc0: alarms up to one year, y3k
[  446.842687] i2c-adapter i2c-0: nForce2 SMBus adapter at 0xf400
[  446.852039] i2c-adapter i2c-1: nForce2 SMBus adapter at 0xf000
[  446.994314] coretemp coretemp.0: Using relative temperature scale!
[  447.003324] coretemp coretemp.1: Using relative temperature scale!
[  447.012411] cpuidle: using governor ladder
[  447.021324] cpuidle: using governor menu
[  447.029958] sdhci: Secure Digital Host Controller Interface driver
[  447.038748] sdhci: Copyright(c) Pierre Ossman
[  447.050789] usbcore: registered new interface driver hiddev
[  447.068363] input: Logitech USB RECEIVER as
/devices/pci0000:00/0000:00:0b.0/usb2/2-2/2-2:1.0/input/input4
[  447.154580] input,hidraw0: USB HID v1.11 Mouse [Logitech USB RECEIVER]
on usb-0000:00:0b.0-2
[  447.163300] usbcore: registered new interface driver usbhid
[  447.172462] usbhid: v2.6:USB HID core driver
[  447.181611] Advanced Linux Sound Architecture Driver Version 1.0.17.
[  447.197455] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 20
[  447.199960] HDA Intel 0000:00:0f.1: PCI INT B -> Link[AAZA] -> GSI 20
(level, low) -> IRQ 20
[  447.243289] hda_codec: Unknown model for ALC882, trying auto-probe from
BIOS...
[  447.250731] ata4: hard resetting link
[  447.286623] ALSA device list:
[  447.296626]   #0: HDA NVidia at 0xcfff0000 irq 20
[  447.306095] TCP cubic registered
[  447.315479] Initializing XFRM netlink socket
[  447.323814] NET: Registered protocol family 10
[  447.335460] IPv6 over IPv4 tunneling driver
[  447.344131] NET: Registered protocol family 17
[  447.354047] NET: Registered protocol family 15
[  447.365657] rtc_cmos 00:05: setting system clock to 2008-08-13 17:51:35
UTC (1218649895)
[  447.374692] Freeing unused kernel memory: 348k freed
[  451.089956] scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE  
9325 PQ: 0 ANSI: 0
[  451.103556] sd 6:0:0:0: [sda] Attached SCSI removable disk
[  451.113632] sd 6:0:0:0: Attached scsi generic sg0 type 0
[  452.733741] ata4: link is slow to respond, please be patient (ready=-19)
[  457.274297] ata4: SRST failed (errno=-16)
[  457.283050] ata4: hard resetting link
[  462.776627] ata4: link is slow to respond, please be patient (ready=-19)
[  467.316743] ata4: SRST failed (errno=-16)
[  467.325267] ata4: hard resetting link
[  472.820783] ata4: link is slow to respond, please be patient (ready=-19)
[  502.374145] ata4: SRST failed (errno=-16)
[  502.382774] ata4: hard resetting link
[  507.397465] ata4: SRST failed (errno=-16)
[  507.406067] ata4: reset failed, giving up
[  507.415258] ata4: hard resetting link
[  512.907322] ata4: link is slow to respond, please be patient (ready=-19)
[  517.446622] ata4: SRST failed (errno=-16)
[  517.455229] ata4: hard resetting link
[  522.950590] ata4: link is slow to respond, please be patient (ready=-19)
[  527.491729] ata4: SRST failed (errno=-16)
[  527.499952] ata4: hard resetting link
[  532.990531] ata4: link is slow to respond, please be patient (ready=-19)
[  562.544150] ata4: SRST failed (errno=-16)
[  562.552337] ata4: hard resetting link
[  567.563894] ata4: SRST failed (errno=-16)
[  567.571855] ata4: reset failed, giving up
[  567.579662] ata4: EH complete
(at this point the kernel stops; I pressed ctrl-alt-delete to soft reboot)
[  641.153364] forcedeth 0000:00:12.0: wake-up capability disabled by ACPI
[  641.161419] forcedeth 0000:00:12.0: PME# disabled
[  641.169425] forcedeth 0000:00:12.0: wake-up capability disabled by ACPI
[  641.179350] forcedeth 0000:00:12.0: PME# disabled
[  641.187529] forcedeth 0000:00:12.0: PCI INT A disabled







Good dmesg, from *exact same kernel*:

[    0.000000] Linux version 2.6.27-rc3 (root@xeon) (gcc version 4.3.1
20080724 (prerelease) (GCC) ) #24 SMP PREEMPT Wed Aug 13 15:58:41 CDT 2008
[    0.000000] Command line: root=/dev/sda2 ro vga=795
netconsole=1842@192.168.0.6/eth0,1942@192.168.0.3/00:26:54:0E:CA:21
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000afef0000 (usable)
[    0.000000]  BIOS-e820: 00000000afef0000 - 00000000afef3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000afef3000 - 00000000aff00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000d0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000150000000 (usable)
[    0.000000] last_pfn = 0x150000 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] last_pfn = 0xafef0 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000] last_map_addr: afef0000 end: afef0000
[    0.000000] init_memory_mapping
[    0.000000] last_map_addr: 150000000 end: 150000000
[    0.000000] RAMDISK: 37faf000 - 37fef9db
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F7F20, 0014 (r0 Nvidia)
[    0.000000] ACPI: RSDT AFEF3040, 0038 (r1 Nvidia NVDAACPI 42302E31 NVDA
       0)
[    0.000000] ACPI: FACP AFEF30C0, 0074 (r1 Nvidia NVDAACPI 42302E31 NVDA
       0)
[    0.000000] ACPI: DSDT AFEF3180, 5339 (r1 NVIDIA NVDAACPI     1000 MSFT
 3000000)
[    0.000000] ACPI: FACS AFEF0000, 0040
[    0.000000] ACPI: HPET AFEF8600, 003C (r1 Nvidia NVDAACPI 42302E31 NVDA
       0)
[    0.000000] ACPI: WDRT AFEF8680, 0047 (r1 Nvidia NVDAACPI 42302E31 NVDA
       0)
[    0.000000] ACPI: MCFG AFEF8740, 003C (r1 Nvidia NVDAACPI 42302E31 NVDA
       0)
[    0.000000] ACPI: APIC AFEF8500, 0098 (r1 Nvidia NVDAACPI 42302E31 NVDA
       0)
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0150000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
[0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000a4d290]    TEXT DATA BSS ==>
[0000200000 - 0000a4d290]
[    0.000000]   #3 [0037faf000 - 0037fef9db]          RAMDISK ==>
[0037faf000 - 0037fef9db]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==>
[000009f000 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000b000]          PGTABLE ==>
[0000008000 - 000000b000]
[    0.000000]   #6 [000000b000 - 000000d000]          PGTABLE ==>
[000000b000 - 000000d000]
[    0.000000] found SMP MP-table at [ffff8800000f3f50] 000f3f50
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00150000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000afef0
[    0.000000]     0: 0x00100000 -> 0x00150000
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET timers must be located in memory.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at b0000000 (gap:
aff00000:20100000)
[    0.000000] PERCPU: Allocating 42308 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 1027159
[    0.000000] Kernel command line: root=/dev/sda2 ro vga=795
netconsole=1842@192.168.0.6/eth0,1942@192.168.0.3/00:26:54:0E:CA:21
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Detected 3599.995 MHz processor.
[    0.003333] Console: colour dummy device 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304
bytes)
[    0.003333] Inode-cache hash table entries: 262144 (order: 9, 2097152
bytes)
[    0.003333] Checking aperture...
[    0.003333] No AGP bridge found
[    0.003333] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.003333] Placing software IO TLB between 0x20000000 - 0x24000000
[    0.003333] Memory: 4034952k/5505024k available (4781k kernel code,
156980k reserved, 1837k data, 348k init)
[    0.006666] Calibrating delay loop (skipped), value calculated using
timer frequency.. 7202.98 BogoMIPS (lpj=11999983)
[    0.006666] Mount-cache hash table entries: 256
[    0.006666] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.006666] CPU: L2 cache: 4096K
[    0.006666] CPU: Physical Processor ID: 0
[    0.006666] CPU: Processor Core ID: 0
[    0.006666] CPU0: Thermal monitoring enabled (TM2)
[    0.006666] using mwait in idle threads.
[    0.006666] ACPI: Core revision 20080609
[    0.009999] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.043330] CPU0: Intel(R) Xeon(R) CPU            3060  @ 2.40GHz
stepping 06
[    0.043330] Using local APIC timer interrupts.
[    0.046663] Detected 24.999 MHz APIC timer.
[    0.046663] Booting processor 1/1 ip 6000
[    0.056662] Initializing CPU#1
[    0.086661] Calibrating delay using timer specific routine.. 7202.09
BogoMIPS (lpj=12000151)
[    0.086661] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.086661] CPU: L2 cache: 4096K
[    0.086661] CPU: Physical Processor ID: 0
[    0.086661] CPU: Processor Core ID: 1
[    0.086661] CPU1: Thermal monitoring enabled (TM2)
[    0.086661] x86 PAT enabled: cpu 1, old 0x7040600070406, new
0x7010600070106
[    0.139990] CPU1: Intel(R) Xeon(R) CPU            3060  @ 2.40GHz
stepping 06
[    0.139990] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.143323] Brought up 2 CPUs
[    0.143323] Total of 2 processors activated (14405.08 BogoMIPS).
[    0.143324] net_namespace: 896 bytes
[    0.143324] NET: Registered protocol family 16
[    0.143324] No dock devices found.
[    0.143324] ACPI: bus type pci registered
[    0.143324] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0
- 255
[    0.143324] PCI: MCFG area at e0000000 reserved in E820
[    0.146657] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.146657] PCI: Using configuration type 1 for base access
[    0.153323] ACPI: Interpreter enabled
[    0.153323] ACPI: (supports S0 S1 S3 S5)
[    0.153323] ACPI: Using IOAPIC for interrupt routing
[    0.159989] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.159989] pci 0000:00:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.159989] pci 0000:00:03.0: PME# disabled
[    0.159989] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.159989] pci 0000:00:0a.1: PME# supported from D3hot D3cold
[    0.159989] pci 0000:00:0a.1: PME# disabled
[    0.159989] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.159989] pci 0000:00:0b.0: PME# disabled
[    0.159989] pci 0000:00:0b.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.159989] pci 0000:00:0b.1: PME# disabled
[    0.159989] pci 0000:00:0f.1: PME# supported from D3hot D3cold
[    0.159989] pci 0000:00:0f.1: PME# disabled
[    0.159989] pci 0000:00:11.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.159989] pci 0000:00:11.0: PME# disabled
[    0.159989] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.159989] pci 0000:00:12.0: PME# disabled
[    0.159989] Pre-1.1 PCIe device detected, disable ASPM for
0000:00:03.0. It can be enabled forcedly with 'pcie_aspm=force'
[    0.159989] pci 0000:02:07.0: PME# supported from D0 D1 D2 D3hot
[    0.163322] pci 0000:02:07.0: PME# disabled
[    0.163322] pci 0000:00:0f.0: transparent bridge
[    0.223318] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.223318] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.223318] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.223318] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 *10 11 14 15)
[    0.223318] ACPI: PCI Interrupt Link [LXV5] (IRQs 5 7 9 *10 11 14 15)
[    0.223318] ACPI: PCI Interrupt Link [LXV6] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.223318] ACPI: PCI Interrupt Link [LXV7] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.223318] ACPI: PCI Interrupt Link [LXV8] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.223318] ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 *10 11 14 15)
[    0.223318] ACPI: PCI Interrupt Link [LMC1] (IRQs *5 7 9 10 11 14 15)
[    0.226651] ACPI: PCI Interrupt Link [LMAC] (IRQs *5 7 9 10 11 14 15)
[    0.226651] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 *11 14 15)
[    0.226651] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 10 *11 14 15)
[    0.226651] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15)
*0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [LSA0] (IRQs 5 7 9 10 *11 14 15)
[    0.226651] ACPI: PCI Interrupt Link [LSA1] (IRQs 5 7 9 10 *11 14 15)
[    0.226651] ACPI: PCI Interrupt Link [LSA2] (IRQs 5 7 9 *10 11 14 15)
[    0.226651] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
[    0.226651] ACPI: PCI Interrupt Link [AXV5] (IRQs 16) *0
[    0.226651] ACPI: PCI Interrupt Link [AXV6] (IRQs 16) *0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [AXV7] (IRQs 16) *0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [AXV8] (IRQs 16) *0, disabled.
[    0.226651] ACPI: PCI Interrupt Link [AUBA] (IRQs 20 21 22 23) *0
[    0.226651] ACPI: PCI Interrupt Link [AMA1] (IRQs 20 21 22 23) *0
[    0.226651] ACPI: PCI Interrupt Link [AMAC] (IRQs 20 21 22 23) *0
[    0.226651] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
[    0.229985] ACPI: PCI Interrupt Link [AACI] (IRQs 20 21 22 23) *0,
disabled.
[    0.229985] ACPI: PCI Interrupt Link [AMCI] (IRQs 20 21 22 23) *0,
disabled.
[    0.229985] ACPI: PCI Interrupt Link [ASMB] (IRQs 20 21 22 23) *0,
disabled.
[    0.229985] ACPI: PCI Interrupt Link [AUS2] (IRQs 20 21 22 23) *0
[    0.229985] ACPI: PCI Interrupt Link [AIDE] (IRQs 20 21 22 23) *0,
disabled.
[    0.229985] ACPI: PCI Interrupt Link [ASA0] (IRQs 20 21 22 23) *0
[    0.229985] ACPI: PCI Interrupt Link [ASA1] (IRQs 20 21 22 23) *0
[    0.229985] ACPI: PCI Interrupt Link [ASA2] (IRQs 20 21 22 23) *0
[    0.229985] ACPI: WMI: Mapper loaded
[    0.229985] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.229985] pnp: PnP ACPI init
[    0.229985] ACPI: bus type pnp registered
[    0.233318] pnp: PnP ACPI: found 13 devices
[    0.233318] ACPI: ACPI bus type pnp unregistered
[    0.233318] SCSI subsystem initialized
[    0.233318] usbcore: registered new interface driver usbfs
[    0.233318] usbcore: registered new interface driver hub
[    0.233318] usbcore: registered new device driver usb
[    0.233318] PCI: Using ACPI for IRQ routing
[    0.263289] PCI-GART: No AMD northbridge found.
[    0.263316] ACPI: RTC can wake from S4
[    0.303261] system 00:00: ioport range 0x1000-0x107f has been reserved
[    0.303278] system 00:00: ioport range 0x1080-0x10ff has been reserved
[    0.303303] system 00:00: ioport range 0x1400-0x147f has been reserved
[    0.303316] system 00:00: ioport range 0x1480-0x14ff has been reserved
[    0.303316] system 00:00: ioport range 0x1800-0x187f has been reserved
[    0.303316] system 00:00: ioport range 0x1880-0x18ff has been reserved
[    0.303316] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    0.303316] system 00:02: ioport range 0x295-0x314 has been reserved
[    0.303316] system 00:02: ioport range 0x880-0x88f has been reserved
[    0.303316] system 00:0b: iomem range 0xe0000000-0xefffffff could not
be reserved
[    0.303316] system 00:0c: iomem range 0xd0000-0xd3fff has been reserved
[    0.303316] system 00:0c: iomem range 0xd5800-0xd7fff has been reserved
[    0.303316] system 00:0c: iomem range 0xf0000-0xfbfff could not be
reserved
[    0.303316] system 00:0c: iomem range 0xfc000-0xfffff could not be
reserved
[    0.303316] system 00:0c: iomem range 0xafef0000-0xafefffff could not
be reserved
[    0.303316] system 00:0c: iomem range 0xffff0000-0xffffffff could not
be reserved
[    0.303316] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.303316] system 00:0c: iomem range 0x100000-0xafeeffff could not be
reserved
[    0.303316] system 00:0c: iomem range 0xfec00000-0xfec00fff could not
be reserved
[    0.303316] system 00:0c: iomem range 0xd0000000-0xdfffffff could not
be reserved
[    0.303316] system 00:0c: iomem range 0xfee00000-0xfee00fff could not
be reserved
[    0.303316] system 00:0c: iomem range 0xfeff0000-0xfeff0000 could not
be reserved
[    0.304266] pci 0000:00:03.0: PCI bridge, secondary bus 0000:01
[    0.304266] pci 0000:00:03.0:   IO window: 0x9000-0x9fff
[    0.304266] pci 0000:00:03.0:   MEM window: 0xca000000-0xcdffffff
[    0.304266] pci 0000:00:03.0:   PREFETCH window:
0x000000b0000000-0x000000bfffffff
[    0.304266] pci 0000:00:0f.0: PCI bridge, secondary bus 0000:02
[    0.304266] pci 0000:00:0f.0:   IO window: 0x8000-0x8fff
[    0.304266] pci 0000:00:0f.0:   MEM window: 0xcfd00000-0xcfdfffff
[    0.304266] pci 0000:00:0f.0:   PREFETCH window:
0x000000cfe00000-0x000000cfefffff
[    0.304266] NET: Registered protocol family 2
[    0.423168] IP route cache hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.423315] TCP established hash table entries: 262144 (order: 10,
4194304 bytes)
[    0.423315] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.423315] TCP: Hash tables configured (established 262144 bind 65536)
[    0.423315] TCP reno registered
[    0.463315] NET: Registered protocol family 1
[    0.463315] checking if image is initramfs... it is
[    0.479982] Freeing initrd memory: 258k freed
[    0.480932] IA-32 Microcode Update Driver: v1.14a
<tigran@aivazian.fsnet.co.uk>
[    0.480932] NTFS driver 2.1.29 [Flags: R/W].
[    0.480932] fuse init (API version 7.9)
[    0.480932] SGI XFS with ACLs, security attributes, realtime, large
block/inode numbers, no debug enabled
[    0.480932] SGI XFS Quota Management subsystem
[    0.480932] msgmni has been set to 7883
[    0.480932] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 253)
[    0.480932] io scheduler noop registered
[    0.480932] io scheduler anticipatory registered
[    0.480932] io scheduler deadline registered
[    0.480932] io scheduler cfq registered (default)
[    0.501307] pcieport-driver 0000:00:03.0: found MSI capability
[    0.502103] ACPI: PCI Interrupt Link [AXV5] enabled at IRQ 16
[    0.502641] nvidiafb 0000:01:00.0: PCI INT A -> Link[AXV5] -> GSI 16
(level, low) -> IRQ 16
[    0.503385] nvidiafb: Device ID: 10de0193
[    0.504133] nvidiafb: unknown NV_ARCH
[    0.504266] vesafb: framebuffer at 0xcb000000, mapped to
0xffffc20010100000, using 10240k, total 16384k
[    0.504266] vesafb: mode is 1280x1024x32, linelength=5120, pages=1
[    0.504266] vesafb: scrolling: redraw
[    0.504266] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.534265] Console: switching to colour frame buffer device 160x64
[    0.560932] fb0: VESA VGA frame buffer device
[    0.560932] vga16fb: mapped to 0xffff8800000a0000
[    0.560932] fb1: VGA16 VGA frame buffer device
[    0.563555] input: Power Button (FF) as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.563555] ACPI: Power Button (FF) [PWRF]
[    0.563555] input: Power Button (CM) as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.563557] ACPI: Power Button (CM) [PWRB]
[    0.564298] processor ACPI0007:00: registered as cooling_device0
[    0.564298] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.564298] processor ACPI0007:01: registered as cooling_device1
[    0.646617] hpet_acpi_add: no address or irqs in _CRS
[    0.646648] Linux agpgart interface v0.103
[    0.646648] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180
seconds, margin is 60 seconds).
[    0.646648] Hangcheck: Using get_cycles().
[    0.646648] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    0.646648] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.646648] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.646648] Floppy drive(s): fd0 is 1.44M
[    0.663315] FDC 0 is a post-1991 82077
[    0.663315] brd: module loaded
[    0.663315] loop: module loaded
[    0.663315] forcedeth: Reverse Engineered nForce ethernet driver.
Version 0.61.
[    0.663315] ACPI: PCI Interrupt Link [AMAC] enabled at IRQ 23
[    0.663315] forcedeth 0000:00:11.0: PCI INT A -> Link[AMAC] -> GSI 23
(level, low) -> IRQ 23
[    1.169816] forcedeth 0000:00:11.0: ifname eth0, PHY OUI 0x5043 @ 1,
addr 00:04:4b:02:ee:42
[    1.170001] forcedeth 0000:00:11.0: highdma csum vlan pwrctl mgmt
timirq gbit lnktim msi desc-v3
[    1.170001] ACPI: PCI Interrupt Link [AMA1] enabled at IRQ 22
[    1.170001] forcedeth 0000:00:12.0: PCI INT A -> Link[AMA1] -> GSI 22
(level, low) -> IRQ 22
[    1.683688] forcedeth 0000:00:12.0: ifname eth1, PHY OUI 0x5043 @ 2,
addr 00:04:4b:02:ee:43
[    1.684328] forcedeth 0000:00:12.0: highdma csum vlan pwrctl mgmt
timirq gbit lnktim msi desc-v3
[    1.685410] netconsole: local port 1842
[    1.686626] netconsole: local IP 192.168.0.6
[    1.686667] netconsole: interface eth0
[    1.686667] netconsole: remote port 1942
[    1.690669] netconsole: remote IP 192.168.0.3
[    1.690675] netconsole: remote ethernet address 00:26:54:0e:ca:21
[    1.690683] netconsole: device eth0 not up yet, forcing it
[    1.691107] eth0: no link during initialization.
[    2.878547] eth0: link up.
[    2.926619] console [netcon0] enabled
[    4.890344] netconsole: network logging started
[    6.847372] Uniform Multi-Platform E-IDE driver
[    6.847372] amd74xx 0000:00:0d.0: UDMA133 controller
[    6.847372] amd74xx 0000:00:0d.0: IDE controller (0x10de:0x036e rev 0xa1)
[    6.847372] amd74xx 0000:00:0d.0: IDE port disabled
[    6.847372] amd74xx 0000:00:0d.0: not 100% native mode: will probe irqs
later
[    6.847372]     ide0: BM-DMA at 0xec00-0xec07
[    6.847372] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    6.847372] ide_generic: please use "probe_mask=0x3f" module parameter
for probing all legacy ISA IDE ports
[    6.847372] ide_generic: I/O resource 0x1F0-0x1F7 not free.
[    6.847372] ide_generic: I/O resource 0x170-0x177 not free.
[    6.847372] Driver 'sd' needs updating - please use bus_type methods
[    6.847372] Driver 'sr' needs updating - please use bus_type methods
[    6.847372] ACPI: PCI Interrupt Link [ASA0] enabled at IRQ 21
[    6.847372] sata_nv 0000:00:0e.0: PCI INT A -> Link[ASA0] -> GSI 21
(level, low) -> IRQ 21
[    6.847372] sata_nv 0000:00:0e.0: Using SWNCQ mode
[    6.847372] scsi0 : sata_nv
[    6.847372] scsi1 : sata_nv
[    6.847372] ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd800
irq 21
[    6.847372] ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd808
irq 21
[    6.847373] ata1: SATA link down (SStatus 0 SControl 300)
[    6.847373] ata2: SATA link down (SStatus 0 SControl 300)
[    6.847373] ACPI: PCI Interrupt Link [ASA1] enabled at IRQ 20
[    6.847373] sata_nv 0000:00:0e.1: PCI INT B -> Link[ASA1] -> GSI 20
(level, low) -> IRQ 20
[    6.847373] sata_nv 0000:00:0e.1: Using SWNCQ mode
[    6.847373] scsi2 : sata_nv
[    6.847373] scsi3 : sata_nv
[    6.847373] ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc400
irq 20
[    6.847373] ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc408
irq 20
[    6.847373] ata3: SATA link down (SStatus 0 SControl 300)
[    7.143925] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    7.157954] ata4.00: ATAPI: TSSTcorp CDDVDW SH-S203N, SB01, max UDMA/100
[    7.179076] ata4.00: configured for UDMA/100
[    7.186669] scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S203N 
SB01 PQ: 0 ANSI: 5
[    7.199364] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2
cdda tray
[    7.204881] Uniform CD-ROM driver Revision: 3.20
[    7.212769] sr 3:0:0:0: Attached scsi generic sg0 type 5
[    7.222879] ACPI: PCI Interrupt Link [ASA2] enabled at IRQ 23
[    7.230479] sata_nv 0000:00:0e.2: PCI INT C -> Link[ASA2] -> GSI 23
(level, low) -> IRQ 23
[    7.238636] sata_nv 0000:00:0e.2: Using SWNCQ mode
[    7.250833] scsi4 : sata_nv
[    7.255135] scsi5 : sata_nv
[    7.262915] ata5: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb000
irq 23
[    7.270816] ata6: SATA max UDMA/133 cmd 0xb800 ctl 0xb400 bmdma 0xb008
irq 23
[    7.746696] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    7.805066] ata5.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
[    7.811329] ata5.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    7.879998] ata5.00: configured for UDMA/133
[    8.214483] ata6: SATA link down (SStatus 0 SControl 300)
[    8.226666] scsi 4:0:0:0: Direct-Access     ATA      ST3320620AS     
3.AA PQ: 0 ANSI: 5
[    8.230525] sd 4:0:0:0: [sda] 625142448 512-byte hardware sectors
(320073 MB)
[    8.238297] sd 4:0:0:0: [sda] Write Protect is off
[    8.246646] sd 4:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    8.254481] sd 4:0:0:0: [sda] 625142448 512-byte hardware sectors
(320073 MB)
[    8.262540] sd 4:0:0:0: [sda] Write Protect is off
[    8.270327] sd 4:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    8.278143]  sda: sda1 sda2 sda3
[    8.301444] sd 4:0:0:0: [sda] Attached SCSI disk
[    8.309675] sd 4:0:0:0: Attached scsi generic sg1 type 0
[    8.319932] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[    8.327745] firewire_ohci 0000:02:07.0: PCI INT A -> Link[APC4] -> GSI
19 (level, low) -> IRQ 19
[    8.401560] firewire_ohci: Added fw-ohci device 0000:02:07.0, OHCI
version 1.10
[    8.410309] ACPI: PCI Interrupt Link [AUS2] enabled at IRQ 22
[    8.420632] ehci_hcd 0000:00:0b.1: PCI INT B -> Link[AUS2] -> GSI 22
(level, low) -> IRQ 22
[    8.427323] ehci_hcd 0000:00:0b.1: EHCI Host Controller
[    8.436054] ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus
number 1
[    8.444782] ehci_hcd 0000:00:0b.1: debug port 1
[    8.453294] ehci_hcd 0000:00:0b.1: irq 22, io mem 0xcfffe000
[    8.471601] ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver
10 Dec 2004
[    8.480054] usb usb1: configuration #1 chosen from 1 choice
[    8.488670] hub 1-0:1.0: USB hub found
[    8.497194] hub 1-0:1.0: 10 ports detected
[    8.713333] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    8.720004] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    8.728671] usb usb1: Product: EHCI Host Controller
[    8.737263] usb usb1: Manufacturer: Linux 2.6.27-rc3 ehci_hcd
[    8.746004] usb usb1: SerialNumber: 0000:00:0b.1
[    8.756667] ACPI: PCI Interrupt Link [AUBA] enabled at IRQ 21
[    8.763337] ohci_hcd 0000:00:0b.0: PCI INT A -> Link[AUBA] -> GSI 21
(level, low) -> IRQ 21
[    8.772469] ohci_hcd 0000:00:0b.0: OHCI Host Controller
[    8.781525] ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus
number 2
[    8.790513] ohci_hcd 0000:00:0b.0: irq 21, io mem 0xcffff000
[    8.853333] usb usb2: configuration #1 chosen from 1 choice
[    8.863355] hub 2-0:1.0: USB hub found
[    8.872319] hub 2-0:1.0: 10 ports detected
[    8.887499] usb 1-9: new high speed USB device using ehci_hcd and
address 3
[    8.906703] firewire_core: created device fw0: GUID 0d4bb3cd00044b03, S400
[    9.019999] usb 1-9: configuration #1 chosen from 1 choice
[    9.031186] usb 1-9: New USB device found, idVendor=05e3, idProduct=070e
[    9.041191] usb 1-9: New USB device strings: Mfr=3, Product=4,
SerialNumber=5
[    9.050536] usb 1-9: Product: USB Reader
[    9.059789] usb 1-9: Manufacturer: Genesys
[    9.067709] usb 1-9: SerialNumber: 000000426965
[    9.085883] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    9.092456] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    9.104858] usb usb2: Product: OHCI Host Controller
[    9.113878] usb usb2: Manufacturer: Linux 2.6.27-rc3 ohci_hcd
[    9.120568] usb usb2: SerialNumber: 0000:00:0b.0
[    9.129553] Initializing USB Mass Storage driver...
[    9.144166] scsi6 : SCSI emulation for USB Mass Storage devices
[    9.299623] usb 2-2: new low speed USB device using ohci_hcd and address 2
[    9.493333] usb 2-2: configuration #1 chosen from 1 choice
[    9.517566] usb 2-2: New USB device found, idVendor=046d, idProduct=c50e
[    9.527572] usb 2-2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    9.536790] usb 2-2: Product: USB RECEIVER
[    9.544540] usb 2-2: Manufacturer: Logitech
[    9.553690] usbcore: registered new interface driver usb-storage
[    9.562815] USB Mass Storage support registered.
[    9.571869] usbcore: registered new interface driver libusual
[    9.580914] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    9.589987] PNP: PS/2 appears to have AUX port disabled, if this is
incorrect please boot with i8042.nopnp
[    9.599679] serio: i8042 KBD port at 0x60,0x64 irq 1
[    9.610974] mice: PS/2 mouse device common for all mice
[    9.703333] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input2
[    9.804103] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    9.892538] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    9.900029] rtc0: alarms up to one year, y3k
[    9.909364] i2c-adapter i2c-0: nForce2 SMBus adapter at 0xf400
[    9.918711] i2c-adapter i2c-1: nForce2 SMBus adapter at 0xf000
[   10.061054] coretemp coretemp.0: Using relative temperature scale!
[   10.070031] coretemp coretemp.1: Using relative temperature scale!
[   10.079117] cpuidle: using governor ladder
[   10.088015] cpuidle: using governor menu
[   10.096797] sdhci: Secure Digital Host Controller Interface driver
[   10.105537] sdhci: Copyright(c) Pierre Ossman
[   10.117499] usbcore: registered new interface driver hiddev
[   10.135019] input: Logitech USB RECEIVER as
/devices/pci0000:00/0000:00:0b.0/usb2/2-2/2-2:1.0/input/input4
[   10.221292] input,hidraw0: USB HID v1.11 Mouse [Logitech USB RECEIVER]
on usb-0000:00:0b.0-2
[   10.230010] usbcore: registered new interface driver usbhid
[   10.239165] usbhid: v2.6:USB HID core driver
[   10.248304] Advanced Linux Sound Architecture Driver Version 1.0.17.
[   10.264165] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 20
[   10.266671] HDA Intel 0000:00:0f.1: PCI INT B -> Link[AAZA] -> GSI 20
(level, low) -> IRQ 20
[   10.306666] hda_codec: Unknown model for ALC882, trying auto-probe from
BIOS...
[   10.343333] ALSA device list:
[   10.353337]   #0: HDA NVidia at 0xcfff0000 irq 20
[   10.362936] TCP cubic registered
[   10.372375] Initializing XFRM netlink socket
[   10.380780] NET: Registered protocol family 10
[   10.392802] IPv6 over IPv4 tunneling driver
[   10.403141] NET: Registered protocol family 17
[   10.410005] NET: Registered protocol family 15
[   10.419626] rtc_cmos 00:05: setting system clock to 2008-08-13 18:00:30
UTC (1218650430)
[   10.429102] Freeing unused kernel memory: 348k freed
[   10.930833] kjournald starting.  Commit interval 5 seconds
[   10.930833] EXT3-fs: mounted filesystem with ordered data mode.
(userspace inits as normal)


