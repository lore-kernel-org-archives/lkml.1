Return-Path: <linux-kernel-owner+w=401wt.eu-S1761491AbXHFClY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491AbXHFClY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 22:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbXHFClP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 22:41:15 -0400
Received: from waste.org ([66.93.16.53]:60938 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbXHFClP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 22:41:15 -0400
Date: Sun, 5 Aug 2007 21:41:41 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Boutcher <boutcher@cs.umn.edu>
Cc: linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix /proc/pid/pagemap end address calculation
Message-ID: <20070806024140.GT11115@waste.org>
References: <18102.33136.963233.867247@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18102.33136.963233.867247@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 09:03:28PM -0500, Dave Boutcher wrote:
> 
> When dumping vma information the pagemap_read routine calculates
> the minimum of what the user asks for and the end of the vma.
> Unfortunately the code uses vma->vm_start rather than vma->vm_end
> which can result in the end address being before the start, and
> a nasty never-ending loop in the kernel.
> 
> Diffed against 2.6.23-rc1-mm2
> 
> Signed-off-by: Dave Boutcher <boutcher@cs.umn.edu>

Thanks, Dave. I've added this fix to my local tree. It's still in a
broken state at the moment, so Andrew, feel free to pick this up.

Acked-by: Matt Mackall <mpm@selenic.com>

> ---
>  fs/proc/task_mmu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index b2baeab..b12740c 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -671,7 +671,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  			ret = -EIO;
>  			goto out_mm;
>  		}
> -		vend = min(vma->vm_start - 1, end - 1) + 1;
> +		vend = min(vma->vm_end - 1, end - 1) + 1;
>  		ret = pagemap_fill(&pm, vend);
>  		if (ret || !pm.count)
>  			break;
> -- 
> 1.4.4.2
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Mathematics is the supreme nostalgia of our time.
