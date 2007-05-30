Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbXE3RQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbXE3RQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbXE3RQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:16:45 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:37781 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753257AbXE3RQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:16:44 -0400
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <1180544796.32594.184.camel@imap.mvista.com>
References: <20070529125248.877196281@chello.nl>
	 <20070529130107.112347096@chello.nl>
	 <1180470525.32594.71.camel@imap.mvista.com>
	 <20070530132431.GA23947@elte.hu>
	 <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com>
	 <20070530134907.GA27085@elte.hu>
	 <1180544796.32594.184.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 30 May 2007 19:16:20 +0200
Message-Id: <1180545380.2958.1.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 10:06 -0700, Daniel Walker wrote:
> On Wed, 2007-05-30 at 15:49 +0200, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > [...] We can argue that sched_clock is "good enough".  If someone 
> > > wants better accounting of locks on some other arch, they can simply 
> > > change sched_clock to be more precise.
> > 
> > exactly. Imprecise sched_clock() if there's a better fast clock source 
> > available is a bug in the architecture code. If the only available 
> > clocksource is 1 msec resolution then there's no solution and nothing to 
> > talk about - lock statistics will be 1msec granular just as much as 
> > scheduling.
> 
> 
> I don't agree .. sched_clock() is obsoleted by timekeepings clocksource
> structure.. sched_clock() was a quick way to get lowlevel time stamps
> just for the scheduler. The timekeeping clocksource structure is a more
> complete solution.
> 
> >From the architecture perspective there are two low level clock hooks to
> implement one is sched_clock() , and at least one clocksource structure.
> Both do essentially the same thing. With timekeepings clocksource
> structure actually being easier to implement cause the math is built in.

I think you are mistaken here; the two are similar but not identical.

I see sched_clock() as fast first, accurate second. Whereas the
clocksource thing is accurate first, fast second.

There is room for both of them.

