Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZBGChE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZBGChE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 21:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZBGCgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 21:36:53 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:35251 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZBGCgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 21:36:52 -0500
Subject: LS21 + HPET = boot hang (since 2.6.24-rc1)
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Clark Williams <williams@redhat.com>
Content-Type: multipart/mixed; boundary="=-AVHMp6VSbnDUED53qGqJ"
Date: Fri, 06 Feb 2009 18:36:49 -0800
Message-Id: <1233974209.7141.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AVHMp6VSbnDUED53qGqJ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Thomas, 
	Just a heads up, Clark noted that on LS21s if the HPET is enabled in
the BIOS, recent kernels hang at boot.

I booted the current -git up after enabling HPET and sure enough:

ENABLING IO-APIC IRQs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 2) ...
....... failed.
...trying to set up timer as Virtual Wire IRQ...
..... failed.
...trying to set up timer as ExtINT IRQ...
..... failed :(.
Kernel panic - not syncing: IO-APIC + timer doesn't work!  Boot with
apic=debug and send a report.  Then try booting with the 'noapic'
option.


Full boot log attached. Disabling the HPET in the BIOS boots up fine.

I then did some rough bisection to see when this showed up and
apparently it hit sometime between 2.6.23 and 2.6.24-rc1.

I'll do some further bisection on it next week, but if you have any
quick ideas let me know. 

thanks
-john


--=-AVHMp6VSbnDUED53qGqJ
Content-Disposition: attachment; filename=boot.log
Content-Type: text/x-log; name=boot.log; charset=UTF-8
Content-Transfer-Encoding: 7bit

Probing EDD (edd=off to disable)...Linux version 2.6.29-rc3john (jstultz@kernel)
 (gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu3)) #8 SMP PREEMPT Fri Feb 6 16:32:39 PST 2009
Command line: root=/dev/sda3 ro crashkernel=128M@32M console=tty1 console=ttyS1,19200  apic=debug
KERNEL supported cpus:
   Intel GenuineIntel
   AMD AuthenticAMD
   Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009c000 (usable)
 BIOS-e820: 000000000009c000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cffa3a00 (usable)
 BIOS-e820: 00000000cffa3a00 - 00000000cffa7400 (ACPI data)                   [
 BIOS-e820: 00000000cffa7400 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000f4000000 - 00000000fc000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
DMI 2.4 present.
last_pfn = 0x230000 max_arch_pfn = 0x100000000
last_pfn = 0xcffa3 max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-00000000cffa3000
last_map_addr: cffa3000 end: cffa3000
init_memory_mapping: 0000000100000000-0000000230000000
last_map_addr: 230000000 end: 230000000
RAMDISK: 37d8a000 - 37fef34b
ACPI: RSDP 000FDFE0, 0014 (r0 IBM   )
ACPI: RSDT CFFA7380, 0034 (r1 IBM    SERLEWIS     1000 IBM  45444F43)
ACPI: FACP CFFA72C0, 0084 (r2 IBM    SERLEWIS     1000 IBM  45444F43)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
FADT: X_PM1b_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT CFFA3A00, 35FC (r1 IBM    SERLEWIS     1000 INTL 20060912)
ACPI: FACS CFFA7080, 0040
ACPI: APIC CFFA7200, 0090 (r1 IBM    SERLEWIS     1000 IBM  45444F43)
ACPI: SRAT CFFA7100, 00E8 (r1 AMD    HAMMER          1 AMD         1)
ACPI: HPET CFFA70C0, 0038 (r1 IBM    SERLEWIS     1000 IBM  45444F43)
(7 early reservations) ==> bootmem [0000000000 - 0230000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 0001e96558]    TEXT DATA BSS ==> [0001000000 - 0001e96558]
  #3 [0037d8a000 - 0037fef34b]          RAMDISK ==> [0037d8a000 - 0037fef34b]
  #4 [000009c000 - 0000100000]    BIOS reserved ==> [000009c000 - 0000100000]
  #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
  #6 [000000c000 - 0000011000]          PGTABLE ==> [000000c000 - 0000011000]
Scan SMP from ffff880000000000 for 1024 bytes.
Scan SMP from ffff88000009fc00 for 1024 bytes.
Scan SMP from ffff8800000f0000 for 65536 bytes.
Scan SMP from ffff88000009c000 for 1024 bytes.
found SMP MP-table at [ffff88000009c140] 0009c140
Reserving 128MB of memory at 32MB for crashkernel (System RAM: 8960MB)
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00230000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009c
    0: 0x00000100 -> 0x000cffa3
    0: 0x00100000 -> 0x00230000
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x488
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, version 0, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x0d] address[0xfec02000] gsi_base[16])
IOAPIC[1]: apic_id 13, version 0, address 0xfec02000, GSI 16-31
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x1166a201 base: 0xfed00000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
mapped APIC to ffffffffff5fc000 (fee00000)
mapped IOAPIC to ffffffffff5fb000 (fec00000)
mapped IOAPIC to ffffffffff5fa000 (fec02000)
Allocating PCI resources starting at d4000000 (gap: d0000000:24000000)
NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Allocating 40960 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2065485
Kernel command line: root=/dev/sda3 ro crashkernel=128M@32M console=tty1 console=ttyS1,19200  apic=debug
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 32768 bytes)
Fast TSC calibration using PIT
Detected 2600.065 MHz processor.
Console: colour VGA+ 80x25
console [tty1] enabled
console [ttyS1] enabled
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ f4000000 size 64 MB
Node 1: aperture @ f4000000 size 64 MB
Memory: 8098608k/9175040k available (8336k kernel code, 787204k absent, 288288k reserved, 4652k data, 496k init)
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 5200.13 BogoMIPS (lpj=2600065)
Security Framework initialized
SELinux:  Initializing.
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
ACPI: Core revision 20081204
Setting APIC routing to flat
Getting VERSION: 80050010
Getting VERSION: 80050010
Getting ID: 0
Getting ID: ff000000
Getting LVT0: 700
Getting LVT1: 400
enabled ExtINT on CPU#0
ESR value before enabling vector: 0x00000004  after: 0x00000000
ENABLING IO-APIC IRQs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 2) ...
....... failed.
...trying to set up timer as Virtual Wire IRQ...
..... failed.
...trying to set up timer as ExtINT IRQ...
..... failed :(.
Kernel panic - not syncing: IO-APIC + timer doesn't work!  Boot with apic=debug and send a report.  Then try booting with the 'noapic' option.

------------[ cut here ]------------
WARNING: at kernel/smp.c:329 smp_call_function_many+0x1c4/0x220()
Hardware name: BladeCenter LS21 -[7971AC1]-
Pid: 1, comm: swapper Not tainted 2.6.29-rc3john #8
Call Trace:
 [<ffffffff81046817>] warn_slowpath+0xd7/0x100
 [<ffffffff818207d0>] ? _spin_unlock+0x10/0x40
 [<ffffffff813139ac>] ? vt_console_print+0x22c/0x2f0
 [<ffffffff81046e26>] ? __call_console_drivers+0x66/0x80
 [<ffffffff81820442>] ? _spin_lock_irqsave+0x22/0x50
 [<ffffffff81820892>] ? _spin_unlock_irqrestore+0x12/0x40
 [<ffffffff810608a5>] ? up+0x35/0x50
 [<ffffffff81820892>] ? _spin_unlock_irqrestore+0x12/0x40
 [<ffffffff81047084>] ? release_console_sem+0x1d4/0x1f0
 [<ffffffff81047641>] ? vprintk+0x2c1/0x3f0
 [<ffffffff81046e26>] ? __call_console_drivers+0x66/0x80
 [<ffffffff810477d7>] ? printk+0x67/0x70
 [<ffffffff8106d244>] smp_call_function_many+0x1c4/0x220
 [<ffffffff810140a0>] ? stop_this_cpu+0x0/0x30
 [<ffffffff810608a5>] ? up+0x35/0x50
 [<ffffffff810140a0>] ? stop_this_cpu+0x0/0x30
 [<ffffffff8106d2df>] smp_call_function+0x3f/0x80
 [<ffffffff81022103>] native_smp_send_stop+0x23/0x40
 [<ffffffff81046909>] panic+0xb9/0x180
 [<ffffffff8129e55f>] ? delay_tsc+0x6f/0xb0
 [<ffffffff8129e3fa>] ? __delay+0xa/0x10
 [<ffffffff8129e449>] ? __const_udelay+0x49/0x50
 [<ffffffff81ced49b>] setup_IO_APIC+0x85b/0x860
 [<ffffffff810246cd>] ? clear_IO_APIC+0x3d/0x70
 [<ffffffff81023f39>] ? setup_apic_nmi_watchdog+0x49/0xc0
 [<ffffffff81ce946a>] native_smp_prepare_cpus+0x3aa/0x430
 [<ffffffff81cd9958>] kernel_init+0x58/0x1b0
 [<ffffffff8100d4ea>] child_rip+0xa/0x20
 [<ffffffff81cd9900>] ? kernel_init+0x0/0x1b0
 [<ffffffff8100d4e0>] ? child_rip+0x0/0x20
---[ end trace 4eaa2a86a8e2da22 ]---


--=-AVHMp6VSbnDUED53qGqJ--

