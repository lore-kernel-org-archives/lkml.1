Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbZGBBb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbZGBBb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 21:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbZGBBbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 21:31:48 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48245 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZGBBbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 21:31:47 -0400
Date: Wed, 1 Jul 2009 20:31:48 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: oleg@redhat.com, roland@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Deny CLONE_PARENT|CLONE_NEWPID|CLONE_SIGHAND
	combination
Message-ID: <20090702013148.GA31606@us.ibm.com>
References: <20090701074045.GA14595@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701074045.GA14595@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
> 
> Deny CLONE_PARENT|CLONE_NEWPID|CLONE_SIGHAND combination.
> 
> CLONE_PARENT was used to implement an older threading model.  For consistency
> with the CLONE_THREAD check in copy_pid_ns(), disable CLONE_PARENT and
> CLONE_SIGHAND with CLONE_NEWPID, at least until the required semantics of
> the pid namespaces are clear.
> 
> Changelog[v2]:
> 	[Eric Biederman] Disable CLONE_SIGHAND also ???
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> Acked-by: Roland McGrath <roland@redhat.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  kernel/pid_namespace.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-mmotm/kernel/pid_namespace.c
> ===================================================================
> --- linux-mmotm.orig/kernel/pid_namespace.c	2009-06-30 23:01:09.000000000 -0700
> +++ linux-mmotm/kernel/pid_namespace.c	2009-06-30 23:49:06.000000000 -0700
> @@ -118,7 +118,7 @@ struct pid_namespace *copy_pid_ns(unsign
>  {
>  	if (!(flags & CLONE_NEWPID))
>  		return get_pid_ns(old_ns);
> -	if (flags & CLONE_THREAD)
> +	if (flags & (CLONE_THREAD|CLONE_PARENT|CLONE_SIGHAND))
>  		return ERR_PTR(-EINVAL);
>  	return create_pid_namespace(old_ns);
>  }
