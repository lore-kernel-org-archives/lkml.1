Return-Path: <linux-kernel-owner+w=401wt.eu-S1762692AbYHICWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762692AbYHICWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 22:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYHICWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 22:22:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59487 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYHICWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 22:22:12 -0400
Date: Sat, 9 Aug 2008 04:23:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
Message-ID: <20080809022302.GH9038@one.firstfloor.org>
References: <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com> <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> <87tzdv2g05.fsf@basil.nowhere.org> <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <20080809011955.GE9038@one.firstfloor.org> <alpine.DEB.1.10.0808082126500.3707@gandalf.stny.rr.com> <20080809015539.GG9038@one.firstfloor.org> <alpine.DEB.1.10.0808082202030.4894@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808082202030.4894@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 10:03:42PM -0400, Steven Rostedt wrote:
> 
> On Sat, 9 Aug 2008, Andi Kleen wrote:
> 
> > > Funny, CONFIG_FTRACE happens to select that. Now the question is, would 
> > > mcount work without it?
> > 
> > Not without fixing gcc first. It would work if gcc always called
> > mcount the first thing before setting up the stack frame. Not 
> > sure why it doesn't do that.
> 
> I could take out the frame pointer option and pass in zero for the parent 
> in such that case. But the parent is quite useful. But if it helps
> with performance, it may be worth doing this.

Right now gcc errors out unfortunately. Would need to ask gcc developers
to fix this first. But when they move mcount to be always first
you can still get at the parent, it will always be at 4(%esp) or 8(%rsp).

An alternative would be also run an assembler post processor that
inserts mcount calls without compiler help.

-Andi
