Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbZELOiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbZELOiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZELOiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:38:08 -0400
Received: from h155.mvista.com ([63.81.120.155]:8639 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750943AbZELOiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:38:06 -0400
Message-ID: <4A0989F0.4060205@ru.mvista.com>
Date: Tue, 12 May 2009 18:38:40 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/14] ide-atapi: switch to rq->resid_len
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com> <1241855134-4984-4-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1241855134-4984-4-git-send-email-petkovbb@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Borislav Petkov wrote:

> Now that we have rq->resid_len, use it to account partial completion
> amount during the lifetime of an rq, decrementing it on each successful
> transfer. As a result, get rid of now unused pc->xferred.

> While at it, remove noisy debug call in ide_prep_sense.

> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

> diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> index cacffd4..1f2af8b 100644
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c

[...]

> @@ -633,8 +631,6 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
>  	} else {
>  		pc = drive->pc;
>  
> -		/* We haven't transferred any data yet */
> -		pc->xferred = 0;
>  
>  		valid_tf = IDE_VALID_DEVICE;
>  		bytes = blk_rq_bytes(rq);

    You forgot to kill the empty line too...

> @@ -643,6 +639,9 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
>  						     : min_t(unsigned int,
>  							     bytes, 63 * 1024));
>  
> +		/* We haven't transferred any data yet */
> +		rq->resid_len = bcount;
> +
>  		if (pc->flags & PC_FLAG_DMA_ERROR) {
>  			pc->flags &= ~PC_FLAG_DMA_ERROR;
>  			ide_dma_off(drive);

MBR, Sergei
