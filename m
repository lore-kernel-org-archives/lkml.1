Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYLPDZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYLPDZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 22:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYLPDZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 22:25:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:36548 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750965AbYLPDZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 22:25:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Ujt0tp+mUJtucIvExRH6vhHlO2yNMhSp+L5lE8i
	DJok3o/CNkOVm4
Subject: Re: [Bug #12208] uml is very slow on 2.6.28 host
From: Mike Galbraith <efault@gmx.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rjw@sisk.pl, a.p.zijlstra@chello.nl, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
In-Reply-To: <E1LCO85-0000rR-Br@pomaz-ex.szeredi.hu>
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera>
	 <T1gm2CtAHBF.A.u6G.g4_QJB@chimera>  <E1LCO85-0000rR-Br@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 04:25:27 +0100
Message-Id: <1229397927.5296.48.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 01:49 +0100, Miklos Szeredi wrote:
> On Sat, 13 Dec 2008, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12208
> > Subject		: uml is very slow on 2.6.28 host
> > Submitter	: Miklos Szeredi <miklos@szeredi.hu>
> > Date		: 2008-12-12 9:35 (2 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122907463518593&w=4
> 
> I did a bisection, and this is the commit which is responsible:
> 
>   commit 464b75273f64be7c81fee975bd6ca9593df3427b
>   Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
>   Date:   Fri Oct 24 11:06:15 2008 +0200
>   
>       sched: re-instate vruntime based wakeup preemption
>   
>       The advantage is that vruntime based wakeup preemption has a better
>       conceptual model. Here wakeup_gran = 0 means: preempt when 'fair'.
>       Therefore wakeup_gran is the granularity of unfairness we allow in order
>       to make progress.
>   
>       Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>       Acked-by: Mike Galbraith <efault@gmx.de>
>       Signed-off-by: Ingo Molnar <mingo@elte.hu>

If that commit is responsible, then it should also be very slow in pre
28 kernels, where the same exists.  Hm, there's another possibility.
Can you try echo NO_LAST_BUDDY > /sys/kernel/debug/sched_features?

	-Mike

