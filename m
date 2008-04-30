Return-Path: <linux-kernel-owner+w=401wt.eu-S1763978AbYD3S2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763978AbYD3S2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbYD3S21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:28:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60577 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758495AbYD3S20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:28:26 -0400
Date: Wed, 30 Apr 2008 20:27:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: "J.A. Magall??n" <jamagallon@ono.com>, Glauber Costa <gcosta@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Problems with -git14
Message-ID: <20080430182741.GA5783@elte.hu>
References: <20080430015655.5a42f63d@werewolf.home> <Pine.LNX.4.64.0804301516580.30549@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804301516580.30549@blonde.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Hugh Dickins <hugh@veritas.com> wrote:

> One point worth noting - is it a worry?  Prior to that smpboot merge, 
> my Xeon booted the two HT siblings on one physical first, then the two 
> siblings on the other physical after - when i386, but alternated them 
> when x86_64.  Since the merge, the x86_64 sequence is unchanged, but 
> the i386 sequence is now like x86_64.  I prefer this consistency, and 
> I prefer the new sequence: booting with maxcpus=2 then uses the 
> independent physicals without HT sharing; but surprises in store?

yep - but right now our view is that such surprises are worth having in 
this case. Basically we now did the more or less "mechanical" 
unification of the two SMP boot codebases, while trying to keep the 
stability track record of both, as much as possible.

The 64-bit SMP boot code (the one which came from arch/x86_64) is 
cleaner, so the plan is to slowly but surely gravitate towards the 
cleaner code - such as with your fix - while not dropping quirks and 
legacies.

It's now possible to do that without impacting the stability (and 
legacy) track record of the 32-bit code too much, because now the code 
is placed next to each other and the differences are plain visible via 
ugly #ifdefs. Whatever change we do is small and revertable.

... but it's still not easy to modify the engine of a race car, in the 
middle of the race - so please be on the lookout and any help is welcome 
;-)

	Ingo
