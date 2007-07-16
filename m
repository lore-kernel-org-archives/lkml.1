Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbXGPEqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbXGPEqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 00:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbXGPEpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 00:45:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:5697 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbXGPEpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 00:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lVRKAft92u2MDYG3qgfqBbQA+cKfOwVm4oMLuvWrDKG8WJKlxCJphi3mnFhNNUKV1lEje6OigAJgqDW+lULxUXYu6t/o73dzPlncjrYkPEqyi0A1bS7hukpFhVHwG8omSafiWWfSWKFk/C/KTVYwdUXb+R5jgKa817fRdt0jCas=
Date: Mon, 16 Jul 2007 08:45:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Diego Woitasen <diego@woitasen.com.ar>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add KERN_* prefix to printks in bug.h
Message-ID: <20070716044547.GA5734@martell.zuzino.mipt.ru>
References: <11845462192199-git-send-email-diego@woitasen.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11845462192199-git-send-email-diego@woitasen.com.ar>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 09:36:59PM -0300, Diego Woitasen wrote:
> ---
>  include/asm-generic/bug.h |   25 +++++++++++++------------
>  1 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index 7f30cce..6e49266 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -8,22 +8,23 @@
>  #ifdef CONFIG_GENERIC_BUG
>  #ifndef __ASSEMBLY__
>  struct bug_entry {
> -	unsigned long	bug_addr;
> +	unsigned long bug_addr;

Never include unrelated changes.

>  #ifdef CONFIG_DEBUG_BUGVERBOSE
> -	const char	*file;
> -	unsigned short	line;
> +	const char *file;
> +	unsigned short line;
>  #endif
> -	unsigned short	flags;
> +	unsigned short flags;
>  };
> -#endif		/* __ASSEMBLY__ */
> +#endif				/* __ASSEMBLY__ */
>  
>  #define BUGFLAG_WARNING	(1<<0)
> -#endif	/* CONFIG_GENERIC_BUG */
> +#endif				/* CONFIG_GENERIC_BUG */
>  
>  #ifndef HAVE_ARCH_BUG
> -#define BUG() do { \
> -	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
> -	panic("BUG!"); \
> +#define BUG() do { 							\
> +	printk(KERN_EMERG "BUG: failure at %s:%d/%s()!\n",		\
> +		__FILE__, __LINE__, __FUNCTION__); 			\
> +	panic("BUG!"); 							\
>  } while (0)
>  #endif
>  
> @@ -35,15 +36,15 @@ struct bug_entry {
>  #define WARN_ON(condition) ({						\
>  	typeof(condition) __ret_warn_on = (condition);			\
>  	if (unlikely(__ret_warn_on)) {					\
> -		printk("WARNING: at %s:%d %s()\n", __FILE__,		\
> -			__LINE__, __FUNCTION__);			\
> +		printk(KERN_WARNING "WARNING: at %s:%d %s()\n",		\
> +			__FILE__, __LINE__, __FUNCTION__);		\
>  		dump_stack();						\
>  	}								\
>  	unlikely(__ret_warn_on);					\
>  })
>  #endif
>  
> -#else /* !CONFIG_BUG */
> +#else				/* !CONFIG_BUG */
>  #ifndef HAVE_ARCH_BUG
>  #define BUG()
>  #endif

