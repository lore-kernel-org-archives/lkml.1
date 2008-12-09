Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbYLIHmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbYLIHmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 02:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYLIHmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 02:42:14 -0500
Received: from smtprelay.restena.lu ([158.64.1.62]:41764 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYLIHmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 02:42:13 -0500
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 02:42:12 EST
Date: Tue, 9 Dec 2008 08:34:40 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bruno.premont@restena.lu>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stefan Winter <stefan.winter@restena.lu>
Subject: [2.6.27.4-5 stable regressions] Kernel boot early crash with
 low-64k reservation patches
Message-ID: <20081209083440.7569d7a0@pluto.restena.lu>
Organization: Fondation RESTENA
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On a VMWare (ESX 3.5.0 Update 3) guest we get boot failure at the very
beginning of boot process. (Boot successful with 2.6.27.4, failing with
2.6.27.x where x > 4 or just adding the 5 patches below to 2.6.27.4)

State of config option
  CONFIG_X86_RESERVE_LOW_64K=y
or
  # CONFIG_X86_RESERVE_LOW_64K not set
does not make any difference.


Bruno


========== console output (manual copy) ===============================
Decompressing Linux... Parsing ELF... done.
Booting the kernel.




BUG: Int 14: CR2 fbe00000
     EDI c0385f65  ESI fbe00000  EBP c0385f80  ESP c0385f4c
     EBX fbe00000  EDX 0000000e  ECX 00000003  EAX fbe10000
     err 00000000  EIP c0399f8d   CS 00000062  flg 00010087
Stack: fbe10000 fbe00000 c0385f80 c038cb6d fc001340 00000001 00000000 00000000
       00000000 c0385fbc c03875a7 00000000 c0385fcc c0385fc0 c0389447 00100000
       00000000 00000000 00099800 c0380000 c0385fbc 00000000 00099800 c0380000
=======================================================================

The error is caused by one of the 5 patches that introduce low-64k
memory protection:
  71556e929b5666bc03750402ce30e3c61cd5148e
    x86: add DMI quirk for AMI BIOS which corrupts address 0xc000 during resume
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
  41943efb7cff566ad1f6334bbddbb8b8a4bfeb59
    x86: reserve low 64K on AMI and Phoenix BIOS boxen
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
  093327cb21660a2f0c028c9c8550b2808600281f
    x86: add X86_RESERVE_LOW_64K
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
  5c371b31be32033b0a4a993431484da8a2305369
    x86: fix CONFIG_X86_RESERVE_LOW_64K=y
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
  c27c4b666ddf7a36b6f20c9b809217157496b36b
    x86: fix macro with bad_bios_dmi_table
    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>




Boot messages for successful boot with 2.6.27.4:

Linux version 2.6.27.4 (root@new-virtual) (gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #1 Mon Oct 27 12:11:42 CET 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fef0000 (usable)
 BIOS-e820: 000000000fef0000 - 000000000feff000 (ACPI data)
 BIOS-e820: 000000000feff000 - 000000000ff00000 (ACPI NVS)
 BIOS-e820: 000000000ff00000 - 0000000010000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
VMI: Found VMware, Inc. Hypervisor OPROM, API version 3.0, ROM version 1.0
Reserving virtual address space above 0xfc000000
last_pfn = 0x10000 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
kernel direct mapping tables up to 10000000 @ 7000-c000
DMI present.
ACPI: RSDP 000F6C60, 0014 (r0 PTLTD )
ACPI: RSDT 0FEFAB68, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 0FEFEF14, 0074 (r1 INTEL  440BX     6040000 PTL     F4240)
ACPI: DSDT 0FEFAB98, 437C (r1 PTLTD  Custom    6040000 MSFT  100000D)
ACPI: FACS 0FEFFFC0, 0040
ACPI: APIC 0FEFEF88, 0050 (r1 PTLTD      APIC    6040000  LTP        0)
ACPI: BOOT 0FEFEFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
256MB LOWMEM available.
  mapped low ram: 0 - 10000000
  low ram: 00000000 - 10000000
  bootmap 00001000 - 00003000
(6 early reservations) ==> bootmem [0000000000 - 0010000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 00003d67dc]    TEXT DATA BSS ==> [0000100000 - 00003d67dc]
  #2 [00003d7000 - 00003d9000]    INIT_PG_TABLE ==> [00003d7000 - 00003d9000]
  #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #4 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
  #5 [0000001000 - 0000003000]          BOOTMAP ==> [0000001000 - 0000003000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00010000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0000fef0
    0: 0x0000ff00 -> 0x00010000
On node 0 totalpages: 65423
free_area_init_node: node 0, pgdat c0379adc, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 60944 pages, LIFO batch:15
ACPI: PM-Timer IO Port: 0x1008
Allocating PCI resources starting at 20000000 (gap: 10000000:eec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64911
Kernel command line: root=/dev/sda2 vga=normal
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 4096 bytes)
Detected 2333.413 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 256128k/262144k available (1788k kernel code, 5320k reserved, 766k data, 204k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfbff9000 - 0xfbfff000   (  24 kB)
    vmalloc : 0xd0800000 - 0xfbff7000   ( 695 MB)
    lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
      .init : 0xc0382000 - 0xc03b5000   ( 204 kB)
      .data : 0xc02bf12e - 0xc037eb64   ( 766 kB)
      .text : 0xc0100000 - 0xc02bf12e   (1788 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
vmi: registering clock event vmi-timer. mult=9787043 shift=22
Calibrating delay loop (skipped), value calculated using timer frequency.. 4666.82 BogoMIPS (lpj=23334130)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 08
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20080609
ACPI: setting ELCR to 0200 (from 0a00)
net_namespace: 440 bytes
Booting paravirtualized kernel on vmi
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd9a0, last bus=1
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: 0000:00:07.1 reg 20 io port: [1050, 105f]
pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB
PCI: 0000:00:0f.0 reg 10 io port: [1060, 106f]
PCI: 0000:00:0f.0 reg 14 32bit mmio: [f8000000, fbffffff]
PCI: 0000:00:0f.0 reg 18 32bit mmio: [f4000000, f47fffff]
PCI: 0000:00:0f.0 reg 30 32bit mmio: [0, 7fff]
PCI: 0000:00:10.0 reg 10 io port: [1080, 10ff]
PCI: 0000:00:10.0 reg 14 32bit mmio: [f4800000, f4800fff]
PCI: 0000:00:10.0 reg 30 32bit mmio: [0, 3fff]
PCI: 0000:00:11.0 reg 10 io port: [1400, 147f]
PCI: 0000:00:11.0 reg 30 32bit mmio: [0, ffff]
PCI: 0000:00:12.0 reg 30 32bit mmio: [0, 3fff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
system 00:01: ioport range 0x1000-0x103f has been reserved
system 00:01: ioport range 0x1040-0x104f has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: disabled
pci 0000:00:01.0:   PREFETCH window: disabled
pci 0000:00:01.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffff]
bus: 01 index 0 mmio: [0, 0]
bus: 01 index 1 mmio: [0, 0]
bus: 01 index 2 mmio: [0, 0]
bus: 01 index 3 mmio: [0, 0]
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x36 set to 0x1
vmi: registering clock source khz=2333413
Switched to NOHz mode on CPU #0
msgmni has been set to 500
...


DMI decode output:

# dmidecode 2.9
SMBIOS 2.4 present.
45 structures occupying 1730 bytes.
Table at 0x000E0010.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
        Vendor: Phoenix Technologies LTD
        Version: 6.00
        Release Date: 07/22/2008
        Address: 0xE7910
        Runtime Size: 100080 bytes
        ROM Size: 64 kB
        Characteristics:
                ISA is supported
                PCI is supported
                PC Card (PCMCIA) is supported
                PNP is supported
                APM is supported
                BIOS is upgradeable
                BIOS shadowing is allowed
                ESCD support is available
                USB legacy is supported
                Smart battery is supported
                BIOS boot specification is supported
                Targeted content distribution is supported
        BIOS Revision: 4.6
        Firmware Revision: 0.0

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: VMware, Inc.
        Product Name: VMware Virtual Platform
        Version: None
        Serial Number: <stripped>
        UUID: <stripped>
        Wake-up Type: Power Switch
        SKU Number: Not Specified
        Family: Not Specified
...


