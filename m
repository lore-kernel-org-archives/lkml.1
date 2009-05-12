Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbZELOeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbZELOeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbZELOdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:33:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36635 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbZELOdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:33:50 -0400
Date: Tue, 12 May 2009 16:33:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/5] [GIT PULL] ring-buffer: optimize to 17%
	performance increase
Message-ID: <20090512143339.GA6304@elte.hu>
References: <20090512040832.681953177@goodmis.org> <20090512083301.GA20435@elte.hu> <alpine.DEB.2.00.0905120923250.13234@gandalf.stny.rr.com> <alpine.DEB.2.00.0905121022560.13234@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905121022560.13234@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Tue, 12 May 2009, Steven Rostedt wrote:
> > > 
> > > It's also interesting to see that text size went down when speed 
> > > went up. I'm wondering how these compiler options:
> > 
> > But that was not always the case. The biggest boost in performance of the 
> > series (the last patch) also increased the size.
> > 
> > > 
> > >   CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> > >   CONFIG_OPTIMIZE_INLINING=y
> > 
> > Note, my test runs had both the above configure options disabled.
> > I'll run it again and see how they affect the results:
> 
> Here's the results:
> 
> size=n inline=n  270 
> size=n inline=y  290
> size=y inline=n  315
> size=y inline=y  372 (ouch!)
> 
> Thus it seems to keep both optimizations off is best for performance.

ok. Maybe newer gcc does better with size=y. optimize-inline=n is 
not a surprise - this is in essence a micro-benchmark where inlining 
helps - and gcc's inliner isnt too fantastic either.

	Ingo
