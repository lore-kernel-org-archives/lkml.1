Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbZKOKly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbZKOKly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZKOKly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:41:54 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42126 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbZKOKlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:references:in-reply-to:cc
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=oJf8Yidj85EYxd0gEjhHfVIGnv0zx3WlZ+MD79tx9SchB02RRzAez9VeVYTjE3ihyY
         v2yE3OVT7+8gfrisq+rbp7Bvv5vEb2nVgiRmAewgj/6gUCA20aO9pLm/XqOQwqLPrQQj
         /fbfDYr+vcuNBcU+bMXNRU16Wdf2MOEH5iLn0=
From: Michael <schnitzelkuchen@googlemail.com>
Reply-To: schnitzelkuchen@googlemail.com
To: David Woodhouse <david.woodhouse@intel.com>
Subject: Re: [regression] [drm:i915_gem_execbuffer] *ERROR* Execbuf while wedged
Date: Sun, 15 Nov 2009 11:41:49 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.31; KDE/4.3.3; x86_64; ; )
References: <200911151048.13777.schnitzelkuchen@googlemail.com> <200911151117.34094.schnitzelkuchen@googlemail.com> <1258280722.1496.185.camel@macbook.infradead.org>
In-Reply-To: <1258280722.1496.185.camel@macbook.infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911151141.49508.schnitzelkuchen@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 15 November 2009 11:25:22 schrieben Sie:
> On Sun, 2009-11-15 at 02:17 -0800, Michael wrote:
> > Am Sonntag 15 November 2009 10:55:48 schrieb David Woodhouse:
> > > On Sun, 2009-11-15 at 01:48 -0800, Michael wrote:
> > > > I tried 2.6.32-rc6 with my Dell Inspiron 1525, but the KDM didnt
> > > > display right - It was mostly black with only the cursor displayed.
> > > > Other things which use X dont work with the kernel, too.
> > >
> > > Interesting. Do you actually have an IOMMU, and is it enabled?
> >
> > Well, my CPU is a "Intel(R) Core(TM)2 Duo CPU     T5750  @ 2.00GHz",
> > which doesnt even have Intel VT, so i guess i dont have an IOMMU.
> >
> > My .config for the test kernel says the following:
> >
> > brotscheibe linux-2.6 # grep IOMM .config
> > CONFIG_GART_IOMMU=y
> > # CONFIG_CALGARY_IOMMU is not set
> > # CONFIG_AMD_IOMMU is not set
> > CONFIG_IOMMU_HELPER=y
> > CONFIG_IOMMU_API=y
> > # CONFIG_IOMMU_DEBUG is not set
> > # CONFIG_IOMMU_STRESS is not set
> >
> >
> > I hope that helps,
> > Michael
> 
> It's CONFIG_DMAR I'm looking for. And can you show 'dmesg' when the
> kernel boots?
> 

brotscheibe linux-2.6 # grep DMAR .config
CONFIG_DMAR=y
# CONFIG_DMAR_DEFAULT_ON is not set
# CONFIG_DMAR_BROKEN_GFX_WA is not set
CONFIG_DMAR_FLOPPY_WA=y

and the dmesg after booting:

Linux version 2.6.31-rc5 (root@brotscheibe) (gcc version 4.4.2 (Gentoo 4.4.2 
p1.0) ) #16 SMP PREEMPT Wed Nov 11 16:18:39 CET 2009
Command line: root=/dev/sda2 rootfstype=ext4 i915.modeset=1 resume=/dev/sda3 2                                                   
KERNEL supported cpus:                                                                                                           
  Intel GenuineIntel                                                                                                             
  AMD AuthenticAMD                                                                                                               
  Centaur CentaurHauls                                                                                                           
BIOS-provided physical RAM map:                                                                                                  
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)                                                                         
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)                                                                       
 BIOS-e820: 0000000000100000 - 00000000df66d800 (usable)                                                                         
 BIOS-e820: 00000000df66d800 - 00000000e0000000 (reserved)                                                                       
 BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)                                                                       
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)                                                                       
 BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)                                                                       
 BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)                                                                       
 BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)                                                                       
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)                                                                       
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)                                                                       
 BIOS-e820: 0000000100000000 - 0000000120000000 (usable)                                                                         
DMI 2.4 present.                                                                                                                 
last_pfn = 0x120000 max_arch_pfn = 0x400000000                                                                                   
MTRR default type: uncachable                                                                                                    
MTRR fixed ranges enabled:                                                                                                       
  00000-9FFFF write-back                                                                                                         
  A0000-BFFFF uncachable                                                                                                         
  C0000-CFFFF write-protect                                                                                                      
  D0000-EFFFF uncachable                                                                                                         
  F0000-FFFFF write-protect                                                                                                                                                         
MTRR variable ranges enabled:                                                                                                                                                       
  0 base 000000000 mask F80000000 write-back                                                                                                                                        
  1 base 080000000 mask FC0000000 write-back                                                                                                                                        
  2 base 0C0000000 mask FE0000000 write-back                                                                                                                                        
  3 base 100000000 mask F00000000 write-back                                                                                                                                        
  4 base 0DF800000 mask FFF800000 uncachable                                                                                                                                        
  5 base 0DF700000 mask FFFF00000 uncachable                                                                                                                                        
  6 disabled                                                                                                                                                                        
  7 disabled                                                                                                                                                                        
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106                                                                                                                    
e820 update range: 00000000df700000 - 0000000100000000 (usable) ==> (reserved)                                                                                                      
last_pfn = 0xdf66d max_arch_pfn = 0x400000000                                                                                                                                       
initial memory mapped : 0 - 20000000                                                                                                                                                
init_memory_mapping: 0000000000000000-00000000df66d000                                                                                                                              
 0000000000 - 00df600000 page 2M                                                                                                                                                    
 00df600000 - 00df66d000 page 4k                                                                                                                                                    
kernel direct mapping tables up to df66d000 @ 8000-e000                                                                                                                             
init_memory_mapping: 0000000100000000-0000000120000000                                                                                                                              
 0100000000 - 0120000000 page 2M                                                                                                                                                    
kernel direct mapping tables up to 120000000 @ c000-12000                                                                                                                           
ACPI: RSDP 00000000000fbc60 00024 (v02 DELL  )                                                                                                                                      
ACPI: XSDT 00000000df66f200 00064 (v01 DELL    M08     27D8061B ASL  00000061)                                                                                                      
ACPI: FACP 00000000df66f09c 000F4 (v04 DELL    M08     27D8061B ASL  00000061)                                                                                                      
ACPI: DSDT 00000000df66f800 05477 (v02 INT430 SYSFexxx 00001001 INTL 20050624)                                                                                                      
ACPI: FACS 00000000df67e000 00040                                                                                                                                                   
ACPI: HPET 00000000df66f300 00038 (v01 DELL    M08     00000001 ASL  00000061)                                                                                                      
ACPI: APIC 00000000df66f400 00068 (v01 DELL    M08     27D8061B ASL  00000047)                                                                                                      
ACPI: MCFG 00000000df66f3c0 0003E (v16 DELL    M08     27D8061B ASL  00000061)                                                                                                      
ACPI: SLIC 00000000df66f49c 00024 (v01 DELL    M08     27D8061B ASL  00000061)                                                                                                      
ACPI: OSFR 00000000df66ea00 0002C (v01 DELL    M08     27D8061B ASL  00000061)                                                                                                      
ACPI: BOOT 00000000df66efc0 00028 (v01 DELL    M08     27D8061B ASL  00000061)                                                                                                      
ACPI: SSDT 00000000df66da02 004CC (v01  PmRef    CpuPm 00003000 INTL 20050624)                                                                                                      
ACPI: Local APIC address 0xfee00000                                                                                                                                                 
(7 early reservations) ==> bootmem [0000000000 - 0120000000]                                                                                                                        
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]                                                                                                       
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]                                                                                                       
  #2 [0001000000 - 00016297b4]    TEXT DATA BSS ==> [0001000000 - 00016297b4]                                                                                                       
  #3 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]                                                                                                       
  #4 [000162a000 - 000162a1e8]              BRK ==> [000162a000 - 000162a1e8]                                                                                                       
  #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]                                                                                                       
  #6 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]                                                                                                       
 [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0                                                                                           
Zone PFN ranges:                                                                                                                                                                    
  DMA      0x00000000 -> 0x00001000                                                                                                                                                 
  DMA32    0x00001000 -> 0x00100000                                                                                                                                                 
  Normal   0x00100000 -> 0x00120000                                                                                                                                                 
Movable zone start PFN for each node                                                                                                                                                
early_node_map[3] active PFN ranges                                                                                                                                                 
    0: 0x00000000 -> 0x0000009f                                                                                                                                                     
    0: 0x00000100 -> 0x000df66d                                                                                                                                                     
    0: 0x00100000 -> 0x00120000                                                                                                                                                     
On node 0 totalpages: 1046028                                                                                                                                                       
  DMA zone: 56 pages used for memmap                                                                                                                                                
  DMA zone: 105 pages reserved                                                                                                                                                      
  DMA zone: 3838 pages, LIFO batch:0                                                                                                                                                
  DMA32 zone: 14280 pages used for memmap                                                                                                                                           
  DMA32 zone: 896677 pages, LIFO batch:31                                                                                                                                           
  Normal zone: 1792 pages used for memmap                                                                                                                                           
  Normal zone: 129280 pages, LIFO batch:31                                                                                                                                          
ACPI: PM-Timer IO Port: 0x1008                                                                                                                                                      
ACPI: Local APIC address 0xfee00000                                                                                                                                                 
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)                                                                                                                                  
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)                                                                                                                                  
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])                                                                                                                                 
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])                                                                                                                                 
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])                                                                                                                             
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23                                                                                                                      
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)                                                                                                                            
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)                                                                                                                         
ACPI: IRQ0 used by override.                                                                                                                                                        
ACPI: IRQ2 used by override.                                                                                                                                                        
ACPI: IRQ9 used by override.                                                                                                                                                        
Using ACPI (MADT) for SMP configuration information                                                                                                                                 
ACPI: HPET id: 0x8086a201 base: 0xfed00000                                                                                                                                          
SMP: Allowing 2 CPUs, 0 hotplug CPUs                                                                                                                                                
nr_irqs_gsi: 24                                                                                                                                                                     
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000                                                                                                                   
PM: Registered nosave memory: 00000000000a0000 - 0000000000100000                                                                                                                   
PM: Registered nosave memory: 00000000df66d000 - 00000000df66e000                                                                                                                   
PM: Registered nosave memory: 00000000df66e000 - 00000000e0000000                                                                                                                   
PM: Registered nosave memory: 00000000e0000000 - 00000000f8000000                                                                                                                   
PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000                                                                                                                   
PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000                                                                                                                   
PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000                                                                                                                   
PM: Registered nosave memory: 00000000fec10000 - 00000000fed18000                                                                                                                   
PM: Registered nosave memory: 00000000fed18000 - 00000000fed1c000                                                                                                                   
PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000                                                                                                                   
PM: Registered nosave memory: 00000000fed20000 - 00000000fed90000                                                                                                                   
PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000                                                                                                                   
PM: Registered nosave memory: 00000000feda0000 - 00000000feda6000                                                                                                                   
PM: Registered nosave memory: 00000000feda6000 - 00000000fee00000                                                                                                                   
PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000                                                                                                                   
PM: Registered nosave memory: 00000000fee10000 - 00000000ffe00000                                                                                                                   
PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000                                                                                                                   
Allocating PCI resources starting at e0000000 (gap: e0000000:18000000)                                                                                                              
NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1                                                                                                                              
PERCPU: Embedded 25 pages at ffff88002801f000, static data 71072 bytes                                                                                                              
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1029795                                                                                                        
Kernel command line: root=/dev/sda2 rootfstype=ext4 i915.modeset=1 
resume=/dev/sda3 2                                                                                               
PID hash table entries: 4096 (order: 12, 32768 bytes)                                                                                                                               
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)                                                                                                                  
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)                                                                                                                    
Initializing CPU#0                                                                                                                                                                  
Checking aperture...                                                                                                                                                                
No AGP bridge found                                                                                                                                                                 
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)                                                                                                                           
Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000                                                                                                            
software IO TLB at phys 0x20000000 - 0x24000000                                                                                                                                     
Memory: 4045000k/4718592k available (3716k kernel code, 534480k absent, 
138224k reserved, 1734k data, 364k init)                                                                    
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1                                                                                                             
Hierarchical RCU implementation.                                                                                                                                                    
NR_IRQS:320                                                                                                                                                                         
Extended CMOS year: 2000                                                                                                                                                            
Fast TSC calibration using PIT                                                                                                                                                      
Detected 1994.981 MHz processor.                                                                                                                                                    
Console: colour VGA+ 80x25                                                                                                                                                          
console [tty0] enabled                                                                                                                                                              
hpet clockevent registered                                                                                                                                                          
HPET: 3 timers in total, 0 timers will be used for per-cpu timer                                                                                                                    
Calibrating delay loop (skipped), value calculated using timer frequency.. 
3989.96 BogoMIPS (lpj=1994981)                                                                           
Mount-cache hash table entries: 256                                                                                                                                                 
CPU: L1 I cache: 32K, L1 D cache: 32K                                                                                                                                               
CPU: L2 cache: 2048K                                                                                                                                                                
CPU: Physical Processor ID: 0                                                                                                                                                       
CPU: Processor Core ID: 0                                                                                                                                                           
mce: CPU supports 6 MCE banks                                                                                                                                                       
CPU0: Thermal monitoring enabled (TM2)                                                                                                                                              
using mwait in idle threads.                                                                                                                                                        
ACPI: Core revision 20090521                                                                                                                                                        
Setting APIC routing to flat                                                                                                                                                        
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1                                                                                                                                
CPU0: Intel(R) Core(TM)2 Duo CPU     T5750  @ 2.00GHz stepping 0d                                                                                                                   
Booting processor 1 APIC 0x1 ip 0x6000                                                                                                                                              
Initializing CPU#1                                                                                                                                                                  
Calibrating delay using timer specific routine.. 3989.80 BogoMIPS (lpj=1994902)                                                                                                     
CPU: L1 I cache: 32K, L1 D cache: 32K                                                                                                                                               
CPU: L2 cache: 2048K                                                                                                                                                                
CPU: Physical Processor ID: 0                                                                                                                                                       
CPU: Processor Core ID: 1                                                                                                                                                           
mce: CPU supports 6 MCE banks                                                                                                                                                       
CPU1: Thermal monitoring enabled (TM2)                                                                                                                                              
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106                                                                                                                    
CPU1: Intel(R) Core(TM)2 Duo CPU     T5750  @ 2.00GHz stepping 0d                                                                                                                   
checking TSC synchronization [CPU#0 -> CPU#1]: passed.                                                                                                                              
Brought up 2 CPUs                                                                                                                                                                   
Total of 2 processors activated (7979.76 BogoMIPS).                                                                                                                                 
NET: Registered protocol family 16                                                                                                                                                  
ACPI: bus type pci registered                                                                                                                                                       
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63                                                                                                                     
PCI: MCFG area at f8000000 reserved in E820                                                                                                                                         
PCI: Using MMCONFIG at f8000000 - fbffffff                                                                                                                                          
PCI: Using configuration type 1 for base access                                                                                                                                     
bio: create slab <bio-0> at 0                                                                                                                                                       
ACPI: EC: Look up EC in DSDT                                                                                                                                                        
ACPI: Interpreter enabled                                                                                                                                                           
ACPI: (supports S0 S3 S4 S5)                                                                                                                                                        
ACPI: Using IOAPIC for interrupt routing                                                                                                                                            
ACPI: No dock devices found.                                                                                                                                                        
ACPI: PCI Root Bridge [PCI0] (0000:00)                                                                                                                                              
pci 0000:00:02.0: reg 10 64bit mmio: [0xfea00000-0xfeafffff]                                                                                                                        
pci 0000:00:02.0: reg 18 64bit mmio: [0xe0000000-0xefffffff]                                                                                                                        
pci 0000:00:02.0: reg 20 io port: [0xeff8-0xefff]                                                                                                                                   
pci 0000:00:02.1: reg 10 64bit mmio: [0xfeb00000-0xfebfffff]                                                                                                                        
pci 0000:00:1a.0: reg 20 io port: [0x6f20-0x6f3f]                                                                                                                                   
pci 0000:00:1a.1: reg 20 io port: [0x6f00-0x6f1f]                                                                                                                                   
pci 0000:00:1a.7: reg 10 32bit mmio: [0xfed1c400-0xfed1c7ff]                                                                                                                        
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold                                                                                                                               
pci 0000:00:1a.7: PME# disabled                                                                                                                                                     
pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe9fc000-0xfe9fffff]                                                                                                                        
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold                                                                                                                               
pci 0000:00:1b.0: PME# disabled                                                                                                                                                     
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold                                                                                                                               
pci 0000:00:1c.0: PME# disabled                                                                                                                                                     
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold                                                                                                                               
pci 0000:00:1c.1: PME# disabled                                                                                                                                                     
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold                                                                                                                               
pci 0000:00:1c.4: PME# disabled                                                                                                                                                     
pci 0000:00:1d.0: reg 20 io port: [0x6f80-0x6f9f]                                                                                                                                   
pci 0000:00:1d.1: reg 20 io port: [0x6f60-0x6f7f]                                                                                                                                   
pci 0000:00:1d.2: reg 20 io port: [0x6f40-0x6f5f]                                                                                                                                   
pci 0000:00:1d.7: reg 10 32bit mmio: [0xfed1c000-0xfed1c3ff]                                                                                                                        
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold                                                                                                                               
pci 0000:00:1d.7: PME# disabled                                                                                                                                                     
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO                                                                                                             
pci 0000:00:1f.0: quirk: region 1080-10bf claimed by ICH6 GPIO                                                                                                                      
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0900 (mask 007f)                                                                                                              
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 006c (mask 0007)                                                                                                              
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0c80 (mask 003f)                                                                                                              
pci 0000:00:1f.1: reg 10 io port: [0x1f0-0x1f7]                                                                                                                                     
pci 0000:00:1f.1: reg 14 io port: [0x3f4-0x3f7]                                                                                                                                     
pci 0000:00:1f.1: reg 18 io port: [0x170-0x177]                                                                                                                                     
pci 0000:00:1f.1: reg 1c io port: [0x374-0x377]                                                                                                                                     
pci 0000:00:1f.1: reg 20 io port: [0x6fa0-0x6faf]                                                                                                                                   
pci 0000:00:1f.2: reg 10 io port: [0x6eb0-0x6eb7]                                                                                                                                   
pci 0000:00:1f.2: reg 14 io port: [0x6eb8-0x6ebb]                                                                                                                                   
pci 0000:00:1f.2: reg 18 io port: [0x6ec0-0x6ec7]                                                                                                                                   
pci 0000:00:1f.2: reg 1c io port: [0x6ec8-0x6ecb]                                                                                                                                   
pci 0000:00:1f.2: reg 20 io port: [0x6ee0-0x6eff]                                                                                                                                   
pci 0000:00:1f.2: reg 24 32bit mmio: [0xfe9fb800-0xfe9fbfff]                                                                                                                        
pci 0000:00:1f.2: PME# supported from D3hot                                                                                                                                         
pci 0000:00:1f.2: PME# disabled                                                                                                                                                     
pci 0000:00:1f.3: reg 10 32bit mmio: [0xfe9fb700-0xfe9fb7ff]                                                                                                                        
pci 0000:00:1f.3: reg 20 io port: [0x10c0-0x10df]                                                                                                                                   
pci 0000:09:00.0: reg 10 64bit mmio: [0xfe8fc000-0xfe8fffff]                                                                                                                        
pci 0000:09:00.0: reg 18 io port: [0xde00-0xdeff]                                                                                                                                   
pci 0000:09:00.0: supports D1 D2                                                                                                                                                    
pci 0000:09:00.0: PME# supported from D0 D1 D2 D3hot D3cold                                                                                                                         
pci 0000:09:00.0: PME# disabled                                                                                                                                                     
pci 0000:00:1c.0: bridge io port: [0xd000-0xdfff]                                                                                                                                   
pci 0000:00:1c.0: bridge 32bit mmio: [0xfe800000-0xfe8fffff]                                                                                                                        
pci 0000:0b:00.0: reg 10 32bit mmio: [0xfe7ff000-0xfe7fffff]                                                                                                                        
pci 0000:0b:00.0: PME# supported from D0 D3hot D3cold                                                                                                                               
pci 0000:0b:00.0: PME# disabled                                                                                                                                                     
pci 0000:0b:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it 
with 'pcie_aspm=force'                                                                                  
pci 0000:00:1c.1: bridge 32bit mmio: [0xfe700000-0xfe7fffff]                                                                                                                        
pci 0000:00:1c.4: bridge io port: [0xc000-0xcfff]                                                                                                                                   
pci 0000:00:1c.4: bridge 32bit mmio: [0xfe400000-0xfe6fffff]                                                                                                                        
pci 0000:00:1c.4: bridge 64bit mmio pref: [0xf0000000-0xf01fffff]                                                                                                                   
pci 0000:02:09.0: reg 10 32bit mmio: [0xfe3ff800-0xfe3fffff]                                                                                                                        
pci 0000:02:09.0: supports D1 D2                                                                                                                                                    
pci 0000:02:09.0: PME# supported from D0 D1 D2 D3hot D3cold                                                                                                                         
pci 0000:02:09.0: PME# disabled                                                                                                                                                     
pci 0000:02:09.1: reg 10 32bit mmio: [0xfe3ff400-0xfe3ff4ff]                                                                                                                        
pci 0000:02:09.1: supports D1 D2                                                                                                                                                    
pci 0000:02:09.1: PME# supported from D0 D1 D2 D3hot D3cold                                                                                                                         
pci 0000:02:09.1: PME# disabled                                                                                                                                                     
pci 0000:02:09.2: reg 10 32bit mmio: [0xfe3ff500-0xfe3ff5ff]                                                                                                                        
pci 0000:02:09.2: supports D1 D2                                                                                                                                                    
pci 0000:02:09.2: PME# supported from D0 D1 D2 D3hot D3cold                                                                                                                         
pci 0000:02:09.2: PME# disabled                                                                                                                                                     
pci 0000:02:09.3: reg 10 32bit mmio: [0xfe3ff600-0xfe3ff6ff]                                                                                                                        
pci 0000:02:09.3: supports D1 D2                                                                                                                                                    
pci 0000:02:09.3: PME# supported from D0 D1 D2 D3hot D3cold                                                                                                                         
pci 0000:02:09.3: PME# disabled                                                                                                                                                     
pci 0000:02:09.4: reg 10 32bit mmio: [0xfe3ff700-0xfe3ff7ff]                                                                                                                        
pci 0000:02:09.4: supports D1 D2                                                                                                                                                    
pci 0000:02:09.4: PME# supported from D0 D1 D2 D3hot D3cold                                                                                                                         
pci 0000:02:09.4: PME# disabled                                                                                                                                                     
pci 0000:00:1e.0: transparent bridge                                                                                                                                                
pci 0000:00:1e.0: bridge 32bit mmio: [0xfe300000-0xfe3fffff]                                                                                                                        
pci_bus 0000:00: on NUMA node 0                                                                                                                                                     
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]                                                                                                                                 
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]                                                                                                                            
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]                                                                                                                            
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]                                                                                                                            
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]                                                                                                                            
ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)                                                                                                                                     
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *10                                                                                                                                      
ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *5                                                                                                                                   
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *0, disabled.                                                                                                                    
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)                                                                                                                  
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)                                                                                                                  
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)                                                                                                                  
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, 
disabled.                                                                                                     
SCSI subsystem initialized                                                                                                                                                          
libata version 3.00 loaded.                                                                                                                                                         
usbcore: registered new interface driver usbfs                                                                                                                                      
usbcore: registered new interface driver hub                                                                                                                                        
usbcore: registered new device driver usb                                                                                                                                           
PCI: Using ACPI for IRQ routing                                                                                                                                                     
cfg80211: Calling CRDA to update world regulatory domain                                                                                                                            
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0                                                                                                                                             
hpet0: 3 comparators, 64-bit 14.318180 MHz counter                                                                                                                                  
pnp: PnP ACPI init                                                                                                                                                                  
ACPI: bus type pnp registered                                                                                                                                                       
pnp 00:0a: io resource (0x1000-0x1005) overlaps 0000:00:1f.0 BAR 7 
(0x1000-0x107f), disabling                                                                                       
pnp 00:0a: io resource (0x1008-0x100f) overlaps 0000:00:1f.0 BAR 7 
(0x1000-0x107f), disabling                                                                                       
pnp 00:0b: io resource (0x1006-0x1007) overlaps 0000:00:1f.0 BAR 7 
(0x1000-0x107f), disabling                                                                                       
pnp 00:0b: io resource (0x100a-0x1059) overlaps 0000:00:1f.0 BAR 7 
(0x1000-0x107f), disabling                                                                                       
pnp 00:0b: io resource (0x1060-0x107f) overlaps 0000:00:1f.0 BAR 7 
(0x1000-0x107f), disabling                                                                                       
pnp 00:0b: io resource (0x1010-0x102f) overlaps 0000:00:1f.0 BAR 7 
(0x1000-0x107f), disabling                                                                                       
pnp: PnP ACPI: found 13 devices                                                                                                                                                     
ACPI: ACPI bus type pnp unregistered                                                                                                                                                
system 00:01: iomem range 0xff800000-0xff8fffff has been reserved                                                                                                                   
system 00:01: iomem range 0xffc00000-0xffcfffff has been reserved                                                                                                                   
system 00:06: ioport range 0xc80-0xcff could not be reserved                                                                                                                        
system 00:09: iomem range 0xfed00000-0xfed003ff has been reserved                                                                                                                   
system 00:0a: ioport range 0x900-0x97f has been reserved                                                                                                                            
system 00:0a: ioport range 0x4d0-0x4d1 has been reserved                                                                                                                            
system 00:0b: ioport range 0xf400-0xf4fe has been reserved                                                                                                                          
system 00:0b: ioport range 0x1080-0x10bf has been reserved                                                                                                                          
system 00:0b: ioport range 0x10c0-0x10df has been reserved                                                                                                                          
system 00:0b: ioport range 0x809-0x809 has been reserved                                                                                                                            
system 00:0c: iomem range 0x0-0x9efff could not be reserved                                                                                                                         
system 00:0c: iomem range 0x9f000-0x9ffff could not be reserved                                                                                                                     
system 00:0c: iomem range 0xc0000-0xcffff has been reserved                                                                                                                         
system 00:0c: iomem range 0xe0000-0xfffff has been reserved                                                                                                                         
system 00:0c: iomem range 0x100000-0xdf66d7ff could not be reserved                                                                                                                 
system 00:0c: iomem range 0xdf66d800-0xdf6fffff has been reserved                                                                                                                   
system 00:0c: iomem range 0xdf700000-0xdf7fffff has been reserved                                                                                                                   
system 00:0c: iomem range 0xdf700000-0xdfefffff could not be reserved                                                                                                               
system 00:0c: iomem range 0xffe00000-0xffffffff has been reserved                                                                                                                   
system 00:0c: iomem range 0xffa00000-0xffbfffff has been reserved                                                                                                                   
system 00:0c: iomem range 0xfec00000-0xfec0ffff could not be reserved                                                                                                               
system 00:0c: iomem range 0xfee00000-0xfee0ffff has been reserved                                                                                                                   
system 00:0c: iomem range 0xfed20000-0xfed8ffff has been reserved                                                                                                                   
system 00:0c: iomem range 0xfeda0000-0xfeda3fff has been reserved                                                                                                                   
system 00:0c: iomem range 0xfeda4000-0xfeda4fff has been reserved                                                                                                                   
system 00:0c: iomem range 0xfeda5000-0xfeda5fff has been reserved                                                                                                                   
system 00:0c: iomem range 0xfeda6000-0xfeda6fff has been reserved                                                                                                                   
system 00:0c: iomem range 0xfed18000-0xfed1bfff has been reserved                                                                                                                   
system 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved                                                                                                                   
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:09                                                                                                                                 
pci 0000:00:1c.0:   IO window: 0xd000-0xdfff                                                                                                                                        
pci 0000:00:1c.0:   MEM window: 0xfe800000-0xfe8fffff                                                                                                                               
pci 0000:00:1c.0:   PREFETCH window: disabled                                                                                                                                       
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0b                                                                                                                                 
pci 0000:00:1c.1:   IO window: disabled                                                                                                                                             
pci 0000:00:1c.1:   MEM window: 0xfe700000-0xfe7fffff                                                                                                                               
pci 0000:00:1c.1:   PREFETCH window: disabled                                                                                                                                       
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:0c                                                                                                                                 
pci 0000:00:1c.4:   IO window: 0xc000-0xcfff                                                                                                                                        
pci 0000:00:1c.4:   MEM window: 0xfe400000-0xfe6fffff                                                                                                                               
pci 0000:00:1c.4:   PREFETCH window: 0x000000f0000000-0x000000f01fffff                                                                                                              
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02                                                                                                                                 
pci 0000:00:1e.0:   IO window: disabled                                                                                                                                             
pci 0000:00:1e.0:   MEM window: 0xfe300000-0xfe3fffff                                                                                                                               
pci 0000:00:1e.0:   PREFETCH window: disabled                                                                                                                                       
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                                                        
pci 0000:00:1c.0: setting latency timer to 64                                                                                                                                       
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17                                                                                                                        
pci 0000:00:1c.1: setting latency timer to 64                                                                                                                                       
pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                                                        
pci 0000:00:1c.4: setting latency timer to 64                                                                                                                                       
pci 0000:00:1e.0: setting latency timer to 64                                                                                                                                       
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]                                                                                                                                      
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]                                                                                                                      
pci_bus 0000:09: resource 0 io:  [0xd000-0xdfff]                                                                                                                                    
pci_bus 0000:09: resource 1 mem: [0xfe800000-0xfe8fffff]                                                                                                                            
pci_bus 0000:0b: resource 1 mem: [0xfe700000-0xfe7fffff]                                                                                                                            
pci_bus 0000:0c: resource 0 io:  [0xc000-0xcfff]                                                                                                                                    
pci_bus 0000:0c: resource 1 mem: [0xfe400000-0xfe6fffff]                                                                                                                            
pci_bus 0000:0c: resource 2 pref mem [0xf0000000-0xf01fffff]                                                                                                                        
pci_bus 0000:02: resource 1 mem: [0xfe300000-0xfe3fffff]                                                                                                                            
pci_bus 0000:02: resource 3 io:  [0x00-0xffff]                                                                                                                                      
pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffffffffffff]                                                                                                                      
NET: Registered protocol family 2                                                                                                                                                   
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)                                                                                                                 
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)                                                                                                               
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)                                                                                                                        
TCP: Hash tables configured (established 262144 bind 65536)                                                                                                                         
TCP reno registered                                                                                                                                                                 
NET: Registered protocol family 1                                                                                                                                                   
Simple Boot Flag at 0x79 set to 0x1                                                                                                                                                 
HugeTLB registered 2 MB page size, pre-allocated 0 pages                                                                                                                            
VFS: Disk quotas dquot_6.5.2                                                                                                                                                        
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)                                                                                                                           
Btrfs loaded                                                                                                                                                                        
msgmni has been set to 7902                                                                                                                                                         
alg: No test for stdrng (krng)                                                                                                                                                      
io scheduler noop registered                                                                                                                                                        
io scheduler deadline registered                                                                                                                                                    
io scheduler cfq registered (default)                                                                                                                                               
pci 0000:00:02.0: Boot video device                                                                                                                                                 
pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X                                                                                                                                  
pcieport-driver 0000:00:1c.0: setting latency timer to 64                                                                                                                           
pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X                                                                                                                                  
pcieport-driver 0000:00:1c.1: setting latency timer to 64                                                                                                                           
pcieport-driver 0000:00:1c.4: irq 26 for MSI/MSI-X                                                                                                                                  
pcieport-driver 0000:00:1c.4: setting latency timer to 64                                                                                                                           
pci_hotplug: PCI Hot Plug PCI Core version: 0.5                                                                                                                                     
pciehp: PCI Express Hot Plug Controller Driver version: 0.4                                                                                                                         
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5                                                                                                                           
acpiphp_glue: can't get bus number, assuming 0                                                                                                                                      
decode_hpp: Could not get hotplug parameters. Use defaults                                                                                                                          
acpiphp: Slot [1] registered                                                                                                                                                        
ACPI: AC Adapter [AC] (on-line)                                                                                                                                                     
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0                                                                                                         
ACPI: Lid Switch [LID]                                                                                                                                                              
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1                                                                                                       
ACPI: Power Button [PBTN]                                                                                                                                                           
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2                                                                                                       
ACPI: Sleep Button [SBTN]                                                                                                                                                           
ACPI: SSDT 00000000df66e538 00244 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)                                                                                                      
ACPI: SSDT 00000000df66dece 005E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)                                                                                                      
Monitor-Mwait will be used to enter C-1 state                                                                                                                                       
Monitor-Mwait will be used to enter C-2 state                                                                                                                                       
Monitor-Mwait will be used to enter C-3 state                                                                                                                                       
Marking TSC unstable due to TSC halts in idle                                                                                                                                       
Switched to high resolution mode on CPU 0                                                                                                                                           
ACPI: CPU0 (power states:                                                                                                                                                           
Switched to high resolution mode on CPU 1                                                                                                                                           
 C1[C1] C2[C2] C3[C3])                                                                                                                                                              
processor LNXCPU:00: registered as cooling_device0                                                                                                                                  
ACPI: Processor [CPU0] (supports 8 throttling states)                                                                                                                               
ACPI: SSDT 00000000df66e77c 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)                                                                                                      
ACPI: SSDT 00000000df66e4b3 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)                                                                                                      
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])                                                                                                                                     
processor LNXCPU:01: registered as cooling_device1                                                                                                                                  
ACPI: Processor [CPU1] (supports 8 throttling states)                                                                                                                               
thermal LNXTHERM:01: registered as thermal_zone0                                                                                                                                    
ACPI: Thermal Zone [THM] (41 C)                                                                                                                                                     
Non-volatile memory driver v1.3                                                                                                                                                     
i8k: unable to get SMM BIOS version                                                                                                                                                 
Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal Zotto (dz@debian.org)                                                                                                           
Linux agpgart interface v0.103                                                                                                                                                      
agpgart-intel 0000:00:00.0: Intel 965GM Chipset                                                                                                                                     
agpgart-intel 0000:00:00.0: detected 7676K stolen memory                                                                                                                            
ACPI: Battery Slot [BAT0] (battery present)                                                                                                                                         
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000                                                                                                                       
[drm] Initialized drm 1.1.0 20060810                                                                                                                                                
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                                                       
i915 0000:00:02.0: setting latency timer to 64                                                                                                                                      
i915 0000:00:02.0: irq 27 for MSI/MSI-X                                                                                                                                             
[drm] TV-16: set mode NTSC 480i 0                                                                                                                                                   
[drm] LVDS-8: set mode 1280x800 19                                                                                                                                                  
Console: switching to colour frame buffer device 160x50                                                                                                                             
[drm] fb0: inteldrmfb frame buffer device                                                                                                                                           
acpi device:31: registered as cooling_device2                                                                                                                                       
input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:2e/input/input3                                                                                                
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)                                                                                                                       
ACPI Warning: \_SB_.PCI0.VID2._DOD: Return Package has no elements (empty) 
20090521 nspredef-434                                                                                    
input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:33/input/input4                                                                                                
ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)                                                                                                                      
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0                                                                                                                   
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled                                                                                                                             
Platform driver 'serial8250' needs updating - please use dev_pm_ops                                                                                                                 
brd: module loaded                                                                                                                                                                  
Loading iSCSI transport class v2.0-870.                                                                                                                                             
ahci 0000:00:1f.2: version 3.0                                                                                                                                                      
ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17                                                                                                                       
ahci 0000:00:1f.2: irq 28 for MSI/MSI-X                                                                                                                                             
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode                                                                                                        
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems                                                                                                               
ahci 0000:00:1f.2: setting latency timer to 64                                                                                                                                      
scsi0 : ahci                                                                                                                                                                        
scsi1 : ahci                                                                                                                                                                        
scsi2 : ahci                                                                                                                                                                        
ata1: SATA max UDMA/133 abar m2048@0xfe9fb800 port 0xfe9fb900 irq 28                                                                                                                
ata2: DUMMY                                                                                                                                                                         
ata3: SATA max UDMA/133 abar m2048@0xfe9fb800 port 0xfe9fba00 irq 28                                                                                                                
ata_piix 0000:00:1f.1: version 2.13                                                                                                                                                 
ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                                                   
ata_piix 0000:00:1f.1: setting latency timer to 64                                                                                                                                  
scsi3 : ata_piix                                                                                                                                                                    
scsi4 : ata_piix                                                                                                                                                                    
ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14                                                                                                                     
ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15                                                                                                                     
sky2 driver version 1.23                                                                                                                                                            
sky2 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                                                       
sky2 0000:09:00.0: setting latency timer to 64                                                                                                                                      
sky2 0000:09:00.0: Yukon-2 FE+ chip revision 0                                                                                                                                      
sky2 0000:09:00.0: irq 29 for MSI/MSI-X                                                                                                                                             
sky2 eth0: addr 00:21:9b:e1:ac:cf                                                                                                                                                   
ata5: port disabled. ignoring.                                                                                                                                                      
firewire_ohci 0000:02:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                                              
firewire_ohci: Added fw-ohci device 0000:02:09.0, OHCI version 1.10                                                                                                                 
usbmon: debugfs is not available                                                                                                                                                    
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver                                                                                                                          
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22                                                                                                                   
ehci_hcd 0000:00:1a.7: setting latency timer to 64                                                                                                                                  
ehci_hcd 0000:00:1a.7: EHCI Host Controller                                                                                                                                         
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1                                                                                                                
ehci_hcd 0000:00:1a.7: debug port 1                                                                                                                                                 
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported                                                                                                                       
ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400                                                                                                                                    
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00                                                                                                                                   
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002                                                                                                                       
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                                                                  
usb usb1: Product: EHCI Host Controller                                                                                                                                             
usb usb1: Manufacturer: Linux 2.6.31-rc5 ehci_hcd                                                                                                                                   
usb usb1: SerialNumber: 0000:00:1a.7                                                                                                                                                
usb usb1: configuration #1 chosen from 1 choice                                                                                                                                     
hub 1-0:1.0: USB hub found                                                                                                                                                          
hub 1-0:1.0: 4 ports detected                                                                                                                                                       
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20                                                                                                                   
ehci_hcd 0000:00:1d.7: setting latency timer to 64                                                                                                                                  
ehci_hcd 0000:00:1d.7: EHCI Host Controller                                                                                                                                         
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2                                                                                                                
ehci_hcd 0000:00:1d.7: debug port 1                                                                                                                                                 
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported                                                                                                                       
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000                                                                                                                                    
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00                                                                                                                                   
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002                                                                                                                       
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                                                                  
usb usb2: Product: EHCI Host Controller                                                                                                                                             
usb usb2: Manufacturer: Linux 2.6.31-rc5 ehci_hcd                                                                                                                                   
usb usb2: SerialNumber: 0000:00:1d.7                                                                                                                                                
usb usb2: configuration #1 chosen from 1 choice                                                                                                                                     
hub 2-0:1.0: USB hub found                                                                                                                                                          
hub 2-0:1.0: 6 ports detected                                                                                                                                                       
uhci_hcd: USB Universal Host Controller Interface driver                                                                                                                            
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20                                                                                                                   
uhci_hcd 0000:00:1a.0: setting latency timer to 64                                                                                                                                  
uhci_hcd 0000:00:1a.0: UHCI Host Controller                                                                                                                                         
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3                                                                                                                
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20                                                                                                                                   
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001                                                                                                                       
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                                                                  
usb usb3: Product: UHCI Host Controller                                                                                                                                             
usb usb3: Manufacturer: Linux 2.6.31-rc5 uhci_hcd                                                                                                                                   
usb usb3: SerialNumber: 0000:00:1a.0                                                                                                                                                
usb usb3: configuration #1 chosen from 1 choice                                                                                                                                     
hub 3-0:1.0: USB hub found                                                                                                                                                          
hub 3-0:1.0: 2 ports detected                                                                                                                                                       
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21                                                                                                                   
uhci_hcd 0000:00:1a.1: setting latency timer to 64                                                                                                                                  
uhci_hcd 0000:00:1a.1: UHCI Host Controller                                                                                                                                         
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4                                                                                                                
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00                                                                                                                                   
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001                                                                                                                       
ata4.00: ATAPI: HL-DT-ST DVD+/-RW GSA-T21N, A102, max UDMA/33                                                                                                                       
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                                                                  
usb usb4: Product: UHCI Host Controller                                                                                                                                             
usb usb4: Manufacturer: Linux 2.6.31-rc5 uhci_hcd                                                                                                                                   
usb usb4: SerialNumber: 0000:00:1a.1                                                                                                                                                
ata4.00: configured for UDMA/33                                                                                                                                                     
usb usb4: configuration #1 chosen from 1 choice                                                                                                                                     
hub 4-0:1.0: USB hub found                                                                                                                                                          
hub 4-0:1.0: 2 ports detected                                                                                                                                                       
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20                                                                                                                   
uhci_hcd 0000:00:1d.0: setting latency timer to 64                                                                                                                                  
uhci_hcd 0000:00:1d.0: UHCI Host Controller                                                                                                                                         
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5                                                                                                                
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80                                                                                                                                   
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001                                                                                                                       
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                                                                  
usb usb5: Product: UHCI Host Controller                                                                                                                                             
usb usb5: Manufacturer: Linux 2.6.31-rc5 uhci_hcd                                                                                                                                   
usb usb5: SerialNumber: 0000:00:1d.0                                                                                                                                                
usb usb5: configuration #1 chosen from 1 choice                                                                                                                                     
hub 5-0:1.0: USB hub found                                                                                                                                                          
hub 5-0:1.0: 2 ports detected                                                                                                                                                       
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21                                                                                                                   
uhci_hcd 0000:00:1d.1: setting latency timer to 64                                                                                                                                  
uhci_hcd 0000:00:1d.1: UHCI Host Controller                                                                                                                                         
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6                                                                                                                
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60                                                                                                                                   
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001                                                                                                                       
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                                                                  
usb usb6: Product: UHCI Host Controller                                                                                                                                             
usb usb6: Manufacturer: Linux 2.6.31-rc5 uhci_hcd                                                                                                                                   
usb usb6: SerialNumber: 0000:00:1d.1                                                                                                                                                
usb usb6: configuration #1 chosen from 1 choice                                                                                                                                     
hub 6-0:1.0: USB hub found                                                                                                                                                          
hub 6-0:1.0: 2 ports detected                                                                                                                                                       
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22                                                                                                                   
uhci_hcd 0000:00:1d.2: setting latency timer to 64                                                                                                                                  
uhci_hcd 0000:00:1d.2: UHCI Host Controller                                                                                                                                         
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7                                                                                                                
uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40                                                                                                                                   
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001                                                                                                                       
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                                                                  
usb usb7: Product: UHCI Host Controller                                                                                                                                             
usb usb7: Manufacturer: Linux 2.6.31-rc5 uhci_hcd                                                                                                                                   
usb usb7: SerialNumber: 0000:00:1d.2                                                                                                                                                
usb usb7: configuration #1 chosen from 1 choice                                                                                                                                     
hub 7-0:1.0: USB hub found                                                                                                                                                          
hub 7-0:1.0: 2 ports detected                                                                                                                                                       
usbcore: registered new interface driver libusual                                                                                                                                   
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12                                                                                                               
Platform driver 'i8042' needs updating - please use dev_pm_ops                                                                                                                      
i8042.c: Detected active multiplexing controller, rev 1.1.                                                                                                                          
serio: i8042 KBD port at 0x60,0x64 irq 1                                                                                                                                            
serio: i8042 AUX0 port at 0x60,0x64 irq 12                                                                                                                                          
serio: i8042 AUX1 port at 0x60,0x64 irq 12                                                                                                                                          
serio: i8042 AUX2 port at 0x60,0x64 irq 12                                                                                                                                          
serio: i8042 AUX3 port at 0x60,0x64 irq 12                                                                                                                                          
mice: PS/2 mouse device common for all mice                                                                                                                                         
rtc_cmos 00:04: RTC can wake from S4                                                                                                                                                
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0                                                                                                                               
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs                                                                                                                       
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17                                                                                                                 
cpuidle: using governor ladder                                                                                                                                                      
cpuidle: using governor menu                                                                                                                                                        
sdhci: Secure Digital Host Controller Interface driver                                                                                                                              
sdhci: Copyright(c) Pierre Ossman                                                                                                                                                   
sdhci-pci 0000:02:09.1: SDHCI controller found [1180:0822] (rev 22)                                                                                                                 
sdhci-pci 0000:02:09.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18                                                                                                                  
Registered led device: mmc0::                                                                                                                                                       
mmc0: SDHCI controller on PCI [0000:02:09.1] using DMA                                                                                                                              
ricoh-mmc: Ricoh MMC Controller disabling driver                                                                                                                                    
ricoh-mmc: Copyright(c) Philip Langdale                                                                                                                                             
ricoh-mmc: Ricoh MMC controller found at 0000:02:09.2 [1180:0843] (rev 12)                                                                                                          
ricoh-mmc: Controller is now disabled.                                                                                                                                              
Advanced Linux Sound Architecture Driver Version 1.0.20.                                                                                                                            
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21                                                                                                                  
HDA Intel 0000:00:1b.0: setting latency timer to 64                                                                                                                                 
input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input5                                                                                                  
ata3: SATA link down (SStatus 0 SControl 300)                                                                                                                                       
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                                                                                                                              
ata1.00: ATA-8: ST9120817AS, 3.ADB, max UDMA/133                                                                                                                                    
ata1.00: 234441648 sectors, multi 8: LBA48 NCQ (depth 31/32)                                                                                                                        
ata1.00: configured for UDMA/133                                                                                                                                                    
hda-codec: No codec parser is available                                                                                                                                             
scsi 0:0:0:0: Direct-Access     ATA      ST9120817AS      3.AD PQ: 0 ANSI: 5                                                                                                        
sd 0:0:0:0: Attached scsi generic sg0 type 0                                                                                                                                        
sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)                                                                                                               
sd 0:0:0:0: [sda] Write Protect is off                                                                                                                                              
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00                                                                                                                                           
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA                                                                                             
 sda:                                                                                                                                                                               
scsi 3:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-T21N A102 PQ: 0 ANSI: 5                                                                                                        
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray                                                                                                                       
Uniform CD-ROM driver Revision: 3.20                                                                                                                                                
sr 3:0:0:0: Attached scsi CD-ROM sr0                                                                                                                                                
sr 3:0:0:0: Attached scsi generic sg1 type 5                                                                                                                                        
 sda1 sda2 sda3                                                                                                                                                                     
sd 0:0:0:0: [sda] Attached SCSI disk                                                                                                                                                
hda-codec: No codec parser is available                                                                                                                                             
ALSA device list:                                                                                                                                                                   
  #0: HDA Intel at 0xfe9fc000 irq 21                                                                                                                                                
TCP cubic registered                                                                                                                                                                
Initializing XFRM netlink socket                                                                                                                                                    
NET: Registered protocol family 17
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
PM: Checking image partition /dev/sda3
PM: Resume from partition 8:3
PM: Checking hibernation image.
firewire_core: created device fw0: GUID 394fc00007dc7870, S400
PM: Resume from disk failed.
registered taskstats version 1
Clocksource tsc unstable (delta = -151011390 ns)
usb 6-1: new full speed USB device using uhci_hcd and address 2
usb 6-1: New USB device found, idVendor=046d, idProduct=c526
usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 6-1: Product: USB Receiver
usb 6-1: Manufacturer: Logitech
usb 6-1: configuration #1 chosen from 1 choice
input: PS/2 Mouse as /devices/platform/i8042/serio2/input/input6
input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio2/input/input7
EXT4-fs (sda2): barriers enabled
EXT4-fs (sda2): Ignoring delalloc option - requested data journaling mode
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (sda2): mounted filesystem with journalled data mode
VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
Freeing unused kernel memory: 364k freed
kjournald2 starting: pid 781, dev sda2:8, commit interval 5 seconds
udev: starting version 146
usbcore: registered new interface driver hiddev
input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1:1.0/input/input8
generic-usb 0003:046D:C526.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech 
USB Receiver] on usb-0000:00:1d.1-1/input0
input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1:1.1/input/input9
generic-usb 0003:046D:C526.0002: input,hiddev96,hidraw1: USB HID v1.11 Device 
[Logitech USB Receiver] on usb-0000:00:1d.1-1/input1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-
devel@redhat.com
loop: module loaded
EXT4-fs (sda2): internal journal on sda2:8
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with journal data mode.
NET: Registered protocol family 10
Adding 2048276k swap on /dev/sda3.  Priority:-1 extents:1 across:2048276k



