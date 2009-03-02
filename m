Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZCBV0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZCBV0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZCBV0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:26:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52186 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbZCBVZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:25:59 -0500
Date: Mon, 2 Mar 2009 22:25:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       sqazi@google.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090302212543.GD20228@elte.hu>
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <20090228173813.6d86c0ef@infradead.org> <49A9E7A3.4050102@zytor.com> <200903020106.51865.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0903021255020.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903021255020.3111@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> We can play games in the kernel. We do know how many sockets 
> there are. We do know the cache size. We _could_ try to make 
> an educated guess at whether the next user of the data will be 
> DMA or not. So there are unquestionably heuristics we could 
> apply, but I also do suspect that they'd inevitably be pretty 
> arbitrary.

There's a higher-level meta-code argument to consider as well, 
and i find it equally important: finding this rather obvious and 
easy to measure performance regression caused by the 
introduction of MOVNT took us two years.

That's _way_ too long - and adding more heuristics and more 
complexity will just increase this latency. (as we will create 
small niches of special cases with special workloads where we 
might or might not regress)

So, if any such change is done, we can only do it if we have the 
latency of performance-regression-finding on the order of days 
or at most weaks - not years.

	Ingo
