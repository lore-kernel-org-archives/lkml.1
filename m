Return-Path: <linux-kernel-owner+w=401wt.eu-S1763416AbZCYR5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763416AbZCYR5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZCYR5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:57:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56899 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZCYR5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:57:44 -0400
Date: Wed, 25 Mar 2009 13:57:41 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5][RFC] tracing: move function profiler data out of
 function struct
In-Reply-To: <20090325174446.GE14250@elte.hu>
Message-ID: <alpine.DEB.2.00.0903251354020.5675@gandalf.stny.rr.com>
References: <20090325035646.662994901@goodmis.org> <20090325040832.443420395@goodmis.org> <20090325100746.GI2341@elte.hu> <alpine.DEB.2.00.0903251142470.5675@gandalf.stny.rr.com> <20090325174446.GE14250@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Ingo Molnar wrote:

> > The atomic_inc_return protects against NMIs, since this is the only place 
> > the lock is taken.
> 
> i mean, if this code executes _ni_ an NMI. Or that cannot happen? We 
> trace nmis too, dont we?

Yes, it can execute in an NMI, but we have no issues there. If the lock 
was taken the atomic inc is set. If an NMI comes in, it will fail the
atomic inc counter test and never try to take the lock. 

But as stated below, this is just beating the dead horse, because we can 
bend the lock. But it is impossible to bend the lock. What we must realize 
is... "There is no lock". ;-)

-- Steve


> 
> > > This all would be solved much more robustly by the function 
> > > attributes hash approach i suggested in the previous mail. If 
> > > percpu_alloc() is done for 20,000 functions the memory 
> > > allocation overhead is no big deal.
> > 
> > Later patches create a per-cpu buffers and removes the lock.
> 
> ok :)
> 
> 	Ingo
> 
