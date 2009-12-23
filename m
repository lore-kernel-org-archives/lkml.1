Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZLWIOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZLWIOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZLWIOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:14:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48092 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbZLWIOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:14:34 -0500
Date: Wed, 23 Dec 2009 09:12:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
Message-ID: <20091223081238.GA29963@elte.hu>
References: <1261387377.4314.37.camel@laptop>
 <4B2F7879.2080901@kernel.org>
 <1261405604.4314.154.camel@laptop>
 <4B3009DC.7020407@kernel.org>
 <1261480001.4937.21.camel@laptop>
 <4B319A20.9010305@kernel.org>
 <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain>
 <20091223060229.GA14805@elte.hu>
 <4B31C210.4010100@kernel.org>
 <20091223080144.GG23839@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223080144.GG23839@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> At least as far as i'm concerned, i'd like to see actual uses. It's a big 
> linecount increase all things considered:
> 
>    20 files changed, 2783 insertions(+), 660 deletions(-)
> 
> and you say it _wont_ help performance/scalability (this aspect wasnt clear 
> to me from previous discussions), so the (yet to be seen) complexity 
> reduction in other code ought to be worth it.

To further stress this point, i'd like to point to the very first commit that 
introduced kernel/workqueue.c into Linux 7 years ago:

 | From 6ed12ff83c765aeda7d38d3bf9df7d46d24bfb11 Mon Sep 17 00:00:00 2001
 | From: Ingo Molnar <mingo@elte.hu>
 | Date: Mon, 30 Sep 2002 22:17:42 -0700
 | Subject: [PATCH] [PATCH] Workqueue Abstraction

look at the diffstat of that commit:

   201 files changed, 1102 insertions(+), 1194 deletions(-)

despite adding a new abstraction and kernel subsystem (workqueues), that 
commit modified more than a hundred drivers to make use of it, and managed to 
achieve a net linecount decrease of 92 lines - despite adding hundreds of 
lines of a new core facility.

Likewise, for this particular patchset it should be possible to identify 
existing patterns of code in the existing code base of 6+ millions lines of 
Linux driver code that would make the advantages of this +2000 lines of core 
kernel code plain obvious. There were multipe claims of problems with the 
current abstractions - so there sure must be a way to show off the new code in 
a few places.

	Ingo
