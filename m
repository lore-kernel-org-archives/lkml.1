Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbZBIQzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbZBIQzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZBIQzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:55:45 -0500
Received: from mx1.wp.pl ([212.77.101.5]:63827 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbZBIQzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:55:44 -0500
Date: Mon, 9 Feb 2009 17:59:54 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 7/15] sstfb: check fb_alloc_cmap
 return value and handle failure properly
Message-Id: <20090209175954.fa9e611b.krzysztof.h1@wp.pl>
In-Reply-To: <20090207121457.28550bdd@ephemeral>
References: <20090207121457.28550bdd@ephemeral>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [oWO0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 12:14:57 -0500
Andres Salomon <dilinger@queued.net> wrote:

> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

>  drivers/video/sstfb.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/sstfb.c b/drivers/video/sstfb.c
> index 5b11a00..609d0a5 100644
> --- a/drivers/video/sstfb.c
> +++ b/drivers/video/sstfb.c
> @@ -1421,13 +1421,16 @@ static int __devinit sstfb_probe(struct pci_dev *pdev,
>  		goto fail;
>  	}
>  	
> -	fb_alloc_cmap(&info->cmap, 256, 0);
> +	if (fb_alloc_cmap(&info->cmap, 256, 0)) {
> +		printk(KERN_ERR "sstfb: can't alloc cmap memory.\n");
> +		goto fail;
> +	}
>  
>  	/* register fb */
>  	info->device = &pdev->dev;
>  	if (register_framebuffer(info) < 0) {
>  		printk(KERN_ERR "sstfb: can't register framebuffer.\n");
> -		goto fail;
> +		goto fail_register;
>  	}
>  
>  	sstfb_clear_screen(info);
> @@ -1441,8 +1444,9 @@ static int __devinit sstfb_probe(struct pci_dev *pdev,
>  
>  	return 0;
>  
> -fail:
> +fail_register:
>  	fb_dealloc_cmap(&info->cmap);
> +fail:
>  	iounmap(info->screen_base);
>  fail_fb_remap:
>  	iounmap(par->mmio_vbase);
> -- 
> 1.5.6.5
> 
> 
> ------------------------------------------------------------------------------
> Create and Deploy Rich Internet Apps outside the browser with Adobe(R)AIR(TM)
> software. With Adobe AIR, Ajax developers can use existing skills and code to
> build responsive, highly engaging applications that combine the power of local
> resources and data with the reach of the web. Download the Adobe AIR SDK and
> Ajax docs to start building applications today-http://p.sf.net/sfu/adobe-com
> _______________________________________________
> Linux-fbdev-devel mailing list
> Linux-fbdev-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-fbdev-devel
> 
