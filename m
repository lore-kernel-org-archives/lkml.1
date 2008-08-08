Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYHHBVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYHHBVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYHHBVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:21:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55831 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYHHBVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:21:21 -0400
Date: Thu, 7 Aug 2008 21:21:18 -0400 (EDT)
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
In-Reply-To: <20080807222642.761AF15429D@magilla.localdomain>
Message-ID: <alpine.DEB.1.10.0808072113290.18565@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org> <489B6511.7000208@goop.org> <alpine.DEB.1.10.0808071721200.10092@gandalf.stny.rr.com> <20080807222642.761AF15429D@magilla.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 7 Aug 2008, Roland McGrath wrote:

> > This doesn't seem any less complex than what I did. With this, I would 
> > have to come up with another way to handle modules. This will make
> > things a lot more complex.
> 
> The scheme you've implemented can apply fine to a .ko file after it's made.
> They are just .o's really.  It is presumably faster to do one step per
> final .ko rather than many tiny ones (per source file).  
> 
> That might be a benefit to doing it all at the end for vmlinux too.  I
> think the best way would be to have a vmlinux.o that we actually use in the
> link, rather than just analyzing and discarding.  Then you can just do your
> existing hack on vmlinux.o before it's linked into vmlinux.

OK, I am playing with this. And you are right, it does work with vmlinux.o 
file.  It adds almost another minute to the build anytime something is 
changed. Where the per-object way may take longer doing a full build, but 
does not add that extra minute ever build.

Which would people prefer?  I little longer full build and do the 
modification on every object, or have a shorter full build, but every 
build will take that extra minute to do?

Note, if you have DYNMAIC_FTRACE disabled, this is a nop, and will _not_ 
affect you.

-- Steve

