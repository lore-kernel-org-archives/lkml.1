Return-Path: <linux-kernel-owner+w=401wt.eu-S1759604AbZJMM2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604AbZJMM2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZJMM2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:28:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57493 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbZJMM2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:28:08 -0400
Date: Tue, 13 Oct 2009 14:27:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vincent Legoll <vincent.legoll@gmail.com>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, paulus@samba.org,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH] [PERF] do not manually count string lengths
Message-ID: <20091013122720.GA5561@elte.hu>
References: <4727185d0910130118m5387058dndb02ac9b384af9f0@mail.gmail.com> <20091013100101.GA26846@elte.hu> <4727185d0910130451h3a5adcebtc0c06f48b6c9ab99@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4727185d0910130451h3a5adcebtc0c06f48b6c9ab99@mail.gmail.com>
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


* Vincent Legoll <vincent.legoll@gmail.com> wrote:

> On Tue, Oct 13, 2009 at 12:01 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > We should add 'F:' file patterns to that entry i guess ...
> >
> > Something like:
> >
> > F:      kernel/perf_event.c
> > F:      include/linux/perf_event.h
> > F:      arch/*/*/kernel/perf_event.c
> > F:      arch/*/include/asm/perf_event.h
> > F:      tools/perf/
> >
> > Would do the trick. Mind sending a patch for that too?
> 
> Yep, I'll do, but a quick find in the tree may reveal other
> suspects that could be in the same league:
> 
> $ find . -name .git -prune -false -o -name drivers -prune \
> -false -o -name '*perf*' | grep -v perfmon | grep -v gperf
> 
> arch/*/kernel/perf_event.c
> 
> arch/frv/lib/perf_event.c
> arch/x86/kernel/cpu/perf_event.c
> 
> or maybe not:
> 
> arch/powerpc/kernel/perf_callchain.c
> arch/parisc/kernel/perf_asm.S
> arch/parisc/kernel/perf_images.h
> arch/parisc/kernel/perf.c
> arch/parisc/include/asm/perf.h
> 
> Was your list really comprehensive ?

ah, yes - perf_callchain.c too indeed. The pattern does not have to be 
100% full coverage.

	Ingo
