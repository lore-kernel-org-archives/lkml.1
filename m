Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbXA1P0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbXA1P0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbXA1P0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:26:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33769 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbXA1P0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:26:18 -0500
Date: Sun, 28 Jan 2007 16:24:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
Message-ID: <20070128152435.GC9196@elte.hu>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128120509.719287000@programming.kicks-ass.net> <20070128143941.GA16552@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128143941.GA16552@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Jan 28, 2007 at 12:51:21PM +0100, Peter Zijlstra wrote:
> > This barrier thing is constructed so that it will not write in the 
> > sync() condition (the hot path) when there are no active lock 
> > sections; thus avoiding cacheline bouncing. -- I'm just not sure how 
> > this will work out in relation to PI. We might track those in the 
> > barrier scope and boost those by the max prio of the blockers.
> 
> Is this really needed?  We seem to grow new funky locking algorithms 
> exponentially, while people already have a hard time understanding the 
> existing ones.

yes, it's needed.

	Ingo
