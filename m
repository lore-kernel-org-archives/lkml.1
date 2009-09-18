Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbZIRHMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbZIRHMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 03:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZIRHMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 03:12:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52940 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbZIRHMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 03:12:19 -0400
Date: Fri, 18 Sep 2009 09:12:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>
Subject: Re: aim7 scalability issue on 4 socket machine
Message-ID: <20090918071217.GB17634@basil.fritz.box>
References: <1253179879.2606.37.camel@ymzhang> <1253180411.8497.1.camel@twins> <Pine.LNX.4.64.0909171122180.25864@sister.anvils> <1253239339.2606.40.camel@ymzhang> <20090917195909.3a00ef83.akpm@linux-foundation.org> <Pine.LNX.4.64.0909180742500.14561@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909180742500.14561@sister.anvils>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 07:53:58AM +0100, Hugh Dickins wrote:
> On Thu, 17 Sep 2009, Andrew Morton wrote:
> > On Fri, 18 Sep 2009 10:02:19 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:
> > > > 
> > > > So, Yanmin, please retest with http://lkml.org/lkml/2009/9/13/25
> > > > and let us know if that works as well for you - thanks.
> > > I tested Lee's patch and it does fix the issue.
> 
> Thanks for checking and reporting back, Yanmin.
> 
> > 
> > Do we think we should cook up something for -stable?
> 
> Gosh, I laughed at Lee (sorry!) for suggesting it for -stable:
> is stable really for getting a better number out of a benchmark?

When your system is large enough scalability problems (e.g.
lock contention) can be a serious bug. i.e. when your workload
is 150% slower than expected that can well be a show stopper.

Admittedly the workload in this case was a benchmark, but it's
not that far fetched to expect the same problem in a real application.

We had a similar problem with the accounting lock some time 
ago, I think that patch also went in.

So yes I think simple non intrusive fixes for serious scalability
problems should be stable candidates.

> > Either this is a regression or the workload is particularly obscure. 
> 
> I've not cross-checked descriptions, but assume Lee was actually
> testing on exactly the same kind of upcoming Nehalem as Yanmin, and
> that machine happens to have characteristics which show up badly here.

AFAIK Lee usually tests on large IA64 boxes.

> > aim7 is sufficiently non-obscure to make me wonder what's happened here?
> 
> Not a regression, just the onward march of new hardware, I think.
> Could easily be other such things in other places with other tests.

Yes, it's just a much larger machine, so old hidden scalability sins now
appear.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
