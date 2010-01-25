Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182Ab0AYQyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0AYQyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 11:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151Ab0AYQyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 11:54:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754121Ab0AYQyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:54:16 -0500
Date: Mon, 25 Jan 2010 08:52:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kyle Moffett <kyle@moffetthome.net>
cc: tytso@mit.edu, "Frank Ch. Eigler" <fche@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
In-Reply-To: <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain>
References: <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>  <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>  <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
  <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>  <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>  <20100123112333.GA15455@elte.hu> <20100123114729.GA7828@redhat.com>  <20100123194820.GM21263@thunk.org>
 <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 24 Jan 2010, Kyle Moffett wrote:
> 
> The point that's being missed is that there is a chicken-and-egg
> problem here.  The "chicken" is a replacement or extension to the
> debugger interface that would make it possible for me to do things
> like GDB a process while it's being strace'd or vice versa.  The "egg"
> is the "utrace" bits, an unstable but somewhat arch-generic ABI that
> abstracts out ptrace() to make it possible to stack both in-kernel and
> userspace debuggers/tracers/etc and have multiple simultaneous users.

Quite frankly, as far as I'm concerned, I'd be a whole lot more interested 
in utrace if it's _only_ stated (and implied) goal was to do exactly this.

The thing I object to is the whole "dessert topping _and_ floor wax" 
thing, with kernel interfaces for random other users.

If somebody extended ptrace in good ways, that's a totally different 
thing. But I think utrace has been over-designed, possibly as a result of 
others coming in and saying "hey, I'd like to use that too for xyz".

"Do one thing, and do it well". I'd not mind somebody improving ptrace 
(including extending its semantics - I do agree that the whole SIGSTOP 
thing makes it hard to have multiple debuggers).

That said, I also suspect that people should still look seriously at 
simply just improving ptrace. For example, I suspect that the biggest 
problem with ptrace is really just the signalling, and that creating a new 
extension for JUST THAT, and then having a model where you can choose - at 
PTRACE_ATTACH time - how to wait for events would be a good thing.

But as long as it is "I want to solve all problems", I'm not very 
impressed. 

Maybe somebody would be interested in trying to take the utrace 
improvements, and scaling down what they promise, and ignoring all input 
except for "I want to strace and gdb at the same time".

So stop the crazy "new kernel interfaces" crap. Stop the crazy "maybe we 
can use it for ftrace and generic user event tracing too". Stop the crazy.

			Linus
