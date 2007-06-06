Return-Path: <linux-kernel-owner+w=401wt.eu-S1759027AbXFFQgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027AbXFFQgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbXFFQgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:36:43 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:40896 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbXFFQgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:36:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:mime-version:content-transfer-encoding:message-id:content-type:to:subject:date:x-mailer:from;
        b=mGLXFKC9LCKdJNfmESRTWhexbEzVfm+krQ74vzTfQvY0BkrlirfQ/6xWZ0CnbUf1wGVtHN/1Rjk3vCUWSObblluwwhTvpV5vsO3OseVxaXL6KJTEi6Ys0IEaf5n7Wq9XlBUVo2iE4IkI7qtmo0a/6WfxsvGM2eD6ytAKhSdE+yQ=
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Transfer-Encoding: 7bit
Message-Id: <8076BF28-4780-4248-88E0-3CE3CD6D0CEE@gmail.com>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: X86 SMP cpu enumeration changes
Date: Wed, 6 Jun 2007 11:36:36 -0500
X-Mailer: Apple Mail (2.752.2)
From: Mark Rustad <mrustad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There seems to have been a change in SMP cpu enumeration sometime  
before 2.6.16. I have also tried 2.6.19 and it also exhibits the  
"new" behavior. It used to be that setting maxcpus to the number of  
physical cpus would effectively prevent the use of hyperthreading. In  
fact in arch/i386/kernel/mpparse.c is the following comment:

/*
  * If the BIOS enumerates physical processors before logical,
  * maxcpus=N at enumeration-time can be used to disable HT.
  */

Interestingly, the boot messages seem to show that it is behaving  
correctly:

Linux version 2.6.19.7-3d3000-2 (mdr@wookieebuildpc) (gcc version  
3.3.3 (SuSE Linux)) #1 SMP PREEMPT Tue Apr 24 11:36:00 CDT 2007
BIOS-provided physical RAM map:
BIOS-e820: 0000000000000000 - 000000000009a000 (usable)
BIOS-e820: 000000000009a000 - 00000000000a0000 (reserved)
BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
BIOS-e820: 0000000000100000 - 000000003ff70000 (usable)
BIOS-e820: 000000003ff70000 - 000000003ff78000 (ACPI data)
BIOS-e820: 000000003ff78000 - 000000003ff80000 (ACPI NVS)
BIOS-e820: 000000003ff80000 - 0000000040000000 (reserved)
BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
BIOS-e820: 00000000fffffc00 - 0000000100000000 (reserved)
1023MB LOWMEM available.
found SMP MP-table at 000f6860
Entering add_active_range(0, 0, 262000) 0 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   262000
early_node_map[1] active PFN ranges
     0:        0 ->   262000
On node 0 totalpages: 262000
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 4064 pages, LIFO batch:0
   Normal zone: 2014 pages used for memmap
   Normal zone: 255890 pages, LIFO batch:31
DMI present.
Using APIC driver default
ACPI: RSDP (v000 PTLTD                                 ) @ 0x000f68c0
ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000) @  
0x3ff73a8f
ACPI: FADT (v001 INTEL  LINDHRST 0x06040000 PTL  0x00000003) @  
0x3ff77e20
ACPI: MADT (v001 PTLTD           APIC   0x06040000  LTP 0x00000000) @  
0x3ff77e94
mdr@wookieebuildpc:~/cpus> cat 19.dmesg
Linux version 2.6.19.7-3d3000-2 (mdr@wookieebuildpc) (gcc version  
3.3.3 (SuSE Linux)) #1 SMP PREEMPT Tue Apr 24 11:36:00 CDT 2007
BIOS-provided physical RAM map:
BIOS-e820: 0000000000000000 - 000000000009a000 (usable)
BIOS-e820: 000000000009a000 - 00000000000a0000 (reserved)
BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
BIOS-e820: 0000000000100000 - 000000003ff70000 (usable)
BIOS-e820: 000000003ff70000 - 000000003ff78000 (ACPI data)
BIOS-e820: 000000003ff78000 - 000000003ff80000 (ACPI NVS)
BIOS-e820: 000000003ff80000 - 0000000040000000 (reserved)
BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
BIOS-e820: 00000000fffffc00 - 0000000100000000 (reserved)
1023MB LOWMEM available.
found SMP MP-table at 000f6860
Entering add_active_range(0, 0, 262000) 0 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   262000
early_node_map[1] active PFN ranges
     0:        0 ->   262000
On node 0 totalpages: 262000
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 4064 pages, LIFO batch:0
   Normal zone: 2014 pages used for memmap
   Normal zone: 255890 pages, LIFO batch:31
DMI present.
Using APIC driver default
ACPI: RSDP (v000 PTLTD                                 ) @ 0x000f68c0
ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000) @  
0x3ff73a8f
ACPI: FADT (v001 INTEL  LINDHRST 0x06040000 PTL  0x00000003) @  
0x3ff77e20
ACPI: MADT (v001 PTLTD           APIC   0x06040000  LTP 0x00000000) @  
0x3ff77e94
ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP 0x00000001) @  
0x3ff77f48
ACPI: SPCR (v001 PTLTD  $UCRTBL$ 0x06040000 PTL  0x00000001) @  
0x3ff77f70
ACPI: MCFG (v001 PTLTD           MCFG   0x06040000  LTP 0x00000000) @  
0x3ff77fc0
ACPI: SSDT (v001  PmRef    CpuPm 0x00003000 INTL 0x20030224) @  
0x3ff73acb
ACPI: DSDT (v001  Intel LINDHRST 0x06040000 MSFT 0x0100000e) @  
0x00000000
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:3 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
Processor #6 15:3 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:3 APIC version 20
WARNING: NR_CPUS limit of 2 reached.  Processor ignored.
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
Processor #7 15:3 APIC version 20
WARNING: NR_CPUS limit of 2 reached.  Processor ignored.
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
ACPI: IOAPIC (id[0x04] address[0xfec80400] gsi_base[48])
IOAPIC[2]: apic_id 4, version 32, address 0xfec80400, GSI 48-71
ACPI: IOAPIC (id[0x05] address[0xfec84000] gsi_base[72])
IOAPIC[3]: apic_id 5, version 32, address 0xfec84000, GSI 72-95
ACPI: IOAPIC (id[0x08] address[0xfec84400] gsi_base[96])
IOAPIC[4]: apic_id 8, version 32, address 0xfec84400, GSI 96-119
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 5 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
Detected 3200.170 MHz processor.
Built 1 zonelists.  Total pages: 259954
Kernel command line: root=/dev/md1 dhash_entries=65536  
ihash_entries=32768 thash_entries=32768 rhash_entries=8192  
console=ttyS1,115200n8 console=tty0 hugepages=178 xio3dshm=300m,300m, 
100m
xio3d: mem[0]=314572800
xio3d: mem[1]=314572800
xio3d: mem[2]=104857600
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
mapped IOAPIC to ffffb000 (fec80000)
mapped IOAPIC to ffffa000 (fec80400)
mapped IOAPIC to ffff9000 (fec84000)
mapped IOAPIC to ffff8000 (fec84400)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=b04a1000 soft=b049f000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 1034856k/1048000k available (2492k kernel code, 12620k  
reserved, 914k data, 260k init, 0k highmem)
virtual kernel memory layout:
     fixmap  : 0xfffb6000 - 0xfffff000   ( 292 kB)
     vmalloc : 0xf0800000 - 0xfffb4000   ( 247 MB)
     lowmem  : 0xb0000000 - 0xeff70000   (1023 MB)
       .init : 0xb0459000 - 0xb049a000   ( 260 kB)
       .data : 0xb036f0bf - 0xb0453b8c   ( 914 kB)
       .text : 0xb0100000 - 0xb036f0bf   (2492 kB)
Checking if this processor honours the WP bit even in supervisor  
mode... Ok.
Calibrating delay using timer specific routine.. 6405.00 BogoMIPS  
(lpj=12810008)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20000000 00000000  
00000000 0000441d 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 20000000 00000000 00000180  
0000441d 00000000 00000000
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 16k freed
ACPI: Core revision 20060707
CPU0: Intel(R) Xeon(TM) CPU 3.20GHz stepping 04
Booting processor 1/1 eip 2000
CPU 1 irqstacks, hard=b04a2000 soft=b04a0000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6400.63 BogoMIPS  
(lpj=12801269)
CPU: After generic identify, caps: bfebfbff 20000000 00000000  
00000000 0000441d 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 20000000 00000000 00000180  
0000441d 00000000 00000000
CPU1: Intel(R) Xeon(TM) CPU 3.20GHz stepping 04
Total of 2 processors activated (12805.63 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
migration_cost=44
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
PCI: No mmconfig possible on 8:1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH4 GPIO
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: PXH quirk detected, disabling MSI for SHPC device
Boot video device is 0000:08:01.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0.PXH0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0.PXH1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEY0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEZ0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEZ0.PXH0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEZ0.PXH1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0,  
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 14 15) *0,  
disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 *10 11 14 15)
ACPI: Device [PRT] status [0000000c]: functional but not present;  
setting present
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post  
a report
PCI: Failed to allocate mem resource #9:100000@e0000000 for 0000:01:00.2
PCI: Failed to allocate mem resource #6:80000@e0000000 for 0000:02:02.1
PCI: Bridge: 0000:01:00.0
   IO window: 2000-3fff
   MEM window: dc200000-dc2fffff
   PREFETCH window: df000000-dfffffff
PCI: Bridge: 0000:01:00.2
   IO window: 4000-4fff
   MEM window: dc300000-dc3fffff
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:02.0
   IO window: 2000-4fff
   MEM window: dc100000-dc3fffff
   PREFETCH window: df000000-dfffffff
PCI: Bridge: 0000:00:04.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:05:00.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:05:00.2
   IO window: 5000-5fff
   MEM window: dc500000-dc5fffff
   PREFETCH window: 50000000-500fffff
PCI: Bridge: 0000:00:06.0
   IO window: 5000-5fff
   MEM window: dc400000-dc5fffff
   PREFETCH window: 50000000-500fffff
PCI: Bridge: 0000:00:1e.0
   IO window: 6000-6fff
   MEM window: dc600000-ddffffff
   PREFETCH window: 50100000-501fffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:01:00.0 to 64
PCI: Setting latency timer of device 0000:01:00.2 to 64
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:06.0 to 64
PCI: Setting latency timer of device 0000:05:00.0 to 64
PCI: Setting latency timer of device 0000:05:00.2 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 8192 (order: 3, 32768 bytes)
TCP established hash table entries: 32768 (order: 6, 393216 bytes)
TCP bind hash table entries: 16384 (order: 5, 196608 bytes)
TCP: Hash tables configured (established 32768 bind 16384)
TCP reno registered
Simple Boot Flag at 0x39 set to 0x1
IA-32 Microcode Update Driver: v1.14a <tigran@veritas.com>
Total HugeTLB memory allocated, 178
io scheduler noop registered (default)
PCI: Setting latency timer of device 0000:00:02.0 to 64
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie01]
PCI: Setting latency timer of device 0000:00:04.0 to 64
Allocate Port Service[0000:00:04.0:pcie00]
Allocate Port Service[0000:00:04.0:pcie01]
PCI: Setting latency timer of device 0000:00:06.0 to 64
Allocate Port Service[0000:00:06.0:pcie00]
Allocate Port Service[0000:00:06.0:pcie01]
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - No ACPI _OSC support
aer: probe of 0000:00:02.0:pcie01 failed with error 1
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - No ACPI _OSC support
aer: probe of 0000:00:04.0:pcie01 failed with error 1
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - No ACPI _OSC support
aer: probe of 0000:00:06.0:pcie01 failed with error 1
ACPI: Power Button (FF) [PWRF]
ACPI: Power Button (CM) [PWRB]
ACPI: Getting cpuindex for acpiid 0x1
ACPI: Getting cpuindex for acpiid 0x3

The messages showing that it is ignoring processors #1 and #7 seems  
to indicate that the correct processors are ignored. Yet, after  
booting when I look at /proc/cpuinfo I get:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 3
model name      : Intel(R) Xeon(TM) CPU 3.20GHz
stepping        : 4
cpu MHz         : 3200.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr  
pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm  
pbe lm constant_tsc pni monitor ds_cpl cid xtpr
bogomips        : 6404.95

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 3
model name      : Intel(R) Xeon(TM) CPU 3.20GHz
stepping        : 4
cpu MHz         : 3200.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr  
pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm  
pbe lm constant_tsc pni monitor ds_cpl cid xtpr
bogomips        : 6400.70

and when I fire up some work and lay hands on the cpu heatsinks, only  
one of them warms up, meaning that /proc/cpuinfo is not lying. This  
kernel was built with CONFIG_NR_CPUS=2, so there is no maxcpus= in  
the kernel command line, but I also tried adding that on the off  
chance that it would make a difference, but it did not.

Was this change in behavior intended? If so, I guess the comment  
should be changed and people that were relying on this behavior  
somehow informed. If it was not I guess there is a bug somewhere.

I will be digging further, but I was interested in posing the  
question in any case.

-- 
Mark Rustad, MRustad@gmail.com


