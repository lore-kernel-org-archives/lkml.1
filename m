Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbXI2OxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbXI2OxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 10:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbXI2OxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 10:53:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:34959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbXI2OxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 10:53:04 -0400
Date: Sat, 29 Sep 2007 07:56:46 -0700
From: Greg KH <gregkh@suse.de>
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] module: return error when mod_sysfs_init() failed
Message-ID: <20070929145646.GB3075@suse.de>
References: <20070929100653.GA4121@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070929100653.GA4121@APFDCB5C>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 07:06:53PM +0900, Akinobu Mita wrote:
> load_module() returns zero when mod_sysfs_init() fails,
> then the module loading will succeed accidentally.
> 
> This patch makes load_module() return error correctly in that case.
> 
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> 
> ---
>  kernel/module.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: 2.6-git/kernel/module.c
> ===================================================================
> --- 2.6-git.orig/kernel/module.c
> +++ 2.6-git/kernel/module.c
> @@ -1782,7 +1782,8 @@ static struct module *load_module(void _
>  	module_unload_init(mod);
>  
>  	/* Initialize kobject, so we can reference it. */
> -	if (mod_sysfs_init(mod) != 0)
> +	err = mod_sysfs_init(mod);
> +	if (err)
>  		goto cleanup;

I must be still asleep this morning, but I think this patch does the
exact same thing as the original code does, right?  Otherwise, this
code would always be failing.

Or do I just need to go get my morning coffee to wake up and see the
problem here?

thanks,

greg k-h
