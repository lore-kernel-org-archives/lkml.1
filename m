Return-Path: <linux-kernel-owner+w=401wt.eu-S941351AbXGaEos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941351AbXGaEos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbXGaEoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:44:39 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:3275 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbXGaEog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:44:36 -0400
Message-ID: <46AEBDDD.2020107@sw.ru>
Date: Tue, 31 Jul 2007 11:43:09 +0700
From: Vasily Averin <vvs@sw.ru>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org,
       Thomas Gleixner <tglx@linutronix.de>,
       George Anzinger <george@mvista.com>
Subject: Re: [2.6.22] negative time jump
References: <46AD57BF.8090106@sw.ru>	 <1f1b08da0707301113r173adba0yd2585263e89fd8@mail.gmail.com> <1f1b08da0707301807h62a24b3o786beed607ae5fcd@mail.gmail.com>
In-Reply-To: <1f1b08da0707301807h62a24b3o786beed607ae5fcd@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040102090302030606010604"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040102090302030606010604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

john stultz wrote:
> On 7/29/07, Vasily Averin <vvs@sw.ru> wrote:
>> I've investigated why my testnode freezes. When I found that node is freezed
>> again I've started to press Sysrq keys and noticed the following negative time jump.
>>
>> Could anybody please help me to understand the reasons of this issue?
>>
>> --- VvS comment: some pre-history: node boot
>> Jul 27 13:58:10 ts28 Linux version 2.6.22 (vvs@vvs.work.ve) (gcc version 3.4.6
>> 20060404 (Red Hat 3.4.6-3)) #11 SMP Fri Jul 27 12:47:45 MSD 2007
>> Jul 27 13:58:10 ts28 Command line: ro root=LABEL=/1 console=ttyS0,115200
>> console=tty debug silencelevel=8 crashkernel=128M@128M acpc=noirq clocksource=tsc
> 
> clocksource=tsc?
> 
> I suspect you're forcing the clocksource as its not selected by
> default. Could you provide dmesg output without that option. It might
> shed some light as to why the clocksource isn't chosen.

Default clocksource was acpi-pm. But the node have similar behavior when I've
used this clocksource. (please look at the following logs)

Originally I've investigated SATA-related issue and noticed some strange with
timers. When I've reproduced situation again I've pressed Alt+Sysrq+Q keys and
noticed that it shows incorrect time (it shows 431968 sec from booting but
according to the serial console timestamps it should be ~445954 sec). Then you
can see that time was jumped back, next timestamp is 431965 sec, 3 sec back.

> It may very well be your TSCs are not synched or are otherwise not
> reliable for timekeeping , and thus time is not consistent between
> cpus.

However IMHO it cannot explain time loops (~4400 sec) that I'm observing right now.

thank you,
	Vasily Averin

PS. You can look at the other logs and find more details in my attachments to
http://bugzilla.kernel.org/show_bug.cgi?id=8650


--------------040102090302030606010604
Content-Type: text/x-log;
 name="ttt1.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ttt1.log"

Jul 12 09:00:16 ts28 Linux version 2.6.22 (vvs@vvs.work.ve) (gcc version 3.4.6 20060404 (Red Hat 3.4.6-3)) #4 SMP Thu Jul 12 07:58:27 MSD 2007
Jul 12 09:00:16 ts28 Command line: ro root=LABEL=/1 console=ttyS0,115200 console=tty debug silencelevel=8 crashkernel=128M@128M acpi=noirq
Jul 12 09:00:16 ts28 BIOS-provided physical RAM map:
Jul 12 09:00:16 ts28  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
Jul 12 09:00:16 ts28  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
Jul 12 09:00:16 ts28  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Jul 12 09:00:16 ts28  BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
Jul 12 09:00:16 ts28  BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
Jul 12 09:00:16 ts28  BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
Jul 12 09:00:16 ts28  BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
Jul 12 09:00:16 ts28  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Jul 12 09:00:16 ts28 Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Jul 12 09:00:16 ts28 Entering add_active_range(0, 256, 917216) 1 entries of 3200 used
Jul 12 09:00:16 ts28 end_pfn_map = 1048576
Jul 12 09:00:16 ts28 DMI 2.3 present.
Jul 12 09:00:16 ts28 ACPI: RSDP 000F6980, 0014 (r0 VIAK8 )
Jul 12 09:00:16 ts28 ACPI: RSDT DFEE3000, 002C (r1 VIAK8  AWRDACPI 42302E31 AWRD        0)
Jul 12 09:00:16 ts28 ACPI: FACP DFEE3040, 0074 (r1 VIAK8  AWRDACPI 42302E31 AWRD        0)
Jul 12 09:00:16 ts28 ACPI: DSDT DFEE30C0, 4A4C (r1 VIAK8  AWRDACPI     1000 MSFT  100000E)
Jul 12 09:00:16 ts28 ACPI: FACS DFEE0000, 0040
Jul 12 09:00:16 ts28 ACPI: APIC DFEE7B40, 0068 (r1 VIAK8  AWRDACPI 42302E31 AWRD        0)
Jul 12 09:00:16 ts28 Scanning NUMA topology in Northbridge 24
Jul 12 09:00:16 ts28 Number of nodes 2
Jul 12 09:00:16 ts28 Node 0 MemBase 0000000000000000 Limit 00000000dfee0000
Jul 12 09:00:16 ts28 Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Jul 12 09:00:16 ts28 Entering add_active_range(0, 256, 917216) 1 entries of 3200 used
Jul 12 09:00:16 ts28 Skipping disabled node 1
Jul 12 09:00:16 ts28 NUMA: Using 63 for the hash shift.
Jul 12 09:00:16 ts28 Using node hash shift of 63
Jul 12 09:00:16 ts28 Bootmem setup node 0 0000000000000000-00000000dfee0000
Jul 12 09:00:16 ts28 Zone PFN ranges:
Jul 12 09:00:16 ts28   DMA             0 ->     4096
Jul 12 09:00:16 ts28   DMA32        4096 ->  1048576
Jul 12 09:00:16 ts28   Normal    1048576 ->  1048576
Jul 12 09:00:16 ts28 early_node_map[2] active PFN ranges
Jul 12 09:00:16 ts28     0:        0 ->      157
Jul 12 09:00:16 ts28     0:      256 ->   917216
Jul 12 09:00:16 ts28 On node 0 totalpages: 917117
Jul 12 09:00:16 ts28   DMA zone: 56 pages used for memmap
Jul 12 09:00:16 ts28 
Jul 12 09:00:16 ts28   DMA zone: 2018 pages reserved
Jul 12 09:00:16 ts28   DMA zone: 1923 pages, LIFO batch:0
Jul 12 09:00:16 ts28   DMA32 zone: 12484 pages used for memmap
Jul 12 09:00:16 ts28   DMA32 zone: 900636 pages, LIFO batch:31
Jul 12 09:00:16 ts28   Normal zone: 0 pages used for memmap
Jul 12 09:00:16 ts28 ACPI: PM-Timer IO Port: 0x4008
Jul 12 09:00:16 ts28 ACPI: Local APIC address 0xfee00000
Jul 12 09:00:16 ts28 ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Jul 12 09:00:16 ts28 Processor #0 (Bootup-CPU)
Jul 12 09:00:16 ts28 ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Jul 12 09:00:16 ts28 Processor #1
Jul 12 09:00:16 ts28 ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Jul 12 09:00:16 ts28 ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Jul 12 09:00:16 ts28 Using ACPI for processor (LAPIC) configuration information
Jul 12 09:00:16 ts28 Intel MultiProcessor Specification v1.4
Jul 12 09:00:16 ts28 MPTABLE: OEM ID: OEM00000 MPTABLE: Product ID: PROD00000000 MPTABLE: APIC at: 0xFEE00000
Jul 12 09:00:16 ts28 I/O APIC #2 at 0xFEC00000.
Jul 12 09:00:16 ts28 Setting APIC routing to flat
Jul 12 09:00:16 ts28 Processors: 2
Jul 12 09:00:16 ts28 Allocating PCI resources starting at e0000000 (gap: dff00000:1ed00000)
Jul 12 09:00:16 ts28 PERCPU: Allocating 68072 bytes of per cpu data
Jul 12 09:00:16 ts28 Built 1 zonelists.  Total pages: 902559
Jul 12 09:00:16 ts28 Kernel command line: ro root=LABEL=/1 console=ttyS0,115200 console=tty debug silencelevel=8 crashkernel=128M@128M acpi=noirq
Jul 12 09:00:16 ts28 Initializing CPU#0
Jul 12 09:00:16 ts28 PID hash table entries: 4096 (order: 12, 32768 bytes)
Jul 12 09:00:16 ts28 Marking TSC unstable due to TSCs unsynchronized
Jul 12 09:00:16 ts28 
Jul 12 09:00:16 ts28 time.c: Detected 2004.613 MHz processor.
Jul 12 09:00:16 ts28 Console: colour VGA+ 80x25
Jul 12 09:00:16 ts28 Checking aperture...
Jul 12 09:00:16 ts28 CPU 0: aperture @ e8000000 size 128 MB
Jul 12 09:00:16 ts28 CPU 1: aperture @ e8000000 size 128 MB
Jul 12 09:00:17 ts28 Memory: 3477240k/3668864k available (2449k kernel code, 191228k reserved, 1418k data, 296k init)
Jul 12 09:00:17 ts28 Calibrating delay using timer specific routine.. 4011.87 BogoMIPS (lpj=2005936)
Jul 12 09:00:17 ts28 Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Jul 12 09:00:17 ts28 Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Jul 12 09:00:17 ts28 Mount-cache hash table entries: 256
Jul 12 09:00:17 ts28 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Jul 12 09:00:17 ts28 CPU: L2 Cache: 1024K (64 bytes/line)
Jul 12 09:00:17 ts28 CPU 0/0 -> Node 0
Jul 12 09:00:17 ts28 Freeing SMP alternatives: 27k freed
Jul 12 09:00:17 ts28 ACPI: Core revision 20070126
Jul 12 09:00:17 ts28 Using local APIC timer interrupts.
Jul 12 09:00:17 ts28 result 12528848
Jul 12 09:00:17 ts28 Detected 12.528 MHz APIC timer.
Jul 12 09:00:17 ts28 Booting processor 1/2 APIC 0x1
Jul 12 09:00:17 ts28 Initializing CPU#1
Jul 12 09:00:17 ts28 Calibrating delay using timer specific routine.. 4008.43 BogoMIPS (lpj=2004219)
Jul 12 09:00:17 ts28 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Jul 12 09:00:17 ts28 CPU: L2 Cache: 1024K (64 bytes/line)
Jul 12 09:00:17 ts28 CPU 1/1 -> Node 0
Jul 12 09:00:17 ts28 
Jul 12 09:00:17 ts28 AMD Opteron(tm) Processor 246 stepping 0a
Jul 12 09:00:17 ts28 Brought up 2 CPUs
Jul 12 09:00:17 ts28 migration_cost=416
Jul 12 09:00:17 ts28 NET: Registered protocol family 16
Jul 12 09:00:17 ts28 No dock devices found.
Jul 12 09:00:17 ts28 ACPI: bus type pci registered
Jul 12 09:00:17 ts28 PCI: Using configuration type 1
Jul 12 09:00:17 ts28 ACPI: Interpreter enabled
Jul 12 09:00:17 ts28 ACPI: Using PIC for interrupt routing
Jul 12 09:00:17 ts28 ACPI: PCI Root Bridge [PCI0] (0000:00)
Jul 12 09:00:17 ts28 PCI: Probing PCI hardware (bus 00)
Jul 12 09:00:17 ts28 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Jul 12 09:00:17 ts28 Linux Plug and Play Support v0.97 (c) Adam Belay
Jul 12 09:00:17 ts28 pnp: PnP ACPI init
Jul 12 09:00:17 ts28 ACPI: bus type pnp registered
Jul 12 09:00:17 ts28 pnp: PnP ACPI: found 14 devices
Jul 12 09:00:17 ts28 ACPI: ACPI bus type pnp unregistered
Jul 12 09:00:17 ts28 SCSI subsystem initialized
Jul 12 09:00:17 ts28 libata version 2.21 loaded.
Jul 12 09:00:17 ts28 usbcore: registered new interface driver usbfs
Jul 12 09:00:17 ts28 usbcore: registered new interface driver hub
Jul 12 09:00:17 ts28 usbcore: registered new device driver usb
Jul 12 09:00:17 ts28 PCI: Probing PCI hardware
Jul 12 09:00:17 ts28 pci 0000:00:01.0: Error creating sysfs bridge symlink, continuing...
Jul 12 09:00:17 ts28 PCI: Using IRQ router VIA [1106/3227] at 0000:00:11.0
Jul 12 09:00:17 ts28 PCI->APIC IRQ transform: 0000:00:0b.0[A] -> IRQ 16
Jul 12 09:00:17 ts28 PCI->APIC IRQ transform: 0000:00:0f.0[B] -> IRQ 20
Jul 12 09:00:17 ts28 PCI->APIC IRQ transform: 0000:00:0f.1[A] -> IRQ 20
Jul 12 09:00:17 ts28 PCI->APIC IRQ transform: 0000:00:10.0[A] -> IRQ 21
Jul 12 09:00:17 ts28 PCI->APIC IRQ transform: 0000:00:10.1[A] -> IRQ 21
Jul 12 09:00:17 ts28 PCI->APIC IRQ transform: 0000:00:10.2[B] -> IRQ 21
Jul 12 09:00:17 ts28 PCI->APIC IRQ transform: 0000:00:10.4[C] -> IRQ 21
Jul 12 09:00:17 ts28 PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 16
Jul 12 09:00:17 ts28 PCI: Cannot allocate resource region 0 of device 0000:00:00.0
Jul 12 09:00:17 ts28 agpgart: Detected AGP bridge 0
Jul 12 09:00:17 ts28 agpgart: AGP aperture is 128M @ 0xe8000000
Jul 12 09:00:17 ts28 pnp: 00:00: iomem range 0xd6000-0xd7fff has been reserved
Jul 12 09:00:17 ts28 pnp: 00:00: iomem range 0xf0000-0xf7fff could not be reserved
Jul 12 09:00:17 ts28 pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
Jul 12 09:00:17 ts28 pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
Jul 12 09:00:17 ts28 pnp: 00:02: ioport range 0x4000-0x407f has been reserved
Jul 12 09:00:17 ts28 pnp: 00:02: ioport range 0x5000-0x500f has been reserved
Jul 12 09:00:17 ts28 PCI: Bridge: 0000:00:01.0
Jul 12 09:00:17 ts28   IO window: disabled.
Jul 12 09:00:17 ts28   MEM window: f8000000-f9ffffff
Jul 12 09:00:17 ts28   PREFETCH window: f0000000-f7ffffff
Jul 12 09:00:17 ts28 PCI: Setting latency timer of device 0000:00:01.0 to 64
Jul 12 09:00:17 ts28 Time: acpi_pm clocksource has been installed.
Jul 12 09:00:17 ts28 NET: Registered protocol family 2
Jul 12 09:00:17 ts28 IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
Jul 12 09:00:17 ts28 
Jul 12 09:00:17 ts28 TCP established hash table entries: 524288 (order: 11, 12582912 bytes)
Jul 12 09:00:17 ts28 TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Jul 12 09:00:17 ts28 TCP: Hash tables configured (established 524288 bind 65536)
Jul 12 09:00:17 ts28 TCP reno registered
Jul 12 09:00:17 ts28 
Jul 12 09:00:17 ts28 checking if image is initramfs... it is
Jul 12 09:00:17 ts28 Freeing initrd memory: 1447k freed
Jul 12 09:00:17 ts28 audit: initializing netlink socket (disabled)
Jul 12 09:00:17 ts28 audit(1184216452.315:1): initialized
Jul 12 09:00:17 ts28 Total HugeTLB memory allocated, 0
Jul 12 09:00:17 ts28 VFS: Disk quotas dquot_6.5.1
Jul 12 09:00:17 ts28 Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Jul 12 09:00:17 ts28 io scheduler noop registered
Jul 12 09:00:17 ts28 io scheduler anticipatory registered
Jul 12 09:00:17 ts28 io scheduler deadline registered
Jul 12 09:00:17 ts28 io scheduler cfq registered (default)
Jul 12 09:00:17 ts28 PCI: VIA PCI bridge detected. Disabling DAC.
Jul 12 09:00:17 ts28 Boot video device is 0000:01:00.0
Jul 12 09:00:17 ts28 pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Jul 12 09:00:17 ts28 ACPI: Fan [FAN] (on)
Jul 12 09:00:17 ts28 ACPI: Thermal Zone [THRM] (40 C)
Jul 12 09:00:17 ts28 Real Time Clock Driver v1.12ac
Jul 12 09:00:17 ts28 Non-volatile memory driver v1.2
Jul 12 09:00:17 ts28 Linux agpgart interface v0.102 (c) Dave Jones
Jul 12 09:00:17 ts28 Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Jul 12 09:00:17 ts28 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jul 12 09:00:17 ts28 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Jul 12 09:00:17 ts28 RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
Jul 12 09:00:17 ts28 Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Jul 12 09:00:17 ts28 ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Jul 12 09:00:17 ts28 ide-floppy driver 0.99.newide
Jul 12 09:00:17 ts28 sata_via 0000:00:0f.0: version 2.2
Jul 12 09:00:17 ts28 sata_via 0000:00:0f.0: routed to hard irq line 11
Jul 12 09:00:17 ts28 scsi0 : sata_via
Jul 12 09:00:17 ts28 scsi1 : sata_via
Jul 12 09:00:17 ts28 ata1: SATA max UDMA/133 cmd 0x000000000001c000 ctl 0x000000000001c402 bmdma 0x000000000001d000 irq 20
Jul 12 09:00:17 ts28 ata2: SATA max UDMA/133 cmd 0x000000000001c800 ctl 0x000000000001cc02 bmdma 0x000000000001d008 irq 20
Jul 12 09:00:17 ts28 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Jul 12 09:00:17 ts28 ata1.00: ATA-7: ST380811AS, 3.AAE, max UDMA/133
Jul 12 09:00:17 ts28 ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)
Jul 12 09:00:17 ts28 ata1.00: configured for UDMA/133
Jul 12 09:00:18 ts28 ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
Jul 12 09:00:18 ts28 scsi 0:0:0:0: Direct-Access     ATA      ST380811AS       3.AA PQ: 0 ANSI: 5
Jul 12 09:00:18 ts28 sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
Jul 12 09:00:18 ts28 sd 0:0:0:0: [sda] Write Protect is off
Jul 12 09:00:18 ts28 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jul 12 09:00:18 ts28 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 12 09:00:18 ts28 sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
Jul 12 09:00:18 ts28 sd 0:0:0:0: [sda] Write Protect is off
Jul 12 09:00:18 ts28 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jul 12 09:00:18 ts28 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 12 09:00:18 ts28  sda: sda1 sda2 sda3 sda4 < sda5 >
Jul 12 09:00:18 ts28 sd 0:0:0:0: [sda] Attached SCSI disk
Jul 12 09:00:18 ts28 pata_via 0000:00:0f.1: version 0.3.1
Jul 12 09:00:18 ts28 scsi2 : pata_via
Jul 12 09:00:18 ts28 scsi3 : pata_via
Jul 12 09:00:18 ts28 ata3: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001d800 irq 14
Jul 12 09:00:18 ts28 ata4: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001d808 irq 15
Jul 12 09:00:18 ts28 ata3.00: ATAPI: TEAC DV-516G, F4S6, max UDMA/33
Jul 12 09:00:18 ts28 ata3.00: configured for UDMA/33
Jul 12 09:00:18 ts28 scsi 2:0:0:0: CD-ROM            TEAC     DV-516G          F4S6 PQ: 0 ANSI: 5
Jul 12 09:00:18 ts28 PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Jul 12 09:00:18 ts28 serio: i8042 KBD port at 0x60,0x64 irq 1
Jul 12 09:00:18 ts28 serio: i8042 AUX port at 0x60,0x64 irq 12
Jul 12 09:00:18 ts28 mice: PS/2 mouse device common for all mice
Jul 12 09:00:18 ts28 input: AT Translated Set 2 keyboard as /class/input/input0
Jul 12 09:00:18 ts28 usbcore: registered new interface driver hiddev
Jul 12 09:00:18 ts28 usbcore: registered new interface driver usbhid
Jul 12 09:00:18 ts28 drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Jul 12 09:00:18 ts28 TCP bic registered
Jul 12 09:00:18 ts28 Initializing XFRM netlink socket
Jul 12 09:00:18 ts28 
Jul 12 09:00:18 ts28 NET: Registered protocol family 1
Jul 12 09:00:18 ts28 NET: Registered protocol family 17
Jul 12 09:00:18 ts28 powernow-k8: Found 2 AMD Opteron(tm) Processor 246 processors (version 2.00.00)
Jul 12 09:00:18 ts28 powernow-k8: MP systems not supported by PSB BIOS structure
Jul 12 09:00:18 ts28 powernow-k8: MP systems not supported by PSB BIOS structure
Jul 12 09:00:19 ts28 Freeing unused kernel memory: 296k freed
Jul 12 09:00:19 ts28 Write protecting the kernel read-only data: 840k
Jul 12 09:00:19 ts28 input: ImPS/2 Generic Wheel Mouse as /class/input/input1
Jul 12 09:00:19 ts28 USB Universal Host Controller Interface driver v3.0
Jul 12 09:00:19 ts28 uhci_hcd 0000:00:10.0: UHCI Host Controller
Jul 12 09:00:19 ts28 uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
Jul 12 09:00:19 ts28 uhci_hcd 0000:00:10.0: irq 21, io base 0x0000dc00
Jul 12 09:00:19 ts28 usb usb1: configuration #1 chosen from 1 choice
Jul 12 09:00:19 ts28 hub 1-0:1.0: USB hub found
Jul 12 09:00:19 ts28 hub 1-0:1.0: 2 ports detected
Jul 12 09:00:19 ts28 uhci_hcd 0000:00:10.1: UHCI Host Controller
Jul 12 09:00:19 ts28 uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
Jul 12 09:00:19 ts28 uhci_hcd 0000:00:10.1: irq 21, io base 0x0000e000
Jul 12 09:00:19 ts28 usb usb2: configuration #1 chosen from 1 choice
Jul 12 09:00:19 ts28 hub 2-0:1.0: USB hub found
Jul 12 09:00:19 ts28 hub 2-0:1.0: 2 ports detected
Jul 12 09:00:19 ts28 uhci_hcd 0000:00:10.2: UHCI Host Controller
Jul 12 09:00:19 ts28 uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
Jul 12 09:00:19 ts28 uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e400
Jul 12 09:00:19 ts28 usb usb3: configuration #1 chosen from 1 choice
Jul 12 09:00:19 ts28 hub 3-0:1.0: USB hub found
Jul 12 09:00:19 ts28 hub 3-0:1.0: 2 ports detected
Jul 12 09:00:19 ts28 ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
Jul 12 09:00:19 ts28 ehci_hcd 0000:00:10.4: EHCI Host Controller
Jul 12 09:00:19 ts28 ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 4
Jul 12 09:00:19 ts28 ehci_hcd 0000:00:10.4: irq 21, io mem 0xfa010000
Jul 12 09:00:19 ts28 ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Jul 12 09:00:19 ts28 usb usb4: configuration #1 chosen from 1 choice
Jul 12 09:00:19 ts28 hub 4-0:1.0: USB hub found
Jul 12 09:00:19 ts28 
Jul 12 09:00:19 ts28 hub 4-0:1.0: 6 ports detected
Jul 12 09:00:19 ts28 device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Jul 12 09:00:20 ts28 kjournald starting.  Commit interval 5 seconds
Jul 12 09:00:20 ts28 EXT3-fs: mounted filesystem with ordered data mode.
Jul 12 09:00:34 ts28 Bluetooth: Core ver 2.11
Jul 12 09:00:34 ts28 NET: Registered protocol family 31
Jul 12 09:00:34 ts28 Bluetooth: HCI device and connection manager initialized
Jul 12 09:00:34 ts28 Bluetooth: HCI socket layer initialized
Jul 12 09:00:34 ts28 Bluetooth: L2CAP ver 2.8
Jul 12 09:00:34 ts28 Bluetooth: L2CAP socket layer initialized
Jul 12 09:00:34 ts28 Bluetooth: RFCOMM socket layer initialized
Jul 12 09:00:34 ts28 Bluetooth: RFCOMM TTY layer initialized
Jul 12 09:00:34 ts28 Bluetooth: RFCOMM ver 1.8
Jul 12 09:00:34 ts28 Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Jul 12 09:00:42 ts28 eth0: no IPv6 routers present
[skip]
Jul 17 12:52:50 ts28 SysRq : Show Pending Timers
Jul 17 12:52:50 ts28 Timer List Version: v0.3
Jul 17 12:52:50 ts28 HRTIMER_MAX_CLOCK_BASES: 2
Jul 17 12:52:50 ts28 now at 431968335320668 nsecs
Jul 17 12:52:50 ts28 cpu: 0
Jul 17 12:52:50 ts28  clock 0:
Jul 17 12:52:50 ts28   .index:      0
Jul 17 12:52:50 ts28   .resolution: 999848 nsecs
Jul 17 12:52:50 ts28   .get_time:   ktime_get_real
Jul 17 12:52:50 ts28 active timers:
Jul 17 12:52:50 ts28  clock 1:
Jul 17 12:52:50 ts28   .index:      1
Jul 17 12:52:50 ts28 
Jul 17 12:52:50 ts28   .resolution: 999848 nsecs
Jul 17 12:52:50 ts28   .get_time:   ktime_get
Jul 17 12:52:50 ts28 active timers:
Jul 17 12:52:50 ts28  #0: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:50 ts28  # expires at 431965534432079 nsecs [in 18446744070908663027 nsecs]
Jul 17 12:52:50 ts28  #1: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:50 ts28  # expires at 431966556318253 nsecs [in 18446744071930549201 nsecs]
Jul 17 12:52:50 ts28  #2: <ffff810037d9fcf8>, it_real_fn, S:01
Jul 17 12:52:50 ts28  # expires at 431967660535212 nsecs [in 18446744073034766160 nsecs]
Jul 17 12:52:50 ts28  #3: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:50 ts28  # expires at 432001537398034 nsecs [in 33202077366 nsecs]
Jul 17 12:52:50 ts28  #4: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:50 ts28  # expires at 432010476658804 nsecs [in 42141338136 nsecs]
Jul 17 12:52:50 ts28  #5: <ffff810037d9fcf8>, it_real_fn, S:01
Jul 17 12:52:50 ts28  # expires at 434227124335280 nsecs [in 2258789014612 nsecs]
Jul 17 12:52:50 ts28  #6: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:50 ts28  # expires at 439279177437767 nsecs [in 7310842117099 nsecs]
Jul 17 12:52:50 ts28 cpu: 1
Jul 17 12:52:50 ts28  clock 0:
Jul 17 12:52:50 ts28   .index:      0
Jul 17 12:52:50 ts28   .resolution: 999848 nsecs
Jul 17 12:52:50 ts28   .get_time:   ktime_get_real
Jul 17 12:52:50 ts28 active timers:
Jul 17 12:52:50 ts28  clock 1:
Jul 17 12:52:50 ts28   .index:      1
Jul 17 12:52:50 ts28   .resolution: 999848 nsecs
Jul 17 12:52:50 ts28   .get_time:   ktime_get
Jul 17 12:52:50 ts28 active timers:
Jul 17 12:52:50 ts28  #0: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:50 ts28  # expires at 431965537398313 nsecs [in 18446744070911629261 nsecs]
Jul 17 12:52:50 ts28  #1: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:50 ts28  # expires at 431975116222933 nsecs [in 6780902265 nsecs]
Jul 17 12:52:50 ts28 
Jul 17 12:52:50 ts28  #2: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:50 ts28  # expires at 432024123554962 nsecs [in 55788234294 nsecs]
Jul 17 12:52:50 ts28  #3: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:50 ts28  # expires at 432024628026277 nsecs [in 56292705609 nsecs]
Jul 17 12:52:50 ts28  #4: <ffff810037d9fcf8>, it_real_fn, S:01
Jul 17 12:52:50 ts28  # expires at 434227065407399 nsecs [in 2258730086731 nsecs]
Jul 17 12:52:52 ts28 SysRq : Show Pending Timers
Jul 17 12:52:52 ts28 Timer List Version: v0.3
Jul 17 12:52:52 ts28 HRTIMER_MAX_CLOCK_BASES: 2
Jul 17 12:52:52 ts28 now at 431965353105789 nsecs
Jul 17 12:52:52 ts28 cpu: 0
Jul 17 12:52:52 ts28  clock 0:
Jul 17 12:52:52 ts28   .index:      0
Jul 17 12:52:52 ts28   .resolution: 999848 nsecs
Jul 17 12:52:52 ts28   .get_time:   ktime_get_real
Jul 17 12:52:52 ts28 active timers:
Jul 17 12:52:52 ts28  clock 1:
Jul 17 12:52:52 ts28   .index:      1
Jul 17 12:52:52 ts28 
Jul 17 12:52:52 ts28   .resolution: 999848 nsecs
Jul 17 12:52:52 ts28   .get_time:   ktime_get
Jul 17 12:52:52 ts28 active timers:
Jul 17 12:52:52 ts28  #0: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:52 ts28  # expires at 431965534432079 nsecs [in 181326290 nsecs]
Jul 17 12:52:52 ts28  #1: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:52 ts28  # expires at 431966556318253 nsecs [in 1203212464 nsecs]
Jul 17 12:52:52 ts28  #2: <ffff810037d9fcf8>, it_real_fn, S:01
Jul 17 12:52:52 ts28  # expires at 431967660535212 nsecs [in 2307429423 nsecs]
Jul 17 12:52:52 ts28 
Jul 17 12:52:52 ts28  #3: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:52 ts28  # expires at 432001537398034 nsecs [in 36184292245 nsecs]
Jul 17 12:52:52 ts28  #4: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:52 ts28  # expires at 432010476658804 nsecs [in 45123553015 nsecs]
Jul 17 12:52:52 ts28  #5: <ffff810037d9fcf8>, it_real_fn, S:01
Jul 17 12:52:52 ts28  # expires at 434227124335280 nsecs [in 2261771229491 nsecs]
Jul 17 12:52:52 ts28  #6: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:52 ts28  # expires at 439279177437767 nsecs [in 7313824331978 nsecs]
Jul 17 12:52:52 ts28 cpu: 1
Jul 17 12:52:52 ts28  clock 0:
Jul 17 12:52:52 ts28   .index:      0
Jul 17 12:52:52 ts28   .resolution: 999848 nsecs
Jul 17 12:52:52 ts28   .get_time:   ktime_get_real
Jul 17 12:52:52 ts28 active timers:
Jul 17 12:52:52 ts28  clock 1:
Jul 17 12:52:52 ts28   .index:      1
Jul 17 12:52:52 ts28   .resolution: 999848 nsecs
Jul 17 12:52:52 ts28   .get_time:   ktime_get
Jul 17 12:52:52 ts28 active timers:
Jul 17 12:52:52 ts28  #0: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:52 ts28  # expires at 431965537398313 nsecs [in 184292524 nsecs]
Jul 17 12:52:52 ts28  #1: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:52 ts28  # expires at 431975116222933 nsecs [in 9763117144 nsecs]
Jul 17 12:52:52 ts28  #2: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:52 ts28  # expires at 432024123554962 nsecs [in 58770449173 nsecs]
Jul 17 12:52:52 ts28  #3: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:52 ts28  # expires at 432024628026277 nsecs [in 59274920488 nsecs]
Jul 17 12:52:52 ts28  #4: <ffff810037d9fcf8>, it_real_fn, S:01
Jul 17 12:52:52 ts28  # expires at 434227065407399 nsecs [in 2261712301610 nsecs]
Jul 17 12:52:53 ts28 SysRq : Show Pending Timers
Jul 17 12:52:53 ts28 Timer List Version: v0.3
Jul 17 12:52:53 ts28 HRTIMER_MAX_CLOCK_BASES: 2
Jul 17 12:52:53 ts28 now at 431966486043009 nsecs
Jul 17 12:52:53 ts28 cpu: 0
Jul 17 12:52:53 ts28  clock 0:
Jul 17 12:52:53 ts28   .index:      0
Jul 17 12:52:53 ts28   .resolution: 999848 nsecs
Jul 17 12:52:53 ts28   .get_time:   ktime_get_real
Jul 17 12:52:53 ts28 active timers:
Jul 17 12:52:53 ts28  clock 1:
Jul 17 12:52:53 ts28   .index:      1
Jul 17 12:52:53 ts28   .resolution: 999848 nsecs
Jul 17 12:52:53 ts28   .get_time:   ktime_get
Jul 17 12:52:53 ts28 active timers:
Jul 17 12:52:53 ts28  #0: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:53 ts28  # expires at 431965534432079 nsecs [in 18446744072757940686 nsecs]
Jul 17 12:52:53 ts28  #1: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:53 ts28  # expires at 431966556318253 nsecs [in 70275244 nsecs]
Jul 17 12:52:53 ts28  #2: <ffff810037d9fcf8>, it_real_fn, S:01
Jul 17 12:52:53 ts28  # expires at 431967660535212 nsecs [in 1174492203 nsecs]
Jul 17 12:52:53 ts28  #3: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:53 ts28  # expires at 432001537398034 nsecs [in 35051355025 nsecs]
Jul 17 12:52:53 ts28  #4: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:53 ts28  # expires at 432010476658804 nsecs [in 43990615795 nsecs]
Jul 17 12:52:53 ts28  #5: <ffff810037d9fcf8>, it_real_fn, S:01
Jul 17 12:52:53 ts28  # expires at 434227124335280 nsecs [in 2260638292271 nsecs]
Jul 17 12:52:53 ts28  #6: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:53 ts28  # expires at 439279177437767 nsecs [in 7312691394758 nsecs]
Jul 17 12:52:53 ts28 cpu: 1
Jul 17 12:52:53 ts28  clock 0:
Jul 17 12:52:53 ts28   .index:      0
Jul 17 12:52:53 ts28   .resolution: 999848 nsecs
Jul 17 12:52:53 ts28   .get_time:   ktime_get_real
Jul 17 12:52:53 ts28 active timers:
Jul 17 12:52:53 ts28  clock 1:
Jul 17 12:52:53 ts28   .index:      1
Jul 17 12:52:53 ts28   .resolution: 999848 nsecs
Jul 17 12:52:53 ts28   .get_time:   ktime_get
Jul 17 12:52:53 ts28 active timers:
Jul 17 12:52:53 ts28  #0: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:53 ts28  # expires at 431965537398313 nsecs [in 18446744072760906920 nsecs]
Jul 17 12:52:53 ts28  #1: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:53 ts28  # expires at 431975116222933 nsecs [in 8630179924 nsecs]
Jul 17 12:52:53 ts28  #2: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:53 ts28  # expires at 432024123554962 nsecs [in 57637511953 nsecs]
Jul 17 12:52:53 ts28  #3: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:53 ts28  # expires at 432024628026277 nsecs [in 58141983268 nsecs]
Jul 17 12:52:53 ts28  #4: <ffff810037d9fcf8>, it_real_fn, S:01
Jul 17 12:52:53 ts28  # expires at 434227065407399 nsecs [in 2260579364390 nsecs]
Jul 17 12:52:54 ts28 SysRq : Show Pending Timers
Jul 17 12:52:54 ts28 Timer List Version: v0.3
Jul 17 12:52:54 ts28 HRTIMER_MAX_CLOCK_BASES: 2
Jul 17 12:52:54 ts28 now at 431967575468152 nsecs
Jul 17 12:52:54 ts28 cpu: 0
Jul 17 12:52:54 ts28  clock 0:
Jul 17 12:52:54 ts28   .index:      0
Jul 17 12:52:54 ts28 
Jul 17 12:52:54 ts28   .resolution: 999848 nsecs
Jul 17 12:52:54 ts28   .get_time:   ktime_get_real
Jul 17 12:52:54 ts28 active timers:
Jul 17 12:52:54 ts28  clock 1:
Jul 17 12:52:54 ts28   .index:      1
Jul 17 12:52:54 ts28   .resolution: 999848 nsecs
Jul 17 12:52:54 ts28   .get_time:   ktime_get
Jul 17 12:52:54 ts28 active timers:
Jul 17 12:52:54 ts28  #0: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:54 ts28  # expires at 431965534432079 nsecs [in 18446744071668515543 nsecs]
Jul 17 12:52:54 ts28  #1: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:54 ts28  # expires at 431966556318253 nsecs [in 18446744072690401717 nsecs]
Jul 17 12:52:54 ts28  #2: <ffff810037d9fcf8>, it_real_fn, S:01
Jul 17 12:52:54 ts28  # expires at 431967660535212 nsecs [in 85067060 nsecs]
Jul 17 12:52:54 ts28  #3: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:54 ts28  # expires at 432001537398034 nsecs [in 33961929882 nsecs]
Jul 17 12:52:54 ts28  #4: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:54 ts28  # expires at 432010476658804 nsecs [in 42901190652 nsecs]
Jul 17 12:52:54 ts28  #5: <ffff810037d9fcf8>, it_real_fn, S:01
Jul 17 12:52:54 ts28  # expires at 434227124335280 nsecs [in 2259548867128 nsecs]
Jul 17 12:52:54 ts28  #6: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:54 ts28  # expires at 439279177437767 nsecs [in 7311601969615 nsecs]
Jul 17 12:52:54 ts28 cpu: 1
Jul 17 12:52:54 ts28  clock 0:
Jul 17 12:52:54 ts28   .index:      0
Jul 17 12:52:54 ts28   .resolution: 999848 nsecs
Jul 17 12:52:54 ts28   .get_time:   ktime_get_real
Jul 17 12:52:54 ts28 active timers:
Jul 17 12:52:54 ts28  clock 1:
Jul 17 12:52:54 ts28   .index:      1
Jul 17 12:52:54 ts28   .resolution: 999848 nsecs
Jul 17 12:52:54 ts28   .get_time:   ktime_get
Jul 17 12:52:54 ts28 active timers:
Jul 17 12:52:54 ts28  #0: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:54 ts28  # expires at 431965537398313 nsecs [in 18446744071671481777 nsecs]
Jul 17 12:52:54 ts28  #1: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:54 ts28  # expires at 431975116222933 nsecs [in 7540754781 nsecs]
Jul 17 12:52:54 ts28  #2: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:54 ts28  # expires at 432024123554962 nsecs [in 56548086810 nsecs]
Jul 17 12:52:54 ts28  #3: <ffff810037d9fcf8>, hrtimer_wakeup, S:01
Jul 17 12:52:54 ts28  # expires at 432024628026277 nsecs [in 57052558125 nsecs]
Jul 17 12:52:54 ts28  #4: <ffff810037d9fcf8>, it_real_fn, S:01
Jul 17 12:52:54 ts28  # expires at 434227065407399 nsecs [in 2259489939247 nsecs]

--------------040102090302030606010604--
