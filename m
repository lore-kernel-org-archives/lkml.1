Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbXL3NKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbXL3NKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbXL3NKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:10:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53310 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584AbXL3NKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:10:39 -0500
Date: Sun, 30 Dec 2007 14:10:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, trem <tremyfr@yahoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20071230131018.GC16946@elte.hu>
References: <9DtBq-2jD-3@gated-at.bofh.it> <476EAF98.6040004@yahoo.fr> <20071223121410.0d572e03.akpm@linux-foundation.org> <20071224012524.GA21843@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071224012524.GA21843@gondor.apana.org.au>
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


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > Ingo, it's not good that we have cond_resched() definitions 
> > conditionally duplicated in kernel.h - that's increasing the risk of 
> > bugs like this one.
> 
> Actually, why do we even have cond_resched when real preemption is on? 
> It seems to be a waste of space and time.

due to the BKL. cond_resched() in BKL code breaks up BKL latencies.

i dont mind not doing that though - we should increase the pain for BKL 
users, so that subsystems finally get rid of it altogether. 
lock_kernel() use within the kernel is still rampant - there are still 
more than 400 callsites to lock_kernel().

	Ingo
