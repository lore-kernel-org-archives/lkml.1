Return-Path: <linux-kernel-owner+w=401wt.eu-S1759839AbYEKVVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839AbYEKVVI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760672AbYEKVUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:20:43 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:32972 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760565AbYEKVUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:20:42 -0400
Date: Sun, 11 May 2008 23:21:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] isdn/capi: return proper errnos on module init
Message-ID: <20080511212117.GB1641@uranus.ravnborg.org>
References: <20080511210707.GA25600@pingi.kke.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511210707.GA25600@pingi.kke.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 11:07:07PM +0200, Karsten Keil wrote:
> cdebug_init is called from kcapi_init which is module initialization function,
> so it must return negative values on errors
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Acked-by: Karsten Keil <kkeil@suse.de>

Hi Karsten.

Lately David Miller has started to include isdn patches
in his netdev tree. So I think you should pass then on to David
and not Andrew.
David or Andrew will correct me if I'm wrong...

	Sam

> ---
> compile tested only
> ---
>  drivers/isdn/capi/capiutil.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/isdn/capi/capiutil.c b/drivers/isdn/capi/capiutil.c
> --- a/drivers/isdn/capi/capiutil.c
> +++ b/drivers/isdn/capi/capiutil.c
> @@ -948,17 +948,17 @@ int __init cdebug_init(void)
>  {
>  	g_cmsg= kmalloc(sizeof(_cmsg), GFP_KERNEL);
>  	if (!g_cmsg)
> -		return ENOMEM;
> +		return -ENOMEM;
>  	g_debbuf = kmalloc(sizeof(_cdebbuf), GFP_KERNEL);
>  	if (!g_debbuf) {
>  		kfree(g_cmsg);
> -		return ENOMEM;
> +		return -ENOMEM;
>  	}
>  	g_debbuf->buf = kmalloc(CDEBUG_GSIZE, GFP_KERNEL);
>  	if (!g_debbuf->buf) {
>  		kfree(g_cmsg);
>  		kfree(g_debbuf);
> -		return ENOMEM;;
> +		return -ENOMEM;;
>  	}
>  	g_debbuf->size = CDEBUG_GSIZE;
>  	g_debbuf->buf[0] = 0;
> -- 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
