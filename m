Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0CCPo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:44:29 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:53024 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab0CCPo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:44:27 -0500
Message-ID: <4B8E83D4.6090507@in.ibm.com>
Date: Wed, 03 Mar 2010 21:14:20 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: linux-next@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: -next March 3: Boot failure on x86 (Oops)
References: <20100303174603.5be197ba.sfr@canb.auug.org.au>
In-Reply-To: <20100303174603.5be197ba.sfr@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------020109090908010505000503"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020109090908010505000503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Today's next failed to boot on x86 box with following trace

Unpacking initramfs...
Freeing initrd memory: 10584k freed
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c01a6b12>] pcpu_alloc+0x1cb/0x75e
*pdpt = 00000000005dd001 *pde = 0000000000000000
Oops: 0000 [#1] SMP
last sysfs file:
Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.33-autotest-next-20100303 #1 /eserver xSeries 235 -[86717AX]-
EIP: 0060:[<c01a6b12>] EFLAGS: 00010002 CPU: 1
EIP is at pcpu_alloc+0x1cb/0x75e
EAX: 00000000 EBX: c05c4100 ECX: cccccccc EDX: 00000000
ESI: 000000b0 EDI: 00000005 EBP: f5c69fa8 ESP: f5c69f2c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=f5c68000 task=f5c66ce0 task.ti=f5c68000)
Stack:
 00000000 00000005 61746164 0a383d29 5f656400 61746164 00000004 000000b0
<0> 000a3036 00000286 61637061 29656863 0a36313d c0579100 c058da30 f5c69f94
<0> c01310be c05c41cc 00000028 c058da30 f5c69fa4 c0116a73 c0492091 c0492089
Call Trace:
 [<c058da30>] ? crash_save_vmcoreinfo_init+0x0/0x31a
 [<c01310be>] ? log_buf_kexec_setup+0x3f/0x67
 [<c058da30>] ? crash_save_vmcoreinfo_init+0x0/0x31a
 [<c0116a73>] ? arch_crash_save_vmcoreinfo+0x37/0x3c
 [<c058d9ff>] ? crash_notes_memory_init+0x0/0x31
 [<c01a70be>] ? __alloc_percpu+0xa/0xc
 [<c058da11>] ? crash_notes_memory_init+0x12/0x31
 [<c0101139>] ? do_one_initcall+0x4c/0x131
 [<c057b352>] ? kernel_init+0x127/0x178
 [<c057b22b>] ? kernel_init+0x0/0x178
 [<c0102df6>] ? kernel_thread_helper+0x6/0x10
Code: 45 a8 e9 65 ff ff ff 8b 4d 9c 8b 55 a0 8b 45 84 e8 31 fa ff ff 85 c0 89 45 a4 0f 89 fd 00 00 00 8b 45 84 8b 00 89 45 84 8b 55 84 <8b> 02 0f 18 00 90 8b 45 cc 03 05 a0 9b 57 c0 39 c2 0f 85 67 ff
EIP: [<c01a6b12>] pcpu_alloc+0x1cb/0x75e SS:ESP 0068:f5c69f2c
CR2: 0000000000000000
---[ end trace a7919e7f17c0a725 ]---

x86_64 boots fine. Have attached dmesg log.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------020109090908010505000503
Content-Type: text/plain;
 name="next-0303-log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="next-0303-log"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.33-autotest-next-20100303 (root@x235b) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Wed Mar 3 13:56:30 IST 2010
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009c000 (usable)
 BIOS-e820: 000000000009c000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000005ffd8740 (usable)
 BIOS-e820: 000000005ffd8740 - 000000005ffe0000 (ACPI data)
 BIOS-e820: 000000005ffe0000 - 0000000060000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
DMI 2.3 present.
last_pfn = 0x5ffd8 max_arch_pfn = 0x1000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
found SMP MP-table at [c009c140] 9c140
init_memory_mapping: 0000000000000000-00000000371fe000
RAMDISK: 37599000 - 37fef152
Allocated new RAMDISK: 0077b000 - 011d1152
Move RAMDISK from 0000000037599000 - 0000000037fef151 to 0077b000 - 011d1151
ACPI: RSDP 000fdfc0 00014 (v00 IBM   )
ACPI: RSDT 5ffdff80 00030 (v01 IBM    SERONYXP 00001000 IBM  45444F43)
ACPI: FACP 5ffdff00 00074 (v01 IBM    SERONYXP 00001000 IBM  45444F43)
ACPI: DSDT 5ffd8740 075D2 (v01 IBM    SERGEODE 00001000 MSFT 0100000B)
ACPI: FACS 5ffdfe00 00040
ACPI: APIC 5ffdfe40 00092 (v01 IBM    SERONYXP 00001000 IBM  45444F43)
ACPI: ASF! 5ffdfd80 0004B (v16 IBM    SERONYXP 00000001 IBM  45444F43)
Node: 0, start_pfn: 0, end_pfn: 5ffd8
Reserving total of e00 pages for numa KVA remap
kva_start_pfn ~ 36200 max_low_pfn ~ 371fe
max_pfn = 5ffd8
653MB HIGHMEM available.
881MB LOWMEM available.
  mapped low ram: 0 - 371fe000
  low ram: 0 - 371fe000
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  Normal   0x00001000 -> 0x000371fe
  HighMem  0x000371fe -> 0x0005ffd8
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000001 -> 0x0000009c
    0: 0x00000100 -> 0x0005f000
    0: 0x0005fe00 -> 0x0005ffd8
Using APIC driver default
ACPI: PM-Timer IO Port: 0x488
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, version 17, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x0d] address[0xfec01000] gsi_base[16])
IOAPIC[1]: apic_id 13, version 17, address 0xfec01000, GSI 16-31
ACPI: IOAPIC (id[0x0c] address[0xfec02000] gsi_base[32])
IOAPIC[2]: apic_id 12, version 17, address 0xfec02000, GSI 32-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 60000000 (gap: 60000000:9ec00000)
setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 nr_node_ids:8
PERCPU: Embedded 13 pages/cpu @c1200000 s29140 r0 d24108 u524288
pcpu-alloc: s29140 r0 d24108 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 386419
Policy zone: HighMem
Kernel command line: root=/dev/sda2 console=tty0 console=ttyS0,9600n1 IDENT=1267607421
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
allocated 7863500 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Subtract (48 early reservations)
  #1 [0000001000 - 0000002000]   EX TRAMPOLINE
  #2 [0000100000 - 00007731c4]   TEXT DATA BSS
  #3 [0000774000 - 000077a1d8]             BRK
  #4 [000009c000 - 000009c140]   BIOS reserved
  #5 [000009c140 - 000009c150]    MP-table mpf
  #6 [000009c150 - 000009d0a0]   BIOS reserved
  #7 [000009d22c - 0000100000]   BIOS reserved
  #8 [000009d0a0 - 000009d22c]    MP-table mpc
  #9 [0000002000 - 0000003000]      TRAMPOLINE
  #10 [0000003000 - 0000007000]     ACPI WAKEUP
  #11 [0000007000 - 000000e000]         PGTABLE
  #12 [000077b000 - 00011d1152]     NEW RAMDISK
  #13 [005f000000 - 005fe00000]         KVA RAM
  #14 [0036200000 - 0037000000]          KVA PG
  #15 [00011d2000 - 00011d3000]         BOOTMEM
  #16 [00011d1180 - 00011d1184]         BOOTMEM
  #17 [00011d11c0 - 00011d1280]         BOOTMEM
  #18 [00011d1280 - 00011d1324]         BOOTMEM
  #19 [00011d3000 - 00011d6000]         BOOTMEM
  #20 [00011d1340 - 00011d13bc]         BOOTMEM
  #21 [00011d6000 - 00011d9000]         BOOTMEM
  #22 [00011d13c0 - 00011d144d]         BOOTMEM
  #23 [00011d1480 - 00011d15a0]         BOOTMEM
  #24 [00011d15c0 - 00011d1600]         BOOTMEM
  #25 [00011d1600 - 00011d1640]         BOOTMEM
  #26 [00011d1640 - 00011d1680]         BOOTMEM
  #27 [00011d1680 - 00011d16c0]         BOOTMEM
  #28 [00011d16c0 - 00011d1700]         BOOTMEM
  #29 [00011d1700 - 00011d1740]         BOOTMEM
  #30 [00011d1740 - 00011d1780]         BOOTMEM
  #31 [00011d1780 - 00011d1790]         BOOTMEM
  #32 [00011d17c0 - 00011d1802]         BOOTMEM
  #33 [00011d1840 - 00011d1882]         BOOTMEM
  #34 [0001200000 - 000120d000]         BOOTMEM
  #35 [0001280000 - 000128d000]         BOOTMEM
  #36 [0001300000 - 000130d000]         BOOTMEM
  #37 [0001380000 - 000138d000]         BOOTMEM
  #38 [00011d18c0 - 00011d18c4]         BOOTMEM
  #39 [00011d1900 - 00011d1904]         BOOTMEM
  #40 [00011d1940 - 00011d1950]         BOOTMEM
  #41 [00011d1980 - 00011d1990]         BOOTMEM
  #42 [00011d19c0 - 00011d1a58]         BOOTMEM
  #43 [00011d1a80 - 00011d1ab8]         BOOTMEM
  #44 [00011d9000 - 00011dd000]         BOOTMEM
  #45 [000138d000 - 000140d000]         BOOTMEM
  #46 [000120d000 - 000124d000]         BOOTMEM
  #47 [000140d000 - 0001b8cccc]         BOOTMEM
Initializing HighMem for node 0 (000371fe:0005ffd8)
Memory: 1517652k/1572704k available (2744k kernel code, 40312k reserved, 1842k data, 356k init, 655208k highmem)
virtual kernel memory layout:
    fixmap  : 0xff5b6000 - 0xfffff000   (10532 kB)
    pkmap   : 0xff200000 - 0xff400000   (2048 kB)
    vmalloc : 0xf79fe000 - 0xff1fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf71fe000   ( 881 MB)
      .init : 0xc057b000 - 0xc05d4000   ( 356 kB)
      .data : 0xc03ae3e8 - 0xc057ad88   (1842 kB)
      .text : 0xc0100000 - 0xc03ae3e8   (2744 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
NR_IRQS:2304
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Fast TSC calibration using PIT
Detected 2793.676 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5587.35 BogoMIPS (lpj=11174704)
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 4 MCE banks
CPU0: Thermal monitoring enabled (TM1)
Performance Events: no PMU driver, software events only.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20100121
Enabling APIC mode:  Flat.  Using 3 I/O APICs
Mapping cpu 0 to node 0
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(TM) CPU 2.80GHz stepping 07
Booting Node   0, Processors  #1
Initializing CPU#1
Mapping cpu 1 to node 0
 #2
Initializing CPU#2
Mapping cpu 2 to node 0
 #3 Ok.
Initializing CPU#3
Mapping cpu 3 to node 0
Brought up 4 CPUs
Total of 4 processors activated (22352.10 BogoMIPS).
devtmpfs: initialized
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd7bc, last bus=10
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Root Bridge [PCI1] (0000:02)
ACPI: PCI Root Bridge [PCI2] (0000:05)
ACPI: PCI Root Bridge [PCI3] (0000:07)
ACPI: PCI Root Bridge [PCI4] (0000:09)
vgaarb: device added: PCI:0000:00:09.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
PCI: Using ACPI for IRQ routing
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 17 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
system 00:01: [io  0x0900-0x093f] has been reserved
system 00:01: [io  0x0510-0x0517] has been reserved
system 00:01: [io  0x0504-0x0507] has been reserved
system 00:01: [io  0x0500-0x0503] has been reserved
system 00:01: [io  0x0520-0x053f] has been reserved
system 00:01: [io  0x0420-0x0427] has been reserved
system 00:01: [io  0x0460-0x0461] has been reserved
system 00:0c: [io  0x01ec-0x01ef] has been reserved
system 00:0c: [io  0x0400-0x04fe] could not be reserved
system 00:0c: [io  0x0600] has been reserved
system 00:0c: [io  0x0800-0x080f] has been reserved
system 00:0c: [io  0x0c00-0x0cfe] could not be reserved
system 00:0c: [io  0x0f50-0x0f58] has been reserved
system 00:0c: [mem 0xfec00000-0xffffffff] could not be reserved
pci 0000:00:09.0: BAR 6: assigned [mem 0x60000000-0x6001ffff pref]
pci 0000:05:03.0: BAR 6: assigned [mem 0x60020000-0x60027fff pref]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
Unpacking initramfs...
Freeing initrd memory: 10584k freed
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c01a6b12>] pcpu_alloc+0x1cb/0x75e
*pdpt = 00000000005dd001 *pde = 0000000000000000 
Oops: 0000 [#1] SMP 
last sysfs file: 
Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.33-autotest-next-20100303 #1 /eserver xSeries 235 -[86717AX]-
EIP: 0060:[<c01a6b12>] EFLAGS: 00010002 CPU: 1
EIP is at pcpu_alloc+0x1cb/0x75e
EAX: 00000000 EBX: c05c4100 ECX: cccccccc EDX: 00000000
ESI: 000000b0 EDI: 00000005 EBP: f5c69fa8 ESP: f5c69f2c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=f5c68000 task=f5c66ce0 task.ti=f5c68000)
Stack:
 00000000 00000005 61746164 0a383d29 5f656400 61746164 00000004 000000b0
<0> 000a3036 00000286 61637061 29656863 0a36313d c0579100 c058da30 f5c69f94
<0> c01310be c05c41cc 00000028 c058da30 f5c69fa4 c0116a73 c0492091 c0492089
Call Trace:
 [<c058da30>] ? crash_save_vmcoreinfo_init+0x0/0x31a
 [<c01310be>] ? log_buf_kexec_setup+0x3f/0x67
 [<c058da30>] ? crash_save_vmcoreinfo_init+0x0/0x31a
 [<c0116a73>] ? arch_crash_save_vmcoreinfo+0x37/0x3c
 [<c058d9ff>] ? crash_notes_memory_init+0x0/0x31
 [<c01a70be>] ? __alloc_percpu+0xa/0xc
 [<c058da11>] ? crash_notes_memory_init+0x12/0x31
 [<c0101139>] ? do_one_initcall+0x4c/0x131
 [<c057b352>] ? kernel_init+0x127/0x178
 [<c057b22b>] ? kernel_init+0x0/0x178
 [<c0102df6>] ? kernel_thread_helper+0x6/0x10
Code: 45 a8 e9 65 ff ff ff 8b 4d 9c 8b 55 a0 8b 45 84 e8 31 fa ff ff 85 c0 89 45 a4 0f 89 fd 00 00 00 8b 45 84 8b 00 89 45 84 8b 55 84 <8b> 02 0f 18 00 90 8b 45 cc 03 05 a0 9b 57 c0 39 c2 0f 85 67 ff 
EIP: [<c01a6b12>] pcpu_alloc+0x1cb/0x75e SS:ESP 0068:f5c69f2c
CR2: 0000000000000000
---[ end trace a7919e7f17c0a725 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D    2.6.33-autotest-next-20100303 #1
Call Trace:
 [<c03a72e2>] ? printk+0xf/0x15
 [<c03a7227>] panic+0x39/0xe5
 [<c0132dae>] do_exit+0x5c/0x5e3
 [<c0130a7c>] ? kmsg_dump+0xe4/0xf8
 [<c012fddb>] ? oops_exit+0x2a/0x2f
 [<c03aa5a1>] oops_end+0x93/0x9b
 [<c0119f8e>] no_context+0x13f/0x149
 [<c0289edf>] ? number+0x11f/0x1da
 [<c011a0f8>] __bad_area_nosemaphore+0x160/0x168
 [<c028a4b3>] ? string+0x33/0x81
 [<c028b3f1>] ? vsnprintf+0x4fe/0x6d1
 [<c011a10d>] bad_area_nosemaphore+0xd/0x10
 [<c03abf1c>] do_page_fault+0x199/0x2f7
 [<c03abd83>] ? do_page_fault+0x0/0x2f7
 [<c03a9c86>] error_code+0x66/0x70
 [<c015007b>] ? sys_futex+0x93/0xff
 [<c03abd83>] ? do_page_fault+0x0/0x2f7
 [<c01a6b12>] ? pcpu_alloc+0x1cb/0x75e
 [<c058da30>] ? crash_save_vmcoreinfo_init+0x0/0x31a
 [<c01310be>] ? log_buf_kexec_setup+0x3f/0x67
 [<c058da30>] ? crash_save_vmcoreinfo_init+0x0/0x31a
 [<c0116a73>] ? arch_crash_save_vmcoreinfo+0x37/0x3c
 [<c058d9ff>] ? crash_notes_memory_init+0x0/0x31
 [<c01a70be>] __alloc_percpu+0xa/0xc
 [<c058da11>] crash_notes_memory_init+0x12/0x31
 [<c0101139>] do_one_initcall+0x4c/0x131
 [<c057b352>] kernel_init+0x127/0x178
 [<c057b22b>] ? kernel_init+0x0/0x178
 [<c0102df6>] kernel_thread_helper+0x6/0x10


--------------020109090908010505000503--
