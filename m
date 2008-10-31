Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbYJaJXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbYJaJXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYJaJXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:23:07 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:54309 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYJaJXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:23:06 -0400
X-SourceIP: 213.46.9.244
Subject: Re: dbench 15% regression with 2.6.28-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1225444465.1685.99.camel@ymzhang>
References: <1225183290.1685.73.camel@ymzhang>
	 <1225444465.1685.99.camel@ymzhang>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Oct 2008 10:23:29 +0100
Message-Id: <1225445009.7803.1203.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-31 at 17:14 +0800, Zhang, Yanmin wrote:
> On Tue, 2008-10-28 at 16:41 +0800, Zhang, Yanmin wrote:
> > Comparing with 2.6.27, dbench result has regression with 2.6.28-rc1 on 2 machines.
> > 1) 8-core stoakley: 15%
> > 2) 8 core+mutl-thread new-model x86-64: 12%
> > 
> > Bisect located below patch.
> > 
> > 695698500912c4479ddf4723e492de3970ff8530 is first bad commit
> > commit 695698500912c4479ddf4723e492de3970ff8530
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Tue Sep 23 14:54:23 2008 +0200
> > 
> >     sched: rework wakeup preemption
> >     
> >     Rework the wakeup preemption to work on real runtime instead of
> >     the virtual runtime. This greatly simplifies the code.
> >     
> >     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> > I reverted the patch against 2.6.28-rc2 and the regression mostly disappears
> > on 8-core stoakley and 8-core+multiThread x86-64 machines.
> > 
> > 
> > ﻿On other 2 machines, I see improvement instead of regression.
> > 1) 16-core tigerton: improvement 48%
> > 2) 8-core+hyperThreading tulsa: 10%.
> > I just checked it by reverting above patch to see if the patch improves it. At least
> > it isn't on tigerton. I'm doing a new bisect on tigerton to see what patch improves
> > dbench result.
> The improvement on tigerton isn't caused by the patch. It seems it is caused by
> other scheduler patches.
> 
> Well, comparing with 2.6.27, the result of sysbench+mysql (oltp readonly) with 2.6.28-rc2
> has about 10% improvement, especially with high thread number. I located that's casued
> by the rework_wakeup_preemption patch.
> 
> So the patch improves oltp result, but downgrades dbench result.

The thing is, a later patch undoes this one. I'm just not sure when its
landed in -linus.

This vruntime -> real-time wakeup preemption was a test to see if it
would work because the code is so much simpler, but the sad truth is
that it doesn't work all that well, so we went back already.

Its just that the patch going back to vruntime based wakeup didn't make
it in -rc1 (and possibly -rc2).



