Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbYLVJiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbYLVJiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 04:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYLVJiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 04:38:01 -0500
Received: from newbox.bazarnic.net ([209.188.29.80]:38112 "EHLO
	newbox.bazarnic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbYLVJh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 04:37:58 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=private; d=bazarnic.net;
  b=RkQFWmdgyf2MGqNRbfkmIiDBv79z3f5yjTYf7UGIjIP/qcAYSYQ8uNOfwn1MQ+S1;
From: "Kernel" <kernel@bazarnic.net>
To: <linux-kernel@vger.kernel.org>
Subject: Oops in 2.6.28-rc9 and -rc8 -- mtrr issues / e1000e
Date: Mon, 22 Dec 2008 02:37:50 -0700
Message-ID: <00d601c96418$f4b42850$de1c78f0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AclkGPN7Y8H7S6D5R+ydfCtCj3/spg==
Content-Language: en-us
x-cr-hashedpuzzle: AlR8 BJ5d BXlo Bl7S B0Xy CJRq DJ0n ENdb GN3K HoYH Hr3d IR8o JEhf JSCE JTNb JYN3;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{68F52142-DFD2-4173-9B8F-1B79D7293CED};awBlAHIAbgBlAGwAQABiAGEAegBhAHIAbgBpAGMALgBuAGUAdAA=;Mon, 22 Dec 2008 09:37:48 GMT;TwBvAHAAcwAgAGkAbgAgADIALgA2AC4AMgA4AC0AcgBjADkAIABhAG4AZAAgAC0AcgBjADgAIAAtAC0AIABtAHQAcgByACAAaQBzAHMAdQBlAHMAIAAvACAAZQAxADAAMAAwAGUA
x-cr-puzzleid: {68F52142-DFD2-4173-9B8F-1B79D7293CED}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please forgive my posting “newness”.  If there’s anything I’m missing,
please let me know. 

I’ve got a brand new machine that I’m having a terrible time trying to keep
up and running with any “newer” kernels.   I have about 8 of these servers
that don’t have an issue, but they’re running older kernels and or don’t
have the load of this machine.

As of right now, I’m running Centos 5.2 x86-64 on a Tyan 5397 MB with (2)
Quad Core Intel CPUs, 32GB of ram (16 2GB sticks, ECC FBDIMMS), and a large
24 drive raid on an Adaptec AACRAID card.   Right now, I’ve got the board
back on bios v1.03.  I’ve tried 1.04 and 1.04beta.   Since my other systems
don’t have this issue, I thought it was a bad MB.  It was not.  Problems
persist on both new boards.    X86-64 gets me much longer “uptimes” than
32bit RHEL 5.2.   The e1000e’s enabled causes the box to crash much, much
sooner.  I have a feeling their reserved memory is getting stomped on,
causing the grief.   Memory tests clean, and there are no ECC events listed
in bios.  Bios 1.04beta did show correct memory sizing in dmidecode, as its
fix on Tyan’s website says DMI Table update.

By bypassing the onboard nics (e1000e) and using some older pci-x Intel
e1000 cards, I can get the box to stay up for around 11 hours.   Sometimes
5, and sometimes 14 hours.  If I use the onboard e1000e nics, I’ll get a
tx_unit_hang error within hours.   The server is doing about 300-400 mbits
of webserving.   Server loads are around 0.4-1.0.

I hope this is as simple as me doing something glaringly wrong in the kernel
config, and missing something vital.   Btw, I get the same crashes in
2.6.27.6 and 2.6.27.9 as well.   One of the other servers like this one,
doesn’t have any issues with 2.6.27.6, RHEL 5.2 32bit.  

Thanks!

Doug Bazarnic

Uname:
Linux mem3 2.6.28-rc9 #9 SMP Sat Dec 20 18:56:23 MST 2008 x86_64 x86_64
x86_64 GNU/Linux

This spits up at the terminal, and box will go down within minutes:
root@mem3 etc]# 
Message from syslogd@ at Mon Dec 22 00:40:57 2008 ...
mem3 kernel: Bad page state in process 'kswapd0'
Message from syslogd@ at Mon Dec 22 00:40:57 2008 ...
mem3 kernel: page:ffffe20010b36b88 flags:0x80001a0000010008
mapping:0000000000000000 mapcount:-721420288 count:0
Message from syslogd@ at Mon Dec 22 00:40:57 2008 ...
mem3 kernel: Trying to fix it up, but a reboot is needed
Message from syslogd@ at Mon Dec 22 00:40:57 2008 ...
mem3 kernel: Backtrace:

dmesg of the crash shows:  (Box must be hard rebooted to come back up –
reboot or ctrl-alt-del does nothing)
Bad page state in process 'kswapd0'
page:ffffe20010b36b88 flags:0x80001a0000010008 mapping:0000000000000000
mapcount:-721420288 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
Pid: 377, comm: kswapd0 Tainted: G        W  2.6.28-rc9 #9
Call Trace:
 [<ffffffff80263bc2>] bad_page+0x6b/0x96
 [<ffffffff80264562>] free_hot_cold_page+0xa0/0x192
 [<ffffffff80264675>] __pagevec_free+0x21/0x2e
 [<ffffffff80269281>] shrink_page_list+0x51a/0x608
 [<ffffffff802695b0>] shrink_list+0x241/0x501
 [<ffffffff8024189b>] bit_waitqueue+0x10/0x8e
 [<ffffffff80265cb9>] determine_dirtyable_memory+0xd/0x20
 [<ffffffff8022acbb>] enqueue_task_fair+0xd6/0xea
 [<ffffffff80269ad4>] shrink_zone+0x264/0x2e8
 [<ffffffff8026a3e2>] kswapd+0x383/0x4c3
 [<ffffffff8026823d>] isolate_pages_global+0x0/0x21d
 [<ffffffff8051b979>] thread_return+0x3d/0xa2
 [<ffffffff80241968>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026a05f>] kswapd+0x0/0x4c3
 [<ffffffff8024184c>] kthread+0x47/0x73
 [<ffffffff8022ceb8>] schedule_tail+0x28/0x60
 [<ffffffff8020c029>] child_rip+0xa/0x11
 [<ffffffff80241805>] kthread+0x0/0x73
 [<ffffffff8020c01f>] child_rip+0x0/0x11

Full dmesg on rebooted box:  (note the mtrr warnings)

BIOS EBDA/lowmem at: 0009a000/0009a000
Linux version 2.6.28-rc9 (root@localhost.localdomain) (gcc version 4.1.2
20071124 (Red Hat 4.1.2-42)) #9 SMP Sat Dec 20 18:56:23 MST 2008
Command line: ro root=LABEL=/
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009a000 (usable)
 BIOS-e820: 000000000009a000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000c8000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bff50000 (usable)
 BIOS-e820: 00000000bff50000 - 00000000bff5f000 (ACPI data)
 BIOS-e820: 00000000bff5f000 - 00000000bff60000 (ACPI NVS)
 BIOS-e820: 00000000bff60000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000840000000 (usable)
DMI present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
last_pfn = 0x840000 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
------------[ cut here ]------------
WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404
generic_get_mtrr+0xbc/0xf5()
mtrr: your BIOS has set up an incorrect mask, fixing it up.
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.28-rc9 #9
Call Trace:
 [<ffffffff80230b9c>] warn_slowpath+0xf3/0x111
 [<ffffffff80231828>] printk+0x8d/0x95
 [<ffffffff8021672b>] post_set+0x20/0x3d
 [<ffffffff80231828>] printk+0x8d/0x95
 [<ffffffff80216c07>] generic_get_mtrr+0xbc/0xf5
 [<ffffffff806e0d69>] mtrr_trim_uncached_memory+0x7b/0x2fe
 [<ffffffff806e85a2>] early_gart_iommu_check+0x9e/0x268
 [<ffffffff806dd01c>] setup_arch+0x3e9/0x619
 [<ffffffff806d6959>] start_kernel+0x6f/0x325
 [<ffffffff806d638e>] x86_64_start_kernel+0xde/0xe2
---[ end trace 4eaa2a86a8e2da22 ]---
last_pfn = 0xbff50 max_arch_pfn = 0x3ffffffff
init_memory_mapping: 0000000000000000-00000000bff50000
 0000000000 - 00bfe00000 page 2M
 00bfe00000 - 00bff50000 page 4k
kernel direct mapping tables up to bff50000 @ 10000-15000
last_map_addr: bff50000 end: bff50000
init_memory_mapping: 0000000100000000-0000000840000000
 0100000000 - 0840000000 page 2M
kernel direct mapping tables up to 840000000 @ 13000-35000
last_map_addr: 840000000 end: 840000000
RAMDISK: 37dd3000 - 37fefa9c
ACPI: RSDP 000F7060, 0024 (r2 PTLTD )
ACPI: XSDT BFF58E2F, 009C (r1 PTLTD      XSDT    6040000  LTP        0)
ACPI: FACP BFF5ED60, 00F4 (r3 INTEL  TUMWATER  6040000 PTL         3)
ACPI: DSDT BFF5A9B9, 4333 (r1  Intel SEABURG   6040000 MSFT  3000000)
ACPI: FACS BFF5FFC0, 0040
ACPI: _MAR BFF5EE54, 0030 (r1 Intel  OEMDMAR   6040000 LOHR        1)
ACPI: APIC BFF5EE84, 00C8 (r1 PTLTD      APIC    6040000  LTP        0)
ACPI: MCFG BFF5EF4C, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
ACPI: BOOT BFF5EF88, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: SPCR BFF5EFB0, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
ACPI: SSDT BFF5A75A, 025F (r1  PmRef  Cpu0Tst     3000 INTL 20050228)
ACPI: SSDT BFF5A6B4, 00A6 (r1  PmRef  Cpu7Tst     3000 INTL 20050228)
ACPI: SSDT BFF5A60E, 00A6 (r1  PmRef  Cpu6Tst     3000 INTL 20050228)
ACPI: SSDT BFF5A568, 00A6 (r1  PmRef  Cpu5Tst     3000 INTL 20050228)
ACPI: SSDT BFF5A4C2, 00A6 (r1  PmRef  Cpu4Tst     3000 INTL 20050228)
ACPI: SSDT BFF5A41C, 00A6 (r1  PmRef  Cpu3Tst     3000 INTL 20050228)
ACPI: SSDT BFF5A376, 00A6 (r1  PmRef  Cpu2Tst     3000 INTL 20050228)
ACPI: SSDT BFF5A2D0, 00A6 (r1  PmRef  Cpu1Tst     3000 INTL 20050228)
ACPI: SSDT BFF58ECB, 1405 (r1  PmRef    CpuPm     3000 INTL 20050228)
ACPI: Local APIC address 0xfee00000
(7 early reservations) ==> bootmem [0000000000 - 0840000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 -
0000008000]
  #2 [0000200000 - 00007e0f54]    TEXT DATA BSS ==> [0000200000 -
00007e0f54]
  #3 [0037dd3000 - 0037fefa9c]          RAMDISK ==> [0037dd3000 -
0037fefa9c]
  #4 [000009a000 - 0000100000]    BIOS reserved ==> [000009a000 -
0000100000]
  #5 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 -
0000013000]
  #6 [0000013000 - 0000030000]          PGTABLE ==> [0000013000 -
0000030000]
 [ffffe20000000000-ffffe2000f9fffff] PMD ->
[ffff880028200000-ffff880037bfffff] on node 0
 [ffffe2000fa00000-ffffe2001cdfffff] PMD ->
[ffff880038000000-ffff8800453fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00840000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009a
    0: 0x00000100 -> 0x000bff50
    0: 0x00100000 -> 0x00840000
On node 0 totalpages: 8388314
  DMA zone: 56 pages used for memmap
  DMA zone: 1641 pages reserved
  DMA zone: 2281 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 767880 pages, LIFO batch:31
  Normal zone: 103936 pages used for memmap
  Normal zone: 7498240 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec88000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 0, address 0xfec88000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
SMP: Allowing 8 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
PERCPU: Allocating 45056 bytes of per cpu data
NR_CPUS: 16, nr_cpu_ids: 8, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8268401
Kernel command line: ro root=LABEL=/
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC: PIT calibration matches PMTIMER. 1 loops
Detected 2659.992 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Checking aperture...
No AGP bridge found
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x20000000 - 0x24000000
Memory: 32954916k/34603008k available (3212k kernel code, 1049752k absent,
597392k reserved, 1537k data, 388k init)
Calibrating delay loop (skipped), value calculated using timer frequency..
5319.98 BogoMIPS (lpj=2659992)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
Freeing SMP alternatives: 29k freed
ACPI: Core revision 20080926
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
Booting processor 1 APIC 0x4 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5319.27 BogoMIPS
(lpj=2659639)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2 APIC 0x1 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 5319.23 BogoMIPS
(lpj=2659618)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3 APIC 0x5 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 5319.26 BogoMIPS
(lpj=2659634)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU3: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Booting processor 4 APIC 0x2 ip 0x6000
Initializing CPU#4
Calibrating delay using timer specific routine.. 5319.24 BogoMIPS
(lpj=2659621)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU4: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
CPU4: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#4]: passed.
Booting processor 5 APIC 0x6 ip 0x6000
Initializing CPU#5
Calibrating delay using timer specific routine.. 5319.25 BogoMIPS
(lpj=2659627)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 2
CPU5: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
CPU5: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#5]: passed.
Booting processor 6 APIC 0x3 ip 0x6000
Initializing CPU#6
Calibrating delay using timer specific routine.. 5319.22 BogoMIPS
(lpj=2659612)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU6: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
CPU6: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#6]: passed.
Booting processor 7 APIC 0x7 ip 0x6000
Initializing CPU#7
Calibrating delay using timer specific routine.. 5319.26 BogoMIPS
(lpj=2659633)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 3
CPU7: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
CPU7: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#7]: passed.
Brought up 8 CPUs
Total of 8 processors activated (42554.75 BogoMIPS).
net_namespace: 552 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 31
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - e1ffffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x1800-0x181f]
pci 0000:00:1d.1: reg 20 io port: [0x1820-0x183f]
pci 0000:00:1d.2: reg 20 io port: [0x1840-0x185f]
pci 0000:00:1d.3: reg 20 io port: [0x1860-0x187f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xdc704000-0xdc7043ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x1880-0x188f]
pci 0000:00:1f.2: reg 10 io port: [0x18d0-0x18d7]
pci 0000:00:1f.2: reg 14 io port: [0x18c8-0x18cb]
pci 0000:00:1f.2: reg 18 io port: [0x18c0-0x18c7]
pci 0000:00:1f.2: reg 1c io port: [0x1894-0x1897]
pci 0000:00:1f.2: reg 20 io port: [0x18a0-0x18bf]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xdc704400-0xdc7047ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20 io port: [0x18e0-0x18ff]
pci 0000:01:00.0: reg 10 64bit mmio: [0xdc000000-0xdc1fffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x07ffff]
pci 0000:01:00.0: supports D1
pci 0000:00:01.0: bridge 32bit mmio: [0xdc000000-0xdc1fffff]
pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
pci 0000:09:00.0: PME# disabled
pci 0000:09:00.3: PME# supported from D0 D3hot D3cold
pci 0000:09:00.3: PME# disabled
pci 0000:00:09.0: bridge io port: [0x2000-0x2fff]
pci 0000:00:09.0: bridge 32bit mmio: [0xdc200000-0xdc3fffff]
pci 0000:0a:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0a:00.0: PME# disabled
pci 0000:0a:02.0: PME# supported from D0 D3hot D3cold
pci 0000:0a:02.0: PME# disabled
pci 0000:10:09.0: reg 10 64bit mmio: [0xdc280000-0xdc29ffff]
pci 0000:10:09.0: reg 18 64bit mmio: [0xdc200000-0xdc23ffff]
pci 0000:10:09.0: reg 20 io port: [0x2000-0x203f]
pci 0000:10:09.0: reg 30 32bit mmio: [0x000000-0x03ffff]
pci 0000:10:0a.0: reg 10 64bit mmio: [0xdc2a0000-0xdc2bffff]
pci 0000:10:0a.0: reg 18 64bit mmio: [0xdc240000-0xdc27ffff]
pci 0000:10:0a.0: reg 20 io port: [0x2040-0x207f]
pci 0000:10:0a.0: reg 30 32bit mmio: [0x000000-0x03ffff]
pci 0000:10:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:10:0a.0: PME# disabled
pci 0000:09:00.3: bridge io port: [0x2000-0x2fff]
pci 0000:09:00.3: bridge 32bit mmio: [0xdc200000-0xdc2fffff]
pci 0000:20:05.0: reg 10 32bit mmio: [0xd8000000-0xdbffffff]
pci 0000:20:05.0: reg 14 32bit mmio: [0xdc400000-0xdc43ffff]
pci 0000:20:05.0: reg 18 io port: [0x3000-0x307f]
pci 0000:20:05.0: supports D1 D2
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0x3000-0x3fff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xdc400000-0xdc4fffff]
pci 0000:00:1e.0: bridge 64bit mmio pref: [0xd8000000-0xdbffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0.BPD0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0.BPD2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMF3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 14 15) *9
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 14 15) *12
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 *10 11 14 15)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
dca service started, version 1.4
PCI: Using ACPI for IRQ routing
PCI-GART: No AMD GART found.
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x800-0x80f has been reserved
system 00:01: ioport range 0x1000-0x107f has been reserved
system 00:01: ioport range 0x1180-0x11bf has been reserved
system 00:01: ioport range 0xfe00-0xfe00 has been reserved
system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
system 00:01: iomem range 0xfee00000-0xfee0ffff could not be reserved
system 00:01: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfec88000-0xfec88fff has been reserved
system 00:01: iomem range 0xfe000000-0xfe01ffff has been reserved
system 00:01: iomem range 0xfe600000-0xfe6fffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: 0xdc000000-0xdc1fffff
pci 0000:00:01.0:   PREFETCH window: 0x000000c2000000-0x000000c20fffff
pci 0000:00:05.0: PCI bridge, secondary bus 0000:05
pci 0000:00:05.0:   IO window: disabled
pci 0000:00:05.0:   MEM window: disabled
pci 0000:00:05.0:   PREFETCH window: disabled
pci 0000:0a:00.0: PCI bridge, secondary bus 0000:0b
pci 0000:0a:00.0:   IO window: disabled
pci 0000:0a:00.0:   MEM window: disabled
pci 0000:0a:00.0:   PREFETCH window: disabled
pci 0000:0a:02.0: PCI bridge, secondary bus 0000:0f
pci 0000:0a:02.0:   IO window: disabled
pci 0000:0a:02.0:   MEM window: disabled
pci 0000:0a:02.0:   PREFETCH window: disabled
pci 0000:09:00.0: PCI bridge, secondary bus 0000:0a
pci 0000:09:00.0:   IO window: disabled
pci 0000:09:00.0:   MEM window: disabled
pci 0000:09:00.0:   PREFETCH window: disabled
pci 0000:09:00.3: PCI bridge, secondary bus 0000:10
pci 0000:09:00.3:   IO window: 0x2000-0x2fff
pci 0000:09:00.3:   MEM window: 0xdc200000-0xdc2fffff
pci 0000:09:00.3:   PREFETCH window: 0x000000c2100000-0x000000c21fffff
pci 0000:00:09.0: PCI bridge, secondary bus 0000:09
pci 0000:00:09.0:   IO window: 0x2000-0x2fff
pci 0000:00:09.0:   MEM window: 0xdc200000-0xdc3fffff
pci 0000:00:09.0:   PREFETCH window: 0x000000c2100000-0x000000c21fffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:1f
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:20
pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
pci 0000:00:1e.0:   MEM window: 0xdc400000-0xdc4fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000d8000000-0x000000dbffffff
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:09.0: setting latency timer to 64
pci 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:09:00.0: setting latency timer to 64
pci 0000:0a:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:0a:00.0: setting latency timer to 64
pci 0000:0a:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:0a:02.0: setting latency timer to 64
pci 0000:09:00.3: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
bus: 01 index 0 mmio: [0x0-0x0]
bus: 01 index 1 mmio: [0xdc000000-0xdc1fffff]
bus: 01 index 2 mmio: [0xc2000000-0xc20fffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 05 index 0 mmio: [0x0-0x0]
bus: 05 index 1 mmio: [0x0-0x0]
bus: 05 index 2 mmio: [0x0-0x0]
bus: 05 index 3 mmio: [0x0-0x0]
bus: 09 index 0 io port: [0x2000-0x2fff]
bus: 09 index 1 mmio: [0xdc200000-0xdc3fffff]
bus: 09 index 2 mmio: [0xc2100000-0xc21fffff]
bus: 09 index 3 mmio: [0x0-0x0]
bus: 0a index 0 mmio: [0x0-0x0]
bus: 0a index 1 mmio: [0x0-0x0]
bus: 0a index 2 mmio: [0x0-0x0]
bus: 0a index 3 mmio: [0x0-0x0]
bus: 0b index 0 mmio: [0x0-0x0]
bus: 0b index 1 mmio: [0x0-0x0]
bus: 0b index 2 mmio: [0x0-0x0]
bus: 0b index 3 mmio: [0x0-0x0]
bus: 0f index 0 mmio: [0x0-0x0]
bus: 0f index 1 mmio: [0x0-0x0]
bus: 0f index 2 mmio: [0x0-0x0]
bus: 0f index 3 mmio: [0x0-0x0]
bus: 10 index 0 io port: [0x2000-0x2fff]
bus: 10 index 1 mmio: [0xdc200000-0xdc2fffff]
bus: 10 index 2 mmio: [0xc2100000-0xc21fffff]
bus: 10 index 3 mmio: [0x0-0x0]
bus: 1f index 0 mmio: [0x0-0x0]
bus: 1f index 1 mmio: [0x0-0x0]
bus: 1f index 2 mmio: [0x0-0x0]
bus: 1f index 3 mmio: [0x0-0x0]
bus: 20 index 0 io port: [0x3000-0x3fff]
bus: 20 index 1 mmio: [0xdc400000-0xdc4fffff]
bus: 20 index 2 mmio: [0xd8000000-0xdbffffff]
bus: 20 index 3 io port: [0x00-0xffff]
bus: 20 index 4 mmio: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 2162k freed
Simple Boot Flag at 0x40 set to 0x80
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
alg: cipher: Test 1 failed on encryption for aes-asm
00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 
audit: initializing netlink socket (disabled)
type=2000 audit(1229934097.774:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SGI XFS with security attributes, large block/inode numbers, no debug
enabled
msgmni has been set to 32768
alg: No test for cipher_null (cipher_null-generic)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:20:05.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
pcieport-driver 0000:00:01.0: irq 767 for MSI/MSI-X
pci_express 0000:00:01.0:pcie00: allocate port service
pci_express 0000:00:01.0:pcie01: allocate port service
pcieport-driver 0000:00:05.0: setting latency timer to 64
pcieport-driver 0000:00:05.0: found MSI capability
pcieport-driver 0000:00:05.0: irq 766 for MSI/MSI-X
pci_express 0000:00:05.0:pcie00: allocate port service
pci_express 0000:00:05.0:pcie01: allocate port service
pcieport-driver 0000:00:09.0: setting latency timer to 64
pcieport-driver 0000:00:09.0: found MSI capability
pcieport-driver 0000:00:09.0: irq 765 for MSI/MSI-X
pci_express 0000:00:09.0:pcie00: allocate port service
pci_express 0000:00:09.0:pcie01: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pcieport-driver 0000:00:1c.0: irq 764 for MSI/MSI-X
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:09:00.0: setting latency timer to 64
pci_express 0000:09:00.0:pcie11: allocate port service
pcieport-driver 0000:0a:00.0: setting latency timer to 64
pcieport-driver 0000:0a:00.0: found MSI capability
pcieport-driver 0000:0a:00.0: irq 763 for MSI/MSI-X
pci_express 0000:0a:00.0:pcie21: allocate port service
pcieport-driver 0000:0a:02.0: setting latency timer to 64
pcieport-driver 0000:0a:02.0: found MSI capability
pcieport-driver 0000:0a:02.0: irq 762 for MSI/MSI-X
pci_express 0000:0a:02.0:pcie21: allocate port service
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
processor ACPI_CPU:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
processor ACPI_CPU:02: registered as cooling_device2
ACPI: Processor [CPU2] (supports 8 throttling states)
processor ACPI_CPU:03: registered as cooling_device3
ACPI: Processor [CPU3] (supports 8 throttling states)
processor ACPI_CPU:04: registered as cooling_device4
ACPI: Processor [CPU4] (supports 8 throttling states)
processor ACPI_CPU:05: registered as cooling_device5
ACPI: Processor [CPU5] (supports 8 throttling states)
processor ACPI_CPU:06: registered as cooling_device6
ACPI: Processor [CPU6] (supports 8 throttling states)
processor ACPI_CPU:07: registered as cooling_device7
ACPI: Processor [CPU7] (supports 8 throttling states)
Non-volatile memory driver v1.2
intel_rng: FWH not detected
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Switched to high resolution mode on CPU 6
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 7
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 4
Switched to high resolution mode on CPU 5
Switched to high resolution mode on CPU 0
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
Uniform Multi-Platform E-IDE driver
Driver 'sd' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 23 (level, low) -> IRQ 23
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA
mode
ahci 0000:00:1f.2: flags: 64bit pm led pmp slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400040,  irq 23
ata2: SATA max UDMA/133 abar m1024@0xdc704400 port 0xdc704580 irq 23
ata3: SATA max UDMA/133 abar m1024@0xdc704400 port 0xdc704600 irq 23
ata4: SATA max UDMA/133 abar m1024@0xdc704400 port 0xdc704680 irq 23
ata5: SATA max UDMA/133 abar m1024@0xdc704400 port 0xdc704700 irq 23
ata6: SATA max UDMA/133 abar m1024@0xdc704400 port 0xdc704780 irq 23
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: ST3500320AS, SD15, max UDMA/133
ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi6 : ata_piix
scsi7 : ata_piix
ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1880 irq 14
ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1888 irq 15
ata8: port disabled. ignoring.
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xdc704000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001820
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001840
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001860
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
i2c /dev entries driver
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 23 (level, low) -> IRQ 23
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
drivers/rtc/hctosys.c: unable to open rtc device (rtc)
Freeing unused kernel memory: 388k freed
Write protecting the kernel read-only data: 4376k
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
input: PC Speaker as /class/input/input0
Adaptec aacraid driver 1.1-5[2456]-ms
aacraid 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
aacraid 0000:01:00.0: setting latency timer to 64
input: Power Button (FF) as /class/input/input1
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
Intel(R) PRO/1000 Network Driver - version 8.0.6a
Copyright (c) 1999-2008 Intel Corporation.
e1000 0000:10:09.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
AAC0: kernel 5.2-0[16343] Nov 20 2008
AAC0: monitor 5.2-0[16343]
AAC0: bios 5.2-0[16343]
AAC0: serial 8A32108386D
AAC0: Non-DASD support enabled.
AAC0: 64bit support enabled.
AAC0: 64 Bit DAC enabled
scsi8 : aacraid
scsi 8:0:0:0: Direct-Access     Adaptec  Mem3             V1.0 PQ: 0 ANSI: 2
sd 8:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
sd 8:0:0:0: [sdb] 13457403904 512-byte hardware sectors: (6.89 TB/6.26 TiB)
sd 8:0:0:0: [sdb] Write Protect is off
sd 8:0:0:0: [sdb] Mode Sense: 06 00 10 00
sd 8:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO
and FUA
sd 8:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
sd 8:0:0:0: [sdb] 13457403904 512-byte hardware sectors: (6.89 TB/6.26 TiB)
sd 8:0:0:0: [sdb] Write Protect is off
sd 8:0:0:0: [sdb] Mode Sense: 06 00 10 00
sd 8:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO
and FUA
 sdb: unknown partition table
sd 8:0:0:0: [sdb] Attached SCSI removable disk
scsi 8:1:0:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:1:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:2:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:3:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:4:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:5:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:6:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:7:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:8:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:9:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:10:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:11:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:12:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:13:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:14:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:15:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:16:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:17:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:18:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:19:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:20:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:21:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:22:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:23:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
e1000: 0000:10:09.0: e1000_probe: (PCI-X:133MHz:64-bit) 00:02:55:53:39:5d
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000 0000:10:0a.0: PCI INT A -> GSI 25 (level, low) -> IRQ 25
e1000: 0000:10:0a.0: e1000_probe: (PCI-X:133MHz:64-bit) 00:04:23:b4:c5:fb
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:
dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
XFS mounting filesystem sdb
Starting XFS recovery on filesystem: sdb (logdev: internal)
Ending XFS recovery on filesystem: sdb (logdev: internal)
Adding 16779884k swap on /dev/sda2.  Priority:-1 extents:1 across:16779884k
microcode: CPU0 updated from revision 0x60b to 0x60c, date = 2008-01-19 
microcode: CPU1 updated from revision 0x60b to 0x60c, date = 2008-01-19 
microcode: CPU2 updated from revision 0x60b to 0x60c, date = 2008-01-19 
microcode: CPU3 updated from revision 0x60b to 0x60c, date = 2008-01-19 
microcode: CPU4 updated from revision 0x60b to 0x60c, date = 2008-01-19 
microcode: CPU5 updated from revision 0x60b to 0x60c, date = 2008-01-19 
microcode: CPU6 updated from revision 0x60b to 0x60c, date = 2008-01-19 
microcode: CPU7 updated from revision 0x60b to 0x60c, date = 2008-01-19 
e1000: eth0: e1000_watchdog_task: NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: RX/TX
e1000: eth1: e1000_watchdog_task: NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: RX/TX
warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
RPC: Registered udp transport module.
RPC: Registered tcp transport module


/proc/interrupts:
root@mem3 ~]# cat /proc/interrupts 
           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5      
CPU6       CPU7       
  0:        129          3          2          0          0         
0          0          0   IO-APIC-edge      timer
  1:          0          0          0          0          1         
0          1          0   IO-APIC-edge      i8042
  3:          0          0          1          0          0         
0          1          0   IO-APIC-edge    
  4:          1          0          0          0          1         
0          0          0   IO-APIC-edge    
  6:          1          1          0          0          1         
1          1          0   IO-APIC-edge      floppy
  8:          0          0          0          0          0         
0          0          1   IO-APIC-edge      rtc0
  9:          0          0          0          0          0         
0          0          0   IO-APIC-fasteoi   acpi
 12:          3          0          1          1          1         
1          0          0   IO-APIC-edge      i8042
 14:          0          0          0          0          0         
0          0          0   IO-APIC-edge      ata_piix
 15:          0          0          0          0          0         
0          0          0   IO-APIC-edge      ata_piix
 16:       1058        197        352        196       1536     207913      
1059     207913   IO-APIC-fasteoi   aacraid
 20:          0          0          0          0          0         
0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
 21:          0          0          0          0          0         
0          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 22:          0          0          0          0          0         
0          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 23:        725        721        729        729       3826       1678      
2183       1687   IO-APIC-fasteoi   ahci, uhci_hcd:usb5
 24:         10         13      12644   13423600         11         14     
40205         10   IO-APIC-fasteoi   eth0
 25:          4          7          1      28174          4          7   
6361363          3   IO-APIC-fasteoi   eth1
NMI:          0          0          0          0          0         
0          0          0   Non-maskable interrupts
LOC:    2219823    2228500    2216906    2219457    2238783    2236045   
2219075    2240538   Local timer interrupts
RES:        492        491        414       4089        595        742      
1348        891   Rescheduling interrupts
CAL:        125        185        184        177        185       
184        166        117   Function call interrupts
TLB:       3102       2886       3166      73490       3167      13094     
25675      14033   TLB shootdowns
TRM:          0          0          0          0          0         
0          0          0   Thermal event interrupts
THR:          0          0          0          0          0         
0          0          0   Threshold APIC interrupts
SPU:          0          0          0          0          0         
0          0          0   Spurious interrupts
ERR:          0
MIS:          0



Lspci -nvvv
00:00.0 0600: 8086:4003 (rev 20)
        Subsystem: 10f1:5397
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 9
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1
Enable-
                Address: fee00000  Data: 0000
        Capabilities: [6c] Express Root Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, Port 0
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [100] Advanced Error Reporting

00:01.0 0604: 8086:4021 (rev 20)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: dc000000-dc1fffff
        Prefetchable memory behind bridge: 00000000c2000000-00000000c2000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1
Enable+
                Address: feeff00c  Data: 4161
        Capabilities: [6c] Express Root Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x16, ASPM L0s L1, Port
4
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x8
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [b0] #0d [0000]
        Capabilities: [100] Advanced Error Reporting

00:05.0 0604: 8086:4025 (rev 20)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1
Enable+
                Address: feeff00c  Data: 4169
        Capabilities: [6c] Express Root Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x16, ASPM L0s L1, Port
8
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes Disabled CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [b0] #0d [0000]
        Capabilities: [100] Advanced Error Reporting

00:09.0 0604: 8086:4029 (rev 20)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR+
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=09, subordinate=10, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: dc200000-dc3fffff
        Prefetchable memory behind bridge: 00000000c2100000-00000000c2100000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1
Enable+
                Address: feeff00c  Data: 4171
        Capabilities: [6c] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x4, ASPM L0s L1, Port
12
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug-
Surpise-
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd Off, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [b0] #0d [0000]
        Capabilities: [100] Advanced Error Reporting

00:10.0 0600: 8086:4030 (rev 20)
        Subsystem: 10f1:5397
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:10.1 0600: 8086:4030 (rev 20)
        Subsystem: 10f1:5397
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:10.2 0600: 8086:4030 (rev 20)
        Subsystem: 10f1:5397
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:10.3 0600: 8086:4030 (rev 20)
        Subsystem: 10f1:5397
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:10.4 0600: 8086:4030 (rev 20)
        Subsystem: 10f1:5397
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:11.0 0600: 8086:4031 (rev 20)
        Subsystem: 10f1:5397
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:15.0 0600: 8086:4035 (rev 20)
        Subsystem: 10f1:5397
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:15.1 0600: 8086:4035 (rev 20)
        Subsystem: 10f1:5397
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:16.0 0600: 8086:4036 (rev 20)
        Subsystem: 10f1:5397
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:16.1 0600: 8086:4036 (rev 20)
        Subsystem: 10f1:5397
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:1c.0 0604: 8086:2690 (rev 09)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=1f, subordinate=1f, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag+
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, Port 1
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn+ PwrFlt- MRL- PresDet+ CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd Off, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0
Enable+
                Address: feeff00c  Data: 4179
        Capabilities: [90] #0d [0000]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1d.0 0c03: 8086:2688 (rev 09)
        Subsystem: 10f1:5397
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at 1800 [size=32]

00:1d.1 0c03: 8086:2689 (rev 09)
        Subsystem: 10f1:5397
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 21
        Region 4: I/O ports at 1820 [size=32]

00:1d.2 0c03: 8086:268a (rev 09)
        Subsystem: 10f1:5397
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 22
        Region 4: I/O ports at 1840 [size=32]

00:1d.3 0c03: 8086:268b (rev 09)
        Subsystem: 10f1:5397
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 23
        Region 4: I/O ports at 1860 [size=32]

00:1d.7 0c03: 8086:268c (rev 09) (prog-if 20)
        Subsystem: 10f1:5397
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at dc704000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 0604: 8086:244e (rev d9) (prog-if 01)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=20, subordinate=20, sec-latency=32
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: dc400000-dc4fffff
        Prefetchable memory behind bridge: 00000000d8000000-00000000dbf00000
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
        Capabilities: [50] #0d [0000]

00:1f.0 0601: 8086:2670 (rev 09)
        Subsystem: 10f1:5397
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:1f.1 0101: 8086:269e (rev 09) (prog-if 8a)
        Subsystem: 10f1:5397
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at 1880 [size=16]

00:1f.2 0106: 8086:2681 (rev 09) (prog-if 01)
        Subsystem: 10f1:5397
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 23
        Region 0: I/O ports at 18d0 [size=8]
        Region 1: I/O ports at 18c8 [size=4]
        Region 2: I/O ports at 18c0 [size=8]
        Region 3: I/O ports at 1894 [size=4]
        Region 4: I/O ports at 18a0 [size=32]
        Region 5: Memory at dc704400 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] #12 [0010]

00:1f.3 0c05: 8086:269b (rev 09)
        Subsystem: 10f1:5397
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 23
        Region 4: I/O ports at 18e0 [size=32]

01:00.0 0104: 9005:0285 (rev 09)
        Subsystem: 9005:02d0
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at dc000000 (64-bit, non-prefetchable) [size=2M]
        [virtual] Expansion ROM at c2000000 [disabled] [size=512K]
        Capabilities: [98] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/1
Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [d0] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 512 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
                Link: Latency L0s <128ns, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x8
        Capabilities: [90] Vital Product Data
        Capabilities: [100] Advanced Error Reporting

09:00.0 0604: 8086:3500 (rev 01)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=09, secondary=0a, subordinate=0f, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [44] Express Upstream Port IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: SlotPowerLimit 0.000000
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 4096 bytes
                Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] #0d [0000]
        Capabilities: [100] Advanced Error Reporting

09:00.3 0604: 8086:350c (rev 01)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR+
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=09, secondary=10, subordinate=10, sec-latency=64
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: dc200000-dc2fffff
        Prefetchable memory behind bridge: 00000000c2100000-00000000c2100000
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 256 bytes
                Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
        Capabilities: [6c] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] #0d [0000]
        Capabilities: [d8] PCI-X bridge device
                Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD-
Freq=133MHz
                Status: Dev=00:00.3 64bit- 133MHz- SCD- USC- SCO- SRD-
                Upstream: Capacity=65535 CommitmentLimit=65535
                Downstream: Capacity=65535 CommitmentLimit=65535
        Capabilities: [100] Advanced Error Reporting

0a:00.0 0604: 8086:3510 (rev 01)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=0a, secondary=0b, subordinate=0b, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [44] Express Downstream Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 2048 bytes
                Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
                Link: Latency L0s <512ns, L1 unlimited
                Link: ASPM Disabled Disabled CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
        Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=0/0
Enable+
                Address: 00000000feeff00c  Data: 4181
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] #0d [0000]
        Capabilities: [100] Advanced Error Reporting

0a:02.0 0604: 8086:3518 (rev 01)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=0a, secondary=0f, subordinate=0f, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [44] Express Downstream Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 2048 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
        Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=0/0
Enable+
                Address: 00000000feeff00c  Data: 4189
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] #0d [0000]
        Capabilities: [100] Advanced Error Reporting

10:09.0 0200: 8086:100f (rev 01)
        Subsystem: 1014:0269
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR+
        Latency: 52 (63750ns min), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 24
        Region 0: Memory at dc280000 (64-bit, non-prefetchable) [size=128K]
        Region 2: Memory at dc200000 (64-bit, non-prefetchable) [size=256K]
        Region 4: I/O ports at 2000 [size=64]
        [virtual] Expansion ROM at c2100000 [disabled] [size=256K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [e4] PCI-X non-bridge device
                Command: DPERE- ERO+ RBC=512 OST=1
                Status: Dev=10:09.0 64bit+ 133MHz+ SCD- USC- DC=simple
DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
        Capabilities: [f0] Message Signalled Interrupts: 64bit+ Queue=0/0
Enable-
                Address: 0000000000000000  Data: 0000

10:0a.0 0200: 8086:1026 (rev 04)
        Subsystem: 8086:1001
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 52 (63750ns min), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 25
        Region 0: Memory at dc2a0000 (64-bit, non-prefetchable) [size=128K]
        Region 2: Memory at dc240000 (64-bit, non-prefetchable) [size=256K]
        Region 4: I/O ports at 2040 [size=64]
        [virtual] Expansion ROM at c2140000 [disabled] [size=256K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [e4] PCI-X non-bridge device
                Command: DPERE- ERO+ RBC=512 OST=1
                Status: Dev=10:0a.0 64bit+ 133MHz+ SCD- USC- DC=simple
DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
        Capabilities: [f0] Message Signalled Interrupts: 64bit+ Queue=0/0
Enable-
                Address: 0000000000000000  Data: 0000

20:05.0 0300: 18ca:0020
        Subsystem: 18ca:0020
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        BIST result: 00
        Region 0: Memory at d8000000 (32-bit, prefetchable) [size=64M]
        Region 1: Memory at dc400000 (32-bit, non-prefetchable) [size=256K]
        Region 2: I/O ports at 3000 [size=128]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

# dmidecode 2.7
SMBIOS 2.5 present.
61 structures occupying 1876 bytes.
Table at 0xBFF60000.

Handle 0x0000, DMI type 0, 24 bytes.
BIOS Information
        Vendor: Phoenix Technologies LTD
        Version: V1.03           
        Release Date: 05/19/2008
        Address: 0xE4D20
        Runtime Size: 111328 bytes
        ROM Size: 1024 kB
        Characteristics:
                PCI is supported
                PNP is supported
                APM is supported
                BIOS is upgradeable
                BIOS shadowing is allowed
                ESCD support is available
                Boot from CD is supported
                Selectable boot is supported
                BIOS ROM is socketed
                EDD is supported
                ACPI is supported
                USB legacy is supported
                LS-120 boot is supported
                ATAPI Zip drive boot is supported
                BIOS boot specification is supported
        BIOS Revision: 1.3

Handle 0x0001, DMI type 1, 27 bytes.
System Information
        Manufacturer: Empty
        Product Name: Empty
        Version: Empty
        Serial Number: Empty
        UUID: 00000000-0000-0000-0000-F0AB0C00C04D
        Wake-up Type: Power Switch
        SKU Number: Not Specified
        Family: Not Specified

Handle 0x0002, DMI type 2, 8 bytes.
Base Board Information
        Manufacturer: TYAN
        Product Name: S5397
        Version: 1.0
        Serial Number: 0123456789

Handle 0x0003, DMI type 3, 17 bytes.
Chassis Information
        Manufacturer: Empty
        Type: Other
        Lock: Not Present
        Version: Empty
        Serial Number: Empty
        Asset Tag: Empty
        Boot-up State: Safe
        Power Supply State: Safe
        Thermal State: Safe
        Security Status: None
        OEM Information: 0x00000000

Handle 0x0004, DMI type 4, 40 bytes.
Processor Information
        Socket Designation: LGA771
        Type: Central Processor
        Family: Pentium II Xeon
        Manufacturer: Intel
        ID: 76 06 01 00 FF FB EB BF
        Signature: Type 0, Family 6, Model 23, Stepping 6
        Flags:
                FPU (Floating-point unit on-chip)
                VME (Virtual mode extension)
                DE (Debugging extension)
                PSE (Page size extension)
                TSC (Time stamp counter)
                MSR (Model specific registers)
                PAE (Physical address extension)
                MCE (Machine check exception)
                CX8 (CMPXCHG8 instruction supported)
                APIC (On-chip APIC hardware supported)
                SEP (Fast system call)
                MTRR (Memory type range registers)
                PGE (Page global enable)
                MCA (Machine check architecture)
                CMOV (Conditional move instruction supported)
                PAT (Page attribute table)
                PSE-36 (36-bit page size extension)
                CLFSH (CLFLUSH instruction supported)
                DS (Debug store)
                ACPI (ACPI supported)
                MMX (MMX technology supported)
                FXSR (Fast floating-point save and restore)
                SSE (Streaming SIMD extensions)
                SSE2 (Streaming SIMD extensions 2)
                SS (Self-snoop)
                HTT (Hyper-threading technology)
                TM (Thermal monitor supported)
                PBE (Pending break enabled)
        Version:   
        Voltage: 1.2 V
        External Clock: Unknown
        Max Speed: 3800 MHz
        Current Speed: 2660 MHz
        Status: Populated, Enabled
        Upgrade: <OUT OF SPEC>
        L1 Cache Handle: 0x0006
        L2 Cache Handle: 0x0007
        L3 Cache Handle: Not Provided
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0005, DMI type 4, 40 bytes.
Processor Information
        Socket Designation: .
        Type: Central Processor
        Family: Pentium II Xeon
        Manufacturer: .
        ID: 76 06 01 00 FF FB EB BF
        Signature: Type 0, Family 6, Model 23, Stepping 6
        Flags:
                FPU (Floating-point unit on-chip)
                VME (Virtual mode extension)
                DE (Debugging extension)
                PSE (Page size extension)
                TSC (Time stamp counter)
                MSR (Model specific registers)
                PAE (Physical address extension)
                MCE (Machine check exception)
                CX8 (CMPXCHG8 instruction supported)
                APIC (On-chip APIC hardware supported)
                SEP (Fast system call)
                MTRR (Memory type range registers)
                PGE (Page global enable)
                MCA (Machine check architecture)
                CMOV (Conditional move instruction supported)
                PAT (Page attribute table)
                PSE-36 (36-bit page size extension)
                CLFSH (CLFLUSH instruction supported)
                DS (Debug store)
                ACPI (ACPI supported)
                MMX (MMX technology supported)
                FXSR (Fast floating-point save and restore)
                SSE (Streaming SIMD extensions)
                SSE2 (Streaming SIMD extensions 2)
                SS (Self-snoop)
                HTT (Hyper-threading technology)
                TM (Thermal monitor supported)
                PBE (Pending break enabled)
        Version: X
        Voltage: 1.2 V
        External Clock: Unknown
        Max Speed: 3800 MHz
        Current Speed: 2660 MHz
        Status: Populated, Enabled
        Upgrade: <OUT OF SPEC>
        L1 Cache Handle: 0x0008
        L2 Cache Handle: 0x0009
        L3 Cache Handle: Not Provided
        Serial Number: Not Specified
        Asset Tag: <BAD INDEX>
        Part Number: <BAD INDEX>

Handle 0x4C02, DMI type 2, 2 bytes.
Base Board Information

Handle 0x0007, DMI type 7, 19 bytes.
Cache Information
        Socket Designation: L2 Cache
        Configuration: Enabled, Socketed, Level 2
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 12288 KB
        Maximum Size: 8192 KB
        Supported SRAM Types:
                Burst
                Pipeline Burst
                Asynchronous
        Installed SRAM Type: Burst
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unknown
        Associativity: Unknown

Handle 0x0008, DMI type 7, 19 bytes.
Cache Information
        Socket Designation: L1 Cache
        Configuration: Enabled, Socketed, Level 1
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 16 KB
        Maximum Size: 16 KB
        Supported SRAM Types:
                Burst
                Pipeline Burst
                Asynchronous
        Installed SRAM Type: Asynchronous
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unknown
        Associativity: Unknown

Handle 0x0009, DMI type 7, 19 bytes.
Cache Information
        Socket Designation: L2 Cache
        Configuration: Enabled, Socketed, Level 2
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 12288 KB
        Maximum Size: 8192 KB
        Supported SRAM Types:
                Burst
                Pipeline Burst
                Asynchronous
        Installed SRAM Type: Burst
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unknown
        Associativity: Unknown

Handle 0x000A, DMI type 8, 9 bytes.
Port Connector Information
        Internal Reference Designator: J4
        Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
        External Reference Designator: COM 1
        External Connector Type: DB-9 male
        Port Type: Serial Port 16550A Compatible

Handle 0x000B, DMI type 8, 9 bytes.
Port Connector Information
        Internal Reference Designator: J20
        Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
        External Reference Designator: COM 2
        External Connector Type: DB-9 male
        Port Type: Serial Port 16550A Compatible

Handle 0x000C, DMI type 8, 9 bytes.
Port Connector Information
        Internal Reference Designator: J1
        Internal Connector Type: None
        External Reference Designator: Keyboard
        External Connector Type: Circular DIN-8 male
        Port Type: Keyboard Port

Handle 0x000D, DMI type 8, 9 bytes.
Port Connector Information
        Internal Reference Designator: J1
        Internal Connector Type: None
        External Reference Designator: PS/2 Mouse
        External Connector Type: Circular DIN-8 male
        Port Type: Keyboard Port

Handle 0x000E, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCI/33 Slot #1 - J1B1
        Type: 32-bit PCI
        Current Usage: Available
        Length: Long
        ID: 1
        Characteristics:
                5.0 V is provided
                3.3 V is provided

Handle 0x000F, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCIE Slot #2 - J2B1
        Type: 32-bit PCI Express
        Current Usage: Available
        Length: Long
        Characteristics:
                5.0 V is provided
                3.3 V is provided

Handle 0x0010, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCIE Slot #3 - J2B2
        Type: 32-bit PCI Express
        Current Usage: Available
        Length: Long
        Characteristics:
                5.0 V is provided
                3.3 V is provided

Handle 0x0011, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCIE Slot #4 - J3B3
        Type: 32-bit PCI Express
        Current Usage: In Use
        Length: Long
        Characteristics:
                5.0 V is provided
                3.3 V is provided

Handle 0x0012, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCIE Slot #5 - J3B2
        Type: 32-bit PCI-X
        Current Usage: In Use
        Length: Long
        ID: 5
        Characteristics:
                5.0 V is provided
                3.3 V is provided

Handle 0x0013, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCIE Slot #6 - J4B1
        Type: 32-bit PCI Express
        Current Usage: Available
        Length: Long
        Characteristics:
                5.0 V is provided
                3.3 V is provided

Handle 0x0014, DMI type 10, 6 bytes.
On Board Device Information
        Type: Sound
        Status: Disabled
        Description: RealTek

Handle 0x0015, DMI type 11, 5 bytes.
OEM Strings
        String 1: 0
        String 2: 0
        String 3: .........................

Handle 0x0016, DMI type 15, 29 bytes.
System Event Log
        Area Length: 32 bytes
        Header Start Offset: 0x0000
        Header Length: 16 bytes
        Data Start Offset: 0x0010
        Access Method: General-purpose non-volatile data functions
        Access Address: 0x0000
        Status: Valid, Not Full
        Change Token: 0x0000008F
        Header Format: Type 1
        Supported Log Type Descriptors: 3
        Descriptor 1: POST error
        Data Format 1: POST results bitmap
        Descriptor 2: Single-bit ECC memory error
        Data Format 2: Multiple-event
        Descriptor 3: Multi-bit ECC memory error
        Data Format 3: Multiple-event

Handle 0x0017, DMI type 16, 15 bytes.
Physical Memory Array
        Location: System Board Or Motherboard
        Use: System Memory
        Error Correction Type: None
        Maximum Capacity: 64 GB
        Error Information Handle: Not Provided
        Number Of Devices: 4

Handle 0x0018, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1573 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM1
        Bank Locator: DIMM1
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0019, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1573 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM2
        Bank Locator: DIMM2
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x001A, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1573 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM3
        Bank Locator: DIMM3
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x001B, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1573 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM4
        Bank Locator: DIMM4
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x001C, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1573 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM5
        Bank Locator: DIMM5
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x001D, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1573 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM6
        Bank Locator: DIMM6
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x001E, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1573 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM7
        Bank Locator: DIMM7
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x001F, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1573 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM8
        Bank Locator: DIMM8
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0020, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: Unknown
        Data Width: Unknown
        Size: No Module Installed
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM9
        Bank Locator: DIMM9
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0021, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: Unknown
        Data Width: Unknown
        Size: No Module Installed
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM10
        Bank Locator: DIMM10
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0022, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: Unknown
        Data Width: Unknown
        Size: No Module Installed
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM11
        Bank Locator: DIMM11
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0023, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: Unknown
        Data Width: Unknown
        Size: No Module Installed
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM12
        Bank Locator: DIMM12
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0024, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: Unknown
        Data Width: Unknown
        Size: No Module Installed
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM13
        Bank Locator: DIMM13
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0025, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: Unknown
        Data Width: Unknown
        Size: No Module Installed
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM14
        Bank Locator: DIMM14
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0026, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: Unknown
        Data Width: Unknown
        Size: No Module Installed
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM15
        Bank Locator: DIMM15
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0027, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: Unknown
        Data Width: Unknown
        Size: No Module Installed
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM16
        Bank Locator: DIMM16
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0028, DMI type 19, 15 bytes.
Memory Array Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x003127FFFFF
        Range Size: 12584 MB
        Physical Array Handle: 0x0017
        Partition Width: 0

Handle 0x0029, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x000624FFFFF
        Range Size: 1573 MB
        Physical Device Handle: 0x0018
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x002A, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00062500000
        Ending Address: 0x000C49FFFFF
        Range Size: 1573 MB
        Physical Device Handle: 0x0019
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x002B, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x000C4A00000
        Ending Address: 0x00126EFFFFF
        Range Size: 1573 MB
        Physical Device Handle: 0x001A
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x002C, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00126F00000
        Ending Address: 0x001893FFFFF
        Range Size: 1573 MB
        Physical Device Handle: 0x001B
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x002D, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00189400000
        Ending Address: 0x001EB8FFFFF
        Range Size: 1573 MB
        Physical Device Handle: 0x001C
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x002E, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x001EB900000
        Ending Address: 0x0024DDFFFFF
        Range Size: 1573 MB
        Physical Device Handle: 0x001D
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x002F, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x0024DE00000
        Ending Address: 0x002B02FFFFF
        Range Size: 1573 MB
        Physical Device Handle: 0x001E
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0030, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x002B0300000
        Ending Address: 0x003127FFFFF
        Range Size: 1573 MB
        Physical Device Handle: 0x001F
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0031, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x003127FFC00
        Ending Address: 0x003127FFFFF
        Range Size: 1 kB
        Physical Device Handle: 0x0020
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0032, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x003127FFC00
        Ending Address: 0x003127FFFFF
        Range Size: 1 kB
        Physical Device Handle: 0x0021
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0033, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x003127FFC00
        Ending Address: 0x003127FFFFF
        Range Size: 1 kB
        Physical Device Handle: 0x0022
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0034, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x003127FFC00
        Ending Address: 0x003127FFFFF
        Range Size: 1 kB
        Physical Device Handle: 0x0023
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0035, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x003127FFC00
        Ending Address: 0x003127FFFFF
        Range Size: 1 kB
        Physical Device Handle: 0x0024
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0036, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x003127FFC00
        Ending Address: 0x003127FFFFF
        Range Size: 1 kB
        Physical Device Handle: 0x0025
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0037, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x003127FFC00
        Ending Address: 0x003127FFFFF
        Range Size: 1 kB
        Physical Device Handle: 0x0026
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0038, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x003127FFC00
        Ending Address: 0x003127FFFFF
        Range Size: 1 kB
        Physical Device Handle: 0x0027
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0039, DMI type 23, 13 bytes.
System Reset
        Status: Enabled
        Watchdog Timer: Present
        Boot Option: Do Not Reboot
        Boot Option On Limit: Do Not Reboot
        Reset Count: Unknown
        Reset Limit: Unknown
        Timer Interval: Unknown
        Timeout: Unknown

Handle 0x003A, DMI type 32, 20 bytes.
System Boot Information
        Status: <OUT OF SPEC>

Handle 0x003B, DMI type 38, 18 bytes.
IPMI Device Information
        Interface Type: Unknown
        Specification Version: 0.0
        I2C Slave Address: 0x00
        NV Storage Device: Not Present
        Base Address: 0x0000000000000000 (Memory-mapped)
        Register Spacing: Successive Byte Boundaries
        Interrupt Polarity: Active Low
        Interrupt Trigger Mode: Edge

Handle 0x003C, DMI type 127, 4 bytes.
End Of Table

.config:

CONFIG_64BIT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_AGP=y
CONFIG_AIO=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ANON_INODES=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ATA_ACPI=y
CONFIG_ATA_PIIX=y
CONFIG_ATA_SFF=y
CONFIG_ATA=y
CONFIG_AUDIT_ARCH=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
CONFIG_AUDIT=y
CONFIG_AUTOFS4_FS=y
CONFIG_BASE_FULL=y
CONFIG_BASE_SMALL=0
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_MISC=y
CONFIG_BITREVERSE=y
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_DM=m
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_IDEDMA_SFF=y
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_IDESCSI=m
CONFIG_BLK_DEV_INITRD=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_MD=y
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_PIIX=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV=y
CONFIG_BLOCK_COMPAT=y
CONFIG_BLOCK=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_BOUNCE=y
CONFIG_BSD_DISKLABEL=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BUG=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_CLASSIC_RCU=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_COMPAT_BRK=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_COMPAT_VDSO=y
CONFIG_COMPAT=y
CONFIG_CONFIGFS_FS=m
CONFIG_CONNECTOR=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_64=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CRAMFS=m
CONFIG_CRC16=y
CONFIG_CRC32=y
CONFIG_CRC_CCITT=m
CONFIG_CRC_ITU_T=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO=y
CONFIG_DCA=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEFAULT_CFQ=y
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_DEVKMEM=y
CONFIG_DEVPORT=y
CONFIG_DLM_DEBUG=y
CONFIG_DLM=m
CONFIG_DMADEVICES=y
CONFIG_DMA_ENGINE=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_DMAR_GFX_WA=y
CONFIG_DMAR=y
CONFIG_DM_CRYPT=m
CONFIG_DMIID=y
CONFIG_DMI=y
CONFIG_DM_MIRROR=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_UEVENT=y
CONFIG_DM_ZERO=m
CONFIG_DNOTIFY=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY=m
CONFIG_E1000=m
CONFIG_EARLY_PRINTK=y
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC=y
CONFIG_EDD=m
CONFIG_EFI_PARTITION=y
CONFIG_ELF_CORE=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_EPOLL=y
CONFIG_EVENTFD=y
CONFIG_EXPERIMENTAL=y
CONFIG_EXPORTFS=m
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT2_FS=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
CONFIG_FAT_FS=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_DDC=m
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_INTEL=m
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y
CONFIG_FB_VESA=y
CONFIG_FB=y
CONFIG_FILE_LOCKING=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_FONT_8x16=y
CONFIG_FONT_8x8=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAME_WARN=2048
CONFIG_FS_MBCACHE=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FS_XIP=y
CONFIG_FTL=m
CONFIG_FUTEX=y
CONFIG_FW_LOADER=y
CONFIG_GART_IOMMU=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_TIME=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_HAS_DMA=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_IDE=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_BRIGHT=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_COMPAT=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DEBUG=y
CONFIG_HID_DELL=y
CONFIG_HID_EZKEY=y
CONFIG_HID_GYRATION=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_PANTHERLORD=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PID=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_HOTPLUG=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_HPET_TIMER=y
CONFIG_HPET=y
CONFIG_HT_IRQ=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_HW_CONSOLE=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM=y
CONFIG_HZ=1000
CONFIG_HZ_1000=y
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_I801=y
CONFIG_I2C=y
CONFIG_IA32_AOUT=y
CONFIG_IA32_EMULATION=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_PROC_FS=y
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE=y
CONFIG_IKCONFIG=y
CONFIG_INET_DIAG=y
CONFIG_INET_LRO=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_INITRAMFS_SOURCE=""
CONFIG_INOTIFY_USER=y
CONFIG_INOTIFY=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_KEYBOARD=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSE=y
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT=y
CONFIG_INTEL_IOATDMA=y
CONFIG_INTR_REMAP=y
CONFIG_IO_DELAY_0X80=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IOMMU_HELPER=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_CFQ=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IPC_NS=y
CONFIG_IP_FIB_HASH=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_POWEROFF=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IP_SCTP=m
CONFIG_ISA_DMA_API=y
CONFIG_ISO9660_FS=y
CONFIG_JBD2=y
CONFIG_JBD=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JOLIET=y
CONFIG_K8_NB=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_KALLSYMS=y
CONFIG_KARMA_PARTITION=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KMOD=y
CONFIG_KPROBES=y
CONFIG_KRETPROBES=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LIBCRC32C=y
CONFIG_LOCALVERSION=""
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_LOCK_KERNEL=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_LOGITECH_FF=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_LOGO=y
CONFIG_MAC_PARTITION=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_MCORE2=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_FAULTY=m
CONFIG_MD_LINEAR=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_MISC_DEVICES=y
CONFIG_MMU=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MSDOS_FS=m
CONFIG_MSDOS_PARTITION=y
CONFIG_MTD_ABSENT=m
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK2MTD=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_CHAR=m
CONFIG_MTD_CONCAT=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD=m
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_MTDRAM=m
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NETSC520=m
CONFIG_MTD_PARTITIONS=y
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_RAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_ROM=m
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_SCB2_FLASH=m
CONFIG_MTD_TS5500=m
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR=y
CONFIG_NAMESPACES=y
CONFIG_NETDEV_1000=y
CONFIG_NETDEVICES=y
CONFIG_NET_DMA=y
CONFIG_NET_KEY=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET=y
CONFIG_NEW_LEDS=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V4=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V3=y
CONFIG_NFS_V4=y
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_UTF8=y
CONFIG_NLS=y
CONFIG_NR_CPUS=16
CONFIG_NSC_GPIO=m
CONFIG_NVRAM=y
CONFIG_OSF_PARTITION=y
CONFIG_PACKET_MMAP=y
CONFIG_PACKET=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_PARTITION_ADVANCED=y
CONFIG_PATA_SCH=m
CONFIG_PC8736x_GPIO=m
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_MSI=y
CONFIG_PCI_QUIRKS=y
CONFIG_PCI=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_PHYSICAL_START=0x200000
CONFIG_PLIST=y
CONFIG_PM=y
CONFIG_PNPACPI=y
CONFIG_PNP_DEBUG_MESSAGES=y
CONFIG_PNP=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POWER_SUPPLY=y
CONFIG_PREEMPT_NONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_PRINTK=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_PROC_EVENTS=y
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_SYSCTL=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTA=y
CONFIG_RAID_ATTRS=y
CONFIG_RAW_DRIVER=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_REED_SOLOMON=m
CONFIG_RELAY=y
CONFIG_RESOURCES_64BIT=y
CONFIG_RFD_FTL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
CONFIG_RTC_CLASS=y
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc"
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_LIB=y
CONFIG_RT_MUTEXES=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_PMP=y
CONFIG_SCHED_HRTICK=y
CONFIG_SCHED_MC=y
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_WAIT_SCAN=m
CONFIG_SCSI=y
CONFIG_SCTP_HMAC_MD5=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_EEPROM=y
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_HDAPS=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_JSM=m
CONFIG_SERIO_I8042=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO=y
CONFIG_SGI_PARTITION=y
CONFIG_SHMEM=y
CONFIG_SIGNALFD=y
CONFIG_SLABINFO=y
CONFIG_SLAB=y
CONFIG_SMP=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_SPARSEMEM=y
CONFIG_SPI_MASTER=y
CONFIG_SPI=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_SSB_POSSIBLE=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_STANDALONE=y
CONFIG_STOP_MACHINE=y
CONFIG_SUN_PARTITION=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC=m
CONFIG_SWAP=y
CONFIG_SWIOTLB=y
CONFIG_SYN_COOKIES=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_SYSCTL=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_SYSVIPC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_THERMAL=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_TICK_ONESHOT=y
CONFIG_TIMERFD=y
CONFIG_TMPFS=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_UID16=y
CONFIG_UIO=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_UNIX98_PTYS=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_UNIX=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DEVICEFS=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_HIDDEV=y
CONFIG_USB_HID=y
CONFIG_USB_MON=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_UTS_NS=y
CONFIG_VFAT_FS=m
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGA_CONSOLE=y
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_MEDIA=m
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIRT_TO_BUS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_VT=y
CONFIG_VXFS_FS=m
CONFIG_X86_64_SMP=y
CONFIG_X86_64=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_CMOV=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_CPUID=y
CONFIG_X86_CPU=y
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_X86_HT=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_IO_APIC=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_MSR=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_PAT=y
CONFIG_X86_PC=y
CONFIG_X86_PM_TIMER=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_X86_SMP=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_X86_TSC=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86=y
CONFIG_XFRM_USER=y
CONFIG_XFRM=y
CONFIG_XFS_FS=y
CONFIG_XOR_BLOCKS=m
CONFIG_ZISOFS=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZONE_DMA32=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_ZONE_DMA=y


