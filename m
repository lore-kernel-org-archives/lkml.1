Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYIWDoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYIWDoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 23:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYIWDoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 23:44:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64870 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbYIWDoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 23:44:03 -0400
Date: Mon, 22 Sep 2008 23:43:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Roland Dreier <rdreier@cisco.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
In-Reply-To: <alpine.LFD.1.10.0809222021230.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0809222335400.26011@gandalf.stny.rr.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
 <48D832B6.3010409@redhat.com> <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org> <adaod2f649o.fsf@cisco.com> <alpine.LFD.1.10.0809222021230.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 22 Sep 2008, Linus Torvalds wrote:

> 
> 
> On Mon, 22 Sep 2008, Roland Dreier wrote:
> >
> > Just like Einstein said, it really seems to me that the order of things
> > depends on your frame of reference.
> 
> Heh. Yes. In general, there is no single ordering unless you actually use 
> a serializing lock on all CPU's involved. 
> 
> And exactly as in the theory of relativity, two people on different CPU's 
> can actually validly _disagree_ about the ordering of the same event. 
> There are things that act as "light-cones" and are borders for what 
> everybody can agree on, but basically, in the absence of explicit locks, 
> it is very possible that no such thing as "ordering" may even exist.
> 
> Now, an atomic increment on a single counter obviously does imply *one* 
> certain ordering, but it really only defines the ordering of that counter 
> itself. It does not at all necessarily imply any ordering on the events 
> that go on around the counter in other unrelated cachelines.
> 
> Which is exactly why even a global counter in no way orders "events" in 
> general, unless those events have something else that does so.

Hmm, I've been pretty spoiled by x86 mostly ording things correctly, and 
the not x86 boxes I've used has mostly been UP.

But, with that, with a global atomic counter, and the following trace:

cpu 0: trace_point_a
cpu 1: trace_point_c
cpu 0: trace_point_b
cpu 1: trace_point_d


Could the event a really come after event d, even though we already hit 
event b?

But I guess you are stating the fact that what the computer does 
internally, no one really knows. Without the help of real memory barriers, 
ording of memory accesses is mostly determined by tarot cards.

But basically, the perceived result of assembly commands is suppose to be 
accurate at the user level.  The traces that I've used not only shows the 
order (or perceived order) of events, but also the output of the corrupted 
data when the race happens. Usually with the two together, you can pretty 
much guarantee that the traced events actually did occur in the order 
presented.

But without some perceived accurate ording, even when you do see the 
corrupted data, the events can easily be misleading, even on an arch that 
usually orders the events as seen by the user.

-- Steve

