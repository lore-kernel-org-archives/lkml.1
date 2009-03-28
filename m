Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbZC1OMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbZC1OMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 10:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZC1OMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 10:12:43 -0400
Received: from mailbackup.inode.at ([213.229.60.24]:59590 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbZC1OMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 10:12:42 -0400
Date: Sat, 28 Mar 2009 15:11:25 +0100
From: Matthias Reichl <hias@horus.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug #12612] hard lockup when interrupting cdda2wav
Message-ID: <20090328141125.GA4061@horus.com>
Mail-Followup-To: Matthias Reichl <hias@horus.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
References: <HPkmj74uawF.A.iqE.M8TxJB@chimera> <fnEpM0mQZjO.A.kXF.l8TxJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fnEpM0mQZjO.A.kXF.l8TxJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 06:07:27PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12612
> Subject		: hard lockup when interrupting cdda2wav
> Submitter	: Matthias Reichl <hias@horus.com>
> Date		: 2009-01-28 16:41 (53 days old)
> References	: http://marc.info/?l=linux-kernel&m=123316111415677&w=4
> Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Patch		: http://marc.info/?l=linux-scsi&m=123371501613019&w=2

The bug is still present in 2.6.28.9 and in 2.6.29 (see backtraces
below).

so long,

Hias

=============================================
[ INFO: possible recursive locking detected ]
2.6.28.9-dbg #1
---------------------------------------------
swapper/0 is trying to acquire lock:
 (&q->__queue_lock){.+..}, at: [<ffffffff8040e3b5>] blk_put_request+0x25/0x60

but task is already holding lock:
 (&q->__queue_lock){.+..}, at: [<ffffffff8040e29a>] blk_end_io+0x5a/0xa0

other info that might help us debug this:
1 lock held by swapper/0:
 #0:  (&q->__queue_lock){.+..}, at: [<ffffffff8040e29a>] blk_end_io+0x5a/0xa0

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.28.9-dbg #1
Call Trace:
 <IRQ>  [<ffffffff8026cd17>] __lock_acquire+0x1797/0x1930
 [<ffffffff8026cf4a>] lock_acquire+0x9a/0xe0
 [<ffffffff8040e3b5>] blk_put_request+0x25/0x60
 [<ffffffff806ab173>] _spin_lock_irqsave+0x43/0x90
 [<ffffffff8040e3b5>] blk_put_request+0x25/0x60
 [<ffffffff8040e3b5>] blk_put_request+0x25/0x60
 [<ffffffff80520644>] sg_finish_rem_req+0xa4/0x100
 [<ffffffff80521d98>] sg_rq_end_io+0x278/0x2e0
 [<ffffffff8040e041>] end_that_request_last+0x61/0x260
 [<ffffffff8040e2a8>] blk_end_io+0x68/0xa0
 [<ffffffff80507da1>] scsi_end_request+0x41/0xd0
 [<ffffffff80508490>] scsi_io_completion+0x130/0x470
 [<ffffffff80413195>] blk_done_softirq+0x75/0x90
 [<ffffffff8024890b>] __do_softirq+0x9b/0x180
 [<ffffffff80213dd3>] native_sched_clock+0x13/0x70
 [<ffffffff8020d6ec>] call_softirq+0x1c/0x30
 [<ffffffff8020f175>] do_softirq+0x65/0xa0
 [<ffffffff802483a5>] irq_exit+0xa5/0xb0
 [<ffffffff8020f467>] do_IRQ+0x107/0x1d0
 [<ffffffff8020c7fb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff80214b86>] mwait_idle+0x56/0x60
 [<ffffffff80214b7d>] mwait_idle+0x4d/0x60
 [<ffffffff8020b353>] cpu_idle+0x63/0xc0


=============================================
[ INFO: possible recursive locking detected ]
2.6.29-dbg #1
---------------------------------------------
swapper/0 is trying to acquire lock:
 (&q->__queue_lock){.+..}, at: [<ffffffff8041a8c5>] blk_put_request+0x25/0x60

but task is already holding lock:
 (&q->__queue_lock){.+..}, at: [<ffffffff8041a7aa>] blk_end_io+0x5a/0xa0

other info that might help us debug this:
1 lock held by swapper/0:
 #0:  (&q->__queue_lock){.+..}, at: [<ffffffff8041a7aa>] blk_end_io+0x5a/0xa0

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.29-dbg #1
Call Trace:
 <IRQ>  [<ffffffff8027109a>] __lock_acquire+0xfda/0x1b70
 [<ffffffff806c1c89>] error_exit+0x29/0xb0
 [<ffffffff80531e30>] sg_rq_end_io+0x0/0x2e0
 [<ffffffff806c4392>] bad_to_user+0xac/0x5c4
 [<ffffffff80271cca>] lock_acquire+0x9a/0xe0
 [<ffffffff8041a8c5>] blk_put_request+0x25/0x60
 [<ffffffff806c1423>] _spin_lock_irqsave+0x43/0x90
 [<ffffffff8041a8c5>] blk_put_request+0x25/0x60
 [<ffffffff8041a8c5>] blk_put_request+0x25/0x60
 [<ffffffff80530934>] sg_finish_rem_req+0xa4/0x100
 [<ffffffff805320a8>] sg_rq_end_io+0x278/0x2e0
 [<ffffffff8041a52a>] end_that_request_last+0x5a/0x280
 [<ffffffff8041a7b8>] blk_end_io+0x68/0xa0
 [<ffffffff805186e6>] scsi_io_completion+0x146/0x520
 [<ffffffff8041fa65>] blk_done_softirq+0x75/0x90
 [<ffffffff8024bcbb>] __do_softirq+0x9b/0x180
 [<ffffffff8020d5fc>] call_softirq+0x1c/0x30
 [<ffffffff8020f145>] do_softirq+0x65/0xb0
 [<ffffffff8024b7e5>] irq_exit+0x85/0xa0
 [<ffffffff8020f3e7>] do_IRQ+0xb7/0x1b0
 [<ffffffff8020ce53>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff80214436>] mwait_idle+0x86/0x90
 [<ffffffff8021442d>] mwait_idle+0x7d/0x90
 [<ffffffff8020b417>] cpu_idle+0x67/0xc0

