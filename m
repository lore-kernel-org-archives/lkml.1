Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbZD1J4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbZD1J4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZD1J4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:56:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:57046 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbZD1J4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:56:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,259,1239001200"; 
   d="scan'208";a="136715327"
Date: Tue, 28 Apr 2009 17:55:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?utf-8?B?RnLpppjpp7tpYw==?= Weisbecker <fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Message-ID: <20090428095551.GB21168@localhost>
References: <84144f020904280219p197d5ceag846ae9a80a76884e@mail.gmail.com> <20090428092918.GC21085@elte.hu> <20090428183237.EBDE.A69D9226@jp.fujitsu.com> <20090428093833.GE21085@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428093833.GE21085@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 05:38:33PM +0800, Ingo Molnar wrote:
> 
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > 
> > > * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > > 
> > > > I have no idea how expensive tracepoints are but I suspect they 
> > > > don't make too much sense for this particular scenario. After all, 
> > > > kmemtrace is mainly interested in _allocation patterns_ whereas 
> > > > this patch seems to be more interested in "memory layout" type of 
> > > > things.
> > > 
> > > My point is that the allocation patterns can be derived from dynamic 
> > > events. We can build a map of everything if we know all the events 
> > > that led up to it. Doing:
> > > 
> > >   echo 3 > /proc/sys/vm/drop_caches
> > > 
> > > will clear 99% of the memory allocations, so we can build a new map 
> > > from scratch just about anytime. (and if boot allocations are 
> > > interesting they can be traced too)
> > > 
> > > _And_ via this angle we'll also have access to the dynamic events, 
> > > in a different 'view' of the same tracepoints - which is obviously 
> > > very useful for different purposes.
> > 
> > I am one of most strongly want guys to MM tracepoint. but No, many 
> > cunstomer never permit to use drop_caches.
> 
> See my other mail i just sent: it would be a natural extension of 
> tracing to also dump all current object state when tracing is turned 
> on. That way no drop_caches is needed at all.

I can understand the merits here - I also did readahead
tracing/accounting in _one_ piece of code. Very handy.

The readahead traces are now raw printks - converting to the ftrace
framework would be a big win.

But. It's still not a fit-all solution. Imagine when full data _since_
booting is required, but the user cannot afford a reboot.

> But it has to be expressed in one framework that cares about the 
> totality of the kernel - not just these splintered bits of 
> instrumentation and pieces of statistics.

Though minded to push the kpageflags interface, I totally agree the
above fine principle and discipline :-)

Thanks,
Fengguang
