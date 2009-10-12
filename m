Return-Path: <linux-kernel-owner+w=401wt.eu-S932249AbZJLOVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbZJLOVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932222AbZJLOVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:21:52 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:31005 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbZJLOVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:21:52 -0400
X-SourceIP: 213.93.53.227
Subject: Re: hackbench regression with kernel 2.6.32-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1255331120.3684.43.camel@ymzhang>
References: <1255079943.25078.23.camel@ymzhang>
	 <1255084986.8802.46.camel@laptop>  <1255331120.3684.43.camel@ymzhang>
Content-Type: text/plain
Date: Mon, 12 Oct 2009 16:21:04 +0200
Message-Id: <1255357264.10420.15.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 15:05 +0800, Zhang, Yanmin wrote:

> > So hackbench is a multi-cast, with one sender spraying multiple
> > receivers, who in their turn don't spray back, right?

> Right. volanoMark has about 9% regression on stoakley and 50% regression
> on tigerton. If I revert the original patches, volanoMark regression on stoakley
> disappears, but still has about 45% on tigerton.

> > /me ponders a bit
> > 
> > Does this make it any better?

> I apply this patch and another one you sent on tbench email thread.
> On stoakley, hackbench is recovered. If reverting the original 2 patches,
> we get 8% improvement.
> On tigerton, with your 2 patches, there is still about 45% regression.

[ and here I got confused because this 45% seemed to match the 45%
above, but then I saw it was hackbench vs volano ]

> As for volanoMark, with your 2 patches, regression disappears on staokley
> and it becomes about 35% on tigerton.

So hackbench on tigerton is worse, but volano on tigerton is better with
this patch vs reverting bits?

> The good news is only tbench has about 6% regression on Nehalem machines.
> Other regressions such like hackbench/aim7/volanoMark is not clear/big on
> Nehalem. But reverting the original 2 patches don't fix the tbench regression
> on Nehalem machines.

Right, so Mike's suggestion of doing: 
  echo NEXT_BUDDY > /debug/sched_features

Seems like the next thing to try..

Mike, did we ever figure out _why_ NEXT_BUDDY introduced latencies?

Buddies shouldn't make latencies worse than regular while(1); loops
would.

