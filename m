Return-Path: <linux-kernel-owner+w=401wt.eu-S964781AbYBCGr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781AbYBCGr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 01:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYBCGrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 01:47:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33902 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbYBCGrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 01:47:06 -0500
Date: Sun, 3 Feb 2008 07:46:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [patch 2/3] CONFIG_HIGHPTE vs. sub-page page tables.
Message-ID: <20080203064645.GA27929@elte.hu>
References: <20071112143009.425807965@de.ibm.com> <20071112144009.831296895@de.ibm.com> <20080201151541.8e3e0359.akpm@linux-foundation.org> <1202017020.7208.2.camel@pasglop> <20080202215315.3ac6907d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202215315.3ac6907d.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > It's a sane patch and a helps going further, and a total pain to 
> > re-do later on. Besides, I may have some use for it on powerpc at 
> > some point too...
> 
> OK, I'll try to reestablish it.
> 
> Look: I can't fix *everyone's* stuff.  This was a consequence of 
> ongoing unbounded churn in the x86 tree. [...]

i've reviewed this patchset and the right model appears to me to do this 
change upstream right now, atomically. It is supposed to be a pure 
functional NOP, and any deviation from that is easy to spot.

  Acked-by: Ingo Molnar <mingo@elte.hu>

I dont think it's particular wise to maintain a change like this across 
all the arch churn, for months. This patch is a pure cleanup, it could 
have been merged two months ago. The author should get agreement that 
it's fine to do it, and if the timing happens to be unfortunate for 
immediate merging (we are within say 1 month window before stable 
release) then delay it and redo the cleanup right when it's about to be 
merged.

The worst thing to do is to prolong this for months - it is only 
unnecessary work for no particular good reason. It complicates -mm 
merging, keeps an API fork around for no good reason, etc., etc.

there's tons of past examples of much larger transformations than this 
done right: for example the recent irq_regs changes. (and that one wasnt 
even a pure NOP like this change.)

In general, we can pick up the x86 bits of any tree-wide change into 
x86.git no problem, and then maintain it against all the nuances of 
x86.git churn. (That requires them to be shaped in a way so that they 
can be applied to one architecture at a time - which is obviously a good 
thing anyway - but not always possible, such as in this case where a 
common API is extended.)

If anyone is feeling _any_ serious effects of x86.git churn then please 
talk to us maintainers and we can work out some technical solution. The 
only thing we cannot do is to stop 100 active contributors and the flow 
of 1000 patches until someone finds the time to get tree-wide changes 
upstream.

Roland was able to shape his utrace-enabler regset patches upstream this 
way, and it is two or three orders of magnitude more complex of a code 
transformation than the one we are talking about here.

	Ingo
