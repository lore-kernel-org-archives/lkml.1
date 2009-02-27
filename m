Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbZB0PDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbZB0PDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 10:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbZB0PDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 10:03:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56274 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbZB0PDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 10:03:08 -0500
Date: Fri, 27 Feb 2009 10:03:03 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] vsprintf: unify the format decoding layer for its
 3 users
In-Reply-To: <20090226224656.5785de9e.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0902270955100.25593@gandalf.stny.rr.com>
References: <49a38304.0506d00a.1f4b.406d@mx.google.com> <20090226130243.GA22460@elte.hu> <20090226170524.GB5889@nowhere> <20090226174303.GC29439@elte.hu> <20090226174547.GC5889@nowhere> <20090226175225.GA4527@elte.hu> <20090226183415.GE5889@nowhere>
 <20090226185208.GA6658@nowhere> <20090226185635.GA12895@elte.hu> <20090227061936.GA5318@nowhere> <20090226224656.5785de9e.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 26 Feb 2009, Andrew Morton wrote:

> On Fri, 27 Feb 2009 07:19:37 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > 
> > An new optimization is making its way to ftrace. Its purpose is to
> > make ftrace_printk() consuming less memory and be faster.
> > 
> > Written by Lai Jiangshan, the approach is to delay the formatting
> > job from tracing time to output time.
> > Currently, a call to ftrace_printk will format the whole string and
> > insert it into the ring buffer.
> 
> It does that?   eek.

Yes, I remember when Linus suggested having a pointer to the format and
the args saved. There was two issues I found.

1) You still needed to read the format string to find out what arguments 
   to save.

2) The format string could be part of module data, and if the module is
   unloaded between the time of recording and the time of reading the 
   trace, we now have a format pointer pointing to God knows what.

When posting ftrace_printk, I said this was for debugging purposes only,
and I was not about to work on optimizations there of. But Frederic and
Lai are doing a great job in that aspect ;-)

HAHAHAHHAAAA!!!! My evil scheme is working! I post some sub-optimal code, 
and have others do the nasty work for me!!!!

Oh, did I just say that out loud?

-- Steve
