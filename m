Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbXEWV66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbXEWV66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbXEWV6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:58:51 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:42307
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbXEWV6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:58:51 -0400
Date: Wed, 23 May 2007 14:57:56 -0700
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH 0/7] lock contention tracking -v2
Message-ID: <20070523215756.GA26450@gnuppy.monkey.org>
References: <20070523072618.129001605@chello.nl> <20070523103311.GA13482@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523103311.GA13482@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 12:33:11PM +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
...
> > It also measures lock wait-time and hold-time in nanoseconds. The 
> > minimum and maximum times are tracked, as well as a total (which 
> > together with the number of event can give the avg).
> > 
> > All statistics are done per lock class, per write (exclusive state) 
> > and per read (shared state).
> > 
> > The statistics are collected per-cpu, so that the collection overhead 
> > is minimized via having no global cachemisses.
...
> really nice changes! The wait-time and hold-time changes should make it 
> as capable as lockmeter and more: lockmeter only measured spinlocks, 
> while your approach covers all lock types (spinlocks, rwlocks and 
> mutexes).
> 
> The performance enhancements in -v2 should make it much more scalable 
> than your first version was. (in fact i think it should be completely 
> scalable as the statistics counters are all per-cpu, so there should be 
> no cacheline bouncing at all from this)

per cpu is pretty important since you can potentially hit that logic more
often with your wait-time code. You don't want to effect the actual
measurement with the measurement code. It's that uncertainty principal thing.

It is looking pretty good. :) You might like to pretty the output even more,
but it's pretty usable as is.

bill

