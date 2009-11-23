Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZKWSUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZKWSUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbZKWSUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:20:19 -0500
Received: from mail.gmx.net ([213.165.64.20]:53191 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751544AbZKWSUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:20:18 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/7p6kJ/dH7Y9e7j2RKOTpkyqFFEwfkkdXuubeL8q
	cKOCKSsDebnIsG
Date: Mon, 23 Nov 2009 19:20:34 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: drivers/dma/ipu/ipu_idmac.c: use resource_size()
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901EE5BEF@mi8nycmail19.Mi8.com>
Message-ID: <Pine.LNX.4.64.0911231920160.4207@axis700.grange>
References: <BD79186B4FD85F4B8E60E381CAEE190901EE5BEF@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, H Hartley Sweeten wrote:

> Use resource_size() for ioremap.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

> 
> ---
> 
> diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
> index 9a5bc1a..bfa2126 100644
> --- a/drivers/dma/ipu/ipu_idmac.c
> +++ b/drivers/dma/ipu/ipu_idmac.c
> @@ -1771,16 +1771,14 @@ static int __init ipu_probe(struct platform_device *pdev)
>  		ipu_data.irq_fn, ipu_data.irq_err, ipu_data.irq_base);
>  
>  	/* Remap IPU common registers */
> -	ipu_data.reg_ipu = ioremap(mem_ipu->start,
> -				   mem_ipu->end - mem_ipu->start + 1);
> +	ipu_data.reg_ipu = ioremap(mem_ipu->start, resource_size(mem_ipu));
>  	if (!ipu_data.reg_ipu) {
>  		ret = -ENOMEM;
>  		goto err_ioremap_ipu;
>  	}
>  
>  	/* Remap Image Converter and Image DMA Controller registers */
> -	ipu_data.reg_ic = ioremap(mem_ic->start,
> -				  mem_ic->end - mem_ic->start + 1);
> +	ipu_data.reg_ic = ioremap(mem_ic->start, resource_size(mem_ic));
>  	if (!ipu_data.reg_ic) {
>  		ret = -ENOMEM;
>  		goto err_ioremap_ic; 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
