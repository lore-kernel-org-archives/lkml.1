Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZBUMtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZBUMtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 07:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZBUMtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 07:49:47 -0500
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:44519 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbZBUMtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 07:49:40 -0500
Date: Sat, 21 Feb 2009 13:49:33 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>
Subject: Re: [BISECTED] [drm:i915_initialize] *ERROR* can not ioremap
 virtual address for ring buffer
Message-ID: <20090221134933.368c2709@fastwebnet.it>
In-Reply-To: <20090221121944.GA21090@silver.sucs.org>
References: <20090221110011.030cb16d@fastwebnet.it>
	<20090221121944.GA21090@silver.sucs.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Feb 2009 12:19:44 +0000
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> On Sat, Feb 21, 2009 at 11:00:11AM +0100, Paolo Ornati wrote:
> > 
> > Booting current -git with that commit reverted (good) and not reverted
> > (bad), with "fastboot initcall_debug" I've noticed mtrr change:
> 
> Does this happen when you enable the mtrr cleaner? -
> http://marc.info/?l=linux-kernel&m=123501581629566&w=2
> 
> -- 
> Sitsofe | http://sucs.org/~sits/

Yes:

@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.29-rc5
-# Fri Feb 20 22:37:54 2009
+# Sat Feb 21 13:43:17 2009
 #
 CONFIG_64BIT=y
 # CONFIG_X86_32 is not set
@@ -275,7 +275,9 @@
 # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
 CONFIG_X86_RESERVE_LOW_64K=y
 CONFIG_MTRR=y
-# CONFIG_MTRR_SANITIZER is not set
+CONFIG_MTRR_SANITIZER=y
+CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
+CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
 CONFIG_X86_PAT=y
 # CONFIG_EFI is not set
 # CONFIG_SECCOMP is not set


dmesg:
[    0.000000] Linux version 2.6.29-rc5-00206-g402a917 (paolo@tux) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1)) #45 SMP Sat Feb 21 13:44:16 CET 2009
[    0.000000] Command line: root=/dev/sda2 ro fastboot initcall_debug
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007e599000 (usable)
[    0.000000]  BIOS-e820: 000000007e599000 - 000000007e5a6000 (reserved)
[    0.000000]  BIOS-e820: 000000007e5a6000 - 000000007e64d000 (usable)
[    0.000000]  BIOS-e820: 000000007e64d000 - 000000007e6a5000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007e6a5000 - 000000007e6aa000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007e6aa000 - 000000007e6ab000 (usable)
[    0.000000]  BIOS-e820: 000000007e6ab000 - 000000007e6f2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007e6f2000 - 000000007e6ff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007e6ff000 - 000000007e700000 (usable)
[    0.000000]  BIOS-e820: 000000007e700000 - 000000007f000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x7e700 max_arch_pfn = 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2032MB, range: 16MB, type UC
[    0.000000] reg 2, base: 2024MB, range: 8MB, type UC
[    0.000000] reg 3, base: 2023MB, range: 1MB, type UC
[    0.000000] total RAM coverred: 2023M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 32M 	num_reg: 4  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2023MB, range: 1MB, type UC
[    0.000000] reg 2, base: 2024MB, range: 8MB, type UC
[    0.000000] reg 3, base: 2032MB, range: 16MB, type UC
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping: 0000000000000000-000000007e700000
[    0.000000]  0000000000 - 007e600000 page 2M
[    0.000000]  007e600000 - 007e700000 page 4k
[    0.000000] kernel direct mapping tables up to 7e700000 @ 8000-c000
[    0.000000] last_map_addr: 7e700000 end: 7e700000
[    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[    0.000000] ACPI: RSDT 7E6FD038, 0050 (r1 INTEL  DG965SS       697       1000013)
[    0.000000] ACPI: FACP 7E6FC000, 0074 (r1 INTEL  DG965SS       697 MSFT  1000013)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 7E6F7000, 40ED (r1 INTEL  DG965SS       697 MSFT  1000013)
[    0.000000] ACPI: FACS 7E6AB000, 0040
[    0.000000] ACPI: APIC 7E6F6000, 0078 (r1 INTEL  DG965SS       697 MSFT  1000013)
[    0.000000] ACPI: WDDT 7E6F5000, 0040 (r1 INTEL  DG965SS       697 MSFT  1000013)
[    0.000000] ACPI: MCFG 7E6F4000, 003C (r1 INTEL  DG965SS       697 MSFT  1000013)
[    0.000000] ACPI: ASF! 7E6F3000, 00A6 (r32 INTEL  DG965SS       697 MSFT  1000013)
[    0.000000] ACPI: HPET 7E6F2000, 0038 (r1 INTEL  DG965SS       697 MSFT  1000013)
[    0.000000] ACPI: SSDT 7E6A9000, 01BC (r1 INTEL     CpuPm      697 MSFT  1000013)
[    0.000000] ACPI: SSDT 7E6A8000, 0175 (r1 INTEL   Cpu0Ist      697 MSFT  1000013)
[    0.000000] ACPI: SSDT 7E6A7000, 0175 (r1 INTEL   Cpu1Ist      697 MSFT  1000013)
[    0.000000] ACPI: SSDT 7E6A6000, 0175 (r1 INTEL   Cpu2Ist      697 MSFT  1000013)
[    0.000000] ACPI: SSDT 7E6A5000, 0175 (r1 INTEL   Cpu3Ist      697 MSFT  1000013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 007e700000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000874d28]    TEXT DATA BSS ==> [0000200000 - 0000874d28]
[    0.000000]   #3 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #4 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000] found SMP MP-table at [ffff8800000fe200] 000fe200
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000008f
[    0.000000]     0: 0x00000100 -> 0x0007e599
[    0.000000]     0: 0x0007e5a6 -> 0x0007e64d
[    0.000000]     0: 0x0007e6aa -> 0x0007e6ab
[    0.000000]     0: 0x0007e6ff -> 0x0007e700
[    0.000000] On node 0 totalpages: 517585
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1756 pages reserved
[    0.000000]   DMA zone: 2171 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7025 pages used for memmap
[    0.000000]   DMA32 zone: 506577 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 7f000000:80f00000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Allocating 49152 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 508748
[    0.000000] Kernel command line: root=/dev/sda2 ro fastboot initcall_debug
[    0.000000] Initializing CPU#0
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1864.864 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000999] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000999] Checking aperture...
[    0.000999] No AGP bridge found
[    0.000999] Memory: 2030916k/2071552k available (3653k kernel code, 1212k absent, 38700k reserved, 2054k data, 384k init)
[    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 3729.72 BogoMIPS (lpj=1864864)
[    0.000999] Mount-cache hash table entries: 256
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] [ds] using Core 2/Atom configuration
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] CPU0: Thermal monitoring enabled (TM2)
[    0.000999] using mwait in idle threads.
[    0.000999] ACPI: Core revision 20081204
[    0.008053] Setting APIC routing to flat
[    0.008437] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.019092] CPU0: Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz stepping 06
[    0.019996] calling  migration_init+0x0/0x60 @ 1
[    0.019996] initcall migration_init+0x0/0x60 returned 1 after 0 usecs
[    0.019996] initcall migration_init+0x0/0x60 returned with error code 1 
[    0.019996] calling  spawn_ksoftirqd+0x0/0x60 @ 1
[    0.019996] initcall spawn_ksoftirqd+0x0/0x60 returned 0 after 0 usecs
[    0.019996] calling  init_call_single_data+0x0/0x70 @ 1
[    0.019996] initcall init_call_single_data+0x0/0x70 returned 0 after 0 usecs
[    0.019996] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 3729.43 BogoMIPS (lpj=1864715)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] [ds] using Core 2/Atom configuration
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] CPU1: Thermal monitoring enabled (TM2)
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.091241] CPU1: Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz stepping 06
[    0.091762] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.092021] Brought up 2 CPUs
[    0.092065] Total of 2 processors activated (7459.15 BogoMIPS).
[    0.093005] CPU0 attaching sched-domain:
[    0.093008]  domain 0: span 0-1 level MC
[    0.093010]   groups: 0 1
[    0.093014] CPU1 attaching sched-domain:
[    0.093016]  domain 0: span 0-1 level MC
[    0.093018]   groups: 1 0
[    0.093066] calling  net_ns_init+0x0/0x190 @ 1
[    0.093089] net_namespace: 1344 bytes
[    0.093134] initcall net_ns_init+0x0/0x190 returned 0 after 0 usecs
[    0.093184] calling  init_smp_flush+0x0/0x60 @ 1
[    0.093230] initcall init_smp_flush+0x0/0x60 returned 0 after 0 usecs
[    0.093281] calling  alloc_frozen_cpus+0x0/0x10 @ 1
[    0.093328] initcall alloc_frozen_cpus+0x0/0x10 returned 0 after 0 usecs
[    0.093380] calling  sysctl_init+0x0/0x20 @ 1
[    0.093427] initcall sysctl_init+0x0/0x20 returned 0 after 0 usecs
[    0.093477] calling  ksysfs_init+0x0/0xc0 @ 1
[    0.093527] initcall ksysfs_init+0x0/0xc0 returned 0 after 0 usecs
[    0.093576] calling  async_init+0x0/0x50 @ 1
[    0.093631] initcall async_init+0x0/0x50 returned 0 after 0 usecs
[    0.093631] calling  init_jiffies_clocksource+0x0/0x20 @ 1
[    0.093990] initcall init_jiffies_clocksource+0x0/0x20 returned 0 after 0 usecs
[    0.094057] calling  pm_init+0x0/0x40 @ 1
[    0.094105] initcall pm_init+0x0/0x40 returned 0 after 0 usecs
[    0.094154] calling  filelock_init+0x0/0x30 @ 1
[    0.094204] initcall filelock_init+0x0/0x30 returned 0 after 0 usecs
[    0.094254] calling  init_misc_binfmt+0x0/0x50 @ 1
[    0.094302] initcall init_misc_binfmt+0x0/0x50 returned 0 after 0 usecs
[    0.094352] calling  init_script_binfmt+0x0/0x20 @ 1
[    0.094399] initcall init_script_binfmt+0x0/0x20 returned 0 after 0 usecs
[    0.094450] calling  init_elf_binfmt+0x0/0x20 @ 1
[    0.094496] initcall init_elf_binfmt+0x0/0x20 returned 0 after 0 usecs
[    0.094547] calling  init_compat_elf_binfmt+0x0/0x20 @ 1
[    0.094595] initcall init_compat_elf_binfmt+0x0/0x20 returned 0 after 0 usecs
[    0.094646] calling  debugfs_init+0x0/0x60 @ 1
[    0.094694] initcall debugfs_init+0x0/0x60 returned 0 after 0 usecs
[    0.094744] calling  random32_init+0x0/0xf0 @ 1
[    0.094790] initcall random32_init+0x0/0xf0 returned 0 after 0 usecs
[    0.094840] calling  cpuidle_init+0x0/0x50 @ 1
[    0.094889] initcall cpuidle_init+0x0/0x50 returned 0 after 0 usecs
[    0.094939] calling  sock_init+0x0/0x60 @ 1
[    0.095008] initcall sock_init+0x0/0x60 returned 0 after 0 usecs
[    0.095058] calling  netlink_proto_init+0x0/0x170 @ 1
[    0.095679] NET: Registered protocol family 16
[    0.095732] initcall netlink_proto_init+0x0/0x170 returned 0 after 0 usecs
[    0.095784] calling  bdi_class_init+0x0/0x50 @ 1
[    0.095837] initcall bdi_class_init+0x0/0x50 returned 0 after 0 usecs
[    0.095837] calling  kobject_uevent_init+0x0/0x50 @ 1
[    0.095989] initcall kobject_uevent_init+0x0/0x50 returned 0 after 0 usecs
[    0.096040] calling  pcibus_class_init+0x0/0x20 @ 1
[    0.096095] initcall pcibus_class_init+0x0/0x20 returned 0 after 0 usecs
[    0.096095] calling  pci_driver_init+0x0/0x20 @ 1
[    0.096095] initcall pci_driver_init+0x0/0x20 returned 0 after 0 usecs
[    0.096095] calling  tty_class_init+0x0/0x40 @ 1
[    0.096096] initcall tty_class_init+0x0/0x40 returned 0 after 0 usecs
[    0.096096] calling  vtconsole_class_init+0x0/0xe0 @ 1
[    0.096096] initcall vtconsole_class_init+0x0/0xe0 returned 0 after 0 usecs
[    0.096096] calling  i2c_init+0x0/0x80 @ 1
[    0.096096] initcall i2c_init+0x0/0x80 returned 0 after 0 usecs
[    0.096096] calling  amd_postcore_init+0x0/0x8c0 @ 1
[    0.096096] initcall amd_postcore_init+0x0/0x8c0 returned 0 after 0 usecs
[    0.096138] calling  arch_kdebugfs_init+0x0/0x30 @ 1
[    0.096188] initcall arch_kdebugfs_init+0x0/0x30 returned 0 after 0 usecs
[    0.096239] calling  mtrr_if_init+0x0/0x80 @ 1
[    0.096989] initcall mtrr_if_init+0x0/0x80 returned 0 after 0 usecs
[    0.097039] calling  ffh_cstate_init+0x0/0x40 @ 1
[    0.097086] initcall ffh_cstate_init+0x0/0x40 returned 0 after 0 usecs
[    0.097136] calling  acpi_pci_init+0x0/0x60 @ 1
[    0.097183] ACPI: bus type pci registered
[    0.097228] initcall acpi_pci_init+0x0/0x60 returned 0 after 0 usecs
[    0.097278] calling  init_acpi_device_notify+0x0/0x4b @ 1
[    0.097326] initcall init_acpi_device_notify+0x0/0x4b returned 0 after 0 usecs
[    0.097393] calling  dmi_id_init+0x0/0x300 @ 1
[    0.097446] initcall dmi_id_init+0x0/0x300 returned 0 after 0 usecs
[    0.097446] calling  pci_arch_init+0x0/0x70 @ 1
[    0.097446] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
[    0.097446] PCI: Not using MMCONFIG.
[    0.097446] PCI: Using configuration type 1 for base access
[    0.097446] initcall pci_arch_init+0x0/0x70 returned 0 after 0 usecs
[    0.097446] calling  topology_init+0x0/0x40 @ 1
[    0.097446] initcall topology_init+0x0/0x40 returned 0 after 0 usecs
[    0.097987] calling  mtrr_init_finialize+0x0/0x50 @ 1
[    0.098035] initcall mtrr_init_finialize+0x0/0x50 returned 0 after 0 usecs
[    0.098087] calling  param_sysfs_init+0x0/0x210 @ 1
[    0.101015] initcall param_sysfs_init+0x0/0x210 returned 0 after 2929 usecs
[    0.101988] calling  pm_sysrq_init+0x0/0x20 @ 1
[    0.102034] initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
[    0.102085] calling  readahead_init+0x0/0x40 @ 1
[    0.102151] initcall readahead_init+0x0/0x40 returned 0 after 0 usecs
[    0.102151] calling  init_bio+0x0/0xe0 @ 1
[    0.102151] bio: create slab <bio-0> at 0
[    0.102151] initcall init_bio+0x0/0xe0 returned 0 after 0 usecs
[    0.102191] calling  blk_settings_init+0x0/0x30 @ 1
[    0.102239] initcall blk_settings_init+0x0/0x30 returned 0 after 0 usecs
[    0.102290] calling  blk_ioc_init+0x0/0x30 @ 1
[    0.102337] initcall blk_ioc_init+0x0/0x30 returned 0 after 0 usecs
[    0.102387] calling  blk_softirq_init+0x0/0x80 @ 1
[    0.102434] initcall blk_softirq_init+0x0/0x80 returned 0 after 0 usecs
[    0.102485] calling  genhd_device_init+0x0/0x70 @ 1
[    0.102552] initcall genhd_device_init+0x0/0x70 returned 0 after 0 usecs
[    0.102552] calling  pci_slot_init+0x0/0x50 @ 1
[    0.102552] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    0.103000] calling  fbmem_init+0x0/0xa0 @ 1
[    0.103060] initcall fbmem_init+0x0/0xa0 returned 0 after 0 usecs
[    0.103060] calling  acpi_init+0x0/0x239 @ 1
[    0.103529] ACPI: EC: Look up EC in DSDT
[    0.107430] ACPI: Interpreter enabled
[    0.107476] ACPI: (supports S0 S3 S5)
[    0.107585] ACPI: Using IOAPIC for interrupt routing
[    0.107672] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
[    0.108744] PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
[    0.113808] PCI: Using MMCONFIG at f0000000 - f7ffffff
[    0.113858] initcall acpi_init+0x0/0x239 returned 0 after 9764 usecs
[    0.113909] calling  acpi_scan_init+0x0/0x10e @ 1
[    0.118741] initcall acpi_scan_init+0x0/0x10e returned 0 after 4882 usecs
[    0.118741] calling  acpi_ec_init+0x0/0x61 @ 1
[    0.118985] initcall acpi_ec_init+0x0/0x61 returned 0 after 976 usecs
[    0.119037] calling  dock_init+0x0/0x8d @ 1
[    0.119191] ACPI: No dock devices found.
[    0.119236] initcall dock_init+0x0/0x8d returned 0 after 0 usecs
[    0.119286] calling  acpi_pci_root_init+0x0/0x28 @ 1
[    0.119344] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.119413] pci 0000:00:02.0: reg 10 32bit mmio: [0x90200000-0x902fffff]
[    0.119413] pci 0000:00:02.0: reg 18 64bit mmio: [0x80000000-0x8fffffff]
[    0.119413] pci 0000:00:02.0: reg 20 io port: [0x3410-0x3417]
[    0.119413] pci 0000:00:03.0: reg 10 64bit mmio: [0x90326100-0x9032610f]
[    0.119413] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.119413] pci 0000:00:03.0: PME# disabled
[    0.119413] pci 0000:00:19.0: reg 10 32bit mmio: [0x90300000-0x9031ffff]
[    0.119413] pci 0000:00:19.0: reg 14 32bit mmio: [0x90324000-0x90324fff]
[    0.119413] pci 0000:00:19.0: reg 18 io port: [0x30e0-0x30ff]
[    0.119413] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.119413] pci 0000:00:19.0: PME# disabled
[    0.119461] pci 0000:00:1a.0: reg 20 io port: [0x30c0-0x30df]
[    0.119506] pci 0000:00:1a.1: reg 20 io port: [0x30a0-0x30bf]
[    0.120012] pci 0000:00:1a.7: reg 10 32bit mmio: [0x90325c00-0x90325fff]
[    0.120060] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.120111] pci 0000:00:1a.7: PME# disabled
[    0.120189] pci 0000:00:1b.0: reg 10 64bit mmio: [0x90320000-0x90323fff]
[    0.120229] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.120279] pci 0000:00:1b.0: PME# disabled
[    0.120374] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.120424] pci 0000:00:1c.0: PME# disabled
[    0.120520] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.120571] pci 0000:00:1c.1: PME# disabled
[    0.120667] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.120718] pci 0000:00:1c.2: PME# disabled
[    0.120816] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.120867] pci 0000:00:1c.3: PME# disabled
[    0.120963] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.120984] pci 0000:00:1c.4: PME# disabled
[    0.121068] pci 0000:00:1d.0: reg 20 io port: [0x3080-0x309f]
[    0.121112] pci 0000:00:1d.1: reg 20 io port: [0x3060-0x307f]
[    0.121156] pci 0000:00:1d.2: reg 20 io port: [0x3040-0x305f]
[    0.121206] pci 0000:00:1d.7: reg 10 32bit mmio: [0x90325800-0x90325bff]
[    0.121253] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.121304] pci 0000:00:1d.7: PME# disabled
[    0.121456] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.121526] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.121578] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.121699] pci 0000:00:1f.2: reg 10 io port: [0x3408-0x340f]
[    0.121705] pci 0000:00:1f.2: reg 14 io port: [0x341c-0x341f]
[    0.121710] pci 0000:00:1f.2: reg 18 io port: [0x3400-0x3407]
[    0.121715] pci 0000:00:1f.2: reg 1c io port: [0x3418-0x341b]
[    0.121720] pci 0000:00:1f.2: reg 20 io port: [0x3020-0x303f]
[    0.121725] pci 0000:00:1f.2: reg 24 32bit mmio: [0x90325000-0x903257ff]
[    0.121752] pci 0000:00:1f.2: PME# supported from D3hot
[    0.121800] pci 0000:00:1f.2: PME# disabled
[    0.121863] pci 0000:00:1f.3: reg 10 32bit mmio: [0x90326000-0x903260ff]
[    0.121879] pci 0000:00:1f.3: reg 20 io port: [0x3000-0x301f]
[    0.122011] pci 0000:02:00.0: reg 10 io port: [0x2018-0x201f]
[    0.122019] pci 0000:02:00.0: reg 14 io port: [0x2024-0x2027]
[    0.122026] pci 0000:02:00.0: reg 18 io port: [0x2010-0x2017]
[    0.122033] pci 0000:02:00.0: reg 1c io port: [0x2020-0x2023]
[    0.122041] pci 0000:02:00.0: reg 20 io port: [0x2000-0x200f]
[    0.122048] pci 0000:02:00.0: reg 24 32bit mmio: [0x90100000-0x901001ff]
[    0.122088] pci 0000:02:00.0: supports D1
[    0.122089] pci 0000:02:00.0: PME# supported from D0 D1 D3hot
[    0.122140] pci 0000:02:00.0: PME# disabled
[    0.122225] pci 0000:00:1c.1: bridge io port: [0x2000-0x2fff]
[    0.122228] pci 0000:00:1c.1: bridge 32bit mmio: [0x90100000-0x901fffff]
[    0.122381] pci 0000:06:01.0: reg 10 io port: [0x1000-0x10ff]
[    0.122387] pci 0000:06:01.0: reg 14 32bit mmio: [0x90000000-0x900000ff]
[    0.122428] pci 0000:06:01.0: supports D1 D2
[    0.122430] pci 0000:06:01.0: PME# supported from D1 D2 D3hot D3cold
[    0.122481] pci 0000:06:01.0: PME# disabled
[    0.122564] pci 0000:00:1e.0: transparent bridge
[    0.122611] pci 0000:00:1e.0: bridge io port: [0x1000-0x1fff]
[    0.122615] pci 0000:00:1e.0: bridge 32bit mmio: [0x90000000-0x900fffff]
[    0.122643] pci_bus 0000:00: on NUMA node 0
[    0.122648] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.122890] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.123074] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.123147] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.123216] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.123286] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.123355] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.128206] initcall acpi_pci_root_init+0x0/0x28 returned 0 after 8787 usecs
[    0.128206] calling  acpi_pci_link_init+0x0/0x63 @ 1
[    0.129031] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.129381] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[    0.129728] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.130079] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[    0.130426] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12)
[    0.130771] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[    0.131091] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
[    0.131437] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.131725] initcall acpi_pci_link_init+0x0/0x63 returned 0 after 2929 usecs
[    0.131725] calling  acpi_power_init+0x0/0x77 @ 1
[    0.131725] initcall acpi_power_init+0x0/0x77 returned 0 after 0 usecs
[    0.131725] calling  acpi_system_init+0x0/0x1b3 @ 1
[    0.132094] initcall acpi_system_init+0x0/0x1b3 returned 0 after 0 usecs
[    0.132146] calling  pnp_init+0x0/0x20 @ 1
[    0.132198] initcall pnp_init+0x0/0x20 returned 0 after 0 usecs
[    0.132198] calling  misc_init+0x0/0xb0 @ 1
[    0.132198] initcall misc_init+0x0/0xb0 returned 0 after 0 usecs
[    0.132198] calling  init_scsi+0x0/0xa0 @ 1
[    0.132198] SCSI subsystem initialized
[    0.132198] initcall init_scsi+0x0/0xa0 returned 0 after 0 usecs
[    0.132198] calling  ata_init+0x0/0x3b0 @ 1
[    0.132198] libata version 3.00 loaded.
[    0.132198] initcall ata_init+0x0/0x3b0 returned 0 after 0 usecs
[    0.132198] calling  usb_init+0x0/0x160 @ 1
[    0.132998] usbcore: registered new interface driver usbfs
[    0.133063] usbcore: registered new interface driver hub
[    0.133063] usbcore: registered new device driver usb
[    0.133063] initcall usb_init+0x0/0x160 returned 0 after 976 usecs
[    0.133093] calling  serio_init+0x0/0xb0 @ 1
[    0.133145] initcall serio_init+0x0/0xb0 returned 0 after 0 usecs
[    0.133145] calling  input_init+0x0/0x130 @ 1
[    0.133145] initcall input_init+0x0/0x130 returned 0 after 0 usecs
[    0.133145] calling  power_supply_class_init+0x0/0x40 @ 1
[    0.133145] initcall power_supply_class_init+0x0/0x40 returned 0 after 0 usecs
[    0.133145] calling  hwmon_init+0x0/0x50 @ 1
[    0.133145] initcall hwmon_init+0x0/0x50 returned 0 after 0 usecs
[    0.133145] calling  thermal_init+0x0/0x50 @ 1
[    0.133145] initcall thermal_init+0x0/0x50 returned 0 after 0 usecs
[    0.133982] calling  pci_subsys_init+0x0/0x120 @ 1
[    0.134028] PCI: Using ACPI for IRQ routing
[    0.134160] initcall pci_subsys_init+0x0/0x120 returned 0 after 0 usecs
[    0.134211] calling  proto_init+0x0/0x20 @ 1
[    0.134259] initcall proto_init+0x0/0x20 returned 0 after 0 usecs
[    0.134308] calling  net_dev_init+0x0/0x180 @ 1
[    0.134365] initcall net_dev_init+0x0/0x180 returned 0 after 0 usecs
[    0.134365] calling  neigh_init+0x0/0x80 @ 1
[    0.134365] initcall neigh_init+0x0/0x80 returned 0 after 0 usecs
[    0.134365] calling  genl_init+0x0/0xe0 @ 1
[    0.138987] initcall genl_init+0x0/0xe0 returned 0 after 4882 usecs
[    0.139039] calling  sysctl_init+0x0/0x50 @ 1
[    0.139088] initcall sysctl_init+0x0/0x50 returned 0 after 0 usecs
[    0.139150] calling  pci_iommu_init+0x0/0x20 @ 1
[    0.139214] initcall pci_iommu_init+0x0/0x20 returned 0 after 0 usecs
[    0.139265] calling  print_all_ICs+0x0/0x510 @ 1
[    0.139314] initcall print_all_ICs+0x0/0x510 returned 0 after 0 usecs
[    0.139364] calling  hpet_late_init+0x0/0x1f0 @ 1
[    0.139413] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.139534] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.140988] initcall hpet_late_init+0x0/0x1f0 returned 0 after 1952 usecs
[    0.141038] calling  clocksource_done_booting+0x0/0x20 @ 1
[    0.141089] initcall clocksource_done_booting+0x0/0x20 returned 0 after 0 usecs
[    0.141982] calling  init_pipe_fs+0x0/0x60 @ 1
[    0.142047] initcall init_pipe_fs+0x0/0x60 returned 0 after 6 usecs
[    0.142097] calling  init_mnt_writers+0x0/0x70 @ 1
[    0.142143] initcall init_mnt_writers+0x0/0x70 returned 0 after 0 usecs
[    0.142194] calling  eventpoll_init+0x0/0xc0 @ 1
[    0.142814] initcall eventpoll_init+0x0/0xc0 returned 0 after 2 usecs
[    0.142864] calling  anon_inode_init+0x0/0x140 @ 1
[    0.142915] initcall anon_inode_init+0x0/0x140 returned 0 after 4 usecs
[    0.142968] calling  acpi_event_init+0x0/0x81 @ 1
[    0.145986] initcall acpi_event_init+0x0/0x81 returned 0 after 2900 usecs
[    0.146039] calling  pnpacpi_init+0x0/0xa0 @ 1
[    0.146086] pnp: PnP ACPI init
[    0.146145] ACPI: bus type pnp registered
[    0.149297] pnp: PnP ACPI: found 12 devices
[    0.149342] ACPI: ACPI bus type pnp unregistered
[    0.149389] initcall pnpacpi_init+0x0/0xa0 returned 0 after 3223 usecs
[    0.149440] calling  pnp_system_init+0x0/0x20 @ 1
[    0.149493] system 00:01: iomem range 0xf0000000-0xf7ffffff has been reserved
[    0.149545] system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
[    0.149597] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.149649] system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.149701] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.149753] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.149804] system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.149856] system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
[    0.149908] system 00:01: iomem range 0xc0000-0xdffff has been reserved
[    0.149959] system 00:01: iomem range 0xe0000-0xfffff could not be reserved
[    0.150018] system 00:06: ioport range 0x500-0x53f has been reserved
[    0.150068] system 00:06: ioport range 0x400-0x47f has been reserved
[    0.150118] system 00:06: ioport range 0x680-0x6ff has been reserved
[    0.150199] initcall pnp_system_init+0x0/0x20 returned 0 after 696 usecs
[    0.150250] calling  chr_dev_init+0x0/0xb0 @ 1
[    0.150606] initcall chr_dev_init+0x0/0xb0 returned 0 after 302 usecs
[    0.150657] calling  firmware_class_init+0x0/0x90 @ 1
[    0.150733] initcall firmware_class_init+0x0/0x90 returned 0 after 28 usecs
[    0.150785] calling  init_acpi_pm_clocksource+0x0/0x100 @ 1
[    0.155356] initcall init_acpi_pm_clocksource+0x0/0x100 returned 0 after 4415 usecs
[    0.155424] calling  pcibios_assign_resources+0x0/0x90 @ 1
[    0.155505] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
[    0.155554] pci 0000:00:1c.0:   IO window: disabled
[    0.155602] pci 0000:00:1c.0:   MEM window: disabled
[    0.155650] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.155700] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
[    0.155750] pci 0000:00:1c.1:   IO window: 0x2000-0x2fff
[    0.155799] pci 0000:00:1c.1:   MEM window: 0x90100000-0x901fffff
[    0.155850] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.155900] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:03
[    0.155948] pci 0000:00:1c.2:   IO window: disabled
[    0.155999] pci 0000:00:1c.2:   MEM window: disabled
[    0.156046] pci 0000:00:1c.2:   PREFETCH window: disabled
[    0.156097] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:04
[    0.156145] pci 0000:00:1c.3:   IO window: disabled
[    0.156193] pci 0000:00:1c.3:   MEM window: disabled
[    0.156240] pci 0000:00:1c.3:   PREFETCH window: disabled
[    0.156291] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:05
[    0.156339] pci 0000:00:1c.4:   IO window: disabled
[    0.156387] pci 0000:00:1c.4:   MEM window: disabled
[    0.156435] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.156485] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
[    0.156534] pci 0000:00:1e.0:   IO window: 0x1000-0x1fff
[    0.156584] pci 0000:00:1e.0:   MEM window: 0x90000000-0x900fffff
[    0.156634] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.156693] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.156745] pci 0000:00:1c.0: setting latency timer to 64
[    0.156753] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.156805] pci 0000:00:1c.1: setting latency timer to 64
[    0.156811] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.156864] pci 0000:00:1c.2: setting latency timer to 64
[    0.156871] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.156923] pci 0000:00:1c.3: setting latency timer to 64
[    0.156929] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.156981] pci 0000:00:1c.4: setting latency timer to 64
[    0.156992] pci 0000:00:1e.0: setting latency timer to 64
[    0.156995] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.156997] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.156999] pci_bus 0000:01: resource 0 mem: [0x0-0x0]
[    0.157001] pci_bus 0000:01: resource 1 mem: [0x0-0x0]
[    0.157003] pci_bus 0000:01: resource 2 mem: [0x0-0x0]
[    0.157005] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.157007] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.157009] pci_bus 0000:02: resource 1 mem: [0x90100000-0x901fffff]
[    0.157011] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    0.157013] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.157014] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.157016] pci_bus 0000:03: resource 1 mem: [0x0-0x0]
[    0.157018] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.157020] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.157022] pci_bus 0000:04: resource 0 mem: [0x0-0x0]
[    0.157023] pci_bus 0000:04: resource 1 mem: [0x0-0x0]
[    0.157025] pci_bus 0000:04: resource 2 mem: [0x0-0x0]
[    0.157027] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    0.157029] pci_bus 0000:05: resource 0 mem: [0x0-0x0]
[    0.157030] pci_bus 0000:05: resource 1 mem: [0x0-0x0]
[    0.157032] pci_bus 0000:05: resource 2 mem: [0x0-0x0]
[    0.157034] pci_bus 0000:05: resource 3 mem: [0x0-0x0]
[    0.157036] pci_bus 0000:06: resource 0 io:  [0x1000-0x1fff]
[    0.157038] pci_bus 0000:06: resource 1 mem: [0x90000000-0x900fffff]
[    0.157040] pci_bus 0000:06: resource 2 mem: [0x0-0x0]
[    0.157042] pci_bus 0000:06: resource 3 io:  [0x00-0xffff]
[    0.157044] pci_bus 0000:06: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.157047] initcall pcibios_assign_resources+0x0/0x90 returned 0 after 1536 usecs
[    0.157116] calling  sysctl_core_init+0x0/0x40 @ 1
[    0.157166] initcall sysctl_core_init+0x0/0x40 returned 0 after 3 usecs
[    0.157217] calling  inet_init+0x0/0x240 @ 1
[    0.157269] NET: Registered protocol family 2
[    0.168226] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.168505] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.170411] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.170946] TCP: Hash tables configured (established 262144 bind 65536)
[    0.170997] TCP reno registered
[    0.173338] initcall inet_init+0x0/0x240 returned 0 after 15691 usecs
[    0.173402] calling  af_unix_init+0x0/0x70 @ 1
[    0.173456] NET: Registered protocol family 1
[    0.173505] initcall af_unix_init+0x0/0x70 returned 0 after 56 usecs
[    0.173558] calling  populate_rootfs+0x0/0x100 @ 1
[    0.173711] initcall populate_rootfs+0x0/0x100 returned 0 after 103 usecs
[    0.173763] calling  i8259A_init_sysfs+0x0/0x30 @ 1
[    0.173933] initcall i8259A_init_sysfs+0x0/0x30 returned 0 after 119 usecs
[    0.173985] calling  vsyscall_init+0x0/0x70 @ 1
[    0.174038] initcall vsyscall_init+0x0/0x70 returned 0 after 7 usecs
[    0.174088] calling  sbf_init+0x0/0xf0 @ 1
[    0.174134] initcall sbf_init+0x0/0xf0 returned 0 after 0 usecs
[    0.174184] calling  i8237A_init_sysfs+0x0/0x30 @ 1
[    0.174300] initcall i8237A_init_sysfs+0x0/0x30 returned 0 after 67 usecs
[    0.174352] calling  add_rtc_cmos+0x0/0xb0 @ 1
[    0.174401] initcall add_rtc_cmos+0x0/0xb0 returned 0 after 2 usecs
[    0.174453] calling  cache_sysfs_init+0x0/0x70 @ 1
[    0.174771] initcall cache_sysfs_init+0x0/0x70 returned 0 after 264 usecs
[    0.174823] calling  mce_init_device+0x0/0xb0 @ 1
[    0.175021] initcall mce_init_device+0x0/0xb0 returned 0 after 147 usecs
[    0.175073] calling  periodic_mcheck_init+0x0/0x50 @ 1
[    0.175122] initcall periodic_mcheck_init+0x0/0x50 returned 0 after 1 usecs
[    0.175174] calling  thermal_throttle_init_device+0x0/0xa0 @ 1
[    0.175227] initcall thermal_throttle_init_device+0x0/0xa0 returned 0 after 3 usecs
[    0.175298] calling  msr_init+0x0/0x120 @ 1
[    0.175446] initcall msr_init+0x0/0x120 returned 0 after 99 usecs
[    0.175495] calling  cpuid_init+0x0/0x120 @ 1
[    0.175642] initcall cpuid_init+0x0/0x120 returned 0 after 98 usecs
[    0.175693] calling  init_lapic_sysfs+0x0/0x30 @ 1
[    0.175795] initcall init_lapic_sysfs+0x0/0x30 returned 0 after 54 usecs
[    0.175847] calling  ioapic_init_sysfs+0x0/0xf0 @ 1
[    0.175952] initcall ioapic_init_sysfs+0x0/0xf0 returned 0 after 57 usecs
[    0.176004] calling  add_pcspkr+0x0/0x30 @ 1
[    0.176087] initcall add_pcspkr+0x0/0x30 returned 0 after 37 usecs
[    0.176137] calling  uv_ptc_init+0x0/0x60 @ 1
[    0.176183] initcall uv_ptc_init+0x0/0x60 returned 0 after 0 usecs
[    0.176233] calling  uv_bau_init+0x0/0x4a0 @ 1
[    0.176288] initcall uv_bau_init+0x0/0x4a0 returned 0 after 0 usecs
[    0.176338] calling  sgi_uv_sysfs_init+0x0/0xb0 @ 1
[    0.176392] initcall sgi_uv_sysfs_init+0x0/0xb0 returned 0 after 6 usecs
[    0.176443] calling  init_vdso_vars+0x0/0x210 @ 1
[    0.176501] initcall init_vdso_vars+0x0/0x210 returned 0 after 11 usecs
[    0.176552] calling  ia32_binfmt_init+0x0/0x20 @ 1
[    0.176599] initcall ia32_binfmt_init+0x0/0x20 returned 0 after 0 usecs
[    0.176650] calling  sysenter_setup+0x0/0x350 @ 1
[    0.176700] initcall sysenter_setup+0x0/0x350 returned 0 after 3 usecs
[    0.176751] calling  init_sched_debug_procfs+0x0/0x30 @ 1
[    0.176802] initcall init_sched_debug_procfs+0x0/0x30 returned 0 after 3 usecs
[    0.176870] calling  proc_schedstat_init+0x0/0x30 @ 1
[    0.176918] initcall proc_schedstat_init+0x0/0x30 returned 0 after 1 usecs
[    0.176969] calling  proc_execdomains_init+0x0/0x30 @ 1
[    0.177018] initcall proc_execdomains_init+0x0/0x30 returned 0 after 1 usecs
[    0.177070] calling  ioresources_init+0x0/0x40 @ 1
[    0.177119] initcall ioresources_init+0x0/0x40 returned 0 after 1 usecs
[    0.177170] calling  uid_cache_init+0x0/0x70 @ 1
[    0.177219] initcall uid_cache_init+0x0/0x70 returned 0 after 3 usecs
[    0.177272] calling  init_posix_timers+0x0/0x120 @ 1
[    0.177321] initcall init_posix_timers+0x0/0x120 returned 0 after 1 usecs
[    0.177373] calling  init_posix_cpu_timers+0x0/0xe0 @ 1
[    0.177420] initcall init_posix_cpu_timers+0x0/0xe0 returned 0 after 0 usecs
[    0.177472] calling  nsproxy_cache_init+0x0/0x30 @ 1
[    0.177520] initcall nsproxy_cache_init+0x0/0x30 returned 0 after 0 usecs
[    0.177572] calling  timekeeping_init_device+0x0/0x30 @ 1
[    0.177677] initcall timekeeping_init_device+0x0/0x30 returned 0 after 55 usecs
[    0.177745] calling  init_clocksource_sysfs+0x0/0x60 @ 1
[    0.177848] initcall init_clocksource_sysfs+0x0/0x60 returned 0 after 53 usecs
[    0.177916] calling  init_timer_list_procfs+0x0/0x30 @ 1
[    0.177965] initcall init_timer_list_procfs+0x0/0x30 returned 0 after 1 usecs
[    0.178017] calling  futex_init+0x0/0x70 @ 1
[    0.178071] initcall futex_init+0x0/0x70 returned 0 after 8 usecs
[    0.178121] calling  proc_dma_init+0x0/0x30 @ 1
[    0.178168] initcall proc_dma_init+0x0/0x30 returned 0 after 1 usecs
[    0.178218] calling  proc_modules_init+0x0/0x30 @ 1
[    0.178269] initcall proc_modules_init+0x0/0x30 returned 0 after 1 usecs
[    0.178322] calling  percpu_modinit+0x0/0x80 @ 1
[    0.178368] initcall percpu_modinit+0x0/0x80 returned 0 after 0 usecs
[    0.178419] calling  kallsyms_init+0x0/0x30 @ 1
[    0.178466] initcall kallsyms_init+0x0/0x30 returned 0 after 0 usecs
[    0.178516] calling  utsname_sysctl_init+0x0/0x20 @ 1
[    0.178565] initcall utsname_sysctl_init+0x0/0x20 returned 0 after 1 usecs
[    0.178616] calling  init_lstats_procfs+0x0/0x30 @ 1
[    0.178664] initcall init_lstats_procfs+0x0/0x30 returned 0 after 1 usecs
[    0.178716] calling  init_per_zone_pages_min+0x0/0xb0 @ 1
[    0.178823] initcall init_per_zone_pages_min+0x0/0xb0 returned 0 after 58 usecs
[    0.178891] calling  pdflush_init+0x0/0x20 @ 1
[    0.178984] initcall pdflush_init+0x0/0x20 returned 0 after 46 usecs
[    0.179034] calling  kswapd_init+0x0/0x20 @ 1
[    0.179103] initcall kswapd_init+0x0/0x20 returned 0 after 22 usecs
[    0.179156] calling  init_tmpfs+0x0/0xf0 @ 1
[    0.179222] initcall init_tmpfs+0x0/0xf0 returned 0 after 20 usecs
[    0.179278] calling  setup_vmstat+0x0/0xd0 @ 1
[    0.179330] initcall setup_vmstat+0x0/0xd0 returned 0 after 6 usecs
[    0.179379] calling  mm_sysfs_init+0x0/0x30 @ 1
[    0.179428] initcall mm_sysfs_init+0x0/0x30 returned 0 after 2 usecs
[    0.179478] calling  proc_vmalloc_init+0x0/0x30 @ 1
[    0.179526] initcall proc_vmalloc_init+0x0/0x30 returned 0 after 1 usecs
[    0.179576] calling  procswaps_init+0x0/0x30 @ 1
[    0.179624] initcall procswaps_init+0x0/0x30 returned 0 after 1 usecs
[    0.179674] calling  slab_proc_init+0x0/0x30 @ 1
[    0.179721] initcall slab_proc_init+0x0/0x30 returned 0 after 1 usecs
[    0.180346] calling  slab_sysfs_init+0x0/0x100 @ 1
[    0.182454] initcall slab_sysfs_init+0x0/0x100 returned 0 after 2012 usecs
[    0.182506] calling  fasync_init+0x0/0x30 @ 1
[    0.182555] initcall fasync_init+0x0/0x30 returned 0 after 3 usecs
[    0.182604] calling  proc_filesystems_init+0x0/0x30 @ 1
[    0.182654] initcall proc_filesystems_init+0x0/0x30 returned 0 after 2 usecs
[    0.182706] calling  dnotify_init+0x0/0x30 @ 1
[    0.182812] initcall dnotify_init+0x0/0x30 returned 0 after 58 usecs
[    0.182862] calling  inotify_setup+0x0/0x20 @ 1
[    0.182908] initcall inotify_setup+0x0/0x20 returned 0 after 0 usecs
[    0.182958] calling  inotify_user_setup+0x0/0xc0 @ 1
[    0.183016] initcall inotify_user_setup+0x0/0xc0 returned 0 after 11 usecs
[    0.183067] calling  aio_setup+0x0/0x80 @ 1
[    0.183211] initcall aio_setup+0x0/0x80 returned 0 after 95 usecs
[    0.183264] calling  proc_locks_init+0x0/0x30 @ 1
[    0.183313] initcall proc_locks_init+0x0/0x30 returned 0 after 3 usecs
[    0.183363] calling  init_sys32_ioctl+0x0/0x90 @ 1
[    0.183424] initcall init_sys32_ioctl+0x0/0x90 returned 0 after 13 usecs
[    0.183474] calling  proc_cmdline_init+0x0/0x30 @ 1
[    0.183522] initcall proc_cmdline_init+0x0/0x30 returned 0 after 1 usecs
[    0.183573] calling  proc_cpuinfo_init+0x0/0x30 @ 1
[    0.183621] initcall proc_cpuinfo_init+0x0/0x30 returned 0 after 1 usecs
[    0.183671] calling  proc_devices_init+0x0/0x30 @ 1
[    0.183719] initcall proc_devices_init+0x0/0x30 returned 0 after 0 usecs
[    0.183769] calling  proc_interrupts_init+0x0/0x30 @ 1
[    0.183818] initcall proc_interrupts_init+0x0/0x30 returned 0 after 1 usecs
[    0.183869] calling  proc_loadavg_init+0x0/0x30 @ 1
[    0.183917] initcall proc_loadavg_init+0x0/0x30 returned 0 after 1 usecs
[    0.183968] calling  proc_meminfo_init+0x0/0x30 @ 1
[    0.184016] initcall proc_meminfo_init+0x0/0x30 returned 0 after 0 usecs
[    0.184066] calling  proc_stat_init+0x0/0x30 @ 1
[    0.184114] initcall proc_stat_init+0x0/0x30 returned 0 after 1 usecs
[    0.184166] calling  proc_uptime_init+0x0/0x30 @ 1
[    0.184214] initcall proc_uptime_init+0x0/0x30 returned 0 after 1 usecs
[    0.184267] calling  proc_version_init+0x0/0x30 @ 1
[    0.184315] initcall proc_version_init+0x0/0x30 returned 0 after 1 usecs
[    0.184366] calling  proc_kcore_init+0x0/0x50 @ 1
[    0.184413] initcall proc_kcore_init+0x0/0x50 returned 0 after 1 usecs
[    0.184463] calling  proc_kmsg_init+0x0/0x30 @ 1
[    0.184510] initcall proc_kmsg_init+0x0/0x30 returned 0 after 1 usecs
[    0.184560] calling  proc_page_init+0x0/0x50 @ 1
[    0.184608] initcall proc_page_init+0x0/0x50 returned 0 after 1 usecs
[    0.184658] calling  init_devpts_fs+0x0/0x50 @ 1
[    0.184711] initcall init_devpts_fs+0x0/0x50 returned 0 after 6 usecs
[    0.184761] calling  init_ext3_fs+0x0/0x70 @ 1
[    0.184858] initcall init_ext3_fs+0x0/0x70 returned 0 after 49 usecs
[    0.184908] calling  journal_init+0x0/0xb0 @ 1
[    0.185152] initcall journal_init+0x0/0xb0 returned 0 after 193 usecs
[    0.185203] calling  init_ext2_fs+0x0/0x70 @ 1
[    0.185299] initcall init_ext2_fs+0x0/0x70 returned 0 after 46 usecs
[    0.185350] calling  init_ramfs_fs+0x0/0x20 @ 1
[    0.185396] initcall init_ramfs_fs+0x0/0x20 returned 0 after 0 usecs
[    0.185446] calling  init_fat_fs+0x0/0x60 @ 1
[    0.185583] initcall init_fat_fs+0x0/0x60 returned 0 after 88 usecs
[    0.185633] calling  init_vfat_fs+0x0/0x20 @ 1
[    0.185679] initcall init_vfat_fs+0x0/0x20 returned 0 after 1 usecs
[    0.185729] calling  init_msdos_fs+0x0/0x20 @ 1
[    0.185776] initcall init_msdos_fs+0x0/0x20 returned 0 after 0 usecs
[    0.185826] calling  init_iso9660_fs+0x0/0x70 @ 1
[    0.185919] initcall init_iso9660_fs+0x0/0x70 returned 0 after 45 usecs
[    0.185970] calling  init_nls_cp437+0x0/0x20 @ 1
[    0.186016] initcall init_nls_cp437+0x0/0x20 returned 0 after 0 usecs
[    0.186067] calling  init_nls_iso8859_1+0x0/0x20 @ 1
[    0.186114] initcall init_nls_iso8859_1+0x0/0x20 returned 0 after 0 usecs
[    0.186168] calling  init_nls_iso8859_15+0x0/0x20 @ 1
[    0.186215] initcall init_nls_iso8859_15+0x0/0x20 returned 0 after 0 usecs
[    0.186276] calling  init_nls_utf8+0x0/0x30 @ 1
[    0.186323] initcall init_nls_utf8+0x0/0x30 returned 0 after 1 usecs
[    0.186373] calling  init_autofs4_fs+0x0/0x30 @ 1
[    0.186457] initcall init_autofs4_fs+0x0/0x30 returned 0 after 37 usecs
[    0.186508] calling  fuse_init+0x0/0x140 @ 1
[    0.186553] fuse init (API version 7.11)
[    0.186736] initcall fuse_init+0x0/0x140 returned 0 after 176 usecs
[    0.186786] calling  init_udf_fs+0x0/0x70 @ 1
[    0.186877] initcall init_udf_fs+0x0/0x70 returned 0 after 44 usecs
[    0.186928] calling  ipc_init+0x0/0x30 @ 1
[    0.186975] msgmni has been set to 3968
[    0.187023] initcall ipc_init+0x0/0x30 returned 0 after 49 usecs
[    0.187073] calling  ipc_sysctl_init+0x0/0x20 @ 1
[    0.187121] initcall ipc_sysctl_init+0x0/0x20 returned 0 after 2 usecs
[    0.187171] calling  init_mqueue_fs+0x0/0xd0 @ 1
[    0.187286] initcall init_mqueue_fs+0x0/0xd0 returned 0 after 66 usecs
[    0.187338] calling  proc_genhd_init+0x0/0x40 @ 1
[    0.187387] initcall proc_genhd_init+0x0/0x40 returned 0 after 2 usecs
[    0.187437] calling  noop_init+0x0/0x20 @ 1
[    0.187482] io scheduler noop registered
[    0.187526] initcall noop_init+0x0/0x20 returned 0 after 43 usecs
[    0.187577] calling  as_init+0x0/0x20 @ 1
[    0.187620] io scheduler anticipatory registered
[    0.187666] initcall as_init+0x0/0x20 returned 0 after 44 usecs
[    0.187715] calling  deadline_init+0x0/0x20 @ 1
[    0.187761] io scheduler deadline registered
[    0.187807] initcall deadline_init+0x0/0x20 returned 0 after 43 usecs
[    0.187857] calling  cfq_init+0x0/0xb0 @ 1
[    0.187958] io scheduler cfq registered (default)
[    0.188005] initcall cfq_init+0x0/0xb0 returned 0 after 101 usecs
[    0.188055] calling  percpu_counter_startup+0x0/0x20 @ 1
[    0.188104] initcall percpu_counter_startup+0x0/0x20 returned 0 after 0 usecs
[    0.188158] calling  pci_init+0x0/0x40 @ 1
[    0.188210] pci 0000:00:02.0: Boot video device
[    0.188543] initcall pci_init+0x0/0x40 returned 0 after 332 usecs
[    0.188593] calling  pci_proc_init+0x0/0x70 @ 1
[    0.188685] initcall pci_proc_init+0x0/0x70 returned 0 after 44 usecs
[    0.188736] calling  fb_console_init+0x0/0x160 @ 1
[    0.188820] initcall fb_console_init+0x0/0x160 returned 0 after 36 usecs
[    0.188871] calling  vesafb_init+0x0/0x255 @ 1
[    0.188989] initcall vesafb_init+0x0/0x255 returned 0 after 69 usecs
[    0.189040] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    0.189090] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 2 usecs
[    0.189143] calling  acpi_ac_init+0x0/0x45 @ 1
[    0.189243] initcall acpi_ac_init+0x0/0x45 returned 0 after 53 usecs
[    0.189297] calling  acpi_battery_init+0x0/0x45 @ 1
[    0.189383] initcall acpi_battery_init+0x0/0x45 returned 0 after 37 usecs
[    0.189434] calling  acpi_button_init+0x0/0x5e @ 1
[    0.189557] input: Power Button (FF) as /class/input/input0
[    0.189606] ACPI: Power Button (FF) [PWRF]
[    0.189717] input: Sleep Button (CM) as /class/input/input1
[    0.189770] ACPI: Sleep Button (CM) [SLPB]
[    0.189852] initcall acpi_button_init+0x0/0x5e returned 0 after 361 usecs
[    0.189903] calling  acpi_fan_init+0x0/0x32 @ 1
[    0.189988] initcall acpi_fan_init+0x0/0x32 returned 0 after 37 usecs
[    0.190039] calling  irqrouter_init_sysfs+0x0/0x38 @ 1
[    0.190163] initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 74 usecs
[    0.190216] calling  acpi_processor_init+0x0/0x101 @ 1
[    0.190443] processor ACPI_CPU:00: registered as cooling_device0
[    0.190494] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.190720] processor ACPI_CPU:01: registered as cooling_device1
[    0.190772] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.190956] initcall acpi_processor_init+0x0/0x101 returned 0 after 671 usecs
[    0.191009] calling  acpi_container_init+0x0/0x42 @ 1
[    0.192424] initcall acpi_container_init+0x0/0x42 returned 0 after 1334 usecs
[    0.192478] calling  acpi_thermal_init+0x0/0x83 @ 1
[    0.192580] initcall acpi_thermal_init+0x0/0x83 returned 0 after 52 usecs
[    0.192633] calling  rand_initialize+0x0/0x30 @ 1
[    0.192694] initcall rand_initialize+0x0/0x30 returned 0 after 14 usecs
[    0.192744] calling  tty_init+0x0/0x110 @ 1
[    0.201280] initcall tty_init+0x0/0x110 returned 0 after 8289 usecs
[    0.201334] calling  pty_init+0x0/0x2f0 @ 1
[    0.201445] initcall pty_init+0x0/0x2f0 returned 0 after 61 usecs
[    0.201507] calling  sysrq_init+0x0/0x30 @ 1
[    0.201557] initcall sysrq_init+0x0/0x30 returned 0 after 4 usecs
[    0.201606] calling  rtc_init+0x0/0xb0 @ 1
[    0.201691] Real Time Clock Driver v1.12b
[    0.201736] initcall rtc_init+0x0/0xb0 returned 0 after 83 usecs
[    0.201786] calling  hpet_init+0x0/0x80 @ 1
[    0.201945] initcall hpet_init+0x0/0x80 returned 0 after 111 usecs
[    0.201995] calling  mod_init+0x0/0x230 @ 1
[    0.202140] initcall mod_init+0x0/0x230 returned -19 after 98 usecs
[    0.202190] calling  agp_init+0x0/0x30 @ 1
[    0.202234] Linux agpgart interface v0.103
[    0.202281] initcall agp_init+0x0/0x30 returned 0 after 45 usecs
[    0.202330] calling  agp_intel_init+0x0/0x30 @ 1
[    0.202390] agpgart-intel 0000:00:00.0: Intel 965G Chipset
[    0.203022] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[    0.205812] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x80000000
[    0.205922] initcall agp_intel_init+0x0/0x30 returned 0 after 3458 usecs
[    0.205973] calling  drm_core_init+0x0/0x110 @ 1
[    0.206065] [drm] Initialized drm 1.1.0 20060810
[    0.206112] initcall drm_core_init+0x0/0x110 returned 0 after 90 usecs
[    0.206162] calling  radeon_init+0x0/0x20 @ 1
[    0.206924] initcall radeon_init+0x0/0x20 returned 0 after 699 usecs
[    0.206974] calling  i915_init+0x0/0x70 @ 1
[    0.207067] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.207119] pci 0000:00:02.0: setting latency timer to 64
[    0.219994] pci 0000:00:02.0: irq 24 for MSI/MSI-X
[    0.220022] [drm] Initialized i915 1.6.0 20080730 on minor 0
[    0.220114] initcall i915_init+0x0/0x70 returned 0 after 12786 usecs
[    0.220165] calling  serial8250_init+0x0/0x150 @ 1
[    0.220211] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.220603] initcall serial8250_init+0x0/0x150 returned 0 after 381 usecs
[    0.220655] calling  serial8250_pnp_init+0x0/0x20 @ 1
[    0.220897] initcall serial8250_pnp_init+0x0/0x20 returned 0 after 189 usecs
[    0.220949] calling  serial8250_pci_init+0x0/0x20 @ 1
[    0.221048] initcall serial8250_pci_init+0x0/0x20 returned 0 after 51 usecs
[    0.221102] calling  topology_sysfs_init+0x0/0x60 @ 1
[    0.221162] initcall topology_sysfs_init+0x0/0x60 returned 0 after 12 usecs
[    0.221213] calling  floppy_init+0x0/0xfb0 @ 1
[    0.221295] Floppy drive(s): fd0 is 1.44M
[    0.236532] FDC 0 is a National Semiconductor PC87306
[    0.237610] initcall floppy_init+0x0/0xfb0 returned 0 after 15964 usecs
[    0.237661] calling  brd_init+0x0/0x1c0 @ 1
[    0.239056] brd: module loaded
[    0.239100] initcall brd_init+0x0/0x1c0 returned 0 after 1359 usecs
[    0.239725] calling  loop_init+0x0/0x1e0 @ 1
[    0.240427] loop: module loaded
[    0.240471] initcall loop_init+0x0/0x1e0 returned 0 after 684 usecs
[    0.240521] calling  net_olddevs_init+0x0/0xb0 @ 1
[    0.240573] initcall net_olddevs_init+0x0/0xb0 returned 0 after 3 usecs
[    0.240624] calling  dummy_init_module+0x0/0xe0 @ 1
[    0.240766] initcall dummy_init_module+0x0/0xe0 returned 0 after 92 usecs
[    0.240818] calling  tun_init+0x0/0xb0 @ 1
[    0.240862] tun: Universal TUN/TAP device driver, 1.6
[    0.240908] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.241003] initcall tun_init+0x0/0xb0 returned 0 after 136 usecs
[    0.241053] calling  init_sd+0x0/0xc0 @ 1
[    0.241131] Driver 'sd' needs updating - please use bus_type methods
[    0.241213] initcall init_sd+0x0/0xc0 returned 0 after 112 usecs
[    0.241263] calling  init_sr+0x0/0x60 @ 1
[    0.241307] Driver 'sr' needs updating - please use bus_type methods
[    0.241388] initcall init_sr+0x0/0x60 returned 0 after 78 usecs
[    0.241437] calling  init_sg+0x0/0xe0 @ 1
[    0.241512] initcall init_sg+0x0/0xe0 returned 0 after 30 usecs
[    0.241565] calling  ahci_init+0x0/0x20 @ 1
[    0.241629] ahci 0000:00:1f.2: version 3.0
[    0.241642] ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.241730] ahci 0000:00:1f.2: irq 25 for MSI/MSI-X
[    0.241791] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    0.241861] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part ems 
[    0.241930] ahci 0000:00:1f.2: setting latency timer to 64
[    0.242157] scsi0 : ahci
[    0.242304] scsi1 : ahci
[    0.242417] scsi2 : ahci
[    0.242530] scsi3 : ahci
[    0.242643] scsi4 : ahci
[    0.242761] scsi5 : ahci
[    0.242939] ata1: SATA max UDMA/133 abar m2048@0x90325000 port 0x90325100 irq 25
[    0.243007] ata2: SATA max UDMA/133 abar m2048@0x90325000 port 0x90325180 irq 25
[    0.243074] ata3: DUMMY
[    0.243114] ata4: DUMMY
[    0.243155] ata5: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 25
[    0.243224] ata6: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 25
[    0.243350] calling  1_async_port_probe+0x0/0xf0 @ 535
[    0.243354] initcall ahci_init+0x0/0x20 returned 0 after 1699 usecs
[    0.243358] calling  marvell_init+0x0/0x20 @ 1
[    0.243379] pata_marvell 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.243401] pata_marvell 0000:02:00.0: setting latency timer to 64
[    0.243620] calling  2_async_port_probe+0x0/0xf0 @ 537
[    0.243675] scsi6 : pata_marvell
[    0.243793] calling  3_async_port_probe+0x0/0xf0 @ 539
[    0.243846] async_waiting @ 539
[    0.243898] calling  4_async_port_probe+0x0/0xf0 @ 541
[    0.243952] scsi7 : pata_marvell
[    0.244035] async_waiting @ 541
[    0.244056] calling  5_async_port_probe+0x0/0xf0 @ 543
[    0.244134] calling  6_async_port_probe+0x0/0xf0 @ 545
[    0.244137] ata7: PATA max UDMA/100 cmd 0x2018 ctl 0x2024 bmdma 0x2000 irq 17
[    0.244138] ata8: DUMMY
[    0.244184] initcall marvell_init+0x0/0x20 returned 0 after 803 usecs
[    0.244187] calling  cdrom_init+0x0/0x10 @ 1
[    0.244195] initcall cdrom_init+0x0/0x10 returned 0 after 5 usecs
[    0.244197] calling  ehci_hcd_init+0x0/0x80 @ 1
[    0.244199] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.244215] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.244230] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.244232] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.244296] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.248190] ehci_hcd 0000:00:1a.7: debug port 1
[    0.248239] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    0.248251] ehci_hcd 0000:00:1a.7: irq 18, io mem 0x90325c00
[    0.252194] calling  7_async_port_probe+0x0/0xf0 @ 548
[    0.252338] calling  8_async_port_probe+0x0/0xf0 @ 549
[    0.252385] async_waiting @ 549
[    0.258677] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.258836] usb usb1: configuration #1 chosen from 1 choice
[    0.258952] hub 1-0:1.0: USB hub found
[    0.259001] hub 1-0:1.0: 4 ports detected
[    0.259211] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.259271] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.259274] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.259366] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.263325] ehci_hcd 0000:00:1d.7: debug port 1
[    0.263373] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.263385] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x90325800
[    0.273817] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.273959] usb usb2: configuration #1 chosen from 1 choice
[    0.274075] hub 2-0:1.0: USB hub found
[    0.274123] hub 2-0:1.0: 6 ports detected
[    0.274315] initcall ehci_hcd_init+0x0/0x80 returned 0 after 29408 usecs
[    0.274366] calling  uhci_hcd_init+0x0/0xd0 @ 1
[    0.274412] uhci_hcd: USB Universal Host Controller Interface driver
[    0.274530] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.274586] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.274589] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.274674] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.274768] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000030c0
[    0.274916] usb usb3: configuration #1 chosen from 1 choice
[    0.275013] hub 3-0:1.0: USB hub found
[    0.275061] hub 3-0:1.0: 2 ports detected
[    0.275225] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.275280] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.275283] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.275378] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.275471] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000030a0
[    0.275617] usb usb4: configuration #1 chosen from 1 choice
[    0.275712] hub 4-0:1.0: USB hub found
[    0.275761] hub 4-0:1.0: 2 ports detected
[    0.275929] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.275984] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.275987] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.276083] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    0.276170] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
[    0.276315] usb usb5: configuration #1 chosen from 1 choice
[    0.276412] hub 5-0:1.0: USB hub found
[    0.276459] hub 5-0:1.0: 2 ports detected
[    0.276620] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.276674] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.276677] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.276768] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    0.276873] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
[    0.277016] usb usb6: configuration #1 chosen from 1 choice
[    0.277113] hub 6-0:1.0: USB hub found
[    0.277161] hub 6-0:1.0: 2 ports detected
[    0.277320] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.277375] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.277378] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.277468] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    0.277554] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
[    0.277697] usb usb7: configuration #1 chosen from 1 choice
[    0.277792] hub 7-0:1.0: USB hub found
[    0.277842] hub 7-0:1.0: 2 ports detected
[    0.278037] initcall uhci_hcd_init+0x0/0xd0 returned 0 after 3537 usecs
[    0.278088] calling  acm_init+0x0/0x150 @ 1
[    0.278173] usbcore: registered new interface driver cdc_acm
[    0.278222] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[    0.278293] initcall acm_init+0x0/0x150 returned 0 after 155 usecs
[    0.278343] calling  usblp_init+0x0/0x20 @ 1
[    0.278425] usbcore: registered new interface driver usblp
[    0.278475] initcall usblp_init+0x0/0x20 returned 0 after 84 usecs
[    0.278525] calling  usb_stor_init+0x0/0x50 @ 1
[    0.278570] Initializing USB Mass Storage driver...
[    0.278670] usbcore: registered new interface driver usb-storage
[    0.278720] USB Mass Storage support registered.
[    0.278766] initcall usb_stor_init+0x0/0x50 returned 0 after 190 usecs
[    0.278816] calling  i8042_init+0x0/0x440 @ 1
[    0.278974] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.281861] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.281911] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.281965] initcall i8042_init+0x0/0x440 returned 0 after 3025 usecs
[    0.282020] calling  mousedev_init+0x0/0x70 @ 1
[    0.282110] mice: PS/2 mouse device common for all mice
[    0.282159] initcall mousedev_init+0x0/0x70 returned 0 after 90 usecs
[    0.282209] calling  atkbd_init+0x0/0x30 @ 1
[    0.282289] initcall atkbd_init+0x0/0x30 returned 0 after 33 usecs
[    0.282342] calling  psmouse_init+0x0/0x80 @ 1
[    0.282448] initcall psmouse_init+0x0/0x80 returned 0 after 57 usecs
[    0.282498] calling  coretemp_init+0x0/0x1c0 @ 1
[    0.282611] coretemp coretemp.0: Using relative temperature scale!
[    0.282747] coretemp coretemp.1: Using relative temperature scale!
[    0.282840] initcall coretemp_init+0x0/0x1c0 returned 0 after 287 usecs
[    0.282891] calling  init_ladder+0x0/0x20 @ 1
[    0.282936] cpuidle: using governor ladder
[    0.282984] initcall init_ladder+0x0/0x20 returned 0 after 46 usecs
[    0.283034] calling  init_menu+0x0/0x20 @ 1
[    0.283078] cpuidle: using governor menu
[    0.283122] initcall init_menu+0x0/0x20 returned 0 after 42 usecs
[    0.283172] calling  init_soundcore+0x0/0x70 @ 1
[    0.283250] initcall init_soundcore+0x0/0x70 returned 0 after 31 usecs
[    0.283301] calling  alsa_sound_init+0x0/0x90 @ 1
[    0.283365] Advanced Linux Sound Architecture Driver Version 1.0.18a.
[    0.283416] initcall alsa_sound_init+0x0/0x90 returned 0 after 66 usecs
[    0.283467] calling  alsa_timer_init+0x0/0x1a0 @ 1
[    0.283555] initcall alsa_timer_init+0x0/0x1a0 returned 0 after 39 usecs
[    0.283606] calling  snd_hrtimer_init+0x0/0x120 @ 1
[    0.283654] initcall snd_hrtimer_init+0x0/0x120 returned 0 after 0 usecs
[    0.283705] calling  rtctimer_init+0x0/0x130 @ 1
[    0.283752] initcall rtctimer_init+0x0/0x130 returned 0 after 0 usecs
[    0.283802] calling  alsa_pcm_init+0x0/0x80 @ 1
[    0.283850] initcall alsa_pcm_init+0x0/0x80 returned 0 after 2 usecs
[    0.283900] calling  snd_mem_init+0x0/0x30 @ 1
[    0.283948] initcall snd_mem_init+0x0/0x30 returned 0 after 2 usecs
[    0.284587] calling  alsa_mixer_oss_init+0x0/0x40 @ 1
[    0.284635] initcall alsa_mixer_oss_init+0x0/0x40 returned 0 after 0 usecs
[    0.284687] calling  alsa_pcm_oss_init+0x0/0xa0 @ 1
[    0.284734] initcall alsa_pcm_oss_init+0x0/0xa0 returned 0 after 0 usecs
[    0.284785] calling  alsa_seq_oss_init+0x0/0x1b0 @ 1
[    0.284967] initcall alsa_seq_oss_init+0x0/0x1b0 returned 0 after 131 usecs
[    0.285022] calling  alsa_seq_init+0x0/0x60 @ 1
[    0.285119] initcall alsa_seq_init+0x0/0x60 returned 0 after 42 usecs
[    0.285170] calling  alsa_seq_device_init+0x0/0x60 @ 1
[    0.285219] initcall alsa_seq_device_init+0x0/0x60 returned 0 after 1 usecs
[    0.285271] calling  alsa_seq_midi_event_init+0x0/0x10 @ 1
[    0.285319] initcall alsa_seq_midi_event_init+0x0/0x10 returned 0 after 0 usecs
[    0.285386] calling  patch_realtek_init+0x0/0x20 @ 1
[    0.285434] initcall patch_realtek_init+0x0/0x20 returned 0 after 0 usecs
[    0.285485] calling  patch_cmedia_init+0x0/0x20 @ 1
[    0.285532] initcall patch_cmedia_init+0x0/0x20 returned 0 after 0 usecs
[    0.285583] calling  patch_analog_init+0x0/0x20 @ 1
[    0.285630] initcall patch_analog_init+0x0/0x20 returned 0 after 0 usecs
[    0.285681] calling  patch_sigmatel_init+0x0/0x20 @ 1
[    0.285728] initcall patch_sigmatel_init+0x0/0x20 returned 0 after 0 usecs
[    0.285780] calling  patch_si3054_init+0x0/0x20 @ 1
[    0.285827] initcall patch_si3054_init+0x0/0x20 returned 0 after 0 usecs
[    0.285879] calling  patch_atihdmi_init+0x0/0x20 @ 1
[    0.285926] initcall patch_atihdmi_init+0x0/0x20 returned 0 after 0 usecs
[    0.285984] calling  patch_conexant_init+0x0/0x20 @ 1
[    0.286031] initcall patch_conexant_init+0x0/0x20 returned 0 after 0 usecs
[    0.286082] calling  patch_via_init+0x0/0x20 @ 1
[    0.286129] initcall patch_via_init+0x0/0x20 returned 0 after 0 usecs
[    0.286180] calling  patch_intelhdmi_init+0x0/0x20 @ 1
[    0.286228] initcall patch_intelhdmi_init+0x0/0x20 returned 0 after 0 usecs
[    0.286280] calling  alsa_card_azx_init+0x0/0x20 @ 1
[    0.286362] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.286454] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    0.305230] input: AT Translated Set 2 keyboard as /class/input/input2
[    0.425268] ata7.00: ATAPI: HL-DT-ST DVDRAM GSA-4167B, DL11, max UDMA/33
[    0.439325] input: HDA Intel Line In at Ext Rear Jack as /class/input/input3
[    0.439444] input: HDA Intel Mic at Ext Front Jack as /class/input/input4
[    0.439564] input: HDA Intel Mic at Ext Rear Jack as /class/input/input5
[    0.439690] input: HDA Intel Mic at Ext Rear Jack as /class/input/input6
[    0.439799] input: HDA Intel Line In at Ext Rear Jack as /class/input/input7
[    0.439907] input: HDA Intel Line Out at Ext Rear Jack as /class/input/input8
[    0.440016] input: HDA Intel HP Out at Ext Front Jack as /class/input/input9
[    0.447803] ata7.00: configured for UDMA/33
[    0.450121] async_waiting @ 548
[    0.452774] initcall alsa_card_azx_init+0x0/0x20 returned 0 after 162544 usecs
[    0.452846] calling  alsa_sound_last_init+0x0/0x70 @ 1
[    0.452894] ALSA device list:
[    0.452938]   #0: HDA Intel at 0x90320000 irq 22
[    0.452996] initcall alsa_sound_last_init+0x0/0x70 returned 0 after 97 usecs
[    0.453048] calling  flow_cache_init+0x0/0x1f0 @ 1
[    0.453125] initcall flow_cache_init+0x0/0x1f0 returned 0 after 29 usecs
[    0.453177] calling  nf_conntrack_standalone_init+0x0/0x20 @ 1
[    0.453227] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.453467] initcall nf_conntrack_standalone_init+0x0/0x20 returned 0 after 233 usecs
[    0.453537] calling  xt_init+0x0/0xe0 @ 1
[    0.453590] initcall xt_init+0x0/0xe0 returned 0 after 0 usecs
[    0.453640] calling  tcpudp_mt_init+0x0/0x20 @ 1
[    0.453687] initcall tcpudp_mt_init+0x0/0x20 returned 0 after 1 usecs
[    0.453738] calling  state_mt_init+0x0/0x20 @ 1
[    0.453784] initcall state_mt_init+0x0/0x20 returned 0 after 0 usecs
[    0.453835] calling  sysctl_ipv4_init+0x0/0x60 @ 1
[    0.453888] initcall sysctl_ipv4_init+0x0/0x60 returned 0 after 7 usecs
[    0.453940] calling  xfrm4_beet_init+0x0/0x20 @ 1
[    0.453986] initcall xfrm4_beet_init+0x0/0x20 returned 0 after 0 usecs
[    0.454037] calling  xfrm4_transport_init+0x0/0x20 @ 1
[    0.454084] initcall xfrm4_transport_init+0x0/0x20 returned 0 after 0 usecs
[    0.454135] calling  xfrm4_mode_tunnel_init+0x0/0x20 @ 1
[    0.454183] initcall xfrm4_mode_tunnel_init+0x0/0x20 returned 0 after 0 usecs
[    0.454237] calling  ipv4_netfilter_init+0x0/0x20 @ 1
[    0.454285] initcall ipv4_netfilter_init+0x0/0x20 returned 0 after 0 usecs
[    0.454336] calling  nf_conntrack_l3proto_ipv4_init+0x0/0x170 @ 1
[    0.454404] initcall nf_conntrack_l3proto_ipv4_init+0x0/0x170 returned 0 after 17 usecs
[    0.454473] calling  nf_defrag_init+0x0/0x20 @ 1
[    0.454519] initcall nf_defrag_init+0x0/0x20 returned 0 after 0 usecs
[    0.454569] calling  ip_tables_init+0x0/0xc0 @ 1
[    0.454622] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.454669] initcall ip_tables_init+0x0/0xc0 returned 0 after 50 usecs
[    0.454720] calling  iptable_filter_init+0x0/0x80 @ 1
[    0.454774] initcall iptable_filter_init+0x0/0x80 returned 0 after 7 usecs
[    0.454825] calling  ip_queue_init+0x0/0x150 @ 1
[    0.454881] initcall ip_queue_init+0x0/0x150 returned 0 after 9 usecs
[    0.454931] calling  inet_diag_init+0x0/0x70 @ 1
[    0.454980] initcall inet_diag_init+0x0/0x70 returned 0 after 2 usecs
[    0.455030] calling  tcp_diag_init+0x0/0x20 @ 1
[    0.455076] initcall tcp_diag_init+0x0/0x20 returned 0 after 0 usecs
[    0.455126] calling  cubictcp_register+0x0/0x80 @ 1
[    0.455172] TCP cubic registered
[    0.455215] initcall cubictcp_register+0x0/0x80 returned 0 after 41 usecs
[    0.455266] calling  packet_init+0x0/0x50 @ 1
[    0.455312] NET: Registered protocol family 17
[    0.455359] initcall packet_init+0x0/0x50 returned 0 after 46 usecs
[    0.455409] calling  ipsec_pfkey_init+0x0/0x90 @ 1
[    0.455455] NET: Registered protocol family 15
[    0.455504] initcall ipsec_pfkey_init+0x0/0x90 returned 0 after 47 usecs
[    0.455556] calling  hpet_insert_resource+0x0/0x30 @ 1
[    0.455609] initcall hpet_insert_resource+0x0/0x30 returned 0 after 1 usecs
[    0.455660] calling  update_mp_table+0x0/0x530 @ 1
[    0.455707] initcall update_mp_table+0x0/0x530 returned 0 after 0 usecs
[    0.455758] calling  lapic_insert_resource+0x0/0x50 @ 1
[    0.455806] initcall lapic_insert_resource+0x0/0x50 returned 0 after 0 usecs
[    0.455858] calling  init_lapic_nmi_sysfs+0x0/0x40 @ 1
[    0.455905] initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 usecs
[    0.455957] calling  ioapic_insert_resources+0x0/0x60 @ 1
[    0.456006] initcall ioapic_insert_resources+0x0/0x60 returned 0 after 0 usecs
[    0.456074] calling  io_apic_bug_finalize+0x0/0x20 @ 1
[    0.456121] initcall io_apic_bug_finalize+0x0/0x20 returned 0 after 0 usecs
[    0.456173] calling  check_early_ioremap_leak+0x0/0x70 @ 1
[    0.456221] initcall check_early_ioremap_leak+0x0/0x70 returned 0 after 0 usecs
[    0.456289] calling  pat_memtype_list_init+0x0/0x30 @ 1
[    0.456341] initcall pat_memtype_list_init+0x0/0x30 returned 0 after 3 usecs
[    0.456392] calling  sched_init_debug+0x0/0x30 @ 1
[    0.456442] initcall sched_init_debug+0x0/0x30 returned 0 after 3 usecs
[    0.456494] calling  init_oops_id+0x0/0x40 @ 1
[    0.456544] initcall init_oops_id+0x0/0x40 returned 0 after 4 usecs
[    0.456597] calling  disable_boot_consoles+0x0/0x40 @ 1
[    0.456645] initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 usecs
[    0.456698] calling  pm_qos_power_init+0x0/0x90 @ 1
[    0.456862] initcall pm_qos_power_init+0x0/0x90 returned 0 after 113 usecs
[    0.456914] calling  max_swapfiles_check+0x0/0x10 @ 1
[    0.456962] initcall max_swapfiles_check+0x0/0x10 returned 0 after 0 usecs
[    0.457014] calling  random32_reseed+0x0/0xc0 @ 1
[    0.457078] initcall random32_reseed+0x0/0xc0 returned 0 after 18 usecs
[    0.457129] calling  pci_sysfs_init+0x0/0x60 @ 1
[    0.457281] initcall pci_sysfs_init+0x0/0x60 returned 0 after 102 usecs
[    0.457332] calling  acpi_wakeup_device_init+0x0/0xa0 @ 1
[    0.457383] initcall acpi_wakeup_device_init+0x0/0xa0 returned 0 after 2 usecs
[    0.457451] calling  acpi_sleep_proc_init+0x0/0x7e @ 1
[    0.457522] initcall acpi_sleep_proc_init+0x0/0x7e returned 0 after 18 usecs
[    0.457574] calling  seqgen_init+0x0/0x10 @ 1
[    0.457630] initcall seqgen_init+0x0/0x10 returned 0 after 11 usecs
[    0.457682] calling  scsi_complete_async_scans+0x0/0x120 @ 1
[    0.457731] initcall scsi_complete_async_scans+0x0/0x120 returned 0 after 0 usecs
[    0.457799] calling  memmap_init+0x0/0xb0 @ 1
[    0.457884] initcall memmap_init+0x0/0xb0 returned 0 after 38 usecs
[    0.457935] calling  pci_mmcfg_late_insert_resources+0x0/0x180 @ 1
[    0.457986] initcall pci_mmcfg_late_insert_resources+0x0/0x180 returned 0 after 1 usecs
[    0.458056] calling  tcp_congestion_default+0x0/0x20 @ 1
[    0.458104] initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 usecs
[    0.506549] Switched to high resolution mode on CPU 1
[    0.506681] Switched to high resolution mode on CPU 0
[    0.550034] ata1: SATA link down (SStatus 0 SControl 300)
[    0.550091] async_waiting @ 535
[    0.550135] async_continuing @ 535 after 0 usec
[    0.550186] initcall 1_async_port_probe+0x0/0xf0 returned 0 after 299414 usecs
[    0.550285] ata2: SATA link down (SStatus 0 SControl 300)
[    0.550340] async_waiting @ 537
[    0.550383] async_continuing @ 537 after 0 usec
[    0.550429] initcall 2_async_port_probe+0x0/0xf0 returned 0 after 299569 usecs
[    0.550505] async_continuing @ 539 after 299429 usec
[    0.550553] initcall 3_async_port_probe+0x0/0xf0 returned 0 after 299523 usecs
[    0.550626] async_continuing @ 541 after 299314 usec
[    0.550674] initcall 4_async_port_probe+0x0/0xf0 returned 0 after 299537 usecs
[    0.966034] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.966575] ata5.00: ATA-7: WDC WD1600AAJS-60PSA0, 21.12M21, max UDMA/100
[    0.966629] ata5.00: 312581808 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    0.967055] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.967265] ata5.00: configured for UDMA/100
[    0.967318] async_waiting @ 543
[    0.967371] async_continuing @ 543 after 0 usec
[    0.967509] scsi 4:0:0:0: Direct-Access     ATA      WDC WD1600AAJS-6 21.1 PQ: 0 ANSI: 5
[    0.967660] calling  9_sd_probe_async+0x0/0x260 @ 541
[    0.967816] sd 4:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    0.967898] sd 4:0:0:0: [sda] Write Protect is off
[    0.967945] sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.967967] sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.968101] sd 4:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    0.968756] sd 4:0:0:0: [sda] Write Protect is off
[    0.968808] sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.968830] sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.968903]  sda:<5>sd 4:0:0:0: Attached scsi generic sg0 type 0
[    0.969032] initcall 5_async_port_probe+0x0/0xf0 returned 0 after 707981 usecs
[    0.974288]  sda1 sda2 sda3 < sda5 sda6 sda7 sda8<6>ata6.00: ATA-7: MAXTOR STM3160215AS, 3.AAD, max UDMA/133
[    1.015548] ata6.00: 312581808 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.029357]  sda9 >
[    1.029920] sd 4:0:0:0: [sda] Attached SCSI disk
[    1.029968] initcall 9_sd_probe_async+0x0/0x260 returned 0 after 60798 usecs
[    1.034291] input: ImPS/2 Logitech Wheel Mouse as /class/input/input10
[    1.059151] async_waiting @ 1
[    1.073797] ata6.00: configured for UDMA/133
[    1.073851] async_waiting @ 545
[    1.073895] async_continuing @ 545 after 0 usec
[    1.074010] scsi 5:0:0:0: Direct-Access     ATA      MAXTOR STM316021 3.AA PQ: 0 ANSI: 5
[    1.074160] calling  10_sd_probe_async+0x0/0x260 @ 537
[    1.074292] sd 5:0:0:0: [sdb] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    1.074372] sd 5:0:0:0: [sdb] Write Protect is off
[    1.074418] sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.074439] sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.074556] sd 5:0:0:0: [sdb] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    1.074635] sd 5:0:0:0: [sdb] Write Protect is off
[    1.074681] sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.074702] sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.074774]  sdb:<5>sd 5:0:0:0: Attached scsi generic sg1 type 0
[    1.074886] initcall 6_async_port_probe+0x0/0xf0 returned 0 after 810567 usecs
[    1.074961] async_continuing @ 548 after 610151 usec
[    1.075026] isa bounce pool size: 16 pages
[    1.078760] scsi 6:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL11 PQ: 0 ANSI: 5
[    1.091515] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.091587] Uniform CD-ROM driver Revision: 3.20
[    1.091768] sr 6:0:0:0: Attached scsi CD-ROM sr0
[    1.091859] sr 6:0:0:0: Attached scsi generic sg2 type 5
[    1.091911] initcall 7_async_port_probe+0x0/0xf0 returned 0 after 819987 usecs
[    1.091982] async_continuing @ 549 after 819878 usec
[    1.092041] async_waiting @ 549
[    1.092082] async_continuing @ 549 after 0 usec
[    1.092129] initcall 8_async_port_probe+0x0/0xf0 returned 0 after 820061 usecs
[    1.092200] async_continuing @ 1 after 32229 usec
[    1.092246] async_waiting @ 1
[    1.121797]  sdb1 sdb2 < sdb5 >
[    1.149968] sd 5:0:0:0: [sdb] Attached SCSI disk
[    1.150020] initcall 10_sd_probe_async+0x0/0x260 returned 0 after 74033 usecs
[    1.150075] async_continuing @ 1 after 56433 usec
[    1.185836] kjournald starting.  Commit interval 5 seconds
[    1.185843] EXT3-fs: mounted filesystem with ordered data mode.
[    1.185853] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
[    1.185873] async_waiting @ 1
[    1.185875] async_continuing @ 1 after 0 usec
[    1.185877] Freeing unused kernel memory: 384k freed
[    3.166191] calling  e1000_init_module+0x0/0x75 [e1000e] @ 1275
[    3.166194] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    3.166196] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    3.166242] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.166250] e1000e 0000:00:19.0: setting latency timer to 64
[    3.166334] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[    3.190832] calling  rtl8139_init_module+0x0/0x2e [8139too] @ 1317
[    3.190835] 8139too Fast Ethernet driver 0.9.28
[    3.190869] 8139too 0000:06:01.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.191265] eth0: RealTek RTL8139 at 0xffffc200080ca000, 00:e0:4c:f0:a9:84, IRQ 22
[    3.191267] eth0:  Identified 8139 chip type 'RTL-8139C'
[    3.191285] initcall rtl8139_init_module+0x0/0x2e [8139too] returned 0 after 437 usecs
[    3.192604] udev: renamed network interface eth0 to eth1
[    3.350299] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:19:d1:00:44:f5
[    3.350302] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.350326] 0000:00:19.0: eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff
[    3.350367] initcall e1000_init_module+0x0/0x75 [e1000e] returned 0 after 179846 usecs
[    3.853266] EXT3 FS on sda2, internal journal
[    4.050098] calling  vmx_init+0x0/0x290 [kvm_intel] @ 1488
[    4.050326] initcall vmx_init+0x0/0x290 [kvm_intel] returned 0 after 216 usecs
[    5.054551] kjournald starting.  Commit interval 5 seconds
[    5.054706] EXT3 FS on sda5, internal journal
[    5.054711] EXT3-fs: mounted filesystem with ordered data mode.
[    5.081239] kjournald starting.  Commit interval 5 seconds
[    5.081715] EXT3 FS on sda6, internal journal
[    5.081720] EXT3-fs: mounted filesystem with ordered data mode.
[    5.101165] kjournald starting.  Commit interval 5 seconds
[    5.101333] EXT3 FS on sda8, internal journal
[    5.101337] EXT3-fs: mounted filesystem with ordered data mode.
[    5.158682] calling  init_xfs_fs+0x0/0xb7 [xfs] @ 1523
[    5.158686] SGI XFS with security attributes, large block/inode numbers, no debug enabled
[    5.159073] initcall init_xfs_fs+0x0/0xb7 [xfs] returned 0 after 365 usecs
[    5.186724] XFS mounting filesystem sda9
[    5.263313] Ending clean XFS mount for filesystem: sda9
[    5.374166] Adding 995988k swap on /dev/sda7.  Priority:-1 extents:1 across:995988k 
[   10.252206] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   10.303066] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   21.187766] eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
[   21.217334] [drm:i915_initialize] *ERROR* can not ioremap virtual address for ring buffer
[   21.217368] [drm:drm_unlock] *ERROR* Process 4087 using kernel context 0
[   36.207478] calling  nf_nat_init+0x0/0x124 [nf_nat] @ 5216
[   36.207538] initcall nf_nat_init+0x0/0x124 [nf_nat] returned 0 after 53 usecs
[   36.213315] calling  nf_nat_standalone_init+0x0/0x8e [iptable_nat] @ 5216
[   36.213328] initcall nf_nat_standalone_init+0x0/0x8e [iptable_nat] returned 0 after 8 usecs
[   36.220194] calling  masquerade_tg_init+0x0/0x3c [ipt_MASQUERADE] @ 5224
[   36.220202] initcall masquerade_tg_init+0x0/0x3c [ipt_MASQUERADE] returned 0 after 3 usecs


-- 
	Paolo Ornati
	Linux 2.6.29-rc5-00206-g402a917 on x86_64
