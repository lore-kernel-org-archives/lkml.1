Return-Path: <linux-kernel-owner+w=401wt.eu-S1767201AbXDETFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767201AbXDETFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 15:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767218AbXDETFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 15:05:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59675 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767201AbXDETFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 15:05:38 -0400
Date: Thu, 5 Apr 2007 21:05:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Mike Galbraith <efault@gmx.de>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: [test] sched: SD-latest versus Mike's latest
Message-ID: <20070405190522.GA22092@elte.hu>
References: <200703290237.38777.kernel@kolivas.org> <1175770950.6609.16.camel@Homer.simpson.net> <20070405115447.GA24138@elte.hu> <200704060208.47327.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704060208.47327.kernel@kolivas.org>
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


* Con Kolivas <kernel@kolivas.org> wrote:

> Nice -10 on mainline ruins the latency of nice 0 tasks unlike SD. New 
> scheduling class just for X? Sounds like a very complicated 
> userspace-changing way to just do the equivalent of "nice -n -10" 
> obfuscated.

i think you are missing the point. We _do not know in advance_ whether X 
should be prioritized or not. It's the behavior of X that determines it. 
When X is reniced to -10 it fixes a few corner cases, but it breaks many 
other cases. We found that out time and time again.

btw., the tests i've done were not with X but using a shell prompt.

> > re-testing the weak points of SD:
> >
> >  - hackbench: still unusable under such type of high load - no 
> >  improvement.
> 
> Load of 160. Is proportional slowdown bad?

this is relative to how mainline+Mike's handles it. Users wont really 
care about the why's, they'll only see the slowdown.

> >  - make -j: still less interactive than Mike's - no improvement.
> 
> Depends on how big your job number vs cpu is. The better the 
> throttling gets with mainline the better SD gets in this comparison. 
> At equal fairness mainline does not have the low latency interactivity 
> SD has.

i often run make jobs with -j200 or larger, and SD gets worse than even 
mainline much sooner than that.

	Ingo
