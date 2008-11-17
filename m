Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYKQSIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYKQSIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYKQSHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:07:51 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33192 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbYKQSHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:07:50 -0500
Date: Mon, 17 Nov 2008 19:06:04 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: next-20081114: WARNING: at block/blk-barrier.c:246 blk_do_ordered()
Message-ID: <20081117180604.GV26778@kernel.dk>
References: <a4423d670811140556o45f0063dn85f695f74d158b03@mail.gmail.com> <20081115160739.GA26778@kernel.dk> <a4423d670811150925qf74b63dy1ef923347140a8fe@mail.gmail.com> <a4423d670811170739w3cab002aqda014ab87ebed529@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670811170739w3cab002aqda014ab87ebed529@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17 2008, Alexander Beregalov wrote:
> 2008/11/15 Alexander Beregalov <a.beregalov@gmail.com>:
> > 2008/11/15 Jens Axboe <jens.axboe@oracle.com>:
> >> On Fri, Nov 14 2008, Alexander Beregalov wrote:
> >>> WARNING: at block/blk-barrier.c:246 blk_do_ordered+0x22b/0x26a()
> >>> Modules linked in:
> >>> Pid: 0, comm: swapper Not tainted 2.6.28-rc4-next-20081114 #3
> >>> Call Trace:
> >>>  <IRQ>  [<ffffffff80236d63>] warn_on_slowpath+0x58/0x7d
> >>>  [<ffffffff802570e3>] ? mark_lock+0x1c/0x37a
> >>>  [<ffffffff803a69f9>] ? elv_rb_del+0x30/0x4b
> >>>  [<ffffffff803b1092>] ? cfq_remove_request+0x180/0x1d8
> >>>  [<ffffffff803afd03>] ? __cfq_slice_expired+0xd6/0xeb
> >>>  [<ffffffff803afd31>] ? cfq_slice_expired+0x19/0x1b
> >>>  [<ffffffff803b1832>] ? cfq_dispatch_requests+0x2c1/0x37e
> >>>  [<ffffffff803aa98c>] blk_do_ordered+0x22b/0x26a
> >>>  [<ffffffff803a6560>] elv_next_request+0x1d0/0x210
> >>>  [<ffffffff80439c7c>] scsi_request_fn+0x9e/0x539
> >>>  [<ffffffff80255c66>] ? put_lock_stats+0xe/0x27
> >>>  [<ffffffff803a827e>] blk_invoke_request_fn+0x3b/0x6e
> >>>  [<ffffffff803a87fd>] __blk_run_queue+0x25/0x29
> >>>  [<ffffffff803a8822>] blk_run_queue+0x21/0x35
> >>>  [<ffffffff80439509>] scsi_run_queue+0x2cf/0x379
> >>>  [<ffffffff8043a33e>] scsi_next_command+0x36/0x46
> >>>  [<ffffffff8043a509>] scsi_end_request+0x92/0xa4
> >>>  [<ffffffff8043aae7>] scsi_io_completion+0x1a7/0x3ad
> >>>  [<ffffffff80434551>] scsi_finish_command+0xe9/0xf2
> >>>  [<ffffffff8043afd5>] scsi_softirq_done+0x10e/0x117
> >>>  [<ffffffff803ac393>] blk_done_softirq+0x7f/0x8f
> >>>  [<ffffffff8023c173>] __do_softirq+0x70/0x101
> >>>  [<ffffffff8020cc0c>] call_softirq+0x1c/0x28
> >>>  [<ffffffff8020e229>] do_softirq+0x39/0x8a
> >>>  [<ffffffff8023bd78>] irq_exit+0x45/0xa2
> >>>  [<ffffffff8020e53a>] do_IRQ+0x16a/0x19c
> >>>  [<ffffffff8020bceb>] ret_from_intr+0x0/0xf
> >>>  <EOI>  [<ffffffff80212e09>] ? mwait_idle+0x3e/0x48
> >>>  [<ffffffff80212e00>] ? mwait_idle+0x35/0x48
> >>>  [<ffffffff8020a940>] ? cpu_idle+0x51/0xba
> >>>  [<ffffffff80514f9c>] ? rest_init+0x70/0x72
> >>> ---[ end trace 115cb4be7e150bb9 ]---
> >>
> >> I'm assuming this is new with -next and doesn't happen with 2.6.28-rc4?
> > Yes.
> >> Is it reproducible in -next?
> > I have seen it only once yet.
> 
> I have the same warning on 2.6.28-rc5-next-20081117, reproducible on dbench.

How big is the file system, how much ram do you have, what are your
mount options, how many dbench clients, and what dbench version? I tried
reproducing it today with no luck on -git + for-2.6.29.

-- 
Jens Axboe

