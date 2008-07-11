Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbYGKQrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbYGKQrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 12:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYGKQrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 12:47:15 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:53887 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYGKQrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 12:47:12 -0400
Date: Fri, 11 Jul 2008 18:47:06 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sdhci: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter -
	disabling IRQ
Message-ID: <20080711164706.GA8943@hardeman.nu>
Mail-Followup-To: Pierre Ossman <drzeus-list@drzeus.cx>,
	linux-kernel@vger.kernel.org
References: <20080624181656.GB14243@hardeman.nu> <20080710083457.7887d363@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080710083457.7887d363@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 08:34:57AM +0200, Pierre Ossman wrote:
>On Tue, 24 Jun 2008 20:16:56 +0200 David Härdeman <david@hardeman.nu> wrote:
>>
>> I'm using my brand new HP 8510w laptop with kernel 2.6.25 (Debian kernel 
>> 2.6.25-2-amd64 version 2.6.25-5 to be exact) and the integrated memory 
>> card reader is detected by the sdhci kernel module.
>> 
>> However, about 10 minutes after boot I get the following message in 
>> dmesg (pid and process may change of course):
>> 
>> [  697.844419] irq 19: nobody cared (try booting with the "irqpoll" option)
>
>Do you have a card in at this point?

No, no card present during the entire time from boot until the above 
message.

>And can you give me a complete
>dmesg dump. The sdhci hardware might not be the culprit, but just a
>trigger in that it enables that interrupt line.

Attached below....and /proc/interrupts says:


            CPU0       CPU1       
   0:     250547     290540   IO-APIC-edge      timer
   1:       4700       4438   IO-APIC-edge      i8042
   7:          0          0   IO-APIC-edge      parport0
   8:          1          0   IO-APIC-edge      rtc
   9:       2960       2887   IO-APIC-fasteoi   acpi
  12:     371395     342127   IO-APIC-edge      i8042
  14:         92         78   IO-APIC-edge      ide0
  16:     176056     155841   IO-APIC-fasteoi   uhci_hcd:usb3, yenta
  17:         59         54   IO-APIC-fasteoi   uhci_hcd:usb4, yenta, HDA Intel
  18:         28         27   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb7, firewire_ohci
  19:      40955      59046   IO-APIC-fasteoi   sdhc0:slot0
  20:        448        457   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb5
  22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb6
1273:       1068        598   PCI-MSI-edge      eth0
1274:      41396      39036   PCI-MSI-edge      iwl4965
1275:      18013      12556   PCI-MSI-edge      ahci
NMI:          0          0   Non-maskable interrupts
LOC:     256042     253255   Local timer interrupts
RES:      80030      85162   Rescheduling interrupts
CAL:        222        300   function call interrupts
TLB:       1925       1993   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0


dmesg:


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.25-2-amd64 (Debian 2.6.25-5) (waldi@debian.org) (gcc version 4.1.3 20080420 (prerelease) (Debian 4.1.2-22)) #1 SMP Fri Jun 20 19:16:03 CEST 2008
[    0.000000] Command line: root=/dev/mapper/mainvg-mainlv ro 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffb0000 - 00000000bffc5400 (reserved)
[    0.000000]  BIOS-e820: 00000000bffc5400 - 00000000bffe7fb8 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bffe7fb8 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 786352) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 1048576, 1294336) 2 entries of 3200 used
[    0.000000] end_pfn_map = 1294336
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F7AF0, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT BFFC81CC, 0084 (r1 HPQOEM SLIC-MPC        1 HP          1)
[    0.000000] ACPI: FACP BFFC8084, 00F4 (r4 HP     30C5            3 HP          1)
[    0.000000] ACPI: DSDT BFFC8544, 12E41 (r1 HP        8510x    10000 MSFT  3000001)
[    0.000000] ACPI: FACS BFFE7D80, 0040
[    0.000000] ACPI: SLIC BFFC8250, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
[    0.000000] ACPI: HPET BFFC83C8, 0038 (r1 HP     30C5            1 HP          1)
[    0.000000] ACPI: APIC BFFC8400, 0068 (r1 HP     30C5            1 HP          1)
[    0.000000] ACPI: MCFG BFFC8468, 003C (r1 HP     30C5            1 HP          1)
[    0.000000] ACPI: TCPA BFFC84A4, 0032 (r2 HP     30C5            1 HP          1)
[    0.000000] ACPI: ASF! BFFC84D8, 0069 (r16 HP     CHIMAYU         1 HP          0)
[    0.000000] ACPI: SSDT BFFDB385, 0328 (r1 HP       HPQSAT        1 MSFT  3000001)
[    0.000000] ACPI: SSDT BFFDB6AD, 017C (r1 HP       HPQMRM        1 MSFT  3000001)
[    0.000000] ACPI: SSDT BFFDC231, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
[    0.000000] ACPI: SSDT BFFDC490, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
[    0.000000] ACPI: SSDT BFFDC536, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
[    0.000000] ACPI: DMI detected: Hewlett-Packard
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013c000000
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 786352) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 1048576, 1294336) 2 entries of 3200 used
[    0.000000] Bootmem setup node 0 0000000000000000-000000013c000000
[    0.000000]   NODE_DATA [000000000000e000 - 0000000000014fff]
[    0.000000]   bootmap [0000000000015000 -  000000000003c7ff] pages 28
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-64f2f7] TEXT DATA BSS
[    0.000000] early res: 3 [3781b000-37fefd7e] RAMDISK
[    0.000000] early res: 4 [9fc00-a0bff] EBDA
[    0.000000] early res: 5 [8000-dfff] PGTABLE
[    0.000000] No mptable found.
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0
[    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0
[    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0
[    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810006600000 on node 0
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810006a00000 on node 0
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810006e00000 on node 0
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810007200000 on node 0
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810007600000 on node 0
[    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810007a00000 on node 0
[    0.000000]  [ffffe20004400000-ffffe200045fffff] PMD ->ffff810007e00000 on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1294336
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   786352
[    0.000000]     0:  1048576 ->  1294336
[    0.000000] On node 0 totalpages: 1032015
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1113 pages reserved
[    0.000000]   DMA zone: 2830 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767976 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bffb0000 - 00000000bffc5000
[    0.000000] PM: Registered nosave memory: 00000000bffc5000 - 00000000bffc6000
[    0.000000] PM: Registered nosave memory: 00000000bffc6000 - 00000000bffe7000
[    0.000000] PM: Registered nosave memory: 00000000bffe7000 - 00000000bffe8000
[    0.000000] PM: Registered nosave memory: 00000000bffe8000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fed9a000
[    0.000000] PM: Registered nosave memory: 00000000fed9a000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000fedc0000
[    0.000000] PM: Registered nosave memory: 00000000fedc0000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:3ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 35096 bytes of per cpu data
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1013206
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/mapper/mainvg-mainlv ro 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000001] time.c: Detected 2393.988 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Checking aperture...
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing software IO TLB between 0x8021000 - 0xc021000
[    0.004000] Memory: 3991888k/5177344k available (2184k kernel code, 136172k reserved, 1088k data, 372k init)
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] hpet clockevent registered
[    0.080007] Calibrating delay using timer specific routine.. 4792.82 BogoMIPS (lpj=9585655)
[    0.080197] Security Framework initialized
[    0.080277] SELinux:  Disabled at boot.
[    0.080355] Capability LSM initialized
[    0.080741] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.083353] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.084753] Mount-cache hash table entries: 256
[    0.084971] Initializing cgroup subsys ns
[    0.085051] Initializing cgroup subsys cpuacct
[    0.085145] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.085283] CPU: L2 cache: 4096K
[    0.085359] CPU 0/0 -> Node 0
[    0.085434] CPU: Physical Processor ID: 0
[    0.085510] CPU: Processor Core ID: 0
[    0.085594] CPU0: Thermal monitoring handled by SMI
[    0.085595] using mwait in idle threads.
[    0.086369] ACPI: Core revision 20070126
[    0.093327] ACPI: Override [DSDT-   8510x], this is unsafe: tainting kernel
[    0.093410] ACPI: Table DSDT replaced by host OS
[    0.093608] ACPI: DSDT 00000000, 12E41 (r1 HP        8510x    10000 MSFT  3000001)
[    0.093822] ACPI: DSDT override uses original SSDTs unless "acpi_no_auto_ssdt"<6>Using local APIC timer interrupts.
[    0.144010] APIC timer calibration result 12468669
[    0.144011] Detected 12.468 MHz APIC timer.
[    0.144224] Booting processor 1/2 APIC 0x1
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4787.97 BogoMIPS (lpj=9575950)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 1/1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0b
[    0.232584] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.236047] Brought up 2 CPUs
[    0.236204] CPU0 attaching sched-domain:
[    0.236206]  domain 0: span 00000003
[    0.236207]   groups: 00000001 00000002
[    0.236210]   domain 1: span 00000003
[    0.236211]    groups: 00000003
[    0.236213] CPU1 attaching sched-domain:
[    0.236214]  domain 0: span 00000003
[    0.236216]   groups: 00000002 00000001
[    0.236218]   domain 1: span 00000003
[    0.236219]    groups: 00000003
[    0.236458] net_namespace: 1016 bytes
[    0.236538] Booting paravirtualized kernel on bare hardware
[    0.236780] NET: Registered protocol family 16
[    0.237019] ACPI: bus type pci registered
[    0.237169] PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
[    0.237249] PCI: Not using MMCONFIG.
[    0.237325] PCI: Using configuration type 1
[    0.240289] ACPI: EC: Look up EC in DSDT
[    0.005184] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.302028] ACPI: Interpreter enabled
[    0.302106] ACPI: (supports S0 S3 S4 S5)
[    0.302441] ACPI: Using IOAPIC for interrupt routing
[    0.314099] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    0.314181] ACPI: EC: driver started in interrupt mode
[    0.314312] ACPI: PCI Root Bridge [C003] (0000:00)
[    0.315653] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.315747] pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH6 GPIO
[    0.316869] PCI: Transparent bridge - 0000:00:1e.0
[    0.317033] ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
[    0.317483] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C096._PRT]
[    0.317600] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B0._PRT]
[    0.317773] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11D._PRT]
[    0.317913] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C131._PRT]
[    0.318055] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C134._PRT]
[    0.366117] ACPI: PCI Interrupt Link [C12D] (IRQs *10 11)
[    0.366647] ACPI: PCI Interrupt Link [C12E] (IRQs *10 11)
[    0.367174] ACPI: PCI Interrupt Link [C12F] (IRQs 10 *11)
[    0.367701] ACPI: PCI Interrupt Link [C130] (IRQs 10 11) *5
[    0.368237] ACPI: PCI Interrupt Link [C140] (IRQs *10 11)
[    0.368763] ACPI: PCI Interrupt Link [C141] (IRQs 10 11) *5
[    0.372237] ACPI: PCI Interrupt Link [C142] (IRQs 10 *11)
[    0.372658] ACPI Exception (pci_link-0184): AE_NOT_FOUND, Evaluating _PRS [20070126]
[    0.373179] ACPI: Power Resource [C238] (on)
[    0.373302] ACPI: Power Resource [C254] (on)
[    0.373433] ACPI: Power Resource [C17C] (off)
[    0.376141] ACPI: Power Resource [C362] (off)
[    0.376316] ACPI: Power Resource [C365] (off)
[    0.376489] ACPI: Power Resource [C366] (off)
[    0.376662] ACPI: Power Resource [C367] (off)
[    0.376834] ACPI: Power Resource [C368] (off)
[    0.376954] ACPI: Power Resource [C369] (off)
[    0.377129] ACPI: Power Resource [C382] (off)
[    0.377303] ACPI: Power Resource [C383] (off)
[    0.377476] ACPI: Power Resource [C384] (off)
[    0.377649] ACPI: Power Resource [C385] (off)
[    0.377823] ACPI: Power Resource [C386] (off)
[    0.378080] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.378181] pnp: PnP ACPI init
[    0.378261] ACPI: bus type pnp registered
[    0.378467]  00:00: calling quirk 0xffffffff8035b9ee: quirk_system_pci_resources+0x0/0x173()
[    0.378507] pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.381619] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.382791] pnp 00:02: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.382988] pnp 00:03: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.383030] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.383069] pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.383107] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.383150] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.383334] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.383377] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.383420] pnp 00:0a: Plug and Play ACPI device, IDs SYN0136 SYN0100 SYN0002 PNP0f13 (active)
[    0.383729]  00:0b: calling quirk 0xffffffff8035b9ee: quirk_system_pci_resources+0x0/0x173()
[    0.383770] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.385875] pnp 00:0c: Plug and Play ACPI device, IDs HPQ0004 (active)
[    0.385930]  00:0d: calling quirk 0xffffffff8035b9ee: quirk_system_pci_resources+0x0/0x173()
[    0.385979] pnp 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.387331]  00:0e: calling quirk 0xffffffff8035b9ee: quirk_system_pci_resources+0x0/0x173()
[    0.387386] pnp 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.387406] pnp: PnP ACPI: found 15 devices
[    0.387484] ACPI: ACPI bus type pnp unregistered
[    0.387699] usbcore: registered new interface driver usbfs
[    0.387818] usbcore: registered new interface driver hub
[    0.387926] usbcore: registered new device driver usb
[    0.388112] PCI: Using ACPI for IRQ routing
[    0.388190] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.404048] PCI-GART: No AMD northbridge found.
[    0.404130] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.404457] hpet0: 3 64-bit timers, 14318180 Hz
[    0.405568] ACPI: RTC can wake from S4
[    0.420043] pnp: the driver 'system' has been registered
[    0.420051] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.420131] system 00:00: iomem range 0xe0000-0xfffff could not be reserved
[    0.420213] system 00:00: iomem range 0x100000-0xbfffffff could not be reserved
[    0.420304] system 00:00: driver attached
[    0.420311] system 00:0b: ioport range 0x500-0x55f has been reserved
[    0.420392] system 00:0b: ioport range 0x800-0x80f has been reserved
[    0.420473] system 00:0b: iomem range 0xffb00000-0xffbfffff could not be reserved
[    0.420565] system 00:0b: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.420656] system 00:0b: driver attached
[    0.420660] system 00:0d: ioport range 0x4d0-0x4d1 has been reserved
[    0.420741] system 00:0d: ioport range 0x1000-0x107f has been reserved
[    0.420822] system 00:0d: ioport range 0x1100-0x113f has been reserved
[    0.420903] system 00:0d: ioport range 0x1200-0x121f has been reserved
[    0.420984] system 00:0d: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.421066] system 00:0d: iomem range 0xfec00000-0xfec000ff could not be reserved
[    0.421158] system 00:0d: iomem range 0xfed20000-0xfed3ffff could not be reserved
[    0.421249] system 00:0d: iomem range 0xfed45000-0xfed8ffff could not be reserved
[    0.421340] system 00:0d: iomem range 0xfed90000-0xfed99fff could not be reserved
[    0.421432] system 00:0d: driver attached
[    0.421436] system 00:0e: iomem range 0xcd200-0xcffff has been reserved
[    0.421516] system 00:0e: iomem range 0xd2000-0xd3fff has been reserved
[    0.421598] system 00:0e: iomem range 0xfeda0000-0xfedbffff could not be reserved
[    0.421689] system 00:0e: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.421781] system 00:0e: driver attached
[    0.422104] PCI: Failed to allocate mem resource #6:20000@e0000000 for 0000:01:00.0
[    0.422195] PCI: Bridge: 0000:00:01.0
[    0.422272]   IO window: 4000-4fff
[    0.422351]   MEM window: 0xe5000000-0xe7ffffff
[    0.422430]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.422512] PCI: Bridge: 0000:00:1c.0
[    0.422589]   IO window: disabled.
[    0.422669]   MEM window: disabled.
[    0.422747]   PREFETCH window: disabled.
[    0.422828] PCI: Bridge: 0000:00:1c.1
[    0.422905]   IO window: disabled.
[    0.422985]   MEM window: 0xe4000000-0xe40fffff
[    0.423065]   PREFETCH window: disabled.
[    0.423147] PCI: Bridge: 0000:00:1c.4
[    0.423225]   IO window: 2000-3fff
[    0.423306]   MEM window: 0xe0000000-0xe3ffffff
[    0.423386]   PREFETCH window: disabled.
[    0.423470] PCI: Bus 3, cardbus bridge: 0000:02:06.0
[    0.423548]   IO window: 0x00006000-0x000060ff
[    0.423629]   IO window: 0x00006400-0x000064ff
[    0.423710]   PREFETCH window: 0xc4000000-0xc7ffffff
[    0.423792]   MEM window: 0xcc000000-0xcfffffff
[    0.423873] PCI: Bus 4, cardbus bridge: 0000:02:06.1
[    0.423951]   IO window: 0x00006800-0x000068ff
[    0.424040]   IO window: 0x00006c00-0x00006cff
[    0.424121]   PREFETCH window: 0xc8000000-0xcbffffff
[    0.424202]   MEM window: 0xec000000-0xefffffff
[    0.424284] PCI: Bridge: 0000:00:1e.0
[    0.424362]   IO window: 6000-6fff
[    0.424443]   MEM window: 0xe4100000-0xe43fffff
[    0.424523]   PREFETCH window: 0x00000000c4000000-0x00000000cbffffff
[    0.424618] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.424774] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.424795] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.424951] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.424973] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[    0.425129] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.425151] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
[    0.425308] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    0.425321] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.425338] ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.425509] ACPI: PCI Interrupt 0000:02:06.1[B] -> GSI 17 (level, low) -> IRQ 17
[    0.425685] NET: Registered protocol family 2
[    0.464163] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.465303] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.469987] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.470745] TCP: Hash tables configured (established 524288 bind 65536)
[    0.470827] TCP reno registered
[    0.480216] checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
[    0.504046] Switched to high resolution mode on CPU 0
[    0.747848]  it is
[    1.032652] Freeing initrd memory: 8019k freed
[    0.800179] audit: initializing netlink socket (disabled)
[    0.800276] type=2000 audit(1215791369.036:1): initialized
[    0.800664] Total HugeTLB memory allocated, 0
[    0.800824] VFS: Disk quotas dquot_6.5.1
[    0.800921] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.801072] io scheduler noop registered
[    0.801150] io scheduler anticipatory registered
[    0.801227] io scheduler deadline registered
[    0.801314] io scheduler cfq registered (default)
[    0.801534] pci 0000:01:00.0: Boot video device
[    0.801627] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.801652] assign_interrupt_mode Found MSI capability
[    0.801755] Allocate Port Service[0000:00:01.0:pcie00]
[    0.801828] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.801869] assign_interrupt_mode Found MSI capability
[    0.801988] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.802083] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.802125] assign_interrupt_mode Found MSI capability
[    0.802245] Allocate Port Service[0000:00:1c.1:pcie00]
[    0.802273] Allocate Port Service[0000:00:1c.1:pcie02]
[    0.802366] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    0.802408] assign_interrupt_mode Found MSI capability
[    0.802528] Allocate Port Service[0000:00:1c.4:pcie00]
[    0.802556] Allocate Port Service[0000:00:1c.4:pcie02]
[    0.804687] Real Time Clock Driver v1.12ac
[    0.804976] hpet_resources: 0xfed00000 is busy
[    0.805055] Linux agpgart interface v0.103
[    0.805134] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    0.805454] pnp: the driver 'serial' has been registered
[    0.805607] ACPI: PCI Interrupt 0000:00:03.3[B] -> GSI 17 (level, low) -> IRQ 17
[    0.805840] 0000:00:03.3: ttyS0 at I/O 0x5030 (irq = 17) is a 16550A
[    0.806524] brd: module loaded
[    0.806652] input: Macintosh mouse button emulation as /class/input/input0
[    0.806803] pnp: the driver 'i8042 kbd' has been registered
[    0.806816] i8042 kbd 00:09: driver attached
[    0.806840] pnp: the driver 'i8042 aux' has been registered
[    0.806855] i8042 aux 00:0a: driver attached
[    0.806877] PNP: PS/2 Controller [PNP0303:C251,PNP0f13:C252] at 0x60,0x64 irq 1,12
[    0.808800] i8042.c: Detected active multiplexing controller, rev 1.1.
[    0.809636] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.809717] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.809796] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.809875] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.809954] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.828142] mice: PS/2 mouse device common for all mice
[    0.828250] cpuidle: using governor ladder
[    0.828328] cpuidle: using governor menu
[    0.828686] TCP cubic registered
[    0.828769] NET: Registered protocol family 1
[    0.828853] NET: Registered protocol family 17
[    0.829027] registered taskstats version 1
[    0.829211] Freeing unused kernel memory: 372k freed
[    0.849990] input: AT Translated Set 2 keyboard as /class/input/input1
[    1.140410] ACPI: Transitioning device [C36A] to D3
[    1.140524] ACPI: PNP0C0B:00 is registered as cooling_device0
[    1.140606] ACPI: Fan [C36A] (off)
[    1.140870] ACPI: Transitioning device [C36B] to D3
[    1.140973] ACPI: PNP0C0B:01 is registered as cooling_device1
[    1.141054] ACPI: Fan [C36B] (off)
[    1.141318] ACPI: Transitioning device [C36C] to D3
[    1.141421] ACPI: PNP0C0B:02 is registered as cooling_device2
[    1.141502] ACPI: Fan [C36C] (off)
[    1.141764] ACPI: Transitioning device [C36D] to D3
[    1.141866] ACPI: PNP0C0B:03 is registered as cooling_device3
[    1.141948] ACPI: Fan [C36D] (off)
[    1.142209] ACPI: Transitioning device [C36E] to D3
[    1.142312] ACPI: PNP0C0B:04 is registered as cooling_device4
[    1.142394] ACPI: Fan [C36E] (off)
[    1.142551] ACPI: Transitioning device [C36F] to D3
[    1.142653] ACPI: PNP0C0B:05 is registered as cooling_device5
[    1.142735] ACPI: Fan [C36F] (off)
[    1.142999] ACPI: Transitioning device [C387] to D3
[    1.143101] ACPI: PNP0C0B:06 is registered as cooling_device6
[    1.144098] ACPI: Fan [C387] (off)
[    1.144360] ACPI: Transitioning device [C388] to D3
[    1.144463] ACPI: PNP0C0B:07 is registered as cooling_device7
[    1.144544] ACPI: Fan [C388] (off)
[    1.144806] ACPI: Transitioning device [C389] to D3
[    1.144908] ACPI: PNP0C0B:08 is registered as cooling_device8
[    1.144991] ACPI: Fan [C389] (off)
[    1.145253] ACPI: Transitioning device [C38A] to D3
[    1.145355] ACPI: PNP0C0B:09 is registered as cooling_device9
[    1.145437] ACPI: Fan [C38A] (off)
[    1.145699] ACPI: Transitioning device [C38B] to D3
[    1.145801] ACPI: PNP0C0B:0a is registered as cooling_device10
[    1.145883] ACPI: Fan [C38B] (off)
[    0.917373] ACPI: SSDT BFFDB8F1, 02C1 (r1 HP      Cpu0Ist     3000 INTL 20060317)
[    0.917954] ACPI: SSDT BFFDBC37, 05FA (r1 HP      Cpu0Cst     3001 INTL 20060317)
[    1.161160] Monitor-Mwait will be used to enter C-1 state
[    1.161163] Monitor-Mwait will be used to enter C-2 state
[    1.161257] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    1.161548] ACPI: ACPI0007:00 is registered as cooling_device11
[    1.161628] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.162118] ACPI: SSDT BFFDB829, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20060317)
[    1.162571] ACPI: SSDT BFFDBBB2, 0085 (r1 HP      Cpu1Cst     3000 INTL 20060317)
[    0.930878] ACPI: CPU1 (power states: C1[C1] C2[C2])
[    1.164085] Marking TSC unstable due to TSC halts in idle
[    0.931291] ACPI: ACPI0007:01 is registered as cooling_device12
[    0.931378] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.936455] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    1.180893] ACPI: Thermal Zone [TZ2] (54 C)
[    1.183746] ACPI: LNXTHERM:02 is registered as thermal_zone1
[    1.184560] ACPI: Thermal Zone [TZ3] (46 C)
[    1.193676] ACPI: LNXTHERM:03 is registered as thermal_zone2
[    0.968264] ACPI: Thermal Zone [TZ4] (27 C)
[    0.972272] ACPI: LNXTHERM:04 is registered as thermal_zone3
[    0.976191] ACPI: Thermal Zone [TZ5] (30 C)
[    1.226944] ACPI: LNXTHERM:05 is registered as thermal_zone4
[    1.246699] ACPI: Thermal Zone [TZ0] (65 C)
[    1.246755] ACPI: LNXTHERM:06 is registered as thermal_zone5
[    1.246755] ACPI: Thermal Zone [TZ1] (61 C)
[    1.264636] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
[    1.264724] e1000e: Copyright (c) 1999-2007 Intel Corporation.
[    1.264858] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 22 (level, low) -> IRQ 22
[    1.265024] PCI: Setting latency timer of device 0000:00:19.0 to 64
[    1.494756] USB Universal Host Controller Interface driver v3.0
[    1.266346] No dock devices found.
[    1.271163] SCSI subsystem initialized
[    1.285533] libata version 3.00 loaded.
[    1.350548] sdhci: Secure Digital Host Controller Interface driver
[    1.350555] sdhci: Copyright(c) Pierre Ossman
[    1.596004] ricoh-mmc: Ricoh MMC Controller disabling driver
[    1.596092] ricoh-mmc: Copyright(c) Philip Langdale
[    1.388896] eth0: (PCI Express:2.5GB/s:Width x1) 00:1a:4b:80:af:5c
[    1.388980] eth0: Intel(R) PRO/1000 Network Connection
[    1.389086] eth0: MAC: 4, PHY: 6, PBA No: ffffff-0ff
[    1.389248] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[    1.389413] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[    1.389417] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.389651] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.393658] ehci_hcd 0000:00:1a.7: debug port 1
[    1.393743] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[    1.393754] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe8041000
[    1.410568] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    1.410758] usb usb1: configuration #1 chosen from 1 choice
[    1.410856] hub 1-0:1.0: USB hub found
[    1.410938] hub 1-0:1.0: 4 ports detected
[    1.513508] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.513591] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.513681] usb usb1: Product: EHCI Host Controller
[    1.513760] usb usb1: Manufacturer: Linux 2.6.25-2-amd64 ehci_hcd
[    1.513839] usb usb1: SerialNumber: 0000:00:1a.7
[    1.513955] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
[    1.514120] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    1.514123] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.514233] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.521297] ehci_hcd 0000:00:1d.7: debug port 1
[    1.521379] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    1.521390] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe8048000
[    1.533452] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    1.533616] usb usb2: configuration #1 chosen from 1 choice
[    1.533712] hub 2-0:1.0: USB hub found
[    1.533791] hub 2-0:1.0: 6 ports detected
[    1.636307] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.636394] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.636484] usb usb2: Product: EHCI Host Controller
[    1.636563] usb usb2: Manufacturer: Linux 2.6.25-2-amd64 ehci_hcd
[    1.636643] usb usb2: SerialNumber: 0000:00:1d.7
[    1.862463] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[    1.862463] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[    1.862463] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.862463] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.862463] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00005060
[    1.862463] usb usb3: configuration #1 chosen from 1 choice
[    1.862463] hub 3-0:1.0: USB hub found
[    1.862463] hub 3-0:1.0: 2 ports detected
[    1.962327] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.962411] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.962501] usb usb3: Product: UHCI Host Controller
[    1.962580] usb usb3: Manufacturer: Linux 2.6.25-2-amd64 uhci_hcd
[    1.962658] usb usb3: SerialNumber: 0000:00:1a.0
[    1.962772] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
[    1.962941] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[    1.962944] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.963061] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.963182] uhci_hcd 0000:00:1a.1: irq 17, io base 0x00005080
[    1.963357] usb usb4: configuration #1 chosen from 1 choice
[    1.963451] hub 4-0:1.0: USB hub found
[    1.963530] hub 4-0:1.0: 2 ports detected
[    1.978272] hub 1-0:1.0: unable to enumerate USB device on port 1
[    1.982256] Clocksource tsc unstable (delta = -295181074 ns)
[    2.066106] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.066193] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.066284] usb usb4: Product: UHCI Host Controller
[    2.066362] usb usb4: Manufacturer: Linux 2.6.25-2-amd64 uhci_hcd
[    2.066441] usb usb4: SerialNumber: 0000:00:1a.1
[    2.066547] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
[    2.066721] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    2.066724] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.066830] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    2.066943] uhci_hcd 0000:00:1d.0: irq 20, io base 0x000050a0
[    2.067110] usb usb5: configuration #1 chosen from 1 choice
[    2.067209] hub 5-0:1.0: USB hub found
[    2.067290] hub 5-0:1.0: 2 ports detected
[    2.169296] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.169384] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.169475] usb usb5: Product: UHCI Host Controller
[    2.169553] usb usb5: Manufacturer: Linux 2.6.25-2-amd64 uhci_hcd
[    2.169632] usb usb5: SerialNumber: 0000:00:1d.0
[    2.169736] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
[    2.169910] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    2.169913] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.170021] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    2.170136] uhci_hcd 0000:00:1d.1: irq 22, io base 0x000050c0
[    2.170302] usb usb6: configuration #1 chosen from 1 choice
[    2.170401] hub 6-0:1.0: USB hub found
[    2.170481] hub 6-0:1.0: 2 ports detected
[    2.217176] hub 2-0:1.0: unable to enumerate USB device on port 2
[    2.273076] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.273163] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.273254] usb usb6: Product: UHCI Host Controller
[    2.273332] usb usb6: Manufacturer: Linux 2.6.25-2-amd64 uhci_hcd
[    2.273412] usb usb6: SerialNumber: 0000:00:1d.1
[    2.273514] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    2.273688] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    2.273691] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.273798] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    2.273910] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000050e0
[    2.274075] usb usb7: configuration #1 chosen from 1 choice
[    2.274174] hub 7-0:1.0: USB hub found
[    2.274254] hub 7-0:1.0: 2 ports detected
[    2.376862] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.376949] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.377040] usb usb7: Product: UHCI Host Controller
[    2.377118] usb usb7: Manufacturer: Linux 2.6.25-2-amd64 uhci_hcd
[    2.377197] usb usb7: SerialNumber: 0000:00:1d.2
[    2.157441] ahci 0000:00:1f.2: version 3.0
[    2.157441] ACPI: PCI Interrupt 0000:00:1f.2[D] -> GSI 21 (level, low) -> IRQ 21
[    2.456828] usb 2-3: new high speed USB device using ehci_hcd and address 3
[    2.368916] usb 2-3: configuration #1 chosen from 1 choice
[    2.369152] usb 2-3: New USB device found, idVendor=4146, idProduct=ba01
[    2.369233] usb 2-3: New USB device strings: Mfr=0, Product=2, SerialNumber=3
[    2.369314] usb 2-3: Product: USB Mass Storage Device
[    2.369390] usb 2-3: SerialNumber: 00A00000000142
[    2.601071] Initializing USB Mass Storage driver...
[    2.607551] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    2.778052] usb 3-1: configuration #1 chosen from 1 choice
[    2.779740] usb 3-1: New USB device found, idVendor=03f0, idProduct=171d
[    2.783337] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.783419] usb 3-1: Product: HP Integrated Module
[    2.783496] usb 3-1: Manufacturer: Broadcom Corp
[    3.077922] usb 5-2: new full speed USB device using uhci_hcd and address 2
[    3.157738] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x1 impl SATA mode
[    3.157835] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part 
[    3.157930] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    3.158107] scsi0 : ahci
[    3.158290] scsi1 : ahci
[    3.158442] scsi2 : ahci
[    3.158572] ata1: SATA max UDMA/133 abar m2048@0xe8049000 port 0xe8049100 irq 1275
[    3.158664] ata2: DUMMY
[    3.161713] ata3: DUMMY
[    3.462821] usb 5-2: configuration #1 chosen from 1 choice
[    3.465336] usb 5-2: New USB device found, idVendor=08ff, idProduct=2580
[    3.465417] usb 5-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    3.465499] usb 5-2: Product: Fingerprint Sensor
[    3.593258] scsi3 : SCSI emulation for USB Mass Storage devices
[    3.374086] usb-storage: device found at 3
[    3.374086] usb-storage: waiting for device to settle before scanning
[    3.593559] usbcore: registered new interface driver usb-storage
[    3.593647] USB Mass Storage support registered.
[    3.856517] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.638465] ata1.00: ATA-7: ST9200420ASG, 3.AAA, max UDMA/133
[    3.638465] ata1.00: 390721968 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.859757] ata1.00: configured for UDMA/133
[    3.640195] scsi 0:0:0:0: Direct-Access     ATA      ST9200420ASG     3.AA PQ: 0 ANSI: 5
[    3.642751] ACPI: PCI Interrupt 0000:02:06.2[C] -> GSI 18 (level, low) -> IRQ 18
[    3.643039] Uniform Multi-Platform E-IDE driver
[    3.643118] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    3.871414] Driver 'sd' needs updating - please use bus_type methods
[    3.872542] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[    3.872641] sd 0:0:0:0: [sda] Write Protect is off
[    3.872719] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.872737] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.872875] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[    3.872965] sd 0:0:0:0: [sda] Write Protect is off
[    3.873043] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.873061] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.873154]  sda: sda1 sda2
[    3.887359] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.720245] firewire_ohci: Added fw-ohci device 0000:02:06.2, OHCI version 1.10
[    3.720642] sdhci: SDHCI controller found at 0000:02:06.3 [1180:0822] (rev 20)
[    3.720763] ACPI: PCI Interrupt 0000:02:06.3[D] -> GSI 19 (level, low) -> IRQ 19
[    3.720930] sdhc0:slot0: Will use DMA mode even though HW doesn't fully claim to support it.
[    3.721059] mmc0: SDHCI at 0xe4103000 irq 19 DMA
[    3.942461] ricoh-mmc: Ricoh MMC controller found at 0000:02:06.4 [1180:0843] (rev 10)
[    3.942567] ricoh-mmc: Controller is now disabled.
[    3.943097] ICH8M: IDE controller (0x8086:0x2850 rev 0x03) at  PCI slot 0000:00:1f.1
[    3.943194] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
[    3.943354] ICH8M: not 100% native mode: will probe irqs later
[    3.943441] ICH8M: IDE port disabled
[    3.943520]     ide0: BM-DMA at 0x5100-0x5107, BIOS settings: hda:DMA, hdb:PIO
[    3.943680] Probing IDE interface ide0...
[    4.439353] firewire_core: created device fw0: GUID 00023f99293d1810, S400
[    4.675079] hda: MATSHITADVD-RAM UJ-861H, ATAPI CD/DVD-ROM drive
[    5.010127] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    5.010432] hda: MWDMA2 mode selected
[    5.010831] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    4.800209] hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
[    4.800672] Uniform CD-ROM driver Revision: 3.20
[    5.067896] device-mapper: uevent: version 1.0.3
[    5.068258] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    8.585331] usb-storage: device scan complete
[    8.586298] scsi 3:0:0:0: Direct-Access     I0MEGA   UMni1GB*IOM2K4   1.01 PQ: 0 ANSI: 2
[    8.586944] sd 3:0:0:0: [sdb] 2048000 512-byte hardware sectors (1049 MB)
[    8.587548] sd 3:0:0:0: [sdb] Write Protect is off
[    8.587548] sd 3:0:0:0: [sdb] Mode Sense: 00 00 00 00
[    8.587548] sd 3:0:0:0: [sdb] Assuming drive cache: write through
[    8.589064] sd 3:0:0:0: [sdb] 2048000 512-byte hardware sectors (1049 MB)
[    8.589797] sd 3:0:0:0: [sdb] Write Protect is off
[    8.589876] sd 3:0:0:0: [sdb] Mode Sense: 00 00 00 00
[    8.589877] sd 3:0:0:0: [sdb] Assuming drive cache: write through
[    8.589961]  sdb: sdb1
[    8.590864] sd 3:0:0:0: [sdb] Attached SCSI removable disk
[    9.165396] PM: Starting manual resume from disk
[    9.422219] kjournald starting.  Commit interval 5 seconds
[    9.215032] EXT3-fs: mounted filesystem with ordered data mode.
[   11.627738] udevd version 124 started
[   12.117547] input: Power Button (FF) as /class/input/input2
[   12.181070] ACPI: Power Button (FF) [PWRF]
[   12.181245] input: Sleep Button (CM) as /class/input/input3
[   12.245069] ACPI: Sleep Button (CM) [C274]
[   12.245201] input: Lid Switch as /class/input/input4
[   12.277177] ACPI: Lid Switch [C26E]
[   12.534039] ACPI: Battery Slot [C1F4] (battery present)
[   12.534319] ACPI: Battery Slot [C1F3] (battery absent)
[   12.535054] ACPI: AC Adapter [C1F2] (on-line)
[   12.535206] ACPI: WMI: Mapper loaded
[   12.449296] ACPI: device:03 is registered as cooling_device13
[   12.450177] input: Video Bus as /class/input/input5
[   12.509356] ACPI: Video Device [C14B] (multi-head: yes  rom: no  post: no)
[   12.758228] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[   12.758384] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
[   12.758509] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   12.906091] Bluetooth: Core ver 2.11
[   12.743655] NET: Registered protocol family 31
[   12.743759] Bluetooth: HCI device and connection manager initialized
[   12.743846] Bluetooth: HCI socket layer initialized
[   12.900042] Yenta: CardBus bridge found at 0000:02:06.0 [103c:30c5]
[   13.181488] input: PC Speaker as /class/input/input6
[   13.024509] Yenta: ISA IRQ mask 0x0cb8, PCI irq 16
[   13.024591] Socket status: 30000006
[   13.024669] pcmcia: parent PCI bridge I/O window: 0x6000 - 0x6fff
[   13.024750] pcmcia: parent PCI bridge Memory window: 0xe4100000 - 0xe43fffff
[   13.024830] pcmcia: parent PCI bridge Memory window: 0xc4000000 - 0xcbffffff
[   13.025157] Yenta: CardBus bridge found at 0000:02:06.1 [103c:30c5]
[   13.265781] Bluetooth: HCI USB driver ver 2.9
[   13.267856] usbcore: registered new interface driver hci_usb
[   13.152530] Yenta: ISA IRQ mask 0x0000, PCI irq 17
[   13.152612] Socket status: 30000810
[   13.152690] Yenta: Raising subordinate bus# of parent bus (#02) from #04 to #07
[   13.152784] pcmcia: parent PCI bridge I/O window: 0x6000 - 0x6fff
[   13.152865] pcmcia: parent PCI bridge Memory window: 0xe4100000 - 0xe43fffff
[   13.152946] pcmcia: parent PCI bridge Memory window: 0xc4000000 - 0xcbffffff
[   13.220625] pnp: the driver 'tpm_inf_pnp' has been registered
[   13.220639] tpm_inf_pnp 00:03: Found C239 with ID IFX0102
[   13.220772] tpm_inf_pnp 00:03: TPM found: config base 0x560, data base 0x570, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[   13.221117] tpm_inf_pnp 00:03: driver attached
[   13.573639] iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.23ks
[   13.573740] iwl4965: Copyright(c) 2003-2007 Intel Corporation
[   13.573913] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   13.574094] PCI: Setting latency timer of device 0000:10:00.0 to 64
[   13.574117] iwl4965: Detected Intel Wireless WiFi Link 4965AGN
[   13.623043] iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
[   13.430525] phy0: Selected rate control algorithm 'iwl-4965-rs'
[   13.529028] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[   13.791215] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 17 (level, low) -> IRQ 17
[   13.791390] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   13.981201] pccard: PCMCIA card inserted into slot 1
[   13.801815] cs: memory probe 0xc4000000-0xcbffffff: excluding 0xc4000000-0xcbffffff
[   13.802112] cs: memory probe 0xe4100000-0xe43fffff: excluding 0xe4100000-0xe412ffff
[   13.807235] pcmcia: registering new device pcmcia1.0
[   13.819246] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x2580b1, caps: 0xa44793/0x300000
[   13.819348] serio: Synaptics pass-through port at isa0060/serio4/input0
[   14.056385] input: SynPS/2 Synaptics TouchPad as /class/input/input7
[   13.896260] pnp: the driver 'parport_pc' has been registered
[   13.896274] parport_pc 00:02: reported by Plug and Play ACPI
[   13.896433] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
[   14.180927] parport_pc 00:02: driver attached
[   14.004125] Probing IDE interface ide1...
[   14.665058] Probing IDE interface ide1...
[   15.327306] Probing IDE interface ide1...
[   15.987508] Probing IDE interface ide1...
[   16.653878] Probing IDE interface ide1...
[   17.323745] Probing IDE interface ide1...
[   17.986282] Probing IDE interface ide1...
[   18.538784] input: PS/2 Generic Mouse as /class/input/input8
[   18.647155] Probing IDE interface ide1...
[   19.320789] Probing IDE interface ide1...
[   19.994254] Probing IDE interface ide1...
[   20.666661] ide-cs: ide_register() at 0x6100 & 0x610e, irq 17 failed
[   20.921659] Probing IDE interface ide1...
[   21.590141] Probing IDE interface ide1...
[   22.260238] Probing IDE interface ide1...
[   22.930242] Probing IDE interface ide1...
[   23.600538] Probing IDE interface ide1...
[   24.268936] Probing IDE interface ide1...
[   24.939216] Probing IDE interface ide1...
[   25.608802] Probing IDE interface ide1...
[   26.278791] Probing IDE interface ide1...
[   26.947439] Probing IDE interface ide1...
[   27.617566] ide-cs: ide_register() at 0x6100 & 0x610e, irq 17 failed
[   29.011590] EXT3 FS on dm-2, internal journal
[   29.688449] loop: module loaded
[   30.711493] kjournald starting.  Commit interval 5 seconds
[   30.716598] EXT3 FS on sda1, internal journal
[   30.716744] EXT3-fs: mounted filesystem with ordered data mode.
[   30.972323] Adding 4194296k swap on /dev/mapper/mainvg-swaplv.  Priority:-1 extents:1 across:4194296k
[   33.243517] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   33.243615] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[   38.780696] NET: Registered protocol family 10
[   38.781203] lo: Disabled Privacy Extensions
[   38.781671] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   38.782122] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   40.004386] lp0: using parport0 (interrupt-driven).
[   40.264224] ppdev: user-space parallel port driver
[   45.634857] Bluetooth: L2CAP ver 2.9
[   45.634968] Bluetooth: L2CAP socket layer initialized
[   45.524961] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   45.839788] Bluetooth: BNEP (Ethernet Emulation) ver 1.2
[   45.839871] Bluetooth: BNEP filters: protocol multicast
[   45.634542] Bridge firewalling registered
[   45.635739] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
[   45.869858] Bluetooth: RFCOMM socket layer initialized
[   45.869981] Bluetooth: RFCOMM TTY layer initialized
[   45.870093] Bluetooth: RFCOMM ver 1.8
[   50.125136] wlan0: Initial auth_alg=0
[   50.125142] wlan0: authenticate with AP XX:XX:XX:XX:XX:XX
[   50.326066] wlan0: authenticate with AP XX:XX:XX:XX:XX:XX
[   50.526077] wlan0: authenticate with AP XX:XX:XX:XX:XX:XX
[   50.726090] wlan0: authentication with AP XX:XX:XX:XX:XX:XX timed out
[   52.898902] wlan0: Initial auth_alg=0
[   52.898906] wlan0: authenticate with AP XX:XX:XX:XX:XX:XX
[   52.904090] wlan0: Initial auth_alg=0
[   52.904094] wlan0: authenticate with AP XX:XX:XX:XX:XX:XX
[   52.907002] wlan0: Initial auth_alg=0
[   52.907005] wlan0: authenticate with AP XX:XX:XX:XX:XX:XX
[   52.909904] wlan0: RX authentication from XX:XX:XX:XX:XX:XX (alg=0 transaction=2 status=0)
[   52.909909] wlan0: authenticated
[   52.909911] wlan0: associate with AP XX:XX:XX:XX:XX:XX
[   52.912175] wlan0: RX AssocResp from XX:XX:XX:XX:XX:XX (capab=0x411 status=0 aid=4)
[   52.912179] wlan0: associated
[   52.912181] wlan0: switched to short barker preamble (BSSID=XX:XX:XX:XX:XX:XX)
[   52.912742] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   62.999277] wlan0: no IPv6 routers present
[   74.388846] CPU0 attaching NULL sched-domain.
[   74.388859] CPU1 attaching NULL sched-domain.
[   74.408739] CPU0 attaching sched-domain:
[   74.408751]  domain 0: span 00000003
[   74.408755]   groups: 00000001 00000002
[   74.408763]   domain 1: span 00000003
[   74.408767]    groups: 00000003
[   74.408773] CPU1 attaching sched-domain:
[   74.408777]  domain 0: span 00000003
[   74.408781]   groups: 00000002 00000001
[   74.408787]   domain 1: span 00000003
[   74.408791]    groups: 00000003
[  637.730290] irq 19: nobody cared (try booting with the "irqpoll" option)
[  637.730290] Pid: 0, comm: swapper Tainted: G       A 2.6.25-2-amd64 #1
[  637.730290] 
[  637.730290] Call Trace:
[  637.730290]  <IRQ>  [<ffffffff8022a6a1>] __update_rq_clock+0x1a/0xcf
[  637.730290]  [<ffffffff8026ca2f>] __report_bad_irq+0x30/0x72
[  637.730290]  [<ffffffff8026cc6e>] note_interrupt+0x1fd/0x23f
[  637.730290]  [<ffffffff8026d4fb>] handle_fasteoi_irq+0xa5/0xc8
[  637.730290]  [<ffffffff8020f41c>] do_IRQ+0x6d/0xd9
[  637.730290]  [<ffffffff8020c34d>] ret_from_intr+0x0/0x19
[  637.730290]  <EOI>  [<ffffffff802203f0>] hpet_legacy_next_event+0x0/0x34
[  637.730290]  [<ffffffff8802b44a>] :processor:acpi_idle_enter_simple+0x18d/0x1ff
[  637.730290]  [<ffffffff803a1e6f>] cpuidle_idle_call+0x7a/0xb3
[  637.730290]  [<ffffffff803a1df5>] cpuidle_idle_call+0x0/0xb3
[  637.730290]  [<ffffffff8020af52>] cpu_idle+0x89/0xb3
[  637.730290] 
[  637.730290] handlers:
[  637.730290] [<ffffffff8810c9e4>] (sdhci_irq+0x0/0x609 [sdhci])
[  637.730290] Disabling IRQ #19

-- 
David Härdeman
