Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbXHBQaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbXHBQaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbXHBQ3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:29:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60037 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372AbXHBQ3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:29:52 -0400
Date: Thu, 2 Aug 2007 18:31:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatch warnings
Message-ID: <20070802163108.GA2431@uranus.ravnborg.org>
References: <46AE2459.7080905@googlemail.com> <20070730185124.GA29116@uranus.ravnborg.org> <46AE3C80.7010307@googlemail.com> <46AF9152.2050707@googlemail.com> <20070731204846.GA9985@uranus.ravnborg.org> <46AFB06E.2020401@googlemail.com> <46B1E9D6.80006@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B1E9D6.80006@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 04:27:34PM +0200, Gabriel C wrote:
> 
> >>> WARNING: vmlinux.o(.init.text+0x29d40): Section mismatch: reference to .exit.text:wbsd_release_resources (between 'wbsd_init' and 'wbsd_probe')
> >>> WARNING: vmlinux.o(.init.text+0x29d49): Section mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init' and 'wbsd_probe')
> >>> WARNING: vmlinux.o(.init.text+0x29f28): Section mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init' and 'wbsd_probe')
> >> When a function is marked __exit and used from an init function then the safe choice
> >> is to just remove the __exit marking. Usually this is small functions used
> >> only in error situations.
> >> Should be trivial too.
> > 
> > I'll look at those too
> > 
> >> Sorry - no patch this time. Could you try to look at it yorself then I will review.
> > 
> > Ok I'll try.
> > 
> 
> The warnings gone with this patch but I'm not really sure it is correct.
Looks correct to me.
You drop the __devexit marking for functions used outside __exit.
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
> 
> 
>  drivers/mmc/host/wbsd.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
> index e0c9808..9bf2a87 100644
> --- a/drivers/mmc/host/wbsd.c
> +++ b/drivers/mmc/host/wbsd.c
> @@ -1266,7 +1266,7 @@ static int __devinit wbsd_alloc_mmc(struct device *dev)
>  	return 0;
>  }
>  
> -static void __devexit wbsd_free_mmc(struct device *dev)
> +static void wbsd_free_mmc(struct device *dev)
>  {
>  	struct mmc_host *mmc;
>  	struct wbsd_host *host;
> @@ -1358,7 +1358,7 @@ static int __devinit wbsd_request_region(struct wbsd_host *host, int base)
>  	return 0;
>  }
>  
> -static void __devexit wbsd_release_regions(struct wbsd_host *host)
> +static void wbsd_release_regions(struct wbsd_host *host)
>  {
>  	if (host->base)
>  		release_region(host->base, 8);
> @@ -1434,7 +1434,7 @@ err:
>  		"Falling back on FIFO.\n", dma);
>  }
>  
> -static void __devexit wbsd_release_dma(struct wbsd_host *host)
> +static void wbsd_release_dma(struct wbsd_host *host)
>  {
>  	if (host->dma_addr) {
>  		dma_unmap_single(mmc_dev(host->mmc), host->dma_addr,
> @@ -1484,7 +1484,7 @@ static int __devinit wbsd_request_irq(struct wbsd_host *host, int irq)
>  	return 0;
>  }
>  
> -static void __devexit wbsd_release_irq(struct wbsd_host *host)
> +static void  wbsd_release_irq(struct wbsd_host *host)
>  {
>  	if (!host->irq)
>  		return;
> @@ -1535,7 +1535,7 @@ static int __devinit wbsd_request_resources(struct wbsd_host *host,
>   * Release all resources for the host.
>   */
>  
> -static void __devexit wbsd_release_resources(struct wbsd_host *host)
> +static void wbsd_release_resources(struct wbsd_host *host)
>  {
>  	wbsd_release_dma(host);
>  	wbsd_release_irq(host);
