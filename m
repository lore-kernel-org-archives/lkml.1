Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZFDATR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZFDATR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 20:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbZFDATF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 20:19:05 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50445 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbZFDATD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 20:19:03 -0400
Message-ID: <4A271287.50103@linux.vnet.ibm.com>
Date: Wed, 03 Jun 2009 17:17:11 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, torvalds@linux-foundation.org,
       xemul@parallels.com, orenl@cs.columbia.edu, serue@us.ibm.com,
       dave@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [PATCH 08/38] pidns 2/2: rewrite copy_pid_ns()
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-8-git-send-email-adobriyan@gmail.com>
In-Reply-To: <1242968132-1044-8-git-send-email-adobriyan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> copy_pid_ns() is a perfect example of a case where unwinding leads to more
> code and makes it less clear. Watch the diffstat.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

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

