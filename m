Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbYKXMiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbYKXMiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 07:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYKXMiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 07:38:09 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:45887 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbYKXMiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:38:08 -0500
Date: Mon, 24 Nov 2008 13:36:09 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at block/blk-barrier.c:246
Message-ID: <20081124123609.GI26308@kernel.dk>
References: <49281226.4070006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49281226.4070006@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22 2008, Jiri Slaby wrote:
> Hi,
> 
> after running mmotm a while, I got this:
> ------------[ cut here ]------------
> WARNING: at /home/l/latest/xxx/block/blk-barrier.c:246 blk_do_ordered+0x281/0x2e
> 0()
> Modules linked in: usblp usbhid ath5k hid mac80211 floppy cfg80211 rtc_cmos [las
> t unloaded: freq_table]
> Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc5-mm1_64 #477
> Call Trace:
>  <IRQ>  [<ffffffff8023dfef>] warn_on_slowpath+0x5f/0x90
>  [<ffffffff8034a22c>] ? elv_rb_del+0x2c/0x50
>  [<ffffffff80356020>] ? __cfq_slice_expired+0x60/0xe0
>  [<ffffffff80356c9f>] ? cfq_dispatch_requests+0x9f/0x3c0
>  [<ffffffff8034f641>] blk_do_ordered+0x281/0x2e0
>  [<ffffffff80349ff4>] elv_next_request+0x44/0x250
>  [<ffffffff80415a52>] scsi_request_fn+0x72/0x490
>  [<ffffffff8034cac7>] blk_invoke_request_fn+0x47/0x140
>  [<ffffffff8034cc75>] __blk_run_queue+0x25/0x30
>  [<ffffffff8034ccab>] blk_run_queue+0x2b/0x50
>  [<ffffffff80414e2f>] scsi_run_queue+0xdf/0x380
>  [<ffffffff803eca65>] ? put_device+0x15/0x20
>  [<ffffffff8040ef61>] ? __scsi_put_command+0x61/0xa0
>  [<ffffffff8041522d>] scsi_next_command+0x3d/0x60
>  [<ffffffff80415304>] scsi_end_request+0xb4/0xd0
>  [<ffffffff8041543c>] scsi_io_completion+0x11c/0x440
>  [<ffffffff8042308d>] ? ata_qc_complete+0xbd/0x230
>  [<ffffffff8040ec1c>] scsi_finish_command+0xac/0xe0
>  [<ffffffff80415958>] scsi_softirq_done+0xb8/0x140
>  [<ffffffff803513e5>] blk_done_softirq+0x75/0x90
>  [<ffffffff80258769>] ? ktime_get_ts+0x59/0x60
>  [<ffffffff80243d04>] __do_softirq+0x94/0x160
>  [<ffffffff8020d77c>] call_softirq+0x1c/0x30
>  [<ffffffff8020ea15>] do_softirq+0x45/0x80
>  [<ffffffff80243a8d>] irq_exit+0x8d/0xa0
>  [<ffffffff8020ecb9>] do_IRQ+0xc9/0x110
>  [<ffffffff8020ca36>] ret_from_intr+0x0/0xa
>  <EOI>  [<ffffffff80213fe2>] ? default_idle+0x42/0x50
>  [<ffffffff8020ae12>] ? enter_idle+0x22/0x30
>  [<ffffffff8020aebe>] ? cpu_idle+0x5e/0xb0
>  [<ffffffff8057c43c>] ? rest_init+0x5c/0x70
> ---[ end trace 73ac849f8acff99f ]---

The offending patch has been removed, so newer -mm or -next should not
be suffering from this bug.

-- 
Jens Axboe

