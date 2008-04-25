Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbYDYFUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbYDYFUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 01:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYDYFUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 01:20:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40791 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbYDYFUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 01:20:36 -0400
Message-ID: <48116A1F.6070907@pobox.com>
Date: Fri, 25 Apr 2008 01:20:31 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 3/3] [libata/BF54x]: Fix compling failure bug - change
 variable's name according to API update
References: <1209094676-20360-1-git-send-email-cooloney@kernel.org> <1209094676-20360-4-git-send-email-cooloney@kernel.org>
In-Reply-To: <1209094676-20360-4-git-send-email-cooloney@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/ata/pata_bf54x.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
> index 4142894..94b818e 100644
> --- a/drivers/ata/pata_bf54x.c
> +++ b/drivers/ata/pata_bf54x.c
> @@ -1342,7 +1342,7 @@ static int bfin_port_start(struct ata_port *ap)
>  inline unsigned int bfin_ata_host_intr(struct ata_port *ap,
>  				   struct ata_queued_cmd *qc)
>  {
> -	struct ata_eh_info *ehi = &ap->eh_info;
> +	struct ata_eh_info *ehi = &ap->link.eh_info;
>  	u8 status, host_stat = 0;
>  
>  	VPRINTK("ata%u: protocol %d task_state %d\n",
> @@ -1443,11 +1443,10 @@ irqreturn_t bfin_ata_interrupt(int irq, void *dev_instance)
>  		    !(ap->flags & ATA_FLAG_DISABLED)) {
>  			struct ata_queued_cmd *qc;
>  
> -			qc = ata_qc_from_tag(ap, ap->active_tag);
> +			qc = ata_qc_from_tag(ap, ap->link.active_tag);
>  			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
>  			    (qc->flags & ATA_QCFLAG_ACTIVE))
>  				handled |= bfin_ata_host_intr(ap, qc);

you need to combine this patch with the first patch, to form a single 
logical whole.

Build fixes should always be folded into the patch that introduces that 
problem (unless the patch is already upstream, of course).  Otherwise, 
you potentially introduce git-bisect breakage.

	Jeff



