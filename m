Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbXDQKCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbXDQKCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 06:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbXDQKCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 06:02:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36553 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbXDQKCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 06:02:47 -0400
Date: Tue, 17 Apr 2007 12:01:57 +0200
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
Message-ID: <20070417100157.GC25553@elte.hu>
References: <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com> <20070417070949.GR8915@holomorphy.com> <20070417073308.GB30559@elte.hu> <20070417090538.GU8915@holomorphy.com> <20070417092422.GA19414@elte.hu> <20070417095749.GN2986@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417095749.GN2986@holomorphy.com>
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

> On Tue, Apr 17, 2007 at 11:24:22AM +0200, Ingo Molnar wrote:
>
> > until now the main approach for nice levels in Linux was always: 
> > "implement your main scheduling logic for nice 0 and then look for 
> > some low-overhead method that can be glued to it that does something 
> > that behaves like nice levels". Feel free to turn that around into a 
> > more natural approach, but the algorithm should remain fairly simple 
> > i think.
> 
> Part of my insistence was because it seemed to be relatively close to 
> a one-liner, though I'm not entirely sure what particular computation 
> to use to handle the signedness of the keys. I guess I could pick some 
> particular nice semantics myself and then sweep the extant schedulers 
> to use them after getting a testcase hammered out.

i'd love to have a oneliner solution :-)

wrt. signedness: note that in v2 i have made rq_running signed, and most 
calculations (especially those related to nice) are signed values. (On 
64-bit systems this all isnt a big issue - most of the arithmetics 
gymnastics in CFS are done to keep deltas within 32 bits, so that 
divisions and multiplications are sane.)

	Ingo
