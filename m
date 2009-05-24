Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbZEXWki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbZEXWki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbZEXWka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:40:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42202 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZEXWk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:40:29 -0400
Date: Sun, 24 May 2009 17:45:22 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [PATCH 08/38] pidns 2/2: rewrite copy_pid_ns()
Message-ID: <20090524224522.GD12734@hallyn.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-8-git-send-email-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242968132-1044-8-git-send-email-adobriyan@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> copy_pid_ns() is a perfect example of a case where unwinding leads to more
> code and makes it less clear. Watch the diffstat.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Reviewed-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  kernel/pid_namespace.c |   18 +++---------------
>  1 files changed, 3 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 495d5de..821722a 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -116,23 +116,11 @@ static void destroy_pid_namespace(struct pid_namespace *ns)
>  
>  struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
>  {
> -	struct pid_namespace *new_ns;
> -
> -	BUG_ON(!old_ns);
> -	new_ns = get_pid_ns(old_ns);
>  	if (!(flags & CLONE_NEWPID))
> -		goto out;
> -
> -	new_ns = ERR_PTR(-EINVAL);
> +		return get_pid_ns(old_ns);
>  	if (flags & CLONE_THREAD)
> -		goto out_put;
> -
> -	new_ns = create_pid_namespace(old_ns);
> -
> -out_put:
> -	put_pid_ns(old_ns);
> -out:
> -	return new_ns;
> +		return ERR_PTR(-EINVAL);
> +	return create_pid_namespace(old_ns);
>  }
>  
>  void free_pid_ns(struct kref *kref)
> -- 
> 1.5.6.5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
