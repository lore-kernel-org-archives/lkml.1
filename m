Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZFEJda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZFEJda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZFEJdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:33:13 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:35910 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbZFEJcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:32:55 -0400
Message-ID: <4A28E5C9.6010408@oracle.com>
Date: Fri, 05 Jun 2009 17:30:49 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
  2.6.30-rc8.
References: <4A289928.7040508@oracle.com>	<20090604223805.2962e826.akpm@linux-foundation.org>	<4A28C262.5020605@oracle.com>	<20090605075614.GC8171@cr0.nay.redhat.com>	<4A28DDEB.4000409@oracle.com>	<2375c9f90906050209h191df8fav36fc9507654c5ca6@mail.gmail.com> <20090605021424.ba352b0f.akpm@linux-foundation.org>
In-Reply-To: <20090605021424.ba352b0f.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------060800030607040101040408"
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A28E5D0.00E9:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060800030607040101040408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Andrew Morton wrote:
> On Fri, 5 Jun 2009 17:09:54 +0800 Am__rico Wang <xiyou.wangcong@gmail.com> wrote:
> 
>> On Fri, Jun 5, 2009 at 4:57 PM, Tao Ma<tao.ma@oracle.com> wrote:
>>>
>>> Amerigo Wang wrote:
>>>> On Fri, Jun 05, 2009 at 02:59:46PM +0800, Tao Ma wrote:
>>>>> Andrew Morton wrote:
>>>>>> On Fri, 05 Jun 2009 12:03:52 +0800 Tao Ma <tao.ma@oracle.com> wrote:
>>>>>>
>>>>>>> Hi list,
>>>>>>> __ __ __ In 2.6.30-rc8, /proc/kcore in x86_64's size is unreasonable large
>>>>>>> to be 281474974617600.
>>>>>>> While in a x86 box, it is 931131392 which looks sane.
>>>>>>>
>>>>>>> [root@test8 ~]# ll /proc/kcore
>>>>>>> -r-------- 1 root root 281474974617600 Jun __5 11:15 /proc/kcore
>>>>>>>
>>>>>>> [root@ocfs2-test9 ~]$ ll /proc/kcore
>>>>>>> -r-------- 1 root root 931131392 Jun __5 11:58 /proc/kcore
>>>>>>>
>>>>>>> I just noticed this when kexec fails in "Can't find kernel text map
>>>>>>> area from kcore".
>>>>>>>
>>>>>>> Is there something wrong?
>>>>>>>
>>>>>> fs/proc/kcore.c hasn't changed since October last year. __Was 2.6.29 OK?
>>>>>> Earlier kernels?
>>>>> with 2.6.29, ls shows the same output.
>>>>> [root@test8 ~]# ll /proc/kcore
>>>>> -r-------- 1 root root 281474974617600 Jun __5 14:35 /proc/kcore
>>>>
>>>> Thanks.
>>>>
>>>> It looks like the value of 'high_memory' is insane..
>>>> Can you get its value on your machine? You can add a printk() or use
>>>> systemtap etc..
>>> Just did that.
>>> Also a strange number.
>>> high memory 18446612137615818752.
>>>
> 
> (top-posting repaired)
> 
>> Add some Cc: to x86 people. :)
>>
>> Yinghai?
>>
> 
> Please send the boot logs: dmesg -s 1000000 > foo
attached.

Thanks.
Tao

--------------060800030607040101040408
Content-Type: text/plain;
 name="foo"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="foo"

Linux version 2.6.30-rc4 (test2.cn.oracle.com) (gcc version 4.1.2 20070626 (Red Hat 4.1.2-14)) #3 SMP Fri Jun 5 14:14:28 CST 2009
Command line: ro root=LABEL=/var rhgb quiet crashkernel=128M@16M
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf5ffc00 (usable)
 BIOS-e820: 00000000bf5ffc00 - 00000000bf601c00 (ACPI NVS)
 BIOS-e820: 00000000bf603c00 - 00000000bf653c00 (reserved)
 BIOS-e820: 00000000bf653c00 - 00000000bf655c00 (ACPI data)
 BIOS-e820: 00000000bf655c00 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
DMI 2.3 present.
last_pfn = 0x13c000 max_arch_pfn = 0x100000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask 000000000 write-back
  1 base 0BF800000 mask FFF800000 uncachable
  2 base 0BF700000 mask FFFF00000 uncachable
  3 base 0C0000000 mask FC0000000 uncachable
  4 disabled
  5 disabled
  6 disabled
  7 disabled
e820 update range: 00000000bf700000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbf5ff max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-00000000bf5ff000
 0000000000 - 00bf400000 page 2M
 00bf400000 - 00bf5ff000 page 4k
kernel direct mapping tables up to bf5ff000 @ 8000-d000
init_memory_mapping: 0000000100000000-000000013c000000
 0100000000 - 013c000000 page 2M
kernel direct mapping tables up to 13c000000 @ b000-11000
RAMDISK: 37d94000 - 37fef752
ACPI: RSDP 00000000000febf0 00024 (v02 DELL  )
ACPI: XSDT 00000000000fce99 0006C (v01 DELL    B8K     00000014 ASL  00000061)
ACPI: FACP 00000000000fcfc1 000F4 (v03 DELL    B8K     00000014 ASL  00000061)
ACPI: DSDT 00000000fff6a119 0473C (v01   DELL    dt_ex 00001000 INTL 20050624)
ACPI: FACS 00000000bf5ffc00 00040
ACPI: SSDT 00000000fff6e974 000AA (v01   DELL    st_ex 00001000 INTL 20050624)
ACPI: APIC 00000000000fd0b5 00092 (v01 DELL    B8K     00000014 ASL  00000061)
ACPI: BOOT 00000000000fd147 00028 (v01 DELL    B8K     00000014 ASL  00000061)
ACPI: ASF! 00000000000fd16f 00092 (v32 DELL    B8K     00000014 ASL  00000061)
ACPI: MCFG 00000000000fd201 0003E (v01 DELL    B8K     00000014 ASL  00000061)
ACPI: HPET 00000000000fd23f 00038 (v01 DELL    B8K     00000014 ASL  00000061)
ACPI: TCPA 00000000000fd49b 00032 (v01 DELL    B8K     00000014 ASL  00000061)
ACPI: SLIC 00000000000fd277 00176 (v01 DELL    B8K     00000014 ASL  00000061)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-000000013c000000
Bootmem setup node 0 0000000000000000-000000013c000000
  NODE_DATA [000000000000c000 - 0000000000011fff]
  bootmap [0000000000012000 -  00000000000397ff] pages 28
(8 early reservations) ==> bootmem [0000000000 - 013c000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000d065d0]    TEXT DATA BSS ==> [0000200000 - 0000d065d0]
  #3 [0037d94000 - 0037fef752]          RAMDISK ==> [0037d94000 - 0037fef752]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [0000d07000 - 0000d07234]              BRK ==> [0000d07000 - 0000d07234]
  #6 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
  #7 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]
found SMP MP-table at [ffff8800000fe710] fe710
Reserving 128MB of memory at 16MB for crashkernel (System RAM: 5056MB)
 [ffffe20000000000-ffffe200045fffff] PMD -> [ffff880028200000-ffff88002b9fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x0013c000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x000bf5ff
    0: 0x00100000 -> 0x0013c000
On node 0 totalpages: 1029534
  DMA zone: 56 pages used for memmap
  DMA zone: 2925 pages reserved
  DMA zone: 1018 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 765495 pages, LIFO batch:31
  Normal zone: 3360 pages used for memmap
  Normal zone: 242400 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x01] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 8 CPUs, 6 hotplug CPUs
nr_irqs_gsi: 24
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
NR_CPUS:255 nr_cpumask_bits:255 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 24 pages at ffff880028104000, static data 69536 bytes
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1008913
Policy zone: Normal
Kernel command line: ro root=LABEL=/var rhgb quiet crashkernel=128M@16M
Initializing CPU#0
NR_IRQS:4352
PID hash table entries: 4096 (order: 12, 32768 bytes)
Fast TSC calibration using PIT
Detected 2128.021 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
No AGP bridge found
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
software IO TLB at phys 0x20000000 - 0x24000000
Memory: 3848804k/5177344k available (2801k kernel code, 1059208k absent, 269332k reserved, 1965k data, 396k init)
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 4256.04 BogoMIPS (lpj=2128021)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 0/0x0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20090320
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4255.80 BogoMIPS (lpj=2127902)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
CPU1: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (8511.84 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
net_namespace: 1736 bytes
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI Warning (tbutils-0246): Incorrect checksum in table [TCPA] - 00, should be 89 [20090320]
ACPI: ACPI Dock Station Driver: 1 docks/bays found
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:02.0: reg 10 32bit mmio: [0xdfe00000-0xdfefffff]
pci 0000:00:02.0: reg 18 64bit mmio: [0xc0000000-0xcfffffff]
pci 0000:00:02.0: reg 20 io port: [0xecb8-0xecbf]
pci 0000:00:02.1: reg 10 32bit mmio: [0xdff00000-0xdfffffff]
pci 0000:00:1a.0: reg 20 io port: [0xff20-0xff3f]
pci 0000:00:1a.1: reg 20 io port: [0xff00-0xff1f]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xdfdfbc00-0xdfdfbfff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xdfdfc000-0xdfdfffff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0xff80-0xff9f]
pci 0000:00:1d.1: reg 20 io port: [0xff60-0xff7f]
pci 0000:00:1d.2: reg 20 io port: [0xff40-0xff5f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xff980800-0xff980bff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0880-08bf claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (mask 0007)
pci 0000:00:1f.2: reg 10 io port: [0xfe00-0xfe07]
pci 0000:00:1f.2: reg 14 io port: [0xfe10-0xfe13]
pci 0000:00:1f.2: reg 18 io port: [0xfe20-0xfe27]
pci 0000:00:1f.2: reg 1c io port: [0xfe30-0xfe33]
pci 0000:00:1f.2: reg 20 io port: [0xfec0-0xfecf]
pci 0000:00:1f.2: reg 24 io port: [0xecc0-0xeccf]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10 32bit mmio: [0xdfdfbb00-0xdfdfbbff]
pci 0000:00:1f.3: reg 20 io port: [0xece0-0xecff]
pci 0000:00:1f.5: reg 10 io port: [0xfe40-0xfe47]
pci 0000:00:1f.5: reg 14 io port: [0xfe50-0xfe53]
pci 0000:00:1f.5: reg 18 io port: [0xfe60-0xfe67]
pci 0000:00:1f.5: reg 1c io port: [0xfe70-0xfe73]
pci 0000:00:1f.5: reg 20 io port: [0xfed0-0xfedf]
pci 0000:00:1f.5: reg 24 io port: [0xecd0-0xecdf]
pci 0000:00:1f.5: PME# supported from D3hot
pci 0000:00:1f.5: PME# disabled
pci 0000:00:01.0: bridge 32bit mmio: [0xdfc00000-0xdfcfffff]
pci 0000:00:1c.0: bridge 32bit mmio: [0xdfb00000-0xdfbfffff]
pci 0000:03:00.0: reg 10 64bit mmio: [0xdfaf0000-0xdfafffff]
pci 0000:03:00.0: PME# supported from D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:1c.4: bridge 32bit mmio: [0xdfa00000-0xdfafffff]
pci 0000:04:00.0: reg 10 32bit mmio: [0xdf880000-0xdf89ffff]
pci 0000:04:00.0: reg 14 32bit mmio: [0xdf8a0000-0xdf8bffff]
pci 0000:04:00.0: reg 18 io port: [0xdc80-0xdcbf]
pci 0000:04:00.0: reg 30 32bit mmio: [0xdf900000-0xdf91ffff]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:04:02.0: reg 10 32bit mmio: [0xdf8c0000-0xdf8dffff]
pci 0000:04:02.0: reg 14 32bit mmio: [0xdf8e0000-0xdf8fffff]
pci 0000:04:02.0: reg 18 io port: [0xdcc0-0xdcff]
pci 0000:04:02.0: reg 30 32bit mmio: [0xdf900000-0xdf91ffff]
pci 0000:04:02.0: PME# supported from D0 D3hot D3cold
pci 0000:04:02.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xd000-0xdfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xdf800000-0xdf9fffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI5._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 15)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:01: io resource (0x800-0x85f) overlaps 0000:00:1f.0 BAR 7 (0x800-0x87f), disabling
pnp 00:01: io resource (0x860-0x8ff) overlaps 0000:00:1f.0 BAR 7 (0x800-0x87f), disabling
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0xc00-0xc7f has been reserved
system 00:08: iomem range 0x0-0x9ffff could not be reserved
system 00:08: iomem range 0x100000-0xffffff could not be reserved
system 00:08: iomem range 0x1000000-0xbf5ffbff could not be reserved
system 00:08: iomem range 0xf0000-0xfffff could not be reserved
system 00:08: iomem range 0xc0000-0xcffff has been reserved
system 00:08: iomem range 0xfec00000-0xfecfffff has been reserved
system 00:08: iomem range 0xfee00000-0xfeefffff has been reserved
system 00:08: iomem range 0xffb00000-0xffbfffff has been reserved
system 00:08: iomem range 0xffc00000-0xffffffff has been reserved
system 00:09: ioport range 0x100-0x1fe has been reserved
system 00:09: ioport range 0x200-0x277 has been reserved
system 00:09: ioport range 0x280-0x2e7 has been reserved
system 00:09: ioport range 0x2f0-0x2f7 has been reserved
system 00:09: ioport range 0x300-0x377 has been reserved
system 00:09: ioport range 0x380-0x3bb has been reserved
system 00:09: ioport range 0x3c0-0x3e7 could not be reserved
system 00:09: ioport range 0x3f6-0x3f7 has been reserved
system 00:09: ioport range 0x400-0x4cf has been reserved
system 00:09: ioport range 0x4d2-0x57f has been reserved
system 00:09: ioport range 0x580-0x677 has been reserved
system 00:09: ioport range 0x680-0x777 has been reserved
system 00:09: ioport range 0x780-0x7bb has been reserved
system 00:09: ioport range 0x7c0-0x7ff has been reserved
system 00:09: ioport range 0x8e0-0x8ff has been reserved
system 00:09: ioport range 0x900-0x9fe has been reserved
system 00:09: ioport range 0xa00-0xafe has been reserved
system 00:09: ioport range 0xb00-0xbfe has been reserved
system 00:09: ioport range 0xc80-0xcaf has been reserved
system 00:09: ioport range 0xcc0-0xcf7 has been reserved
system 00:09: ioport range 0xd00-0xdfe has been reserved
system 00:09: ioport range 0xe00-0xefe has been reserved
system 00:09: ioport range 0xf00-0xffe has been reserved
system 00:09: ioport range 0x2000-0x20fe has been reserved
system 00:09: ioport range 0x2100-0x21fe has been reserved
system 00:09: ioport range 0x2200-0x22fe has been reserved
system 00:09: ioport range 0x2300-0x23fe has been reserved
system 00:09: ioport range 0x2400-0x24fe has been reserved
system 00:09: ioport range 0x2500-0x25fe has been reserved
system 00:09: ioport range 0x2600-0x26fe has been reserved
system 00:09: ioport range 0x2700-0x27fe has been reserved
system 00:09: ioport range 0x2800-0x28fe has been reserved
system 00:09: ioport range 0x2900-0x29fe has been reserved
system 00:09: ioport range 0x2a00-0x2afe has been reserved
system 00:09: ioport range 0x2b00-0x2bfe has been reserved
system 00:09: ioport range 0x2c00-0x2cfe has been reserved
system 00:09: ioport range 0x2d00-0x2dfe has been reserved
system 00:09: ioport range 0x2e00-0x2efe has been reserved
system 00:09: ioport range 0x2f00-0x2ffe has been reserved
system 00:09: ioport range 0x5000-0x50fe has been reserved
system 00:09: ioport range 0x5100-0x51fe has been reserved
system 00:09: ioport range 0x5200-0x52fe has been reserved
system 00:09: ioport range 0x5300-0x53fe has been reserved
system 00:09: ioport range 0x5400-0x54fe has been reserved
system 00:09: ioport range 0x5500-0x55fe has been reserved
system 00:09: ioport range 0x5600-0x56fe has been reserved
system 00:09: ioport range 0x5700-0x57fe has been reserved
system 00:09: ioport range 0x5800-0x58fe has been reserved
system 00:09: ioport range 0x5900-0x59fe has been reserved
system 00:09: ioport range 0x5a00-0x5afe has been reserved
system 00:09: ioport range 0x5b00-0x5bfe has been reserved
system 00:09: ioport range 0x5c00-0x5cfe has been reserved
system 00:09: ioport range 0x5d00-0x5dfe has been reserved
system 00:09: ioport range 0x5e00-0x5efe has been reserved
system 00:09: ioport range 0x5f00-0x5ffe has been reserved
system 00:09: ioport range 0x6000-0x60fe has been reserved
system 00:09: ioport range 0x6100-0x61fe has been reserved
system 00:09: ioport range 0x6200-0x62fe has been reserved
system 00:09: ioport range 0x6300-0x63fe has been reserved
system 00:09: ioport range 0x6400-0x64fe has been reserved
system 00:09: ioport range 0x6500-0x65fe has been reserved
system 00:09: ioport range 0x6600-0x66fe has been reserved
system 00:09: ioport range 0x6700-0x67fe has been reserved
system 00:09: ioport range 0x6800-0x68fe has been reserved
system 00:09: ioport range 0x6900-0x69fe has been reserved
system 00:09: ioport range 0x6a00-0x6afe has been reserved
system 00:09: ioport range 0x6b00-0x6bfe has been reserved
system 00:09: ioport range 0x6c00-0x6cfe has been reserved
system 00:09: ioport range 0x6d00-0x6dfe has been reserved
system 00:09: ioport range 0x6e00-0x6efe has been reserved
system 00:09: ioport range 0x6f00-0x6ffe has been reserved
system 00:09: ioport range 0xa000-0xa0fe has been reserved
system 00:09: ioport range 0xa100-0xa1fe has been reserved
system 00:09: ioport range 0xa200-0xa2fe has been reserved
system 00:09: ioport range 0xa300-0xa3fe has been reserved
system 00:09: ioport range 0xa400-0xa4fe has been reserved
system 00:09: ioport range 0xa500-0xa5fe has been reserved
system 00:09: ioport range 0xa600-0xa6fe has been reserved
system 00:09: ioport range 0xa700-0xa7fe has been reserved
system 00:09: ioport range 0xa800-0xa8fe has been reserved
system 00:09: ioport range 0xa900-0xa9fe has been reserved
system 00:09: ioport range 0xaa00-0xaafe has been reserved
system 00:09: ioport range 0xab00-0xabfe has been reserved
system 00:09: ioport range 0xac00-0xacfe has been reserved
system 00:09: ioport range 0xad00-0xadfe has been reserved
system 00:09: ioport range 0xae00-0xaefe has been reserved
system 00:09: ioport range 0xaf00-0xaffe has been reserved
system 00:09: iomem range 0xe0000000-0xefffffff has been reserved
system 00:09: iomem range 0xfeda0000-0xfedacfff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: 0xdfc00000-0xdfcfffff
pci 0000:00:01.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: 0xdfb00000-0xdfbfffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.4:   IO window: disabled
pci 0000:00:1c.4:   MEM window: 0xdfa00000-0xdfafffff
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
pci 0000:00:1e.0:   IO window: 0xd000-0xdfff
pci 0000:00:1e.0:   MEM window: 0xdf800000-0xdf9fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000d0000000-0x000000d00fffff
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 1 mem: [0xdfc00000-0xdfcfffff]
pci_bus 0000:02: resource 1 mem: [0xdfb00000-0xdfbfffff]
pci_bus 0000:03: resource 1 mem: [0xdfa00000-0xdfafffff]
pci_bus 0000:04: resource 0 io:  [0xd000-0xdfff]
pci_bus 0000:04: resource 1 mem: [0xdf800000-0xdf9fffff]
pci_bus 0000:04: resource 2 pref mem [0xd0000000-0xd00fffff]
pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...
rootfs image is initramfs; unpacking...
Freeing initrd memory: 2413k freed
Simple Boot Flag at 0x7a set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1244191610.804:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
#######high memory 18446612137615818752, size_t 18446612137615818752
#######kcore size 5301604352, PAGE_OFFSET 0, PAGE_SIZE 4096
msgmni has been set to 7521
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.4: irq 26 for MSI/MSI-X
pcieport-driver 0000:00:1c.4: setting latency timer to 64
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Marking TSC unstable due to TSC halts in idle
processor ACPI_CPU:00: registered as cooling_device0
processor ACPI_CPU:01: registered as cooling_device1
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 965Q Chipset
agpgart-intel 0000:00:00.0: detected 7676K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
Uniform Multi-Platform E-IDE driver
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
Probing IDE interface ide0...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
ide1 at 0x170-0x177,0x376 on irq 15
ide-gd driver 1.18
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
Freeing unused kernel memory: 396k freed
Write protecting the kernel read-only data: 3968k
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff20
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000ff00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000ff80
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000ff60
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 22, io mem 0xdfdfbc00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff980800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0xfe00 ctl 0xfe10 bmdma 0xfec0 irq 20
ata2: SATA max UDMA/133 cmd 0xfe20 ctl 0xfe30 bmdma 0xfec8 irq 20
ata_piix 0000:00:1f.5: PCI INT C -> GSI 20 (level, low) -> IRQ 20
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
ata_piix 0000:00:1f.5: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0xfe40 ctl 0xfe50 bmdma 0xfed0 irq 20
ata4: SATA max UDMA/133 cmd 0xfe60 ctl 0xfe70 bmdma 0xfed8 irq 20
usb 2-2: new low speed USB device using uhci_hcd and address 2
usb 2-2: configuration #1 chosen from 1 choice
input: Dell Dell USB Keyboard as /class/input/input0
generic-usb 0003:413C:2003.0001: input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1a.1-2/input0
ata3: SATA link down (SStatus 0 SControl 300)
ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.01: SATA link down (SStatus 4 SControl 300)
ata1.00: ATA-7: ST3250820AS, 3.ADG, max UDMA/133
ata1.00: 488281250 sectors, multi 8: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST3250820AS      3.AD PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 488281250 512-byte hardware sectors: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk
ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.01: SATA link down (SStatus 4 SControl 300)
ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-H653A, D500, max UDMA/33
ata2.00: applying bridge limits
ata2.00: configured for UDMA/33
scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-H653A D500 PQ: 0 ANSI: 5
ata4: SATA link down (SStatus 0 SControl 300)
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
type=1404 audit(1244191617.685:2): selinux=0 auid=4294967295 ses=4294967295
input: PC Speaker as /class/input/input1
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 20 (level, low) -> IRQ 20
Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000: 0000:04:00.0: e1000_probe: (PCI:33MHz:32-bit) 00:1b:21:06:27:78
input: Power Button as /class/input/input2
ACPI: Power Button [PWRF]
input: Power Button as /class/input/input3
ACPI: Power Button [VBTN]
parport_pc 00:06: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000 0000:04:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
e1000: 0000:04:02.0: e1000_probe: (PCI:33MHz:32-bit) 00:0e:0c:dc:ed:53
rtc_cmos 00:05: RTC can wake from S4
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
tg3.c:v3.98 (February 25, 2009)
tg3 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
tg3 0000:03:00.0: setting latency timer to 64
tg3 0000:03:00.0: PME# disabled
eth1: Tigon3 [partno(BCM95754) rev b002] (PCI Express) MAC address 00:1a:a0:af:d1:f5
eth1: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1])
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
eth1: dma_rwctrl[76180000] dma_mask[64-bit]
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
HDA Intel 0000:00:1b.0: setting latency timer to 64
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
Floppy drive(s): fd0 is 1.44M
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
floppy0: no floppy controllers found
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
lp0: using parport0 (interrupt-driven).
lp0: console ready
ramfs: bad mount option: maxsize=512
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda6, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
Adding 8193140k swap on /dev/sda3.  Priority:-1 extents:1 across:8193140k 
platform microcode: firmware: requesting intel-ucode/06-0f-02
platform microcode: firmware: requesting intel-ucode/06-0f-02
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Microcode Update Driver: v2.00 removed.
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
Loading iSCSI transport class v2.0-870.
iscsi: registered transport (tcp)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
iscsi: registered transport (iser)
e1000: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
ADDRCONF(NETDEV_UP): eth0: link is not ready
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
e1000: eth1 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
ADDRCONF(NETDEV_UP): eth1: link is not ready
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
tg3 0000:03:00.0: PME# disabled
tg3 0000:03:00.0: irq 27 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth2: link is not ready
tg3: eth2: Link is up at 100 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
eth0: no IPv6 routers present
warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
OCFS2 Node Manager 1.5.0
OCFS2 DLM 1.5.0
ocfs2: Registered cluster interface o2cb
OCFS2 DLMFS 1.5.0
OCFS2 User DLM kernel interface loaded
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.13
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
eth1: no IPv6 routers present
Bridge firewalling registered
ip_tables: (C) 2000-2006 Netfilter Core Team
eth2: no IPv6 routers present
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
[drm] MTRR allocation failed.  Graphics performance may suffer.
pci 0000:00:02.0: irq 28 for MSI/MSI-X
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining

--------------060800030607040101040408--
