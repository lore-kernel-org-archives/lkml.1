Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbYJ3LOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbYJ3LOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbYJ3LN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:13:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:29193 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYJ3LN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=UJC+oYBGhhDHleIncnmfU9vqEACkVRLykuAOHtI/2NP1r+UUZ1ATOqOrVHZmJVH9pJ
         CvjblkfCHCINXfCBad9PbhcawTbRdGCY24ydiQZ2qVUbtTlfL/d6sTmr1uN5cZkJlgCp
         T3Ke2h2AzALpckXT0x+1P1ZUx7aDu/ytT7K0w=
Message-ID: <f3642e6b0810300413u47398c0do76098b8fa1242d74@mail.gmail.com>
Date: Thu, 30 Oct 2008 12:13:55 +0100
From: "Andreas Hartmetz" <ahartmetz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: RE: RAID ate my PCIe-PCI bridge's MMIO address space (?)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore my amateurish guessing about the cause of the ALSA breakage
from the previous mail - booting from live CD without the "quiet" option
leads to the same shpchp error message in syslog, but the soundcard still
works. Maybe I should just reinstall and see what happens :/
Anyway, here's the /var/log/syslog produced by booting the live CD *without*
quiet:

Oct 30 11:56:21 ubuntu syslogd 1.5.0#2ubuntu6: restart.
Oct 30 11:56:21 ubuntu kernel: Inspecting /boot/System.map-2.6.27-7-generic
Oct 30 11:56:21 ubuntu kernel: Cannot find map file.
Oct 30 11:56:22 ubuntu kernel: Loaded 50972 symbols from 87 modules.
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Initializing cgroup subsys cpuset
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Initializing cgroup subsys cpu
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Linux version
2.6.27-7-generic (buildd@yellow) (gcc version 4.3.2 (Ubuntu
4.3.2-1ubuntu10) ) #1 SMP Fri Oct 24 06:40:41 UTC 2008 (Ubuntu
2.6.27-7.14-generic)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Command line:
BOOT_IMAGE=/casper/vmlinuz file=/cdrom/preseed/kubuntu.seed
boot=casper initrd=/casper/initrd.gz nosplash --
debian-installer/language=de console-setup/layoutcode?=de
Oct 30 11:56:22 ubuntu kernel: [    0.000000] KERNEL supported cpus:
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   Intel GenuineIntel
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   AMD AuthenticAMD
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   Centaur CentaurHauls
Oct 30 11:56:22 ubuntu kernel: [    0.000000] BIOS-provided physical RAM map:
Oct 30 11:56:22 ubuntu kernel: [    0.000000]  BIOS-e820:
0000000000000000 - 000000000009f800 (usable)
Oct 30 11:56:22 ubuntu kernel: [    0.000000]  BIOS-e820:
000000000009f800 - 00000000000a0000 (reserved)
Oct 30 11:56:22 ubuntu kernel: [    0.000000]  BIOS-e820:
00000000000f0000 - 0000000000100000 (reserved)
Oct 30 11:56:22 ubuntu kernel: [    0.000000]  BIOS-e820:
0000000000100000 - 0000000077de0000 (usable)
Oct 30 11:56:22 ubuntu kernel: [    0.000000]  BIOS-e820:
0000000077de0000 - 0000000077de3000 (ACPI NVS)
Oct 30 11:56:22 ubuntu kernel: [    0.000000]  BIOS-e820:
0000000077de3000 - 0000000077df0000 (ACPI data)
Oct 30 11:56:22 ubuntu kernel: [    0.000000]  BIOS-e820:
0000000077df0000 - 0000000077e00000 (reserved)
Oct 30 11:56:22 ubuntu kernel: [    0.000000]  BIOS-e820:
00000000e0000000 - 00000000f0000000 (reserved)
Oct 30 11:56:22 ubuntu kernel: [    0.000000]  BIOS-e820:
00000000fec00000 - 0000000100000000 (reserved)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] last_pfn = 0x77de0
max_arch_pfn = 0x3ffffffff
Oct 30 11:56:22 ubuntu kernel: [    0.000000] init_memory_mapping
Oct 30 11:56:22 ubuntu kernel: [    0.000000]  0000000000 - 0077c00000 page 2M
Oct 30 11:56:22 ubuntu kernel: [    0.000000]  0077c00000 - 0077de0000 page 4k
Oct 30 11:56:22 ubuntu kernel: [    0.000000] kernel direct mapping
tables up to 77de0000 @ 8000-c000
Oct 30 11:56:22 ubuntu kernel: [    0.000000] last_map_addr: 77de0000
end: 77de0000
Oct 30 11:56:22 ubuntu kernel: [    0.000000] RAMDISK: 774e8000 - 77daf3c0
Oct 30 11:56:22 ubuntu kernel: [    0.000000] DMI 2.4 present.
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: RSDP 000F71C0,
0014 (r0 GBT   )
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: RSDT 77DE3000,
0038 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: FACP 77DE3040,
0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: DSDT 77DE30C0,
6550 (r1 GBT    GBTUACPI     1000 MSFT  3000000)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: FACS 77DE0000, 0040
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: SSDT 77DE9700,
0544 (r1 PTLTD  POWERNOW        1  LTP        1)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: HPET 77DE9C80,
0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: MCFG 77DE9CC0,
003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: APIC 77DE9640,
0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Scanning NUMA topology
in Northbridge 24
Oct 30 11:56:22 ubuntu kernel: [    0.000000] No NUMA configuration found
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Faking a node at
0000000000000000-0000000077de0000
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Bootmem setup node 0
0000000000000000-0000000077de0000
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   NODE_DATA
[0000000000001000 - 0000000000005fff]
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   bootmap
[000000000000a000 -  0000000000018fbf] pages f
Oct 30 11:56:22 ubuntu kernel: [    0.000000] (6 early reservations)
==> bootmem [0000000000 - 0077de0000]
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   #0 [0000000000 -
0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   #1 [0000006000 -
0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   #2 [0000200000 -
00008b8f9c]    TEXT DATA BSS ==> [0000200000 - 00008b8f9c]
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   #3 [00774e8000 -
0077daf3c0]          RAMDISK ==> [00774e8000 - 0077daf3c0]
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   #4 [000009f800 -
0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   #5 [0000008000 -
000000a000]          PGTABLE ==> [0000008000 - 000000a000]
Oct 30 11:56:22 ubuntu kernel: [    0.000000] found SMP MP-table at
[ffff8800000f5840] 000f5840
Oct 30 11:56:22 ubuntu kernel: [    0.000000]
[ffffe20000000000-ffffe20001dfffff] PMD ->
[ffff880001200000-ffff880002ffffff] on node 0
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Zone PFN ranges:
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   DMA      0x00000000 ->
0x00001000
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   DMA32    0x00001000 ->
0x00100000
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   Normal   0x00100000 ->
0x00100000
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Movable zone start PFN
for each node
Oct 30 11:56:22 ubuntu kernel: [    0.000000] early_node_map[2] active
PFN ranges
Oct 30 11:56:22 ubuntu kernel: [    0.000000]     0: 0x00000000 -> 0x0000009f
Oct 30 11:56:22 ubuntu kernel: [    0.000000]     0: 0x00000100 -> 0x00077de0
Oct 30 11:56:22 ubuntu kernel: [    0.000000] On node 0 totalpages: 490879
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   DMA zone: 2112 pages,
LIFO batch:0
Oct 30 11:56:22 ubuntu kernel: [    0.000000]   DMA32 zone: 479272
pages, LIFO batch:31
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x4008
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: Local APIC address
0xfee00000
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x00] lapic_id[0x00] enabled)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x01] lapic_id[0x01] enabled)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x02] lapic_id[0x02] enabled)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x03] lapic_id[0x03] enabled)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0x00] dfl dfl lint[0x1])
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0x01] dfl dfl lint[0x1])
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0x02] dfl dfl lint[0x1])
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0x03] dfl dfl lint[0x1])
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: IOAPIC (id[0x02]
address[0xfec00000] gsi_base[0])
Oct 30 11:56:22 ubuntu kernel: [    0.000000] IOAPIC[0]: apic_id 2,
version 0, address 0xfec00000, GSI 0-23
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0
bus_irq 0 global_irq 2 dfl dfl)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0
bus_irq 9 global_irq 9 low level)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: IRQ0 used by override.
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: IRQ2 used by override.
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: IRQ9 used by override.
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Setting APIC routing to flat
Oct 30 11:56:22 ubuntu kernel: [    0.000000] ACPI: HPET id:
0x10b9a201 base: 0xfed00000
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Using ACPI (MADT) for
SMP configuration information
Oct 30 11:56:22 ubuntu kernel: [    0.000000] SMP: Allowing 4 CPUs, 0
hotplug CPUs
Oct 30 11:56:22 ubuntu kernel: [    0.000000] PM: Registered nosave
memory: 000000000009f000 - 00000000000a0000
Oct 30 11:56:22 ubuntu kernel: [    0.000000] PM: Registered nosave
memory: 00000000000a0000 - 00000000000f0000
Oct 30 11:56:22 ubuntu kernel: [    0.000000] PM: Registered nosave
memory: 00000000000f0000 - 0000000000100000
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Allocating PCI resources
starting at 78000000 (gap: 77e00000:68200000)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] PERCPU: Allocating 64928
bytes of per cpu data
Oct 30 11:56:22 ubuntu kernel: [    0.000000] NR_CPUS: 64, nr_cpu_ids:
4, nr_node_ids 1
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Built 1 zonelists in
Node order, mobility grouping on.  Total pages: 481384
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Policy zone: DMA32
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Kernel command line:
BOOT_IMAGE=/casper/vmlinuz file=/cdrom/preseed/kubuntu.seed
boot=casper initrd=/casper/initrd.gz nosplash --
debian-installer/language=de console-setup/layoutcode?=de
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Initializing CPU#0
Oct 30 11:56:22 ubuntu kernel: [    0.000000] PID hash table entries:
4096 (order: 12, 32768 bytes)
Oct 30 11:56:22 ubuntu kernel: [    0.000000] TSC: PIT calibration
confirmed by PMTIMER.
Oct 30 11:56:22 ubuntu kernel: [    0.000000] TSC: using PIT calibration value
Oct 30 11:56:22 ubuntu kernel: [    0.000000] Detected 2004.255 MHz processor.
Oct 30 11:56:22 ubuntu kernel: [    0.004000] Console: colour VGA+ 80x25
Oct 30 11:56:22 ubuntu kernel: [    0.004000] console [tty0] enabled
Oct 30 11:56:22 ubuntu kernel: [    0.004000] Checking aperture...
Oct 30 11:56:22 ubuntu kernel: [    0.004000] No AGP bridge found
Oct 30 11:56:22 ubuntu kernel: [    0.004000] Node 0: aperture @
5086000000 size 32 MB
Oct 30 11:56:22 ubuntu kernel: [    0.004000] Aperture beyond 4GB. Ignoring.
Oct 30 11:56:22 ubuntu kernel: [    0.004000] Memory:
1916492k/1963904k available (3112k kernel code, 47024k reserved, 1575k
data, 536k init)
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPA: page pool
initialized 1 of 1 pages preallocated
Oct 30 11:56:22 ubuntu kernel: [    0.004000] SLUB: Genslabs=13,
HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Oct 30 11:56:22 ubuntu kernel: [    0.004000] hpet clockevent registered
Oct 30 11:56:22 ubuntu kernel: [    0.004008] Calibrating delay loop
(skipped), value calculated using timer frequency.. 4008.50 BogoMIPS
(lpj=8017008)
Oct 30 11:56:22 ubuntu kernel: [    0.004092] Security Framework initialized
Oct 30 11:56:22 ubuntu kernel: [    0.004129] SELinux:  Disabled at boot.
Oct 30 11:56:22 ubuntu kernel: [    0.004172] AppArmor: AppArmor initialized
Oct 30 11:56:22 ubuntu kernel: [    0.004388] Dentry cache hash table
entries: 262144 (order: 9, 2097152 bytes)
Oct 30 11:56:22 ubuntu kernel: [    0.005248] Inode-cache hash table
entries: 131072 (order: 8, 1048576 bytes)
Oct 30 11:56:22 ubuntu kernel: [    0.005625] Mount-cache hash table
entries: 256
Oct 30 11:56:22 ubuntu kernel: [    0.005803] Initializing cgroup subsys ns
Oct 30 11:56:22 ubuntu kernel: [    0.005838] Initializing cgroup subsys cpuacct
Oct 30 11:56:22 ubuntu kernel: [    0.005872] Initializing cgroup subsys memory
Oct 30 11:56:22 ubuntu kernel: [    0.005916] CPU: L1 I Cache: 64K (64
bytes/line), D cache 64K (64 bytes/line)
Oct 30 11:56:22 ubuntu kernel: [    0.005951] CPU: L2 Cache: 512K (64
bytes/line)
Oct 30 11:56:22 ubuntu kernel: [    0.005984] CPU 0/0 -> Node 0
Oct 30 11:56:22 ubuntu kernel: [    0.006017] tseg: 0077e00000
Oct 30 11:56:22 ubuntu kernel: [    0.006019] CPU: Physical Processor ID: 0
Oct 30 11:56:22 ubuntu kernel: [    0.006051] CPU: Processor Core ID: 0
Oct 30 11:56:22 ubuntu kernel: [    0.006090] using C1E aware idle routine
Oct 30 11:56:22 ubuntu kernel: [    0.007542] ACPI: Core revision 20080609
Oct 30 11:56:22 ubuntu kernel: [    0.009685] ACPI: Checking initramfs
for custom DSDT
Oct 30 11:56:22 ubuntu kernel: [    0.356629] ..TIMER: vector=0x30
apic1=0 pin1=2 apic2=-1 pin2=-1
Oct 30 11:56:22 ubuntu kernel: [    0.398941] CPU0: AMD Phenom(tm)
9350e Quad-Core Processor stepping 03
Oct 30 11:56:22 ubuntu kernel: [    0.399032] Using local APIC timer interrupts.
Oct 30 11:56:22 ubuntu kernel: [    0.400026] APIC timer calibration
result 12526593
Oct 30 11:56:22 ubuntu kernel: [    0.400028] Detected 12.526 MHz APIC timer.
Oct 30 11:56:22 ubuntu kernel: [    0.400180] Booting processor 1/1 ip 6000
Oct 30 11:56:22 ubuntu kernel: [    0.004000] Initializing CPU#1
Oct 30 11:56:22 ubuntu kernel: [    0.004000] Calibrating delay using
timer specific routine.. 4008.74 BogoMIPS (lpj=8017489)
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU: L1 I Cache: 64K (64
bytes/line), D cache 64K (64 bytes/line)
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU: L2 Cache: 512K (64
bytes/line)
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU 1/1 -> Node 0
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU: Physical Processor ID: 0
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU: Processor Core ID: 1
Oct 30 11:56:22 ubuntu kernel: [    0.488393] CPU1: AMD Phenom(tm)
9350e Quad-Core Processor stepping 03
Oct 30 11:56:22 ubuntu kernel: [    0.488708] checking TSC
synchronization [CPU#0 -> CPU#1]: passed.
Oct 30 11:56:22 ubuntu kernel: [    0.492107] Booting processor 2/2 ip 6000
Oct 30 11:56:22 ubuntu kernel: [    0.004000] Initializing CPU#2
Oct 30 11:56:22 ubuntu kernel: [    0.004000] Calibrating delay using
timer specific routine.. 4008.64 BogoMIPS (lpj=8017291)
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU: L1 I Cache: 64K (64
bytes/line), D cache 64K (64 bytes/line)
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU: L2 Cache: 512K (64
bytes/line)
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU 2/2 -> Node 0
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU: Physical Processor ID: 0
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU: Processor Core ID: 2
Oct 30 11:56:22 ubuntu kernel: [    0.580405] CPU2: AMD Phenom(tm)
9350e Quad-Core Processor stepping 03
Oct 30 11:56:22 ubuntu kernel: [    0.580720] checking TSC
synchronization [CPU#0 -> CPU#2]: passed.
Oct 30 11:56:22 ubuntu kernel: [    0.584109] Booting processor 3/3 ip 6000
Oct 30 11:56:22 ubuntu kernel: [    0.004000] Initializing CPU#3
Oct 30 11:56:22 ubuntu kernel: [    0.004000] Calibrating delay using
timer specific routine.. 4008.63 BogoMIPS (lpj=8017262)
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU: L1 I Cache: 64K (64
bytes/line), D cache 64K (64 bytes/line)
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU: L2 Cache: 512K (64
bytes/line)
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU 3/3 -> Node 0
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU: Physical Processor ID: 0
Oct 30 11:56:22 ubuntu kernel: [    0.004000] CPU: Processor Core ID: 3
Oct 30 11:56:22 ubuntu kernel: [    0.672413] CPU3: AMD Phenom(tm)
9350e Quad-Core Processor stepping 03
Oct 30 11:56:22 ubuntu kernel: [    0.672729] checking TSC
synchronization [CPU#0 -> CPU#3]: passed.
Oct 30 11:56:22 ubuntu kernel: [    0.676054] Brought up 4 CPUs
Oct 30 11:56:22 ubuntu kernel: [    0.676087] Total of 4 processors
activated (16034.52 BogoMIPS).
Oct 30 11:56:22 ubuntu kernel: [    0.676206] CPU0 attaching sched-domain:
Oct 30 11:56:22 ubuntu kernel: [    0.676208]  domain 0: span 0-3 level CPU
Oct 30 11:56:22 ubuntu kernel: [    0.676211]   groups: 0 1 2 3
Oct 30 11:56:22 ubuntu kernel: [    0.676215]   domain 1: span 0-3 level NODE
Oct 30 11:56:22 ubuntu kernel: [    0.676217]    groups: 0-3
Oct 30 11:56:22 ubuntu kernel: [    0.676221] CPU1 attaching sched-domain:
Oct 30 11:56:22 ubuntu kernel: [    0.676223]  domain 0: span 0-3 level CPU
Oct 30 11:56:22 ubuntu kernel: [    0.676224]   groups: 1 2 3 0
Oct 30 11:56:22 ubuntu kernel: [    0.676228]   domain 1: span 0-3 level NODE
Oct 30 11:56:22 ubuntu kernel: [    0.676230]    groups: 0-3
Oct 30 11:56:22 ubuntu kernel: [    0.676233] CPU2 attaching sched-domain:
Oct 30 11:56:22 ubuntu kernel: [    0.676234]  domain 0: span 0-3 level CPU
Oct 30 11:56:22 ubuntu kernel: [    0.676236]   groups: 2 3 0 1
Oct 30 11:56:22 ubuntu kernel: [    0.676239]   domain 1: span 0-3 level NODE
Oct 30 11:56:22 ubuntu kernel: [    0.676241]    groups: 0-3
Oct 30 11:56:22 ubuntu kernel: [    0.676243] CPU3 attaching sched-domain:
Oct 30 11:56:22 ubuntu kernel: [    0.676245]  domain 0: span 0-3 level CPU
Oct 30 11:56:22 ubuntu kernel: [    0.676246]   groups: 3 0 1 2
Oct 30 11:56:22 ubuntu kernel: [    0.676250]   domain 1: span 0-3 level NODE
Oct 30 11:56:22 ubuntu kernel: [    0.676251]    groups: 0-3
Oct 30 11:56:22 ubuntu kernel: [    0.676375] net_namespace: 1552 bytes
Oct 30 11:56:22 ubuntu kernel: [    0.676375] Booting paravirtualized
kernel on bare hardware
Oct 30 11:56:22 ubuntu kernel: [    0.676375] Time: 11:54:24  Date: 10/30/08
Oct 30 11:56:22 ubuntu kernel: [    0.676420] NET: Registered protocol family 16
Oct 30 11:56:22 ubuntu kernel: [    0.676470] node 0 link 0: io port
[c000, ffff]
Oct 30 11:56:22 ubuntu kernel: [    0.676470] TOM: 0000000080000000 aka 2048M
Oct 30 11:56:22 ubuntu kernel: [    0.676470] Fam 10h mmconf
[e0000000, e00fffff]
Oct 30 11:56:22 ubuntu kernel: [    0.676470] node 0 link 0: mmio [a0000, bffff]
Oct 30 11:56:22 ubuntu kernel: [    0.676470] node 0 link 0: mmio
[80000000, fe02ffff] ==> [80000000, dfffffff] and [e0100000, fe02ffff]
Oct 30 11:56:22 ubuntu kernel: [    0.676470] node 0 link 0: mmio
[e0000000, efffffff] ==> [e0100000, efffffff]
Oct 30 11:56:22 ubuntu kernel: [    0.676470] bus: [00,03] on node 0 link 0
Oct 30 11:56:22 ubuntu kernel: [    0.676470] bus: 00 index 0 io port: [0, ffff]
Oct 30 11:56:22 ubuntu kernel: [    0.676470] bus: 00 index 1 mmio:
[a0000, bffff]
Oct 30 11:56:22 ubuntu kernel: [    0.676470] bus: 00 index 2 mmio:
[80000000, dfffffff]
Oct 30 11:56:22 ubuntu kernel: [    0.676470] bus: 00 index 3 mmio:
[e0100000, fcffffffff]
Oct 30 11:56:22 ubuntu kernel: [    0.676470] ACPI: bus type pci registered
Oct 30 11:56:22 ubuntu kernel: [    0.676470] PCI: MCFG configuration
0: base e0000000 segment 0 buses 0 - 255
Oct 30 11:56:22 ubuntu kernel: [    0.676470] PCI: MCFG area at
e0000000 reserved in E820
Oct 30 11:56:22 ubuntu kernel: [    0.691475] PCI: Using MMCONFIG at
e0000000 - efffffff
Oct 30 11:56:22 ubuntu kernel: [    0.691509] PCI: Using configuration
type 1 for base access
Oct 30 11:56:22 ubuntu kernel: [    0.692633] ACPI: EC: Look up EC in DSDT
Oct 30 11:56:22 ubuntu kernel: [    0.703086] ACPI: Interpreter enabled
Oct 30 11:56:22 ubuntu kernel: [    0.703125] ACPI: (supports S0 S3 S4 S5)
Oct 30 11:56:22 ubuntu kernel: [    0.703284] ACPI: Using IOAPIC for
interrupt routing
Oct 30 11:56:22 ubuntu kernel: [    0.709336] ACPI: PCI Root Bridge
[PCI0] (0000:00)
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:00.0 reg 1c
64bit mmio: [e0000000, ffffffff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] pci 0000:00:0a.0: PME#
supported from D0 D3hot D3cold
Oct 30 11:56:22 ubuntu kernel: [    0.709336] pci 0000:00:0a.0: PME# disabled
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:11.0 reg 10
io port: [ff00, ff07]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:11.0 reg 14
io port: [fe00, fe03]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:11.0 reg 18
io port: [fd00, fd07]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:11.0 reg 1c
io port: [fc00, fc03]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:11.0 reg 20
io port: [fb00, fb0f]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:11.0 reg 24
32bit mmio: [fe02f000, fe02f3ff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:12.0 reg 10
32bit mmio: [fe02e000, fe02efff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:12.1 reg 10
32bit mmio: [fe02d000, fe02dfff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:12.2 reg 10
32bit mmio: [fe02c000, fe02c0ff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] pci 0000:00:12.2: supports D1
Oct 30 11:56:22 ubuntu kernel: [    0.709336] pci 0000:00:12.2: supports D2
Oct 30 11:56:22 ubuntu kernel: [    0.709336] pci 0000:00:12.2: PME#
supported from D0 D1 D2 D3hot
Oct 30 11:56:22 ubuntu kernel: [    0.709336] pci 0000:00:12.2: PME# disabled
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:13.0 reg 10
32bit mmio: [fe02b000, fe02bfff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:13.1 reg 10
32bit mmio: [fe02a000, fe02afff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:13.2 reg 10
32bit mmio: [fe029000, fe0290ff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] pci 0000:00:13.2: supports D1
Oct 30 11:56:22 ubuntu kernel: [    0.709336] pci 0000:00:13.2: supports D2
Oct 30 11:56:22 ubuntu kernel: [    0.709336] pci 0000:00:13.2: PME#
supported from D0 D1 D2 D3hot
Oct 30 11:56:22 ubuntu kernel: [    0.709336] pci 0000:00:13.2: PME# disabled
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:14.1 reg 10
io port: [0, 7]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:14.1 reg 14
io port: [0, 3]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:14.1 reg 18
io port: [0, 7]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:14.1 reg 1c
io port: [0, 3]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:14.1 reg 20
io port: [fa00, fa0f]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:00:14.5 reg 10
32bit mmio: [fe028000, fe028fff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:01:05.0 reg 10
32bit mmio: [d8000000, dfffffff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:01:05.0 reg 14
io port: [ee00, eeff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:01:05.0 reg 18
32bit mmio: [fdee0000, fdeeffff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:01:05.0 reg 24
32bit mmio: [fdd00000, fddfffff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] pci 0000:01:05.0: supports D1
Oct 30 11:56:22 ubuntu kernel: [    0.709336] pci 0000:01:05.0: supports D2
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:01:05.1 reg 10
32bit mmio: [fdefc000, fdefffff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] pci 0000:01:05.1: supports D1
Oct 30 11:56:22 ubuntu kernel: [    0.709336] pci 0000:01:05.1: supports D2
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: bridge 0000:00:01.0
io port: [e000, efff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: bridge 0000:00:01.0
32bit mmio: [fdd00000, fdefffff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: bridge 0000:00:01.0
64bit mmio pref: [d8000000, dfffffff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:02:00.0 reg 10
io port: [de00, deff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:02:00.0 reg 18
32bit mmio: [fdfff000, fdffffff]
Oct 30 11:56:22 ubuntu kernel: [    0.709336] PCI: 0000:02:00.0 reg 20
32bit mmio: [fdfe0000, fdfeffff]
Oct 30 11:56:22 ubuntu kernel: [    0.709342] PCI: 0000:02:00.0 reg 30
32bit mmio: [0, ffff]
Oct 30 11:56:22 ubuntu kernel: [    0.709362] pci 0000:02:00.0: supports D1
Oct 30 11:56:22 ubuntu kernel: [    0.709364] pci 0000:02:00.0: supports D2
Oct 30 11:56:22 ubuntu kernel: [    0.709365] pci 0000:02:00.0: PME#
supported from D0 D1 D2 D3hot D3cold
Oct 30 11:56:22 ubuntu kernel: [    0.709401] pci 0000:02:00.0: PME# disabled
Oct 30 11:56:22 ubuntu kernel: [    0.709472] PCI: bridge 0000:00:0a.0
io port: [d000, dfff]
Oct 30 11:56:22 ubuntu kernel: [    0.709474] PCI: bridge 0000:00:0a.0
32bit mmio: [fda00000, fdafffff]
Oct 30 11:56:22 ubuntu kernel: [    0.709478] PCI: bridge 0000:00:0a.0
64bit mmio pref: [fdf00000, fdffffff]
Oct 30 11:56:22 ubuntu kernel: [    0.709529] PCI: 0000:03:07.0 reg 10
io port: [cf00, cf1f]
Oct 30 11:56:22 ubuntu kernel: [    0.709537] PCI: 0000:03:07.0 reg 14
io port: [ce00, ce7f]
Oct 30 11:56:22 ubuntu kernel: [    0.709585] pci 0000:03:07.0: supports D2
Oct 30 11:56:22 ubuntu kernel: [    0.709623] pci 0000:00:14.4:
transparent bridge
Oct 30 11:56:22 ubuntu kernel: [    0.709658] PCI: bridge 0000:00:14.4
io port: [c000, cfff]
Oct 30 11:56:22 ubuntu kernel: [    0.709662] PCI: bridge 0000:00:14.4
32bit mmio: [fdc00000, fdcfffff]
Oct 30 11:56:22 ubuntu kernel: [    0.709666] PCI: bridge 0000:00:14.4
32bit mmio pref: [fdb00000, fdbfffff]
Oct 30 11:56:22 ubuntu kernel: [    0.709683] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0._PRT]
Oct 30 11:56:22 ubuntu kernel: [    0.712159] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.P2P_._PRT]
Oct 30 11:56:22 ubuntu kernel: [    0.712356] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.PCEA._PRT]
Oct 30 11:56:22 ubuntu kernel: [    0.712489] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.AGP_._PRT]
Oct 30 11:56:22 ubuntu kernel: [    0.741524] ACPI: PCI Interrupt Link
[LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 11:56:22 ubuntu kernel: [    0.741524] ACPI: PCI Interrupt Link
[LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 11:56:22 ubuntu kernel: [    0.744485] ACPI: PCI Interrupt Link
[LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 11:56:22 ubuntu kernel: [    0.744971] ACPI: PCI Interrupt Link
[LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 11:56:22 ubuntu kernel: [    0.745951] ACPI: PCI Interrupt Link
[LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 11:56:22 ubuntu kernel: [    0.746445] ACPI: PCI Interrupt Link
[LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 11:56:22 ubuntu kernel: [    0.746925] ACPI: PCI Interrupt Link
[LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 11:56:22 ubuntu kernel: [    0.747414] ACPI: PCI Interrupt Link
[LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 11:56:22 ubuntu kernel: [    0.747826] Linux Plug and Play
Support v0.97 (c) Adam Belay
Oct 30 11:56:22 ubuntu kernel: [    0.748037] pnp: PnP ACPI init
Oct 30 11:56:22 ubuntu kernel: [    0.748074] ACPI: bus type pnp registered
Oct 30 11:56:22 ubuntu kernel: [    0.749045] pnp 00:09: mem resource
(0xe0000000-0xefffffff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
Oct 30 11:56:22 ubuntu kernel: [    0.749045] pnp 00:0a: mem resource
(0xffff0000-0xffffffff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
Oct 30 11:56:22 ubuntu kernel: [    0.749045] pnp 00:0a: mem resource
(0xfec00000-0xfec00fff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
Oct 30 11:56:22 ubuntu kernel: [    0.749045] pnp 00:0a: mem resource
(0xfee00000-0xfee00fff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
Oct 30 11:56:22 ubuntu kernel: [    0.749045] pnp 00:0a: mem resource
(0xfff80000-0xfffeffff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
Oct 30 11:56:22 ubuntu kernel: [    0.749045] pnp: PnP ACPI: found 11 devices
Oct 30 11:56:22 ubuntu kernel: [    0.749045] ACPI: ACPI bus type pnp
unregistered
Oct 30 11:56:22 ubuntu kernel: [    0.752046] PCI: Using ACPI for IRQ routing
Oct 30 11:56:22 ubuntu kernel: [    0.752073] pci 0000:00:00.0: BAR 3:
can't allocate resource
Oct 30 11:56:22 ubuntu kernel: [    0.772041] NET: Registered protocol family 8
Oct 30 11:56:22 ubuntu kernel: [    0.772075] NET: Registered protocol family 20
Oct 30 11:56:22 ubuntu kernel: [    0.772119] NetLabel: Initializing
Oct 30 11:56:22 ubuntu kernel: [    0.772119] NetLabel:  domain hash size = 128
Oct 30 11:56:22 ubuntu kernel: [    0.772119] NetLabel:  protocols =
UNLABELED CIPSOv4
Oct 30 11:56:22 ubuntu kernel: [    0.772142] NetLabel:  unlabeled
traffic allowed by default
Oct 30 11:56:22 ubuntu kernel: [    0.772233] hpet0: at MMIO
0xfed00000, IRQs 2, 8, 0, 0
Oct 30 11:56:22 ubuntu kernel: [    0.772310] hpet0: 4 32-bit timers,
14318180 Hz
Oct 30 11:56:22 ubuntu kernel: [    0.776041] Switched to high
resolution mode on CPU 0
Oct 30 11:56:22 ubuntu kernel: [    0.776748] tracer: 1286 pages
allocated for 65536 entries of 80 bytes
Oct 30 11:56:22 ubuntu kernel: [    0.776782]    actual entries 65586
Oct 30 11:56:22 ubuntu kernel: [    0.776802] Switched to high
resolution mode on CPU 1
Oct 30 11:56:22 ubuntu kernel: [    0.776812] Switched to high
resolution mode on CPU 2
Oct 30 11:56:22 ubuntu kernel: [    0.776822] Switched to high
resolution mode on CPU 3
Oct 30 11:56:22 ubuntu kernel: [    0.776898] AppArmor: AppArmor
Filesystem Enabled
Oct 30 11:56:22 ubuntu kernel: [    0.776949] ACPI: RTC can wake from S4
Oct 30 11:56:22 ubuntu kernel: [    0.792028] system 00:01: ioport
range 0x4d0-0x4d1 has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792064] system 00:01: ioport
range 0x220-0x225 has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792098] system 00:01: ioport
range 0x290-0x294 has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792135] system 00:02: ioport
range 0x4100-0x411f has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792171] system 00:02: ioport
range 0x228-0x22f has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792205] system 00:02: ioport
range 0x238-0x23f has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792239] system 00:02: ioport
range 0x40b-0x40b has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792273] system 00:02: ioport
range 0x4d6-0x4d6 has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792308] system 00:02: ioport
range 0xc00-0xc01 has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792343] system 00:02: ioport
range 0xc14-0xc14 has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792377] system 00:02: ioport
range 0xc50-0xc52 has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792412] system 00:02: ioport
range 0xc6c-0xc6d has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792446] system 00:02: ioport
range 0xc6f-0xc6f has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792481] system 00:02: ioport
range 0xcd0-0xcd1 has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792516] system 00:02: ioport
range 0xcd2-0xcd3 has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792550] system 00:02: ioport
range 0xcd4-0xcdf has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792584] system 00:02: ioport
range 0x4000-0x40fe has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792619] system 00:02: ioport
range 0x4210-0x4217 has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792653] system 00:02: ioport
range 0xb00-0xb0f has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792688] system 00:02: ioport
range 0xb10-0xb1f has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792722] system 00:02: ioport
range 0xb20-0xb3f has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792770] system 00:0a: iomem
range 0xd1a00-0xd3fff has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792805] system 00:0a: iomem
range 0xf0000-0xf7fff could not be reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792840] system 00:0a: iomem
range 0xf8000-0xfbfff could not be reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792875] system 00:0a: iomem
range 0xfc000-0xfffff could not be reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792909] system 00:0a: iomem
range 0x77de0000-0x77dfffff could not be reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792947] system 00:0a: iomem
range 0x0-0x9ffff could not be reserved
Oct 30 11:56:22 ubuntu kernel: [    0.792982] system 00:0a: iomem
range 0x100000-0x77ddffff could not be reserved
Oct 30 11:56:22 ubuntu kernel: [    0.793019] system 00:0a: iomem
range 0x77ef0000-0x7feeffff has been reserved
Oct 30 11:56:22 ubuntu kernel: [    0.798179] pci 0000:00:01.0: PCI
bridge, secondary bus 0000:01
Oct 30 11:56:22 ubuntu kernel: [    0.798214] pci 0000:00:01.0:   IO
window: 0xe000-0xefff
Oct 30 11:56:22 ubuntu kernel: [    0.798249] pci 0000:00:01.0:   MEM
window: 0xfdd00000-0xfdefffff
Oct 30 11:56:22 ubuntu kernel: [    0.798285] pci 0000:00:01.0:
PREFETCH window: 0x000000d8000000-0x000000dfffffff
Oct 30 11:56:22 ubuntu kernel: [    0.798324] pci 0000:00:0a.0: PCI
bridge, secondary bus 0000:02
Oct 30 11:56:22 ubuntu kernel: [    0.798359] pci 0000:00:0a.0:   IO
window: 0xd000-0xdfff
Oct 30 11:56:22 ubuntu kernel: [    0.798393] pci 0000:00:0a.0:   MEM
window: 0xfda00000-0xfdafffff
Oct 30 11:56:22 ubuntu kernel: [    0.798428] pci 0000:00:0a.0:
PREFETCH window: 0x000000fdf00000-0x000000fdffffff
Oct 30 11:56:22 ubuntu kernel: [    0.798466] pci 0000:00:14.4: PCI
bridge, secondary bus 0000:03
Oct 30 11:56:22 ubuntu kernel: [    0.798502] pci 0000:00:14.4:   IO
window: 0xc000-0xcfff
Oct 30 11:56:22 ubuntu kernel: [    0.798538] pci 0000:00:14.4:   MEM
window: 0xfdc00000-0xfdcfffff
Oct 30 11:56:22 ubuntu kernel: [    0.798574] pci 0000:00:14.4:
PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
Oct 30 11:56:22 ubuntu kernel: [    0.798630] pci 0000:00:0a.0: PCI
INT A -> GSI 18 (level, low) -> IRQ 18
Oct 30 11:56:22 ubuntu kernel: [    0.798665] pci 0000:00:0a.0:
setting latency timer to 64
Oct 30 11:56:22 ubuntu kernel: [    0.798672] bus: 00 index 0 io port: [0, ffff]
Oct 30 11:56:22 ubuntu kernel: [    0.798705] bus: 00 index 1 mmio:
[0, ffffffffffffffff]
Oct 30 11:56:22 ubuntu kernel: [    0.798739] bus: 01 index 0 io port:
[e000, efff]
Oct 30 11:56:22 ubuntu kernel: [    0.798772] bus: 01 index 1 mmio:
[fdd00000, fdefffff]
Oct 30 11:56:22 ubuntu kernel: [    0.798806] bus: 01 index 2 mmio:
[d8000000, dfffffff]
Oct 30 11:56:22 ubuntu kernel: [    0.798839] bus: 01 index 3 mmio: [0, 0]
Oct 30 11:56:22 ubuntu kernel: [    0.798871] bus: 02 index 0 io port:
[d000, dfff]
Oct 30 11:56:22 ubuntu kernel: [    0.798904] bus: 02 index 1 mmio:
[fda00000, fdafffff]
Oct 30 11:56:22 ubuntu kernel: [    0.798938] bus: 02 index 2 mmio:
[fdf00000, fdffffff]
Oct 30 11:56:22 ubuntu kernel: [    0.798971] bus: 02 index 3 mmio: [0, 0]
Oct 30 11:56:22 ubuntu kernel: [    0.799003] bus: 03 index 0 io port:
[c000, cfff]
Oct 30 11:56:22 ubuntu kernel: [    0.799036] bus: 03 index 1 mmio:
[fdc00000, fdcfffff]
Oct 30 11:56:22 ubuntu kernel: [    0.799070] bus: 03 index 2 mmio:
[fdb00000, fdbfffff]
Oct 30 11:56:22 ubuntu kernel: [    0.799103] bus: 03 index 3 io port: [0, ffff]
Oct 30 11:56:22 ubuntu kernel: [    0.799136] bus: 03 index 4 mmio:
[0, ffffffffffffffff]
Oct 30 11:56:22 ubuntu kernel: [    0.799179] NET: Registered protocol family 2
Oct 30 11:56:22 ubuntu kernel: [    0.840129] IP route cache hash
table entries: 65536 (order: 7, 524288 bytes)
Oct 30 11:56:22 ubuntu kernel: [    0.840957] TCP established hash
table entries: 262144 (order: 10, 4194304 bytes)
Oct 30 11:56:22 ubuntu kernel: [    0.842421] TCP bind hash table
entries: 65536 (order: 8, 1048576 bytes)
Oct 30 11:56:22 ubuntu kernel: [    0.842792] TCP: Hash tables
configured (established 262144 bind 65536)
Oct 30 11:56:22 ubuntu kernel: [    0.842826] TCP reno registered
Oct 30 11:56:22 ubuntu kernel: [    0.852108] NET: Registered protocol family 1
Oct 30 11:56:22 ubuntu kernel: [    0.852252] checking if image is
initramfs... it is
Oct 30 11:56:22 ubuntu kernel: [    1.549062] Freeing initrd memory: 8988k freed
Oct 30 11:56:22 ubuntu kernel: [    1.554035] audit: initializing
netlink socket (disabled)
Oct 30 11:56:22 ubuntu kernel: [    1.554082] type=2000
audit(1225367664.552:1): initialized
Oct 30 11:56:22 ubuntu kernel: [    1.559396] HugeTLB registered 2 MB
page size, pre-allocated 0 pages
Oct 30 11:56:22 ubuntu kernel: [    1.562162] VFS: Disk quotas dquot_6.5.1
Oct 30 11:56:22 ubuntu kernel: [    1.562278] Dquot-cache hash table
entries: 512 (order 0, 4096 bytes)
Oct 30 11:56:22 ubuntu kernel: [    1.562413] msgmni has been set to 3760
Oct 30 11:56:22 ubuntu kernel: [    1.562571] io scheduler noop registered
Oct 30 11:56:22 ubuntu kernel: [    1.562604] io scheduler
anticipatory registered
Oct 30 11:56:22 ubuntu kernel: [    1.562638] io scheduler deadline registered
Oct 30 11:56:22 ubuntu kernel: [    1.562795] io scheduler cfq
registered (default)
Oct 30 11:56:22 ubuntu kernel: [    1.684050] pci 0000:01:05.0: Boot
video device
Oct 30 11:56:22 ubuntu kernel: [    1.684183] pcieport-driver
0000:00:0a.0: setting latency timer to 64
Oct 30 11:56:22 ubuntu kernel: [    1.684204] pcieport-driver
0000:00:0a.0: found MSI capability
Oct 30 11:56:22 ubuntu kernel: [    1.684263] pci_express
0000:00:0a.0:pcie00: allocate port service
Oct 30 11:56:22 ubuntu kernel: [    1.720860] hpet_resources: 0xfed00000 is busy
Oct 30 11:56:22 ubuntu kernel: [    1.720928] Linux agpgart interface v0.103
Oct 30 11:56:22 ubuntu kernel: [    1.720966] Serial: 8250/16550
driver4 ports, IRQ sharing enabled
Oct 30 11:56:22 ubuntu kernel: [    1.723146] brd: module loaded
Oct 30 11:56:22 ubuntu kernel: [    1.723247] input: Macintosh mouse
button emulation as /devices/virtual/input/input0
Oct 30 11:56:22 ubuntu kernel: [    1.723390] PNP: PS/2 Controller
[PNP0303:PS2K] at 0x60,0x64 irq 1
Oct 30 11:56:22 ubuntu kernel: [    1.723424] PNP: PS/2 appears to
have AUX port disabled, if this is incorrect please boot with
i8042.nopnp
Oct 30 11:56:22 ubuntu kernel: [    1.723587] serio: i8042 KBD port at
0x60,0x64 irq 1
Oct 30 11:56:22 ubuntu kernel: [    1.740136] mice: PS/2 mouse device
common for all mice
Oct 30 11:56:22 ubuntu kernel: [    1.740298] rtc_cmos 00:05: rtc
core: registered rtc_cmos as rtc0
Oct 30 11:56:22 ubuntu kernel: [    1.740361] rtc0: alarms up to one
month, hpet irqs
Oct 30 11:56:22 ubuntu kernel: [    1.740431] cpuidle: using governor ladder
Oct 30 11:56:22 ubuntu kernel: [    1.740465] cpuidle: using governor menu
Oct 30 11:56:22 ubuntu kernel: [    1.740875] TCP cubic registered
Oct 30 11:56:22 ubuntu kernel: [    1.741117] registered taskstats version 1
Oct 30 11:56:22 ubuntu kernel: [    1.741275]   Magic number: 12:336:935
Oct 30 11:56:22 ubuntu kernel: [    1.741412] rtc_cmos 00:05: setting
system clock to 2008-10-30 11:54:25 UTC (1225367665)
Oct 30 11:56:22 ubuntu kernel: [    1.741450] BIOS EDD facility v0.16
2004-Jun-25, 0 devices found
Oct 30 11:56:22 ubuntu kernel: [    1.741484] EDD information not available.
Oct 30 11:56:22 ubuntu kernel: [    1.741547] Freeing unused kernel
memory: 536k freed
Oct 30 11:56:22 ubuntu kernel: [    1.741775] Write protecting the
kernel read-only data: 4348k
Oct 30 11:56:22 ubuntu kernel: [    1.757365] input: AT Translated Set
2 keyboard as /devices/platform/i8042/serio0/input/input1
Oct 30 11:56:22 ubuntu kernel: [    1.832998] fuse init (API version 7.9)
Oct 30 11:56:22 ubuntu kernel: [    1.853066] processor ACPI0007:00:
registered as cooling_device0
Oct 30 11:56:22 ubuntu kernel: [    1.853166] processor ACPI0007:01:
registered as cooling_device1
Oct 30 11:56:22 ubuntu kernel: [    1.853263] processor ACPI0007:02:
registered as cooling_device2
Oct 30 11:56:22 ubuntu kernel: [    1.853359] processor ACPI0007:03:
registered as cooling_device3
Oct 30 11:56:22 ubuntu kernel: [    2.004582] No dock devices found.
Oct 30 11:56:22 ubuntu kernel: [    2.015361] SCSI subsystem initialized
Oct 30 11:56:22 ubuntu kernel: [    2.017298] r8169 Gigabit Ethernet
driver 2.3LK-NAPI loaded
Oct 30 11:56:22 ubuntu kernel: [    2.017354] r8169 0000:02:00.0: PCI
INT A -> GSI 18 (level, low) -> IRQ 18
Oct 30 11:56:22 ubuntu kernel: [    2.017404] r8169 0000:02:00.0:
setting latency timer to 64
Oct 30 11:56:22 ubuntu kernel: [    2.017697] eth0: RTL8168c/8111c at
0xffffc20000372000, 00:1f:d0:56:5e:a0, XID 3c4000c0 IRQ 2302
Oct 30 11:56:22 ubuntu kernel: [    2.035130] libata version 3.00 loaded.
Oct 30 11:56:22 ubuntu kernel: [    2.047195] usbcore: registered new
interface driver usbfs
Oct 30 11:56:22 ubuntu kernel: [    2.047280] usbcore: registered new
interface driver hub
Oct 30 11:56:22 ubuntu kernel: [    2.050234] usbcore: registered new
device driver usb
Oct 30 11:56:22 ubuntu kernel: [    2.050365] ahci 0000:00:11.0: version 3.0
Oct 30 11:56:22 ubuntu kernel: [    2.050391] ahci 0000:00:11.0: PCI
INT A -> GSI 22 (level, low) -> IRQ 22
Oct 30 11:56:22 ubuntu kernel: [    2.050582] ahci 0000:00:11.0: AHCI
0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
Oct 30 11:56:22 ubuntu kernel: [    2.050621] ahci 0000:00:11.0:
flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
Oct 30 11:56:22 ubuntu kernel: [    2.051655] scsi0 : ahci
Oct 30 11:56:22 ubuntu kernel: [    2.051793] scsi1 : ahci
Oct 30 11:56:22 ubuntu kernel: [    2.051872] scsi2 : ahci
Oct 30 11:56:22 ubuntu kernel: [    2.051951] scsi3 : ahci
Oct 30 11:56:22 ubuntu kernel: [    2.052029] scsi4 : ahci
Oct 30 11:56:22 ubuntu kernel: [    2.052108] scsi5 : ahci
Oct 30 11:56:22 ubuntu kernel: [    2.052243] ata1: SATA max UDMA/133
abar m1024@0xfe02f000 port 0xfe02f100 irq 2301
Oct 30 11:56:22 ubuntu kernel: [    2.052281] ata2: SATA max UDMA/133
abar m1024@0xfe02f000 port 0xfe02f180 irq 2301
Oct 30 11:56:22 ubuntu kernel: [    2.052808] ata3: SATA max UDMA/133
abar m1024@0xfe02f000 port 0xfe02f200 irq 2301
Oct 30 11:56:22 ubuntu kernel: [    2.052845] ata4: SATA max UDMA/133
abar m1024@0xfe02f000 port 0xfe02f280 irq 2301
Oct 30 11:56:22 ubuntu kernel: [    2.052882] ata5: SATA max UDMA/133
abar m1024@0xfe02f000 port 0xfe02f300 irq 2301
Oct 30 11:56:22 ubuntu kernel: [    2.052920] ata6: SATA max UDMA/133
abar m1024@0xfe02f000 port 0xfe02f380 irq 2301
Oct 30 11:56:22 ubuntu kernel: [    2.060096] ohci_hcd: 2006 August 04
USB 1.1 'Open' Host Controller (OHCI) Driver
Oct 30 11:56:22 ubuntu kernel: [    2.536026] ata1: softreset failed
(device not ready)
Oct 30 11:56:22 ubuntu kernel: [    2.536067] ata1: failed due to HW
bug, retry pmp=0
Oct 30 11:56:22 ubuntu kernel: [    2.700039] ata1: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Oct 30 11:56:22 ubuntu kernel: [    2.706414] ata1.00: ATA-7: SAMSUNG
HD642JJ, 1AA01112, max UDMA7
Oct 30 11:56:22 ubuntu kernel: [    2.706454] ata1.00: 1250263728
sectors, multi 0: LBA48 NCQ (depth 31/32)
Oct 30 11:56:22 ubuntu kernel: [    2.712880] ata1.00: configured for UDMA/133
Oct 30 11:56:22 ubuntu kernel: [    3.048034] ata2: SATA link down
(SStatus 0 SControl 300)
Oct 30 11:56:22 ubuntu kernel: [    3.384034] ata3: SATA link down
(SStatus 0 SControl 300)
Oct 30 11:56:22 ubuntu kernel: [    3.720025] ata4: SATA link down
(SStatus 0 SControl 300)
Oct 30 11:56:22 ubuntu kernel: [    4.220023] ata5: softreset failed
(device not ready)
Oct 30 11:56:22 ubuntu kernel: [    4.220060] ata5: failed due to HW
bug, retry pmp=0
Oct 30 11:56:22 ubuntu kernel: [    4.384029] ata5: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Oct 30 11:56:22 ubuntu kernel: [    4.390388] ata5.00: ATA-7: SAMSUNG
HD642JJ, 1AA01112, max UDMA7
Oct 30 11:56:22 ubuntu kernel: [    4.390422] ata5.00: 1250263728
sectors, multi 0: LBA48 NCQ (depth 31/32)
Oct 30 11:56:22 ubuntu kernel: [    4.396842] ata5.00: configured for UDMA/133
Oct 30 11:56:22 ubuntu kernel: [    4.732032] ata6: SATA link down
(SStatus 0 SControl 300)
Oct 30 11:56:22 ubuntu kernel: [    4.748117] scsi 0:0:0:0:
Direct-Access     ATA      SAMSUNG HD642JJ  1AA0 PQ: 0 ANSI: 5
Oct 30 11:56:22 ubuntu kernel: [    4.748265] scsi 4:0:0:0:
Direct-Access     ATA      SAMSUNG HD642JJ  1AA0 PQ: 0 ANSI: 5
Oct 30 11:56:22 ubuntu kernel: [    4.748754] ohci_hcd 0000:00:12.0:
PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 30 11:56:22 ubuntu kernel: [    4.748805] ohci_hcd 0000:00:12.0:
OHCI Host Controller
Oct 30 11:56:22 ubuntu kernel: [    4.748886] ohci_hcd 0000:00:12.0:
new USB bus registered, assigned bus number 1
Oct 30 11:56:22 ubuntu kernel: [    4.748957] ohci_hcd 0000:00:12.0:
irq 16, io mem 0xfe02e000
Oct 30 11:56:22 ubuntu kernel: [    4.808118] usb usb1: configuration
#1 chosen from 1 choice
Oct 30 11:56:22 ubuntu kernel: [    4.808181] hub 1-0:1.0: USB hub found
Oct 30 11:56:22 ubuntu kernel: [    4.808221] hub 1-0:1.0: 3 ports detected
Oct 30 11:56:22 ubuntu kernel: [    5.013760] ohci_hcd 0000:00:12.1:
PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 30 11:56:22 ubuntu kernel: [    5.013809] ohci_hcd 0000:00:12.1:
OHCI Host Controller
Oct 30 11:56:22 ubuntu kernel: [    5.013874] ohci_hcd 0000:00:12.1:
new USB bus registered, assigned bus number 2
Oct 30 11:56:22 ubuntu kernel: [    5.013926] ohci_hcd 0000:00:12.1:
irq 16, io mem 0xfe02d000
Oct 30 11:56:22 ubuntu kernel: [    5.073198] usb usb2: configuration
#1 chosen from 1 choice
Oct 30 11:56:22 ubuntu kernel: [    5.073756] hub 2-0:1.0: USB hub found
Oct 30 11:56:22 ubuntu kernel: [    5.073798] hub 2-0:1.0: 3 ports detected
Oct 30 11:56:22 ubuntu kernel: [    5.176019] usb 1-2: new low speed
USB device using ohci_hcd and address 2
Oct 30 11:56:22 ubuntu kernel: [    5.177215] ehci_hcd 0000:00:12.2:
PCI INT B -> GSI 17 (level, low) -> IRQ 17
Oct 30 11:56:22 ubuntu kernel: [    5.177262] ehci_hcd 0000:00:12.2:
EHCI Host Controller
Oct 30 11:56:22 ubuntu kernel: [    5.177334] ehci_hcd 0000:00:12.2:
new USB bus registered, assigned bus number 3
Oct 30 11:56:22 ubuntu kernel: [    5.177401] ehci_hcd 0000:00:12.2:
debug port 1
Oct 30 11:56:22 ubuntu kernel: [    5.177459] ehci_hcd 0000:00:12.2:
irq 17, io mem 0xfe02c000
Oct 30 11:56:22 ubuntu kernel: [    5.324020] ehci_hcd 0000:00:12.2:
USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Oct 30 11:56:22 ubuntu kernel: [    5.324169] usb usb3: configuration
#1 chosen from 1 choice
Oct 30 11:56:22 ubuntu kernel: [    5.324225] hub 3-0:1.0: USB hub found
Oct 30 11:56:22 ubuntu kernel: [    5.324264] hub 3-0:1.0: 6 ports detected
Oct 30 11:56:22 ubuntu kernel: [    5.533207] ohci_hcd 0000:00:13.0:
PCI INT A -> GSI 18 (level, low) -> IRQ 18
Oct 30 11:56:22 ubuntu kernel: [    5.533250] ohci_hcd 0000:00:13.0:
OHCI Host Controller
Oct 30 11:56:22 ubuntu kernel: [    5.533309] ohci_hcd 0000:00:13.0:
new USB bus registered, assigned bus number 4
Oct 30 11:56:22 ubuntu kernel: [    5.533370] ohci_hcd 0000:00:13.0:
irq 18, io mem 0xfe02b000
Oct 30 11:56:22 ubuntu kernel: [    5.592087] usb usb4: configuration
#1 chosen from 1 choice
Oct 30 11:56:22 ubuntu kernel: [    5.592143] hub 4-0:1.0: USB hub found
Oct 30 11:56:22 ubuntu kernel: [    5.592182] hub 4-0:1.0: 3 ports detected
Oct 30 11:56:22 ubuntu kernel: [    5.693291] ohci_hcd 0000:00:13.1:
PCI INT A -> GSI 18 (level, low) -> IRQ 18
Oct 30 11:56:22 ubuntu kernel: [    5.693334] ohci_hcd 0000:00:13.1:
OHCI Host Controller
Oct 30 11:56:22 ubuntu kernel: [    5.693390] ohci_hcd 0000:00:13.1:
new USB bus registered, assigned bus number 5
Oct 30 11:56:22 ubuntu kernel: [    5.693439] ohci_hcd 0000:00:13.1:
irq 18, io mem 0xfe02a000
Oct 30 11:56:22 ubuntu kernel: [    5.720020] usb 1-2: device not
accepting address 2, error -62
Oct 30 11:56:22 ubuntu kernel: [    5.752083] usb usb5: configuration
#1 chosen from 1 choice
Oct 30 11:56:22 ubuntu kernel: [    5.752138] hub 5-0:1.0: USB hub found
Oct 30 11:56:22 ubuntu kernel: [    5.752177] hub 5-0:1.0: 3 ports detected
Oct 30 11:56:22 ubuntu kernel: [    5.776030] hub 1-0:1.0: unable to
enumerate USB device on port 2
Oct 30 11:56:22 ubuntu kernel: [    5.956175] ehci_hcd 0000:00:13.2:
PCI INT B -> GSI 19 (level, low) -> IRQ 19
Oct 30 11:56:22 ubuntu kernel: [    5.956218] ehci_hcd 0000:00:13.2:
EHCI Host Controller
Oct 30 11:56:22 ubuntu kernel: [    5.956277] ehci_hcd 0000:00:13.2:
new USB bus registered, assigned bus number 6
Oct 30 11:56:22 ubuntu kernel: [    5.956343] ehci_hcd 0000:00:13.2:
debug port 1
Oct 30 11:56:22 ubuntu kernel: [    5.956396] ehci_hcd 0000:00:13.2:
irq 19, io mem 0xfe029000
Oct 30 11:56:22 ubuntu kernel: [    5.976019] ehci_hcd 0000:00:13.2:
USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Oct 30 11:56:22 ubuntu kernel: [    5.976144] usb usb6: configuration
#1 chosen from 1 choice
Oct 30 11:56:22 ubuntu kernel: [    5.976201] hub 6-0:1.0: USB hub found
Oct 30 11:56:22 ubuntu kernel: [    5.976238] hub 6-0:1.0: 6 ports detected
Oct 30 11:56:22 ubuntu kernel: [    6.185520] pata_acpi 0000:00:14.1:
PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 30 11:56:22 ubuntu kernel: [    6.185659] ohci_hcd 0000:00:14.5:
PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct 30 11:56:22 ubuntu kernel: [    6.185704] ohci_hcd 0000:00:14.5:
OHCI Host Controller
Oct 30 11:56:22 ubuntu kernel: [    6.185771] ohci_hcd 0000:00:14.5:
new USB bus registered, assigned bus number 7
Oct 30 11:56:22 ubuntu kernel: [    6.185821] ohci_hcd 0000:00:14.5:
irq 18, io mem 0xfe028000
Oct 30 11:56:22 ubuntu kernel: [    6.244801] usb usb7: configuration
#1 chosen from 1 choice
Oct 30 11:56:22 ubuntu kernel: [    6.244864] hub 7-0:1.0: USB hub found
Oct 30 11:56:22 ubuntu kernel: [    6.244903] hub 7-0:1.0: 2 ports detected
Oct 30 11:56:22 ubuntu kernel: [    6.357707] scsi6 : pata_atiixp
Oct 30 11:56:22 ubuntu kernel: [    6.357807] scsi7 : pata_atiixp
Oct 30 11:56:22 ubuntu kernel: [    6.359019] ata7: PATA max UDMA/100
cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
Oct 30 11:56:22 ubuntu kernel: [    6.359054] ata8: PATA max UDMA/100
cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
Oct 30 11:56:22 ubuntu kernel: [    6.360814] scsi 0:0:0:0: Attached
scsi generic sg0 type 0
Oct 30 11:56:22 ubuntu kernel: [    6.360887] scsi 4:0:0:0: Attached
scsi generic sg1 type 0
Oct 30 11:56:22 ubuntu kernel: [    6.369529] usb 1-2: new low speed
USB device using ohci_hcd and address 4
Oct 30 11:56:22 ubuntu kernel: [    6.378333] Driver 'sd' needs
updating - please use bus_type methods
Oct 30 11:56:22 ubuntu kernel: [    6.378478] sd 0:0:0:0: [sda]
1250263728 512-byte hardware sectors (640135 MB)
Oct 30 11:56:22 ubuntu kernel: [    6.378527] sd 0:0:0:0: [sda] Write
Protect is off
Oct 30 11:56:22 ubuntu kernel: [    6.378561] sd 0:0:0:0: [sda] Mode
Sense: 00 3a 00 00
Oct 30 11:56:22 ubuntu kernel: [    6.378583] sd 0:0:0:0: [sda] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 30 11:56:22 ubuntu kernel: [    6.378682] sd 0:0:0:0: [sda]
1250263728 512-byte hardware sectors (640135 MB)
Oct 30 11:56:22 ubuntu kernel: [    6.378730] sd 0:0:0:0: [sda] Write
Protect is off
Oct 30 11:56:22 ubuntu kernel: [    6.378764] sd 0:0:0:0: [sda] Mode
Sense: 00 3a 00 00
Oct 30 11:56:22 ubuntu kernel: [    6.378785] sd 0:0:0:0: [sda] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 30 11:56:22 ubuntu kernel: [    6.378826]  sda: sda1 sda2
Oct 30 11:56:22 ubuntu kernel: [    6.396744] sd 0:0:0:0: [sda]
Attached SCSI disk
Oct 30 11:56:22 ubuntu kernel: [    6.396859] sd 4:0:0:0: [sdb]
1250263728 512-byte hardware sectors (640135 MB)
Oct 30 11:56:22 ubuntu kernel: [    6.396912] sd 4:0:0:0: [sdb] Write
Protect is off
Oct 30 11:56:22 ubuntu kernel: [    6.396946] sd 4:0:0:0: [sdb] Mode
Sense: 00 3a 00 00
Oct 30 11:56:22 ubuntu kernel: [    6.396978] sd 4:0:0:0: [sdb] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 30 11:56:22 ubuntu kernel: [    6.397062] sd 4:0:0:0: [sdb]
1250263728 512-byte hardware sectors (640135 MB)
Oct 30 11:56:22 ubuntu kernel: [    6.397111] sd 4:0:0:0: [sdb] Write
Protect is off
Oct 30 11:56:22 ubuntu kernel: [    6.397144] sd 4:0:0:0: [sdb] Mode
Sense: 00 3a 00 00
Oct 30 11:56:22 ubuntu kernel: [    6.397167] sd 4:0:0:0: [sdb] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 30 11:56:22 ubuntu kernel: [    6.397213]  sdb: sdb1 sdb2
Oct 30 11:56:22 ubuntu kernel: [    6.411444] sd 4:0:0:0: [sdb]
Attached SCSI disk
Oct 30 11:56:22 ubuntu kernel: [    6.520501] ata7.00: ATAPI: TOSHIBA
DVD-ROM SD-M1612, 1004, max UDMA/33
Oct 30 11:56:22 ubuntu kernel: [    6.536460] ata7.00: configured for UDMA/33
Oct 30 11:56:22 ubuntu kernel: [    6.537237] usb 1-2: configuration
#1 chosen from 1 choice
Oct 30 11:56:22 ubuntu kernel: [    6.592082] usbcore: registered new
interface driver hiddev
Oct 30 11:56:22 ubuntu kernel: [    6.598919] input: Logitech USB-PS/2
Optical Mouse as
/devices/pci0000:00/0000:00:12.0/usb1/1-2/1-2:1.0/input/input2
Oct 30 11:56:22 ubuntu kernel: [    6.626670] input,hidraw0: USB HID
v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:12.0-2
Oct 30 11:56:22 ubuntu kernel: [    6.626846] usbcore: registered new
interface driver usbhid
Oct 30 11:56:22 ubuntu kernel: [    6.628416] usbhid: v2.6:USB HID core driver
Oct 30 11:56:22 ubuntu kernel: [    6.692121] isa bounce pool size: 16 pages
Oct 30 11:56:22 ubuntu kernel: [    6.693579] scsi 6:0:0:0: CD-ROM
       TOSHIBA  DVD-ROM SD-M1612 1004 PQ: 0 ANSI: 5
Oct 30 11:56:22 ubuntu kernel: [    6.693760] scsi 6:0:0:0: Attached
scsi generic sg2 type 5
Oct 30 11:56:22 ubuntu kernel: [    6.711730] Driver 'sr' needs
updating - please use bus_type methods
Oct 30 11:56:22 ubuntu kernel: [    6.713140] sr0: scsi3-mmc drive:
48x/48x cd/rw xa/form2 cdda tray
Oct 30 11:56:22 ubuntu kernel: [    6.713181] Uniform CD-ROM driver
Revision: 3.20
Oct 30 11:56:22 ubuntu kernel: [    6.713309] sr 6:0:0:0: Attached
scsi CD-ROM sr0
Oct 30 11:56:22 ubuntu kernel: [    6.865525] usb 5-3: new low speed
USB device using ohci_hcd and address 2
Oct 30 11:56:22 ubuntu kernel: [    7.048232] usb 5-3: configuration
#1 chosen from 1 choice
Oct 30 11:56:22 ubuntu kernel: [    7.129318] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [    7.129325] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [    8.206526] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [    8.206533] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [    9.261160] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [    9.261169] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   10.316918] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   10.316926] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   11.368748] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   11.368757] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   12.424444] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   12.424453] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   13.480339] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   13.480347] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   14.536525] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   14.536533] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   15.592624] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   15.592632] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   16.387170] sr 6:0:0:0: [sr0]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Oct 30 11:56:22 ubuntu kernel: [   16.387241] sr 6:0:0:0: [sr0] Sense
Key : Medium Error [current]
Oct 30 11:56:22 ubuntu kernel: [   16.387359] Info fld=0x56f36
Oct 30 11:56:22 ubuntu kernel: [   16.387391] sr 6:0:0:0: [sr0] Add.
Sense: CIRC unrecovered error
Oct 30 11:56:22 ubuntu kernel: [   16.387482] end_request: I/O error,
dev sr0, sector 1424600
Oct 30 11:56:22 ubuntu kernel: [   16.387518] Buffer I/O error on
device sr0, logical block 356150
Oct 30 11:56:22 ubuntu kernel: [   16.648494] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   16.648502] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   17.060535]
/build/buildd/linux-2.6.27/drivers/hid/usbhid/hid-core.c:
usb_submit_urb(ctrl) failed
Oct 30 11:56:22 ubuntu kernel: [   17.060586] usbhid: timeout
initializing reports
Oct 30 11:56:22 ubuntu kernel: [   17.061269] input: Logitech Logitech
Attack 3 as /devices/pci0000:00/0000:00:13.1/usb5/5-3/5-3:1.0/input/input3
Oct 30 11:56:22 ubuntu kernel: [   17.061950] input,hidraw1: USB HID
v1.10 Joystick [Logitech Logitech Attack 3] on usb-0000:00:13.1-3
Oct 30 11:56:22 ubuntu kernel: [   17.700562] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   17.700570] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   17.910616] sr 6:0:0:0: [sr0]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Oct 30 11:56:22 ubuntu kernel: [   17.910686] sr 6:0:0:0: [sr0] Sense
Key : Medium Error [current]
Oct 30 11:56:22 ubuntu kernel: [   17.910805] Info fld=0x56f36
Oct 30 11:56:22 ubuntu kernel: [   17.910837] sr 6:0:0:0: [sr0] Add.
Sense: CIRC unrecovered error
Oct 30 11:56:22 ubuntu kernel: [   17.910928] end_request: I/O error,
dev sr0, sector 1424600
Oct 30 11:56:22 ubuntu kernel: [   17.910963] Buffer I/O error on
device sr0, logical block 356150
Oct 30 11:56:22 ubuntu kernel: [   18.752665] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   18.752673] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   19.434168] sr 6:0:0:0: [sr0]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Oct 30 11:56:22 ubuntu kernel: [   19.434239] sr 6:0:0:0: [sr0] Sense
Key : Medium Error [current]
Oct 30 11:56:22 ubuntu kernel: [   19.434357] Info fld=0x56f36
Oct 30 11:56:22 ubuntu kernel: [   19.434389] sr 6:0:0:0: [sr0] Add.
Sense: CIRC unrecovered error
Oct 30 11:56:22 ubuntu kernel: [   19.434480] end_request: I/O error,
dev sr0, sector 1424600
Oct 30 11:56:22 ubuntu kernel: [   19.434515] Buffer I/O error on
device sr0, logical block 356150
Oct 30 11:56:22 ubuntu kernel: [   19.808525] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   19.808534] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   20.864630] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   20.864638] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   20.957442] sr 6:0:0:0: [sr0]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Oct 30 11:56:22 ubuntu kernel: [   20.957517] sr 6:0:0:0: [sr0] Sense
Key : Medium Error [current]
Oct 30 11:56:22 ubuntu kernel: [   20.957636] Info fld=0x56f36
Oct 30 11:56:22 ubuntu kernel: [   20.957668] sr 6:0:0:0: [sr0] Add.
Sense: CIRC unrecovered error
Oct 30 11:56:22 ubuntu kernel: [   20.957760] end_request: I/O error,
dev sr0, sector 1424600
Oct 30 11:56:22 ubuntu kernel: [   20.957795] Buffer I/O error on
device sr0, logical block 356150
Oct 30 11:56:22 ubuntu kernel: [   21.920705] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   21.920713] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   22.480778] sr 6:0:0:0: [sr0]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Oct 30 11:56:22 ubuntu kernel: [   22.480848] sr 6:0:0:0: [sr0] Sense
Key : Medium Error [current]
Oct 30 11:56:22 ubuntu kernel: [   22.480967] Info fld=0x56f36
Oct 30 11:56:22 ubuntu kernel: [   22.480999] sr 6:0:0:0: [sr0] Add.
Sense: CIRC unrecovered error
Oct 30 11:56:22 ubuntu kernel: [   22.481090] end_request: I/O error,
dev sr0, sector 1424600
Oct 30 11:56:22 ubuntu kernel: [   22.481125] Buffer I/O error on
device sr0, logical block 356150
Oct 30 11:56:22 ubuntu kernel: [   22.976578] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   22.976586] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   24.004493] sr 6:0:0:0: [sr0]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Oct 30 11:56:22 ubuntu kernel: [   24.004564] sr 6:0:0:0: [sr0] Sense
Key : Medium Error [current]
Oct 30 11:56:22 ubuntu kernel: [   24.004683] Info fld=0x56f36
Oct 30 11:56:22 ubuntu kernel: [   24.004715] sr 6:0:0:0: [sr0] Add.
Sense: CIRC unrecovered error
Oct 30 11:56:22 ubuntu kernel: [   24.004806] end_request: I/O error,
dev sr0, sector 1424600
Oct 30 11:56:22 ubuntu kernel: [   24.004841] Buffer I/O error on
device sr0, logical block 356150
Oct 30 11:56:22 ubuntu kernel: [   24.032594] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   24.032602] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   25.084631] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   25.084639] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   25.527861] sr 6:0:0:0: [sr0]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Oct 30 11:56:22 ubuntu kernel: [   25.527931] sr 6:0:0:0: [sr0] Sense
Key : Medium Error [current]
Oct 30 11:56:22 ubuntu kernel: [   25.528050] Info fld=0x56f36
Oct 30 11:56:22 ubuntu kernel: [   25.528082] sr 6:0:0:0: [sr0] Add.
Sense: CIRC unrecovered error
Oct 30 11:56:22 ubuntu kernel: [   25.528173] end_request: I/O error,
dev sr0, sector 1424600
Oct 30 11:56:22 ubuntu kernel: [   25.528208] Buffer I/O error on
device sr0, logical block 356150
Oct 30 11:56:22 ubuntu kernel: [   26.140655] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   26.140662] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   26.971326] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [   26.971366] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [   27.196639] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   27.196646] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   28.252556] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   28.252564] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   28.498584] sr 6:0:0:0: [sr0]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Oct 30 11:56:22 ubuntu kernel: [   28.498654] sr 6:0:0:0: [sr0] Sense
Key : Medium Error [current]
Oct 30 11:56:22 ubuntu kernel: [   28.498773] Info fld=0x56f36
Oct 30 11:56:22 ubuntu kernel: [   28.498805] sr 6:0:0:0: [sr0] Add.
Sense: CIRC unrecovered error
Oct 30 11:56:22 ubuntu kernel: [   28.498896] end_request: I/O error,
dev sr0, sector 1424600
Oct 30 11:56:22 ubuntu kernel: [   28.498931] Buffer I/O error on
device sr0, logical block 356150
Oct 30 11:56:22 ubuntu kernel: [   29.308761] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   29.308768] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   30.021792] sr 6:0:0:0: [sr0]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Oct 30 11:56:22 ubuntu kernel: [   30.021863] sr 6:0:0:0: [sr0] Sense
Key : Medium Error [current]
Oct 30 11:56:22 ubuntu kernel: [   30.021981] Info fld=0x56f36
Oct 30 11:56:22 ubuntu kernel: [   30.022013] sr 6:0:0:0: [sr0] Add.
Sense: CIRC unrecovered error
Oct 30 11:56:22 ubuntu kernel: [   30.022104] end_request: I/O error,
dev sr0, sector 1424600
Oct 30 11:56:22 ubuntu kernel: [   30.022139] Buffer I/O error on
device sr0, logical block 356150
Oct 30 11:56:22 ubuntu kernel: [   30.364639] kjournald starting.
Commit interval 5 seconds
Oct 30 11:56:22 ubuntu kernel: [   30.364647] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 11:56:22 ubuntu kernel: [   32.370277] end_request: I/O error,
dev sr0, sector 1424592
Oct 30 11:56:22 ubuntu kernel: [   32.370316] Buffer I/O error on
device sr0, logical block 178074
Oct 30 11:56:22 ubuntu kernel: [   33.512916] end_request: I/O error,
dev sr0, sector 1424592
Oct 30 11:56:22 ubuntu kernel: [   33.512950] Buffer I/O error on
device sr0, logical block 178074
Oct 30 11:56:22 ubuntu kernel: [   34.655424] end_request: I/O error,
dev sr0, sector 1424592
Oct 30 11:56:22 ubuntu kernel: [   34.655464] Buffer I/O error on
device sr0, logical block 178074
Oct 30 11:56:22 ubuntu kernel: [   36.266407] end_request: I/O error,
dev sr0, sector 1424592
Oct 30 11:56:22 ubuntu kernel: [   36.266445] Buffer I/O error on
device sr0, logical block 178074
Oct 30 11:56:22 ubuntu kernel: [   37.408952] end_request: I/O error,
dev sr0, sector 1424592
Oct 30 11:56:22 ubuntu kernel: [   37.408986] Buffer I/O error on
device sr0, logical block 178074
Oct 30 11:56:22 ubuntu kernel: [   38.551605] end_request: I/O error,
dev sr0, sector 1424592
Oct 30 11:56:22 ubuntu kernel: [   38.551639] Buffer I/O error on
device sr0, logical block 178074
Oct 30 11:56:22 ubuntu kernel: [   39.694090] end_request: I/O error,
dev sr0, sector 1424592
Oct 30 11:56:22 ubuntu kernel: [   39.694125] Buffer I/O error on
device sr0, logical block 178074
Oct 30 11:56:22 ubuntu kernel: [   41.065373] end_request: I/O error,
dev sr0, sector 1424592
Oct 30 11:56:22 ubuntu kernel: [   41.065412] Buffer I/O error on
device sr0, logical block 178074
Oct 30 11:56:22 ubuntu kernel: [   42.207776] end_request: I/O error,
dev sr0, sector 1424592
Oct 30 11:56:22 ubuntu kernel: [   42.207813] Buffer I/O error on
device sr0, logical block 178074
Oct 30 11:56:22 ubuntu kernel: [   42.634991] ISO 9660 Extensions:
Microsoft Joliet Level 3
Oct 30 11:56:22 ubuntu kernel: [   42.726718] ISO 9660 Extensions: RRIP_1991A
Oct 30 11:56:22 ubuntu kernel: [   43.064635] aufs 20080922
Oct 30 11:56:22 ubuntu kernel: [   43.080066] loop: module loaded
Oct 30 11:56:22 ubuntu kernel: [   43.353926] squashfs: version 3.3
(2007/10/31) Phillip Lougher
Oct 30 11:56:22 ubuntu kernel: [   78.281197] end_request: I/O error,
dev sr0, sector 1424592
Oct 30 11:56:22 ubuntu kernel: [   78.281236] Buffer I/O error on
device sr0, logical block 356148
Oct 30 11:56:22 ubuntu kernel: [   78.281272] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [   79.330520] end_request: I/O error,
dev sr0, sector 1424592
Oct 30 11:56:22 ubuntu kernel: [   79.330554] Buffer I/O error on
device sr0, logical block 356148
Oct 30 11:56:22 ubuntu kernel: [   79.330589] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [   80.386837] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [   80.386871] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [   81.445971] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [   81.446005] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [   82.501106] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [   82.501140] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [   83.555735] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [   83.555770] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [   84.610329] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [   84.610364] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [   85.709070] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [   85.709104] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [   86.764132] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [   86.764166] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [  101.409558] udevd version 124 started
Oct 30 11:56:22 ubuntu kernel: [  101.620362] pci_hotplug: PCI Hot
Plug PCI Core version: 0.5
Oct 30 11:56:22 ubuntu kernel: [  101.640155] shpchp: HPC vendor_id
1022 device_id 9602 ss_vid 0 ss_did 0
Oct 30 11:56:22 ubuntu kernel: [  101.640198] shpchp: shpc_init:
cannot reserve MMIO region
Oct 30 11:56:22 ubuntu kernel: [  101.640267] shpchp: Standard Hot
Plug PCI Controller Driver version: 0.4
Oct 30 11:56:22 ubuntu kernel: [  102.258483] input: Power Button (FF)
as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
Oct 30 11:56:22 ubuntu kernel: [  102.286271] ACPI: Power Button (FF) [PWRF]
Oct 30 11:56:22 ubuntu kernel: [  102.286396] input: Power Button (CM)
as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
Oct 30 11:56:22 ubuntu kernel: [  102.317518] ACPI: Power Button (CM) [PWRB]
Oct 30 11:56:22 ubuntu kernel: [  102.430904] ACPI: WMI: Mapper loaded
Oct 30 11:56:22 ubuntu kernel: [  102.560073] ACPI: I/O resource
piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1
[0xb00-0xb0f]
Oct 30 11:56:22 ubuntu kernel: [  102.560118] ACPI: Device needs an ACPI driver
Oct 30 11:56:22 ubuntu kernel: [  102.560157] piix4_smbus
0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
Oct 30 11:56:22 ubuntu kernel: [  102.632996] input: PC Speaker as
/devices/platform/pcspkr/input/input6
Oct 30 11:56:22 ubuntu kernel: [  103.087266] HDA Intel 0000:01:05.1:
PCI INT B -> GSI 19 (level, low) -> IRQ 19
Oct 30 11:56:22 ubuntu kernel: [  103.087322] HDA Intel 0000:01:05.1:
setting latency timer to 64
Oct 30 11:56:22 ubuntu kernel: [  103.168020] ICE1724 0000:03:07.0:
PCI INT A -> GSI 21 (level, low) -> IRQ 21
Oct 30 11:56:22 ubuntu kernel: [  105.036098] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [  105.036138] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [  106.082883] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [  106.082918] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [  107.129050] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [  107.129084] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [  108.184385] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [  108.184426] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [  109.238009] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [  109.238048] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [  110.294095] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [  110.294134] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [  111.346913] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [  111.346952] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [  112.403820] end_request: I/O error,
dev sr0, sector 1424596
Oct 30 11:56:22 ubuntu kernel: [  112.403855] Buffer I/O error on
device sr0, logical block 356149
Oct 30 11:56:22 ubuntu kernel: [  113.845253] Adding 979924k swap on
/dev/sdb1.  Priority:-1 extents:1 across:979924k
Oct 30 11:56:22 ubuntu kernel: [  114.448536] ip_tables: (C) 2000-2006
Netfilter Core Team
Oct 30 11:56:22 ubuntu kernel: [  117.704475] powernow-k8: Found 1 AMD
Phenom(tm) 9350e Quad-Core Processor processors (4 cpu cores) (version
2.20.00)
Oct 30 11:56:22 ubuntu kernel: [  117.704517] powernow-k8:    0 :
pstate 0 (2000 MHz)
Oct 30 11:56:22 ubuntu kernel: [  117.704520] powernow-k8:    1 :
pstate 1 (1000 MHz)
Oct 30 11:56:22 ubuntu avahi-daemon[8891]: Found user 'avahi' (UID
106) and group 'avahi' (GID 116).
Oct 30 11:56:22 ubuntu avahi-daemon[8891]: Successfully dropped root privileges.
Oct 30 11:56:22 ubuntu kernel: [  119.105230] warning: `avahi-daemon'
uses 32-bit capabilities (legacy support in use)
Oct 30 11:56:22 ubuntu avahi-daemon[8891]: avahi-daemon 0.6.23 starting up.
Oct 30 11:56:22 ubuntu avahi-daemon[8891]: Successfully called chroot().
Oct 30 11:56:22 ubuntu avahi-daemon[8891]: Successfully dropped
remaining capabilities.
Oct 30 11:56:22 ubuntu avahi-daemon[8892]: chroot.c: open() failed: No
such file or directory
Oct 30 11:56:22 ubuntu avahi-daemon[8891]: Failed to open
/etc/resolv.conf: Invalid argument
Oct 30 11:56:22 ubuntu avahi-daemon[8891]: No service file found in
/etc/avahi/services.
Oct 30 11:56:22 ubuntu avahi-daemon[8891]: Network interface
enumeration completed.
Oct 30 11:56:22 ubuntu avahi-daemon[8891]: Registering HINFO record
with values 'X86_64'/'LINUX'.
Oct 30 11:56:22 ubuntu avahi-daemon[8891]: Server startup complete.
Host name is ubuntu.local. Local service cookie is 3354321440.
Oct 30 11:56:23 ubuntu kernel: [  119.265599] lp: driver loaded but no
devices found
Oct 30 11:56:23 ubuntu kernel: [  119.421542] ppdev: user-space
parallel port driver
Oct 30 11:56:29 ubuntu acpid: client connected from 9102[108:118]
Oct 30 11:56:30 ubuntu bluetoothd[9151]: Bluetooth daemon
Oct 30 11:56:30 ubuntu kernel: [  127.010844] Bluetooth: Core ver 2.13
Oct 30 11:56:30 ubuntu kernel: [  127.010972] NET: Registered protocol family 31
Oct 30 11:56:30 ubuntu kernel: [  127.010977] Bluetooth: HCI device
and connection manager initialized
Oct 30 11:56:30 ubuntu kernel: [  127.010982] Bluetooth: HCI socket
layer initialized
Oct 30 11:56:30 ubuntu bluetoothd[9151]: Starting SDP server
Oct 30 11:56:30 ubuntu kernel: [  127.072205] Bluetooth: L2CAP ver 2.11
Oct 30 11:56:30 ubuntu kernel: [  127.072215] Bluetooth: L2CAP socket
layer initialized
Oct 30 11:56:31 ubuntu kernel: [  127.271473] Bluetooth: SCO (Voice
Link) ver 0.6
Oct 30 11:56:31 ubuntu kernel: [  127.271486] Bluetooth: SCO socket
layer initialized
Oct 30 11:56:31 ubuntu bluetoothd[9151]: Starting experimental netlink support
Oct 30 11:56:31 ubuntu bluetoothd[9151]: Failed to find Bluetooth netlink family
Oct 30 11:56:31 ubuntu bluetoothd[9151]: Can't init plugin
/usr/lib/bluetooth/plugins/netlink.so
Oct 30 11:56:31 ubuntu kernel: [  127.611788] Bluetooth: BNEP
(Ethernet Emulation) ver 1.3
Oct 30 11:56:31 ubuntu kernel: [  127.611799] Bluetooth: BNEP filters:
protocol multicast
Oct 30 11:56:31 ubuntu kernel: [  127.619449] Bluetooth: RFCOMM socket
layer initialized
Oct 30 11:56:31 ubuntu kernel: [  127.619477] Bluetooth: RFCOMM TTY
layer initialized
Oct 30 11:56:31 ubuntu kernel: [  127.619480] Bluetooth: RFCOMM ver 1.10
Oct 30 11:56:31 ubuntu kernel: [  127.741941] Bridge firewalling registered
Oct 30 11:56:31 ubuntu bluetoothd[9151]: bridge pan0 created
Oct 30 11:56:31 ubuntu kernel: [  127.742246] pan0: Dropping
NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
Oct 30 11:56:32 ubuntu NetworkManager: <info>  starting...
Oct 30 11:56:32 ubuntu NetworkManager: <info>  eth0: driver is 'r8169'.
Oct 30 11:56:32 ubuntu NetworkManager: <info>  Found new Ethernet
device 'eth0'.
Oct 30 11:56:32 ubuntu NetworkManager: <info>  (eth0): exported as
/org/freedesktop/Hal/devices/net_00_1f_d0_56_5e_a0
Oct 30 11:56:32 ubuntu NetworkManager: <info>  Trying to start the
supplicant...
Oct 30 11:56:32 ubuntu NetworkManager: <info>  Trying to start the
system settings daemon...
Oct 30 11:56:32 ubuntu nm-system-settings:    SCPlugin-Ifupdown: init!
Oct 30 11:56:32 ubuntu nm-system-settings:    SCPlugin-Ifupdown:
update_system_hostname
Oct 30 11:56:32 ubuntu nm-system-settings:    SCPluginIfupdown:
management mode: unmanaged
Oct 30 11:56:32 ubuntu nm-system-settings:    SCPlugin-Ifupdown:
devices added (udi:
/org/freedesktop/Hal/devices/net_00_1f_d0_56_5e_a0, iface: eth0)
Oct 30 11:56:32 ubuntu nm-system-settings:    SCPlugin-Ifupdown: end _init.
Oct 30 11:56:32 ubuntu nm-system-settings: Loaded plugin ifupdown: (C)
2008 Canonical Ltd.  To report bugs please use the NetworkManager
mailing list.
Oct 30 11:56:33 ubuntu nm-system-settings: Loaded plugin keyfile: (c)
2007 - 2008 Red Hat, Inc.  To report bugs please use the
NetworkManager mailing list.
Oct 30 11:56:33 ubuntu nm-system-settings:    SCPlugin-Ifupdown:
(16266432) ... get_connections.
Oct 30 11:56:33 ubuntu nm-system-settings:    SCPlugin-Ifupdown:
(16266432) connections count: 0
Oct 30 11:56:33 ubuntu nm-system-settings:    Ifupdown: get unmanaged
devices count: 0
Oct 30 11:56:34 ubuntu /usr/sbin/cron[9282]: (CRON) INFO (pidfile fd = 3)
Oct 30 11:56:34 ubuntu /usr/sbin/cron[9283]: (CRON) STARTUP (fork ok)
Oct 30 11:56:34 ubuntu /usr/sbin/cron[9283]: (CRON) INFO (Running @reboot jobs)
Oct 30 11:56:34 ubuntu acpid: client connected from 9242[0:0]
Oct 30 11:56:35 ubuntu kernel: [  132.041826] pci 0000:01:05.0: PCI
INT A -> GSI 18 (level, low) -> IRQ 18
Oct 30 11:56:36 ubuntu NetworkManager: <info>  (eth0): device state
change: 1 -> 2
Oct 30 11:56:36 ubuntu NetworkManager: <info>  (eth0): bringing up device.
Oct 30 11:56:36 ubuntu kernel: [  132.328550] r8169: eth0: link up
Oct 30 11:56:36 ubuntu kernel: [  132.328569] r8169: eth0: link up
Oct 30 11:56:36 ubuntu NetworkManager: <info>  (eth0): preparing device.
Oct 30 11:56:36 ubuntu NetworkManager: <info>  (eth0): deactivating
device (reason: 2).
Oct 30 11:56:36 ubuntu NetworkManager: <info>  (eth0): carrier now ON
(device state 2)
Oct 30 11:56:36 ubuntu NetworkManager: <info>  (eth0): device state
change: 2 -> 3
Oct 30 11:56:37 ubuntu nm-system-settings: Adding default connection
'Auto eth0' for /org/freedesktop/Hal/devices/net_00_1f_d0_56_5e_a0
Oct 30 11:56:37 ubuntu NetworkManager: <info>  Activation (eth0)
starting connection 'Auto eth0'
Oct 30 11:56:37 ubuntu NetworkManager: <info>  (eth0): device state
change: 3 -> 4
Oct 30 11:56:37 ubuntu NetworkManager: <info>  Activation (eth0) Stage
1 of 5 (Device Prepare) scheduled...
Oct 30 11:56:37 ubuntu NetworkManager: <info>  Activation (eth0) Stage
1 of 5 (Device Prepare) started...
Oct 30 11:56:37 ubuntu NetworkManager: <info>  Activation (eth0) Stage
2 of 5 (Device Configure) scheduled...
Oct 30 11:56:37 ubuntu NetworkManager: <info>  Activation (eth0) Stage
1 of 5 (Device Prepare) complete.
Oct 30 11:56:37 ubuntu NetworkManager: <info>  Activation (eth0) Stage
2 of 5 (Device Configure) starting...
Oct 30 11:56:37 ubuntu NetworkManager: <info>  (eth0): device state
change: 4 -> 5
Oct 30 11:56:37 ubuntu NetworkManager: <info>  Activation (eth0) Stage
2 of 5 (Device Configure) successful.
Oct 30 11:56:37 ubuntu NetworkManager: <info>  Activation (eth0) Stage
3 of 5 (IP Configure Start) scheduled.
Oct 30 11:56:37 ubuntu NetworkManager: <info>  Activation (eth0) Stage
2 of 5 (Device Configure) complete.
Oct 30 11:56:37 ubuntu NetworkManager: <info>  Activation (eth0) Stage
3 of 5 (IP Configure Start) started...
Oct 30 11:56:37 ubuntu NetworkManager: <info>  (eth0): device state
change: 5 -> 7
Oct 30 11:56:37 ubuntu NetworkManager: <info>  Activation (eth0)
Beginning DHCP transaction.
Oct 30 11:56:37 ubuntu NetworkManager: <info>  dhclient started with pid 9385
Oct 30 11:56:37 ubuntu NetworkManager: <info>  Activation (eth0) Stage
3 of 5 (IP Configure Start) complete.
Oct 30 11:56:37 ubuntu dhclient: Internet Systems Consortium DHCP Client V3.1.1
Oct 30 11:56:37 ubuntu dhclient: Copyright 2004-2008 Internet Systems
Consortium.
Oct 30 11:56:37 ubuntu dhclient: All rights reserved.
Oct 30 11:56:37 ubuntu dhclient: For info, please visit
http://www.isc.org/sw/dhcp/
Oct 30 11:56:37 ubuntu dhclient:
Oct 30 11:56:37 ubuntu NetworkManager: <info>  DHCP: device eth0 state
changed (null) -> preinit
Oct 30 11:56:37 ubuntu kernel: [  133.897082] NET: Registered protocol family 17
Oct 30 11:56:37 ubuntu dhclient: Listening on LPF/eth0/00:1f:d0:56:5e:a0
Oct 30 11:56:37 ubuntu dhclient: Sending on   LPF/eth0/00:1f:d0:56:5e:a0
Oct 30 11:56:37 ubuntu dhclient: Sending on   Socket/fallback
Oct 30 11:56:38 ubuntu dhclient: DHCPDISCOVER on eth0 to
255.255.255.255 port 67 interval 5
Oct 30 11:56:38 ubuntu dhclient: DHCPOFFER of 192.168.1.186 from 192.168.1.1
Oct 30 11:56:38 ubuntu dhclient: DHCPREQUEST of 192.168.1.186 on eth0
to 255.255.255.255 port 67
Oct 30 11:56:38 ubuntu dhclient: DHCPACK of 192.168.1.186 from 192.168.1.1
Oct 30 11:56:38 ubuntu NetworkManager: <info>  DHCP: device eth0 state
changed preinit -> bound
Oct 30 11:56:38 ubuntu NetworkManager: <info>  Activation (eth0) Stage
4 of 5 (IP Configure Get) scheduled...
Oct 30 11:56:38 ubuntu dhclient: bound to 192.168.1.186 -- renewal in
41357 seconds.
Oct 30 11:56:38 ubuntu NetworkManager: <info>  Activation (eth0) Stage
4 of 5 (IP Configure Get) started...
Oct 30 11:56:38 ubuntu NetworkManager: <info>    address 192.168.1.186
Oct 30 11:56:38 ubuntu NetworkManager: <info>    prefix 24 (255.255.255.0)
Oct 30 11:56:38 ubuntu NetworkManager: <info>    gateway 192.168.1.1
Oct 30 11:56:38 ubuntu NetworkManager: <info>    nameserver '192.168.1.1'
Oct 30 11:56:38 ubuntu NetworkManager: <info>    domain name 'netz'
Oct 30 11:56:38 ubuntu NetworkManager: <info>  Activation (eth0) Stage
5 of 5 (IP Configure Commit) scheduled...
Oct 30 11:56:38 ubuntu NetworkManager: <info>  Activation (eth0) Stage
4 of 5 (IP Configure Get) complete.
Oct 30 11:56:38 ubuntu NetworkManager: <info>  Activation (eth0) Stage
5 of 5 (IP Configure Commit) started...
Oct 30 11:56:38 ubuntu avahi-daemon[8891]: Joining mDNS multicast
group on interface eth0.IPv4 with address 192.168.1.186.
Oct 30 11:56:38 ubuntu avahi-daemon[8891]: New relevant interface
eth0.IPv4 for mDNS.
Oct 30 11:56:38 ubuntu avahi-daemon[8891]: Registering new address
record for 192.168.1.186 on eth0.IPv4.
Oct 30 11:56:39 ubuntu NetworkManager: <info>  (eth0): device state
change: 7 -> 8
Oct 30 11:56:39 ubuntu NetworkManager: <info>  Policy set 'Auto eth0'
(eth0) as default for routing and DNS.
Oct 30 11:56:39 ubuntu NetworkManager: <info>  Activation (eth0)
successful, device activated.
Oct 30 11:56:39 ubuntu NetworkManager: <info>  Activation (eth0) Stage
5 of 5 (IP Configure Commit) complete.
Oct 30 10:56:41 ubuntu ntpdate[9488]: step time server 91.189.94.4
offset -3599.930487 sec
Oct 30 10:57:45 ubuntu python: hp-systray(init)[9904]: warning: No hp:
or hpfax: devices found in any installed CUPS queue. Exiting.
Oct 30 10:58:26 ubuntu NetworkManager: <WARN>  list_connections_cb():
Couldn't retrieve connections: Did not receive a reply. Possible
causes include: the remote application did not send a reply, the
message bus security policy blocked the reply, the reply timeout
expired, or the network connection was broken..
Oct 30 10:59:22 ubuntu kernel: [  298.928588] kjournald starting.
Commit interval 5 seconds
Oct 30 10:59:22 ubuntu kernel: [  298.928754] EXT3 FS on sda1, internal journal
Oct 30 10:59:22 ubuntu kernel: [  298.928766] EXT3-fs: mounted
filesystem with ordered data mode.
