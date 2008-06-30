Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbYF3Oyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbYF3Oyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 10:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbYF3Oyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 10:54:35 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:38014 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752492AbYF3OyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 10:54:25 -0400
Date: Mon, 30 Jun 2008 20:23:57 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/30] SMP-group balancer - take 3
Message-ID: <20080630145357.GA26809@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080627114109.724249622@chello.nl> <20080627173355.GA11381@linux.vnet.ibm.com> <20080628170828.GA2002@linux.vnet.ibm.com> <20080630125956.GD4011@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630125956.GD4011@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 02:59:56PM +0200, Ingo Molnar wrote:
> 
> * Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> 
> > Hi,
> > 
> > I get this at bootup
> > 
> > ------------[ cut here ]------------
> > WARNING: at kernel/lockdep.c:2738 check_flags+0x8a/0x12d()
> > Modules linked in:
> > Pid: 1, comm: swapper Not tainted 2.6.26-rc8-tip #5
> 
> please check latest tip/master. This is the commit that should fix it:
> 

Nope, does not :(. Still get,

------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2662 check_flags+0x7c/0x10b()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc8 #2
 [<c0122a6d>] warn_on_slowpath+0x41/0x5d
 [<c013ba0e>] ? find_usage_backwards+0xb4/0xd5
 [<c013ba0e>] ? find_usage_backwards+0xb4/0xd5
 [<c013ba0e>] ? find_usage_backwards+0xb4/0xd5
 [<c013bc2b>] ? check_usage+0x23/0x58
 [<c013bcd1>] ? check_prev_add_irq+0x71/0x85
 [<c013be48>] ? check_prev_add+0x3b/0x17f
 [<c013bfe6>] ? check_prevs_add+0x5a/0xb2
 [<c013c0e8>] ? validate_chain+0xaa/0x29c
 [<c013def5>] check_flags+0x7c/0x10b
 [<c013dfb4>] lock_acquire+0x30/0x7e
 [<c01187b2>] ? tg_shares_up+0x0/0x100
 [<c01186b6>] walk_tg_tree+0x2c/0x96
 [<c011868a>] ? walk_tg_tree+0x0/0x96
 [<c0118907>] ? tg_nop+0x0/0x5
 [<c011894e>] update_shares+0x42/0x4a
 [<c011b87a>] try_to_wake_up+0x4c/0x11f
 [<c011b95c>] wake_up_process+0xf/0x11
 [<c01331b5>] kthread_create+0x6c/0x9c
 [<c0130739>] ? worker_thread+0x0/0xd2
 [<c024218c>] ? __spin_lock_init+0x24/0x47
 [<c0130ceb>] create_workqueue_thread+0x2b/0x45
 [<c0130739>] ? worker_thread+0x0/0xd2
 [<c0130e3a>] __create_workqueue_key+0x115/0x14d
 [<c05c8854>] ? kernel_init+0x0/0x93
 [<c05d7594>] init_workqueues+0x4c/0x5d
 [<c05c880d>] do_basic_setup+0x8/0x1e
 [<c05c88ac>] kernel_init+0x58/0x93
 [<c0104557>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
possible reason: unannotated irqs-on.
irq event stamp: 10216
hardirqs last  enabled at (10215): [<c013e52b>]
debug_check_no_locks_freed+0x9d/0xa7
hardirqs last disabled at (10216): [<c0107f91>]
native_sched_clock+0x50/0xb8
softirqs last  enabled at (9922): [<c0127171>] __do_softirq+0xdf/0xe6
softirqs last disabled at (9915): [<c01271b1>] do_softirq+0x39/0x51

-- 
regards,
Dhaval
