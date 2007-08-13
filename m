Return-Path: <linux-kernel-owner+w=401wt.eu-S944399AbXHMO2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944399AbXHMO2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939215AbXHML1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:27:55 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49732 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967618AbXHML1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:27:50 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 13 Aug 2007 05:47:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Surya Prabhakar N <surya.prabhakar@wipro.com>
cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ-resend]replacing kmalloc with kzalloc in drivers/mtd/chips/cfi_probe.c
In-Reply-To: <1186998573.29518.6.camel@bluegenie>
Message-ID: <Pine.LNX.4.64.0708130545510.19318@localhost.localdomain>
References: <1186998573.29518.6.camel@bluegenie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.541, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	SARE_SUB_OBFU_Z 0.26)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Surya Prabhakar N wrote:

>
> Hi,
>    Replacing kmalloc with kzalloc and cleaning up memset in
> drivers/mtd/chips/cfi_probe.c. Kindly ignore the previous similar patch.
>
> Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
> ---
>
> diff --git a/drivers/mtd/chips/cfi_probe.c b/drivers/mtd/chips/cfi_probe.c
> index 60e11a0..efb51f7 100644
> --- a/drivers/mtd/chips/cfi_probe.c
> +++ b/drivers/mtd/chips/cfi_probe.c
> @@ -203,14 +203,12 @@ static int __xipram cfi_chip_setup(struct map_info *map,
>  	if (!num_erase_regions)
>  		return 0;
>
> -	cfi->cfiq = kmalloc(sizeof(struct cfi_ident) + num_erase_regions * 4, GFP_KERNEL);
> +	cfi->cfiq = kzalloc(sizeof(struct cfi_ident) + num_erase_regions * 4, GFP_KERNEL);
>  	if (!cfi->cfiq) {
>  		printk(KERN_WARNING "%s: kmalloc failed for CFI ident structure\n", map->name);
>  		return 0;
>  	}
>
> -	memset(cfi->cfiq,0,sizeof(struct cfi_ident));
> -
>  	cfi->cfi_mode = CFI_MODE_CFI;

but that change is not precisely equivalent, it now clears more than
the original code.  as long as that's not a problem.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
