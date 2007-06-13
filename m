Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbXFMItv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbXFMItv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 04:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbXFMIto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 04:49:44 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:56526 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbXFMItm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 04:49:42 -0400
Message-ID: <466FAF99.3070708@free.fr>
Date: Wed, 13 Jun 2007 10:49:29 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Runaway process and oom-killer
Content-Type: multipart/mixed;
 boundary="------------000408070302010502060604"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000408070302010502060604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I have a problem with an app I wrote: after it has run for a long time 
(sometimes 10-15 hours, sometimes several days) the oom-killer kicks in 
and snipes most processes in the system.

(My process runs in SCHED_RR.)

There is a good probability that there is a memory leak in my app, but 
I'm trying to make sense of the oom-killer's logs to make sure.

If I run dmesg, it prints the oom-killer's logs.

Question 1: why isn't this output picked up by klogd and sent to the 
appropriate file (kern.log in my case)?

Question 2: how can I tell which process or kernel thread was hogging 
most of the RAM when the oom-killer kicked in?

Question 3: if myapp was hogging the RAM, then why did oom-killer snipe 
other processes (syslogd and boa) after it killed myapp?

Regards.

--------------000408070302010502060604
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

Linux version 2.6.20.7-rt8 (root@wagram) (gcc version 3.4.3) #1 PREEMPT Fri Apr 20 12:44:16 CEST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 00000000000a0000 end: 00000000000a0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000000fef0000 end: 000000000fff0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000fff0000 size: 0000000000003000 end: 000000000fff3000 type: 4
copy_e820_map() start: 000000000fff3000 size: 000000000000d000 end: 0000000010000000 type: 3
copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
 BIOS-e820: 000000000fff0000 - 000000000fff3000 (ACPI NVS)
 BIOS-e820: 000000000fff3000 - 0000000010000000 (ACPI data)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
255MB LOWMEM available.
Entering add_active_range(0, 0, 65520) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    65520
early_node_map[1] active PFN ranges
    0:        0 ->    65520
On node 0 totalpages: 65520
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 479 pages used for memmap
  Normal zone: 60945 pages, LIFO batch:15
DMI 2.3 present.
ACPI: RSDP (v000 VIA601                                ) @ 0x000f6950
ACPI: RSDT (v001 VIA601 AWRDACPI 0x42302e31 AWRD 0x00000000) @ 0x0fff3000
ACPI: FADT (v001 VIA601 AWRDACPI 0x42302e31 AWRD 0x00000000) @ 0x0fff3040
ACPI: DSDT (v001 VIA601 AWRDACPI 0x00001000 MSFT 0x0100000c) @ 0x00000000
ACPI: PM-Timer IO Port: 0x4008
Allocating PCI resources starting at 20000000 (gap: 10000000:efff0000)
Detected 1266.700 MHz processor.
Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
Built 1 zonelists.  Total pages: 65009
Kernel command line: ro root=/dev/hda2 console=ttyS0,57600n8 console=tty0 panic=3 lpj=12667000
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
WARNING: experimental RCU implementation.
PID hash table entries: 1024 (order: 10, 4096 bytes)
Console: colour dummy device 80x25
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 256680k/262080k available (1735k kernel code, 4916k reserved, 584k data, 168k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffff8000 - 0xfffff000   (  28 kB)
    vmalloc : 0xd0800000 - 0xffff6000   ( 759 MB)
    lowmem  : 0xc0000000 - 0xcfff0000   ( 255 MB)
      .init : 0xc0348000 - 0xc0372000   ( 168 kB)
      .data : 0xc02b1fe8 - 0xc0344238   ( 584 kB)
      .text : 0xc0100000 - 0xc02b1fe8   (1735 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay loop (skipped)... 2533.40 BogoMIPS preset
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel(R) Pentium(R) III CPU - S         1266MHz stepping 04
Checking 'hlt' instruction... OK.
ACPI: Core revision 20060707
ACPI: setting ELCR to 0080 (from 1ca0)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb210, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
0000:00:07.1: cannot adjust BAR0 (not I/O)
0000:00:07.1: cannot adjust BAR1 (not I/O)
0000:00:07.1: cannot adjust BAR2 (not I/O)
0000:00:07.1: cannot adjust BAR3 (not I/O)
PCI quirk: region 6000-607f claimed by vt82c686 HW-mon
PCI quirk: region 5000-500f claimed by vt82c686 SMB
PCI: Firmware left 0000:00:08.0 e100 interrupts enabled, disabling
PCI: Firmware left 0000:00:09.0 e100 interrupts enabled, disabling
PCI: Firmware left 0000:00:0a.0 e100 interrupts enabled, disabling
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
  IO window: disabled.
  MEM window: e5300000-e53fffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 6, 262144 bytes)
TCP bind hash table entries: 4096 (order: 4, 114688 bytes)
TCP: Hash tables configured (established 8192 bind 4096)
TCP reno registered
io scheduler noop registered (default)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
serial8250: ttyS2 at I/O 0x3e8 (irq = 0) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
eepro100.c:v1.09j-t 9/29/99 Donald Becker http://www.scyld.com/network/eepro100.html
eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V. Savochkin <saw@saw.sw.com.sg> and others
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
eth0: 0000:00:08.0, 00:30:64:05:69:CF, IRQ 11.
  Board assembly 721383-016, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0x04f4518b).
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 12
PCI: setting IRQ 12 as level-triggered
ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKB] -> GSI 12 (level, low) -> IRQ 12
eth1: 0000:00:09.0, 00:30:64:05:69:D0, IRQ 12.
  Board assembly 721383-016, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0x04f4518b).
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
eth2: 0000:00:0a.0, 00:30:64:05:69:D1, IRQ 10.
  Board assembly 721383-016, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0x04f4518b).
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
hda: PQI IDE DiskOnModule, ATA DISK drive
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
hda: 256000 sectors (131 MB) w/1KiB Cache, CHS=500/16/32
 hda: hda1 hda2 hda3 hda4
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
netem: version 1.2
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (2047 buckets, 16376 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
ClusterIP Version 0.8 loaded successfully
arp_tables: (C) 2002 David S. Miller
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
Using IPI Shortcut mode
VFS: Mounted root (ext2 filesystem) readonly.
Time: tsc clocksource has been installed.
Switched to high resolution mode on CPU 0
Freeing unused kernel memory: 168k freed
process `syslogd' is using obsolete setsockopt SO_BSDCOMPAT
ACPI: PCI Interrupt 0000:02:0e.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
Dta1xx: The DTA-105 (Firmware Version 0) has started successfully.
Dta1xx: Found 1 DTA-1xx boards in the system
Dta1xx: Major: 254
Dta1xx: The driver (Rev 1.11.2.105) has loaded successfully.
watchsoftware.s invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
 [<c013fd7e>] out_of_memory+0xde/0x110
 [<c0141102>] __alloc_pages+0x292/0x300
 [<c013c461>] find_get_page+0x91/0x170
 [<c0128520>] wake_bit_function+0x0/0x60
 [<c0142e41>] __do_page_cache_readahead+0xa1/0x140
 [<c013d749>] filemap_nopage+0x169/0x390
 [<c01499ca>] do_no_page+0x6a/0x2a0
 [<c0149fbf>] __handle_mm_fault+0x25f/0x2b0
 [<c010e847>] do_page_fault+0x317/0x5c0
 [<c010e530>] do_page_fault+0x0/0x5c0
 [<c02b1394>] error_code+0x74/0x7c
 [<c02b0033>] cond_resched_softirq_context+0x43/0xd0
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: Hot: hi:   90, btch:  15 usd:  53   Cold: hi:   30, btch:   7 usd:   9
Active:61612 inactive:137 dirty:0 writeback:0 unstable:0 free:744 slab:1336 mapped:82 pagetables:117
DMA free:1076kB min:124kB low:152kB high:184kB active:12244kB inactive:124kB present:16256kB pages_scanned:21628 all_unreclaimable? yes
lowmem_reserve[]: 0 238
Normal free:1900kB min:1908kB low:2384kB high:2860kB active:234204kB inactive:424kB present:243780kB pages_scanned:359621 all_unreclaimable? yes
lowmem_reserve[]: 0 0
DMA: 1*4kB 0*8kB 1*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1076kB
Normal: 1*4kB 1*8kB 2*16kB 0*32kB 3*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1900kB
Free swap:            0kB
klogd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
 [<c013fd7e>] out_of_memory+0xde/0x110
 [<c0141102>] __alloc_pages+0x292/0x300
 [<c013c461>] find_get_page+0x91/0x170
 [<c0142e41>] __do_page_cache_readahead+0xa1/0x140
 [<c013d749>] filemap_nopage+0x169/0x390
 [<c01499ca>] do_no_page+0x6a/0x2a0
 [<c0149fbf>] __handle_mm_fault+0x25f/0x2b0
 [<c01284d0>] autoremove_wake_function+0x0/0x50
 [<c010e847>] do_page_fault+0x317/0x5c0
 [<c01577a1>] sys_read+0x41/0x70
 [<c010e530>] do_page_fault+0x0/0x5c0
 [<c02b1394>] error_code+0x74/0x7c
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: Hot: hi:   90, btch:  15 usd:  53   Cold: hi:   30, btch:   7 usd:   9
Active:61612 inactive:137 dirty:0 writeback:0 unstable:0 free:744 slab:1336 mapped:82 pagetables:117
DMA free:1076kB min:124kB low:152kB high:184kB active:12244kB inactive:124kB present:16256kB pages_scanned:21628 all_unreclaimable? yes
lowmem_reserve[]: 0 238
Normal free:1900kB min:1908kB low:2384kB high:2860kB active:234204kB inactive:424kB present:243780kB pages_scanned:359621 all_unreclaimable? yes
lowmem_reserve[]: 0 0
DMA: 1*4kB 0*8kB 1*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1076kB
Normal: 1*4kB 1*8kB 2*16kB 0*32kB 3*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1900kB
Free swap:            0kB
tail invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
 [<c013fd7e>] out_of_memory+0xde/0x110
 [<c0141102>] __alloc_pages+0x292/0x300
 [<c013c461>] find_get_page+0x91/0x170
 [<c0128520>] wake_bit_function+0x0/0x60
 [<c0142e41>] __do_page_cache_readahead+0xa1/0x140
 [<c013d749>] filemap_nopage+0x169/0x390
 [<c01499ca>] do_no_page+0x6a/0x2a0
 [<c0149fbf>] __handle_mm_fault+0x25f/0x2b0
 [<c012b883>] hrtimer_cancel+0x13/0x20
 [<c010e847>] do_page_fault+0x317/0x5c0
 [<c010e530>] do_page_fault+0x0/0x5c0
 [<c02b1394>] error_code+0x74/0x7c
 [<c02b0033>] cond_resched_softirq_context+0x43/0xd0
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: Hot: hi:   90, btch:  15 usd:  53   Cold: hi:   30, btch:   7 usd:   9
Active:61612 inactive:137 dirty:0 writeback:0 unstable:0 free:744 slab:1336 mapped:82 pagetables:117
DMA free:1076kB min:124kB low:152kB high:184kB active:12244kB inactive:124kB present:16256kB pages_scanned:21628 all_unreclaimable? yes
lowmem_reserve[]: 0 238
Normal free:1900kB min:1908kB low:2384kB high:2860kB active:234204kB inactive:424kB present:243780kB pages_scanned:359666 all_unreclaimable? yes
lowmem_reserve[]: 0 0
DMA: 1*4kB 0*8kB 1*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1076kB
Normal: 1*4kB 1*8kB 2*16kB 0*32kB 3*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1900kB
Free swap:            0kB
65520 pages of RAM
0 pages of HIGHMEM
1283 reserved pages
855 pages shared
0 pages swap cached
0 pages dirty
0 pages writeback
82 pages mapped
1336 pages slab
117 pages pagetables
Out of memory: kill process 1023 (ControlTask) score 149 or a child
Killed process 1141 (myapp)
65520 pages of RAM
0 pages of HIGHMEM
1283 reserved pages
793 pages shared
0 pages swap cached
0 pages dirty
0 pages writeback
79 pages mapped
1259 pages slab
61 pages pagetables
Out of memory: kill process 853 (syslogd) score 134 or a child
Killed process 853 (syslogd)
65520 pages of RAM
0 pages of HIGHMEM
1283 reserved pages
818 pages shared
0 pages swap cached
0 pages dirty
0 pages writeback
85 pages mapped
1259 pages slab
61 pages pagetables
Out of memory: kill process 1021 (boa) score 130 or a child
Killed process 1021 (boa)
root@RCV:/var/log#

--------------000408070302010502060604--
