Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbXKNPxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbXKNPxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbXKNPww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:52:52 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:56088 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbXKNPwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:52:51 -0500
Date: Wed, 14 Nov 2007 18:53:00 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sigwait eats blocked default-ignore signals
Message-ID: <20071114155300.GA12407@tv-sign.ru>
References: <20071112234155.783744D04C9@magilla.localdomain> <20071113155638.GB74@tv-sign.ru> <20071114073249.CEECC26F8B6@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114073249.CEECC26F8B6@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13, Roland McGrath wrote:
>
> > But I suspect we have other issues here. Let's suppose we have threads T1
> > (main) and T2. T2 blocks SIGCHLD and does sigwait(SIGCHLD).
> > 
> > Now, we send SIGCHLD to the thread group. The signal is lost again because
> > sig_ignored() returns true on T1's side.
> > 
> > Is this OK? [...]
> 
> Yes, it's OK if T1 has SIGCHLD unblocked.  When there are multiple threads
> that either don't block the signal or are in sigwait for it, then it can go
> to any of them and there are no guarantees at all about which.  So we
> simply say that the signal went to the thread not in sigwait that has that
> signal unblocked (T1).  When it got there, it was ignored.  The user
> semantics are equivalent even if that thread never actually woke and
> dequeued the signal to ignore it.

Yes.

I misunderstood the required semantics for sigwait(), thanks Roland.

Oleg.

