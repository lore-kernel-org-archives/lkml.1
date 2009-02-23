Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZBWSDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZBWSDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZBWSDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:03:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57581 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbZBWSDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:03:43 -0500
Date: Mon, 23 Feb 2009 13:03:39 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] tracing/ftrace: add missing wake-up on some callsites
In-Reply-To: <20090223173714.GA601@elte.hu>
Message-ID: <alpine.DEB.2.00.0902231303000.18221@gandalf.stny.rr.com>
References: <49a1cc8f.2283420a.54d2.ffff8461@mx.google.com> <alpine.DEB.2.00.0902231034570.18221@gandalf.stny.rr.com> <alpine.DEB.2.00.0902231039290.18221@gandalf.stny.rr.com> <20090223162630.GG5961@nowhere> <alpine.DEB.2.00.0902231151020.18221@gandalf.stny.rr.com>
 <20090223170528.GH5961@nowhere> <alpine.DEB.2.00.0902231211230.18221@gandalf.stny.rr.com> <20090223173714.GA601@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 23 Feb 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > Which would send a delayed work to wake up?
> > 
> > No, I was thinking that trace_delay_wake_up() would be called 
> > by these dangerous call sites. Then a per_cpu flag could be 
> > set. We could have a trace point in the scheduler code that is 
> > outside holding a runqueue lock, and this trace point would 
> > call a trace function that will clear the per cpu flag, and 
> > then call trace_wake_up().
> 
> No, that's very roundabout and ugly. If we putting a tracepoint 
> there we might as well put real scheduler code there that looks 
> for such a flag. But i'm not convinced we need a flag ...

Just a suggestion. I was trying to keep the tracer from being an overhead. 
But what else would you suggest? Just having the scheduler call 
trace_wakeup?

-- Steve

