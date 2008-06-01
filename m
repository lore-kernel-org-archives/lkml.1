Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYFAIBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYFAIBH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 04:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYFAIAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 04:00:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52493 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbYFAIAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 04:00:54 -0400
Date: Sun, 1 Jun 2008 10:00:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25.4-rt4
In-Reply-To: <1212076754.24785.18.camel@localhost.localdomain>
Message-ID: <alpine.LNX.1.10.0806010940040.4055@fbirervta.pbzchgretzou.qr>
References: <1212076754.24785.18.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-05-29 17:59, Steven Rostedt wrote:

>We are pleased to announce the 2.6.25.4-rt4 tree,[...]

I am getting tons of the following two stack traces (see below)
during normal operation. 2.6.25.4-rt4, compiled for i586+SMP,
running on i686+UP. syslogd even gets so far as to say "suppressed 134
messages", so it's really a lot. I am tempted to just disable
CONFIG_DEBUG_PREEMPT because otherwise it seems to work.


kernel: BUG: using smp_processor_id() in preemptible [00000000] code: xfssyncd/491
l: caller is __rcu_preempt_unboost+0x20/0xd0
l: Pid: 491, comm: xfssyncd Tainted: G        N 2.6.25.4-jen67-rt #1
l:  [<c0214b4a>] debug_smp_processor_id+0xba/0xc0
l:  [<c016a7b0>] __rcu_preempt_unboost+0x20/0xd0
l:  [<c020dd3c>] ? radix_tree_lookup_slot+0x3c/0xf0
l:  [<c0169e42>] __rcu_read_unlock+0x92/0xa0
l:  [<c016e8d7>] find_get_page+0x87/0x120
l:  [<c016ecae>] find_lock_page+0x1e/0x70
l:  [<c01710d4>] find_or_create_page+0x34/0xc0
l:  [<f0970352>] _xfs_buf_lookup_pages+0x142/0x290 [xfs]
l:  [<c01411e5>] ? init_waitqueue_head+0x15/0x30
l:  [<f097172a>] xfs_buf_get_flags+0x6a/0x140 [xfs]
l:  [<f097181d>] xfs_buf_read_flags+0x1d/0x90 [xfs]
l:  [<f0963f1b>] xfs_trans_read_buf+0x4b/0x340 [xfs]
l:  [<f094b680>] xfs_itobp+0x70/0x1e0 [xfs]
l:  [<f094e2d1>] xfs_iflush+0xe1/0x480 [xfs]
l:  [<f0967801>] xfs_finish_reclaim+0x101/0x190 [xfs]
l:  [<f0967949>] xfs_finish_reclaim_all+0xb9/0xd0 [xfs]
l:  [<f0965aaf>] xfs_syncsub+0x5f/0x2f0 [xfs]
l:  [<f0965d88>] xfs_sync+0x48/0x70 [xfs]
l:  [<f0976ef7>] xfs_sync_worker+0x27/0x50 [xfs]
l:  [<f0977bc9>] xfssyncd+0x129/0x1a0 [xfs]
l:  [<f0977aa0>] ? xfssyncd+0x0/0x1a0 [xfs]
l:  [<c0140ce2>] kthread+0x42/0x70
l:  [<c0140ca0>] ? kthread+0x0/0x70
l:  [<c0107257>] kernel_thread_helper+0x7/0x10


kernel: BUG: using smp_processor_id() in preemptible [00000000] code: IRQ-1/30
l: caller is __rcu_preempt_unboost+0x20/0xd0
l: Pid: 30, comm: IRQ-1 Tainted: G        N 2.6.25.4-jen67-rt #1
l:  [<c0214b4a>] debug_smp_processor_id+0xba/0xc0
l:  [<c016a7b0>] __rcu_preempt_unboost+0x20/0xd0
l:  [<c0169e42>] __rcu_read_unlock+0x92/0xa0
l:  [<c0294960>] ? evdev_event+0x0/0xc0
l:  [<c029022e>] input_pass_event+0x3e/0xb0
l:  [<c0295940>] ? atkbd_event+0x0/0x50
l:  [<c0290a45>] input_handle_event+0x135/0x3f0
l:  [<c0291fcc>] input_event+0x5c/0x70
l:  [<c0296441>] atkbd_interrupt+0x151/0x5c0
l:  [<c0330881>] ? add_preempt_count+0x11/0xa0
l:  [<c032d9e5>] ? __rt_spin_lock+0x25/0x70
l:  [<c028ddb8>] serio_interrupt+0x38/0x80
l:  [<c028ea5a>] i8042_interrupt+0x10a/0x240
l:  [<c0166b00>] handle_IRQ_event+0x60/0xf0
l:  [<c0330881>] ? add_preempt_count+0x11/0xa0
l:  [<c01678fb>] do_irqd+0x1cb/0x290
l:  [<c0167730>] ? do_irqd+0x0/0x290
l:  [<c0140ce2>] kthread+0x42/0x70
l:  [<c0140ca0>] ? kthread+0x0/0x70


