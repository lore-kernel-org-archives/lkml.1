Return-Path: <linux-kernel-owner+w=401wt.eu-S1030316AbXCVJef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316AbXCVJef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 05:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030321AbXCVJef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 05:34:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:37214 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030316AbXCVJee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 05:34:34 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+0Vkcpp2+0wmEzKJ+S/434TM6B9XDow6glhRVUx5
	1tEJ2R3p2EiAaT
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Willy Tarreau <w@1wt.eu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070322091824.GD15328@elte.hu>
References: <45FEB54A.3040602@rtr.ca>
	 <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca>
	 <1174322580.30876.72.camel@frg-rhel40-em64t-04>
	 <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
	 <20070320061152.GW943@1wt.eu> <1174377787.9756.21.camel@Homer.simpson.net>
	 <1174489064.5379.42.camel@Homer.simpson.net>
	 <1174492966.16411.1.camel@twins>
	 <1174547256.7414.129.camel@Homer.simpson.net>
	 <20070322091824.GD15328@elte.hu>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 10:34:24 +0100
Message-Id: <1174556064.6748.5.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 10:18 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > Actually, the numbers are an interesting curiosity point, but not as 
> > interesting as the fact that the deadline mechanism isn't kicking in.
> 
> it's not just the scheduling accounting being off, RSDL also seems to be 
> accessing stale data here:
> 
> > >From pull_task():
> > 	/*
> > 	 * If this task has already been running on src_rq this priority
> > 	 * cycle, make the new runqueue think it has been on its cycle
> > 	 */
> > 	if (p->rotation == src_rq->prio_rotation)
> > 		p->rotation = this_rq->prio_rotation;
> > 
> > The intent here is clearly that this task continue on the new cpu as
> > if nothing has happened.  However, when the task was dequeued,
> > p->array was left as it was, points to the last place it was queued.
> > Stale data.
> 
> it might point to a hot-unplugged CPU's runqueue as well. Which might 
> work accidentally, but we want this fixed nevertheless.

Erk!  I mentioned to Con offline that I've seen RSDL bring up only one
of my two (halves of a) penguins a couple three times out of a zillion
boots.  Maybe that's why?

	-Mike

