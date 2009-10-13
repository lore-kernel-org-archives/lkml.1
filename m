Return-Path: <linux-kernel-owner+w=401wt.eu-S934450AbZJMWds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934450AbZJMWds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760892AbZJMWdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:33:47 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:61945 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760372AbZJMWdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:33:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicFAHeZ1EpMRK1g/2dsb2JhbACBUdgMhC0E
Date: Tue, 13 Oct 2009 18:32:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/5] [PATCH 1/5] function-graph/x86: replace unbalanced
	ret with jmp
Message-ID: <20091013223237.GB14430@Krystal>
References: <20091013203349.814936710@goodmis.org> <20091013203425.042034383@goodmis.org> <20091013204702.GA4533@Krystal> <1255468214.7113.2396.camel@gandalf.stny.rr.com> <20091013212126.GA8039@Krystal> <1255469210.7113.2436.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1255469210.7113.2436.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:29:16 up 56 days,  9:18,  3 users,  load average: 0.30, 0.26,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2009-10-13 at 17:21 -0400, Mathieu Desnoyers wrote:
> 
> > > What it was:
> > > 
> > > call function
> > >   function:
> > >   call mcount
> > >      mcount:
> > >      call ftrace_entry
> > 
> > Can we manage to change this call
> 
> Note, that call jumps to C code.
> 
> > 
> > >        ftrace_entry:
> > >        mess up with return code of caller
> > >        ret
> > 
> > .. and this ret for 2 jmp instructions too ?
> 
> The code is all in C, and it too calls functions. Not sure where this
> helps out any. The ret here matches their calls. Thus the prediction
> will work.
> 

Oh, OK. I thought the callback was in assembly. That's a bit more work
than I thought.

> > 
> > Given that we have no choice but to kill call/ret prediction logic, I
> > think it might be good to try to use this logic as little as possible
> > (by favoring jmp jmp over call/ret when the return target is invariant).
> > 
> > That's just an idea, benchmarks could prove me right/wrong.
> 
> I don't see how this would help. And I'm not about to waste time
> experimenting. What's the rational?
> 

The idea is that call/ret are fast when predictions are right. In this
case, I wonder if the fact that we trash the call/ret prediction (even
if this happens after the paired call/ret) would have an impact on
balanced call/ret in the tracing code path. I doubt so, but who knows.

Probably not worth spending much time on this. It would just have been
nice to try if the implementation would have been trivial.

Thanks,

Mathieu

> -- Steve
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
