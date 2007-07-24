Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbXGXOuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbXGXOuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbXGXOt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:49:57 -0400
Received: from mail.screens.ru ([213.234.233.54]:37615 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbXGXOt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:49:56 -0400
Date: Tue, 24 Jul 2007 18:51:42 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jeremy Katz <jeremy.katz@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
Message-ID: <20070724145142.GA199@tv-sign.ru>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain> <1184662429.12353.426.camel@chaos> <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain> <1184703427.12353.476.camel@chaos> <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain> <Pine.LNX.4.63.0707171654020.10358@localhost.localdomain> <20070718161156.GA761@tv-sign.ru> <Pine.LNX.4.63.0707181203110.3157@localhost.localdomain> <20070720141529.GA218@tv-sign.ru> <Pine.LNX.4.63.0707231858420.9759@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0707231858420.9759@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23, Jeremy Katz wrote:
>
> On Fri, 20 Jul 2007, Oleg Nesterov wrote:
> 
> >I still can't believe we have a double-free problem, this looks imposiible.
> >Do you see the
> >
> >	"idr_remove called for id=%d which is not allocated.\n"
> >
> >in syslog?
> 
> No.  I also added some accounting with atomic counters, and don't see 
> evidence of a second call to release_posix_timer.

Interesting. Could you show the patch? Where does sys_timer_create() set
counter == 1?

> >Could you try the patch below? Perhaps we have some wierd problem with
> >->sigq corruption.
> 
> Tried, with apparent effect.

You mean, "null pointer dereference" in release_posix_timer() ? Or it was
BUG_ON(timr && !timr->sigq) in lock_timer() ?

I assume you didn't apply any other patches except Thomas's, yes?

Oleg.

