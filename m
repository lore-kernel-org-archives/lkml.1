Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821Ab0AISxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0AISxx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 13:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954Ab0AISxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 13:53:52 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:53948 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab0AISxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 13:53:52 -0500
Date: Sat, 9 Jan 2010 19:53:47 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: mxc: fix memory leak
Message-ID: <20100109185347.GA8970@buzzloop.caiaq.de>
References: <1263055387-31340-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263055387-31340-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 07:43:07PM +0300, Alexander Beregalov wrote:
> Free pdata before exit.
> Found by cppcheck.
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Acked-by: Daniel Mack <daniel@caiaq.de>


> ---
>  drivers/rtc/rtc-mxc.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
> index 6bd5072..2642e6b 100644
> --- a/drivers/rtc/rtc-mxc.c
> +++ b/drivers/rtc/rtc-mxc.c
> @@ -396,8 +396,10 @@ static int __init mxc_rtc_probe(struct platform_device *pdev)
>  	pdata->ioaddr = ioremap(res->start, resource_size(res));
>  
>  	clk = clk_get(&pdev->dev, "ckil");
> -	if (IS_ERR(clk))
> -		return PTR_ERR(clk);
> +	if (IS_ERR(clk)) {
> +		ret = PTR_ERR(clk);
> +		goto exit_free_pdata;
> +	}
>  
>  	rate = clk_get_rate(clk);
>  	clk_put(clk);
> -- 
> 1.6.6
> 
