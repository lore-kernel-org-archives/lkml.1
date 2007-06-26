Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbXFZJjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbXFZJjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 05:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbXFZJjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 05:39:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54211 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbXFZJjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 05:39:09 -0400
Date: Tue, 26 Jun 2007 11:38:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "S.??a??lar Onur" <caglar@pardus.org.tr>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070626093823.GA9850@elte.hu>
References: <20070622220202.GA16872@elte.hu> <200706230109.08310.caglar@pardus.org.tr> <200706230116.29615.caglar@pardus.org.tr> <20070622222036.GC27445@elte.hu> <20070625200235.9d24f6cd.akpm@linux-foundation.org> <20070626083813.GA16151@elte.hu> <20070626020047.f019b731.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626020047.f019b731.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > the main reason is the sched debugging stuff:
> 
> That would serve to explain the 18% growth on x86_64.  But why did 
> i386 grow by much more: 29%?  I'd be suspecting all the new 64-bit 
> arithmetic.

this is what i see on 32-bit:

    text    data     bss     dec     hex filename
   28732    3905      24   32661    7f95 kernel/sched.o-vanilla
   37986    2538      20   40544    9e60 kernel/sched.o-v18
   31092    2426      20   33538    8302 kernel/sched.o-v18-no_sched_debug

text is larger but data got smaller. While they are not equivalent in 
function, the two almost even out each other (and that's without any of 
the uninlining that is in v19). In fact, there's a 1.5K per CPU percpu 
data size win with CFS, which is not visible in this stat. So on 
dual-core the net cost should already be zero.

> The cost on 32-bit appears to be pretty high.  Perhaps a round of 
> uninlining will help.

agreed, i've done one more round of uninlining.

	Ingo
