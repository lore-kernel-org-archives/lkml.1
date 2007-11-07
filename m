Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbXKGUms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbXKGUms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 15:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXKGUml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 15:42:41 -0500
Received: from host-66-43-248-10 ([67.55.143.10]:59013 "EHLO albrecht.rdi1.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754602AbXKGUmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 15:42:39 -0500
Subject: Re: unionfs and sys_readahead
From: Paul Albrecht <albrecht@rdi1.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200711071953.25716.vda.linux@googlemail.com>
References: <1194386482.7489.5.camel@albrecht.rdi1.com>
	 <200711071953.25716.vda.linux@googlemail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Nov 2007 14:43:39 -0600
Message-Id: <1194468220.5538.10.camel@albrecht.rdi1.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-07 at 19:53 +0000, Denys Vlasenko wrote:
> On Tuesday 06 November 2007 22:01, Paul Albrecht wrote:
> > Hi,
> > 
> > Whenever I use readahead-list on a union mounted file system I get a
> > segfault and kernel oops so I'm wondering whether or not the linux
> > unionfs supports sys_readahead.
> > 
> > Anyone know? I'm not usually subscribed to the lkml so please cc me in
> > your response. Thanks.
> 
> Please show actual oops output.
> 
> Also: what kernel version do you use? any extra patch(es) applied? .config?

I'm using a stock generic kernel that's shipped with ubuntu. Here's my
dmesg output containing two oops. The first occurs during boot and the
second happens whenever I run readahead-list from the command line
against a file list containing an entry in a union mounted filesystem:

[    0.000000] Linux version 2.6.22-14-generic (buildd@palmer) (gcc
version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Sun
Oct 14 23:05:12 GMT 2007 (Ubuntu 2.6.22-14.46-generic)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000
(reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000
(reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001dee0000 (usable)
[    0.000000]  BIOS-e820: 000000001dee0000 - 000000001dee3000 (ACPI
NVS)
[    0.000000]  BIOS-e820: 000000001dee3000 - 000000001def0000 (ACPI
data)
[    0.000000]  BIOS-e820: 000000001def0000 - 000000001df00000
(reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000
(reserved)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 478MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f4360
[    0.000000] Entering add_active_range(0, 0, 122592) 0 entries of 256
used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   122592
[    0.000000]   HighMem    122592 ->   122592
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   122592
[    0.000000] On node 0 totalpages: 122592
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 925 pages used for memmap
[    0.000000]   Normal zone: 117571 pages, LIFO batch:31
[    0.000000]   HighMem zone: 0 pages used for memmap
[    0.000000] DMI 2.2 present.
[    0.000000] ACPI: RSDP signature @ 0xC00F6420 checksum 0
[    0.000000] ACPI: RSDP 000F6420, 0014 (r0 IntelR)
[    0.000000] ACPI: RSDT 1DEE3040, 002C (r1 IntelR AWRDACPI 42302E31
AWRD        0)
[    0.000000] ACPI: FACP 1DEE30C0, 0074 (r1 IntelR AWRDACPI 42302E31
AWRD        0)
[    0.000000] ACPI: DSDT 1DEE3180, 3C2B (r1 INTELR AWRDACPI     1000
MSFT  100000E)
[    0.000000] ACPI: FACS 1DEE0000, 0040
[    0.000000] ACPI: APIC 1DEE6E00, 0068 (r1 IntelR AWRDACPI 42302E31
AWRD        0)
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:9 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high
level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 20000000 (gap:
1df00000:e0d00000)
[    0.000000] Built 1 zonelists.  Total pages: 121635
[    0.000000] Kernel command line:
root=UUID=4a6b4df9-cddd-4b5a-8d5a-e7c8b2f72824 ro nofsck
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 599.961 MHz processor.
[   18.211221] Console: colour VGA+ 80x25
[   18.214292] Dentry cache hash table entries: 65536 (order: 6, 262144
bytes)
[   18.214832] Inode-cache hash table entries: 32768 (order: 5, 131072
bytes)
[   18.245276] Memory: 474380k/490368k available (2015k kernel code,
15444k reserved, 916k data, 364k init, 0k highmem)
[   18.245402] virtual kernel memory layout:
[   18.245405]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[   18.245409]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   18.245413]     vmalloc : 0xde800000 - 0xff7fe000   ( 527 MB)
[   18.245417]     lowmem  : 0xc0000000 - 0xddee0000   ( 478 MB)
[   18.245421]       .init : 0xc03e3000 - 0xc043e000   ( 364 kB)
[   18.245425]       .data : 0xc02f7d26 - 0xc03dce84   ( 916 kB)
[   18.245429]       .text : 0xc0100000 - 0xc02f7d26   (2015 kB)
[   18.245949] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[   18.246163] SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4,
CPUs=1, Nodes=1
[   18.326245] Calibrating delay using timer specific routine.. 1201.05
BogoMIPS (lpj=2402110)
[   18.326423] Security Framework v1.0.0 initialized
[   18.326499] SELinux:  Disabled at boot.
[   18.326595] Mount-cache hash table entries: 512
[   18.326933] CPU: After generic identify, caps: a7e9fbbf 00000000
00000000 00000000 00000000 00000000 00000000
[   18.326960] CPU: L1 I cache: 32K, L1 D cache: 32K
[   18.327064] CPU: L2 cache: 512K
[   18.327129] CPU: After all inits, caps: a7e9fbbf 00000000 00000000
00002040 00000000 00000000 00000000
[   18.327152] Compat vDSO mapped to ffffe000.
[   18.327237] Checking 'hlt' instruction... OK.
[   18.342533] SMP alternatives: switching to UP code
[   18.342974] Freeing SMP alternatives: 11k freed
[   18.343711] Early unpacking initramfs... done
[   19.342374] ACPI: Core revision 20070126
[   19.342586] ACPI: Looking for DSDT in initramfs... error,
file /DSDT.aml not found.
[   19.350955] CPU0: Intel Genuine Intel(R) processor
600MHz stepping 05
[   19.351201] Total of 1 processors activated (1201.05 BogoMIPS).
[   19.351405] ENABLING IO-APIC IRQs
[   19.351703] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   19.497807] Brought up 1 CPUs
[   19.498097] Booting paravirtualized kernel on bare hardware
[   19.498272] Time: 20:16:13  Date: 10/06/107
[   19.498379] NET: Registered protocol family 16
[   19.498615] EISA bus registered
[   19.498693] ACPI: bus type pci registered
[   19.522504] PCI: PCI BIOS revision 2.10 entry at 0xfb080, last bus=1
[   19.522576] PCI: Using configuration type 1
[   19.522642] Setting up standard PCI resources
[   19.535319] ACPI: EC: Look up EC in DSDT
[   19.545398] ACPI: Interpreter enabled
[   19.545472] ACPI: (supports S0 S1 S4 S5)
[   19.545754] ACPI: Using IOAPIC for interrupt routing
[   19.558719] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   19.558799] PCI: Probing PCI hardware (bus 00)
[   19.559405] * The chipset may have PM-Timer Bug. Due to workarounds
for a bug,
[   19.559410] * this clock source is slow. If you are sure your timer
does not have
[   19.559415] * this bug, please use "acpi_pm_good" to disable the
workaround
[   19.559710] PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
[   19.559784] PCI quirk: region 0480-04bf claimed by ICH4 GPIO
[   19.560248] PCI: Transparent bridge - 0000:00:1e.0
[   19.560351] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   19.560769] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[   19.578530] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 *9 10 11 12
14 15)
[   19.579270] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 9 10 11 12
14 15)
[   19.580004] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 9 10 11 12
14 15)
[   19.580736] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *9 10 11 12
14 15)
[   19.581469] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12
14 15) *0, disabled.
[   19.582301] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 7 9 10 11 12
14 15)
[   19.583034] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12
14 15) *0, disabled.
[   19.583853] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 *9 10 11 12
14 15)
[   19.584542] Linux Plug and Play Support v0.97 (c) Adam Belay
[   19.584631] pnp: PnP ACPI init
[   19.584719] ACPI: bus type pnp registered
[   19.593310] pnp: PnP ACPI: found 15 devices
[   19.593379] ACPI: ACPI bus type pnp unregistered
[   19.593451] PnPBIOS: Disabled by ACPI PNP
[   19.593622] PCI: Using ACPI for IRQ routing
[   19.593691] PCI: If a device doesn't work, try "pci=routeirq".  If it
helps, post a report
[   19.605242] NET: Registered protocol family 8
[   19.605309] NET: Registered protocol family 20
[   19.605529] pnp: 00:0c: ioport range 0x400-0x4bf could not be
reserved
[   19.605613] pnp: 00:0e: iomem range 0xf0000-0xfffff could not be
reserved
[   19.605690] pnp: 00:0e: iomem range 0x1dee0000-0x1defffff could not
be reserved
[   19.605786] Time: tsc clocksource has been installed.
[   19.605861] pnp: 00:0e: iomem range 0x0-0x9ffff could not be reserved
[   19.605936] pnp: 00:0e: iomem range 0x100000-0x1dedffff could not be
reserved
[   19.636700] PCI: Bridge: 0000:00:1e.0
[   19.636768]   IO window: d000-dfff
[   19.636836]   MEM window: e8000000-e80fffff
[   19.636905]   PREFETCH window: 28000000-280fffff
[   19.636986] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   19.637016] NET: Registered protocol family 2
[   19.673727] IP route cache hash table entries: 4096 (order: 2, 16384
bytes)
[   19.673873] TCP established hash table entries: 16384 (order: 5,
196608 bytes)
[   19.674325] TCP bind hash table entries: 16384 (order: 5, 131072
bytes)
[   19.674645] TCP: Hash tables configured (established 16384 bind
16384)
[   19.674717] TCP reno registered
[   19.685983] checking if image is initramfs...<6>Switched to high
resolution mode on CPU 0
[   20.636733]  it is
[   21.644973] Freeing initrd memory: 7331k freed
[   21.645718] audit: initializing netlink socket (disabled)
[   21.645810] audit(1194380175.256:1): initialized
[   21.651568] VFS: Disk quotas dquot_6.5.1
[   21.651777] Dquot-cache hash table entries: 1024 (order 0, 4096
bytes)
[   21.652081] io scheduler noop registered
[   21.652148] io scheduler anticipatory registered
[   21.652215] io scheduler deadline registered
[   21.652332] io scheduler cfq registered (default)
[   21.652424] Boot video device is 0000:00:02.0
[   21.652839] isapnp: Scanning for PnP cards...
[   22.006994] isapnp: No Plug & Play device found
[   22.081528] Real Time Clock Driver v1.12ac
[   22.081795] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ
sharing enabled
[   22.082007] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   22.082408] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   22.082773] serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
[   22.083136] serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
[   22.084066] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   22.084705] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   22.085384] 00:0a: ttyS2 at I/O 0x3e8 (irq = 10) is a 16550A
[   22.085950] 00:0b: ttyS3 at I/O 0x2e8 (irq = 11) is a 16550A
[   22.087674] RAMDISK driver initialized: 16 RAM disks of 65536K size
1024 blocksize
[   22.088240] input: Macintosh mouse button emulation
as /class/input/input0
[   22.088567] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   22.088640] PNP: PS/2 controller doesn't have AUX irq; using default
12
[   22.340632] serio: i8042 KBD port at 0x60,0x64 irq 1
[   22.340996] mice: PS/2 mouse device common for all mice
[   22.341306] EISA: Probing bus 0 at eisa.0
[   22.341424] EISA: Detected 0 cards.
[   22.341693] TCP cubic registered
[   22.341787] NET: Registered protocol family 1
[   22.341906] Using IPI No-Shortcut mode
[   22.342305]   Magic number: 15:322:295
[   22.342403]   hash matches device ttyz9
[   22.342481]   hash matches device ttywc
[   22.342670]   hash matches device tty28
[   22.343082] Freeing unused kernel memory: 364k freed
[   22.368439] input: AT Translated Set 2 keyboard
as /class/input/input1
[   22.798033] AppArmor: AppArmor initialized<5>audit(1194380176.256:2):
type=1505 info="AppArmor initialized" pid=1167
[   22.821767] fuse init (API version 7.8)
[   22.833899] Failure registering capabilities with primary security
module.
[   22.849082] ACPI: Fan [FAN] (on)
[   22.862957] ACPI Exception (processor_core-0783): AE_NOT_FOUND,
Processor Device is not present [20070126]
[   22.869125] ACPI: Thermal Zone [THRM] (59 C)
[   24.061245] usbcore: registered new interface driver usbfs
[   24.061367] usbcore: registered new interface driver hub
[   24.061498] usbcore: registered new device driver usb
[   24.065301] USB Universal Host Controller Interface driver v3.0
[   24.065492] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   24.065633] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   24.065642] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   24.065961] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 1
[   24.066088] uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000eb00
[   24.066460] usb usb1: configuration #1 chosen from 1 choice
[   24.066592] hub 1-0:1.0: USB hub found
[   24.066665] hub 1-0:1.0: 2 ports detected
[   24.167745] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level,
low) -> IRQ 17
[   24.167895] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   24.167905] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   24.168025] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 2
[   24.168151] uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000ed00
[   24.168475] usb usb2: configuration #1 chosen from 1 choice
[   24.168609] hub 2-0:1.0: USB hub found
[   24.168683] hub 2-0:1.0: 2 ports detected
[   24.234718] SCSI subsystem initialized
[   24.263300] libata version 2.21 loaded.
[   24.271615] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level,
low) -> IRQ 18
[   24.271762] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   24.271771] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   24.271899] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 3
[   24.272025] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
[   24.272347] usb usb3: configuration #1 chosen from 1 choice
[   24.272479] hub 3-0:1.0: USB hub found
[   24.272553] hub 3-0:1.0: 2 ports detected
[   24.376957] ata_piix 0000:00:1f.1: version 2.11
[   24.376987] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level,
low) -> IRQ 18
[   24.377178] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   24.377335] scsi0 : ata_piix
[   24.377501] scsi1 : ata_piix
[   24.377828] ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6
bmdma 0x0001f000 irq 14
[   24.377927] ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376
bmdma 0x0001f008 irq 15
[   24.528034] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[   24.539684] ata1.00: ATA-6: HTS548040M9AT00, MG2OA53A, max UDMA/100
[   24.539766] ata1.00: 78140160 sectors, multi 16: LBA48 
[   24.539847] ata1.00: limited to UDMA/33 due to 40-wire cable
[   24.555689] ata1.00: configured for UDMA/33
[   24.615212] usb 3-2: new low speed USB device using uhci_hcd and
address 2
[   24.719183] scsi 0:0:0:0: Direct-Access     ATA      HTS548040M9AT00
MG2O PQ: 0 ANSI: 5
[   24.729772] r8169 Gigabit Ethernet driver 2.2LK loaded
[   24.729879] ACPI: PCI Interrupt 0000:01:0d.0[A] -> GSI 21 (level,
low) -> IRQ 19
[   24.730253] eth0: RTL8169sc/8110sc at 0xde83a000, 00:d0:f8:1f:b3:3f,
XID 18000000 IRQ 19
[   24.731173] 8139cp 0000:01:0f.0: This (id 10ec:8139 rev 10) is not an
8139C+ compatible chip
[   24.731272] 8139cp 0000:01:0f.0: Try the "8139too" driver instead.
[   24.739692] 8139too Fast Ethernet driver 0.9.28
[   24.739831] ACPI: PCI Interrupt 0000:01:0f.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   24.740365] eth1: RealTek RTL8139 at 0xde83c000, 00:d0:f8:1f:b3:3e,
IRQ 16
[   24.740440] eth1:  Identified 8139 chip type 'RTL-8100B/8139D'
[   24.744234] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level,
low) -> IRQ 20
[   24.744379] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   24.744388] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   24.744525] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 4
[   24.744671] PCI: cache line size of 32 is not supported by device
0000:00:1d.7
[   24.744696] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe8180000
[   24.748645] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver
10 Dec 2004
[   24.748953] usb usb4: configuration #1 chosen from 1 choice
[   24.749090] hub 4-0:1.0: USB hub found
[   24.749165] hub 4-0:1.0: 6 ports detected
[   24.766855] usb 3-2: device descriptor read/all, error -71
[   25.029034] sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors
(40008 MB)
[   25.029167] sd 0:0:0:0: [sda] Write Protect is off
[   25.029237] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   25.029278] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   25.029486] sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors
(40008 MB)
[   25.029577] sd 0:0:0:0: [sda] Write Protect is off
[   25.029646] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   25.029682] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   25.029781]  sda: sda1 sda2 sda3 < sda5 >
[   25.094804] sd 0:0:0:0: [sda] Attached SCSI disk
[   25.108445] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   25.370852] usb 3-2: new low speed USB device using uhci_hcd and
address 4
[   25.393859] Attempting manual resume
[   25.393928] swsusp: Resume From Partition 8:2
[   25.393933] PM: Checking swsusp image.
[   25.394232] PM: Resume from disk failed.
[   25.471552] kjournald starting.  Commit interval 5 seconds
[   25.471645] EXT3-fs: mounted filesystem with ordered data mode.
[   25.536330] kjournald starting.  Commit interval 5 seconds
[   25.536823] EXT3 FS on sda5, internal journal
[   25.536922] EXT3-fs: recovery complete.
[   25.537265] EXT3-fs: mounted filesystem with ordered data mode.
[   25.551441] Registering unionfs 1.4
[   25.551512] unionfs: debugging is not enabled
[   25.557519] usb 3-2: configuration #1 chosen from 1 choice
[   25.596262] usbcore: registered new interface driver hiddev
[   25.610469] input: Microsoft Basic Optical Mouse
as /class/input/input2
[   25.610943] input: USB HID v1.10 Mouse [Microsoft Basic Optical
Mouse] on usb-0000:00:1d.2-2
[   25.611129] usbcore: registered new interface driver usbhid
[
25.611203] /build/buildd/linux-source-2.6.22-2.6.22/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   26.917746] BUG: unable to handle kernel NULL pointer dereference at
virtual address 00000014
[   26.917902]  printing eip:
[   26.917962] c02f3e51
[   26.918033] *pde = 00000000
[   26.918096] Oops: 0002 [#1]
[   26.918155] SMP 
[   26.918279] Modules linked in: usbhid hid unionfs ext3 jbd mbcache sg
sd_mod 8139too ata_generic 8139cp mii r8169 ata_piix libata scsi_mod
ehci_hcd uhci_hcd usbcore thermal processor fan fuse apparmor commoncap
[   26.919287] CPU:    0
[   26.919290] EIP:    0060:[<c02f3e51>]    Not tainted VLI
[   26.919294] EFLAGS: 00010296   (2.6.22-14-generic #1)
[   26.919490] EIP is at _spin_lock+0x1/0x10
[   26.919558] eax: 00000014   ebx: 00000000   ecx: dd829c30   edx:
dd829b98
[   26.919632] esi: 00000000   edi: 00000000   ebp: 00000000   esp:
c16b9f38
[   26.919706] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[   26.919780] Process readahead-list (pid: 2466, ti=c16b8000
task=dc5d54c0 task.ti=c16b8000)
[   26.919857] Stack: de92261a 00000014 00000000 dc5d54c0 c013bdd0
c16b9f4c c16b9f4c 00000000 
[   26.920252]        dd829cd4 00000000 00000000 de95f329 00000001
dd829cd4 de96d0c0 dd829cd4 
[   26.920645]        00000000 c16b8000 c018cbc4 dc5d54c0 dda26700
00000000 dc5e39c0 0804b01c 
[   26.921040] Call Trace:
[   26.921151]  [<de92261a>] journal_lock_updates+0x5a/0xe0 [jbd]
[   26.921275]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   26.921388]  [<de95f329>] ext3_bmap+0x49/0x90 [ext3]
[   26.921513]  [<c018cbc4>] vfs_ioctl+0x114/0x290
[   26.921619]  [<c018cdb2>] sys_ioctl+0x72/0x90
[   26.921723]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
[   26.921835]  =======================
[   26.921898] Code: 00 00 01 0f 94 c0 84 c0 b9 01 00 00 00 75 09 90 81
02 00 00 00 01 30 c9 89 c8 c3 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
90 90 <fe> 08 79 09 f3 90 80 38 00 7e f9 eb f2 c3 90 90 81 28 00 00 00 
[   26.924179] EIP: [<c02f3e51>] _spin_lock+0x1/0x10 SS:ESP
0068:c16b9f38
[   36.616946] Linux agpgart interface v0.102 (c) Dave Jones
[   36.654435] agpgart: Detected an Intel 855GM Chipset.
[   36.654803] agpgart: Detected 32636K stolen memory.
[   36.664039] agpgart: AGP aperture is 128M @ 0xe0000000
[   36.930507] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   37.563259] intel_rng: FWH not detected
[   37.569068] shpchp: Standard Hot Plug PCI Controller Driver version:
0.4
[   39.582512] iTCO_vendor_support: vendor-support=0
[   39.609540] input: PC Speaker as /class/input/input3
[   39.935416] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01
(21-Jan-2007)
[   39.935644] iTCO_wdt: Found a ICH4 TCO device (Version=1,
TCOBASE=0x0460)
[   39.936913] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   40.029080] parport_pc 00:08: reported by Plug and Play ACPI
[   40.029204] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   40.829736] ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level,
low) -> IRQ 21
[   40.829899] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[   41.150705] intel8x0_measure_ac97_clock: measured 54613 usecs
[   41.150784] intel8x0: clocking to 48000
[   42.354719] lp0: using parport0 (interrupt-driven).
[   46.498842] NET: Registered protocol family 17
[   49.258074] No dock devices found.
[   49.710348] input: Power Button (FF) as /class/input/input4
[   49.710835] ACPI: Power Button (FF) [PWRF]
[   49.730351] input: Power Button (CM) as /class/input/input5
[   49.730829] ACPI: Power Button (CM) [PWRB]
[   52.910900] ppdev: user-space parallel port driver
[   53.693263] r8169: eth0: link down
[   53.842703] eth1: link down
[   54.035936] audit(1194380207.511:3):  type=1503
operation="file_mprotect" requested_mask="mr" denied_mask="mr"
name="/root/lib/tls/i686/cmov/libc-2.6.1.so" pid=4702
profile="/usr/sbin/cupsd"
[   54.184851] apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
[   54.184862] apm: overridden by ACPI.
[   54.667654] Failure registering capabilities with primary security
module.
[   55.031426] Bluetooth: Core ver 2.11
[   55.031693] NET: Registered protocol family 31
[   55.031700] Bluetooth: HCI device and connection manager initialized
[   55.031708] Bluetooth: HCI socket layer initialized
[   55.103007] Bluetooth: L2CAP ver 2.8
[   55.103017] Bluetooth: L2CAP socket layer initialized
[   55.224658] Bluetooth: RFCOMM socket layer initialized
[   55.224862] Bluetooth: RFCOMM TTY layer initialized
[   55.224869] Bluetooth: RFCOMM ver 1.8
[   59.507415] [drm] Initialized drm 1.1.0 20060810
[   59.517090] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   59.521332] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   59.521554] PCI: Enabling device 0000:00:02.1 (0000 -> 0002)
[   59.525688] [drm] Initialized i915 1.6.0 20060119 on minor 1
[   87.108202] NET: Registered protocol family 10
[   87.108610] lo: Disabled Privacy Extensions
[   87.108910] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   87.108948] ADDRCONF(NETDEV_UP): eth1: link is not ready
[  190.568565] BUG: unable to handle kernel NULL pointer dereference at
virtual address 0000005c
[  190.568582]  printing eip:
[  190.568587] c01a5c20
[  190.568592] *pde = 00000000
[  190.568599] Oops: 0000 [#2]
[  190.568603] SMP 
[  190.568610] Modules linked in: ipv6 i915 drm rfcomm l2cap bluetooth
ppdev cpufreq_ondemand cpufreq_conservative cpufreq_stats freq_table
cpufreq_powersave cpufreq_userspace button sbs ac video container dock
battery af_packet lp snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore
parport_pc iTCO_wdt parport snd_page_alloc pcspkr iTCO_vendor_support
shpchp pci_hotplug intel_agp agpgart evdev usbhid hid unionfs ext3 jbd
mbcache sg sd_mod 8139too ata_generic 8139cp mii r8169 ata_piix libata
scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan fuse apparmor
commoncap
[  190.568744] CPU:    0
[  190.568747] EIP:    0060:[<c01a5c20>]    Not tainted VLI
[  190.568751] EFLAGS: 00210246   (2.6.22-14-generic #1)
[  190.568766] EIP is at bio_get_nr_vecs+0x0/0x40
[  190.568773] eax: 00000000   ebx: 00001000   ecx: 0000000c   edx:
00000000
[  190.568782] esi: 00000008   edi: 00000000   ebp: 00000001   esp:
c9aa3d88
[  190.568790] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[  190.568800] Process readahead-list (pid: 5537, ti=c9aa2000
task=cc4e6a60 task.ti=c9aa2000)
[  190.568807] Stack: c01a959e c9aa3ea0 00000000 ddce2330 c9aa3f30
c9aa3df8 00000001 00000000 
[  190.568826]        de95e250 c9aa3ee0 c9aa3ea0 c9aa3ed8 000000ac
c1056c60 00000000 db3c41b0 
[  190.568845]        0000000c 00000001 000000ac 00000000 00000001
00000000 00000001 c3856005 
[  190.568861] Call Trace:
[  190.568868]  [<c01a959e>] do_mpage_readpage+0x43e/0x720
[  190.568899]  [<de95e250>] ext3_get_block+0x0/0x100 [ext3]
[  190.568994]  [<c015ea9f>] add_to_page_cache+0x9f/0xb0
[  190.569017]  [<c01a9a65>] mpage_readpages+0x95/0x150
[  190.569036]  [<de95e250>] ext3_get_block+0x0/0x100 [ext3]
[  190.569126]  [<de95d570>] ext3_readpages+0x0/0x20 [ext3]
[  190.569159]  [<c0165448>] __do_page_cache_readahead+0x178/0x250
[  190.569173]  [<de95e250>] ext3_get_block+0x0/0x100 [ext3]
[  190.569246]  [<c0165999>] force_page_cache_readahead+0x59/0x80
[  190.569269]  [<c015e55d>] sys_readahead+0x9d/0xd0
[  190.569294]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
[  190.569319]  [<c02f0000>] clip_ioctl+0x500/0x510
[  190.569344]  =======================
[  190.569349] Code: 89 e8 83 c4 10 5b 5e 5f 5d c3 8b 75 30 0f b7 45 18
eb ce 89 d0 e8 e1 6c fd ff 90 e9 59 ff ff ff bd f4 ff ff ff e9 46 ff ff
ff 90 <8b> 40 5c 8b 50 38 8b 82 38 01 00 00 0f b7 8a 40 01 00 00 0f b7 
[  190.569429] EIP: [<c01a5c20>] bio_get_nr_vecs+0x0/0x40 SS:ESP
0068:c9aa3d88
[  305.816936] eth1: link up, 10Mbps, half-duplex, lpa 0x0000
[  305.817472] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[  320.551422] eth1: no IPv6 routers present


Paul Albrecht
