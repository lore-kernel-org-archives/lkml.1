Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbZLJQRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbZLJQRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbZLJQRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:17:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39376 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbZLJQRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:17:43 -0500
Date: Thu, 10 Dec 2009 17:16:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
Message-ID: <20091210161605.GC27794@elte.hu>
References: <4B202778.4030801@am.sony.com>
 <20091210070800.GB16874@elte.hu>
 <20091210120332.GA5042@nowhere>
 <1260455367.2146.143.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260455367.2146.143.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2009-12-10 at 13:03 +0100, Frederic Weisbecker wrote:
> 
> > This makes me feel I'm going to try converting the function graph 
> > tracer into an event during the next cycle. It does not mean I could 
> > make it usable as a perf event right away in the same shot that 
> > said, as you can guess this is not a trivial plug. The current perf 
> > fast path is not yet adapted for that.
> 
> I curious how you plan on doing this. The current event system shows 
> one event per trace point. A straight forward approach would make 
> every entry and exit of a function a trace point and that would lead 
> to a very large kernel to handle that.
> 
> Perhaps we could abstract out all entries and exits. We need to be 
> able to link to a single point (entry or exit) not all.  This also has 
> the added issue of using the ftrace infrastructure of nop the mcount 
> call. We also need a way to enable a set of functions.

I think a good solution would be what i suggested (and what the patch i 
sent does in essence), i.e. to add a special software event for 
functions:

  PERF_COUNT_SW_FUNCTION_CALLS

Next step would be to extend the ioctl interface to allow per function 
tracepoints to be turned on/off (and set other per function attributes). 
The attributes would be system-wide (at least initially) - we dont want 
to live patch functions at context switch time.

We'd basically keep the function tracer, just re-wire it somewhat and 
expose it via the unified interface and make it available to a much 
larger set of usecases.

	Ingo
