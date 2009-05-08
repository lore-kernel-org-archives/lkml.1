Return-Path: <linux-kernel-owner+w=401wt.eu-S1763750AbZEHTUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763750AbZEHTUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZEHTUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:20:40 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42887 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbZEHTUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:20:39 -0400
Date: Fri, 8 May 2009 14:19:22 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, xemul@parallels.com
Subject: Re: [PATCH 2/2] pidns 2/2: rewrite copy_pid_ns()
Message-ID: <20090508191922.GB28885@us.ibm.com>
References: <20090503232721.GE16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503232721.GE16631@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> copy_pid_ns() is a perfect example of a case where unwinding leads to more
> code and makes it less clear. Watch the diffstat.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Nice.

Reviewed-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

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
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
