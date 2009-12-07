Return-Path: <linux-kernel-owner+w=401wt.eu-S935643AbZLGWnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935643AbZLGWnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934201AbZLGWnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:43:20 -0500
Received: from smtp111.rog.mail.re2.yahoo.com ([206.190.37.1]:46266 "HELO
	smtp111.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934088AbZLGWnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:43:16 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Dec 2009 17:43:15 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=m9qX9c7nbxs9g0fgQ5JoNcwVjafgto65gjKySxbbnEzrZkKEjsGA5/aRuoyxXWB9i7nX9Wr+fTEYtVx6ZUOoDE6g5GbZvGGIdu+w2jfCDyeuPGjlPAFataycBR3kTWFfeaRYOyAjVXp6lN03J69DOUBqO2zhU+Ufa14NQ5W1EUU=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: Z.HEF9YVM1lOhfJrETDzP6_eJhzx3XO_N4UeFKKRCnlVIeUhjqaRY6iEK0DZYHCabw--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.32-git1] High IRQ reschedules?
Date: Mon, 7 Dec 2009 17:36:29 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.32-custom-radeon; KDE/4.3.80; x86_64; svn-1056887; 2009-11-30)
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912071736.30552.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am noticing a very high number of rescheduling interrupts, powertop also is indicating this (maybe timer problem?). The only things triggering interrupts is the hpet timer, local timer and iwlagn but it doesn't seem to be from the wifi driver. I do not believe this is due to me turning off NMI 
watchdog in grub? 

Thanks, 

Shawn.

/proc/interrupts:

  0:      41474      43989   IO-APIC-edge      timer
  1:       1875       1637   IO-APIC-edge      i8042
  8:          0          1   IO-APIC-edge      rtc0
  9:        542        551   IO-APIC-fasteoi   acpi
 12:       2714       2330   IO-APIC-edge      i8042
 16:       3035       2648   IO-APIC-fasteoi   uhci_hcd:usb6, yenta, radeon@pci:0000:01:00.0
 17:        415        307   IO-APIC-fasteoi   firewire_ohci, uhci_hcd:usb7, HDA Intel
 18:          0          0   IO-APIC-fasteoi   mmc0, uhci_hcd:usb8
 19:          2          0   IO-APIC-fasteoi   ehci_hcd:usb2
 20:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 21:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
 23:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
 29:        132        198   PCI-MSI-edge      eth0
 30:       5803       5083   PCI-MSI-edge      ahci
 31:      11490       6337   PCI-MSI-edge      iwlagn
NMI:          0          0   Non-maskable interrupts
LOC:      29626      28270   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
PND:          0          0   Performance pending work
RES:      64178      68696   Rescheduling interrupts
CAL:         52         68   Function call interrupts
TLB:        158        155   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:          3          3   Machine check polls
ERR:          1
MIS:          0

Dmesg:

[    0.000000] Initializing cgroup subsys cpuset                                                                                                                
[    0.000000] Initializing cgroup subsys cpu                                                                                                                   
[    0.000000] Linux version 2.6.32-custom-radeon (root@panic) (gcc version 4.3.4 (Debian 4.3.4-6) ) #2 SMP Mon Dec 7 16:08:06 EST 2009                         
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32-custom-radeon root=UUID=d7dd8c66-cb1b-44fb-92c9-a39b586ea3d0 ro nmi_watchdog=0 radeon.modeset=0 printk.time=1 slub_debug=- i915.modeset=1                                                                                                                          
[    0.000000] BIOS-provided physical RAM map:                                                                                                                  
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)                                                                                         
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf8a1000 (usable)                                                                                         
[    0.000000]  BIOS-e820: 00000000bf8a1000 - 00000000bf8a7000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 00000000bf8a7000 - 00000000bf9b7000 (usable)                                                                                         
[    0.000000]  BIOS-e820: 00000000bf9b7000 - 00000000bfa0f000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 00000000bfa0f000 - 00000000bfac6000 (usable)                                                                                         
[    0.000000]  BIOS-e820: 00000000bfac6000 - 00000000bfad1000 (ACPI NVS)                                                                                       
[    0.000000]  BIOS-e820: 00000000bfad1000 - 00000000bfad4000 (ACPI data)                                                                                      
[    0.000000]  BIOS-e820: 00000000bfad4000 - 00000000bfad8000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 00000000bfad8000 - 00000000bfadc000 (ACPI NVS)                                                                                       
[    0.000000]  BIOS-e820: 00000000bfadc000 - 00000000bfadf000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 00000000bfadf000 - 00000000bfb06000 (ACPI NVS)                                                                                       
[    0.000000]  BIOS-e820: 00000000bfb06000 - 00000000bfb08000 (ACPI data)                                                                                      
[    0.000000]  BIOS-e820: 00000000bfb08000 - 00000000bfd0f000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 00000000bfd0f000 - 00000000bfd9f000 (ACPI NVS)                                                                                       
[    0.000000]  BIOS-e820: 00000000bfd9f000 - 00000000bfdff000 (ACPI data)                                                                                      
[    0.000000]  BIOS-e820: 00000000bfdff000 - 00000000bfe00000 (usable)                                                                                         
[    0.000000]  BIOS-e820: 00000000bfe00000 - 00000000c0000000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)                                                                                       
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)                                                                                         
[    0.000000] DMI present.                                                                                                                                     
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000                                                                                                   
[    0.000000] MTRR default type: uncachable                                                                                                                    
[    0.000000] MTRR fixed ranges enabled:                                                                                                                       
[    0.000000]   00000-9FFFF write-back                                                                                                                         
[    0.000000]   A0000-BFFFF uncachable                                                                                                                         
[    0.000000]   C0000-FFFFF write-protect                                                                                                                      
[    0.000000] MTRR variable ranges enabled:                                                                                                                    
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable                                                                                                     
[    0.000000]   1 base 000000000 mask F80000000 write-back                                                                                                     
[    0.000000]   2 base 080000000 mask FC0000000 write-back                                                                                                     
[    0.000000]   3 base 100000000 mask FC0000000 write-back                                                                                                     
[    0.000000]   4 disabled                                                                                                                                     
[    0.000000]   5 disabled                                                                                                                                     
[    0.000000]   6 disabled                                                                                                                                     
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106                                                                                 
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)                                                                   
[    0.000000] last_pfn = 0xbfe00 max_arch_pfn = 0x400000000                                                                                                    
[    0.000000] initial memory mapped : 0 - 20000000                                                                                                             
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfe00000                                                                                           
[    0.000000]  0000000000 - 00bfe00000 page 2M                                                                                                                 
[    0.000000] kernel direct mapping tables up to bfe00000 @ 8000-c000                                                                                          
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000                                                                                           
[    0.000000]  0100000000 - 013c000000 page 2M                                                                                                                 
[    0.000000] kernel direct mapping tables up to 13c000000 @ a000-10000                                                                                        
[    0.000000] RAMDISK: 37809000 - 37fef1a7                                                                                                                     
[    0.000000] ACPI: RSDP 00000000000f6450 00024 (v02 LENOVO)                                                                                                   
[    0.000000] ACPI: XSDT 00000000bfd49b7a 0009C (v01 LENOVO TP-6F    00003110  LTP 00000000)                                                                   
[    0.000000] ACPI: FACP 00000000bfd49d00 000F4 (v03 LENOVO TP-6F    00003110 LNVO 00000001)                                                                   
[    0.000000] ACPI: DSDT 00000000bfd4a10e 0FAC1 (v01 LENOVO TP-6F    00003110 MSFT 03000000)                                                                   
[    0.000000] ACPI: FACS 00000000bfd8e000 00040                                                                                                                
[    0.000000] ACPI: SSDT 00000000bfd49eb4 0025A (v01 LENOVO TP-6F    00003110 MSFT 03000000)                                                                   
[    0.000000] ACPI: ECDT 00000000bfd59bcf 00052 (v01 LENOVO TP-6F    00003110 LNVO 00000001)                                                                   
[    0.000000] ACPI: APIC 00000000bfd59c21 00078 (v01 LENOVO TP-6F    00003110 LNVO 00000001)                                                                   
[    0.000000] ACPI: MCFG 00000000bfd59c99 0003C (v01 LENOVO TP-6F    00003110 LNVO 00000001)                                                                   
[    0.000000] ACPI: HPET 00000000bfd59cd5 00038 (v01 LENOVO TP-6F    00003110 LNVO 00000001)                                                                   
[    0.000000] ACPI: SLIC 00000000bfd59dc2 00176 (v01 LENOVO TP-6F    00003110  LTP 00000000)                                                                   
[    0.000000] ACPI: BOOT 00000000bfd59f38 00028 (v01 LENOVO TP-6F    00003110  LTP 00000001)                                                                   
[    0.000000] ACPI: ASF! 00000000bfd59f60 000A0 (v16 LENOVO TP-6F    00003110 PTL  00000001)                                                                   
[    0.000000] ACPI: SSDT 00000000bfd8d1fa 00568 (v01 LENOVO TP-6F    00003110 INTL 20050513)                                                                   
[    0.000000] ACPI: TCPA 00000000bfb07000 00032 (v00                 00000000      00000000)                                                                   
[    0.000000] ACPI: DMAR 00000000bfb06000 000D8 (v01               ? 00000001      00000000)                                                                   
[    0.000000] ACPI: SSDT 00000000bfad3000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)                                                                   
[    0.000000] ACPI: SSDT 00000000bfad2000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)                                                                   
[    0.000000] ACPI: SSDT 00000000bfad1000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)                                                                   
[    0.000000] ACPI: Local APIC address 0xfee00000                                                                                                              
[    0.000000] No NUMA configuration found                                                                                                                      
[    0.000000] Faking a node at 0000000000000000-000000013c000000                                                                                               
[    0.000000] Bootmem setup node 0 0000000000000000-000000013c000000                                                                                           
[    0.000000]   NODE_DATA [000000000000b000 - 0000000000012fff]                                                                                                
[    0.000000]   bootmap [0000000000013000 -  000000000003a7ff] pages 28                                                                                        
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 013c000000]                                                                                     
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]                                                                    
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]                                                                    
[    0.000000]   #2 [0001000000 - 00015f4814]    TEXT DATA BSS ==> [0001000000 - 00015f4814]                                                                    
[    0.000000]   #3 [0037809000 - 0037fef1a7]          RAMDISK ==> [0037809000 - 0037fef1a7]                                                                    
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]                                                                    
[    0.000000]   #5 [00015f5000 - 00015f514c]              BRK ==> [00015f5000 - 00015f514c]                                                                    
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]                                                                    
[    0.000000]   #7 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]                                                                    
[    0.000000] found SMP MP-table at [ffff8800000f6490] f6490                                                                                                   
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880028600000-ffff88002bdfffff] on node 0                                                        
[    0.000000] Zone PFN ranges:                                                                                                                                 
[    0.000000]   DMA      0x00000000 -> 0x00001000                                                                                                              
[    0.000000]   DMA32    0x00001000 -> 0x00100000                                                                                                              
[    0.000000]   Normal   0x00100000 -> 0x0013c000                                                                                                              
[    0.000000] Movable zone start PFN for each node                                                                                                             
[    0.000000] early_node_map[6] active PFN ranges                                                                                                              
[    0.000000]     0: 0x00000000 -> 0x0000009e                                                                                                                  
[    0.000000]     0: 0x00000100 -> 0x000bf8a1                                                                                                                  
[    0.000000]     0: 0x000bf8a7 -> 0x000bf9b7                                                                                                                  
[    0.000000]     0: 0x000bfa0f -> 0x000bfac6                                                                                                                  
[    0.000000]     0: 0x000bfdff -> 0x000bfe00                                                                                                                  
[    0.000000]     0: 0x00100000 -> 0x0013c000                                                                                                                  
[    0.000000] On node 0 totalpages: 1030663                                                                                                                    
[    0.000000]   DMA zone: 56 pages used for memmap                                                                                                             
[    0.000000]   DMA zone: 103 pages reserved                                                                                                                   
[    0.000000]   DMA zone: 3839 pages, LIFO batch:0                                                                                                             
[    0.000000]   DMA32 zone: 14280 pages used for memmap                                                                                                        
[    0.000000]   DMA32 zone: 766625 pages, LIFO batch:31                                                                                                        
[    0.000000]   Normal zone: 3360 pages used for memmap                                                                                                        
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31                                                                                                       
[    0.000000] ACPI: PM-Timer IO Port: 0x1008                                                                                                                   
[    0.000000] ACPI: Local APIC address 0xfee00000                                                                                                              
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)                                                                                               
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)                                                                                               
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)                                                                                              
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)                                                                                              
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])                                                                                              
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])                                                                                              
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])                                                                                          
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23                                                                                   
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)                                                                                         
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)                                                                                      
[    0.000000] ACPI: IRQ0 used by override.                                                                                                                     
[    0.000000] ACPI: IRQ2 used by override.                                                                                                                     
[    0.000000] ACPI: IRQ9 used by override.                                                                                                                     
[    0.000000] Using ACPI (MADT) for SMP configuration information                                                                                              
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000                                                                                                       
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs                                                                                                             
[    0.000000] nr_irqs_gsi: 24                                                                                                                                  
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000                                                                                
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000bf8a1000 - 00000000bf8a7000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000bf9b7000 - 00000000bfa0f000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000bfac6000 - 00000000bfad1000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000bfad1000 - 00000000bfad4000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000bfad4000 - 00000000bfad8000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000bfad8000 - 00000000bfadc000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000bfadc000 - 00000000bfadf000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000bfadf000 - 00000000bfb06000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000bfb06000 - 00000000bfb08000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000bfb08000 - 00000000bfd0f000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000bfd0f000 - 00000000bfd9f000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000bfd9f000 - 00000000bfdff000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000bfe00000 - 00000000c0000000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000                                                                                
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000                                                                                
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)                                                                           
[    0.000000] Booting paravirtualized kernel on bare hardware                                                                                                  
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1                                                                                       
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880028200000 s84056 r8192 d22440 u524288                                                                      
[    0.000000] pcpu-alloc: s84056 r8192 d22440 u524288 alloc=1*2097152                                                                                          
[    0.000000] pcpu-alloc: [0] 0 1 2 3                                                                                                                          
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1012864                                                                     
[    0.000000] Policy zone: Normal                                                                                                                              
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32-custom-radeon root=UUID=d7dd8c66-cb1b-44fb-92c9-a39b586ea3d0 ro nmi_watchdog=0 radeon.modeset=0 printk.time=1 slub_debug=- i915.modeset=1                                                                                                                   
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)                                                                                             
[    0.000000] Initializing CPU#0                                                                                                                               
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240                                                                                            
[    0.000000] Checking aperture...                                                                                                                             
[    0.000000] No AGP bridge found                                                                                                                              
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area                                                                                                    
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!                                                                                    
[    0.000000] Memory: 3984440k/5177344k available (2992k kernel code, 1054692k absent, 138212k reserved, 1618k data, 584k init)                                
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1                                                                          
[    0.000000] Hierarchical RCU implementation.                                                                                                                 
[    0.000000] NR_IRQS:4352 nr_irqs:440                                                                                                                         
[    0.000000] Extended CMOS year: 2000                                                                                                                         
[    0.000000] Console: colour VGA+ 80x25                                                                                                                       
[    0.000000] console [tty0] enabled                                                                                                                           
[    0.000000] hpet clockevent registered                                                                                                                       
[    0.000000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer                                                                                 
[    0.000000] Fast TSC calibration using PIT                                                                                                                   
[    0.000000] Detected 2526.893 MHz processor.                                                                                                                 
[    0.008005] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.78 BogoMIPS (lpj=10107572)                                       
[    0.008144] Security Framework initialized                                                                                                                   
[    0.008208] SELinux:  Disabled at boot.                                                                                                                      
[    0.008535] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)                                                                               
[    0.012959] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)                                                                                 
[    0.013975] Mount-cache hash table entries: 256                                                                                                              
[    0.014170] Initializing cgroup subsys ns                                                                                                                    
[    0.014232] Initializing cgroup subsys cpuacct                                                                                                               
[    0.014293] Initializing cgroup subsys devices                                                                                                               
[    0.014353] Initializing cgroup subsys freezer                                                                                                               
[    0.014413] Initializing cgroup subsys net_cls                                                                                                               
[    0.014495] CPU 0/0x0 -> Node 0                                                                                                                              
[    0.014554] CPU: Physical Processor ID: 0                                                                                                                    
[    0.014613] CPU: Processor Core ID: 0                                                                                                                        
[    0.014673] mce: CPU supports 6 MCE banks                                                                                                                    
[    0.014738] CPU0: Thermal monitoring enabled (TM2)                                                                                                           
[    0.014800] using mwait in idle threads.                                                                                                                     
[    0.014859] Performance Events: Core2 events, Intel PMU driver.                                                                                              
[    0.015024] ... version:                2                                                                                                                    
[    0.015083] ... bit width:              40                                                                                                                   
[    0.015143] ... generic registers:      2                                                                                                                    
[    0.015203] ... value mask:             000000ffffffffff                                                                                                     
[    0.015263] ... max period:             000000007fffffff                                                                                                     
[    0.015324] ... fixed-purpose events:   3                                                                                                                    
[    0.015383] ... event mask:             0000000700000003                                                                                                     
[    0.016312] ACPI: Core revision 20090903                                                                                                                     
[    0.036073] DMAR: Host address width 36                                                                                                                      
[    0.036135] DMAR: DRHD base: 0x000000feb03000 flags: 0x0                                                                                                     
[    0.036201] IOMMU feb03000: ver 1:0 cap c9008020e30260 ecap 1000                                                                                             
[    0.036264] DMAR: DRHD base: 0x000000feb00000 flags: 0x0                                                                                                     
[    0.036329] IOMMU feb00000: ver 1:0 cap c0000020630270 ecap 1000                                                                                             
[    0.036392] DMAR: DRHD base: 0x000000feb02000 flags: 0x1                                                                                                     
[    0.036456] IOMMU feb02000: ver 1:0 cap c9008020630260 ecap 1000                                                                                             
[    0.036518] DMAR: RMRR base: 0x000000fc226c00 end: 0x000000fc2273ff                                                                                          
[    0.036581] DMAR: No ATSR found                                                                                                                              
[    0.036649] Setting APIC routing to flat                                                                                                                     
[    0.037053] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1                                                                                             
[    0.077146] CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 0a                                                                                
[    0.080001] Booting processor 1 APIC 0x1 ip 0x6000                                                                                                           
[    0.080001] Initializing CPU#1                                                                                                                               
[    0.080001] Calibrating delay using timer specific routine.. 5053.98 BogoMIPS (lpj=10107972)                                                                 
[    0.080001] CPU 1/0x1 -> Node 0                                                                                                                              
[    0.080001] CPU: Physical Processor ID: 0                                                                                                                    
[    0.080001] CPU: Processor Core ID: 1                                                                                                                        
[    0.080001] CPU1: Thermal monitoring enabled (TM2)                                                                                                           
[    0.164077] CPU1: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 0a                                                                                
[    0.168020] Brought up 2 CPUs                                                                                                                                
[    0.168081] Total of 2 processors activated (10107.77 BogoMIPS).                                                                                             
[    0.169040] regulator: core version 0.5                                                                                                                      
[    0.169040] NET: Registered protocol family 16                                                                                                               
[    0.169040] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it                                                                           
[    0.169040] ACPI: bus type pci registered                                                                                                                    
[    0.169040] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63                                                                                  
[    0.169040] PCI: MCFG area at e0000000 reserved in E820                                                                                                      
[    0.174726] PCI: Using MMCONFIG at e0000000 - e3ffffff                                                                                                       
[    0.174788] PCI: Using configuration type 1 for base access                                                                                                  
[    0.176022] bio: create slab <bio-0> at 0                                                                                                                    
[    0.176894] ACPI: EC: EC description table is found, configuring boot EC                                                                                     
[    0.184961] ACPI: BIOS _OSI(Linux) query ignored                                                                                                             
[    0.189863] ACPI: Interpreter enabled                                                                                                                        
[    0.189926] ACPI: (supports S0 S3 S4 S5)                                                                                                                     
[    0.190216] ACPI: Using IOAPIC for interrupt routing                                                                                                         
[    0.204154] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62                                                                                    
[    0.204154] ACPI: Power Resource [PUBS] (on)                                                                                                                 
[    0.204567] ACPI: ACPI Dock Station Driver: 3 docks/bays found                                                                                               
[    0.205053] ACPI: PCI Root Bridge [PCI0] (0000:00)                                                                                                           
[    0.205140] DMAR: Forcing write-buffer flush capability                                                                                                      
[    0.205140] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold                                                                                            
[    0.205140] pci 0000:00:01.0: PME# disabled                                                                                                                  
[    0.205140] pci 0000:00:03.0: reg 10 64bit mmio: [0xfc226800-0xfc22680f]                                                                                     
[    0.205140] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold                                                                                            
[    0.205140] pci 0000:00:03.0: PME# disabled                                                                                                                  
[    0.208109] pci 0000:00:19.0: reg 10 32bit mmio: [0xfc200000-0xfc21ffff]                                                                                     
[    0.208116] pci 0000:00:19.0: reg 14 32bit mmio: [0xfc225000-0xfc225fff]                                                                                     
[    0.208123] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]                                                                                                
[    0.208173] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold                                                                                            
[    0.208237] pci 0000:00:19.0: PME# disabled                                                                                                                  
[    0.208357] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]                                                                                                
[    0.208441] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]                                                                                                
[    0.208525] pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]                                                                                                
[    0.208610] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfc226c00-0xfc226fff]                                                                                     
[    0.208671] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold                                                                                            
[    0.208736] pci 0000:00:1a.7: PME# disabled                                                                                                                  
[    0.208846] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfc220000-0xfc223fff]                                                                                     
[    0.208900] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold                                                                                            
[    0.208965] pci 0000:00:1b.0: PME# disabled                                                                                                                  
[    0.209107] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold                                                                                            
[    0.209171] pci 0000:00:1c.0: PME# disabled                                                                                                                  
[    0.209316] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold                                                                                            
[    0.209380] pci 0000:00:1c.1: PME# disabled                                                                                                                  
[    0.209525] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold                                                                                            
[    0.209590] pci 0000:00:1c.3: PME# disabled                                                                                                                  
[    0.209736] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold                                                                                            
[    0.209801] pci 0000:00:1c.4: PME# disabled                                                                                                                  
[    0.209929] pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]                                                                                                
[    0.210012] pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]                                                                                                
[    0.210096] pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]                                                                                                
[    0.210183] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfc227000-0xfc2273ff]                                                                                     
[    0.210244] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold                                                                                            
[    0.210309] pci 0000:00:1d.7: PME# disabled                                                                                                                  
[    0.210605] pci 0000:00:1f.2: reg 10 io port: [0x1c40-0x1c47]                                                                                                
[    0.210612] pci 0000:00:1f.2: reg 14 io port: [0x1834-0x1837]                                                                                                
[    0.210619] pci 0000:00:1f.2: reg 18 io port: [0x1838-0x183f]                                                                                                
[    0.210625] pci 0000:00:1f.2: reg 1c io port: [0x1830-0x1833]                                                                                                
[    0.210632] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]                                                                                                
[    0.210639] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfc226000-0xfc2267ff]                                                                                     
[    0.210681] pci 0000:00:1f.2: PME# supported from D3hot                                                                                                      
[    0.210745] pci 0000:00:1f.2: PME# disabled                                                                                                                  
[    0.210842] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfc227400-0xfc2274ff]                                                                                     
[    0.210859] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]                                                                                                
[    0.210917] pci 0000:01:00.0: reg 10 32bit mmio pref: [0xd0000000-0xdfffffff]                                                                                
[    0.210924] pci 0000:01:00.0: reg 14 io port: [0x2000-0x20ff]                                                                                                
[    0.210931] pci 0000:01:00.0: reg 18 32bit mmio: [0xcfff0000-0xcfffffff]                                                                                     
[    0.210953] pci 0000:01:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]                                                                                    
[    0.210979] pci 0000:01:00.0: supports D1 D2                                                                                                                 
[    0.211035] pci 0000:00:01.0: bridge io port: [0x2000-0x2fff]                                                                                                
[    0.211037] pci 0000:00:01.0: bridge 32bit mmio: [0xcff00000-0xcfffffff]                                                                                     
[    0.211041] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]                                                                                
[    0.211220] pci 0000:03:00.0: reg 10 64bit mmio: [0xf4200000-0xf4201fff]                                                                                     
[    0.211334] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold                                                                                            
[    0.211423] pci 0000:03:00.0: PME# disabled                                                                                                                  
[    0.211582] pci 0000:00:1c.1: bridge 32bit mmio: [0xf4200000-0xf42fffff]                                                                                     
[    0.211641] pci 0000:00:1c.3: bridge io port: [0x3000-0x3fff]                                                                                                
[    0.211645] pci 0000:00:1c.3: bridge 32bit mmio: [0xf8000000-0xf9ffffff]                                                                                     
[    0.211652] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf4000000-0xf40fffff]                                                                                
[    0.211706] pci 0000:00:1c.4: bridge io port: [0x4000-0x4fff]                                                                                                
[    0.211710] pci 0000:00:1c.4: bridge 32bit mmio: [0xfa000000-0xfbffffff]                                                                                     
[    0.211717] pci 0000:00:1c.4: bridge 64bit mmio pref: [0xf4100000-0xf41fffff]                                                                                
[    0.211764] pci 0000:15:00.0: reg 10 32bit mmio: [0xf4300000-0xf4300fff]                                                                                     
[    0.211790] pci 0000:15:00.0: supports D1 D2                                                                                                                 
[    0.211791] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold                                                                                      
[    0.211857] pci 0000:15:00.0: PME# disabled                                                                                                                  
[    0.212035] pci 0000:15:00.1: reg 10 32bit mmio: [0xf4301000-0xf43017ff]                                                                                     
[    0.212103] pci 0000:15:00.1: supports D1 D2                                                                                                                 
[    0.212104] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold                                                                                      
[    0.212170] pci 0000:15:00.1: PME# disabled                                                                                                                  
[    0.212276] pci 0000:15:00.2: reg 10 32bit mmio: [0xf4301800-0xf43018ff]                                                                                     
[    0.212343] pci 0000:15:00.2: supports D1 D2                                                                                                                 
[    0.212344] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold                                                                                      
[    0.212410] pci 0000:15:00.2: PME# disabled                                                                                                                  
[    0.212517] pci 0000:15:00.3: reg 10 32bit mmio: [0xf4301c00-0xf4301cff]                                                                                     
[    0.212583] pci 0000:15:00.3: supports D1 D2                                                                                                                 
[    0.212585] pci 0000:15:00.3: PME# supported from D0 D1 D2 D3hot D3cold                                                                                      
[    0.212651] pci 0000:15:00.3: PME# disabled                                                                                                                  
[    0.212757] pci 0000:15:00.4: reg 10 32bit mmio: [0xf4302000-0xf43020ff]                                                                                     
[    0.212824] pci 0000:15:00.4: supports D1 D2                                                                                                                 
[    0.212826] pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold                                                                                      
[    0.212892] pci 0000:15:00.4: PME# disabled                                                                                                                  
[    0.212997] pci 0000:15:00.5: reg 10 32bit mmio: [0xf4302400-0xf43024ff]                                                                                     
[    0.213064] pci 0000:15:00.5: supports D1 D2                                                                                                                 
[    0.213066] pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold                                                                                      
[    0.213132] pci 0000:15:00.5: PME# disabled                                                                                                                  
[    0.213261] pci 0000:00:1e.0: transparent bridge                                                                                                             
[    0.213325] pci 0000:00:1e.0: bridge io port: [0x5000-0x8fff]                                                                                                
[    0.213330] pci 0000:00:1e.0: bridge 32bit mmio: [0xf4300000-0xf7ffffff]                                                                                     
[    0.213337] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xf0000000-0xf3ffffff]                                                                                
[    0.213393] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]                                                                                              
[    0.213532] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]                                                                                         
[    0.213596] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]                                                                                         
[    0.213656] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]                                                                                         
[    0.213719] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]                                                                                         
[    0.213785] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]                                                                                         
[    0.213851] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]                                                                                         
[    0.220124] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)                                                                                        
[    0.220879] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)                                                                                        
[    0.221632] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)                                                                                        
[    0.222384] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)                                                                                        
[    0.223135] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)                                                                                        
[    0.223886] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)                                                                                        
[    0.224647] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)                                                                                        
[    0.225398] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)                                                                                        
[    0.226063] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none                                                                     
[    0.226063] vgaarb: loaded                                                                                                                                   
[    0.226063] usbcore: registered new interface driver usbfs                                                                                                   
[    0.226063] usbcore: registered new interface driver hub                                                                                                     
[    0.226063] usbcore: registered new device driver usb                                                                                                        
[    0.226063] PCI: Using ACPI for IRQ routing                                                                                                                  
[    0.226063] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0                                                                                                       
[    0.226063] hpet0: 4 comparators, 64-bit 14.318180 MHz counter                                                                                               
[    0.232019] Switching to clocksource tsc                                                                                                                     
[    0.233046] pnp: PnP ACPI init                                                                                                                               
[    0.233111] ACPI: bus type pnp registered                                                                                                                    
[    0.295198] pnp: PnP ACPI: found 10 devices                                                                                                                  
[    0.295260] ACPI: ACPI bus type pnp unregistered                                                                                                             
[    0.295326] system 00:00: iomem range 0x0-0x9ffff could not be reserved                                                                                      
[    0.295390] system 00:00: iomem range 0xc0000-0xc3fff has been reserved                                                                                      
[    0.295453] system 00:00: iomem range 0xc4000-0xc7fff has been reserved                                                                                      
[    0.295516] system 00:00: iomem range 0xc8000-0xcbfff has been reserved                                                                                      
[    0.295580] system 00:00: iomem range 0xcc000-0xcffff has been reserved                                                                                      
[    0.295643] system 00:00: iomem range 0xdc000-0xdffff could not be reserved                                                                                  
[    0.295706] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved                                                                                  
[    0.295769] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved                                                                                  
[    0.295833] system 00:00: iomem range 0xe8000-0xebfff could not be reserved                                                                                  
[    0.295896] system 00:00: iomem range 0xec000-0xeffff could not be reserved                                                                                  
[    0.295963] system 00:00: iomem range 0xf0000-0xfffff could not be reserved                                                                                  
[    0.296026] system 00:00: iomem range 0x100000-0xbfffffff could not be reserved                                                                              
[    0.296095] system 00:00: iomem range 0xfec00000-0xffffffff could not be reserved                                                                            
[    0.296167] system 00:02: ioport range 0x1000-0x107f has been reserved                                                                                       
[    0.296230] system 00:02: ioport range 0x1180-0x11ff has been reserved                                                                                       
[    0.296293] system 00:02: ioport range 0x800-0x80f has been reserved                                                                                         
[    0.296356] system 00:02: ioport range 0x15e0-0x15ef has been reserved                                                                                       
[    0.296419] system 00:02: ioport range 0x1600-0x167f has been reserved                                                                                       
[    0.296482] system 00:02: ioport range 0x1680-0x169f has been reserved                                                                                       
[    0.296546] system 00:02: iomem range 0xe0000000-0xefffffff has been reserved                                                                                
[    0.296609] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved                                                                                
[    0.296673] system 00:02: iomem range 0xfed10000-0xfed13fff has been reserved                                                                                
[    0.296736] system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved                                                                                
[    0.296799] system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved                                                                                
[    0.296863] system 00:02: iomem range 0xfed45000-0xfed4bfff has been reserved                                                                                
[    0.296927] system 00:02: iomem range 0xfed40000-0xfed44fff has been reserved                                                                                
[    0.301877] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01                                                                                              
[    0.301940] pci 0000:00:01.0:   IO window: 0x2000-0x2fff                                                                                                     
[    0.302003] pci 0000:00:01.0:   MEM window: 0xcff00000-0xcfffffff                                                                                            
[    0.302067] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff                                                                           
[    0.302137] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02                                                                                              
[    0.302201] pci 0000:00:1c.0:   IO window: 0x9000-0x9fff                                                                                                     
[    0.302266] pci 0000:00:1c.0:   MEM window: 0xc0000000-0xc01fffff                                                                                            
[    0.302330] pci 0000:00:1c.0:   PREFETCH window: 0x000000c0200000-0x000000c03fffff                                                                           
[    0.302403] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03                                                                                              
[    0.302467] pci 0000:00:1c.1:   IO window: 0xa000-0xafff                                                                                                     
[    0.302532] pci 0000:00:1c.1:   MEM window: 0xf4200000-0xf42fffff                                                                                            
[    0.302597] pci 0000:00:1c.1:   PREFETCH window: 0x000000c0400000-0x000000c05fffff                                                                           
[    0.302670] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05                                                                                              
[    0.302733] pci 0000:00:1c.3:   IO window: 0x3000-0x3fff                                                                                                     
[    0.302799] pci 0000:00:1c.3:   MEM window: 0xf8000000-0xf9ffffff                                                                                            
[    0.302864] pci 0000:00:1c.3:   PREFETCH window: 0x000000f4000000-0x000000f40fffff                                                                           
[    0.302937] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:0d                                                                                              
[    0.303000] pci 0000:00:1c.4:   IO window: 0x4000-0x4fff                                                                                                     
[    0.303066] pci 0000:00:1c.4:   MEM window: 0xfa000000-0xfbffffff                                                                                            
[    0.303131] pci 0000:00:1c.4:   PREFETCH window: 0x000000f4100000-0x000000f41fffff                                                                           
[    0.303206] pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16                                                                                          
[    0.303269] pci 0000:15:00.0:   IO window: 0x005000-0x0050ff                                                                                                 
[    0.305536] pci 0000:15:00.0:   IO window: 0x005400-0x0054ff                                                                                                 
[    0.305602] pci 0000:15:00.0:   PREFETCH window: 0xf0000000-0xf3ffffff                                                                                       
[    0.305668] pci 0000:15:00.0:   MEM window: 0xc4000000-0xc7ffffff                                                                                            
[    0.305733] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15                                                                                              
[    0.305796] pci 0000:00:1e.0:   IO window: 0x5000-0x8fff                                                                                                     
[    0.305862] pci 0000:00:1e.0:   MEM window: 0xf4300000-0xf7ffffff                                                                                            
[    0.305927] pci 0000:00:1e.0:   PREFETCH window: 0x000000f0000000-0x000000f3ffffff                                                                           
[    0.306004]   alloc irq_desc for 16 on node -1                                                                                                               
[    0.306005]   alloc kstat_irqs on node -1                                                                                                                    
[    0.306010] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                     
[    0.306074] pci 0000:00:01.0: setting latency timer to 64                                                                                                    
[    0.306082]   alloc irq_desc for 20 on node -1                                                                                                               
[    0.306083]   alloc kstat_irqs on node -1                                                                                                                    
[    0.306086] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20                                                                                     
[    0.306151] pci 0000:00:1c.0: setting latency timer to 64                                                                                                    
[    0.306159]   alloc irq_desc for 21 on node -1                                                                                                               
[    0.306161]   alloc kstat_irqs on node -1                                                                                                                    
[    0.306164] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21                                                                                     
[    0.306229] pci 0000:00:1c.1: setting latency timer to 64                                                                                                    
[    0.306237]   alloc irq_desc for 23 on node -1                                                                                                               
[    0.306238]   alloc kstat_irqs on node -1                                                                                                                    
[    0.306241] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23                                                                                     
[    0.306306] pci 0000:00:1c.3: setting latency timer to 64                                                                                                    
[    0.306314] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20                                                                                     
[    0.306380] pci 0000:00:1c.4: setting latency timer to 64                                                                                                    
[    0.306387] pci 0000:00:1e.0: setting latency timer to 64                                                                                                    
[    0.306397] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                     
[    0.306464] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]                                                                                                   
[    0.306466] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]                                                                                   
[    0.306468] pci_bus 0000:01: resource 0 io:  [0x2000-0x2fff]                                                                                                 
[    0.306470] pci_bus 0000:01: resource 1 mem: [0xcff00000-0xcfffffff]                                                                                         
[    0.306472] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]                                                                                     
[    0.306474] pci_bus 0000:02: resource 0 io:  [0x9000-0x9fff]                                                                                                 
[    0.306476] pci_bus 0000:02: resource 1 mem: [0xc0000000-0xc01fffff]                                                                                         
[    0.306478] pci_bus 0000:02: resource 2 pref mem [0xc0200000-0xc03fffff]                                                                                     
[    0.306479] pci_bus 0000:03: resource 0 io:  [0xa000-0xafff]                                                                                                 
[    0.306481] pci_bus 0000:03: resource 1 mem: [0xf4200000-0xf42fffff]                                                                                         
[    0.306483] pci_bus 0000:03: resource 2 pref mem [0xc0400000-0xc05fffff]                                                                                     
[    0.306485] pci_bus 0000:05: resource 0 io:  [0x3000-0x3fff]                                                                                                 
[    0.306487] pci_bus 0000:05: resource 1 mem: [0xf8000000-0xf9ffffff]                                                                                         
[    0.306489] pci_bus 0000:05: resource 2 pref mem [0xf4000000-0xf40fffff]                                                                                     
[    0.306490] pci_bus 0000:0d: resource 0 io:  [0x4000-0x4fff]                                                                                                 
[    0.306492] pci_bus 0000:0d: resource 1 mem: [0xfa000000-0xfbffffff]                                                                                         
[    0.306494] pci_bus 0000:0d: resource 2 pref mem [0xf4100000-0xf41fffff]                                                                                     
[    0.306496] pci_bus 0000:15: resource 0 io:  [0x5000-0x8fff]                                                                                                 
[    0.306498] pci_bus 0000:15: resource 1 mem: [0xf4300000-0xf7ffffff]                                                                                         
[    0.306500] pci_bus 0000:15: resource 2 pref mem [0xf0000000-0xf3ffffff]                                                                                     
[    0.306501] pci_bus 0000:15: resource 3 io:  [0x00-0xffff]                                                                                                   
[    0.306503] pci_bus 0000:15: resource 4 mem: [0x000000-0xffffffffffffffff]                                                                                   
[    0.306505] pci_bus 0000:16: resource 0 io:  [0x5000-0x50ff]                                                                                                 
[    0.306507] pci_bus 0000:16: resource 1 io:  [0x5400-0x54ff]                                                                                                 
[    0.306508] pci_bus 0000:16: resource 2 pref mem [0xf0000000-0xf3ffffff]                                                                                     
[    0.306510] pci_bus 0000:16: resource 3 mem: [0xc4000000-0xc7ffffff]                                                                                         
[    0.306533] NET: Registered protocol family 2                                                                                                                
[    0.306718] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)                                                                              
[    0.307944] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)                                                                            
[    0.310988] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)                                                                                     
[    0.311526] TCP: Hash tables configured (established 524288 bind 65536)                                                                                      
[    0.311590] TCP reno registered                                                                                                                              
[    0.311768] NET: Registered protocol family 1                                                                                                                
[    0.312026] pci 0000:01:00.0: Boot video device                                                                                                              
[    0.312083] Trying to unpack rootfs image as initramfs...                                                                                                    
[    0.481295] Freeing initrd memory: 8088k freed                                                                                                               
[    0.484601] DMAR: Device scope device [0000:00:03.02] not found                                                                                              
[    0.484666] DMAR: Device scope device [0000:00:03.02] not found                                                                                              
[    0.484728] DMAR: Device scope device [0000:00:03.03] not found                                                                                              
[    0.484791] DMAR: Device scope device [0000:00:03.03] not found                                                                                              
[    0.484862] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)                                                                                        
[    0.484926] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000                                                                         
[    0.484994] software IO TLB at phys 0x20000000 - 0x24000000                                                                                                  
[    0.485440] Simple Boot Flag at 0x35 set to 0x1                                                                                                              
[    0.488894] audit: initializing netlink socket (disabled)                                                                                                    
[    0.489467] HugeTLB registered 2 MB page size, pre-allocated 0 pages                                                                                         
[    0.502517] VFS: Disk quotas dquot_6.5.2                                                                                                                     
[    0.502658] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)                                                                                        
[    0.502833] msgmni has been set to 7797                                                                                                                      
[    0.503673] alg: No test for stdrng (krng)                                                                                                                   
[    0.503851] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)                                                                             
[    0.503920] io scheduler noop registered                                                                                                                     
[    0.503982] io scheduler anticipatory registered                                                                                                             
[    0.504042] io scheduler deadline registered                                                                                                                 
[    0.504301] io scheduler cfq registered (default)                                                                                                            
[    0.504752]   alloc irq_desc for 24 on node -1                                                                                                               
[    0.504754]   alloc kstat_irqs on node -1                                                                                                                    
[    0.504762] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X                                                                                                      
[    0.504767] pcieport 0000:00:01.0: setting latency timer to 64                                                                                               
[    0.505352]   alloc irq_desc for 25 on node -1                                                                                                               
[    0.505354]   alloc kstat_irqs on node -1                                                                                                                    
[    0.505362] pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X                                                                                                      
[    0.505371] pcieport 0000:00:1c.0: setting latency timer to 64                                                                                               
[    0.506203]   alloc irq_desc for 26 on node -1                                                                                                               
[    0.506204]   alloc kstat_irqs on node -1                                                                                                                    
[    0.506213] pcieport 0000:00:1c.1: irq 26 for MSI/MSI-X                                                                                                      
[    0.506222] pcieport 0000:00:1c.1: setting latency timer to 64                                                                                               
[    0.507073]   alloc irq_desc for 27 on node -1                                                                                                               
[    0.507075]   alloc kstat_irqs on node -1                                                                                                                    
[    0.507083] pcieport 0000:00:1c.3: irq 27 for MSI/MSI-X                                                                                                      
[    0.507092] pcieport 0000:00:1c.3: setting latency timer to 64                                                                                               
[    0.507940]   alloc irq_desc for 28 on node -1                                                                                                               
[    0.507942]   alloc kstat_irqs on node -1                                                                                                                    
[    0.507950] pcieport 0000:00:1c.4: irq 28 for MSI/MSI-X                                                                                                      
[    0.507960] pcieport 0000:00:1c.4: setting latency timer to 64                                                                                               
[    0.530049] Linux agpgart interface v0.103                                                                                                                   
[    0.530112] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled                                                                                          
[    0.541489] brd: module loaded                                                                                                                               
[    0.541617] input: Macintosh mouse button emulation as /devices/virtual/input/input0                                                                         
[    0.542770] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12                                                                             
[    0.551454] serio: i8042 KBD port at 0x60,0x64 irq 1                                                                                                         
[    0.551518] serio: i8042 AUX port at 0x60,0x64 irq 12                                                                                                        
[    0.552540] mice: PS/2 mouse device common for all mice                                                                                                      
[    0.552904] Driver 'rtc_cmos' needs updating - please use bus_type methods                                                                                   
[    0.552994] rtc_cmos 00:07: RTC can wake from S4                                                                                                             
[    0.553216] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0                                                                                            
[    0.553307] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs                                                                                    
[    0.553422] cpuidle: using governor ladder                                                                                                                   
[    0.553484] cpuidle: using governor menu                                                                                                                     
[    0.553546] No iBFT detected.                                                                                                                                
[    0.553856] TCP cubic registered                                                                                                                             
[    0.554952] NET: Registered protocol family 10                                                                                                               
[    0.555494] lo: Disabled Privacy Extensions                                                                                                                  
[    0.555771] Mobile IPv6                                                                                                                                      
[    0.555832] NET: Registered protocol family 17                                                                                                               
[    0.556419] registered taskstats version 1                                                                                                                   
[    0.557083] rtc_cmos 00:07: setting system clock to 2009-12-07 17:14:23 UTC (1260206063)                                                                     
[    0.557228] Freeing unused kernel memory: 584k freed                                                                                                         
[    0.557519] Write protecting the kernel read-only data: 4088k                                                                                                
[    0.557535] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1                                                               
[    0.635516] thermal LNXTHERM:01: registered as thermal_zone0                                                                                                 
[    0.635590] ACPI: Thermal Zone [THM0] (54 C)                                                                                                                 
[    0.637106] thermal LNXTHERM:02: registered as thermal_zone1                                                                                                 
[    0.637174] ACPI: Thermal Zone [THM1] (58 C)                                                                                                                 
[    0.666608] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver                                                                                       
[    0.684269] SCSI subsystem initialized                                                                                                                       
[    0.694280] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2                                                                    
[    0.698299] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2                                                                                              
[    0.698365] e1000e: Copyright (c) 1999-2008 Intel Corporation.                                                                                               
[    0.712800] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0                                                                                         
[    0.712914] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23                                                                                
[    0.713016] ehci_hcd 0000:00:1a.7: setting latency timer to 64                                                                                               
[    0.713020] ehci_hcd 0000:00:1a.7: EHCI Host Controller                                                                                                      
[    0.713142] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1                                                                             
[    0.713247] ehci_hcd 0000:00:1a.7: debug port 1                                                                                                              
[    0.717187] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported                                                                                    
[    0.717217] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xfc226c00                                                                                                 
[    0.722617] ACPI: Lid Switch [LID]                                                                                                                           
[    0.722739] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input3                                                                  
[    0.722816] ACPI: Sleep Button [SLPB]                                                                                                                        
[    0.722946] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4                                                                             
[    0.723015] ACPI: Power Button [PWRF]                                                                                                                        
[    0.726911] acpi device:07: registered as cooling_device0                                                                                                    
[    0.743767] ricoh-mmc: Ricoh MMC Controller disabling driver                                                                                                 
[    0.743832] ricoh-mmc: Copyright(c) Philip Langdale                                                                                                          
[    0.743914] ricoh-mmc: Ricoh MMC controller found at 0000:15:00.3 [1180:0843] (rev 11)                                                                       
[    0.744000] ricoh-mmc: Controller is now disabled.                                                                                                           
[    0.755348] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01/input/input5                                               
[    0.755425] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)                                                                                   
[    0.758245]   alloc irq_desc for 17 on node -1                                                                                                               
[    0.758248]   alloc kstat_irqs on node -1                                                                                                                    
[    0.758255] firewire_ohci 0000:15:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17                                                                           
[    0.763887] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00                                                                                                
[    0.763973] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002                                                                                    
[    0.764036] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                               
[    0.764103] usb usb1: Product: EHCI Host Controller                                                                                                          
[    0.764165] usb usb1: Manufacturer: Linux 2.6.32-custom-radeon ehci_hcd                                                                                      
[    0.764227] usb usb1: SerialNumber: 0000:00:1a.7                                                                                                             
[    0.764336] usb usb1: configuration #1 chosen from 1 choice                                                                                                  
[    0.764422] hub 1-0:1.0: USB hub found                                                                                                                       
[    0.764491] hub 1-0:1.0: 6 ports detected                                                                                                                    
[    0.764692] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20                                                                                  
[    0.764761] e1000e 0000:00:19.0: setting latency timer to 64                                                                                                 
[    0.764857]   alloc irq_desc for 29 on node -1                                                                                                               
[    0.764859]   alloc kstat_irqs on node -1                                                                                                                    
[    0.764871] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X                                                                                                        
[    0.771667] libata version 3.00 loaded.                                                                                                                      
[    0.772684] sdhci: Secure Digital Host Controller Interface driver                                                                                           
[    0.772751] sdhci: Copyright(c) Pierre Ossman                                                                                                                
[    0.839312] firewire_ohci: Added fw-ohci device 0000:15:00.1, OHCI version 1.10                                                                              
[    0.839481] sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 21)                                                                              
[    0.839562]   alloc irq_desc for 18 on node -1                                                                                                               
[    0.839563]   alloc kstat_irqs on node -1                                                                                                                    
[    0.839567] sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18                                                                               
[    0.840656] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.                                                      
[    0.841754] Registered led device: mmc0::                                                                                                                    
[    0.842833] mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA                                                                                           
[    0.871690] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:22:68:0c:96:e3                                                                             
[    0.871759] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection                                                                                         
[    0.871842] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008ff-0ff                                                                                           
[    0.872122] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0                                                                                         
[    0.872190]   alloc irq_desc for 19 on node -1                                                                                                               
[    0.872192]   alloc kstat_irqs on node -1                                                                                                                    
[    0.872195] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19                                                                                
[    0.872269] ehci_hcd 0000:00:1d.7: setting latency timer to 64                                                                                               
[    0.872272] ehci_hcd 0000:00:1d.7: EHCI Host Controller                                                                                                      
[    0.872369] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2                                                                             
[    0.872466] ehci_hcd 0000:00:1d.7: debug port 1                                                                                                              
[    0.876406] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported                                                                                    
[    0.876417] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfc227000                                                                                                 
[    0.891316] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00                                                                                                
[    0.891401] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002                                                                                    
[    0.891464] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                               
[    0.891532] usb usb2: Product: EHCI Host Controller                                                                                                          
[    0.891593] usb usb2: Manufacturer: Linux 2.6.32-custom-radeon ehci_hcd                                                                                      
[    0.891656] usb usb2: SerialNumber: 0000:00:1d.7                                                                                                             
[    0.891753] usb usb2: configuration #1 chosen from 1 choice                                                                                                  
[    0.891836] hub 2-0:1.0: USB hub found                                                                                                                       
[    0.894111] hub 2-0:1.0: 6 ports detected                                                                                                                    
[    0.894398] ahci 0000:00:1f.2: version 3.0                                                                                                                   
[    0.894409] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16                                                                                    
[    0.894981]   alloc irq_desc for 30 on node -1                                                                                                               
[    0.894983]   alloc kstat_irqs on node -1                                                                                                                    
[    0.894991] ahci 0000:00:1f.2: irq 30 for MSI/MSI-X                                                                                                          
[    0.895024] ahci: SSS flag set, parallel bus scan disabled                                                                                                   
[    0.895109] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode                                                                     
[    0.895178] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs                                                                   
[    0.895250] ahci 0000:00:1f.2: setting latency timer to 64                                                                                                   
[    0.897966] scsi0 : ahci                                                                                                                                     
[    0.898109] scsi1 : ahci                                                                                                                                     
[    0.898214] scsi2 : ahci                                                                                                                                     
[    0.898319] scsi3 : ahci                                                                                                                                     
[    0.899017] ata1: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 irq 30                                                                             
[    0.899087] ata2: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 irq 30                                                                             
[    0.899155] ata3: DUMMY                                                                                                                                      
[    0.899215] ata4: DUMMY                                                                                                                                      
[    0.909730] uhci_hcd: USB Universal Host Controller Interface driver                                                                                         
[    0.910010] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0                                                                                         
[    0.910077] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20                                                                                
[    0.910144] uhci_hcd 0000:00:1a.0: setting latency timer to 64                                                                                               
[    0.910147] uhci_hcd 0000:00:1a.0: UHCI Host Controller                                                                                                      
[    0.910239] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3                                                                             
[    0.910338] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860                                                                                                
[    0.910432] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001                                                                                    
[    0.910495] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                               
[    0.910563] usb usb3: Product: UHCI Host Controller                                                                                                          
[    0.910624] usb usb3: Manufacturer: Linux 2.6.32-custom-radeon uhci_hcd                                                                                      
[    0.910686] usb usb3: SerialNumber: 0000:00:1a.0                                                                                                             
[    0.910781] usb usb3: configuration #1 chosen from 1 choice                                                                                                  
[    0.910866] hub 3-0:1.0: USB hub found                                                                                                                       
[    0.910931] hub 3-0:1.0: 2 ports detected                                                                                                                    
[    0.911043] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21                                                                                
[    0.911110] uhci_hcd 0000:00:1a.1: setting latency timer to 64                                                                                               
[    0.911113] uhci_hcd 0000:00:1a.1: UHCI Host Controller                                                                                                      
[    0.911200] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4                                                                             
[    0.911299] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880                                                                                                
[    0.911410] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001                                                                                    
[    0.911473] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                               
[    0.911541] usb usb4: Product: UHCI Host Controller                                                                                                          
[    0.911602] usb usb4: Manufacturer: Linux 2.6.32-custom-radeon uhci_hcd                                                                                      
[    0.911665] usb usb4: SerialNumber: 0000:00:1a.1                                                                                                             
[    0.911769] usb usb4: configuration #1 chosen from 1 choice                                                                                                  
[    0.911853] hub 4-0:1.0: USB hub found                                                                                                                       
[    0.911918] hub 4-0:1.0: 2 ports detected                                                                                                                    
[    0.912190] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0                                                                                         
[    0.912255]   alloc irq_desc for 22 on node -1                                                                                                               
[    0.912257]   alloc kstat_irqs on node -1                                                                                                                    
[    0.912261] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22                                                                                
[    0.912328] uhci_hcd 0000:00:1a.2: setting latency timer to 64                                                                                               
[    0.912331] uhci_hcd 0000:00:1a.2: UHCI Host Controller                                                                                                      
[    0.912425] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5                                                                             
[    0.912523] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0                                                                                                
[    0.912615] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001                                                                                    
[    0.912678] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                               
[    0.912746] usb usb5: Product: UHCI Host Controller                                                                                                          
[    0.912808] usb usb5: Manufacturer: Linux 2.6.32-custom-radeon uhci_hcd                                                                                      
[    0.912870] usb usb5: SerialNumber: 0000:00:1a.2                                                                                                             
[    0.912964] usb usb5: configuration #1 chosen from 1 choice                                                                                                  
[    0.913048] hub 5-0:1.0: USB hub found                                                                                                                       
[    0.913113] hub 5-0:1.0: 2 ports detected                                                                                                                    
[    0.913383] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0                                                                                         
[    0.913448] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                
[    0.913515] uhci_hcd 0000:00:1d.0: setting latency timer to 64                                                                                               
[    0.913518] uhci_hcd 0000:00:1d.0: UHCI Host Controller                                                                                                      
[    0.913605] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6                                                                             
[    0.913703] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0                                                                                                
[    0.913794] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001                                                                                    
[    0.913857] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                               
[    0.913925] usb usb6: Product: UHCI Host Controller                                                                                                          
[    0.913986] usb usb6: Manufacturer: Linux 2.6.32-custom-radeon uhci_hcd                                                                                      
[    0.914049] usb usb6: SerialNumber: 0000:00:1d.0                                                                                                             
[    0.914141] usb usb6: configuration #1 chosen from 1 choice                                                                                                  
[    0.914225] hub 6-0:1.0: USB hub found                                                                                                                       
[    0.914289] hub 6-0:1.0: 2 ports detected                                                                                                                    
[    0.914400] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17                                                                                
[    0.914467] uhci_hcd 0000:00:1d.1: setting latency timer to 64                                                                                               
[    0.914470] uhci_hcd 0000:00:1d.1: UHCI Host Controller                                                                                                      
[    0.914557] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7                                                                             
[    0.914648] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0                                                                                                
[    0.914738] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001                                                                                    
[    0.914801] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                               
[    0.914869] usb usb7: Product: UHCI Host Controller                                                                                                          
[    0.914930] usb usb7: Manufacturer: Linux 2.6.32-custom-radeon uhci_hcd                                                                                      
[    0.914992] usb usb7: SerialNumber: 0000:00:1d.1                                                                                                             
[    0.915086] usb usb7: configuration #1 chosen from 1 choice                                                                                                  
[    0.915169] hub 7-0:1.0: USB hub found                                                                                                                       
[    0.915234] hub 7-0:1.0: 2 ports detected                                                                                                                    
[    0.915352] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18                                                                                
[    0.915419] uhci_hcd 0000:00:1d.2: setting latency timer to 64                                                                                               
[    0.915422] uhci_hcd 0000:00:1d.2: UHCI Host Controller                                                                                                      
[    0.915508] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8                                                                             
[    0.915599] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00                                                                                                
[    0.915689] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001                                                                                    
[    0.915752] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1                                                                               
[    0.915819] usb usb8: Product: UHCI Host Controller                                                                                                          
[    0.915881] usb usb8: Manufacturer: Linux 2.6.32-custom-radeon uhci_hcd                                                                                      
[    0.915943] usb usb8: SerialNumber: 0000:00:1d.2                                                                                                             
[    0.916036] usb usb8: configuration #1 chosen from 1 choice                                                                                                  
[    0.916121] hub 8-0:1.0: USB hub found                                                                                                                       
[    0.916185] hub 8-0:1.0: 2 ports detected                                                                                                                    
[    1.172019] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)                                                                                           
[    1.172950] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded                                                                                  
[    1.172953] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out                                                                       
[    1.173079] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded                                                                                  
[    1.173081] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out                                                                               
[    1.213104] ata1.00: ATA-8: WDC WD1600BEVS-08VAT2, 14.01A14, max UDMA/133                                                                                    
[    1.213168] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA                                                                                
[    1.214598] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded                                                                                  
[    1.214601] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out                                                                       
[    1.214764] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded                                                                                  
[    1.214767] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out                                                                               
[    1.216109] ata1.00: configured for UDMA/133                                                                                                                 
[    1.235510] ata1.00: configured for UDMA/133                                                                                                                 
[    1.235572] ata1: EH complete                                                                                                                                
[    1.235712] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVS-0 14.0 PQ: 0 ANSI: 5                                                                     
[    1.292045] firewire_core: created device fw0: GUID 00016c2000a7ebc0, S400                                                                                   
[    1.356006] usb 6-1: new low speed USB device using uhci_hcd and address 2                                                                                   
[    1.536823] usb 6-1: New USB device found, idVendor=045e, idProduct=00cb                                                                                     
[    1.536887] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0                                                                                
[    1.536950] usb 6-1: Product: Microsoft Basic Optical Mouse v2.0                                                                                             
[    1.537011] usb 6-1: Manufacturer: Microsoft                                                                                                                 
[    1.537112] usb 6-1: configuration #1 chosen from 1 choice                                                                                                   
[    1.552519] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)                                                                                           
[    1.555273] ata2.00: ACPI cmd e3/00:79:00:00:00:a0 (IDLE) succeeded                                                                                          
[    1.556095] ata2.00: ACPI cmd e3/00:01:00:00:00:a0 (IDLE) succeeded                                                                                          
[    1.557916] ata2.00: ATAPI: MATSHITADVD-RAM UJ862AC, SB01, max UDMA/33                                                                                       
[    1.560869] ata2.00: ACPI cmd e3/00:79:00:00:00:a0 (IDLE) succeeded                                                                                          
[    1.561692] ata2.00: ACPI cmd e3/00:01:00:00:00:a0 (IDLE) succeeded                                                                                          
[    1.563594] ata2.00: configured for UDMA/33                                                                                                                  
[    1.581680] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AC  SB01 PQ: 0 ANSI: 5                                                                     
[    1.584058] usbcore: registered new interface driver hiddev                                                                                                  
[    1.589083] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)                                                                            
[    1.589185] sd 0:0:0:0: [sda] Write Protect is off                                                                                                           
[    1.589247] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00                                                                                                        
[    1.589265] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA                                                          
[    1.589428]  sda:sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray                                                                       
[    1.594372] Uniform CD-ROM driver Revision: 3.20                                                                                                             
[    1.594499] sr 1:0:0:0: Attached scsi CD-ROM sr0                                                                                                             
[    1.597996] input: Microsoft  Microsoft Basic Optical Mouse v2.0  as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input6                          
[    1.598110] generic-usb 0003:045E:00CB.0001: input,hidraw0: USB HID v1.11 Mouse [Microsoft  Microsoft Basic Optical Mouse v2.0 ] on usb-0000:00:1d.0-1/input0
[    1.598197] usbcore: registered new interface driver usbhid                                                                                                  
[    1.598259] usbhid: v2.6:USB HID core driver                                                                                                                 
[    1.599386]  sda1 sda2 sda3 < sda5 > sda4                                                                                                                    
[    1.624005] sd 0:0:0:0: [sda] Attached SCSI disk                                                                                                             
[    1.627537] sd 0:0:0:0: Attached scsi generic sg0 type 0                                                                                                     
[    1.627622] sr 1:0:0:0: Attached scsi generic sg1 type 5                                                                                                     
[    2.088860] PM: Starting manual resume from disk                                                                                                             
[    2.126080] EXT4-fs (sda4): mounted filesystem with ordered data mode                                                                                        
[    3.888490] udev: starting version 147                                                                                                                       
[    4.389110] ACPI: AC Adapter [AC] (on-line)                                                                                                                  
[    4.405916] ACPI: Battery Slot [BAT0] (battery present)                                                                                                      
[    4.473709] Non-volatile memory driver v1.3                                                                                                                  
[    4.522000] ACPI: SSDT 00000000bfad6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)                                                                   
[    4.522723] ACPI: SSDT 00000000bfad4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)                                                                   
[    4.528927] Monitor-Mwait will be used to enter C-1 state                                                                                                    
[    4.528945] Monitor-Mwait will be used to enter C-2 state                                                                                                    
[    4.528960] Monitor-Mwait will be used to enter C-3 state                                                                                                    
[    4.528965] Marking TSC unstable due to TSC halts in idle                                                                                                    
[    4.529108] processor LNXCPU:00: registered as cooling_device1                                                                                               
[    4.531647] Switching to clocksource hpet                                                                                                                    
[    4.532354] ACPI: SSDT 00000000bfad5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)                                                                   
[    4.532911] ACPI: SSDT 00000000bfad5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)                                                                   
[    4.534474] processor LNXCPU:01: registered as cooling_device2                                                                                               
[    4.542110] ACPI: WMI: Mapper loaded                                                                                                                         
[    4.883901] thinkpad_acpi: ThinkPad ACPI Extras v0.23                                                                                                        
[    4.883969] thinkpad_acpi: http://ibm-acpi.sf.net/                                                                                                           
[    4.884039] thinkpad_acpi: ThinkPad BIOS 6FET81WW (3.11 ), EC 7VHT15WW-1.05                                                                                  
[    4.884104] thinkpad_acpi: Lenovo ThinkPad W500, model 4058CTO                                                                                               
[    4.884547] thinkpad_acpi: radio switch found; radios are enabled                                                                                            
[    4.884696] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver                                  
[    4.884767] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...                                                                           
[    4.887873] Registered led device: tpacpi::thinklight                                                                                                        
[    4.887963] Registered led device: tpacpi::power                                                                                                             
[    4.888049] Registered led device: tpacpi::standby                                                                                                           
[    4.888130] Registered led device: tpacpi::thinkvantage                                                                                                      
[    4.891187] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.                                                              
[    4.891587] input: ThinkPad Extra Buttons as /devices/virtual/input/input7                                                                                   
[    5.226418] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]                                                                                     
[    5.262200] cfg80211: Using static regulatory domain info                                                                                                    
[    5.262263] cfg80211: Regulatory domain: US                                                                                                                  
[    5.262323]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)                                                                               
[    5.262390]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)                                                                                    
[    5.262453]  (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)                                                                                    
[    5.262515]  (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)                                                                                    
[    5.262578]  (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)                                                                                    
[    5.262640]  (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)                                                                                    
[    5.262703]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)                                                                                    
[    5.262852] cfg80211: Calling CRDA for country: US                                                                                                           
[    5.352811] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16                                                                                      
[    5.352881] yenta_cardbus 0000:15:00.0: Socket status: 30000006                                                                                              
[    5.352945] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge I/O window: 0x5000 - 0x8fff                                                                
[    5.353015] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf4300000 - 0xf7ffffff                                                     
[    5.353084] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf0000000 - 0xf3ffffff                                                     
[    5.430187] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1c0b1, caps: 0xd04791/0xb00000                                                                      
[    5.430263] serio: Synaptics pass-through port at isa0060/serio1/input0                                                                                      
[    5.472820] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23                                                                              
[    5.474166] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8                                                                 
[    5.766437] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks                                                                               
[    5.766510] iwlagn: Copyright(c) 2003-2009 Intel Corporation                                                                                                 
[    5.766659] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17                                                                                  
[    5.766757] iwlagn 0000:03:00.0: setting latency timer to 64                                                                                                 
[    5.766840] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5100AGN REV=0x54                                                                          
[    5.803364] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels                                                                          
[    5.803487]   alloc irq_desc for 31 on node -1                                                                                                               
[    5.803488]   alloc kstat_irqs on node -1                                                                                                                    
[    5.803506] iwlagn 0000:03:00.0: irq 31 for MSI/MSI-X                                                                                                        
[    5.991736] phy0: Selected rate control algorithm 'iwl-agn-rs'                                                                                               
[    6.202554] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17                                                                               
[    6.202681] HDA Intel 0000:00:1b.0: setting latency timer to 64                                                                                              
[    7.094877] Adding 4610612k swap on /dev/sda5.  Priority:-1 extents:1 across:4610612k                                                                        
[    7.527440] loop: module loaded                                                                                                                              
[    9.301653] fuse init (API version 7.13)                                                                                                                     
[    9.844234] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X                                                                                                        
[    9.896460] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input9                                                                             
[    9.904104] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X                                                                                                        
[    9.904625] ADDRCONF(NETDEV_UP): eth0: link is not ready                                                                                                     
[   11.193627] IBM TrackPoint firmware: 0x0e, buttons: 3/3                                                                                                      
[   11.432936] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input10                                                              
[   18.410514] vboxdrv: Trying to deactivate the NMI watchdog permanently...                                                                                    
[   18.410520] vboxdrv: Successfully done.                                                                                                                      
[   18.410525] vboxdrv: Found 2 processor cores.                                                                                                                
[   18.410623] VBoxDrv: dbg - g_abExecMemory=ffffffffa0328de0                                                                                                   
[   18.410810] vboxdrv: fAsync=0 offMin=0x3dc offMax=0x3998                                                                                                     
[   18.410991] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.                                                                               
[   18.411090] vboxdrv: Successfully loaded version 3.1.0 (interface 0x00100001).                                                                               
[   22.519452] pci 0000:01:00.0: power state changed by ACPI to D0                                                                                              
[   22.519472] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                     
[   22.635468] [drm] Initialized drm 1.1.0 20060810                                                                                                             
[   22.747215] pci 0000:01:00.0: setting latency timer to 64                                                                                                    
[   22.747539] [drm] Initialized radeon 1.31.0 20080528 for 0000:01:00.0 on minor 0                                                                             
[   23.751452] [drm] Setting GART location based on new memory map                                                                                              
[   23.752295] [drm] Loading RV635 CP Microcode                                                                                                                 
[   23.752303] platform r600_cp.0: firmware: requesting radeon/RV635_pfp.bin                                                                                    
[   23.840790] platform r600_cp.0: firmware: requesting radeon/RV635_me.bin                                                                                     
[   23.883619] [drm] Resetting GPU                                                                                                                              
[   23.883684] [drm] writeback test succeeded in 1 usecs                                                                                                        
[   25.057873] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-2.ucode                                                                                   
[   25.085507] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12                                                                                           
[   25.232973] Registered led device: iwl-phy0::radio                                                                                                           
[   25.233020] Registered led device: iwl-phy0::assoc
[   25.233062] Registered led device: iwl-phy0::RX
[   25.233109] Registered led device: iwl-phy0::TX
[   25.245984] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   43.313910] CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
[   64.635930] wlan0: deauthenticating from aa:bb:cc:dd:ee:ff by local choice (reason=3)
[   64.635987] wlan0: direct probe to AP aa:bb:cc:dd:ee:ff (try 1)
[   64.639282] wlan0: direct probe responded
[   64.639285] wlan0: authenticate with AP aa:bb:cc:dd:ee:ff (try 1)
[   64.642160] wlan0: authenticated
[   64.642173] wlan0: associate with AP aa:bb:cc:dd:ee:ff (try 1)
[   64.644571] wlan0: RX AssocResp from aa:bb:cc:dd:ee:ff (capab=0x431 status=0 aid=1)
[   64.644574] wlan0: associated
[   64.646127] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   64.711325] Intel AES-NI instructions are not detected.
[   74.792024] wlan0: no IPv6 routers present
[  169.408549] wlan0: deauthenticating from aa:bb:cc:dd:ee:ff by local choice (reason=3)
[  169.408650] wlan0: deauthenticating from aa:bb:cc:dd:ee:ff by local choice (reason=3)
[  261.181015] Registered led device: iwl-phy0::radio
[  261.181065] Registered led device: iwl-phy0::assoc
[  261.181107] Registered led device: iwl-phy0::RX
[  261.181149] Registered led device: iwl-phy0::TX
[  261.194390] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  264.402709] wlan0: deauthenticating from aa:bb:cc:dd:ee:ff by local choice (reason=3)
[  264.441283] wlan0: direct probe to AP aa:bb:cc:dd:ee:ff (try 1)
[  264.443696] wlan0: direct probe responded
[  264.443704] wlan0: authenticate with AP aa:bb:cc:dd:ee:ff (try 1)
[  264.445572] wlan0: authenticated
[  264.445601] wlan0: associate with AP aa:bb:cc:dd:ee:ff (try 1)
[  264.447948] wlan0: RX AssocResp from aa:bb:cc:dd:ee:ff (capab=0x431 status=0 aid=1)
[  264.447954] wlan0: associated
[  264.450633] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  274.476087] wlan0: no IPv6 routers present
