Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbZGOTA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbZGOTA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 15:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932220AbZGOTA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 15:00:57 -0400
Received: from emulex.emulex.com ([138.239.112.1]:43055 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbZGOTA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 15:00:57 -0400
Message-ID: <4A5E2762.8050502@emulex.com>
Date: Wed, 15 Jul 2009 15:00:50 -0400
From: James Smart <James.Smart@Emulex.Com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SCSI: lpfc, don't dereference NULL
References: <1247520354-32145-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1247520354-32145-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2009 19:00:54.0351 (UTC) FILETIME=[942D85F0:01CA057E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Jiri.

-- james s


Acked-By:  James Smart  <james.smart@emulex.com>


Jiri Slaby wrote:
> When kzalloc fails in lpfc_hba_alloc, don't dereference the NULL by
> lpfc_printf_log. Use dev_err instead.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index fc67cc6..2452dc9 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4130,8 +4130,7 @@ lpfc_hba_alloc(struct pci_dev *pdev)
>  	/* Allocate memory for HBA structure */
>  	phba = kzalloc(sizeof(struct lpfc_hba), GFP_KERNEL);
>  	if (!phba) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"1417 Failed to allocate hba struct.\n");
> +		dev_err(&pdev->dev, "failed to allocate hba struct\n");
>  		return NULL;
>  	}
>  
