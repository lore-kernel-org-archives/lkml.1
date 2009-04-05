Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbZDEUjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbZDEUjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 16:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbZDEUja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 16:39:30 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:53909 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZDEUja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 16:39:30 -0400
Date: Mon, 6 Apr 2009 02:08:29 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: WARNING: at kernel/lockdep.c:2134
	trace_hardirqs_on_caller+0xcb/0x150()
Message-ID: <20090405203829.GA16487@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hit this on a reboot,

Unmounting file systems:
Please stand by while rebooting the system...
Starting new kernel
irq event stamp: 20972
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2134 trace_hardirqs_on_caller+0xcb/0x150()
Hardware name: eserver xSeries 255 -[4444aaa]-
Modules linked in: bridge stp bnep l2cap bluetooth fuse ip6table_filter ip6_tables ipv6 dm_multipath pcspkr [last unloaded: freq_table]
Pid: 0, comm: swapper Not tainted 2.6.29-07945-g6bb5975 #53
Call Trace:
[<c022ca6a>] warn_slowpath+0x76/0xad
[<c022a27e>] ? scheduler_tick+0x93/0x1a6
[<c024536e>] ? getnstimeofday+0x56/0xe2
[<c0210f1c>] ? lapic_next_event+0x1b/0x1f
[<c024797f>] ? clockevents_program_event+0xed/0xfc
[<c02488cc>] ? tick_dev_program_event+0x2d/0x9a
[<c024898d>] ? tick_program_event+0x27/0x2e
[<c024166b>] ? hrtimer_interrupt+0x141/0x151
[<c0202bee>] ? restore_nocheck_notrace+0x0/0xe
[<c024c060>] trace_hardirqs_on_caller+0xcb/0x150
[<c0341d34>] trace_hardirqs_on_thunk+0xc/0x10
[<c0202bee>] ? restore_nocheck_notrace+0x0/0xe
[<c021007b>] ? acpi_processor_ffh_cstate_probe_cpu+0x63/0xad
[<c025007b>] ? futex_lock_pi+0xcc/0x7c2
[<c0217d24>] ? native_safe_halt+0xa/0xc
[<c0208451>] ? stop_this_cpu+0x4a/0x4d
[<c053ce53>] ? _spin_unlock+0x22/0x25
[<c025241c>] ? generic_smp_call_function_interrupt+0x61/0xfc
[<c0210829>] ? smp_call_function_interrupt+0x25/0x34
[<c0203237>] ? call_function_interrupt+0x2f/0x34
[<c024c0f0>] ? trace_hardirqs_on+0xb/0xd
[<c0217d24>] ? native_safe_halt+0xa/0xc
[<c020828d>] ? default_idle+0x3a/0x64
[<c0201d8f>] ? cpu_idle+0x58/0x79
[<c0537f34>] ? start_secondary+0x1b4/0x1bc
---[ end trace faa6dba417174c69 ]---
hardirqs last enabled at (20971): [<c0211594>] lapic_shutdown+0x53/0x5e
hardirqs last disabled at (20972): [<c053d093>] _spin_lock_irqsave+0x20/0x6a
softirqs last enabled at (20960): [<c023161d>] __do_softirq+0x11c/0x124
softirqs last disabled at (20947): [<c0231660>] do_softirq+0x3b/0x5f
I'm in purgatory

Unfortunately I forgot to compile in the network drivers and on
rebuilding the kernel and rebooting it, I've been unable to reproduce
it. So sadly, I cannot more information

This is on current -git 6bb597507f9839b13498781e481f5458aea33620

Thanks,
-- 
regards,
Dhaval
