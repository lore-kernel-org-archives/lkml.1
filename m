Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbYIYXZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbYIYXZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 19:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYIYXZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 19:25:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57898 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbYIYXZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 19:25:42 -0400
Date: Fri, 26 Sep 2008 01:25:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Martin Bligh <mbligh@mbligh.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080925232512.GA12141@elte.hu>
References: <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <48DBFC7D.4050208@goop.org> <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org> <20080925222548.GA28309@elte.hu> <alpine.DEB.1.10.0809251840430.32742@gandalf.stny.rr.com> <48DC18E9.7000007@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DC18E9.7000007@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Steven Rostedt wrote:
> > On Fri, 26 Sep 2008, Ingo Molnar wrote:
> >   
> >> Firstly they need a low-frequency (10khz-100khz) shared clock line 
> >> across all CPUs. A single line - and since it's low frequency it could 
> >> be overlaid on some existing data line and filtered out. That works 
> >> across NUMA nodes as well and physics allows it to be nanosec accurate 
> >> up to dozens of meters or so.
> >>     
> >
> > Can this possibly be true? I mean, light travels only one foot every
> > nanosecond. Can it really keep nanosecond accuracy up to dozens of  meters 
> > away? 
> 
> Sure.  NTP keeps machines within 1ms (or better) of each other even 
> though the network latency is much higher and jittery.

yes. And there are radio telescope arrays that are synced up to do delta 
interferometry, over thousands of kilometers. Syncing up time over a few 
dozen meters is no challenge - and the reason for that ease is that 
physical time is neatly and uniformly broadcasted by nature in a pretty 
dependable way, at around 300 thousand kilometers per second.

the challenge is to make it cheap enough for commodity hw. I.e. no extra 
CPU pins or lines in critical parts of the board, no extra power, low 
transistor count, no impact on any critical path, short and reliable 
clock readout after powerup, etc. But that is quite possible too IMO, 
and the payback is very real.

[ OTOH, this is a world that still ships FreeDOS on many whitebox PC
  instead of putting Linux on it, so dont expect logic to prevail
  in all cases ;-) ]

	Ingo
