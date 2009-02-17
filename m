Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbZBQUXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbZBQUXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZBQUXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:23:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35101 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbZBQUXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:23:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthias Reichl <hias@horus.com>
Subject: Re: [Bug #12612] hard lockup when interrupting cdda2wav
Date: Tue, 17 Feb 2009 21:23:12 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <ROx6X68CGJG.A.NoH.m40lJB@chimera> <20090217171601.GA3351@horus.com>
In-Reply-To: <20090217171601.GA3351@horus.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902172123.13052.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 February 2009, Matthias Reichl wrote:
> The bug is still present in 2.6.28.5:
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.28.5-dbg #1
> ---------------------------------------------
> swapper/0 is trying to acquire lock:
>  (&q->__queue_lock){.+..}, at: [<ffffffff8040e615>] blk_put_request+0x25/0x60
> 
> but task is already holding lock:
>  (&q->__queue_lock){.+..}, at: [<ffffffff8040e4fa>] blk_end_io+0x5a/0xa0
> 
> other info that might help us debug this:
> 1 lock held by swapper/0:
>  #0:  (&q->__queue_lock){.+..}, at: [<ffffffff8040e4fa>] blk_end_io+0x5a/0xa0
> 
> stack backtrace:
> Pid: 0, comm: swapper Not tainted 2.6.28.5-dbg #1
> Call Trace:
>  <IRQ>  [<ffffffff8026cd07>] __lock_acquire+0x1797/0x1930
>  [<ffffffff806abf8b>] error_exit+0x29/0xa9
>  [<ffffffff80521f40>] sg_rq_end_io+0x0/0x2e0
>  [<ffffffff8026cf3a>] lock_acquire+0x9a/0xe0
>  [<ffffffff8040e615>] blk_put_request+0x25/0x60
>  [<ffffffff806ab973>] _spin_lock_irqsave+0x43/0x90
>  [<ffffffff8040e615>] blk_put_request+0x25/0x60
>  [<ffffffff8040e615>] blk_put_request+0x25/0x60
>  [<ffffffff80520a94>] sg_finish_rem_req+0xa4/0x100
>  [<ffffffff805221b8>] sg_rq_end_io+0x278/0x2e0
>  [<ffffffff8040e2a1>] end_that_request_last+0x61/0x260
>  [<ffffffff8040e508>] blk_end_io+0x68/0xa0
>  [<ffffffff80508181>] scsi_end_request+0x41/0xd0
>  [<ffffffff80508870>] scsi_io_completion+0x130/0x470
>  [<ffffffff80413405>] blk_done_softirq+0x75/0x90
>  [<ffffffff802488ab>] __do_softirq+0x9b/0x180
>  [<ffffffff80213df3>] native_sched_clock+0x13/0x70
>  [<ffffffff8020d6ec>] call_softirq+0x1c/0x30
>  [<ffffffff8020f175>] do_softirq+0x65/0xa0
>  [<ffffffff80248345>] irq_exit+0xa5/0xb0
>  [<ffffffff8020f467>] do_IRQ+0x107/0x1d0
>  [<ffffffff8020c7fb>] ret_from_intr+0x0/0xf
>  <EOI>  [<ffffffff80214ba6>] mwait_idle+0x56/0x60
>  [<ffffffff80214b9d>] mwait_idle+0x4d/0x60
>  [<ffffffff8020b353>] cpu_idle+0x63/0xc0

Thanks for the update.

Rafael
