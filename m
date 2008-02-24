Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbYBXRHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbYBXRHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYBXRHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:07:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:51429 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYBXRHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:07:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Wl3gdzTpwWQmNk0+aAk8v/E+NHjejcBXH3/1iHPMKKP7xlXousKbK2YaIiZtzUpzTqa/a+3ml4PaR7DydDzz3KEUipKRXr8ZrHBVFx0zT0ShT8xbrdxqco8sh63+osLRQHX9zpF7DdVf5gIuLeiO2r/X5Q2e3K1h2l8nAotpncA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patches] libata fixes
Date: Sun, 24 Feb 2008 18:21:14 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20080224053508.GA17530@havoc.gtf.org>
In-Reply-To: <20080224053508.GA17530@havoc.gtf.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802241821.15052.bzolnier@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 February 2008, Jeff Garzik wrote:

[...]

> Alan Cox (1):
>       pata_atiixp: Use 255 sector limit

AHCI needs sorting too but this deals with the old interface

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>

[...]

>> diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
> index 9623f52..408bdc1 100644
> --- a/drivers/ata/pata_atiixp.c
> +++ b/drivers/ata/pata_atiixp.c
> @@ -227,7 +227,7 @@ static struct scsi_host_template atiixp_sht = {
>  	.queuecommand		= ata_scsi_queuecmd,
>  	.can_queue		= ATA_DEF_QUEUE,
>  	.this_id		= ATA_SHT_THIS_ID,
> -	.sg_tablesize		= LIBATA_MAX_PRD,
> +	.sg_tablesize		= LIBATA_DUMB_MAX_PRD,
>  	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
>  	.emulated		= ATA_SHT_EMULATED,
>  	.use_clustering		= ATA_SHT_USE_CLUSTERING,
> @@ -259,7 +259,7 @@ static struct ata_port_operations atiixp_port_ops = {
>  	.bmdma_stop	= atiixp_bmdma_stop,
>  	.bmdma_status 	= ata_bmdma_status,
>  
> -	.qc_prep 	= ata_qc_prep,
> +	.qc_prep 	= ata_dumb_qc_prep,
>  	.qc_issue	= ata_qc_issue_prot,
>  
>  	.data_xfer	= ata_data_xfer,

This patch doesn't enforce "255 sector limit" but instead:

- limits max PRD table size from 128 entries to 64

- enables quirk needed for some chipsets to split 64K PRD table entry
  on two 32K ones (these chipsets choke on size == 0x0000)

>From the patch description it can't be told whether the patch itself is
correct and only the patch description is bogus...

Alan/Jeff: please elaborate on what the patch is trying to achieve.

Thanks,
Bart
