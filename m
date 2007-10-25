Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbXJYFxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbXJYFxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 01:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXJYFw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 01:52:56 -0400
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:63548 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbXJYFwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 01:52:55 -0400
To: jens.axboe@oracle.com
Cc: g3vbv@blueyonder.co.uk, linux-kernel@vger.kernel.org, tomof@acm.org
Subject: Re: 2.6.24-rc1 oops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20071025102202L.fujita.tomonori@lab.ntt.co.jp>
References: <471FE5E0.9040202@blueyonder.co.uk>
	<20071025102202L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071025145129C.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 25 Oct 2007 14:51:29 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, I should have CC'ed to you.

On Thu, 25 Oct 2007 10:22:02 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Thu, 25 Oct 2007 01:40:00 +0100
> Sid Boyce <g3vbv@blueyonder.co.uk> wrote:
> 
> > x86_64 dual, gcc version 4.2.2 (SUSE Linux).
> > ------------[ cut here ]------------
> > kernel BUG at include/linux/scatterlist.h:50!
> > invalid opcode: 0000 [1] SMP
> > CPU 1
> > Modules linked in: ub crc_itu_t hwmon cdrom soundcore v4l1_compat 
> > videobuf_core btcx_risc ff_memless floppy sg forcedeth ehci_hcd ohci_hcd 
> > sd_mod usbcore jfs edd ext3 mbcache jbd fan pata_jmicron ahci sata_nv 
> > pata_amd libata scsi_mod thermal processor
> > Pid: 0, comm: swapper Not tainted 2.6.24-rc1-smp #1
> > RIP: 0010:[<ffffffff881f3d27>]  [<ffffffff881f3d27>] 
> > :ub:ub_state_sense+0x9a/0x169
> > RSP: 0018:ffff810100697e60  EFLAGS: 00010093
> > RAX: 0000000087654321 RBX: ffff810105d55000 RCX: ffff81011f975540
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff81011f975540
> > RBP: ffff810105d51000 R08: 0000000000000000 R09: ffff810105d55098
> > R10: ffff810001c319b8 R11: 0000000000000286 R12: ffff810105d55098
> > R13: ffff810105d55260 R14: ffff810105d55278 R15: ffff810105d55298
> > FS:  00002afb8597c6f0(0000) GS:ffff810100001800(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: 00002afb8548200f CR3: 000000010615b000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process swapper (pid: 0, threadinfo ffff810100690000, task ffff810100689160)
> > Stack:  0000000000000001 ffff810105d55000 ffff810105d51000 0000000000000000
> >   ffff810105d55260 ffffffff881f4d43 ffff810105919998 ffff810105d553a0
> >   ffff810105d553af ffff810105d55348 0000000000000286 ffff810105d55058
> > Call Trace:
> >   <IRQ>  [<ffffffff881f4d43>] :ub:ub_scsi_action+0x1e3/0x214
> >   [<ffffffff8023a34e>] tasklet_action+0x54/0x97
> >   [<ffffffff8023a261>] __do_softirq+0x65/0xce
> >   [<ffffffff8020d0bc>] call_softirq+0x1c/0x28
> >   [<ffffffff8020e634>] do_softirq+0x2c/0x7d
> >   [<ffffffff8023a1b7>] irq_exit+0x3f/0x84
> >   [<ffffffff8020e7c3>] do_IRQ+0x13e/0x15f
> >   [<ffffffff8020afa0>] default_idle+0x0/0x3d
> >   [<ffffffff8020afa0>] default_idle+0x0/0x3d
> >   [<ffffffff8020c441>] ret_from_intr+0x0/0xa
> >   <EOI>  [<ffffffff8020afc9>] default_idle+0x29/0x3d
> >   [<ffffffff8020b070>] cpu_idle+0x93/0xbb
> 
> Can you try this?
> 
> Thanks,
> 
> diff --git a/drivers/block/ub.c b/drivers/block/ub.c
> index 14143f2..78f158f 100644
> --- a/drivers/block/ub.c
> +++ b/drivers/block/ub.c
> @@ -1428,6 +1428,7 @@ static void ub_state_sense(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
>  	scmd->state = UB_CMDST_INIT;
>  	scmd->nsg = 1;
>  	sg = &scmd->sgv[0];
> +	sg_init_table(sg, UB_MAX_REQ_SG);
>  	sg_set_page(sg, virt_to_page(sc->top_sense));
>  	sg->offset = (unsigned long)sc->top_sense & (PAGE_SIZE-1);
>  	sg->length = UB_SENSE_SIZE;
> @@ -1864,6 +1865,7 @@ static int ub_sync_read_cap(struct ub_dev *sc, struct ub_lun *lun,
>  	cmd->state = UB_CMDST_INIT;
>  	cmd->nsg = 1;
>  	sg = &cmd->sgv[0];
> +	sg_init_table(sg, UB_MAX_REQ_SG);
>  	sg_set_page(sg, virt_to_page(p));
>  	sg->offset = (unsigned long)p & (PAGE_SIZE-1);
>  	sg->length = 8;

Here's a modified version for your sg branch (for sg_set_page API
changes).

-
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ub: add sg_init_table for sense and read capacity commands

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/block/ub.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 5e740e1..08e909d 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -1428,6 +1428,7 @@ static void ub_state_sense(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
 	scmd->state = UB_CMDST_INIT;
 	scmd->nsg = 1;
 	sg = &scmd->sgv[0];
+	sg_init_table(sg, UB_MAX_REQ_SG);
 	sg_set_page(sg, virt_to_page(sc->top_sense), UB_SENSE_SIZE,
 			(unsigned long)sc->top_sense & (PAGE_SIZE-1));
 	scmd->len = UB_SENSE_SIZE;
@@ -1863,6 +1864,7 @@ static int ub_sync_read_cap(struct ub_dev *sc, struct ub_lun *lun,
 	cmd->state = UB_CMDST_INIT;
 	cmd->nsg = 1;
 	sg = &cmd->sgv[0];
+	sg_init_table(sg, UB_MAX_REQ_SG);
 	sg_set_page(sg, virt_to_page(p), 8, (unsigned long)p & (PAGE_SIZE-1));
 	cmd->len = 8;
 	cmd->lun = lun;
-- 
1.5.2.4

