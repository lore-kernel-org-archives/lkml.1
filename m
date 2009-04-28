Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbZD1JhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbZD1JhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbZD1JhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:37:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:56543 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015AbZD1JhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:37:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,259,1239001200"; 
   d="scan'208";a="136710493"
Date: Tue, 28 Apr 2009 17:36:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Matt Mackall <mpm@selenic.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Message-ID: <20090428093608.GA21168@localhost>
References: <20090428010907.912554629@intel.com> <20090428014920.769723618@intel.com> <20090428065507.GA2024@elte.hu> <20090428074031.GK27382@one.firstfloor.org> <1240909484.1982.16.camel@penberg-laptop> <20090428091508.GA21085@elte.hu> <84144f020904280219p197d5ceag846ae9a80a76884e@mail.gmail.com> <84144f020904280225h490ef682p8973cb1241a1f3ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020904280225h490ef682p8973cb1241a1f3ea@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 05:25:06PM +0800, Pekka Enberg wrote:
> On Tue, 2009-04-28 at 09:40 +0200, Andi Kleen wrote:
> >>> > > I think i have to NAK this kind of ad-hoc instrumentation of kernel
> >>> > > internals and statistics until we clear up why such instrumentation
> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >>> > I think because it has zero fast path overhead and can be used
> >>> > any time without enabling anything special.
> >
> > On Tue, Apr 28, 2009 at 12:15 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >> ( That's a dubious claim in any case - tracepoints are very cheap.
> >>  And they could be made even cheaper and such efforts would benefit
> >>  all the tracepoint users so it's a prime focus of interest.
> >>  Andi is a SystemTap proponent, right? I saw him oppose pretty much
> >>  everything built-in kernel tracing related. I consider that a
> >>  pretty extreme position. )
> 
> On Tue, Apr 28, 2009 at 12:19 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > I have no idea how expensive tracepoints are but I suspect they don't
> > make too much sense for this particular scenario. After all, kmemtrace
> > is mainly interested in _allocation patterns_ whereas this patch seems
> > to be more interested in "memory layout" type of things.
> 
> That said, I do foresee a need to be able to turn on more detailed
> tracing after you've identified problematic areas from kpageflags type
> of overview report. And for that, you almost certainly want
> kmemtrace/tracepoints style solution with pid/function/whatever regexp
> matching ftrace already provides.

Exactly - kmemtrace is the tool I looked for when hunting down the
page flags of the leaked ring buffer memory :-)

Thanks,
Fengguang
