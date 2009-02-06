Return-Path: <linux-kernel-owner+w=401wt.eu-S1759781AbZBFRXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbZBFRXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbZBFRXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:23:07 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:57963 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbZBFRXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:23:06 -0500
Date: Fri, 6 Feb 2009 18:24:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, ralf@linux-mips.org,
       dhowells@redhat.com, matthew@wil.cx, chris@zankel.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
Message-ID: <20090206172453.GB11299@uranus.ravnborg.org>
References: <1233385816.17794.16.camel@localhost.localdomain> <12c511ca0902050955x1acb3907jdbfc1d0e6392cb91@mail.gmail.com> <alpine.LFD.2.00.0902051101040.3247@localhost.localdomain> <20090205191907.GA27422@elte.hu> <1233886017.3463.26.camel@localhost.localdomain> <20090206022025.GA8317@elte.hu> <1233929922.3209.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233929922.3209.6.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Is this safe OR we can make it more safer:
> 
> Subject: [PATCH] make linux/types.h as assembly safe
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  include/linux/types.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/types.h b/include/linux/types.h
> index 712ca53..c30973a 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -1,6 +1,7 @@
>  #ifndef _LINUX_TYPES_H
>  #define _LINUX_TYPES_H
>  
> +#ifndef __ASSEMBLY__
>  #ifdef	__KERNEL__
>  
>  #define DECLARE_BITMAP(name,bits) \
> @@ -212,5 +213,5 @@ struct ustat {
>  };
>  
>  #endif	/* __KERNEL__ */
> -
> +#endif /*  __ASSEMBLY__ */
>  #endif /* _LINUX_TYPES_H */

This is wrong...
We should include the assumed assembly safe asm/types.h
outside the __ASEMBLY__ ifdef.

	Sam
