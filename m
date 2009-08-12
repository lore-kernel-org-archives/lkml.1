Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbZHLWYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbZHLWYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 18:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZHLWYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 18:24:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3751 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZHLWYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 18:24:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ekdjvBoib1ftWj2sn0wTzfRwc2AgvHiadYvNheJTg4SUAKC5JHAlx0ydHmfn/bAqu
	JcFJ5Gnz9nhbRp1mbTg3Q==
Date: Wed, 12 Aug 2009 15:24:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vincent Li <macli@brc.ubc.ca>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/proc/task_mmu.c: fix clear_refs_write() input sanity
 check
In-Reply-To: <1250114690-24829-1-git-send-email-macli@brc.ubc.ca>
Message-ID: <alpine.DEB.2.00.0908121522350.7135@chino.kir.corp.google.com>
References: <1250114690-24829-1-git-send-email-macli@brc.ubc.ca>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, Vincent Li wrote:

> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 2079969..026b532 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -494,18 +494,17 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
>  	char buffer[PROC_NUMBUF], *end;
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
> -	int type;
> +	long res;
>  

What does `res' mean?  Why can't it just be left as `type'?

>  	memset(buffer, 0, sizeof(buffer));
>  	if (count > sizeof(buffer) - 1)
>  		count = sizeof(buffer) - 1;
>  	if (copy_from_user(buffer, buf, count))
>  		return -EFAULT;
> -	type = simple_strtol(buffer, &end, 0);
> -	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
> +	if (strict_strtol(strstrip(buffer), 10, &res)
> +		return -EINVAL;

Please test your patch submissions (which would require that the above 
actually compiles).
