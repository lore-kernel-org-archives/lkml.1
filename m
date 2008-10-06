Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbYJFROB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbYJFROB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYJFRNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:13:53 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:36668 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbYJFRNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:13:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsEAJPi6UhMQWq+/2dsb2JhbACBcbppgWo
Date: Mon, 6 Oct 2008 13:13:48 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/3] ring-buffer: less locking and only disable
	preemption
Message-ID: <20081006171348.GB9345@Krystal>
References: <20081004060057.660306328@goodmis.org> <20081004084002.GE27624@elte.hu> <alpine.DEB.1.10.0810041015330.4551@gandalf.stny.rr.com> <20081004163348.GA23593@Krystal> <alpine.DEB.1.10.0810041315440.6571@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810041315440.6571@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:10:46 up 123 days, 21:51,  9 users,  load average: 0.09, 0.30,
	0.38
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Sat, 4 Oct 2008, Mathieu Desnoyers wrote:
> > 
> > Or use this code, based on a temporary breakpoint, to do the code
> > patching (part of the -lttng tree). It does not require stop_machine at
> > all and is nmi safe.
> > 
> 
> When this is supported for all archs, and can be done at all functions 
> then I could use it.
> 

How about incrementally using this piece of infrastructure when
available on a given architecture ? This way we keep a sub-optimal
fall-back for archs which does not support NMI-safe code patching and
incrementally get the optimal behavior. Otherwise, we would require any
new architecture to implement that up-front, which I doubt is a good
idea.

> I may just have the arch specific code use it, but we'll see.
> 
> Also, how good is it at patching 20,000 call sites?
> 

Can be done really fast using a hash table, see my previous mail.

Mathieu

> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
