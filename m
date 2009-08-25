Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbZHYLVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbZHYLVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 07:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZHYLVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 07:21:46 -0400
Received: from crmrmail.amdocs.com ([87.86.252.131]:55584 "EHLO
	crmrmail.amdocs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZHYLVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 07:21:45 -0400
X-Greylist: delayed 1004 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2009 07:21:45 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: BUG: 2.6.30.1 pv_ops kernel boot failure - bisected
Date: Tue, 25 Aug 2009 12:04:54 +0100
Message-ID: <683099EDC3E36D40942EBF636EB88BF00701E35F@batmail1.corp.amdocs.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: BUG: 2.6.30.1 pv_ops kernel boot failure - bisected
Thread-Index: Acolc9/4uOmmvNjRSFmwKQXW5sAtUw==
From: "James Dingwall" <james.dingwall@amdocs.com>
To: <linux-kernel@vger.kernel.org>
Cc: <andreas.herrmann3@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I have encountered what appears to be a bug when using the 2.6.30 stable
series as a pv_ops kernel under Xen 3.4.1.  The problem appears to have
been introduced with the following commit (provided I bisected it
correctly)

commit bb9b409349f533a919b6b6d95698fbe6ff4aa209
Author: Andreas Herrmann <andreas.herrmann3@amd.com>
Date:   Mon Jun 8 15:55:09 2009 +0200

    x86: Detect use of extended APIC ID for AMD CPUs

When I try and boot the domU (xm create -c) I do not get any output.
With this commit reverted I can boot 2.6.30.5 pv_ops without issue,
output follows below.  The system is a dual Opteron 242.  If more
details about the hardware or configuration are required to debug this
please let me know.  I'm willing to test any patches.

James


Linux version 2.6.30.5-00001-g3de1371 (root@behemoth) (gcc version 4.1.2
(Gentoo 4.1.2 p1.0.2)) #8 SMP Tue Aug 25 11:50:57 BST 2009
Command line: root=/dev/ram0 init=/linuxrc ramdisk=8192
real_root=/dev/xvda1 console=hvc0 udev doscsi dolvm dodmraid
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
ACPI in unprivileged domain disabled
BIOS-provided physical RAM map:
 Xen: 0000000000000000 - 00000000000a0000 (usable)
 Xen: 00000000000a0000 - 0000000000100000 (reserved)
 Xen: 0000000000100000 - 0000000000e50000 (usable)
 Xen: 0000000000e50000 - 0000000000ed3000 (reserved)
 Xen: 0000000000ed3000 - 0000000010000000 (usable)
DMI not present or invalid.
last_pfn = 0x10000 max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-0000000010000000
RAMDISK: 0084a000 - 00e50000
No NUMA configuration found
Faking a node at 0000000000000000-0000000010000000
Bootmem setup node 0 0000000000000000-0000000010000000
  NODE_DATA [0000000000001000 - 0000000000004fff]
  bootmap [000000000007c000 -  000000000007dfff] pages 2
(6 early reservations) ==> bootmem [0000000000 - 0010000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
0000001000]
  #1 [0000ed3000 - 0000ede000]   XEN PAGETABLES ==> [0000ed3000 -
0000ede000]
  #2 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 -
0000008000]
  #3 [0000200000 - 0000829dd4]    TEXT DATA BSS ==> [0000200000 -
0000829dd4]
  #4 [000084a000 - 0000e50000]          RAMDISK ==> [000084a000 -
0000e50000]
  #5 [0000008000 - 000007c000]          PGTABLE ==> [0000008000 -
000007c000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x000000a0
    0: 0x00000100 -> 0x00000e50
    0: 0x00000ed3 -> 0x00010000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
No local APIC present
Allocating PCI resources starting at 20000000 (gap: 10000000:f0000000)
NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Allocated 19 4k pages, static data 73888 bytes
Xen: using vcpu_info placement
Built 1 zonelists in Node order, mobility grouping on.  Total pages:
61164
Policy zone: DMA32
Kernel command line: root=/dev/ram0 init=/linuxrc ramdisk=8192
real_root=/dev/xvda1 console=hvc0 udev doscsi dolvm dodmraid
Initializing CPU#0
NR_IRQS:4352 nr_irqs:288
PID hash table entries: 1024 (order: 10, 8192 bytes)
Detected 1593.260 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
console [hvc0] enabled
Checking aperture...
No AGP bridge found
Memory: 244212k/262144k available (3502k kernel code, 908k absent,
17024k reserved, 1700k data, 468k init)
installing Xen timer for CPU 0
Calibrating delay loop (skipped), value calculated using timer
frequency.. 3186.52 BogoMIPS (lpj=6373040)
Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0x0 -> Node 0
SMP alternatives: switching to UP code
cpu 0 spinlock event irq 1
installing Xen timer for CPU 1
cpu 1 spinlock event irq 7
SMP alternatives: switching to SMP code
Initializing CPU#1
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/0x0 -> Node 0
Brought up 2 CPUs
net_namespace: 1304 bytes
Booting paravirtualized kernel on Xen
Xen version: 3.4.1 (preserve-AD)
xor: automatically using best checksumming function: generic_sse
   generic_sse:  1906.000 MB/sec
xor: using function: generic_sse (1906.000 MB/sec)
Grant table initialized
NET: Registered protocol family 16
PCI: Fatal: No config space access function found
bio: create slab <bio-0> at 0
ACPI: Interpreter disabled.
xen_balloon: Initialising balloon driver.
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
raid6: int64x1   1350 MB/s
raid6: int64x2   1710 MB/s
raid6: int64x4   1580 MB/s
raid6: int64x8   1063 MB/s
raid6: sse2x1    1067 MB/s
raid6: sse2x2    1148 MB/s
raid6: sse2x4    1366 MB/s
raid6: using algorithm sse2x4 (1366 MB/s)
PCI: System does not support PCI
PCI: System does not support PCI
pnp: PnP ACPI: disabled
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 2, 16384 bytes)
TCP established hash table entries: 8192 (order: 5, 131072 bytes)
TCP bind hash table entries: 8192 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 6168k freed
platform rtc_cmos: registered platform RTC device (no PNP device found)
SGI XFS with ACLs, security attributes, realtime, large block/inode
numbers, no debug enabled
SGI XFS Quota Management subsystem
msgmni has been set to 524
alg: No test for stdrng (krng)
async_tx: api initialized (async)
io scheduler noop registered
io scheduler deadline registered (default)
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
brd: module loaded
loop: module loaded
Uniform Multi-Platform E-IDE driver
ide_generic: please use "probe_mask=0x3f" module parameter for probing
all legacy ISA IDE ports
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
ide-gd driver 1.18
ide-cd driver 5.00
3ware 9000 Storage Controller device driver for Linux v2.26.02.012.
Driver 'sd' needs updating - please use bus_type methods
PNP: No PS/2 controller found. Probing ports directly.
i8042.c: No controller found.
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input0
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:
dm-devel@redhat.com
cpuidle: using governor ladder
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
registered taskstats version 1
XENBUS: Device with no driver: device/vbd/51720
XENBUS: Device with no driver: device/vbd/51713
XENBUS: Device with no driver: device/vbd/51714
XENBUS: Device with no driver: device/vbd/51717
XENBUS: Device with no driver: device/vbd/51718
XENBUS: Device with no driver: device/vbd/51719
XENBUS: Device with no driver: device/vif/0
XENBUS: Device with no driver: device/console/0
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Freeing unused kernel memory: 468k freed


This message and the information contained herein is proprietary and confidential and subject to the Amdocs policy statement,
you may review at http://www.amdocs.com/email_disclaimer.asp
