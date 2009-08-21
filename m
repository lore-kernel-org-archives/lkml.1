Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbZHUOZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbZHUOZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbZHUOZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:25:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48163 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbZHUOZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:25:23 -0400
Date: Fri, 21 Aug 2009 16:25:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Cohen <wcohen@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add minimal support for software performance counters
	for ia64
Message-ID: <20090821142514.GE11098@elte.hu>
References: <4A8C2290.3040707@redhat.com> <1250698351.8282.106.camel@twins> <4A8C4CAA.5070101@redhat.com> <1250708819.7154.5.camel@laptop> <4A8DBDDB.5080402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8DBDDB.5080402@redhat.com>
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


* William Cohen <wcohen@redhat.com> wrote:

> Peter Zijlstra wrote:
> > On Wed, 2009-08-19 at 15:04 -0400, William Cohen wrote:
> >> Peter Zijlstra wrote:
> >>> On Wed, 2009-08-19 at 12:04 -0400, William Cohen wrote:
> >>>> +#ifdef __ia64__
> >>>> +#include "../../arch/ia64/include/asm/unistd.h"
> >>>> +#define rmb()          asm volatile("" ::: "memory")
> >>>> +#define cpu_relax()    asm volatile("" ::: "memory");
> >>>> +#endif
> >>> Surely the itanic has a real memory barrier? The kernel seems to use
> >>> something along the lines of mf.
> >>>
> >>> Also, cpu_relax() seems to end up being asm volatile("hint @pause" :::
> >>> "memory"), although we don't seem to have an actual user of cpu_relax()
> >>> in perf atm.
> >>>
> >>>
> >>>
> >> Peter, thanks for the comment. I took a look at the rmb() and cpu_relax() code
> >> in the kernel and revised the patch with the appropriate defines
> > 
> > Looks good now, thanks!
> > 
> 
> When looking through the patch today I realized the new 
> perf_counter.h was placed in include/asm-ia64. It should be placed 
> in arch/ia64/include/asm/perf_counter.h.

mind sending out a v2 patch with all review feedback folded in, for 
IA64 maintainers to ack if they like it?

Thanks,

	Ingo
