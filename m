Return-Path: <linux-kernel-owner+w=401wt.eu-S1759005AbZANKIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005AbZANKIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZANKIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:08:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbZANKIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:08:21 -0500
Date: Wed, 14 Jan 2009 11:08:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] perf_counter: Add support for pinned and exclusive
	counter groups
Message-ID: <20090114100814.GA23835@elte.hu>
References: <18797.44875.470975.535175@cargo.ozlabs.ibm.com> <20090114095743.GA1389@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114095743.GA1389@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Yeah. Such artifacts at inheritance stem from the reduction in utility 
> that comes from any exclusive-resource-usage scheme, and are expected.
> 
> For example, right now it works just fine to nest 'timec' in itself 
> [there is a reduction in statistical value if we start round-robining, 
> but there's still full utility]. If it used exclusive or pinned counters 
> that might not work.

for example, this measurement works just fine currently:

aldebaran:~/linux/linux> timec -e 1 timec -e 1 timec -e 1 make -j16 kernel/
 [...]
 Performance counter stats for 'make':

   59561.510176  task clock ticks     (msecs)

    92223201071  instructions         (events)

 Wall-clock time elapsed:  6016.011818 msecs


 Performance counter stats for 'timec':

   59562.300425  task clock ticks     (msecs)

    92223534177  instructions         (events)

 Wall-clock time elapsed:  6017.117985 msecs


 Performance counter stats for 'timec':

   59563.307588  task clock ticks     (msecs)

    92223867295  instructions         (events)

 Wall-clock time elapsed:  6018.590227 msecs

The performance counters are layered upon each other in each nested timec 
instance. In the innermost instance ls runs with 3+3 performance counters 
active at once - and it all just works, without the timec apps having any 
knowledge about each other.

And that is i think what powerful kernel abstractions are about. If we 
provide nice and useful abstractions then the hw folks will eventually 
extend the hw side resources, if users keep bumping into them.

If we structure our design around the limitations then users wont actually 
ever bump into the hw limitations in a clear-cut way - they will bump into 
our design. So they'll pester us, not the hw folks ;-)

Such details are the main difference between the perfmon design and the 
perfcounters design.

	Ingo
