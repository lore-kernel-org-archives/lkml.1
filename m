Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab0CERjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:39:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:45403 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab0CERjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:39:15 -0500
Subject: Re: [PATCH 2/2] perf: Walk through the relevant events only
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20100305173342.GE5244@nowhere>
References: <1267772426-5944-1-git-send-regression-fweisbec@gmail.com>
	 <1267772426-5944-2-git-send-regression-fweisbec@gmail.com>
	 <1267781969.16716.55.camel@laptop> <20100305170331.GB5244@nowhere>
	 <1267809629.4942.0.camel@laptop>  <20100305173342.GE5244@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 18:39:12 +0100
Message-ID: <1267810752.4942.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 18:33 +0100, Frederic Weisbecker wrote:
> On Fri, Mar 05, 2010 at 06:20:29PM +0100, Peter Zijlstra wrote:
> > On Fri, 2010-03-05 at 18:03 +0100, Frederic Weisbecker wrote:
> > > 
> > > Now isn't the problem more in the fact that most of the swevents
> > > should be tracepoints? 
> > 
> > No, different interface, and I don't want to require TRACE=y, I already
> > utterly hate that x86 requires PERF=y.
> > 
> 
> This could be reduced to the strict minimum, say CONFIG_TRACEPOINT
> and some code around just to support the event ids.

Can't, software events already are an ABI so we'll have to support that
forever, but sure you can make something that reduces to the current
software event callback on TRACE=n and maps to the right software event
id when TRACE=y.

> Software events could be made optionals too.

Sure, but they're nowhere near as much code as tracepoints.

> > I already
> > utterly hate that x86 requires PERF=y.
> 
> 
> Me too, and it's my bad, so me double too. Sometimes I think
> we should make BREAKPOINTs optional, default y. I just don't know
> if something like this that has always been builtin can be made
> optional.

Simply for build testing that would be useful, we could make it an
embedded switch.

