Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbXE3RJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbXE3RJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbXE3RJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:09:20 -0400
Received: from homer.mvista.com ([63.81.120.158]:9877 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbXE3RJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:09:19 -0400
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20070530134907.GA27085@elte.hu>
References: <20070529125248.877196281@chello.nl>
	 <20070529130107.112347096@chello.nl>
	 <1180470525.32594.71.camel@imap.mvista.com>
	 <20070530132431.GA23947@elte.hu>
	 <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com>
	 <20070530134907.GA27085@elte.hu>
Content-Type: text/plain
Date: Wed, 30 May 2007 10:06:35 -0700
Message-Id: <1180544796.32594.184.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 15:49 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > [...] We can argue that sched_clock is "good enough".  If someone 
> > wants better accounting of locks on some other arch, they can simply 
> > change sched_clock to be more precise.
> 
> exactly. Imprecise sched_clock() if there's a better fast clock source 
> available is a bug in the architecture code. If the only available 
> clocksource is 1 msec resolution then there's no solution and nothing to 
> talk about - lock statistics will be 1msec granular just as much as 
> scheduling.


I don't agree .. sched_clock() is obsoleted by timekeepings clocksource
structure.. sched_clock() was a quick way to get lowlevel time stamps
just for the scheduler. The timekeeping clocksource structure is a more
complete solution.

>From the architecture perspective there are two low level clock hooks to
implement one is sched_clock() , and at least one clocksource structure.
Both do essentially the same thing. With timekeepings clocksource
structure actually being easier to implement cause the math is built in.

It's clear to me that architectures will implement clocksource
structures .. However, they will not implement sched_clock() because
there is no benefit associated with it. As you have said the scheduler
works fine with a jiffies resolution clock, even a large number of x86
machines use a jiffies sched_clock() ..

So I don't think it's a bug if sched_clock() is lowres, and it shouldn't
be a bug in the future..

Daniel

