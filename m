Return-Path: <linux-kernel-owner+w=401wt.eu-S1752981AbYKFPf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbYKFPf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYKFPew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:34:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35900 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbYKFPev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:34:51 -0500
Date: Thu, 6 Nov 2008 10:34:50 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, alan@redhat.com
Subject: Re: [PATCH] ftrace: add an fsync tracer
In-Reply-To: <20081106070157.065b2dcc@infradead.org>
Message-ID: <alpine.DEB.1.10.0811061020311.31011@gandalf.stny.rr.com>
References: <20081105094902.27ec4b39@infradead.org> <1225976138.7803.4485.camel@twins> <20081106060624.58a0f967@infradead.org> <1225981141.7803.4577.camel@twins> <20081106063108.02b4813d@infradead.org> <1225983052.7803.4623.camel@twins>
 <20081106070157.065b2dcc@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 6 Nov 2008, Arjan van de Ven wrote:

> > 
> > The syscall tracer will also have told you about that open.
> 
> ok so now you're turning a simple problem into "also track all open,
> openat, dup, dup2, close, unix domain fs passing etc". That doesn't
> sound like an improvement to me.
> And even the "open/fd" family isn't enough, because the open will be
> relative pathnames, so I now also need to second guess the PWD, and
> then follow a chain of "chdir" calls as well and then resolve the
> ".."'s in the path. And follow symlinks that may no longer be the same
> symlink it used to be. Etc. Etc.
> 
> No sorry, this really is not a viable approach.
> 
> And that goes beyond the fsync tracer. Anybody who thinks that syscall
> tracing is the right approach needs to seriously think about it; it
> really looks like the same problem as with audit... it started out with
> a bad hack that did it at the syscall level but it was likewise shown
> to just not be the right level. I am rather certain that the same will
> be shown for tracing.

What I would like is a single "event tracer" that does all of this.
But add the ability to start and stop different events. We could start
with this tracer, and then add more events to this tracer. Have a
separate file to show which events are available.

This will keep the 'available_tracers' file small, but it would be fine
if the 'events' file grew large.

-- Steve
