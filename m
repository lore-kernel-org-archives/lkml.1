Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbYFCRYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbYFCRYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYFCRYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:24:00 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:34048 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbYFCRX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:23:59 -0400
Date: Tue, 3 Jun 2008 20:24:15 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Will Newton <will.newton@gmail.com>
Cc: linux-usb@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>, leoli@freescale.com
Subject: Re: [PATCH] fsl_usb2_udc: Add a wmb before priming endpoint.
Message-ID: <20080603172415.GB29125@kedavra.cpe.vivax.com.br>
Reply-To: me@felipebalbi.com
References: <87a5b0800806030820i16b36366qf199e1c56d729fbe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5b0800806030820i16b36366qf199e1c56d729fbe@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 04:20:25PM +0100, Will Newton wrote:
> Add a wmb to fsl_queue_td before priming the endpoint. This ensures that the
> modifications to the QH are seen by the hardware.
> 
> Signed-off-by: Will Newton <will.newton@gmail.com>
> ---
>  drivers/usb/gadget/fsl_usb2_udc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/gadget/fsl_usb2_udc.c
> b/drivers/usb/gadget/fsl_usb2_udc.c
> index 1868754..dd06a5b 100644
> --- a/drivers/usb/gadget/fsl_usb2_udc.c
> +++ b/drivers/usb/gadget/fsl_usb2_udc.c
> @@ -653,6 +653,8 @@ static int fsl_queue_td(struct fsl_ep *ep, struct
> fsl_req *req)
>  			| EP_QUEUE_HEAD_STATUS_HALT));
>  	dQH->size_ioc_int_sts &= temp;
> 
> +	wmb();

checkpatch.pl will complain that there's not comment above the memory
barrier. Could you just add it and in one line summarize why wmb()??

> +
>  	/* Prime endpoint by writing 1 to ENDPTPRIME */
>  	temp = ep_is_in(ep)
>  		? (1 << (ep_index(ep) + 16))
> -- 
> 1.5.5.2



-- 
Best Regards,

Felipe Balbi
me@felipebalbi.com
http://blog.felipebalbi.com
