Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbZH0Q3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbZH0Q3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 12:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZH0Q3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 12:29:06 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:57991 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbZH0Q3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 12:29:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=p6GnZ+LNA407NlF/o3xyS/M6HFDdfMl5jwklGDctTI7790GxYOdJNpiYhYGekHK01d
         vOGIc+PNKqbjxnOIRh+GQL+m+kWSFDNo+6WfFQQfN7X51LJwuDhz8WK8/RoCgpCyflB0
         FY8hRlwaXjojMtQozCqeTGfedUCglEvVDYG74=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: amd64 + mtrr: only 3.1gb of 8gb are covered, kernel 2.6.30 and earlier.
Date: Thu, 27 Aug 2009 18:28:58 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30.5r4; KDE/4.3.0; x86_64; ; )
References: <200908211814.56800.volkerarmin@googlemail.com> <200908270313.32528.volkerarmin@googlemail.com> <86802c440908270013k4b8c75b1h6bac33a623ded5e7@mail.gmail.com>
In-Reply-To: <86802c440908270013k4b8c75b1h6bac33a623ded5e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908271828.59356.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag 27 August 2009, you wrote:
> On Wed, Aug 26, 2009 at 6:13 PM, Volker Armin
>
> Hemmann<volkerarmin@googlemail.com> wrote:
> > Hi,
> >
> > On Sonntag 23 August 2009, Yinghai Lu wrote:
> >> On Sat, Aug 22, 2009 at 12:26 PM, Volker Armin
> >>
> >> Hemmann<volkerarmin@googlemail.com> wrote:
> >> > when I went from 4gb to 6gb I had a performance degradation. Since the
> >> > 8gb are faster and the new cpu is faster, I don't see degradation. But
> >> > I wonder how much better performance could be with 'correct' mtrr.
> >>
> >> that is weird. with 4g should have mem hole remapping.
> >>
> >> do you still have /proc/mtrr for 6g setup?
> >>
> >> YH
> >
> > some more information, mtrr of 8gb with my X2 6000:
> >
> > reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> > reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
> > reg02: base=0x0c0000000 ( 3072MB), size=  128MB, count=1: write-back
> > reg03: base=0x0c8000000 ( 3200MB), size=   64MB, count=1: write-back
> > reg04: base=0x0cc000000 ( 3264MB), size=   32MB, count=1: write-back
> > reg05: base=0x0ce000000 ( 3296MB), size=   16MB, count=1: write-back
> >
> > from June with 2.6.30, dmesg from that incident is attached
> >
> > compared that with the mtrr with my X4:
> >
> > reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> > reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
> > reg02: base=0x0c0000000 ( 3072MB), size=  128MB, count=1: write-back
> >
> >
> > just ignore the fgrlx parts - whenever I checked it did not made a
> > difference if X was started or not.
>
> theo one with X4, you got extra device
>
> [    0.383812] pci 0000:03:00.0: reg 10 io port: [0xd800-0xd8ff]
> [    0.383828] pci 0000:03:00.0: reg 18 64bit mmio: [0xfebff000-0xfebfffff]
> [    0.383844] pci 0000:03:00.0: reg 30 32bit mmio: [0xfebc0000-0xfebdffff]
> [    0.383878] pci 0000:03:00.0: supports D1 D2
> [    0.383879] pci 0000:03:00.0: PME# supported from D1 D2 D3hot D3cold
> [    0.383916] pci 0000:03:00.0: PME# disabled
>
> so BIOS allocate more mmio space for it.
>
> YH

that card is (as far as I can see) an additional networking card from realtek 
I put into the pcie1x slot. On the other hand I also removed a  scsi card in 
the mean time. 

I removed that card:

cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg02: base=0x0c0000000 ( 3072MB), size=  128MB, count=1: write-back

 dmesg
[    0.000000] Linux version 2.6.30.5r4 (root@energy) (gcc version 4.4.1 
(Gentoo 4.4.1 p1.0) ) #1 SMP Tue Aug 18 06:28:18 CEST 2009                                                           
[    0.000000] Command line: root=/dev/md1 md=3,/dev/sda3,/dev/sdb3,/dev/sdc3 
nmi_watchdog=0 mtrr_spare_reg_nr=1                                                                              
[    0.000000] KERNEL supported cpus:                                                          
[    0.000000]   Intel GenuineIntel                                                            
[    0.000000]   AMD AuthenticAMD                                                              
[    0.000000] BIOS-provided physical RAM map:                                                 
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)                        
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)                      
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)                      
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7eb0000 (usable)                        
[    0.000000]  BIOS-e820: 00000000c7eb0000 - 00000000c7ec0000 (ACPI data)                     
[    0.000000]  BIOS-e820: 00000000c7ec0000 - 00000000c7ef0000 (ACPI NVS)                      
[    0.000000]  BIOS-e820: 00000000c7ef0000 - 00000000c7f00000 (reserved)                      
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)                      
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000238000000 (usable)                        
[    0.000000] DMI present.                                                                    
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.                 
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) 
==> (reserved)  
[    0.000000] last_pfn = 0x238000 max_arch_pfn = 0x100000000                                  
[    0.000000] MTRR default type: uncachable                                                   
[    0.000000] MTRR fixed ranges enabled:                                                      
[    0.000000]   00000-9FFFF write-back                                                        
[    0.000000]   A0000-EFFFF uncachable                                                        
[    0.000000]   F0000-FFFFF write-protect                                                     
[    0.000000] MTRR variable ranges enabled:                                                   
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back                              
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back                              
[    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back                              
[    0.000000]   3 disabled                                                                    
[    0.000000]   4 disabled                                                                    
[    0.000000]   5 disabled                                                                    
[    0.000000]   6 disabled                                                                    
[    0.000000]   7 disabled                                                                    
[    0.000000] TOM2: 0000000238000000 aka 9088M                                                
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106                
[    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usable) 
==> (reserved)  
[    0.000000] last_pfn = 0xc7eb0 max_arch_pfn = 0x100000000                                   
[    0.000000] init_memory_mapping: 0000000000000000-00000000c7eb0000                          
[    0.000000] Using GB pages for direct mapping                                               
[    0.000000]  0000000000 - 00c0000000 page 1G                                                
[    0.000000]  00c0000000 - 00c7e00000 page 2M                                                
[    0.000000]  00c7e00000 - 00c7eb0000 page 4k                                                
[    0.000000] kernel direct mapping tables up to c7eb0000 @ 10000-13000                       
[    0.000000] init_memory_mapping: 0000000100000000-0000000238000000                          
[    0.000000] Using GB pages for direct mapping                                               
[    0.000000]  0100000000 - 0200000000 page 1G                                                
[    0.000000]  0200000000 - 0238000000 page 2M                                                
[    0.000000] kernel direct mapping tables up to 238000000 @ 12000-14000                      
[    0.000000] ACPI: RSDP 00000000000fa7c0 00014 (v00 ACPIAM)                                  
[    0.000000] ACPI: RSDT 00000000c7eb0000 00040 (v01 050609 RSDT2000 20090506 
MSFT 00000097)  
[    0.000000] ACPI: FACP 00000000c7eb0200 00084 (v02 A M I  OEMFACP  12000601 
MSFT 00000097)  
[    0.000000] ACPI: DSDT 00000000c7eb0440 08512 (v01  AS140 AS140121 00000121 
INTL 20051117)  
[    0.000000] ACPI: FACS 00000000c7ec0000 00040                                               
[    0.000000] ACPI: APIC 00000000c7eb0390 0006C (v01 050609 APIC2000 20090506 
MSFT 00000097)  
[    0.000000] ACPI: MCFG 00000000c7eb0400 0003C (v01 050609 OEMMCFG  20090506 
MSFT 00000097)  
[    0.000000] ACPI: OEMB 00000000c7ec0040 00071 (v01 050609 OEMB2000 20090506 
MSFT 00000097)  
[    0.000000] ACPI: AAFT 00000000c7eb8960 00027 (v01 050609 OEMAAFT  20090506 
MSFT 00000097)  
[    0.000000] ACPI: HPET 00000000c7eb8990 00038 (v01 050609 OEMHPET  20090506 
MSFT 00000097)  
[    0.000000] ACPI: SSDT 00000000c7eb89d0 0088C (v01 A M I  POWERNOW 00000001 
AMD  00000001)  
[    0.000000] ACPI: Local APIC address 0xfee00000                                             
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0238000000]                    
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 
- 0000001000]   
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 
- 0000008000]   
[    0.000000]   #2 [0001000000 - 0001575998]    TEXT DATA BSS ==> [0001000000 
- 0001575998]   
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 
- 0000100000]   
[    0.000000]   #4 [0001576000 - 0001576133]              BRK ==> [0001576000 
- 0001576133]   
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 
- 0000012000]   
[    0.000000]   #6 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 
- 0000013000]   
[    0.000000]  [ffffe20000000000-ffffe20007dfffff] PMD -> [ffff880028200000-
ffff88002fffffff] on node 0                                                                                      
[    0.000000] Zone PFN ranges:                                                                
[    0.000000]   DMA      0x00000010 -> 0x00001000                                             
[    0.000000]   DMA32    0x00001000 -> 0x00100000                                             
[    0.000000]   Normal   0x00100000 -> 0x00238000                                             
[    0.000000] Movable zone start PFN for each node                                            
[    0.000000] early_node_map[3] active PFN ranges                                             
[    0.000000]     0: 0x00000010 -> 0x0000009f                                                 
[    0.000000]     0: 0x00000100 -> 0x000c7eb0                                                 
[    0.000000]     0: 0x00100000 -> 0x00238000                                                 
[    0.000000] On node 0 totalpages: 2096703                                                   
[    0.000000]   DMA zone: 56 pages used for memmap                                            
[    0.000000]   DMA zone: 102 pages reserved                                                  
[    0.000000]   DMA zone: 3825 pages, LIFO batch:0                                            
[    0.000000]   DMA32 zone: 14280 pages used for memmap                                       
[    0.000000]   DMA32 zone: 800488 pages, LIFO batch:31                                       
[    0.000000]   Normal zone: 17472 pages used for memmap                                      
[    0.000000]   Normal zone: 1260480 pages, LIFO batch:31                                     
[    0.000000] ACPI: PM-Timer IO Port: 0x808                                                   
[    0.000000] ACPI: Local APIC address 0xfee00000                                             
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)                              
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)                              
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)                              
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)                              
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])                         
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23                   
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)                        
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)                      
[    0.000000] ACPI: IRQ0 used by override.                                                    
[    0.000000] ACPI: IRQ2 used by override.                                                    
[    0.000000] ACPI: IRQ9 used by override.                                                    
[    0.000000] Using ACPI (MADT) for SMP configuration information                             
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000                                          
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs                                            
[    0.000000] nr_irqs_gsi: 24                                                                 
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000               
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e6000               
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 
0000000000100000               
[    0.000000] PM: Registered nosave memory: 00000000c7eb0000 - 
00000000c7ec0000               
[    0.000000] PM: Registered nosave memory: 00000000c7ec0000 - 
00000000c7ef0000               
[    0.000000] PM: Registered nosave memory: 00000000c7ef0000 - 
00000000c7f00000               
[    0.000000] PM: Registered nosave memory: 00000000c7f00000 - 
00000000fff00000               
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 
0000000100000000               
[    0.000000] Allocating PCI resources starting at c8000000 (gap: 
c7f00000:38000000)          
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1                          
[    0.000000] PERCPU: Embedded 24 pages at ffff880028034000, static data 67808 
bytes          
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 2064793    
[    0.000000] Kernel command line: root=/dev/md1 
md=3,/dev/sda3,/dev/sdb3,/dev/sdc3 nmi_watchdog=0 mtrr_spare_reg_nr=1                                                                       
[    0.000000] md: Will configure md3 (super-block) from 
/dev/sda3,/dev/sdb3,/dev/sdc3, below. 
[    0.000000] Initializing CPU#0                                                              
[    0.000000] NR_IRQS:384                                                                     
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)                           
[    0.000000] Fast TSC calibration using PIT                                                  
[    0.000000] Detected 3200.022 MHz processor.                                                
[    0.003333] Console: colour VGA+ 80x25                                                      
[    0.003333] console [tty0] enabled                                                          
[    0.003333] Dentry cache hash table entries: 1048576 (order: 11, 8388608 
bytes)             
[    0.003333] Inode-cache hash table entries: 524288 (order: 10, 4194304 
bytes)               
[    0.003333] Checking aperture...                                                            
[    0.003333] No AGP bridge found                                                             
[    0.003333] Node 0: aperture @ 2242000000 size 32 MB                                        
[    0.003333] Aperture beyond 4GB. Ignoring.                                                  
[    0.003333] Your BIOS doesn't leave a aperture memory hole                                  
[    0.003333] Please enable the IOMMU option in the BIOS setup                                
[    0.003333] This costs you 64 MB of RAM                                                     
[    0.003333] Mapping aperture over 65536 KB of RAM @ 20000000                                
[    0.003333] PM: Registered nosave memory: 0000000020000000 - 
0000000024000000               
[    0.003333] Memory: 8172700k/9306112k available (3231k kernel code, 919300k 
absent, 213188k reserved, 1310k data, 348k init)                                                               
[    0.003333] hpet clockevent registered                                                      
[    0.003333] HPET: 4 timers in total, 1 timers will be used for per-cpu 
timer                
[    0.003338] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 6402.70 BogoMIPS (lpj=10666726)                                                                     
[    0.003444] Mount-cache hash table entries: 256                                             
[    0.003563] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)               
[    0.003598] CPU: L2 Cache: 512K (64 bytes/line)                                             
[    0.003632] tseg: 0000000000                                                                
[    0.003638] CPU: Physical Processor ID: 0                                                   
[    0.003671] CPU: Processor Core ID: 0                                                       
[    0.003709] using C1E aware idle routine                                                    
[    0.003752] ACPI: Core revision 20090320                                                    
[    0.016701] Setting APIC routing to flat                                                    
[    0.017037] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1                            
[    0.050747] CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02                            
[    0.053332] Booting processor 1 APIC 0x1 ip 0x6000                                          
[    0.003333] Initializing CPU#1                                                              
[    0.003333] Calibrating delay using timer specific routine.. 6402.85 
BogoMIPS (lpj=10666968)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)               
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)                                             
[    0.003333] CPU: Physical Processor ID: 0                                                   
[    0.003333] CPU: Processor Core ID: 1                                                       
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 
0x7010600070106                
[    0.144204] CPU1: AMD Phenom(tm) II X4 955 Processor stepping 02                            
[    0.144516] checking TSC synchronization [CPU#0 -> CPU#1]: passed.                          
[    0.146715] Booting processor 2 APIC 0x2 ip 0x6000                                          
[    0.003333] Initializing CPU#2                                                              
[    0.003333] Calibrating delay using timer specific routine.. 6402.85 
BogoMIPS (lpj=10666966)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)               
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)                                             
[    0.003333] CPU: Physical Processor ID: 0                                                   
[    0.003333] CPU: Processor Core ID: 2                                                       
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 
0x7010600070106                
[    0.240831] CPU2: AMD Phenom(tm) II X4 955 Processor stepping 02                            
[    0.241143] checking TSC synchronization [CPU#0 -> CPU#2]: passed.                          
[    0.243382] Booting processor 3 APIC 0x3 ip 0x6000                                          
[    0.003333] Initializing CPU#3                                                              
[    0.003333] Calibrating delay using timer specific routine.. 6402.86 
BogoMIPS (lpj=10666977)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)               
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)                                             
[    0.003333] CPU: Physical Processor ID: 0                                                   
[    0.003333] CPU: Processor Core ID: 3                                                       
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 
0x7010600070106                
[    0.337458] CPU3: AMD Phenom(tm) II X4 955 Processor stepping 02                            
[    0.337769] checking TSC synchronization [CPU#0 -> CPU#3]: passed.                          
[    0.340014] Brought up 4 CPUs                                                               
[    0.340048] Total of 4 processors activated (25610.27 BogoMIPS).                            
[    0.340314] net_namespace: 1400 bytes                                                       
[    0.340417] xor: automatically using best checksumming function: 
generic_sse                
[    0.356667]    generic_sse: 12783.600 MB/sec                                                
[    0.356701] xor: using function: generic_sse (12783.600 MB/sec)                             
[    0.356754] Time: 18:24:15  Date: 08/27/09                                                  
[    0.356837] NET: Registered protocol family 16                                              
[    0.357042] node 0 link 0: io port [1000, ffffff]                                           
[    0.357044] TOM: 00000000c8000000 aka 3200M                                                 
[    0.357078] Fam 10h mmconf [e0000000, efffffff]                                             
[    0.357080] node 0 link 0: mmio [e0000000, efffffff] ==> none                               
[    0.357082] node 0 link 0: mmio [f0000000, ffffffff]                                        
[    0.357084] node 0 link 0: mmio [a0000, bffff]                                              
[    0.357085] node 0 link 0: mmio [c8000000, dfffffff]                                        
[    0.357087] TOM2: 0000000238000000 aka 9088M                                                
[    0.357120] bus: [00,07] on node 0 link 0                                                   
[    0.357122] bus: 00 index 0 io port: [0, ffff]                                              
[    0.357123] bus: 00 index 1 mmio: [f0000000, ffffffff]                                      
[    0.357124] bus: 00 index 2 mmio: [a0000, bffff]                                            
[    0.357125] bus: 00 index 3 mmio: [c8000000, dfffffff]                                      
[    0.357126] bus: 00 index 4 mmio: [238000000, fcffffffff]                                   
[    0.357133] ACPI: bus type pci registered                                                   
[    0.357236] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255                
[    0.357271] PCI: Not using MMCONFIG.                                                        
[    0.357305] PCI: Using configuration type 1 for base access                                 
[    0.357338] PCI: Using configuration type 1 for extended access                             
[    0.358956] bio: create slab <bio-0> at 0                                                   
[    0.359399] ACPI: EC: Look up EC in DSDT                                                    
[    0.367245] ACPI: Interpreter enabled                                                       
[    0.367280] ACPI: (supports S0 S1 S3 S4 S5)                                                 
[    0.367395] ACPI: Using IOAPIC for interrupt routing                                        
[    0.367473] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255                
[    0.370672] PCI: MCFG area at e0000000 reserved in ACPI motherboard 
resources               
[    0.375800] PCI: Using MMCONFIG at e0000000 - efffffff                                      
[    0.381629] ACPI: No dock devices found.                                                    
[    0.381855] ACPI: PCI Root Bridge [PCI0] (0000:00)                                          
[    0.381960] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]                    
[    0.382006] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold                           
[    0.382041] pci 0000:00:02.0: PME# disabled                                                 
[    0.382108] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold                           
[    0.382143] pci 0000:00:09.0: PME# disabled                                                 
[    0.382688] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold                           
[    0.382723] pci 0000:00:0a.0: PME# disabled                                                 
[    0.382801] pci 0000:00:11.0: reg 10 io port: [0xa000-0xa007]                               
[    0.382807] pci 0000:00:11.0: reg 14 io port: [0x9000-0x9003]                               
[    0.382813] pci 0000:00:11.0: reg 18 io port: [0x8000-0x8007]                               
[    0.382818] pci 0000:00:11.0: reg 1c io port: [0x7000-0x7003]                               
[    0.382824] pci 0000:00:11.0: reg 20 io port: [0x6000-0x600f]                               
[    0.382830] pci 0000:00:11.0: reg 24 32bit mmio: [0xfddff800-0xfddffbff]                    
[    0.382879] pci 0000:00:12.0: reg 10 32bit mmio: [0xfddfe000-0xfddfefff]                    
[    0.382930] pci 0000:00:12.1: reg 10 32bit mmio: [0xfddfd000-0xfddfdfff]                    
[    0.382998] pci 0000:00:12.2: reg 10 32bit mmio: [0xfddff000-0xfddff0ff]                    
[    0.383047] pci 0000:00:12.2: supports D1 D2                                                
[    0.383049] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot                            
[    0.383085] pci 0000:00:12.2: PME# disabled                                                 
[    0.383146] pci 0000:00:13.0: reg 10 32bit mmio: [0xfddfc000-0xfddfcfff]                    
[    0.383197] pci 0000:00:13.1: reg 10 32bit mmio: [0xfddf7000-0xfddf7fff]                    
[    0.383266] pci 0000:00:13.2: reg 10 32bit mmio: [0xfddf6800-0xfddf68ff]                    
[    0.383315] pci 0000:00:13.2: supports D1 D2                                                
[    0.383316] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot                            
[    0.383336] pci 0000:00:13.2: PME# disabled                                                 
[    0.383478] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]                                   
[    0.383484] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]                                   
[    0.383490] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]                                   
[    0.383495] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]                                   
[    0.383501] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]                               
[    0.383626] pci 0000:00:14.5: reg 10 32bit mmio: [0xfddf5000-0xfddf5fff]                    
[    0.383760] pci 0000:02:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]                    
[    0.383767] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdff0000-0xfdffffff]                    
[    0.383771] pci 0000:02:00.0: reg 20 io port: [0xc000-0xc0ff]                               
[    0.383778] pci 0000:02:00.0: reg 30 32bit mmio: [0xfdfc0000-0xfdfdffff]                    
[    0.383794] pci 0000:02:00.0: supports D1 D2                                                
[    0.383821] pci 0000:02:00.1: reg 10 64bit mmio: [0xfdfec000-0xfdfeffff]                    
[    0.383852] pci 0000:02:00.1: supports D1 D2                                                
[    0.383901] pci 0000:00:02.0: bridge io port: [0xc000-0xcfff]                               
[    0.383903] pci 0000:00:02.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]                    
[    0.383906] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]               
[    0.383948] pci 0000:00:09.0: bridge io port: [0xd000-0xdfff]                               
[    0.383950] pci 0000:00:09.0: bridge 32bit mmio: [0xfe000000-0xfebfffff]                    
[    0.383953] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfa000000-0xfcefffff]               
[    0.383984] pci 0000:01:00.0: reg 10 io port: [0xb800-0xb8ff]                               
[    0.383997] pci 0000:01:00.0: reg 18 64bit mmio: [0xcffff000-0xcfffffff]                    
[    0.384007] pci 0000:01:00.0: reg 20 64bit mmio: [0xcffe0000-0xcffeffff]                    
[    0.384012] pci 0000:01:00.0: reg 30 32bit mmio: [0xfdef0000-0xfdefffff]                    
[    0.384039] pci 0000:01:00.0: supports D1 D2                                                
[    0.384040] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold                     
[    0.384077] pci 0000:01:00.0: PME# disabled                                                 
[    0.384162] pci 0000:00:0a.0: bridge io port: [0xb000-0xbfff]                               
[    0.384164] pci 0000:00:0a.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]                    
[    0.384167] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xcff00000-0xcfffffff]               
[    0.384201] pci 0000:05:06.0: reg 10 32bit mmio: [0xfcfff000-0xfcffffff]                    
[    0.384282] pci 0000:05:08.0: reg 10 io port: [0xe800-0xe83f]                               
[    0.384339] pci 0000:05:08.0: supports D1 D2                                                
[    0.384381] pci 0000:00:14.4: transparent bridge                                            
[    0.384417] pci 0000:00:14.4: bridge io port: [0xe000-0xefff]                               
[    0.384423] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfcf00000-0xfcffffff]               
[    0.384435] pci_bus 0000:00: on NUMA node 0                                                 
[    0.384439] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]                             
[    0.384573] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]                        
[    0.384617] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]                        
[    0.384661] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]                        
[    0.384723] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]                        
[    0.387558] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)                      
[    0.387802] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14 15)                      
[    0.388043] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)                      
[    0.388284] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)                      
[    0.388525] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, 
disabled.         
[    0.388812] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 *11 12 14 15)                      
[    0.389052] ACPI: PCI Interrupt Link [LNKG] (IRQs *4 10 11 12 14 15)                        
[    0.389281] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 *10 11 12 14 15)                      
[    0.389666] SCSI subsystem initialized                                                      
[    0.389752] libata version 3.00 loaded.                                                     
[    0.389823] usbcore: registered new interface driver usbfs                                  
[    0.389879] usbcore: registered new interface driver hub                                    
[    0.389943] usbcore: registered new device driver usb                                       
[    0.446679] raid6: int64x1   2811 MB/s                                                      
[    0.503351] raid6: int64x2   3615 MB/s                                                      
[    0.560018] raid6: int64x4   2850 MB/s                                                      
[    0.616675] raid6: int64x8   2698 MB/s                                                      
[    0.673347] raid6: sse2x1    4188 MB/s                                                      
[    0.730011] raid6: sse2x2    7192 MB/s                                                      
[    0.786667] raid6: sse2x4    7958 MB/s                                                      
[    0.786701] raid6: using algorithm sse2x4 (7958 MB/s)                                       
[    0.786782] PCI: Using ACPI for IRQ routing                                                 
[    0.786821] pci 0000:00:00.0: BAR 3: can't allocate resource                                
[    0.800181] PCI-DMA: Disabling AGP.                                                         
[    0.800296] PCI-DMA: aperture base @ 20000000 size 65536 KB                                 
[    0.800330] PCI-DMA: using GART IOMMU.                                                      
[    0.800365] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture                       
[    0.802132] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0                                     
[    0.802239] hpet0: 4 comparators, 32-bit 14.318180 MHz counter                              
[    0.806694] hpet: hpet2 irq 24 for MSI                                                      
[    0.816683] Switched to high resolution mode on CPU 0                                       
[    0.817794] Switched to high resolution mode on CPU 3                                       
[    0.817836] Switched to high resolution mode on CPU 2                                       
[    0.817876] Switched to high resolution mode on CPU 1                                       
[    0.826699] pnp: PnP ACPI init                                                              
[    0.826750] ACPI: bus type pnp registered                                                   
[    0.829210] pnp 00:0b: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 
(0x0-0x1fffffff), disabling                                                                                  
[    0.829264] pnp 00:0b: mem resource (0xc0000-0xcffff) overlaps 0000:00:00.0 
BAR 3 (0x0-0x1fffffff), disabling                                                                              
[    0.829318] pnp 00:0b: mem resource (0xe0000-0xfffff) overlaps 0000:00:00.0 
BAR 3 (0x0-0x1fffffff), disabling                                                                              
[    0.829372] pnp 00:0b: mem resource (0x100000-0xc7efffff) overlaps 
0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling                                                                          
[    0.829725] pnp: PnP ACPI: found 12 devices                                                 
[    0.829758] ACPI: ACPI bus type pnp unregistered                                            
[    0.829798] system 00:06: iomem range 0xfec00000-0xfec00fff could not be 
reserved           
[    0.829851] system 00:06: iomem range 0xfee00000-0xfee00fff has been 
reserved               
[    0.829888] system 00:07: ioport range 0x4d0-0x4d1 has been reserved                        
[    0.829923] system 00:07: ioport range 0x40b-0x40b has been reserved                        
[    0.829957] system 00:07: ioport range 0x4d6-0x4d6 has been reserved                        
[    0.830008] system 00:07: ioport range 0xc00-0xc01 has been reserved                        
[    0.830043] system 00:07: ioport range 0xc14-0xc14 has been reserved                        
[    0.830077] system 00:07: ioport range 0xc50-0xc51 has been reserved                        
[    0.830112] system 00:07: ioport range 0xc52-0xc52 has been reserved                        
[    0.830146] system 00:07: ioport range 0xc6c-0xc6c has been reserved                        
[    0.830181] system 00:07: ioport range 0xc6f-0xc6f has been reserved                        
[    0.830215] system 00:07: ioport range 0xcd0-0xcd1 has been reserved                        
[    0.830250] system 00:07: ioport range 0xcd2-0xcd3 has been reserved                        
[    0.830284] system 00:07: ioport range 0xcd4-0xcd5 has been reserved                        
[    0.830318] system 00:07: ioport range 0xcd6-0xcd7 has been reserved                        
[    0.830353] system 00:07: ioport range 0xcd8-0xcdf has been reserved                        
[    0.830387] system 00:07: ioport range 0x800-0x89f has been reserved                        
[    0.830422] system 00:07: ioport range 0xb00-0xb0f has been reserved                        
[    0.830456] system 00:07: ioport range 0xb20-0xb3f has been reserved                        
[    0.830490] system 00:07: ioport range 0x900-0x90f has been reserved                        
[    0.830525] system 00:07: ioport range 0x910-0x91f has been reserved                        
[    0.830559] system 00:07: ioport range 0xfe00-0xfefe has been reserved                      
[    0.830594] system 00:07: iomem range 0xffb80000-0xffbfffff has been reserved               
[    0.830629] system 00:07: iomem range 0xfec10000-0xfec1001f has been 
reserved               
[    0.830666] system 00:09: ioport range 0x290-0x29f has been reserved                        
[    0.830701] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved               
[    0.830738] system 00:0b: iomem range 0xfec00000-0xffffffff could not be 
reserved           
[    0.835626] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02                             
[    0.835661] pci 0000:00:02.0:   IO window: 0xc000-0xcfff                                    
[    0.835696] pci 0000:00:02.0:   MEM window: 0xfdf00000-0xfdffffff                           
[    0.835731] pci 0000:00:02.0:   PREFETCH window: 
0x000000d0000000-0x000000dfffffff          
[    0.835786] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03                             
[    0.835820] pci 0000:00:09.0:   IO window: 0xd000-0xdfff                                    
[    0.835855] pci 0000:00:09.0:   MEM window: 0xfe000000-0xfebfffff                           
[    0.835890] pci 0000:00:09.0:   PREFETCH window: 
0x000000fa000000-0x000000fcefffff          
[    0.835944] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:01                             
[    0.835978] pci 0000:00:0a.0:   IO window: 0xb000-0xbfff                                    
[    0.836013] pci 0000:00:0a.0:   MEM window: 0xfde00000-0xfdefffff                           
[    0.836048] pci 0000:00:0a.0:   PREFETCH window: 
0x000000cff00000-0x000000cfffffff          
[    0.836102] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05                             
[    0.836138] pci 0000:00:14.4:   IO window: 0xe000-0xefff                                    
[    0.836175] pci 0000:00:14.4:   MEM window: disabled                                        
[    0.836210] pci 0000:00:14.4:   PREFETCH window: 
0x000000fcf00000-0x000000fcffffff          
[    0.836273] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18                    
[    0.836309] pci 0000:00:02.0: setting latency timer to 64                                   
[    0.836315] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17                    
[    0.836350] pci 0000:00:09.0: setting latency timer to 64                                   
[    0.836353] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18                    
[    0.836388] pci 0000:00:0a.0: setting latency timer to 64                                   
[    0.836395] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]                                  
[    0.836397] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]                  
[    0.836398] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]                                
[    0.836400] pci_bus 0000:02: resource 1 mem: [0xfdf00000-0xfdffffff]                        
[    0.836401] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdfffffff]                    
[    0.836403] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]                                
[    0.836404] pci_bus 0000:03: resource 1 mem: [0xfe000000-0xfebfffff]                        
[    0.836405] pci_bus 0000:03: resource 2 pref mem [0xfa000000-0xfcefffff]                    
[    0.836407] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]                                
[    0.836408] pci_bus 0000:01: resource 1 mem: [0xfde00000-0xfdefffff]                        
[    0.836409] pci_bus 0000:01: resource 2 pref mem [0xcff00000-0xcfffffff]                    
[    0.836411] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]                                
[    0.836412] pci_bus 0000:05: resource 2 pref mem [0xfcf00000-0xfcffffff]                    
[    0.836413] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]                                  
[    0.836415] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]                  
[    0.836469] NET: Registered protocol family 2                                               
[    0.873408] IP route cache hash table entries: 262144 (order: 9, 2097152 
bytes)             
[    0.873917] TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)           
[    0.874894] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)                    
[    0.875291] TCP: Hash tables configured (established 262144 bind 65536)                     
[    0.875325] TCP reno registered                                                             
[    0.883426] NET: Registered protocol family 1                                               
[    0.885125] HugeTLB registered 2 MB page size, pre-allocated 0 pages                        
[    0.885267] Loading Reiser4. See www.namesys.com for a description of 
Reiser4.              
[    0.885403] msgmni has been set to 15964                                                    
[    0.885670] alg: No test for stdrng (krng)                                                  
[    0.885707] async_tx: api initialized (sync-only)                                           
[    0.885786] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)            
[    0.885840] io scheduler noop registered                                                    
[    0.885883] io scheduler cfq registered (default)                                           
[    0.886008] pci 0000:02:00.0: Boot video device                                             
[    0.886105] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X                              
[    0.886112] pcieport-driver 0000:00:02.0: setting latency timer to 64                       
[    0.886203] pcieport-driver 0000:00:09.0: irq 26 for MSI/MSI-X                              
[    0.886209] pcieport-driver 0000:00:09.0: setting latency timer to 64                       
[    0.886296] pcieport-driver 0000:00:0a.0: irq 27 for MSI/MSI-X                              
[    0.886303] pcieport-driver 0000:00:0a.0: setting latency timer to 64                       
[    0.886520] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0            
[    0.886573] ACPI: Power Button [PWRF]                                                       
[    0.886654] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1   
[    0.886726] ACPI: Power Button [PWRB]                                                       
[    0.886869] processor ACPI_CPU:00: registered as cooling_device0                            
[    0.886904] ACPI: Processor [P001] (supports 8 throttling states)                           
[    0.886999] processor ACPI_CPU:01: registered as cooling_device1                            
[    0.887067] processor ACPI_CPU:02: registered as cooling_device2                            
[    0.887135] processor ACPI_CPU:03: registered as cooling_device3                            
[    0.890986] Linux agpgart interface v0.103                                                  
[    0.891109] Driver 'sd' needs updating - please use bus_type methods                        
[    0.891192] ahci 0000:00:11.0: version 3.0                                                  
[    0.891204] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22                   
[    0.891348] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f 
impl SATA mode   
[    0.891402] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio 
slum part      
[    0.891917] scsi0 : ahci                                                                    
[    0.892050] scsi1 : ahci                                                                    
[    0.892140] scsi2 : ahci                                                                    
[    0.892229] scsi3 : ahci                                                                    
[    0.892316] scsi4 : ahci                                                                    
[    0.892406] scsi5 : ahci                                                                    
[    0.892531] ata1: SATA max UDMA/133 irq 22, PHY RDY changed                                 
[    0.892566] ata2: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff980 irq 
22            
[    0.892620] ata3: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa00 irq 
22            
[    0.892674] ata4: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa80 irq 
22            
[    0.892727] ata5: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb00 irq 
22            
[    0.892781] ata6: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb80 irq 
22            
[    0.893026] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1                          
[    0.893060] PNP: PS/2 appears to have AUX port disabled, if this is 
incorrect please boot with i8042.nopnp                                                                                 
[    0.893677] serio: i8042 KBD port at 0x60,0x64 irq 1                                        
[    0.893757] mice: PS/2 mouse device common for all mice                                     
[    0.893879] rtc_cmos 00:02: RTC can wake from S4                                            
[    0.893944] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0                           
[    0.894000] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs                   
[    0.894054] md: raid1 personality registered for level 1                                    
[    0.894088] md: raid6 personality registered for level 6                                    
[    0.894122] md: raid5 personality registered for level 5                                    
[    0.894156] md: raid4 personality registered for level 4                                    
[    0.894258] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: 
dm-devel@redhat.com
[    0.894351] cpuidle: using governor ladder                                                  
[    0.894476] usbcore: registered new interface driver hiddev                                 
[    0.894530] usbcore: registered new interface driver usbhid                                 
[    0.894563] usbhid: v2.6:USB HID core driver                                                
[    0.894637] TCP cubic registered                                                            
[    0.894670] NET: Registered protocol family 17                                              
[    0.894732] powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor 
processors (4 cpu cores) (version 2.20.00)                                                                             
[    0.894809] powernow-k8:    0 : pstate 0 (3200 MHz)                                         
[    0.894843] powernow-k8:    1 : pstate 1 (2500 MHz)                                         
[    0.895361] powernow-k8:    2 : pstate 2 (2100 MHz)                                         
[    0.895395] powernow-k8:    3 : pstate 3 (800 MHz)                                          
[    0.895799] PM: Resume from disk failed.                                                    
[    0.895891]   Magic number: 5:326:444                                                       
[    0.921708] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input2                                                                                             
[    1.210865] ata6: SATA link down (SStatus 0 SControl 300)                                   
[    1.210924] ata5: SATA link down (SStatus 0 SControl 300)                                   
[    1.210981] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                          
[    1.211036] ata3: SATA link down (SStatus 0 SControl 300)                                   
[    1.211091] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                          
[    1.217322] ata2.00: ATA-7: SAMSUNG HD502IJ, 1AA01110, max UDMA7                            
[    1.217368] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)                    
[    1.217434] ata4.00: ATA-7: SAMSUNG HD753LJ, 1AA01113, max UDMA7                            
[    1.217473] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)                   
[    1.223837] ata2.00: configured for UDMA/133                                                
[    1.223889] ata4.00: configured for UDMA/133                                                
[    1.610866] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                          
[    1.617207] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7                            
[    1.617243] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)                    
[    1.623662] ata1.00: configured for UDMA/133                                                
[    1.637999] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 
PQ: 0 ANSI: 5    
[    1.638193] sd 0:0:0:0: Attached scsi generic sg0 type 0                                    
[    1.638294] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 
GB/465 GiB)         
[    1.638328] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 
PQ: 0 ANSI: 5    
[    1.638411] sd 0:0:0:0: [sda] Write Protect is off                                          
[    1.638446] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00                                       
[    1.638456] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA                                                                                        
[    1.638461] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors: (500 
GB/465 GiB)         
[    1.638468] sd 1:0:0:0: [sdb] Write Protect is off                                          
[    1.638469] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00                                       
[    1.638478] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA                                                                                        
[    1.638516]  sdb:<5>sd 1:0:0:0: Attached scsi generic sg1 type 0                            
[    1.638614] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 
PQ: 0 ANSI: 5    
[    1.638731] sd 3:0:0:0: Attached scsi generic sg2 type 0                                    
[    1.638752] sd 3:0:0:0: [sdc] 1465149168 512-byte hardware sectors: (750 
GB/698 GiB)        
[    1.638760] sd 3:0:0:0: [sdc] Write Protect is off                                          
[    1.638762] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00                                       
[    1.638770] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA                                                                                        
[    1.638811]  sdc:<6> sda: sdc1 sdc2 sdc3 sdc4 < sdb1 sdb2 sdb3 sdb4 < sda1 
sda2 sda3 sda4 < sdb5 sdc5 sda5 sdc6 sdb6 >                                                                     
[    1.660703] sd 1:0:0:0: [sdb] Attached SCSI disk                                            
[    1.667600]  sda6 >                                                                         
[    1.667894] sd 0:0:0:0: [sda] Attached SCSI disk                                            
[    1.671362]  sdc7 >                                                                         
[    1.671684] sd 3:0:0:0: [sdc] Attached SCSI disk                                            
[    1.671725] md: Waiting for all devices to be available before autodetect                   
[    1.671759] md: If you don't use raid, use raid=noautodetect                                
[    1.671861] md: Autodetecting RAID arrays.                                                  
[    1.769826] md: Scanned 12 and added 12 devices.                                            
[    1.769861] md: autorun ...                                                                 
[    1.769894] md: considering sdc6 ...                                                        
[    1.769931] md:  adding sdc6 ...                                                            
[    1.769965] md: sdc5 has different UUID to sdc6                                             
[    1.769999] md: sdc3 has different UUID to sdc6                                             
[    1.770035] md: sdc1 has different UUID to sdc6                                             
[    1.770070] md:  adding sda6 ...                                                            
[    1.770104] md: sda5 has different UUID to sdc6                                             
[    1.770138] md: sda3 has different UUID to sdc6                                             
[    1.770172] md: sda1 has different UUID to sdc6                                             
[    1.770207] md:  adding sdb6 ...                                                            
[    1.770241] md: sdb5 has different UUID to sdc6                                             
[    1.770275] md: sdb3 has different UUID to sdc6                                             
[    1.770309] md: sdb1 has different UUID to sdc6                                             
[    1.770429] md: created md3                                                                 
[    1.770462] md: bind<sdb6>                                                                  
[    1.770500] md: bind<sda6>                                                                  
[    1.770536] md: bind<sdc6>                                                                  
[    1.770572] md: running: <sdc6><sda6><sdb6>                                                 
[    1.770708] raid5: device sdc6 operational as raid disk 2                                   
[    1.770742] raid5: device sda6 operational as raid disk 0                                   
[    1.770776] raid5: device sdb6 operational as raid disk 1                                   
[    1.770968] raid5: allocated 3220kB for md3                                                 
[    1.771021] raid5: raid level 5 set md3 active with 3 out of 3 devices, 
algorithm 2         
[    1.771071] RAID5 conf printout:                                                            
[    1.771104]  --- rd:3 wd:3                                                                  
[    1.771137]  disk 0, o:1, dev:sda6                                                          
[    1.771170]  disk 1, o:1, dev:sdb6                                                          
[    1.771203]  disk 2, o:1, dev:sdc6                                                          
[    1.771288] md: considering sdc5 ...                                                        
[    1.771324] md:  adding sdc5 ...                                                            
[    1.771358] md: sdc3 has different UUID to sdc5                                             
[    1.771392] md: sdc1 has different UUID to sdc5                                             
[    1.771427] md:  adding sda5 ...                                                            
[    1.771460] md: sda3 has different UUID to sdc5                                             
[    1.771494] md: sda1 has different UUID to sdc5                                             
[    1.771529] md:  adding sdb5 ...                                                            
[    1.771563] md: sdb3 has different UUID to sdc5                                             
[    1.771597] md: sdb1 has different UUID to sdc5                                             
[    1.771688] md: created md2                                                                 
[    1.771721] md: bind<sdb5>                                                                  
[    1.771758] md: bind<sda5>                                                                  
[    1.771794] md: bind<sdc5>                                                                  
[    1.771830] md: running: <sdc5><sda5><sdb5>                                                 
[    1.771964] raid5: device sdc5 operational as raid disk 2                                   
[    1.771998] raid5: device sda5 operational as raid disk 0                                   
[    1.772031] raid5: device sdb5 operational as raid disk 1                                   
[    1.772220] raid5: allocated 3220kB for md2                                                 
[    1.772266] raid5: raid level 5 set md2 active with 3 out of 3 devices, 
algorithm 2         
[    1.772318] RAID5 conf printout:                                                            
[    1.772351]  --- rd:3 wd:3                                                                  
[    1.772384]  disk 0, o:1, dev:sda5                                                          
[    1.772417]  disk 1, o:1, dev:sdb5                                                          
[    1.772450]  disk 2, o:1, dev:sdc5                                                          
[    1.772520] md: considering sdc3 ...                                                        
[    1.772556] md:  adding sdc3 ...                                                            
[    1.772590] md: sdc1 has different UUID to sdc3                                             
[    1.772624] md:  adding sda3 ...                                                            
[    1.772658] md: sda1 has different UUID to sdc3                                             
[    1.772693] md:  adding sdb3 ...                                                            
[    1.772727] md: sdb1 has different UUID to sdc3                                             
[    1.772819] md: created md1                                                                 
[    1.772852] md: bind<sdb3>                                                                  
[    1.772888] md: bind<sda3>                                                                  
[    1.772924] md: bind<sdc3>                                                                  
[    1.772960] md: running: <sdc3><sda3><sdb3>                                                 
[    1.773090] raid5: device sdc3 operational as raid disk 2                                   
[    1.773124] raid5: device sda3 operational as raid disk 0                                   
[    1.773157] raid5: device sdb3 operational as raid disk 1                                   
[    1.773353] raid5: allocated 3220kB for md1                                                 
[    1.773403] raid5: raid level 5 set md1 active with 3 out of 3 devices, 
algorithm 2         
[    1.773452] RAID5 conf printout:                                                            
[    1.773485]  --- rd:3 wd:3                                                                  
[    1.773518]  disk 0, o:1, dev:sda3                                                          
[    1.773551]  disk 1, o:1, dev:sdb3                                                          
[    1.773584]  disk 2, o:1, dev:sdc3                                                          
[    1.773660] md: considering sdc1 ...                                                        
[    1.773695] md:  adding sdc1 ...                                                            
[    1.773730] md:  adding sda1 ...                                                            
[    1.773764] md:  adding sdb1 ...                                                            
[    1.773797] md: created md0                                                                 
[    1.773829] md: bind<sdb1>                                                                  
[    1.773866] md: bind<sda1>                                                                  
[    1.773902] md: bind<sdc1>                                                                  
[    1.773938] md: running: <sdc1><sda1><sdb1>                                                 
[    1.774092] raid1: raid set md0 active with 3 out of 3 mirrors                              
[    1.774152] md: ... autorun DONE.                                                           
[    1.774200] md: Loading md3: /dev/sda3                                                      
[    1.774239]  md3: unknown partition table                                                   
[    1.774396] md: couldn't update array info. -22                                             
[    1.774433] md: could not bd_claim sda3.                                                    
[    1.774467] md: md_import_device returned -16                                               
[    1.774502] md: could not bd_claim sdb3.                                                    
[    1.774535] md: md_import_device returned -16                                               
[    1.774570] md: could not bd_claim sdc3.                                                    
[    1.774617] md: md_import_device returned -16                                               
[    1.774651] md: starting md3 failed                                                         
[    1.774725]  md1: unknown partition table                                                   
[    1.821104] reiser4: md1: found disk format 4.0.0.                                          
[    5.827803] VFS: Mounted root (reiser4 filesystem) readonly on device 9:1.                  
[    5.827853] Freeing unused kernel memory: 348k freed                                        
[    8.934542] udev: starting version 145                                                      
[    9.053004]  md0:<6> md2: unknown partition table                                           
[    9.113192]  unknown partition table                                                        
[   10.041736] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded                                 
[   10.041750] r8169 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18                  
[   10.041762] r8169 0000:01:00.0: setting latency timer to 64                                 
[   10.042017] r8169 0000:01:00.0: irq 28 for MSI/MSI-X                                        
[   10.042095] eth0: RTL8168c/8111c at 0xffffc20012efa000, 00:19:66:86:ce:12, 
XID 3c4000c0 IRQ 28                                                                                             
[   10.070654] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver                      
[   10.070677] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 
17               
[   10.070710] ehci_hcd 0000:00:12.2: EHCI Host Controller                                     
[   10.070949] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus 
number 1            
[   10.070973] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze 
workaround           
[   10.070989] ehci_hcd 0000:00:12.2: debug port 1                                             
[   10.071005] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000                                
[   10.081262] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00                               
[   10.081288] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002                   
[   10.081290] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1              
[   10.081291] usb usb1: Product: EHCI Host Controller                                         
[   10.081292] usb usb1: Manufacturer: Linux 2.6.30.5r4 ehci_hcd                               
[   10.081294] usb usb1: SerialNumber: 0000:00:12.2                                            
[   10.081640] usb usb1: configuration #1 chosen from 1 choice                                 
[   10.081682] hub 1-0:1.0: USB hub found                                                      
[   10.081687] hub 1-0:1.0: 6 ports detected                                                   
[   10.081811] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 
19               
[   10.081826] ehci_hcd 0000:00:13.2: EHCI Host Controller                                     
[   10.081990] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus 
number 2            
[   10.082007] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze 
workaround           
[   10.082023] ehci_hcd 0000:00:13.2: debug port 1                                             
[   10.082036] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800                                
[   10.091264] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00                               
[   10.091276] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002                   
[   10.091277] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1              
[   10.091279] usb usb2: Product: EHCI Host Controller                                         
[   10.091280] usb usb2: Manufacturer: Linux 2.6.30.5r4 ehci_hcd                               
[   10.091281] usb usb2: SerialNumber: 0000:00:13.2                                            
[   10.091348] usb usb2: configuration #1 chosen from 1 choice                                 
[   10.091377] hub 2-0:1.0: USB hub found                                                      
[   10.091381] hub 2-0:1.0: 6 ports detected                                                   
[   10.120081] Linux video capture interface: v2.00                                            
[   10.128288] bttv: driver version 0.9.18 loaded                                              
[   10.128290] bttv: using 8 buffers with 2080k (520 pages) each for capture                   
[   10.128348] bttv: Bt8xx card found (0).                                                     
[   10.128359] bttv 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21                   
[   10.128369] bttv0: Bt848 (rev 18) at 0000:05:06.0, irq: 21, latency: 128, 
mmio: 0xfcfff000  
[   10.128411] bttv0: using: Terratec TerraTV+ Version 1.0 (Bt848)/ Terra 
TValue Version 1.0/ Vobis TV-Boostar [card=25,insmod option]                                                        
[   10.128413] IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs                    
[   10.128447] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]                       
[   10.387101] usb 1-2: new high speed USB device using ehci_hcd and address 2
[   10.512120] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608
[   10.512122] usb 1-2: New USB device strings: Mfr=0, Product=1, 
SerialNumber=0
[   10.512124] usb 1-2: Product: USB2.0 Hub
[   10.512170] usb 1-2: configuration #1 chosen from 1 choice
[   10.512613] hub 1-2:1.0: USB hub found
[   10.512866] hub 1-2:1.0: 4 ports detected
[   10.781873] usb 1-2.2: new low speed USB device using ehci_hcd and address 
3
[   10.871357] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518
[   10.871358] usb 1-2.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[   10.871360] usb 1-2.2: Product: USB Receiver
[   10.871361] usb 1-2.2: Manufacturer: Logitech
[   10.871391] usb 1-2.2: configuration #1 chosen from 1 choice
[   10.881593] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input3
[   10.881630] generic-usb 0003:046D:C518.0001: input,hidraw0: USB HID v1.11 
Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input0
[   10.887013] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.1/input/input4
[   10.887061] generic-usb 0003:046D:C518.0002: input,hiddev96,hidraw1: USB 
HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input1
[   11.130018] bttv0: tea5757: read timeout
[   11.130020] bttv0: tuner type=5
[   11.148620] All bytes are equal. It is not a TEA5767
[   11.148649] tuner 0-0060: chip found @ 0xc0 (bt848 #0 [sw])
[   11.151481] tuner-simple 0-0060: creating new instance
[   11.151484] tuner-simple 0-0060: type set to 5 (Philips PAL_BG (FI1216 and 
compatibles))
[   11.163632] bttv0: audio absent, no audio device found!
[   11.163694] bttv0: registered device video0
[   11.163721] bttv0: registered device vbi0
[   11.491112] reiser4: md2: found disk format 4.0.0.
[   13.287507] reiser4: md3: found disk format 4.0.0.
[   54.579781] reiser4: sdc7: found disk format 4.0.0.
[   66.925455] Adding 7815612k swap on /dev/sda2.  Priority:1 extents:1 
across:7815612k
[   66.968051] Adding 7815612k swap on /dev/sdb2.  Priority:1 extents:1 
across:7815612k
[   67.009103] Adding 7815612k swap on /dev/sdc2.  Priority:1 extents:1 
across:7815612k
[   67.688099] w83627ehf: Found W83627EHG chip at 0x290
[   68.078974] r8169: eth0: link up
[   68.078984] r8169: eth0: link up
[   70.853121] EMU10K1_Audigy 0000:05:08.0: PCI INT A -> GSI 23 (level, low) -
> IRQ 23
[   70.860129] Audigy2 value: Special config.
[   72.279621] fglrx: module license 'Proprietary. (C) 2002 - ATI 
Technologies, Starnberg, GERMANY' taints kernel.
[   72.279629] Disabling lock debugging due to kernel taint
[   72.328125] [fglrx] Maximum main memory to use for locked dma buffers: 7749 
MBytes.
[   72.328388] [fglrx]   vendor: 1002 device: 9501 count: 1
[   72.329030] [fglrx] ioport: bar 4, base 0xc000, size: 0x100
[   72.329052] pci 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   72.329061] pci 0000:02:00.0: setting latency timer to 64
[   72.329531] [fglrx] Kernel PAT support is enabled
[   72.329567] [fglrx] module loaded - fglrx 8.66.2 [Aug 25 2009] with 1 
minors
[   72.502484] fglrx_pci 0000:02:00.0: irq 29 for MSI/MSI-X
[   72.502838] [fglrx] Firegl kernel thread PID: 3735
[   74.588819] [fglrx] Gart USWC size:1279 M.
[   74.588822] [fglrx] Gart cacheable size:508 M.
[   74.588826] [fglrx] Reserved FB block: Shared offset:0, size:1000000
[   74.588827] [fglrx] Reserved FB block: Unshared offset:fbff000, size:401000
[   74.588829] [fglrx] Reserved FB block: Unshared offset:1fffc000, size:4000
[  132.415785] reiser4[kmail(3916)]: disable_write_barrier 
(fs/reiser4/wander.c:235)[zam-1055]:
[  132.415790] NOTICE: md3 does not support write barriers, using synchronous 
write instead.

same result.

Glück Auf,
Volker

ps.
putting back the scsi card would be difficult - so if it is not really needed I 
would prefer to skip that step.
