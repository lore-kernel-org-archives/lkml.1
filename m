Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbYHICDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbYHICDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 22:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYHICDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 22:03:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53019 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbYHICDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 22:03:45 -0400
Date: Fri, 8 Aug 2008 22:03:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
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
In-Reply-To: <20080809015539.GG9038@one.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0808082202030.4894@gandalf.stny.rr.com>
References: <20080808174607.GG8244@Krystal> <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com> <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com>
 <87tzdv2g05.fsf@basil.nowhere.org> <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <20080809011955.GE9038@one.firstfloor.org> <alpine.DEB.1.10.0808082126500.3707@gandalf.stny.rr.com> <20080809015539.GG9038@one.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 9 Aug 2008, Andi Kleen wrote:

> > Funny, CONFIG_FTRACE happens to select that. Now the question is, would 
> > mcount work without it?
> 
> Not without fixing gcc first. It would work if gcc always called
> mcount the first thing before setting up the stack frame. Not 
> sure why it doesn't do that.

I could take out the frame pointer option and pass in zero for the parent 
in such that case. But the parent is quite useful. But if it helps
with performance, it may be worth doing this.

-- Steve

> 
> Still do a benchmark of frame pointer vs no frame pointer kernel
> and you'll see, especially on a older CPUs without special hardware
> to avoid stack stalls (e.g. not Core2)

I'll see what it does with just a kernel build.

-- Steve
