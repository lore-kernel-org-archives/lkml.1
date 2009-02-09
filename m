Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbZBIQsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbZBIQsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbZBIQsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:48:17 -0500
Received: from mx1.wp.pl ([212.77.101.5]:53874 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbZBIQsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:48:16 -0500
Date: Mon, 9 Feb 2009 17:52:27 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 4/15] vfb: fix memory leaks in
 removal path
Message-Id: <20090209175227.0bf4961f.krzysztof.h1@wp.pl>
In-Reply-To: <20090207121242.21c07e0e@ephemeral>
References: <20090207121242.21c07e0e@ephemeral>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [gQOU]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 12:12:42 -0500
Andres Salomon <dilinger@queued.net> wrote:

> 
> We were leaking the cmap memory.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>


>  drivers/video/vfb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/vfb.c b/drivers/video/vfb.c
> index 93fe08d..cc919ae 100644
> --- a/drivers/video/vfb.c
> +++ b/drivers/video/vfb.c
> @@ -543,6 +543,7 @@ static int vfb_remove(struct platform_device *dev)
>  	if (info) {
>  		unregister_framebuffer(info);
>  		rvfree(videomemory, videomemorysize);
> +		fb_dealloc_cmap(&info->cmap);
>  		framebuffer_release(info);
>  	}
>  	return 0;
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
