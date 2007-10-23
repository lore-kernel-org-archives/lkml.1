Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbXJWSph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbXJWSph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXJWSpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:45:21 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8392 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbXJWSpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:45:19 -0400
Date: Tue, 23 Oct 2007 20:45:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Florin Iucha <florin@iucha.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel NULL pointer dereference in blk_rq_map_sg with  v2.6.23-6815-g0895e91
Message-ID: <20071023184514.GF14671@kernel.dk>
References: <20071023124637.GJ7918@iucha.net> <20071023124738.GW5059@kernel.dk> <20071023162850.0b76e410@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023162850.0b76e410@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Jean Delvare wrote:
> Hi Jens,
> 
> On Tue, 23 Oct 2007 14:47:38 +0200, Jens Axboe wrote:
> > On Tue, Oct 23 2007, Florin Iucha wrote:
> > > Jens,
> > > 
> > > This is freshly after booting into this morning's kernel:
> > > 
> > > [   60.656136] Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
> > > [   60.656143]  [<ffffffff80375553>] blk_rq_map_sg+0x10d/0x17c
> > > [   60.656151] PGD 4640067 PUD 46d4067 PMD 0 
> > > [   60.656154] Oops: 0000 [1] SMP 
> > > [   60.656157] CPU 1 
> > > [   60.656159] Modules linked in: sbp2 lp dvb_pll lgdt330x cx88_dvb cx88_vp3054_i2c videobuf_dvb tuner tea5767 td
> > > a8290 tuner_simple mt20xx cx88_alsa cx8802 cx8800 cx88xx ir_common tveeprom videobuf_dma_sg videobuf_core btcx_ri
> > > sc i2c_nforce2 evdev rtc forcedeth ehci_hcd fuse
> > > [   60.656176] Pid: 4250, comm: hald-probe-stor Not tainted 2.6.24-rc0-5 #1
> > > [   60.656178] RIP: 0010:[<ffffffff80375553>]  [<ffffffff80375553>] blk_rq_map_sg+0x10d/0x17c
> > > [   60.656182] RSP: 0018:ffff810004791930  EFLAGS: 00010246
> > > [   60.656184] RAX: 000000000403b000 RBX: 0000000000001000 RCX: 6db6db6db6db6db7
> > > [   60.656187] RDX: 0000000000000000 RSI: ffff810001000000 RDI: 0000000005701000
> > > [   60.656189] RBP: ffff810004791968 R08: 0000000005700000 R09: ffff8100044aa060
> > > [   60.656191] R10: 0000000000000000 R11: ffff8100050dea00 R12: 0000000000002000
> > > [   60.656193] R13: ffff8100060d2700 R14: 0000000000000000 R15: ffffffff807f0000
> > > [   60.656196] FS:  00002b5da088e6e0(0000) GS:ffff810003011500(0000) knlGS:0000000000000000
> > > [   60.656198] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > [   60.656200] CR2: 0000000000000000 CR3: 0000000004568000 CR4: 00000000000006e0
> > > [   60.656202] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > [   60.656204] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > [   60.656207] Process hald-probe-stor (pid: 4250, threadinfo ffff810004790000, task ffff810006312000)
> > > [   60.656208] Stack:  ffff81000607a000 0000000100000001 ffff8100040fa120 ffffffff807fe2c0
> > > [   60.656213]  ffff81000607a000 ffff81000607a000 ffffffff807fe2c0 ffff8100047919a8
> > > [   60.656217]  ffffffff8041bb58 ffff8100047919a8 ffff8100040fa120 ffffffff807fe2c0
> > > [   60.656220] Call Trace:
> > > [   60.656226]  [<ffffffff8041bb58>] ide_map_sg+0x38/0xb0
> > > [   60.656231]  [<ffffffff8042952b>] cdrom_start_read_continuation+0x0/0xb5
> > > [   60.656234]  [<ffffffff80423806>] ide_build_sglist+0x38/0x88
> > > [   60.656238]  [<ffffffff80423885>] ide_build_dmatable+0x2f/0x172
> > > [   60.656241]  [<ffffffff804239fc>] ide_dma_setup+0x34/0xaa
> > > [   60.656245]  [<ffffffff804277e5>] cdrom_start_packet_command+0x5a/0x177
> > > [   60.656249]  [<ffffffff8037fac4>] cfq_dispatch_insert+0x38/0x50
> > > [   60.656253]  [<ffffffff80428339>] ide_do_rw_cdrom+0x423/0x57c
> > > [   60.656257]  [<ffffffff8041c56c>] ide_do_request+0x7a7/0xa74
> > > [   60.656263]  [<ffffffff8023c097>] del_timer+0x52/0x5d
> > > [   60.656267]  [<ffffffff8025d343>] sync_page+0x0/0x45
> > > [   60.656269]  [<ffffffff8041cba0>] do_ide_request+0x1b/0x1d
> > > [   60.656273]  [<ffffffff803778a7>] __generic_unplug_device+0x28/0x2c
> > > [   60.656276]  [<ffffffff80377c6e>] generic_unplug_device+0x20/0x31
> > > [   60.656279]  [<ffffffff803751b1>] blk_backing_dev_unplug+0x16/0x18
> > > [   60.656283]  [<ffffffff8029decc>] block_sync_page+0x42/0x44
> > > [   60.656285]  [<ffffffff8025d37f>] sync_page+0x3c/0x45
> > > [   60.656290]  [<ffffffff805589b8>] __wait_on_bit_lock+0x42/0x79
> > > [   60.656294]  [<ffffffff8025d32f>] __lock_page+0x64/0x6b
> > > [   60.656298]  [<ffffffff8024664b>] wake_bit_function+0x0/0x2a
> > > [   60.656301]  [<ffffffff8025da95>] do_generic_mapping_read+0x1da/0x383
> > > [   60.656304]  [<ffffffff8025d08d>] file_read_actor+0x0/0x137
> > > [   60.656309]  [<ffffffff8025f1af>] generic_file_aio_read+0x11e/0x15d
> > > [   60.656315]  [<ffffffff8027ee59>] do_sync_read+0xe2/0x126
> > > [   60.656318]  [<ffffffff8026b15a>] handle_mm_fault+0x62e/0x65e
> > > [   60.656324]  [<ffffffff80386fcc>] __up_read+0x8f/0x97
> > > [   60.656327]  [<ffffffff80246613>] autoremove_wake_function+0x0/0x38
> > > [   60.656331]  [<ffffffff80559233>] __mutex_lock_slowpath+0x22f/0x23c
> > > [   60.656337]  [<ffffffff8027f5f0>] vfs_read+0xab/0x134
> > > [   60.656341]  [<ffffffff8027f9b5>] sys_read+0x47/0x6f
> > > [   60.656345]  [<ffffffff8020b77e>] system_call+0x7e/0x83
> > > [   60.656349] 
> > > [   60.656350] 
> > > [   60.656350] Code: 49 8b 02 41 c7 42 18 00 00 00 00 49 c7 42 10 00 00 00 00 83 
> > > [   60.656359] RIP  [<ffffffff80375553>] blk_rq_map_sg+0x10d/0x17c
> > > [   60.656362]  RSP <ffff810004791930>
> > > [   60.656363] CR2: 0000000000000000
> > > 
> > > Platform is AMD64 and the userspace is Ubuntu 7/10 Gutsy Gibbon.
> 
> I am seeing something similar with 2.6.23-git18 on x86_64 at boot time.
> 2.6.23-git16 was working fine.
> 
> > This should fix it, sorry about that.
> > 
> > diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
> > index 61c2e39..de5ba47 100644
> > --- a/block/ll_rw_blk.c
> > +++ b/block/ll_rw_blk.c
> > @@ -1351,11 +1351,21 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
> >  new_segment:
> >  			if (!sg)
> >  				sg = sglist;
> > -			else
> > +			else {
> > +				/*
> > +				 * If the driver previously mapped a shorter
> > +				 * list, we could see a termination bit
> > +				 * prematurely unless it fully inits the sg
> > +				 * table on each mapping. We KNOW that there
> > +				 * must be more entries here or the driver
> > +				 * would be buggy, so force clear the
> > +				 * termination bit to avoid doing a full
> > +				 * sg_init_table() in drivers for each command.
> > +				 */
> > +				sg->page_link &= ~0x02;
> >  				sg = sg_next(sg);
> > +			}
> >  
> > -			sg_dma_len(sg) = 0;
> > -			sg_dma_address(sg) = 0;
> >  			sg_set_page(sg, bvec->bv_page);
> >  			sg->length = nbytes;
> >  			sg->offset = bvec->bv_offset;
> > 
> > 
> 
> The patch above indeed fixes the problem for me, as far as I can see.
> Thanks Jens! Can you please push this fix to Linus quickly?

It's already pushed and pulled, so current git should work again...

-- 
Jens Axboe

