Return-Path: <linux-kernel-owner+w=401wt.eu-S1760409AbZEMVVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409AbZEMVVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 17:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZEMVVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 17:21:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:46959 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbZEMVVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 17:21:20 -0400
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <B2706AD9-61E9-49E2-8EA4-6DB69B608658@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1242249131-25014-1-git-send-email-galak@kernel.crashing.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] sata_fsl: Fix compile warnings
Date: Wed, 13 May 2009 16:20:11 -0500
References: <1242249131-25014-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 13, 2009, at 4:12 PM, Kumar Gala wrote:

> We we build with dma_addr_t as a 64-bit quantity we get:
>
> drivers/ata/sata_fsl.c: In function 'sata_fsl_fill_sg':
> drivers/ata/sata_fsl.c:340: warning: format '%x' expects type  
> 'unsigned int', but argument 4 has type 'dma_addr_t'
>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> drivers/ata/sata_fsl.c |    7 ++++---
> 1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
> index c2e90e1..c7ee52d 100644
> --- a/drivers/ata/sata_fsl.c
> +++ b/drivers/ata/sata_fsl.c
> @@ -332,13 +332,14 @@ static unsigned int sata_fsl_fill_sg(struct  
> ata_queued_cmd *qc, void *cmd_desc,
> 		dma_addr_t sg_addr = sg_dma_address(sg);
> 		u32 sg_len = sg_dma_len(sg);
>
> -		VPRINTK("SATA FSL : fill_sg, sg_addr = 0x%x, sg_len = %d\n",
> -			sg_addr, sg_len);
> +		VPRINTK("SATA FSL : fill_sg, sg_addr = 0x%llx, sg_len = %d\n",
> +			(unsigned long long)sg_addr, sg_len);
>
> 		/* warn if each s/g element is not dword aligned */
> 		if (sg_addr & 0x03)
> 			ata_port_printk(qc->ap, KERN_ERR,
> -					"s/g addr unaligned : 0x%x\n", sg_addr);
> +					"s/g addr unaligned : 0x%llxx\n",

You have an extra "x" in there....

Cheers,
B

