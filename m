Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0BEMNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 07:13:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36977 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab0BEMNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 07:13:24 -0500
Subject: Re: [PATCH 10/11] tracing/perf: Fix lock events recursions in the
 fast path
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, paulmck@linux.vnet.ibm.com,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <1265371808.22001.502.camel@laptop>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
	 <1265188475-23509-11-git-send-regression-fweisbec@gmail.com>
	 <20100204154700.GE6676@linux.vnet.ibm.com> <4B6B84A1.60805@cn.fujitsu.com>
	 <1265363102.22001.286.camel@laptop> <1265363441.22001.300.camel@laptop>
	 <20100205104937.GB29515@elte.hu>  <1265371808.22001.502.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 13:12:53 +0100
Message-ID: <1265371973.22001.508.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 13:10 +0100, Peter Zijlstra wrote:
> On Fri, 2010-02-05 at 11:49 +0100, Ingo Molnar wrote:
> > 
> > > That said, I'm not at all happy about removing lockdep annotations to make 
> > > the tracer faster, that's really counter productive.
> > 
> > Are there no dynamic techniques that could be used here?
> > 
> > Lockdep obviously wants maximum instrumentation coverage - performance be 
> > damned.
> > 
> > Lock profiling/tracing/visualization wants the minimum subset of events it is 
> > interested in - everything else is unnecessary overhead.
> 
> Well, they could start by moving the tracepoint inside the lockdep
> recursion check.

IIRC the reason its now outside is that you'd loose tracepoint on
lockdep_off() usage, but having the tracer folks help on removing any
such usage is of course a good thing.

The usage thereof in nmi_enter() doesn't seem like a problem, since
you're not supposed to be using locks from nmi context anyway, more so,
I'd not be adverse to putting BUG_ON(in_nmi()) in every lockdep hook.

