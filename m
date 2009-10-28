Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbZJ1EMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbZJ1EMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 00:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZJ1EMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 00:12:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:2233 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbZJ1EMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 00:12:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=lJn4P6dWf6ErL9sHbSp/G6DEpnZW/gxbSAu0epf/ZVcMY+lURWLnac+VhZLrSmBEo
	PCsLCbnQR4vJEjYGZ5q0Q==
Date: Tue, 27 Oct 2009 21:12:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       vedran.furac@gmail.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
In-Reply-To: <20091028113713.FD85.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0910272111400.8988@chino.kir.corp.google.com>
References: <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <20091028113713.FD85.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009, KOSAKI Motohiro wrote:

> I agree quartering is debatable.
> At least, killing quartering is worth for any user, and it can be push into -stable.
> 

Not sure where the -stable reference came from, I don't think this is a 
candidate.

> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index ea2147d..40d323d 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -152,18 +152,15 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
>  	/*
>  	 * Superuser processes are usually more important, so we make it
>  	 * less likely that we kill those.
> -	 */
> -	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
> -	    has_capability_noaudit(p, CAP_SYS_RESOURCE))
> -		points /= 4;
> -
> -	/*
> -	 * We don't want to kill a process with direct hardware access.
> +	 *
> +	 * Plus, We don't want to kill a process with direct hardware access.
>  	 * Not only could that mess up the hardware, but usually users
>  	 * tend to only have this flag set on applications they think
>  	 * of as important.
>  	 */
> -	if (has_capability_noaudit(p, CAP_SYS_RAWIO))
> +	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
> +	    has_capability_noaudit(p, CAP_SYS_RESOURCE) ||
> +	    has_capability_noaudit(p, CAP_SYS_RAWIO))
>  		points /= 4;
>  
>  	/*

Acked-by: David Rientjes <rientjes@google.com>
