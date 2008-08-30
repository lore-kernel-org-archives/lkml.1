Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYH3Uv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYH3Uv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 16:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYH3Uvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 16:51:50 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:60111 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752898AbYH3Uvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 16:51:48 -0400
Date: Sat, 30 Aug 2008 22:51:43 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20080830205143.GA9726@anita>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <48B90F7F.8040308@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Am 2008-08-30 11:14 +0200 schrieb Tejun Heo:

> Hmm... Can you post full dmesg output?  We used to see things like above

Of course :-)

dmesg is attached with patch applied. At the end of the patch it (of
course) continues, but only with:

ata1: EH complete
ata1: EH complete
ata1: EH complete
...

> when ATAPI CHECK SENSE handling somehow failed to tell EH that it was an
> exception not worth whining about.  Maybe EH action mask is not being
> cleared properly?

Hmn, to take my pants down entirely: What is this "EH"?

And how does the change of the .reset function affect this? May be, I
will take a look onto this.

> > I am curious if it boots tomorrow after sleeping for one night :-P
> 
> I somehow feel pretty optimistic about that part.  :-)

You are right, it started immediately without a hitch this morning after
sleeping entirely for a couple of hours.

Kind Regards, Konsti


-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-2.6.27-rc3_ATA_OP_NULL.txt"

 97)
ACPI: DSDT 3FFB03F0, 3F26 (r1  K8UNF K8UNF201      201 INTL  2002026)
ACPI: FACS 3FFC0000, 0040
ACPI: APIC 3FFB0390, 005C (r1 A M I  OEMAPIC   8000607 MSFT       97)
ACPI: OEMB 3FFC0040, 0056 (r1 A M I  AMI_OEM   8000607 MSFT       97)
(4 early reservations) ==> bootmem [0000000000 - 003ffb0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000200000 - 000054e670]    TEXT DATA BSS ==> [0000200000 - 000054e670]
  #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #3 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
 [ffffe20000000000-ffffe20000dfffff] PMD -> [ffff880001200000-ffff880001ffffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0003ffb0
On node 0 totalpages: 261967
  DMA zone: 2999 pages, LIFO batch:0
  DMA32 zone: 254441 pages, LIFO batch:31
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bf7c0000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257440
Kernel command line: auto BOOT_IMAGE=linux ro root=801 netconsole=6665@10.10.0.1/eth0,6666@10.10.0.18/00:1f:c6:be:1e:06
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Detected 1607.821 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
AGP bridge at 00:00:00
Aperture from AGP @ f8000000 old size 32 MB
Aperture size 4096 MB (APSIZE 0) is not right, using settings from NB
Aperture from AGP @ f8000000 size 32 MB (APSIZE 0)
Node 0: aperture @ 94f8000000 size 64 MB
Aperture beyond 4GB. Ignoring.
Memory: 1027896k/1048256k available (2312k kernel code, 19476k reserved, 606k data, 220k init)
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay loop (skipped), value calculated using timer frequency.. 3215.64 BogoMIPS (lpj=6431284)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
tseg: 0000000000
CPU: AMD Sempron(tm) Processor 2800+ stepping 02
ACPI: Core revision 20080609
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
Using local APIC timer interrupts.
APIC timer calibration result 12561098
Detected 12.561 MHz APIC timer.
net_namespace: 1136 bytes
NET: Registered protocol family 16
No dock devices found.
node 0 link 0: io port [1000, ffffff]
TOM: 0000000040000000 aka 1024M
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [40000000, fe0bffff]
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [a0000, bffff]
bus: 00 index 2 mmio: [40000000, fcffffffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: supports D1
pci 0000:00:02.0: supports D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: supports D1
pci 0000:00:02.1: supports D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:02.2: supports D1
pci 0000:00:02.2: supports D2
pci 0000:00:02.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.2: PME# disabled
pci 0000:00:05.0: supports D1
pci 0000:00:05.0: supports D2
pci 0000:00:05.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:06.0: supports D1
pci 0000:00:06.0: supports D2
pci 0000:02:06.0: supports D1
pci 0000:02:06.0: supports D2
pci 0000:02:06.0: PME# supported from D1 D2 D3hot
pci 0000:02:06.0: PME# disabled
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *9
ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LNKE] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LUS1] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LKLN] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LAUI] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LKMO] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LKSM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22) *10
ACPI: PCI Interrupt Link [LTIE] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LATA] (IRQs 22) *14
ACPI: Power Resource [ISAV] (on)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - E0, should be B8 [20080609]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
agpgart-amd64 0000:00:00.0: AGP bridge [10de/00e1]
agpgart-amd64 0000:00:00.0: setting up Nforce3 AGP
agpgart-amd64 0000:00:00.0: AGP aperture is 32M @ 0xf8000000
ACPI: RTC can wake from S4
system 00:09: ioport range 0x4d0-0x4d1 has been reserved
system 00:09: ioport range 0x4000-0x407f has been reserved
system 00:09: ioport range 0x4080-0x40ff has been reserved
system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0a: iomem range 0xfee00000-0xfeefffff has been reserved
system 00:0a: iomem range 0xff7c0000-0xffffffff could not be reserved
system 00:0c: ioport range 0x290-0x29f has been reserved
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0xc0000-0xcffff has been reserved
system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
system 00:0d: iomem range 0x100000-0x3fffffff could not be reserved
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:01
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: 0xfc900000-0xfe9fffff
pci 0000:00:0b.0:   PREFETCH window: 0x000000e4800000-0x000000f47fffff
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0e.0:   IO window: 0xc000-0xcfff
pci 0000:00:0e.0:   MEM window: 0xfea00000-0xfeafffff
pci 0000:00:0e.0:   PREFETCH window: 0x00000050000000-0x000000500fffff
pci 0000:00:0e.0: setting latency timer to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
msgmni has been set to 2008
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
Linux agpgart interface v0.103
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LKLN] enabled at IRQ 22
forcedeth 0000:00:05.0: PCI INT A -> Link[LKLN] -> GSI 22 (level, low) -> IRQ 22
forcedeth 0000:00:05.0: setting latency timer to 64
Switched to high resolution mode on CPU 0
forcedeth 0000:00:05.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:13:8f:fd:f9:26
forcedeth 0000:00:05.0: csum timirq lnktim desc-v2
netconsole: local port 6665
netconsole: local IP 10.10.0.1
netconsole: interface eth0
netconsole: remote port 6666
netconsole: remote IP 10.10.0.18
netconsole: remote ethernet address 00:1f:c6:be:1e:06
netconsole: device eth0 not up yet, forcing it
eth0: no link during initialization.
eth0: link up.
console [netcon0] enabled
netconsole: network logging started
Driver 'sd' needs updating - please use bus_type methods
sata_nv 0000:00:0a.0: version 3.5
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
sata_nv 0000:00:0a.0: PCI INT A -> Link[LTID] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:0a.0: setting latency timer to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xf80 ctl 0xf00 bmdma 0xd800 irq 21
ata2: SATA max UDMA/133 cmd 0xe80 ctl 0xe00 bmdma 0xd808 irq 21
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: SAMSUNG HD753LJ, 1AA01106, max UDMA7
ata2.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
isa bounce pool size: 16 pages
scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
sd 1:0:0:0: [sda] Attached SCSI disk
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
TCP cubic registered
NET: Registered protocol family 17
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 220k freed
processor ACPI0007:00: registered as cooling_device0
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button (CM) [PWRB]
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 20
ehci_hcd 0000:00:02.2: PCI INT C -> Link[LUS2] -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:02.2: setting latency timer to 64
ehci_hcd 0000:00:02.2: EHCI Host Controller
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.2: debug port 0
ehci_hcd 0000:00:02.2: cache line size of 64 is not supported
ehci_hcd 0000:00:02.2: irq 20, io mem 0xfebfdc00
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
sd 1:0:0:0: Attached scsi generic sg0 type 0
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUS0] -> GSI 22 (level, low) -> IRQ 22
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xfebff000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ACPI: PCI Interrupt Link [LUS1] enabled at IRQ 21
ohci_hcd 0000:00:02.1: PCI INT B -> Link[LUS1] -> GSI 21 (level, low) -> IRQ 21
ohci_hcd 0000:00:02.1: setting latency timer to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.1: irq 21, io mem 0xfebfe000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
pata_amd 0000:00:08.0: version 0.3.10
pata_amd 0000:00:08.0: power state changed by ACPI to D0
pata_amd 0000:00:08.0: setting latency timer to 64
scsi2 : pata_amd
scsi3 : pata_amd
ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata4.00: ATAPI: HL-DT-ST CD-ROM GCR-8520B, 1.00, max MWDMA2
ata4: nv_mode_filter: 0x39f&0x39f->0x39f, BIOS=0x0 (0x0) ACPI=0x39f (120:600:0x12)
ata4.00: configured for MWDMA2
scsi 3:0:0:0: CD-ROM            HL-DT-ST CD-ROM GCR-8520B 1.00 PQ: 0 ANSI: 5
scsi 3:0:0:0: Attached scsi generic sg1 type 5
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 19
8139too 0000:02:06.0: PCI INT A -> Link[LNKC] -> GSI 19 (level, low) -> IRQ 19
eth1: RealTek RTL8139 at 0xffffc20000064c00, 00:a1:b0:f0:2b:d1, IRQ 19
eth1:  Identified 8139 chip type 'RTL-8100B/8139D'
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 52x/52x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k
parport_pc 00:06: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
lp0: using parport0 (interrupt-driven).
XFS mounting filesystem sda3
Ending clean XFS mount for filesystem: sda3
XFS mounting filesystem sda5
Ending clean XFS mount for filesystem: sda5
XFS mounting filesystem sda9
ata1: EH pending after 5 tries, giving up
ata1: EH complete
Ending clean XFS mount for filesystem: sda9
XFS mounting filesystem sda7
Ending clean XFS mount for filesystem: sda7
kjournald2 starting.  Commit interval 5 seconds
EXT4 FS on sda6, internal journal
EXT4-fs: mounted filesystem with journal data mode.
EXT4-fs: Ignoring delalloc option - requested data journaling mode
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
XFS mounting filesystem sda8
Ending clean XFS mount for filesystem: sda8
Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
ata1: EH pending after 5 tries, giving up
ata1: EH complete
PPP generic driver version 2.4.2
NET: Registered protocol family 24
eth1: link up, 100Mbps, full-duplex, lpa 0x41E1
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ata1: EH pending after 5 tries, giving up
ata1: EH complete
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
ata1: EH pending after 5 tries, giving up
ata1: EH complete
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: EH complete
ata1: EH pending after 5 tries, giving up
ata1: EH complete

--VbJkn9YxBvnuCH5J--
