Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbXJ3PoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbXJ3PoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbXJ3PoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:44:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:41501 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbXJ3PoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=PwEHeB6O9AyfthP5KII06qB3JOhCTS28n/m/VkO7IOCf12l35Q4E9oLc0/ojIQ8vN3wNQnKfFccqHVwYXmW5vrfLoGBotickihN3MBLgJXi+fpijic1bHB8CxrKcyxIguAB+bt7rjlD4wxnnGFw7uAN1Q8MuyQLB/7T/2KaHhnQ=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH] drivers/scsi/lpfc/lpfc_hw.h: Some minor cleanup.
Date: Tue, 30 Oct 2007 15:44:02 +0000
User-Agent: KMail/1.9.1
Cc: James.Bottomley@steeleye.com, James.Smart@emulex.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20071030104816.30937.77821.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20071030104816.30937.77821.sendpatchset@thinktank.campus.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710301544.02765.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007 10:54, Richard Knutsson wrote:
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Diffed against linus-git
> Checked with script/checkpatch.pl
> 
> 
> diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
> index 451accd..6f56528 100644
> --- a/drivers/scsi/lpfc/lpfc_hw.h
> +++ b/drivers/scsi/lpfc/lpfc_hw.h
> @@ -3158,31 +3158,30 @@ struct lpfc_sli2_slim {
>   *
>   * Parameters:
>   * device : struct pci_dev 's device field
> - *
> - * return 1 => TRUE
> - *        0 => FALSE
>   */
> -static inline int
> +static inline bool
>  lpfc_is_LC_HBA(unsigned short device)
>  {
> -	if ((device == PCI_DEVICE_ID_TFLY) ||
> -	    (device == PCI_DEVICE_ID_PFLY) ||
> -	    (device == PCI_DEVICE_ID_LP101) ||
> -	    (device == PCI_DEVICE_ID_BMID) ||
> -	    (device == PCI_DEVICE_ID_BSMB) ||
> -	    (device == PCI_DEVICE_ID_ZMID) ||
> -	    (device == PCI_DEVICE_ID_ZSMB) ||
> -	    (device == PCI_DEVICE_ID_RFLY))
> -		return 1;
> -	else
> -		return 0;
> +	switch (device) {
> +	case PCI_DEVICE_ID_TFLY:
> +	case PCI_DEVICE_ID_PFLY:
> +	case PCI_DEVICE_ID_LP101:
> +	case PCI_DEVICE_ID_BMID:
> +	case PCI_DEVICE_ID_BSMB:
> +	case PCI_DEVICE_ID_ZMID:
> +	case PCI_DEVICE_ID_ZSMB:
> +	case PCI_DEVICE_ID_RFLY:
> +		return true;
> +	}
> +
> +	return false;
>  }

Why is this patch useful? I'd rather do this instead:

-static inline int
+static int

(this function has three callsites, thus de-inlining will
make code smaller)
--
vda
