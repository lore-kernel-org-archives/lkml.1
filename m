Return-Path: <linux-kernel-owner+w=401wt.eu-S1422991AbXDXSXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422991AbXDXSXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 14:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422993AbXDXSXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 14:23:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:58179 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422991AbXDXSXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 14:23:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Nin4sqDWskxRhSbHuKJyNxaxT6XlOtl74Moyt3y2ocE8ttMVf8w9RsAc2WIj/gswdvZZ5fCUue6iaUQ5tNKWrAzhTaUU5ZXfmSe5eAm0Oczlp4YMoVxmgkeHhViLH/nAp4/AgsTx3bReNXtgdk6rgFjEl6qvfnVBjQZIBZkcmpc=
Date: Tue, 24 Apr 2007 22:23:58 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc7-mm1: BUG at init_sched_clock()
Message-ID: <20070424182358.GA5857@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	...
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=9999
BUG: at arch/x86_64/kernel/../../i386/kernel/sched-clock.c:175 init_sched_clock()

Call Trace:
 [<ffffffff8020ae7a>] show_trace+0x34/0x4f
 [<ffffffff8020aea7>] dump_stack+0x12/0x17
 [<ffffffff8046dddf>] init_sched_clock+0x59/0x8a
 [<ffffffff8046a608>] kernel_init+0x167/0x2dc
 [<ffffffff8020a4c8>] child_rip+0xa/0x12

It didn't happen in 2.6.21-rc6-mm1 nor in mainline. And migration cost was 15.
However, box boots to the end as usual. /proc/cpuinfo shows 2 CPUs.

[reboots box]
Now migration cost is 19999 and same trace.

------------------------------------------------------------------------------
Should-be-relevant config options:

CONFIG_X86_64=y
CONFIG_64BIT=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_MCORE2=y
CONFIG_X86_TSC=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_HT=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_SMP=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
CONFIG_NR_CPUS=2
CONFIG_HPET_TIMER=y
CONFIG_HZ=100
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_DETECT_SOFTLOCKUP=y

------------------------------------------------------------------------------
Linux version 2.6.21-rc7-mm1 (ad@core2) (gcc version 4.1.1 (Gentoo 4.1.1-r3)) #1 SMP PREEMPT Wed Apr 25 01:58:43 MSD 2007
Command line: root=/dev/sda2 netconsole=@10.10.0.42/eth0,9353@10.10.0.1/00:80:48:45:EC:73 ignore_loglevel
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
 BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
 BIOS-e820: 000000007ff9e000 - 000000007ffe0000 (ACPI NVS)
 BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 524176) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.4 present.
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 524176) 1 entries of 256 used
sizeof(struct page) = 56
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   524176
On node 0 totalpages: 524079
Node 0 memmap at 0xffff810001000000 size 29360128 first pfn 0xffff810001000000
  DMA zone: 56 pages used for memmap
  DMA zone: 1636 pages reserved
  DMA zone: 2307 pages, LIFO batch:0
  DMA32 zone: 7110 pages used for memmap
  DMA32 zone: 512970 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Intel MultiProcessor Specification v1.4
MPTABLE: OEM ID: P5B      MPTABLE: Product ID:  MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
I/O APIC #2 at 0xFEC00000.
Setting APIC routing to flat
Processors: 2
Allocating PCI resources starting at 88000000 (gap: 80000000:7ee00000)
PERCPU: Allocating 24832 bytes of per cpu data
Built 1 zonelists, mobility grouping on.  Total pages: 515277
Kernel command line: root=/dev/sda2 netconsole=@10.10.0.42/eth0,9353@10.10.0.1/00:80:48:45:EC:73 ignore_loglevel
netconsole: local port 6665
netconsole: local IP 10.10.0.42
netconsole: interface eth0
netconsole: remote port 9353
netconsole: remote IP 10.10.0.1
netconsole: remote ethernet address 00:80:48:45:ec:73
debug: ignoring loglevel setting.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2135.087 MHz processor.
Console: colour VGA+ 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1648 kB
 per task-struct memory footprint: 1680 bytes
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Memory: 2057452k/2096704k available (1421k kernel code, 38652k reserved, 918k data, 148k init)
SLUB: General Slabs=18, HW alignment=64, Processors=2, Nodes=1
Calibrating delay using timer specific routine.. 4273.12 BogoMIPS (lpj=21365632)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
Freeing SMP alternatives: 16k freed
ExtINT not setup in hardware but reported by MP table
Using local APIC timer interrupts.
result 16680360
Detected 16.680 MHz APIC timer.
lockdep: not fixing up alternatives.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4270.17 BogoMIPS (lpj=21350870)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=19999
BUG: at arch/x86_64/kernel/../../i386/kernel/sched-clock.c:175 init_sched_clock()

Call Trace:
 [<ffffffff8020ae7a>] show_trace+0x34/0x4f
 [<ffffffff8020aea7>] dump_stack+0x12/0x17
 [<ffffffff8046dddf>] init_sched_clock+0x59/0x8a
 [<ffffffff8046a608>] kernel_init+0x167/0x2dc
 [<ffffffff8020a4c8>] child_rip+0xa/0x12

NET: Registered protocol family 16
	...

