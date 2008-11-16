Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbYKPMvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbYKPMvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 07:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYKPMvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 07:51:36 -0500
Received: from ox1.aei.mpg.de ([194.94.224.6]:45609 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbYKPMv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 07:51:29 -0500
Date: Sun, 16 Nov 2008 13:51:48 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: iwlagn driver segfault in 2.6.28-rc3
Message-ID: <20081116125148.GA16746@localhost.aei.mpg.de>
References: <20081111143410.GA4401@ics.muni.cz> <1226560041.1115.945.camel@rc-desk> <20081116120621.GA3937@localhost.aei.mpg.de> <1ba2fa240811160429ld8cc080s7e023b0398eeda08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ba2fa240811160429ld8cc080s7e023b0398eeda08@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 16.Nov'08 at 14:29:12 +0200, Tomas Winkler wrote:
> On Sun, Nov 16, 2008 at 2:06 PM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
> > I just got (another) one of this too.
> >
> > The wireless connection suddenly lost the AP and I was waiting
> > for ifplugd to reconnect to it again automatically, as it always
> > does.
> >
> > After waiting for one or two minutes I decided to 'modprobe -r
> > iwlagn' but this command never returned (it got stuck).
> >
> > Then I looked at the end of dmesg and found this:
> 
> Did you happen to have logs open so I can see what happen prior to that
> We found out that this is due to double removal of an encryption key
> but I still haven't see the exact flow.

Here is the whole dmesg which I saved after that GPF.

It is a bit bit because I had already suspended to ram a few times
(which is working _fine_, btw)

BIOS EBDA/lowmem at: 0009f800/0009f800
Linux version 2.6.28-rc4-keypress-00322-g58e20d8 (mafra@localhost) (gcc version 4.2.3 (4.2.3-6mnb1)) #14 SMP Fri Nov 14 00:02:57 CET 2008
Command line: BOOT_IMAGE=2628-rc4-keypress-00322-g58e20d root=UUID=019b9dde-30e6-11dd-b550-3d3d11ee558f resume=/dev/sda6 splash=silent vga=0x0364
KERNEL supported cpus:
  Intel GenuineIntel
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
 BIOS-e820: 000000007f6d0000 - 000000007f6e0000 (ACPI data)
 BIOS-e820: 000000007f6e0000 - 000000007f6e3000 (ACPI NVS)
 BIOS-e820: 000000007f6e3000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
DMI present.
last_pfn = 0x7f6d0 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping: 0000000000000000-000000007f6d0000
 0000000000 - 007f600000 page 2M
 007f600000 - 007f6d0000 page 4k
kernel direct mapping tables up to 7f6d0000 @ 8000-c000
last_map_addr: 7f6d0000 end: 7f6d0000
RAMDISK: 37dc9000 - 37fef347
ACPI: RSDP 000F8060, 0024 (r2 PTLTD )
ACPI: XSDT 7F6D7E0E, 008C (r1   Sony     VAIO 20070704 PTL         0)
ACPI: FACP 7F6DFC04, 00F4 (r3   Sony     VAIO 20070704 PTL         1)
ACPI: DSDT 7F6D9217, 6979 (r2   Sony     VAIO 20070704 PTL  20050624)
ACPI: FACS 7F6E2FC0, 0040
ACPI: APIC 7F6DFCF8, 0068 (r1   Sony     VAIO 20070704 PTL        5A)
ACPI: HPET 7F6DFD60, 0038 (r1   Sony     VAIO 20070704 PTL        5A)
ACPI: MCFG 7F6DFD98, 003C (r1   Sony     VAIO 20070704 PTL        5A)
ACPI: SLIC 7F6DFDD4, 0176 (r1   Sony     VAIO 20070704 PTL   1000000)
ACPI: TMOR 7F6DFF4A, 0026 (r1   Sony     VAIO 20070704 PTL         3)
ACPI: APIC 7F6DFF70, 0068 (r1   Sony     VAIO 20070704 PTL         0)
ACPI: BOOT 7F6DFFD8, 0028 (r1   Sony     VAIO 20070704 PTL         1)
ACPI: SSDT 7F6D90FA, 011D (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: SSDT 7F6D8FD7, 0123 (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: SSDT 7F6D8482, 0287 (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: SSDT 7F6D83CE, 00B4 (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: SSDT 7F6D7E9A, 0534 (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: BIOS bug: multiple APIC/MADT found, using 0
ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
ACPI: DMI detected: Sony
ACPI: Local APIC address 0xfee00000
(6 early reservations) ==> bootmem [0000000000 - 007f6d0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000746690]    TEXT DATA BSS ==> [0000200000 - 0000746690]
  #3 [0037dc9000 - 0037fef347]          RAMDISK ==> [0037dc9000 - 0037fef347]
  #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
 [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0007f6d0
On node 0 totalpages: 521839
  DMA zone: 56 pages used for memmap
  DMA zone: 1451 pages reserved
  DMA zone: 2492 pages, LIFO batch:0
  DMA32 zone: 7080 pages used for memmap
  DMA32 zone: 510760 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
PERCPU: Allocating 45056 bytes of per cpu data
NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 513252
Kernel command line: BOOT_IMAGE=2628-rc4-keypress-00322-g58e20d root=UUID=019b9dde-30e6-11dd-b550-3d3d11ee558f resume=/dev/sda6 splash=silent vga=0x0364
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 1995.352 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Memory: 2047292k/2087744k available (2911k kernel code, 388k absent, 39592k reserved, 1516k data, 320k init)
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 3992.98 BogoMIPS (lpj=6651173)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20080926
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3991.24 BogoMIPS (lpj=6649999)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (7983.23 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
net_namespace: 856 bytes
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: reg 10 64bit mmio: [0xfc000000-0xfc0fffff]
pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
pci 0000:00:02.1: reg 10 64bit mmio: [0xfc100000-0xfc1fffff]
pci 0000:00:1a.0: reg 20 io port: [0x1820-0x183f]
pci 0000:00:1a.1: reg 20 io port: [0x1840-0x185f]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xfc604800-0xfc604bff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xfc400000-0xfc403fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x1860-0x187f]
pci 0000:00:1d.1: reg 20 io port: [0x1880-0x189f]
pci 0000:00:1d.2: reg 20 io port: [0x18a0-0x18bf]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xfc604c00-0xfc604fff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x1810-0x181f]
pci 0000:00:1f.2: reg 10 io port: [0x1c00-0x1c07]
pci 0000:00:1f.2: reg 14 io port: [0x18d4-0x18d7]
pci 0000:00:1f.2: reg 18 io port: [0x18d8-0x18df]
pci 0000:00:1f.2: reg 1c io port: [0x18d0-0x18d3]
pci 0000:00:1f.2: reg 20 io port: [0x18e0-0x18ff]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xfc604000-0xfc6047ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10 32bit mmio: [0x000000-0x0000ff]
pci 0000:00:1f.3: reg 20 io port: [0x1c20-0x1c3f]
pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
pci 0000:00:1c.0: bridge 32bit mmio: [0xf6000000-0xf7ffffff]
pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf0000000-0xf1ffffff]
pci 0000:00:1c.1: bridge io port: [0x3000-0x3fff]
pci 0000:00:1c.1: bridge 32bit mmio: [0xf8000000-0xf9ffffff]
pci 0000:00:1c.1: bridge 64bit mmio pref: [0xf2000000-0xf3ffffff]
pci 0000:06:00.0: reg 10 64bit mmio: [0xfa000000-0xfa001fff]
pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
pci 0000:06:00.0: PME# disabled
pci 0000:00:1c.2: bridge io port: [0x4000-0x4fff]
pci 0000:00:1c.2: bridge 32bit mmio: [0xfa000000-0xfbffffff]
pci 0000:00:1c.2: bridge 64bit mmio pref: [0xf4000000-0xf5ffffff]
pci 0000:08:00.0: reg 10 64bit mmio: [0xfc200000-0xfc203fff]
pci 0000:08:00.0: reg 18 io port: [0x5000-0x50ff]
pci 0000:08:00.0: supports D1 D2
pci 0000:08:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:08:00.0: PME# disabled
pci 0000:00:1c.4: bridge io port: [0x5000-0x5fff]
pci 0000:00:1c.4: bridge 32bit mmio: [0xfc200000-0xfc2fffff]
pci 0000:09:03.0: reg 10 32bit mmio: [0xfc300000-0xfc300fff]
pci 0000:09:03.0: supports D1 D2
pci 0000:09:03.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:09:03.0: PME# disabled
pci 0000:09:03.1: reg 10 32bit mmio: [0xfc302000-0xfc3027ff]
pci 0000:09:03.1: reg 14 32bit mmio: [0xfc304000-0xfc307fff]
pci 0000:09:03.1: supports D1 D2
pci 0000:09:03.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:09:03.1: PME# disabled
pci 0000:09:03.2: reg 10 32bit mmio: [0xfc301000-0xfc301fff]
pci 0000:09:03.2: supports D1 D2
pci 0000:09:03.2: PME# supported from D0 D1 D2 D3hot
pci 0000:09:03.2: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge 32bit mmio: [0xfc300000-0xfc3fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
PCI: Using ACPI for IRQ routing
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Failed calling CRDA
cfg80211: calling CRDA failed - unable to update world regulatory domain, using static definition
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:01: iomem range 0xfed40000-0xfed44fff has been reserved
system 00:01: iomem range 0xfed45000-0xfed8ffff has been reserved
system 00:04: iomem range 0xfed00000-0xfed003ff has been reserved
system 00:06: ioport range 0x680-0x69f has been reserved
system 00:06: ioport range 0x800-0x80f has been reserved
system 00:06: ioport range 0x1000-0x107f has been reserved
system 00:06: ioport range 0x1180-0x11bf has been reserved
system 00:06: ioport range 0x1640-0x164f has been reserved
system 00:06: ioport range 0xfe00-0xfe7f has been reserved
system 00:06: ioport range 0xfe80-0xfeff has been reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
pci 0000:00:1c.0:   MEM window: 0xf6000000-0xf7ffffff
pci 0000:00:1c.0:   PREFETCH window: 0x000000f0000000-0x000000f1ffffff
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
pci 0000:00:1c.1:   MEM window: 0xf8000000-0xf9ffffff
pci 0000:00:1c.1:   PREFETCH window: 0x000000f2000000-0x000000f3ffffff
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:06
pci 0000:00:1c.2:   IO window: 0x4000-0x4fff
pci 0000:00:1c.2:   MEM window: 0xfa000000-0xfbffffff
pci 0000:00:1c.2:   PREFETCH window: 0x000000f4000000-0x000000f5ffffff
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:08
pci 0000:00:1c.4:   IO window: 0x5000-0x5fff
pci 0000:00:1c.4:   MEM window: 0xfc200000-0xfc2fffff
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:09:03.0: CardBus bridge, secondary bus 0000:0a
pci 0000:09:03.0:   IO window: 0x006000-0x0060ff
pci 0000:09:03.0:   IO window: 0x006400-0x0064ff
pci 0000:09:03.0:   PREFETCH window: 0x88000000-0x8bffffff
pci 0000:09:03.0:   MEM window: 0x90000000-0x93ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:09
pci 0000:00:1e.0:   IO window: 0x6000-0x6fff
pci 0000:00:1e.0:   MEM window: 0xfc300000-0xfc3fffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000088000000-0x0000008bffffff
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:09:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
bus: 02 index 0 io port: [0x2000-0x2fff]
bus: 02 index 1 mmio: [0xf6000000-0xf7ffffff]
bus: 02 index 2 mmio: [0xf0000000-0xf1ffffff]
bus: 02 index 3 mmio: [0x0-0x0]
bus: 04 index 0 io port: [0x3000-0x3fff]
bus: 04 index 1 mmio: [0xf8000000-0xf9ffffff]
bus: 04 index 2 mmio: [0xf2000000-0xf3ffffff]
bus: 04 index 3 mmio: [0x0-0x0]
bus: 06 index 0 io port: [0x4000-0x4fff]
bus: 06 index 1 mmio: [0xfa000000-0xfbffffff]
bus: 06 index 2 mmio: [0xf4000000-0xf5ffffff]
bus: 06 index 3 mmio: [0x0-0x0]
bus: 08 index 0 io port: [0x5000-0x5fff]
bus: 08 index 1 mmio: [0xfc200000-0xfc2fffff]
bus: 08 index 2 mmio: [0x0-0x0]
bus: 08 index 3 mmio: [0x0-0x0]
bus: 09 index 0 io port: [0x6000-0x6fff]
bus: 09 index 1 mmio: [0xfc300000-0xfc3fffff]
bus: 09 index 2 mmio: [0x88000000-0x8bffffff]
bus: 09 index 3 io port: [0x00-0xffff]
bus: 09 index 4 mmio: [0x000000-0xffffffffffffffff]
bus: 0a index 0 io port: [0x6000-0x60ff]
bus: 0a index 1 io port: [0x6400-0x64ff]
bus: 0a index 2 mmio: [0x88000000-0x8bffffff]
bus: 0a index 3 mmio: [0x90000000-0x93ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs... done
Freeing initrd memory: 2200k freed
Simple Boot Flag at 0x36 set to 0x1
msgmni has been set to 4003
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20010100000, using 4000k, total 7616k
vesafb: mode is 1280x800x16, linelength=2560, pages=2
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 160x50
fb0: VESA VGA frame buffer device
ACPI: AC Adapter [ADP1] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID0]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button (CM) [PWRB]
acpi device:08: registered as cooling_device0
acpi device:09: registered as cooling_device1
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:05/input/input2
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
ACPI: SSDT 7F6D8C52, 02A1 (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: SSDT 7F6D8709, 04B7 (r1   Sony     VAIO 20070704 PTL  20050624)<7>Switched to high resolution mode on CPU 1

Switched to high resolution mode on CPU 0
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device2
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7F6D8EF3, 00E4 (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: SSDT 7F6D8BC0, 0092 (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: EC: GPE storm detected, transactions will use polling mode
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:01: registered as cooling_device3
ACPI: Processor [CPU1] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (45 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Thermal Zone [TZ01] (45 C)
Generic RTC Driver v1.07
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 965GM Chipset
agpgart-intel 0000:00:00.0: detected 7676K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20080730 on minor 0
intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
intelfb: Version 0.9.6
intelfb: Cannot reserve FB region.
tifm_7xx1 0000:09:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sony-laptop: Sony Notebook Control Driver v0.6.
input: Sony Vaio Keys as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:29/SNY5001:00/input/input3
input: Sony Vaio Jogdial as /devices/virtual/input/input4
sony-laptop: detected Sony Vaio FZ Series
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
Marking TSC unstable due to TSC halts in idle
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
ALSA device list:
  No soundcards found.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
NET: Registered protocol family 15
Freeing unused kernel memory: 320k freed
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfc604800
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfc604c00
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
input: PS/2 Mouse as /devices/platform/i8042/serio4/input/input6
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio4/input/input7
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001860
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001880
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018a0
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
Clocksource tsc unstable (delta = -128025211 ns)
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
ata2: DUMMY
ata3: DUMMY
usb 1-2: new high speed USB device using ehci_hcd and address 2
usb 1-2: configuration #1 chosen from 1 choice
input: PS/2 Mouse as /devices/platform/i8042/serio4/input/input8
input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio4/input/input9
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ATA-8: FUJITSU MHX2250BT, 0041000B, max UDMA/100
ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHX2250B 0041 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi3 : ata_piix
scsi4 : ata_piix
ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata4.00: ATAPI: SONY    DVD RW AW-G540A, 1.W0, max UDMA/33
ata4.00: configured for UDMA/33
isa bounce pool size: 16 pages
scsi 3:0:0:0: CD-ROM            SONY     DVD RW AW-G540A  1.W0 PQ: 0 ANSI: 5
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: sda1: orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 720331
ext3_orphan_cleanup: deleting unreferenced inode 2013901
EXT3-fs: sda1: 2 orphan inodes deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
Linux video capture interface: v2.00
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kd
iwlagn: Copyright(c) 2003-2008 Intel Corporation
iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwlagn 0000:06:00.0: setting latency timer to 64
iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 19 (level, low) -> IRQ 19
sky2 driver version 1.22
sky2 0000:08:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
sky2 0000:08:00.0: setting latency timer to 64
sky2 0000:08:00.0: Yukon-2 FE chip revision 1
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 3:0:0:0: Attached scsi generic sg1 type 5
uvcvideo: Found UVC 1.00 device <unnamed> (05ca:183b)
iwlagn: Tunable channels: 11 802.11bg, 13 802.11a channels
sky2 0000:08:00.0: Marvell Yukon 88E8036 Fast Ethernet Controller
 Part Number: Yukon 88E8036
 Engineering Level: Rev. 1.6
 Manufacturer: Marvell
uvcvideo: Failed to query (135) UVC control 1 (unit 0) : -32 (exp. 26).
uvcvideo: Failed to query (129) UVC control 1 (unit 0) : -32 (exp. 26).
uvcvideo: Failed to initialize the device (-5).
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
sky2 eth0: addr 00:1a:80:4a:7f:37
iwlagn 0000:06:00.0: PCI INT A disabled
phy0: Selected rate control algorithm 'iwl-agn-rs'
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
ohci1394 0000:09:03.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[fc302000-fc3027ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwlagn 0000:06:00.0: restoring config space at offset 0x1 (was 0x40100102, writing 0x40100106)
iwlagn 0000:06:00.0: firmware: requesting iwlwifi-4965-2.ucode
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0800460302903fd0]
iwlagn: TX Power requested while scanning!
iwlagn: Error sending TX power (-11)
iwlagn 0000:06:00.0: PCI INT A disabled
Non-volatile memory driver v1.2
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 4281280k swap on /dev/sda6.  Priority:-1 extents:1 across:4281280k
iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwlagn 0000:06:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x100106)
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
wlan0: direct probe to AP 00:0b:86:dd:92:01 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:86:dd:92:01
wlan0: authenticated
wlan0: associate with AP 00:0b:86:dd:92:01
wlan0: RX AssocResp from 00:0b:86:dd:92:01 (capab=0x431 status=0 aid=1)
wlan0: associated
wlan0: deauthenticated
wlan0: direct probe to AP 00:0b:86:dd:92:01 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:86:dd:92:01
wlan0: authenticated
wlan0: associate with AP 00:0b:86:dd:92:01
wlan0: RX ReassocResp from 00:0b:86:dd:92:01 (capab=0x431 status=0 aid=1)
wlan0: associated
phy0: failed to restore operational channel after scan
evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
ACPI: EC: missing confirmations, switch off interrupt mode.
evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
process `skype' is using obsolete setsockopt SO_BSDCOMPAT
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ACPI handle has no context!
tifm_7xx1 0000:09:03.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
iwlagn 0000:06:00.0: PCI INT A disabled
ahci 0000:00:1f.2: PCI INT B disabled
ata_piix 0000:00:1f.1: PCI INT A disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
HDA Intel 0000:00:1b.0: PCI INT A disabled
ehci_hcd 0000:00:1a.7: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Back to C!
Extended CMOS year: 2000
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3991.24 BogoMIPS (lpj=6649998)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
CPU1 is up
ACPI: Waking up from system sleep state S3
sony-laptop: detected Sony Vaio FZ Series
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
usb usb4: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
pci 0000:00:1c.0: restoring config space at offset 0xf (was 0x40100, writing 0x4010a)
pci 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20002020, writing 0x2020)
pci 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: restoring config space at offset 0xf (was 0x40200, writing 0x40205)
pci 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0xf3f1f201)
pci 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xf9f0f800)
pci 0000:00:1c.1: restoring config space at offset 0x7 (was 0x0, writing 0x3030)
pci 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: restoring config space at offset 0xf (was 0x40300, writing 0x40307)
pci 0000:00:1c.2: restoring config space at offset 0x9 (was 0x10001, writing 0xf5f1f401)
pci 0000:00:1c.2: restoring config space at offset 0x8 (was 0x0, writing 0xfbf0fa00)
pci 0000:00:1c.2: restoring config space at offset 0x7 (was 0x20000000, writing 0x4040)
pci 0000:00:1c.2: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.4: restoring config space at offset 0xf (was 0x40100, writing 0x4010a)
pci 0000:00:1c.4: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
pci 0000:00:1c.4: restoring config space at offset 0x8 (was 0x0, writing 0xfc20fc20)
pci 0000:00:1c.4: restoring config space at offset 0x7 (was 0x20000000, writing 0x5050)
pci 0000:00:1c.4: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb5: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb6: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb7: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x8bf18801)
pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xfc30fc30)
pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x22800000, writing 0x22806060)
pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100107)
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.1: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
ata_piix 0000:00:1f.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.1: setting latency timer to 64
ahci 0000:00:1f.2: restoring config space at offset 0xf (was 0x200, writing 0x20a)
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: setting latency timer to 64
i801_smbus 0000:00:1f.3: restoring config space at offset 0x4 (was 0x0, writing 0x8c000000)
iwlagn 0000:06:00.0: enabling device (0000 -> 0002)
iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwlagn 0000:06:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
iwlagn 0000:06:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfa000004)
iwlagn 0000:06:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
iwlagn 0000:06:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100106)
sky2 0000:08:00.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
sky2 0000:08:00.0: restoring config space at offset 0x6 (was 0x1, writing 0x5001)
sky2 0000:08:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfc200004)
sky2 0000:08:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
sky2 0000:08:00.0: restoring config space at offset 0x1 (was 0x40100000, writing 0x100107)
pci 0000:09:03.0: restoring config space at offset 0xf (was 0x34001ff, writing 0x3440105)
pci 0000:09:03.0: restoring config space at offset 0xe (was 0x0, writing 0x64fc)
pci 0000:09:03.0: restoring config space at offset 0xd (was 0x0, writing 0x6400)
pci 0000:09:03.0: restoring config space at offset 0xc (was 0x0, writing 0x60fc)
pci 0000:09:03.0: restoring config space at offset 0xb (was 0x0, writing 0x6000)
pci 0000:09:03.0: restoring config space at offset 0xa (was 0x0, writing 0x93fff000)
pci 0000:09:03.0: restoring config space at offset 0x9 (was 0x0, writing 0x90000000)
pci 0000:09:03.0: restoring config space at offset 0x8 (was 0x0, writing 0x8bfff000)
pci 0000:09:03.0: restoring config space at offset 0x7 (was 0x0, writing 0x88000000)
pci 0000:09:03.0: restoring config space at offset 0x6 (was 0x0, writing 0xb00d0a09)
pci 0000:09:03.0: restoring config space at offset 0x4 (was 0x0, writing 0xfc300000)
pci 0000:09:03.0: restoring config space at offset 0x3 (was 0x820000, writing 0x823110)
pci 0000:09:03.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100107)
pci 0000:09:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci1394 0000:09:03.1: restoring config space at offset 0xf (was 0x4030200, writing 0x403020a)
ohci1394 0000:09:03.1: restoring config space at offset 0x5 (was 0x0, writing 0xfc304000)
ohci1394 0000:09:03.1: restoring config space at offset 0x4 (was 0x0, writing 0xfc302000)
ohci1394 0000:09:03.1: restoring config space at offset 0x3 (was 0x800000, writing 0x802010)
ohci1394 0000:09:03.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100116)
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[fc302000-fc3027ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
tifm_7xx1 0000:09:03.2: restoring config space at offset 0xf (was 0x40703ff, writing 0x4070307)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x4 (was 0x0, writing 0xfc301000)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x3 (was 0x800000, writing 0x803910)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100106)
tifm_7xx1 0000:09:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:02.0: setting latency timer to 64
ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
ata4.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
ata4.00: configured for UDMA/33
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
sd 0:0:0:0: [sda] Starting disk
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Restarting tasks ... done.
wlan0: direct probe to AP 00:0b:86:dd:92:01 try 1
wlan0: direct probe to AP 00:0b:86:dd:92:01 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:86:dd:92:01
wlan0: authenticated
wlan0: associate with AP 00:0b:86:dd:92:01
wlan0: RX ReassocResp from 00:0b:86:dd:92:01 (capab=0x431 status=0 aid=1)
wlan0: associated
evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
ACPI: EC: missing confirmations, switch off interrupt mode.
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ACPI handle has no context!
tifm_7xx1 0000:09:03.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
iwlagn 0000:06:00.0: PCI INT A disabled
ahci 0000:00:1f.2: PCI INT B disabled
ata_piix 0000:00:1f.1: PCI INT A disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
HDA Intel 0000:00:1b.0: PCI INT A disabled
ehci_hcd 0000:00:1a.7: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Back to C!
Extended CMOS year: 2000
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3991.31 BogoMIPS (lpj=6650107)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
CPU1 is up
ACPI: Waking up from system sleep state S3
sony-laptop: detected Sony Vaio FZ Series
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
usb usb4: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
pci 0000:00:1c.0: restoring config space at offset 0xf (was 0x40100, writing 0x4010a)
pci 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: restoring config space at offset 0xf (was 0x40200, writing 0x40205)
pci 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0xf3f1f201)
pci 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xf9f0f800)
pci 0000:00:1c.1: restoring config space at offset 0x7 (was 0x0, writing 0x3030)
pci 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: restoring config space at offset 0xf (was 0x40300, writing 0x40307)
pci 0000:00:1c.2: restoring config space at offset 0x9 (was 0x10001, writing 0xf5f1f401)
pci 0000:00:1c.2: restoring config space at offset 0x8 (was 0x0, writing 0xfbf0fa00)
pci 0000:00:1c.2: restoring config space at offset 0x7 (was 0x20000000, writing 0x20004040)
pci 0000:00:1c.2: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.4: restoring config space at offset 0xf (was 0x40100, writing 0x4010a)
pci 0000:00:1c.4: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
pci 0000:00:1c.4: restoring config space at offset 0x8 (was 0x0, writing 0xfc20fc20)
pci 0000:00:1c.4: restoring config space at offset 0x7 (was 0x20000000, writing 0x20005050)
pci 0000:00:1c.4: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb5: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb6: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb7: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x8bf18801)
pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xfc30fc30)
pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x22800000, writing 0x22806060)
pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100107)
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.1: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
ata_piix 0000:00:1f.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.1: setting latency timer to 64
ahci 0000:00:1f.2: restoring config space at offset 0xf (was 0x200, writing 0x20a)
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: setting latency timer to 64
i801_smbus 0000:00:1f.3: restoring config space at offset 0x4 (was 0x0, writing 0x8c000000)
iwlagn 0000:06:00.0: enabling device (0000 -> 0002)
iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwlagn 0000:06:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
iwlagn 0000:06:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfa000004)
iwlagn 0000:06:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
iwlagn 0000:06:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100106)
sky2 0000:08:00.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
sky2 0000:08:00.0: restoring config space at offset 0x6 (was 0x1, writing 0x5001)
sky2 0000:08:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfc200004)
sky2 0000:08:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
sky2 0000:08:00.0: restoring config space at offset 0x1 (was 0x40100000, writing 0x100107)
pci 0000:09:03.0: restoring config space at offset 0xf (was 0x34001ff, writing 0x3440105)
pci 0000:09:03.0: restoring config space at offset 0xe (was 0x0, writing 0x64fc)
pci 0000:09:03.0: restoring config space at offset 0xd (was 0x0, writing 0x6400)
pci 0000:09:03.0: restoring config space at offset 0xc (was 0x0, writing 0x60fc)
pci 0000:09:03.0: restoring config space at offset 0xb (was 0x0, writing 0x6000)
pci 0000:09:03.0: restoring config space at offset 0xa (was 0x0, writing 0x93fff000)
pci 0000:09:03.0: restoring config space at offset 0x9 (was 0x0, writing 0x90000000)
pci 0000:09:03.0: restoring config space at offset 0x8 (was 0x0, writing 0x8bfff000)
pci 0000:09:03.0: restoring config space at offset 0x7 (was 0x0, writing 0x88000000)
pci 0000:09:03.0: restoring config space at offset 0x6 (was 0x0, writing 0xb00d0a09)
pci 0000:09:03.0: restoring config space at offset 0x4 (was 0x0, writing 0xfc300000)
pci 0000:09:03.0: restoring config space at offset 0x3 (was 0x820000, writing 0x823110)
pci 0000:09:03.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100107)
pci 0000:09:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci1394 0000:09:03.1: restoring config space at offset 0xf (was 0x4030200, writing 0x403020a)
ohci1394 0000:09:03.1: restoring config space at offset 0x5 (was 0x0, writing 0xfc304000)
ohci1394 0000:09:03.1: restoring config space at offset 0x4 (was 0x0, writing 0xfc302000)
ohci1394 0000:09:03.1: restoring config space at offset 0x3 (was 0x800000, writing 0x802010)
ohci1394 0000:09:03.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100116)
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[fc302000-fc3027ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
tifm_7xx1 0000:09:03.2: restoring config space at offset 0xf (was 0x40703ff, writing 0x4070307)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x4 (was 0x0, writing 0xfc301000)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x3 (was 0x800000, writing 0x803910)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100106)
tifm_7xx1 0000:09:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:02.0: setting latency timer to 64
ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
ata4.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
ata4.00: configured for UDMA/33
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
sd 0:0:0:0: [sda] Starting disk
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Restarting tasks ... done.
wlan0: direct probe to AP 00:0b:86:dd:92:01 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:86:dd:92:01
wlan0: authenticated
wlan0: associate with AP 00:0b:86:dd:92:01
wlan0: RX ReassocResp from 00:0b:86:dd:92:01 (capab=0x431 status=0 aid=1)
wlan0: associated
phy0: failed to restore operational channel after scan
evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ACPI handle has no context!
tifm_7xx1 0000:09:03.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
iwlagn 0000:06:00.0: PCI INT A disabled
ahci 0000:00:1f.2: PCI INT B disabled
ata_piix 0000:00:1f.1: PCI INT A disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
HDA Intel 0000:00:1b.0: PCI INT A disabled
ehci_hcd 0000:00:1a.7: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Back to C!
Extended CMOS year: 2000
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3991.29 BogoMIPS (lpj=6650066)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
CPU1 is up
ACPI: Waking up from system sleep state S3
sony-laptop: detected Sony Vaio FZ Series
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
usb usb4: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
pci 0000:00:1c.0: restoring config space at offset 0xf (was 0x40100, writing 0x4010a)
pci 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: restoring config space at offset 0xf (was 0x40200, writing 0x40205)
pci 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0xf3f1f201)
pci 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xf9f0f800)
pci 0000:00:1c.1: restoring config space at offset 0x7 (was 0x0, writing 0x3030)
pci 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: restoring config space at offset 0xf (was 0x40300, writing 0x40307)
pci 0000:00:1c.2: restoring config space at offset 0x9 (was 0x10001, writing 0xf5f1f401)
pci 0000:00:1c.2: restoring config space at offset 0x8 (was 0x0, writing 0xfbf0fa00)
pci 0000:00:1c.2: restoring config space at offset 0x7 (was 0x20000000, writing 0x4040)
pci 0000:00:1c.2: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.4: restoring config space at offset 0xf (was 0x40100, writing 0x4010a)
pci 0000:00:1c.4: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
pci 0000:00:1c.4: restoring config space at offset 0x8 (was 0x0, writing 0xfc20fc20)
pci 0000:00:1c.4: restoring config space at offset 0x7 (was 0x20000000, writing 0x5050)
pci 0000:00:1c.4: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb5: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb6: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb7: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x8bf18801)
pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xfc30fc30)
pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x22800000, writing 0x22806060)
pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100107)
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.1: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
ata_piix 0000:00:1f.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.1: setting latency timer to 64
ahci 0000:00:1f.2: restoring config space at offset 0xf (was 0x200, writing 0x20a)
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: setting latency timer to 64
i801_smbus 0000:00:1f.3: restoring config space at offset 0x4 (was 0x0, writing 0x8c000000)
iwlagn 0000:06:00.0: enabling device (0000 -> 0002)
iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwlagn 0000:06:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
iwlagn 0000:06:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfa000004)
iwlagn 0000:06:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
iwlagn 0000:06:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100106)
sky2 0000:08:00.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
sky2 0000:08:00.0: restoring config space at offset 0x6 (was 0x1, writing 0x5001)
sky2 0000:08:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfc200004)
sky2 0000:08:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
sky2 0000:08:00.0: restoring config space at offset 0x1 (was 0x40100000, writing 0x100107)
pci 0000:09:03.0: restoring config space at offset 0xf (was 0x34001ff, writing 0x3440105)
pci 0000:09:03.0: restoring config space at offset 0xe (was 0x0, writing 0x64fc)
pci 0000:09:03.0: restoring config space at offset 0xd (was 0x0, writing 0x6400)
pci 0000:09:03.0: restoring config space at offset 0xc (was 0x0, writing 0x60fc)
pci 0000:09:03.0: restoring config space at offset 0xb (was 0x0, writing 0x6000)
pci 0000:09:03.0: restoring config space at offset 0xa (was 0x0, writing 0x93fff000)
pci 0000:09:03.0: restoring config space at offset 0x9 (was 0x0, writing 0x90000000)
pci 0000:09:03.0: restoring config space at offset 0x8 (was 0x0, writing 0x8bfff000)
pci 0000:09:03.0: restoring config space at offset 0x7 (was 0x0, writing 0x88000000)
pci 0000:09:03.0: restoring config space at offset 0x6 (was 0x0, writing 0xb00d0a09)
pci 0000:09:03.0: restoring config space at offset 0x4 (was 0x0, writing 0xfc300000)
pci 0000:09:03.0: restoring config space at offset 0x3 (was 0x820000, writing 0x823110)
pci 0000:09:03.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100107)
pci 0000:09:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci1394 0000:09:03.1: restoring config space at offset 0xf (was 0x4030200, writing 0x403020a)
ohci1394 0000:09:03.1: restoring config space at offset 0x5 (was 0x0, writing 0xfc304000)
ohci1394 0000:09:03.1: restoring config space at offset 0x4 (was 0x0, writing 0xfc302000)
ohci1394 0000:09:03.1: restoring config space at offset 0x3 (was 0x800000, writing 0x802010)
ohci1394 0000:09:03.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100116)
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[fc302000-fc3027ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
tifm_7xx1 0000:09:03.2: restoring config space at offset 0xf (was 0x40703ff, writing 0x4070307)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x4 (was 0x0, writing 0xfc301000)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x3 (was 0x800000, writing 0x803910)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100106)
tifm_7xx1 0000:09:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:02.0: setting latency timer to 64
ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
ata4.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
ata4.00: configured for UDMA/33
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
sd 0:0:0:0: [sda] Starting disk
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Restarting tasks ... <7>wlan0: deauthenticating by local choice (reason=1)
done.
wlan0: direct probe to AP 00:0b:86:dd:92:01 try 1
wlan0: direct probe to AP 00:0b:86:dd:92:01 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:86:dd:92:01
wlan0: authenticated
wlan0: associate with AP 00:0b:86:dd:92:01
wlan0: RX ReassocResp from 00:0b:86:dd:92:01 (capab=0x431 status=0 aid=1)
wlan0: associated
evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
wlan0: deauthenticated
wlan0: direct probe to AP 00:0b:86:dd:92:01 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:86:dd:92:01
wlan0: authenticated
wlan0: associate with AP 00:0b:86:dd:92:01
wlan0: RX ReassocResp from 00:0b:86:dd:92:01 (capab=0x431 status=0 aid=1)
wlan0: associated
phy0: failed to restore operational channel after scan
ACPI: EC: missing confirmations, switch off interrupt mode.
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ACPI handle has no context!
tifm_7xx1 0000:09:03.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
iwlagn 0000:06:00.0: PCI INT A disabled
ahci 0000:00:1f.2: PCI INT B disabled
ata_piix 0000:00:1f.1: PCI INT A disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
HDA Intel 0000:00:1b.0: PCI INT A disabled
ehci_hcd 0000:00:1a.7: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Back to C!
Extended CMOS year: 2000
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3991.30 BogoMIPS (lpj=6650083)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
CPU1 is up
ACPI: Waking up from system sleep state S3
sony-laptop: detected Sony Vaio FZ Series
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
usb usb4: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
pci 0000:00:1c.0: restoring config space at offset 0xf (was 0x40100, writing 0x4010a)
pci 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: restoring config space at offset 0xf (was 0x40200, writing 0x40205)
pci 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0xf3f1f201)
pci 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xf9f0f800)
pci 0000:00:1c.1: restoring config space at offset 0x7 (was 0x0, writing 0x3030)
pci 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: restoring config space at offset 0xf (was 0x40300, writing 0x40307)
pci 0000:00:1c.2: restoring config space at offset 0x9 (was 0x10001, writing 0xf5f1f401)
pci 0000:00:1c.2: restoring config space at offset 0x8 (was 0x0, writing 0xfbf0fa00)
pci 0000:00:1c.2: restoring config space at offset 0x7 (was 0x20000000, writing 0x20004040)
pci 0000:00:1c.2: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.4: restoring config space at offset 0xf (was 0x40100, writing 0x4010a)
pci 0000:00:1c.4: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
pci 0000:00:1c.4: restoring config space at offset 0x8 (was 0x0, writing 0xfc20fc20)
pci 0000:00:1c.4: restoring config space at offset 0x7 (was 0x20000000, writing 0x20005050)
pci 0000:00:1c.4: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb5: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb6: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb7: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x8bf18801)
pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xfc30fc30)
pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x22800000, writing 0x22806060)
pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100107)
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.1: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
ata_piix 0000:00:1f.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.1: setting latency timer to 64
ahci 0000:00:1f.2: restoring config space at offset 0xf (was 0x200, writing 0x20a)
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: setting latency timer to 64
i801_smbus 0000:00:1f.3: restoring config space at offset 0x4 (was 0x0, writing 0x8c000000)
iwlagn 0000:06:00.0: enabling device (0000 -> 0002)
iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwlagn 0000:06:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
iwlagn 0000:06:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfa000004)
iwlagn 0000:06:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
iwlagn 0000:06:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100106)
sky2 0000:08:00.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
sky2 0000:08:00.0: restoring config space at offset 0x6 (was 0x1, writing 0x5001)
sky2 0000:08:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfc200004)
sky2 0000:08:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
sky2 0000:08:00.0: restoring config space at offset 0x1 (was 0x40100000, writing 0x100107)
pci 0000:09:03.0: restoring config space at offset 0xf (was 0x34001ff, writing 0x3440105)
pci 0000:09:03.0: restoring config space at offset 0xe (was 0x0, writing 0x64fc)
pci 0000:09:03.0: restoring config space at offset 0xd (was 0x0, writing 0x6400)
pci 0000:09:03.0: restoring config space at offset 0xc (was 0x0, writing 0x60fc)
pci 0000:09:03.0: restoring config space at offset 0xb (was 0x0, writing 0x6000)
pci 0000:09:03.0: restoring config space at offset 0xa (was 0x0, writing 0x93fff000)
pci 0000:09:03.0: restoring config space at offset 0x9 (was 0x0, writing 0x90000000)
pci 0000:09:03.0: restoring config space at offset 0x8 (was 0x0, writing 0x8bfff000)
pci 0000:09:03.0: restoring config space at offset 0x7 (was 0x0, writing 0x88000000)
pci 0000:09:03.0: restoring config space at offset 0x6 (was 0x0, writing 0xb00d0a09)
pci 0000:09:03.0: restoring config space at offset 0x4 (was 0x0, writing 0xfc300000)
pci 0000:09:03.0: restoring config space at offset 0x3 (was 0x820000, writing 0x823110)
pci 0000:09:03.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100107)
pci 0000:09:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci1394 0000:09:03.1: restoring config space at offset 0xf (was 0x4030200, writing 0x403020a)
ohci1394 0000:09:03.1: restoring config space at offset 0x5 (was 0x0, writing 0xfc304000)
ohci1394 0000:09:03.1: restoring config space at offset 0x4 (was 0x0, writing 0xfc302000)
ohci1394 0000:09:03.1: restoring config space at offset 0x3 (was 0x800000, writing 0x802010)
ohci1394 0000:09:03.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100116)
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[fc302000-fc3027ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
tifm_7xx1 0000:09:03.2: restoring config space at offset 0xf (was 0x40703ff, writing 0x4070307)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x4 (was 0x0, writing 0xfc301000)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x3 (was 0x800000, writing 0x803910)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100106)
tifm_7xx1 0000:09:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:02.0: setting latency timer to 64
ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
ata4.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
ata4.00: configured for UDMA/33
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
sd 0:0:0:0: [sda] Starting disk
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Restarting tasks ... done.
wlan0: direct probe to AP 00:0b:86:dd:92:01 try 1
wlan0: direct probe to AP 00:0b:86:dd:92:01 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:86:dd:92:01
wlan0: authenticated
wlan0: associate with AP 00:0b:86:dd:92:01
wlan0: RX ReassocResp from 00:0b:86:dd:92:01 (capab=0x431 status=0 aid=1)
wlan0: associated
evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
hub 2-0:1.0: unable to enumerate USB device on port 2
usb 2-2: new high speed USB device using ehci_hcd and address 3
usb 2-2: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi5 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
scsi 5:0:0:0: Direct-Access     SanDisk  Sansa Clip 8GB   v02. PQ: 0 ANSI: 0
sd 5:0:0:0: [sdb] 15993856 512-byte hardware sectors: (8.18 GB/7.62 GiB)
sd 5:0:0:0: [sdb] Write Protect is off
sd 5:0:0:0: [sdb] Mode Sense: 04 00 00 00
sd 5:0:0:0: [sdb] Assuming drive cache: write through
sd 5:0:0:0: [sdb] 15993856 512-byte hardware sectors: (8.18 GB/7.62 GiB)
sd 5:0:0:0: [sdb] Write Protect is off
sd 5:0:0:0: [sdb] Mode Sense: 04 00 00 00
sd 5:0:0:0: [sdb] Assuming drive cache: write through
 sdb:
sd 5:0:0:0: [sdb] Attached SCSI removable disk
sd 5:0:0:0: Attached scsi generic sg2 type 0
usb-storage: device scan complete
usb 2-2: USB disconnect, address 3
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.05 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ACPI handle has no context!
tifm_7xx1 0000:09:03.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
iwlagn 0000:06:00.0: PCI INT A disabled
ahci 0000:00:1f.2: PCI INT B disabled
ata_piix 0000:00:1f.1: PCI INT A disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
HDA Intel 0000:00:1b.0: PCI INT A disabled
ehci_hcd 0000:00:1a.7: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Back to C!
Extended CMOS year: 2000
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3991.26 BogoMIPS (lpj=6650021)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
CPU1 is up
ACPI: Waking up from system sleep state S3
sony-laptop: detected Sony Vaio FZ Series
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
usb usb4: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
pci 0000:00:1c.0: restoring config space at offset 0xf (was 0x40100, writing 0x4010a)
pci 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: restoring config space at offset 0xf (was 0x40200, writing 0x40205)
pci 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0xf3f1f201)
pci 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xf9f0f800)
pci 0000:00:1c.1: restoring config space at offset 0x7 (was 0x0, writing 0x3030)
pci 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: restoring config space at offset 0xf (was 0x40300, writing 0x40307)
pci 0000:00:1c.2: restoring config space at offset 0x9 (was 0x10001, writing 0xf5f1f401)
pci 0000:00:1c.2: restoring config space at offset 0x8 (was 0x0, writing 0xfbf0fa00)
pci 0000:00:1c.2: restoring config space at offset 0x7 (was 0x20000000, writing 0x4040)
pci 0000:00:1c.2: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.4: restoring config space at offset 0xf (was 0x40100, writing 0x4010a)
pci 0000:00:1c.4: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
pci 0000:00:1c.4: restoring config space at offset 0x8 (was 0x0, writing 0xfc20fc20)
pci 0000:00:1c.4: restoring config space at offset 0x7 (was 0x20000000, writing 0x5050)
pci 0000:00:1c.4: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pci 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb5: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb6: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb7: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x8bf18801)
pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xfc30fc30)
pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x22800000, writing 0x22806060)
pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100107)
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.1: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
ata_piix 0000:00:1f.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.1: setting latency timer to 64
ahci 0000:00:1f.2: restoring config space at offset 0xf (was 0x200, writing 0x20a)
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: setting latency timer to 64
i801_smbus 0000:00:1f.3: restoring config space at offset 0x4 (was 0x0, writing 0x8c000000)
iwlagn 0000:06:00.0: enabling device (0000 -> 0002)
iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwlagn 0000:06:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
iwlagn 0000:06:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfa000004)
iwlagn 0000:06:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
iwlagn 0000:06:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100106)
sky2 0000:08:00.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
sky2 0000:08:00.0: restoring config space at offset 0x6 (was 0x1, writing 0x5001)
sky2 0000:08:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfc200004)
sky2 0000:08:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
sky2 0000:08:00.0: restoring config space at offset 0x1 (was 0x40100000, writing 0x100107)
pci 0000:09:03.0: restoring config space at offset 0xf (was 0x34001ff, writing 0x3440105)
pci 0000:09:03.0: restoring config space at offset 0xe (was 0x0, writing 0x64fc)
pci 0000:09:03.0: restoring config space at offset 0xd (was 0x0, writing 0x6400)
pci 0000:09:03.0: restoring config space at offset 0xc (was 0x0, writing 0x60fc)
pci 0000:09:03.0: restoring config space at offset 0xb (was 0x0, writing 0x6000)
pci 0000:09:03.0: restoring config space at offset 0xa (was 0x0, writing 0x93fff000)
pci 0000:09:03.0: restoring config space at offset 0x9 (was 0x0, writing 0x90000000)
pci 0000:09:03.0: restoring config space at offset 0x8 (was 0x0, writing 0x8bfff000)
pci 0000:09:03.0: restoring config space at offset 0x7 (was 0x0, writing 0x88000000)
pci 0000:09:03.0: restoring config space at offset 0x6 (was 0x0, writing 0xb00d0a09)
pci 0000:09:03.0: restoring config space at offset 0x4 (was 0x0, writing 0xfc300000)
pci 0000:09:03.0: restoring config space at offset 0x3 (was 0x820000, writing 0x823110)
pci 0000:09:03.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100107)
pci 0000:09:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci1394 0000:09:03.1: restoring config space at offset 0xf (was 0x4030200, writing 0x403020a)
ohci1394 0000:09:03.1: restoring config space at offset 0x5 (was 0x0, writing 0xfc304000)
ohci1394 0000:09:03.1: restoring config space at offset 0x4 (was 0x0, writing 0xfc302000)
ohci1394 0000:09:03.1: restoring config space at offset 0x3 (was 0x800000, writing 0x802010)
ohci1394 0000:09:03.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100116)
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[fc302000-fc3027ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
tifm_7xx1 0000:09:03.2: restoring config space at offset 0xf (was 0x40703ff, writing 0x4070307)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x4 (was 0x0, writing 0xfc301000)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x3 (was 0x800000, writing 0x803910)
tifm_7xx1 0000:09:03.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100106)
tifm_7xx1 0000:09:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:02.0: setting latency timer to 64
ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
ata4.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
ata4.00: configured for UDMA/33
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
sd 0:0:0:0: [sda] Starting disk
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Restarting tasks ... <7>wlan0: direct probe to AP 00:0b:86:dd:92:01 try 1
done.
wlan0: direct probe to AP 00:0b:86:dd:92:01 try 2
wlan0: direct probe to AP 00:0b:86:dd:92:01 try 3
wlan0: direct probe to AP 00:0b:86:dd:92:01 timed out
wlan0: direct probe to AP 00:0b:86:28:1a:d1 try 1
wlan0: direct probe to AP 00:0b:86:28:1a:d1 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:86:28:1a:d1
wlan0: authenticated
wlan0: associate with AP 00:0b:86:28:1a:d1
wlan0: RX ReassocResp from 00:0b:86:28:1a:d1 (capab=0x431 status=0 aid=1)
wlan0: associated
evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
wlan0: deauthenticated
wlan0: direct probe to AP 00:0b:86:28:1a:d1 try 1
wlan0: direct probe to AP 00:0b:86:28:1a:d1 try 2
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:86:28:1a:d1
wlan0: authenticated
wlan0: associate with AP 00:0b:86:28:1a:d1
wlan0: RX ReassocResp from 00:0b:86:28:1a:d1 (capab=0x431 status=0 aid=1)
wlan0: associated
phy0: failed to restore operational channel after scan
phy0: failed to restore operational channel after scan
wlan0: direct probe to AP 00:0b:86:28:21:71 try 1
wlan0: direct probe to AP 00:0b:86:28:21:71 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:86:28:21:71
wlan0: authenticated
wlan0: associate with AP 00:0b:86:28:21:71
wlan0: associate with AP 00:0b:86:28:21:71
wlan0: RX ReassocResp from 00:0b:86:28:21:71 (capab=0x431 status=0 aid=1)
wlan0: associated
ACPI: EC: missing confirmations, switch off interrupt mode.
iwlagn 0000:06:00.0: PCI INT A disabled
iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwlagn 0000:06:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x100106)
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
iwlagn 0000:06:00.0: PCI INT A disabled
iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwlagn 0000:06:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x100106)
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
wlan0: direct probe to AP 00:0b:86:3e:10:31 try 1
wlan0: direct probe to AP 00:0b:86:3e:10:31 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:86:3e:10:31
wlan0: authenticated
wlan0: associate with AP 00:0b:86:3e:10:31
wlan0: RX AssocResp from 00:0b:86:3e:10:31 (capab=0x431 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating by local choice (reason=3)
iwlagn 0000:06:00.0: PCI INT A disabled
iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwlagn 0000:06:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x100106)
general protection fault: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
CPU 1 
Modules linked in: nls_iso8859_1 nls_cp437 vfat fat usb_storage xt_comment xt_policy xt_tcpmss xt_pkttype xt_owner xt_NFQUEUE xt_NFLOG xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_hashlimit xt_dscp xt_dccp xt_CLASSIFY snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss nvram ohci1394 ieee1394 snd_hda_intel uvcvideo snd_pcm sg sky2 i2c_i801 sr_mod iwlagn compat_ioctl32 snd_timer evdev videodev snd_page_alloc v4l1_compat snd_hwdep ata_piix ahci libata sd_mod scsi_mod uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
Pid: 3163, comm: ifplugd Not tainted 2.6.28-rc4-keypress-00322-g58e20d8 #14
RIP: 0010:[<ffffffff803d844b>]  [<ffffffff803d844b>] iwl_eeprom_query16+0xb/0x20
RSP: 0018:ffff88007b631a88  EFLAGS: 00010092
RAX: 7fff88007dfd5400 RBX: ffff88007d81a000 RCX: 00000000800600f0
RDX: 0000000000000cfc RSI: 0000000000000090 RDI: ffff88007dcc1940
RBP: ffff88007b631a88 R08: 0000000000000002 R09: ffff88007b631a5c
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000080006
R13: ffff88007dcc1940 R14: ffff88007dcc29f8 R15: ffff88007d81a740
FS:  00007f7f93ef16f0(0000) GS:ffff88007f0686c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002ad88fdfd000 CR3: 000000007d935000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ifplugd (pid: 3163, threadinfo ffff88007b630000, task ffff88007b5ba980)
Stack:
 ffff88007b631af8 ffffffffa0108526 ffff88007b631af8 ffffffffa00f3aaf
 0000000000000000 ffff88007dcc2328 0000000000000292 0000000000000000
 0143000000000000 ffff88007d81a000 ffff88007dcc1940 ffff88007dcc2328
Call Trace:
 [<ffffffffa0108526>] iwl4965_nic_config+0xa6/0x380 [iwlagn]
 [<ffffffffa00f3aaf>] ? iwl4965_set_pwr_src+0x1cf/0x3d0 [iwlagn]
 [<ffffffff803d5a9b>] iwl_hw_nic_init+0x11b/0x1d0
 [<ffffffffa00fbe17>] __iwl4965_up+0x1a7/0x720 [iwlagn]
 [<ffffffffa00fd0c8>] iwl4965_mac_start+0xd38/0x1570 [iwlagn]
 [<ffffffff8022d365>] ? __wake_up_sync+0x55/0x70
 [<ffffffff8043000f>] ? sock_def_readable+0x6f/0x80
 [<ffffffff8049b893>] ? unix_dgram_sendmsg+0x463/0x4f0
 [<ffffffff804b5cf8>] ieee80211_open+0x328/0x830
 [<ffffffff8042bf5b>] ? sock_sendmsg+0xdb/0xf0
 [<ffffffff8043cba4>] dev_open+0x64/0xc0
 [<ffffffff8043ba71>] dev_change_flags+0x91/0x1b0
 [<ffffffff8047fde3>] devinet_ioctl+0x5b3/0x750
 [<ffffffff8048096d>] inet_ioctl+0x6d/0x90
 [<ffffffff8042c4d5>] sock_ioctl+0xc5/0x240
 [<ffffffff802a60f1>] vfs_ioctl+0x31/0x90
 [<ffffffff802a647b>] do_vfs_ioctl+0x32b/0x460
 [<ffffffff802a65fa>] sys_ioctl+0x4a/0x80
 [<ffffffff8020c1fb>] system_call_fastpath+0x16/0x1b
Code: 48 8b 47 18 55 48 89 e5 48 8b 40 18 48 8b 00 ff 90 00 01 00 00 c9 c3 66 0f 1f 84 00 00 00 00 00 48 8b 87 98 22 01 00 55 48 89 e5 <0f> b6 54 06 01 0f b6 04 30 c9 c1 e2 08 09 d0 0f b7 c0 c3 66 90 
RIP  [<ffffffff803d844b>] iwl_eeprom_query16+0xb/0x20
 RSP <ffff88007b631a88>
---[ end trace 28eaede31d178563 ]---

