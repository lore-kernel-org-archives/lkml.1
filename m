Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXH2Dmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXH2Dmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 23:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbXH2Dm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 23:42:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40106 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbXH2Dm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 23:42:28 -0400
Date: Wed, 29 Aug 2007 05:42:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch] sched: fix broken smt/mc optimizations with CFS
Message-ID: <20070829034214.GA30551@elte.hu>
References: <20070816010150.GG10033@linux-os.sc.intel.com> <20070823115416.GA31027@elte.hu> <20070823121341.GA5775@elte.hu> <20070827191905.GE1894@linux-os.sc.intel.com> <20070827192324.GA29441@elte.hu> <20070827193103.GF1894@linux-os.sc.intel.com> <20070828222718.GI1894@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828222718.GI1894@linux-os.sc.intel.com>
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


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> On Mon, Aug 27, 2007 at 12:31:03PM -0700, Siddha, Suresh B wrote:
> > Essentially I observed that nice 0 tasks still endup on two cores of same
> > package, with out getting spread out to two different packages. This behavior
> > is same with out this fix and this fix doesn't help in any way.
> 
> Ingo, Appended patch seems to fix the issue and as far as I can test, 
> seems ok to me.

thanks! I've queued your fix up for .23 merge. I've done a quick test 
and it indeed seems to work well.

> This is a quick fix for .23. Peter Williams and myself plan to look at 
> code cleanups in this area (HT/MC optimizations) post .23
> 
> BTW, with this fix, do you want to retain the current FUZZ value?

what value would you suggest? I was thinking about using 
busiest_rq->curr->load.weight instead, to always keep rotating tasks.

	Ingo
