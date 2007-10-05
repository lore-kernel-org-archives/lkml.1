Return-Path: <linux-kernel-owner+w=401wt.eu-S1763707AbXJEXPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763707AbXJEXPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 19:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbXJEXPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 19:15:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57053 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbXJEXP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 19:15:29 -0400
Date: Fri, 5 Oct 2007 16:15:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org, hpa@zytor.com,
       menage@google.com
Subject: Re: [PATCH] Use task_pid_nr() instead of pid_nr(task_pid())
Message-Id: <20071005161521.cae8c531.akpm@linux-foundation.org>
In-Reply-To: <4703A67E.1070209@openvz.org>
References: <4703A67E.1070209@openvz.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Oct 2007 18:26:06 +0400
Pavel Emelyanov <xemul@openvz.org> wrote:

> There are two places that do so - the cgroups subsystem 
> and the autofs code.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> diff --git a/fs/autofs/root.c b/fs/autofs/root.c
> index 592f640..5efff3c 100644
> --- a/fs/autofs/root.c
> +++ b/fs/autofs/root.c
> @@ -214,7 +214,7 @@ static struct dentry *autofs_root_lookup
>  
>  	oz_mode = autofs_oz_mode(sbi);
>  	DPRINTK(("autofs_lookup: pid = %u, pgrp = %u, catatonic = %d, "
> -				"oz_mode = %d\n", pid_nr(task_pid(current)),
> +				"oz_mode = %d\n", task_pid_nr(current),
>  				task_pgrp_nr(current), sbi->catatonic,
>  				oz_mode));
>  
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 1e8aa53..8720881 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1762,7 +1762,7 @@ static int pid_array_load(pid_t *pidarra
>  	while ((tsk = cgroup_iter_next(cont, &it))) {
>  		if (unlikely(n == npids))
>  			break;
> -		pidarray[n++] = pid_nr(task_pid(tsk));
> +		pidarray[n++] = task_pid_nr(tsk);
>  	}
>  	cgroup_iter_end(cont, &it);
>  	return n;

And more will appear over time unless we remove pid_nr() altogether.

Can we do that?
