Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbXDOXxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbXDOXxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 19:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbXDOXxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 19:53:42 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:51593 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754093AbXDOXxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 19:53:40 -0400
Date: Mon, 16 Apr 2007 01:53:48 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Brad Campbell <brad@wasp.net.au>
Cc: lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk, jgarzik@pobox.com,
       linux-ide@vger.kernel.org
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
Message-ID: <20070415235348.GJ3691@stusta.de>
References: <4621FAF0.7000705@wasp.net.au> <46220339.9080205@wasp.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46220339.9080205@wasp.net.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Cc's added, additional information is in http://lkml.org/lkml/2007/4/15/32 ]

On Sun, Apr 15, 2007 at 02:49:29PM +0400, Brad Campbell wrote:
> Brad Campbell wrote:
> >G'day all,
> >
> >All I have is a digital photo of this oops. (It's 3.5mb). I have serial 
> >console configured, but Murphy is watching me carefully and I just can't 
> >seem to reproduce it while logging the console output.
> >
> 
> And as usual, after trying to capture one for 4 days, I get one 10 mins 
> after I've sent the E-mail :)
> 
> I think I've just found a way to make this easier to reproduce as /dev/sdd 
> was not even mounted this
> time. I just cold booted and started an md5sum -c run on a directory of 
> about 180GB.


Is this also present with kernel 2.6.20 or is it a regression?


> [ 2566.192665] BUG: unable to handle kernel NULL pointer dereference at 
> virtual address 0000005c
> [ 2566.218242]  printing eip:
> [ 2566.226362] c0203169
> [ 2566.232906] *pde = 00000000
> [ 2566.241274] Oops: 0000 [#1]
> [ 2566.249637] Modules linked in:
> [ 2566.258832] CPU:    0
> [ 2566.258833] EIP:    0060:[<c0203169>]    Not tainted VLI
> [ 2566.258834] EFLAGS: 00010082   (2.6.21-rc6-git5 #1)
> [ 2566.296146] EIP is at cfq_dispatch_insert+0x19/0x70
> [ 2566.310761] eax: f7a0eae0   ebx: f7a0cb28   ecx: e2f869e8   edx: 00000000
> [ 2566.331076] esi: f79fea7c   edi: f7d04ac0   ebp: 00000000   esp: f6945de0
> [ 2566.351388] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> [ 2566.368843] Process md5sum (pid: 2875, ti=f6944000 task=f68f4ad0 
> task.ti=f6944000)
> [ 2566.390975] Stack: 00000000 f79fea7c f7d04ac0 00000000 c02032d9 f6ae5ef0 
> c0133411 00001000
> [ 2566.416414]        00000008 00000000 00000004 0b582fd4 f79fea7c f7d04ac0 
> f79fea7c 00000000
> [ 2566.441870]        c0203519 f7a0cb28 f7a0cb28 f79e0000 00000282 c01fb7a9 
> 00000000 c016ea4d
> [ 2566.467326] Call Trace:
> [ 2566.475236]  [<c02032d9>] __cfq_dispatch_requests+0x79/0x170
> [ 2566.492224]  [<c0133411>] do_generic_mapping_read+0x281/0x470
> [ 2566.509473]  [<c0203519>] cfq_dispatch_requests+0x69/0x90
> [ 2566.525681]  [<c01fb7a9>] elv_next_request+0x39/0x130
> [ 2566.540850]  [<c016ea4d>] bio_endio+0x5d/0x90
> [ 2566.553942]  [<c0268635>] scsi_request_fn+0x45/0x280
> [ 2566.568851]  [<c01fdde2>] blk_run_queue+0x32/0x70
> [ 2566.582982]  [<c0267ba0>] scsi_next_command+0x30/0x50
> [ 2566.598154]  [<c0267c8b>] scsi_end_request+0x9b/0xc0
> [ 2566.613063]  [<c0267df1>] scsi_io_completion+0x81/0x330
> [ 2566.628751]  [<c0265dab>] scsi_delete_timer+0xb/0x20
> [ 2566.643661]  [<c02770f5>] ata_scsi_qc_complete+0x65/0xd0
> [ 2566.659613]  [<c026d47b>] sd_rw_intr+0x8b/0x220
> [ 2566.673222]  [<c0278ecc>] ata_altstatus+0x1c/0x20
> [ 2566.687352]  [<c027394d>] ata_hsm_move+0x14d/0x3f0
> [ 2566.701744]  [<c0263f80>] scsi_finish_command+0x40/0x60
> [ 2566.717434]  [<c026857f>] scsi_softirq_done+0x6f/0xe0
> [ 2566.732604]  [<c027d521>] sil_interrupt+0x81/0x90
> [ 2566.746733]  [<c01ff9b8>] blk_done_softirq+0x58/0x70
> [ 2566.761644]  [<c011721f>] __do_softirq+0x6f/0x80
> [ 2566.775516]  [<c0117257>] do_softirq+0x27/0x30
> [ 2566.788866]  [<c0104cee>] do_IRQ+0x3e/0x80
> [ 2566.801177]  [<c010322f>] common_interrupt+0x23/0x28
> [ 2566.816090]  =======================
> [ 2566.826793] Code: 3e 05 f0 ff e9 47 ff ff ff 89 f6 8d bc 27 00 00 00 00 
> 83 ec 10 89 1c 24 89 6c
> 24 0c 89 74 24 04 89 7c 24 08 89 c3 89 d5 8b 40 0c <8b> 72 5c 8b 78 04 89 
> d0 e8 4a fa ff ff 8b 45 14
> 89 ea 25 01 80
> [ 2566.886586] EIP: [<c0203169>] cfq_dispatch_insert+0x19/0x70 SS:ESP 
> 0068:f6945de0
> [ 2566.909179] Kernel panic - not syncing: Fatal exception in interrupt

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

