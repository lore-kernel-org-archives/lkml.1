Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbXFAN3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbXFAN3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 09:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757138AbXFAN3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 09:29:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:39132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066AbXFAN3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 09:29:38 -0400
To: Daniel Walker <dwalker@mvista.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
References: <20070529125248.877196281@chello.nl>
	<20070529130107.112347096@chello.nl>
	<1180470525.32594.71.camel@imap.mvista.com>
	<20070530132431.GA23947@elte.hu>
	<Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com>
	<20070530134907.GA27085@elte.hu>
	<1180544796.32594.184.camel@imap.mvista.com>
	<1180545380.2958.1.camel@lappy>
	<1180545913.32594.194.camel@imap.mvista.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Jun 2007 16:25:47 +0200
In-Reply-To: <1180545913.32594.194.camel@imap.mvista.com>
Message-ID: <p73sl9bbvkk.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker <dwalker@mvista.com> writes:

> On Wed, 2007-05-30 at 19:16 +0200, Peter Zijlstra wrote:
> 
> > > >From the architecture perspective there are two low level clock hooks to
> > > implement one is sched_clock() , and at least one clocksource structure.
> > > Both do essentially the same thing. With timekeepings clocksource
> > > structure actually being easier to implement cause the math is built in.
> > 
> > I think you are mistaken here; the two are similar but not identical.
> > 
> > I see sched_clock() as fast first, accurate second. Whereas the
> > clocksource thing is accurate first, fast second.
> 
> This is true .. However, if there is a speed different it's small.

pmtimer (factor 1000+) or HPET (factor 10-100+ depending on CPU) 
accesses are much slower than TSC or jiffies read. Talking to the
southbridge is slow.

-Andi
