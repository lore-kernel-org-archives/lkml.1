Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab0BLHUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 02:20:46 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42471 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab0BLHUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 02:20:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH] Create initial stack independent of PAGE_SIZE
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Helge Deller <deller@gmx.de>, Americo Wang <xiyou.wangcong@gmail.com>,
       Anton Blanchard <anton@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <31586.1265953455@neuling.org>
References: <20100209132529.bfc455b7.akpm@linux-foundation.org> <31586.1265953455@neuling.org>
Message-Id: <20100212161305.73B2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 12 Feb 2010 16:20:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently we create the initial stack based on the PAGE_SIZE.  This is
> unnecessary.  

I don't think this is enough explanation. In past mail, you described
why page size dependency is harmful. I hope you add it into the patch
description.

IOW, we don't need to change the unnecessary-but-non-harmful behavior.

> 
> This creates this initial stack independent of the PAGE_SIZE.
> 
> It also bumps up the number of 4k pages allocated from 20 to 32, to
> align with 64K page systems.

Why do we need page-aligning? Do you mean this code doesn't works on
128K (or more larger) page systems?


> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> ---
> This is the second half of my original patch. This can be targeted for
> 2.6.34 as it's just a cleanup.
> 
> Tested on PPC64 with 4k and 64k pages.
> 
>  fs/exec.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> Index: linux-2.6-ozlabs/fs/exec.c
> ===================================================================
> --- linux-2.6-ozlabs.orig/fs/exec.c
> +++ linux-2.6-ozlabs/fs/exec.c
> @@ -554,8 +554,6 @@ static int shift_arg_pages(struct vm_are
>  	return 0;
>  }
>  
> -#define EXTRA_STACK_VM_PAGES	20	/* random */
> -
>  /*
>   * Finalizes the stack vm_area_struct. The flags and permissions are updated,
>   * the stack is optionally relocated, and some extra space is added.
> @@ -630,7 +628,7 @@ int setup_arg_pages(struct linux_binprm 
>  			goto out_unlock;
>  	}
>  
> -	stack_expand = EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> +	stack_expand = 131072UL; /* randomly 32*4k (or 2*64k) pages */
>  	stack_size = vma->vm_end - vma->vm_start;
>  	/*
>  	 * Align this down to a page boundary as expand_stack



