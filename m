Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbYLCPvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbYLCPvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYLCPvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:51:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:56198 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbYLCPvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:51:13 -0500
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Wolfgang Grandegger <wg@grandegger.com>,
       linux-kernel Kernel <linux-kernel@vger.kernel.org>,
       linux-ppc list <linuxppc-dev@ozlabs.org>, linux-mtd@lists.infradead.org
Message-Id: <4A183575-1142-4EC2-83C4-145E721E6E8D@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20081126163840.GA21669@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH for 2.6.28] NAND: fsl_upm: fix build problem with 2.6.28-rc2
Date: Wed, 3 Dec 2008 09:47:53 -0600
References: <20081126163840.GA21669@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 26, 2008, at 10:38 AM, Anton Vorontsov wrote:

> From: Wolfgang Grandegger <wg@grandegger.com>
>
> The patch fixes following build error:
>
>  CC      drivers/mtd/nand/fsl_upm.o
> drivers/mtd/nand/fsl_upm.c: In function 'fun_chip_init':
> drivers/mtd/nand/fsl_upm.c:168: warning: passing argument 2 of  
> 'of_mtd_parse_partitions' from incompatible pointer type
> drivers/mtd/nand/fsl_upm.c:168: warning: passing argument 3 of  
> 'of_mtd_parse_partitions' from incompatible pointer type
> drivers/mtd/nand/fsl_upm.c:168: error: too many arguments to  
> function 'of_mtd_parse_partitions'
> make[1]: *** [drivers/mtd/nand/fsl_upm.o] Error 1
>
> The breakage was introduced in  
> 69fd3a8d098faf41a04930afa83757c0555ee360
> ("[MTD] remove unused mtd parameter in of_mtd_parse_partitions()").
>
> While at it, also add a check for the of_mtd_parse_partitions() return
> value.
>
> Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> drivers/mtd/nand/fsl_upm.c |    8 +++++---
> 1 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
> index 024e3ff..a83192f 100644
> --- a/drivers/mtd/nand/fsl_upm.c
> +++ b/drivers/mtd/nand/fsl_upm.c
> @@ -163,9 +163,11 @@ static int __devinit fun_chip_init(struct  
> fsl_upm_nand *fun,
> 	ret = parse_mtd_partitions(&fun->mtd, part_types, &fun->parts, 0);
>
> #ifdef CONFIG_MTD_OF_PARTS
> -	if (ret == 0)
> -		ret = of_mtd_parse_partitions(fun->dev, &fun->mtd,
> -					      flash_np, &fun->parts);
> +	if (ret == 0) {
> +		ret = of_mtd_parse_partitions(fun->dev, flash_np, &fun->parts);
> +		if (ret < 0)
> +			goto err;
> +	}
> #endif
> 	if (ret > 0)
> 		ret = add_mtd_partitions(&fun->mtd, fun->parts, ret);
> -- 
> 1.5.6.5

David,

what's going on with this patch?

- k
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

