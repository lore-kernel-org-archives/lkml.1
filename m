Return-Path: <linux-kernel-owner+w=401wt.eu-S1762091AbZCaQgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091AbZCaQgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZCaQgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:36:22 -0400
Received: from smtp-out.google.com ([216.239.33.17]:60185 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZCaQgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:36:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=xyZVkMJrRcx49SOtdW3KP5nrOKQbfFM7wStLis4aVN29IkkCZtwbWafD7IY1kTnjh
	9Bk0iWmuFveupWMyEhMMA==
MIME-Version: 1.0
In-Reply-To: <1238516136-15852-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1238516136-15852-1-git-send-email-anemo@mba.ocn.ne.jp>
Date: Tue, 31 Mar 2009 09:36:15 -0700
Message-ID: <da824cf30903310936p75469518j9bb28421b1ee81b8@mail.gmail.com>
Subject: Re: [PATCH] tx4939ide: remove wmb()
From: Grant Grundler <grundler@google.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 9:15 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> * define CHECK_DMA_MASK
> * remove use of wmb()
>
> Suggested-by: Grant Grundler <grundler@google.com>

Thank you for the attribution!

But I think proper header would be:
    Reported-by: Grant Grundler <grundler@google.com>

But in this case, since i've looked at the code and am under the
illusion I understand it, I'm comfortable with:
    Reviewed-by: Grant Grundler <grundler@google.com>

thanks!
grant

> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
> This patch is against linux-next 20090331.
>
>  drivers/ide/tx4939ide.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
> index cc269c0..48186ae 100644
> --- a/drivers/ide/tx4939ide.c
> +++ b/drivers/ide/tx4939ide.c
> @@ -327,15 +327,15 @@ static int tx4939ide_dma_end(ide_drive_t *drive)
>        /* read and clear the INTR & ERROR bits */
>        dma_stat = tx4939ide_clear_dma_status(base);
>
> -       wmb();
> +#define CHECK_DMA_MASK (ATA_DMA_ACTIVE | ATA_DMA_ERR | ATA_DMA_INTR)
>
>        /* verify good DMA status */
> -       if ((dma_stat & (ATA_DMA_INTR | ATA_DMA_ERR | ATA_DMA_ACTIVE)) == 0 &&
> +       if ((dma_stat & CHECK_DMA_MASK) == 0 &&
>            (ctl & (TX4939IDE_INT_XFEREND | TX4939IDE_INT_HOST)) ==
>            (TX4939IDE_INT_XFEREND | TX4939IDE_INT_HOST))
>                /* INT_IDE lost... bug? */
>                return 0;
> -       return ((dma_stat & (ATA_DMA_INTR | ATA_DMA_ERR | ATA_DMA_ACTIVE)) !=
> +       return ((dma_stat & CHECK_DMA_MASK) !=
>                ATA_DMA_INTR) ? 0x10 | dma_stat : 0;
>  }
>
> --
> 1.5.6.3
>
>
