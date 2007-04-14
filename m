Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbXDNQPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbXDNQPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 12:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbXDNQPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 12:15:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39540 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbXDNQPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 12:15:12 -0400
Date: Sat, 14 Apr 2007 18:14:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414161451.GC3099@elte.hu>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070414132732.GA22103@1wt.eu> <20070414144544.GO943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414144544.GO943@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> BTW, I've tried your fork patch. It definitely helps forking because 
> it takes below one second to create 4000 processes, then the load 
> slowly increases. As you said, the children have to earn their share, 
> and I find that it makes it easier to conserve control of the whole 
> system's stability.

ok, thanks for testing this out, i think i'll integrate this one back 
into the core. (I'm still unsure about the cpu-hog one.) And it saves 
some code-size too:

   text    data     bss     dec     hex filename
  23349    2705      24   26078    65de kernel/sched.o.cfs-v1
  23189    2705      24   25918    653e kernel/sched.o.cfs-before
  23052    2705      24   25781    64b5 kernel/sched.o.cfs-after

  23366    4001      24   27391    6aff kernel/sched.o.vanilla
  23671    4548      24   28243    6e53 kernel/sched.o.sd.v40

	Ingo
