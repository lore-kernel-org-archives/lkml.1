Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbYLCSBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbYLCSBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYLCSBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:01:41 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:49933 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYLCSBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:01:40 -0500
Date: Wed, 3 Dec 2008 23:31:31 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>, jan.kiszka@web.de
Cc: Jan Kiszka <jan.kiszka@web.de>, Gian Lorenzo Meocci <glmeocci@gmail.com>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       mbligh@google.com
Subject: Re: [ltt-dev] trace a futex
Message-ID: <20081203180131.GA2904@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <8d94e9280812021142j2eb5ca72td730410e97ccd9a1@mail.gmail.com> <20081202195015.GA25792@Krystal> <8d94e9280812021215m6a63d6c2l4e64acd26274953d@mail.gmail.com> <20081202215519.GA734@Krystal> <4935B25F.7010701@web.de> <20081203052640.GA13701@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203052640.GA13701@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 12:26:40AM -0500, Mathieu Desnoyers wrote:
> * Jan Kiszka (jan.kiszka@web.de) wrote:
> > Mathieu Desnoyers wrote:
> > > * Gian Lorenzo Meocci (glmeocci@gmail.com) wrote:
> > >> Hi Mathieu,
> > >>
> > >> thanks for your reply.
> > >>
> > >> I want specify that:
> > >> 1) I am already patching glibc (and, of course, nptl/pthread_*)
> > >> 2) I already add two event to pthread_mutex_lock. The first at the
> > >> beginning of the function and the second after all return 0 presented
> > >> on that function. But those two events are not enough to establish if
> > >> a pthread_mutex_lock has been blocking.
> > >> In fact I know only the time spent on pthread_mutex_lock. If this time
> > >> is little probably I hold the mutex otherwise I was been descheduled.
> > >>
> > >> So thanks a lot again,
> > >>
> > >>
> > > 
> > > Ok, then you will probably want to correlate your information with :
> > > 
> > > - scheduling activity regarding your threads
> > > - system call entry events, especially sys_futex. Note that a thread
> > >   calling sys_futex won't _necessarily_ be put to sleep.. it may still
> > >   be able to take the lock relatively quickly.
> > > 
> > > If you need more than that, we may think of instrumenting futex.c, but I
> > > am not sure this is required.
> > 
> > Haven't checked the state of instrumentation recently: Is the futex
> > operation visible in the trace now? It used to be not, and we often had
> > to guess the reason for sys_futex (wake, wait, pi or not pi, etc.) from
> > the context - or add ad-hoc instrumentation.
> > 
> > Jan
> > 
> 
> It still isn't instrumented, and I think it would be good to add such
> instrumentation.
> 
> Have a look at the patch done by K. Prasad for futex.c : it should
> probably be updated so it uses tracepoints instead of markers. Anyone
> would like to do this ?
> 
> See http://lkml.org/lkml/2008/4/15/125
> "[RFC PATCH 0/2] Debugging infrastructure for Futexes using Markers"
> 
> Mathieu
> 
> -- 

The patches pointed out at http://lkml.org/lkml/2008/4/15/125 aimed to
introduce static probes in the form of kernel markers in the futex
subsystem. Apart from tracing function boundaries and return values,
they were intended to be helpful in gathering performance measurements
and turn-around times for futex operations.

The patches did not elicit a favourable response then, and haven't been
converted to tracepoints (owing to the format string parameter
requirements for trace_mark and the fine-granular information being
exported by the proposed markers). I doubt if the community opinion has
changed now to accept the patch, if converted to tracepoints.

On a related note, just thinking if the proposed marker patch submission
from Google (http://lwn.net/Articles/298685/) has been sent to/accepted by
the community folks? It would be interesting to note details such as
granularity, level of information exported, number and choice of probe
points in the patch that is accepted by the community.

Thanks,
K.Prasad


