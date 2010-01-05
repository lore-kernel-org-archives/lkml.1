Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697Ab0AEGF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0AEGF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 01:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789Ab0AEGF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 01:05:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52388 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab0AEGF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 01:05:56 -0500
Date: Tue, 5 Jan 2010 07:05:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Jason Baron <jbaron@redhat.com>,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] dynamic debug - adding ring buffer storage support
Message-ID: <20100105060537.GA17310@elte.hu>
References: <1261481526-17630-1-git-send-email-jolsa@redhat.com>
 <20091222153955.GD3308@redhat.com>
 <20091222161353.GB20225@jolsa.lab.eng.brq.redhat.com>
 <20091228092402.GD24690@elte.hu>
 <20091230225011.GJ6322@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230225011.GJ6322@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.2
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.2 required=5.9 tests=BAYES_00,FH_DATE_PAST_20XX autolearn=no SpamAssassin version=3.2.5
	3.2 FH_DATE_PAST_20XX      The date is grossly in the future.
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Dec 28, 2009 at 10:24:02AM +0100, Ingo Molnar wrote:
> > > that way you need to enable tracing as well... but thats ok I guess :)
> > > 
> > > I was investigating trace events for this, but did not find a way
> > > to put variable length argument inside... and I overlooked the
> > > trace_printk, I'll look on it and see how it fits, thanks
> > > 
> > > also having separate ring buffer makes the 'trace'/'trace_pipe' code
> > > really simple (suprissingly) compared to ftrace, and I thought
> > > on this place it could last for some time.. ;)
> > 
> > I think what we want is a unified channel of events, of which printk (and 
> > dynamic-printk) is one form. I.e. we should add printk events and 
> > dynamic-printk events as well, which would show up in /debug/tracing/events/ 
> > in a standard ftrace event form and would be accessible to tooling that way.
> > 
> > For printk a single event would be enough i suspect (we dont want a separate 
> > event for every printk), and for dynamic-printk we want to map the existing 
> > dyn-printk topologies into /debug/tracing/events, to preserve the distinctions 
> > and controls available there.
> > 
> > This way in the long run we'd have one unified facility.
> > 
> > 	Ingo
> 
> 
> That said, I sometimes dream about one event per printk.

Yeah - but it's only really useful if we could properly encode/extract the 
record format as well.

The one person's printk would become another person's programmable tracepoint.

> Too bad that would bloat the memory.

Should be optional of course, and then developers/distros pick instrumentation 
landscape winners/losers. To most people memory overhead is not a big issue, 
if the result is sufficiently useful.

	Ingo
