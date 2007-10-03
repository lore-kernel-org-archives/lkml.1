Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbXJCIQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbXJCIQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbXJCIQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:16:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60945 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbXJCIQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:16:20 -0400
Date: Wed, 3 Oct 2007 10:16:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20071003081613.GA29904@elte.hu>
References: <20071002060607.GA18588@elte.hu> <20071003080224.GB1726@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003080224.GB1726@ff.dom.local>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0092]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jarek Poplawski <jarkao2@o2.pl> wrote:

> > firstly, there's no notion of "timeslices" in CFS. (in CFS tasks 
> > "earn" a right to the CPU, and that "right" is not sliced in the 
> > traditional sense) But we tried a conceptually similar thing [...]
> 
> >From kernel/sched_fair.c:
> 
> "/*
>  * Targeted preemption latency for CPU-bound tasks:
>  * (default: 20ms, units: nanoseconds)
>  *
>  * NOTE: this latency value is not the same as the concept of
>  * 'timeslice length' - timeslices in CFS are of variable length.
>  * (to see the precise effective timeslice length of your workload,
>  *  run vmstat and monitor the context-switches field)
> ..."
> 
> So, no notion of something, which are(!) of variable length, and which 
> precise effective timeslice lenght can be seen in nanoseconds? (But 
> not timeslice!)

You should really read and understand the code you are arguing about :-/

In the 2.6.22 scheduler, there was a p->time_slice per task variable 
that could be manipulated. (Note, in 2.6.22's sched_yield() did not 
manipulate p->time_slice.)

sysctl_sched_latency on the other hand is not something that is per task 
(it is global) so there is no pending timeslice to be "cleared" as it 
has been suggested naively.

	Ingo
