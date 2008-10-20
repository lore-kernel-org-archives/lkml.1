Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYJTWIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYJTWIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYJTWI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:08:28 -0400
Received: from connectmail.carleton.ca ([134.117.2.12]:59559 "EHLO
	connectmail.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYJTWIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:08:24 -0400
Date: Mon, 20 Oct 2008 18:08:18 -0400
From: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: Regression in 2.6.27: "irq 18: nobody cared" on Toshiba Satellite
 A100
In-reply-to: <48FC38AE.3030007@suse.de>
To: Stefan Assmann <sassmann@suse.de>
Cc: Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Olaf Dabrunz <odabrunz@suse.de>, linux-kernel@vger.kernel.org
Message-id: <48FD0152.60907@superonline.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
References: <48FB3ED5.60904@superonline.com>
 <1224431722.26279.4.camel@sven.thebigcorporation.com>
 <48FB6321.7030501@superonline.com> <48FC38AE.3030007@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Assmann wrote:
> M. Vefa Bicakci wrote:
>> Sven-Thorsten Dietrich wrote:
>>> On Sun, 2008-10-19 at 10:06 -0400, M. Vefa Bicakci wrote:
>>>> Hello,
>>>>
>>>> As you might guess from the subject line, since I started to use 2.6.27-rcX
>>>> series, I began to get "irq 18: nobody cared" messages in dmesg. Currently I am
>>>> using 2.6.27.2 with Sidux on this laptop, which is a Toshiba Satellite A100.
>>>> I have reproduced this problem with vanilla and sidux's kernels.
>>>>
>>> Can you provide the contents of /proc/interrupts? 
> 
> Could you provide the following:
> - output of lspci -nn
> - dmesg output with kernel commandline option apic=debug

The dmesg output with "apic=debug" is appended to this e-mail. Please note that
since the regression needs quite a few hours with the computer doing nothing to
show itself, this dmesg output does not include the "nobody cared" message. If
you need the dmesg output to contain the "nobody cared" message, then please let
me know.

Here's the output of "lspci -nn":

=== 8< ===
00:00.0 Host bridge [0600]: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub [8086:27a0] (rev 03)
00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller [8086:27a2] (rev 03)
00:02.1 Display controller [0380]: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller [8086:27a6] (rev 03)
00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller [8086:27d8] (rev 02)
00:1c.0 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 [8086:27d0] (rev 02)
00:1c.1 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 [8086:27d2] (rev 02)
00:1c.2 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 [8086:27d4] (rev 02)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 [8086:27c8] (rev 02)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 [8086:27c9] (rev 02)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 [8086:27ca] (rev 02)
00:1d.3 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 [8086:27cb] (rev 02)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller [8086:27cc] (rev 02)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev e2)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge [8086:27b9] (rev 02)
00:1f.2 IDE interface [0101]: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller [8086:27c4] (rev 02)
00:1f.3 SMBus [0c05]: Intel Corporation 82801G (ICH7 Family) SMBus Controller [8086:27da] (rev 02)
05:00.0 Network controller [0280]: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection [8086:4222] (rev 02)
07:06.0 CardBus bridge [0607]: Texas Instruments PCIxx12 Cardbus Controller [104c:8039]
07:06.1 FireWire (IEEE 1394) [0c00]: Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller [104c:803a]
07:06.2 Mass storage controller [0180]: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD) [104c:803b]
07:06.3 SD Host controller [0805]: Texas Instruments PCIxx12 SDA Standard Compliant SD Host Controller [104c:803c]
07:08.0 Ethernet controller [0200]: Intel Corporation PRO/100 VE Network Connection [8086:1092] (rev 02)
=== >8 ===

 
>> My computer is currently in the "nobody cared" state. Here are the current
>> contents of /proc/interrupts:
>>
>> --- 8< ---
>>            CPU0       CPU1       
>>   0:   45249492      60399   IO-APIC-edge      timer
>>   1:      25451          0   IO-APIC-edge      i8042
>>   8:          1          0   IO-APIC-edge      rtc0
>>   9:      36514          0   IO-APIC-fasteoi   acpi
>>  12:    1147983       2103   IO-APIC-edge      i8042
>>  14:     170245          0   IO-APIC-edge      ata_piix
>>  15:     558085        819   IO-APIC-edge      ata_piix
>>  16:        508          0   IO-APIC-fasteoi   uhci_hcd:usb5, i915@pci:0000:00:02.0
>>  17:       1353          0   IO-APIC-fasteoi   firewire_ohci
>>  18:     300158          1   IO-APIC-fasteoi   uhci_hcd:usb4, tifm_7xx1, yenta
>>  19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
>>  20:      26606          2   IO-APIC-fasteoi   eth0
>>  22:    3206279          1   IO-APIC-fasteoi   HDA Intel
>>  23:          3          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb2
>> 220:    2105545          0   PCI-MSI-edge      iwl3945
>> NMI:          0          0   Non-maskable interrupts
>> LOC:    5971997   27874747   Local timer interrupts
>> RES:     938710    1791498   Rescheduling interrupts
>> CAL:     138135     180813   function call interrupts
>> TLB:      48455      64413   TLB shootdowns
>> TRM:          0          0   Thermal event interrupts
>> SPU:          0          0   Spurious interrupts
>> ERR:          0
>> MIS:          0
>> --- >8 ---
> 
> Nothing unusual at first glance. How long did the system run?

The computer had been booted at 15:24 on October 18th. I got the "nobody cared"
message at 05:30 (am) on October 19th. The contents of "/proc/interrupts" that
are quoted above were generated at about 12:40 (afternoon) on October 19th.

There is one more thing I would like add. Last night, before going to sleep,
I wrote a simple bash script which, every two seconds, recorded the contents
of "/proc/interrupts" to a directory into a "ramfs" mount-point. (I chose "ramfs"
because I thought that "ramfs" would not interfere with the "swapper" process
which is shown as the reason in all of the "nobody cared" messsages.)

Interestingly, when I woke up today, the dmesg contents did *not* contain any
"nobody cared" messages. So I hit Ctrl-C and ended the execution of the script.
I then left the computer alone and went on to do other things. And guess what,
about four-five hours after I ended the script, I got the "nobody cared" message.
So it looks like the computer really needs to be doing "nothing" in order to get
this "nobody cared" message.

Unfortunately, all of this happened without the "apic=debug" command line option.
Tonight, I am going to leave the computer on with the "apic=debug" command line
option and without anything running.

Finally, I would like to say that I appreciate your help.

Regards,

M. Vefa Bicakci

Note: dmesg output with "apic=debug" follows:

=== 8< ===
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.27.2 (root@debian) (gcc version 4.3.2 (Debian 4.3.2-1) ) #1 SMP PREEMPT Sat Oct 18 20:19:36 EDT 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000005f670000 (usable)
 BIOS-e820: 000000005f670000 - 000000005f700000 (ACPI NVS)
 BIOS-e820: 000000005f700000 - 0000000060000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
last_pfn = 0x5f670 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 38000000 @ 7000-c000
RAMDISK: 37806000 - 37fef4eb
DMI present.
ACPI: RSDP 000F6510, 0014 (r0 TOSINV)
ACPI: RSDT 5F67E201, 0048 (r1 TOSINV Capell00  6040000  LTP        0)
ACPI: FACP 5F685DEE, 0074 (r1 TOSINV CALISTGA  6040000 LOHR       5A)
ACPI: DSDT 5F67F8B6, 6538 (r1 TOSINV CALISTGA  6040000 INTL 20050624)
ACPI: FACS 5F686FC0, 0040
ACPI: APIC 5F685E62, 0068 (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: HPET 5F685ECA, 0038 (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: MCFG 5F685F02, 003C (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: BOOT 5F685FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: APIC 5F685F70, 0068 (r1 TOSINV   APIC    6040000  LTP        0)
ACPI: SSDT 5F67F263, 064F (r1 SataRe  SataPri     1000 INTL 20050624)
ACPI: SSDT 5F67EBD1, 0692 (r1 SataRe  SataSec     1000 INTL 20050624)
ACPI: SSDT 5F67E249, 04F6 (r1  PmRef    CpuPm     3000 INTL 20050624)
ACPI: BIOS bug: multiple APIC/MADT found, using 0
ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
ACPI: DMI detected: Toshiba
630MB HIGHMEM available.
896MB LOWMEM available.
  mapped low ram: 0 - 38000000
  low ram: 00000000 - 38000000
  bootmap 00008000 - 0000f000
(9 early reservations) ==> bootmem [0000000000 - 0038000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 0000509420]    TEXT DATA BSS ==> [0000100000 - 0000509420]
  #4 [0037806000 - 0037fef4eb]          RAMDISK ==> [0037806000 - 0037fef4eb]
  #5 [000050a000 - 000050d000]    INIT_PG_TABLE ==> [000050a000 - 000050d000]
  #6 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #7 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
  #8 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f65c0] 000f65c0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00038000
  HighMem  0x00038000 -> 0x0005f670
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0005f670
On node 0 totalpages: 390671
free_area_init_node: node 0, pgdat c042db80, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 160131 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 68000000 (gap: 60000000:80000000)
PERCPU: Allocating 41220 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 387618
Kernel command line: root=/dev/mapper/root ro apic=debug
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 1828.727 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1536480k/1563072k available (2406k kernel code, 25412k reserved, 933k data, 320k init, 645568k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe18000 - 0xfffff000   (1948 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0449000 - 0xc0499000   ( 320 kB)
      .data : 0xc0359b08 - 0xc0443200   ( 933 kB)
      .text : 0xc0100000 - 0xc0359b08   (2406 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 3657.45 BogoMIPS (lpj=1828727)
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080609
Getting VERSION: 50014
Getting VERSION: 50014
Getting ID: 0
Getting LVT0: 700
Getting LVT1: 400
enabled ExtINT on CPU#0
ESR value before enabling vector: 0x00000040  after: 0x00000000
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 1-0 not connected.
 IO-APIC (apicid-pin) 1-16, 1-17, 1-18, 1-19, 1-20, 1-21, 1-22, 1-23 not connected.
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1039050
... PM timer delta = 357950
... PM timer result ok
..... delta 1039050
..... mult: 44633642
..... calibration result: 166248
..... CPU clock speed is 1828.0727 MHz.
..... host bus clock speed is 166.0248 MHz.
Booting processor 1/1 ip 6000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 3657.34 BogoMIPS (lpj=1828671)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (7314.79 BogoMIPS).
net_namespace: 792 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: 0000:00:02.0 reg 10 32bit mmio: [dc100000, dc17ffff]
PCI: 0000:00:02.0 reg 14 io port: [1800, 1807]
PCI: 0000:00:02.0 reg 18 32bit mmio: [c0000000, cfffffff]
PCI: 0000:00:02.0 reg 1c 32bit mmio: [dc200000, dc23ffff]
PCI: 0000:00:02.1 reg 10 32bit mmio: [dc180000, dc1fffff]
PCI: 0000:00:1b.0 reg 10 64bit mmio: [dc240000, dc243fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
PCI: 0000:00:1d.0 reg 20 io port: [1820, 183f]
PCI: 0000:00:1d.1 reg 20 io port: [1840, 185f]
PCI: 0000:00:1d.2 reg 20 io port: [1860, 187f]
PCI: 0000:00:1d.3 reg 20 io port: [1880, 189f]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [dc444000, dc4443ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: 0000:00:1f.2 reg 10 io port: [0, 7]
PCI: 0000:00:1f.2 reg 14 io port: [0, 3]
PCI: 0000:00:1f.2 reg 18 io port: [0, 7]
PCI: 0000:00:1f.2 reg 1c io port: [0, 3]
PCI: 0000:00:1f.2 reg 20 io port: [18b0, 18bf]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
PCI: 0000:00:1f.3 reg 20 io port: [18c0, 18df]
PCI: bridge 0000:00:1c.1 io port: [2000, 2fff]
PCI: bridge 0000:00:1c.1 32bit mmio: [d8000000, d9ffffff]
PCI: bridge 0000:00:1c.1 64bit mmio pref: [d2000000, d3ffffff]
PCI: 0000:05:00.0 reg 10 32bit mmio: [da000000, da000fff]
pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
pci 0000:05:00.0: PME# disabled
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:1c.2. It can be enabled forcedly with 'pcie_aspm=force'
PCI: bridge 0000:00:1c.2 io port: [3000, 3fff]
PCI: bridge 0000:00:1c.2 32bit mmio: [da000000, dbffffff]
PCI: bridge 0000:00:1c.2 64bit mmio pref: [d4000000, d5ffffff]
PCI: 0000:07:06.0 reg 10 32bit mmio: [0, fff]
pci 0000:07:06.0: supports D1
pci 0000:07:06.0: supports D2
pci 0000:07:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:07:06.0: PME# disabled
PCI: 0000:07:06.1 reg 10 32bit mmio: [dc006000, dc0067ff]
PCI: 0000:07:06.1 reg 14 32bit mmio: [dc000000, dc003fff]
pci 0000:07:06.1: supports D1
pci 0000:07:06.1: supports D2
pci 0000:07:06.1: PME# supported from D0 D1 D2 D3hot
pci 0000:07:06.1: PME# disabled
PCI: 0000:07:06.2 reg 10 32bit mmio: [dc004000, dc004fff]
pci 0000:07:06.2: supports D1
pci 0000:07:06.2: supports D2
pci 0000:07:06.2: PME# supported from D0 D1 D2 D3hot
pci 0000:07:06.2: PME# disabled
PCI: 0000:07:06.3 reg 10 32bit mmio: [dc006800, dc0068ff]
pci 0000:07:06.3: supports D1
pci 0000:07:06.3: supports D2
pci 0000:07:06.3: PME# supported from D0 D1 D2 D3hot
pci 0000:07:06.3: PME# disabled
PCI: 0000:07:08.0 reg 10 32bit mmio: [dc005000, dc005fff]
PCI: 0000:07:08.0 reg 14 io port: [4000, 403f]
pci 0000:07:08.0: supports D1
pci 0000:07:08.0: supports D2
pci 0000:07:08.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:07:08.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 io port: [4000, 4fff]
PCI: bridge 0000:00:1e.0 32bit mmio: [dc000000, dc0fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: Power Resource [FN00] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
IOAPIC[0]: Set PCI routing entry (1-13 -> 0x91 -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set PCI routing entry (1-8 -> 0x69 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set PCI routing entry (1-1 -> 0x39 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set PCI routing entry (1-12 -> 0x89 -> IRQ 12 Mode:0 Active:0)
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
number of MP IRQ sources: 15.
number of IO-APIC #1 registers: 24.
testing the IO APIC.......................
IO APIC #1......
.... register #00: 02000000
.......    : physical APIC id: 02
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00170020
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0020
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
 00 000 00  1    0    0   0   0    0    0    00
 01 003 03  1    0    0   0   0    1    1    39
 02 003 03  0    0    0   0   0    1    1    31
 03 003 03  0    0    0   0   0    1    1    41
 04 003 03  0    0    0   0   0    1    1    49
 05 003 03  0    0    0   0   0    1    1    51
 06 003 03  0    0    0   0   0    1    1    59
 07 003 03  0    0    0   0   0    1    1    61
 08 003 03  1    0    0   0   0    1    1    69
 09 003 03  0    1    0   0   0    1    1    71
 0a 003 03  0    0    0   0   0    1    1    79
 0b 003 03  0    0    0   0   0    1    1    81
 0c 003 03  1    0    0   0   0    1    1    89
 0d 003 03  1    0    0   0   0    1    1    91
 0e 003 03  0    0    0   0   0    1    1    99
 0f 003 03  0    0    0   0   0    1    1    A1
 10 000 00  1    0    0   0   0    0    0    00
 11 000 00  1    0    0   0   0    0    0    00
 12 000 00  1    0    0   0   0    0    0    00
 13 000 00  1    0    0   0   0    0    0    00
 14 000 00  1    0    0   0   0    0    0    00
 15 000 00  1    0    0   0   0    0    0    00
 16 000 00  1    0    0   0   0    0    0    00
 17 000 00  1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
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
.................................... done.
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
tracer: 772 pages allocated for 65536 entries of 48 bytes
   actual entries 65620
ACPI: RTC can wake from S4
system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff could not be reserved
system 00:01: iomem range 0xfed45000-0xfed8ffff could not be reserved
system 00:04: iomem range 0xfed00000-0xfed003ff could not be reserved
system 00:06: ioport range 0x400-0x401 has been reserved
system 00:06: ioport range 0x680-0x69f has been reserved
system 00:06: ioport range 0x800-0x80f has been reserved
system 00:06: ioport range 0x1000-0x107f has been reserved
system 00:06: ioport range 0x1180-0x11bf has been reserved
system 00:06: ioport range 0x1640-0x164f has been reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.1:   IO window: 0x2000-0x2fff
pci 0000:00:1c.1:   MEM window: 0xd8000000-0xd9ffffff
pci 0000:00:1c.1:   PREFETCH window: 0x000000d2000000-0x000000d3ffffff
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:05
pci 0000:00:1c.2:   IO window: 0x3000-0x3fff
pci 0000:00:1c.2:   MEM window: 0xda000000-0xdbffffff
pci 0000:00:1c.2:   PREFETCH window: 0x000000d4000000-0x000000d5ffffff
pci 0000:07:06.0: CardBus bridge, secondary bus 0000:08
pci 0000:07:06.0:   IO window: 0x004400-0x0044ff
pci 0000:07:06.0:   IO window: 0x004800-0x0048ff
pci 0000:07:06.0:   PREFETCH window: 0x68000000-0x6bffffff
pci 0000:07:06.0:   MEM window: 0x6c000000-0x6fffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:07
pci 0000:00:1e.0:   IO window: 0x4000-0x4fff
pci 0000:00:1e.0:   MEM window: 0xdc000000-0xdc0fffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000068000000-0x0000006bffffff
IOAPIC[0]: Set PCI routing entry (1-17 -> 0xa9 -> IRQ 17 Mode:1 Active:1)
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
IOAPIC[0]: Set PCI routing entry (1-16 -> 0xb1 -> IRQ 16 Mode:1 Active:1)
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
IOAPIC[0]: Set PCI routing entry (1-18 -> 0xb9 -> IRQ 18 Mode:1 Active:1)
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:07:06.0: enabling device (0000 -> 0003)
pci 0000:07:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 02 index 0 mmio: [0, 0]
bus: 02 index 1 mmio: [0, 0]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 io port: [2000, 2fff]
bus: 03 index 1 mmio: [d8000000, d9ffffff]
bus: 03 index 2 mmio: [d2000000, d3ffffff]
bus: 03 index 3 mmio: [0, 0]
bus: 05 index 0 io port: [3000, 3fff]
bus: 05 index 1 mmio: [da000000, dbffffff]
bus: 05 index 2 mmio: [d4000000, d5ffffff]
bus: 05 index 3 mmio: [0, 0]
bus: 07 index 0 io port: [4000, 4fff]
bus: 07 index 1 mmio: [dc000000, dc0fffff]
bus: 07 index 2 mmio: [68000000, 6bffffff]
bus: 07 index 3 io port: [0, ffff]
bus: 07 index 4 mmio: [0, ffffffffffffffff]
bus: 08 index 0 io port: [4400, 44ff]
bus: 08 index 1 io port: [4800, 48ff]
bus: 08 index 2 mmio: [68000000, 6bffffff]
bus: 08 index 3 mmio: [6c000000, 6fffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs...<7>Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
 done
Freeing initrd memory: 8101k freed
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1224524394.863:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1757
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pci 0000:07:08.0: Firmware left e100 interrupts enabled; disabling
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
pcieport-driver 0000:00:1c.2: setting latency timer to 64
pcieport-driver 0000:00:1c.2: found MSI capability
pci_express 0000:00:1c.2:pcie00: allocate port service
pci_express 0000:00:1c.2:pcie02: allocate port service
pci_express 0000:00:1c.2:pcie03: allocate port service
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
input: Macintosh mouse button emulation as /devices/virtual/input/input0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
Using IPI No-Shortcut mode
registered taskstats version 1
Freeing unused kernel memory: 320k freed
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
ACPI: Transitioning device [FAN0] to D3
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FAN0] (off)
ACPI: SSDT 5F67E9A0, 01A8 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
ACPI: SSDT 5F67E73F, 01DC (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor ACPI0007:00: registered as cooling_device1
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 5F67EB48, 0089 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
ACPI: SSDT 5F67E91B, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
Marking TSC unstable due to TSC halts in idle
ACPI: CPU1 (power states: C1[C1] C2[C2])
processor ACPI0007:01: registered as cooling_device2
ACPI: Processor [CPU1] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (52 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Thermal Zone [TZ01] (56 C)
ACPI: ACPI Dock Station Driver
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
IOAPIC[0]: Set PCI routing entry (1-23 -> 0xd9 -> IRQ 23 Mode:1 Active:1)
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001820
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
SCSI subsystem initialized
libata version 3.00 loaded.
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27.2 uhci_hcd
usb usb1: SerialNumber: 0000:00:1d.0
IOAPIC[0]: Set PCI routing entry (1-19 -> 0xe1 -> IRQ 19 Mode:1 Active:1)
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001840
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27.2 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27.2 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.2
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001880
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 3-2: new low speed USB device using uhci_hcd and address 2
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27.2 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.3
firewire_ohci 0000:07:06.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xdc444000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
firewire_ohci: Added fw-ohci device 0000:07:06.1, OHCI version 1.10
sdhci-pci 0000:07:06.3: SDHCI controller found [104c:803c] (rev 0)
sdhci-pci 0000:07:06.3: PCI INT A -> GSI 18 (level, low) -> IRQ 18
mmc0: SDHCI controller on PCI [0000:07:06.3] using DMA
IOAPIC[0]: Set PCI routing entry (1-20 -> 0xe9 -> IRQ 20 Mode:1 Active:1)
e100 0000:07:08.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
hub 3-0:1.0: unable to enumerate USB device on port 2
e100 0000:07:08.0: PME# disabled
e100: eth0: e100_probe: addr 0xdc005000, irq 20, MAC addr xx:xx:xx:xx:xx:xx
usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: EHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27.2 ehci_hcd
usb usb5: SerialNumber: 0000:00:1d.7
pata_acpi 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
pata_acpi 0000:00:1f.2: setting latency timer to 64
pata_acpi 0000:00:1f.2: PCI INT B disabled
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x18b0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x18b8 irq 15
usb 3-2: new low speed USB device using uhci_hcd and address 3
ata1.00: ATA-6: TOSHIBA MK8032GSX, AS112M, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
firewire_core: created device fw0: GUID xxxxxxxxxxxxxxxx, S400
ata2.00: ATAPI: MATSHITADVD-RAM UJ-841S, 1.60, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK8032GS AS11 PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-841S  1.60 PQ: 0 ANSI: 5
usb 3-2: configuration #1 chosen from 1 choice
Driver 'sr' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
usb 3-2: New USB device found, idVendor=0d62, idProduct=0004
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: USB Keyboard
usb 3-2: Manufacturer: Darfon
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
 sda1 sda2 sda3 < sda5<6>usbcore: registered new interface driver hiddev
 sda6<6>input: Darfon USB Keyboard as /devices/pci0000:00/0000:00:1d.2/usb3/3-2/3-2:1.0/input/input2
 sda7<6>input,hidraw0: USB HID v1.10 Keyboard [Darfon USB Keyboard] on usb-0000:00:1d.2-2
 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk
input: Darfon USB Keyboard as /devices/pci0000:00/0000:00:1d.2/usb3/3-2/3-2:1.1/input/input3
input,hiddev96,hidraw1: USB HID v1.10 Device [Darfon USB Keyboard] on usb-0000:00:1d.2-2
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
padlock: VIA PadLock not detected.
padlock: VIA PadLock Hash Engine not detected.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
PM: Starting manual resume from disk
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
udevd version 125 started
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: AC Adapter [ADP0] (on-line)
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input5
ACPI: Lid Switch [LID]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input6
ACPI: Power Button (CM) [PWRB]
ACPI: Battery Slot [BAT0] (battery present)
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/device:02/input/input7
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
acpi device:0a: registered as cooling_device3
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:07/input/input8
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26ks
iwl3945: Copyright(c) 2003-2008 Intel Corporation
iwl3945 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwl3945 0000:05:00.0: setting latency timer to 64
iwl3945: Detected Intel Wireless WiFi Link 3945ABG
iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
phy0: Selected rate control algorithm 'iwl-3945-rs'
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
iTCO_wdt: Found a ICH7-M TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
input: PC Speaker as /devices/platform/pcspkr/input/input9
intel_rng: FWH not detected
iwl3945 0000:05:00.0: PCI INT A disabled
Yenta: CardBus bridge found at 0000:07:06.0 [1179:ff10]
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:07:06.0, mfunc 0x01a01b22, devctl 0x66
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, hpet irqs
Yenta: ISA IRQ mask 0x0cf8, PCI irq 18
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#07) from #07 to #0b
pcmcia: parent PCI bridge I/O window: 0x4000 - 0x4fff
cs: IO port probe 0x4000-0x4fff: clean.
pcmcia: parent PCI bridge Memory window: 0xdc000000 - 0xdc0fffff
pcmcia: parent PCI bridge Memory window: 0x68000000 - 0x6bffffff
tifm_7xx1 0000:07:06.2: PCI INT A -> GSI 18 (level, low) -> IRQ 18
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ACPI: I/O resource 0000:00:1f.3 [0x18c0-0x18df] conflicts with ACPI region SMBI [0x18c0-0x18cf]
ACPI: Device needs an ACPI driver
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x25a0b1, caps: 0xa04713/0x0
synaptics: Toshiba Satellite A100 detected, limiting rate to 40pps.
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input10
IOAPIC[0]: Set PCI routing entry (1-22 -> 0x32 -> IRQ 22 Mode:1 Active:1)
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: Unknown model for ALC861, trying auto-probe from BIOS...
cs: IO port probe 0x100-0x3af: clean.
cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
EXT3 FS on dm-1, internal journal
fuse init (API version 7.9)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1999024k swap on /dev/mapper/suspend.  Priority:-1 extents:1 across:1999024k
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
lp: driver loaded but no devices found
ppdev: user-space parallel port driver
Bluetooth: Core ver 2.13
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ADDRCONF(NETDEV_UP): eth0: link is not ready
iwl3945 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwl3945 0000:05:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
firmware: requesting iwlwifi-3945-1.ucode
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
NET: Registered protocol family 17
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
wlan0: authenticate with AP xx:xx:xx:xx:xx:xx
wlan0: authenticated
wlan0: associate with AP xx:xx:xx:xx:xx:xx
wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x11 status=0 aid=1)
wlan0: associated
wlan0 (WE) : Wireless Event too big (346)
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
wlan0: no IPv6 routers present
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
=== >8 ===
I ran a "rmmod thermal" and then a "modprobe thermal" over here.
It seems to stop the annoying messages.
=== 8< ===
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (49 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Thermal Zone [TZ01] (50 C)
CE: hpet increasing min_delta_ns to 15000 nsec
wlan0: no IPv6 routers present
=== >8 ===
