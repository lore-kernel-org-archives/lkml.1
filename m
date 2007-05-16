Return-Path: <linux-kernel-owner+w=401wt.eu-S1030510AbXEPVBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030510AbXEPVBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934532AbXEPVAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:00:51 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54483 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762249AbXEPVAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:00:49 -0400
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
From: Badari Pulavarty <pbadari@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, bhalevy@panasas.com,
       Andrew Morton <akpm@linux-foundation.org>,
       fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
In-Reply-To: <20070515175025.GE23798@kernel.dk>
References: <20070511135108.GF4629@kernel.dk>
	 <1179249337.2836.110.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515172001.GB23798@kernel.dk>
	 <1179251020.2836.118.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515175025.GE23798@kernel.dk>
Content-Type: text/plain
Date: Wed, 16 May 2007 14:01:34 -0700
Message-Id: <1179349294.16195.6.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-15 at 19:50 +0200, Jens Axboe wrote:
> On Tue, May 15 2007, Badari Pulavarty wrote:
> > On Tue, 2007-05-15 at 19:20 +0200, Jens Axboe wrote:
> > > On Tue, May 15 2007, Badari Pulavarty wrote:
> > > > On Fri, 2007-05-11 at 15:51 +0200, Jens Axboe wrote:
> > > > > Hi,
> > > > > 
> > > > > Updated version of the patch - this time I'll just attach the patch
> > > > > file...
> > > > 
> > > > Missing scatterlist.h inclusions..
> > > > 
> > > > drivers/scsi/sym53c8xx_2/sym_glue.c: In function ???sym_scatter???:
> > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: warning: implicit declaration
> > > > of function ???for_each_sg???
> > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: error: expected ???;??? before ???{???
> > > > token
> > > > drivers/scsi/sym53c8xx_2/sym_glue.c:375: warning: unused variable ???tp???
> > > > make[3]: *** [drivers/scsi/sym53c8xx_2/sym_glue.o] Error 1
> > > > 
> > > > 
> > > > drivers/scsi/qla2xxx/qla_iocb.c: In function ???qla24xx_build_scsi_iocbs???:
> > > > drivers/scsi/qla2xxx/qla_iocb.c:678: warning: implicit declaration of
> > > > function ???for_each_sg???
> > > > drivers/scsi/qla2xxx/qla_iocb.c:678: error: expected ???;??? before ???{???
> > > > token
> > > 
> > > Thanks, will fix those. What arch? I tested it here.
> > 
> > I am playing with them on ppc64.
> 
> Ah ok, you need the updated patch series for ppc64 support. Builds fine
> here on ppc64. See the #sglist branch of the block repo:
> 
> git://git.kernel.dk/data/git/linux-2.6-block.git
> 
> I can mail you an updated patch, if you want.


Here is the whole panic stack..

VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 356k freed
Unable to handle kernel paging request at 00000000464b7948 RIP:
 [<ffffffff80381aa1>] blk_rq_map_sg+0x71/0x1b0
PGD 1df350067 PUD 0
Oops: 0000 [1] SMP
CPU 3
Modules linked in:
Pid: 1, comm: init Not tainted 2.6.22-rc1 #2
RIP: 0010:[<ffffffff80381aa1>]  [<ffffffff80381aa1>] blk_rq_map_sg
+0x71/0x1b0
RSP: 0000:ffff8101a02390e8  EFLAGS: 00010206
RAX: 00000001df36a000 RBX: ffff8101df2efce0 RCX: 00000001df446000
RDX: 0000000000000000 RSI: ffff8101df2eb780 RDI: 00000000001df36a
RBP: ffff8101a0239148 R08: 00000000000004e2 R09: 0000000000000000
R10: ffff8101df2eb780 R11: 0000000000000001 R12: 00000000464b7928
R13: 0000000000001000 R14: 000000000000000e R15: ffff8101df2efcd0
FS:  0000000000000000(0000) GS:ffff8101c0223300(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000464b7948 CR3: 000000017a397000 CR4: 00000000000006e0
Process init (pid: 1, threadinfo ffff8101a0238000, task
ffff81018023a000)
Stack:  0000000000000001 ffff810179c58000 00000001df446000
ffff810179c56060
 ffff8101df2eb780 00000004a02393b8 0100000000000001 ffff8101df2b4000
 ffffffff8078a500 ffff810179c56000 ffffffff8078a500 ffff8101df2b4000
Call Trace:
 [<ffffffff8042faf2>] ide_map_sg+0x42/0xd0
 [<ffffffff804393aa>] ide_build_sglist+0x2a/0x90
 [<ffffffff8043943f>] ide_build_dmatable+0x2f/0x1a0
 [<ffffffff804395f4>] ide_dma_setup+0x44/0xe0
 [<ffffffff8043cdf9>] ide_do_rw_disk+0x349/0x510
 [<ffffffff80430442>] ide_do_request+0x622/0xb40
 [<ffffffff802393a6>] lock_timer_base+0x36/0x70
 [<ffffffff802397cb>] del_timer+0x6b/0x70
 [<ffffffff80430d0d>] do_ide_request+0x1d/0x20
 [<ffffffff80384155>] __generic_unplug_device+0x25/0x30
 [<ffffffff80384315>] blk_start_queueing+0x25/0x30
 [<ffffffff8038c97b>] cfq_insert_request+0x36b/0x380
 [<ffffffff80380980>] elv_insert+0x130/0x1a0
 [<ffffffff80380a58>] __elv_add_request+0x68/0xc0
 [<ffffffff80385383>] __make_request+0xd3/0x590
 [<ffffffff80382db8>] generic_make_request+0x198/0x240
 [<ffffffff802af069>] bio_alloc_bioset+0xa9/0x120
 [<ffffffff80385a52>] submit_bio+0x62/0xe0
 [<ffffffff802b29b2>] mpage_bio_submit+0x22/0x30
 [<ffffffff802b358d>] do_mpage_readpage+0x49d/0x590
 [<ffffffff8026641a>] __inc_zone_page_state+0x2a/0x30
 [<ffffffff802b3898>] mpage_readpages+0x88/0x160
 [<ffffffff802e4b50>] reiserfs_get_block+0x0/0x1250
 [<ffffffff802e4b50>] reiserfs_get_block+0x0/0x1250
 [<ffffffff802e394a>] reiserfs_readpages+0x1a/0x20
 [<ffffffff8026178f>] __do_page_cache_readahead+0x1af/0x2c0
 [<ffffffff8025f7ae>] __alloc_pages+0x6e/0x330
 [<ffffffff80261ca9>] do_page_cache_readahead+0x59/0x80
 [<ffffffff8025cc99>] filemap_nopage+0x239/0x2f0
 [<ffffffff80269100>] __handle_mm_fault+0x1d0/0xba0
 [<ffffffff8021c67c>] do_page_fault+0x1dc/0x950
 [<ffffffff8025f7ae>] __alloc_pages+0x6e/0x330
 [<ffffffff8026573d>] vma_prio_tree_insert+0x2d/0x50
 [<ffffffff8026de22>] vma_link+0xb2/0x140
 [<ffffffff8026d14b>] __vma_link_rb+0x2b/0x30
 [<ffffffff80505bed>] error_exit+0x0/0x84
 [<ffffffff80395aba>] __clear_user+0x1a/0x40
 [<ffffffff80395bfb>] clear_user+0x2b/0x40
 [<ffffffff802bef91>] padzero+0x21/0x30
 [<ffffffff802c0abf>] load_elf_binary+0xbbf/0x1ec0
 [<ffffffff8025f7ae>] __alloc_pages+0x6e/0x330
 [<ffffffff8025f7ae>] __alloc_pages+0x6e/0x330
 [<ffffffff80279c5a>] alloc_pages_current+0x5a/0x90
 [<ffffffff8028aac2>] copy_strings+0x122/0x220
 [<ffffffff8028adaf>] search_binary_handler+0xaf/0x210
 [<ffffffff8028cbff>] do_execve+0x25f/0x290
 [<ffffffff80395bba>] strncpy_from_user+0x3a/0x50
 [<ffffffff80208736>] sys_execve+0x46/0xb0
 [<ffffffff8020a994>] kernel_execve+0x64/0xd0
 [<ffffffff8020707e>] run_init_process+0x1e/0x20
 [<ffffffff8020711f>] init_post+0x9f/0xf0
 [<ffffffff806aeaff>] kernel_init+0x23f/0x330
 [<ffffffff8020a928>] child_rip+0xa/0x12
 [<ffffffff806ae8c0>] kernel_init+0x0/0x330
 [<ffffffff8020a91e>] child_rip+0x0/0x12


Code: 49 8b 44 24 20 49 8d 4c 24 20 48 89 c2 48 83 e2 fe a8 01 48
RIP  [<ffffffff80381aa1>] blk_rq_map_sg+0x71/0x1b0
 RSP <ffff8101a02390e8>
CR2: 00000000464b7948
Kernel panic - not syncing: Attempted to kill init!

Thanks,
Badari

