Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbZDQPAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbZDQPAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758934AbZDQPA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:00:28 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:43654 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbZDQPAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:00:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer;
        b=HkZK0CEfaPNIItozvxURq2jfvbJelGIWzId6xBAgiEBOjdYTweEnL1snICw8tCeuzk
         nUm0uJ4lbO3PSiweBvpwwoKf7ZflBF+IYFeq5W9Ww7mpPVA2jsWhyAE+cAXAhs73/OqR
         U5mY9iSe9Q2adAGGUEky0VNKA3psp3nc24eB0=
Subject: 2.6.29.1 sdhci: irq 19: nobody cared
From: Alessandro Bono <alessandro.bono@gmail.com>
To: sdhci-devel@list.drzeus.cx, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-HSaFkWIgE8JUGtwOuwxQ"
Date: Fri, 17 Apr 2009 17:00:18 +0200
Message-Id: <1239980418.6220.15.camel@champagne>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HSaFkWIgE8JUGtwOuwxQ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi

This is a bug that occur from time to time on my (unsed) sdhci card
drive
this is with kernel 2.6.29.1 (not a regression, I had the same problem
with older kernel)

[ 2885.888003] irq 19: nobody cared (try booting with the "irqpoll"
option)
[ 2885.888014] Pid: 0, comm: swapper Not tainted 2.6.29.1 #1
[ 2885.888019] Call Trace:
[ 2885.888023]  <IRQ>  [<ffffffff802751cb>] __report_bad_irq+0x38/0x87
[ 2885.888045]  [<ffffffff80275332>] note_interrupt+0x118/0x182
[ 2885.888053]  [<ffffffff80275962>] handle_fasteoi_irq+0xa1/0xc5
[ 2885.888062]  [<ffffffff8020de49>] do_IRQ+0x70/0xe7
[ 2885.888069]  [<ffffffff8020bf53>] ret_from_intr+0x0/0xa
[ 2885.888073]  <EOI>  [<ffffffff8024f317>] ? notifier_call_chain
+0x33/0x5b
[ 2885.888136]  [<ffffffffa002b7bb>] ? acpi_idle_enter_simple
+0x186/0x1f8 [processor]
[ 2885.888159]  [<ffffffffa002b7b1>] ? acpi_idle_enter_simple
+0x17c/0x1f8 [processor]
[ 2885.888169]  [<ffffffff80399fa6>] ? cpuidle_idle_call+0x8c/0xc6
[ 2885.888176]  [<ffffffff8020a649>] ? cpu_idle+0x52/0x93
[ 2885.888184]  [<ffffffff804133cd>] ? rest_init+0x61/0x63
[ 2885.888189] handlers:
[ 2885.888192] [<ffffffffa02b2b86>] (sdhci_irq+0x0/0x49a [sdhci])
[ 2885.888208] Disabling IRQ #19


as you can see there is a lot of interrupts on mmc0 but seems strange
because I don't use this drive at all


cat /proc/interrupts 
           CPU0       CPU1               
  0:     320163     361871   IO-APIC-edge      timer
  1:        997       1017   IO-APIC-edge      i8042
  7:          0          0   IO-APIC-edge      parport0
  9:       3427        205   IO-APIC-fasteoi   acpi    
 12:        920        876   IO-APIC-edge      i8042   
 14:      43038        224   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:      34787         50   IO-APIC-fasteoi   uhci_hcd:usb2, yenta
 17:        742        735   IO-APIC-fasteoi   uhci_hcd:usb4, yenta, HDA
Intel, HDA Intel
 18:          2          2   IO-APIC-fasteoi   ohci1394, ehci_hcd:usb1,
uhci_hcd:usb7    
 19:    5399854        147   IO-APIC-fasteoi
mmc0                                      
 20:         12         12   IO-APIC-fasteoi   ehci_hcd:usb3,
uhci_hcd:usb5              
 22:          0          0   IO-APIC-fasteoi
uhci_hcd:usb6                             
 28:      57246         12   PCI-MSI-edge
eth0                                      
 29:      26003      21615   PCI-MSI-edge
ahci                                      
 30:        922        722   PCI-MSI-edge
iwlagn                                    
NMI:          0          0   Non-maskable
interrupts                                     
LOC:     235843     241312   Local timer
interrupts                                      
RES:      58369      76238   Rescheduling
interrupts                                     
CAL:         67         65   Function call
interrupts                                    
TLB:       3679       4198   TLB
shootdowns                                              
TRM:          0          0   Thermal event
interrupts                                    
THR:          0          0   Threshold APIC
interrupts                                   
SPU:          0          0   Spurious
interrupts                                         
ERR:
0                                                                          
MIS:          0                                   


from dmesg

[    9.220049] ricoh-mmc: Ricoh MMC Controller disabling driver
[    9.220054] ricoh-mmc: Copyright(c) Philip Langdale
[    9.258786] sdhci: Secure Digital Host Controller Interface driver
[    9.258788] sdhci: Copyright(c) Pierre Ossman
[    9.329406] ricoh-mmc: Ricoh MMC controller found at 0000:02:06.4
[1180:0843] (rev 10)
[    9.329424] ricoh-mmc: Controller is now disabled.
[    9.329463] sdhci-pci 0000:02:06.3: SDHCI controller found
[1180:0822] (rev 20)
[    9.329480] sdhci-pci 0000:02:06.3: PCI INT D -> GSI 19 (level, low)
-> IRQ 19
[    9.331556] Registered led device: mmc0::
[    9.332608] mmc0: SDHCI controller on PCI [0000:02:06.3] using PIO


dmesg attached

tell me if you need other info

thanks

-- 
Cordiali Saluti
Alessandro Bono

--=-HSaFkWIgE8JUGtwOuwxQ
Content-Disposition: attachment; filename="dmesg-2.6.29.1"
Content-Type: text/plain; name="dmesg-2.6.29.1"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.29.1 (root@champagne) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu12) ) #1 SMP Fri Apr 3 09:23:25 CEST 2009
[    0.000000] Command line: root=UUID=0a96113a-5259-480a-abac-a27a7f9ae544 ro quiet splash 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
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
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbffb0 max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bffb0000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bffb0000 page 4k
[    0.000000] kernel direct mapping tables up to bffb0000 @ 8000-d000
[    0.000000] last_map_addr: bffb0000 end: bffb0000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ b000-11000
[    0.000000] last_map_addr: 13c000000 end: 13c000000
[    0.000000] RAMDISK: 379f8000 - 37fef16a
[    0.000000] ACPI: RSDP 000F7D10, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT BFFC81CC, 0084 (r1 HPQOEM SLIC-MPC        1 HP          1)
[    0.000000] ACPI: FACP BFFC8084, 00F4 (r4 HP     30C5            3 HP          1)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT BFFC8544, 12EAD (r1 HP        8510x    10000 MSFT  3000001)
[    0.000000] ACPI: FACS BFFE7D80, 0040
[    0.000000] ACPI: SLIC BFFC8250, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
[    0.000000] ACPI: HPET BFFC83C8, 0038 (r1 HP     30C5            1 HP          1)
[    0.000000] ACPI: APIC BFFC8400, 0068 (r1 HP     30C5            1 HP          1)
[    0.000000] ACPI: MCFG BFFC8468, 003C (r1 HP     30C5            1 HP          1)
[    0.000000] ACPI: TCPA BFFC84A4, 0032 (r2 HP     30C5            1 HP          1)
[    0.000000] ACPI: ASF! BFFC84D8, 0069 (r16 HP     CHIMAYU         1 HP          0)
[    0.000000] ACPI: SSDT BFFDB3F1, 0328 (r1 HP       HPQSAT        1 MSFT  3000001)
[    0.000000] ACPI: SSDT BFFDB719, 017C (r1 HP       HPQMRM        1 MSFT  3000001)
[    0.000000] ACPI: SSDT BFFDC29D, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
[    0.000000] ACPI: SSDT BFFDC4FC, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
[    0.000000] ACPI: SSDT BFFDC5A2, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 013c000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 000067e94c]    TEXT DATA BSS ==> [0000200000 - 000067e94c]
[    0.000000]   #3 [00379f8000 - 0037fef16a]          RAMDISK ==> [00379f8000 - 0037fef16a]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
[    0.000000]   #6 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]
[    0.000000]  [ffffe20000000000-ffffe200045fffff] PMD -> [ffff880028200000-ffff88002c7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bffb0
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1032015
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1253 pages reserved
[    0.000000]   DMA zone: 2690 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767976 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
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
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 49152 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1013066
[    0.000000] Kernel command line: root=UUID=0a96113a-5259-480a-abac-a27a7f9ae544 ro quiet splash 
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2394.566 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] allocated 52428800 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.004000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.004000] Memory: 3921096k/5177344k available (2197k kernel code, 1049284k absent, 206020k reserved, 1346k data, 312k init)
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4789.13 BogoMIPS (lpj=9578264)
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys devices
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring handled by SMI
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20081204
[    0.024064] Setting APIC routing to flat
[    0.024434] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.066317] CPU0: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0b
[    0.068001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4787.95 BogoMIPS (lpj=9575919)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.153294] CPU1: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0b
[    0.153314] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.156028] Brought up 2 CPUs
[    0.156030] Total of 2 processors activated (9577.09 BogoMIPS).
[    0.156077] CPU0 attaching sched-domain:
[    0.156079]  domain 0: span 0-1 level MC
[    0.156081]   groups: 0 1
[    0.156085] CPU1 attaching sched-domain:
[    0.156086]  domain 0: span 0-1 level MC
[    0.156088]   groups: 1 0
[    0.156152] net_namespace: 1792 bytes
[    0.156152] NET: Registered protocol family 16
[    0.156152] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.156152] ACPI: bus type pci registered
[    0.156152] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.156152] PCI: Not using MMCONFIG.
[    0.156152] PCI: Using configuration type 1 for base access
[    0.156152] bio: create slab <bio-0> at 0
[    0.160044] ACPI: EC: Look up EC in DSDT
[    0.188019] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.212311] ACPI: Interpreter enabled
[    0.212314] ACPI: (supports S0 S3 S4 S5)
[    0.212328] ACPI: Using IOAPIC for interrupt routing
[    0.212391] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.222774] PCI: MCFG area at f8000000 reserved in ACPI motherboard resources
[    0.225062] PCI: Using MMCONFIG at f8000000 - fbffffff
[    0.236440] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    0.236440] ACPI: EC: driver started in interrupt mode
[    0.240091] ACPI: No dock devices found.
[    0.240101] ACPI: PCI Root Bridge [C003] (0000:00)
[    0.240125] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.240125] pci 0000:00:01.0: PME# disabled
[    0.240125] pci 0000:00:03.0: reg 10 64bit mmio: [0xe4500000-0xe450000f]
[    0.240149] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.240151] pci 0000:00:03.0: PME# disabled
[    0.240178] pci 0000:00:03.2: reg 10 io port: [0x5000-0x5007]
[    0.240182] pci 0000:00:03.2: reg 14 io port: [0x5008-0x500b]
[    0.240187] pci 0000:00:03.2: reg 18 io port: [0x5010-0x5017]
[    0.240191] pci 0000:00:03.2: reg 1c io port: [0x5018-0x501b]
[    0.240195] pci 0000:00:03.2: reg 20 io port: [0x5020-0x502f]
[    0.240239] pci 0000:00:03.3: reg 10 io port: [0x5030-0x5037]
[    0.240244] pci 0000:00:03.3: reg 14 32bit mmio: [0xe4501000-0xe4501fff]
[    0.240349] pci 0000:00:19.0: reg 10 32bit mmio: [0xe4520000-0xe453ffff]
[    0.240357] pci 0000:00:19.0: reg 14 32bit mmio: [0xe4540000-0xe4540fff]
[    0.240364] pci 0000:00:19.0: reg 18 io port: [0x5040-0x505f]
[    0.240414] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.240418] pci 0000:00:19.0: PME# disabled
[    0.240468] pci 0000:00:1a.0: reg 20 io port: [0x5060-0x507f]
[    0.240530] pci 0000:00:1a.1: reg 20 io port: [0x5080-0x509f]
[    0.240598] pci 0000:00:1a.7: reg 10 32bit mmio: [0xe4541000-0xe45413ff]
[    0.240660] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.240664] pci 0000:00:1a.7: PME# disabled
[    0.240716] pci 0000:00:1b.0: reg 10 64bit mmio: [0xe4544000-0xe4547fff]
[    0.240775] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.240779] pci 0000:00:1b.0: PME# disabled
[    0.240860] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.240864] pci 0000:00:1c.0: PME# disabled
[    0.240948] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.240952] pci 0000:00:1c.1: PME# disabled
[    0.241040] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.241044] pci 0000:00:1c.4: PME# disabled
[    0.241104] pci 0000:00:1d.0: reg 20 io port: [0x50a0-0x50bf]
[    0.241168] pci 0000:00:1d.1: reg 20 io port: [0x50c0-0x50df]
[    0.241230] pci 0000:00:1d.2: reg 20 io port: [0x50e0-0x50ff]
[    0.241298] pci 0000:00:1d.7: reg 10 32bit mmio: [0xe4548000-0xe45483ff]
[    0.241359] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.241364] pci 0000:00:1d.7: PME# disabled
[    0.241528] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.241532] pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH6 GPIO
[    0.241536] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0500 (mask 007f)
[    0.241543] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 02e8 (mask 0007)
[    0.241593] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    0.241600] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    0.241608] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    0.241615] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    0.241622] pci 0000:00:1f.1: reg 20 io port: [0x5100-0x510f]
[    0.241692] pci 0000:00:1f.2: reg 10 io port: [0x13f0-0x13f7]
[    0.241699] pci 0000:00:1f.2: reg 14 io port: [0x15f4-0x15f7]
[    0.241706] pci 0000:00:1f.2: reg 18 io port: [0x1370-0x1377]
[    0.241713] pci 0000:00:1f.2: reg 1c io port: [0x1574-0x1577]
[    0.241721] pci 0000:00:1f.2: reg 20 io port: [0x5140-0x515f]
[    0.241728] pci 0000:00:1f.2: reg 24 32bit mmio: [0xe4549000-0xe45497ff]
[    0.241769] pci 0000:00:1f.2: PME# supported from D3hot
[    0.241773] pci 0000:00:1f.2: PME# disabled
[    0.241825] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
[    0.241833] pci 0000:01:00.0: reg 14 io port: [0x4000-0x40ff]
[    0.241839] pci 0000:01:00.0: reg 18 32bit mmio: [0xe4400000-0xe440ffff]
[    0.241862] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.241890] pci 0000:01:00.0: supports D1 D2
[    0.241932] pci 0000:01:00.1: reg 10 32bit mmio: [0xe4410000-0xe4413fff]
[    0.241992] pci 0000:01:00.1: supports D1 D2
[    0.242057] pci 0000:00:01.0: bridge io port: [0x4000-0x4fff]
[    0.242060] pci 0000:00:01.0: bridge 32bit mmio: [0xe4400000-0xe44fffff]
[    0.242063] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.242254] pci 0000:10:00.0: reg 10 64bit mmio: [0xe4000000-0xe4001fff]
[    0.242381] pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
[    0.242394] pci 0000:10:00.0: PME# disabled
[    0.242482] pci 0000:00:1c.1: bridge 32bit mmio: [0xe4000000-0xe40fffff]
[    0.242544] pci 0000:00:1c.4: bridge io port: [0x2000-0x3fff]
[    0.242549] pci 0000:00:1c.4: bridge 32bit mmio: [0xe0000000-0xe3ffffff]
[    0.242606] pci 0000:02:06.0: reg 10 32bit mmio: [0xe4100000-0xe4100fff]
[    0.242628] pci 0000:02:06.0: supports D1 D2
[    0.242629] pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.242634] pci 0000:02:06.0: PME# disabled
[    0.242673] pci 0000:02:06.1: reg 10 32bit mmio: [0xe4101000-0xe4101fff]
[    0.242697] pci 0000:02:06.1: supports D1 D2
[    0.242698] pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.242703] pci 0000:02:06.1: PME# disabled
[    0.242742] pci 0000:02:06.2: reg 10 32bit mmio: [0xe4102000-0xe41027ff]
[    0.242801] pci 0000:02:06.2: supports D1 D2
[    0.242802] pci 0000:02:06.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.242807] pci 0000:02:06.2: PME# disabled
[    0.242847] pci 0000:02:06.3: reg 10 32bit mmio: [0xe4103000-0xe41030ff]
[    0.242904] pci 0000:02:06.3: supports D1 D2
[    0.242906] pci 0000:02:06.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.242910] pci 0000:02:06.3: PME# disabled
[    0.242951] pci 0000:02:06.4: reg 10 32bit mmio: [0xe4104000-0xe41040ff]
[    0.243010] pci 0000:02:06.4: supports D1 D2
[    0.243011] pci 0000:02:06.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.243016] pci 0000:02:06.4: PME# disabled
[    0.243070] pci 0000:00:1e.0: transparent bridge
[    0.243077] pci 0000:00:1e.0: bridge 32bit mmio: [0xe4100000-0xe43fffff]
[    0.243146] pci_bus 0000:00: on NUMA node 0
[    0.243151] ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
[    0.243412] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C096._PRT]
[    0.243482] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B0._PRT]
[    0.243591] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11D._PRT]
[    0.243672] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C131._PRT]
[    0.243755] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C134._PRT]
[    0.298307] ACPI: PCI Interrupt Link [C12D] (IRQs *10 11)
[    0.298307] ACPI: PCI Interrupt Link [C12E] (IRQs *10 11)
[    0.298307] ACPI: PCI Interrupt Link [C12F] (IRQs 10 *11)
[    0.298307] ACPI: PCI Interrupt Link [C130] (IRQs 10 11) *5
[    0.300020] ACPI: PCI Interrupt Link [C140] (IRQs *10 11)
[    0.300259] ACPI: PCI Interrupt Link [C141] (IRQs 10 11) *5
[    0.300497] ACPI: PCI Interrupt Link [C142] (IRQs 10 *11)
[    0.300607] ACPI Exception (pci_link-0189): AE_NOT_FOUND, Evaluating _PRS [20081204]
[    0.300728] ACPI: Power Resource [C238] (on)
[    0.300728] ACPI: Power Resource [C254] (on)
[    0.300728] ACPI: Power Resource [C17C] (off)
[    0.300728] ACPI: Power Resource [C363] (off)
[    0.300728] ACPI: Power Resource [C366] (off)
[    0.300728] ACPI: Power Resource [C367] (off)
[    0.300754] ACPI: Power Resource [C368] (off)
[    0.300863] ACPI: Power Resource [C369] (off)
[    0.300914] ACPI: Power Resource [C36A] (off)
[    0.301023] ACPI: Power Resource [C383] (off)
[    0.301132] ACPI: Power Resource [C384] (off)
[    0.301240] ACPI: Power Resource [C385] (off)
[    0.301349] ACPI: Power Resource [C386] (off)
[    0.301458] ACPI: Power Resource [C387] (off)
[    0.301469] PCI: Using ACPI for IRQ routing
[    0.312014] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.312017] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.328004] pnp: PnP ACPI init
[    0.328010] ACPI: bus type pnp registered
[    0.338988] pnp: PnP ACPI: found 15 devices
[    0.338990] ACPI: ACPI bus type pnp unregistered
[    0.338997] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.338999] system 00:00: iomem range 0xe0000-0xfffff could not be reserved
[    0.339001] system 00:00: iomem range 0x100000-0xbfffffff could not be reserved
[    0.339008] system 00:0b: ioport range 0x500-0x55f has been reserved
[    0.339010] system 00:0b: ioport range 0x800-0x80f has been reserved
[    0.339013] system 00:0b: iomem range 0xffb00000-0xffbfffff has been reserved
[    0.339015] system 00:0b: iomem range 0xfff00000-0xffffffff has been reserved
[    0.339019] system 00:0d: ioport range 0x4d0-0x4d1 has been reserved
[    0.339021] system 00:0d: ioport range 0x1000-0x107f has been reserved
[    0.339023] system 00:0d: ioport range 0x1100-0x113f has been reserved
[    0.339025] system 00:0d: ioport range 0x1200-0x121f has been reserved
[    0.339028] system 00:0d: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.339030] system 00:0d: iomem range 0xfec00000-0xfec000ff has been reserved
[    0.339032] system 00:0d: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.339034] system 00:0d: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.339036] system 00:0d: iomem range 0xfed90000-0xfed99fff has been reserved
[    0.339040] system 00:0e: iomem range 0xcf400-0xcffff has been reserved
[    0.339042] system 00:0e: iomem range 0xfeda0000-0xfedbffff has been reserved
[    0.339044] system 00:0e: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.343889] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.343891] pci 0000:00:01.0:   IO window: 0x4000-0x4fff
[    0.343895] pci 0000:00:01.0:   MEM window: 0xe4400000-0xe44fffff
[    0.343898] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.343902] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:08
[    0.343903] pci 0000:00:1c.0:   IO window: disabled
[    0.343909] pci 0000:00:1c.0:   MEM window: disabled
[    0.343913] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.343920] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:10
[    0.343921] pci 0000:00:1c.1:   IO window: disabled
[    0.343927] pci 0000:00:1c.1:   MEM window: 0xe4000000-0xe40fffff
[    0.343931] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.343938] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:28
[    0.343941] pci 0000:00:1c.4:   IO window: 0x2000-0x3fff
[    0.343947] pci 0000:00:1c.4:   MEM window: 0xe0000000-0xe3ffffff
[    0.343951] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.343962] pci 0000:02:06.0: CardBus bridge, secondary bus 0000:03
[    0.343963] pci 0000:02:06.0:   IO window: 0x006000-0x0060ff
[    0.343968] pci 0000:02:06.0:   IO window: 0x006400-0x0064ff
[    0.343972] pci 0000:02:06.0:   PREFETCH window: 0xc4000000-0xc7ffffff
[    0.343977] pci 0000:02:06.0:   MEM window: 0xcc000000-0xcfffffff
[    0.343981] pci 0000:02:06.1: CardBus bridge, secondary bus 0000:04
[    0.343983] pci 0000:02:06.1:   IO window: 0x006800-0x0068ff
[    0.343987] pci 0000:02:06.1:   IO window: 0x006c00-0x006cff
[    0.343999] pci 0000:02:06.1:   PREFETCH window: 0xc8000000-0xcbffffff
[    0.344004] pci 0000:02:06.1:   MEM window: 0xe8000000-0xebffffff
[    0.344008] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[    0.344011] pci 0000:00:1e.0:   IO window: 0x6000-0x6fff
[    0.344017] pci 0000:00:1e.0:   MEM window: 0xe4100000-0xe43fffff
[    0.344021] pci 0000:00:1e.0:   PREFETCH window: 0x000000c4000000-0x000000cbffffff
[    0.344034] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.344037] pci 0000:00:01.0: setting latency timer to 64
[    0.344045] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.344049] pci 0000:00:1c.0: setting latency timer to 64
[    0.344058] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.344062] pci 0000:00:1c.1: setting latency timer to 64
[    0.344070] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.344074] pci 0000:00:1c.4: setting latency timer to 64
[    0.344082] pci 0000:00:1e.0: setting latency timer to 64
[    0.344090] pci 0000:02:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.344100] pci 0000:02:06.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.344105] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.344107] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.344109] pci_bus 0000:01: resource 0 io:  [0x4000-0x4fff]
[    0.344111] pci_bus 0000:01: resource 1 mem: [0xe4400000-0xe44fffff]
[    0.344113] pci_bus 0000:01: resource 2 mem: [0xd0000000-0xdfffffff]
[    0.344114] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.344116] pci_bus 0000:08: resource 0 mem: [0x0-0x0]
[    0.344118] pci_bus 0000:08: resource 1 mem: [0x0-0x0]
[    0.344119] pci_bus 0000:08: resource 2 mem: [0x0-0x0]
[    0.344120] pci_bus 0000:08: resource 3 mem: [0x0-0x0]
[    0.344122] pci_bus 0000:10: resource 0 mem: [0x0-0x0]
[    0.344124] pci_bus 0000:10: resource 1 mem: [0xe4000000-0xe40fffff]
[    0.344125] pci_bus 0000:10: resource 2 mem: [0x0-0x0]
[    0.344127] pci_bus 0000:10: resource 3 mem: [0x0-0x0]
[    0.344128] pci_bus 0000:28: resource 0 io:  [0x2000-0x3fff]
[    0.344130] pci_bus 0000:28: resource 1 mem: [0xe0000000-0xe3ffffff]
[    0.344132] pci_bus 0000:28: resource 2 mem: [0x0-0x0]
[    0.344133] pci_bus 0000:28: resource 3 mem: [0x0-0x0]
[    0.344135] pci_bus 0000:02: resource 0 io:  [0x6000-0x6fff]
[    0.344136] pci_bus 0000:02: resource 1 mem: [0xe4100000-0xe43fffff]
[    0.344138] pci_bus 0000:02: resource 2 mem: [0xc4000000-0xcbffffff]
[    0.344140] pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
[    0.344141] pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.344143] pci_bus 0000:03: resource 0 io:  [0x6000-0x60ff]
[    0.344145] pci_bus 0000:03: resource 1 io:  [0x6400-0x64ff]
[    0.344146] pci_bus 0000:03: resource 2 mem: [0xc4000000-0xc7ffffff]
[    0.344148] pci_bus 0000:03: resource 3 mem: [0xcc000000-0xcfffffff]
[    0.344150] pci_bus 0000:04: resource 0 io:  [0x6800-0x68ff]
[    0.344151] pci_bus 0000:04: resource 1 io:  [0x6c00-0x6cff]
[    0.344153] pci_bus 0000:04: resource 2 mem: [0xc8000000-0xcbffffff]
[    0.344155] pci_bus 0000:04: resource 3 mem: [0xe8000000-0xebffffff]
[    0.344176] NET: Registered protocol family 2
[    0.380027] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.380498] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.382327] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.382860] TCP: Hash tables configured (established 262144 bind 65536)
[    0.382862] TCP reno registered
[    0.392078] NET: Registered protocol family 1
[    0.392185] checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
[    0.503956] Switched to high resolution mode on CPU 0
[    0.593610]  it is
[    0.808364] Freeing initrd memory: 6108k freed
[    0.811728] audit: initializing netlink socket (disabled)
[    0.811741] type=2000 audit(1239975323.809:1): initialized
[    0.812116] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.814004] VFS: Disk quotas dquot_6.5.2
[    0.814069] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.814144] msgmni has been set to 7672
[    0.814293] alg: No test for stdrng (krng)
[    0.814371] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.814373] io scheduler noop registered
[    0.814422] io scheduler cfq registered (default)
[    0.814573] pci 0000:01:00.0: Boot video device
[    0.814678] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    0.814724] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
[    0.814829] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.814902] pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
[    0.815037] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.815111] pcieport-driver 0000:00:1c.1: irq 26 for MSI/MSI-X
[    0.815272] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.815346] pcieport-driver 0000:00:1c.4: irq 27 for MSI/MSI-X
[    0.818273] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.818702] serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.818772] 0000:00:03.3: ttyS0 at I/O 0x5030 (irq = 17) is a 16550A
[    0.820036] brd: module loaded
[    0.820117] PNP: PS/2 Controller [PNP0303:C251,PNP0f13:C252] at 0x60,0x64 irq 1,12
[    0.821987] i8042.c: Detected active multiplexing controller, rev 1.1.
[    0.822745] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.822749] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.822752] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.822754] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.822756] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.822883] mice: PS/2 mouse device common for all mice
[    0.822945] cpuidle: using governor ladder
[    0.822947] cpuidle: using governor menu
[    0.823192] TCP cubic registered
[    0.823553] Freeing unused kernel memory: 312k freed
[    0.823684] Write protecting the kernel read-only data: 3264k
[    0.854052] input: AT Translated Set 2 keyboard as /class/input/input0
[    0.929059] fuse init (API version 7.11)
[    0.945851] fan PNP0C0B:00: registered as cooling_device0
[    0.945857] ACPI: Fan [C36B] (off)
[    0.946107] fan PNP0C0B:01: registered as cooling_device1
[    0.946112] ACPI: Fan [C36C] (off)
[    0.946358] fan PNP0C0B:02: registered as cooling_device2
[    0.946363] ACPI: Fan [C36D] (off)
[    0.946610] fan PNP0C0B:03: registered as cooling_device3
[    0.946614] ACPI: Fan [C36E] (off)
[    0.946859] fan PNP0C0B:04: registered as cooling_device4
[    0.946864] ACPI: Fan [C36F] (off)
[    0.946990] fan PNP0C0B:05: registered as cooling_device5
[    0.946994] ACPI: Fan [C370] (off)
[    0.947244] fan PNP0C0B:06: registered as cooling_device6
[    0.947249] ACPI: Fan [C388] (off)
[    0.947496] fan PNP0C0B:07: registered as cooling_device7
[    0.947500] ACPI: Fan [C389] (off)
[    0.947752] fan PNP0C0B:08: registered as cooling_device8
[    0.947757] ACPI: Fan [C38A] (off)
[    0.948011] fan PNP0C0B:09: registered as cooling_device9
[    0.948015] ACPI: Fan [C38B] (off)
[    0.948262] fan PNP0C0B:0a: registered as cooling_device10
[    0.948267] ACPI: Fan [C38C] (off)
[    0.952680] ACPI: SSDT BFFDB95D, 02C1 (r1 HP      Cpu0Ist     3000 INTL 20060317)
[    0.953137] ACPI: SSDT BFFDBCA3, 05FA (r1 HP      Cpu0Cst     3001 INTL 20060317)
[    0.959411] Monitor-Mwait will be used to enter C-1 state
[    0.959417] Monitor-Mwait will be used to enter C-2 state
[    0.959421] Monitor-Mwait will be used to enter C-3 state
[    0.959573] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.959610] processor ACPI_CPU:00: registered as cooling_device11
[    0.959613] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.959941] ACPI: SSDT BFFDB895, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20060317)
[    0.960295] ACPI: SSDT BFFDBC1E, 0085 (r1 HP      Cpu1Cst     3000 INTL 20060317)
[    0.961309] Marking TSC unstable due to TSC halts in idle
[    0.993122] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.993188] processor ACPI_CPU:01: registered as cooling_device12
[    0.993198] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.999203] thermal LNXTHERM:01: registered as thermal_zone0
[    1.001416] ACPI: Thermal Zone [TZ2] (39 C)
[    1.016096] thermal LNXTHERM:02: registered as thermal_zone1
[    1.017808] ACPI: Thermal Zone [TZ3] (33 C)
[    1.024692] thermal LNXTHERM:03: registered as thermal_zone2
[    1.036763] ACPI: Thermal Zone [TZ4] (33 C)
[    1.039495] thermal LNXTHERM:04: registered as thermal_zone3
[    1.045453] ACPI: Thermal Zone [TZ5] (73 C)
[    1.063577] thermal LNXTHERM:05: registered as thermal_zone4
[    1.072712] ACPI: Thermal Zone [TZ0] (51 C)
[    1.075758] thermal LNXTHERM:06: registered as thermal_zone5
[    1.077596] ACPI: Thermal Zone [TZ1] (53 C)
[    1.084652] device-mapper: uevent: version 1.0.3
[    1.084870] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    1.314054] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    1.314056] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    1.314100] e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.314109] e1000e 0000:00:19.0: setting latency timer to 64
[    1.314227] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[    1.338917] usbcore: registered new interface driver usbfs
[    1.338944] usbcore: registered new interface driver hub
[    1.353992] usbcore: registered new device driver usb
[    1.365279] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.366493] uhci_hcd: USB Universal Host Controller Interface driver
[    1.375539] SCSI subsystem initialized
[    1.377861] ohci1394 0000:02:06.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.389171] libata version 3.00 loaded.
[    1.438164] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[e4102000-e41027ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    1.500103] Clocksource tsc unstable (delta = -71030829 ns)
[    1.522477] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1a:4b:7a:9d:98
[    1.522479] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.522508] 0000:00:19.0: eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff
[    1.522737] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.522902] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.522906] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.522939] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.526843] ehci_hcd 0000:00:1a.7: debug port 1
[    1.526850] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    1.526854] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe4541000
[    1.541125] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.541243] usb usb1: configuration #1 chosen from 1 choice
[    1.541288] hub 1-0:1.0: USB hub found
[    1.541298] hub 1-0:1.0: 4 ports detected
[    1.541429] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.541437] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.541440] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.541458] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 2
[    1.541490] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00005060
[    1.541548] usb usb2: configuration #1 chosen from 1 choice
[    1.541570] hub 2-0:1.0: USB hub found
[    1.541575] hub 2-0:1.0: 2 ports detected
[    1.541679] ata_piix 0000:00:1f.1: version 2.12
[    1.541687] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.541722] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.541785] scsi0 : ata_piix
[    1.541848] scsi1 : ata_piix
[    1.542420] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x5100 irq 14
[    1.542423] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x5108 irq 15
[    1.704483] ata1.00: ATAPI: MATSHITADVD-RAM UJ-860H, 1.02, max MWDMA2
[    1.720427] ata1.00: configured for MWDMA2
[    1.723149] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-860H  1.02 PQ: 0 ANSI: 5
[    1.723337] ata2: port disabled. ignoring.
[    1.723396] ahci 0000:00:1f.2: version 3.0
[    1.723408] ahci 0000:00:1f.2: PCI INT D -> GSI 21 (level, low) -> IRQ 21
[    1.723452] ahci 0000:00:1f.2: irq 29 for MSI/MSI-X
[    1.723490] ahci: SSS flag set, parallel bus scan disabled
[    1.723513] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x1 impl SATA mode
[    1.723515] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part 
[    1.723521] ahci 0000:00:1f.2: setting latency timer to 64
[    1.723613] scsi2 : ahci
[    1.723655] scsi3 : ahci
[    1.723695] scsi4 : ahci
[    1.723744] ata3: SATA max UDMA/133 abar m2048@0xe4549000 port 0xe4549100 irq 29
[    1.723746] ata4: DUMMY
[    1.723747] ata5: DUMMY
[    1.729339] Driver 'sr' needs updating - please use bus_type methods
[    1.737182] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.737187] Uniform CD-ROM driver Revision: 3.20
[    1.737302] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.741493] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    2.044125] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.046611] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    2.046613] ata3.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
[    2.046891] ata3.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
[    2.046895] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    2.047604] ata3.00: ATA-8: Hitachi HTS722012K9SA00, DCCOC80A, max UDMA/100
[    2.047608] ata3.00: 234441648 sectors, multi 16: LBA48 
[    2.050323] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    2.050325] ata3.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
[    2.050540] ata3.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
[    2.050545] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    2.051338] ata3.00: configured for UDMA/100
[    2.069949] ata3.00: configured for UDMA/100
[    2.069954] ata3: EH complete
[    2.070091] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HTS72201 DCCO PQ: 0 ANSI: 5
[    2.070191] scsi 2:0:0:0: Attached scsi generic sg1 type 0
[    2.070289] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.070318] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.070321] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.070347] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 3
[    2.074259] ehci_hcd 0000:00:1d.7: debug port 1
[    2.074265] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.074279] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe4548000
[    2.081372] Driver 'sd' needs updating - please use bus_type methods
[    2.081439] sd 2:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
[    2.081456] sd 2:0:0:0: [sda] Write Protect is off
[    2.081458] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.081474] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.081515] sd 2:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
[    2.081525] sd 2:0:0:0: [sda] Write Protect is off
[    2.081527] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.081543] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.081546]  sda: sda1 sda2 < sda5 >
[    2.117503] sd 2:0:0:0: [sda] Attached SCSI disk
[    2.133120] usb 2-1: new full speed USB device using uhci_hcd and address 2
[    2.145120] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.145244] usb usb3: configuration #1 chosen from 1 choice
[    2.145300] hub 3-0:1.0: USB hub found
[    2.145311] hub 3-0:1.0: 6 ports detected
[    2.145823] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.145834] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    2.145837] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.145858] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    2.145896] uhci_hcd 0000:00:1a.1: irq 17, io base 0x00005080
[    2.145965] usb usb4: configuration #1 chosen from 1 choice
[    2.145986] hub 4-0:1.0: USB hub found
[    2.145991] hub 4-0:1.0: 2 ports detected
[    2.146071] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.146078] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.146082] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.146104] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    2.146130] uhci_hcd 0000:00:1d.0: irq 20, io base 0x000050a0
[    2.146195] usb usb5: configuration #1 chosen from 1 choice
[    2.146218] hub 5-0:1.0: USB hub found
[    2.146223] hub 5-0:1.0: 2 ports detected
[    2.146313] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    2.146319] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.146322] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.146340] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    2.146371] uhci_hcd 0000:00:1d.1: irq 22, io base 0x000050c0
[    2.146435] usb usb6: configuration #1 chosen from 1 choice
[    2.146456] hub 6-0:1.0: USB hub found
[    2.146461] hub 6-0:1.0: 2 ports detected
[    2.146537] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.146543] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.146546] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.146562] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    2.146587] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000050e0
[    2.146653] usb usb7: configuration #1 chosen from 1 choice
[    2.146675] hub 7-0:1.0: USB hub found
[    2.146680] hub 7-0:1.0: 2 ports detected
[    2.310640] usb 2-1: configuration #1 chosen from 1 choice
[    2.353780] PM: Starting manual resume from disk
[    2.353782] PM: Resume from partition 8:5
[    2.353783] PM: Checking hibernation image.
[    2.353962] PM: Resume from disk failed.
[    2.404475] kjournald starting.  Commit interval 5 seconds
[    2.404481] EXT3-fs: mounted filesystem with ordered data mode.
[    2.712274] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f9929ed5e0e]
[    2.873117] usb 5-2: new full speed USB device using uhci_hcd and address 2
[    3.038307] usb 5-2: configuration #1 chosen from 1 choice
[    8.096793] udevd version 124 started
[    8.465224] device-mapper: multipath: version 1.0.5 loaded
[    8.588129] iTCO_vendor_support: vendor-support=0
[    8.589305] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    8.589439] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
[    8.589501] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    8.649133] input: Power Button (FF) as /class/input/input1
[    8.652799] input: PC Speaker as /class/input/input2
[    8.669097] ACPI: Power Button (FF) [PWRF]
[    8.669201] input: Sleep Button (CM) as /class/input/input3
[    8.705081] ACPI: Sleep Button (CM) [C274]
[    8.705146] input: Lid Switch as /class/input/input4
[    8.713166] ACPI: Lid Switch [C26E]
[    8.841161] ACPI: Battery Slot [C1F4] (battery present)
[    8.841790] ACPI: Battery Slot [C1F3] (battery absent)
[    8.872717] ACPI: AC Adapter [C1F2] (off-line)
[    8.941270] acpi device:03: registered as cooling_device13
[    8.942281] input: Video Bus as /class/input/input5
[    8.968105] ACPI: Video Device [C14B] (multi-head: yes  rom: no  post: no)
[    9.068764] yenta_cardbus 0000:02:06.0: CardBus bridge found [103c:30c5]
[    9.104862] tpm_inf_pnp 00:03: Found C239 with ID IFX0102
[    9.104913] tpm_inf_pnp 00:03: TPM found: config base 0x560, data base 0x570, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[    9.112419] lis3lv02d: 2-byte sensor found
[    9.112423] lis3lv02d: hardware type NC8510 found.
[    9.112440] Registered led device: hp::hddprotect
[    9.123967] input: ST LIS3LV02DL Accelerometer as /class/input/input6
[    9.128085] lis3_init_device: irq 23
[    9.128087] lis3: registering device
[    9.128126] lis3lv02d driver loaded.
[    9.184375] ACPI: WMI: Mapper loaded
[    9.197884] yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x0cb8, PCI irq 16
[    9.197888] yenta_cardbus 0000:02:06.0: Socket status: 30000006
[    9.197893] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge I/O window: 0x6000 - 0x6fff
[    9.197895] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0xe4100000 - 0xe43fffff
[    9.197898] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0xc4000000 - 0xcbffffff
[    9.198092] yenta_cardbus 0000:02:06.1: CardBus bridge found [103c:30c5]
[    9.200759] Bluetooth: Core ver 2.14
[    9.202703] NET: Registered protocol family 31
[    9.202704] Bluetooth: HCI device and connection manager initialized
[    9.202707] Bluetooth: HCI socket layer initialized
[    9.220049] ricoh-mmc: Ricoh MMC Controller disabling driver
[    9.220054] ricoh-mmc: Copyright(c) Philip Langdale
[    9.233098] cfg80211: Calling CRDA to update world regulatory domain
[    9.258786] sdhci: Secure Digital Host Controller Interface driver
[    9.258788] sdhci: Copyright(c) Pierre Ossman
[    9.276615] Bluetooth: Generic Bluetooth USB driver ver 0.4
[    9.277354] usbcore: registered new interface driver btusb
[    9.325843] yenta_cardbus 0000:02:06.1: ISA IRQ mask 0x0000, PCI irq 17
[    9.325846] yenta_cardbus 0000:02:06.1: Socket status: 30000810
[    9.325849] pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #04 to #07
[    9.325857] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge I/O window: 0x6000 - 0x6fff
[    9.325859] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge Memory window: 0xe4100000 - 0xe43fffff
[    9.325861] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge Memory window: 0xc4000000 - 0xcbffffff
[    9.327385] parport_pc 00:02: reported by Plug and Play ACPI
[    9.327461] parport0: PC-style at 0x378 (0x778), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    9.329406] ricoh-mmc: Ricoh MMC controller found at 0000:02:06.4 [1180:0843] (rev 10)
[    9.329424] ricoh-mmc: Controller is now disabled.
[    9.329463] sdhci-pci 0000:02:06.3: SDHCI controller found [1180:0822] (rev 20)
[    9.329480] sdhci-pci 0000:02:06.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    9.331556] Registered led device: mmc0::
[    9.332608] mmc0: SDHCI controller on PCI [0000:02:06.3] using PIO
[    9.385325] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[    9.385335] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    9.385377] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    9.414833] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
[    9.414835] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[    9.414956] iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    9.414966] iwlagn 0000:10:00.0: setting latency timer to 64
[    9.415063] iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
[    9.477827] iwlagn: Tunable channels: 13 802.11bg, 19 802.11a channels
[    9.478632] iwlagn 0000:10:00.0: PCI INT A disabled
[    9.478702] wmaster0 (iwlagn): not using net_device_ops yet
[    9.478919] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    9.519524] wlan0 (iwlagn): not using net_device_ops yet
[    9.588873] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    9.588947] HDA Intel 0000:01:00.1: setting latency timer to 64
[    9.826066] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x2580b1, caps: 0xa44793/0x300000
[    9.826073] serio: Synaptics pass-through port at isa0060/serio4/input0
[    9.867525] input: SynPS/2 Synaptics TouchPad as /class/input/input7
[    9.965115] pcmcia_socket pcmcia_socket1: pccard: PCMCIA card inserted into slot 1
[    9.997116] pcmcia_socket pcmcia_socket1: cs: memory probe 0xc4000000-0xcbffffff: excluding 0xc4000000-0xcbffffff
[    9.997146] pcmcia_socket pcmcia_socket1: cs: memory probe 0xe4100000-0xe43fffff: excluding 0xe4100000-0xe412ffff
[   10.002436] pcmcia 1.0: pcmcia: registering new device pcmcia1.0
[   10.139601] lp0: using parport0 (interrupt-driven).
[   10.231311] Adding 4803392k swap on /dev/sda5.  Priority:-1 extents:1 across:4803392k 
[   10.245666] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[   10.246008] EXT3 FS on sda1, internal journal
[   10.832908] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.552720] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   12.957190] NET: Registered protocol family 10
[   12.957567] lo: Disabled Privacy Extensions
[   14.544665] input: PS/2 Generic Mouse as /class/input/input8
[   16.481559] ppdev: user-space parallel port driver
[   18.372340] Bridge firewalling registered
[   18.456354] vnet0: starting userspace STP failed, starting kernel STP
[   18.788598] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   18.788808] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   18.788810] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[   18.788812] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   22.318405] Bluetooth: L2CAP ver 2.11
[   22.318410] Bluetooth: L2CAP socket layer initialized
[   22.339950] Bluetooth: SCO (Voice Link) ver 0.6
[   22.339956] Bluetooth: SCO socket layer initialized
[   22.355128] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   22.355135] Bluetooth: BNEP filters: protocol multicast
[   22.448322] Bluetooth: RFCOMM socket layer initialized
[   22.448342] Bluetooth: RFCOMM TTY layer initialized
[   22.448346] Bluetooth: RFCOMM ver 1.10
[   24.668285] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   26.881563] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   26.936306] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   26.937868] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   26.942792] iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   26.942931] iwlagn 0000:10:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
[   26.943099] iwlagn 0000:10:00.0: irq 30 for MSI/MSI-X
[   26.943212] iwlagn 0000:10:00.0: firmware: requesting iwlwifi-4965-2.ucode
[   27.202613] iwlagn loaded firmware version 228.57.2.23
[   27.409469] Registered led device: iwl-phy0:radio
[   27.410077] Registered led device: iwl-phy0:assoc
[   27.411811] Registered led device: iwl-phy0:RX
[   27.411899] Registered led device: iwl-phy0:TX
[   27.453545] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   27.574154] NET: Registered protocol family 17
[   28.605052] vnet0: no IPv6 routers present
[   38.049145] CE: hpet increasing min_delta_ns to 15000 nsec
[  102.421511] Monitor-Mwait will be used to enter C-2 state
[  108.145656] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[  108.146919] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  118.780098] eth0: no IPv6 routers present
[  134.340199] ppdev0: registered pardevice
[  134.388093] ppdev0: unregistered pardevice
[  134.668443] ppdev0: registered pardevice
[  134.716425] ppdev0: unregistered pardevice
[  136.331159] ppdev0: registered pardevice
[  136.377183] ppdev0: unregistered pardevice
[  146.660545] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[  146.661674] input: Bluetooth Laser Travel Mouse as /class/input/input9
[  146.685182] generic-bluetooth 0005:046D:B008.0001: input,hidraw0: BLUETOOTH HID v3.13 Mouse [Bluetooth Laser Travel Mouse] on 00:1E:37:6E:FD:70
[ 2885.888003] irq 19: nobody cared (try booting with the "irqpoll" option)
[ 2885.888014] Pid: 0, comm: swapper Not tainted 2.6.29.1 #1
[ 2885.888019] Call Trace:
[ 2885.888023]  <IRQ>  [<ffffffff802751cb>] __report_bad_irq+0x38/0x87
[ 2885.888045]  [<ffffffff80275332>] note_interrupt+0x118/0x182
[ 2885.888053]  [<ffffffff80275962>] handle_fasteoi_irq+0xa1/0xc5
[ 2885.888062]  [<ffffffff8020de49>] do_IRQ+0x70/0xe7
[ 2885.888069]  [<ffffffff8020bf53>] ret_from_intr+0x0/0xa
[ 2885.888073]  <EOI>  [<ffffffff8024f317>] ? notifier_call_chain+0x33/0x5b
[ 2885.888136]  [<ffffffffa002b7bb>] ? acpi_idle_enter_simple+0x186/0x1f8 [processor]
[ 2885.888159]  [<ffffffffa002b7b1>] ? acpi_idle_enter_simple+0x17c/0x1f8 [processor]
[ 2885.888169]  [<ffffffff80399fa6>] ? cpuidle_idle_call+0x8c/0xc6
[ 2885.888176]  [<ffffffff8020a649>] ? cpu_idle+0x52/0x93
[ 2885.888184]  [<ffffffff804133cd>] ? rest_init+0x61/0x63
[ 2885.888189] handlers:
[ 2885.888192] [<ffffffffa02b2b86>] (sdhci_irq+0x0/0x49a [sdhci])
[ 2885.888208] Disabling IRQ #19

--=-HSaFkWIgE8JUGtwOuwxQ--

