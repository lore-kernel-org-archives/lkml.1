Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbXJZMCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbXJZMCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbXJZMBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:01:54 -0400
Received: from brick.kernel.dk ([87.55.233.238]:13609 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbXJZMBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:01:53 -0400
Date: Fri, 26 Oct 2007 13:59:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Initialise scatter/gather list in sg driver
Message-ID: <20071026115958.GK5155@kernel.dk>
References: <20071025193530.GB20459@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025193530.GB20459@kryten>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25 2007, Anton Blanchard wrote:
> 
> After turning on DEBUG_SG I hit a fail:
> 
> kernel BUG at include/linux/scatterlist.h:50!
> 
> 	sg_build_indirect
> 	sg_build_reserve
> 	sg_open
> 	chrdev_open
> 	__dentry_open
> 	do_filp_open
> 	do_sys_open
> 
> We should initialise the sg list when we allocate it in sg_build_sgat.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index b5fa4f0..f1871ea 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1652,6 +1652,7 @@ sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
>  	schp->buffer = kzalloc(sg_bufflen, gfp_flags);
>  	if (!schp->buffer)
>  		return -ENOMEM;
> +	sg_init_table(schp->buffer, tablesize);
>  	schp->sglist_len = sg_bufflen;
>  	return tablesize;	/* number of scat_gath elements allocated */
>  }

Thanks, applied!

-- 
Jens Axboe

