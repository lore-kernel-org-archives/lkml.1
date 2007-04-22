Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbXDVHh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbXDVHh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbXDVHh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:37:57 -0400
Received: from wasp.net.au ([203.190.192.17]:59621 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbXDVHh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:37:56 -0400
Message-ID: <462B10C3.1030906@wasp.net.au>
Date: Sun, 22 Apr 2007 11:37:39 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Neil Brown <neilb@suse.de>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
References: <4621FAF0.7000705@wasp.net.au> <46220339.9080205@wasp.net.au> <4623FB29.1000603@redhat.com> <17956.22235.574867.179016@notabene.brown> <20070418123757.GC3796@kernel.dk> <46261ACE.1050407@wasp.net.au> <20070418132157.GC3720@kernel.dk>
In-Reply-To: <20070418132157.GC3720@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> 
> Thanks for testing Brad, be sure to use the next patch I sent instead.
> The one from this mail shouldn't even get you booted. So double check
> that you are still using CFQ :-)
> 

[184901.576773] BUG: unable to handle kernel NULL pointer dereference at virtual address 0000005c
[184901.602612]  printing eip:
[184901.610990] c0205399
[184901.617796] *pde = 00000000
[184901.626421] Oops: 0000 [#1]
[184901.635044] Modules linked in:
[184901.644500] CPU:    0
[184901.644501] EIP:    0060:[<c0205399>]    Not tainted VLI
[184901.644503] EFLAGS: 00010082   (2.6.21-rc7 #7)
[184901.681294] EIP is at cfq_dispatch_insert+0x19/0x70
[184901.696168] eax: f7f078e0   ebx: f7ca2794   ecx: 00000004   edx: 00000000
[184901.716743] esi: c1acaa1c   edi: f7c9c6c0   ebp: 00000000   esp: dbaefde0
[184901.737316] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[184901.755032] Process md5sum (pid: 4268, ti=dbaee000 task=f794a5a0 task.ti=dbaee000)
[184901.777422] Stack: 00000000 c1acaa1c f7c9c6c0 00000000 c0205509 e6b61bd8 c0133451 00001000
[184901.803121]        00000008 00000000 00000004 0e713800 c1acaa1c f7c9c6c0 c1acaa1c 00000000
[184901.828837]        c0205749 f7ca2794 f7ca2794 f79bc000 00000282 c01fb829 00000000 c016ea8d
[184901.854552] Call Trace:
[184901.862723]  [<c0205509>] __cfq_dispatch_requests+0x79/0x170
[184901.879971]  [<c0133451>] do_generic_mapping_read+0x281/0x470
[184901.897478]  [<c0205749>] cfq_dispatch_requests+0x69/0x90
[184901.913946]  [<c01fb829>] elv_next_request+0x39/0x130
[184901.929375]  [<c016ea8d>] bio_endio+0x5d/0x90
[184901.942725]  [<c0270375>] scsi_request_fn+0x45/0x280
[184901.957896]  [<c01fde92>] blk_run_queue+0x32/0x70
[184901.972286]  [<c026f8e0>] scsi_next_command+0x30/0x50
[184901.987716]  [<c026f9cb>] scsi_end_request+0x9b/0xc0
[184902.002886]  [<c026fb31>] scsi_io_completion+0x81/0x330
[184902.018835]  [<c026daeb>] scsi_delete_timer+0xb/0x20
[184902.034006]  [<c027ee35>] ata_scsi_qc_complete+0x65/0xd0
[184902.050214]  [<c02751bb>] sd_rw_intr+0x8b/0x220
[184902.064085]  [<c0280c0c>] ata_altstatus+0x1c/0x20
[184902.078475]  [<c027b68d>] ata_hsm_move+0x14d/0x3f0
[184902.093126]  [<c026bcc0>] scsi_finish_command+0x40/0x60
[184902.109075]  [<c02702bf>] scsi_softirq_done+0x6f/0xe0
[184902.124506]  [<c0285f61>] sil_interrupt+0x81/0x90
[184902.138895]  [<c01ffa78>] blk_done_softirq+0x58/0x70
[184902.154066]  [<c011721f>] __do_softirq+0x6f/0x80
[184902.181806]  [<c0104cee>] do_IRQ+0x3e/0x80
[184902.194380]  [<c010322f>] common_interrupt+0x23/0x28
[184902.209551]  =======================
[184902.220512] Code: 0e e3 ef ff e9 47 ff ff ff 89 f6 8d bc 27 00 00 00 00 83 ec 10 89 1c 24 89 6c 
24 0c 89 74 24 04 89 7c 24 08 89 c3 89 d5 8b 40 0c <8b> 72 5c 8b 78
04 89 d0 e8 1a fa ff ff 8b 45 14 89 ea 25 01 80
[184902.280564] EIP: [<c0205399>] cfq_dispatch_insert+0x19/0x70 SS:ESP 0068:dbaefde0
[184902.303418] Kernel panic - not syncing: Fatal exception in interrupt
[184902.322746] Rebooting in 60 seconds..

Ok, it's taken be _ages_ to get the system to a point I can reproduce this, but I think it's now 
reproducible with a couple of hours beating. The bad news is it looks like it has not tickled any of 
your debugging markers! This was the 1st thing printed on a clean serial console, so nothing above 
that for days.

I did double check and I was/am certainly running the kernel with the debug patch compiled in.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
