Return-Path: <linux-kernel-owner+w=401wt.eu-S1751245AbZJUEJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbZJUEJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 00:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbZJUEJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 00:09:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZJUEJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 00:09:22 -0400
Date: Tue, 20 Oct 2009 23:14:45 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] exec: setup_arg_pages fails to return errors
Message-ID: <20091021041444.GA5126@hallyn.com>
References: <20091018113908.GR4808@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091018113908.GR4808@kryten>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Anton Blanchard (anton@samba.org):
> 
> In setup_arg_pages we work hard to assign a value to ret, but on exit
> we always return 0.
> 
> Also remove a now duplicated exit path and branch to out_unlock instead.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Yikes!

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
> Index: linux.trees.git/fs/exec.c
> ===================================================================
> --- linux.trees.git.orig/fs/exec.c	2009-09-28 12:17:10.000000000 +1000
> +++ linux.trees.git/fs/exec.c	2009-09-28 12:17:58.000000000 +1000
> @@ -624,10 +624,8 @@ int setup_arg_pages(struct linux_binprm 
>  	/* Move stack pages down in memory. */
>  	if (stack_shift) {
>  		ret = shift_arg_pages(vma, stack_shift);
> -		if (ret) {
> -			up_write(&mm->mmap_sem);
> -			return ret;
> -		}
> +		if (ret)
> +			goto out_unlock;
>  	}
>  
>  #ifdef CONFIG_STACK_GROWSUP
> @@ -641,7 +639,7 @@ int setup_arg_pages(struct linux_binprm 
>  
>  out_unlock:
>  	up_write(&mm->mmap_sem);
> -	return 0;
> +	return ret;
>  }
>  EXPORT_SYMBOL(setup_arg_pages);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
