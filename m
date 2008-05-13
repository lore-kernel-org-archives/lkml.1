Return-Path: <linux-kernel-owner+w=401wt.eu-S1760436AbYEMVAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436AbYEMVAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbYEMVA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:00:26 -0400
Received: from web57605.mail.re1.yahoo.com ([66.196.100.87]:33550 "HELO
	web57605.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752429AbYEMVAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:00:24 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 17:00:23 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=aN9zrW/XBSYmBFJlJ45sofuTNZExKMEAEoRFH0PTGmIvNXpQJVmtECzqatzkPH6MbFlihcT5fbPQQMExH4AYo0CweBY7UpMhZgDdA/FceCfx5txDqvrxpHg7keJZCH3titcydUIVuvLkFg3Q5jHn/Bdcqis5Lw1mJfE0W4rwEeg=;
X-YMail-OSG: .lh5zZMVM1n0HjRVEeIldkhLqKUcLhGLTuEBC.ncN_HJzrQ6EkQuqn35_QO6EtFXuQ--
X-Mailer: YahooMailWebService/0.7.185
Date: Tue, 13 May 2008 13:53:42 -0700 (PDT)
From: Bill Johnstone <beejstone3@yahoo.com>
Reply-To: beejstone3@yahoo.com
Subject: Incorrect SMP topology reported on AMD K7 MP system
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <36859.1025.qm@web57605.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I have some older cluster nodes running dual AMD Athlon MP 2600+ processors on Tyan S2469 motherboards, running the latest BIOS that Tyan released, version 1.08 .

Issue: the number of processors and sockets on this system is 2.  The second processor has a /sys/devices/system/cpu/cpu1/topology/physical_package_id value of 0, whereas it should be 1.  /proc/cpuinfo looks OK and the kernel seems to recognize and otherwise deal with both processors correctly.

The kernel is a Gentoo version of 2.6.22 .  The dmesg is below.

Is this an issue with the kernel or the motherboard BIOS / ACPI?  If the latter, can it be worked around somehow?

Diagnostic info:

$ grep -r . /sys/devices/system/cpu/*/topology
/sys/devices/system/cpu/cpu0/topology/core_siblings:1
/sys/devices/system/cpu/cpu0/topology/thread_siblings:1
/sys/devices/system/cpu/cpu0/topology/core_id:0
/sys/devices/system/cpu/cpu0/topology/physical_package_id:0
/sys/devices/system/cpu/cpu1/topology/core_siblings:2
/sys/devices/system/cpu/cpu1/topology/thread_siblings:2
/sys/devices/system/cpu/cpu1/topology/core_id:0
/sys/devices/system/cpu/cpu1/topology/physical_package_id:0

$ cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 8
model name      : AMD Athlon(tm) MP 2600+
stepping        : 1
cpu MHz         : 2133.441
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow ts
bogomips        : 4272.01
clflush size    : 32

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 8
model name      : AMD Athlon(tm) Processor
stepping        : 1
cpu MHz         : 2133.441
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow ts
bogomips        : 4266.87
clflush size    : 32

$ dmesg
Linux version 2.6.22-gentoo-r9 (root@node1.dom) (gcc version 4.1.2 (Gentoo 4.1.2)) #2 SMP Wed Nov 21 15:20:26 EST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fef0000 (usable)
 BIOS-e820: 000000007fef0000 - 000000007fef6000 (ACPI data)
 BIOS-e820: 000000007fef6000 - 000000007ff00000 (ACPI NVS)
 BIOS-e820: 000000007ff00000 - 000000007ff80000 (usable)
 BIOS-e820: 000000007ff80000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec04000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f7120
Entering add_active_range(0, 0, 524160) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524160
early_node_map[1] active PFN ranges
    0:        0 ->   524160
On node 0 totalpages: 524160
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2303 pages used for memmap
  HighMem zone: 292481 pages, LIFO batch:31
DMI 2.3 present.
Using APIC driver default
ACPI: RSDP 000F70B0, 0014 (r0 PTLTD )
ACPI: RSDT 7FEF3F55, 002C (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 7FEF5F2E, 0074 (r1 AMD    TECATE    6040000 PTL     F4240)
ACPI: DSDT 7FEF3F81, 1FAD (r1    AMD  AMDACPI  6040000 MSFT  100000D)
ACPI: FACS 7FEFFFC0, 0040
ACPI: APIC 7FEF5FA2, 005E (r1 PTLTD      APIC    6040000  LTP        0)
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x01] enabled)
Processor #1 6:8 APIC version 16
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 6:8 APIC version 16
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Built 1 zonelists.  Total pages: 520065
Kernel command line: root=/dev/nfs ip=dhcp nfsroot=10.0.0.1:/root_amd32,v3,tcp,rsize=8192,wsize=8192 console=ttyS0,115200n8 console=tty0 vga=extended BOOT_IMAGE=kernel-2.6.22-gentoo-r9
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2133.441 MHz processor.
Console: colour VGA+ 80x50
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2073852k/2096640k available (2465k kernel code, 21528k reserved, 984k data, 236k init, 1179072k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9c000 - 0xfffff000   ( 396 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0466000 - 0xc04a1000   ( 236 kB)
      .data : 0xc0368500 - 0xc045e544   ( 984 kB)
      .text : 0xc0100000 - 0xc0368500   (2465 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4272.01 BogoMIPS (lpj=8544022)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383fbff c1cbfbff 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: After all inits, caps: 0383fbff c1cbfbff 00000000 00000420 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 14k freed
ACPI: Core revision 20070126
CPU0: AMD Athlon(tm) MP 2600+ stepping 01
Booting processor 1/0 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4266.87 BogoMIPS (lpj=8533754)
CPU: After generic identify, caps: 0383fbff c1cbfbff 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: After all inits, caps: 0383fbff c1cbfbff 00000000 00000420 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Athlon(tm) Processor stepping 01
Total of 2 processors activated (8538.88 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
Brought up 2 CPUs
migration_cost=4000
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd7c0, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
mtrr: your CPUs had inconsistent fixed MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Firmware left 0000:02:08.0 e100 interrupts enabled, disabling
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.OP2P._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 5 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 5 *10 11)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:00: iomem range 0xfffc0000-0xffffffff could not be reserved
pnp: 00:00: iomem range 0xffc00000-0xfff7ffff has been reserved
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x7fffffff could not be reserved
pnp: 00:06: ioport range 0x4d0-0x4d1 has been reserved
PCI: Bridge: 0000:00:01.0
Time: acpi_pm clocksource has been installed.
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:10.0
  IO window: 2000-2fff
  MEM window: fc100000-fdffffff
  PREFETCH window: 88000000-880fffff
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
fuse init (API version 7.8)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
BIOS failed to enable PCI standards compliance, fixing this error.
Boot video device is 0000:02:07.0
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
AMD768 RNG detected
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected AMD 760MP chipset
agpgart: AGP aperture is 32M @ 0x0
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (FF) as /class/input/input1
ACPI: Sleep Button (FF) [SLPF]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
floppy0: no floppy controllers found
RAMDISK driver initialized: 0 RAM disks of 4096K size 1024 blocksize
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 23 (level, low) -> IRQ 16
e1000: 0000:00:0b.0: e1000_probe: (PCI:66MHz:64-bit) 00:e0:81:26:a0:62
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:02:08.0[A] -> GSI 18 (level, low) -> IRQ 17
e100: eth1: e100_probe: addr 0xfc122000, irq 17, MAC addr 00:E0:81:26:A0:63
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
AMD7441: IDE controller at PCI slot 0000:00:07.1
AMD7441: chipset revision 4
AMD7441: not 100% native mode: will probe irqs later
AMD7441: 0000:00:07.1 (rev 04) UDMA100 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: WDC WD400BB-00JHC0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: max request size: 128KiB
hda: 78165360 sectors (40020 MB) w/2048KiB Cache, CHS=65535/16/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 < hda5 hda6 >
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:02:00.0[D] -> GSI 19 (level, low) -> IRQ 18
ohci_hcd 0000:02:00.0: OHCI Host Controller
ohci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:02:00.0: irq 18, io mem 0xfc120000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
oprofile: using NMI interrupt.
pktgen v2.68: Packet Generator for packet performance testing.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
Starting balanced_irq
Using IPI Shortcut mode
e100: eth1: e100_watchdog: link up, 100Mbps, full-duplex
e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Sending DHCP requests ., OK
IP-Config: Got DHCP answer from 0.0.0.0, my address is 10.0.1.1
IP-Config: Complete:
      device=eth0, addr=10.0.1.1, mask=255.0.0.0, gw=255.255.255.255,
     host=node1, domain=dom, nis-domain=(none),
     bootserver=0.0.0.0, rootserver=10.0.0.1, rootpath=
Looking up port of RPC 100003/3 on 10.0.0.1
Looking up port of RPC 100005/3 on 10.0.0.1
VFS: Mounted root (nfs filesystem) readonly.
Freeing unused kernel memory: 236k freed
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda6, internal journal
EXT3-fs: mounted filesystem with journal data mode.
Adding 4194248k swap on /dev/hda1.  Priority:-1 extents:1 across:4194248k




      
