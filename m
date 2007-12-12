Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbXLLKph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbXLLKph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbXLLKp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:45:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41870 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbXLLKp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:45:27 -0500
Date: Wed, 12 Dec 2007 11:44:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071212104441.GC1611@elte.hu>
References: <20071207021952.6f0ac922@morte> <200712081157.27840.nickpiggin@yahoo.com.au> <20071208085207.GE30997@elte.hu> <200712121542.45957.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712121542.45957.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > the scariest bit is the adding of cpu_clock() to kernel/printk.c so 
> > late in the game, and the anti-recursion code i did there. Maybe 
> > because this only affects CONFIG_PRINTK_TIME we could try it even 
> > for v2.6.24.
> 
> Printk recursion I guess shouldn't happen, but if there is a bug 
> somewhere in eg. the scheduler locking, then it may trigger, right?

or we just crash somewhere. It's all about risk management - printk is 
crutial, and with more complex codepaths being touched in printk it 
might make sense to just add built-in recursion protection into printk 
via my patch.

> Probably pretty rare case, however it would be nice to be able to find 
> out where the recursion comes from? Can you put an instruction pointer 
> in the recursion message perhaps?

yeah, as i mentioned if this would be occuring in practice we can always 
save the stacktrace of the incident and output that. I opted for the 
simplest approach first. Thanks for your Reviewed-by, i've queued it up 
for 2.6.25.

	Ingo
