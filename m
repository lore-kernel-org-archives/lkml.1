Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbZKCU2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbZKCU2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 15:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZKCU2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 15:28:04 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:37771 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbZKCU2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:28:04 -0500
Message-ID: <4AF0922B.3030701@hiramoto.org>
Date: Tue, 03 Nov 2009 21:27:23 +0100
From: Karl Hiramoto <karl@hiramoto.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090831)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] IXP4xx: Ensure index is positive
References: <4AF08014.4000704@gmail.com>
In-Reply-To: <4AF08014.4000704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> The indexes are signed, make sure they are not negative
> when we read the array elements.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  arch/arm/mach-ixp4xx/common.c     |    2 +-
>  arch/arm/mach-ixp4xx/ixp4xx_npe.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
> index cfd52fb..2df77bc 100644
> --- a/arch/arm/mach-ixp4xx/common.c
> +++ b/arch/arm/mach-ixp4xx/common.c
> @@ -119,7 +119,7 @@ EXPORT_SYMBOL(gpio_to_irq);
>  
>  int irq_to_gpio(int irq)
>  {
> -	int gpio = (irq < 32) ? irq2gpio[irq] : -EINVAL;
> +	int gpio = (irq < 32 && irq >= 0) ? irq2gpio[irq] : -EINVAL;
>  
>  	if (gpio == -1)
>  		return -EINVAL;
> diff --git a/arch/arm/mach-ixp4xx/ixp4xx_npe.c b/arch/arm/mach-ixp4xx/ixp4xx_npe.c
> index 47ac69c..30e1456 100644
> --- a/arch/arm/mach-ixp4xx/ixp4xx_npe.c
> +++ b/arch/arm/mach-ixp4xx/ixp4xx_npe.c
> @@ -667,7 +667,7 @@ err:
>  
>  struct npe *npe_request(int id)
>  {
> -	if (id < NPE_COUNT)
> +	if (id >= 0 && id < NPE_COUNT)
>  		if (npe_tab[id].valid)
>  			if (try_module_get(THIS_MODULE))
>  				return &npe_tab[id];
>
>   
changing npe_request() to unsigned would probably be better and  not add 
to bloat.   If your calling these functions with negative arguments, 
your code is buggy then.
