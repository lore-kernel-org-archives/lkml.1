Return-Path: <linux-kernel-owner+w=401wt.eu-S1762699AbYFDX0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762699AbYFDX0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbYFDX0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:26:43 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:50758 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088AbYFDX0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:26:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYEAEy/RkhMQWRQ/2dsb2JhbACBVa8a
Date: Wed, 4 Jun 2008 19:26:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Hideo AOKI <haoki@redhat.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Kernel marker has no performance impact on ia64.
Message-ID: <20080604232640.GB8488@Krystal>
References: <48447052.3030300@redhat.com> <1212445965.6269.22.camel@lappy.programming.kicks-ass.net> <20080602232135.GA20173@Krystal> <4846210E.8080401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4846210E.8080401@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:23:02 up  4:03,  4 users,  load average: 0.93, 1.11, 1.04
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Hi Peter and Mathieu,
> 
> Thank you for your comments.
> 
> Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> >> On Mon, 2008-06-02 at 18:12 -0400, Hideo AOKI wrote:
> >>> Hello,
> >>>
> >>> I evaluated overhead of kernel marker using linux-2.6-sched-fixes
> >>> git tree, which includes several markers for LTTng, using an ia64
> >>> server.
> >>>
> >>> While the immediate trace mark feature isn't implemented on ia64,
> >>> there is no major performance regression. So, I think that we 
> >>> don't have any issues to propose merging marker point patches 
> >>> into Linus's tree from the viewpoint of performance impact.
> >> Performance is atm the least of the concerns regarding this work.
> >>
> >> I'm still convinced markers are too ugly to live.
> >>
> >> I also worry greatly about the fact that its too easy to expose too much
> >> to user-space. There are no clear rules and the free form marker format
> >> just begs for an inconsistent mess to arise.
> 
> Sure, I think we should review each point carefully
> and should make clear rules what is acceptable or not and why.
> 
> >>
> >> IMHO the current free-form trace_mark() should be removed from the tree
> >> - its great for ad-hoc debugging but its a disaster waiting to happen
> >> for anything else. Anybody doing ad-hoc debugging can patch it in
> >> themselves if needed.
> >>
> >> Regular trace points can be custom made; this has the advantages that it
> >> raises the implementation barrier and hopefully that encourages some
> >> thought in the process. It also avoid the code from growing into
> >> something that looks like someone had a long night of debugging.
> >>
> > 
> > Maybe we could settle for an intermediate solution : I agree with you
> > that defining the trace points in headers, like you did for the
> > scheduler, makes the code much cleaner and makes things much easier to
> > maintain afterward. However, having the trace_mark mechanism underneath
> > helps a lot in plugging a generic tracer (actually, if we can settle the
> > marker issue, I've got a kernel tracer, LTTng, that I've been waiting
> > for quite a while to push to mainline that I would like to post someday).
> 
> That's good to me.
> BTW, I'd like to know your plan, would those static inline functions be
> defined in new headers or marker.h(or other existing headers)?
> 

Hi Masami,

What do you think of kernel/sched-trace.h for the scheduler as proposed
by Peter ? Having these headers close to the c file instrumentation they
deal with seems to scale maintenance better. Placing all these in one
big kernel header included everywhere would require to recompile the
whole kernel when the header is touched, which is, I guess, not what we
want.

Mathieu

> Regards,
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
