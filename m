Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYI0RRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYI0RRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYI0RRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:17:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYI0RRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:17:47 -0400
Date: Sat, 27 Sep 2008 19:16:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080927171640.GA1990@elte.hu>
References: <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org> <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu> <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org> <20080925211017.GA12689@elte.hu> <20080925214134.GA23025@elte.hu> <alpine.LFD.1.10.0809251458020.3265@nehalem.linux-foundation.org> <20080925221441.GA29060@elte.hu> <alpine.LFD.1.10.0809251631460.3265@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809251631460.3265@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 26 Sep 2008, Ingo Molnar wrote:
> > 
> > i do not understand this argument of yours. (really)
> > 
> > 1) is your point that we might lock up?
> 
> Have you at all followed the discussion about the people who asked for 
> cross-CPU ordering? They wanted not timestamps at all, but global 
> atomic counter updates. Which is very reasonable, if timestamps don't 
> work (and jiffies certainly doesn't, especially in a NOHZ 
> environment).
> 
> IOW, my whole argument is that what tracers want is _not_ the same 
> thing as what "sched_clock()" wants.

ah, i see what you mean. I think that's an orthogonal property.

Well, it's important in some cases, not that important in other cases.

Historically we've been flip-flopping on that issue in ftrace, whether 
it should be coherent by default or not. We had at least three of four 
variations of global synchronization. (one was an atomic generation 
counter, another variant a global lock)

Eventually people noticed the overhead and asked for it to be faster.

If all you do is to trace high-freq events on all CPUs and you are _not_ 
interested in the precise interactions, the overhead of global 
synchronization can hurt a lot.

In any case, SMP coherency of trace events is an independent property of 
the tracer, and preferably something that can be turned on/off.

	Ingo
