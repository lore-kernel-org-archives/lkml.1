Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYIJVAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYIJVAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYIJVAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:00:19 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2167 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYIJVAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:00:14 -0400
Message-ID: <48C83546.7090206@xs4all.nl>
Date: Wed, 10 Sep 2008 22:59:50 +0200
From: Rambaldi <rambaldi@xs4all.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080815)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc6 xen soft lockup
References: <48C7BB39.6090700@xs4all.nl> <48C7FB83.8080904@goop.org> <48C81537.8080409@xs4all.nl> <48C81F12.9040208@goop.org>
In-Reply-To: <48C81F12.9040208@goop.org>
Content-Type: multipart/mixed;
 boundary="------------080605090207070701020109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080605090207070701020109
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Jeremy Fitzhardinge wrote:
> Rambaldi wrote:
>> The machine has two Intel(R) Xeon(R) E5420's so that gives a total of
>> 8 cpu's
>> During the time of the lockup the cpu load, as measured with cacti,
>> was about 4%
>> with a increase to 15% at the time the BUG was triggered. So I would
>> say mostly idle
>> but not very idle.
> 
> So that's the cpu load within the domain?  How about the overall system
> load?  What other domains are running?
> 
Yes I was talking about the load in the domU.
The overall load of the system was idle. Cacti, monitoring dom0, showed no signs of
network or disk activity. The cpu load for the dom0 was also idle.
The system hosts a total of 6 domU's. I have no cpu load measurements for the other domU's
but judging from the lack of disk and network activity and constant cpu temperature readings
I would say that there cpu load was also mostly idle.


>>> Did anything fail or misbehave?
>> No nothing failed or misbehaved (as far as I could tell)
>>
>> With dynticks I guess you mean: CONFIG_NO_HZ ; this option is not set.
> 
> (In general its a good idea to set it for virtual machines, to avoid
> spuriously scheduling vcpus.)
> 
Ok, I will change that.

>> I have attached my .config. I have also attached the output of
>> (date ; cat /proc/interrupts ; sleep 10 ; date ;  cat /proc/interrupts
>> )> /tmp/interrupts
>> to give an impression about the number of interrupts after 11:30 hours
>> of uptime.
> 
> Well, there were 1001 interrupts on cpu 1 in that interval, which shows
> that the timer interrupts are going at full rate on the idle cpu.
> 
> I'm a bit confused.  I'm not sure what would trigger a lockup at that
> point, unless it really stopped taking interrupts for a while. 
> Unfortunately the RIP and backtrace are not particularly helpful.  I'm
> assuming the message is spurious, and indicates some other kind of
> timekeeping bug.
> 
>> Any other info that you need?
> 
> Full dmesg output, for completeness.
> 
>     J
> 
dmesg output attached.

thanks for looking into it.

R


--------------080605090207070701020109
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg"

Linux version 2.6.27-rc6 (root@localhost) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1)) #2 SMP Wed Sep 10 08:45:39 CEST 2008
Command line: root=/dev/xvda1 ro xencons=hvc0  xen_fbfront.video=4,1152,864
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 Xen: 0000000000000000 - 00000000000a0000 (usable)
 Xen: 00000000000a0000 - 0000000000100000 (reserved)
 Xen: 0000000000100000 - 00000000005f0000 (usable)
 Xen: 00000000005f0000 - 0000000000d7b000 (reserved)
 Xen: 0000000000d7b000 - 00000000f0f00000 (usable)
last_pfn = 0xf0f00 max_arch_pfn = 0x3ffffffff
init_memory_mapping
 0000000000 - 00f0e00000 page 4k
 00f0e00000 - 00f0f00000 page 4k
kernel direct mapping tables up to f0f00000 @ d86000-1513000
last_map_addr: f0f00000 end: f0f00000
DMI not present or invalid.
(5 early reservations) ==> bootmem [0000000000 - 00f0f00000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000d7b000 - 0000d86000]   XEN PAGETABLES ==> [0000d7b000 - 0000d86000]
  #3 [0000200000 - 00005ef234]    TEXT DATA BSS ==> [0000200000 - 00005ef234]
  #4 [0000d86000 - 0001505000]          PGTABLE ==> [0000d86000 - 0001505000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x000000a0
    0: 0x00000100 -> 0x000005f0
    0: 0x00000d7b -> 0x000f0f00
On node 0 totalpages: 984853
  DMA zone: 992 pages, LIFO batch:0
  DMA32 zone: 969347 pages, LIFO batch:31
No local APIC present
Allocating PCI resources starting at f1000000 (gap: f0f00000:f100000)
PERCPU: Allocating 50400 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 8, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 970339
Kernel command line: root=/dev/xvda1 ro xencons=hvc0  xen_fbfront.video=4,1152,864
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Detected 2500.000 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
console [hvc0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Memory: 3864692k/3947520k available (2093k kernel code, 74256k reserved, 948k data, 324k init)
CPA: page pool initialized 1 of 1 pages preallocated
Xen: using vcpuop timer interface
installing Xen timer for CPU 0
Calibrating delay loop (skipped), value calculated using timer frequency.. 5000.00 BogoMIPS (lpj=25000000)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Freeing SMP alternatives: 26k freed
cpu 0 spinlock event irq 1
installing Xen timer for CPU 1
cpu 1 spinlock event irq 7
Initializing CPU#1
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
installing Xen timer for CPU 2
cpu 2 spinlock event irq 13
Initializing CPU#2
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
installing Xen timer for CPU 3
cpu 3 spinlock event irq 19
Initializing CPU#3
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
installing Xen timer for CPU 4
cpu 4 spinlock event irq 25
Initializing CPU#4
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
installing Xen timer for CPU 5
cpu 5 spinlock event irq 31
Initializing CPU#5
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
installing Xen timer for CPU 6
cpu 6 spinlock event irq 37
Initializing CPU#6
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
installing Xen timer for CPU 7
cpu 7 spinlock event irq 43
Initializing CPU#7
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Brought up 8 CPUs
CPU0 attaching sched-domain:
 domain 0: span 0-7 level MC
  groups: 0 1 2 3 4 5 6 7
CPU1 attaching sched-domain:
 domain 0: span 0-7 level MC
  groups: 1 2 3 4 5 6 7 0
CPU2 attaching sched-domain:
 domain 0: span 0-7 level MC
  groups: 2 3 4 5 6 7 0 1
CPU3 attaching sched-domain:
 domain 0: span 0-7 level MC
  groups: 3 4 5 6 7 0 1 2
CPU4 attaching sched-domain:
 domain 0: span 0-7 level MC
  groups: 4 5 6 7 0 1 2 3
CPU5 attaching sched-domain:
 domain 0: span 0-7 level MC
  groups: 5 6 7 0 1 2 3 4
CPU6 attaching sched-domain:
 domain 0: span 0-7 level MC
  groups: 6 7 0 1 2 3 4 5
CPU7 attaching sched-domain:
 domain 0: span 0-7 level MC
  groups: 7 0 1 2 3 4 5 6
net_namespace: 1440 bytes
Booting paravirtualized kernel on Xen
Xen version: 3.3.0 (preserve-AD)
xor: automatically using best checksumming function: generic_sse
   generic_sse:  2516.400 MB/sec
xor: using function: generic_sse (2516.400 MB/sec)
Grant table initialized
NET: Registered protocol family 16
PCI: Fatal: No config space access function found
xen_balloon: Initialising balloon driver.
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: System does not support PCI
PCI: System does not support PCI
PCI-GART: No AMD northbridge found.
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
msgmni has been set to 7710
async_tx: api initialized (sync-only)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Console: switching to colour frame buffer device 144x54
console [tty0] enabled
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
loop: module loaded
Initialising Xen virtual ethernet driver.
blkfront: xvda: barriers enabled
 xvda:<4>Driver 'sd' needs updating - please use bus_type methods
i8042.c: No controller found.
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input0
input: Xen Virtual Keyboard as /class/input/input1
 xvda1 xvda2
blkfront: xvdb: barriers enabled
 xvdb: unknown partition table
input: Xen Virtual Pointer as /class/input/input2
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
raid6: int64x1   2279 MB/s
raid6: int64x2   2728 MB/s
raid6: int64x4   2676 MB/s
raid6: int64x8   1801 MB/s
raid6: sse2x1    2776 MB/s
raid6: sse2x2    5287 MB/s
raid6: sse2x4    6080 MB/s
raid6: using algorithm sse2x4 (6080 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
TCP cubic registered
NET: Registered protocol family 17
IO APIC resources could be not be allocated.
XENBUS: Device with no driver: device/console/0
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 324k freed
EXT3 FS on xvda1, internal journal
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
tunl0: Disabled Privacy Extensions
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: dm-2: found reiserfs format "3.6" with standard journal
ReiserFS: dm-2: using ordered data mode
ReiserFS: dm-2: journal params: device dm-2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-2: checking transaction log (dm-2)
ReiserFS: dm-2: Using r5 hash to sort names
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Adding 8388600k swap on /dev/mapper/vghome-swap.  Priority:-1 extents:1 across:8388600k
process `sysctl' is using deprecated sysctl (syscall) net.ipv6.neigh.default.base_reachable_time; Use net.ipv6.neigh.default.base_reachable_time_ms instead.
eth0: no IPv6 routers present
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
eth1: no IPv6 routers present
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
warning: `asterisk' uses 32-bit capabilities (legacy support in use)
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
sixxs: Disabled Privacy Extensions
linksys: Disabled Privacy Extensions
BUG: soft lockup - CPU#1 stuck for 4125s! [swapper:0]
Modules linked in: sit ts_bm xt_string ipt_LOG xt_limit iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 ip_tables nf_conntrack_ipv6 xt_state nf_conntrack xt_tcpudp ip6table_filter ip6_tables x_tables usbcore nfsd lockd auth_rpcgss sunrpc exportfs reiserfs ipv6
CPU 1:
Modules linked in: sit ts_bm xt_string ipt_LOG xt_limit iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 ip_tables nf_conntrack_ipv6 xt_state nf_conntrack xt_tcpudp ip6table_filter ip6_tables x_tables usbcore nfsd lockd auth_rpcgss sunrpc exportfs reiserfs ipv6
Pid: 0, comm: swapper Not tainted 2.6.27-rc6 #2
RIP: e030:[<ffffffff802093aa>]  [<ffffffff802093aa>] _stext+0x3aa/0x1000
RSP: e02b:ffff8800f0869f28  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff802093aa
RDX: ffff8800f0868000 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff880001542478
R10: ffff8800f0a27e90 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fe2c6a8a710(0000) GS:ffff8800f084cec0(0000) knlGS:0000000000000000
CS:  e033 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 00007fe2c6aab000 CR3: 00000000cc292000 CR4: 0000000000002620
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff803f9a39>] unix_poll+0x0/0xa4
 [<ffffffff8020a533>] xen_safe_halt+0xc/0x15
 [<ffffffff8020b953>] xen_idle+0x33/0x48
 [<ffffffff8020e883>] cpu_idle+0x45/0x63

sixxs: Disabled Privacy Extensions


--------------080605090207070701020109--
