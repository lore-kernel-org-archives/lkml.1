Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbXD2K2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbXD2K2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbXD2K2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:28:48 -0400
Received: from www.osadl.org ([213.239.205.134]:41496 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755107AbXD2K2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:28:47 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@elte.hu>, Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <20070429071627.GC23638@1wt.eu>
References: <20070425214704.GA32572@elte.hu>
	 <1177596399.14496.1.camel@localhost>
	 <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost>
	 <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu>
	 <20070429065900.GB32281@elte.hu>  <20070429071627.GC23638@1wt.eu>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 12:30:54 +0200
Message-Id: <1177842654.5791.85.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy,

On Sun, 2007-04-29 at 09:16 +0200, Willy Tarreau wrote:
> In fact, what I'd like to see in 2.6.22 is something better for everybody
> and with *no* regression, even if it's not perfect. I had the feeling
> that SD matched that goal right now, except for Mike who has not tested
> recent versions. Don't get me wrong, I still think that CFS is a more
> interesting long-term target. But it may require more time to satisfy
> everyone. At least with one of them in 2.6.22, we won't waste time
> comparing to current mainline.

Oh no, we really do _NOT_ want to throw SD or anything else at mainline
in a hurry just for not wasting time on comparing to the current
scheduler.

I agree that CFS is the more interesting target and I prefer to push the
more interesting one even if it takes a release cycle longer. The main
reason for me is the design of CFS. Even if it is not really modular
right now, it is not rocket science to make it fully modular.

Looking at the areas where people work on, e.g. containers, resource
management, cpu isolation, fully tickless systems ...., we really need
to go into that direction, when we want to avoid permanent tinkering in
the core scheduler code for the next five years.

As a sidenote: I really wonder if anybody noticed yet, that the whole
CFS / SD comparison is so ridiculous, that it is not even funny anymore.
CFS modifies the scheduler and nothing else, SD fiddles all over the
kernel in interesting ways. 

This is worse than apples and oranges, it's more like apples and
screwdrivers. 

Can we please stop this useless pissing contest and sit down and get a
modular design into mainline, which allows folks to work and integrate
their "workload X perfect scheduler" and gives us the flexibility to
adjust to the needs of upcoming functionality.

	tglx


