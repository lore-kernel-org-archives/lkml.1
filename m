Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbXDUQzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbXDUQzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 12:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXDUQzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 12:55:20 -0400
Received: from 1wt.eu ([62.212.114.60]:2126 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbXDUQzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 12:55:18 -0400
Date: Sat, 21 Apr 2007 18:53:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070421165326.GD7840@1wt.eu>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <20070421154614.GA26169@elte.hu> <20070421161818.GC7840@1wt.eu> <alpine.LFD.0.98.0704210931370.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704210931370.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2007 at 09:34:07AM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 21 Apr 2007, Willy Tarreau wrote:
> > 
> > If you remember, with 50/50, I noticed some difficulties to fork many
> > processes. I think that during a fork(), the parent has a higher probability
> > of forking other processes than the child. So at least, we should use
> > something like 67/33 or 75/25 for parent/child.
> 
> It would be even better to simply have the rule:
>  - child gets almost no points at startup
>  - but when a parent does a "waitpid()" call and blocks, it will spread 
>    out its points to the childred (the "vfork()" blocking is another case 
>    that is really the same).
> 
> This is a very special kind of "priority inversion" logic: you give higher 
> priority to the things you wait for. Not because of holding any locks, but 
> simply because a blockign waitpid really is a damn big hint that "ok, the 
> child now works for the parent".

I like this idea a lot. I don't know if it can be applied to pipes and unix
sockets, but it's clearly a way of saying "hurry up, I'm waiting for you"
which seems natural with inter-process communications. Also, if we can do
this on unix sockets, it would help a lot with X !

Willy

