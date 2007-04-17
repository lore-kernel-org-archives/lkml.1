Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbXDQJY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbXDQJY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 05:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbXDQJY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 05:24:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35401 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbXDQJYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 05:24:55 -0400
Date: Tue, 17 Apr 2007 11:24:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, Nick Piggin <npiggin@suse.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417092422.GA19414@elte.hu>
References: <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com> <20070417070949.GR8915@holomorphy.com> <20070417073308.GB30559@elte.hu> <20070417090538.GU8915@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417090538.GU8915@holomorphy.com>
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


* William Lee Irwin III <wli@holomorphy.com> wrote:

> [...] Also rest assured that the tone of the critique is not hostile, 
> and wasn't meant to sound that way.

ok :) (And i guess i was too touchy - sorry about coming out swinging.)

> Also, given the general comments it appears clear that some 
> statistical metric of deviation from the intended behavior furthermore 
> qualified by timescale is necessary, so this appears to be headed 
> toward a sort of performance metric as opposed to a pass/fail test 
> anyway. However, to even measure this at all, some statement of 
> intention is required. I'd prefer that there be a Linux-standard 
> semantics for nice so results are more directly comparable and so that 
> users also get similar nice behavior from the scheduler as it varies 
> over time and possibly implementations if users should care to switch 
> them out with some scheduler patch or other.

yeah. If you could come up with a sane definition that also translates 
into low overhead on the algorithm side that would be great! The only 
good generic definition i could come up with (nice levels are isolated 
buckets with a constant maximum relative percentage of CPU time 
available to every active bucket) resulted in having a per-nice-level 
array of rbtree roots, which did not look worth the hassle at first 
sight :-)

until now the main approach for nice levels in Linux was always: 
"implement your main scheduling logic for nice 0 and then look for some 
low-overhead method that can be glued to it that does something that 
behaves like nice levels". Feel free to turn that around into a more 
natural approach, but the algorithm should remain fairly simple i think.

	Ingo
