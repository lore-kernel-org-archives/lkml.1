Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbYJVL3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbYJVL3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJVL26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:28:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYJVL25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:28:57 -0400
Date: Wed, 22 Oct 2008 07:28:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace: make dynamic ftrace more robust
In-Reply-To: <alpine.DEB.1.10.0810220658380.21358@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0810220721090.30656@gandalf.stny.rr.com>
References: <20081021164018.889518687@goodmis.org> <20081021164302.399002797@goodmis.org> <20081022065346.GD17485@elte.hu> <alpine.DEB.1.10.0810220658380.21358@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Oct 2008, Steven Rostedt wrote:
> > 
> > > +					/* kprobes was not the fault */
> > > +					ftrace_kill_atomic();
> > 
> > while at it, ftrace_kill_atomic() is a misnomer.
> > 
> > Please use something more understandable and less ambigious, like 
> > "ftrace_turn_off()". Both 'kill' and 'atomic' are heavily laden phrases 
> > used for many other things in the kernel.

I agree with your "atomic" part but the 'kill' I do not. Yes, it is 
unfortunate that Unix used 'kill' to send signals. But the Unix name is 
the misnomer.  The problem with a "ftrace_turn_off" or anything similar, 
is that people will likely use it to temporarily disable ftrace when they 
need to do some sensitive code that they can not allow tracing on.
Then they will be confused when they can not find a "ftrace_turn_on()".

We already use "disable" to shut down ftrace and put it back into the 
"NOP" state. We have "stop" and "start" to stop function tracing quickly 
(just a bit is set, no conversion of code).

I figured "kill" is self explanatory. You use it when you want to kill 
ftrace and do not want it to come back. We have no "ftrace_resurrect" 
(well, not yet ;-)

I think most developers know the "kill" meaning. If you do not like the 
name, you can change it.

-- Steve
