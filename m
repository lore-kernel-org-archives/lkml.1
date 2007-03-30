Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbXC3CRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbXC3CRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 22:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbXC3CRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 22:17:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:50432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbXC3CRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 22:17:31 -0400
Date: Fri, 30 Mar 2007 04:17:17 +0200
From: Nick Piggin <npiggin@suse.de>
To: Lee Revell <rlrevell@joe-job.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Ingo Molnar <mingo@elte.hu>, Nikita Danilov <nikita@clusterfs.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] queued spinlocks (i386)
Message-ID: <20070330021717.GF19407@wotan.suse.de>
References: <20070325155407.GA497@tv-sign.ru> <20070328070459.GC12508@wotan.suse.de> <20070329184213.GA83@tv-sign.ru> <Pine.LNX.4.64.0703291215440.1199@alien.or.mcafeemobile.com> <75b66ecd0703291906q265f9cc7g486cf65484ba8393@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75b66ecd0703291906q265f9cc7g486cf65484ba8393@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 10:06:41PM -0400, Lee Revell wrote:
> On 3/29/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> >On Thu, 29 Mar 2007, Oleg Nesterov wrote:
> >
> >> On 03/28, Nick Piggin wrote:
> >> >
> >> > Well with my queued spinlocks, all that lockbreak stuff can just come 
> >out
> >> > of the spin_lock, break_lock out of the spinlock structure, and
> >> > need_lockbreak just becomes (lock->qhead - lock->qtail > 1).
> >>
> >> Q: queued spinlocks are not CONFIG_PREEMPT friendly,
> >
> >Why? Is CONFIG_PREEMPT friendly to anyone? :)
> 
> Until someone fixes all the places in the kernel where scheduling can
> be held off for tens of milliseconds, CONFIG_PREEMPT will be an
> absolute requirement for many applications like audio and gaming.

There's nothing wrong with CONFIG_PREEMPT for those users. We have
a few other performance concessions activated with CONFIG_PREEMPT on.
I think a usual upper of a few miliseconds (especially for SMP) is
reasonable for a non preempt kernel.

