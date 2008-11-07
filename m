Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbYKGQ4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbYKGQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYKGQ4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:56:16 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:57105 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752450AbYKGQ4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:56:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAHr9E0lMQWxa/2dsb2JhbACBdsgUg1Y
Date: Fri, 7 Nov 2008 11:51:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Howells <dhowells@redhat.com>
Cc: Nicolas Pitre <nico@cam.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-ID: <20081107165112.GC22134@Krystal>
References: <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca> <20081106220530.5b0e3a96.akpm@linux-foundation.org> <25298.1226055815@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <25298.1226055815@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:50:37 up 155 days, 21:31,  6 users,  load average: 1.75, 1.03,
	0.81
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Howells (dhowells@redhat.com) wrote:
> Nicolas Pitre <nico@cam.org> wrote:
> 
> > > I mean, the darned thing is called from sched_clock(), which can be
> > > concurrently called on separate CPUs and which can be called from
> > > interrupt context (with an arbitrary nesting level!) while it was running
> > > in process context.
> > 
> > Yes!  And this is so on *purpose*.  Please take some time to read the 
> > comment that goes along with it, and if you're still not convinced then 
> > look for those explanation emails I've already posted.
> 
> I agree with Nicolas on this.  It's abominably clever, but I think he's right.
> 
> The one place I remain unconvinced is over the issue of preemption of a process
> that is in the middle of cnt32_to_63(), where if the preempted process is
> asleep for long enough, I think it can wind time backwards when it resumes, but
> that's not a problem for the one place I want to use it (sched_clock()) because
> that is (almost) always called with preemption disabled in one way or another.
> 
> The one place it isn't is a debugging case that I'm not too worried about.
> 

I am also concerned about the non-preemption off case.

Then I think the function should document that it must be called with
preempt disabled.

Mathieu

> > > /*
> > >  * Caller must provide locking to protect *caller_state
> > >  */
> > 
> > NO!  This is meant to be LOCK FREE!
> 
> Absolutely.
> 
> David

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
