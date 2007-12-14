Return-Path: <linux-kernel-owner+w=401wt.eu-S934768AbXLNAEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934768AbXLNAEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932298AbXLNADt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:03:49 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37273 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932219AbXLNADs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:03:48 -0500
Date: Fri, 14 Dec 2007 01:03:50 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Print taint info in more places.
Message-ID: <20071214000350.GK21616@stusta.de>
References: <20071213224927.GA18639@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071213224927.GA18639@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 05:49:27PM -0500, Dave Jones wrote:
> We've found in the past that various bug reports have had minimal
> information, just a few printk's rather than a complete oops,
> and it's taken several round-trips with the bug reporter before
> we've discovered they had some proprietary module loaded.
> 
> The patches below adds dumping of the tainted state to some
> extra parts of the kernel that report 'bad things' happening.
> These patches have been in the Fedora kernel for some time now,
> and have proved useful often.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> 
> --- linux-2.6/include/asm-generic/bug.h~	2007-02-12 16:18:21.000000000 -0500
> +++ linux-2.6/include/asm-generic/bug.h	2007-02-12 16:19:57.000000000 -0500
> @@ -3,6 +3,10 @@
>  
>  #include <linux/compiler.h>
>  
> +#ifndef __ASSEMBLY__
> +extern const char *print_tainted(void);
> +#endif
> +
>  #ifdef CONFIG_BUG
>  
>  #ifdef CONFIG_GENERIC_BUG
> @@ -22,7 +26,8 @@ struct bug_entry {
>  
>  #ifndef HAVE_ARCH_BUG
>  #define BUG() do { \
> -	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
> +	printk(KERN_ERR "BUG: failure at %s:%d/%s()! (%s)\n",
> +		__FILE__, __LINE__, __FUNCTION__, print_tainted()); \
>  	panic("BUG!"); \
>  } while (0)
>  #endif
>...

Note that this only changes a handful of architectures and most likely 
not the ones you are interested in.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


