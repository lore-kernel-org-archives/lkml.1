Return-Path: <linux-kernel-owner+w=401wt.eu-S966180AbXG3DPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966180AbXG3DPs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 23:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759914AbXG3DPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 23:15:37 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:38789 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937934AbXG3DPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 23:15:30 -0400
Message-ID: <46AD57BF.8090106@sw.ru>
Date: Mon, 30 Jul 2007 10:15:11 +0700
From: Vasily Averin <vvs@sw.ru>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@osdl.org>
Subject: [2.6.22] negative time jump
Content-Type: multipart/mixed;
 boundary="------------020003030905000805010003"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020003030905000805010003
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

I've investigated why my testnode freezes. When I found that node is freezed
again I've started to press Sysrq keys and noticed the following negative time jump.

Could anybody please help me to understand the reasons of this issue?

--- VvS comment: some pre-history: node boot
Jul 27 13:58:10 ts28 Linux version 2.6.22 (vvs@vvs.work.ve) (gcc version 3.4.6
20060404 (Red Hat 3.4.6-3)) #11 SMP Fri Jul 27 12:47:45 MSD 2007
Jul 27 13:58:10 ts28 Command line: ro root=LABEL=/1 console=ttyS0,115200
console=tty debug silencelevel=8 crashkernel=128M@128M acpc=noirq clocksource=tsc

[root@ts28 ~]# echo q > /proc/sysrq-trigger
Jul 27 14:09:34 ts28 now at 685327961777 nsecs

--- VvS comment: AIM7 test hangs at friday ~Jul 27 20:27:06 2007
48  135.33   98         2.8193   2149.48    167.67   Fri Jul 27 17:42:10 2007
54  127.76   99         2.3660   2561.30    190.97   Fri Jul 27 18:24:51 2007
67  117.00   99         1.7463   3470.13    237.20   Fri Jul 27 19:22:41 2007
72  112.89   99         1.5679   3864.93    248.71   Fri Jul 27 20:27:06 2007
82


---VvS comment: what I do monday morning:
[root@ts28 ~]# echo q > /proc/sysrq-trigger
Jul 30 06:15:37 ts28 SysRq : Show Pending Timers
Jul 30 06:15:37 ts28 Timer List Version: v0.3
Jul 30 06:15:37 ts28 HRTIMER_MAX_CLOCK_BASES: 2
Jul 30 06:15:37 ts28 now at 29111288132045 nsecs
--- VvS comment: I would note: 29111 sec is very strange value for node with 3
day uptime...

[root@ts28 ~]# echo q > /proc/sysrq-trigger
Jul 30 06:16:21 ts28 now at 29155644785562 nsecs

[root@ts28 ~]# echo 1 > /proc/timer_stats
[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: 17.992 s
0 total events
[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: -4366.278 s
0 total events
[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: -4359.840 s
0 total events
[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: -4347.397 s
0 total events
[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: -4331.652 s
0 total events
[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: -4297.293 s
0 total events
[root@ts28 ~]# echo q > /proc/sysrq-trigger
Jul 30 06:19:07 ts28 now at 24922828615221 nsecs

[root@ts28 ~]# echo q > /proc/sysrq-trigger
Jul 30 06:22:07 ts28 now at 25103332336122 nsecs

[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: -4065.515 s
0 total events
[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: -3913.800 s
0 total events
[root@ts28 ~]# echo q > /proc/sysrq-trigger
Jul 30 06:25:47 ts28 now at 25322820465391 nsecs

Full serial console logs are attached, The other hardware details can be found
in http://bugzilla.kernel.org/show_bug.cgi?id=8650

Thank you,
	Vasily Averin

--------------020003030905000805010003
Content-Type: text/x-log;
 name="timers.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="timers.log"

Jul 27 13:58:10 ts28 Linux version 2.6.22 (vvs@vvs.work.ve) (gcc version 3.4.6 20060404 (Red Hat 3.4.6-3)) #11 SMP Fri Jul 27 12:47:45 MSD 2007
Jul 27 13:58:10 ts28 Command line: ro root=LABEL=/1 console=ttyS0,115200 console=tty debug silencelevel=8 crashkernel=128M@128M acpc=noirq clocksource=tsc
Jul 27 13:58:10 ts28 BIOS-provided physical RAM map:
Jul 27 13:58:10 ts28  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
Jul 27 13:58:10 ts28  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
Jul 27 13:58:10 ts28  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Jul 27 13:58:10 ts28  BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
Jul 27 13:58:10 ts28  BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
Jul 27 13:58:10 ts28  BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
Jul 27 13:58:10 ts28 
Jul 27 13:58:10 ts28  BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
Jul 27 13:58:10 ts28  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Jul 27 13:58:10 ts28 Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Jul 27 13:58:10 ts28 Entering add_active_range(0, 256, 917216) 1 entries of 3200 used
Jul 27 13:58:10 ts28 end_pfn_map = 1048576
Jul 27 13:58:10 ts28 DMI 2.3 present.
Jul 27 13:58:10 ts28 ACPI: RSDP 000F6980, 0014 (r0 VIAK8 )
Jul 27 13:58:10 ts28 
Jul 27 13:58:10 ts28 ACPI: RSDT DFEE3000, 002C (r1 VIAK8  AWRDACPI 42302E31 AWRD        0)
Jul 27 13:58:10 ts28 ACPI: FACP DFEE3040, 0074 (r1 VIAK8  AWRDACPI 42302E31 AWRD        0)
Jul 27 13:58:10 ts28 ACPI: DSDT DFEE30C0, 4A4C (r1 VIAK8  AWRDACPI     1000 MSFT  100000E)
Jul 27 13:58:10 ts28 ACPI: FACS DFEE0000, 0040
Jul 27 13:58:10 ts28 ACPI: APIC DFEE7B40, 0068 (r1 VIAK8  AWRDACPI 42302E31 AWRD        0)
Jul 27 13:58:10 ts28 Scanning NUMA topology in Northbridge 24
Jul 27 13:58:10 ts28 Number of nodes 2
Jul 27 13:58:10 ts28 Node 0 MemBase 0000000000000000 Limit 00000000dfee0000
Jul 27 13:58:10 ts28 Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Jul 27 13:58:10 ts28 Entering add_active_range(0, 256, 917216) 1 entries of 3200 used
Jul 27 13:58:10 ts28 Skipping disabled node 1
Jul 27 13:58:10 ts28 NUMA: Using 63 for the hash shift.
Jul 27 13:58:10 ts28 Using node hash shift of 63
Jul 27 13:58:10 ts28 Bootmem setup node 0 0000000000000000-00000000dfee0000
Jul 27 13:58:10 ts28 Zone PFN ranges:
Jul 27 13:58:10 ts28   DMA             0 ->     4096
Jul 27 13:58:10 ts28   DMA32        4096 ->  1048576
Jul 27 13:58:10 ts28   Normal    1048576 ->  1048576
Jul 27 13:58:10 ts28 early_node_map[2] active PFN ranges
Jul 27 13:58:10 ts28     0:        0 ->      157
Jul 27 13:58:10 ts28     0:      256 ->   917216
Jul 27 13:58:10 ts28 On node 0 totalpages: 917117
Jul 27 13:58:10 ts28   DMA zone: 56 pages used for memmap
Jul 27 13:58:10 ts28   DMA zone: 2037 pages reserved
Jul 27 13:58:10 ts28   DMA zone: 1904 pages, LIFO batch:0
Jul 27 13:58:10 ts28   DMA32 zone: 12484 pages used for memmap
Jul 27 13:58:10 ts28 
Jul 27 13:58:10 ts28   DMA32 zone: 900636 pages, LIFO batch:31
Jul 27 13:58:10 ts28   Normal zone: 0 pages used for memmap
Jul 27 13:58:10 ts28 ACPI: PM-Timer IO Port: 0x4008
Jul 27 13:58:10 ts28 ACPI: Local APIC address 0xfee00000
Jul 27 13:58:10 ts28 ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Jul 27 13:58:10 ts28 Processor #0 (Bootup-CPU)
Jul 27 13:58:10 ts28 ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Jul 27 13:58:10 ts28 Processor #1
Jul 27 13:58:10 ts28 ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Jul 27 13:58:10 ts28 ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Jul 27 13:58:10 ts28 ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Jul 27 13:58:10 ts28 IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
Jul 27 13:58:10 ts28 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jul 27 13:58:10 ts28 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Jul 27 13:58:10 ts28 ACPI: IRQ0 used by override.
Jul 27 13:58:10 ts28 ACPI: IRQ2 used by override.
Jul 27 13:58:10 ts28 ACPI: IRQ9 used by override.
Jul 27 13:58:10 ts28 Setting APIC routing to flat
Jul 27 13:58:10 ts28 Using ACPI (MADT) for SMP configuration information
Jul 27 13:58:10 ts28 Allocating PCI resources starting at e0000000 (gap: dff00000:1ed00000)
Jul 27 13:58:10 ts28 PERCPU: Allocating 68072 bytes of per cpu data
Jul 27 13:58:10 ts28 Built 1 zonelists.  Total pages: 902540
Jul 27 13:58:10 ts28 Kernel command line: ro root=LABEL=/1 console=ttyS0,115200 console=tty debug silencelevel=8 crashkernel=128M@128M acpc=noirq clocksource=tsc
Jul 27 13:58:10 ts28 Initializing CPU#0
Jul 27 13:58:10 ts28 PID hash table entries: 4096 (order: 12, 32768 bytes)
Jul 27 13:58:10 ts28 Marking TSC unstable due to TSCs unsynchronized
Jul 27 13:58:10 ts28 time.c: Detected 2004.613 MHz processor.
Jul 27 13:58:10 ts28 Console: colour VGA+ 80x25
Jul 27 13:58:10 ts28 Checking aperture...
Jul 27 13:58:10 ts28 CPU 0: aperture @ e8000000 size 128 MB
Jul 27 13:58:10 ts28 CPU 1: aperture @ e8000000 size 128 MB
Jul 27 13:58:10 ts28 Memory: 3477164k/3668864k available (2428k kernel code, 191304k reserved, 1380k data, 296k init)
Jul 27 13:58:10 ts28 Calibrating delay using timer specific routine.. 4012.16 BogoMIPS (lpj=2006082)
Jul 27 13:58:10 ts28 Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Jul 27 13:58:10 ts28 Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Jul 27 13:58:10 ts28 Mount-cache hash table entries: 256
Jul 27 13:58:10 ts28 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Jul 27 13:58:10 ts28 CPU: L2 Cache: 1024K (64 bytes/line)
Jul 27 13:58:10 ts28 CPU 0/0 -> Node 0
Jul 27 13:58:10 ts28 Freeing SMP alternatives: 27k freed
Jul 27 13:58:10 ts28 ACPI: Core revision 20070126
Jul 27 13:58:10 ts28 Using local APIC timer interrupts.
Jul 27 13:58:10 ts28 result 12528849
Jul 27 13:58:10 ts28 Detected 12.528 MHz APIC timer.
Jul 27 13:58:10 ts28 Booting processor 1/2 APIC 0x1
Jul 27 13:58:10 ts28 Initializing CPU#1
Jul 27 13:58:10 ts28 Calibrating delay using timer specific routine.. 4008.60 BogoMIPS (lpj=2004302)
Jul 27 13:58:10 ts28 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Jul 27 13:58:10 ts28 CPU: L2 Cache: 1024K (64 bytes/line)
Jul 27 13:58:10 ts28 CPU 1/1 -> Node 0
Jul 27 13:58:10 ts28 AMD Opteron(tm) Processor 246 stepping 0a
Jul 27 13:58:10 ts28 Brought up 2 CPUs
Jul 27 13:58:10 ts28 migration_cost=419
Jul 27 13:58:10 ts28 NET: Registered protocol family 16
Jul 27 13:58:10 ts28 No dock devices found.
Jul 27 13:58:10 ts28 ACPI: bus type pci registered
Jul 27 13:58:10 ts28 PCI: Using configuration type 1
Jul 27 13:58:10 ts28 ACPI: Interpreter enabled
Jul 27 13:58:10 ts28 ACPI: Using IOAPIC for interrupt routing
Jul 27 13:58:10 ts28 ACPI: PCI Root Bridge [PCI0] (0000:00)
Jul 27 13:58:11 ts28 PCI: Probing PCI hardware (bus 00)
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12)
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12)
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12) *5
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12) *0, disabled.
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12) *0, disabled.
Jul 27 13:58:11 ts28 
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12) *0, disabled.
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 10 11 12) *0, disabled.
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 10 11 12) *0, disabled.
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Link [ALKA] (IRQs 20) *0
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Link [ALKB] (IRQs 21) *0
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Link [ALKC] (IRQs 22) *0
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Link [ALKD] (IRQs 23) *0, disabled.
Jul 27 13:58:11 ts28 Linux Plug and Play Support v0.97 (c) Adam Belay
Jul 27 13:58:11 ts28 pnp: PnP ACPI init
Jul 27 13:58:11 ts28 ACPI: bus type pnp registered
Jul 27 13:58:11 ts28 pnp: PnP ACPI: found 14 devices
Jul 27 13:58:11 ts28 ACPI: ACPI bus type pnp unregistered
Jul 27 13:58:11 ts28 SCSI subsystem initialized
Jul 27 13:58:11 ts28 libata version 2.21 loaded.
Jul 27 13:58:11 ts28 usbcore: registered new interface driver usbfs
Jul 27 13:58:11 ts28 usbcore: registered new interface driver hub
Jul 27 13:58:11 ts28 usbcore: registered new device driver usb
Jul 27 13:58:11 ts28 PCI: Using ACPI for IRQ routing
Jul 27 13:58:11 ts28 PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Jul 27 13:58:11 ts28 PCI: Cannot allocate resource region 0 of device 0000:00:00.0
Jul 27 13:58:11 ts28 agpgart: Detected AGP bridge 0
Jul 27 13:58:11 ts28 agpgart: AGP aperture is 128M @ 0xe8000000
Jul 27 13:58:11 ts28 pnp: 00:00: iomem range 0xd6000-0xd7fff has been reserved
Jul 27 13:58:11 ts28 pnp: 00:00: iomem range 0xf0000-0xf7fff could not be reserved
Jul 27 13:58:11 ts28 pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
Jul 27 13:58:11 ts28 pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
Jul 27 13:58:11 ts28 Time: tsc clocksource has been installed.
Jul 27 13:58:11 ts28 pnp: 00:02: ioport range 0x4000-0x407f has been reserved
Jul 27 13:58:11 ts28 pnp: 00:02: ioport range 0x5000-0x500f has been reserved
Jul 27 13:58:11 ts28 PCI: Bridge: 0000:00:01.0
Jul 27 13:58:11 ts28   IO window: disabled.
Jul 27 13:58:11 ts28   MEM window: f8000000-f9ffffff
Jul 27 13:58:11 ts28   PREFETCH window: f0000000-f7ffffff
Jul 27 13:58:11 ts28 PCI: Setting latency timer of device 0000:00:01.0 to 64
Jul 27 13:58:11 ts28 NET: Registered protocol family 2
Jul 27 13:58:11 ts28 IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
Jul 27 13:58:11 ts28 TCP established hash table entries: 524288 (order: 11, 12582912 bytes)
Jul 27 13:58:11 ts28 TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Jul 27 13:58:11 ts28 TCP: Hash tables configured (established 524288 bind 65536)
Jul 27 13:58:11 ts28 TCP reno registered
Jul 27 13:58:11 ts28 checking if image is initramfs... it is
Jul 27 13:58:11 ts28 Freeing initrd memory: 1447k freed
Jul 27 13:58:11 ts28 audit: initializing netlink socket (disabled)
Jul 27 13:58:11 ts28 audit(1185530252.320:1): initialized
Jul 27 13:58:11 ts28 Total HugeTLB memory allocated, 0
Jul 27 13:58:11 ts28 VFS: Disk quotas dquot_6.5.1
Jul 27 13:58:11 ts28 Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Jul 27 13:58:11 ts28 io scheduler noop registered
Jul 27 13:58:11 ts28 io scheduler anticipatory registered
Jul 27 13:58:11 ts28 io scheduler deadline registered
Jul 27 13:58:11 ts28 io scheduler cfq registered (default)
Jul 27 13:58:11 ts28 PCI: VIA PCI bridge detected. Disabling DAC.
Jul 27 13:58:11 ts28 Boot video device is 0000:01:00.0
Jul 27 13:58:11 ts28 pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Jul 27 13:58:11 ts28 ACPI: Fan [FAN] (on)
Jul 27 13:58:11 ts28 ACPI: Thermal Zone [THRM] (40 C)
Jul 27 13:58:11 ts28 Real Time Clock Driver v1.12ac
Jul 27 13:58:11 ts28 Non-volatile memory driver v1.2
Jul 27 13:58:11 ts28 Linux agpgart interface v0.102 (c) Dave Jones
Jul 27 13:58:11 ts28 Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Jul 27 13:58:11 ts28 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jul 27 13:58:11 ts28 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Jul 27 13:58:11 ts28 RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
Jul 27 13:58:11 ts28 Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Jul 27 13:58:11 ts28 ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Jul 27 13:58:11 ts28 VP_IDE: IDE controller at PCI slot 0000:00:0f.1
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Link [ALKA] BIOS reported IRQ 0, using IRQ 20
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
Jul 27 13:58:11 ts28 ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
Jul 27 13:58:11 ts28 VP_IDE: chipset revision 6
Jul 27 13:58:11 ts28 VP_IDE: not 100% native mode: will probe irqs later
Jul 27 13:58:11 ts28 VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
Jul 27 13:58:11 ts28     ide0: BM-DMA at 0xd800-0xd807, BIOS settings: hda:DMA, hdb:pio
Jul 27 13:58:11 ts28     ide1: BM-DMA at 0xd808-0xd80f, BIOS settings: hdc:pio, hdd:pio
Jul 27 13:58:11 ts28 Probing IDE interface ide0...
Jul 27 13:58:12 ts28 hda: TEAC DV-516G, ATAPI CD/DVD-ROM drive
Jul 27 13:58:12 ts28 ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Jul 27 13:58:12 ts28 Probing IDE interface ide1...
Jul 27 13:58:13 ts28 Probing IDE interface ide1...
Jul 27 13:58:13 ts28 hda: ATAPI 48X DVD-ROM drive, 254kB Cache, UDMA(33)
Jul 27 13:58:13 ts28 Uniform CD-ROM driver Revision: 3.20
Jul 27 13:58:13 ts28 sata_via 0000:00:0f.0: version 2.2
Jul 27 13:58:13 ts28 ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
Jul 27 13:58:13 ts28 sata_via 0000:00:0f.0: routed to hard irq line 11
Jul 27 13:58:13 ts28 scsi0 : sata_via
Jul 27 13:58:13 ts28 scsi1 : sata_via
Jul 27 13:58:13 ts28 ata1: SATA max UDMA/133 cmd 0x000000000001c000 ctl 0x000000000001c402 bmdma 0x000000000001d000 irq 20
Jul 27 13:58:13 ts28 ata2: SATA max UDMA/133 cmd 0x000000000001c800 ctl 0x000000000001cc02 bmdma 0x000000000001d008 irq 20
Jul 27 13:58:14 ts28 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Jul 27 13:58:14 ts28 ata1.00: ATA-7: ST380811AS, 3.AAE, max UDMA/133
Jul 27 13:58:14 ts28 ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)
Jul 27 13:58:14 ts28 ata1.00: configured for UDMA/133
Jul 27 13:58:14 ts28 ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
Jul 27 13:58:14 ts28 scsi 0:0:0:0: Direct-Access     ATA      ST380811AS       3.AA PQ: 0 ANSI: 5
Jul 27 13:58:14 ts28 sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
Jul 27 13:58:14 ts28 sd 0:0:0:0: [sda] Write Protect is off
Jul 27 13:58:14 ts28 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jul 27 13:58:14 ts28 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 27 13:58:14 ts28 sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
Jul 27 13:58:14 ts28 sd 0:0:0:0: [sda] Write Protect is off
Jul 27 13:58:14 ts28 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jul 27 13:58:14 ts28 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 27 13:58:14 ts28  sda: sda1 sda2 sda3 sda4 < sda5 >
Jul 27 13:58:14 ts28 sd 0:0:0:0: [sda] Attached SCSI disk
Jul 27 13:58:14 ts28 PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Jul 27 13:58:14 ts28 serio: i8042 KBD port at 0x60,0x64 irq 1
Jul 27 13:58:14 ts28 serio: i8042 AUX port at 0x60,0x64 irq 12
Jul 27 13:58:14 ts28 mice: PS/2 mouse device common for all mice
Jul 27 13:58:14 ts28 input: AT Translated Set 2 keyboard as /class/input/input0
Jul 27 13:58:14 ts28 usbcore: registered new interface driver hiddev
Jul 27 13:58:14 ts28 usbcore: registered new interface driver usbhid
Jul 27 13:58:14 ts28 drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Jul 27 13:58:14 ts28 TCP bic registered
Jul 27 13:58:14 ts28 Initializing XFRM netlink socket
Jul 27 13:58:14 ts28 NET: Registered protocol family 1
Jul 27 13:58:14 ts28 NET: Registered protocol family 17
Jul 27 13:58:14 ts28 powernow-k8: Found 2 AMD Opteron(tm) Processor 246 processors (version 2.00.00)
Jul 27 13:58:14 ts28 powernow-k8: MP systems not supported by PSB BIOS structure
Jul 27 13:58:14 ts28 powernow-k8: MP systems not supported by PSB BIOS structure
Jul 27 13:58:14 ts28 Freeing unused kernel memory: 296k freed
Jul 27 13:58:14 ts28 Write protecting the kernel read-only data: 832k
Jul 27 13:58:15 ts28 input: ImPS/2 Generic Wheel Mouse as /class/input/input1
Jul 27 13:58:15 ts28 USB Universal Host Controller Interface driver v3.0
Jul 27 13:58:15 ts28 ACPI: PCI Interrupt Link [ALKB] BIOS reported IRQ 0, using IRQ 21
Jul 27 13:58:15 ts28 ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
Jul 27 13:58:15 ts28 ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
Jul 27 13:58:15 ts28 uhci_hcd 0000:00:10.0: UHCI Host Controller
Jul 27 13:58:15 ts28 uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
Jul 27 13:58:15 ts28 uhci_hcd 0000:00:10.0: irq 21, io base 0x0000dc00
Jul 27 13:58:15 ts28 usb usb1: configuration #1 chosen from 1 choice
Jul 27 13:58:15 ts28 hub 1-0:1.0: USB hub found
Jul 27 13:58:15 ts28 hub 1-0:1.0: 2 ports detected
Jul 27 13:58:15 ts28 ACPI: PCI Interrupt 0000:00:10.1[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
Jul 27 13:58:15 ts28 uhci_hcd 0000:00:10.1: UHCI Host Controller
Jul 27 13:58:15 ts28 uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
Jul 27 13:58:15 ts28 uhci_hcd 0000:00:10.1: irq 21, io base 0x0000e000
Jul 27 13:58:15 ts28 usb usb2: configuration #1 chosen from 1 choice
Jul 27 13:58:15 ts28 hub 2-0:1.0: USB hub found
Jul 27 13:58:15 ts28 hub 2-0:1.0: 2 ports detected
Jul 27 13:58:15 ts28 ACPI: PCI Interrupt 0000:00:10.2[B] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
Jul 27 13:58:15 ts28 uhci_hcd 0000:00:10.2: UHCI Host Controller
Jul 27 13:58:15 ts28 uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
Jul 27 13:58:15 ts28 uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e400
Jul 27 13:58:15 ts28 usb usb3: configuration #1 chosen from 1 choice
Jul 27 13:58:15 ts28 hub 3-0:1.0: USB hub found
Jul 27 13:58:15 ts28 hub 3-0:1.0: 2 ports detected
Jul 27 13:58:15 ts28 ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
Jul 27 13:58:15 ts28 ACPI: PCI Interrupt 0000:00:10.4[C] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
Jul 27 13:58:15 ts28 ehci_hcd 0000:00:10.4: EHCI Host Controller
Jul 27 13:58:15 ts28 ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 4
Jul 27 13:58:15 ts28 ehci_hcd 0000:00:10.4: irq 21, io mem 0xfa010000
Jul 27 13:58:15 ts28 ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Jul 27 13:58:15 ts28 usb usb4: configuration #1 chosen from 1 choice
Jul 27 13:58:15 ts28 hub 4-0:1.0: USB hub found
Jul 27 13:58:15 ts28 
Jul 27 13:58:15 ts28 hub 4-0:1.0: 6 ports detected
Jul 27 13:58:15 ts28 device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Jul 27 13:58:15 ts28 kjournald starting.  Commit interval 5 seconds
Jul 27 13:58:15 ts28 EXT3-fs: mounted filesystem with ordered data mode.
Jul 27 13:58:30 ts28 Bluetooth: Core ver 2.11
Jul 27 13:58:30 ts28 NET: Registered protocol family 31
Jul 27 13:58:30 ts28 Bluetooth: HCI device and connection manager initialized
Jul 27 13:58:30 ts28 Bluetooth: HCI socket layer initialized
Jul 27 13:58:30 ts28 Bluetooth: L2CAP ver 2.8
Jul 27 13:58:30 ts28 Bluetooth: L2CAP socket layer initialized
Jul 27 13:58:30 ts28 Bluetooth: RFCOMM socket layer initialized
Jul 27 13:58:30 ts28 Bluetooth: RFCOMM TTY layer initialized
Jul 27 13:58:30 ts28 Bluetooth: RFCOMM ver 1.8
Jul 27 13:58:30 ts28 Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Jul 27 13:58:38 ts28 eth0: no IPv6 routers present
Jul 27 14:01:27 ts28 VZTEST vzt-aim7 0
Jul 27 14:01:28 ts28 Server date: ‘Œ È¿Ã 27 14:00:50 MSD 2007
Jul 27 14:09:34 ts28 SysRq : Show Pending Timers
Jul 27 14:09:34 ts28 Timer List Version: v0.3
Jul 27 14:09:34 ts28 HRTIMER_MAX_CLOCK_BASES: 2
Jul 27 14:09:34 ts28 now at 685327961777 nsecs
Jul 27 14:09:34 ts28 cpu: 0
Jul 27 14:09:34 ts28  clock 0:
Jul 27 14:09:34 ts28   .index:      0
Jul 27 14:09:34 ts28   .resolution: 999848 nsecs
Jul 27 14:09:34 ts28   .get_time:   ktime_get_real
Jul 27 14:09:34 ts28 active timers:
Jul 27 14:09:34 ts28 
Jul 27 14:09:34 ts28  clock 1:
Jul 27 14:09:34 ts28   .index:      1
Jul 27 14:09:34 ts28   .resolution: 999848 nsecs
Jul 27 14:09:34 ts28   .get_time:   ktime_get
Jul 27 14:09:34 ts28 active timers:
Jul 27 14:09:34 ts28  #0: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, hald-addon-stor/2658
Jul 27 14:09:34 ts28  # expires at 685454912197 nsecs [in 126950420 nsecs]
Jul 27 14:09:34 ts28  #1: <ffff8100d2997e28>, hrtimer_wakeup, S:01, futex_wait, automount/2432
Jul 27 14:09:34 ts28  # expires at 685477381288 nsecs [in 149419511 nsecs]
Jul 27 14:09:34 ts28  #2: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, pcscd/2404
Jul 27 14:09:34 ts28  # expires at 686101809269 nsecs [in 773847492 nsecs]
Jul 27 14:09:34 ts28  #3: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, vmstat/4051
Jul 27 14:09:34 ts28  # expires at 686714033723 nsecs [in 1386071946 nsecs]
Jul 27 14:09:34 ts28  #4: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, crond/2549
Jul 27 14:09:34 ts28  # expires at 689706595957 nsecs [in 4378634180 nsecs]
Jul 27 14:09:34 ts28  #5: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, syslogd/2127
Jul 27 14:09:34 ts28  # expires at 710100747037 nsecs [in 24772785260 nsecs]
Jul 27 14:09:34 ts28  #6: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, smartd/2691
Jul 27 14:09:34 ts28  # expires at 1826718147573 nsecs [in 1141390185796 nsecs]
Jul 27 14:09:34 ts28  #7: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, rhnsd/2594
Jul 27 14:09:34 ts28  # expires at 12894710704826 nsecs [in 12209382743049 nsecs]
Jul 27 14:09:34 ts28 
Jul 27 14:09:34 ts28 cpu: 1
Jul 27 14:09:34 ts28  clock 0:
Jul 27 14:09:34 ts28   .index:      0
Jul 27 14:09:34 ts28   .resolution: 999848 nsecs
Jul 27 14:09:34 ts28   .get_time:   ktime_get_real
Jul 27 14:09:34 ts28 active timers:
Jul 27 14:09:34 ts28  clock 1:
Jul 27 14:09:34 ts28   .index:      1
Jul 27 14:09:34 ts28   .resolution: 999848 nsecs
Jul 27 14:09:34 ts28   .get_time:   ktime_get
Jul 27 14:09:34 ts28 active timers:
Jul 27 14:09:34 ts28  #0: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2146
Jul 27 14:09:34 ts28  # expires at 685379417566 nsecs [in 51455789 nsecs]
Jul 27 14:09:34 ts28  #1: <ffff8100d2997e28>, hrtimer_wakeup, S:01, futex_wait, automount/2431
Jul 27 14:09:34 ts28  # expires at 754477381442 nsecs [in 69149419665 nsecs]
Jul 27 14:09:34 ts28  #2: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, atd/2578
Jul 27 14:09:34 ts28  # expires at 922636188995 nsecs [in 237308227218 nsecs]
Jul 27 14:09:34 ts28  #3: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, sendmail/2510
Jul 27 14:09:34 ts28  # expires at 3622342732579 nsecs [in 2937014770802 nsecs]
Jul 27 14:09:34 ts28  #4: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, sendmail/2518
Jul 27 14:09:34 ts28  # expires at 3622497530251 nsecs [in 2937169568474 nsecs]
Jul 27 14:29:46 ts28 hda: lost interrupt
Jul 27 15:34:19 ts28 hda: lost interrupt
Jul 27 18:29:47 ts28 hda: lost interrupt
Jul 30 06:15:37 ts28 SysRq : Show Pending Timers
Jul 30 06:15:37 ts28 Timer List Version: v0.3
Jul 30 06:15:37 ts28 HRTIMER_MAX_CLOCK_BASES: 2
Jul 30 06:15:37 ts28 now at 29111288132045 nsecs
Jul 30 06:15:37 ts28 cpu: 0
Jul 30 06:15:37 ts28  clock 0:
Jul 30 06:15:37 ts28   .index:      0
Jul 30 06:15:37 ts28   .resolution: 999848 nsecs
Jul 30 06:15:37 ts28   .get_time:   ktime_get_real
Jul 30 06:15:37 ts28 active timers:
Jul 30 06:15:37 ts28  clock 1:
Jul 30 06:15:37 ts28   .index:      1
Jul 30 06:15:37 ts28   .resolution: 999848 nsecs
Jul 30 06:15:37 ts28   .get_time:   ktime_get
Jul 30 06:15:37 ts28 active timers:
Jul 30 06:15:37 ts28  #0: <ffff8100d2997e28>, hrtimer_wakeup, S:01, futex_wait, automount/2432
Jul 30 06:15:37 ts28  # expires at 24810477381515 nsecs [in 18446739772898801086 nsecs]
Jul 30 06:15:37 ts28  #1: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, vmstat/4051
Jul 30 06:15:37 ts28  # expires at 24811646186522 nsecs [in 18446739774067606093 nsecs]
Jul 30 06:15:37 ts28  #2: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, syslogd/2127
Jul 30 06:15:37 ts28  # expires at 24831325550055 nsecs [in 18446739793746969626 nsecs]
Jul 30 06:15:37 ts28  #3: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, sendmail/2510
Jul 30 06:15:37 ts28  # expires at 25222357715198 nsecs [in 18446740184779134769 nsecs]
Jul 30 06:15:37 ts28  #4: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, sendmail/2518
Jul 30 06:15:37 ts28  # expires at 25222512655696 nsecs [in 18446740184934075267 nsecs]
Jul 30 06:15:37 ts28  #5: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, smartd/2691
Jul 30 06:15:37 ts28  # expires at 25227151980383 nsecs [in 18446740189573399954 nsecs]
Jul 30 06:15:37 ts28 cpu: 1
Jul 30 06:15:37 ts28  clock 0:
Jul 30 06:15:37 ts28   .index:      0
Jul 30 06:15:37 ts28   .resolution: 999848 nsecs
Jul 30 06:15:37 ts28   .get_time:   ktime_get_real
Jul 30 06:15:37 ts28 active timers:
Jul 30 06:15:37 ts28  clock 1:
Jul 30 06:15:37 ts28   .index:      1
Jul 30 06:15:37 ts28   .resolution: 999848 nsecs
Jul 30 06:15:37 ts28   .get_time:   ktime_get
Jul 30 06:15:37 ts28 active timers:
Jul 30 06:15:37 ts28  #0: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, pcscd/2404
Jul 30 06:15:37 ts28  # expires at 24809816102307 nsecs [in 18446739772237521878 nsecs]
Jul 30 06:15:37 ts28  #1: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, crond/2549
Jul 30 06:15:37 ts28  # expires at 24810169561628 nsecs [in 18446739772590981199 nsecs]
Jul 30 06:15:37 ts28  #2: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, hald-addon-stor/2658
Jul 30 06:15:37 ts28 
Jul 30 06:15:37 ts28  # expires at 24810685882983 nsecs [in 18446739773107302554 nsecs]
Jul 30 06:15:37 ts28  #3: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2146
Jul 30 06:15:37 ts28  # expires at 24819617556407 nsecs [in 18446739782038975978 nsecs]
Jul 30 06:15:37 ts28  #4: <ffff8100d2997e28>, hrtimer_wakeup, S:01, futex_wait, automount/2431
Jul 30 06:15:37 ts28  # expires at 24829477381513 nsecs [in 18446739791898801084 nsecs]
Jul 30 06:15:37 ts28  #5: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, atd/2578
Jul 30 06:15:37 ts28  # expires at 24922978747105 nsecs [in 18446739885400166676 nsecs]
Jul 30 06:15:37 ts28 
Jul 30 06:15:37 ts28  #6: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, rhnsd/2594
Jul 30 06:15:37 ts28  # expires at 27295278724036 nsecs [in 18446742257700143607 nsecs]
Jul 30 06:16:21 ts28 SysRq : Show Pending Timers
Jul 30 06:16:21 ts28 Timer List Version: v0.3
Jul 30 06:16:21 ts28 HRTIMER_MAX_CLOCK_BASES: 2
Jul 30 06:16:21 ts28 now at 29155644785562 nsecs
Jul 30 06:16:21 ts28 cpu: 0
Jul 30 06:16:21 ts28  clock 0:
Jul 30 06:16:21 ts28   .index:      0
Jul 30 06:16:21 ts28   .resolution: 999848 nsecs
Jul 30 06:16:21 ts28   .get_time:   ktime_get_real
Jul 30 06:16:21 ts28 active timers:
Jul 30 06:16:21 ts28  clock 1:
Jul 30 06:16:21 ts28   .index:      1
Jul 30 06:16:21 ts28   .resolution: 999848 nsecs
Jul 30 06:16:21 ts28   .get_time:   ktime_get
Jul 30 06:16:21 ts28 active timers:
Jul 30 06:16:21 ts28  #0: <ffff8100d2997e28>, hrtimer_wakeup, S:01, futex_wait, automount/2432
Jul 30 06:16:21 ts28  # expires at 24810477381515 nsecs [in 18446739728542147569 nsecs]
Jul 30 06:16:21 ts28  #1: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, vmstat/4051
Jul 30 06:16:21 ts28  # expires at 24811646186522 nsecs [in 18446739729710952576 nsecs]
Jul 30 06:16:21 ts28  #2: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, syslogd/2127
Jul 30 06:16:21 ts28  # expires at 24831325550055 nsecs [in 18446739749390316109 nsecs]
Jul 30 06:16:21 ts28  #3: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, sendmail/2510
Jul 30 06:16:21 ts28  # expires at 25222357715198 nsecs [in 18446740140422481252 nsecs]
Jul 30 06:16:21 ts28  #4: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, sendmail/2518
Jul 30 06:16:21 ts28  # expires at 25222512655696 nsecs [in 18446740140577421750 nsecs]
Jul 30 06:16:21 ts28  #5: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, smartd/2691
Jul 30 06:16:21 ts28  # expires at 25227151980383 nsecs [in 18446740145216746437 nsecs]
Jul 30 06:16:21 ts28 cpu: 1
Jul 30 06:16:21 ts28  clock 0:
Jul 30 06:16:22 ts28   .index:      0
Jul 30 06:16:22 ts28   .resolution: 999848 nsecs
Jul 30 06:16:22 ts28   .get_time:   ktime_get_real
Jul 30 06:16:22 ts28 active timers:
Jul 30 06:16:22 ts28  clock 1:
Jul 30 06:16:22 ts28   .index:      1
Jul 30 06:16:22 ts28   .resolution: 999848 nsecs
Jul 30 06:16:22 ts28   .get_time:   ktime_get
Jul 30 06:16:22 ts28 active timers:
Jul 30 06:16:22 ts28  #0: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, pcscd/2404
Jul 30 06:16:22 ts28  # expires at 24809816102307 nsecs [in 18446739727880868361 nsecs]
Jul 30 06:16:22 ts28 
Jul 30 06:16:22 ts28  #1: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, crond/2549
Jul 30 06:16:22 ts28  # expires at 24810169561628 nsecs [in 18446739728234327682 nsecs]
Jul 30 06:16:22 ts28  #2: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, hald-addon-stor/2658
Jul 30 06:16:22 ts28 
Jul 30 06:16:22 ts28  # expires at 24810685882983 nsecs [in 18446739728750649037 nsecs]
Jul 30 06:16:22 ts28  #3: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2146
Jul 30 06:16:22 ts28  # expires at 24819617556407 nsecs [in 18446739737682322461 nsecs]
Jul 30 06:16:22 ts28  #4: <ffff8100d2997e28>, hrtimer_wakeup, S:01, futex_wait, automount/2431
Jul 30 06:16:22 ts28  # expires at 24829477381513 nsecs [in 18446739747542147567 nsecs]
Jul 30 06:16:22 ts28  #5: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, atd/2578
Jul 30 06:16:22 ts28  # expires at 24922978747105 nsecs [in 18446739841043513159 nsecs]
Jul 30 06:16:22 ts28 
Jul 30 06:16:22 ts28  #6: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, rhnsd/2594
Jul 30 06:16:22 ts28  # expires at 27295278724036 nsecs [in 18446742213343490090 nsecs]
Jul 30 06:19:07 ts28 SysRq : Show Pending Timers
Jul 30 06:19:07 ts28 Timer List Version: v0.3
Jul 30 06:19:07 ts28 HRTIMER_MAX_CLOCK_BASES: 2
Jul 30 06:19:07 ts28 now at 24922828615221 nsecs
Jul 30 06:19:07 ts28 cpu: 0
Jul 30 06:19:07 ts28  clock 0:
Jul 30 06:19:07 ts28   .index:      0
Jul 30 06:19:07 ts28   .resolution: 999848 nsecs
Jul 30 06:19:07 ts28   .get_time:   ktime_get_real
Jul 30 06:19:07 ts28 active timers:
Jul 30 06:19:07 ts28  clock 1:
Jul 30 06:19:07 ts28 
Jul 30 06:19:07 ts28   .index:      1
Jul 30 06:19:07 ts28   .resolution: 999848 nsecs
Jul 30 06:19:07 ts28   .get_time:   ktime_get
Jul 30 06:19:07 ts28 active timers:
Jul 30 06:19:07 ts28  #0: <ffff8100d2997e28>, hrtimer_wakeup, S:01, futex_wait, automount/2432
Jul 30 06:19:07 ts28  # expires at 24810477381515 nsecs [in 18446743961358317910 nsecs]
Jul 30 06:19:07 ts28  #1: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, vmstat/4051
Jul 30 06:19:07 ts28  # expires at 24811646186522 nsecs [in 18446743962527122917 nsecs]
Jul 30 06:19:07 ts28  #2: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, syslogd/2127
Jul 30 06:19:07 ts28  # expires at 24831325550055 nsecs [in 18446743982206486450 nsecs]
Jul 30 06:19:07 ts28  #3: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, sendmail/2510
Jul 30 06:19:07 ts28  # expires at 25222357715198 nsecs [in 299529099977 nsecs]
Jul 30 06:19:07 ts28  #4: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, sendmail/2518
Jul 30 06:19:07 ts28  # expires at 25222512655696 nsecs [in 299684040475 nsecs]
Jul 30 06:19:07 ts28  #5: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, smartd/2691
Jul 30 06:19:07 ts28  # expires at 25227151980383 nsecs [in 304323365162 nsecs]
Jul 30 06:19:07 ts28 cpu: 1
Jul 30 06:19:07 ts28  clock 0:
Jul 30 06:19:07 ts28   .index:      0
Jul 30 06:19:07 ts28   .resolution: 999848 nsecs
Jul 30 06:19:07 ts28   .get_time:   ktime_get_real
Jul 30 06:19:07 ts28 active timers:
Jul 30 06:19:07 ts28  clock 1:
Jul 30 06:19:07 ts28   .index:      1
Jul 30 06:19:07 ts28   .resolution: 999848 nsecs
Jul 30 06:19:07 ts28   .get_time:   ktime_get
Jul 30 06:19:07 ts28 active timers:
Jul 30 06:19:07 ts28  #0: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, pcscd/2404
Jul 30 06:19:07 ts28  # expires at 24809816102307 nsecs [in 18446743960697038702 nsecs]
Jul 30 06:19:07 ts28  #1: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, crond/2549
Jul 30 06:19:07 ts28  # expires at 24810169561628 nsecs [in 18446743961050498023 nsecs]
Jul 30 06:19:07 ts28  #2: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, hald-addon-stor/2658
Jul 30 06:19:07 ts28  # expires at 24810685882983 nsecs [in 18446743961566819378 nsecs]
Jul 30 06:19:07 ts28  #3: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2146
Jul 30 06:19:07 ts28  # expires at 24819617556407 nsecs [in 18446743970498492802 nsecs]
Jul 30 06:19:07 ts28  #4: <ffff8100d2997e28>, hrtimer_wakeup, S:01, futex_wait, automount/2431
Jul 30 06:19:07 ts28  # expires at 24829477381513 nsecs [in 18446743980358317908 nsecs]
Jul 30 06:19:07 ts28  #5: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, atd/2578
Jul 30 06:19:07 ts28  # expires at 24922978747105 nsecs [in 150131884 nsecs]
Jul 30 06:19:07 ts28  #6: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, rhnsd/2594
Jul 30 06:19:07 ts28  # expires at 27295278724036 nsecs [in 2372450108815 nsecs]
Jul 30 06:22:07 ts28 SysRq : Show Pending Timers
Jul 30 06:22:07 ts28 Timer List Version: v0.3
Jul 30 06:22:07 ts28 HRTIMER_MAX_CLOCK_BASES: 2
Jul 30 06:22:07 ts28 now at 25103332336122 nsecs
Jul 30 06:22:07 ts28 
Jul 30 06:22:07 ts28 cpu: 0
Jul 30 06:22:07 ts28  clock 0:
Jul 30 06:22:07 ts28   .index:      0
Jul 30 06:22:07 ts28   .resolution: 999848 nsecs
Jul 30 06:22:07 ts28   .get_time:   ktime_get_real
Jul 30 06:22:07 ts28 active timers:
Jul 30 06:22:07 ts28  clock 1:
Jul 30 06:22:07 ts28   .index:      1
Jul 30 06:22:07 ts28   .resolution: 999848 nsecs
Jul 30 06:22:07 ts28   .get_time:   ktime_get
Jul 30 06:22:07 ts28 active timers:
Jul 30 06:22:07 ts28  #0: <ffff8100d2997e28>, hrtimer_wakeup, S:01, futex_wait, automount/2432
Jul 30 06:22:07 ts28  # expires at 24810477381515 nsecs [in 18446743780854597009 nsecs]
Jul 30 06:22:07 ts28  #1: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, vmstat/4051
Jul 30 06:22:07 ts28  # expires at 24811646186522 nsecs [in 18446743782023402016 nsecs]
Jul 30 06:22:07 ts28  #2: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, syslogd/2127
Jul 30 06:22:07 ts28  # expires at 24831325550055 nsecs [in 18446743801702765549 nsecs]
Jul 30 06:22:07 ts28  #3: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, sendmail/2510
Jul 30 06:22:07 ts28  # expires at 25222357715198 nsecs [in 119025379076 nsecs]
Jul 30 06:22:07 ts28  #4: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, sendmail/2518
Jul 30 06:22:07 ts28  # expires at 25222512655696 nsecs [in 119180319574 nsecs]
Jul 30 06:22:07 ts28  #5: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, smartd/2691
Jul 30 06:22:07 ts28  # expires at 25227151980383 nsecs [in 123819644261 nsecs]
Jul 30 06:22:07 ts28 cpu: 1
Jul 30 06:22:07 ts28  clock 0:
Jul 30 06:22:07 ts28   .index:      0
Jul 30 06:22:07 ts28   .resolution: 999848 nsecs
Jul 30 06:22:07 ts28 
Jul 30 06:22:07 ts28   .get_time:   ktime_get_real
Jul 30 06:22:07 ts28 active timers:
Jul 30 06:22:07 ts28  clock 1:
Jul 30 06:22:07 ts28   .index:      1
Jul 30 06:22:07 ts28   .resolution: 999848 nsecs
Jul 30 06:22:07 ts28   .get_time:   ktime_get
Jul 30 06:22:07 ts28 active timers:
Jul 30 06:22:07 ts28  #0: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, pcscd/2404
Jul 30 06:22:07 ts28  # expires at 24809816102307 nsecs [in 18446743780193317801 nsecs]
Jul 30 06:22:07 ts28  #1: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, crond/2549
Jul 30 06:22:07 ts28  # expires at 24810169561628 nsecs [in 18446743780546777122 nsecs]
Jul 30 06:22:07 ts28  #2: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, hald-addon-stor/2658
Jul 30 06:22:07 ts28  # expires at 24810685882983 nsecs [in 18446743781063098477 nsecs]
Jul 30 06:22:07 ts28  #3: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2146
Jul 30 06:22:07 ts28  # expires at 24819617556407 nsecs [in 18446743789994771901 nsecs]
Jul 30 06:22:07 ts28  #4: <ffff8100d2997e28>, hrtimer_wakeup, S:01, futex_wait, automount/2431
Jul 30 06:22:07 ts28  # expires at 24829477381513 nsecs [in 18446743799854597007 nsecs]
Jul 30 06:22:07 ts28  #5: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, atd/2578
Jul 30 06:22:07 ts28  # expires at 24922978747105 nsecs [in 18446743893355962599 nsecs]
Jul 30 06:22:07 ts28  #6: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, rhnsd/2594
Jul 30 06:22:07 ts28  # expires at 27295278724036 nsecs [in 2191946387914 nsecs]
Jul 30 06:25:47 ts28 SysRq : Show Pending Timers
Jul 30 06:25:47 ts28 Timer List Version: v0.3
Jul 30 06:25:47 ts28 HRTIMER_MAX_CLOCK_BASES: 2
Jul 30 06:25:47 ts28 now at 25322820465391 nsecs
Jul 30 06:25:47 ts28 cpu: 0
Jul 30 06:25:47 ts28  clock 0:
Jul 30 06:25:47 ts28   .index:      0
Jul 30 06:25:47 ts28   .resolution: 999848 nsecs
Jul 30 06:25:47 ts28   .get_time:   ktime_get_real
Jul 30 06:25:47 ts28 active timers:
Jul 30 06:25:47 ts28  clock 1:
Jul 30 06:25:47 ts28   .index:      1
Jul 30 06:25:47 ts28   .resolution: 999848 nsecs
Jul 30 06:25:47 ts28   .get_time:   ktime_get
Jul 30 06:25:47 ts28 active timers:
Jul 30 06:25:47 ts28  #0: <ffff8100d2997e28>, hrtimer_wakeup, S:01, futex_wait, automount/2432
Jul 30 06:25:47 ts28  # expires at 24810477381515 nsecs [in 18446743561366467740 nsecs]
Jul 30 06:25:47 ts28  #1: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, vmstat/4051
Jul 30 06:25:47 ts28  # expires at 24811646186522 nsecs [in 18446743562535272747 nsecs]
Jul 30 06:25:47 ts28  #2: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, syslogd/2127
Jul 30 06:25:47 ts28  # expires at 24831325550055 nsecs [in 18446743582214636280 nsecs]
Jul 30 06:25:47 ts28  #3: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, sendmail/2510
Jul 30 06:25:47 ts28  # expires at 25222357715198 nsecs [in 18446743973246801423 nsecs]
Jul 30 06:25:47 ts28  #4: <ffff8100d2997e28>, it_real_fn, S:01, do_setitimer, sendmail/2518
Jul 30 06:25:47 ts28  # expires at 25222512655696 nsecs [in 18446743973401741921 nsecs]
Jul 30 06:25:47 ts28  #5: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, smartd/2691
Jul 30 06:25:47 ts28  # expires at 25227151980383 nsecs [in 18446743978041066608 nsecs]
Jul 30 06:25:47 ts28 cpu: 1
Jul 30 06:25:47 ts28  clock 0:
Jul 30 06:25:47 ts28   .index:      0
Jul 30 06:25:47 ts28   .resolution: 999848 nsecs
Jul 30 06:25:47 ts28 
Jul 30 06:25:47 ts28   .get_time:   ktime_get_real
Jul 30 06:25:47 ts28 active timers:
Jul 30 06:25:47 ts28  clock 1:
Jul 30 06:25:47 ts28   .index:      1
Jul 30 06:25:47 ts28   .resolution: 999848 nsecs
Jul 30 06:25:47 ts28   .get_time:   ktime_get
Jul 30 06:25:47 ts28 active timers:
Jul 30 06:25:47 ts28  #0: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, pcscd/2404
Jul 30 06:25:47 ts28  # expires at 24809816102307 nsecs [in 18446743560705188532 nsecs]
Jul 30 06:25:47 ts28  #1: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, crond/2549
Jul 30 06:25:47 ts28  # expires at 24810169561628 nsecs [in 18446743561058647853 nsecs]
Jul 30 06:25:47 ts28  #2: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, hald-addon-stor/2658
Jul 30 06:25:47 ts28  # expires at 24810685882983 nsecs [in 18446743561574969208 nsecs]
Jul 30 06:25:47 ts28  #3: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2146
Jul 30 06:25:47 ts28  # expires at 24819617556407 nsecs [in 18446743570506642632 nsecs]
Jul 30 06:25:47 ts28  #4: <ffff8100d2997e28>, hrtimer_wakeup, S:01, futex_wait, automount/2431
Jul 30 06:25:47 ts28  # expires at 24829477381513 nsecs [in 18446743580366467738 nsecs]
Jul 30 06:25:47 ts28  #5: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, atd/2578
Jul 30 06:25:47 ts28  # expires at 24922978747105 nsecs [in 18446743673867833330 nsecs]
Jul 30 06:25:47 ts28  #6: <ffff8100d2997e28>, hrtimer_wakeup, S:01, do_nanosleep, rhnsd/2594
Jul 30 06:25:47 ts28  # expires at 27295278724036 nsecs [in 1972458258645 nsecs]

--------------020003030905000805010003--
