Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZLWIiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZLWIiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbZLWIiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:38:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59524 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbZLWIiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:38:01 -0500
Date: Wed, 23 Dec 2009 09:37:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
Message-ID: <20091223083705.GA25240@elte.hu>
References: <4B2F7879.2080901@kernel.org>
 <1261405604.4314.154.camel@laptop>
 <4B3009DC.7020407@kernel.org>
 <1261480001.4937.21.camel@laptop>
 <4B319A20.9010305@kernel.org>
 <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain>
 <20091223060229.GA14805@elte.hu>
 <4B31C210.4010100@kernel.org>
 <20091223080144.GG23839@elte.hu>
 <4B31D487.6060706@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B31D487.6060706@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 12/23/2009 05:01 PM, Ingo Molnar wrote:
> > At least as far as i'm concerned, i'd like to see actual uses. It's a big 
> > linecount increase all things considered:
> > 
> >    20 files changed, 2783 insertions(+), 660 deletions(-)
> > 
> > and you say it _wont_ help performance/scalability (this aspect
> > wasnt clear to me from previous discussions),
> 
> I'm just not sure how it would turn out. I guess it would be an overall win 
> under loaded situations due to lowered cache footprint but I don't think it 
> will be anything which would stand out.
>
> > so the (yet to be seen) complexity reduction in other code ought to be 
> > worth it.
> 
> Sure, fair enough but there's also a different side.  It'll allow much 
> easier implementation of things like in-kernel media presence polling (I 
> have some code for this but it's still just forming) and per-device.  It 
> gives a much easier tool to extract concurrency and thus opens up new 
> possibilities.
> 
> So, anyways, alright, I'll go try some conversions.

Well, but note that you are again talking performance. Concurrency _IS_ 
performance: either in terms of reduced IO/app/request latency or in terms of 
CPU utilization.

Both metrics can be measured (and there's a massive effort underway to help 
measure such things - see current results under tools/perf/ in your favorite 
kernel repo ;-)

(Plus reduction in driver complexity can be measured as well, in the diffstat 
space.)

So there's no leap of faith needed really, IMHO.

	Ingo
