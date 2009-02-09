Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbZBIRFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbZBIRFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZBIRFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:05:00 -0500
Received: from mx1.wp.pl ([212.77.101.5]:18786 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbZBIRE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:04:59 -0500
Date: Mon, 9 Feb 2009 18:09:11 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 11/15] tgafb: fix cmap memory leak
Message-Id: <20090209180911.fe7337a8.krzysztof.h1@wp.pl>
In-Reply-To: <20090207121831.11c34988@ephemeral>
References: <20090207121831.11c34988@ephemeral>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [UQMk]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 12:18:31 -0500
Andres Salomon <dilinger@queued.net> wrote:

> 
>  - fix cmap leak when register_framebuffer fails
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>


>  drivers/video/tgafb.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/tgafb.c b/drivers/video/tgafb.c
> index 680642c..a86046f 100644
> --- a/drivers/video/tgafb.c
> +++ b/drivers/video/tgafb.c
> @@ -1663,7 +1663,7 @@ tgafb_register(struct device *dev)
>  	if (register_framebuffer(info) < 0) {
>  		printk(KERN_ERR "tgafb: Could not register framebuffer\n");
>  		ret = -EINVAL;
> -		goto err1;
> +		goto err2;
>  	}
>  
>  	if (tga_bus_pci) {
> @@ -1682,6 +1682,8 @@ tgafb_register(struct device *dev)
>  
>  	return 0;
>  
> + err2:
> +	fb_dealloc_cmap(&info->cmap);
>   err1:
>  	if (mem_base)
>  		iounmap(mem_base);
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
