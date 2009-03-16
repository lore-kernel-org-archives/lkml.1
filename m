Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZCPHKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZCPHKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZCPHK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:10:27 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51421 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZCPHKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:10:24 -0400
Message-ID: <49BDFB4F.7040405@in.ibm.com>
Date: Mon, 16 Mar 2009 12:40:07 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: jfs-discussion@lists.sourceforge.net
CC: linux-kernel <linux-kernel@vger.kernel.org>, shaggy@austin.ibm.com
Subject: [BUG/JFS/2.6.29-rc8] kernel BUG at fs/mpage.c:473!
Content-Type: multipart/mixed;
 boundary="------------070604070005010500040106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070604070005010500040106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While running file system stress (fsstress) on a JFS partition
with 2.6.29-rc8, i hit the following BUG.

------------[ cut here ]------------
kernel BUG at fs/mpage.c:473!
cpu 0x0: Vector: 700 (Program Check) at [c0000000be9daba0]
    pc: c00000000014e3a0: .__mpage_writepage+0xd0/0x630
    lr: c0000000000dfedc: .write_cache_pages+0x288/0x42c
    sp: c0000000be9dae20
   msr: 8000000000029032
  current = 0xc00000003f30dd10
  paca    = 0xc000000000753400
    pid   = 27402, comm = fsstress
kernel BUG at fs/mpage.c:473!
enter ? for help
[c0000000be9db3a0] c0000000000dfedc .write_cache_pages+0x288/0x42c
[c0000000be9db530] c00000000014e298 .mpage_writepages+0x54/0x8c
[c0000000be9db5d0] d0000000032f1720 .jfs_writepages+0x1c/0x34 [jfs]
[c0000000be9db650] c0000000000e0120 .do_writepages+0x68/0xa4
[c0000000be9db6d0] c0000000000d764c .__filemap_fdatawrite_range+0x8c/0xbc
[c0000000be9db7c0] c0000000000d76bc .filemap_write_and_wait_range+0x40/0x8c
[c0000000be9db860] c0000000000d79f4 .generic_file_buffered_write+0x2ec/0x358
[c0000000be9db9a0] c0000000000d7f88
.__generic_file_aio_write_nolock+0x300/0x3ec
[c0000000be9dbaa0] c0000000000d8390 .generic_file_aio_write+0x80/0x114
[c0000000be9dbb60] c000000000118a24 .do_sync_write+0xc4/0x124
[c0000000be9dbcf0] c00000000011959c .vfs_write+0xd8/0x1a4
[c0000000be9dbd90] c000000000119768 .SyS_write+0x50/0x90
[c0000000be9dbe30] c000000000008534 syscall_exit+0x0/0x40
--- Exception: c01 (System Call) at 000000000ff0d8c8
SP (ff87c6f0) is in userspace

This is a powerpc box (IBM,9133-55A). I have attached the dmesg log
as well as the jfs-fsstress.log

Partition Table information : 

/dev/sda3 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/sda2 on /boot type ext3 (rw)
tmpfs on /dev/shm type tmpfs (rw)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
/dev/sda6 on /mnt/tmp type jfs (rw)

Let me know if there is any other information that i can provide.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------070604070005010500040106
Content-Type: text/plain;
 name="dmesg-log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-log"

Using pSeries machine description
Page orders: linear mapping = 24, virtual = 16, io = 12, vmemmap = 24
Using 1TB segments
Found initrd at 0xc000000002600000:0xc000000002865000
console [udbg0] enabled
Partition configured for 20 cpus.
CPU maps initialized for 2 threads per core
 (thread shift is 1)
Starting Linux PPC64 #1 SMP Sat Mar 14 22:21:27 IST 2009
-----------------------------------------------------
ppc64_pft_size                = 0x1b
physicalMemorySize            = 0x1c0000000
htab_hash_mask                = 0xfffff
-----------------------------------------------------
Initializing cgroup subsys cpuset
Linux version 2.6.29-rc8-autokern1 (root@xxxxxx.xx.xxx.xxx) (gcc version 4.1.2 20070626 (Red Hat 4.1.2-14)) #1 SMP Sat Mar 14 22:21:27 IST 2009
[boot]0012 Setup Arch
Node 0 Memory: 0x10000000-0xf0000000
Node 1 Memory: 0x0-0x10000000 0xf0000000-0x1c0000000
EEH: No capable adapters found
PPC64 nvram contains 7168 bytes
Using shared processor idle loop
Zone PFN ranges:
  DMA      0x00000000 -> 0x0001c000
  Normal   0x0001c000 -> 0x0001c000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    1: 0x00000000 -> 0x00001000
    0: 0x00001000 -> 0x0000f000
    1: 0x0000f000 -> 0x0001c000
On node 0 totalpages: 57344
  DMA zone: 49 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 57295 pages, LIFO batch:1
On node 1 totalpages: 57344
  DMA zone: 98 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 57246 pages, LIFO batch:1
[boot]0015 Setup Done
Built 2 zonelists in Node order, mobility grouping on.  Total pages: 114541
Policy zone: DMA
Kernel command line: ro console=hvc0 rhgb quiet root=LABEL=/1 autobench_args: root=/dev/sda3 ABAT:1237051183 
[boot]0020 XICS Init
[boot]0021 XICS Done
pic: no ISA interrupt controller
PID hash table entries: 4096 (order: 12, 32768 bytes)
time_init: decrementer frequency = 187.199000 MHz
time_init: processor frequency   = 1498.500000 MHz
clocksource: timebase mult[155e1d6] shift[22] registered
clockevent: decrementer mult[2fec] shift[16] cpu[0]
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [hvc0]
Dentry cache hash table entries: 1048576 (order: 7, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 6, 4194304 bytes)
allocated 4587520 bytes of page_cgroup
please try cgroup_disable=memory option if you don't want
freeing bootmem node 0
freeing bootmem node 1
Memory: 7259520k/7340032k available (6016k kernel code, 96384k reserved, 1024k data, 992k bss, 448k init)
Calibrating delay loop... 373.76 BogoMIPS (lpj=186880)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Mount-cache hash table entries: 4096
Initializing cgroup subsys debug
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
clockevent: decrementer mult[2fec] shift[16] cpu[1]
Processor 1 found.
Brought up 2 CPUs
Node 0 CPUs: 0-1
Node 1 CPUs:
CPU0 attaching sched-domain:
 domain 0: span 0-1 level SIBLING
  groups: 0 1
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level SIBLING
  groups: 1 0
  domain 1: span 0-1 level NODE
   groups: 0-1
khelper used greatest stack depth: 12160 bytes left
khelper used greatest stack depth: 11024 bytes left
net_namespace: 1672 bytes
NET: Registered protocol family 16
IBM eBus Device Driver
PCI: Probing PCI hardware
PCI: Probing PCI hardware done
bio: create slab <bio-0> at 0
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 3, 524288 bytes)
TCP established hash table entries: 262144 (order: 6, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 4, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 2452k freed
IOMMU table initialized, virtual merging enabled
RTAS daemon started
RTAS: event: 333, Type: Resource Deallocation Event, Severity: 2
RTAS: event: 334, Type: Resource Deallocation Event, Severity: 2
RTAS: event: 335, Type: Resource Deallocation Event, Severity: 2
audit: initializing netlink socket (disabled)
type=2000 audit(1237051441.513:1): initialized
HugeTLB registered 16 MB page size, pre-allocated 0 pages
HugeTLB registered 16 GB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
msgmni has been set to 14180
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
vio_register_driver: driver hvc_console registering
HVSI: registered 0 devices
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
mice: PS/2 mouse device common for all mice
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
Freeing unused kernel memory: 448k freed
uhci_hcd: USB Universal Host Controller Interface driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
vio_register_driver: driver ibmvscsi registering
ibmvscsi 30000003: SRP_VERSION: 16.a
scsi0 : IBM POWER Virtual SCSI Adapter 1.5.8
ibmvscsi 30000003: partner initialization complete
ibmvscsi 30000003: sent SRP login
ibmvscsi 30000003: SRP_LOGIN succeeded
ibmvscsi 30000003: host srp version: 16.a, host partition VIO_Server (1), OS 3, max io 262144
scsi 0:0:1:0: Direct-Access     AIX      VDASD                 PQ: 0 ANSI: 3
sd 0:0:1:0: [sda] 136314880 512-byte hardware sectors: (69.7 GB/65.0 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: 17 00 00 08
sd 0:0:1:0: [sda] Cache data unavailable
sd 0:0:1:0: [sda] Assuming drive cache: write through
sd 0:0:1:0: [sda] 136314880 512-byte hardware sectors: (69.7 GB/65.0 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: 17 00 00 08
sd 0:0:1:0: [sda] Cache data unavailable
sd 0:0:1:0: [sda] Assuming drive cache: write through
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:1:0: [sda] Attached SCSI disk
insmod used greatest stack depth: 4960 bytes left
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
type=1404 audit(1237051445.261:2): selinux=0 auid=4294967295 ses=4294967295
drivers/net/ibmveth.c: ibmveth: IBM i/pSeries Virtual Ethernet Driver 1.03
vio_register_driver: driver ibmveth registering
eth0 (ibmveth): not using net_device_ops yet
sd 0:0:1:0: Attached scsi generic sg0 type 0
lp: driver loaded but no devices found
i2c-core: driver [dummy] registered
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2048128k swap on /dev/sda5.  Priority:-1 extents:1 across:2048128k 


--------------070604070005010500040106
Content-Type: text/x-log;
 name="jfs-fsstress.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="jfs-fsstress.log"

autorun: fs --partition=1 --mkjfs --mount -l /mnt/tmp: command read
autorun: fs --partition=1 --mkjfs --mount -l /mnt/tmp: was expanded
03/15/2009-19:36:29 processing command: (1) 'fs --partition=1 --mkjfs --mount -l /mnt/tmp'
n format
PARTITION='/dev/sda6'
mkfs.jfs version 1.1.12, 24-Aug-2007


Format completed successfully.

34186288 kilobytes total disk space.
03/15/2009-19:36:31 fs: creating filesystem jfs Succeeded
03/15/2009-19:36:31 fs: mkdir for mount option Succeeded
03/15/2009-19:36:31 fs: mount of partition Succeeded
Completed successfully
03/15/2009-19:36:31 command complete: (1) rc=0 (GOOD)
autorun: reading command 85 /usr/local/autobench/scripts/autobench.dat
autorun: run test fsstress -d $scratchdir -l $iterations: command read
autorun: run test fsstress -d /mnt/tmp -l 1: was expanded
03/15/2009-19:36:37 processing command: (1) 'run test fsstress -d /mnt/tmp -l 1'
new log requested
03/15/2009-19:36:42 Running command fsstress
03/15/2009-19:36:53 fsstress: getcommand doprofilers Succeeded
Test directory: /mnt/tmp
Filesystem type under test: jfs
Number of iteration: 1
               chown 3/39 write op
               creat 4/39 write op
               dread 4/39  
              dwrite 4/39 write op
           fdatasync 1/39 write op
               fsync 1/39 write op
            getdents 1/39  
                link 1/39 write op
               mkdir 2/39 write op
               mknod 2/39 write op
                read 1/39  
            readlink 1/39  
              rename 2/39 write op
               rmdir 1/39 write op
                stat 1/39  
             symlink 2/39 write op
                sync 1/39  
            truncate 2/39 write op
              unlink 1/39 write op
               write 4/39 write op

seed = 1237289639
Linux 2.6.29-rc8-autokern1 (xxxxxx.xx.xxx.xxx) 	03/15/2009 	_ppc64_

07:37:00 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
07:37:05 PM     all      0.20      0.00      2.60     90.80      1.10      5.30
07:37:10 PM     all      0.00      0.00      0.80     98.90      0.30      0.00
07:37:15 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
07:37:20 PM     all      0.00      0.00      0.60     99.20      0.20      0.00
07:37:25 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
07:37:30 PM     all      0.20      0.00      1.20     98.10      0.50      0.00
07:37:35 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:37:40 PM     all      0.10      0.00      0.70     98.90      0.30      0.00
07:37:45 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
07:37:50 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
07:37:55 PM     all      0.00      0.00      0.80     98.90      0.30      0.00
07:38:00 PM     all      0.20      0.00      0.80     98.80      0.20      0.00
07:38:05 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
07:38:10 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
07:38:15 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
07:38:20 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
07:38:25 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
07:38:30 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
07:38:35 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
07:38:40 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:38:45 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
07:38:50 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:38:55 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
07:39:00 PM     all      0.20      0.00      1.40     97.90      0.50      0.00
07:39:05 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
07:39:10 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
07:39:15 PM     all      0.20      0.00      1.40     98.10      0.30      0.00
07:39:20 PM     all      0.10      0.00      1.00     98.50      0.40      0.00
07:39:25 PM     all      0.20      0.00      2.00     97.30      0.50      0.00
07:39:30 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
07:39:35 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
07:39:40 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
07:39:45 PM     all      0.00      0.00      1.20     98.50      0.30      0.00
07:39:50 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
07:39:55 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
07:40:00 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
07:40:05 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
07:40:10 PM     all      0.10      0.00      1.60     97.50      0.80      0.00
07:40:15 PM     all      0.00      0.00      0.50     99.50      0.00      0.00
07:40:20 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
07:40:25 PM     all      0.10      0.00      1.40     98.00      0.50      0.00
07:40:30 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
07:40:35 PM     all      0.10      0.00      1.10     98.30      0.50      0.00
07:40:47 PM     all      0.16      0.00      1.14     98.38      0.32      0.00
07:40:59 PM     all      0.13      0.00      1.19     98.35      0.34      0.00
07:41:04 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
07:41:09 PM     all      0.10      0.00      1.00     98.40      0.50      0.00
07:41:14 PM     all      0.20      0.00      1.40     98.10      0.30      0.00
07:41:19 PM     all      0.10      0.00      1.40     98.00      0.50      0.00
07:41:24 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
07:41:29 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
07:41:34 PM     all      0.10      0.00      1.50     97.90      0.50      0.00
07:41:39 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:41:44 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
07:41:49 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
07:41:54 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
07:41:59 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:42:04 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
07:42:09 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:42:14 PM     all      0.10      0.00      1.40     98.20      0.30      0.00
07:42:19 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
07:42:24 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
07:42:29 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:42:34 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
07:42:39 PM     all      0.10      0.00      1.40     98.20      0.30      0.00
07:42:44 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
07:42:49 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:42:54 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
07:42:59 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
07:43:04 PM     all      0.20      0.00      0.80     98.90      0.10      0.00
07:43:09 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
07:43:14 PM     all      0.00      0.00      1.00     98.70      0.30      0.00
07:43:19 PM     all      0.20      0.00      1.20     98.30      0.30      0.00
07:43:24 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
07:43:29 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
07:43:34 PM     all      0.00      0.00      1.10     98.60      0.30      0.00
07:43:39 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
07:43:44 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
07:43:49 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
07:43:54 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
07:43:59 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
07:44:04 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
07:44:09 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:44:14 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
07:44:19 PM     all      0.20      0.00      1.50     97.81      0.50      0.00
07:44:24 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
07:44:29 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
07:44:34 PM     all      0.10      0.00      0.90     98.90      0.10      0.00
07:44:39 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
07:44:44 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:44:49 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:44:54 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:44:59 PM     all      0.20      0.00      1.60     97.60      0.60      0.00
07:45:04 PM     all      0.20      0.00      1.60     97.80      0.40      0.00
07:45:09 PM     all      0.10      0.00      1.60     97.70      0.60      0.00
07:45:14 PM     all      0.10      0.00      0.80     99.00      0.10      0.00
07:45:19 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
07:45:24 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
07:45:29 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
07:45:34 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
07:45:44 PM     all      0.10      0.00      0.98     98.67      0.25      0.00
07:45:49 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
07:45:54 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
07:45:59 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:46:04 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
07:46:09 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
07:46:14 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
07:46:19 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
07:46:24 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
07:46:29 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
07:46:34 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
07:46:39 PM     all      0.10      0.00      1.20     98.50      0.20      0.00
07:46:44 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
07:46:49 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:47:02 PM     all      0.12      0.00      1.16     98.38      0.35      0.00
07:47:07 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
07:47:12 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:47:17 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:47:22 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:47:27 PM     all      0.10      0.00      1.00     98.50      0.40      0.00
07:47:32 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
07:47:37 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
07:47:42 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:47:47 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
07:47:52 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
07:47:57 PM     all      0.20      0.00      1.60     97.60      0.60      0.00
07:48:02 PM     all      0.00      0.00      0.90     98.80      0.30      0.00
07:48:07 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
07:48:12 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
07:48:17 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
07:48:22 PM     all      0.10      0.00      0.50     99.40      0.00      0.00
07:48:27 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
07:48:32 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:48:37 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
07:48:42 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:48:47 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
07:48:52 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
07:48:57 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:49:02 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
07:49:07 PM     all      0.10      0.00      0.70     98.90      0.30      0.00
07:49:12 PM     all      0.10      0.00      1.20     98.50      0.20      0.00
07:49:17 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:49:22 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
07:49:27 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
07:49:32 PM     all      0.20      0.00      1.40     97.90      0.50      0.00
07:49:37 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
07:49:42 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
07:49:47 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
07:49:52 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
07:49:57 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
07:50:02 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
07:50:07 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
07:50:12 PM     all      0.20      0.00      1.50     97.60      0.70      0.00
07:50:17 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:50:22 PM     all      0.10      0.00      1.50     97.90      0.50      0.00
07:50:27 PM     all      0.00      0.00      0.40     99.60      0.00      0.00
07:50:32 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
07:50:37 PM     all      0.10      0.00      1.10     98.20      0.60      0.00
07:50:42 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
07:50:47 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
07:50:52 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:50:57 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
07:51:02 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
07:51:07 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
07:51:12 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
07:51:17 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
07:51:22 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
07:51:27 PM     all      0.20      0.00      1.30     98.00      0.50      0.00
07:51:32 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:51:37 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
07:51:42 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
07:51:47 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
07:51:52 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
07:51:57 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
07:52:02 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
07:52:07 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
07:52:12 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
07:52:17 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:52:22 PM     all      0.20      0.00      1.50     97.70      0.60      0.00
07:52:27 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
07:52:32 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
07:52:37 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:52:42 PM     all      0.20      0.00      1.30     98.20      0.30      0.00
07:52:47 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
07:52:52 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
07:52:57 PM     all      0.20      0.00      1.40     98.10      0.30      0.00
07:53:02 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
07:53:07 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:53:19 PM     all      0.08      0.00      0.98     98.65      0.29      0.00
07:53:24 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:53:29 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
07:53:34 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
07:53:48 PM     all      0.11      0.00      1.83     96.93      1.13      0.00
07:53:53 PM     all      0.20      0.00      1.80     97.20      0.80      0.00
07:53:58 PM     all      0.20      0.00      9.30     81.70      8.80      0.00
07:54:09 PM     all      0.09      0.00      1.41     98.23      0.27      0.00
07:54:26 PM     all      0.09      0.00      0.98     98.58      0.36      0.00
07:54:31 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:54:36 PM     all      0.20      0.00      1.90     97.30      0.60      0.00
07:54:41 PM     all      3.50      0.00      0.70     95.40      0.40      0.00
07:54:46 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
07:54:51 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
07:54:56 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
07:55:01 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
07:55:06 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
07:55:11 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
07:55:16 PM     all      0.20      0.00      1.20     98.30      0.30      0.00
07:55:27 PM     all      0.09      0.00      1.08     98.54      0.28      0.00
07:55:32 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:55:37 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:55:42 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
07:55:47 PM     all      0.20      0.00      1.50     97.80      0.50      0.00
07:55:52 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
07:55:57 PM     all      0.20      0.00      1.60     97.60      0.60      0.00
07:56:02 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
07:56:07 PM     all      0.20      0.00      1.40     98.10      0.30      0.00
07:56:12 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
07:56:17 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
07:56:22 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
07:56:27 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
07:56:32 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
07:56:37 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
07:56:42 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
07:56:52 PM     all      0.10      0.00      1.15     98.46      0.30      0.00
07:56:57 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
07:57:02 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:57:07 PM     all      0.20      0.00      1.50     97.80      0.50      0.00
07:57:12 PM     all      0.10      0.00      1.50     97.90      0.50      0.00
07:57:17 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
07:57:22 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
07:57:27 PM     all      0.20      0.00      0.90     98.60      0.30      0.00
07:57:32 PM     all      0.00      0.00      2.20     97.10      0.70      0.00
07:57:37 PM     all      0.10      0.00      0.40     99.40      0.10      0.00
07:57:42 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:57:47 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
07:57:52 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
07:57:57 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:58:02 PM     all      0.10      0.00      0.80     99.00      0.10      0.00
07:58:07 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
07:58:12 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
07:58:17 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
07:58:22 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
07:58:27 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
07:58:32 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
07:58:37 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
07:58:42 PM     all      0.10      0.00      1.00     98.50      0.40      0.00
07:58:47 PM     all      0.10      0.00      1.80     97.70      0.40      0.00
07:58:52 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
07:58:57 PM     all      0.20      0.00      1.40     97.90      0.50      0.00
07:59:02 PM     all      0.10      0.00      1.70     97.70      0.50      0.00
07:59:07 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
07:59:12 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
07:59:17 PM     all      0.10      0.00      1.50     97.90      0.50      0.00
07:59:22 PM     all      0.00      0.00      0.60     99.20      0.20      0.00
07:59:27 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
07:59:32 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
07:59:37 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
07:59:50 PM     all      0.08      0.00      0.75     98.97      0.20      0.00
07:59:55 PM     all      0.00      0.00      0.70     99.00      0.30      0.00
08:00:00 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:00:05 PM     all      0.20      0.00      1.80     97.50      0.50      0.00
08:00:10 PM     all      0.20      0.00      1.40     97.80      0.60      0.00
08:00:15 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:00:20 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:00:25 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
08:00:30 PM     all      0.00      0.00      1.00     98.80      0.20      0.00
08:00:35 PM     all      0.20      0.00      1.30     98.00      0.50      0.00
08:00:40 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:00:45 PM     all      0.00      0.00      1.20     98.60      0.20      0.00
08:00:50 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
08:00:55 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:01:00 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
08:01:05 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:01:10 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
08:01:15 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:01:20 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:01:25 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:01:30 PM     all      0.00      0.00      1.10     98.70      0.20      0.00
08:01:35 PM     all      0.20      0.00      1.00     98.50      0.30      0.00
08:01:40 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:01:51 PM     all      0.09      0.00      1.20     98.34      0.37      0.00
08:01:56 PM     all      0.10      0.00      1.20     98.50      0.20      0.00
08:02:01 PM     all      0.10      0.00      1.50     97.80      0.60      0.00
08:02:06 PM     all      0.20      0.00      1.40     98.10      0.30      0.00
08:02:11 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:02:16 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:02:21 PM     all      0.20      0.00      1.50     97.90      0.40      0.00
08:02:26 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:02:31 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:02:36 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
08:02:41 PM     all      0.20      0.00      1.60     97.80      0.40      0.00
08:02:46 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:02:51 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:02:56 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:03:01 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
08:03:06 PM     all      0.00      0.00      1.00     98.80      0.20      0.00
08:03:11 PM     all      0.20      0.00      1.40     98.10      0.30      0.00
08:03:16 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:03:21 PM     all      0.20      0.00      1.50     97.90      0.40      0.00
08:03:26 PM     all      0.10      0.00      1.00     98.50      0.40      0.00
08:03:31 PM     all      0.10      0.00      1.40     98.00      0.50      0.00
08:03:36 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:03:41 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:03:46 PM     all      0.20      0.00      1.50     97.90      0.40      0.00
08:03:51 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:03:56 PM     all      0.20      0.00      1.30     98.20      0.30      0.00
08:04:06 PM     all      0.10      0.00      1.13     98.47      0.30      0.00
08:04:11 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
08:04:16 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
08:04:21 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:04:26 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:04:31 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:04:36 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
08:04:41 PM     all      0.10      0.00      5.70     89.50      4.70      0.00
08:04:46 PM     all      0.00      0.00      0.40     99.60      0.00      0.00
08:04:56 PM     all      0.10      0.00      9.42     81.89      8.59      0.00
08:05:09 PM     all      0.19      0.00      1.80     97.25      0.76      0.00
08:05:21 PM     all      0.21      0.00      1.66     97.59      0.54      0.00
08:05:26 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
08:05:31 PM     all      0.10      0.00      0.50     99.20      0.20      0.00
08:05:36 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
08:05:41 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
08:05:46 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:05:57 PM     all      0.23      0.00      1.81     97.41      0.56      0.00
08:06:07 PM     all      0.15      0.00      1.59     97.81      0.45      0.00
08:06:12 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
08:06:17 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
08:06:22 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:06:27 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:06:32 PM     all      0.10      0.00      1.00     98.50      0.40      0.00
08:06:37 PM     all      0.20      0.00      1.60     97.80      0.40      0.00
08:06:50 PM     all      0.19      0.00      1.52     97.81      0.48      0.00
08:06:55 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:07:00 PM     all      0.20      0.00      1.90     97.30      0.60      0.00
08:07:05 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:07:10 PM     all      0.10      0.00      1.60     97.30      1.00      0.00
08:07:15 PM     all      0.20      0.00      1.80     97.21      0.80      0.00
08:07:20 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:07:25 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:07:30 PM     all      0.10      0.00      1.40     97.90      0.60      0.00
08:07:35 PM     all      0.10      0.00      1.30     98.40      0.20      0.00
08:07:40 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
08:07:45 PM     all      0.10      0.00      1.20     98.50      0.20      0.00
08:07:50 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:07:55 PM     all      0.00      0.00      0.90     98.80      0.30      0.00
08:08:06 PM     all      0.15      0.00      1.37     98.10      0.39      0.00
08:08:11 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:08:16 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:08:21 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:08:26 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
08:08:31 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:08:36 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:08:41 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:08:46 PM     all      0.20      0.00      3.90     94.40      1.50      0.00
08:09:05 PM     all      0.08      0.00      0.80     99.00      0.13      0.00
08:09:10 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:09:15 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
08:09:20 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:09:25 PM     all      0.10      0.00      0.50     99.30      0.10      0.00
08:09:30 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
08:09:35 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:09:40 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:09:45 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:09:50 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
08:09:55 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
08:10:00 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:10:05 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
08:10:10 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:10:15 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:10:20 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:10:30 PM     all      0.10      0.00      1.18     98.37      0.34      0.00
08:10:35 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
08:10:47 PM     all      0.08      0.00      1.02     98.60      0.30      0.00
08:10:52 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
08:10:57 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:11:02 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:11:07 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
08:11:12 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:11:17 PM     all      0.00      0.00      0.90     98.90      0.20      0.00
08:11:22 PM     all      0.20      0.00      1.40     97.91      0.50      0.00
08:11:27 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:11:32 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:11:37 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
08:11:42 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:11:52 PM     all      0.10      0.00      1.09     98.51      0.30      0.00
08:11:57 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:12:02 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:12:07 PM     all      0.10      0.00      1.40     98.00      0.50      0.00
08:12:12 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:12:17 PM     all      0.20      0.00      2.10     96.60      1.10      0.00
08:12:22 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
08:12:27 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:12:32 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:12:37 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:12:42 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:12:47 PM     all      0.10      0.00      2.00     97.10      0.80      0.00
08:12:52 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
08:12:57 PM     all      0.10      0.00      0.50     99.30      0.10      0.00
08:13:02 PM     all      0.10      0.00      1.20     98.50      0.20      0.00
08:13:07 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
08:13:12 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:13:17 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
08:13:22 PM     all      0.20      0.00      1.70     97.50      0.60      0.00
08:13:27 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
08:13:32 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:13:37 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:13:42 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:13:47 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:13:52 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
08:13:57 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
08:14:02 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:14:07 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:14:12 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:14:17 PM     all      0.10      0.00      1.70     97.30      0.90      0.00
08:14:22 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:14:27 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:14:32 PM     all      0.20      0.00      1.00     98.50      0.30      0.00
08:14:37 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:14:42 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:14:47 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:14:52 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:14:57 PM     all      0.00      0.00      1.00     98.70      0.30      0.00
08:15:02 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
08:15:07 PM     all      0.20      0.00      1.60     97.70      0.50      0.00
08:15:12 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:15:17 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:15:28 PM     all      0.10      0.00      0.96     98.66      0.29      0.00
08:15:33 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:15:43 PM     all      0.14      0.00      1.34     98.13      0.38      0.00
08:15:48 PM     all      0.20      0.00      1.50     97.90      0.40      0.00
08:15:53 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:15:58 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:16:03 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
08:16:08 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:16:18 PM     all      0.15      0.00      1.37     98.14      0.34      0.00
08:16:23 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:16:28 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
08:16:33 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:16:38 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:16:43 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:16:48 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:16:53 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
08:16:58 PM     all      0.00      0.00      1.00     98.80      0.20      0.00
08:17:03 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:17:08 PM     all      0.10      0.00      2.50     95.60      1.80      0.00
08:17:13 PM     all      0.20      0.00      1.20     98.30      0.30      0.00
08:17:18 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:17:29 PM     all      0.19      0.00      1.86     97.30      0.65      0.00
08:17:34 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:17:39 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:17:44 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:17:49 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
08:17:54 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:17:59 PM     all      0.00      0.00      0.80     99.10      0.10      0.00
08:18:04 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:18:09 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:18:14 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:18:19 PM     all      0.20      0.00      0.90     98.60      0.30      0.00
08:18:24 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:18:29 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:18:34 PM     all      0.10      0.00      1.50     97.90      0.50      0.00
08:18:39 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
08:18:44 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:18:49 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:19:01 PM     all      0.08      0.00      1.03     98.59      0.29      0.00
08:19:06 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:19:11 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:19:16 PM     all      0.20      0.00      1.70     97.50      0.60      0.00
08:19:21 PM     all      0.10      0.00      1.30     97.90      0.70      0.00
08:19:26 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:19:31 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
08:19:36 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:19:41 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:19:46 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
08:19:51 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
08:20:02 PM     all      0.14      0.00      1.52     97.83      0.51      0.00
08:20:07 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:20:12 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:20:17 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
08:20:22 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
08:20:27 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:20:32 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:20:37 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:20:42 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:20:47 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:20:52 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
08:20:57 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
08:21:02 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:21:07 PM     all      0.10      0.00      1.30     98.40      0.20      0.00
08:21:12 PM     all      0.10      0.00      1.70     97.10      1.10      0.00
08:21:17 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:21:22 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:21:27 PM     all      0.20      0.00      1.60     97.70      0.50      0.00
08:21:32 PM     all      0.10      0.00      1.60     97.80      0.50      0.00
08:21:37 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
08:21:42 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:21:47 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
08:21:52 PM     all      0.20      0.00      1.40     97.90      0.50      0.00
08:21:57 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:22:02 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:22:07 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:22:12 PM     all      0.20      0.00      1.80     97.50      0.50      0.00
08:22:17 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:22:22 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
08:22:27 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
08:22:32 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
08:22:37 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
08:22:42 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:22:47 PM     all      0.20      0.00      1.40     97.90      0.50      0.00
08:22:59 PM     all      0.09      0.00      0.78     99.00      0.13      0.00
08:23:04 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
08:23:09 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:23:14 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:23:19 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
08:23:24 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:23:29 PM     all      0.10      0.00      2.60     96.20      1.10      0.00
08:23:34 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
08:23:39 PM     all      0.10      0.00      1.20     93.10      0.50      5.10
08:23:44 PM     all      0.40      0.00     26.37     43.66     25.67      3.90
08:23:55 PM     all      0.14      0.00      1.82     97.59      0.45      0.00
08:24:05 PM     all      0.14      0.00      1.14     98.45      0.27      0.00
08:24:10 PM     all      0.20      0.00      1.60     97.80      0.40      0.00
08:24:15 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:24:20 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:24:25 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:24:30 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:24:35 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
08:24:40 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
08:24:45 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
08:24:50 PM     all      0.10      0.00      1.50     98.10      0.30      0.00
08:24:55 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
08:25:00 PM     all      0.10      0.00      1.50     98.10      0.30      0.00
08:25:05 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
08:25:10 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
08:25:15 PM     all      0.20      0.00      1.40     97.90      0.50      0.00
08:25:20 PM     all      0.10      0.00      1.20     98.50      0.20      0.00
08:25:25 PM     all      0.10      0.00      1.50     97.90      0.50      0.00
08:25:30 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:25:35 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
08:25:40 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
08:25:45 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
08:25:50 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:25:55 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
08:26:00 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:26:05 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:26:16 PM     all      0.09      0.00      1.17     98.45      0.28      0.00
08:26:21 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:26:26 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
08:26:31 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:26:36 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:26:41 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:26:46 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:26:51 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
08:26:56 PM     all      0.00      0.00      0.80     98.90      0.30      0.00
08:27:01 PM     all      0.20      0.00      1.20     98.30      0.30      0.00
08:27:06 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:27:11 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:27:16 PM     all      0.20      0.00      1.90     97.20      0.70      0.00
08:27:21 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
08:27:26 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
08:27:31 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:27:36 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:27:41 PM     all      0.00      0.00      0.40     99.60      0.00      0.00
08:27:46 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:27:51 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:27:56 PM     all      0.20      0.00      1.40     97.90      0.50      0.00
08:28:01 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
08:28:12 PM     all      0.09      0.00      1.14     98.44      0.32      0.00
08:28:17 PM     all      0.10      0.00      1.30     97.80      0.80      0.00
08:28:22 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
08:28:27 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:28:42 PM     all      0.07      0.00      0.72     99.00      0.21      0.00
08:28:47 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:28:52 PM     all      0.00      0.00      0.50     99.50      0.00      0.00
08:28:57 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
08:29:02 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
08:29:07 PM     all      0.20      0.00      1.60     97.80      0.40      0.00
08:29:12 PM     all      0.10      0.00      1.50     97.90      0.50      0.00
08:29:17 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:29:22 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:29:27 PM     all      0.00      0.00      0.80     98.90      0.30      0.00
08:29:32 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
08:29:37 PM     all      0.20      0.00      1.60     97.80      0.40      0.00
08:29:42 PM     all      0.10      0.00      1.00     98.50      0.40      0.00
08:29:47 PM     all      0.20      0.00      2.20     96.80      0.80      0.00
08:29:52 PM     all      0.00      0.00      0.50     99.50      0.00      0.00
08:29:57 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:30:02 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
08:30:07 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
08:30:12 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:30:17 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:30:22 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:30:27 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
08:30:32 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
08:30:37 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
08:30:42 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:30:47 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:30:52 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
08:30:57 PM     all      0.20      0.00      1.30     98.00      0.50      0.00
08:31:02 PM     all      0.20      0.00      1.40     98.10      0.30      0.00
08:31:07 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:31:12 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:31:22 PM     all      0.15      0.00      1.42     98.04      0.39      0.00
08:31:27 PM     all      0.20      0.00      1.50     97.90      0.40      0.00
08:31:32 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:31:37 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:31:42 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:31:47 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:31:52 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:31:57 PM     all      0.20      0.00      2.50     95.80      1.50      0.00
08:32:02 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:32:07 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:32:12 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:32:17 PM     all      0.00      0.00      0.90     98.90      0.20      0.00
08:32:22 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
08:32:27 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
08:32:32 PM     all      0.20      0.00      1.80     97.20      0.80      0.00
08:32:37 PM     all      0.20      0.00      1.60     97.50      0.70      0.00
08:32:48 PM     all      0.09      0.00      1.22     98.33      0.36      0.00
08:32:53 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:32:58 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
08:33:03 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
08:33:08 PM     all      0.00      0.00      0.60     99.20      0.20      0.00
08:33:13 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:33:18 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
08:33:23 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
08:33:28 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:33:33 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:33:38 PM     all      0.20      0.00      2.50     96.20      1.10      0.00
08:33:43 PM     all      0.20      0.00      1.20     98.30      0.30      0.00
08:33:48 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:33:53 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:33:58 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:34:03 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:34:08 PM     all      0.10      0.00      1.60     97.80      0.50      0.00
08:34:13 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:34:18 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:34:23 PM     all      0.10      0.00      0.90     92.50      0.20      6.30
08:34:28 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
08:34:33 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:34:38 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
08:34:50 PM     all      0.08      0.00      1.04     98.62      0.25      0.00
08:34:55 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:35:00 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:35:05 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:35:10 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
08:35:15 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:35:20 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:35:25 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:35:35 PM     all      0.10      0.00      1.04     98.62      0.25      0.00
08:35:40 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
08:35:45 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:35:50 PM     all      0.10      0.00      1.50     97.60      0.80      0.00
08:35:55 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
08:36:00 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:36:05 PM     all      0.10      0.00      0.90     96.21      0.20      2.59
08:36:10 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:36:15 PM     all      0.10      0.00      4.20     93.20      2.50      0.00
08:36:20 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:36:25 PM     all      0.10      0.00     14.09     72.23     13.59      0.00
08:36:51 PM     all      0.23      0.00      7.79     85.49      6.48      0.00
08:36:56 PM     all      0.00      0.00      0.40     99.50      0.10      0.00
08:37:01 PM     all      0.10      0.00      0.50     99.30      0.10      0.00
08:37:06 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
08:37:11 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:37:16 PM     all      0.10      0.00      1.40     98.20      0.30      0.00
08:37:21 PM     all      0.20      0.00      1.10     98.30      0.40      0.00
08:37:26 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:37:31 PM     all      0.10      0.00      0.90     98.90      0.10      0.00
08:37:36 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
08:37:41 PM     all      0.20      0.00      1.10     98.30      0.40      0.00
08:37:46 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:37:51 PM     all      0.10      0.00      0.80     99.00      0.10      0.00
08:37:56 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
08:38:01 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:38:06 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:38:11 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
08:38:16 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:38:21 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:38:26 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:38:31 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
08:38:36 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
08:38:41 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
08:38:46 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
08:38:51 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
08:38:56 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:39:01 PM     all      0.20      0.00      1.50     97.90      0.40      0.00
08:39:06 PM     all      0.20      0.00      1.60     97.70      0.50      0.00
08:39:11 PM     all      0.10      0.00      1.70     97.90      0.30      0.00
08:39:16 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
08:39:21 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
08:39:32 PM     all      0.09      0.00      1.17     98.39      0.35      0.00
08:39:37 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:39:42 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:39:53 PM     all      0.14      0.00      1.20     98.34      0.32      0.00
08:39:58 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:40:03 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
08:40:08 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:40:13 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:40:18 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:40:23 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:40:28 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:40:33 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
08:40:38 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:40:43 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:40:48 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:40:53 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:40:58 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
08:41:03 PM     all      0.00      0.00      0.90     98.90      0.20      0.00
08:41:08 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:41:13 PM     all      0.20      0.00      1.60     97.70      0.50      0.00
08:41:18 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:41:23 PM     all      0.20      0.00      0.80     98.60      0.40      0.00
08:41:28 PM     all      0.20      0.00      3.90     94.61      1.30      0.00
08:41:41 PM     all      0.04      0.00      0.64     99.25      0.08      0.00
08:41:46 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:41:51 PM     all      0.10      0.00      1.60     98.00      0.30      0.00
08:41:56 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:42:01 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:42:06 PM     all      0.10      0.00      1.60     97.70      0.60      0.00
08:42:11 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:42:16 PM     all      0.20      0.00      0.90     98.70      0.20      0.00
08:42:21 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:42:26 PM     all      0.00      0.00      0.90     98.90      0.20      0.00
08:42:31 PM     all      0.10      0.00      1.00     98.50      0.40      0.00
08:42:36 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:42:41 PM     all      0.00      0.00      0.40     99.60      0.00      0.00
08:42:46 PM     all      0.10      0.00      0.50     99.30      0.10      0.00
08:42:51 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
08:42:56 PM     all      0.00      0.00      0.40     99.50      0.10      0.00
08:43:01 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
08:43:06 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
08:43:11 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
08:43:16 PM     all      0.10      0.00      0.90     98.90      0.10      0.00
08:43:21 PM     all      0.10      0.00      1.00     98.50      0.40      0.00
08:43:26 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
08:43:31 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:43:36 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
08:43:41 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:43:46 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:43:51 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:43:56 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:44:01 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:44:06 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
08:44:11 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
08:44:16 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
08:44:21 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
08:44:26 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:44:31 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:44:36 PM     all      0.10      0.00      2.00     95.60      0.60      1.70
08:44:41 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
08:44:46 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:44:51 PM     all      0.00      0.00      0.30     99.60      0.10      0.00
08:44:56 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:45:01 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:45:11 PM     all      0.15      0.00      1.57     97.94      0.34      0.00
08:45:16 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:45:21 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:45:26 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:45:31 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:45:36 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:45:41 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
08:45:46 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
08:45:57 PM     all      0.14      0.00      1.15     98.38      0.32      0.00
08:46:07 PM     all      0.15      0.00      1.17     98.34      0.34      0.00
08:46:12 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:46:23 PM     all      0.09      0.00      0.84     98.83      0.23      0.00
08:46:28 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:46:33 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:46:38 PM     all      0.20      0.00      1.20     98.40      0.20      0.00
08:46:43 PM     all      0.10      0.00      1.30     97.40      0.40      0.80
08:46:54 PM     all      0.09      0.00      1.67     97.34      0.90      0.00
08:46:59 PM     all      0.10      0.00      0.50     99.30      0.10      0.00
08:47:04 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:47:09 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
08:47:14 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:47:19 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:47:24 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:47:29 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
08:47:34 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
08:47:39 PM     all      0.10      0.00      1.20     98.20      0.50      0.00
08:47:44 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
08:47:49 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:47:54 PM     all      0.10      0.00      1.20     98.20      0.50      0.00
08:47:59 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:48:04 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:48:09 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:48:14 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
08:48:19 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:48:24 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
08:48:29 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:48:34 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:48:39 PM     all      0.20      0.00      1.30     98.11      0.40      0.00
08:48:44 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:48:49 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
08:48:54 PM     all      0.10      0.00      1.40     98.00      0.50      0.00
08:49:05 PM     all      0.13      0.00      1.14     98.37      0.35      0.00
08:49:10 PM     all      0.10      0.00      0.80     99.00      0.10      0.00
08:49:15 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:49:20 PM     all      0.00      0.00      0.40     99.50      0.10      0.00
08:49:25 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:49:30 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:49:35 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:49:40 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
08:49:45 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:49:50 PM     all      0.10      0.00      1.40     98.00      0.50      0.00
08:49:55 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
08:50:00 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
08:50:05 PM     all      0.10      0.00      1.00     98.50      0.40      0.00
08:50:10 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:50:15 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
08:50:20 PM     all      0.20      0.00      1.80     97.50      0.50      0.00
08:50:32 PM     all      0.08      0.00      0.98     98.69      0.25      0.00
08:50:37 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:50:42 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:50:47 PM     all      0.20      0.00      1.30     98.11      0.40      0.00
08:50:52 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
08:50:57 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
08:51:02 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:51:07 PM     all      0.10      0.00      1.90     97.20      0.80      0.00
08:51:12 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
08:51:18 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:51:23 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
08:51:35 PM     all      0.25      0.00     12.23     75.95     11.57      0.00
08:51:45 PM     all      0.14      0.00      1.74     97.62      0.50      0.00
08:51:50 PM     all      0.10      0.00      7.11     86.69      6.11      0.00
08:52:01 PM     all      0.24      0.00      2.69     95.79      1.27      0.00
08:52:06 PM     all      0.20      0.00      1.60     97.70      0.50      0.00
08:52:11 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:52:16 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:52:27 PM     all      0.09      0.00      1.18     98.36      0.36      0.00
08:52:32 PM     all      0.10      0.00      0.40     99.40      0.10      0.00
08:52:42 PM     all      0.00      0.00      0.38     99.62      0.00      0.00
08:52:47 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:52:52 PM     all      0.10      0.00      0.50     99.30      0.10      0.00
08:52:57 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:53:02 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:53:07 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
08:53:12 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
08:53:17 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
08:53:22 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:53:27 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:53:32 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:53:37 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
08:53:42 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
08:53:47 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
08:53:52 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:53:57 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
08:54:02 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:54:07 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
08:54:12 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
08:54:17 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
08:54:22 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:54:27 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
08:54:32 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
08:54:37 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
08:54:42 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
08:54:47 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:55:01 PM     all      0.22      0.00      0.95     98.60      0.22      0.00
08:55:13 PM     all      0.20      0.00      0.78     98.77      0.25      0.00
08:55:25 PM     all      0.33      0.00      0.85     98.58      0.24      0.00
08:55:30 PM     all      0.40      0.00      0.80     98.60      0.20      0.00
08:55:45 PM     all      0.35      0.00      0.87     98.54      0.24      0.00
08:55:55 PM     all      0.34      0.00      0.88     98.54      0.24      0.00
08:56:07 PM     all      0.16      0.00      0.97     98.63      0.24      0.00
08:56:12 PM     all      0.20      0.00      1.40     97.90      0.50      0.00
08:56:17 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:56:22 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
08:56:33 PM     all      0.09      0.00      1.44     98.10      0.36      0.00
08:56:38 PM     all      0.10      0.00      1.50     97.70      0.70      0.00
08:56:43 PM     all      0.20      0.00      1.10     98.50      0.20      0.00
08:56:48 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
08:56:53 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:56:58 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
08:57:03 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:57:08 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:57:13 PM     all      0.10      0.00      0.90     98.60      0.40      0.00
08:57:18 PM     all      0.10      0.00      0.80     99.00      0.10      0.00
08:57:23 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:57:28 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
08:57:33 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:57:38 PM     all      0.20      0.00      1.80     97.30      0.70      0.00
08:57:43 PM     all      0.00      0.00      0.80     99.10      0.10      0.00
08:57:48 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
08:57:53 PM     all      0.10      0.00      0.50     99.40      0.00      0.00
08:57:58 PM     all      0.00      0.00      0.60     99.20      0.20      0.00
08:58:03 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
08:58:08 PM     all      0.00      0.00      0.60     99.20      0.20      0.00
08:58:13 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:58:18 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:58:23 PM     all      0.10      0.00      1.80     97.29      0.80      0.00
08:58:29 PM     all      0.20      0.00      1.80     97.50      0.50      0.00
08:58:34 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
08:58:39 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:58:44 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
08:58:49 PM     all      0.20      0.00      1.40     97.90      0.50      0.00
08:58:54 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:58:59 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
08:59:04 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
08:59:09 PM     all      0.20      0.00      1.20     98.30      0.30      0.00
08:59:14 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:59:19 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
08:59:24 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
08:59:29 PM     all      0.20      0.00      1.00     98.40      0.40      0.00
08:59:34 PM     all      0.20      0.00      1.60     97.90      0.30      0.00
08:59:39 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
08:59:44 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
08:59:49 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
08:59:54 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
08:59:59 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
09:00:04 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:00:09 PM     all      0.10      0.00      1.50     97.70      0.70      0.00
09:00:14 PM     all      0.10      0.00      1.60     97.30      1.00      0.00
09:00:19 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
09:00:24 PM     all      0.10      0.00      1.40     98.20      0.30      0.00
09:00:29 PM     all      0.20      0.00      1.50     97.71      0.60      0.00
09:00:34 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
09:00:39 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:00:44 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:00:54 PM     all      0.05      0.00      0.74     99.01      0.20      0.00
09:01:04 PM     all      0.10      0.00      1.12     98.49      0.29      0.00
09:01:09 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
09:01:14 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
09:01:19 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
09:01:24 PM     all      0.10      0.00      1.40     98.00      0.50      0.00
09:01:29 PM     all      0.10      0.00      0.80     99.00      0.10      0.00
09:01:39 PM     all      0.10      0.00      1.10     98.46      0.35      0.00
09:01:44 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:01:49 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:01:54 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:01:59 PM     all      0.20      0.00      1.40     97.90      0.50      0.00
09:02:04 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:02:09 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:02:14 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
09:02:19 PM     all      0.00      0.00      1.00     98.80      0.20      0.00
09:02:24 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
09:02:29 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
09:02:34 PM     all      0.20      0.00      1.50     97.81      0.50      0.00
09:02:39 PM     all      0.10      0.00      1.60     97.80      0.50      0.00
09:02:49 PM     all      0.10      0.00      0.77     98.99      0.14      0.00
09:02:54 PM     all      0.10      0.00      1.20     98.20      0.50      0.00
09:02:59 PM     all      0.10      0.00      1.80     97.30      0.80      0.00
09:03:04 PM     all      0.10      0.00      1.50     97.80      0.60      0.00
09:03:09 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:03:14 PM     all      0.20      0.00      1.90     97.40      0.50      0.00
09:03:19 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:03:24 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
09:03:29 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
09:03:34 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:03:39 PM     all      0.10      0.00      1.00     98.50      0.40      0.00
09:03:44 PM     all      0.10      0.00      1.50     97.90      0.50      0.00
09:03:49 PM     all      0.20      0.00      1.00     98.60      0.20      0.00
09:03:54 PM     all      0.00      0.00      0.90     98.80      0.30      0.00
09:03:59 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:04:04 PM     all      0.10      0.00      1.60     97.90      0.40      0.00
09:04:09 PM     all      0.20      0.00      1.80     97.40      0.60      0.00
09:04:14 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:04:19 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:04:24 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
09:04:29 PM     all      0.10      0.00      0.40     99.40      0.10      0.00
09:04:34 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:04:45 PM     all      0.05      0.00      0.70     99.12      0.14      0.00
09:04:50 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
09:04:55 PM     all      0.20      0.00      1.40     98.10      0.30      0.00
09:05:00 PM     all      0.00      0.00      0.80     98.90      0.30      0.00
09:05:05 PM     all      0.20      0.00      1.60     97.80      0.40      0.00
09:05:10 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:05:15 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:05:20 PM     all      0.20      0.00      1.50     97.90      0.40      0.00
09:05:25 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:05:35 PM     all      0.10      0.00      1.08     98.57      0.25      0.00
09:05:40 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
09:05:45 PM     all      0.30      0.00      1.70     97.50      0.50      0.00
09:05:50 PM     all      0.10      0.00      1.40     98.20      0.30      0.00
09:05:55 PM     all      0.10      0.00      1.20     98.00      0.70      0.00
09:06:00 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:06:05 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:06:10 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:06:15 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:06:29 PM     all      0.19      0.00      1.67     97.54      0.60      0.00
09:06:40 PM     all      0.09      0.00      0.87     98.83      0.22      0.00
09:06:55 PM     all      0.07      0.00      0.72     99.05      0.17      0.00
09:07:00 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
09:07:05 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:07:10 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
09:07:15 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:07:20 PM     all      0.20      0.00      1.70     97.60      0.50      0.00
09:07:32 PM     all      0.08      0.00      1.13     98.51      0.28      0.00
09:07:37 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
09:07:42 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
09:07:54 PM     all      0.13      0.00      1.28     98.30      0.30      0.00
09:07:59 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
09:08:04 PM     all      0.00      0.00      0.80     99.10      0.10      0.00
09:08:09 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:08:14 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
09:08:19 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:08:24 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:08:29 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:08:39 PM     all      0.15      0.00      1.32     88.57      0.34      9.62
09:08:44 PM     all      0.20      0.00      1.60     95.00      0.50      2.70
09:08:49 PM     all      0.00      0.00      0.80     99.10      0.10      0.00
09:08:54 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
09:08:59 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
09:09:04 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
09:09:15 PM     all      0.05      0.00      1.07     98.64      0.24      0.00
09:09:20 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
09:09:25 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
09:09:30 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:09:35 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
09:09:40 PM     all      0.10      0.00      1.70     97.70      0.50      0.00
09:09:50 PM     all      0.10      0.00      1.09     98.52      0.30      0.00
09:09:55 PM     all      0.20      0.00      1.00     98.50      0.30      0.00
09:10:00 PM     all      0.10      0.00      1.60     97.90      0.40      0.00
09:10:05 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
09:10:10 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
09:10:15 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
09:10:20 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:10:25 PM     all      0.00      0.00      0.90     98.80      0.30      0.00
09:10:30 PM     all      0.20      0.00      1.40     98.10      0.30      0.00
09:10:35 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:10:40 PM     all      0.10      0.00      0.50     99.30      0.10      0.00
09:10:45 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:10:50 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
09:10:55 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:11:00 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:11:05 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:11:10 PM     all      0.20      0.00      2.69     95.21      1.90      0.00
09:11:15 PM     all      0.20      0.00      1.70     97.50      0.60      0.00
09:11:20 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:11:25 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:11:30 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
09:11:35 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:11:40 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:11:45 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:11:50 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
09:11:55 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
09:12:00 PM     all      0.20      0.00      1.30     98.20      0.30      0.00
09:12:05 PM     all      0.00      0.00      1.10     98.60      0.30      0.00
09:12:10 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:12:15 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:12:20 PM     all      0.10      0.00      1.80     97.30      0.80      0.00
09:12:25 PM     all      0.10      0.00     23.60     52.90     23.40      0.00
09:12:37 PM     all      0.25      0.00      3.34     94.39      2.02      0.00
09:12:42 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
09:12:47 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:12:52 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
09:12:57 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
09:13:02 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
09:13:07 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:13:12 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
09:13:17 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:13:22 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:13:27 PM     all      0.20      0.00      1.70     97.70      0.40      0.00
09:13:32 PM     all      0.20      0.00      1.50     97.80      0.50      0.00
09:13:37 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:13:42 PM     all      0.20      0.00      1.50     97.90      0.40      0.00
09:13:47 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
09:13:52 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:13:57 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
09:14:07 PM     all      0.15      0.00      1.37     98.09      0.39      0.00
09:14:12 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:14:17 PM     all      0.10      0.00      1.70     97.80      0.40      0.00
09:14:22 PM     all      0.10      0.00      0.60     99.00      0.30      0.00
09:14:27 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:14:32 PM     all      0.10      0.00      1.20     98.50      0.20      0.00
09:14:42 PM     all      0.10      0.00      0.88     98.77      0.25      0.00
09:14:47 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:14:52 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:14:57 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
09:15:02 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:15:07 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
09:15:12 PM     all      0.20      0.00      1.10     98.30      0.40      0.00
09:15:17 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:15:22 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:15:27 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:15:32 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
09:15:37 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
09:15:42 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:15:47 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
09:15:52 PM     all      0.00      0.00      0.80     98.80      0.40      0.00
09:15:57 PM     all      0.20      0.00      1.50     97.90      0.40      0.00
09:16:02 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
09:16:07 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
09:16:12 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:16:24 PM     all      0.08      0.00      0.92     98.71      0.29      0.00
09:16:29 PM     all      0.10      0.00      1.50     97.60      0.80      0.00
09:16:34 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
09:16:39 PM     all      0.20      0.00      1.70     97.50      0.40      0.20
09:16:44 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:16:49 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:16:54 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:16:59 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:17:04 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
09:17:09 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:17:14 PM     all      0.20      0.00      1.70     97.50      0.60      0.00
09:17:19 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:17:24 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:17:29 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
09:17:34 PM     all      0.10      0.00      0.50     99.30      0.10      0.00
09:17:39 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:17:44 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:17:49 PM     all      0.00      0.00      0.90     98.80      0.30      0.00
09:17:54 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:17:59 PM     all      0.20      0.00      1.20     98.10      0.50      0.00
09:18:04 PM     all      0.20      0.00      1.90     97.30      0.60      0.00
09:18:09 PM     all      0.10      0.00      1.30     97.90      0.70      0.00
09:18:14 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:18:19 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:18:24 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:18:29 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:18:34 PM     all      0.30      0.00      2.00     97.10      0.60      0.00
09:18:39 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
09:18:44 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:18:49 PM     all      0.20      0.00      1.80     97.50      0.50      0.00
09:18:54 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
09:18:59 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:19:04 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
09:19:09 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:19:14 PM     all      0.20      0.00      1.50     97.80      0.50      0.00
09:19:19 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:19:24 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:19:29 PM     all      0.10      0.00      0.90     98.90      0.10      0.00
09:19:34 PM     all      0.00      0.00      0.80     98.90      0.30      0.00
09:19:39 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:19:44 PM     all      0.10      0.00      1.20     98.50      0.20      0.00
09:19:49 PM     all      0.20      0.00      1.10     98.30      0.40      0.00
09:19:54 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:19:59 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:20:04 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:20:09 PM     all      0.10      0.00      1.20     98.50      0.20      0.00
09:20:14 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
09:20:19 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:20:24 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:20:29 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:20:34 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:20:39 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:20:44 PM     all      0.20      0.00      1.30     98.20      0.30      0.00
09:20:49 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:21:00 PM     all      0.10      0.00      0.92     98.78      0.19      0.00
09:21:05 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:21:10 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
09:21:15 PM     all      0.20      0.00      1.50     98.00      0.30      0.00
09:21:26 PM     all      0.13      0.00      1.28     98.28      0.31      0.00
09:21:31 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:21:36 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:21:41 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
09:21:46 PM     all      0.10      0.00      3.30     94.20      2.40      0.00
09:21:51 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:21:56 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
09:22:01 PM     all      0.10      0.00      0.90     98.90      0.10      0.00
09:22:06 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
09:22:11 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
09:22:16 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
09:22:21 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:22:26 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:22:31 PM     all      0.20      0.00      1.30     98.00      0.50      0.00
09:22:36 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:22:41 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
09:22:46 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
09:22:51 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:22:56 PM     all      0.10      0.00      1.20     92.50      0.40      5.80
09:23:01 PM     all      0.20      0.00      1.60     97.80      0.40      0.00
09:23:06 PM     all      0.00      0.00      1.10     98.60      0.30      0.00
09:23:11 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:23:16 PM     all      0.20      0.00      1.50     97.70      0.60      0.00
09:23:21 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:23:26 PM     all      0.10      0.00      1.40     98.20      0.30      0.00
09:23:31 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:23:36 PM     all      0.10      0.00      0.70     98.90      0.30      0.00
09:23:41 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:23:46 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:23:51 PM     all      0.00      0.00      0.80     93.79      0.20      5.21
09:23:56 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:24:01 PM     all      0.10      0.00      1.00     98.80      0.10      0.00
09:24:06 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:24:11 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:24:16 PM     all      0.10      0.00      2.10     96.40      1.40      0.00
09:24:21 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:24:26 PM     all      0.00      0.00      0.60     94.29      0.00      5.11
09:24:31 PM     all      0.20      0.00      1.20     98.30      0.30      0.00
09:24:36 PM     all      0.00      0.00      0.80     99.10      0.10      0.00
09:24:41 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:24:46 PM     all      0.10      0.00      1.70     93.21      1.00      4.00
09:24:51 PM     all      0.10      0.00      1.00     92.69      0.10      6.11
09:24:56 PM     all      0.10      0.00      1.30     94.41      0.40      3.80
09:25:01 PM     all      0.10      0.00      0.60     97.20      0.20      1.90
09:25:06 PM     all      0.10      0.00      1.40     91.40      0.30      6.80
09:25:11 PM     all      0.10      0.00      1.50     97.60      0.50      0.30
09:25:16 PM     all      0.00      0.00      0.40     98.30      0.10      1.20
09:25:21 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:25:26 PM     all      0.10      0.00      1.20     87.20      0.50     11.00
09:25:31 PM     all      0.10      0.00      1.00     97.70      0.40      0.80
09:25:36 PM     all      0.10      0.00      1.70     97.80      0.40      0.00
09:25:41 PM     all      0.20      0.00      1.30     89.61      0.40      8.49
09:25:46 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:25:51 PM     all      0.10      0.00      1.10     96.50      0.60      1.70
09:25:56 PM     all      0.10      0.00      1.30     97.50      0.50      0.60
09:26:01 PM     all      0.10      0.00      1.40     95.00      0.40      3.10
09:26:06 PM     all      0.10      0.00      1.40     91.72      0.40      6.39
09:26:11 PM     all      0.10      0.00      1.00     95.70      0.20      3.00
09:26:16 PM     all      0.10      0.00      0.90     84.30      0.30     14.40
09:26:21 PM     all      0.10      0.00      1.60     96.30      0.70      1.30
09:26:26 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
09:26:31 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
09:26:36 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
09:26:41 PM     all      0.20      0.00      1.30     98.10      0.30      0.10
09:26:46 PM     all      0.10      0.00      1.00     87.50      0.30     11.10
09:26:51 PM     all      0.10      0.00      1.20     88.60      0.30      9.80
09:26:56 PM     all      0.10      0.00     20.82     58.86     20.22      0.00
09:27:11 PM     all      0.20      0.00      2.36     96.58      0.86      0.00
09:27:22 PM     all      0.09      0.00      0.97     98.66      0.28      0.00
09:27:27 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
09:27:32 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
09:27:37 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
09:27:42 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
09:27:47 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:27:52 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:27:57 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:28:02 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:28:07 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:28:12 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
09:28:22 PM     all      0.10      0.00      1.09     98.51      0.30      0.00
09:28:27 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
09:28:32 PM     all      0.10      0.00      1.70     97.70      0.50      0.00
09:28:37 PM     all      0.20      0.00      2.00     97.20      0.60      0.00
09:28:42 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
09:28:47 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
09:28:52 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:28:57 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
09:29:02 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
09:29:07 PM     all      0.00      0.00      0.80     98.90      0.30      0.00
09:29:12 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
09:29:17 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:29:22 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:29:27 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:29:32 PM     all      0.00      0.00      1.10     98.60      0.30      0.00
09:29:37 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
09:29:42 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:29:47 PM     all      0.00      0.00      1.00     98.70      0.30      0.00
09:29:52 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:29:57 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
09:30:02 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:30:07 PM     all      0.20      0.00      1.00     98.40      0.40      0.00
09:30:18 PM     all      0.14      0.00      1.61     97.75      0.50      0.00
09:30:23 PM     all      0.20      0.00      1.50     97.90      0.40      0.00
09:30:28 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:30:33 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:30:38 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:30:43 PM     all      0.10      0.00      0.50     99.20      0.20      0.00
09:30:48 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:30:53 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
09:30:58 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
09:31:03 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:31:08 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:31:13 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:31:18 PM     all      0.20      0.00      1.60     97.80      0.40      0.00
09:31:23 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:31:28 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:31:33 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:31:38 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
09:31:43 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
09:31:54 PM     all      0.09      0.00      1.22     98.32      0.37      0.00
09:31:59 PM     all      0.20      0.00      2.60     95.60      1.60      0.00
09:32:10 PM     all      0.09      0.00      1.19     98.44      0.28      0.00
09:32:15 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:32:20 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:32:25 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:32:30 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:32:35 PM     all      0.10      0.00      0.70     98.90      0.10      0.20
09:32:40 PM     all      0.20      0.00      1.70     97.00      0.50      0.60
09:32:45 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:32:50 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:32:55 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:33:05 PM     all      0.14      0.00      1.29     98.16      0.41      0.00
09:33:16 PM     all      0.10      0.00      0.87     98.84      0.19      0.00
09:33:21 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:33:33 PM     all      0.08      0.00      1.05     98.54      0.32      0.00
09:33:38 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:33:43 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
09:33:48 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:33:53 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:33:58 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
09:34:03 PM     all      0.20      0.00      1.30     98.20      0.30      0.00
09:34:08 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:34:13 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
09:34:18 PM     all      0.00      0.00      0.80     98.90      0.30      0.00
09:34:23 PM     all      0.10      0.00      0.90     98.90      0.10      0.00
09:34:28 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:34:33 PM     all      0.10      0.00      1.60     97.70      0.60      0.00
09:34:45 PM     all      0.08      0.00      6.28     88.07      5.57      0.00
09:34:57 PM     all      0.18      0.00      4.57     91.69      3.56      0.00
09:35:02 PM     all      0.20      0.00      1.60     97.80      0.40      0.00
09:35:07 PM     all      0.20      0.00      1.50     97.80      0.50      0.00
09:35:12 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:35:17 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
09:35:22 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
09:35:27 PM     all      0.20      0.00      1.00     98.50      0.30      0.00
09:35:32 PM     all      0.10      0.00      0.80     99.00      0.10      0.00
09:35:37 PM     all      0.00      0.00      0.60     99.20      0.20      0.00
09:35:42 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:35:47 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
09:35:52 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:35:57 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
09:36:02 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:36:07 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
09:36:12 PM     all      0.20      0.00      1.50     97.80      0.50      0.00
09:36:17 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:36:22 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
09:36:27 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
09:36:32 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:36:37 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
09:36:42 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:36:47 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:36:52 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:37:02 PM     all      0.10      0.00      1.18     98.37      0.34      0.00
09:37:07 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:37:12 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
09:37:17 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:37:22 PM     all      0.10      0.00      1.50     98.00      0.40      0.00
09:37:27 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:37:32 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
09:37:37 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:37:42 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
09:37:47 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
09:37:52 PM     all      0.20      0.00      3.80     93.11      2.90      0.00
09:37:57 PM     all      0.10      0.00      1.40     98.00      0.50      0.00
09:38:02 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:38:07 PM     all      0.10      0.00      2.00     96.90      1.00      0.00
09:38:12 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
09:38:17 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:38:22 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
09:38:27 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
09:38:32 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:38:37 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:38:42 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:38:47 PM     all      0.10      0.00      1.00     98.50      0.40      0.00
09:38:52 PM     all      0.10      0.00      1.50     97.60      0.80      0.00
09:38:57 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:39:02 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:39:07 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:39:12 PM     all      0.10      0.00      1.70     97.70      0.50      0.00
09:39:17 PM     all      0.20      0.00      1.50     97.90      0.40      0.00
09:39:22 PM     all      0.00      0.00      0.80     98.90      0.30      0.00
09:39:27 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
09:39:32 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:39:37 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
09:39:42 PM     all      0.10      0.00      1.40     98.20      0.30      0.00
09:39:47 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:39:52 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
09:39:57 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
09:40:02 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:40:07 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:40:12 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:40:17 PM     all      0.30      0.00      2.10     96.90      0.70      0.00
09:40:22 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
09:40:27 PM     all      0.20      0.00      1.20     98.30      0.30      0.00
09:40:32 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:40:37 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
09:40:42 PM     all      0.20      0.00      1.20     98.30      0.30      0.00
09:40:47 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
09:40:52 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
09:40:57 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
09:41:02 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:41:07 PM     all      0.20      0.00      1.40     97.90      0.50      0.00
09:41:17 PM     all      0.10      0.00      1.11     98.56      0.24      0.00
09:41:22 PM     all      0.20      0.00      1.30     98.20      0.30      0.00
09:41:27 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
09:41:32 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:41:37 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:41:42 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:41:52 PM     all      0.15      0.00      1.22     98.33      0.29      0.00
09:41:57 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:42:02 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:42:07 PM     all      0.10      0.00      0.80     99.00      0.10      0.00
09:42:12 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:42:17 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
09:42:22 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
09:42:27 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:42:32 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:42:37 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
09:42:42 PM     all      0.00      0.00      0.80     98.90      0.30      0.00
09:42:47 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:42:52 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:42:57 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
09:43:02 PM     all      0.20      0.00      1.00     98.50      0.30      0.00
09:43:07 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
09:43:12 PM     all      0.00      0.00      0.40     99.50      0.10      0.00
09:43:17 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
09:43:22 PM     all      0.00      0.00      1.20     98.40      0.40      0.00
09:43:27 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
09:43:32 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
09:43:37 PM     all      0.10      0.00      2.60     95.40      1.90      0.00
09:43:42 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
09:43:47 PM     all      0.20      0.00      0.90     98.60      0.30      0.00
09:43:52 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:43:57 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:44:02 PM     all      0.10      0.00      1.40     98.00      0.50      0.00
09:44:13 PM     all      0.10      0.00      0.84     98.81      0.25      0.00
09:44:18 PM     all      0.10      0.00      1.00     98.50      0.40      0.00
09:44:28 PM     all      0.10      0.00      1.10     98.47      0.34      0.00
09:44:33 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:44:38 PM     all      0.20      0.00      1.20     98.30      0.30      0.00
09:44:43 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:44:48 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:44:53 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:44:58 PM     all      0.20      0.00      1.20     98.30      0.30      0.00
09:45:03 PM     all      0.00      0.00      1.20     98.40      0.40      0.00
09:45:08 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:45:13 PM     all      0.10      0.00      0.50     99.30      0.10      0.00
09:45:18 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
09:45:23 PM     all      0.10      0.00      1.30     98.40      0.20      0.00
09:45:28 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:45:33 PM     all      0.00      0.00      0.90     99.00      0.10      0.00
09:45:38 PM     all      0.10      0.00      3.19     94.81      1.90      0.00
09:45:43 PM     all      0.10      0.00      0.80     99.00      0.10      0.00
09:45:48 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
09:45:53 PM     all      0.00      0.00     39.76     19.28     39.66      1.30
09:46:19 PM     all      0.23      0.00      3.60     93.75      2.41      0.00
09:46:24 PM     all      0.10      0.00      0.80     99.00      0.10      0.00
09:46:29 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
09:46:34 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:46:39 PM     all      0.20      0.00      1.60     97.80      0.40      0.00
09:46:44 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:46:49 PM     all      0.20      0.00      0.90     98.70      0.20      0.00
09:46:54 PM     all      0.10      0.00      0.90     98.90      0.10      0.00
09:46:59 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:47:10 PM     all      0.18      0.00      1.98     97.10      0.74      0.00
09:47:22 PM     all      0.08      0.00      0.68     99.17      0.08      0.00
09:47:27 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:47:32 PM     all      0.00      0.00      0.80     98.90      0.30      0.00
09:47:37 PM     all      0.10      0.00      0.60     99.30      0.00      0.00
09:47:42 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
09:47:47 PM     all      0.10      0.00      0.50     99.40      0.00      0.00
09:47:57 PM     all      0.05      0.00      0.77     98.94      0.24      0.00
09:48:02 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
09:48:07 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:48:12 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:48:17 PM     all      0.10      0.00      0.80     99.00      0.10      0.00
09:48:22 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
09:48:33 PM     all      0.18      0.00      1.59     97.81      0.41      0.00
09:48:38 PM     all      0.20      0.00      1.90     97.30      0.60      0.00
09:48:43 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:48:54 PM     all      0.09      0.00      1.06     98.57      0.28      0.00
09:48:59 PM     all      0.20      0.00      1.40     98.00      0.40      0.00
09:49:04 PM     all      0.20      0.00      1.30     98.20      0.30      0.00
09:49:17 PM     all      0.16      0.00      1.49     97.88      0.47      0.00
09:49:22 PM     all      0.00      0.00      1.00     98.80      0.20      0.00
09:49:27 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:49:32 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
09:49:37 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
09:49:42 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
09:49:47 PM     all      0.00      0.00      0.90     98.90      0.20      0.00
09:49:52 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:49:57 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:50:02 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:50:07 PM     all      0.10      0.00      0.50     99.30      0.10      0.00
09:50:12 PM     all      0.00      0.00      0.90     98.90      0.20      0.00
09:50:17 PM     all      0.20      0.00      1.20     98.20      0.40      0.00
09:50:22 PM     all      0.00      0.00      0.80     99.10      0.10      0.00
09:50:27 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
09:50:32 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:50:37 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:50:42 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:50:47 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:50:52 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:50:57 PM     all      0.00      0.00      0.90     98.80      0.30      0.00
09:51:02 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:51:07 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
09:51:12 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:51:17 PM     all      0.10      0.00      0.50     99.20      0.20      0.00
09:51:22 PM     all      0.10      0.00      1.90     97.50      0.50      0.00
09:51:27 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
09:51:32 PM     all      0.10      0.00      1.40     98.20      0.30      0.00
09:51:37 PM     all      0.10      0.00      1.60     97.30      1.00      0.00
09:51:42 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
09:51:47 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:51:52 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
09:52:04 PM     all      0.09      0.00      1.09     98.47      0.35      0.00
09:52:09 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:52:14 PM     all      0.00      0.00      0.80     98.80      0.40      0.00
09:52:19 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:52:24 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:52:29 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:52:34 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:52:39 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:52:44 PM     all      0.10      0.00      1.00     98.50      0.40      0.00
09:52:49 PM     all      0.10      0.00      1.50     97.80      0.60      0.00
09:52:54 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:52:59 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:53:04 PM     all      0.20      0.00      2.00     97.20      0.60      0.00
09:53:14 PM     all      0.10      0.00      0.92     98.69      0.29      0.00
09:53:19 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
09:53:24 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
09:53:29 PM     all      0.10      0.00      1.50     97.90      0.50      0.00
09:53:34 PM     all      0.20      0.00      1.30     98.00      0.50      0.00
09:53:39 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
09:53:44 PM     all      0.10      0.00      0.50     99.30      0.10      0.00
09:53:49 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:53:54 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:53:59 PM     all      0.00      0.00      0.80     99.10      0.10      0.00
09:54:04 PM     all      0.20      0.00      1.60     97.80      0.40      0.00
09:54:09 PM     all      0.20      0.00      1.20     96.20      0.40      2.00
09:54:14 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:54:26 PM     all      0.08      0.00      1.19     98.26      0.47      0.00
09:54:31 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
09:54:41 PM     all      0.09      0.00      1.04     98.59      0.28      0.00
09:54:46 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:55:03 PM     all      0.24      0.00      1.02     98.47      0.27      0.00
09:55:16 PM     all      0.37      0.00      1.09     98.24      0.30      0.00
09:55:29 PM     all      0.43      0.00      1.01     98.25      0.31      0.00
09:55:43 PM     all      0.42      0.00      1.13     98.16      0.28      0.00
09:55:53 PM     all      0.20      0.00      1.18     98.23      0.39      0.00
09:55:58 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:56:03 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:56:15 PM     all      0.14      0.00      1.13     98.46      0.27      0.00
09:56:20 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:56:25 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
09:56:30 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
09:56:42 PM     all      0.12      0.00      1.03     98.58      0.28      0.00
09:56:47 PM     all      0.20      0.00      1.50     97.80      0.50      0.00
09:56:52 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:56:57 PM     all      0.10      0.00      1.50     97.90      0.50      0.00
09:57:02 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:57:07 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
09:57:17 PM     all      0.15      0.00      1.27     98.19      0.39      0.00
09:57:22 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
09:57:27 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
09:57:32 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:57:37 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
09:57:42 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
09:57:52 PM     all      0.10      0.00      1.05     98.60      0.25      0.00
09:57:57 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
09:58:09 PM     all      0.09      0.00      0.93     98.76      0.22      0.00
09:58:14 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
09:58:19 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
09:58:29 PM     all      0.10      0.00      0.93     97.31      0.24      1.42
09:58:34 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:58:39 PM     all      0.20      0.00      1.60     97.90      0.30      0.00
09:58:44 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
09:58:49 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
09:58:54 PM     all      0.10      0.00      0.80     98.80      0.30      0.00
09:58:59 PM     all      0.20      0.00      1.60     97.80      0.40      0.00
09:59:04 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
09:59:09 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
09:59:14 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
09:59:19 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:59:24 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
09:59:29 PM     all      0.10      0.00      0.50     99.30      0.10      0.00
09:59:34 PM     all      0.00      0.00      2.40     95.70      1.90      0.00
09:59:39 PM     all      0.20      0.00      1.40     98.10      0.30      0.00
09:59:44 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
09:59:49 PM     all      0.10      0.00      1.00     98.50      0.40      0.00
09:59:54 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
09:59:59 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
10:00:04 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
10:00:15 PM     all      0.13      0.00      1.36     98.16      0.35      0.00
10:00:20 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:00:25 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
10:00:30 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
10:00:41 PM     all      0.15      0.00      1.12     98.44      0.29      0.00
10:00:46 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
10:00:51 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:00:56 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
10:01:01 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
10:01:06 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
10:01:11 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
10:01:16 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
10:01:21 PM     all      0.20      0.00      1.60     97.70      0.50      0.00
10:01:26 PM     all      0.10      0.00      1.20     98.20      0.50      0.00
10:01:31 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
10:01:36 PM     all      0.00      0.00      0.90     98.90      0.20      0.00
10:01:41 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
10:01:46 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
10:01:51 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
10:01:56 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
10:02:01 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
10:02:06 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
10:02:11 PM     all      0.20      0.00      1.80     97.50      0.50      0.00
10:02:16 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
10:02:21 PM     all      0.20      0.00      1.10     98.30      0.40      0.00
10:02:26 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
10:02:31 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
10:02:41 PM     all      0.10      0.00      1.06     98.60      0.24      0.00
10:02:46 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
10:02:51 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
10:02:56 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
10:03:01 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
10:03:06 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
10:03:11 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:03:16 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:03:26 PM     all      0.10      0.00      0.91     98.70      0.29      0.00
10:03:31 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
10:03:36 PM     all      0.10      0.00      1.60     97.80      0.50      0.00
10:03:50 PM     all      0.11      0.00      1.14     98.45      0.30      0.00
10:03:55 PM     all      0.20      0.00      1.30     97.90      0.60      0.00
10:04:00 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
10:04:05 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
10:04:10 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
10:04:15 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
10:04:20 PM     all      0.10      0.00      1.60     97.90      0.40      0.00
10:04:25 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
10:04:30 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
10:04:35 PM     all      0.10      0.00      1.40     98.10      0.40      0.00
10:04:40 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
10:04:45 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
10:04:50 PM     all      0.10      0.00      1.10     96.50      0.20      2.10
10:04:55 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
10:05:00 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
10:05:05 PM     all      0.00      0.00      1.00     98.70      0.30      0.00
10:05:10 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
10:05:20 PM     all      0.05      0.00      0.76     98.95      0.24      0.00
10:05:25 PM     all      0.10      0.00      2.20     96.30      1.40      0.00
10:05:30 PM     all      0.10      0.00      1.10     98.60      0.20      0.00
10:05:35 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
10:05:40 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
10:05:45 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
10:05:50 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:05:55 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
10:06:00 PM     all      0.10      0.00      1.10     98.30      0.50      0.00
10:06:05 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
10:06:10 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
10:06:15 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:06:20 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:06:31 PM     all      0.09      0.00      1.10     98.41      0.40      0.00
10:06:36 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
10:06:41 PM     all      0.00      0.00      1.00     98.70      0.30      0.00
10:06:46 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:06:51 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
10:06:56 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
10:07:01 PM     all      0.10      0.00      0.40     99.40      0.10      0.00
10:07:06 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
10:07:18 PM     all      0.04      0.00      0.77     99.02      0.17      0.00
10:07:23 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:07:28 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:07:33 PM     all      0.10      0.00      0.80     99.00      0.10      0.00
10:07:38 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
10:07:43 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
10:07:48 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
10:07:53 PM     all      0.10      0.00      1.50     97.90      0.50      0.00
10:07:58 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
10:08:08 PM     all      0.15      0.00      1.19     98.41      0.25      0.00
10:08:13 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
10:08:18 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
10:08:23 PM     all      0.10      0.00      0.80     99.00      0.10      0.00
10:08:28 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
10:08:33 PM     all      0.10      0.00      1.20     91.51      0.30      6.89
10:08:38 PM     all      0.10      0.00     15.38     56.04     14.79     13.69
10:08:50 PM     all      0.13      0.00     11.86     76.85     11.16      0.00
10:09:01 PM     all      0.32      0.00      2.95     95.62      1.11      0.00
10:09:15 PM     all      0.07      0.00      0.84     98.86      0.23      0.00
10:09:20 PM     all      0.20      0.00      1.50     98.00      0.30      0.00
10:09:31 PM     all      0.15      0.00      1.36     98.16      0.34      0.00
10:09:44 PM     all      0.12      0.00      1.07     98.50      0.31      0.00
10:09:49 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
10:09:54 PM     all      0.30      0.00      2.00     96.80      0.90      0.00
10:10:05 PM     all      0.05      0.00      1.19     98.53      0.23      0.00
10:10:10 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
10:10:15 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
10:10:20 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
10:10:25 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
10:10:30 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
10:10:35 PM     all      0.10      0.00      0.40     99.50      0.00      0.00
10:10:40 PM     all      0.00      0.00      0.90     98.90      0.20      0.00
10:10:45 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
10:10:50 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
10:10:55 PM     all      0.00      0.00      1.00     98.80      0.20      0.00
10:11:00 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:11:05 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
10:11:10 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
10:11:15 PM     all      0.20      0.00      1.50     97.90      0.40      0.00
10:11:20 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
10:11:25 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
10:11:30 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
10:11:35 PM     all      0.20      0.00      1.50     97.90      0.40      0.00
10:11:40 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
10:11:45 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
10:11:50 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
10:12:00 PM     all      0.10      0.00      1.03     98.58      0.29      0.00
10:12:05 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
10:12:10 PM     all      0.00      0.00      0.60     99.20      0.20      0.00
10:12:15 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
10:12:20 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
10:12:25 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
10:12:30 PM     all      0.10      0.00      0.40     99.40      0.10      0.00
10:12:35 PM     all      0.00      0.00      0.60     99.20      0.20      0.00
10:12:40 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
10:12:45 PM     all      0.20      0.00      1.20     98.30      0.30      0.00
10:12:50 PM     all      0.00      0.00      0.90     98.80      0.30      0.00
10:12:55 PM     all      0.10      0.00      0.60     99.20      0.10      0.00
10:13:00 PM     all      0.00      0.00      0.50     99.40      0.10      0.00
10:13:05 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
10:13:10 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
10:13:15 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
10:13:20 PM     all      0.10      0.00      0.80     98.90      0.20      0.00
10:13:25 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
10:13:30 PM     all      0.00      0.00      0.90     98.80      0.30      0.00
10:13:35 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
10:13:40 PM     all      0.20      0.00      1.60     97.70      0.50      0.00
10:13:45 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
10:13:50 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
10:13:55 PM     all      0.00      0.00      0.90     98.90      0.20      0.00
10:14:00 PM     all      0.20      0.00      1.70     97.70      0.40      0.00
10:14:05 PM     all      0.00      0.00      0.90     98.80      0.30      0.00
10:14:10 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
10:14:15 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
10:14:20 PM     all      0.00      0.00      0.90     98.90      0.20      0.00
10:14:25 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
10:14:30 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
10:14:35 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
10:14:40 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
10:14:45 PM     all      0.20      0.00      1.50     97.90      0.40      0.00
10:14:57 PM     all      0.17      0.00      1.52     97.89      0.42      0.00
10:15:02 PM     all      0.20      0.00      1.80     97.30      0.70      0.00
10:15:15 PM     all      0.11      0.00      1.21     98.34      0.34      0.00
10:15:20 PM     all      0.10      0.00      1.30     97.80      0.80      0.00
10:15:25 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
10:15:30 PM     all      0.10      0.00      1.50     97.90      0.50      0.00
10:15:35 PM     all      0.20      0.00      1.30     98.20      0.30      0.00
10:15:40 PM     all      0.00      0.00      0.90     98.90      0.20      0.00
10:15:45 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
10:15:50 PM     all      0.20      0.00      1.90     97.30      0.60      0.00
10:15:55 PM     all      0.00      0.00      0.70     99.20      0.10      0.00
10:16:00 PM     all      0.20      0.00      1.10     98.40      0.30      0.00
10:16:05 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
10:16:10 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
10:16:15 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
10:16:20 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
10:16:25 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:16:30 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:16:35 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:16:40 PM     all      0.10      0.00      0.90     98.80      0.20      0.00
10:16:45 PM     all      0.00      0.00      0.80     99.00      0.20      0.00
10:16:50 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
10:16:55 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:17:00 PM     all      0.10      0.00      0.70     99.00      0.20      0.00
10:17:05 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
10:17:10 PM     all      0.00      0.00      0.70     99.10      0.20      0.00
10:17:15 PM     all      0.10      0.00      1.30     98.20      0.40      0.00
10:17:20 PM     all      0.10      0.00      1.30     98.00      0.60      0.00
10:17:25 PM     all      0.20      0.00      1.60     97.70      0.50      0.00
10:17:30 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
10:17:35 PM     all      0.10      0.00      0.60     99.10      0.20      0.00
10:17:40 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:17:45 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
10:17:50 PM     all      0.00      0.00      0.90     98.80      0.30      0.00
10:17:55 PM     all      0.20      0.00      1.70     97.50      0.60      0.00
10:18:00 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
10:18:05 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
10:18:10 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
10:18:15 PM     all      0.10      0.00      1.00     98.60      0.30      0.00
10:18:20 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
10:18:25 PM     all      0.10      0.00      1.20     98.20      0.50      0.00
10:18:30 PM     all      0.20      0.00      1.30     98.20      0.30      0.00
10:18:35 PM     all      0.00      0.00      1.10     98.50      0.40      0.00
10:18:40 PM     all      0.20      0.00      1.30     98.20      0.30      0.00
10:18:45 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
10:18:50 PM     all      0.20      0.00      1.30     98.20      0.30      0.00
10:18:55 PM     all      0.10      0.00      1.30     98.10      0.50      0.00
10:19:09 PM     all      0.11      0.00      1.10     98.58      0.22      0.00
10:19:14 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:19:19 PM     all      0.00      0.00      0.90     98.90      0.20      0.00
10:19:24 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
10:19:29 PM     all      0.20      0.00      1.40     98.10      0.30      0.00
10:19:34 PM     all      0.10      0.00      1.30     98.30      0.30      0.00
10:19:45 PM     all      0.09      0.00      1.10     98.47      0.35      0.00
10:19:50 PM     all      0.20      0.00      1.30     98.20      0.30      0.00
10:20:02 PM     all      0.09      0.00      1.01     98.64      0.26      0.00
10:20:07 PM     all      0.10      0.00      1.20     98.30      0.40      0.00
10:20:12 PM     all      0.10      0.00      0.70     99.10      0.10      0.00
10:20:22 PM     all      0.10      0.00      0.86     98.76      0.29      0.00
10:20:27 PM     all      0.10      0.00      1.50     97.90      0.50      0.00
10:20:32 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:20:37 PM     all      0.20      0.00      1.30     98.10      0.40      0.00
10:20:42 PM     all      0.10      0.00      1.20     98.40      0.30      0.00
10:20:47 PM     all      0.10      0.00      1.00     98.70      0.20      0.00
10:20:52 PM     all      0.10      0.00      0.90     98.70      0.30      0.00
10:20:57 PM     all      0.00      0.00      0.60     99.30      0.10      0.00
10:21:02 PM     all      0.10      0.00      1.10     98.40      0.40      0.00
10:21:07 PM     all      0.10      0.00      1.10     98.50      0.30      0.00
10:21:18 PM     all      0.13      0.00      1.34     98.16      0.36  

--------------070604070005010500040106--
