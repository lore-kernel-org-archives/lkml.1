Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZGCIJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZGCIJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZGCIJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:09:37 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:37570 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbZGCIJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:09:35 -0400
Subject: Re: [PATCH] kmemleak: Mark nice +10
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
In-Reply-To: <20090703070036.GC32687@elte.hu>
References: <200907010300.n6130rRf026194@hera.kernel.org>
	 <20090701075332.GA17252@elte.hu>
	 <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
	 <20090701093015.GA6862@elte.hu>
	 <1246528108.13320.19.camel@pc1117.cambridge.arm.com>
	 <20090703070036.GC32687@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 03 Jul 2009 09:09:13 +0100
Message-Id: <1246608553.24965.2.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2009 08:09:15.0833 (UTC) FILETIME=[8EB02290:01C9FBB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 09:00 +0200, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > On Wed, 2009-07-01 at 11:30 +0200, Ingo Molnar wrote:
> > > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > 
> > > > > The minimal fix below removes scan_yield() and adds a 
> > > > > cond_resched() to the outmost (safe) place of the scanning 
> > > > > thread. This solves the regression.
> > > > 
> > > > With CONFIG_PREEMPT disabled it won't reschedule during the bss 
> > > > scanning but I don't see this as a real issue (task stacks 
> > > > scanning probably takes longer anyway).
> > > 
> > > Yeah. I suspect one more cond_resched() could be added - i just 
> > > didnt see an obvious place for it, given that scan_block() is being 
> > > called with asymetric held-locks contexts.
> > 
> > Now that your patch was merged, I propose adding a few more 
> > cond_resched() calls, useful for the !PREEMPT case:
> 
> note, please also merge the renicing fix you sent. I have it tested 
> in tip:out-of-tree, attached below.

I have this patch in my kmemleak branch
(http://www.linux-arm.org/git?p=linux-2.6.git;a=shortlog;h=kmemleak)
which I plan to push to Linus, only that I was waiting to accumulate a
few more patches (to avoid sending too many pull requests).

I'll fix the scan_mutex lock as well, following comments and send a pull
request tonight.

Thanks.

-- 
Catalin

