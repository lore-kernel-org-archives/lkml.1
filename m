Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbYI0StY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbYI0StY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYI0StD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:49:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60299 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbYI0StB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:49:01 -0400
Date: Sat, 27 Sep 2008 20:42:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Martin Bligh <mbligh@mbligh.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080927184212.GB13685@elte.hu>
References: <20080925201211.GA1878@elte.hu> <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org> <20080925211017.GA12689@elte.hu> <20080925214134.GA23025@elte.hu> <alpine.LFD.1.10.0809251458020.3265@nehalem.linux-foundation.org> <20080925221441.GA29060@elte.hu> <alpine.LFD.1.10.0809251631460.3265@nehalem.linux-foundation.org> <20080927171640.GA1990@elte.hu> <alpine.DEB.1.10.0809271335001.10534@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809271335001.10534@gandalf.stny.rr.com>
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

> 
> On Sat, 27 Sep 2008, Ingo Molnar wrote:
> > 
> > If all you do is to trace high-freq events on all CPUs and you are _not_ 
> > interested in the precise interactions, the overhead of global 
> > synchronization can hurt a lot.
> > 
> > In any case, SMP coherency of trace events is an independent property of 
> > the tracer, and preferably something that can be turned on/off.
> 
> Just a note.  The current ring buffering system that I'm proposing 
> keeps its own time stamp counter (currently sched_clock) that will 
> most likely be updated later. I'm trying to keep this ring buffer 
> system as dumb as possible. It does not even implement the merge sort. 
> That's up to the tracer to handle. There's nothing stopping the trace 
> from adding some atomic counter to each event to help it sort.

correct. The price is all the notifier/callback overhead and the loss of 
type checking of the record contents. But that's an unavoidable price of 
abstraction, at least in C.

> So yes, the tracer can implement anything it wants on top of the ring 
> buffer ;-)

yes, very nice! :)

	Ingo
