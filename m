Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZGAJa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZGAJa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZGAJaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:30:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44590 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbZGAJaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:30:20 -0400
Date: Wed, 1 Jul 2009 11:30:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
Subject: Re: [PATCH] kmemleak: Fix scheduling-while-atomic bug
Message-ID: <20090701093015.GA6862@elte.hu>
References: <200907010300.n6130rRf026194@hera.kernel.org> <20090701075332.GA17252@elte.hu> <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> > The minimal fix below removes scan_yield() and adds a 
> > cond_resched() to the outmost (safe) place of the scanning 
> > thread. This solves the regression.
> 
> With CONFIG_PREEMPT disabled it won't reschedule during the bss 
> scanning but I don't see this as a real issue (task stacks 
> scanning probably takes longer anyway).

Yeah. I suspect one more cond_resched() could be added - i just 
didnt see an obvious place for it, given that scan_block() is being 
called with asymetric held-locks contexts.

	Ingo
