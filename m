Return-Path: <linux-kernel-owner+w=401wt.eu-S1751470AbZAZPBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbZAZPBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZAZPBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:01:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60881 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbZAZPBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:01:30 -0500
Date: Mon, 26 Jan 2009 16:00:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>, Avi Kivity <avi@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Message-ID: <20090126150002.GB9128@elte.hu>
References: <1232455343.4895.4.camel@kulgan.wumi.org.au> <20090120125652.GA1457@elte.hu> <20090120130714.GA11048@elte.hu> <alpine.DEB.1.10.0901200957220.2681@gandalf.stny.rr.com> <49760E2D.2060109@redhat.com> <1232547932.4895.119.camel@kulgan.wumi.org.au> <49773275.3020203@redhat.com> <20090121151820.GA23813@elte.hu> <1232963730.4921.12.camel@kulgan.wumi.org.au> <1232969705.4863.46.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232969705.4863.46.camel@laptop>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Is there a way to add a wall-time column to this output so that we can 
> see where the time goes?

yes, on tip/master:

  http://people.redhat.com/mingo/tip.git/README

do something like this:

 echo funcgraph-abstime > /debug/tracing/trace_options

when the function-graph plugin is active. This will activate the absolute 
timestamps column in the trace output.

> Another something nice would be to have ctx switches like:
> 
> foo-1 => bar-2 ran: ${time foo spend on the cpu} since: ${time bar spend away from the cpu}
> 
> I'll poke me a little at this function graph tracer thingy to see if I 
> can do that.

indeed, tracking the 'scheduling atom duration' would be very nice.

	Ingo
