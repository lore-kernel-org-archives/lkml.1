Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbXHBNjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbXHBNjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbXHBNjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:39:23 -0400
Received: from pat.uio.no ([129.240.10.15]:48521 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbXHBNjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:39:22 -0400
Subject: Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lee Revell <rlrevell@joe-job.com>, Peter Zijlstra <peterz@infradead.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
In-Reply-To: <20070802114557.GC4067@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu>
	 <1185839164.27166.7.camel@localhost> <1185863461.3092.4.camel@twins>
	 <20070731085713.GA15136@elte.hu>
	 <75b66ecd0708011935x600fc547j8edbe1ed3092d560@mail.gmail.com>
	 <20070802114557.GC4067@elte.hu>
Content-Type: text/plain
Date: Thu, 02 Aug 2007 09:39:08 -0400
Message-Id: <1186061948.7702.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.073)
X-UiO-Scanned: 7AF809BA8FAD72FD794576F86E6C378187BD072A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 606 total 3064672 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 13:45 +0200, Ingo Molnar wrote:
> * Lee Revell <rlrevell@joe-job.com> wrote:
> 
> > On 7/31/07, Ingo Molnar <mingo@elte.hu> wrote:
> > > Almost all of the Reiser3
> > > code runs under the BKL, and the only other major kernel infrastructure
> > > that has BKL dependencies is the TTY code.
> > 
> > Also NFS:
> > 
> > $ grep -rIi lock_kernel kernel-source/linux-2.6.17/fs/nfs/ | wc -l
> > 94
> 
> yeah - but i never saw NFS cause really big BKL latencies. IIRC it uses 
> the BKL mostly for archaic reasons, most of the NFS code is SMP-safe. 
> Almost all of the reiser3 code runs under the BKL on the other hand.

We're still working on fixing the NFS case, but as everyone knows,
finding those last few obscure code sections which still depend on BKL
protection can be tedious work...

Trond

