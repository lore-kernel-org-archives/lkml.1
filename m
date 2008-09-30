Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYI3HuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYI3HuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbYI3Hpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:45:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47283 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbYI3Hp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:45:29 -0400
Date: Tue, 30 Sep 2008 09:45:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH 0/6] ftrace: port to the new ring_buffer
Message-ID: <20080930074514.GB2838@elte.hu>
References: <20080930030236.230994826@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930030236.230994826@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> These patches are against linux-tip.
> 
> The first is just a fix in the wakeup selftest.
> 
> The next is a port of the Unified tracer buffer to linux-tip and some 
> updates.
> 
> After that is the ftrace port to use the ring buffer, followed by some 
> more enhancements to ftrace because of the new variable length buffer.
> 
> I tried a few configurations and tried to test all the different 
> ftrace tracers, but I'm sure there may be some bugs still to work out. 
> I worked out all those that I found.

very nice! I'd expect breakages and complications too so i restructured 
tip/tracing/* a bit: firstly i created a tip/tracing/core append-only 
merge branch which collects all the known-robust bits. Then i created a 
new branch for your new generic ring-buffer feature: 
tip/tracing/ring-buffer, and applied your patches. I've started testing 
it.

Once we declare it OK, it can be merged into tip/tracing/core.

> But, with the ring_buffer I can envision several ways to clean up 
> ftrace and to make adding new tracers cleaner.
> 
> I'm also thinking about making a way that each tracer can allocate its 
> own buffer, and allow for more than one tracer to be running at the 
> same time! (only with different buffers).

yeah. Ideally this should just fall out of the generic framework - i.e. 
tracer plugins should not have to do anything extra to get per tracer 
buffers. They should just add their own specialistic flavor, there 
should be no repetitions otherwise. (barring cases where a tracer wants 
to deviate from default behavior)

	Ingo
