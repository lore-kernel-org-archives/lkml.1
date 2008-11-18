Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbYKRSF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbYKRSF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 13:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbYKRSFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 13:05:13 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:9370 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYKRSFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 13:05:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LHa4ljADc2gzvYeGSB6rL6NOgvYvg3i34/bcLl+gJ9NzVZFP6AuI99IkcUAUXb3Key
         WWy8owY0aejMQrknyPqwgPg/Yjj6WkSRPxisqlsP+XSQA0VjEnCNrlUS5fXiTCOJYxa3
         fXCe/vADbWOTPsUeneihgV+UFhMuTDLBJ/das=
Message-ID: <a4423d670811181005r3bbd99efk5b57a16fc3a7b767@mail.gmail.com>
Date: Tue, 18 Nov 2008 21:05:09 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>,
       "Miquel van Smoorenburg" <mikevs@xs4all.ne>
Subject: Re: next-20081114: WARNING: at block/blk-barrier.c:246 blk_do_ordered()
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
In-Reply-To: <20081117180604.GV26778@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670811140556o45f0063dn85f695f74d158b03@mail.gmail.com>
	 <20081115160739.GA26778@kernel.dk>
	 <a4423d670811150925qf74b63dy1ef923347140a8fe@mail.gmail.com>
	 <a4423d670811170739w3cab002aqda014ab87ebed529@mail.gmail.com>
	 <20081117180604.GV26778@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/17 Jens Axboe <jens.axboe@oracle.com>:
> On Mon, Nov 17 2008, Alexander Beregalov wrote:
>> 2008/11/15 Alexander Beregalov <a.beregalov@gmail.com>:
>> > 2008/11/15 Jens Axboe <jens.axboe@oracle.com>:
>> >> On Fri, Nov 14 2008, Alexander Beregalov wrote:
>> >>> WARNING: at block/blk-barrier.c:246 blk_do_ordered+0x22b/0x26a()
>> >>> Modules linked in:
>> >>> Pid: 0, comm: swapper Not tainted 2.6.28-rc4-next-20081114 #3
>> >>> Call Trace:
>> >>>  <IRQ>  [<ffffffff80236d63>] warn_on_slowpath+0x58/0x7d
>> >>>  [<ffffffff802570e3>] ? mark_lock+0x1c/0x37a
>> >>>  [<ffffffff803a69f9>] ? elv_rb_del+0x30/0x4b
>> >>>  [<ffffffff803b1092>] ? cfq_remove_request+0x180/0x1d8
>> >>>  [<ffffffff803afd03>] ? __cfq_slice_expired+0xd6/0xeb
>> >>>  [<ffffffff803afd31>] ? cfq_slice_expired+0x19/0x1b
>> >>>  [<ffffffff803b1832>] ? cfq_dispatch_requests+0x2c1/0x37e
>> >>>  [<ffffffff803aa98c>] blk_do_ordered+0x22b/0x26a
>> >>>  [<ffffffff803a6560>] elv_next_request+0x1d0/0x210
>> >>>  [<ffffffff80439c7c>] scsi_request_fn+0x9e/0x539
>> >>>  [<ffffffff80255c66>] ? put_lock_stats+0xe/0x27
>> >>>  [<ffffffff803a827e>] blk_invoke_request_fn+0x3b/0x6e
>> >>>  [<ffffffff803a87fd>] __blk_run_queue+0x25/0x29
>> >>>  [<ffffffff803a8822>] blk_run_queue+0x21/0x35
>> >>>  [<ffffffff80439509>] scsi_run_queue+0x2cf/0x379
>> >>>  [<ffffffff8043a33e>] scsi_next_command+0x36/0x46
>> >>>  [<ffffffff8043a509>] scsi_end_request+0x92/0xa4
>> >>>  [<ffffffff8043aae7>] scsi_io_completion+0x1a7/0x3ad
>> >>>  [<ffffffff80434551>] scsi_finish_command+0xe9/0xf2
>> >>>  [<ffffffff8043afd5>] scsi_softirq_done+0x10e/0x117
>> >>>  [<ffffffff803ac393>] blk_done_softirq+0x7f/0x8f
>> >>>  [<ffffffff8023c173>] __do_softirq+0x70/0x101
>> >>>  [<ffffffff8020cc0c>] call_softirq+0x1c/0x28
>> >>>  [<ffffffff8020e229>] do_softirq+0x39/0x8a
>> >>>  [<ffffffff8023bd78>] irq_exit+0x45/0xa2
>> >>>  [<ffffffff8020e53a>] do_IRQ+0x16a/0x19c
>> >>>  [<ffffffff8020bceb>] ret_from_intr+0x0/0xf
>> >>>  <EOI>  [<ffffffff80212e09>] ? mwait_idle+0x3e/0x48
>> >>>  [<ffffffff80212e00>] ? mwait_idle+0x35/0x48
>> >>>  [<ffffffff8020a940>] ? cpu_idle+0x51/0xba
>> >>>  [<ffffffff80514f9c>] ? rest_init+0x70/0x72
>> >>> ---[ end trace 115cb4be7e150bb9 ]---
>> >>
>> >> I'm assuming this is new with -next and doesn't happen with 2.6.28-rc4?
>> > Yes.
>> >> Is it reproducible in -next?
>> > I have seen it only once yet.
>>
>> I have the same warning on 2.6.28-rc5-next-20081117, reproducible on dbench.
Bisected down to 70bfe2de81b32969db1b4939bf171bbe55bcf1ef
"elevator prevent flushing small requests to device"
>
> How big is the file system, how much ram do you have, what are your
> mount options, how many dbench clients, and what dbench version? I tried
> reproducing it today with no luck on -git + for-2.6.29.

/dev/root on / type xfs (rw,noatime,noquota)
/dev/root             145G
RAM 2G, Swap 3.9G
x86_64 SMP
dbench 3.0.4; 25 clients
