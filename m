Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbZCKO2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbZCKO2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbZCKO2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:28:18 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:57830 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbZCKO2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:28:17 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2009 10:28:03 EDT
Message-ID: <49B7CA78.9010807@mnementh.co.uk>
Date: Wed, 11 Mar 2009 14:28:08 +0000
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: linux-kernel@vger.kernel.org, drzeus-wbsd@drzeus.cx,
       akpm@linux-foundation.org
Subject: Re: [PATCH 02/05] tmio_mmc: Fix use after free in remove()
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se> <20090311125903.1563.71042.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090311125903.1563.71042.sendpatchset@rx1.opensource.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:
> From:  Magnus Damm <damm@opensource.se>
> 
> Update the tmio_mmc code to call mmc_free_host() when
> done using the private data. Without this fix the driver
> frees memory and then keeps on using it as private data.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Acked-by: Ian Molton <ian@mnementh.co.uk>

> ---
> 
>  drivers/mmc/host/tmio_mmc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 0010/drivers/mmc/host/tmio_mmc.c
> +++ work/drivers/mmc/host/tmio_mmc.c	2009-03-11 19:24:03.000000000 +0900
> @@ -650,10 +650,10 @@ static int __devexit tmio_mmc_remove(str
>  	if (mmc) {
>  		struct tmio_mmc_host *host = mmc_priv(mmc);
>  		mmc_remove_host(mmc);
> -		mmc_free_host(mmc);
>  		free_irq(host->irq, host);
>  		iounmap(host->ctl);
>  		iounmap(host->cnf);
> +		mmc_free_host(mmc);
>  	}
>  
>  	return 0;
> 

