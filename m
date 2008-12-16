Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbYLPVEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbYLPVEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 16:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbYLPVDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:03:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33409 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbYLPVDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:03:51 -0500
Date: Tue, 16 Dec 2008 22:03:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Luis Henriques <henrix@sapo.pt>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <pzijlstr@redhat.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Conditional compilation updates in kernel/lockdep.c
Message-ID: <20081216210344.GK14787@elte.hu>
References: <20081214205218.GA10877@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081214205218.GA10877@hades.domain.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luis Henriques <henrix@sapo.pt> wrote:

> This patch removes the following warning:
> 
> kernel/lockdep.c:580: warning: ‘print_lock_dependencies’ defined but not used
> 
> Now functions print_lock_dependencies and print_lock_class_header are now
> compiled only if both CONFIG_TRACE_IRQFLAGS and CONFIG_PROVE_LOCKING
> are defined; function lockdep_dependency_visit and variable
> lockdep_dependency_gen_id are compiled only if CONFIG_PROVE_LOCKING
> is defined
> 
> Signed-off-by: Luis Henriques <henrix@sapo.pt>
> ---
>  kernel/lockdep.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 46a4041..f2eebc7 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -381,6 +381,7 @@ unsigned int nr_process_chains;
>  unsigned int max_lockdep_depth;
>  unsigned int max_recursion_depth;
>  
> +#ifdef CONFIG_PROVE_LOCKING
>  static unsigned int lockdep_dependency_gen_id;
>  
>  static bool lockdep_dependency_visit(struct lock_class *source,
> @@ -393,6 +394,7 @@ static bool lockdep_dependency_visit(struct lock_class *source,
>  	source->dep_gen_id = lockdep_dependency_gen_id;
>  	return false;
>  }
> +#endif
>  
>  #ifdef CONFIG_DEBUG_LOCKDEP
>  /*
> @@ -549,6 +551,8 @@ static void lockdep_print_held_locks(struct task_struct *curr)
>  	}
>  }
>  
> +#if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_PROVE_LOCKING)
> +
>  static void print_lock_class_header(struct lock_class *class, int depth)
>  {
>  	int bit;
> @@ -599,6 +603,7 @@ static void print_lock_dependencies(struct lock_class *class, int depth)
>  		printk("\n");
>  	}
>  }
> +#endif

hm, these many #ifdefs are ugly. Could we somehow improve the structure of 
this code by moving bits of it out into separate .c files, or by merging 
needless Kconfig options?

	Ingo
