Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbXKNNG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbXKNNG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 08:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXKNNGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 08:06:48 -0500
Received: from sa2.bezeqint.net ([192.115.104.16]:50029 "EHLO sa2.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbXKNNGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 08:06:48 -0500
Message-ID: <473AE948.4090702@panasas.com>
Date: Wed, 14 Nov 2007 14:25:44 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata_sg_setup_one vs ata_sg_setup?
References: <200711141540.58658.rusty@rustcorp.com.au>
In-Reply-To: <200711141540.58658.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14 2007 at 6:40 +0200, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Hi Jeff,
> 
>     Was looking through libata, and it seems to me that ata_sg_setup is a
> superset of ata_sg_setup_one.  Am I missing something?  Seems like it could
> be simplified.
> 
> My machine never seems to do an ata_sg_setup_one, so this patch isn't really
> tested...
> 
It's not only your machine, it's every ones machines. Since 2.6.18.
But in 2.6.24 the last code user of ata_sg_setup_one was also removed
from libata-scsi.c :
(http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e10b8c3f5f23188e065b1845ba732570eca007fe)
Please see in above commit's comment about this issue.

> Thanks,
> Rusty.
> ---
> Subject: libata: fold ata_queued_cmd single and sg logic
> 
> libata separates the single buffer case from the scatterlist case
> internally.  It's not clear that this is necessary.
> 
> Remove the ATA_QCFLAG_SINGLE flag, and buf_virt pointer, and always
> initialize qc->nbytes in ata_sg_init().
> 
> It's possible that the ATA_QCFLAG_SG and ATA_QCFLAG_DMAMAP flags could
> be entirely removed, and we could use whether qc->__sg is NULL or not.
> 
Yes these flags can be removed and you will find that qc->__sg will
never be NULL, unless it is a DMA_NONE command.

> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff -r 8b1075c7ad47 drivers/ata/libata-core.c
> --- a/drivers/ata/libata-core.c	Tue Nov 13 21:00:47 2007 +1100
> +++ b/drivers/ata/libata-core.c	Wed Nov 14 15:31:07 2007 +1100
> @@ -1648,16 +1648,8 @@ unsigned ata_exec_internal_sg(struct ata
<snip>

Thanks for doing this.

Boaz
