Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbXJ3S4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbXJ3S4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 14:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbXJ3S4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 14:56:44 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:53095 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752430AbXJ3S4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 14:56:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAFobJ0dMQWvU/2dsb2JhbACBWo5Y
Date: Tue, 30 Oct 2007 14:56:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] Create kinst/ or ki/ directory ?
Message-ID: <20071030185639.GA9077@Krystal>
References: <20071029215138.GA4233@Krystal> <20071029154741.cb093f55.rdunlap@xenotime.net> <4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal> <472667F3.3000505@garzik.org> <20071030172442.GA4477@Krystal> <alpine.LFD.0.999.0710301044110.30120@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710301044110.30120@woody.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:22:57 up 92 days, 18:41,  4 users,  load average: 0.68, 0.72, 0.78
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Tue, 30 Oct 2007, Mathieu Desnoyers wrote:
> >
> > * Jeff Garzik (jeff@garzik.org) wrote:
> > ...
> > > Pick a shorter word like probes or profile or what... or better yet... 
> > > just leave most things in their current directories.
> > ...
> > 
> > 
> > How about something along the
> > 
> > kinst or ki
> > 
> > lines ?
> > 
> > (for "kernel instrumentation")
> 
> No, that's horrible.
> 
> Also, in general, why do people want to have an "instrumentation" thing? 
> Yes, you can put random things into the same box, but that doesn't make 
> them be the same thing. Personally, I don't think "instrumentation" is 
> very useful at all. I consider "profiling" and "markers" to be two 
> fundamentally different things, and putting them both in the same box does 
> not make them any more similar. 
> 
> Yes, technically they are both "instrumentation", but hey, technically the 
> VM and the VFS layer are both "infrastructure", but we don't put *those* 
> in a "infrastructure" subdirectory.
> 

The key idea for collapsing profiling, markup and tracing was that
marking up the code is required for both profiling and tracing. It's
only the code that is called from that markup site that differs.

> In other words, the fact that two different things share some attribute 
> does not mean that they should be collapsed together by that attribute, 
> does it?

It becomes interesting when they can share code and/or a common control
architecture. The fact that markup could be shared between profiling and
tracing could be a good incentive to do so.

> 
> I think "instrumentation" was/is a particularly bad thing to group things 
> by. It doesn't actually tell you anything about the thing, and it's not 
> even true that some people are interested in "instrumentation"  and others 
> aren't. 
> 

Ok, so maybe we should keep "markup", "tracing" and "profiling"
separately and see how things evolve.


> For example: I think profiling support is something REALLY FUNDAMENTAL. 
> It's something each and every developer should generally care about, and 
> OProfile should be considered an indispensable tool for any developer, on 
> par with something like gdb.
> 
> In contrast, we should *not* expect most people to do any kernel markers 
> etc. That's a very esoteric thing.
> 

With SMP systems becoming cheap commodity hardware, each and every
developer increasingly face thorny race problems, both in user-space
apps and in the kernel, which may involve hypervisor-kernel-userspace
interaction. Sadly, the blame is often put on kernel developers because
tools like gdb, oprofile and strace are practically useless to solve
such problems and people lack the right tool for the job.

Therefore, marking up the code to perform tracing should not be
considered esoteric: it's a very useful tool when one needs to
understand what is happening in their large scale system. Userspace
doesn't always have the ability to isolate problems and, worse, some
problems a just unreproduceable when tried to be isolated. I think it is
sensible to give them a tool that helps them understanding what is going
on.


> So I actually think that the current Kconfig.instrumentation should be 
> *removed*. Rather than adding more groupings based on that fundamentally 
> flawed premise of false commonality.
> 

Should it come with a re-duplication of it's content into each
architecture, which was the case previously ? The oprofile and kprobes menu
entries were litteraly cut and pasted from one architecture to another.
Should we put its content in init/Kconfig then ?

Regards,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
