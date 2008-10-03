Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbYJCUBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbYJCUBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYJCUBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:01:44 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:64496 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753049AbYJCUBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:01:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEAKMS5khMQWq+/2dsb2JhbACBcbpqgWg
Date: Fri, 3 Oct 2008 15:56:40 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
Message-ID: <20081003195640.GA15639@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <alpine.DEB.1.10.0809200451420.9362@gandalf.stny.rr.com> <20080920135548.GB23215@Krystal> <20080920071232.46908040@infradead.org> <20080922185209.GC6349@Krystal> <20081002152851.GC3220@redhat.com> <20081003161154.GA4139@Krystal> <20081003183737.GD3167@redhat.com> <20081003191026.GC9626@Krystal> <20081003192536.GE3167@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081003192536.GE3167@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:55:35 up 121 days, 36 min,  5 users,  load average: 0.64,
	0.64, 0.42
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Fri, Oct 03, 2008 at 03:10:26PM -0400, Mathieu Desnoyers wrote:
> > * Jason Baron (jbaron@redhat.com) wrote:
> > > On Fri, Oct 03, 2008 at 12:11:54PM -0400, Mathieu Desnoyers wrote:
> > > > > > > > How about :
> > > > > > > > 
> > > > > > > >   trace_mark(ftrace_evname, "size %lu binary %pW",
> > > > > > > >     sizeof(mystruct), mystruct);
> > > > > > > >   or
> > > > > > > >   trace_mark(sched_wakeup, "target_pid %ld", task->pid);
> > > > > > > > 
> > > > > > > > Note the namespacing with buffers being "ftrace" and "sched" here.
> > > > > > > > 
> > > > > > > > That would encapsulate the whole
> > > > > > > >   - Event ID registration
> > > > > > > >   - Event type registration
> > > > > > > >   - Sending data out
> > > > > > > >   - Enabling the event source directly at the source
> > > > > > > > 
> > > > > > > > We can then export the markers through a debugfs file and let userland
> > > > > > > > enable them one by one and possibly connect systemtap filters on them
> > > > > > > > (one table of registered filters, one table for the markers, a command
> > > > > > > > file to connect/disconnect filters to/from markers).
> > > > > > > 
> > > > > > > I would like to ask for the following from the start: have a field for
> > > > > > > a longer description of the marker that describes it's usage and
> > > > > > > context. Getting this there from the start is critical, because only
> > > > > > > when adding the marker point do people still really remember why/what
> > > > > > > (and having to type a good description also helps them to realize if
> > > > > > > this is the right point or not). This can then be exposed to the user
> > > > > > > so he has a standing chance of knowing what the marker is about.
> > > > > > > 
> > > > > > > It also has a standing chance of being updated when the code changes
> > > > > > > this way
> > > > > > > 
> > > > > > 
> > > > > > I agree, and I think it might be required in both markers and
> > > > > > tracepoints.
> > > > > > 
> > > > > > Given that tracepoints are declared in a global header
> > > > > > (DECLARE_TRACE()), I would add this kind of description here. Tracepoint
> > > > > > uses within the kernel code (statements like :
> > > > > >   trace_sched_switch(prev, next);
> > > > > > added to the scheduler) would therefore be tied to the description
> > > > > > without having to contain it in the core kernel code.
> > > > > > 
> > > > > > Markers, on the other hand, could become the "event description"
> > > > > > interface which is exported to userspace. Considering that, I guess it's
> > > > > > as important to let a precise description follow the markers.
> > > > > > 
> > > > > > Mathieu
> > > > > > 
> > > > > >
> > > > > 
> > > > > hi,
> > > > > 
> > > > > Tracepoints and markers seem to both have their place, with tracepoints
> > > > > being integral to kernel users, and markers being important for
> > > > > userspace. However, it seems to me like there is overlap in the
> > > > > code and an extra level of indirection when markers are layered on
> > > > > tracespoints. could they be merged a bit more?
> > > > > 
> > > > > What if we extended DEFINE_TRACE() to also create a
> > > > > 'set_marker(marker_cb)' function where 'marker_cb' has the function signature:
> > > > > 
> > > > > marker_cb(<tracepoint prototype>, *marker_probe_func);
> > > > > 
> > > > > We then also create 'register_marker_##name' function in DEFINE_TRACE(),
> > > > > which allows one to regiser marker callbacks in the usual way.
> > > > > 
> > > > > Then 'marker_cb' function is then called in '__DO_TRACE' if anybody has
> > > > > registered a marker (which can set the tracepoint.state appropriately).
> > > > > 
> > > > > The 'marker_cb' function then marshalls its arguemnts and passes them
> > > > > through to the marker functions that were registered.
> > > > > 
> > > > > I think in this way we can simplify the tracepoints and markers by
> > > > > combining them to a large extent.
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > -Jason
> > > > > 
> > > > 
> > > > I think what you propose here is already in y LTTng tree in a different
> > > > form. It's a patch to markers to allow declaring a marker which enables
> > > > an associated tracepoint when enabled. This way, we can have a marker
> > > > (exposed to userspace) connecting itself automatically to a tracepoint
> > > > when enabled.
> > > > 
> > > > It's here :
> > > > http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commitdiff;h=d52ea7c48f47a1179aee01636d515cfea4ff6ede;hp=0a7b5c02209f3582ed1369ec818a1b389bd45a09
> > > > 
> > > > Note that locking depends on the psrwlock patch so we can have nested
> > > > module list readers. Otherwise locking becomes _really_ messy. :-(
> > > > 
> > > > Mathieu
> > > > 
> > > 
> > > That patch simplifies using markers with tracepoints and couples
> > > markers and tracepoints much more closely. But I was proposing to make
> > > the coupling tighter...
> > > 
> > > Couldn't 'marker_probe_register()' register the marker directly with
> > > the tracepoint callsite? Have DEFINE_TRACE() take an additional argument
> > > which references a marker callback funtion. That function would look 
> > > like (very loose C code):
> > > 
> > > marker_blah_callback(TPPROTO(arg1, arg2), marker_probe_func *probe,
> > 
> > I don't want the tracepoints to be coupled with markers (which are a
> > userspace API). The other way around is fine : letting a marker
> > automatically enable a tracepoint makes sense, but the opposite would
> > tie the in-kernel API (tracepoint) to the external marker
> > representation, and I would like to avoid that.
> > 
> 
> The interface to markers is still marker_probe_register() and
> marker_probe_unregister(). I don't see how that changes with this
> proposal?
> 

"Have DEFINE_TRACE() take an additional argument which references a
marker callback funtion." -> it would tie the tracepoint definition to a
marker. Or am I misunderstanding something ?

Mathieu

> 
> > And how do you plan to deal with :
> > 
> > TPPROTO(arg1, arg2) == void ?
> > 
> > C won't let you define stuff like :
> > 
> > blah(void, marker_probe_func *probe, void *private_data)
> > 
> 
> it'd be simple enough to pass the the noargs requirement down as an
> extra argument to DO_TRACE(), and then invoke the callback with no arguments.
> 
> thanks,
> 
> -Jason
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
