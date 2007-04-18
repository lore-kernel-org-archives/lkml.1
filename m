Return-Path: <linux-kernel-owner+w=401wt.eu-S1030510AbXDSACy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030510AbXDSACy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 20:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030574AbXDSACx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 20:02:53 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55815 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030510AbXDSACx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 20:02:53 -0400
Subject: Re: [PATCH] utrace: remove exports
From: Jim Keniston <jkenisto@us.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <46269F6A.4050303@us.ibm.com>
References: <46269F6A.4050303@us.ibm.com>
Content-Type: text/plain
Date: Wed, 18 Apr 2007 16:02:42 -0700
Message-Id: <1176937362.3666.22.camel@ibm-ni9dztukfq8.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> 
> All the exports in utrace are totally unused, and not really something
> I'd want modules to use anyway :)
> 

Please leave the exports in place.

Very early in Documentation/utrace.txt, it says:
"The UTRACE is infrastructure code for tracing and controlling user
threads.  This is the foundation for writing tracing engines, which
can be loadable kernel modules."

If we can't use utrace to write ad hoc instrumentation modules (i.e.,
because utrace_attach(), utrace_detach(), etc. are no longer exported),
then utrace's usefulness is greatly reduced.

Jim Keniston
IBM LTC

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
...
> Index: linux-2.6/kernel/utrace.c
> ===================================================================
> --- linux-2.6.orig/kernel/utrace.c	2007-04-13 15:56:28.000000000 +0200
> +++ linux-2.6/kernel/utrace.c	2007-04-13 15:56:39.000000000 +0200
> @@ -490,7 +490,6 @@ restart:
> 
>  	return engine;
>  }
> -EXPORT_SYMBOL_GPL(utrace_attach);
> 
>  /*
>   * When an engine is detached, the target thread may still see it and make
> @@ -700,8 +699,6 @@ utrace_detach(struct task_struct *target
> 
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(utrace_detach);
> -
> 
>  /*
>   * Called with utrace->lock held.
> @@ -900,8 +897,7 @@ restart:			/* See below. */
> 
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(utrace_set_flags);
> -
> +
>  /*
>   * While running an engine callback, no locks are held.
>   * If a callback updates its engine's action state, then
> @@ -1930,8 +1926,6 @@ utrace_inject_signal(struct task_struct 
> 
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(utrace_inject_signal);
> -
> 
>  const struct utrace_regset *
>  utrace_regset(struct task_struct *target,
> @@ -1946,8 +1940,6 @@ utrace_regset(struct task_struct *target
> 
>  	return &view->regsets[which];
>  }
> -EXPORT_SYMBOL_GPL(utrace_regset);
> -
> 
>  /*
>   * Return the task_struct for the task using ptrace on this one, or NULL.
> -


