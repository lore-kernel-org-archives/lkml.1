Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZEZNT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZEZNT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZEZNTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:19:50 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:52756 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbZEZNTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:19:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=k5oCBJo4uhOTOMuggqXwdRGEieV7uCz4vGYdBOXFB4Zqdd3MV19KgmFiM1paL5gWdF
         Ya7tf/RQa7IQ/5LxBuRyTMjRREvZSo2zgJcx3Q9V3B2kjLVWMYFL4GOTk/+lxpvTmnd3
         8Vn3JZtXjmxgaIYVVOh6wso2kdmKnuJoGD/xo=
MIME-Version: 1.0
In-Reply-To: <200905261844.33864.knikanth@suse.de>
References: <200905261844.33864.knikanth@suse.de>
Date: Tue, 26 May 2009 16:19:46 +0300
X-Google-Sender-Auth: 524bd77c417e040f
Message-ID: <84144f020905260619j301c130ev8906a15942397678@mail.gmail.com>
Subject: Re: [PATCH] Fix build warning and avoid checking for mem != null 
	twice
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 4:14 PM, Nikanth Karthikesan <knikanth@suse.de> wrote:
> Fix build warning, "mem_cgroup_is_obsolete defined but not used" when
> CONFIG_DEBUG_VM is not set. Also avoid checking for !mem twice.
>
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

I also sent a patch to fix this but yours is much nicer.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

>
> ---
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 01c2d8f..420fc61 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -314,14 +314,6 @@ static struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
>        return mem;
>  }
>
> -static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
> -{
> -       if (!mem)
> -               return true;
> -       return css_is_removed(&mem->css);
> -}
> -
> -
>  /*
>  * Call callback function against all cgroup under hierarchy tree.
>  */
> @@ -932,7 +924,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>        if (unlikely(!mem))
>                return 0;
>
> -       VM_BUG_ON(!mem || mem_cgroup_is_obsolete(mem));
> +       VM_BUG_ON(!mem || css_is_removed(&mem->css));
>
>        while (1) {
>                int ret;
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
