Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbZDMXLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbZDMXLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbZDMXLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:11:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52241 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbZDMXLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:11:05 -0400
Date: Mon, 13 Apr 2009 19:11:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing, boottrace: Move include/trace/boot.h to
 include/linux/boottrace.h
In-Reply-To: <20090413222436.GF8514@elte.hu>
Message-ID: <alpine.DEB.2.00.0904131907020.3041@gandalf.stny.rr.com>
References: <49E2B763.8060706@cn.fujitsu.com> <20090413142531.GC5977@nowhere> <20090413222436.GF8514@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 14 Apr 2009, Ingo Molnar wrote:

> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Apr 13, 2009 at 11:54:11AM +0800, Zhaolei wrote:
> > > Impact: refactor code, no functionality changed
> > > 
> > > Files in include/trace/ should be definition of tracepoints, and header
> > > file for boot trace should put to include/linux/.
> > > 
> > > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > > ---
> > 
> > Until now I had the opinion that it's good to let every tracing 
> > headers to be placed in include/trace/* because they are not 
> > useful for anything else than the tracer itself so that we don't 
> > encumber include/linux for private things.
> > 
> > So that we have both tracepoints/trace_events plus the low-level 
> > tracers headers in include/trace/*
> > 
> > I'm not opposite to this change, but seeing this patch and the 
> > recent divide of kmemtrace headers, I would like to know the 
> > opinion of Ingo and Steven about the strict role of 
> > include/trace/* Is it only for tracepoints-like bits, or oslo 
> > intended for every private tracing purposes?
> 
> The header split itself is probably good to do - to keep the 'pure' 
> portions of tracepoint definitions cleanly separated from more 
> functional details like kmem tracer initialization.
> 
> The move to include/linux/ is indeed more debatable. I think if a 
> header says 'footrace.h' in its name, it could easily be in 
> include/trace/foo.h instead? Makes for a tidier structure - 
> include/linux/ is massively over-crowded already.
> 
> Steve, what do you think?

We actually discussed this a little at the Linux Collaboration Summit.
The idea was to keep only the tracepoints aka TRACE_EVENT code in 
include/trace/ and perhaps special headers that work with the TRACE_EVENT 
macros. But the infrastructure of the tracers would stay in include/linux.

The rational is that we have a separate directory reserved only for trace 
points / trace events. Adding more headers into that directory would make 
it a bit harder to see right away what trace events where defined for a 
particular kernel source.

I'm getting ready to post my code to allow trace events for modules, and 
it cleans up this directory a little.

-- Steve

