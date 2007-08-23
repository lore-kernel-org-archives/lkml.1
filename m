Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbXHWFfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbXHWFfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 01:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbXHWFfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 01:35:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:55927 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbXHWFfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 01:35:03 -0400
Date: Wed, 22 Aug 2007 22:34:58 -0700
From: Brandon Philips <brandon@ifup.org>
To: postfail@hushmail.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH resubmit] /drivers/ata ioremap returncode check
Message-ID: <20070823053458.GA4418@ifup.org>
References: <20070823023328.19E6CDA82B@mailserver7.hushmail.com> <159327.52462.qm@web44910.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159327.52462.qm@web44910.mail.sp1.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:47 Wed 22 Aug 2007, Scott Thompson wrote:
> Patchset against 2.6.23-rc3.  corrects missing ioremap return 
> checks, resending after making changes suggested....
> 
> Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
> ------------------------------------------------------------
> diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
> index 4ca7fd6..8dc7c3b 100644
> --- a/drivers/ata/pata_ixp4xx_cf.c
> +++ b/drivers/ata/pata_ixp4xx_cf.c
> @@ -189,6 +189,10 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
>  	data->cs0 = devm_ioremap(&pdev->dev, cs0->start, 0x1000);
>  	data->cs1 = devm_ioremap(&pdev->dev, cs1->start, 0x1000);
>  
> +	if (!data->cs0 || !data->cs1) {
> +		return -ENOMEM;
> +	}
> +

You aren't following the Kernel CodingStyle there.  

See Documentation/CodingStyle:

"Do not unnecessarily use braces where a single statement will do."

+	if (!data->cs0 || !data->cs1)
+		return -ENOMEM;

Thanks,

	Brandon
