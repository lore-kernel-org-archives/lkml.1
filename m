Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZIONnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZIONnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbZIONnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:43:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33079 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbZIONnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:43:25 -0400
Subject: Re: [PATCH 2/4] virtual block device driver (ramzswap)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: rostedt@goodmis.org
Cc: Nitin Gupta <ngupta@vflare.org>, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mm-cc@laptop.org, Ingo Molnar <mingo@elte.hu>,
       "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>
In-Reply-To: <1253020471.20020.76.camel@gandalf.stny.rr.com>
References: <200909100215.36350.ngupta@vflare.org>
	 <200909100249.26284.ngupta@vflare.org>
	 <84144f020909141310y164b2d1ak44dd6945d35e6ec@mail.gmail.com>
	 <d760cf2d0909142339i30d74a9dic7ece86e7227c2e2@mail.gmail.com>
	 <84144f020909150030h1f9d8062sc39057b55a7ba6c0@mail.gmail.com>
	 <1253020471.20020.76.camel@gandalf.stny.rr.com>
Date: Tue, 15 Sep 2009 16:43:27 +0300
Message-Id: <1253022207.4754.1.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Tue, 2009-09-15 at 09:14 -0400, Steven Rostedt wrote:
> > >>> +
> > >>> +       trace_mark(ramzswap_lock_wait, "ramzswap_lock_wait");
> > >>> +       mutex_lock(&rzs->lock);
> > >>> +       trace_mark(ramzswap_lock_acquired, "ramzswap_lock_acquired");
> > >>
> > >> Hmm? What's this? I don't think you should be doing ad hoc
> > >> trace_mark() in driver code.
> > >
> > > This is not ad hoc. It is to see contention over this lock which I believe is a
> > > major bottleneck even on dual-cores. I need to keep this to measure improvements
> > > as I gradually make this locking more fine grained (using per-cpu buffer etc).
> > 
> > It is ad hoc. Talk to the ftrace folks how to do it properly. I'd keep
> > those bits out-of-tree until the issue is resolved, really.
> 
> Yes, trace_mark is deprecated. You want to use TRACE_EVENT. See how gfs2
> does it in:
> 
>   fs/gfs2/gfs2_trace.h
> 
> and it is well documented in
> samples/trace_events/trace-events-samples.[ch]

Does it really make sense to add special-case tracing in driver code to
profile lock contention for a _single mutex_?

			Pekka

