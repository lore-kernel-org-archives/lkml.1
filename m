Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbYBHUxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbYBHUxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbYBHUxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:53:23 -0500
Received: from waste.org ([66.93.16.53]:51168 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbYBHUxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:53:22 -0500
Subject: Re: [PATCH] stub out is_swap_pte for !MMU
From: Matt Mackall <mpm@selenic.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1202500959-2727-1-git-send-email-vapier@gentoo.org>
References: <1202500959-2727-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 14:49:09 -0600
Message-Id: <1202503750.17934.639.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-08 at 15:02 -0500, Mike Frysinger wrote:
> With commit 698dd4ba6b12e34e1e432c944c01478c0b2cd773, swap_pte() was moved
> into view of both MMU and !MMU, but uses functions only provided by MMU.
> Here we stub out the function for !MMU ports.

I'm not sure if this is right compared to my original patch. Does it
ever make sense to ask "is this pte a swap entry?" on a machine with no
MMU? Presumably this also means it has no ptes too, right? In which
case, it's better to comment the whole function out. Then when someone
tries to ask the above meaningless question, they get a compile error
rather than a meaningless answer.

> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  include/linux/swapops.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index 7bf2d14..e6b54f7 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -45,7 +45,11 @@ static inline pgoff_t swp_offset(swp_entry_t entry)
>  /* check whether a pte points to a swap entry */
>  static inline int is_swap_pte(pte_t pte)
>  {
> +#ifdef CONFIG_MMU
>  	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
> +#else
> +	return 0;
> +#endif
>  }
>  
>  /*
-- 
Mathematics is the supreme nostalgia of our time.

