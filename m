Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZCTL3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZCTL3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 07:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZCTL25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 07:28:57 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43854 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbZCTL2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 07:28:55 -0400
Message-ID: <49C37DF1.30806@monstr.eu>
Date: Fri, 20 Mar 2009 12:28:49 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, john.williams@petalogix.com,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu> <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu> <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu> <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu> <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu> <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu> <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu> <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu> <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain> <49C2AB09.9040300@monstr.eu> <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain> <49C36149.9000703@monstr.eu> <alpine.LFD.2.00.0903201052340.29264@localhost.localdomain> <49C371F5.5010100@monstr.eu> <alpine.LFD.2.00.0903201142300.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903201142300.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 20 Mar 2009, Michal Simek wrote:
>> Why is my .resolution: 10000000 nsecs? It seems to me weird.
> 
> Well. The resulution there is the granularity which the kernel uses to
> expire application timers. Once the kernel switches to high resolution
> mode it sets the granularity to 1ns.
> 
> To get high resolution mode you need two things:
> 
> 1) a suitable clocksource - which needs to have the
> CLOCK_SOURCE_IS_CONTINUOUS flag set

> 
> 2) a clock event device which has CLOCK_EVT_FEAT_PERIODIC flag set.

You meant ONESHOT feature, right?

> 3) CONFIG_HIGH_RES_TIMERS=y


Below are kernel logs which I am getting.

Thanks,
Michal


> Thanks,
> 
> 	tglx


Here is .config fragment
#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y




Only Periodic mode

early_printk_console is enabled at 0x84000000
Ramdisk addr 0x90c80040, FDT 0x90780000
Found romfs @ 0x90c80040 (0x001bf000)
#### klimit 902f5000 ####
Moving 0x001bf000 bytes from 0x90c80040 to 0x902f42a8
New klimit: 0x904b4000
Found FDT at 0x90780000
Linux version 2.6.29-rc8-00471-g965e2a5-dirty (monstr@monstr.eu) (gcc version
3.4.1 ( PetaLinux 0.20 Build -rc1 050607 )) #46 Fri Mar 20 12:20:22 CET 2009
setup_cpuinfo: initialising
setup_cpuinfo: Using full CPU PVR support
setup_memory: Main mem: 0x90000000-0xa0000000, size 0x10000000
setup_memory: kernel addr=0x90000000-0x904b4000 size=0x004b4000
setup_memory: max_mapnr: 0x10000
setup_memory: min_low_pfn: 0x90000
setup_memory: max_low_pfn: 0xa0000
On node 0 totalpages: 65536
free_area_init_node: node 0, pgdat 902842f0, node_mem_map 904b4000
  Normal zone: 512 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 65024 pages, LIFO batch:15
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
Kernel command line: console=ttyUL0,115200 highres=on
xlnx,xps-intc-1.00.a #0 at 0x81800000, num_irq=9, edge=0x100
PID hash table entries: 1024 (order: 10, 4096 bytes)
xlnx,xps-timer-1.00.a #0 at 0x83c00000, irq=3
Heartbeat GPIO at 0x81400000
microblaze_timer_set_mode: shutdown
microblaze_timer_set_mode: periodic

periodic mode
--------------------------------------------------------------------------------------
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 254848k/262144k available
ODEBUG: selftest passed
Calibrating delay loop... 61.64 BogoMIPS (lpj=308224)
Mount-cache hash table entries: 512
net_namespace: 544 bytes
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
NET: Registered protocol family 1
msgmni has been set to 498
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
84000000.serial: ttyUL0 at MMIO 0x84000003 (irq = 8) is a uartlite
console [ttyUL0] enabled
brd: module loaded
nbd: registered device at major 43
uclinux[mtd]: RAM probe address=0x902f42a8 size=0x1bf000
Creating 1 MTD partitions on "RAM":
0x000000000000-0x0000001bf000 : "ROMfs"
uclinux[mtd]: set ROMfs to be root filesystem index=0
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
VFS: Mounted root (romfs filesystem) readonly on device 31:0.
Freeing unused kernel memory: 96k freed
Mounting proc:
Mounting var:
Populating /var:
Running local start scripts.
Mounting /etc/config:
Populating /etc/config:
flatfsd: Nonexistent or bad flatfs (-48), creating new one...
flatfsd: Failed to write flatfs (-48): No such device
flatfsd: Created 6 configuration files (310 bytes)
Mounting sysfs:
Setting hostname:
Setting up interface lo:
Setting up interface eth0:
SIOCSIFADDR: No such device
Starting thttpd:

uclinux login: root
Password:
# cat /proc/timer_list
Timer List Version: v0.4
HRTIMER_MAX_CLOCK_BASES: 2
now at 21135463800 nsecs

cpu: 0
 clock 0:
  .base:       9027a4d0
  .index:      0
  .resolution: 10000000 nsecs
  .get_time:   ktime_get_real
  .offset:     0 nsecs
active timers:
 clock 1:
  .base:       9027a4fc
  .index:      1
  .resolution: 10000000 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <9f2d3a48>, hrtimer_wakeup, S:01, <9f2d3a48>, inetd/54
 # expires at 21380356677-21381356634 nsecs [in 244892877 to 245892834 nsecs]
 #1: <9e127a48>, hrtimer_wakeup, S:01, <9e127a48>, thttpd/50
 # expires at 129627877707-129727877707 nsecs [in 108492413907 to 108592413907
nsecs]
  .expires_next   : 2147483646999999999 nsecs
  .hres_active    : 0
  .nr_events      : 0
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294939392


Tick Device: mode:     0
Per CPU device: 0
Clock Event Device: microblaze_clockevent
 max_delta_ns:   2147483647
 min_delta_ns:   1000
 mult:           536870912
 shift:          32
 mode:           2
 next_event:     2147483646999999999 nsecs
 set_next_event: microblaze_timer_set_next_event
 set_mode:       microblaze_timer_set_mode
 event_handler:  tick_handle_periodic

#

--------------------------------------------------------------------------------------
only shot mode


early_printk_console is enabled at 0x84000000
Ramdisk addr 0x90c80040, FDT 0x90780000
Found romfs @ 0x90c80040 (0x001bf000)
#### klimit 902f5000 ####
Moving 0x001bf000 bytes from 0x90c80040 to 0x902f42a8
New klimit: 0x904b4000
Found FDT at 0x90780000
Linux version 2.6.29-rc8-00471-g965e2a5-dirty (monstr@monstr.eu) (gcc version
3.4.1 ( PetaLinux 0.20 Build -rc1 050607 )) #47 Fri Mar 20 12:23:08 CET 2009
setup_cpuinfo: initialising
setup_cpuinfo: Using full CPU PVR support
setup_memory: Main mem: 0x90000000-0xa0000000, size 0x10000000
setup_memory: kernel addr=0x90000000-0x904b4000 size=0x004b4000
setup_memory: max_mapnr: 0x10000
setup_memory: min_low_pfn: 0x90000
setup_memory: max_low_pfn: 0xa0000
On node 0 totalpages: 65536
free_area_init_node: node 0, pgdat 902842f0, node_mem_map 904b4000
  Normal zone: 512 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 65024 pages, LIFO batch:15
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
Kernel command line: console=ttyUL0,115200 highres=on
xlnx,xps-intc-1.00.a #0 at 0x81800000, num_irq=9, edge=0x100
PID hash table entries: 1024 (order: 10, 4096 bytes)
xlnx,xps-timer-1.00.a #0 at 0x83c00000, irq=3
Heartbeat GPIO at 0x81400000
microblaze_timer_set_mode: shutdown
microblaze_timer_set_mode: oneshot

one shot mode here
--------------------------------------------------------------------------------------
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 254848k/262144k available
ODEBUG: selftest passed
Calibrating delay loop... 62.25 BogoMIPS (lpj=311296)
Mount-cache hash table entries: 512
net_namespace: 544 bytes
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
Switched to high resolution mode on CPU 0
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
NET: Registered protocol family 1
msgmni has been set to 498
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
84000000.serial: ttyUL0 at MMIO 0x84000003 (irq = 8) is a uartlite
console [ttyUL0] enabled
brd: module loaded
nbd: registered device at major 43
uclinux[mtd]: RAM probe address=0x902f42a8 size=0x1bf000
Creating 1 MTD partitions on "RAM":
0x000000000000-0x0000001bf000 : "ROMfs"
uclinux[mtd]: set ROMfs to be root filesystem index=0
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
VFS: Mounted root (romfs filesystem) readonly on device 31:0.
Freeing unused kernel memory: 96k freed
Mounting proc:
Mounting var:
Populating /var:
Running local start scripts.
Mounting /etc/config:
Populating /etc/config:
flatfsd: Nonexistent or bad flatfs (-48), creating new one...
flatfsd: Failed to write flatfs (-48): No such device
flatfsd: Created 6 configuration files (310 bytes)
Mounting sysfs:
Setting hostname:
Setting up interface lo:
Setting up interface eth0:
SIOCSIFADDR: No such device
Starting thttpd:

uclinux login: root
Password:
# cat /proc/timer_list
Timer List Version: v0.4
HRTIMER_MAX_CLOCK_BASES: 2
now at 20996421657 nsecs

cpu: 0
 clock 0:
  .base:       9027a4d0
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     0 nsecs
active timers:
 clock 1:
  .base:       9027a4fc
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: per_cpu__tick_cpu_sched, tick_sched_timer, S:01, <800005a6>, swapper/1
 # expires at 21000000000-21000000000 nsecs [in 3578343 to 3578343 nsecs]
 #1: <9f2d3a48>, hrtimer_wakeup, S:01, <9f2d3a48>, inetd/54
 # expires at 21467819124-21468819081 nsecs [in 471397467 to 472397424 nsecs]
 #2: <9e127a48>, hrtimer_wakeup, S:01, <9e127a48>, thttpd/50
 # expires at 129753940928-129853940928 nsecs [in 108757519271 to 108857519271
nsecs]
  .expires_next   : 21000000000 nsecs
  .hres_active    : 1
  .nr_events      : 2011
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294939395


Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: microblaze_clockevent
 max_delta_ns:   2147483647
 min_delta_ns:   1000
 mult:           536870912
 shift:          32
 mode:           3
 next_event:     21000000000 nsecs
 set_next_event: microblaze_timer_set_next_event
 set_mode:       microblaze_timer_set_mode
 event_handler:  hrtimer_interrupt

#


---------------------------------------------------------------------------------------------
both mode in features


early_printk_console is enabled at 0x84000000
Ramdisk addr 0x90c80040, FDT 0x90780000
Found romfs @ 0x90c80040 (0x001bf000)
#### klimit 902f5000 ####
Moving 0x001bf000 bytes from 0x90c80040 to 0x902f42a8
New klimit: 0x904b4000
Found FDT at 0x90780000
Linux version 2.6.29-rc8-00471-g965e2a5-dirty (monstr@monstr.eu) (gcc version
3.4.1 ( PetaLinux 0.20 Build -rc1 050607 )) #48 Fri Mar 20 12:26:44 CET 2009
setup_cpuinfo: initialising
setup_cpuinfo: Using full CPU PVR support
setup_memory: Main mem: 0x90000000-0xa0000000, size 0x10000000
setup_memory: kernel addr=0x90000000-0x904b4000 size=0x004b4000
setup_memory: max_mapnr: 0x10000
setup_memory: min_low_pfn: 0x90000
setup_memory: max_low_pfn: 0xa0000
On node 0 totalpages: 65536
free_area_init_node: node 0, pgdat 902842f0, node_mem_map 904b4000
  Normal zone: 512 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 65024 pages, LIFO batch:15
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
Kernel command line: console=ttyUL0,115200 highres=on
xlnx,xps-intc-1.00.a #0 at 0x81800000, num_irq=9, edge=0x100
PID hash table entries: 1024 (order: 10, 4096 bytes)
xlnx,xps-timer-1.00.a #0 at 0x83c00000, irq=3
Heartbeat GPIO at 0x81400000
microblaze_timer_set_mode: shutdown
microblaze_timer_set_mode: periodic
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 254848k/262144k available
ODEBUG: selftest passed
Calibrating delay loop... 61.64 BogoMIPS (lpj=308224)
Mount-cache hash table entries: 512
net_namespace: 544 bytes
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
microblaze_timer_set_mode: oneshot
Switched to high resolution mode on CPU 0
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
NET: Registered protocol family 1
msgmni has been set to 498
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
84000000.serial: ttyUL0 at MMIO 0x84000003 (irq = 8) is a uartlite
console [ttyUL0] enabled
brd: module loaded
nbd: registered device at major 43
uclinux[mtd]: RAM probe address=0x902f42a8 size=0x1bf000
Creating 1 MTD partitions on "RAM":
0x000000000000-0x0000001bf000 : "ROMfs"
uclinux[mtd]: set ROMfs to be root filesystem index=0
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
VFS: Mounted root (romfs filesystem) readonly on device 31:0.
Freeing unused kernel memory: 96k freed
Mounting proc:
Mounting var:
Populating /var:
Running local start scripts.
Mounting /etc/config:
Populating /etc/config:
flatfsd: Nonexistent or bad flatfs (-48), creating new one...
flatfsd: Failed to write flatfs (-48): No such device
flatfsd: Created 6 configuration files (310 bytes)
Mounting sysfs:
Setting hostname:
Setting up interface lo:
Setting up interface eth0:
SIOCSIFADDR: No such device
Starting thttpd:

uclinux login: root
Password:
# cat /proc/timer_list
Timer List Version: v0.4
HRTIMER_MAX_CLOCK_BASES: 2
now at 17205889582 nsecs

cpu: 0
 clock 0:
  .base:       9027a4d0
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     0 nsecs
active timers:
 clock 1:
  .base:       9027a4fc
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: per_cpu__tick_cpu_sched, tick_sched_timer, S:01, <800005a6>, swapper/1
 # expires at 17210000000-17210000000 nsecs [in 4110418 to 4110418 nsecs]
 #1: <9f2d3a48>, hrtimer_wakeup, S:01, <9f2d3a48>, inetd/54
 # expires at 17430563969-17431563926 nsecs [in 224674387 to 225674344 nsecs]
 #2: <9e127a48>, hrtimer_wakeup, S:01, <9e127a48>, thttpd/50
 # expires at 129748538823-129848538823 nsecs [in 112542649241 to 112642649241
nsecs]
  .expires_next   : 17210000000 nsecs
  .hres_active    : 1
  .nr_events      : 1627
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294939016


Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: microblaze_clockevent
 max_delta_ns:   2147483647
 min_delta_ns:   1000
 mult:           536870912
 shift:          32
 mode:           3
 next_event:     17210000000 nsecs
 set_next_event: microblaze_timer_set_next_event
 set_mode:       microblaze_timer_set_mode
 event_handler:  hrtimer_interrupt

#




