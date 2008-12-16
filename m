Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbYLPG4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbYLPG4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 01:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYLPG4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 01:56:04 -0500
Received: from viefep15-int.chello.at ([62.179.121.35]:52122 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875AbYLPG4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 01:56:02 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [Bug #12208] uml is very slow on 2.6.28 host
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rjw@sisk.pl, efault@gmx.de, mingo@elte.hu, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
In-Reply-To: <E1LCO85-0000rR-Br@pomaz-ex.szeredi.hu>
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera>
	 <T1gm2CtAHBF.A.u6G.g4_QJB@chimera>  <E1LCO85-0000rR-Br@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 07:56:01 +0100
Message-Id: <1229410561.14605.42.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
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

How's 27? That code basically makes .28 do what .27 did, we tried
something else for a little while and that made stuff suck rocks.

