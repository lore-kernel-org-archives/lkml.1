Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbYIWDgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbYIWDgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 23:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYIWDgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 23:36:38 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:65170 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753338AbYIWDgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 23:36:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAIcA2EhMQWq+/2dsb2JhbACBXbUogWY
Date: Mon, 22 Sep 2008 23:36:35 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland Dreier <rdreier@cisco.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080923033635.GK24937@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com> <48D832B6.3010409@redhat.com> <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org> <adaod2f649o.fsf@cisco.com> <alpine.LFD.1.10.0809222021230.3265@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809222021230.3265@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:31:31 up 110 days,  8:11,  7 users,  load average: 0.32, 0.37,
	0.39
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
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
> 
> 		Linus
> 

Unless I am missing something, in the case we use an atomic operation
which implies memory barriers (cmpxchg and atomic_add_return does), one
can be sure that all memory operations done before the barrier are
completed at the barrier and that all memory ops following the barrier
will happen after.

Did you have something else in mind ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
