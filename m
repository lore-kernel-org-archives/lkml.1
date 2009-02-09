Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZBIQxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZBIQxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZBIQxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:53:02 -0500
Received: from mx1.wp.pl ([212.77.101.5]:60181 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbZBIQxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:53:00 -0500
Date: Mon, 9 Feb 2009 17:57:10 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 6/15] sm501fb: check fb_alloc_cmap
 return value and handle failure properly
Message-Id: <20090209175710.5a837ec0.krzysztof.h1@wp.pl>
In-Reply-To: <20090207121448.7b18c3fd@ephemeral>
References: <20090207121448.7b18c3fd@ephemeral>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [kZP0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 12:14:48 -0500
Andres Salomon <dilinger@queued.net> wrote:

> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

>  drivers/video/sm501fb.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
> index dcd9879..eb5d73a 100644
> --- a/drivers/video/sm501fb.c
> +++ b/drivers/video/sm501fb.c
> @@ -1525,7 +1525,10 @@ static int sm501fb_init_fb(struct fb_info *fb,
>  	}
>  
>  	/* initialise and set the palette */
> -	fb_alloc_cmap(&fb->cmap, NR_PALETTE, 0);
> +	if (fb_alloc_cmap(&fb->cmap, NR_PALETTE, 0)) {
> +		dev_err(info->dev, "failed to allocate cmap memory\n");
> +		return -ENOMEM;
> +	}
>  	fb_set_cmap(&fb->cmap, fb);
>  
>  	ret = (fb->fbops->fb_check_var)(&fb->var, fb);
> -- 
> 1.5.6.5
> 
