Return-Path: <linux-kernel-owner+w=401wt.eu-S1761888AbXJZMBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761888AbXJZMBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbXJZMAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:00:54 -0400
Received: from brick.kernel.dk ([87.55.233.238]:13601 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbXJZMAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:00:54 -0400
Date: Fri, 26 Oct 2007 13:58:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Initialise scatter/gather list in ata_sg_setup
Message-ID: <20071026115859.GJ5155@kernel.dk>
References: <20071025192959.GA5827@kryten> <20071025193226.GA20459@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025193226.GA20459@kryten>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25 2007, Anton Blanchard wrote:
> 
> (Sorry the subject was incorrect)...
> 
> After turning on DEBUG_SG I hit a fail:
> 
> kernel BUG at include/linux/scatterlist.h:50!
> 
> 	ata_qc_issue
> 	ata_scsi_translate
> 	ipr_queuecommand
> 	scsi_dispatch_cmd
> 	scsi_request_fn
> 	elv_insert
> 	blk_execute_rq_nowait
> 	blk_execute_rq
> 	sg_io
> 	scsi_cmd_ioctl
> 	cdrom_ioctl
> 	sr_block_ioctl
> 	blkdev_driver_ioctl
> 	blkdev_ioctl
> 	block_ioctl
> 	do_ioctl
> 	vfs_ioctl
> 	sys_ioctl
> 	sg_ioctl_trans
> 
> It looks like ata_sg_setup is working on an uninitialised sg table. Call
> sg_init_table to initialise it before use.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> Jens this is against your sg branch. This fixes the fail but Id
> appreciate a confirmation that it's the right fix :)

The patch looks OK, you could also get away with just doing that
sg_init_table() on qc init/alloc.


-- 
Jens Axboe

