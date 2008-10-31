Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbYJaJPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbYJaJPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYJaJPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:15:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:9493 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbYJaJPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:15:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,521,1220252400"; 
   d="scan'208";a="354378705"
Subject: Re: dbench 15% regression with 2.6.28-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1225183290.1685.73.camel@ymzhang>
References: <1225183290.1685.73.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 31 Oct 2008 17:14:25 +0800
Message-Id: <1225444465.1685.99.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-10-28 at 16:41 +0800, Zhang, Yanmin wrote:
> Comparing with 2.6.27, dbench result has regression with 2.6.28-rc1 on 2 machines.
> 1) 8-core stoakley: 15%
> 2) 8 core+mutl-thread new-model x86-64: 12%
> 
> Bisect located below patch.
> 
> 695698500912c4479ddf4723e492de3970ff8530 is first bad commit
> commit 695698500912c4479ddf4723e492de3970ff8530
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Tue Sep 23 14:54:23 2008 +0200
> 
>     sched: rework wakeup preemption
>     
>     Rework the wakeup preemption to work on real runtime instead of
>     the virtual runtime. This greatly simplifies the code.
>     
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> I reverted the patch against 2.6.28-rc2 and the regression mostly disappears
> on 8-core stoakley and 8-core+multiThread x86-64 machines.
> 
> 
> ﻿On other 2 machines, I see improvement instead of regression.
> 1) 16-core tigerton: improvement 48%
> 2) 8-core+hyperThreading tulsa: 10%.
> I just checked it by reverting above patch to see if the patch improves it. At least
> it isn't on tigerton. I'm doing a new bisect on tigerton to see what patch improves
> dbench result.
The improvement on tigerton isn't caused by the patch. It seems it is caused by
other scheduler patches.

Well, comparing with 2.6.27, the result of sysbench+mysql (oltp readonly) with 2.6.28-rc2
has about 10% improvement, especially with high thread number. I located that's casued
by the rework_wakeup_preemption patch.

So the patch improves oltp result, but downgrades dbench result.

-yanmin


