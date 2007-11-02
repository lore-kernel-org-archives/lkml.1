Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbXKBPhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbXKBPhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXKBPg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:36:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59841 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbXKBPg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:36:57 -0400
Date: Fri, 2 Nov 2007 16:36:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: David Miller <davem@davemloft.net>, duaneg@dghda.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb
	causes unkillable spinning
Message-ID: <20071102153643.GA29354@elte.hu>
References: <20071030.235600.254712083.davem@davemloft.net> <20071031074106.GE12189@wotan.suse.de> <20071031.004425.12962203.davem@davemloft.net> <20071101.220204.254984189.davem@davemloft.net> <20071102104554.GA941@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102104554.GA941@wotan.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> > This means that even if some cpu is stuck in a spinlock loop with 
> > interrupts disabled, you'd see it with this thing.  The way it works 
> > is that cross cpu vectored interrupts are disabled independently of 
> > the processor interrupt level on sparc64.
> 
> That's really sweet. I'd better put my code where my mouth is as 
> well... this patch seems to be about the best we can do as a generic 
> fallback without getting a dedicated vector (which has to be done in 
> arch code anyway).

btw., in -rt we had something like this implemented as an NMI mechanism 
(for x86) - that way it's guaranteed that we get some output even from 
locked up CPUs.

	Ingo
