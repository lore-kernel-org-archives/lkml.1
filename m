Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0CLEQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 23:16:27 -0500
Received: from kroah.org ([198.145.64.141]:60606 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab0CLEQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 23:16:26 -0500
Date: Thu, 11 Mar 2010 20:15:18 -0800
From: Greg KH <greg@kroah.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kobject: Fix kobject_set_name_vargs()
Message-ID: <20100312041518.GA31394@kroah.com>
References: <1268340652.2845.10.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268340652.2845.10.camel@edumazet-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 09:50:52PM +0100, Eric Dumazet wrote:
> In case of kvasprintf() failure, we can leak old kobject name.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 8115eb1..1247c57 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -222,8 +222,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>  		return 0;
>  
>  	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
> -	if (!kobj->name)
> +	if (!kobj->name) {
> +		kobj->name = old_name;
>  		return -ENOMEM;
> +	}

Are you sure?  I think we've been over this very thing many times in the
past...

Kay, I can't recall the issue here, can you?

thanks,

greg k-h
