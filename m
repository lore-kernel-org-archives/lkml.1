Return-Path: <linux-kernel-owner+w=401wt.eu-S1763217AbXHNDCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763217AbXHNDCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 23:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbXHNDBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 23:01:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43423 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754548AbXHNDBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 23:01:49 -0400
Date: Mon, 13 Aug 2007 20:00:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lmbench ctxsw regression with CFS
Message-Id: <20070813200038.7fc8a9e6.akpm@linux-foundation.org>
In-Reply-To: <20070813123031.GS23758@kernel.dk>
References: <20070802021525.GC15595@wotan.suse.de>
	<alpine.LFD.0.999.0708011922500.3582@woody.linux-foundation.org>
	<20070802024132.GD15595@wotan.suse.de>
	<20070802071956.GA23300@elte.hu>
	<20070802073123.GB16744@wotan.suse.de>
	<20070802154447.GA13725@elte.hu>
	<20070803001447.GA14775@wotan.suse.de>
	<20070804065037.GA30816@elte.hu>
	<20070806032949.GA16401@wotan.suse.de>
	<20070813123031.GS23758@kernel.dk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 14:30:31 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> On Mon, Aug 06 2007, Nick Piggin wrote:
> > > > What CPU did you get these numbers on? Do the indirect calls hurt much 
> > > > on those without an indirect predictor? (I'll try running some tests).
> > > 
> > > it was on an older Athlon64 X2. I never saw indirect calls really 
> > > hurting on modern x86 CPUs - dont both CPU makers optimize them pretty 
> > > efficiently? (as long as the target function is always the same - which 
> > > it is here.)
> > 
> > I think a lot of CPUs do. I think ia64 does not. It predicts
> > based on the contents of a branch target register which has to
> > be loaded I presume before instructoin fetch reaches the branch.
> > I don't know if this would hurt or not.
> 
> Testing on ia64 showed that the indirect calls in the io scheduler hurt
> quite a bit, so I'd be surprised if the impact here wasn't an issue
> there.

With what workload?  lmbench ctxsw?  Who cares?

Look, if you're doing 100,000 context switches per second per then *that*
is your problem.  You suck, and making context switches a bit faster
doesn't stop you from sucking.  And ten microseconds is a very long time
indeed.

Put it this way: if a 50% slowdown in context switch times yields a 5%
improvement in, say, balancing decisions then it's probably a net win.

Guys, repeat after me: "context switch is not a fast path".  Take that
benchmark and set fire to it.

