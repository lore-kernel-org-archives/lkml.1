Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbZHBUrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbZHBUrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZHBUrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:47:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45630 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbZHBUrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:47:01 -0400
Date: Sun, 2 Aug 2009 22:46:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/debug] debug lockups: Improve lockup detection
Message-ID: <20090802204647.GC3986@elte.hu>
References: <tip-c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc@git.kernel.org> <20090802114545.f1520c81.akpm@linux-foundation.org> <20090802192657.GA21882@elte.hu> <20090802123958.cbd497a0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802123958.cbd497a0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

>  #ifndef trigger_all_cpu_backtrace
> +#ifdef CONFIG_SMP
> +#warning This architecture is missing a trigger_all_cpu_backtrace() implementation
> +#endif
>  #define trigger_all_cpu_backtrace() do { } while (0)
>  #endif

I think a better solution will be to make this function return 1 if 
it generated a backtrace.

That way we can fall back to the generic schedule_work based 
codepath.

Albeit the best and cleanest solution would be to implement a 
workqueue based trigger_all_cpu_backtrace() __weak variant and throw 
away the workqueue bits from sysrq.c.

	Ingo

