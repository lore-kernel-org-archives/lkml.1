Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbZIHJuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbZIHJuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 05:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZIHJuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 05:50:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:55917 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbZIHJuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 05:50:21 -0400
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Buesch <mb@bu3sch.de>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <20090908074825.GA11413@elte.hu>
References: <20090906205952.GA6516@elte.hu>
	 <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu>
	 <20090908074825.GA11413@elte.hu>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 19:50:00 +1000
Message-Id: <1252403400.4950.81.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 09:48 +0200, Ingo Molnar wrote:
> So either your MIPS system has some unexpected dependency on the 
> scheduler, or there's something weird going on.
> 
> Mind poking on this one to figure out whether it's all repeatable 
> and why that slowdown happens? Multiple attempts to reproduce it 
> failed here for me.

Could it be the scheduler using constructs that don't do well on MIPS ? 

I remember at some stage we spotted an expensive multiply in there,
maybe there's something similar, or some unaligned or non-cache friendly
vs. the MIPS cache line size data structure, that sort of thing ...

Is this a SW loaded TLB ? Does it misses on kernel space ? That could
also be some differences in how many pages are touched by each scheduler
causing more TLB pressure. This will be mostly invisible on x86.

At this stage, it will be hard to tell without some profile data I
suppose. Maybe next week I can try on a small SW loaded TLB embedded PPC
see if I can reproduce some of that, but no promises here.

Cheers,
Ben.

