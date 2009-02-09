Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZBIUWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZBIUWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZBIUWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 15:22:21 -0500
Received: from mx1.wp.pl ([212.77.101.5]:45666 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZBIUWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:22:20 -0500
Date: Mon, 9 Feb 2009 21:26:29 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 14/15] amifb: check fb_alloc_cmap
 return value and handle failure properly
Message-Id: <20090209212629.611bd99d.krzysztof.h1@wp.pl>
In-Reply-To: <20090207121857.6bc5d5bc@ephemeral>
References: <20090207121857.6bc5d5bc@ephemeral>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [QWPk]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 12:18:57 -0500
Andres Salomon <dilinger@queued.net> wrote:

> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

One comment below.

>  drivers/video/amifb.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
> index 100f236..82bedd7 100644
> --- a/drivers/video/amifb.c
> +++ b/drivers/video/amifb.c
> @@ -2437,7 +2437,9 @@ default_chipset:
>  		goto amifb_error;
>  	}
>  
> -	fb_alloc_cmap(&fb_info.cmap, 1<<fb_info.var.bits_per_pixel, 0);
> +	err = fb_alloc_cmap(&fb_info.cmap, 1<<fb_info.var.bits_per_pixel, 0);
> +	if (err)
> +		goto amifb_error;
>  
>  	if (register_framebuffer(&fb_info) < 0) {
>  		err = -EINVAL;
> @@ -2456,7 +2458,8 @@ amifb_error:
>  
>  static void amifb_deinit(void)
>  {
> -	fb_dealloc_cmap(&fb_info.cmap);
> +	if (fb_info.cmap.len)
> +		fb_dealloc_cmap(&fb_info.cmap);

Again, is the "if(fb_info.cmap.len)" needed here?

>  	chipfree();
>  	if (videomemory)
>  		iounmap((void*)videomemory);
> -- 
> 1.5.6.5
> 
