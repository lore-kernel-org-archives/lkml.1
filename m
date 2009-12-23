Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbZLWGDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbZLWGDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 01:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZLWGDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 01:03:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33794 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbZLWGDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 01:03:35 -0500
Date: Wed, 23 Dec 2009 07:02:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
Message-ID: <20091223060229.GA14805@elte.hu>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
 <1261143924.20899.169.camel@laptop>
 <4B2EE5A5.2030208@kernel.org>
 <1261387377.4314.37.camel@laptop>
 <4B2F7879.2080901@kernel.org>
 <1261405604.4314.154.camel@laptop>
 <4B3009DC.7020407@kernel.org>
 <1261480001.4937.21.camel@laptop>
 <4B319A20.9010305@kernel.org>
 <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Workqueues generally aren't about heavy CPU usage, although some workqueue 
> usage has scalability issues. And the most common scalability problem is not 
> "I need more than one CPU", but often "I need to run even though another 
> workqueue entry is blocked on IO" - iow, it's not about lacking CPU power, 
> it's about in-fighting with other workqueue users.
> 
> That said, if we can improve on this further, I'd be all for it. I'd love to 
> have some generic async model that really works. So far, our async models 
> have tended to not really work out well, whether they be softirq's or kernel 
> threads (many of the same issues: some subsystems start tons of kernel 
> threads just because one kernel thread blocks, not because you need 
> multi-processor CPU usage per se). And AIO/threadlets never got anywhere etc 
> etc.

Not from lack of trying though ;-)

One key thing i havent seen in this discussion are actual measurements. I 
think a lot could be decided by simply testing this patch-set, by looking at 
the hard numbers: how much faster (or slower) did a particular key workload 
get before/after these patches.

Likewise, if there's a reduction in complexity, that is a tangible metric as 
well: lets do a few conversions as part of the patch-set and see how much 
simpler things have become as a result of it.

We really are not forced to the space of Gedankenexperiments here.

	Ingo
