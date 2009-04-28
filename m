Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZD1K5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZD1K5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZD1K5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:57:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60342 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZD1K5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:57:13 -0400
Date: Tue, 28 Apr 2009 12:56:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
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
Message-ID: <20090428105603.GB25347@elte.hu>
References: <20090428093621.GD21085@elte.hu> <84144f020904280257j57b5b686k91cc4096a8e5ca29@mail.gmail.com> <20090428190822.EBED.A69D9226@jp.fujitsu.com> <84144f020904280321u4be9fb10t6f0123b589752b80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020904280321u4be9fb10t6f0123b589752b80@mail.gmail.com>
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

> Hi!
> 
> 2009/4/28 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> >> I guess the main question here is whether this approach will scale to
> >> something like kmalloc() or the page allocator in production
> >> environments. For any serious workload, the frequency of events is
> >> going to be pretty high.
> >
> > Immediate Values patch series makes zero-overhead to tracepoint
> > while it's not used.
> >
> > So, We have to implement to stop collect stastics way. it restore
> > zero overhead world.
> > We don't lose any performance by trace.
> 
> Sure but I meant the _enabled_ case here. kmalloc() (and the page 
> allocator to some extent) is very performance sensitive in many 
> workloads so you probably don't want to use tracepoints if you're 
> collecting some overall statistics (i.e. tracing all events) like 
> we do here.

That's where 'collect current state' kind of tracepoints would help 
- they could be used even without enabling any of the other 
tracepoints. And they'd still be in a coherent whole with the 
dynamic-events tracepoints.

So i'm not arguing against these techniques at all - and we can move 
on a wide scale from zero-overhead to lots-of-tracing-enabled models 
- what i'm arguing against is the splintering.

	Ingo
