Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbZE1Pm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbZE1Pm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbZE1Pmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:42:51 -0400
Received: from www.tglx.de ([62.245.132.106]:43020 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219AbZE1Pmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:42:51 -0400
Date: Thu, 28 May 2009 17:42:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: annotate emit_log_char() notrace
In-Reply-To: <alpine.DEB.2.00.0905281057490.905@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0905281732010.3397@localhost.localdomain>
References: <alpine.LFD.2.00.0905271657340.3397@localhost.localdomain> <20090528141648.GA6018@nowhere> <alpine.LFD.2.00.0905281646380.3397@localhost.localdomain> <alpine.DEB.2.00.0905281057490.905@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Steven Rostedt wrote:
> > IIRC the same happens with a serial console, but that can be worse as
> > you busy wait during the character output.
> > 
> > It'd be nice if we could inherit the notrace from the caller :)
> > 
> 
> I'd hate to make rcu_read_*lock be a notrace. I've done some debugging 
> with wanting to know where the rcu locks were taken.

Sure.
 
> I'm sure there's lots of functions that people will want to add notrace 
> for. Really, the notrace on a function should only be there to prevent 
> crashes (functions used by the tracer or early boot up code for some 
> archs).

Well, lets look at the atomic notifier then. Why is it notrace ? And
if there is a reason why does it trace the calls which are done inside
of it. We should really think about inheriting the notrace down the
call chain at least for those calls which must be annotated to avoid
wreckage. That could then be made optional (via commandline) for all
notrace calls.

> That said, there are times when you want to avoid tracing things on early 
> boot up. Thus, if someone adds to the kernel command line 
> "ftrace=function" you have no way to filter out these functions you don't 
> care about.
> 
> What if I add a "ftrace_notrace=<function list>" kernel command line, that 
> has <function list> be a comma separated list of functions you want to go 
> into the "set_ftrace_notrace" on boot up? Would that satisfy you. Then you 
> can keep adding to the list dynamically every boot. And keep it there in a 
> grub file.

That list might grow fast beyond the command line lenght limit :)

But yeah, I can see your point. At least it would be better than
cursing and adding ad hoc notrace patches all over the place.

Thanks,

	tglx
