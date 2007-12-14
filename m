Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbXLNPjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbXLNPjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbXLNPjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:39:37 -0500
Received: from waste.org ([66.93.16.53]:52068 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbXLNPjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:39:37 -0500
Date: Fri, 14 Dec 2007 09:38:44 -0600
From: Matt Mackall <mpm@selenic.com>
To: Dave Jones <davej@redhat.com>, Adrian Bunk <bunk@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@muc.de>
Subject: Re: Print taint info in more places.
Message-ID: <20071214153844.GS17536@waste.org>
References: <20071213224927.GA18639@redhat.com> <20071214000350.GK21616@stusta.de> <20071214013041.GH22304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214013041.GH22304@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 08:30:41PM -0500, Dave Jones wrote:
>  #ifndef HAVE_ARCH_BUG
>  #define BUG() do { \
> -	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
> +	printk(KERN_ERR "BUG: failure at %s:%d/%s()! (%s)\n",
> +		__FILE__, __LINE__, __FUNCTION__, print_tainted()); \
>  	panic("BUG!"); \
>  } while (0)

Might as well make this inline too, no?

>  #endif
> @@ -32,13 +37,11 @@ struct bug_entry {
>  #endif
>  
>  #ifndef HAVE_ARCH_WARN_ON
> +void out_of_line_warnon(char *file, unsigned int line, const char *func);

How about __warn_on?

> diff --git a/init/main.c b/init/main.c
> index 80b04b6..b1fad76 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -855,3 +855,11 @@ static int __init kernel_init(void * unused)
>  	init_post();
>  	return 0;
>  }
> +
> +void out_of_line_warnon(char *file, unsigned int line, const char *func)

Might as well make *file const too.

> diff --git a/kernel/panic.c b/kernel/panic.c
> index 6f6e03e..198fc58 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -173,6 +173,7 @@ const char *print_tainted(void)
>  		snprintf(buf, sizeof(buf), "Not tainted");
>  	return(buf);
>  }
> +EXPORT_SYMBOL(print_tainted);

Looks like you've got two patches here..

-- 
Mathematics is the supreme nostalgia of our time.
