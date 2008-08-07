Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYHGW1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYHGW1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757357AbYHGW0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:26:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757183AbYHGW0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:26:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
X-Fcc: ~/Mail/linus
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
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
In-Reply-To: Steven Rostedt's message of  Thursday, 7 August 2008 17:29:41 -0400 <alpine.DEB.1.10.0808071721200.10092@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org>
	<489B6511.7000208@goop.org>
	<alpine.DEB.1.10.0808071721200.10092@gandalf.stny.rr.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080807222642.761AF15429D@magilla.localdomain>
Date: Thu,  7 Aug 2008 15:26:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This doesn't seem any less complex than what I did. With this, I would 
> have to come up with another way to handle modules. This will make
> things a lot more complex.

The scheme you've implemented can apply fine to a .ko file after it's made.
They are just .o's really.  It is presumably faster to do one step per
final .ko rather than many tiny ones (per source file).  

That might be a benefit to doing it all at the end for vmlinux too.  I
think the best way would be to have a vmlinux.o that we actually use in the
link, rather than just analyzing and discarding.  Then you can just do your
existing hack on vmlinux.o before it's linked into vmlinux.


Thanks,
Roland
