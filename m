Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbXLIHv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbXLIHv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 02:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXLIHvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 02:51:51 -0500
Received: from smtp105.plus.mail.re1.yahoo.com ([69.147.102.68]:30939 "HELO
	smtp105.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751009AbXLIHvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 02:51:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=hucSi/SiJg5h+bBnflZWKLtWYEBTx4uTyM8KB6F551xJ0NtCx19ntVjaOh5lOGp3exw9hP8J7VNR6wHpQjahBSonVjdb6i3olEO09y4HtZHUlfMN2chp7m4iOrjUo7PJTLUKycR9Q3cWQhRfvLnSES1SlCC7KhleHyWcqivmiAM=  ;
Date: Sun, 9 Dec 2007 08:50:02 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>, len.brown@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 2.6.24-rc4-mm1: acpi reboots machine
Message-ID: <20071209075001.GA4686@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Andrew Morton <akpm@linux-foundation.org>, len.brown@intel.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Andrew,
Hi Len,

after booting 2.6.24-rc4-mm1 (2.6.24-rc4-190-g94545ba, otoh, boots just
fine) on my asus laptop, the machine reboots after claiming that
"Critical temperature reached (255 C)." However, the degrees number
is kinda hinting at 0xff all-ones field. Will try dump_stack in
acpi_thermal_critical() to checkout the call path. For now here's the netconsole bootlog:

[    0.000000] Linux version 2.6.24-rc4-mm1 (boris@gollum) (gcc version 4.2.3 20071123 (prerelease) (Debian 4.2.2-4)) #7 SMP PREEMPT Sun Dec 9 08:27:26 CET 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001ff40000 (usable)
[    0.000000]  BIOS-e820: 000000001ff40000 - 000000001ff50000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001ff50000 - 0000000020000000 (ACPI NVS)
[    0.000000] 511MB LOWMEM available.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   130880
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   130880
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F5DF0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 1FF40000, 002C (r1 A M I  OEMRSDT   6000423 MSFT       97)
[    0.000000] ACPI: FACP 1FF40200, 0081 (r1 A M I  OEMFACP   6000423 MSFT       97)
[    0.000000] ACPI: DSDT 1FF40400, 628D (r1  1ABSP 1ABSP001        1 MSFT  2000001)
[    0.000000] ACPI: FACS 1FF50000, 0040
[    0.000000] ACPI: OEMB 1FF50040, 0053 (r1 A M I  OEMBIOS   6000423 MSFT       97)
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000:e0000000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129475
[    0.000000] Kernel command line: root=/dev/hda1 vga=0 nmi_watchdog=1 netconsole=@192.168.45.67/,@192.168.45.26/
[    0.000000] Found and enabled local APIC!
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c0451000 soft=c0449000
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 1500.114 MHz processor.
[   50.138075] Console: colour VGA+ 80x25
[   50.138080] console [tty0] enabled
[   50.140479] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[   50.140882] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[   50.160065] Memory: 513364k/523520k available (2049k kernel code, 9712k reserved, 1113k data, 172k init, 0k highmem)
[   50.160147] virtual kernel memory layout:
[   50.160148]     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
[   50.160150]     vmalloc : 0xe0800000 - 0xfffb3000   ( 503 MB)
[   50.160151]     lowmem  : 0xc0000000 - 0xdff40000   ( 511 MB)
[   50.160153]       .init : 0xc041b000 - 0xc0446000   ( 172 kB)
[   50.160154]       .data : 0xc030067f - 0xc0416ca8   (1113 kB)
[   50.160156]       .text : 0xc0100000 - 0xc030067f   (2049 kB)
[   50.160549] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   50.160705] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
[   50.220728] Calibrating delay using timer specific routine.. 3003.73 BogoMIPS (lpj=1501865)
[   50.220857] Security Framework initialized
[   50.220934] Mount-cache hash table entries: 512
[   50.221174] CPU: L1 I cache: 32K, L1 D cache: 32K
[   50.221273] CPU: L2 cache: 1024K
[   50.221338] Intel machine check architecture supported.
[   50.221398] Intel machine check reporting enabled on CPU#0.
[   50.221459] Compat vDSO mapped to ffffe000.
[   50.221524] Checking 'hlt' instruction... OK.
[   50.225022] SMP alternatives: switching to UP code
[   50.225766] Freeing SMP alternatives: 11k freed
[   50.225823] ACPI: Core revision 20070126
[   50.229623] ACPI: setting ELCR to 0200 (from 0c30)
[   50.734915] CPU0: Intel(R) Pentium(R) M processor 1500MHz stepping 05
[   50.735059] SMP motherboard not detected.
[   50.836119] Brought up 1 CPUs
[   50.836305] khelper used greatest stack depth: 3352 bytes left
[   50.836463] net_namespace: 108 bytes
[   50.837167] NET: Registered protocol family 16
[   50.837466] ACPI: bus type pci registered
[   50.838812] PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=2
[   50.838872] PCI: Using configuration type 1
[   50.838928] Setting up standard PCI resources
[   50.850451] khelper used greatest stack depth: 3280 bytes left
[   50.851263] khelper used greatest stack depth: 3112 bytes left
[   50.857186] ACPI: EC: non-query interrupt received, switching to interrupt mode
[   50.858465] ACPI: Interpreter enabled
[   50.858524] ACPI: (supports S0 S3 S4 S5)
[   50.858760] ACPI: Using PIC for interrupt routing
[   50.868377] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[   50.868445] ACPI: EC: driver started in interrupt mode
[   50.868555] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   50.869056] PCI: Enabled i801 SMBus device
[   50.869117] PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
[   50.869179] PCI quirk: region 0500-053f claimed by ICH4 GPIO
[   50.869806] PCI: Transparent bridge - 0000:00:1e.0
[   50.873140] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12)
[   50.873851] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *11 12)
[   50.874535] ACPI: PCI Interrupt Link [LNKC] (IRQs *4 10 12)
[   50.875034] ACPI: PCI Interrupt Link [LNKD] (IRQs *5 6 10)
[   50.875537] ACPI: PCI Interrupt Link [LNKE] (IRQs 6 11) *0, disabled.
[   50.876080] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 7) *0, disabled.
[   50.876623] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7) *0, disabled.
[   50.877169] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 6 *10 12)
[   50.877640] Linux Plug and Play Support v0.97 (c) Adam Belay
[   50.877738] pnp: PnP ACPI init
[   50.877803] ACPI: bus type pnp registered
[   50.883974] pnp: PnP ACPI: found 15 devices
[   50.884035] ACPI: ACPI bus type pnp unregistered
[   50.884094] PnPBIOS: Disabled by ACPI PNP
[   50.884329] usbcore: registered new interface driver usbfs
[   50.884441] usbcore: registered new interface driver hub
[   50.884552] usbcore: registered new device driver usb
[   50.884777] PCI: Using ACPI for IRQ routing
[   50.884834] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   50.884927] PCI: Cannot allocate resource region 4 of device 0000:00:1f.3
[   50.893004] Time: tsc clocksource has been installed.
[   50.895050] system 00:09: ioport range 0x480-0x48f has been reserved
[   50.895112] system 00:09: ioport range 0x5c0-0x5cf has been reserved
[   50.895176] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[   50.895242] system 00:0c: iomem range 0xffc00000-0xffefffff has been reserved
[   50.895309] system 00:0d: ioport range 0x540-0x55f has been reserved
[   50.895370] system 00:0d: ioport range 0x400-0x47f has been reserved
[   50.895435] system 00:0d: ioport range 0x480-0x48f has been reserved
[   50.895496] system 00:0d: ioport range 0x500-0x53f has been reserved
[   50.895557] system 00:0d: ioport range 0x4c0-0x4cf has been reserved
[   50.895617] system 00:0d: iomem range 0xfec00000-0xfec00fff has been reserved
[   50.895680] system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
[   50.895746] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[   50.895807] system 00:0e: iomem range 0xc0000-0xdffff could not be reserved
[   50.895869] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[   50.895931] system 00:0e: iomem range 0x100000-0x1fffffff could not be reserved
[   50.896004] system 00:0e: iomem range 0x0-0x0 could not be reserved
[   50.926541] PCI: Bridge: 0000:00:01.0
[   50.926598]   IO window: d000-dfff
[   50.926655]   MEM window: ff800000-ff8fffff
[   50.926713]   PREFETCH window: ce900000-de9fffff
[   50.926786] PCI: Bus 3, cardbus bridge: 0000:02:01.0
[   50.926843]   IO window: 00001400-000014ff
[   50.926901]   IO window: 00001800-000018ff
[   50.926960]   PREFETCH window: 34000000-37ffffff
[   50.927020]   MEM window: 38000000-3bffffff
[   50.927079] PCI: Bus 7, cardbus bridge: 0000:02:01.1
[   50.927136]   IO window: 00001c00-00001cff
[   50.927194]   IO window: 00002000-000020ff
[   50.927252]   PREFETCH window: 3c000000-3fffffff
[   50.927313]   MEM window: 40000000-43ffffff
[   50.927375] PCI: Bridge: 0000:00:1e.0
[   50.927430]   IO window: disabled.
[   50.927488]   MEM window: ff900000-ff9fffff
[   50.927547]   PREFETCH window: dea00000-deafffff
[   50.927631] PCI: Enabling device 0000:02:01.0 (0000 -> 0003)
[   50.927999] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[   50.928064] ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
[   50.928527] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[   50.928587] ACPI: PCI Interrupt 0000:02:01.1[B] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[   50.928756] NET: Registered protocol family 2
[   50.937028] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[   50.937394] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[   50.937603] TCP bind hash table entries: 16384 (order: 6, 393216 bytes)
[   50.938109] TCP: Hash tables configured (established 16384 bind 16384)
[   50.938171] TCP reno registered
[   50.943908] khelper used greatest stack depth: 3100 bytes left
[   50.945348] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   50.945635] io scheduler noop registered (default)
[   50.946705] ACPI: AC Adapter [AC] (on-line)
[   50.947312] ACPI: Battery Slot [BAT0] (battery absent)
[   50.947441] ACPI: Battery Slot [BAT1] (battery absent)
[   50.947808] input: Power Button (FF) as /class/input/input0
[   50.947869] ACPI: Power Button (FF) [PWRF]
[   50.948032] input: Lid Switch as /class/input/input1
[   50.948146] ACPI: Lid Switch [LID]
[   50.948294] input: Sleep Button (CM) as /class/input/input2
[   50.948359] ACPI: Sleep Button (CM) [SLPB]
[   50.948511] input: Power Button (CM) as /class/input/input3
[   50.948571] ACPI: Power Button (CM) [PWRB]
[   50.948749] ACPI: Invalid PBLK length [7]
[   50.949640] ACPI: CPU0 (power states: C1[C1] C2[C2])
[   50.962860] ACPI: Critical trip point
[   50.962918] Critical temperature reached (255 C), shutting down.
[   50.962988] ACPI: Thermal Zone [THRM] (255 C)
[   50.963137] Asus Laptop ACPI Extras version 0.30
[   50.963335]   M6N model detected, supported
[   50.964168] isapnp: Scanning for PnP cards...
[   51.320980] isapnp: No Plug & Play device found
[   51.358289] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   51.358586] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[   51.359209] ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
[   51.359375] ACPI: PCI interrupt for device 0000:00:1f.6 disabled
[   51.359565] tg3.c:v3.86 (November 9, 2007)
[   51.359635] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
[   51.388900] eth0: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:11:2f:00:71:33
[   51.389234] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
[   51.389304] eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
[   51.389386] netconsole: local port 6665
[   51.389442] netconsole: local IP 192.168.45.67
[   51.389500] netconsole: interface eth0
[   51.389555] netconsole: remote port 6666
[   51.389611] netconsole: remote IP 192.168.45.26
[   51.389669] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[   51.389729] netconsole: device eth0 not up yet, forcing it
[   53.278349] tg3: eth0: Link is up at 100 Mbps, full duplex.
[   53.278409] tg3: eth0: Flow control is on for TX and on for RX.
[   53.281188] console [netcon0] enabled
[   53.293588] netconsole: network logging started
[   53.293647] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   53.293720] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   53.293894] ICH4: IDE controller (0x8086:0x24ca rev 0x03) at  PCI slot 0000:00:1f.1
[   53.293971] PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
[   53.294419] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 4
[   53.294486] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 4 (level, low) -> IRQ 4
[   53.294670] ICH4: not 100% native mode: will probe irqs later
[   53.294750]     ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
[   53.294924]     ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
[   54.169666] hda: IC25N060ATMR04-0, ATA DISK drive
[   55.503664] hdc: TOSHIBA ODD-DVD SD-R6372, ATAPI CD/DVD-ROM drive
[   55.504886] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   55.527065] ide1 at 0x170-0x177,0x376 on irq 15
[   55.538103] hda: max request size: 512KiB
[   55.538432] hda: 117210240 sectors (60011 MB) w/7884KiB Cache, CHS=16383/255/63, UDMA(100)
[   55.539013] hda: cache flushes supported
[   55.539119]  hda: hda1 hda2 hda3
[   55.553931] hdc: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
[   55.554381] Uniform CD-ROM driver Revision: 3.20
[   55.560575] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
[   55.560642] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10 (level, low) -> IRQ 10
[   55.560836] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   55.560974] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   55.564994] ehci_hcd 0000:00:1d.7: debug port 1
[   55.565074] ehci_hcd 0000:00:1d.7: irq 10, io mem 0xffaffc00
[   55.574449] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   55.574763] usb usb1: configuration #1 chosen from 1 choice
[   55.574888] hub 1-0:1.0: USB hub found
[   55.574951] hub 1-0:1.0: 6 ports detected
[   55.675460] usb usb1: New USB device found, idVendor=0000, idProduct=0000
[   55.675523] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   55.675606] usb usb1: Product: EHCI Host Controller
[   55.675664] usb usb1: Manufacturer: Linux 2.6.24-rc4-mm1 ehci_hcd
[   55.675735] usb usb1: SerialNumber: 0000:00:1d.7
[   55.830303] usbcore: registered new interface driver usbserial
[   55.830365] drivers/usb/serial/usb-serial.c: USB Serial Driver core
[   55.830476] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan - (without firmware)
[   55.830595] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan 1 port adapter
[   55.830714] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan 2 port adapter
[   55.830835] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan 4 port adapter
[   55.830961] usbcore: registered new interface driver keyspan
[   55.831022] drivers/usb/serial/keyspan.c: v1.1.5:Keyspan USB to Serial Converter Driver
[   55.831212] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f12:PS2M] at 0x60,0x64 irq 1,12
[   55.833451] i8042.c: Detected active multiplexing controller, rev 1.1.
[   55.835365] serio: i8042 KBD port at 0x60,0x64 irq 1
[   55.835428] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   55.835498] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   55.835559] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   55.835629] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   55.835866] mice: PS/2 mouse device common for all mice
[   55.836284] cpuidle: using governor ladder
[   55.951618] input: AT Translated Set 2 keyboard as /class/input/input4
[   56.836635] cpuidle: using governor menu
[   56.836763] Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Nov 20 19:16:42 2007 UTC).
[   56.836955] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
[   56.838502] Marking TSC unstable due to: TSC halts in idle.
[   56.838572] Time: acpi_pm clocksource has been installed.
[   57.646804] intel8x0_measure_ac97_clock: measured 50509 usecs
[   57.646867] intel8x0: clocking to 48000
[   57.647364] ALSA device list:
[   57.647421]   #0: Intel 82801DB-ICH4 with STAC9750,51 at irq 11
[   57.647552] TCP cubic registered
[   57.647648] NET: Registered protocol family 1
[   57.647738] NET: Registered protocol family 17
[   57.647988] RPC: Registered udp transport module.
[   57.648048] RPC: Registered tcp transport module.
[   57.648200] Testing NMI watchdog ... OK.
[   57.668313] Using IPI No-Shortcut mode
[   57.733562] kjournald starting.  Commit interval 5 seconds
[   57.733643] EXT3-fs: mounted filesystem with ordered data mode.
[   57.733729] VFS: Mounted root (ext3 filesystem) readonly.
[   57.733969] Freeing unused kernel memory: 172k freed
[   57.800235] khelper used greatest stack depth: 2648 bytes left
[   58.980087] stty used greatest stack depth: 2640 bytes left
[   59.600742] mount used greatest stack depth: 2140 bytes left
[   60.959463] ACPI: Critical trip point
[   60.959542] Critical temperature reached (255 C), shutting down.
[   62.925991] Real Time Clock Driver v1.12ac
[   63.082557] Linux agpgart interface v0.103
[   63.128504] agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
[   63.128508] on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
[   63.128718] agpgart: Detected an Intel 855PM Chipset.
[   63.143091] agpgart: AGP aperture is 256M @ 0xe0000000
[   63.166109] USB Universal Host Controller Interface driver v3.0
[   63.166282] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[   63.166490] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   63.166607] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   63.167403] uhci_hcd 0000:00:1d.0: irq 11, io base 0x0000e800
[   63.167652] usb usb2: configuration #1 chosen from 1 choice
[   63.167757] hub 2-0:1.0: USB hub found
[   63.167820] hub 2-0:1.0: 2 ports detected
[   63.237339] Shutdown: hda
[   63.268462] usb usb2: New USB device found, idVendor=0000, idProduct=0000
[   63.268537] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   63.268629] usb usb2: Product: UHCI Host Controller
[   63.268687] usb usb2: Manufacturer: Linux 2.6.24-rc4-mm1 uhci_hcd
[   63.268760] usb usb2: SerialNumber: 0000:00:1d.0
[   63.269225] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 5
[   63.269292] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
[   63.269496] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   63.269603] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   63.269709] uhci_hcd 0000:00:1d.1: irq 5, io base 0x0000e880
[   63.269944] usb usb3: configuration #1 chosen from 1 choice
[   63.270049] hub 3-0:1.0: USB hub found
[   63.270111] hub 3-0:1.0: 2 ports detected
[   63.370377] usb usb3: New USB device found, idVendor=0000, idProduct=0000
[   63.370450] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   63.370536] usb usb3: Product: UHCI Host Controller
[   63.370595] usb usb3: Manufacturer: Linux 2.6.24-rc4-mm1 uhci_hcd
[   63.370667] usb usb3: SerialNumber: 0000:00:1d.1
[   63.370772] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 4 (level, low) -> IRQ 4
[   63.370967] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   63.371072] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   63.371177] uhci_hcd 0000:00:1d.2: irq 4, io base 0x0000ec00
[   63.371413] usb usb4: configuration #1 chosen from 1 choice
[   63.371517] hub 4-0:1.0: USB hub found
[   63.371579] hub 4-0:1.0: 2 ports detected
[   63.472261] usb usb4: New USB device found, idVendor=0000, idProduct=0000
[   63.472325] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   63.472409] usb usb4: Product: UHCI Host Controller
[   63.472467] usb usb4: Manufacturer: Linux 2.6.24-rc4-mm1 uhci_hcd
[   63.472540] usb usb4: SerialNumber: 0000:00:1d.2
[   63.475203] usb 2-2: new low speed USB device using uhci_hcd and address 2
[   63.639154] usb 2-2: configuration #1 chosen from 1 choice
[   63.642112] usb 2-2: New USB device found, idVendor=046d, idProduct=c016
[   63.642176] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   63.642253] usb 2-2: Product: Optical USB Mouse
[   63.642311] usb 2-2: Manufacturer: Logitech
[   63.709809] Disabling non-boot CPUs ...
[   63.709884] Power down.
[   63.709944] acpi_power_off called
-- 
Regards/Gruﬂ,
    Boris.

--jI8keyz6grp/JLjh
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="config-2.6.24-rc4-mm1.bz2"
Content-Transfer-Encoding: base64

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
kU4UJD+PFobA

--jI8keyz6grp/JLjh--
