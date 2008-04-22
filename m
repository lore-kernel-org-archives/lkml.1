Return-Path: <linux-kernel-owner+w=401wt.eu-S1764979AbYDVPNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764979AbYDVPNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbYDVPMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:12:48 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:59611 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbYDVPMo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:12:44 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Tue, 22 Apr 2008 17:12:39 +0200
User-Agent: KMail/1.9.9
Cc: Peer Chen <pchen@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kuan Luo <kluo@nvidia.com>
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200804221444.55483.volker.armin.hemmann@tu-clausthal.de> <480DF1F5.3060208@gmail.com>
In-Reply-To: <480DF1F5.3060208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804221712.39552.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag, 22. April 2008, Tejun Heo wrote:
> Volker Armin Hemmann wrote:
> > On Dienstag, 22. April 2008, Peer Chen wrote:
> >> Looks like the BIOS trap had been applied, GHC.AE suppose should be set
> >> correctly. Volker, could you try to set the AE twice in the driver or
> >> using mmapper to set the AE manually to check if AE will be set
> >> correctly or not?
> >
> > emm, I am totally out of my depth here. I don't even know what you are
> > talking about. If you explain me in nice, little word or even better,
> > with examples, what I shall try, I will happily do so.
>
> This patch should do the trick.

ok, with the patch the call trace is gone.

Looks like this now (2.6.25+reiser4+your patch)

[    0.367177] Driver 'sd' needs updating - please use bus_type methods
[    0.367189] ahci 0000:00:0a.0: version 3.0
[    0.367189] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.367189] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
(lev
el, low) -> IRQ 23
[    0.470521] AHCI_EN failed i=0
[    1.572680] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
imp
l SATA mode
[    1.572680] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[    1.572680] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.572682] scsi0 : ahci
[    1.572692] scsi1 : ahci
[    1.572701] scsi2 : ahci
[    1.572711] scsi3 : ahci
[    1.572717] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq
 23
[    1.572717] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq
 23
[    1.572717] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq
 23
[    1.572717] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq
 23
[    2.010056] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.010552] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[    2.010552] ata1.00: 312581808 sectors, multi 16: LBA48
[    2.011132] ata1.00: configured for UDMA/133
[    2.643013] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.663511] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[    2.663511] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.665420] ata2.00: configured for UDMA/133
[    2.982665] ata3: SATA link down (SStatus 0 SControl 300)
[    3.302534] ata4: SATA link down (SStatus 0 SControl 300)
[    3.499383] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ
: 0 ANSI: 5
[    3.499400] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[    3.499400] sd 0:0:0:0: [sda] Write Protect is off
[    3.499400] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.499400] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
does
n't support DPO or FUA
[    3.499400] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[    3.499400] sd 0:0:0:0: [sda] Write Protect is off
[    3.499400] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.499400] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
does
n't support DPO or FUA
[    3.499400]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    3.336734] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.336745] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.336750] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ
: 0 ANSI: 5
[    3.336757] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[    3.336757] sd 1:0:0:0: [sdb] Write Protect is off
[    3.336757] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.336757] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
does
n't support DPO or FUA
[    3.336757] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[    3.336757] sd 1:0:0:0: [sdb] Write Protect is off
[    3.336757] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.336757] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
does
n't support DPO or FUA
[    3.336757]  sdb: sdb1 sdb2
[    3.383500] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.383510] sd 1:0:0:0: Attached scsi generic sg1 type 0

complete dmesg:
[    0.000000] Linux version 2.6.25 (root@energy) (gcc version 4.2.3 (Gentoo 
4.2.3 p1.0)) #3 SMP Tue Apr 22 16:57:50 CEST 2008
[    0.000000] Command line: pci=nomsi root=/dev/sda3 nmi_watchdog=0 
console=tty6ÿ      ëMítHt$01Ò¿
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] end_pfn_map = 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98F0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT   1000822 MSFT       
97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       
97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19192      192 INTL 
20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC   1000822 MSFT       
97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG   1000822 MSFT       
97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM   1000822 MSFT       
97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0  1000822 MSFT       
97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD         
1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-59e313] TEXT DATA BSS
[    0.000000] early res: 3 [9fc00-a0bff] EBDA
[    0.000000] early res: 4 [8000-dfff] PGTABLE
[    0.000000] No mptable found.
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on 
node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on 
node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on 
node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on 
node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on 
node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on 
node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on 
node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on 
node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on 
node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on 
node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on 
node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on 
node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on 
node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on 
node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on 
node 0
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on 
node 0
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on 
node 0
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on 
node 0
[    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on 
node 0
[    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on 
node 0
[    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on 
node 0
[    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 on 
node 0
[    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 on 
node 0
[    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 on 
node 0
[    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 on 
node 0
[    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 on 
node 0
[    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff810007a00000 on 
node 0
[    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff810007e00000 on 
node 0
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810008200000 on 
node 0
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810008600000 on 
node 0
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008a00000 on 
node 0
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008e00000 on 
node 0
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810009200000 on 
node 0
[    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810009600000 on 
node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 936 pages reserved
[    0.000000]   DMA zone: 3007 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cffb0000 - 
00000000cffc0000
[    0.000000] PM: Registered nosave memory: 00000000cffc0000 - 
00000000cfff0000
[    0.000000] PM: Registered nosave memory: 00000000cfff0000 - 
00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 
00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 
00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 
00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 
00000000ff380000
[    0.000000] PM: Registered nosave memory: 00000000ff380000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: 
d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 32584 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 1030439
[    0.000000] Kernel command line: pci=nomsi root=/dev/sda3 nmi_watchdog=0 
console=tty6ÿ       ëMítHt$01Ò¿
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.000002] time.c: Detected 3013.881 MHz processor.
[    0.000011] spurious 8259A interrupt: IRQ7.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty6] enabled
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[    0.003333] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.003333] Checking aperture...
[    0.003333] Node 0: aperture @ c000000 size 32 MB
[    0.003333] Aperture pointing to e820 RAM. Ignoring.
[    0.003333] No AGP bridge found
[    0.003333] Your BIOS doesn't leave a aperture memory hole
[    0.003333] Please enable the IOMMU option in the BIOS setup
[    0.003333] This costs you 64 MB of RAM
[    0.003333] Mapping aperture over 65536 KB of RAM @ c000000
[    0.003333] PM: Registered nosave memory: 000000000c000000 - 
0000000010000000
[    0.003333] Memory: 4047432k/4980736k available (2240k kernel code, 145456k 
reserved, 933k data, 192k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, 
Nodes=1
[    0.003333] hpet clockevent registered
[    0.083330] Calibrating delay using timer specific routine.. 6034.70 
BogoMIPS (lpj=10053922)
[    0.083419] Mount-cache hash table entries: 256
[    0.083537] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[    0.083577] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.083615] CPU: Physical Processor ID: 0
[    0.083651] CPU: Processor Core ID: 0
[    0.083700] ACPI: Core revision 20070126
[    0.122312] Using local APIC timer interrupts.
[    0.123326] APIC timer calibration result 12557839
[    0.123327] Detected 12.557 MHz APIC timer.
[    0.123428] Booting processor 1/2 APIC 0x1
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6030.95 
BogoMIPS (lpj=10046321)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[    0.216844] Brought up 2 CPUs
[    0.217291] net_namespace: 296 bytes
[    0.217409] NET: Registered protocol family 16
[    0.217503] No dock devices found.
[    0.217565] ACPI: bus type pci registered
[    0.217642] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[    0.217681] PCI: Not using MMCONFIG.
[    0.217718] PCI: Using configuration type 1
[    0.220744] ACPI: EC: Look up EC in DSDT
[    0.224960] ACPI: Interpreter enabled
[    0.224998] ACPI: (supports S0 S1 S3 S4 S5)
[    0.225169] ACPI: Using IOAPIC for interrupt routing
[    0.225345] ACPI: Error attaching device data
[    0.225385] ACPI: Error attaching device data
[    0.225424] ACPI: Error attaching device data
[    0.225464] ACPI: Error attaching device data
[    0.231383] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.231918] PCI: Transparent bridge - 0000:00:08.0
[    0.232173] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.232323] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.232434] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.232498] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.232563] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.232628] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.237207] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[    0.237568] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[    0.237927] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, 
disabled.
[    0.238312] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, 
disabled.
[    0.238697] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, 
disabled.
[    0.239083] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.239443] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, 
disabled.
[    0.239829] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[    0.240290] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[    0.240650] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, 
disabled.
[    0.241037] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[    0.241397] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, 
disabled.
[    0.241783] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, 
disabled.
[    0.242169] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.242528] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, 
disabled.
[    0.242914] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[    0.243274] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, 
disabled.
[    0.243716] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, 
disabled.
[    0.244103] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, 
disabled.
[    0.244490] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, 
disabled.
[    0.244819] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.244868] pnp: PnP ACPI init
[    0.244907] ACPI: bus type pnp registered
[    0.248071] pnp: PnP ACPI: found 13 devices
[    0.248108] ACPI: ACPI bus type pnp unregistered
[    0.248214] SCSI subsystem initialized
[    0.248284] libata version 3.00 loaded.
[    0.248322] usbcore: registered new interface driver usbfs
[    0.248373] usbcore: registered new interface driver hub
[    0.248428] usbcore: registered new device driver usb
[    0.248507] PCI: Using ACPI for IRQ routing
[    0.248545] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[    0.273316] PCI-DMA: Disabling AGP.
[    0.273316] PCI-DMA: aperture base @ c000000 size 65536 KB
[    0.273316] PCI-DMA: using GART IOMMU.
[    0.273316] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.273316] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.273316] hpet0: 3 32-bit timers, 25000000 Hz
[    0.273325] Switched to high resolution mode on CPU 0
[    0.066836] Switched to high resolution mode on CPU 1
[    0.286685] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.286685] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.286685] system 00:05: ioport range 0x2000-0x207f has been reserved
[    0.286685] system 00:05: ioport range 0x2080-0x20ff has been reserved
[    0.286685] system 00:05: ioport range 0x2400-0x247f has been reserved
[    0.286685] system 00:05: ioport range 0x2480-0x24ff has been reserved
[    0.286685] system 00:05: ioport range 0x2800-0x287f has been reserved
[    0.286685] system 00:05: ioport range 0x2880-0x28ff has been reserved
[    0.286688] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[    0.286728] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[    0.286767] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.286807] system 00:05: iomem range 0xfee01000-0xfeefffff has been 
reserved
[    0.286851] system 00:07: iomem range 0xfec00000-0xfec00fff could not be 
reserved
[    0.286899] system 00:07: iomem range 0xfee00000-0xfee00fff could not be 
reserved
[    0.286950] system 00:0a: ioport range 0x290-0x29f has been reserved
[    0.286993] system 00:0b: iomem range 0xe0000000-0xefffffff has been 
reserved
[    0.287036] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.287076] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[    0.287116] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.287161] system 00:0c: iomem range 0x100000-0xcfffffff could not be 
reserved
[    0.287209] system 00:0c: iomem range 0xff380000-0xffffffff could not be 
reserved
[    0.287661] PCI: Bridge: 0000:00:08.0
[    0.287698]   IO window: d000-dfff
[    0.287735]   MEM window: 0xf9f00000-0xf9ffffff
[    0.287774]   PREFETCH window: 0x00000000f0000000-0x00000000f00fffff
[    0.287815] PCI: Bridge: 0000:00:0b.0
[    0.287851]   IO window: c000-cfff
[    0.287888]   MEM window: 0xf9e00000-0xf9efffff
[    0.287926]   PREFETCH window: disabled.
[    0.287963] PCI: Bridge: 0000:00:0c.0
[    0.287999]   IO window: disabled.
[    0.288036]   MEM window: disabled.
[    0.288073]   PREFETCH window: disabled.
[    0.288111] PCI: Bridge: 0000:00:0d.0
[    0.288147]   IO window: e000-efff
[    0.288184]   MEM window: 0xfa000000-0xfebfffff
[    0.288222]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.288262] PCI: Bridge: 0000:00:0e.0
[    0.288298]   IO window: disabled.
[    0.288334]   MEM window: disabled.
[    0.288371]   PREFETCH window: disabled.
[    0.288414] PCI: Setting latency timer of device 0000:00:08.0 to 64
[    0.288423] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.288429] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.288434] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.288438] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.288445] NET: Registered protocol family 2
[    0.323349] IP route cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[    0.323349] TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)
[    0.323349] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.323349] TCP: Hash tables configured (established 262144 bind 65536)
[    0.323349] TCP reno registered
[    0.333656] Loading Reiser4. See www.namesys.com for a description of 
Reiser4.
[    0.333662] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
254)
[    0.333662] io scheduler noop registered
[    0.333662] io scheduler cfq registered (default)
[    0.333662] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.333662] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.333662] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.333662] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.333662] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    0.333662] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    0.333662] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.333662] pci 0000:04:00.0: Boot video device
[    0.333670] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.333670] assign_interrupt_mode Found MSI capability
[    0.333670] Allocate Port Service[0000:00:0b.0:pcie00]
[    0.333677] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.333677] assign_interrupt_mode Found MSI capability
[    0.333677] Allocate Port Service[0000:00:0c.0:pcie00]
[    0.333684] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.333684] assign_interrupt_mode Found MSI capability
[    0.333684] Allocate Port Service[0000:00:0d.0:pcie00]
[    0.333690] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.333690] assign_interrupt_mode Found MSI capability
[    0.333690] Allocate Port Service[0000:00:0e.0:pcie00]
[    0.333731] input: Power Button (FF) as /class/input/input0
[    0.333731] ACPI: Power Button (FF) [PWRF]
[    0.333738] input: Power Button (CM) as /class/input/input1
[    0.333738] ACPI: Power Button (CM) [PWRB]
[    0.333771] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.333778] ACPI: ACPI0007:01 is registered as cooling_device1
[    0.367146] Real Time Clock Driver v1.12ac
[    0.367150] hpet_resources: 0xfed00000 is busy
[    0.367157] Linux agpgart interface v0.103
[    0.367177] Driver 'sd' needs updating - please use bus_type methods
[    0.367189] ahci 0000:00:0a.0: version 3.0
[    0.367189] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.367189] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
(level, low) -> IRQ 23
[    0.470521] AHCI_EN failed i=0
[    1.572680] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
impl SATA mode
[    1.572680] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[    1.572680] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.572682] scsi0 : ahci
[    1.572692] scsi1 : ahci
[    1.572701] scsi2 : ahci
[    1.572711] scsi3 : ahci
[    1.572717] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq 23
[    1.572717] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq 23
[    1.572717] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq 23
[    1.572717] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq 23
[    2.010056] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.010552] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[    2.010552] ata1.00: 312581808 sectors, multi 16: LBA48
[    2.011132] ata1.00: configured for UDMA/133
[    2.643013] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.663511] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[    2.663511] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.665420] ata2.00: configured for UDMA/133
[    2.982665] ata3: SATA link down (SStatus 0 SControl 300)
[    3.302534] ata4: SATA link down (SStatus 0 SControl 300)
[    3.499383] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[    3.499400] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[    3.499400] sd 0:0:0:0: [sda] Write Protect is off
[    3.499400] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.499400] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.499400] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[    3.499400] sd 0:0:0:0: [sda] Write Protect is off
[    3.499400] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.499400] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.499400]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    3.336734] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.336745] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.336750] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[    3.336757] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[    3.336757] sd 1:0:0:0: [sdb] Write Protect is off
[    3.336757] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.336757] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.336757] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[    3.336757] sd 1:0:0:0: [sdb] Write Protect is off
[    3.336757] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.336757] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.336757]  sdb: sdb1 sdb2
[    3.383500] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.383510] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.383517] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 
irq 1,12
[    3.383612] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.383612] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.413630] usbcore: registered new interface driver usbhid
[    3.413630] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    3.413630] TCP cubic registered
[    3.413630] NET: Registered protocol family 1
[    3.413635] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 
6000+ processors (2 cpu cores) (version 2.20.00)
[    3.611878] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[    3.611878] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[    3.611878] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[    3.611878] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[    3.611878] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[    3.611878] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[    3.611878] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[    3.611878] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[    3.442917] input: AT Translated Set 2 keyboard as /class/input/input2
[    3.541535] ReiserFS: sda3: found reiserfs format "3.6" with standard 
journal
[    3.541579] ReiserFS: sda3: using ordered data mode
[    3.552592] ReiserFS: sda3: journal params: device sda3, size 8192, journal 
first block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
[    3.552592] ReiserFS: sda3: checking transaction log (sda3)
[    3.598972] ReiserFS: sda3: Using r5 hash to sort names
[    3.598972] VFS: Mounted root (reiserfs filesystem) readonly.
[    3.598972] Freeing unused kernel memory: 192k freed
[    3.975260] Clocksource tsc unstable (delta = -137536132 ns)
[    6.849124] r8169 Gigabit Ethernet driver 2.2LK loaded
[    6.849359] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[    6.849364] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 
(level, low) -> IRQ 19
[    6.849373] PCI: Setting latency timer of device 0000:01:00.0 to 64
[    6.849381] r8169 0000:01:00.0: no MSI. Back to INTx.
[    6.849527] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, 
XID 38000000 IRQ 19
[    6.904115] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    6.904121] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 
(level, low) -> IRQ 22
[    6.904128] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    6.904130] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    6.907044] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus 
number 1
[    6.907069] ehci_hcd 0000:00:02.1: debug port 1
[    6.907071] PCI: cache line size of 64 is not supported by device 
0000:00:02.1
[    6.907079] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[    6.919982] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 
Dec 2004
[    6.919982] usb usb1: configuration #1 chosen from 1 choice
[    6.919982] hub 1-0:1.0: USB hub found
[    6.919982] hub 1-0:1.0: 10 ports detected
[    7.276306] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    7.404183] usb 1-3: configuration #1 chosen from 1 choice
[    7.404183] hub 1-3:1.0: USB hub found
[    7.404302] hub 1-3:1.0: 4 ports detected
[    7.716532] usb 1-3.1: new low speed USB device using ehci_hcd and address 
3
[    7.808210] usb 1-3.1: configuration #1 chosen from 1 choice
[    7.820564] input: Logitech USB Receiver as /class/input/input3
[    7.839764] input: USB HID v1.11 Mouse [Logitech USB Receiver] on 
usb-0000:00:02.1-3.1
[    7.841500] input: Logitech USB Receiver as /class/input/input4
[    7.893869] input: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:02.1-3.1
[    7.971393] mice: PS/2 mouse device common for all mice
[    9.611430] ReiserFS: sda3: switching to journaled data mode
[    9.737449] reiser4: sdb2: found disk format 4.0.0.
[   35.261279] reiser4: sda6: found disk format 4.0.0.
[   36.657701] reiser4: sdb1: found disk format 4.0.0.
[   37.856117] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 
across:1951888k
[   39.210462] r8169: eth0: link up
[   39.210466] r8169: eth0: link up
[   39.262963] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   39.262968] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 
(level, low) -> IRQ 18
[   39.266285] Audigy2 value: Special config.
[   40.373183] i2c /dev entries driver
[   40.426512] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2d00
[   40.426512] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2e00
[   40.811375] w83627ehf: Found W83627EHG chip at 0x290
[   49.334910] nvidia: module license 'NVIDIA' taints kernel.
[   49.593955] ACPI: PCI Interrupt Link [LNED] enabled at IRQ 17
[   49.593963] ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNED] -> GSI 17 
(level, low) -> IRQ 17
[   49.593969] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   49.594415] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  173.08  Wed Apr  
2 07:55:48 PST 2008
[   50.026675] NVRM: bad caching on address 0xffff81012b3e1000: actual 
0x173 != expected 0x17b
[   50.026679] NVRM: please see the README section on Cache Aliasing for more 
information
[   50.026984] NVRM: bad caching on address 0xffff81012e182000: actual 
0x173 != expected 0x17b
[   50.027029] NVRM: bad caching on address 0xffff81012e161000: actual 
0x173 != expected 0x17b
[   50.027071] NVRM: bad caching on address 0xffff81012e151000: actual 
0x173 != expected 0x17b
[   50.027113] NVRM: bad caching on address 0xffff81012b39a000: actual 
0x173 != expected 0x17b
[   50.027152] NVRM: bad caching on address 0xffff81012e153000: actual 
0x173 != expected 0x17b
[   50.027191] NVRM: bad caching on address 0xffff81012e2d8000: actual 
0x173 != expected 0x17b
[   50.027239] NVRM: bad caching on address 0xffff81012b20c000: actual 
0x173 != expected 0x17b
[   50.027305] NVRM: bad caching on address 0xffff81012ad4f000: actual 
0x173 != expected 0x17b
[   50.027346] NVRM: bad caching on address 0xffff81012f3a3000: actual 
0x173 != expected 0x17b


