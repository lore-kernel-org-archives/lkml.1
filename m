Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbZDROQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbZDROQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 10:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbZDROQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 10:16:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43503 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbZDROQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 10:16:25 -0400
Date: Sat, 18 Apr 2009 10:16:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/4] tracing: move __DO_TRACE out of line
In-Reply-To: <20090418065331.GA1942@Krystal>
Message-ID: <alpine.DEB.2.00.0904181013450.1016@gandalf.stny.rr.com>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-2-git-send-email-jeremy@goop.org> <20090417154640.GB8253@elte.hu> <20090417161005.GA16361@Krystal> <20090417162326.GG8253@elte.hu> <49E8D91F.1060005@goop.org>
 <20090418065331.GA1942@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 18 Apr 2009, Mathieu Desnoyers wrote:
> 
> tbench test
> 
> kernel : 2.6.30-rc1
> 
> running on a 8-cores x86_64, localhost server
> 
> tracepoints inactive :
> 
> 2051.20 MB/sec

Is this with or without inlined trace points?

It would be interesting to see:

time with tracepoints not configured at all

time with inline tracepoints (inactive)

time with out-of-line tracepoints (inactive)

Because if inline trace points affect the use of normal operations when 
inactive, that would be a cause against trace points all together.

-- Steve

> 
> "google" tracepoints activated, flight recorder mode (overwrite) tracing
> 
> inline tracepoints
> 
> 1704.70 MB/sec (16.9 % slower than baseline)
> 
> out-of-line tracepoints
> 
> 1635.14 MB/sec (20.3 % slower than baseline)
> 
> So the overall tracer impact is 20 % bigger just by making the
> tracepoints out-of-line. This is going to add up quickly if we add as
> much function calls as we currently find in the event tracer fast path,
> but LTTng, OTOH, has been designed to minimize the number of such
> function calls, and you see a good example of why it's been such an
> important design goal above.
> 
> About cache-line usage, I agree that in some cases gcc does not seem
> intelligent enough to move those code paths away from the fast path.
> What we would really whant there is -freorder-blocks-and-partition, but
> I doubt we want this for the whole kernel, as it makes some jumps
> slightly larger. One thing we should maybe look into is to add some kind
> of "very unlikely" builtin expect to gcc that would teach it to really
> put the branch in a cache-cold location, no matter what.
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
