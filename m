Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbYBXJmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbYBXJmQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 04:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYBXJmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 04:42:04 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:10182 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbYBXJl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 04:41:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GVE2CLrv5NKGFrQYR3EXIVHpOw+bU/qMbI1AnCUxkrK+CS0R38RnvJmubJ8msK27G0kLbLZxrHRz+QWzxGY89sanm7oeyDifDHM2em07BIUUT/6VOsF+LZ86KZPAct3uReO/rBRPowQMbxi6C1OXRGL0iq8lbwe3mXvAmgyZZQY=
Message-ID: <df0436a0802240141x2965ad62pd5cfbb751864cf79@mail.gmail.com>
Date: Sun, 24 Feb 2008 11:41:53 +0200
From: "Vitaly Kroivets" <vitalyk678@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: help needed : kernel 2.4 sata_nv smp 4G
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I need help with following problem.
We use kernel 2.4.32 ,
Motherboard is Tyan k8SE which uses Nvidia Nforce 2200 (CK8-04) chips,
we have 2 Dualcore opterons and 4G ram , and SATA disk WD1600YS-01S .
Sometimes (once a 3-4 weeks) the computer stops responding with following
message:

ata1: command 0x35 timeout, stat 0xd0 host_stat 0x21
ata1: translated ATA stat/err 0xd0/00 to SCSI SK/ASC/ASCQ 0xb/47/00
ata1: status=0xd0 { Busy }
SCSI disk error : host 0 channel 0 id 0 lun 0 return code = 8000002
Current sd08:03: sense key Aborted Command
Additional sense indicates Scsi parity error
I/O error: dev 08:03, sector 5367736
ATA: abnormal status 0xD0 on port 0x1447
ATA: abnormal status 0xD0 on port 0x1447
ATA: abnormal status 0xD0 on port 0x1447

Here is similar error reported in 2.6.
- http://readlist.com/lists/vger.kernel.org/linux-kernel/30/154602.html
But although we have a recent sata_nv code, it still does not work...
Unfortunately we can not upgrade  to 2.6 now.

Do you know how I reproduce and fix this problem reliably?
Why it happens?

Any help will be appreciated very much.

Thanks in advance,
  Vitaly

Below I added the output of dmesg and kernel config.

cross CPUs: passed.
migration_task 0 on cpu=0
migration_task 1 on cpu=1
migration_task 2 on cpu=2
migration_task 3 on cpu=3
ACPI: Subsystem revision 20040326
PCI: PCI BIOS revision 2.10 entry at 0xfd741, last bus=26
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: System [ACPI] (supports S0 S1 S4 S5)
ACPI: PCI Root Bridge [PCI0] (00:00)
PCI: Probing PCI hardware (bus 00)
Transparent bridge - PCI device 10de:005c
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Root Bridge [PCI2] (00:18)
PCI: Probing PCI hardware (bus 18)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PB._PRT]
PCI: Probing PCI hardware
ACPI: PCI Interrupt Link [LSMB] enabled at IRQ 23
00:00:01[A] -> 4-23 -> IRQ 23 level high
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
00:00:02[A] -> 4-22 -> IRQ 22 level high
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 21
00:00:02[B] -> 4-21 -> IRQ 21 level high
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
00:00:0a[A] -> 4-20 -> IRQ 20 level high
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 23
ACPI: PCI Interrupt Link [LMCI] enabled at IRQ 22
ACPI: PCI Interrupt Link [LPID] enabled at IRQ 21
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 20
ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 23
ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 19
00:01:06[A] -> 4-19 -> IRQ 19 level high
ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 18
00:01:04[A] -> 4-18 -> IRQ 18 level high
ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 17
00:01:04[B] -> 4-17 -> IRQ 17 level high
ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 16
00:01:04[D] -> 4-16 -> IRQ 16 level high
00:19:02[A] -> 5-2 -> IRQ 26 level low
00:19:02[B] -> 5-3 -> IRQ 27 level low
00:19:02[C] -> 5-0 -> IRQ 24 level low
00:19:02[D] -> 5-1 -> IRQ 25 level low
00:1a:03[A] -> 6-2 -> IRQ 30 level low
00:1a:03[B] -> 6-3 -> IRQ 31 level low
00:1a:03[C] -> 6-0 -> IRQ 28 level low
00:1a:03[D] -> 6-1 -> IRQ 29 level low
number of MP IRQ sources: 16.
number of IO-APIC #4 registers: 24.
number of IO-APIC #5 registers: 4.
number of IO-APIC #6 registers: 4.
testing the IO APIC.......................
IO APIC #4......
.... register #00: 04000000
....... : physical APIC id: 04
....... : Delivery Type: 0
....... : LTS : 0
.... register #01: 00170011
....... : max redirection entries: 0017
....... : PRQ implemented: 0
....... : IO APIC version: 0011
.... register #02: 04000000
....... : arbitration: 04
.... IRQ redirection table:
NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:
00 00F 0F 0 0 0 0 0 1 1 31
01 00F 0F 0 0 0 0 0 1 1 39
02 00F 0F 0 0 0 0 0 1 1 41
03 00F 0F 0 0 0 0 0 1 1 49
04 00F 0F 0 0 0 0 0 1 1 51
05 00F 0F 0 0 0 0 0 1 1 59
06 00F 0F 0 0 0 0 0 1 1 61
07 00F 0F 1 0 0 0 0 1 1 69
08 00F 0F 0 0 0 0 0 1 1 71
09 00F 0F 0 1 0 1 0 1 1 79
0a 00F 0F 0 0 0 0 0 1 1 81
0b 00F 0F 0 0 0 0 0 1 1 89
0c 00F 0F 0 0 0 0 0 1 1 91
0d 00F 0F 0 0 0 0 0 1 1 99
0e 00F 0F 0 0 0 0 0 1 1 A1
0f 00F 0F 0 0 0 0 0 1 1 A9
10 00F 0F 1 1 0 0 0 1 1 E9
11 00F 0F 1 1 0 0 0 1 1 E1
12 00F 0F 1 1 0 0 0 1 1 D9
13 00F 0F 1 1 0 0 0 1 1 D1
14 00F 0F 1 1 0 0 0 1 1 C9
15 00F 0F 1 1 0 0 0 1 1 C1
16 00F 0F 1 1 0 0 0 1 1 B9
17 00F 0F 1 1 0 0 0 1 1 B1
IO APIC #5......
.... register #00: 05000000
....... : physical APIC id: 05
....... : Delivery Type: 0
....... : LTS : 0
.... register #01: 00030011
....... : max redirection entries: 0003
An unexpected IO-APIC was found. If this kernel release is less than
three months old please report this to linux-smp@vger.kernel.org
....... : PRQ implemented: 0
....... : IO APIC version: 0011
.... register #02: 00000000
....... : arbitration: 00
.... IRQ redirection table:
NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:
00 00F 0F 1 1 0 1 0 1 1 42
01 00F 0F 1 1 0 1 0 1 1 4A
02 00F 0F 1 1 0 1 0 1 1 32
03 00F 0F 1 1 0 1 0 1 1 3A
IO APIC #6......
.... register #00: 06000000
....... : physical APIC id: 06
....... : Delivery Type: 0
....... : LTS : 0
.... register #01: 00030011
....... : max redirection entries: 0003
An unexpected IO-APIC was found. If this kernel release is less than
three months old please report this to linux-smp@vger.kernel.org
....... : PRQ implemented: 0
....... : IO APIC version: 0011
.... register #02: 00000000
....... : arbitration: 00
.... IRQ redirection table:
NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:
00 00F 0F 1 1 0 1 0 1 1 62
01 00F 0F 1 1 0 1 0 1 1 6A
02 00F 0F 1 1 0 1 0 1 1 52
03 00F 0F 1 1 0 1 0 1 1 5A
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ2 -> 0:2
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
IRQ16 -> 0:16
IRQ17 -> 0:17
IRQ18 -> 0:18
IRQ19 -> 0:19
IRQ20 -> 0:20
IRQ21 -> 0:21
IRQ22 -> 0:22
IRQ23 -> 0:23
IRQ24 -> 1:0
IRQ25 -> 1:1
IRQ26 -> 1:2
IRQ27 -> 1:3
IRQ28 -> 2:0
IRQ29 -> 2:1
IRQ30 -> 2:2
IRQ31 -> 2:3
.................................... done.
PCI: Using ACPI for IRQ routing
PCI: Cannot allocate resource region 4 of device 00:01.1
PCI: Cannot allocate resource region 5 of device 00:01.1
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
apm: BIOS not found.
Starting kswapd
allocated 32 pages and 32 bhs reserved for the highmem bounces
VFS: Disk quotas vdquot_6.5.1
Journalled Block Device driver loaded
udf: registering filesystem
ACPI: Power Button (FF) [PWRF]
pty: 256 Unix98 ptys configured
keyboard: Timeout - AT keyboard not present?(ed)
keyboard: Timeout - AT keyboard not present?(f4)
Serial driver version 5.05c (2001-07-08) with MANY_PORTS SHARE_IRQ
SERIAL_PCI ISAPNP enabled
ttyS00 at 0x03f8 (irq = 4) is a 16550A
ttyS01 at 0x02f8 (irq = 3) is a 16550A
[c4c5c000] /dev/epoll: driver installed.
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 28000K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00beta4-2.4
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SCSI subsystem driver Revision: 1.00
libata version 1.20 loaded.
PCI(00:07.0): version 0.8
PCI: Setting latency timer of device 00:07.0 to 64
PCI: Setting latency timer of device 00:08.0 to 64
ata1: SATA max UDMA/133 cmd 0x1440 ctl 0x1436 bmdma 0x1410 irq 20
ata2: SATA max UDMA/133 cmd 0x1438 ctl 0x1432 bmdma 0x1418 irq 20
ata1: dev 0 cfg 49:2f00 82:746b 83:7f61 84:4063 85:7469 86:3d41 87:4063
88:407f
ata1: dev 0 ATA-7, max UDMA/133, 321672960 sectors: LBA48
ata1: dev 0 configured for UDMA/133
ata2: no device found (phy stat 00000000)
ata3: SATA max UDMA/133 cmd 0x1458 ctl 0x144E bmdma 0x1420 irq 23
ata4: SATA max UDMA/133 cmd 0x1450 ctl 0x144A bmdma 0x1428 irq 23
ata3: no device found (phy stat 00000000)
ata4: no device found (phy stat 00000000)
scsi0 : sata_nv
scsi1 : sata_nv
scsi2 : sata_nv
scsi3 : sata_nv
Vendor: ATA Model: WDC WD1600YS-01S Rev: 20.0
Type: Direct-Access ANSI SCSI revision: 05
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sda: 321672960 512-byte hdwr sectors (164697 MB)
Partition check:
sda: sda1 sda2 < sda5 sda6 sda7 > sda3 sda4
Linux Kernel Card Services 3.1.22
options: [pci] [cardbus] [pm]
usb.c: registered new driver usbdevfs
usb.c: registered new driver hub
PCI: Setting latency timer of device 00:02.1 to 64
ehci_hcd 00:02.1: PCI device 10de:005b
ehci_hcd 00:02.1: irq 21, pci mem f880e000
usb.c: new USB bus registered, assigned bus number 1
PCI: cache line size of 64 is not supported by device 00:02.1
ehci_hcd 00:02.1: USB 2.0 enabled, EHCI 1.00, driver 2003-Dec-29/2.4
hub.c: USB hub found
hub.c: 10 ports detected
PCI: Setting latency timer of device 00:02.0 to 64
host/usb-ohci.c: USB OHCI at membase 0xf8810000, IRQ 22
host/usb-ohci.c: usb-00:02.0, PCI device 10de:005a
usb.c: new USB bus registered, assigned bus number 2
hub.c: USB hub found
hub.c: 10 ports detected
usb.c: registered new driver usblcd
usblcd.c: USBLCD Driver Version 1.03 (C) Adams IT Services
http://www.usblcd.de
usblcd.c: USBLCD support registered.
usb.c: registered new driver serial
usbserial.c: USB Serial Driver core v1.4
usbserial.c: USB Serial support registered for FTDI SIO
usbserial.c: USB Serial support registered for FTDI 8U232AM Compatible
usbserial.c: USB Serial support registered for FTDI FT232BM Compatible
usbserial.c: USB Serial support registered for USB-UIRT Infrared Tranceiver
usbserial.c: USB Serial support registered for Home-Electronics TIRA-1 IR
Transceiver
ftdi_sio.c: v1.3.5:USB FTDI Serial Converters Driver
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP
IP: routing cache hash table of 65536 buckets, 512Kbytes
TCP: Hash tables configured (established 262144 bind 65536)
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
ds: no socket drivers loaded!
RAMDISK: Compressed image found at block 0
Freeing initrd memory: 8809k freed
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 128k freed
Adding Swap: 2097136k swap-space (priority -1)
kjournald starting. Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,5), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting. Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,7), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting. Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,6), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting. Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,3), internal journal
hub.c: new USB device 00:02.0-7, assigned address 2
EXT3-fs: mounted filesystem with ordered data mode.
usbserial.c: FTDI 8U232AM Compatible converter detected
usbserial.c: FTDI 8U232AM Compatible converter now attached to ttyUSB0 (or
usb/tts/0 for devfs)
kjournald starting. Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,3), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Silicom Bypass Gigabit Ethernet Driver slcm5700 ver. 8.3.9.silc.2.7(28/06/06)
eth0: Silicom Bypass PEG2BP series adapter found at mem df010000, IRQ 16,
node addr 00e0ed10d90a
eth0: Broadcom BCM5714 Integrated Copper transceiver found
eth0: Scatter-gather ON, 64-bit DMA ON, Tx Checksum ON, Rx Checksum ON,
802.1Q VLAN ON, NAPI ON
eth1: Silicom Bypass PEG2BP series adapter found at mem df030000, IRQ 18,
node addr 00e0ed10d90b
eth1: Broadcom BCM5714 Integrated Copper transceiver found
eth1: Scatter-gather ON, 64-bit DMA ON, Tx Checksum ON, Rx Checksum ON,
802.1Q VLAN ON, NAPI ON
eth2: Silicom Bypass PEG2BP series adapter found at mem df110000, IRQ 19,
node addr 00e0ed10d8b8
eth2: Broadcom BCM5714 Integrated Copper transceiver found
eth2: Scatter-gather ON, 64-bit DMA ON, Tx Checksum ON, Rx Checksum ON,
802.1Q VLAN ON, NAPI ON
eth3: Silicom Bypass PEG2BP series adapter found at mem df130000, IRQ 16,
node addr 00e0ed10d8b9
eth3: Broadcom BCM5714 Integrated Copper transceiver found
eth3: Scatter-gather ON, 64-bit DMA ON, Tx Checksum ON, Rx Checksum ON,
802.1Q VLAN ON, NAPI ON
tg3.c:v3.43f (Jan 9, 2006)
eth4: Tigon3 [partno(BCM95704A7) rev 2100 PHY(5704)] (PCIX:100MHz:64-bit)
10/100/1000BaseT Ethernet 00:e0:81:47:97:a2
eth4: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1]
TSOcap[0]
eth4: dma_rwctrl[769f4000]
eth5: Tigon3 [partno(BCM95704A7) rev 2100 PHY(5704)] (PCIX:100MHz:64-bit)
10/100/1000BaseT Ethernet 00:e0:81:47:97:a3
eth5: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1]
TSOcap[0]
eth5: dma_rwctrl[769f4000]
Intel(R) PRO/1000 Network Driver - version 7.2.9
Copyright (c) 1999-2006 Intel Corporation.
Intel(R) PRO/1000 Network Driver - version 7.2.9
Copyright (c) 1999-2006 Intel Corporation.
BCM5820 driver v1.82:
BCM5820: <1>Device startup failed
Rainbow Technologies CryptoSwift Linux Driver v3.0.0
Cavium Driver --- 0.99-k
N1 Device found at Bus 25 Slot 2
bar 0: 3400
bar 2: 3000
Local Mem size 20000000
Number of banks 1
DDR size : 0x20000000
mem base: 4194304 max 532676608
Finished Initializing this device
MAX 1 N1 Devices supported
Ignoring other N1 devices
Total Number of N1/N1-Lite Devices: 1
Completion Addr f56a8000
Completion Bus Addr 356a8000
Starting poll_thread
Registeration is a success The major device number is 125
if you want to talk to the device driver,
I suggest you use:
mknod pkp_drv c 125 0
Loaded Cavium Driver --- 0.99-k
got boot microcode
Code type = 02, code size = 95c, data size = d8
got mainline microcode
Code type = 01, code size = 5f70, data size = e0
UEN = 0xffff
Final Core Mask = 0x0000ffff
Loaded Boot microcode
Loaded Main microcode
Loading of Microcodes successful
device count = 1
eth0: Using PCI INTX interrupt
remove_proc_entry: bypass/bypass_eth0 busy, count=1
slcm5700: eth0 NIC Link is DOWN
eth2: Using PCI INTX interrupt
remove_proc_entry: bypass/bypass_eth2 busy, count=2
slcm5700: eth2 NIC Link is DOWN
eth0: Using PCI INTX interrupt
eth1: Using PCI INTX interrupt
eth2: Using PCI INTX interrupt
eth3: Using PCI INTX interrupt
tg3: eth4: Link is up at 100 Mbps, full duplex.
tg3: eth4: Flow control is on for TX and on for RX.
slcm5700: eth0 NIC Link is DOWN
slcm5700: eth1 NIC Link is DOWN
slcm5700: eth2 NIC Link is DOWN
slcm5700: eth3 NIC Link is DOWN
device eth0 entered promiscuous mode


#
# Automatically generated by make menuconfig: don't edit
#
CONFIG_X86=y
# CONFIG_SBUS is not set
CONFIG_UID16=y

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y

#
# Loadable module support
#
CONFIG_MODULES=y
CONFIG_MODVERSIONS=y
CONFIG_KMOD=y

#
# Processor type and features
#
# CONFIG_LOLAT is not set
# CONFIG_LOLAT_SYSCTL is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
CONFIG_MPENTIUMIII=y
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MELAN is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_XADD=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_HAS_TSC=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_PGE=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_F00F_WORKS_OK=y
# CONFIG_X86_MCE is not set
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_EDD is not set
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_HIGHIO=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_SMP=y
# CONFIG_PREEMPT is not set
CONFIG_NR_CPUS=32
# CONFIG_X86_NUMA is not set
# CONFIG_X86_TSC_DISABLE is not set
CONFIG_X86_TSC=y
CONFIG_HAVE_DEC_LOCK=y

#
# General setup
#
CONFIG_HZ=500
CONFIG_NET=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_ISA=y
# CONFIG_PCI_NAMES is not set
CONFIG_EISA=y
# CONFIG_MCA is not set
CONFIG_HOTPLUG=y

#
# PCMCIA/CardBus support
#
CONFIG_PCMCIA=y
CONFIG_CARDBUS=y
# CONFIG_TCIC is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set

#
# PCI Hotplug Support
#
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_HOTPLUG_PCI_SHPC_POLL_EVENT_MODE is not set
# CONFIG_HOTPLUG_PCI_PCIE is not set
# CONFIG_HOTPLUG_PCI_PCIE_POLL_EVENT_MODE is not set
CONFIG_SYSVIPC=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_SYSCTL=y
CONFIG_KCORE_ELF=y
# CONFIG_KCORE_AOUT is not set
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_MISC is not set
# CONFIG_OOM_KILLER is not set
CONFIG_PM=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_RTC_IS_GMT is not set
# CONFIG_APM_ALLOW_INTS is not set
# CONFIG_APM_REAL_MODE_POWER_OFF is not set

#
# ACPI Support
#
CONFIG_ACPI=y
CONFIG_ACPI_BOOT=y
CONFIG_ACPI_BUS=y
CONFIG_ACPI_INTERPRETER=y
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_PCI=y
CONFIG_ACPI_MMCONFIG=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_SYSTEM=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_THERMAL is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_DEBUG is not set

#
# Memory Technology Devices (MTD)
#
# CONFIG_MTD is not set

#
# Parallel port support
#
# CONFIG_PARPORT is not set

#
# Plug and Play configuration
#
CONFIG_PNP=y
CONFIG_ISAPNP=y

#
# Block devices
#
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_DEV_XD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_CISS_SCSI_TAPE is not set
# CONFIG_CISS_MONITOR_THREAD is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_SIZE=8192
CONFIG_BLK_DEV_INITRD=y
CONFIG_BLK_STATS=y

#
# Multi-device support (RAID and LVM)
#
# CONFIG_MD is not set
# CONFIG_BLK_DEV_MD is not set
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID5 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_BLK_DEV_LVM is not set

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_NETLINK_DEV=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_FILTER=y
CONFIG_UNIX=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
CONFIG_INET_ECN=y
CONFIG_SYN_COOKIES=y
CONFIG_RW_TPROXY=y
CONFIG_RW_SYN_DIVERT=y

#
#   IP: Netfilter Configuration
#
CONFIG_IP_NF_CONNTRACK=m
# CONFIG_IP_NF_FTP is not set
# CONFIG_IP_NF_CONNTRACK_MARK is not set
# CONFIG_IP_NF_AMANDA is not set
# CONFIG_IP_NF_TFTP is not set
# CONFIG_IP_NF_IRC is not set
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_LIMIT=m
# CONFIG_IP_NF_SET is not set
# CONFIG_IP_NF_SET is not set
# CONFIG_IP_NF_MATCH_QUOTA is not set
# CONFIG_IP_NF_MATCH_IPRANGE is not set
CONFIG_IP_NF_MATCH_MAC=m
# CONFIG_IP_NF_MATCH_PKTTYPE is not set
CONFIG_IP_NF_MATCH_MARK=m
CONFIG_IP_NF_MATCH_MULTIPORT=m
CONFIG_IP_NF_MATCH_TOS=m
# CONFIG_IP_NF_MATCH_TIME is not set
# CONFIG_IP_NF_MATCH_RANDOM is not set
# CONFIG_IP_NF_MATCH_PSD is not set
# CONFIG_IP_NF_MATCH_OSF is not set
# CONFIG_IP_NF_MATCH_NTH is not set
# CONFIG_IP_NF_MATCH_IPV4OPTIONS is not set
# CONFIG_IP_NF_MATCH_FUZZY is not set
# CONFIG_IP_NF_MATCH_RECENT is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_DSCP is not set
# CONFIG_IP_NF_MATCH_AH_ESP is not set
CONFIG_IP_NF_MATCH_LENGTH=m
# CONFIG_IP_NF_MATCH_U32 is not set
CONFIG_IP_NF_MATCH_TTL=m
# CONFIG_IP_NF_MATCH_ADDRTYPE is not set
CONFIG_IP_NF_MATCH_TCPMSS=m
# CONFIG_IP_NF_MATCH_REALM is not set
# CONFIG_IP_NF_MATCH_COMMENT is not set
# CONFIG_IP_NF_MATCH_HELPER is not set
CONFIG_IP_NF_MATCH_STATE=m
# CONFIG_IP_NF_MATCH_CONNLIMIT is not set
# CONFIG_IP_NF_MATCH_CONNTRACK is not set
# CONFIG_IP_NF_MATCH_UNCLEAN is not set
# CONFIG_IP_NF_MATCH_OWNER is not set
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
# CONFIG_IP_NF_TARGET_NETLINK is not set
# CONFIG_IP_NF_TARGET_IPV4OPTSSTRIP is not set
CONFIG_IP_NF_TARGET_MIRROR=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_NAT_NEEDED=y
# CONFIG_IP_NF_NAT_NRES is not set
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_REDIRECT=m
# CONFIG_IP_NF_TARGET_NETMAP is not set
# CONFIG_IP_NF_TARGET_SAME is not set
# CONFIG_IP_NF_NAT_SNMP_BASIC is not set
CONFIG_IP_NF_TPROXY=m
CONFIG_IP_NF_TARGET_TPROXY=m
CONFIG_IP_NF_MATCH_TPROXY=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_TOS=m
# CONFIG_IP_NF_TARGET_ECN is not set
# CONFIG_IP_NF_TARGET_DSCP is not set
CONFIG_IP_NF_TARGET_MARK=m
CONFIG_IP_NF_TARGET_ROUTE=m
# CONFIG_IP_NF_TARGET_CLASSIFY is not set
CONFIG_IP_NF_TARGET_LOG=m
# CONFIG_IP_NF_TARGET_TTL is not set
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_TARGET_TCPMSS=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_TARGET_NOTRACK=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
# CONFIG_IP_NF_ARP_MANGLE is not set
CONFIG_IP_NF_COMPAT_IPCHAINS=m
CONFIG_IP_NF_NAT_NEEDED=y
# CONFIG_IP_NF_COMPAT_IPFWADM is not set

#
#   IP: Virtual Server Configuration
#
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_KHTTPD is not set

#
#    SCTP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_SCTP is not set
# CONFIG_ATM is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_DECNET is not set
CONFIG_BRIDGE=m
CONFIG_BRIDGE_NF=y
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_LLC is not set
# CONFIG_NET_DIVERT is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_FASTROUTE is not set
# CONFIG_NET_HW_FLOWCONTROL is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set

#
# Telephony Support
#
# CONFIG_PHONE is not set
# CONFIG_PHONE_IXJ is not set
# CONFIG_PHONE_IXJ_PCMCIA is not set

#
# ATA/IDE/MFM/RLL support
#
CONFIG_IDE=y

#
# IDE, ATA and ATAPI Block devices
#
CONFIG_BLK_DEV_IDE=y
# CONFIG_BLK_DEV_HD_IDE is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_IDEDISK_MULTI_MODE=y
# CONFIG_IDEDISK_STROKE is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_ISAPNP is not set
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_IDEPCI_SHARE_IRQ is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
CONFIG_IDEDMA_PCI_AUTO=y
# CONFIG_IDEDMA_ONLYDISK is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_IDEDMA_PCI_WIP is not set
# CONFIG_BLK_DEV_ADMA100 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_WDC_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_AMD74XX_OVERRIDE is not set
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=y
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_HPT34X_AUTODMA is not set
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_PDC202XX_BURST is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_SVWKS=y
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_IDE_CHIPSETS is not set
CONFIG_IDEDMA_AUTO=y
# CONFIG_IDEDMA_IVB is not set
# CONFIG_DMA_NONPCI is not set
# CONFIG_BLK_DEV_ATARAID is not set
# CONFIG_BLK_DEV_ATARAID_PDC is not set
# CONFIG_BLK_DEV_ATARAID_HPT is not set
# CONFIG_BLK_DEV_ATARAID_MEDLEY is not set
# CONFIG_BLK_DEV_ATARAID_SII is not set

#
# SCSI support
#
CONFIG_SCSI=y
CONFIG_BLK_DEV_SD=y
CONFIG_SD_EXTRA_DEVS=40
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_SR_EXTRA_DEVS=2
CONFIG_CHR_DEV_SG=y
CONFIG_SCSI_DEBUG_QUEUES=y
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y

#
# SCSI low-level drivers
#
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AHA1740 is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_MEGARAID is not set
# CONFIG_SCSI_MEGARAID2 is not set
CONFIG_SCSI_SATA=y
# CONFIG_SCSI_SATA_AHCI is not set
# CONFIG_SCSI_SATA_SVW is not set
# CONFIG_SCSI_ATA_PIIX is not set
CONFIG_SCSI_SATA_NV=y
# CONFIG_SCSI_SATA_QSTOR is not set
# CONFIG_SCSI_SATA_PROMISE is not set
# CONFIG_SCSI_SATA_SX4 is not set
# CONFIG_SCSI_SATA_SIL is not set
# CONFIG_SCSI_SATA_SIS is not set
# CONFIG_SCSI_SATA_ULI is not set
# CONFIG_SCSI_SATA_VIA is not set
# CONFIG_SCSI_SATA_VITESSE is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_CPQFCTS is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_EATA_DMA is not set
# CONFIG_SCSI_EATA_PIO is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_NCR53C7xx is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_NCR53C8XX is not set
# CONFIG_SCSI_SYM53C8XX is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_PCI2000 is not set
# CONFIG_SCSI_PCI2220I is not set
# CONFIG_SCSI_PSI240I is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_ISP is not set
# CONFIG_SCSI_QLOGIC_FC is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_SEAGATE is not set
# CONFIG_SCSI_SIM710 is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set

#
# PCMCIA SCSI adapter support
#
# CONFIG_SCSI_PCMCIA is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_BOOT is not set
# CONFIG_FUSION_ISENSE is not set
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LAN is not set

#
# IEEE 1394 (FireWire) support (EXPERIMENTAL)
#
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set
# CONFIG_I2O_PCI is not set
# CONFIG_I2O_BLOCK is not set
# CONFIG_I2O_LAN is not set
# CONFIG_I2O_SCSI is not set
# CONFIG_I2O_PROC is not set

#
# Network device support
#
CONFIG_NETDEVICES=y

#
# ARCnet devices
#
# CONFIG_ARCNET is not set
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_ETHERTAP is not set
# CONFIG_NET_SB1000 is not set

#
# Ethernet (10 or 100Mbit)
#
CONFIG_NET_ETHERNET=y
# CONFIG_SUNLANCE is not set
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNBMAC is not set
# CONFIG_SUNQE is not set
# CONFIG_SUNGEM is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_CS89x0 is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_DGRS is not set
# CONFIG_DM9102 is not set
CONFIG_EEPRO100=m
# CONFIG_EEPRO100_PIO is not set
CONFIG_E100=m
# CONFIG_LNE390 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_FORCEDETH is not set
# CONFIG_NE3210 is not set
# CONFIG_ES3210 is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_SUNDANCE_MMIO is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_RHINE_MMIO is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_NET_POCKET is not set

#
# Ethernet (1000 Mbit)
#
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=m
# CONFIG_E1000_NAPI is not set
# CONFIG_MYRI_SBUS is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SK98LIN is not set
# CONFIG_TIGON3 is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# Wireless LAN (non-hamradio)
#
# CONFIG_NET_RADIO is not set

#
# Token Ring devices
#
# CONFIG_TR is not set
# CONFIG_NET_FC is not set
# CONFIG_RCPCI is not set
# CONFIG_SHAPER is not set

#
# Wan interfaces
#
# CONFIG_WAN is not set

#
# PCMCIA network device support
#
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_PCMCIA_PCNET=y
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_ARCNET_COM20020_CS is not set
# CONFIG_PCMCIA_IBMTR is not set
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_PCMCIA_XIRTULIP is not set
CONFIG_NET_PCMCIA_RADIO=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_PCMCIA_NETWAVE is not set
# CONFIG_PCMCIA_WAVELAN is not set
# CONFIG_AIRONET4500_CS is not set

#
# Amateur Radio support
#
# CONFIG_HAMRADIO is not set

#
# IrDA (infrared) support
#
# CONFIG_IRDA is not set

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

#
# Old CD-ROM drivers (not SCSI, not IDE)
#
# CONFIG_CD_NO_IDESCSI is not set

#
# Input core support
#
# CONFIG_INPUT is not set
# CONFIG_INPUT_KEYBDEV is not set
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_DUMMY_KEYB is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_SERIAL=y
CONFIG_SERIAL_CONSOLE=y
# CONFIG_SERIAL_EXTENDED is not set
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_UNIX98_PTYS=y
CONFIG_UNIX98_PTY_COUNT=256

#
# I2C support
#
# CONFIG_I2C is not set

#
# Mice
#
# CONFIG_BUSMOUSE is not set
# CONFIG_MOUSE is not set

#
# Joysticks
#
# CONFIG_INPUT_GAMEPORT is not set
# CONFIG_QIC02_TAPE is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
# CONFIG_IPMI_KCS is not set
# CONFIG_IPMI_WATCHDOG is not set

#
# Watchdog Cards
#
# CONFIG_WATCHDOG is not set
# CONFIG_SCx200 is not set
# CONFIG_SCx200_GPIO is not set
# CONFIG_AMD_RNG is not set
# CONFIG_INTEL_RNG is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_AMD_PM768 is not set
# CONFIG_NVRAM is not set
CONFIG_EVENTPOLL=y
# CONFIG_RTC is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# Ftape, the floppy tape device driver
#
# CONFIG_FTAPE is not set
# CONFIG_AGP is not set

#
# Direct Rendering Manager (XFree86 DRI support)
#
# CONFIG_DRM is not set

#
# PCMCIA character devices
#
# CONFIG_PCMCIA_SERIAL_CS is not set
# CONFIG_SYNCLINK_CS is not set
# CONFIG_MWAVE is not set
# CONFIG_OBMOUSE is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set

#
# File systems
#
CONFIG_QUOTA=y
# CONFIG_QFMT_V2 is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_ADFS_FS is not set
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BEFS_DEBUG is not set
# CONFIG_BFS_FS is not set
CONFIG_EXT3_FS=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=m
CONFIG_UMSDOS_FS=m
CONFIG_VFAT_FS=y
# CONFIG_EFS_FS is not set
# CONFIG_JFFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_CRAMFS is not set
CONFIG_TMPFS=y
CONFIG_RAMFS=y
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
# CONFIG_JFS_FS is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_NTFS_FS is not set
# CONFIG_NTFS_RW is not set
# CONFIG_HPFS_FS is not set
CONFIG_PROC_FS=y
# CONFIG_DEVFS_FS is not set
# CONFIG_DEVFS_MOUNT is not set
# CONFIG_DEVFS_DEBUG is not set
CONFIG_DEVPTS_FS=y
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX4FS_RW is not set
CONFIG_ROMFS_FS=m
CONFIG_EXT2_FS=y
# CONFIG_SYSV_FS is not set
CONFIG_UDF_FS=y
# CONFIG_UDF_RW is not set
# CONFIG_UFS_FS is not set
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_XFS_FS is not set
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_RT is not set
# CONFIG_XFS_TRACE is not set
# CONFIG_XFS_DEBUG is not set

#
# Network File Systems
#
# CONFIG_CODA_FS is not set
# CONFIG_INTERMEZZO_FS is not set
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
# CONFIG_NFS_DIRECTIO is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFSD is not set
# CONFIG_NFSD_V3 is not set
# CONFIG_NFSD_TCP is not set
CONFIG_SUNRPC=m
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
# CONFIG_SMB_UNIX is not set
CONFIG_NCP_FS=m
# CONFIG_NCPFS_PACKET_SIGNING is not set
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
# CONFIG_NCPFS_NFS_NS is not set
# CONFIG_NCPFS_OS2_NS is not set
# CONFIG_NCPFS_SMALLDOS is not set
CONFIG_NCPFS_NLS=m
# CONFIG_NCPFS_EXTRAS is not set
# CONFIG_ZISOFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_SMB_NLS=y
CONFIG_NLS=y


#
# Native Language Support
#
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m


# CONFIG_NLS is not set

#
# Console drivers
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VIDEO_SELECT is not set
# CONFIG_MDA_CONSOLE is not set

#
# Frame-buffer support
#
# CONFIG_FB is not set

#
# Sound
#
# CONFIG_SOUND is not set

#
# USB support
#
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_DEVICEFS=y
CONFIG_USB_BANDWIDTH=y
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_UHCI is not set
# CONFIG_USB_UHCI_ALT is not set
CONFIG_USB_OHCI=y
# CONFIG_USB_SL811HS_ALT is not set
# CONFIG_USB_SL811HS is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_BLUETOOTH is not set
# CONFIG_USB_MIDI is not set
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_HP8200e is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_HID is not set
# CONFIG_USB_HIDINPUT is not set
# CONFIG_USB_HIDDEV is not set
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
# CONFIG_USB_AIPTEK is not set
# CONFIG_USB_WACOM is not set
# CONFIG_USB_KBTAB is not set
# CONFIG_USB_POWERMATE is not set
# CONFIG_USB_DC2XX is not set
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_SCANNER is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_HPUSBSCSI is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_CATC is not set
# CONFIG_USB_CDCETHER is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_USS720 is not set

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_DEBUG is not set
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_TIGL is not set
# CONFIG_USB_BRLVGER is not set
CONFIG_USB_LCD=y

#
# Support for USB gadgets
#
# CONFIG_USB_GADGET is not set

#
# Bluetooth support
#
# CONFIG_BLUEZ is not set

#
# Kernel hacking
#
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_HIGHMEM is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_IOVIRT is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_FRAME_POINTER is not set
CONFIG_LOG_BUF_SHIFT=0

#
# Cryptographic options
#
# CONFIG_CRYPTO is not set

#
# Library routines
#
CONFIG_CRC32=y
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
# CONFIG_FW_LOADER is not set
