Return-Path: <linux-kernel-owner+w=401wt.eu-S1763613AbXFATdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763613AbXFATdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762430AbXFATda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:33:30 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:50270 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762312AbXFATd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:33:29 -0400
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070601183053.GA30072@elte.hu>
References: <20070530132431.GA23947@elte.hu>
	 <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com>
	 <20070530134907.GA27085@elte.hu>
	 <1180544796.32594.184.camel@imap.mvista.com>
	 <1180545380.2958.1.camel@lappy>
	 <1180545913.32594.194.camel@imap.mvista.com>
	 <20070601131249.GA17059@elte.hu>
	 <1180711606.15884.32.camel@imap.mvista.com> <1180713154.5676.4.camel@lappy>
	 <1180714263.15884.52.camel@imap.mvista.com>
	 <20070601183053.GA30072@elte.hu>
Content-Type: text/plain
Date: Fri, 01 Jun 2007 12:30:37 -0700
Message-Id: <1180726237.15884.103.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-01 at 20:30 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > > So, having two interfaces, one fast and one accurate is the right 
> > > answer IMHO.
> > 
> > In the case of lockstat you have two cases fast and functional, and 
> > non-functional .. Right now your patch has no slow and functional 
> > state.
> 
> let me explain it to you:
> 
> 1) there is absolutely no problem here to begin with. If a rare 
> architecture is lazy enough to not bother implementing a finegrained 
> sched_clock() then it certainly does not care about the granularity of 
> lockstat fields either. If it does, it can improve scheduling and get 
> more finegrained lockstat by implementing a proper sched_clock() 
> function - all for the same price! ;-)

There is a problem, which we are discussing ... sched_clock() can be
lowres in lots of different situations, and lockstat fails to account
for that .. That in turn makes it's timing non-functional.

> 2) the 'solution' you suggested for this non-problem is _far worse_ than 
> the granularity non-problem, on the _majority_ of server systems today! 
> Think about it! Your suggestion would make lockstat _totally unusable_. 
> Not "slow and functional" like you claim but "dead-slow and unusable".

I'm not sure how to respond to this.. You taking a big ball of
assumptions, and molding it into what ever you want ..

> in light of all this it is puzzling to me how you can still call Peter's 
> code "non-functional" with a straight face. I have just tried lockstat 
> with jiffies granular sched_clock() and it was still fully functional. 
> So if you want to report some bug then please do it in a proper form.

Clearly you can't have sane microsecond level timestamps with a clock
that doesn't support microsecond resolution.. This is even something
Peter acknowledged in his first email to me.

> > As I said before there is no reason why and architectures should be 
> > forced to implement sched_clock() .. Is there some specific reason why 
> > you think it should be mandatory?
> 
> Easy: it's not mandatory, but it's certainly "nice" even today, even 
> without lockstat. It will get you:
> 
>  - better scheduling
>  - better printk timestamps
>  - higher-quality blktrace timestamps
> 
> With lockstat, append "more finegrained lockstat output" to that list of 
> benefits too. That's why every sane server architecture has a 
> sched_clock() implementation - go check the kernel source. Now i wouldnt 
> mind to clean the API up and call it get_stat_clock() or whatever - but 
> that was not your suggestion at all - your suggestion was flawed: to 
> implement sched_clock() via the GTOD clocksource.

At this point it's not clear to me you know what my suggestion was ..
Your saying you want a better API for sched_clock(), and yes I agree
with that 100% sched_clock() needs a better API .. The paragraph above
it looks like your on the verge of agreeing with me ..

You think my words are puzzling, try it from this end.. 

Daniel

