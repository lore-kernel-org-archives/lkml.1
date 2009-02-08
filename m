Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbZBHGgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbZBHGgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 01:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbZBHGfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 01:35:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36204 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbZBHGfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 01:35:45 -0500
Date: Sun, 8 Feb 2009 07:35:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: [bug] sata detection problem
Message-ID: <20090208063516.GA2318@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,FR_ALMOST_VIAG2 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	2.0 FR_ALMOST_VIAG2        RAW: Almost looks like viagra.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hm, in a boot test i had this boot failure:

[   15.504053] calling  piix_init+0x0/0x30 @ 1
[   15.508050] ata_piix 0000:00:1f.1: version 2.12
[   15.516193] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
[   15.520029] ata_piix 0000:00:1f.1: PCI INT A -> Link[LNKG] -> GSI 11 (level, low) -> IRQ 11
[   15.524072] ata_piix 0000:00:1f.1: setting latency timer to 64
[   15.528115] scsi0 : ata_piix
[   15.531526] scsi1 : ata_piix
[   15.544044] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[   15.548028] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[   15.716358] ata1.00: ATAPI: �V�V�V�V�V������������������������������, ��V�V�V, max UDMA7
[   15.720044] ata1.00: limited to UDMA/33 due to 40-wire cable
[   15.740296] ata1.00: configured for UDMA/33
[   15.744117] async_waiting @ 1
[   15.748027] async_continuing @ 1 after 0 usec
[   15.752066] isa bounce pool size: 16 pages
[   15.756124] scsi scan: INQUIRY result too short (5), using 36
[   15.760030] scsi 0:0:0:0: Direct-Access                                    PQ: 0 ANSI: 5
[   15.768197] sd 0:0:0:0: [sda] Attached SCSI removable disk
[   15.772359] async_waiting @ 1
[   15.776047] async_continuing @ 1 after 0 usec
[   15.940033] async_waiting @ 1
[   15.944027] async_continuing @ 1 after 0 usec
[   15.948613] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[   15.952029] ata_piix 0000:00:1f.2: PCI INT B -> Link[LNKH] -> GSI 11 (level, low) -> IRQ 11
[   15.956030] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   15.961683] ata_piix 0000:00:1f.2: setting latency timer to 64
[   15.964087] scsi2 : ata_piix
[   15.968192] scsi3 : ata_piix
[   15.972153] ata3: SATA max UDMA/133 cmd 0x9800 ctl 0x9400 bmdma 0x8400 irq 11
[   15.976028] ata4: SATA max UDMA/133 cmd 0x9000 ctl 0x8800 bmdma 0x8408 irq 11
[   16.176051] ata3.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
[   16.180027] ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   16.248061] ata3.00: configured for UDMA/133
[   16.252031] async_waiting @ 1
[   16.256027] async_continuing @ 1 after 0 usec
[   16.260175] scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[   16.264348] sd 2:0:0:0: [sdb] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[   16.268056] sd 2:0:0:0: [sdb] Write Protect is off
[   16.272028] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   16.276097] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   16.280135] sd 2:0:0:0: [sdb] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[   16.284055] sd 2:0:0:0: [sdb] Write Protect is off
[   16.288028] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   16.292078] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   16.296029]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 >
[   16.337818] sd 2:0:0:0: [sdb] Attached SCSI disk
[   16.340313] async_waiting @ 1
[   16.344028] async_continuing @ 1 after 0 usec
[   16.508033] async_waiting @ 1
[   16.512027] async_continuing @ 1 after 0 usec
[   16.516143] initcall piix_init+0x0/0x30 returned 0 after 984375 usecs
[   16.520029] calling  sil_init+0x0/0x20 @ 1

Look at the weird sda detection. The only _real_ device on this system is the 
ST3320620AS disk which got detected as sdb. But the bogus sda entry crashed the 
(older) OS installation on the box:

[   20.132252] VFS: Cannot open root device "sda3" or unknown-block(0,0)

Find below a successful bootup. Bug is very sporadic. (seems timing related)

	Ingo

[    0.000000] Linux version 2.6.29-rc3-00697-gae1a25d (mingo@aldebaran) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #52 Sun Feb 8 06:54:35 CET 2009
[    0.000000] Command line: root=/dev/sda3 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 3 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ffa0000 (usable)
[    0.000000]  BIOS-e820: 000000007ffa0000 - 000000007ffae000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ffae000 - 000000007ffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
[    0.000000] console [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] DMI 2.3 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0x7ffa0 max_arch_pfn = 0x100000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007ffa0000 (usable)
[    0.000000]  modified: 000000007ffa0000 - 000000007ffae000 (ACPI data)
[    0.000000]  modified: 000000007ffae000 - 000000007ffe0000 (ACPI NVS)
[    0.000000]  modified: 000000007ffe0000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000ffb80000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-000000007ffa0000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007ffa0000 page 4k
[    0.000000] kernel direct mapping tables up to 7ffa0000 @ 10000-14000
[    0.000000] last_map_addr: 7ffa0000 end: 7ffa0000
[    0.000000] ACPI: RSDP 000FACD0, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 7FFA0100, 0044 (r1 A M I  OEMXSDT  10000630 MSFT       97)
[    0.000000] ACPI: FACP 7FFA0290, 00F4 (r3 A M I  OEMFACP  10000630 MSFT       97)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 7FFA0410, 8318 (r1  A0227 A0227000        0 INTL  2002026)
[    0.000000] ACPI: FACS 7FFAE000, 0040
[    0.000000] ACPI: APIC 7FFA0390, 0080 (r1 A M I  OEMAPIC  10000630 MSFT       97)
[    0.000000] ACPI: OEMB 7FFAE040, 0066 (r1 A M I  AMI_OEM  10000630 MSFT       97)
[    0.000000] ACPI: MCFG 7FFA8730, 003C (r1 A M I  OEMMCFG  10000630 MSFT       97)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 007ffa0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00013be814]    TEXT DATA BSS ==> [0000200000 - 00013be814]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #4 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000ff780] 000ff780
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001600000-ffff8800031fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007ffa0
[    0.000000] On node 0 totalpages: 524079
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 103 pages reserved
[    0.000000]   DMA zone: 3824 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7111 pages used for memmap
[    0.000000]   DMA32 zone: 512985 pages, LIFO batch:31
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] mapped APIC to ffffffffff5fc000 (fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:7fb80000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 516809
[    0.000000] Kernel command line: root=/dev/sda3 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 3 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled
[    0.000000] debug: sysrq always enabled.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3456.959 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console handover: boot [earlyser0] -> real [tty0]
[    0.004000] console [ttyS0] enabled
[    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Memory: 2045728k/2096768k available (9108k kernel code, 452k absent, 50196k reserved, 5116k data, 660k init)
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.004013] Calibrating delay loop (skipped), value calculated using timer frequency.. 6913.91 BogoMIPS (lpj=13827836)
[    0.012066] Security Framework initialized
[    0.016043] Mount-cache hash table entries: 256
[    0.024104] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.028003] CPU: L2 cache: 2048K
[    0.032018] CPU0: Thermal monitoring enabled (TM1)
[    0.036004] using mwait in idle threads.
[    0.040003] CPU: Intel(R) Pentium(R) D CPU 3.00GHz stepping 02
[    0.051273] ACPI: Core revision 20081204
[    0.088087] calling  spawn_ksoftirqd+0x0/0x40 @ 1
[    0.092032] initcall spawn_ksoftirqd+0x0/0x40 returned 0 after 0 usecs
[    0.096005] calling  relay_init+0x0/0x8 @ 1
[    0.100004] initcall relay_init+0x0/0x8 returned 0 after 0 usecs
[    0.104004] calling  tracer_alloc_buffers+0x0/0x10b @ 1
[    0.108352] initcall tracer_alloc_buffers+0x0/0x10b returned 0 after 0 usecs
[    0.112005] Setting APIC routing to flat
[    0.116008] enabled ExtINT on CPU#0
[    0.120142] ENABLING IO-APIC IRQs
[    0.124003] init IO_APIC IRQs
[    0.128003]  2-0 (apicid-pin) not connected
[    0.132008] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.136007] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.140006] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.144005] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.148005] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.152005] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.156005] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.160005] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.164005] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
[    0.168005] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.172005] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
[    0.176005] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.180005] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.184005] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.188005] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.192003]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
[    0.200149] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.246106] Using local APIC timer interrupts.
[    0.246106] calibrating APIC timer ...
[    0.252001] ... lapic delta = 1440414
[    0.252001] ..... delta 1440414
[    0.252001] ..... mult: 61861443
[    0.252001] ..... calibration result: 921864
[    0.252001] ..... CPU clock speed is 3456.3980 MHz.
[    0.252001] ..... host bus clock speed is 230.1864 MHz.
[    0.252001] ... verify APIC timer
[    0.360045] ... jiffies delta = 25
[    0.363490] ... jiffies result ok
[    0.366127] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.368006] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.372005] calling  net_ns_init+0x0/0x182 @ 1
[    0.376003] net_namespace: 1352 bytes
[    0.380007] initcall net_ns_init+0x0/0x182 returned 0 after 3906 usecs
[    0.384004] calling  cpufreq_tsc+0x0/0x28 @ 1
[    0.388003] initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
[    0.392005] calling  print_banner+0x0/0xe @ 1
[    0.396003] Booting paravirtualized kernel on bare hardware
[    0.400004] initcall print_banner+0x0/0xe returned 0 after 3906 usecs
[    0.404004] calling  sysctl_init+0x0/0x16 @ 1
[    0.408007] initcall sysctl_init+0x0/0x16 returned 0 after 0 usecs
[    0.412004] calling  ksysfs_init+0x0/0xbb @ 1
[    0.416108] initcall ksysfs_init+0x0/0xbb returned 0 after 0 usecs
[    0.420004] calling  async_init+0x0/0x4b @ 1
[    0.424186] initcall async_init+0x0/0x4b returned 0 after 0 usecs
[    0.428117] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.432006] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.436004] calling  pm_init+0x0/0x43 @ 1
[    0.440010] initcall pm_init+0x0/0x43 returned 0 after 0 usecs
[    0.444005] calling  filelock_init+0x0/0x2e @ 1
[    0.448010] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.452004] calling  init_misc_binfmt+0x0/0x44 @ 1
[    0.456007] initcall init_misc_binfmt+0x0/0x44 returned 0 after 0 usecs
[    0.460004] calling  init_script_binfmt+0x0/0x12 @ 1
[    0.464005] initcall init_script_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.468004] calling  init_elf_binfmt+0x0/0x12 @ 1
[    0.472005] initcall init_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.476004] calling  init_compat_elf_binfmt+0x0/0x12 @ 1
[    0.480005] initcall init_compat_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.484004] calling  debugfs_init+0x0/0x56 @ 1
[    0.488009] initcall debugfs_init+0x0/0x56 returned 0 after 0 usecs
[    0.492005] calling  random32_init+0x0/0xad @ 1
[    0.496005] initcall random32_init+0x0/0xad returned 0 after 0 usecs
[    0.500007] calling  gnttab_init+0x0/0x1d0 @ 1
[    0.504005] initcall gnttab_init+0x0/0x1d0 returned -19 after 0 usecs
[    0.508004] calling  cpufreq_core_init+0x0/0x2c @ 1
[    0.512004] initcall cpufreq_core_init+0x0/0x2c returned 0 after 0 usecs
[    0.516004] calling  cpuidle_init+0x0/0x20 @ 1
[    0.520010] initcall cpuidle_init+0x0/0x20 returned 0 after 0 usecs
[    0.524004] calling  sock_init+0x0/0x60 @ 1
[    0.528038] initcall sock_init+0x0/0x60 returned 0 after 0 usecs
[    0.532005] calling  netpoll_init+0x0/0x27 @ 1
[    0.536005] initcall netpoll_init+0x0/0x27 returned 0 after 0 usecs
[    0.540005] calling  netlink_proto_init+0x0/0x16f @ 1
[    0.544023] NET: Registered protocol family 16
[    0.548026] initcall netlink_proto_init+0x0/0x16f returned 0 after 3906 usecs
[    0.552005] calling  bdi_class_init+0x0/0x41 @ 1
[    0.556104] initcall bdi_class_init+0x0/0x41 returned 0 after 0 usecs
[    0.560004] calling  kobject_uevent_init+0x0/0x49 @ 1
[    0.564023] initcall kobject_uevent_init+0x0/0x49 returned 0 after 0 usecs
[    0.568005] calling  gpiolib_sysfs_init+0x0/0x9b @ 1
[    0.572096] initcall gpiolib_sysfs_init+0x0/0x9b returned 0 after 0 usecs
[    0.576004] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.580149] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.584004] calling  pci_driver_init+0x0/0x14 @ 1
[    0.588113] initcall pci_driver_init+0x0/0x14 returned 0 after 0 usecs
[    0.592005] calling  backlight_class_init+0x0/0x60 @ 1
[    0.596130] initcall backlight_class_init+0x0/0x60 returned 0 after 0 usecs
[    0.600006] calling  xenbus_probe_init+0x0/0x167 @ 1
[    0.604020] initcall xenbus_probe_init+0x0/0x167 returned -19 after 0 usecs
[    0.608005] calling  tty_class_init+0x0/0x31 @ 1
[    0.612085] initcall tty_class_init+0x0/0x31 returned 0 after 0 usecs
[    0.616005] calling  vtconsole_class_init+0x0/0xcc @ 1
[    0.620196] initcall vtconsole_class_init+0x0/0xcc returned 0 after 0 usecs
[    0.624006] calling  i2c_init+0x0/0x6b @ 1
[    0.628266] i2c-core: driver [dummy] registered
[    0.632006] initcall i2c_init+0x0/0x6b returned 0 after 3906 usecs
[    0.636027] calling  amd_postcore_init+0x0/0x45 @ 1
[    0.640005] initcall amd_postcore_init+0x0/0x45 returned 0 after 0 usecs
[    0.644004] calling  arch_kdebugfs_init+0x0/0x31 @ 1
[    0.648008] initcall arch_kdebugfs_init+0x0/0x31 returned 0 after 0 usecs
[    0.652004] calling  ffh_cstate_init+0x0/0x37 @ 1
[    0.656005] initcall ffh_cstate_init+0x0/0x37 returned 0 after 0 usecs
[    0.660004] calling  acpi_pci_init+0x0/0x5a @ 1
[    0.664004] ACPI: bus type pci registered
[    0.668005] initcall acpi_pci_init+0x0/0x5a returned 0 after 3906 usecs
[    0.672004] calling  init_acpi_device_notify+0x0/0x4b @ 1
[    0.676004] initcall init_acpi_device_notify+0x0/0x4b returned 0 after 0 usecs
[    0.680004] calling  dmi_id_init+0x0/0x30f @ 1
[    0.684224] initcall dmi_id_init+0x0/0x30f returned 0 after 0 usecs
[    0.688005] calling  pci_arch_init+0x0/0x6a @ 1
[    0.692074] PCI: Found Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub without MMCONFIG support.
[    0.696003] PCI: Using configuration type 1 for base access
[    0.700011] initcall pci_arch_init+0x0/0x6a returned 0 after 7812 usecs
[    0.704004] calling  topology_init+0x0/0x16 @ 1
[    0.708086] initcall topology_init+0x0/0x16 returned 0 after 0 usecs
[    0.712004] calling  param_sysfs_init+0x0/0x1eb @ 1
[    0.750429] initcall param_sysfs_init+0x0/0x1eb returned 0 after 31250 usecs
[    0.752009] calling  pm_sysrq_init+0x0/0x20 @ 1
[    0.756290] initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
[    0.760310] calling  readahead_init+0x0/0x3b @ 1
[    0.764858] initcall readahead_init+0x0/0x3b returned 0 after 0 usecs
[    0.768006] calling  init_bio+0x0/0xda @ 1
[    0.772171] bio: create slab <bio-0> at 0
[    0.776098] initcall init_bio+0x0/0xda returned 0 after 3906 usecs
[    0.780005] calling  integrity_init+0x0/0x38 @ 1
[    0.784040] initcall integrity_init+0x0/0x38 returned 0 after 0 usecs
[    0.788006] calling  cryptomgr_init+0x0/0x3a @ 1
[    0.792130] initcall cryptomgr_init+0x0/0x3a returned 0 after 0 usecs
[    0.796018] calling  blk_settings_init+0x0/0x2c @ 1
[    0.800005] initcall blk_settings_init+0x0/0x2c returned 0 after 0 usecs
[    0.804004] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.808007] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.812004] calling  blk_softirq_init+0x0/0x35 @ 1
[    0.816004] initcall blk_softirq_init+0x0/0x35 returned 0 after 0 usecs
[    0.820004] calling  genhd_device_init+0x0/0x7e @ 1
[    0.824139] initcall genhd_device_init+0x0/0x7e returned 0 after 0 usecs
[    0.828005] calling  blk_dev_integrity_init+0x0/0x2a @ 1
[    0.832058] initcall blk_dev_integrity_init+0x0/0x2a returned 0 after 0 usecs
[    0.836006] calling  gpiolib_debugfs_init+0x0/0x24 @ 1
[    0.840010] initcall gpiolib_debugfs_init+0x0/0x24 returned 0 after 0 usecs
[    0.844005] calling  pca953x_init+0x0/0x17 @ 1
[    0.848098] i2c-core: driver [pca953x] registered
[    0.852006] initcall pca953x_init+0x0/0x17 returned 0 after 3906 usecs
[    0.856039] calling  pci_slot_init+0x0/0x50 @ 1
[    0.860011] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    0.864005] calling  fbmem_init+0x0/0x95 @ 1
[    0.868105] initcall fbmem_init+0x0/0x95 returned 0 after 0 usecs
[    0.872006] calling  acpi_init+0x0/0x239 @ 1
[    0.877001] ACPI: EC: Look up EC in DSDT
[    0.955936] ACPI: Interpreter enabled
[    0.956007] ACPI: (supports S0 S1 S3 S5)
[    0.961328] ACPI: Using IOAPIC for interrupt routing
[    0.964162] initcall acpi_init+0x0/0x239 returned 0 after 85937 usecs
[    0.968006] calling  acpi_scan_init+0x0/0x109 @ 1
[    1.009244] initcall acpi_scan_init+0x0/0x109 returned 0 after 35156 usecs
[    1.012064] calling  acpi_ec_init+0x0/0x61 @ 1
[    1.016100] initcall acpi_ec_init+0x0/0x61 returned 0 after 0 usecs
[    1.020006] calling  dock_init+0x0/0x8d @ 1
[    1.024443] ACPI: No dock devices found.
[    1.028006] initcall dock_init+0x0/0x8d returned 0 after 3906 usecs
[    1.032005] calling  acpi_pci_root_init+0x0/0x28 @ 1
[    1.036171] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.040213] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.044006] pci 0000:00:01.0: PME# disabled
[    1.048194] pci 0000:00:1b.0: reg 10 64bit mmio: [0xd7cf8000-0xd7cfbfff]
[    1.052044] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.056006] pci 0000:00:1b.0: PME# disabled
[    1.060060] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.064006] pci 0000:00:1c.0: PME# disabled
[    1.068063] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.072006] pci 0000:00:1c.3: PME# disabled
[    1.076049] pci 0000:00:1d.0: reg 20 io port: [0x7000-0x701f]
[    1.080052] pci 0000:00:1d.1: reg 20 io port: [0x7400-0x741f]
[    1.084051] pci 0000:00:1d.2: reg 20 io port: [0x7800-0x781f]
[    1.088051] pci 0000:00:1d.3: reg 20 io port: [0x8000-0x801f]
[    1.092056] pci 0000:00:1d.7: reg 10 32bit mmio: [0xd7cff800-0xd7cffbff]
[    1.096050] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.100006] pci 0000:00:1d.7: PME# disabled
[    1.104129] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    1.108009] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    1.112006] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    1.116007] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 0007)
[    1.120045] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    1.124008] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    1.128008] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    1.132008] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    1.136008] pci 0000:00:1f.1: reg 20 io port: [0xffa0-0xffaf]
[    1.140065] pci 0000:00:1f.2: reg 10 io port: [0x9800-0x9807]
[    1.144008] pci 0000:00:1f.2: reg 14 io port: [0x9400-0x9403]
[    1.148007] pci 0000:00:1f.2: reg 18 io port: [0x9000-0x9007]
[    1.152007] pci 0000:00:1f.2: reg 1c io port: [0x8800-0x8803]
[    1.156007] pci 0000:00:1f.2: reg 20 io port: [0x8400-0x840f]
[    1.160008] pci 0000:00:1f.2: reg 24 32bit mmio: [0xd7cffc00-0xd7cfffff]
[    1.164021] pci 0000:00:1f.2: PME# supported from D3hot
[    1.168006] pci 0000:00:1f.2: PME# disabled
[    1.172048] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    1.176055] pci 0000:04:00.0: reg 10 32bit mmio: [0xd8000000-0xdfffffff]
[    1.180008] pci 0000:04:00.0: reg 14 io port: [0xe000-0xe0ff]
[    1.184007] pci 0000:04:00.0: reg 18 32bit mmio: [0xd7fe0000-0xd7feffff]
[    1.188017] pci 0000:04:00.0: reg 30 32bit mmio: [0xd7fc0000-0xd7fdffff]
[    1.192021] pci 0000:04:00.0: supports D1 D2
[    1.196032] pci 0000:04:00.1: reg 10 32bit mmio: [0xd7ff0000-0xd7ffffff]
[    1.200039] pci 0000:04:00.1: supports D1 D2
[    1.204042] pci 0000:00:01.0: bridge io port: [0xe000-0xefff]
[    1.208005] pci 0000:00:01.0: bridge 32bit mmio: [0xd7f00000-0xd7ffffff]
[    1.212006] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd8000000-0xdfffffff]
[    1.216041] pci 0000:00:1c.0: bridge io port: [0xd000-0xdfff]
[    1.220069] pci 0000:02:00.0: reg 10 64bit mmio: [0xd7efc000-0xd7efffff]
[    1.224010] pci 0000:02:00.0: reg 18 io port: [0xc800-0xc8ff]
[    1.228027] pci 0000:02:00.0: reg 30 32bit mmio: [0xd7ec0000-0xd7edffff]
[    1.232042] pci 0000:02:00.0: supports D1 D2
[    1.236004] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.240007] pci 0000:02:00.0: PME# disabled
[    1.244041] pci 0000:00:1c.3: bridge io port: [0xc000-0xcfff]
[    1.248006] pci 0000:00:1c.3: bridge 32bit mmio: [0xd7e00000-0xd7efffff]
[    1.252045] pci 0000:01:01.0: reg 10 32bit mmio: [0xd7ddf000-0xd7ddffff]
[    1.256009] pci 0000:01:01.0: reg 14 32bit mmio: [0xd7dde000-0xd7ddefff]
[    1.260041] pci 0000:01:01.0: supports D1
[    1.264038] pci 0000:01:03.0: reg 10 io port: [0xb800-0xb807]
[    1.268009] pci 0000:01:03.0: reg 14 io port: [0xb400-0xb403]
[    1.272008] pci 0000:01:03.0: reg 18 io port: [0xb000-0xb007]
[    1.276008] pci 0000:01:03.0: reg 1c io port: [0xa800-0xa803]
[    1.280008] pci 0000:01:03.0: reg 20 io port: [0xa400-0xa40f]
[    1.284013] pci 0000:01:03.0: reg 30 32bit mmio: [0xd7de0000-0xd7dfffff]
[    1.288057] pci 0000:00:1e.0: transparent bridge
[    1.292006] pci 0000:00:1e.0: bridge io port: [0xa000-0xbfff]
[    1.296006] pci 0000:00:1e.0: bridge 32bit mmio: [0xd7d00000-0xd7dfffff]
[    1.300022] pci_bus 0000:00: on NUMA node 0
[    1.304021] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.312655] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    1.316282] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    1.320615] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    1.324296] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
[    1.348142] initcall acpi_pci_root_init+0x0/0x28 returned 0 after 304688 usecs
[    1.352007] calling  acpi_pci_link_init+0x0/0x63 @ 1
[    1.356458] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    1.364748] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    1.372746] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    1.380746] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    1.388747] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    1.396745] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    1.404744] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.414061] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    1.421875] initcall acpi_pci_link_init+0x0/0x63 returned 0 after 62500 usecs
[    1.424006] calling  acpi_power_init+0x0/0x77 @ 1
[    1.428380] initcall acpi_power_init+0x0/0x77 returned 0 after 0 usecs
[    1.432005] Clocksource tsc unstable (delta = 160815809 ns)
[    1.436046] calling  acpi_system_init+0x0/0x274 @ 1
[    1.440121] ACPI Warning (tbutils-0242): Incorrect checksum in table [OEMB] - 5F, should be 52 [20081204]
[    1.449220] initcall acpi_system_init+0x0/0x274 returned 0 after 7812 usecs
[    1.452006] calling  acpi_debug_init+0x0/0xae @ 1
[    1.456014] initcall acpi_debug_init+0x0/0xae returned 0 after 0 usecs
[    1.460006] calling  pnp_init+0x0/0x12 @ 1
[    1.464097] initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
[    1.468007] calling  setup_shutdown_event+0x0/0x21 @ 1
[    1.472033] initcall setup_shutdown_event+0x0/0x21 returned 0 after 0 usecs
[    1.476006] calling  misc_init+0x0/0xa4 @ 1
[    1.480102] initcall misc_init+0x0/0xa4 returned 0 after 0 usecs
[    1.484007] calling  tps_init+0x0/0xc7 @ 1
[    1.488029] tps65010: version 2 May 2005
[    1.492087] i2c-core: driver [tps65010] registered
[    1.496092] i2c-core: driver [tps65010] unregistered
[    1.516102] i2c-core: driver [tps65010] registered
[    1.520088] i2c-core: driver [tps65010] unregistered
[    1.540097] i2c-core: driver [tps65010] registered
[    1.544088] i2c-core: driver [tps65010] unregistered
[    1.548009] tps65010: no chip?
[    1.552007] initcall tps_init+0x0/0xc7 returned -19 after 62500 usecs
[    1.556006] calling  twl4030_init+0x0/0x14 @ 1
[    1.560084] i2c-core: driver [twl4030] registered
[    1.564007] initcall twl4030_init+0x0/0x14 returned 0 after 3906 usecs
[    1.568019] calling  phy_init+0x0/0x3a @ 1
[    1.572255] initcall phy_init+0x0/0x3a returned 0 after 0 usecs
[    1.576006] calling  init_scsi+0x0/0xa1 @ 1
[    1.580500] SCSI subsystem initialized
[    1.584007] initcall init_scsi+0x0/0xa1 returned 0 after 3906 usecs
[    1.588038] calling  ata_init+0x0/0x3fd @ 1
[    1.592061] libata version 3.00 loaded.
[    1.596007] initcall ata_init+0x0/0x3fd returned 0 after 3906 usecs
[    1.600041] calling  usb_init+0x0/0x168 @ 1
[    1.604297] usbcore: registered new interface driver usbfs
[    1.608111] usbcore: registered new interface driver hub
[    1.612136] usbcore: registered new device driver usb
[    1.616007] initcall usb_init+0x0/0x168 returned 0 after 11718 usecs
[    1.620048] calling  serio_init+0x0/0xa0 @ 1
[    1.624114] initcall serio_init+0x0/0xa0 returned 0 after 0 usecs
[    1.628007] calling  gameport_init+0x0/0xa0 @ 1
[    1.632140] initcall gameport_init+0x0/0xa0 returned 0 after 0 usecs
[    1.636007] calling  input_init+0x0/0x119 @ 1
[    1.640117] initcall input_init+0x0/0x119 returned 0 after 0 usecs
[    1.644007] calling  rtc_init+0x0/0x65 @ 1
[    1.648099] initcall rtc_init+0x0/0x65 returned 0 after 0 usecs
[    1.652006] calling  hwmon_init+0x0/0x44 @ 1
[    1.656098] initcall hwmon_init+0x0/0x44 returned 0 after 0 usecs
[    1.660006] calling  thermal_init+0x0/0x43 @ 1
[    1.664097] initcall thermal_init+0x0/0x43 returned 0 after 0 usecs
[    1.668006] calling  leds_init+0x0/0x40 @ 1
[    1.672098] initcall leds_init+0x0/0x40 returned 0 after 0 usecs
[    1.676007] calling  acpi_wmi_init+0x0/0x55 @ 1
[    1.680108] ACPI: WMI: Mapper loaded
[    1.684007] initcall acpi_wmi_init+0x0/0x55 returned 0 after 3906 usecs
[    1.688019] calling  ac97_bus_init+0x0/0x12 @ 1
[    1.692094] initcall ac97_bus_init+0x0/0x12 returned 0 after 0 usecs
[    1.696006] calling  pci_subsys_init+0x0/0x130 @ 1
[    1.700018] PCI: Using ACPI for IRQ routing
[    1.704122] initcall pci_subsys_init+0x0/0x130 returned 0 after 3906 usecs
[    1.708006] calling  proto_init+0x0/0x12 @ 1
[    1.712013] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    1.716006] calling  net_dev_init+0x0/0x141 @ 1
[    1.720277] initcall net_dev_init+0x0/0x141 returned 0 after 0 usecs
[    1.724007] calling  neigh_init+0x0/0x71 @ 1
[    1.728020] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    1.732007] calling  fib_rules_init+0x0/0xb0 @ 1
[    1.736008] initcall fib_rules_init+0x0/0xb0 returned 0 after 0 usecs
[    1.740006] calling  pktsched_init+0x0/0xc4 @ 1
[    1.744012] initcall pktsched_init+0x0/0xc4 returned 0 after 0 usecs
[    1.748007] calling  tc_filter_init+0x0/0x4c @ 1
[    1.752006] initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
[    1.756006] calling  genl_init+0x0/0xe1 @ 1
[    1.776031] initcall genl_init+0x0/0xe1 returned 0 after 15625 usecs
[    1.780007] calling  cipso_v4_init+0x0/0x5b @ 1
[    1.784022] initcall cipso_v4_init+0x0/0x5b returned 0 after 0 usecs
[    1.788007] calling  wanrouter_init+0x0/0x5a @ 1
[    1.792006] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[    1.796017] initcall wanrouter_init+0x0/0x5a returned 0 after 3906 usecs
[    1.800006] calling  wireless_nlevent_init+0x0/0x27 @ 1
[    1.804007] initcall wireless_nlevent_init+0x0/0x27 returned 0 after 0 usecs
[    1.808006] calling  netlbl_init+0x0/0x8a @ 1
[    1.812005] NetLabel: Initializing
[    1.816005] NetLabel:  domain hash size = 128
[    1.820005] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.824079] NetLabel:  unlabeled traffic allowed by default
[    1.828007] initcall netlbl_init+0x0/0x8a returned 0 after 15625 usecs
[    1.832007] calling  rfkill_init+0x0/0x69 @ 1
[    1.836094] initcall rfkill_init+0x0/0x69 returned 0 after 0 usecs
[    1.840007] calling  sysctl_init+0x0/0x51 @ 1
[    1.844008] initcall sysctl_init+0x0/0x51 returned 0 after 0 usecs
[    1.848009] calling  xen_mc_debugfs+0x0/0x11a @ 1
[    1.852040] initcall xen_mc_debugfs+0x0/0x11a returned 0 after 0 usecs
[    1.856007] calling  xen_mmu_debugfs+0x0/0x2c0 @ 1
[    1.860049] initcall xen_mmu_debugfs+0x0/0x2c0 returned 0 after 0 usecs
[    1.864007] calling  pci_iommu_init+0x0/0x18 @ 1
[    1.868040] initcall pci_iommu_init+0x0/0x18 returned 0 after 0 usecs
[    1.872007] calling  print_all_ICs+0x0/0x53a @ 1
[    1.876006] 
[    1.876006] printing PIC contents
[    1.880007] ... PIC  IMR: ffff
[    1.883106] ... PIC  IRR: 0c29
[    1.884005] ... PIC  ISR: 0000
[    1.888007] ... PIC ELCR: 0e28
[    1.891105] 
[    1.891106] printing local APIC contents on CPU#0/0:
[    1.892004] ... APIC ID:      00000000 (0)
[    1.892004] ... APIC VERSION: 00050014
[    1.892004] ... APIC TASKPRI: 00000000 (00)
[    1.892004] ... APIC PROCPRI: 00000000
[    1.892004] ... APIC LDR: 01000000
[    1.892004] ... APIC DFR: ffffffff
[    1.892004] ... APIC SPIV: 000001ff
[    1.892004] ... APIC ISR field:
[    1.892004] 0123456789abcdef0123456789abcdef
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] ... APIC TMR field:
[    1.892004] 0123456789abcdef0123456789abcdef
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] ... APIC IRR field:
[    1.892004] 0123456789abcdef0123456789abcdef
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000000000000000000000
[    1.892004] 00000000000000010000000000000000
[    1.892004] ... APIC ESR: 00000000
[    1.892004] ... APIC ICR: 000c0630
[    1.892004] ... APIC ICR2: ff000000
[    1.892004] ... APIC LVTT: 000200ef
[    1.892004] ... APIC LVTPC: 00010000
[    1.892004] ... APIC LVT0: 00010700
[    1.892004] ... APIC LVT1: 00000400
[    1.892004] ... APIC LVTERR: 000000fe
[    1.892004] ... APIC TMICT: 0000e110
[    1.892004] ... APIC TMCCT: 0000d9a0
[    1.892004] ... APIC TDCR: 00000003
[    1.892004] 
[    1.892005] number of MP IRQ sources: 15.
[    1.896005] number of IO-APIC #2 registers: 24.
[    1.900005] testing the IO APIC.......................
[    1.904010] 
[    1.908005] IO APIC #2......
[    1.910931] .... register #00: 02000000
[    1.912005] .......    : physical APIC id: 02
[    1.916005] .......    : Delivery Type: 0
[    1.920005] .......    : LTS          : 0
[    1.924005] .... register #01: 00170020
[    1.928005] .......     : max redirection entries: 0017
[    1.932005] .......     : PRQ implemented: 0
[    1.936005] .......     : IO APIC version: 0020
[    1.940005] .... IRQ redirection table:
[    1.944005]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    1.948008]  00 000 1    0    0   0   0    0    0    00
[    1.956008]  01 001 0    0    0   0   0    1    1    31
[    1.960008]  02 001 0    0    0   0   0    1    1    30
[    1.964008]  03 001 0    0    0   0   0    1    1    33
[    1.972008]  04 001 0    0    0   0   0    1    1    34
[    1.976008]  05 001 0    0    0   0   0    1    1    35
[    1.980008]  06 001 0    0    0   0   0    1    1    36
[    1.988008]  07 001 0    0    0   0   0    1    1    37
[    1.992008]  08 001 0    0    0   0   0    1    1    38
[    1.996008]  09 001 0    1    0   0   0    1    1    39
[    2.004008]  0a 001 0    0    0   0   0    1    1    3A
[    2.008008]  0b 001 0    0    0   0   0    1    1    3B
[    2.012008]  0c 001 0    0    0   0   0    1    1    3C
[    2.020008]  0d 001 0    0    0   0   0    1    1    3D
[    2.024008]  0e 001 0    0    0   0   0    1    1    3E
[    2.028008]  0f 001 0    0    0   0   0    1    1    3F
[    2.036008]  10 000 1    0    0   0   0    0    0    00
[    2.040008]  11 000 1    0    0   0   0    0    0    00
[    2.044008]  12 000 1    0    0   0   0    0    0    00
[    2.052008]  13 000 1    0    0   0   0    0    0    00
[    2.056008]  14 000 1    0    0   0   0    0    0    00
[    2.060008]  15 000 1    0    0   0   0    0    0    00
[    2.068008]  16 000 1    0    0   0   0    0    0    00
[    2.072008]  17 000 1    0    0   0   0    0    0    00
[    2.076006] IRQ to pin mappings:
[    2.080006] IRQ0 -> 0:2
[    2.084238] IRQ1 -> 0:1
[    2.086818] IRQ3 -> 0:3
[    2.088809] IRQ4 -> 0:4
[    2.092237] IRQ5 -> 0:5
[    2.094817] IRQ6 -> 0:6
[    2.096800] IRQ7 -> 0:7
[    2.100237] IRQ8 -> 0:8
[    2.102809] IRQ9 -> 0:9
[    2.104809] IRQ10 -> 0:10
[    2.108006] IRQ11 -> 0:11
[    2.110758] IRQ12 -> 0:12
[    2.112896] IRQ13 -> 0:13
[    2.116238] IRQ14 -> 0:14
[    2.118984] IRQ15 -> 0:15
[    2.120913] .................................... done.
[    2.124007] initcall print_all_ICs+0x0/0x53a returned 0 after 242187 usecs
[    2.128007] calling  hpet_late_init+0x0/0xf1 @ 1
[    2.132080] hpet clockevent registered
[    2.136015] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    2.141069] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    2.145009] initcall hpet_late_init+0x0/0xf1 returned 0 after 11718 usecs
[    2.148008] calling  clocksource_done_booting+0x0/0x12 @ 1
[    2.152007] initcall clocksource_done_booting+0x0/0x12 returned 0 after 0 usecs
[    2.156012] Switched to high resolution mode on CPU 0
[    2.161115] calling  rb_init_debugfs+0x0/0x50 @ 1
[    2.165879] initcall rb_init_debugfs+0x0/0x50 returned 0 after 6 usecs
[    2.172459] calling  tracer_init_debugfs+0x0/0x34e @ 1
[    2.177687] initcall tracer_init_debugfs+0x0/0x34e returned 0 after 35 usecs
[    2.184784] calling  init_pipe_fs+0x0/0x51 @ 1
[    2.189299] initcall init_pipe_fs+0x0/0x51 returned 0 after 17 usecs
[    2.195703] calling  init_mnt_writers+0x0/0x13 @ 1
[    2.200549] initcall init_mnt_writers+0x0/0x13 returned 0 after 0 usecs
[    2.207212] calling  anon_inode_init+0x0/0x12e @ 1
[    2.212082] initcall anon_inode_init+0x0/0x12e returned 0 after 23 usecs
[    2.218834] calling  acpi_event_init+0x0/0x52 @ 1
[    2.236030] initcall acpi_event_init+0x0/0x52 returned 0 after 12145 usecs
[    2.242954] calling  pnpacpi_init+0x0/0x8e @ 1
[    2.247454] pnp: PnP ACPI init
[    2.250575] ACPI: bus type pnp registered
[    2.255677] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    2.263351] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    2.273858] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    2.285019] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    2.301155] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    2.311673] pnp: PnP ACPI: found 14 devices
[    2.315909] ACPI: ACPI bus type pnp unregistered
[    2.320646] initcall pnpacpi_init+0x0/0x8e returned 0 after 71474 usecs
[    2.327306] calling  pnp_system_init+0x0/0x13 @ 1
[    2.332078] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    2.339274] system 00:08: ioport range 0x290-0x297 has been reserved
[    2.345685] system 00:09: ioport range 0x4d0-0x4d1 has been reserved
[    2.352085] system 00:09: ioport range 0x800-0x87f has been reserved
[    2.358488] system 00:09: ioport range 0x480-0x4bf has been reserved
[    2.364893] system 00:09: ioport range 0x900-0x91f has been reserved
[    2.371299] system 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    2.378484] system 00:09: iomem range 0xfed20000-0xfed8ffff has been reserved
[    2.385670] system 00:09: iomem range 0xffb00000-0xffbfffff could not be reserved
[    2.393216] system 00:09: iomem range 0xfff00000-0xffffffff has been reserved
[    2.400406] system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
[    2.407595] system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
[    2.414783] system 00:0c: iomem range 0xf0000000-0xf3ffffff has been reserved
[    2.421970] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    2.428637] system 00:0d: iomem range 0xc0000-0xdffff has been reserved
[    2.435303] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    2.442315] system 00:0d: iomem range 0x100000-0x7fffffff could not be reserved
[    2.449774] initcall pnp_system_init+0x0/0x13 returned 0 after 114949 usecs
[    2.456787] calling  chr_dev_init+0x0/0xa3 @ 1
[    2.462289] initcall chr_dev_init+0x0/0xa3 returned 0 after 939 usecs
[    2.468782] calling  firmware_class_init+0x0/0x7f @ 1
[    2.473984] initcall firmware_class_init+0x0/0x7f returned 0 after 79 usecs
[    2.480993] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    2.487008] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 1 usecs
[    2.494729] calling  pcibios_assign_resources+0x0/0x8a @ 1
[    2.500316] pci 0000:00:01.0: PCI bridge, secondary bus 0000:04
[    2.506281] pci 0000:00:01.0:   IO window: 0xe000-0xefff
[    2.511647] pci 0000:00:01.0:   MEM window: 0xd7f00000-0xd7ffffff
[    2.517792] pci 0000:00:01.0:   PREFETCH window: 0x000000d8000000-0x000000dfffffff
[    2.525428] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:03
[    2.531398] pci 0000:00:1c.0:   IO window: 0xd000-0xdfff
[    2.536763] pci 0000:00:1c.0:   MEM window: disabled
[    2.541780] pci 0000:00:1c.0:   PREFETCH window: disabled
[    2.547234] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:02
[    2.553202] pci 0000:00:1c.3:   IO window: 0xc000-0xcfff
[    2.558569] pci 0000:00:1c.3:   MEM window: 0xd7e00000-0xd7efffff
[    2.564712] pci 0000:00:1c.3:   PREFETCH window: disabled
[    2.570169] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
[    2.576134] pci 0000:00:1e.0:   IO window: 0xa000-0xbfff
[    2.581500] pci 0000:00:1e.0:   MEM window: 0xd7d00000-0xd7dfffff
[    2.587645] pci 0000:00:1e.0:   PREFETCH window: 0x00000088000000-0x000000880fffff
[    2.595289]   alloc irq_desc for 16 on cpu 0 node 0
[    2.599275]   alloc kstat_irqs on cpu 0 node 0
[    2.604711] IOAPIC[0]: Set routing entry (2-16 -> 0x49 -> IRQ 16 Mode:1 Active:1)
[    2.612258] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.619011] pci 0000:00:01.0: setting latency timer to 64
[    2.624465] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.631212] pci 0000:00:1c.0: setting latency timer to 64
[    2.636667]   alloc irq_desc for 19 on cpu 0 node 0
[    2.640659]   alloc kstat_irqs on cpu 0 node 0
[    2.646084] IOAPIC[0]: Set routing entry (2-19 -> 0x51 -> IRQ 19 Mode:1 Active:1)
[    2.653632] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.660384] pci 0000:00:1c.3: setting latency timer to 64
[    2.665838] pci 0000:00:1e.0: setting latency timer to 64
[    2.671288] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    2.676823] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    2.683748] pci_bus 0000:04: resource 0 io:  [0xe000-0xefff]
[    2.689458] pci_bus 0000:04: resource 1 mem: [0xd7f00000-0xd7ffffff]
[    2.695863] pci_bus 0000:04: resource 2 mem: [0xd8000000-0xdfffffff]
[    2.702267] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    2.707451] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
[    2.713162] pci_bus 0000:03: resource 1 mem: [0x0-0x0]
[    2.718344] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    2.723882] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    2.729066] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
[    2.734776] pci_bus 0000:02: resource 1 mem: [0xd7e00000-0xd7efffff]
[    2.741181] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    2.746363] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    2.751547] pci_bus 0000:01: resource 0 io:  [0xa000-0xbfff]
[    2.757258] pci_bus 0000:01: resource 1 mem: [0xd7d00000-0xd7dfffff]
[    2.763662] pci_bus 0000:01: resource 2 mem: [0x88000000-0x880fffff]
[    2.770067] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    2.775597] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
[    2.782524] initcall pcibios_assign_resources+0x0/0x8a returned 0 after 275640 usecs
[    2.790332] calling  sysctl_core_init+0x0/0x38 @ 1
[    2.795186] initcall sysctl_core_init+0x0/0x38 returned 0 after 9 usecs
[    2.801849] calling  inet_init+0x0/0x25a @ 1
[    2.806196] NET: Registered protocol family 2
[    2.856066] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    2.863781] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    2.874517] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    2.881648] TCP: Hash tables configured (established 262144 bind 65536)
[    2.888309] TCP reno registered
[    2.900162] initcall inet_init+0x0/0x25a returned 0 after 91775 usecs
[    2.906657] calling  af_unix_init+0x0/0x65 @ 1
[    2.911173] NET: Registered protocol family 1
[    2.915592] initcall af_unix_init+0x0/0x65 returned 0 after 4334 usecs
[    2.922173] calling  populate_rootfs+0x0/0xfb @ 1
[    2.927401] initcall populate_rootfs+0x0/0xfb returned 0 after 462 usecs
[    2.934158] calling  calgary_fixup_tce_spaces+0x0/0xf8 @ 1
[    2.939695] initcall calgary_fixup_tce_spaces+0x0/0xf8 returned -19 after 0 usecs
[    2.947241] calling  i8259A_init_sysfs+0x0/0x29 @ 1
[    2.952437] initcall i8259A_init_sysfs+0x0/0x29 returned 0 after 257 usecs
[    2.959358] calling  vsyscall_init+0x0/0xa3 @ 1
[    2.963950] initcall vsyscall_init+0x0/0xa3 returned 0 after 3 usecs
[    2.970355] calling  sbf_init+0x0/0x103 @ 1
[    2.974595] initcall sbf_init+0x0/0x103 returned 0 after 0 usecs
[    2.980652] calling  i8237A_init_sysfs+0x0/0x29 @ 1
[    2.985754] initcall i8237A_init_sysfs+0x0/0x29 returned 0 after 166 usecs
[    2.992682] calling  add_rtc_cmos+0x0/0xce @ 1
[    2.997210] initcall add_rtc_cmos+0x0/0xce returned 0 after 5 usecs
[    3.003526] calling  cache_sysfs_init+0x0/0x221 @ 1
[    3.008724] initcall cache_sysfs_init+0x0/0x221 returned 0 after 262 usecs
[    3.015649] calling  mce_init_device+0x0/0x120 @ 1
[    3.020814] initcall mce_init_device+0x0/0x120 returned 0 after 293 usecs
[    3.027652] calling  periodic_mcheck_init+0x0/0x41 @ 1
[    3.032909] initcall periodic_mcheck_init+0x0/0x41 returned 0 after 2 usecs
[    3.039923] calling  thermal_throttle_init_device+0x0/0x44 @ 1
[    3.045812] initcall thermal_throttle_init_device+0x0/0x44 returned 0 after 4 usecs
[    3.053538] calling  threshold_init_device+0x0/0x57 @ 1
[    3.058817] initcall threshold_init_device+0x0/0x57 returned 0 after 0 usecs
[    3.065915] calling  init_lapic_sysfs+0x0/0x2f @ 1
[    3.070921] initcall init_lapic_sysfs+0x0/0x2f returned 0 after 157 usecs
[    3.077763] calling  ioapic_init_sysfs+0x0/0xd0 @ 1
[    3.082891] initcall ioapic_init_sysfs+0x0/0xd0 returned 0 after 158 usecs
[    3.089821] calling  start_periodic_check_for_corruption+0x0/0x40 @ 1
[    3.096336] Scanning for low memory corruption every 60 seconds
[    3.102309] initcall start_periodic_check_for_corruption+0x0/0x40 returned 0 after 5831 usecs
[    3.110903] calling  uv_ptc_init+0x0/0x51 @ 1
[    3.115316] initcall uv_ptc_init+0x0/0x51 returned 0 after 1 usecs
[    3.121545] calling  uv_bau_init+0x0/0x410 @ 1
[    3.126045] initcall uv_bau_init+0x0/0x410 returned 0 after 1 usecs
[    3.132361] calling  sgi_uv_sysfs_init+0x0/0xaf @ 1
[    3.137302] initcall sgi_uv_sysfs_init+0x0/0xaf returned 0 after 7 usecs
[    3.144053] calling  aes_init+0x0/0x20 @ 1
[    3.148296] initcall aes_init+0x0/0x20 returned 0 after 87 usecs
[    3.154349] calling  crc32c_intel_mod_init+0x0/0x30 @ 1
[    3.159659] initcall crc32c_intel_mod_init+0x0/0x30 returned -19 after 0 usecs
[    3.166950] calling  init_vdso_vars+0x0/0x241 @ 1
[    3.171732] initcall init_vdso_vars+0x0/0x241 returned 0 after 21 usecs
[    3.178399] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    3.183247] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 2 usecs
[    3.189908] calling  sysenter_setup+0x0/0x377 @ 1
[    3.194674] initcall sysenter_setup+0x0/0x377 returned 0 after 6 usecs
[    3.201253] calling  init_aout_binfmt+0x0/0x1b @ 1
[    3.206098] initcall init_aout_binfmt+0x0/0x1b returned 0 after 1 usecs
[    3.212761] calling  init_sched_debug_procfs+0x0/0x2c @ 1
[    3.218223] initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 8 usecs
[    3.225511] calling  proc_schedstat_init+0x0/0x22 @ 1
[    3.230621] initcall proc_schedstat_init+0x0/0x22 returned 0 after 4 usecs
[    3.237548] calling  proc_execdomains_init+0x0/0x2f @ 1
[    3.242832] initcall proc_execdomains_init+0x0/0x2f returned 0 after 4 usecs
[    3.249926] calling  ioresources_init+0x0/0x3c @ 1
[    3.254777] initcall ioresources_init+0x0/0x3c returned 0 after 7 usecs
[    3.261442] calling  uid_cache_init+0x0/0x85 @ 1
[    3.266119] initcall uid_cache_init+0x0/0x85 returned 0 after 5 usecs
[    3.272606] calling  init_posix_timers+0x0/0xe8 @ 1
[    3.277542] initcall init_posix_timers+0x0/0xe8 returned 0 after 5 usecs
[    3.284288] calling  init_posix_cpu_timers+0x0/0xb3 @ 1
[    3.289567] initcall init_posix_cpu_timers+0x0/0xb3 returned 0 after 0 usecs
[    3.296664] calling  nsproxy_cache_init+0x0/0x38 @ 1
[    3.301686] initcall nsproxy_cache_init+0x0/0x38 returned 0 after 3 usecs
[    3.308520] calling  timekeeping_init_device+0x0/0x29 @ 1
[    3.314133] initcall timekeeping_init_device+0x0/0x29 returned 0 after 157 usecs
[    3.321598] calling  init_clocksource_sysfs+0x0/0x52 @ 1
[    3.327138] initcall init_clocksource_sysfs+0x0/0x52 returned 0 after 157 usecs
[    3.334512] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    3.339910] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 4 usecs
[    3.347096] calling  futex_init+0x0/0xa5 @ 1
[    3.351429] initcall futex_init+0x0/0xa5 returned 0 after 7 usecs
[    3.357573] calling  proc_dma_init+0x0/0x22 @ 1
[    3.362168] initcall proc_dma_init+0x0/0x22 returned 0 after 8 usecs
[    3.368572] calling  proc_modules_init+0x0/0x22 @ 1
[    3.373508] initcall proc_modules_init+0x0/0x22 returned 0 after 4 usecs
[    3.380254] calling  kallsyms_init+0x0/0x25 @ 1
[    3.384845] initcall kallsyms_init+0x0/0x25 returned 0 after 4 usecs
[    3.391252] calling  crash_save_vmcoreinfo_init+0x0/0x4a0 @ 1
[    3.397067] initcall crash_save_vmcoreinfo_init+0x0/0x4a0 returned 0 after 15 usecs
[    3.404790] calling  crash_notes_memory_init+0x0/0x3c @ 1
[    3.410244] initcall crash_notes_memory_init+0x0/0x3c returned 0 after 1 usecs
[    3.417530] calling  init_kprobes+0x0/0x16c @ 1
[    3.430556] initcall init_kprobes+0x0/0x16c returned 0 after 8245 usecs
[    3.437221] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    3.442329] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 3 usecs
[    3.449252] calling  init_tracepoints+0x0/0x20 @ 1
[    3.454096] initcall init_tracepoints+0x0/0x20 returned 0 after 0 usecs
[    3.460759] calling  init_lstats_procfs+0x0/0x34 @ 1
[    3.465782] initcall init_lstats_procfs+0x0/0x34 returned 0 after 4 usecs
[    3.472615] calling  init_stack_trace+0x0/0x1b @ 1
[    3.477462] initcall init_stack_trace+0x0/0x1b returned 0 after 1 usecs
[    3.484125] calling  init_per_zone_pages_min+0x0/0x96 @ 1
[    3.489808] initcall init_per_zone_pages_min+0x0/0x96 returned 0 after 225 usecs
[    3.497275] calling  pdflush_init+0x0/0x12 @ 1
[    3.501832] initcall pdflush_init+0x0/0x12 returned 0 after 59 usecs
[    3.508236] calling  kswapd_init+0x0/0x14 @ 1
[    3.512698] initcall kswapd_init+0x0/0x14 returned 0 after 23 usecs
[    3.519017] calling  init_tmpfs+0x0/0xd8 @ 1
[    3.523388] initcall init_tmpfs+0x0/0xd8 returned 0 after 38 usecs
[    3.529616] calling  setup_vmstat+0x0/0x7c @ 1
[    3.534129] initcall setup_vmstat+0x0/0x7c returned 0 after 14 usecs
[    3.540536] calling  mm_sysfs_init+0x0/0x29 @ 1
[    3.545130] initcall mm_sysfs_init+0x0/0x29 returned 0 after 8 usecs
[    3.551534] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    3.556472] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 5 usecs
[    3.563225] calling  procswaps_init+0x0/0x24 @ 1
[    3.567902] initcall procswaps_init+0x0/0x24 returned 0 after 4 usecs
[    3.574397] calling  hugetlb_init+0x0/0x478 @ 1
[    3.578982] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.585400] initcall hugetlb_init+0x0/0x478 returned 0 after 6267 usecs
[    3.592059] calling  slab_proc_init+0x0/0x25 @ 1
[    3.596735] initcall slab_proc_init+0x0/0x25 returned 0 after 4 usecs
[    3.603222] calling  slab_sysfs_init+0x0/0xf8 @ 1
[    3.619507] initcall slab_sysfs_init+0x0/0xf8 returned 0 after 11251 usecs
[    3.626443] calling  fasync_init+0x0/0x31 @ 1
[    3.632626] initcall fasync_init+0x0/0x31 returned 0 after 1459 usecs
[    3.639120] calling  proc_filesystems_init+0x0/0x22 @ 1
[    3.644441] initcall proc_filesystems_init+0x0/0x22 returned 0 after 11 usecs
[    3.651626] calling  dnotify_init+0x0/0x2a @ 1
[    3.656261] initcall dnotify_init+0x0/0x2a returned 0 after 133 usecs
[    3.662754] calling  aio_setup+0x0/0xb4 @ 1
[    3.667539] initcall aio_setup+0x0/0xb4 returned 0 after 424 usecs
[    3.673770] calling  proc_locks_init+0x0/0x22 @ 1
[    3.678590] initcall proc_locks_init+0x0/0x22 returned 0 after 5 usecs
[    3.685166] calling  init_sys32_ioctl+0x0/0x88 @ 1
[    3.690030] initcall init_sys32_ioctl+0x0/0x88 returned 0 after 19 usecs
[    3.696779] calling  init_mbcache+0x0/0x14 @ 1
[    3.701279] initcall init_mbcache+0x0/0x14 returned 0 after 1 usecs
[    3.707595] calling  dquot_init+0x0/0xf3 @ 1
[    3.711918] VFS: Disk quotas dquot_6.5.2
[    3.716039] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.722600] initcall dquot_init+0x0/0xf3 returned 0 after 10429 usecs
[    3.729088] calling  init_v1_quota_format+0x0/0x12 @ 1
[    3.734280] initcall init_v1_quota_format+0x0/0x12 returned 0 after 0 usecs
[    3.741290] calling  init_v2_quota_format+0x0/0x14 @ 1
[    3.746483] initcall init_v2_quota_format+0x0/0x14 returned 0 after 0 usecs
[    3.753493] calling  proc_cmdline_init+0x0/0x22 @ 1
[    3.758431] initcall proc_cmdline_init+0x0/0x22 returned 0 after 5 usecs
[    3.765184] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    3.770122] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 5 usecs
[    3.776876] calling  proc_devices_init+0x0/0x22 @ 1
[    3.781815] initcall proc_devices_init+0x0/0x22 returned 0 after 6 usecs
[    3.788914] calling  proc_interrupts_init+0x0/0x22 @ 1
[    3.794110] initcall proc_interrupts_init+0x0/0x22 returned 0 after 4 usecs
[    3.801126] calling  proc_loadavg_init+0x0/0x22 @ 1
[    3.806062] initcall proc_loadavg_init+0x0/0x22 returned 0 after 4 usecs
[    3.812816] calling  proc_meminfo_init+0x0/0x22 @ 1
[    3.817753] initcall proc_meminfo_init+0x0/0x22 returned 0 after 4 usecs
[    3.824508] calling  proc_stat_init+0x0/0x22 @ 1
[    3.829185] initcall proc_stat_init+0x0/0x22 returned 0 after 4 usecs
[    3.835679] calling  proc_uptime_init+0x0/0x2d @ 1
[    3.840530] initcall proc_uptime_init+0x0/0x2d returned 0 after 4 usecs
[    3.847198] calling  proc_version_init+0x0/0x22 @ 1
[    3.852135] initcall proc_version_init+0x0/0x22 returned 0 after 4 usecs
[    3.858889] calling  proc_kmsg_init+0x0/0x25 @ 1
[    3.863565] initcall proc_kmsg_init+0x0/0x25 returned 0 after 4 usecs
[    3.870060] calling  proc_page_init+0x0/0x42 @ 1
[    3.874741] initcall proc_page_init+0x0/0x42 returned 0 after 7 usecs
[    3.881232] calling  configfs_init+0x0/0xd6 @ 1
[    3.885958] initcall configfs_init+0x0/0xd6 returned 0 after 137 usecs
[    3.892533] calling  init_devpts_fs+0x0/0x49 @ 1
[    3.897236] Created ptmx node in devpts ino 2
[    3.901643] initcall init_devpts_fs+0x0/0x49 returned 0 after 4330 usecs
[    3.908393] calling  init_dlm+0x0/0xa3 @ 1
[    3.913033] DLM (built Feb  8 2009 06:53:43) installed
[    3.918222] initcall init_dlm+0x0/0xa3 returned 0 after 5544 usecs
[    3.924480] calling  init_ext3_fs+0x0/0x72 @ 1
[    3.929259] initcall init_ext3_fs+0x0/0x72 returned 0 after 276 usecs
[    3.935754] calling  journal_init+0x0/0xea @ 1
[    3.940841] initcall journal_init+0x0/0xea returned 0 after 536 usecs
[    3.947332] calling  init_ext2_fs+0x0/0x62 @ 1
[    3.951989] initcall init_ext2_fs+0x0/0x62 returned 0 after 132 usecs
[    3.958478] calling  init_ramfs_fs+0x0/0x12 @ 1
[    3.963140] initcall init_ramfs_fs+0x0/0x12 returned 0 after 1 usecs
[    3.969545] calling  init_hugetlbfs_fs+0x0/0xad @ 1
[    3.974626] initcall init_hugetlbfs_fs+0x0/0xad returned 0 after 146 usecs
[    3.981548] calling  init_minix_fs+0x0/0x62 @ 1
[    3.986287] initcall init_minix_fs+0x0/0x62 returned 0 after 133 usecs
[    3.992868] calling  init_iso9660_fs+0x0/0x72 @ 1
[    3.997803] initcall init_iso9660_fs+0x0/0x72 returned 0 after 153 usecs
[    4.004559] calling  init_hfsplus_fs+0x0/0x60 @ 1
[    4.009491] initcall init_hfsplus_fs+0x0/0x60 returned 0 after 156 usecs
[    4.016242] calling  init_nls_cp855+0x0/0x12 @ 1
[    4.020929] initcall init_nls_cp855+0x0/0x12 returned 0 after 1 usecs
[    4.027422] calling  init_nls_cp860+0x0/0x12 @ 1
[    4.032093] initcall init_nls_cp860+0x0/0x12 returned 0 after 0 usecs
[    4.038583] calling  init_nls_cp862+0x0/0x12 @ 1
[    4.043255] initcall init_nls_cp862+0x0/0x12 returned 0 after 0 usecs
[    4.049747] calling  init_nls_cp863+0x0/0x12 @ 1
[    4.054419] initcall init_nls_cp863+0x0/0x12 returned 0 after 0 usecs
[    4.060909] calling  init_nls_cp865+0x0/0x12 @ 1
[    4.065582] initcall init_nls_cp865+0x0/0x12 returned 0 after 0 usecs
[    4.072072] calling  init_nls_cp874+0x0/0x12 @ 1
[    4.076744] initcall init_nls_cp874+0x0/0x12 returned 0 after 0 usecs
[    4.083234] calling  init_nls_cp932+0x0/0x12 @ 1
[    4.087907] initcall init_nls_cp932+0x0/0x12 returned 0 after 0 usecs
[    4.094396] calling  init_nls_euc_jp+0x0/0x48 @ 1
[    4.099156] initcall init_nls_euc_jp+0x0/0x48 returned 0 after 0 usecs
[    4.105733] calling  init_nls_cp949+0x0/0x12 @ 1
[    4.110405] initcall init_nls_cp949+0x0/0x12 returned 0 after 0 usecs
[    4.116895] calling  init_nls_ascii+0x0/0x12 @ 1
[    4.121567] initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
[    4.128058] calling  init_nls_iso8859_2+0x0/0x12 @ 1
[    4.133077] initcall init_nls_iso8859_2+0x0/0x12 returned 0 after 0 usecs
[    4.139914] calling  init_nls_iso8859_5+0x0/0x12 @ 1
[    4.144934] initcall init_nls_iso8859_5+0x0/0x12 returned 0 after 0 usecs
[    4.151771] calling  init_nls_cp1255+0x0/0x12 @ 1
[    4.156530] initcall init_nls_cp1255+0x0/0x12 returned 0 after 0 usecs
[    4.163106] calling  init_nls_iso8859_13+0x0/0x12 @ 1
[    4.168213] initcall init_nls_iso8859_13+0x0/0x12 returned 0 after 0 usecs
[    4.175135] calling  init_nls_utf8+0x0/0x26 @ 1
[    4.179722] initcall init_nls_utf8+0x0/0x26 returned 0 after 0 usecs
[    4.186125] calling  init_smb_fs+0x0/0x72 @ 1
[    4.190798] initcall init_smb_fs+0x0/0x72 returned 0 after 255 usecs
[    4.197201] calling  init_hpfs_fs+0x0/0x62 @ 1
[    4.201847] initcall init_hpfs_fs+0x0/0x62 returned 0 after 130 usecs
[    4.208338] calling  init_ufs_fs+0x0/0x62 @ 1
[    4.212907] initcall init_ufs_fs+0x0/0x62 returned 0 after 131 usecs
[    4.219310] calling  init_romfs_fs+0x0/0x62 @ 1
[    4.224043] initcall init_romfs_fs+0x0/0x62 returned 0 after 131 usecs
[    4.230636] calling  init_qnx4_fs+0x0/0x70 @ 1
[    4.235264] QNX4 filesystem 0.2.3 registered.
[    4.239677] initcall init_qnx4_fs+0x0/0x70 returned 0 after 4436 usecs
[    4.246258] calling  init_adfs_fs+0x0/0x62 @ 1
[    4.250890] initcall init_adfs_fs+0x0/0x62 returned 0 after 134 usecs
[    4.257382] calling  init_omfs_fs+0x0/0x12 @ 1
[    4.261906] initcall init_omfs_fs+0x0/0x12 returned 0 after 1 usecs
[    4.268224] calling  init_jfs_fs+0x0/0x1d0 @ 1
[    4.272998] JFS: nTxBlock = 8192, nTxLock = 65536
[    4.282599] initcall init_jfs_fs+0x0/0x1d0 returned 0 after 9636 usecs
[    4.289205] calling  init_xfs_fs+0x0/0xce @ 1
[    4.293667] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    4.305316] SGI XFS Quota Management subsystem
[    4.309830] initcall init_xfs_fs+0x0/0xce returned 0 after 15782 usecs
[    4.316412] calling  init_befs_fs+0x0/0x8a @ 1
[    4.320908] BeFS version: 0.9.3
[    4.324243] initcall init_befs_fs+0x0/0x8a returned 0 after 3255 usecs
[    4.330823] calling  init_btrfs_fs+0x0/0xbc @ 1
[    4.336775] Btrfs loaded
[    4.339354] initcall init_btrfs_fs+0x0/0xbc returned 0 after 3745 usecs
[    4.346134] calling  init_gfs2_fs+0x0/0x1ce @ 1
[    4.351640] GFS2 (built Feb  8 2009 06:53:45) installed
[    4.356921] initcall init_gfs2_fs+0x0/0x1ce returned 0 after 6061 usecs
[    4.363628] calling  init_lock_dlm+0x0/0x6b @ 1
[    4.368220] Lock_DLM (built Feb  8 2009 06:53:59) installed
[    4.373845] initcall init_lock_dlm+0x0/0x6b returned 0 after 5501 usecs
[    4.380508] calling  ipc_init+0x0/0x2f @ 1
[    4.384661] msgmni has been set to 3996
[    4.388562] initcall ipc_init+0x0/0x2f returned 0 after 3818 usecs
[    4.394791] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    4.399554] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 4 usecs
[    4.406128] calling  init_mqueue_fs+0x0/0xbd @ 1
[    4.410968] initcall init_mqueue_fs+0x0/0xbd returned 0 after 164 usecs
[    4.417629] calling  key_proc_init+0x0/0x5e @ 1
[    4.422365] initcall key_proc_init+0x0/0x5e returned 0 after 9 usecs
[    4.428783] calling  crypto_algapi_init+0x0/0xd @ 1
[    4.433722] initcall crypto_algapi_init+0x0/0xd returned 0 after 7 usecs
[    4.440474] calling  chainiv_module_init+0x0/0x12 @ 1
[    4.445582] initcall chainiv_module_init+0x0/0x12 returned 0 after 2 usecs
[    4.452504] calling  eseqiv_module_init+0x0/0x12 @ 1
[    4.457523] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.464360] calling  seqiv_module_init+0x0/0x1c @ 1
[    4.469292] initcall seqiv_module_init+0x0/0x1c returned 0 after 0 usecs
[    4.476042] calling  hmac_module_init+0x0/0x12 @ 1
[    4.480887] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.487551] calling  crypto_null_mod_init+0x0/0x80 @ 1
[    4.492774] alg: No test for cipher_null (cipher_null-generic)
[    4.498719] alg: No test for digest_null (digest_null-generic)
[    4.504653] alg: No test for compress_null (compress_null-generic)
[    4.510891] initcall crypto_null_mod_init+0x0/0x80 returned 0 after 17721 usecs
[    4.518305] calling  md4_mod_init+0x0/0x12 @ 1
[    4.522853] initcall md4_mod_init+0x0/0x12 returned 0 after 51 usecs
[    4.529255] calling  md5_mod_init+0x0/0x12 @ 1
[    4.533820] initcall md5_mod_init+0x0/0x12 returned 0 after 44 usecs
[    4.540227] calling  rmd128_mod_init+0x0/0x12 @ 1
[    4.545061] initcall rmd128_mod_init+0x0/0x12 returned 0 after 51 usecs
[    4.551727] calling  rmd256_mod_init+0x0/0x12 @ 1
[    4.556546] initcall rmd256_mod_init+0x0/0x12 returned 0 after 48 usecs
[    4.563211] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[    4.568544] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 45 usecs
[    4.575726] calling  sha256_generic_mod_init+0x0/0x49 @ 1
[    4.581282] initcall sha256_generic_mod_init+0x0/0x49 returned 0 after 90 usecs
[    4.588657] calling  wp512_mod_init+0x0/0x80 @ 1
[    4.593539] initcall wp512_mod_init+0x0/0x80 returned 0 after 197 usecs
[    4.600200] calling  tgr192_mod_init+0x0/0x72 @ 1
[    4.605114] initcall tgr192_mod_init+0x0/0x72 returned 0 after 139 usecs
[    4.611867] calling  crypto_ecb_module_init+0x0/0x12 @ 1
[    4.617249] initcall crypto_ecb_module_init+0x0/0x12 returned 0 after 1 usecs
[    4.624432] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    4.629798] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.636981] calling  crypto_pcbc_module_init+0x0/0x12 @ 1
[    4.642434] initcall crypto_pcbc_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.649721] calling  crypto_module_init+0x0/0x12 @ 1
[    4.654740] initcall crypto_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.661577] calling  crypto_ctr_module_init+0x0/0x44 @ 1
[    4.666944] initcall crypto_ctr_module_init+0x0/0x44 returned 0 after 1 usecs
[    4.674126] calling  crypto_gcm_module_init+0x0/0x62 @ 1
[    4.679493] initcall crypto_gcm_module_init+0x0/0x62 returned 0 after 1 usecs
[    4.686675] calling  crypto_ccm_module_init+0x0/0x62 @ 1
[    4.692042] initcall crypto_ccm_module_init+0x0/0x62 returned 0 after 1 usecs
[    4.699225] calling  des_generic_mod_init+0x0/0x44 @ 1
[    4.704525] initcall des_generic_mod_init+0x0/0x44 returned 0 after 104 usecs
[    4.711706] calling  fcrypt_mod_init+0x0/0x12 @ 1
[    4.716507] alg: No test for fcrypt (fcrypt-generic)
[    4.721534] initcall fcrypt_mod_init+0x0/0x12 returned 0 after 4933 usecs
[    4.728386] calling  blowfish_mod_init+0x0/0x12 @ 1
[    4.733772] initcall blowfish_mod_init+0x0/0x12 returned 0 after 448 usecs
[    4.740696] calling  twofish_mod_init+0x0/0x12 @ 1
[    4.745624] initcall twofish_mod_init+0x0/0x12 returned 0 after 76 usecs
[    4.752379] calling  serpent_mod_init+0x0/0x44 @ 1
[    4.757360] initcall serpent_mod_init+0x0/0x44 returned 0 after 117 usecs
[    4.764200] calling  aes_init+0x0/0x12 @ 1
[    4.768429] initcall aes_init+0x0/0x12 returned 0 after 67 usecs
[    4.774487] calling  camellia_init+0x0/0x12 @ 1
[    4.779148] initcall camellia_init+0x0/0x12 returned 0 after 59 usecs
[    4.785641] calling  cast5_mod_init+0x0/0x12 @ 1
[    4.790379] initcall cast5_mod_init+0x0/0x12 returned 0 after 58 usecs
[    4.796961] calling  arc4_init+0x0/0x12 @ 1
[    4.801613] initcall arc4_init+0x0/0x12 returned 0 after 56 usecs
[    4.807758] calling  khazad_mod_init+0x0/0x12 @ 1
[    4.812597] initcall khazad_mod_init+0x0/0x12 returned 0 after 70 usecs
[    4.819259] calling  anubis_mod_init+0x0/0x12 @ 1
[    4.824108] initcall anubis_mod_init+0x0/0x12 returned 0 after 79 usecs
[    4.830769] calling  deflate_mod_init+0x0/0x12 @ 1
[    4.836009] initcall deflate_mod_init+0x0/0x12 returned 0 after 377 usecs
[    4.842858] calling  michael_mic_init+0x0/0x12 @ 1
[    4.847760] initcall michael_mic_init+0x0/0x12 returned 0 after 54 usecs
[    4.854507] calling  crc32c_mod_init+0x0/0x12 @ 1
[    4.859334] initcall crc32c_mod_init+0x0/0x12 returned 0 after 58 usecs
[    4.865999] calling  crypto_authenc_module_init+0x0/0x12 @ 1
[    4.871719] initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 1 usecs
[    4.879267] calling  krng_mod_init+0x0/0x12 @ 1
[    4.883878] alg: No test for stdrng (krng)
[    4.888040] initcall krng_mod_init+0x0/0x12 returned 0 after 4089 usecs
[    4.894712] calling  prng_mod_init+0x0/0x2a @ 1
[    4.899320] alg: No test for stdrng (ansi_cprng)
[    4.904010] initcall prng_mod_init+0x0/0x2a returned 0 after 4603 usecs
[    4.910675] calling  proc_genhd_init+0x0/0x3c @ 1
[    4.915443] initcall proc_genhd_init+0x0/0x3c returned 0 after 9 usecs
[    4.922020] calling  bsg_init+0x0/0x12f @ 1
[    4.926542] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    4.934008] initcall bsg_init+0x0/0x12f returned 0 after 7567 usecs
[    4.940331] calling  noop_init+0x0/0x14 @ 1
[    4.944563] io scheduler noop registered (default)
[    4.949406] initcall noop_init+0x0/0x14 returned 0 after 4729 usecs
[    4.955724] calling  libcrc32c_mod_init+0x0/0x2c @ 1
[    4.960737] initcall libcrc32c_mod_init+0x0/0x2c returned 0 after 3 usecs
[    4.967571] calling  dynamic_printk_init+0x0/0x101 @ 1
[    4.973492] initcall dynamic_printk_init+0x0/0x101 returned 0 after 719 usecs
[    4.980680] calling  pci_init+0x0/0x46 @ 1
[    4.984855] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.991170] pci 0000:00:1d.0: Performing full reset
[    4.996110] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    5.002428] pci 0000:00:1d.1: Performing full reset
[    5.007375] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    5.013685] pci 0000:00:1d.2: Performing full reset
[    5.018624] pci 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[    5.024938] pci 0000:00:1d.3: Performing full reset
[    5.029927] pci 0000:04:00.0: Boot video device
[    5.034517] initcall pci_init+0x0/0x46 returned 0 after 48524 usecs
[    5.040831] calling  pci_proc_init+0x0/0x7b @ 1
[    5.045531] initcall pci_proc_init+0x0/0x7b returned 0 after 120 usecs
[    5.052107] calling  pcie_portdrv_init+0x0/0x50 @ 1
[    5.057189] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    5.063842] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    5.070625] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    5.077381] initcall pcie_portdrv_init+0x0/0x50 returned 0 after 19864 usecs
[    5.084490] calling  aer_service_init+0x0/0x29 @ 1
[    5.089416] initcall aer_service_init+0x0/0x29 returned 0 after 83 usecs
[    5.096168] calling  pci_hotplug_init+0x0/0x51 @ 1
[    5.101044] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.106665] initcall pci_hotplug_init+0x0/0x51 returned 0 after 5487 usecs
[    5.113587] calling  pcied_init+0x0/0x82 @ 1
[    5.119378] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    5.126044] initcall pcied_init+0x0/0x82 returned 0 after 7947 usecs
[    5.132476] calling  acpiphp_init+0x0/0x65 @ 1
[    5.136969] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    5.155614] initcall acpiphp_init+0x0/0x65 returned -19 after 18207 usecs
[    5.162452] calling  shpcd_init+0x0/0x68 @ 1
[    5.166877] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.173632] initcall shpcd_init+0x0/0x68 returned 0 after 6695 usecs
[    5.180073] calling  pci_stub_init+0x0/0x25 @ 1
[    5.184747] initcall pci_stub_init+0x0/0x25 returned 0 after 89 usecs
[    5.191242] calling  mbp_init+0x0/0xee @ 1
[    5.195413] initcall mbp_init+0x0/0xee returned -19 after 2 usecs
[    5.201555] calling  pm2fb_init+0x0/0x132 @ 1
[    5.206054] initcall pm2fb_init+0x0/0x132 returned 0 after 86 usecs
[    5.212371] calling  rivafb_init+0x0/0x1a3 @ 1
[    5.216889] rivafb_setup START
[    5.220091] initcall rivafb_init+0x0/0x1a3 returned 0 after 3125 usecs
[    5.226670] calling  atyfb_init+0x0/0x1d0 @ 1
[    5.231185] initcall atyfb_init+0x0/0x1d0 returned 0 after 84 usecs
[    5.237504] calling  aty128fb_init+0x0/0x120 @ 1
[    5.242286] initcall aty128fb_init+0x0/0x120 returned 0 after 93 usecs
[    5.248867] calling  sisfb_init+0x0/0x825 @ 1
[    5.253389] initcall sisfb_init+0x0/0x825 returned 0 after 95 usecs
[    5.259708] calling  viafb_init+0x0/0x1252 @ 1
[    5.264219] VIA Graphics Intergration Chipset framebuffer 2.4 initializing
[    5.271196] I2C adapter driver [via_i2c] forgot to specify physical device
[    5.278213] i2c-adapter i2c-0: adapter [via_i2c] registered
[    5.283868] i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=1
[    5.290029] i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=1
[    5.376005] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    5.540006] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    5.704006] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    5.868005] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    5.874062] i2c-adapter i2c-0: Used 4 tries to write to client at 0x08: failed, timeout?
[    5.882216] i2c-adapter i2c-0: NAK from device addr 0x08 msg #0
[    5.968047] i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=1
[    5.974186] i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=1
[    6.060005] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    6.224005] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    6.388004] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    6.552005] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    6.558059] i2c-adapter i2c-0: Used 4 tries to write to client at 0x08: failed, timeout?
[    6.566214] i2c-adapter i2c-0: NAK from device addr 0x08 msg #0
[    6.652060] i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=1
[    6.658204] i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=1
[    6.744004] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    6.908005] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    7.072005] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    7.236005] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    7.242059] i2c-adapter i2c-0: Used 4 tries to write to client at 0x08: failed, timeout?
[    7.250214] i2c-adapter i2c-0: NAK from device addr 0x08 msg #0
[    7.336047] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[    7.342185] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[    7.428005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    7.592005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    7.756005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    7.920005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    7.926059] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[    7.934214] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[    8.020047] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[    8.026185] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[    8.112005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    8.276006] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    8.440005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    8.604005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    8.610058] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[    8.618213] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[    8.704047] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[    8.710192] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[    8.796005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    8.960004] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.124005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.288005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.294057] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[    9.302212] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[    9.388052] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[    9.394192] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[    9.480005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.644005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.808005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.972004] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.978057] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[    9.986212] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   10.072047] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[   10.078192] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[   10.164005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.328005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.492005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.656005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.662056] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   10.670212] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   10.756047] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[   10.762191] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[   10.848005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.012004] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.176005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.340005] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.346055] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   11.354211] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   11.440047] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[   11.446190] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[   11.532004] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   11.696005] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   11.860005] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.024004] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.030056] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   12.038211] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   12.124047] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[   12.130190] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[   12.216005] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.380005] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.544005] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.708005] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.714409] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   12.722564] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   12.808047] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[   12.814189] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[   12.900005] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   13.064005] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   13.228004] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   13.392005] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   13.398062] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   13.406218] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   13.492046] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[   13.498188] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[   13.584005] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   13.748005] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   13.912005] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   14.076005] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   14.082062] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   14.090217] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   14.176047] i2c-adapter i2c-0: master_xfer[0] W, addr=0x38, len=1
[   14.182187] i2c-adapter i2c-0: master_xfer[1] R, addr=0x38, len=1
[   14.268005] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   14.432005] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   14.596005] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   14.760005] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   14.766061] i2c-adapter i2c-0: Used 4 tries to write to client at 0x38: failed, timeout?
[   14.774217] i2c-adapter i2c-0: NAK from device addr 0x38 msg #0
[   14.860050] ioremap failed
[   14.862803] initcall viafb_init+0x0/0x1252 returned -1 after 9373618 usecs
[   14.869725] initcall viafb_init+0x0/0x1252 returned with error code -1 
[   14.876389] calling  tdfxfb_init+0x0/0x11e @ 1
[   14.880990] initcall tdfxfb_init+0x0/0x11e returned 0 after 99 usecs
[   14.887397] calling  imsttfb_init+0x0/0x131 @ 1
[   14.892073] initcall imsttfb_init+0x0/0x131 returned 0 after 88 usecs
[   14.898559] calling  vt8623fb_init+0x0/0x98 @ 1
[   14.903254] initcall vt8623fb_init+0x0/0x98 returned 0 after 97 usecs
[   14.909748] calling  s3fb_init+0x0/0xfe @ 1
[   14.914092] initcall s3fb_init+0x0/0xfe returned 0 after 93 usecs
[   14.920235] calling  hecubafb_init+0x0/0x12 @ 1
[   14.924918] initcall hecubafb_init+0x0/0x12 returned 0 after 84 usecs
[   14.931406] calling  tmiofb_init+0x0/0x6b @ 1
[   14.935912] initcall tmiofb_init+0x0/0x6b returned 0 after 79 usecs
[   14.942231] calling  mb862xxfb_init+0x0/0xb @ 1
[   14.946829] initcall mb862xxfb_init+0x0/0xb returned -19 after 0 usecs
[   14.953411] calling  acpi_reserve_resources+0x0/0xeb @ 1
[   14.958782] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 5 usecs
[   14.965970] calling  acpi_ac_init+0x0/0x28 @ 1
[   14.970577] initcall acpi_ac_init+0x0/0x28 returned 0 after 107 usecs
[   14.977071] calling  acpi_battery_init+0x0/0x28 @ 1
[   14.982108] initcall acpi_battery_init+0x0/0x28 returned 0 after 90 usecs
[   14.988944] calling  acpi_button_init+0x0/0x5e @ 1
[   14.993986] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[   15.001885] ACPI: Power Button (FF) [PWRF]
[   15.006206] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[   15.014883] ACPI: Power Button (CM) [PWRB]
[   15.019119] initcall acpi_button_init+0x0/0x5e returned 0 after 24723 usecs
[   15.026134] calling  acpi_fan_init+0x0/0x5e @ 1
[   15.030826] initcall acpi_fan_init+0x0/0x5e returned 0 after 94 usecs
[   15.037314] calling  irqrouter_init_sysfs+0x0/0x38 @ 1
[   15.042678] initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 157 usecs
[   15.049862] calling  acpi_processor_init+0x0/0xad @ 1
[   15.055933] processor ACPI_CPU:00: registered as cooling_device0
[   15.062000] ACPI: Processor [CPU1] (supports 8 throttling states)
[   15.068433] initcall acpi_processor_init+0x0/0xad returned 0 after 13137 usecs
[   15.075726] calling  rand_initialize+0x0/0x30 @ 1
[   15.080509] initcall rand_initialize+0x0/0x30 returned 0 after 13 usecs
[   15.087172] calling  tty_init+0x0/0xfa @ 1
[   15.128250] initcall tty_init+0x0/0xfa returned 0 after 36056 usecs
[   15.134578] calling  pty_init+0x0/0x3cb @ 1
[   15.139022] initcall pty_init+0x0/0x3cb returned 0 after 146 usecs
[   15.145258] calling  sysrq_init+0x0/0x25 @ 1
[   15.149620] initcall sysrq_init+0x0/0x25 returned 0 after 16 usecs
[   15.155847] calling  cy_init+0x0/0x16b @ 1
[   15.160000] Cyclades driver 2.5 (built Feb  8 2009 06:54:01)
[   15.165840] initcall cy_init+0x0/0x16b returned 0 after 5702 usecs
[   15.172072] calling  istallion_module_init+0x0/0x560 @ 1
[   15.177445] Stallion Intelligent Multiport Serial Driver: version 5.6.0
[   15.184682] initcall istallion_module_init+0x0/0x560 returned 0 after 7065 usecs
[   15.192144] calling  epca_module_init+0x0/0x501 @ 1
[   15.197086] DIGI epca driver version 1.3.0.1-LK2.6 loaded.
[   15.278321] initcall epca_module_init+0x0/0x501 returned 0 after 79324 usecs
[   15.285682] calling  specialix_init_module+0x0/0x45d @ 1
[   15.291336] sx: Specialix IO8+ driver v1.11, (c) R.E.Wolff 1997/1998.
[   15.297866] sx: derived from work (c) D.Gorodchanin 1994-1996.
[   15.303750] sx: DTR/RTS pin is always RTS.
[   15.319040] sx0: specialix IO8+ Board at 0x100 not found.
[   15.324514] sx1: specialix IO8+ Board at 0x180 not found.
[   15.330280] sx2: specialix IO8+ Board at 0x250 not found.
[   15.335985] sx3: specialix IO8+ Board at 0x260 not found.
[   15.351760] sx: No specialix IO8+ boards detected.
[   15.356624] initcall specialix_init_module+0x0/0x45d returned -5 after 63749 usecs
[   15.364495] initcall specialix_init_module+0x0/0x45d returned with error code -5 
[   15.372292] calling  isicom_init+0x0/0x21f @ 1
[   15.376954] initcall isicom_init+0x0/0x21f returned 0 after 150 usecs
[   15.383443] calling  synclink_init+0x0/0x294 @ 1
[   15.388217] SyncLink serial driver $Revision: 4.38 $
[   15.415174] SyncLink serial driver $Revision: 4.38 $, tty major#252
[   15.421749] initcall synclink_init+0x0/0x294 returned 0 after 32740 usecs
[   15.428830] calling  sx_init+0x0/0x120 @ 1
[   15.433262] initcall sx_init+0x0/0x120 returned 0 after 261 usecs
[   15.439405] calling  rio_init+0x0/0x12d6 @ 1
[   15.445805] initcall rio_init+0x0/0x12d6 returned -5 after 1962 usecs
[   15.452301] initcall rio_init+0x0/0x12d6 returned with error code -5 
[   15.458829] calling  raw_init+0x0/0xea @ 1
[   15.463192] initcall raw_init+0x0/0xea returned 0 after 210 usecs
[   15.469339] calling  applicom_init+0x0/0x4ff @ 1
[   15.474118] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[   15.481418] ac.o: No PCI boards found.
[   15.485223] ac.o: For an ISA board you must supply memory and irq parameters.
[   15.492410] initcall applicom_init+0x0/0x4ff returned -6 after 17860 usecs
[   15.499333] initcall applicom_init+0x0/0x4ff returned with error code -6 
[   15.506171] calling  hpet_init+0x0/0x6d @ 1
[   15.510656] initcall hpet_init+0x0/0x6d returned 0 after 240 usecs
[   15.516884] calling  nvram_init+0x0/0x94 @ 1
[   15.521357] Non-volatile memory driver v1.3
[   15.525595] initcall nvram_init+0x0/0x94 returned 0 after 4263 usecs
[   15.532096] calling  agp_init+0x0/0x38 @ 1
[   15.536243] Linux agpgart interface v0.103
[   15.540387] initcall agp_init+0x0/0x38 returned 0 after 4045 usecs
[   15.546618] calling  agp_intel_init+0x0/0x2c @ 1
[   15.551423] initcall agp_intel_init+0x0/0x2c returned 0 after 129 usecs
[   15.558085] calling  agp_sis_init+0x0/0x2c @ 1
[   15.562688] initcall agp_sis_init+0x0/0x2c returned 0 after 86 usecs
[   15.569091] calling  ipmi_init_msghandler_mod+0x0/0xd @ 1
[   15.574644] ipmi message handler version 39.2
[   15.579058] initcall ipmi_init_msghandler_mod+0x0/0xd returned 0 after 4390 usecs
[   15.586623] calling  init_ipmi_devintf+0x0/0x107 @ 1
[   15.591640] ipmi device interface
[   15.595091] initcall init_ipmi_devintf+0x0/0x107 returned 0 after 3368 usecs
[   15.602192] calling  init_ipmi_si+0x0/0x88b @ 1
[   15.606873] IPMI System Interface driver.
[   15.660196] ipmi_si: Unable to find any System Interface(s)
[   15.665821] initcall init_ipmi_si+0x0/0x88b returned -19 after 57647 usecs
[   15.672745] calling  hangcheck_init+0x0/0x93 @ 1
[   15.677415] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   15.686436] Hangcheck: Using get_cycles().
[   15.690581] initcall hangcheck_init+0x0/0x93 returned 0 after 12856 usecs
[   15.697417] calling  intelfb_init+0x0/0x230 @ 1
[   15.702002] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[   15.713623] intelfb: Version 0.9.6
[   15.717171] initcall intelfb_init+0x0/0x230 returned 0 after 14812 usecs
[   15.723921] calling  serial8250_init+0x0/0x136 @ 1
[   15.728786] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   15.735280] async_waiting @ 1
[   15.738299] async_continuing @ 1 after 0 usec
[   15.868096] async_waiting @ 1
[   15.871108] async_continuing @ 1 after 0 usec
[   16.000128] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   16.006968] initcall serial8250_init+0x0/0x136 returned 0 after 271661 usecs
[   16.014065] calling  parport_default_proc_register+0x0/0x20 @ 1
[   16.020041] initcall parport_default_proc_register+0x0/0x20 returned 0 after 4 usecs
[   16.027851] calling  parport_pc_init+0x0/0x41f @ 1
[   16.033042] parport_pc 00:07: reported by Plug and Play ACPI
[   16.038858] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[   16.144861] initcall parport_pc_init+0x0/0x41f returned 0 after 109543 usecs
[   16.151959] calling  floppy_init+0x0/0x125f @ 1
[   16.156619] Floppy drive(s): fd0 is 1.44M
[   16.179649] FDC 0 is a post-1991 82077
[   16.184662] initcall floppy_init+0x0/0x125f returned 0 after 27458 usecs
[   16.191409] calling  brd_init+0x0/0x1cc @ 1
[   16.199331] brd: module loaded
[   16.202481] initcall brd_init+0x0/0x1cc returned 0 after 6677 usecs
[   16.208796] calling  cpqarray_init+0x0/0x2c7 @ 1
[   16.213465] Compaq SMART2 Driver (v 2.6.0)
[   16.217802] initcall cpqarray_init+0x0/0x2c7 returned -19 after 4232 usecs
[   16.224725] calling  pkt_init+0x0/0x1cd @ 1
[   16.229658] initcall pkt_init+0x0/0x1cd returned 0 after 328 usecs
[   16.235887] calling  carm_init+0x0/0x1b @ 1
[   16.240867] initcall carm_init+0x0/0x1b returned 0 after 520 usecs
[   16.247103] calling  wm8400_module_init+0x0/0x38 @ 1
[   16.252235] i2c-core: driver [WM8400] registered
[   16.256907] initcall wm8400_module_init+0x0/0x38 returned 0 after 4647 usecs
[   16.264079] calling  pcf50633_init+0x0/0x1e @ 1
[   16.268745] i2c-core: driver [pcf50633] registered
[   16.273589] initcall pcf50633_init+0x0/0x1e returned 0 after 4808 usecs
[   16.280274] calling  e1000_init_module+0x0/0x70 @ 1
[   16.285199] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[   16.291343] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   16.297327] initcall e1000_init_module+0x0/0x70 returned 0 after 11842 usecs
[   16.304423] calling  ixgbe_init_module+0x0/0x5a @ 1
[   16.309385] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 1.3.30-k2
[   16.317283] ixgbe: Copyright (c) 1999-2007 Intel Corporation.
[   16.323178] initcall ixgbe_init_module+0x0/0x5a returned 0 after 13468 usecs
[   16.330275] calling  t1_init_module+0x0/0x1b @ 1
[   16.335049] initcall t1_init_module+0x0/0x1b returned 0 after 86 usecs
[   16.341630] calling  vcan_init_module+0x0/0x3a @ 1
[   16.346487] vcan: Virtual CAN interface driver
[   16.350982] initcall vcan_init_module+0x0/0x3a returned 0 after 4388 usecs
[   16.357904] calling  jme_init_module+0x0/0x30 @ 1
[   16.362662] jme: JMicron JMC250 gigabit ethernet driver version 1.0.3
[   16.369246] initcall jme_init_module+0x0/0x30 returned 0 after 6428 usecs
[   16.376088] calling  rr_init_module+0x0/0x1b @ 1
[   16.380861] initcall rr_init_module+0x0/0x1b returned 0 after 85 usecs
[   16.387441] calling  gem_init+0x0/0x1b @ 1
[   16.391695] initcall gem_init+0x0/0x1b returned 0 after 85 usecs
[   16.397754] calling  vortex_init+0x0/0xc3 @ 1
[   16.402268] initcall vortex_init+0x0/0xc3 returned 0 after 86 usecs
[   16.408588] calling  e100_init_module+0x0/0x5f @ 1
[   16.413446] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
[   16.419584] e100: Copyright(c) 1999-2006 Intel Corporation
[   16.425211] initcall e100_init_module+0x0/0x5f returned 0 after 11488 usecs
[   16.432222] calling  ns83820_init+0x0/0x29 @ 1
[   16.436732] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   16.443656] initcall ns83820_init+0x0/0x29 returned 0 after 6760 usecs
[   16.450231] calling  tg3_init+0x0/0x1b @ 1
[   16.454487] initcall tg3_init+0x0/0x1b returned 0 after 87 usecs
[   16.460545] calling  bnx2x_init+0x0/0x55 @ 1
[   16.465010] initcall bnx2x_init+0x0/0x55 returned 0 after 123 usecs
[   16.471325] calling  skge_init_module+0x0/0x1b @ 1
[   16.476266] initcall skge_init_module+0x0/0x1b returned 0 after 87 usecs
[   16.483017] calling  sky2_init_module+0x0/0x29 @ 1
[   16.487874] sky2 driver version 1.22
[   16.491540] sky2 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   16.498387] sky2 0000:02:00.0: setting latency timer to 64
[   16.503962] sky2 0000:02:00.0: Yukon-2 EC chip revision 2
[   16.541275] sky2 0000:02:00.0: Marvell Yukon 88E8053 Gigabit Ethernet Controller
[   16.548735]  Part Number: Yukon 88E8053
[   16.552617]  Engineering Level: Rev. 1.9
[   16.556586]  Manufacturer: Marvell
[   16.560324] sky2 eth0: addr 00:15:f2:e6:8e:6b
[   16.564821] initcall sky2_init_module+0x0/0x29 returned 0 after 75141 usecs
[   16.571846] calling  starfire_init+0x0/0x1c @ 1
[   16.576517] initcall starfire_init+0x0/0x1c returned 0 after 86 usecs
[   16.583004] calling  cicada_init+0x0/0x44 @ 1
[   16.587593] initcall cicada_init+0x0/0x44 returned 0 after 168 usecs
[   16.593995] calling  vsc82xx_init+0x0/0x44 @ 1
[   16.598678] initcall vsc82xx_init+0x0/0x44 returned 0 after 160 usecs
[   16.605166] calling  realtek_init+0x0/0x12 @ 1
[   16.609767] initcall realtek_init+0x0/0x12 returned 0 after 81 usecs
[   16.616172] calling  fixed_mdio_bus_init+0x0/0xce @ 1
[   16.621504] Fixed MDIO Bus: probed
[   16.624961] initcall fixed_mdio_bus_init+0x0/0xce returned 0 after 3573 usecs
[   16.632160] calling  ns_init+0x0/0x12 @ 1
[   16.636301] initcall ns_init+0x0/0x12 returned 0 after 80 usecs
[   16.642266] calling  sundance_init+0x0/0x21 @ 1
[   16.646957] initcall sundance_init+0x0/0x21 returned 0 after 86 usecs
[   16.653447] calling  net_olddevs_init+0x0/0xae @ 1
[   16.658427] initcall net_olddevs_init+0x0/0xae returned 0 after 118 usecs
[   16.665268] calling  init_nic+0x0/0x1b @ 1
[   16.669509] initcall init_nic+0x0/0x1b returned 0 after 88 usecs
[   16.675564] calling  ppp_init+0x0/0xa7 @ 1
[   16.679730] PPP generic driver version 2.4.2
[   16.684301] initcall ppp_init+0x0/0xa7 returned 0 after 4462 usecs
[   16.690531] calling  ppp_mppe_init+0x0/0x117 @ 1
[   16.695392] PPP MPPE Compression module registered
[   16.700239] initcall ppp_mppe_init+0x0/0x117 returned 0 after 4905 usecs
[   16.707013] calling  macvlan_init_module+0x0/0x56 @ 1
[   16.712116] initcall macvlan_init_module+0x0/0x56 returned 0 after 3 usecs
[   16.719037] calling  rtl8139_init_module+0x0/0x1b @ 1
[   16.724261] initcall rtl8139_init_module+0x0/0x1b returned 0 after 117 usecs
[   16.731361] calling  rio_init+0x0/0x1b @ 1
[   16.735624] initcall rio_init+0x0/0x1b returned 0 after 87 usecs
[   16.741682] calling  mlx4_init+0x0/0x79 @ 1
[   16.746068] initcall mlx4_init+0x0/0x79 returned 0 after 125 usecs
[   16.752299] calling  mlx4_en_init+0x0/0x17 @ 1
[   16.756813] initcall mlx4_en_init+0x0/0x17 returned 0 after 0 usecs
[   16.763132] calling  hdlc_module_init+0x0/0x45 @ 1
[   16.767977] HDLC support module revision 1.22
[   16.772389] initcall hdlc_module_init+0x0/0x45 returned 0 after 4307 usecs
[   16.779312] calling  mod_init+0x0/0x14 @ 1
[   16.783456] initcall mod_init+0x0/0x14 returned 0 after 0 usecs
[   16.789425] calling  fst_init+0x0/0x37 @ 1
[   16.793665] initcall fst_init+0x0/0x37 returned 0 after 92 usecs
[   16.799722] calling  kaweth_init+0x0/0x1b @ 1
[   16.804235] usbcore: registered new interface driver kaweth
[   16.809857] initcall kaweth_init+0x0/0x1b returned 0 after 5574 usecs
[   16.816361] calling  pegasus_init+0x0/0x18d @ 1
[   16.820938] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[   16.828568] usbcore: registered new interface driver pegasus
[   16.834280] initcall pegasus_init+0x0/0x18d returned 0 after 13028 usecs
[   16.841042] calling  ipw_init+0x0/0x8e @ 1
[   16.845187] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2km
[   16.852285] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   16.858173] initcall ipw_init+0x0/0x8e returned 0 after 12679 usecs
[   16.864489] calling  ieee80211_init+0x0/0x24 @ 1
[   16.869173] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   16.875832] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   16.884249] initcall ieee80211_init+0x0/0x24 returned 0 after 14721 usecs
[   16.891087] calling  airo_init_module+0x0/0xf4 @ 1
[   16.895940] airo(): Probing for PCI adapters
[   16.900361] airo(): Finished probing for PCI adapters
[   16.905466] initcall airo_init_module+0x0/0xf4 returned 0 after 9310 usecs
[   16.912403] calling  prism54_module_init+0x0/0x3c @ 1
[   16.917502] Loaded prism54 driver, version 1.2
[   16.922088] initcall prism54_module_init+0x0/0x3c returned 0 after 4477 usecs
[   16.929272] calling  init_netconsole+0x0/0x214 @ 1
[   16.934131] console [netcon0] enabled
[   16.937843] netconsole: network logging started
[   16.942420] initcall init_netconsole+0x0/0x214 returned 0 after 8095 usecs
[   16.949343] calling  efx_init_module+0x0/0xcb @ 1
[   16.954092] Solarflare NET driver v2.3
[   16.958035] initcall efx_init_module+0x0/0xcb returned 0 after 3848 usecs
[   16.964875] calling  dabusb_init+0x0/0xd2 @ 1
[   16.969383] usbcore: registered new interface driver dabusb
[   16.975006] dabusb: v1.54:DAB-USB Interface Driver for Linux (c)1999
[   16.981425] initcall dabusb_init+0x0/0xd2 returned 0 after 11841 usecs
[   16.988006] calling  spi_transport_init+0x0/0x30 @ 1
[   16.993186] initcall spi_transport_init+0x0/0x30 returned 0 after 157 usecs
[   17.000201] calling  fc_transport_init+0x0/0x4e @ 1
[   17.005461] initcall fc_transport_init+0x0/0x4e returned 0 after 309 usecs
[   17.012385] calling  iscsi_transport_init+0x0/0x153 @ 1
[   17.017683] Loading iSCSI transport class v2.0-870.
[   17.023059] initcall iscsi_transport_init+0x0/0x153 returned 0 after 5248 usecs
[   17.030440] calling  scsi_dh_init+0x0/0x42 @ 1
[   17.034977] initcall scsi_dh_init+0x0/0x42 returned 0 after 1 usecs
[   17.041298] calling  hp_sw_init+0x0/0x12 @ 1
[   17.045622] hp_sw: device handler registered
[   17.049937] initcall hp_sw_init+0x0/0x12 returned 0 after 4214 usecs
[   17.056342] calling  iscsi_sw_tcp_init+0x0/0x52 @ 1
[   17.061401] iscsi: registered transport (tcp)
[   17.065809] initcall iscsi_sw_tcp_init+0x0/0x52 returned 0 after 4427 usecs
[   17.072869] calling  BusLogic_init+0x0/0x1b3c @ 1
[   17.077684] initcall BusLogic_init+0x0/0x1b3c returned 0 after 53 usecs
[   17.084345] calling  ahc_linux_init+0x0/0x67 @ 1
[   17.089123] initcall ahc_linux_init+0x0/0x67 returned 0 after 102 usecs
[   17.095785] calling  ahd_linux_init+0x0/0x83 @ 1
[   17.100586] initcall ahd_linux_init+0x0/0x83 returned 0 after 107 usecs
[   17.107251] calling  aac_init+0x0/0x7f @ 1
[   17.111424] Adaptec aacraid driver 1.1-5[2456]-ms
[   17.116282] initcall aac_init+0x0/0x7f returned 0 after 4743 usecs
[   17.122513] calling  qla1280_init+0x0/0x1b @ 1
[   17.127124] initcall qla1280_init+0x0/0x1b returned 0 after 94 usecs
[   17.133529] calling  qla4xxx_module_init+0x0/0x14d @ 1
[   17.139039] iscsi: registered transport (qla4xxx)
[   17.143892] QLogic iSCSI HBA Driver
[   17.147445] initcall qla4xxx_module_init+0x0/0x14d returned 0 after 8503 usecs
[   17.154736] calling  lpfc_init+0x0/0xdf @ 1
[   17.158972] Emulex LightPulse Fibre Channel SCSI driver 8.3.0
[   17.164770] Copyright(c) 2004-2008 Emulex.  All rights reserved.
[   17.170930] initcall lpfc_init+0x0/0xdf returned 0 after 11675 usecs
[   17.177329] calling  dc390_module_init+0x0/0xa0 @ 1
[   17.182281] DC390: clustering now enabled by default. If you get problems load
[   17.189566]        with "disable_clustering=1" and report to maintainers
[   17.196415] initcall dc390_module_init+0x0/0xa0 returned 0 after 13800 usecs
[   17.203512] calling  mraid_mm_init+0x0/0x8c @ 1
[   17.208117] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[   17.215640] initcall mraid_mm_init+0x0/0x8c returned 0 after 7345 usecs
[   17.222302] calling  megasas_init+0x0/0x172 @ 1
[   17.227246] megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
[   17.233231] initcall megasas_init+0x0/0x172 returned 0 after 5843 usecs
[   17.239895] calling  gdth_init+0x0/0xf7 @ 1
[   17.244148] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[   17.250388] initcall gdth_init+0x0/0xf7 returned 0 after 6093 usecs
[   17.256708] calling  twa_init+0x0/0x30 @ 1
[   17.260872] 3ware 9000 Storage Controller device driver for Linux v2.26.02.011.
[   17.268354] initcall twa_init+0x0/0x30 returned 0 after 7305 usecs
[   17.274588] calling  ppa_driver_init+0x0/0x27 @ 1
[   17.279358] ppa: Version 2.07 (for Linux 2.4.x)
[   17.286107] initcall ppa_driver_init+0x0/0x27 returned 0 after 6591 usecs
[   17.292943] calling  imm_driver_init+0x0/0x27 @ 1
[   17.297699] imm: Version 2.05 (for Linux 2.4.0)
[   17.302618] initcall imm_driver_init+0x0/0x27 returned 0 after 4802 usecs
[   17.309454] calling  stex_init+0x0/0x33 @ 1
[   17.313689] stex: Promise SuperTrak EX Driver version: 3.6.0000.1
[   17.319926] initcall stex_init+0x0/0x33 returned 0 after 6089 usecs
[   17.326241] calling  init_st+0x0/0x1c8 @ 1
[   17.330404] st: Version 20081215, fixed bufsize 32768, s/g segs 256
[   17.336801] Driver 'st' needs updating - please use bus_type methods
[   17.343295] initcall init_st+0x0/0x1c8 returned 0 after 12587 usecs
[   17.349628] calling  init_osst+0x0/0x14b @ 1
[   17.353948] osst :I: Tape driver with OnStream support version 0.99.4
[   17.353949] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   17.367265] Driver 'osst' needs updating - please use bus_type methods
[   17.373935] initcall init_osst+0x0/0x14b returned 0 after 19517 usecs
[   17.380437] calling  init_sd+0x0/0x10d @ 1
[   17.384676] Driver 'sd' needs updating - please use bus_type methods
[   17.391158] initcall init_sd+0x0/0x10d returned 0 after 6418 usecs
[   17.397407] calling  init_sr+0x0/0x4e @ 1
[   17.401467] Driver 'sr' needs updating - please use bus_type methods
[   17.407955] initcall init_sr+0x0/0x4e returned 0 after 6335 usecs
[   17.414095] calling  init_ch_module+0x0/0xae @ 1
[   17.418786] SCSI Media Changer driver v0.25 
[   17.423190] Driver 'ch' needs updating - please use bus_type methods
[   17.429672] initcall init_ch_module+0x0/0xae returned 0 after 10629 usecs
[   17.436529] calling  ahci_init+0x0/0x1b @ 1
[   17.440870] initcall ahci_init+0x0/0x1b returned 0 after 105 usecs
[   17.447098] calling  k2_sata_init+0x0/0x1b @ 1
[   17.451700] initcall k2_sata_init+0x0/0x1b returned 0 after 88 usecs
[   17.458104] calling  piix_init+0x0/0x29 @ 1
[   17.462384] ata_piix 0000:00:1f.1: version 2.12
[   17.466986]   alloc irq_desc for 22 on cpu 0 node 0
[   17.470965]   alloc kstat_irqs on cpu 0 node 0
[   17.476412] IOAPIC[0]: Set routing entry (2-22 -> 0x59 -> IRQ 22 Mode:1 Active:1)
[   17.483966] ata_piix 0000:00:1f.1: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   17.491190] ata_piix 0000:00:1f.1: setting latency timer to 64
[   17.497163] scsi0 : ata_piix
[   17.500630] scsi1 : ata_piix
[   17.512401] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[   17.519411] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[   17.688305] ata1.00: unsupported CDB len
[   22.844294] ata1.00: unsupported CDB len
[   22.848267] ata1.00: revalidation failed (errno=-22)
[   22.853276] ata1.00: disabled
[   22.856299] async_waiting @ 1
[   22.859311] async_continuing @ 1 after 0 usec
[   22.863723] async_waiting @ 1
[   22.866744] async_continuing @ 1 after 0 usec
[   23.034136] async_waiting @ 1
[   23.037158] async_continuing @ 1 after 0 usec
[   23.041581]   alloc irq_desc for 23 on cpu 0 node 0
[   23.045557]   alloc kstat_irqs on cpu 0 node 0
[   23.051000] IOAPIC[0]: Set routing entry (2-23 -> 0x61 -> IRQ 23 Mode:1 Active:1)
[   23.058547] ata_piix 0000:00:1f.2: PCI INT B -> GSI 23 (level, low) -> IRQ 23
[   23.065733] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   23.071177] ata_piix 0000:00:1f.2: setting latency timer to 64
[   23.077127] scsi2 : ata_piix
[   23.080309] scsi3 : ata_piix
[   23.083441] ata3: SATA max UDMA/133 cmd 0x9800 ctl 0x9400 bmdma 0x8400 irq 23
[   23.090632] ata4: SATA max UDMA/133 cmd 0x9000 ctl 0x8800 bmdma 0x8408 irq 23
[   23.295428] ata3.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
[   23.301136] ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   23.370406] ata3.00: configured for UDMA/133
[   23.374728] async_waiting @ 1
[   23.377750] async_continuing @ 1 after 0 usec
[   23.382196] isa bounce pool size: 16 pages
[   23.386469] scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[   23.395026] sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[   23.402774] sd 2:0:0:0: [sda] Write Protect is off
[   23.407615] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   23.412796] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   23.422014] sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[   23.429759] sd 2:0:0:0: [sda] Write Protect is off
[   23.434603] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   23.439758] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   23.448870]  sda: sda1 sda2 sda3 sda4 < sda5 >
[   23.494219] sd 2:0:0:0: [sda] Attached SCSI disk
[   23.499254] async_waiting @ 1
[   23.502274] async_continuing @ 1 after 0 usec
[   23.670154] async_waiting @ 1
[   23.673169] async_continuing @ 1 after 0 usec
[   23.677685] initcall piix_init+0x0/0x29 returned 0 after 6069643 usecs
[   23.684266] calling  sil_init+0x0/0x1b @ 1
[   23.688532] initcall sil_init+0x0/0x1b returned 0 after 113 usecs
[   23.694674] calling  sil24_init+0x0/0x1b @ 1
[   23.699099] initcall sil24_init+0x0/0x1b returned 0 after 88 usecs
[   23.705333] calling  svia_init+0x0/0x1b @ 1
[   23.709681] initcall svia_init+0x0/0x1b returned 0 after 97 usecs
[   23.715828] calling  sis_init+0x0/0x1b @ 1
[   23.720094] initcall sis_init+0x0/0x1b returned 0 after 99 usecs
[   23.726150] calling  nv_init+0x0/0x1b @ 1
[   23.730326] initcall nv_init+0x0/0x1b returned 0 after 96 usecs
[   23.736298] calling  inic_init+0x0/0x1b @ 1
[   23.740640] initcall inic_init+0x0/0x1b returned 0 after 87 usecs
[   23.746785] calling  amd_init+0x0/0x1b @ 1
[   23.751039] initcall amd_init+0x0/0x1b returned 0 after 87 usecs
[   23.757099] calling  artop_init+0x0/0x1b @ 1
[   23.761526] initcall artop_init+0x0/0x1b returned 0 after 87 usecs
[   23.767758] calling  cmd64x_init+0x0/0x1b @ 1
[   23.772272] initcall cmd64x_init+0x0/0x1b returned 0 after 86 usecs
[   23.778591] calling  hpt3x2n_init+0x0/0x1b @ 1
[   23.783195] initcall hpt3x2n_init+0x0/0x1b returned 0 after 90 usecs
[   23.789599] calling  it821x_init+0x0/0x1b @ 1
[   23.794056]   alloc irq_desc for 20 on cpu 0 node 0
[   23.798006]   alloc kstat_irqs on cpu 0 node 0
[   23.803476] IOAPIC[0]: Set routing entry (2-20 -> 0x69 -> IRQ 20 Mode:1 Active:1)
[   23.811024] pata_it821x 0000:01:03.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   23.818486] pata_it821x: controller in pass through mode.
[   23.823965] pata_it821x 0000:01:03.0: setting latency timer to 64
[   23.830198] scsi4 : pata_it821x
[   23.833648] scsi5 : pata_it821x
[   23.837057] ata5: PATA max UDMA/133 cmd 0xb800 ctl 0xb400 bmdma 0xa400 irq 20
[   23.844241] ata6: PATA max UDMA/133 cmd 0xb000 ctl 0xa800 bmdma 0xa408 irq 20
[   24.014173] async_waiting @ 1
[   24.017193] async_continuing @ 1 after 0 usec
[   24.021597] async_waiting @ 1
[   24.024620] async_continuing @ 1 after 0 usec
[   24.194169] async_waiting @ 1
[   24.197192] async_continuing @ 1 after 0 usec
[   24.201691] initcall it821x_init+0x0/0x1b returned 0 after 398112 usecs
[   24.208355] calling  ninja32_init+0x0/0x1b @ 1
[   24.212947] initcall ninja32_init+0x0/0x1b returned 0 after 90 usecs
[   24.219353] calling  ns87415_init+0x0/0x1b @ 1
[   24.223955] initcall ns87415_init+0x0/0x1b returned 0 after 91 usecs
[   24.230359] calling  opti_init+0x0/0x1b @ 1
[   24.234697] initcall opti_init+0x0/0x1b returned 0 after 86 usecs
[   24.240838] calling  mpiix_init+0x0/0x1b @ 1
[   24.245274] initcall mpiix_init+0x0/0x1b returned 0 after 97 usecs
[   24.251506] calling  oldpiix_init+0x0/0x1b @ 1
[   24.256110] initcall oldpiix_init+0x0/0x1b returned 0 after 87 usecs
[   24.262513] calling  rz1000_init+0x0/0x1b @ 1
[   24.267027] initcall rz1000_init+0x0/0x1b returned 0 after 87 usecs
[   24.273346] calling  sc1200_init+0x0/0x1b @ 1
[   24.277861] initcall sc1200_init+0x0/0x1b returned 0 after 87 usecs
[   24.284180] calling  via_init+0x0/0x1b @ 1
[   24.288436] initcall via_init+0x0/0x1b returned 0 after 90 usecs
[   24.294492] calling  sis_init+0x0/0x1b @ 1
[   24.298747] initcall sis_init+0x0/0x1b returned 0 after 87 usecs
[   24.304806] calling  triflex_init+0x0/0x1f @ 1
[   24.309407] initcall triflex_init+0x0/0x1f returned 0 after 87 usecs
[   24.315813] calling  fw_core_init+0x0/0xbe @ 1
[   24.320423] initcall fw_core_init+0x0/0xbe returned 0 after 97 usecs
[   24.326827] calling  cdrom_init+0x0/0x77 @ 1
[   24.331167] initcall cdrom_init+0x0/0x77 returned 0 after 9 usecs
[   24.337315] calling  gpio_vbus_init+0x0/0x19 @ 1
[   24.342156] initcall gpio_vbus_init+0x0/0x19 returned -19 after 165 usecs
[   24.348998] calling  mon_init+0x0/0x105 @ 1
[   24.353510] initcall mon_init+0x0/0x105 returned 0 after 255 usecs
[   24.359744] calling  ehci_hcd_init+0x0/0xe9 @ 1
[   24.364350] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   24.370923] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[   24.377012] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   24.384216] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   24.390104] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   24.395512] drivers/usb/core/inode.c: creating file 'devices'
[   24.401318] drivers/usb/core/inode.c: creating file '001'
[   24.406926] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   24.414396] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
[   24.423780] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[   24.432136] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   24.444950] ehci_hcd 0000:00:1d.7: debug port 1
[   24.449533] ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
[   24.456453] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[   24.462251] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xd7cff800
[   24.467966] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   24.480771] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[   24.500010] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   24.505849] usb usb1: default language 0x0409
[   24.510277] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   24.517113] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   24.524400] usb usb1: Product: EHCI Host Controller
[   24.529323] usb usb1: Manufacturer: Linux 2.6.29-rc3-00697-gae1a25d ehci_hcd
[   24.536421] usb usb1: SerialNumber: 0000:00:1d.7
[   24.541194] usb usb1: uevent
[   24.544207] usb usb1: usb_probe_device
[   24.548010] usb usb1: configuration #1 chosen from 1 choice
[   24.553652] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   24.559486] usb 1-0:1.0: uevent
[   24.562763] hub 1-0:1.0: usb_probe_interface
[   24.567084] hub 1-0:1.0: usb_probe_interface - got id
[   24.572191] hub 1-0:1.0: USB hub found
[   24.576007] hub 1-0:1.0: 8 ports detected
[   24.580067] hub 1-0:1.0: standalone hub
[   24.583941] hub 1-0:1.0: no power switching (usb 1.0)
[   24.589045] hub 1-0:1.0: individual port over-current protection
[   24.595094] hub 1-0:1.0: power on to power good time: 20ms
[   24.600644] hub 1-0:1.0: local power source is good
[   24.605574] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   24.612772] drivers/usb/core/inode.c: creating file '001'
[   24.618461] initcall ehci_hcd_init+0x0/0xe9 returned 0 after 248152 usecs
[   24.625312] calling  oxu_module_init+0x0/0x12 @ 1
[   24.630158] initcall oxu_module_init+0x0/0x12 returned 0 after 89 usecs
[   24.636826] calling  ohci_hcd_mod_init+0x0/0xb8 @ 1
[   24.641777] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   24.648006] ohci_hcd: block sizes: ed 80 td 96
[   24.652603] initcall ohci_hcd_mod_init+0x0/0xb8 returned 0 after 10570 usecs
[   24.659698] calling  uhci_hcd_init+0x0/0x10a @ 1
[   24.664398] uhci_hcd: USB Universal Host Controller Interface driver
[   24.671004] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   24.678199] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   24.684100] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   24.689481] drivers/usb/core/inode.c: creating file '002'
[   24.695068] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   24.702552] uhci_hcd 0000:00:1d.0: detected 2 ports
[   24.707486] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[   24.714237] uhci_hcd 0000:00:1d.0: Performing full reset
[   24.719612] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[   24.725413] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00007000
[   24.731260] usb usb2: default language 0x0409
[   24.735687] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   24.742524] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   24.749812] usb usb2: Product: UHCI Host Controller
[   24.754734] usb usb2: Manufacturer: Linux 2.6.29-rc3-00697-gae1a25d uhci_hcd
[   24.761832] usb usb2: SerialNumber: 0000:00:1d.0
[   24.766572] usb usb2: uevent
[   24.769607] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
[   24.775163] usb usb2: usb_probe_device
[   24.778981] usb usb2: configuration #1 chosen from 1 choice
[   24.784611] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   24.790436] usb 2-0:1.0: uevent
[   24.793713] hub 2-0:1.0: usb_probe_interface
[   24.798034] hub 2-0:1.0: usb_probe_interface - got id
[   24.803162] hub 2-0:1.0: USB hub found
[   24.806971] hub 2-0:1.0: 2 ports detected
[   24.811034] hub 2-0:1.0: standalone hub
[   24.814915] hub 2-0:1.0: no power switching (usb 1.0)
[   24.820012] hub 2-0:1.0: individual port over-current protection
[   24.826071] hub 2-0:1.0: power on to power good time: 2ms
[   24.831528] hub 2-0:1.0: local power source is good
[   24.836454] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   24.843518] drivers/usb/core/inode.c: creating file '001'
[   24.849145]   alloc irq_desc for 17 on cpu 0 node 0
[   24.852966]   alloc kstat_irqs on cpu 0 node 0
[   24.858578] IOAPIC[0]: Set routing entry (2-17 -> 0x71 -> IRQ 17 Mode:1 Active:1)
[   24.866129] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   24.873318] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   24.879197] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   24.884583] drivers/usb/core/inode.c: creating file '003'
[   24.890162] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   24.897646] uhci_hcd 0000:00:1d.1: detected 2 ports
[   24.902574] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[   24.909322] uhci_hcd 0000:00:1d.1: Performing full reset
[   24.914689] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[   24.920502] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00007400
[   24.926357] usb usb3: default language 0x0409
[   24.930786] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   24.937620] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   24.944907] usb usb3: Product: UHCI Host Controller
[   24.949830] usb usb3: Manufacturer: Linux 2.6.29-rc3-00697-gae1a25d uhci_hcd
[   24.956934] usb usb3: SerialNumber: 0000:00:1d.1
[   24.961673] usb usb3: uevent
[   24.964712] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   24.970264] usb usb3: usb_probe_device
[   24.974086] usb usb3: configuration #1 chosen from 1 choice
[   24.979715] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   24.985545] usb 3-0:1.0: uevent
[   24.988814] hub 3-0:1.0: usb_probe_interface
[   24.993137] hub 3-0:1.0: usb_probe_interface - got id
[   24.998256] hub 3-0:1.0: USB hub found
[   25.002066] hub 3-0:1.0: 2 ports detected
[   25.006129] hub 3-0:1.0: standalone hub
[   25.010010] hub 3-0:1.0: no power switching (usb 1.0)
[   25.015107] hub 3-0:1.0: individual port over-current protection
[   25.021157] hub 3-0:1.0: power on to power good time: 2ms
[   25.026616] hub 3-0:1.0: local power source is good
[   25.031540] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   25.038608] drivers/usb/core/inode.c: creating file '001'
[   25.044216]   alloc irq_desc for 18 on cpu 0 node 0
[   25.048052]   alloc kstat_irqs on cpu 0 node 0
[   25.053649] IOAPIC[0]: Set routing entry (2-18 -> 0x79 -> IRQ 18 Mode:1 Active:1)
[   25.061199] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   25.068387] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   25.074267] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   25.079649] drivers/usb/core/inode.c: creating file '004'
[   25.085231] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   25.092714] uhci_hcd 0000:00:1d.2: detected 2 ports
[   25.097642] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[   25.104391] uhci_hcd 0000:00:1d.2: Performing full reset
[   25.109757] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[   25.115569] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00007800
[   25.121420] usb usb4: default language 0x0409
[   25.125842] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   25.132680] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   25.139968] usb usb4: Product: UHCI Host Controller
[   25.144891] usb usb4: Manufacturer: Linux 2.6.29-rc3-00697-gae1a25d uhci_hcd
[   25.151988] usb usb4: SerialNumber: 0000:00:1d.2
[   25.156732] usb usb4: uevent
[   25.159745] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   25.165300] usb usb4: usb_probe_device
[   25.169121] usb usb4: configuration #1 chosen from 1 choice
[   25.174750] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   25.180576] usb 4-0:1.0: uevent
[   25.183840] hub 4-0:1.0: usb_probe_interface
[   25.188163] hub 4-0:1.0: usb_probe_interface - got id
[   25.193282] hub 4-0:1.0: USB hub found
[   25.197092] hub 4-0:1.0: 2 ports detected
[   25.201168] hub 4-0:1.0: standalone hub
[   25.205054] hub 4-0:1.0: no power switching (usb 1.0)
[   25.210149] hub 4-0:1.0: individual port over-current protection
[   25.216200] hub 4-0:1.0: power on to power good time: 2ms
[   25.221661] hub 4-0:1.0: local power source is good
[   25.226592] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   25.233665] drivers/usb/core/inode.c: creating file '001'
[   25.239273] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   25.246479] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   25.252360] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   25.257745] drivers/usb/core/inode.c: creating file '005'
[   25.263327] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   25.270813] uhci_hcd 0000:00:1d.3: detected 2 ports
[   25.275742] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[   25.282491] uhci_hcd 0000:00:1d.3: Performing full reset
[   25.287858] uhci_hcd 0000:00:1d.3: supports USB remote wakeup
[   25.293661] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00008000
[   25.299506] usb usb5: default language 0x0409
[   25.303935] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   25.310771] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   25.318059] usb usb5: Product: UHCI Host Controller
[   25.322981] usb usb5: Manufacturer: Linux 2.6.29-rc3-00697-gae1a25d uhci_hcd
[   25.330079] usb usb5: SerialNumber: 0000:00:1d.3
[   25.334816] usb usb5: uevent
[   25.337833] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   25.343382] usb usb5: usb_probe_device
[   25.347550] usb usb5: configuration #1 chosen from 1 choice
[   25.353177] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[   25.359008] usb 5-0:1.0: uevent
[   25.362278] hub 5-0:1.0: usb_probe_interface
[   25.366601] hub 5-0:1.0: usb_probe_interface - got id
[   25.371722] hub 5-0:1.0: USB hub found
[   25.375529] hub 5-0:1.0: 2 ports detected
[   25.379593] hub 5-0:1.0: standalone hub
[   25.383474] hub 5-0:1.0: no power switching (usb 1.0)
[   25.388570] hub 5-0:1.0: individual port over-current protection
[   25.394621] hub 5-0:1.0: power on to power good time: 2ms
[   25.400078] hub 5-0:1.0: local power source is good
[   25.405005] hub 5-0:1.0: trying to enable port power on non-switchable hub
[   25.412075] drivers/usb/core/inode.c: creating file '001'
[   25.417794] initcall uhci_hcd_init+0x0/0x10a returned 0 after 735734 usecs
[   25.424739] calling  sl811h_init+0x0/0x42 @ 1
[   25.429149] sl811: driver sl811-hcd, 19 May 2005
[   25.433906] initcall sl811h_init+0x0/0x42 returned 0 after 4644 usecs
[   25.440399] calling  acm_init+0x0/0x13f @ 1
[   25.444749] usbcore: registered new interface driver cdc_acm
[   25.450488] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[   25.459110] initcall acm_init+0x0/0x13f returned 0 after 14118 usecs
[   25.465516] calling  usb_stor_init+0x0/0x55 @ 1
[   25.470099] Initializing USB Mass Storage driver...
[   25.475135] usbcore: registered new interface driver usb-storage
[   25.481194] USB Mass Storage support registered.
[   25.485880] initcall usb_stor_init+0x0/0x55 returned 0 after 15409 usecs
[   25.492634] calling  usb_usual_init+0x0/0x41 @ 1
[   25.497406] usbcore: registered new interface driver libusual
[   25.503212] initcall usb_usual_init+0x0/0x41 returned 0 after 5769 usecs
[   25.509984] calling  usb_mdc800_init+0x0/0x26f @ 1
[   25.514932] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   25.520480] usbcore: registered new interface driver mdc800
[   25.526117] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[   25.533844] initcall usb_mdc800_init+0x0/0x26f returned 0 after 18568 usecs
[   25.540854] calling  adu_init+0x0/0x9d @ 1
[   25.544997] drivers/usb/misc/adutux.c :  adu_init : enter 
[   25.550625] usbcore: registered new interface driver adutux
[   25.556247] adutux adutux (see www.ontrak.net) v0.0.13
[   25.561450] adutux is an experimental driver. Use at your own risk
[   25.567677] drivers/usb/misc/adutux.c :  adu_init : leave, return value 0 
[   25.574604] initcall adu_init+0x0/0x9d returned 0 after 28912 usecs
[   25.580920] calling  emi62_init+0x0/0x3d @ 1
[   25.585321] usbcore: registered new interface driver emi62 - firmware loader
[   25.592425] initcall emi62_init+0x0/0x3d returned 0 after 7018 usecs
[   25.598840] calling  usb_idmouse_init+0x0/0x4d @ 1
[   25.603678] idmouse: 0.6:Siemens ID Mouse FingerTIP Sensor Driver
[   25.609897] usbcore: registered new interface driver idmouse
[   25.615608] initcall usb_idmouse_init+0x0/0x4d returned 0 after 11648 usecs
[   25.622629] calling  ld_usb_init+0x0/0x3f @ 1
[   25.627131] usbcore: registered new interface driver ldusb
[   25.632672] initcall ld_usb_init+0x0/0x3f returned 0 after 5502 usecs
[   25.639174] calling  usbtest_init+0x0/0x41 @ 1
[   25.643757] usbcore: registered new interface driver usbtest
[   25.649468] initcall usbtest_init+0x0/0x41 returned 0 after 5664 usecs
[   25.656057] calling  tv_init+0x0/0x4d @ 1
[   25.660199] usbcore: registered new interface driver trancevibrator
[   25.666513] trancevibrator: v1.1:PlayStation 2 Trance Vibrator driver
[   25.673018] initcall tv_init+0x0/0x4d returned 0 after 12598 usecs
[   25.679244] calling  uss720_init+0x0/0x67 @ 1
[   25.683745] usbcore: registered new interface driver uss720
[   25.689367] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[   25.698772] uss720: NOTE: this is a special purpose driver to allow nonstandard
[   25.706143] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[   25.713432] uss720: If you just want to connect to a printer, use usblp instead
[   25.720810] initcall uss720_init+0x0/0x67 returned 0 after 36283 usecs
[   25.727387] calling  usb_sevseg_init+0x0/0x3f @ 1
[   25.732237] usbcore: registered new interface driver usbsevseg
[   25.738119] initcall usb_sevseg_init+0x0/0x3f returned 0 after 5833 usecs
[   25.744967] calling  vstusb_init+0x0/0x46 @ 1
[   25.749458] usbcore: registered new interface driver vstusb
[   25.755081] initcall vstusb_init+0x0/0x46 returned 0 after 5571 usecs
[   25.761582] calling  usb_sisusb_init+0x0/0x1e @ 1
[   25.766418] usbcore: registered new interface driver sisusb
[   25.772041] initcall usb_sisusb_init+0x0/0x1e returned 0 after 5571 usecs
[   25.778890] calling  i8042_init+0x0/0x413 @ 1
[   25.783652] PNP: No PS/2 controller found. Probing ports directly.
[   25.792234] serio: i8042 KBD port at 0x60,0x64 irq 1
[   25.797252] serio: i8042 AUX port at 0x60,0x64 irq 12
[   25.802358] initcall i8042_init+0x0/0x413 returned 0 after 18613 usecs
[   25.808932] calling  serio_raw_init+0x0/0x1d @ 1
[   25.813823] initcall serio_raw_init+0x0/0x1d returned 0 after 213 usecs
[   25.820486] calling  l4_init+0x0/0x3e0 @ 1
[   25.824684] initcall l4_init+0x0/0x3e0 returned -19 after 8 usecs
[   25.830823] calling  ns558_init+0x0/0x360 @ 1
[   25.848215] initcall ns558_init+0x0/0x360 returned 0 after 12674 usecs
[   25.854795] calling  mousedev_init+0x0/0x92 @ 1
[   25.859647] mice: PS/2 mouse device common for all mice
[   25.864929] initcall mousedev_init+0x0/0x92 returned 0 after 5417 usecs
[   25.871618] calling  atkbd_init+0x0/0x27 @ 1
[   25.876040] initcall atkbd_init+0x0/0x27 returned 0 after 94 usecs
[   25.882298] calling  lkkbd_init+0x0/0x1b @ 1
[   25.886733] initcall lkkbd_init+0x0/0x1b returned 0 after 108 usecs
[   25.893051] calling  xtkbd_init+0x0/0x1d @ 1
[   25.897482] initcall xtkbd_init+0x0/0x1d returned 0 after 89 usecs
[   25.903710] calling  atp_init+0x0/0x1b @ 1
[   25.908127] usbcore: registered new interface driver appletouch
[   25.914109] initcall atp_init+0x0/0x1b returned 0 after 6083 usecs
[   25.920347] calling  sermouse_init+0x0/0x25 @ 1
[   25.925074] initcall sermouse_init+0x0/0x25 returned 0 after 142 usecs
[   25.931652] calling  gpio_mouse_init+0x0/0x19 @ 1
[   25.936616] initcall gpio_mouse_init+0x0/0x19 returned -19 after 180 usecs
[   25.943543] calling  gf2k_init+0x0/0x1b @ 1
[   25.947787] usb usb2: suspend_rh (auto-stop)
[   25.952239] initcall gf2k_init+0x0/0x1b returned 0 after 86 usecs
[   25.958381] calling  grip_init+0x0/0x1b @ 1
[   25.962731] initcall grip_init+0x0/0x1b returned 0 after 87 usecs
[   25.968877] calling  guillemot_init+0x0/0x1b @ 1
[   25.973650] initcall guillemot_init+0x0/0x1b returned 0 after 86 usecs
[   25.980229] calling  magellan_init+0x0/0x1b @ 1
[   25.984923] initcall magellan_init+0x0/0x1b returned 0 after 91 usecs
[   25.991417] calling  spaceorb_init+0x0/0x1b @ 1
[   25.996118] initcall spaceorb_init+0x0/0x1b returned 0 after 95 usecs
[   26.002608] calling  twidjoy_init+0x0/0x1b @ 1
[   26.007209] initcall twidjoy_init+0x0/0x1b returned 0 after 87 usecs
[   26.013614] calling  ati_remote_init+0x0/0x4d @ 1
[   26.018479] usbcore: registered new interface driver ati_remote
[   26.024448] ati_remote: 2.2.1:ATI/X10 RF USB Remote Control
[   26.030085] initcall ati_remote_init+0x0/0x4d returned 0 after 11425 usecs
[   26.037014] calling  ati_remote2_init+0x0/0x4d @ 1
[   26.041957] usbcore: registered new interface driver ati_remote2
[   26.048012] ati_remote2: ATI/Philips USB RF remote driver 0.3
[   26.053824] initcall ati_remote2_init+0x0/0x4d returned 0 after 11684 usecs
[   26.060838] calling  usb_keyspan_init+0x0/0x3f @ 1
[   26.065780] usbcore: registered new interface driver keyspan_remote
[   26.072099] initcall usb_keyspan_init+0x0/0x3f returned 0 after 6266 usecs
[   26.079035] calling  yealink_dev_init+0x0/0x3d @ 1
[   26.083957] usbcore: registered new interface driver yealink
[   26.089663] yealink: yld-20051230:Yealink phone driver
[   26.094868] initcall yealink_dev_init+0x0/0x3d returned 0 after 10735 usecs
[   26.101883] calling  pcf50633_input_init+0x0/0x1f @ 1
[   26.107072] initcall pcf50633_input_init+0x0/0x1f returned 0 after 81 usecs
[   26.114086] calling  i2o_iop_init+0x0/0x62 @ 1
[   26.118596] I2O subsystem v1.325
[   26.121875] i2o: max drivers = 8
[   26.125476] initcall i2o_iop_init+0x0/0x62 returned 0 after 6716 usecs
[   26.132052] calling  i2o_bus_init+0x0/0x49 @ 1
[   26.136561] I2O Bus Adapter OSM v1.317
[   26.140445] initcall i2o_bus_init+0x0/0x49 returned 0 after 3790 usecs
[   26.147019] calling  i2o_block_init+0x0/0x128 @ 1
[   26.151806] I2O Block Device OSM v1.325
[   26.156322] initcall i2o_block_init+0x0/0x128 returned 0 after 4407 usecs
[   26.163170] calling  ds1742_init+0x0/0x12 @ 1
[   26.167660] initcall ds1742_init+0x0/0x12 returned 0 after 81 usecs
[   26.173982] calling  fm3130_init+0x0/0x14 @ 1
[   26.178494] i2c-core: driver [rtc-fm3130] registered
[   26.183517] initcall fm3130_init+0x0/0x14 returned 0 after 4988 usecs
[   26.190029] calling  isl1208_init+0x0/0x14 @ 1
[   26.194525] usb usb3: suspend_rh (auto-stop)
[   26.198956] i2c-core: driver [rtc-isl1208] registered
[   26.204057] initcall isl1208_init+0x0/0x14 returned 0 after 5064 usecs
[   26.210647] calling  m41t80_rtc_init+0x0/0x14 @ 1
[   26.215479] i2c-core: driver [rtc-m41t80] registered
[   26.220497] initcall m41t80_rtc_init+0x0/0x14 returned 0 after 4978 usecs
[   26.227348] calling  m48t59_rtc_init+0x0/0x12 @ 1
[   26.232184] initcall m48t59_rtc_init+0x0/0x12 returned 0 after 81 usecs
[   26.238852] calling  m48t86_rtc_init+0x0/0x12 @ 1
[   26.243711] initcall m48t86_rtc_init+0x0/0x12 returned 0 after 86 usecs
[   26.250379] calling  bq4802_init+0x0/0x12 @ 1
[   26.254910] initcall bq4802_init+0x0/0x12 returned 0 after 104 usecs
[   26.261316] calling  max6900_init+0x0/0x14 @ 1
[   26.265918] i2c-core: driver [rtc-max6900] registered
[   26.271022] initcall max6900_init+0x0/0x14 returned 0 after 5075 usecs
[   26.277613] calling  rx8581_init+0x0/0x14 @ 1
[   26.282109] i2c-core: driver [rtc-rx8581] registered
[   26.287126] initcall rx8581_init+0x0/0x14 returned 0 after 4985 usecs
[   26.293629] calling  s35390a_rtc_init+0x0/0x14 @ 1
[   26.298559] i2c-core: driver [rtc-s35390a] registered
[   26.303661] initcall s35390a_rtc_init+0x0/0x14 returned 0 after 5069 usecs
[   26.310598] calling  v3020_init+0x0/0x12 @ 1
[   26.315002] initcall v3020_init+0x0/0x12 returned 0 after 80 usecs
[   26.321237] calling  pcf50633_rtc_init+0x0/0x12 @ 1
[   26.326264] initcall pcf50633_rtc_init+0x0/0x12 returned 0 after 80 usecs
[   26.333101] calling  i2c_dev_init+0x0/0xac @ 1
[   26.337956] i2c /dev entries driver
[   26.341670] i2c-core: driver [dev_driver] registered
[   26.346847] i2c-dev: adapter [via_i2c] registered as minor 0
[   26.352573] initcall i2c_dev_init+0x0/0xac returned 0 after 14271 usecs
[   26.359239] calling  i2c_amd8111_init+0x0/0x1b @ 1
[   26.364190] initcall i2c_amd8111_init+0x0/0x1b returned 0 after 102 usecs
[   26.371027] calling  i2c_sch_init+0x0/0x1b @ 1
[   26.375637] initcall i2c_sch_init+0x0/0x1b returned 0 after 88 usecs
[   26.382042] calling  i2c_piix4_init+0x0/0x1b @ 1
[   26.386827] initcall i2c_piix4_init+0x0/0x1b returned 0 after 89 usecs
[   26.393404] calling  i2c_sis96x_init+0x0/0x1b @ 1
[   26.398268] initcall i2c_sis96x_init+0x0/0x1b returned 0 after 87 usecs
[   26.404930] calling  i2c_vt586b_init+0x0/0x1b @ 1
[   26.409791] initcall i2c_vt586b_init+0x0/0x1b returned 0 after 87 usecs
[   26.416457] calling  ocores_i2c_init+0x0/0x12 @ 1
[   26.421317] initcall ocores_i2c_init+0x0/0x12 returned 0 after 85 usecs
[   26.427983] calling  usb_i2c_tiny_usb_init+0x0/0x1b @ 1
[   26.433363] usbcore: registered new interface driver i2c-tiny-usb
[   26.439513] initcall usb_i2c_tiny_usb_init+0x0/0x1b returned 0 after 6092 usecs
[   26.446890] usb usb4: suspend_rh (auto-stop)
[   26.451225] usb usb5: suspend_rh (auto-stop)
[   26.455568] calling  i2c_voodoo3_init+0x0/0x1b @ 1
[   26.460504] initcall i2c_voodoo3_init+0x0/0x1b returned 0 after 86 usecs
[   26.467252] calling  ds1682_init+0x0/0x14 @ 1
[   26.471757] i2c-core: driver [ds1682] registered
[   26.476423] initcall ds1682_init+0x0/0x14 returned 0 after 4635 usecs
[   26.482925] calling  max6875_init+0x0/0x14 @ 1
[   26.487504] i2c-core: driver [max6875] registered
[   26.492263] initcall max6875_init+0x0/0x14 returned 0 after 4729 usecs
[   26.498855] calling  pcf8574_init+0x0/0x14 @ 1
[   26.503428] i2c-core: driver [pcf8574] registered
[   26.508191] initcall pcf8574_init+0x0/0x14 returned 0 after 4729 usecs
[   26.514784] calling  pcf8591_init+0x0/0x46 @ 1
[   26.519362] i2c-core: driver [pcf8591] registered
[   26.524121] initcall pcf8591_init+0x0/0x46 returned 0 after 4729 usecs
[   26.530713] calling  sensors_w83792d_init+0x0/0x14 @ 1
[   26.535981] i2c-core: driver [w83792d] registered
[   26.540743] initcall sensors_w83792d_init+0x0/0x14 returned 0 after 4727 usecs
[   26.548046] calling  sensors_w83781d_init+0x0/0x18 @ 1
[   26.553315] i2c-core: driver [w83781d] registered
[   26.558077] initcall sensors_w83781d_init+0x0/0x18 returned 0 after 4728 usecs
[   26.565380] calling  abituguru_init+0x0/0x1b2 @ 1
[   26.570136] initcall abituguru_init+0x0/0x1b2 returned -19 after 0 usecs
[   26.576885] calling  ad7418_init+0x0/0x14 @ 1
[   26.581369] i2c-core: driver [ad7418] registered
[   26.586039] initcall ad7418_init+0x0/0x14 returned 0 after 4639 usecs
[   26.592543] calling  sensors_adm1025_init+0x0/0x14 @ 1
[   26.597809] i2c-core: driver [adm1025] registered
[   26.602571] initcall sensors_adm1025_init+0x0/0x14 returned 0 after 4728 usecs
[   26.609876] calling  sensors_adm1029_init+0x0/0x14 @ 1
[   26.615142] i2c-core: driver [adm1029] registered
[   26.619904] initcall sensors_adm1029_init+0x0/0x14 returned 0 after 4728 usecs
[   26.627209] calling  sensors_adm1031_init+0x0/0x14 @ 1
[   26.632480] i2c-core: driver [adm1031] registered
[   26.637238] initcall sensors_adm1031_init+0x0/0x14 returned 0 after 4729 usecs
[   26.644541] calling  sensors_adm9240_init+0x0/0x1e @ 1
[   26.649809] i2c-core: driver [adm9240] registered
[   26.654572] initcall sensors_adm9240_init+0x0/0x1e returned 0 after 4728 usecs
[   26.661875] calling  applesmc_init+0x0/0x600 @ 1
[   26.666547] applesmc: supported laptop not found!
[   26.671299] applesmc: driver init failed (ret=-19)!
[   26.676223] initcall applesmc_init+0x0/0x600 returned -19 after 9452 usecs
[   26.683146] calling  coretemp_init+0x0/0x210 @ 1
[   26.687989] initcall coretemp_init+0x0/0x210 returned -19 after 165 usecs
[   26.694831] calling  dme1737_init+0x0/0x19f @ 1
[   26.699508] i2c-core: driver [dme1737] registered
[   26.704276] initcall dme1737_init+0x0/0x19f returned 0 after 4735 usecs
[   26.710963] calling  f71805f_init+0x0/0x171 @ 1
[   26.715559] initcall f71805f_init+0x0/0x171 returned -19 after 15 usecs
[   26.722225] calling  sensors_fscher_init+0x0/0x14 @ 1
[   26.727413] i2c-core: driver [fscher] registered
[   26.732086] initcall sensors_fscher_init+0x0/0x14 returned 0 after 4643 usecs
[   26.739286] calling  fschmd_init+0x0/0x14 @ 1
[   26.743774] i2c-core: driver [fschmd] registered
[   26.748449] initcall fschmd_init+0x0/0x14 returned 0 after 4643 usecs
[   26.754957] calling  sm_fscpos_init+0x0/0x14 @ 1
[   26.759703] i2c-core: driver [fscpos] registered
[   26.764378] initcall sm_fscpos_init+0x0/0x14 returned 0 after 4644 usecs
[   26.771144] calling  sensors_gl520sm_init+0x0/0x14 @ 1
[   26.776412] i2c-core: driver [gl520sm] registered
[   26.781173] initcall sensors_gl520sm_init+0x0/0x14 returned 0 after 4727 usecs
[   26.788479] calling  i5k_amb_init+0x0/0x6b @ 1
[   26.793197] initcall i5k_amb_init+0x0/0x6b returned 0 after 220 usecs
[   26.799689] calling  lis3lv02d_init_module+0x0/0x37 @ 1
[   26.805088] lis3lv02d driver loaded.
[   26.808720] initcall lis3lv02d_init_module+0x0/0x37 returned 0 after 3653 usecs
[   26.816119] calling  sensors_lm63_init+0x0/0x1f @ 1
[   26.821130] hub 1-0:1.0: hub_suspend
[   26.824766] usb usb1: bus auto-suspend
[   26.828578] ehci_hcd 0000:00:1d.7: suspend root hub
[   26.833532] i2c-core: driver [lm63] registered
[   26.838036] initcall sensors_lm63_init+0x0/0x1f returned 0 after 16584 usecs
[   26.845152] calling  sm_lm78_init+0x0/0x403 @ 1
[   26.849846] i2c-core: driver [lm78] registered
[   26.854347] initcall sm_lm78_init+0x0/0x403 returned 0 after 4509 usecs
[   26.861017] calling  sensors_lm83_init+0x0/0x14 @ 1
[   26.866026] i2c-core: driver [lm83] registered
[   26.870528] initcall sensors_lm83_init+0x0/0x14 returned 0 after 4475 usecs
[   26.877555] calling  sensors_lm87_init+0x0/0x14 @ 1
[   26.882564] i2c-core: driver [lm87] registered
[   26.887063] initcall sensors_lm87_init+0x0/0x14 returned 0 after 4474 usecs
[   26.894087] calling  sensors_lm90_init+0x0/0x14 @ 1
[   26.899098] i2c-core: driver [lm90] registered
[   26.903600] initcall sensors_lm90_init+0x0/0x14 returned 0 after 4474 usecs
[   26.910626] calling  sensors_max1619_init+0x0/0x14 @ 1
[   26.915894] i2c-core: driver [max1619] registered
[   26.920656] initcall sensors_max1619_init+0x0/0x14 returned 0 after 4728 usecs
[   26.927958] calling  pc87360_init+0x0/0x1bf @ 1
[   26.932549] pc87360: PC8736x not detected, module not inserted.
[   26.938520] initcall pc87360_init+0x0/0x1bf returned -19 after 5838 usecs
[   26.945357] calling  sm_sis5595_init+0x0/0x1b @ 1
[   26.950207] initcall sm_sis5595_init+0x0/0x1b returned 0 after 97 usecs
[   26.956868] calling  sm_thmc50_init+0x0/0x14 @ 1
[   26.961632] i2c-core: driver [thmc50] registered
[   26.966311] initcall sm_thmc50_init+0x0/0x14 returned 0 after 4647 usecs
[   26.973077] calling  sm_via686a_init+0x0/0x1b @ 1
[   26.977923] initcall sm_via686a_init+0x0/0x1b returned 0 after 89 usecs
[   26.984592] calling  sm_vt8231_init+0x0/0x1b @ 1
[   26.989376] initcall sm_vt8231_init+0x0/0x1b returned 0 after 97 usecs
[   26.995954] calling  cpufreq_gov_userspace_init+0x0/0x12 @ 1
[   27.001681] initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 1 usecs
[   27.009230] calling  cpufreq_gov_dbs_init+0x0/0x12 @ 1
[   27.014423] initcall cpufreq_gov_dbs_init+0x0/0x12 returned 0 after 0 usecs
[   27.021433] calling  init_ladder+0x0/0x12 @ 1
[   27.025837] cpuidle: using governor ladder
[   27.029987] initcall init_ladder+0x0/0x12 returned 0 after 4053 usecs
[   27.036478] calling  init_menu+0x0/0x12 @ 1
[   27.040716] cpuidle: using governor menu
[   27.044686] initcall init_menu+0x0/0x12 returned 0 after 3876 usecs
[   27.051003] calling  alix_led_init+0x0/0x108 @ 1
[   27.057342] initcall alix_led_init+0x0/0x108 returned -19 after 1636 usecs
[   27.064264] calling  pca955x_leds_init+0x0/0x14 @ 1
[   27.069278] i2c-core: driver [leds-pca955x] registered
[   27.074467] initcall pca955x_leds_init+0x0/0x14 returned 0 after 5147 usecs
[   27.081490] calling  dcdrbu_init+0x0/0x13e @ 1
[   27.086088] initcall dcdrbu_init+0x0/0x13e returned 0 after 101 usecs
[   27.092578] calling  compal_init+0x0/0x120 @ 1
[   27.097092] initcall compal_init+0x0/0x120 returned -19 after 2 usecs
[   27.103584] calling  acer_wmi_init+0x0/0x6ca @ 1
[   27.108255] acer-wmi: Acer Laptop ACPI-WMI Extras
[   27.113013] acer-wmi: No or unsupported WMI interface, unable to load
[   27.119506] initcall acer_wmi_init+0x0/0x6ca returned -19 after 10986 usecs
[   27.126517] calling  sony_laptop_init+0x0/0x86 @ 1
[   27.131443] initcall sony_laptop_init+0x0/0x86 returned 0 after 87 usecs
[   27.138192] calling  thinkpad_acpi_module_init+0x0/0xa4b @ 1
[   27.143961] initcall thinkpad_acpi_module_init+0x0/0xa4b returned -19 after 44 usecs
[   27.151772] calling  init_soundcore+0x0/0x80 @ 1
[   27.156531] initcall init_soundcore+0x0/0x80 returned 0 after 85 usecs
[   27.163108] calling  alsa_sound_init+0x0/0x8d @ 1
[   27.167929] Advanced Linux Sound Architecture Driver Version 1.0.18a.
[   27.174418] initcall alsa_sound_init+0x0/0x8d returned 0 after 6385 usecs
[   27.181255] calling  alsa_hwdep_init+0x0/0x70 @ 1
[   27.186023] initcall alsa_hwdep_init+0x0/0x70 returned 0 after 8 usecs
[   27.192600] calling  alsa_timer_init+0x0/0x212 @ 1
[   27.197628] initcall alsa_timer_init+0x0/0x212 returned 0 after 178 usecs
[   27.204464] calling  snd_hrtimer_init+0x0/0x196 @ 1
[   27.209413] initcall snd_hrtimer_init+0x0/0x196 returned 0 after 3 usecs
[   27.216165] calling  alsa_pcm_init+0x0/0x71 @ 1
[   27.220758] initcall alsa_pcm_init+0x0/0x71 returned 0 after 7 usecs
[   27.227163] calling  snd_mem_init+0x0/0x2c @ 1
[   27.231668] initcall snd_mem_init+0x0/0x2c returned 0 after 6 usecs
[   27.237988] calling  alsa_rawmidi_init+0x0/0x89 @ 1
[   27.242922] initcall alsa_rawmidi_init+0x0/0x89 returned 0 after 2 usecs
[   27.249669] calling  alsa_opl3_init+0x0/0x8 @ 1
[   27.254246] initcall alsa_opl3_init+0x0/0x8 returned 0 after 0 usecs
[   27.260650] calling  alsa_mpu401_uart_init+0x0/0x8 @ 1
[   27.265842] initcall alsa_mpu401_uart_init+0x0/0x8 returned 0 after 0 usecs
[   27.272852] calling  alsa_sb_common_init+0x0/0x8 @ 1
[   27.278210] initcall alsa_sb_common_init+0x0/0x8 returned 0 after 0 usecs
[   27.285046] calling  alsa_card_als300_init+0x0/0x1b @ 1
[   27.290422] initcall alsa_card_als300_init+0x0/0x1b returned 0 after 94 usecs
[   27.297606] calling  alsa_card_als4000_init+0x0/0x1b @ 1
[   27.303087] initcall alsa_card_als4000_init+0x0/0x1b returned 0 after 100 usecs
[   27.310467] calling  alsa_card_atiixp_init+0x0/0x1b @ 1
[   27.315864] initcall alsa_card_atiixp_init+0x0/0x1b returned 0 after 103 usecs
[   27.323155] calling  alsa_card_bt87x_init+0x0/0x30 @ 1
[   27.328459] initcall alsa_card_bt87x_init+0x0/0x30 returned 0 after 96 usecs
[   27.335558] calling  alsa_card_cmipci_init+0x0/0x1b @ 1
[   27.340947] initcall alsa_card_cmipci_init+0x0/0x1b returned 0 after 96 usecs
[   27.348133] calling  alsa_card_ens137x_init+0x0/0x1b @ 1
[   27.353609] initcall alsa_card_ens137x_init+0x0/0x1b returned 0 after 95 usecs
[   27.360900] calling  alsa_card_es1968_init+0x0/0x1b @ 1
[   27.366291] initcall alsa_card_es1968_init+0x0/0x1b returned 0 after 98 usecs
[   27.373474] calling  alsa_card_m3_init+0x0/0x1b @ 1
[   27.378517] initcall alsa_card_m3_init+0x0/0x1b returned 0 after 95 usecs
[   27.385356] calling  alsa_card_via82xx_init+0x0/0x1b @ 1
[   27.390832] initcall alsa_card_via82xx_init+0x0/0x1b returned 0 after 95 usecs
[   27.398122] calling  alsa_ac97_init+0x0/0x8 @ 1
[   27.402720] initcall alsa_ac97_init+0x0/0x8 returned 0 after 0 usecs
[   27.409119] calling  alsa_card_ali_init+0x0/0x1b @ 1
[   27.414247] initcall alsa_card_ali_init+0x0/0x1b returned 0 after 105 usecs
[   27.421262] calling  alsa_card_aw2_init+0x0/0x29 @ 1
[   27.426291] aw2: Load aw2 module
[   27.429671] initcall alsa_card_aw2_init+0x0/0x29 returned 0 after 3299 usecs
[   27.436766] calling  alsa_card_echo_init+0x0/0x1b @ 1
[   27.441985] initcall alsa_card_echo_init+0x0/0x1b returned 0 after 98 usecs
[   27.448995] calling  alsa_card_echo_init+0x0/0x1b @ 1
[   27.454215] initcall alsa_card_echo_init+0x0/0x1b returned 0 after 99 usecs
[   27.461224] calling  alsa_card_echo_init+0x0/0x1b @ 1
[   27.466439] initcall alsa_card_echo_init+0x0/0x1b returned 0 after 95 usecs
[   27.473453] calling  alsa_card_echo_init+0x0/0x1b @ 1
[   27.478675] initcall alsa_card_echo_init+0x0/0x1b returned 0 after 102 usecs
[   27.485777] calling  alsa_card_echo_init+0x0/0x1b @ 1
[   27.490996] initcall alsa_card_echo_init+0x0/0x1b returned 0 after 99 usecs
[   27.498005] calling  alsa_card_hifier_init+0x0/0x1b @ 1
[   27.503393] initcall alsa_card_hifier_init+0x0/0x1b returned 0 after 94 usecs
[   27.510580] calling  alsa_card_xonar_init+0x0/0x1b @ 1
[   27.515889] initcall alsa_card_xonar_init+0x0/0x1b returned 0 after 101 usecs
[   27.523078] calling  alsa_card_hammerfall_init+0x0/0x1b @ 1
[   27.528814] initcall alsa_card_hammerfall_init+0x0/0x1b returned 0 after 95 usecs
[   27.536364] calling  alsa_card_hdsp_init+0x0/0x1b @ 1
[   27.541584] initcall alsa_card_hdsp_init+0x0/0x1b returned 0 after 99 usecs
[   27.548592] calling  snd_us122l_module_init+0x0/0x1b @ 1
[   27.554067] usbcore: registered new interface driver snd-usb-us122l
[   27.560390] initcall snd_us122l_module_init+0x0/0x1b returned 0 after 6270 usecs
[   27.567862] calling  alsa_sound_last_init+0x0/0x86 @ 1
[   27.573049] ALSA device list:
[   27.576063]   No soundcards found.
[   27.579508] initcall alsa_sound_last_init+0x0/0x86 returned 0 after 6308 usecs
[   27.586795] calling  flow_cache_init+0x0/0x12e @ 1
[   27.591821] initcall flow_cache_init+0x0/0x12e returned 0 after 176 usecs
[   27.598660] calling  pg_init+0x0/0x2ad @ 1
[   27.602823] pktgen v2.70: Packet Generator for packet performance testing.
[   27.609798] initcall pg_init+0x0/0x2ad returned 0 after 6810 usecs
[   27.616028] calling  llc_init+0x0/0x20 @ 1
[   27.620193] initcall llc_init+0x0/0x20 returned 0 after 1 usecs
[   27.626159] calling  llc2_init+0x0/0xd2 @ 1
[   27.630435] NET: Registered protocol family 26
[   27.634931] initcall llc2_init+0x0/0xd2 returned 0 after 4427 usecs
[   27.641248] calling  snap_init+0x0/0x33 @ 1
[   27.645487] initcall snap_init+0x0/0x33 returned 0 after 1 usecs
[   27.651542] calling  blackhole_module_init+0x0/0x12 @ 1
[   27.656815] initcall blackhole_module_init+0x0/0x12 returned 0 after 1 usecs
[   27.663910] calling  hfsc_init+0x0/0x12 @ 1
[   27.668141] initcall hfsc_init+0x0/0x12 returned 0 after 0 usecs
[   27.674197] calling  prio_module_init+0x0/0x12 @ 1
[   27.679034] initcall prio_module_init+0x0/0x12 returned 0 after 0 usecs
[   27.685699] calling  init_route4+0x0/0x12 @ 1
[   27.690111] initcall init_route4+0x0/0x12 returned 0 after 0 usecs
[   27.696342] calling  init_basic+0x0/0x12 @ 1
[   27.700667] initcall init_basic+0x0/0x12 returned 0 after 0 usecs
[   27.706810] calling  cls_flow_init+0x0/0x12 @ 1
[   27.711397] initcall cls_flow_init+0x0/0x12 returned 0 after 0 usecs
[   27.717800] calling  init_em_nbyte+0x0/0x12 @ 1
[   27.722385] initcall init_em_nbyte+0x0/0x12 returned 0 after 0 usecs
[   27.728789] calling  sysctl_ipv4_init+0x0/0x53 @ 1
[   27.733659] initcall sysctl_ipv4_init+0x0/0x53 returned 0 after 23 usecs
[   27.740412] calling  tunnel4_init+0x0/0x6f @ 1
[   27.744911] initcall tunnel4_init+0x0/0x6f returned 0 after 1 usecs
[   27.751228] calling  xfrm4_mode_tunnel_init+0x0/0x19 @ 1
[   27.756595] initcall xfrm4_mode_tunnel_init+0x0/0x19 returned 0 after 1 usecs
[   27.763776] calling  inet_diag_init+0x0/0x6b @ 1
[   27.768455] initcall inet_diag_init+0x0/0x6b returned 0 after 15 usecs
[   27.775035] calling  tcp_diag_init+0x0/0x12 @ 1
[   27.779621] initcall tcp_diag_init+0x0/0x12 returned 0 after 1 usecs
[   27.786023] calling  cubictcp_register+0x0/0x6f @ 1
[   27.790955] TCP cubic registered
[   27.794231] initcall cubictcp_register+0x0/0x6f returned 0 after 3199 usecs
[   27.801242] calling  inet6_init+0x0/0x2b2 @ 1
[   27.806489] NET: Registered protocol family 10
[   27.811655] lo: Disabled Privacy Extensions
[   27.816037] initcall inet6_init+0x0/0x2b2 returned 0 after 10138 usecs
[   27.822616] calling  esp6_init+0x0/0x6f @ 1
[   27.826855] initcall esp6_init+0x0/0x6f returned 0 after 0 usecs
[   27.832911] calling  ipcomp6_init+0x0/0x6f @ 1
[   27.837411] initcall ipcomp6_init+0x0/0x6f returned 0 after 1 usecs
[   27.843727] calling  xfrm6_tunnel_init+0x0/0xf5 @ 1
[   27.848758] hub 2-0:1.0: hub_suspend
[   27.852388] usb usb2: bus auto-suspend
[   27.856247] usb usb2: suspend_rh
[   27.859532] hub 3-0:1.0: hub_suspend
[   27.863157] usb usb3: bus auto-suspend
[   27.866962] usb usb3: suspend_rh
[   27.870249] hub 4-0:1.0: hub_suspend
[   27.873878] usb usb4: bus auto-suspend
[   27.877681] usb usb4: suspend_rh
[   27.880969] hub 5-0:1.0: hub_suspend
[   27.884598] usb usb5: bus auto-suspend
[   27.888393] usb usb5: suspend_rh
[   27.891736] initcall xfrm6_tunnel_init+0x0/0xf5 returned 0 after 42068 usecs
[   27.898839] calling  tunnel6_init+0x0/0x6f @ 1
[   27.903366] initcall tunnel6_init+0x0/0x6f returned 0 after 0 usecs
[   27.909681] calling  xfrm6_mode_tunnel_init+0x0/0x17 @ 1
[   27.915046] initcall xfrm6_mode_tunnel_init+0x0/0x17 returned 0 after 0 usecs
[   27.922229] calling  xfrm6_ro_init+0x0/0x17 @ 1
[   27.926814] initcall xfrm6_ro_init+0x0/0x17 returned 0 after 0 usecs
[   27.933219] calling  sit_init+0x0/0x76 @ 1
[   27.937369] IPv6 over IPv4 tunneling driver
[   27.941843] sit0: Disabled Privacy Extensions
[   27.946284] initcall sit_init+0x0/0x76 returned 0 after 8704 usecs
[   27.952534] calling  packet_init+0x0/0x4a @ 1
[   27.956938] NET: Registered protocol family 17
[   27.961436] initcall packet_init+0x0/0x4a returned 0 after 4390 usecs
[   27.967928] calling  br_init+0x0/0xc6 @ 1
[   27.972180] initcall br_init+0x0/0xc6 returned 0 after 182 usecs
[   27.978233] calling  can_init+0x0/0xf6 @ 1
[   27.982393] can: controller area network core (rev 20090105 abi 8)
[   27.988819] NET: Registered protocol family 29
[   27.993316] initcall can_init+0x0/0xf6 returned 0 after 10665 usecs
[   27.999648] calling  bcm_module_init+0x0/0x6d @ 1
[   28.004406] can: broadcast manager protocol (rev 20090105 t)
[   28.010124] initcall bcm_module_init+0x0/0x6d returned 0 after 5582 usecs
[   28.016965] calling  af_rxrpc_init+0x0/0x1a5 @ 1
[   28.021940] NET: Registered protocol family 33
[   28.026450] initcall af_rxrpc_init+0x0/0x1a5 returned 0 after 4700 usecs
[   28.033212] calling  econet_proto_init+0x0/0x53 @ 1
[   28.038137] NET: Registered protocol family 19
[   28.042637] initcall econet_proto_init+0x0/0x53 returned 0 after 4393 usecs
[   28.049647] calling  sctp_init+0x0/0x7e3 @ 1
[   28.054857] SCTP: Hash tables configured (established 65536 bind 65536)
[   28.096178] sctp_init_sock(sk: ffff88007d804000)
[   28.100868] initcall sctp_init+0x0/0x7e3 returned 0 after 45793 usecs
[   28.107361] calling  lib80211_init+0x0/0x20 @ 1
[   28.111942] lib80211: common routines for IEEE802.11 drivers
[   28.117655] lib80211_crypt: registered algorithm 'NULL'
[   28.122932] initcall lib80211_init+0x0/0x20 returned 0 after 10731 usecs
[   28.129683] calling  lib80211_crypto_wep_init+0x0/0x12 @ 1
[   28.135222] lib80211_crypt: registered algorithm 'WEP'
[   28.140413] initcall lib80211_crypto_wep_init+0x0/0x12 returned 0 after 5068 usecs
[   28.148048] calling  lib80211_crypto_ccmp_init+0x0/0x12 @ 1
[   28.153674] lib80211_crypt: registered algorithm 'CCMP'
[   28.158952] initcall lib80211_crypto_ccmp_init+0x0/0x12 returned 0 after 5154 usecs
[   28.166673] calling  lib80211_crypto_tkip_init+0x0/0x12 @ 1
[   28.172297] lib80211_crypt: registered algorithm 'TKIP'
[   28.177577] initcall lib80211_crypto_tkip_init+0x0/0x12 returned 0 after 5155 usecs
[   28.185297] calling  tipc_init+0x0/0xc9 @ 1
[   28.189529] TIPC: Activated (version 1.6.4 compiled Feb  8 2009 06:54:12)
[   28.196865] NET: Registered protocol family 30
[   28.201357] TIPC: Started in single node mode
[   28.205780] initcall tipc_init+0x0/0xc9 returned 0 after 15870 usecs
[   28.212183] calling  rfkill_handler_init+0x0/0x49 @ 1
[   28.217291] initcall rfkill_handler_init+0x0/0x49 returned 0 after 3 usecs
[   28.224210] calling  dcbnl_init+0x0/0x32 @ 1
[   28.228527] initcall dcbnl_init+0x0/0x32 returned 0 after 1 usecs
[   28.234674] calling  hpet_insert_resource+0x0/0x23 @ 1
[   28.239864] initcall hpet_insert_resource+0x0/0x23 returned 1 after 0 usecs
[   28.246873] initcall hpet_insert_resource+0x0/0x23 returned with error code 1 
[   28.254510] calling  update_mp_table+0x0/0x6c3 @ 1
[   28.259355] initcall update_mp_table+0x0/0x6c3 returned 0 after 0 usecs
[   28.266018] calling  lapic_insert_resource+0x0/0x42 @ 1
[   28.271302] initcall lapic_insert_resource+0x0/0x42 returned 0 after 5 usecs
[   28.278394] calling  init_lapic_nmi_sysfs+0x0/0x39 @ 1
[   28.283587] initcall init_lapic_nmi_sysfs+0x0/0x39 returned 0 after 0 usecs
[   28.290597] calling  ioapic_insert_resources+0x0/0x59 @ 1
[   28.296052] initcall ioapic_insert_resources+0x0/0x59 returned 0 after 1 usecs
[   28.303337] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[   28.308521] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
[   28.315532] calling  uv_init_heartbeat+0x0/0x19 @ 1
[   28.320464] initcall uv_init_heartbeat+0x0/0x19 returned 0 after 0 usecs
[   28.327215] calling  check_early_ioremap_leak+0x0/0x6d @ 1
[   28.332753] initcall check_early_ioremap_leak+0x0/0x6d returned 0 after 0 usecs
[   28.340127] calling  sched_init_debug+0x0/0x24 @ 1
[   28.344982] initcall sched_init_debug+0x0/0x24 returned 0 after 9 usecs
[   28.351648] calling  init_oops_id+0x0/0x40 @ 1
[   28.356147] initcall init_oops_id+0x0/0x40 returned 0 after 3 usecs
[   28.362461] calling  disable_boot_consoles+0x0/0x3a @ 1
[   28.367739] initcall disable_boot_consoles+0x0/0x3a returned 0 after 0 usecs
[   28.374838] calling  pm_qos_power_init+0x0/0xe1 @ 1
[   28.380443] initcall pm_qos_power_init+0x0/0xe1 returned 0 after 657 usecs
[   28.387374] calling  debugfs_kprobe_init+0x0/0x90 @ 1
[   28.392503] initcall debugfs_kprobe_init+0x0/0x90 returned 0 after 8 usecs
[   28.399426] calling  max_swapfiles_check+0x0/0x8 @ 1
[   28.404443] initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
[   28.411280] calling  afs_init+0x0/0x1e5 @ 1
[   28.415508] kAFS: Red Hat AFS client v0.1 registering.
[   28.421024] initcall afs_init+0x0/0x1e5 returned 0 after 5384 usecs
[   28.427342] calling  random32_reseed+0x0/0x5d @ 1
[   28.432134] initcall random32_reseed+0x0/0x5d returned 0 after 5 usecs
[   28.438711] calling  pci_sysfs_init+0x0/0x55 @ 1
[   28.443626] initcall pci_sysfs_init+0x0/0x55 returned 0 after 237 usecs
[   28.450291] calling  acpi_wakeup_device_init+0x0/0x78 @ 1
[   28.455745] initcall acpi_wakeup_device_init+0x0/0x78 returned 0 after 4 usecs
[   28.463030] calling  acpi_sleep_proc_init+0x0/0xa4 @ 1
[   28.468264] initcall acpi_sleep_proc_init+0x0/0xa4 returned 0 after 40 usecs
[   28.475364] calling  boot_wait_for_devices+0x0/0x19 @ 1
[   28.480643] initcall boot_wait_for_devices+0x0/0x19 returned 0 after 0 usecs
[   28.487740] calling  seqgen_init+0x0/0xf @ 1
[   28.492075] initcall seqgen_init+0x0/0xf returned 0 after 10 usecs
[   28.498304] calling  hd_init+0x0/0x333 @ 1
[   28.502485] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[   28.510316] initcall hd_init+0x0/0x333 returned -1 after 7676 usecs
[   28.516633] initcall hd_init+0x0/0x333 returned with error code -1 
[   28.522953] calling  scsi_complete_async_scans+0x0/0x100 @ 1
[   28.528663] initcall scsi_complete_async_scans+0x0/0x100 returned 0 after 0 usecs
[   28.536213] calling  rtc_hctosys+0x0/0x186 @ 1
[   28.540709] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   28.547027] initcall rtc_hctosys+0x0/0x186 returned -19 after 6170 usecs
[   28.553780] calling  pci_mmcfg_late_insert_resources+0x0/0x166 @ 1
[   28.560011] initcall pci_mmcfg_late_insert_resources+0x0/0x166 returned 1 after 0 usecs
[   28.568078] initcall pci_mmcfg_late_insert_resources+0x0/0x166 returned with error code 1 
[   28.576408] calling  tcp_congestion_default+0x0/0x12 @ 1
[   28.581775] initcall tcp_congestion_default+0x0/0x12 returned 0 after 2 usecs
[   28.588955] calling  ip_auto_config+0x0/0xfdc @ 1
[   28.593732] initcall ip_auto_config+0x0/0xfdc returned 0 after 17 usecs
[   28.600414] async_waiting @ 1
[   28.603422] async_continuing @ 1 after 0 usec
[   28.622840] EXT3-fs: INFO: recovery required on readonly filesystem.
[   28.629253] EXT3-fs: write access will be enabled during recovery.
[   28.816662] kjournald starting.  Commit interval 5 seconds
[   28.822217] EXT3-fs: recovery complete.
[   28.826721] EXT3-fs: mounted filesystem with ordered data mode.
[   28.832725] VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
[   28.839428] async_waiting @ 1
[   28.842448] async_continuing @ 1 after 0 usec
[   28.846850] Freeing unused kernel memory: 660k freed
[   31.426499] usb usb2: uevent
[   31.439862] usb 2-0:1.0: uevent
[   31.443363] usb usb3: uevent
[   31.447267] usb 3-0:1.0: uevent
[   31.450770] usb usb4: uevent
[   31.463207] usb 4-0:1.0: uevent
[   31.466695] usb usb5: uevent
[   31.478429] usb 5-0:1.0: uevent
[   31.500342] usb usb1: uevent
[   31.503319] usb 1-0:1.0: uevent
[   52.510805] sky2 eth0: enabling interface
[   52.515295] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   54.905678] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[   54.913314] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   65.904007] eth0: no IPv6 routers present
[  122.816187] EXT3 FS on sda3, internal journal
[  123.291568] Adding 4096532k swap on /dev/sda5.  Priority:-1 extents:1 across:4096532k 
[  125.023796] warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
[  302.816025] Machine check events logged
