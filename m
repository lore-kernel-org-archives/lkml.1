Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbZGBMAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbZGBMAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 08:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZGBMAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 08:00:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44932 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbZGBMAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 08:00:33 -0400
Date: Thu, 2 Jul 2009 13:57:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: roland@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Deny CLONE_PARENT|CLONE_NEWPID|CLONE_SIGHAND
	combination
Message-ID: <20090702115740.GB3552@redhat.com>
References: <20090701074045.GA14595@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701074045.GA14595@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01, Sukadev Bhattiprolu wrote:
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

Still can't understand why CLONE_SIGHAND is forbidden...

CLONE_SIGHAND doesn't mean we share the signal queue, so what is
the reason?

Oleg.

