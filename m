Return-Path: <linux-kernel-owner+w=401wt.eu-S935720AbXEVWPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935720AbXEVWPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761717AbXEVWOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:14:49 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59896 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935671AbXEVWOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:14:46 -0400
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
From: Badari Pulavarty <pbadari@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, bhalevy@panasas.com,
       Andrew Morton <akpm@linux-foundation.org>,
       fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
In-Reply-To: <20070521063554.GF14746@kernel.dk>
References: <1179249337.2836.110.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515172001.GB23798@kernel.dk>
	 <1179251020.2836.118.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515175025.GE23798@kernel.dk>
	 <1179349294.16195.6.camel@dyn9047017100.beaverton.ibm.com>
	 <20070517062742.GW23798@kernel.dk>
	 <1179414911.23725.7.camel@dyn9047017100.beaverton.ibm.com>
	 <20070518073525.GD23798@kernel.dk>
	 <1179510664.29302.16.camel@dyn9047017100.beaverton.ibm.com>
	 <20070521061445.GD14746@kernel.dk>  <20070521063554.GF14746@kernel.dk>
Content-Type: text/plain
Date: Tue, 22 May 2007 15:15:08 -0700
Message-Id: <1179872108.29302.55.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 08:35 +0200, Jens Axboe wrote:
> On Mon, May 21 2007, Jens Axboe wrote:
> > On Fri, May 18 2007, Badari Pulavarty wrote:
> > > On Fri, 2007-05-18 at 09:35 +0200, Jens Axboe wrote:
> > > > On Thu, May 17 2007, Badari Pulavarty wrote:
> > > > > On Thu, 2007-05-17 at 08:27 +0200, Jens Axboe wrote:
> > > > > > On Wed, May 16 2007, Badari Pulavarty wrote:
> > > > > > > On Tue, 2007-05-15 at 19:50 +0200, Jens Axboe wrote:
> > > > > > > > On Tue, May 15 2007, Badari Pulavarty wrote:
> > > > > > > > > On Tue, 2007-05-15 at 19:20 +0200, Jens Axboe wrote:
> > > > > > > > > > On Tue, May 15 2007, Badari Pulavarty wrote:
> > > > > > > > > > > On Fri, 2007-05-11 at 15:51 +0200, Jens Axboe wrote:
> > > > > > > > > > > > Hi,
> > > > > > > > > > > > 
> > > > > > > > > > > > Updated version of the patch - this time I'll just attach the patch
> > > > > > > > > > > > file...
> > > > > > > > > > > 
> > > > > > > > > > > Missing scatterlist.h inclusions..
> > > > > > > > > > > 
> > > > > > > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c: In function ???sym_scatter???:
> > > > > > > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: warning: implicit declaration
> > > > > > > > > > > of function ???for_each_sg???
> > > > > > > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: error: expected ???;??? before ???{???
> > > > > > > > > > > token
> > > > > > > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:375: warning: unused variable ???tp???
> > > > > > > > > > > make[3]: *** [drivers/scsi/sym53c8xx_2/sym_glue.o] Error 1
> > > > > > > > > > > 
> > > > > > > > > > > 
> > > > > > > > > > > drivers/scsi/qla2xxx/qla_iocb.c: In function ???qla24xx_build_scsi_iocbs???:
> > > > > > > > > > > drivers/scsi/qla2xxx/qla_iocb.c:678: warning: implicit declaration of
> > > > > > > > > > > function ???for_each_sg???
> > > > > > > > > > > drivers/scsi/qla2xxx/qla_iocb.c:678: error: expected ???;??? before ???{???
> > > > > > > > > > > token
> > > > > > > > > > 
> > > > > > > > > > Thanks, will fix those. What arch? I tested it here.
> > > > > > > > > 
> > > > > > > > > I am playing with them on ppc64.
> > > > > > > > 
> > > > > > > > Ah ok, you need the updated patch series for ppc64 support. Builds fine
> > > > > > > > here on ppc64. See the #sglist branch of the block repo:
> > > > > > > > 
> > > > > > > > git://git.kernel.dk/data/git/linux-2.6-block.git
> > > > > > > > 
> > > > > > > > I can mail you an updated patch, if you want.
> > > > > > > 
> > > > > > > 
> > > > > > > Here is the whole panic stack..
> > > > > > 
> > > > > > Thanks will fix that up, the IDE part is totally untested. Can you try
> > > > > > and backout this patch and see if it boots?
> > > > > 
> > > > > I increased max_segments to 1024 on my qla2200 attached disks and
> > > > > simple "dd" (direct read) resulted in following:
> > > > > 
> > > > > elm3b29:/sys/block/sdd/queue # echo 1024 > max_segments
> > > > > elm3b29:/sys/block/sdd/queue # cat max_hw_sectors_kb > max_sectors_kb
> > > > > elm3b29:/mnt # dd iflag=direct if=./z of=/dev/null bs=512M
> > > > > 
> > > > > Unable to handle kernel paging request at 0000000000001008 RIP:
> > > > >  [<ffffffff8025e7af>] __rmqueue+0x6f/0x120
> > > > 
> > > > Auch, that's a bug. I don't think the oom path has been tested yet,
> > > > perhaps this is hitting it.
> > > > 
> > > > Can you try with this debug patch, plus enable the slab debugging
> > > > helpers (like poisoning)?
> > > > 
> > > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > > index 7456992..a479d1e 100644
> > > > --- a/drivers/scsi/scsi_lib.c
> > > > +++ b/drivers/scsi/scsi_lib.c
> > > > @@ -793,6 +793,7 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
> > > >  	return ret;
> > > >  enomem:
> > > >  	if (ret) {
> > > > +		printk(KERN_ERR "scsi: failed to allocate sg table\n");
> > > >  		/*
> > > >  		 * Free entries chained off ret. Since we were trying to
> > > >  		 * allocate another sglist, we know that all entries are of
> > > > 
> > > 
> > > Not much help. I get all kinds of weird panics.. This time I got (with
> > > the above debug).
> > > 
> > > general protection fault: 0000 [1] SMP
> > > CPU 1
> > > Modules linked in: jfs sg sd_mod qla2xxx firmware_class
> > > scsi_transport_fc scsi_mod vfat fat ipv6 thermal processor fan button
> > > battery ac dm_mod floppy parport_pc lp parport
> > > Pid: 56, comm: kblockd/1 Not tainted 2.6.22-rc1-sg #8
> > > RIP: 0010:[<ffffffff802816b6>]  [<ffffffff802816b6>] kmem_cache_alloc
> > > +0x36/0x70
> > > RSP: 0018:ffff81017abbfc10  EFLAGS: 00010002
> > > RAX: 0000000000000000 RBX: 0000000000000082 RCX: 0600000000000064
> > > RDX: ffff81019ff2b8a0 RSI: 0000000000011220 RDI: ffffffff8068d120
> > > RBP: ffff81017abbfc20 R08: 00000000000039f8 R09: 0000000000000000
> > > R10: ffff81019cbee700 R11: 0000000000000188 R12: ffff8101df2a64e0
> > > R13: 0000000000011220 R14: ffff8101df2a6510 R15: ffff81017abbfc50
> > > FS:  00002b505b027f20(0000) GS:ffff81018021f300(0000)
> > > knlGS:00000000f7da26b0
> > > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > > CR2: 00002b505b029008 CR3: 000000019af73000 CR4: 00000000000006e0
> > > Process kblockd/1 (pid: 56, threadinfo ffff81017abbe000, task
> > > ffff81017a571440)
> > > Stack:  000000007abbfc30 0000000000000000 ffff81017abbfc30
> > > ffffffff8025d001
> > >  ffff81017abbfcb0 ffffffff8025d122 ffff81017abbfc60 ffffffff80219dc0
> > >  ffffffff880e5da6 00000000000000ad ffff81017abbfcd0 ffffffff8021a366
> > > Call Trace:
> > >  [<ffffffff8025d001>] mempool_alloc_slab+0x11/0x20
> > >  [<ffffffff8025d122>] mempool_alloc+0x42/0x110
> > >  [<ffffffff80219dc0>] flush_gart+0x40/0x50
> > >  [<ffffffff880e5da6>] :scsi_mod:__scsi_get_command+0x26/0x90
> > >  [<ffffffff8021a366>] gart_map_sg+0x2d6/0x3e0
> > 
> > Smells like a bug in the gart modifications, I'll double check them.
> > Does it work if you boot with iommu=off?
> 
> If iommu=off works, can you try a normal boot but with this applied on
> top of the sglist patches? That should fix gart mapping.
> 
> diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
> index 2e22a3a..b16384f 100644
> --- a/arch/x86_64/kernel/pci-gart.c
> +++ b/arch/x86_64/kernel/pci-gart.c

Yes. With this patch + kzalloc() for ide probe took care of all my
problems on x86-64.

But my ppc64 box is still sick :(

Thanks,
Badari

Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=32 NUMA pSeries
Modules linked in: qla2xxx scsi_transport_fc
NIP: c0000000000414a0 LR: c00000000004162c CTR: 0000000000000001
REGS: c0000000047bb130 TRAP: 0300   Not tainted  (2.6.22-rc1)
MSR: 8000000000001032 <ME,IR,DR>  CR: 28000022  XER: 00000008
DAR: 0000000000000000, DSISR: 0000000040000000
TASK = c0000000047a6aa0[0] 'swapper' THREAD: c0000000047b8000 CPU: 7
GPR00: 0000000000000080 c0000000047bb3b0 c000000000692358 c0000000047a6aa0
GPR04: 0000000000000000 0000000000000070 0000000000000000 c0000000005ac0b8
GPR08: 000000000000e4b4 0000000000000001 0000000000000000 0000000000000280
GPR12: 0000000000000020 c0000000005a3e80 0000000000000000 0000000007a8dd70
GPR16: 0000000000000000 0000000000000000 0000000000000000 c0000000047b8000
GPR20: 000000003b9aca00 c0000000047a6c50 0000000000000001 0000000000000000
GPR24: d000000000909048 0001dee6d30c0d30 c000000003b7dd80 c0000000047a6aa0
GPR28: 00000001079027ca c0000000047a6aa0 c0000000005b7cb0 c000000000472c9c
NIP [c0000000000414a0] .dequeue_task+0x0/0x9c
LR [c00000000004162c] .deactivate_task+0x40/0x60
Call Trace:
[c0000000047bb3b0] [c00000000004bccc] .printk+0x38/0x48 (unreliable)
[c0000000047bb440] [c000000000471704] .schedule+0x1fc/0x8dc
[c0000000047bb540] [c000000000472c9c] .schedule_timeout+0xa8/0xe8
[c0000000047bb610] [c000000000057260] .msleep+0x20/0x38
[c0000000047bb690] [c00000000003f5ec] .eeh_dn_check_failure+0x114/0x268
[c0000000047bb740] [c00000000003fc64] .eeh_check_failure+0xec/0x114
[c0000000047bb7c0] [d00000000086190c] .qla2300_fw_dump+0x1130/0x1c00 [qla2xxx]
[c0000000047bb8a0] [d000000000858d50] .qla2300_intr_handler+0x1e8/0x60c [qla2xxx]
[c0000000047bb950] [c000000000078368] .handle_IRQ_event+0x70/0xe4
[c0000000047bb9f0] [c00000000007a7e0] .handle_fasteoi_irq+0x11c/0x1d0
[c0000000047bba90] [c00000000000c178] .do_IRQ+0x90/0xec
[c0000000047bbb10] [c000000000004790] hardware_interrupt_entry+0x18/0x1c
--- Exception: 501 at .ppc64_runlatch_off+0x20/0x50
    LR = .pseries_dedicated_idle_sleep+0x88/0x11c
[c0000000047bbe00] [c0000000047bbe80] 0xc0000000047bbe80 (unreliable)
[c0000000047bbe80] [c0000000000108f4] .cpu_idle+0xc8/0x118
[c0000000047bbf00] [c000000000024f64] .start_secondary+0x160/0x184
[c0000000047bbf90] [c0000000000083c0] .start_secondary_prolog+0xc/0x10
Instruction dump:
2f830000 419d0008 38600001 78630020 4e800020 38000014 7c6903d6 2f830000
419d0008 38600001 78630020 4e800020 <81240000> 39030030 3c000020 3d400010
Kernel panic - not syncing: Fatal exception in interrupt
------------[ cut here ]------------
Badness at arch/powerpc/kernel/smp.c:202
Call Trace:
[c0000000047ba9b0] [c00000000000e650] .show_stack+0x68/0x1b0 (unreliable)
[c0000000047baa50] [c00000000029eca0] .report_bug+0x94/0xe8
[c0000000047baae0] [c0000000000219f0] .program_check_exception+0x12c/0x568
[c0000000047bab60] [c000000000004a84] program_check_common+0x104/0x180
--- Exception: 700 at .smp_call_function_map+0x30/0x25c
    LR = .panic+0x8c/0x1a4
[c0000000047bae50] [c0000000005e3f48] 0xc0000000005e3f48 (unreliable)
[c0000000047baf00] [c00000000004acc4] .panic+0x8c/0x1a4
[c0000000047bafa0] [c0000000000214f4] .die+0x198/0x1b0
[c0000000047bb040] [c0000000000282c8] .bad_page_fault+0xb8/0xd4
[c0000000047bb0c0] [c000000000004e98] handle_page_fault+0x3c/0x58
--- Exception: 300 at .dequeue_task+0x0/0x9c
    LR = .deactivate_task+0x40/0x60
[c0000000047bb3b0] [c00000000004bccc] .printk+0x38/0x48 (unreliable)
[c0000000047bb440] [c000000000471704] .schedule+0x1fc/0x8dc
[c0000000047bb540] [c000000000472c9c] .schedule_timeout+0xa8/0xe8
[c0000000047bb610] [c000000000057260] .msleep+0x20/0x38
[c0000000047bb690] [c00000000003f5ec] .eeh_dn_check_failure+0x114/0x268
[c0000000047bb740] [c00000000003fc64] .eeh_check_failure+0xec/0x114
[c0000000047bb7c0] [d00000000086190c] .qla2300_fw_dump+0x1130/0x1c00 [qla2xxx]
[c0000000047bb8a0] [d000000000858d50] .qla2300_intr_handler+0x1e8/0x60c [qla2xxx]
[c0000000047bb950] [c000000000078368] .handle_IRQ_event+0x70/0xe4
[c0000000047bb9f0] [c00000000007a7e0] .handle_fasteoi_irq+0x11c/0x1d0
[c0000000047bba90] [c00000000000c178] .do_IRQ+0x90/0xec
[c0000000047bbb10] [c000000000004790] hardware_interrupt_entry+0x18/0x1c
--- Exception: 501 at .ppc64_runlatch_off+0x20/0x50
    LR = .pseries_dedicated_idle_sleep+0x88/0x11c
[c0000000047bbe00] [c0000000047bbe80] 0xc0000000047bbe80 (unreliable)
[c0000000047bbe80] [c0000000000108f4] .cpu_idle+0xc8/0x118
[c0000000047bbf00] [c000000000024f64] .start_secondary+0x160/0x184
[c0000000047bbf90] [c0000000000083c0] .start_secondary_prolog+0xc/0x10


