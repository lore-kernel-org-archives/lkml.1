Return-Path: <linux-kernel-owner+w=401wt.eu-S932394AbXCDOTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbXCDOTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 09:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932694AbXCDOTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 09:19:41 -0500
Received: from hermes1.dur.ac.uk ([129.234.8.20]:53479 "EHLO hermes1.dur.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394AbXCDOTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 09:19:38 -0500
Date: Sun, 4 Mar 2007 14:23:50 +0000
From: Ash Milsted <thatistosayiseenem@gawab.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, vojtech@suse.cz
Subject: Re: 2.6.21-rc2 regression vs. 2.6.20: AT keyboard only works with
 pci=noacpi
Message-Id: <20070304142350.7c3c79af.thatistosayiseenem@gawab.com>
In-Reply-To: <20070303151424.3b08c33e.thatistosayiseenem@gawab.com>
References: <20070303151424.3b08c33e.thatistosayiseenem@gawab.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-DurhamAcUk-MailScanner: Found to be clean, Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2007 15:14:24 +0000
Ash Milsted <thatistosayiseenem@gawab.com> wrote:

> Hi,
> With 2.6.21-rc2-git1 I have a problem with my ps/2 port keyboard - it only works
> with one of the following on the command-line:
>  - nolapic
>  - irqfixup
>  - pci=noacpi
> Otherwise it gets stuck with the numlock on.
> The following options have no effect:
>  - nohz=off (who knows eh?)
>  - pci=nomsi
> 
> Here is my lspci:
> 00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600 AGP] Host Bridge (rev 80)
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
> 00:0a.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
> 00:0b.0 Multimedia audio controller: Creative Labs SB Audigy (rev 04)
> 00:0b.1 Input device controller: Creative Labs SB Audigy Game Port (rev 04)
> 00:0b.2 FireWire (IEEE 1394): Creative Labs SB Audigy FireWire Port (rev 04)
> 00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID Controller (rev 80)
> 00:0f.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
> 00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
> 00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
> 00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
> 00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
> 00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86)
> 00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge [KT600/K8T800/K8T890 South]
> 00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233/A/8235/8237 AC97 Audio Controller (rev 60)
> 00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 78)
> 01:00.0 VGA compatible controller: nVidia Corporation NV11 [GeForce2 MX/MX 400] (rev a1)
> 
> And here is a boot log without any of those parameters (keyboard fails):
> Mar  3 14:38:24 joker syslog-ng[4183]: syslog-ng starting up; version='2.0.0' 
> Mar  3 14:38:24 joker a0000 (reserved)
> Mar  3 14:38:24 joker limit_regions endfor: 00000000000f0000 - 0000000000100000 (reserved)
> Mar  3 14:38:24 joker limit_regions endfor: 0000000000100000 - 000000001fff0000 (usable)
> Mar  3 14:38:24 joker user-defined physical RAM map:
> Mar  3 14:38:24 joker user: 0000000000000000 - 000000000009fc00 (usable)
> Mar  3 14:38:24 joker user: 000000000009fc00 - 00000000000a0000 (reserved)
> Mar  3 14:38:24 joker user: 00000000000f0000 - 0000000000100000 (reserved)
> Mar  3 14:38:24 joker user: 0000000000100000 - 000000001fff0000 (usable)
> Mar  3 14:38:24 joker 511MB LOWMEM available.
> Mar  3 14:38:24 joker Entering add_active_range(0, 0, 131056) 0 entries of 256 used
> Mar  3 14:38:24 joker Zone PFN ranges:
> Mar  3 14:38:24 joker DMA             0 ->     4096
> Mar  3 14:38:24 joker Normal       4096 ->   131056
> Mar  3 14:38:24 joker early_node_map[1] active PFN ranges
> Mar  3 14:38:24 joker 0:        0 ->   131056
> Mar  3 14:38:24 joker On node 0 totalpages: 131056
> Mar  3 14:38:24 joker DMA zone: 32 pages used for memmap
> Mar  3 14:38:24 joker DMA zone: 0 pages reserved
> Mar  3 14:38:24 joker DMA zone: 4064 pages, LIFO batch:0
> Mar  3 14:38:24 joker Normal zone: 991 pages used for memmap
> Mar  3 14:38:24 joker Normal zone: 125969 pages, LIFO batch:31
> Mar  3 14:38:24 joker DMI 2.3 present.
> Mar  3 14:38:24 joker ACPI: RSDP 000FA8C0, 0014 (r0 AMI   )
> Mar  3 14:38:24 joker ACPI: RSDT 1FFF0000, 002C (r1 AMIINT VIA_K7         10 MSFT       97)
> Mar  3 14:38:24 joker ACPI: FACP 1FFF0030, 0081 (r1 AMIINT VIA_K7         11 MSFT       97)
> Mar  3 14:38:24 joker ACPI: DSDT 1FFF0120, 3502 (r1    VIA    K7VT4     1000 MSFT  100000D)
> Mar  3 14:38:24 joker ACPI: FACS 1FFF8000, 0040
> Mar  3 14:38:24 joker ACPI: APIC 1FFF00C0, 0054 (r1 AMIINT VIA_K7          9 MSFT       97)
> Mar  3 14:38:24 joker ACPI: PM-Timer IO Port: 0x808
> Mar  3 14:38:24 joker ACPI: Local APIC address 0xfee00000
> Mar  3 14:38:24 joker ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> Mar  3 14:38:24 joker Processor #0 6:10 APIC version 16
> Mar  3 14:38:24 joker ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> Mar  3 14:38:24 joker IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
> Mar  3 14:38:24 joker ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> Mar  3 14:38:24 joker ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> Mar  3 14:38:24 joker ACPI: IRQ0 used by override.
> Mar  3 14:38:24 joker ACPI: IRQ2 used by override.
> Mar  3 14:38:24 joker ACPI: IRQ9 used by override.
> Mar  3 14:38:24 joker Enabling APIC mode:  Flat.  Using 1 I/O APICs
> Mar  3 14:38:24 joker Using ACPI (MADT) for SMP configuration information
> Mar  3 14:38:24 joker Allocating PCI resources starting at 20000000 (gap: 1fff0000:e0010000)
> Mar  3 14:38:24 joker Detected 2198.080 MHz processor.
> Mar  3 14:38:24 joker Built 1 zonelists.  Total pages: 130033
> Mar  3 14:38:24 joker Kernel command line: root=/dev/disk/by-label/root vga=ext ro agp=off mem=524224K
> Mar  3 14:38:24 joker mapped APIC to ffffd000 (fee00000)
> Mar  3 14:38:24 joker mapped IOAPIC to ffffc000 (fec00000)
> Mar  3 14:38:24 joker Enabling fast FPU save and restore... done.
> Mar  3 14:38:24 joker Enabling unmasked SIMD FPU exception support... done.
> Mar  3 14:38:24 joker Initializing CPU#0
> Mar  3 14:38:24 joker CPU 0 irqstacks, hard=c0306000 soft=c0305000
> Mar  3 14:38:24 joker PID hash table entries: 2048 (order: 11, 8192 bytes)
> Mar  3 14:38:24 joker Console: colour VGA+ 80x50
> Mar  3 14:38:24 joker Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> Mar  3 14:38:24 joker Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> Mar  3 14:38:24 joker Memory: 516036k/524224k available (1321k kernel code, 7612k reserved, 533k data, 188k init, 0k highmem)
> Mar  3 14:38:24 joker virtual kernel memory layout:
> Mar  3 14:38:24 joker fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
> Mar  3 14:38:24 joker vmalloc : 0xe0800000 - 0xfffb5000   ( 503 MB)
> Mar  3 14:38:24 joker lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
> Mar  3 14:38:24 joker .init : 0xc02d1000 - 0xc0300000   ( 188 kB)
> Mar  3 14:38:24 joker .data : 0xc024a4cd - 0xc02cf9b4   ( 533 kB)
> Mar  3 14:38:24 joker .text : 0xc0100000 - 0xc024a4cd   (1321 kB)
> Mar  3 14:38:24 joker Checking if this processor honours the WP bit even in supervisor mode... Ok.
> Mar  3 14:38:24 joker Calibrating delay using timer specific routine.. 4405.92 BogoMIPS (lpj=2546149)
> Mar  3 14:38:24 joker Mount-cache hash table entries: 512
> Mar  3 14:38:24 joker CPU: After generic identify, caps: 0383fbff c1c3fbff 00000000 00000000 00000000 00000000 00000000
> Mar  3 14:38:24 joker CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> Mar  3 14:38:24 joker CPU: L2 Cache: 512K (64 bytes/line)
> Mar  3 14:38:24 joker CPU: After all inits, caps: 0383fbff c1c3fbff 00000000 00000420 00000000 00000000 00000000
> Mar  3 14:38:24 joker Intel machine check architecture supported.
> Mar  3 14:38:24 joker Intel machine check reporting enabled on CPU#0.
> Mar  3 14:38:24 joker CPU: AMD Athlon(tm) XP 3200+ stepping 00
> Mar  3 14:38:24 joker Checking 'hlt' instruction... OK.
> Mar  3 14:38:24 joker ACPI: Core revision 20070126
> Mar  3 14:38:24 joker ENABLING IO-APIC IRQs
> Mar  3 14:38:24 joker ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> Mar  3 14:38:24 joker NET: Registered protocol family 16
> Mar  3 14:38:24 joker ACPI: bus type pci registered
> Mar  3 14:38:24 joker PCI: PCI BIOS revision 2.10 entry at 0xfda71, last bus=1
> Mar  3 14:38:24 joker PCI: Using configuration type 1
> Mar  3 14:38:24 joker Setting up standard PCI resources
> Mar  3 14:38:24 joker ACPI: Interpreter enabled
> Mar  3 14:38:24 joker ACPI: (supports S0 S1 S3 S4 S5)
> Mar  3 14:38:24 joker ACPI: Using IOAPIC for interrupt routing
> Mar  3 14:38:24 joker ACPI: PCI Root Bridge [PCI0] (0000:00)
> Mar  3 14:38:24 joker PCI: Probing PCI hardware (bus 00)
> Mar  3 14:38:24 joker Boot video device is 0000:01:00.0
> Mar  3 14:38:24 joker ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> Mar  3 14:38:24 joker ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 12 14 15)
> Mar  3 14:38:24 joker ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11 12 14 15)
> Mar  3 14:38:24 joker ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 *12 14 15)
> Mar  3 14:38:24 joker ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 10 11 12 14 15)
> Mar  3 14:38:24 joker ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
> Mar  3 14:38:24 joker ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
> Mar  3 14:38:24 joker ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
> Mar  3 14:38:24 joker ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
> Mar  3 14:38:24 joker ACPI: Power Resource [URP1] (off)
> Mar  3 14:38:24 joker ACPI: Power Resource [URP2] (off)
> Mar  3 14:38:24 joker ACPI: Power Resource [FDDP] (off)
> Mar  3 14:38:24 joker ACPI: Power Resource [LPTP] (off)
> Mar  3 14:38:24 joker Linux Plug and Play Support v0.97 (c) Adam Belay
> Mar  3 14:38:24 joker pnp: PnP ACPI init
> Mar  3 14:38:24 joker pnp: PnP ACPI: found 11 devices
> Mar  3 14:38:24 joker PCI: Using ACPI for IRQ routing
> Mar  3 14:38:24 joker PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> Mar  3 14:38:24 joker pnp: 00:05: iomem range 0xfec00000-0xfec00fff has been reserved
> Mar  3 14:38:24 joker pnp: 00:05: iomem range 0xfee00000-0xfee00fff has been reserved
> Mar  3 14:38:24 joker PCI: Bridge: 0000:00:01.0
> Mar  3 14:38:24 joker IO window: disabled.
> Mar  3 14:38:24 joker MEM window: dde00000-dfefffff
> Mar  3 14:38:24 joker PREFETCH window: cdd00000-ddcfffff
> Mar  3 14:38:24 joker PCI: Setting latency timer of device 0000:00:01.0 to 64
> Mar  3 14:38:24 joker NET: Registered protocol family 2
> Mar  3 14:38:24 joker IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
> Mar  3 14:38:24 joker TCP established hash table entries: 16384 (order: 5, 131072 bytes)
> Mar  3 14:38:24 joker TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
> Mar  3 14:38:24 joker TCP: Hash tables configured (established 16384 bind 16384)
> Mar  3 14:38:24 joker TCP reno registered
> Mar  3 14:38:24 joker checking if image is initramfs... it is
> Mar  3 14:38:24 joker Freeing initrd memory: 864k freed
> Mar  3 14:38:24 joker Machine check exception polling timer started.
> Mar  3 14:38:24 joker VFS: Disk quotas dquot_6.5.1
> Mar  3 14:38:24 joker Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> Mar  3 14:38:24 joker io scheduler noop registered
> Mar  3 14:38:24 joker io scheduler anticipatory registered
> Mar  3 14:38:24 joker io scheduler deadline registered
> Mar  3 14:38:24 joker io scheduler cfq registered (default)
> Mar  3 14:38:24 joker PCI: Bypassing VIA 8237 APIC De-Assert Message
> Mar  3 14:38:24 joker input: Power Button (FF) as /class/input/input0
> Mar  3 14:38:24 joker ACPI: Power Button (FF) [PWRF]
> Mar  3 14:38:24 joker input: Power Button (CM) as /class/input/input1
> Mar  3 14:38:24 joker ACPI: Power Button (CM) [PWRB]
> Mar  3 14:38:24 joker input: Sleep Button (CM) as /class/input/input2
> Mar  3 14:38:24 joker ACPI: Sleep Button (CM) [SLPB]
> Mar  3 14:38:24 joker isapnp: Scanning for PnP cards...
> Mar  3 14:38:24 joker isapnp: No Plug & Play device found
> Mar  3 14:38:24 joker Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
> Mar  3 14:38:24 joker serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Mar  3 14:38:24 joker 00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Mar  3 14:38:24 joker RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
> Mar  3 14:38:24 joker loop: loaded (max 8 devices)
> Mar  3 14:38:24 joker PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> Mar  3 14:38:24 joker PNP: PS/2 controller doesn't have AUX irq; using default 12
> Mar  3 14:38:24 joker serio: i8042 KBD port at 0x60,0x64 irq 1
> Mar  3 14:38:24 joker serio: i8042 AUX port at 0x60,0x64 irq 12
> Mar  3 14:38:24 joker mice: PS/2 mouse device common for all mice
> Mar  3 14:38:24 joker TCP cubic registered
> Mar  3 14:38:24 joker NET: Registered protocol family 1
> Mar  3 14:38:24 joker NET: Registered protocol family 17
> Mar  3 14:38:24 joker Using IPI Shortcut mode
> Mar  3 14:38:24 joker Time: tsc clocksource has been installed.
> Mar  3 14:38:24 joker Freeing unused kernel memory: 188k freed
> Mar  3 14:38:24 joker SCSI subsystem initialized
> Mar  3 14:38:24 joker libata version 2.20 loaded.
> Mar  3 14:38:24 joker pata_via 0000:00:0f.1: version 0.2.1
> Mar  3 14:38:24 joker ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 16
> Mar  3 14:38:24 joker ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001fc00 irq 14
> Mar  3 14:38:24 joker ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001fc08 irq 15
> Mar  3 14:38:24 joker scsi0 : pata_via
> Mar  3 14:38:24 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
> Mar  3 14:38:24 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1474f04), AE_AML_OPERAND_VALUE
> Mar  3 14:38:24 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node c147489c), AE_AML_OPERAND_VALUE
> Mar  3 14:38:24 joker ata1.00: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
> Mar  3 14:38:24 joker ata1.00: 160086528 sectors, multi 16: LBA 
> Mar  3 14:38:24 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
> Mar  3 14:38:24 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1474f04), AE_AML_OPERAND_VALUE
> Mar  3 14:38:24 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node c147489c), AE_AML_OPERAND_VALUE
> Mar  3 14:38:24 joker ata1.00: configured for UDMA/133
> Mar  3 14:38:24 joker scsi1 : pata_via
> Mar  3 14:38:24 joker Switched to high resolution mode on CPU 0
> Mar  3 14:38:24 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
> Mar  3 14:38:24 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1474f04), AE_AML_OPERAND_VALUE
> Mar  3 14:38:24 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14747d4), AE_AML_OPERAND_VALUE
> Mar  3 14:38:24 joker ata2.00: ATAPI, max UDMA/33
> Mar  3 14:38:24 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
> Mar  3 14:38:24 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1474f04), AE_AML_OPERAND_VALUE
> Mar  3 14:38:24 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14747d4), AE_AML_OPERAND_VALUE
> Mar  3 14:38:24 joker ata2.01: ATAPI, max UDMA/33
> Mar  3 14:38:24 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
> Mar  3 14:38:24 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1474f04), AE_AML_OPERAND_VALUE
> Mar  3 14:38:24 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14747d4), AE_AML_OPERAND_VALUE
> Mar  3 14:38:24 joker ata2.00: configured for UDMA/33
> Mar  3 14:38:24 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
> Mar  3 14:38:24 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1474f04), AE_AML_OPERAND_VALUE
> Mar  3 14:38:24 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14747d4), AE_AML_OPERAND_VALUE
> Mar  3 14:38:24 joker ata2.01: configured for UDMA/33
> Mar  3 14:38:24 joker scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
> Mar  3 14:38:24 joker scsi 1:0:0:0: CD-ROM            HL-DT-ST CD-RW GCE-8526B  1.03 PQ: 0 ANSI: 5
> Mar  3 14:38:24 joker scsi 1:0:1:0: CD-ROM            LITE-ON  DVD SOHD-167T    9S19 PQ: 0 ANSI: 5
> Mar  3 14:38:24 joker SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
> Mar  3 14:38:24 joker sda: Write Protect is off
> Mar  3 14:38:24 joker sda: Mode Sense: 00 3a 00 00
> Mar  3 14:38:24 joker SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Mar  3 14:38:24 joker SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
> Mar  3 14:38:24 joker sda: Write Protect is off
> Mar  3 14:38:24 joker sda: Mode Sense: 00 3a 00 00
> Mar  3 14:38:24 joker SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Mar  3 14:38:24 joker sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
> Mar  3 14:38:24 joker sd 0:0:0:0: Attached scsi disk sda
> Mar  3 14:38:24 joker sr0: scsi3-mmc drive: 52x/52x writer cd/rw xa/form2 cdda tray
> Mar  3 14:38:24 joker Uniform CD-ROM driver Revision: 3.20
> Mar  3 14:38:24 joker sr 1:0:0:0: Attached scsi CD-ROM sr0
> Mar  3 14:38:24 joker sr1: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
> Mar  3 14:38:24 joker sr 1:0:1:0: Attached scsi CD-ROM sr1
> Mar  3 14:38:24 joker kjournald starting.  Commit interval 5 seconds
> Mar  3 14:38:24 joker EXT3-fs: mounted filesystem with ordered data mode.
> Mar  3 14:38:24 joker usbcore: registered new interface driver usbfs
> Mar  3 14:38:24 joker usbcore: registered new interface driver hub
> Mar  3 14:38:24 joker usbcore: registered new device driver usb
> Mar  3 14:38:24 joker ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 17
> Mar  3 14:38:24 joker Installing spdif_bug patch: Audigy 2 Platinum [SB0240P]
> Mar  3 14:38:24 joker Real Time Clock Driver v1.12ac
> Mar  3 14:38:24 joker i2c /dev entries driver
> Mar  3 14:38:24 joker fuse init (API version 7.8)
> Mar  3 14:38:24 joker sd 0:0:0:0: Attached scsi generic sg0 type 0
> Mar  3 14:38:24 joker sr 1:0:0:0: Attached scsi generic sg1 type 5
> Mar  3 14:38:24 joker sr 1:0:1:0: Attached scsi generic sg2 type 5
> Mar  3 14:38:24 joker input: PC Speaker as /class/input/input3
> Mar  3 14:38:24 joker PPP generic driver version 2.4.2
> Mar  3 14:38:24 joker ieee1394: Initialized config rom entry `ip1394'
> Mar  3 14:38:24 joker gameport: EMU10K1 is pci0000:00:0b.1/gameport0, io 0xec00, speed 1217kHz
> Mar  3 14:38:24 joker ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
> Mar  3 14:38:24 joker rt2500 1.1.0 CVS CVS http://rt2x00.serialmonkey.com
> Mar  3 14:38:24 joker ACPI: PCI Interrupt 0000:00:0b.2[B] -> GSI 16 (level, low) -> IRQ 19
> Mar  3 14:38:24 joker USB Universal Host Controller Interface driver v3.0
> Mar  3 14:38:24 joker ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[dfff9800-dfff9fff]  Max Packet=[2048]  IR/IT contexts=[4/8]
> Mar  3 14:38:24 joker ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 20
> Mar  3 14:38:24 joker uhci_hcd 0000:00:10.0: UHCI Host Controller
> Mar  3 14:38:24 joker uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
> Mar  3 14:38:24 joker uhci_hcd 0000:00:10.0: irq 20, io base 0x0000c000
> Mar  3 14:38:24 joker usb usb1: configuration #1 chosen from 1 choice
> Mar  3 14:38:24 joker hub 1-0:1.0: USB hub found
> Mar  3 14:38:24 joker hub 1-0:1.0: 2 ports detected
> Mar  3 14:38:24 joker ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 20
> Mar  3 14:38:24 joker uhci_hcd 0000:00:10.1: UHCI Host Controller
> Mar  3 14:38:24 joker uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
> Mar  3 14:38:24 joker uhci_hcd 0000:00:10.1: irq 20, io base 0x0000c400
> Mar  3 14:38:24 joker usb usb2: configuration #1 chosen from 1 choice
> Mar  3 14:38:24 joker hub 2-0:1.0: USB hub found
> Mar  3 14:38:24 joker hub 2-0:1.0: 2 ports detected
> Mar  3 14:38:24 joker ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 20
> Mar  3 14:38:24 joker uhci_hcd 0000:00:10.2: UHCI Host Controller
> Mar  3 14:38:24 joker uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
> Mar  3 14:38:24 joker uhci_hcd 0000:00:10.2: irq 20, io base 0x0000c800
> Mar  3 14:38:24 joker usb usb3: configuration #1 chosen from 1 choice
> Mar  3 14:38:24 joker hub 3-0:1.0: USB hub found
> Mar  3 14:38:24 joker hub 3-0:1.0: 2 ports detected
> Mar  3 14:38:24 joker ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 20
> Mar  3 14:38:24 joker uhci_hcd 0000:00:10.3: UHCI Host Controller
> Mar  3 14:38:24 joker uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
> Mar  3 14:38:24 joker uhci_hcd 0000:00:10.3: irq 20, io base 0x0000cc00
> Mar  3 14:38:24 joker usb usb4: configuration #1 chosen from 1 choice
> Mar  3 14:38:24 joker hub 4-0:1.0: USB hub found
> Mar  3 14:38:24 joker hub 4-0:1.0: 2 ports detected
> Mar  3 14:38:24 joker usb 2-1: new low speed USB device using uhci_hcd and address 2
> Mar  3 14:38:24 joker ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 20
> Mar  3 14:38:24 joker ehci_hcd 0000:00:10.4: EHCI Host Controller
> Mar  3 14:38:24 joker ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
> Mar  3 14:38:24 joker ehci_hcd 0000:00:10.4: irq 20, io mem 0xdfff9600
> Mar  3 14:38:24 joker ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> Mar  3 14:38:24 joker usb usb5: configuration #1 chosen from 1 choice
> Mar  3 14:38:24 joker hub 5-0:1.0: USB hub found
> Mar  3 14:38:24 joker hub 5-0:1.0: 8 ports detected
> Mar  3 14:38:24 joker usb 2-1: unable to read config index 0 descriptor/start
> Mar  3 14:38:24 joker usb 2-1: chopping to 0 config(s)
> Mar  3 14:38:24 joker usb 2-1: no configuration chosen from 0 choices
> Mar  3 14:38:24 joker parport: PnPBIOS parport detected.
> Mar  3 14:38:24 joker parport0: PC-style at 0x378 (0x778), irq 7, dma 0 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
> Mar  3 14:38:24 joker sata_via 0000:00:0f.0: version 2.1
> Mar  3 14:38:24 joker ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 16
> Mar  3 14:38:24 joker sata_via 0000:00:0f.0: routed to hard irq line 10
> Mar  3 14:38:24 joker ata3: SATA max UDMA/133 cmd 0x0001e800 ctl 0x0001e402 bmdma 0x0001d800 irq 16
> Mar  3 14:38:24 joker ata4: SATA max UDMA/133 cmd 0x0001e000 ctl 0x0001dc02 bmdma 0x0001d808 irq 16
> Mar  3 14:38:24 joker scsi2 : sata_via
> Mar  3 14:38:24 joker rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
> Mar  3 14:38:24 joker pnp: Device 00:07 does not support disabling.
> Mar  3 14:38:24 joker rtc_cmos: probe of 00:07 failed with error -16
> Mar  3 14:38:24 joker ata3: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
> Mar  3 14:38:24 joker ATA: abnormal status 0x7F on port 0x0001e807
> Mar  3 14:38:24 joker scsi3 : sata_via
> Mar  3 14:38:24 joker via-rhine.c:v1.10-LK1.4.2 Sept-11-2006 Written by Donald Becker
> Mar  3 14:38:24 joker ata4: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
> Mar  3 14:38:24 joker ATA: abnormal status 0x7F on port 0x0001e007
> Mar  3 14:38:24 joker ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 21
> Mar  3 14:38:24 joker PCI: Setting latency timer of device 0000:00:11.5 to 64
> Mar  3 14:38:24 joker usb 2-1: USB disconnect, address 2
> Mar  3 14:38:24 joker ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023c00910047b3]
> Mar  3 14:38:24 joker lp0: using parport0 (interrupt-driven).
> Mar  3 14:38:24 joker ppdev: user-space parallel port driver
> Mar  3 14:38:24 joker usb 2-1: new low speed USB device using uhci_hcd and address 3
> Mar  3 14:38:24 joker ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 23 (level, low) -> IRQ 22
> Mar  3 14:38:24 joker eth0: VIA Rhine II at 0xdfff9500, 00:0b:6a:99:27:12, IRQ 22.
> Mar  3 14:38:24 joker eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link 0021.
> Mar  3 14:38:24 joker usb 2-1: configuration #1 chosen from 1 choice
> Mar  3 14:38:24 joker usbcore: registered new interface driver hiddev
> Mar  3 14:38:24 joker input: HID 1241:1177 as /class/input/input4
> Mar  3 14:38:24 joker input: USB HID v1.00 Mouse [HID 1241:1177] on usb-0000:00:10.1-1
> Mar  3 14:38:24 joker usbcore: registered new interface driver usbhid
> Mar  3 14:38:24 joker drivers/usb/input/hid-core.c: v2.6:USB HID core driver
> Mar  3 14:38:24 joker EXT3 FS on sda2, internal journal
> Mar  3 14:38:24 joker Adding 1534168k swap on /dev/disk/by-label/swap.  Priority:-1 extents:1 across:1534168k
> Mar  3 14:38:24 joker init: Going single user
> 
> An here's one with irqfixup (after a cold boot - doesn't always work after a warm boot) (keyboard works):
> Mar  3 14:41:52 joker syslog-ng[4191]: syslog-ng starting up; version='2.0.0' 
> Mar  3 14:41:52 joker 000 (usable)
> Mar  3 14:41:52 joker user-defined physical RAM map:
> Mar  3 14:41:52 joker user: 0000000000000000 - 000000000009fc00 (usable)
> Mar  3 14:41:52 joker user: 000000000009fc00 - 00000000000a0000 (reserved)
> Mar  3 14:41:52 joker user: 00000000000f0000 - 0000000000100000 (reserved)
> Mar  3 14:41:52 joker user: 0000000000100000 - 000000001fff0000 (usable)
> Mar  3 14:41:52 joker 511MB LOWMEM available.
> Mar  3 14:41:52 joker Entering add_active_range(0, 0, 131056) 0 entries of 256 used
> Mar  3 14:41:52 joker Zone PFN ranges:
> Mar  3 14:41:52 joker DMA             0 ->     4096
> Mar  3 14:41:52 joker Normal       4096 ->   131056
> Mar  3 14:41:52 joker early_node_map[1] active PFN ranges
> Mar  3 14:41:52 joker 0:        0 ->   131056
> Mar  3 14:41:52 joker On node 0 totalpages: 131056
> Mar  3 14:41:52 joker DMA zone: 32 pages used for memmap
> Mar  3 14:41:52 joker DMA zone: 0 pages reserved
> Mar  3 14:41:52 joker DMA zone: 4064 pages, LIFO batch:0
> Mar  3 14:41:52 joker Normal zone: 991 pages used for memmap
> Mar  3 14:41:52 joker Normal zone: 125969 pages, LIFO batch:31
> Mar  3 14:41:52 joker DMI 2.3 present.
> Mar  3 14:41:52 joker ACPI: RSDP 000FA8C0, 0014 (r0 AMI   )
> Mar  3 14:41:52 joker ACPI: RSDT 1FFF0000, 002C (r1 AMIINT VIA_K7         10 MSFT       97)
> Mar  3 14:41:52 joker ACPI: FACP 1FFF0030, 0081 (r1 AMIINT VIA_K7         11 MSFT       97)
> Mar  3 14:41:52 joker ACPI: DSDT 1FFF0120, 3502 (r1    VIA    K7VT4     1000 MSFT  100000D)
> Mar  3 14:41:52 joker ACPI: FACS 1FFF8000, 0040
> Mar  3 14:41:52 joker ACPI: APIC 1FFF00C0, 0054 (r1 AMIINT VIA_K7          9 MSFT       97)
> Mar  3 14:41:52 joker ACPI: PM-Timer IO Port: 0x808
> Mar  3 14:41:52 joker ACPI: Local APIC address 0xfee00000
> Mar  3 14:41:52 joker ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> Mar  3 14:41:52 joker Processor #0 6:10 APIC version 16
> Mar  3 14:41:52 joker ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> Mar  3 14:41:52 joker IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
> Mar  3 14:41:52 joker ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> Mar  3 14:41:52 joker ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> Mar  3 14:41:52 joker ACPI: IRQ0 used by override.
> Mar  3 14:41:52 joker ACPI: IRQ2 used by override.
> Mar  3 14:41:52 joker ACPI: IRQ9 used by override.
> Mar  3 14:41:52 joker Enabling APIC mode:  Flat.  Using 1 I/O APICs
> Mar  3 14:41:52 joker Using ACPI (MADT) for SMP configuration information
> Mar  3 14:41:52 joker Allocating PCI resources starting at 20000000 (gap: 1fff0000:e0010000)
> Mar  3 14:41:52 joker Detected 2198.080 MHz processor.
> Mar  3 14:41:52 joker Built 1 zonelists.  Total pages: 130033
> Mar  3 14:41:52 joker Kernel command line: root=/dev/disk/by-label/root vga=ext ro agp=off irqfixup mem=524224K
> Mar  3 14:41:52 joker Misrouted IRQ fixup support enabled.
> Mar  3 14:41:52 joker This may impact system performance.
> Mar  3 14:41:52 joker mapped APIC to ffffd000 (fee00000)
> Mar  3 14:41:52 joker mapped IOAPIC to ffffc000 (fec00000)
> Mar  3 14:41:52 joker Enabling fast FPU save and restore... done.
> Mar  3 14:41:52 joker Enabling unmasked SIMD FPU exception support... done.
> Mar  3 14:41:52 joker Initializing CPU#0
> Mar  3 14:41:52 joker CPU 0 irqstacks, hard=c0306000 soft=c0305000
> Mar  3 14:41:52 joker PID hash table entries: 2048 (order: 11, 8192 bytes)
> Mar  3 14:41:52 joker Console: colour VGA+ 80x50
> Mar  3 14:41:52 joker Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> Mar  3 14:41:52 joker Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> Mar  3 14:41:52 joker Memory: 516036k/524224k available (1321k kernel code, 7612k reserved, 533k data, 188k init, 0k highmem)
> Mar  3 14:41:52 joker virtual kernel memory layout:
> Mar  3 14:41:52 joker fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
> Mar  3 14:41:52 joker vmalloc : 0xe0800000 - 0xfffb5000   ( 503 MB)
> Mar  3 14:41:52 joker lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
> Mar  3 14:41:52 joker .init : 0xc02d1000 - 0xc0300000   ( 188 kB)
> Mar  3 14:41:52 joker .data : 0xc024a4cd - 0xc02cf9b4   ( 533 kB)
> Mar  3 14:41:52 joker .text : 0xc0100000 - 0xc024a4cd   (1321 kB)
> Mar  3 14:41:52 joker Checking if this processor honours the WP bit even in supervisor mode... Ok.
> Mar  3 14:41:52 joker Calibrating delay using timer specific routine.. 4405.92 BogoMIPS (lpj=2546145)
> Mar  3 14:41:52 joker Mount-cache hash table entries: 512
> Mar  3 14:41:52 joker CPU: After generic identify, caps: 0383fbff c1c3fbff 00000000 00000000 00000000 00000000 00000000
> Mar  3 14:41:52 joker CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> Mar  3 14:41:52 joker CPU: L2 Cache: 512K (64 bytes/line)
> Mar  3 14:41:52 joker CPU: After all inits, caps: 0383fbff c1c3fbff 00000000 00000420 00000000 00000000 00000000
> Mar  3 14:41:52 joker Intel machine check architecture supported.
> Mar  3 14:41:52 joker Intel machine check reporting enabled on CPU#0.
> Mar  3 14:41:52 joker CPU: AMD Athlon(tm) XP 3200+ stepping 00
> Mar  3 14:41:52 joker Checking 'hlt' instruction... OK.
> Mar  3 14:41:52 joker ACPI: Core revision 20070126
> Mar  3 14:41:52 joker ENABLING IO-APIC IRQs
> Mar  3 14:41:52 joker ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> Mar  3 14:41:52 joker NET: Registered protocol family 16
> Mar  3 14:41:52 joker ACPI: bus type pci registered
> Mar  3 14:41:52 joker PCI: PCI BIOS revision 2.10 entry at 0xfda71, last bus=1
> Mar  3 14:41:52 joker PCI: Using configuration type 1
> Mar  3 14:41:52 joker Setting up standard PCI resources
> Mar  3 14:41:52 joker ACPI: Interpreter enabled
> Mar  3 14:41:52 joker ACPI: (supports S0 S1 S3 S4 S5)
> Mar  3 14:41:52 joker ACPI: Using IOAPIC for interrupt routing
> Mar  3 14:41:52 joker ACPI: PCI Root Bridge [PCI0] (0000:00)
> Mar  3 14:41:52 joker PCI: Probing PCI hardware (bus 00)
> Mar  3 14:41:52 joker Boot video device is 0000:01:00.0
> Mar  3 14:41:52 joker ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> Mar  3 14:41:52 joker ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 12 14 15)
> Mar  3 14:41:52 joker ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11 12 14 15)
> Mar  3 14:41:52 joker ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 *12 14 15)
> Mar  3 14:41:52 joker ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 10 11 12 14 15)
> Mar  3 14:41:52 joker ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
> Mar  3 14:41:52 joker ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
> Mar  3 14:41:52 joker ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
> Mar  3 14:41:52 joker ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
> Mar  3 14:41:52 joker ACPI: Power Resource [URP1] (off)
> Mar  3 14:41:52 joker ACPI: Power Resource [URP2] (off)
> Mar  3 14:41:52 joker ACPI: Power Resource [FDDP] (off)
> Mar  3 14:41:52 joker ACPI: Power Resource [LPTP] (off)
> Mar  3 14:41:52 joker Linux Plug and Play Support v0.97 (c) Adam Belay
> Mar  3 14:41:52 joker pnp: PnP ACPI init
> Mar  3 14:41:52 joker pnp: PnP ACPI: found 11 devices
> Mar  3 14:41:52 joker PCI: Using ACPI for IRQ routing
> Mar  3 14:41:52 joker PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> Mar  3 14:41:52 joker pnp: 00:05: iomem range 0xfec00000-0xfec00fff has been reserved
> Mar  3 14:41:52 joker pnp: 00:05: iomem range 0xfee00000-0xfee00fff has been reserved
> Mar  3 14:41:52 joker PCI: Bridge: 0000:00:01.0
> Mar  3 14:41:52 joker IO window: disabled.
> Mar  3 14:41:52 joker MEM window: dde00000-dfefffff
> Mar  3 14:41:52 joker PREFETCH window: cdd00000-ddcfffff
> Mar  3 14:41:52 joker PCI: Setting latency timer of device 0000:00:01.0 to 64
> Mar  3 14:41:52 joker NET: Registered protocol family 2
> Mar  3 14:41:52 joker IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
> Mar  3 14:41:52 joker TCP established hash table entries: 16384 (order: 5, 131072 bytes)
> Mar  3 14:41:52 joker TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
> Mar  3 14:41:52 joker TCP: Hash tables configured (established 16384 bind 16384)
> Mar  3 14:41:52 joker TCP reno registered
> Mar  3 14:41:52 joker checking if image is initramfs... it is
> Mar  3 14:41:52 joker Freeing initrd memory: 864k freed
> Mar  3 14:41:52 joker Machine check exception polling timer started.
> Mar  3 14:41:52 joker VFS: Disk quotas dquot_6.5.1
> Mar  3 14:41:52 joker Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> Mar  3 14:41:52 joker io scheduler noop registered
> Mar  3 14:41:52 joker io scheduler anticipatory registered
> Mar  3 14:41:52 joker io scheduler deadline registered
> Mar  3 14:41:52 joker io scheduler cfq registered (default)
> Mar  3 14:41:52 joker PCI: Bypassing VIA 8237 APIC De-Assert Message
> Mar  3 14:41:52 joker input: Power Button (FF) as /class/input/input0
> Mar  3 14:41:52 joker ACPI: Power Button (FF) [PWRF]
> Mar  3 14:41:52 joker input: Power Button (CM) as /class/input/input1
> Mar  3 14:41:52 joker ACPI: Power Button (CM) [PWRB]
> Mar  3 14:41:52 joker input: Sleep Button (CM) as /class/input/input2
> Mar  3 14:41:52 joker ACPI: Sleep Button (CM) [SLPB]
> Mar  3 14:41:52 joker isapnp: Scanning for PnP cards...
> Mar  3 14:41:52 joker isapnp: No Plug & Play device found
> Mar  3 14:41:52 joker Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
> Mar  3 14:41:52 joker serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Mar  3 14:41:52 joker 00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Mar  3 14:41:52 joker RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
> Mar  3 14:41:52 joker loop: loaded (max 8 devices)
> Mar  3 14:41:52 joker PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> Mar  3 14:41:52 joker PNP: PS/2 controller doesn't have AUX irq; using default 12
> Mar  3 14:41:52 joker serio: i8042 KBD port at 0x60,0x64 irq 1
> Mar  3 14:41:52 joker serio: i8042 AUX port at 0x60,0x64 irq 12
> Mar  3 14:41:52 joker mice: PS/2 mouse device common for all mice
> Mar  3 14:41:52 joker TCP cubic registered
> Mar  3 14:41:52 joker NET: Registered protocol family 1
> Mar  3 14:41:52 joker NET: Registered protocol family 17
> Mar  3 14:41:52 joker Using IPI Shortcut mode
> Mar  3 14:41:52 joker Time: tsc clocksource has been installed.
> Mar  3 14:41:52 joker Freeing unused kernel memory: 188k freed
> Mar  3 14:41:52 joker SCSI subsystem initialized
> Mar  3 14:41:52 joker libata version 2.20 loaded.
> Mar  3 14:41:52 joker pata_via 0000:00:0f.1: version 0.2.1
> Mar  3 14:41:52 joker ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 16
> Mar  3 14:41:52 joker ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001fc00 irq 14
> Mar  3 14:41:52 joker ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001fc08 irq 15
> Mar  3 14:41:52 joker scsi0 : pata_via
> Mar  3 14:41:52 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
> Mar  3 14:41:52 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1474f04), AE_AML_OPERAND_VALUE
> Mar  3 14:41:52 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node c147489c), AE_AML_OPERAND_VALUE
> Mar  3 14:41:52 joker ata1.00: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
> Mar  3 14:41:52 joker ata1.00: 160086528 sectors, multi 16: LBA 
> Mar  3 14:41:52 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
> Mar  3 14:41:52 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1474f04), AE_AML_OPERAND_VALUE
> Mar  3 14:41:52 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node c147489c), AE_AML_OPERAND_VALUE
> Mar  3 14:41:52 joker ata1.00: configured for UDMA/133
> Mar  3 14:41:52 joker scsi1 : pata_via
> Mar  3 14:41:52 joker Switched to high resolution mode on CPU 0
> Mar  3 14:41:52 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
> Mar  3 14:41:52 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1474f04), AE_AML_OPERAND_VALUE
> Mar  3 14:41:52 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14747d4), AE_AML_OPERAND_VALUE
> Mar  3 14:41:52 joker ata2.00: ATAPI, max UDMA/33
> Mar  3 14:41:52 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
> Mar  3 14:41:52 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1474f04), AE_AML_OPERAND_VALUE
> Mar  3 14:41:52 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14747d4), AE_AML_OPERAND_VALUE
> Mar  3 14:41:52 joker ata2.01: ATAPI, max UDMA/33
> Mar  3 14:41:52 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
> Mar  3 14:41:52 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1474f04), AE_AML_OPERAND_VALUE
> Mar  3 14:41:52 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14747d4), AE_AML_OPERAND_VALUE
> Mar  3 14:41:52 joker ata2.00: configured for UDMA/33
> Mar  3 14:41:52 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
> Mar  3 14:41:52 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1474f04), AE_AML_OPERAND_VALUE
> Mar  3 14:41:52 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14747d4), AE_AML_OPERAND_VALUE
> Mar  3 14:41:52 joker ata2.01: configured for UDMA/33
> Mar  3 14:41:52 joker scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
> Mar  3 14:41:52 joker scsi 1:0:0:0: CD-ROM            HL-DT-ST CD-RW GCE-8526B  1.03 PQ: 0 ANSI: 5
> Mar  3 14:41:52 joker scsi 1:0:1:0: CD-ROM            LITE-ON  DVD SOHD-167T    9S19 PQ: 0 ANSI: 5
> Mar  3 14:41:52 joker SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
> Mar  3 14:41:52 joker sda: Write Protect is off
> Mar  3 14:41:52 joker sda: Mode Sense: 00 3a 00 00
> Mar  3 14:41:52 joker SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Mar  3 14:41:52 joker SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
> Mar  3 14:41:52 joker sda: Write Protect is off
> Mar  3 14:41:52 joker sda: Mode Sense: 00 3a 00 00
> Mar  3 14:41:52 joker SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Mar  3 14:41:52 joker sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
> Mar  3 14:41:52 joker sd 0:0:0:0: Attached scsi disk sda
> Mar  3 14:41:52 joker sr0: scsi3-mmc drive: 52x/52x writer cd/rw xa/form2 cdda tray
> Mar  3 14:41:52 joker Uniform CD-ROM driver Revision: 3.20
> Mar  3 14:41:52 joker sr 1:0:0:0: Attached scsi CD-ROM sr0
> Mar  3 14:41:52 joker sr1: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
> Mar  3 14:41:52 joker sr 1:0:1:0: Attached scsi CD-ROM sr1
> Mar  3 14:41:52 joker input: AT Translated Set 2 keyboard as /class/input/input3
> Mar  3 14:41:52 joker EXT3-fs: INFO: recovery required on readonly filesystem.
> Mar  3 14:41:52 joker EXT3-fs: write access will be enabled during recovery.
> Mar  3 14:41:52 joker kjournald starting.  Commit interval 5 seconds
> Mar  3 14:41:52 joker EXT3-fs: recovery complete.
> Mar  3 14:41:52 joker EXT3-fs: mounted filesystem with ordered data mode.
> Mar  3 14:41:52 joker usbcore: registered new interface driver usbfs
> Mar  3 14:41:52 joker usbcore: registered new interface driver hub
> Mar  3 14:41:52 joker usbcore: registered new device driver usb
> Mar  3 14:41:52 joker ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 17
> Mar  3 14:41:52 joker Installing spdif_bug patch: Audigy 2 Platinum [SB0240P]
> Mar  3 14:41:52 joker Real Time Clock Driver v1.12ac
> Mar  3 14:41:52 joker i2c /dev entries driver
> Mar  3 14:41:52 joker fuse init (API version 7.8)
> Mar  3 14:41:52 joker sd 0:0:0:0: Attached scsi generic sg0 type 0
> Mar  3 14:41:52 joker sr 1:0:0:0: Attached scsi generic sg1 type 5
> Mar  3 14:41:52 joker sr 1:0:1:0: Attached scsi generic sg2 type 5
> Mar  3 14:41:52 joker gameport: EMU10K1 is pci0000:00:0b.1/gameport0, io 0xec00, speed 1217kHz
> Mar  3 14:41:52 joker ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
> Mar  3 14:41:52 joker rt2500 1.1.0 CVS CVS http://rt2x00.serialmonkey.com
> Mar  3 14:41:52 joker ieee1394: Initialized config rom entry `ip1394'
> Mar  3 14:41:52 joker PPP generic driver version 2.4.2
> Mar  3 14:41:52 joker ACPI: PCI Interrupt 0000:00:0b.2[B] -> GSI 16 (level, low) -> IRQ 19
> Mar  3 14:41:52 joker parport: PnPBIOS parport detected.
> Mar  3 14:41:52 joker parport0: PC-style at 0x378 (0x778), irq 7, dma 0 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
> Mar  3 14:41:52 joker rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
> Mar  3 14:41:52 joker pnp: Device 00:07 does not support disabling.
> Mar  3 14:41:52 joker rtc_cmos: probe of 00:07 failed with error -16
> Mar  3 14:41:52 joker input: PC Speaker as /class/input/input4
> Mar  3 14:41:52 joker USB Universal Host Controller Interface driver v3.0
> Mar  3 14:41:52 joker ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[dfff9800-dfff9fff]  Max Packet=[2048]  IR/IT contexts=[4/8]
> Mar  3 14:41:52 joker sata_via 0000:00:0f.0: version 2.1
> Mar  3 14:41:52 joker ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 16
> Mar  3 14:41:52 joker sata_via 0000:00:0f.0: routed to hard irq line 10
> Mar  3 14:41:52 joker ata3: SATA max UDMA/133 cmd 0x0001e800 ctl 0x0001e402 bmdma 0x0001d800 irq 16
> Mar  3 14:41:52 joker ata4: SATA max UDMA/133 cmd 0x0001e000 ctl 0x0001dc02 bmdma 0x0001d808 irq 16
> Mar  3 14:41:52 joker scsi2 : sata_via
> Mar  3 14:41:52 joker lp0: using parport0 (interrupt-driven).
> Mar  3 14:41:52 joker ppdev: user-space parallel port driver
> Mar  3 14:41:52 joker ata3: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
> Mar  3 14:41:52 joker ATA: abnormal status 0x7F on port 0x0001e807
> Mar  3 14:41:52 joker scsi3 : sata_via
> Mar  3 14:41:52 joker ata4: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
> Mar  3 14:41:52 joker ATA: abnormal status 0x7F on port 0x0001e007
> Mar  3 14:41:52 joker ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 20
> Mar  3 14:41:52 joker uhci_hcd 0000:00:10.0: UHCI Host Controller
> Mar  3 14:41:52 joker uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
> Mar  3 14:41:52 joker uhci_hcd 0000:00:10.0: irq 20, io base 0x0000c000
> Mar  3 14:41:52 joker usb usb1: configuration #1 chosen from 1 choice
> Mar  3 14:41:52 joker hub 1-0:1.0: USB hub found
> Mar  3 14:41:52 joker hub 1-0:1.0: 2 ports detected
> Mar  3 14:41:52 joker via-rhine.c:v1.10-LK1.4.2 Sept-11-2006 Written by Donald Becker
> Mar  3 14:41:52 joker atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
> Mar  3 14:41:52 joker ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 20
> Mar  3 14:41:52 joker uhci_hcd 0000:00:10.1: UHCI Host Controller
> Mar  3 14:41:52 joker uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
> Mar  3 14:41:52 joker uhci_hcd 0000:00:10.1: irq 20, io base 0x0000c400
> Mar  3 14:41:52 joker usb usb2: configuration #1 chosen from 1 choice
> Mar  3 14:41:52 joker hub 2-0:1.0: USB hub found
> Mar  3 14:41:52 joker hub 2-0:1.0: 2 ports detected
> Mar  3 14:41:52 joker ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 20
> Mar  3 14:41:52 joker uhci_hcd 0000:00:10.2: UHCI Host Controller
> Mar  3 14:41:52 joker uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
> Mar  3 14:41:52 joker uhci_hcd 0000:00:10.2: irq 20, io base 0x0000c800
> Mar  3 14:41:52 joker usb usb3: configuration #1 chosen from 1 choice
> Mar  3 14:41:52 joker hub 3-0:1.0: USB hub found
> Mar  3 14:41:52 joker hub 3-0:1.0: 2 ports detected
> Mar  3 14:41:52 joker ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 20
> Mar  3 14:41:52 joker uhci_hcd 0000:00:10.3: UHCI Host Controller
> Mar  3 14:41:52 joker uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
> Mar  3 14:41:52 joker uhci_hcd 0000:00:10.3: irq 20, io base 0x0000cc00
> Mar  3 14:41:52 joker usb usb4: configuration #1 chosen from 1 choice
> Mar  3 14:41:52 joker hub 4-0:1.0: USB hub found
> Mar  3 14:41:52 joker hub 4-0:1.0: 2 ports detected
> Mar  3 14:41:52 joker ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 20
> Mar  3 14:41:52 joker ehci_hcd 0000:00:10.4: EHCI Host Controller
> Mar  3 14:41:52 joker ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
> Mar  3 14:41:52 joker ehci_hcd 0000:00:10.4: irq 20, io mem 0xdfff9600
> Mar  3 14:41:52 joker ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> Mar  3 14:41:52 joker usb usb5: configuration #1 chosen from 1 choice
> Mar  3 14:41:52 joker hub 5-0:1.0: USB hub found
> Mar  3 14:41:52 joker hub 5-0:1.0: 8 ports detected
> Mar  3 14:41:52 joker ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 21
> Mar  3 14:41:52 joker PCI: Setting latency timer of device 0000:00:11.5 to 64
> Mar  3 14:41:52 joker ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023c00910047b3]
> Mar  3 14:41:52 joker ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 23 (level, low) -> IRQ 22
> Mar  3 14:41:52 joker eth0: VIA Rhine II at 0xdfff9500, 00:0b:6a:99:27:12, IRQ 22.
> Mar  3 14:41:52 joker eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link 0021.
> Mar  3 14:41:52 joker usb 2-1: new low speed USB device using uhci_hcd and address 2
> Mar  3 14:41:52 joker EXT3 FS on sda2, internal journal
> Mar  3 14:41:52 joker usb 2-1: configuration #1 chosen from 1 choice
> Mar  3 14:41:52 joker Adding 1534168k swap on /dev/disk/by-label/swap.  Priority:-1 extents:1 across:1534168k
> Mar  3 14:41:52 joker usbcore: registered new interface driver hiddev
> Mar  3 14:41:52 joker input: HID 1241:1177 as /class/input/input5
> Mar  3 14:41:52 joker input: USB HID v1.00 Mouse [HID 1241:1177] on usb-0000:00:10.1-1
> Mar  3 14:41:52 joker usbcore: registered new interface driver usbhid
> Mar  3 14:41:52 joker drivers/usb/input/hid-core.c: v2.6:USB HID core driver
> Mar  3 14:41:52 joker init: Going single user
> Mar  3 14:42:25 joker shutdown[4197]: shutting down for system reboot
> Mar  3 14:42:25 joker init: Switching to runlevel: 6
> Mar  3 14:42:26 joker syslog-ng[4191]: SIGTERM received, terminating;  
> Mar  3 14:42:26 joker syslog-ng[4191]: syslog-ng shutting down; version='2.0.0' 
> 
> And here's one with pci=noacpi (keyboard works):
> Mar  3 14:43:13 joker syslog-ng[4211]: syslog-ng starting up; version='2.0.0' 
> Mar  3 14:43:13 joker fef0000 end: 000000001fff0000 type: 1
> Mar  3 14:43:13 joker copy_e820_map() type is E820_RAM
> Mar  3 14:43:13 joker copy_e820_map() start: 000000001fff0000 size: 0000000000008000 end: 000000001fff8000 type: 3
> Mar  3 14:43:13 joker copy_e820_map() start: 000000001fff8000 size: 0000000000008000 end: 0000000020000000 type: 4
> Mar  3 14:43:13 joker copy_e820_map() start: 00000000fec00000 size: 0000000000001000 end: 00000000fec01000 type: 2
> Mar  3 14:43:13 joker copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end: 00000000fee01000 type: 2
> Mar  3 14:43:13 joker copy_e820_map() start: 00000000fff80000 size: 0000000000080000 end: 0000000100000000 type: 2
> Mar  3 14:43:13 joker BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> Mar  3 14:43:13 joker BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> Mar  3 14:43:13 joker BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> Mar  3 14:43:13 joker BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
> Mar  3 14:43:13 joker BIOS-e820: 000000001fff0000 - 000000001fff8000 (ACPI data)
> Mar  3 14:43:13 joker BIOS-e820: 000000001fff8000 - 0000000020000000 (ACPI NVS)
> Mar  3 14:43:13 joker BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> Mar  3 14:43:13 joker BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> Mar  3 14:43:13 joker BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
> Mar  3 14:43:13 joker limit_regions start: 0000000000000000 - 000000000009fc00 (usable)
> Mar  3 14:43:13 joker limit_regions start: 000000000009fc00 - 00000000000a0000 (reserved)
> Mar  3 14:43:13 joker limit_regions start: 00000000000f0000 - 0000000000100000 (reserved)
> Mar  3 14:43:13 joker limit_regions start: 0000000000100000 - 000000001fff0000 (usable)
> Mar  3 14:43:13 joker limit_regions start: 000000001fff0000 - 000000001fff8000 (ACPI data)
> Mar  3 14:43:13 joker limit_regions start: 000000001fff8000 - 0000000020000000 (ACPI NVS)
> Mar  3 14:43:13 joker limit_regions start: 00000000fec00000 - 00000000fec01000 (reserved)
> Mar  3 14:43:13 joker limit_regions start: 00000000fee00000 - 00000000fee01000 (reserved)
> Mar  3 14:43:13 joker limit_regions start: 00000000fff80000 - 0000000100000000 (reserved)
> Mar  3 14:43:13 joker limit_regions endfor: 0000000000000000 - 000000000009fc00 (usable)
> Mar  3 14:43:13 joker limit_regions endfor: 000000000009fc00 - 00000000000a0000 (reserved)
> Mar  3 14:43:13 joker limit_regions endfor: 00000000000f0000 - 0000000000100000 (reserved)
> Mar  3 14:43:13 joker limit_regions endfor: 0000000000100000 - 000000001fff0000 (usable)
> Mar  3 14:43:13 joker user-defined physical RAM map:
> Mar  3 14:43:13 joker user: 0000000000000000 - 000000000009fc00 (usable)
> Mar  3 14:43:13 joker user: 000000000009fc00 - 00000000000a0000 (reserved)
> Mar  3 14:43:13 joker user: 00000000000f0000 - 0000000000100000 (reserved)
> Mar  3 14:43:13 joker user: 0000000000100000 - 000000001fff0000 (usable)
> Mar  3 14:43:13 joker 511MB LOWMEM available.
> Mar  3 14:43:13 joker Entering add_active_range(0, 0, 131056) 0 entries of 256 used
> Mar  3 14:43:13 joker Zone PFN ranges:
> Mar  3 14:43:13 joker DMA             0 ->     4096
> Mar  3 14:43:13 joker Normal       4096 ->   131056
> Mar  3 14:43:13 joker early_node_map[1] active PFN ranges
> Mar  3 14:43:13 joker 0:        0 ->   131056
> Mar  3 14:43:13 joker On node 0 totalpages: 131056
> Mar  3 14:43:13 joker DMA zone: 32 pages used for memmap
> Mar  3 14:43:13 joker DMA zone: 0 pages reserved
> Mar  3 14:43:13 joker DMA zone: 4064 pages, LIFO batch:0
> Mar  3 14:43:13 joker Normal zone: 991 pages used for memmap
> Mar  3 14:43:13 joker Normal zone: 125969 pages, LIFO batch:31
> Mar  3 14:43:13 joker DMI 2.3 present.
> Mar  3 14:43:13 joker ACPI: RSDP 000FA8C0, 0014 (r0 AMI   )
> Mar  3 14:43:13 joker ACPI: RSDT 1FFF0000, 002C (r1 AMIINT VIA_K7         10 MSFT       97)
> Mar  3 14:43:13 joker ACPI: FACP 1FFF0030, 0081 (r1 AMIINT VIA_K7         11 MSFT       97)
> Mar  3 14:43:13 joker ACPI: DSDT 1FFF0120, 3502 (r1    VIA    K7VT4     1000 MSFT  100000D)
> Mar  3 14:43:13 joker ACPI: FACS 1FFF8000, 0040
> Mar  3 14:43:13 joker ACPI: APIC 1FFF00C0, 0054 (r1 AMIINT VIA_K7          9 MSFT       97)
> Mar  3 14:43:13 joker ACPI: PM-Timer IO Port: 0x808
> Mar  3 14:43:13 joker ACPI: Local APIC address 0xfee00000
> Mar  3 14:43:13 joker ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> Mar  3 14:43:13 joker Processor #0 6:10 APIC version 16
> Mar  3 14:43:13 joker Allocating PCI resources starting at 20000000 (gap: 1fff0000:e0010000)
> Mar  3 14:43:13 joker Detected 2198.080 MHz processor.
> Mar  3 14:43:13 joker Built 1 zonelists.  Total pages: 130033
> Mar  3 14:43:13 joker Kernel command line: root=/dev/disk/by-label/root vga=ext ro agp=off pci=noacpi mem=524224K
> Mar  3 14:43:13 joker Found and enabled local APIC!
> Mar  3 14:43:13 joker mapped APIC to ffffd000 (fee00000)
> Mar  3 14:43:13 joker Enabling fast FPU save and restore... done.
> Mar  3 14:43:13 joker Enabling unmasked SIMD FPU exception support... done.
> Mar  3 14:43:13 joker Initializing CPU#0
> Mar  3 14:43:13 joker CPU 0 irqstacks, hard=c0306000 soft=c0305000
> Mar  3 14:43:13 joker PID hash table entries: 2048 (order: 11, 8192 bytes)
> Mar  3 14:43:13 joker Console: colour VGA+ 80x50
> Mar  3 14:43:13 joker Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> Mar  3 14:43:13 joker Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> Mar  3 14:43:13 joker Memory: 516036k/524224k available (1321k kernel code, 7612k reserved, 533k data, 188k init, 0k highmem)
> Mar  3 14:43:13 joker virtual kernel memory layout:
> Mar  3 14:43:13 joker fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
> Mar  3 14:43:13 joker vmalloc : 0xe0800000 - 0xfffb5000   ( 503 MB)
> Mar  3 14:43:13 joker lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
> Mar  3 14:43:13 joker .init : 0xc02d1000 - 0xc0300000   ( 188 kB)
> Mar  3 14:43:13 joker .data : 0xc024a4cd - 0xc02cf9b4   ( 533 kB)
> Mar  3 14:43:13 joker .text : 0xc0100000 - 0xc024a4cd   (1321 kB)
> Mar  3 14:43:13 joker Checking if this processor honours the WP bit even in supervisor mode... Ok.
> Mar  3 14:43:13 joker Calibrating delay using timer specific routine.. 4405.91 BogoMIPS (lpj=2546144)
> Mar  3 14:43:13 joker Mount-cache hash table entries: 512
> Mar  3 14:43:13 joker CPU: After generic identify, caps: 0383fbff c1c3fbff 00000000 00000000 00000000 00000000 00000000
> Mar  3 14:43:13 joker CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> Mar  3 14:43:13 joker CPU: L2 Cache: 512K (64 bytes/line)
> Mar  3 14:43:13 joker CPU: After all inits, caps: 0383fbff c1c3fbff 00000000 00000420 00000000 00000000 00000000
> Mar  3 14:43:13 joker Intel machine check architecture supported.
> Mar  3 14:43:13 joker Intel machine check reporting enabled on CPU#0.
> Mar  3 14:43:13 joker CPU: AMD Athlon(tm) XP 3200+ stepping 00
> Mar  3 14:43:13 joker Checking 'hlt' instruction... OK.
> Mar  3 14:43:13 joker ACPI: Core revision 20070126
> Mar  3 14:43:13 joker ACPI: setting ELCR to 1e20 (from 1c20)
> Mar  3 14:43:13 joker NET: Registered protocol family 16
> Mar  3 14:43:13 joker ACPI: bus type pci registered
> Mar  3 14:43:13 joker PCI: PCI BIOS revision 2.10 entry at 0xfda71, last bus=1
> Mar  3 14:43:13 joker PCI: Using configuration type 1
> Mar  3 14:43:13 joker Setting up standard PCI resources
> Mar  3 14:43:13 joker ACPI: Interpreter enabled
> Mar  3 14:43:13 joker ACPI: (supports S0 S1 S3 S4 S5)
> Mar  3 14:43:13 joker ACPI: Using PIC for interrupt routing
> Mar  3 14:43:13 joker ACPI: Power Resource [URP1] (off)
> Mar  3 14:43:13 joker ACPI: Power Resource [URP2] (off)
> Mar  3 14:43:13 joker ACPI: Power Resource [FDDP] (off)
> Mar  3 14:43:13 joker ACPI: Power Resource [LPTP] (off)
> Mar  3 14:43:13 joker Linux Plug and Play Support v0.97 (c) Adam Belay
> Mar  3 14:43:13 joker pnp: PnP ACPI init
> Mar  3 14:43:13 joker pnp: PnP ACPI: found 11 devices
> Mar  3 14:43:13 joker PCI: Probing PCI hardware
> Mar  3 14:43:13 joker PCI: Probing PCI hardware (bus 00)
> Mar  3 14:43:13 joker Boot video device is 0000:01:00.0
> Mar  3 14:43:13 joker PCI: Using IRQ router VIA [1106/3227] at 0000:00:11.0
> Mar  3 14:43:13 joker PCI: setting IRQ 11 as level-triggered
> Mar  3 14:43:13 joker PCI: Found IRQ 11 for device 0000:00:0f.1
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:0b.2
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:10.0
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:10.1
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:12.0
> Mar  3 14:43:13 joker pnp: 00:05: iomem range 0xfec00000-0xfec00fff has been reserved
> Mar  3 14:43:13 joker pnp: 00:05: iomem range 0xfee00000-0xfee00fff has been reserved
> Mar  3 14:43:13 joker PCI: Bridge: 0000:00:01.0
> Mar  3 14:43:13 joker IO window: disabled.
> Mar  3 14:43:13 joker MEM window: dde00000-dfefffff
> Mar  3 14:43:13 joker PREFETCH window: cdd00000-ddcfffff
> Mar  3 14:43:13 joker PCI: Setting latency timer of device 0000:00:01.0 to 64
> Mar  3 14:43:13 joker NET: Registered protocol family 2
> Mar  3 14:43:13 joker IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
> Mar  3 14:43:13 joker TCP established hash table entries: 16384 (order: 5, 131072 bytes)
> Mar  3 14:43:13 joker TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
> Mar  3 14:43:13 joker TCP: Hash tables configured (established 16384 bind 16384)
> Mar  3 14:43:13 joker TCP reno registered
> Mar  3 14:43:13 joker checking if image is initramfs... it is
> Mar  3 14:43:13 joker Freeing initrd memory: 864k freed
> Mar  3 14:43:13 joker Machine check exception polling timer started.
> Mar  3 14:43:13 joker VFS: Disk quotas dquot_6.5.1
> Mar  3 14:43:13 joker Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> Mar  3 14:43:13 joker io scheduler noop registered
> Mar  3 14:43:13 joker io scheduler anticipatory registered
> Mar  3 14:43:13 joker io scheduler deadline registered
> Mar  3 14:43:13 joker io scheduler cfq registered (default)
> Mar  3 14:43:13 joker PCI: Bypassing VIA 8237 APIC De-Assert Message
> Mar  3 14:43:13 joker input: Power Button (FF) as /class/input/input0
> Mar  3 14:43:13 joker ACPI: Power Button (FF) [PWRF]
> Mar  3 14:43:13 joker input: Power Button (CM) as /class/input/input1
> Mar  3 14:43:13 joker ACPI: Power Button (CM) [PWRB]
> Mar  3 14:43:13 joker input: Sleep Button (CM) as /class/input/input2
> Mar  3 14:43:13 joker ACPI: Sleep Button (CM) [SLPB]
> Mar  3 14:43:13 joker isapnp: Scanning for PnP cards...
> Mar  3 14:43:13 joker isapnp: No Plug & Play device found
> Mar  3 14:43:13 joker Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
> Mar  3 14:43:13 joker serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Mar  3 14:43:13 joker 00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Mar  3 14:43:13 joker RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
> Mar  3 14:43:13 joker loop: loaded (max 8 devices)
> Mar  3 14:43:13 joker PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> Mar  3 14:43:13 joker PNP: PS/2 controller doesn't have AUX irq; using default 12
> Mar  3 14:43:13 joker serio: i8042 KBD port at 0x60,0x64 irq 1
> Mar  3 14:43:13 joker serio: i8042 AUX port at 0x60,0x64 irq 12
> Mar  3 14:43:13 joker mice: PS/2 mouse device common for all mice
> Mar  3 14:43:13 joker TCP cubic registered
> Mar  3 14:43:13 joker NET: Registered protocol family 1
> Mar  3 14:43:13 joker NET: Registered protocol family 17
> Mar  3 14:43:13 joker Testing NMI watchdog ... OK.
> Mar  3 14:43:13 joker Using IPI Shortcut mode
> Mar  3 14:43:13 joker Freeing unused kernel memory: 188k freed
> Mar  3 14:43:13 joker Time: tsc clocksource has been installed.
> Mar  3 14:43:13 joker SCSI subsystem initialized
> Mar  3 14:43:13 joker libata version 2.20 loaded.
> Mar  3 14:43:13 joker pata_via 0000:00:0f.1: version 0.2.1
> Mar  3 14:43:13 joker PCI: Found IRQ 11 for device 0000:00:0f.1
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:0b.2
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:10.1
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:10.0
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:12.0
> Mar  3 14:43:13 joker PCI: VIA VLink IRQ fixup for 0000:00:0f.1, from 255 to 11
> Mar  3 14:43:13 joker ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001fc00 irq 14
> Mar  3 14:43:13 joker ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001fc08 irq 15
> Mar  3 14:43:13 joker scsi0 : pata_via
> Mar  3 14:43:13 joker ata1.00: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
> Mar  3 14:43:13 joker ata1.00: 160086528 sectors, multi 16: LBA 
> Mar  3 14:43:13 joker ata1.00: configured for UDMA/133
> Mar  3 14:43:13 joker scsi1 : pata_via
> Mar  3 14:43:13 joker Switched to high resolution mode on CPU 0
> Mar  3 14:43:13 joker ata2.00: ATAPI, max UDMA/33
> Mar  3 14:43:13 joker ata2.01: ATAPI, max UDMA/33
> Mar  3 14:43:13 joker ata2.00: configured for UDMA/33
> Mar  3 14:43:13 joker ata2.01: configured for UDMA/33
> Mar  3 14:43:13 joker scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
> Mar  3 14:43:13 joker scsi 1:0:0:0: CD-ROM            HL-DT-ST CD-RW GCE-8526B  1.03 PQ: 0 ANSI: 5
> Mar  3 14:43:13 joker scsi 1:0:1:0: CD-ROM            LITE-ON  DVD SOHD-167T    9S19 PQ: 0 ANSI: 5
> Mar  3 14:43:13 joker SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
> Mar  3 14:43:13 joker sda: Write Protect is off
> Mar  3 14:43:13 joker sda: Mode Sense: 00 3a 00 00
> Mar  3 14:43:13 joker SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Mar  3 14:43:13 joker SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
> Mar  3 14:43:13 joker sda: Write Protect is off
> Mar  3 14:43:13 joker sda: Mode Sense: 00 3a 00 00
> Mar  3 14:43:13 joker SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Mar  3 14:43:13 joker sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
> Mar  3 14:43:13 joker sd 0:0:0:0: Attached scsi disk sda
> Mar  3 14:43:13 joker sr0: scsi3-mmc drive: 52x/52x writer cd/rw xa/form2 cdda tray
> Mar  3 14:43:13 joker Uniform CD-ROM driver Revision: 3.20
> Mar  3 14:43:13 joker sr 1:0:0:0: Attached scsi CD-ROM sr0
> Mar  3 14:43:13 joker sr1: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
> Mar  3 14:43:13 joker sr 1:0:1:0: Attached scsi CD-ROM sr1
> Mar  3 14:43:13 joker kjournald starting.  Commit interval 5 seconds
> Mar  3 14:43:13 joker EXT3-fs: mounted filesystem with ordered data mode.
> Mar  3 14:43:13 joker usbcore: registered new interface driver usbfs
> Mar  3 14:43:13 joker usbcore: registered new interface driver hub
> Mar  3 14:43:13 joker usbcore: registered new device driver usb
> Mar  3 14:43:13 joker PCI: setting IRQ 5 as level-triggered
> Mar  3 14:43:13 joker PCI: Found IRQ 5 for device 0000:00:0b.0
> Mar  3 14:43:13 joker Installing spdif_bug patch: Audigy 2 Platinum [SB0240P]
> Mar  3 14:43:13 joker Real Time Clock Driver v1.12ac
> Mar  3 14:43:13 joker i2c /dev entries driver
> Mar  3 14:43:13 joker fuse init (API version 7.8)
> Mar  3 14:43:13 joker spurious 8259A interrupt: IRQ7.
> Mar  3 14:43:13 joker sd 0:0:0:0: Attached scsi generic sg0 type 0
> Mar  3 14:43:13 joker sr 1:0:0:0: Attached scsi generic sg1 type 5
> Mar  3 14:43:13 joker sr 1:0:1:0: Attached scsi generic sg2 type 5
> Mar  3 14:43:13 joker gameport: EMU10K1 is pci0000:00:0b.1/gameport0, io 0xec00, speed 1217kHz
> Mar  3 14:43:13 joker ieee1394: Initialized config rom entry `ip1394'
> Mar  3 14:43:13 joker input: PC Speaker as /class/input/input3
> Mar  3 14:43:13 joker PCI: Found IRQ 11 for device 0000:00:0b.2
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:0f.1
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:10.1
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:10.0
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:12.0
> Mar  3 14:43:13 joker ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[11]  MMIO=[dfff9800-dfff9fff]  Max Packet=[2048]  IR/IT contexts=[4/8]
> Mar  3 14:43:13 joker PPP generic driver version 2.4.2
> Mar  3 14:43:13 joker parport: PnPBIOS parport detected.
> Mar  3 14:43:13 joker parport0: PC-style at 0x378 (0x778), irq 7, dma 0 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
> Mar  3 14:43:13 joker rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
> Mar  3 14:43:13 joker pnp: Device 00:07 does not support disabling.
> Mar  3 14:43:13 joker rtc_cmos: probe of 00:07 failed with error -16
> Mar  3 14:43:13 joker lp0: using parport0 (interrupt-driven).
> Mar  3 14:43:13 joker ppdev: user-space parallel port driver
> Mar  3 14:43:13 joker PCI: setting IRQ 12 as level-triggered
> Mar  3 14:43:13 joker PCI: Found IRQ 12 for device 0000:00:0a.0
> Mar  3 14:43:13 joker PCI: Sharing IRQ 12 with 0000:00:10.4
> Mar  3 14:43:13 joker PCI: Sharing IRQ 12 with 0000:00:11.5
> Mar  3 14:43:13 joker rt2500 1.1.0 CVS CVS http://rt2x00.serialmonkey.com
> Mar  3 14:43:13 joker sata_via 0000:00:0f.0: version 2.1
> Mar  3 14:43:13 joker PCI: setting IRQ 10 as level-triggered
> Mar  3 14:43:13 joker PCI: Found IRQ 10 for device 0000:00:0f.0
> Mar  3 14:43:13 joker PCI: Sharing IRQ 10 with 0000:00:10.3
> Mar  3 14:43:13 joker PCI: Sharing IRQ 10 with 0000:00:10.2
> Mar  3 14:43:13 joker sata_via 0000:00:0f.0: routed to hard irq line 10
> Mar  3 14:43:13 joker ata3: SATA max UDMA/133 cmd 0x0001e800 ctl 0x0001e402 bmdma 0x0001d800 irq 10
> Mar  3 14:43:13 joker ata4: SATA max UDMA/133 cmd 0x0001e000 ctl 0x0001dc02 bmdma 0x0001d808 irq 10
> Mar  3 14:43:13 joker scsi2 : sata_via
> Mar  3 14:43:13 joker USB Universal Host Controller Interface driver v3.0
> Mar  3 14:43:13 joker ata3: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
> Mar  3 14:43:13 joker ATA: abnormal status 0x7F on port 0x0001e807
> Mar  3 14:43:13 joker scsi3 : sata_via
> Mar  3 14:43:13 joker ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023c00910047b3]
> Mar  3 14:43:13 joker ata4: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
> Mar  3 14:43:13 joker ATA: abnormal status 0x7F on port 0x0001e007
> Mar  3 14:43:13 joker PCI: Found IRQ 11 for device 0000:00:10.0
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:0b.2
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:0f.1
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:10.1
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:12.0
> Mar  3 14:43:13 joker uhci_hcd 0000:00:10.0: UHCI Host Controller
> Mar  3 14:43:13 joker uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
> Mar  3 14:43:13 joker uhci_hcd 0000:00:10.0: irq 11, io base 0x0000c000
> Mar  3 14:43:13 joker usb usb1: configuration #1 chosen from 1 choice
> Mar  3 14:43:13 joker hub 1-0:1.0: USB hub found
> Mar  3 14:43:13 joker hub 1-0:1.0: 2 ports detected
> Mar  3 14:43:13 joker PCI: Found IRQ 11 for device 0000:00:10.1
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:0b.2
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:0f.1
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:10.0
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:12.0
> Mar  3 14:43:13 joker uhci_hcd 0000:00:10.1: UHCI Host Controller
> Mar  3 14:43:13 joker uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
> Mar  3 14:43:13 joker uhci_hcd 0000:00:10.1: irq 11, io base 0x0000c400
> Mar  3 14:43:13 joker usb usb2: configuration #1 chosen from 1 choice
> Mar  3 14:43:13 joker hub 2-0:1.0: USB hub found
> Mar  3 14:43:13 joker hub 2-0:1.0: 2 ports detected
> Mar  3 14:43:13 joker via-rhine.c:v1.10-LK1.4.2 Sept-11-2006 Written by Donald Becker
> Mar  3 14:43:13 joker PCI: Found IRQ 10 for device 0000:00:10.2
> Mar  3 14:43:13 joker PCI: Sharing IRQ 10 with 0000:00:0f.0
> Mar  3 14:43:13 joker PCI: Sharing IRQ 10 with 0000:00:10.3
> Mar  3 14:43:13 joker uhci_hcd 0000:00:10.2: UHCI Host Controller
> Mar  3 14:43:13 joker uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
> Mar  3 14:43:13 joker uhci_hcd 0000:00:10.2: irq 10, io base 0x0000c800
> Mar  3 14:43:13 joker usb usb3: configuration #1 chosen from 1 choice
> Mar  3 14:43:13 joker hub 3-0:1.0: USB hub found
> Mar  3 14:43:13 joker hub 3-0:1.0: 2 ports detected
> Mar  3 14:43:13 joker PCI: Found IRQ 10 for device 0000:00:10.3
> Mar  3 14:43:13 joker PCI: Sharing IRQ 10 with 0000:00:0f.0
> Mar  3 14:43:13 joker PCI: Sharing IRQ 10 with 0000:00:10.2
> Mar  3 14:43:13 joker uhci_hcd 0000:00:10.3: UHCI Host Controller
> Mar  3 14:43:13 joker uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
> Mar  3 14:43:13 joker uhci_hcd 0000:00:10.3: irq 10, io base 0x0000cc00
> Mar  3 14:43:13 joker usb usb4: configuration #1 chosen from 1 choice
> Mar  3 14:43:13 joker hub 4-0:1.0: USB hub found
> Mar  3 14:43:13 joker hub 4-0:1.0: 2 ports detected
> Mar  3 14:43:13 joker PCI: Found IRQ 12 for device 0000:00:10.4
> Mar  3 14:43:13 joker PCI: Sharing IRQ 12 with 0000:00:0a.0
> Mar  3 14:43:13 joker PCI: Sharing IRQ 12 with 0000:00:11.5
> Mar  3 14:43:13 joker ehci_hcd 0000:00:10.4: EHCI Host Controller
> Mar  3 14:43:13 joker ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
> Mar  3 14:43:13 joker ehci_hcd 0000:00:10.4: irq 12, io mem 0xdfff9600
> Mar  3 14:43:13 joker ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> Mar  3 14:43:13 joker usb usb5: configuration #1 chosen from 1 choice
> Mar  3 14:43:13 joker hub 5-0:1.0: USB hub found
> Mar  3 14:43:13 joker hub 5-0:1.0: 8 ports detected
> Mar  3 14:43:13 joker input: AT Translated Set 2 keyboard as /class/input/input4
> Mar  3 14:43:13 joker PCI: Found IRQ 12 for device 0000:00:11.5
> Mar  3 14:43:13 joker PCI: Sharing IRQ 12 with 0000:00:0a.0
> Mar  3 14:43:13 joker PCI: Sharing IRQ 12 with 0000:00:10.4
> Mar  3 14:43:13 joker PCI: Setting latency timer of device 0000:00:11.5 to 64
> Mar  3 14:43:13 joker PCI: Found IRQ 11 for device 0000:00:12.0
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:0b.2
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:0f.1
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:10.1
> Mar  3 14:43:13 joker PCI: Sharing IRQ 11 with 0000:00:10.0
> Mar  3 14:43:13 joker eth0: VIA Rhine II at 0xdfff9500, 00:0b:6a:99:27:12, IRQ 11.
> Mar  3 14:43:13 joker eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link 0021.
> Mar  3 14:43:13 joker usb 2-1: new low speed USB device using uhci_hcd and address 2
> Mar  3 14:43:13 joker EXT3 FS on sda2, internal journal
> Mar  3 14:43:13 joker usb 2-1: configuration #1 chosen from 1 choice
> Mar  3 14:43:13 joker usbcore: registered new interface driver hiddev
> Mar  3 14:43:13 joker input: HID 1241:1177 as /class/input/input5
> Mar  3 14:43:13 joker input: USB HID v1.00 Mouse [HID 1241:1177] on usb-0000:00:10.1-1
> Mar  3 14:43:13 joker usbcore: registered new interface driver usbhid
> Mar  3 14:43:13 joker drivers/usb/input/hid-core.c: v2.6:USB HID core driver
> Mar  3 14:43:13 joker Adding 1534168k swap on /dev/disk/by-label/swap.  Priority:-1 extents:1 across:1534168k
> Mar  3 14:43:13 joker init: Going single user
> Mar  3 14:43:29 joker shutdown[4217]: shutting down for system reboot
> Mar  3 14:43:29 joker init: Switching to runlevel: 6
> Mar  3 14:43:30 joker syslog-ng[4211]: SIGTERM received, terminating;  
> Mar  3 14:43:30 joker syslog-ng[4211]: syslog-ng shutting down; version='2.0.0' 
> 
> 
> I hope that's informative. Cheers.
> 
> Ash

Just checked 2.6.21-rc2-mm1, still has the problem.
Also, acpi=noirq fixes it too.
To clarify, the problem is that my ps/2 port keyboard is completely frozen
on boot - usually it gets activated when udev probes for hardware (my kernel
config is highly modular). It worked fine with 2.6.20 and earlier with acpi 
taking care of interrupt routing.

Ash
