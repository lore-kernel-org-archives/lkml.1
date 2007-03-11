Return-Path: <linux-kernel-owner+w=401wt.eu-S933603AbXCKOO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603AbXCKOO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 10:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933640AbXCKOO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 10:14:59 -0400
Received: from emulex.emulex.com ([138.239.112.1]:44267 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933603AbXCKOO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 10:14:58 -0400
Message-ID: <45F40D02.9060900@emulex.com>
Date: Sun, 11 Mar 2007 10:06:58 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Linas Vepstas <linas@austin.ibm.com>
CC: Bino.Sebastian@Emulex.Com, linuxppc-dev@ozlabs.org,
       linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com,
       rlary@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lpfc: avoid double-free during PCI error failure
References: <20070308221911.GC30703@austin.ibm.com>
In-Reply-To: <20070308221911.GC30703@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2007 14:06:59.0458 (UTC) FILETIME=[88F2A620:01C763E6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK...  Looks good...

-- james s


Linas Vepstas wrote:
> Bino, James,
> Please review, sign-off and forward upstream.
> 
> --linas
> 
> 
> If a PCI error is detected that cannot be recovered from, there
> will be a double call of lpfc_pci_remove_one(), with the second call
> resulting in a null-pointer dereference. The first call occurs in 
> lpfc_io_error_detected(), and the second call during pci device 
> remove. This patch eliminates the first call; its un-needed.
> 
> Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
> 
> ----
>  drivers/scsi/lpfc/lpfc_init.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.20-git16/drivers/scsi/lpfc/lpfc_init.c
> ===================================================================
> --- linux-2.6.20-git16.orig/drivers/scsi/lpfc/lpfc_init.c	2007-03-08 15:57:40.000000000 -0600
> +++ linux-2.6.20-git16/drivers/scsi/lpfc/lpfc_init.c	2007-03-08 16:03:18.000000000 -0600
> @@ -1817,10 +1817,9 @@ static pci_ers_result_t lpfc_io_error_de
>  	struct lpfc_sli *psli = &phba->sli;
>  	struct lpfc_sli_ring  *pring;
>  
> -	if (state == pci_channel_io_perm_failure) {
> -		lpfc_pci_remove_one(pdev);
> +	if (state == pci_channel_io_perm_failure)
>  		return PCI_ERS_RESULT_DISCONNECT;
> -	}
> +
>  	pci_disable_device(pdev);
>  	/*
>  	 * There may be I/Os dropped by the firmware.
> 
