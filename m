Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbYBSRBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbYBSRBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 12:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbYBSRA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 12:00:56 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:59582 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753681AbYBSRAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:00:54 -0500
Date: Tue, 19 Feb 2008 22:30:43 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: vgoyal@redhat.com, rostedt@goodmis.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: ftrace and kexec
Message-ID: <20080219170043.GC4754@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080219132746.GC13780@linux.vnet.ibm.com> <20080219142239.GE9965@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219142239.GE9965@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 03:22:39PM +0100, Ingo Molnar wrote:
> 
> * Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> 
> > Hi,
> > 
> > I've been running ftrace on the sched-devel tree. I just built a 
> > kernel and tried rebooting using kexec and I get this,
> 
> hm, it's not a good idea to keep using the data structures of the tracer 
> while we kexec. Does the patch below resolve the problem?
> 

It boots, but I get this now


[    0.296073] ------------[ cut here ]------------
[    0.300018] WARNING: at kernel/lockdep.c:2689 check_flags+0xf6/0x10b()
[    0.300018] Modules linked in:
[    0.300018] Pid: 1, comm: swapper Not tainted 2.6.25-rc2-sched-devel #8
[    0.300018]  [<c012089c>] warn_on_slowpath+0x46/0x60
[    0.300018]  [<c0138ca7>] ? very_verbose+0x8/0xc
[    0.300018]  [<c0139a7e>] ? check_chain_key+0xe/0x1a3
[    0.300018]  [<c0138ca7>] ? very_verbose+0x8/0xc
[    0.300018]  [<c0138ca7>] ? very_verbose+0x8/0xc
[    0.300018]  [<c0139a7e>] ? check_chain_key+0xe/0x1a3
[    0.300018]  [<c0104800>] ? mcount_call+0x5/0x9
[    0.300018]  [<c0139a7e>] ? check_chain_key+0xe/0x1a3
[    0.300019]  [<c013b2f5>] ? __lock_acquire+0x614/0x668
[    0.300019]  [<c0139a7e>] ? check_chain_key+0xe/0x1a3
[    0.300019]  [<c01541c6>] ? ftrace_record_ip+0x124/0x130
[    0.300019]  [<c0104800>] ? mcount_call+0x5/0x9
[    0.300019]  [<c0242f58>] ? debug_locks_off+0x8/0x40
[    0.300019]  [<c0104800>] ? mcount_call+0x5/0x9
[    0.300019]  [<c013b78c>] check_flags+0xf6/0x10b
[    0.300019]  [<c013b7d5>] lock_acquire+0x34/0x80
[    0.300019]  [<c040e2eb>] _spin_lock_irqsave+0x27/0x37
[    0.300019]  [<c015414e>] ? ftrace_record_ip+0xac/0x130
[    0.300019]  [<c0124dc4>] ? do_softirq+0x2f/0x47
[    0.300019]  [<c015414e>] ftrace_record_ip+0xac/0x130
[    0.300019]  [<c013a581>] ? trace_softirqs_off+0x8/0xaa
[    0.300019]  [<c0124dc4>] ? do_softirq+0x2f/0x47
[    0.300019]  [<c0104800>] mcount_call+0x5/0x9
[    0.300019]  [<c0124dc4>] ? do_softirq+0x2f/0x47
[    0.300019]  [<c013a581>] ? trace_softirqs_off+0x8/0xaa
[    0.300019]  [<c01249b1>] __local_bh_disable+0x7d/0x83
[    0.300019]  [<c0124d1c>] __do_softirq+0x1e/0x97
[    0.300019]  [<c0124dc4>] do_softirq+0x2f/0x47
[    0.300019]  [<c0124e3b>] irq_exit+0x3c/0x3e
[    0.300019]  [<c011087b>] smp_apic_timer_interrupt+0x32/0x3b
[    0.300019]  [<c0105375>] apic_timer_interrupt+0x2d/0x34
[    0.300019]  [<c012153a>] ? release_console_sem+0xc0/0xda
[    0.300019]  [<c0120000>] ? sys_unshare+0x9c/0x2a8
[    0.300019]  [<c01211ee>] ? vprintk+0x24b/0x256
[    0.300019]  [<c013a455>] ? trace_hardirqs_on+0xb/0xd
[    0.300019]  [<c01541c6>] ? ftrace_record_ip+0x124/0x130
[    0.300019]  [<c0120f95>] ? printk+0x8/0x16
[    0.300019]  [<c0120fa1>] printk+0x14/0x16
[    0.300019]  [<c03a7b85>] sock_register+0x61/0x6a
[    0.300019]  [<c05daefd>] netlink_proto_init+0xf4/0x11a
[    0.300019]  [<c05bca6c>] ? kernel_init+0x0/0x6c
[    0.300019]  [<c05bc8fb>] do_initcalls+0x7a/0x192
[    0.300019]  [<c01a7627>] ? create_proc_entry+0x6c/0x80
[    0.300019]  [<c0104800>] ? mcount_call+0x5/0x9
[    0.300019]  [<c01511b0>] ? register_irq_proc+0xe/0x8b
[    0.300019]  [<c01a0000>] ? load_elf_binary+0x818/0x9e0
[    0.300019]  [<c05bca6c>] ? kernel_init+0x0/0x6c
[    0.300019]  [<c05bca34>] do_basic_setup+0x21/0x23
[    0.300019]  [<c05bca9d>] kernel_init+0x31/0x6c
[    0.300019]  [<c01054cf>] kernel_thread_helper+0x7/0x10
[    0.300019]  =======================
[    0.300019] ---[ end trace ca143223eefdc828 ]---
[    0.300019] irq event stamp: 1894
[    0.300019] hardirqs last  enabled at (1893): [<c013a455>] trace_hardirqs_on+0xb/0xd
[    0.300019] hardirqs last disabled at (1894): [<c013a4e6>] trace_hardirqs_off+0xb/0xd
[    0.300019] softirqs last  enabled at (1184): [<c0124d90>] __do_softirq+0x92/0x97
[    0.300019] softirqs last disabled at (1175): [<c0124dc4>] do_softirq+0x2f/0x47

-- 
regards,
Dhaval
