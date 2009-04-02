Return-Path: <linux-kernel-owner+w=401wt.eu-S934333AbZDBDog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333AbZDBDog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 23:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933045AbZDBDoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 23:44:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:28151 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764164AbZDBDoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 23:44:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nw42xbgI3A3rHiDim6eAmmwu7+FAKUzijOs7/VrvlZ86CjKDu91oGIDy24YBJAH+My
         sRcbC20oOvFXR7z45ZAHTasr/uDuz0Rp2idC63u91nn+Q+7iuUcl2I4vgr29fNMC5tSS
         IxKCjG1Z+3AnFZrzQbBaSYRBIvaDTxe3jthtg=
Date: Thu, 2 Apr 2009 12:44:14 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] Fix highmem build failure
Message-ID: <20090402034414.GA22836@localhost.localdomain>
References: <1238621611-4844-1-git-send-email-galak@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238621611-4844-1-git-send-email-galak@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 04:33:31PM -0500, Kumar Gala wrote:
> The following commit breaks PPC builds with CONFIG_HIGHMEM=y
> 
> commit f4112de6b679d84bd9b9681c7504be7bdfb7c7d5
> Author: Akinobu Mita <akinobu.mita@gmail.com>
> Date:   Tue Mar 31 15:23:25 2009 -0700
> 
>     mm: introduce debug_kmap_atomic
> 

Thanks.
But the definition of debug_kmap_atomic() needs to be outside of
ifdef CONFIG_HIGHMEM. Because debug_kmap_atomic() is used without
CONFIG_HIGHMEM by kmap_atomic_prot_pfn() in arch/x86/mm/iomap_32.c

> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -20,6 +20,19 @@ static inline void flush_kernel_dcache_page(struct page *page)
>  #endif
>  
>  #ifdef CONFIG_HIGHMEM
> +#include <asm/kmap_types.h>
> +
> +#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
> +
> +void debug_kmap_atomic(enum km_type type);
> +
> +#else
> +
> +static inline void debug_kmap_atomic(enum km_type type)
> +{
> +}
> +
> +#endif
>  
>  #include <asm/highmem.h>
>  
