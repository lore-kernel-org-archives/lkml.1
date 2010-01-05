Return-Path: <linux-kernel-owner+w=401wt.eu-S1751770Ab0AEJpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab0AEJpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 04:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781Ab0AEJpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 04:45:53 -0500
Received: from pc-249.acfr.usyd.edu.au ([129.78.210.249]:60485 "EHLO
	rosaceae.acfr.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0AEJps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 04:45:48 -0500
X-Greylist: delayed 1580 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 04:45:47 EST
From: Alex Brooks <a.brooks@marathon-robotics.com>
Organization: Marathon Robotics
To: linux-kernel@vger.kernel.org
Subject: BAR 0: can't allocate resource
Date: Tue, 5 Jan 2010 20:18:02 +1100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_KPwQLpwlB5LmXmq"
Message-Id: <201001052018.02607.a.brooks@marathon-robotics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_KPwQLpwlB5LmXmq
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I have a problem getting a couple of PCI cards to play nicely together.  The 
error I get (in dmesg) is:
2.6.26 kernel:
[    0.215619] PCI: Cannot allocate resource region 0 of device 0000:01:04.0
2.6.30 kernel:
[    0.138390] pci 0000:01:04.0: BAR 0: can't allocate resource

And (for both kernels) the output of lspci has the following line:
  01:04.0 Unclassified device [0080]: Device 0002:0080

Hardware Details:
 - My motherboard is a DigitalLogic MSM945.  It has a PC104 bus.
 - I have two PC104 cards:
   i)  8-port serial card (DiamondSystems Emerald-MM-8Plus)
   ii) PC/104+ to MiniPCI Adapter (ConnectTech) (no MiniPCI cards installed).
  (I have run both of these cards with a different motherboard, no problems).

I've compared two conditions:
 a) "working": serial card installed by itself, and
 b) "broken": serial + MiniPCI cards both installed

For the 2.6.26 kernel, I've attached the output of 
 - dmesg
 - lspci
 - lspci -v
 - cat /proc/iomem
for both 'working' and 'broken' cases.

(Note: in both cases the following two lines appear in the dmesg output:
[    0.185656] PCI: BIOS Bug: MCFG area at e0000000 is not reserved in ACPI 
motherboard resources
[    0.185711] PCI: Not using MMCONFIG
Is this significant?)


Does anyone have any ideas what to try here?  I've been fighting with this for 
a while now...
(Please Cc me on any response).

Thanks,

Alex

--Boundary-00=_KPwQLpwlB5LmXmq
Content-Type: text/plain;
  charset="iso 8859-15";
  name="dmesg_broken.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_broken.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.26-2-686 (Debian 2.6.26-19lenny2) (dannf@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-25)) #1 SMP Wed Nov 4 20:45:37 UTC 2009
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f7c0000 (usable)
[    0.000000]  BIOS-e820: 000000003f7c0000 - 000000003f7ce000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003f7ce000 - 000000003f800000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] 119MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at [c00ff780] 000ff780
[    0.000000] Entering add_active_range(0, 0, 260032) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   260032
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   260032
[    0.000000] On node 0 totalpages: 260032
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 240 pages used for memmap
[    0.000000]   HighMem zone: 30416 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F8ED0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 3F7C0000, 003C (r1 112007 RSDT1407 20071120 MSFT       97)
[    0.000000] ACPI: FACP 3F7C0200, 0084 (r2 112007 FACP1407 20071120 MSFT       97)
[    0.000000] ACPI: DSDT 3F7C05B0, 4FF8 (r1  DLAG_ DLAG_117      117 INTL 20051117)
[    0.000000] ACPI: FACS 3F7CE000, 0040
[    0.000000] ACPI: APIC 3F7C0390, 005C (r1 112007 APIC1407 20071120 MSFT       97)
[    0.000000] ACPI: MCFG 3F7C03F0, 003C (r1 112007 OEMMCFG  20071120 MSFT       97)
[    0.000000] ACPI: SLIC 3F7C0430, 0176 (r1 112007 SLIC1407 20071120 MSFT       97)
[    0.000000] ACPI: OEMB 3F7CE040, 0071 (r1 112007 OEMB1407 20071120 MSFT       97)
[    0.000000] ACPI: ASF! 3F7C55B0, 0075 (r32 LEGEND I865PASF        1 INTL 20051117)
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 3f800000:bf600000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] SMP: Allowing 2 CPUs, 1 hotplug CPUs
[    0.000000] PERCPU: Allocating 37992 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 2
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258000
[    0.000000] Kernel command line: root=/dev/hdb2 ro 8250.nr_uarts=10 quiet
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1666.659 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Memory: 1021100k/1040128k available (1770k kernel code, 18312k reserved, 750k data, 244k init, 122624k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.004000]       .init : 0xc037f000 - 0xc03bc000   ( 244 kB)
[    0.004000]       .data : 0xc02baaa1 - 0xc0376620   ( 750 kB)
[    0.004000]       .text : 0xc0100000 - 0xc02baaa1   (1770 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.084099] Calibrating delay using timer specific routine.. 3337.13 BogoMIPS (lpj=6674263)
[    0.084138] Security Framework initialized
[    0.084144] SELinux:  Disabled at boot.
[    0.084149] Capability LSM initialized
[    0.084164] Mount-cache hash table entries: 512
[    0.084310] Initializing cgroup subsys ns
[    0.084314] Initializing cgroup subsys cpuacct
[    0.084317] Initializing cgroup subsys devices
[    0.084335] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.084339] CPU: L2 cache: 2048K
[    0.084343] Intel machine check architecture supported.
[    0.084349] Intel machine check reporting enabled on CPU#0.
[    0.084351] using mwait in idle threads.
[    0.084360] Checking 'hlt' instruction... OK.
[    0.100419] SMP alternatives: switching to UP code
[    0.106246] ACPI: Core revision 20080321
[    0.120007] ENABLING IO-APIC IRQs
[    0.120007] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.160010] CPU0: Intel(R) Core(TM) Duo CPU      L2400  @ 1.66GHz stepping 0c
[    0.160010] Brought up 1 CPUs
[    0.160010] Total of 1 processors activated (3337.13 BogoMIPS).
[    0.160010] CPU0 attaching sched-domain:
[    0.160010]  domain 0: span 0
[    0.160010]   groups: 0
[    0.160010] net_namespace: 660 bytes
[    0.160010] Booting paravirtualized kernel on bare hardware
[    0.160010] NET: Registered protocol family 16
[    0.160010] ACPI: bus type pci registered
[    0.160010] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.160010] PCI: Not using MMCONFIG.
[    0.160010] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=1
[    0.160010] PCI: Using configuration type 1 for base access
[    0.160010] Setting up standard PCI resources
[    0.168010] ACPI: EC: Look up EC in DSDT
[    0.178065] ACPI: Interpreter enabled
[    0.178068] ACPI: (supports S0 S1 S3 S4 S5)
[    0.178085] ACPI: Using IOAPIC for interrupt routing
[    0.178152] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.185649] PCI: BIOS Bug: MCFG area at e0000000 is not reserved in ACPI motherboard resources
[    0.185704] PCI: Not using MMCONFIG.
[    0.195968] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.196647] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.196654] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.196659] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.197033] PCI: Transparent bridge - 0000:00:1e.0
[    0.197057] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.197315] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.207497] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.207646] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.207793] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.207939] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.208013] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.208160] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.208309] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.208454] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *6 7 10 11 12 14 15)
[    0.208673] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 48, should be 41 [20080321]
[    0.208698] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.208729] pnp: PnP ACPI init
[    0.208738] ACPI: bus type pnp registered
[    0.215303] pnp: PnP ACPI: found 17 devices
[    0.215306] ACPI: ACPI bus type pnp unregistered
[    0.215310] PnPBIOS: Disabled by ACPI PNP
[    0.215562] PCI: Using ACPI for IRQ routing
[    0.215619] PCI: Cannot allocate resource region 0 of device 0000:01:04.0
[    0.215890] hpet clockevent registered
[    0.215897] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.215902] hpet0: 3 64-bit timers, 14318180 Hz
[    0.216944] ACPI: RTC can wake from S4
[    0.216970] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.216980] system 00:09: ioport range 0xa00-0xa0f has been reserved
[    0.216990] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    0.216993] system 00:0b: ioport range 0x800-0x87f has been reserved
[    0.216996] system 00:0b: ioport range 0x480-0x4bf has been reserved
[    0.217000] system 00:0b: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.217003] system 00:0b: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.217006] system 00:0b: iomem range 0xfed40000-0xfed8ffff has been reserved
[    0.217013] system 00:0d: iomem range 0xffc00000-0xffefffff could not be reserved
[    0.217020] system 00:0e: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.217023] system 00:0e: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.217029] system 00:0f: iomem range 0xe0000000-0xe3ffffff has been reserved
[    0.217036] system 00:10: iomem range 0x0-0x9ffff could not be reserved
[    0.217039] system 00:10: iomem range 0xc0000-0xcffff could not be reserved
[    0.217042] system 00:10: iomem range 0xe0000-0xfffff could not be reserved
[    0.217045] system 00:10: iomem range 0x100000-0x3f7fffff could not be reserved
[    0.217049] system 00:10: iomem range 0xfed90000-0xffffffff could not be reserved
[    0.247436] PCI: Error while updating region 0000:01:04.0/0 (feb00002 != 00000000)
[    0.247489] PCI: Bridge: 0000:00:1e.0
[    0.247493]   IO window: e000-efff
[    0.247498]   MEM window: 0xfeb00000-0xfebfffff
[    0.247503]   PREFETCH window: disabled.
[    0.247520] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.247539] NET: Registered protocol family 2
[    0.247628] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.247859] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.248652] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.249054] TCP: Hash tables configured (established 131072 bind 65536)
[    0.249057] TCP reno registered
[    0.249169] NET: Registered protocol family 1
[    0.249290] checking if image is initramfs... it is
[    0.716035] Switched to high resolution mode on CPU 0
[    0.818306] Freeing initrd memory: 6040k freed
[    0.819062] audit: initializing netlink socket (disabled)
[    0.819079] type=2000 audit(1262505979.816:1): initialized
[    0.819232] highmem bounce pool size: 64 pages
[    0.819237] Total HugeTLB memory allocated, 0
[    0.819310] VFS: Disk quotas dquot_6.5.1
[    0.819339] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.819384] msgmni has been set to 1767
[    0.819489] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.819494] io scheduler noop registered
[    0.819496] io scheduler anticipatory registered
[    0.819498] io scheduler deadline registered
[    0.819509] io scheduler cfq registered (default)
[    0.819523] pci 0000:00:02.0: Boot video device
[    0.819621] pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
[    0.819941] isapnp: Scanning for PnP cards...
[    1.174338] isapnp: No Plug & Play device found
[    1.176903] Serial: 8250/16550 driver $Revision: 1.90 $ 10 ports, IRQ sharing enabled
[    1.177037] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.177166] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.177801] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.177984] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.179441] brd: module loaded
[    1.179592] PNP: No PS/2 controller found. Probing ports directly.
[    1.181887] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.181892] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.182034] mice: PS/2 mouse device common for all mice
[    1.182159] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.182179] rtc0: alarms up to one month
[    1.182214] cpuidle: using governor ladder
[    1.182217] cpuidle: using governor menu
[    1.182222] No iBFT detected.
[    1.182637] TCP cubic registered
[    1.182640] NET: Registered protocol family 17
[    1.182646] Using IPI No-Shortcut mode
[    1.182758] registered taskstats version 1
[    1.182889] rtc_cmos 00:03: setting system clock to 2010-01-03 08:06:20 UTC (1262505980)
[    1.183018] Freeing unused kernel memory: 244k freed
[    1.272162] ACPI: SSDT 3F7CE0C0, 0688 (r1    AMI   CPU1PM        1 INTL 20051117)
[    1.272769] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    1.272814] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.723884] usbcore: registered new interface driver usbfs
[    1.723912] usbcore: registered new interface driver hub
[    1.723944] usbcore: registered new device driver usb
[    1.732059] USB Universal Host Controller Interface driver v3.0
[    1.732108] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    1.732119] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    1.732123] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.732248] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    1.732283] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000dc00
[    1.732367] usb usb1: configuration #1 chosen from 1 choice
[    1.732399] hub 1-0:1.0: USB hub found
[    1.732406] hub 1-0:1.0: 2 ports detected
[    1.835739] Uniform Multi-Platform E-IDE driver
[    1.835745] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    1.836125] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    1.836129] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.836132] usb usb1: Product: UHCI Host Controller
[    1.836134] usb usb1: Manufacturer: Linux 2.6.26-2-686 uhci_hcd
[    1.836136] usb usb1: SerialNumber: 0000:00:1d.0
[    1.836205] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    1.836217] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    1.836221] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.836247] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[    1.836280] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d880
[    1.836355] usb usb2: configuration #1 chosen from 1 choice
[    1.836384] hub 2-0:1.0: USB hub found
[    1.836392] hub 2-0:1.0: 2 ports detected
[    1.850586] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[    1.850589] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.940109] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.940113] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.940116] usb usb2: Product: UHCI Host Controller
[    1.940118] usb usb2: Manufacturer: Linux 2.6.26-2-686 uhci_hcd
[    1.940121] usb usb2: SerialNumber: 0000:00:1d.1
[    1.940171] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    1.940182] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    1.940187] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.940218] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[    1.940251] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d800
[    1.940329] usb usb3: configuration #1 chosen from 1 choice
[    1.940357] hub 3-0:1.0: USB hub found
[    1.940363] hub 3-0:1.0: 2 ports detected
[    1.990370] Marking TSC unstable due to: TSC halts in idle.
[    2.044104] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.044107] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.044110] usb usb3: Product: UHCI Host Controller
[    2.044113] usb usb3: Manufacturer: Linux 2.6.26-2-686 uhci_hcd
[    2.044115] usb usb3: SerialNumber: 0000:00:1d.2
[    2.044166] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[    2.044175] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    2.044179] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.044201] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[    2.044233] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d480
[    2.044306] usb usb4: configuration #1 chosen from 1 choice
[    2.044335] hub 4-0:1.0: USB hub found
[    2.044341] hub 4-0:1.0: 2 ports detected
[    2.076027] usb 1-2: new low speed USB device using uhci_hcd and address 2
[    2.148091] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.148094] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.148097] usb usb4: Product: UHCI Host Controller
[    2.148099] usb usb4: Manufacturer: Linux 2.6.26-2-686 uhci_hcd
[    2.148102] usb usb4: SerialNumber: 0000:00:1d.3
[    2.148231] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    2.148247] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    2.148251] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.148275] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[    2.152182] ehci_hcd 0000:00:1d.7: debug port 1
[    2.152190] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    2.152195] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfea37c00
[    2.212025] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.212081] usb usb5: configuration #1 chosen from 1 choice
[    2.212108] hub 5-0:1.0: USB hub found
[    2.212114] hub 5-0:1.0: 8 ports detected
[    2.316093] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    2.316096] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.316099] usb usb5: Product: EHCI Host Controller
[    2.316101] usb usb5: Manufacturer: Linux 2.6.26-2-686 ehci_hcd
[    2.316104] usb usb5: SerialNumber: 0000:00:1d.7
[    2.318728] No dock devices found.
[    2.326910] SCSI subsystem initialized
[    2.336011] libata version 3.00 loaded.
[    2.336998] ACPI: PCI Interrupt 0000:01:08.0[A] -> GSI 20 (level, low) -> IRQ 20
[    2.363103] e100: eth0: e100_probe: addr 0xfebfe000, irq 20, MAC addr 00:30:59:04:25:2e
[    2.365334] ata_piix 0000:00:1f.2: version 2.12
[    2.365351] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[    2.365356] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    2.365391] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    2.365442] scsi0 : ata_piix
[    2.365517] scsi1 : ata_piix
[    2.365547] ata1: SATA max UDMA/133 cmd 0xd400 ctl 0xd080 bmdma 0xcc00 irq 19
[    2.365550] ata2: SATA max UDMA/133 cmd 0xd000 ctl 0xcc80 bmdma 0xcc08 irq 19
[    2.608024] usb 1-2: device not accepting address 2, error -71
[    2.664047] hub 1-0:1.0: unable to enumerate USB device on port 2
[    2.695202] ICH7: IDE controller (0x8086:0x27df rev 0x02) at  PCI slot 0000:00:1f.1
[    2.695214] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[    2.695224] ICH7: not 100% native mode: will probe irqs later
[    2.695233] ICH7: IDE port disabled
[    2.695240]     ide0: BM-DMA at 0xffa0-0xffa7
[    2.695247] Probing IDE interface ide0...
[    3.120330] usb 1-2: new low speed USB device using uhci_hcd and address 4
[    3.208387] hdb: SILICONSYSTEMS UDMA 4GB-4300, ATA DISK drive
[    3.264062] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    3.264109] hdb: host side 80-wire cable detection failed, limiting max speed to UDMA33
[    3.264112] hdb: UDMA/33 mode selected
[    3.264163] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    3.279613] hdb: max request size: 128KiB
[    3.279617] hdb: 8027712 sectors (4110 MB) w/1KiB Cache, CHS=7964/16/63
[    3.279896] hdb: cache flushes supported
[    3.279930]  hdb: hdb1 hdb2 hdb3 < hdb5 hdb6 hdb7 hdb8 hdb9 >
[    3.372380] usb 1-2: configuration #1 chosen from 1 choice
[    3.373684] PM: Starting manual resume from disk
[    3.378477] usb 1-2: New USB device found, idVendor=1241, idProduct=1603
[    3.378481] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.378484] usb 1-2: Product: USB Keyboard
[    3.378486] usb 1-2: Manufacturer:  
[    3.414683] usbcore: registered new interface driver hiddev
[    3.417555] kjournald starting.  Commit interval 5 seconds
[    3.417566] EXT3-fs: mounted filesystem with ordered data mode.
[    3.458143] input:   USB Keyboard as /class/input/input0
[    3.458143] input,hidraw0: USB HID v1.10 Keyboard [  USB Keyboard] on usb-0000:00:1d.0-2
[    3.543382] input:   USB Keyboard as /class/input/input1
[    3.552031] input,hidraw1: USB HID v1.10 Device [  USB Keyboard] on usb-0000:00:1d.0-2
[    3.552051] usbcore: registered new interface driver usbhid
[    3.552055] usbhid: v2.6:USB HID core driver
[    3.773202] udevd version 125 started
[    4.366743] Linux agpgart interface v0.103
[    4.375872] agpgart: Detected an Intel 945GME Chipset.
[    4.376229] agpgart: Detected 7932K stolen memory.
[    4.391529] agpgart: AGP aperture is 256M @ 0xd0000000
[    4.563115] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
[    4.563135] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    4.593853] hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
[    4.595122] input: Power Button (FF) as /class/input/input2
[    4.624054] ACPI: Power Button (FF) [PWRF]
[    4.624148] input: Power Button (CM) as /class/input/input3
[    4.652044] ACPI: Power Button (CM) [PWRB]
[    5.670043] intel_rng: FWH not detected
[    5.734423] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[    5.734496] iTCO_wdt: Found a ICH7-M DH TCO device (Version=2, TCOBASE=0x0860)
[    5.734524] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.740578] input: Video Bus as /class/input/input4
[    5.772049] ACPI: Video Device [IGD] (multi-head: yes  rom: no  post: no)
[    5.901055] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
[    6.011232] input: PC Speaker as /class/input/input5
[    6.048672] Error: Driver 'pcspkr' is already registered, aborting...
[    6.299792] parport_pc 00:08: reported by Plug and Play ACPI
[    6.299845] parport0: PC-style at 0x378, irq 7 [PCSPP]
[    6.974349] Adding 489940k swap on /dev/hdb8.  Priority:-1 extents:1 across:489940k
[    7.847947] loop: module loaded
[    7.861361] ppdev: user-space parallel port driver
[    8.218580] kjournald starting.  Commit interval 5 seconds
[    8.218589] EXT3-fs: mounted filesystem with ordered data mode.
[    8.219908] kjournald starting.  Commit interval 5 seconds
[    8.242677] EXT3 FS on hdb6, internal journal
[    8.242681] EXT3-fs: mounted filesystem with ordered data mode.
[    8.243566] kjournald starting.  Commit interval 5 seconds
[    8.285475] EXT3 FS on hdb7, internal journal
[    8.285475] EXT3-fs: mounted filesystem with ordered data mode.
[    8.286626] kjournald starting.  Commit interval 5 seconds
[    8.286626] EXT3-fs: mounted filesystem with ordered data mode.
[    8.287131] kjournald starting.  Commit interval 5 seconds
[    8.302911] EXT3 FS on hdb5, internal journal
[    8.302911] EXT3-fs: mounted filesystem with ordered data mode.
[    9.346890] NET: Registered protocol family 10
[    9.347300] lo: Disabled Privacy Extensions
[    9.424398] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
[   96.685169] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   96.688130] e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
[   96.688492] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  107.232020] eth0: no IPv6 routers present

--Boundary-00=_KPwQLpwlB5LmXmq
Content-Type: text/plain;
  charset="iso 8859-15";
  name="dmesg_working.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_working.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.26-2-686 (Debian 2.6.26-19lenny2) (dannf@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-25)) #1 SMP Wed Nov 4 20:45:37 UTC 2009
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f7c0000 (usable)
[    0.000000]  BIOS-e820: 000000003f7c0000 - 000000003f7ce000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003f7ce000 - 000000003f800000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] 119MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at [c00ff780] 000ff780
[    0.000000] Entering add_active_range(0, 0, 260032) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   260032
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   260032
[    0.000000] On node 0 totalpages: 260032
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 240 pages used for memmap
[    0.000000]   HighMem zone: 30416 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F8ED0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 3F7C0000, 003C (r1 112007 RSDT1407 20071120 MSFT       97)
[    0.000000] ACPI: FACP 3F7C0200, 0084 (r2 112007 FACP1407 20071120 MSFT       97)
[    0.000000] ACPI: DSDT 3F7C05B0, 4FF8 (r1  DLAG_ DLAG_117      117 INTL 20051117)
[    0.000000] ACPI: FACS 3F7CE000, 0040
[    0.000000] ACPI: APIC 3F7C0390, 005C (r1 112007 APIC1407 20071120 MSFT       97)
[    0.000000] ACPI: MCFG 3F7C03F0, 003C (r1 112007 OEMMCFG  20071120 MSFT       97)
[    0.000000] ACPI: SLIC 3F7C0430, 0176 (r1 112007 SLIC1407 20071120 MSFT       97)
[    0.000000] ACPI: OEMB 3F7CE040, 0071 (r1 112007 OEMB1407 20071120 MSFT       97)
[    0.000000] ACPI: ASF! 3F7C55B0, 0075 (r32 LEGEND I865PASF        1 INTL 20051117)
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 3f800000:bf600000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] SMP: Allowing 2 CPUs, 1 hotplug CPUs
[    0.000000] PERCPU: Allocating 37992 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 2
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258000
[    0.000000] Kernel command line: root=/dev/hdb2 ro 8250.nr_uarts=10 quiet
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1666.746 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Memory: 1021100k/1040128k available (1770k kernel code, 18312k reserved, 750k data, 244k init, 122624k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.004000]       .init : 0xc037f000 - 0xc03bc000   ( 244 kB)
[    0.004000]       .data : 0xc02baaa1 - 0xc0376620   ( 750 kB)
[    0.004000]       .text : 0xc0100000 - 0xc02baaa1   (1770 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.084100] Calibrating delay using timer specific routine.. 3337.12 BogoMIPS (lpj=6674246)
[    0.084138] Security Framework initialized
[    0.084144] SELinux:  Disabled at boot.
[    0.084148] Capability LSM initialized
[    0.084165] Mount-cache hash table entries: 512
[    0.084306] Initializing cgroup subsys ns
[    0.084312] Initializing cgroup subsys cpuacct
[    0.084315] Initializing cgroup subsys devices
[    0.084333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.084337] CPU: L2 cache: 2048K
[    0.084341] Intel machine check architecture supported.
[    0.084347] Intel machine check reporting enabled on CPU#0.
[    0.084350] using mwait in idle threads.
[    0.084358] Checking 'hlt' instruction... OK.
[    0.100420] SMP alternatives: switching to UP code
[    0.106268] ACPI: Core revision 20080321
[    0.120007] ENABLING IO-APIC IRQs
[    0.120007] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.159714] CPU0: Intel(R) Core(TM) Duo CPU      L2400  @ 1.66GHz stepping 0c
[    0.160010] Brought up 1 CPUs
[    0.160010] Total of 1 processors activated (3337.12 BogoMIPS).
[    0.160010] CPU0 attaching sched-domain:
[    0.160010]  domain 0: span 0
[    0.160010]   groups: 0
[    0.160010] net_namespace: 660 bytes
[    0.160010] Booting paravirtualized kernel on bare hardware
[    0.160010] NET: Registered protocol family 16
[    0.160010] ACPI: bus type pci registered
[    0.160010] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.160010] PCI: Not using MMCONFIG.
[    0.160010] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=1
[    0.160010] PCI: Using configuration type 1 for base access
[    0.160010] Setting up standard PCI resources
[    0.168010] ACPI: EC: Look up EC in DSDT
[    0.178097] ACPI: Interpreter enabled
[    0.178100] ACPI: (supports S0 S1 S3 S4 S5)
[    0.178117] ACPI: Using IOAPIC for interrupt routing
[    0.178184] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.185656] PCI: BIOS Bug: MCFG area at e0000000 is not reserved in ACPI motherboard resources
[    0.185711] PCI: Not using MMCONFIG.
[    0.195955] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.196636] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.196642] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.196647] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.197010] PCI: Transparent bridge - 0000:00:1e.0
[    0.197035] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.197293] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.207476] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.207624] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.207770] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.207914] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.208013] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.208013] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.208162] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.208307] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *6 7 10 11 12 14 15)
[    0.208521] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 48, should be 41 [20080321]
[    0.208545] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.208576] pnp: PnP ACPI init
[    0.208584] ACPI: bus type pnp registered
[    0.215142] pnp: PnP ACPI: found 17 devices
[    0.215145] ACPI: ACPI bus type pnp unregistered
[    0.215149] PnPBIOS: Disabled by ACPI PNP
[    0.215400] PCI: Using ACPI for IRQ routing
[    0.215677] hpet clockevent registered
[    0.215683] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.215688] hpet0: 3 64-bit timers, 14318180 Hz
[    0.216731] ACPI: RTC can wake from S4
[    0.216758] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.216768] system 00:09: ioport range 0xa00-0xa0f has been reserved
[    0.216777] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    0.216781] system 00:0b: ioport range 0x800-0x87f has been reserved
[    0.216784] system 00:0b: ioport range 0x480-0x4bf has been reserved
[    0.216787] system 00:0b: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.216791] system 00:0b: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.216794] system 00:0b: iomem range 0xfed40000-0xfed8ffff has been reserved
[    0.216801] system 00:0d: iomem range 0xffc00000-0xffefffff could not be reserved
[    0.216807] system 00:0e: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.216811] system 00:0e: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.216817] system 00:0f: iomem range 0xe0000000-0xe3ffffff has been reserved
[    0.216823] system 00:10: iomem range 0x0-0x9ffff could not be reserved
[    0.216827] system 00:10: iomem range 0xc0000-0xcffff could not be reserved
[    0.216830] system 00:10: iomem range 0xe0000-0xfffff could not be reserved
[    0.216833] system 00:10: iomem range 0x100000-0x3f7fffff could not be reserved
[    0.216837] system 00:10: iomem range 0xfed90000-0xffffffff could not be reserved
[    0.247235] PCI: Bridge: 0000:00:1e.0
[    0.247239]   IO window: e000-efff
[    0.247245]   MEM window: 0xfeb00000-0xfebfffff
[    0.247249]   PREFETCH window: disabled.
[    0.247267] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.247288] NET: Registered protocol family 2
[    0.247378] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.247612] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.248410] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.248809] TCP: Hash tables configured (established 131072 bind 65536)
[    0.248814] TCP reno registered
[    0.248924] NET: Registered protocol family 1
[    0.249046] checking if image is initramfs... it is
[    0.716009] Switched to high resolution mode on CPU 0
[    0.817665] Freeing initrd memory: 6040k freed
[    0.818424] audit: initializing netlink socket (disabled)
[    0.818440] type=2000 audit(1262506709.816:1): initialized
[    0.818596] highmem bounce pool size: 64 pages
[    0.818601] Total HugeTLB memory allocated, 0
[    0.818674] VFS: Disk quotas dquot_6.5.1
[    0.818702] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.818747] msgmni has been set to 1767
[    0.818851] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.818855] io scheduler noop registered
[    0.818857] io scheduler anticipatory registered
[    0.818859] io scheduler deadline registered
[    0.818871] io scheduler cfq registered (default)
[    0.818885] pci 0000:00:02.0: Boot video device
[    0.818982] pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
[    0.819300] isapnp: Scanning for PnP cards...
[    1.173668] isapnp: No Plug & Play device found
[    1.176248] Serial: 8250/16550 driver $Revision: 1.90 $ 10 ports, IRQ sharing enabled
[    1.176382] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.176509] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.177145] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.177327] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.177458] ACPI: PCI Interrupt 0000:01:04.0[A] -> GSI 20 (level, low) -> IRQ 20
[    1.177536] 0000:01:04.0: ttyS4 at MMIO 0xfebff000 (irq = 20) is a 16550A
[    1.177645] 0000:01:04.0: ttyS5 at MMIO 0xfebff200 (irq = 20) is a 16550A
[    1.177752] 0000:01:04.0: ttyS6 at MMIO 0xfebff400 (irq = 20) is a 16550A
[    1.177858] 0000:01:04.0: ttyS7 at MMIO 0xfebff600 (irq = 20) is a 16550A
[    1.177964] 0000:01:04.0: ttyS8 at MMIO 0xfebff800 (irq = 20) is a 16550A
[    1.178070] 0000:01:04.0: ttyS9 at MMIO 0xfebffa00 (irq = 20) is a 16550A
[    1.178177] 0000:01:04.0: ttyS2 at MMIO 0xfebffc00 (irq = 20) is a 16550A
[    1.178282] 0000:01:04.0: ttyS3 at MMIO 0xfebffe00 (irq = 20) is a 16550A
[    1.179659] brd: module loaded
[    1.179804] PNP: No PS/2 controller found. Probing ports directly.
[    1.182118] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.182123] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.182261] mice: PS/2 mouse device common for all mice
[    1.182387] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.182406] rtc0: alarms up to one month
[    1.182443] cpuidle: using governor ladder
[    1.182445] cpuidle: using governor menu
[    1.182450] No iBFT detected.
[    1.182866] TCP cubic registered
[    1.182869] NET: Registered protocol family 17
[    1.182876] Using IPI No-Shortcut mode
[    1.182988] registered taskstats version 1
[    1.183115] rtc_cmos 00:03: setting system clock to 2010-01-03 08:18:30 UTC (1262506710)
[    1.183242] Freeing unused kernel memory: 244k freed
[    1.272398] ACPI: SSDT 3F7CE0C0, 0688 (r1    AMI   CPU1PM        1 INTL 20051117)
[    1.273002] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    1.273046] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.739819] usbcore: registered new interface driver usbfs
[    1.739847] usbcore: registered new interface driver hub
[    1.739880] usbcore: registered new device driver usb
[    1.741034] USB Universal Host Controller Interface driver v3.0
[    1.741083] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    1.741094] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    1.741098] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.741227] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    1.741263] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000dc00
[    1.741346] usb usb1: configuration #1 chosen from 1 choice
[    1.741377] hub 1-0:1.0: USB hub found
[    1.741384] hub 1-0:1.0: 2 ports detected
[    1.819850] Uniform Multi-Platform E-IDE driver
[    1.819855] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    1.837757] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[    1.837760] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.844115] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    1.844119] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.844122] usb usb1: Product: UHCI Host Controller
[    1.844124] usb usb1: Manufacturer: Linux 2.6.26-2-686 uhci_hcd
[    1.844127] usb usb1: SerialNumber: 0000:00:1d.0
[    1.844203] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    1.844214] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    1.844219] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.844243] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[    1.844278] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d880
[    1.844355] usb usb2: configuration #1 chosen from 1 choice
[    1.844383] hub 2-0:1.0: USB hub found
[    1.844389] hub 2-0:1.0: 2 ports detected
[    1.948109] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.948113] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.948117] usb usb2: Product: UHCI Host Controller
[    1.948119] usb usb2: Manufacturer: Linux 2.6.26-2-686 uhci_hcd
[    1.948121] usb usb2: SerialNumber: 0000:00:1d.1
[    1.948176] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    1.948186] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    1.948191] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.948214] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[    1.948249] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d800
[    1.948325] usb usb3: configuration #1 chosen from 1 choice
[    1.948353] hub 3-0:1.0: USB hub found
[    1.948360] hub 3-0:1.0: 2 ports detected
[    1.976002] Marking TSC unstable due to: TSC halts in idle.
[    2.055866] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.055870] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.055873] usb usb3: Product: UHCI Host Controller
[    2.055875] usb usb3: Manufacturer: Linux 2.6.26-2-686 uhci_hcd
[    2.055877] usb usb3: SerialNumber: 0000:00:1d.2
[    2.055923] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[    2.055932] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    2.055936] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.055958] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[    2.055987] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d480
[    2.056014] usb usb4: configuration #1 chosen from 1 choice
[    2.056014] hub 4-0:1.0: USB hub found
[    2.056014] hub 4-0:1.0: 2 ports detected
[    2.086974] usb 1-2: new low speed USB device using uhci_hcd and address 2
[    2.158814] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.158818] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.158821] usb usb4: Product: UHCI Host Controller
[    2.158823] usb usb4: Manufacturer: Linux 2.6.26-2-686 uhci_hcd
[    2.158825] usb usb4: SerialNumber: 0000:00:1d.3
[    2.158956] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    2.158970] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    2.158974] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.158996] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[    2.162913] ehci_hcd 0000:00:1d.7: debug port 1
[    2.162922] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    2.162927] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfea37c00
[    2.220024] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.220079] usb usb5: configuration #1 chosen from 1 choice
[    2.220106] hub 5-0:1.0: USB hub found
[    2.220112] hub 5-0:1.0: 8 ports detected
[    2.324093] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    2.324096] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.324099] usb usb5: Product: EHCI Host Controller
[    2.324102] usb usb5: Manufacturer: Linux 2.6.26-2-686 ehci_hcd
[    2.324104] usb usb5: SerialNumber: 0000:00:1d.7
[    2.326736] No dock devices found.
[    2.334908] SCSI subsystem initialized
[    2.344019] libata version 3.00 loaded.
[    2.345016] ACPI: PCI Interrupt 0000:01:08.0[A] -> GSI 20 (level, low) -> IRQ 20
[    2.370303] e100: eth0: e100_probe: addr 0xfebfe000, irq 20, MAC addr 00:30:59:04:25:2e
[    2.372518] ata_piix 0000:00:1f.2: version 2.12
[    2.372535] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[    2.372541] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    2.372576] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    2.372629] scsi0 : ata_piix
[    2.372707] scsi1 : ata_piix
[    2.372737] ata1: SATA max UDMA/133 cmd 0xd400 ctl 0xd080 bmdma 0xcc00 irq 19
[    2.372740] ata2: SATA max UDMA/133 cmd 0xd000 ctl 0xcc80 bmdma 0xcc08 irq 19
[    2.617863] usb 1-2: device not accepting address 2, error -71
[    2.673787] hub 1-0:1.0: unable to enumerate USB device on port 2
[    2.703054] ICH7: IDE controller (0x8086:0x27df rev 0x02) at  PCI slot 0000:00:1f.1
[    2.703065] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[    2.703074] ICH7: not 100% native mode: will probe irqs later
[    2.703084] ICH7: IDE port disabled
[    2.703092]     ide0: BM-DMA at 0xffa0-0xffa7
[    2.703098] Probing IDE interface ide0...
[    3.120023] usb 1-2: new low speed USB device using uhci_hcd and address 4
[    3.216283] hdb: SILICONSYSTEMS UDMA 4GB-4300, ATA DISK drive
[    3.272061] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    3.272109] hdb: host side 80-wire cable detection failed, limiting max speed to UDMA33
[    3.272112] hdb: UDMA/33 mode selected
[    3.272163] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    3.287664] hdb: max request size: 128KiB
[    3.287668] hdb: 8027712 sectors (4110 MB) w/1KiB Cache, CHS=7964/16/63
[    3.287953] hdb: cache flushes supported
[    3.287987]  hdb: hdb1 hdb2 hdb3 < hdb5 hdb6 hdb7 hdb8 hdb9 >
[    3.371351] usb 1-2: configuration #1 chosen from 1 choice
[    3.372503] PM: Starting manual resume from disk
[    3.377441] usb 1-2: New USB device found, idVendor=1241, idProduct=1603
[    3.377445] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.377448] usb 1-2: Product: USB Keyboard
[    3.377450] usb 1-2: Manufacturer:  
[    3.409452] usbcore: registered new interface driver hiddev
[    3.409971] kjournald starting.  Commit interval 5 seconds
[    3.409981] EXT3-fs: mounted filesystem with ordered data mode.
[    3.453644] input:   USB Keyboard as /class/input/input0
[    3.453691] input,hidraw0: USB HID v1.10 Keyboard [  USB Keyboard] on usb-0000:00:1d.0-2
[    3.539354] input:   USB Keyboard as /class/input/input1
[    3.548033] input,hidraw1: USB HID v1.10 Device [  USB Keyboard] on usb-0000:00:1d.0-2
[    3.548052] usbcore: registered new interface driver usbhid
[    3.548056] usbhid: v2.6:USB HID core driver
[    3.769097] udevd version 125 started
[    4.358662] Linux agpgart interface v0.103
[    4.367501] agpgart: Detected an Intel 945GME Chipset.
[    4.367836] agpgart: Detected 7932K stolen memory.
[    4.382966] agpgart: AGP aperture is 256M @ 0xd0000000
[    4.527944] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
[    4.527964] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    4.557848] hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
[    4.585865] input: Power Button (FF) as /class/input/input2
[    4.612654] ACPI: Power Button (FF) [PWRF]
[    4.612745] input: Power Button (CM) as /class/input/input3
[    4.644048] ACPI: Power Button (CM) [PWRB]
[    5.710031] intel_rng: FWH not detected
[    5.740592] input: Video Bus as /class/input/input4
[    5.764040] ACPI: Video Device [IGD] (multi-head: yes  rom: no  post: no)
[    5.782541] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[    5.782613] iTCO_wdt: Found a ICH7-M DH TCO device (Version=2, TCOBASE=0x0860)
[    5.782642] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.880861] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
[    5.953481] input: PC Speaker as /class/input/input5
[    5.975940] Error: Driver 'pcspkr' is already registered, aborting...
[    6.056711] Error: Driver 'pcspkr' is already registered, aborting...
[    6.250035] parport_pc 00:08: reported by Plug and Play ACPI
[    6.250087] parport0: PC-style at 0x378, irq 7 [PCSPP]
[    6.922157] Adding 489940k swap on /dev/hdb8.  Priority:-1 extents:1 across:489940k
[    7.838259] loop: module loaded
[    7.851772] ppdev: user-space parallel port driver
[    8.350401] kjournald starting.  Commit interval 5 seconds
[    8.350411] EXT3-fs: mounted filesystem with ordered data mode.
[    8.351728] kjournald starting.  Commit interval 5 seconds
[    8.374635] EXT3 FS on hdb6, internal journal
[    8.374639] EXT3-fs: mounted filesystem with ordered data mode.
[    8.375522] kjournald starting.  Commit interval 5 seconds
[    8.417212] EXT3 FS on hdb7, internal journal
[    8.417212] EXT3-fs: mounted filesystem with ordered data mode.
[    8.418360] kjournald starting.  Commit interval 5 seconds
[    8.418360] EXT3-fs: mounted filesystem with ordered data mode.
[    8.418863] kjournald starting.  Commit interval 5 seconds
[    8.434795] EXT3 FS on hdb5, internal journal
[    8.434795] EXT3-fs: mounted filesystem with ordered data mode.
[    9.485855] NET: Registered protocol family 10
[    9.486264] lo: Disabled Privacy Extensions
[    9.558863] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
[   21.053169] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   21.056131] e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
[   21.056478] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   32.048028] eth0: no IPv6 routers present

--Boundary-00=_KPwQLpwlB5LmXmq
Content-Type: text/plain;
  charset="iso 8859-15";
  name="lspci_broken.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci_broken.txt"

00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GHM (ICH7-M DH) LPC Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
01:04.0 Unclassified device [0080]: Device 0002:0080
01:08.0 Ethernet controller: Intel Corporation PRO/100 VM Network Connection (rev 01)

--Boundary-00=_KPwQLpwlB5LmXmq
Content-Type: text/plain;
  charset="iso 8859-15";
  name="lspci_working.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci_working.txt"

00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GHM (ICH7-M DH) LPC Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
01:04.0 Serial controller: Exar Corp. XR17C158 Octal UART (rev 09)
01:08.0 Ethernet controller: Intel Corporation PRO/100 VM Network Connection (rev 01)

--Boundary-00=_KPwQLpwlB5LmXmq
Content-Type: text/plain;
  charset="iso 8859-15";
  name="lspci_v_broken.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci_v_broken.txt"

00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
	Subsystem: Intel Corporation Mobile 945GME Express Memory Controller Hub
	Flags: bus master, fast devsel, latency 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
	Subsystem: Intel Corporation Mobile 945GME Express Integrated Graphics Controller
	Flags: bus master, fast devsel, latency 0, IRQ 15
	Memory at fea80000 (32-bit, non-prefetchable) [size=512K]
	I/O ports at dc80 [size=8]
	Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Memory at fea40000 (32-bit, non-prefetchable) [size=256K]
	Capabilities: <access denied>

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
	Subsystem: Intel Corporation Device 27ae
	Flags: bus master, fast devsel, latency 0
	Memory at fe980000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: <access denied>

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at fea38000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1
	Flags: bus master, medium devsel, latency 0, IRQ 23
	I/O ports at dc00 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at d880 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at d800 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at d480 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02) (prog-if 20 [EHCI])
	Subsystem: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at fea37c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: feb00000-febfffff
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation 82801GHM (ICH7-M DH) LPC Interface Bridge (rev 02)
	Subsystem: Intel Corporation 82801GHM (ICH7-M DH) LPC Interface Bridge
	Flags: bus master, medium devsel, latency 0
	Capabilities: <access denied>
	Kernel modules: iTCO_wdt, intel-rng

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Intel Corporation 82801G (ICH7 Family) IDE Controller
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at ffa0 [size=16]
	Kernel driver in use: PIIX_IDE
	Kernel modules: piix

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
	I/O ports at d400 [size=8]
	I/O ports at d080 [size=4]
	I/O ports at d000 [size=8]
	I/O ports at cc80 [size=4]
	I/O ports at cc00 [size=16]
	Memory at fea37800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ata_piix
	Kernel modules: ata_piix

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
	Subsystem: Intel Corporation 82801G (ICH7 Family) SMBus Controller
	Flags: medium devsel, IRQ 19
	I/O ports at 0400 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801

01:04.0 Unclassified device [0080]: Device 0002:0080
	Flags: fast devsel
	[virtual] Memory at feb00000 (32-bit, non-prefetchable) [disabled] [size=4K]

01:08.0 Ethernet controller: Intel Corporation PRO/100 VM Network Connection (rev 01)
	Subsystem: Intel Corporation Device 0001
	Flags: bus master, medium devsel, latency 64, IRQ 20
	Memory at febfe000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at ec80 [size=64]
	Capabilities: <access denied>
	Kernel driver in use: e100
	Kernel modules: e100


--Boundary-00=_KPwQLpwlB5LmXmq
Content-Type: text/plain;
  charset="iso 8859-15";
  name="lspci_v_working.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci_v_working.txt"

00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
	Subsystem: Intel Corporation Mobile 945GME Express Memory Controller Hub
	Flags: bus master, fast devsel, latency 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
	Subsystem: Intel Corporation Mobile 945GME Express Integrated Graphics Controller
	Flags: bus master, fast devsel, latency 0, IRQ 15
	Memory at fea80000 (32-bit, non-prefetchable) [size=512K]
	I/O ports at dc80 [size=8]
	Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Memory at fea40000 (32-bit, non-prefetchable) [size=256K]
	Capabilities: <access denied>

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
	Subsystem: Intel Corporation Device 27ae
	Flags: bus master, fast devsel, latency 0
	Memory at fe980000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: <access denied>

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at fea38000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1
	Flags: bus master, medium devsel, latency 0, IRQ 23
	I/O ports at dc00 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at d880 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at d800 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at d480 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02) (prog-if 20 [EHCI])
	Subsystem: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at fea37c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: feb00000-febfffff
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation 82801GHM (ICH7-M DH) LPC Interface Bridge (rev 02)
	Subsystem: Intel Corporation 82801GHM (ICH7-M DH) LPC Interface Bridge
	Flags: bus master, medium devsel, latency 0
	Capabilities: <access denied>
	Kernel modules: iTCO_wdt, intel-rng

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Intel Corporation 82801G (ICH7 Family) IDE Controller
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at ffa0 [size=16]
	Kernel driver in use: PIIX_IDE
	Kernel modules: piix

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
	I/O ports at d400 [size=8]
	I/O ports at d080 [size=4]
	I/O ports at d000 [size=8]
	I/O ports at cc80 [size=4]
	I/O ports at cc00 [size=16]
	Memory at fea37800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ata_piix
	Kernel modules: ata_piix

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
	Subsystem: Intel Corporation 82801G (ICH7 Family) SMBus Controller
	Flags: medium devsel, IRQ 19
	I/O ports at 0400 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801

01:04.0 Serial controller: Exar Corp. XR17C158 Octal UART (rev 09) (prog-if 02 [16550])
	Flags: fast devsel, IRQ 20
	Memory at febff000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: serial

01:08.0 Ethernet controller: Intel Corporation PRO/100 VM Network Connection (rev 01)
	Subsystem: Intel Corporation Device 0001
	Flags: bus master, medium devsel, latency 64, IRQ 20
	Memory at febfe000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at ec80 [size=64]
	Capabilities: <access denied>
	Kernel driver in use: e100
	Kernel modules: e100


--Boundary-00=_KPwQLpwlB5LmXmq
Content-Type: text/plain;
  charset="iso 8859-15";
  name="proc_iomem_broken.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="proc_iomem_broken.txt"

00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cf000-000d07ff : Adapter ROM
000d0800-000d17ff : Adapter ROM
000f0000-000fffff : System ROM
00100000-3f7bffff : System RAM
  00100000-002baaa0 : Kernel code
  002baaa1-0037661f : Kernel data
  003bc000-0041f57f : Kernel bss
3f7c0000-3f7cdfff : ACPI Tables
3f7ce000-3f7fffff : ACPI Non-volatile Storage
d0000000-dfffffff : 0000:00:02.0
e0000000-e3ffffff : pnp 00:0f
fe980000-fe9fffff : 0000:00:02.1
fea37800-fea37bff : 0000:00:1f.2
fea37c00-fea37fff : 0000:00:1d.7
  fea37c00-fea37fff : ehci_hcd
fea38000-fea3bfff : 0000:00:1b.0
  fea38000-fea3bfff : ICH HD audio
fea40000-fea7ffff : 0000:00:02.0
fea80000-feafffff : 0000:00:02.0
feb00000-febfffff : PCI Bus 0000:01
  feb00000-feb00fff : 0000:01:04.0
  febfe000-febfefff : 0000:01:08.0
    febfe000-febfefff : e100
fec00000-fec00fff : pnp 00:0e
fed13000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:0b
fed20000-fed3ffff : pnp 00:0b
fed40000-fed8ffff : pnp 00:0b
fee00000-fee00fff : reserved
ffb00000-ffffffff : reserved

--Boundary-00=_KPwQLpwlB5LmXmq
Content-Type: text/plain;
  charset="iso 8859-15";
  name="proc_iomem_working.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="proc_iomem_working.txt"

00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cf000-000d07ff : Adapter ROM
000d0800-000d17ff : Adapter ROM
000f0000-000fffff : System ROM
00100000-3f7bffff : System RAM
  00100000-002baaa0 : Kernel code
  002baaa1-0037661f : Kernel data
  003bc000-0041f57f : Kernel bss
3f7c0000-3f7cdfff : ACPI Tables
3f7ce000-3f7fffff : ACPI Non-volatile Storage
d0000000-dfffffff : 0000:00:02.0
e0000000-e3ffffff : pnp 00:0f
fe980000-fe9fffff : 0000:00:02.1
fea37800-fea37bff : 0000:00:1f.2
fea37c00-fea37fff : 0000:00:1d.7
  fea37c00-fea37fff : ehci_hcd
fea38000-fea3bfff : 0000:00:1b.0
  fea38000-fea3bfff : ICH HD audio
fea40000-fea7ffff : 0000:00:02.0
fea80000-feafffff : 0000:00:02.0
feb00000-febfffff : PCI Bus 0000:01
  febfe000-febfefff : 0000:01:08.0
    febfe000-febfefff : e100
  febff000-febfffff : 0000:01:04.0
    febff000-febff007 : serial
    febff200-febff207 : serial
    febff400-febff407 : serial
    febff600-febff607 : serial
    febff800-febff807 : serial
    febffa00-febffa07 : serial
    febffc00-febffc07 : serial
    febffe00-febffe07 : serial
fec00000-fec00fff : pnp 00:0e
fed13000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:0b
fed20000-fed3ffff : pnp 00:0b
fed40000-fed8ffff : pnp 00:0b
fee00000-fee00fff : reserved
ffb00000-ffffffff : reserved

--Boundary-00=_KPwQLpwlB5LmXmq--
