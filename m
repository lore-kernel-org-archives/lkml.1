Return-Path: <linux-kernel-owner+w=401wt.eu-S1764676AbXJFAz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764676AbXJFAz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 20:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbXJFAzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 20:55:15 -0400
Received: from kai.vm.bytemark.co.uk ([80.68.89.220]:4154 "EHLO
	kai.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbXJFAzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 20:55:10 -0400
X-Greylist: delayed 2094 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2007 20:55:09 EDT
Message-ID: <4706D4B1.6050101@sacredchao.net>
Date: Fri, 05 Oct 2007 20:20:01 -0400
From: Matthew Reppert <arashi@sacredchao.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20071005)
MIME-Version: 1.0
To: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: G33 graphics broken after 2.6.23-rc6
Content-Type: multipart/mixed;
 boundary="------------060407040808030608080408"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060407040808030608080408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I've got a new-ish system that I've been trying to get working that's
very close; the only things left are networking (which the latest e1000
driver from sf.net might fix) and graphics.

The system is a DG33TL micro ATX motherboard with a 2.13GHz Core 2 Duo
processor and 2GB RAM.  The graphics adapter is:

00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express 
Integrated Graphics Controller (rev 02) (prog-if 00 [VGA])
        Subsystem: Intel Corporation Unknown device 5044
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at 90280000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at 2430 [size=8]
        Region 2: Memory at 80000000 (32-bit, prefetchable) [size=256M]
        Region 3: Memory at 90100000 (32-bit, non-prefetchable) [size=1M]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

It works fine in the Ubuntu kernels (pre 2.6.22-13) and in mainline through
2.6.23-rc6; since 2.6.23-rc7 (and Ubuntu 2.6.22-13), the X server won't
start up, and I get this at the end of my Xorg.log:

============================================
(II) intel(0): xf86BindGARTMemory: bind key 0 at 0x006ff000 (pgoffset 1791)
(WW) intel(0): xf86BindGARTMemory: binding of gart memory with key 0
        at offset 0x6ff000 failed (Invalid argument)

Fatal server error:
Couldn't bind memory for front buffer

============================================

Up until that (II) line, the logs are basically identical, and the working
one just goes into another xf86BindGARTMemory call afterwards, then goes
along its merry way.  The version of the Intel X.org driver is
2.1.1-0ubuntu5.  I've attached a diff of dmesg outputs for the Ubuntu
2.6.22-12 kernel and 2.6.23-rc9.

Matt


--------------060407040808030608080408
Content-Type: text/x-patch;
 name="dmesg.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.diff"

--- dmesg-2.6.22-12-generic.no-times	2007-10-05 20:11:41.000000000 -0400
+++ dmesg-2.6.23-rc9-ubuntu-config.no-times	2007-10-05 20:11:32.000000000 -0400
@@ -1,4 +1,4 @@
-Linux version 2.6.22-12-generic (buildd@vernadsky) (gcc version 4.1.3 20070831 (prerelease) (Ubuntu 4.1.2-16ubuntu1)) #1 SMP Sun Sep 23 18:11:30 GMT 2007 (Ubuntu 2.6.22-12.39-generic)
+Linux version 2.6.23-rc9-ubuntu-config (root@yukarin) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Thu Oct 4 01:34:19 EDT 2007
 BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
@@ -22,6 +22,7 @@
   DMA             0 ->     4096
   Normal       4096 ->   229376
   HighMem    229376 ->   517632
+Movable zone start PFN for each node
 early_node_map[1] active PFN ranges
     0:        0 ->   517632
 On node 0 totalpages: 517632
@@ -32,6 +33,7 @@
   Normal zone: 223520 pages, LIFO batch:31
   HighMem zone: 2252 pages used for memmap
   HighMem zone: 286004 pages, LIFO batch:31
+  Movable zone: 0 pages used for memmap
 DMI 2.4 present.
 ACPI: RSDP 000FE020, 0014 (r0 INTEL )
 ACPI: RSDT 7E5FD038, 005C (r1 INTEL  DG33TL        10B       1000013)
@@ -71,68 +73,70 @@
 Enabling APIC mode:  Flat.  Using 1 I/O APICs
 Using ACPI (MADT) for SMP configuration information
 Allocating PCI resources starting at 80000000 (gap: 7f000000:71000000)
-Built 1 zonelists.  Total pages: 513588
-Kernel command line: BOOT_IMAGE=(hd0,3)/boot/vmlinuz-2.6.22-12-generic root=/dev/sda3 ro
-mapped APIC to ffffd000 (fee00000)
-mapped IOAPIC to ffffc000 (fec00000)
+swsusp: Registered nosave memory region: 000000000009e000 - 000000000009f000
+swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
+swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
+swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
+Built 1 zonelists in Zone order.  Total pages: 513588
+Kernel command line: BOOT_IMAGE=(hd0,3)/boot/vmlinuz-2.6.23-rc9-ubuntu-config root=/dev/sda3 ro pci=nommconf
+mapped APIC to ffffb000 (fee00000)
+mapped IOAPIC to ffffa000 (fec00000)
 Enabling fast FPU save and restore... done.
 Enabling unmasked SIMD FPU exception support... done.
 Initializing CPU#0
 PID hash table entries: 4096 (order: 12, 16384 bytes)
-Detected 2133.462 MHz processor.
+Detected 2133.533 MHz processor.
 Console: colour VGA+ 80x25
+console [tty0] enabled
 Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
 Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
-Memory: 2040308k/2070528k available (2017k kernel code, 27956k reserved, 918k data, 364k init, 1152020k highmem)
+Memory: 2022388k/2070528k available (2020k kernel code, 45880k reserved, 913k data, 360k init, 1152020k highmem)
 virtual kernel memory layout:
-    fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
+    fixmap  : 0xfff4b000 - 0xfffff000   ( 720 kB)
     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
-      .init : 0xc03e3000 - 0xc043e000   ( 364 kB)
-      .data : 0xc02f8456 - 0xc03ddea4   ( 918 kB)
-      .text : 0xc0100000 - 0xc02f8456   (2017 kB)
+      .init : 0xc03e3000 - 0xc043d000   ( 360 kB)
+      .data : 0xc02f9153 - 0xc03dd644   ( 913 kB)
+      .text : 0xc0100000 - 0xc02f9153   (2020 kB)
 Checking if this processor honours the WP bit even in supervisor mode... Ok.
 SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
-Calibrating delay using timer specific routine.. 4270.16 BogoMIPS (lpj=8540329)
+Calibrating delay using timer specific routine.. 4270.25 BogoMIPS (lpj=8540501)
 Security Framework v1.0.0 initialized
 SELinux:  Disabled at boot.
 Mount-cache hash table entries: 512
-CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
+CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
 monitor/mwait feature present.
 using mwait in idle threads.
 CPU: L1 I cache: 32K, L1 D cache: 32K
 CPU: L2 cache: 4096K
 CPU: Physical Processor ID: 0
 CPU: Processor Core ID: 0
-CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
+CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
 Compat vDSO mapped to ffffe000.
 Checking 'hlt' instruction... OK.
 SMP alternatives: switching to UP code
-Early unpacking initramfs... done
 ACPI: Core revision 20070126
-ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
 CPU0: Intel(R) Core(TM)2 CPU          6420  @ 2.13GHz stepping 06
 SMP alternatives: switching to SMP code
 Booting processor 1/1 eip 3000
 Initializing CPU#1
-Calibrating delay using timer specific routine.. 4267.13 BogoMIPS (lpj=8534263)
-CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
+Calibrating delay using timer specific routine.. 4267.13 BogoMIPS (lpj=8534277)
+CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
 monitor/mwait feature present.
 CPU: L1 I cache: 32K, L1 D cache: 32K
 CPU: L2 cache: 4096K
 CPU: Physical Processor ID: 0
 CPU: Processor Core ID: 1
-CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
+CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
 CPU1: Intel(R) Core(TM)2 CPU          6420  @ 2.13GHz stepping 06
-Total of 2 processors activated (8537.29 BogoMIPS).
+Total of 2 processors activated (8537.38 BogoMIPS).
 ENABLING IO-APIC IRQs
 ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
 checking TSC synchronization [CPU#0 -> CPU#1]: passed.
 Brought up 2 CPUs
-migration_cost=94
 Booting paravirtualized kernel on bare hardware
-Time: 23:20:57  Date: 09/05/107
+Time:  0:08:34  Date: 09/06/107
 NET: Registered protocol family 16
 EISA bus registered
 ACPI: bus type pci registered
@@ -143,7 +147,6 @@
 ACPI: (supports S0 S1 S3 S4 S5)
 ACPI: Using IOAPIC for interrupt routing
 ACPI: PCI Root Bridge [PCI0] (0000:00)
-PCI: Probing PCI hardware (bus 00)
 PCI: Transparent bridge - 0000:00:1e.0
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
@@ -170,6 +173,7 @@
 PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
 NET: Registered protocol family 8
 NET: Registered protocol family 20
+Time: tsc clocksource has been installed.
 pnp: 00:01: iomem range 0xf0000000-0xf7ffffff could not be reserved
 pnp: 00:01: iomem range 0xfeb00000-0xfeb03fff has been reserved
 pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
@@ -177,7 +181,6 @@
 pnp: 00:06: ioport range 0x500-0x53f has been reserved
 pnp: 00:06: ioport range 0x400-0x47f has been reserved
 pnp: 00:06: ioport range 0x680-0x6ff has been reserved
-Time: tsc clocksource has been installed.
 PCI: Bridge: 0000:00:1c.0
   IO window: disabled.
   MEM window: 90400000-904fffff
@@ -224,12 +227,12 @@
 TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
 TCP: Hash tables configured (established 131072 bind 65536)
 TCP reno registered
-checking if image is initramfs... it is
-Switched to high resolution mode on CPU 1
+checking if image is initramfs...<6>Switched to high resolution mode on CPU 1
 Switched to high resolution mode on CPU 0
-Freeing initrd memory: 7026k freed
+ it is
+Freeing initrd memory: 24954k freed
 audit: initializing netlink socket (disabled)
-audit(1191626457.320:1): initialized
+audit(1191629316.152:1): initialized
 highmem bounce pool size: 64 pages
 VFS: Disk quotas dquot_6.5.1
 Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
@@ -264,7 +267,6 @@
 Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
 serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
 RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
-input: Macintosh mouse button emulation as /class/input/input0
 PNP: No PS/2 controller found. Probing ports directly.
 serio: i8042 KBD port at 0x60,0x64 irq 1
 serio: i8042 AUX port at 0x60,0x64 irq 12
@@ -276,16 +278,14 @@
 TCP cubic registered
 NET: Registered protocol family 1
 Using IPI No-Shortcut mode
-  Magic number: 11:112:352
-Freeing unused kernel memory: 364k freed
-AppArmor: AppArmor initialized<5>audit(1191626457.820:2):  type=1505 info="AppArmor initialized" pid=1147
+  Magic number: 11:534:101
+Freeing unused kernel memory: 360k freed
 fuse init (API version 7.8)
-Failure registering capabilities with primary security module.
 Monitor-Mwait will be used to enter C-1 state
 ACPI: Processor [CPU0] (supports 8 throttling states)
 ACPI: Processor [CPU1] (supports 8 throttling states)
-ACPI Exception (processor_core-0781): AE_NOT_FOUND, Processor Device is not present [20070126]
-ACPI Exception (processor_core-0781): AE_NOT_FOUND, Processor Device is not present [20070126]
+ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
+ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
 usbcore: registered new interface driver usbfs
 usbcore: registered new interface driver hub
 usbcore: registered new device driver usb
@@ -370,17 +370,17 @@
 scsi1 : pata_it821x
 ata1: PATA max UDMA/133 cmd 0x00011018 ctl 0x00011026 bmdma 0x00011000 irq 18
 ata2: PATA max UDMA/133 cmd 0x00011010 ctl 0x00011022 bmdma 0x00011008 irq 18
-ahci 0000:00:1f.2: version 2.2
+ahci 0000:00:1f.2: version 2.3
 ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 21 (level, low) -> IRQ 20
 usb 5-2: new low speed USB device using uhci_hcd and address 3
 usb 5-2: configuration #1 chosen from 1 choice
 usb 6-2: new low speed USB device using uhci_hcd and address 2
 usb 6-2: configuration #1 chosen from 1 choice
 usbcore: registered new interface driver hiddev
-input: Logitech USB-PS/2 Optical Mouse as /class/input/input1
+input: Logitech USB-PS/2 Optical Mouse as /class/input/input0
 input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.1-2
 ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
-ahci 0000:00:1f.2: flags: 64bit ncq led clo pmp pio slum part 
+ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pmp pio slum part 
 PCI: Setting latency timer of device 0000:00:1f.2 to 64
 scsi2 : ahci
 scsi3 : ahci
@@ -388,16 +388,16 @@
 scsi5 : ahci
 scsi6 : ahci
 scsi7 : ahci
-ata3: SATA max UDMA/133 cmd 0xf884c100 ctl 0x00000000 bmdma 0x00000000 irq 218
-ata4: SATA max UDMA/133 cmd 0xf884c180 ctl 0x00000000 bmdma 0x00000000 irq 218
-ata5: SATA max UDMA/133 cmd 0xf884c200 ctl 0x00000000 bmdma 0x00000000 irq 218
-ata6: SATA max UDMA/133 cmd 0xf884c280 ctl 0x00000000 bmdma 0x00000000 irq 218
-ata7: SATA max UDMA/133 cmd 0xf884c300 ctl 0x00000000 bmdma 0x00000000 irq 218
-ata8: SATA max UDMA/133 cmd 0xf884c380 ctl 0x00000000 bmdma 0x00000000 irq 218
-input: Logitech Logitech USB Keyboard as /class/input/input2
+ata3: SATA max UDMA/133 cmd 0xf88a4100 ctl 0x00000000 bmdma 0x00000000 irq 218
+ata4: SATA max UDMA/133 cmd 0xf88a4180 ctl 0x00000000 bmdma 0x00000000 irq 218
+ata5: SATA max UDMA/133 cmd 0xf88a4200 ctl 0x00000000 bmdma 0x00000000 irq 218
+ata6: SATA max UDMA/133 cmd 0xf88a4280 ctl 0x00000000 bmdma 0x00000000 irq 218
+ata7: SATA max UDMA/133 cmd 0xf88a4300 ctl 0x00000000 bmdma 0x00000000 irq 218
+ata8: SATA max UDMA/133 cmd 0xf88a4380 ctl 0x00000000 bmdma 0x00000000 irq 218
+input: Logitech Logitech USB Keyboard as /class/input/input1
 input: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:1d.2-2
 usbcore: registered new interface driver usbhid
-/build/buildd/linux-source-2.6.22-2.6.22/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
+drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
 ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
 ata3.00: ATA-7: ST3400620AS, 3.AAK, max UDMA/133
 ata3.00: 781422768 sectors, multi 0: LBA48 NCQ (depth 31/32)
@@ -409,6 +409,7 @@
 ata8: SATA link down (SStatus 0 SControl 300)
 scsi 2:0:0:0: Direct-Access     ATA      ST3400620AS      3.AA PQ: 0 ANSI: 5
 ACPI: PCI Interrupt 0000:06:03.0[A] -> GSI 19 (level, low) -> IRQ 19
+ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]  MMIO=[90000000-900007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
 sd 2:0:0:0: [sda] 781422768 512-byte hardware sectors (400088 MB)
 sd 2:0:0:0: [sda] Write Protect is off
 sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
@@ -417,8 +418,7 @@
 sd 2:0:0:0: [sda] Write Protect is off
 sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
 sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
- sda:<6>ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]  MMIO=[90000000-900007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
- sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
+ sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
 sd 2:0:0:0: [sda] Attached SCSI disk
 sd 2:0:0:0: Attached scsi generic sg0 type 0
 Attempting manual resume
@@ -426,53 +426,47 @@
 PM: Checking swsusp image.
 PM: Resume from disk failed.
 ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0090270001ccd7a0]
-heci: Intel(R) AMT Management Interface - version 3.1.0.17
-heci: Copyright (c) 2003 - 2007 Intel Corporation.
-ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 16 (level, low) -> IRQ 22
-PCI: Setting latency timer of device 0000:00:03.0 to 64
-heci: link layer has been established.
-pci_hotplug: PCI Hot Plug PCI Core version: 0.5
-Intel(R) PRO/1000 Network Driver - version 7.6.5-NAPI
-Copyright (c) 1999-2007 Intel Corporation.
-Linux agpgart interface v0.102 (c) Dave Jones
-heci: heci driver initialization successful.
-shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
+Linux agpgart interface v0.102
 agpgart: Detected an Intel G33 Chipset.
-agpgart: Detected 7164K stolen memory.
+agpgart: Detected 8192K stolen memory.
+pci_hotplug: PCI Hot Plug PCI Core version: 0.5
 agpgart: AGP aperture is 256M @ 0x80000000
-ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 17
-PCI: Setting latency timer of device 0000:00:19.0 to 64
-input: PC Speaker as /class/input/input3
-e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:19:d1:91:aa:e4
-e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
-ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 23
+iTCO_vendor_support: vendor-support=0
+input: PC Speaker as /class/input/input2
+shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
+input: Power Button (FF) as /class/input/input3
+ACPI: Power Button (FF) [PWRF]
+input: Sleep Button (CM) as /class/input/input4
+ACPI: Sleep Button (CM) [SLPB]
+iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
+iTCO_wdt: Found a ICH9R TCO device (Version=2, TCOBASE=0x0460)
+iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
+ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
 PCI: Setting latency timer of device 0000:00:1b.0 to 64
-NET: Registered protocol family 10
-lo: Disabled Privacy Extensions
-ADDRCONF(NETDEV_UP): eth0: link is not ready
-e1000: eth0: e1000_watchdog_task: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
-e1000: eth0: e1000_watchdog_task: 10/100 speed: disabling TSO
-ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
-lp: driver loaded but no devices found
 [drm] Initialized drm 1.1.0 20060810
-ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 22
+ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 23
 [drm] Initialized i915 1.6.0 20060119 on minor 0
 Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
 ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
 Probing IDE interface ide0...
 Probing IDE interface ide1...
 Adding 1951856k swap on /dev/sda8.  Priority:-1 extents:1 across:1951856k
-eth0: no IPv6 routers present
 No dock devices found.
-input: Power Button (FF) as /class/input/input4
-ACPI: Power Button (FF) [PWRF]
-input: Sleep Button (CM) as /class/input/input5
-ACPI: Sleep Button (CM) [SLPB]
-ppdev: user-space parallel port driver
-audit(1191626495.850:3):  type=1503 operation="inode_permission" requested_mask="a" denied_mask="a" name="/dev/tty" pid=5352 profile="/usr/sbin/cupsd"
+toshiba_acpi: Unknown parameter `hotkeys_over_acpi'
+NET: Registered protocol family 10
+lo: Disabled Privacy Extensions
 apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
 apm: disabled - APM is not SMP safe.
 Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
 NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
 NFSD: starting 90-second grace period
-Failure registering capabilities with primary security module.
+Capability LSM initialized
+agpgart: pg_start == 0x000006ff,intel_private.gtt_entries == 0x00000800
+agpgart: Trying to insert into local/stolen memory
+agpgart: pg_start == 0x000006ff,intel_private.gtt_entries == 0x00000800
+agpgart: Trying to insert into local/stolen memory
+agpgart: pg_start == 0x000006ff,intel_private.gtt_entries == 0x00000800
+agpgart: Trying to insert into local/stolen memory
+mtrr: no more MTRRs available
+mtrr: no more MTRRs available
+mtrr: no more MTRRs available

--------------060407040808030608080408--
