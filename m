Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZB1Jks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZB1Jks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbZB1Jkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:40:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59871 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbZB1Jkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:40:39 -0500
Date: Sat, 28 Feb 2009 10:40:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [git-pull -tip] x86: Basic AMD Support for performance counters
Message-ID: <20090228094018.GF12095@elte.hu>
References: <1235756278.3914.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235756278.3914.9.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Hello Ingo,
> 
> These patches added basic AMD (K7 and later) support for performance counters:
> 
> [jaswinder@hpdv5 linux-2.6-tip]$ perfstat -e 0,1,2,3,4,5,-1,-2,-3,-4,-5 ls -lR > /dev/null
> 
>  Performance counter stats for 'ls':
> 
>     2723.203821  task clock ticks     (msecs)
> 
>      1812527794  CPU cycles           (events)
>      1121688997  instructions         (events)
>       569836744  cache references     (events)
>        15934598  cache misses         (events)
>        57313261  branches             (events)
>         4243201  branch misses        (events)
>     2639.682866  cpu clock ticks      (msecs)
>     2723.203821  task clock ticks     (msecs)
>             647  pagefaults           (events)
>            2401  context switches     (events)
>               3  CPU migrations       (events)
> 
>  Wall-clock time elapsed:  6813.030975 msecs

Very nice feature!

The AMD patches look much cleaner than i feared they would be. 
It seems you were able to keep pretty generic x86 code in 
arch/x86/kernel/cpu/perf_counters.c, sharing most of the logic 
between Intel and AMD perfcounters.

> The following changes since commit f39e09b3b2c11ad1b008518a05bc2b7c25eabc7d:
>   Ingo Molnar (1):
>         Merge branch 'tracing/ftrace'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master
> 
> Jaswinder Singh Rajput (2):
>       x86: prepare perf_counter to add more cpus
>       x86: AMD Support for perf_counter
> 
>  arch/x86/kernel/cpu/amd.c          |    4 +
>  arch/x86/kernel/cpu/perf_counter.c |  189 ++++++++++++++++++++++++++++++------
>  2 files changed, 163 insertions(+), 30 deletions(-)

Pulled into tip:perfcounters/core, thanks Jaswinder!

	Ingo
