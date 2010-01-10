Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331Ab0AJCa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0AJCa3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 21:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350Ab0AJCa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 21:30:29 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35029 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab0AJCa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 21:30:27 -0500
Date: Sun, 10 Jan 2010 08:00:15 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: suresh.b.siddha@intel.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [PATCH] Make Intel 8-way Xeons boot again
Message-ID: <20100110023015.GA2253@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100109101038.GA17555@in.ibm.com> <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 01:13:39PM -0800, Yinghai Lu wrote:
> On Sat, Jan 9, 2010 at 2:10 AM, Ananth N Mavinakayanahalli
> <ananth@in.ibm.com> wrote:
> > On an 8-way system with Intel Xeon X7350 CPUs, booting 2.6.32 or newer
> > kernels fails at:
> >
> > ...
> > CPU0: Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz stepping 0b
> > Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
> > Brought up 8 CPUs
> > Total of 8 processors activated (46906.05 BogoMIPS).
> >
> > Git bisect showed 2fbd07a5f as the offending commit.
> >
> > With the patch below, I am able to boot the latest Linus' git tree on
> > the machine. If this patch is correct, it needs to get into the stable
> > tree too.
> >
> > Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > ---
> > Index: linux-2.6/arch/x86/kernel/apic/probe_64.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/kernel/apic/probe_64.c      2010-01-09 14:54:29.000000000 +0530
> > +++ linux-2.6/arch/x86/kernel/apic/probe_64.c   2010-01-09 14:57:53.000000000 +0530
> > @@ -70,7 +70,7 @@
> >        if (apic == &apic_flat) {
> >                switch (boot_cpu_data.x86_vendor) {
> >                case X86_VENDOR_INTEL:
> > -                       if (num_processors > 8)
> > +                       if (num_processors >= 8)
> >                                apic = &apic_physflat;
> >                        break;
> >                case X86_VENDOR_AMD:
> 
> can you send out whole bootlog with apic=debug?

Here it is:

Linux version 2.6.33-rc3-bsect (ananth@llm69.in.ibm.com) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-46)) #1 SMP Sun Jan 10 07:36:02 IST 2010
Command line: ro root=LABEL=/ rhgb console=tty0 console=ttyS0,9600n1 apic=debug
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
 BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bff4b480 (usable)
 BIOS-e820: 00000000bff4b480 - 00000000bff57b40 (ACPI data)
 BIOS-e820: 00000000bff57b40 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000d0000000 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000840000000 (usable)
NX (Execute Disable) protection: active
DMI 2.4 present.
No AGP bridge found
last_pfn = 0x840000 max_arch_pfn = 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xbff4b max_arch_pfn = 0x400000000
Scan SMP from ffff880000000000 for 1024 bytes.
Scan SMP from ffff88000009fc00 for 1024 bytes.
Scan SMP from ffff8800000f0000 for 65536 bytes.
Scan SMP from ffff88000009bc00 for 1024 bytes.
found SMP MP-table at [ffff88000009bd40] 9bd40
  mpc: 9d920-9dc84
init_memory_mapping: 0000000000000000-00000000bff4b000
init_memory_mapping: 0000000100000000-0000000840000000
RAMDISK: 37d4d000 - 37fef9e3
ACPI: RSDP 000000000009bde0 00014 (v00 M   IB)
ACPI: RSDT 00000000bff57ac0 00044 (v01 IBM    EXA01ZEU 00001000 IBM  45444F43)
ACPI: FACP 00000000bff57900 000F4 (v03 IBM    EXA01ZEU 00001000 IBM  45444F43)
ACPI: DSDT 00000000bff4b480 021B5 (v01 IBM    EXA01ZEU 00001000 INTL 20060707)
ACPI: FACS 00000000bff53780 00040
ACPI: APIC 00000000bff57800 000F4 (v01 IBM    EXA01ZEU 00001000 IBM  45444F43)
ACPI: SRAT 00000000bff57700 00100 (v01 IBM    EXA01ZEU 00001000 IBM  45444F43)
ACPI: HPET 00000000bff576c0 00038 (v01 IBM    EXA01ZEU 00001000 IBM  45444F43)
ACPI: TCPA 00000000bff57640 00064 (v02 IBM    EXA01ZEU 00001000 IBM  45444F43)
ACPI: MCFG 00000000bff57600 0003C (v01 IBM    EXA01ZEU 00001000 IBM  45444F43)
ACPI: ERST 00000000bff537c0 00230 (v01 IBM    EXA01ZEU 00001000 IBM  45444F43)
ACPI: SSDT 00000000bff4d640 05686 (v01 IBM    VIGSSDT0 00001000 INTL 20060707)
SRAT: PXM 0 -> APIC 0x0c -> Node 0
SRAT: PXM 0 -> APIC 0x10 -> Node 0
SRAT: PXM 0 -> APIC 0x0d -> Node 0
SRAT: PXM 0 -> APIC 0x11 -> Node 0
SRAT: PXM 0 -> APIC 0x0e -> Node 0
SRAT: PXM 0 -> APIC 0x12 -> Node 0
SRAT: PXM 0 -> APIC 0x0f -> Node 0
SRAT: PXM 0 -> APIC 0x13 -> Node 0
SRAT: Node 0 PXM 0 0-c0000000
SRAT: Node 0 PXM 0 100000000-840000000
Bootmem setup node 0 0000000000000000-0000000840000000
  NODE_DATA [0000000000028000 - 000000000002efff]
  bootmap [0000000000100000 -  0000000000207fff] pages 108
(13 early reservations) ==> bootmem [0000000000 - 0840000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0001000000 - 0001d4b2b0]    TEXT DATA BSS ==> [0001000000 - 0001d4b2b0]
  #2 [0037d4d000 - 0037fef9e3]          RAMDISK ==> [0037d4d000 - 0037fef9e3]
  #3 [0001d4c000 - 0001d4c350]              BRK ==> [0001d4c000 - 0001d4c350]
  #4 [000009bc00 - 000009bd40]    BIOS reserved ==> [000009bc00 - 000009bd40]
  #5 [000009bd40 - 000009bd50]     MP-table mpf ==> [000009bd40 - 000009bd50]
  #6 [000009bd50 - 000009d920]    BIOS reserved ==> [000009bd50 - 000009d920]
  #7 [000009dc84 - 0000100000]    BIOS reserved ==> [000009dc84 - 0000100000]
  #8 [000009d920 - 000009dc84]     MP-table mpc ==> [000009d920 - 000009dc84]
  #9 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
  #10 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
  #11 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
  #12 [000000b000 - 0000028000]          PGTABLE ==> [000000b000 - 0000028000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00840000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009b
    0: 0x00000100 -> 0x000bff4b
    0: 0x00100000 -> 0x00840000
ACPI: PM-Timer IO Port: 0x588
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x0c] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x0d] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x11] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x0e] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0f] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x13] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 15, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x10] address[0xfecff000] gsi_base[24])
IOAPIC[1]: apic_id 16, version 17, address 0xfecff000, GSI 24-26
ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[27])
IOAPIC[2]: apic_id 14, version 17, address 0xfec01000, GSI 27-62
ACPI: IOAPIC (id[0x0d] address[0xfec02000] gsi_base[63])
IOAPIC[3]: apic_id 13, version 17, address 0xfec02000, GSI 63-98
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 8 global_irq 8 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10142201 base: 0xfde84000
SMP: Allowing 8 CPUs, 0 hotplug CPUs
mapped APIC to ffffffffff5fc000 (fee00000)
mapped IOAPIC to ffffffffff5fb000 (fec00000)
mapped IOAPIC to ffffffffff5fa000 (fecff000)
mapped IOAPIC to ffffffffff5f9000 (fec01000)
mapped IOAPIC to ffffffffff5f8000 (fec02000)
Allocating PCI resources starting at e0000000 (gap: e0000000:1ec00000)
setup_percpu: NR_CPUS:255 nr_cpumask_bits:255 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 27 pages/cpu @ffff880028200000 s80280 r8192 d22120 u262144
pcpu-alloc: s80280 r8192 d22120 u262144 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8269916
Policy zone: Normal
Kernel command line: ro root=LABEL=/ rhgb console=tty0 console=ttyS0,9600n1 apic=debug
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Memory: 33010860k/34603008k available (3066k kernel code, 1049704k absent, 542444k reserved, 5027k data, 476k init)
Hierarchical RCU implementation.
NR_IRQS:4352
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Fast TSC calibration using PIT
Detected 2931.853 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5863.70 BogoMIPS (lpj=2931853)
Security Framework initialized
SELinux:  Initializing.
Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Performance Events: Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
ACPI: Core revision 20091214
Setting APIC routing to flat
Getting VERSION: 50014
Getting VERSION: 50014
Getting ID: c000000
Getting ID: f3000000
Getting LVT0: 700
Getting LVT1: 400
enabled ExtINT on CPU#0
ESR value before enabling vector: 0x00000040  after: 0x00000000
ENABLING IO-APIC IRQs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz stepping 0b
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1665619
... PM-Timer delta = 357899
... PM-Timer result ok
..... delta 1665619
..... mult: 71548666
..... calibration result: 266499
..... CPU clock speed is 2931.0489 MHz.
..... host bus clock speed is 266.0499 MHz.
Booting Node   0, Processors  #1masked ExtINT on CPU#1
 #2masked ExtINT on CPU#2
 #3masked ExtINT on CPU#3
 #4masked ExtINT on CPU#4
 #5masked ExtINT on CPU#5
 #6masked ExtINT on CPU#6
 #7 Ok.
masked ExtINT on CPU#7
Brought up 8 CPUs
Total of 8 processors activated (46905.61 BogoMIPS).

