Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbZIHUeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbZIHUeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 16:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbZIHUeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 16:34:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44902 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbZIHUeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 16:34:07 -0400
Date: Tue, 8 Sep 2009 22:34:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090908203409.GJ18599@kernel.dk>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk> <20090907141458.GD24507@elte.hu> <20090907173846.GB18599@kernel.dk> <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252423398.7746.97.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08 2009, Peter Zijlstra wrote:
> On Tue, 2009-09-08 at 11:13 +0200, Jens Axboe wrote:
> > And here's a newer version.
> 
> I tinkered a bit with your proglet and finally found the problem.
> 
> You used a single pipe per child, this means the loop in run_child()
> would consume what it just wrote out until it got force preempted by the
> parent which would also get woken.
> 
> This results in the child spinning a while (its full quota) and only
> reporting the last timestamp to the parent.

Oh doh, that's not well thought out. Well it was a quick hack :-)
Thanks for the fixup, now it's at least usable to some degree.

> Since consumer (parent) is a single thread the program basically
> measures the worst delay in a thundering herd wakeup of N children.

Yes, it's really meant to measure how long it takes to wake a group of
processes, assuming that this is where things fall down on the 'box
loaded, switch desktop' case. Now whether that's useful or not or
whether this test app is worth the bits it takes up on the hard drive,
is another question.

-- 
Jens Axboe

