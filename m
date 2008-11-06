Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbYKFOrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbYKFOrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYKFOrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:47:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38125 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYKFOrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:47:01 -0500
Date: Thu, 6 Nov 2008 09:46:57 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: sys_sched_yield keeps locked irq before call of schedule()
In-Reply-To: <20081106143428.GE13023@elte.hu>
Message-ID: <alpine.DEB.1.10.0811060942300.31011@gandalf.stny.rr.com>
References: <c4e36d110811050457m36346fe1m63ffbb143f684637@mail.gmail.com> <20081105130113.GB29548@elte.hu> <c4e36d110811050509t51719671saa7eb337fca39656@mail.gmail.com> <20081106075754.GE8459@elte.hu> <alpine.DEB.1.10.0811060845340.31011@gandalf.stny.rr.com>
 <20081106143428.GE13023@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 6 Nov 2008, Ingo Molnar wrote:
> > 
> > Quick note. Currently ftrace_printk only shows up if it is set in the 
> > iter_ctrl.
> > 
> >   echo trace_printk > /debug/tracing/iter_ctrl
> > 
> > I'll send out a patch to have it on by default.
> 
> ok, agreed - but in that case please make the NOP tracer 
> tracing_enabled=0 by default. (we'll get a lot of ftrace_printk 
> tracepoints by default otherwise)

Hmm, I think it may be good to leave it on even for the nop tracer.

ftrace_printk's should not be out in open code unless someone is actually 
debugging it. You can use ftrace_printk inside a tracer to write stuff, 
but that printk should be protected somehow by the encompassing tracer.

i.e.

	some_tracer(void) {
		if (!tracer_enabled)
			return;
		ftrace_printk("my special stuff\n");
	}

I would think if someone is debugging their code by using ftrace_printk, 
they probably want it to show up right away, without having to remember to 
do a...


	echo trace_printk > /debug/tracing/iter_ctrl

And still have it show up in the nop tracer.

-- Steve

