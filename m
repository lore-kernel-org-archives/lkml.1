Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbZCJO7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbZCJO7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZCJO7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:59:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43757 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbZCJO7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:59:35 -0400
Date: Tue, 10 Mar 2009 15:59:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] perf_counter: provide pagefault software events
Message-ID: <20090310145915.GK3850@elte.hu>
References: <20090310141913.961861111@chello.nl> <20090310142015.761644317@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310142015.761644317@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Index: linux-2.6/arch/powerpc/mm/fault.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/mm/fault.c
> +++ linux-2.6/arch/powerpc/mm/fault.c
> @@ -29,6 +29,7 @@
>  #include <linux/module.h>
>  #include <linux/kprobes.h>
>  #include <linux/kdebug.h>
> +#include <linux/perf_counter.h>
>  
>  #include <asm/firmware.h>
>  #include <asm/page.h>
> @@ -170,6 +171,8 @@ int __kprobes do_page_fault(struct pt_re
>  		die("Weird page fault", regs, SIGSEGV);
>  	}
>  
> +	perf_swcount_event(PERF_COUNT_PAGE_FAULTS, 1, regs);

Wow, that's really nice - this way we can display a profile of 
pagefault events in KernelTop - as if it was a real cycles or 
other hw event based profile. Have you tried it out?

	Ingo
