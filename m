Return-Path: <linux-kernel-owner+w=401wt.eu-S1760846AbYDRTH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbYDRTH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 15:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759300AbYDRTHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 15:07:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759286AbYDRTHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 15:07:11 -0400
Date: Fri, 18 Apr 2008 12:06:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: netdev@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] tun: vringfd xmit support.
Message-Id: <20080418120634.986e30f1.akpm@linux-foundation.org>
In-Reply-To: <200804190115.15983.rusty@rustcorp.com.au>
References: <200804181433.48488.rusty@rustcorp.com.au>
	<200804181443.24812.rusty@rustcorp.com.au>
	<20080418043120.ff78eab5.akpm@linux-foundation.org>
	<200804190115.15983.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008 01:15:15 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:

> >
> > What is the maximum numbet of pages which an unpriviliged user can
> > concurrently pin with this code?
> 
> Since only root can open the tun device, it's currently OK.  The old code
> kmalloced and copied: is there some mm-fu reason why pinning userspace memory
> is worse?

We generally try to avoid it - it allows users to dos the box.  Although I
suspect that direct-io presently permits users to transiently pin an amount
of memory which is proportional to the number of disks upon which they can
open files.

> Subject: Export release_pages; nice undo for get_user_pages.
> 
> Andrew Morton suggests tun/tap use release_pages, but it's not
> exported.  It's not clear to me why this is in swap.c, but it exists
> even without CONFIG_SWAP, so that's OK.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff -r abd2ad431e5c mm/swap.c
> --- a/mm/swap.c	Sat Apr 19 00:34:54 2008 +1000
> +++ b/mm/swap.c	Sat Apr 19 01:11:40 2008 +1000
> @@ -346,6 +346,7 @@ void release_pages(struct page **pages, 
>  
>  	pagevec_free(&pages_to_free);
>  }
> +EXPORT_SYMBOL(release_pages);
>  
>  /*
>   * The pages which we're about to release may be in the deferred lru-addition

acked-by: me.
