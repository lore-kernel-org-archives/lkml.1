Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbZA2SMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbZA2SMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZA2SLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:11:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56582 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbZA2SLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:11:53 -0500
Date: Thu, 29 Jan 2009 13:11:52 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, jens.axboe@oracle.com
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
In-Reply-To: <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0901291311160.27527@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>  <200901290955.38940.rusty@rustcorp.com.au>  <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com>  <20090128173039.cbc29e81.akpm@linux-foundation.org> <1233218954.7835.11.camel@twins>
 <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com> <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain> <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com> <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 29 Jan 2009, Linus Torvalds wrote:

> 
> 
> On Thu, 29 Jan 2009, Steven Rostedt wrote:
> > 
> > Actually, we are locking against the destination CPU.
> 
> Oh.
> 
> THAT'S JUST INCOMPETENT.

Or lack of sleep ;-)

> 
> What the *fuck* is the point of having per-CPU data, and then using it for 
> the wrong CPU?
> 
> Stop doing that idiocy. Put the per-cpu data on the senders side, and stop 
> the idiocy. You are going to get cross-CPU cacheline bouncing anyway, 
> there's no way to avoid it, but as long as you do it on the wrong CPU's 
> local data, you're missing the whole POINT of having per-cpu data in the 
> first place.
> 
> But yeah, that explains the locking. One stupid design mistake leads to 
> another.
> 
> And are you really sure it cannot be called from within interrupts? I'm 
> finding a lot of callers of smp_call_function_single(), and while I 
> couldn't find any that look like interrupts, I also couldn't find any 
> indication that it never happens.

No, the solution that Peter gave on top of mine looks like something we 
can all be happy with.

-- Steve

