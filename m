Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYHTJhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYHTJhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 05:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbYHTJhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 05:37:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52116 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbYHTJhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 05:37:16 -0400
Date: Wed, 20 Aug 2008 11:36:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Bill Fink <billfink@mindspring.com>,
       David Witbrodt <dawitbro@sbcglobal.net>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user
	with the same regression
Message-ID: <20080820093617.GA27681@elte.hu>
References: <109483.89278.qm@web82104.mail.mud.yahoo.com> <86802c440808192221s3ada5443qc3b9d8e26f252d03@mail.gmail.com> <20080820035130.38426b00.billfink@mindspring.com> <86802c440808200102n6487ae17ud790991b8ea30d16@mail.gmail.com> <20080820091513.GA23865@elte.hu> <86802c440808200231h27ab9121ofe68c86c2a80535e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808200231h27ab9121ofe68c86c2a80535e@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Wed, Aug 20, 2008 at 2:15 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >> > This is true if he reverted just the 3def3d6d... commit, but if he
> >> > also reverts the similar, and immediately following, 1e934dda...
> >> > commit, then his 2.6.26 kernel runs fine.
> >>
> >> interesting,
> >>
> >> David, can you try only comment out
> >>
> >> late_initcall(lapic_insert_resource);
> >
> > i.e. the patch below?
> >
> > what's your theory, what could be the reason for David's lockups?
> 
> could be insert_resource related.
> 1. revert patch that change back insert_resource doesn't work
> 2. insert_resource for lapic address moved to late after ....
> 
> need to add debug printout for insert_resource/request_resource to 
> make sure thing going well

but what can happen if it does not "go well"? The resource list is 
basically there to make sure we dont overlap resources. But is there a 
real danger here for any overlap?

And insert_resource() differs from request_resource() in that 
insert_resource() allows "complete overlap". David has done printks of 
all resources in this thread - can you see anything suspicious in there?

and what's the connection to your e820 patches?

	Ingo
