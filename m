Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZJZMXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZJZMXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 08:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbZJZMXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 08:23:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34997 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919AbZJZMXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 08:23:14 -0400
Date: Mon, 26 Oct 2009 13:22:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net,
       mcree@orcon.net.nz, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf tools, Alpha: Add Alpha support to perf.h
Message-ID: <20091026122247.GA31982@elte.hu>
References: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz> <tip-fcd14b3203b538dca04a2b065c774c0b57863eec@git.kernel.org> <84144f020910260508n47ef067ci4adfd02cd3f87edd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020910260508n47ef067ci4adfd02cd3f87edd@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Ingo,
> 
> On Mon, Oct 26, 2009 at 1:38 PM, tip-bot for Michael Cree
> <mcree@orcon.net.nz> wrote:
> > Commit-ID:  fcd14b3203b538dca04a2b065c774c0b57863eec
> > Gitweb:     http://git.kernel.org/tip/fcd14b3203b538dca04a2b065c774c0b57863eec
> > Author:     Michael Cree <mcree@orcon.net.nz>
> > AuthorDate: Mon, 26 Oct 2009 21:32:06 +1300
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 26 Oct 2009 09:45:41 +0100
> >
> > perf tools, Alpha: Add Alpha support to perf.h
> >
> > For the perf tool the patch implements an Alpha specific section
> > in the perf.h header file.
> >
> > Signed-off-by: Michael Cree <mcree@orcon.net.nz>
> > Cc: Richard Henderson <rth@twiddle.net>
> > Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Paul Mackerras <paulus@samba.org>
> > LKML-Reference: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  tools/perf/perf.h |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> >
> > diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> > index 8cc4623..216bdb2 100644
> > --- a/tools/perf/perf.h
> > +++ b/tools/perf/perf.h
> > @@ -47,6 +47,12 @@
> >  #define cpu_relax()    asm volatile("":::"memory")
> >  #endif
> >
> > +#ifdef __alpha__
> > +#include "../../arch/alpha/include/asm/unistd.h"
> > +#define rmb()          asm volatile("mb" ::: "memory")
> > +#define cpu_relax()    asm volatile("" ::: "memory")
> > +#endif
> 
> OK, I'll bite. We tell userspace developers not to include kernel 
> headers. Why is it okay for perf to do it (especially for something 
> that's in asm)?

The main counter-argument against inclusion was always "what if we break 
them accidentally". I.e. it can become a semi-ABI - stuff we cannot 
change because we cannot change the outside projects. With perf this 
cannot occur - it's all in one Git tree and can always be fixed/changed.

Note that we reuse a couple of other facilities in tools/perf as well - 
linux/list.h, rbtree.c, etc. - and this is good - you can code perf as 
if you were hacking on the kernel! ;-)

	Ingo
