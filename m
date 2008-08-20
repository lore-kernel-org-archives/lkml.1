Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbYHTO14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbYHTO14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYHTO1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:27:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:39833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbYHTO1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:27:48 -0400
Date: Wed, 20 Aug 2008 07:24:53 -0700
From: Greg KH <gregkh@suse.de>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/module: fix warning when
	!CONFIG_DYNAMIC_PRINTK_DEBUG
Message-ID: <20080820142453.GA31886@suse.de>
References: <20080820141329.GB7622@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820141329.GB7622@orion>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 06:13:29PM +0400, Alexander Beregalov wrote:
> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> kernel/module.c: In function 'load_module':
> kernel/module.c:1839: warning: unused variable 'value'
> kernel/module.c:1838: warning: unused variable 'iter'
> 
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
> 
>  kernel/module.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 1721320..5a1258e 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1835,8 +1835,10 @@ static struct module *load_module(void __user *umod,
>  	unsigned int markersindex;
>  	unsigned int markersstringsindex;
>  	unsigned int verboseindex;
> +#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
>  	struct mod_debug *iter;
>  	unsigned long value;
> +#endif

Hm, that's not very nice, we try to keep #ifdefs out of the .c file
where ever possible, especially within a single function.  I'll split
the section out of this function that has the #ifdef which should fix
this problem.

thanks,

greg k-h
