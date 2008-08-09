Return-Path: <linux-kernel-owner+w=401wt.eu-S1762406AbYHIBy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762406AbYHIBy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYHIByt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:54:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46378 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbYHIBys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:54:48 -0400
Date: Sat, 9 Aug 2008 03:55:39 +0200
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
Message-ID: <20080809015539.GG9038@one.firstfloor.org>
References: <20080808174607.GG8244@Krystal> <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com> <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> <87tzdv2g05.fsf@basil.nowhere.org> <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <20080809011955.GE9038@one.firstfloor.org> <alpine.DEB.1.10.0808082126500.3707@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808082126500.3707@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Funny, CONFIG_FTRACE happens to select that. Now the question is, would 
> mcount work without it?

Not without fixing gcc first. It would work if gcc always called
mcount the first thing before setting up the stack frame. Not 
sure why it doesn't do that.

Still do a benchmark of frame pointer vs no frame pointer kernel
and you'll see, especially on a older CPUs without special hardware
to avoid stack stalls (e.g. not Core2)

BTW always forcing frame pointers also means that ftrace is far
from near zero overhead even when disabled. That is unless you
find a way to nop the frame pointers too, but that would be likely
very difficult because the code will actually use it.

-Andi
