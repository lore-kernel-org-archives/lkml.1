Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZLCQ0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZLCQ0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 11:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZLCQ0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 11:26:42 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49482 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZLCQ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 11:26:41 -0500
Message-ID: <4B17E6AF.90700@petalogix.com>
Date: Thu, 03 Dec 2009 17:26:23 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>, matthew@wil.cx,
       Arnd Bergmann <arnd@arndb.de>,
       John Williams <john.williams@petalogix.com>
Subject: Inconsistent lock state - finish_task_switch/sched.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am trying to find out one inconsistent lock state.
I haven't had any experience with it. I found Matthew's explanation 
(http://lkml.org/lkml/2008/6/4/1).
Below is log for Microblaze which points to finish_task_switch in 
sched.c. I am not sure if is arch specific problem or not.

BTW: The backtraces below are wrong because Microblaze miss frame pointer.

Thanks for your advices,
Michal


Linux version 2.6.32-00043-g62a59b0 (monstr@monstr.eu) (gcc version 
4.1.2) #12 Thu Dec 3 16:42:36 CET 2009
setup_cpuinfo: initialising
setup_cpuinfo: Using full CPU PVR support
setup_memory: max_mapnr: 0x10000
setup_memory: min_low_pfn: 0x90000
setup_memory: max_low_pfn: 0xa0000
On node 0 totalpages: 65536
free_area_init_node: node 0, pgdat c0337554, node_mem_map c0e4a000
   Normal zone: 512 pages used for memmap
   Normal zone: 0 pages reserved
   Normal zone: 65024 pages, LIFO batch:15
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
Kernel command line: console=ttyUL0,115200
PID hash table entries: 1024 (order: 0, 4096 bytes)
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 244864k/262144k available
Hierarchical RCU implementation.
NR_IRQS:32
xlnx,xps-intc-1.00.a #0 at 0xd0000000, num_irq=9, edge=0x100
xlnx,xps-timer-1.00.a #0 at 0xd0004000, irq=3
microblaze_timer_set_mode: shutdown
microblaze_timer_set_mode: periodic
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
  memory used by lock dependency info: 3567 kB
  per task-struct memory footprint: 1152 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                  | spin |wlock |rlock |mutex | wsem | 
rsem |
 
--------------------------------------------------------------------------
                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
 
--------------------------------------------------------------------------
               recursive read-lock:             |  ok  |             | 
ok  |
            recursive read-lock #2:             |  ok  |             | 
ok  |
             mixed read-write-lock:             |  ok  |             | 
ok  |
             mixed write-read-lock:             |  ok  |             | 
ok  |
 
--------------------------------------------------------------------------
      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
       hard-irq read-recursion/123:  ok  |
       soft-irq read-recursion/123:  ok  |
       hard-irq read-recursion/132:  ok  |
       soft-irq read-recursion/132:  ok  |
       hard-irq read-recursion/213:  ok  |
       soft-irq read-recursion/213:  ok  |
       hard-irq read-recursion/231:  ok  |
       soft-irq read-recursion/231:  ok  |
       hard-irq read-recursion/312:  ok  |
       soft-irq read-recursion/312:  ok  |
       hard-irq read-recursion/321:  ok  |
       soft-irq read-recursion/321:  ok  |
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Calibrating delay loop... 59.80 BogoMIPS (lpj=299008)
Mount-cache hash table entries: 512

=================================
[ INFO: inconsistent lock state ]
2.6.32-00043-g62a59b0 #12
---------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
swapper/1 [HC0[0]:SC0[0]:HE0:SE1] takes:
  (&rq->lock){?.-...}, at: [<c000f148>] finish_task_switch+0x0/0x178
{IN-HARDIRQ-W} state was registered at:
   [<c0016478>] release_console_sem+0x50/0x2d8
   [<c0046214>] mark_lock+0x2f4/0x6ac
   [<c00492f8>] __lock_acquire+0x908/0xbb8
   [<c001707c>] vprintk+0x2a4/0x550
   [<c0048cfc>] __lock_acquire+0x30c/0xbb8
   [<c00495f8>] lock_acquire+0x50/0x80
   [<c0024374>] do_timer+0x40/0x68
   [<c0048bfc>] __lock_acquire+0x20c/0xbb8
   [<c0280d3c>] _spin_lock+0x38/0x64
   [<c00120f0>] scheduler_tick+0x2c/0x13c
   [<c00120e8>] scheduler_tick+0x24/0x13c
   [<c00243b8>] run_local_timers+0x1c/0x44
   [<c00120f0>] scheduler_tick+0x2c/0x13c
   [<c0024438>] update_process_times+0x58/0x88
   [<c002442c>] update_process_times+0x4c/0x88
   [<c0042d30>] tick_periodic+0x30/0x110
   [<c0042dec>] tick_periodic+0xec/0x110
   [<c0042dc4>] tick_periodic+0xc4/0x110
   [<c0042e3c>] tick_handle_periodic+0x2c/0x150
   [<c00495f8>] lock_acquire+0x50/0x80
   [<c0280af4>] _spin_unlock_irqrestore+0x2c/0x90
   [<c0005ff4>] timer_interrupt+0x30/0x50
   [<c0050f58>] handle_IRQ_event+0x58/0x1e8
   [<c0280b88>] _spin_unlock+0x30/0x50
   [<c00540d8>] handle_level_irq+0xa4/0x16c
   [<c00540c8>] handle_level_irq+0x94/0x16c
   [<c0001b2c>] do_IRQ+0x7c/0x108
   [<c0001ae0>] do_IRQ+0x30/0x108
   [<c0008b20>] irq_call+0x0/0x8
   [<c0280e90>] _spin_lock_irqsave+0x30/0x8c
   [<c0280b1c>] _spin_unlock_irqrestore+0x54/0x90
   [<c0042628>] clockevents_register_device+0xf8/0x194
   [<c00425a8>] clockevents_register_device+0x78/0x194
   [<c0042630>] clockevents_register_device+0x100/0x194
   [<c0339a6c>] start_kernel+0x2d4/0x4e4
   [<c0339a74>] start_kernel+0x2dc/0x4e4
   [<c0339a7c>] start_kernel+0x2e4/0x4e4
   [<c00065b0>] machine_halt+0x0/0x24
   [<c001667c>] release_console_sem+0x254/0x2d8
irq event stamp: 0
hardirqs last  enabled at (0): [<(null)>] (null)
hardirqs last disabled at (0): [<c001358c>] copy_process+0x33c/0x1200
softirqs last  enabled at (0): [<c001358c>] copy_process+0x33c/0x1200
softirqs last disabled at (0): [<(null)>] (null)

other info that might help us debug this:
no locks held by swapper/1.

stack backtrace:

Stack:
   cf833de8 00000000 cf833e00 c028ee58 cf833e08 cf833e00 c0046594 c028e584
   c02b7568 c001667c 00000000 00000002 00000000 00000000 00000000 00000001
   cf833e3c 00000000 00000000 00000002 cf8313b4 c00490c4 cf83111c cf831210
Call Trace:

[<c0046594>] mark_lock+0x674/0x6ac
[<c001667c>] release_console_sem+0x254/0x2d8
[<c00490c4>] __lock_acquire+0x6d4/0xbb8
[<c001a24c>] do_exit+0xcc/0x7a4
[<c0280d1c>] _spin_lock+0x18/0x64
[<c001a2b0>] do_exit+0x130/0x7a4
[<c00495f8>] lock_acquire+0x50/0x80
[<c000f1a8>] finish_task_switch+0x60/0x178
[<c000f148>] finish_task_switch+0x0/0x178
[<c0010aa4>] schedule_tail+0x18/0x88
[<c0018620>] exit_mm+0x248/0x268
[<c000f148>] finish_task_switch+0x0/0x178
[<c0007e94>] ret_from_fork+0x4/0x20
[<c0007f88>] full_exception_trap+0x28/0x210
[<c03391c0>] kernel_init+0x0/0x194
[<c0002628>] kernel_thread_helper+0x0/0x28

INFO: lockdep is turned off.
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
Switching to clocksource microblaze_clocksource
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
Slow work thread pool: Starting up
Slow work thread pool: Ready
msgmni has been set to 478
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
84000000.serial: ttyUL0 at MMIO 0x84000003 (irq = 8) is a uartlite
console [ttyUL0] enabled
brd: module loaded
TCP cubic registered
NET: Registered protocol family 17
Freeing unused kernel memory: 6220k freed
Mounting proc:
Mounting var:
Populating /var:
Running local start scripts.
Mounting sysfs:
Setting hostname:
Setting up interface lo:
Setting up interface eth0:
ifconfig: SIOCSIFADDR: No such device
Starting syslogd:
Starting httpd:
Mounting nfs server

uclinux login:


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
