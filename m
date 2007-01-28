Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbXA1PZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbXA1PZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbXA1PZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:25:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33725 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbXA1PZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:25:36 -0500
Date: Sun, 28 Jan 2007 16:24:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] breaking the global file_list_lock
Message-ID: <20070128152404.GB9196@elte.hu>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128144325.GB16552@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4549]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Jan 28, 2007 at 12:51:18PM +0100, Peter Zijlstra wrote:
> > This patch-set breaks up the global file_list_lock which was found 
> > to be a severe contention point under basically any filesystem 
> > intensive workload.
> 
> Benchmarks, please.  Where exactly do you see contention for this?

it's the most contended spinlock we have during a parallel kernel 
compile on an 8-way system. But it's pretty common-sense as well, 
without doing any measurements, it's basically the only global lock left 
in just about every VFS workload that doesnt involve massive amount of 
dentries created/removed (which is still dominated by the dcache_lock).

> filesystem intensive workload apparently means namespace operation 
> heavy workload, right?  The biggest bottleneck I've seen with those is 
> dcache lock.

the dcache lock is not a problem during kernel compiles. (its 
rcu-ification works nicely in that workload)

	Ingo
