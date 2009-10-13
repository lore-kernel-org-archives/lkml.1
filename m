Return-Path: <linux-kernel-owner+w=401wt.eu-S1758816AbZJMDML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816AbZJMDML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 23:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbZJMDMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 23:12:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:51459 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbZJMDMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 23:12:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,548,1249282800"; 
   d="scan'208";a="456874213"
Subject: Re: hackbench regression with kernel 2.6.32-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1255357264.10420.15.camel@twins>
References: <1255079943.25078.23.camel@ymzhang>
	 <1255084986.8802.46.camel@laptop>  <1255331120.3684.43.camel@ymzhang>
	 <1255357264.10420.15.camel@twins>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 11:12:02 +0800
Message-Id: <1255403522.3684.57.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 16:21 +0200, Peter Zijlstra wrote:
> On Mon, 2009-10-12 at 15:05 +0800, Zhang, Yanmin wrote:
> 
> > > So hackbench is a multi-cast, with one sender spraying multiple
> > > receivers, who in their turn don't spray back, right?
> 
> > Right. volanoMark has about 9% regression on stoakley and 50% regression
> > on tigerton. If I revert the original patches, volanoMark regression on stoakley
> > disappears, but still has about 45% on tigerton.
> 
> > > /me ponders a bit
> > > 
> > > Does this make it any better?
> 
> > I apply this patch and another one you sent on tbench email thread.
> > On stoakley, hackbench is recovered. If reverting the original 2 patches,
> > we get 8% improvement.
> > On tigerton, with your 2 patches, there is still about 45% regression.
> 
> [ and here I got confused because this 45% seemed to match the 45%
> above, but then I saw it was hackbench vs volano ]
Sorry for mentioning some data about multiple benchmarks in one email.


> 
> > As for volanoMark, with your 2 patches, regression disappears on staokley
> > and it becomes about 35% on tigerton.
> 
> So hackbench on tigerton is worse, but volano on tigerton is better with
> this patch vs reverting bits?
Right with your 2 new patches vs reverting the 2 original patches.

> 
> > The good news is only tbench has about 6% regression on Nehalem machines.
> > Other regressions such like hackbench/aim7/volanoMark is not clear/big on
> > Nehalem. But reverting the original 2 patches don't fix the tbench regression
> > on Nehalem machines.
> 
> Right, so Mike's suggestion of doing: 
>   echo NEXT_BUDDY > /debug/sched_features
With your 2 new patches plus NEXT_BUDDY configuration, hackbench has
some improvement instead of regression on tigerton now. So it does work.

NEXT_BUDDY has no help on volanoMark and tbench.

> 
> Seems like the next thing to try..
> 
> Mike, did we ever figure out _why_ NEXT_BUDDY introduced latencies?
> 
> Buddies shouldn't make latencies worse than regular while(1); loops
> would.
> 

