Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZBRTfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZBRTfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZBRTev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:34:51 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56179 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbZBRTev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:34:51 -0500
Date: Wed, 18 Feb 2009 14:34:44 -0500
From: Andres Salomon <dilinger@queued.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mmotm] asiliantfb: fix ISO declaration/code warning
Message-ID: <20090218143444.24a4b465@ephemeral>
In-Reply-To: <499C5DB6.5010908@oracle.com>
References: <200902181018.n1IAISW7012483@imap1.linux-foundation.org>
	<499C5DB6.5010908@oracle.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 11:12:54 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Move data declaration before any code:
> 
> drivers/video/asiliantfb.c:515: warning: ISO C90 forbids mixed
> declarations and code
> 
> (from asiliantfb-fix-cmap-memory-leaks.patch)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>


Looks obviously correct to me.

Acked-by: Andres Salomon <dilinger@debian.org>


> ---
>  drivers/video/asiliantfb.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- mmotm-2009-0218-0215.orig/drivers/video/asiliantfb.c
> +++ mmotm-2009-0218-0215/drivers/video/asiliantfb.c
> @@ -507,12 +507,13 @@ static struct fb_var_screeninfo asiliant
>  
>  static int __devinit init_asiliant(struct fb_info *p, unsigned long
> addr) {
> +	int err;
> +
>  	p->fix			= asiliantfb_fix;
>  	p->fix.smem_start	= addr;
>  	p->var			= asiliantfb_var;
>  	p->fbops		= &asiliantfb_ops;
>  	p->flags		= FBINFO_DEFAULT;
> -	int err;
>  
>  	err = fb_alloc_cmap(&p->cmap, 256, 0);
>  	if (err) {
> 
