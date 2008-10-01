Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbYJARrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbYJARrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 13:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYJARro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 13:47:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36851 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbYJARrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 13:47:43 -0400
Date: Wed, 1 Oct 2008 19:47:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] ftrace: type cast verifier
Message-ID: <20081001174719.GA21089@elte.hu>
References: <20080930030236.230994826@goodmis.org> <20080930030652.883661046@goodmis.org> <20080930203342.5b5ca814@daedalus.pq.iki.fi> <alpine.DEB.1.10.0809301341300.6224@gandalf.stny.rr.com> <20081001075419.GA24509@elte.hu> <alpine.DEB.1.10.0810011052130.30777@gandalf.stny.rr.com> <20081001174236.GA19954@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001174236.GA19954@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> could you rename it to trace_type() - that way the initialization could 
> be written in a more compact way as:
> 
> > +	struct trace_mmiotrace_map *field = trace_type(field, entry);

ah, it cannot be done that way, as 'field' has to be known to the 
compiler.

so your patch is fine as-is, the extra line is an acceptable cost, as we 
get:

- the type filter (trying to cast an object outside of the narrow list 
  of trace entry types will cause a failed build - i.e. most of the 
  practical dangers of C type casting are avoided!)

- the runtime entry type checker

	Ingo
