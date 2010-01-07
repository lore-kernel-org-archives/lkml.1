Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521Ab0AGBKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0AGBKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153Ab0AGBK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:10:29 -0500
Received: from pc-249.acfr.usyd.edu.au ([129.78.210.249]:55501 "EHLO
	rosaceae.acfr.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab0AGBK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:10:27 -0500
From: Alex Brooks <a.brooks@marathon-robotics.com>
Organization: Marathon Robotics
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: BAR 0: can't allocate resource
Date: Thu, 7 Jan 2010 12:09:01 +1100
User-Agent: KMail/1.9.9
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001061305.31635.a.brooks@marathon-robotics.com> <201001061316.21744.a.brooks@marathon-robotics.com> <201001061319.54436.bjorn.helgaas@hp.com>
In-Reply-To: <201001061319.54436.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tQTRLKnn02lT+Nh"
Message-Id: <201001071209.01975.a.brooks@marathon-robotics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_tQTRLKnn02lT+Nh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> You mentioned two messages.  Here's the first:
>   PCI: BIOS Bug: MCFG area at e0000000 is not reserved in ACPI motherboard
> resources PCI: Not using MMCONFIG.
>
> and the second:
>   PCI: Cannot allocate resource region 0 of device 0000:01:04.0
>   PCI: Error while updating region 0000:01:04.0/0 (feb00002 != 00000000)
>
> The "Error while updating region" message is because we wrote something
> to a BAR, read it back, and they didn't match.  I suppose this could be
> some kind of config space problem related to the fact that we're not
> using MMCONFIG.
>
> Can you try removing the MCFG reservation check, so we do try to use
> MMCONFIG?  If you do this on a current kernel, we'll also get a little
> more debug output about the subsequent resource allocation failure.

I did this on my 2.6.26 kernel (is this current enough or would a later kernel 
be better?) and attached the dmesg output.

Alex

--Boundary-00=_tQTRLKnn02lT+Nh
Content-Type: text/plain;
  charset="iso 8859-15";
  name="dmesg_mmconfig.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_mmconfig.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.26-custom (2.6.26) (root@moss) (gcc version 4.3.3 (Debian 4.3.3-3) ) #1 SMP Thu Jan 7 11:23:54 EST 2010
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
[    0.000000] PERCPU: Allocating 37576 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 2
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258000
[    0.000000] Kernel command line: root=/dev/hdb2 ro 8250.nr_uarts=10 quiet
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1666.687 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Memory: 1021624k/1040128k available (1791k kernel code, 17740k reserved, 725k data, 248k init, 122624k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.004000]       .init : 0xc037d000 - 0xc03bb000   ( 248 kB)
[    0.004000]       .data : 0xc02bfd70 - 0xc0375418   ( 725 kB)
[    0.004000]       .text : 0xc0100000 - 0xc02bfd70   (1791 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.084101] Calibrating delay using timer specific routine.. 3337.10 BogoMIPS (lpj=6674206)
[    0.084138] Security Framework initialized
[    0.084144] SELinux:  Disabled at boot.
[    0.084148] Capability LSM initialized
[    0.084163] Mount-cache hash table entries: 512
[    0.084302] Initializing cgroup subsys ns
[    0.084306] Initializing cgroup subsys cpuacct
[    0.084309] Initializing cgroup subsys devices
[    0.084328] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.084331] CPU: L2 cache: 2048K
[    0.084335] Intel machine check architecture supported.
[    0.084341] Intel machine check reporting enabled on CPU#0.
[    0.084343] using mwait in idle threads.
[    0.084352] Checking 'hlt' instruction... OK.
[    0.100449] SMP alternatives: switching to UP code
[    0.106103] ACPI: Core revision 20080321
[    0.120007] ENABLING IO-APIC IRQs
[    0.120007] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.159715] CPU0: Intel(R) Core(TM) Duo CPU      L2400  @ 1.66GHz stepping 0c
[    0.160010] Brought up 1 CPUs
[    0.160010] Total of 1 processors activated (3337.10 BogoMIPS).
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
[    0.178108] ACPI: Interpreter enabled
[    0.178111] ACPI: (supports S0 S1 S3 S4 S5)
[    0.178128] ACPI: Using IOAPIC for interrupt routing
[    0.178193] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.185680] AlexB: ignoring error and continuing: PCI: BIOS Bug: MCFG area at e0000000 is not reserved in ACPI motherboard resources
[    0.185684] PCI: Using MMCONFIG for extended config space
[    0.196164] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.196841] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.196847] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.196852] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.197225] PCI: Transparent bridge - 0000:00:1e.0
[    0.197248] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.197507] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.207695] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.207842] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.207989] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.208139] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.208284] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.208428] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.208576] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.208724] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *6 7 10 11 12 14 15)
[    0.208942] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 48, should be 41 [20080321]
[    0.208966] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.208997] pnp: PnP ACPI init
[    0.209005] ACPI: bus type pnp registered
[    0.215537] pnp: PnP ACPI: found 17 devices
[    0.215540] ACPI: ACPI bus type pnp unregistered
[    0.215543] PnPBIOS: Disabled by ACPI PNP
[    0.215788] PCI: Using ACPI for IRQ routing
[    0.215844] PCI: Cannot allocate resource region 0 of device 0000:01:04.0
[    0.216114] hpet clockevent registered
[    0.216120] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.216125] hpet0: 3 64-bit timers, 14318180 Hz
[    0.217165] ACPI: RTC can wake from S4
[    0.217190] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.217200] system 00:09: ioport range 0xa00-0xa0f has been reserved
[    0.217209] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    0.217213] system 00:0b: ioport range 0x800-0x87f has been reserved
[    0.217216] system 00:0b: ioport range 0x480-0x4bf has been reserved
[    0.217220] system 00:0b: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.217223] system 00:0b: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.217226] system 00:0b: iomem range 0xfed40000-0xfed8ffff has been reserved
[    0.217233] system 00:0d: iomem range 0xffc00000-0xffefffff could not be reserved
[    0.217239] system 00:0e: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.217242] system 00:0e: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.217248] system 00:0f: iomem range 0xe0000000-0xe3ffffff has been reserved
[    0.217254] system 00:10: iomem range 0x0-0x9ffff could not be reserved
[    0.217257] system 00:10: iomem range 0xc0000-0xcffff could not be reserved
[    0.217260] system 00:10: iomem range 0xe0000-0xfffff could not be reserved
[    0.217263] system 00:10: iomem range 0x100000-0x3f7fffff could not be reserved
[    0.217266] system 00:10: iomem range 0xfed90000-0xffffffff could not be reserved
[    0.247644] PCI: Error while updating region 0000:01:04.0/0 (feb00002 != 00000000)
[    0.247698] PCI: Bridge: 0000:00:1e.0
[    0.247702]   IO window: e000-efff
[    0.247707]   MEM window: 0xfeb00000-0xfebfffff
[    0.247711]   PREFETCH window: disabled.
[    0.247728] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.247748] NET: Registered protocol family 2
[    0.247837] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.248071] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.248862] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.249261] TCP: Hash tables configured (established 131072 bind 65536)
[    0.249264] TCP reno registered
[    0.249374] NET: Registered protocol family 1
[    0.249488] checking if image is initramfs... it is
[    0.720023] Switched to high resolution mode on CPU 0
[    0.749105] Freeing initrd memory: 5482k freed
[    0.749850] audit: initializing netlink socket (disabled)
[    0.749866] type=2000 audit(1262826245.748:1): initialized
[    0.750020] highmem bounce pool size: 64 pages
[    0.750025] Total HugeTLB memory allocated, 0
[    0.750099] VFS: Disk quotas dquot_6.5.1
[    0.750124] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.750170] msgmni has been set to 1767
[    0.750267] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.750270] io scheduler noop registered
[    0.750272] io scheduler anticipatory registered
[    0.750275] io scheduler deadline registered
[    0.750285] io scheduler cfq registered (default)
[    0.750300] pci 0000:00:02.0: Boot video device
[    0.750397] pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
[    0.750712] isapnp: Scanning for PnP cards...
[    1.105027] isapnp: No Plug & Play device found
[    1.107558] Serial: 8250/16550 driver $Revision: 1.90 $ 10 ports, IRQ sharing enabled
[    1.107690] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.107815] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.108453] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.108633] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.110043] brd: module loaded
[    1.110192] PNP: No PS/2 controller found. Probing ports directly.
[    1.112371] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.112377] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.112515] mice: PS/2 mouse device common for all mice
[    1.112636] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.112657] rtc0: alarms up to one month
[    1.112691] cpuidle: using governor ladder
[    1.112694] cpuidle: using governor menu
[    1.112698] No iBFT detected.
[    1.113076] TCP cubic registered
[    1.113079] NET: Registered protocol family 17
[    1.113085] Using IPI No-Shortcut mode
[    1.113193] registered taskstats version 1
[    1.113324] rtc_cmos 00:03: setting system clock to 2010-01-07 01:04:07 UTC (1262826247)
[    1.113454] Freeing unused kernel memory: 248k freed
[    1.187611] ACPI: SSDT 3F7CE0C0, 0688 (r1    AMI   CPU1PM        1 INTL 20051117)
[    1.188254] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    1.188298] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.635732] usbcore: registered new interface driver usbfs
[    1.635759] usbcore: registered new interface driver hub
[    1.635789] usbcore: registered new device driver usb
[    1.644059] USB Universal Host Controller Interface driver v3.0
[    1.644106] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    1.644119] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    1.644123] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.644249] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    1.644283] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000dc00
[    1.644369] usb usb1: configuration #1 chosen from 1 choice
[    1.644400] hub 1-0:1.0: USB hub found
[    1.644406] hub 1-0:1.0: 2 ports detected
[    1.735791] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[    1.735794] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.746826] No dock devices found.
[    1.754725] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    1.754728] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.754731] usb usb1: Product: UHCI Host Controller
[    1.754734] usb usb1: Manufacturer: Linux 2.6.26-custom uhci_hcd
[    1.754736] usb usb1: SerialNumber: 0000:00:1d.0
[    1.754808] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    1.754818] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    1.754823] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.754847] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[    1.754880] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d880
[    1.754955] usb usb2: configuration #1 chosen from 1 choice
[    1.754983] hub 2-0:1.0: USB hub found
[    1.754990] hub 2-0:1.0: 2 ports detected
[    1.770625] SCSI subsystem initialized
[    1.784134] libata version 3.00 loaded.
[    1.856106] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.856110] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.856113] usb usb2: Product: UHCI Host Controller
[    1.856115] usb usb2: Manufacturer: Linux 2.6.26-custom uhci_hcd
[    1.856118] usb usb2: SerialNumber: 0000:00:1d.1
[    1.856176] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    1.856187] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    1.856191] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.856216] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[    1.856250] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d800
[    1.856326] usb usb3: configuration #1 chosen from 1 choice
[    1.856354] hub 3-0:1.0: USB hub found
[    1.856360] hub 3-0:1.0: 2 ports detected
[    1.940002] Marking TSC unstable due to: TSC halts in idle.
[    1.963998] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.964002] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.964005] usb usb3: Product: UHCI Host Controller
[    1.964007] usb usb3: Manufacturer: Linux 2.6.26-custom uhci_hcd
[    1.964009] usb usb3: SerialNumber: 0000:00:1d.2
[    1.964014] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[    1.964014] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    1.964014] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.964014] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[    1.964014] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d480
[    1.964014] usb usb4: configuration #1 chosen from 1 choice
[    1.964014] hub 4-0:1.0: USB hub found
[    1.964014] hub 4-0:1.0: 2 ports detected
[    1.994949] usb 1-1: new low speed USB device using uhci_hcd and address 2
[    2.066799] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.066802] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.066805] usb usb4: Product: UHCI Host Controller
[    2.066807] usb usb4: Manufacturer: Linux 2.6.26-custom uhci_hcd
[    2.066809] usb usb4: SerialNumber: 0000:00:1d.3
[    2.066961] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    2.066976] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    2.066980] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.067003] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[    2.070923] ehci_hcd 0000:00:1d.7: debug port 1
[    2.070930] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    2.070935] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfea37c00
[    2.128023] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.128078] usb usb5: configuration #1 chosen from 1 choice
[    2.128104] hub 5-0:1.0: USB hub found
[    2.128112] hub 5-0:1.0: 8 ports detected
[    2.232095] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    2.232098] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.232101] usb usb5: Product: EHCI Host Controller
[    2.232103] usb usb5: Manufacturer: Linux 2.6.26-custom ehci_hcd
[    2.232105] usb usb5: SerialNumber: 0000:00:1d.7
[    2.233214] ACPI: PCI Interrupt 0000:01:08.0[A] -> GSI 20 (level, low) -> IRQ 20
[    2.258614] e100: eth0: e100_probe: addr 0xfebfe000, irq 20, MAC addr 00:30:59:04:25:2e
[    2.258657] ata_piix 0000:00:1f.2: version 2.12
[    2.258674] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[    2.258679] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    2.258714] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    2.258771] scsi0 : ata_piix
[    2.258853] scsi1 : ata_piix
[    2.258884] ata1: SATA max UDMA/133 cmd 0xd400 ctl 0xd080 bmdma 0xcc00 irq 19
[    2.258887] ata2: SATA max UDMA/133 cmd 0xd000 ctl 0xcc80 bmdma 0xcc08 irq 19
[    2.524197] usb 1-1: device not accepting address 2, error -71
[    2.594897] Uniform Multi-Platform E-IDE driver
[    2.594901] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    2.595366] ICH7: IDE controller (0x8086:0x27df rev 0x02) at  PCI slot 0000:00:1f.1
[    2.595377] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[    2.595386] ICH7: not 100% native mode: will probe irqs later
[    2.595394] ICH7: IDE port disabled
[    2.595399]     ide0: BM-DMA at 0xffa0-0xffa7
[    2.595404] Probing IDE interface ide0...
[    2.606275] hub 1-0:1.0: unable to enumerate USB device on port 1
[    3.104285] hdb: SILICONSYSTEMS UDMA 4GB-4300, ATA DISK drive
[    3.120023] usb 1-1: new low speed USB device using uhci_hcd and address 4
[    3.160055] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    3.160101] hdb: host side 80-wire cable detection failed, limiting max speed to UDMA33
[    3.160103] hdb: UDMA/33 mode selected
[    3.160152] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    3.177696] hdb: max request size: 128KiB
[    3.177699] hdb: 8027712 sectors (4110 MB) w/1KiB Cache, CHS=7964/16/63
[    3.177959] hdb: cache flushes supported
[    3.177990]  hdb: hdb1 hdb2 hdb3 < hdb5 hdb6 hdb7 hdb8 hdb9 >
[    3.265510] PM: Starting manual resume from disk
[    3.277632] kjournald starting.  Commit interval 5 seconds
[    3.277641] EXT3-fs: mounted filesystem with ordered data mode.
[    3.371382] usb 1-1: configuration #1 chosen from 1 choice
[    3.377453] usb 1-1: New USB device found, idVendor=1241, idProduct=1603
[    3.377457] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.377460] usb 1-1: Product: USB Keyboard
[    3.377461] usb 1-1: Manufacturer:  
[    3.623882] udevd version 125 started
[    4.179487] Linux agpgart interface v0.103
[    4.184696] agpgart: Detected an Intel 945GME Chipset.
[    4.185040] agpgart: Detected 7932K stolen memory.
[    4.200169] agpgart: AGP aperture is 256M @ 0xd0000000
[    4.340024] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
[    4.340046] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    4.375731] hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
[    4.425641] usbcore: registered new interface driver hiddev
[    4.459370] input: Power Button (FF) as /class/input/input0
[    4.469725] input:   USB Keyboard as /class/input/input1
[    4.473389] ACPI: Power Button (FF) [PWRF]
[    4.473472] input: Power Button (CM) as /class/input/input2
[    4.491042] ACPI: Power Button (CM) [PWRB]
[    4.504057] input,hidraw0: USB HID v1.10 Keyboard [  USB Keyboard] on usb-0000:00:1d.0-1
[    4.589402] input:   USB Keyboard as /class/input/input3
[    4.600039] input,hidraw1: USB HID v1.10 Device [  USB Keyboard] on usb-0000:00:1d.0-1
[    4.600059] usbcore: registered new interface driver usbhid
[    4.600064] usbhid: v2.6:USB HID core driver
[    5.597656] intel_rng: FWH not detected
[    5.620584] input: Video Bus as /class/input/input4
[    5.632023] ACPI: Video Device [IGD] (multi-head: yes  rom: no  post: no)
[    5.679083] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[    5.679151] iTCO_wdt: Found a ICH7-M DH TCO device (Version=2, TCOBASE=0x0860)
[    5.679181] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.791951] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
[    5.859236] input: PC Speaker as /class/input/input5
[    5.876135] Error: Driver 'pcspkr' is already registered, aborting...
[    5.962974] Error: Driver 'pcspkr' is already registered, aborting...
[    6.133435] parport_pc 00:08: reported by Plug and Play ACPI
[    6.133487] parport0: PC-style at 0x378, irq 7 [PCSPP]
[    6.974296] Adding 489940k swap on /dev/hdb8.  Priority:-1 extents:1 across:489940k
[    7.879067] loop: module loaded
[    7.892565] ppdev: user-space parallel port driver
[    8.258340] kjournald starting.  Commit interval 5 seconds
[    8.258349] EXT3-fs: mounted filesystem with ordered data mode.
[    8.259734] kjournald starting.  Commit interval 5 seconds
[    8.282598] EXT3 FS on hdb6, internal journal
[    8.282598] EXT3-fs: mounted filesystem with ordered data mode.
[    8.283201] kjournald starting.  Commit interval 5 seconds
[    8.414148] EXT3 FS on hdb7, internal journal
[    8.414148] EXT3-fs: mounted filesystem with ordered data mode.
[    8.415383] kjournald starting.  Commit interval 5 seconds
[    8.415383] EXT3-fs: mounted filesystem with ordered data mode.
[    8.416843] kjournald starting.  Commit interval 5 seconds
[    8.434804] EXT3 FS on hdb5, internal journal
[    8.434804] EXT3-fs: mounted filesystem with ordered data mode.
[    8.636130] e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
[   12.763934] NET: Registered protocol family 10
[   12.764326] lo: Disabled Privacy Extensions
[   23.596026] eth0: no IPv6 routers present

--Boundary-00=_tQTRLKnn02lT+Nh--
