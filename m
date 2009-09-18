Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbZIRNPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbZIRNPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 09:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbZIRNPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 09:15:04 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:37316 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068AbZIRNPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 09:15:03 -0400
Subject: Re: aim7 scalability issue on 4 socket machine
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20090918071217.GB17634@basil.fritz.box>
References: <1253179879.2606.37.camel@ymzhang>
	 <1253180411.8497.1.camel@twins>
	 <Pine.LNX.4.64.0909171122180.25864@sister.anvils>
	 <1253239339.2606.40.camel@ymzhang>
	 <20090917195909.3a00ef83.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0909180742500.14561@sister.anvils>
	 <20090918071217.GB17634@basil.fritz.box>
Content-Type: text/plain
Organization: HP/LKTT
Date: Fri, 18 Sep 2009 09:15:02 -0400
Message-Id: <1253279702.4732.24.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 09:12 +0200, Andi Kleen wrote:
> On Fri, Sep 18, 2009 at 07:53:58AM +0100, Hugh Dickins wrote:
> > On Thu, 17 Sep 2009, Andrew Morton wrote:
> > > On Fri, 18 Sep 2009 10:02:19 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:
> > > > > 
> > > > > So, Yanmin, please retest with http://lkml.org/lkml/2009/9/13/25
> > > > > and let us know if that works as well for you - thanks.
> > > > I tested Lee's patch and it does fix the issue.
> > 
> > Thanks for checking and reporting back, Yanmin.
> > 
> > > 
> > > Do we think we should cook up something for -stable?
> > 
> > Gosh, I laughed at Lee (sorry!) for suggesting it for -stable:
> > is stable really for getting a better number out of a benchmark?
> 
> When your system is large enough scalability problems (e.g.
> lock contention) can be a serious bug. i.e. when your workload
> is 150% slower than expected that can well be a show stopper.
> 
> Admittedly the workload in this case was a benchmark, but it's
> not that far fetched to expect the same problem in a real application.
> 
> We had a similar problem with the accounting lock some time 
> ago, I think that patch also went in.
> 
> So yes I think simple non intrusive fixes for serious scalability
> problems should be stable candidates.
> 
> > > Either this is a regression or the workload is particularly obscure. 
> > 
> > I've not cross-checked descriptions, but assume Lee was actually
> > testing on exactly the same kind of upcoming Nehalem as Yanmin, and
> > that machine happens to have characteristics which show up badly here.
> 
> AFAIK Lee usually tests on large IA64 boxes.

In this case, it's an x86_64 [DL785] platform--an 8 socket, 4 core
Shanghai in a glueless, "twisted ladder" config.

Lee


