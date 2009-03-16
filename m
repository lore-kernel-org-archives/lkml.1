Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbZCPAyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbZCPAyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 20:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZCPAyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 20:54:44 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53558 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbZCPAyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 20:54:43 -0400
Message-Id: <200903160054.n2G0sVnd083490@www262.sakura.ne.jp>
Subject: Re: KMEMCHECK: linux-next: kernel BUG at arch/x86/mm/kmemcheck/kmemcheck.c:297!
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: vegard.nossum@gmail.com
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Mar 2009 09:54:31 +0900
References: <20090315174713.GA11207@damson.getinternet.no>
In-Reply-To: <20090315174713.GA11207@damson.getinternet.no>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 15032009 #1726517, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Vegard Nossum wrote:
> > [    0.004000] ------------[ cut here ]------------
> > [    0.004000] kernel BUG at arch/x86/mm/kmemcheck/kmemcheck.c:297!
> 
> Hi, thanks for this report!
> 
> I have a feeling that the following patch might fix it. Please try it out
> only if you have the time. I will also try to reproduce it when I have the
> time myself.

I tested this patch on linux-next-20090310 and confirmed that this problem was
solved.

By the way, is there a possibility that delays introduced by kmemcheck trigger
false "CPU stalled" warning?
I got below warning message after applying this patch.

[   14.477987] pci 0000:00:18.7: PCI bridge, secondary bus 0000:22
[   14.480320] pci 0000:00:18.7:   IO window: disabled
[   14.482590] pci 0000:00:18.7:   MEM window: 0xdb200000-0xdb2fffff
[   14.485180] pci 0000:00:18.7:   PREFETCH window: 0x000000dda00000-0x000000ddafffff
[   14.618875] NET: Registered protocol family 2
[   14.744525] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   15.762230] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[   18.989204] TCP bind hash table entries: 65536 (order: 9, 2621440 bytes)
[   24.007883] INFO: RCU detected CPU 0 stall (t=4294898298/2500 jiffies)
[   24.007883] Pid: 1, comm: swapper Not tainted 2.6.29-rc7-next-20090310-dirty #2
[   24.007883] Call Trace:
[   24.007883]  [<c01366d8>] ? printk+0x18/0x20
[   24.007883]  [<c0170254>] print_cpu_stall+0x44/0x90
[   24.007883]  [<c01702dd>] check_cpu_stall+0x3d/0xc0
[   24.007883]  [<c016ccce>] ? __touch_softlockup_watchdog+0xe/0x20
[   24.007883]  [<c016cf69>] ? softlockup_tick+0x169/0x190
[   24.007883]  [<c017091a>] __rcu_pending+0x1a/0xa0
[   24.007883]  [<c01709c9>] rcu_pending+0x29/0x60
[   24.007883]  [<c01401b6>] update_process_times+0x36/0x70
[   24.007883]  [<c0155e25>] tick_periodic+0x25/0x70
[   24.007883]  [<c0155e89>] tick_handle_periodic+0x19/0x80
[   24.007883]  [<c0102f3e>] ? restore_nocheck_notrace+0x0/0xe
[   24.007883]  [<c0115b64>] local_apic_timer_interrupt+0x54/0x60
[   24.007883]  [<c0115b9e>] smp_apic_timer_interrupt+0x2e/0x40
[   24.007883]  [<c01037c7>] apic_timer_interrupt+0x2f/0x34
[   24.007883]  [<c015ba2b>] ? lockdep_init_map+0x5b/0x570
[   24.007883]  [<c0273f02>] __spin_lock_init+0x32/0x60
[   24.007883]  [<c055c241>] tcp_init+0x1c1/0x350
[   24.007883]  [<c033fcca>] ? register_pernet_subsys+0x2a/0x30
[   24.007883]  [<c055cc40>] ? inet_init+0x0/0x1f0
[   24.007883]  [<c055cd40>] inet_init+0x100/0x1f0
[   24.007883]  [<c055cc40>] ? inet_init+0x0/0x1f0
[   24.007883]  [<c010103d>] do_one_initcall+0x2d/0x1a0
[   24.007883]  [<c015a37c>] ? validate_chain+0x3fc/0x540
[   24.007883]  [<c015a37c>] ? validate_chain+0x3fc/0x540
[   24.007883]  [<c012354e>] ? kmemcheck_pte_lookup+0xe/0x30
[   24.007883]  [<c015a37c>] ? validate_chain+0x3fc/0x540
[   24.007883]  [<c012354e>] ? kmemcheck_pte_lookup+0xe/0x30
[   24.007883]  [<c015a37c>] ? validate_chain+0x3fc/0x540
[   24.007883]  [<c015a37c>] ? validate_chain+0x3fc/0x540
[   24.007883]  [<c0157d14>] ? lock_release_holdtime+0x74/0xc0
[   24.007883]  [<c012ecd8>] ? scheduler_tick+0x68/0xb0
[   24.007883]  [<c015d3c7>] ? __lock_release+0x47/0x70
[   24.007883]  [<c012ecd8>] ? scheduler_tick+0x68/0xb0
[   24.007883]  [<c03cd47d>] ? _spin_unlock+0x1d/0x20
[   24.007883]  [<c012ece0>] ? scheduler_tick+0x70/0xb0
[   24.007883]  [<c01401cb>] ? update_process_times+0x4b/0x70
[   24.007883]  [<c0155e25>] ? tick_periodic+0x25/0x70
[   24.007883]  [<c0155e89>] ? tick_handle_periodic+0x19/0x80
[   24.007883]  [<c0102f3e>] ? restore_nocheck_notrace+0x0/0xe
[   24.007883]  [<c015b066>] ? trace_hardirqs_on_caller+0xe6/0x170
[   24.007883]  [<c0535a00>] ? start_kernel+0x250/0x280
[   24.007883]  [<c0265e34>] ? trace_hardirqs_on_thunk+0xc/0x10
[   24.007883]  [<c010590b>] ? do_softirq+0x4b/0xf0
[   24.007883]  [<c0102f3e>] ? restore_nocheck_notrace+0x0/0xe
[   24.007883]  [<c0535ad0>] ? kernel_init+0x0/0x90
[   24.007883]  [<c0535a5a>] do_initcalls+0x2a/0x40
[   24.007883]  [<c0535ad0>] ? kernel_init+0x0/0x90
[   24.007883]  [<c0535a8c>] do_basic_setup+0x1c/0x20
[   24.007883]  [<c0535b20>] kernel_init+0x50/0x90
[   24.007883]  [<c01038e7>] kernel_thread_helper+0x7/0x10
[   26.314302] TCP: Hash tables configured (established 131072 bind 65536)
[   26.316703] TCP reno registered
[   26.423914] NET: Registered protocol family 1
[   26.498394] checking if image is initramfs...it isn't (junk in compressed archive); looks like an initrd
[   26.667075] Freeing initrd memory: 1056k freed

I don't see this warning message if I choose CONFIG_KMEMCHECK=n .

Regards.
