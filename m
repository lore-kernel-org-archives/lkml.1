Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbYHHB4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbYHHB4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYHHB4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:56:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYHHB4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:56:34 -0400
Date: Thu, 7 Aug 2008 21:56:32 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Roland McGrath <roland@redhat.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: <alpine.DEB.1.10.0808072113290.18565@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0808072154040.18565@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org> <489B6511.7000208@goop.org> <alpine.DEB.1.10.0808071721200.10092@gandalf.stny.rr.com> <20080807222642.761AF15429D@magilla.localdomain> <alpine.DEB.1.10.0808072113290.18565@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Aug 2008, Steven Rostedt wrote:

> 
> On Thu, 7 Aug 2008, Roland McGrath wrote:
> 
> > > This doesn't seem any less complex than what I did. With this, I would 
> > > have to come up with another way to handle modules. This will make
> > > things a lot more complex.
> > 
> > The scheme you've implemented can apply fine to a .ko file after it's made.
> > They are just .o's really.  It is presumably faster to do one step per
> > final .ko rather than many tiny ones (per source file).  
> > 
> > That might be a benefit to doing it all at the end for vmlinux too.  I
> > think the best way would be to have a vmlinux.o that we actually use in the
> > link, rather than just analyzing and discarding.  Then you can just do your
> > existing hack on vmlinux.o before it's linked into vmlinux.
> 
> OK, I am playing with this. And you are right, it does work with vmlinux.o 
> file.  It adds almost another minute to the build anytime something is 
> changed. Where the per-object way may take longer doing a full build, but 
> does not add that extra minute ever build.

I spoke to soon. I was only looking at the result of the vmlinux.o. But it 
seems that kallsyms skips using this file and relinks everything itself.
Thus the __mcount_loc I added never made it into the vmlinux. The more I 
try to get this method to work, the more complex it becomes. And I still 
did not change the recordmcount.pl at all. Which means, by trying to do it 
against the vmlinux.o, I'm actually making it more complex than it already 
is.

Right now, doing it to every object seems to be the safest approach.

-- Steve


