Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbZHYKjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbZHYKjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 06:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZHYKjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 06:39:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42598 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbZHYKjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 06:39:17 -0400
Date: Tue, 25 Aug 2009 12:39:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
Message-ID: <20090825103907.GB28287@elte.hu>
References: <20090824092455.GA25267@elte.hu> <1251106058.7538.149.camel@twins> <4A937505.5000209@cn.fujitsu.com> <1251181266.7538.1016.camel@twins> <4A9385AA.508@cn.fujitsu.com> <1251182405.7538.1050.camel@twins> <20090825090558.GC14003@elte.hu> <1251191546.7538.1118.camel@twins> <20090825102215.GC26801@elte.hu> <1251196359.7538.1133.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251196359.7538.1133.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-08-25 at 12:22 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Tue, 2009-08-25 at 11:05 +0200, Ingo Molnar wrote:
> > > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > > 
> > > > > Ah, my bad, I was thikning tracepoint_probe_register() was the 
> > > > > thing that registered the tracepoint itself, not the callback.
> > > > > 
> > > > > Ok, then what's the problem?, don't do modules that consume their 
> > > > > own tracepoints, seems simple enough.
> > > > 
> > > > is this a reasonable restriction? I dont see any reason why the 
> > > > act of defining and providing a tracepoint should be exclusive 
> > > > of the ability to make use of it.
> > > 
> > > It doesn't make sense to me, you don't need your own tracepoints 
> > > because you generate the events yourself, you already have them.
> > 
> > For a reasonable large subsystem/driver i can very well imagine 
> > this to happen: why should the subsystem add _another_ layer of 
> > callbacks if it can reuse the generic tracepoint code and 
> > register itself to those?
> 
> Then that subsystem would be non functioning when the kernel is 
> build without tracepoints.

... except if it selects all required core kernel functionality it 
relies on? Tracepoints and typed callbacks really go hand in hand 
and it would be nice to see some more synergy in that space. 
(instead of crappy, prioritized notifier chains for example.)

> Nothing should rely on tracepoint being present, they are and 
> should remain a debug feature, not a core hook thing.
> 
> Do you really wish to burden every tracepoint user with the extra 
> logic needed to deal with modules?

Not necessarily - i'm just outlining why i think that the 'dont 
allow subsystems to utilize tracepoint callbacks' is a restriction 
we should not live with voluntarily.

	Ingo
