Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZDQUG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZDQUG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 16:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZDQUGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 16:06:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbZDQUGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 16:06:17 -0400
Date: Fri, 17 Apr 2009 16:06:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/4] tracing: move __DO_TRACE out of line
In-Reply-To: <49E8DF78.2050203@goop.org>
Message-ID: <alpine.DEB.2.00.0904171604250.1016@gandalf.stny.rr.com>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-2-git-send-email-jeremy@goop.org> <20090417154640.GB8253@elte.hu> <20090417161005.GA16361@Krystal> <20090417162326.GG8253@elte.hu> <49E8D91F.1060005@goop.org> <20090417194613.GA30544@elte.hu>
 <49E8DF78.2050203@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 17 Apr 2009, Jeremy Fitzhardinge wrote:

> Ingo Molnar wrote:
> > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > 
> >   
> > > Taking __do_trace_sched_switch out of lines inserts this into the hot path
> > > (6 instructions, 31 bytes):
> > > 
> > >        cmpl    $0, __tracepoint_sched_switch+8(%rip)   #,
> > > __tracepoint_sched_switch.state
> > >        je      .L1748  #,
> > >        movq    -136(%rbp), %rdx        # next,
> > >        movq    -144(%rbp), %rsi        # prev,
> > >        movq    %rbx, %rdi      # rq,
> > >        call    __do_trace_sched_switch #
> > > .L1748:
> > >     
> > 
> > Hm, why isnt this off-line in the function? It's marked unlikely(), isnt it?
> >   
> 
> Yes, its unlikely().  I don't know why it doesn't move it; I've never seen
> unlikely() do anything useful.
> 

I wounder if it is because it is in context_switch(). Perhaps it moved it 
to the end of that function, but being that context_switch() is only used 
in schedule, it could have inlined it. The gcc was not smart enough to 
move this unlikely down to the end of the schedule function?

-- Steve

