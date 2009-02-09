Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbZBIGZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbZBIGZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 01:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZBIGZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 01:25:27 -0500
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:28771 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbZBIGZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 01:25:26 -0500
Date: Mon, 9 Feb 2009 07:29:29 +0100
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 5/15] skeletonfb: check
 fb_alloc_cmap return value and handle failure properly
Message-Id: <20090209072929.29589e5d.krzysztof.h1@poczta.fm>
In-Reply-To: <20090207121302.55db6a87@ephemeral>
References: <20090207121302.55db6a87@ephemeral>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 70e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 12:13:02 -0500
Andres Salomon <dilinger@queued.net> wrote:

> 
> Bad example code, no cookie!
> 

It is even worse than you thought.

> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---
>  drivers/video/skeletonfb.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/skeletonfb.c b/drivers/video/skeletonfb.c
> index df53365..a439159 100644
> --- a/drivers/video/skeletonfb.c
> +++ b/drivers/video/skeletonfb.c
> @@ -795,8 +795,9 @@ static int __devinit xxxfb_probe(struct pci_dev *dev,
>      if (!retval || retval == 4)
>  	return -EINVAL;			
>  
> -    /* This has to been done !!! */	
> -    fb_alloc_cmap(&info->cmap, cmap_len, 0);
> +    /* This has to be done! */
> +    if (fb_alloc_cmap(&info->cmap, cmap_len, 0))
> +	return -ENOMEM;
>  	

The info pointer should be freed before the return here ...

>      /* 
>       * The following is done in the case of having hardware with a static 
> @@ -820,8 +821,10 @@ static int __devinit xxxfb_probe(struct pci_dev *dev,
>       */
>      /* xxxfb_set_par(info); */
>  
> -    if (register_framebuffer(info) < 0)
> +    if (register_framebuffer(info) < 0) {
> +	fb_dealloc_cmap(&info->cmap);

... and here.

>  	return -EINVAL;
> +    }
>      printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
>  	   info->fix.id);
>      pci_set_drvdata(dev, info); /* or platform_set_drvdata(pdev, info) */
> -- 


Kind regards,
Krzysztof


----------------------------------------------------------------------
Zostan mistrzem parkowania w Bombaju!
Zagraj >> http://link.interia.pl/f204e 

