Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbZERPMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbZERPMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbZERPMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:12:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:32918 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZERPMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:12:18 -0400
Subject: Re: tip: patches in git for irq and numa
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4A1178D5.5050900@kernel.org>
References: <4A05269D.8000701@kernel.org> <20090511095022.GA23121@elte.hu>
	 <20090511163158.c4e4d334.akpm@linux-foundation.org>
	 <20090512090704.GC18004@elte.hu> <4A0A6700.3070100@kernel.org>
	 <20090513133635.GB7384@elte.hu> <4A0AFA6E.5050200@kernel.org>
	 <20090515173521.GA29647@elte.hu> <4A0DE0ED.6090402@kernel.org>
	 <20090518072952.GA12460@elte.hu> <1242654650.26820.429.camel@twins>
	 <4A1178D5.5050900@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 May 2009 17:11:17 +0200
Message-Id: <1242659477.26820.433.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 08:03 -0700, Yinghai Lu wrote:
> Peter Zijlstra wrote:
>  
> > commit b9c61b70075c87a8612624736faf4a2de5b1ed30
> > Author: Yinghai Lu <yinghai@kernel.org>
> > Date:   Wed May 6 10:10:06 2009 -0700
> > 
> >     x86/pci: update pirq_enable_irq() to setup io apic routing
> >     
> >     So we can set io apic routing only when enabling the device irq.
> >     
> >     This is advantageous for IRQ descriptor allocation affinity: if we set up
> >     the IO-APIC entry later, we have a chance to allocate the IRQ descriptor
> >     later and know which device it is on and can set affinity accordingly.
> >     
> >     [ Impact: standardize/enhance irq-enabling sequence for mptable irqs ]
> 
> can you post whole bootlog?

See below

> need to figure out 32bit/64bit? ACPI is disabled? MPtable is used?

64bit, default acpi default mptable

> also please check if pci=routeirq help to fix the problem.

It does not.

[    0.000000] Linux version 2.6.30-rc3 (root@twins) (gcc version 4.3.1 20080510 (prerelease) (GCC) ) #984 SMP PREEMPT Mon May 18 15:46:49 CEST 2009
[    0.000000] Command line: ro root=UUID=2678f5ee-ec1c-4be4-9fdd-ee4f1de115fa debug ignore_loglevel sysrq_always_enabled console=ttyS0,115200 earlyprintk=serial,ttyS0,115200rq_always_enabled console=ttyS0,115200 earlyprintk=seria
[    0.000000] KERNEL supported cpus:                                          
[    0.000000]   Intel GenuineIntel   [Linux-bzImage, setup=0x2e00, size=0x27cbb0]
[    0.000000]   AMD AuthenticAMD                                                 
[    0.000000]   Centaur CentaurHauls                                             
[    0.000000] BIOS-provided physical RAM map:                                    
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)           
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)         
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)         
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)           
[    0.000000]  BIOS-e820: 000000007fff0000 - 000000007fffe000 (ACPI data)        
[    0.000000]  BIOS-e820: 000000007fffe000 - 0000000080000000 (ACPI NVS)         
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec03000 (reserved)         
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)         
[    0.000000] debug: ignoring loglevel setting.                                  
[    0.000000] console [earlyser0] enabled                                        
[    0.000000] DMI 2.3 present.                                                   
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.  
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)-2.6.30-rc3.img
[    0.000000] last_pfn = 0x7fff0 max_arch_pfn = 0x100000000                                                
[    0.000000] MTRR default type: uncachable                                                                
[    0.000000] MTRR fixed ranges enabled:                                                                   
[    0.000000]   00000-9FFFF write-back                                                                     
[    0.000000]   A0000-EFFFF uncachable                                                                     
[    0.000000]   F0000-FFFFF write-protect                                                                  
[    0.000000] MTRR variable ranges enabled:                                                                
[    0.000000]   0 base 0000000000 mask FF80000000 write-back                                               
[    0.000000]   1 disabled                                                                                 
[    0.000000]   2 disabled                                                                                 
[    0.000000]   3 disabled                                                                                 
[    0.000000]   4 disabled                                                                                 
[    0.000000]   5 disabled                                                                                 
[    0.000000]   6 disabled                                                                                 
[    0.000000]   7 disabled                                                                                 
[    0.000000] init_memory_mapping: 0000000000000000-000000007fff0000                                       
[    0.000000]  0000000000 - 007fe00000 page 2M                                                             
[    0.000000]  007fe00000 - 007fff0000 page 4k                                                             
[    0.000000] kernel direct mapping tables up to 7fff0000 @ 10000-14000                                    
[    0.000000] RAMDISK: 37d54000 - 37fef31b                                                                 
[    0.000000] ACPI: RSDP 00000000000f7470 00024 (v02 ACPIAM)                                               
[    0.000000] ACPI: XSDT 000000007fff0100 00044 (v01 A M I  OEMXSDT  09000625 MSFT 00000097)               
[    0.000000] ACPI: FACP 000000007fff0290 000F4 (v03 A M I  OEMFACP  09000625 MSFT 00000097)               
[    0.000000] ACPI: DSDT 000000007fff0400 03018 (v01  0AAAA 0AAAA000 00000000 INTL 02002026)               
[    0.000000] ACPI: FACS 000000007fffe000 00040                                                            
[    0.000000] ACPI: APIC 000000007fff0390 00070 (v01 A M I  OEMAPIC  09000625 MSFT 00000097)               
[    0.000000] ACPI: OEMB 000000007fffe040 00056 (v01 A M I  AMI_OEM  09000625 MSFT 00000097)               
[    0.000000] ACPI: SSDT 000000007fff3420 00248 (v01 A M I  POWERNOW 00000001 AMD  00000001)               
[    0.000000] ACPI: Local APIC address 0xfee00000                                                          
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 007fff0000]                                 
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]                
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]                
[    0.000000]   #2 [0000200000 - 0001231e10]    TEXT DATA BSS ==> [0000200000 - 0001231e10]                
[    0.000000]   #3 [0037d54000 - 0037fef31b]          RAMDISK ==> [0037d54000 - 0037fef31b]                
[    0.000000]   #4 [000009d800 - 0000100000]    BIOS reserved ==> [000009d800 - 0000100000]                
[    0.000000]   #5 [0001232000 - 0001232200]              BRK ==> [0001232000 - 0001232200]                
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]                
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780                                               
[    0.000000]  [ffffe20000000000-ffffe200033fffff] PMD -> [ffff880001400000-ffff8800047fffff] on node 0    
[    0.000000] Zone PFN ranges:                                                                             
[    0.000000]   DMA      0x00000010 -> 0x00001000                                                          
[    0.000000]   DMA32    0x00001000 -> 0x00100000                                                          
[    0.000000]   Normal   0x00100000 -> 0x00100000                                                          
[    0.000000] Movable zone start PFN for each node                                                         
[    0.000000] early_node_map[2] active PFN ranges                                                          
[    0.000000]     0: 0x00000010 -> 0x0000009d                                                              
[    0.000000]     0: 0x00000100 -> 0x0007fff0                                                              
[    0.000000] On node 0 totalpages: 524157                                                                 
[    0.000000]   DMA zone: 104 pages used for memmap                                                        
[    0.000000]   DMA zone: 103 pages reserved                                                               
[    0.000000]   DMA zone: 3774 pages, LIFO batch:0                                                         
[    0.000000]   DMA32 zone: 13208 pages used for memmap                                                    
[    0.000000]   DMA32 zone: 506968 pages, LIFO batch:31                                                    
[    0.000000] Detected use of extended apic ids on hypertransport bus                                      
[    0.000000] ACPI: PM-Timer IO Port: 0x508                                                                
[    0.000000] ACPI: Local APIC address 0xfee00000                                                          
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)                                           
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)                                           
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])                                          
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])                                      
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-15                                
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec01000] gsi_base[16])                                     
[    0.000000] IOAPIC[1]: apic_id 3, version 0, address 0xfec01000, GSI 16-31                               
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec02000] gsi_base[32])                                     
[    0.000000] IOAPIC[2]: apic_id 4, version 0, address 0xfec02000, GSI 32-47                               
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)                                     
[    0.000000] ACPI: IRQ0 used by override.                                                                 
[    0.000000] ACPI: IRQ2 used by override.                                                                 
[    0.000000] ACPI: IRQ9 used by override.                                                                 
[    0.000000] Using ACPI (MADT) for SMP configuration information                                          
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs                                                         
[    0.000000] nr_irqs_gsi: 48                                                                              
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)                       
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1                                       
[    0.000000] PERCPU: Embedded 473 pages at ffff880004800000, static data 1907424 bytes                    
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 510742                  
[    0.000000] Kernel command line: ro root=UUID=2678f5ee-ec1c-4be4-9fdd-ee4f1de115fa debug ignore_loglevel sysrq_always_enabled console=ttyS0,115200 earlyprintk=serial,ttyS0,115200                                                                                                                         
[    0.000000] debug: sysrq always enabled.                                                                                                            
[    0.000000] Initializing CPU#0                                                                                                                      
[    0.000000] NR_IRQS:512                                                                                                                             
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)                                                                                   
[    0.000000] Extended CMOS year: 2000                                                                                                                
[    0.000000] Fast TSC calibration failed                                                                                                             
[    0.000000] TSC: PIT calibration matches PMTIMER. 1 loops                                                                                           
[    0.000000] Detected 2393.995 MHz processor.                                                                                                        
[    0.000999] Console: colour VGA+ 80x25                                                                                                              
[    0.000999] console handover: boot [earlyser0] -> real [ttyS0]                                                                                      
[    0.000999] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar                                                                
[    0.000999] ... MAX_LOCKDEP_SUBCLASSES:  8                                                                                                          
[    0.000999] ... MAX_LOCK_DEPTH:          48                                                                                                         
[    0.000999] ... MAX_LOCKDEP_KEYS:        8191                                                                                                       
[    0.000999] ... CLASSHASH_SIZE:          4096                                                                                                       
[    0.000999] ... MAX_LOCKDEP_ENTRIES:     8192                                                                                                       
[    0.000999] ... MAX_LOCKDEP_CHAINS:      16384                                                                                                      
[    0.000999] ... CHAINHASH_SIZE:          8192                                                                                                       
[    0.000999]  memory used by lock dependency info: 5119 kB                                                                                           
[    0.000999]  per task-struct memory footprint: 2688 bytes                                                                                           
[    0.000999] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)                                                                       
[    0.000999] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)                                                                        
[    0.000999] Checking aperture...                                                                                                                    
[    0.000999] No AGP bridge found                                                                                                                     
[    0.000999] Node 0: aperture @ 202a000000 size 32 MB                                                                                                
[    0.000999] Aperture beyond 4GB. Ignoring.                                                                                                          
[    0.000999] Memory: 2016276k/2097088k available (3225k kernel code, 460k absent, 79688k reserved, 2051k data, 2180k init)                           
[    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1                                                                 
[    0.001012] Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.99 BogoMIPS (lpj=2393995)                               
[    0.003038] Security Framework initialized                                                                                                          
[    0.004112] Mount-cache hash table entries: 256                                                                                                     
[    0.007530] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)                                                                       
[    0.008002] CPU: L2 Cache: 1024K (64 bytes/line)                                                                                                    
[    0.009002] tseg: 0000000000                                                                                                                        
[    0.010070] CPU: Physical Processor ID: 0                                                                                                           
[    0.011001] CPU: Processor Core ID: 0                                                                                                               
[    0.012010] using C1E aware idle routine                                                                                                            
[    0.013031] ACPI: Core revision 20090320                                                                                                            
[    0.022005] ftrace: converting mcount calls to 0f 1f 44 00 00                                                                                       
[    0.023002] ftrace: allocating 13675 entries in 54 pages                                                                                            
[    0.025212] Setting APIC routing to flat                                                                                                            
[    0.026741] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1                                                                                    
[    0.037023] CPU0: Dual-Core AMD Opteron(tm) Processor 1216 stepping 02                                                                              
[    0.040993] lockdep: fixing up alternatives.                                                                                                        
[    0.041182] Booting processor 1 APIC 0x1 ip 0x6000                                                                                                  
[    0.000999] Initializing CPU#1                                                                                                                      
[    0.000999] Calibrating delay using timer specific routine.. 4791.25 BogoMIPS (lpj=2395625)                                                         
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)                                                                       
[    0.000999] CPU: L2 Cache: 1024K (64 bytes/line)                                                                                                    
[    0.000999] CPU: Physical Processor ID: 0                                                                                                           
[    0.000999] CPU: Processor Core ID: 1                                                                                                               
[    0.114121] CPU1: Dual-Core AMD Opteron(tm) Processor 1216 stepping 02                                                                              
[    0.117018] Brought up 2 CPUs                                                                                                                       
[    0.117985] Total of 2 processors activated (9579.24 BogoMIPS).                                                                                     
[    0.120028] CPU0 attaching sched-domain:                                                                                                            
[    0.120984]  domain 0: span 0-1 level CPU                                                                                                           
[    0.122983]   groups: 0 1                                                                                                                           
[    0.124554] CPU1 attaching sched-domain:                                                                                                            
[    0.124984]  domain 0: span 0-1 level CPU                                                                                                           
[    0.126982]   groups: 1 0                                                                                                                           
[    0.130206] net_namespace: 784 bytes                                                                                                                
[    0.131536] NET: Registered protocol family 16                                                                                                      
[    0.133093] node 0 link 0: io port [1000, ffffff]                                                                                                   
[    0.133984] TOM: 0000000080000000 aka 2048M                                                                                                         
[    0.134993] node 0 link 0: mmio [a0000, bffff]                                                                                                      
[    0.136165] node 0 link 0: mmio [80000000, ff70ffff]                                                                                                
[    0.137165] bus: [00,ff] on node 0 link 0                                                                                                           
[    0.137981] bus: 00 index 0 io port: [0, ffff]                                                                                                      
[    0.138981] bus: 00 index 1 mmio: [a0000, bffff]                                                                                                    
[    0.139981] bus: 00 index 2 mmio: [80000000, fcffffffff]                                                                                            
[    0.141025] ACPI: bus type pci registered                                                                                                           
[    0.142047] PCI: Using configuration type 1 for base access                                                                                         
[    0.151063] bio: create slab <bio-0> at 0                                                                                                           
[    0.154745] ACPI: EC: Look up EC in DSDT                                                                                                            
[    0.169950] ACPI: Interpreter enabled                                                                                                               
[    0.169978] ACPI: (supports S0 S1 S5)                                                                                                               
[    0.172248] ACPI: Using IOAPIC for interrupt routing                                                                                                
[    0.192179] ACPI Warning (tbutils-0246): Incorrect checksum in table [OEMB] - 8D, should be 82 [20090320]                                           
[    0.195298] ACPI: No dock devices found.                                                                                                            
[    0.196053] ACPI: PCI Root Bridge [PCI0] (0000:00)                                                                                                  
[    0.197128] pci 0000:00:01.0: Enabling HT MSI Mapping                                                                                               
[    0.198136] pci 0000:00:02.1: reg 10 io port: [0x1f0-0x1f7]                                                                                         
[    0.198983] pci 0000:00:02.1: reg 14 io port: [0x3f4-0x3f7]                                                                                         
[    0.199977] pci 0000:00:02.1: reg 18 io port: [0x170-0x177]                                                                                         
[    0.200977] pci 0000:00:02.1: reg 1c io port: [0x374-0x377]                                                                                         
[    0.201977] pci 0000:00:02.1: reg 20 io port: [0xffa0-0xffaf]                                                                                       
[    0.203108] pci 0000:00:03.0: reg 10 32bit mmio: [0xff6b4000-0xff6b4fff]                                                                            
[    0.203977] pci 0000:00:03.0: reg 14 io port: [0xe000-0xe0ff]                                                                                       
[    0.205976] pci 0000:00:03.1: reg 10 32bit mmio: [0xff6b5000-0xff6b5fff]                                                                            
[    0.206977] pci 0000:00:03.1: reg 14 io port: [0xe400-0xe4ff]                                                                                       
[    0.208065] pci 0000:00:03.2: reg 10 32bit mmio: [0xff6b6000-0xff6b6fff]                                                                            
[    0.208977] pci 0000:00:03.2: reg 14 io port: [0xe800-0xe8ff]                                                                                       
[    0.210022] pci 0000:00:03.2: supports D1 D2                                                                                                        
[    0.210970] pci 0000:00:03.2: PME# supported from D0 D1 D2 D3hot                                                                                    
[    0.211973] pci 0000:00:03.2: PME# disabled                                                                                                         
[    0.213034] pci 0000:00:04.0: reg 10 32bit mmio: [0xff680000-0xff69ffff]                                                                            
[    0.213976] pci 0000:00:04.0: reg 14 32bit mmio: [0xff660000-0xff67ffff]                                                                            
[    0.214976] pci 0000:00:04.0: reg 18 io port: [0xdc00-0xdc3f]                                                                                       
[    0.215993] pci 0000:00:04.0: reg 30 32bit mmio: [0xff640000-0xff65ffff]                                                                            
[    0.216996] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold                                                                                   
[    0.217972] pci 0000:00:04.0: PME# disabled                                                                                                         
[    0.219023] pci 0000:00:05.0: reg 10 32bit mmio: [0xff620000-0xff63ffff]                                                                            
[    0.219975] pci 0000:00:05.0: reg 14 32bit mmio: [0xff600000-0xff61ffff]                                                                            
[    0.220974] pci 0000:00:05.0: reg 18 io port: [0xd880-0xd8bf]                                                                                       
[    0.221992] pci 0000:00:05.0: reg 30 32bit mmio: [0xff5e0000-0xff5fffff]                                                                            
[    0.222996] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold                                                                                   
[    0.223971] pci 0000:00:05.0: PME# disabled                                                                                                         
[    0.225012] pci 0000:00:06.0: reg 10 32bit mmio: [0xf8000000-0xfbffffff]                                                                            
[    0.225974] pci 0000:00:06.0: reg 14 32bit mmio: [0xff6c0000-0xff6fffff]                                                                            
[    0.226973] pci 0000:00:06.0: reg 18 io port: [0xec00-0xec7f]                                                                                       
[    0.229001] pci 0000:00:06.0: supports D1 D2                                                                                                        
[    0.230339] pci 0000:01:0e.0: reg 10 io port: [0xc080-0xc087]                                                                                       
[    0.230971] pci 0000:01:0e.0: reg 14 io port: [0xc000-0xc003]                                                                                       
[    0.231971] pci 0000:01:0e.0: reg 18 io port: [0xbc00-0xbc07]                                                                                       
[    0.232971] pci 0000:01:0e.0: reg 1c io port: [0xb880-0xb883]                                                                                       
[    0.233971] pci 0000:01:0e.0: reg 20 io port: [0xb800-0xb80f]                                                                                       
[    0.234971] pci 0000:01:0e.0: reg 24 32bit mmio: [0xff3fe000-0xff3fffff]                                                                            
[    0.235970] pci 0000:01:0e.0: reg 30 32bit mmio: [0xff3c0000-0xff3dffff]                                                                            
[    0.237031] pci 0000:01:0e.1: reg 10 io port: [0xcc00-0xcc07]                                                                                       
[    0.237970] pci 0000:01:0e.1: reg 14 io port: [0xc880-0xc883]                                                                                       
[    0.238970] pci 0000:01:0e.1: reg 18 io port: [0xc800-0xc807]                                                                                       
[    0.239970] pci 0000:01:0e.1: reg 1c io port: [0xc480-0xc483]                                                                                       
[    0.240969] pci 0000:01:0e.1: reg 20 io port: [0xc400-0xc40f]                                                                                       
[    0.242057] pci 0000:00:01.0: bridge io port: [0xb000-0xcfff]                                                                                       
[    0.242967] pci 0000:00:01.0: bridge 32bit mmio: [0xff300000-0xff3fffff]                                                                            
[    0.244072] pci_bus 0000:00: on NUMA node 0                                                                                                         
[    0.244971] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]                                                                                     
[    0.246176] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]                                                                                
[    0.247020] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1.P1P2._PRT]                                                                           
[    0.259175] ACPI: PCI Interrupt Link [LN00] (IRQs 3 4 5 7 9 11 12 14 15) *0, disabled.                                                              
[    0.263312] ACPI: PCI Interrupt Link [LN01] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.268128] ACPI: PCI Interrupt Link [LN02] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.273308] ACPI: PCI Interrupt Link [LN03] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.278310] ACPI: PCI Interrupt Link [LN04] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.283307] ACPI: PCI Interrupt Link [LN05] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.288101] ACPI: PCI Interrupt Link [LN06] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.293306] ACPI: PCI Interrupt Link [LN07] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.298123] ACPI: PCI Interrupt Link [LN08] (IRQs 1 3 4 5 6 7 *9 11 12 14 15)                                                                       
[    0.302401] ACPI: PCI Interrupt Link [LN09] (IRQs 1 3 4 *5 6 7 9 11 12 14 15)                                                                       
[    0.306083] ACPI: PCI Interrupt Link [LN10] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.311304] ACPI: PCI Interrupt Link [LN11] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.316141] ACPI: PCI Interrupt Link [LN12] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.321350] ACPI: PCI Interrupt Link [LN13] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.327046] ACPI: PCI Interrupt Link [LN14] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.332351] ACPI: PCI Interrupt Link [LN15] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.337171] ACPI: PCI Interrupt Link [LN16] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.342350] ACPI: PCI Interrupt Link [LN17] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.347169] ACPI: PCI Interrupt Link [LN18] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.352351] ACPI: PCI Interrupt Link [LN19] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.357351] ACPI: PCI Interrupt Link [LN20] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.362352] ACPI: PCI Interrupt Link [LN21] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.367172] ACPI: PCI Interrupt Link [LN22] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.372351] ACPI: PCI Interrupt Link [LN23] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.377352] ACPI: PCI Interrupt Link [LN24] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.382352] ACPI: PCI Interrupt Link [LN25] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.387350] ACPI: PCI Interrupt Link [LN26] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.392129] ACPI: PCI Interrupt Link [LN27] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.398168] ACPI: PCI Interrupt Link [LN28] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.403352] ACPI: PCI Interrupt Link [LN29] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.408351] ACPI: PCI Interrupt Link [LN30] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                                                          
[    0.414039] ACPI: PCI Interrupt Link [LNUS] (IRQs *10)                                                                                              
[    0.416360] ACPI: PCI Interrupt Link [LNSA] (IRQs *11)                                                                                              
[    0.419075] SCSI subsystem initialized                                                                                                              
[    0.421058] libata version 3.00 loaded.                                                                                                             
[    0.423077] usbcore: registered new interface driver usbfs                                                                                          
[    0.424055] usbcore: registered new interface driver hub                                                                                            
[    0.425038] usbcore: registered new device driver usb                                                                                               
[    0.426115] PCI: Using ACPI for IRQ routing                                                                                                         
[    0.436018] pnp: PnP ACPI init                                                                                                                      
[    0.437034] ACPI: bus type pnp registered                                                                                                           
[    0.445279] pnp: PnP ACPI: found 12 devices                                                                                                         
[    0.446003] ACPI: ACPI bus type pnp unregistered                                                                                                    
[    0.447021] system 00:08: ioport range 0x800-0x87f has been reserved                                                                                
[    0.448003] system 00:08: ioport range 0xa80-0xa8f has been reserved                                                                                
[    0.449012] system 00:09: ioport range 0x4d0-0x4d1 has been reserved                                                                                
[    0.450003] system 00:09: ioport range 0xc00-0xc01 has been reserved                                                                                
[    0.451003] system 00:09: ioport range 0xcd6-0xcd7 has been reserved                                                                                
[    0.452006] system 00:09: ioport range 0xcd4-0xcd5 has been reserved                                                                                
[    0.453003] system 00:09: ioport range 0xcd8-0xcdf has been reserved                                                                                
[    0.454003] system 00:09: ioport range 0x40b-0x40b has been reserved                                                                                
[    0.455003] system 00:09: ioport range 0x4d6-0x4d6 has been reserved                                                                                
[    0.456003] system 00:09: ioport range 0xc06-0xc07 has been reserved                                                                                
[    0.457003] system 00:09: ioport range 0xc14-0xc14 has been reserved                                                                                
[    0.458003] system 00:09: ioport range 0xc49-0xc49 has been reserved                                                                                
[    0.459003] system 00:09: ioport range 0xc4a-0xc4a has been reserved                                                                                
[    0.460003] system 00:09: ioport range 0xc50-0xc51 has been reserved                                                                                
[    0.461003] system 00:09: ioport range 0xc52-0xc52 has been reserved                                                                                
[    0.462003] system 00:09: ioport range 0xc6c-0xc6c has been reserved                                                                                
[    0.463003] system 00:09: ioport range 0xc6f-0xc6f has been reserved                                                                                
[    0.465003] system 00:09: ioport range 0x500-0x57f has been reserved                                                                                
[    0.466012] system 00:0a: ioport range 0x580-0x58f has been reserved                                                                                
[    0.467003] system 00:0a: ioport range 0x590-0x593 has been reserved                                                                                
[    0.468003] system 00:0a: ioport range 0x700-0x703 has been reserved                                                                                
[    0.469003] system 00:0a: ioport range 0xca0-0xcaf has been reserved                                                                                
[    0.470004] system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved                                                                       
[    0.471003] system 00:0a: iomem range 0xfec01000-0xfec01fff has been reserved                                                                       
[    0.472003] system 00:0a: iomem range 0xfec02000-0xfec02fff has been reserved                                                                       
[    0.473003] system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved                                                                       
[    0.474003] system 00:0a: iomem range 0xfff00000-0xffffffff has been reserved                                                                       
[    0.475003] system 00:0a: iomem range 0xff780000-0xffbfffff has been reserved                                                                       
[    0.476003] system 00:0a: iomem range 0xfebfe000-0xfebfefff has been reserved                                                                       
[    0.477012] system 00:0b: iomem range 0x0-0x9ffff could not be reserved                                                                             
[    0.478003] system 00:0b: iomem range 0xe0000-0xfffff could not be reserved                                                                         
[    0.479004] system 00:0b: iomem range 0x100000-0x7fffffff could not be reserved                                                                     
[    0.486501] pci 0000:01:0d.0: PCI bridge, secondary bus 0000:02                                                                                     
[    0.487022] Switched to high resolution mode on CPU 0                                                                                               
[    0.487213] Switched to high resolution mode on CPU 1                                                                                               
[    0.497094] pci 0000:01:0d.0:   IO window: disabled                                                                                                 
[    0.501967] pci 0000:01:0d.0:   MEM window: disabled                                                                                                
[    0.506925] pci 0000:01:0d.0:   PREFETCH window: disabled                                                                                           
[    0.512316] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01                                                                                     
[    0.518227] pci 0000:00:01.0:   IO window: 0xb000-0xcfff                                                                                            
[    0.523531] pci 0000:00:01.0:   MEM window: 0xff300000-0xff3fffff                                                                                   
[    0.529613] pci 0000:00:01.0:   PREFETCH window: disabled                                                                                           
[    0.535026] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]                                                                                          
[    0.540500] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]                                                                          
[    0.547360] pci_bus 0000:01: resource 0 io:  [0xb000-0xcfff]                                                                                        
[    0.553601] pci_bus 0000:01: resource 1 mem: [0xff300000-0xff3fffff]                                                                                
[    0.559941] pci_bus 0000:01: resource 2 mem: [0x0-0x0]                                                                                              
[    0.565069] pci_bus 0000:01: resource 3 mem: [0x0-0x0]                                                                                              
[    0.570199] pci_bus 0000:02: resource 0 mem: [0x0-0x0]                                                                                              
[    0.575327] pci_bus 0000:02: resource 1 mem: [0x0-0x0]                                                                                              
[    0.580454] pci_bus 0000:02: resource 2 mem: [0x0-0x0]                                                                                              
[    0.585581] pci_bus 0000:02: resource 3 mem: [0x0-0x0]                                                                                              
[    0.590794] NET: Registered protocol family 2                                                                                                       
[    0.607200] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)                                                                       
[    0.616062] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)                                                                   
[    0.625753] TCP bind hash table entries: 32768 (order: 9, 2359296 bytes)                                                                            
[    0.636466] TCP: Hash tables configured (established 262144 bind 32768)                                                                             
[    0.643108] TCP reno registered                                                                                                                     
[    0.649199] NET: Registered protocol family 1                                                                                                       
[    0.653870] checking if image is initramfs...                                                                                                       
[    0.740649] rootfs image is initramfs; unpacking...                                                                                                 
[    0.745594] Freeing initrd memory: 2668k freed                                                                                                      
[    0.755727] audit: initializing netlink socket (disabled)                                                                                           
[    0.761216] type=2000 audit(1242654497.761:1): initialized                                                                                          
[    0.769272] HugeTLB registered 2 MB page size, pre-allocated 0 pages                                                                                
[    0.783215] VFS: Disk quotas dquot_6.5.2                                                                                                            
[    0.787383] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)                                                                               
[    0.795622] msgmni has been set to 3944                                                                                                             
[    0.800880] alg: No test for stdrng (krng)                                                                                                          
[    0.805667] io scheduler noop registered                                                                                                            
[    0.809591] io scheduler anticipatory registered                                                                                                    
[    0.814202] io scheduler deadline registered                                                                                                        
[    0.818482] io scheduler cfq registered (default)                                                                                                   
[    0.823242] disabled boot interrupts on PCI device0x1166:0x0205                                                                                     
[    0.871059] pci 0000:00:06.0: Boot video device                                                                                                     
[    0.876105] pci_hotplug: PCI Hot Plug PCI Core version: 0.5                                                                                         
[    0.882441] processor ACPI_CPU:00: registered as cooling_device0                                                                                    
[    0.888596] processor ACPI_CPU:01: registered as cooling_device1                                                                                    
[    0.907665] Non-volatile memory driver v1.3                                                                                                         
[    0.911908] Linux agpgart interface v0.103                                                                                                          
[    0.916348] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled                                                                                 
�[    1.167644] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A                                                                                   
[    1.418642] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A                                                                                    
[    1.425803] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A                                                                                         
[    1.431735] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A                                                                                         
[    1.441852] brd: module loaded                                                                                                                      
[    1.445211] Driver 'sd' needs updating - please use bus_type methods                                                                                
[    1.451839] sata_svw 0000:01:0e.0: version 2.3                                                                                                      
[    1.456333] sata_svw 0000:01:0e.0: PCI INT A -> GSI 11 (level, low) -> IRQ 11                                                                       
[    1.463639] scsi0 : sata_svw                                                                                                                        
[    1.466949] scsi1 : sata_svw                                                                                                                        
[    1.470022] scsi2 : sata_svw                                                                                                                        
[    1.473090] scsi3 : sata_svw                                                                                                                        
[    1.476112] ata1: SATA max UDMA/133 mmio m8192@0xff3fe000 port 0xff3fe000 irq 11                                                                    
[    1.483490] ata2: SATA max UDMA/133 mmio m8192@0xff3fe000 port 0xff3fe100 irq 11                                                                    
[    1.490870] ata3: SATA max UDMA/133 mmio m8192@0xff3fe000 port 0xff3fe200 irq 11                                                                    
[    1.498247] ata4: SATA max UDMA/133 mmio m8192@0xff3fe000 port 0xff3fe300 irq 11                                                                    
[    1.505712] sata_svw 0000:01:0e.1: PCI INT A -> GSI 11 (level, low) -> IRQ 11                                                                       
[    1.513536] scsi4 : pata_serverworks                                                                                                                
[    1.517323] scsi5 : pata_serverworks                                                                                                                
[    1.521046] ata5: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14                                                                          
[    1.527921] ata6: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15                                                                          
[    1.535032] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI                                                                               
[    1.541460] Copyright (c) 1999-2006 Intel Corporation.                                                                                              
[    1.546627] e1000 0000:00:04.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24                                                                          
[    1.690370] ata5.00: ATAPI: TEAC DV-516G, F4S7, max UDMA/33                                                                                         
[    1.699343] ata5.00: configured for UDMA/33                                                                                                         
[    1.834378] e1000: 0000:00:04.0: e1000_probe: (PCI:33MHz:32-bit) 00:e0:81:72:62:74                                                                  
[    1.942047] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)                                                                                  
[    1.993659] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection                                                                          
[    2.000541] e1000 0000:00:05.0: PCI INT A -> GSI 25 (level, low) -> IRQ 25                                                                          
[    2.271681] e1000: 0000:00:05.0: e1000_probe: (PCI:33MHz:32-bit) 00:e0:81:72:62:75                                                                  
[    2.443651] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection                                                                          
[    2.450618] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4                                                                                   
[    2.456700] e1000e: Copyright (c) 1999-2008 Intel Corporation.                                                                                      
[    2.462659] console [netcon0] enabled                                                                                                               
[    2.466320] netconsole: network logging started                                                                                                     
[    2.471178] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver                                                                              
[    2.477720] ehci_hcd 0000:00:03.2: PCI INT A -> GSI 10 (level, low) -> IRQ 10                                                                       
[    2.484849] ehci_hcd 0000:00:03.2: EHCI Host Controller                                                                                             
[    2.492188] ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1                                                                    
[    2.520055] ehci_hcd 0000:00:03.2: irq 10, io mem 0xff6b6000                                                                                        
[    2.531045] ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00                                                                                       
[    2.537344] usb usb1: configuration #1 chosen from 1 choice                                                                                         
[    2.543264] hub 1-0:1.0: USB hub found                                                                                                              
[    2.547074] hub 1-0:1.0: 4 ports detected                                                                                                           
[    2.552549] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver                                                                                  
[    2.558741] ohci_hcd 0000:00:03.0: PCI INT A -> GSI 10 (level, low) -> IRQ 10                                                                       
[    2.565869] ohci_hcd 0000:00:03.0: OHCI Host Controller                                                                                             
[    2.571347] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2                                                                    
[    2.578745] ohci_hcd 0000:00:03.0: irq 10, io mem 0xff6b4000                                                                                        
[    2.639319] usb usb2: configuration #1 chosen from 1 choice                                                                                         
[    2.645015] hub 2-0:1.0: USB hub found                                                                                                              
[    2.648770] hub 2-0:1.0: 2 ports detected                                                                                                           
[    2.653366] ohci_hcd 0000:00:03.1: PCI INT A -> GSI 10 (level, low) -> IRQ 10                                                                       
[    2.660493] ohci_hcd 0000:00:03.1: OHCI Host Controller                                                                                             
[    2.665985] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3                                                                    
[    2.673382] ohci_hcd 0000:00:03.1: irq 10, io mem 0xff6b5000                                                                                        
[    2.734284] usb usb3: configuration #1 chosen from 1 choice                                                                                         
[    2.740006] hub 3-0:1.0: USB hub found                                                                                                              
[    2.743765] hub 3-0:1.0: 2 ports detected                                                                                                           
[    2.748320] uhci_hcd: USB Universal Host Controller Interface driver                                                                                
[    2.755360] usbcore: registered new interface driver libusual                                                                                       
[    2.761511] PNP: No PS/2 controller found. Probing ports directly.                                                                                  
[    2.769409] serio: i8042 KBD port at 0x60,0x64 irq 1                                                                                                
[    2.774412] serio: i8042 AUX port at 0x60,0x64 irq 12                                                                                               
[    2.779871] mice: PS/2 mouse device common for all mice                                                                                             
[    2.785770] cpuidle: using governor ladder                                                                                                          
[    2.789861] cpuidle: using governor menu                                                                                                            
[    2.796101] usbcore: registered new interface driver hiddev                                                                                         
[    2.801783] usbcore: registered new interface driver usbhid                                                                                         
[    2.807346] usbhid: v2.6:USB HID core driver                                                                                                        
[    2.812502] TCP bic registered                                                                                                                      
[    2.815553] NET: Registered protocol family 17                                                                                                      
[    2.820302] powernow-k8: Found 1 Dual-Core AMD Opteron(tm) Processor 1216 processors (2 cpu cores) (version 2.20.00)                                
[    2.831228] powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0xa                                                                                        
[    2.836892] powernow-k8:    1 : fid 0xe (2200 MHz), vid 0xc                                                                                         
[    2.842454] powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xe                                                                                         
[    2.848015] powernow-k8:    3 : fid 0xa (1800 MHz), vid 0x10                                                                                        
[    2.853661] powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x12                                                                                        
[    2.860635] registered taskstats version 1                                                                                                          
[    6.951257] ata1.00: qc timeout (cmd 0x27)                                                                                                          
[    6.955354] ata1.00: failed to read native max address (err_mask=0x4)                                                                               
[    6.961781] ata1.00: HPA support seems broken, skipping HPA handling                                                                                
[    7.273044] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)                                                                                  
[    7.285159] ata1.00: configured for UDMA/133                                                                                                        
[    7.290052] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1200JS-00N 10.0 PQ: 0 ANSI: 5                                                            
[    7.299294] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)                                                                 
[    7.306968] sd 0:0:0:0: [sda] Write Protect is off                                                                                                  
[    7.311754] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00                                                                                               
[    7.316839] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA                                                 
[    7.326312]  sda:<6>ata2: SATA link down (SStatus 4 SControl 300)                                                                                   
[    7.938372] ata3: SATA link down (SStatus 4 SControl 300)                                                                                           
[    8.258372] ata4: SATA link down (SStatus 4 SControl 300)                                                                                           
[    8.264357] scsi 4:0:0:0: CD-ROM            TEAC     DV-516G          F4S7 PQ: 0 ANSI: 5                                                            
[   37.704234] ata1: lost interrupt (Status 0x50)                                                                                                      
[   37.708695] sd 0:0:0:0: [sda] Unhandled error code                                                                                                  
[   37.713479] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT                                                                     
[   37.720791] end_request: I/O error, dev sda, sector 0                                                                                               
[   37.725848] Buffer I/O error on device sda, logical block 0 
