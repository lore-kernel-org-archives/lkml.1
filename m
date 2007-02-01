Return-Path: <linux-kernel-owner+w=401wt.eu-S1422847AbXBANAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422847AbXBANAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422844AbXBANAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:00:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:46653 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422847AbXBANAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:00:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Wp3h9ViqJquJBKS/AGtWWF2ndAmtDaQFknNqYy156eTcafhoCg58tGMdeNXTFkRUAoDvmnIi8u5/BDpYLQv4ov8PrcGBGeLjbS25REr0eTc1oQ9J4BkWpNd/YD7jpCBk0pFn5v9xHmTFlRq7Gk+0Um4WywgQDF2z7vALd5vJlAE=
Message-ID: <64b272cb0702010500k4e5d6576kb077991bb03afd0e@mail.gmail.com>
Date: Thu, 1 Feb 2007 14:00:15 +0100
From: "Kobajashi Zaghi" <kobajashi@gmail.com>
To: drzeus-mmc@drzeus.cx
Subject: 2 GB SD card problem vs. 2.6.20-rc7 (FAT: Filesystem panic (dev sdc1))
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre!

I have two 2GB capacity SD card (Kingston, noname). When i put either
of them to a card reader, kernel recognize, but "see" only 1GB
capacity, and when i try to access, FAT filesystem paniced.

dmesg:
--------

[snip]
[  216.408000] usb 4-3: new high speed USB device using ehci_hcd and address 3
[  216.537000] usb 4-3: configuration #1 chosen from 1 choice
[  216.650000] usbcore: registered new interface driver libusual
[  216.664000] Initializing USB Mass Storage driver...
[  216.664000] scsi0 : SCSI emulation for USB Mass Storage devices
[  216.664000] usbcore: registered new interface driver usb-storage
[  216.664000] USB Mass Storage support registered.
[  216.664000] usb-storage: device found at 3
[  216.664000] usb-storage: waiting for device to settle before scanning
[  221.668000] scsi 0:0:0:0: Direct-Access     GENERIC  USB
Storage-SMC  I16A PQ: 0 ANSI: 0 CCS
[  221.673000] scsi 0:0:0:1: Direct-Access     GENERIC  USB
Storage-CFC  I16A PQ: 0 ANSI: 0 CCS
[  221.678000] scsi 0:0:0:2: Direct-Access     GENERIC  USB
Storage-SDC  I16A PQ: 0 ANSI: 0 CCS
[  221.683000] scsi 0:0:0:3: Direct-Access     GENERIC  USB
Storage-MSC  I16A PQ: 0 ANSI: 0 CCS
[  221.691000] usb-storage: device scan complete
[  221.792000] sd 0:0:0:0: Attached scsi removable disk sda
[  221.794000] sd 0:0:0:1: Attached scsi removable disk sdb
[  221.798000] SCSI device sdc: 1992704 512-byte hdwr sectors (1020 MB)
[  221.812000] sdc: Write Protect is off
[  221.812000] sdc: Mode Sense: 00 00 00 00
[  221.812000] sdc: assuming drive cache: write through
[  221.837000] SCSI device sdc: 1992704 512-byte hdwr sectors (1020 MB)
[  221.849000] sdc: Write Protect is off
[  221.849000] sdc: Mode Sense: 00 00 00 00
[  221.849000] sdc: assuming drive cache: write through
[  221.849000]  sdc: sdc1
[  221.851000]  sdc: p1 exceeds device capacity
[  221.852000] sd 0:0:0:2: Attached scsi removable disk sdc
[  221.854000] sd 0:0:0:3: Attached scsi removable disk sdd
[  221.878000] sd 0:0:0:0: Attached scsi generic sg0 type 0
[  221.879000] sd 0:0:0:1: Attached scsi generic sg1 type 0
[  221.879000] sd 0:0:0:2: Attached scsi generic sg2 type 0
[  221.879000] sd 0:0:0:3: Attached scsi generic sg3 type 0
[  222.030000] attempt to access beyond end of device
[  222.030000] sdc: rw=0, want=3985272, limit=1992704
[  222.030000] Buffer I/O error on device sdc1, logical block 3985024
[  222.031000] attempt to access beyond end of device
[  222.031000] sdc: rw=0, want=3985273, limit=1992704
[  222.031000] Buffer I/O error on device sdc1, logical block 3985025
[  222.031000] attempt to access beyond end of device
[  222.031000] sdc: rw=0, want=3985274, limit=1992704
[  222.031000] Buffer I/O error on device sdc1, logical block 3985026
[  222.031000] attempt to access beyond end of device
[  222.031000] sdc: rw=0, want=3985275, limit=1992704
[  222.031000] Buffer I/O error on device sdc1, logical block 3985027
[  222.032000] attempt to access beyond end of device
[  222.032000] sdc: rw=0, want=3985276, limit=1992704
[  222.032000] Buffer I/O error on device sdc1, logical block 3985028
[...]
[snip]

lsusb:
-------

Bus 004 Device 003: ID 07c4:a600 Datafab Systems, Inc.
Bus 004 Device 001: ID 0000:0000
Bus 003 Device 001: ID 0000:0000
Bus 002 Device 001: ID 0000:0000
Bus 001 Device 003: ID 045e:0040 Microsoft Corp. Wheel Mouse Optical
Bus 001 Device 001: ID 0000:0000

lspci
------

00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML
Express Processor to DRAM Controller (rev 04)
00:01.0 PCI bridge: Intel Corporation Mobile 915GM/PM Express PCI
Express Root Port (rev 04)
00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) High Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) PCI Express Port 1 (rev 04)
00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #1 (rev 04)
00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #2 (rev 04)
00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #3 (rev 04)
00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB2 EHCI Controller (rev 04)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d4)
00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface
Bridge (rev 04)
00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) IDE Controller (rev 04)
00:1f.2 IDE interface: Intel Corporation 82801FBM (ICH6M) SATA
Controller (rev 04)
00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
SMBus Controller (rev 04)
01:00.0 VGA compatible controller: ATI Technologies Inc Radeon
Mobility X700 (PCIE)
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053
PCI-E Gigabit Ethernet Controller (rev 15)
06:02.0 FireWire (IEEE 1394): Texas Instruments TSB43AB21
IEEE-1394a-2000 Controller (PHY/Link)
06:03.0 Network controller: Intel Corporation PRO/Wireless 2915ABG
Network Connection (rev 05)
06:04.0 CardBus bridge: Texas Instruments PCI1620 PC Card Controller (rev 01)
06:04.1 CardBus bridge: Texas Instruments PCI1620 PC Card Controller (rev 01)
06:04.2 System peripheral: Texas Instruments PCI1620 Firmware Loading
Function (rev 01)

cfdisk /dev/sdc
-------------------

FATAL ERROR: Bad primary partition 0: Partition ends after end-of-disk
                                                                Press
any key to exit cfdisk


fdisk /dev/sdc
-----------------

The number of cylinders for this disk is set to 2454.
There is nothing wrong with that, but this is larger than 1024,
and could in certain setups cause problems with:
1) software that runs at boot time (e.g., old versions of LILO)
2) booting and partitioning software from other OSs
   (e.g., DOS FDISK, OS/2 FDISK)

Command (m for help): p

Disk /dev/sdc: 1020 MB, 1020264448 bytes
29 heads, 28 sectors/track, 2454 cylinders
Units = cylinders of 812 * 512 = 415744 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1        4909     1992580+   b  W95 FAT32


mount -t vfat /dev/sdc1 /media/
-------------------------------------

Feb  1 07:47:03 localhost kernel: [  421.426000] FAT: Filesystem panic
(dev sdc1)
Feb  1 07:47:03 localhost kernel: [  421.426000]     fat_get_cluster:
invalid cluster chain (i_pos 0)
Feb  1 07:47:03 localhost kernel: [  421.427000] FAT: Filesystem panic
(dev sdc1)
Feb  1 07:47:03 localhost kernel: [  421.427000]     fat_get_cluster:
invalid cluster chain (i_pos 0)
Feb  1 07:47:34 localhost kernel: [  452.049000] FAT: Filesystem panic
(dev sdc1)
Feb  1 07:47:34 localhost kernel: [  452.049000]     fat_get_cluster:
invalid cluster chain (i_pos 0)
Feb  1 07:47:34 localhost kernel: [  452.049000] FAT: Filesystem panic
(dev sdc1)
Feb  1 07:47:34 localhost kernel: [  452.049000]     fat_get_cluster:
invalid cluster chain (i_pos 0)
Feb  1 07:47:34 localhost kernel: [  452.049000] FAT: Filesystem panic
(dev sdc1)
Feb  1 07:47:34 localhost kernel: [  452.049000]     fat_get_cluster:
invalid cluster chain (i_pos 0)

dmesg
--------

[    0.000000] Linux version 2.6.20-rc7 (root@foobar) (gcc version
4.1.2 20060928 (prerelease) (Ubuntu 4.1.1-13ubuntu5)) #1 SMP Wed Jan
31 21:05:44 CET 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] sanitize start
[    0.000000] sanitize end
[    0.000000] copy_e820_map() start: 0000000000000000 size:
000000000009f800 end: 000000000009f800 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000000009f800 size:
0000000000000800 end: 00000000000a0000 type: 2
[    0.000000] copy_e820_map() start: 00000000000ce000 size:
0000000000002000 end: 00000000000d0000 type: 2
[    0.000000] copy_e820_map() start: 00000000000dc000 size:
0000000000024000 end: 0000000000100000 type: 2
[    0.000000] copy_e820_map() start: 0000000000100000 size:
000000003fde0000 end: 000000003fee0000 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000003fee0000 size:
000000000000a000 end: 000000003feea000 type: 3
[    0.000000] copy_e820_map() start: 000000003feea000 size:
0000000000016000 end: 000000003ff00000 type: 4
[    0.000000] copy_e820_map() start: 000000003ff00000 size:
0000000000100000 end: 0000000040000000 type: 2
[    0.000000] copy_e820_map() start: 00000000e0000000 size:
0000000010006000 end: 00000000f0006000 type: 2
[    0.000000] copy_e820_map() start: 00000000f0008000 size:
0000000000004000 end: 00000000f000c000 type: 2
[    0.000000] copy_e820_map() start: 00000000fed00000 size:
0000000000000400 end: 00000000fed00400 type: 2
[    0.000000] copy_e820_map() start: 00000000fed20000 size:
0000000000070000 end: 00000000fed90000 type: 2
[    0.000000] copy_e820_map() start: 00000000ff000000 size:
0000000001000000 end: 0000000100000000 type: 2
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fee0000 (usable)
[    0.000000]  BIOS-e820: 000000003fee0000 - 000000003feea000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003feea000 - 000000003ff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0006000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0008000 - 00000000f000c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] 126MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 261856) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   261856
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   261856
[    0.000000] On node 0 totalpages: 261856
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 253 pages used for memmap
[    0.000000]   HighMem zone: 32227 pages, LIFO batch:7
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP (v000 PTLTD
) @ 0x000f63f0
[    0.000000] ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP
0x00000000) @ 0x3fee4cf5
[    0.000000] ACPI: MADT (v001 INTEL  ALVISO   0x06040000 LOHR
0x0000005f) @ 0x3fee9e88
[    0.000000] ACPI: FADT (v001 INTEL  ALVISO   0x06040000 LOHR
0x0000005f) @ 0x3fee9ef0
[    0.000000] ACPI: HPET (v001 INTEL  ALVISO   0x06040000 LOHR
0x0000005f) @ 0x3fee9f64
[    0.000000] ACPI: MCFG (v001 INTEL  ALVISO   0x06040000 LOHR
0x0000005f) @ 0x3fee9f9c
[    0.000000] ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP
0x00000001) @ 0x3fee9fd8
[    0.000000] ACPI: SSDT (v001 SataRe  SataPri 0x00001000 INTL
0x20030224) @ 0x3fee5b87
[    0.000000] ACPI: SSDT (v001 SataRe  SataSec 0x00001000 INTL
0x20030224) @ 0x3fee54eb
[    0.000000] ACPI: SSDT (v001  PmRef  Cpu0Ist 0x00003000 INTL
0x20030224) @ 0x3fee50a6
[    0.000000] ACPI: SSDT (v001  PmRef  Cpu0Cst 0x00003001 INTL
0x20030224) @ 0x3fee4f5a
[    0.000000] ACPI: SSDT (v001  PmRef    CpuPm 0x00003000 INTL
0x20030224) @ 0x3fee4d41
[    0.000000] ACPI: DSDT (v001 INTEL  ALVISO   0x06040000 INTL
0x20030224) @ 0x00000000
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:13 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0x0
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:a0000000)
[    0.000000] Detected 1729.177 MHz processor.
[   16.440639] Built 1 zonelists.  Total pages: 259811
[   16.440643] Kernel command line:
root=UUID=3b6c3c49-cca7-4e4e-a451-e577a29a8dc6 ro vga=791
[   16.440799] mapped APIC to ffffd000 (fee00000)
[   16.440801] mapped IOAPIC to ffffc000 (fec00000)
[   16.440805] Enabling fast FPU save and restore... done.
[   16.440807] Enabling unmasked SIMD FPU exception support... done.
[   16.440816] Initializing CPU#0
[   16.440890] PID hash table entries: 4096 (order: 12, 16384 bytes)
[   16.441012] Console: colour dummy device 80x25
[   16.441433] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   16.441849] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   16.472311] Memory: 1027704k/1047424k available (1950k kernel code,
18980k reserved, 878k data, 316k init, 129920k highmem)
[   16.472326] virtual kernel memory layout:
[   16.472327]     fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
[   16.472329]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   16.472330]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   16.472331]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   16.472332]       .init : 0xc03ca000 - 0xc0419000   ( 316 kB)
[   16.472334]       .data : 0xc02e7b50 - 0xc03c36d4   ( 878 kB)
[   16.472335]       .text : 0xc0100000 - 0xc02e7b50   (1950 kB)
[   16.472351] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[   16.531845] Calibrating delay using timer specific routine..
3460.15 BogoMIPS (lpj=1730075)
[   16.531884] Security Framework v1.0.0 initialized
[   16.531893] SELinux:  Disabled at boot.
[   16.531908] Mount-cache hash table entries: 512
[   16.532025] CPU: After generic identify, caps: afe9fbff 00100000
00000000 00000000 00000180 00000000 00000000
[   16.532036] CPU: L1 I cache: 32K, L1 D cache: 32K
[   16.532041] CPU: L2 cache: 2048K
[   16.532045] CPU: After all inits, caps: afe9fbff 00100000 00000000
00002040 00000180 00000000 00000000
[   16.532053] Compat vDSO mapped to ffffe000.
[   16.532065] Checking 'hlt' instruction... OK.
[   16.535925] SMP alternatives: switching to UP code
[   16.536099] Freeing SMP alternatives: 12k freed
[   16.536103] ACPI: Core revision 20060707
[   16.543659] CPU0: Intel(R) Pentium(R) M processor 1.73GHz stepping 08
[   16.543685] Total of 1 processors activated (3460.15 BogoMIPS).
[   16.543881] ENABLING IO-APIC IRQs
[   16.544079] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   16.658811] Brought up 1 CPUs
[   16.659048] NET: Registered protocol family 16
[   16.659122] EISA bus registered
[   16.659128] ACPI: bus type pci registered
[   16.659138] PCI: Using MMCONFIG
[   16.659787] Setting up standard PCI resources
[   16.668332] ACPI: Interpreter enabled
[   16.668336] ACPI: Using IOAPIC for interrupt routing
[   16.668944] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   16.668951] PCI: Probing PCI hardware (bus 00)
[   16.669968] PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[   16.669974] PCI quirk: region 1180-11bf claimed by ICH6 GPIO
[   16.670167] Boot video device is 0000:01:00.0
[   16.670700] PCI: Transparent bridge - 0000:00:1e.0
[   16.670788] PCI: Bus #07 (-#0a) is hidden behind transparent bridge
#06 (-#06) (try 'pci=assign-busses')
[   16.670794] Please report the result to linux-kernel to fix this permanently
[   16.670836] PCI: Bus #0b (-#0e) is hidden behind transparent bridge
#06 (-#06) (try 'pci=assign-busses')
[   16.670842] Please report the result to linux-kernel to fix this permanently
[   16.670873] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   16.672744] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[   16.673121] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[   16.673351] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[   16.673860] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 *4 5 6 7 10 12 14 15)
[   16.674073] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[   16.674292] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[   16.674501] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12
14 15) *10
[   16.674709] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[   16.674921] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12
14 15) *10
[   16.675129] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[   16.675340] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 *5 6 7 11 12 14 15)
[   16.676954] Linux Plug and Play Support v0.97 (c) Adam Belay
[   16.676967] pnp: PnP ACPI init
[   16.679339] pnp: PnP ACPI: found 12 devices
[   16.679345] PnPBIOS: Disabled by ACPI PNP
[   16.679385] PCI: Using ACPI for IRQ routing
[   16.679390] PCI: If a device doesn't work, try "pci=routeirq".  If
it helps, post a report
[   16.679783] PCI: Bridge: 0000:00:01.0
[   16.679787]   IO window: 2000-2fff
[   16.679791]   MEM window: c0100000-c01fffff
[   16.679796]   PREFETCH window: d0000000-d7ffffff
[   16.679800] PCI: Bridge: 0000:00:1c.0
[   16.679804]   IO window: 3000-3fff
[   16.679810]   MEM window: c4000000-c7ffffff
[   16.679815]   PREFETCH window: d8000000-dbffffff
[   16.679832] PCI: Bus 7, cardbus bridge: 0000:06:04.0
[   16.679836]   IO window: 00004400-000044ff
[   16.679842]   IO window: 00004800-000048ff
[   16.679849]   PREFETCH window: 50000000-53ffffff
[   16.679855]   MEM window: 58000000-5bffffff
[   16.679861] PCI: Bus 11, cardbus bridge: 0000:06:04.1
[   16.679865]   IO window: 00004c00-00004cff
[   16.679870]   IO window: 00001400-000014ff
[   16.679877]   PREFETCH window: 54000000-57ffffff
[   16.679884]   MEM window: 5c000000-5fffffff
[   16.679890] PCI: Bridge: 0000:00:1e.0
[   16.679894]   IO window: 4000-4fff
[   16.679900]   MEM window: c8000000-c80fffff
[   16.679905]   PREFETCH window: 50000000-57ffffff
[   16.679917] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   16.679924] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   16.679939] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level,
low) -> IRQ 17
[   16.679947] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   16.679957] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   16.679972] PCI: Enabling device 0000:06:04.0 (0000 -> 0003)
[   16.679978] ACPI: PCI Interrupt 0000:06:04.0[A] -> GSI 22 (level,
low) -> IRQ 18
[   16.680000] PCI: Enabling device 0000:06:04.1 (0000 -> 0003)
[   16.680007] ACPI: PCI Interrupt 0000:06:04.1[B] -> GSI 21 (level,
low) -> IRQ 19
[   16.680017] PCI: Setting latency timer of device 0000:06:04.1 to 64
[   16.680034] NET: Registered protocol family 2
[   16.689706] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   16.689814] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[   16.690740] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   16.691371] TCP: Hash tables configured (established 131072 bind 65536)
[   16.691378] TCP reno registered
[   16.693925] checking if image is initramfs... it is
[   17.267064] Freeing initrd memory: 6366k freed
[   17.267347] Simple Boot Flag at 0x37 set to 0x1
[   17.267562] audit: initializing netlink socket (disabled)
[   17.267579] audit(1170315603.011:1): initialized
[   17.267646] highmem bounce pool size: 64 pages
[   17.267705] VFS: Disk quotas dquot_6.5.1
[   17.267726] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   17.267777] io scheduler noop registered
[   17.267781] io scheduler anticipatory registered
[   17.267785] io scheduler deadline registered
[   17.267796] io scheduler cfq registered (default)
[   17.268139] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   17.268164] assign_interrupt_mode Found MSI capability
[   17.268195] Allocate Port Service[0000:00:01.0:pcie00]
[   17.268224] Allocate Port Service[0000:00:01.0:pcie03]
[   17.268278] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   17.268313] assign_interrupt_mode Found MSI capability
[   17.268343] Allocate Port Service[0000:00:1c.0:pcie00]
[   17.268370] Allocate Port Service[0000:00:1c.0:pcie02]
[   17.268396] Allocate Port Service[0000:00:1c.0:pcie03]
[   17.268532] isapnp: Scanning for PnP cards...
[   17.625458] isapnp: No Plug & Play device found
[   17.645453] Real Time Clock Driver v1.12ac
[   17.645650] hpet_acpi_add: no address or irqs in _CRS
[   17.645664] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports,
IRQ sharing enabled
[   17.646677] RAMDISK driver initialized: 16 RAM disks of 65536K size
1024 blocksize
[   17.646772] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   17.646778] ide: Assuming 33MHz system bus speed for PIO modes;
override with idebus=xx
[   17.647034] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at
0x60,0x64 irq 1,12
[   17.648931] i8042.c: Detected active multiplexing controller, rev 1.1.
[   17.650165] serio: i8042 KBD port at 0x60,0x64 irq 1
[   17.650171] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   17.650175] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   17.650179] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   17.650183] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   17.650371] mice: PS/2 mouse device common for all mice
[   17.650454] EISA: Probing bus 0 at eisa.0
[   17.650464] Cannot allocate resource for EISA slot 1
[   17.650468] Cannot allocate resource for EISA slot 2
[   17.650472] Cannot allocate resource for EISA slot 3
[   17.650475] Cannot allocate resource for EISA slot 4
[   17.650495] EISA: Detected 0 cards.
[   17.680583] TCP cubic registered
[   17.680593] NET: Registered protocol family 1
[   17.680600] NET: Registered protocol family 8
[   17.680603] NET: Registered protocol family 20
[   17.680665] Using IPI No-Shortcut mode
[   17.680714] ACPI: (supports S0 S3 S4 S5)
[   17.680911] Freeing unused kernel memory: 316k freed
[   17.681185] Time: tsc clocksource has been installed.
[   17.694413] input: AT Translated Set 2 keyboard as /class/input/input0
[   17.749894] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   17.749903] ACPI: Processor [CPU0] (supports 8 throttling states)
[   17.749912] ACPI Exception (acpi_processor-0677): AE_NOT_FOUND,
Processor Device is not present [20060707]
[    1.210000] Time: acpi_pm clocksource has been installed.
[    1.274000] ACPI: Invalid passive threshold
[    1.276000] ACPI: Thermal Zone [THM0] (50 C)
[    1.556000] ICH6: IDE controller at PCI slot 0000:00:1f.1
[    1.556000] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level,
low) -> IRQ 20
[    1.556000] ICH6: chipset revision 4
[    1.556000] ICH6: not 100% native mode: will probe irqs later
[    1.556000]     ide0: BM-DMA at 0x1860-0x1867, BIOS settings:
hda:DMA, hdb:DMA
[    1.556000] Probing IDE interface ide0...
[    1.820000] hda: SAMSUNG MP0804H, ATA DISK drive
[    2.534000] hdb: MATSHITAUJ-840D, ATAPI CD/DVD-ROM drive
[    2.585000] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.589000] hda: max request size: 512KiB
[    2.599000] hda: 156368016 sectors (80060 MB) w/8192KiB Cache,
CHS=16383/255/63, UDMA(100)
[    2.599000] hda: cache flushes supported
[    2.599000]  hda: hda1 hda2 hda3 hda4
[    2.624000] hdb: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB
Cache, UDMA(33)
[    2.624000] Uniform CD-ROM driver Revision: 3.20
[    2.936000] Probing IDE interface ide1...
[    2.967000] usbcore: registered new interface driver usbfs
[    2.967000] usbcore: registered new interface driver hub
[    2.967000] usbcore: registered new device driver usb
[    2.968000] USB Universal Host Controller Interface driver v3.0
[    2.968000] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level,
low) -> IRQ 21
[    2.968000] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    2.968000] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.968000] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 1
[    2.968000] uhci_hcd 0000:00:1d.0: irq 21, io base 0x00001800
[    2.968000] usb usb1: configuration #1 chosen from 1 choice
[    2.968000] hub 1-0:1.0: USB hub found
[    2.968000] hub 1-0:1.0: 2 ports detected
[    3.016000] ieee1394: Initialized config rom entry `ip1394'
[    3.069000] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level,
low) -> IRQ 22
[    3.069000] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    3.069000] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.069000] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 2
[    3.069000] uhci_hcd 0000:00:1d.1: irq 22, io base 0x00001820
[    3.069000] usb usb2: configuration #1 chosen from 1 choice
[    3.070000] hub 2-0:1.0: USB hub found
[    3.070000] hub 2-0:1.0: 2 ports detected
[    3.171000] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level,
low) -> IRQ 20
[    3.171000] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    3.171000] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.171000] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 3
[    3.171000] uhci_hcd 0000:00:1d.2: irq 20, io base 0x00001840
[    3.171000] usb usb3: configuration #1 chosen from 1 choice
[    3.171000] hub 3-0:1.0: USB hub found
[    3.171000] hub 3-0:1.0: 2 ports detected
[    3.272000] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level,
low) -> IRQ 21
[    3.272000] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    3.272000] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.272000] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 4
[    3.272000] ehci_hcd 0000:00:1d.7: debug port 1
[    3.272000] PCI: cache line size of 32 is not supported by device
0000:00:1d.7
[    3.272000] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xc0004000
[    3.276000] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
[    3.276000] usb 1-2: new low speed USB device using uhci_hcd and address 2
[    3.277000] usb usb4: configuration #1 chosen from 1 choice
[    3.277000] hub 4-0:1.0: USB hub found
[    3.277000] hub 4-0:1.0: 6 ports detected
[    3.378000] ACPI: PCI Interrupt 0000:06:02.0[A] -> GSI 21 (level,
low) -> IRQ 19
[    3.437000] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]
MMIO=[c8004000-c80047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    3.706000] ReiserFS: hda4: found reiserfs format "3.6" with standard journal
[    3.706000] ReiserFS: hda4: using ordered data mode
[    3.718000] ReiserFS: hda4: journal params: device hda4, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit
age 30, max trans age 30
[    3.719000] ReiserFS: hda4: checking transaction log (hda4)
[    3.775000] usb 1-2: new low speed USB device using uhci_hcd and address 3
[    3.790000] ReiserFS: hda4: Using r5 hash to sort names
[    3.944000] usb 1-2: configuration #1 chosen from 1 choice
[    4.693000] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0090f50000000003]
[   24.432000] input: PC Speaker as /class/input/input1
[   24.483000] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   24.489000] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   24.558000] parport: PnPBIOS parport detected.
[   24.558000] parport0: PC-style at 0x378 (0x778), irq 7, dma 1
[PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[   24.736000] Yenta: CardBus bridge found at 0000:06:04.0 [1558:04a0]
[   24.736000] Yenta: Enabling burst memory read transactions
[   24.736000] Yenta: Using CSCINT to route CSC interrupts to PCI
[   24.736000] Yenta: Routing CardBus interrupts to PCI
[   24.736000] Yenta TI: socket 0000:06:04.0, mfunc 0x00000022, devctl 0x64
[   24.768000] ieee80211_crypt: registered algorithm 'NULL'
[   24.770000] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   24.770000] ieee80211: Copyright (C) 2004-2005 Intel Corporation
<jketreno@linux.intel.com>
[   24.850000] irda_init()
[   24.850000] NET: Registered protocol family 23
[   24.880000] Linux agpgart interface v0.101 (c) Dave Jones
[   24.882000] agpgart: Detected an Intel 915GM Chipset.
[   24.899000] agpgart: AGP aperture is 256M @ 0x0
[   24.905000] intel_rng: FWH not detected
[   24.921000] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network
Driver, 1.2.0kmprq
[   24.921000] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   24.963000] Yenta: ISA IRQ mask 0x0000, PCI irq 18
[   24.963000] Socket status: 30000010
[   24.963000] Yenta: Raising subordinate bus# of parent bus (#06)
from #06 to #0a
[   24.963000] pcmcia: parent PCI bridge I/O window: 0x4000 - 0x4fff
[   24.963000] cs: IO port probe 0x4000-0x4fff: clean.
[   24.964000] pcmcia: parent PCI bridge Memory window: 0xc8000000 - 0xc80fffff
[   24.964000] pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x57ffffff
[   24.967000] Yenta: CardBus bridge found at 0000:06:04.1 [1558:04a0]
[   24.967000] Yenta: Using CSCINT to route CSC interrupts to PCI
[   24.967000] Yenta: Routing CardBus interrupts to PCI
[   24.967000] Yenta TI: socket 0000:06:04.1, mfunc 0x00000022, devctl 0x64
[   25.191000] Yenta: ISA IRQ mask 0x0000, PCI irq 19
[   25.191000] Socket status: 30000006
[   25.191000] Yenta: Raising subordinate bus# of parent bus (#06)
from #0a to #0e
[   25.191000] pcmcia: parent PCI bridge I/O window: 0x4000 - 0x4fff
[   25.191000] cs: IO port probe 0x4000-0x4fff: clean.
[   25.191000] pcmcia: parent PCI bridge Memory window: 0xc8000000 - 0xc80fffff
[   25.191000] pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x57ffffff
[   25.191000] ACPI: PCI Interrupt 0000:06:03.0[A] -> GSI 20 (level,
low) -> IRQ 23
[   25.191000] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 20 (level,
low) -> IRQ 23
[   25.191000] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   25.191000] ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
[   25.200000] input: ImPS/2 Logitech Wheel Mouse as /class/input/input2
[   25.205000] nsc_ircc_pnp_probe() : From PnP, found firbase 0x2F8 ;
irq 3 ; dma 0.
[   25.206000] nsc-ircc, chip->init
[   25.206000] nsc-ircc, Found chip at base=0x02e
[   25.206000] nsc-ircc, Wrong chip version ff
[   25.206000] nsc-ircc, Found chip at base=0x02e
[   25.206000] nsc-ircc, Wrong chip version ff
[   25.206000] nsc-ircc, chip->init
[   25.206000] nsc-ircc, Found chip at base=0x02e
[   25.206000] nsc-ircc, Wrong chip version ff
[   25.206000] nsc-ircc, Found chip at base=0x02e
[   25.206000] nsc-ircc, Wrong chip version ff
[   25.206000] pnp: Device 00:08 disabled.
[   25.238000] hda_codec: Unknown model for ALC880, trying auto-probe
from BIOS...
[   25.552000] ipw2200: Detected geography ZZE (13 802.11bg channels,
19 802.11a channels)
[   25.552000] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   25.552000] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   25.552000] sky2 v1.10 addr 0xc4000000 irq 16 Yukon-EC (0xb6) rev 2
[   25.553000] sky2 eth1: addr 00:90:f5:46:cd:0f
[   25.576000] usbcore: registered new interface driver hiddev
[   25.650000] pccard: PCMCIA card inserted into slot 0
[   25.666000] input: Microsoft Microsoft 3-Button Mouse with
IntelliEye(TM) as /class/input/input3
[   25.666000] input: USB HID v1.10 Mouse [Microsoft Microsoft
3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1d.0-2
[   25.666000] usbcore: registered new interface driver usbhid
[   25.666000] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   25.804000] cs: memory probe 0xc8000000-0xc80fffff: excluding
0xc8000000-0xc800ffff
[   25.819000] pcmcia: registering new device pcmcia0.0
[   25.924000] orinoco 0.15 (David Gibson
<hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
[   26.119000] cs: IO port probe 0x100-0x4ff: excluding 0x3c0-0x3df 0x4d0-0x4d7
[   26.121000] cs: IO port probe 0xc00-0xcf7: clean.
[   26.122000] cs: IO port probe 0xa00-0xaff: clean.
[   26.127000] cs: IO port probe 0x100-0x4ff: excluding 0x3c0-0x3df 0x4d0-0x4d7
[   26.130000] cs: IO port probe 0xc00-0xcf7: clean.
[   26.130000] cs: IO port probe 0xa00-0xaff: clean.
[   26.156000] orinoco_cs 0.15 (David Gibson
<hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
[   26.156000] pcmcia: request for exclusive IRQ could not be fulfilled.
[   26.156000] pcmcia: the driver needs updating to supported shared IRQ lines.
[   26.343000] eth1: Hardware identity 8000:0001:0000:0000
[   26.343000] eth1: Station identity  001f:0002:0002:0001
[   26.344000] eth1: Firmware determined as Symbol V2.51-04
[   26.344000] eth1: Ad-hoc demo mode supported
[   26.344000] eth1: IEEE standard IBSS ad-hoc mode supported
[   26.344000] eth1: WEP supported, 104-bit key
[   26.344000] eth1: MAC address 00:02:B3:04:7B:F6
[   26.344000] eth1: Station name "Prism  I"
[   26.344000] eth1: ready
[   26.346000] eth1: orinoco_cs at 0.0, irq 18, io 0x4080-0x40c7
[   26.569000] lp0: using parport0 (interrupt-driven).
[   26.742000] SCSI subsystem initialized
[   26.988000] Adding 1461904k swap on
/dev/disk/by-uuid/9bf56c5a-2881-4820-879b-9b6db2644a31.  Priority:-1
extents:1 across:1461904k
[   38.651000] ip_tables: (C) 2000-2006 Netfilter Core Team
[   39.799000] PPP generic driver version 2.4.2
[   39.820000] NET: Registered protocol family 17
[   40.768000] Using specific hotkey driver
[   40.828000] ACPI: AC Adapter [ADP0] (on-line)
[   40.838000] No dock devices found.
[   40.872000] toshiba_acpi: Unknown parameter `hotkeys_over_acpi'
[   40.916000] input: Power Button (FF) as /class/input/input4
[   40.927000] ACPI: Power Button (FF) [PWRF]
[   40.963000] input: Power Button (CM) as /class/input/input5
[   40.973000] ACPI: Power Button (CM) [PWRB]
[   41.002000] input: Lid Switch as /class/input/input6
[   41.002000] ACPI: Lid Switch [LID0]
[   41.018000] input: Sleep Button (CM) as /class/input/input7
[   41.018000] ACPI: Sleep Button (CM) [SLPB]
[   41.096000] ibm_acpi: ec object not found
[   41.111000] ACPI: Battery Slot [BAT0] (battery present)
[   41.120000] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[   41.286000] speedstep-centrino with X86_SPEEDSTEP_CENTRINO_ACPI
config is deprecated.
[   41.286000]  Use X86_ACPI_CPUFREQ (acpi-cpufreq) instead.
[   44.728000] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   44.728000] apm: overridden by ACPI.
[   48.985000] mtrr: no more MTRRs available
[   48.985000] mtrr: no more MTRRs available
[   48.985000] mtrr: no more MTRRs available
[   48.985000] mtrr: no more MTRRs available
[  216.408000] usb 4-3: new high speed USB device using ehci_hcd and address 3
[  216.537000] usb 4-3: configuration #1 chosen from 1 choice
[  216.650000] usbcore: registered new interface driver libusual
[  216.664000] Initializing USB Mass Storage driver...
[  216.664000] scsi0 : SCSI emulation for USB Mass Storage devices
[  216.664000] usbcore: registered new interface driver usb-storage
[  216.664000] USB Mass Storage support registered.
[  216.664000] usb-storage: device found at 3
[  216.664000] usb-storage: waiting for device to settle before scanning
[  221.668000] scsi 0:0:0:0: Direct-Access     GENERIC  USB
Storage-SMC  I16A PQ: 0 ANSI: 0 CCS
[  221.673000] scsi 0:0:0:1: Direct-Access     GENERIC  USB
Storage-CFC  I16A PQ: 0 ANSI: 0 CCS
[  221.678000] scsi 0:0:0:2: Direct-Access     GENERIC  USB
Storage-SDC  I16A PQ: 0 ANSI: 0 CCS
[  221.683000] scsi 0:0:0:3: Direct-Access     GENERIC  USB
Storage-MSC  I16A PQ: 0 ANSI: 0 CCS
[  221.691000] usb-storage: device scan complete
[  221.792000] sd 0:0:0:0: Attached scsi removable disk sda
[  221.794000] sd 0:0:0:1: Attached scsi removable disk sdb
[  221.798000] SCSI device sdc: 1992704 512-byte hdwr sectors (1020 MB)
[  221.812000] sdc: Write Protect is off
[  221.812000] sdc: Mode Sense: 00 00 00 00
[  221.812000] sdc: assuming drive cache: write through
[  221.837000] SCSI device sdc: 1992704 512-byte hdwr sectors (1020 MB)
[  221.849000] sdc: Write Protect is off
[  221.849000] sdc: Mode Sense: 00 00 00 00
[  221.849000] sdc: assuming drive cache: write through
[  221.849000]  sdc: sdc1
[  221.851000]  sdc: p1 exceeds device capacity
[  221.852000] sd 0:0:0:2: Attached scsi removable disk sdc
[  221.854000] sd 0:0:0:3: Attached scsi removable disk sdd
[  221.878000] sd 0:0:0:0: Attached scsi generic sg0 type 0
[  221.879000] sd 0:0:0:1: Attached scsi generic sg1 type 0
[  221.879000] sd 0:0:0:2: Attached scsi generic sg2 type 0
[  221.879000] sd 0:0:0:3: Attached scsi generic sg3 type 0
[  222.030000] attempt to access beyond end of device
[  222.030000] sdc: rw=0, want=3985272, limit=1992704
[  222.030000] Buffer I/O error on device sdc1, logical block 3985024
[  222.031000] attempt to access beyond end of device
[  222.031000] sdc: rw=0, want=3985273, limit=1992704
[  222.031000] Buffer I/O error on device sdc1, logical block 3985025
[  222.031000] attempt to access beyond end of device
[  222.031000] sdc: rw=0, want=3985274, limit=1992704
[  222.031000] Buffer I/O error on device sdc1, logical block 3985026
[  222.031000] attempt to access beyond end of device
[  222.031000] sdc: rw=0, want=3985275, limit=1992704
[  222.031000] Buffer I/O error on device sdc1, logical block 3985027
[  222.032000] attempt to access beyond end of device
[  222.032000] sdc: rw=0, want=3985276, limit=1992704
[  222.032000] Buffer I/O error on device sdc1, logical block 3985028
[  222.032000] attempt to access beyond end of device
[  222.032000] sdc: rw=0, want=3985277, limit=1992704
[  222.032000] Buffer I/O error on device sdc1, logical block 3985029
[  222.033000] attempt to access beyond end of device
[  222.033000] sdc: rw=0, want=3985278, limit=1992704
[  222.033000] Buffer I/O error on device sdc1, logical block 3985030
[  222.033000] attempt to access beyond end of device
[  222.033000] sdc: rw=0, want=3985279, limit=1992704
[  222.033000] Buffer I/O error on device sdc1, logical block 3985031
[  222.034000] attempt to access beyond end of device
[  222.034000] sdc: rw=0, want=3985272, limit=1992704
[  222.034000] Buffer I/O error on device sdc1, logical block 3985024
[  222.034000] attempt to access beyond end of device
[  222.034000] sdc: rw=0, want=3985273, limit=1992704
[  222.034000] Buffer I/O error on device sdc1, logical block 3985025
[  222.035000] attempt to access beyond end of device
[  222.035000] sdc: rw=0, want=3985274, limit=1992704
[  222.035000] attempt to access beyond end of device
[  222.035000] sdc: rw=0, want=3985275, limit=1992704
[  222.035000] attempt to access beyond end of device
[  222.035000] sdc: rw=0, want=3985276, limit=1992704
[  222.036000] attempt to access beyond end of device
[  222.036000] sdc: rw=0, want=3985277, limit=1992704
[  222.036000] attempt to access beyond end of device
[  222.036000] sdc: rw=0, want=3985278, limit=1992704
[  222.036000] attempt to access beyond end of device
[  222.036000] sdc: rw=0, want=3985279, limit=1992704
[  222.037000] attempt to access beyond end of device
[  222.037000] sdc: rw=0, want=3985400, limit=1992704
[  222.037000] attempt to access beyond end of device
[  222.037000] sdc: rw=0, want=3985401, limit=1992704
[  222.037000] attempt to access beyond end of device
[  222.037000] sdc: rw=0, want=3985402, limit=1992704
[  222.037000] attempt to access beyond end of device
[  222.037000] sdc: rw=0, want=3985403, limit=1992704
[  222.038000] attempt to access beyond end of device
[  222.038000] sdc: rw=0, want=3985404, limit=1992704
[  222.038000] attempt to access beyond end of device
[  222.038000] sdc: rw=0, want=3985405, limit=1992704
[  222.038000] attempt to access beyond end of device
[  222.038000] sdc: rw=0, want=3985406, limit=1992704
[  222.039000] attempt to access beyond end of device
[  222.039000] sdc: rw=0, want=3985407, limit=1992704
[  222.039000] attempt to access beyond end of device
[  222.039000] sdc: rw=0, want=3985400, limit=1992704
[  222.039000] attempt to access beyond end of device
[  222.039000] sdc: rw=0, want=3985401, limit=1992704
[  222.040000] attempt to access beyond end of device
[  222.040000] sdc: rw=0, want=3985402, limit=1992704
[  222.040000] attempt to access beyond end of device
[  222.040000] sdc: rw=0, want=3985403, limit=1992704
[  222.040000] attempt to access beyond end of device
[  222.040000] sdc: rw=0, want=3985404, limit=1992704
[  222.040000] attempt to access beyond end of device
[  222.040000] sdc: rw=0, want=3985405, limit=1992704
[  222.041000] attempt to access beyond end of device
[  222.041000] sdc: rw=0, want=3985406, limit=1992704
[  222.041000] attempt to access beyond end of device
[  222.041000] sdc: rw=0, want=3985407, limit=1992704
[  222.041000] attempt to access beyond end of device
[  222.041000] sdc: rw=0, want=3985408, limit=1992704
[  222.042000] attempt to access beyond end of device
[  222.042000] sdc: rw=0, want=3985408, limit=1992704
[  222.042000] attempt to access beyond end of device
[  222.042000] sdc: rw=0, want=3985408, limit=1992704
[  222.042000] attempt to access beyond end of device
[  222.042000] sdc: rw=0, want=3985408, limit=1992704
[  222.043000] attempt to access beyond end of device
[  222.043000] sdc: rw=0, want=3985400, limit=1992704
[  222.043000] attempt to access beyond end of device
[  222.043000] sdc: rw=0, want=3985401, limit=1992704
[  222.043000] attempt to access beyond end of device
[  222.043000] sdc: rw=0, want=3985402, limit=1992704
[  222.044000] attempt to access beyond end of device
[  222.044000] sdc: rw=0, want=3985403, limit=1992704
[  222.044000] attempt to access beyond end of device
[  222.044000] sdc: rw=0, want=3985404, limit=1992704
[  222.044000] attempt to access beyond end of device
[  222.044000] sdc: rw=0, want=3985405, limit=1992704
[  222.044000] attempt to access beyond end of device
[  222.044000] sdc: rw=0, want=3985406, limit=1992704
[  222.045000] attempt to access beyond end of device
[  222.045000] sdc: rw=0, want=3985407, limit=1992704
[  222.045000] attempt to access beyond end of device
[  222.045000] sdc: rw=0, want=3985344, limit=1992704
[  222.045000] attempt to access beyond end of device
[  222.045000] sdc: rw=0, want=3985345, limit=1992704
[  222.046000] attempt to access beyond end of device
[  222.046000] sdc: rw=0, want=3985346, limit=1992704
[  222.046000] attempt to access beyond end of device
[  222.046000] sdc: rw=0, want=3985347, limit=1992704
[  222.046000] attempt to access beyond end of device
[  222.046000] sdc: rw=0, want=3985348, limit=1992704
[  222.047000] attempt to access beyond end of device
[  222.047000] sdc: rw=0, want=3985349, limit=1992704
[  222.047000] attempt to access beyond end of device
[  222.047000] sdc: rw=0, want=3985350, limit=1992704
[  222.047000] attempt to access beyond end of device
[  222.047000] sdc: rw=0, want=3985351, limit=1992704
[  222.048000] attempt to access beyond end of device
[  222.048000] sdc: rw=0, want=3985392, limit=1992704
[  222.048000] attempt to access beyond end of device
[  222.048000] sdc: rw=0, want=3985393, limit=1992704
[  222.048000] attempt to access beyond end of device
[  222.048000] sdc: rw=0, want=3985394, limit=1992704
[  222.049000] attempt to access beyond end of device
[  222.049000] sdc: rw=0, want=3985395, limit=1992704
[  222.049000] attempt to access beyond end of device
[  222.049000] sdc: rw=0, want=3985396, limit=1992704
[  222.049000] attempt to access beyond end of device
[  222.049000] sdc: rw=0, want=3985397, limit=1992704
[  222.050000] attempt to access beyond end of device
[  222.050000] sdc: rw=0, want=3985398, limit=1992704
[  222.050000] attempt to access beyond end of device
[  222.050000] sdc: rw=0, want=3985399, limit=1992704
[  222.050000] attempt to access beyond end of device
[  222.050000] sdc: rw=0, want=3985408, limit=1992704
[  222.050000] attempt to access beyond end of device
[  222.050000] sdc: rw=0, want=3985408, limit=1992704
[  222.108000] attempt to access beyond end of device
[  222.108000] sdc: rw=0, want=3985272, limit=1992704
[  222.109000] attempt to access beyond end of device
[  222.109000] sdc: rw=0, want=3985273, limit=1992704
[  222.109000] attempt to access beyond end of device
[  222.109000] sdc: rw=0, want=3985274, limit=1992704
[  222.109000] attempt to access beyond end of device
[  222.109000] sdc: rw=0, want=3985275, limit=1992704
[  222.110000] attempt to access beyond end of device
[  222.110000] sdc: rw=0, want=3985276, limit=1992704
[  222.110000] attempt to access beyond end of device
[  222.110000] sdc: rw=0, want=3985277, limit=1992704
[  222.110000] attempt to access beyond end of device
[  222.110000] sdc: rw=0, want=3985278, limit=1992704
[  222.111000] attempt to access beyond end of device
[  222.111000] sdc: rw=0, want=3985279, limit=1992704
[  222.111000] attempt to access beyond end of device
[  222.111000] sdc: rw=0, want=3985272, limit=1992704
[  222.111000] attempt to access beyond end of device
[  222.111000] sdc: rw=0, want=3985273, limit=1992704
[  222.112000] attempt to access beyond end of device
[  222.112000] sdc: rw=0, want=3985274, limit=1992704
[  222.112000] attempt to access beyond end of device
[  222.112000] sdc: rw=0, want=3985275, limit=1992704
[  222.112000] attempt to access beyond end of device
[  222.112000] sdc: rw=0, want=3985276, limit=1992704
[  222.113000] attempt to access beyond end of device
[  222.113000] sdc: rw=0, want=3985277, limit=1992704
[  222.113000] attempt to access beyond end of device
[  222.113000] sdc: rw=0, want=3985278, limit=1992704
[  222.113000] attempt to access beyond end of device
[  222.113000] sdc: rw=0, want=3985279, limit=1992704
[  222.114000] attempt to access beyond end of device
[  222.114000] sdc: rw=0, want=3985400, limit=1992704
[  222.114000] attempt to access beyond end of device
[  222.114000] sdc: rw=0, want=3985401, limit=1992704
[  222.114000] attempt to access beyond end of device
[  222.114000] sdc: rw=0, want=3985402, limit=1992704
[  222.114000] attempt to access beyond end of device
[  222.114000] sdc: rw=0, want=3985403, limit=1992704
[  222.115000] attempt to access beyond end of device
[  222.115000] sdc: rw=0, want=3985404, limit=1992704
[  222.115000] attempt to access beyond end of device
[  222.115000] sdc: rw=0, want=3985405, limit=1992704
[  222.115000] attempt to access beyond end of device
[  222.115000] sdc: rw=0, want=3985406, limit=1992704
[  222.116000] attempt to access beyond end of device
[  222.116000] sdc: rw=0, want=3985407, limit=1992704
[  222.116000] attempt to access beyond end of device
[  222.116000] sdc: rw=0, want=3985400, limit=1992704
[  222.116000] attempt to access beyond end of device
[  222.116000] sdc: rw=0, want=3985401, limit=1992704
[  222.117000] attempt to access beyond end of device
[  222.117000] sdc: rw=0, want=3985402, limit=1992704
[  222.117000] attempt to access beyond end of device
[  222.117000] sdc: rw=0, want=3985403, limit=1992704
[  222.117000] attempt to access beyond end of device
[  222.117000] sdc: rw=0, want=3985404, limit=1992704
[  222.117000] attempt to access beyond end of device
[  222.117000] sdc: rw=0, want=3985405, limit=1992704
[  222.118000] attempt to access beyond end of device
[  222.118000] sdc: rw=0, want=3985406, limit=1992704
[  222.118000] attempt to access beyond end of device
[  222.118000] sdc: rw=0, want=3985407, limit=1992704
[  222.118000] attempt to access beyond end of device
[  222.118000] sdc: rw=0, want=3985408, limit=1992704
[  222.119000] attempt to access beyond end of device
[  222.119000] sdc: rw=0, want=3985408, limit=1992704
[  222.119000] attempt to access beyond end of device
[  222.119000] sdc: rw=0, want=3985408, limit=1992704
[  222.119000] attempt to access beyond end of device
[  222.119000] sdc: rw=0, want=3985408, limit=1992704
[  222.120000] attempt to access beyond end of device
[  222.120000] sdc: rw=0, want=3985400, limit=1992704
[  222.120000] attempt to access beyond end of device
[  222.120000] sdc: rw=0, want=3985401, limit=1992704
[  222.120000] attempt to access beyond end of device
[  222.120000] sdc: rw=0, want=3985402, limit=1992704
[  222.121000] attempt to access beyond end of device
[  222.121000] sdc: rw=0, want=3985403, limit=1992704
[  222.121000] attempt to access beyond end of device
[  222.121000] sdc: rw=0, want=3985404, limit=1992704
[  222.121000] attempt to access beyond end of device
[  222.121000] sdc: rw=0, want=3985405, limit=1992704
[  222.121000] attempt to access beyond end of device
[  222.121000] sdc: rw=0, want=3985406, limit=1992704
[  222.122000] attempt to access beyond end of device
[  222.122000] sdc: rw=0, want=3985407, limit=1992704
[  222.122000] attempt to access beyond end of device
[  222.122000] sdc: rw=0, want=3985344, limit=1992704
[  222.122000] attempt to access beyond end of device
[  222.122000] sdc: rw=0, want=3985345, limit=1992704
[  222.123000] attempt to access beyond end of device
[  222.123000] sdc: rw=0, want=3985346, limit=1992704
[  222.123000] attempt to access beyond end of device
[  222.123000] sdc: rw=0, want=3985347, limit=1992704
[  222.123000] attempt to access beyond end of device
[  222.123000] sdc: rw=0, want=3985348, limit=1992704
[  222.124000] attempt to access beyond end of device
[  222.124000] sdc: rw=0, want=3985349, limit=1992704
[  222.124000] attempt to access beyond end of device
[  222.124000] sdc: rw=0, want=3985350, limit=1992704
[  222.124000] attempt to access beyond end of device
[  222.124000] sdc: rw=0, want=3985351, limit=1992704
[  222.124000] attempt to access beyond end of device
[  222.124000] sdc: rw=0, want=3985392, limit=1992704
[  222.125000] attempt to access beyond end of device
[  222.125000] sdc: rw=0, want=3985393, limit=1992704
[  222.125000] attempt to access beyond end of device
[  222.125000] sdc: rw=0, want=3985394, limit=1992704
[  222.125000] attempt to access beyond end of device
[  222.125000] sdc: rw=0, want=3985395, limit=1992704
[  222.126000] attempt to access beyond end of device
[  222.126000] sdc: rw=0, want=3985396, limit=1992704
[  222.126000] attempt to access beyond end of device
[  222.126000] sdc: rw=0, want=3985397, limit=1992704
[  222.126000] attempt to access beyond end of device
[  222.126000] sdc: rw=0, want=3985398, limit=1992704
[  222.127000] attempt to access beyond end of device
[  222.127000] sdc: rw=0, want=3985399, limit=1992704
[  222.410000] FAT: utf8 is not a recommended IO charset for FAT
filesystems, filesystem will be case sensitive!
[  224.046000] FAT: Filesystem panic (dev sdc1)
[  224.046000]     fat_get_cluster: invalid cluster chain (i_pos 0)
[  224.046000]     File system has been set read-only
[  224.048000] FAT: Filesystem panic (dev sdc1)
[  224.048000]     fat_get_cluster: invalid cluster chain (i_pos 0)
[  224.049000] FAT: Filesystem panic (dev sdc1)

Under Windows (XP or Windows Mobile 2005 (PDA)  i see 2GB capacity,
works correctly.

Please ask for more info.

Thank you!

--
kobi
