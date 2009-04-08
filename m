Return-Path: <linux-kernel-owner+w=401wt.eu-S1760046AbZDHMWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046AbZDHMWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZDHMVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:21:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35806 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZDHMVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:21:44 -0400
Date: Wed, 8 Apr 2009 14:21:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] x86: remove dupilcated #include
Message-ID: <20090408122121.GB18581@elte.hu>
References: <1239009605-1796-1-git-send-email-weiyi.huang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239009605-1796-1-git-send-email-weiyi.huang@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Huang Weiyi <weiyi.huang@gmail.com> wrote:

> Remove dupilcated #include in arch/x86/kernel/dumpstack.c.
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
> ---
>  arch/x86/kernel/dumpstack.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index 95ea5fa..6d7966d 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -15,7 +15,6 @@
>  #include <linux/bug.h>
>  #include <linux/nmi.h>
>  #include <linux/sysfs.h>
> -#include <linux/ftrace.h>
>  
>  #include <asm/stacktrace.h>

Many of those include lines are probably unnecessary. Instead of 
these trivial patches causing churn, would you be interested in 
doing a comprehensive search to eliminate all the unused ones?
That would be a real step forward. (and this holds for your 
other patches in this series too.)

The include files section of fault.c might be a good template to 
use:

#include <linux/magic.h>		/* STACK_END_MAGIC		*/
#include <linux/sched.h>		/* test_thread_flag(), ...	*/
#include <linux/kdebug.h>		/* oops_begin/end, ...		*/
#include <linux/module.h>		/* search_exception_table	*/
#include <linux/bootmem.h>		/* max_low_pfn			*/
#include <linux/kprobes.h>		/* __kprobes, ...		*/
#include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
#include <linux/perf_counter.h>		/* perf_swcounter_*(), ...	*/

#include <asm/traps.h>			/* dotraplinkage, ...		*/
#include <asm/pgalloc.h>		/* pgd_*(), ...			*/
#include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/

I was able to eliminate half of all include file lines there.

See latest -tip for that:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
