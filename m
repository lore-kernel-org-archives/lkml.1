Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbXJ0T13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbXJ0T13 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 15:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbXJ0T1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 15:27:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53273 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbXJ0T1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 15:27:21 -0400
Date: Sat, 27 Oct 2007 20:21:45 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, axboe@kernel.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scatterlist fallout: drivers/scsi/arm/
Message-ID: <20071027192145.GB22235@flint.arm.linux.org.uk>
References: <20071027184404.GQ8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071027184404.GQ8181@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Already have this one queued for Linus in my tree.

On Sat, Oct 27, 2007 at 07:44:04PM +0100, Al Viro wrote:
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/drivers/scsi/arm/scsi.h b/drivers/scsi/arm/scsi.h
> index 21ba571..2d09fef 100644
> --- a/drivers/scsi/arm/scsi.h
> +++ b/drivers/scsi/arm/scsi.h
> @@ -39,7 +39,7 @@ static inline int next_SCp(struct scsi_pointer *SCp)
>  		SCp->buffer++;
>  		SCp->buffers_residual--;
>  		SCp->ptr = (char *)
> -			 (page_address(SCp->buffer->page) +
> +			 (page_address(sg_page(SCp->buffer)) +
>  			  SCp->buffer->offset);
>  		SCp->this_residual = SCp->buffer->length;
>  	} else {
> @@ -77,7 +77,7 @@ static inline void init_SCp(struct scsi_cmnd *SCpnt)
>  		SCpnt->SCp.buffer = (struct scatterlist *) SCpnt->request_buffer;
>  		SCpnt->SCp.buffers_residual = SCpnt->use_sg - 1;
>  		SCpnt->SCp.ptr = (char *)
> -			 (page_address(SCpnt->SCp.buffer->page) +
> +			 (page_address(sg_page(SCpnt->SCp.buffer)) +
>  			  SCpnt->SCp.buffer->offset);
>  		SCpnt->SCp.this_residual = SCpnt->SCp.buffer->length;
>  		SCpnt->SCp.phase = SCpnt->request_bufflen;

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
