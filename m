Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbXEUHub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbXEUHub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 03:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbXEUHuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 03:50:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53577 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbXEUHuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 03:50:23 -0400
Date: Mon, 21 May 2007 09:50:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] lockdep: lock contention tracking
Message-ID: <20070521075013.GA9419@elte.hu>
References: <1179657026.5915.10.camel@lappy> <20070521060446.GA4593@gnuppy.monkey.org> <20070521060828.GB20277@elte.hu> <20070521064150.GC4442@gnuppy.monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521064150.GC4442@gnuppy.monkey.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Huey <billh@gnuppy.monkey.org> wrote:

> On Mon, May 21, 2007 at 08:08:28AM +0200, Ingo Molnar wrote:
> > To me it appears Peter's stuff is already a pretty complete solution on 
> > its own, and it's a whole lot simpler (and less duplicative) than your 
> > lockstat patch. Could you list the specific items/features that you 
> > think Peter's stuff doesnt have?
> 
> First of all, this isn't an either/or kind of thing nor should it be 
> thought of in that way.

why? Please be specific.

> Precise file/function/line placement for one thing. [...]

Have you looked at the output Peter's patch produces? It prints out 
precise symbols:

 dcache_lock: 3000 0 [618] [<ffffffff8033badd>] _atomic_dec_and_lock+0x39/0x58

which can easily be turned into line numbers using debuginfo packages or 
using gdb. (But normally one only needs the symbol name, and we 
certainly do not want to burden the kernel source with tracking 
__FILE__/__LINE__ metadata, if the same is already available via 
CONFIG_DEBUG_INFO.)

anything else?

> [...] My stuff is potentially more extensible since I have other ideas 
> for it that really are outside of the lockdep logic currently. [...]

what do you mean, specifically?

> That's why I was hessitant to completely unify with lockdep in the 
> manner you suggested.

i really need specifics. Currently i have the choice between your stuff:

   17 files changed, 1425 insertions(+), 80 deletions(-)

and Peter's patch:

    6 files changed,  266 insertions(+), 18 deletions(-)

and Peter's patch (if it works out fine in testing - and it seemed fine 
so far on my testbox), is smaller, more maintainable, better integrated 
and thus the clear candidate for merging into -rt and merging upstream 
as well. It's far cleaner than i hoped this whole lock-stats thing could 
be done based on lockdep, so i'm pretty happy with Peter's current patch 
already.

	Ingo
