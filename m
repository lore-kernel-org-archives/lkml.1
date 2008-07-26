Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbYGZRMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbYGZRMD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 13:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYGZRLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 13:11:54 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:49250 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbYGZRLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 13:11:53 -0400
Date: Sat, 26 Jul 2008 18:11:27 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix build error when no swap
In-Reply-To: <20080726212246.d64073b3.yoichi_yuasa@tripeaks.co.jp>
Message-ID: <Pine.LNX.4.64.0807261747470.27377@blonde.site>
References: <20080726212246.d64073b3.yoichi_yuasa@tripeaks.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008, Yoichi Yuasa wrote:
> When CONFIG_SWAP is not set, I got the following error.
> 
> In file included from include/asm/tlb.h:21,
>                  from fs/exec.c:55:
> 		 include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
> 		 include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
> 		 include/asm-generic/tlb.h: In function 'tlb_remove_page':
> 		 include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
> 		 make[1]: *** [fs/exec.o] Error 1

Urgrrh, that'll be my fault: sorry, I've caused nothing but trouble
with my little remove-a-few-unneeded #includes from exec.c.
I honestly believed I'd tested !CONFIG_SWAP.

> 
> Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
> 
> diff -pruN -X /home/yuasa/Memo/dontdiff linux-orig/include/linux/swap.h linux/include/linux/swap.h
> --- linux-orig/include/linux/swap.h	2008-07-26 17:27:22.651869820 +0900
> +++ linux/include/linux/swap.h	2008-07-26 18:36:46.406531575 +0900
> @@ -7,6 +7,7 @@
>  #include <linux/list.h>
>  #include <linux/memcontrol.h>
>  #include <linux/sched.h>
> +#include <linux/pagemap.h>
>  
>  #include <asm/atomic.h>
>  #include <asm/page.h>

There's actually a comment further down saying that sparc cannot
include pagemap.h in swap.h, so I think your patch will probably
cause some other build trouble on sparc.

I'd be more inclined to include pagemap.h back in exec.c, as it
was before I interfered, or see if there's another "obviously safe"
(haha) solution.

Please give me a little while to wander through the maze, thanks.

Hugh
