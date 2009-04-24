Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZDXG4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZDXG4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZDXGz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:55:56 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:58664 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbZDXGzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:55:55 -0400
Message-ID: <49F1626D.6080102@in.ibm.com>
Date: Fri, 24 Apr 2009 12:25:41 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@redhat.com>,
       peterz@infradead.org
Subject: Next April 24 : BUG: lock held at task exit time!
References: <20090424150456.ff35e4ea.sfr@canb.auug.org.au>
In-Reply-To: <20090424150456.ff35e4ea.sfr@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------010407070305000806030608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010407070305000806030608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While booting today's next tree on a powerpc box [ power 6 blade]
observed the following :

khelper used greatest stack depth: 10176 bytes left

=====================================
[ BUG: lock held at task exit time! ]
-------------------------------------
khelper/21 is exiting with locks still held!
2 locks held by khelper/21:
 #0:  (rcu_read_lock){.+.+.+}, at: [<c0000000001382fc>] 
.check_unsafe_exec+0x44/0x148
 #1:  (rcu_read_lock){.+.+.+}, at: [<c000000000138368>] 
.check_unsafe_exec+0xb0/0x148

stack backtrace:
Call Trace:
[c000000044483cf0] [c000000000011a54] .show_stack+0x6c/0x16c (unreliable)
[c000000044483da0] [c00000000009ae14] .debug_check_no_locks_held+0x98/0xb4
[c000000044483e20] [c000000000073b1c] .do_exit+0x758/0x7b0
[c000000044483f00] [c0000000000853d8] .____call_usermodehelper+0x170/0x174
[c000000044483f90] [c00000000002bd8c] .kernel_thread+0x54/0x70
net_namespace: 2000 bytes

Complete dmesg attached. Let me know if you need any other info. I will 
try yesterday's next
tree to check if this problem can be recreated.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------010407070305000806030608
Content-Type: text/plain;
 name="dmesg_next0424"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg_next0424"

Using pSeries machine description
Page orders: linear mapping = 16, virtual = 16, io = 12, vmemmap = 24
Using 1TB segments
Found initrd at 0xc000000003600000:0xc000000003bebc74
console [udbg0] enabled
Partition configured for 8 cpus.
CPU maps initialized for 2 threads per core
 (thread shift is 1)
Starting Linux PPC64 #2 SMP Fri Apr 24 11:30:39 IST 2009
-----------------------------------------------------
ppc64_pft_size                = 0x19
physicalMemorySize            = 0x80000000
htab_hash_mask                = 0x3ffff
-----------------------------------------------------
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.30-rc3-next-20090424 (root@mjs22lp5) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #2 SMP Fri Apr 24 11:30:39 IST 2009
[boot]0012 Setup Arch
Node 0 Memory: 0x8000000-0x46000000
Node 1 Memory: 0x0-0x8000000 0x46000000-0x80000000
EEH: No capable adapters found
PPC64 nvram contains 15360 bytes
Using shared processor idle loop
Zone PFN ranges:
  DMA      0x00000000 -> 0x00008000
  Normal   0x00008000 -> 0x00008000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    1: 0x00000000 -> 0x00000800
    0: 0x00000800 -> 0x00004600
    1: 0x00004600 -> 0x00008000
On node 0 totalpages: 15872
  DMA zone: 22 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 15850 pages, LIFO batch:1
On node 1 totalpages: 16896
  DMA zone: 44 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 16852 pages, LIFO batch:1
[boot]0015 Setup Done
Built 2 zonelists in Node order, mobility grouping on.  Total pages: 32702
Policy zone: DMA
Kernel command line: root=/dev/sda3 sysrq=1 
Experimental hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
Experimental hierarchical RCU init done.
NR_IRQS:512
[boot]0020 XICS Init
[boot]0021 XICS Done
pic: no ISA interrupt controller
PID hash table entries: 4096 (order: 12, 32768 bytes)
time_init: decrementer frequency = 512.000000 MHz
time_init: processor frequency   = 4005.000000 MHz
clocksource: timebase mult[7d0000] shift[22] registered
clockevent: decrementer mult[8312] shift[16] cpu[0]
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [hvc0]
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 4607 kB
 per task-struct memory footprint: 1920 bytes
allocated 1310720 bytes of page_cgroup
please try cgroup_disable=memory option if you don't want
freeing bootmem node 0
freeing bootmem node 1
Memory: 2035200k/2097152k available (8448k kernel code, 67136k reserved, 1216k data, 8988k bss, 448k init)
ODEBUG: 0 of 0 active objects replaced
ODEBUG: selftest passed
Calibrating delay loop... 1021.95 BogoMIPS (lpj=510976)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 262144 (order: 5, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 4, 1048576 bytes)
Mount-cache hash table entries: 4096
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
irq: irq 2 on host null mapped to virtual irq 16
Testing tracer nop: PASSED
clockevent: decrementer mult[8312] shift[16] cpu[1]
Processor 1 found.
clockevent: decrementer mult[8312] shift[16] cpu[2]
Processor 2 found.
clockevent: decrementer mult[8312] shift[16] cpu[3]
Processor 3 found.
Brought up 4 CPUs
Node 0 CPUs: 0-3
Node 1 CPUs:
CPU0 attaching sched-domain:
 domain 0: span 0-1 level SIBLING
  groups: 0 1
  domain 1: span 0-3 level CPU
   groups: 0-1 2-3
   domain 2: span 0-3 level NODE
    groups: 0-3 (__cpu_power = 2048)
CPU1 attaching sched-domain:
 domain 0: span 0-1 level SIBLING
  groups: 1 0
  domain 1: span 0-3 level CPU
   groups: 0-1 2-3
   domain 2: span 0-3 level NODE
    groups: 0-3 (__cpu_power = 2048)
CPU2 attaching sched-domain:
 domain 0: span 2-3 level SIBLING
  groups: 2 3
  domain 1: span 0-3 level CPU
   groups: 2-3 0-1
   domain 2: span 0-3 level NODE
    groups: 0-3 (__cpu_power = 2048)
CPU3 attaching sched-domain:
 domain 0: span 2-3 level SIBLING
  groups: 3 2
  domain 1: span 0-3 level CPU
   groups: 2-3 0-1
   domain 2: span 0-3 level NODE
    groups: 0-3 (__cpu_power = 2048)
khelper used greatest stack depth: 10176 bytes left

=====================================
[ BUG: lock held at task exit time! ]
-------------------------------------
khelper/21 is exiting with locks still held!
2 locks held by khelper/21:
 #0:  (rcu_read_lock){.+.+.+}, at: [<c0000000001382fc>] .check_unsafe_exec+0x44/0x148
 #1:  (rcu_read_lock){.+.+.+}, at: [<c000000000138368>] .check_unsafe_exec+0xb0/0x148

stack backtrace:
Call Trace:
[c000000044483cf0] [c000000000011a54] .show_stack+0x6c/0x16c (unreliable)
[c000000044483da0] [c00000000009ae14] .debug_check_no_locks_held+0x98/0xb4
[c000000044483e20] [c000000000073b1c] .do_exit+0x758/0x7b0
[c000000044483f00] [c0000000000853d8] .____call_usermodehelper+0x170/0x174
[c000000044483f90] [c00000000002bd8c] .kernel_thread+0x54/0x70
net_namespace: 2000 bytes
NET: Registered protocol family 16
IBM eBus Device Driver
PCI: Probing PCI hardware
PCI: Probing PCI hardware done
bio: create slab <bio-0> at 0
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Failed to register trace events module notifier
NET: Registered protocol family 2
IP route cache hash table entries: 16384 (order: 1, 131072 bytes)
TCP established hash table entries: 65536 (order: 4, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 5, 3670016 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...
rootfs image is initramfs; unpacking...
Freeing initrd memory: 6063k freed
irq: irq 655360 on host null mapped to virtual irq 17
irq: irq 655362 on host null mapped to virtual irq 18
IOMMU table initialized, virtual merging enabled
irq: irq 655364 on host null mapped to virtual irq 19
irq: irq 655365 on host null mapped to virtual irq 20
irq: irq 589825 on host null mapped to virtual irq 21
RTAS daemon started
audit: initializing netlink socket (disabled)
type=2000 audit(1240553894.305:1): initialized
Kprobe smoke test started
Kprobe smoke test passed successfully
HugeTLB registered 16 MB page size, pre-allocated 0 pages
HugeTLB registered 16 GB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
Btrfs loaded
msgmni has been set to 3984
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
vio_register_driver: driver hvc_console registering
HVSI: registered 0 devices
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
vio_register_driver: driver ibmvscsi registering
ibmvscsi 30000002: SRP_VERSION: 16.a
scsi0 : IBM POWER Virtual SCSI Adapter 1.5.8
ibmvscsi 30000002: partner initialization complete
ibmvscsi 30000002: sent SRP login
ibmvscsi 30000002: SRP_LOGIN succeeded
ibmvscsi 30000002: host srp version: 16.a, host partition 06-1C12A (1), OS 3, max io 262144
scsi 0:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
scsi 0:0:2:0: CD-ROM            AIX      VOPTA                 PQ: 0 ANSI: 4
ibmvfc: IBM Virtual Fibre Channel Driver version: 1.0.5 (March 19, 2009)
vio_register_driver: driver ibmvfc registering
st: Version 20081215, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
Driver 'osst' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi-1 drive
Uniform CD-ROM driver Revision: 3.20
sd 0:0:1:0: [sda] 33554432 512-byte hardware sectors: (17.1 GB/16.0 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: 17 00 00 08
sd 0:0:1:0: [sda] Cache data unavailable
sd 0:0:1:0: [sda] Assuming drive cache: write through
sr 0:0:2:0: Attached scsi CD-ROM sr0
sd 0:0:1:0: [sda] Cache data unavailable
sd 0:0:1:0: [sda] Assuming drive cache: write through
 sda:<5>sd 0:0:1:0: Attached scsi generic sg0 type 0
sr 0:0:2:0: Attached scsi generic sg1 type 5
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
mice: PS/2 mouse device common for all mice
 sda1 sda2 sda3 sda4 <<6>usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
Running tests on trace events:
Testing event kfree_skb:  sda5 sda6 >
sd 0:0:1:0: [sda] Attached SCSI disk
OK
Testing event kmem_cache_free: OK
Testing event kfree: OK
Testing event kmem_cache_alloc_node: OK
Testing event kmalloc_node: OK
Testing event kmem_cache_alloc: OK
Testing event kmalloc: OK
Testing event irq_handler_exit: OK
Testing event softirq_exit: OK
Testing event softirq_entry: OK
Testing event irq_handler_entry: OK
Testing event lock_release: OK
Testing event lock_acquire: OK
Testing event sched_signal_send: OK
Testing event sched_process_fork: OK
Testing event sched_process_wait: OK
Testing event sched_process_exit: OK
Testing event sched_process_free: OK
Testing event sched_migrate_task: OK
Testing event sched_switch: OK
Testing event sched_wakeup_new: OK
Testing event sched_wakeup: OK
Testing event sched_wait_task: OK
Testing event sched_kthread_stop_ret: OK
Testing event sched_kthread_stop: OK
Running tests on trace event systems:
Testing event system skb: OK
Testing event system kmem: OK
Testing event system irq: OK
Testing event system lockdep: OK
Testing event system sched: OK
Running tests on all trace events:
Testing all events: OK
Freeing unused kernel memory: 448k freed
SysRq : Changing Loglevel
Loglevel set to 1
udevd version 128 started
scsi_id used greatest stack depth: 9104 bytes left
vol_id used greatest stack depth: 8432 bytes left
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
stty used greatest stack depth: 8096 bytes left
mount used greatest stack depth: 7504 bytes left
udevd version 128 started
drivers/net/ibmveth.c: ibmveth: IBM i/pSeries Virtual Ethernet Driver 1.03
vio_register_driver: driver ibmveth registering
IBM eHEA ethernet device driver (Release EHEA_0100)
irq: irq 590080 on host null mapped to virtual irq 256
ehea: eth2: Jumbo frames are enabled
ehea: eth2 -> logical port id #9
ehea: eth3: Jumbo frames are enabled
ehea: eth3 -> logical port id #10
modprobe used greatest stack depth: 7200 bytes left
Adding 2096320k swap on /dev/sda5.  Priority:-1 extents:1 across:2096320k 
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
mv used greatest stack depth: 7008 bytes left
ehea: eth2: Physical port up
irq: irq 775 on host null mapped to virtual irq 263
ehea: External switch port is backup port
irq: irq 776 on host null mapped to virtual irq 264
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
modprobe used greatest stack depth: 6752 bytes left
eth2: no IPv6 routers present
less used greatest stack depth: 6336 bytes left

--------------010407070305000806030608--
