Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbYESVmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbYESVmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762027AbYESVm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:42:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38582 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761668AbYESVm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:42:27 -0400
Message-ID: <4831F442.1010600@pobox.com>
Date: Mon, 19 May 2008 17:42:26 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 1/1] [libata] pata-bf54x: Set ATAPI host state machine
 to control IDE device terminate sequence.
References: <1210565536-4026-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1210565536-4026-1-git-send-email-cooloney@kernel.org>
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
> Set ATAPI host state machine to control IDE device terminate sequence.
> Some IDE harddisk may assert terminate sequence in the middle of a
> formal DMA transaction and resume later. Bit DETECT_TERM in ATAPI_CTRL
> register determines whether the ATAPI host state machine or the kernel
> driver should take care of this case.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/ata/pata_bf54x.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
> index 9ab8973..5551610 100644
> --- a/drivers/ata/pata_bf54x.c
> +++ b/drivers/ata/pata_bf54x.c
> @@ -911,7 +911,10 @@ static void bfin_bmdma_start(struct ata_queued_cmd *qc)
>  	/* Reset all transfer count */
>  	ATAPI_SET_CONTROL(base, ATAPI_GET_CONTROL(base) | TFRCNT_RST);
>  
> -		/* Set transfer length to buffer len */
> +	/* Set ATAPI state machine contorl in terminate sequence */
> +	ATAPI_SET_CONTROL(base, ATAPI_GET_CONTROL(base) | END_ON_TERM);
> +
> +	/* Set transfer length to buffer len */
>  	for_each_sg(qc->sg, sg, qc->n_elem, si) {

applied


