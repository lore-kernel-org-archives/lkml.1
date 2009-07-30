Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZG3VYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZG3VYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZG3VYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:24:06 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:43034 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbZG3VYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:24:02 -0400
Date: Thu, 30 Jul 2009 23:51:04 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Thinkpad X20 docking troubles - irq routing, USB strangeness
Message-ID: <Pine.SOC.4.64.0907302339550.23777@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to use Thinkpad X20 with Thinkpad Dock 
(as described in http://www.thinkwiki.org/wiki/ThinkPad_Dock quite 
well).

Docking and undocking basically works but there are different troubles.

The first is irq-related. As soon as yenta driver discovers the 
additional ports, screaming irq happens and this shared irq is disabled.
This documented in the dmesg below. This is my main problem, others may 
be secondary to it (at least the usb one).

Another problem is that PCI devices do not go away after undock - they 
stay around in kernel's thinking.

The third is related to USb and is quite mysterious to me. First it's 
simple - when docked, kernel spams dmesg with
hub 1-1:1.0: unable to enumerate USB device on port 1
and dock USB ports do not work. lsusb displays this:


Bus 001 Device 002: ID 0451:2036 Texas Instruments, Inc. TUSB2036 Hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0         8
  idVendor           0x0451 Texas Instruments, Inc.
  idProduct          0x2036 TUSB2036 Hub
  bcdDevice            1.01
  iManufacturer           0 
  iProduct                1 General Purpose USB Hub
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          1 General Purpose USB Hub
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              1 General Purpose USB Hub
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x0009
    Per-port power switching
    Per-port overcurrent protection
  bPwrOn2PwrGood       50 * 2 milli seconds
  bHubContrCurrent    100 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0x06
 Hub Port Status:
   Port 1: 0001.0101 C_CONNECT power connect
   Port 2: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.31-rc4-00350-g658874f uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:07.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

However, after undock and dock, 4-port Atmel USB hub is discovered and 
it works, and no spamming happens any more.


Bus 001 Device 038: ID 03eb:3312 Atmel Corp. 4-Port Hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0         8
  idVendor           0x03eb Atmel Corp.
  idProduct          0x3312 4-Port Hub
  bcdDevice            3.00
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower               64mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             4
  wHubCharacteristic 0x0009
    Per-port power switching
    Per-port overcurrent protection
  bPwrOn2PwrGood       50 * 2 milli seconds
  bHubContrCurrent     64 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0x1e
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 001 Device 037: ID 0451:2036 Texas Instruments, Inc. TUSB2036 Hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0         8
  idVendor           0x0451 Texas Instruments, Inc.
  idProduct          0x2036 TUSB2036 Hub
  bcdDevice            1.01
  iManufacturer           0 
  iProduct                1 General Purpose USB Hub
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          1 General Purpose USB Hub
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              1 General Purpose USB Hub
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x0009
    Per-port power switching
    Per-port overcurrent protection
  bPwrOn2PwrGood       50 * 2 milli seconds
  bHubContrCurrent    100 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0x06
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.31-rc4-00350-g658874f uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:07.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

/proc/interrupts:
           CPU0       
  0:     184539    XT-PIC-XT        timer
  1:       8322    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  3:          5    XT-PIC-XT      
  4:          7    XT-PIC-XT      
  5:          6    XT-PIC-XT      
  7:          1    XT-PIC-XT        parport0
  8:          2    XT-PIC-XT        rtc0
  9:      25796    XT-PIC-XT        acpi, yenta, yenta, eth0
 10:          6    XT-PIC-XT      
 11:     202345    XT-PIC-XT        ohci1394, uhci_hcd:usb1, pata_cmd64x, yenta, yenta, CS4281
 12:      14174    XT-PIC-XT        i8042
 14:      15444    XT-PIC-XT        ata_piix
 15:          0    XT-PIC-XT        ata_piix
NMI:          0   Non-maskable interrupts
ERR:          0



Linux version 2.6.31-rc4-00350-g658874f (mroos@tulp) (gcc version 4.3.3 (Debian 4.3.3-15) ) #1 Thu Jul 30 18:47:07 EEST 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dd000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000013ff0000 (usable)
 BIOS-e820: 0000000013ff0000 - 0000000013ffec00 (ACPI data)
 BIOS-e820: 0000000013ffec00 - 0000000014000000 (ACPI NVS)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
DMI 2.3 present.
last_pfn = 0x13ff0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DFFFF uncachable
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask FF0000000 write-back
  1 base 010000000 mask FFC000000 write-back
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
initial memory mapped : 0 - 01800000
init_memory_mapping: 0000000000000000-0000000013ff0000
 0000000000 - 0000400000 page 4k
 0000400000 - 0013c00000 page 2M
 0013c00000 - 0013ff0000 page 4k
kernel direct mapping tables up to 13ff0000 @ 7000-c000
RAMDISK: 13bdc000 - 13fdff44
ACPI: RSDP 000f6ec0 00014 (v00 PTLTD )
ACPI: RSDT 13ff5c49 0002C (v01 PTLTD    RSDT   06040000  LTP 00000000)
ACPI: FACP 13ffeb65 00074 (v01 IBM    TP-X21   06040000      00000000)
ACPI: DSDT 13ff5c75 08EF0 (v01 IBM    TP-X21   06040000 MSFT 0100000C)
ACPI: FACS 13fff000 00040
ACPI: BOOT 13ffebd9 00027 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
319MB LOWMEM available.
  mapped low ram: 0 - 13ff0000
  low ram: 0 - 13ff0000
  node 0 low ram: 00000000 - 13ff0000
  node 0 bootmap 00001000 - 00003800
(7 early reservations) ==> bootmem [0000000000 - 0013ff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0001000000 - 00013beee8]    TEXT DATA BSS ==> [0001000000 - 00013beee8]
  #2 [0013bdc000 - 0013fdff44]          RAMDISK ==> [0013bdc000 - 0013fdff44]
  #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #4 [00013bf000 - 00013c50d9]              BRK ==> [00013bf000 - 00013c50d9]
  #5 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
  #6 [0000001000 - 0000004000]          BOOTMAP ==> [0000001000 - 0000004000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00013ff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x00013ff0
On node 0 totalpages: 81807
free_area_init_node: node 0, pgdat c132b8e0, node_mem_map c13c6000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 608 pages used for memmap
  Normal zone: 77200 pages, LIFO batch:15
ACPI: PM-Timer IO Port: 0x1008
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dd000
PM: Registered nosave memory: 00000000000dd000 - 0000000000100000
Allocating PCI resources starting at 14000000 (gap: 14000000:ebf80000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 81167
Kernel command line: root=/dev/sda1 ro resume=/dev/sda2 
PID hash table entries: 2048 (order: 11, 8192 bytes)
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Memory: 316004k/327616k available (2427k kernel code, 10956k reserved, 858k data, 288k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffe5000 - 0xfffff000   ( 104 kB)
    vmalloc : 0xd47f0000 - 0xfffe3000   ( 695 MB)
    lowmem  : 0xc0000000 - 0xd3ff0000   ( 319 MB)
      .init : 0xc1337000 - 0xc137f000   ( 288 kB)
      .data : 0xc125ed4e - 0xc1335588   ( 858 kB)
      .text : 0xc1000000 - 0xc125ed4e   (2427 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
NR_IRQS:16
CPU 0 irqstacks, hard=c132e000 soft=c132f000
Fast TSC calibration using PIT
Detected 597.365 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Calibrating delay loop (skipped), value calculated using timer frequency.. 1194.73 BogoMIPS (lpj=5973650)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: Intel Pentium III (Coppermine) stepping 03
Checking 'hlt' instruction... OK.
ACPI: Core revision 20090521
ACPI: setting ELCR to 0200 (from 0e20)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd94f, last bus=14
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE = 0x9, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: Power Resource [PSIO] (on)
ACPI: Power Resource [PSER] (off)
ACPI: ACPI Dock Station Driver: 2 docks/bays found
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio: [0xf8000000-0xfbffffff]
pci 0000:00:04.0: supports D1 D2
pci 0000:00:07.1: reg 20 io port: [0x1800-0x180f]
pci 0000:00:07.2: reg 20 io port: [0x1820-0x183f]
pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB
pci 0000:00:07.3: PIIX4 devres I PIO at 03f0-03f7
pci 0000:00:07.3: PIIX4 devres J PIO at 002e-002f
pci 0000:00:08.0: reg 10 32bit mmio: [0x50000000-0x50000fff]
pci 0000:00:08.0: supports D1 D2
pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:08.0: PME# disabled
pci 0000:00:08.1: reg 10 32bit mmio: [0x50100000-0x50100fff]
pci 0000:00:08.1: supports D1 D2
pci 0000:00:08.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:08.1: PME# disabled
pci 0000:00:0a.0: reg 10 32bit mmio: [0xf4010000-0xf4010fff]
pci 0000:00:0a.0: reg 14 io port: [0x1840-0x187f]
pci 0000:00:0a.0: reg 18 32bit mmio: [0xf4020000-0xf403ffff]
pci 0000:00:0a.0: reg 30 32bit mmio: [0x000000-0x0fffff]
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0a.1: reg 10 io port: [0x1810-0x1817]
pci 0000:00:0a.1: reg 14 32bit mmio: [0xf4011000-0xf4011fff]
pci 0000:00:0a.1: supports D1 D2
pci 0000:00:0a.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.1: PME# disabled
pci 0000:00:0b.0: reg 10 32bit mmio: [0xf4012000-0xf4012fff]
pci 0000:00:0b.0: reg 14 32bit mmio: [0xf4000000-0xf400ffff]
pci 0000:00:0b.0: supports D1 D2
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot
pci 0000:00:0b.0: PME# disabled
pci 0000:01:00.0: reg 10 32bit mmio: [0xf5000000-0xf5ffffff]
pci 0000:01:00.0: reg 14 io port: [0x2000-0x20ff]
pci 0000:01:00.0: reg 18 32bit mmio: [0xf4100000-0xf4100fff]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:00:01.0: bridge io port: [0x2000-0x2fff]
pci 0000:00:01.0: bridge 32bit mmio: [0xf4100000-0xf5ffffff]
pci 0000:02:00.0: reg 10 32bit mmio: [0xf6000000-0xf60007ff]
pci 0000:02:00.0: reg 14 io port: [0x3000-0x307f]
pci 0000:02:00.0: supports D2
pci 0000:02:00.0: PME# supported from D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:01.0: reg 10 io port: [0x30a0-0x30a7]
pci 0000:02:01.0: reg 14 io port: [0x3094-0x3097]
pci 0000:02:01.0: reg 18 io port: [0x3098-0x309f]
pci 0000:02:01.0: reg 1c io port: [0x3090-0x3093]
pci 0000:02:01.0: reg 20 io port: [0x3080-0x308f]
pci 0000:02:01.0: supports D1 D2
pci 0000:02:02.0: reg 10 32bit mmio: [0x52000000-0x52000fff]
pci 0000:02:02.0: supports D1 D2
pci 0000:02:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:02.0: PME# disabled
pci 0000:02:02.1: reg 10 32bit mmio: [0x53000000-0x53000fff]
pci 0000:02:02.1: supports D1 D2
pci 0000:02:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:02.1: PME# disabled
pci 0000:00:04.0: transparent bridge
pci 0000:00:04.0: bridge io port: [0x00-0xfff]
pci 0000:00:04.0: bridge 32bit mmio: [0x000000-0x0fffff]
pci 0000:00:04.0: bridge 32bit mmio pref: [0x000000-0x0fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.DOCK._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 9 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 9 11) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs *9 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 9 11) *5
PCI: Using ACPI for IRQ routing
pci 0000:00:04.0: BAR 7: can't allocate resource
pci 0000:00:04.0: BAR 8: can't allocate resource
pci 0000:00:04.0: BAR 9: can't allocate resource
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: mem resource (0x0-0x9ffff) overlaps 0000:00:0a.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:00: mem resource (0xc0000-0xc3fff) overlaps 0000:00:0a.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:00: mem resource (0xc4000-0xc7fff) overlaps 0000:00:0a.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:00: mem resource (0xc8000-0xcbfff) overlaps 0000:00:0a.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:00: mem resource (0xcc000-0xcffff) overlaps 0000:00:0a.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:00: mem resource (0xd0000-0xcffff) overlaps 0000:00:0a.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:00: mem resource (0xd4000-0xd3fff) overlaps 0000:00:0a.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:00: mem resource (0xd8000-0xdbfff) overlaps 0000:00:0a.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:00: mem resource (0xdc000-0xdffff) overlaps 0000:00:0a.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:00: mem resource (0xe0000-0xe3fff) overlaps 0000:00:0a.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:00: mem resource (0xe4000-0xe7fff) overlaps 0000:00:0a.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:00: mem resource (0xe8000-0xebfff) overlaps 0000:00:0a.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:00: mem resource (0xec000-0xeffff) overlaps 0000:00:0a.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:00: mem resource (0xf0000-0xfffff) overlaps 0000:00:0a.0 BAR 6 (0x0-0xfffff), disabling
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0x100000-0x13ffffff could not be reserved
system 00:00: iomem range 0xfff80000-0xffffffff has been reserved
system 00:02: ioport range 0x1000-0x103f has been reserved
system 00:02: ioport range 0x1040-0x104f has been reserved
system 00:02: ioport range 0xfe00-0xfe0f has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x2000-0x2fff
pci 0000:00:01.0:   MEM window: 0xf4100000-0xf5ffffff
pci 0000:00:01.0:   PREFETCH window: 0x34000000-0x340fffff
pci 0000:02:02.0: CardBus bridge, secondary bus 0000:03
pci 0000:02:02.0:   IO window: 0x004000-0x0040ff
pci 0000:02:02.0:   IO window: 0x004400-0x0044ff
pci 0000:02:02.0:   PREFETCH window: 0x1c000000-0x1fffffff
pci 0000:02:02.0:   MEM window: 0x14000000-0x17ffffff
pci 0000:02:02.1: CardBus bridge, secondary bus 0000:07
pci 0000:02:02.1:   IO window: 0x004800-0x0048ff
pci 0000:02:02.1:   IO window: 0x004c00-0x004cff
pci 0000:02:02.1:   PREFETCH window: 0x20000000-0x23ffffff
pci 0000:02:02.1:   MEM window: 0x18000000-0x1bffffff
pci 0000:00:04.0: PCI bridge, secondary bus 0000:02
pci 0000:00:04.0:   IO window: 0x4000-0x4fff
pci 0000:00:04.0:   MEM window: 0x14000000-0x1bffffff
pci 0000:00:04.0:   PREFETCH window: 0x1c000000-0x23ffffff
pci 0000:00:08.0: CardBus bridge, secondary bus 0000:09
pci 0000:00:08.0:   IO window: 0x001400-0x0014ff
pci 0000:00:08.0:   IO window: 0x001c00-0x001cff
pci 0000:00:08.0:   PREFETCH window: 0x24000000-0x27ffffff
pci 0000:00:08.0:   MEM window: 0x28000000-0x2bffffff
pci 0000:00:08.1: CardBus bridge, secondary bus 0000:0d
pci 0000:00:08.1:   IO window: 0x003400-0x0034ff
pci 0000:00:08.1:   IO window: 0x003800-0x0038ff
pci 0000:00:08.1:   PREFETCH window: 0x2c000000-0x2fffffff
pci 0000:00:08.1:   MEM window: 0x30000000-0x33ffffff
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
pci 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 9 (level, low) -> IRQ 9
pci 0000:02:02.1: PCI INT A -> Link[LNKC] -> GSI 9 (level, low) -> IRQ 9
pci 0000:00:08.0: power state changed by ACPI to D0
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
pci 0000:00:08.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
pci 0000:00:08.1: power state changed by ACPI to D0
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
pci 0000:00:08.1: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:01: resource 1 mem: [0xf4100000-0xf5ffffff]
pci_bus 0000:01: resource 2 pref mem [0x34000000-0x340fffff]
pci_bus 0000:02: resource 0 io:  [0x4000-0x4fff]
pci_bus 0000:02: resource 1 mem: [0x14000000-0x1bffffff]
pci_bus 0000:02: resource 2 pref mem [0x1c000000-0x23ffffff]
pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
pci_bus 0000:03: resource 0 io:  [0x4000-0x40ff]
pci_bus 0000:03: resource 1 io:  [0x4400-0x44ff]
pci_bus 0000:03: resource 2 pref mem [0x1c000000-0x1fffffff]
pci_bus 0000:03: resource 3 mem: [0x14000000-0x17ffffff]
pci_bus 0000:07: resource 0 io:  [0x4800-0x48ff]
pci_bus 0000:07: resource 1 io:  [0x4c00-0x4cff]
pci_bus 0000:07: resource 2 pref mem [0x20000000-0x23ffffff]
pci_bus 0000:07: resource 3 mem: [0x18000000-0x1bffffff]
pci_bus 0000:09: resource 0 io:  [0x1400-0x14ff]
pci_bus 0000:09: resource 1 io:  [0x1c00-0x1cff]
pci_bus 0000:09: resource 2 pref mem [0x24000000-0x27ffffff]
pci_bus 0000:09: resource 3 mem: [0x28000000-0x2bffffff]
pci_bus 0000:0d: resource 0 io:  [0x3400-0x34ff]
pci_bus 0000:0d: resource 1 io:  [0x3800-0x38ff]
pci_bus 0000:0d: resource 2 pref mem [0x2c000000-0x2fffffff]
pci_bus 0000:0d: resource 3 mem: [0x30000000-0x33ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs...
Freeing initrd memory: 4111k freed
Switched to high resolution mode on CPU 0
Simple Boot Flag at 0x35 set to 0x1
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 625
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:01:00.0: Boot video device
Non-volatile memory driver v1.3
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Platform driver 'serial8250' needs updating - please use dev_pm_ops
serial 00:0b: activated
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial 0000:00:0a.1: PCI INT A -> Link[LNKC] -> GSI 9 (level, low) -> IRQ 9
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
e100 0000:00:0a.0: PCI INT A -> Link[LNKC] -> GSI 9 (level, low) -> IRQ 9
e100 0000:00:0a.0: PME# disabled
e100: eth0: e100_probe: addr 0xf4010000, irq 9, MAC addr 00:90:27:96:b1:d0
console [netcon0] enabled
netconsole: network logging started
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
Platform driver 'i8042' needs updating - please use dev_pm_ops
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
Platform driver 'thinkpad_acpi' needs updating - please use dev_pm_ops
thinkpad_acpi: ThinkPad ACPI Extras v0.23
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS IZET9BWW (2.23 ), EC unknown
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
Registered led device: tpacpi::thinklight
thinkpad_acpi: acpi_bus_get_device(bay) failed: -19
thinkpad_acpi: disabling subdriver bay
Registered led device: tpacpi::power
Registered led device: tpacpi::standby
input: ThinkPad Extra Buttons as /devices/virtual/input/input1
TCP cubic registered
NET: Registered protocol family 17
Freeing unused kernel memory: 288k freed
Write protecting the kernel text: 2428k
Write protecting the kernel read-only data: 684k
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (67 C)
Platform driver 'floppy' needs updating - please use dev_pm_ops
Floppy drive(s): fd0 is 1.44M
Linux agpgart interface v0.103
SCSI subsystem initialized
agpgart-intel 0000:00:00.0: Intel 440BX Chipset
agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
ohci1394 0000:02:00.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[11]  MMIO=[f6000000-f60007ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
uhci_hcd 0000:00:07.2: PCI INT D -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x00001820
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.31-rc4-00350-g658874f uhci_hcd
usb usb1: SerialNumber: 0000:00:07.2
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
libata version 3.00 loaded.
pata_cmd64x 0000:02:01.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
scsi0 : pata_cmd64x
scsi1 : pata_cmd64x
ata1: PATA max UDMA/66 cmd 0x30a0 ctl 0x3094 bmdma 0x3080 irq 11
ata2: PATA max UDMA/66 cmd 0x3098 ctl 0x3090 bmdma 0x3088 irq 11
pata_cmd64x: active 10 recovery 10 setup 3.
pata_cmd64x: active 10 recovery 10 setup 3.
ata_piix 0000:00:07.1: version 2.13
scsi2 : ata_piix
scsi3 : ata_piix
ata3: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x1800 irq 14
ata4: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x1808 irq 15
pata_cmd64x: active 10 recovery 10 setup 3.
pata_cmd64x: active 10 recovery 10 setup 3.
usb 1-1: new full speed USB device using uhci_hcd and address 2
ata3.00: ATA-5: IC25N020ATCS04-0, CA2OA71A, max UDMA/100
ata3.00: 39070080 sectors, multi 16: LBA 
ata3.00: configured for UDMA/33
scsi 2:0:0:0: Direct-Access     ATA      IC25N020ATCS04-0 CA2O PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 39070080 512-byte logical blocks: (20.0 GB/18.6 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
usb 1-1: New USB device found, idVendor=0451, idProduct=2036
usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-1: Product: General Purpose USB Hub
usb 1-1: configuration #1 chosen from 1 choice
sd 2:0:0:0: [sda] Attached SCSI disk
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 2 ports detected
hub 1-1:1.0: unable to enumerate USB device on port 1
hub 1-1:1.0: unable to enumerate USB device on port 1
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011060000004434]
hub 1-1:1.0: unable to enumerate USB device on port 1
floppy0: no floppy controllers found
Platform driver 'floppy' needs updating - please use dev_pm_ops
Floppy drive(s): fd0 is 1.44M
hub 1-1:1.0: unable to enumerate USB device on port 1
floppy0: no floppy controllers found
PM: Starting manual resume from disk
hub 1-1:1.0: unable to enumerate USB device on port 1
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
hub 1-1:1.0: unable to enumerate USB device on port 1
udev: starting version 141
hub 1-1:1.0: unable to enumerate USB device on port 1
Marking TSC unstable due to TSC halts in idle
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor LNXCPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input3
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input4
ACPI: Sleep Button [SLPB]
ACPI: AC Adapter [AC] (on-line)
Platform driver 'floppy' needs updating - please use dev_pm_ops
Floppy drive(s): fd0 is 1.44M
hub 1-1:1.0: unable to enumerate USB device on port 1
parport_pc 00:0c: activated
parport_pc 00:0c: reported by Plug and Play ACPI
parport0: PC-style at 0x3bc (0x7bc), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
ACPI: Battery Slot [BAT0] (battery present)
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 242 bytes nvram
yenta_cardbus 0000:00:08.0: CardBus bridge found [1014:0185]
usb 1-1.1: new full speed USB device using uhci_hcd and address 94
hub 1-1:1.0: unable to enumerate USB device on port 1
yenta_cardbus 0000:00:08.0: ISA IRQ mask 0x0438, PCI irq 11
yenta_cardbus 0000:00:08.0: Socket status: 30000006
yenta_cardbus 0000:00:08.1: CardBus bridge found [1014:0185]
yenta_cardbus 0000:00:08.1: ISA IRQ mask 0x0438, PCI irq 11
yenta_cardbus 0000:00:08.1: Socket status: 30000006
yenta_cardbus 0000:02:02.0: CardBus bridge found [1014:0148]
yenta_cardbus 0000:02:02.0: Using INTVAL to route CSC interrupts to PCI
yenta_cardbus 0000:02:02.0: Routing CardBus interrupts to PCI
yenta_cardbus 0000:02:02.0: TI: mfunc 0x00001002, devctl 0x66
irq 11: nobody cared (try booting with the "irqpoll" option)
Pid: 924, comm: modprobe Not tainted 2.6.31-rc4-00350-g658874f #1
Call Trace:
 [<c125bfe3>] ? printk+0x23/0x40
 [<c1051fe3>] __report_bad_irq+0x33/0xb0
 [<c10521cd>] note_interrupt+0x16d/0x1b0
 [<c1052a3b>] handle_level_irq+0xab/0xe0
 [<c1005287>] handle_irq+0x97/0xb0
 [<c1004e15>] do_IRQ+0x45/0xb0
 [<c1041284>] ? tick_program_event+0x24/0x40
 [<c1052990>] ? handle_level_irq+0x0/0xe0
 [<c10036f0>] common_interrupt+0x30/0x38
 [<c1052990>] ? handle_level_irq+0x0/0xe0
 [<c1050ee2>] ? handle_IRQ_event+0x22/0x100
 [<c1052990>] ? handle_level_irq+0x0/0xe0
 [<c10529ec>] handle_level_irq+0x5c/0xe0
 <IRQ>  [<c1004e15>] ? do_IRQ+0x45/0xb0
 [<c10036f0>] ? common_interrupt+0x30/0x38
 [<d4b5858d>] ? yenta_probe_cb_irq+0xbd/0x150 [yenta_socket]
 [<d4b58920>] ? ti12xx_override+0x300/0x820 [yenta_socket]
 [<d4b59419>] ? yenta_probe+0x349/0x76a [yenta_socket]
 [<c1097dde>] ? iput+0x2e/0x80
 [<c10dab64>] ? sysfs_addrm_start+0x64/0xc0
 [<c113033d>] ? local_pci_probe+0x1d/0x40
 [<c1131368>] ? pci_device_probe+0x78/0xa0
 [<c11a084c>] ? driver_probe_device+0x8c/0x1a0
 [<c1130305>] ? pci_match_device+0xa5/0xc0
 [<c11a09f9>] ? __driver_attach+0x99/0xa0
 [<c11a0960>] ? __driver_attach+0x0/0xa0
 [<c119ffb2>] ? bus_for_each_dev+0x62/0xa0
 [<c11a0694>] ? driver_attach+0x24/0x40
 [<c11a0960>] ? __driver_attach+0x0/0xa0
 [<c119f73a>] ? bus_add_driver+0xba/0x260
 [<c1130360>] ? pci_device_shutdown+0x0/0x50
 [<c1131250>] ? pci_device_remove+0x0/0x60
 [<c11a0d73>] ? driver_register+0x83/0x170
 [<d4b5f000>] ? yenta_socket_init+0x0/0x3d [yenta_socket]
 [<c1131722>] ? __pci_register_driver+0x42/0xc0
 [<d4b5f000>] ? yenta_socket_init+0x0/0x3d [yenta_socket]
 [<d4b5f025>] ? yenta_socket_init+0x25/0x3d [yenta_socket]
 [<c1001125>] ? do_one_initcall+0x35/0x170
 [<c1039ac5>] ? blocking_notifier_call_chain+0x25/0x40
 [<c104a3dd>] ? sys_init_module+0xdd/0x220
 [<c1013239>] ? do_page_fault+0x179/0x270
 [<c10030af>] ? sysenter_do_call+0x12/0x26
handlers:
[<d4824930>] (ohci_irq_handler+0x0/0x8b0 [ohci1394])
[<d4906a60>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<d49a71b0>] (ata_sff_interrupt+0x0/0xf0 [libata])
[<d4b58f40>] (yenta_interrupt+0x0/0x100 [yenta_socket])
[<d4b58f40>] (yenta_interrupt+0x0/0x100 [yenta_socket])
Disabling IRQ #11
hub 1-1:1.0: unable to enumerate USB device on port 1
hub 1-1:1.0: unable to enumerate USB device on port 1
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input5
Platform driver 'pcspkr' needs updating - please use dev_pm_ops
input: PC Speaker as /devices/platform/pcspkr/input/input6
CS4281 0000:00:0b.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
yenta_cardbus 0000:02:02.0: ISA IRQ mask 0x0438, PCI irq 9
yenta_cardbus 0000:02:02.0: Socket status: 30000006
yenta_cardbus 0000:02:02.0: pcmcia: parent PCI bridge I/O window: 0x4000 - 0x4fff
yenta_cardbus 0000:02:02.0: pcmcia: parent PCI bridge Memory window: 0x14000000 - 0x1bffffff
yenta_cardbus 0000:02:02.0: pcmcia: parent PCI bridge Memory window: 0x1c000000 - 0x23ffffff
yenta_cardbus 0000:02:02.1: CardBus bridge found [1014:0148]
yenta_cardbus 0000:02:02.1: Using INTVAL to route CSC interrupts to PCI
yenta_cardbus 0000:02:02.1: Routing CardBus interrupts to PCI
yenta_cardbus 0000:02:02.1: TI: mfunc 0x00001002, devctl 0x66
irq 11: nobody cared (try booting with the "irqpoll" option)
Pid: 924, comm: modprobe Not tainted 2.6.31-rc4-00350-g658874f #1
Call Trace:
 [<c125bfe3>] ? printk+0x23/0x40
 [<c1051fe3>] __report_bad_irq+0x33/0xb0
 [<c10521cd>] note_interrupt+0x16d/0x1b0
 [<c1052a3b>] handle_level_irq+0xab/0xe0
 [<c1005287>] handle_irq+0x97/0xb0
 [<c1004e15>] do_IRQ+0x45/0xb0
 [<c1041284>] ? tick_program_event+0x24/0x40
 [<c1052990>] ? handle_level_irq+0x0/0xe0
 [<c10036f0>] common_interrupt+0x30/0x38
 [<c1052990>] ? handle_level_irq+0x0/0xe0
 [<c1050ee2>] ? handle_IRQ_event+0x22/0x100
 [<c1052990>] ? handle_level_irq+0x0/0xe0
 [<c10529ec>] handle_level_irq+0x5c/0xe0
 <IRQ>  [<c1004e15>] ? do_IRQ+0x45/0xb0
 [<c10036f0>] ? common_interrupt+0x30/0x38
 [<d4b5858d>] ? yenta_probe_cb_irq+0xbd/0x150 [yenta_socket]
 [<d4b587fe>] ? ti12xx_override+0x1de/0x820 [yenta_socket]
 [<d4b59419>] ? yenta_probe+0x349/0x76a [yenta_socket]
 [<c1097dde>] ? iput+0x2e/0x80
 [<c10dab64>] ? sysfs_addrm_start+0x64/0xc0
 [<c113033d>] ? local_pci_probe+0x1d/0x40
 [<c1131368>] ? pci_device_probe+0x78/0xa0
 [<c11a084c>] ? driver_probe_device+0x8c/0x1a0
 [<c1130305>] ? pci_match_device+0xa5/0xc0
 [<c11a09f9>] ? __driver_attach+0x99/0xa0
 [<c11a0960>] ? __driver_attach+0x0/0xa0
 [<c119ffb2>] ? bus_for_each_dev+0x62/0xa0
 [<c11a0694>] ? driver_attach+0x24/0x40
 [<c11a0960>] ? __driver_attach+0x0/0xa0
 [<c119f73a>] ? bus_add_driver+0xba/0x260
 [<c1130360>] ? pci_device_shutdown+0x0/0x50
 [<c1131250>] ? pci_device_remove+0x0/0x60
 [<c11a0d73>] ? driver_register+0x83/0x170
 [<d4b5f000>] ? yenta_socket_init+0x0/0x3d [yenta_socket]
 [<c1131722>] ? __pci_register_driver+0x42/0xc0
 [<d4b5f000>] ? yenta_socket_init+0x0/0x3d [yenta_socket]
 [<d4b5f025>] ? yenta_socket_init+0x25/0x3d [yenta_socket]
 [<c1001125>] ? do_one_initcall+0x35/0x170
 [<c1039ac5>] ? blocking_notifier_call_chain+0x25/0x40
 [<c104a3dd>] ? sys_init_module+0xdd/0x220
 [<c1013239>] ? do_page_fault+0x179/0x270
 [<c10030af>] ? sysenter_do_call+0x12/0x26
handlers:
[<d4824930>] (ohci_irq_handler+0x0/0x8b0 [ohci1394])
[<d4906a60>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<d49a71b0>] (ata_sff_interrupt+0x0/0xf0 [libata])
[<d4b58f40>] (yenta_interrupt+0x0/0x100 [yenta_socket])
[<d4b58f40>] (yenta_interrupt+0x0/0x100 [yenta_socket])
[<d4d7f3c0>] (snd_cs4281_interrupt+0x0/0x1f0 [snd_cs4281])
Disabling IRQ #11
floppy0: no floppy controllers found
Platform driver 'floppy' needs updating - please use dev_pm_ops
Floppy drive(s): fd0 is 1.44M
gameport: CS4281 Gameport is pci0000:00:0b.0/gameport0, speed 2386kHz
hub 1-1:1.0: unable to enumerate USB device on port 1
yenta_cardbus 0000:02:02.1: ISA IRQ mask 0x0438, PCI irq 9
yenta_cardbus 0000:02:02.1: Socket status: 30000006
yenta_cardbus 0000:02:02.1: pcmcia: parent PCI bridge I/O window: 0x4000 - 0x4fff
yenta_cardbus 0000:02:02.1: pcmcia: parent PCI bridge Memory window: 0x14000000 - 0x1bffffff
yenta_cardbus 0000:02:02.1: pcmcia: parent PCI bridge Memory window: 0x1c000000 - 0x23ffffff
Clocksource tsc unstable (delta = -117459214 ns)
hub 1-1:1.0: unable to enumerate USB device on port 1
hub 1-1:1.0: unable to enumerate USB device on port 1
floppy0: no floppy controllers found
hub 1-1:1.0: unable to enumerate USB device on port 1
hub 1-1:1.0: unable to enumerate USB device on port 1
Adding 680392k swap on /dev/sda2.  Priority:-1 extents:1 across:680392k 
EXT3 FS on sda1, internal journal
hub 1-1:1.0: unable to enumerate USB device on port 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
hub 1-1:1.0: unable to enumerate USB device on port 1
e100 0000:00:0a.0: firmware: using built-in firmware e100/d101s_ucode.bin
ADDRCONF(NETDEV_UP): eth0: link is not ready
hub 1-1:1.0: unable to enumerate USB device on port 1
e100: eth0 NIC Link is Up 100 Mbps Full Duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
hub 1-1:1.0: unable to enumerate USB device on port 1
thinkpad_acpi: requested hot key mask 0x000000ff, forced to 0x00000000 (NVRAM poll mask is 0x00fb8000): no firmware mask support
input: /usr/sbin/thinkpad-keys as /devices/virtual/input/input7
hub 1-1:1.0: unable to enumerate USB device on port 1
hub 1-1:1.0: unable to enumerate USB device on port 1
e100 0000:00:0a.0: firmware: using built-in firmware e100/d101s_ucode.bin
ADDRCONF(NETDEV_UP): eth0: link is not ready
hub 1-1:1.0: unable to enumerate USB device on port 1
e100: eth0 NIC Link is Up 100 Mbps Full Duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
hub 1-1:1.0: unable to enumerate USB device on port 1
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.13
Bluetooth: L2CAP socket layer initialized
hub 1-1:1.0: unable to enumerate USB device on port 1
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
hub 1-1:1.0: unable to enumerate USB device on port 1
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
hub 1-1:1.0: unable to enumerate USB device on port 1
lp0: using parport0 (interrupt-driven).
hub 1-1:1.0: unable to enumerate USB device on port 1
eth0: no IPv6 routers present
hub 1-1:1.0: unable to enumerate USB device on port 1

-- 
Meelis Roos (mroos@linux.ee)
