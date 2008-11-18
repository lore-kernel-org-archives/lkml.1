Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYKRPL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYKRPL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYKRPLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:11:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37374 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbYKRPLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:11:46 -0500
Date: Tue, 18 Nov 2008 10:11:45 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun
 field
In-Reply-To: <20081118150249.GE30358@elte.hu>
Message-ID: <alpine.DEB.1.10.0811181010590.15003@gandalf.stny.rr.com>
References: <4920D571.4050007@gmail.com> <20081117084923.GD28786@elte.hu> <alpine.DEB.1.10.0811180918480.15003@gandalf.stny.rr.com> <20081118144838.GB30358@elte.hu> <alpine.DEB.1.10.0811180951410.15003@gandalf.stny.rr.com> <20081118150249.GE30358@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Nov 2008, Ingo Molnar wrote:
> > 
> > What would be needed is to make a per-arch stack call. Perhaps have 
> > a:
> > 
> >    arch_check_stack(&this_size, &max_stack_trace, &max_stack_size);
> > 
> > Where a weak function can be defined to return nothing. But the arch 
> > can check which stack the "this_size" variable is on and run the 
> > stack tracer against that stack.
> > 
> > Maybe we should have two stack traces, a stack_trace file and a 
> > stack_trace_irq ?
> > 
> > Because, some archs, like x86_64 have different size stacks. The 
> > thread stack is 8K where as the IRQ stack is 4K.  We may want to see 
> > which IRQ stack call is the worst, and not compare it to the thread 
> > stack call.
> 
> ... and on 64-bit x86 the IRQ stacks are 16K, and some of the IST 
> exception stacks have different sizes as well.

Heh, I expect that we will not support IRQ stacks until 2.6.30 or 31 :-/

-- Steve

