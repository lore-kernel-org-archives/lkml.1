Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZBIQrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZBIQrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZBIQrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:47:00 -0500
Received: from mx1.wp.pl ([212.77.101.5]:52054 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbZBIQrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:47:00 -0500
Date: Mon, 9 Feb 2009 17:51:08 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 1/15] fix memory leaks in removal
 path
Message-Id: <20090209175108.1c6c4197.krzysztof.h1@wp.pl>
In-Reply-To: <20090207121215.77e45acf@ephemeral>
References: <20090207121215.77e45acf@ephemeral>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [sdNU]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 12:12:15 -0500
Andres Salomon <dilinger@queued.net> wrote:

> 
> We were leaking both the cmap memory and the info struct memory.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

>  drivers/video/sgivwfb.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/sgivwfb.c b/drivers/video/sgivwfb.c
> index f5252c2..bba5371 100644
> --- a/drivers/video/sgivwfb.c
> +++ b/drivers/video/sgivwfb.c
> @@ -837,6 +837,8 @@ static int sgivwfb_remove(struct platform_device *dev)
>  		iounmap(par->regs);
>  		iounmap(info->screen_base);
>  		release_mem_region(DBE_REG_PHYS, DBE_REG_SIZE);
> +		fb_dealloc_cmap(&info->cmap);
> +		framebuffer_release(info);
>  	}
>  	return 0;
>  }
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
