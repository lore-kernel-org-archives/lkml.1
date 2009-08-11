Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZHKNxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZHKNxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbZHKNxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:53:54 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:37201 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbZHKNxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:53:53 -0400
Date: Tue, 11 Aug 2009 13:45:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090811114512.GA585@elte.hu>
References: <cover.1249932670.git.jbaron@redhat.com> <aa785a0431b72327d288ef9b921e824d7f494de2.1249932670.git.jbaron@redhat.com> <20090811105010.GB4938@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811105010.GB4938@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > +struct trace_event event_syscall_enter = {
> > +	.trace			= print_syscall_enter,
> > +	.type			= TRACE_SYSCALL_ENTER
> > +};
> > +
> > +struct trace_event event_syscall_exit = {
> > +	.trace			= print_syscall_exit,
> > +	.type			= TRACE_SYSCALL_EXIT
> > +};
> > -- 
> > 1.6.2.5
> > 
> 
> Nice.
> 
> It's a bit too bad that enter and exit must be that separated 
> whereas their callbacks are pretty the same.
> 
> But I guess if we want to nicely decouple both, we don't have the 
> choice.

Yeah - and enter and exit are different, in terms of state.

One thing that would be nice in the future (as an add-on - this 
patch-set looks useful already) is to allow the sampling of user 
register state as well via these tracepoints. That way we'd have a 
much faster (and completely transparent) implementation of strace in 
essence, with unique features such as system-wide or per cpu 
strace-ing.

	Ingo
