Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbZIKHdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbZIKHdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZIKHdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:33:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:58197 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbZIKHdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:33:45 -0400
Subject: Re: [PATCH v2 4/5] powerpc: remove unused __page_aligned
 definition.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <1252464546-26394-5-git-send-email-tabbott@ksplice.com>
References: <1252464546-26394-1-git-send-email-tabbott@ksplice.com>
	 <1252464546-26394-5-git-send-email-tabbott@ksplice.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 17:33:21 +1000
Message-Id: <1252654401.8566.101.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 22:49 -0400, Tim Abbott wrote:
> There is already an architecture-independent __page_aligned_data macro
> for this purpose, so removing the powerpc-specific macro should be
> harmless.

Thanks. I'll pick these up.

Cheers,
Ben.

> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/powerpc/include/asm/page_64.h |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/page_64.h b/arch/powerpc/include/asm/page_64.h
> index 5817a3b..22e4795 100644
> --- a/arch/powerpc/include/asm/page_64.h
> +++ b/arch/powerpc/include/asm/page_64.h
> @@ -152,14 +152,6 @@ do {						\
>  
>  #endif /* !CONFIG_HUGETLB_PAGE */
>  
> -#ifdef MODULE
> -#define __page_aligned __attribute__((__aligned__(PAGE_SIZE)))
> -#else
> -#define __page_aligned \
> -	__attribute__((__aligned__(PAGE_SIZE), \
> -		__section__(".data.page_aligned")))
> -#endif
> -
>  #define VM_DATA_DEFAULT_FLAGS \
>  	(test_thread_flag(TIF_32BIT) ? \
>  	 VM_DATA_DEFAULT_FLAGS32 : VM_DATA_DEFAULT_FLAGS64)

