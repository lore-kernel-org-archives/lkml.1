Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbXHBLqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbXHBLqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbXHBLqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:46:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54842 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbXHBLqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:46:08 -0400
Date: Thu, 2 Aug 2007 13:45:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lee Revell <rlrevell@joe-job.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
Subject: Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Message-ID: <20070802114557.GC4067@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <1185839164.27166.7.camel@localhost> <1185863461.3092.4.camel@twins> <20070731085713.GA15136@elte.hu> <75b66ecd0708011935x600fc547j8edbe1ed3092d560@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75b66ecd0708011935x600fc547j8edbe1ed3092d560@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Lee Revell <rlrevell@joe-job.com> wrote:

> On 7/31/07, Ingo Molnar <mingo@elte.hu> wrote:
> > Almost all of the Reiser3
> > code runs under the BKL, and the only other major kernel infrastructure
> > that has BKL dependencies is the TTY code.
> 
> Also NFS:
> 
> $ grep -rIi lock_kernel kernel-source/linux-2.6.17/fs/nfs/ | wc -l
> 94

yeah - but i never saw NFS cause really big BKL latencies. IIRC it uses 
the BKL mostly for archaic reasons, most of the NFS code is SMP-safe. 
Almost all of the reiser3 code runs under the BKL on the other hand.

	Ingo
