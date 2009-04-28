Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZD1JQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZD1JQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbZD1JQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:16:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53219 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716AbZD1JQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:16:02 -0400
Date: Tue, 28 Apr 2009 11:15:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Matt Mackall <mpm@selenic.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Message-ID: <20090428091508.GA21085@elte.hu>
References: <20090428010907.912554629@intel.com> <20090428014920.769723618@intel.com> <20090428065507.GA2024@elte.hu> <20090428074031.GK27382@one.firstfloor.org> <1240909484.1982.16.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240909484.1982.16.camel@penberg-laptop>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Andi,
> 
> On Tue, 2009-04-28 at 09:40 +0200, Andi Kleen wrote:
> > > I think i have to NAK this kind of ad-hoc instrumentation of kernel 
> > > internals and statistics until we clear up why such instrumentation 
> > 
> > I think because it has zero fast path overhead and can be used 
> > any time without enabling anything special.

( That's a dubious claim in any case - tracepoints are very cheap.
  And they could be made even cheaper and such efforts would benefit
  all the tracepoint users so it's a prime focus of interest.
  Andi is a SystemTap proponent, right? I saw him oppose pretty much 
  everything built-in kernel tracing related. I consider that a 
  pretty extreme position. )

> Yes, zero overhead is important for certain things (like 
> CONFIG_SLUB_STATS, for example). However, putting slab allocator 
> specific checks in fs/proc looks pretty fragile to me. It would be 
> nice to have this under the "kmemtrace umbrella" so that there's 
> just one place that needs to be fixed up when allocators change.
> 
> Also, while you probably don't want to use tracepoints for this 
> kind of instrumentation, you might want to look into reusing the 
> ftrace reporting bits.

Exactly - we have a tracing and statistics framework for a reason.

	Ingo
