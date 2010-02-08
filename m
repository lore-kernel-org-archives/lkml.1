Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab0BHHUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 02:20:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38714 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0BHHUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 02:20:12 -0500
Date: Mon, 8 Feb 2010 08:19:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3 v2] nmi_watchdog: config option to enable new
 nmi_watchdog
Message-ID: <20100208071954.GA24721@elte.hu>
References: <1265424425-31562-1-git-send-email-dzickus@redhat.com>
 <1265424425-31562-4-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265424425-31562-4-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> +config NMI_WATCHDOG
> +	bool "Detect Hard Lockups with an NMI Watchdog"
> +	depends on DEBUG_KERNEL && PERF_EVENTS
> +	default y
> +	help
> +	  Say Y here to enable the kernel to use the NMI as a watchdog
> +	  to detect hard lockups.  This is useful when a cpu hangs for no
> +	  reason but can still respond to NMIs.  A backtrace is displayed
> +	  for reviewing and reporting.
> +
> +	  The overhead should be minimal, just an extra NMI every few 
> +	  seconds.

Thought for later patches: I think an architecture should be able to express 
via a Kconfig switch that it actually _has_ NMI events. There's architectures 
which dont have a PMU driver and only have software events. There's also 
architectures that have a PMU driver but no NMIs.

Something like ARCH_HAS_NMI_PERF_EVENTS?

Also, i havent checked, but what is the practical effect of the new generic 
watchdog on x86 CPUs that does not have a native PMU driver yet - such as 
P4s?

Anyway, i'll create a tip:perf/nmi topic branch for these patches, it 
certainly looks like a useful generalization and a new architecture that has 
perf could easily enable it, without having to write its own NMI watchdog 
implementation. It's also useful for any new watchdog features that people 
might want to add. Plus it makes the x86 PMU code cleaner in the long run as 
well.

Thanks, 

	Ingo
