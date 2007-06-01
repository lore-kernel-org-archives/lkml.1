Return-Path: <linux-kernel-owner+w=401wt.eu-S1763787AbXFATd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763787AbXFATd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762763AbXFATdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:33:33 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:50292 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762706AbXFATdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:33:32 -0400
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1180723421.5676.8.camel@lappy>
References: <20070529125248.877196281@chello.nl>
	 <20070529130107.112347096@chello.nl>
	 <1180470525.32594.71.camel@imap.mvista.com>
	 <20070530132431.GA23947@elte.hu>
	 <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com>
	 <20070530134907.GA27085@elte.hu>
	 <1180544796.32594.184.camel@imap.mvista.com>
	 <1180545380.2958.1.camel@lappy>
	 <1180545913.32594.194.camel@imap.mvista.com>
	 <20070601131249.GA17059@elte.hu>
	 <1180711606.15884.32.camel@imap.mvista.com> <1180713154.5676.4.camel@lappy>
	 <1180714263.15884.52.camel@imap.mvista.com> <1180723421.5676.8.camel@lappy>
Content-Type: text/plain
Date: Fri, 01 Jun 2007 12:30:37 -0700
Message-Id: <1180726238.15884.104.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-01 at 20:43 +0200, Peter Zijlstra wrote:
> On Fri, 2007-06-01 at 09:11 -0700, Daniel Walker wrote:
> > On Fri, 2007-06-01 at 17:52 +0200, Peter Zijlstra wrote:
> 
> > > The whole issue is that you don't have any control over what clocksource
> > > you'll end up with. If it so happens that pmtimer gets selected your
> > > whole box will crawl if its used liberaly, like the patch under
> > > discussion does.
> > 
> > You can have control over it, which I think the whole point of this
> > discussion ..
> 
> No you don't, clocksource will gladly discard the TSC when its not found
> stable enough (the majority of the systems today). While it would be
> good enough for sched_clock().

Your misreading the sentence above "You can have control over it" , this
means that you _can_ make lockstat use the TSC or disable itself when
the TSC is unstable.. Clock management is secondary to me, and we can
change it.. What matters more is if the "struct clocksource" provides a
better method for accessing lowlevel clocks than sched_clock() .. My
contention is that it does provide a better method.

Daniel

