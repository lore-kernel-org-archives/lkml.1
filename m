Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZB0Ieo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZB0Ieo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZB0Ieg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:34:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524AbZB0Ief (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:34:35 -0500
Date: Fri, 27 Feb 2009 00:33:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] vsprintf: unify the format decoding layer for its
 3 users
Message-Id: <20090227003330.67406cc5.akpm@linux-foundation.org>
In-Reply-To: <20090227082035.GD3609@elte.hu>
References: <20090226130243.GA22460@elte.hu>
	<20090226170524.GB5889@nowhere>
	<20090226174303.GC29439@elte.hu>
	<20090226174547.GC5889@nowhere>
	<20090226175225.GA4527@elte.hu>
	<20090226183415.GE5889@nowhere>
	<20090226185208.GA6658@nowhere>
	<20090226185635.GA12895@elte.hu>
	<20090227061936.GA5318@nowhere>
	<20090226224656.5785de9e.akpm@linux-foundation.org>
	<20090227082035.GD3609@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 09:20:35 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 27 Feb 2009 07:19:37 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > An new optimization is making its way to ftrace. Its purpose 
> > > is to make ftrace_printk() consuming less memory and be 
> > > faster.
> > > 
> > > Written by Lai Jiangshan, the approach is to delay the 
> > > formatting job from tracing time to output time. Currently, 
> > > a call to ftrace_printk will format the whole string and 
> > > insert it into the ring buffer.
> > 
> > It does that?  eek.
> 
> hm, did you expect something else from a printf based interface?
> 

Well, it's very obvious that it will be very slow.  We've never had any
motivation for caring about the performance of the printf functions
because they're called so infrequently.

I mean...  the whole thing's designed to fail, really - if we care
about the performance impact of tracing, we can't trace with per-tracepoint
printf()s.  If we don't care about the performance impact of tracing
then fine, leave ftrace_printk() as it is - slow.

Trying to make something which is inherently slow run slightly faster seems... 
odd.


Oh well, that's beside the point.  Right now I'm trying to provoke you
guys into revealing what the implementation problems are, and what
you're proposing to do.  Stuff like: how will it work with 64-bit
quantities on arm/s390/etc.
