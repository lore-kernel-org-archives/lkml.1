Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZLRJik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZLRJik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 04:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZLRJih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 04:38:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53766 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZLRJig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 04:38:36 -0500
Subject: Re: [PATCH 0/6] Some load-balancer cleanups
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091218065755.GA23808@elte.hu>
References: <20091217185021.684424629@chello.nl>
	 <20091218065755.GA23808@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 10:37:57 +0100
Message-ID: <1261129077.27920.1041.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 07:57 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Since RT has since grown its own load-balancer which is totally independent 
> > from CFS, we can remove some of the left-overs from back when.
> > 
> > Gets rid of the ->load_balance and ->move_one_task sched_class calls and 
> > removed the rq_iterator stuff.
> > 
> > Also carries a lock-break recently found wanted by -rt.
> > 
> > Compile tested with CGROUP/SMP/UP and booted on x86_64-SMP.
> > 
> >  include/linux/sched.h   |    8 -
> >  kernel/sched.c          | 1945 ++---------------------------------------------
> >  kernel/sched_fair.c     | 1778 +++++++++++++++++++++++++++++++++++++++++--
> >  kernel/sched_idletask.c |   21 -
> >  kernel/sched_rt.c       |   20 -
> >  5 files changed, 1805 insertions(+), 1967 deletions(-)
> 
> Nice cleanups! I think we want to delay its application to the scheduler tree 
> for a week or two, to not interact with any urgent fixes for the .33 code.

Sure, I'll keep them around until then.

