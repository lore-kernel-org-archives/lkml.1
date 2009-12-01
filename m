Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZLAKD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZLAKD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZLAKD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:03:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59198 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbZLAKD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:03:57 -0500
Date: Tue, 1 Dec 2009 21:03:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: michal.simek@petalogix.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: problems in linux-next (Was: Re: linux-next: Tree for December 1)
Message-Id: <20091201210343.f0a1d353.sfr@canb.auug.org.au>
In-Reply-To: <4B14D6E2.2040704@petalogix.com>
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au>
	<4B14D6E2.2040704@petalogix.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing the percpu and workqueue folks ...

On Tue, 01 Dec 2009 09:42:10 +0100 Michal Simek <michal.simek@petalogix.com> wrote:
> 
> It seems to me that percpu has more other troubles too.
> Look at boolog below for Microblaze with MMU.

Or may the workqueue additions?

> I haven't look at that problem deeper but I will.
> Any suggestion what could be wrong?
> 
> Problems started in linux-next from November 27.
> You can look at logs.
> http://www.monstr.eu/wiki/doku.php?id=log:log
> 
> Thanks,
> Michal
> 
> early_printk_console is enabled at 0x84000000
> Ramdisk addr 0x00000003, FDT at 0x9099c414
> Linux version 2.6.32-rc8-next-20091201 (monstr@monstr.eu) (gcc version 
> 4.1.2) #1 Tue Dec 1 09:34:15 CET 2009
> setup_cpuinfo: initialising
> setup_cpuinfo: Using full CPU PVR support
> setup_memory: max_mapnr: 0x10000
> setup_memory: min_low_pfn: 0x90000
> setup_memory: max_low_pfn: 0xa0000
> On node 0 totalpages: 65536
> free_area_init_node: node 0, pgdat c02cc768, node_mem_map c09a1000
>    Normal zone: 512 pages used for memmap
>    Normal zone: 0 pages reserved
>    Normal zone: 65024 pages, LIFO batch:15
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
> Kernel command line: console=ttyUL0,115200
> PID hash table entries: 1024 (order: 0, 4096 bytes)
> Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
> Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
> Memory: 249600k/262144k available
> Hierarchical RCU implementation.
> NR_IRQS:32
> xlnx,xps-intc-1.00.a #0 at 0xd0000000, num_irq=9, edge=0x100
> xlnx,xps-timer-1.00.a #0 at 0xd0004000, irq=3
> microblaze_timer_set_mode: shutdown
> microblaze_timer_set_mode: periodic
> Calibrating delay loop... 119.19 BogoMIPS (lpj=595968)
> Mount-cache hash table entries: 512
> ------------[ cut here ]------------
> WARNING: at include/linux/percpu.h:157 __create_workqueue_key+0x1c0/0x1d0()
> Modules linked in:
> 
> Stack:
>    cf831f1c c0033694 00000000 00000000 c022dac0 c0013f40 c022836c c022dac0
>    0000009d c0029814 0001ffff c0973e20 cf8032e4 00000000 00000000 c022dad8
>    c002980c 00000000 c02d68f8 c02e6218 00000000 00000000 c022dad8 c02d5860
> Call Trace:
> 
> [<c0033694>] atomic_notifier_chain_register+0x40/0x64
> [<c0013f40>] warn_slowpath_null+0xc/0x20
> [<c0029814>] __create_workqueue_key+0x1c0/0x1d0
> [<c002980c>] __create_workqueue_key+0x1b8/0x1d0
> [<c02d68f8>] spawn_softlockup_task+0x0/0xc0
> [<c02d5860>] init_workqueues+0x48/0xa0
> [<c02ce104>] kernel_init+0x0/0x184
> [<c02ce148>] kernel_init+0x44/0x184
> [<c02ce170>] kernel_init+0x6c/0x184
> [<c00023a0>] kernel_thread_helper+0xc/0x20
> [<c0002394>] kernel_thread_helper+0x0/0x20
> 
> ---[ end trace 139ce121c98e96c9 ]---
> NET: Registered protocol family 16
> bio: create slab <bio-0> at 0
> Switching to clocksource microblaze_clocksource
> NET: Registered protocol family 2
> IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
> TCP established hash table entries: 8192 (order: 4, 65536 bytes)
> TCP bind hash table entries: 8192 (order: 5, 163840 bytes)
> TCP: Hash tables configured (established 8192 bind 8192)
> TCP reno registered
> NET: Registered protocol family 1
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> RPC: Registered tcp NFSv4.1 backchannel transport module.
> Slow work thread pool: Starting up
> Slow work thread pool: Ready
> msgmni has been set to 487
> io scheduler noop registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> 84000000.serial: ttyUL0 at MMIO 0x84000003 (irq = 8) is a uartlite
> console [ttyUL0] enabled
> brd: module loaded
> TCP cubic registered
> NET: Registered protocol family 17
> Freeing unused kernel memory: 6801k freed
> Mounting proc:
> Mounting var:
> Populating /var:
> Running local start scripts.
> Mounting sysfs:
> Setting hostname:
> Setting up interface lo:
> Setting up interface eth0:
> BUG: failure at kernel/workqueue.c:431/process_one_work()!
> Kernel panic - not syncing: BUG!
> Rebooting in 120 seconds..timeout
> 
> -- 
> Michal Simek, Ing. (M.Eng)
> PetaLogix - Linux Solutions for a Reconfigurable World
> w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
