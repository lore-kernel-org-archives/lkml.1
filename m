Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZDQT6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZDQT6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZDQT56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:57:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58923 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZDQT55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:57:57 -0400
Date: Fri, 17 Apr 2009 15:57:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/4] tracing: move __DO_TRACE out of line
In-Reply-To: <20090417194613.GA30544@elte.hu>
Message-ID: <alpine.DEB.2.00.0904171557060.1016@gandalf.stny.rr.com>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-2-git-send-email-jeremy@goop.org> <20090417154640.GB8253@elte.hu> <20090417161005.GA16361@Krystal> <20090417162326.GG8253@elte.hu> <49E8D91F.1060005@goop.org>
 <20090417194613.GA30544@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 17 Apr 2009, Ingo Molnar wrote:

> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Taking __do_trace_sched_switch out of lines inserts this into the 
> > hot path (6 instructions, 31 bytes):
> >
> >        cmpl    $0, __tracepoint_sched_switch+8(%rip)   #, __tracepoint_sched_switch.state
> >        je      .L1748  #,
> >        movq    -136(%rbp), %rdx        # next,
> >        movq    -144(%rbp), %rsi        # prev,
> >        movq    %rbx, %rdi      # rq,
> >        call    __do_trace_sched_switch #
> > .L1748:
> 
> Hm, why isnt this off-line in the function? It's marked unlikely(), 
> isnt it?
> 
> also, did you investigate the effect on the _instrumented_ function 
> itself? (i.e. the non-tracing related bits) A function call clobbers 
> various registers and creates pressure on gcc to shuffle registers 
> around.

I doubt it will make much difference. The inline version stil has the
function call to the trace point handler.

-- Steve

