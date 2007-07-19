Return-Path: <linux-kernel-owner+w=401wt.eu-S940825AbXGSRuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940825AbXGSRuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934857AbXGSRt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:49:57 -0400
Received: from emulex.emulex.com ([138.239.112.1]:37252 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669AbXGSRt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:49:56 -0400
Message-ID: <469FA312.7070702@emulex.com>
Date: Thu, 19 Jul 2007 13:44:50 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Florin Malita <fmalita@gmail.com>
CC: James.Bottomley@SteelEye.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] [scsi] lpfc: potential leak in lpfc_sli_hbqbuf_fill_hbqs
References: <469F884B.6010402@gmail.com>
In-Reply-To: <469F884B.6010402@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jul 2007 17:44:50.0964 (UTC) FILETIME=[81DFAD40:01C7CA2C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florin,

Thanks for the effort to create this patch.  Turns out we have already
fixed this, and have it included in our 8.2.2 patch set, which we will be
posting within the next week.

So James, don't pick this patch up, take the larger patch set instead.

Thanks.

-- james s

Florin Malita wrote:
> If lpfc_hbq_alloc() fails, an hbq_buffer is leaked. Found by Coverity 
> (1775).
> 
> Signed-off-by: Florin Malita <fmalita@gmail.com>
> ---
> 
> drivers/scsi/lpfc/lpfc_sli.c |    4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index f4d5a6b..fe16b0c 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -622,8 +622,10 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hba *phba, 
> uint32_t hbqno, uint32_t count)
>             return 1;
>         hbq_buffer->dbuf.virt = lpfc_hbq_alloc(phba, MEM_PRI,
>                             &hbq_buffer->dbuf.phys);
> -        if (hbq_buffer->dbuf.virt == NULL)
> +        if (hbq_buffer->dbuf.virt == NULL) {
> +            kfree(hbq_buffer);
>             return 1;
> +        }
>         hbq_buffer->tag = (i | (hbqno << 16));
>         lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer);
>         lpfc_hbq_defs[hbqno]->buffer_count++;
> 
> 
