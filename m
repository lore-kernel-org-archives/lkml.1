Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbXDNIJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbXDNIJb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 04:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161161AbXDNIJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 04:09:31 -0400
Received: from 1wt.eu ([62.212.114.60]:1817 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbXDNIJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 04:09:30 -0400
Date: Sat, 14 Apr 2007 10:08:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414080833.GL943@1wt.eu>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414064334.GA19463@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 08:43:34AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Nick noticed that upon fork we change parent->wait_runtime but we do 
> > not requeue it within the rbtree.
> 
> this fix is not complete - because the child runqueue is locked here, 
> not the parent's. I've fixed this properly in my tree and have uploaded 
> a new sched-modular+cfs.patch. (the effects of the original bug are 
> mostly harmless, the rbtree position gets corrected the first time the 
> parent reschedules. The fix might improve heavy forker handling.)

It looks like it did not reach your public dir yet.

BTW, I've given it a try. It seems pretty usable. I have also tried
the usual meaningless "glxgears" test with 12 of them at the same time,
and they rotate very smoothly, there is absolutely no pause in any of
them. But they don't all run at same speed, and top reports their CPU
load varying from 3.4 to 10.8%, with what looks like more CPU is
assigned to the first processes, and less CPU for the last ones. But
this is just a rough observation on a stupid test, I would not call
that one scientific in any way (and X has its share in the test too).

I'll perform other tests when I can rebuild with your fixed patch.

Cheers,
Willy

