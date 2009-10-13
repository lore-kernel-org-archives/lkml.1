Return-Path: <linux-kernel-owner+w=401wt.eu-S933931AbZJMP54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931AbZJMP54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760404AbZJMP5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:57:55 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51973 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760384AbZJMP5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:57:55 -0400
Date: Tue, 13 Oct 2009 11:56:50 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: linux-kernel@vger.kernel.org
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: From: Tim Abbott <tabbott@ksplice.com>
In-Reply-To: <1255449206-16650-1-git-send-email-tabbott@ksplice.com>
Message-ID: <alpine.DEB.1.10.0910131156170.2868@dr-wily.mit.edu>
References: <1255449206-16650-1-git-send-email-tabbott@ksplice.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I think I just found a bug in git-send-email.  I'll resend with the 
actual subject line.

	-Tim Abbott

On Tue, 13 Oct 2009, Tim Abbott wrote:

> There is already an architecture-independent __page_aligned_data macro
> for this purpose, so removing the powerpc-specific macro should be
> harmless.
> 
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@ozlabs.org
> Cc: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/powerpc/include/asm/page_64.h |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/page_64.h b/arch/powerpc/include/asm/page_64.h
> index 3f17b83..3c7118f 100644
> --- a/arch/powerpc/include/asm/page_64.h
> +++ b/arch/powerpc/include/asm/page_64.h
> @@ -162,14 +162,6 @@ do {						\
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
> -- 
> 1.6.4.3
> 
> 
