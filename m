Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbZLJOxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbZLJOxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZLJOxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:53:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48271 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbZLJOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:53:17 -0500
X-Authority-Analysis: v=1.0 c=1 a=0ZecOPpkQPkA:10 a=7U3hwN5JcxgA:10 a=UmlGXnNOlJMCk4-AL2wA:9 a=bKUC4zAmx2KshRY1HsAA:7 a=YDpY795_3ghmdYKCMhMhVrZPiz8A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091210141121.GB1436@elte.hu>
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu>
	 <20091210120332.GA5042@nowhere>  <20091210141121.GB1436@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Dec 2009 09:53:23 -0500
Message-ID: <1260456803.2146.167.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 15:11 +0100, Ingo Molnar wrote:

> > > ftrace plugins were a nice idea originally and a clear improvement over 
> > > existing alternatives, but now that we've got a technicaly superior, 
> > > unified event framework that can do what the old plugins did and much 
> > > more, we want to improve that and not look back ...

Well to me the ftrace plugins still serve a purpose. The event
structures are very powerful for showing events. The plugins purpose is
to show functionality.

The latency tracers are a perfect example. Because they do not
concentrate on just events. But we must hit a maximum to save off the
trace. Just watching the events is not good enough. A separate buffer to
keep trace of the biggest latency is still needed.

> > 
> > 
> > I agree. If we can abstract it out in a struct trace_event rather than 
> > a struct tracer, then please try. I doubt we can't.
> > 
> > The trace events are more unified.

Yes because the trace events all pretty much do the same thing.

> > 
> > This makes me feel I'm going to try converting the function graph 
> > tracer into an event during the next cycle. [...]
> 
> Great!
> 
> > [...] It does not mean I could make it usable as a perf event right 
> > away in the same shot that said, as you can guess this is not a 
> > trivial plug. The current perf fast path is not yet adapted for that.
> 
> Yeah, definitely so. I'd guess it would be slower out of box - it hasnt 
> gone through nearly as many refinements yet.
> 
> > But at least this will be a good step forward.
> 
> Yeah.
> 
> Also, i'd suggest we call unified events 'ftrace events', as that is 
> what they really are: the whole TRACE_EVENT() infrastructure is the 
> crown jewel of ftrace and IMO it worked out pretty well.

For recording events, yes I totally agree. But for logic that needs to
pass data from one event to another, it is still a bit lacking.

> 
> I hope there wont be any significant culture clash between ftrace and 
> perf - we want a single, unified piece of instrumentation 
> infrastructure, we want to keep the best of both worlds, and want to 
> eliminate any weaknesses and duplications. As long as we keep all that 
> in mind it will be all fine.

I'm just not from the mind set that one product fits all needs. I never
was and that was the reason that I joined the Linux community in the
first place. I liked the old Unix philosophy of "Do one thing, and do it
well, and let all others interact, and interact with all others". Ftrace
itself never was one product. It just seemed that anything to do with
tracing was called ftrace. It started as just the function tracer. Then
it had plugins, then it got events, but these are separate entities all
together.

I designed the ftrace plugins as a way to plug in new features that I
could never dream of.

I wrote the ring buffer not for ftrace, but as a separate entity, that
is also used by the hard ware latency detector.

I designed the ftrace function tracer to not just work with ftrace but
to allow all others to hook to functions. This created the function
graph tracer, the stack tracer, and even LTTng hooks into it (not to
mention my own logdev).

I see that perf at the user level has ways to interact with it nicely,
although I don't know how well it interacts with other utilites. But the
perf kernel code seems to be a one way street. You can add features to
perf, but it is hard to use the perf infrastructure for something other
than perf (with the exception of the hardware perf events, that part has
a nice interface).

-- Steve


