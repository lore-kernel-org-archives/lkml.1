Return-Path: <linux-kernel-owner+w=401wt.eu-S1760358AbYBHWKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358AbYBHWKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYBHWHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:07:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752829AbYBHWHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:07:08 -0500
Date: Fri, 8 Feb 2008 14:05:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: vapier@gentoo.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stub out is_swap_pte for !MMU
Message-Id: <20080208140555.01d3832f.akpm@linux-foundation.org>
In-Reply-To: <1202506903.17934.653.camel@cinder.waste.org>
References: <1202500959-2727-1-git-send-email-vapier@gentoo.org>
	<1202503750.17934.639.camel@cinder.waste.org>
	<200802081625.12893.vapier@gentoo.org>
	<1202506903.17934.653.camel@cinder.waste.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2008 15:41:42 -0600
Matt Mackall <mpm@selenic.com> wrote:

> Fix compile error on nommu for is_swap_pte
> 
> Does it ever make sense to ask "is this pte a swap entry?" on a machine
> with no MMU? Presumably this also means it has no ptes too, right? In
> which case, it's better to comment the whole function out. Then when
> someone tries to ask the above meaningless question, they get a compile
> error rather than a meaningless answer.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>
> 
> diff -r 50a6e531a9f2 include/linux/swapops.h
> --- a/include/linux/swapops.h	Mon Feb 04 20:23:02 2008 -0600
> +++ b/include/linux/swapops.h	Fri Feb 08 15:38:01 2008 -0600
> @@ -42,11 +42,13 @@
>  	return entry.val & SWP_OFFSET_MASK(entry);
>  }
>  
> +#ifdef CONFIG_MMU
>  /* check whether a pte points to a swap entry */
>  static inline int is_swap_pte(pte_t pte)
>  {
>  	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
>  }
> +#endif
>  

Seems contradictory.  Is there _really_ a compilation error at present? 
The changelog seems to imply otherwise and no compiler error output is
quoted and it all compiled OK for me on nommu superh.

